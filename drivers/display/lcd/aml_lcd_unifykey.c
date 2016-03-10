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

/* #define LCD_UNIFYKEY_TEST */
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
	unsigned char buf[550];
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

void aml_lcd_test_unifykey(void)
{
#ifdef LCD_UNIFYKEY_TEST
	int len;
	unsigned char buf[150];
	const char *str;
	int i, n;
	uint32_t key_crc;
	unsigned int key_crc32;

	len = 10 + 105 + 20 + 15;

	/* basic */
	str = "lcd_unifykey_test";
	n = strlen(str);
	strcpy((char *)(&buf[10]), str);
	buf[10+n] = '\0';
	buf[39] = '\0';
	buf[40] = 1; /* interface */
	buf[41] = 8; /* lcd bits */
	buf[42] = 16;  /* screen width bit[7:0] */
	buf[43] = 0;   /* screen width bit[15:8] */
	buf[44] = 9;   /* screen height bit[7:0] */
	buf[45] = 0;   /* screen height bit[15:8] */

	/* timing */
	buf[46] = 0x80; /* h active bit[7:0] */ /* 1920 */
	buf[47] = 0x07; /* h active bit[15:8] */
	buf[48] = 0x38; /* v active bit[7:0] */ /* 1080 */
	buf[49] = 0x04; /* v active bit[15:8] */
	buf[50] = 0x98; /* h period bit[7:0] */ /* 2200 */
	buf[51] = 0x08; /* h period bit[15:8] */
	buf[52] = 0x65; /* v period bit[7:0] */ /* 1125 */
	buf[53] = 0x04; /* v period bit[15:8] */
	buf[54] = 44;   /* hs width bit[7:0] */
	buf[55] = 0;    /* hs width bit[15:8] */
	buf[56] = 148;  /* hs bp bit[7:0] */
	buf[57] = 0;    /* hs bp bit[15:8] */
	buf[58] = 0;    /* hs pol */
	buf[59] = 5;    /* vs width bit[7:0] */
	buf[60] = 0;    /* vs width bit[15:8] */
	buf[61] = 30;   /* vs bp bit[7:0] */
	buf[62] = 0;    /* vs bp bit[15:8] */
	buf[63] = 0;    /* hs pol */

	/* customer */
	buf[64] = 1;   /* fr_adj_type */
	buf[65] = 0;   /* ss_level */
	buf[66] = 1;   /* clk_auto_gen */
	buf[67] = 0;   /* pclk bit[7:0] */
	buf[68] = 0;   /* pclk bit[15:8] */
	buf[69] = 0;   /* pclk bit[23:16] */
	buf[70] = 0;   /* pclk bit[31:24] */
	for (i = 71; i < 95; i++)
		buf[i] = 0;

	/* interface */
	buf[95] = 1;  /* lvds_repack bit[7:0] */
	buf[96] = 0;  /* lvds_repack bit[15:8] */
	buf[97] = 1;  /* lvds_dual_port bit[7:0] */
	buf[98] = 0;  /* lvds_dual_port bit[15:8] */
	buf[99] = 0;  /* lvds_pn_swap bit[7:0] */
	buf[100] = 0;  /* lvds_pn_swap bit[15:8] */
	buf[101] = 0;  /* lvds_port_swap bit[7:0] */
	buf[102] = 0;  /* lvds_port_swap bit[15:8] */
	buf[103] = 3;  /* phy_vswing_level bit[7:0] */
	buf[104] = 0;  /* phy_vswing_level bit[15:8] */
	buf[105] = 0;  /* phy_preem_level bit[7:0] */
	buf[106] = 0;  /* phy_preem_level bit[15:8] */
	for (i = 107; i < 115; i++)
		buf[i] = 0;

	/* power */
	buf[115] = 0;     /* power_on: type */
	buf[116] = 0;     /* power_on: index */
	buf[117] = 1;     /* power_on: val */
	buf[118] = 20;    /* power_on: delay bit[7:0] */
	buf[119] = 0;     /* power_on: delay bit[15:8] */
	buf[120] = 2;     /* power_on: type */
	buf[121] = 0;     /* power_on: index */
	buf[122] = 0;     /* power_on: val */
	buf[123] = 10;    /* power_on: delay bit[7:0] */
	buf[124] = 0;     /* power_on: delay bit[15:8] */
	buf[125] = 3;     /* power_on: type */
	buf[126] = 0;     /* power_on: index */
	buf[127] = 0;     /* power_on: val */
	buf[128] = 10;    /* power_on: delay bit[7:0] */
	buf[129] = 0;     /* power_on: delay bit[15:8] */
	buf[130] = 0xff;  /* power_on: type */
	buf[131] = 0;     /* power_on: index */
	buf[132] = 0;     /* power_on: val */
	buf[133] = 0;     /* power_on: delay bit[7:0] */
	buf[134] = 0;     /* power_on: delay bit[15:8] */
	buf[135] = 2;     /* power_off: type */
	buf[136] = 0;     /* power_off: index */
	buf[137] = 0;     /* power_off: val */
	buf[138] = 20;    /* power_off: delay bit[7:0] */
	buf[139] = 0;     /* power_off: delay bit[15:8] */
	buf[140] = 0;     /* power_off: type */
	buf[141] = 0;     /* power_off: index */
	buf[142] = 0;     /* power_off: val */
	buf[143] = 100;   /* power_off: delay bit[7:0] */
	buf[144] = 0;     /* power_off: delay bit[15:8] */
	buf[145] = 0xff;  /* power_off: type */
	buf[146] = 0;     /* power_off: index */
	buf[147] = 0;     /* power_off: val */
	buf[148] = 0;     /* power_off: delay bit[7:0] */
	buf[149] = 0;     /* power_off: delay bit[15:8] */

	/* header */
	buf[4] = 150;
	buf[5] = 0;   /* data_len */
	buf[6] = 1;
	buf[7] = 0;   /* version */
	buf[8] = 0;
	buf[9] = 0;   /* reserved */
	key_crc = crc32(0, &buf[4], 146); //except crc32
	key_crc32 = (unsigned int)key_crc;
	for (i = 0; i < 4; i++)
		buf[i] = (unsigned char)((key_crc32 >> (i * 8)) & 0xff);

	key_unify_write("lcd", buf, len);
#else
	LCDUKEY("default bypass for lcd unifykey test\n");
	LCDUKEY("should enable macro definition: LCD_UNIFYKEY_TEST\n");
	LCDUKEY("Be Careful!! This test will overwrite lcd unifykey!!\n");
#endif
}

void aml_lcd_extern_test_unifykey(void)
{
#ifdef LCD_UNIFYKEY_TEST
	int len;
	unsigned char buf[90];
	const char *str;
	int i, n;
	uint32_t key_crc;
	unsigned int key_crc32;

	len = 10 + 33 + 10 + 4*9;

	/* basic */
	str = "lcd_extern_unifykey_test";
	n = strlen(str);
	strcpy((char *)(&buf[10]), str);
	buf[10+n] = '\0';
	buf[39] = '\0';
	buf[40] = 0; /* index */
	buf[41] = 0; /* type */
	buf[42] = 1;  /* status */

	/* type */
	buf[43] = 0x1c; /* i2c_addr */
	buf[44] = 0xff; /* i2c_second_addr */
	buf[45] = 0x1; /* i2c_bus */
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
	buf[80] = 0xff;
	buf[81] = 0x00;
	buf[82] = 0x00;
	buf[83] = 0x00;
	buf[84] = 0x00;
	buf[85] = 0x00;
	buf[86] = 0x00;
	buf[87] = 0x00;
	buf[88] = 0x00;  //init_off ending

	/* header */
	buf[4] = 89;
	buf[5] = 0;   /* data_len */
	buf[6] = 1;
	buf[7] = 0;   /* version */
	buf[8] = 0;
	buf[9] = 0;   /* reserved */
	key_crc = crc32(0, &buf[4], 85); //except crc32
	key_crc32 = (unsigned int)key_crc;
	for (i = 0; i < 4; i++)
		buf[i] = (unsigned char)((key_crc32 >> (i * 8)) & 0xff);

	key_unify_write("lcd_extern", buf, len);
#endif
}

void aml_bl_test_unifykey(void)
{
#ifdef LCD_UNIFYKEY_TEST
	int len;
	unsigned char buf[95];
	const char *str;
	int i, n;
	uint32_t key_crc;
	unsigned int key_crc32;

	len = 92;

	/* basic */
	str = "backlight_unifykey_test";
	n = strlen(str);
	strcpy((char *)(&buf[10]), str);
	buf[10+n] = '\0';
	buf[39] = '\0';

	/* level */
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

	/* method */
	buf[52] = 1;   /* bl method */
	buf[53] = 0;   /* bl enable gpio */
	buf[54] = 1;   /* bl enable gpio on */
	buf[55] = 0;   /* bl enable gpio off */
	buf[56] = 200; /* power on delay bit[7:0] */
	buf[57] = 0;   /* power on delay bit[15:8] */
	buf[58] = 30;  /* power off delay bit[7:0] */
	buf[59] = 0;   /* power off delay bit[15:8] */

	/* pwm */
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

	/* header */
	buf[4] = 92;
	buf[5] = 0;   /* data_len */
	buf[6] = 1;
	buf[7] = 0;   /* version */
	buf[8] = 0;
	buf[9] = 0;   /* reserved */
	key_crc = crc32(0, &buf[4], 88); //except crc32
	key_crc32 = (unsigned int)key_crc;
	for (i = 0; i < 4; i++)
		buf[i] = (unsigned char)((key_crc32 >> (i * 8)) & 0xff);

	key_unify_write("backlight", buf, len);
#else
	LCDUKEY("Be Careful!! This test will overwrite backlight unifykey!!\n");
#endif
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

void aml_lcd_test_unifykey(void)
{
	LCDUKEYERR("Don't support unifykey\n");
}

void aml_lcd_extern_test_unifykey(void)
{
	LCDUKEYERR("Don't support unifykey\n");
}

void aml_bl_test_unifykey(void)
{
	LCDUKEYERR("Don't support unifykey\n");
}

#endif


