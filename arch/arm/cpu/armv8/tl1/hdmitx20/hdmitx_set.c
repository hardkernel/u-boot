
/*
 * arch/arm/cpu/armv8/txl/hdmitx20/hdmitx_set.c
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

#include <common.h>
#include <asm/io.h>
#include <asm/arch/register.h>
#include <amlogic/hdmi.h>
#include "hdmitx_reg.h"
#include "hdmitx_tvenc.h"
#include "mach_reg.h"
#include "hw_enc_clk_config.h"

const static char *vend_name = "Amlogic"; /* Max 8 bytes */
const static char *prod_desc = "MBox Meson Ref"; /* Max 16 bytes */

struct hdmitx_dev hdmitx_device;

static void hdmi_tvenc_set(enum hdmi_vic vic);
extern void _udelay(unsigned int us);
static void hdmitx_set_phy(struct hdmitx_dev *hdev);
static void set_tmds_clk_div40(unsigned int div40);

#define HSYNC_POLARITY      1                       // HSYNC polarity: active high
#define VSYNC_POLARITY      1                       // VSYNC polarity: active high

#define TX_INPUT_COLOR_FORMAT   HDMI_COLOR_FORMAT_444   // Pixel format: 0=RGB444; 1=YCbCr422; 2=YCbCr444; 3=YCbCr420.
#define TX_INPUT_COLOR_RANGE    HDMI_COLOR_RANGE_LIM    // Pixel range: 0=limited; 1=full.
#define TX_OUTPUT_COLOR_RANGE   HDMI_COLOR_RANGE_LIM    // Pixel range: 0=limited; 1=full.

// TODO  Delete later
#define CLK_UTIL_VID_PLL_DIV_1      0
#define CLK_UTIL_VID_PLL_DIV_2      1
#define CLK_UTIL_VID_PLL_DIV_3      2
#define CLK_UTIL_VID_PLL_DIV_3p5    3
#define CLK_UTIL_VID_PLL_DIV_3p75   4
#define CLK_UTIL_VID_PLL_DIV_4      5
#define CLK_UTIL_VID_PLL_DIV_5      6
#define CLK_UTIL_VID_PLL_DIV_6      7
#define CLK_UTIL_VID_PLL_DIV_6p25   8
#define CLK_UTIL_VID_PLL_DIV_7      9
#define CLK_UTIL_VID_PLL_DIV_7p5    10
#define CLK_UTIL_VID_PLL_DIV_12     11
#define CLK_UTIL_VID_PLL_DIV_14     12
#define CLK_UTIL_VID_PLL_DIV_15     13

static int hdmitx_get_hpd_state(void)
{
	int st = 0;

	st = !!(hd_read_reg(P_PREG_PAD_GPIO3_I) & (1 << 2));
	return st;
}

static void ddc_pinmux_init(void)
{
	hd_set_reg_bits(P_PAD_PULL_UP_EN_REG3, 0, 0, 2);    // Disable GPIOH_1/2 pull-up/down
	hd_set_reg_bits(P_PAD_PULL_UP_REG3, 0, 0, 2);
	hd_set_reg_bits(P_PREG_PAD_GPIO3_EN_N, 3, 0, 2);     // GPIOH_1/2 input
	hd_set_reg_bits(P_PERIPHS_PIN_MUX_B, 0x11, 0, 8);      // Mux DDC SDA/SCL
}

static void hdelay(int us)
{
	_udelay(us * 1000);
}

#define mdelay(i)   hdelay(i)
#define msleep(i)   hdelay(i)

static void hdmitx_set_hw(struct hdmitx_dev *hdev);

// Internal functions:
static void hdmitx_csc_config (unsigned char input_color_format,
                        unsigned char output_color_format,
                        unsigned char color_depth);

static void dump_regs(void)
{
	unsigned int reg_adr;
	unsigned int reg_val;
	unsigned int ladr;
	for (reg_adr = 0x0000; reg_adr < 0x0100; reg_adr ++) {
                ladr = 0xc883c000 + (reg_adr << 2);
		reg_val = hd_read_reg(ladr);
		printk("[0x%08x] = 0x%X\n", ladr, reg_val);
	}
#define VPU_REG_ADDR(reg) (0xd0100000 + (reg << 2))
	for (reg_adr = 0x1b00; reg_adr < 0x1c00; reg_adr ++) {
		ladr = VPU_REG_ADDR(reg_adr);
		reg_val = hd_read_reg(ladr);
		printk("[0x%08x] = 0x%X\n", ladr, reg_val);
	}
	for (reg_adr = 0x1c01; reg_adr < 0x1d00; reg_adr ++) {
		ladr = VPU_REG_ADDR(reg_adr);
		reg_val = hd_read_reg(ladr);
		printk("[0x%08x] = 0x%X\n", ladr, reg_val);
	}
	for (reg_adr = 0x2700; reg_adr < 0x2780; reg_adr ++) {
		ladr = VPU_REG_ADDR(reg_adr);
		reg_val = hd_read_reg(ladr);
		printk("[0x%08x] = 0x%X\n", ladr, reg_val);
	}
	for (reg_adr = HDMITX_TOP_SW_RESET; reg_adr < HDMITX_TOP_STAT0 + 1; reg_adr ++) {
		reg_val = hdmitx_rd_reg(reg_adr);
		printk("TOP[0x%x]: 0x%x\n", reg_adr, reg_val);
	}
	for (reg_adr = HDMITX_DWC_DESIGN_ID; reg_adr < HDMITX_DWC_I2CM_SCDC_UPDATE1 + 1; reg_adr ++) {
		if ((reg_adr > HDMITX_DWC_HDCP_BSTATUS_0 -1) && (reg_adr < HDMITX_DWC_HDCPREG_BKSV0)) {
            //hdmitx_wr_reg(HDMITX_DWC_A_KSVMEMCTRL, 0x1);
//            hdmitx_poll_reg(HDMITX_DWC_A_KSVMEMCTRL, (1<<1), 2 * HZ);
			reg_val = 0;//hdmitx_rd_reg(reg_adr);
		} else {
			reg_val = hdmitx_rd_reg(reg_adr);
		}
		if (reg_val) {
			// excluse HDCP regisiters
			if ((reg_adr < HDMITX_DWC_A_HDCPCFG0) || (reg_adr > HDMITX_DWC_CEC_CTRL))
				printk("DWC[0x%x]: 0x%x\n", reg_adr, reg_val);
		}
	}
}

static void hdmitx_hw_init(void)
{
	static int hw_init_flag;

	if (hw_init_flag)
		return;
	else
		hw_init_flag = 1;

	/* Enable clocks and bring out of reset */

	/* Enable hdmitx_sys_clk */
	/* .clk0 ( cts_oscin_clk ), */
	/* .clk1 ( fclk_div4 ), */
	/* .clk2 ( fclk_div3 ), */
	/* .clk3 ( fclk_div5 ), */
	hd_set_reg_bits(P_HHI_HDMI_CLK_CNTL, 0x0100, 0, 16);

	/* Enable clk81_hdmitx_pclk */
	hd_set_reg_bits(P_HHI_GCLK_MPEG2, 1, 4, 1);

	/* wire	wr_enable = control[3]; */
	/* wire	fifo_enable = control[2]; */
	/* assign phy_clk_en = control[1]; */
	/* Enable tmds_clk */
	/* Bring HDMITX MEM output of power down */
	hd_set_reg_bits(P_HHI_MEM_PD_REG0, 0, 8, 8);
	/* reset HDMITX APB & TX & PHY */
	//hd_set_reg_bits(P_RESET0_REGISTER, 1, 19, 1);
	//hd_set_reg_bits(P_RESET2_REGISTER, 1, 15, 1);
	//hd_set_reg_bits(P_RESET2_REGISTER, 1,  2, 1);
	// Enable APB3 fail on error
	//hd_set_reg_bits(P_HDMITX_CTRL_PORT, 1, 15, 1);
	//hd_set_reg_bits((P_HDMITX_CTRL_PORT + 0x10), 1, 15, 1);
	/* Bring out of reset */
	hdmitx_wr_reg(HDMITX_TOP_SW_RESET,  0);
	_udelay(200);
	/* Enable internal pixclk, tmds_clk, spdif_clk, i2s_clk, cecclk */
	hdmitx_wr_reg(HDMITX_TOP_CLK_CNTL,  0x000000ff);

	hdmitx_wr_reg(HDMITX_DWC_MC_LOCKONCLOCK, 0xff);

	hdmitx_wr_reg(HDMITX_DWC_MC_CLKDIS, 0x00);
}

/*
 * Note: read 8 Bytes of EDID data every time
 */
static int read_edid_8bytes(unsigned char *rx_edid, unsigned char addr)
{
	unsigned int timeout = 0;
	unsigned int i = 0;
	// Program SLAVE/SEGMENT/ADDR
	hdmitx_wr_reg(HDMITX_DWC_I2CM_SLAVE, 0x50);
	hdmitx_wr_reg(HDMITX_DWC_I2CM_SEGADDR, 0x30);
	hdmitx_wr_reg(HDMITX_DWC_I2CM_SEGPTR, 0);
	hdmitx_wr_reg(HDMITX_DWC_I2CM_ADDRESS, addr & 0xff);
	hdmitx_wr_reg(HDMITX_DWC_I2CM_OPERATION, 1 << 3);
	timeout = 0;
	while ((!(hdmitx_rd_reg(HDMITX_DWC_IH_I2CM_STAT0) & (1 << 1))) && (timeout < 3)) {
		mdelay(2);
		timeout ++;
	}
	if (timeout == 3) {
		printk("ddc timeout\n");
		return 0;
	}
	hdmitx_wr_reg(HDMITX_DWC_IH_I2CM_STAT0, 1 << 1);        // clear INT
	// Read back 8 bytes
	for (i = 0; i < 8; i ++) {
		rx_edid[i] = hdmitx_rd_reg(HDMITX_DWC_I2CM_READ_BUFF0 + i);
	}
	return 1;
}

static void ddc_init(void)
{
	static int ddc_init_flag;
	unsigned int data32 = 0;


	if (ddc_init_flag)
		return;
	else
		ddc_init_flag = 1;

	ddc_pinmux_init();

	data32  = 0;
	data32 |= (0    << 6);  // [  6] read_req_mask
	data32 |= (0    << 2);  // [  2] done_mask
	hdmitx_wr_reg(HDMITX_DWC_I2CM_INT,      data32);

	data32  = 0;
	data32 |= (0    << 6);  // [  6] nack_mask
	data32 |= (0    << 2);  // [  2] arbitration_error_mask
	hdmitx_wr_reg(HDMITX_DWC_I2CM_CTLINT,   data32);

	data32  = 0;
	data32 |= (0    << 3);  // [  3] i2c_fast_mode: 0=standard mode; 1=fast mode.
	hdmitx_wr_reg(HDMITX_DWC_I2CM_DIV,      data32);

	hdmitx_wr_reg(HDMITX_DWC_I2CM_SS_SCL_HCNT_1, 0);
	hdmitx_wr_reg(HDMITX_DWC_I2CM_SS_SCL_HCNT_0, 0xcf);
	hdmitx_wr_reg(HDMITX_DWC_I2CM_SS_SCL_LCNT_1, 0);
	hdmitx_wr_reg(HDMITX_DWC_I2CM_SS_SCL_LCNT_0, 0xff);
	hdmitx_wr_reg(HDMITX_DWC_I2CM_FS_SCL_HCNT_1, 0);
	hdmitx_wr_reg(HDMITX_DWC_I2CM_FS_SCL_HCNT_0, 0x0f);
	hdmitx_wr_reg(HDMITX_DWC_I2CM_FS_SCL_LCNT_1, 0);
	hdmitx_wr_reg(HDMITX_DWC_I2CM_FS_SCL_LCNT_0, 0x20);
	hdmitx_wr_reg(HDMITX_DWC_I2CM_SDA_HOLD,	0x08);

	data32  = 0;
	data32 |= (0    << 5);  // [  5] updt_rd_vsyncpoll_en
	data32 |= (0    << 4);  // [  4] read_request_en  // scdc
	data32 |= (0    << 0);  // [  0] read_update
	hdmitx_wr_reg(HDMITX_DWC_I2CM_SCDC_UPDATE,  data32);
}

static int hdmitx_read_edid(unsigned char *buf, unsigned char addr, unsigned char size)
{
	ddc_init();
	if ((addr + size) > 256)
		return 0;
	return read_edid_8bytes(buf, addr);
}

static void scdc_rd_sink(unsigned char adr, unsigned char *val)
{
	hdmitx_wr_reg(HDMITX_DWC_I2CM_SLAVE, 0x54);
	hdmitx_wr_reg(HDMITX_DWC_I2CM_ADDRESS, adr);
	hdmitx_wr_reg(HDMITX_DWC_I2CM_OPERATION, 1);
	_udelay(2000);
	*val = (unsigned char)hdmitx_rd_reg(HDMITX_DWC_I2CM_DATAI);
}

static void scdc_wr_sink(unsigned char adr, unsigned char val)
{
	hdmitx_wr_reg(HDMITX_DWC_I2CM_SLAVE, 0x54);
	hdmitx_wr_reg(HDMITX_DWC_I2CM_ADDRESS, adr);
	hdmitx_wr_reg(HDMITX_DWC_I2CM_DATAO, val);
	hdmitx_wr_reg(HDMITX_DWC_I2CM_OPERATION, 0x10);
	_udelay(2000);
}

static void scdc_prepare(unsigned int div)
{
	unsigned char rx_ver = 0;

	scdc_rd_sink(SINK_VER, &rx_ver);
	if (rx_ver != 1)
		scdc_rd_sink(SINK_VER, &rx_ver);	/* Recheck */
	printf("rx version is %s  div=%d\n",
		(rx_ver == 1) ? "2.0" : "1.4 or below",
		div ? 40 : 10);

	scdc_wr_sink(SOURCE_VER, 0x1);
	scdc_wr_sink(SOURCE_VER, 0x1);
	scdc_wr_sink(TMDS_CFG, div ? 0x3 : 0); /* TMDS 1/40 & Scramble */
	scdc_wr_sink(TMDS_CFG, div ? 0x3 : 0); /* TMDS 1/40 & Scramble */
}

static void hdmitx_turnoff(void)
{
        /* Close HDMITX PHY */
        hd_write_reg(P_HHI_HDMI_PHY_CNTL0, 0);
        hd_write_reg(P_HHI_HDMI_PHY_CNTL3, 0);
        hd_write_reg(P_HHI_HDMI_PHY_CNTL5, 0);
        /* Disable HPLL */
        hd_write_reg(P_HHI_HDMI_PLL_CNTL0, 0);
}

static struct hdmi_support_mode gxbb_modes[] = {
	{HDMI_3840x2160p60_16x9, "2160p60hz", 0},
	{HDMI_3840x2160p50_16x9, "2160p50hz", 0},
	{HDMI_3840x2160p30_16x9, "2160p30hz", 0},
	{HDMI_3840x2160p25_16x9, "2160p25hz", 0},
	{HDMI_3840x2160p24_16x9, "2160p24hz", 0},
	{HDMI_4096x2160p60_256x135, "smpte60hz", 0},
	{HDMI_4096x2160p50_256x135, "smpte50hz", 0},
	{HDMI_4096x2160p30_256x135, "smpte30hz", 0},
	{HDMI_4096x2160p25_256x135, "smpte25hz", 0},
	{HDMI_4096x2160p24_256x135, "smpte24hz", 0},
	{HDMI_3840x2160p60_16x9, "2160p60hz420", 1},
	{HDMI_3840x2160p50_16x9, "2160p50hz420", 1},
	{HDMI_4096x2160p50_256x135, "smpte50hz420", 1},
	{HDMI_4096x2160p60_256x135, "smpte60hz420", 1},
	{HDMI_1920x1080p60_16x9, "1080p60hz", 0},
	{HDMI_1920x1080p50_16x9, "1080p50hz", 0},
	{HDMI_1920x1080p30_16x9, "1080p30hz", 0},
	{HDMI_1920x1080p25_16x9, "1080p25hz", 0},
	{HDMI_1920x1080p24_16x9, "1080p24hz", 0},
	{HDMI_1920x1080i60_16x9, "1080i60hz", 0},
	{HDMI_1920x1080i50_16x9, "1080i50hz", 0},
	{HDMI_1280x720p60_16x9, "720p60hz", 0},
	{HDMI_1280x720p50_16x9, "720p50hz", 0},
	{HDMI_720x576p50_16x9, "576p50hz", 0},
	{HDMI_720x480p60_16x9, "480p60hz", 0},
	{HDMI_720x576i50_16x9, "576i50hz", 0},
	{HDMI_720x480i60_16x9, "480i60hz", 0},
};

static void hdmitx_list_support_modes(void)
{
	int i;

	for (i = 0; i < ARRAY_SIZE(gxbb_modes); i++)
		printf("%s\n", gxbb_modes[i].sname);
}

static void hdmitx_test_bist(unsigned int mode)
{
	unsigned int i;

	switch (mode) {
	case 1:
	case 2:
	case 3:
		hd_set_reg_bits(P_ENCP_VIDEO_MODE_ADV, 0, 3, 1);
		hd_write_reg(P_VENC_VIDEO_TST_EN, 1);
		hd_write_reg(P_VENC_VIDEO_TST_MDSEL, mode);
		break;
	/* prbs test */
	case 10:
		for (i = 0; i < 4; i ++) {
			hd_write_reg(P_HHI_HDMI_PHY_CNTL1, 0x0390000f);
			hd_write_reg(P_HHI_HDMI_PHY_CNTL1, 0x0390000e);
			hd_write_reg(P_HHI_HDMI_PHY_CNTL1, 0x03904002);
			hd_write_reg(P_HHI_HDMI_PHY_CNTL4, 0x0001efff | (i << 20));
			hd_write_reg(P_HHI_HDMI_PHY_CNTL1, 0xef904002);
			mdelay(10);
			if (i > 0)
				pr_info("prbs D[%d]:%lx\n", i -1, hd_read_reg(P_HHI_HDMI_PHY_STATUS));
			else
				pr_info("prbs clk :%lx\n",hd_read_reg(P_HHI_HDMI_PHY_STATUS));
		}
		break;
	case 0:
	default:
		hd_set_reg_bits(P_ENCP_VIDEO_MODE_ADV, 1, 3, 1);
		hd_write_reg(P_VENC_VIDEO_TST_EN, 0);
		break;
	}
}

static void hdmitx_output_blank(unsigned int blank)
{
	if (blank == 1)
		hd_write_reg(P_VPU_HDMI_DATA_OVR,
			((1 << 31) | (1 << 29) | (1 << 9)));
	if (blank == 0)
		hd_write_reg(P_VPU_HDMI_DATA_OVR, 0);
}

void hdmi_tx_init(void)
{
	hdmitx_device.HWOp.get_hpd_state = hdmitx_get_hpd_state;
	hdmitx_device.HWOp.read_edid = hdmitx_read_edid;
	hdmitx_device.HWOp.turn_off = hdmitx_turnoff;
	hdmitx_device.HWOp.list_support_modes = hdmitx_list_support_modes;
	hdmitx_device.HWOp.dump_regs = dump_regs;
	hdmitx_device.HWOp.test_bist = hdmitx_test_bist;
	hdmitx_device.HWOp.output_blank = hdmitx_output_blank;
}

void hdmi_tx_set(struct hdmitx_dev *hdev)
{
	hdmitx_hw_init();
	hdmitx_debug();
	ddc_init();
	hdmitx_set_hw(hdev);
	hdmitx_debug();
	return;

#if 0
	hdmi_tx_gate(vic);
	hdmi_tx_clk(vic);
	hdmi_tx_misc(vic);
	hdmi_tx_enc(vic);
	hdmi_tx_set_vend_spec_infofram(vic);
	hdmi_tx_phy(vic);
#endif
}

int hdmi_outputmode_check(char *mode)
{
	int i, ret = -1;

	for (i = 0; i < ARRAY_SIZE(gxbb_modes); i++) {
		if (!strcmp(mode, gxbb_modes[i].sname)) {
			ret = 0;
			break;
		}
	}

	if (ret)
		printf("hdmitx: outputmode[%s] is invalid\n", mode);
	return ret;
}

#define __asmeq(x, y)  ".ifnc " x "," y " ; .err ; .endif\n\t"
static void hdcp14_init(void)
{
	register long x0 asm("x0") = 0x82000012;
	asm volatile(
		__asmeq("%0", "x0")
		"smc #0\n"
		: : "r"(x0)
	);
}

/*
 * set Source Product Description InfoFrame
 */
static void hdmitx_set_spdinfo(void)
{
	int i;

	if (!(vend_name && prod_desc))
		return;

	for (i = 0; (i < 8) && vend_name[i]; i++)
		hdmitx_wr_reg(HDMITX_DWC_FC_SPDVENDORNAME0 + i, vend_name[i]);
	for (i = 0; (i < 16) && prod_desc[i]; i++)
		hdmitx_wr_reg(HDMITX_DWC_FC_SDPPRODUCTNAME0 + i, prod_desc[i]);
	hdmitx_wr_reg(HDMITX_DWC_FC_SPDDEVICEINF, 0x1);
	hdmitx_set_reg_bits(HDMITX_DWC_FC_DATAUTO0, 1, 4, 1);
	hdmitx_set_reg_bits(HDMITX_DWC_FC_DATAUTO2, 1, 4, 4);
	hdmitx_set_reg_bits(HDMITX_DWC_FC_PACKET_TX_EN, 1, 4, 1);
}

#define NUM_INT_VSYNC   INT_VEC_VIU1_VSYNC

static unsigned long modulo(unsigned long a, unsigned long b);
static signed int to_signed(unsigned int a);

static void config_hdmi20_tx ( enum hdmi_vic vic, struct hdmi_format_para *para,
                        unsigned char   color_depth,            // Pixel bit width: 4=24-bit; 5=30-bit; 6=36-bit; 7=48-bit.
                        unsigned char   input_color_format,     // Pixel format: 0=RGB444; 1=YCbCr422; 2=YCbCr444; 3=YCbCr420.
                        unsigned char   input_color_range,      // Pixel range: 0=limited; 1=full.
                        unsigned char   output_color_format,    // Pixel format: 0=RGB444; 1=YCbCr422; 2=YCbCr444; 3=YCbCr420.
                        unsigned char   output_color_range     // Pixel range: 0=limited; 1=full.
                    )          // 0:TMDS_CLK_rate=TMDS_Character_rate; 1:TMDS_CLK_rate=TMDS_Character_rate/4, for TMDS_Character_rate>340Mcsc.
{
	struct hdmi_cea_timing *t = &para->timing;
	unsigned long   data32;
	unsigned char   vid_map;
	unsigned char   csc_en;
	unsigned char   default_phase = 0;
	unsigned char   tmp = 0;

#define GET_TIMING(name)      (t->name)

	hdmitx_hw_init();

	data32  = 0;
	data32 |= (1 << 12);
	data32 |= (0 << 8);
	data32 |= (0 << 0);
	hdmitx_wr_reg(HDMITX_TOP_BIST_CNTL, data32);

	/* Configure video */

	// Configure video sampler
    vid_map = ( input_color_format == HDMI_COLOR_FORMAT_RGB )?  ((color_depth == HDMI_COLOR_DEPTH_24B)? 0x01    :
                                                                 (color_depth == HDMI_COLOR_DEPTH_30B)? 0x03    :
                                                                 (color_depth == HDMI_COLOR_DEPTH_36B)? 0x05    :
                                                                                                        0x07)   :
              ((input_color_format == HDMI_COLOR_FORMAT_444) ||
               (input_color_format == HDMI_COLOR_FORMAT_420))?  ((color_depth == HDMI_COLOR_DEPTH_24B)? 0x09    :
                                                                 (color_depth == HDMI_COLOR_DEPTH_30B)? 0x0b    :
                                                                 (color_depth == HDMI_COLOR_DEPTH_36B)? 0x0d    :
                                                                                                        0x0f)   :
                                                                ((color_depth == HDMI_COLOR_DEPTH_24B)? 0x16    :
                                                                 (color_depth == HDMI_COLOR_DEPTH_30B)? 0x14    :
                                                                                                        0x12);

	data32  = 0;
	data32 |= (0 << 7);
	data32 |= (vid_map << 0);
	hdmitx_wr_reg(HDMITX_DWC_TX_INVID0, data32);

	data32  = 0;
	data32 |= (0 << 2);
	data32 |= (0 << 1);
	data32 |= (0 << 0);
	hdmitx_wr_reg(HDMITX_DWC_TX_INSTUFFING, data32);
	hdmitx_wr_reg(HDMITX_DWC_TX_GYDATA0, 0x00);
	hdmitx_wr_reg(HDMITX_DWC_TX_GYDATA1, 0x00);
	hdmitx_wr_reg(HDMITX_DWC_TX_RCRDATA0, 0x00);
	hdmitx_wr_reg(HDMITX_DWC_TX_RCRDATA1, 0x00);
	hdmitx_wr_reg(HDMITX_DWC_TX_BCBDATA0, 0x00);
	hdmitx_wr_reg(HDMITX_DWC_TX_BCBDATA1, 0x00);

	/* Configure Color Space Converter */

	csc_en  = (input_color_format != output_color_format) ? 1 : 0;

	data32  = 0;
	data32 |= (csc_en   << 0);
	hdmitx_wr_reg(HDMITX_DWC_MC_FLOWCTRL, data32);

    data32  = 0;
    data32 |= ((((input_color_format ==HDMI_COLOR_FORMAT_422) &&
                 (output_color_format!=HDMI_COLOR_FORMAT_422))? 2 : 0 ) << 4);  // [5:4] intmode
    data32 |= ((((input_color_format !=HDMI_COLOR_FORMAT_422) &&
                 (output_color_format==HDMI_COLOR_FORMAT_422))? 2 : 0 ) << 0);  // [1:0] decmode
	hdmitx_wr_reg(HDMITX_DWC_CSC_CFG, data32);

	hdmitx_csc_config(input_color_format, output_color_format, color_depth);

	/* Configure video packetizer */

	/* Video Packet color depth and pixel repetition */
	data32  = 0;
	data32 |= (((output_color_format==HDMI_COLOR_FORMAT_422)? HDMI_COLOR_DEPTH_24B : color_depth)   << 4);  // [7:4] color_depth
	data32 |= (0 << 0);
	if ((data32 & 0xf0) == 0x40 )
		data32 &= ~(0xf << 4);
	hdmitx_wr_reg(HDMITX_DWC_VP_PR_CD, data32);
	if (output_color_format == HDMI_COLOR_FORMAT_422) {
		switch (color_depth) {
		case HDMI_COLOR_DEPTH_24B:
			tmp = 4;
			break;
		default:
			tmp = 0;
			break;
		}
		hdmitx_set_reg_bits(HDMITX_DWC_VP_PR_CD, tmp, 4, 4);
	}

	/* Video Packet Stuffing */
	data32  = 0;
	data32 |= (default_phase << 5);
	data32 |= (0 << 2);
	data32 |= (0 << 1);
	data32 |= (0 << 0);
	hdmitx_wr_reg(HDMITX_DWC_VP_STUFF,  data32);

	/* Video Packet YCC color remapping */
	data32  = 0;
	hdmitx_wr_reg(HDMITX_DWC_VP_REMAP, data32);
	if (output_color_format == HDMI_COLOR_FORMAT_422) {
		switch (color_depth) {
		case HDMI_COLOR_DEPTH_36B:
			tmp = 2;
			break;
		case HDMI_COLOR_DEPTH_30B:
			tmp = 1;
			break;
		case HDMI_COLOR_DEPTH_24B:
			tmp = 0;
			break;
		}
	}
	hdmitx_set_reg_bits(HDMITX_DWC_VP_REMAP, tmp, 0, 2);  // [1:0] ycc422_size

	/* Video Packet configuration */
	data32  = 0;
	data32 |= ((((output_color_format != HDMI_COLOR_FORMAT_422) &&
		(color_depth == HDMI_COLOR_DEPTH_24B))? 1 : 0) << 6);  // [  6] bypass_en
	data32 |= ((((output_color_format == HDMI_COLOR_FORMAT_422) ||
		(color_depth == HDMI_COLOR_DEPTH_24B))? 0 : 1) << 5);  // [  5] pp_en
	data32 |= (0 << 4);  // [  4] pr_en
	data32 |= (((output_color_format == HDMI_COLOR_FORMAT_422)?  1 : 0) << 3);  // [  3] ycc422_en
	data32 |= (1 << 2);  // [  2] pr_bypass_select
	data32 |= (((output_color_format == HDMI_COLOR_FORMAT_422)? 1 :
		(color_depth == HDMI_COLOR_DEPTH_24B)?  2 : 0)  << 0);  // [1:0] output_selector: 0=pixel packing; 1=YCC422 remap; 2/3=8-bit bypass
	hdmitx_wr_reg(HDMITX_DWC_VP_CONF, data32);

	data32  = 0;
	data32 |= (1 << 7);
	data32 |= (1 << 6);
	data32 |= (1 << 5);
	data32 |= (1 << 4);
	data32 |= (1 << 3);
	data32 |= (1 << 2);
	data32 |= (1 << 1);
	data32 |= (1 << 0);
	hdmitx_wr_reg(HDMITX_DWC_VP_MASK, data32);

	/* Configure audio */
	/* I2S Sampler config */

	data32  = 0;
	data32 |= (1 << 3);
	data32 |= (1 << 2);
	hdmitx_wr_reg(HDMITX_DWC_AUD_INT, data32);

	data32  = 0;
	data32 |= (1 << 4);
	hdmitx_wr_reg(HDMITX_DWC_AUD_INT1,  data32);

	hdmitx_wr_reg(HDMITX_DWC_FC_MULTISTREAM_CTRL, 0);

/* if enable it now, fifo_overrun will happen, because packet don't get
 * sent out until initial DE detected.
 */
	data32  = 0;
	data32 |= (0 << 7);
	data32 |= (1 << 5);
	data32 |= (0 << 0);
	hdmitx_wr_reg(HDMITX_DWC_AUD_CONF0, data32);

	data32  = 0;
	data32 |= (0 << 5);
	data32 |= (24   << 0);
	hdmitx_wr_reg(HDMITX_DWC_AUD_CONF1, data32);

	data32  = 0;
	data32 |= (0 << 1);
	data32 |= (0 << 0);
	hdmitx_wr_reg(HDMITX_DWC_AUD_CONF2, data32);

	/* spdif sampler config */

	data32  = 0;
	data32 |= (1 << 3);
	data32 |= (1 << 2);
	hdmitx_wr_reg(HDMITX_DWC_AUD_SPDIFINT,  data32);

	data32  = 0;
	data32 |= (0 << 4);
	hdmitx_wr_reg(HDMITX_DWC_AUD_SPDIFINT1, data32);

	data32  = 0;
	data32 |= (0 << 7);
	hdmitx_wr_reg(HDMITX_DWC_AUD_SPDIF0,	data32);

	data32  = 0;
	data32 |= (0 << 7);
	data32 |= (0 << 6);
	data32 |= (24 << 0);
	hdmitx_wr_reg(HDMITX_DWC_AUD_SPDIF1,	data32);

	/* Frame Composer configuration */

	/* Video definitions, as per output video(for packet gen/schedulling) */

	data32  = 0;
	data32 |= (1 << 7);
	data32 |= (GET_TIMING(vsync_polarity) << 6);
	data32 |= (GET_TIMING(hsync_polarity) << 5);
	data32 |= (1 << 4);
	data32 |= (1 << 3);
	data32 |= (!(para->progress_mode) << 1);
	data32 |= (!(para->progress_mode) << 0);
	hdmitx_wr_reg(HDMITX_DWC_FC_INVIDCONF,  data32);

	data32  = GET_TIMING(h_active)&0xff;
	hdmitx_wr_reg(HDMITX_DWC_FC_INHACTV0,   data32);
	data32  = (GET_TIMING(h_active)>>8) & 0x3f;
	hdmitx_wr_reg(HDMITX_DWC_FC_INHACTV1,   data32);

	data32  = GET_TIMING(h_blank) & 0xff;
	hdmitx_wr_reg(HDMITX_DWC_FC_INHBLANK0,  data32);
	data32  = (GET_TIMING(h_blank)>>8)&0x1f;
	hdmitx_wr_reg(HDMITX_DWC_FC_INHBLANK1,  data32);

	data32  = GET_TIMING(v_active)&0xff;
	hdmitx_wr_reg(HDMITX_DWC_FC_INVACTV0,   data32);
	data32  = (GET_TIMING(v_active)>>8)&0x1f;
	hdmitx_wr_reg(HDMITX_DWC_FC_INVACTV1,   data32);

	data32  = GET_TIMING(v_blank)&0xff;
	hdmitx_wr_reg(HDMITX_DWC_FC_INVBLANK,   data32);

	data32  = GET_TIMING(h_front)&0xff;
	hdmitx_wr_reg(HDMITX_DWC_FC_HSYNCINDELAY0,  data32);
	data32  = (GET_TIMING(h_front)>>8)&0x1f;
	hdmitx_wr_reg(HDMITX_DWC_FC_HSYNCINDELAY1,  data32);

	data32  = GET_TIMING(h_sync)&0xff;
	hdmitx_wr_reg(HDMITX_DWC_FC_HSYNCINWIDTH0,  data32);
	data32  = (GET_TIMING(h_sync)>>8)&0x3;
	hdmitx_wr_reg(HDMITX_DWC_FC_HSYNCINWIDTH1,  data32);

	data32  = GET_TIMING(v_front)&0xff;
	hdmitx_wr_reg(HDMITX_DWC_FC_VSYNCINDELAY,   data32);

	data32  = GET_TIMING(v_sync)&0x3f;
	hdmitx_wr_reg(HDMITX_DWC_FC_VSYNCINWIDTH,   data32);

	/* control period duration (typ 12 tmds periods) */
	hdmitx_wr_reg(HDMITX_DWC_FC_CTRLDUR,	12);
	/* extended control period duration (typ 32 tmds periods) */
	hdmitx_wr_reg(HDMITX_DWC_FC_EXCTRLDUR,  32);
	/* max interval betwen extended control period duration (typ 50) */
	hdmitx_wr_reg(HDMITX_DWC_FC_EXCTRLSPAC, 1);
	/* preamble filler */
	hdmitx_wr_reg(HDMITX_DWC_FC_CH0PREAM, 0x0b);
	hdmitx_wr_reg(HDMITX_DWC_FC_CH1PREAM, 0x16);
	hdmitx_wr_reg(HDMITX_DWC_FC_CH2PREAM, 0x21);

	/* write GCP packet configuration */
	data32  = 0;
	data32 |= (default_phase << 2);
	data32 |= (0 << 1);
	data32 |= (1 << 0);
	hdmitx_wr_reg(HDMITX_DWC_FC_GCP, data32);

	/* write AVI Infoframe packet configuration */

	data32  = 0;
	data32 |= (((output_color_format>>2)&0x1) << 7);
	data32 |= (1 << 6);
	data32 |= (0 << 4);
	data32 |= (0 << 2);
	data32 |= (0x2 << 0);    /* FIXED YCBCR 444 */
	hdmitx_wr_reg(HDMITX_DWC_FC_AVICONF0, data32);
	switch (output_color_format) {
	case HDMI_COLOR_FORMAT_RGB:
		tmp = 0;
		break;
	case HDMI_COLOR_FORMAT_422:
		tmp = 1;
		break;
	case HDMI_COLOR_FORMAT_420:
		tmp = 3;
		break;
	case HDMI_COLOR_FORMAT_444:
	default:
		tmp = 2;
		break;
	}
	hdmitx_set_reg_bits(HDMITX_DWC_FC_AVICONF0, tmp, 0, 2);

	hdmitx_wr_reg(HDMITX_DWC_FC_AVICONF1, 0x8);
	hdmitx_wr_reg(HDMITX_DWC_FC_AVICONF2, 0);

	/* set Aspect Ratio in AVIInfo */
	switch (para->vic) {
	case HDMI_640x480p60_4x3:
	case HDMI_720x480p60_4x3:
	case HDMI_720x480i60_4x3:
	case HDMI_720x240p60_4x3:
	case HDMI_2880x480i60_4x3:
	case HDMI_2880x240p60_4x3:
	case HDMI_1440x480p60_4x3:
	case HDMI_720x576p50_4x3:
	case HDMI_720x576i50_4x3:
	case HDMI_720x288p_4x3:
	case HDMI_2880x576i50_4x3:
	case HDMI_2880x288p50_4x3:
	case HDMI_1440x576p_4x3:
	case HDMI_2880x480p60_4x3:
	case HDMI_2880x576p50_4x3:
	case HDMI_720x576p100_4x3:
	case HDMI_720x576i100_4x3:
	case HDMI_720x480p120_4x3:
	case HDMI_720x480i120_4x3:
	case HDMI_720x576p200_4x3:
	case HDMI_720x576i200_4x3:
	case HDMI_720x480p240_4x3:
	case HDMI_720x480i240_4x3:
		/* Picture Aspect Ratio M1/M0 4:3 */
		hdmitx_set_reg_bits(HDMITX_DWC_FC_AVICONF1, 0x1, 4, 2);
		break;
	default:
		/* Picture Aspect Ratio M1/M0 16:9 */
		hdmitx_set_reg_bits(HDMITX_DWC_FC_AVICONF1, 0x2, 4, 2);
		break;
	}
	/* Active Format Aspect Ratio R3~R0 Same as picture aspect ratio */
	hdmitx_set_reg_bits(HDMITX_DWC_FC_AVICONF1, 0x8, 0, 4);

	/* set Colorimetry in AVIInfo */
	switch (para->vic) {
	case HDMI_640x480p60_4x3:
	case HDMI_720x480p60_4x3:
	case HDMI_720x480p60_16x9:
	case HDMI_720x480i60_4x3:
	case HDMI_720x480i60_16x9:
	case HDMI_720x240p60_4x3:
	case HDMI_720x240p60_16x9:
	case HDMI_2880x480i60_4x3:
	case HDMI_2880x480i60_16x9:
	case HDMI_2880x240p60_4x3:
	case HDMI_2880x240p60_16x9:
	case HDMI_1440x480p60_4x3:
	case HDMI_1440x480p60_16x9:
	case HDMI_720x576p50_4x3:
	case HDMI_720x576p50_16x9:
	case HDMI_720x576i50_4x3:
	case HDMI_720x576i50_16x9:
	case HDMI_720x288p_4x3:
	case HDMI_720x288p_16x9:
	case HDMI_2880x576i50_4x3:
	case HDMI_2880x576i50_16x9:
	case HDMI_2880x288p50_4x3:
	case HDMI_2880x288p50_16x9:
	case HDMI_1440x576p_4x3:
	case HDMI_1440x576p_16x9:
	case HDMI_2880x480p60_4x3:
	case HDMI_2880x480p60_16x9:
	case HDMI_2880x576p50_4x3:
	case HDMI_2880x576p50_16x9:
	case HDMI_720x576p100_4x3:
	case HDMI_720x576p100_16x9:
	case HDMI_720x576i100_4x3:
	case HDMI_720x576i100_16x9:
	case HDMI_720x480p120_4x3:
	case HDMI_720x480p120_16x9:
	case HDMI_720x480i120_4x3:
	case HDMI_720x480i120_16x9:
	case HDMI_720x576p200_4x3:
	case HDMI_720x576p200_16x9:
	case HDMI_720x576i200_4x3:
	case HDMI_720x576i200_16x9:
	case HDMI_720x480p240_4x3:
	case HDMI_720x480p240_16x9:
	case HDMI_720x480i240_4x3:
	case HDMI_720x480i240_16x9:
		/* C1C0 601 , now is 709*/
		hdmitx_set_reg_bits(HDMITX_DWC_FC_AVICONF1, 1, 6, 2);
		hdmitx_set_reg_bits(HDMITX_DWC_FC_AVICONF2, 0, 4, 3);
		break;
	default:
		/* C1C0 709 */
		hdmitx_set_reg_bits(HDMITX_DWC_FC_AVICONF1, 2, 6, 2);
		hdmitx_set_reg_bits(HDMITX_DWC_FC_AVICONF2, 0, 4, 3);
		break;
	}

	data32  = 0;
	data32 |= (((output_color_range == HDMI_COLOR_RANGE_FUL)?1:0)   << 2);  // [3:2] YQ
	data32 |= (0 << 0);
	hdmitx_wr_reg(HDMITX_DWC_FC_AVICONF3,   data32);

	hdmitx_wr_reg(HDMITX_DWC_FC_AVIVID, para->vic);

/* the audio setting bellow are only used for I2S audio IEC60958-3 frame
 * insertion
 */


	/* packet queue priority (auto mode) */
	hdmitx_wr_reg(HDMITX_DWC_FC_CTRLQHIGH,  15);
	hdmitx_wr_reg(HDMITX_DWC_FC_CTRLQLOW, 3);

	/* packet scheduller configuration for SPD, VSD, ISRC1/2, ACP. */
	data32  = 0;
	data32 |= (0 << 4);
	data32 |= (0 << 3);
	data32 |= (0 << 2);
	data32 |= (0 << 1);
	data32 |= (0 << 0);
	hdmitx_wr_reg(HDMITX_DWC_FC_DATAUTO0, data32);
	hdmitx_set_spdinfo();
	hdmitx_wr_reg(HDMITX_DWC_FC_DATAUTO1, 0);
	hdmitx_wr_reg(HDMITX_DWC_FC_DATAUTO2, 0);
	hdmitx_wr_reg(HDMITX_DWC_FC_DATMAN, 0);

	/* packet scheduller configuration for AVI, GCP, AUDI, ACR. */
	data32  = 0;
	data32 |= (0 << 5);
	data32 |= (0 << 4);
	data32 |= (0 << 3);
	data32 |= (1 << 2);
	data32 |= (1 << 1);
	data32 |= (0 << 0);
	hdmitx_wr_reg(HDMITX_DWC_FC_DATAUTO3, data32);
	hdmitx_wr_reg(HDMITX_DWC_FC_RDRB0,  0);
	hdmitx_wr_reg(HDMITX_DWC_FC_RDRB1,  0);
	hdmitx_wr_reg(HDMITX_DWC_FC_RDRB2,  0);
	hdmitx_wr_reg(HDMITX_DWC_FC_RDRB3,  0);
	hdmitx_wr_reg(HDMITX_DWC_FC_RDRB4,  0);
	hdmitx_wr_reg(HDMITX_DWC_FC_RDRB5,  0);
	/* AVI info usb RDRB mode and place in line 10*/
	hdmitx_wr_reg(HDMITX_DWC_FC_RDRB6,  0);
	hdmitx_wr_reg(HDMITX_DWC_FC_RDRB7,  0x1a);
	hdmitx_wr_reg(HDMITX_DWC_FC_RDRB8,  0);
	hdmitx_wr_reg(HDMITX_DWC_FC_RDRB9,  0);
	hdmitx_wr_reg(HDMITX_DWC_FC_RDRB10, 0);
	hdmitx_wr_reg(HDMITX_DWC_FC_RDRB11, 0);

	/* Packet transmission enable */
	data32  = 0;
	data32 |= (0 << 6);
	data32 |= (0 << 5);
	data32 |= (0 << 4);
	data32 |= (1 << 3);
	data32 |= (1 << 2);
	data32 |= (1 << 1);
	data32 |= (1 << 0);
	hdmitx_wr_reg(HDMITX_DWC_FC_PACKET_TX_EN, data32);

	/* For 3D video */
	data32  = 0;
	data32 |= (0 << 1);
	data32 |= (0 << 0);
	hdmitx_wr_reg(HDMITX_DWC_FC_ACTSPC_HDLR_CFG, data32);

	data32  = GET_TIMING(v_active)&0xff;
	hdmitx_wr_reg(HDMITX_DWC_FC_INVACT_2D_0,	data32);
	data32  = (GET_TIMING(v_active)>>8)&0xf;
	hdmitx_wr_reg(HDMITX_DWC_FC_INVACT_2D_1,	data32);

	/* Do not enable these interrupt below, we can check them at RX side. */
	data32  = 0;
	data32 |= (1 << 7);
	data32 |= (1 << 6);
	data32 |= (1 << 5);
	data32 |= (1 << 2);
	data32 |= (1 << 1);
	data32 |= (1 << 0);
	hdmitx_wr_reg(HDMITX_DWC_FC_MASK0,  data32);

	data32  = 0;
	data32 |= (1 << 7);
	data32 |= (1 << 6);
	data32 |= (1 << 5);
	data32 |= (1 << 4);
	data32 |= (1 << 3);
	data32 |= (1 << 1);
	data32 |= (1 << 0);
	hdmitx_wr_reg(HDMITX_DWC_FC_MASK1,  data32);

	data32  = 0;
	data32 |= (1 << 1);
	data32 |= (1 << 0);
	hdmitx_wr_reg(HDMITX_DWC_FC_MASK2,  data32);

	/* Pixel repetition ratio the input and output video */
	data32  = 0;
	data32 |= ((para->pixel_repetition_factor+1) << 4);
	data32 |= (para->pixel_repetition_factor << 0);
	hdmitx_wr_reg(HDMITX_DWC_FC_PRCONF, data32);

	/* Configure HDCP */
	data32  = 0;
	data32 |= (0 << 7);
	data32 |= (0 << 6);
	data32 |= (0 << 4);
	data32 |= (0 << 3);
	data32 |= (0 << 2);
	data32 |= (0 << 1);
	data32 |= (1 << 0);
	hdmitx_wr_reg(HDMITX_DWC_A_APIINTMSK, data32);

	data32  = 0;
	data32 |= (0 << 5);
	data32 |= (1 << 4);
	data32 |= (1 << 3);
	data32 |= (1 << 1);
	hdmitx_wr_reg(HDMITX_DWC_A_VIDPOLCFG,   data32);

	hdmitx_wr_reg(HDMITX_DWC_A_OESSWCFG,    0x40);

	hdcp14_init();

	/* Interrupts */
	/* Clear interrupts */
	hdmitx_wr_reg(HDMITX_DWC_IH_FC_STAT0,  0xff);
	hdmitx_wr_reg(HDMITX_DWC_IH_FC_STAT1,  0xff);
	hdmitx_wr_reg(HDMITX_DWC_IH_FC_STAT2,  0xff);
	hdmitx_wr_reg(HDMITX_DWC_IH_AS_STAT0,  0xff);
	hdmitx_wr_reg(HDMITX_DWC_IH_PHY_STAT0, 0xff);
	hdmitx_wr_reg(HDMITX_DWC_IH_I2CM_STAT0,	0xff);
	hdmitx_wr_reg(HDMITX_DWC_IH_CEC_STAT0, 0xff);
	hdmitx_wr_reg(HDMITX_DWC_IH_VP_STAT0,  0xff);
	hdmitx_wr_reg(HDMITX_DWC_IH_I2CMPHY_STAT0, 0xff);
	hdmitx_wr_reg(HDMITX_DWC_A_APIINTCLR,  0xff);
	hdmitx_wr_reg(HDMITX_DWC_HDCP22REG_STAT, 0xff);

	hdmitx_wr_reg(HDMITX_TOP_INTR_STAT_CLR,	0x0000001f);

	/* Selectively enable/mute interrupt sources */
	data32  = 0;
	data32 |= (1 << 7);
	data32 |= (1 << 6);
	data32 |= (1 << 5);
	data32 |= (1 << 4);
	data32 |= (1 << 3);
	data32 |= (1 << 2);
	data32 |= (1 << 1);
	data32 |= (1 << 0);
	hdmitx_wr_reg(HDMITX_DWC_IH_MUTE_FC_STAT0,  data32);

	data32  = 0;
	data32 |= (1 << 7);
	data32 |= (1 << 6);
	data32 |= (1 << 5);
	data32 |= (1 << 4);
	data32 |= (1 << 3);
	data32 |= (1 << 2);
	data32 |= (1 << 1);
	data32 |= (1 << 0);
	hdmitx_wr_reg(HDMITX_DWC_IH_MUTE_FC_STAT1,  data32);

	data32  = 0;
	data32 |= (1 << 1);
	data32 |= (1 << 0);
	hdmitx_wr_reg(HDMITX_DWC_IH_MUTE_FC_STAT2,  data32);

	data32  = 0;
	data32 |= (0 << 4);
	data32 |= (0 << 3);
	data32 |= (1 << 2);
	data32 |= (1 << 1);
	data32 |= (1 << 0);
	hdmitx_wr_reg(HDMITX_DWC_IH_MUTE_AS_STAT0,  data32);

	hdmitx_wr_reg(HDMITX_DWC_IH_MUTE_PHY_STAT0, 0x3f);

	data32  = 0;
	data32 |= (0 << 2);
	data32 |= (1 << 1);
	data32 |= (0 << 0);
	hdmitx_wr_reg(HDMITX_DWC_IH_MUTE_I2CM_STAT0, data32);

	data32  = 0;
	data32 |= (0 << 6);
	data32 |= (0 << 5);
	data32 |= (0 << 4);
	data32 |= (0 << 3);
	data32 |= (0 << 2);
	data32 |= (0 << 1);
	data32 |= (0 << 0);
	hdmitx_wr_reg(HDMITX_DWC_IH_MUTE_CEC_STAT0, data32);

	hdmitx_wr_reg(HDMITX_DWC_IH_MUTE_VP_STAT0,  0xff);

	hdmitx_wr_reg(HDMITX_DWC_IH_MUTE_I2CMPHY_STAT0, 0x03);

	data32  = 0;
	data32 |= (0 << 1);
	data32 |= (0 << 0);
	hdmitx_wr_reg(HDMITX_DWC_IH_MUTE, data32);

	data32  = 0;
	data32 |= (1 << 4);
	data32 |= (1 << 3);
	data32 |= (1 << 2);
	data32 |= (1 << 1);
	data32 |= (1 << 0);
	hdmitx_wr_reg(HDMITX_TOP_INTR_MASKN, data32);

	/* Reset pulse */
	hdmitx_rd_check_reg(HDMITX_DWC_MC_LOCKONCLOCK, 0xff, 0x9f);

	hd_write_reg(P_ENCP_VIDEO_EN, 0);
	hdmitx_wr_reg(HDMITX_DWC_MC_CLKDIS, 0xdf);

	hdmitx_wr_reg(HDMITX_DWC_MC_SWRSTZREQ, 0);
	mdelay(10);

	data32  = 0;
	data32 |= (1 << 7);
	data32 |= (1 << 6);
	data32 |= (1 << 4);
	data32 |= (1 << 3);
	data32 |= (1 << 2);
	data32 |= (0 << 1);
	data32 |= (1 << 0);
	hdmitx_wr_reg(HDMITX_DWC_MC_SWRSTZREQ, data32);
	hdmitx_wr_reg(HDMITX_DWC_FC_VSYNCINWIDTH,
		hdmitx_rd_reg(HDMITX_DWC_FC_VSYNCINWIDTH));

	hdmitx_wr_reg(HDMITX_DWC_MC_CLKDIS, 0);
	hd_write_reg(P_ENCP_VIDEO_EN, 0xff);
} /* config_hdmi20_tx */

/* Set TV encoder for HDMI */
static void hdmitx_enc(enum hdmi_vic vic)
{
	set_vmode_enc_hw(vic);
	hdmi_tvenc_set(vic);
	return;
}

static void hdmitx_set_pll(struct hdmitx_dev *hdev)
{
	hdmitx_set_clk(hdev);
}

static void set_phy_by_mode(unsigned int mode)
{
	switch (mode) {
	case 1: /* 5.94/4.5/3.7Gbps */
		hd_write_reg(P_HHI_HDMI_PHY_CNTL0, 0x37eb65c4);
		hd_write_reg(P_HHI_HDMI_PHY_CNTL3, 0x2ab0ff3b);
		hd_write_reg(P_HHI_HDMI_PHY_CNTL5, 0x0000080b);
		break;
	case 2: /* 2.97Gbps */
		hd_write_reg(P_HHI_HDMI_PHY_CNTL0, 0x33eb6262);
		hd_write_reg(P_HHI_HDMI_PHY_CNTL3, 0x2ab0ff3b);
		hd_write_reg(P_HHI_HDMI_PHY_CNTL5, 0x00000003);
		break;
	case 3: /* 1.485Gbps, and below */
	default:
		hd_write_reg(P_HHI_HDMI_PHY_CNTL0, 0x33eb4242);
		hd_write_reg(P_HHI_HDMI_PHY_CNTL3, 0x2ab0ff3b);
		hd_write_reg(P_HHI_HDMI_PHY_CNTL5, 0x00000003);
		break;
	}
}

static void hdmitx_set_phy(struct hdmitx_dev *hdev)
{
	if (!hdev)
		return;

	switch (hdev->vic) {
	case HDMI_3840x2160p50_16x9:
	case HDMI_3840x2160p60_16x9:
	case HDMI_4096x2160p50_256x135:
	case HDMI_4096x2160p60_256x135:
		if ((hdev->para->cs == HDMI_COLOR_FORMAT_420)
			&& (hdev->para->cd == HDMI_COLOR_DEPTH_24B))
			set_phy_by_mode(2);
		else
			set_phy_by_mode(1);
		break;
	case HDMI_3840x2160p50_16x9_Y420:
	case HDMI_3840x2160p60_16x9_Y420:
	case HDMI_4096x2160p50_256x135_Y420:
	case HDMI_4096x2160p60_256x135_Y420:
		if (hdev->para->cd == HDMI_COLOR_DEPTH_24B)
			set_phy_by_mode(2);
		else
			set_phy_by_mode(1);
		break;
	case HDMI_3840x2160p24_16x9:
	case HDMI_3840x2160p24_64x27:
	case HDMI_3840x2160p25_16x9:
	case HDMI_3840x2160p25_64x27:
	case HDMI_3840x2160p30_16x9:
	case HDMI_3840x2160p30_64x27:
	case HDMI_4096x2160p24_256x135:
	case HDMI_4096x2160p25_256x135:
	case HDMI_4096x2160p30_256x135:
		if ((hdev->para->cs == HDMI_COLOR_FORMAT_422)
			|| (hdev->para->cd == HDMI_COLOR_DEPTH_24B))
			set_phy_by_mode(2);
		else
			set_phy_by_mode(1);
		break;
	case HDMI_1920x1080p60_16x9:
	case HDMI_1920x1080p50_16x9:
	case HDMI_1920x1080i100_16x9:
	case HDMI_1920x1080i120_16x9:
	case HDMI_1280x720p100_16x9:
	case HDMI_1280x720p120_16x9:
	default:
		set_phy_by_mode(3);
		break;
	}
/* P_HHI_HDMI_PHY_CNTL1	bit[1]: enable clock	bit[0]: soft reset */
#define RESET_HDMI_PHY() \
do { \
	hd_set_reg_bits(P_HHI_HDMI_PHY_CNTL1, 0xf, 0, 4); \
	mdelay(2); \
	hd_set_reg_bits(P_HHI_HDMI_PHY_CNTL1, 0xe, 0, 4); \
	mdelay(2); \
} while (0)

	hd_set_reg_bits(P_HHI_HDMI_PHY_CNTL1, 0x0390, 16, 16);
	hd_set_reg_bits(P_HHI_HDMI_PHY_CNTL1, 0x0, 0, 4);
	RESET_HDMI_PHY();
	RESET_HDMI_PHY();
	RESET_HDMI_PHY();
#undef RESET_HDMI_PHY

	printk("hdmitx phy setting done\n");
}

/*
 * mode: 1 means Progressive;  0 means interlaced
 */
static void enc_vpu_bridge_reset(int mode)
{
    unsigned int wr_clk = 0;

    printk("%s[%d]\n", __func__, __LINE__);
    wr_clk = (hd_read_reg(P_VPU_HDMI_SETTING) & 0xf00) >> 8;
    if (mode) {
        hd_write_reg(P_ENCP_VIDEO_EN, 0);
        hd_set_reg_bits(P_VPU_HDMI_SETTING, 0, 0, 2);  // [    0] src_sel_enci: Disable ENCP output to HDMI
        hd_set_reg_bits(P_VPU_HDMI_SETTING, 0, 8, 4);  // [    0] src_sel_enci: Disable ENCP output to HDMI
        mdelay(1);
        hd_write_reg(P_ENCP_VIDEO_EN, 1);
        mdelay(1);
        hd_set_reg_bits(P_VPU_HDMI_SETTING, wr_clk, 8, 4);
        mdelay(1);
        hd_set_reg_bits(P_VPU_HDMI_SETTING, 2, 0, 2);  // [    0] src_sel_enci: Enable ENCP output to HDMI
    } else {
        hd_write_reg(P_ENCI_VIDEO_EN, 0);
        hd_set_reg_bits(P_VPU_HDMI_SETTING, 0, 0, 2);  // [    0] src_sel_enci: Disable ENCI output to HDMI
        hd_set_reg_bits(P_VPU_HDMI_SETTING, 0, 8, 4);  // [    0] src_sel_enci: Disable ENCP output to HDMI
        mdelay(1);
        hd_write_reg(P_ENCI_VIDEO_EN, 1);
        mdelay(1);
        hd_set_reg_bits(P_VPU_HDMI_SETTING, wr_clk, 8, 4);
        mdelay(1);
        hd_set_reg_bits(P_VPU_HDMI_SETTING, 1, 0, 2);  // [    0] src_sel_enci: Enable ENCI output to HDMI
    }
}

static void hdmi_tvenc1080i_set(enum hdmi_vic vic)
{
	unsigned long VFIFO2VD_TO_HDMI_LATENCY = 2;
	unsigned long TOTAL_PIXELS = 0, PIXEL_REPEAT_HDMI = 0,
		PIXEL_REPEAT_VENC = 0, ACTIVE_PIXELS = 0;
	unsigned FRONT_PORCH = 88, HSYNC_PIXELS = 0, ACTIVE_LINES = 0,
		INTERLACE_MODE = 0, TOTAL_LINES = 0, SOF_LINES = 0,
		VSYNC_LINES = 0;
	unsigned LINES_F0 = 0, LINES_F1 = 563, BACK_PORCH = 0;

	unsigned long total_pixels_venc = 0;
	unsigned long active_pixels_venc = 0;
	unsigned long front_porch_venc = 0;
	unsigned long hsync_pixels_venc = 0;

	unsigned long de_h_begin = 0, de_h_end = 0;
	unsigned long de_v_begin_even = 0, de_v_end_even = 0,
		de_v_begin_odd = 0, de_v_end_odd = 0;
	unsigned long hs_begin = 0, hs_end = 0;
	unsigned long vs_adjust = 0;
	unsigned long vs_bline_evn = 0, vs_eline_evn = 0,
		vs_bline_odd = 0, vs_eline_odd = 0;
	unsigned long vso_begin_evn = 0, vso_begin_odd = 0;

	if ((vic == HDMI_1920x1080i60_16x9) ||
		(vic == HDMI_1920x1080i120_16x9)) {
		INTERLACE_MODE = 1;
		PIXEL_REPEAT_VENC = 1;
		PIXEL_REPEAT_HDMI = 0;
		ACTIVE_PIXELS = (1920*(1+PIXEL_REPEAT_HDMI));
		ACTIVE_LINES = (1080/(1+INTERLACE_MODE));
		LINES_F0 = 562;
		LINES_F1 = 563;
		FRONT_PORCH = 88;
		HSYNC_PIXELS = 44;
		BACK_PORCH = 148;
		VSYNC_LINES = 5;
		SOF_LINES = 15;
	} else if ((vic == HDMI_1920x1080i50_16x9) ||
		(vic == HDMI_1920x1080i100_16x9)) {
		INTERLACE_MODE = 1;
		PIXEL_REPEAT_VENC = 1;
		PIXEL_REPEAT_HDMI = 0;
		ACTIVE_PIXELS = (1920*(1+PIXEL_REPEAT_HDMI));
		ACTIVE_LINES = (1080/(1+INTERLACE_MODE));
		LINES_F0 = 562;
		LINES_F1 = 563;
		FRONT_PORCH = 528;
		HSYNC_PIXELS = 44;
		BACK_PORCH = 148;
		VSYNC_LINES = 5;
		SOF_LINES = 15;
	}
	TOTAL_PIXELS = (FRONT_PORCH+HSYNC_PIXELS+BACK_PORCH+ACTIVE_PIXELS);
	TOTAL_LINES = (LINES_F0+(LINES_F1*INTERLACE_MODE));

	total_pixels_venc = (TOTAL_PIXELS / (1+PIXEL_REPEAT_HDMI)) *
		(1+PIXEL_REPEAT_VENC);
	active_pixels_venc = (ACTIVE_PIXELS / (1+PIXEL_REPEAT_HDMI)) *
		(1+PIXEL_REPEAT_VENC);
	front_porch_venc = (FRONT_PORCH / (1+PIXEL_REPEAT_HDMI)) *
		(1+PIXEL_REPEAT_VENC);
	hsync_pixels_venc =
		(HSYNC_PIXELS / (1+PIXEL_REPEAT_HDMI)) * (1+PIXEL_REPEAT_VENC);

	hd_write_reg(P_ENCP_VIDEO_MODE, hd_read_reg(P_ENCP_VIDEO_MODE)|(1<<14));

	/* Program DE timing */
	de_h_begin = modulo(hd_read_reg(P_ENCP_VIDEO_HAVON_BEGIN) +
		VFIFO2VD_TO_HDMI_LATENCY, total_pixels_venc);
	de_h_end  = modulo(de_h_begin + active_pixels_venc, total_pixels_venc);
	hd_write_reg(P_ENCP_DE_H_BEGIN, de_h_begin);
	hd_write_reg(P_ENCP_DE_H_END, de_h_end);
	/* Program DE timing for even field */
	de_v_begin_even = hd_read_reg(P_ENCP_VIDEO_VAVON_BLINE);
	de_v_end_even  = de_v_begin_even + ACTIVE_LINES;
	hd_write_reg(P_ENCP_DE_V_BEGIN_EVEN, de_v_begin_even);
	hd_write_reg(P_ENCP_DE_V_END_EVEN,  de_v_end_even);
	/* Program DE timing for odd field if needed */
	if (INTERLACE_MODE) {
		de_v_begin_odd = to_signed((
			hd_read_reg(P_ENCP_VIDEO_OFLD_VOAV_OFST) & 0xf0)>>4)
			+ de_v_begin_even + (TOTAL_LINES-1)/2;
		de_v_end_odd = de_v_begin_odd + ACTIVE_LINES;
		hd_write_reg(P_ENCP_DE_V_BEGIN_ODD, de_v_begin_odd);/* 583 */
		hd_write_reg(P_ENCP_DE_V_END_ODD, de_v_end_odd);  /* 1123 */
	}

	/* Program Hsync timing */
	if (de_h_end + front_porch_venc >= total_pixels_venc) {
		hs_begin = de_h_end + front_porch_venc - total_pixels_venc;
		vs_adjust  = 1;
	} else {
		hs_begin = de_h_end + front_porch_venc;
		vs_adjust  = 0;
	}
	hs_end = modulo(hs_begin + hsync_pixels_venc, total_pixels_venc);
	hd_write_reg(P_ENCP_DVI_HSO_BEGIN,  hs_begin);
	hd_write_reg(P_ENCP_DVI_HSO_END, hs_end);

	/* Program Vsync timing for even field */
	if (de_v_begin_even >= SOF_LINES + VSYNC_LINES + (1-vs_adjust))
		vs_bline_evn = de_v_begin_even - SOF_LINES - VSYNC_LINES
			- (1-vs_adjust);
	else
		vs_bline_evn = TOTAL_LINES + de_v_begin_even - SOF_LINES
			- VSYNC_LINES - (1-vs_adjust);

	vs_eline_evn = modulo(vs_bline_evn + VSYNC_LINES, TOTAL_LINES);
	hd_write_reg(P_ENCP_DVI_VSO_BLINE_EVN, vs_bline_evn);   /* 0 */
	hd_write_reg(P_ENCP_DVI_VSO_ELINE_EVN, vs_eline_evn);   /* 5 */
	vso_begin_evn = hs_begin; /* 2 */
	hd_write_reg(P_ENCP_DVI_VSO_BEGIN_EVN, vso_begin_evn);  /* 2 */
	hd_write_reg(P_ENCP_DVI_VSO_END_EVN, vso_begin_evn);  /* 2 */
	/* Program Vsync timing for odd field if needed */
	if (INTERLACE_MODE) {
		vs_bline_odd = de_v_begin_odd-1 - SOF_LINES - VSYNC_LINES;
		vs_eline_odd = de_v_begin_odd-1 - SOF_LINES;
		vso_begin_odd  = modulo(hs_begin + (total_pixels_venc>>1),
			total_pixels_venc);
		hd_write_reg(P_ENCP_DVI_VSO_BLINE_ODD, vs_bline_odd);
		hd_write_reg(P_ENCP_DVI_VSO_ELINE_ODD, vs_eline_odd);
		hd_write_reg(P_ENCP_DVI_VSO_BEGIN_ODD, vso_begin_odd);
		hd_write_reg(P_ENCP_DVI_VSO_END_ODD, vso_begin_odd);
	}

	hd_write_reg(P_VPU_HDMI_SETTING, (0 << 0) |
		(0 << 1) |
		(HSYNC_POLARITY << 2) |
		(VSYNC_POLARITY << 3) |
		(0 << 4) |
		(4 << 5) |
		(0 << 8) |
		(0 << 12)
	);
	hd_set_reg_bits(P_VPU_HDMI_SETTING, 1, 1, 1);

}

static void hdmi_tvenc4k2k_set(enum hdmi_vic vic)
{
	unsigned long VFIFO2VD_TO_HDMI_LATENCY = 2;
	unsigned long TOTAL_PIXELS = 4400, PIXEL_REPEAT_HDMI = 0,
		PIXEL_REPEAT_VENC = 0, ACTIVE_PIXELS = 3840;
	unsigned FRONT_PORCH = 1020, HSYNC_PIXELS = 0, ACTIVE_LINES = 2160,
		INTERLACE_MODE = 0, TOTAL_LINES = 0, SOF_LINES = 0,
		VSYNC_LINES = 0;
	unsigned LINES_F0 = 2250, LINES_F1 = 2250, BACK_PORCH = 0;

	unsigned long total_pixels_venc = 0;
	unsigned long active_pixels_venc = 0;
	unsigned long front_porch_venc = 0;
	unsigned long hsync_pixels_venc = 0;

	unsigned long de_h_begin = 0, de_h_end = 0;
	unsigned long de_v_begin_even = 0, de_v_end_even = 0,
		de_v_begin_odd = 0, de_v_end_odd = 0;
	unsigned long hs_begin = 0, hs_end = 0;
	unsigned long vs_adjust = 0;
	unsigned long vs_bline_evn = 0, vs_eline_evn = 0, vs_bline_odd = 0,
		vs_eline_odd = 0;
	unsigned long vso_begin_evn = 0, vso_begin_odd = 0;

	switch (vic) {
	case HDMI_3840x2160p30_16x9:
	case HDMI_3840x2160p60_16x9:
	case HDMI_3840x2160p60_16x9_Y420:
		INTERLACE_MODE = 0;
		PIXEL_REPEAT_VENC = 0;
		PIXEL_REPEAT_HDMI = 0;
		ACTIVE_PIXELS = (3840*(1+PIXEL_REPEAT_HDMI));
		ACTIVE_LINES = (2160/(1+INTERLACE_MODE));
		LINES_F0 = 2250;
		LINES_F1 = 2250;
		FRONT_PORCH = 176;
		HSYNC_PIXELS = 88;
		BACK_PORCH = 296;
		VSYNC_LINES = 10;
		SOF_LINES = 72 + 1;
		break;
	case HDMI_3840x2160p25_16x9:
	case HDMI_3840x2160p50_16x9:
	case HDMI_3840x2160p50_16x9_Y420:
		INTERLACE_MODE = 0;
		PIXEL_REPEAT_VENC = 0;
		PIXEL_REPEAT_HDMI = 0;
		ACTIVE_PIXELS = (3840*(1+PIXEL_REPEAT_HDMI));
		ACTIVE_LINES = (2160/(1+INTERLACE_MODE));
		LINES_F0 = 2250;
		LINES_F1 = 2250;
		FRONT_PORCH = 1056;
		HSYNC_PIXELS = 88;
		BACK_PORCH = 296;
		VSYNC_LINES = 10;
		SOF_LINES = 72 + 1;
		break;
	case HDMI_3840x2160p24_16x9:
		INTERLACE_MODE = 0;
		PIXEL_REPEAT_VENC = 0;
		PIXEL_REPEAT_HDMI = 0;
		ACTIVE_PIXELS = (3840*(1+PIXEL_REPEAT_HDMI));
		ACTIVE_LINES = (2160/(1+INTERLACE_MODE));
		LINES_F0 = 2250;
		LINES_F1 = 2250;
		FRONT_PORCH = 1276;
		HSYNC_PIXELS = 88;
		BACK_PORCH = 296;
		VSYNC_LINES = 10;
		SOF_LINES = 72 + 1;
		break;
	case HDMI_4096x2160p24_256x135:
		INTERLACE_MODE = 0;
		PIXEL_REPEAT_VENC = 0;
		PIXEL_REPEAT_HDMI = 0;
		ACTIVE_PIXELS = (4096*(1+PIXEL_REPEAT_HDMI));
		ACTIVE_LINES = (2160/(1+INTERLACE_MODE));
		LINES_F0 = 2250;
		LINES_F1 = 2250;
		FRONT_PORCH = 1020;
		HSYNC_PIXELS = 88;
		BACK_PORCH = 296;
		VSYNC_LINES = 10;
		SOF_LINES = 72 + 1;
		break;
	case HDMI_4096x2160p25_256x135:
	case HDMI_4096x2160p50_256x135:
	case HDMI_4096x2160p50_256x135_Y420:
		INTERLACE_MODE = 0;
		PIXEL_REPEAT_VENC = 0;
		PIXEL_REPEAT_HDMI = 0;
		ACTIVE_PIXELS = (4096*(1+PIXEL_REPEAT_HDMI));
		ACTIVE_LINES = (2160/(1+INTERLACE_MODE));
		LINES_F0 = 2250;
		LINES_F1 = 2250;
		FRONT_PORCH = 968;
		HSYNC_PIXELS = 88;
		BACK_PORCH = 128;
		VSYNC_LINES = 10;
		SOF_LINES = 72;
		break;
	case HDMI_4096x2160p30_256x135:
	case HDMI_4096x2160p60_256x135:
	case HDMI_4096x2160p60_256x135_Y420:
		INTERLACE_MODE = 0;
		PIXEL_REPEAT_VENC = 0;
		PIXEL_REPEAT_HDMI = 0;
		ACTIVE_PIXELS = (4096*(1+PIXEL_REPEAT_HDMI));
		ACTIVE_LINES = (2160/(1+INTERLACE_MODE));
		LINES_F0 = 2250;
		LINES_F1 = 2250;
		FRONT_PORCH = 88;
		HSYNC_PIXELS = 88;
		BACK_PORCH = 128;
		VSYNC_LINES = 10;
		SOF_LINES = 72;
		break;
	default:
		printk("hdmitx20: no setting for VIC = %d\n", vic);
		break;
	}

	TOTAL_PIXELS = (FRONT_PORCH+HSYNC_PIXELS+BACK_PORCH+ACTIVE_PIXELS);
	TOTAL_LINES = (LINES_F0+(LINES_F1*INTERLACE_MODE));

	total_pixels_venc = (TOTAL_PIXELS  / (1+PIXEL_REPEAT_HDMI)) *
		(1+PIXEL_REPEAT_VENC);
	active_pixels_venc = (ACTIVE_PIXELS / (1+PIXEL_REPEAT_HDMI)) *
		(1+PIXEL_REPEAT_VENC);
	front_porch_venc = (FRONT_PORCH   / (1+PIXEL_REPEAT_HDMI)) *
		(1+PIXEL_REPEAT_VENC);
	hsync_pixels_venc = (HSYNC_PIXELS  / (1+PIXEL_REPEAT_HDMI)) *
		(1+PIXEL_REPEAT_VENC);

	de_h_begin = modulo(hd_read_reg(P_ENCP_VIDEO_HAVON_BEGIN) +
		VFIFO2VD_TO_HDMI_LATENCY, total_pixels_venc);
	de_h_end  = modulo(de_h_begin + active_pixels_venc, total_pixels_venc);
	hd_write_reg(P_ENCP_DE_H_BEGIN, de_h_begin);
	hd_write_reg(P_ENCP_DE_H_END, de_h_end);
	/* Program DE timing for even field */
	de_v_begin_even = hd_read_reg(P_ENCP_VIDEO_VAVON_BLINE);
	de_v_end_even  = modulo(de_v_begin_even + ACTIVE_LINES, TOTAL_LINES);
	hd_write_reg(P_ENCP_DE_V_BEGIN_EVEN, de_v_begin_even);
	hd_write_reg(P_ENCP_DE_V_END_EVEN,  de_v_end_even);
	/* Program DE timing for odd field if needed */
	if (INTERLACE_MODE) {
		de_v_begin_odd = to_signed(
			(hd_read_reg(P_ENCP_VIDEO_OFLD_VOAV_OFST) & 0xf0)>>4)
			+ de_v_begin_even + (TOTAL_LINES-1)/2;
		de_v_end_odd = modulo(de_v_begin_odd + ACTIVE_LINES,
			TOTAL_LINES);
		hd_write_reg(P_ENCP_DE_V_BEGIN_ODD, de_v_begin_odd);
		hd_write_reg(P_ENCP_DE_V_END_ODD, de_v_end_odd);
	}

	/* Program Hsync timing */
	if (de_h_end + front_porch_venc >= total_pixels_venc) {
		hs_begin = de_h_end + front_porch_venc - total_pixels_venc;
		vs_adjust  = 1;
	} else {
		hs_begin = de_h_end + front_porch_venc;
		vs_adjust  = 1;
	}
	hs_end = modulo(hs_begin + hsync_pixels_venc, total_pixels_venc);
	hd_write_reg(P_ENCP_DVI_HSO_BEGIN,  hs_begin);
	hd_write_reg(P_ENCP_DVI_HSO_END, hs_end);

	/* Program Vsync timing for even field */
	if (de_v_begin_even >= SOF_LINES + VSYNC_LINES + (1-vs_adjust))
		vs_bline_evn = de_v_begin_even - SOF_LINES - VSYNC_LINES
			- (1-vs_adjust);
	else
		vs_bline_evn = TOTAL_LINES + de_v_begin_even - SOF_LINES
			- VSYNC_LINES - (1-vs_adjust);
	vs_eline_evn = modulo(vs_bline_evn + VSYNC_LINES, TOTAL_LINES);
	hd_write_reg(P_ENCP_DVI_VSO_BLINE_EVN, vs_bline_evn);
	hd_write_reg(P_ENCP_DVI_VSO_ELINE_EVN, vs_eline_evn);
	vso_begin_evn = hs_begin;
	hd_write_reg(P_ENCP_DVI_VSO_BEGIN_EVN, vso_begin_evn);
	hd_write_reg(P_ENCP_DVI_VSO_END_EVN, vso_begin_evn);
	/* Program Vsync timing for odd field if needed */
	if (INTERLACE_MODE) {
		vs_bline_odd = de_v_begin_odd-1 - SOF_LINES - VSYNC_LINES;
		vs_eline_odd = de_v_begin_odd-1 - SOF_LINES;
		vso_begin_odd  = modulo(hs_begin + (total_pixels_venc>>1),
			total_pixels_venc);
		hd_write_reg(P_ENCP_DVI_VSO_BLINE_ODD, vs_bline_odd);
		hd_write_reg(P_ENCP_DVI_VSO_ELINE_ODD, vs_eline_odd);
		hd_write_reg(P_ENCP_DVI_VSO_BEGIN_ODD, vso_begin_odd);
		hd_write_reg(P_ENCP_DVI_VSO_END_ODD, vso_begin_odd);
	}
	hd_write_reg(P_VPU_HDMI_SETTING, (0 << 0) |
			(0 << 1) |
			(HSYNC_POLARITY << 2) |
			(VSYNC_POLARITY << 3) |
			(0 << 4) |
			(4 << 5) |
			(0 << 8) |
			(0 << 12)
	);
	hd_set_reg_bits(P_VPU_HDMI_SETTING, 1, 1, 1);
	hd_write_reg(P_ENCP_VIDEO_EN, 1);
}

static void hdmi_tvenc480i_set(enum hdmi_vic vic)
{
	unsigned long VFIFO2VD_TO_HDMI_LATENCY = 1;
	unsigned long TOTAL_PIXELS = 0, PIXEL_REPEAT_HDMI = 0,
		PIXEL_REPEAT_VENC = 0, ACTIVE_PIXELS = 0;
	unsigned FRONT_PORCH = 38, HSYNC_PIXELS = 124, ACTIVE_LINES = 0,
		INTERLACE_MODE = 0, VSYNC_LINES = 0;
	unsigned LINES_F0 = 262, LINES_F1 = 263, BACK_PORCH = 114,
		EOF_LINES = 2;

	unsigned long total_pixels_venc = 0;
	unsigned long active_pixels_venc = 0;
	unsigned long front_porch_venc = 0;
	unsigned long hsync_pixels_venc = 0;

	unsigned long de_h_begin = 0, de_h_end = 0;
	unsigned long de_v_begin_even = 0, de_v_end_even = 0,
		de_v_begin_odd = 0, de_v_end_odd = 0;
	unsigned long hs_begin = 0, hs_end = 0;
	unsigned long vs_adjust = 0;
	unsigned long vs_bline_evn = 0, vs_eline_evn = 0,
		vs_bline_odd = 0, vs_eline_odd = 0;
	unsigned long vso_begin_evn = 0, vso_begin_odd = 0;

	hd_set_reg_bits(P_HHI_GCLK_OTHER, 1, 8, 1);
	switch (vic) {
	case HDMI_720x480i60_16x9:
		INTERLACE_MODE = 1;
		PIXEL_REPEAT_VENC = 1;
		PIXEL_REPEAT_HDMI = 1;
		ACTIVE_PIXELS	= (720*(1+PIXEL_REPEAT_HDMI));
		ACTIVE_LINES = (480/(1+INTERLACE_MODE));
		LINES_F0 = 262;
		LINES_F1 = 263;
		FRONT_PORCH = 38;
		HSYNC_PIXELS = 124;
		BACK_PORCH = 114;
		EOF_LINES = 4;
		VSYNC_LINES = 3;
                break;
	case HDMI_720x576i50_16x9:
		INTERLACE_MODE = 1;
		PIXEL_REPEAT_VENC = 1;
		PIXEL_REPEAT_HDMI = 1;
		ACTIVE_PIXELS	= (720*(1+PIXEL_REPEAT_HDMI));
		ACTIVE_LINES = (576/(1+INTERLACE_MODE));
		LINES_F0 = 312;
		LINES_F1 = 313;
		FRONT_PORCH = 24;
		HSYNC_PIXELS = 126;
		BACK_PORCH = 138;
		EOF_LINES = 2;
		VSYNC_LINES = 3;
		break;
	default:
		break;
	}

	TOTAL_PIXELS = (FRONT_PORCH+HSYNC_PIXELS+BACK_PORCH+ACTIVE_PIXELS);

	total_pixels_venc = (TOTAL_PIXELS  / (1+PIXEL_REPEAT_HDMI)) *
		(1+PIXEL_REPEAT_VENC); /* 1716 / 2 * 2 = 1716 */
	active_pixels_venc = (ACTIVE_PIXELS / (1+PIXEL_REPEAT_HDMI)) *
		(1+PIXEL_REPEAT_VENC);
	front_porch_venc = (FRONT_PORCH   / (1+PIXEL_REPEAT_HDMI)) *
		(1+PIXEL_REPEAT_VENC); /* 38   / 2 * 2 = 38 */
	hsync_pixels_venc = (HSYNC_PIXELS  / (1+PIXEL_REPEAT_HDMI)) *
		(1+PIXEL_REPEAT_VENC); /* 124  / 2 * 2 = 124 */

	de_h_begin = modulo(hd_read_reg(P_ENCI_VFIFO2VD_PIXEL_START) +
		VFIFO2VD_TO_HDMI_LATENCY, total_pixels_venc);
	de_h_end  = modulo(de_h_begin + active_pixels_venc, total_pixels_venc);
	hd_write_reg(P_ENCI_DE_H_BEGIN, de_h_begin);	/* 235 */
	hd_write_reg(P_ENCI_DE_H_END, de_h_end);	 /* 1675 */

	de_v_begin_even = hd_read_reg(P_ENCI_VFIFO2VD_LINE_TOP_START);
	de_v_end_even  = de_v_begin_even + ACTIVE_LINES;
	de_v_begin_odd = hd_read_reg(P_ENCI_VFIFO2VD_LINE_BOT_START);
	de_v_end_odd = de_v_begin_odd + ACTIVE_LINES;
	hd_write_reg(P_ENCI_DE_V_BEGIN_EVEN, de_v_begin_even);
	hd_write_reg(P_ENCI_DE_V_END_EVEN,  de_v_end_even);
	hd_write_reg(P_ENCI_DE_V_BEGIN_ODD, de_v_begin_odd);
	hd_write_reg(P_ENCI_DE_V_END_ODD, de_v_end_odd);

	/* Program Hsync timing */
	if (de_h_end + front_porch_venc >= total_pixels_venc) {
		hs_begin = de_h_end + front_porch_venc - total_pixels_venc;
		vs_adjust  = 1;
	} else {
		hs_begin = de_h_end + front_porch_venc;
		vs_adjust  = 0;
	}
	hs_end = modulo(hs_begin + hsync_pixels_venc, total_pixels_venc);
	hd_write_reg(P_ENCI_DVI_HSO_BEGIN,  hs_begin);  /* 1713 */
	hd_write_reg(P_ENCI_DVI_HSO_END, hs_end);	/* 121 */

	/* Program Vsync timing for even field */
	if (de_v_end_odd-1 + EOF_LINES + vs_adjust >= LINES_F1) {
		vs_bline_evn = de_v_end_odd-1 + EOF_LINES + vs_adjust
			- LINES_F1;
		vs_eline_evn = vs_bline_evn + VSYNC_LINES;
		hd_write_reg(P_ENCI_DVI_VSO_BLINE_EVN, vs_bline_evn);
		/* vso_bline_evn_reg_wr_cnt ++; */
		hd_write_reg(P_ENCI_DVI_VSO_ELINE_EVN, vs_eline_evn);
		/* vso_eline_evn_reg_wr_cnt ++; */
		hd_write_reg(P_ENCI_DVI_VSO_BEGIN_EVN, hs_begin);
		hd_write_reg(P_ENCI_DVI_VSO_END_EVN, hs_begin);
	} else {
		vs_bline_odd = de_v_end_odd-1 + EOF_LINES + vs_adjust;
		hd_write_reg(P_ENCI_DVI_VSO_BLINE_ODD, vs_bline_odd);
		/* vso_bline_odd_reg_wr_cnt ++; */
		hd_write_reg(P_ENCI_DVI_VSO_BEGIN_ODD, hs_begin);
	if (vs_bline_odd + VSYNC_LINES >= LINES_F1) {
		vs_eline_evn = vs_bline_odd + VSYNC_LINES - LINES_F1;
		hd_write_reg(P_ENCI_DVI_VSO_ELINE_EVN, vs_eline_evn);
		/* vso_eline_evn_reg_wr_cnt ++; */
		hd_write_reg(P_ENCI_DVI_VSO_END_EVN, hs_begin);
	} else {
		vs_eline_odd = vs_bline_odd + VSYNC_LINES;
		hd_write_reg(P_ENCI_DVI_VSO_ELINE_ODD, vs_eline_odd);
		/* vso_eline_odd_reg_wr_cnt ++; */
		hd_write_reg(P_ENCI_DVI_VSO_END_ODD, hs_begin);
	}
	}
	/* Program Vsync timing for odd field */
	if (de_v_end_even-1 + EOF_LINES + 1 >= LINES_F0) {
		vs_bline_odd = de_v_end_even-1 + EOF_LINES + 1 - LINES_F0;
		vs_eline_odd = vs_bline_odd + VSYNC_LINES;
		hd_write_reg(P_ENCI_DVI_VSO_BLINE_ODD, vs_bline_odd);
		/* vso_bline_odd_reg_wr_cnt ++; */
		hd_write_reg(P_ENCI_DVI_VSO_ELINE_ODD, vs_eline_odd);
		/* vso_eline_odd_reg_wr_cnt ++; */
		vso_begin_odd  = modulo(hs_begin + (total_pixels_venc>>1),
			total_pixels_venc);
		hd_write_reg(P_ENCI_DVI_VSO_BEGIN_ODD, vso_begin_odd);
		hd_write_reg(P_ENCI_DVI_VSO_END_ODD, vso_begin_odd);
	} else {
		vs_bline_evn = de_v_end_even-1 + EOF_LINES + 1;
		hd_write_reg(P_ENCI_DVI_VSO_BLINE_EVN, vs_bline_evn); /* 261 */
		/* vso_bline_evn_reg_wr_cnt ++; */
		vso_begin_evn  = modulo(hs_begin + (total_pixels_venc>>1),
			total_pixels_venc);
		hd_write_reg(P_ENCI_DVI_VSO_BEGIN_EVN, vso_begin_evn);
	if (vs_bline_evn + VSYNC_LINES >= LINES_F0) {
		vs_eline_odd = vs_bline_evn + VSYNC_LINES - LINES_F0;
		hd_write_reg(P_ENCI_DVI_VSO_ELINE_ODD, vs_eline_odd);
		/* vso_eline_odd_reg_wr_cnt ++; */
		hd_write_reg(P_ENCI_DVI_VSO_END_ODD, vso_begin_evn);
	} else {
		vs_eline_evn = vs_bline_evn + VSYNC_LINES;
		hd_write_reg(P_ENCI_DVI_VSO_ELINE_EVN, vs_eline_evn);
		/* vso_eline_evn_reg_wr_cnt ++; */
		hd_write_reg(P_ENCI_DVI_VSO_END_EVN, vso_begin_evn);
	}
	}

	hd_write_reg(P_VPU_HDMI_SETTING, (0 << 0) |
			(0 << 1) |
			(0 << 2) |
			(0 << 3) |
			(0 << 4) |
			(4 << 5) |
			(1 << 8) |
			(1 << 12)
	);
	hd_set_reg_bits(P_VPU_HDMI_SETTING, 1, 0, 1);
}

static void hdmi_tvenc_set_def(enum hdmi_vic vic)
{
        unsigned long VFIFO2VD_TO_HDMI_LATENCY = 2;
	unsigned long TOTAL_PIXELS = 0, PIXEL_REPEAT_HDMI = 0,
		PIXEL_REPEAT_VENC = 0, ACTIVE_PIXELS = 0;
	unsigned FRONT_PORCH = 0, HSYNC_PIXELS = 0, ACTIVE_LINES = 0,
		INTERLACE_MODE = 0, TOTAL_LINES = 0, SOF_LINES = 0,
		VSYNC_LINES = 0;
	unsigned LINES_F0 = 0, LINES_F1 = 0, BACK_PORCH = 0;

	unsigned long total_pixels_venc = 0;
	unsigned long active_pixels_venc = 0;
	unsigned long front_porch_venc = 0;
	unsigned long hsync_pixels_venc = 0;

	unsigned long de_h_begin = 0, de_h_end = 0;
	unsigned long de_v_begin_even = 0, de_v_end_even = 0,
		de_v_begin_odd = 0, de_v_end_odd = 0;
	unsigned long hs_begin = 0, hs_end = 0;
	unsigned long vs_adjust = 0;
	unsigned long vs_bline_evn = 0, vs_eline_evn = 0,
		vs_bline_odd = 0, vs_eline_odd = 0;
	unsigned long vso_begin_evn = 0, vso_begin_odd = 0;
        hdmitx_debug();
	switch (vic) {
	case HDMI_720x480p60_16x9:
	case HDMI_720x480p120_16x9:
		INTERLACE_MODE = 0;
		PIXEL_REPEAT_VENC = 1;
		PIXEL_REPEAT_HDMI = 0;
		ACTIVE_PIXELS	= (720*(1+PIXEL_REPEAT_HDMI));
		ACTIVE_LINES = (480/(1+INTERLACE_MODE));
		LINES_F0 = 525;
		LINES_F1 = 525;
		FRONT_PORCH = 16;
		HSYNC_PIXELS = 62;
		BACK_PORCH = 60;
		VSYNC_LINES = 6;
		SOF_LINES = 30;
		break;
	case HDMI_720x576p50_16x9:
	case HDMI_720x576p100_16x9:
		INTERLACE_MODE = 0;
		PIXEL_REPEAT_VENC = 1;
		PIXEL_REPEAT_HDMI = 0;
		ACTIVE_PIXELS	= (720*(1+PIXEL_REPEAT_HDMI));
		ACTIVE_LINES = (576/(1+INTERLACE_MODE));
		LINES_F0 = 625;
		LINES_F1 = 625;
		FRONT_PORCH = 12;
		HSYNC_PIXELS = 64;
		BACK_PORCH = 68;
		VSYNC_LINES = 5;
		SOF_LINES = 39;
		break;
	case HDMI_1280x720p60_16x9:
	case HDMI_1280x720p120_16x9:
		INTERLACE_MODE = 0;
		PIXEL_REPEAT_VENC = 1;
		PIXEL_REPEAT_HDMI = 0;
		ACTIVE_PIXELS	= (1280*(1+PIXEL_REPEAT_HDMI));
		ACTIVE_LINES = (720/(1+INTERLACE_MODE));
		LINES_F0 = 750;
		LINES_F1 = 750;
		FRONT_PORCH = 110;
		HSYNC_PIXELS = 40;
		BACK_PORCH = 220;
		VSYNC_LINES = 5;
		SOF_LINES = 20;
		break;
	case HDMI_1280x720p50_16x9:
	case HDMI_1280x720p100_16x9:
		INTERLACE_MODE = 0;
		PIXEL_REPEAT_VENC = 1;
		PIXEL_REPEAT_HDMI = 0;
		ACTIVE_PIXELS	= (1280*(1+PIXEL_REPEAT_HDMI));
		ACTIVE_LINES = (720/(1+INTERLACE_MODE));
		LINES_F0 = 750;
		LINES_F1 = 750;
		FRONT_PORCH = 440;
		HSYNC_PIXELS = 40;
		BACK_PORCH = 220;
		VSYNC_LINES = 5;
		SOF_LINES = 20;
		break;
	case HDMI_1920x1080p50_16x9:
	case HDMI_1920x1080p25_16x9:
	case HDMI_1920x1080p100_16x9:
		INTERLACE_MODE	= 0;
		PIXEL_REPEAT_VENC  = 0;
		PIXEL_REPEAT_HDMI  = 0;
		ACTIVE_PIXELS = (1920*(1+PIXEL_REPEAT_HDMI));
		ACTIVE_LINES = (1080/(1+INTERLACE_MODE));
		LINES_F0 = 1125;
		LINES_F1 = 1125;
		FRONT_PORCH = 528;
		HSYNC_PIXELS = 44;
		BACK_PORCH = 148;
		VSYNC_LINES = 5;
		SOF_LINES = 36;
		break;
	case HDMI_1920x1080p24_16x9:
		INTERLACE_MODE	= 0;
		PIXEL_REPEAT_VENC  = 0;
		PIXEL_REPEAT_HDMI  = 0;
		ACTIVE_PIXELS = (1920*(1+PIXEL_REPEAT_HDMI));
		ACTIVE_LINES = (1080/(1+INTERLACE_MODE));
		LINES_F0 = 1125;
		LINES_F1 = 1125;
		FRONT_PORCH = 638;
		HSYNC_PIXELS = 44;
		BACK_PORCH = 148;
		VSYNC_LINES = 5;
		SOF_LINES = 36;
		break;
	case HDMI_1920x1080p60_16x9:
	case HDMI_1920x1080p30_16x9:
	case HDMI_1920x1080p120_16x9:
		INTERLACE_MODE	= 0;
		PIXEL_REPEAT_VENC  = 0;
		PIXEL_REPEAT_HDMI  = 0;
		ACTIVE_PIXELS = (1920*(1+PIXEL_REPEAT_HDMI));
		ACTIVE_LINES = (1080/(1+INTERLACE_MODE));
		LINES_F0 = 1125;
		LINES_F1 = 1125;
		FRONT_PORCH = 88;
		HSYNC_PIXELS = 44;
		BACK_PORCH = 148;
		VSYNC_LINES = 5;
		SOF_LINES = 36;
		break;
	default:
		break;
	}

	TOTAL_PIXELS = (FRONT_PORCH+HSYNC_PIXELS+BACK_PORCH+ACTIVE_PIXELS);
	TOTAL_LINES = (LINES_F0+(LINES_F1*INTERLACE_MODE));

	total_pixels_venc = (TOTAL_PIXELS  / (1+PIXEL_REPEAT_HDMI)) *
		(1+PIXEL_REPEAT_VENC);
	active_pixels_venc = (ACTIVE_PIXELS / (1+PIXEL_REPEAT_HDMI)) *
		(1+PIXEL_REPEAT_VENC);
	front_porch_venc = (FRONT_PORCH   / (1+PIXEL_REPEAT_HDMI)) *
		(1+PIXEL_REPEAT_VENC);
	hsync_pixels_venc = (HSYNC_PIXELS  / (1+PIXEL_REPEAT_HDMI)) *
		(1+PIXEL_REPEAT_VENC);

	hd_write_reg(P_ENCP_VIDEO_MODE, hd_read_reg(P_ENCP_VIDEO_MODE)|(1<<14));
	/* Program DE timing */
	de_h_begin = modulo(hd_read_reg(P_ENCP_VIDEO_HAVON_BEGIN) +
		VFIFO2VD_TO_HDMI_LATENCY,  total_pixels_venc);
	de_h_end  = modulo(de_h_begin + active_pixels_venc, total_pixels_venc);
	hd_write_reg(P_ENCP_DE_H_BEGIN, de_h_begin);	/* 220 */
	hd_write_reg(P_ENCP_DE_H_END, de_h_end);	 /* 1660 */
	/* Program DE timing for even field */
	de_v_begin_even = hd_read_reg(P_ENCP_VIDEO_VAVON_BLINE);
	de_v_end_even  = de_v_begin_even + ACTIVE_LINES;
	hd_write_reg(P_ENCP_DE_V_BEGIN_EVEN, de_v_begin_even);
	hd_write_reg(P_ENCP_DE_V_END_EVEN,  de_v_end_even);	/* 522 */
	/* Program DE timing for odd field if needed */
	if (INTERLACE_MODE) {
		de_v_begin_odd = to_signed(
			(hd_read_reg(P_ENCP_VIDEO_OFLD_VOAV_OFST)
			& 0xf0)>>4) + de_v_begin_even + (TOTAL_LINES-1)/2;
		de_v_end_odd = de_v_begin_odd + ACTIVE_LINES;
		hd_write_reg(P_ENCP_DE_V_BEGIN_ODD, de_v_begin_odd);
		hd_write_reg(P_ENCP_DE_V_END_ODD, de_v_end_odd);
	}

	/* Program Hsync timing */
	if (de_h_end + front_porch_venc >= total_pixels_venc) {
		hs_begin = de_h_end + front_porch_venc - total_pixels_venc;
		vs_adjust  = 1;
	} else {
		hs_begin = de_h_end + front_porch_venc;
		vs_adjust  = 0;
	}
	hs_end = modulo(hs_begin + hsync_pixels_venc, total_pixels_venc);
	hd_write_reg(P_ENCP_DVI_HSO_BEGIN,  hs_begin);
	hd_write_reg(P_ENCP_DVI_HSO_END, hs_end);

	/* Program Vsync timing for even field */
	if (de_v_begin_even >= SOF_LINES + VSYNC_LINES + (1-vs_adjust))
		vs_bline_evn = de_v_begin_even - SOF_LINES - VSYNC_LINES -
			(1-vs_adjust);
	else
		vs_bline_evn = TOTAL_LINES + de_v_begin_even - SOF_LINES -
			VSYNC_LINES - (1-vs_adjust);
	vs_eline_evn = modulo(vs_bline_evn + VSYNC_LINES, TOTAL_LINES);
	hd_write_reg(P_ENCP_DVI_VSO_BLINE_EVN, vs_bline_evn);   /* 5 */
	hd_write_reg(P_ENCP_DVI_VSO_ELINE_EVN, vs_eline_evn);   /* 11 */
	vso_begin_evn = hs_begin; /* 1692 */
	hd_write_reg(P_ENCP_DVI_VSO_BEGIN_EVN, vso_begin_evn);  /* 1692 */
	hd_write_reg(P_ENCP_DVI_VSO_END_EVN, vso_begin_evn);  /* 1692 */
	/* Program Vsync timing for odd field if needed */
	if (INTERLACE_MODE) {
		vs_bline_odd = de_v_begin_odd-1 - SOF_LINES - VSYNC_LINES;
		vs_eline_odd = de_v_begin_odd-1 - SOF_LINES;
		vso_begin_odd  = modulo(hs_begin + (total_pixels_venc>>1),
			total_pixels_venc);
		hd_write_reg(P_ENCP_DVI_VSO_BLINE_ODD, vs_bline_odd);
		hd_write_reg(P_ENCP_DVI_VSO_ELINE_ODD, vs_eline_odd);
		hd_write_reg(P_ENCP_DVI_VSO_BEGIN_ODD, vso_begin_odd);
		hd_write_reg(P_ENCP_DVI_VSO_END_ODD, vso_begin_odd);
	}
	switch (vic) {
	case HDMI_720x480i60_16x9:
	case HDMI_720x576i50_16x9:
		hd_write_reg(P_VPU_HDMI_SETTING, (0 << 0) |
				(0 << 1) |
				(0 << 2) |
				(0 << 3) |
				(0 << 4) |
				(4 << 5) |
				(1 << 8) |
				(1 << 12)
		);
		hd_set_reg_bits(P_VPU_HDMI_SETTING, 1, 0, 1);
		break;
	case HDMI_1920x1080i60_16x9:
	case HDMI_1920x1080i50_16x9:
		hd_write_reg(P_VPU_HDMI_SETTING, (0 << 0) |
				(0 << 1) |
				(HSYNC_POLARITY << 2) |
				(VSYNC_POLARITY << 3) |
				(0 << 4) |
				(((TX_INPUT_COLOR_FORMAT == 0) ? 1 : 0) << 5) |
				(1 << 8) |
				(0 << 12)
		);
		hd_set_reg_bits(P_VPU_HDMI_SETTING, 1, 1, 1);
		break;
	case HDMI_3840x2160p30_16x9:
	case HDMI_3840x2160p25_16x9:
	case HDMI_3840x2160p24_16x9:
	case HDMI_4096x2160p24_256x135:
	case HDMI_4096x2160p25_256x135:
	case HDMI_4096x2160p30_256x135:
	case HDMI_4096x2160p50_256x135:
	case HDMI_4096x2160p60_256x135:
	case HDMI_3840x2160p50_16x9:
	case HDMI_3840x2160p60_16x9:
		hd_write_reg(P_VPU_HDMI_SETTING, (0 << 0) |
			(0 << 1) |
			(HSYNC_POLARITY << 2) |
			(VSYNC_POLARITY << 3) |
			(0 << 4) |
			(4 << 5) |
			(0 << 8) |
			(0 << 12)
		);
		hd_set_reg_bits(P_VPU_HDMI_SETTING, 1, 1, 1);
		hd_write_reg(P_ENCP_VIDEO_EN, 1); /* Enable VENC */
		break;
	case HDMI_720x480p60_16x9:
	case HDMI_720x576p50_16x9:
	case HDMI_720x480p120_16x9:
	case HDMI_720x576p100_16x9:
		hd_write_reg(P_VPU_HDMI_SETTING, (0 << 0) |
				(0 << 1) |
				(0 << 2) |
				(0 << 3) |
				(0 << 4) |
				(4 << 5) |
				(1 << 8) |
				(0 << 12)
		);
		hd_set_reg_bits(P_VPU_HDMI_SETTING, 1, 1, 1);
		break;
	case HDMI_1280x720p60_16x9:
	case HDMI_1280x720p50_16x9:
	case HDMI_1280x720p100_16x9:
	case HDMI_1280x720p120_16x9:
		hd_write_reg(P_VPU_HDMI_SETTING, (0 << 0) |
				(0 << 1) |
				(HSYNC_POLARITY << 2) |
				(VSYNC_POLARITY << 3) |
				(0 << 4) |
				(4 << 5) |
				(1 << 8) |
				(0 << 12)
		);
		hd_set_reg_bits(P_VPU_HDMI_SETTING, 1, 1, 1);
		break;
	default:
		hd_write_reg(P_VPU_HDMI_SETTING, (0 << 0) |
				(0 << 1) | /* [	1] src_sel_encp */
				(HSYNC_POLARITY << 2) |
				(VSYNC_POLARITY << 3) |
				(0 << 4) |
				(4 << 5) |
				(0 << 8) |
				(0 << 12)
		);
		hd_set_reg_bits(P_VPU_HDMI_SETTING, 1, 1, 1);
	}
	hd_set_reg_bits(P_VPU_HDMI_SETTING, 1, 1, 1);
}

static void hdmi_tvenc_set(enum hdmi_vic vic)
{
	switch (vic) {
	case HDMI_720x480i60_16x9:
	case HDMI_720x576i50_16x9:
		hdmi_tvenc480i_set(vic);
		break;
	case HDMI_1920x1080i60_16x9:
	case HDMI_1920x1080i50_16x9:
	case HDMI_1920x1080i100_16x9:
	case HDMI_1920x1080i120_16x9:
		hdmi_tvenc1080i_set(vic);
		break;
	case HDMI_3840x2160p30_16x9:
	case HDMI_3840x2160p25_16x9:
	case HDMI_3840x2160p24_16x9:
	case HDMI_4096x2160p24_256x135:
	case HDMI_4096x2160p25_256x135:
	case HDMI_4096x2160p30_256x135:
	case HDMI_4096x2160p50_256x135:
	case HDMI_4096x2160p60_256x135:
	case HDMI_3840x2160p50_16x9:
	case HDMI_3840x2160p60_16x9:
	case HDMI_4096x2160p50_256x135_Y420:
	case HDMI_4096x2160p60_256x135_Y420:
	case HDMI_3840x2160p50_16x9_Y420:
	case HDMI_3840x2160p60_16x9_Y420:
		hdmi_tvenc4k2k_set(vic);
		break;
	default:
		hdmi_tvenc_set_def(vic);
                break;
	}

	switch (vic) {
	case HDMI_720x480i60_16x9:
	case HDMI_720x576i50_16x9:
		// Annie 01Sep2011: Register VENC_DVI_SETTING and VENC_DVI_SETTING_MORE are no long valid, use VPU_HDMI_SETTING instead.
		hd_write_reg(P_VPU_HDMI_SETTING, (0                                 << 0) | // [    0] src_sel_enci
                             (0                                 << 1) | // [    1] src_sel_encp
                             (0                                 << 2) | // [    2] inv_hsync. 1=Invert Hsync polarity.
                             (0                                 << 3) | // [    3] inv_vsync. 1=Invert Vsync polarity.
                             (0                                 << 4) | // [    4] inv_dvi_clk. 1=Invert clock to external DVI, (clock invertion exists at internal HDMI).
                             (4                                 << 5) | // [ 7: 5] data_comp_map. Input data is CrYCb(BRG), map the output data to desired format:
                                                                        //                          0=output CrYCb(BRG);
                                                                        //                          1=output YCbCr(RGB);
                                                                        //                          2=output YCrCb(RBG);
                                                                        //                          3=output CbCrY(GBR);
                                                                        //                          4=output CbYCr(GRB);
                                                                        //                          5=output CrCbY(BGR);
                                                                        //                          6,7=Rsrv.
                             (1                                 << 8) | // [11: 8] wr_rate. 0=A write every clk1; 1=A write every 2 clk1; ...; 15=A write every 16 clk1.
                             (1                                 <<12)   // [15:12] rd_rate. 0=A read every clk2; 1=A read every 2 clk2; ...; 15=A read every 16 clk2.
		);
		hd_set_reg_bits(P_VPU_HDMI_SETTING, 1, 0, 1);  // [    0] src_sel_enci: Enable ENCI output to HDMI
		break;
	case HDMI_1920x1080i60_16x9:
	case HDMI_1920x1080i50_16x9:
	case HDMI_1920x1080i100_16x9:
	case HDMI_1920x1080i120_16x9:
		// Annie 01Sep2011: Register VENC_DVI_SETTING and VENC_DVI_SETTING_MORE are no long valid, use VPU_HDMI_SETTING instead.
		hd_write_reg(P_VPU_HDMI_SETTING, (0                                 << 0) | // [    0] src_sel_enci
                             (0                                 << 1) | // [    1] src_sel_encp
                             (HSYNC_POLARITY                    << 2) | // [    2] inv_hsync. 1=Invert Hsync polarity.
                             (VSYNC_POLARITY                    << 3) | // [    3] inv_vsync. 1=Invert Vsync polarity.
                             (0                                 << 4) | // [    4] inv_dvi_clk. 1=Invert clock to external DVI, (clock invertion exists at internal HDMI).
                             (4                                 << 5) | // [ 7: 5] data_comp_map. Input data is CrYCb(BRG), map the output data to desired format:
                                                                        //                          0=output CrYCb(BRG);
                                                                        //                          1=output YCbCr(RGB);
                                                                        //                          2=output YCrCb(RBG);
                                                                        //                          3=output CbCrY(GBR);
                                                                        //                          4=output CbYCr(GRB);
                                                                        //                          5=output CrCbY(BGR);
                                                                        //                          6,7=Rsrv.
                             (1                                 << 8) | // [11: 8] wr_rate. 0=A write every clk1; 1=A write every 2 clk1; ...; 15=A write every 16 clk1.
                             (0                                 <<12)   // [15:12] rd_rate. 0=A read every clk2; 1=A read every 2 clk2; ...; 15=A read every 16 clk2.
		);
		hd_set_reg_bits(P_VPU_HDMI_SETTING, 1, 1, 1);  // [    1] src_sel_encp: Enable ENCP output to HDMI
		break;
	case HDMI_3840x2160p30_16x9:
	case HDMI_3840x2160p25_16x9:
	case HDMI_3840x2160p24_16x9:
	case HDMI_4096x2160p24_256x135:
	case HDMI_4096x2160p25_256x135:
	case HDMI_4096x2160p30_256x135:
	case HDMI_4096x2160p50_256x135:
	case HDMI_4096x2160p60_256x135:
	case HDMI_3840x2160p50_16x9:
	case HDMI_3840x2160p60_16x9:
		hd_write_reg(P_VPU_HDMI_SETTING, (0                  << 0) | // [    0] src_sel_enci
                     (0                                 << 1) | // [    1] src_sel_encp
                     (HSYNC_POLARITY                    << 2) | // [    2] inv_hsync. 1=Invert Hsync polarity.
                     (VSYNC_POLARITY                    << 3) | // [    3] inv_vsync. 1=Invert Vsync polarity.
                     (0                                 << 4) | // [    4] inv_dvi_clk. 1=Invert clock to external DVI, (clock invertion exists at internal HDMI).
                     (4                                 << 5) | // [ 7: 5] data_comp_map. Input data is CrYCb(BRG), map the output data to desired format:
                                                                //                          0=output CrYCb(BRG);
                                                                //                          1=output YCbCr(RGB);
                                                                //                          2=output YCrCb(RBG);
                                                                //                          3=output CbCrY(GBR);
                                                                //                          4=output CbYCr(GRB);
                                                                //                          5=output CrCbY(BGR);
                                                                //                          6,7=Rsrv.
                     (0                                 << 8) | // [11: 8] wr_rate. 0=A write every clk1; 1=A write every 2 clk1; ...; 15=A write every 16 clk1.
                     (0                                 <<12)   // [15:12] rd_rate. 0=A read every clk2; 1=A read every 2 clk2; ...; 15=A read every 16 clk2.
		);
		hd_set_reg_bits(P_VPU_HDMI_SETTING, 1, 1, 1);  // [    1] src_sel_encp: Enable ENCP output to HDMI
		hd_write_reg(P_ENCP_VIDEO_EN, 1); // Enable VENC
		break;
	case HDMI_720x480p60_16x9:
	case HDMI_720x576p50_16x9:
	case HDMI_720x480p120_16x9:
	case HDMI_720x576p100_16x9:
		// Annie 01Sep2011: Register VENC_DVI_SETTING and VENC_DVI_SETTING_MORE are no long valid, use VPU_HDMI_SETTING instead.
		hd_write_reg(P_VPU_HDMI_SETTING, (0                                 << 0) | // [    0] src_sel_enci
                             (0                                 << 1) | // [    1] src_sel_encp
                             (0                                 << 2) | // [    2] inv_hsync. 1=Invert Hsync polarity.
                             (0                                 << 3) | // [    3] inv_vsync. 1=Invert Vsync polarity.
                             (0                                 << 4) | // [    4] inv_dvi_clk. 1=Invert clock to external DVI, (clock invertion exists at internal HDMI).
                             (4                                 << 5) | // [ 7: 5] data_comp_map. Input data is CrYCb(BRG), map the output data to desired format:
                                                                        //                          0=output CrYCb(BRG);
                                                                        //                          1=output YCbCr(RGB);
                                                                        //                          2=output YCrCb(RBG);
                                                                        //                          3=output CbCrY(GBR);
                                                                        //                          4=output CbYCr(GRB);
                                                                        //                          5=output CrCbY(BGR);
                                                                        //                          6,7=Rsrv.
                             (1                                 << 8) | // [11: 8] wr_rate. 0=A write every clk1; 1=A write every 2 clk1; ...; 15=A write every 16 clk1.
                             (0                                 <<12)   // [15:12] rd_rate. 0=A read every clk2; 1=A read every 2 clk2; ...; 15=A read every 16 clk2.
		);
		// Annie 01Sep2011: Register VENC_DVI_SETTING and VENC_DVI_SETTING_MORE are no long valid, use VPU_HDMI_SETTING instead.
		hd_set_reg_bits(P_VPU_HDMI_SETTING, 1, 1, 1);  // [    1] src_sel_encp: Enable ENCP output to HDMI
		break;
	case HDMI_1280x720p60_16x9:
	case HDMI_1280x720p50_16x9:
	case HDMI_1280x720p100_16x9:
	case HDMI_1280x720p120_16x9:
		// Annie 01Sep2011: Register VENC_DVI_SETTING and VENC_DVI_SETTING_MORE are no long valid, use VPU_HDMI_SETTING instead.
		hd_write_reg(P_VPU_HDMI_SETTING, (0                                 << 0) | // [    0] src_sel_enci
                             (0                                 << 1) | // [    1] src_sel_encp
                             (HSYNC_POLARITY                    << 2) | // [    2] inv_hsync. 1=Invert Hsync polarity.
                             (VSYNC_POLARITY                    << 3) | // [    3] inv_vsync. 1=Invert Vsync polarity.
                             (0                                 << 4) | // [    4] inv_dvi_clk. 1=Invert clock to external DVI, (clock invertion exists at internal HDMI).
                             (4                                 << 5) | // [ 7: 5] data_comp_map. Input data is CrYCb(BRG), map the output data to desired format:
                                                                        //                          0=output CrYCb(BRG);
                                                                        //                          1=output YCbCr(RGB);
                                                                        //                          2=output YCrCb(RBG);
                                                                        //                          3=output CbCrY(GBR);
                                                                        //                          4=output CbYCr(GRB);
                                                                        //                          5=output CrCbY(BGR);
                                                                        //                          6,7=Rsrv.
                             (1                                 << 8) | // [11: 8] wr_rate. 0=A write every clk1; 1=A write every 2 clk1; ...; 15=A write every 16 clk1.
                             (0                                 <<12)   // [15:12] rd_rate. 0=A read every clk2; 1=A read every 2 clk2; ...; 15=A read every 16 clk2.
		);
		// Annie 01Sep2011: Register VENC_DVI_SETTING and VENC_DVI_SETTING_MORE are no long valid, use VPU_HDMI_SETTING instead.
		hd_set_reg_bits(P_VPU_HDMI_SETTING, 1, 1, 1);  // [    1] src_sel_encp: Enable ENCP output to HDMI
		break;
	default:
		// Annie 01Sep2011: Register VENC_DVI_SETTING and VENC_DVI_SETTING_MORE are no long valid, use VPU_HDMI_SETTING instead.
		hd_write_reg(P_VPU_HDMI_SETTING, (0                                 << 0) | // [    0] src_sel_enci
                             (0                                 << 1) | // [    1] src_sel_encp
                             (HSYNC_POLARITY                    << 2) | // [    2] inv_hsync. 1=Invert Hsync polarity.
                             (VSYNC_POLARITY                    << 3) | // [    3] inv_vsync. 1=Invert Vsync polarity.
                             (0                                 << 4) | // [    4] inv_dvi_clk. 1=Invert clock to external DVI, (clock invertion exists at internal HDMI).
                             (4                                 << 5) | // [ 7: 5] data_comp_map. Input data is CrYCb(BRG), map the output data to desired format:
                                                                        //                          0=output CrYCb(BRG);
                                                                        //                          1=output YCbCr(RGB);
                                                                        //                          2=output YCrCb(RBG);
                                                                        //                          3=output CbCrY(GBR);
                                                                        //                          4=output CbYCr(GRB);
                                                                        //                          5=output CrCbY(BGR);
                                                                        //                          6,7=Rsrv.
                             (0                                 << 8) | // [11: 8] wr_rate. 0=A write every clk1; 1=A write every 2 clk1; ...; 15=A write every 16 clk1.
                             (0                                 <<12)   // [15:12] rd_rate. 0=A read every clk2; 1=A read every 2 clk2; ...; 15=A read every 16 clk2.
		);
		// Annie 01Sep2011: Register VENC_DVI_SETTING and VENC_DVI_SETTING_MORE are no long valid, use VPU_HDMI_SETTING instead.
		hd_set_reg_bits(P_VPU_HDMI_SETTING, 1, 1, 1);  // [    1] src_sel_encp: Enable ENCP output to HDMI
	}
}

static void mode420_half_horizontal_para(void)
{
	unsigned int hactive = 0;
	unsigned int hblank = 0;
	unsigned int hfront = 0;
	unsigned int hsync = 0;

	printk("%s[%d]\n", __func__, __LINE__);
	hactive  =  hdmitx_rd_reg(HDMITX_DWC_FC_INHACTV0);
	hactive += (hdmitx_rd_reg(HDMITX_DWC_FC_INHACTV1) & 0x3f) << 8;
	hblank  =  hdmitx_rd_reg(HDMITX_DWC_FC_INHBLANK0);
	hblank += (hdmitx_rd_reg(HDMITX_DWC_FC_INHBLANK1) & 0x1f) << 8;
	hfront  =  hdmitx_rd_reg(HDMITX_DWC_FC_HSYNCINDELAY0);
	hfront += (hdmitx_rd_reg(HDMITX_DWC_FC_HSYNCINDELAY1) & 0x1f) << 8;
	hsync  =  hdmitx_rd_reg(HDMITX_DWC_FC_HSYNCINWIDTH0);
	hsync += (hdmitx_rd_reg(HDMITX_DWC_FC_HSYNCINWIDTH1) & 0x3) << 8;

	hactive = hactive / 2;
	hblank = hblank / 2;
	hfront = hfront / 2;
	hsync = hsync / 2;

	hdmitx_wr_reg(HDMITX_DWC_FC_INHACTV0, (hactive & 0xff));
	hdmitx_wr_reg(HDMITX_DWC_FC_INHACTV1, ((hactive >> 8) & 0x3f));
	hdmitx_wr_reg(HDMITX_DWC_FC_INHBLANK0, (hblank  & 0xff));
	hdmitx_wr_reg(HDMITX_DWC_FC_INHBLANK1, ((hblank >> 8) & 0x1f));
	hdmitx_wr_reg(HDMITX_DWC_FC_HSYNCINDELAY0, (hfront & 0xff));
	hdmitx_wr_reg(HDMITX_DWC_FC_HSYNCINDELAY1, ((hfront >> 8) & 0x1f));
	hdmitx_wr_reg(HDMITX_DWC_FC_HSYNCINWIDTH0, (hsync & 0xff));
	hdmitx_wr_reg(HDMITX_DWC_FC_HSYNCINWIDTH1, ((hsync >> 8) & 0x3));
}

static void set_tmds_clk_div40(unsigned int div40)
{
	if (div40 == 1) {
		hdmitx_wr_reg(HDMITX_TOP_TMDS_CLK_PTTN_01, 0);		  // [25:16] tmds_clk_pttn[19:10]  [ 9: 0] tmds_clk_pttn[ 9: 0]
		hdmitx_wr_reg(HDMITX_TOP_TMDS_CLK_PTTN_23, 0x03ff03ff); // [25:16] tmds_clk_pttn[39:30]  [ 9: 0] tmds_clk_pttn[29:20]
	} else {
		hdmitx_wr_reg(HDMITX_TOP_TMDS_CLK_PTTN_01, 0x001f001f);
		hdmitx_wr_reg(HDMITX_TOP_TMDS_CLK_PTTN_23, 0x001f001f);
	}
	hdmitx_set_reg_bits(HDMITX_DWC_FC_SCRAMBLER_CTRL, (div40 == 1) ? 1 : 0, 0, 1);

	hdmitx_wr_reg(HDMITX_TOP_TMDS_CLK_PTTN_CNTL, 0x1);			// 0xc
	msleep(2);
	hdmitx_wr_reg(HDMITX_TOP_TMDS_CLK_PTTN_CNTL, 0x2);            // 0xc
	scdc_prepare((div40 == 1) ? 1:0);
}

static void hdmitx_set_vsi_pkt(enum hdmi_vic vic)
{
	/* convert to HDMI_VIC */
	if (vic == HDMI_3840x2160p30_16x9)
		vic = 1;
	else if (vic == HDMI_3840x2160p25_16x9)
		vic = 2;
	else if (vic == HDMI_3840x2160p24_16x9)
		vic = 3;
	else
		vic = 4;

	hdmitx_wr_reg(HDMITX_DWC_FC_VSDIEEEID0, 0x03);
	hdmitx_wr_reg(HDMITX_DWC_FC_VSDIEEEID1, 0x0c);
	hdmitx_wr_reg(HDMITX_DWC_FC_VSDIEEEID2, 0x00);
	hdmitx_wr_reg(HDMITX_DWC_FC_AVIVID, 0);
	hdmitx_wr_reg(HDMITX_DWC_FC_VSDPAYLOAD0, 0x20);
	hdmitx_wr_reg(HDMITX_DWC_FC_VSDPAYLOAD1, vic);
	hdmitx_wr_reg(HDMITX_DWC_FC_VSDSIZE, 5);
	hdmitx_set_reg_bits(HDMITX_DWC_FC_DATAUTO0, 1, 3, 1);
	hdmitx_wr_reg(HDMITX_DWC_FC_DATAUTO1, 0);
	hdmitx_wr_reg(HDMITX_DWC_FC_DATAUTO2, 0x10);
	hdmitx_set_reg_bits(HDMITX_DWC_FC_PACKET_TX_EN, 1, 4, 1);
}

/* record HDMITX current format */
/* ISA_DEBUG_REG0 0x2600
 * bit[11]: Y420
 * bit[10:8]: HDMI VIC
 * bit[7:0]: CEA VIC
 */
static void save_hdmitx_format(enum hdmi_vic vic, int y420)
{
	unsigned int data32;

	data32 = vic & 0xff;
	data32 |= (hdmitx_rd_reg(HDMITX_DWC_FC_VSDPAYLOAD1) & 0x7) << 8;
	data32 |= (!!y420) << 11;
	hd_write_reg(P_ISA_DEBUG_REG0, data32);
}

static void hdmitx_set_vdac(unsigned int enable)
{
	if (0 == enable)
	{
		hd_write_reg(P_HHI_VDAC_CNTL0, 0);
		hd_write_reg(P_HHI_VDAC_CNTL1, 8);
	}
	else if (1 == enable)
	{
		hd_write_reg(P_HHI_VDAC_CNTL0, 1);
		hd_write_reg(P_HHI_VDAC_CNTL1, 0);
	}

	return ;
}

static void hdmitx_set_hw(struct hdmitx_dev* hdev)
{
	struct hdmi_format_para *para = NULL;

	para = hdmi_get_fmt_paras(hdev->vic);
	if (para == NULL) {
		printk("error at %s[%d]\n", __func__, __LINE__);
		return;
	}
	hdmitx_set_pll(hdev);
	hdmitx_set_phy(hdev);
	hdmitx_enc(hdev->vic);
	hdmitx_set_vdac(0);

	// --------------------------------------------------------
	// Set up HDMI
	// --------------------------------------------------------
	config_hdmi20_tx(hdev->vic, para,                     // pixel_repeat,
		hdev->para->cd,                        // Pixel bit width: 4=24-bit; 5=30-bit; 6=36-bit; 7=48-bit.
		TX_INPUT_COLOR_FORMAT,                 // input_color_format: 0=RGB444; 1=YCbCr422; 2=YCbCr444; 3=YCbCr420.
		TX_INPUT_COLOR_RANGE,                  // input_color_range: 0=limited; 1=full.
		hdev->para->cs,                // output_color_format: 0=RGB444; 1=YCbCr422; 2=YCbCr444; 3=YCbCr420.
		TX_OUTPUT_COLOR_RANGE                 // output_color_range: 0=limited; 1=full.
		);

	/* switch HDMI_VIC for 2160p30/25/24hz */
	switch (hdev->vic) {
	case HDMI_3840x2160p24_16x9:
	case HDMI_3840x2160p25_16x9:
	case HDMI_3840x2160p30_16x9:
	case HDMI_4096x2160p24_256x135:
		hdmitx_set_vsi_pkt(hdev->vic);
		break;
	default:
		break;
	}

	/* Using ISA_DEBUG_REG0 to record HDMITX current format */
	save_hdmitx_format(hdev->vic, (hdev->para->cs == HDMI_COLOR_FORMAT_420));

	hd_write_reg(P_VPU_HDMI_FMT_CTRL,(((TX_INPUT_COLOR_FORMAT==HDMI_COLOR_FORMAT_420)?2:0)  << 0) | // [ 1: 0] hdmi_vid_fmt. 0=444; 1=convert to 422; 2=convert to 420.
						 (2													 << 2) | // [ 3: 2] chroma_dnsmp. 0=use pixel 0; 1=use pixel 1; 2=use average.
						 (0													 << 4) | // [	4] dith_en. 1=enable dithering before HDMI TX input.
						 (0													 << 5) | // [	5] hdmi_dith_md: random noise selector.
						 (0													 << 6)); // [ 9: 6] hdmi_dith10_cntl.
	if (hdev->para->cs == HDMI_COLOR_FORMAT_420) {
		hd_set_reg_bits(P_VPU_HDMI_FMT_CTRL, 2, 0, 2);
		hd_set_reg_bits(P_VPU_HDMI_SETTING, 0, 4, 4);
		hd_set_reg_bits(P_VPU_HDMI_SETTING, 1, 8, 1);
	}
	switch (hdev->vic) {
	case HDMI_720x480i60_16x9:
	case HDMI_720x576i50_16x9:
		enc_vpu_bridge_reset(0);
		break;
	default:
		enc_vpu_bridge_reset(1);
		break;
	}

	if (hdev->para->cs == HDMI_COLOR_FORMAT_420)
		mode420_half_horizontal_para();

	switch (hdev->vic) {
	case HDMI_3840x2160p50_16x9:
	case HDMI_3840x2160p60_16x9:
	case HDMI_4096x2160p50_256x135:
	case HDMI_4096x2160p60_256x135:
		if ((hdev->para->cs == HDMI_COLOR_FORMAT_420)
		   && (hdev->para->cd == HDMI_COLOR_DEPTH_24B))
			set_tmds_clk_div40(0);
		else
			set_tmds_clk_div40(1);
		break;
	case HDMI_3840x2160p50_16x9_Y420:
	case HDMI_3840x2160p60_16x9_Y420:
	case HDMI_4096x2160p50_256x135_Y420:
	case HDMI_4096x2160p60_256x135_Y420:
		if ((hdev->para->cs == HDMI_COLOR_FORMAT_420)
		   && (hdev->para->cd == HDMI_COLOR_DEPTH_24B))
			set_tmds_clk_div40(0);
		else
			set_tmds_clk_div40(1);
		break;
	case HDMI_3840x2160p24_16x9:
	case HDMI_3840x2160p24_64x27:
	case HDMI_4096x2160p24_256x135:
	case HDMI_3840x2160p25_16x9:
	case HDMI_3840x2160p25_64x27:
	case HDMI_4096x2160p25_256x135:
	case HDMI_3840x2160p30_16x9:
	case HDMI_3840x2160p30_64x27:
	case HDMI_4096x2160p30_256x135:
	case HDMI_1920x1080p100_16x9:
	case HDMI_1920x1080p120_16x9:
		if ((hdev->para->cs == HDMI_COLOR_FORMAT_422)
			|| (hdev->para->cd == HDMI_COLOR_DEPTH_24B))
			set_tmds_clk_div40(0);
		else
			set_tmds_clk_div40(1);
		break;
	default:
		set_tmds_clk_div40(0);
		break;
	}
	hdmitx_set_reg_bits(HDMITX_DWC_FC_INVIDCONF, 0, 3, 1);
	msleep(1);
	hdmitx_set_reg_bits(HDMITX_DWC_FC_INVIDCONF, 1, 3, 1);
}

// Use this self-made function rather than %, because % appears to produce wrong
// value for divisor which are not 2's exponential.
static unsigned long modulo(unsigned long a, unsigned long b)
{
	if (a >= b) {
		return(a-b);
	} else {
		return(a);
	}
}

static signed int to_signed(unsigned int a)
{
	if (a <= 7) {
		return(a);
	} else {
		return(a-16);
	}
}

// TODO
static void hdmitx_csc_config (unsigned char input_color_format,
                        unsigned char output_color_format,
                        unsigned char color_depth)
{
	unsigned char   conv_en;
	unsigned long   csc_coeff_a1, csc_coeff_a2, csc_coeff_a3, csc_coeff_a4;
	unsigned long   csc_coeff_b1, csc_coeff_b2, csc_coeff_b3, csc_coeff_b4;
	unsigned long   csc_coeff_c1, csc_coeff_c2, csc_coeff_c3, csc_coeff_c4;
	unsigned char   csc_scale;
	unsigned long   data32;

	conv_en = (((input_color_format  == HDMI_COLOR_FORMAT_RGB) ||
                (output_color_format == HDMI_COLOR_FORMAT_RGB)) &&
               ( input_color_format  != output_color_format))? 1 : 0;

	if (conv_en) {
		if (output_color_format == HDMI_COLOR_FORMAT_RGB) {
			csc_coeff_a1    = 0x2000;
			csc_coeff_a2    = 0x6926;
			csc_coeff_a3    = 0x74fd;
			csc_coeff_a4    = (color_depth==HDMI_COLOR_DEPTH_24B)? 0x010e :
                              (color_depth==HDMI_COLOR_DEPTH_30B)? 0x043b :
                              (color_depth==HDMI_COLOR_DEPTH_36B)? 0x10ee :
                              (color_depth==HDMI_COLOR_DEPTH_48B)? 0x10ee : 0x010e;
			csc_coeff_b1    = 0x2000;
			csc_coeff_b2    = 0x2cdd;
			csc_coeff_b3    = 0x0000;
			csc_coeff_b4    = (color_depth==HDMI_COLOR_DEPTH_24B)? 0x7e9a :
                              (color_depth==HDMI_COLOR_DEPTH_30B)? 0x7a65 :
                              (color_depth==HDMI_COLOR_DEPTH_36B)? 0x6992 :
                              (color_depth==HDMI_COLOR_DEPTH_48B)? 0x6992 : 0x7e9a;
			csc_coeff_c1    = 0x2000;
			csc_coeff_c2    = 0x0000;
			csc_coeff_c3    = 0x38b4;
			csc_coeff_c4    = (color_depth==HDMI_COLOR_DEPTH_24B)? 0x7e3b :
                              (color_depth==HDMI_COLOR_DEPTH_30B)? 0x78ea :
                              (color_depth==HDMI_COLOR_DEPTH_36B)? 0x63a6 :
                              (color_depth==HDMI_COLOR_DEPTH_48B)? 0x63a6 : 0x7e3b;
			csc_scale       = 1;
		} else {    // input_color_format == HDMI_COLOR_FORMAT_RGB
			csc_coeff_a1    = 0x2591;
			csc_coeff_a2    = 0x1322;
			csc_coeff_a3    = 0x074b;
			csc_coeff_a4    = 0x0000;
			csc_coeff_b1    = 0x6535;
			csc_coeff_b2    = 0x2000;
			csc_coeff_b3    = 0x7acc;
			csc_coeff_b4    = (color_depth==HDMI_COLOR_DEPTH_24B)? 0x0200 :
                              (color_depth==HDMI_COLOR_DEPTH_30B)? 0x0800 :
                              (color_depth==HDMI_COLOR_DEPTH_36B)? 0x2000 :
                              (color_depth==HDMI_COLOR_DEPTH_48B)? 0x2000 : 0x0200;
			csc_coeff_c1    = 0x6acd;
			csc_coeff_c2    = 0x7534;
			csc_coeff_c3    = 0x2000;
			csc_coeff_c4    = (color_depth==HDMI_COLOR_DEPTH_24B)? 0x0200 :
                              (color_depth==HDMI_COLOR_DEPTH_30B)? 0x0800 :
                              (color_depth==HDMI_COLOR_DEPTH_36B)? 0x2000 :
                              (color_depth==HDMI_COLOR_DEPTH_48B)? 0x2000 : 0x0200;
			csc_scale       = 0;
		}
	} else {
		csc_coeff_a1    = 0x2000;
		csc_coeff_a2    = 0x0000;
		csc_coeff_a3    = 0x0000;
		csc_coeff_a4    = 0x0000;
		csc_coeff_b1    = 0x0000;
		csc_coeff_b2    = 0x2000;
		csc_coeff_b3    = 0x0000;
		csc_coeff_b4    = 0x0000;
		csc_coeff_c1    = 0x0000;
		csc_coeff_c2    = 0x0000;
		csc_coeff_c3    = 0x2000;
		csc_coeff_c4    = 0x0000;
		csc_scale       = 1;
	}

	hdmitx_wr_reg(HDMITX_DWC_CSC_COEF_A1_MSB,   (csc_coeff_a1>>8)&0xff  );
	hdmitx_wr_reg(HDMITX_DWC_CSC_COEF_A1_LSB,	csc_coeff_a1&0xff	  );
	hdmitx_wr_reg(HDMITX_DWC_CSC_COEF_A2_MSB,   (csc_coeff_a2>>8)&0xff  );
	hdmitx_wr_reg(HDMITX_DWC_CSC_COEF_A2_LSB,	csc_coeff_a2&0xff	  );
	hdmitx_wr_reg(HDMITX_DWC_CSC_COEF_A3_MSB,   (csc_coeff_a3>>8)&0xff  );
	hdmitx_wr_reg(HDMITX_DWC_CSC_COEF_A3_LSB,	csc_coeff_a3&0xff	  );
	hdmitx_wr_reg(HDMITX_DWC_CSC_COEF_A4_MSB,   (csc_coeff_a4>>8)&0xff  );
	hdmitx_wr_reg(HDMITX_DWC_CSC_COEF_A4_LSB,	csc_coeff_a4&0xff	  );
	hdmitx_wr_reg(HDMITX_DWC_CSC_COEF_B1_MSB,   (csc_coeff_b1>>8)&0xff  );
	hdmitx_wr_reg(HDMITX_DWC_CSC_COEF_B1_LSB,	csc_coeff_b1&0xff	  );
	hdmitx_wr_reg(HDMITX_DWC_CSC_COEF_B2_MSB,   (csc_coeff_b2>>8)&0xff  );
	hdmitx_wr_reg(HDMITX_DWC_CSC_COEF_B2_LSB,	csc_coeff_b2&0xff	  );
	hdmitx_wr_reg(HDMITX_DWC_CSC_COEF_B3_MSB,   (csc_coeff_b3>>8)&0xff  );
	hdmitx_wr_reg(HDMITX_DWC_CSC_COEF_B3_LSB,	csc_coeff_b3&0xff	  );
	hdmitx_wr_reg(HDMITX_DWC_CSC_COEF_B4_MSB,   (csc_coeff_b4>>8)&0xff  );
	hdmitx_wr_reg(HDMITX_DWC_CSC_COEF_B4_LSB,	csc_coeff_b4&0xff	  );
	hdmitx_wr_reg(HDMITX_DWC_CSC_COEF_C1_MSB,   (csc_coeff_c1>>8)&0xff  );
	hdmitx_wr_reg(HDMITX_DWC_CSC_COEF_C1_LSB,	csc_coeff_c1&0xff	  );
	hdmitx_wr_reg(HDMITX_DWC_CSC_COEF_C2_MSB,   (csc_coeff_c2>>8)&0xff  );
	hdmitx_wr_reg(HDMITX_DWC_CSC_COEF_C2_LSB,	csc_coeff_c2&0xff	  );
	hdmitx_wr_reg(HDMITX_DWC_CSC_COEF_C3_MSB,   (csc_coeff_c3>>8)&0xff  );
	hdmitx_wr_reg(HDMITX_DWC_CSC_COEF_C3_LSB,	csc_coeff_c3&0xff	  );
	hdmitx_wr_reg(HDMITX_DWC_CSC_COEF_C4_MSB,   (csc_coeff_c4>>8)&0xff  );
	hdmitx_wr_reg(HDMITX_DWC_CSC_COEF_C4_LSB,	csc_coeff_c4&0xff	  );

	data32  = 0;
	data32 |= (color_depth  << 4);  // [7:4] csc_color_depth
	data32 |= (csc_scale	<< 0);  // [1:0] cscscale
	hdmitx_wr_reg(HDMITX_DWC_CSC_SCALE,         data32);
}   /* hdmitx_csc_config */
