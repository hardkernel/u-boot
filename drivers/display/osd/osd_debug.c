/*
 * drivers/osd/osd_hw.c
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
*/

/* System Headers */
#include <config.h>
#include <common.h>
#include <malloc.h>
#include <asm/arch/io.h>
#include <asm/cpu_id.h>
#include <asm/arch/cpu.h>

/* Local Headers */
#ifdef CONFIG_AML_CANVAS
#include <amlogic/canvas.h>
#endif

/* Local Headers */
#include "osd_log.h"
#include "osd_io.h"
#include "osd_hw.h"

#define OSD_TEST_DURATION 500

#define msleep(a) mdelay(a)

extern struct hw_para_s osd_hw;

static void osd_debug_dump_value(void)
{
	u32 index = 0;
	struct hw_para_s *hwpara = NULL;
	struct pandata_s *pdata = NULL;

	osd_get_hw_para(&hwpara);
	if (hwpara == NULL)
		return;

	osd_logi("--- OSD ---\n");
	osd_logi("scan_mode: %s\n", (hwpara->scan_mode == SCAN_MODE_INTERLACE) ? "interlace" : "progressive");
	osd_logi("order: %d\n", hwpara->order);
	osd_logi("bot_type: %d\n", hwpara->bot_type);
	osd_logi("field_out_en: %d\n", hwpara->field_out_en);

	for (index = 0; index < HW_OSD_COUNT; index++) {
		osd_logi("\n--- OSD%d ---\n", index);
		osd_logi("enable: %d\n", hwpara->enable[index]);
		osd_logi("2x-scale enable.h:%d .v: %d\n",
			 hwpara->scale[index].h_enable,
			 hwpara->scale[index].v_enable);
		osd_logi("free-scale-mode: %d\n",
			 hwpara->free_scale_mode[index]);
		osd_logi("free-scale enable.h:%d .v: %d\n",
			 hwpara->free_scale[index].h_enable,
			 hwpara->free_scale[index].v_enable);
		pdata = &hwpara->pandata[index];
		osd_logi("pan data:\n");
		osd_logi("\tx_start: %10d, x_end: %10d\n",
			 pdata->x_start, pdata->x_end);
		osd_logi("\ty_start: %10d, y_end: %10d\n",
			 pdata->y_start, pdata->y_end);

		pdata = &hwpara->dispdata[index];
		osd_logi("disp data:\n");
		osd_logi("\tx_start: 0x%08x, x_end: 0x%08x\n",
			 pdata->x_start, pdata->x_end);
		osd_logi("\ty_start: 0x%08x, y_end: 0x%08x\n",
			 pdata->y_start, pdata->y_end);

		pdata = &hwpara->scaledata[index];
		osd_logi("2x-scale data:\n");
		osd_logi("\tx_start: 0x%08x, x_end: 0x%08x\n",
			 pdata->x_start, pdata->x_end);
		osd_logi("\ty_start: 0x%08x, y_end: 0x%08x\n",
			 pdata->y_start, pdata->y_end);

		pdata = &hwpara->free_scale_data[index];
		osd_logi("free-scale src data:\n");
		osd_logi("\tx_start: 0x%08x, x_end: 0x%08x\n",
			 pdata->x_start, pdata->x_end);
		osd_logi("\ty_start: 0x%08x, y_end: 0x%08x\n",
			 pdata->y_start, pdata->y_end);

		pdata = &hwpara->free_dst_data[index];
		osd_logi("free-scale dst data:\n");
		osd_logi("\tx_start: 0x%08x, x_end: 0x%08x\n",
			 pdata->x_start, pdata->x_end);
		osd_logi("\ty_start: 0x%08x, y_end: 0x%08x\n",
			 pdata->y_start, pdata->y_end);
	}

}

static void osd_debug_dump_register_all(void)
{
	u32 reg = 0;
	u32 offset = 0;
	u32 index = 0;

	reg = VPU_VIU_VENC_MUX_CTRL;
	osd_logi("reg[0x%x]: 0x%08x\n", reg, osd_reg_read(reg));
	reg = VPP_MISC;
	osd_logi("reg[0x%x]: 0x%08x\n", reg, osd_reg_read(reg));
	reg = VPP_OFIFO_SIZE;
	osd_logi("reg[0x%x]: 0x%08x\n", reg, osd_reg_read(reg));
	reg = VPP_HOLD_LINES;
	osd_logi("reg[0x%x]: 0x%08x\n", reg, osd_reg_read(reg));
	if (osd_hw.osd_ver == OSD_HIGH_ONE) {
#ifdef CONFIG_AML_MESON_G12A
		reg = OSD_PATH_MISC_CTRL;
		osd_logi("reg[0x%x]: 0x%08x\n", reg, osd_reg_read(reg));
		reg = VIU_OSD_BLEND_CTRL;
		osd_logi("reg[0x%x]: 0x%08x\n", reg, osd_reg_read(reg));
		reg = VIU_OSD_BLEND_DIN0_SCOPE_H;
		osd_logi("reg[0x%x]: 0x%08x\n", reg, osd_reg_read(reg));
		reg = VIU_OSD_BLEND_DIN0_SCOPE_V;
		osd_logi("reg[0x%x]: 0x%08x\n", reg, osd_reg_read(reg));
		reg = VIU_OSD_BLEND_DIN1_SCOPE_H;
		osd_logi("reg[0x%x]: 0x%08x\n", reg, osd_reg_read(reg));
		reg = VIU_OSD_BLEND_DIN1_SCOPE_V;
		osd_logi("reg[0x%x]: 0x%08x\n", reg, osd_reg_read(reg));
		reg = VIU_OSD_BLEND_DIN2_SCOPE_H;
		osd_logi("reg[0x%x]: 0x%08x\n", reg, osd_reg_read(reg));
		reg = VIU_OSD_BLEND_DIN2_SCOPE_V;
		osd_logi("reg[0x%x]: 0x%08x\n", reg, osd_reg_read(reg));
		reg = VIU_OSD_BLEND_DIN3_SCOPE_H;
		osd_logi("reg[0x%x]: 0x%08x\n", reg, osd_reg_read(reg));
		reg = VIU_OSD_BLEND_DIN3_SCOPE_V;
		osd_logi("reg[0x%x]: 0x%08x\n", reg, osd_reg_read(reg));
		reg = VIU_OSD_BLEND_DUMMY_DATA0;
		osd_logi("reg[0x%x]: 0x%08x\n", reg, osd_reg_read(reg));
		reg = VIU_OSD_BLEND_DUMMY_ALPHA;
		osd_logi("reg[0x%x]: 0x%08x\n", reg, osd_reg_read(reg));
		reg = VIU_OSD_BLEND_BLEND0_SIZE;
		osd_logi("reg[0x%x]: 0x%08x\n", reg, osd_reg_read(reg));
		reg = VIU_OSD_BLEND_BLEND1_SIZE;
		osd_logi("reg[0x%x]: 0x%08x\n", reg, osd_reg_read(reg));

		reg = VPP_OSD1_IN_SIZE;
		osd_logi("reg[0x%x]: 0x%08x\n", reg, osd_reg_read(reg));
		reg = VPP_OSD1_BLD_H_SCOPE;
		osd_logi("reg[0x%x]: 0x%08x\n", reg, osd_reg_read(reg));
		reg = VPP_OSD1_BLD_V_SCOPE;
		osd_logi("reg[0x%x]: 0x%08x\n", reg, osd_reg_read(reg));
		reg = VPP_OSD2_BLD_H_SCOPE;
		osd_logi("reg[0x%x]: 0x%08x\n", reg, osd_reg_read(reg));
		reg = VPP_OSD2_BLD_V_SCOPE;
		osd_logi("reg[0x%x]: 0x%08x\n", reg, osd_reg_read(reg));
		reg = OSD1_BLEND_SRC_CTRL;
		osd_logi("reg[0x%x]: 0x%08x\n", reg, osd_reg_read(reg));
		reg = OSD2_BLEND_SRC_CTRL;
		osd_logi("reg[0x%x]: 0x%08x\n", reg, osd_reg_read(reg));
		reg = VPP_POSTBLEND_H_SIZE;
		osd_logi("reg[0x%x]: 0x%08x\n", reg, osd_reg_read(reg));
		reg = VPP_OUT_H_V_SIZE;
		osd_logi("reg[0x%x]: 0x%08x\n", reg, osd_reg_read(reg));
#endif
	}
	reg = VPP_OSD_SC_CTRL0;
	osd_logi("reg[0x%x]: 0x%08x\n", reg, osd_reg_read(reg));
	reg = VPP_OSD_SCI_WH_M1;
	osd_logi("reg[0x%x]: 0x%08x\n", reg, osd_reg_read(reg));
	reg = VPP_OSD_SCO_H_START_END;
	osd_logi("reg[0x%x]: 0x%08x\n", reg, osd_reg_read(reg));
	reg = VPP_OSD_SCO_V_START_END;
	osd_logi("reg[0x%x]: 0x%08x\n\n", reg, osd_reg_read(reg));
	reg = VPP_POSTBLEND_H_SIZE;
	osd_logi("reg[0x%x]: 0x%08x\n\n", reg, osd_reg_read(reg));
	for (index = 0; index < 2; index++) {
		if (index == 1)
			offset = REG_OFFSET;
		reg = offset + VIU_OSD1_FIFO_CTRL_STAT;
		osd_logi("reg[0x%x]: 0x%08x\n", reg, osd_reg_read(reg));
		reg = offset + VIU_OSD1_CTRL_STAT;
		osd_logi("reg[0x%x]: 0x%08x\n", reg, osd_reg_read(reg));
		reg = offset + VIU_OSD1_BLK0_CFG_W0;
		osd_logi("reg[0x%x]: 0x%08x\n", reg, osd_reg_read(reg));
		reg = offset + VIU_OSD1_BLK0_CFG_W1;
		osd_logi("reg[0x%x]: 0x%08x\n", reg, osd_reg_read(reg));
		reg = offset + VIU_OSD1_BLK0_CFG_W2;
		osd_logi("reg[0x%x]: 0x%08x\n", reg, osd_reg_read(reg));
		reg = offset + VIU_OSD1_BLK0_CFG_W3;
		osd_logi("reg[0x%x]: 0x%08x\n", reg, osd_reg_read(reg));
		reg = VIU_OSD1_BLK0_CFG_W4;
		if (index == 1)
			reg = VIU_OSD2_BLK0_CFG_W4;
		osd_logi("reg[0x%x]: 0x%08x\n\n", reg, osd_reg_read(reg));
	}
}

static void osd_test_colorbar(void)
{
	u32 encp_video_adv = 0;

	encp_video_adv = osd_reg_read(ENCP_VIDEO_MODE_ADV);

	/* start test mode */
	osd_logi("--- OSD TEST COLORBAR ---\n");
	osd_reg_write(ENCP_VIDEO_MODE_ADV, 0);
	osd_reg_write(VENC_VIDEO_TST_EN, 1);
	/* TST_MODE COLORBAR */
	osd_logi("- COLORBAR -\n");
	osd_reg_write(VENC_VIDEO_TST_MDSEL, 1);
	msleep(OSD_TEST_DURATION);

	/* TST_MODE THINLINE */
	osd_logi("- THINLINE -\n");
	osd_reg_write(VENC_VIDEO_TST_MDSEL, 2);
	msleep(OSD_TEST_DURATION);
	/* TST_MODE DOTGRID */
	osd_logi("- DOTGRID -\n");
	osd_reg_write(VENC_VIDEO_TST_MDSEL, 3);
	msleep(OSD_TEST_DURATION);

	/* stop test mode */
	osd_reg_write(ENCP_VIDEO_MODE_ADV, encp_video_adv);
	osd_reg_write(VENC_VIDEO_TST_EN, 0);
	osd_reg_write(VENC_VIDEO_TST_MDSEL, 0);
}

static void osd_reset(void)
{
	osd_set_free_scale_enable_hw(0, 0);
	osd_enable_hw(0, 1);
}

static void osd_test_dummydata(void)
{
	u32 dummy_data = 0;

	dummy_data = osd_reg_read(VPP_DUMMY_DATA1);
	osd_reset();
	osd_logi("--- OSD TEST DUMMYDATA ---\n");
	if (osd_hw.osd_ver == OSD_HIGH_ONE) {
#ifdef CONFIG_AML_MESON_G12A
		osd_reg_write(VPP_POST_BLEND_BLEND_DUMMY_DATA, 0xff);
		msleep(OSD_TEST_DURATION);
		osd_reg_write(VPP_POST_BLEND_BLEND_DUMMY_DATA, 0xff00);
		msleep(OSD_TEST_DURATION);
		osd_reg_write(VPP_POST_BLEND_BLEND_DUMMY_DATA, 0xff0000);
		msleep(OSD_TEST_DURATION);
		osd_reg_write(VPP_POST_BLEND_BLEND_DUMMY_DATA, dummy_data);
		msleep(OSD_TEST_DURATION);
#endif
	} else if (get_cpu_id().family_id ==
		MESON_CPU_MAJOR_ID_GXTVBB) {
		osd_reg_write(VPP_DUMMY_DATA1, 0xFF0000); /* R */
		msleep(OSD_TEST_DURATION);
		osd_reg_write(VPP_DUMMY_DATA1, 0xFF00); /* G */
		msleep(OSD_TEST_DURATION);
		osd_reg_write(VPP_DUMMY_DATA1, 0xFF); /* B */
		msleep(OSD_TEST_DURATION);
		osd_reg_write(VPP_DUMMY_DATA1, dummy_data);
		msleep(OSD_TEST_DURATION);

	} else {
		osd_reg_write(VPP_DUMMY_DATA1, 0xFF);
		msleep(OSD_TEST_DURATION);
		osd_reg_write(VPP_DUMMY_DATA1, 0);
		msleep(OSD_TEST_DURATION);
		osd_reg_write(VPP_DUMMY_DATA1, 0xFF00);
		msleep(OSD_TEST_DURATION);
		osd_reg_write(VPP_DUMMY_DATA1, dummy_data);
		msleep(OSD_TEST_DURATION);
	}
}

static void osd_debug_auto_test(void)
{
	osd_test_colorbar();

	osd_test_dummydata();
}

void osd_debug(void)
{
	osd_debug_dump_value();
	osd_logi("\n");
	osd_debug_dump_register_all();
}

void osd_test(void)
{
	osd_debug_auto_test();
}
