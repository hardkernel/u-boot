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

static int board_rev = -1;

#define IS_RANGE(x, min, max)   ((x) > (min) && (x) < (max))

static unsigned int get_hw_revision(void)
{
	int hwrev = -1;
	int adc = get_adc_value(1);

#if defined(CONFIG_ODROID_N2)
	if (IS_RANGE(adc, 80, 90))		/* ave : 84 */
		hwrev = BOARD_REVISION(2018, 7, 23);
	else if (IS_RANGE(adc, 160, 170))	/* avg : 164 */
		hwrev = BOARD_REVISION(2018, 12, 6);
	else if (IS_RANGE(adc, 245, 255))	/* avg : 248 */
		hwrev = BOARD_REVISION(2019, 1, 17);
	else if (IS_RANGE(adc, 330, 350))	/* avg : 334 */
		hwrev = BOARD_REVISION(2019, 2, 7);
	else if (IS_RANGE(adc, 410, 430)) {	/* avg : 419 */
		/* ODROID-N2plus */
		hwrev = BOARD_REVISION(2019, 11, 20);
	} else if (IS_RANGE(adc, 500, 520)) {
		hwrev = BOARD_REVISION(2021,  1, 21);
	}
#elif defined(CONFIG_ODROID_C4)
	if (IS_RANGE(adc, 80, 100))	/* avg : 90 */
		hwrev = BOARD_REVISION(2020, 1, 29);
	else if (IS_RANGE(adc, 300, 320))	/* avg : 308 */
		hwrev = BOARD_REVISION(2019, 12, 10);
	else if (IS_RANGE(adc, 335, 345))	/* avg : 341 */
		hwrev = BOARD_REVISION(2019, 11, 29);
	else if (IS_RANGE(adc, 590, 610))	/* avg : 604 */
		hwrev = BOARD_REVISION(2020, 8, 7);
#endif

	debug("ADC=%d, hwrev=0x%x\n", adc, hwrev);

	return hwrev;
}

int board_revision(void)
{
	if (board_rev == -1)
		board_rev = get_hw_revision();

	return board_rev;
}

void board_set_dtbfile(const char *format)
{
	char s[128];
	char *ep = getenv("variant");

	snprintf(s, sizeof(s), format, ep ? ep : "");
	setenv("fdtfile", s);
}

#if defined(CONFIG_ODROID_N2)
int board_is_odroidn2(void)
{
	int hwrev = board_revision();

	return (hwrev == BOARD_REVISION(2018, 7, 23))
		|| (hwrev == BOARD_REVISION(2018, 12, 6))
		|| (hwrev == BOARD_REVISION(2019, 1, 17))
		|| (hwrev == BOARD_REVISION(2019, 2, 7));
}

int board_is_odroidn2plus(void)
{
	return !board_is_odroidn2();
}
#elif defined(CONFIG_ODROID_C4)
int board_is_odroidc4(void)
{
	int hwrev = board_revision();

	return (hwrev == BOARD_REVISION(2019, 11, 29))
		|| (hwrev == BOARD_REVISION(2020, 1, 29));
}

int board_is_odroidhc4(void)
{
	int hwrev = board_revision();

	return (hwrev == BOARD_REVISION(2019, 12, 10))
		|| (hwrev == BOARD_REVISION(2020, 8, 7));
}
#endif
