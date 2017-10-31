/*
 * Copyright (C) 2015 Hardkernel Co,. Ltd
 * Dongjin Kim <tobetter@gmail.com>
 *
 * This driver has been modified to support ODROID-N1
 *   Modified by Joy Cho <joycho78@gmail.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <linux/sizes.h>
#include <linux/string.h>
#include <disk.h>

/* FIXME: Is block size always 512? */
#define bytes_to_lba(x)		((x) / 512)
#define gbytes_to_lba(x)	((x) * 1024 * 1024 * 2)

#define SZ_RESERVED		(8 * SZ_1M)	/* MBR + idbloader */
#define SZ_RESERVED2		(1020 * SZ_1K)	/* Start offset of cache is 121MB */

static struct fbt_partition {
	const char *name;
	lbaint_t lba;
} partitions[] = {
	{
		.name = "-reserved",
		.lba = bytes_to_lba(SZ_RESERVED)
	}, {
		.name = "uboot",
		.lba = bytes_to_lba(4 * SZ_1M)
	}, {
		.name = "trust",
		.lba = bytes_to_lba(4 * SZ_1M)
	}, {
		.name = "bcb",			/* Bootloader control block */
		.lba = bytes_to_lba(4 * SZ_1K)
	}, {
		.name = "dtb",			/* Device Tree */
		.lba = bytes_to_lba(16 * SZ_1M)
	}, {
		.name = "kernel",		/* kernel image */
		.lba = bytes_to_lba(24 * SZ_1M)
	}, {
		.name = "boot",		/* ramdisk image */
		.lba = bytes_to_lba(32 * SZ_1M)
	}, {
		.name = "recovery",		/* Recovery Image */
		.lba = bytes_to_lba(32 * SZ_1M)
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
		.lba = bytes_to_lba(1536 * SZ_1M),
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

static int dos_next = 0;

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

	/* init dos_next index */
	dos_next = 0;

	return next;
}

/*
 * Get the partition detail, partition number and its type, as well as
 * return the number of sectors to allocate for the partition.
 */
lbaint_t board_dos_partition_next(int *part, u8 *type)
{
	if (!valid_partition_number(dos_next + 1))
		return 0;

	struct dos_partition *p = &dos_partitions[dos_next++];

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
 * Scan all of boot devices and check magic pattern
 * magic1 : 6 chars of fixed uboot header pattern
 * magic2 : 4 chars of fixed trust header pattern
 */
#define MMC_DEV_SDHCI	0	/* sdhci@fe330000 */
#define MMC_DEV_DWMMC	1	/* sdmmc@fe320000 */
#define MAGIC_OFFSET1	16384
#define MAGIC_OFFSET2	24576
static const char *magic1 = "LOADER";
static const char *magic2 = "BL3X";

int board_check_magic(struct blk_desc *dev_desc)
{
	char pattern[512];

	/* Check magic1 */
	if (blk_dread(dev_desc, MAGIC_OFFSET1, 1, pattern) != 1) {
		printf("scan boot: block read fail\n");
		return -EIO;
	}

	if (0 != strncmp(pattern, magic1, strlen(magic1))) {
		printf("scan boot: magic1 fail");
		return -EIO;
	}

	/* Check magic2 */
	if (blk_dread(dev_desc, MAGIC_OFFSET2, 1, pattern) != 1) {
		printf("scan boot: block read fail\n");
		return -EIO;
	}

	if (0 != strncmp(pattern, magic2, strlen(magic2))) {
		printf("scan boot: magic2 fail");
		return -EIO;
	}

	return 0;
}

int board_scan_boot_storage(void)
{
	struct mmc *mmc;
	struct blk_desc *dev_desc;

	/* First, try checking eMMC */
	mmc = find_mmc_device(MMC_DEV_SDHCI);
	if (!mmc) {
		printf("no sdhci device\n");
	} else {
		dev_desc = blk_get_dev("mmc", MMC_DEV_SDHCI);
		if (dev_desc) {
			if (0 == board_check_magic(dev_desc)) {
				/* Two magic patterns are available
				 * on eMMC, so related env is set
				 * and then exit this routine.
				 */
				setenv("storagemedia", "emmc");
				setenv("bootdev", "0");
				run_command("setenv bootargs ${bootargs} storagemedia=emmc", 0);
				saveenv();

				return 0;
			}
		}
	}

	/* No emmc magic, now try sdmmc */
	mmc = find_mmc_device(MMC_DEV_DWMMC);
	if (!mmc) {
		printf("no sdmmc device, no way...\n");
	} else {
		dev_desc = blk_get_dev("mmc", MMC_DEV_DWMMC);
		if (dev_desc) {
			if (0 == board_check_magic(dev_desc)) {
				setenv("storagemedia", "sd");
				setenv("bootdev", "1");
				run_command("setenv bootargs ${bootargs} storagemedia=sd", 0);
				saveenv();

				return 0;
			}
		}
	}

	return -EIO;
}

/*
 * Initiate the disk partition entries with internal system partitions and
 * DOS partition table.
 */
int board_partition_init(void)
{
	struct mmc *mmc;
	struct blk_desc *dev_desc;
	disk_ptentry ptn;
	lbaint_t next = 0;
	lbaint_t len;
	int n = 0;
	u32 dev_no;

	disk_flash_reset_ptn();

	dev_no = getenv_ulong("bootdev", 10, 0);
	mmc = find_mmc_device(dev_no);
	if (!mmc) {
		printf("no mmc device\n");
		return -1;
	}

	dev_desc = blk_get_dev("mmc", dev_no);
	if (!dev_desc) {
		printf("invalid mmc device\n");
		return -1;
	}

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
		 * could be damaged by disk if its offset is invalid with
		 * defined by CONFIG_ENV_OFFSET.
		 */
		if (!strcmp(partitions[n].name, "env") &&
				(bytes_to_lba(CONFIG_ENV_OFFSET) != next)) {
			printf("WARNING!!: Invalid offset of 'env' partition,"
					" it must be " LBAFU " but " LBAFU "\n",
					next, (lbaint_t)bytes_to_lba(CONFIG_ENV_OFFSET));
		}

		if (len == 0)
			len = dev_desc->lba - next;

		strncpy((char*)&ptn.name, partitions[n].name, sizeof(ptn.name));

		ptn.start = next;
		ptn.length = len;

		/* Add the partition to disk partition entry table */
		disk_flash_add_ptn(&ptn);

		next += len;
	}

	disk_load_dos_partition();

	return 0;
}
