#ifndef _PARTITION_TABLE_H
#define _PARTITION_TABLE_H
// #ifdef CONFIG_STORE_COMPATIBLE
#include <storage.h>
// #endif
//#include <asm/arch/nand.h>
//#include <asm/arch/poc.h>


//#define STORE_DBG
#ifdef STORE_DBG
#define store_dbg(fmt, ...) printk( "%s: line:%d " fmt "\n", \
				  __func__, __LINE__, ##__VA_ARGS__)

#define store_msg(fmt, ...) printk( "%s: line:%d " fmt "\n", \
				  __func__, __LINE__, ##__VA_ARGS__)
#else
#define store_dbg(fmt, ...)
#define store_msg(fmt, ...) printk( fmt "\n",  ##__VA_ARGS__)
#endif

//boot_flag
//#define R_BOOT_DEVICE_FLAG  READ_CBUS_REG(ASSIST_POR_CONFIG)

//#if MESON_CPU_TYPE >= MESON_CPU_TYPE_MESON8
//#define POR_BOOT_VALUE 	((((R_BOOT_DEVICE_FLAG>>9)&1)<<2)|((R_BOOT_DEVICE_FLAG>>6)&3))
//#else
//#define POR_BOOT_VALUE 	(R_BOOT_DEVICE_FLAG & 7)
//#endif

//#if 1 /*defined in poc.h*/
//#define POR_NAND_BOOT()	 ((POR_BOOT_VALUE == 7) || (POR_BOOT_VALUE == 6))
//#define POR_SPI_BOOT()  		((POR_BOOT_VALUE == 5) || (POR_BOOT_VALUE == 4))
//#define POR_EMMC_BOOT()	((IS_MESON_M8M2_CPU | IS_MESON_M8BABY_CPU)?((POR_BOOT_VALUE == 3) || ((POR_BOOT_VALUE == 1))):(POR_BOOT_VALUE == 3))
//#define POR_CARD_BOOT() 	(POR_BOOT_VALUE == 0)
//#endif

#define SPI_BOOT_FLAG 			0
#define NAND_BOOT_FLAG 		1
#define EMMC_BOOT_FLAG 		2
#define CARD_BOOT_FLAG 		3
#define SPI_NAND_FLAG			4
#define SPI_EMMC_FLAG			5

#define _AML_DEVICE_BOOT_FLAG_DEFAULT   (0XFFFFFFFF)
extern unsigned  device_boot_flag;

#define START_ADDR 			0xd9000200
#define TABLE_MAGIC_NAME  		"part"
#define STORE_MAGIC_NAME  		"stor"
#define ACS_SET_LEN 			 128

extern int info_disprotect;

#define DISPROTECT_KEY    		1
#define DISPROTECT_SECURE		1<<1
#define DISPROTECT_FBBT		1<<2
#define DISPROTECT_HYNIX		1<<3

extern int get_partition_from_dts(unsigned char * buffer);

extern int get_partitions_table(struct partitions **table);

#define AML_DTB_IMG_MAX_SZ  ((256<<10) - 512)

#endif// #ifndef _PARTITION_TABLE_H

