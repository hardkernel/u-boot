/*
 * Copyright (C) 2015 Hardkernel Co,. Ltd
 * Dongjin Kim <tobetter@gmail.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <linux/sizes.h>
#include <linux/string.h>
#include <usb/fastboot.h>

/* FIXME: Is block size always 512? */
#define bytes_to_lba(x)		((x) / 512)
#define gbytes_to_lba(x)	((x) * 1024 * 1024 * 2)

#define SZ_RESERVED		(48 * SZ_1K + 512)	/* BL1 + MBR */
#define SZ_BOOTLOADER		(720 * SZ_1K)
#define SZ_BOOTMESSAGE		(4 * SZ_1K)
#define SZ_RESERVED2		((1 * SZ_1M) + (208 * SZ_1K))

static struct fbt_partition {
	const char *name;
	lbaint_t lba;
} partitions[] = {
	{
		.name = "-reserved",
		.lba = bytes_to_lba(SZ_RESERVED)
	}, {
		.name = "bootloader",
		.lba = bytes_to_lba(SZ_BOOTLOADER
				- (SZ_RESERVED + SZ_BOOTMESSAGE))
	}, {
		.name = "bcb",			/* Bootloader control block */
		.lba = bytes_to_lba(SZ_BOOTMESSAGE)
	}, {
		.name = "env",			/* "environment" */
		.lba = bytes_to_lba(CONFIG_ENV_SIZE)
	}, {
		.name = "dtb",			/* Device Tree */
		.lba = bytes_to_lba(SZ_64K)
	}, {
		.name = "boot",			/* Boot image */
		.lba = bytes_to_lba(16 * SZ_1M)
	}, {
		.name = "recovery",		/* Recovery Image */
		.lba = bytes_to_lba(12 * SZ_1M)
	}, {
		.name = "logo",			/* Logo */
		.lba = bytes_to_lba(2 * SZ_1M)
	}, {
		.name = "-reserved2",			/* Reserved */
		.lba = bytes_to_lba(SZ_RESERVED2)
	}
};

static struct dos_partition {
	const char *name;
	int part;
	u8 type;
	lbaint_t lba;
} dos_partitions[] = {
	{
		.name = "cache",
		.part = 3,
		.type = 0x83,
		.lba = bytes_to_lba(1024 * SZ_1M),
	}, {
		.name = "system",
		.part = 2,
		.type = 0x83,
		.lba = gbytes_to_lba(1),
	}, {
		.name = "vfat",
		.part = 1,
		.type = 0x0c,
		.lba = bytes_to_lba(128 * SZ_1M),
	}, {
		.name = "userdata",
		.part = 4,
		.type = 0x83,
		.lba = -1,
	},
};

static int n = 0;

static int valid_partition_number(int part)
{
	return (1 <= part) && (part <= ARRAY_SIZE(dos_partitions));
}

/*
 * Initiate dos partition index and return the first sector (lba)
 */
lbaint_t board_dos_partition_start(void)
{
	int n;
	lbaint_t next = 0;

	for (n = 0 ; n < ARRAY_SIZE(partitions); n++)
		next += partitions[n].lba;

	return next;
}

/*
 * Get the partition detail, partition number and its type, as well as
 * return the number of sectors to allocate for the partition.
 */
lbaint_t board_dos_partition_next(int *part, u8 *type)
{
	if (!valid_partition_number(n + 1))
		return 0;

	struct dos_partition *p = &dos_partitions[n++];

	*part = p->part;	/* partition number */
	*type = p->type;	/* partition type */

	/* Use remained sectors for this partition */
	if (p->lba == -1)
		return -1;

	return p->lba;
}

/*
 * Return the partition name of given partiton number. Since DOS partition
 * does not support name on its parition table, the partition names are
 * predefined upon each partition number.
 */
char *board_dos_partition_name(int part, char* name)
{
	int i;

	if (!valid_partition_number(part))
		return NULL;

	for (i = 0; i < ARRAY_SIZE(dos_partitions); i++) {
		/* Partition number is same with given to seek */
		if (dos_partitions[i].part == part) {
			strcpy(name, dos_partitions[i].name);
			return name;
		}
	}

	return NULL;
}

/*
 * Initiate the fastboot partition entries with internal system partitions and
 * DOS partition table.
 */
int board_partition_init(void)
{
	struct mmc *mmc;
	fastboot_ptentry ptn;
	lbaint_t next = 0;
	lbaint_t len;
	int n = 0;

	fastboot_flash_reset_ptn();

	mmc = find_mmc_device(CONFIG_FASTBOOT_FLASH_MMC_DEV);

	for (n = 0 ; mmc && n < ARRAY_SIZE(partitions); n++) {
		len = partitions[n].lba;

		/* Skip to add the partition if start with '-', but move forward
		 * to next position as much as its size
		 */
		if (partitions[n].name[0] == '-') {
			next += len;
			continue;
		}

		/* 'env' partition contains U-boot's environment fields, it
		 * could be damaged by fastboot if its offset is invalid with
		 * defined by CONFIG_ENV_OFFSET.
		 */
		if (!strcmp(partitions[n].name, "env") &&
				(bytes_to_lba(CONFIG_ENV_OFFSET) != next)) {
			printf("WARNING!!: Invalid offset of 'env' partition,"
					" it must be " LBAFU " but " LBAFU "\n",
					next, (lbaint_t)bytes_to_lba(CONFIG_ENV_OFFSET));
		}

		if (len == 0)
			len = mmc->block_dev.lba - next;

		strncpy((char*)&ptn.name, partitions[n].name, sizeof(ptn.name));

		ptn.start = next;
		ptn.length = len;

		/* Add the partition to fastboot partition entry table */
		fastboot_flash_add_ptn(&ptn);

		next += len;
	}

	fastboot_load_dos_partition();

	return 0;
}

int board_fastboot_pre_flash(block_dev_desc_t *dev_desc, lbaint_t start,
		void *buffer)
{
	if (start == 0) {
		/* MUST be trying to modify MBR, hence at least DOS partition
		 * table have to be kept. So buffer to flashing will be
		 * overwritten with exist partition table.
		 */
		u8 mbr[512];

		if (dev_desc->block_read(dev_desc->dev, start, 1, mbr) != 1) {
			printf("fastboot: can't read MBR from device %d\n",
					dev_desc->dev);
			return -EIO;
		}

		memcpy(buffer + 0x1be, &mbr[0x1be], 512 - 0x1be);
	}

	return 0;
}
