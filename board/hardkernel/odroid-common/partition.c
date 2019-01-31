#include <common.h>
#include <inttypes.h>
#include <common.h>
#include <part.h>
#include <storage.h>
#include <mmc.h>
#include <errno.h>

#include "../../../disk/part_dos.h"

#define PART_TYPE_FAT32 0x0C
#define PART_TYPE_LINEX_NATIVE_FS 0x83

#define bytes_to_lba(x)		((x) / 512L)

int mpt_write_partitions(struct mmc *mmc, struct partitions *partitions, int nr_parts);

static struct partitions factory_partitions[] = {
	{
		.name = "@MBR",
		.size = bytes_to_lba(CONFIG_MBR_SIZE),
	}, {
		.name = "bootloader",
		.size = bytes_to_lba(CONFIG_UBOOT_SIZE),
	}, {
		.name = "env",
		.size = bytes_to_lba(CONFIG_ENV_SIZE),
	}, {
		.name = "ptable",
		.size = bytes_to_lba(CONFIG_PTABLE_SIZE),
	}, {
		.name = "misc",			/* Android: misc */
		.size = bytes_to_lba(4 * SZ_1K),
	}, {
		.name = "logo",			/* Logo */
		.size = bytes_to_lba(2 * SZ_1M),
	}, {
		.name = "dtbs",			/* Device Tree */
		.size = bytes_to_lba(CONFIG_DTB_SIZE),
	}, {
		.name = "boot",			/* Boot image */
		.size = bytes_to_lba(16 * SZ_1M),
	}, {
		.name = "recovery",		/* Recovery Image */
		.size = bytes_to_lba(24 * SZ_1M),
	}, {
		.name = "cache",		/* Android: cache */
		.size = bytes_to_lba(1 * SZ_1G),
	}, {
		.name = "odm",			/* Android:odm, DOS FAT */
		.size = bytes_to_lba(32 * SZ_1M),
	}, {
		.name = "system",		/* Android: system */
		.size = bytes_to_lba(SZ_2G - SZ_256M),
	}, {
		.name = "vendor",		/* Android: vendor */
		.size = bytes_to_lba(SZ_512M),
	}, {
		.name = "product",		/* Android: product */
		.size = bytes_to_lba(SZ_32M),
	}, {
		.name = "param",
		.size = bytes_to_lba(16 * SZ_1M),
	}, {
		.name = "cri_data",
		.size = bytes_to_lba(8 * SZ_1M),
	}, {
		.name = "data",			/* Android: data */
		.size = -1,
	},
};

int board_partition_list(void)
{
	struct mmc *mmc = find_mmc_device(board_current_mmc());
	if (!mmc)
		return -ENODEV;

	print_part_mpt(&mmc->block_dev);
	printf("----------\n");

	return 0;
}

static int mpt_validate_partition_offset(block_dev_desc_t *dev_desc,
		struct partitions *partitions, int nr_parts)
{
	int i;
	uint64_t offset = 0;
	uint64_t blocks = dev_desc->lba;
	struct partitions *part = partitions;

	for (i = 0; i < nr_parts - 1; i++, part++) {
		if (part->offset == 0) {
			part->offset = offset;
		} else {
			if (part->offset < offset)
				printf("offset of '%s' is overlapped!\n", part->name);
			offset = part->offset;
		}

		offset += part->size;
		blocks = (blocks > part->size) ? (blocks - part->size) : 0;
	}

	part->offset = offset;
	part->size = blocks;

	return i;
}

static void dos_partition_entry(dos_partition_t *part,
		u32 start, u32 size, u8 type)
{
	part->boot_ind = 0x00;
	part->head = 0;
	part->sector = 1;
	part->cyl = 1;
	part->sys_ind = type;
	part->end_head = 0;
	part->end_sector = 0;
	part->end_cyl = 0;

	u32 *p = (u32 *)part->start4;
	*p = start;
	p = (u32 *)part->size4;
	*p = size;
}

int board_fdisk_all(void)
{
	u8 mbr[512];
	int ret;

	int mmc_dev = board_current_mmc();
	struct mmc *mmc = find_mmc_device(mmc_dev);
	if (mmc == NULL)
		return -ENODEV;

	/* Update MPT partitions */
	mpt_validate_partition_offset(&mmc->block_dev,
			factory_partitions,
			ARRAY_SIZE(factory_partitions));

	ret = mpt_write_partitions(mmc, factory_partitions,
			ARRAY_SIZE(factory_partitions));
	if (ret < 0) {
		printf("failed to update MPT partition table!!\n");
		return ret;
	}

	block_dev_desc_t *dev_desc = &mmc->block_dev;

	board_partition_list();

	/* Read the first sector, MBR, to buffer */
	if (dev_desc->block_read(dev_desc->dev, 0, 1, mbr) != 1) {
		printf("fastboot: can't read MBR from device %d\n",
				dev_desc->dev);
		return -EIO;
	}

	/* Initiate MBR sector for parititons and its type */
	memset(mbr + DOS_PART_TBL_OFFSET, 0, sizeof(dos_partition_t) * 4);

	disk_partition_t info;
	/* Android : set the 'odm' partition entry */
	ret = get_partition_info_mpt_by_name(dev_desc, "odm", &info);
	if (ret < 0) {
		printf("fastboot: no DOS partition is defined\n");
		return -ENOENT;
	}
	dos_partition_entry((dos_partition_t*)(mbr + DOS_PART_TBL_OFFSET),
			info.start, info.size, PART_TYPE_FAT32);

	/* Android : set the 'data' partition entry */
	ret = get_partition_info_mpt_by_name(dev_desc, "data", &info);
	if (ret < 0) {
		printf("fastboot: no DOS partition is defined\n");
		return -ENOENT;
	}
	dos_partition_entry((dos_partition_t *)(mbr + DOS_PART_TBL_OFFSET + sizeof(dos_partition_t)),
			info.start, info.size, PART_TYPE_LINEX_NATIVE_FS);

	/* Boot signature */
	mbr[0x1fe] = 0x55;
	mbr[0x1ff] = 0xaa;

	/* Write the MBR with new partition details */
	if (dev_desc->block_write(dev_desc->dev, 0, 1, mbr) != 1) {
		printf("fastboot: can't write MBR to device %d\n",
				dev_desc->dev);
		return -EIO;
	}

	init_part(dev_desc);

	return 0;
}
