/*
 * Amlogic Meson driver-----------HDMI_TX
 * Copyright (C) 2013 Amlogic, Inc.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the named License,
 * or any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 */

#include "ubi_uboot.h"
#include <common.h>
#include <asm/arch/io.h>
#include <amlogic/aml_tv.h>

/*
 * Init hdmi power
 */
void init_hdmi(void)
{
    extern void hdmi_tx_power_init(void);
    hdmi_tx_power_init();
}

/*
 * the parameters mode from tv setting should be convert to HDMI VIC
 */
static unsigned int tvmode_vmode_vic_map[][3] = {
    {TVOUT_480I, VMODE_480I, HDMI_480i60_16x9},
    {TVOUT_480I, VMODE_480I, HDMI_480i60},
    {TVOUT_480CVBS, VMODE_480I, HDMI_480i60},
    {TVOUT_480P, VMODE_480P, HDMI_480p60_16x9},
    {TVOUT_480P, VMODE_480P, HDMI_480p60},
    {TVOUT_576I, VMODE_576I, HDMI_576i50_16x9},
    {TVOUT_576I, VMODE_576I, HDMI_576i50},
    {TVOUT_576CVBS, VMODE_576I, HDMI_576i50},
    {TVOUT_576P, VMODE_576P, HDMI_576p50_16x9},
    {TVOUT_576P, VMODE_576P, HDMI_576p50},
    {TVOUT_720P, VMODE_720P, HDMI_720p60},
    {TVOUT_1080I, VMODE_1080I, HDMI_1080i60},
    {TVOUT_1080P, VMODE_1080P, HDMI_1080p60},
    {TVOUT_720P_50HZ, VMODE_720P_50HZ, HDMI_720p50},
    {TVOUT_1080I_50HZ, VMODE_1080I_50HZ, HDMI_1080i50},
    {TVOUT_1080P_50HZ, VMODE_1080P_50HZ, HDMI_1080p50},
    {TVOUT_1080P_24HZ, VMODE_1080P_24HZ, HDMI_1080p24},
#if CONFIG_AML_MESON_8
    {TVOUT_4K2K_30HZ, VMODE_4K2K_30HZ, HDMI_4k2k_30},
    {TVOUT_4K2K_25HZ, VMODE_4K2K_25HZ, HDMI_4k2k_25},
    {TVOUT_4K2K_24HZ, VMODE_4K2K_24HZ, HDMI_4k2k_24},
    {TVOUT_4K2K_SMPTE, VMODE_4K2K_SMPTE, HDMI_4k2k_smpte},
#endif
    {TVOUT_MAX, VMODE_MAX, HDMI_Unkown},
};

HDMI_Video_Codes_t tvmode_to_vic(int mode)
{
    HDMI_Video_Codes_t vic = HDMI_Unkown;
    int i = 0;
    while(tvmode_vmode_vic_map[i][0] != TVOUT_MAX) {
        if(tvmode_vmode_vic_map[i][0] == mode) {
            vic = tvmode_vmode_vic_map[i][2];
            break;
        }
        i ++;
    }
    return vic;
}

vmode_t vic_to_vmode(HDMI_Video_Codes_t vic)
{
    vmode_t vmode = VMODE_INIT_NULL;
    int i = 0;
    while(tvmode_vmode_vic_map[i][2] != HDMI_Unkown) {
        if(tvmode_vmode_vic_map[i][2] == vic) {
            vmode = tvmode_vmode_vic_map[i][1];
            break;
        }
        i ++;
    }
    return vmode;
}

/*
 * set hdmi format
 */
int set_disp_mode(int mode)
{
    HDMI_Video_Codes_t vic;
    if(mode >= TVOUT_MAX) {
        printf("Invalid hdmi mode %d\n", mode);
        return 0;
    }
    vic = tvmode_to_vic(mode);
    printf("mode = %d  vic = %d\n", mode, vic);
    hdmi_tx_set(vic);
    return 1;
}    


