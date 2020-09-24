/*
 *  (C) Copyright 2019 Hardkernel Co., Ltd
 *
 *  SPDX-License-Identifier:	GPL-2.0+
 */

#include "odroidtest.h"

#ifdef CONFIG_TARGET_ODROIDGO3
static int yoffs = 4;
#else
static int yoffs = 0;
#endif

static int do_odroidtest_all(cmd_tbl_t * cmdtp, int flag,
				int argc, char * const argv[]);

int wait_key_event(bool timeout)
{
	struct udevice *dev;
	struct dm_key_uclass_platdata *key;
	int evt;
	unsigned int cnt = 15;

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
				lcd_printf(0, 10 + yoffs, 1, "Power key pressed... system will shut down.");
				mdelay(500);
				run_command("poweroff", 0);
			}

			if (timeout == true && cnt == 0)
				return -1;

			cnt--;
		}
	}

	return 0;
}

#ifdef CONFIG_TARGET_ODROIDGO3
/* adc mux controls */
#define GPIO_ADCMUX_EN		109 /* GPIO3_B5 */
#define GPIO_ADCMUX_SEL_A	107 /* GPIO3_B3 */
#define GPIO_ADCMUX_SEL_B	104 /* GPIO3_B0 */

#define NUM_ADC_CH	4
#define ADC_RIGHT_Y	0
#define ADC_RIGHT_X	1
#define ADC_LEFT_Y	2
#define ADC_LEFT_X	3

struct key_adc {
	unsigned int center;
	unsigned int value;
};

void adc_draw_key_arrays(struct key_adc *adcs, int key_idx)
{
	int i;
	char cmd[16];

	lcd_setfg_color("yellow");

	/* center */
	sprintf(cmd, "X %d", adcs[ADC_RIGHT_X].center);
	lcd_printf(599, 10, 0, cmd);
	sprintf(cmd, "Y %d", adcs[ADC_RIGHT_Y].center);
	lcd_printf(599, 12, 0, cmd);

	sprintf(cmd, "X %d", adcs[ADC_LEFT_X].center);
	lcd_printf(184, 10, 0, cmd);
	sprintf(cmd, "Y %d", adcs[ADC_LEFT_Y].center);
	lcd_printf(184, 12, 0, cmd);

	/* value */
	sprintf(cmd, "X %d   ",
		(int)adcs[ADC_RIGHT_X].value - adcs[ADC_RIGHT_X].center);
	lcd_printf(599, 18, 0, cmd);
	sprintf(cmd, "Y %d   ",
		(int)adcs[ADC_RIGHT_Y].value - adcs[ADC_RIGHT_Y].center);
	lcd_printf(599, 20, 0, cmd);

	sprintf(cmd, "X %d   ",
		(int)adcs[ADC_LEFT_X].value - adcs[ADC_LEFT_X].center);
	lcd_printf(184, 18, 0, cmd);
	sprintf(cmd, "Y %d   ",
		(int)adcs[ADC_LEFT_Y].value - adcs[ADC_LEFT_Y].center);
	lcd_printf(184, 20, 0, cmd);

	for (i = 0; i < 8; i++) {
		if (adckeys[i].chk) {
			if (i != key_idx)
				lcd_setfg_color("green");
			else
				lcd_setfg_color("blue");
		}
		else
			lcd_setfg_color("red");

		lcd_printf(adckeys[i].x, adckeys[i].y,
				0, adckeys[i].name);
	}

	mdelay(200);
	lcd_setfg_color("green");
	lcd_printf(adckeys[key_idx].x, adckeys[key_idx].y,
		0, adckeys[key_idx].name);
}

int adc_amux_select(int channel)
{
	/* enable mux */
	gpio_set_value(GPIO_ADCMUX_EN, 0);

	switch(channel) {
		case ADC_RIGHT_Y: /* Right Y */
			gpio_set_value(GPIO_ADCMUX_SEL_A, 0);
			gpio_set_value(GPIO_ADCMUX_SEL_B, 0);
			break;
		case ADC_RIGHT_X: /* Right X */
			gpio_set_value(GPIO_ADCMUX_SEL_A, 0);
			gpio_set_value(GPIO_ADCMUX_SEL_B, 1);
			break;
		case ADC_LEFT_Y: /* Left Y */
			gpio_set_value(GPIO_ADCMUX_SEL_A, 1);
			gpio_set_value(GPIO_ADCMUX_SEL_B, 0);
			break;
		case ADC_LEFT_X: /* Left X */
			gpio_set_value(GPIO_ADCMUX_SEL_A, 1);
			gpio_set_value(GPIO_ADCMUX_SEL_B, 1);
			break;
		default:
			/* disable adcmux */
			gpio_set_value(GPIO_ADCMUX_EN, 1);
			return -1;
	}

	mdelay(50);

	return 0;
}

#define ADC_CENTER_CHECK_COUNT	5
int adc_get_center(struct key_adc *adc, int adc_ch)
{
	int i = 0;
	unsigned int val;

	adc->center = 0;

	adc_amux_select(adc_ch);

	while (i < ADC_CENTER_CHECK_COUNT) {
		if (adc_channel_single_shot("saradc", 1, &val)) {
			printf("adc_channel_single_shot fail!\n");
			return CMD_RET_FAILURE;
		}

		adc->center += val;

		mdelay(50);
		i++;
	}

	adc->center /= ADC_CENTER_CHECK_COUNT;

	return CMD_RET_SUCCESS;
}

int adc_read_value(struct key_adc *adc, int adc_ch)
{
	adc_amux_select(adc_ch);

	if (adc_channel_single_shot("saradc", 1, &adc->value)) {
		printf("adc_channel_single_shot fail!\n");
		return CMD_RET_FAILURE;
	}

	return CMD_RET_SUCCESS;
}

#define ADC_CHECK_OFFSET	100
static int do_odroidtest_adc(cmd_tbl_t * cmdtp, int flag,
				int argc, char * const argv[])
{
	struct udevice *dev;
	struct key_adc adcs[NUM_ADC_CH];

	int i;
	int center_x, center_y;
	int val_x, val_y;
	int key;
	int key_idx = -1;

	if (uclass_get_device(UCLASS_ADC, 0, &dev))
		return CMD_RET_FAILURE;

	/* init adcs arrays */
	memset(adcs, 0, sizeof(adcs));

	/* draw background */
	lcd_setbg_color("black");
	lcd_clear();
	lcd_setfg_color("white");
	lcd_printf(0, 1, 1, "[ ADC KEY TEST ]");

	/* calibration preparation */
	lcd_printf(0, 8, 1, "For the Accuracy of Analog Joysticks Test,");
	lcd_printf(0, 10, 1, "Calibration will be Run First.");
	mdelay(1000);
	lcd_setfg_color("red");
	lcd_printf(0, 14, 1, "DO NOT Control Analog Joysticks During Calibration.");
	mdelay(1000);
	lcd_setfg_color("white");
	lcd_printf(0, 18, 1, "Now, Press Any Button to Start.");
	lcd_printf(0, 20, 1, "Then, Calibration will Start in 2 Seconds.");
	mdelay(500);

	key = wait_key_event(false);

	lcd_printf(0, 22, 1, "...          ");
	mdelay(400);
	lcd_printf(0, 22, 1, "......       ");
	mdelay(400);
	lcd_printf(0, 22, 1, ".........    ");
	mdelay(400);
	lcd_printf(0, 22, 1, ".............");
	mdelay(400);

	/* start calibration */
	lcd_clear();
	lcd_setfg_color("white");
	lcd_printf(0, 1, 1, "[ ADC KEY TEST ]");
	lcd_printf(0, 14, 1, "Calibration Starts...");
	lcd_printf(0, 16, 1, "It may take 1 or 2 seconds.");

	gpio_request(GPIO_ADCMUX_EN, "adcmux_en");
	gpio_direction_output(GPIO_ADCMUX_EN, 1); /* default disable */
	gpio_request(GPIO_ADCMUX_SEL_A, "adcmux_sel_a");
	gpio_direction_output(GPIO_ADCMUX_SEL_A, 0);
	gpio_request(GPIO_ADCMUX_SEL_B, "adcmux_sel_b");
	gpio_direction_output(GPIO_ADCMUX_SEL_B, 0);

	for (i = 0; i < NUM_ADC_CH; i++) {
		if (adc_get_center(&adcs[i], i))
			return CMD_RET_FAILURE;
	}

	mdelay(500);
	lcd_printf(0, 14, 1, "  Calibration Done !  ");
	lcd_printf(0, 16, 1, "Press Any Button to Start Analog Joysticks Test.");
	mdelay(500);

	key = wait_key_event(false);
	mdelay(1000);

	/* clear background */
	lcd_clear();
	lcd_setfg_color("white");
	lcd_printf(0, 1, 1, "[ ADC KEY TEST ]");
	lcd_setfg_color("grey");
	lcd_printf(0, 26, 1, "F3+F6 press to exit ADC KEY test");
	lcd_printf(0, 28, 1, "Long press on PWR key to turn off power");

	adc_draw_key_arrays(adcs, key_idx);

	while (1) {
		/* LEFT ADC */
		for (i = 2; i < 4; i++) {
			if (adc_read_value(&adcs[i], i))
				return CMD_RET_FAILURE;
		}

		center_x = adcs[ADC_LEFT_X].center;
		center_y = adcs[ADC_LEFT_Y].center;
		val_x = adcs[ADC_LEFT_X].value;
		val_y = adcs[ADC_LEFT_Y].value;

		debug("[LEFT]center x %d y %d / value x %d, y %d ",
			center_x, center_y,
			val_x, val_y);

		/* WEST */
		if (val_x < center_x - ADC_CHECK_OFFSET) {
			if (!adckeys[0].chk)
				adckeys[0].chk = 1;
			key_idx = 0;
		/* EAST */
		} else if (val_x > center_x + ADC_CHECK_OFFSET) {
			if (!adckeys[1].chk)
				adckeys[1].chk = 1;
			key_idx = 1;
		/* NORTH */
		} else if (val_y < center_y - ADC_CHECK_OFFSET) {
			if (!adckeys[2].chk)
				adckeys[2].chk = 1;
			key_idx = 2;
		/* SOUTH */
		} else if (val_y > center_y + ADC_CHECK_OFFSET) {
			if (!adckeys[3].chk)
				adckeys[3].chk = 1;
			key_idx = 3;
		}

		for (i = 0; i < 3; i++) {
			if (adc_read_value(&adcs[i], i))
				return CMD_RET_FAILURE;
		}

		/* RIGHT ADC */
		center_x = adcs[ADC_RIGHT_X].center;
		center_y = adcs[ADC_RIGHT_Y].center;
		val_x = adcs[ADC_RIGHT_X].value;
		val_y = adcs[ADC_RIGHT_Y].value;

		debug("[RIGHT]center x %d y %d / value x %d, y %d\n",
			center_x, center_y,
			val_x, val_y);

		/* WEST */
		if (val_x < center_x - ADC_CHECK_OFFSET) {
			if (!adckeys[4].chk)
				adckeys[4].chk = 1;
			key_idx = 4;
		/* EAST */
		} else if (val_x > center_x + ADC_CHECK_OFFSET) {
			if (!adckeys[5].chk)
				adckeys[5].chk = 1;
			key_idx = 5;
		/* NORTH */
		} else if (val_y < center_y - ADC_CHECK_OFFSET) {
			if (!adckeys[6].chk)
				adckeys[6].chk = 1;
			key_idx = 6;
		/* SOUTH */
		} else if (val_y > center_y + ADC_CHECK_OFFSET) {
			if (!adckeys[7].chk)
				adckeys[7].chk = 1;
			key_idx = 7;
		}

		adc_draw_key_arrays(adcs, key_idx);
		key_idx = -1;
		mdelay(200);

		/* termination using F3+F6 */
		key = wait_key_event(true);
		if ((key == BTN_TRIGGER_HAPPY3) || (key == BTN_TRIGGER_HAPPY6)) {
			if(!run_command("gpio input C2", 0)
				&& !run_command("gpio input C5", 0)) {
				printf("Got termination key!\n");
				break;
			}
		}
	}

	lcd_setfg_color("white");
	lcd_printf(0, 22, 1, "ADC KEY TEST TERMINATED!");

	for (i = 0; i < 8; i++)
		adckeys[i].chk = 0;

	mdelay(1000);

	gpio_free(GPIO_ADCMUX_EN);
	gpio_free(GPIO_ADCMUX_SEL_A);
	gpio_free(GPIO_ADCMUX_SEL_B);

	return CMD_RET_SUCCESS;
}

#else /* CONFIG_TARGET_ODROIDGO3 */

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
	lcd_printf(0, 18 + yoffs, 1, "ADC KEY TEST PASS!");

	for (i = 0; i < 4; i++)
		adckeys[i].chk = 0;

	mdelay(1000);

	return CMD_RET_SUCCESS;
}
#endif /* CONFIG_TARGET_ODROIDGO3 */

static int do_odroidtest_backlight(cmd_tbl_t * cmdtp, int flag,
				int argc, char * const argv[])
{
	int loop;
	int key;
	uint period_ns, duty_ns;

	u8 active[4] = {10, 30, 80, 100};
	struct udevice *dev;

	if (uclass_get_device(UCLASS_PWM, 0, &dev))
		return CMD_RET_FAILURE;

	lcd_setbg_color("red");
	lcd_clear();
	lcd_setfg_color("black");
	lcd_printf(0, 3, 1, "[ BACKLIGHT TEST ]");
	lcd_printf(0, 12 + yoffs, 1, "Press any key to go on next step");

	lcd_setfg_color("grey");
	lcd_printf(0, 22 + yoffs, 1, "F3+F6 press to exit BACKLIGHT test");
	lcd_printf(0, 24 + yoffs, 1,
		"Long press on PWR key to turn off power");

	loop = 0;

	lcd_setfg_color("black");
	while (1) {
		period_ns = 25000;
		duty_ns = period_ns * active[loop] / 100;
		printf("active percentage %d, duty_ns %d\n", active[loop], duty_ns);
		lcd_printf(0, 8 + yoffs, 1, "PERCENTAGE : %d %", active[loop]);

		if(pwm_set_config(dev, 1, period_ns, duty_ns))
			return CMD_RET_FAILURE;

		if (loop < 3)
			loop++;
		else
			loop = 0;

		key = wait_key_event(false);
#ifdef CONFIG_TARGET_ODROIDGO3
		/* termination using F3+F6 */
		if ((key == BTN_TRIGGER_HAPPY3) || (key == BTN_TRIGGER_HAPPY6)) {
			if(!run_command("gpio input C2", 0)
				&& !run_command("gpio input C5", 0)) {
				printf("Got termination key!\n");
				break;
			}
		}
#else
		/* termination using F1+F6 */
		if ((key == BTN_TRIGGER_HAPPY1) || (key == BTN_TRIGGER_HAPPY6)) {
			if(!run_command("gpio input C0", 0)
				&& !run_command("gpio input C5", 0)) {
				printf("Got termination key!\n");
				break;
			}
		}
#endif
		mdelay(500);
	}

	/* set backlight as max */
	pwm_set_config(dev, 1, period_ns, period_ns);

	lcd_setfg_color("black");
	lcd_printf(0, 18 + yoffs, 1, "BACKLIGHT TEST TERMINATED!");

	mdelay(1000);

	return CMD_RET_SUCCESS;
}

static int do_odroidtest_lcd(cmd_tbl_t * cmdtp, int flag,
				int argc, char * const argv[])
{
	int loop = 0;
	int ret = 0;
	int key;
	char cmd[128];
	char *colors[] =
		{"red", "blue", "green", "white", "black"};

	while (1) {
		sprintf(cmd, "lcd setbg %s", colors[loop]);
		run_command(cmd, 0);
		run_command("lcd clear", 0);

		lcd_setfg_color("grey");
		lcd_printf(0, 22 + yoffs, 1, "F3+F6 press to exit LCD test");
		lcd_printf(0, 24 + yoffs, 1,
			"Long press on PWR key to turn off power");

		if (!strcmp(colors[loop], "red"))
			lcd_setfg_color("black");
		else
			lcd_setfg_color("magenta");

		sprintf(cmd, "%s", colors[loop]);
		lcd_printf(0, 4, 1, "[ LCD TEST ]");
		lcd_printf(0, 8 + yoffs, 1, cmd);
		sprintf(cmd, "%d / 5", (loop + 1));
		lcd_printf(0, 10 + yoffs, 1, cmd);
		lcd_printf(0, 12 + yoffs, 1, "Press any key to go on next step");

		if (loop < 4)	loop++;
		else		loop = 0;

		key = wait_key_event(false);
#ifdef CONFIG_TARGET_ODROIDGO3
		/* termination using F3+F6 */
		if ((key == BTN_TRIGGER_HAPPY3) || (key == BTN_TRIGGER_HAPPY6)) {
			if(!run_command("gpio input C2", 0)
				&& !run_command("gpio input C5", 0)) {
				printf("Got termination key!\n");
				break;
			}
		}
#else
		/* termination using F1+F6 */
		if ((key == BTN_TRIGGER_HAPPY1) || (key == BTN_TRIGGER_HAPPY6)) {
			if(!run_command("gpio input C0", 0)
				&& !run_command("gpio input C5", 0)) {
				printf("Got termination key!\n");
				break;
			}
		}
#endif
		mdelay(500);
	}

	lcd_printf(0, 18 + yoffs, 1, "LCD TEST TERMINATED!");

	mdelay(1000);

	return ret;
}

void btn_draw_key_arrays(int numkeys, int key_idx)
{
	int i;

	for (i = 0; i < numkeys; i++) {
		if (gpiokeys[i].chk) {
			if (i != key_idx)
				lcd_setfg_color("green");
			else
				lcd_setfg_color("blue");
		} else {
			lcd_setfg_color("red");
		}

		lcd_printf(gpiokeys[i].x, gpiokeys[i].y,
				0, gpiokeys[i].name);
	}

	mdelay(200);

	lcd_setfg_color("green");
	lcd_printf(gpiokeys[key_idx].x, gpiokeys[key_idx].y,
			0, gpiokeys[key_idx].name);
}

static int btn_passed;
int btn_update_key_status(int key, int numkeys)
{
	int i = 0;

	while (i < numkeys) {
		if (gpiokeys[i].code == key) {
			if(!(gpiokeys[i].chk)) {
				gpiokeys[i].chk = 1;
				btn_passed++;
			}
			return i;
		}
		i++;
	}

	return -1;
}

void btn_set_default(int numkeys)
{
	int i;

	btn_passed = 0;
	for (i = 0; i < numkeys; i++)
		gpiokeys[i].chk = 0;
}

static int do_odroidtest_btn(cmd_tbl_t * cmdtp, int flag,
				int argc, char * const argv[])
{
	int key, numkeys, key_idx;
	const char *hwrev = env_get("hwrev");

	if (hwrev && !strcmp(hwrev, "v10"))
		numkeys = NUMGPIOKEYS - 2;
	else
		numkeys = NUMGPIOKEYS;

	/* draw background */
	lcd_setbg_color("black");
	lcd_clear();

	lcd_setfg_color("white");
	lcd_printf(0, 1, 1, "[ GPIO KEY TEST ]");

	lcd_setfg_color("grey");
	lcd_printf(0, 22 + yoffs, 1, "F3+F6 press to exit BUTTON test");
	lcd_printf(0, 24 + yoffs, 1,
		"Long press on PWR key to turn off power");

	/* key initialization */
	key_idx = -1;
	btn_draw_key_arrays(numkeys, key_idx);
	mdelay(2000);

	while (1) {
		key = wait_key_event(false);
		key_idx = btn_update_key_status(key, numkeys);

		/* update display */
		btn_draw_key_arrays(numkeys, key_idx);
		printf("key 0x%x, passed %d\n", key, btn_passed);

#ifdef CONFIG_TARGET_ODROIDGO3
		/* check termination using F3+F6 */
		if ((key == BTN_TRIGGER_HAPPY3) || (key == BTN_TRIGGER_HAPPY6)) {
			printf("check termination keys, key_idx %d\n", key_idx);

			if(!run_command("gpio input C2", 0)
				&& !run_command("gpio input C5", 0)) {
				printf("Got termination key!\n");
				break;
			}
		}
#else
		/* check termination using F1+F6 */
		if ((key == BTN_TRIGGER_HAPPY1) || (key == BTN_TRIGGER_HAPPY6)) {
			printf("check termination keys, key_idx %d\n", key_idx);

			if(!run_command("gpio input C0", 0)
				&& !run_command("gpio input C5", 0)) {
				printf("Got termination key!\n");
				break;
			}
		}
#endif
	}

	lcd_setfg_color("white");
	lcd_printf(0, 18 + yoffs, 1, "GPIO KEY TEST TERMINATED!");

	btn_set_default(numkeys);

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
	unsigned int state;
	unsigned int delay = 5000;

	for (i = 1; i < ARRAY_SIZE(cmd_sub_odroidtest); i++) {
		printf("----- [ %s ] -----\n",
				cmd_sub_odroidtest[i].name);
		ret = cmd_sub_odroidtest[i].cmd(cmdtp, flag,
				1, &cmd_sub_odroidtest[i].name);
	}

	lcd_clear();
	lcd_setfg_color("yellow");
	lcd_printf(0, 9, 1, "AUTO TEST DONE!");
	lcd_printf(0, 16 + yoffs, 1, "wait power key...");

	/* check power key */
	while (delay) {
		state = key_read(KEY_POWER);
		if (state == KEY_PRESS_DOWN)
			break;

		mdelay(25);
		delay -= 25;
	}

	printf("power key long pressed...\n");
	lcd_printf(0, 18 + yoffs, 1, "%s", "power off...");
	mdelay(500);
	run_command("poweroff", 0);

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
