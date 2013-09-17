/* copyright (c) 2010 Samsung Electronics Co., Ltd.
 *              http://www.samsung.com/
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
*/

#include <common.h>
#include <asm/io.h>
#include <asm/types.h>
#include <environment.h>
#include <command.h>
#include <fastboot.h>

#include <asm/errno.h>
#include <decompress_ext4.h>
#include <mmc.h>

#define SECTOR_BITS		9	/* 512B */

#define ext4_printf(args, ...)

static int write_raw_chunk(char* data, unsigned int sector, unsigned int sector_size);


int check_compress_ext4(char *img_base, unsigned long long parti_size) {
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

#if defined(CONFIG_BOARD_HARDKERNEL)
    extern  unsigned char GLOBAL_SYSTEM_PART;
#endif    

int write_raw_chunk(char* data, unsigned int sector, unsigned int sector_size) {
	char run_cmd[64];
#ifdef CONFIG_CPU_EXYNOS5410_EVT2
	unsigned char *tmp_align;

	if (((unsigned int)data % 8) != 0) {
		tmp_align = (char *)CFG_FASTBOOT_MMC_BUFFER;
		memcpy((unsigned char *)tmp_align, (unsigned char *)data, sector_size * 512);
		data = tmp_align;
	}
#endif
	ext4_printf("write raw data in %d size %d \n", sector, sector_size);

#if defined(CONFIG_BOARD_HARDKERNEL)
	sprintf(run_cmd,"mmc write %d 0x%x 0x%x 0x%x", GLOBAL_SYSTEM_PART, (int)data, sector, sector_size);
#else
	sprintf(run_cmd,"mmc write 0 0x%x 0x%x 0x%x", (int)data, sector, sector_size);
#endif	

	run_command(run_cmd, 0);

	return 0;
}


int write_compressed_ext4(char* img_base, unsigned int sector_base) {
	unsigned int sector_size;
	int total_chunks;
	ext4_chunk_header *chunk_header;
	ext4_file_header *file_header;

	file_header = (ext4_file_header*)img_base;
	total_chunks = file_header->total_chunks;

	ext4_printf("total chunk = %d \n", total_chunks);

	img_base += EXT4_FILE_HEADER_SIZE;

#if defined(CONFIG_BOARD_HARDKERNEL) && defined(CONFIG_LED_CONTROL)
    LED_GREEN(ON);
#endif    
	while(total_chunks) {
		chunk_header = (ext4_chunk_header*)img_base;
		sector_size = (chunk_header->chunk_size * file_header->block_size) >> SECTOR_BITS;

		switch(chunk_header->type)
		{
		case EXT4_CHUNK_TYPE_RAW:
			ext4_printf("raw_chunk \n");
			write_raw_chunk(img_base + EXT4_CHUNK_HEADER_SIZE,
							sector_base, sector_size);
			sector_base += sector_size;
			break;

		case EXT4_CHUNK_TYPE_FILL:
			printf("*** fill_chunk ***\n");
			sector_base += sector_size;
			break;

		case EXT4_CHUNK_TYPE_NONE:
			ext4_printf("none chunk \n");
			sector_base += sector_size;
			break;

		default:
			printf("*** unknown chunk type ***\n");
			sector_base += sector_size;
			break;
		}
		total_chunks--;
		ext4_printf("remain chunks = %d \n", total_chunks);

		img_base += chunk_header->total_size;
	};

	ext4_printf("write done \n");
	return 0;
}
