/*
 *  (C) Copyright 2019 Hardkernel Co., Ltd
 *
 *  SPDX-License-Identifier:	GPL-2.0+
 */

#include "odroidtest.h"

extern bool is_odroidgo3(void);

static int yoffs;

static int do_odroidtest_all(cmd_tbl_t * cmdtp, int flag,
				int argc, char * const argv[]);

int wait_key_event(bool timeout)
{
	struct udevice *dev;
	struct dm_key_uclass_platdata *key;
	int evt;
	unsigned int cnt;

	if (is_odroidgo3())
		cnt = NUMGPIOKEYS_GO3;
	else
		cnt = NUMGPIOKEYS_GO2;

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

bool check_termination_key(int key)
{
	if (is_odroidgo3()) {
		/* termination using F3+F6 */
		if ((key == BTN_TRIGGER_HAPPY3) || (key == BTN_TRIGGER_HAPPY6)) {
			if(!run_command("gpio input C2", 0)
					&& !run_command("gpio input C5", 0)) {
				printf("Got termination key!\n");
				return true;
			}
		}
	} else {
		/* termination using F1+F6 */
		if ((key == BTN_TRIGGER_HAPPY1) || (key == BTN_TRIGGER_HAPPY6)) {
			if(!run_command("gpio input C0", 0)
					&& !run_command("gpio input C5", 0)) {
				printf("Got termination key!\n");
				return true;
			}
		}
	}

	return false;
}

/* adc mux controls */
#define GPIO_ADCMUX_EN		109 /* GPIO3_B5 */
#define GPIO_ADCMUX_SEL_A	107 /* GPIO3_B3 */
#define GPIO_ADCMUX_SEL_B	104 /* GPIO3_B0 */

static unsigned int num_adcch;

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

	if (is_odroidgo3()) {
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
	} else {
		/* center */
		sprintf(cmd, "X %d", adcs[ADC_LEFT_X].center);
		lcd_printf(222, 6, 0, cmd);
		sprintf(cmd, "Y %d", adcs[ADC_LEFT_Y].center);
		lcd_printf(222, 8, 0, cmd);

		/* value */
		sprintf(cmd, "X %d   ",
				(int)adcs[ADC_LEFT_X].value - adcs[ADC_LEFT_X].center);
		lcd_printf(222, 13, 0, cmd);
		sprintf(cmd, "Y %d   ",
				(int)adcs[ADC_LEFT_Y].value - adcs[ADC_LEFT_Y].center);
		lcd_printf(222, 14, 0, cmd);

		for (i = 0; i < 4; i++) {
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
	}

	mdelay(200);
	if (key_idx > 0) {
		lcd_setfg_color("green");
		lcd_printf(adckeys[key_idx].x, adckeys[key_idx].y,
				0, adckeys[key_idx].name);
	}
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

	printf("adc_get_center : adc_ch %d\n", adc_ch);
	adc->center = 0;

	if (is_odroidgo3()) {
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
	} else {
		while (i < ADC_CENTER_CHECK_COUNT) {
			/* Left X (CH3) */
			if (adc_ch == ADC_LEFT_X) {
				if (adc_channel_single_shot("saradc", 1, &val)) {
					printf("adc_channel_single_shot fail!\n");
					return CMD_RET_FAILURE;
				}
			}

			/* Left Y (CH2) */
			if (adc_ch == ADC_LEFT_Y) {
				if (adc_channel_single_shot("saradc", 2, &val)) {
					printf("adc_channel_single_shot fail!\n");
					return CMD_RET_FAILURE;
				}
			}

			adc->center += val;

			mdelay(50);
			i++;
		}
	}

	adc->center /= ADC_CENTER_CHECK_COUNT;

	return CMD_RET_SUCCESS;
}

int adc_read_value(struct key_adc *adc, int adc_ch)
{
	if (is_odroidgo3()) {
		adc_amux_select(adc_ch);

		if (adc_channel_single_shot("saradc", 1, &adc->value)) {
			printf("adc_channel_single_shot fail!\n");
			return CMD_RET_FAILURE;
		}
	} else {
		/* Left X */
		if (adc_ch == ADC_LEFT_X) {
			if (adc_channel_single_shot("saradc", 1, &adc->value)) {
				printf("adc_channel_single_shot fail!\n");
				return CMD_RET_FAILURE;
			}
		}

		/* Left Y */
		if (adc_ch == ADC_LEFT_Y) {
			if (adc_channel_single_shot("saradc", 2, &adc->value)) {
				printf("adc_channel_single_shot fail!\n");
				return CMD_RET_FAILURE;
			}
		}
	}

	return CMD_RET_SUCCESS;
}

#define ADC_CHECK_OFFSET_GO2	100
#define ADC_CHECK_OFFSET_GO3	200
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

	/* set adc key table */
	if (is_odroidgo3()) {
		adckeys = adckeys_go3;
		num_adcch = 4;
	} else {
		adckeys = adckeys_go2;
		num_adcch = 2;
	}

	/* draw background */
	lcd_setbg_color("black");
	lcd_clear();
	lcd_setfg_color("white");
	lcd_printf(0, 1, 1, "[ ADC KEY TEST ]");

	/* calibration preparation */
	lcd_printf(0, 4 + yoffs, 1, "For the Accuracy of Analog Joysticks Test,");
	lcd_printf(0, 6 + yoffs, 1, "Calibration will be Run First.");
	mdelay(1000);
	lcd_setfg_color("red");
	lcd_printf(0, 9+ yoffs, 1, "DO NOT Control Analog Joysticks During Calibration.");
	mdelay(1000);
	lcd_setfg_color("white");
	lcd_printf(0, 13 + yoffs, 1, "Now, Press Any Button to Start.");
	lcd_printf(0, 15 + yoffs, 1, "Then, Calibration will Start in 2 Seconds.");
	mdelay(500);

	key = wait_key_event(false);

	lcd_printf(0, 17 + yoffs, 1, "...          ");
	mdelay(400);
	lcd_printf(0, 17 + yoffs, 1, "......       ");
	mdelay(400);
	lcd_printf(0, 17 + yoffs, 1, ".........    ");
	mdelay(400);
	lcd_printf(0, 17 + yoffs, 1, ".............");
	mdelay(400);

	/* start calibration */
	lcd_clear();
	lcd_setfg_color("white");
	lcd_printf(0, 1, 1, "[ ADC KEY TEST ]");
	lcd_printf(0, 10 + yoffs, 1, "Calibration Starts...");
	lcd_printf(0, 12 + yoffs, 1, "It may take 1 or 2 seconds.");

	if (is_odroidgo3()) {
		gpio_request(GPIO_ADCMUX_EN, "adcmux_en");
		gpio_direction_output(GPIO_ADCMUX_EN, 1); /* default disable */
		gpio_request(GPIO_ADCMUX_SEL_A, "adcmux_sel_a");
		gpio_direction_output(GPIO_ADCMUX_SEL_A, 0);
		gpio_request(GPIO_ADCMUX_SEL_B, "adcmux_sel_b");
		gpio_direction_output(GPIO_ADCMUX_SEL_B, 0);
	}

	for (i = 0; i < NUM_ADC_CH; i++) {
		if (adc_get_center(&adcs[i], i))
			return CMD_RET_FAILURE;
	}

	mdelay(500);
	lcd_printf(0, 10 + yoffs, 1, "  Calibration Done !  ");
	lcd_printf(0, 12 + yoffs, 1, "Press Any Button to Start Analog Joysticks Test.");
	mdelay(500);

	key = wait_key_event(false);
	mdelay(1000);

	/* clear background */
	lcd_clear();
	lcd_setfg_color("white");
	lcd_printf(0, 1, 1, "[ ADC KEY TEST ]");
	lcd_setfg_color("grey");
	if (is_odroidgo3()) {
		lcd_printf(0, 26, 1, "F3+F6 press to exit ADC KEY test");
		lcd_printf(0, 28, 1, "Long press on PWR key to turn off power");
	} else {
		lcd_printf(0, 16, 1, "F1+F6 press to exit ADC KEY test");
		lcd_printf(0, 17, 1, "Long press on PWR key to turn off power");
	}

	adc_draw_key_arrays(adcs, key_idx);

	while (1) {
		if (is_odroidgo3()) {
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
			if (val_x < center_x - ADC_CHECK_OFFSET_GO3) {
				if (!adckeys[0].chk)
					adckeys[0].chk = 1;
				key_idx = 0;
				/* EAST */
			} else if (val_x > center_x + ADC_CHECK_OFFSET_GO3) {
				if (!adckeys[1].chk)
					adckeys[1].chk = 1;
				key_idx = 1;
				/* NORTH */
			} else if (val_y < center_y - ADC_CHECK_OFFSET_GO3) {
				if (!adckeys[2].chk)
					adckeys[2].chk = 1;
				key_idx = 2;
				/* SOUTH */
			} else if (val_y > center_y + ADC_CHECK_OFFSET_GO3) {
				if (!adckeys[3].chk)
					adckeys[3].chk = 1;
				key_idx = 3;
			}

			/* RIGHT ADC */
			for (i = 0; i < 2; i++) {
				if (adc_read_value(&adcs[i], i))
					return CMD_RET_FAILURE;
			}

			center_x = adcs[ADC_RIGHT_X].center;
			center_y = adcs[ADC_RIGHT_Y].center;
			val_x = adcs[ADC_RIGHT_X].value;
			val_y = adcs[ADC_RIGHT_Y].value;

			debug("[RIGHT]center x %d y %d / value x %d, y %d\n",
					center_x, center_y,
					val_x, val_y);

			/* WEST */
			if (val_x < center_x - ADC_CHECK_OFFSET_GO3) {
				if (!adckeys[4].chk)
					adckeys[4].chk = 1;
				key_idx = 4;
				/* EAST */
			} else if (val_x > center_x + ADC_CHECK_OFFSET_GO3) {
				if (!adckeys[5].chk)
					adckeys[5].chk = 1;
				key_idx = 5;
				/* NORTH */
			} else if (val_y < center_y - ADC_CHECK_OFFSET_GO3) {
				if (!adckeys[6].chk)
					adckeys[6].chk = 1;
				key_idx = 6;
				/* SOUTH */
			} else if (val_y > center_y + ADC_CHECK_OFFSET_GO3) {
				if (!adckeys[7].chk)
					adckeys[7].chk = 1;
				key_idx = 7;
			}
		} else {
			/* LEFT ADC Only */
			for (i = 2; i < 4; i++) {
				if (adc_read_value(&adcs[i], i))
					return CMD_RET_FAILURE;
			}

			center_x = adcs[ADC_LEFT_X].center;
			center_y = adcs[ADC_LEFT_Y].center;
			val_x = adcs[ADC_LEFT_X].value;
			val_y = adcs[ADC_LEFT_Y].value;

			printf("[LEFT]center x %d y %d / value x %d, y %d \n",
					center_x, center_y,
					val_x, val_y);

			/* WEST : plus value */
			if (val_x > center_x + ADC_CHECK_OFFSET_GO2) {
				if (!adckeys[0].chk)
					adckeys[0].chk = 1;
				key_idx = 0;
			/* EAST : minus value */
			} else if (val_x < center_x - ADC_CHECK_OFFSET_GO2) {
				if (!adckeys[1].chk)
					adckeys[1].chk = 1;
				key_idx = 1;
			/* NORTH : minus value */
			} else if (val_y < center_y - ADC_CHECK_OFFSET_GO2) {
				if (!adckeys[2].chk)
					adckeys[2].chk = 1;
				key_idx = 2;
			/* SOUTH : plus value */
			} else if (val_y > center_y + ADC_CHECK_OFFSET_GO2) {
				if (!adckeys[3].chk)
					adckeys[3].chk = 1;
				key_idx = 3;
			}
		}

		adc_draw_key_arrays(adcs, key_idx);
		key_idx = -1;
		mdelay(80);

		/* check termination keys */
		key = wait_key_event(true);
		if (check_termination_key(key))
			break;
	}

	lcd_setfg_color("white");
	lcd_printf(0, 18 + yoffs, 1, "ADC KEY TEST TERMINATED!");

	for (i = 0; i < 8; i++)
		adckeys[i].chk = 0;

	mdelay(1000);

	if (is_odroidgo3()) {
		gpio_free(GPIO_ADCMUX_EN);
		gpio_free(GPIO_ADCMUX_SEL_A);
		gpio_free(GPIO_ADCMUX_SEL_B);
	}

	return CMD_RET_SUCCESS;
}

#define BL_MAX_LEVEL		255
#define BL_OGA_MAX_LEVEL	160
#define BL_OGA_DEFAULT_LEVEL	80
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
	if (is_odroidgo3()) {
		lcd_printf(0, 22 + yoffs, 1, "F3+F6 press to exit BACKLIGHT test");
		lcd_printf(0, 24 + yoffs, 1,
				"Long press on PWR key to turn off power");
	} else {
		lcd_printf(0, 16, 1, "F1+F6 press to exit BACKLIGHT test");
		lcd_printf(0, 17, 1,
				"Long press on PWR key to turn off power");
	}

	loop = 0;

	lcd_setfg_color("black");
	while (1) {
		period_ns = 25000;
		if (is_odroidgo3())
			duty_ns = period_ns * active[loop] / 100 * BL_OGA_MAX_LEVEL / BL_MAX_LEVEL;
		else
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
		if (check_termination_key(key))
			break;

		mdelay(500);
	}

	if (is_odroidgo3()) {
		/* set backlight as default */
		duty_ns = period_ns * BL_OGA_DEFAULT_LEVEL / BL_MAX_LEVEL;
		pwm_set_config(dev, 1, period_ns, duty_ns);
	} else {
		/* set backlight as max */
		pwm_set_config(dev, 1, period_ns, period_ns);
	}

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
		if (is_odroidgo3()) {
			lcd_printf(0, 22 + yoffs, 1, "F3+F6 press to exit LCD test");
			lcd_printf(0, 24 + yoffs, 1,
					"Long press on PWR key to turn off power");
		} else {
			lcd_printf(0, 16, 1, "F1+F6 press to exit LCD test");
			lcd_printf(0, 17, 1,
					"Long press on PWR key to turn off power");
		}

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
		if (check_termination_key(key))
			break;

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

	if (key_idx > 0) {
		lcd_setfg_color("green");
		lcd_printf(gpiokeys[key_idx].x, gpiokeys[key_idx].y,
				0, gpiokeys[key_idx].name);
	}
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

	if (is_odroidgo3()) {
		numkeys = NUMGPIOKEYS_GO3;
		gpiokeys = gpiokeys_go3;
	} else {
		if (hwrev && !strcmp(hwrev, "v11"))
			numkeys = NUMGPIOKEYS_GO2;
		else
			numkeys = NUMGPIOKEYS_GO2 - 2;
		gpiokeys = gpiokeys_go2;
	}

	/* draw background */
	lcd_setbg_color("black");
	lcd_clear();

	lcd_setfg_color("white");
	lcd_printf(0, 1, 1, "[ GPIO KEY TEST ]");

	lcd_setfg_color("grey");
	if (is_odroidgo3()) {
		lcd_printf(0, 22 + yoffs, 1, "F3+F6 press to exit BUTTON test");
		lcd_printf(0, 24 + yoffs, 1,
				"Long press on PWR key to turn off power");
	} else {
		lcd_printf(0, 16, 1, "F1+F6 press to exit BUTTON test");
		lcd_printf(0, 17, 1,
				"Long press on PWR key to turn off power");
	}

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

		if (check_termination_key(key))
			break;
	}

	lcd_setfg_color("white");
	lcd_printf(0, 18 + yoffs, 1, "GPIO KEY TEST TERMINATED!");

	btn_set_default(numkeys);

	mdelay(1000);

	return 0;
}

#define PWR_LED_GPIO	18	/* GPIO0_C2 */
#define DC_DET_GPIO	11	/* GPIO0_B3 */
#define CHG_LED_GPIO	13	/* GPIO0_B5 */
static int do_odroidtest_bat(cmd_tbl_t * cmdtp, int flag,
				int argc, char * const argv[])
{
	struct udevice *fg;
	int ret;

	int key;

	int is_bat_exist;
	bool is_dcjack_exist;
	bool is_chrg_online;

	int bat_voltage;
	int chrg_current;
	int soc;

	char cmd[64];

	/* draw background */
	lcd_setbg_color("black");
	lcd_clear();

	lcd_setfg_color("white");
	lcd_printf(0, 1, 1, "[ BATTERY & CHARGE TEST ]");

	lcd_setfg_color("grey");
	if (is_odroidgo3()) {
		lcd_printf(0, 26, 1, "F3+F6 press to exit BATTERY test");
		lcd_printf(0, 28, 1,
				"Long press on PWR key to turn off power");
	} else {
		lcd_printf(0, 18, 1, "F1+F6 press to exit BATTERY test");
		lcd_printf(0, 19 + yoffs, 1,
				"Long press on PWR key to turn off power");
	}

	/* check fuel gauge device */
	ret = uclass_get_device(UCLASS_FG, 0, &fg);
	if (ret) {
		if (ret == -ENODEV)
			printf("Can't find FG\n");
		else
			printf("Get UCLASS FG failed: %d\n", ret);
		return ret;
	}

	gpio_request(PWR_LED_GPIO, "pwr_led");
	gpio_request(CHG_LED_GPIO, "chg_led");

	while (1) {
		lcd_setfg_color("yellow");

		/* 1. check battery connection */
		is_bat_exist = fuel_gauge_bat_is_exist(fg);
		printf("is_bat_exist %d\n", is_bat_exist);
		if (is_bat_exist) {
			lcd_printf(0, 3 + yoffs, 1, "  BATTERY : Connected  ");
		} else {
			lcd_printf(0, 3 + yoffs, 1, "BATTERY : Disconnected");
		}

		/* 2. check dc cable connection */
		is_dcjack_exist = gpio_get_value(DC_DET_GPIO) ? 1 : 0;
		printf("is_dcjack_exist %d\n", is_dcjack_exist);
		if (is_dcjack_exist) {
			lcd_printf(0, 6 + yoffs, 1, "  DC JACK : Connected  ");
			gpio_direction_output(PWR_LED_GPIO, 1);
		} else {
			lcd_printf(0, 6 + yoffs, 1, "DC JACK : Disconnected");
			gpio_direction_output(PWR_LED_GPIO, 0);
		}

		/* 3. get soc */
		if (is_bat_exist) {
			soc = fuel_gauge_update_get_soc(fg);
			printf("charging online : soc %d\n", soc);
		}

		/* 4. check charging online */
		is_chrg_online = fuel_gauge_get_chrg_online(fg);
		printf("is_chrg_online %d\n", is_chrg_online);
		if (is_chrg_online) {
			lcd_printf(0, 9 + yoffs, 1, "  CHARGING STATE : Online  ");
			gpio_direction_output(CHG_LED_GPIO, 1);
		} else {
			lcd_printf(0, 9 + yoffs, 1, "CHARGING STATE : Offline");
			gpio_direction_output(CHG_LED_GPIO, 0);
		}

		/* 5. show battery level */
		bat_voltage = fuel_gauge_get_voltage(fg);
		printf("bat_voltage %d\n", bat_voltage);
		sprintf(cmd, "BATTERY VOLTAGE : %d (mV)", bat_voltage);
		lcd_printf(0, 12 + yoffs, 1, cmd);

		/* 6. show charging current */
		chrg_current = fuel_gauge_get_current(fg);
		printf("chrg_current %d\n\n", chrg_current);
		sprintf(cmd, "CHARGING CURRENT : %d (mA)", chrg_current);
		lcd_printf(0, 15 + yoffs, 1, cmd);

		/* 7. check key event */
		key = wait_key_event(true);

		if (check_termination_key(key))
			break;

		/* loop delay 500ms+alpha */
		mdelay(500);
	}

	gpio_free(PWR_LED_GPIO);
	gpio_free(CHG_LED_GPIO);

	return 0;
}

bool check_audio_keys(int key)
{
	bool ret = false;

	if (is_odroidgo3()) {
		switch (key) {
		case BTN_DPAD_UP:
		case BTN_DPAD_DOWN:
		case BTN_DPAD_LEFT:
		case BTN_DPAD_RIGHT:
		case BTN_EAST:
		case BTN_SOUTH:
		case BTN_WEST:
		case BTN_NORTH:
		case KEY_VOLUMEUP:
		case KEY_VOLUMEDOWN:
		case BTN_TL:
		case BTN_TR:
		case BTN_TL2:
		case BTN_TR2:
		case BTN_TRIGGER_HAPPY1:
		case BTN_TRIGGER_HAPPY2:
			ret = true;
			break;
		case BTN_TRIGGER_HAPPY3:
		case BTN_TRIGGER_HAPPY4:
		case BTN_TRIGGER_HAPPY5:
		case BTN_TRIGGER_HAPPY6:
		default:
			ret = false;
			break;
		}
	} else {
		switch (key) {
		case BTN_DPAD_UP:
		case BTN_DPAD_DOWN:
		case BTN_DPAD_LEFT:
		case BTN_DPAD_RIGHT:
		case BTN_EAST:
		case BTN_SOUTH:
		case BTN_WEST:
		case BTN_NORTH:
		case BTN_TL:
		case BTN_TR:
		case BTN_TL2:
		case BTN_TR2:
			ret = true;
			break;
		case BTN_TRIGGER_HAPPY1:
		case BTN_TRIGGER_HAPPY2:
		case BTN_TRIGGER_HAPPY3:
		case BTN_TRIGGER_HAPPY4:
		case BTN_TRIGGER_HAPPY5:
		case BTN_TRIGGER_HAPPY6:
		default:
			ret = false;
			break;
		}
	}

	return ret;
}

#define PHONE_DET_GPIO		86 /* GPIO2_C6 */
static int do_odroidtest_audio(cmd_tbl_t * cmdtp, int flag,
				int argc, char * const argv[])
{
	int ret;
	int key;
	int is_phone_det;

	/* draw background */
	lcd_setbg_color("black");
	lcd_clear();

	lcd_setfg_color("white");
	lcd_printf(0, 2, 1, "[ AUDIO TEST ]");

	lcd_setfg_color("grey");
	if (is_odroidgo3()) {
		lcd_printf(0, 24, 1, "During Audio Playing, Key Event is Ignored.");
		lcd_printf(0, 26, 1, "F3+F6 press to exit AUDIO test");
		lcd_printf(0, 28, 1,
				"Long press on PWR key to turn off power");
	} else {
		lcd_printf(0, 15, 1, "During Audio Playing, Key Event is Ignored.");
		lcd_printf(0, 16, 1, "F1+F6 press to exit AUDIO test");
		lcd_printf(0, 17, 1,
				"Long press on PWR key to turn off power");
	}

	/* init sound system */
	ret = sound_init(gd->fdt_blob);
	if (ret) {
		printf("Initialise Audio driver failed\n");
		lcd_printf(0, 18 + yoffs, 1, "ADC KEY TEST TERMINATED!");
		return 0;
	}

	/* init headphone detect gpio */
	gpio_request(PHONE_DET_GPIO, "phone_det");
	gpio_direction_input(PHONE_DET_GPIO);

	while (1) {
		lcd_setfg_color("yellow");

		/* 1. check headphone detect */
		is_phone_det = gpio_get_value(PHONE_DET_GPIO);
		printf("phone detected %d\n", is_phone_det);
		if (is_phone_det) {
			lcd_printf(0, 6 + yoffs, 1, "  HEADPHONE : Connected  ");
			sound_path(HP_PATH);
		} else {
			lcd_printf(0, 6 + yoffs, 1, "HEADPHONE : Disconnected");
			sound_path(SPK_PATH);
		}

		/* 2. check key event */
		key = wait_key_event(true);
		if (check_termination_key(key))
			break;

		/* 3. play test file */
		if (check_audio_keys(key)) {
			lcd_printf(0, 10 + yoffs, 1, "  Audio Playing : Running  ");
			/* if boot.wav not found, 400Hz square wave will be used */
			sound_play(1000, 400);
		}

		lcd_printf(0, 10 + yoffs, 1, "  Audio Playing : Stopped  ");
		mdelay(500);

	}

	gpio_free(PHONE_DET_GPIO);

	lcd_setfg_color("white");
	lcd_printf(0, 18 + yoffs, 1, "AUDIO TEST TERMINATED!");

	return 0;
}


static cmd_tbl_t cmd_sub_odroidtest[] = {
	U_BOOT_CMD_MKENT(all, 1, 0, do_odroidtest_all, "", ""),
	U_BOOT_CMD_MKENT(bat, 1, 0, do_odroidtest_bat, "", ""),
	U_BOOT_CMD_MKENT(btn, 1, 0, do_odroidtest_btn, "", ""),
	U_BOOT_CMD_MKENT(lcd, 1, 0, do_odroidtest_lcd, "", ""),
	U_BOOT_CMD_MKENT(backlight, 1, 0, do_odroidtest_backlight, "", ""),
	U_BOOT_CMD_MKENT(adc, 1, 0, do_odroidtest_adc, "", ""),
	U_BOOT_CMD_MKENT(audio, 1, 0, do_odroidtest_audio, "", ""),
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

	if (is_odroidgo3())
		yoffs = 4;
	else
		yoffs = 0;

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
	"odroidtest bat - battery and charge test \n"
	"odroidtest btn - gpio button test\n"
	"odroidtest lcd - lcd test\n"
	"odroidtest backlight - backlight test\n"
	"odroidtest adc - analog switch test\n"
	"odroidtest audio - audio test"
);
