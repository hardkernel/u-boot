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

#if defined(CONFIG_S5P6450)
DECLARE_GLOBAL_DATA_PTR;
#endif

#define MAXIMUM_BLOCK_COUNT 0xFFFF

static void print_mmcinfo(struct mmc *mmc)
{
	char *bw[10];

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
	printf("Size: %dMB (block: %d)\n",
			(mmc->capacity/(1024*1024/mmc->read_bl_len)),
			(mmc->capacity));

	if (mmc->bus_width == MMC_BUS_WIDTH_4) {
		bw[0] = "4-bit";
	} else if (mmc->bus_width == MMC_BUS_WIDTH_8){
		bw[0] = "8-bit";
	} else if (mmc->bus_width == MMC_BUS_WIDTH_4_DDR){
		bw[0] = "4-bit DDR";
	} else if (mmc->bus_width == MMC_BUS_WIDTH_8_DDR){
		bw[0] = "8-bit DDR";
	} else {
		bw[0] = "1-bit";
	}
	printf("Bus Width: %s\n", *bw);
	printf("Boot Partition Size: %d KB\n", ((mmc->ext_csd.boot_size_multi)*128));
}

int do_mmcinfo (cmd_tbl_t *cmdtp, int flag, int argc, char *argv[])
{
	struct mmc *mmc;
	int dev_num, err;

	if (argc < 2)
		dev_num = 0;
	else
		dev_num = simple_strtoul(argv[1], NULL, 10);

	mmc = find_mmc_device(dev_num);

	if (mmc) {
		mmc->ext_csd.boot_size_multi = 0;
		err = mmc_init(mmc);
		if (err) {
			printf("Card NOT detected or Init Failed!!\n");
			return err;
		}
		print_mmcinfo(mmc);
	}

	return 0;
}

U_BOOT_CMD(mmcinfo, 2, 0, do_mmcinfo,
	"mmcinfo <dev num>-- display MMC info",
	""
);

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

int do_mmcops(cmd_tbl_t *cmdtp, int flag, int argc, char *argv[])
{
	int rc = 0;
	int part = 0;

	switch (argc) {
	case 3:
		if (strcmp(argv[1], "rescan") == 0) {
			int dev = simple_strtoul(argv[2], NULL, 10);
			struct mmc *mmc = find_mmc_device(dev);

			if (!mmc)
				return 1;

			mmc_init(mmc);

			return 0;
		}

	case 0:
	case 1:
	case 4:
		printf("Usage:\n%s\n", cmdtp->usage);
		return 1;

	case 2:
		if (!strcmp(argv[1], "list")) {
			print_mmc_devices('\n');
			return 0;
		}
		return 1;
	case 6:
		if (strcmp(argv[1], "erase") == 0) {
			/* Read input variable */
			int dev = simple_strtoul(argv[3], NULL, 10);
			u32 start = simple_strtoul(argv[4], NULL, 10);
			u32 block = simple_strtoul(argv[5], NULL, 10);

			struct mmc *mmc = find_mmc_device(dev);

			u32 count = 0;

			/* Select erase partition */
			if (strcmp(argv[2], "boot") == 0) {
				part = 0;
				/* Read Boot partition size. */
				count = ((mmc->ext_csd.boot_size_multi)*256);
			} else if (strcmp(argv[2], "user") == 0) {
				part = 1;
				/* Read User partition size. */
				count = mmc->capacity;
			} else {
				part = 1;
				count = mmc->capacity;
				printf("Default erase user partition\n");
			}

			/* If input counter is larger than max counter */
			if ((start + block) > count) {
				block = (count - start) - 1;
				printf("Block count is Too BIG!!\n");
			}

			/* If input counter is 0 */
			if (!block ) {
				block = (count - start) - 1;
				printf("Erase all from %d block\n", start);
			}

			if (!mmc)
				rc = 1;

			rc = mmc_erase(mmc, part, start, block);

			if (rc == 0) {
				printf("MMC erase Success.!!\n");
			} else {
				printf("MMC erase Failed.!!\n");
				return -1;
			}
			return 0;
		} else if (strcmp(argv[1], "read") == 0) {
			int dev = simple_strtoul(argv[2], NULL, 10);
			void *addr = (void *)simple_strtoul(argv[3], NULL, 16);
			u32 cnt = simple_strtoul(argv[5], NULL, 16);
			u32 n;
			u32 blk = simple_strtoul(argv[4], NULL, 16);
			u32 read_cnt;
			u32 cnt_to_read;
			void *addr_to_read = addr;
			struct mmc *mmc = find_mmc_device(dev);

			if (!mmc)
				return 1;

			printf("\nMMC read: dev # %d, block # %d, count %d ... ",
				dev, blk, cnt);

			n = 0;
			addr_to_read = addr;
			do {
				if (cnt - n > MAXIMUM_BLOCK_COUNT)
					cnt_to_read = MAXIMUM_BLOCK_COUNT;
				else
					cnt_to_read = cnt - n;

				read_cnt = mmc->block_dev.block_read(dev, blk, cnt_to_read, addr_to_read);
				n += read_cnt;
				blk += read_cnt;
				addr_to_read += read_cnt * 512;
				if(cnt_to_read != read_cnt) {
					printf("%d blocks read: %s\n",
						n, "ERROR");
					return -1;
				}
			} while(cnt > n);

			/* flush cache after read */
			flush_cache((ulong)addr, cnt * 512); /* FIXME */

			printf("%d blocks read: %s\n",
				n, (n==cnt) ? "OK" : "ERROR");
			return (n == cnt) ? 0 : 1;
		} else if (strcmp(argv[1], "write") == 0) {
			int dev = simple_strtoul(argv[2], NULL, 10);
			void *addr = (void *)simple_strtoul(argv[3], NULL, 16);
			u32 cnt = simple_strtoul(argv[5], NULL, 16);
			int blk = simple_strtoul(argv[4], NULL, 16);
			u32 n;
			u32 written_cnt;
			u32 cnt_to_write;
			void *addr_to_write = addr;
			struct mmc *mmc = find_mmc_device(dev);


			if (!mmc)
				return 1;

			printf("\nMMC write: dev # %d, block # %d, count %d ... ",
				dev, blk, cnt);

			n = 0;
			addr_to_write = addr;
			do {
				if (cnt - n > MAXIMUM_BLOCK_COUNT)
					cnt_to_write = MAXIMUM_BLOCK_COUNT;
				else
					cnt_to_write = cnt - n;

				written_cnt = mmc->block_dev.block_write(dev, blk, cnt_to_write, addr_to_write);
				n += written_cnt;
				blk += written_cnt;
				addr_to_write += written_cnt * 512;
				if(cnt_to_write != written_cnt) {
					printf("%d blocks written: %s\n",
						n, "ERROR");
					return -1;
				}
			} while(cnt > n);

			printf("%d blocks written: %s\n",
				n, (n == cnt) ? "OK" : "ERROR");
			return (n == cnt) ? 0 : 1;
		} else {
			printf("Usage:\n%s\n", cmdtp->usage);
			rc = 1;
		}

		return rc;
	default: /* at least 5 args */
		printf("Usage:\n%s\n", cmdtp->usage);
		return 1;
	}
}

U_BOOT_CMD(
	mmc, 6, 1, do_mmcops,
	"MMC sub system",
	"read <device num> addr blk# cnt\n"
	"mmc write <device num> addr blk# cnt\n"
	"mmc rescan <device num>\n"
	"mmc erase <boot | user> <device num> <start block> <block count>\n"
	"mmc list - lists available devices");
