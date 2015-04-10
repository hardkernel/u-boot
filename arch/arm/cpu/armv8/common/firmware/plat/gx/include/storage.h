/*
 * Amlogic spl storage module
 * Load TPL from different storage device by POC setting.
 */

#ifndef __BL2_STORAGE_
#define __BL2_STORAGE_

/*boot device defines*/
#define BOOT_DEVICE_RESERVED            0
#define BOOT_DEVICE_EMMC                1
#define BOOT_DEVICE_NAND                2
#define BOOT_DEVICE_SPI                 3
#define BOOT_DEVICE_SD                  4
#define BOOT_DEVICE_USB                 5

uint32_t storage_load(uint32_t src, uint32_t des, uint32_t size);
uint32_t get_boot_device(void);
uint32_t spi_read(uint32_t src, uint32_t des, uint32_t size);
unsigned sdio_read_data(unsigned boot_device, uint32_t src, uint32_t des, uint32_t size);
#endif /*__BL2_STORAGE_*/