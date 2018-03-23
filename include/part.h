/*
 * (C) Copyright 2000-2004
 * Wolfgang Denk, DENX Software Engineering, wd@denx.de.
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */
#ifndef _PART_H
#define _PART_H

#include <ide.h>
#include <common.h>
#include <uuid.h>
#include <linux/list.h>

#ifndef EINVAL
#define EINVAL	22
#endif

#define CONFIG_PARTITION_UUIDS
#define CONFIG_PARTITION_TYPE_GUID
//#define CONFIG_EFI_PARTITION

typedef struct block_dev_desc {
	int		if_type;	/* type of the interface */
	int		dev;		/* device number */
	unsigned char	part_type;	/* partition type */
	unsigned char	target;		/* target SCSI ID */
	unsigned char	lun;		/* target LUN */
	unsigned char	type;		/* device type */
	unsigned char	removable;	/* removable device */
#ifdef CONFIG_LBA48
	unsigned char	lba48;		/* device can use 48bit addr (ATA/ATAPI v7) */
#endif
	lbaint_t	lba;		/* number of blocks */
	unsigned long	blksz;		/* block size */
	int		log2blksz;	/* for convenience: log2(blksz) */
	char		vendor [40+1];	/* IDE model, SCSI Vendor */
	char		product[20+1];	/* IDE Serial no, SCSI product */
	char		revision[8+1];	/* firmware revision */
	unsigned long	(*block_read)(int dev,
				      lbaint_t start,
				      lbaint_t blkcnt,
				      void *buffer);
	unsigned long	(*block_write)(int dev,
				       lbaint_t start,
				       lbaint_t blkcnt,
				       const void *buffer);
	unsigned long   (*block_erase)(int dev,
				       lbaint_t start,
				       lbaint_t blkcnt);
	void		*priv;		/* driver private struct pointer */
}block_dev_desc_t;

#define BLOCK_CNT(size, block_dev_desc) (PAD_COUNT(size, block_dev_desc->blksz))
#define PAD_TO_BLOCKSIZE(size, block_dev_desc) \
	(PAD_SIZE(size, block_dev_desc->blksz))
#define LOG2(x) (((x & 0xaaaaaaaa) ? 1 : 0) + ((x & 0xcccccccc) ? 2 : 0) + \
		 ((x & 0xf0f0f0f0) ? 4 : 0) + ((x & 0xff00ff00) ? 8 : 0) + \
		 ((x & 0xffff0000) ? 16 : 0))
#define LOG2_INVALID(type) ((type)((sizeof(type)<<3)-1))

/* Interface types: */
#define IF_TYPE_UNKNOWN		0
#define IF_TYPE_IDE		1
#define IF_TYPE_SCSI		2
#define IF_TYPE_ATAPI		3
#define IF_TYPE_USB		4
#define IF_TYPE_DOC		5
#define IF_TYPE_MMC		6
#define IF_TYPE_SD		7
#define IF_TYPE_SATA		8
#define IF_TYPE_HOST		9
#define IF_TYPE_MAX		10	/* Max number of IF_TYPE_* supported */

/* Part types */
#define PART_TYPE_UNKNOWN	0x00
#define PART_TYPE_MAC		0x01
#define PART_TYPE_DOS		0x02
#define PART_TYPE_ISO		0x03
#define PART_TYPE_AMIGA		0x04
#define PART_TYPE_EFI		0x05
#define PART_TYPE_AML		0x06

/*
 * Type string for U-Boot bootable partitions
 */
#define BOOT_PART_TYPE	"U-Boot"	/* primary boot partition type	*/
#define BOOT_PART_COMP	"PPCBoot"	/* PPCBoot compatibility type	*/

/* device types */
#define DEV_TYPE_UNKNOWN	0xff	/* not connected */
#define DEV_TYPE_HARDDISK	0x00	/* harddisk */
#define DEV_TYPE_TAPE		0x01	/* Tape */
#define DEV_TYPE_CDROM		0x05	/* CD-ROM */
#define DEV_TYPE_OPDISK		0x07	/* optical disk */

#define PART_NAME_LEN 32
#define PART_TYPE_LEN 32
#define MAX_SEARCH_PARTITIONS 64
#define UUID_STR_LEN          36

typedef struct disk_partition {
	lbaint_t	start;	/* # of first block in partition	*/
	lbaint_t	size;	/* number of blocks in partition	*/
	ulong	blksz;		/* block size in bytes			*/
	uchar	name[32];	/* partition name			*/
	uchar	type[32];	/* string type description		*/
	int	bootable;	/* Active/Bootable flag is set		*/
#ifdef CONFIG_PARTITION_UUIDS
	char	uuid[37];	/* filesystem UUID as string, if exists	*/
#endif
#ifdef CONFIG_PARTITION_TYPE_GUID
	char	type_guid[UUID_STR_LEN + 1]; /* type GUID as string, if exists*/
#endif
#ifdef CONFIG_DOS_PARTITION
	uchar	sys_ind;	/* partition type			*/
#endif
} disk_partition_t;

struct disk_part {
	int partnum;
	disk_partition_t gpt_part_info;
	struct list_head list;
};

/* Misc _get_dev functions */
#ifdef CONFIG_PARTITIONS
block_dev_desc_t *get_dev(const char *ifname, int dev);
block_dev_desc_t *ide_get_dev(int dev);
block_dev_desc_t *sata_get_dev(int dev);
block_dev_desc_t *scsi_get_dev(int dev);
block_dev_desc_t *usb_stor_get_dev(int dev);
block_dev_desc_t *mmc_get_dev(int dev);
int mmc_select_hwpart(int dev_num, int hwpart);
block_dev_desc_t *systemace_get_dev(int dev);
block_dev_desc_t *mg_disk_get_dev(int dev);
block_dev_desc_t *host_get_dev(int dev);
int host_get_dev_err(int dev, block_dev_desc_t **blk_devp);

/* disk/part.c */
int get_partition_info(block_dev_desc_t *dev_desc, int part,
			disk_partition_t *info);
void print_part(block_dev_desc_t *dev_desc);
void  init_part(block_dev_desc_t *dev_desc);
void dev_print(block_dev_desc_t *dev_desc);
int get_device(const char *ifname, const char *dev_str,
	       block_dev_desc_t **dev_desc);
int get_device_and_partition(const char *ifname, const char *dev_part_str,
			     block_dev_desc_t **dev_desc,
			     disk_partition_t *info, int allow_whole_dev);
#else
static inline block_dev_desc_t *get_dev(const char *ifname, int dev)
{ return NULL; }
static inline block_dev_desc_t *ide_get_dev(int dev) { return NULL; }
static inline block_dev_desc_t *sata_get_dev(int dev) { return NULL; }
static inline block_dev_desc_t *scsi_get_dev(int dev) { return NULL; }
static inline block_dev_desc_t *usb_stor_get_dev(int dev) { return NULL; }
static inline block_dev_desc_t *mmc_get_dev(int dev) { return NULL; }
static inline int mmc_select_hwpart(int dev_num, int hwpart) { return -1; }
static inline block_dev_desc_t *systemace_get_dev(int dev) { return NULL; }
static inline block_dev_desc_t *mg_disk_get_dev(int dev) { return NULL; }
static inline block_dev_desc_t *host_get_dev(int dev) { return NULL; }

static inline int get_partition_info(block_dev_desc_t *dev_desc, int part,
	disk_partition_t *info) { return -1; }
static inline void print_part(block_dev_desc_t *dev_desc) {}
static inline void  init_part(block_dev_desc_t *dev_desc) {}
static inline void dev_print(block_dev_desc_t *dev_desc) {}
static inline int get_device(const char *ifname, const char *dev_str,
	       block_dev_desc_t **dev_desc)
{ return -1; }
static inline int get_device_and_partition(const char *ifname,
					   const char *dev_part_str,
					   block_dev_desc_t **dev_desc,
					   disk_partition_t *info,
					   int allow_whole_dev)
{ *dev_desc = NULL; return -1; }
#endif

#ifdef CONFIG_MAC_PARTITION
/* disk/part_mac.c */
int get_partition_info_mac(block_dev_desc_t *dev_desc, int part,
				disk_partition_t *info);
void print_part_mac(block_dev_desc_t *dev_desc);
int   test_part_mac(block_dev_desc_t *dev_desc);
#endif

#ifdef CONFIG_DOS_PARTITION
/* disk/part_dos.c */
int get_partition_info_dos(block_dev_desc_t *dev_desc, int part,
				disk_partition_t *info);
void print_part_dos(block_dev_desc_t *dev_desc);
int   test_part_dos(block_dev_desc_t *dev_desc);
#endif

#ifdef CONFIG_ISO_PARTITION
/* disk/part_iso.c */
int get_partition_info_iso(block_dev_desc_t *dev_desc, int part,
				disk_partition_t *info);
void print_part_iso(block_dev_desc_t *dev_desc);
int   test_part_iso(block_dev_desc_t *dev_desc);
#endif

#ifdef CONFIG_AMIGA_PARTITION
/* disk/part_amiga.c */
int get_partition_info_amiga(block_dev_desc_t *dev_desc, int part,
				disk_partition_t *info);
void print_part_amiga(block_dev_desc_t *dev_desc);
int   test_part_amiga(block_dev_desc_t *dev_desc);
#endif

#ifdef CONFIG_AML_PARTITION
/* disk/part_aml.c, for aml emmc only */
int get_partition_info_aml(block_dev_desc_t *dev_desc,
	int part_num, disk_partition_t * info);
int get_partition_info_aml_by_name(block_dev_desc_t *dev_desc,
	const char *name, disk_partition_t *info);
void print_part_aml(block_dev_desc_t *dev_desc);
int   test_part_aml(block_dev_desc_t *dev_desc);
#endif

/*
 * We don't support printing partition information in SPL and only support
 * getting partition information in a few cases.
 */
#ifdef CONFIG_SPL_BUILD
# define part_print_ptr(x)	NULL
# if defined(CONFIG_SPL_EXT_SUPPORT) || defined(CONFIG_SPL_FAT_SUPPORT) || \
	defined(CONFIG_SYS_MMCSD_RAW_MODE_U_BOOT_PARTITION)
#  define part_get_info_ptr(x)	x
# else
#  define part_get_info_ptr(x)	NULL
# endif
#else
#define part_print_ptr(x)	x
#define part_get_info_ptr(x)	x
#endif


struct part_driver {
	const char *name;
	int part_type;
	const int max_entries;	/* maximum number of entries to search */

	/**
	 * get_info() - Get information about a partition
	 *
	 * @dev_desc:	Block device descriptor
	 * @part:	Partition number (1 = first)
	 * @info:	Returns partition information
	 */
	int (*get_info)(block_dev_desc_t *dev_desc, int part,
			disk_partition_t *info);

	/**
	 * print() - Print partition information
	 *
	 * @dev_desc:	Block device descriptor
	 */
	void (*print)(block_dev_desc_t *dev_desc);

	/**
	 * test() - Test if a device contains this partition type
	 *
	 * @dev_desc:	Block device descriptor
	 * @return 0 if the block device appears to contain this partition
	 *	   type, -ve if not
	 */
	int (*test)(block_dev_desc_t *dev_desc);
};

/* Declare a new U-Boot partition 'driver' */
#define U_BOOT_PART_TYPE(__name)					\
	ll_entry_declare(struct part_driver, __name, part_driver)


#ifdef CONFIG_EFI_PARTITION
#include <part_efi.h>
/* disk/part_efi.c */
int get_partition_info_efi(block_dev_desc_t *dev_desc,
			   int part, disk_partition_t *info);
/**
 * get_partition_info_efi_by_name() - Find the specified GPT partition table entry
 *
 * @param dev_desc - block device descriptor
 * @param gpt_name - the specified table entry name
 * @param info - returns the disk partition info
 *
 * @return - '0' on match, '-1' on no match, otherwise error
 */
int get_partition_info_efi_by_name(block_dev_desc_t *dev_desc,
	const char *name, disk_partition_t *info);
void print_part_efi(block_dev_desc_t *dev_desc);
int   test_part_efi(block_dev_desc_t *dev_desc);

/**
 * write_gpt_table() - Write the GUID Partition Table to disk
 *
 * @param dev_desc - block device descriptor
 * @param gpt_h - pointer to GPT header representation
 * @param gpt_e - pointer to GPT partition table entries
 *
 * @return - zero on success, otherwise error
 */
int write_gpt_table(block_dev_desc_t *dev_desc,
		  gpt_header *gpt_h, gpt_entry *gpt_e);

/**
 * gpt_fill_pte(): Fill the GPT partition table entry
 *
 * @param gpt_h - GPT header representation
 * @param gpt_e - GPT partition table entries
 * @param partitions - list of partitions
 * @param parts - number of partitions
 *
 * @return zero on success
 */
int gpt_fill_pte(block_dev_desc_t *dev_desc, gpt_header *gpt_h,
		 gpt_entry *gpt_e, disk_partition_t *partitions, int parts);

/**
 * gpt_fill_header(): Fill the GPT header
 *
 * @param dev_desc - block device descriptor
 * @param gpt_h - GPT header representation
 * @param str_guid - disk guid string representation
 * @param parts_count - number of partitions
 *
 * @return - error on str_guid conversion error
 */
int gpt_fill_header(block_dev_desc_t *dev_desc, gpt_header *gpt_h,
		char *str_guid, int parts_count);

/**
 * gpt_restore(): Restore GPT partition table
 *
 * @param dev_desc - block device descriptor
 * @param str_disk_guid - disk GUID
 * @param partitions - list of partitions
 * @param parts - number of partitions
 *
 * @return zero on success
 */
int gpt_restore(block_dev_desc_t *dev_desc, char *str_disk_guid,
		disk_partition_t *partitions, const int parts_count);

/**
 * is_valid_gpt_buf() - Ensure that the Primary GPT information is valid
 *
 * @param dev_desc - block device descriptor
 * @param buf - buffer which contains the MBR and Primary GPT info
 *
 * @return - '0' on success, otherwise error
 */
int is_valid_gpt_buf(block_dev_desc_t *dev_desc, void *buf);

/**
 * write_mbr_and_gpt_partitions() - write MBR, Primary GPT and Backup GPT
 *
 * @param dev_desc - block device descriptor
 * @param buf - buffer which contains the MBR and Primary GPT info
 *
 * @return - '0' on success, otherwise error
 */
int write_mbr_and_gpt_partitions(block_dev_desc_t *dev_desc, void *buf);
/**
 * gpt_verify_headers() - Function to read and CRC32 check of the GPT's header
 *                        and partition table entries (PTE)
 *
 * As a side effect if sets gpt_head and gpt_pte so they point to GPT data.
 *
 * @param dev_desc - block device descriptor
 * @param gpt_head - pointer to GPT header data read from medium
 * @param gpt_pte - pointer to GPT partition table enties read from medium
 *
 * @return - '0' on success, otherwise error
 */
int gpt_verify_headers(block_dev_desc_t *dev_desc, gpt_header *gpt_head,
		       gpt_entry **gpt_pte);

/**
 * gpt_verify_partitions() - Function to check if partitions' name, start and
 *                           size correspond to '$partitions' env variable
 *
 * This function checks if on medium stored GPT data is in sync with information
 * provided in '$partitions' environment variable. Specificially, name, start
 * and size of the partition is checked.
 *
 * @param dev_desc - block device descriptor
 * @param partitions - partition data read from '$partitions' env variable
 * @param parts - number of partitions read from '$partitions' env variable
 * @param gpt_head - pointer to GPT header data read from medium
 * @param gpt_pte - pointer to GPT partition table enties read from medium
 *
 * @return - '0' on success, otherwise error
 */
int gpt_verify_partitions(block_dev_desc_t *dev_desc,
			  disk_partition_t *partitions, int parts,
			  gpt_header *gpt_head, gpt_entry **gpt_pte);


/**
 * get_disk_guid() - Function to read the GUID string from a device's GPT
 *
 * This function reads the GUID string from a block device whose descriptor
 * is provided.
 *
 * @param dev_desc - block device descriptor
 * @param guid - pre-allocated string in which to return the GUID
 *
 * @return - '0' on success, otherwise error
 */
int get_disk_guid(block_dev_desc_t *dev_desc, char *guid);

#endif

#if CONFIG_DOS_PARTITION
/**
 * is_valid_dos_buf() - Ensure that a DOS MBR image is valid
 *
 * @param buf - buffer which contains the MBR
 *
 * @return - '0' on success, otherwise error
 */
int is_valid_dos_buf(void *buf);

/**
 * write_mbr_partition() - write DOS MBR
 *
 * @param dev_desc - block device descriptor
 * @param buf - buffer which contains the MBR
 *
 * @return - '0' on success, otherwise error
 */
int write_mbr_partition(block_dev_desc_t *dev_desc, void *buf);

#endif

#endif /* _PART_H */
