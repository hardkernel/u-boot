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
#include <malloc.h>
#include <command.h>
#include <linux/ctype.h>
#include <mmc.h>
#include <partition_table.h>
#include <emmc_partitions.h>
#include <asm/arch/cpu_sdio.h>
#include <asm/arch/sd_emmc.h>
#include <linux/sizes.h>
#include <asm/cpu_id.h>
#include <amlogic/aml_mmc.h>
#include <errno.h>

#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
#define SD_EMMC_VDDEE_REG (*((volatile unsigned *)(0xff807000 + (0x01 << 2))))
#ifdef MMC_HS200_MODE
//#define MMC_NO_BOOT_PARTITION
/*tl1*/
static int pwm_voltage_table_ee[][2] = {
	{ 0x1c0000,  681},
	{ 0x1b0001,  691},
	{ 0x1a0002,  701},
	{ 0x190003,  711},
	{ 0x180004,  721},
	{ 0x170005,  731},
	{ 0x160006,  741},
	{ 0x150007,  751},
	{ 0x140008,  761},
	{ 0x130009,  772},
	{ 0x12000a,  782},
	{ 0x11000b,  792},
	{ 0x10000c,  802},
	{ 0x0f000d,  812},
	{ 0x0e000e,  822},
	{ 0x0d000f,  832},
	{ 0x0c0010,  842},
	{ 0x0b0011,  852},
	{ 0x0a0012,  862},
	{ 0x090013,  872},
	{ 0x080014,  882},
	{ 0x070015,  892},
	{ 0x060016,  902},
	{ 0x050017,  912},
	{ 0x040018,  922},
	{ 0x030019,  932},
	{ 0x02001a,  942},
	{ 0x01001b,  952},
	{ 0x00001c,  962}
};

/*g12b*/
//static int pwm_voltage_table_ee[][2] = {
//  { 0x1c0000,  681},
//  { 0x1b0001,  691},
//  { 0x1a0002,  701},
//  { 0x190003,  711},
//  { 0x180004,  721},
//  { 0x170005,  731},
//  { 0x160006,  741},
//  { 0x150007,  751},
//  { 0x140008,  761},
//  { 0x130009,  772},
//  { 0x12000a,  782},
//  { 0x11000b,  792},
//  { 0x10000c,  802},
//  { 0x0f000d,  812},
//  { 0x0e000e,  822},
//  { 0x0d000f,  832},
//  { 0x0c0010,  842},
//  { 0x0b0011,  852},
//  { 0x0a0012,  862},
//  { 0x090013,  872},
//  { 0x080014,  882},
//  { 0x070015,  892},
//  { 0x060016,  902},
//  { 0x050017,  912},
//  { 0x040018,  922},
//  { 0x030019,  932},
//  { 0x02001a,  942},
//  { 0x01001b,  952},
//  { 0x00001c,  962}
//};

//static int pwm_voltage_table_ee[][2] = {
//  { 0x1c0000,  681},
//  { 0x1b0001,  691},
//  { 0x1a0002,  701},
//  { 0x190003,  711},
//  { 0x180004,  721},
//  { 0x170005,  731},
//  { 0x160006,  741},
//  { 0x150007,  751},
//  { 0x140008,  761},
//  { 0x130009,  772},
//  { 0x12000a,  782},
//  { 0x11000b,  792},
//  { 0x10000c,  802},
//  { 0x0f000d,  812},
//  { 0x0e000e,  822},
//  { 0x0d000f,  832},
//  { 0x0c0010,  842},
//  { 0x0b0011,  852},
//  { 0x0a0012,  862},
//  { 0x090013,  872},
//  { 0x080014,  882},
//  { 0x070015,  892},
//  { 0x060016,  902},
//  { 0x050017,  912},
//  { 0x040018,  922},
//  { 0x030019,  932},
//  { 0x02001a,  942},
//  { 0x01001b,  952},
//  { 0x00001c,  962}
//};
/*r311
static int pwm_voltage_table_ee[][2] = {
	{ 0x1c0000,  810},
	{ 0x1b0001,  820},
	{ 0x1a0002,  830},
	{ 0x190003,  840},
	{ 0x180004,  850},
	{ 0x170005,  860},
	{ 0x160006,  870},
	{ 0x150007,  880},
	{ 0x140008,  890},
	{ 0x130009,  900},
	{ 0x12000a,  910},
	{ 0x11000b,  920},
	{ 0x10000c,  930},
	{ 0x0f000d,  940},
	{ 0x0e000e,  950},
	{ 0x0d000f,  960},
	{ 0x0c0010,  970},
	{ 0x0b0011,  980},
	{ 0x0a0012,  990},
	{ 0x090013, 1000},
	{ 0x080014, 1010},
	{ 0x070015, 1020},
	{ 0x060016, 1030},
	{ 0x050017, 1040},
	{ 0x040018, 1050},
	{ 0x030019, 1060},
	{ 0x02001a, 1070},
	{ 0x01001b, 1080},
	{ 0x00001c, 1090}
};
*/
#endif
/* info system. */
#define dtb_err(fmt, ...) printf( "%s()-%d: " fmt , \
				  __func__, __LINE__, ##__VA_ARGS__)

#define dtb_wrn(fmt, ...) printf( "%s()-%d: " fmt , \
				  __func__, __LINE__, ##__VA_ARGS__)

/* for detail debug info */
#define dtb_info(fmt, ...) printf( "%s()-%d: " fmt , \
				  __func__, __LINE__, ##__VA_ARGS__)

#define fb_err(fmt, ...)   printf("%s()-%d: " fmt , \
				__func__, __LINE__, ##__VA_ARGS__)

struct aml_dtb_rsv {
	u8 data[DTB_BLK_SIZE*DTB_BLK_CNT - 4*sizeof(u32)];
	u32 magic;
	u32 version;
	u32 timestamp;
	u32 checksum;
};

struct aml_dtb_info {
	u32 stamp[2];
	u8 valid[2];
};

#define stamp_after(a,b)   ((int)(b) - (int)(a)  < 0)
/* glb dtb infos */
static struct aml_dtb_info dtb_infos = {{0, 0}, {0, 0}};

#define CONFIG_SECURITYKEY

#if !defined(CONFIG_SYS_MMC_BOOT_DEV)
	#define CONFIG_SYS_MMC_BOOT_DEV (CONFIG_SYS_MMC_ENV_DEV)
#endif

#define GXB_START_BLK   0
#define GXL_START_BLK   1

/* max 2MB for emmc in blks */
#define UBOOT_SIZE  (0x1000)

int info_disprotect = 0;

bool emmckey_is_protected (struct mmc *mmc)
{
#ifdef CONFIG_STORE_COMPATIBLE
#ifdef CONFIG_SECURITYKEY
	if (info_disprotect & DISPROTECT_KEY) {
		printf("%s(): disprotect\n", __func__);
		return 0;
	}else{
		printf("%s(): protect\n", __func__);
		return 1;
	}
#else
		return 0;
#endif
#else
#ifdef CONFIG_SECURITYKEY
		//return mmc->key_protect;
		return 0; /* fixme, */
#else
		return 0;
#endif
#endif
}

unsigned emmc_cur_partition = 0;

int mmc_read_status(struct mmc *mmc, int timeout)
{
	struct mmc_cmd cmd;
	int err, retries = 5;
	int status;

	cmd.cmdidx = MMC_CMD_SEND_STATUS;
	cmd.resp_type = MMC_RSP_R1;
	if (!mmc_host_is_spi(mmc))
		cmd.cmdarg = mmc->rca << 16;
	do {
		err = mmc_send_cmd(mmc, &cmd, NULL);
		if (!err) {
			if ((cmd.response[0] & MMC_STATUS_RDY_FOR_DATA) &&
				(cmd.response[0] & MMC_STATUS_CURR_STATE) !=
				 MMC_STATE_PRG)
				break;
			else if (cmd.response[0] & MMC_STATUS_MASK) {
				printf("Status Error: 0x%08X\n",
					cmd.response[0]);
				return COMM_ERR;
			}
		} else if (--retries < 0)
			return err;

		udelay(1000);

	} while (timeout--);

	status = (cmd.response[0] & MMC_STATUS_CURR_STATE) >> 9;
	printf("CURR STATE:%d, status = 0x%x\n", status, cmd.response[0]);

	if (timeout <= 0) {
		printf("read status Timeout waiting card ready\n");
		return TIMEOUT;
	}
	if (cmd.response[0] & MMC_STATUS_SWITCH_ERROR) {
		printf("mmc status swwitch error status =0x%x\n", status);
		return SWITCH_ERR;
	}
	return 0;
}

static int get_off_size(struct mmc * mmc, char * name, uint64_t offset, uint64_t  size, u64 * blk, u64 * cnt, u64 * sz_byte)
{
		struct partitions *part_info = NULL;
		uint64_t off = 0;
		int blk_shift = 0;

		blk_shift =  ffs(mmc->read_bl_len) - 1;
		// printf("blk_shift:%d , off:0x%llx , size:0x%llx.\n ",blk_shift,off,size );
		part_info = find_mmc_partition_by_name(name);
		if (part_info == NULL) {
				printf("get partition info failed !!\n");
				return -1;
		}
		off = part_info->offset + offset;

		// printf("part_info->offset:0x%llx , off:0x%llx , size:0x%llx.\n",part_info->offset ,off,size);

		*blk = off >>  blk_shift ;
		*cnt = size >>  blk_shift ;
		*sz_byte = size - ((*cnt) << blk_shift) ;

		// printf("get_partition_off_size : blk:0x%llx , cnt:0x%llx.\n",*blk,*cnt);
		return 0;
}

static int get_partition_size(unsigned char* name, uint64_t* addr)
{
		struct partitions *part_info = NULL;
		part_info = find_mmc_partition_by_name((char *)name);
		if (part_info == NULL) {
				printf("get partition info failed !!\n");
				return -1;
		}

		*addr = part_info->size >> 9; // unit: 512 bytes
		return 0;
}

static inline int isstring(char *p)
{
	char *endptr = p;
	while (*endptr != '\0') {
		if (!(((*endptr >= '0') && (*endptr <= '9'))
				|| ((*endptr >= 'a') && (*endptr <= 'f'))
				|| ((*endptr >= 'A') && (*endptr <= 'F'))
				|| (*endptr == 'x') || (*endptr == 'X')))
			return 1;
		endptr++;
	}

	return 0;
}

/*
	erase bootloader on user/boot0/boot1 which indicate by map.
	bit 0: user
	bit 1: boot0
	bit 2: boot1
*/
int amlmmc_erase_bootloader(int dev, int map)
{
	int ret = 0, i, count = 3;
	int blk_shift;
	unsigned long n;
	char *partname[3] = {"user", "boot0", "boot1"};
	cpu_id_t cpu_id = get_cpu_id();
	struct mmc *mmc = find_mmc_device(dev);

	/* do nothing */
	if (0 == map)
		goto _out;

	if (!mmc) {
		printf("%s() %d: not valid emmc %d\n", __func__, __LINE__, dev);
		ret = -1;
		goto _out;
	}
	/* make sure mmc is initilized! */
	ret = mmc_init(mmc);
	if (ret) {
		printf("%s() %d: emmc %d init %d\n", __func__, __LINE__, dev, ret);
		ret = -2;
		goto _out;
	}

	blk_shift = ffs(mmc->read_bl_len) -1;
	/* erase bootloader in user/boot0/boot1 */
	for (i = 0; i < count; i++) {
		if (map & (0x1 << i)) {
			if (!mmc_select_hwpart(dev, i)) {
				lbaint_t start = 0, blkcnt;

				blkcnt = mmc->capacity >> blk_shift;
				if (0 == i) {
					struct partitions *part_info;
					/* get info by partition */
					part_info = find_mmc_partition_by_name(MMC_BOOT_NAME);
					if (part_info == NULL) {
						printf("%s() %d: error!!\n", __func__, __LINE__);
						/* fixme, do somthing! */
						continue;
					} else {
						start = part_info->offset>> blk_shift;
						blkcnt = part_info->size>> blk_shift;
						if (cpu_id.family_id >= MESON_CPU_MAJOR_ID_GXL) {
							start = GXL_START_BLK;
							blkcnt -= GXL_START_BLK;
						}
					}
				}
/* some customer may use boot1 higher 2M as private data. */
#ifdef CONFIG_EMMC_BOOT1_TOUCH_REGION
				if (2 == i && CONFIG_EMMC_BOOT1_TOUCH_REGION <= mmc->capacity) {
					blkcnt = CONFIG_EMMC_BOOT1_TOUCH_REGION >> blk_shift;
				}
#endif/* CONFIG_EMMC_BOOT1_TOUCH_REGION */
				printf("Erasing blocks " LBAFU " to " LBAFU " @ %s\n",
				   start, blkcnt, partname[i]);
				n = mmc->block_dev.block_erase(dev, start, blkcnt);
				if (n != 0) {
					printf("mmc erase %s failed\n", partname[i]);
					ret = -3;
					break;
				}
			} else
				printf("%s() %d: switch dev %d to %s fail\n",
						__func__, __LINE__, dev, partname[i]);
		}
	}
	/* try to switch back to user. */
	mmc_select_hwpart(dev, 0);

_out:
	return ret;
}

/* dtb read&write operation with backup updates */
static u32 _calc_boot_info_checksum(struct storage_emmc_boot_info *boot_info)
{
	u32 *buffer = (u32*)boot_info;
	u32 checksum = 0;
	int i = 0;

	do {
		checksum += buffer[i];
	} while (i++ < ((EMMC_BOOT_INFO_SIZE >> 2) - 2));

	return checksum;
}

#define GET_RSERVED_BASE_ADDR()	(_get_inherent_offset(MMC_RESERVED_NAME))
static int amlmmc_write_info_sector(struct mmc *mmc, int dev)
{
	struct storage_emmc_boot_info *boot_info;
	struct virtual_partition *ddr_part;
	u8 *buffer;
	int ret = 0;

	buffer = malloc(MMC_BLOCK_SIZE);
	if (!buffer)
		return -ENOMEM;

	memset(buffer, 0, sizeof(*boot_info));
	boot_info = (struct storage_emmc_boot_info *)buffer;
	boot_info->rsv_base_addr = GET_RSERVED_BASE_ADDR() / MMC_BLOCK_SIZE;
	ddr_part =  aml_get_virtual_partition_by_name(MMC_DDR_PARAMETER_NAME);
	boot_info->ddr.addr = ddr_part->offset / MMC_BLOCK_SIZE;
	boot_info->ddr.size = ddr_part->size / MMC_BLOCK_SIZE;
	boot_info->version = 1;
	boot_info->checksum = _calc_boot_info_checksum(boot_info);

	printf("boot_info.rsv_base_addr\t:\t%04x\n", boot_info->rsv_base_addr);
	printf("boot_info.ddr.addr\t:\t%04x\n", boot_info->ddr.addr);
	printf("boot_info.ddr.size\t:\t%04x\n", boot_info->ddr.size);
	printf("boot_info.version\t:\t%04x\n", boot_info->version);
	printf("boot_info.checksum\t:\t%04x\n", boot_info->checksum);

	if (mmc->block_dev.block_write(dev, 0, 1, buffer) != 1)
		ret = -EIO;

	free(buffer);
	return ret;
}

/*
	write bootloader on user/boot0/boot1 which indicate by map.
	bit 0: user
	bit 1: boot0
	bit 2: boot1
*/
int amlmmc_write_bootloader(int dev, int map, unsigned int size, const void *src)
{
	int ret = 0, i, count = 3;
	unsigned long n;
	char *partname[3] = {"user", "boot0", "boot1"};
	struct mmc *mmc = find_mmc_device(dev);
	lbaint_t start = GXB_START_BLK, blkcnt;
	cpu_id_t cpu_id = get_cpu_id();

	/* do nothing */
	if (0 == map)
		goto _out;

	if (!mmc) {
		printf("%s() %d: not valid emmc %d\n", __func__, __LINE__, dev);
		ret = -1;
		goto _out;
	}
	/* make sure mmc is initilized! */
	ret = mmc_init(mmc);
	if (ret) {
		printf("%s() %d: emmc %d init %d\n", __func__, __LINE__, dev, ret);
		ret = -2;
		goto _out;
	}
#ifdef MMC_NO_BOOT_PARTITION
	map = map & ~AML_BL_BOOT;
#endif
	if (cpu_id.family_id >= MESON_CPU_MAJOR_ID_GXL)
		start = GXL_START_BLK;
	blkcnt = (size + mmc->read_bl_len - 1) / mmc->read_bl_len;

	/* erase bootloader in user/boot0/boot1 */
	for (i = 0; i < count; i++) {
		if (map & (0x1 << i)) {
			if (!mmc_select_hwpart(dev, i)) {
/* some customer may use boot1 higher 2M as private data. */
#ifdef CONFIG_EMMC_BOOT1_TOUCH_REGION
				if (2 == i && CONFIG_EMMC_BOOT1_TOUCH_REGION <= size) {
					printf("%s(), size %d exceeds TOUCH_REGION %d, skip\n",
						__func__, size, CONFIG_EMMC_BOOT1_TOUCH_REGION);
					break;
				}
#endif /* CONFIG_EMMC_BOOT1_TOUCH_REGION */
				printf("Wrting blocks " LBAFU " to " LBAFU " @ %s\n",
				   start, blkcnt, partname[i]);
				if (i != 0)
					amlmmc_write_info_sector(mmc, dev);
				n = mmc->block_dev.block_write(dev, start, blkcnt, src);
				if (n != blkcnt) {
					printf("mmc write %s failed\n", partname[i]);
					ret = -3;
					break;
				}
			} else
				printf("%s() %d: switch dev %d to %s fail\n",
						__func__, __LINE__, dev, partname[i]);
		}
	}
	/* try to switch back to user. */
	mmc_select_hwpart(dev, 0);

_out:
	return ret;
}

static int amlmmc_erase_in_dev(int argc, char *const argv[])
{
	int dev = 0;
	u64 cnt = 0, blk = 0, n = 0;
	struct mmc *mmc;

	dev = simple_strtoul(argv[2], NULL, 10);
	blk = simple_strtoull(argv[3], NULL, 16);
	cnt = simple_strtoull(argv[4], NULL, 16);

	if (dev < 0) {
		printf("Cannot find dev.\n");
		return 1;
	}

	mmc = find_mmc_device(dev);

	if (!mmc)
		return 1;

	printf("MMC erase: dev # %d, start_erase_address(in block) # %#llx,\
			several blocks  # %lld will be erased ...\n ",
			dev, blk, cnt);

	mmc_init(mmc);

	if (cnt != 0)
		n = mmc->block_dev.block_erase(dev, blk, cnt);

	printf("dev # %d, %s, several blocks erased %s\n",
				dev, " ", (n == 0) ? "OK" : "ERROR");

	return (n == 0) ? 0 : 1;
}

static int amlmmc_erase_in_card(int argc, char *const argv[])
{
	int dev = 0;
	u64 cnt = 0, blk = 0, n = 0;
	/*sz_byte =0;*/
	char *name = NULL;
	u64 offset_addr = 0, size = 0;
	struct mmc *mmc;
	int tmp_shift;

	name = argv[2];
	dev = find_dev_num_by_partition_name (name);
	offset_addr = simple_strtoull(argv[3], NULL, 16);
	size = simple_strtoull(argv[4], NULL, 16);
	mmc = find_mmc_device(dev);

	tmp_shift = ffs(mmc->read_bl_len) -1;
	cnt = size >> tmp_shift;
	blk = offset_addr >> tmp_shift;
	/* sz_byte = size - (cnt<<tmp_shift); */

	if (dev < 0) {
		printf("Cannot find dev.\n");
		return 1;
	}

	mmc = find_mmc_device(dev);

	if (!mmc)
		return 1;

	printf("MMC erase: dev # %d, start_erase_address(in block) # %#llx,\
			several blocks  # %lld will be erased ...\n ",
			dev, blk, cnt);

	mmc_init(mmc);

	if (cnt != 0)
		n = mmc->block_dev.block_erase(dev, blk, cnt);

	printf("dev # %d, %s, several blocks erased %s\n",
				dev, argv[2], (n == 0) ? "OK" : "ERROR");

	return (n == 0) ? 0 : 1;
}

static int amlmmc_erase_in_part(int argc, char *const argv[])
{
	int dev = 0;
	u64 cnt = 0, blk = 0, n = 0, sz_byte =0;
	char *name = NULL;
	u64 offset_addr = 0, size = 0;
	struct mmc *mmc;
	struct partitions *part_info;

	name = argv[2];
	dev = find_dev_num_by_partition_name (name);
	offset_addr = simple_strtoull(argv[3], NULL, 16);
	size = simple_strtoull(argv[4], NULL, 16);
	part_info = find_mmc_partition_by_name(name);
	mmc = find_mmc_device(dev);
	if (!mmc)
		 return -ENODEV;

	if (offset_addr >= part_info->size) {
		printf("Start address out #%s# partition'address region,(addr_byte < 0x%llx)\n",
						name, part_info->size);
		return 1;
	}
	if ((offset_addr+size) > part_info->size) {
		printf("End address exceeds #%s# partition,(offset = 0x%llx,size = 0x%llx)\n",
						name, part_info->offset,part_info->size);
		return 1;
	}
	get_off_size(mmc, name, offset_addr, size, &blk, &cnt, &sz_byte);

	if (dev < 0) {
		printf("Cannot find dev.\n");
		return 1;
	}

	printf("MMC erase: dev # %d, start_erase_address(in block) # %#llx,\
			several blocks  # %lld will be erased ...\n ",
			dev, blk, cnt);

	mmc_init(mmc);

	if (cnt != 0)
		n = mmc->block_dev.block_erase(dev, blk, cnt);

	printf("dev # %d, %s, several blocks erased %s\n",
				dev, argv[2], (n == 0) ? "OK" : "ERROR");

	return (n == 0) ? 0 : 1;
}

static int amlmmc_erase_by_add(int argc, char *const argv[])
{
	int ret = 0;

	if (argc != 5)
		return CMD_RET_USAGE;

	if (isdigit(argv[2][0]))
		ret = amlmmc_erase_in_dev(argc, argv);
	else if (strcmp(argv[2], "card") == 0)
		ret = amlmmc_erase_in_card(argc, argv);
	else if (isstring(argv[2]))
		ret = amlmmc_erase_in_part(argc, argv);

	return ret;
}

static int amlmmc_erase_non_loader(int argc, char *const argv[])
{
	int dev;
	u32 n = 0;
	int blk_shift;
	u64 blk = 0, start_blk = 0;
	struct partitions *part_info;
	struct mmc *mmc;

	dev = 1;
	if (dev < 0) {
		printf("Cannot find dev.\n");
		return 1;
	}
	mmc = find_mmc_device(dev);

	if (!mmc)
		return 1;

	mmc_init(mmc);

	blk_shift = ffs(mmc->read_bl_len) -1;
	part_info = find_mmc_partition_by_name(MMC_BOOT_NAME);

	if (part_info == NULL) {
		start_blk = 0;
		printf("no uboot partition for eMMC boot, just erase from 0\n");
	}
	else
		start_blk = (part_info->offset + part_info->size) >> blk_shift;

	if (emmckey_is_protected(mmc)) {
		part_info = find_mmc_partition_by_name(MMC_RESERVED_NAME);
		if (part_info == NULL) {
			return 1;
		}
		blk = part_info->offset;
		// it means: there should be other partitions before reserve-partition.
		if (blk > 0)
			blk -= PARTITION_RESERVED;
		blk >>= blk_shift;
		blk -= start_blk;
		// (1) erase all the area before reserve-partition
		if (blk > 0)
			n = mmc->block_dev.block_erase(dev, start_blk, blk);
		if (n == 0) { // not error
			// (2) erase all the area after reserve-partition
			start_blk = (part_info->offset + part_info->size + PARTITION_RESERVED)
						 >> blk_shift;
			u64 erase_cnt = (mmc->capacity >> blk_shift) - start_blk;
			n = mmc->block_dev.block_erase(dev, start_blk, erase_cnt);
		}
	} else {
		n = mmc->block_dev.block_erase(dev, start_blk, 0); // erase the whole card
	}
	return (n == 0) ? 0 : 1;
}

static int amlmmc_erase_single_part(int argc, char *const argv[])
{
	char *name = NULL;
	int dev;
	u32 n = 0;
	int blk_shift;
	u64 cnt = 0, blk = 0;
	struct partitions *part_info;
	struct mmc *mmc;
	name = argv[2];
	dev = find_dev_num_by_partition_name(name);
	if (dev < 0) {
		printf("Cannot find dev.\n");
		return 1;
	}
	mmc = find_mmc_device(dev);

	if (!mmc)
		return 1;

	mmc_init(mmc);

	blk_shift = ffs(mmc->read_bl_len) -1;
	if (emmckey_is_protected(mmc)
		&& (strncmp(name, MMC_RESERVED_NAME, sizeof(MMC_RESERVED_NAME)) == 0x00)) {
		printf("\"%s-partition\" is been protecting and should no be erased!\n",
				MMC_RESERVED_NAME);
		return 1;
	}

	part_info = find_mmc_partition_by_name(name);
	if (part_info == NULL) {
		return 1;
	}

	blk = part_info->offset >> blk_shift;
	if (emmc_cur_partition && !strncmp(name, "bootloader", strlen("bootloader")))
		cnt = mmc->boot_size >> blk_shift;
	else
		cnt = part_info->size >> blk_shift;
	n = mmc->block_dev.block_erase(dev, blk, cnt);

	return (n == 0) ? 0 : 1;
}

static int amlmmc_erase_whole(int argc, char *const argv[])
{
	char *name = NULL;
	int dev;
	u32 n = 0;
	int blk_shift;
	//u64 cnt = 0,
	u64 blk = 0, start_blk = 0;
	struct partitions *part_info;
	struct mmc *mmc;
	int map;

	name = "logo";
	dev = find_dev_num_by_partition_name(name);
	if (dev < 0) {
		printf("Cannot find dev.\n");
		return 1;
	}
	mmc = find_mmc_device(dev);
	if (!mmc)
		return 1;
	mmc_init(mmc);
	blk_shift = ffs(mmc->read_bl_len) -1;
	start_blk = 0;

	if (emmckey_is_protected(mmc)) {
		part_info = find_mmc_partition_by_name(MMC_RESERVED_NAME);
		if (part_info == NULL) {
			return 1;
		}
		blk = part_info->offset;
		// it means: there should be other partitions before reserve-partition.
		if (blk > 0)
			blk -= PARTITION_RESERVED;
		blk >>= blk_shift;
		blk -= start_blk;
		// (1) erase all the area before reserve-partition
		if (blk > 0)
			n = mmc->block_dev.block_erase(dev, start_blk, blk);
		if (n == 0) { // not error
			// (2) erase all the area after reserve-partition
			start_blk = (part_info->offset + part_info->size + PARTITION_RESERVED)
						 >> blk_shift;
			u64 erase_cnt = (mmc->capacity >> blk_shift) - start_blk;
			n = mmc->block_dev.block_erase(dev, start_blk, erase_cnt);
		}
	} else {
		n = mmc->block_dev.block_erase(dev, start_blk, 0); // erase the whole card
	}
	map = AML_BL_BOOT;
	if (n == 0)
		n = amlmmc_erase_bootloader(dev, map);
	if (n)
		printf("erase bootloader in boot partition failed\n");
	return (n == 0) ? 0 : 1;
}

static int amlmmc_erase_non_cache(int arc, char *const argv[])
{
	char *name = NULL;
	int dev;
	u32 n = 0;
	int blk_shift;
	u64 blk = 0, start_blk = 0;
	struct partitions *part_info;
	struct mmc *mmc;
	int map;

	name = "logo";
	dev = find_dev_num_by_partition_name(name);
	if (dev < 0) {
		 printf("Cannot find dev.\n");
		 return 1;
	 }
	 mmc = find_mmc_device(dev);
	 if (!mmc)
		 return 1;
	 mmc_init(mmc);
	 blk_shift = ffs(mmc->read_bl_len) -1;
	 if (emmckey_is_protected(mmc)) {
		 part_info = find_mmc_partition_by_name(MMC_RESERVED_NAME);
		 if (part_info == NULL) {
			 return 1;
		 }

		 blk = part_info->offset;
		 // it means: there should be other partitions before reserve-partition.
		if (blk > 0) {
			blk -= PARTITION_RESERVED;
		 }
		 blk >>= blk_shift;
		 blk -= start_blk;
		 // (1) erase all the area before reserve-partition
		 if (blk > 0) {
			 n = mmc->block_dev.block_erase(dev, start_blk, blk);
			 // printf("(1) erase blk: 0 --> %llx %s\n", blk, (n == 0) ? "OK" : "ERROR");
		 }
		 if (n == 0) { // not error
			 // (2) erase all the area after reserve-partition
			 part_info = find_mmc_partition_by_name(MMC_CACHE_NAME);
			 if (part_info == NULL) {
				 return 1;
			 }
			 start_blk = (part_info->offset + part_info->size + PARTITION_RESERVED)
						  >> blk_shift;
			 u64 erase_cnt = (mmc->capacity >> blk_shift) - start_blk;
			 n = mmc->block_dev.block_erase(dev, start_blk, erase_cnt);
		 }
	 } else {
		 n = mmc->block_dev.block_erase(dev, start_blk, 0); // erase the whole card
	 }
	 map = AML_BL_BOOT;
	 if (n == 0) {
		 n = amlmmc_erase_bootloader(dev, map);
		 if (n)
			 printf("erase bootloader in boot partition failed\n");
	 }
	 return (n == 0) ? 0 : 1;
}

static int amlmmc_erase_dev(int argc, char *const argv[])
{
	return amlmmc_erase_whole(argc, argv);
}

static int amlmmc_erase_allbootloader(int argc, char*const argv[])
{
	int map;
	int rc;
	char *name = NULL;
	int dev;
	map = AML_BL_ALL;

	name = "bootloader";
	dev = find_dev_num_by_partition_name(name);

	if (dev < 0) {
		printf("Cannot find dev.\n");
		return 1;
	}

	rc = amlmmc_erase_bootloader(dev, map);
	return rc;
}

static int amlmmc_erase_by_part(int argc, char *const argv[])
{
	int ret = CMD_RET_USAGE;

	if (argc != 3)
		return ret;

	if (isdigit(argv[2][0]))
		ret = amlmmc_erase_dev(argc, argv);
	else if (strcmp(argv[2], "whole") == 0)
		ret = amlmmc_erase_whole(argc, argv);
	else if (strcmp(argv[2], "non_cache") == 0)
		ret = amlmmc_erase_non_cache(argc, argv);
	else if (strcmp(argv[2], "non_loader") == 0)
		ret = amlmmc_erase_non_loader(argc, argv);
	else if (strcmp(argv[2], "allbootloader") == 0)
		ret = amlmmc_erase_allbootloader(argc, argv);
	else
		ret = amlmmc_erase_single_part(argc, argv);
	return ret;
}

static int do_amlmmc_erase(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	int ret = CMD_RET_USAGE;

	if (argc == 3)
		ret = amlmmc_erase_by_part(argc, argv);
	else if (argc == 5)
		ret = amlmmc_erase_by_add(argc, argv);

	return ret;
}

static int amlmmc_write_in_part(int argc, char *const argv[])
{
	int dev, ret;
	void *addr = NULL;
	u64 cnt = 0, n = 0, blk = 0, sz_byte = 0;
	char *name = NULL;
	u64 offset = 0, size = 0;
	struct mmc *mmc;

	name = argv[2];
	if (strcmp(name, "bootloader") == 0)
		dev = CONFIG_SYS_MMC_BOOT_DEV;
	else
		dev = find_dev_num_by_partition_name (name);
	addr = (void *)simple_strtoul(argv[3], NULL, 16);
	offset  = simple_strtoull(argv[4], NULL, 16);
	size = simple_strtoull(argv[5], NULL, 16);
	if (dev < 0) {
		printf("Cannot find dev.\n");
		return 1;
	}
	mmc = find_mmc_device(dev);
	if (!mmc)
		return 1;

	mmc_init(mmc);

	if (strcmp(name, "bootloader") == 0) {
		ret = amlmmc_write_bootloader(dev, AML_BL_ALL, size, addr);
		return ret;
	} else
		get_off_size(mmc, name, offset, size, &blk, &cnt, &sz_byte);

	n = mmc->block_dev.block_write(dev, blk, cnt, addr);
	//write sz_byte bytes
	if ((n == cnt) && (sz_byte != 0)) {
		// printf("sz_byte=%#llx bytes\n",sz_byte);
		void *addr_tmp = malloc(mmc->write_bl_len);
		void *addr_byte = (void*)(addr+cnt*(mmc->write_bl_len));
		ulong start_blk = blk+cnt;

		if (addr_tmp == NULL) {
			printf("mmc write: malloc fail\n");
			return 1;
		}

		if (mmc->block_dev.block_read(dev, start_blk, 1, addr_tmp) != 1) { // read 1 block
			free(addr_tmp);
			printf("mmc read 1 block fail\n");
			return 1;
		}

		memcpy(addr_tmp, addr_byte, sz_byte);
		if (mmc->block_dev.block_write(dev, start_blk, 1, addr_tmp) != 1) { // write 1 block
			free(addr_tmp);
			printf("mmc write 1 block fail\n");
			return 1;
		}
		free(addr_tmp);
	}
	//printf("%#llx blocks , %#llx bytes written: %s\n", n, sz_byte, (n==cnt) ? "OK" : "ERROR");
	return (n == cnt) ? 0 : 1;
}

static int amlmmc_write_in_card(int argc, char *const argv[])
{
	int dev;
	void *addr = NULL;
	u64 cnt = 0, n = 0, blk = 0, sz_byte = 0;
	char *name = NULL;
	u64 offset = 0, size = 0;
	struct mmc *mmc;

	name = argv[2];
	dev = find_dev_num_by_partition_name (name);
	addr = (void *)simple_strtoul(argv[3], NULL, 16);
	offset  = simple_strtoull(argv[4], NULL, 16);
	size = simple_strtoull(argv[5], NULL, 16);
	if (dev < 0) {
		printf("Cannot find dev.\n");
		return 1;
	}
	mmc = find_mmc_device(dev);
	if (!mmc)
		return 1;

	int blk_shift = ffs( mmc->read_bl_len) -1;
	cnt = size >> blk_shift;
	blk = offset >> blk_shift;
	sz_byte = size - (cnt<<blk_shift);
	 mmc_init(mmc);

	n = mmc->block_dev.block_write(dev, blk, cnt, addr);

	//write sz_byte bytes
	if ((n == cnt) && (sz_byte != 0)) {
		// printf("sz_byte=%#llx bytes\n",sz_byte);
		void *addr_tmp = malloc(mmc->write_bl_len);
		void *addr_byte = (void*)(addr+cnt*(mmc->write_bl_len));
		ulong start_blk = blk+cnt;

		if (addr_tmp == NULL) {
			printf("mmc write: malloc fail\n");
			return 1;
		}

		if (mmc->block_dev.block_read(dev, start_blk, 1, addr_tmp) != 1) { // read 1 block
			free(addr_tmp);
			printf("mmc read 1 block fail\n");
			return 1;
		}

		memcpy(addr_tmp, addr_byte, sz_byte);
		if (mmc->block_dev.block_write(dev, start_blk, 1, addr_tmp) != 1) { // write 1 block
			free(addr_tmp);
			printf("mmc write 1 block fail\n");
			return 1;
		}
		free(addr_tmp);
	}
	//printf("%#llx blocks , %#llx bytes written: %s\n", n, sz_byte, (n==cnt) ? "OK" : "ERROR");
	return (n == cnt) ? 0 : 1;
}

static int amlmmc_write_in_dev(int argc, char *const argv[])
{
	int dev;
	void *addr = NULL;
	u64 cnt = 0, n = 0, blk = 0;
	struct mmc *mmc;
	dev = simple_strtoul(argv[2], NULL, 10);
	addr = (void *)simple_strtoul(argv[3], NULL, 16);
	blk = simple_strtoull(argv[4], NULL, 16);
	cnt = simple_strtoull(argv[5], NULL, 16);
	if (dev < 0) {
		printf("Cannot find dev.\n");
		return 1;
	}
	mmc = find_mmc_device(dev);
	if (!mmc)
		return 1;

	 //printf("MMC write: dev # %d, block # %#llx, count # %#llx ... ",
	 //dev, blk, cnt);

	mmc_init(mmc);

	n = mmc->block_dev.block_write(dev, blk, cnt, addr);
	return (n == cnt) ? 0 : 1;
}

static int do_amlmmc_write(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	int ret = 0;
	if (argc != 6)
		return CMD_RET_USAGE;

	if (isdigit(argv[2][0]))
		ret = amlmmc_write_in_dev(argc, argv);
	else if (strcmp(argv[2], "card") == 0)
		ret = amlmmc_write_in_card(argc, argv);
	else if (isstring(argv[2]))
		ret = amlmmc_write_in_part(argc, argv);

	return ret;
}

static int amlmmc_read_in_dev(int argc, char *const argv[])
{
	int dev;
	void *addr = NULL;
	u64 cnt =0, n = 0, blk = 0;
	struct mmc *mmc;

	dev = simple_strtoul(argv[2], NULL, 10);
	addr = (void *)simple_strtoul(argv[3], NULL, 16);
	blk = simple_strtoull(argv[4], NULL, 16);
	cnt = simple_strtoull(argv[5], NULL, 16);

	if (dev < 0) {
		printf("Cannot find dev.\n");
		return 1;
	}

	mmc = find_mmc_device(dev);
	if (!mmc)
		return 1;
	n = mmc->block_dev.block_read(dev, blk, cnt, addr);
	return (n == cnt) ? 0 : 1;
}

static int amlmmc_read_in_card(int argc, char *const argv[])
{
	int dev;
	void *addr = NULL;
	//u32 flag =0;
	u64 cnt =0, n = 0, blk = 0, sz_byte = 0;
	char *name = NULL;
	u64 offset = 0, size = 0;
	int blk_shift;
	struct mmc *mmc;
	void *addr_tmp;
	void *addr_byte;
	ulong start_blk;

	name = argv[2];
	dev = find_dev_num_by_partition_name (name);
	addr = (void *)simple_strtoul(argv[3], NULL, 16);
	size = simple_strtoull(argv[5], NULL, 16);
	offset = simple_strtoull(argv[4], NULL, 16);

	if (dev < 0) {
		printf("Cannot find dev.\n");
		return 1;
	}

	mmc = find_mmc_device(dev);
	if (!mmc)
		return 1;

	blk_shift = ffs( mmc->read_bl_len) - 1;
	cnt = size >> blk_shift;
	blk = offset >> blk_shift;
	sz_byte = size - (cnt<<blk_shift);

	mmc_init(mmc);
	n = mmc->block_dev.block_read(dev, blk, cnt, addr);

	//read sz_byte bytes
	if ((n == cnt) && (sz_byte != 0)) {
	   addr_tmp = malloc(mmc->read_bl_len);
	   addr_byte = (void *)(addr+cnt*(mmc->read_bl_len));
	   start_blk = blk+cnt;
	   if (addr_tmp == NULL) {
		   printf("mmc read: malloc fail\n");
		   return 1;
	   }
	   if (mmc->block_dev.block_read(dev, start_blk, 1, addr_tmp) != 1) { // read 1 block
		   free(addr_tmp);
		   printf("mmc read 1 block fail\n");
		   return 1;
	   }
	   memcpy(addr_byte, addr_tmp, sz_byte);
	   free(addr_tmp);
	}
	return (n == cnt) ? 0 : 1;
}

static int amlmmc_read_in_part(int argc, char *const argv[])
{
	int dev;
	void *addr = NULL;
	u64 cnt = 0, n = 0, blk = 0, sz_byte = 0;
	char *name = NULL;
	u64 offset = 0, size = 0;
	struct mmc *mmc;
	void *addr_tmp;
	void *addr_byte;
	ulong start_blk;

	name = argv[2];
	dev = find_dev_num_by_partition_name (name);
	addr = (void *)simple_strtoul(argv[3], NULL, 16);
	offset = simple_strtoull(argv[4], NULL, 16);
	size = simple_strtoull(argv[5], NULL, 16);

	if (dev < 0) {
		printf("Cannot find dev.\n");
		return 1;
	}

	mmc = find_mmc_device(dev);
	if (!mmc)
		return 1;

	get_off_size(mmc, name, offset, size, &blk, &cnt, &sz_byte);
	mmc_init(mmc);
	n = mmc->block_dev.block_read(dev, blk, cnt, addr);

	//read sz_byte bytes
	if ((n == cnt) && (sz_byte != 0)) {
	   /*printf("sz_byte=%#llx bytes\n",sz_byte);*/
	   addr_tmp = malloc(mmc->read_bl_len);
	   addr_byte = (void *)(addr+cnt*(mmc->read_bl_len));
	   start_blk = blk+cnt;

	   if (addr_tmp == NULL) {
		   printf("mmc read: malloc fail\n");
		   return 1;
	   }

	   if (mmc->block_dev.block_read(dev, start_blk, 1, addr_tmp) != 1) { // read 1 block
		   free(addr_tmp);
		   printf("mmc read 1 block fail\n");
		   return 1;
	   }

	   memcpy(addr_byte, addr_tmp, sz_byte);
	   free(addr_tmp);
	}
	return (n == cnt) ? 0 : 1;
}

static int do_amlmmc_read(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	int ret = 0;

	if (argc != 6)
		return CMD_RET_USAGE;

	if (isdigit(argv[2][0]))
		ret = amlmmc_read_in_dev(argc, argv);
	else if (strcmp(argv[2], "card") == 0)
		ret = amlmmc_read_in_card(argc, argv);
	else if (isstring(argv[2]))
		ret = amlmmc_read_in_part(argc, argv);

	return ret;
}

static int do_amlmmc_env(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	printf("herh\n");
	env_relocate();
	return 0;
}

static int do_amlmmc_list(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	print_mmc_devices('\n');
	return 0;
}

static int do_amlmmc_size(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	char *name;
	uint64_t* addr = NULL;
	int dev;
	struct mmc *mmc = NULL;

	if (argc != 4)
		return CMD_RET_USAGE;

	name = argv[2];
	addr = (uint64_t *)simple_strtoul(argv[3], NULL, 16);
	if (!strcmp(name, "wholeDev")) {
		dev = CONFIG_SYS_MMC_BOOT_DEV;
		mmc = find_mmc_device(dev);
		if (!mmc) {
			puts("no mmc devices available\n");
			return 1;
		}
		mmc_init(mmc);

		*addr = mmc->capacity >> 9; // unit: 512 bytes
		return 0;
	}
	return get_partition_size((unsigned char *)name, addr);
}

static int amlmmc_get_ext_csd(int argc, char *const argv[])
{
	int ret= 0;
	u8 ext_csd[512] = {0};
	int dev, byte;
	struct mmc *mmc;

	if (argc != 4)
		return CMD_RET_USAGE;

	dev = simple_strtoul(argv[2], NULL, 10);
	byte = simple_strtoul(argv[3], NULL, 10);
	mmc = find_mmc_device(dev);

	if (!mmc) {
		puts("no mmc devices available\n");
		return 1;
	}
	mmc_init(mmc);
	ret = mmc_get_ext_csd(mmc, ext_csd);
	printf("read EXT_CSD byte[%d] val[0x%x] %s\n",
			byte, ext_csd[byte], (ret == 0) ? "ok" : "fail");
	ret = ret || ret;
	return ret;
}

static int amlmmc_set_ext_csd(int argc, char *const argv[])
{
	int ret = 0;
	int dev, byte;
	struct mmc *mmc;
	int val;

	if (argc != 5)
		return CMD_RET_USAGE;

	dev = simple_strtoul(argv[2], NULL, 10);
	byte = simple_strtoul(argv[3], NULL, 10);
	val = simple_strtoul(argv[4], NULL, 16);
	if ((byte > 191) || (byte < 0)) {
		printf("byte is not able to write!\n");
		return 1;
	}

	mmc = find_mmc_device(dev);

	if (!mmc) {
		puts("no mmc devices available\n");
		return 1;
	}

	mmc_init(mmc);

	ret = mmc_set_ext_csd(mmc, byte, val);
	printf("write EXT_CSD byte[%d] val[0x%x] %s\n",
			byte, val, (ret == 0) ? "ok" : "fail");
	ret =ret || ret;
	return ret;
}

static int do_amlmmc_ext_csd(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	int ret = CMD_RET_USAGE;

	if (argc == 4)
		ret = amlmmc_get_ext_csd(argc,argv);
	else if (argc == 5)
		ret = amlmmc_set_ext_csd(argc,argv);

	return ret;
}

static int do_amlmmc_switch(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	int rc = 0;
	int dev;
	struct mmc *mmc;

	if (argc != 4)
		return CMD_RET_USAGE;

	dev = simple_strtoul(argv[2], NULL, 10);
	mmc = find_mmc_device(dev);

	if (!mmc) {
		puts("no mmc devices available\n");
		return 1;
	}

	mmc_init(mmc);
	printf("mmc switch to ");

	if (strcmp(argv[3], "boot0") == 0) {
		rc = mmc_switch_part(dev, 1);
		if (rc == 0) {
			emmc_cur_partition = 1;
			printf("boot0 success\n");
		} else {
			printf("boot0 failed\n");
		}
	}
	else if(strcmp(argv[3], "boot1") == 0) {
		rc = mmc_switch_part(dev, 2);
		if (rc == 0) {
			emmc_cur_partition = 2;
			printf("boot1 success\n");
		} else {
			printf("boot1 failed\n");
		}
	}
	else if(strcmp(argv[3], "user") == 0) {
		rc = mmc_switch_part(dev, 0);
		if (rc == 0) {
			emmc_cur_partition = 0;
			printf("user success\n");
		} else {
			printf("user failed\n");
	   }
	}
#ifdef CONFIG_SUPPORT_EMMC_RPMB
	else if(strcmp(argv[3], "rpmb") == 0) {
		rc = mmc_switch_part(dev, 3);
		if (rc == 0) {
			emmc_cur_partition = 3;
			printf("rpmb success\n");
		} else {
			printf("rpmb failed\n");
		}
	}
#endif
	else
		printf("%s failed\n", argv[3]);
	return rc;
}

static int do_amlmmc_controller(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	int dev;
	struct mmc *mmc;
	struct aml_card_sd_info *aml_priv;
	struct sd_emmc_global_regs *sd_emmc_reg;

	if (argc != 3)
		return CMD_RET_USAGE;

	dev = simple_strtoul(argv[2], NULL, 10);

	if (dev < 0) {
		printf("Cannot find dev.\n");
		return 1;
	}

	mmc = find_mmc_device(dev);

	if (!mmc)
		return 1;

	aml_priv = mmc->priv;
	sd_emmc_reg = aml_priv->sd_emmc_reg;

	printf("sd_emmc_reg->gclock = 0x%x\n", sd_emmc_reg->gclock);
	printf("sd_emmc_reg->gdelay = 0x%x\n", sd_emmc_reg->gdelay);
	printf("sd_emmc_reg->gadjust = 0x%x\n", sd_emmc_reg->gadjust);
	printf("sd_emmc_reg->gcalout = 0x%x\n", sd_emmc_reg->gcalout);
	if (!mmc->has_init) {
		printf("mmc dev %d has not been initialed\n", dev);
		return 1;
	}
	printf("sd_emmc_reg->gstart = 0x%x\n", sd_emmc_reg->gstart);
	printf("sd_emmc_reg->gcfg = 0x%x\n", sd_emmc_reg->gcfg);
	printf("sd_emmc_reg->gstatus = 0x%x\n", sd_emmc_reg->gstatus);
	printf("sd_emmc_reg->girq_en = 0x%x\n", sd_emmc_reg->girq_en);
	printf("sd_emmc_reg->gcmd_cfg = 0x%x\n", sd_emmc_reg->gcmd_cfg);
	printf("sd_emmc_reg->gcmd_arg = 0x%x\n", sd_emmc_reg->gcmd_arg);
	printf("sd_emmc_reg->gcmd_dat = 0x%x\n", sd_emmc_reg->gcmd_dat);
	printf("sd_emmc_reg->gcmd_rsp0 = 0x%x\n", sd_emmc_reg->gcmd_rsp0);
	printf("sd_emmc_reg->gcmd_rsp1 = 0x%x\n", sd_emmc_reg->gcmd_rsp1);
	printf("sd_emmc_reg->gcmd_rsp2 = 0x%x\n", sd_emmc_reg->gcmd_rsp2);
	printf("sd_emmc_reg->gcmd_rsp3 = 0x%x\n", sd_emmc_reg->gcmd_rsp3);
	return 0;
}

static int do_amlmmc_response(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	int dev;
	struct mmc *mmc;
	struct aml_card_sd_info *aml_priv;
	struct sd_emmc_global_regs *sd_emmc_reg;

	if (argc != 3)
		return CMD_RET_USAGE;

	dev = simple_strtoul(argv[2], NULL, 10);

	if (dev < 0) {
		printf("Cannot find dev.\n");
		return 1;
	}

	mmc = find_mmc_device(dev);

	if (!mmc)
		return 1;
	if (!mmc->has_init) {
		printf("mmc dev %d has not been initialed\n", dev);
		return 1;
	}

	aml_priv = mmc->priv;
	sd_emmc_reg = aml_priv->sd_emmc_reg;

	printf("last cmd = %d, response0 = 0x%x\n",
		(sd_emmc_reg->gcmd_cfg & 0x3f), sd_emmc_reg->gcmd_rsp0);
	return 0;
}

static int do_amlmmc_status(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	int rc = 0;
	int dev;
	struct mmc *mmc;

	if (argc != 3)
		return CMD_RET_USAGE;

	dev = simple_strtoul(argv[2], NULL, 10);

	if (dev < 0) {
		printf("Cannot find dev.\n");
		return 1;
	}
	mmc = find_mmc_device(dev);

	if (!mmc)
		return 1;
	if (!mmc->has_init) {
		printf("mmc dev %d has not been initialed\n", dev);
		return 1;
	}
	rc = mmc_read_status(mmc, 1000);
	if (rc)
		return 1;
	else
		return 0;
}

static int do_amlmmc_part(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	int dev;
	block_dev_desc_t *mmc_dev;
	struct mmc *mmc;

	if (argc != 3)
		return CMD_RET_USAGE;

	dev = simple_strtoul(argv[2], NULL, 10);
	mmc = find_mmc_device(dev);

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
}

static int do_amlmmc_rescan(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	int dev;
	struct mmc *mmc;

	if (argc != 3)
		return CMD_RET_USAGE;

	dev = simple_strtoul(argv[2], NULL, 10);

	if (dev < 0) {
		printf("Cannot find dev.\n");
		return 1;
	}

	mmc = find_mmc_device(dev);

	if (!mmc)
			return 1;

	return mmc_init(mmc);
}

#ifdef CONFIG_SECURITYKEY
static int do_amlmmc_key(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	struct mmc *mmc;
	int dev;

	//char *name = "logo";
	dev = CONFIG_SYS_MMC_BOOT_DEV;
	mmc = find_mmc_device(dev);
	if (!mmc) {
		printf("device %d is invalid\n",dev);
		return 1;
	}
	//mmc->key_protect = 0;
#ifdef CONFIG_STORE_COMPATIBLE
	info_disprotect |= DISPROTECT_KEY;  //disprotect
	printf("emmc disprotect key\n");
#endif
	return 0;
}
#endif

static int set_write_prot(struct mmc *mmc, u64 start)
{
	struct mmc_cmd cmd;
	int err;

	cmd.cmdidx = MMC_CMD_SET_WRITE_PROTECT;
	cmd.cmdarg = start;
	cmd.resp_type = MMC_RSP_R1b;

	err = mmc_send_cmd(mmc, &cmd, NULL);
	if (err)
		goto err_out;

	return 0;

err_out:
	puts("Failed: mmc write protect failed\n");
	return err;
}

static int set_us_wp_en(struct mmc *mmc, u8 *ext_csd, u8 wp_enable_type)
{
	u8 index = EXT_CSD_USER_WP;
	u8 user_wp = ext_csd[index];
	user_wp = user_wp & (~WP_ENABLE_MASK);
	user_wp = user_wp | wp_enable_type;
	int err = 0;
	err = mmc_set_ext_csd(mmc, index, user_wp);
	if (err)
		printf("Failed: set write protect enable failed\n");
	return err;
}

static int mmc_set_us_perm_wp_dis(struct mmc *mmc, u8 *ext_csd)
{
	u8 usr_wp = ext_csd[EXT_CSD_USER_WP];
	u8 perm_disable_bit = US_PERM_WP_DIS_BIT;

	int err;
	if (usr_wp & perm_disable_bit)
		return 0;

	usr_wp = usr_wp | perm_disable_bit;
	err = mmc_set_ext_csd(mmc, EXT_CSD_USER_WP, usr_wp);
	if (err) {
		printf("Failed: set permanent write protect disable failed\n");
		return 1;
	}
	return 0;
}

static int mmc_is_us_pwr_wp_dis(u8 user_wp)
{
   return user_wp & US_PWR_WP_DIS_BIT;
}

static int mmc_is_us_perm_wp_dis(u8 user_wp)
{
   return user_wp & US_PERM_WP_DIS_BIT;
}

static int check_wp_type(u8 *addr, u8 wp_type, u64 set_protect_cnt)
{
	u8 type_mask = WP_TYPE_MASK;
	u64 cnt = set_protect_cnt;
	u8 times = 0;
	u8 index = 7;
	u8 cur_group_wp_type = addr[index];

	while (cnt != 0) {
		if (wp_type != ((type_mask)&(cur_group_wp_type))) {
			return 1;
		}
		if (times == 3) {
			times = 0;
			index--;
			cur_group_wp_type = addr[index];
		}
		else {
			cur_group_wp_type = cur_group_wp_type >> 2;
			times++;
		}
		cnt--;
	}
	return 0;
}

static int set_register_to_temporary(struct mmc *mmc, u8 *ext_csd)
{
	int err;
	u8 wp_enable_type = WP_TEMPORARY_EN_BIT;
	err = set_us_wp_en(mmc, ext_csd, wp_enable_type);
	if (err)
		printf("Failed: set temporary write protect failed\n");
	return err;
}

static int set_register_to_pwr(struct mmc *mmc, u8 *ext_csd)
{
	int err;
	u8 user_wp = ext_csd[EXT_CSD_USER_WP];
	u8 wp_enable_type = WP_POWER_ON_EN_BIT;
	if (mmc_is_us_pwr_wp_dis(user_wp)) {
		printf("Failed: power on protection had been disabled\n");
		return 1;
	}

	err = mmc_set_us_perm_wp_dis(mmc, ext_csd);
	if (err) {
		printf("Failed: set permanent protection diable failed\n");
		return 1;
	}

	err = set_us_wp_en(mmc, ext_csd, wp_enable_type);
	if (err) {
		printf("Failed: set power on write protect enable failed\n");
		return 1;
	}
	return 0;
}

static int set_register_to_perm(struct mmc *mmc, u8 *ext_csd)
{
	int err;
	u8 wp_enable_type = WP_PERM_EN_BIT;
	u8 user_wp = ext_csd[EXT_CSD_USER_WP];

	if (mmc_is_us_perm_wp_dis(user_wp)) {
		printf("Failed: Permanent protection had been disabled\n");
		return 1;
	}

	err = set_us_wp_en(mmc, ext_csd, wp_enable_type);
	if (err) {
		printf("Failed: set permanent write protect enable failed\n");
		return 1;
	}
	return 0;
}

static int set_wp_register(struct mmc *mmc, u8 *ext_csd, u8 wp_type)
{
	int ret = 1;
	if (wp_type == WP_POWER_ON_TYPE)
		ret = set_register_to_pwr(mmc, ext_csd);
	else if (wp_type == WP_PERMANENT_TYPE)
		ret = set_register_to_perm(mmc, ext_csd);
	else if (wp_type == WP_TEMPORARY_TYPE)
		ret = set_register_to_temporary(mmc, ext_csd);
	return ret;
}

static u64 write_protect_group_size(struct mmc *mmc, u8 *ext_csd)
{
	int erase_group_def = ext_csd[EXT_CSD_ERASE_GROUP_DEF];
	u64 write_protect_group_size;
	int wp_grp_size = mmc->csd[2] & WP_GRP_SIZE_MASK;
	int hc_wp_grp_size = ext_csd[EXT_CSD_HC_WP_GRP_SIZE];

	if (erase_group_def == 0)
		write_protect_group_size = (wp_grp_size + 1) * mmc->erase_grp_size;
	else
		write_protect_group_size =  hc_wp_grp_size * mmc->erase_grp_size;

	return write_protect_group_size;
}

int is_write_protect_valid(u8 *ext_csd)
{
	u8 class_6_ctrl = ext_csd[EXT_CSD_CLASS_6_CTRL];
	if (class_6_ctrl == 0)
		return 1;
	return 0;
}

static int compute_write_protect_range(struct mmc *mmc, char *name,
		u8 *ext_csd, u64 *wp_grp_size_addr, u64 *start_addr, u64 *end)
{
	int blk_shift;
	struct partitions *part_info;
	u64 cnt;
	u64 start = *start_addr;
	u64 align_start = *start_addr;
	u64 wp_grp_size = *wp_grp_size_addr;
	u64 group_num ;
	u64 partition_end;

	wp_grp_size = write_protect_group_size(mmc, ext_csd);

	blk_shift = ffs(mmc->read_bl_len) -1;

	part_info = find_mmc_partition_by_name(name);
	if (part_info == NULL)
		return 1;

	start = part_info->offset >> blk_shift;
	if ((start % wp_grp_size)) {
		align_start = (start + wp_grp_size - 1) / wp_grp_size * wp_grp_size;
		printf("Caution! The partition start address isn't' aligned"
				"to group size\n"
			   "the start address is change from 0x%llx to 0x%llx\n",
			   start, align_start);
	} else {
		align_start = start;
	}
	if (emmc_cur_partition && !strncmp(name, "bootloader", strlen("bootloader")))
		cnt = mmc->boot_size >> blk_shift;
	else
		cnt = part_info->size >> blk_shift;
	if (cnt < wp_grp_size) {
		printf("Caution: The partition size is 0x%llx sector smaller than "
				"the group size 0x%llx sector, \n"
				"so the partition can't be protect\n", cnt, wp_grp_size);
		return 1;
	}

	*start_addr = align_start;
	*wp_grp_size_addr = wp_grp_size;
	partition_end = start + cnt - 1;
	group_num = (cnt - (align_start - start)) / wp_grp_size;
	*end = align_start + group_num * wp_grp_size - 1;

	if (partition_end != *end) {
		printf("Caution! The boundary of partition isn't aligned with write "
				"protected group,\n"
				"so the write protected boundry of the "
				"partition is 0x%llx, rather than 0x%llx\n",
				*end, partition_end);
	}

	printf("write_protect group size is 0x%llx sector\n", wp_grp_size);
	printf("The %s partition write protect group number is %lld\n", name, group_num);
#ifdef WP_DEBUG
	printf("the start address is 0x%llx, group size is 0x%llx, end is 0x%llx\n",
		   *start_addr, *wp_grp_size_addr, *end);
#endif
	return 0;
}

static int send_wp_prot_type(struct mmc *mmc, void *dst, u64 blk)
{
	struct mmc_cmd cmd;
	int err;
	struct mmc_data data;

	cmd.cmdidx = MMC_CMD_SEND_WRITE_PROT_TYPE;
	cmd.cmdarg = blk;
	cmd.resp_type = MMC_RSP_R1;

	data.dest = dst;
	data.blocks = 1;
	data.blocksize = 8;
	data.flags = MMC_DATA_READ;

	err = mmc_send_cmd(mmc, &cmd, &data);
	if (err)
		goto err_out;

	return 0;

err_out:
	puts("Failed: mmc send write protect type failed\n");
	return err;
}

static int is_wp_set_failed(struct mmc *mmc, u8 wp_type, u64 start, u64 group_cnt)
{
	u8 *addr = NULL;
	u8 err = 0;

	addr = malloc(sizeof(u64));
	if (addr == NULL) {
		printf("Failed: malloc failed\n");
		return 1;
	}

	err = send_wp_prot_type(mmc, addr, start);
	if (err)
		goto err_out;

#ifdef WP_DEBUG
	int  i;
	for (i = 0; i < 8; i++)
		printf("write_protect status is %x\n", ((u8 *)addr)[i]);
#endif
	if (check_wp_type(addr, wp_type, group_cnt)) {
		printf("Failed: Write Protection set failed\n");
		goto err_out;
	}
	return 0;

err_out:
	free(addr);
	return 1;
}

static int send_part_wp_type(struct mmc *mmc, char *name)
{
	int err = 0;
	u8 ext_csd[512] = {0};
	u64 wp_grp_size, start, part_end;
	u64 group_start;
	void *addr = NULL;
	int i;
	int ret;

	ret = mmc_get_ext_csd(mmc, ext_csd);
	if (ret) {
		printf("Failed: get ext_csd failed\n");
		return 1;
	}

	if (!is_write_protect_valid(ext_csd)) {
		printf("Failed: CLASS_6_CTRL isn't '0' "
				"write protect process is invalid\n");
		return 1;
	}

	addr = malloc(sizeof(u64));
	if (addr == NULL) {
		printf("Failed: malloc failed\n");
		return 1;
	}

	err = compute_write_protect_range(mmc, name, ext_csd,
			&wp_grp_size, &start, &part_end);
	if (err)
		return 1;

	group_start = start;

	while ((group_start + wp_grp_size - 1) <= part_end) {
		err = send_wp_prot_type(mmc, addr, group_start);
		if (err)
			return 1;
		printf("The write protect type for the 32 groups after 0x%llx is: \n0x",
				group_start);
		for (i = 0; i < 8; i++)
			printf("%02x", ((u8*)addr)[i]);
		printf("\n");
		group_start += 32 * wp_grp_size;
	}
	return 0;
}

static int send_add_wp_type(struct mmc *mmc, u64 start, u64 cnt)
{
	u8 ext_csd[512] = {0};
	u64 wp_grp_size = 0;
	u64 part_end = 0;
	u64 group_start;
	u64 mmc_boundary;
	int blk_shift;
	void *addr = NULL;
	int i;
	int ret;

	ret = mmc_get_ext_csd(mmc, ext_csd);
	if (ret) {
		printf("Failed: get ext_csd failed\n");
		return 1;
	}

	if (!is_write_protect_valid(ext_csd)) {
		printf("Failed: CLASS_6_CTRL isn't '0' "
				"write protect process is invalid\n");
		return 1;
	}

	addr = malloc(sizeof(u64));
	if (addr == NULL) {
		printf("Failed: malloc failed\n");
		return 1;
	}

	wp_grp_size = write_protect_group_size(mmc, ext_csd);

   if ((start % wp_grp_size)) {
		group_start = (start + wp_grp_size - 1) / wp_grp_size * wp_grp_size;
		printf("Caution! The partition start address isn't' aligned"
				"to group size\n"
			   "the start address is change from 0x%llx to 0x%llx\n",
			   start, group_start);
		part_end = group_start + (cnt - 1) * wp_grp_size - 1;
		printf("The write protect group number is 0x%llx, rather than 0x%lld\n",
				cnt - 1, cnt);
	} else {
		group_start = start;
		part_end = group_start + cnt * wp_grp_size - 1;
	}

	blk_shift = ffs(mmc->read_bl_len) - 1;
	mmc_boundary = mmc->capacity>>blk_shift;

	if ((part_end + 1) > mmc_boundary) {
		printf("Error: the operation cross the boundary of mmc\n");
		return 1;
	}

	while ((group_start + wp_grp_size - 1) <= part_end) {
		ret = send_wp_prot_type(mmc, addr, group_start);
		if (ret)
			return 1;
		printf("The write protect type for the 32 groups after 0x%llx is: \n0x",
				group_start);
		for (i = 0; i < 8; i++)
			printf("%02x", ((u8*)addr)[i]);
		printf("\n");
		group_start += 32 * wp_grp_size;
	}
	return 0;
}

static int set_part_write_protect(struct mmc *mmc, u8 wp_type, char *name)
{
	int err = 0;
	u8 ext_csd[512] = {0};
	u8 group_num  = 32;
	u64 wp_grp_size, start, part_end;
	u64 group_start;
	u64 check_group_start;
	u64 set_protect_cnt = 0;

	err = mmc_get_ext_csd(mmc, ext_csd);
	if (err) {
		printf("Failed: get ext_csd failed\n");
		return 1;
	}

	if (!is_write_protect_valid(ext_csd)) {
		printf("Failed: CLASS_6_CTRL isn't '0' "
				"write protect process is invalid\n");
		return 1;
	}

	err = compute_write_protect_range(mmc, name, ext_csd,
			&wp_grp_size, &start, &part_end);
	if (err)
		return 1;

	group_start = start;
	err = set_wp_register(mmc, ext_csd, wp_type);
	if (err)
		return 1;
	while ((group_start + wp_grp_size - 1) <= part_end) {
		err = set_write_prot(mmc, group_start);
		if (err)
			return 1;
		group_start += wp_grp_size;
		set_protect_cnt++;
//check write protect type every 32 group
		if (set_protect_cnt % 32 == 0) {
			check_group_start = group_start -  group_num * wp_grp_size;
			err = is_wp_set_failed(mmc, wp_type, check_group_start, group_num);
			if (err)
				return 1;
		}
	}

	group_num = set_protect_cnt % 32;
	check_group_start = group_start - group_num * wp_grp_size;

	if (group_num) {
		err = is_wp_set_failed(mmc, wp_type, check_group_start, group_num);
		if (err)
			return 1;
	}

	return 0;
}

static int set_add_write_protect(struct mmc *mmc, u8 wp_type, u64 start, u64 cnt)
{
	int err = 0;
	u8 ext_csd[512] = {0};
	int group_num = 32;
	u64 wp_grp_size, part_end;
	u64 group_start;
	u64 check_group_start;
	u64 set_protect_cnt = 0;
	u64 mmc_boundary = 0;
	int blk_shift;
	err = mmc_get_ext_csd(mmc, ext_csd);

	if (err) {
		printf("Failed: get ext_csd failed\n");
		return 1;
	}

	if (!is_write_protect_valid(ext_csd)) {
		printf("Failed: CLASS_6_CTRL isn't '0' "
				"write protect process is invalid\n");
		return 1;
	}

	if (err)
		return 1;

	wp_grp_size = write_protect_group_size(mmc, ext_csd);

	if ((start % wp_grp_size)) {
	  group_start = (start + wp_grp_size - 1) / wp_grp_size * wp_grp_size;
	  printf("Caution! The partition start address isn't' aligned"
			  "to group size\n"
			 "the start address is change from 0x%llx to 0x%llx\n",
			 start, group_start);
	  part_end = group_start + (cnt - 1) * wp_grp_size - 1;
	  printf("The write protect group number is 0x%llx, rather than 0x%lld\n",
			  cnt - 1, cnt);
	} else {
	  group_start = start;
	  part_end = group_start + cnt * wp_grp_size - 1;
	}

	blk_shift = ffs(mmc->read_bl_len) - 1;
	mmc_boundary = mmc->capacity>>blk_shift;

	if ((part_end + 1) > mmc_boundary) {
		printf("Error: the operation cross the boundary of mmc\n");
		return 1;
	}

	err = set_wp_register(mmc, ext_csd, wp_type);
	if (err)
		return 1;

	while ((group_start + wp_grp_size - 1) <= part_end) {
		err = set_write_prot(mmc, group_start);
		if (err)
			return 1;
		group_start += wp_grp_size;
		set_protect_cnt++;
//check write protect type every 32 group
		if (set_protect_cnt % 32 == 0) {
			check_group_start = group_start -  group_num * wp_grp_size;
			err = is_wp_set_failed(mmc, wp_type, check_group_start, group_num);
			if (err)
				return 1;
		}
	}

	group_num = set_protect_cnt % 32;
	check_group_start = group_start - group_num * wp_grp_size;

	if (group_num) {
		err = is_wp_set_failed(mmc, wp_type, check_group_start, group_num);
		if (err)
			return 1;
	}

	return 0;
}

static int do_amlmmc_write_protect(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	int ret = CMD_RET_USAGE;
	struct mmc *mmc;
	int dev = 1;
	char *name = NULL;
	char *wp_type_str = NULL;
	u8 write_protect_type;
	u64 start, cnt;

	if (argc > 5 || argc < 4)
		return ret;
	if (argc == 4) {
		name = argv[2];
		wp_type_str = argv[3];
		dev = find_dev_num_by_partition_name(name);
		if (dev < 0) {
			printf("Error: Cannot find dev.\n");
			return CMD_RET_USAGE;
		}
	} else {
		start = simple_strtoull(argv[2], NULL, 16);
		cnt = simple_strtoull(argv[3], NULL, 0);
		wp_type_str = argv[4];
	}

	mmc = find_mmc_device(dev);

	if (IS_SD(mmc)) {
		mmc = find_mmc_device(~dev);
		if (IS_SD(mmc)) {
			printf("SD card can not be write protect\n");
			return 1;
		}
	}

	if (!mmc)
		return 1;

	mmc_init(mmc);
	if (!mmc)
		return 1;

	if (strcmp(wp_type_str, "temporary") == 0)
		write_protect_type = WP_TEMPORARY_TYPE;
	else if (strcmp(wp_type_str, "power_on") == 0 )
		write_protect_type = WP_POWER_ON_TYPE;
	else if (strcmp(wp_type_str, "permanent") == 0)
		write_protect_type = WP_PERMANENT_TYPE;
	else
		return ret;

	if (argc == 4)
		ret = set_part_write_protect(mmc, write_protect_type, name);
	else
		ret = set_add_write_protect(mmc, write_protect_type, start, cnt);

	return ret;
}

static int clear_write_prot_per_group(struct mmc *mmc, u64 blk)
{
	struct mmc_cmd cmd;
	int err;

	cmd.cmdidx = MMC_CMD_CLR_WRITE_PROT;
	cmd.cmdarg = blk;
	cmd.resp_type = MMC_RSP_R1b;

	err = mmc_send_cmd(mmc, &cmd, NULL);

	return err;
}

static int set_part_clear_wp(struct mmc *mmc, char *name)
{
	int err = 0;
	u8 ext_csd[512] = {0};
	u8 group_num  = 32;
	u64 wp_grp_size, start, part_end;
	u64 group_start;
	u64 check_group_start;
	u64 set_protect_cnt = 0;
	u8 wp_type = WP_CLEAR_TYPE;

	err = mmc_get_ext_csd(mmc, ext_csd);
	if (err) {
		printf("get ext_csd failed\n");
		return 1;
	}

	if (!is_write_protect_valid(ext_csd)) {
		printf("CLASS_6_CTRL isn't '0' write protect process is invalid\n");
		return 1;
	}

	err = compute_write_protect_range(mmc, name, ext_csd,
			&wp_grp_size, &start, &part_end);
	if (err)
		return 1;

	group_start = start;
/*
	if (!is_wp_type_temporary(ext_csd)) {
		printf("The write protect can't be clear\n");
		return 1;
	}
*/
	while ((group_start + wp_grp_size - 1) <= part_end) {
		err = clear_write_prot_per_group(mmc, group_start);
		if (err) {
			printf("Error: The write protect can't be clear\n");
			return 1;
		}
		group_start += wp_grp_size;
		set_protect_cnt++;
//check write protect type every 32 group
		if (set_protect_cnt % 32 == 0) {
			check_group_start = group_start -  group_num * wp_grp_size;
			err = is_wp_set_failed(mmc, wp_type, check_group_start, group_num);
			if (err)
				return 1;
		}
	}

	group_num = set_protect_cnt % 32;
	check_group_start = group_start - group_num * wp_grp_size;

	if (group_num) {
		err = is_wp_set_failed(mmc, wp_type, check_group_start, group_num);
		if (err)
			return 1;
	}

	return 0;
}

static int set_add_clear_wp(struct mmc *mmc, u64 start, u64 cnt)
{
	int err = 0;
	u8 ext_csd[512] = {0};
	u8 group_num  = 32;
	u64 wp_grp_size, part_end;
	u64 group_start;
	u64 check_group_start;
	u64 set_protect_cnt = 0;
	u8 wp_type = WP_CLEAR_TYPE;
	int blk_shift;
	u64 mmc_boundary;

	err = mmc_get_ext_csd(mmc, ext_csd);
	if (err) {
		printf("get ext_csd failed\n");
		return 1;
	}

	if (!is_write_protect_valid(ext_csd)) {
		printf("CLASS_6_CTRL isn't '0' write protect process is invalid\n");
		return 1;
	}

	wp_grp_size = write_protect_group_size(mmc, ext_csd);

	if ((start % wp_grp_size)) {
		 group_start = (start + wp_grp_size - 1) / wp_grp_size * wp_grp_size;
		 printf("Caution! The partition start address isn't' aligned"
				 "to group size\n"
				"the start address is change from 0x%llx to 0x%llx\n",
				start, group_start);
		 part_end = group_start + (cnt - 1) * wp_grp_size - 1;
		 printf("The write protect group number is 0x%llx, rather than 0x%lld\n",
				 cnt - 1, cnt);
	 } else {
		 group_start = start;
		 part_end = group_start + cnt * wp_grp_size - 1;
	 }

	 blk_shift = ffs(mmc->read_bl_len) - 1;
	 mmc_boundary = mmc->capacity>>blk_shift;

	 if ((part_end + 1) > mmc_boundary) {
		 printf("Error: the operation cross the boundary of mmc\n");
		 return 1;
	 }

	while ((group_start + wp_grp_size - 1) <= part_end) {
		err = clear_write_prot_per_group(mmc, group_start);
		if (err) {
			printf("Error: The write protect can't be clear\n");
			return 1;
		}
		group_start += wp_grp_size;
		set_protect_cnt++;
//check write protect type every 32 group
		if (set_protect_cnt % 32 == 0) {
			check_group_start = group_start -  group_num * wp_grp_size;
			err = is_wp_set_failed(mmc, wp_type, check_group_start, group_num);
			if (err)
				return 1;
		}
	}

	group_num = set_protect_cnt % 32;
	check_group_start = group_start - group_num * wp_grp_size;

	if (group_num) {
		err = is_wp_set_failed(mmc, wp_type, check_group_start, group_num);
		if (err)
			return 1;
	}

	return 0;
}

static int do_amlmmc_clear_wp(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	int ret = CMD_RET_USAGE;
	struct mmc *mmc;
	int dev = 1;
	char *name = NULL;
	u64 start, cnt;

	if (argc < 3 || argc > 4)
		return ret;

	if (argc == 3) {
		 name = argv[2];
		 dev = find_dev_num_by_partition_name(name);
		 if (dev < 0) {
			 printf("Error: Cannot find dev.\n");
			 return CMD_RET_USAGE;
		 }
	 } else {
		 start = simple_strtoull(argv[2], NULL, 16);
		 cnt = simple_strtoull(argv[3], NULL, 10);
	 }

	mmc = find_mmc_device(dev);
	if (!mmc)
		return 1;

	if (IS_SD(mmc)) {
		mmc = find_mmc_device(~dev);
		if (IS_SD(mmc)) {
			printf("SD card can not be write protect\n");
			return 1;
		}
	}

	mmc_init(mmc);
	if (!mmc)
		return 1;

	if (argc == 3)
		ret = set_part_clear_wp(mmc, name);
	else
		ret = set_add_clear_wp(mmc, start, cnt);

	return ret;
}

static int send_write_prot_status_group(struct mmc *mmc, u64 blk)
{
	struct mmc_cmd cmd;
	struct mmc_data data;
	int err;
	void *addr = NULL;
	int i = 0;
	addr = malloc(4*sizeof(u8));

	if (addr == NULL) {
		printf("Failed: malloc failed\n");
		return 1;
	}

	cmd.cmdidx = MMC_CMD_SEND_WRITE_PROT;
	cmd.cmdarg = blk;
	cmd.resp_type = MMC_RSP_R1;

	data.dest = addr;
	data.blocks = 1;
	data.blocksize = 4;
	data.flags = MMC_DATA_READ;

	err = mmc_send_cmd(mmc, &cmd, &data);
	if (err)
		goto err_out;

	printf("The write protect type for the 32 groups after 0x%llx is:\n0x",
			blk);
	for (i = 0 ; i < 4; i++)
		printf("%02x", ((u8 *)addr)[i]);
	printf("\n");

	free(addr);
	return 0;
err_out:
	free(addr);
	return 1;
}

static int send_part_wp_status(struct mmc *mmc, char *name)
{
	int err = 0;
	u8 ext_csd[512] = {0};
	u64 wp_grp_size, start, part_end;
	u64 group_start;

	err = mmc_get_ext_csd(mmc, ext_csd);
	if (err) {
		printf("Failed: get ext_csd failed\n");
		return 1;
	}

	if (!is_write_protect_valid(ext_csd)) {
		printf("Failed: CLASS_6_CTRL isn't '0' "
				"write protect process is invalid\n");
		return 1;
	}

	err = compute_write_protect_range(mmc, name, ext_csd,
			&wp_grp_size, &start, &part_end);
	if (err)
		return 1;

	group_start = start;

	while ((group_start + wp_grp_size - 1) <= part_end) {
		err = send_write_prot_status_group(mmc, group_start);
		if (err)
			return 1;
		group_start += 32 * wp_grp_size;
	}

	return 0;
}

static int send_add_wp_status(struct mmc *mmc, u64 start, u64 cnt)
{
	int err = 0;
	u8 ext_csd[512] = {0};
	u64 wp_grp_size, part_end;
	u64 group_start;
	int blk_shift;
	u64 mmc_boundary;
	err = mmc_get_ext_csd(mmc, ext_csd);
	if (err) {
		printf("Failed: get ext_csd failed\n");
		return 1;
	}

	if (!is_write_protect_valid(ext_csd)) {
		printf("Failed: CLASS_6_CTRL isn't '0' "
				"write protect process is invalid\n");
		return 1;
	}

	wp_grp_size = write_protect_group_size(mmc, ext_csd);

	if ((start % wp_grp_size)) {
		 group_start = (start + wp_grp_size - 1) / wp_grp_size * wp_grp_size;
		 printf("Caution! The partition start address isn't' aligned"
				 "to group size\n"
				"the start address is change from 0x%llx to 0x%llx\n",
				start, group_start);
		 part_end = group_start + (cnt - 1) * wp_grp_size - 1;
		 printf("The write protect group number is 0x%llx, rather than 0x%lld\n",
				 cnt - 1, cnt);
	 } else {
		 group_start = start;
		 part_end = group_start + cnt * wp_grp_size - 1;
	 }

	blk_shift = ffs(mmc->read_bl_len) - 1;
	mmc_boundary = mmc->capacity>>blk_shift;

	if ((part_end + 1) > mmc_boundary) {
		printf("Error: the operation cross the boundary of mmc\n");
		return 1;
	}

	while ((group_start + wp_grp_size - 1) <= part_end) {
		err = send_write_prot_status_group(mmc, group_start);
		if (err)
			return 1;
		group_start += 32 * wp_grp_size;
	}

	return 0;
}

static int do_amlmmc_send_wp_status(cmd_tbl_t *cmdtp,
		int flag, int argc, char *const argv[])
{
	int ret = CMD_RET_USAGE;
	struct mmc *mmc;
	int dev = 1;
	char *name = NULL;
	u64 start, cnt;

	if (argc < 3 || argc > 4)
		return ret;

	if (argc == 3) {
		name = argv[2];
		dev = find_dev_num_by_partition_name(name);
		if (dev < 0) {
			printf("Error: Cannot find dev.\n");
			return 1;
		}
	} else {
		start = simple_strtoull(argv[2], NULL, 16);
		cnt = simple_strtoull(argv[3], NULL, 0);
	}

	mmc = find_mmc_device(dev);

	if (IS_SD(mmc)) {
		mmc = find_mmc_device(~dev);
		if (IS_SD(mmc)) {
			printf("SD card can not be write protect\n");
			return 1;
		}
	}

	if (!mmc)
		return 1;

	mmc_init(mmc);
	if (!mmc)
		return 1;

	if (argc == 3)
		ret = send_part_wp_status(mmc, name);
	else
		ret = send_add_wp_status(mmc, start, cnt);

	if (ret) {
		printf("Failed: send partition write protect status failed\n");
	}

	return ret;
}

static int do_amlmmc_send_wp_type(cmd_tbl_t *cmdtp,
		int flag, int argc, char *const argv[])
{
	int ret = CMD_RET_USAGE;
	struct mmc *mmc;
	int dev = 1;
	char *name = NULL;
	u64 start, cnt;

	if (argc < 3 || argc > 4)
		return ret;

	if (argc == 3) {
		name = argv[2];
		dev = find_dev_num_by_partition_name(name);
		if (dev < 0) {
			printf("Error: Cannot find dev.\n");
			return 1;
		}
	} else {
		start = simple_strtoull(argv[2], NULL, 16);
		cnt = simple_strtoull(argv[3], NULL, 0);
	}

	mmc = find_mmc_device(dev);

	if (!mmc)
		return 1;

	if (IS_SD(mmc)) {
		mmc = find_mmc_device(~dev);
		if (IS_SD(mmc)) {
			printf("SD card can not be write protect\n");
			return 1;
		}
	}

	mmc_init(mmc);
	if (!mmc)
		return 1;
	if (argc == 3)
		ret = send_part_wp_type(mmc, name);
	else
		ret = send_add_wp_type(mmc, start, cnt);

	if (ret) {
		printf("Failed: send parittion write protect type failed\n");
	}

	return ret;
}

static int set_driver_strength(struct mmc *mmc, int strength)
{
	int ret = 0;
	u8 ext_csd[512] = {0};
	u8 strength_type = 0;
	u8 driver_strength;
	u8 hs_timing = 0;
	ret = mmc_get_ext_csd(mmc, ext_csd);
	if (ret) {
		printf("get ext_csd failed\n");
		return ret;
	}
	strength_type = 1 << strength;
	driver_strength = ext_csd[EXT_CSD_DRIVER_STRENGTH];
	if (0 == (strength_type & driver_strength)) {
		printf("Failed: This device didn't support strength type %d\n", strength);
		return 1;
	}

	hs_timing = ext_csd[EXT_CSD_HS_TIMING];
	if ((hs_timing >> 4) > 0) {
		printf("Failed: The driver strength has been set already, \
			  please reset the device\n");
		return 1;
	}

	hs_timing = hs_timing | (strength << 4);

	ret = mmc_set_ext_csd(mmc, EXT_CSD_HS_TIMING, hs_timing);
	if (ret) {
		printf("set ext_csd hs_timing field failed\n");
		return ret;
	}
	ret = mmc_get_ext_csd(mmc, ext_csd);
	if (ret) {
		printf("get ext_csd failed\n");
		return ret;
	}
	printf("The ext_csd[HS_TIMING] has been set to 0x%x\n",
		  ext_csd[EXT_CSD_HS_TIMING]);
	return ret;
}

static int get_driver_strength(struct mmc *mmc)
{
	int ret = 0;
	u8 ext_csd[512] = {0};
	u8 support_ds_type = 0;
	u8 cur_driver_strength;
	u8 hs_timing = 0;
	ret = mmc_get_ext_csd(mmc, ext_csd);
	if (ret) {
		printf("get ext_csd failed\n");
		return ret;
	}

	support_ds_type = ext_csd[EXT_CSD_DRIVER_STRENGTH];

	hs_timing = ext_csd[EXT_CSD_HS_TIMING];
	cur_driver_strength = hs_timing >> 4;

	printf("current strength type is: ");
	int strength_type = 0;
	while (support_ds_type) {
		if (support_ds_type & 1) {
			if (cur_driver_strength == strength_type)
				printf("[%d] ", strength_type);
			else
				printf("%d ", strength_type);
		}
		strength_type++;
		support_ds_type = support_ds_type >> 1;
	}
	printf("\n");
	return ret;
}

static int amlmmc_set_driver_strength(int argc, char *const argv[])
{
	int ret = CMD_RET_USAGE;
	int dev, strength;
	struct mmc *mmc;

	if (argc != 4)
		return CMD_RET_USAGE;

	dev = simple_strtoul(argv[2], NULL, 10);
	strength = simple_strtoul(argv[3], NULL, 10);
	mmc = find_mmc_device(dev);
	if (!mmc) {
		puts("no mmc devices available\n");
		return 1;
	}
	mmc_init(mmc);
	if (!mmc)
		return 1;

	ret = set_driver_strength(mmc, strength);

	return ret;
}

static int amlmmc_get_driver_strength(int argc, char *const argv[])
{
	int ret = CMD_RET_USAGE;
	int dev;
	struct mmc *mmc;

	if (argc != 3)
		return CMD_RET_USAGE;

	dev = simple_strtoul(argv[2], NULL, 10);
	mmc = find_mmc_device(dev);
	if (!mmc) {
		puts("no mmc devices available\n");
		return 1;
	}
	mmc_init(mmc);
	if (!mmc)
		return 1;

	ret = get_driver_strength(mmc);

	return ret;
}

static int do_amlmmc_driver_strength(cmd_tbl_t *cmdtp,
		int flag, int argc, char *const argv[])
{
	int ret = CMD_RET_USAGE;

	if (argc == 3)
		ret = amlmmc_get_driver_strength(argc,argv);
	else if (argc == 4)
		ret = amlmmc_set_driver_strength(argc,argv);

	return ret;
}

#ifdef MMC_HS200_MODE
static int do_amlmmc_reset_delay(cmd_tbl_t *cmdtp, int flag,
		int argc, char * const argv[])
{
	struct mmc *mmc;
	int dev;

	struct aml_card_sd_info *aml_priv;
	struct sd_emmc_global_regs *sd_emmc_regs;

	if (argc != 3)
		return CMD_RET_USAGE;

	dev = simple_strtoul(argv[2], NULL, 10);
	mmc = find_mmc_device(dev);
	if (!mmc) {
		puts("no mmc devices available\n");
		return 1;
	}
	mmc_init(mmc);
	if (!mmc)
		return 1;

	aml_priv = mmc->priv;
	sd_emmc_regs = aml_priv->sd_emmc_reg;

	sd_emmc_regs->gdelay = 0;
	sd_emmc_regs->gdelay1 = 0;

	return CMD_RET_SUCCESS;

}

static int do_amlmmc_clktest(cmd_tbl_t *cmdtp, int flag,
		int argc, char * const argv[])
{
	struct mmc *mmc;
	int dev;

	if (argc != 3)
		return CMD_RET_USAGE;
	dev = simple_strtoul(argv[2], NULL, 10);

	if (dev < 0) {
		printf("Cannot find dev.\n");
		return 1;
	}
	mmc  = find_mmc_device(dev);

	if (!mmc) {
		puts("no mmc devices available\n");
		return 1;
	}

	mmc_init(mmc);
	if (!mmc)
		return 1;

	aml_sd_emmc_clktest(mmc);
	return CMD_RET_SUCCESS;
}

static int do_amlmmc_set_rxdelay(cmd_tbl_t *cmdtp, int flag,
		int argc, char * const argv[])
{
	struct mmc *mmc;
	int dev;
	u32 delay1, delay2;

	if (argc != 5)
		return CMD_RET_USAGE;
	dev = simple_strtoul(argv[2], NULL, 10);
	delay1 = simple_strtoul(argv[3], NULL, 16);
	delay2 = simple_strtoul(argv[4], NULL, 16);

	if (dev < 0) {
		printf("Cannot find dev.\n");
		return 1;
	}
	mmc  = find_mmc_device(dev);

	if (!mmc) {
		puts("no mmc devices available\n");
		return 1;
	}

	mmc_init(mmc);
	if (!mmc)
		return 1;

	struct aml_card_sd_info *aml_priv = mmc->priv;
	struct sd_emmc_global_regs *sd_emmc_regs = aml_priv->sd_emmc_reg;

	sd_emmc_regs->gdelay = delay1;
	sd_emmc_regs->gdelay1 = delay2;

	update_all_line_eyetest(mmc);

	return CMD_RET_SUCCESS;
}

static int do_amlmmc_set_txdelay(cmd_tbl_t *cmdtp, int flag,
		int argc, char * const argv[])
{
	struct mmc *mmc;
	u32 delay;
	u32 mask;
	int dev;

	if (argc != 4)
		return CMD_RET_USAGE;
	dev = simple_strtoul(argv[2], NULL, 10);
	delay = simple_strtoul(argv[3], NULL, 16);

	if (dev < 0) {
		printf("Cannot find dev.\n");
		return 1;
	}
	mmc  = find_mmc_device(dev);

	if (!mmc) {
		puts("no mmc devices available\n");
		return 1;
	}

	mmc_init(mmc);
	if (!mmc)
		return 1;

	if (delay < 0 || delay > 63) {
		printf("error: tx delay is out of range\n");
		return CMD_RET_USAGE;
	}

	struct aml_card_sd_info *aml_priv = mmc->priv;
	struct sd_emmc_global_regs *sd_emmc_regs = aml_priv->sd_emmc_reg;

	mask = ~(0x3f<<16);
	sd_emmc_regs->gclock = sd_emmc_regs->gclock & mask;
	sd_emmc_regs->gclock |= delay << 16;

	update_all_line_eyetest(mmc);
	return CMD_RET_SUCCESS;
}

static void set_vddee_voltage(unsigned int target_voltage)
{
	unsigned int to;

	for (to = 0; to < ARRAY_SIZE(pwm_voltage_table_ee); to++) {
		if (pwm_voltage_table_ee[to][1] >= target_voltage) {
			break;
		}
	}

	if (to >= ARRAY_SIZE(pwm_voltage_table_ee)) {
		to = ARRAY_SIZE(pwm_voltage_table_ee) - 1;
	}

	SD_EMMC_VDDEE_REG = pwm_voltage_table_ee[to][0];
}

static int send_vddee_voltage(unsigned int target_voltage)
{
	unsigned int to;
	int vddee;

	for (to = 0; to < ARRAY_SIZE(pwm_voltage_table_ee); to++) {
		if (pwm_voltage_table_ee[to][0] <= target_voltage) {
			break;
		}
	}

	if (to >= ARRAY_SIZE(pwm_voltage_table_ee)) {
		to = ARRAY_SIZE(pwm_voltage_table_ee) - 1;
	}

	vddee = pwm_voltage_table_ee[to][1];

	return vddee;
}

static int do_amlmmc_set_vddee(cmd_tbl_t *cmdtp, int flag,
		int argc, char * const argv[])
{
	unsigned int vddee;
	struct mmc *mmc;
	int dev;

	if (argc != 4)
		return CMD_RET_USAGE;
	dev = simple_strtoul(argv[2], NULL, 10);
	vddee = simple_strtoul(argv[3], NULL, 10);

	if (dev < 0) {
		printf("Cannot find dev.\n");
		return 1;
	}

	mmc  = find_mmc_device(dev);

	if (!mmc) {
		puts("no mmc devices available\n");
		return 1;
	}

	mmc_init(mmc);
	if (!mmc)
		return 1;

	set_vddee_voltage(vddee);
	return CMD_RET_SUCCESS;

}

static int do_amlmmc_show_vddee(cmd_tbl_t *cmdtp, int flag,
		int argc, char * const argv[])
{
	int vddee;
	unsigned int vddee_reg;
	struct mmc *mmc;
	int dev;

	if (argc != 3)
		return CMD_RET_USAGE;
	dev = simple_strtoul(argv[2], NULL, 10);

	if (dev < 0) {
		printf("Cannot find dev.\n");
		return 1;
	}

	mmc  = find_mmc_device(dev);

	if (!mmc) {
		puts("no mmc devices available\n");
		return 1;
	}

	mmc_init(mmc);
	if (!mmc)
		return 1;

	vddee_reg = SD_EMMC_VDDEE_REG;

	vddee = send_vddee_voltage(vddee_reg);

	printf("meson-mmc: emmc: vddee is %d mv\n", vddee);

	return CMD_RET_SUCCESS;

}

static int do_amlmmc_refix(cmd_tbl_t *cmdtp, int flag,
		int argc, char * const argv[])
{
	int err;
	struct mmc *mmc;
	int dev;

	if (argc != 3)
		return CMD_RET_USAGE;
	dev = simple_strtoul(argv[2], NULL, 10);

	if (dev < 0) {
		printf("Cannot find dev.\n");
		return 1;
	}

	mmc  = find_mmc_device(dev);

	if (!mmc) {
		puts("no mmc devices available\n");
		return 1;
	}

	mmc_init(mmc);
	if (!mmc)
		return 1;

	err = aml_emmc_refix(mmc);
	if (err)
		printf("refix failed\n");
	return err;

}

static int do_amlmmc_move_all_delay(cmd_tbl_t *cmdtp, int flag,
		int argc, char * const argv[])
{
	struct mmc *mmc;
	u32 delay1, delay2;
	u8 count;
	int dev;

	if (argc != 4)
		return CMD_RET_USAGE;
	dev = simple_strtoul(argv[2], NULL, 10);
	count = simple_strtoul(argv[3], NULL, 16);
	if (dev < 0) {
		printf("Cannot find dev.\n");
		return 1;
	}

	mmc  = find_mmc_device(dev);

	if (!mmc) {
		puts("no mmc devices available\n");
		return 1;
	}

	mmc_init(mmc);
	if (!mmc)
		return 1;

	struct aml_card_sd_info *aml_priv = mmc->priv;
	struct sd_emmc_global_regs *sd_emmc_regs = aml_priv->sd_emmc_reg;

	delay1 = sd_emmc_regs->gdelay;
	delay2 = sd_emmc_regs->gdelay1;

	delay1 += (count<<0)|(count<<6)|(count<<12)|(count<<18)|(count<<24);
	delay2 += (count<<0)|(count<<6)|(count<<12);

	sd_emmc_regs->gdelay = delay1;
	sd_emmc_regs->gdelay1 = delay2;

	update_all_line_eyetest(mmc);
	return CMD_RET_SUCCESS;
}

static int do_amlmmc_move_sig_delay(cmd_tbl_t *cmdtp, int flag,
		int argc, char * const argv[])
{
	struct mmc *mmc;
	u32 delay1, delay2;
	u8 line, count;
	int dev;

	if (argc != 5)
		return CMD_RET_USAGE;

	dev = simple_strtoul(argv[2], NULL, 10);
	line = simple_strtoul(argv[3], NULL, 10);
	count = simple_strtoul(argv[4], NULL, 10);

	if (dev < 0) {
		printf("Cannot find dev.\n");
		return 1;
	}

	mmc  = find_mmc_device(dev);

	if (!mmc) {
		puts("no mmc devices available\n");
		return 1;
	}

	mmc_init(mmc);
	if (!mmc)
		return 1;

	if (line > 9 || line < 0) {
		printf("error: data line out of range\n");
		return CMD_RET_USAGE;
	}

	struct aml_card_sd_info *aml_priv = mmc->priv;
	struct sd_emmc_global_regs *sd_emmc_regs = aml_priv->sd_emmc_reg;

	delay1 = sd_emmc_regs->gdelay;
	delay2 = sd_emmc_regs->gdelay1;

	if (line < 5) {
		delay1 += (count<<(6*line));
		sd_emmc_regs->gdelay = delay1;
	} else {
		delay2 += (count<<(6 * (line - 5)));
		sd_emmc_regs->gdelay1 = delay2;
	}

	update_all_line_eyetest(mmc);
	return CMD_RET_SUCCESS;
}

static int do_amlmmc_line_eyetest(cmd_tbl_t *cmdtp, int flag,
		int argc, char * const argv[])
{
	struct mmc *mmc;
	u32 delay1, delay2;
	u8 line, count;
	int dev;
	u32 mask = 0x3f;

	if (argc != 4)
		return CMD_RET_USAGE;

	dev = simple_strtoul(argv[2], NULL, 10);
	line = simple_strtoul(argv[3], NULL, 10);

	if (dev < 0) {
		printf("Cannot find dev.\n");
		return 1;
	}

	mmc  = find_mmc_device(dev);

	if (!mmc) {
		puts("no mmc devices available\n");
		return 1;
	}

	mmc_init(mmc);
	if (!mmc)
		return 1;

	if (line > 9 || line < 0) {
		printf("error: data line out of range\n");
		return CMD_RET_USAGE;
	}

	struct aml_card_sd_info *aml_priv = mmc->priv;
	struct sd_emmc_global_regs *sd_emmc_regs = aml_priv->sd_emmc_reg;

	delay1 = sd_emmc_regs->gdelay;
	delay2 = sd_emmc_regs->gdelay1;

	if (line < 5)
		delay1 &= ~(mask << (6 * line));
	else
		delay2 &= ~(mask << (6 * (line - 5)));

	for (count = 0; count < 64; count++) {
		if (line < 5) {
			delay1 &= ~(mask << (6 * line));
			delay1 |= (count << (6 * line));
			sd_emmc_regs->gdelay = delay1;
		} else {
			delay2 &= ~(mask << (6 * (line - 5)));
			delay2 |= (count << (6 * line));
			sd_emmc_regs->gdelay1 = delay2;
		}
		emmc_eyetest_log(mmc, line);
	}
	return CMD_RET_SUCCESS;
}
#endif
static cmd_tbl_t cmd_amlmmc[] = {
	U_BOOT_CMD_MKENT(read,          6, 0, do_amlmmc_read,          "", ""),
	U_BOOT_CMD_MKENT(write,         6, 0, do_amlmmc_write,         "", ""),
	U_BOOT_CMD_MKENT(erase,         5, 0, do_amlmmc_erase,         "", ""),
	U_BOOT_CMD_MKENT(rescan,        3, 0, do_amlmmc_rescan,        "", ""),
	U_BOOT_CMD_MKENT(part,          3, 0, do_amlmmc_part,          "", ""),
	U_BOOT_CMD_MKENT(list,          2, 0, do_amlmmc_list,          "", ""),
	U_BOOT_CMD_MKENT(switch,        4, 0, do_amlmmc_switch,        "", ""),
	U_BOOT_CMD_MKENT(status,        3, 0, do_amlmmc_status,        "", ""),
	U_BOOT_CMD_MKENT(ext_csd,       5, 0, do_amlmmc_ext_csd,       "", ""),
	U_BOOT_CMD_MKENT(response,      3, 0, do_amlmmc_response,      "", ""),
	U_BOOT_CMD_MKENT(controller,    3, 0, do_amlmmc_controller,    "", ""),
	U_BOOT_CMD_MKENT(size,          4, 0, do_amlmmc_size,          "", ""),
	U_BOOT_CMD_MKENT(env,           2, 0, do_amlmmc_env,           "", ""),
	U_BOOT_CMD_MKENT(write_protect, 5, 0, do_amlmmc_write_protect,  "", ""),
	U_BOOT_CMD_MKENT(send_wp_status, 4, 0, do_amlmmc_send_wp_status, "", ""),
	U_BOOT_CMD_MKENT(send_wp_type,   4, 0, do_amlmmc_send_wp_type, "", ""),
	U_BOOT_CMD_MKENT(clear_wp,      4, 0, do_amlmmc_clear_wp,      "", ""),
	U_BOOT_CMD_MKENT(ds,            4, 0, do_amlmmc_driver_strength, "", ""),
#ifdef CONFIG_SECURITYKEY
	U_BOOT_CMD_MKENT(key,           2, 0, do_amlmmc_key,           "", ""),
#endif
#ifdef MMC_HS200_MODE
	U_BOOT_CMD_MKENT(clktest,    3, 0, do_amlmmc_clktest,    "", ""),
	U_BOOT_CMD_MKENT(refix,    3, 0, do_amlmmc_refix,    "", ""),
	U_BOOT_CMD_MKENT(move_all, 4, 0, do_amlmmc_move_all_delay, "", ""),
	U_BOOT_CMD_MKENT(move_single, 5, 0, do_amlmmc_move_sig_delay, "", ""),
	U_BOOT_CMD_MKENT(set_rxdly, 5, 0, do_amlmmc_set_rxdelay, "", ""),
	U_BOOT_CMD_MKENT(set_txdly, 4, 0, do_amlmmc_set_txdelay, "", ""),
	U_BOOT_CMD_MKENT(set_vddee, 4, 0, do_amlmmc_set_vddee, "", ""),
	U_BOOT_CMD_MKENT(show_vddee, 3, 0, do_amlmmc_show_vddee, "", ""),
	U_BOOT_CMD_MKENT(reset_dly, 3, 0, do_amlmmc_reset_delay, "", ""),
	U_BOOT_CMD_MKENT(line_eyetest, 4, 0, do_amlmmc_line_eyetest, "", ""),
#endif
};

static int do_amlmmcops(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	cmd_tbl_t *cp;

	cp = find_cmd_tbl(argv[1], cmd_amlmmc, ARRAY_SIZE(cmd_amlmmc));

	if (cp == NULL || argc > cp->maxargs)
		return CMD_RET_USAGE;

	if (flag == CMD_FLAG_REPEAT && !cp->repeatable)
		return CMD_RET_SUCCESS;

	return cp->cmd(cmdtp, flag, argc, argv);
}

U_BOOT_CMD(
	amlmmc, 6, 1, do_amlmmcops,
	"AMLMMC sub system",
	"read  <partition_name> ram_addr addr_byte# cnt_byte\n"
	"amlmmc write <partition_name> ram_addr addr_byte# cnt_byte\n"
	"amlmmc erase <partition_name> addr_byte# cnt_byte\n"
	"amlmmc erase <partition_name>/<device num>\n"
	"amlmmc rescan <device_num>\n"
	"amlmmc part <device_num> - show partition infomation of mmc\n"
	"amlmmc list - lists available devices\n"
	"amlmmc env -  display env partition offset\n"
	"amlmmc switch <device_num> <part name> - part name : boot0, boot1, user\n"
	"amlmmc status <device_num> - read sd/emmc device status\n"
	"amlmmc ext_csd <device_num> <byte> - read sd/emmc device EXT_CSD [byte]\n"
	"amlmmc ext_csd <device_num> <byte> <value> - write sd/emmc device EXT_CSD [byte] value\n"
	"amlmmc response <device_num> - read sd/emmc last command response\n"
	"amlmmc controller <device_num> - read sd/emmc controller register\n"
	"amlmmc write_protect <partition_name> <write_protect_type>\n"
	"        - set write protect on partition through power_on or temporary\n"
	"amlmmc write_protect <addr_base16> <cnt_base10> <write_protect_type>\n"
	"        - set write protect on specified address through power_on or temporary\n"
	"amlmmc send_wp_status <partition_name> send protect status of partition\n"
	"amlmmc send_wp_status <addr_base16> <cnt_base10> send protect status on specified address\n"
	"amlmmc send_wp_type <partition_name> send protect type of partition\n"
	"amlmmc send_wp_type <addr_base16> <cnt_base10> send protect type on specified address\n"
	"amlmmc clear_wp <partition_name> clear write protect of partition\n"
	"amlmmc clear_wp <addr_base16> <cnt_base10> clear write protect on specified addresst\n"
	"amlmmc ds <dev_num> <val> set driver strength\n"
#ifdef CONFIG_SECURITYKEY
	"amlmmc key - disprotect key partition\n"
#endif
#ifdef MMC_HS200_MODE
	"amlmmc clktest <dev> - display info of delaycell and count\n"
	"amlmmc reset_dly <dev> - reset all delay register\n"
	"amlmmc set_rxdly <dev> <0xdelay1> <0xdelay2> - manually set rx delay value\n"
	"amlmmc set_txdly <dev> <0xdelay> - manually set tx delay\n"
	"amlmmc refix <dev> - fix adj\n"
	"amlmmc move_all <dev> <count> - move all data delay line <count> steps\n"
	"amlmmc move_single <dev> <line> <count> - move <line> <count> steps\n"
	"amlmmc set_vddee <dev> <value> - set vddee\n"
	"amlmmc show_vddee <dev> -show current vddee\n"
	"amlmmc line_eyetest <dev> <line> single line eyetest\n"
#endif
);

static u32 _calc_dtb_checksum(struct aml_dtb_rsv * dtb)
{
	int i = 0;
	int size = sizeof(struct aml_dtb_rsv) - sizeof(u32);
	u32 * buffer;
	u32 checksum = 0;

	if ((u64)dtb % 4 != 0) {
		BUG();
	}

	size = size >> 2;
	buffer = (u32*) dtb;
	while (i < size)
		checksum += buffer[i++];

	return checksum;
}

static int _verify_dtb_checksum(struct aml_dtb_rsv * dtb)
{
	u32 checksum;

	checksum = _calc_dtb_checksum(dtb);
	dtb_info("calc %x, store %x\n", checksum, dtb->checksum);

	return !(checksum == dtb->checksum);
}

static int _dtb_read(struct mmc *mmc, u64 blk, u64 cnt, void * addr)
{
	int dev = EMMC_DTB_DEV;
	u64 n;
	n = mmc->block_dev.block_read(dev, blk, cnt, addr);
	if (n != cnt) {
		dtb_err("%s: dev # %d, block # %#llx, count # %#llx ERROR!\n",
				__func__, dev, blk, cnt);
	}

	return (n != cnt);
}

static int _dtb_write(struct mmc *mmc, u64 blk, u64 cnt, void * addr)
{
	int dev = EMMC_DTB_DEV;
	u64 n;
	n = mmc->block_dev.block_write(dev, blk, cnt, addr);
	if (n != cnt) {
		dtb_err("%s: dev # %d, block # %#llx, count # %#llx ERROR!\n",
				__func__, dev, blk, cnt);
	}

	return (n != cnt);
}

static struct mmc *_dtb_init(void)
{
	struct mmc *mmc = find_mmc_device(EMMC_DTB_DEV);
	if (!mmc) {
		dtb_err("not find mmc\n");
		return NULL;
	}

	if (mmc_init(mmc)) {
		dtb_err("mmc init failed\n");
		return NULL;
	}
	return mmc;
}

static int dtb_read_shortcut(struct mmc * mmc, void *addr)
{
	u64 blk, cnt, dtb_glb_offset;
	int dev = EMMC_DTB_DEV;
	struct aml_dtb_info *info = &dtb_infos;
	struct partitions * part = NULL;
	struct virtual_partition *vpart = NULL;
	vpart = aml_get_virtual_partition_by_name(MMC_DTB_NAME);
	part = aml_get_partition_by_name(MMC_RESERVED_NAME);
	dtb_glb_offset = part->offset + vpart->offset;
	/* short cut */
	if (info->valid[0]) {
		dtb_info("short cut in...\n");
		blk = dtb_glb_offset / mmc->read_bl_len;
		cnt = vpart->size / mmc->read_bl_len;
		if (_dtb_read(mmc, blk, cnt, addr)) {
			dtb_err("%s: dev # %d, block # %#llx,cnt # %#llx ERROR!\n",
					__func__, dev, blk, cnt);
			/*try dtb2 if it's valid */
			if (info->valid[1]) {
				blk = (dtb_glb_offset + vpart->size) / mmc->read_bl_len;
				cnt = vpart->size / mmc->read_bl_len;
				if (_dtb_read(mmc, blk, cnt, addr)) {
					dtb_err("%s: dev # %d, block # %#llx, cnt # %#llx ERROR!\n",
						__func__, dev, blk, cnt);
					return -1;
				}
			}
		}
		return 0;
	}
	return -2;
}

static int update_dtb_info(struct mmc *mmc, void *addr)
{
	int ret = 0, dev = EMMC_DTB_DEV;
	u64 blk, cnt, dtb_glb_offset;
	struct aml_dtb_rsv * dtb = (struct aml_dtb_rsv *) addr;
	struct aml_dtb_info *info = &dtb_infos;
	int cpy = 1, valid = 0;
	struct partitions * part = NULL;
	struct virtual_partition *vpart = NULL;
	vpart = aml_get_virtual_partition_by_name(MMC_DTB_NAME);
	part = aml_get_partition_by_name(MMC_RESERVED_NAME);
	dtb_glb_offset = part->offset + vpart->offset;

	while (cpy >= 0) {
		blk = (dtb_glb_offset + cpy * (vpart->size)) / mmc->read_bl_len;
		cnt = vpart->size / mmc->read_bl_len;
		ret = _dtb_read(mmc, blk, cnt, addr);
		if (ret) {
			dtb_err("%s: dev # %d, block # %#llx, cnt # %#llx ERROR!\n",
				__func__, dev, blk, cnt);
		} else {
			ret = _verify_dtb_checksum(dtb);
			/* check magic avoid whole 0 issue */
			if (!ret && (dtb->magic != 0)) {
				info->stamp[cpy] = dtb->timestamp;
				info->valid[cpy] = 1;
			}
			else
				dtb_wrn("cpy %d is not valid\n", cpy);
		}
		valid += info->valid[cpy];
		cpy --;
	}
	return valid;
}

static int update_invalid_dtb(struct mmc *mmc, void *addr)
{
	int ret = 0, dev = EMMC_DTB_DEV;
	u64 blk, cnt, dtb_glb_offset;
	struct aml_dtb_rsv * dtb = (struct aml_dtb_rsv *) addr;
	struct aml_dtb_info *info = &dtb_infos;
	struct partitions * part = NULL;
	struct virtual_partition *vpart = NULL;
	vpart = aml_get_virtual_partition_by_name(MMC_DTB_NAME);
	part = aml_get_partition_by_name(MMC_RESERVED_NAME);
	dtb_glb_offset = part->offset + vpart->offset;
	cnt = vpart->size / mmc->read_bl_len;

	if (info->valid[1]) {
		blk = (dtb_glb_offset + vpart->size) / mmc->read_bl_len;
		if (_dtb_read(mmc, blk, cnt, addr)) {
		dtb_err("%s: dev # %d, block # %#llx,cnt # %#llx ERROR!\n",
				__func__, dev, blk, cnt);
			ret = -2;
		}
		/* fixme, update the invalid one - dtb1 */
		blk = (dtb_glb_offset) / mmc->read_bl_len;
		if (_dtb_write(mmc, blk, cnt, addr)) {
			dtb_err("%s: dev # %d, block # %#llx,cnt # %#llx ERROR!\n",
				__func__, dev, blk, cnt);
			ret = -4;
		}
		info->valid[0] = 1;
		info->stamp[0] = dtb->timestamp;
		ret = 0;
	} else {
		dtb_info("update dtb2");
		blk = (dtb_glb_offset + vpart->size) / mmc->read_bl_len;
		if (_dtb_write(mmc, blk, cnt, addr)) {
			dtb_err("%s: dev # %d, block # %#llx,cnt # %#llx ERROR!\n",
				__func__, dev, blk, cnt);
			ret = -2;
		}
		info->valid[1] = 1;
		info->stamp[1] = dtb->timestamp;
	}
	return ret;
}

int update_old_dtb(struct mmc *mmc, void *addr)
{
	int ret = 0, dev = EMMC_DTB_DEV;
	u64 blk, cnt, dtb_glb_offset;
	struct aml_dtb_rsv * dtb = (struct aml_dtb_rsv *) addr;
	struct aml_dtb_info *info = &dtb_infos;
	struct partitions * part = NULL;
	struct virtual_partition *vpart = NULL;
	vpart = aml_get_virtual_partition_by_name(MMC_DTB_NAME);
	part = aml_get_partition_by_name(MMC_RESERVED_NAME);
	dtb_glb_offset = part->offset + vpart->offset;
	cnt = vpart->size / mmc->read_bl_len;
	if (stamp_after(info->stamp[1], info->stamp[0])) {
		blk = (dtb_glb_offset + vpart->size) / mmc->read_bl_len;
		if (_dtb_read(mmc, blk, cnt, addr)) {
			dtb_err("%s: dev # %d, block # %#llx,cnt # %#llx ERROR!\n",
					__func__, dev, blk, cnt);
			ret = -3;
		}
		/*update dtb1*/
		blk = dtb_glb_offset / mmc->read_bl_len;
		if (_dtb_write(mmc, blk, cnt, addr)) {
			dtb_err("%s: dev # %d, block # %#llx,cnt # %#llx ERROR!\n",
					__func__, dev, blk, cnt);
			ret = -3;
		}
		info->stamp[0] = dtb->timestamp;
		ret = 0;
	} else if (stamp_after(info->stamp[0], info->stamp[1])) {
		/*update dtb2*/
		blk = (dtb_glb_offset + vpart->size) / mmc->read_bl_len;
		if (_dtb_write(mmc, blk, cnt, addr)) {
			dtb_err("%s: dev # %d, block # %#llx,cnt # %#llx ERROR!\n",
					__func__, dev, blk, cnt);
			ret = -3;
		}
		info->stamp[1] = dtb->timestamp;
	} else {
		dtb_info("do nothing\n");
	}
	return ret;
}

int dtb_read(void *addr)
{
	int ret = 0;
	int valid = 0;
	struct mmc *mmc;

	mmc = _dtb_init();
	if (mmc == NULL)
		return -10;

	if (dtb_read_shortcut(mmc, addr) == 0)
		return ret;

	valid = update_dtb_info(mmc, addr);
	dtb_info("total valid %d\n", valid);
	/* check valid */
	switch (valid) {
		/* none is valid, using the 1st one for compatibility*/
		case 0:
			ret = -1;
			goto _out;
		break;
		/* only 1 is valid, using the valid one */
		case 1:
			update_invalid_dtb(mmc, addr);
		break;
		/* both are valid, pickup new one. */
		case 2:
			update_old_dtb(mmc, addr);
		break;
		default:
			dtb_err("impossble valid values.\n");
			BUG();
		break;
	}
_out:
	return ret;
}


int dtb_write(void *addr)
{
	int ret = 0;
	struct aml_dtb_rsv * dtb = (struct aml_dtb_rsv *) addr;
	struct aml_dtb_info *info = &dtb_infos;
	u64 blk, cnt, dtb_glb_offset;
	int cpy, valid;
	struct mmc * mmc;
	struct partitions * part = NULL;
	struct virtual_partition *vpart = NULL;
	vpart = aml_get_virtual_partition_by_name(MMC_DTB_NAME);
	part = aml_get_partition_by_name(MMC_RESERVED_NAME);
	dtb_glb_offset = part->offset + vpart->offset;

	mmc = _dtb_init();
	if (NULL == mmc)
		return -10;

	/* stamp */
	valid = info->valid[0] + info->valid[1];
	dtb_info("valid %d\n", valid);
	if (0 == valid)
		dtb->timestamp = 0;
	else if (1 == valid) {
		dtb->timestamp = 1 + info->stamp[info->valid[0]?0:1];
	} else {
		/* both are valid */
		if (info->stamp[0] != info->stamp[1]) {
			dtb_wrn("timestamp are not same %d:%d\n",
				info->stamp[0], info->stamp[1]);
			dtb->timestamp = 1 + stamp_after(info->stamp[1], info->stamp[0])?
				info->stamp[1]:info->stamp[0];
		} else
			dtb->timestamp = 1 + info->stamp[0];
	}
	/*setting version and magic*/
	dtb->version = 1; /* base version */
	dtb->magic = 0x00447e41; /*A~D\0*/
	dtb->checksum = _calc_dtb_checksum(dtb);
	dtb_info("new stamp %d, checksum 0x%x, version %d, magic %s\n",
		dtb->timestamp, dtb->checksum, dtb->version, (char *)&dtb->magic);

	for (cpy = 0; cpy < DTB_COPIES; cpy++) {
		blk = (dtb_glb_offset + cpy * (vpart->size)) / mmc->read_bl_len;
		cnt = vpart->size / mmc->read_bl_len;
		ret |= _dtb_write(mmc, blk, cnt, addr);
		info->valid[cpy] = 1;
		info->stamp[cpy] = dtb->timestamp;
	}

	return ret;
}

extern int check_valid_dts(unsigned char *buffer);
int renew_partition_tbl(unsigned char *buffer)
{
	int ret = 0;
	unsigned char *temp = NULL;

	if (!buffer)
		return 1;
	temp = malloc (AML_DTB_IMG_MAX_SZ);
	if (!temp)
		return 1;
	memcpy(temp, buffer, AML_DTB_IMG_MAX_SZ);
	/* todo, check new dts imcoming.... */
	ret = check_valid_dts(temp);
	free(temp);

	/* only the dts new is valid */
	if (!ret) {
		free_partitions();
		get_partition_from_dts(buffer);
		if (0 == mmc_device_init(_dtb_init())) {
			printf("partition table success\n");
			ret = 0;
			goto _out;
		}
		printf("partition table error\n");
		ret = 1;
	}

_out:
	return ret;
}

int do_amlmmc_dtb_key(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	int dev, ret = 0;
	void *addr = NULL;
	u64 cnt = 0, n = 0, blk = 0;
	//u64 size;
	struct partitions *part = NULL;
	struct virtual_partition *vpart = NULL;
	vpart = aml_get_virtual_partition_by_name(MMC_DTB_NAME);
	part = aml_get_partition_by_name(MMC_RESERVED_NAME);

	switch (argc) {
		case 3:
			if (strcmp(argv[1], "erase") == 0) {
				if (strcmp(argv[2], "dtb") == 0) {
					printf("start erase dtb......\n");
					dev = EMMC_DTB_DEV;
					struct mmc *mmc = find_mmc_device(dev);
					if (!mmc) {
						printf("not find mmc\n");
						return 1;
					}
					blk = (part->offset + vpart->offset) / mmc->read_bl_len;
					cnt = (vpart->size * 2) / mmc->read_bl_len;
					if (cnt != 0)
						n = mmc->block_dev.block_erase(dev, blk, cnt);
					printf("dev # %d, %s, several blocks erased %s\n",
							dev, (flag == 0) ? " ":(argv[2]),(n == 0) ? "OK" : "ERROR");
					return (n == 0) ? 0 : 1;
				}else if (strcmp(argv[2], "key") == 0){
					printf("start erase key......\n");
					dev = 1;
					struct mmc *mmc = find_mmc_device(dev);
					if (!mmc) {
						printf("not find mmc\n");
						return 1;
					}
					n = mmc_key_erase();
					printf("dev # %d, %s, several blocks erased %s\n",
							dev, (flag == 0) ? " ":(argv[2]),(n == 0) ? "OK" : "ERROR");
					return (n == 0) ? 0 : 1;
				}
			} else if (strcmp(argv[1], "cali_pattern") == 0) {

				if (strcmp(argv[2], "write") == 0) {
					dev = EMMC_DTB_DEV;
					struct mmc *mmc = find_mmc_device(dev);
					if (!mmc) {
						printf("not find mmc\n");
						return 1;
					}
					vpart = aml_get_virtual_partition_by_name(MMC_PATTERN_NAME);
					part = aml_get_partition_by_name(MMC_RESERVED_NAME);
					addr = (void *)malloc(vpart->size);
					if (addr == NULL) {
						printf("cali_pattern malloc fail\n");
						return 1;
					}
					mmc_write_cali_mattern(addr);
					blk = (part->offset + vpart->offset) / mmc->read_bl_len;
					cnt = vpart->size / mmc->read_bl_len;
					if (cnt != 0)
						n = mmc->block_dev.block_write(dev, blk, cnt, addr);
					printf("dev # %d, %s, several calibration pattern blocks write %s\n",
							dev, (flag == 0) ? " ":(argv[2]),(n == cnt) ? "OK" : "ERROR");
					free(addr);
					return (n == cnt) ? 0 : 1;
				}
			}
		case 4:
			addr = (void *)simple_strtoul(argv[2], NULL, 16);
			if (strcmp(argv[1], "dtb_read") == 0) {
				/* fixme, */
				ret = dtb_read(addr);
				return 0;

			} else if (strcmp(argv[1], "dtb_write") == 0) {
				/* fixme, should we check the return value? */
				ret = dtb_write(addr);
				ret |= renew_partition_tbl(addr);
				return ret;
			}
			return 0;
		default:
			break;
	}
	return 1;
}

/* update partition table in reserved partition. */
__weak int emmc_update_ept(unsigned char *buffer)
{
	int ret = 0;

#ifndef DTB_BIND_KERNEL
	dtb_write(buffer);
#endif
	ret = renew_partition_tbl(buffer);
	return ret;
}

/* fixme, should use renew_partition_tbl here! */
__weak int emmc_update_mbr(unsigned char *buffer)
{
	int ret = 0;
	cpu_id_t cpu_id = get_cpu_id();

	if (cpu_id.family_id < MESON_CPU_MAJOR_ID_GXL) {
		ret = -1;
		printf("MBR not support, try dtb\n");
		goto _out;
	}
#ifndef DTB_BIND_KERNEL
	dtb_write(buffer);
#endif
	ret = get_partition_from_dts(buffer);
	if (ret) {
		printf("Fail to get partition talbe from dts\n");
		goto _out;
	}
	ret = mmc_device_init(_dtb_init());
	printf("%s: update mbr %s\n", __func__, ret?"Fail":"Success");
_out:
	return ret;
}

int do_emmc_erase(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	int dev;
	u64 cnt = 0, n = 0, blk = 0;
	//u64 size;
	struct partitions *part = NULL;
	struct virtual_partition *vpart = NULL;
	struct mmc *mmc;
	if (argc != 3)
		return CMD_RET_USAGE;

	vpart = aml_get_virtual_partition_by_name(MMC_DTB_NAME);
	part = aml_get_partition_by_name(MMC_RESERVED_NAME);
	if (strcmp(argv[2], "dtb") == 0) {
		printf("start erase dtb......\n");
		dev = EMMC_DTB_DEV;
		mmc = find_mmc_device(dev);
		if (!mmc) {
			printf("not find mmc\n");
			return 1;
		}
		blk = (part->offset + vpart->offset) / mmc->read_bl_len;
		cnt = (vpart->size * 2) / mmc->read_bl_len;
		if (cnt != 0)
			n = mmc->block_dev.block_erase(dev, blk, cnt);
		printf("dev # %d, %s, several blocks erased %s\n",
				dev, (flag == 0) ? " ":(argv[2]),(n == 0) ? "OK" : "ERROR");
		return (n == 0) ? 0 : 1;
	} else if (strcmp(argv[2], "key") == 0) {
		printf("start erase key......\n");
		dev = 1;
		mmc = find_mmc_device(dev);
		if (!mmc) {
			printf("not find mmc\n");
			return 1;
		}
		n = mmc_key_erase();
		printf("dev # %d, %s, several blocks erased %s\n",
				dev, (flag == 0) ? " ":(argv[2]),(n == 0) ? "OK" : "ERROR");
		return (n == 0) ? 0 : 1;
	}
	return 1;
}

int do_emmc_dtb_read(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	int ret = 0;
	void *addr = NULL;

	if (argc != 4)
		return CMD_RET_USAGE;

	addr = (void *)simple_strtoul(argv[2], NULL, 16);
	ret = dtb_read(addr);
	return ret;
}

int do_emmc_dtb_write(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	int ret = 0;
	void *addr = NULL;

	if (argc != 4)
		return CMD_RET_USAGE;

	addr = (void *)simple_strtoul(argv[2], NULL, 16);
	ret = dtb_write(addr);
	ret |= renew_partition_tbl(addr);
	return ret;
}

static int _fastboot_context_read(struct mmc *mmc, u64 blk,
		u64 cnt, void *addr)
{
	int dev = EMMC_FASTBOOT_CONTEXT_DEV;
	u64 n;

	n = mmc->block_dev.block_read(dev, blk, cnt, addr);
	if (n != cnt) {
		fb_err("%s: dev # %d, block # %#llx, count # %#llx ERROR!\n",
			__func__, dev, blk, cnt);
	}

	return n != cnt;
}

int fastboot_context_read(void *buf, size_t size)
{
	uint32_t crc_result;
	struct mmc *mmc;
	struct FastbootContext *fb_cont;
	int fb_size = sizeof(struct FastbootContext);
	u64 blk, cnt, fb_glb_offset;
	int dev = EMMC_FASTBOOT_CONTEXT_DEV;
	struct partitions *part = NULL;
	struct virtual_partition *vpart = NULL;

	mmc = find_mmc_device(dev);
	if (!mmc) {
		puts("no mmc devices available\n");
		return 1;
	}

	if (mmc_init(mmc)) {
		printf("%s() %d: emmc init failed\n", __func__, __LINE__);
		return 1;
	}

	vpart = aml_get_virtual_partition_by_name(MMC_FASTBOOT_CONTEXT_NAME);
	part = aml_get_partition_by_name(MMC_RESERVED_NAME);
	fb_glb_offset = part->offset + vpart->offset;

	blk = fb_glb_offset / mmc->read_bl_len;
	cnt = size / mmc->read_bl_len;

	if (_fastboot_context_read(mmc, blk, cnt, buf))
		return 1;

	fb_cont = (struct FastbootContext *)buf;
	crc_result = crc32(0, buf, fb_size - 4);

	if (crc_result != fb_cont->crc32) {
		printf("%s %d: crc checksum ERROR!\n", __func__, __LINE__);
		return 1;
	}
	return 0;
}


int do_emmc_fb_read(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	int ret = 0;
	void *addr = NULL;
	u64 size;

	if (argc != 4)
		return CMD_RET_USAGE;

	addr = (void *)simple_strtoul(argv[2], NULL, 16);
	size = simple_strtoull(argv[3], NULL, 16);
	ret = fastboot_context_read(addr, size);
	return ret;
}

static int _fastboot_context_write(struct mmc *mmc, u64 blk,
		u64 cnt, void *addr)
{
	int dev = EMMC_FASTBOOT_CONTEXT_DEV;
	int n;

	n = mmc->block_dev.block_write(dev, blk, cnt, addr);

	if (n != cnt) {
		fb_err("%s: dev # %d, block # %#llx,cnt # %#llx ERROR!\n",
			__func__, dev, blk, cnt);
	}

	return n != cnt;
}

int fastboot_context_write(void *buf, size_t size)
{
	int ret = 0;
	struct FastbootContext *fb_cont = (struct FastbootContext *)buf;
	u64 blk, cnt, fb_glb_offset;
	struct mmc *mmc;
	struct partitions *part = NULL;
	struct virtual_partition *vpart = NULL;
	int dev = EMMC_FASTBOOT_CONTEXT_DEV;
	int fb_size = sizeof(struct FastbootContext);

	mmc = find_mmc_device(dev);
	if (!mmc) {
		puts("no mmc devices available\n");
		return 1;
	}

	ret = mmc_init(mmc);
	if (ret) {
		printf("%s() %d: emmc init failed\n", __func__, __LINE__);
		return 1;
	}

	vpart = aml_get_virtual_partition_by_name(MMC_FASTBOOT_CONTEXT_NAME);
	part = aml_get_partition_by_name(MMC_RESERVED_NAME);
	fb_glb_offset = part->offset + vpart->offset;
	fb_cont->crc32 = crc32(0, buf, fb_size - 4);
	blk = fb_glb_offset / mmc->read_bl_len;
	cnt = size / mmc->read_bl_len;
	ret = _fastboot_context_write(mmc, blk, cnt, buf);

	return ret;
}

int do_emmc_fb_write(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	int ret = 0;
	void *addr = NULL;
	u64 size;

	if (argc != 4)
		return CMD_RET_USAGE;

	addr = (void *)simple_strtoul(argv[2], NULL, 16);
	size = simple_strtoull(argv[3], NULL, 16);
	ret = fastboot_context_write(addr, size);
	return ret;
}


static cmd_tbl_t cmd_emmc[] = {
	U_BOOT_CMD_MKENT(dtb_read,  4, 0, do_emmc_dtb_read,  "", ""),
	U_BOOT_CMD_MKENT(dtb_write, 4, 0, do_emmc_dtb_write, "", ""),
	U_BOOT_CMD_MKENT(erase,     3, 0, do_emmc_erase,     "", ""),
	U_BOOT_CMD_MKENT(fastboot_read, 4, 0, do_emmc_fb_read, "", ""),
	U_BOOT_CMD_MKENT(fastboot_write, 4, 0, do_emmc_fb_write, "", ""),
};

static int do_emmc_dtb_key(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	cmd_tbl_t *cp;

	cp = find_cmd_tbl(argv[1], cmd_emmc, ARRAY_SIZE(cmd_emmc));

	if (cp == NULL || argc > cp->maxargs)
		return CMD_RET_USAGE;
	if (flag == CMD_FLAG_REPEAT && !cp->repeatable)
		return CMD_RET_SUCCESS;
	return cp->cmd(cmdtp, flag, argc, argv);
}


U_BOOT_CMD(
	emmc, 4, 1, do_emmc_dtb_key,
	"EMMC sub system",
	"dtb_read addr size\n"
	"emmc dtb_write addr size\n"
	"emmc erase dtb\n"
	"emmc erase key\n"
	"emmc fastboot_read addr size\n"
	"emmc fastboot_write addr size\n");

