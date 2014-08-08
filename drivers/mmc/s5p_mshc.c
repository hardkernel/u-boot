/*
 * Copyright 2007, Freescale Semiconductor, Inc
 * Andy Fleming
 *
 * Based vaguely on the pxa mmc code:
 * (C) Copyright 2003
 * Kyle Harris, Nexus Technologies, Inc. kharris@nexus-tech.net
 *
 * (C) Copyright 2011 Samsung Electronics Co. Ltd
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */

#include <config.h>
#include <common.h>
#include <command.h>
#include <part.h>
#include <malloc.h>
#include <asm/io.h>
#include <asm/arch/cpu.h>
#include <asm/arch/mmc.h>
#include <asm/arch/clk.h>

#include "s5p_mshc.h"

DECLARE_GLOBAL_DATA_PTR;
//#define DEBUG_S5P_MSHC
#ifdef DEBUG_S5P_MSHC
#define dbg(x...)       printf(x)
#else
#define dbg(x...)       do { } while (0)
#endif

#ifndef mdelay
#define mdelay(x)	udelay(1000*x)
#endif

#define MHZ	1000000
#define KHZ	1000

struct mmc mshc_channel[MMC_MAX_CHANNEL];

struct mshci_host mshc_host[MMC_MAX_CHANNEL];

/* it can cover to transfer 256MB at a time */
static struct mshci_idmac idmac_desc[0x10000];

extern unsigned int OmPin;

static void mshci_dumpregs_err(struct mshci_host *host)
{
	dbg("mshci: ============== REGISTER DUMP ==============\n");
	dbg("mshci: MSHCI_CTRL:      0x%08x\n",
		mshci_readl(host, MSHCI_CTRL));
	dbg("mshci: MSHCI_PWREN:     0x%08x\n",
		mshci_readl(host, MSHCI_PWREN));
	dbg("mshci: MSHCI_CLKDIV:    0x%08x\n",
		mshci_readl(host, MSHCI_CLKDIV));
	dbg("mshci: MSHCI_CLKSRC:    0x%08x\n",
		mshci_readl(host, MSHCI_CLKSRC));
	dbg("mshci: MSHCI_CLKENA:    0x%08x\n",
		mshci_readl(host, MSHCI_CLKENA));
	dbg("mshci: MSHCI_TMOUT:     0x%08x\n",
		mshci_readl(host, MSHCI_TMOUT));
	dbg("mshci: MSHCI_CTYPE:     0x%08x\n",
		mshci_readl(host, MSHCI_CTYPE));
	dbg("mshci: MSHCI_BLKSIZ:    0x%08x\n",
		mshci_readl(host, MSHCI_BLKSIZ));
	dbg("mshci: MSHCI_BYTCNT:    0x%08x\n",
		mshci_readl(host, MSHCI_BYTCNT));
	dbg("mshci: MSHCI_INTMSK:    0x%08x\n",
		mshci_readl(host, MSHCI_INTMSK));
	dbg("mshci: MSHCI_CMDARG:    0x%08x\n",
		mshci_readl(host, MSHCI_CMDARG));
	dbg("mshci: MSHCI_CMD:       0x%08x\n",
		mshci_readl(host, MSHCI_CMD));
	dbg("mshci: MSHCI_MINTSTS:   0x%08x\n",
		mshci_readl(host, MSHCI_MINTSTS));
	dbg("mshci: MSHCI_RINTSTS:   0x%08x\n",
		mshci_readl(host, MSHCI_RINTSTS));
	dbg("mshci: MSHCI_STATUS:    0x%08x\n",
		mshci_readl(host, MSHCI_STATUS));
	dbg("mshci: MSHCI_FIFOTH:    0x%08x\n",
		mshci_readl(host, MSHCI_FIFOTH));
	dbg("mshci: MSHCI_CDETECT:   0x%08x\n",
		mshci_readl(host, MSHCI_CDETECT));
	dbg("mshci: MSHCI_WRTPRT:    0x%08x\n",
		mshci_readl(host, MSHCI_WRTPRT));
	dbg("mshci: MSHCI_GPIO:      0x%08x\n",
		mshci_readl(host, MSHCI_GPIO));
	dbg("mshci: MSHCI_TCBCNT:    0x%08x\n",
		mshci_readl(host, MSHCI_TCBCNT));
	dbg("mshci: MSHCI_TBBCNT:    0x%08x\n",
		mshci_readl(host, MSHCI_TBBCNT));
	dbg("mshci: MSHCI_DEBNCE:    0x%08x\n",
		mshci_readl(host, MSHCI_DEBNCE));
	dbg("mshci: MSHCI_USRID:     0x%08x\n",
		mshci_readl(host, MSHCI_USRID));
	dbg("mshci: MSHCI_VERID:     0x%08x\n",
		mshci_readl(host, MSHCI_VERID));
	dbg("mshci: MSHCI_HCON:      0x%08x\n",
		mshci_readl(host, MSHCI_HCON));
	dbg("mshci: MSHCI_UHS_REG:   0x%08x\n",
		mshci_readl(host, MSHCI_UHS_REG));
	dbg("mshci: MSHCI_BMOD:      0x%08x\n",
		mshci_readl(host, MSHCI_BMOD));
	dbg("mshci: MSHCI_PLDMND:   0x%08x\n",
		mshci_readl(host, MSHCI_PLDMND));
	dbg("mshci: MSHCI_DBADDR:    0x%08x\n",
		mshci_readl(host, MSHCI_DBADDR));
	dbg("mshci: MSHCI_IDSTS:     0x%08x\n",
		mshci_readl(host, MSHCI_IDSTS));
	dbg("mshci: MSHCI_IDINTEN:   0x%08x\n",
		mshci_readl(host, MSHCI_IDINTEN));
	dbg("mshci: MSHCI_DSCADDR:   0x%08x\n",
		mshci_readl(host, MSHCI_DSCADDR));
	dbg("mshci: MSHCI_BUFADDR:   0x%08x\n",
		mshci_readl(host, MSHCI_BUFADDR));
	dbg("mshci: MSHCI_WAKEUPCON: 0x%08x\n",
		mshci_readl(host, MSHCI_WAKEUPCON));
	dbg("mshci: MSHCI_CLOCKCON:  0x%08x\n",
		mshci_readl(host, MSHCI_CLOCKCON));
	dbg("mshci: MSHCI_FIFODAT:   0x%08x\n",
		mshci_readl(host, MSHCI_FIFODAT(host->data_offset)));
	dbg("mshci: ===========================================\n");
}

static void mshci_reset_ciu(struct mshci_host *host)
{
	u32 timeout = 100;
	u32 ier;

	ier = readl(host->ioaddr + MSHCI_CTRL);
	ier |= CTRL_RESET;

	writel(ier, host->ioaddr + MSHCI_CTRL);

	while (readl(host->ioaddr + MSHCI_CTRL) & CTRL_RESET) {
		if (timeout == 0) {
			printf("Reset CTRL never completed.\n");
			return;
		}
		timeout--;
		mdelay(1);
	}
}

static void mshci_reset_fifo(struct mshci_host *host)
{
	u32 timeout = 100;
	u32 ier;

	ier = readl(host->ioaddr + MSHCI_CTRL);
	ier |= FIFO_RESET;

	writel(ier, host->ioaddr + MSHCI_CTRL);
	while (readl(host->ioaddr + MSHCI_CTRL) & FIFO_RESET) {
		if (timeout == 0) {
			printf("Reset FIFO never completed.\n");
			return;
		}
		timeout--;
		mdelay(1);
	}
}

static void mshci_reset_dma(struct mshci_host *host)
{
	u32 timeout = 100;
	u32 ier;

	ier = readl(host->ioaddr + MSHCI_CTRL);
	ier |= DMA_RESET;

	writel(ier, host->ioaddr + MSHCI_CTRL);
	while (readl(host->ioaddr + MSHCI_CTRL) & DMA_RESET) {
		if (timeout == 0) {
			printf("Reset DMA never completed.\n");
			return;
		}
		timeout--;
		mdelay(1);
	}
}

static void mshci_reset_all(struct mshci_host *host)
{
	int count;

	/* Wait max 100 ms */
	count = 10000;

	/* before reset ciu, it should check DATA0. if when DATA0 is low and
	it resets ciu, it might make a problem */
	while (mshci_readl(host, MSHCI_STATUS) & (1 << 9)) {
		printf("Count: %d\n", count);
		if (count == 0) {
			printf("Controller never released \
				data0 before reset ciu.\n");
			return;
		}
		count--;
		udelay(10);
	}

	mshci_reset_ciu(host);
	mshci_reset_fifo(host);
	mshci_reset_dma(host);
}



static void mshci_set_mdma_desc(u8 *desc_vir, u8 *desc_phy,
				u32 des0, u32 des1, u32 des2)
{
	((struct mshci_idmac *)(desc_vir))->des0 = des0;
	((struct mshci_idmac *)(desc_vir))->des1 = des1;
	((struct mshci_idmac *)(desc_vir))->des2 = des2;
	((struct mshci_idmac *)(desc_vir))->des3 = (u32)desc_phy +
					sizeof(struct mshci_idmac);
}


static void mshci_prepare_data(struct mshci_host *host, struct mmc_data *data)
{
	u32 i;
	u32 data_cnt;
	u32 des_flag;
	u32 blksz;

	struct mshci_idmac *pdesc_dmac;

	mshci_reset_fifo(host);

	pdesc_dmac = idmac_desc;

	blksz = data->blocksize;
	data_cnt = data->blocks;

	for (i = 0;; i++) {
		des_flag = (MSHCI_IDMAC_OWN | MSHCI_IDMAC_CH);
		des_flag |= (i == 0) ? MSHCI_IDMAC_FS : 0;
		if (data_cnt <= 8) {
			des_flag |= MSHCI_IDMAC_LD;
			mshci_set_mdma_desc((u8 *)pdesc_dmac,
				(u8 *)virt_to_phys((u32)pdesc_dmac),
				des_flag, blksz * data_cnt,
				(u32)(virt_to_phys((u32)data->dest))
				+ (u32)(i * 0x1000));
			break;
		}
		/* max transfer size is 4KB per a description. */
		mshci_set_mdma_desc((u8 *)pdesc_dmac,
			(u8 *)virt_to_phys((u32)pdesc_dmac),
			des_flag, blksz * 8,
			virt_to_phys((u32)data->dest) + (u32)(i * 0x1000));

		data_cnt -= 8;
		pdesc_dmac++;
	}

	writel((u32)virt_to_phys((u32)idmac_desc),
		host->ioaddr + MSHCI_DBADDR);

	if (data->blocks > 1)
		writel(readl(host->ioaddr + MSHCI_CTRL) | SEND_AS_CCSD,
			host->ioaddr + MSHCI_CTRL);

	/* enable DMA, IDMAC */
	writel((readl(host->ioaddr + MSHCI_CTRL) |
		ENABLE_IDMAC|DMA_ENABLE), host->ioaddr + MSHCI_CTRL);
	writel((readl(host->ioaddr + MSHCI_BMOD) |
		(BMOD_IDMAC_ENABLE|BMOD_IDMAC_FB)),
		host->ioaddr + MSHCI_BMOD);

	writel(data->blocksize, host->ioaddr + MSHCI_BLKSIZ);
	writel((data->blocksize * data->blocks), host->ioaddr + MSHCI_BYTCNT);

}

static int mshci_set_transfer_mode(struct mshci_host *host,
	struct mmc_data *data)
{
	int mode = 0;

	/* this cmd has data to transmit */
	mode |= CMD_DATA_EXP_BIT;
#if defined(CONFIG_SKIP_MMC_STOP_CMD)
	if (data->blocks > 1)
		mode |= CMD_SENT_AUTO_STOP_BIT;
#endif
	if (data->flags & MMC_DATA_WRITE)
		mode |= CMD_RW_BIT;

	return mode;
}

#define COMMAND_TIMEOUT (0x200000)

/*
 * Sends a command out on the bus.  Takes the mmc pointer,
 * a command pointer, and an optional data pointer.
 */
static int
s5p_mshc_send_command(struct mmc *mmc, struct mmc_cmd *cmd,
			struct mmc_data *data)
{
	struct mshci_host *host = mmc->priv;

	int flags = 0, i;
	u32 mask;
	unsigned long timeout;

	/* Wait max 1000 ms */
	timeout = 1000;

	/*We shouldn't wait for data inihibit for stop commands, even
	 * though they might use busy signaling */
	while (mshci_readl(host, MSHCI_STATUS) & (1 << 9)) {
		if (timeout == 0) {
			printf("Controller never released data busy!!\n");
			return -1;
		}
		timeout--;
		mdelay(1);
	}

	if (mshci_readl(host, MSHCI_RINTSTS)) {
		if (mshci_readl(host, MSHCI_RINTSTS) &
			~((0xffff << 16) | (1 << 2) | (1 << 14)))
			printf("there are pending interrupts 0x%08x\n",
				mshci_readl(host, MSHCI_RINTSTS));
	}
	/* It clears all pending interrupts before sending a command*/
	mshci_writel(host, INTMSK_ALL, MSHCI_RINTSTS);

	if (data)
		mshci_prepare_data(host, data);

	dbg("CMD[%2d]\t", cmd->cmdidx);
	dbg("ARG: %08x\n", cmd->cmdarg);

	writel(cmd->cmdarg, host->ioaddr + MSHCI_CMDARG);

	if (data)
		flags = mshci_set_transfer_mode(host, data);

	if ((cmd->resp_type & MMC_RSP_136) && (cmd->resp_type & MMC_RSP_BUSY))
		/* this is out of SD spec */
		return -1;

	if (cmd->resp_type & MMC_RSP_PRESENT) {
		flags |= CMD_RESP_EXP_BIT;
		if (cmd->resp_type & MMC_RSP_136)
			flags |= CMD_RESP_LENGTH_BIT;
	}

	if (cmd->resp_type & MMC_RSP_CRC)
		flags |= CMD_CHECK_CRC_BIT;

	flags |= (cmd->cmdidx | CMD_STRT_BIT |
		host->use_hold_reg | CMD_WAIT_PRV_DAT_BIT);

	mask = mshci_readl(host, MSHCI_CMD);
	if (mask & CMD_STRT_BIT)
		printf("[ERROR] CMD busy. current cmd %d. last cmd reg 0x%x\n",
			cmd->cmdidx, mask);

	mshci_writel(host, flags, MSHCI_CMD);

	/* wait for command complete by busy waiting. */
	for (i = 0; i < COMMAND_TIMEOUT; i++) {
		mask = readl(host->ioaddr + MSHCI_RINTSTS);
		if (mask & INTMSK_CDONE) {
			if (!data)
				writel(mask, host->ioaddr + MSHCI_RINTSTS);
			break;
		}
	}

	/* timeout for command complete. */
	if (COMMAND_TIMEOUT == i) {
		printf("FAIL: waiting for status update.\n");
		return TIMEOUT;
	}

	if (mask & INTMSK_RTO) {
		if (((cmd->cmdidx == 8 || cmd->cmdidx == 41 ||
			cmd->cmdidx == 55)) == 0) {
			printf("[ERROR] response timeout error : %08x cmd %d\n",
			mask, cmd->cmdidx);
		}
			return TIMEOUT;
	} else if (mask & INTMSK_RE) {
		printf("[ERROR] response error : %08x cmd %d\n",
			mask, cmd->cmdidx);
		return -1;
	}

	if (cmd->resp_type & MMC_RSP_PRESENT) {
		if (cmd->resp_type & MMC_RSP_136) {
			/* CRC is stripped so we need to do some shifting. */
			cmd->response[0] = mshci_readl(host, MSHCI_RESP3);
			cmd->response[1] = mshci_readl(host, MSHCI_RESP2);
			cmd->response[2] = mshci_readl(host, MSHCI_RESP1);
			cmd->response[3] = mshci_readl(host, MSHCI_RESP0);
			dbg("\tcmd->response[0]: 0x%08x\n", cmd->response[0]);
			dbg("\tcmd->response[1]: 0x%08x\n", cmd->response[1]);
			dbg("\tcmd->response[2]: 0x%08x\n", cmd->response[2]);
			dbg("\tcmd->response[3]: 0x%08x\n", cmd->response[3]);
		} else {
			cmd->response[0] = readl(host->ioaddr + MSHCI_RESP0);
			dbg("\tcmd->response[0]: 0x%08x\n", cmd->response[0]);
		}
	}

	if (data) {
		while (!(mask & (DATA_ERR | DATA_TOUT | INTMSK_DTO)))
			mask = readl(host->ioaddr + MSHCI_RINTSTS);

		writel(mask, host->ioaddr + MSHCI_RINTSTS);
		if (mask & (DATA_ERR | DATA_TOUT)) {
			printf("error during transfer: 0x%08x\n", mask);

			/* make sure disable IDMAC and IDMAC_Interrupts */
			mshci_writel(host, (mshci_readl(host, MSHCI_CTRL) &
				~(DMA_ENABLE|ENABLE_IDMAC)), MSHCI_CTRL);
			/* mask all interrupt source of IDMAC */
			mshci_writel(host, 0x0, MSHCI_IDINTEN);

			return -1;
		} else if (mask & INTMSK_DTO)
			dbg("MSHCI_INT_DMA_END\n");
		else
			printf("unexpected condition 0x%x\n", mask);

		/* make sure disable IDMAC and IDMAC_Interrupts */
		mshci_writel(host, (mshci_readl(host, MSHCI_CTRL) &
			~(DMA_ENABLE|ENABLE_IDMAC)), MSHCI_CTRL);
		/* mask all interrupt source of IDMAC */
		mshci_writel(host, 0x0, MSHCI_IDINTEN);
	}
	return 0;
}

static void mshci_clock_onoff(struct mshci_host *host, int val)
{
	u32 loop_count = 0x100000;

	if (val) {
		mshci_writel(host, (0x1 << 0), MSHCI_CLKENA);
		mshci_writel(host, 0, MSHCI_CMD);
		mshci_writel(host, CMD_ONLY_CLK, MSHCI_CMD);
		do {
			if (!(mshci_readl(host, MSHCI_CMD) & CMD_STRT_BIT))
				break;
			loop_count--;
		} while (loop_count);
	} else {
		mshci_writel(host, (0x0 << 0), MSHCI_CLKENA);
		mshci_writel(host, 0, MSHCI_CMD);
		mshci_writel(host, CMD_ONLY_CLK, MSHCI_CMD);
		do {
			if (!(mshci_readl(host, MSHCI_CMD) & CMD_STRT_BIT))
				break;
			loop_count--;
		} while (loop_count);
	}
	if (loop_count == 0)
		printf("Clock %s has been failed.\n ", val ? "ON" : "OFF");
}

static void mshci_change_clock(struct mshci_host *host, uint clock)
{
	int div, dev_index;
	u32 mpll_clock;
	u32 div_mmc, div_mmc_pre, sclk_mmc;
	u32 loop_count;

	if (clock == 0)
		return;

	/* befor changing clock. clock needs to be off. */
	mshci_clock_onoff(host, CLK_DISABLE);

	/* If Input clock is high more than MAXUMUM CLK */
	if (clock > host->max_clk) {
		dbg("Input CLK is too high. CLK: %dMHz\n", clock / MHZ);
		clock = host->max_clk;
		dbg("Set CLK to %dMHz\n", clock / MHZ);
	}

	/* Calculate SCLK_MMCx */
	dev_index = host->dev_index;
	sclk_mmc = get_mmc_clk(dev_index);

	dbg("sclk_mmc: %dKHz\n", sclk_mmc / KHZ);
	dbg("Phase Shift CLK: %dKHz\n", (sclk_mmc / host->phase_devide) / KHZ);

	/* CLKDIV */
	for (div = 1 ; div <= 0xFF; div++) {
		if (((sclk_mmc / host->phase_devide) / (2 * div)) <= clock) {
			mshci_writel(host, div, MSHCI_CLKDIV);
			break;
		}
	}
	dbg("div: %08d\n", div);
	dbg("CLOCK:: %dKHz\n",
		((sclk_mmc / host->phase_devide) / (div * 2)) / KHZ);

	mshci_writel(host, div, MSHCI_CLKDIV);

	mshci_writel(host, 0, MSHCI_CMD);
	mshci_writel(host, CMD_ONLY_CLK, MSHCI_CMD);
	loop_count = 0x10000000;

	do {
		if (!(mshci_readl(host, MSHCI_CMD) & CMD_STRT_BIT))
			break;
		loop_count--;
	} while (loop_count);

	if (loop_count == 0)
		printf("Changing clock has been failed.\n ");

	mshci_writel(host, mshci_readl(host, MSHCI_CMD)&(~CMD_SEND_CLK_ONLY),
					MSHCI_CMD);
	mshci_clock_onoff(host, CLK_ENABLE);
	host->clock = clock;

	return;
}

static void s5p_mshc_set_ios(struct mmc *mmc)
{
	struct mshci_host *host = mmc->priv;
	u32 mode = 0;

	if (mmc->clock > 0)
		mshci_change_clock(host, mmc->clock);

	if (mmc->bus_width == 0x8) {
		dbg("MMC_BUS_WIDTH_8\n");
		mshci_writel(host, (0x1<<16), MSHCI_CTYPE);
		mode = (mmc->card_caps) & MMC_MODE_DDR;
	} else if (mmc->bus_width == 0x4) {
		dbg("MMC_BUS_WIDTH_4\n");
		mshci_writel(host, (0x1<<0), MSHCI_CTYPE);
		mode = (mmc->card_caps) & MMC_MODE_DDR;
	} else {
		dbg("BUS_WIDTH_1\n");
		mshci_writel(host, (0x0<<0), MSHCI_CTYPE);
	}

	/* Support DDR Mode */
	if (mode) {
		dbg("MMC DDR MODE\n");
		mshci_writel(host, (0x1<<16), MSHCI_UHS_REG);
	} else {
		dbg("MMC SDR MODE\n");
		mshci_writel(host,
				mshci_readl(host, MSHCI_UHS_REG) & ~(0x1<<16),
				MSHCI_UHS_REG);
	}

	if (host->version >= 0x240a) {
		if (mode) {
			dbg("Phase Shift Register: 0x%08x\n", host->ddr);
			mshci_writel(host, host->ddr, MSHCI_CLKSEL);
		} else {
			dbg("Phase Shift Register: 0x%08x\n", host->sdr);
			mshci_writel(host, host->sdr, MSHCI_CLKSEL);
		}
	}
}

static void mshci_fifo_init(struct mshci_host *host)
{
	int fifo_val, fifo_depth, fifo_threshold;

	fifo_val = mshci_readl(host, MSHCI_FIFOTH);

	fifo_depth = 0x20;

	fifo_threshold = fifo_depth / 2;

	dbg("FIFO WMARK FOR RX 0x%x TX 0x%x.\n",
		(fifo_threshold - 1), fifo_threshold);

	fifo_val &= ~(RX_WMARK | TX_WMARK | MSIZE_MASK);
	fifo_val |= (fifo_threshold | ((fifo_threshold - 1) << 16));
	fifo_val |= MSIZE_8;

	mshci_writel(host, fifo_val, MSHCI_FIFOTH);
}

static void mshci_init(struct mshci_host *host)
{
	/* Power Enable Register */
	mshci_writel(host, 1<<0, MSHCI_PWREN);

	mshci_reset_all(host);
	mshci_fifo_init(host);

	/* It clears all pending interrupts */
	mshci_writel(host, INTMSK_ALL, MSHCI_RINTSTS);
	/* It dose not use Interrupt. Disable all */
	mshci_writel(host, 0, MSHCI_INTMSK);
}

static int s5c_mshc_init(struct mmc *mmc)
{
	struct mshci_host *host = (struct mshci_host *)mmc->priv;
	u32 chip_version, main_rev, sub_rev;
	u32 ier;

#if defined(CONFIG_CPU_EXYNOS5420)
	if (host->dev_index != 2) {
		mshci_writel(host, 0, MSHCI_MPSBEGIN0);
		mshci_writel(host, 0xFFFFFFFF, MSHCI_MPSEND0);
		mshci_writel(host, MPSCTRL_SECURE_READ_BIT | MPSCTRL_SECURE_WRITE_BIT |
			MPSCTRL_NON_SECURE_READ_BIT | MPSCTRL_NON_SECURE_WRITE_BIT |
			MPSCTRL_VALID, MSHCI_MPSCTRL0);
	}
#endif

	host->version = GET_VERID(mshci_readl(host, MSHCI_VERID));
	dbg("MSHC version: %x\n", host->version);

	mshci_init(host);

	if (host->version >= 0x240a)
		host->data_offset = MSHCI_240A_FIFODAT;
	else
		host->data_offset = MSHCI_220A_FIFODAT;

	host->max_clk = mmc->f_max;
	host->phase_devide = PHASE_DEVIDER;

	if (host->version >= 0x240a)
		host->use_hold_reg = CMD_USE_HOLD_REG;

	/* MSHC Version check */
	if (host->version >= 0x240a) {
		chip_version = readl(0x10000000);
		main_rev = (0xF & (chip_version >> 4));
		sub_rev = (0xF & chip_version);
		dbg("AP REVISION: %d.%d\n", main_rev, sub_rev);
	}

	if (host->version >= 0x240a)
		mmc->host_caps = MMC_MODE_4BIT | MMC_MODE_8BIT |
			MMC_MODE_HS_52MHz | MMC_MODE_HS |
			MMC_MODE_HC | MMC_MODE_DDR;
	else
		mmc->host_caps = MMC_MODE_4BIT | MMC_MODE_8BIT |
			MMC_MODE_HS_52MHz | MMC_MODE_HS | MMC_MODE_HC;

	mshci_change_clock(host, 400000);

	/* Set auto stop command */
	ier = readl(host->ioaddr + MSHCI_CTRL);
	ier |= (1<<10);
	writel(ier, host->ioaddr + MSHCI_CTRL);

	/* set debounce filter value*/
	mshci_writel(host, 0xfffff, MSHCI_DEBNCE);

	/* clear card type. set 1bit mode */
	mshci_writel(host, 0x0, MSHCI_CTYPE);

	/* set bus mode register for IDMAC */
	mshci_writel(host, BMOD_IDMAC_RESET, MSHCI_BMOD);

	/* disable all interrupt source of IDMAC */
	mshci_writel(host, 0x0, MSHCI_IDINTEN);

	/* set max timeout */
	writel(0xffffffff, host->ioaddr + MSHCI_TMOUT);

	return 0;
}

int s5p_mshc_init(unsigned int regbase, unsigned int channel)
{
	struct mmc *mmc;
	mmc = &mshc_channel[channel];

	sprintf(mmc->name, "S5P_MSHC%d", channel);
	mmc->priv = &mshc_host[channel];
	mmc->send_cmd = s5p_mshc_send_command;
	mmc->set_ios = s5p_mshc_set_ios;
	mmc->init = s5c_mshc_init;

	mmc->voltages = MMC_VDD_32_33 | MMC_VDD_33_34;
	mmc->f_min = 400000;
	mmc->f_max = 50000000;
	mshc_host[channel].clock = 0;
	mshc_host[channel].dev_index = channel;

	switch (channel) {
#ifdef USE_MMC0
	case 0:
		mshc_host[channel].ioaddr = (void *)regbase;
		mshc_host[channel].sdr = SDR_CH0;
		mshc_host[channel].ddr = DDR_CH0;
		break;
#endif
#ifdef USE_MMC2
	case 2:
		mshc_host[channel].ioaddr = (void *)regbase;
		mshc_host[channel].sdr = SDR_CH2;
		mshc_host[channel].ddr = DDR_CH2;
		break;
#endif
#ifdef USE_MMC3
	case 3:
		mshc_host[channel].ioaddr = (void *)regbase;
		break;
#endif
#ifdef USE_MMC4
	case 4:
		mshc_host[channel].ioaddr = (void *)regbase;
		mshc_host[channel].sdr = SDR_CH4;
		mshc_host[channel].ddr = DDR_CH4;
		break;
#endif
	default:
		printf("mmc err: not supported channel %d\n", channel);
	}

	return mmc_register(mmc);
}

