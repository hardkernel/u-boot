#ifndef __RK_BLK_H_
#define __RK_BLK_H_

/*
 * boot device type define
 * 1:flash 2:emmc 4:sdcard0 8:sdcard1
 */
#define BOOT_FROM_FLASH		(1 << 0)
#define BOOT_FROM_EMMC		(1 << 1)
#define BOOT_FROM_SD0		(1 << 2)
#define BOOT_FROM_SD1		(1 << 3)
#define BOOT_FROM_SPI_NOR	(1 << 4)
#define BOOT_FROM_RAM		(1 << 5)
#define BOOT_FROM_SPI_NAND	(1 << 6)

int blkdev_read(void *buffer, u32 blk, u32 cnt);
int blkdev_write(void *buffer, u32 blk, u32 cnt);
int get_bootdev_type(void);

#endif
