#ifndef __SPI_SECURE_STORAGE_H__
#define __SPI_SECURE_STORAGE_H__

//#include <linux/types.h>
#define SPI_SECURE_STORAGE_UBOOT
//#define SPI_SECURE_STORAGE_KERNEL

#define SPI_MIN_ROOM_SIZE 0x200000

//#ifdef CONFIG_SPI_NOR_SECURE_STORAGE
struct aml_spivalid_node_t{
	u64 offset;
	u64 size;
	int timestamp;
	struct aml_spivalid_node_t *next;
};
struct aml_spifree_node_t{
	u64 offset;
	u64 size;
	int dirty_flag;
	struct aml_spifree_node_t *next;
};

#define SPI_SECURESTORAGE_VER		1
#define SPI_SECURESTORAGE_MAGIC		"spi_sskey"

#define SPI_SECURESTORAGE_SIZE		(128*1024)

#define SPI_SECURESTORAGE_AREA_SIZE	(256*1024)
#define SPI_SECURESTORAGE_AREA_COUNT 2
#define SPI_SECURESTORAGE_OFFSET	(0x100000+64*1024)

#define SPI_SECURESTORAGE_MAGIC_SIZE	16
#define SPI_SECURESTORAGE_AREA_HEAD_SIZE	(SPI_SECURESTORAGE_MAGIC_SIZE+4*6)
#define SPI_SECURESTORAGE_AREA_VALID_SIZE	(SPI_SECURESTORAGE_AREA_SIZE-SPI_SECURESTORAGE_AREA_HEAD_SIZE)

struct aml_spi_securestorage_t{
	u8 magic[SPI_SECURESTORAGE_MAGIC_SIZE];
	u32 magic_checksum;
	u32 version;
	u32 tag;
	u32 checksum; //data checksum
	u32 timestamp;
	u32 reserve;
	u8 data[SPI_SECURESTORAGE_AREA_VALID_SIZE];
};


struct aml_spisecurestorage_info_t{
	struct aml_spivalid_node_t *valid_node;
	struct aml_spifree_node_t *free_node;
	u64 start_pos;
	u64 end_pos;
	u8 secure_valid;
	u8 secure_init;
};

//#else
//#endif


#endif


