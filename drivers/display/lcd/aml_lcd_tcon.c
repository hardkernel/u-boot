/*
 * drivers/display/lcd/aml_lcd_tcon.c
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

#include <common.h>
#include <malloc.h>
#include <asm/arch/io.h>
#include <amlogic/aml_lcd.h>
#include "aml_lcd_reg.h"
#include "aml_lcd_common.h"
#include "aml_lcd_tcon.h"
//#include "tcon_ceds.h"

static struct tcon_rmem_s tcon_rmem = {
	.flag = 0,
	.mem_paddr = 0,
	.mem_size = 0,
};

static struct lcd_tcon_data_s *lcd_tcon_data;

static int lcd_tcon_valid_check(void)
{
	if (lcd_tcon_data == NULL) {
		LCDERR("invalid tcon data\n");
		return -1;
	}
	if (lcd_tcon_data->tcon_valid == 0) {
		LCDERR("invalid tcon\n");
		return -1;
	}

	return 0;
}

static void lcd_tcon_od_check(unsigned char *table)
{
	unsigned int reg, bit;

	if (lcd_tcon_data->reg_core_od == REG_LCD_TCON_MAX)
		return;

	reg = lcd_tcon_data->reg_core_od;
	bit = lcd_tcon_data->bit_od_en;
	if (((table[reg] >> bit) & 1) == 0)
		return;

	if (tcon_rmem.flag == 0) {
		table[reg] &= ~(1 << bit);
		LCDPR("%s: invalid memory, disable od function\n", __func__);
	}
}

unsigned int lcd_tcon_core_reg_read(unsigned int addr)
{
	unsigned int val;
	int ret;

	ret = lcd_tcon_valid_check();
	if (ret)
		return 0;

	if (lcd_tcon_data->core_reg_width == 8)
		val = lcd_tcon_read_byte(addr + TCON_CORE_REG_START);
	else
		val = lcd_tcon_read(addr + TCON_CORE_REG_START);

	return val;
}

void lcd_tcon_core_reg_write(unsigned int addr, unsigned int val)
{
	unsigned char temp;
	int ret;

	ret = lcd_tcon_valid_check();
	if (ret)
		return;

	if (lcd_tcon_data->core_reg_width == 8) {
		temp = (unsigned char)val;
		lcd_tcon_write_byte((addr + TCON_CORE_REG_START), temp);
	} else {
		lcd_tcon_write((addr + TCON_CORE_REG_START), val);
	}
}

static void lcd_tcon_core_reg_udpate(void)
{
	unsigned char *table;
	unsigned int len, temp;
	int i;

	len = lcd_tcon_data->reg_table_len;
	table = lcd_tcon_data->reg_table;
	if (table == NULL) {
		LCDERR("%s: table is NULL\n", __func__);
		return;
	}
	lcd_tcon_od_check(table);
	if (lcd_tcon_data->core_reg_width == 8) {
		for (i = 0; i < len; i++) {
			lcd_tcon_write_byte((i + TCON_CORE_REG_START),
				table[i]);
		}
	} else {
		for (i = 0; i < len; i++)
			lcd_tcon_write((i + TCON_CORE_REG_START), table[i]);
	}
	LCDPR("tcon core regs update\n");

	if (lcd_tcon_data->reg_core_od != REG_LCD_TCON_MAX) {
		i = lcd_tcon_data->reg_core_od;
		if (lcd_tcon_data->core_reg_width == 8)
			temp = lcd_tcon_read_byte(i + TCON_CORE_REG_START);
		else
			temp = lcd_tcon_read(i + TCON_CORE_REG_START);
		LCDPR("%s: tcon od reg readback: 0x%04x = 0x%04x\n",
			__func__, i, temp);
	}
}

static int lcd_tcon_top_set_txhd(void)
{
	LCDPR("lcd tcon top set\n");

	if (tcon_rmem.flag == 0) {
		LCDERR("%s: invalid axi mem\n", __func__);
	} else {
		lcd_tcon_write(TCON_AXI_OFST, tcon_rmem.mem_paddr);
		LCDPR("set tcon axi_mem addr: 0x%08x\n", tcon_rmem.mem_paddr);
	}

	lcd_tcon_write(TCON_CLK_CTRL, 0x001f);
	lcd_tcon_write(TCON_TOP_CTRL, 0x0199);
	lcd_tcon_write(TCON_RGB_IN_MUX, 0x24);
	lcd_tcon_write(TCON_PLLLOCK_CNTL, 0x0037);
	lcd_tcon_write(TCON_DDRIF_CTRL0, 0x33ff0004);
	lcd_tcon_write(TCON_RST_CTRL, 0x003f);
	lcd_tcon_write(TCON_RST_CTRL, 0x0000);

	return 0;
}

static int lcd_tcon_enable_txhd(struct lcd_config_s *pconf)
{
	struct mlvds_config_s *mlvds_conf;
	int ret;

	ret = lcd_tcon_valid_check();
	if (ret)
		return -1;

	mlvds_conf = pconf->lcd_control.mlvds_config;
	if (mlvds_conf == NULL)
		return -1;

	/* reset apb for tcon */
	lcd_cbus_setb(RESET7_REGISTER, 1, 12, 1);
	udelay(100);

	/* step 1: tcon top */
	lcd_tcon_top_set_txhd();

	/* step 2: tcon_core_reg_update */
	lcd_tcon_core_reg_udpate();

	/* step 3: tcon_top_output_set */
	lcd_tcon_write(TCON_OUT_CH_SEL0, mlvds_conf->channel_sel0);
	lcd_tcon_write(TCON_OUT_CH_SEL1, mlvds_conf->channel_sel1);
	LCDPR("set tcon ch_sel: 0x%08x, 0x%08x\n",
		mlvds_conf->channel_sel0, mlvds_conf->channel_sel1);

	return 0;
}

static int lcd_tcon_top_set_tl1(void)
{
	unsigned int axi_reg[3] = {0x200c, 0x2013, 0x2014};
	unsigned int addr[3] = {0, 0, 0};
	unsigned int size[3] = {4162560, 4162560, 1960440};
	int i;

	LCDPR("lcd tcon top set\n");

	if (tcon_rmem.flag == 0) {
		LCDERR("%s: invalid axi mem\n", __func__);
	} else {
		addr[0] = tcon_rmem.mem_paddr;
		addr[1] = addr[0] + size[0];
		addr[2] = addr[1] + size[1];
		for (i = 0; i < 3; i++) {
			lcd_tcon_write(axi_reg[i], addr[i]);
			LCDPR("set tcon axi_mem[%d]: 0x%08x\n", i, addr[i]);
		}
	}

	lcd_tcon_write(TCON_CLK_CTRL, 0x001f);
	lcd_tcon_write(TCON_TOP_CTRL, 0x8999);
	lcd_tcon_write(TCON_PLLLOCK_CNTL, 0x0037);
	lcd_tcon_write(TCON_RST_CTRL, 0x003f);
	lcd_tcon_write(TCON_RST_CTRL, 0x0000);
	lcd_tcon_write(TCON_DDRIF_CTRL0, 0x33fff000);
	lcd_tcon_write(TCON_DDRIF_CTRL1, 0x300300);

	return 0;
}

static int lcd_tcon_enable_tl1(struct lcd_config_s *pconf)
{
	int ret;

	ret = lcd_tcon_valid_check();
	if (ret)
		return -1;

	/* step 1: tcon top */
	lcd_tcon_top_set_tl1();

	/* step 2: tcon_core_reg_update */
	lcd_tcon_core_reg_udpate();

	/* step 3: tcon_top_output_set */
	lcd_tcon_write(TCON_OUT_CH_SEL1, 0xba98); /* out swap for ch8~11 */
	LCDPR("set tcon ch_sel: 0x%08x, 0x%08x\n",
		lcd_tcon_read(TCON_OUT_CH_SEL0),
		lcd_tcon_read(TCON_OUT_CH_SEL1));

	return 0;
}

static void lcd_tcon_config_axi_offset_default(void)
{
	char *str = NULL;

	str = getenv("tcon_mem_addr");
	if (str) {
		tcon_rmem.mem_paddr = (unsigned int)simple_strtoul(str, NULL, 16);
		tcon_rmem.mem_size = lcd_tcon_data->axi_mem_size;
		tcon_rmem.flag = 1;
	} else {
		LCDERR("can't find env tcon_mem_addr\n");
	}
}

static int lcd_tcon_config(char *dt_addr, struct lcd_config_s *pconf, int load_id)
{
	int key_len, reg_len;
	int parent_offset;
	char *propdata;
	int ret;

	if (load_id & 0x1) {
		parent_offset = fdt_path_offset(dt_addr, "/lcd");
		if (parent_offset < 0) {
			LCDERR("can't find /lcd node: %s\n", fdt_strerror(parent_offset));
		} else {
			propdata = (char *)fdt_getprop(dt_addr, parent_offset,
				"tcon_mem_addr", NULL);
			if (propdata == NULL) {
				propdata = (char *)fdt_getprop(dt_addr,
					parent_offset, "tcon_fb_addr", NULL);
				if (propdata == NULL) {
					LCDERR("failed to get tcon_mem_addr from dts\n");
					lcd_tcon_config_axi_offset_default();
				} else {
					tcon_rmem.mem_paddr = be32_to_cpup(((u32*)propdata));
					tcon_rmem.mem_size = lcd_tcon_data->axi_mem_size;
					tcon_rmem.flag = 1;
				}
			} else {
				tcon_rmem.mem_paddr = be32_to_cpup(((u32*)propdata));
				tcon_rmem.mem_size = lcd_tcon_data->axi_mem_size;
				tcon_rmem.flag = 1;
			}
		}
	} else {
		lcd_tcon_config_axi_offset_default();
	}

#if 1
	/* get reg table from unifykey */
	reg_len = lcd_tcon_data->reg_table_len;
	if (lcd_tcon_data->reg_table == NULL) {
		lcd_tcon_data->reg_table =
			(unsigned char *)malloc(sizeof(unsigned char) * reg_len);
		if (!lcd_tcon_data->reg_table) {
			LCDERR("%s: Not enough memory\n", __func__);
			return -1;
		}
	}
	memset(lcd_tcon_data->reg_table, 0, (sizeof(unsigned char) * reg_len));
	key_len = reg_len;
	ret = aml_lcd_unifykey_get_no_header("lcd_tcon",
		lcd_tcon_data->reg_table, &key_len);
	if (ret) {
		free(lcd_tcon_data->reg_table);
		lcd_tcon_data->reg_table = NULL;
		LCDERR("%s: !!!!!!!!tcon unifykey load error!!!!!!!!\n", __func__);
		return -1;
	}
	if (key_len != reg_len) {
		free(lcd_tcon_data->reg_table);
		lcd_tcon_data->reg_table = NULL;
		LCDERR("%s: !!!!!!!!tcon unifykey load length error!!!!!!!!\n", __func__);
		return -1;
	}
	LCDPR("tcon: load unifykey len: %d\n", key_len);
#else
	reg_len = lcd_tcon_data->reg_table_len;
	if (lcd_tcon_data->reg_table == NULL)
		lcd_tcon_data->reg_table = uhd_tcon_setting_ceds_h10;
	key_len = sizeof(uhd_tcon_setting_ceds_h10)/sizeof(unsigned char);
	if (key_len != reg_len) {
		free(lcd_tcon_data->reg_table);
		lcd_tcon_data->reg_table = NULL;
		LCDERR("%s: !!!!!!!!tcon unifykey load length error!!!!!!!!\n",
			__func__);
		return -1;
	}
	LCDPR("tcon: load default table len: %d\n", key_len);
#endif

	return 0;
}

/* **********************************
 * tcon function api
 * **********************************
 */
#define PR_BUF_MAX    200
void lcd_tcon_reg_table_print(void)
{
	int i, j, n, cnt;
	char *buf;
	int ret;

	ret = lcd_tcon_valid_check();
	if (ret)
		return;

	if (lcd_tcon_data->reg_table == NULL) {
		LCDERR("%s: reg_table is null\n", __func__);
		return;
	}

	buf = (char *)malloc(PR_BUF_MAX * sizeof(char));
	if (buf == NULL) {
		LCDERR("%s: buf malloc error\n", __func__);
		return;
	}

	LCDPR("%s:\n", __func__);
	cnt = lcd_tcon_data->reg_table_len;
	for (i = 0; i < cnt; i += 16) {
		n = snprintf(buf, PR_BUF_MAX, "0x%04x: ", i);
		for (j = 0; j < 16; j++) {
			if ((i + j) >= cnt)
				break;
			n += snprintf(buf+n, PR_BUF_MAX, " 0x%02x",
				lcd_tcon_data->reg_table[i+j]);
		}
		buf[n] = '\0';
		printf("%s\n", buf);
	}
	free(buf);
}

void lcd_tcon_reg_readback_print(void)
{
	int i, j, n, cnt;
	char *buf;
	int ret;

	ret = lcd_tcon_valid_check();
	if (ret)
		return;

	buf = (char *)malloc(PR_BUF_MAX * sizeof(char));
	if (buf == NULL) {
		LCDERR("%s: buf malloc error\n", __func__);
		return;
	}

	LCDPR("%s:\n", __func__);
	cnt = lcd_tcon_data->reg_table_len;
	for (i = 0; i < cnt; i += 16) {
		n = snprintf(buf, PR_BUF_MAX, "0x%04x: ", i);
		for (j = 0; j < 16; j++) {
			if ((i + j) >= cnt)
				break;
			if (lcd_tcon_data->core_reg_width == 8) {
				n += snprintf(buf+n, PR_BUF_MAX, " 0x%02x",
					lcd_tcon_read_byte(i+j));
			} else {
				n += snprintf(buf+n, PR_BUF_MAX, " 0x%02x",
					lcd_tcon_read(i+j));
			}
		}
		buf[n] = '\0';
		printf("%s\n", buf);
	}
	free(buf);
}

void lcd_tcon_info_print(void)
{
	int ret;

	ret = lcd_tcon_valid_check();
	if (ret)
		return;

	LCDPR("%s:\n", __func__);
	printf("core_reg_width:    %d\n"
		"reg_table_len:     %d\n"
		"axi_mem addr:      0x%08x\n"
		"axi_mem size:      0x%08x\n",
		lcd_tcon_data->core_reg_width,
		lcd_tcon_data->reg_table_len,
		tcon_rmem.mem_paddr,
		tcon_rmem.mem_size);
}

int lcd_tcon_enable(struct lcd_config_s *pconf)
{
	int ret;

	ret = lcd_tcon_valid_check();
	if (ret)
		return -1;

	if (lcd_tcon_data->tcon_enable)
		lcd_tcon_data->tcon_enable(pconf);

	return 0;
}

void lcd_tcon_disable(void)
{
	unsigned int reg, i, cnt, offset, bit;
	int ret;

	ret = lcd_tcon_valid_check();
	if (ret)
		return;

	LCDPR("%s\n", __func__);
	/* disable over_drive */
	if (lcd_tcon_data->reg_core_od != REG_LCD_TCON_MAX) {
		reg = lcd_tcon_data->reg_core_od + TCON_CORE_REG_START;
		if (lcd_tcon_data->core_reg_width == 8)
			lcd_tcon_write_byte(reg, 0);
		else
			lcd_tcon_write(reg, 0);
		mdelay(100);
	}

	/* disable all ctrl signal */
	if (lcd_tcon_data->reg_core_ctrl_timing_base != REG_LCD_TCON_MAX) {
		reg = lcd_tcon_data->reg_core_ctrl_timing_base + TCON_CORE_REG_START;
		offset = lcd_tcon_data->ctrl_timing_offset;
		cnt = lcd_tcon_data->ctrl_timing_cnt;
		for (i = 0; i < cnt; i++) {
			if (lcd_tcon_data->core_reg_width == 8)
				lcd_tcon_setb_byte((reg + (i * offset)), 1, 3, 1);
			else
				lcd_tcon_setb((reg + (i * offset)), 1, 3, 1);
		}
	}

	/* disable top */
	if (lcd_tcon_data->reg_top_ctrl != REG_LCD_TCON_MAX) {
		reg = lcd_tcon_data->reg_top_ctrl;
		bit = lcd_tcon_data->bit_en;
		lcd_tcon_setb(reg, 0, bit, 1);
	}
}

/* **********************************
 * tcon match data
 * **********************************
 */
static struct lcd_tcon_data_s tcon_data_txhd = {
	.tcon_valid = 0,

	.core_reg_width = LCD_TCON_CORE_REG_WIDTH_TXHD,
	.reg_table_len = LCD_TCON_TABLE_LEN_TXHD,

	.reg_top_ctrl = TCON_TOP_CTRL,
	.bit_en = BIT_TOP_EN_TXHD,

	.reg_core_od = REG_CORE_OD_TXHD,
	.bit_od_en = BIT_OD_EN_TXHD,

	.reg_core_ctrl_timing_base = REG_CORE_CTRL_TIMING_BASE_TXHD,
	.ctrl_timing_offset = CTRL_TIMING_OFFSET_TXHD,
	.ctrl_timing_cnt = CTRL_TIMING_CNT_TXHD,

	.axi_mem_size = 0x001fe000,
	.reg_table = NULL,

	.tcon_enable = lcd_tcon_enable_txhd,
};

static struct lcd_tcon_data_s tcon_data_tl1 = {
	.tcon_valid = 0,

	.core_reg_width = LCD_TCON_CORE_REG_WIDTH_TL1,
	.reg_table_len = LCD_TCON_TABLE_LEN_TL1,

	.reg_top_ctrl = TCON_TOP_CTRL,
	.bit_en = BIT_TOP_EN_TL1,

	.reg_core_od = REG_LCD_TCON_MAX,
	.bit_od_en = BIT_OD_EN_TL1,

	.reg_core_ctrl_timing_base = REG_CORE_CTRL_TIMING_BASE_TL1,
	.ctrl_timing_offset = CTRL_TIMING_OFFSET_TL1,
	.ctrl_timing_cnt = CTRL_TIMING_CNT_TL1,

	.axi_mem_size = 0x009d0000,
	.reg_table = NULL,

	.tcon_enable = lcd_tcon_enable_tl1,
};

int lcd_tcon_probe(char *dt_addr, struct aml_lcd_drv_s *lcd_drv, int load_id)
{
	int ret = 0;
	struct lcd_config_s *pconf = lcd_drv->lcd_config;

	LCDPR("%s\n", __func__);

	lcd_tcon_data = NULL;
	switch (lcd_drv->chip_type) {
	case LCD_CHIP_TXHD:
		switch (pconf->lcd_basic.lcd_type) {
		case LCD_MLVDS:
			lcd_tcon_data = &tcon_data_txhd;
			lcd_tcon_data->tcon_valid = 1;
			break;
		default:
			break;
		}
		break;
	case LCD_CHIP_TL1:
		switch (pconf->lcd_basic.lcd_type) {
		case LCD_MLVDS:
		case LCD_P2P:
			lcd_tcon_data = &tcon_data_tl1;
			lcd_tcon_data->tcon_valid = 1;
			break;
		default:
			break;
		}
		break;
	default:
		break;
	}
	if (lcd_tcon_data == NULL)
		return 0;

	ret = lcd_tcon_config(dt_addr, pconf, load_id);

	return ret;
}

