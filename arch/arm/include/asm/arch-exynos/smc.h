/*
 * Copyright (c) 2011 Samsung Electronics Co., Ltd.
 *
 * "SMC CALL COMMAND"
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 */

#include <common.h>
#include <config.h>
#include <asm/arch/movi_partition.h>
#include <asm/arch/cpu.h>

#define SMC_CMD_LOAD_UBOOT		(-230)
#define SMC_CMD_COLDBOOT		(-231)
#define SMC_CMD_WARMBOOT		(-232)
#define SMC_CMD_CHECK_SECOND_BOOT	(-233)
#define SMC_CMD_EMMC_ENDBOOTOP          (-234)
#define SMC_CMD_SDMMC_ENUMERATE         (-235)
#define SMC_CMD_SET_SECURE_REG		(-236)

#ifdef CONFIG_UBOOT_SECURE_BOOT
#define SMC_UBOOT_SIGNATURE_SIZE	256
#else
#define SMC_UBOOT_SIGNATURE_SIZE	0
#endif

#ifdef CONFIG_TZSW_SECURE_BOOT
#define SMC_TZSW_SIGNATURE_SIZE         256
#else
#define SMC_TZSW_SIGNATURE_SIZE         0
#endif

#define CONFIG_IMAGE_INFO_BASE		(CONFIG_SYS_SDRAM_BASE)
#define CONFIG_PHY_UBOOT_BASE		(CONFIG_SYS_TEXT_BASE)
#define SMC_SECURE_CONTEXT_BASE		(CONFIG_PHY_IRAM_BASE + 0x4c00)
#ifdef CONFIG_CPU_EXYNOS5420
#define CONFIG_PHY_TZSW_BASE		(CONFIG_PHY_IRAM_BASE + 0x10000)
#else
#define CONFIG_PHY_TZSW_BASE		(CONFIG_PHY_IRAM_BASE + 0x8000)
#endif

typedef struct sdmmc_dev {
	/* for SDMMC */
	u32	image_pos;
	u32	blkcnt;
	u32	base_addr;
} sdmmc_t;

typedef struct emmc_dev {
	/* for eMMC */
	u32	blkcnt;
	u32	base_addr;
} emmc_t;

typedef struct sata_dev {
	/* for SATA */
	u64	read_sector_of_hdd;
	u32	trans_byte;
	u32	*read_buffer;
	u32	position_of_mem;
} sata_t;

typedef struct sfmc_dev {
	/* for SFMC */
	u32	cs;
	u32	byte_offset;
	u32	byte_size;
	void	*dest_addr;
} sfmc_t;

typedef struct spi_sf_dev {
	/* for SPI SERIAL FLASH */
	u32	flash_read_addr;
	u32	read_size;
	u8	*read_buff;
} spi_sf_t;

/* boot device */
typedef union boot_device_u {
	sdmmc_t 	sdmmc;
	emmc_t		emmc;
	sata_t		sata;
	sfmc_t		sfmc;
	spi_sf_t	spi_sf;
} boot_device_t;

typedef struct ld_image_info {
	/* for Signature */
	u32	image_base_addr;
	u32	size;
	u32	secure_context_base;
	u32	signature_size;
	boot_device_t bootdev;

} image_info;

typedef struct reg_val {
	u32	addr;
	u32	val;
} reg_val_t;

typedef struct reg_arr {
	reg_val_t	set0;
	reg_val_t	set1;
	reg_val_t	set2;
	reg_val_t	set3;
	reg_val_t	set4;
	reg_val_t	set5;
	reg_val_t	set6;
	reg_val_t	set7;
	reg_val_t	set8;
	reg_val_t	set9;
} reg_arr_t;

unsigned int load_uboot_image(u32 boot_device);
unsigned int coldboot(u32 boot_device);
void warmboot(void);
unsigned int find_second_boot(void);
void emmc_endbootop(void);
void set_secure_reg(u32 reg_val, u32 num);


