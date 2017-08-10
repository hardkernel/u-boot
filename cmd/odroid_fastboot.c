/*
 * Copyright 2008 - 2009 Windriver, <www.windriver.com>
 * Author: Tom Rix <Tom.Rix@windriver.com>
 *
 * (C) Copyright 2014 Linaro, Ltd.
 * Rob Herring <robh@kernel.org>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */
#include <common.h>
#include <command.h>
#include <console.h>
#include <malloc.h>

#include <mach/power.h>
#include <fastboot.h>
#include <samsung/odroid_misc.h>
#include <mmc.h>

/*---------------------------------------------------------------------------*/
static unsigned int download_size;
static unsigned int download_bytes;
static unsigned int download_error;
static int rx_handler (const unsigned char *buffer, unsigned int buffer_size);

/*---------------------------------------------------------------------------*/
static struct cmd_fastboot_interface interface =
{
	.rx_handler            = rx_handler,
	.reset_handler         = NULL,
	.product_name          = NULL,
	.serial_no             = NULL,
	.nand_block_size       = 0,
	.transfer_buffer       = (unsigned char *)0xffffffff,
	.transfer_buffer_size  = 0,
};

/*---------------------------------------------------------------------------*/
static int flashing_raw_data(struct partition_info *pinfo,
	unsigned int addr, u64 size, unsigned int dev_no)
{
	struct mmc *mmc;
	char cmd[64] = { 0, };
	unsigned int blk_start = pinfo->blk_start;
	unsigned int blk_cnt  = size / MOVI_BLK_SIZE;

	mmc = find_mmc_device(dev_no);

	if (!IS_SD(mmc) && pinfo->raw_en) {
		memset(cmd, 0x00, sizeof(cmd));
		sprintf(cmd, "emmc open %d", dev_no);
		run_command(cmd, 0);
		blk_start = pinfo->blk_start -1;
	}

	mmc->block_dev.block_write(&mmc->block_dev,
		blk_start,
		blk_cnt,
		(const void *)addr);
	printf("mmc block write, dev %d, addr 0x%x, blk start %d, blk cnt %d\n",
		dev_no,
		(unsigned int)addr,
		blk_start,
		blk_cnt);

	if (!IS_SD(mmc) && pinfo->raw_en) {
		memset(cmd, 0x00, sizeof(cmd));
		sprintf(cmd, "emmc close %d", dev_no);
		run_command(cmd, 0);
	}
	return	0;
}

/*---------------------------------------------------------------------------*/
static void erase_partition(struct partition_info *pinfo, unsigned int dev_no)
{
	#define	BLOCK_ERASE_SIZE	(512 * 1024)

	unsigned int blk_start = pinfo->blk_start;
	unsigned int blk_cnt  = pinfo->size / MOVI_BLK_SIZE;
	struct mmc *mmc;
	unsigned char *clrbuf =
		(unsigned char *)calloc(sizeof(char), BLOCK_ERASE_SIZE);

	printf("Erasing partition(%s)... blk_st = %d, blk_cnt = %d\n",
		pinfo->name, blk_start, blk_cnt);

	mmc = find_mmc_device(dev_no);

	if (blk_start & 0x3FF) {
		mmc->block_dev.block_write(&mmc->block_dev,
			blk_start,
			1024 - (blk_start & 0x3ff),
			clrbuf);
		printf("*** erase start block 0x%x ***\n", blk_start);
		blk_cnt = blk_cnt - (1024 - (blk_start & 0x3FFF));
		blk_start = (blk_start & (~0x3FFF)) + 1024;
	}
	if (blk_cnt & 0x3FF) {
		mmc->block_dev.block_write(&mmc->block_dev,
			blk_start + blk_cnt - (blk_cnt & 0x3FF),
			(blk_cnt & 0x3FF),
			clrbuf);
		printf("*** erase block length 0x%x ***\n", blk_cnt);
		blk_cnt = blk_cnt - (blk_cnt & 0x3FFF);
	}
	if (blk_cnt >> 10) {
		mmc->block_dev.block_erase(&mmc->block_dev, blk_start, blk_cnt);
		printf("*** erase block start 0x%x, cnt 0x%x ***\n", blk_start, blk_cnt);
	}

	free(clrbuf);
}

/*---------------------------------------------------------------------------*/
static int check_compress_ext4(char *img_base, unsigned long long parti_size) {
	ext4_file_header *file_header;

	file_header = (ext4_file_header*)img_base;

	if (file_header->magic != EXT4_FILE_HEADER_MAGIC) {
		return -1;
	}

	if (file_header->major != EXT4_FILE_HEADER_MAJOR) {
		printf("Invalid Version Info! 0x%2x\n", file_header->major);
		return -1;
	}

	if (file_header->file_header_size != EXT4_FILE_HEADER_SIZE) {
		printf("Invalid File Header Size! 0x%8x\n",
			file_header->file_header_size);
		return -1;
	}

	if (file_header->chunk_header_size != EXT4_CHUNK_HEADER_SIZE) {
		printf("Invalid Chunk Header Size! 0x%8x\n",
			file_header->chunk_header_size);
		return -1;
	}

	if (file_header->block_size != EXT4_FILE_BLOCK_SIZE) {
		printf("Invalid Block Size! 0x%8x\n", file_header->block_size);
		return -1;
	}

	if ((parti_size/file_header->block_size)  < file_header->total_blocks) {
		printf("Invalid Volume Size! Image is bigger than partition size!\n");
		printf("partion size %lld , image size %d \n",
			(parti_size/file_header->block_size), file_header->total_blocks);
		while(1);
	}

	/* image is compressed ext4 */
	return 0;
}

/*---------------------------------------------------------------------------*/
static int write_compressed_ext4(char* img_base, unsigned int sector_base,
	unsigned int dev_no)
{
	#define SECTOR_BITS	9	/* 512B */

	unsigned int sector_size;
	int total_chunks;
	ext4_chunk_header *chunk_header;
	ext4_file_header *file_header;
	struct mmc *mmc;

	mmc = find_mmc_device(dev_no);

	file_header = (ext4_file_header*)img_base;
	total_chunks = file_header->total_chunks;

	printf("%s : total chunk = %d \n", __func__, total_chunks);

	img_base += EXT4_FILE_HEADER_SIZE;

	odroid_led_ctrl	(GPIO_LED_G, 1);
	while(total_chunks) {
		chunk_header = (ext4_chunk_header*)img_base;
		sector_size =
			(chunk_header->chunk_size *
				file_header->block_size) >> SECTOR_BITS;

		switch(chunk_header->type)
		{
		case EXT4_CHUNK_TYPE_RAW:
			mmc->block_dev.block_write(&mmc->block_dev,
				sector_base,
				sector_size,
				(const void *)(img_base + EXT4_CHUNK_HEADER_SIZE));
			sector_base += sector_size;
			break;

		case EXT4_CHUNK_TYPE_FILL:
			printf("*** fill_chunk ***\n");
			sector_base += sector_size;
			break;

		case EXT4_CHUNK_TYPE_NONE:
			printf("none chunk \n");
			sector_base += sector_size;
			break;

		default:
			printf("*** unknown chunk type ***\n");
			sector_base += sector_size;
			break;
		}
		total_chunks--;
		printf("mmc write dev %d, blk = 0x%08x, size = 0x%08x, remain chunks = %d\n",
			dev_no,
			sector_base,
			sector_size,
			total_chunks);

		img_base += chunk_header->total_size;
	};

	odroid_led_ctrl	(GPIO_LED_G, 0);
	printf("write done \n");
	return 0;
}

/*---------------------------------------------------------------------------*/
static int flashing_data(struct partition_info *pinfo,
	unsigned int addr, unsigned int size, unsigned int dev_no)
{
	if (check_compress_ext4((char *)addr, pinfo->size))
		flashing_raw_data(pinfo, addr, pinfo->size, dev_no);
	else {
		erase_partition(pinfo, dev_no);
		write_compressed_ext4((char*)addr, pinfo->blk_start, dev_no);
	}

	printf("\npartition '%s' flashed.\n\n", pinfo->name);
	return	0;
}

/*---------------------------------------------------------------------------*/
static int rx_handler (const unsigned char *buffer, unsigned int buffer_size)
{
	int ret = 1;

	/* Use 65 instead of 64
	   null gets dropped
	   strcpy's need the extra byte */
	char response[65];

	if (download_size) {
		/* Something to download */

		if (buffer_size) {
			/* Handle possible overflow */
			unsigned int transfer_size = download_size - download_bytes;

			if (buffer_size < transfer_size)
				transfer_size = buffer_size;

			/* Save the data to the transfer buffer */
			memcpy (interface.transfer_buffer + download_bytes,
				buffer, transfer_size);

			download_bytes += transfer_size;

			/* Check if transfer is done */
			if (download_bytes >= download_size) {
				/* Reset global transfer variable,
				   Keep download_bytes because it will be
				   used in the next possible flashing command */
				download_size = 0;

				if (download_error) {
					/* There was an earlier error */
					sprintf(response, "ERROR");
				} else {
					/* Everything has transferred,
					   send the OK response */
					sprintf(response, "OKAY");
				}
				fastboot_tx_status(response, strlen(response), FASTBOOT_TX_ASYNC);

				printf("\ndownloading of %d bytes finished\n", download_bytes);
			}

			/* Provide some feedback */
			if (download_bytes && download_size &&
			    0 == (download_bytes & (0x100000 - 1))) {
				/* Some feeback that the download is happening */
				if (download_error)
					printf("X");
				else
					printf(".");
				if (0 == (download_bytes %
					  (80 * 0x100000)))
					printf("\n");
			}
		} else {
			/* Ignore empty buffers */
			printf("Warning empty download buffer\n");
			printf("Ignoring\n");
		}
		ret = 0;
	} else {
		/* A command */

		/* Cast to make compiler happy with string functions */
		const char *cmdbuf = (char *) buffer;

		/* Generic failed response */
		sprintf(response, "FAIL");

		/* reboot
		   Reboot the board. */
		if (memcmp(cmdbuf, "reboot", 6) == 0) {
			if (!strcmp(cmdbuf + 6, "-bootloader")) {
				struct exynos5_power *pmu =
					(struct exynos5_power *)samsung_get_base_power();
				pmu->sysip_dat0 = FASTBOOT_MAGIC_REBOOT_CMD; 
				printf("reboot-bootloader (reboot fastboot)\n");			    
			} else {
				memset(interface.transfer_buffer, 0x0, FASTBOOT_REBOOT_MAGIC_SIZE);
			}

			sprintf(response,"OKAY");
			fastboot_tx_status(response, strlen(response), FASTBOOT_TX_SYNC);

			do_reset (NULL, 0, 0, NULL);

			/* This code is unreachable,
			   leave it to make the compiler happy */
			return 0;
		}

		/* getvar
		   Get common fastboot variables
		   Board has a chance to handle other variables */
		if (memcmp(cmdbuf, "getvar:", 7) == 0)
		{
			strcpy(response,"OKAY");

			if (!strcmp(cmdbuf + 7, "version")) {
				strcpy(response + 4, FASTBOOT_VERSION);
			} else if (!strcmp(cmdbuf + 7, "product")) {
				if (interface.product_name)
					strcpy(response + 4, interface.product_name);
			} else if (!strcmp(cmdbuf + 7, "serialno")) {
				if (interface.serial_no)
					strcpy(response + 4, interface.serial_no);
			} else if (!strcmp(cmdbuf + 7, "downloadsize")) {
				if (interface.transfer_buffer_size)
					sprintf(response + 4, "%08x", interface.transfer_buffer_size);
			} else {
				fastboot_getvar(cmdbuf + 7, response + 4);
			}
			ret = 0;
			goto send_tx_status;
		}

		/* erase
		   Erase a register flash partition
		   Board has to set up flash partitions */
		if (memcmp(cmdbuf, "erase:", 6) == 0)
		{
			struct partition_info pinfo;

			ret = 0;
			printf("partition '%s' erased\n", cmdbuf + 6);
			if (!strncmp(cmdbuf + 6, "fat", sizeof("fat"))) {
				run_command("fatformat mmc 0:1", 0);
				sprintf(response, "OKAY");
				goto send_tx_status;
			}
			if (odroid_get_partition_info(&cmdbuf[6], &pinfo))
				sprintf(response, "FAILUnsupport partitiond");
			else {
				if (!pinfo.raw_en) {
					erase_partition(&pinfo, 0);
					sprintf(response, "OKAY");
				}
				else
					sprintf(response, "FAILUnsupport or Unknown partitiond");
			}
			goto send_tx_status;
		}

		/* download
		   download something ..
		   What happens to it depends on the next command after data */
		if (memcmp(cmdbuf, "download:", 9) == 0)
		{
			/* save the size */
			download_size = simple_strtoul(cmdbuf + 9, NULL, 16);
			/* Reset the bytes count, now it is safe */
			download_bytes = 0;
			/* Reset error */
			download_error = 0;

			printf("Starting download of %d bytes\n", download_size);

			if (0 == download_size) {
				/* bad user input */
				sprintf(response, "FAILdata invalid size");
			} else if (download_size > interface.transfer_buffer_size) {
				/* set download_size to 0 because this is an error */
				download_size = 0;
				sprintf(response, "FAILdata too large");
			} else {
				/* The default case, the transfer fits
				   completely in the interface buffer */
				sprintf(response, "DATA%08x", download_size);
			}
			ret = 0;
			goto send_tx_status;
		}

		/* flash
		   Flash what was downloaded */
		if (memcmp(cmdbuf, "flash:", 6) == 0) {
			struct partition_info pinfo;

			ret = 0;
			if (download_bytes == 0) {
				sprintf(response, "FAILno image downloaded");
				goto send_tx_status;
			}
			if (odroid_get_partition_info(&cmdbuf[6], &pinfo)) {
				sprintf(response, "FAILunknown(%s) partition!",
					cmdbuf + 6);
				goto send_tx_status;
			}
			if (pinfo.size < download_bytes) {
				sprintf(response, "FAILimage too large for partition(%s)!",
					cmdbuf + 6);
				goto send_tx_status;
			}
			if (flashing_data(&pinfo,
				(unsigned int)interface.transfer_buffer,
				download_bytes, 0)) {
					sprintf(response, "FAILfailed to flash %s partition!",
					cmdbuf + 6);
				goto send_tx_status;
			}
			sprintf(response, "OKAY");
			goto send_tx_status;
		}
		/* verify */
		/* continue */
		/* powerdown */
send_tx_status:
		fastboot_tx_status(response, strlen(response), FASTBOOT_TX_ASYNC);
	} /* End of command */

	return ret;
}

/*---------------------------------------------------------------------------*/
static int fastboot_cmd_flash(int argc, char *const argv[])
{
	struct partition_info pinfo;
	unsigned int addr, dev_no = 0;

	if (odroid_get_partition_info(argv[2], &pinfo))
		return	1;

	addr = simple_strtoul(argv[3], NULL, 16);
	if (argc == 5)
		dev_no = simple_strtoul(argv[4], NULL, 16);

	if ((dev_no != 0) && (dev_no != 1))
		dev_no = 0;

	flashing_data(&pinfo, addr, pinfo.size, dev_no);

	if (dev_no)
		run_command("mmc dev 0", 0);

	return	0;
}

/*---------------------------------------------------------------------------*/
static int fastboot_cmd_parsing(int argc, char *const argv[], int *retval)
{
	int	ret = 0;
	*retval = CMD_RET_FAILURE;

	switch(argc) {
	case	2:
		if (!strncmp(argv[1], "poweroff", sizeof("poweroff"))) {
			odroid_power_off();
			while(1);
		}
		*retval = CMD_RET_USAGE;
		break;
	case	5:	case	6:
		if (argv[4] != NULL)
			ret = odroid_partition_setup(argv[4]);
		else
			ret = odroid_partition_setup("0");

		if (!ret)
			ret = fastboot_cmd_flash(argc, argv);

		*retval = ret ? CMD_RET_FAILURE:CMD_RET_SUCCESS;
		break;
	default:
		*retval = CMD_RET_USAGE;
		break;
	/* normal fastboot */
	case	1:
		ret = odroid_partition_setup("0");
		*retval = ret ? CMD_RET_FAILURE:CMD_RET_SUCCESS;
		return	*retval;
	}
	return	1;
}

/*---------------------------------------------------------------------------*/
static int do_fastboot(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	int continue_from_disconnect = 0, poll_status, retval;
	int led_status = 0, led_blink_cnt = 0;
	int ret = 1;

	/* fastboot command parsing */
	if (fastboot_cmd_parsing(argc, argv, &retval))
		return retval;
	do
	{
		continue_from_disconnect = 0;

		/* Initialize the board specific support */
		if (0 == fastboot_init(&interface))
		{
			/* If we got this far, we are a success */
			ret = 0;

			while (1)
			{
				/* Green LED Blink */
				if (led_blink_cnt++ > 0x8000) {
					if (led_status) {
						odroid_led_ctrl	(GPIO_LED_G, led_status);
						led_status = 0;
					} else {
						odroid_led_ctrl	(GPIO_LED_G, led_status);
						led_status = 1;
					}
					led_blink_cnt = 0;
				}

				poll_status = fastboot_poll();

				/* Check if the user wanted to terminate with ^C */
				if ((FASTBOOT_OK != poll_status) && ctrlc()) {
					printf("Fastboot ended by user\n");
					continue_from_disconnect = 0;
					break;
				}

				if (FASTBOOT_ERROR == poll_status) {
					/* Error */
					printf("Fastboot error \n");
					break;
				}
				else if (FASTBOOT_DISCONNECT == poll_status) {
					/* break, cleanup and re-init */
					printf("Fastboot disconnect detected\n");
					continue_from_disconnect = 1;
					break;
				}
			} /* while (1) */
		}
		/* Reset the board specific support */
		fastboot_shutdown();
		/* restart the loop if a disconnect was detected */
	} while (continue_from_disconnect);

	odroid_led_ctrl	(GPIO_LED_G, 0);
	return	ret;
}

U_BOOT_CMD(
	fastboot, 5, 1, do_fastboot,
	"use USB Fastboot protocol",
	"[ poweroff | flash [kernel|system|userdata|cache] [addr] [dev no] ]\n"
	"[] - options for self update"
);

/*---------------------------------------------------------------------------*/
static int do_self_update(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	uint	option = 0;

	switch(argc) {
	case	2:
		if ((argv[1][0] == 'h') || (argv[1][0] == '-'))
			return	CMD_RET_USAGE;

		option = (uint)simple_strtoul(argv[1], NULL, 16);
		printf("%s : option = 0x%x\n", __func__, option);
		odroid_self_update(option);
		return	CMD_RET_SUCCESS;

	default :
		return	CMD_RET_USAGE;
	}
}

U_BOOT_CMD(
	self_update, 2, 0, do_self_update,
	"self update for android",
	"[ option val ]\n\n"
	"==== OPTION Value ====\n"
	"-h or h : usage display\n"
	"ERASE_USERDATA = 0x01, ERASE_FAT = 0x02, ERASE_ENV = 0x04\n"
	"UPDATE_UBOOT = 0x08, RESIZE_PART = 0x10, FILELOAD_EXT4 = 0x20\n"
	"OPTION_OLDTYPE_PART = 0x40\n\n"
	"RESIZE_PART flag : expand partition for userdata\n"
	"	--> fdisk -c 0 1024 0 256 100\n"
	"	--> System 1G / Userdata expand / Cache 256M / Vfat 100M\n\n"
	"FILELOAD_EXT4 flag : update file load from userdata partition(ext4)\n"
	"	--> ext4load mmc 0:3 media/0/update\n\n"
	"OLDTYPE_PART flag : old style partition setup\n"
	"	--> fdisk -c 0\n"
	"	--> System 1G / Userdata 2G / Cache 256M / Vfat expand\n\n"
);

/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/
