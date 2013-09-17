/*
 *  GRUB  --  GRand Unified Bootloader
 *  Copyright (C) 2000, 2001  Free Software Foundation, Inc.
 *
 *  (C) Copyright 2003 Sysgo Real-Time Solutions, AG <www.elinos.com>
 *  Pavel Bartusek <pba@sysgo.de>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

/* An implementation for the Ext2FS filesystem ported from GRUB.
 * Some parts of this code (mainly the structures and defines) are
 * from the original ext2 fs code, as found in the linux kernel.
 */


#define SECTOR_SIZE		0x200
#define SECTOR_BITS		9

#define COMMON_BLOCK_SIZE	4096

/*
 * Current group descriptor table size allows until size of 256GB.
 * If you want to format more size than 256GB,
 * please change GRP_DESC_TABLE_SIZE below.
 *
 * Unit for size : MB
 */
#define BLOCK_GROUP_SIZE	(128)		/* 128MB */

#define STORAGE_SIZE_16G	(1024 * 16)
#define STORAGE_SIZE_32G	(1024 * 32)
#define STORAGE_SIZE_64G	(1024 * 64)
#define STORAGE_SIZE_128G	(1024 * 128)
#define STORAGE_SIZE_256G	(1024 * 256)

#define GRP_DESC_SIZE		32		/* 32Byte */
#define GRP_DESC_TABLE_SIZE	\
	((STORAGE_SIZE_256G / BLOCK_GROUP_SIZE) * GRP_DESC_SIZE)

#define INODE_DATA_SIZE		GRP_DESC_TABLE_SIZE

/* Error codes */
typedef enum
{
  ERR_NONE = 0,
  ERR_BAD_FILENAME,
  ERR_BAD_FILETYPE,
  ERR_BAD_GZIP_DATA,
  ERR_BAD_GZIP_HEADER,
  ERR_BAD_PART_TABLE,
  ERR_BAD_VERSION,
  ERR_BELOW_1MB,
  ERR_BOOT_COMMAND,
  ERR_BOOT_FAILURE,
  ERR_BOOT_FEATURES,
  ERR_DEV_FORMAT,
  ERR_DEV_VALUES,
  ERR_EXEC_FORMAT,
  ERR_FILELENGTH,
  ERR_FILE_NOT_FOUND,
  ERR_FSYS_CORRUPT,
  ERR_FSYS_MOUNT,
  ERR_GEOM,
  ERR_NEED_LX_KERNEL,
  ERR_NEED_MB_KERNEL,
  ERR_NO_DISK,
  ERR_NO_PART,
  ERR_NUMBER_PARSING,
  ERR_OUTSIDE_PART,
  ERR_READ,
  ERR_SYMLINK_LOOP,
  ERR_UNRECOGNIZED,
  ERR_WONT_FIT,
  ERR_WRITE,
  ERR_BAD_ARGUMENT,
  ERR_UNALIGNED,
  ERR_PRIVILEGED,
  ERR_DEV_NEED_INIT,
  ERR_NO_DISK_SPACE,
  ERR_NUMBER_OVERFLOW,

  MAX_ERR_NUM
} ext2fs_error_t;


extern int ext2fs_set_blk_dev(block_dev_desc_t *rbdd, int part);
extern int ext2fs_ls (const char *dirname);
extern int ext2fs_open (const char *filename);
extern int ext2fs_read (char *buf, unsigned len);
extern int ext2fs_mount (unsigned part_length);
extern int ext2fs_close(void);
