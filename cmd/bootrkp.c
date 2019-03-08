/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <malloc.h>
#include <android_bootloader.h>
#include <attestation_key.h>
#include <boot_rkimg.h>
#include <keymaster.h>

#define OEM_UNLOCK_ARG_SIZE 30

static int do_boot_rockchip(cmd_tbl_t *cmdtp, int flag, int argc,
		      char * const argv[])
{
	disk_partition_t part_info;
	struct blk_desc *dev_desc;
	int mode = 0;
	char *boot_partname = PART_BOOT;
	int ret = 0;
	int i = 0;

	dev_desc = rockchip_get_bootdev();
	if (!dev_desc) {
		printf("%s: dev_desc is NULL!\n", __func__);
		return CMD_RET_FAILURE;
	}

#ifdef CONFIG_ANDROID_KEYMASTER_CA
	disk_partition_t misc_part_info;

	/* load attestation key from misc partition. */
	ret = part_get_info_by_name(dev_desc, "misc",
				    &misc_part_info);
	if (ret < 0)
		printf("%s Could not find misc partition\n", __func__);
	else
		load_attestation_key(dev_desc, &misc_part_info);
#endif

#ifdef CONFIG_FASTBOOT_OEM_UNLOCK
	/* read oem unlock status and attach to bootargs */
	uint8_t unlock = 0;
	TEEC_Result result;
	char oem_unlock[OEM_UNLOCK_ARG_SIZE] = {0};
	result = trusty_read_oem_unlock(&unlock);
	if (result) {
		printf("read oem unlock status with error : 0x%x\n", result);
	} else {
		snprintf(oem_unlock, OEM_UNLOCK_ARG_SIZE, "androidboot.oem_unlocked=%d", unlock);
		env_update("bootargs", oem_unlock);
	}
#endif

	mode = rockchip_get_boot_mode();
	if (mode == BOOT_MODE_RECOVERY) {
		boot_partname = PART_RECOVERY;
		printf("%s boot from Recovery partition!\n", __func__);
	}

	for (i = 0; i < argc; i++) {
		if (!strcmp(argv[i], "boot-recovery")) {
			boot_partname = PART_RECOVERY;
			printf("%s argv%d:%s boot from Recovery partition!\n",
				__func__, i, argv[i]);
		}
	}

	ret = part_get_info_by_name(dev_desc, boot_partname, &part_info);

	if(boot_rockchip_image(dev_desc, &part_info))
		ret = CMD_RET_FAILURE;

	return ret;
}

U_BOOT_CMD(
	bootrkp,  CONFIG_SYS_MAXARGS,     1,      do_boot_rockchip,
	"Boot Linux Image from rockchip image type",
	"kernel.img: zImage/Image\n"
	"boot.img: ramdisk\n"
	"resource.img: dtb, u-boot logo, kernel logo"
);

static int do_rkimg_test(cmd_tbl_t *cmdtp, int flag, int argc,
		      char * const argv[])
{
	struct blk_desc *dev_desc;
	u32* buffer;
	int ret = 0;

	dev_desc = blk_get_dev(argv[1], simple_strtoul(argv[2], NULL, 16));

	buffer = memalign(ARCH_DMA_MINALIGN, 1024);
	/* Read one block from begining of IDB data */
	ret = blk_dread(dev_desc, 64, 2, buffer);
	if (ret != 2) {
		printf("%s fail to read data from IDB\n", __func__);
		free(buffer);
		return CMD_RET_FAILURE;
	}

	if (buffer[0] == 0xFCDC8C3B){
		printf("%s found IDB in SDcard\n", __func__);
		ret = CMD_RET_SUCCESS;
		if (0 == buffer[128 + 104 / 4]) /* TAG in IDB */
			env_update("bootargs", "sdfwupdate");
	}

	free(buffer);

	return ret;
}

U_BOOT_CMD(
	rkimgtest, 3, 0,    do_rkimg_test,
	"Test if storage media have rockchip image",
	""
);
