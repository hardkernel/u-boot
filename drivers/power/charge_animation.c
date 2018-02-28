/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <boot_rkimg.h>
#include <console.h>
#include <dm.h>
#include <errno.h>
#include <key.h>
#include <pwm.h>
#include <irq-generic.h>
#include <asm/arch/rockchip_smccc.h>
#include <asm/suspend.h>
#include <linux/input.h>
#include <power/charge_display.h>
#include <power/charge_animation.h>
#include <power/rockchip_pm.h>
#include <power/fuel_gauge.h>
#include <power/pmic.h>
#include <power/rk8xx_pmic.h>
#include <power/regulator.h>
#include <video_rockchip.h>

DECLARE_GLOBAL_DATA_PTR;

#define IMAGE_SHOW_RESET			-1

struct charge_image {
	const char *name;
	int soc;
	int period;	/* ms */
};

struct charge_animation_priv {
	struct udevice *pmic;
	struct udevice *fg;
	const struct charge_image *image;
	int image_num;
};

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

	/* charge mode */
	pdata->uboot_charge =
		dev_read_u32_default(dev, "rockchip,uboot-charge-on", 0);
	pdata->android_charge =
		dev_read_u32_default(dev, "rockchip,android-charge-on", 0);

	pdata->exit_charge_level =
		dev_read_u32_default(dev, "rockchip,uboot-exit-charge-level", 0);
	pdata->exit_charge_voltage =
		dev_read_u32_default(dev, "rockchip,uboot-exit-charge-voltage", 0);

	pdata->low_power_voltage =
		dev_read_u32_default(dev, "rockchip,uboot-low-power-voltage", 0);

	pdata->screen_on_voltage =
		dev_read_u32_default(dev, "rockchip,screen-on-voltage", 0);
	pdata->system_suspend =
		dev_read_u32_default(dev, "rockchip,system-suspend", 0);

	if (pdata->screen_on_voltage > pdata->exit_charge_voltage)
		pdata->screen_on_voltage = pdata->exit_charge_voltage;

	debug("mode: uboot=%d, android=%d; exit: soc=%d%%, voltage=%dmv;\n"
	      "lp_voltage=%d%%, screen_on=%dmv\n",
	      pdata->uboot_charge, pdata->android_charge,
	      pdata->exit_charge_level, pdata->exit_charge_voltage,
	      pdata->low_power_voltage, pdata->screen_on_voltage);

	return 0;
}

static int check_key_press(void)
{
	u32 state;

	state = platform_key_read(KEY_POWER);
	if (state < 0)
		printf("read power key failed: %d\n", state);

	return state;
}

static int system_suspend_enter(struct charge_animation_pdata *pdata)
{
	/*
	 * TODO: enter low power mode:
	 * 3. auto turn off screen when timout;
	 * 4. power key wakeup;
	 * 5. timer period wakeup for pmic fg
	 */
	if (pdata->system_suspend && IS_ENABLED(CONFIG_ARM_SMCCC)) {
		printf("\nSystem suspend: ");
		putc('1');
		local_irq_disable();
		putc('2');
		irqs_suspend();
		putc('3');
		device_suspend();
		putc('4');
		putc('\n');

		/* Trap into ATF for low power mode */
		cpu_suspend(0, psci_system_suspend);

		putc('\n');
		putc('4');
		device_resume();
		putc('3');
		irqs_resume();
		putc('2');
		local_irq_enable();
		putc('1');
		putc('\n');
	} else {
		printf("\nWfi\n");
		wfi();
	}

	/*
	 * We must wait for key release event finish, otherwise
	 * we may read key state too early.
	 */
	mdelay(300);

	return 0;
}

#ifdef CONFIG_DRM_ROCKCHIP
static void charge_show_bmp(const char *name)
{
	rockchip_show_bmp(name);
}

static void charge_show_logo(void)
{
	rockchip_show_logo();
}
#else
static void charge_show_bmp(const char *name) {}
static void charge_show_logo(void) {}
#endif

static int charge_extrem_low_power(struct udevice *dev)
{
	struct charge_animation_pdata *pdata = dev_get_platdata(dev);
	struct charge_animation_priv *priv = dev_get_priv(dev);
	struct udevice *pmic = priv->pmic;
	struct udevice *fg = priv->fg;
	int voltage, soc, charging = 1;

	voltage = fuel_gauge_get_voltage(fg);
	if (voltage < 0)
		return -EINVAL;

	while (voltage < pdata->low_power_voltage + 50) {
		/* Check charger online */
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

		/*
		 * Just for fuel gauge to update something important,
		 * including charge current, coulometer or other.
		 */
		soc = fuel_gauge_get_soc(fg);
		if (soc < 0 || soc > 100) {
			printf("get soc failed: %d\n", soc);
			continue;
		}

		printf("Extrem low power, force charging... threshold=%dmv, now=%dmv\n",
		       pdata->low_power_voltage, voltage);

		/* System suspend */
		system_suspend_enter(pdata);

		/* Update voltage */
		voltage = fuel_gauge_get_voltage(fg);
		if (voltage < 0) {
			printf("get voltage failed: %d\n", voltage);
			continue;
		}
	}

	return 0;
}

static int charge_animation_show(struct udevice *dev)
{
	struct charge_animation_pdata *pdata = dev_get_platdata(dev);
	struct charge_animation_priv *priv = dev_get_priv(dev);
	const struct charge_image *image = priv->image;
	struct udevice *pmic = priv->pmic;
	struct udevice *fg = priv->fg;
	const char *preboot = env_get("preboot");
	int image_num = priv->image_num;
	bool ever_lowpower_screen_off = false;
	bool screen_on = true;
	ulong show_start = 0, charge_start = 0, debug_start = 0;
	ulong ms = 0, sec = 0;
	int start_idx = 0, show_idx = -1;
	int soc, voltage, current, key_state;
	int i, charging = 1, ret;
	int boot_mode;

/*
 * Check sequence:
 *
 * 1. Extrem low power charge?
 * 2. Preboot cmd?
 * 3. Valid boot mode?
 * 4. U-Boot charge enabled by dts config?
 * 5. Screen off before charge?
 * 6. Enter charge !
 *
 */
	/* Extrem low power charge */
	ret = charge_extrem_low_power(dev);
	if (ret < 0) {
		printf("extrem low power charge failed, ret=%d\n", ret);
		return ret;
	}

	/* If there is preboot command, exit */
	if (preboot) {
		debug("preboot: %s\n", preboot);
		return 0;
	}

	/* Not valid charge mode, exit */
#ifdef CONFIG_RKIMG_BOOTLOADER
	boot_mode = rockchip_get_boot_mode();
	if ((boot_mode != BOOT_MODE_CHARGING) &&
	    (boot_mode != BOOT_MODE_UNDEFINE)) {
		debug("exit charge, due to boot mode: %d\n", boot_mode);
		return 0;
	}
#endif

	/* Enter android charge, set property for kernel */
	if (pdata->android_charge) {
		env_update("bootargs", "androidboot.mode=charger");
		printf("Android charge mode\n");
	}

	/* Not enable U-Boot charge, exit */
	if (!pdata->uboot_charge)
		return 0;

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
	if (voltage <= pdata->screen_on_voltage + 50) {
		screen_on = false;
		ever_lowpower_screen_off = true;
		charge_show_bmp(NULL);
	}

	printf("Enter U-Boot charging mode\n");

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

		current = fuel_gauge_get_current(fg);
		if (current == -ENOSYS) {
			printf("get current failed: %d\n", current);
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
			printf("[%8ld]: soc=%d%%, vol=%dmv, c=%dma, online=%d, screen_on=%d\n",
			       get_timer(0)/1000, soc, voltage,
			       current, charging, screen_on);
		}

		/*
		 * If ever lowpower screen off, force screen_on=false, which
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
		    (voltage > pdata->screen_on_voltage)) {
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
			charge_show_bmp(image[show_idx].name);
		} else {
			system_suspend_enter(pdata);
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
		key_state = check_key_press();
		if (key_state == KEY_PRESS_DOWN) {
			/* NULL means show nothing, ie. turn off screen */
			if (screen_on)
				charge_show_bmp(NULL);

			/*
			 * Clear current image index, and show image
			 * from start_idx
			 */
			show_idx = IMAGE_SHOW_RESET;

			/*
			 * We turn off screen by charge_show_bmp(NULL), so we
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
		} else if (key_state == KEY_PRESS_LONG_DOWN) {
			/* Only long pressed while screen off needs screen_on true */
			if (!screen_on)
				screen_on = true;

			/* Is able to boot now ? */
			if (soc < pdata->exit_charge_level) {
				printf("soc=%d%%, threshold soc=%d%%\n",
				       soc, pdata->exit_charge_level);
				printf("Low power, unable to boot, charging...\n");
				show_idx = image_num - 1;
				continue;
			}

			if (voltage < pdata->exit_charge_voltage) {
				printf("voltage=%dmv, threshold voltage=%dmv\n",
				       voltage, pdata->exit_charge_voltage);
				printf("Low power, unable to boot, charging...\n");
				show_idx = image_num - 1;
				continue;
			}

			/* Success exit charging */
			printf("Exit charge animation...\n");
			charge_show_logo();
			break;
		} else {
			/* Do nothing */
		}

		debug("step5 (%d)... \n", screen_on);

		/* Step5: Exit by ctrl+c */
		if (ctrlc()) {
			if (voltage >= pdata->screen_on_voltage)
				charge_show_logo();
			printf("Exit charge, due to ctrl+c\n");
			break;
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
	.show = charge_animation_show,
};

static int charge_animation_probe(struct udevice *dev)
{
	struct charge_animation_priv *priv = dev_get_priv(dev);
	struct udevice *fg, *pmic;
	int ret, soc;

	/* Get PMIC: used for power off system  */
	ret = uclass_get_device(UCLASS_PMIC, 0, &pmic);
	if (ret) {
		printf("Get UCLASS PMIC failed: %d\n", ret);
		return ret;
	}
	priv->pmic = pmic;

	/* Get fuel gauge: used for charging */
	ret = uclass_get_device(UCLASS_FG, 0, &fg);
	if (ret) {
		printf("Get UCLASS FG failed: %d\n", ret);
		return ret;
	}
	priv->fg = fg;

	/* Get PWRKEY: used for wakeup and trun off/on LCD */
	ret = platform_key_read(KEY_POWER);
	if (ret == KEY_NOT_EXIST) {
		printf("Can't find power key\n");
		return -EINVAL;
	}

	/* Initialize charge current */
	soc = fuel_gauge_get_soc(fg);
	if (soc < 0 || soc > 100) {
		printf("get soc failed: %d\n", soc);
		return -EINVAL;
	}

	/* Get charge images */
	priv->image = image;
	priv->image_num = ARRAY_SIZE(image);

	printf("Enable charge animation display\n");

	return 0;
}

static const struct udevice_id charge_animation_ids[] = {
	{ .compatible = "rockchip,uboot-charge" },
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
