/*
 * drivers/display/dolby_vision.c
 *
 * Copyright (C) 2018 Amlogic, Inc. All rights reserved.
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
 * Author: AMLOGIC dolby_vision driver
 *
*/


#include <common.h>
#include <asm/arch/io.h>
#include <asm/arch/secure_apb.h>
#include <amlogic/vmode.h>
#include <amlogic/storage_if.h>
#include <amlogic/vout.h>
#include <amlogic/hdmi.h>
#include <amlogic/dolby_vision.h>
#include <malloc.h>

#include <config.h>
#include <mmc.h>
#include <asm/byteorder.h>
#include <asm/unaligned.h>
#include <amlogic/dolby_vision_func.h>
#include <asm/cpu_id.h>

#include "vpp.h"
#include "hdr2.h"

#include <asm/arch/io.h>
#include <asm/arch/secure_apb.h>

static struct dovi_setting_s dovi_setting;
static struct dovi_mode_s dovi_mode;
static unsigned int dolby_vision_mode = DOLBY_VISION_OUTPUT_MODE_BYPASS;
static unsigned int dolby_vision_ll_policy = DOLBY_VISION_LL_DISABLE;
static unsigned int dv_ll_output_mode = DOLBY_VISION_OUTPUT_MODE_HDR10;
static unsigned int dolby_vision_target_min = 50; /* 0.0001 */
static unsigned int dolby_vision_target_max[3][3] = {
	{ 4000, 1000, 100 }, /* DOVI => DOVI/HDR/SDR */
	{ 1000, 1000, 100 }, /* HDR =>  DOVI/HDR/SDR */
	{ 600, 1000, 100 },  /* SDR =>  DOVI/HDR/SDR */
};
static unsigned int dolby_vision_target_graphics_max[3] = {
	300, 300, 100
}; /* DOVI/HDR/SDR */

/* 0: video priority 1: graphic priority */
static unsigned int dv_graphics_priority = 1;

static unsigned int vinfo_width = 1920;
static unsigned int vinfo_height = 1080;
static unsigned int vinfo_duration_num = 60;
static unsigned int vinfo_field_height = 1080;
static bool dolby_vision_on;
static char *dolby_status;
#define COEFF_NORM(a) ((int)((((a) * 2048.0) + 1) / 2))
#define MATRIX_5x3_COEF_SIZE 24

static int RGB709_to_YUV709l_coeff[MATRIX_5x3_COEF_SIZE] = {
	0, 0, 0, /* pre offset */
	COEFF_NORM(0.181873),	COEFF_NORM(0.611831),	COEFF_NORM(0.061765),
	COEFF_NORM(-0.100251),	COEFF_NORM(-0.337249),	COEFF_NORM(0.437500),
	COEFF_NORM(0.437500),	COEFF_NORM(-0.397384),	COEFF_NORM(-0.040116),
	0, 0, 0, /* 10'/11'/12' */
	0, 0, 0, /* 20'/21'/22' */
	64, 512, 512, /* offset */
	0, 0, 0 /* mode, right_shift, clip_en */
};
static int bypass_coeff[MATRIX_5x3_COEF_SIZE] = {
	0, 0, 0, /* pre offset */
	COEFF_NORM(1.0),	COEFF_NORM(0.0),	COEFF_NORM(0.0),
	COEFF_NORM(0.0),	COEFF_NORM(1.0),	COEFF_NORM(0.0),
	COEFF_NORM(0.0),	COEFF_NORM(0.0),	COEFF_NORM(1.0),
	0, 0, 0, /* 10'/11'/12' */
	0, 0, 0, /* 20'/21'/22' */
	0, 0, 0, /* offset */
	0, 0, 0 /* mode, right_shift, clip_en */
};
static int dvll_RGB_to_YUV709l_coeff[MATRIX_5x3_COEF_SIZE] = {
	0, 0, 0, /* pre offset */
	COEFF_NORM(0.181873), COEFF_NORM(0.611831), COEFF_NORM(0.061765),
	COEFF_NORM(-0.100251), COEFF_NORM(-0.337249), COEFF_NORM(0.437500),
	COEFF_NORM(0.437500), COEFF_NORM(-0.397384), COEFF_NORM(-0.040116),
	0, 0, 0, /* 10'/11'/12' */
	0, 0, 0, /* 20'/21'/22' */
	64, 512, 512, /* offset */
	0, 0, 0 /* mode, right_shift, clip_en */
};

static int *cur_osd_mtx = RGB709_to_YUV709l_coeff;
static int *cur_vd1_mtx = bypass_coeff;
static unsigned int debug_enable = 0;

static bool tv_mode;

#define MAX_PARAM   8

#define REG_OFFSET_VCBUS(reg)           ((reg << 2))
#define REG_ADDR_VCBUS(reg)             (REG_BASE_VCBUS + REG_OFFSET_VCBUS(reg))

static inline u32 READ_VPP_REG(u32 reg)
{
	return (*(volatile unsigned int *)REG_ADDR_VCBUS(reg));
}

static inline void WRITE_VPP_REG(u32 reg,
	 const u32 val)
{
	*(volatile unsigned int *)REG_ADDR_VCBUS(reg) = (val);
}

static inline void WRITE_VPP_REG_BITS(uint32_t reg,
	const uint32_t value, const uint32_t start, const uint32_t len)
{
	WRITE_VPP_REG(reg, ((READ_VPP_REG(reg) &
		~(((1L << (len)) - 1) << (start))) |
		(((value) & ((1L << (len)) - 1)) << (start))));
}

static bool is_meson_gxm(void)
{
	if (get_cpu_id().family_id == MESON_CPU_MAJOR_ID_GXM)
		return true;
	else
		return false;
}
static bool is_meson_g12(void)
{
	if (get_cpu_id().family_id == MESON_CPU_MAJOR_ID_G12A ||
		get_cpu_id().family_id == MESON_CPU_MAJOR_ID_G12B ||
		get_cpu_id().family_id == MESON_CPU_MAJOR_ID_SM1)
		return true;
	else
		return false;
}

static bool is_meson_box(void)
{
	if (is_meson_gxm() || is_meson_g12())
		return true;
	else
		return false;
}

static bool is_meson_txlx(void)
{
	if (get_cpu_id().family_id == MESON_CPU_MAJOR_ID_TXLX)
		return true;
	else
		return false;
}

static bool is_meson_txlx_tvmode(void)
{
	if ((is_meson_txlx()) && (tv_mode == 1))
		return true;
	else
		return false;
}
static bool is_meson_txlx_stbmode(void)
{
	if ((is_meson_txlx()) && (tv_mode == 0))
		return true;
	else
		return false;
}
static bool is_meson_tm2(void)
{
	if (get_cpu_id().family_id == MESON_CPU_MAJOR_ID_TM2)
		return true;
	else
		return false;
}

static bool is_meson_tm2_tvmode(void)
{
	if ((is_meson_tm2()) && (tv_mode == 1))
		return true;
	else
		return false;
}

static bool is_meson_tm2_stbmode(void)
{
	if ((is_meson_tm2()) && (tv_mode == 0))
		return true;
	else
		return false;
}

static bool is_meson_tvmode(void)
{
	if (is_meson_tm2_tvmode() ||
		is_meson_txlx_tvmode())
		return true;
	else
		return false;
}
#ifdef CONFIG_AML_DOLBY
/*check dolby enable status,if status is disabled, not enable dolby
*/
int is_dolby_enable(void)
{
	if (!dolby_status)
		dolby_status = getenv("dolby_status");

	printf("dolby_status %s\n", dolby_status);
	if (!strcmp(dolby_status, DOLBY_VISION_SET_STD) ||
		!strcmp(dolby_status, DOLBY_VISION_SET_LL_YUV) ||
		!strcmp(dolby_status, DOLBY_VISION_SET_LL_RGB))
		return 1;
	else
		return 0;
}
bool request_ll_mode(void)
{
	if (!dolby_status)
		dolby_status = getenv("dolby_status");

	if (!strcmp(dolby_status, DOLBY_VISION_SET_LL_RGB) ||
		!strcmp(dolby_status, DOLBY_VISION_SET_LL_YUV)) {
		printf("request LL mode\n");
		return true;
	} else
		return false;
}
bool check_dolby_vision_on(void)
{
	if ((get_cpu_id().family_id == MESON_CPU_MAJOR_ID_G12A) ||
		(get_cpu_id().family_id == MESON_CPU_MAJOR_ID_G12B) ||
		(get_cpu_id().family_id == MESON_CPU_MAJOR_ID_SM1)) {
		if (READ_VPP_REG(DOLBY_CORE3_SWAP_CTRL0) & 0x1)
			return true;
	}
	return false;
}
#endif

unsigned int  dv_read_reg(unsigned int addr)
{
	return READ_VPP_REG(addr);
}

void  dv_write_reg(unsigned int addr, unsigned int value)
{
	WRITE_VPP_REG(addr, value);
}
/*
static int check_tv_has_changed(struct hdmitx_dev* hdmitx_device)
{
	return hdmitx_device->RXCap.edid_changed;
}*/

static int check_tv_hpd_status(struct hdmitx_dev* hdmitx_device)
{
	return hdmitx_device->HWOp.get_hpd_state();
}


static int check_tv_support_dv(struct hdmitx_dev *hdmitx_device)
{
	struct dv_info* dv_info = NULL;
	int maxTMDSRate = 0;
	//int preferredMode = hdmitx_device->RXCap.preferred_mode;

	//1.tv not changed, use outputmode from env
	//2.tv changed,hdmi will choose best mode and update outputmode to env
	char *outputmode = getenv("outputmode");
	printf("check_tv_support_dv, outputmode %s\n", outputmode);

	if (!hdmitx_device)
		return 0;
	if (hdmitx_device->RXCap.dv_info.ieeeoui != 0x00d046)
		return 0;
	if (hdmitx_device->RXCap.dv_info.block_flag != CORRECT)
		return 0;

	dv_info = &hdmitx_device->RXCap.dv_info;

	if (dv_info->ver == 0) {
		dovi_mode.dv_rgb_444_8bit = 1;
		if (dv_info->sup_2160p60hz)
			dovi_mode.sup_2160p60hz = 1;
	} else if ((dv_info->ver == 1) && (dv_info->length == 0xB)) {
		dovi_mode.dv_rgb_444_8bit = 1;
		if (dv_info->low_latency == 0x01)
			dovi_mode.ll_ycbcr_422_12bit = 1;
		if (dv_info->sup_2160p60hz)
			dovi_mode.sup_2160p60hz = 1;
	} else if ((dv_info->ver == 1) && (dv_info->length == 0xE)) {
		dovi_mode.dv_rgb_444_8bit = 1;
		if (dv_info->sup_2160p60hz)
			dovi_mode.sup_2160p60hz = 1;
	} else if (dv_info->ver == 2) {
		dovi_mode.ll_ycbcr_422_12bit = 1;
		if ((dv_info->Interface != 0x00) && (dv_info->Interface != 0x01))
			dovi_mode.dv_rgb_444_8bit = 1;
		if ((dv_info->Interface == 0x01) || (dv_info->Interface == 0x03)) {
			if (dv_info->sup_10b_12b_444 == 0x1)
				dovi_mode.ll_rgb_444_10bit = 1;
			if (dv_info->sup_10b_12b_444 == 0x2)
				dovi_mode.ll_rgb_444_12bit = 1;
		}
		dovi_mode.sup_2160p60hz = 1;
	}

	//if preferred mode is 4k, make sure it can be truly supported in DV format
	if (hdmitx_device->RXCap.Max_TMDS_Clock2 != 0) {
		maxTMDSRate = hdmitx_device->RXCap.Max_TMDS_Clock2 * 5;
		printf("check_tv_support_dv: maxTMDSRate1 = %d\n", maxTMDSRate);
	} else {
		if (hdmitx_device->RXCap.Max_TMDS_Clock1 < 0xf)
			hdmitx_device->RXCap.Max_TMDS_Clock1 = 0x1e;
		maxTMDSRate = hdmitx_device->RXCap.Max_TMDS_Clock1 * 5;
		printf("check_tv_support_dv: maxTMDSRate2 = %d\n", maxTMDSRate);
	}
	//return true only if DV can truly be supported for a given mode
	if (strstr(outputmode, "2160p60hz") || strstr(outputmode, "2160p50hz")) {
		if ((dovi_mode.sup_2160p60hz) && (maxTMDSRate >= 594)) {
			//safety check for yuv420 - shudn't be the case
			if (!strcmp(outputmode, "2160p60hz420"))
				setenv("outputmode", "2160p60hz");
			if (!strcmp(outputmode, "2160p50hz420"))
				setenv("outputmode", "2160p50hz");
			printf("check_tv_support_dv: 4k60 dovi supported\n");
			return 1;
		} else {
			printf("check_tv_support_dv: 4k60 dovi NOT supported\n");
			return 0;
		}
	}
	return 1;
}

static int check_tv_support_hdr(struct hdmitx_dev *hdmitx_device)
{
	if (!hdmitx_device)
		return 0;
	if (hdmitx_device->RXCap.hdr_info.hdr_sup_eotf_smpte_st_2084)
		return 1;
	return 0;
}

#if 0
/* not needed anymore */
/*if tv has changed, choose the preferred mode and check if dv support this preferred mode*/
static int check_tv_dv_mode(struct hdmitx_dev *hdmitx_device)
{

	if (dovi_mode.dv_rgb_444_8bit) {
		setenv("colorattribute", "444,8bit");
		if ((hdmitx_device->RXCap.preferred_mode
			== HDMI_3840x2160p50_16x9) ||
			(hdmitx_device->RXCap.preferred_mode
			== HDMI_3840x2160p60_16x9)) {
			if ((dovi_mode.sup_2160p60hz) &&
				(hdmitx_device->RXCap.Max_TMDS_Clock2 * 5 == 600))
				setenv("outputmode", "2160p60hz");
			else
				setenv("outputmode", "1080p60hz");
		 } else if (hdmitx_device->RXCap.preferred_mode
			== HDMI_1920x1080p60_16x9)
			setenv("outputmode", "1080p60hz");
		else if (hdmitx_device->RXCap.preferred_mode
			== HDMI_1920x1080p50_16x9)
			setenv("outputmode", "1080p50hz");
		else if (hdmitx_device->RXCap.preferred_mode
			== HDMI_1280x720p60_16x9)
			setenv("outputmode", "720p60hz");
		else if (hdmitx_device->RXCap.preferred_mode
			== HDMI_1280x720p50_16x9)
			setenv("outputmode", "720p50hz");
		else
			setenv("outputmode", "1080p60hz");
		printf("output dv standard mode : mode is : %s  attr: %s\n",
			getenv("outputmode"), getenv("colorattribute"));
	} else if (dovi_mode.ll_ycbcr_422_12bit) {
		setenv("colorattribute", "422,12bit");
		if ((hdmitx_device->RXCap.preferred_mode
			== HDMI_3840x2160p50_16x9) ||
			(hdmitx_device->RXCap.preferred_mode
			== HDMI_3840x2160p60_16x9)) {
			if ((dovi_mode.sup_2160p60hz) &&
				(hdmitx_device->RXCap.Max_TMDS_Clock2 * 5 == 600))
				setenv("outputmode", "2160p60hz");
			else
				setenv("outputmode", "1080p60hz");
		} else if (hdmitx_device->RXCap.preferred_mode
			== HDMI_1920x1080p60_16x9)
			setenv("outputmode", "1080p60hz");
		else if (hdmitx_device->RXCap.preferred_mode
			== HDMI_1920x1080p50_16x9)
			setenv("outputmode", "1080p50hz");
		else if (hdmitx_device->RXCap.preferred_mode
			== HDMI_1280x720p60_16x9)
			setenv("outputmode", "720p60hz");
		else if (hdmitx_device->RXCap.preferred_mode
			== HDMI_1280x720p50_16x9)
			setenv("outputmode", "720p50hz");
		else
			setenv("outputmode", "1080p60hz");
		printf("output dv LL 422 mode : mode is : %s  attr: %s\n",
			getenv("outputmode"), getenv("colorattribute"));
	} else if (dovi_mode.ll_rgb_444_10bit) {
		setenv("colorattribute", "444,10bit");
		setenv("outputmode", "1080p60hz");
		printf("output dv LL 444 mode : mode is : %s  attr: %s\n",
			getenv("outputmode"), getenv("colorattribute"));
	} else if (dovi_mode.ll_rgb_444_12bit) {
		setenv("colorattribute", "444,12bit");
		setenv("outputmode", "1080p60hz");
		printf("output dv LL 444 mode : mode is : %s  attr: %s\n",
			getenv("outputmode"), getenv("colorattribute"));
	} else {
		setenv("colorattribute", "444,8bit");
		setenv("outputmode", "1080p60hz");
	}
	return 0;
}
#endif

/*true: attr match with dv_moder*/
/*false: attr not match with dv_mode*/
static bool is_attr_match(void)
{
	char *attr = getenv("colorattribute");

	/*two case use std mode: */
	/*1.user not requeset LL mode*/
	/*2.user request LL mode but sink not support LL mode*/
	if (dovi_mode.dv_rgb_444_8bit &&
		(!request_ll_mode() || dovi_mode.ll_ycbcr_422_12bit == 0)) { /*STD*/
		if (strcmp(attr, "444,8bit")) {
			printf("expect output DV, but attr is %s\n", attr);
			return false;
		}
	} else if (dovi_mode.ll_ycbcr_422_12bit) { /*LL YUV*/
		if (strcmp(attr, "422,12bit")) {
			printf("expect output LL YUV, but attr is %s\n", attr);
			dovi_setting.dst_format = FORMAT_SDR;
			return false;
		}
	} else if (dovi_mode.ll_rgb_444_10bit) {  /*LL RGB*/
		if (strcmp(attr, "444,10bit")) {
			printf("expect output LL RGB, but attr is %s\n", attr);
			dovi_setting.dst_format = FORMAT_SDR;
			return false;
		}
	}
	return true;
}
static int check_tv_support(struct hdmitx_dev *hdmitx_device)
{
	if (check_tv_support_dv(hdmitx_device)) {
		if (is_attr_match()) {
			dovi_setting.dst_format = FORMAT_DOVI;
			printf("output dovi mode: mode is : %s  attr: %s\n",
				getenv("outputmode"), getenv("colorattribute"));
		} else {
			dovi_setting.dst_format = FORMAT_SDR;
			printf("attr is not match, change to output SDR\n");
		}
	} else if (check_tv_support_hdr(hdmitx_device)) {
		dovi_setting.dst_format = FORMAT_HDR10;
		printf("output hdr mode: mode is : %s  attr: %s\n",
			getenv("outputmode"), getenv("colorattribute"));
	} else {
		dovi_setting.dst_format = FORMAT_SDR;
		printf("output sdr mode: mode is : %s  attr: %s\n",
			getenv("outputmode"), getenv("colorattribute"));
	}
	return 0;
}

static void dolby_vision_get_vinfo(struct hdmitx_dev *hdmitx_device)
{
	uint32_t width;
	uint32_t height;
	uint32_t sync_duration_num;
	uint32_t field_height;
	char  *mode_name;

	mode_name = getenv("outputmode");

	if (strstr(mode_name, "1080")) {
		width = 1920;
		height = 1080;
	} else if (strstr(mode_name, "2160")) {
		width = 3840;
		height = 2160;
	} else if (strstr(mode_name, "720")) {
		width = 1280;
		height = 720;
	} else if (strstr(mode_name, "576")) {
		width = 720;
		height = 576;
	} else if (strstr(mode_name, "480")) {
		width = 720;
		height = 480;
	} else if (strstr(mode_name, "smpte")) {
		width = 4096;
		height = 2160;
	} else {
		printf("unkown mode, use default 1080p\n");
		width = 1920;
		height = 1080;
	}

	if (strstr(mode_name, "60hz"))
		sync_duration_num = 60;
	else if (strstr(mode_name, "50hz"))
		sync_duration_num = 50;
	else if (strstr(mode_name, "30hz"))
		sync_duration_num = 30;
	else if (strstr(mode_name, "25hz"))
		sync_duration_num = 25;
	else if (strstr(mode_name, "24hz"))
		sync_duration_num = 24;
	else
		sync_duration_num = 60;

	if (strstr(mode_name, "i"))
		field_height = height/2;
	else
		field_height = height;

	vinfo_width = width;
	vinfo_height = height;
	vinfo_duration_num = sync_duration_num;
	vinfo_field_height = field_height;

}

static void dolby_vision_parse(struct hdmitx_dev *hdmitx_device)
{
	enum signal_format_e src_format = FORMAT_SDR;
	enum signal_format_e dst_format = dovi_setting.dst_format;
	unsigned int graphic_min = 50;
	unsigned int graphic_max = 100;
	unsigned int target_max = 100;
	unsigned int w = 3840;
	unsigned int h = 2160;

	dolby_vision_get_vinfo(hdmitx_device);
	dovi_setting.vout_width = vinfo_width;
	dovi_setting.vout_height= vinfo_height;
	dovi_setting.g_bitdepth = 8;
	dovi_setting.g_format = GF_SDR_RGB;
	dovi_setting.video_width = w << 16;
	dovi_setting.video_height = h << 16;

	if(dst_format >= 0
		&& dst_format <= 2)
		graphic_max = dolby_vision_target_graphics_max[dst_format];

	if (dovi_setting.dst_format == FORMAT_DOVI) {
		memset(&dovi_setting.vsvdb_tbl[0],
			0, sizeof(dovi_setting.vsvdb_tbl));
		memcpy(&dovi_setting.vsvdb_tbl[0],
			&hdmitx_device->RXCap.dv_info.rawdata[0],
			hdmitx_device->RXCap.dv_info.length + 1);

		//two case use std mode:
		//1.user not requeset LL mode
		//2.user request LL mode but sink not support LL mode
		if (dovi_mode.dv_rgb_444_8bit &&
			(!request_ll_mode() || dovi_mode.ll_ycbcr_422_12bit == 0))
			;
		else if (dovi_mode.ll_ycbcr_422_12bit) {
			dovi_setting.use_ll_flag = 1;
			dovi_setting.dovi_ll_enable = 1;
		} else if (dovi_mode.ll_rgb_444_10bit) {
			dovi_setting.use_ll_flag = 1;
			dovi_setting.dovi_ll_enable = 1;
			dovi_setting.ll_rgb_desired= 1;
			dovi_setting.diagnostic_enable = 1;
		}
	} else if (dovi_setting.dst_format == FORMAT_HDR10) {
		if (hdmitx_device->RXCap.hdr_info.hdr_lum_max) {
			graphic_max = 50 * (2 ^ (hdmitx_device->RXCap.hdr_info.hdr_lum_max >> 5));
			graphic_max = graphic_max * 10000
				* hdmitx_device->RXCap.hdr_info.hdr_lum_min
				* hdmitx_device->RXCap.hdr_info.hdr_lum_min
				/ (255 * 255 * 100);
		}
	} else
		;

	if ((src_format >= 0 && src_format <= 2) &&
		(dst_format >= 0 && dst_format <= 2))
		target_max = dolby_vision_target_max[src_format][dst_format];

	DV_func.control_path(
		src_format, dst_format,
		NULL, 0,
		NULL, 0,
		dv_graphics_priority,
		12, 0, 0,
		graphic_min,
		graphic_max * 10000,
		dolby_vision_target_min,
		target_max * 10000, 1,
		NULL,
		&dovi_setting);
}

static bool need_skip_cvm(unsigned int is_graphic) {
	return false;
}

static unsigned int mtx_en_mux;
static void video_effect_bypass(int bypass)
{
	WRITE_VPP_REG(VPP_EOTF_CTL, 0);
	WRITE_VPP_REG(XVYCC_LUT_CTL, 0);
	WRITE_VPP_REG(XVYCC_INV_LUT_CTL, 0);
	WRITE_VPP_REG(VPP_VADJ_CTRL, 0);
	WRITE_VPP_REG(VPP_GAINOFF_CTRL0, 0);
	WRITE_VPP_REG(VPP_VE_ENABLE_CTRL, 0);
	WRITE_VPP_REG(XVYCC_VD1_RGB_CTRST, 0);
}
static void vpp_set_mtx_en_write(void)
{
	int reg_val;

	reg_val = READ_VPP_REG(VPP_MATRIX_CTRL);
	WRITE_VPP_REG(VPP_MATRIX_CTRL, (reg_val &
		(~(POST_MTX_EN_MASK |
		VD2_MTX_EN_MASK |
		VD1_MTX_EN_MASK |
		XVY_MTX_EN_MASK |
		OSD1_MTX_EN_MASK))) |
		mtx_en_mux);
}

static void vpp_set_mtx_en_read(void)
{
	int reg_value;

	reg_value = READ_VPP_REG(VPP_MATRIX_CTRL);
	mtx_en_mux = reg_value &
		(POST_MTX_EN_MASK |
		VD2_MTX_EN_MASK |
		VD1_MTX_EN_MASK |
		XVY_MTX_EN_MASK |
		OSD1_MTX_EN_MASK);
}

static int enable_rgb_to_yuv_matrix_for_dvll(
	int32_t on, uint32_t *coeff_orig, uint32_t bits)
{
	int32_t i;
	uint32_t coeff01, coeff23, coeff45, coeff67, coeff89;
	uint32_t scale, shift, offset[3];
	int32_t *coeff = dvll_RGB_to_YUV709l_coeff;

	if ((bits < 10) || (bits > 12))
		return -1;
	if (on && !coeff_orig)
		return -2;
	if (on) {
		coeff01 = coeff_orig[0];
		coeff23 = coeff_orig[1];
		coeff45 = coeff_orig[2];
		coeff67 = coeff_orig[3];
		coeff89 = coeff_orig[4] & 0xffff;
		scale = (coeff_orig[4] >> 16) & 0x0f;
		offset[0] = coeff_orig[5];
		offset[1] = 0; /* coeff_orig[6]; */
		offset[2] = 0; /* coeff_orig[7]; */

		coeff[0] = coeff[1] = coeff[2] = 0; /* pre offset */

		coeff[5] = (int32_t)((coeff01 & 0xffff) << 16) >> 16;
		coeff[3] = (int32_t)coeff01 >> 16;
		coeff[4] = (int32_t)((coeff23 & 0xffff) << 16) >> 16;
		coeff[8] = (int32_t)coeff23 >> 16;
		coeff[6] = (int32_t)((coeff45 & 0xffff) << 16) >> 16;
		coeff[7] = (int32_t)coeff45 >> 16;
		coeff[11] = (int32_t)((coeff67 & 0xffff) << 16) >> 16;
		coeff[9] = (int32_t)coeff67 >> 16;
		coeff[10] = (int32_t)((coeff89 & 0xffff) << 16) >> 16;

		if (scale > 12) {
			shift = scale - 12;
			for (i = 3; i < 12; i++)
				coeff[i] = (coeff[i] + (1 << (shift - 1))) >> shift;
		} else if (scale < 12) {
			shift = 12 - scale;
			for (i = 3; i < 12; i++)
				coeff[i] <<= shift;
		}

		/* post offset */
		coeff[18] = offset[0];
		coeff[19] = offset[1];
		coeff[20] = offset[2];

		coeff[5] = ((coeff[3] + coeff[4] + coeff[5]) & 0xfffe)
			- coeff[3] - coeff[4];
		coeff[8] = 0 - coeff[6] - coeff[7];
		coeff[11] = 0 - coeff[9] - coeff[10];
		coeff[18] -= (0x1000 - coeff[3] - coeff[4] - coeff[5]) >> 1;

		coeff[22] = 2;
		vpp_set_mtx_en_read();
		WRITE_VPP_REG(VPP_MATRIX_CTRL, 0);
		set_vpp_matrix(VPP_MATRIX_OSD,
			cur_osd_mtx, CSC_OFF);
		set_vpp_matrix(VPP_MATRIX_VD1,
			cur_vd1_mtx, CSC_OFF);
		set_vpp_matrix(VPP_MATRIX_POST,
			coeff, CSC_ON);
		vpp_set_mtx_en_write();
	}
	return 0;
}

static int dolby_core2_set(
	const uint32_t dm_count,
	const uint32_t lut_count,
	uint32_t *p_core2_dm_regs,
	uint32_t *p_core2_lut,
	int hsize,
	int vsize,
	int dolby_enable,
	int lut_endian)
{
	uint32_t count;
	int i;
	uint32_t bypass_flag = 0;

	uint32_t g_htotal_add = 0x40;
	uint32_t g_vtotal_add = 0x80;
	uint32_t g_vsize_add = 0;
	uint32_t g_vwidth = 0x18;
	uint32_t g_hwidth = 0x10;
	uint32_t g_vpotch;
	uint32_t g_hpotch = 0x10;

	/* adjust core2 setting to work around*/
	/* fixing with 1080p24hz and 480p60hz */
	if ((vinfo_width < 1280) && ((vinfo_height < 720)
		&& (vinfo_field_height < 720)))
		g_vpotch = 0x60;
	else if ((vinfo_width == 1280) &&
		 (vinfo_height == 720) &&
		 (vinfo_field_height < 720))
		g_vpotch = 0x60;
	else if ((vinfo_width == 1920) &&
		  (vinfo_height == 1080) &&
		  (vinfo_duration_num == 24))
		g_vpotch = 0x60;
	else if ((vinfo_width == 1920) &&
		 (vinfo_height == 1080) &&
		 (vinfo_field_height < 1080))
		g_vpotch = 0x60;
	else if ((vinfo_width == 1280) && (vinfo_height == 720))
		g_vpotch = 0x38;
	else
		g_vpotch = 0x20;

	WRITE_VPP_REG(DOLBY_CORE2A_CLKGATE_CTRL, 0);
	WRITE_VPP_REG(DOLBY_CORE2A_SWAP_CTRL0, 0);

	WRITE_VPP_REG(DOLBY_CORE2A_SWAP_CTRL1,
		((hsize + g_htotal_add) << 16)
		| (vsize + g_vtotal_add + g_vsize_add));
	WRITE_VPP_REG(DOLBY_CORE2A_SWAP_CTRL2,
		(hsize << 16) | (vsize + g_vsize_add));
	WRITE_VPP_REG(DOLBY_CORE2A_SWAP_CTRL3,
		(g_hwidth << 16) | g_vwidth);
	WRITE_VPP_REG(DOLBY_CORE2A_SWAP_CTRL4,
		(g_hpotch << 16) | g_vpotch);
	if (is_meson_txlx_stbmode())
		WRITE_VPP_REG(DOLBY_CORE2A_SWAP_CTRL5, 0xf8000000);
	else if (is_meson_g12() || is_meson_tm2_stbmode())
		WRITE_VPP_REG(DOLBY_CORE2A_SWAP_CTRL5,  0xa8000000);
	else
		WRITE_VPP_REG(DOLBY_CORE2A_SWAP_CTRL5, 0x0);

	WRITE_VPP_REG(DOLBY_CORE2A_DMA_CTRL, 0x0);
	WRITE_VPP_REG(DOLBY_CORE2A_REG_START + 2, 1);
	if (need_skip_cvm(1))
		bypass_flag |= 1 << 0;
	WRITE_VPP_REG(DOLBY_CORE2A_REG_START + 2, 1);
	WRITE_VPP_REG(DOLBY_CORE2A_REG_START + 1,
		2 | bypass_flag);
	WRITE_VPP_REG(DOLBY_CORE2A_REG_START + 1,
		2 | bypass_flag);
	WRITE_VPP_REG(DOLBY_CORE2A_CTRL, 0);

	WRITE_VPP_REG(DOLBY_CORE2A_CTRL, 0);

	if (dm_count == 0)
		count = 24;
	else
		count = dm_count;
	for (i = 0; i < count; i++)
		WRITE_VPP_REG(
			DOLBY_CORE2A_REG_START + 6 + i,
			p_core2_dm_regs[i]);

	/* core2 metadata program done */
	WRITE_VPP_REG(DOLBY_CORE2A_REG_START + 3, 1);

	if (lut_count == 0)
		count = 256 * 5;
	else
		count = lut_count;

	WRITE_VPP_REG(DOLBY_CORE2A_DMA_CTRL, 0x1401);
	if (lut_endian)
		for (i = 0; i < count; i += 4) {
			WRITE_VPP_REG(DOLBY_CORE2A_DMA_PORT,
				p_core2_lut[i+3]);
			WRITE_VPP_REG(DOLBY_CORE2A_DMA_PORT,
				p_core2_lut[i+2]);
			WRITE_VPP_REG(DOLBY_CORE2A_DMA_PORT,
				p_core2_lut[i+1]);
			WRITE_VPP_REG(DOLBY_CORE2A_DMA_PORT,
				p_core2_lut[i]);
		}
	else
		for (i = 0; i < count; i++)
			WRITE_VPP_REG(DOLBY_CORE2A_DMA_PORT,
				p_core2_lut[i]);

	/* enable core2 */
	WRITE_VPP_REG(DOLBY_CORE2A_SWAP_CTRL0, dolby_enable << 0);

	if (debug_enable) {
		printf("core2\n");
		for (i = 0; i < 24; i++)
			printf("%08x\n", p_core2_dm_regs[i]);
		printf("core2 swap\n");
		for (i = DOLBY_CORE2A_CLKGATE_CTRL;
			i <= DOLBY_CORE2A_DMA_PORT; i++)
			printf("[0x%4x] = 0x%x\n",
				i, READ_VPP_REG(i));
		printf("core2 real reg\n");
		for (i = DOLBY_CORE2A_REG_START;
			i <= DOLBY_CORE2A_REG_START + 5; i++)
			printf("[0x%4x] = 0x%x\n",
				i, READ_VPP_REG(i));
	}

	return 0;
}

static int dolby_core3_set(
	uint32_t dm_count,
	uint32_t md_count,
	uint32_t *p_core3_dm_regs,
	uint32_t *p_core3_md_regs,
	int hsize,
	int vsize,
	int dolby_enable,
	int scramble_en,
	u8 pps_state)
{
	uint32_t count;
	int i;
	int vsize_hold = 0x10;
	uint32_t diag_mode = 0;
	uint32_t cur_dv_mode = dolby_vision_mode;
	uint32_t diag_enable = 0;

	uint32_t htotal_add = 0x140;
	uint32_t vtotal_add = 0x40;
	uint32_t vsize_add = 0;

	if (dovi_setting.diagnostic_enable
		|| dovi_setting.dovi_ll_enable)
		diag_enable = 1;

	if (((cur_dv_mode == DOLBY_VISION_OUTPUT_MODE_IPT_TUNNEL)
		|| (cur_dv_mode == DOLBY_VISION_OUTPUT_MODE_IPT))
		&& diag_enable) {
		cur_dv_mode = dv_ll_output_mode & 0xff;

		if (is_meson_g12() || is_meson_tm2_stbmode()) {
			if (dolby_vision_ll_policy == DOLBY_VISION_LL_YUV422)
				diag_mode = 0x20;
			else
				diag_mode = 3;
		} else
			diag_mode = 3;
	}
	if (is_meson_box() || is_meson_tm2_stbmode()) {
		if (dovi_setting.dovi_ll_enable &&
			dovi_setting.diagnostic_enable == 0) {
			WRITE_VPP_REG_BITS(
				VPP_DOLBY_CTRL,
				3, 6, 2); /* post matrix */
			WRITE_VPP_REG_BITS(
				VPP_MATRIX_CTRL,
				1, 0, 1); /* post matrix */
		} else {
			WRITE_VPP_REG_BITS(
				VPP_DOLBY_CTRL,
				0, 6, 2); /* post matrix */
			WRITE_VPP_REG_BITS(
				VPP_MATRIX_CTRL,
				0, 0, 1); /* post matrix */
		}
	} else if (is_meson_txlx_stbmode()) {
			WRITE_VPP_REG_BITS(
				VPP_DOLBY_CTRL,
				1, 0, 1); /* skip pps/dither/cm */
			WRITE_VPP_REG(
				VPP_DAT_CONV_PARA0, 0x08000800);

		if (dovi_setting.dovi_ll_enable &&
			dovi_setting.diagnostic_enable == 0) {
			/*bypass gainoff to vks */
			/*enable wn tp vks*/
			WRITE_VPP_REG_BITS(
				VPP_DOLBY_CTRL, 0, 2, 1);
			WRITE_VPP_REG_BITS(
				VPP_DOLBY_CTRL, 1, 1, 1);
			WRITE_VPP_REG(
				VPP_DAT_CONV_PARA1, 0x8000800);
			WRITE_VPP_REG_BITS(
				VPP_MATRIX_CTRL,
				1, 0, 1); /* post matrix */
		} else {
			/* bypass wm tp vks*/
			WRITE_VPP_REG_BITS(
				VPP_DOLBY_CTRL, 1, 2, 1);
			WRITE_VPP_REG_BITS(
				VPP_DOLBY_CTRL, 0, 1, 1);
			WRITE_VPP_REG(
				VPP_DAT_CONV_PARA1, 0x20002000);
			if (is_meson_tvmode())
				enable_rgb_to_yuv_matrix_for_dvll(
					0, NULL, 12);
			else
				WRITE_VPP_REG_BITS(
					VPP_MATRIX_CTRL,
					0, 0, 1);
		}
	}

	/* flush post matrix table when ll mode on and setting changed */
	if (dovi_setting.dovi_ll_enable &&
		(dovi_setting.diagnostic_enable == 0))
		enable_rgb_to_yuv_matrix_for_dvll(
			1, &p_core3_dm_regs[18], 12);

	WRITE_VPP_REG(DOLBY_CORE3_CLKGATE_CTRL, 0);
	WRITE_VPP_REG(DOLBY_CORE3_SWAP_CTRL1,
		((hsize + htotal_add) << 16)
		| (vsize + vtotal_add + vsize_add + vsize_hold * 2));
	WRITE_VPP_REG(DOLBY_CORE3_SWAP_CTRL2,
		(hsize << 16) | (vsize + vsize_add));
	WRITE_VPP_REG(DOLBY_CORE3_SWAP_CTRL3,
		(0x80 << 16) | vsize_hold);
	WRITE_VPP_REG(DOLBY_CORE3_SWAP_CTRL4,
		(0x04 << 16) | vsize_hold);
	WRITE_VPP_REG(DOLBY_CORE3_SWAP_CTRL5, 0x0000);
	if (cur_dv_mode != DOLBY_VISION_OUTPUT_MODE_IPT_TUNNEL)
		WRITE_VPP_REG(DOLBY_CORE3_SWAP_CTRL6, 0);
	else
		WRITE_VPP_REG(DOLBY_CORE3_SWAP_CTRL6,
			0x10000000);  /* swap UV */
	WRITE_VPP_REG(DOLBY_CORE3_REG_START + 5, 7);
	WRITE_VPP_REG(DOLBY_CORE3_REG_START + 4, 4);
	WRITE_VPP_REG(DOLBY_CORE3_REG_START + 4, 2);
	WRITE_VPP_REG(DOLBY_CORE3_REG_START + 2, 1);
	/* Control Register, address 0x04 2:0 RW */
	/* Output_operating mode*/
	/*   00- IPT 12 bit 444 bypass Dolby Vision output*/
	/*   01- IPT 12 bit tunnelled over RGB 8 bit 444, dolby vision output*/
	/*   02- HDR10 output, RGB 10 bit 444 PQ*/
	/*   03- Deep color SDR, RGB 10 bit 444 Gamma*/
	/*   04- SDR, RGB 8 bit 444 Gamma*/
	WRITE_VPP_REG(DOLBY_CORE3_REG_START + 1, cur_dv_mode);
	WRITE_VPP_REG(DOLBY_CORE3_REG_START + 1, cur_dv_mode);
	/* for delay */

	if (dm_count == 0)
		count = 26;
	else
		count = dm_count;
	for (i = 0; i < count; i++)
		WRITE_VPP_REG(DOLBY_CORE3_REG_START + 0x6 + i,
			p_core3_dm_regs[i]);
	/* from addr 0x18 */

	count = md_count;
	for (i = 0; i < count; i++)
		WRITE_VPP_REG(DOLBY_CORE3_REG_START + 0x24 + i,
			p_core3_md_regs[i]);
	for (; i < (128+1); i++)
		WRITE_VPP_REG(DOLBY_CORE3_REG_START + 0x24 + i, 0);

	/* from addr 0x90 */
	/* core3 metadata program done */
	WRITE_VPP_REG(DOLBY_CORE3_REG_START + 3, 1);

	WRITE_VPP_REG(DOLBY_CORE3_DIAG_CTRL, diag_mode);
	/* enable core3 */
	WRITE_VPP_REG(DOLBY_CORE3_SWAP_CTRL0, (dolby_enable << 0));

	if (debug_enable) {
		printf("core3\n");
		for (i = 0; i < 26; i++)
			printf("%08x\n", p_core3_dm_regs[i]);
		printf("core3 swap\n");
		for (i = DOLBY_CORE3_CLKGATE_CTRL;
			i <= 0x36fd; i++)
			printf("[0x%4x] = 0x%x\n",
				i, READ_VPP_REG(i));
		printf("core3 real reg\n");
		for (i = DOLBY_CORE3_REG_START;
			i <= DOLBY_CORE3_REG_START + 67; i++)
			printf("[0x%4x] = 0x%x\n",
				i, READ_VPP_REG(i));

		printf("core3 metadata, count %d\n",md_count);
		for (i = 0; i < md_count; i++)
			printf("%08x\n", p_core3_md_regs[i]);
	}

	return 0;
}

int apply_stb_core_settings(void)
{
	uint32_t graphics_w = 1920;
	uint32_t graphics_h = 1080;

	if (!is_dolby_enable())
		return 0;
	if (dovi_setting.dst_format == FORMAT_INVALID)
		return 0;

	printf("apply_stb_core_settings\n");
	if (dovi_setting.dst_format == FORMAT_DOVI) {
		if (dovi_setting.dovi_ll_enable) {
			if (dovi_setting.diagnostic_enable) {
				dolby_vision_mode = DOLBY_VISION_OUTPUT_MODE_IPT;
				dolby_vision_ll_policy = DOLBY_VISION_LL_RGB444;
			} else {
				dolby_vision_mode = DOLBY_VISION_OUTPUT_MODE_IPT;
				dolby_vision_ll_policy = DOLBY_VISION_LL_YUV422;
			}
		} else
			dolby_vision_mode = DOLBY_VISION_OUTPUT_MODE_IPT_TUNNEL;
	} else if (dovi_setting.dst_format == FORMAT_HDR10)
		dolby_vision_mode = DOLBY_VISION_OUTPUT_MODE_HDR10;
	else
		dolby_vision_mode = DOLBY_VISION_OUTPUT_MODE_SDR8;

	dolby_core2_set(24, 256 * 5,
		(uint32_t *)&dovi_setting.dm_reg2,
		(uint32_t *)&dovi_setting.dm_lut2,
		graphics_w, graphics_h, 1, 1);

	dolby_core3_set(26, dovi_setting.md_reg3.size,
		(uint32_t *)&dovi_setting.dm_reg3,
		dovi_setting.md_reg3.raw_metadata,
		vinfo_width, vinfo_height, 1, 1, 0);
	return 0;
}

static int  enable_dolby_vision(void)
{
	printf("enable_dolby_vision\n");
	if (is_meson_g12()) {
		hdr_func(OSD1_HDR, HDR_OFF);

		/*enable core3*/
		WRITE_VPP_REG_BITS(VPP_DOLBY_CTRL, 1, 3, 1);
		WRITE_VPP_REG(VPP_WRAP_OSD1_MATRIX_EN_CTRL,
			0x0);
		WRITE_VPP_REG(VPP_WRAP_OSD2_MATRIX_EN_CTRL,
			0x0);
		WRITE_VPP_REG(VPP_WRAP_OSD3_MATRIX_EN_CTRL,
			0x0);

		/*enable core2*/
		WRITE_VPP_REG_BITS(DOLBY_PATH_CTRL, 0, 2, 1);

		/* bypass all video effect */
		video_effect_bypass(1);
		/* 12->10 before vadj1*/
		/* 10->12 before post blend */
		WRITE_VPP_REG(VPP_DAT_CONV_PARA0,
			0x20002000);
		/* 12->10 before vadj2*/
		/* 10->12 after gainoff */
		WRITE_VPP_REG(VPP_DAT_CONV_PARA1,
			0x20002000);

		WRITE_VPP_REG(VPP_MATRIX_CTRL, 0);
		WRITE_VPP_REG(VPP_DUMMY_DATA1,0x80200);

		if (((dolby_vision_mode ==
			DOLBY_VISION_OUTPUT_MODE_IPT_TUNNEL)
			|| (dolby_vision_mode ==
			DOLBY_VISION_OUTPUT_MODE_IPT)) &&
			(dovi_setting.diagnostic_enable == 0) &&
			dovi_setting.dovi_ll_enable) {
			uint32_t *reg = (uint32_t *)&dovi_setting.dm_reg3;
			/* input u12 -0x800 to s12 */
			WRITE_VPP_REG(VPP_DAT_CONV_PARA1,
				0x8000800);
			/* bypass vadj */
			WRITE_VPP_REG(VPP_VADJ_CTRL, 0);
			/* bypass gainoff */
			WRITE_VPP_REG(VPP_GAINOFF_CTRL0, 0);
			/* enable wm tp vks*/
			/* bypass gainoff to vks */
			WRITE_VPP_REG_BITS(VPP_DOLBY_CTRL, 1, 1, 2);
			enable_rgb_to_yuv_matrix_for_dvll(1, &reg[18],
				(dv_ll_output_mode >> 8)& 0xff);
		} else
			enable_rgb_to_yuv_matrix_for_dvll(0, NULL, 12);

		dolby_vision_on = true;
		setenv("dolby_vision_on", "1");
		run_command("saveenv", 0);
		printk("Dolby Vision turn on\n");
	}
	return 0;
}

static int prepare_drm_pkt(struct master_display_info_s *data,
	struct dovi_setting_s *setting, const struct hdmitx_dev *hdmitx_device)
{
	struct hdr_10_infoframe_s *p_hdr;
	p_hdr = &(setting->hdr_info);

	if (!data || !hdmitx_device || !setting)
		return -1;

	data->features = (1 << 29) | (5 << 26) | (0 << 25) | (1 << 24)
			| (9 << 16) | (0x10 << 8) | (10 << 0);
	data->primaries[0][0] =
		(p_hdr->display_primaries_x_1_MSB << 8)
		| p_hdr->display_primaries_x_1_LSB;
	data->primaries[0][1] =
		(p_hdr->display_primaries_y_1_MSB << 8)
		| p_hdr->display_primaries_y_1_LSB;
	data->primaries[1][0] =
		(p_hdr->display_primaries_x_2_MSB << 8)
		| p_hdr->display_primaries_x_2_LSB;
	data->primaries[1][1] =
		(p_hdr->display_primaries_y_2_MSB << 8)
		| p_hdr->display_primaries_y_2_LSB;
	data->primaries[2][0] =
		(p_hdr->display_primaries_x_0_MSB << 8)
		| p_hdr->display_primaries_x_0_LSB;
	data->primaries[2][1] =
		(p_hdr->display_primaries_y_0_MSB << 8)
		| p_hdr->display_primaries_y_0_LSB;
	data->white_point[0] =
		(p_hdr->white_point_x_MSB << 8)
		| p_hdr->white_point_x_LSB;
	data->white_point[1] =
		(p_hdr->white_point_y_MSB << 8)
		| p_hdr->white_point_y_LSB;
	data->luminance[0] =
		(p_hdr->max_display_mastering_luminance_MSB << 8)
		| p_hdr->max_display_mastering_luminance_LSB;
	data->luminance[1] =
		(p_hdr->min_display_mastering_luminance_MSB << 8)
		| p_hdr->min_display_mastering_luminance_LSB;
	data->max_content =
		(p_hdr->max_content_light_level_MSB << 8)
		| p_hdr->max_content_light_level_LSB;
	data->max_frame_average =
		(p_hdr->max_frame_average_light_level_MSB << 8)
		| p_hdr->max_frame_average_light_level_LSB;
	return 0;
}

static int prepare_vsif_pkt(struct dv_vsif_para *vsif,
	struct dovi_setting_s *setting, const struct hdmitx_dev *hdmitx_device)
{
	if (!vsif || !hdmitx_device || !setting)
			return -1;
	vsif->vers.ver2.low_latency = setting->dovi_ll_enable;
	vsif->vers.ver2.dobly_vision_signal = 1;
	if (hdmitx_device->RXCap.dv_info.sup_backlight_control
		&& (setting->ext_md.available_level_mask
		& EXT_MD_AVAIL_LEVEL_2)) {
		vsif->vers.ver2.backlt_ctrl_MD_present = 1;
		vsif->vers.ver2.eff_tmax_PQ_hi =
			setting->ext_md.level_2.target_max_PQ_hi & 0xf;
			vsif->vers.ver2.eff_tmax_PQ_low =
			setting->ext_md.level_2.target_max_PQ_lo;
	} else {
		vsif->vers.ver2.backlt_ctrl_MD_present = 0;
		vsif->vers.ver2.eff_tmax_PQ_hi = 0;
		vsif->vers.ver2.eff_tmax_PQ_low = 0;
	}

	if (setting->dovi_ll_enable
		&& (setting->ext_md.available_level_mask
		& EXT_MD_AVAIL_LEVEL_255)) {
		vsif->vers.ver2.auxiliary_MD_present = 1;
		vsif->vers.ver2.auxiliary_runmode =
			setting->ext_md.level_255.dm_run_mode;
		vsif->vers.ver2.auxiliary_runversion =
			setting->ext_md.level_255.dm_run_version;
		vsif->vers.ver2.auxiliary_debug0 =
			setting->ext_md.level_255.dm_debug0;
	} else {
		vsif->vers.ver2.auxiliary_MD_present = 0;
		vsif->vers.ver2.auxiliary_runmode = 0;
		vsif->vers.ver2.auxiliary_runversion = 0;
		vsif->vers.ver2.auxiliary_debug0 = 0;
	}
	return 0;
}

void send_hdmi_pkt(void)
{
	struct dv_vsif_para vsif;
	struct master_display_info_s drmif;

	if (!is_dolby_enable())
		return;

	printf("apply_stb_core_settings\n");

	if (dovi_setting.dst_format == FORMAT_DOVI) {
		memset(&vsif, 0, sizeof(vsif));
		prepare_vsif_pkt(&vsif, &dovi_setting, &hdmitx_device);

		if (dovi_setting.dovi_ll_enable)
			hdmitx_set_vsif_pkt( EOTF_T_LL_MODE,
				dovi_setting.diagnostic_enable
				? RGB_10_12BIT : YUV422_BIT12,
				&vsif);
		else
			hdmitx_set_vsif_pkt(EOTF_T_DOLBYVISION, RGB_8BIT,
				&vsif);
	} else if (dovi_setting.dst_format == FORMAT_HDR10) {
		memset(&drmif, 0, sizeof(drmif));
		prepare_drm_pkt(&drmif, &dovi_setting, &hdmitx_device);
		hdmitx_set_drm_pkt(&drmif);
	} else
		return;
}

/*check hpd status:
 *1. hdmi connected: set hdr/dv mode based on capability of TV if dv enabled.
 *2. no hdmi: output sdr if dv enabled.
 */
void dolby_vision_process(void)
{
	if (!check_tv_hpd_status(&hdmitx_device)) {
		if (is_dolby_enable()) {
			dovi_setting.dst_format = FORMAT_SDR;
			printf("dolby_vision_process: no hpd, dst_format = SDR\n");
		} else {
			printf("dolby_vision_process: no tv and dv disabled\n");
			setenv("dolby_vision_on", "0");
			run_command("saveenv", 0);
			return;
		}
	} else {
		if (is_dolby_enable()) {
			check_tv_support(&hdmitx_device);
			printf("dolby_vision_process: hpd: dst_format=%d\n",
						dovi_setting.dst_format);
		} else {
			printf("dolby_vision_process: hpd: dv disabled\n");
			setenv("dolby_vision_on", "0");
			run_command("saveenv", 0);
			return;
		}
	}
	if (dovi_setting.dst_format == FORMAT_INVALID) {
		printf("dolby_vision_process: dst_format = FORMAT_INVALID\n");
		return;
	}
	dolby_vision_parse(&hdmitx_device);
	apply_stb_core_settings();
	enable_dolby_vision();
	/*dv send hdmi vsif after hdmi set mode*/
	/* so we add another cmd to send this hdmi package solely*/
}
void dolbyvision_dump_setting() {
	int i;
	uint32_t *p;

	printf("core2\n");
	p = (uint32_t *)&dovi_setting.dm_reg2;
	for (i = 0; i < 24; i++)
		printf("%08x\n", p[i]);
	printf("core2 swap\n");
	for (i = DOLBY_CORE2A_CLKGATE_CTRL;
		i <= DOLBY_CORE2A_DMA_PORT; i++)
		printf("[0x%4x] = 0x%x\n",
			i, READ_VPP_REG(i));
	printf("core2 real reg\n");
	for (i = DOLBY_CORE2A_REG_START;
		i <= DOLBY_CORE2A_REG_START + 5; i++)
		printf("[0x%4x] = 0x%x\n",
			i, READ_VPP_REG(i));

	printf("\ncore2lut\n");
	p = (uint32_t *)&dovi_setting.dm_lut2.TmLutI;
	for (i = 0; i < 64; i++)
		printf("%08x, %08x, %08x, %08x\n",
			p[i*4+3], p[i*4+2], p[i*4+1], p[i*4]);
	printf("\n");
	p = (uint32_t *)&dovi_setting.dm_lut2.TmLutS;
	for (i = 0; i < 64; i++)
		printf("%08x, %08x, %08x, %08x\n",
			p[i*4+3], p[i*4+2], p[i*4+1], p[i*4]);
	printf("\n");
	p = (uint32_t *)&dovi_setting.dm_lut2.SmLutI;
	for (i = 0; i < 64; i++)
		printf("%08x, %08x, %08x, %08x\n",
			p[i*4+3], p[i*4+2], p[i*4+1], p[i*4]);
	printf("\n");
	p = (uint32_t *)&dovi_setting.dm_lut2.SmLutS;
	for (i = 0; i < 64; i++)
		printf("%08x, %08x, %08x, %08x\n",
			p[i*4+3], p[i*4+2], p[i*4+1], p[i*4]);
	printf("\n");
	p = (uint32_t *)&dovi_setting.dm_lut2.G2L;
	for (i = 0; i < 64; i++)
		printf("%08x, %08x, %08x, %08x\n",
			p[i*4+3], p[i*4+2], p[i*4+1], p[i*4]);
	printf("\n");

	printf("core3\n");
	p = (uint32_t *)&dovi_setting.dm_reg3;
	for (i = 0; i < 26; i++)
		printf("%08x\n", p[i]);
	printf("core3 swap\n");
	for (i = DOLBY_CORE3_CLKGATE_CTRL;
		i <= DOLBY_CORE3_CLKGATE_CTRL + 13; i++)
		printf("[0x%4x] = 0x%x\n",
			i, READ_VPP_REG(i));
	printf("core3 real reg\n");
	for (i = DOLBY_CORE3_REG_START;
		i <= DOLBY_CORE3_REG_START + 67; i++)
		printf("[0x%4x] = 0x%x\n",
			i, READ_VPP_REG(i));

	if (dolby_vision_mode <= DOLBY_VISION_OUTPUT_MODE_IPT_TUNNEL) {
		printf("\ncore3_meta %d\n", dovi_setting.md_reg3.size);
		p = dovi_setting.md_reg3.raw_metadata;
		for (i = 0; i < dovi_setting.md_reg3.size; i++)
			printf("%08x\n", p[i]);
		printf("\n");
	}

}
void dolbyvision_debug(int enable_debug) {
	debug_enable = enable_debug;
}
