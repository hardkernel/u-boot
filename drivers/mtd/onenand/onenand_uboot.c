/*
 *  drivers/mtd/onenand/onenand_uboot.c
 *
 *  Copyright (C) 2005-2008 Samsung Electronics
 *  Kyungmin Park <kyungmin.park@samsung.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

/*
 * OneNAND initialization at U-Boot
 */

#include <common.h>
#include <linux/mtd/compat.h>
#include <linux/mtd/mtd.h>
#include <linux/mtd/onenand.h>

#ifndef NAND_BOOTING

#ifdef CONFIG_SMDKC210
	/* Setting GPIO for ONENAND	*/
	#define rMP0_0CON	(*(volatile u32*) (GPIO_BASE + 0x0120))
	#define rMP0_2CON	(*(volatile u32*) (GPIO_BASE + 0x0160))
	#define rMP0_3CON       (*(volatile u32*) (GPIO_BASE + 0x0180))
	#define rMP0_4CON       (*(volatile u32*) (GPIO_BASE + 0x01A0))
	#define rMP0_5CON       (*(volatile u32*) (GPIO_BASE + 0x01C0))
	#define rMP0_6CON       (*(volatile u32*) (GPIO_BASE + 0x01E0))
	#define rMP0_0DRV_SR	(*(volatile u32*) (GPIO_BASE + 0x012C))
	#define rMP0_2DRV_SR	(*(volatile u32*) (GPIO_BASE + 0x016C))
	#define rMP0_3DRV_SR	(*(volatile u32*) (GPIO_BASE + 0x018C))
	#define rMP0_4DRV_SR	(*(volatile u32*) (GPIO_BASE + 0x01AC))
	#define rMP0_5DRV_SR	(*(volatile u32*) (GPIO_BASE + 0x01CC))
	#define rMP0_6DRV_SR	(*(volatile u32*) (GPIO_BASE + 0x01EC))
#endif
#endif

struct mtd_info onenand_mtd;
struct onenand_chip onenand_chip;
static __attribute__((unused)) char dev_name[] = "onenand0";

#ifndef NAND_BOOTING

#ifdef CONFIG_SMDKC210
void onenand_gpio_init(void)
{
	u32 uReg;
	uReg = rMP0_0CON;
	uReg &= ~((0xff<<16)|(0xf<<8));
	uReg |= ((0x22<<16)|(0x5<<8));
	rMP0_0CON = uReg;

	uReg = rMP0_2CON;
	uReg &= ~((0xf<<16)|(0xfff<<0));
	uReg |= ((0x5<<16)|(0x555<<0));
	rMP0_2CON = uReg;

	// set Data signal
	rMP0_5CON = 0x22222222;		/*	EBI_DATA [ 7: 0]	*/
	rMP0_6CON = 0x22222222;		/*	EBI_DATA [15: 8]	*/

	// set drive strength	=> x3
	uReg = rMP0_0DRV_SR;
	uReg &= ~((0xf<<8)|(0x3<<4));
	uReg |= ((0x5<<8)|(0x1<<4));
	rMP0_0DRV_SR = uReg;		/* EBI_WEn, EBI_OEn, OND_CSn[0]	=> x3	*/

	uReg = rMP0_2DRV_SR;
	uReg &= ~((0x3<<8)|(0x3f<<0));
	uReg |= ((0x1<<8)|(0x15<<0));
	rMP0_2DRV_SR = uReg;		/* OND_RPn, OND_INT[0], OND_SMCLK, OND_ADDRVALID	=>x3	*/

	rMP0_5DRV_SR = 0x5555;		/* EBI_DATA [ 7: 0] => x3	*/
	rMP0_6DRV_SR = 0x5555;		/* EBI_DATA [15: 8] => x3	*/
}
#endif

#endif

void onenand_init(void)
{
#ifndef NAND_BOOTING
	memset(&onenand_mtd, 0, sizeof(struct mtd_info));
	memset(&onenand_chip, 0, sizeof(struct onenand_chip));

	onenand_mtd.priv = &onenand_chip;

#ifdef CONFIG_USE_ONENAND_BOARD_INIT
	/*
	 * It's used for some board init required
	 */
	onenand_board_init(&onenand_mtd);
#else
#ifdef CONFIG_SMDKC210
	onenand_gpio_init();
#endif
	onenand_chip.base = (void *) CONFIG_SYS_ONENAND_BASE;	/*	0x0C000000	*/
#endif

	onenand_scan(&onenand_mtd, 1);

	if (onenand_chip.device_id & DEVICE_IS_FLEXONENAND)
		puts("Flex-");
	puts("OneNAND: ");
	print_size(onenand_chip.chipsize, "\n");

#ifdef CONFIG_MTD_DEVICE
	/*
	 * Add MTD device so that we can reference it later
	 * via the mtdcore infrastructure (e.g. ubi).
	 */
	if (onenand_chip.chipsize > 0) {
		onenand_mtd.name = dev_name;
		add_mtd_device(&onenand_mtd);
	}
#endif
#endif
}

