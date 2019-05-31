/*
 * drivers/display/lcd/aml_lcd_unifykey.c
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
#include <asm/arch/gpio.h>
#ifdef CONFIG_OF_LIBFDT
#include <libfdt.h>
#endif
#include <amlogic/keyunify.h>
#include <amlogic/aml_lcd.h>
#include "aml_lcd_reg.h"
#include "aml_lcd_common.h"
#ifdef CONFIG_UNIFY_KEY_MANAGE
#include "aml_lcd_tcon_ref.h"
#endif

#define LCD_UNIFYKEY_TEST
#define LCDUKEY(fmt, args...)     printf("lcd ukey: "fmt"", ## args)
#define LCDUKEYERR(fmt, args...)     printf("lcd ukey err: "fmt"", ## args)

#ifdef CONFIG_UNIFY_KEY_MANAGE
int aml_lcd_unifykey_len_check(int key_len, int len)
{
	if (key_len < len) {
		LCDUKEYERR("invalid unifykey length %d, need %d\n", key_len, len);
		return -1;
	}
	return 0;
}

int aml_lcd_unifykey_header_check(unsigned char *buf, struct aml_lcd_unifykey_header_s *header)
{
	header->crc32 = (buf[0] | (buf[1] << 8) | (buf[2] << 16) | (buf[3] << 24));
	header->data_len = (buf[4] | (buf[5] << 8));
	header->version = (buf[6] | (buf[7] << 8));
	header->reserved = (buf[8] | (buf[9] << 8));

	return 0;
}

int aml_lcd_unifykey_check(const char *key_name)
{
	ssize_t key_size;
	int key_exist, isSecure, key_len;
	unsigned char *buf;
	struct aml_lcd_unifykey_header_s key_header;
	int retry_cnt = 0;
	uint32_t key_crc;
	unsigned int key_crc32;
	int ret;

	key_size = 0;
	key_exist = 0;
	ret = key_unify_query_exist(key_name, &key_exist);
	if (ret) {
		if (lcd_debug_print_flag)
			LCDUKEYERR("%s query exist error\n", key_name);
		return -1;
	}
	if (key_exist == 0) {
		if (lcd_debug_print_flag)
			LCDUKEYERR("%s is not exist\n", key_name);
		return -1;
	}
	ret = key_unify_query_secure(key_name, &isSecure);
	if (ret) {
		LCDUKEYERR("%s query secure error\n", key_name);
		return -1;
	}
	if (isSecure) {
		LCDUKEYERR("%s is secure key\n", key_name);
		return -1;
	}
	ret = key_unify_query_size(key_name, &key_size);
	if (ret) {
		LCDUKEYERR("%s query size error\n", key_name);
		return -1;
	}
	key_len = (int)key_size;
	if (key_len == 0) {
		if (lcd_debug_print_flag)
			LCDUKEY("%s size is zero\n", key_name);
		return -1;
	}
	if (lcd_debug_print_flag)
		LCDUKEY("%s size: %d\n", key_name, key_len);

lcd_unifykey_read:
	buf = (unsigned char *)malloc(sizeof(unsigned char) * key_len);
	if (!buf) {
		LCDERR("%s: Not enough memory\n", __func__);
		return -1;
	}
	ret = key_unify_read(key_name, buf, key_len);
	if (ret) {
		LCDUKEYERR("%s unify read error\n", key_name);
		return -1;
	}

	/* check header */
	if (key_len <= LCD_UKEY_HEAD_SIZE) {
		LCDUKEYERR("%s unify key_len %d error\n", key_name, key_len);
		return -1;
	}
	aml_lcd_unifykey_header_check(buf, &key_header);
	if (key_len != key_header.data_len) {  //length check
		if (lcd_debug_print_flag) {
			LCDUKEYERR("data_len %d is not match key_len %d\n",
				key_header.data_len, key_len);
		}
		if (retry_cnt < LCD_UKEY_RETRY_CNT_MAX) {
			retry_cnt++;
			goto lcd_unifykey_read;
		} else {
			LCDUKEYERR("%s: load unifykey failed\n", key_name);
			return -1;
		}
	}
	key_crc = crc32(0, &buf[4], (key_len - 4)); //except crc32
	key_crc32 = (unsigned int)key_crc;
	if (key_crc32 != key_header.crc32) {  //crc32 check
		if (lcd_debug_print_flag) {
			LCDUKEYERR("crc32 0x%08x is not match 0x%08x\n",
				key_header.crc32, key_crc32);
		}
		if (retry_cnt < LCD_UKEY_RETRY_CNT_MAX) {
			retry_cnt++;
			goto lcd_unifykey_read;
		} else {
			LCDUKEYERR("%s: load unifykey failed\n", key_name);
			return -1;
		}
	}

	return 0;
}

int aml_lcd_unifykey_get(const char *key_name, unsigned char *buf, int *len)
{
	ssize_t key_size;
	int key_len;
	int ret;

	key_size = 0;
	ret = aml_lcd_unifykey_check(key_name);
	if (ret)
		return -1;
	ret = key_unify_query_size(key_name, &key_size);
	key_len = (int)key_size;
	if (key_len > *len) {
		LCDUKEYERR("%s size(%d) is bigger than buf_size(%d)\n",
			key_name, key_len, *len);
		return -1;
	}
	*len = key_len;

	ret = key_unify_read(key_name, buf, key_len);
	if (ret) {
		LCDUKEYERR("%s unify read error\n", key_name);
		return -1;
	}
	return 0;
}

int aml_lcd_unifykey_check_no_header(const char *key_name)
{
	ssize_t key_size;
	int key_exist, isSecure, key_len;
	int ret;

	key_size = 0;
	key_exist = 0;
	ret = key_unify_query_exist(key_name, &key_exist);
	if (ret) {
		if (lcd_debug_print_flag)
			LCDUKEYERR("%s query exist error\n", key_name);
		return -1;
	}
	if (key_exist == 0) {
		if (lcd_debug_print_flag)
			LCDUKEYERR("%s is not exist\n", key_name);
		return -1;
	}
	ret = key_unify_query_secure(key_name, &isSecure);
	if (ret) {
		LCDUKEYERR("%s query secure error\n", key_name);
		return -1;
	}
	if (isSecure) {
		LCDUKEYERR("%s is secure key\n", key_name);
		return -1;
	}
	ret = key_unify_query_size(key_name, &key_size);
	if (ret) {
		LCDUKEYERR("%s query size error\n", key_name);
		return -1;
	}
	key_len = (int)key_size;
	if (key_len == 0) {
		if (lcd_debug_print_flag)
			LCDUKEY("%s size is zero\n", key_name);
		return -1;
	}
	if (lcd_debug_print_flag)
		LCDUKEY("%s size: %d\n", key_name, key_len);

	return 0;
}

int aml_lcd_unifykey_get_no_header(const char *key_name, unsigned char *buf, int *len)
{
	ssize_t key_size;
	int key_len;
	int ret;

	key_size = 0;
	ret = aml_lcd_unifykey_check_no_header(key_name);
	if (ret)
		return -1;
	ret = key_unify_query_size(key_name, &key_size);
	key_len = (int)key_size;
	if (key_len > *len) {
		LCDUKEYERR("%s size(%d) is bigger than buf_size(%d)\n",
			key_name, key_len, *len);
		return -1;
	}
	*len = key_len;

	ret = key_unify_read(key_name, buf, key_len);
	if (ret) {
		LCDUKEYERR("%s unify read error\n", key_name);
		return -1;
	}
	return 0;
}

#ifdef LCD_UNIFYKEY_TEST
static void aml_lcd_test_unifykey(void)
{
	int len;
	unsigned char buf[204];
	const char *str;
	int i, n;
	uint32_t key_crc;
	unsigned int key_crc32;

	/* basic: 36byte(10~45) */
	str = "lcd_unifykey_test";
	n = strlen(str);
	strcpy((char *)(&buf[10]), str);
	buf[10+n] = '\0';
	buf[39] = '\0';
	buf[40] = 2; /* interface */
	buf[41] = 10; /* lcd bits */
	buf[42] = 16;  /* screen width bit[7:0] */
	buf[43] = 0;   /* screen width bit[15:8] */
	buf[44] = 9;   /* screen height bit[7:0] */
	buf[45] = 0;   /* screen height bit[15:8] */

	/* timing: 18byte(46~63) */
	buf[46] = 0x00; /* h active bit[7:0] */ /* 3840 */
	buf[47] = 0x0f; /* h active bit[15:8] */
	buf[48] = 0x70; /* v active bit[7:0] */ /* 2160 */
	buf[49] = 0x08; /* v active bit[15:8] */
	buf[50] = 0x30; /* h period bit[7:0] */ /* 4400 */
	buf[51] = 0x11; /* h period bit[15:8] */
	buf[52] = 0xca; /* v period bit[7:0] */ /* 2250 */
	buf[53] = 0x08; /* v period bit[15:8] */
	buf[54] = 33;   /* hs width bit[7:0] */
	buf[55] = 0;    /* hs width bit[15:8] */
	buf[56] = 0xdd;  /* hs bp bit[7:0] */  /* 477 */
	buf[57] = 0x01;  /* hs bp bit[15:8] */
	buf[58] = 0;    /* hs pol */
	buf[59] = 6;    /* vs width bit[7:0] */
	buf[60] = 0;    /* vs width bit[15:8] */
	buf[61] = 65;   /* vs bp bit[7:0] */
	buf[62] = 0;    /* vs bp bit[15:8] */
	buf[63] = 0;    /* hs pol */

	/* customer: 31byte(64~94) */
	buf[64] = 2;   /* fr_adj_type */
	buf[65] = 0;   /* ss_level */
	buf[66] = 1;   /* clk_auto_gen */
	buf[67] = 0;   /* pclk bit[7:0] */
	buf[68] = 0;   /* pclk bit[15:8] */
	buf[69] = 0;   /* pclk bit[23:16] */
	buf[70] = 0;   /* pclk bit[31:24] */
	for (i = 71; i < 95; i++)
		buf[i] = 0;
#if 1 /* v2 */
	/* interface: 20byte(95~114) */
	buf[95] = 8;  /* vx1_lane_count bit[7:0] */
	buf[96] = 0;  /* vx1_lane_count bit[15:8] */
	buf[97] = 2;  /* vx1_region_num bit[7:0] */
	buf[98] = 0;  /* vx1_region_num bit[15:8] */
	buf[99] = 4;  /* vx1_byte_mode bit[7:0] */
	buf[100] = 0;  /* vx1_byte_mode bit[15:8] */
	buf[101] = 4;  /* vx1_color_fmt bit[7:0] */
	buf[102] = 0;  /* vx1_color_fmt bit[15:8] */
	buf[103] = 1;  /* vx1_intr_en bit[7:0] */
	buf[104] = 0;  /* vx1_intr_en bit[15:8] */
	buf[105] = 1;  /* vx1_vsync_intr_en bit[7:0] */
	buf[106] = 0;  /* vx1_vsync_intr_en bit[15:8] */
	for (i = 107; i < 115; i++)
		buf[i] = 0;

	/* ctrl: 44byte(115~158) */
	buf[115] = 0x10;  /* ctrl_flag bit[7:0] */
	buf[116] = 0;  /* ctrl_flag bit[15:8] */
	buf[117] = 0;  /* ctrl_flag bit[7:0] */
	buf[118] = 0;  /* ctrl_flag bit[15:8] */
	buf[119] = 0;  /* vx1_power_on_sw_reset_delay bit[7:0] */
	buf[120] = 0;  /* vx1_power_on_sw_reset_delay bit[15:8] */
	buf[121] = 10;  /* vx1_filter_time bit[7:0] */
	buf[122] = 0;  /* vx1_filter_time bit[15:8] */
	buf[123] = 6;  /* vx1_filter_cnt bit[7:0] */
	buf[124] = 0;  /* vx1_filter_cnt bit[15:8] */
	buf[125] = 2;  /* vx1_filter_retry_cnt bit[7:0] */
	buf[126] = 0;  /* vx1_filter_retry_cnt bit[15:8] */
	buf[127] = 100;  /* vx1_filter_retry_delay bit[7:0] */
	buf[128] = 0;  /* vx1_filter_retry_delay bit[15:8] */
	buf[129] = 20;  /* vx1_filter_cdr_detect_time bit[7:0] */
	buf[130] = 0;  /* vx1_filter_cdr_detect_time bit[15:8] */
	buf[131] = 100;  /* vx1_filter_cdr_detect_cnt bit[7:0] */
	buf[132] = 0;  /* vx1_filter_cdr_detect_cnt bit[15:8] */
	buf[133] = 100;  /* vx1_filter_cdr_timeout_cnt bit[7:0] */
	buf[134] = 0;  /* vx1_filter_cdr_timeout_cnt bit[15:8] */
	buf[125] = 10;  /* vx1_hpd_lockn_delay bit[7:0] */
	buf[136] = 0;  /* vx1_hpd_lockn_delay bit[15:8] */
	buf[137] = 0;  /* vx1_cdr_training_delay bit[7:0] */
	buf[138] = 0;  /* vx1_cdr_training_delay bit[15:8] */
	for (i = 139; i < 159; i++)
		buf[i] = 0;

	/* phy: 10byte(159~168) */
	buf[159] = 3;  /* phy_vswing_level */
	buf[160] = 1;  /* phy_preem_level */
	buf[161] = 0;  /* phy_clk_vswing_level */
	buf[162] = 0;  /* phy_clk_preem_level */
	for (i = 163; i < 169; i++)
		buf[i] = 0;

	/* power */
	buf[169] = 0;     /* power_on: type */
	buf[170] = 0;     /* power_on: index */
	buf[171] = 1;     /* power_on: val */
	buf[172] = 20;    /* power_on: delay bit[7:0] */
	buf[173] = 0;     /* power_on: delay bit[15:8] */
	buf[174] = 2;     /* power_on: type */
	buf[175] = 0;     /* power_on: index */
	buf[176] = 0;     /* power_on: val */
	buf[177] = 10;    /* power_on: delay bit[7:0] */
	buf[178] = 0;     /* power_on: delay bit[15:8] */
	buf[179] = 3;     /* power_on: type */
	buf[180] = 0;     /* power_on: index */
	buf[181] = 0;     /* power_on: val */
	buf[182] = 10;    /* power_on: delay bit[7:0] */
	buf[183] = 0;     /* power_on: delay bit[15:8] */
	buf[184] = 0xff;  /* power_on: type */
	buf[185] = 0;     /* power_on: index */
	buf[186] = 0;     /* power_on: val */
	buf[187] = 0;     /* power_on: delay bit[7:0] */
	buf[188] = 0;     /* power_on: delay bit[15:8] */
	buf[189] = 2;     /* power_off: type */
	buf[190] = 0;     /* power_off: index */
	buf[191] = 0;     /* power_off: val */
	buf[192] = 20;    /* power_off: delay bit[7:0] */
	buf[193] = 0;     /* power_off: delay bit[15:8] */
	buf[194] = 0;     /* power_off: type */
	buf[195] = 0;     /* power_off: index */
	buf[196] = 0;     /* power_off: val */
	buf[197] = 100;   /* power_off: delay bit[7:0] */
	buf[198] = 0;     /* power_off: delay bit[15:8] */
	buf[199] = 0xff;  /* power_off: type */
	buf[200] = 0;     /* power_off: index */
	buf[201] = 0;     /* power_off: val */
	buf[202] = 0;     /* power_off: delay bit[7:0] */
	buf[203] = 0;     /* power_off: delay bit[15:8] */

	len = 204;//10 + 36 + 18 + 31 + 20 + 44 + 10 + 35;
	/* header */
	buf[4] = (len & 0xff);   /* data_len */
	buf[5] = ((len >> 8) & 0xff);
	buf[6] = 2;   /* version */
	buf[7] = 0;
	buf[8] = 0;   /* reserved */
	buf[9] = 0;
#else  /* v1 */
	/* interface: 20byte(95~114) */
	buf[95] = 8;  /* vx1_lane_count bit[7:0] */
	buf[96] = 0;  /* vx1_lane_count bit[15:8] */
	buf[97] = 2;  /* vx1_region_num bit[7:0] */
	buf[98] = 0;  /* vx1_region_num bit[15:8] */
	buf[99] = 4;  /* vx1_byte_mode bit[7:0] */
	buf[100] = 0;  /* vx1_byte_mode bit[15:8] */
	buf[101] = 4;  /* vx1_color_fmt bit[7:0] */
	buf[102] = 0;  /* vx1_color_fmt bit[15:8] */
	buf[103] = 3;  /* phy_vswing_level bit[7:0] */
	buf[104] = 0;  /* phy_vswing_level bit[15:8] */
	buf[105] = 1;  /* phy_preem_level bit[7:0] */
	buf[106] = 0;  /* phy_preem_level bit[15:8] */
	buf[107] = 1;  /* vbyone_intr_en bit[7:0] */
	buf[108] = 0;  /* vbyone_intr_en bit[15:8] */
	buf[109] = 1;  /* vbyone_vsync_intr_en bit[7:0] */
	buf[110] = 0;  /* vbyone_vsync_intr_en bit[15:8] */
	for (i = 111; i < 115; i++)
		buf[i] = 0;

	/* power */
	buf[115] = 0;	  /* power_on: type */
	buf[116] = 0;	  /* power_on: index */
	buf[117] = 1;	  /* power_on: val */
	buf[118] = 20;	  /* power_on: delay bit[7:0] */
	buf[119] = 0;	  /* power_on: delay bit[15:8] */
	buf[120] = 2;	  /* power_on: type */
	buf[121] = 0;	  /* power_on: index */
	buf[122] = 0;	  /* power_on: val */
	buf[123] = 10;	  /* power_on: delay bit[7:0] */
	buf[124] = 0;	  /* power_on: delay bit[15:8] */
	buf[125] = 3;	  /* power_on: type */
	buf[126] = 0;	  /* power_on: index */
	buf[127] = 0;	  /* power_on: val */
	buf[128] = 10;	  /* power_on: delay bit[7:0] */
	buf[129] = 0;	  /* power_on: delay bit[15:8] */
	buf[130] = 0xff;  /* power_on: type */
	buf[131] = 0;	  /* power_on: index */
	buf[132] = 0;	  /* power_on: val */
	buf[133] = 0;	  /* power_on: delay bit[7:0] */
	buf[134] = 0;	  /* power_on: delay bit[15:8] */
	buf[135] = 2;	  /* power_off: type */
	buf[136] = 0;	  /* power_off: index */
	buf[137] = 0;	  /* power_off: val */
	buf[138] = 20;	  /* power_off: delay bit[7:0] */
	buf[139] = 0;	  /* power_off: delay bit[15:8] */
	buf[140] = 0;	  /* power_off: type */
	buf[141] = 0;	  /* power_off: index */
	buf[142] = 0;	  /* power_off: val */
	buf[143] = 100;   /* power_off: delay bit[7:0] */
	buf[144] = 0;	  /* power_off: delay bit[15:8] */
	buf[145] = 0xff;  /* power_off: type */
	buf[146] = 0;	  /* power_off: index */
	buf[147] = 0;	  /* power_off: val */
	buf[148] = 0;	  /* power_off: delay bit[7:0] */
	buf[149] = 0;	  /* power_off: delay bit[15:8] */

	len = 150;//10 + 36 + 18 + 31 + 20 + 44 + 10 + 35;
	/* header */
	buf[4] = (len & 0xff);	 /* data_len */
	buf[5] = ((len >> 8) & 0xff);
	buf[6] = 1;   /* version */
	buf[7] = 0;
	buf[8] = 0;   /* reserved */
	buf[9] = 0;
#endif
	key_crc = crc32(0, &buf[4], (len - 4)); //except crc32
	key_crc32 = (unsigned int)key_crc;
	for (i = 0; i < 4; i++)
		buf[i] = (unsigned char)((key_crc32 >> (i * 8)) & 0xff);

	key_unify_write("lcd", buf, len);
}

static void aml_lcd_extern_test_unifykey(void)
{
	int len;
	unsigned char buf[99];
	const char *str;
	int i, n;
	uint32_t key_crc;
	unsigned int key_crc32;

	/* basic: 33byte(10~42) */
	str = "lcd_extern_unifykey_test";
	n = strlen(str);
	strcpy((char *)(&buf[10]), str);
	buf[10+n] = '\0';
	buf[39] = '\0';
	buf[40] = 0; /* index */
	buf[41] = 0; /* type */
	buf[42] = 1;  /* status */

	/* type: 10byte(43~52) */
	buf[43] = 0x1c; /* i2c_addr */
	buf[44] = 0xff; /* i2c_second_addr */
	buf[45] = 0x1; /* i2c_bus */

#if 0 /* init_table_dynamic_size */
	buf[46] = 0xff; /* cmd_size */
	for (i = 47; i < 53; i++)
		buf[i] = 0;

	/* init */
	buf[53] = 0x10;
	buf[54] = 0x07;
	buf[55] = 0x01;
	buf[56] = 0x02;
	buf[57] = 0x00;
	buf[58] = 0x40;
	buf[59] = 0xff;
	buf[60] = 0x00;
	buf[61] = 0x00;  //init step 1
	buf[62] = 0x10;
	buf[63] = 0x03;
	buf[64] = 0x02;
	buf[65] = 0x00;
	buf[66] = 0x40;	//init step 2
	buf[67] = 0x00;
	buf[68] = 0x05;
	buf[69] = 0x73;
	buf[70] = 0x0a;
	buf[71] = 0x01;
	buf[72] = 0x00;
	buf[73] = 0x00;	//init step 3
	buf[74] = 0x00;
	buf[75] = 0x02;
	buf[76] = 0x06;
	buf[77] = 0x08;	//init step 4
	buf[78] = 0xff;
	buf[79] = 0x00;  //init_on ending
	buf[80] = 0x10;
	buf[81] = 0x02;
	buf[82] = 0x30;
	buf[83] = 0x40;  //init_off 1
	buf[84] = 0x10;
	buf[85] = 0x06;
	buf[86] = 0x70;
	buf[87] = 0x80;
	buf[88] = 0x90;  //init_off 2
	buf[89] = 0xff;
	buf[90] = 0x00;
	buf[91] = 0x00;	//init_off 3
	buf[92] = 0x00;
	buf[93] = 0x02;
	buf[94] = 0x09;
	buf[95] = 0x0a;	//init_off 4
	buf[96] = 0xff;
	buf[97] = 0x00;  //init_off ending
#else /* init_table_fixed_size */
	buf[46] = 0x9; /* cmd_size */
	for (i = 47; i < 53; i++)
		buf[i] = 0;

	/* init */
	buf[53] = 0x10;
	buf[54] = 0x20;
	buf[55] = 0x01;
	buf[56] = 0x02;
	buf[57] = 0x00;
	buf[58] = 0x40;
	buf[59] = 0xff;
	buf[60] = 0x00;
	buf[61] = 0x00;  //init step 1
	buf[62] = 0x10;
	buf[63] = 0x80;
	buf[64] = 0x02;
	buf[65] = 0x00;
	buf[66] = 0x40;
	buf[67] = 0x62;
	buf[68] = 0x51;
	buf[69] = 0x73;
	buf[70] = 0x0a;  //init step 2
	buf[71] = 0xff;
	buf[72] = 0x00;
	buf[73] = 0x00;
	buf[74] = 0x00;
	buf[75] = 0x00;
	buf[76] = 0x00;
	buf[77] = 0x00;
	buf[78] = 0x00;
	buf[79] = 0x00;  //init_on ending
	buf[80] = 0x10;
	buf[81] = 0x20;
	buf[82] = 0x30;
	buf[83] = 0x40;
	buf[84] = 0x50;
	buf[85] = 0x60;
	buf[86] = 0x70;
	buf[87] = 0x80;
	buf[88] = 0x90;  //init_off
	buf[89] = 0xff;
	buf[90] = 0x00;
	buf[91] = 0x00;
	buf[92] = 0x00;
	buf[93] = 0x00;
	buf[94] = 0x00;
	buf[95] = 0x00;
	buf[96] = 0x00;
	buf[97] = 0x00;  //init_off ending
#endif

	len = 10 + 33 + 10 + 5*9;
	/* header */
	buf[4] = (len & 0xff);   /* data_len */
	buf[5] = ((len >> 8) & 0xff);
	buf[6] = 1;   /* version */
	buf[7] = 0;
	buf[8] = 0;   /* reserved */
	buf[9] = 0;
	key_crc = crc32(0, &buf[4], (len - 4)); //except crc32
	key_crc32 = (unsigned int)key_crc;
	for (i = 0; i < 4; i++)
		buf[i] = (unsigned char)((key_crc32 >> (i * 8)) & 0xff);

	key_unify_write("lcd_extern", buf, len);
}

static void aml_bl_test_unifykey(void)
{
	int len;
	unsigned char buf[102];
	const char *str;
	int i, n;
	uint32_t key_crc;
	unsigned int key_crc32;

	/* basic: 30byte(10~39) */
	str = "backlight_unifykey_test";
	n = strlen(str);
	strcpy((char *)(&buf[10]), str);
	buf[10+n] = '\0';
	buf[39] = '\0';

	/* level: 12byte(40~51) */
	buf[40] = 128; /* level uboot */
	buf[41] = 0;
	buf[42] = 128; /* level kernel */
	buf[43] = 0;
	buf[44] = 255; /* level max */
	buf[45] = 0;
	buf[46] = 10;  /* level min */
	buf[47] = 0;
	buf[48] = 128; /* level mid */
	buf[49] = 0;
	buf[50] = 128; /* level mid mapping */
	buf[51] = 0;
#if 1
	/* method: 8byte(52~59) */
	buf[52] = 1;   /* bl method */
	buf[53] = 0;   /* bl enable gpio */
	buf[54] = 1;   /* bl enable gpio on */
	buf[55] = 0;   /* bl enable gpio off */
	buf[56] = 200; /* power on delay bit[7:0] */
	buf[57] = 0;   /* power on delay bit[15:8] */
	buf[58] = 30;  /* power off delay bit[7:0] */
	buf[59] = 0;   /* power off delay bit[15:8] */

	/* pwm: 32byte(60~91) */
	buf[60] = 10;  /* pwm on delay bit[15:8] */
	buf[61] = 0;   /* pwm on delay bit[15:8] */
	buf[62] = 10;  /* pwm off delay bit[15:8] */
	buf[63] = 0;   /* pwm off delay bit[15:8] */

	buf[64] = 1;   /* pwm method */
	buf[65] = 3;   /* pwm port */
	buf[66] = 180; /* pwm freq bit[7:0] */
	buf[67] = 0;   /* pwm freq bit[15:8] */
	buf[68] = 0;   /* pwm freq bit[23:16] */
	buf[69] = 0;   /* pwm freq bit[31:24] */
	buf[70] = 100; /* pwm duty max */
	buf[71] = 25;  /* pwm duty min */
	buf[72] = 1;   /* pwm gpio */
	buf[73] = 0;   /* pwm gpio off */
	for (i = 74; i < 84; i++)  /* pwm2 for pwm_combo */
		buf[i] = 0;

	for (i = 84; i < 92; i++)  /* pwm/pwm2_level_range for pwm_combo */
		buf[i] = 0;
#else
	/* method: 8byte(52~59) */
	buf[52] = 2;   /* bl method */
	buf[53] = 0;   /* bl enable gpio */
	buf[54] = 1;   /* bl enable gpio on */
	buf[55] = 0;   /* bl enable gpio off */
	buf[56] = 0xf2; /* power on delay bit[7:0] */
	buf[57] = 0x03;   /* power on delay bit[15:8] */
	buf[58] = 0x6e;  /* power off delay bit[7:0] */
	buf[59] = 0;   /* power off delay bit[15:8] */

	/* pwm: 32byte(60~91) */
	buf[60] = 10;  /* pwm on delay bit[15:8] */
	buf[61] = 0;   /* pwm on delay bit[15:8] */
	buf[62] = 10;  /* pwm off delay bit[15:8] */
	buf[63] = 0;   /* pwm off delay bit[15:8] */

	buf[64] = 1;   /* pwm method */
	buf[65] = 1;   /* pwm port */
	buf[66] = 180; /* pwm freq bit[7:0] */
	buf[67] = 0;   /* pwm freq bit[15:8] */
	buf[68] = 0;   /* pwm freq bit[23:16] */
	buf[69] = 0;   /* pwm freq bit[31:24] */
	buf[70] = 100; /* pwm duty max */
	buf[71] = 25;  /* pwm duty min */
	buf[72] = 1;   /* pwm gpio */
	buf[73] = 0;   /* pwm gpio off */

	buf[74] = 1;   /* pwm2 method */
	buf[75] = 2;   /* pwm2 port */
	buf[76] = 0x50; /* pwm2 freq bit[7:0] */
	buf[77] = 0x46;   /* pwm2 freq bit[15:8] */
	buf[78] = 0;   /* pwm2 freq bit[23:16] */
	buf[79] = 0;   /* pwm2 freq bit[31:24] */
	buf[80] = 100; /* pwm2 duty max */
	buf[81] = 20;  /* pwm2 duty min */
	buf[82] = 2;   /* pwm2 gpio */
	buf[83] = 0;   /* pwm2 gpio off */

	buf[84] = 50;
	buf[85] = 0;
	buf[86] = 10;
	buf[87] = 0;
	buf[88] = 255;
	buf[89] = 0;
	buf[90] = 50;
	buf[91] = 0;
#endif
	/* customer: 10byte(92~101) */
	for (i = 92; i < 102; i++)
		buf[i] = 0;

	len = 102;
	/* header */
	buf[4] = (len & 0xff);   /* data_len */
	buf[5] = ((len >> 8) & 0xff);
	buf[6] = 2;   /* version */
	buf[7] = 0;
	buf[8] = 0;   /* reserved */
	buf[9] = 0;
	key_crc = crc32(0, &buf[4], (len - 4)); //except crc32
	key_crc32 = (unsigned int)key_crc;
	for (i = 0; i < 4; i++)
		buf[i] = (unsigned char)((key_crc32 >> (i * 8)) & 0xff);

	key_unify_write("backlight", buf, len);
}

static void aml_lcd_tcon_test_unifykey(int n)
{
	int len;
	unsigned char *buf;

	switch (n) {
	case 768:
		buf = &tcon_boe_hd_hsd_n56_1366x768[0];
		len = sizeof(tcon_boe_hd_hsd_n56_1366x768);
		break;
	case 1080:
		buf = &tcon_boe_fhd_goa_n10_1920x1080[0];
		len = sizeof(tcon_boe_fhd_goa_n10_1920x1080);
		break;
	case 2160:
		buf = &uhd_tcon_setting_ceds_3840x2160[0];
		len = sizeof(uhd_tcon_setting_ceds_3840x2160);
	default:
		buf = NULL;
		break;
	}

	if (buf)
		key_unify_write("lcd_tcon", buf, len);
	else
		LCDUKEYERR("tcon_test error data\n");
}
#endif

void aml_lcd_unifykey_test(void)
{
#ifdef LCD_UNIFYKEY_TEST
	LCDUKEY("Be Careful!! This test will overwrite lcd unifykeys!!\n");
	aml_lcd_test_unifykey();
	aml_lcd_extern_test_unifykey();
	aml_bl_test_unifykey();
#else
	LCDUKEY("default bypass for lcd unifykey test\n");
	LCDUKEY("should enable macro definition: LCD_UNIFYKEY_TEST\n");
	LCDUKEY("Be Careful!! This test will overwrite lcd unifykeys!!\n");
#endif
}

void aml_lcd_unifykey_tcon_test(int n)
{
#ifdef LCD_UNIFYKEY_TEST
	LCDUKEY("Be Careful!! This test will overwrite lcd_tcon unifykeys!!\n");
	aml_lcd_tcon_test_unifykey(n);
#else
	LCDUKEY("default bypass for lcd unifykey test\n");
	LCDUKEY("should enable macro definition: LCD_UNIFYKEY_TEST\n");
	LCDUKEY("Be Careful!! This test will overwrite lcd unifykeys!!\n");
#endif
}

void aml_lcd_unifykey_dump(int flag)
{
	unsigned char *para;
	int key_len;
	int ret, i;

	/* dump unifykey: lcd */
	para = (unsigned char *)malloc(sizeof(unsigned char) * LCD_UKEY_LCD_SIZE);
	if (!para) {
		LCDUKEYERR("%s: Not enough memory\n", __func__);
		return;
	}
	key_len = LCD_UKEY_LCD_SIZE;
	memset(para, 0, (sizeof(unsigned char) * key_len));
	ret = aml_lcd_unifykey_get("lcd", para, &key_len);
	if (ret == 0) {
		printf("unifykey: lcd:");
		for (i = 0; i < key_len; i++) {
			if ((i % 16) == 0)
				printf("\n%03x0:", (i / 16));
			printf(" %02x", para[i]);
		}
	}
	printf("\n");
	free(para);

	/* dump unifykey: lcd_extern */
	para = (unsigned char *)malloc(sizeof(unsigned char) * LCD_UKEY_LCD_EXT_SIZE);
	if (!para) {
		LCDUKEYERR("%s: Not enough memory\n", __func__);
		return;
	}
	key_len = LCD_UKEY_LCD_EXT_SIZE;
	memset(para, 0, (sizeof(unsigned char) * key_len));
	ret = aml_lcd_unifykey_get("lcd_extern", para, &key_len);
	if (ret == 0) {
		printf("unifykey: lcd_extern:");
		for (i = 0; i < key_len; i++) {
			if ((i % 16) == 0)
				printf("\n%03x0:", (i / 16));
			printf(" %02x", para[i]);
		}
	}
	printf("\n");
	free(para);

	/* dump unifykey: backlight */
	para = (unsigned char *)malloc(sizeof(unsigned char) * LCD_UKEY_BL_SIZE);
	if (!para) {
		LCDUKEYERR("%s: Not enough memory\n", __func__);
		return;
	}
	key_len = LCD_UKEY_BL_SIZE;
	memset(para, 0, (sizeof(unsigned char) * key_len));
	ret = aml_lcd_unifykey_get("backlight", para, &key_len);
	if (ret == 0) {
		printf("unifykey: backlight:");
		for (i = 0; i < key_len; i++) {
			if ((i % 16) == 0)
				printf("\n%03x0:", (i / 16));
			printf(" %02x", para[i]);
		}
	}
	printf("\n");
	free(para);

	if ((flag & LCD_UKEY_DEBUG_TCON) == 0)
		return;
	/* dump unifykey: lcd_tcon */
	para = (unsigned char *)malloc(sizeof(unsigned char) * LCD_UKEY_TCON_SIZE);
	if (!para) {
		LCDUKEYERR("%s: Not enough memory\n", __func__);
		return;
	}
	key_len = LCD_UKEY_TCON_SIZE;
	memset(para, 0, (sizeof(unsigned char) * key_len));
	ret = aml_lcd_unifykey_get_no_header("lcd_tcon", para, &key_len);
	if (ret == 0) {
		printf("unifykey: lcd_tcon:");
		for (i = 0; i < key_len; i++) {
			if ((i % 16) == 0)
				printf("\n%03x0:", (i / 16));
			printf(" %02x", para[i]);
		}
	}
	printf("\n");
	free(para);
}

#else
/* dummy driver */
int aml_lcd_unifykey_len_check(int key_len, int len)
{
	LCDUKEYERR("Don't support unifykey\n");
	return -1;
}

int aml_lcd_unifykey_header_check(unsigned char *buf, struct aml_lcd_unifykey_header_s *header)
{
	LCDUKEYERR("Don't support unifykey\n");
	return -1;
}

int aml_lcd_unifykey_check(const char *key_name)
{
	LCDUKEYERR("Don't support unifykey\n");
	return -1;
}

int aml_lcd_unifykey_get(const char *key_name, unsigned char *buf, int *len)
{
	LCDUKEYERR("Don't support unifykey\n");
	return -1;
}

int aml_lcd_unifykey_check_no_header(const char *key_name)
{
	LCDUKEYERR("Don't support unifykey\n");
	return -1;
}

int aml_lcd_unifykey_get_no_header(const char *key_name, unsigned char *buf, int *len)
{
	LCDUKEYERR("Don't support unifykey\n");
	return -1;
}

void aml_lcd_unifykey_test(void)
{
	LCDUKEYERR("Don't support unifykey\n");
}

void aml_lcd_unifykey_tcon_test(int n)
{
	LCDUKEYERR("Don't support unifykey\n");
}

void aml_lcd_unifykey_dump(int flag)
{
	LCDUKEYERR("Don't support unifykey\n");
}

#endif


