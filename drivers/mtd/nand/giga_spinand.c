/*
 * MTD SPI driver for GIGA SPI NAND flash
 *
 * Author: Rongzhen Zhu, rzzhu@gigadevice.com
 *
 * Copyright (c) 2014, Giga Inc.
 *
 * Derived from drivers/mtd/devices/m25p80.c
 *
 * This code is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#include <common.h>
#include <dm.h>
#include <nand.h>
#include <linux/mtd/mtd.h>
#include <linux/mtd/nand_ecc.h>
#include <linux/mtd/nand.h>
#include <linux/mtd/partitions.h>
#include <spi.h>
#include <linux/types.h>
#include <malloc.h>
#include <asm/errno.h>
#include <asm/io.h>
#include <asm/arch/clock.h>
#include <amlogic/spifc.h>

#undef DEBUG
#undef pr_info
#undef pr_warn
#undef pr_err

#define pr_info	printf
#define pr_warn	printf
#define pr_err	printf
#define spinand_dbg printf

#define DUMMY_BYTE 0xab

/* Flash opcodes. */
#define SPINAND_CMD_WREN            0x06    /* Write enable */
#define SPINAND_CMD_WRDI            0x04    /* Write disable */
#define SPINAND_CMD_GETFEA          0x0F    /* Get feature */
#define SPINAND_CMD_SETFEA          0x1F    /* Set feature */
#define SPINAND_CMD_READ            0x13    /* read data to cache */
#define SPINAND_CMD_NORM_READ       0x03    /* Read data bytes (low frequency) */
#define SPINAND_CMD_FAST_READ       0x0B    /* Read data bytes (high frequency) */
#define SPINAND_CMD_DUAL_READ       0x3B    /* Read data bytes (x2) */
#define SPINAND_CMD_QUAD_READ       0x6B    /* Read data bytes (x4) */
#define SPINAND_CMD_PLOAD           0x02    /* Program load */
#define SPINAND_CMD_QUAD_PLOAD      0x32    /* Program load (x4) */
#define SPINAND_CMD_PROG            0x10    /* Program execute */
#define SPINAND_CMD_ERASE           0xD8    /* Block erase */
#define SPINAND_CMD_RDID            0x9F    /* Read JEDEC ID */
#define SPINAND_CMD_RESET           0xFF    /* reset nand flash */

/* Flash Protection register */
#define SPINAND_PROTEC_REG          0xA0
#define SPINAND_PROTEC_BRWD         0x80
#define SPINAND_PROTEC_BP2          0x20
#define SPINAND_PROTEC_BP1          0x10
#define SPINAND_PROTEC_BP0          0x08
#define SPINAND_PROTEC_INV          0x04
#define SPINAND_PROTEC_CMP          0x02

/* Flash feature register */
#define SPINAND_FEATURE_REG         0xB0
#define SPINAND_FEATURE_OTPPRT      0x80
#define SPINAND_FEATURE_OPTEN       0x40
#define SPINAND_FEATURE_ECC_EN      0x10
#define SPINAND_FEATURE_QE          0x01

/* Flash status register. */
#define SPINAND_STATUS_REG          0xC0
#define SPINAND_STATUS_BUSY         0x1
#define SPINAND_STATUS_WREN         0x2
#define SPINAND_STATUS_EFAIL        0x4
#define SPINAND_STATUS_PFAIL        0x8
#define SPINAND_STATUS_ECCMASK      0x30
#define SPINAND_STATUS_ECC(x)       (x << 4)
#define SPINAND_STATUS_ECC0         0x0
#define SPINAND_STATUS_ECC1         0x1
#define SPINAND_STATUS_ECC2         0x2
#define SPINAND_STATUS_ECC3         0x3

#define SPINAND_VERC_STATUS_ECCMASK 0x70
#define SPINAND_VERC_STATUS_ERR     0x7

/* Define max times to check status register before we give up. */
#define MAX_CMD_SIZE                8
#define SPINAND_SUBFEATURE_LEN      1

#define MAX_READY_WAIT_JIFFIES      (40 * HZ)
#define NOTALIGNED(x)               ((x & (chip->subpagesize - 1)) != 0)

#define OOB1_ECCWRITE_SECTION       0xC
#define OOB2_ECCWRITE_SECTION       0x1C
#define OOB3_ECCWRITE_SECTION       0x2C
#define OOB4_OOB1_SECTION           0x30
#define OOB4_OOB2_SECTION           0x34
#define OOB4_OOB3_SECTION           0x38

#define OOB_REMOVESIZE              4
#define OOB_SECTION_SIZE            16

#define MANUFACTURE_ID              0xC8
#define DEVICE_ID_A_1G_3V           0xF1
#define DEVICE_ID_A_2G_3V           0xF2
#define DEVICE_ID_A_4G_3V           0xF4
#define DEVICE_ID_A_1G_1V           0xE1
#define DEVICE_ID_A_2G_1V           0xE2
#define DEVICE_ID_A_4G_1V           0xE4
#define DEVICE_ID_B_1G_3V           0xD1
#define DEVICE_ID_B_2G_3V           0xD2
#define DEVICE_ID_B_4G_3V           0xD4
#define DEVICE_ID_B_1G_1V           0xC1
#define DEVICE_ID_B_2G_1V           0xC2
#define DEVICE_ID_B_4G_1V           0xC4
#define DEVICE_ID_C_1G_3V           0xB1
#define DEVICE_ID_C_2G_3V           0xB2
#define DEVICE_ID_C_4G_3V           0xB4
#define DEVICE_ID_C_1G_1V           0xA1
#define DEVICE_ID_C_2G_1V           0xA2
#define DEVICE_ID_C_4G_1V           0xA4

#define GIGA_SPINAND_CHIP_VER_A     0x0
#define GIGA_SPINAND_CHIP_VER_B     0x1
#define GIGA_SPINAND_CHIP_VER_B_LP  0x2
#define GIGA_SPINAND_CHIP_VER_C     0x3

/*
 * we should put the spinand device in nand_info[x],
 * and use command 'nand device x' to set spinand as
 * current device before use nand command.
 */
#define SPINAND_INFO_ID 0

struct spinand_platdata {
	unsigned int max_hz;
	unsigned int mode;
	unsigned int cs;
};

struct spinand_info {
  struct nand_hw_control    controller;
  struct mtd_info           mtd;
  struct nand_chip          chip;
#ifndef __UBOOT__
  struct spi_device         *pdev;
#else
  struct spi_slave         *pdev;
#endif
  uint8_t                   cmd[MAX_CMD_SIZE];
  uint8_t                   read_cmd;
  uint8_t                   pload_cmd;
  uint8_t                   chip_ver;
  uint16_t                  cmd_len;
  uint16_t                  oob_required;
  uint32_t                  status;
};

#ifdef __UBOOT__
static inline int
spi_write(struct spi_slave *spi, const void *buf, size_t len)
{
	return spi_xfer(spi, len<<3, buf, NULL,
			SPI_XFER_BEGIN | SPI_XFER_END);
}

static inline int
spi_write_then_read(struct spi_slave *spi,
		const void *txbuf, unsigned n_tx,
		void *rxbuf, unsigned n_rx)
{
	spi_xfer(spi, n_tx<<3, txbuf, NULL, SPI_XFER_BEGIN);
	return spi_xfer(spi, n_rx<<3, NULL, rxbuf, SPI_XFER_END);
}
#endif /* __UBOOT__ */

static const struct mtd_partition spinand_partitions[] = {
	[0] = {
		.name = "spinand1",
		.offset = 0x0,
		.size = 0x40000, //256K
	},
	[1] = {
		.name = "spinand2",
		.offset = 0x40000,
		.size = 0x200000, //2M
	},
};

/* Define default oob placement schemes for large and small page devices */
static struct nand_ecclayout nand_oob_8 = {
  .eccbytes = 3,
  .eccpos = {0, 1, 2},
  .oobfree = {
    {.offset = 3,
     .length = 2},
    {.offset = 6,
     .length = 2}
    }
};

static struct nand_ecclayout nand_oob_16 = {
  .eccbytes = 6,
  .eccpos = {0, 1, 2, 3, 6, 7},
  .oobfree = {
    {.offset = 8,
     .length = 8}
    }
};

static struct nand_ecclayout nand_oob_64 = {
  .eccbytes = 24,
  .eccpos = {
       40, 41, 42, 43, 44, 45, 46, 47,
       48, 49, 50, 51, 52, 53, 54, 55,
       56, 57, 58, 59, 60, 61, 62, 63},
  .oobfree = {
    {.offset = 2,
     .length = 38}
    }
};

static struct nand_ecclayout nand_oob_128 = {
  .eccbytes = 48,
  .eccpos = {
       80, 81, 82, 83, 84, 85, 86, 87,
       88, 89, 90, 91, 92, 93, 94, 95,
       96, 97, 98, 99, 100, 101, 102, 103,
       104, 105, 106, 107, 108, 109, 110, 111,
       112, 113, 114, 115, 116, 117, 118, 119,
       120, 121, 122, 123, 124, 125, 126, 127},
  .oobfree = {
    {.offset = 2,
     .length = 78}
  }
};

static int spinand_get_feature(struct mtd_info *mtd, struct nand_chip *chip,
                              int addr, uint8_t *subfeature_param);
static int spinand_set_feature(struct mtd_info *mtd, struct nand_chip *chip,
                              int addr, uint8_t *subfeature_param);
static int spinand_set_qeb(struct mtd_info *mtd, struct nand_chip *chip);

static inline struct spinand_info *mtd_to_spinand(struct mtd_info *mtd)
{
#ifndef __UBOOT__
  return container_of(mtd, struct spinand_info, mtd);
#else
	/* see nand_info in spinand_probe() */
	struct nand_chip *chip = mtd->priv;
	return container_of(chip, struct spinand_info, chip);
#endif
}

static int check_offs_len(struct mtd_info *mtd, loff_t offs, uint64_t len)
{
  struct nand_chip *chip = mtd->priv;
  int ret = 0;

  /* Start address must align on block boundary */
  if (offs & ((1 << chip->phys_erase_shift) - 1)) {
    pr_err("%s: unaligned address\n", __func__);
    ret = -EINVAL;
  }

  /* Length must align on block boundary */
  if (len & ((1 << chip->phys_erase_shift) - 1)) {
    pr_err("%s: length not block aligned\n", __func__);
    ret = -EINVAL;
  }

  return ret;
}

static uint8_t *transfer_oob(struct nand_chip *chip, uint8_t *oob,  struct mtd_oob_ops *ops, size_t len)
{
  switch (ops->mode) {

  case MTD_OPS_PLACE_OOB:
  case MTD_OPS_RAW:
    memcpy(oob, chip->oob_poi + ops->ooboffs, len);
    return oob + len;

  case MTD_OPS_AUTO_OOB: {
    struct nand_oobfree *free = chip->ecc.layout->oobfree;
    uint32_t boffs = 0, roffs = ops->ooboffs;
    size_t bytes = 0;

    for (; free->length && len; free++, len -= bytes) {
      /* Read request not from offset 0? */
      if (unlikely(roffs)) {
        if (roffs >= free->length) {
          roffs -= free->length;
          continue;
        }
        boffs = free->offset + roffs;
        bytes = min_t(size_t, len,
                (free->length - roffs));
        roffs = 0;
      } else {
        bytes = min_t(size_t, len, free->length);
        boffs = free->offset;
      }
      memcpy(oob, chip->oob_poi + boffs, bytes);
      oob += bytes;
    }
    return oob;
  }
  default:
    BUG();
  }
  return NULL;
}

static void spinand_cmdfunc(struct mtd_info *mtd, unsigned command, int column, int page_addr)
{
    struct spinand_info *info = mtd_to_spinand(mtd);

    memset(info->cmd, 0, MAX_CMD_SIZE);
    info->cmd[0] = command;
    switch (info->cmd[0]) {
    case SPINAND_CMD_RESET:
    case SPINAND_CMD_WREN:
    case SPINAND_CMD_WRDI:
        info->cmd_len = 1;
        spi_write(info->pdev, info->cmd, info->cmd_len);
        break;

    case SPINAND_CMD_RDID:
        info->cmd[1] = column;
        info->cmd_len = 2;
        break;
    case SPINAND_CMD_GETFEA:
        info->cmd[1] = page_addr;
        info->cmd_len = 2;
        break;

    case SPINAND_CMD_SETFEA:
        info->cmd[1] = page_addr;
        info->cmd[2] = column;
        info->cmd_len = 3;
        break;

    case SPINAND_CMD_READ:
    case SPINAND_CMD_PROG:
    case SPINAND_CMD_ERASE:
        info->cmd[1] = (u8)(page_addr >> 16);
        info->cmd[2] = (u8)(page_addr >> 8);
        info->cmd[3] = (u8)(page_addr);
        info->cmd_len = 4;
        spi_write(info->pdev, info->cmd, info->cmd_len);
        break;

    case SPINAND_CMD_PLOAD:
    case SPINAND_CMD_QUAD_PLOAD:
        info->cmd[1] = (u8)(column >> 8);
        info->cmd[2] = (u8)(column);
        info->cmd_len = 3;
        break;
    case SPINAND_CMD_NORM_READ:
    case SPINAND_CMD_FAST_READ:
    case SPINAND_CMD_DUAL_READ:
    case SPINAND_CMD_QUAD_READ:
        if (info->chip_ver != GIGA_SPINAND_CHIP_VER_C) {
          info->cmd[1] = (u8)(column >> 8);
          info->cmd[2] = (u8)(column);
          info->cmd_len = 4;
          }
        else{
          info->cmd[2] = (u8)(column >> 8);
          info->cmd[3] = (u8)(column);
          info->cmd_len = 4;
        }
        break;
    default:
        break;
    }
}

static int spinand_waitfunc(struct mtd_info *mtd, struct nand_chip *chip)
{

  int status, state = chip->state;
  unsigned long timeo = (state == FL_ERASING ? 400 : 30);

  /*
   * Apply this short delay always to ensure that we do wait tWB in any
   * case on any machine.
   */
  ndelay(100);

  chip->cmdfunc(mtd, SPINAND_CMD_GETFEA, -1, 0xC0);
#ifndef __UBOOT__
  timeo = jiffies + msecs_to_jiffies(timeo);
  while (time_before(jiffies, timeo)) {
#else
  timeo <<= 10;
  while (timeo--) {
#endif
      if (((status = chip->read_byte(mtd)) & SPINAND_STATUS_BUSY) == 0x0)
          break;

      cond_resched();
  }

  status = (int)chip->read_byte(mtd);

  /* This_can_happen if_in case_of timeout or_buggy_dev_ready */
  WARN_ON(status & SPINAND_STATUS_BUSY);
  return status;
}

static int spinand_get_device(struct mtd_info *mtd, int new_state)
{
  struct nand_chip *chip = mtd->priv;
#ifndef __UBOOT__
  spinlock_t *lock = &chip->controller->lock;
  wait_queue_head_t *wq = &chip->controller->wq;
  DECLARE_WAITQUEUE(wait, current);
retry:
  spin_lock(lock);

  /* Hardware controller shared among independent devices */
  if (!chip->controller->active)
    chip->controller->active = chip;

  if (chip->controller->active == chip && chip->state == FL_READY) {
    chip->state = new_state;
    spin_unlock(lock);
    return 0;
  }
  if (new_state == FL_PM_SUSPENDED) {
    if (chip->controller->active->state == FL_PM_SUSPENDED) {
      chip->state = FL_PM_SUSPENDED;
      spin_unlock(lock);
      return 0;
    }
  }
  set_current_state(TASK_UNINTERRUPTIBLE);
  add_wait_queue(wq, &wait);
  spin_unlock(lock);
  schedule();
  remove_wait_queue(wq, &wait);
  goto retry;
#else
	if (!chip->controller->active)
		chip->controller->active = chip;
	if (chip->controller->active == chip && chip->state == FL_READY)
		chip->state = new_state;
	return 0;
#endif
}

static void spinand_release_device(struct mtd_info *mtd)
{
  struct nand_chip *chip = mtd->priv;
#ifndef __UBOOT__
  /* Release the controller and the chip */
  spin_lock(&chip->controller->lock);
  chip->controller->active = NULL;
  chip->state = FL_READY;
  wake_up(&chip->controller->wq);
  spin_unlock(&chip->controller->lock);
#else
  chip->state = FL_READY;
#endif
}

static void reset_spinand_device(struct mtd_info *mtd)
{
    struct nand_chip *chip = mtd->priv;

    chip->cmdfunc(mtd, SPINAND_CMD_RESET, -1, -1);
    chip->waitfunc(mtd, chip);
}

static uint8_t *fill_oob(struct mtd_info *mtd, uint8_t *oob,
        size_t len, struct mtd_oob_ops *ops)
{
  struct nand_chip *chip = mtd->priv;

  /*
   * Initialise to all 0xFF, to avoid the possibility of left over OOB
   * data from a previous OOB read.
   */
  memset(chip->oob_poi, 0xff, mtd->oobsize);

  switch (ops->mode) {
  case MTD_OPS_PLACE_OOB:
  case MTD_OPS_RAW:
    memcpy(chip->oob_poi + ops->ooboffs, oob, len);

    return oob + len;

  case MTD_OPS_AUTO_OOB: {
    struct nand_oobfree *free = chip->ecc.layout->oobfree;
    uint32_t boffs = 0, woffs = ops->ooboffs;
    size_t bytes = 0;

    for (; free->length && len; free++, len -= bytes) {
      /* Write request not from offset 0? */
      if (unlikely(woffs)) {
        if (woffs >= free->length) {
          woffs -= free->length;
          continue;
        }
        boffs = free->offset + woffs;
        bytes = min_t(size_t, len,
        (free->length - woffs));
        woffs = 0;
      } else {
        bytes = min_t(size_t, len, free->length);
        boffs = free->offset;
      }
      memcpy(chip->oob_poi + boffs, oob, bytes);
      oob += bytes;
    }
    return oob;
  }
  default:
    BUG();
  }
  return NULL;
}

static void spinand_erase_block(struct mtd_info *mtd, int page)
{
    struct nand_chip *chip = mtd->priv;
    chip->cmdfunc(mtd, SPINAND_CMD_WREN, -1, -1);
    chip->cmdfunc(mtd, SPINAND_CMD_ERASE, 0, page);
    chip->waitfunc(mtd, chip);
    chip->cmdfunc(mtd, SPINAND_CMD_WRDI, -1, -1);
}

int erase_nand(struct mtd_info *mtd, struct erase_info *instr, int allowbbt)
{
  struct nand_chip *chip = mtd->priv;
  int page;
  int status;
  int pages_per_block;
  int ret;
  uint64_t len;

  if (check_offs_len(mtd, instr->addr, instr->len))
    {
    return -EINVAL;
    }

  /* Grab_the_lock and see if_the device is available */
  spinand_get_device(mtd, FL_ERASING);

  /* Shift to get first page */
  page = (int)(instr->addr >> chip->page_shift);

  /* Calculate pages in each block */
  pages_per_block = 1 << (chip->phys_erase_shift - chip->page_shift);

  /* Loop through the pages */
  len = instr->len;

  instr->state = MTD_ERASING;

  while (len) {
      /*
       * Invalidate the page cache, if we erase the block which
       * contains the current cached page.
       */
      if (page <= chip->pagebuf && chip->pagebuf < (page + pages_per_block))
        {
        chip->pagebuf = -1;
        }

      chip->erase_cmd(mtd, page);
      status = chip->waitfunc(mtd, chip);

      /* See if block erase succeeded */
      if (status & SPINAND_STATUS_EFAIL) {
          pr_err("%s: failed erase, page 0x%08x\n",
                 __func__, page);
      instr->state = MTD_ERASE_FAILED;
      instr->fail_addr = ((loff_t)page << chip->page_shift);
      goto erase_exit;
      }

    /* Increment page address and decrement length */
    len -= (1 << chip->phys_erase_shift);
    page += pages_per_block;
  }

  instr->state = MTD_ERASE_DONE;

erase_exit:
  ret = instr->state == MTD_ERASE_DONE ? 0 : -EIO;
  spinand_release_device(mtd);

  /* Do call back function */
  if (!ret)
    mtd_erase_callback(instr);

  /* Return more or less happy */
  return ret;
}

static int spinand_mtd_erase(struct mtd_info *mtd, struct erase_info *instr)
{
  pr_debug("%s:  from = 0x%08x, len = 0x%04x\n",
          __func__, (uint32_t)instr->addr, (uint32_t)instr->len);

  return erase_nand(mtd, instr, 0);
}

static uint8_t spinand_read_byte(struct mtd_info *mtd)
{
  struct spinand_info *info = mtd_to_spinand(mtd);
  uint8_t val = 0;
  int retval;

  retval = spi_write_then_read(info->pdev, info->cmd, info->cmd_len, &val, 1);

  if (retval < 0)
    {
		spinand_dbg("%s: mtd=%p, info=%p, slave=%p, cmd=%p\n",
		__func__, mtd, info, info->pdev, info->cmd);
    dev_err(&info->pdev->dev, "error %d reading byte\n", (int) retval);
    }

  return val;
}

static void spinand_read_buf(struct mtd_info *mtd, uint8_t *buf, int len)
{
  struct spinand_info *info = mtd_to_spinand(mtd);
  struct nand_chip *chip = mtd->priv;
  uint8_t * oobTemp;
#ifdef __UBOOT__
	info->status = spi_xfer(info->pdev, info->cmd_len<<3,
			info->cmd, NULL, SPI_XFER_BEGIN);
	info->status = spi_xfer(info->pdev, len<<3, NULL, buf, 0);
	info->status = spi_xfer(info->pdev, mtd->oobsize<<3, NULL,
			chip->oob_poi, SPI_XFER_END);
#else
  struct spi_transfer xfers[3];
  struct spi_message msg;

  spi_message_init(&msg);
  memset(xfers, 0, (sizeof xfers));

  xfers[0].tx_buf = info->cmd;
  xfers[0].len = info->cmd_len;
  if (info->read_cmd == SPINAND_CMD_DUAL_READ)
    xfers[0].rx_nbits = SPI_NBITS_DUAL;
  else if (info->read_cmd == SPINAND_CMD_QUAD_READ)
    xfers[0].rx_nbits = SPI_NBITS_QUAD;
  spi_message_add_tail(&xfers[0], &msg);

  if (NULL != buf) {
    xfers[1].rx_buf = buf;
    xfers[1].len = len;
    spi_message_add_tail(&xfers[1], &msg);
  }

  if (info->oob_required) {
      xfers[2].rx_buf = chip->oob_poi;
      xfers[2].len = mtd->oobsize;
      spi_message_add_tail(&xfers[2], &msg);
  }

  info->status = spi_sync(info->pdev, &msg);
#endif
  if (info->oob_required) {
      if (info->chip_ver == GIGA_SPINAND_CHIP_VER_A) {
    memcpy ((chip->oob_poi + OOB1_ECCWRITE_SECTION), (chip->oob_poi + OOB4_OOB1_SECTION), OOB_REMOVESIZE);
    memcpy ((chip->oob_poi + OOB2_ECCWRITE_SECTION), (chip->oob_poi + OOB4_OOB2_SECTION), OOB_REMOVESIZE);
    memcpy ((chip->oob_poi + OOB3_ECCWRITE_SECTION), (chip->oob_poi + OOB4_OOB3_SECTION), OOB_REMOVESIZE);

    oobTemp = (chip->oob_poi + OOB4_OOB1_SECTION);
    memset (oobTemp, 0xff, OOB_SECTION_SIZE);
    }
  }
  info->oob_required = 0;
}

static int spinand_read_page_raw(struct mtd_info *mtd, struct nand_chip *chip,
                                 uint8_t *buf, int oob_required, int page)
{
  struct spinand_info *info = mtd_to_spinand(mtd);

  info->oob_required = oob_required;
  chip->read_buf(mtd, buf, mtd->writesize);

  return info->status;
}

static int spinand_read_page_hwecc(struct mtd_info *mtd, struct nand_chip *chip,
                                  uint8_t *buf, int oob_required, int page)
{
  struct spinand_info *info = mtd_to_spinand(mtd);
  uint8_t get_feature = 0x0;

  info->oob_required = oob_required;
  chip->read_buf(mtd, buf, mtd->writesize);
  spinand_set_feature(mtd, chip, SPINAND_STATUS_REG, &get_feature);
  if (info->chip_ver != GIGA_SPINAND_CHIP_VER_C) {
    if ((get_feature & SPINAND_STATUS_ECCMASK) == (SPINAND_STATUS_ECC(SPINAND_STATUS_ECC2))) {
      mtd->ecc_stats.failed++;
      pr_debug("ecc err for page read\n");
      return -EBADMSG;
    }
  }
  else {
	if ((get_feature & SPINAND_VERC_STATUS_ECCMASK) == (SPINAND_STATUS_ECC(SPINAND_VERC_STATUS_ERR))) {
    mtd->ecc_stats.failed++;
    pr_debug("ecc err for page read\n");
    return -EBADMSG;
    }
  }
  mtd->ecc_stats.corrected++;
  return info->status;
}

static int spinand_do_read_ops(struct mtd_info *mtd, loff_t from, struct mtd_oob_ops *ops)
{
  int page, realpage, col, bytes, aligned, oob_required;
  struct nand_chip *chip = mtd->priv;
  struct mtd_ecc_stats stats;
  int ret = 0;
  uint32_t readlen = ops->len;
  uint32_t oobreadlen = ops->ooblen;
  uint32_t max_oobsize = ops->mode == MTD_OPS_AUTO_OOB ? mtd->oobavail  : mtd->oobsize;

  uint8_t *bufpoi, *oob, *buf;
  unsigned int max_bitflips = 0;
  stats = mtd->ecc_stats;

  realpage = (int)(from >> chip->page_shift);
  page = realpage & chip->pagemask;

  col = (int)(from & (mtd->writesize - 1));

  buf = ops->datbuf;
  oob = ops->oobbuf;
  oob_required = oob ? 1 : 0;

  while (1) {
      bytes = min(mtd->writesize - col, readlen);
      aligned = (bytes == mtd->writesize);
      max_bitflips = 0;

      /* Is the current page in the buffer? */
      if (realpage != chip->pagebuf || oob) {
          bufpoi = aligned ? buf : chip->buffers->databuf;

      chip->cmdfunc(mtd, SPINAND_CMD_READ, -1, page);
      chip->waitfunc(mtd, chip);

      /*
       * Now read the page into the buffer.  Absent an error,
       * the read methods return max bitflips per ecc step.
       */
      struct spinand_info *info = mtd_to_spinand(mtd);
//      if (info->read_cmd == SPINAND_CMD_QUAD_READ)
//        spinand_set_qeb(mtd, chip);
      chip->cmdfunc(mtd, info->read_cmd, 0, -1);
      if (unlikely(ops->mode == MTD_OPS_RAW))
          ret = chip->ecc.read_page_raw(mtd, chip, bufpoi,
                                        oob_required, page);
      else
          ret = chip->ecc.read_page(mtd, chip, bufpoi,
                                    oob_required, page);

      if (ret < 0) {
        if (!aligned) {
          /* Invalidate page cache */
          chip->pagebuf = -1;
          break;
        }
      }
      max_bitflips = max_t(unsigned int, max_bitflips, ret);

      /* Transfer not aligned data */
      if (!aligned) {
        if (!oob && !(mtd->ecc_stats.failed - stats.failed) &&
            (ops->mode != MTD_OPS_RAW)) {
          chip->pagebuf = realpage;
          chip->pagebuf_bitflips = ret;
        } else {
          /* Invalidate page cache */
          chip->pagebuf = -1;
        }
        memcpy(buf, chip->buffers->databuf + col, bytes);
      }

      buf += bytes;

      if (unlikely(oob)) {
        int toread = min(oobreadlen, max_oobsize);

        if (toread) {
          oob = transfer_oob(chip, oob, ops, toread);
          oobreadlen -= toread;
        }
      }

    } else {
      memcpy(buf, chip->buffers->databuf + col, bytes);
      buf += bytes;
      max_bitflips = max_t(unsigned int, max_bitflips,
      chip->pagebuf_bitflips);
    }

    readlen -= bytes;

    if (!readlen)
      break;

    /* For subsequent reads align to page boundary */
    col = 0;
    /* Increment page address */
    realpage++;

    page = realpage & chip->pagemask;
  }

  ops->retlen = ops->len - (size_t) readlen;
  if (oob)
    ops->oobretlen = ops->ooblen - oobreadlen;

  if (ret < 0)
    return ret;

  if (mtd->ecc_stats.failed - stats.failed)
    return -EBADMSG;

  return max_bitflips;
}

static int spinand_mtd_read(struct mtd_info *mtd, loff_t from, size_t len,
                                  size_t *retlen, uint8_t *buf)
{
  struct mtd_oob_ops ops;
  int ret;

  pr_debug("%s:  from = 0x%08x, len = 0x%04x\n",
           __func__, (uint32_t)from, (uint32_t)len);

  spinand_get_device(mtd, FL_READING);
  memset(&ops, 0, sizeof(struct mtd_oob_ops));
  ops.len = len;
  ops.datbuf = buf;
  ops.mode = MTD_OPS_PLACE_OOB;
  ret = spinand_do_read_ops(mtd, from, &ops);
  *retlen = ops.retlen;
  spinand_release_device(mtd);
  return ret;
}

static int spinand_read_oob_std(struct mtd_info *mtd, struct nand_chip *chip, int page)
{
  struct spinand_info *info = mtd_to_spinand(mtd);

  info->oob_required = 1;
  chip->read_buf(mtd, NULL, 0);
  return 0;
}

static int spinand_do_read_oob(struct mtd_info *mtd, loff_t from, struct mtd_oob_ops *ops)
{
  int page, realpage;
  struct nand_chip *chip = mtd->priv;
  struct mtd_ecc_stats stats;
  int readlen = ops->ooblen;
  int len;
  uint8_t *buf = ops->oobbuf;
  int ret = 0;

  stats = mtd->ecc_stats;

  if (ops->mode == MTD_OPS_AUTO_OOB)
    len = chip->ecc.layout->oobavail;
  else
    len = mtd->oobsize;

  if (unlikely(ops->ooboffs >= len)) {
    pr_err("%s: attempt to start read outside oob\n",
           __func__);
    return -EINVAL;
  }

  /* Do not allow reads past end of device */
  if (unlikely(from >= mtd->size ||
      ops->ooboffs + readlen > ((mtd->size >> chip->page_shift) -
      (from >> chip->page_shift)) * len)) {
    pr_err("%s: attempt to read beyond end of device\n",
            __func__);
    return -EINVAL;
  }

  /* Shift to get page */
  realpage = (int)(from >> chip->page_shift);
  page = realpage & chip->pagemask;

  while (1) {
    chip->cmdfunc(mtd, SPINAND_CMD_READ, -1, page);
    chip->waitfunc(mtd, chip);
    struct spinand_info *info = mtd_to_spinand(mtd);
//    if (info->read_cmd == SPINAND_CMD_QUAD_READ)
//      spinand_set_qeb(mtd, chip);
    chip->cmdfunc(mtd, info->read_cmd, mtd->writesize, -1);

    if (ops->mode == MTD_OPS_RAW)
      ret = chip->ecc.read_oob_raw(mtd, chip, page);
    else
      ret = chip->ecc.read_oob(mtd, chip, page);

    if (ret < 0)
      break;

    len = min(len, readlen);
    buf = transfer_oob(chip, buf, ops, len);

    readlen -= len;
    if (!readlen)
      break;

    /* Increment page address */
    realpage++;

    page = realpage & chip->pagemask;
    /* Check, if we cross a chip boundary */
  }

  ops->oobretlen = ops->ooblen - readlen;

  if (ret < 0)
    return ret;

  if (mtd->ecc_stats.failed - stats.failed)
    return -EBADMSG;

  return  mtd->ecc_stats.corrected - stats.corrected ? -EUCLEAN : 0;
}

static int spinand_mtd_read_oob(struct mtd_info *mtd, loff_t from,  struct mtd_oob_ops *ops)
{
  int ret = -ENOTSUPP;

   pr_debug("spinand_mtd_read_oob %s: %s, from = 0x%08x, len = 0x%04x, "
            "ooboffs = 0x%04x, ooblen = 0x%02x\n",
             __func__, ops->datbuf ? "DATA" : "NULL",
             (uint32_t)from, (uint32_t)ops->len,
             (uint32_t)ops->ooboffs, (uint32_t)ops->ooblen);

  ops->retlen = 0;

  /* Do not allow reads past end of device */
  if (ops->datbuf && (from + ops->len) > mtd->size) {
    pr_err("%s: attempt to read beyond end of device\n",
            __func__);
    return -EINVAL;
  }

  spinand_get_device(mtd, FL_READING);

  switch (ops->mode) {
  case MTD_OPS_PLACE_OOB:
  case MTD_OPS_AUTO_OOB:
  case MTD_OPS_RAW:
    break;

  default:
    goto out;
  }

  if (NULL == ops->datbuf)
    ret = spinand_do_read_oob(mtd, from, ops);
  else
    ret = spinand_do_read_ops(mtd, from, ops);

    spinand_release_device(mtd);
out:
  return ret;
}

static void spinand_write_buf(struct mtd_info *mtd, const uint8_t *buf, int len)
{
  struct spinand_info *info = mtd_to_spinand(mtd);
  struct nand_chip *chip = mtd->priv;

  if (info->oob_required) {
    if (info->chip_ver == GIGA_SPINAND_CHIP_VER_A) {
      memcpy ((chip->oob_poi + OOB4_OOB1_SECTION),
          (chip->oob_poi + OOB1_ECCWRITE_SECTION), OOB_REMOVESIZE);
      memcpy ((chip->oob_poi + OOB4_OOB2_SECTION),
	        (chip->oob_poi + OOB2_ECCWRITE_SECTION), OOB_REMOVESIZE);
	    memcpy ((chip->oob_poi + OOB4_OOB3_SECTION),
	        (chip->oob_poi + OOB3_ECCWRITE_SECTION), OOB_REMOVESIZE);
    }
  }
#ifdef __UBOOT__
  info->status = spi_xfer(info->pdev, info->cmd_len<<3,
      info->cmd, NULL, SPI_XFER_BEGIN);
  info->status = spi_xfer(info->pdev, len<<3, buf, NULL, 0);
  info->status = spi_xfer(info->pdev, mtd->oobsize<<3,
      chip->oob_poi, NULL, SPI_XFER_END);
#else
  struct spi_transfer xfers[3];
  struct spi_message msg;

  spi_message_init(&msg);
  memset(xfers, 0, (sizeof xfers));

  xfers[0].tx_buf = info->cmd;
  xfers[0].len = info->cmd_len;
  if (info->pload_cmd == SPINAND_CMD_QUAD_PLOAD)
    xfers[0].tx_nbits = SPI_NBITS_QUAD;
  spi_message_add_tail(&xfers[0], &msg);

  if (NULL != buf) {
    xfers[1].tx_buf = buf;
    xfers[1].len = len;
    spi_message_add_tail(&xfers[1], &msg);
  }

  if ( info->oob_required) {
    xfers[2].tx_buf = chip->oob_poi;
    xfers[2].len = mtd->oobsize;
    spi_message_add_tail(&xfers[2], &msg);
  }
  info->status = spi_sync(info->pdev, &msg);
#endif
  info->oob_required = 0;
}

static int spinand_write_page_raw(struct mtd_info *mtd, struct nand_chip *chip,
                                         const uint8_t *buf, int oob_required)
{
  struct spinand_info *info = mtd_to_spinand(mtd);

  info->oob_required = oob_required;
  chip->write_buf(mtd, buf, mtd->writesize);

  return info->status;
}

static int spinand_write_page_hwecc(struct mtd_info *mtd, struct nand_chip *chip,
                                             const uint8_t *buf, int oob_required)
{
  struct spinand_info *info = mtd_to_spinand(mtd);

  info->oob_required = oob_required;
  chip->write_buf(mtd, buf, mtd->writesize);

  return info->status;
}

static int spinand_write_page(struct mtd_info *mtd, struct nand_chip *chip,
                                    uint32_t offset, int data_len, const uint8_t *buf,
                                    int oob_required, int page, int cached, int raw)
{
  int status;
  struct spinand_info *info = mtd_to_spinand(mtd);
//  if (info->pload_cmd == SPINAND_CMD_QUAD_PLOAD)
//    spinand_set_qeb(mtd, chip);
  chip->cmdfunc(mtd, info->pload_cmd, 0x00, -1);

  if (unlikely(raw))
    status = chip->ecc.write_page_raw(mtd, chip, buf, oob_required);
  else
    status = chip->ecc.write_page(mtd, chip, buf, oob_required);

  if (status < 0)
    return status;

  chip->cmdfunc(mtd, SPINAND_CMD_WREN, -1, -1);
  chip->cmdfunc(mtd, SPINAND_CMD_PROG, -1, page);
  status = chip->waitfunc(mtd, chip);
  chip->cmdfunc(mtd, SPINAND_CMD_WRDI, -1, -1);

  /*
   * See if operation failed and additional status checks are
   * available.
   */
  if (status & SPINAND_STATUS_PFAIL) {
    pr_err("%s: error %02x program failed\n",
            __func__, (uint32_t)status);
    return -EIO;
    }
  return 0;
}

static int spinand_do_write_ops(struct mtd_info *mtd, loff_t to, struct mtd_oob_ops *ops)
{
  int realpage, page, column;
  struct nand_chip *chip = mtd->priv;
  uint32_t writelen = ops->len;
  uint32_t oobwritelen = ops->ooblen;
  uint32_t oobmaxlen = ops->mode == MTD_OPS_AUTO_OOB ? mtd->oobavail  : mtd->oobsize;

  uint8_t *oob = ops->oobbuf;
  uint8_t *buf = ops->datbuf;
  int ret;
  int oob_required = oob ? 1 : 0;
  ops->retlen = 0;
  if (!writelen)
    return 0;

  /* Reject writes, which are not page aligned */
  if (NOTALIGNED(to) || NOTALIGNED(ops->len)) {
    pr_notice("%s: attempt to write non page aligned data\n",
               __func__);
    return -EINVAL;
  }

  column = to & (mtd->writesize - 1);
  realpage = (int)(to >> chip->page_shift);
  page = realpage & chip->pagemask;

  /* Invalidate the page cache, when we write to the cached page */
  if (to <= (chip->pagebuf << chip->page_shift) &&
      (chip->pagebuf << chip->page_shift) < (to + ops->len))
    chip->pagebuf = -1;

  /* Don't allow multipage oob writes with offset */
  if (oob && ops->ooboffs && (ops->ooboffs + ops->ooblen > oobmaxlen)) {
    ret = -EINVAL;
    goto err_out;
  }

  while (1) {
    int bytes = mtd->writesize;
    uint8_t *wbuf = buf;

    /* Partial page write? */
    if (unlikely(column || writelen < (mtd->writesize - 1))) {
      bytes = min_t(int, bytes - column, (int) writelen);
      chip->pagebuf = -1;
      memset(chip->buffers->databuf, 0xff, mtd->writesize);
      memcpy(&chip->buffers->databuf[column], buf, bytes);
      wbuf = chip->buffers->databuf;
    }

    if (unlikely(oob)) {
      size_t len = min(oobwritelen, oobmaxlen);
      oob = fill_oob(mtd, oob, len, ops);
      oobwritelen -= len;
    } else {
      /* We still need to erase leftover OOB data */
      memset(chip->oob_poi, 0xff, mtd->oobsize);
    }

    ret = chip->write_page(mtd, chip, column, bytes, wbuf,
                          oob_required, page, 0,
                          (ops->mode == MTD_OPS_RAW));
    if (ret)
      break;

    writelen -= bytes;
    if (!writelen)
      break;

    column = 0;
    buf += bytes;
    realpage++;

    page = realpage & chip->pagemask;
  }

  ops->retlen = ops->len - writelen;
  if (unlikely(oob))
    ops->oobretlen = ops->ooblen - oobwritelen;

err_out:
  return ret;
}

static int spinand_mtd_write(struct mtd_info *mtd, loff_t to, size_t len,
                                  size_t *retlen, const u_char *buf)
{
  struct mtd_oob_ops ops;
  int ret;

  pr_debug("%s: to = 0x%08x, len = 0x%04x\n",
          __func__, (uint32_t)to, (uint32_t)len);

  spinand_get_device(mtd, FL_WRITING);
  memset(&ops, 0, sizeof(struct mtd_oob_ops));
  ops.len = len;
  ops.datbuf = (uint8_t *)buf;
  ops.mode = MTD_OPS_PLACE_OOB;
  ret = spinand_do_write_ops(mtd, to, &ops);
  *retlen = ops.retlen;
  spinand_release_device(mtd);

  return ret;
}

static int spinand_write_oob_raw(struct mtd_info *mtd, struct nand_chip *chip,  int page)
{
  struct spinand_info *info = mtd_to_spinand(mtd);
  int status = 0;
//  if (info->pload_cmd == SPINAND_CMD_QUAD_PLOAD)
//    spinand_set_qeb(mtd, chip);
  chip->cmdfunc(mtd, info->pload_cmd, mtd->writesize, -1);

  info->oob_required = 1;
  chip->write_buf(mtd, NULL, 0);

  chip->cmdfunc(mtd, SPINAND_CMD_WREN, -1, -1);
  chip->cmdfunc(mtd, SPINAND_CMD_PROG, -1, page);
  status = chip->waitfunc(mtd, chip);
  chip->cmdfunc(mtd, SPINAND_CMD_WRDI, -1, -1);

  return status & SPINAND_STATUS_PFAIL ? -EIO : 0;
}

static int spinand_write_oob_std(struct mtd_info *mtd, struct nand_chip *chip,  int page)
{
  struct spinand_info *info = mtd_to_spinand(mtd);
  int status = 0;
//  if (info->pload_cmd == SPINAND_CMD_QUAD_PLOAD)
//    spinand_set_qeb(mtd, chip);
  chip->cmdfunc(mtd, info->pload_cmd, mtd->writesize, -1);

  info->oob_required = 1;
  chip->write_buf(mtd, NULL, 0);

  chip->cmdfunc(mtd, SPINAND_CMD_WREN, -1, -1);
  chip->cmdfunc(mtd, SPINAND_CMD_PROG, -1, page);
  status = chip->waitfunc(mtd, chip);
  chip->cmdfunc(mtd, SPINAND_CMD_WRDI, -1, -1);

  return status & SPINAND_STATUS_PFAIL ? -EIO : 0;
}

static int spinand_do_write_oob(struct mtd_info *mtd, loff_t to,  struct mtd_oob_ops *ops)
{
  int page, status, len;
  struct nand_chip *chip = mtd->priv;

  if (ops->mode == MTD_OPS_AUTO_OOB)
    len = chip->ecc.layout->oobavail;
  else
    len = mtd->oobsize;

  if (unlikely(ops->ooboffs >= len)) {
    pr_err("%s: attempt to start write outside oob\n",
          __func__);
    return -EINVAL;
  }

  /* Do not allow write past end of page */
  if ((ops->ooboffs + ops->ooblen) > len) {
    pr_err("%s: attempt to write past end of page\n",
          __func__);
    return -EINVAL;
  }

  /* Do not allow write past end of device */
  if (unlikely(to >= mtd->size ||
      ops->ooboffs + ops->ooblen >
      ((mtd->size >> chip->page_shift) -
     (to >> chip->page_shift)) * len)) {
    pr_err("%s: attempt to write beyond end of device\n",
          __func__);
    return -EINVAL;
  }

  /* Shift to get page */
  page = (int)(to >> chip->page_shift);

  /* Invalidate the page cache, if we write to the cached page */
  if (page == chip->pagebuf)
    chip->pagebuf = -1;

  fill_oob(mtd, ops->oobbuf, ops->ooblen, ops);

  if (ops->mode == MTD_OPS_RAW)
    status = chip->ecc.write_oob_raw(mtd, chip, page & chip->pagemask);
  else
    status = chip->ecc.write_oob(mtd, chip, page & chip->pagemask);

  if (status)
    return status;

  ops->oobretlen = ops->ooblen;
  return 0;
}

static int spinand_mtd_write_oob(struct mtd_info *mtd, loff_t to,
                                struct mtd_oob_ops *ops)
{
  int ret = -ENOTSUPP;

   pr_debug("%s:  %s, to = 0x%08x, len = 0x%04x, "
            "ooboffs = 0x%04x, ooblen = 0x%02x\n",
             __func__, ops->datbuf ? "DATA" : "NULL",
             (uint32_t)to, (uint32_t)ops->len,
             (uint32_t)ops->ooboffs, (int)ops->ooblen);

  ops->retlen = 0;
  ops->oobretlen = 0;

  /* Do not allow writes past end of device */
  if (ops->datbuf && (to + ops->len) > mtd->size)
    {
    pr_err("%s: attempt to write beyond end of device\n",
            __func__);

    return -EINVAL;
  }

  switch (ops->mode) {
  case MTD_OPS_PLACE_OOB:
  case MTD_OPS_AUTO_OOB:
  case MTD_OPS_RAW:
    break;
  default:
    goto out;
  }

  if (NULL != ops->datbuf) {
    ret = spinand_do_write_ops(mtd, to, ops);
  }
  else
    ret = spinand_do_write_oob(mtd, to, ops);

out:
  return ret;
}

static void spinand_mtd_sync(struct mtd_info *mtd)
{
  pr_debug("%s: called\n",  __func__);

  /* Grab the lock and see if the device is available */
  spinand_get_device(mtd, FL_SYNCING);
  /* Release it and go back */
  spinand_release_device(mtd);
}

static int spinand_block_bad(struct mtd_info *mtd, loff_t offs, int getchip)
{
  struct nand_chip *chip = mtd->priv;
  int page, res = 0, i = 0;
  uint8_t bad;

  if (chip->bbt_options & NAND_BBT_SCANLASTPAGE)
    offs += mtd->erasesize - mtd->writesize;

  page = (int)(offs >> chip->page_shift) & chip->pagemask;

  if (getchip) {
    spinand_get_device(mtd, FL_READING);
  }

  do {
    chip->cmdfunc(mtd, SPINAND_CMD_READ, -1, page);
    chip->waitfunc(mtd, chip);
    struct spinand_info *info = mtd_to_spinand(mtd);
//    if (info->read_cmd == SPINAND_CMD_QUAD_READ)
//      spinand_set_qeb(mtd, chip);
    chip->cmdfunc(mtd, info->read_cmd,
                  mtd->writesize + chip->badblockpos, -1);
    bad = chip->read_byte(mtd);

    if (likely(chip->badblockbits == 8))
      res = bad != 0xFF;

    offs += mtd->writesize;
    page = (int)(offs >> chip->page_shift) & chip->pagemask;
    i++;
  } while (!res && i < 2 && (chip->bbt_options & NAND_BBT_SCAN2NDPAGE));

    if (getchip) {
      spinand_release_device(mtd);
    }

  return res;
}

static int block_checkbad(struct mtd_info *mtd, loff_t offs,
        int getchip, int allowbbt)
{
  struct nand_chip *chip = mtd->priv;

  if (!chip->bbt)
    return chip->block_bad(mtd, offs, getchip);

  /* Return info from the table */
  return nand_isbad_bbt(mtd, offs, allowbbt);
}

static int spinand_mtd_block_isbad(struct mtd_info *mtd, loff_t offs)
{
  int res;

  res = block_checkbad(mtd, offs, 1, 0);

  pr_debug("%s: offs = 0x%08x, res = %x\t%s\n",
            __func__, (uint32_t)offs, res, res? "BAD" : "GOOD");

  return res;
}

static int spinand_block_markbad(struct mtd_info *mtd, loff_t offs)
{
  struct nand_chip *chip = mtd->priv;
  uint8_t buf[2] = { 0, 0 };
  int block, res, ret = 0, i = 0;
  int write_oob = !(chip->bbt_options & NAND_BBT_NO_OOB_BBM);

  if (write_oob) {
    struct erase_info einfo;

    /* Attempt erase before marking OOB */
    memset(&einfo, 0, sizeof(einfo));
    einfo.mtd = mtd;
    einfo.addr = offs;
    einfo.len = 1 << chip->phys_erase_shift;
    erase_nand(mtd, &einfo, 0);
  }

  /* Get block number */
  block = (int)(offs >> chip->bbt_erase_shift);
  /* Mark block bad in memory-based BBT */
  if (chip->bbt)
    chip->bbt[block >> 2] |= 0x01 << ((block & 0x03) << 1);

  /* Write bad block marker to OOB */
  if (write_oob) {
    struct mtd_oob_ops ops;
    loff_t wr_offs = offs;

    spinand_get_device(mtd, FL_WRITING);

    ops.datbuf = NULL;
    ops.oobbuf = buf;
    ops.ooboffs = chip->badblockpos;
    ops.len = ops.ooblen = 1;
    ops.mode = MTD_OPS_PLACE_OOB;

    /* Write to first/last page(s) if necessary */
    if (chip->bbt_options & NAND_BBT_SCANLASTPAGE)
      wr_offs += mtd->erasesize - mtd->writesize;
    do {
      res = spinand_do_write_oob(mtd, wr_offs, &ops);
      if (!ret)
        ret = res;

      i++;
      wr_offs += mtd->writesize;
    } while ((chip->bbt_options & NAND_BBT_SCAN2NDPAGE) && i < 2);

    spinand_release_device(mtd);
  }

  /* Update flash-based bad block table */
  if (chip->bbt_options & NAND_BBT_USE_FLASH) {
    res = nand_markbad_bbt(mtd, offs);
    if (!ret)
      ret = res;
  }

  if (!ret)
    mtd->ecc_stats.badblocks++;

  return ret;
}

static int spinand_mtd_block_markbad(struct mtd_info *mtd, loff_t offs)
{
  struct nand_chip *chip = mtd->priv;
  int ret;

  pr_debug("%s: offs = 0x%08x\n",
          __func__, (uint32_t)offs);

  ret = spinand_mtd_block_isbad(mtd, offs);
  if (ret) {
    /* If it was bad already, return success and do nothing */
    if (ret > 0)
      return 0;
    return ret;
  }

  return chip->block_markbad(mtd, offs);
}

static int spinand_get_feature(struct mtd_info *mtd, struct nand_chip *chip,
                              int addr, uint8_t *subfeature_param)
{
  struct spinand_info *info = mtd_to_spinand(mtd);

  /* clear the sub feature parameters */
  memset(subfeature_param, 0, SPINAND_SUBFEATURE_LEN);

  chip->cmdfunc(mtd, SPINAND_CMD_GETFEA, -1, addr);

  spi_write_then_read(info->pdev, info->cmd, info->cmd_len,
                      subfeature_param, SPINAND_SUBFEATURE_LEN);
  return 0;
}

static int spinand_set_feature(struct mtd_info *mtd, struct nand_chip *chip,
                                int addr, uint8_t *subfeature_param)
{
  struct spinand_info *info = mtd_to_spinand(mtd);
  int status;
  uint8_t val = *subfeature_param;

  chip->cmdfunc(mtd, SPINAND_CMD_SETFEA, val, addr);
  spi_write(info->pdev, info->cmd, info->cmd_len);
  status = chip->waitfunc(mtd, chip);
  if (status & NAND_STATUS_FAIL)
    return -EIO;
  return 0;
}

static int spinand_set_qeb(struct mtd_info *mtd, struct nand_chip *chip)
{
  uint8_t feature = 0;
  int ret;

  ret = spinand_get_feature(mtd, chip, SPINAND_FEATURE_REG, &feature);
  if (ret)
    return ret;
  if (feature & SPINAND_FEATURE_QE)
    debug("spiand: QEB is already set\n");
  else {
    feature |= SPINAND_FEATURE_QE;
    ret = spinand_set_feature(mtd, chip, SPINAND_FEATURE_REG, &feature);
  }
  return ret;
}

static void spinand_set_defaults(struct nand_chip *chip)
{
  /* check for proper chip_delay setup, set 20us if not */
  if (!chip->chip_delay)
    chip->chip_delay = 50;

  /* check, if a user supplied command function given */
  if (chip->cmdfunc == NULL)
    chip->cmdfunc = spinand_cmdfunc;
  /* check, if a user supplied wait function given */
  if (chip->waitfunc == NULL)
    chip->waitfunc = spinand_waitfunc;

  if (!chip->read_byte)
    chip->read_byte = spinand_read_byte;

  if (!chip->block_bad)
        chip->block_bad = spinand_block_bad;
  if (!chip->block_markbad)
    chip->block_markbad = spinand_block_markbad;
  if (!chip->write_buf)
    chip->write_buf = spinand_write_buf;
  if (!chip->read_buf)
    chip->read_buf = spinand_read_buf;
  if (!chip->scan_bbt)
    chip->scan_bbt = nand_default_bbt;
}

static struct nand_flash_dev *spinand_get_flash_type(struct mtd_info *mtd,
              struct nand_chip *chip,
              int *maf_id, int *dev_id,
              struct nand_flash_dev *type)
{
  struct spinand_info *info = mtd_to_spinand(mtd);
  uint8_t status = 0x00;
  int maf_idx;
  u8 id_data[8];

  /*
   * Reset the chip, required by some chips (e.g. Micron MT29FxGxxxxx)
   * after power-up.
   */
  reset_spinand_device(mtd);

  spinand_set_feature(mtd, chip, SPINAND_PROTEC_REG, &status);
  spinand_get_feature(mtd, chip, SPINAND_PROTEC_REG, &status);

  status = 0x00;
  spinand_set_feature(mtd, chip, SPINAND_FEATURE_REG, &status);
  spinand_get_feature(mtd, chip, SPINAND_FEATURE_REG, &status);

  /* Send the command for reading device ID */
  chip->cmdfunc(mtd, SPINAND_CMD_RDID, 0x00, -1);
  spi_write_then_read(info->pdev, info->cmd, info->cmd_len, id_data, 2);

  /* Read manufacturer and device IDs */
  *maf_id = id_data[0];
  *dev_id = id_data[1];
  if (*maf_id != MANUFACTURE_ID) {
    id_data[1] = id_data[0];
  }
  switch (id_data[1]) {
  case DEVICE_ID_A_1G_3V:
  case DEVICE_ID_A_2G_3V:
  case DEVICE_ID_A_4G_3V:
  case DEVICE_ID_A_1G_1V:
  case DEVICE_ID_A_2G_1V:
  case DEVICE_ID_A_4G_1V:
    info->chip_ver = GIGA_SPINAND_CHIP_VER_A;
    break;
  case DEVICE_ID_B_1G_1V:
  case DEVICE_ID_B_2G_1V:
  case DEVICE_ID_B_1G_3V:
  case DEVICE_ID_B_2G_3V:
    info->chip_ver = GIGA_SPINAND_CHIP_VER_B;
	break;
  case DEVICE_ID_B_4G_1V:
  case DEVICE_ID_B_4G_3V:
    info->chip_ver = GIGA_SPINAND_CHIP_VER_B_LP;
	break;
  case DEVICE_ID_C_4G_3V:
  case DEVICE_ID_C_4G_1V:
  case DEVICE_ID_C_2G_3V:
  case DEVICE_ID_C_2G_1V:
  case DEVICE_ID_C_1G_3V:
  case DEVICE_ID_C_1G_1V:
    info->chip_ver = GIGA_SPINAND_CHIP_VER_C;
	break;
  default:
    info->chip_ver = GIGA_SPINAND_CHIP_VER_A;
	break;
  }

  if (info->chip_ver == GIGA_SPINAND_CHIP_VER_C) {
		/* Send the command for reading device ID */
		info->cmd[0] = SPINAND_CMD_RDID;
		info->cmd_len = 1;
		spi_write_then_read(info->pdev, info->cmd, info->cmd_len, id_data, 2);
		*maf_id = id_data[0];
		*dev_id = id_data[1];
	}

  if (!type)
    type = nand_flash_ids;

  for (; type->name != NULL; type++) {
      if (!strncmp((const char *)type->id, (const char *)id_data, type->id_len)) {
      mtd->writesize = type->pagesize;
      mtd->erasesize = type->erasesize;
      mtd->oobsize = type->oobsize;
      chip->chipsize = (uint64_t)type->chipsize;
      chip->options |= type->options;
      printf("name=%s, ws=0x%x, es=0x%x, os=0x%x, cs=0x%x\n",
      type->name, mtd->writesize, mtd->erasesize,
      mtd->oobsize, type->chipsize);
      break;
    }
  }

  if (!type->name)
    return ERR_PTR(-ENODEV);

  if (!mtd->name)
    mtd->name = type->name;

  /* Try to identify manufacturer */
  for (maf_idx = 0; nand_manuf_ids[maf_idx].id != 0x0; maf_idx++) {
    if (nand_manuf_ids[maf_idx].id == *maf_id)
      break;
  }

  /* nand_decode_bbm_options(mtd, chip, id_data); */
  chip->badblockpos = NAND_LARGE_BADBLOCK_POS;
  chip->bbt_options |= NAND_BBT_SCAN2NDPAGE;

  /* Calculate the address shift from the page size */
  chip->page_shift = ffs(mtd->writesize) - 1;
  /* Convert chipsize to number of pages per chip -1 */
  chip->pagemask = (chip->chipsize >> chip->page_shift) - 1;

  chip->bbt_erase_shift = chip->phys_erase_shift = ffs(mtd->erasesize) - 1;
  if (chip->chipsize & 0xffffffff)
    chip->chip_shift = ffs((unsigned)chip->chipsize) - 1;
  else {
    chip->chip_shift = ffs((unsigned)(chip->chipsize >> 32));
    chip->chip_shift += 32 - 1;
  }

  chip->badblockbits = 8;
  chip->erase_cmd = spinand_erase_block;

#ifndef __UBOOT__
  pr_err("NAND device: Manufacturer ID: 0x%02x, Chip ID: 0x%02x (%s %s),"
        " %dMiB, page size: %d, OOB size: %d\n",
        *maf_id, *dev_id, nand_manuf_ids[maf_idx].name,
        chip->onfi_version ? chip->onfi_params.model : type->name,
        (int)(chip->chipsize >> 20), mtd->writesize, mtd->oobsize);
#else
  pr_err("NAND device: Manufacturer ID: 0x%02x, Chip ID: 0x%02x (%s %d),"
        " %dMiB, page size: %d, OOB size: %d\n",
        *maf_id, *dev_id, nand_manuf_ids[maf_idx].name,
        chip->onfi_version,
        (int)(chip->chipsize >> 20), mtd->writesize, mtd->oobsize);
#endif

  return type;
}

int spinand_scan_ident(struct mtd_info *mtd, int maxchips,
        struct nand_flash_dev *table)
{
  int maf_id, dev_id;
  struct nand_chip *chip = mtd->priv;
  struct nand_flash_dev *type;

  /* Set the default functions */
  spinand_set_defaults(chip);

  /* Read the flash type */
  type = spinand_get_flash_type(mtd, chip, &maf_id, &dev_id, table);

  if (IS_ERR(type)) {
    if (!(chip->options & NAND_SCAN_SILENT_NODEV))
      pr_warn("No NAND device found\n");
    return PTR_ERR(type);
  }

  mtd->size = chip->chipsize;
  return 0;
}

int spinand_scan_tail(struct mtd_info *mtd)
{
  int i;
  struct nand_chip *chip = mtd->priv;
  uint8_t setFeature = 0x0;

  /* New bad blocks should be marked in OOB, flash-based BBT, or both */
  BUG_ON((chip->bbt_options & NAND_BBT_NO_OOB_BBM) &&
      !(chip->bbt_options & NAND_BBT_USE_FLASH));

  /* Set the internal oob buffer location, just after the page data */
  chip->oob_poi = chip->buffers->databuf + mtd->writesize;

  /* If no default placement scheme is given, select an appropriate one */
  if (!chip->ecc.layout && (chip->ecc.mode != NAND_ECC_SOFT_BCH)) {
    switch (mtd->oobsize) {
    case 8:
      chip->ecc.layout = &nand_oob_8;
      break;
    case 16:
      chip->ecc.layout = &nand_oob_16;
      break;
    case 64:
      chip->ecc.layout = &nand_oob_64;
      break;
    case 128:
      chip->ecc.layout = &nand_oob_128;
      break;
    default:
      pr_warn("No oob scheme defined for oobsize %d\n",
           mtd->oobsize);
      BUG();
    }
  }

  if (!chip->write_page)
    chip->write_page = spinand_write_page;

  if (!chip->onfi_set_features)
      chip->onfi_set_features = spinand_set_feature;
  if (!chip->onfi_get_features)
      chip->onfi_get_features = spinand_get_feature;
  /*
   * Check ECC mode, default to software if 3byte/512byte hardware ECC is
   * selected and we have 256 byte pagesize fallback to software ECC
   */

  switch (chip->ecc.mode) {
  case NAND_ECC_HW_OOB_FIRST:
  case NAND_ECC_HW:
    pr_debug("NAND_ECC_HW selected  by board driver.\n");
    chip->ecc.read_page         = spinand_read_page_hwecc;
    chip->ecc.write_page        = spinand_write_page_hwecc;
    chip->ecc.read_oob          = spinand_read_oob_std;
    chip->ecc.read_page_raw     = spinand_read_page_raw;
    chip->ecc.write_page_raw    = spinand_write_page_raw;
    chip->ecc.write_oob         = spinand_write_oob_std;
    chip->ecc.size = mtd->writesize;
    chip->ecc.bytes = 0;
    chip->ecc.strength = 0;
    setFeature = SPINAND_FEATURE_ECC_EN;
    spinand_set_feature (mtd, chip, SPINAND_FEATURE_REG,  &setFeature);
    setFeature = 0x00;
    spinand_get_feature (mtd, chip, SPINAND_FEATURE_REG,  &setFeature);
    break;
  case NAND_ECC_HW_SYNDROME:
  case NAND_ECC_SOFT:
  case NAND_ECC_SOFT_BCH:
  case NAND_ECC_NONE:
    pr_debug("NAND_ECC_NONE selected  by board driver. "
             "This is not recommended!\n");
    chip->ecc.read_page         = spinand_read_page_raw;
    chip->ecc.write_page        = spinand_write_page_hwecc;
    chip->ecc.read_oob          = spinand_read_oob_std;
    chip->ecc.read_page_raw     = spinand_read_page_raw;
    chip->ecc.write_page_raw    = spinand_write_page_raw;
    chip->ecc.write_oob         = spinand_write_oob_std;
    chip->ecc.size = mtd->writesize;
    chip->ecc.bytes = 0;
    chip->ecc.strength = 0;
    break;

  default:
    pr_warn("Invalid NAND_ECC_MODE %d\n", chip->ecc.mode);
    BUG();
  }

  /* For many systems, the standard OOB write also works for raw */
  if (!chip->ecc.read_oob_raw)
      chip->ecc.read_oob_raw      = spinand_read_oob_std;
  if (!chip->ecc.write_oob_raw)
      chip->ecc.write_oob_raw     = spinand_write_oob_raw;

  /*
     * The number of bytes available for a client to place data into
     * the out of band area.
     */
  chip->ecc.layout->oobavail = 0;
  for (i = 0; chip->ecc.layout->oobfree[i].length
      && i < ARRAY_SIZE(chip->ecc.layout->oobfree); i++)
      chip->ecc.layout->oobavail +=
      chip->ecc.layout->oobfree[i].length;
  mtd->oobavail = chip->ecc.layout->oobavail;

  /*
     * Set the number of read / write steps for one page depending on ECC
     * mode.
     */
  chip->ecc.steps = mtd->writesize / chip->ecc.size;
  if (chip->ecc.steps * chip->ecc.size != mtd->writesize) {
    pr_warn("Invalid ECC parameters\n");
    BUG();
  }
  chip->ecc.total = chip->ecc.steps * chip->ecc.bytes;

  mtd->subpage_sft = 0;
  chip->subpagesize = mtd->writesize >> mtd->subpage_sft;

  /* Initialize state */
  chip->state = FL_READY;

  /* Invalidate the pagebuffer reference */
  chip->pagebuf = -1;

  /* Large page NAND with SOFT_ECC should support subpage reads */
  if ((chip->ecc.mode == NAND_ECC_SOFT) && (chip->page_shift > 9))
    chip->options |= NAND_SUBPAGE_READ;

  /* Fill in remaining MTD driver data */
  mtd->type = MTD_NANDFLASH;
  mtd->flags = MTD_CAP_NANDFLASH;
  mtd->_erase = spinand_mtd_erase;
#ifndef __UBOOT__
  mtd->_point = NULL;
  mtd->_unpoint = NULL;
#endif
  mtd->_read = spinand_mtd_read;
  mtd->_write = spinand_mtd_write;
  mtd->_panic_write = spinand_mtd_write;
  mtd->_read_oob = spinand_mtd_read_oob;
  mtd->_write_oob = spinand_mtd_write_oob;
  mtd->_sync = spinand_mtd_sync;
  mtd->_lock = NULL;
  mtd->_unlock = NULL;
  mtd->_block_isbad = spinand_mtd_block_isbad;
  mtd->_block_markbad = spinand_mtd_block_markbad;
  mtd->writebufsize = mtd->writesize;

  /* propagate ecc info to mtd_info */
  mtd->ecclayout = chip->ecc.layout;
  mtd->ecc_strength = chip->ecc.strength;
  /*
     * Initialize bitflip_threshold to its default prior scan_bbt() call.
     * scan_bbt() might invoke mtd_read(), thus bitflip_threshold must be
     * properly set.
     */
  if (!mtd->bitflip_threshold)
    mtd->bitflip_threshold = mtd->ecc_strength;

	struct spinand_info *info = mtd_to_spinand(mtd);
	if ((info->read_cmd == SPINAND_CMD_QUAD_READ)
			|| (info->pload_cmd == SPINAND_CMD_QUAD_PLOAD))
		spinand_set_qeb(mtd, chip);

  /* Check, if we should skip the bad block table scan */
  if (chip->options & NAND_SKIP_BBTSCAN)
    return 0;

  /* Build bad block table */
  return chip->scan_bbt(mtd);
}

#ifndef __UBOOT__
#ifdef MODULE
#define caller_is_module() (1)
#else
#define caller_is_module() \
  is_module_text_address((unsigned long)__builtin_return_address(0))
#endif
#endif


int spinand_scan(struct mtd_info *mtd, int maxchips)
{
  int ret;
#ifndef __UBOOT__
  /* Many callers got this wrong, so check for it for a while... */
  if (!mtd->owner && caller_is_module()) {
    pr_crit("%s called with NULL mtd->owner!\n", __func__);
    BUG();
  }
#endif

  ret = spinand_scan_ident(mtd, maxchips, NULL);
  if (!ret)
    ret = spinand_scan_tail(mtd);
  return ret;
}

#ifdef CONFIG_OF
static void of_spinand_free_data(struct flash_platform_data *data)
{
	if (data) {
		if (data->parts)
			kfree(data->parts);
		kfree(data);
	}
}

static struct flash_platform_data *
of_spinand_get_data(struct device *dev)
{
	struct flash_platform_data *data = 0;
	struct device_node *np, *part_np;
	char *propname;
	phandle phandle;
	int err, i;

	data = kzalloc(sizeof(struct flash_platform_data), GFP_KERNEL);
	if (!data) {
		dev_err(dev, "alloc data failed!\n");
		return 0;
	}

	np = dev->of_node;
	err = of_property_read_u32(np, "nr-parts", &data->nr_parts);
	if (err || !data->nr_parts) {
		dev_err(dev, "match nr-parts failed!\n");
		return 0;
	}

	data->parts = kzalloc(
	sizeof(struct mtd_partition)*data->nr_parts, GFP_KERNEL);
	if (!data->parts) {
		dev_err(dev, "alloc parts failed!\n");
		goto get_data_err;
	}

	for (i=0; i<data->nr_parts; i++) {
		propname = kasprintf(GFP_KERNEL, "nr-part-%d", i);
		if (of_property_read_u32(np, propname, &phandle)) {
			dev_err(dev, "match %s failed!\n", propname);
			goto get_data_err;
		}
		part_np = of_find_node_by_phandle(phandle);
		if (!part_np) {
			dev_err(dev, "find %s node failed!\n", propname);
			goto get_data_err;
		}
		if (of_property_read_string(part_np, "name",
		(const char **)&(data->parts[i].name))) {
			dev_err(dev, "match %s name failed!\n", propname);
			goto get_data_err;
		}
		if (of_property_read_u32(part_np, "offset",
		(u32 *)&(data->parts[i].offset))) {
			dev_err(dev, "match %s offset failed!\n", propname);
			goto get_data_err;
		}
		if (of_property_read_u32(part_np, "size",
		(u32 *)&(data->parts[i].size))) {
			dev_err(dev, "match %s size failed!\n", propname);
			goto get_data_err;
		}
	}
	return data;

get_data_err:
	of_spinand_free_data(data);
	return 0;
}
#endif

#ifndef __UBOOT__
static int spinand_probe(struct spi_device *pdev)
#else
static int spinand_probe(struct udevice *dev)
#endif
{
  struct spi_slave *pdev = dev_get_parentdata(dev);
  struct mtd_info *mtd;
  struct spinand_info *info;
  struct nand_chip *chip;
  int retval = 0;
#ifndef __UBOOT__
  struct flash_platform_data *data;
#ifdef CONFIG_OF
  data = of_spinand_get_data(&pdev->dev);
  pdev->dev.platform_data = data;
#else
  data = pdev->dev.platform_data;
#endif
  if (!data) {
    dev_err(&pdev->dev, "no platform data or alloc failed!\n");
    return -ENODEV;
  }
#endif // __UBOOT__

	struct spinand_platdata *plat = dev_get_platdata(dev);
	info = dev_get_priv(dev);
	if (plat) {
		pdev->max_hz = plat->max_hz;
		pdev->mode = plat->mode;
		pdev->cs = plat->cs;
	}

  memset(info->cmd, 0, MAX_CMD_SIZE);
  if (pdev->mode & SPI_RX_DUAL)
    info->read_cmd = SPINAND_CMD_DUAL_READ;
  else if (pdev->mode & SPI_RX_QUAD)
    info->read_cmd = SPINAND_CMD_QUAD_READ;
  else
    info->read_cmd = SPINAND_CMD_NORM_READ;
  if (pdev->mode & SPI_TX_QUAD)
    info->pload_cmd = SPINAND_CMD_QUAD_PLOAD;
  else
    info->pload_cmd = SPINAND_CMD_PLOAD;
	printf("%s: max_hz=%d, mode=0x%x, read_cmd=0x%x, pload_cmd=0x%x\n",
		__func__, pdev->max_hz, pdev->mode, info->read_cmd, info->pload_cmd);

  info->chip.buffers = (void  *)kmalloc(sizeof(struct nand_buffers), GFP_KERNEL);
  if (NULL == info->chip.buffers) {
    dev_err(&pdev->dev, "failed to allocate data buffers\n");
    retval = -ENOMEM;
    goto exit_error2;
  }

  dev_set_drvdata(&pdev->dev, info);

  spin_lock_init(&info->controller.lock);
  init_waitqueue_head(&info->controller.wq);

  info->pdev = pdev;
  chip = &info->chip;
  mtd = &info->mtd;

  chip->controller    = &info->controller;
#ifndef __UBOOT__
  chip->priv          = mtd;
#else
	/* use nand_chip's priv to get spi_slave in cmd_nand.c */
  chip->priv          = pdev;
#endif
  chip->IO_ADDR_W     = NULL;
  chip->cmd_ctrl      = NULL;
  chip->dev_ready     = NULL;
  chip->IO_ADDR_R     = chip->IO_ADDR_W;

  chip->options       = 0;
  chip->ecc.mode      = NAND_ECC_HW;
  chip->ecc.calculate = nand_calculate_ecc;
  chip->ecc.correct   = nand_correct_data;
  chip->ecc.hwctl     = NULL;

  /* initialise mtd info data struct */
  mtd->priv = &info->chip;
  mtd->owner = THIS_MODULE;
  mtd->name = "giga_spinand";
#ifndef __UBOOT__
  mtd->dev.parent = &pdev->dev;
  pdev->max_speed_hz = 3000000;
#elif defined CONFIG_DM_SPI
  retval = spi_claim_bus(pdev);
  if (retval) {
    printf("%s: Failed to claim SPI bus\n", __func__);
    goto exit_error3;
  }
#endif
  if (spinand_scan(mtd, 1)) {
    retval = -ENXIO;
    goto exit_error3;
  }

#ifdef __UBOOT__
  add_mtd_partitions(mtd, spinand_partitions, ARRAY_SIZE(spinand_partitions));
#elif defined CONFIG_OF
  mtd_device_register(mtd, data->parts, data->nr_parts);
#endif
	/* Warning: This is a copy. Don't get spinand_info by
	 * container_of(mtd, struct spinand_info, mtd) but
	 * container_of(mtd->priv, struct spinand_info, chip)
	 */
	nand_info[SPINAND_INFO_ID] = *mtd;
  pr_debug("chip_ops = %x, bbt_ops = %x\n",
            chip->options, chip->bbt_options);

	printf("%s: probe ok\n", __func__);
  return retval;

exit_error3: kfree(info->chip.buffers);
exit_error2: kfree(info);
#ifdef CONFIG_OF
	of_spinand_free_data(data);
#endif
  return retval;
}

#ifdef CONFIG_OF_CONTROL
static int spinand_ofdata_to_platdata(struct udevice *bus)
{
	return 0;
}

static const struct udevice_id spinand_ids[] = {
	{ .compatible = "amlogic, spinand" },
	{ }
};
#endif

U_BOOT_DRIVER(spinand) = {
	.name = "spinand",
	.id = UCLASS_SPI_GENERIC,
#ifdef CONFIG_OF_CONTROL
	.of_match = spinand_ids,
	.ofdata_to_platdata = spinand_ofdata_to_platdata,
	.platdata_auto_alloc_size = sizeof(struct spinand_platdata),
#endif
	.priv_auto_alloc_size = sizeof(struct spinand_info),
	.probe = spinand_probe,
};
