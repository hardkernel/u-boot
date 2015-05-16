
/*
 * arch/arm/cpu/armv8/common/firmware/plat/gxb/mailbox.c
 *
 * Copyright (C) 2015 Amlogic, Inc. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

#include <stdio.h>
#include <string.h>
#include <io.h>
#include <stdint.h>
#include <asm/arch/romboot.h>
#include <mailbox.h>
#include <asm/arch/secure_apb.h>

void mb_send_data(uint32_t val, uint32_t port)
{
	unsigned long  base_addr = SEC_HIU_MAILBOX_SET_0;
	unsigned long  set_addr;

	if (port > 5) {
		printf("Error: Use the error port num!\n");
		return;
	}

	set_addr = base_addr + port*3*4;

	if (!val) {
		printf("Error: mailbox try to send zero val!\n");
		return;
	}

	writel(val, set_addr);

	return;
}

uint32_t mb_read_data(uint32_t port)
{
	unsigned long base_addr = SEC_HIU_MAILBOX_STAT_0;
	uint32_t val;

	if (port > 5) {
		printf("Error: Use the error port num!\n");
		return 0;
	}

	val = readl(base_addr + port*3*4);

	if (val)
		return val;
	else {
//		print_out("Warning: read mailbox val=0.\n");
		return 0;
	}
}

void mb_clear_data(uint32_t val, uint32_t port)
{
	uint32_t base_addr = SEC_HIU_MAILBOX_CLR_0;

	unsigned long clean_addr = base_addr + port*3*4;

	if (port > 5) {
		printf("Error: Use the error port num!\n");
		return;
	}

	if (!val) {
		printf("Warning: clean val=0.\n");
		return;
	}

	writel(val,clean_addr);

	return;
}

void send_bl30x(uint32_t addr, uint32_t size, const uint8_t * sha2, \
	uint32_t sha2_length, const char * name)
{
	int i;
	*(unsigned int *)MB_SRAM_BASE = size;

	if (0 == strcmp("bl301", name)) {
		/*bl301 must wait bl30 run*/
		printf("Wait bl30...");
		while (0x3 != ((readl(AO_SEC_SD_CFG15) >> 20) & 0x3)) {}
		printf("Done\n");
	}

	printf("Sending %s", name);
	//printf("time=0x%x size=0x%x\n", readl(0xc1109988),size);

	mb_send_data(CMD_DATA_LEN, 3);
	do {} while(mb_read_data(3));
	memcpy((void *)MB_SRAM_BASE, (const void *)sha2, sha2_length);
	mb_send_data(CMD_SHA, 3);
	do {} while(mb_read_data(3));

	for (i = 0; i < size; i+=1024) {
		printf(".");
		if (size >= i + 1024)
			memcpy((void *)MB_SRAM_BASE,(const void *)(unsigned long)(addr+i),1024);
		else if(size > i)
			memcpy((void *)MB_SRAM_BASE,(const void *)(unsigned long)(addr+i),(size-i));

		mb_send_data(CMD_DATA, 3);
		do {} while(mb_read_data(3));
	}
	mb_send_data(CMD_OP_SHA, 3);

	do {} while(mb_read_data(3));
	printf("OK. \nRun %s...\n", name);

	/* The BL31 will run after this command */
	mb_send_data(CMD_END,3);//code transfer end.
}
