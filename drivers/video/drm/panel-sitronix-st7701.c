// SPDX-License-Identifier: GPL-2.0+
/*
 * Copyright (C) 2019, Amarula Solutions.
 * Author: Jagan Teki <jagan@amarulasolutions.com>
 */

#include <common.h>
#include <backlight.h>

#include <asm/gpio.h>
#include <dm/device.h>
#include <dm/read.h>
#include <dm/uclass-id.h>
#include <drm/drm_mipi_dsi.h>
#include <linux/bitfield.h>
#include <linux/delay.h>
#include <linux/media-bus-format.h>
#include <power/regulator.h>

#include "rockchip_display.h"
#include "rockchip_connector.h"
#include "rockchip_panel.h"

#define msleep(a) udelay(a * 1000)

/* Command2 BKx selection command */
#define DSI_CMD2BKX_SEL			0xFF

/* Command2, BK0 commands */
#define DSI_CMD2_BK0_PVGAMCTRL		0xB0 /* Positive Voltage Gamma Control */
#define DSI_CMD2_BK0_NVGAMCTRL		0xB1 /* Negative Voltage Gamma Control */
#define DSI_CMD2_BK0_LNESET		0xC0 /* Display Line setting */
#define DSI_CMD2_BK0_PORCTRL		0xC1 /* Porch control */
#define DSI_CMD2_BK0_INVSEL		0xC2 /* Inversion selection, Frame Rate Control */

/* Command2, BK1 commands */
#define DSI_CMD2_BK1_VRHS		0xB0 /* Vop amplitude setting */
#define DSI_CMD2_BK1_VCOM		0xB1 /* VCOM amplitude setting */
#define DSI_CMD2_BK1_VGHSS		0xB2 /* VGH Voltage setting */
#define DSI_CMD2_BK1_TESTCMD		0xB3 /* TEST Command Setting */
#define DSI_CMD2_BK1_VGLS		0xB5 /* VGL Voltage setting */
#define DSI_CMD2_BK1_PWCTLR1		0xB7 /* Power Control 1 */
#define DSI_CMD2_BK1_PWCTLR2		0xB8 /* Power Control 2 */
#define DSI_CMD2_BK1_SPD1		0xC1 /* Source pre_drive timing set1 */
#define DSI_CMD2_BK1_SPD2		0xC2 /* Source EQ2 Setting */
#define DSI_CMD2_BK1_MIPISET1		0xD0 /* MIPI Setting 1 */

/*
 * Command2 with BK function selection.
 *
 * BIT[4].....CN2
 * BIT[1:0]...BKXSEL
 * 1:00 = CMD2BK0, Command2 BK0
 * 1:01 = CMD2BK1, Command2 BK1
 * 1:11 = CMD2BK3, Command2 BK3
 * 0:00 = Command2 disable
 */
#define DSI_CMD2BK0_SEL			0x10
#define DSI_CMD2BK1_SEL			0x11
#define DSI_CMD2BK3_SEL			0x13
#define DSI_CMD2BKX_SEL_NONE		0x00

/* Command2, BK0 bytes */
#define DSI_CMD2_BK0_GAMCTRL_AJ_MASK	GENMASK(7, 6)
#define DSI_CMD2_BK0_GAMCTRL_VC0_MASK	GENMASK(3, 0)
#define DSI_CMD2_BK0_GAMCTRL_VC4_MASK	GENMASK(5, 0)
#define DSI_CMD2_BK0_GAMCTRL_VC8_MASK	GENMASK(5, 0)
#define DSI_CMD2_BK0_GAMCTRL_VC16_MASK	GENMASK(4, 0)
#define DSI_CMD2_BK0_GAMCTRL_VC24_MASK	GENMASK(4, 0)
#define DSI_CMD2_BK0_GAMCTRL_VC52_MASK	GENMASK(3, 0)
#define DSI_CMD2_BK0_GAMCTRL_VC80_MASK	GENMASK(5, 0)
#define DSI_CMD2_BK0_GAMCTRL_VC108_MASK	GENMASK(3, 0)
#define DSI_CMD2_BK0_GAMCTRL_VC147_MASK	GENMASK(3, 0)
#define DSI_CMD2_BK0_GAMCTRL_VC175_MASK	GENMASK(5, 0)
#define DSI_CMD2_BK0_GAMCTRL_VC203_MASK	GENMASK(3, 0)
#define DSI_CMD2_BK0_GAMCTRL_VC231_MASK	GENMASK(4, 0)
#define DSI_CMD2_BK0_GAMCTRL_VC239_MASK	GENMASK(4, 0)
#define DSI_CMD2_BK0_GAMCTRL_VC247_MASK	GENMASK(5, 0)
#define DSI_CMD2_BK0_GAMCTRL_VC251_MASK	GENMASK(5, 0)
#define DSI_CMD2_BK0_GAMCTRL_VC255_MASK	GENMASK(4, 0)
#define DSI_CMD2_BK0_LNESET_LINE_MASK	GENMASK(6, 0)
#define DSI_CMD2_BK0_LNESET_LDE_EN	BIT(7)
#define DSI_CMD2_BK0_LNESET_LINEDELTA	GENMASK(1, 0)
#define DSI_CMD2_BK0_PORCTRL_VBP_MASK	GENMASK(7, 0)
#define DSI_CMD2_BK0_PORCTRL_VFP_MASK	GENMASK(7, 0)
#define DSI_CMD2_BK0_INVSEL_ONES_MASK	GENMASK(5, 4)
#define DSI_CMD2_BK0_INVSEL_NLINV_MASK	GENMASK(2, 0)
#define DSI_CMD2_BK0_INVSEL_RTNI_MASK	GENMASK(4, 0)

/* Command2, BK1 bytes */
#define DSI_CMD2_BK1_VRHA_MASK		GENMASK(7, 0)
#define DSI_CMD2_BK1_VCOM_MASK		GENMASK(7, 0)
#define DSI_CMD2_BK1_VGHSS_MASK		GENMASK(3, 0)
#define DSI_CMD2_BK1_TESTCMD_VAL	BIT(7)
#define DSI_CMD2_BK1_VGLS_ONES		BIT(6)
#define DSI_CMD2_BK1_VGLS_MASK		GENMASK(3, 0)
#define DSI_CMD2_BK1_PWRCTRL1_AP_MASK	GENMASK(7, 6)
#define DSI_CMD2_BK1_PWRCTRL1_APIS_MASK	GENMASK(3, 2)
#define DSI_CMD2_BK1_PWRCTRL1_APOS_MASK	GENMASK(1, 0)
#define DSI_CMD2_BK1_PWRCTRL2_AVDD_MASK	GENMASK(5, 4)
#define DSI_CMD2_BK1_PWRCTRL2_AVCL_MASK	GENMASK(1, 0)
#define DSI_CMD2_BK1_SPD1_ONES_MASK	GENMASK(6, 4)
#define DSI_CMD2_BK1_SPD1_T2D_MASK	GENMASK(3, 0)
#define DSI_CMD2_BK1_SPD2_ONES_MASK	GENMASK(6, 4)
#define DSI_CMD2_BK1_SPD2_T3D_MASK	GENMASK(3, 0)
#define DSI_CMD2_BK1_MIPISET1_ONES	BIT(7)
#define DSI_CMD2_BK1_MIPISET1_EOT_EN	BIT(3)

#define CFIELD_PREP(_mask, _val)					\
	(((typeof(_mask))(_val) << (__builtin_ffsll(_mask) - 1)) & (_mask))

enum op_bias {
	OP_BIAS_OFF = 0,
	OP_BIAS_MIN,
	OP_BIAS_MIDDLE,
	OP_BIAS_MAX
};

struct st7701;

struct st7701_panel_desc {
	const struct drm_display_mode *mode;
	unsigned int lanes;
	enum mipi_dsi_pixel_format format;
	unsigned int panel_sleep_delay;

	/* TFT matrix driver configuration, panel specific. */
	const u8	pv_gamma[16];	/* Positive voltage gamma control */
	const u8	nv_gamma[16];	/* Negative voltage gamma control */
	const u8	nlinv;		/* Inversion selection */
	const u32	vop_uv;		/* Vop in uV */
	const u32	vcom_uv;	/* Vcom in uV */
	const u16	vgh_mv;		/* Vgh in mV */
	const s16	vgl_mv;		/* Vgl in mV */
	const u16	avdd_mv;	/* Avdd in mV */
	const s16	avcl_mv;	/* Avcl in mV */
	const enum op_bias	gamma_op_bias;
	const enum op_bias	input_op_bias;
	const enum op_bias	output_op_bias;
	const u16	t2d_ns;		/* T2D in ns */
	const u16	t3d_ns;		/* T3D in ns */
	const bool	eot_en;

	/* GIP sequence, fully custom and undocumented. */
	void		(*gip_sequence)(struct st7701 *st7701);
};

struct st7701 {
	struct mipi_dsi_device *dsi;

	struct udevice *power_supply;
	struct gpio_desc reset_gpio;

	struct udevice *backlight;

	unsigned int sleep_delay;

	const struct st7701_panel_desc *desc;
};

static inline int st7701_dsi_write(struct st7701 *st7701, const void *seq,
				   size_t len)
{
	return mipi_dsi_dcs_write_buffer(st7701->dsi, seq, len);
}

#define ST7701_DSI(st7701, seq...)				\
	{							\
		const u8 d[] = { seq };				\
		st7701_dsi_write(st7701, d, ARRAY_SIZE(d));	\
	}

static u8 st7701_vgls_map(struct st7701 *st7701)
{
	const struct st7701_panel_desc *desc = st7701->desc;
	struct {
		s32	vgl;
		u8	val;
	} map[16] = {
		{ -7060, 0x0 }, { -7470, 0x1 },
		{ -7910, 0x2 }, { -8140, 0x3 },
		{ -8650, 0x4 }, { -8920, 0x5 },
		{ -9210, 0x6 }, { -9510, 0x7 },
		{ -9830, 0x8 }, { -10170, 0x9 },
		{ -10530, 0xa }, { -10910, 0xb },
		{ -11310, 0xc }, { -11730, 0xd },
		{ -12200, 0xe }, { -12690, 0xf }
	};
	int i;

	for (i = 0; i < ARRAY_SIZE(map); i++)
		if (desc->vgl_mv == map[i].vgl)
			return map[i].val;

	return 0;
}

static void st7701_init_sequence(struct st7701 *st7701)
{
	const struct st7701_panel_desc *desc = st7701->desc;
	const struct drm_display_mode *mode = desc->mode;
	const u8 linecount8 = mode->vdisplay / 8;
	const u8 linecountrem2 = (mode->vdisplay % 8) / 2;

	ST7701_DSI(st7701, MIPI_DCS_SOFT_RESET, 0x00);

	/* We need to wait 5ms before sending new commands */
	msleep(5);

	ST7701_DSI(st7701, MIPI_DCS_EXIT_SLEEP_MODE, 0x00);

	msleep(st7701->sleep_delay);

	/* Command2, BK0 */
	ST7701_DSI(st7701, DSI_CMD2BKX_SEL,
		   0x77, 0x01, 0x00, 0x00, DSI_CMD2BK0_SEL);
	mipi_dsi_dcs_write(st7701->dsi, DSI_CMD2_BK0_PVGAMCTRL,
			   desc->pv_gamma, ARRAY_SIZE(desc->pv_gamma));
	mipi_dsi_dcs_write(st7701->dsi, DSI_CMD2_BK0_NVGAMCTRL,
			   desc->nv_gamma, ARRAY_SIZE(desc->nv_gamma));
	/*
	 * Vertical line count configuration:
	 * Line[6:0]: select number of vertical lines of the TFT matrix in
	 *            multiples of 8 lines
	 * LDE_EN: enable sub-8-line granularity line count
	 * Line_delta[1:0]: add 0/2/4/6 extra lines to line count selected
	 *                  using Line[6:0]
	 *
	 * Total number of vertical lines:
	 * LN = ((Line[6:0] + 1) * 8) + (LDE_EN ? Line_delta[1:0] * 2 : 0)
	 */
	ST7701_DSI(st7701, DSI_CMD2_BK0_LNESET,
		   FIELD_PREP(DSI_CMD2_BK0_LNESET_LINE_MASK, linecount8 - 1) |
		   (linecountrem2 ? DSI_CMD2_BK0_LNESET_LDE_EN : 0),
		   FIELD_PREP(DSI_CMD2_BK0_LNESET_LINEDELTA, linecountrem2));
	ST7701_DSI(st7701, DSI_CMD2_BK0_PORCTRL,
		   FIELD_PREP(DSI_CMD2_BK0_PORCTRL_VBP_MASK,
			      mode->vtotal - mode->vsync_end),
		   FIELD_PREP(DSI_CMD2_BK0_PORCTRL_VFP_MASK,
			      mode->vsync_start - mode->vdisplay));
	/*
	 * Horizontal pixel count configuration:
	 * PCLK = 512 + (RTNI[4:0] * 16)
	 * The PCLK is number of pixel clock per line, which matches
	 * mode htotal. The minimum is 512 PCLK.
	 */
	ST7701_DSI(st7701, DSI_CMD2_BK0_INVSEL,
		   DSI_CMD2_BK0_INVSEL_ONES_MASK |
		   FIELD_PREP(DSI_CMD2_BK0_INVSEL_NLINV_MASK, desc->nlinv),
		   FIELD_PREP(DSI_CMD2_BK0_INVSEL_RTNI_MASK,
			      (clamp((u32)mode->htotal, 512U, 1008U) - 512) / 16));

	/* Command2, BK1 */
	ST7701_DSI(st7701, DSI_CMD2BKX_SEL,
			0x77, 0x01, 0x00, 0x00, DSI_CMD2BK1_SEL);

	/* Vop = 3.5375V + (VRHA[7:0] * 0.0125V) */
	ST7701_DSI(st7701, DSI_CMD2_BK1_VRHS,
		   FIELD_PREP(DSI_CMD2_BK1_VRHA_MASK,
			      DIV_ROUND_CLOSEST(desc->vop_uv - 3537500, 12500)));

	/* Vcom = 0.1V + (VCOM[7:0] * 0.0125V) */
	ST7701_DSI(st7701, DSI_CMD2_BK1_VCOM,
		   FIELD_PREP(DSI_CMD2_BK1_VCOM_MASK,
			      DIV_ROUND_CLOSEST(desc->vcom_uv - 100000, 12500)));

	/* Vgh = 11.5V + (VGHSS[7:0] * 0.5V) */
	ST7701_DSI(st7701, DSI_CMD2_BK1_VGHSS,
		   FIELD_PREP(DSI_CMD2_BK1_VGHSS_MASK,
			      DIV_ROUND_CLOSEST(clamp(desc->vgh_mv,
						      (u16)11500,
						      (u16)17000) - 11500,
						500)));

	ST7701_DSI(st7701, DSI_CMD2_BK1_TESTCMD, DSI_CMD2_BK1_TESTCMD_VAL);

	/* Vgl is non-linear */
	ST7701_DSI(st7701, DSI_CMD2_BK1_VGLS,
		   DSI_CMD2_BK1_VGLS_ONES |
		   FIELD_PREP(DSI_CMD2_BK1_VGLS_MASK, st7701_vgls_map(st7701)));

	ST7701_DSI(st7701, DSI_CMD2_BK1_PWCTLR1,
		   FIELD_PREP(DSI_CMD2_BK1_PWRCTRL1_AP_MASK,
			      desc->gamma_op_bias) |
		   FIELD_PREP(DSI_CMD2_BK1_PWRCTRL1_APIS_MASK,
			      desc->input_op_bias) |
		   FIELD_PREP(DSI_CMD2_BK1_PWRCTRL1_APOS_MASK,
			      desc->output_op_bias));

	/* Avdd = 6.2V + (AVDD[1:0] * 0.2V) , Avcl = -4.4V - (AVCL[1:0] * 0.2V) */
	ST7701_DSI(st7701, DSI_CMD2_BK1_PWCTLR2,
		   FIELD_PREP(DSI_CMD2_BK1_PWRCTRL2_AVDD_MASK,
			      DIV_ROUND_CLOSEST(desc->avdd_mv - 6200, 200)) |
		   FIELD_PREP(DSI_CMD2_BK1_PWRCTRL2_AVCL_MASK,
			      DIV_ROUND_CLOSEST(-4400 + desc->avcl_mv, 200)));

	/* T2D = 0.2us * T2D[3:0] */
	ST7701_DSI(st7701, DSI_CMD2_BK1_SPD1,
		   DSI_CMD2_BK1_SPD1_ONES_MASK |
		   FIELD_PREP(DSI_CMD2_BK1_SPD1_T2D_MASK,
			      DIV_ROUND_CLOSEST(desc->t2d_ns, 200)));

	/* T3D = 4us + (0.8us * T3D[3:0]) */
	ST7701_DSI(st7701, DSI_CMD2_BK1_SPD2,
		   DSI_CMD2_BK1_SPD2_ONES_MASK |
		   FIELD_PREP(DSI_CMD2_BK1_SPD2_T3D_MASK,
			      DIV_ROUND_CLOSEST(desc->t3d_ns - 4000, 800)));

	ST7701_DSI(st7701, DSI_CMD2_BK1_MIPISET1,
		   DSI_CMD2_BK1_MIPISET1_ONES |
		   (desc->eot_en ? DSI_CMD2_BK1_MIPISET1_EOT_EN : 0));
}

static void odroid_vu5s_gip_sequence(struct st7701 *st7701)
{
	ST7701_DSI(st7701, 0xE0, 0x00, 0x00, 0x02);
	ST7701_DSI(st7701, 0xE1, 0x08, 0x00, 0x0A, 0x00, 0x07,
			0x00, 0x09, 0x00, 0x00, 0x33, 0x33);
	ST7701_DSI(st7701, 0xE2, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
			0x00, 0x00, 0x00, 0x00, 0x00);
	ST7701_DSI(st7701, 0xE3, 0x00, 0x00, 0x33, 0x33);
	ST7701_DSI(st7701, 0xE4, 0x44, 0x44);
	ST7701_DSI(st7701, 0xE5, 0x0E, 0x60, 0xA0, 0xA0, 0x10, 0x60, 0xA0, 0xA0,
			0x0A, 0x60, 0xA0, 0xA0, 0x0C, 0x60, 0xA0, 0xA0);
	ST7701_DSI(st7701, 0xE6, 0x00, 0x00, 0x33, 0x33);
	ST7701_DSI(st7701, 0xE7, 0x44, 0x44);
	ST7701_DSI(st7701, 0xE8, 0x0D, 0x60, 0xA0, 0xA0, 0x0F, 0x60, 0xA0, 0xA0,
			0x09, 0x60, 0xA0, 0xA0, 0x0B, 0x60, 0xA0, 0xA0);
	ST7701_DSI(st7701, 0xEB, 0x02, 0x01, 0xE4, 0xE4, 0x44, 0x00, 0x40);
	ST7701_DSI(st7701, 0xEC, 0x02, 0x01);
	ST7701_DSI(st7701, 0xED, 0xAB, 0x89, 0x76, 0x54, 0x01, 0xFF, 0xFF, 0xFF,
			0xFF, 0xFF, 0xFF, 0x10, 0x45, 0x67, 0x98, 0xBA);

	ST7701_DSI(st7701, 0xCC, 0x10);
	ST7701_DSI(st7701, 0xB9, 0x10);

	ST7701_DSI(st7701, 0x3A, 0x70);
	ST7701_DSI(st7701, 0x53, 0xEC);
	ST7701_DSI(st7701, 0x55, 0xB3);
	ST7701_DSI(st7701, 0x5E, 0xFF);
}

static void st7701_prepare(struct rockchip_panel *panel)
{
	struct st7701 *st7701 = dev_get_priv(panel->dev);

	dm_gpio_set_value(&st7701->reset_gpio, 0);

	if (st7701->power_supply) {
		regulator_set_enable(st7701->power_supply, true);
		msleep(20);
	}

	dm_gpio_set_value(&st7701->reset_gpio, 1);
	msleep(150);

	st7701_init_sequence(st7701);

	if (st7701->desc->gip_sequence)
		st7701->desc->gip_sequence(st7701);

	/* Disable Command2 */
	ST7701_DSI(st7701, DSI_CMD2BKX_SEL,
		   0x77, 0x01, 0x00, 0x00, DSI_CMD2BKX_SEL_NONE);

}

static void st7701_enable(struct rockchip_panel *panel)
{
	struct st7701 *st7701 = dev_get_priv(panel->dev);

	ST7701_DSI(st7701, MIPI_DCS_SET_DISPLAY_ON, 0x00);

	if (st7701->backlight)
		backlight_enable(st7701->backlight);
}

static void st7701_disable(struct rockchip_panel *panel)
{
	struct st7701 *st7701 = dev_get_priv(panel->dev);

	ST7701_DSI(st7701, MIPI_DCS_SET_DISPLAY_OFF, 0x00);

	if (st7701->backlight)
		backlight_disable(st7701->backlight);
}

static void st7701_unprepare(struct rockchip_panel *panel)
{
	struct st7701 *st7701 = dev_get_priv(panel->dev);

	ST7701_DSI(st7701, MIPI_DCS_ENTER_SLEEP_MODE, 0x00);

	msleep(st7701->sleep_delay);

	dm_gpio_set_value(&st7701->reset_gpio, 0);

	/**
	 * During the Resetting period, the display will be blanked
	 * (The display is entering blanking sequence, which maximum
	 * time is 120 ms, when Reset Starts in Sleep Out –mode. The
	 * display remains the blank state in Sleep In –mode.) and
	 * then return to Default condition for Hardware Reset.
	 *
	 * So we need wait sleep_delay time to make sure reset completed.
	 */
	msleep(st7701->sleep_delay);
}

static const struct rockchip_panel_funcs st7701_funcs = {
	.prepare	= st7701_prepare,
	.unprepare	= st7701_unprepare,
	.enable		= st7701_enable,
	.disable	= st7701_disable,
};

static const struct drm_display_mode odroid_vu5s_mode = {
	.clock		= 27500,

	.hdisplay	= 480,
	.hsync_start	= 480 + 38,
	.hsync_end	= 480 + 38 + 12,
	.htotal		= 480 + 38 + 12 + 12,

	.vdisplay	= 854,
	.vsync_start	= 854 + 2,
	.vsync_end	= 854 + 2 + 18,
	.vtotal		= 854 + 2 + 18 + 17,

	.flags          = DRM_MODE_FLAG_NHSYNC | DRM_MODE_FLAG_NVSYNC,

	.type = DRM_MODE_TYPE_DRIVER | DRM_MODE_TYPE_PREFERRED,
};

static const struct st7701_panel_desc odroid_vu5s_desc = {
	.mode = &odroid_vu5s_mode,
	.lanes = 2,
	.format = MIPI_DSI_FMT_RGB888,
	.panel_sleep_delay = 80, /* panel need extra 80ms for sleep out cmd */

	.pv_gamma = {
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_AJ_MASK, 0) |
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_VC0_MASK, 0x00),
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_AJ_MASK, 0) |
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_VC4_MASK, 0x0d),
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_AJ_MASK, 0) |
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_VC8_MASK, 0x14),
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_VC16_MASK, 0xd),

		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_AJ_MASK, 0) |
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_VC24_MASK, 0x10),
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_VC52_MASK, 0x5),
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_VC80_MASK, 0x2),
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_VC108_MASK, 0x8),

		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_VC147_MASK, 0x8),
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_VC175_MASK, 0x1e),
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_VC203_MASK, 0x5),
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_AJ_MASK, 0) |
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_VC231_MASK, 0x13),

		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_VC239_MASK, 0xe),
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_AJ_MASK, 0x11) |
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_VC247_MASK, 0xa3),
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_AJ_MASK, 0) |
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_VC251_MASK, 0x29),
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_AJ_MASK, 0) |
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_VC255_MASK, 0x18)
	},
	.nv_gamma = {
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_AJ_MASK, 0) |
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_VC0_MASK, 0),
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_AJ_MASK, 0) |
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_VC4_MASK, 0xc),
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_AJ_MASK, 0) |
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_VC8_MASK, 0x14),
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_VC16_MASK, 0xc),

		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_AJ_MASK, 0) |
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_VC24_MASK, 0x10),
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_VC52_MASK, 0x5),
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_VC80_MASK, 0x3),
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_VC108_MASK, 0x8),

		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_VC147_MASK, 0x7),
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_VC175_MASK, 0x20),
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_VC203_MASK, 0x5),
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_AJ_MASK, 0) |
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_VC231_MASK, 0x13),

		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_VC239_MASK, 0x11),
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_AJ_MASK, 0) |
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_VC247_MASK, 0xa4),
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_AJ_MASK, 0) |
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_VC251_MASK, 0x29),
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_AJ_MASK, 0) |
		CFIELD_PREP(DSI_CMD2_BK0_GAMCTRL_VC255_MASK, 0x18)
	},
	.nlinv = 1,
	.vop_uv = 4887500,
	.vcom_uv = 937500,
	.vgh_mv = 15000,
	.vgl_mv = -9510,
	.avdd_mv = 6600,
	.avcl_mv = -4400,
	.gamma_op_bias = OP_BIAS_MIDDLE,
	.input_op_bias = OP_BIAS_MIN,
	.output_op_bias = OP_BIAS_MIN,
	.t2d_ns = 1600,
	.t3d_ns = 10400,
	.eot_en = true,
	.gip_sequence = odroid_vu5s_gip_sequence,
};

static int st7701_dsi_probe(struct udevice *dev)
{
	struct st7701 *st7701 = dev_get_priv(dev);
	struct rockchip_panel *panel;
	struct mipi_dsi_device *dsi;
	int ret;

	st7701->desc = (const struct st7701_panel_desc *)dev_get_driver_data(dev);

	ret = gpio_request_by_name(dev, "reset-gpios", 0,
				   &st7701->reset_gpio, GPIOD_IS_OUT);
	if (ret && ret != -ENOENT) {
		printf("%s: Cannot get reset GPIO: %d\n", __func__, ret);
		return ret;
	}

	ret = uclass_get_device_by_phandle(UCLASS_PANEL_BACKLIGHT, dev,
					   "backlight", &st7701->backlight);
	if (ret && ret != -ENOENT) {
		dev_err(dev, "%s: Cannot get backlight: %d\n", __func__, ret);
		return ret;
	}

	ret = uclass_get_device_by_phandle(UCLASS_REGULATOR, dev,
					   "power-supply", &st7701->power_supply);
	if (ret && ret != -ENOENT) {
		printf("%s: Cannot get power supply: %d\n", __func__, ret);
		return ret;
	}

	st7701->desc = (const struct st7701_panel_desc *)dev_get_driver_data(dev);

	panel = calloc(1, sizeof(*panel));
	if (!panel)
		return -ENOMEM;

	dev->driver_data = (ulong)panel;
	panel->dev = dev;
	panel->bus_format = MEDIA_BUS_FMT_RGB888_1X24;
	panel->bpc = 8;
	panel->funcs = &st7701_funcs;
	panel->data = st7701->desc->mode;

	dsi = dev_get_parent_platdata(panel->dev);
	dsi->mode_flags = MIPI_DSI_MODE_VIDEO | MIPI_DSI_MODE_VIDEO_BURST |
		MIPI_DSI_MODE_EOT_PACKET;

	dsi->format = st7701->desc->format;
	dsi->lanes = st7701->desc->lanes;

	st7701->dsi = dsi;

	/**
	 * Once sleep out has been issued, ST7701 IC required to wait 120ms
	 * before initiating new commands.
	 *
	 * On top of that some panels might need an extra delay to wait, so
	 * add panel specific delay for those cases. As now this panel specific
	 * delay information is referenced from those panel BSP driver, example
	 * ts8550b and there is no valid documentation for that.
	 */
	st7701->sleep_delay = 120 + st7701->desc->panel_sleep_delay;

	return ret;
}

static const struct udevice_id st7701_of_match[] = {
	{ .compatible = "odroid,vu5s", .data = (ulong)&odroid_vu5s_desc },
	{ }
};

U_BOOT_DRIVER(st7701) = {
	.name = "st7701",
	.id = UCLASS_PANEL,
	.of_match = st7701_of_match,
	.probe = st7701_dsi_probe,
	.priv_auto_alloc_size = sizeof(struct st7701),
	.platdata_auto_alloc_size = sizeof(struct st7701_panel_desc),
};
