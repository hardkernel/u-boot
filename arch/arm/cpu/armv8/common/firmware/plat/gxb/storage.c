/*
 * Copyright (c) 2015 Amlogic, Inc. All rights reserved.
 *
 * This source code is subject to the terms and conditions defined in the
 * file 'LICENSE' which is part of this source code package.
 *
 *
 * Amlogic storage load module
 * Author: larson.jiang@amlogic.com, xiaobo.gu@amlogic.com
 * Created time: 2015.04.22
 *
 */

#include <stdio.h>
#include <stdint.h>
#include <asm/arch/romboot.h>
#include <string.h>
#include <io.h>
#include <platform_def.h>
#include <storage.h>
#include <asm/arch/io.h>
#include <asm/arch/secure_apb.h>
#include <asm/arch/cpu_sdio.h>
#include <usb.h>

uint64_t storage_load(uint64_t src, uint64_t des, uint64_t size, const char * image_name)
{
	char * device_name = "UNKNOWN";
	uint64_t boot_device = 0;

	boot_device = get_boot_device();
	//boot_device = BOOT_DEVICE_SPI;
	switch (boot_device) {
		case BOOT_DEVICE_RESERVED:
			device_name = "Reserved";
			break;
		case BOOT_DEVICE_EMMC:
			device_name = "eMMC";
			break;
		case BOOT_DEVICE_NAND:
			device_name = "NANE";
			break;
		case BOOT_DEVICE_SPI:
			device_name = "SPI";
			break;
		case BOOT_DEVICE_SD:
			device_name = "SD";
			break;
		case BOOT_DEVICE_USB:
			device_name = "USB";
			break;
		default:
			break;
	}
	printf("Load %s from %s, src: 0x%x, dst: 0x%x, size: 0x%x\n",
		image_name, device_name, src, des, size);
	switch (boot_device) {
		case BOOT_DEVICE_RESERVED:
			break;
		case BOOT_DEVICE_EMMC:
			sdio_read_data(boot_device,src, des, size);
			break;
		case BOOT_DEVICE_NAND:
			/*to do list*/
			break;
		case BOOT_DEVICE_SPI:
			spi_read(src, des, size);
			break;
		case BOOT_DEVICE_SD:
			sdio_read_data(boot_device, src, des, size);
			break;
		case BOOT_DEVICE_USB:
			/*to do list*/
			break;
		default:
			break;
	}
	return 0;
}

uint64_t get_boot_device(void)
{
	//printf("P_ASSIST_POR_CONFIG addr: 0x%8x\n", P_ASSIST_POR_CONFIG);
	//printf("P_ASSIST_POR_CONFIG cont: 0x%8x\n", readl(P_ASSIST_POR_CONFIG));
	//printf("SEC_AO_SEC_GP_CFG0 addr: 0x%8x\n", SEC_AO_SEC_GP_CFG0);
	//printf("SEC_AO_SEC_GP_CFG0 cont: 0x%8x\n", readl(SEC_AO_SEC_GP_CFG0));
	return (readl(SEC_AO_SEC_GP_CFG0) & 0xf);
}

uint64_t spi_read(uint64_t src, uint64_t des, uint64_t size)
{
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
	memcpy((void *)des64, (void *)(src64 | (uint64_t)P_SPI_START_ADDR), size);
	return 0;
}

uint64_t sdio_read_blocks(struct sd_emmc_global_regs *sd_emmc_regs,
			uint64_t src, uint64_t des, uint64_t size, uint64_t mode)
{
	unsigned ret = 0;
	unsigned read_start;
	unsigned vstart = 0;
	unsigned status_irq = 0;
	unsigned response[4];
	struct cmd_cfg *des_cmd_cur = NULL;
	struct sd_emmc_desc_info desc[MAX_DESC_NUM];
	struct sd_emmc_desc_info *desc_cur;
	struct sd_emmc_start *desc_start = (struct sd_emmc_start*)&vstart;
	struct sd_emmc_status *status_irq_reg = (void *)&status_irq;

	memset(desc,0,MAX_DESC_NUM*sizeof(struct sd_emmc_desc_info));
	desc_cur = desc;

	if (mode)
		read_start = src>>9;
	else
		read_start = src;

	des_cmd_cur = (struct cmd_cfg *)&(desc_cur->cmd_info);
	//starting reading......
	des_cmd_cur->cmd_index = 18;  //read data command
    if (mode) {
		des_cmd_cur->block_mode = 1;
		des_cmd_cur->length = size;
	}else{
		des_cmd_cur->block_mode = 0;
		des_cmd_cur->length = size;
	}

	des_cmd_cur->data_io = 1;
	des_cmd_cur->data_wr = 0;
	des_cmd_cur->data_num = 0;
	des_cmd_cur->no_resp = 0;
	des_cmd_cur->resp_num = 0;
	des_cmd_cur->timeout = 7;
	des_cmd_cur->owner = 1;
	des_cmd_cur->end_of_chain = 1;

	desc_cur->cmd_arg = read_start;
	desc_cur->data_addr = des;
	desc_cur->data_addr &= ~(1<<0);   //DDR
	desc_cur->resp_addr = (unsigned long)response;

	desc_start->init = 0;
	desc_start->busy = 1;
	desc_start->addr = (unsigned long)desc >> 2;
	sd_emmc_regs->gstatus = 0x3fff;
	//sd_emmc_regs->gstart = vstart;
	sd_emmc_regs->gcmd_cfg = desc_cur->cmd_info;
	sd_emmc_regs->gcmd_dat = desc_cur->data_addr;
	sd_emmc_regs->gcmd_arg = desc_cur->cmd_arg;


	while (1) {
		status_irq = sd_emmc_regs->gstatus;
		if (status_irq_reg->end_of_chain)
			break;
	}
	//send stop cmd
	desc_cur = &desc[1];
	des_cmd_cur = (struct cmd_cfg *)&(desc_cur->cmd_info);
	des_cmd_cur->cmd_index = 12;
	des_cmd_cur->data_io = 0;
	des_cmd_cur->no_resp = 0;
	des_cmd_cur->r1b = 1;
	des_cmd_cur->owner = 1;
	des_cmd_cur->end_of_chain = 1;

	desc_start->init = 0;
	desc_start->busy = 1;
	desc_start->addr = (unsigned long)desc_cur >> 2;
	sd_emmc_regs->gstatus = 0x3fff;
	//sd_emmc_regs->gstart = vstart;
	sd_emmc_regs->gcmd_cfg = desc_cur->cmd_info;
	sd_emmc_regs->gcmd_dat = desc_cur->data_addr;
	sd_emmc_regs->gcmd_arg = desc_cur->cmd_arg;

	while (1) {
		status_irq = sd_emmc_regs->gstatus;
		//printf("status_irq=0x%x\n",status_irq);
		if (status_irq_reg->end_of_chain)
			break;
	}

	if (status_irq_reg->rxd_err)
		ret |= SD_EMMC_RXD_ERROR;
	if (status_irq_reg->txd_err)
		ret |= SD_EMMC_TXD_ERROR;
	if (status_irq_reg->desc_err)
		ret |= SD_EMMC_DESC_ERROR;
	if (status_irq_reg->resp_err)
		ret |= SD_EMMC_RESP_CRC_ERROR;
	if (status_irq_reg->resp_timeout)
		ret |= SD_EMMC_RESP_TIMEOUT_ERROR;
	if (status_irq_reg->desc_timeout)
		ret |= SD_EMMC_DESC_TIMEOUT_ERROR;
	if (ret)
		printf("sd/emmc read data error: %d\n",ret);
	printf("read data success!\n");
	return ret;
}

uint64_t sdio_read_data(uint64_t boot_device, uint64_t src, uint64_t des, uint64_t size)
{
	unsigned mode = 1,blk_cnt,ret;
	struct sd_emmc_global_regs *sd_emmc_regs=0;

	if (boot_device == BOOT_DEVICE_EMMC)
		sd_emmc_regs = (struct sd_emmc_global_regs *)SD_EMMC_BASE_C;
	else if(boot_device == BOOT_DEVICE_SD)
		sd_emmc_regs = (struct sd_emmc_global_regs *)SD_EMMC_BASE_B;
	else
		printf("sd/emmc boot device error\n");

	blk_cnt = ((size+511)&(~(511)))>>9;
	do {
		ret = sdio_read_blocks(sd_emmc_regs,src,des,(blk_cnt>MAX_BLOCK_COUNTS)?MAX_BLOCK_COUNTS:blk_cnt,mode);
		if (ret)
			return ret;
		if (blk_cnt>MAX_BLOCK_COUNTS) {
			src += MAX_BLOCK_COUNTS<<9;
			des += MAX_BLOCK_COUNTS<<9;
			blk_cnt -= MAX_BLOCK_COUNTS;
		}else
			break;
	}while(1);

	return ret;
}

