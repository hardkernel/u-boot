/*
 *  linux/drivers/mmc/host/sdhci.h - Secure Digital Host Controller Interface driver
 *
 *  Copyright (C) 2005-2008 Pierre Ossman, All Rights Reserved.
 * (C) Copyright 2011 Samsung Electronics Co. Ltd
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or (at
 * your option) any later version.
 */


/*
 * Controller registers
 */

#ifndef S3C_HSMMC_H
#define S3C_HSMMC_H

#if defined(CONFIG_ARCH_EXYNOS5)
#define GPIO_CON_MMC0_1         0x114000E0
#define GPIO_CON_MMC0_2         0x11400100
#define GPIO_CON_MMC2_1         0x11400120
#define GPIO_CON_MMC2_2         0x11400140
#define GPIO_CON_MMC4_1         0x114000E0
#define GPIO_CON_MMC4_2         0x11400100
#else
#define GPIO_CON_MMC0           0x11000040
#define GPIO_CON_MMC2_1         0x11000080
#define GPIO_CON_MMC2_2         0x110000A0
#define GPIO_CON_MMC4_1         0x11000040
#define GPIO_CON_MMC4_2         0x11000060
#endif

#define GPIO_PUD_OFFSET         0x08
#define GPIO_DRV_OFFSET         0x0C

#define SDHCI_DMA_ADDRESS	0x00

#define SDHCI_BLOCK_SIZE	0x04
#define  SDHCI_MAKE_BLKSZ(dma, blksz) (((dma & 0x7) << 12) | (blksz & 0xFFF))

#define SDHCI_BLOCK_COUNT	0x06

#define SDHCI_ARGUMENT		0x08

#define SDHCI_TRANSFER_MODE	0x0C
#define  SDHCI_TRNS_DMA		0x01
#define  SDHCI_TRNS_BLK_CNT_EN	0x02
#define  SDHCI_TRNS_ACMD12	0x04
#define  SDHCI_TRNS_READ	0x10
#define  SDHCI_TRNS_MULTI	0x20

#define SDHCI_COMMAND		0x0E
#define  SDHCI_CMD_RESP_MASK	0x03
#define  SDHCI_CMD_CRC		0x08
#define  SDHCI_CMD_INDEX	0x10
#define  SDHCI_CMD_DATA		0x20

#define  SDHCI_CMD_RESP_NONE	0x00
#define  SDHCI_CMD_RESP_LONG	0x01
#define  SDHCI_CMD_RESP_SHORT	0x02
#define  SDHCI_CMD_RESP_SHORT_BUSY 0x03

#define SDHCI_MAKE_CMD(c, f) (((c & 0xff) << 8) | (f & 0xff))

#define SDHCI_RESPONSE		0x10

#define SDHCI_BUFFER		0x20

#define SDHCI_PRESENT_STATE	0x24
#define  SDHCI_CMD_INHIBIT	0x00000001
#define  SDHCI_DATA_INHIBIT	0x00000002
#define  SDHCI_DOING_WRITE	0x00000100
#define  SDHCI_DOING_READ	0x00000200
#define  SDHCI_SPACE_AVAILABLE	0x00000400
#define  SDHCI_DATA_AVAILABLE	0x00000800
#define  SDHCI_CARD_PRESENT	0x00010000
#define  SDHCI_WRITE_PROTECT	0x00080000
#define  SDHCI_DATA_BIT(x)	(1 << ((x) + 20))

#define SDHCI_HOST_CONTROL 	0x28
#define SDHCI_CTRL_4BITBUS	(0x1<<1)
#define SDHCI_CTRL_HISPD	(0x1<<2)
#define SDHCI_CTRL_8BITBUS	(0x1<<5)
#define SDHCI_CTRL_DMA_MASK	0x18
#define SDHCI_CTRL_SDMA		0x00
#define SDHCI_CTRL_ADMA1	0x08
#define SDHCI_CTRL_ADMA32	0x10
#define SDHCI_CTRL_ADMA64	0x18

#define SDHCI_POWER_CONTROL	0x29
#define  SDHCI_POWER_ON		0x01
#define  SDHCI_POWER_180	0x0A
#define  SDHCI_POWER_300	0x0C
#define  SDHCI_POWER_330	0x0E

#define SDHCI_BLOCK_GAP_CONTROL	0x2A

#define SDHCI_WAKE_UP_CONTROL	0x2B

#define SDHCI_CLOCK_CONTROL	0x2C
#define  SDHCI_DIVIDER_SHIFT	8
#define  SDHCI_CLOCK_CARD_EN	0x0004
#define  SDHCI_CLOCK_INT_STABLE	0x0002
#define  SDHCI_CLOCK_INT_EN	0x0001

#define SDHCI_TIMEOUT_CONTROL	0x2E

#define SDHCI_SOFTWARE_RESET	0x2F
#define  SDHCI_RESET_ALL	0x01
#define  SDHCI_RESET_CMD	0x02
#define  SDHCI_RESET_DATA	0x04

#define SDHCI_INT_STATUS	0x30
#define SDHCI_INT_ENABLE	0x34
#define SDHCI_SIGNAL_ENABLE	0x38
#define  SDHCI_INT_RESPONSE	0x00000001
#define  SDHCI_INT_DATA_END	0x00000002
#define  SDHCI_INT_DMA_END	0x00000008
#define  SDHCI_INT_SPACE_AVAIL	0x00000010
#define  SDHCI_INT_DATA_AVAIL	0x00000020
#define  SDHCI_INT_CARD_INSERT	0x00000040
#define  SDHCI_INT_CARD_REMOVE	0x00000080
#define  SDHCI_INT_CARD_INT	0x00000100
#define  SDHCI_INT_ERROR	0x00008000
#define  SDHCI_INT_TIMEOUT	0x00010000
#define  SDHCI_INT_CRC		0x00020000
#define  SDHCI_INT_END_BIT	0x00040000
#define  SDHCI_INT_INDEX	0x00080000
#define  SDHCI_INT_DATA_TIMEOUT	0x00100000
#define  SDHCI_INT_DATA_CRC	0x00200000
#define  SDHCI_INT_DATA_END_BIT	0x00400000
#define  SDHCI_INT_BUS_POWER	0x00800000
#define  SDHCI_INT_ACMD12ERR	0x01000000
#define  SDHCI_INT_ADMA_ERROR	0x02000000

#define  SDHCI_INT_NORMAL_MASK	0x00007FFF
#define  SDHCI_INT_ERROR_MASK	0xFFFF8000

#define  SDHCI_INT_CMD_MASK	(SDHCI_INT_RESPONSE | SDHCI_INT_TIMEOUT | \
		SDHCI_INT_CRC | SDHCI_INT_END_BIT | SDHCI_INT_INDEX)
#define  SDHCI_INT_DATA_MASK	(SDHCI_INT_DATA_END | SDHCI_INT_DMA_END | \
		SDHCI_INT_DATA_AVAIL | SDHCI_INT_SPACE_AVAIL | \
		SDHCI_INT_DATA_TIMEOUT | SDHCI_INT_DATA_CRC | \
		SDHCI_INT_DATA_END_BIT)

#define SDHCI_ACMD12_ERR	0x3C

/* 3E-3F reserved */

#define SDHCI_CAPABILITIES	0x40
#define  SDHCI_TIMEOUT_CLK_MASK	0x0000003F
#define  SDHCI_TIMEOUT_CLK_SHIFT 0
#define  SDHCI_TIMEOUT_CLK_UNIT	0x00000080
#define  SDHCI_CLOCK_BASE_MASK	0x00003F00
#define  SDHCI_CLOCK_BASE_SHIFT	8
#define  SDHCI_MAX_BLOCK_MASK	0x00030000
#define  SDHCI_MAX_BLOCK_SHIFT  16
#define  SDHCI_CAN_DO_ADMA2	0x00080000
#define  SDHCI_CAN_DO_ADMA1	0x00100000
#define  SDHCI_CAN_DO_HISPD	0x00200000
#define  SDHCI_CAN_DO_DMA	0x00400000
#define  SDHCI_CAN_VDD_330	0x01000000
#define  SDHCI_CAN_VDD_300	0x02000000
#define  SDHCI_CAN_VDD_180	0x04000000
#define  SDHCI_CAN_64BIT	0x10000000

/* 44-47 reserved for more caps */

#define SDHCI_MAX_CURRENT	0x48

/* 4C-4F reserved for more max current */

#define SDHCI_SET_ACMD12_ERROR	0x50
#define SDHCI_SET_INT_ERROR	0x52

#define SDHCI_ADMA_ERROR	0x54

/* 55-57 reserved */

#define SDHCI_ADMA_ADDRESS	0x58

/* 60-FB reserved */

#define SDHCI_SLOT_INT_STATUS	0xFC

#define SDHCI_HOST_VERSION	0xFE
#define  SDHCI_VENDOR_VER_MASK	0xFF00
#define  SDHCI_VENDOR_VER_SHIFT	8
#define  SDHCI_SPEC_VER_MASK	0x00FF
#define  SDHCI_SPEC_VER_SHIFT	0
#define   SDHCI_SPEC_100	0
#define   SDHCI_SPEC_200	1

#define S3C_SDHCI_CONTROL2			(HM_CONTROL2)
#define S3C_SDHCI_CONTROL3			(HM_CONTROL3)
#define S3C_SDHCI_CONTROL4			(HM_CONTROL4)

#define S3C_SDHCI_CTRL2_ENSTAASYNCCLR	(1 << 31)
#define S3C_SDHCI_CTRL2_ENCMDCNFMSK		(1 << 30)
#define S3C_SDHCI_CTRL2_CDINVRXD3		(1 << 29)
#define S3C_SDHCI_CTRL2_SLCARDOUT		(1 << 28)

#define S3C_SDHCI_CTRL2_FLTCLKSEL_MASK		(0xf << 24)
#define S3C_SDHCI_CTRL2_FLTCLKSEL_SHIFT		(24)
#define S3C_SDHCI_CTRL2_FLTCLKSEL(_x)		((_x) << 24)

#define S3C_SDHCI_CTRL2_LVLDAT_MASK		(0xff << 16)
#define S3C_SDHCI_CTRL2_LVLDAT_SHIFT		(16)
#define S3C_SDHCI_CTRL2_LVLDAT(_x)		((_x) << 16)

#define S3C_SDHCI_CTRL2_ENFBCLKTX		(1 << 15)
#define S3C_SDHCI_CTRL2_ENFBCLKRX		(1 << 14)
#define S3C_SDHCI_CTRL2_SDCDSEL			(1 << 13)
#define S3C_SDHCI_CTRL2_SDSIGPC			(1 << 12)
#define S3C_SDHCI_CTRL2_ENBUSYCHKTXSTART	(1 << 11)

#define S3C_SDHCI_CTRL2_DFCNT_MASK		(0x3 << 9)
#define S3C_SDHCI_CTRL2_DFCNT_SHIFT		(9)
#define S3C_SDHCI_CTRL2_DFCNT_NONE		(0x0 << 9)
#define S3C_SDHCI_CTRL2_DFCNT_4SDCLK		(0x1 << 9)
#define S3C_SDHCI_CTRL2_DFCNT_16SDCLK		(0x2 << 9)
#define S3C_SDHCI_CTRL2_DFCNT_64SDCLK		(0x3 << 9)

#define S3C_SDHCI_CTRL2_ENCLKOUTHOLD		(1 << 8)
#define S3C_SDHCI_CTRL2_RWAITMODE		(1 << 7)
#define S3C_SDHCI_CTRL2_DISBUFRD		(1 << 6)
#define S3C_SDHCI_CTRL2_SELBASECLK_MASK		(0x3 << 4)
#define S3C_SDHCI_CTRL2_SELBASECLK_SHIFT	(4)
#define S3C_SDHCI_CTRL2_PWRSYNC			(1 << 3)
#define S3C_SDHCI_CTRL2_ENCLKOUTMSKCON		(1 << 1)
#define S3C_SDHCI_CTRL2_HWINITFIN		(1 << 0)

#define S3C_SDHCI_CTRL3_FCSEL3			(1 << 31)
#define S3C_SDHCI_CTRL3_FCSEL2			(1 << 23)
#define S3C_SDHCI_CTRL3_FCSEL1			(1 << 15)
#define S3C_SDHCI_CTRL3_FCSEL0			(1 << 7)

#define S3C_SDHCI_CTRL3_FIA3_MASK		(0x7f << 24)
#define S3C_SDHCI_CTRL3_FIA3_SHIFT		(24)
#define S3C_SDHCI_CTRL3_FIA3(_x)		((_x) << 24)

#define S3C_SDHCI_CTRL3_FIA2_MASK		(0x7f << 16)
#define S3C_SDHCI_CTRL3_FIA2_SHIFT		(16)
#define S3C_SDHCI_CTRL3_FIA2(_x)		((_x) << 16)

#define S3C_SDHCI_CTRL3_FIA1_MASK		(0x7f << 8)
#define S3C_SDHCI_CTRL3_FIA1_SHIFT		(8)
#define S3C_SDHCI_CTRL3_FIA1(_x)		((_x) << 8)

#define S3C_SDHCI_CTRL3_FIA0_MASK		(0x7f << 0)
#define S3C_SDHCI_CTRL3_FIA0_SHIFT		(0)
#define S3C_SDHCI_CTRL3_FIA0(_x)		((_x) << 0)

#define S3C_SDHCI_CONTROL4_DRIVE_MASK	(0x3 << 16)
#define S3C_SDHCI_CONTROL4_DRIVE_SHIFT	(16)
#define S3C_SDHCI_CONTROL4_DRIVE_2mA	(0x0 << 16)
#define S3C_SDHCI_CONTROL4_DRIVE_4mA	(0x1 << 16)
#define S3C_SDHCI_CONTROL4_DRIVE_7mA	(0x2 << 16)
#define S3C_SDHCI_CONTROL4_DRIVE_9mA	(0x3 << 16)

#define S3C_SDHCI_CONTROL4_BUSY		(1)

#ifndef __iomem
#define __iomem
#endif

struct sdhci_host {
	/* Data set by hardware interface driver */
	const char		*hw_name;	/* Hardware bus name */

	int			irq;		/* Device IRQ */
	void __iomem *		ioaddr;		/* Mapped address */

	/* Internal data */
	struct mmc		*mmc;		/* MMC structure */
	u64			dma_mask;	/* custom DMA mask */

	int			flags;		/* Host attributes */
#define SDHCI_USE_DMA		(1<<0)		/* Host is DMA capable */
#define SDHCI_USE_ADMA		(1<<1)		/* Host is ADMA capable */
#define SDHCI_REQ_USE_DMA	(1<<2)		/* Use DMA for this req. */
#define SDHCI_DEVICE_DEAD	(1<<3)		/* Device unresponsive */
#define SDHCI_DEVICE_ALIVE	(1<<4)		/* used on ext card detect */

	unsigned int		version;	/* SDHCI spec. version */

	unsigned int		max_clk;	/* Max possible freq (MHz) */
	unsigned int		timeout_clk;	/* Timeout freq (KHz) */

	unsigned int		clock;		/* Current clock (MHz) */
	unsigned short		power;		/* Current voltage */

	dma_addr_t		adma_addr;	/* Mapped ADMA descr. table */
};

#endif

