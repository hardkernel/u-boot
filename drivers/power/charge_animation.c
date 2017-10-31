/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <dm.h>
#include <errno.h>
#include <key.h>
#include <linux/input.h>
#include <pwm.h>
#include <power/charge_display.h>
#include <power/fuel_gauge.h>
#include <power/pmic.h>
#include <power/rk8xx_pmic.h>
#include <power/regulator.h>
#include <video_rockchip.h>

DECLARE_GLOBAL_DATA_PTR;

#define LONG_PRESSED_TIME			2000 /* 2s */
#define IMAGE_SHOW_RESET			-1

enum key_event {
	KEY_NOT_PRESSED = 0,
	KEY_SHORT_PRESSED,
	KEY_LONG_PRESSED,
};

struct charge_image {
	const char *name;
	int soc;
	int period;	/* ms */
};

struct charge_animation_priv {
	struct udevice *pmic;
	struct udevice *fg;
	struct udevice *pwrkey;
	const struct charge_image *image;
	int image_num;
};

struct charge_animation_pdata {
	int screen_on_voltage_threshold;
	int power_on_voltage_threshold;
	int power_on_soc_threshold;
	bool suspend_to_sram;
	bool auto_start_kernel;
};

static int charge_animation_threshold_soc(struct udevice *dev)
{
	struct charge_animation_pdata *pdata = dev_get_platdata(dev);

	if (!pdata)
		return -ENOSYS;

	return pdata->power_on_soc_threshold;
}

static int charge_animation_threshold_voltage(struct udevice *dev)
{
	struct charge_animation_pdata *pdata = dev_get_platdata(dev);

	if (!pdata)
		return -ENOSYS;

	return pdata->power_on_voltage_threshold;
}

/*
 * IF you want to use your own charge images, please:
 *
 * 1. Update the following 'image[]' to point to your own images;
 * 2. You must set the failed image as last one and soc = -1 !!!
 */
static const struct charge_image image[] = {
	{ .name = "battery_0.bmp", .soc = 5, .period = 600 },
	{ .name = "battery_1.bmp", .soc = 20, .period = 600 },
	{ .name = "battery_2.bmp", .soc = 40, .period = 600 },
	{ .name = "battery_3.bmp", .soc = 60, .period = 600 },
	{ .name = "battery_4.bmp", .soc = 80, .period = 600 },
	{ .name = "battery_5.bmp", .soc = 100, .period = 600 },
	{ .name = "battery_fail.bmp", .soc = -1, .period = 1000 },
};

static int charge_animation_ofdata_to_platdata(struct udevice *dev)
{
	struct charge_animation_pdata *pdata = dev_get_platdata(dev);

	if (dev_read_bool(dev, "charge,suspend-to-sram"))
		pdata->suspend_to_sram = true;
	else
		pdata->suspend_to_sram = false;

	if (dev_read_bool(dev, "charge,auto-start-kernel"))
		pdata->auto_start_kernel = true;
	else
		pdata->auto_start_kernel = false;

	pdata->power_on_soc_threshold =
		dev_read_u32_default(dev, "power-on-soc-threshold", 0);
	pdata->power_on_voltage_threshold =
		dev_read_u32_default(dev, "power-on-voltage-threshold", 0);
	pdata->screen_on_voltage_threshold =
		dev_read_u32_default(dev, "screen-on-voltage-threshold", 0);

	if (pdata->screen_on_voltage_threshold >
	    pdata->power_on_voltage_threshold)
		pdata->screen_on_voltage_threshold =
					pdata->power_on_voltage_threshold;

	debug("threshold soc=%d%%, voltage=%dmv, screen_on=%dmv, suspend=%d\n",
	      pdata->power_on_soc_threshold, pdata->power_on_voltage_threshold,
	      pdata->screen_on_voltage_threshold, pdata->suspend_to_sram);

	return 0;
}

static int check_key_press(struct udevice *dev, bool restar_time)
{
	static unsigned long pressed_time;
	static int old_state;
	int report = KEY_NOT_PRESSED;
	int state;

	/* just for restart time */
	if (restar_time) {
		pressed_time = get_timer(0);
		goto out;
	}

	state = key_read(dev);
	if (state < 0) {
		printf("read power key failed: %d\n", state);
		goto out;
	}

	/* Start time is not initialized, let's do it */
	if (!pressed_time && (state == KEY_PRESS_DOWN)) {
		pressed_time = get_timer(0);
		return KEY_NOT_PRESSED;
	} else {
		debug("key state = %d\n", state);

		if (state == KEY_PRESS_DOWN) {
			if (get_timer(pressed_time) >= LONG_PRESSED_TIME) {
				report = KEY_LONG_PRESSED;
				pressed_time = 0;
				old_state = KEY_LONG_PRESSED;
				printf("power key long pressed...\n");
			}
		/*
		 * If you don't check 'old_state != KEY_LONG_PRESSED', it will
		 * treat 'key long pressed' release as a 'short key pressed'
		 * release.
		 */
		} else if ((state == KEY_PRESS_UP) &&
			   (old_state != KEY_LONG_PRESSED)) {
			report = KEY_SHORT_PRESSED;
			old_state = report;
			pressed_time = 0;
			printf("power key short pressed...\n");
		} else {
			report = KEY_NOT_PRESSED;
			old_state = report;
			pressed_time = 0;
			debug("power key Not pressed...\n");
		}
	}

out:
	return report;
}

static int charge_animation_show(struct udevice *dev)
{
	struct charge_animation_pdata *pdata = dev_get_platdata(dev);
	struct charge_animation_priv *priv = dev_get_priv(dev);
	const struct charge_image *image = priv->image;
	struct udevice *pwrkey = priv->pwrkey;
	struct udevice *pmic = priv->pmic;
	struct udevice *fg = priv->fg;
	int image_num = priv->image_num;
	bool ever_lowpower_screen_off = false;
	bool screen_on = true;
	ulong show_start = 0, charge_start = 0, debug_start = 0;
	ulong ms = 0, sec = 0;
	int start_idx = 0, show_idx = -1;
	int soc, voltage, key_state;
	int i, charging = 1;

	/* Not charger online, exit */
	charging = fuel_gauge_get_chrg_online(fg);
	if (charging <= 0)
		return 0;

	voltage = fuel_gauge_get_voltage(fg);
	if (voltage < 0) {
		printf("get voltage failed: %d\n", voltage);
		return -EINVAL;
	}

	/* If low power, turn off screen */
	if (voltage <= pdata->screen_on_voltage_threshold + 50) {
		screen_on = false;
		ever_lowpower_screen_off = true;
		rockchip_show_bmp(NULL);
	}

	charge_start = get_timer(0);

	/* Charging ! */
	while (1) {
		debug("step1 (%d)... \n", screen_on);

		/* Step1: Is charging now ? */
		charging = fuel_gauge_get_chrg_online(fg);
		if (charging <= 0) {
			printf("Not charging, online=%d. Shutdown...\n",
			       charging);

			/* wait uart flush before shutdown */
			mdelay(500);

			/* PMIC shutdown */
			pmic_shutdown(pmic);

			printf("Cpu should never reach here, shutdown failed !\n");
			continue;
		}

		debug("step2 (%d)... show_idx=%d\n", screen_on, show_idx);

		/* Step2: get soc and voltage */
		soc = fuel_gauge_get_soc(fg);
		if (soc < 0 || soc > 100) {
			printf("get soc failed: %d\n", soc);
			continue;
		}

		voltage = fuel_gauge_get_voltage(fg);
		if (voltage < 0) {
			printf("get voltage failed: %d\n", voltage);
			continue;
		}

		/*
		 * Just for debug, otherwise there will be nothing output which
		 * is not good to know what happen.
		 */
		if (!debug_start)
			debug_start = get_timer(0);
		if (get_timer(debug_start) > 20000) {
			debug_start = get_timer(0);
			printf("soc=%d, vol=%d, online=%d, screen_on=%d, show_idx=%d, ever_off=%d\n",
			       soc, voltage, charging, screen_on, show_idx,
			       ever_lowpower_screen_off);
		}

		/*
		 * If ever lowpower screen off, force screen on false, which
		 * means key event can't modify screen_on, only voltage higher
		 * then threshold can update screen_on=true;
		 */
		if (ever_lowpower_screen_off)
			screen_on = false;

		/*
		 * Auto turn on screen when voltage higher than Vol screen on.
		 * 'ever_lowpower_screen_off' means enter while loop with
		 * screen off.
		 */
		if ((ever_lowpower_screen_off) &&
		    (voltage > pdata->screen_on_voltage_threshold)) {
			ever_lowpower_screen_off = false;
			screen_on = true;
			show_idx = IMAGE_SHOW_RESET;
		}

		/*
		 * IMAGE_SHOW_RESET means show_idx show be update by start_idx.
		 * When short key pressed event trigged, we will set show_idx
		 * as IMAGE_SHOW_RESET which updates images index from start_idx
		 * that calculate by current soc.
		 */
		if (show_idx == IMAGE_SHOW_RESET) {
			for (i = 0; i < image_num - 2; i++) {
				/* Find out which image we start to show */
				if ((soc >= image[i].soc) &&
				    (soc < image[i + 1].soc)) {
					start_idx = i;
					break;
				}

				if (soc >= 100) {
					start_idx = image_num - 2;
					break;
				}
			}

			debug("%s: show_idx=%d, screen_on=%d\n",
			      __func__, show_idx, screen_on);

			/* Mark start index and start time */
			show_idx = start_idx;
			show_start = get_timer(0);
		}

		debug("step3 (%d)... show_idx=%d\n", screen_on, show_idx);

		/* Step3: show images */
		if (screen_on) {
			debug("SHOW: %s\n", image[show_idx].name);
			rockchip_show_bmp(image[show_idx].name);
		} else {
			/*
			 * TODO: enter low power mode:
			 *
			 * 1. cut off some regualtors;
			 * 2. set 24MHZ for some PLLs;
			 * 3. auto turn off screen when timout;
			 * 4. power key wakeup;
			 * 5. timer period wakeup for pmic fg ?
			 */
		}

		mdelay(5);

		/* Every image shows period */
		if (get_timer(show_start) > image[show_idx].period) {
			show_start = get_timer(0);
			/* Update to next image */
			show_idx++;
			if (show_idx > (image_num - 2))
				show_idx = IMAGE_SHOW_RESET;
		}

		debug("step4 (%d)... \n", screen_on);

		/*
		 * Step4: check key event.
		 *
		 * Short key event: turn on/off screen;
		 * Long key event: show logo and boot system or still charging.
		 */
		key_state = check_key_press(pwrkey, false);
		if (key_state == KEY_SHORT_PRESSED) {
			/* NULL means show nothing, ie. turn off screen */
			if (screen_on)
				rockchip_show_bmp(NULL);

			/*
			 * Clear current image index, and show image
			 * from start_idx
			 */
			show_idx = IMAGE_SHOW_RESET;

			/*
			 * We turn off screen by rockchip_show_bmp(NULL), so we
			 * should tell while loop to stop show images any more.
			 *
			 * If screen_on=false, means this short key pressed
			 * event turn on the screen and we need show images.
			 *
			 * If screen_on=true, means this short key pressed
			 * event turn off the screen and we never show images.
			 */
			if (screen_on)
				screen_on = false;
			else
				screen_on = true;
		} else if (key_state == KEY_LONG_PRESSED) {
			/* Only long pressed while screen off needs screen_on true */
			if (!screen_on)
				screen_on = true;

			/* Is able to boot now ? */
			if (soc < pdata->power_on_soc_threshold) {
				printf("soc=%d%%, threshold soc=%d%%\n",
				       soc, pdata->power_on_soc_threshold);
				printf("Low power, unable to boot, charging...\n");
				/* 'true': just for clear time of check key */
				check_key_press(pwrkey, true);
				show_idx = image_num - 1;
				continue;
			}

			if (voltage < pdata->power_on_voltage_threshold) {
				printf("voltage=%dmv, threshold voltage=%dmv\n",
				       voltage, pdata->power_on_voltage_threshold);
				printf("Low power, unable to boot, charging...\n");
				/* 'true': just for clear time of check key */
				check_key_press(pwrkey, true);
				show_idx = image_num - 1;
				continue;
			}

			/* Success exit charging */
			printf("Exit charge animation...\n");
			rockchip_show_logo();
			break;
		} else {
			/* Do nothing */
		}

		debug("step5 (%d)... \n", screen_on);

		/*
		 * Step5: Check auto start kernel
		 */
		if (pdata->auto_start_kernel) {
			if ((voltage >= pdata->power_on_voltage_threshold) &&
			    (soc >= pdata->power_on_soc_threshold)) {
				printf("Auto start, exit charge animation..\n");
				rockchip_show_logo();
				break;
			}
		}
	}

	ms = get_timer(charge_start);
	if (ms >= 1000) {
		sec = ms / 1000;
		ms = ms % 1000;
	}

	printf("charging time total: %lu.%lus, soc=%d%%, vol=%dmv\n",
	       sec, ms, soc, voltage);

	return 0;
}

static const struct dm_charge_display_ops charge_animation_ops = {
	.get_power_on_soc = charge_animation_threshold_soc,
	.get_power_on_voltage = charge_animation_threshold_voltage,
	.show = charge_animation_show,
};

static int charge_animation_probe(struct udevice *dev)
{
	struct charge_animation_priv *priv = dev_get_priv(dev);
	struct udevice *pwrkey, *fg, *pmic;
	int ret;

	/* Get PMIC */
	ret = uclass_get_device(UCLASS_PMIC, 0, &pmic);
	if (ret) {
		printf("Get UCLASS PMIC failed: %d\n", ret);
		return ret;
	}
	priv->pmic = pmic;

	/* Get power key */
	for (uclass_first_device(UCLASS_KEY, &pwrkey);
	     pwrkey;
	     uclass_next_device(&pwrkey)) {
		if (key_type(pwrkey) == KEY_POWER) {
			priv->pwrkey = pwrkey;
			break;
		}
	}
	if (!priv->pwrkey) {
		printf("Can't find any power key\n");
		return -ENOSYS;
	}

	/* Get fuel gauge */
	ret = uclass_get_device(UCLASS_FG, 0, &fg);
	if (ret) {
		printf("Get UCLASS FG failed: %d\n", ret);
		return ret;
	}
	priv->fg = fg;

	/* Get image */
	priv->image = image;
	priv->image_num = ARRAY_SIZE(image);

	printf("Enable charge animation display\n");

	return 0;
}

static const struct udevice_id charge_animation_ids[] = {
	{ .compatible = "charge-animation" },
	{ },
};

U_BOOT_DRIVER(charge_animation) = {
	.name = "charge-animation",
	.id = UCLASS_CHARGE_DISPLAY,
	.probe = charge_animation_probe,
	.of_match = charge_animation_ids,
	.ops = &charge_animation_ops,
	.ofdata_to_platdata = charge_animation_ofdata_to_platdata,
	.platdata_auto_alloc_size = sizeof(struct charge_animation_pdata),
	.priv_auto_alloc_size = sizeof(struct charge_animation_priv),
};
