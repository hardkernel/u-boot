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

#ifndef CONFIG_GENERIC_MMC
static int curr_device = -1;

int do_mmc (cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	int dev;

	if (argc < 2)
		return cmd_usage(cmdtp);

	if (strcmp(argv[1], "init") == 0) {
		if (argc == 2) {
			if (curr_device < 0)
				dev = 1;
			else
				dev = curr_device;
		} else if (argc == 3) {
			dev = (int)simple_strtoul(argv[2], NULL, 10);
		} else {
			return cmd_usage(cmdtp);
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
			return cmd_usage(cmdtp);
		}

		printf("mmc%d is current device\n", curr_device);
	} else {
		return cmd_usage(cmdtp);
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
	printf("Capacity: %lld\n", mmc->capacity);
	printf("Boot Part Size: %lld\n", mmc->boot_size);

	printf("Bus Width: %d-bit\n", mmc->bus_width);
}

int do_mmcinfo (cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	struct mmc *mmc;
	int dev_num;
	int ret = 1;

	if (argc < 2)
		dev_num = 0;
	else
		dev_num = simple_strtoul(argv[1], NULL, 0);

	mmc = find_mmc_device(dev_num);

	if (mmc) {
		if(mmc_init(mmc))
			return 1;
		print_mmcinfo(mmc);
		return 0;
	}

	return 1;
}

U_BOOT_CMD(
	mmcinfo, 2, 0, do_mmcinfo,
	"display MMC info",
	"<dev num>\n"
	"    - device number of the device to dislay info of\n"
	""
);

int do_mmcops(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	int rc = 0;

	switch (argc) {
	case 3:
		if (strcmp(argv[1], "rescan") == 0) {
			int dev = simple_strtoul(argv[2], NULL, 10);
			struct mmc *mmc = find_mmc_device(dev);

			if (!mmc)
				return 1;

			mmc_init(mmc);

			return 0;
		} else if (strncmp(argv[1], "part", 4) == 0) {
			int dev = simple_strtoul(argv[2], NULL, 10);
			block_dev_desc_t *mmc_dev;
			struct mmc *mmc = find_mmc_device(dev);

			if (!mmc) {
				puts("no mmc devices available\n");
				return 1;
			}
			mmc_init(mmc);
			mmc_dev = mmc_get_dev(dev);
			if (mmc_dev != NULL &&
			    mmc_dev->type != DEV_TYPE_UNKNOWN) {
				print_part(mmc_dev);
				return 0;
			}

			puts("get mmc type error!\n");
			return 1;
		}else if (strcmp(argv[1], "erase") == 0) {
		  int dev = simple_strtoul(argv[2], NULL, 10);
			u32 n=0;
			struct mmc *mmc = find_mmc_device(dev);

			if (!mmc)
				return 1;

			mmc_init(mmc);

			if (mmc->boot_size > 0){
				n = mmc->block_dev.block_erase(dev, 0, 0);
				printf("blocks erased: %d %s\n",
					  (int)(mmc->block_dev.lba), (n == 0) ? "OK" : "ERROR");
			}else{
				printf("boot_size 0 (tsd) doesn't support erase\n");
			}
			return (n == 0) ? 0 : 1;
		}

	case 0:
	case 1:
	case 4:
	        if(strcmp(argv[1], "switch")==0){
			int dev = simple_strtoul(argv[2], NULL, 10);
			struct mmc* mmc = find_mmc_device(dev);
			if(!mmc) {
				puts("no mmc devices available\n");
				return 1;
			}
			mmc_init(mmc);
            		if(strcmp(argv[3], "boot0")==0)
                		mmc_switch_partition(mmc, 1);
	            	else if(strcmp(argv[3], "boot1")==0)
        	        	mmc_switch_partition(mmc, 2);
	            	else if(strcmp(argv[3], "user")==0)
        	        	mmc_switch_partition(mmc, 0);
			}
			#ifdef CONFIG_AML_EMMC_KEY
			if(strcmp(argv[1], "erase")==0){
				int dev = simple_strtoul(argv[2], NULL, 10);
				if(strcmp(argv[3], "key")==0){
					struct mmc* mmc = find_mmc_device(dev);
					if(!mmc){
						printf("device %d is invalid\n",dev);
						return 1;
					}
					mmc->key_protect = 0;
					return 0;
				}
			}
			#endif
		return 1;

	case 2:
		if (!strcmp(argv[1], "list")) {
			print_mmc_devices('\n');
			return 0;
		}
		return 1;
	default: /* at least 5 args */
		if (strcmp(argv[1], "read") == 0) {
			int dev = simple_strtoul(argv[2], NULL, 10);
			void *addr = (void *)simple_strtoul(argv[3], NULL, 16);
			u32 cnt = simple_strtoul(argv[5], NULL, 16);
			u32 n;
			u32 blk = simple_strtoul(argv[4], NULL, 16);
			struct mmc *mmc = find_mmc_device(dev);

			if (!mmc)
				return 1;

			printf("\nMMC read: dev # %d, block # %d, count %d ... ",
				dev, blk, cnt);

			mmc_init(mmc);

			n = mmc->block_dev.block_read(dev, blk, cnt, addr);

			/* flush cache after read */
			//flush_cache((ulong)addr, cnt * 512); /* FIXME */

			printf("%d blocks read: %s\n",
				n, (n==cnt) ? "OK" : "ERROR");
			return (n == cnt) ? 0 : 1;
		} else if (strcmp(argv[1], "write") == 0) {
			int dev = simple_strtoul(argv[2], NULL, 10);
			void *addr = (void *)simple_strtoul(argv[3], NULL, 16);
			u32 cnt = simple_strtoul(argv[5], NULL, 16);
			u32 n;
			struct mmc *mmc = find_mmc_device(dev);

			int blk = simple_strtoul(argv[4], NULL, 16);

			if (!mmc)
				return 1;

			printf("\nMMC write: dev # %d, block # %d, count %d ... ",
				dev, blk, cnt);

			mmc_init(mmc);

			n = mmc->block_dev.block_write(dev, blk, cnt, addr);

			printf("%d blocks written: %s\n",
				n, (n == cnt) ? "OK" : "ERROR");
			return (n == cnt) ? 0 : 1;
		}
		else if (strcmp(argv[1], "erase") == 0) {
			int dev = simple_strtoul(argv[2], NULL, 10);			
			u32 cnt = simple_strtoul(argv[4], NULL, 16);
			u32 n = 0;
			struct mmc *mmc = find_mmc_device(dev);

			int blk = simple_strtoul(argv[3], NULL, 16);

			if (!mmc)
				return 1;

			printf("\nMMC erase: dev # %d, group # %d, count %d ... ",
				dev, blk, cnt);

			mmc_init(mmc);

			if (cnt != 0 && mmc->boot_size > 0)
				n = mmc->block_dev.block_erase(dev, blk, cnt);

		  printf("%d groups erased: %s\n",
			  cnt, (n == 0) ? "OK" : "ERROR");
			return (n == 0) ? 0 : 1;
		} else
			rc = cmd_usage(cmdtp);

		return rc;
	}
}

U_BOOT_CMD(
	mmc, 6, 1, do_mmcops,
	"MMC sub system",
	"read <device num> addr blk# cnt\n"
	"mmc write <device num> addr blk# cnt\n"
	"mmc erase <device num> grp# cnt\n"
	"mmc erase <device num>\n"
	"mmc rescan <device num>\n"
	"mmc part <device num> - lists available partition on mmc\n"
	"mmc list - lists available devices\n"
	"mmc switch <device num> <part name> - part name : boot0, boot1, user");




static void do_mmcdump(cmd_tbl_t * cmdtp,int flag,int argc,char * const argv [ ])
{
	unsigned int i =0;
	char    buf[200] = {};

	 if (argc > 2) {
		printf (" arguments error\n");
		return -1;
	}


	u64 Capacity = 2909798400;
	unsigned int BlockLen = 512;
	unsigned int MaxBlock  = Capacity/BlockLen;
	unsigned int PRB = 0x8000;//PerReadBlock
	unsigned int ReadCnt_I = MaxBlock /PRB;
	unsigned int ReadCnt_R = MaxBlock %PRB;
	unsigned int userstartblock = 0;
	unsigned int bootsize = 0;
	struct mmc *mmc = NULL;
	mmc = find_mmc_device(1);
	if (mmc)
	{
		printf("mmc 1:---------------------\n");

		mmc_init(mmc);
		print_mmcinfo(mmc);
		Capacity = mmc->capacity  - mmc->boot_size;//for boot need not read
		bootsize = mmc->boot_size;
		BlockLen = mmc->read_bl_len;
		MaxBlock  = Capacity/BlockLen;
		ReadCnt_I = MaxBlock /PRB;
		ReadCnt_R = MaxBlock %PRB;
		userstartblock = bootsize/BlockLen;

	}
	else
	{
		printf("mmc 1 error !!!");
		return -1;
	}
	printf("mmc 0:---------------------\n");
	run_command ("mmcinfo", 0);

	printf("get dump mmc info:---------------------\n");

	printf("Capacity.%lld\n",Capacity);
	printf("userstartblock.%x\n",userstartblock);
	printf("MaxBlock.%x\n",MaxBlock);
	printf("ReadCntI.%d\n",ReadCnt_I);
	printf("ReadCnt_R.%d\n",ReadCnt_R);
	printf("start dump boot--------------------\n");

	if(bootsize)// first  dump boot / ,boot block = userstartblock
	{
		//run_command ("mmc switch 1 boot0", 0);
		sprintf(buf, "mmc read 1 0x82000000 0x%x 0x%x\n",0, (userstartblock -1) );
		run_command (buf, 0);

		sprintf(buf, "mmc write  0 0x82000000 0x%x 0x%x\n",0, (userstartblock -1));
		run_command (buf, 0);

	}
		printf("start dump user--------------------\n");

	run_command ("mmc switch 1 user", 0);
	for(i = 0; i< ReadCnt_I; i++)//inter
	{
		sprintf(buf, "mmc read 1 0x82000000 0x%x 0x%x\n",(userstartblock + (i*PRB)),PRB);
		run_command (buf, 0);

		sprintf(buf, "mmc write  0 0x82000000 0x%x 0x%x\n",userstartblock + (i*PRB),PRB);
		run_command (buf, 0);

		//print msg --------------------
		int percent = (i*1000)/ReadCnt_I;
		printf("percent:%d.%d",percent/10, percent%10);
	}
	if(ReadCnt_R)//residual
	{
		sprintf(buf, "mmc read 1 0x82000000 0x%x 0x%x\n",(userstartblock + (ReadCnt_I*PRB)),(ReadCnt_R - 1));
		run_command (buf, 0);

		sprintf(buf, "mmc write  0 0x82000000 0x%x 0x%x\n",(userstartblock + (ReadCnt_I*PRB)), (ReadCnt_R - 1) );
		run_command (buf, 0);
		printf("percent:%d",100);

	}


}

U_BOOT_CMD(
	mmcdump,	2,	0,	do_mmcdump,
	"mmc data load ",
	"/N\n"
	"load all mmc data to sdcard'\n"
);
#endif
