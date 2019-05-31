#include <common.h>
#include <environment.h>
#include <nand.h>
#include <asm/io.h>
#include <malloc.h>
#include <linux/err.h>
#include <linux/bitops.h>
#include <asm/cache.h>
// #include <asm/reboot.h>
#include <asm/arch/clock.h>

#include "aml_mtd.h"

extern struct hw_controller *controller;
extern uint8_t nand_boot_flag;
/*external defined variable*/
extern int info_disprotect;
/* protect flag inside */
static int rsv_protect = 1;

static inline void _aml_rsv_disprotect(void)
{
	rsv_protect = 0;
}
static inline void _aml_rsv_protect(void)
{
	rsv_protect = 1;
}
static inline int _aml_rsv_isprotect(void)
{
	return rsv_protect;
}

//#define CONFIG_DBG_BITMAP	1

struct rsv_info {
	char name[8];
	struct aml_nandrsv_info_t rsv_info;
	unsigned int blocks;
	unsigned int size;
};

#define BBT_INFO_INDEX		0
#define ENV_INFO_INDEX		1
#define KEY_INFO_INDEX		2
#define DTB_INFO_INDEX		3
#define DDR_INFO_INDEX		4

#define INFO_DATA(n, b, s)	{ .name = (n), .blocks = (b), .size = (s) }

static struct rsv_info info[] = {
	INFO_DATA(BBT_NAND_MAGIC, NAND_BBT_BLOCK_NUM, 0),
#ifndef CONFIG_ENV_IS_IN_NAND
	INFO_DATA(ENV_NAND_MAGIC, NAND_ENV_BLOCK_NUM, CONFIG_ENV_SIZE),
#endif
	INFO_DATA(KEY_NAND_MAGIC, NAND_KEY_BLOCK_NUM, 0),
	INFO_DATA(DTB_NAND_MAGIC, NAND_DTB_BLOCK_NUM, 0),
	INFO_DATA(DDR_NAND_MAGIC, NAND_DDR_BLOCK_NUM, 2048),
};

static struct free_node_t *get_free_node(struct mtd_info *mtd)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	unsigned int index;
#ifdef CONFIG_DBG_BITMAP
	printk("%s %d: bitmap=%llx\n", __func__, __LINE__,
		aml_chip->freeNodeBitmask);
#endif
	index = find_first_zero_bit((void *)&aml_chip->freeNodeBitmask, 64);
	if (index > RESERVED_BLOCK_NUM)
		printk("%s %d: index=%d is greater than max! error",
			__func__, __LINE__, index);
	test_and_set_bit(index, (void *)&aml_chip->freeNodeBitmask);
#ifdef CONFIG_DBG_BITMAP
	printk("%s %d: bitmap=%llx\n", __func__, __LINE__,
		aml_chip->freeNodeBitmask);
#endif
	return aml_chip->free_node[index];

}

static void release_free_node(struct mtd_info *mtd,
	struct free_node_t *free_node)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	unsigned int index_save = free_node->index;
	printk("%s %d: bitmap=%llx\n", __func__, __LINE__,
		aml_chip->freeNodeBitmask);

	if (free_node->index > RESERVED_BLOCK_NUM)
		printk("%s %d: index=%d is greater than max! error",
			__func__, __LINE__, free_node->index);

	test_and_clear_bit(free_node->index,
		(void *)&aml_chip->freeNodeBitmask);

	/*memset zero to protect from dead-loop*/
	memset(free_node, 0, sizeof(struct free_node_t));
	free_node->index = index_save;
	printk("%s %d: bitmap=%llx\n", __func__, __LINE__,
		aml_chip->freeNodeBitmask);
}

int aml_nand_rsv_erase_protect(struct mtd_info *mtd, unsigned int block_addr)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	/* skip protect if we disprotect it in porpose */
	if (!_aml_rsv_isprotect())
		return 0;

	if (aml_chip->aml_nandkey_info != NULL) {
		if (aml_chip->aml_nandkey_info->valid)
	if ((!(info_disprotect & DISPROTECT_KEY))
	&& ((block_addr >= aml_chip->aml_nandkey_info->start_block)
		&& (block_addr < aml_chip->aml_nandkey_info->end_block)))
			return -1; /*need skip key blocks*/
		}
	if (aml_chip->aml_nandbbt_info != NULL) {
		if (aml_chip->aml_nandbbt_info->valid)
	if ((block_addr >= aml_chip->aml_nandbbt_info->start_block)
		&&(block_addr < aml_chip->aml_nandbbt_info->end_block))
			return -1; /*need skip bbt blocks*/
		}
	return 0;
}

/* fixme, mxic's bad block identify is not checked yet! */
//only read bad block  labeled ops
int aml_nand_scan_shipped_bbt(struct mtd_info *mtd)
{
	struct nand_chip * chip = mtd->priv;
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	unsigned char *data_buf;
	int32_t read_cnt, page, pages_per_blk;
	loff_t addr, offset;
	int  start_blk =0, total_blk =0,i, j, bad_blk_cnt =0, phys_erase_shift;
	int realpage, col0_data=0, col0_oob=0, valid_page_num = 1;
	int col_data_sandisk[6], bad_sandisk_flag=0;

	phys_erase_shift = fls(mtd->erasesize) - 1;
	chip->pagebuf = -1;
	pages_per_blk = (1 << (chip->phys_erase_shift - chip->page_shift));

	data_buf = kzalloc(mtd->writesize, GFP_KERNEL);
	if (data_buf == NULL) {
		printk("%s %d malloc failed\n",__func__,__LINE__);
		return -ENOMEM;
	}

	/*need scan factory bad block in bootloader area*/
	start_blk = 0;
	total_blk = (int)(mtd->size >> phys_erase_shift);
	/* fixme, need  check the total block number avoid mtd->size was changed outside! */
	printk("scaning flash total block %d\n", total_blk);
	do {
	offset = mtd->erasesize;
	offset *= start_blk;
	for (i=0; i < controller->chip_num; i++) {
	//if (aml_chip->valid_chip[i]) {
		for (read_cnt = 0; read_cnt < 3; read_cnt++) {
			if (read_cnt == 2) {
				if (aml_chip->mfr_type == NAND_MFR_AMD)
					addr = offset + mtd->writesize;
				else
					break;
		    } else {
				if (aml_chip->mfr_type  == NAND_MFR_SANDISK) {
					addr = offset + read_cnt*mtd->writesize;
				} else
					addr = offset +
				(pages_per_blk - 1) * read_cnt * mtd->writesize;
			}

			realpage = (int)(addr >> chip->page_shift);
			page = realpage & chip->pagemask;

			if (page != -1) {
				valid_page_num=mtd->writesize>>chip->page_shift;
				valid_page_num /= aml_chip->plane_num;

				aml_chip->page_addr = page/ valid_page_num;
	if (unlikely(aml_chip->page_addr >= aml_chip->internal_page_nums)) {
		aml_chip->page_addr -= aml_chip->internal_page_nums;
		aml_chip->page_addr |=
		(1 << aml_chip->internal_chip_shift)*aml_chip->internal_chipnr;
	}
			}
			if (aml_chip->plane_num == 2) {
				chip->select_chip(mtd, i);
				aml_chip->aml_nand_wait_devready(aml_chip, i);
				if (aml_nand_get_fbb_issue()) {
					chip->cmd_ctrl(mtd,
						NAND_CMD_SEQIN, NAND_CTRL_CLE);
					chip->cmd_ctrl(mtd,
						0, NAND_CTRL_ALE);
				}
				aml_chip->aml_nand_command(aml_chip,
					NAND_CMD_READ0,
					0x00,aml_chip->page_addr, i);

			if (!aml_chip->aml_nand_wait_devready(aml_chip, i))
				printk ("%s, %d,selected chip%d not ready\n",
					__func__, __LINE__, i);

				if (aml_chip->ops_mode & AML_CHIP_NONE_RB)
					chip->cmd_ctrl(mtd,
					NAND_CMD_READ0 & 0xff,
					NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);
				udelay(2);
				aml_chip->aml_nand_command(aml_chip,
					NAND_CMD_TWOPLANE_READ1,
					0x00, aml_chip->page_addr, i);
				udelay(2);

		if (aml_chip->mfr_type  == NAND_MFR_SANDISK) {
			for (j = 0; j < 6; j++)
				col_data_sandisk[j] = chip->read_byte(mtd);
		} else
			col0_data = chip->read_byte(mtd);

				aml_chip->aml_nand_command(aml_chip,
					NAND_CMD_TWOPLANE_READ2,
					aml_chip->page_size,
					aml_chip->page_addr, i);
				//aml_chip->aml_nand_wait_devready(aml_chip, i);
				udelay(2);

				if (aml_chip->mfr_type  == NAND_MFR_SANDISK)
					col0_oob = 0x0;
				else
					col0_oob = chip->read_byte(mtd);
				//printk("col0_oob=%x\n",col0_oob);

			} else if (aml_chip->plane_num == 1) {
				chip->select_chip(mtd, i);
				//nand_get_chip();
				//aml_chip->aml_nand_select_chip(aml_chip, i);

			if (aml_nand_get_fbb_issue()) {
				chip->cmd_ctrl(mtd,
					NAND_CMD_SEQIN, NAND_CTRL_CLE);
				chip->cmd_ctrl(mtd,
					0, NAND_CTRL_ALE);
				}
				aml_chip->aml_nand_command(aml_chip,
					NAND_CMD_READ0, 0x00,
					aml_chip->page_addr , i);
				udelay(2);

			if (!aml_chip->aml_nand_wait_devready(aml_chip, i))
				printk ("%s, %d,selected chip%d not ready\n",
					__func__, __LINE__, i);

				if (aml_chip->ops_mode & AML_CHIP_NONE_RB)
					chip->cmd_ctrl(mtd,
					NAND_CMD_READ0 & 0xff,
					NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);
				udelay(2);

			if (aml_chip->mfr_type  == NAND_MFR_SANDISK) {
				for (j = 0; j < 6; j++)
					col_data_sandisk[j] =
						chip->read_byte(mtd);
			} else
				col0_data = chip->read_byte(mtd);

				//printk("col0_data =%x\n",col0_data);

				if (aml_chip->mfr_type  != NAND_MFR_SANDISK)
					aml_chip->aml_nand_command(aml_chip,
						NAND_CMD_RNDOUT,
						aml_chip->page_size, -1, i);
				udelay(2);

				if (aml_chip->mfr_type  == NAND_MFR_SANDISK)
					col0_oob = 0x0;
				else
					col0_oob = chip->read_byte(mtd);
				//printk("col0_oob =%x\n",col0_oob);
			}

	if ((aml_chip->mfr_type  == 0xC8 )) {
		if ((col0_oob != 0xFF) || (col0_data != 0xFF)) {
			printk("detect factory Bad block:%llx blk:%d chip:%d\n",
				(uint64_t)addr, start_blk, i);
			aml_chip->nand_bbt_info->nand_bbt[bad_blk_cnt++] =
				start_blk | 0x8000;
			aml_chip->block_status[start_blk] = NAND_FACTORY_BAD;
			break;
		}
	}

	if (aml_chip->mfr_type  == NAND_MFR_AMD ) {
		if (col0_oob != 0xFF) {
			printk("detect factory Bad block:%llx blk:%d chip:%d\n",
				(uint64_t)addr, start_blk, i);
			aml_chip->nand_bbt_info->nand_bbt[bad_blk_cnt++] =
				start_blk | 0x8000;
			aml_chip->block_status[start_blk] = NAND_FACTORY_BAD;
			break;
		}
	}

	if ((col0_oob == 0xFF))
		continue;

	if (col0_oob != 0xFF) {
		printk("%s:%d factory ship bbt found\n", __func__, __LINE__);
		if (aml_chip->mfr_type  == 0xc2 ) {
			if (col0_oob != 0xFF) {
				printk("detect factory Bad block:%llx blk=%d chip=%d\n",
					(uint64_t)addr, start_blk, i);
				aml_chip->nand_bbt_info->nand_bbt[bad_blk_cnt++] = start_blk|0x8000;
				aml_chip->block_status[start_blk] = NAND_FACTORY_BAD;
				break;
			}
		}

		if (aml_chip->mfr_type  == NAND_MFR_DOSILICON ||
		    aml_chip->mfr_type  == NAND_MFR_ATO ||
			aml_chip->mfr_type  == NAND_MFR_HYNIX ||
			aml_chip->mfr_type  == NAND_MFR_ZETTA) {
			if (col0_oob != 0xFF) {
				pr_info("detect a fbb:%llx blk=%d chip=%d\n",
					(uint64_t)addr, start_blk, i);
				aml_chip->nand_bbt_info->
					nand_bbt[bad_blk_cnt++] =
						start_blk|0x8000;
				aml_chip->block_status[start_blk] =
					NAND_FACTORY_BAD;
				break;
			}
		}

		if (aml_chip->mfr_type  == 0xef ) {
			if (col0_oob != 0xFF) {
				printk("detect factory Bad block:%llx blk=%d chip=%d\n",
					(uint64_t)addr, start_blk, i);
				aml_chip->nand_bbt_info->nand_bbt[bad_blk_cnt++] = start_blk|0x8000;
				aml_chip->block_status[start_blk] = NAND_FACTORY_BAD;
				break;
			}
		}

		if ((aml_chip->mfr_type  == NAND_MFR_SANDISK) ) {
			for (j = 0; j < 6; j++) {
				if (col_data_sandisk[j] == 0x0) {
					bad_sandisk_flag = 1;
					break;
				}
			}
			if (bad_sandisk_flag ) {
				printk("detect factory Bad block:%llx blk=%d chip=%d\n",
					(uint64_t)addr, start_blk, i);
				aml_chip->nand_bbt_info->nand_bbt[bad_blk_cnt++] = start_blk|0x8000;
				aml_chip->block_status[start_blk] = NAND_FACTORY_BAD;
				bad_sandisk_flag=0;
				break;
			}
		}

		if ((aml_chip->mfr_type  == NAND_MFR_SAMSUNG ) ) {
			if ((col0_oob != 0xFF) && (col0_data != 0xFF)) {
				printk("detect factory Bad block:%llx blk=%d chip=%d\n",
					(uint64_t)addr, start_blk, i);
				aml_chip->nand_bbt_info->nand_bbt[bad_blk_cnt++] = start_blk|0x8000;
				aml_chip->block_status[start_blk] = NAND_FACTORY_BAD;
					break;
			}
		}

		if ((aml_chip->mfr_type  == NAND_MFR_TOSHIBA )  ) {
			if ((col0_oob != 0xFF) && (col0_data != 0xFF)) {
				printk("detect factory Bad block:%llx blk=%d chip=%d\n",
					(uint64_t)addr, start_blk, i);
				aml_chip->nand_bbt_info->nand_bbt[bad_blk_cnt++] = start_blk|0x8000;
				aml_chip->block_status[start_blk] = NAND_FACTORY_BAD;
				break;
			}
		}

		if (aml_chip->mfr_type  == NAND_MFR_MICRON ) {
			if (col0_oob == 0x0) {
				printk("detect factory Bad block:%llx blk=%d chip=%d\n",
					(uint64_t)addr, start_blk, i);
				aml_chip->nand_bbt_info->nand_bbt[bad_blk_cnt++] = start_blk|0x8000;
				aml_chip->block_status[start_blk] = NAND_FACTORY_BAD;
				break;
			}
		}
	}
		}
		//}
	}
	} while((++start_blk) < total_blk);

	printk("aml_nand_scan_bbt: factory Bad block bad_blk_cnt=%d\n",
		bad_blk_cnt);
	kfree(data_buf);
	return 0;
}

int aml_nand_read_rsv_info (struct mtd_info *mtd,
	struct aml_nandrsv_info_t *nandrsv_info, size_t offset, u_char * buf)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	struct oobinfo_t *oobinfo;
	int error = 0, ret = 0;
	loff_t addr = 0;
	size_t amount_loaded = 0;
	size_t len;
	unsigned char *data_buf;
	unsigned char oob_buf[sizeof(struct oobinfo_t)];
	int page, realpage, chipnr;
	struct nand_chip *chip = mtd->priv;

READ_RSV_AGAIN:
	addr = nandrsv_info->valid_node->phy_blk_addr;
	addr *= mtd->erasesize;
	addr += nandrsv_info->valid_node->phy_page_addr * mtd->writesize;
	printk("%s:%d,read %s info to %llx\n",__func__, __LINE__,
		nandrsv_info->name, addr);

	data_buf = aml_chip->rsv_data_buf;

	oobinfo = (struct oobinfo_t *)oob_buf;
	while (amount_loaded < nandrsv_info->size ) {

		memset((unsigned char *)data_buf,
			0x0, mtd->writesize);
		memset((unsigned char *)oob_buf,
			0x0, sizeof(struct oobinfo_t));

		chipnr = (int)(addr >> chip->chip_shift);
		chip->select_chip(mtd, chipnr);
		realpage = (int)(addr >> chip->page_shift);
		page = realpage & chip->pagemask;

		chip->cmdfunc(mtd, NAND_CMD_READ0, 0x00, page);
		error = chip->ecc.read_page(mtd, chip, data_buf,
							  1, page);
		chip->select_chip(mtd, -1);

		if ((error != 0) && (error != -EUCLEAN)) {
			printk("blk good but read failed: %llx, %d\n",
				(uint64_t)addr, error);
			ret = aml_nand_scan_rsv_info(mtd, nandrsv_info);
			if (ret == -1)
				return 1;
			else
				goto READ_RSV_AGAIN;
		}
		memcpy(oob_buf, chip->oob_poi, mtd->oobavail);
		if (memcmp(oobinfo->name, nandrsv_info->name, 4))
			printk("invalid nand info %s magic: %llx\n",
				nandrsv_info->name, (uint64_t)addr);

		addr += mtd->writesize;
		page++;
		len = min_t( uint32_t, mtd->writesize,
			(nandrsv_info->size - amount_loaded));
		memcpy(buf + amount_loaded, data_buf, len);
		amount_loaded += mtd->writesize;
	}

	if (amount_loaded < nandrsv_info->size)
		return 1;
#if 0
	uint64_t  dump_len =0;
	unsigned char *tmp =  NULL;
	if(!strncmp(nandrsv_info->name,
		KEY_NAND_MAGIC, strlen(nandrsv_info->name))) {
	tmp = buf;
	dump_len = nandrsv_info->size / 16;
	while (dump_len--) {
		printk("\t%02x %02x %02x %02x %02x %02x %02x %02x"
			"  %02x %02x %02x %02x %02x %02x %02x %02x\n",
		tmp[0], tmp[1], tmp[2], tmp[3], tmp[4], tmp[5], tmp[6], tmp[7],
		tmp[8], tmp[9], tmp[10], tmp[11], tmp[12], tmp[13], tmp[14],
		tmp[15]);
		tmp += 16;
	}
	}
#endif
	return 0;
}

int aml_nand_ext_read_rsv_info(struct mtd_info *mtd,
			       struct aml_nandrsv_info_t *info,
			       size_t offset, u_char *buf)
{
	if (!info->valid) {
		printk("%s %d: %s is invalid! read exit!",
		       __func__,
		       __LINE__,
		       info->name);
		return 1;
	}
	if (aml_nand_read_rsv_info(mtd, info, offset, (u_char *)buf))
		return 1;
	return 0;
}

static int aml_nand_write_rsv(struct mtd_info *mtd,
	struct aml_nandrsv_info_t *nandrsv_info, loff_t offset, u_char *buf)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	struct oobinfo_t *oobinfo;
	int error = 0;
	loff_t addr = 0;
	size_t amount_saved = 0;
	size_t len;
	unsigned char *data_buf;
	unsigned char oob_buf[sizeof(struct oobinfo_t)];
	struct nand_chip *chip = mtd->priv;
	int page, chipnr;

	data_buf = aml_chip->rsv_data_buf;
	addr = offset;
	oobinfo = (struct oobinfo_t *)oob_buf;
	memcpy(oobinfo->name, nandrsv_info->name, 4);
	oobinfo->ec = nandrsv_info->valid_node->ec;
	oobinfo->timestamp = nandrsv_info->valid_node->timestamp;

#if 0
	uint64_t  dump_len =0;
	unsigned char *tmp =  NULL;

	if(!strncmp(nandrsv_info->name,
		KEY_NAND_MAGIC, strlen(nandrsv_info->name))) {
	tmp = buf;
	dump_len = nandrsv_info->size / 16;
	while (dump_len--) {
		printk("\t%02x %02x %02x %02x %02x %02x %02x %02x"
			"  %02x %02x %02x %02x %02x %02x %02x %02x\n",
		tmp[0], tmp[1], tmp[2], tmp[3], tmp[4], tmp[5], tmp[6], tmp[7],
		tmp[8], tmp[9], tmp[10], tmp[11], tmp[12], tmp[13], tmp[14],
		tmp[15]);
		tmp += 16;
	}
	}
#endif
	while (amount_saved < nandrsv_info->size ) {

		memset((unsigned char *)data_buf,
			0x0, mtd->writesize);
		len = min_t(uint32_t,mtd->writesize,
			nandrsv_info->size - amount_saved);
		memcpy((unsigned char *)data_buf,
			buf + amount_saved, len);

		page = (int)(addr >> chip->page_shift);
		chipnr = (int)(addr >> chip->chip_shift);
		memset(chip->oob_poi, 0xff, mtd->oobsize);
		memcpy(chip->oob_poi, oob_buf, mtd->oobsize);
		chip->select_chip(mtd, chipnr);
		error = chip->write_page(mtd, chip, 0, len, data_buf,
			1, page, 0, 0);
		chip->select_chip(mtd, -1);
		if (error) {
			printk("blk check good but write failed: %llx, %d\n",
				(uint64_t)addr, error);
			return 1;
		}
		addr += mtd->writesize;
		amount_saved += mtd->writesize;
	}
	if (amount_saved < nandrsv_info->size)
		return 1;

	return 0;
}

int aml_nand_erase_rsv_info(struct mtd_info *mtd,
	struct aml_nandrsv_info_t *nandrsv_info)
{
	struct free_node_t *tmp_node = NULL;
	int error = 0;
	loff_t addr = 0;
	int chipnr, page;
	struct nand_chip *chip = mtd->priv;

	printk("erasing %s: \n", nandrsv_info->name);

	if (nandrsv_info->valid) {
		addr = nandrsv_info->valid_node->phy_blk_addr;
		addr *= mtd->erasesize;
		_aml_rsv_disprotect();
		//error = mtd->_erase(mtd, &erase_info);

		page = (int)(addr >> chip->page_shift);
		chipnr = (int)(addr >> chip->chip_shift);
		chip->select_chip(mtd, chipnr);
		chip->erase_cmd(mtd, page & chip->pagemask);
		error = chip->waitfunc(mtd, chip);
		if (error & NAND_STATUS_FAIL)
			error = -EIO;
		else
			error = 0;
		chip->select_chip(mtd, -1);
		_aml_rsv_protect();
		printk("erasing valid info block: %llx \n", addr);
		nandrsv_info->valid_node->ec++;
		nandrsv_info->valid_node->phy_page_addr = 0;
		nandrsv_info->valid_node->timestamp = 1;
	}
	tmp_node = nandrsv_info->free_node;
	while (tmp_node != NULL) {
		addr = tmp_node->phy_blk_addr;
		addr *= mtd->erasesize;

		_aml_rsv_disprotect();
		//error = mtd->_erase(mtd, &erase_info);

		page = (int)(addr >> chip->page_shift);
		chipnr = (int)(addr >> chip->chip_shift);
		chip->select_chip(mtd, chipnr);
		chip->erase_cmd(mtd, page & chip->pagemask);
		error = chip->waitfunc(mtd, chip);
		if (error & NAND_STATUS_FAIL)
			error = -EIO;
		else
			error = 0;
		chip->select_chip(mtd, -1);
		_aml_rsv_protect();
		printk("erasing free info block: %llx \n", addr);
		tmp_node->ec = -1;
		tmp_node->dirty_flag = 0;
		tmp_node = tmp_node->next;
	}
	return error;
}

int aml_nand_ext_erase_rsv_info(struct mtd_info *mtd,
				struct aml_nandrsv_info_t *info)
{
	if (aml_nand_erase_rsv_info(mtd, info))
		return 1;
	return 0;
}

int aml_nand_save_rsv_info(struct mtd_info *mtd,
	struct aml_nandrsv_info_t *nandrsv_info ,u_char *buf)
{
	struct free_node_t *free_node = NULL, *tmp_node = NULL;
	int error = 0, pages_per_blk, i = 1;
	loff_t addr = 0;
	int chipnr, page;
	struct nand_chip *chip = mtd->priv;

	pages_per_blk = mtd->erasesize / mtd->writesize;

	/*solve these abnormals caused by power off and ecc error*/
	if ((nandrsv_info->valid_node->status & POWER_ABNORMAL_FLAG)
		|| (nandrsv_info->valid_node->status & ECC_ABNORMAL_FLAG))
		nandrsv_info->valid_node->phy_page_addr = pages_per_blk;

	if ((mtd->writesize < nandrsv_info->size))
		i = (nandrsv_info->size + mtd->writesize - 1) / mtd->writesize;
	printk("%s:%d, %s: valid=%d, pages=%d\n",__func__, __LINE__,
		nandrsv_info->name, nandrsv_info->valid, i);
RE_SEARCH:
	if (nandrsv_info->valid) {
		//printk("%s:%d,phy_page_addr=%d,pages=%d\n",__func__, __LINE__,
		//	nandrsv_info->valid_node->phy_page_addr, i);
		nandrsv_info->valid_node->phy_page_addr += i;
		if ((nandrsv_info->valid_node->phy_page_addr+i)>pages_per_blk) {
	if ((nandrsv_info->valid_node->phy_page_addr -i) == pages_per_blk) {
				addr = nandrsv_info->valid_node->phy_blk_addr;
				addr *= mtd->erasesize;
				_aml_rsv_disprotect();
				//error = mtd->_erase(mtd, &erase_info);
				page = (int)(addr >> chip->page_shift);
				chipnr = (int)(addr >> chip->chip_shift);
				chip->select_chip(mtd, chipnr);
				chip->erase_cmd(mtd, page & chip->pagemask);
				error = chip->waitfunc(mtd, chip);
				if (error & NAND_STATUS_FAIL)
					error = -EIO;
				else
					error = 0;
				chip->select_chip(mtd, -1);
				_aml_rsv_protect();
				nandrsv_info->valid_node->ec++;
				printk("---erase bad info block:%llx \n",addr);
			}
			//free_node = kzalloc(sizeof(struct free_node_t),
			//	GFP_KERNEL);
			free_node = get_free_node(mtd);
			if (free_node == NULL)
				return -ENOMEM;

			free_node->phy_blk_addr =
				nandrsv_info->valid_node->phy_blk_addr;
			free_node->ec = nandrsv_info->valid_node->ec;
			tmp_node = nandrsv_info->free_node;
			while (tmp_node->next != NULL) {
				tmp_node = tmp_node->next;
			}
			tmp_node->next = free_node;

			tmp_node = nandrsv_info->free_node;
			nandrsv_info->valid_node->phy_blk_addr =
				tmp_node->phy_blk_addr;
			nandrsv_info->valid_node->phy_page_addr = 0;
			nandrsv_info->valid_node->ec = tmp_node->ec;
			nandrsv_info->valid_node->timestamp += 1;
			nandrsv_info->free_node = tmp_node->next;
			release_free_node(mtd, tmp_node);
		}
	} else {
		tmp_node = nandrsv_info->free_node;
		nandrsv_info->valid_node->phy_blk_addr = tmp_node->phy_blk_addr;
		nandrsv_info->valid_node->phy_page_addr = 0;
		nandrsv_info->valid_node->ec = tmp_node->ec;
		nandrsv_info->valid_node->timestamp += 1;
		nandrsv_info->free_node = tmp_node->next;
		release_free_node(mtd, tmp_node);
	}

	addr = nandrsv_info->valid_node->phy_blk_addr;
	addr *= mtd->erasesize;
	addr += nandrsv_info->valid_node->phy_page_addr * mtd->writesize;

	printk("%s:%d,save info to %llx\n",__func__, __LINE__, addr);

	if (nandrsv_info->valid_node->phy_page_addr == 0) {
		chipnr = (int)(addr >> chip->chip_shift);
		chip->select_chip(mtd, chipnr);
		error = chip->block_bad(mtd, addr, 1);
		chip->select_chip(mtd, -1);
		if (error != 0) {
			/*
			bad block here, need fix it
			because of info_blk list may be include bad block,
			so we need check it and done here. if don't,
			some bad blocks may be erase here
			and env will lost or too much ecc error
			*/
			printk("have bad block in info_blk list!!!!\n");
			nandrsv_info->valid_node->phy_page_addr =
				pages_per_blk - i ;
			goto RE_SEARCH;
		}

		_aml_rsv_disprotect();
		page = (int)(addr >> chip->page_shift);
		//chipnr = (int)(addr >> chip->chip_shift);
		chip->select_chip(mtd, chipnr);

		chip->erase_cmd(mtd, page & chip->pagemask);
		error = chip->waitfunc(mtd, chip);
		if (error & NAND_STATUS_FAIL)
			error = -EIO;
		else
			error = 0;
		chip->select_chip(mtd, -1);
		_aml_rsv_protect();
		if (error) {
			printk("env free blk erase failed %d\n", error);
			chip->select_chip(mtd, chipnr);
			chip->block_markbad(mtd, addr);
			chip->select_chip(mtd, -1);
			return error;
		}
		nandrsv_info->valid_node->ec++;
	}


	if (aml_nand_write_rsv(mtd, nandrsv_info, addr, (u_char *) buf)) {
		printk("update nand env FAILED!\n");
		return 1;
	}
	/* update valid infos */
	if (!nandrsv_info->valid)
		nandrsv_info->valid = 1;
	/* clear status when write successfully*/
	nandrsv_info->valid_node->status = 0;
	return error;
}

int aml_nand_ext_save_rsv_info(struct mtd_info *mtd,
			       struct aml_nandrsv_info_t *info,
			       u_char *buf)
{
	if (!info->init) {
		printk("%s %d %s not init\n",
			__func__, __LINE__, info->name);
		return 1;
	}
	if (aml_nand_save_rsv_info(mtd, info, buf))
		return 1;
	return 0;
}

static void aml_nand_rsv_info_size_fill(struct mtd_info *mtd)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	struct nand_chip *chip = mtd->priv;
	int subtract = -1;

#ifndef CONFIG_ENV_IS_IN_NAND
	subtract = 0;
#endif
	info[BBT_INFO_INDEX].size = mtd->size >> chip->phys_erase_shift;
	info[KEY_INFO_INDEX + subtract].size = aml_chip->keysize;
	info[DTB_INFO_INDEX + subtract].size = aml_chip->dtbsize;
}

static void aml_nand_rsv_info_ptr_fill(struct mtd_info *mtd)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	int subtract = -1;

	aml_chip->aml_nandbbt_info = &info[BBT_INFO_INDEX].rsv_info;
#ifndef CONFIG_ENV_IS_IN_NAND
	aml_chip->aml_nandenv_info = &info[ENV_INFO_INDEX].rsv_info;
	subtract = 0;
#endif
	aml_chip->aml_nandkey_info = &info[KEY_INFO_INDEX + subtract].rsv_info;
	aml_chip->aml_nanddtb_info = &info[DTB_INFO_INDEX + subtract].rsv_info;
	aml_chip->aml_nandddr_info = &info[DDR_INFO_INDEX + subtract].rsv_info;
}

static int aml_nand_rsv_info_alloc_init(struct mtd_info *mtd,
					char *name,
					struct aml_nandrsv_info_t **rsv_info,
					unsigned int blocks, unsigned int size)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	struct aml_nandrsv_info_t *rsvinfo = *rsv_info;
	struct nand_chip *chip = mtd->priv;
	unsigned int limit_blk, pages_per_blk_shift;

	pages_per_blk_shift = (chip->phys_erase_shift - chip->page_shift);
	limit_blk = (BOOT_TOTAL_PAGES >> pages_per_blk_shift) +
		    RESERVED_BLOCK_NUM;
	if (aml_chip->vernier + blocks > limit_blk) {
		pr_info("ERROR: total blk number is over the limit\n");
		return -ERANGE;
	}

	rsvinfo->mtd = mtd;
	rsvinfo->valid_node = kzalloc(sizeof(struct valid_node_t), GFP_KERNEL);
	if (rsvinfo->valid_node == NULL)
		return -ENOMEM;

	rsvinfo->valid_node->phy_blk_addr = -1;
	rsvinfo->start_block = aml_chip->vernier;
	aml_chip->vernier += blocks;
	rsvinfo->end_block = aml_chip->vernier;
	rsvinfo->size = size;
	memcpy(rsvinfo->name, name, 4);
	return 0;
}

int aml_nand_rsv_info_init(struct mtd_info *mtd)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	struct nand_chip *chip = mtd->priv;
	struct aml_nandrsv_info_t *rsv_info;
	unsigned int pages_per_blk_shift, bbt_start_block;
	int  i, ret;

	pages_per_blk_shift = (chip->phys_erase_shift - chip->page_shift);
	bbt_start_block = BOOT_TOTAL_PAGES >> pages_per_blk_shift;
	bbt_start_block += NAND_GAP_BLOCK_NUM;
	aml_chip->rsv_data_buf = kzalloc(mtd->writesize, GFP_KERNEL);
	if (aml_chip->rsv_data_buf == NULL)
		return -ENOMEM;

	aml_chip->vernier = bbt_start_block;
	aml_chip->freeNodeBitmask = 0;
	for (i = 0; i < RESERVED_BLOCK_NUM; i++) {
		aml_chip->free_node[i] =
			kzalloc(sizeof(struct free_node_t), GFP_KERNEL);
		aml_chip->free_node[i]->index = i;
	}

	/*block status*/
	aml_chip->block_status =
		kzalloc((mtd->size >> chip->phys_erase_shift), GFP_KERNEL);
	if (aml_chip->block_status == NULL) {
		printk("no memory for flash block status\n");
		return -ENOMEM;
	}
	memset(aml_chip->block_status,
		0, (mtd->size >> chip->phys_erase_shift));

	aml_nand_rsv_info_size_fill(mtd);

	for (i = 0; i < ARRAY_SIZE(info); i++) {
		rsv_info = &info[i].rsv_info;
		ret = aml_nand_rsv_info_alloc_init(mtd, info[i].name,
						   &rsv_info,
						   info[i].blocks,
						   info[i].size);
		if (ret) {
			printk("%s info alloc init failed\n", info[i].name);
			return ret;
		}
		printk("%s=%d\n", info[i].name, info[i].rsv_info.start_block);
	}

	aml_nand_rsv_info_ptr_fill(mtd);

	printk("bbt_start=%d ", aml_chip->aml_nandbbt_info->start_block);
#ifndef CONFIG_ENV_IS_IN_NAND
	printk("env_start=%d ", aml_chip->aml_nandenv_info->start_block);
#endif
	printk("key_start=%d ", aml_chip->aml_nandkey_info->start_block);
	printk("dtb_start=%d ", aml_chip->aml_nanddtb_info->start_block);
	printk("ddr_start=%d ", aml_chip->aml_nandddr_info->start_block);
	printk("\n");

	return 0;
}

int aml_nand_free_rsv_info(struct mtd_info *mtd,
	struct aml_nandrsv_info_t *nandrsv_info)
{
	struct free_node_t *tmp_node, *next_node = NULL;
	int error = 0;
	loff_t addr = 0;
	int page, chipnr;
	struct nand_chip *chip = mtd->priv;

	pr_info("free %s\n", nandrsv_info->name);

	if (nandrsv_info->valid) {
		addr = nandrsv_info->valid_node->phy_blk_addr;
		addr *= mtd->erasesize;
		_aml_rsv_disprotect();
		//error = mtd->_erase(mtd, &erase_info);
		page = (int)(addr >> chip->page_shift);
		chipnr = (int)(addr >> chip->chip_shift);
		chip->select_chip(mtd, chipnr);
		chip->erase_cmd(mtd, page & chip->pagemask);
		error = chip->waitfunc(mtd, chip);
		if (error & NAND_STATUS_FAIL)
			error = -EIO;
		else
			error = 0;
		chip->select_chip(mtd, -1);
		_aml_rsv_protect();
		pr_info("erasing valid info block: %llx\n", addr);
		nandrsv_info->valid_node->phy_blk_addr = -1;
		nandrsv_info->valid_node->ec = -1;
		nandrsv_info->valid_node->phy_page_addr = 0;
		nandrsv_info->valid_node->timestamp = 0;
		nandrsv_info->valid_node->status = 0;
		nandrsv_info->valid = 0;
	}
	tmp_node = nandrsv_info->free_node;
	while (tmp_node != NULL) {
		next_node = tmp_node->next;
		release_free_node(mtd, tmp_node);
		tmp_node = next_node;
	}
	nandrsv_info->free_node = NULL;

	return error;
}

int aml_nand_scan_rsv_info(struct mtd_info *mtd,
	struct aml_nandrsv_info_t *nandrsv_info)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	struct nand_chip *chip = &aml_chip->chip;
	struct oobinfo_t *oobinfo;
	struct free_node_t *free_node, *tmp_node = NULL;
	unsigned char oob_buf[sizeof(struct oobinfo_t)];
	loff_t offset;
	unsigned char *data_buf, good_addr[256] = {0};
	int start_blk, max_scan_blk, i , k, scan_status = 0, env_status=0;
	int phys_erase_shift, pages_per_blk, page_num;
	int error = 0, ret = 0;
	int page, realpage, chipnr;

	data_buf = aml_chip->rsv_data_buf;
	oobinfo = (struct oobinfo_t *)oob_buf;

RE_RSV_INFO_EXT:
	memset(good_addr, 0 , 256);
	max_scan_blk = nandrsv_info->end_block;
	start_blk = nandrsv_info->start_block;
	printk("%s: info size=0x%x max_scan_blk=%d, start_blk=%d\n",
		nandrsv_info->name, nandrsv_info->size, max_scan_blk, start_blk);

	do {
	offset = mtd->erasesize;
	offset *= start_blk;
	scan_status = 0;
RE_RSV_INFO:

	memset((unsigned char *)data_buf,
		0x0, mtd->writesize);
	memset((unsigned char *)oob_buf,
		0x0, sizeof(struct oobinfo_t));

	//error = mtd->_read_oob(mtd, offset, &aml_oob_ops);
	realpage = (int)(offset >> chip->page_shift);
	page = realpage & chip->pagemask;
	chipnr = (int)(offset >> chip->chip_shift);

	chip->select_chip(mtd, chipnr);
	chip->cmdfunc(mtd, NAND_CMD_READ0, 0x00, page);
	error = chip->ecc.read_page(mtd, chip, data_buf,
							  1, page);
	chip->select_chip(mtd, -1);
	if ((error != 0) && (error != -EUCLEAN)) {
		printk("blk check good but read failed: %llx, %d\n",
			(uint64_t)offset, error);
		offset += nandrsv_info->size;
		if ((scan_status++ > 6) || (!(offset % mtd->erasesize))) {
			printk("ECC error, scan ONE block exit\n");
			scan_status = 0;
			continue;
		}
		goto RE_RSV_INFO;
	}

	memcpy(oob_buf, chip->oob_poi, mtd->oobavail);
	nandrsv_info->init = 1;
	nandrsv_info->valid_node->status = 0;
	if (!memcmp(oobinfo->name, nandrsv_info->name, 4)) {
		nandrsv_info->valid = 1;
		if (nandrsv_info->valid_node->phy_blk_addr >= 0) {
			free_node = get_free_node(mtd);
			if (free_node == NULL)
				return -ENOMEM;

			free_node->dirty_flag = 1;
	if (oobinfo->timestamp > nandrsv_info->valid_node->timestamp) {
				free_node->phy_blk_addr =
				nandrsv_info->valid_node->phy_blk_addr;
				free_node->ec =
				nandrsv_info->valid_node->ec;
				nandrsv_info->valid_node->phy_blk_addr =
				start_blk;
				nandrsv_info->valid_node->phy_page_addr=
					0;
				nandrsv_info->valid_node->ec =
					oobinfo->ec;
				nandrsv_info->valid_node->timestamp =
					oobinfo->timestamp;
			} else {
				free_node->phy_blk_addr = start_blk;
				free_node->ec = oobinfo->ec;
			}
			if (nandrsv_info->free_node == NULL)
				nandrsv_info->free_node = free_node;
			else {
				tmp_node = nandrsv_info->free_node;
				while (tmp_node->next != NULL) {
					tmp_node = tmp_node->next;
				}
				tmp_node->next = free_node;
			}
		} else {
			nandrsv_info->valid_node->phy_blk_addr =
				start_blk;
			nandrsv_info->valid_node->phy_page_addr = 0;
			nandrsv_info->valid_node->ec = oobinfo->ec;
			nandrsv_info->valid_node->timestamp =
				oobinfo->timestamp;
		}
	} else {
		free_node = get_free_node(mtd);
		if (free_node == NULL)
			return -ENOMEM;
		free_node->phy_blk_addr = start_blk;
		free_node->ec = oobinfo->ec;
		if (nandrsv_info->free_node == NULL)
			nandrsv_info->free_node = free_node;
		else {
			tmp_node = nandrsv_info->free_node;
			while (tmp_node->next != NULL) {
				tmp_node = tmp_node->next;
			}
			tmp_node->next = free_node;
		}
	}
	} while ((++start_blk) < max_scan_blk);

	printk("%s : phy_blk_addr=%d, ec=%d, phy_page_addr=%d, timestamp=%d\n",
		nandrsv_info->name,
		nandrsv_info->valid_node->phy_blk_addr,
		nandrsv_info->valid_node->ec,
		nandrsv_info->valid_node->phy_page_addr,
		nandrsv_info->valid_node->timestamp);
	printk("%s free list: \n", nandrsv_info->name);
	tmp_node = nandrsv_info->free_node;
	while (tmp_node != NULL) {
		printk("blockN=%d, ec=%d, dirty_flag=%d\n",
			tmp_node->phy_blk_addr,
			tmp_node->ec,
			tmp_node->dirty_flag);
		tmp_node = tmp_node->next;
	}

	/*second stage*/
	phys_erase_shift = fls(mtd->erasesize) - 1;
	pages_per_blk = (1 << (phys_erase_shift - chip->page_shift));
	page_num = nandrsv_info->size / mtd->writesize;
	if (page_num == 0)
		page_num++;

	printk("%s %d: page_num=%d\n", __func__, __LINE__, page_num);

	if (nandrsv_info->valid == 1) {
	printk("%s %d\n", __func__, __LINE__);

	for (i = 0; i < pages_per_blk; i++) {
		memset((unsigned char *)data_buf,
			0x0, mtd->writesize);
		memset((unsigned char *)oob_buf,
			0x0, sizeof(struct oobinfo_t));

		offset = nandrsv_info->valid_node->phy_blk_addr;
		offset *= mtd->erasesize;
		offset += i * mtd->writesize;
		//error = mtd->_read_oob(mtd, offset, &aml_oob_ops);
		realpage = (int)(offset >> chip->page_shift);
		page = realpage & chip->pagemask;
		chipnr = (int)(offset >> chip->chip_shift);

		chip->select_chip(mtd, chipnr);
		chip->cmdfunc(mtd, NAND_CMD_READ0, 0x00, page);
		error = chip->ecc.read_page(mtd, chip, data_buf,
								  1, page);
		chip->select_chip(mtd, -1);
		if ((error != 0) && (error != -EUCLEAN)) {
			printk("blk good but read failed:%llx,%d\n",
				(uint64_t)offset, error);
			nandrsv_info->valid_node->status |= ECC_ABNORMAL_FLAG;
			ret = -1;
			continue;
		}

		memcpy(oob_buf, chip->oob_poi, mtd->oobavail);
		if (!memcmp(oobinfo->name, nandrsv_info->name, 4)) {
			good_addr[i] = 1;
			nandrsv_info->valid_node->phy_page_addr = i;
		} else
			break;
	}
	}

	if ((mtd->writesize<nandrsv_info->size) && (nandrsv_info->valid ==1)) {
		i = nandrsv_info->valid_node->phy_page_addr;
		if (((i + 1) % page_num) != 0) {
			ret = -1;
			nandrsv_info->valid_node->status |= POWER_ABNORMAL_FLAG;
			printk("find %s incomplete\n", nandrsv_info->name);
		}
		if (ret == -1) {
			for (i = 0; i < (pages_per_blk / page_num); i++) {
				env_status =0;
				for (k = 0; k < page_num; k++) {
					if (!good_addr[ k + i * page_num]) {
						env_status = 1;
						break;
					}
				}
				if (!env_status) {
					printk("find %d page ok\n", i*page_num);
					nandrsv_info->valid_node->phy_page_addr=
						k + i * page_num -1;
					ret = 0;
				}
			}
		}
		if (ret == -1) {
			nandrsv_info->valid_node->status = 0;
			aml_nand_free_rsv_info(mtd, nandrsv_info);
			goto RE_RSV_INFO_EXT;
		}
		i = (nandrsv_info->size + mtd->writesize - 1) / mtd->writesize;
		nandrsv_info->valid_node->phy_page_addr -= (i - 1);
	}

	if (nandrsv_info->valid != 1)
		ret = -1;

	offset = nandrsv_info->valid_node->phy_blk_addr;
	offset *= mtd->erasesize;
	offset += nandrsv_info->valid_node->phy_page_addr * mtd->writesize;
	printk("%s valid addr: %llx\n", nandrsv_info->name, (uint64_t)offset);
	return ret;
}

int aml_nand_rsv_info_check_except_bbt(struct mtd_info *mtd)
{
	int ret = 0, i;

	for (i = ENV_INFO_INDEX; i < ARRAY_SIZE(info); i++) {
		ret = aml_nand_scan_rsv_info(mtd, &info[i].rsv_info);
		if (ret !=0 && ret != -1)
			printk("%s %d\n", __func__, __LINE__);
		if (info[i].rsv_info.valid == 0)
			printk("%s %d NO %s exist\n",
			       __func__, __LINE__, info[i].name);
	}

	return ret;
}

int aml_nand_bbt_check(struct mtd_info *mtd)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	struct aml_nand_chip *aml_chip_boot = mtd_to_nand_chip(&nand_info[0]);
	int phys_erase_shift;
	int ret =0;
	int8_t *buf = NULL;

	phys_erase_shift = fls(mtd->erasesize) - 1;
	ret = aml_nand_scan_rsv_info(mtd, aml_chip->aml_nandbbt_info);
	if ((ret !=0) && ((ret != (-1)))) {
		printk("%s %d\n", __func__, __LINE__);
		goto exit_error;
	}

	ret = 0;
	buf = aml_chip->block_status;
	if (aml_chip->aml_nandbbt_info->valid == 1) {
		/*read bbt*/
		printk("%s %d bbt is valid, reading.\n", __func__, __LINE__);
		aml_nand_read_rsv_info(mtd,
			aml_chip->aml_nandbbt_info, 0, (u_char *)buf);
	} else {
		printk("%s %d bbt is invalid, scanning.\n", __func__, __LINE__);
		/*no bbt haven't been found, abnormal or clean nand! rebuild*/
		aml_chip->nand_bbt_info =
			kzalloc(sizeof(struct aml_nand_bbt_info), GFP_KERNEL);
		if (!aml_chip->nand_bbt_info) {
			ret = -ENOMEM;
			goto exit_error;
		}
		memset(aml_chip->block_status,
			0, (mtd->size >> phys_erase_shift));
		aml_nand_scan_shipped_bbt(mtd);
		aml_nand_ext_save_rsv_info(mtd,
			aml_chip->aml_nandbbt_info, (u_char *)buf);
		if (aml_chip->nand_bbt_info)
			kfree(aml_chip->nand_bbt_info);
	}

	/*make uboot bbt perspective the same with normal bbt*/
	aml_chip_boot->block_status = aml_chip->block_status;
exit_error:
	return ret;
}

int aml_nand_scan_bbt(struct mtd_info *mtd)
{
	return 0;
}

