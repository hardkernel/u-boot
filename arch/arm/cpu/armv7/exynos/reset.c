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

#if defined(CONFIG_HKDK4412)
#include <asm/arch/gpio.h>
#endif
/* * reset the cpu by setting up the watchdog timer and let him time out */
void reset_cpu(ulong ignored)
{

#if defined(CONFIG_HKDK4412)
	emmc_pwr_reset();

	GPIO_Init();

	GPIO_SetFunctionEach(eGPIO_K1, eGPIO_2, eGPO);
//	GPIO_SetPullUpDownEach(eGPIO_K1, eGPIO_2, 0);
	GPIO_SetDataEach(eGPIO_K1, eGPIO_2, 0);
	udelay (50000);				/* wait 50 ms */
	GPIO_SetDataEach(eGPIO_K1, eGPIO_2, 1);

#endif

	printf("reset... \n\n\n");
	SW_RST_REG = 0x1;

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

