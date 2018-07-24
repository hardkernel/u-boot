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

extern const char *boot_device_name(int n);
extern int get_boot_device(void);

#endif
