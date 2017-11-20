 /*
  * arch/arm/cpu/armv8/txlx/hdmirx/hdmirx.c
  *
  * Copyright (C) 2012 AMLOGIC, INC. All Rights Reserved.
  * Author: hongmin hua <hongmin hua@amlogic.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the smems of the GNU General Public License as published by
  * the Free Software Foundation; version 2 of the License.
  */

#include <config.h>
#include <common.h>
#include <command.h>
#include <asm/cpu_id.h>
#include <asm/arch/io.h>
#include <asm/arch/hdmirx_reg.h>
#include "hdmirx.h"

struct hdmirx_data_s hdmirx_data;

unsigned char edid_14[] = {
	0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00,
	0x05, 0xac, 0x30, 0x00, 0x01, 0x00, 0x00, 0x00,
	0x20, 0x19, 0x01, 0x03, 0x80, 0x73, 0x41, 0x78,
	0x0a, 0xcf, 0x74, 0xa3, 0x57, 0x4c, 0xb0, 0x23,
	0x09, 0x48, 0x4c, 0x2f, 0x4f, 0x00, 0x01, 0x01,
	0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
	0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x04, 0x74,
	0x00, 0x30, 0xf2, 0x70, 0x5a, 0x80, 0xb0, 0x58,
	0x8a, 0x00, 0x20, 0xc2, 0x31, 0x00, 0x00, 0x1e,
	0x02, 0x3a, 0x80, 0x18, 0x71, 0x38, 0x2d, 0x40,
	0x58, 0x2c, 0x45, 0x00, 0x20, 0xc2, 0x31, 0x00,
	0x00, 0x1e, 0x00, 0x00, 0x00, 0xfc, 0x00, 0x41,
	0x4d, 0x4c, 0x20, 0x54, 0x56, 0x0a, 0x20, 0x20,
	0x20, 0x20, 0x20, 0x20, 0x00, 0x00, 0x00, 0xfd,
	0x00, 0x3b, 0x46, 0x1f, 0x8c, 0x3c, 0x00, 0x0a,
	0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x01, 0x85,
	0x02, 0x03, 0x3c, 0xf0, 0x57, 0x5f, 0x10, 0x1f,
	0x14, 0x05, 0x13, 0x04, 0x20, 0x22, 0x3c, 0x3e,
	0x12, 0x16, 0x03, 0x07, 0x11, 0x15, 0x02, 0x06,
	0x01, 0x5d, 0x64, 0x62, 0x29, 0x0f, 0x7f, 0x05,
	0x11, 0x07, 0x00, 0x57, 0x06, 0x00, 0x83, 0x01,
	0x00, 0x00, 0x6e, 0x03, 0x0c, 0x00, 0x20, 0x00,
	0x98, 0x3c, 0x20, 0x80, 0x80, 0x01, 0x02, 0x03,
	0x04, 0xe2, 0x00, 0xfb, 0x02, 0x3a, 0x80, 0xd0,
	0x72, 0x38, 0x2d, 0x40, 0x10, 0x2c, 0x45, 0x80,
	0x30, 0xeb, 0x52, 0x00, 0x00, 0x1f, 0x00, 0x00,
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x1d,
};

static unsigned first_bit_set(uint32_t data)
{
	unsigned n = 32;

	if (data != 0) {
		for (n = 0; (data & 1) == 0; n++)
			data >>= 1;
	}
	return n;
}

uint32_t get(uint32_t data, uint32_t mask)
{
	return (data & mask) >> first_bit_set(mask);
}

uint32_t set(uint32_t data, uint32_t mask, uint32_t value)
{
	return ((value << first_bit_set(mask)) & mask) | (data & ~mask);
}

unsigned int rx_rd_reg(unsigned long reg_addr)
{
	unsigned int val = 0;

	val = readl(reg_addr);

	return val;
}

void rx_wr_reg(unsigned long reg_addr, unsigned int val)
{
	writel(val, reg_addr);
}

uint32_t hdmirx_rd_dwc(unsigned long addr)
{
	int data;
	unsigned long dev_offset = 0x10;
	rx_wr_reg(HDMIRX_ADDR_PORT | dev_offset, addr);
	data = rx_rd_reg(HDMIRX_DATA_PORT | dev_offset);
	return data;
}

uint32_t hdmirx_rd_bits_dwc(unsigned long addr, uint32_t mask)
{
	return get(hdmirx_rd_dwc(addr), mask);
}

/**
 * Write data to HDMI RX CTRL
 * @param[in] addr register address
 * @param[in] data new register value
 */
void hdmirx_wr_dwc(unsigned long addr, uint32_t data)
{
	unsigned long dev_offset = 0x10;
	rx_wr_reg(HDMIRX_ADDR_PORT | dev_offset, addr);
	rx_wr_reg(HDMIRX_DATA_PORT | dev_offset, data);
}

void hdmirx_wr_bits_dwc(unsigned long addr, uint32_t mask, uint32_t value)
{
	hdmirx_wr_dwc(addr, set(hdmirx_rd_dwc(addr), mask, value));
}

unsigned long hdmirx_rd_top(unsigned long addr)
{
	int data;
	unsigned long dev_offset = 0;
	rx_wr_reg(HDMIRX_ADDR_PORT | dev_offset, addr);
	rx_wr_reg(HDMIRX_ADDR_PORT | dev_offset, addr);
	data = rx_rd_reg(HDMIRX_DATA_PORT | dev_offset);
	return data;
} /* hdmirx_rd_TOP */

uint32_t hdmirx_rd_bits_top(unsigned long addr, uint32_t mask)
{
	return get(hdmirx_rd_top(addr), mask);
}

void hdmirx_wr_top(unsigned long addr, unsigned long data)
{
	unsigned long dev_offset = 0;
	rx_wr_reg(HDMIRX_ADDR_PORT | dev_offset, addr);
	rx_wr_reg(HDMIRX_DATA_PORT | dev_offset, data);
}

void hdmirx_wr_bits_top(unsigned long addr, uint32_t mask, uint32_t value)
{
	hdmirx_wr_top(addr, set(hdmirx_rd_top(addr), mask, value));
}

unsigned int rd_reg_hhi(unsigned long offset)
{
	unsigned long addr = offset + HHI_BASE_ADDR;

	return rx_rd_reg(addr);
}

void wr_reg_hhi(unsigned long offset, unsigned int val)
{
	unsigned long addr = offset + HHI_BASE_ADDR;
	rx_wr_reg(addr, val);
}

bool hdmirx_repeat_support(void)
{
	return hdmirx_data.repeater;
}

unsigned char *rx_get_edid(int edid_index)
{
	if (hdmirx_data.edid_buf != NULL)
		return hdmirx_data.edid_buf;
	else
		return edid_14;
}

unsigned int rx_exchange_bits(unsigned int value)
{
	unsigned int temp;
	printf("bfe:%#x\n", value);
	temp = value & 0xF;
	value = (((value >> 4) & 0xF) | (value & 0xFFF0));
	value = ((value & 0xFF0F) | (temp << 4));
	temp = value & 0xF00;
	value = (((value >> 4) & 0xF00) | (value & 0xF0FF));
	value = ((value & 0x0FFF) | (temp << 4));
	printf("aft:%#x\n", value);
	return value;
}

unsigned int rx_edid_cal_phy_addr(
					unsigned int brepeat,
					unsigned int up_addr,
					unsigned int portmap,
					unsigned char *pedid,
					unsigned int *phy_offset,
					unsigned int *phy_addr)
{
	unsigned int root_offset = 0;
	unsigned int i;
	unsigned int flag = 0;

	if (!(pedid && phy_offset && phy_addr))
		return -1;

	for (i = 0; i <= 255; i++) {
		/*find phy_addr_offset*/
		if (pedid[i] == 0x03) {
			if ((0x0c == pedid[i+1]) &&
			    (0x00 == pedid[i+2]) &&
				(0x00 == pedid[i+4])) {
				if (brepeat)
					pedid[i+3] = 0x00;
				else
					pedid[i+3] = 0x10;
				*phy_offset = i+3;
				flag = 1;
				break;
			}
		}
	}

	if (brepeat) {
		/*get the root index*/
		i = 0;
		while (i < 4) {
			if (((up_addr << (i*4)) & 0xf000) != 0) {
				root_offset = i;
				break;
			} else {
				i++;
			}
		}
		if (i == 4)
			root_offset = 4;

		printf("portmap:%#x,rootoffset=%d,upaddr=%#x\n",
		       portmap,	root_offset, up_addr);

		for (i = 0; i < E_PORT_NUM; i++) {
			if (root_offset == 0)
				phy_addr[i] = 0xFFFF;
			else
				phy_addr[i] = (up_addr |
				((((portmap >> i*4) & 0xf) << 12) >>
				(root_offset - 1)*4));

			phy_addr[i] = rx_exchange_bits(phy_addr[i]);
			printf("port %d phy:%d\n", i, phy_addr[i]);
		}
	} else {
		for (i = 0; i < E_PORT_NUM; i++)
			phy_addr[i] = ((portmap >> i*4) & 0xf) << 4;
	}

	return flag;
}

void rx_edid_fill_to_register(
						unsigned char *pedid,
						unsigned int brepeat,
						unsigned int *pphy_addr,
						unsigned char *pchecksum)
{
	unsigned int i;
	unsigned int checksum = 0;
	unsigned int value = 0;

	if (!(pedid && pphy_addr && pchecksum))
		return;

	/*printf("rx_edid_fill_to_register start\n");*/

	/* clear all and disable all overlay register 0~7*/
	for (i = TOP_EDID_RAM_OVR0; i <= TOP_EDID_RAM_OVR7; ) {
		hdmirx_wr_top(i, 0);
		i += 2;
	}

	/* physical address info at second block */
	for (i = 128; i <= 255; i++) {
		value = pedid[i];
		if (i < 255) {
			checksum += pedid[i];
			checksum &= 0xff;
		} else if (i == 255) {
			value = (0x100 - checksum)&0xff;
		}
	}

	/* physical address info at second block */
	for (i = 0; i <= 255; i++) {
		/* fill first edid buffer */
		hdmirx_wr_top(TOP_EDID_OFFSET + i, pedid[i]);
		/* fill second edid buffer */
		hdmirx_wr_top(0x100+TOP_EDID_OFFSET + i, pedid[i]);
	}
	/* caculate 4 port check sum */
	if (brepeat) {
		for (i = 0; i < E_PORT_NUM; i++) {
			pchecksum[i] = (0x100 + value - (pphy_addr[i] & 0xFF) -
			((pphy_addr[i] >> 8) & 0xFF)) & 0xff;
			/*printf("port %d phy:%d\n", i, pphy_addr[i]);*/
		}
	} else {
		for (i = 0; i < E_PORT_NUM; i++) {
			pchecksum[i] = (0x100 - (checksum +
				(pphy_addr[i] - 0x10))) & 0xff;
		}
	}
}

void rx_edid_update_overlay(
						unsigned int phy_addr_offset,
						unsigned int *pphy_addr,
						unsigned char *pchecksum)
{
	/*unsigned int i;*/

	if (!(pphy_addr && pchecksum))
		return;
	/*printf("rx_edid_update_overlay statrt\n");*/

	/* replace the first edid ram data */
	/* physical address byte 1 */
	hdmirx_wr_top(TOP_EDID_RAM_OVR2,
		      (phy_addr_offset + 1) | (0x0f<<16));
	hdmirx_wr_top(TOP_EDID_RAM_OVR2_DATA,
		      ((pphy_addr[E_PORT0] >> 8) & 0xFF) |
		 (((pphy_addr[E_PORT1] >> 8) & 0xFF)<<8)
			| (((pphy_addr[E_PORT2] >> 8) & 0xFF)<<16)
			| (((pphy_addr[E_PORT3] >> 8) & 0xFF)<<24));
	/* physical address byte 0 */
	hdmirx_wr_top(TOP_EDID_RAM_OVR1,
		      phy_addr_offset | (0x0f<<16));
	hdmirx_wr_top(TOP_EDID_RAM_OVR1_DATA,
		      (pphy_addr[E_PORT0] & 0xFF) |
		      ((pphy_addr[E_PORT1] & 0xFF)<<8) |
	  ((pphy_addr[E_PORT2] & 0xFF)<<16) |
	  ((pphy_addr[E_PORT3] & 0xFF) << 24));

	/* checksum */
	hdmirx_wr_top(TOP_EDID_RAM_OVR0,
		      0xff | (0x0f<<16));
	hdmirx_wr_top(TOP_EDID_RAM_OVR0_DATA,
		      pchecksum[E_PORT0]|(pchecksum[E_PORT1]<<8) |
			(pchecksum[E_PORT2]<<16) | (pchecksum[E_PORT3] << 24));


	/* replace the second edid ram data */
	/* physical address byte 1 */
	hdmirx_wr_top(TOP_EDID_RAM_OVR5,
		      (phy_addr_offset + 0x101) | (0x0f<<16));
	hdmirx_wr_top(TOP_EDID_RAM_OVR5_DATA,
		      ((pphy_addr[E_PORT0] >> 8) & 0xFF) |
		 (((pphy_addr[E_PORT1] >> 8) & 0xFF)<<8)
			| (((pphy_addr[E_PORT2] >> 8) & 0xFF)<<16)
			| (((pphy_addr[E_PORT3] >> 8) & 0xFF)<<24));
	/* physical address byte 0 */
	hdmirx_wr_top(TOP_EDID_RAM_OVR4,
		      (phy_addr_offset + 0x100) | (0x0f<<16));
	hdmirx_wr_top(TOP_EDID_RAM_OVR4_DATA,
		      (pphy_addr[E_PORT0] & 0xFF) |
		       ((pphy_addr[E_PORT1] & 0xFF)<<8) |
			((pphy_addr[E_PORT2] & 0xFF)<<16) |
			((pphy_addr[E_PORT3] & 0xFF) << 24));
	/* checksum */
	hdmirx_wr_top(TOP_EDID_RAM_OVR3,
		      (0xff + 0x100) | (0x0f<<16));
	hdmirx_wr_top(TOP_EDID_RAM_OVR3_DATA,
		      pchecksum[E_PORT0]|(pchecksum[E_PORT1]<<8) |
			(pchecksum[E_PORT2]<<16) | (pchecksum[E_PORT3] << 24));

	/*for (i = 0; i < E_PORT_NUM; i++) {
		printf(">port %d,addr 0x%x,checksum 0x%x\n",
		       i, pphy_addr[i], pchecksum[i]);
	}*/
}

int rx_get_tag_code(uint8_t *edid_data)
{
	int tag_code;

	if ((*edid_data >> 5) != 7)
		tag_code = (*edid_data >> 5);
	else
		tag_code = (7 << 8) | *(edid_data + 1);/*extern tag*/

	return tag_code;
}

int rx_get_ceadata_offset(uint8_t *cur_edid, uint8_t *addition)
{
	int i;
	int type;

	if ((cur_edid == NULL) || (addition == NULL))
		return 0;

	type = rx_get_tag_code(addition);
	i = EDID_DEFAULT_START;/*block check start index*/
	while (i < 255) {
		if (type == rx_get_tag_code(cur_edid + i))
			return i;
		else
			i += (1 + (*(cur_edid + i) & 0x1f));
	}
	if (hdmirx_data.dbg_en)
		printf("type: %#x, start addr: %#x\n", type, i);

	return 0;
}

int hdmirx_ctrl_edid_update(void)
{
	bool brepeat = hdmirx_repeat_support();
	unsigned char *pedid_data;
	unsigned int sts;
	unsigned int phy_addr_offset;
	unsigned int phy_addr[E_PORT_NUM] = {0, 0, 0};
	unsigned char checksum[E_PORT_NUM] = {0, 0, 0};

	/* get edid from buffer, return buffer addr */
	pedid_data = rx_get_edid(0);

	/* caculate physical address and checksum */
	sts = rx_edid_cal_phy_addr(brepeat,
					hdmirx_data.up_phy_addr,
					hdmirx_data.port_map,
					pedid_data, &phy_addr_offset,
					phy_addr);
	if (!sts) {
		/* not find physical address info */
		printf("err: not finded phy addr info\n");
	}

	/* write edid to edid register */
	rx_edid_fill_to_register(pedid_data, brepeat,
				 phy_addr, checksum);
	if (sts) {
		/* update physical and checksum */
		rx_edid_update_overlay(phy_addr_offset, phy_addr, checksum);
	}
	return true;
}

static int rx_top_init(void)
{
	int err = 0;
	int data32 = 0;

	data32 |= (0xf	<< 13); /* bit[16:13] */
	data32 |= 0	<< 11;
	data32 |= 0	<< 10;
	data32 |= 0	<< 9;
	data32 |= 0 << 8;
	data32 |= EDID_CLK_DIV << 0;
	hdmirx_wr_top(TOP_EDID_GEN_CNTL,  data32);

	data32 = 0;
	/* SDA filter internal clk div */
	data32 |= 1 << 29;
	/* SDA sampling clk div */
	data32 |= 1 << 16;
	/* SCL filter internal clk div */
	data32 |= 1 << 13;
	/* SCL sampling clk div */
	data32 |= 1 << 0;
	hdmirx_wr_top(TOP_INFILTER_HDCP, data32);
	hdmirx_wr_top(TOP_INFILTER_I2C0, data32);
	hdmirx_wr_top(TOP_INFILTER_I2C1, data32);
	hdmirx_wr_top(TOP_INFILTER_I2C2, data32);
	hdmirx_wr_top(TOP_INFILTER_I2C3, data32);

	data32 = 0;
	/* conversion mode of 422 to 444 */
	data32 |= 0	<< 19;
	/* !!!!dolby vision 422 to 444 ctl bit */
	data32 |= 0	<< 0;
	hdmirx_wr_top(TOP_VID_CNTL,	data32);
	data32 = 0;
	/* delay cycles before n/cts update pulse */
	data32 |= 7 << 0;
	hdmirx_wr_top(TOP_ACR_CNTL2, data32);
	return err;
}

int rx_control_clk_range(unsigned long min, unsigned long max)
{
	int error = 0;
	unsigned evaltime = 0;
	unsigned long ref_clk;

	ref_clk = MODET_CLK;
	evaltime = (ref_clk * 4095) / 158000;
	min = (min * evaltime) / ref_clk;
	max = (max * evaltime) / ref_clk;
	hdmirx_wr_bits_dwc(DWC_HDMI_CKM_F, MINFREQ, min);
	hdmirx_wr_bits_dwc(DWC_HDMI_CKM_F, CKM_MAXFREQ, max);
	return error;
}

void rx_clk_init(void)
{
	unsigned int data32;

	/* DWC clock enable */
	/* Turn on clk_hdmirx_pclk, also = sysclk */
	wr_reg_hhi(HHI_GCLK_MPEG0,
		   rd_reg_hhi(HHI_GCLK_MPEG0) | (1 << 21));

	/* Enable APB3 fail on error */
	/* APB3 to HDMIRX-TOP err_en */
	/* default 0x3ff, | bit15 = 1 */

	/* hdmirx_wr_ctl_port(0, 0x83ff); */
	/* hdmirx_wr_ctl_port(0x10, 0x83ff); */

	/* turn on clocks: md, cfg... */
	/* G9 clk tree */
	/* fclk_div5 400M ----- mux sel = 3 */
	/* fclk_div3 850M ----- mux sel = 2 */
	/* fclk_div4 637M ----- mux sel = 1 */
	/* XTAL		24M  ----- mux sel = 0 */
	/* [26:25] HDMIRX mode detection clock mux select: osc_clk */
	/* [24]    HDMIRX mode detection clock enable */
	/* [22:16] HDMIRX mode detection clock divider */
	/* [10: 9] HDMIRX config clock mux select: */
	/* [    8] HDMIRX config clock enable */
	/* [ 6: 0] HDMIRX config clock divider: */
	data32  = 0;
	data32 |= 0 << 25;
	data32 |= 1 << 24;
	data32 |= 0 << 16;
	data32 |= 3 << 9;
	data32 |= 1 << 8;
	data32 |= 2 << 0;
	wr_reg_hhi(HHI_HDMIRX_CLK_CNTL, data32);

	data32 = 0;
	data32 |= 2	<< 25;
	data32 |= ACR_MODE << 24;
	data32 |= 0	<< 16;
	data32 |= 2	<< 9;
	data32 |= 1	<< 8;
	data32 |= 2	<< 0;
	wr_reg_hhi(HHI_HDMIRX_AUD_CLK_CNTL, data32);

	/* [15] hdmirx_aud_pll4x_en override enable */
	/* [14] hdmirx_aud_pll4x_en override value */
	/* [6:5] clk_sel for cts_hdmirx_aud_pll_clk:
		0=hdmirx_aud_pll_clk */
	/* [4] clk_en for cts_hdmirx_aud_pll_clk */
	/* [2:0] clk_div for cts_hdmirx_aud_pll_clk */
	data32  = 0;
	data32 |= (0 << 15);
	data32 |= (1 << 14);
	data32 |= (0 << 5);
	data32 |= (0 << 4);
	data32 |= (0 << 0);
	wr_reg_hhi(HHI_AUDPLL_CLK_OUT_CNTL, data32);
	data32 |= (1 << 4);
	wr_reg_hhi(HHI_AUDPLL_CLK_OUT_CNTL, data32);
	data32 = 0;
	data32 |= 0 << 31;  /* [31]     disable clkgating */
	data32 |= 1 << 17;  /* [17]     audfifo_rd_en */
	data32 |= 1 << 16;  /* [16]     pktfifo_rd_en */
	data32 |= 1 << 2;   /* [2]      hdmirx_cecclk_en */
	data32 |= 0 << 1;   /* [1]      bus_clk_inv */
	data32 |= 0 << 0;   /* [0]      hdmi_clk_inv */
	hdmirx_wr_top(TOP_CLK_CNTL, data32);    /* DEFAULT: {32'h0} */
}

void rx_set_pinmux(void)
{
	writel(0xFFFF0000, PERIPHS_PIN_MUX_5);
	printf("set pinmux:%#x\n", readl(PERIPHS_PIN_MUX_5));
}

void hdmirx_hw_init(unsigned int port_map,
						  unsigned char *pedid_data,
						  int edid_size)
{
	/*int i, j;*/
	if ((pedid_data != NULL) && (edid_size >= EDID_DEFAULT_LEN)) {
		printf("load %#x,len:%d\n", pedid_data[0], edid_size);
		hdmirx_data.edid_buf = pedid_data;
		hdmirx_data.edid_size = edid_size;
	} else {
		hdmirx_data.edid_buf = edid_14;
		hdmirx_data.edid_size = sizeof(edid_14);
	}
	hdmirx_wr_top(TOP_MEM_PD, 0);
	hdmirx_wr_top(TOP_INTR_MASKN, 0);
	hdmirx_wr_top(TOP_SW_RESET, 0);
	rx_clk_init();
	hdmirx_wr_top(TOP_HPD_PWR5V, 0x10);
	hdmirx_data.port_map = port_map;
	hdmirx_ctrl_edid_update();
	/*for (i = 0; i < 16; i++) {
		printf("[%2d] ", i);
		for (j = 0; j < 16; j++) {
			printf("0x%02lx, ",
			       hdmirx_rd_top(TOP_EDID_OFFSET +
					     (i * 16 + j)));
		}
		printf("\n");
	}*/
	rx_top_init();
	hdmirx_wr_top(TOP_PORT_SEL, 0x10);
	rx_set_pinmux();
	hdmirx_wr_top(TOP_EDID_RAM_OVR7_DATA, 0xFF);
	printf("%s Done port map:%#x !\n", __func__, port_map);
}

