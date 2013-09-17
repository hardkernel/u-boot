/*
 * (C) Copyright 2002
 * Sysgo Real-Time Solutions, GmbH <www.elinos.com>
 * Marius Groeger <mgroeger@sysgo.de>
 *
 * (C) Copyright 2002
 * Sysgo Real-Time Solutions, GmbH <www.elinos.com>
 * Alex Zuepke <azu@sysgo.de>
 *
 * (C) Copyright 2002
 * Gary Jennejohn, DENX Software Engineering, <garyj@denx.de>
 *
 * (C) Copyright 2004
 * DAVE Srl
 * http://www.dave-tech.it
 * http://www.wawnet.biz
 * mailto:info@wawnet.biz
 *
 * (C) Copyright 2004 Texas Insturments
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

#include <common.h>

#if defined(CONFIG_BOARD_HARDKERNEL) && defined(CONFIG_TOSHIBA_EMMC441)
    //-------------------------------------------------------------------------------------------
    // TOSHIBA eMMC H/W Reset Control(GPD1.0)
    //-------------------------------------------------------------------------------------------
    #define GPD1CON		*(volatile unsigned long *)(0x13400180)
    #define GPD1DAT		*(volatile unsigned long *)(0x13400184)
    #define GPD1PUD		*(volatile unsigned long *)(0x13400188)
#endif

int do_reset(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
    #if defined(CONFIG_BOARD_HARDKERNEL) && defined(CONFIG_TOSHIBA_EMMC441)
        puts("emmc resetting ...\n");
        GPD1CON &= 0xFFFFFFF0;      GPD1CON |= 0x00000001;
        GPD1PUD &= 0xFFFFFFFC;      GPD1DAT &= 0xFE;
        udelay(50000);
        GPD1DAT |= 0x01;
    #endif

	puts ("resetting ...\n");

	udelay (50000);				/* wait 50 ms */

	disable_interrupts();
	reset_cpu(0);

	/*NOTREACHED*/
	return 0;
}
