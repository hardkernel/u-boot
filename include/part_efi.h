/*
 * Copyright (C) 2008 RuggedCom, Inc.
 * Richard Retanubun <RichardRetanubun@RuggedCom.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

/*
 * See also linux/fs/partitions/efi.h
 *
 * EFI GUID Partition Table
 * Per Intel EFI Specification v1.02
 * http://developer.intel.com/technology/efi/efi.htm
*/

#include <linux/compiler.h>

#ifndef _DISK_PART_EFI_H
#define _DISK_PART_EFI_H

#define MSDOS_MBR_SIGNATURE 0xAA55
#define EFI_PMBR_OSTYPE_EFI 0xEF
#define EFI_PMBR_OSTYPE_EFI_GPT 0xEE

#define GPT_HEADER_SIGNATURE 0x5452415020494645ULL
#define GPT_HEADER_REVISION_V1 0x00010000
#define GPT_PRIMARY_PARTITION_TABLE_LBA 1ULL
#define GPT_ENTRY_NAME "gpt"
#define GPT_ENTRY_NUMBERS		128
#define GPT_ENTRY_SIZE			128

#define EFI_GUID(a,b,c,d0,d1,d2,d3,d4,d5,d6,d7) \
	((efi_guid_t) \
	{{ (a) & 0xff, ((a) >> 8) & 0xff, ((a) >> 16) & 0xff, ((a) >> 24) & 0xff, \
		(b) & 0xff, ((b) >> 8) & 0xff, \
		(c) & 0xff, ((c) >> 8) & 0xff, \
		(d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }})

#define PARTITION_SYSTEM_GUID \
	EFI_GUID( 0xC12A7328, 0xF81F, 0x11d2, \
		0xBA, 0x4B, 0x00, 0xA0, 0xC9, 0x3E, 0xC9, 0x3B)
#define LEGACY_MBR_PARTITION_GUID \
	EFI_GUID( 0x024DEE41, 0x33E7, 0x11d3, \
		0x9D, 0x69, 0x00, 0x08, 0xC7, 0x81, 0xF3, 0x9F)
#define PARTITION_MSFT_RESERVED_GUID \
	EFI_GUID( 0xE3C9E316, 0x0B5C, 0x4DB8, \
		0x81, 0x7D, 0xF9, 0x2D, 0xF0, 0x02, 0x15, 0xAE)
#define PARTITION_BASIC_DATA_GUID \
	EFI_GUID( 0xEBD0A0A2, 0xB9E5, 0x4433, \
		0x87, 0xC0, 0x68, 0xB6, 0xB7, 0x26, 0x99, 0xC7)
#define PARTITION_LINUX_FILE_SYSTEM_DATA_GUID \
	EFI_GUID(0x0FC63DAF, 0x8483, 0x4772, \
		0x8E, 0x79, 0x3D, 0x69, 0xD8, 0x47, 0x7D, 0xE4)
#define PARTITION_LINUX_RAID_GUID \
	EFI_GUID( 0xa19d880f, 0x05fc, 0x4d3b, \
		0xa0, 0x06, 0x74, 0x3f, 0x0f, 0x84, 0x91, 0x1e)
#define PARTITION_LINUX_SWAP_GUID \
	EFI_GUID( 0x0657fd6d, 0xa4ab, 0x43c4, \
		0x84, 0xe5, 0x09, 0x33, 0xc8, 0x4b, 0x4f, 0x4f)
#define PARTITION_LINUX_LVM_GUID \
	EFI_GUID( 0xe6d6d379, 0xf507, 0x44c2, \
		0xa2, 0x3c, 0x23, 0x8f, 0x2a, 0x3d, 0xf9, 0x28)
#define PARTITION_LINUX_DEFAULT_GUID \
	EFI_GUID(0x0FC63DAF, 0x8483, 0x4772, \
		0x8E, 0x79, 0x3D, 0x69, 0xD8, 0x47, 0x7D, 0xE4)
#define PARTITION_ANDROID_BOOTLOADER_GUID \
	EFI_GUID(0x2568845D, 0x2332, 0x4675, \
		0xBC, 0x39, 0x8F, 0xA5, 0xA4, 0x74, 0x8D, 0x15)
#define PARTITION_ANDROID_BOOTLOADER2_GUID \
	EFI_GUID(0x114EAFFE, 0x1552, 0x4022, \
		0xB2, 0x6E, 0x9B, 0x05, 0x36, 0x04, 0xCF, 0x84)
#define PARTITION_ANDROID_RECOVERY_GUID \
	EFI_GUID(0x4177C722, 0x9E92, 0x4AAB, \
		0x86, 0x44, 0x43, 0x50, 0x2B, 0xFD, 0x55, 0x06)
#define PARTITION_ANDROID_MISC_GUID \
	EFI_GUID(0xEF32A33B, 0xA409, 0x486C, \
		0x91, 0X41, 0x9F, 0xFB, 0x71, 0x1F, 0x62, 0x66)
#define PARTITION_ANDROID_SYSTEM_GUID \
	EFI_GUID(0x38F428E6, 0xD326, 0x425D, \
		0x91, 0x40, 0x6E, 0x0E, 0xA1, 0x33, 0x64, 0x7C)
#define PARTITION_ANDROID_CACHE_GUID \
	EFI_GUID(0xA893EF21, 0xE428, 0x470A, \
		0x9E, 0x55, 0x06, 0x68, 0xFD, 0x91, 0xA2, 0xD9)
#define PARTITION_ANDROID_DATA_GUID \
	EFI_GUID(0xDC76DDA9, 0x5AC1, 0x491C, \
		0xAF, 0x42, 0xA8, 0x25, 0x91, 0x58, 0x0C, 0x0D)
#define PARTITION_ANDROID_PERSISTENT_GUID \
	EFI_GUID(0xEBC597D0, 0x2053, 0x4B15, \
		0x8B, 0x64, 0xE0, 0xAA, 0xC7, 0x5F, 0x4D, 0xB1)
#define PARTITION_ANDROID_VENDOR_GUID \
	EFI_GUID(0xC5A0AEEC, 0x13EA, 0x11E5, \
		0xA1, 0xB1, 0x00, 0x1E, 0x67, 0xCA, 0x0C, 0x3C)
#define PARTITION_ANDROID_CONFIG_GUID \
	EFI_GUID(0xBD59408B, 0x4514, 0x490D, \
		0xBF, 0x12, 0x98, 0x78, 0xD9, 0x63, 0xF3, 0x78)
#define PARTITION_ANDROID_FACTORY_GUID \
	EFI_GUID(0x8F68CC74, 0xC5E5, 0x48DA, \
		0xBE, 0x01, 0xA0, 0xC8, 0xC1, 0x5E, 0x9C, 0x80)
#define PARTITION_ANDROID_FACTORY_ALT_GUID \
	EFI_GUID(0x9FDAA6EF, 0x4B3F, 0x40D2, \
		0xBA, 0x8D, 0xBF, 0xF1, 0x6B, 0xFB, 0x88, 0x78)
#define PARTITION_ANDROID_FASTBOOT_GUID \
	EFI_GUID(0x767941D0, 0x2085, 0x11E3, \
		0xAD, 0x3B, 0x6C, 0xFD, 0xB9, 0x47, 0x11, 0xE9)
#define PARTITION_ANDROID_TERTIARY_GUID \
	EFI_GUID(0x767941D0, 0x2085, 0x11E3, \
		0xAD, 0x3B, 0x6C, 0xFD, 0xB9, 0x47, 0x11, 0xE9)
#define PARTITION_ANDROID_OEM_GUID \
	EFI_GUID(0xAC6D7924, 0xEB71, 0x4DF8, \
		0xB4, 0x8D, 0xE2, 0x67, 0xB2, 0x71, 0x48, 0xFF)

/* linux/include/efi.h */
typedef u16 efi_char16_t;

typedef struct {
	u8 b[16];
} efi_guid_t;

/* based on linux/include/genhd.h */
struct partition {
	u8 boot_ind;		/* 0x80 - active */
	u8 head;		/* starting head */
	u8 sector;		/* starting sector */
	u8 cyl;			/* starting cylinder */
	u8 sys_ind;		/* What partition type */
	u8 end_head;		/* end head */
	u8 end_sector;		/* end sector */
	u8 end_cyl;		/* end cylinder */
	__le32 start_sect;	/* starting sector counting from 0 */
	__le32 nr_sects;	/* nr of sectors in partition */
} __packed;

/* based on linux/fs/partitions/efi.h */
typedef struct _gpt_header {
	__le64 signature;
	__le32 revision;
	__le32 header_size;
	__le32 header_crc32;
	__le32 reserved1;
	__le64 my_lba;
	__le64 alternate_lba;
	__le64 first_usable_lba;
	__le64 last_usable_lba;
	efi_guid_t disk_guid;
	__le64 partition_entry_lba;
	__le32 num_partition_entries;
	__le32 sizeof_partition_entry;
	__le32 partition_entry_array_crc32;
} __packed gpt_header;
int gpt_restore(block_dev_desc_t *dev_desc, char *str_disk_guid,
		disk_partition_t *partitions, const int parts_count);


typedef union _gpt_entry_attributes {
	struct {
		u64 required_to_function:1;
		u64 no_block_io_protocol:1;
		u64 legacy_bios_bootable:1;
		u64 reserved:45;
		u64 type_guid_specific:16;
	} fields;
	unsigned long long raw;
} __packed gpt_entry_attributes;

#define PARTNAME_SZ	(72 / sizeof(efi_char16_t))
typedef struct _gpt_entry {
	efi_guid_t partition_type_guid;
	efi_guid_t unique_partition_guid;
	__le64 starting_lba;
	__le64 ending_lba;
	gpt_entry_attributes attributes;
	efi_char16_t partition_name[PARTNAME_SZ];
} __packed gpt_entry;

typedef struct _legacy_mbr {
	u8 boot_code[440];
	__le32 unique_mbr_signature;
	__le16 unknown;
	struct partition partition_record[4];
	__le16 signature;
} __packed legacy_mbr;

#endif	/* _DISK_PART_EFI_H */
