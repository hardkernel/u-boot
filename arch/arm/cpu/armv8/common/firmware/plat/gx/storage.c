/*
 * Amlogic spl storage module
 * Load data from different storage device by POC setting.
 */

#include <stdio.h>
#include <romboot.h>
#include <string.h>
#include <io.h>
#include <platform_def.h>
#include <storage.h>
#include <asm/arch/secure_apb.h>

uint32_t storage_load(uint32_t src, uint32_t des, uint32_t size){
	printf("storage_load src: 0x%8x, des: 0x%8x, size: 0x%8x\n", src, des, size);
	/*add code here*/
	unsigned int boot_device = 0;
	boot_device = get_boot_device();
	//boot_device = BOOT_DEVICE_SPI;
	switch (boot_device) {
		case BOOT_DEVICE_RESERVED:
			printf("Boot device: Reserved\n");
			break;
		case BOOT_DEVICE_EMMC:
			printf("Boot device: eMMC\n");
			/*to do list*/
			break;
		case BOOT_DEVICE_NAND:
			printf("Boot device: NAND\n");
			/*to do list*/
			break;
		case BOOT_DEVICE_SPI:
			printf("Boot device: SPI\n");
			spi_read(src, des, size);
			printf("Load From SPI: OK!\n");
			break;
		case BOOT_DEVICE_SD:
			printf("Boot device: SD\n");
			/*to do list*/
			break;
		case BOOT_DEVICE_USB:
			printf("Boot device: USB\n");
			/*to do list*/
			break;
		default:
			printf("Boot device: %d\n", boot_device);
			break;
	}
	return 0;
}

uint32_t get_boot_device(void){
	printf("P_ASSIST_POR_CONFIG addr: 0x%8x\n", P_ASSIST_POR_CONFIG);
	printf("P_ASSIST_POR_CONFIG cont: 0x%8x\n", readl(P_ASSIST_POR_CONFIG));
	printf("SEC_AO_SEC_SD_CFG1 addr: 0x%8x\n", SEC_AO_SEC_SD_CFG1);
	printf("SEC_AO_SEC_SD_CFG1 cont: 0x%8x\n", readl(SEC_AO_SEC_SD_CFG1));
	return (readl(SEC_AO_SEC_SD_CFG1) & 0xf);
}

uint32_t spi_read(uint32_t src, uint32_t des, uint32_t size){
	/*spi pin mux*/
	*P_PAD_PULL_UP_EN_REG2 = 0xffff87ff;
	*P_PAD_PULL_UP_REG2 = 0xffff8700;
	// deselect nand/emmc, select spi.
	*P_PERIPHS_PIN_MUX_4 &= ~((1<<31) | (7<<22) | (1<<20));
	*P_PERIPHS_PIN_MUX_5 |= 0xf;

	/*spi init*/
	// 24:0x2ab313 pll:0x2aa949
	writel(0x2aa949,P_SPI_FLASH_CTRL);

	/*load data*/
	uint64_t des64, src64;
	des64 = des;
	src64 = src;
	printf("load tpl from spi\n");
	memcpy((void *)des64, (void *)(src64 | (uint64_t)P_SPI_START_ADDR), size);
	return 0;
}