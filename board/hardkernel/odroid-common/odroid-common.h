#ifndef __ODROID_COMMON_H
#define __ODROID_COMMON_H

/*
 * Discover the boot device within MicroSD or eMMC
 * and return 1 for eMMC, otherwise 0.
 */
#define BOOT_DEVICE_RESERVED    0
#define BOOT_DEVICE_EMMC        1
#define BOOT_DEVICE_NAND        2
#define BOOT_DEVICE_SPI         3
#define BOOT_DEVICE_SD          4
#define BOOT_DEVICE_USB         5

extern int board_led_alive(int status);
extern const char *boot_device_name(int n);
extern int get_boot_device(void);


extern int get_adc_value(int channel);

/*
 * Board revision in the form of YYYYMMDD as hexadecimal
 * ex) BOARD_REVISION(2018, 07, 16)  -> 0x20180716
 */

#define BOARD_REVISION(y,m,d)	(((0x##y & 0xffff) << 16) \
		| ((0x##m & 0xff) << 8) | ((0x##d & 0xff) << 0))

int board_revision(void);
void board_set_dtbfile(const char *format);

#if defined(CONFIG_ODROID_N2)
int board_is_odroidn2plus(void);
#elif defined(CONFIG_ODROID_C4)
int board_is_odroidc4(void);
int board_is_odroidhc4(void);
#elif defined(CONFIG_ODROID_GO4)
int board_is_odroidgo4(void);
#elif defined(CONFIG_ODROID_GOU)
int board_is_odroidgou(void);
#endif

/*
 * CVBS
 */

int board_cvbs_probe(void);

/*
 * USB Host
 */

int board_usbhost_early_power(void);
int usbhost_early_poweron(void);
int usbhost_gpio_alloc(void);
int usbhost_set_power(int on);

int board_check_odroidbios(int devno);
int board_check_recovery_image(void);

#endif
