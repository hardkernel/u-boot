/* copyright (c) 2010 Samsung Electronics Co., Ltd.
 *              http://www.samsung.com/
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
*/

typedef struct _ext4_file_header {
	unsigned int magic;
	unsigned short major;
	unsigned short minor;
	unsigned short file_header_size;
	unsigned short chunk_header_size;
	unsigned int block_size;
	unsigned int total_blocks;
	unsigned int total_chunks;
	unsigned int crc32;
}ext4_file_header;


typedef struct _ext4_chunk_header {
	unsigned short type;
	unsigned short reserved;
	unsigned int chunk_size;
	unsigned int total_size;
}ext4_chunk_header;

#define EXT4_FILE_HEADER_MAGIC	0xED26FF3A
#define EXT4_FILE_HEADER_MAJOR	0x0001
#define EXT4_FILE_HEADER_MINOR	0x0000
#define EXT4_FILE_BLOCK_SIZE	0x1000

#define EXT4_FILE_HEADER_SIZE	(sizeof(struct _ext4_file_header))
#define EXT4_CHUNK_HEADER_SIZE	(sizeof(struct _ext4_chunk_header))


#define EXT4_CHUNK_TYPE_RAW			0xCAC1
#define EXT4_CHUNK_TYPE_FILL		0xCAC2
#define EXT4_CHUNK_TYPE_NONE		0xCAC3

int write_compressed_ext4(char* img_base, unsigned int sector_base);
int check_compress_ext4(char *img_base, unsigned long long parti_size);

