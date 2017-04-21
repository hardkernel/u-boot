/*
 * (C) Copyright 2002
 * Gerald Van Baren, Custom IDEAS, vanbaren@cideas.com
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

/*
 * Exynos5422 ADC Read Utilities
 */

#include <common.h>
#include <command.h>

/*-----------------------------------------------------------------------
 * Definitions
 */
struct exynos5422_adc {
	unsigned int con1;
	unsigned int con2;
	unsigned int status;
	unsigned int dat;
	unsigned int int_en;
	unsigned int int_status;
	unsigned int reserved1;
	unsigned int reserved2;
	unsigned int version;
};

#define	EXYNOS5422_ADC_BASE	0x12D10000

int do_adc_read (cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	struct exynos5422_adc *adc =
		(struct exynos5422_adc *)EXYNOS5422_ADC_BASE;

	unsigned long adc_channel, wait_cnt = 100;

	/* ADC Argument error! */
	if (argc != 2)
		return	0;

	adc_channel = simple_strtoul(argv[1], NULL, 10);

	if (adc_channel > 9)	adc_channel = 9;

	/* ADC Software Reset */
	adc->con1 = 0x04;
	udelay(100);
	adc->con1 &= ~0x01;

	/* ADC Read Channel Setup */
	adc->con2 = (0x0720 | adc_channel);

	/* ADC Convert Start */
	adc->con1 |= 0x01;

	/* ADC Convert End check */
	while (!(adc->status & 0x04) && wait_cnt--)
		udelay(100);

	/* Debug Message
	printf("adc channel = %d, adc value = %d\n",
		adc_channel, adc->dat & 0xFFF);
	*/

	if (adc_channel == 9)
		setenv_ulong("board_rev", adc->dat & 0xFFF);

	/* 12 Bits ADC Data */
	return (adc->dat & 0xFFF);
}

/***************************************************/

U_BOOT_CMD(
	adc_read, 2,	0,	do_adc_read,
	"Exynos5422 ADC read utility command",
	"[channel<0 - 9>] - adc read channel\n"
	"channel 9 adc value is board revision\n"
	"Unknown : 0, XU3 : 350 < value < 400, XU4 : 1250 < value < 1300\n"
);
