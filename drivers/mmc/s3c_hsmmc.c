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
#include <mmc.h>
#include <part.h>
#include <malloc.h>
#include <asm/io.h>
#include <asm/arch/cpu.h>
#include <asm/arch/s3c_hsmmc.h>

void set_hsmmc_pre_ratio (struct sdhci_host *host, uint clock);

void setup_sdhci0_cfg_card(struct sdhci_host *host);

DECLARE_GLOBAL_DATA_PTR;
//#define DEBUG_S3C_HSMMC
#ifdef DEBUG_S3C_HSMMC
#define dbg(x...)       printf(x)
#else
#define dbg(x...)       do { } while (0)
#endif

#ifndef printk
#define printk printf
#endif

#ifndef mdelay
#define mdelay(x)	udelay(1000*x)
#endif

struct mmc mmc_channel[MMC_MAX_CHANNEL];

struct sdhci_host mmc_host[MMC_MAX_CHANNEL];

static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_data *data)
{
	u8 ctrl;

	writeb(0xe, host->ioaddr + SDHCI_TIMEOUT_CONTROL);

	/*
	 * Always uses SDMA
	 */
 	dbg("data->dest: %08x\n", data->dest);
	writel(virt_to_phys((u32)data->dest), host->ioaddr + SDHCI_DMA_ADDRESS);

	ctrl = readb(host->ioaddr + SDHCI_HOST_CONTROL);
	ctrl &= ~SDHCI_CTRL_DMA_MASK;
	writeb(ctrl, host->ioaddr + SDHCI_HOST_CONTROL);

	/* We do not handle DMA boundaries, so set it to max (512 KiB) */
	writew(SDHCI_MAKE_BLKSZ(7, data->blocksize),
		host->ioaddr + SDHCI_BLOCK_SIZE);
	writew(data->blocks, host->ioaddr + SDHCI_BLOCK_COUNT);
}

static void sdhci_set_transfer_mode(struct sdhci_host *host,
	struct mmc_data *data)
{
	u16 mode;

	mode = SDHCI_TRNS_BLK_CNT_EN | SDHCI_TRNS_DMA;
	if (data->blocks > 1)
		mode |= SDHCI_TRNS_MULTI | SDHCI_TRNS_ACMD12;
	if (data->flags & MMC_DATA_READ)
		mode |= SDHCI_TRNS_READ;

	writew(mode, host->ioaddr + SDHCI_TRANSFER_MODE);
}

/*
 * Sends a command out on the bus.  Takes the mmc pointer,
 * a command pointer, and an optional data pointer.
 */
static int
s3c_hsmmc_send_command(struct mmc *mmc, struct mmc_cmd *cmd,
			struct mmc_data *data)
{
	struct sdhci_host *host = mmc->priv;

	int flags, i;
	u32 mask;
	unsigned long timeout;

	/* For Debug */
	dbg("CMD[%2d]\t",cmd->cmdidx);
	dbg("ARG: %08x\n",cmd->cmdarg);

	/* Wait max 10 ms */
	timeout = 10;

	mask = SDHCI_CMD_INHIBIT;
	if ((data != NULL) || (cmd->flags & MMC_RSP_BUSY))
		mask |= SDHCI_DATA_INHIBIT;

	/* We shouldn't wait for data inihibit for stop commands, even
	   though they might use busy signaling */
	if (data)
		mask &= ~SDHCI_DATA_INHIBIT;

	while (readl(host->ioaddr + SDHCI_PRESENT_STATE) & mask) {
		if (timeout == 0) {
			printk("Controller never released " \
				"inhibit bit(s).\n");
			return -1;
		}
		timeout--;
		mdelay(1);
	}

	if (data)
		sdhci_prepare_data(host, data);

	writel(cmd->cmdarg, host->ioaddr + SDHCI_ARGUMENT);

	if (data)
		sdhci_set_transfer_mode(host, data);

	if ((cmd->resp_type & MMC_RSP_136) && (cmd->resp_type & MMC_RSP_BUSY)) {
		return -100;
	}

	if (!(cmd->resp_type & MMC_RSP_PRESENT))
		flags = SDHCI_CMD_RESP_NONE;
	else if (cmd->resp_type & MMC_RSP_136)
		flags = SDHCI_CMD_RESP_LONG;
	else if (cmd->resp_type & MMC_RSP_BUSY)
		flags = SDHCI_CMD_RESP_SHORT_BUSY;
	else
		flags = SDHCI_CMD_RESP_SHORT;

	if (cmd->resp_type & MMC_RSP_CRC)
		flags |= SDHCI_CMD_CRC;
	if (cmd->resp_type & MMC_RSP_OPCODE)
		flags |= SDHCI_CMD_INDEX;
	if (data)
		flags |= SDHCI_CMD_DATA;

	writew(SDHCI_MAKE_CMD(cmd->cmdidx, flags),
		host->ioaddr + SDHCI_COMMAND);

	for (i=0; i<0x100000; i++) {
		mask = readl(host->ioaddr + SDHCI_INT_STATUS);
		if (mask & SDHCI_INT_RESPONSE) {
			if (!data)
				writel(mask, host->ioaddr + SDHCI_INT_STATUS);
			break;
		}
	}
	
	if (0x100000 == i) {
		printk("FAIL: waiting for status update.\n");
		return TIMEOUT;
	}

	if (mask & SDHCI_INT_TIMEOUT) {
		dbg("timeout: %08x cmd %d\n", mask, cmd->cmdidx);
		return TIMEOUT;
	}
	else if (mask & SDHCI_INT_ERROR) {
		printf("error: %08x cmd %d\n", mask, cmd->cmdidx);
		return -1;
	}
	
	if (cmd->resp_type & MMC_RSP_PRESENT) {
		if (cmd->resp_type & MMC_RSP_136) {
			/* CRC is stripped so we need to do some shifting. */
			for (i = 0;i < 4;i++) {
				cmd->response[i] = readl(host->ioaddr +
					SDHCI_RESPONSE + (3-i)*4) << 8;
				dbg("cmd->resp[%d]: %08x\n", i, cmd->response[i]);
				if (i != 3)
					cmd->response[i] |=
						readb(host->ioaddr +
						SDHCI_RESPONSE + (3-i)*4-1);
			}
		} else if (cmd->resp_type & MMC_RSP_BUSY) {
			for (i = 0;i < 0x100000; i++)
			{
				if (readl(host->ioaddr + SDHCI_PRESENT_STATE) & SDHCI_DATA_BIT(0))
					break;
				udelay(100);
			}
			if (0x100000 == i) {
				printk("FAIL: card is still busy\n");
				return TIMEOUT;
			}
							
			cmd->response[0] = readl(host->ioaddr + SDHCI_RESPONSE);
			dbg("cmd->resp[0]: %08x\n", cmd->response[i]);
		} else {
			cmd->response[0] = readl(host->ioaddr + SDHCI_RESPONSE);
			dbg("cmd->resp[0]: %08x\n", cmd->response[i]);
		}
	}

	if (data) {
		while (!(mask & (SDHCI_INT_DATA_END | SDHCI_INT_ERROR | SDHCI_INT_DMA_END))) {
			mask = readl(host->ioaddr + SDHCI_INT_STATUS);
		}
		writel(mask, host->ioaddr + SDHCI_INT_STATUS);
		if (mask & SDHCI_INT_ERROR) {
			printf("error during transfer: 0x%08x\n", mask);
			return -1;
		} else if (mask & SDHCI_INT_DMA_END) {
			printf("SDHCI_INT_DMA_END\n");
		} else {		
			dbg("r/w is done\n");
		}
	}

	mdelay(1);
	return 0;
}

static void sdhci_change_clock(struct sdhci_host *host, uint clock)
{
	u16 clk;
	unsigned long timeout;
	u32 ctrl2;

	if (clock == 0)
		goto out;

	/* Set SCLK_MMC from SYSCON as a clock source */
	ctrl2 = readl(host->ioaddr + S3C_SDHCI_CONTROL2);
	ctrl2 &= ~(3 << S3C_SDHCI_CTRL2_SELBASECLK_SHIFT);
	ctrl2 |= 2 << S3C_SDHCI_CTRL2_SELBASECLK_SHIFT;
	writew(ctrl2, host->ioaddr + S3C_SDHCI_CONTROL2);

	writew(0, host->ioaddr + SDHCI_CLOCK_CONTROL);
	set_hsmmc_pre_ratio(host, clock);

	clk = readw(host->ioaddr + SDHCI_CLOCK_CONTROL);
	clk |= SDHCI_CLOCK_INT_EN;
	writew(clk, host->ioaddr + SDHCI_CLOCK_CONTROL);

	/* Wait max 10 ms */
	timeout = 10;
	while (!((clk = readw(host->ioaddr + SDHCI_CLOCK_CONTROL))
		& SDHCI_CLOCK_INT_STABLE)) {
		if (timeout == 0) {
			printk("Internal clock never stabilised.\n");
			return;
		}
		timeout--;
		mdelay(1);
	}

	clk |= SDHCI_CLOCK_CARD_EN;
	writew(clk, host->ioaddr + SDHCI_CLOCK_CONTROL);

out:
	host->clock = clock;

	return;
}

static void s3c_hsmmc_set_ios(struct mmc *mmc)
{
	struct sdhci_host *host = mmc->priv;
	u8 ctrl;

	dbg("set_ios: bus_width: %x, clock: %d\n", mmc->bus_width, mmc->clock);

	/* Save io-address for Feedback Delay */
	mmc->ioaddr = host->ioaddr;

	sdhci_change_clock(host, mmc->clock);
	setup_sdhci0_cfg_card(host);

	/* Set Controller Bus Width */
	ctrl = readb(host->ioaddr + SDHCI_HOST_CONTROL);
	if (mmc->bus_width == MMC_BUS_WIDTH_4) {
		dbg("MMC_MODE_4BIT\n");
		ctrl |= SDHCI_CTRL_4BITBUS;
	} else if (mmc->bus_width == MMC_BUS_WIDTH_8) {
		dbg("MMC_MODE_8BIT\n");
		ctrl |= SDHCI_CTRL_8BITBUS;
	} else {
		ctrl &= ~(SDHCI_CTRL_4BITBUS | SDHCI_CTRL_8BITBUS);
	}

	ctrl &= ~SDHCI_CTRL_HISPD;

	writeb(ctrl, host->ioaddr + SDHCI_HOST_CONTROL);
}

static void sdhci_reset(struct sdhci_host *host, u8 mask)
{
	ulong timeout;

	writeb(mask, host->ioaddr + SDHCI_SOFTWARE_RESET);

	if (mask & SDHCI_RESET_ALL)
		host->clock = 0;

	/* Wait max 100 ms */
	timeout = 100;

	/* hw clears the bit when it's done */
	while (readb(host->ioaddr + SDHCI_SOFTWARE_RESET) & mask) {
		if (timeout == 0) {
			printk("mmc: Reset 0x%x never completed.\n",
				(int)mask);
			return;
		}
		timeout--;
		mdelay(1);
	}
}

static void sdhci_init(struct sdhci_host *host)
{
	u32 intmask;

	sdhci_reset(host, SDHCI_RESET_ALL);

	intmask = SDHCI_INT_BUS_POWER | SDHCI_INT_DATA_END_BIT |
		SDHCI_INT_DATA_CRC | SDHCI_INT_DATA_TIMEOUT | SDHCI_INT_INDEX |
		SDHCI_INT_END_BIT | SDHCI_INT_CRC | SDHCI_INT_TIMEOUT |
		SDHCI_INT_CARD_REMOVE | SDHCI_INT_CARD_INSERT |
		SDHCI_INT_DATA_AVAIL | SDHCI_INT_SPACE_AVAIL |
		SDHCI_INT_DATA_END | SDHCI_INT_RESPONSE |
		SDHCI_INT_ADMA_ERROR;

	writel(intmask, host->ioaddr + SDHCI_INT_ENABLE);
	writel(intmask, host->ioaddr + SDHCI_SIGNAL_ENABLE);
}

static int s3c_hsmmc_init(struct mmc *mmc)
{
	struct sdhci_host *host = (struct sdhci_host *)mmc->priv;

	sdhci_reset(host, SDHCI_RESET_ALL);

	host->version = readw(host->ioaddr + SDHCI_HOST_VERSION);
	sdhci_init(host);

	sdhci_change_clock(host, 400000);

	return 0;
}

static int s3c_hsmmc_initialize(int channel)
{
	struct mmc *mmc;

	mmc = &mmc_channel[channel];

	sprintf(mmc->name, "S3C_HSMMC%d", channel);
	mmc->priv = &mmc_host[channel];
	mmc->send_cmd = s3c_hsmmc_send_command;
	mmc->set_ios = s3c_hsmmc_set_ios;
	mmc->init = s3c_hsmmc_init;

	mmc->voltages = MMC_VDD_32_33 | MMC_VDD_33_34;
	mmc->host_caps = MMC_MODE_4BIT | MMC_MODE_8BIT |
			MMC_MODE_HS_52MHz | MMC_MODE_HS;

	mmc->f_min = 400000;
#ifdef CONFIG_EXYNOS4212
	#ifdef CONFIG_EXYNOS4412_EVT1
	mmc->f_max = 50000000;
	#else
	mmc->f_max = 45000000;
	#endif
#else
	mmc->f_max = 52000000;
#endif

	mmc_host[channel].clock = 0;

	switch(channel) {
#ifdef USE_MMC0
	case 0:
		mmc_host[channel].ioaddr = (void *)ELFIN_HSMMC_0_BASE;
		break;
#endif
#ifdef USE_MMC1
	case 1:
		mmc_host[channel].ioaddr = (void *)ELFIN_HSMMC_1_BASE;
		break;
#endif
#ifdef USE_MMC2
	case 2:
		mmc_host[channel].ioaddr = (void *)ELFIN_HSMMC_2_BASE;
		break;
#endif
#ifdef USE_MMC3
	case 3:
		mmc_host[channel].ioaddr = (void *)ELFIN_HSMMC_3_BASE;
		break;
#endif
	default:
		printk("mmc err: not supported channel %d\n", channel);
	}
	
	return mmc_register(mmc);
}

int smdk_s3c_hsmmc_init(void)
{
	int err;

#ifdef USE_MMC0
	err = s3c_hsmmc_initialize(0);
	if(err)
		return err;
#endif

#ifdef USE_MMC1
	err = s3c_hsmmc_initialize(1);
	if(err)
		return err;
#endif	

#ifdef USE_MMC2
	err = s3c_hsmmc_initialize(2);
	if(err)
		return err;
#endif	

#ifdef USE_MMC3
	err = s3c_hsmmc_initialize(3);
	if(err)
		return err;
#endif
	return -1;
}
