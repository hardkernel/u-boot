/*
* (C) Copyright 2014 Hardkernel Co,.Ltd
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

#include <asm/arch/romboot.h>
#include <asm/arch/sdio.h>
#include <common.h>
#include <mmc.h>

#if CONFIG_CMD_MMC
static int  sdio_init(unsigned port)
{
        switch (port) {
        case SDIO_PORT_B:
                setbits_le32(P_PREG_PAD_GPIO5_EN_N, 1 << 29);
                break;
        case SDIO_PORT_C:
                clrbits_le32(P_PAD_PULL_UP_REG3, 0xff << 0);
                break;
        }

        return cpu_sdio_init(port);
}

extern unsigned sdio_debug_1bit_flag;

static int  sdio_detect(unsigned port)
{
        switch (port) {
        case SDIO_PORT_B:
#if 0   // FIXME: Card detect?
                int ret;
                setbits_le32(P_PREG_PAD_GPIO5_EN_N, 1 << 29);
                ret = readl(P_PREG_PAD_GPIO5_I) & (1 << 29) ? 0 : 1;
#endif
                // If UART pinmux is set, debug board inserted
                if ((readl(P_PERIPHS_PIN_MUX_8) & (3<<9))) {
                        if (!(readl(P_PREG_PAD_GPIO0_I) & (1 << 22))) {
                                printf("sdio debug board detected, sd card with 1bit mode\n");
                                sdio_debug_1bit_flag = 1;
                        }
                        else {
                                printf("sdio debug board detected, no sd card in\n");
                                sdio_debug_1bit_flag = 0;
                                return 1;
                        }
                }

                break;
        case SDIO_PORT_C:
                break;
        }

        return 0;
}

static void sdio_pwr_prepare(unsigned port)
{
        cpu_sdio_pwr_prepare(port);
}

static void sdio_pwr_on(unsigned port)
{
        switch (port) {
        case SDIO_PORT_B:
                clrbits_le32(P_PREG_PAD_GPIO5_O, 1 << 31);      // CARD_8
                clrbits_le32(P_PREG_PAD_GPIO5_EN_N, 1 << 31);
                break;
        case SDIO_PORT_C:
                break;
        }
}
static void sdio_pwr_off(unsigned port)
{
        switch (port) {
        case SDIO_PORT_B:
                setbits_le32(P_PREG_PAD_GPIO5_O, (1 << 31));    // CARD_8
                clrbits_le32(P_PREG_PAD_GPIO5_EN_N, (1 << 31));
                break;
        case SDIO_PORT_C:
                break;
        }
}

#define NR_STORAGE      2

struct mmc mmc[NR_STORAGE];

struct aml_card_sd_info sdio_dev[NR_STORAGE] = {
        {
                .sdio_port = SDIO_PORT_B,
                .name = "SDCARD",
                .sdio_init = sdio_init,
                .sdio_detect = sdio_detect,
                .sdio_pwr_on = sdio_pwr_on,
                .sdio_pwr_off = sdio_pwr_off,
                .sdio_pwr_prepare = sdio_pwr_prepare,
        }, {
                .sdio_port = SDIO_PORT_C,
                .name = "eMMC",
                .sdio_init = sdio_init,
                .sdio_detect = sdio_detect,
                .sdio_pwr_on = sdio_pwr_on,
                .sdio_pwr_off = sdio_pwr_off,
                .sdio_pwr_prepare = sdio_pwr_prepare,
        },
};

int board_boot_from_emmc()
{
        /* FIXME: 0xd901ff00 is from bootrom code itself. It must be corrected
         * with specific address of SoC.
         */
        T_ROM_BOOT_RETURN_INFO *bootinfo = (T_ROM_BOOT_RETURN_INFO*)0xd901ff00;

        return (0 == bootinfo->boot_id);
}

int board_mmc_init(bd_t *bis)
{
        if (board_boot_from_emmc()) { // Boot from eMMC
                mmc[0].block_dev.if_type = IF_TYPE_MMC;
                mmc[1].block_dev.if_type = IF_TYPE_SD;

                sdio_register(&mmc[0], &sdio_dev[1]);
                sdio_register(&mmc[1], &sdio_dev[0]);
        } else { // Boot from SDCARD
                mmc[0].block_dev.if_type = IF_TYPE_SD;
                mmc[1].block_dev.if_type = IF_TYPE_MMC;

                sdio_register(&mmc[0], &sdio_dev[0]);
                sdio_register(&mmc[1], &sdio_dev[1]);
        }
}
#endif
