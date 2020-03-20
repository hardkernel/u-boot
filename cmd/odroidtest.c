/*
 *  (C) Copyright 2019 Hardkernel Co., Ltd
 *
 *  SPDX-License-Identifier:	GPL-2.0+
 */

#include "odroidtest.h"

static int do_odroidtest_all(cmd_tbl_t * cmdtp, int flag,
				int argc, char * const argv[]);

int wait_key_event(void)
{
	struct udevice *dev;
	struct dm_key_uclass_platdata *key;
	int evt;

	while (!ctrlc()) {
		for (uclass_first_device(UCLASS_KEY, &dev);
		     dev;
		     uclass_next_device(&dev)) {
			key = dev_get_uclass_platdata(dev);
			evt = key_read(key->code);

			if (evt == KEY_PRESS_DOWN) {
				printf("'%s [%d]' key pressed...\n",
					key->name, key->code);

				return key->code;
			} else if ((evt == KEY_PRESS_LONG_DOWN)
					&& (key->code == KEY_POWER)) {
				lcd_setbg_color("black");
				lcd_clear();
				lcd_setfg_color("white");
				lcd_printf(0, 10, 1, "Power key pressed... system will shut down.");
				mdelay(500);
				run_command("poweroff", 0);
			}
		}
	}

	return 0;
}

void adc_draw_key_arrays(void)
{
	int i;

	lcd_setbg_color("black");
	lcd_clear();

	lcd_setfg_color("white");
	lcd_printf(0, 1, 1, "[ ADC KEY TEST ]");

	for (i = 0; i < 4; i++) {
		if (adckeys[i].chk)
			lcd_setfg_color("blue");
		else
			lcd_setfg_color("red");

		lcd_printf(adckeys[i].x, adckeys[i].y,
				0, adckeys[i].name);
	}
}

#define ADC_CENTER_CHECK_COUNT	10
int adc_get_center(unsigned int *center_x, unsigned int *center_y)
{
	int i = 0;
	unsigned int val_x, val_y;

	*center_x = 0;
	*center_y = 0;

	while (i < ADC_CENTER_CHECK_COUNT) {
		if (adc_channel_single_shot("saradc", 1, &val_x)) {
			printf("adc_channel_single_shot fail!\n");
			return CMD_RET_FAILURE;
		}

		if (adc_channel_single_shot("saradc", 2, &val_y)) {
			printf("adc_channel_single_shot fail!\n");
			return CMD_RET_FAILURE;
		}

		*center_x += val_x;
		*center_y += val_y;

		mdelay(50);
		i++;
	}

	*center_x /= ADC_CENTER_CHECK_COUNT;
	*center_y /= ADC_CENTER_CHECK_COUNT;

	return CMD_RET_SUCCESS;
}

#define ADC_CHECK_OFFSET	100
static int do_odroidtest_adc(cmd_tbl_t * cmdtp, int flag,
				int argc, char * const argv[])
{
	struct udevice *dev;
	unsigned int val_x, val_y;
	unsigned int center_x, center_y;
	int adc_passed = 0;
	int i;

	if (uclass_get_device(UCLASS_ADC, 0, &dev))
		return CMD_RET_FAILURE;

	if (adc_get_center(&center_x, &center_y))
		return CMD_RET_FAILURE;

	adc_draw_key_arrays();

	while (adc_passed < 4) {
		/* XOUT */
		if (adc_channel_single_shot("saradc", 1, &val_x)) {
			printf("adc_channel_single_shot fail!\n");
			return CMD_RET_FAILURE;
		}

		/* YOUT */
		if (adc_channel_single_shot("saradc", 2, &val_y)) {
			printf("adc_channel_single_shot fail!\n");
			return CMD_RET_FAILURE;
		}

		printf("center x %d y %d / value x %d, y %d\n",
			center_x, center_y, val_x, val_y);

		/* LEFT */
		if (val_x > center_x + ADC_CHECK_OFFSET) {
			if (!adckeys[0].chk) {
				adckeys[0].chk = 1;
				adc_draw_key_arrays();
				adc_passed++;
			}
		/* RIGHT */
		} else if (val_x < center_x - ADC_CHECK_OFFSET) {
			if (!adckeys[1].chk) {
				adckeys[1].chk = 1;
				adc_draw_key_arrays();
				adc_passed++;
			}
		/* UP */
		} else if (val_y < center_y - ADC_CHECK_OFFSET) {
			if (!adckeys[2].chk) {
				adckeys[2].chk = 1;
				adc_draw_key_arrays();
				adc_passed++;
			}
		/* DOWN */
		} else if (val_y > center_y + ADC_CHECK_OFFSET) {
			if (!adckeys[3].chk) {
				adckeys[3].chk = 1;
				adc_draw_key_arrays();
				adc_passed++;
			}
		}

		mdelay(100);
	}

	lcd_setfg_color("white");
	lcd_printf(0, 18, 1, "ADC KEY TEST PASS!");

	for (i = 0; i < 4; i++)
		adckeys[i].chk = 0;

	mdelay(1000);

	return CMD_RET_SUCCESS;
}

static int do_odroidtest_backlight(cmd_tbl_t * cmdtp, int flag,
				int argc, char * const argv[])
{
	int loop;
	uint period_ns, duty_ns;

	u8 active[4] = {10, 30, 80, 100};
	struct udevice *dev;

	if (uclass_get_device(UCLASS_PWM, 0, &dev))
		return CMD_RET_FAILURE;

	lcd_setbg_color("red");
	lcd_clear();
	lcd_setfg_color("black");
	lcd_printf(0, 3, 1, "[ BACKLIGHT TEST ]");

	loop = 0;
	while (loop < 4) {
		period_ns = 25000;
		duty_ns = period_ns * active[loop] / 100;
		printf("active percentage %d, duty_ns %d\n", active[loop], duty_ns);

		lcd_printf(0, 8, 1, "PERCENTAGE : %d %", active[loop]);
		lcd_printf(0, 12, 1, "Press any key to go on next step");

		if(pwm_set_config(dev, 1, period_ns, duty_ns))
			return CMD_RET_FAILURE;

		wait_key_event();
		mdelay(500);
		loop++;
	}

	lcd_setfg_color("black");
	lcd_printf(0, 16, 1, "BACKLIGHT TEST DONE!");

	mdelay(1000);

	return CMD_RET_SUCCESS;
}

static int do_odroidtest_lcd(cmd_tbl_t * cmdtp, int flag,
				int argc, char * const argv[])
{
	int loop = 0;
	int ret = 0;
	char cmd[128];
	char *colors[] =
		{"red", "blue", "green", "white", "black"};

	while (loop < 5) {
		sprintf(cmd, "lcd setbg %s", colors[loop]);
		run_command(cmd, 0);
		run_command("lcd clear", 0);

		if (!strcmp(colors[loop], "red"))
			lcd_setfg_color("black");
		else
			lcd_setfg_color("magenta");

		sprintf(cmd, "%s", colors[loop]);
		lcd_printf(0, 4, 1, "[ LCD TEST ]");
		lcd_printf(0, 8, 1, cmd);
		lcd_printf(0, 12, 1, "Press any key to go on next step");

		printf("%s\n", colors[loop]);

		wait_key_event();
		mdelay(500);
		loop++;
	}

	lcd_setfg_color("yellow");
	lcd_printf(0, 14, 1, "LCD TEST DONE!");

	mdelay(1000);

	return ret;
}

void btn_draw_key_arrays(int numkeys)
{
	int i;

	lcd_setbg_color("black");
	lcd_clear();

	lcd_setfg_color("white");
	lcd_printf(0, 1, 1, "[ GPIO KEY TEST ]");

	for (i = 0; i < numkeys; i++) {
		if (gpiokeys[i].chk)
			lcd_setfg_color("blue");
		else
			lcd_setfg_color("red");

		lcd_printf(gpiokeys[i].x, gpiokeys[i].y,
				0, gpiokeys[i].name);
	}

}

static int btn_passed;
int btn_update_key_status(int key)
{
	int i = 0;

	while (i < NUMGPIOKEYS) {
		if (gpiokeys[i].code == key) {
			if(!(gpiokeys[i].chk)) {
				gpiokeys[i].chk = 1;
				btn_passed++;
				return 1;
			} else {
				return 0;
			}
		}
		i++;
	}

	return 0;
}

void btn_set_default(void)
{
	int i;

	btn_passed = 0;
	for (i = 0; i < NUMGPIOKEYS; i++)
		gpiokeys[i].chk = 0;
}

static int do_odroidtest_btn(cmd_tbl_t * cmdtp, int flag,
				int argc, char * const argv[])
{
	int key, numkeys;
	const char *hwrev = env_get("hwrev");

	if (hwrev && !strcmp(hwrev, "v11"))
		numkeys = NUMGPIOKEYS;
	else
		numkeys = NUMGPIOKEYS - 2;

	btn_draw_key_arrays(numkeys);
	mdelay(2000);

	while (btn_passed < numkeys) {
		key = wait_key_event();
		if (btn_update_key_status(key))
			btn_draw_key_arrays(numkeys);
		printf("key 0x%x, passed %d\n", key, btn_passed);
	}

	lcd_setfg_color("white");
	lcd_printf(0, 18, 1, "GPIO KEY TEST PASS!");

	btn_set_default();

	mdelay(1000);

	return 0;
}

static cmd_tbl_t cmd_sub_odroidtest[] = {
	U_BOOT_CMD_MKENT(all, 1, 0, do_odroidtest_all, "", ""),
	U_BOOT_CMD_MKENT(btn, 1, 0, do_odroidtest_btn, "", ""),
	U_BOOT_CMD_MKENT(lcd, 1, 0, do_odroidtest_lcd, "", ""),
	U_BOOT_CMD_MKENT(backlight, 1, 0, do_odroidtest_backlight, "", ""),
	U_BOOT_CMD_MKENT(adc, 1, 0, do_odroidtest_adc, "", ""),
};

static int do_odroidtest_all(cmd_tbl_t * cmdtp, int flag,
				int argc, char * const argv[])
{
	int i, ret = 0;

	for (i = 1; i < ARRAY_SIZE(cmd_sub_odroidtest); i++) {
		printf("----- [ %s ] -----\n",
				cmd_sub_odroidtest[i].name);
		ret = cmd_sub_odroidtest[i].cmd(cmdtp, flag,
				1, &cmd_sub_odroidtest[i].name);
	}

	lcd_clear();
	lcd_setfg_color("yellow");
	lcd_printf(0, 9, 1, "AUTO TEST DONE!");

	return ret;
}

static int do_odroidtest(cmd_tbl_t *cmdtp,
			int flag,
			int argc,
			char * const argv[])
{
	cmd_tbl_t *cp;

	if (argc < 2)
		return CMD_RET_USAGE;

	cp = find_cmd_tbl(argv[1], cmd_sub_odroidtest,
			ARRAY_SIZE(cmd_sub_odroidtest));

	argc--;
	argv++;

	if (cp == NULL || argc > cp->maxargs)
		return CMD_RET_USAGE;

	return cp->cmd(cmdtp, flag, argc, argv);
}

U_BOOT_CMD(
	odroidtest, 2, 1, do_odroidtest,
	"ODROID GO Advanced HW Test",
	"odroidtest <subcmd>\n"
	"odroidtest all - do all test\n"
	"odroidtest btn - gpio button test\n"
	"odroidtest lcd - lcd test\n"
	"odroidtest backlight - backlight test\n"
	"odroidtest adc - analog switch test"
);
