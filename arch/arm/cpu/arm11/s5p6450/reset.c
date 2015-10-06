/*
 * (C) Copyright 2011 Samsung Electronics Co. Ltd
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 */

#include <common.h>
#include <asm/arch/cpu.h>

/* * reset the cpu by setting up the watchdog timer and let him time out */
void reset_cpu(ulong ignored)
{
	printf("reset... \n\n\n");

	SW_RST_REG = 0x6450;

	/* loop forever and wait for reset to happen */
	while (1)
	{
		if (serial_tstc())
		{
			serial_getc();
			break;
		}
	}
	/*NOTREACHED*/
}
