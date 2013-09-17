/*
 * (C) Copyright 2003
 * Kyle Harris, kharris@nexus-tech.net
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */

#include <common.h>
#include <command.h>
#include <mmc.h>

static int curr_device = -1;
#ifndef CONFIG_GENERIC_MMC
int do_mmc (cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	int dev;

	if (argc < 2)
		return CMD_RET_USAGE;

	if (strcmp(argv[1], "init") == 0) {
		if (argc == 2) {
			if (curr_device < 0)
				dev = 1;
			else
				dev = curr_device;
		} else if (argc == 3) {
			dev = (int)simple_strtoul(argv[2], NULL, 10);
		} else {
			return CMD_RET_USAGE;
		}

		if (mmc_legacy_init(dev) != 0) {
			puts("No MMC card found\n");
			return 1;
		}

		curr_device = dev;
		printf("mmc%d is available\n", curr_device);
	} else if (strcmp(argv[1], "device") == 0) {
		if (argc == 2) {
			if (curr_device < 0) {
				puts("No MMC device available\n");
				return 1;
			}
		} else if (argc == 3) {
			dev = (int)simple_strtoul(argv[2], NULL, 10);

#ifdef CONFIG_SYS_MMC_SET_DEV
			if (mmc_set_dev(dev) != 0)
				return 1;
#endif
			curr_device = dev;
		} else {
			return CMD_RET_USAGE;
		}

		printf("mmc%d is current device\n", curr_device);
	} else {
		return CMD_RET_USAGE;
	}

	return 0;
}

U_BOOT_CMD(
	mmc, 3, 1, do_mmc,
	"MMC sub-system",
	"init [dev] - init MMC sub system\n"
	"mmc device [dev] - show or set current device"
);
#else /* !CONFIG_GENERIC_MMC */

enum mmc_state {
	MMC_INVALID,
	MMC_READ,
	MMC_WRITE,
	MMC_ERASE,
};
static void print_mmcinfo(struct mmc *mmc)
{
	printf("Device: %s\n", mmc->name);
	printf("Manufacturer ID: %x\n", mmc->cid[0] >> 24);
	printf("OEM: %x\n", (mmc->cid[0] >> 8) & 0xffff);
	printf("Name: %c%c%c%c%c \n", mmc->cid[0] & 0xff,
			(mmc->cid[1] >> 24), (mmc->cid[1] >> 16) & 0xff,
			(mmc->cid[1] >> 8) & 0xff, mmc->cid[1] & 0xff);

	printf("Tran Speed: %d\n", mmc->tran_speed);
	printf("Rd Block Len: %d\n", mmc->read_bl_len);

	printf("%s version %d.%d\n", IS_SD(mmc) ? "SD" : "MMC",
			(mmc->version >> 4) & 0xf, mmc->version & 0xf);

	printf("High Capacity: %s\n", mmc->high_capacity ? "Yes" : "No");
	puts("Capacity: ");
	print_size(mmc->capacity, "\n");

	printf("Bus Width: %d-bit %s\n", mmc->bus_width,
				mmc->ddr ? "DDR" : "SDR");
}

int do_mmcinfo (cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	struct mmc *mmc;
	int dev_num, err;

	if (argc == 2)
		dev_num = simple_strtoul(argv[1], NULL, 10);
	else if (curr_device < 0) {
		if (get_mmc_num() > 0) {
			curr_device = 0;
			dev_num = curr_device;
		}
		else {
			puts("No MMC device available\n");
			return 1;
		}
	}

	mmc = find_mmc_device(dev_num);

	if (mmc) {
		mmc->has_init = 0;

		err = mmc_init(mmc);
		if (err) {
			printf("no mmc device at slot %x\n", dev_num);
			return err;
		}

		print_mmcinfo(mmc);
		return 0;
	} else {
		printf("no mmc device at slot %x\n", dev_num);
		return 1;
	}
}

U_BOOT_CMD(
	mmcinfo, 2, 0, do_mmcinfo,
	"display MMC info",
	"mmcinfo [dev_num]\n"
	"    - device number of the device to dislay info of\n"
	""
);

int do_mmcops(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	enum mmc_state state;

	if (argc < 2)
		return CMD_RET_USAGE;

	if (curr_device < 0) {
		if (get_mmc_num() > 0)
			curr_device = 0;
		else {
			puts("No MMC device available\n");
			return 1;
		}
	}

	if (strcmp(argv[1], "rescan") == 0) {
		struct mmc *mmc = find_mmc_device(curr_device);

		if (!mmc) {
			printf("no mmc device at slot %x\n", curr_device);
			return 1;
		}

		mmc->has_init = 0;

		if (mmc_init(mmc))
			return 1;
		else
			return 0;
	} else if (strncmp(argv[1], "part", 4) == 0) {
		block_dev_desc_t *mmc_dev;
		struct mmc *mmc = find_mmc_device(curr_device);

		if (!mmc) {
			printf("no mmc device at slot %x\n", curr_device);
			return 1;
		}
		mmc_init(mmc);
		mmc_dev = mmc_get_dev(curr_device);
		if (mmc_dev != NULL &&
				mmc_dev->type != DEV_TYPE_UNKNOWN) {
			print_part(mmc_dev);
			return 0;
		}

		puts("get mmc type error!\n");
		return 1;
	} else if (strcmp(argv[1], "list") == 0) {
		print_mmc_devices('\n');
		return 0;
	} else if (strcmp(argv[1], "dev") == 0) {
		int dev, part = -1;
		struct mmc *mmc;

		if (argc == 2)
			dev = curr_device;
		else if (argc == 3)
			dev = simple_strtoul(argv[2], NULL, 10);
		else if (argc == 4) {
			dev = (int)simple_strtoul(argv[2], NULL, 10);
			part = (int)simple_strtoul(argv[3], NULL, 10);
			if (part > PART_ACCESS_MASK) {
				printf("#part_num shouldn't be larger"
					" than %d\n", PART_ACCESS_MASK);
				return 1;
			}
		} else
			return CMD_RET_USAGE;

		mmc = find_mmc_device(dev);
		if (!mmc) {
			printf("no mmc device at slot %x\n", dev);
			return 1;
		}

		mmc_init(mmc);
		if (part != -1) {
			int ret;
			if (mmc->part_config == MMCPART_NOAVAILABLE) {
				printf("Card doesn't support part_switch\n");
				return 1;
			}

			if (part != mmc->part_num) {
				ret = mmc_switch_part(dev, part);
				if (!ret)
					mmc->part_num = part;

				printf("switch to partions #%d, %s\n",
						part, (!ret) ? "OK" : "ERROR");
			}
		}
		curr_device = dev;
		if (mmc->part_config == MMCPART_NOAVAILABLE)
			printf("mmc%d is current device\n", curr_device);
		else
			printf("mmc%d(part %d) is current device\n",
				curr_device, mmc->part_num);

		return 0;
	}

	if (strcmp(argv[1], "read") == 0)
		state = MMC_READ;
	else if (strcmp(argv[1], "write") == 0)
		state = MMC_WRITE;
	else if (strcmp(argv[1], "erase") == 0)
		state = MMC_ERASE;
	else
		state = MMC_INVALID;

	if (state != MMC_INVALID) {
		int idx = 3;
		if (state == MMC_ERASE)
			idx = 4;
		int dev = simple_strtoul(argv[idx - 1], NULL, 10);
		struct mmc *mmc = find_mmc_device(dev);
		u32 blk, cnt, count, n;
		void *addr;
		int part, err;

		curr_device = dev;

		if (state != MMC_ERASE) {
			addr = (void *)simple_strtoul(argv[idx], NULL, 16);
			++idx;
		} else
			addr = 0;
		blk = simple_strtoul(argv[idx], NULL, 16);
		cnt = simple_strtoul(argv[idx + 1], NULL, 16);

		if (!mmc) {
			printf("no mmc device at slot %x\n", curr_device);
			return 1;
		}

		printf("\nMMC %s: dev # %d, block # %d, count %d ... ",
				argv[1], curr_device, blk, cnt);

		mmc_init(mmc);

		switch (state) {
		case MMC_READ:
			n = mmc->block_dev.block_read(curr_device, blk,
						      cnt, addr);
			/* flush cache after read */
			flush_cache((ulong)addr, cnt * 512); /* FIXME */
			break;
		case MMC_WRITE:
			n = mmc->block_dev.block_write(curr_device, blk,
						      cnt, addr);
			break;
		case MMC_ERASE:

			/* Select erase partition */
			if (strcmp(argv[2], "boot") == 0) {
				part = 0;
				/* Read Boot partition size. */
				count = mmc->boot_size_multi / mmc->read_bl_len;
			} else if (strcmp(argv[2], "user") == 0) {
				part = 1;
				/* Read User partition size. */
				count = mmc->capacity / mmc->read_bl_len;
			} else {
				part = 1;
				count = mmc->capacity / mmc->read_bl_len;
				printf("Default erase user partition\n");
			}

			/* If input counter is larger than max counter */
			if ((blk + cnt) > count) {
				cnt = (count - blk) - 1;
				printf("Block count is Too BIG!!\n");
			}

			/* If input counter is 0 */
			if (!cnt ) {
				cnt = (count - blk) - 1;
				printf("Erase all from %d block\n", blk);
			}

			if (part == 0) {
				err = emmc_boot_open(mmc);
				if (err)
					printf("eMMC OPEN Failed.!!\n");
			}

			n = mmc->block_dev.block_erase(curr_device, blk, cnt);

			if (part == 0) {
				err = emmc_boot_close(mmc);
				if (err)
					printf("eMMC CLOSE Failed.!!\n");
			}
			break;
		default:
			BUG();
		}

		printf("%d blocks %s: %s\n",
				n, argv[1], (n == cnt) ? "OK" : "ERROR");
		return (n == cnt) ? 0 : 1;
	}

	return CMD_RET_USAGE;
}

U_BOOT_CMD(
	mmc, 6, 1, do_mmcops,
	"MMC sub system",
	"mmc read [dev] addr blk# cnt\n"
	"mmc write [dev] addr blk# cnt\n"
	"mmc erase [boot | user] [dev] blk# cnt\n"
	"mmc rescan\n"
	"mmc part - lists available partition on current mmc device\n"
	"mmc dev [dev] [part] - show or set current mmc device [partition]\n"
	"mmc list - lists available devices");

int do_emmc(cmd_tbl_t *cmdtp, int flag, int argc, char *argv[])
{
	int rc = 0;
	u32 dev;

	switch (argc) {
	case 5:
		if (strcmp(argv[1], "partition") == 0) {
			dev = simple_strtoul(argv[2], NULL, 10);
			struct mmc *mmc = find_mmc_device(dev);
			u32 bootsize = simple_strtoul(argv[3], NULL, 10);
			u32 rpmbsize = simple_strtoul(argv[4], NULL, 10);

			if (!mmc)
				rc = 1;

			rc = emmc_boot_partition_size_change(mmc, bootsize, rpmbsize);
			if (rc == 0) {
				printf("eMMC boot partition Size is %d MB.!!\n", bootsize);
				printf("eMMC RPMB partition Size is %d MB.!!\n", rpmbsize);
			} else {
				printf("eMMC boot partition Size change Failed.!!\n");
			}
		} else {
			printf("Usage:\n%s\n", cmdtp->usage);
			rc =1;
		}
		break;

	case 3:
		if (strcmp(argv[1], "open") == 0) {
			int dev = simple_strtoul(argv[2], NULL, 10);
			struct mmc *mmc = find_mmc_device(dev);

			if (!mmc)
				rc = 1;

			rc = emmc_boot_open(mmc);

			if (rc == 0) {
			printf("eMMC OPEN Success.!!\n");
			printf("\t\t\t!!!Notice!!!\n");
			printf("!You must close eMMC boot Partition after all image writing!\n");
			printf("!eMMC boot partition has continuity at image writing time.!\n");
			printf("!So, Do not close boot partition, Before, all images is written.!\n");
			} else {
				printf("eMMC OPEN Failed.!!\n");
			}
		} else if (strcmp(argv[1], "close") == 0) {
			int dev = simple_strtoul(argv[2], NULL, 10);
			struct mmc *mmc = find_mmc_device(dev);

			if (!mmc)
				rc = 1;

			rc = emmc_boot_close(mmc);

			if (rc == 0) {
				printf("eMMC CLOSE Success.!!\n");
			} else {
				printf("eMMC CLOSE Failed.!!\n");
			}
		} else {
			printf("Usage:\n%s\n", cmdtp->usage);
			rc =1;
		}
		break;
	case 0:
	case 1:
	case 2:
	case 4:
	default:
		printf("Usage:\n%s\n", cmdtp->usage);
		rc = 1;
		break;
	}

	return rc;
}


U_BOOT_CMD(
	emmc,	5,	0,	do_emmc,
	"Open/Close eMMC boot Partition",
	"emmc open <device num> \n"
	"emmc close <device num> \n"
	"emmc partition <device num> <boot partiton size MB> <RPMB partition size MB>\n");
#endif
