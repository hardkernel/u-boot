#include <common.h>
#include <errno.h>
#include <asm/io.h>
#include <asm/arch/secure_apb.h>
#include <asm-generic/gpio.h>
#include <asm/arch/gpio.h>
#include <linux/kernel.h>

#include <odroid-common.h>

#define GPIO_LED_ALIVE		11	// GPIOAO_11

int board_led_alive(int status)
{
	int ret = gpio_request(GPIO_LED_ALIVE, "alive");
	if (ret < 0) {
		printf("Failed to request GPIO pin %u\n", GPIO_LED_ALIVE);
		return -EINVAL;
	}

	return gpio_direction_output(GPIO_LED_ALIVE, status & 1);
}

const char *boot_device_name(int n)
{
	struct names {
		int id;
		const char* name;
	} names[] = {
		{ BOOT_DEVICE_RESERVED, "reserved" },
		{ BOOT_DEVICE_EMMC, "emmc" },
		{ BOOT_DEVICE_NAND, "nand" },
		{ BOOT_DEVICE_SPI, "spi" },
		{ BOOT_DEVICE_SD, "sd" },
		{ BOOT_DEVICE_USB, "usb" },
	};
	int i;

	for (i = 0; i < ARRAY_SIZE(names); i++)
		if (names[i].id == n)
			return names[i].name;

	return NULL;
}

int get_boot_device(void)
{
	return readl(AO_SEC_GP_CFG0) & 0xf;
}
