/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <bidram.h>
#include <bootm.h>
#include <boot_rkimg.h>
#include <console.h>
#include <malloc.h>
#include <mmc.h>
#include <part.h>
#include <sysmem.h>
#include <asm/io.h>
#include <linux/libfdt.h>
#include <asm/arch/hotkey.h>
#include <asm/arch/resource_img.h>
#include <asm/arch/rockchip_crc.h>
#include <asm/arch/boot_mode.h>

#define TAG_KERNEL				0x4C4E524B
#define DTB_FILE				"rk-kernel.dtb"
#define BOOTLOADER_MESSAGE_OFFSET_IN_MISC	(16 * 1024)
#define BOOTLOADER_MESSAGE_BLK_OFFSET		(BOOTLOADER_MESSAGE_OFFSET_IN_MISC >> 9)

DECLARE_GLOBAL_DATA_PTR;

struct bootloader_message {
	char command[32];
	char status[32];
	char recovery[768];

	/*
	 * The 'recovery' field used to be 1024 bytes.  It has only ever
	 * been used to store the recovery command line, so 768 bytes
	 * should be plenty.  We carve off the last 256 bytes to store the
	 * stage string (for multistage packages) and possible future
	 * expansion.
	 */
	char stage[32];
	char slot_suffix[32];
	char reserved[192];
};

struct rockchip_image {
	uint32_t tag;
	uint32_t size;
	int8_t image[1];
	uint32_t crc;
};

#if !defined(CONFIG_ARM64)
#ifdef CONFIG_LMB
static void boot_start_lmb(bootm_headers_t *images)
{
	lmb_init(&images->lmb);
#ifdef CONFIG_NR_DRAM_BANKS
	int i;

	for (i = 0; i < CONFIG_NR_DRAM_BANKS; i++) {
		lmb_add(&images->lmb, gd->bd->bi_dram[i].start,
			gd->bd->bi_dram[i].size);
	}
#else
	ulong		mem_start;
	phys_size_t	mem_size;

	mem_start = env_get_bootm_low();
	mem_size = env_get_bootm_size();
	lmb_add(&images->lmb, (phys_addr_t)mem_start, mem_size);
#endif
	arch_lmb_reserve(&images->lmb);
	board_lmb_reserve(&images->lmb);
}
#else
static inline void boot_start_lmb(bootm_headers_t *images) { }
#endif

static void boot_lmb_init(bootm_headers_t *images)
{
	boot_start_lmb(images);
	images->state = BOOTM_STATE_OS_GO;
}
#endif

/*
 * non-OTA packaged kernel.img & boot.img return the image size on success,
 * and a negative value on error.
 */
int read_rockchip_image(struct blk_desc *dev_desc,
			disk_partition_t *part_info, void *dst)
{
	struct rockchip_image *img;
	int header_len = 8;
	int cnt, ret;
#ifdef CONFIG_ROCKCHIP_CRC
	u32 crc32;
#endif

	img = memalign(ARCH_DMA_MINALIGN, RK_BLK_SIZE);
	if (!img)
		return -ENOMEM;

	/* read first block with header imformation */
	ret = blk_dread(dev_desc, part_info->start, 1, img);
	if (ret != 1) {
		ret = -EIO;
		goto err;
	}

	if (img->tag != TAG_KERNEL) {
		printf("Invalid %s image tag(0x%x)\n",
		       part_info->name, img->tag);
		ret = -EINVAL;
		goto err;
	}

	/*
	 * read the rest blks
	 * total size = image size + 8 bytes header + 4 bytes crc32
	 */
	cnt = DIV_ROUND_UP(img->size + 8 + 4, RK_BLK_SIZE);
	if (!sysmem_alloc_base_by_name((const char *)part_info->name,
				       (phys_addr_t)dst,
				       cnt * dev_desc->blksz)) {
		ret = -ENXIO;
		goto err;
	}

	memcpy(dst, img->image, RK_BLK_SIZE - header_len);
	ret = blk_dread(dev_desc, part_info->start + 1, cnt - 1,
			dst + RK_BLK_SIZE - header_len);
	if (ret != (cnt - 1)) {
		printf("Read %s part failed, ret=%d\n", part_info->name, ret);
		ret = -EIO;
	} else {
		ret = img->size;
	}

#ifdef CONFIG_ROCKCHIP_CRC
	printf("%s image CRC32 verify... ", part_info->name);
	crc32 = rockchip_crc_verify((uchar *)(unsigned long)dst, img->size + 4);
	if (!crc32) {
		printf("fail!\n");
		ret = -EINVAL;
	} else {
		printf("okay.\n");
	}
#endif

err:
	free(img);
	return ret;
}

/* Gets the storage type of the current device */
int get_bootdev_type(void)
{
	char *boot_media = NULL, *devtype = NULL;
	char boot_options[128] = {0};
	static int appended;
	ulong devnum = 0;
	int type = 0;

	devtype = env_get("devtype");
	devnum = env_get_ulong("devnum", 10, 0);

	/* For current use(Only EMMC support!) */
	if (!devtype) {
		devtype = "mmc";
		printf("Use emmc as default boot media\n");
	}

	if (!strcmp(devtype, "mmc")) {
		type = IF_TYPE_MMC;
		if (devnum == 1)
			boot_media = "sd";
		else
			boot_media = "emmc";
	} else if (!strcmp(devtype, "rknand")) {
		type = IF_TYPE_RKNAND;
		boot_media = "nand";
	} else if (!strcmp(devtype, "spinand")) {
		type = IF_TYPE_SPINAND;
		boot_media = "nand"; /* kernel treat sfc nand as nand device */
	} else if (!strcmp(devtype, "spinor")) {
		type = IF_TYPE_SPINOR;
		boot_media = "nor";
	} else if (!strcmp(devtype, "ramdisk")) {
		type = IF_TYPE_RAMDISK;
		boot_media = "ramdisk";
	} else if (!strcmp(devtype, "mtd")) {
		type = IF_TYPE_MTD;
		boot_media = "mtd";
	} else {
		/* Add new to support */
	}

	if (!appended && boot_media) {
		appended = 1;

	/*
	 * The legacy rockchip Android (SDK < 8.1) requires "androidboot.mode="
	 * to be "charger" or boot media which is a rockchip private solution.
	 *
	 * The official Android rule (SDK >= 8.1) is:
	 * "androidboot.mode=normal" or "androidboot.mode=charger".
	 *
	 * Now that this U-Boot is usually working with higher version
	 * Android (SDK >= 8.1), we follow the official rules.
	 *
	 * Common: androidboot.mode=charger has higher priority, don't override;
	 */
#ifdef CONFIG_RKIMG_ANDROID_BOOTMODE_LEGACY
		/* rknand doesn't need "androidboot.mode="; */
		if (env_exist("bootargs", "androidboot.mode=charger") ||
		    (type == IF_TYPE_RKNAND) ||
		    (type == IF_TYPE_SPINAND) ||
		    (type == IF_TYPE_SPINOR))
			snprintf(boot_options, sizeof(boot_options),
				 "storagemedia=%s", boot_media);
		else
			snprintf(boot_options, sizeof(boot_options),
				 "storagemedia=%s androidboot.mode=%s",
				 boot_media, boot_media);
#else
		/*
		 * 1. "storagemedia": This is a legacy variable to indicate board
		 *    storage media for kernel and android.
		 *
		 * 2. "androidboot.storagemedia": The same purpose as "storagemedia",
		 *    but the android framework will auto create property by
		 *    variable with format "androidboot.xxx", eg:
		 *
		 *    "androidboot.storagemedia" => "ro.boot.storagemedia".
		 *
		 *    So, U-Boot pass this new variable is only for the convenience
		 *    to Android.
		 */
		if (env_exist("bootargs", "androidboot.mode=charger"))
			snprintf(boot_options, sizeof(boot_options),
				 "storagemedia=%s androidboot.storagemedia=%s",
				 boot_media, boot_media);
		else
			snprintf(boot_options, sizeof(boot_options),
				 "storagemedia=%s androidboot.storagemedia=%s "
				 "androidboot.mode=normal ",
				 boot_media, boot_media);
#endif
		env_update("bootargs", boot_options);
	}

	return type;
}

static struct blk_desc *dev_desc;

void rockchip_set_bootdev(struct blk_desc *desc)
{
	dev_desc = desc;
}

struct blk_desc *rockchip_get_bootdev(void)
{
	int dev_type;
	int devnum;

	if (dev_desc)
		return dev_desc;

	boot_devtype_init();
	dev_type = get_bootdev_type();
	devnum = env_get_ulong("devnum", 10, 0);

	dev_desc = blk_get_devnum_by_type(dev_type, devnum);
	if (!dev_desc) {
		printf("%s: Can't find dev_desc!\n", __func__);
		return NULL;
	}

#ifdef CONFIG_MMC
	if (dev_type == IF_TYPE_MMC) {
		struct mmc *mmc;
		const char *timing[] = {
			"Legacy", "High Speed", "High Speed", "SDR12",
			"SDR25", "SDR50", "SDR104", "DDR50",
			"DDR52", "HS200", "HS400", "HS400 Enhanced Strobe"};

		mmc = find_mmc_device(devnum);
		printf("MMC%d: %s, %dMhz\n", devnum,
		       timing[mmc->timing], mmc->clock / 1000000);
	}
#endif

	printf("PartType: %s\n", part_get_type(dev_desc));

	return dev_desc;
}

static int boot_mode = -1;

static void rkloader_set_bootloader_msg(struct bootloader_message *bmsg)
{
	struct blk_desc *dev_desc;
	disk_partition_t part_info;
	int ret, cnt;

	dev_desc = rockchip_get_bootdev();
	if (!dev_desc) {
		printf("%s: dev_desc is NULL!\n", __func__);
		return;
	}

	ret = part_get_info_by_name(dev_desc, PART_MISC, &part_info);
	if (ret < 0) {
		printf("%s: Could not found misc partition\n", __func__);
		return;
	}

	cnt = DIV_ROUND_UP(sizeof(struct bootloader_message), dev_desc->blksz);
	ret = blk_dwrite(dev_desc,
			 part_info.start + BOOTLOADER_MESSAGE_BLK_OFFSET,
			 cnt, bmsg);
	if (ret != cnt)
		printf("%s: Wipe data failed\n", __func__);
}

void board_run_recovery(void)
{
	run_command("bootrkp boot-recovery", 0);
}

void board_run_recovery_wipe_data(void)
{
	struct bootloader_message bmsg;
	struct blk_desc *dev_desc;
	disk_partition_t part_info;
	int ret;

	printf("Rebooting into recovery to do wipe_data\n");
	dev_desc = rockchip_get_bootdev();
	if (!dev_desc) {
		printf("%s: dev_desc is NULL!\n", __func__);
		return;
	}

	ret = part_get_info_by_name(dev_desc, PART_MISC, &part_info);
	if (ret < 0) {
		printf("%s: Could not found misc partition, just run recovery\n",
		       __func__);
		board_run_recovery();
	}

	memset((char *)&bmsg, 0, sizeof(struct bootloader_message));
	strcpy(bmsg.command, "boot-recovery");
	strcpy(bmsg.recovery, "recovery\n--wipe_data");
	bmsg.status[0] = 0;

	rkloader_set_bootloader_msg(&bmsg);

	/* now reboot to recovery */
	board_run_recovery();
}

/*
 * Generally, we have 3 ways to get reboot mode:
 *
 * 1. from bootloader_message which is defined in MISC partition;
 * 2. from CONFIG_ROCKCHIP_BOOT_MODE_REG which supports "reboot xxx" commands;
 * 3. from env "reboot_mode" which is added by U-Boot code(currently only when
 *    recovery key pressed);
 *
 * 1st and 2nd cases are static determined at system start and we check it once,
 * while 3th case is dynamically added by U-Boot code, so we have to check it
 * everytime.
 *
 * Recovery mode from:
 *	- MISC partition;
 *	- "reboot recovery" command;
 *	- recovery key pressed without usb attach;
 */
int rockchip_get_boot_mode(void)
{
	struct bootloader_message *bmsg = NULL;
	struct blk_desc *dev_desc;
	disk_partition_t part_info;
	uint32_t reg_boot_mode;
	char *env_reboot_mode;
	int clear_boot_reg = 0;
	int ret, cnt;

	/*
	 * Here, we mainly check for:
	 * In rockchip_dnl_mode_check(), that recovery key is pressed without
	 * USB attach will do env_set("reboot_mode", "recovery");
	 */
	env_reboot_mode = env_get("reboot_mode");
	if (env_reboot_mode) {
		if (!strcmp(env_reboot_mode, "recovery-key")) {
			boot_mode = BOOT_MODE_RECOVERY;
			printf("boot mode: recovery (key)\n");
		} else if (!strcmp(env_reboot_mode, "recovery-usb")) {
			boot_mode = BOOT_MODE_RECOVERY;
			printf("boot mode: recovery (usb)\n");
		} else if (!strcmp(env_reboot_mode, "fastboot")) {
			boot_mode = BOOT_MODE_BOOTLOADER;
			printf("boot mode: fastboot\n");
		}
	}

	if (boot_mode != -1)
		return boot_mode;

	dev_desc = rockchip_get_bootdev();
	if (!dev_desc) {
		printf("%s: dev_desc is NULL!\n", __func__);
		return -ENODEV;
	}

	ret = part_get_info_by_name(dev_desc, PART_MISC, &part_info);
	if (ret < 0) {
		printf("%s: Could not found misc partition\n", __func__);
		goto fallback;
	}

	cnt = DIV_ROUND_UP(sizeof(struct bootloader_message), dev_desc->blksz);
	bmsg = memalign(ARCH_DMA_MINALIGN, cnt * dev_desc->blksz);
	ret = blk_dread(dev_desc,
			part_info.start + BOOTLOADER_MESSAGE_BLK_OFFSET,
			cnt, bmsg);
	if (ret != cnt) {
		free(bmsg);
		return -EIO;
	}

fallback:
	/*
	 * Boot mode priority
	 *
	 * Anyway, we should set download boot mode as the highest priority, so:
	 *
	 * reboot loader/bootloader/fastboot > misc partition "recovery" > reboot xxx.
	 */
	reg_boot_mode = readl((void *)CONFIG_ROCKCHIP_BOOT_MODE_REG);
	if (reg_boot_mode == BOOT_LOADER) {
		printf("boot mode: loader\n");
		boot_mode = BOOT_MODE_LOADER;
		clear_boot_reg = 1;
	} else if (reg_boot_mode == BOOT_FASTBOOT) {
		printf("boot mode: bootloader\n");
		boot_mode = BOOT_MODE_BOOTLOADER;
		clear_boot_reg = 1;
	} else if (bmsg && !strcmp(bmsg->command, "boot-recovery")) {
		printf("boot mode: recovery (misc)\n");
		boot_mode = BOOT_MODE_RECOVERY;
		clear_boot_reg = 1;
	} else {
		switch (reg_boot_mode) {
		case BOOT_NORMAL:
			printf("boot mode: normal\n");
			boot_mode = BOOT_MODE_NORMAL;
			clear_boot_reg = 1;
			break;
		case BOOT_RECOVERY:
			printf("boot mode: recovery (cmd)\n");
			boot_mode = BOOT_MODE_RECOVERY;
			clear_boot_reg = 1;
			break;
		case BOOT_UMS:
			printf("boot mode: ums\n");
			boot_mode = BOOT_MODE_UMS;
			clear_boot_reg = 1;
			break;
		case BOOT_CHARGING:
			printf("boot mode: charging\n");
			boot_mode = BOOT_MODE_CHARGING;
			clear_boot_reg = 1;
			break;
		case BOOT_PANIC:
			printf("boot mode: panic\n");
			boot_mode = BOOT_MODE_PANIC;
			break;
		case BOOT_WATCHDOG:
			printf("boot mode: watchdog\n");
			boot_mode = BOOT_MODE_WATCHDOG;
			break;
		default:
			printf("boot mode: None\n");
			boot_mode = BOOT_MODE_UNDEFINE;
		}
	}

	/*
	 * We don't clear boot mode reg when its value stands for the reboot
	 * reason or others(in the future), the kernel will need and clear it.
	 */
	if (clear_boot_reg)
		writel(BOOT_NORMAL, (void *)CONFIG_ROCKCHIP_BOOT_MODE_REG);

	return boot_mode;
}

static void fdt_ramdisk_skip_relocation(void)
{
	char *ramdisk_high = env_get("initrd_high");
	char *fdt_high = env_get("fdt_high");

	if (!fdt_high) {
		env_set_hex("fdt_high", -1UL);
		printf("Fdt ");
	}

	if (!ramdisk_high) {
		env_set_hex("initrd_high", -1UL);
		printf("Ramdisk ");
	}

	if (!fdt_high || !ramdisk_high)
		printf("skip relocation\n");
}

int boot_rockchip_image(struct blk_desc *dev_desc, disk_partition_t *boot_part)
{
	ulong ramdisk_addr_r = env_get_ulong("ramdisk_addr_r", 16, 0);
	ulong kernel_addr_r = env_get_ulong("kernel_addr_r", 16, 0);
	ulong fdt_addr_r = env_get_ulong("fdt_addr_r", 16, 0);
	disk_partition_t kernel_part;
	int ramdisk_size;
	int kernel_size;
	int fdt_size;
	int ret = 0;

	printf("=Booting Rockchip format image=\n");
	ret = part_get_info_by_name(dev_desc, PART_KERNEL, &kernel_part);
	if (ret < 0 || !boot_part) {
		printf("Could not found misc partition\n");
		ret = -EINVAL;
		goto out;
	}

	kernel_size = read_rockchip_image(dev_desc, &kernel_part,
					  (void *)kernel_addr_r);
	if (kernel_size < 0) {
		printf("Read kernel image failed, ret=%d\n", ret);
		ret = -EINVAL;
		goto out;
	}

	ramdisk_size = read_rockchip_image(dev_desc, boot_part,
					   (void *)ramdisk_addr_r);
	if (ramdisk_size < 0) {
		printf("Read ramdisk image failed, ret=%d\n", ret);
		ramdisk_size = 0;
	}

	/*
	 * When it happens ?
	 *
	 * 1. CONFIG_USING_KERNEL_DTB is disabled, so we should load kenrel dtb;
	 *
	 * 2. Even CONFIG_USING_KERNEL_DTB is enabled, if we load kernel dtb
	 *    failed due to some reason before here, and then we fix it and run
	 *    cmd "bootrkp" try to boot system again, we should reload fdt here.
	 */
	if (gd->fdt_blob != (void *)fdt_addr_r) {
		fdt_size = rockchip_read_dtb_file((void *)fdt_addr_r);
		if (fdt_size < 0) {
			printf("Read fdt failed, ret=%d\n", fdt_size);
			ret = -EINVAL;
			goto out;
		}
	}

	printf("fdt	 @ 0x%08lx (0x%08x)\n", fdt_addr_r, fdt_totalsize(fdt_addr_r));
	printf("kernel   @ 0x%08lx (0x%08x)\n", kernel_addr_r, kernel_size);
	printf("ramdisk  @ 0x%08lx (0x%08x)\n", ramdisk_addr_r, ramdisk_size);

	fdt_ramdisk_skip_relocation();
	hotkey_run(HK_SYSMEM);

	/* Check sysmem overflow */
	sysmem_overflow_check();

#if defined(CONFIG_ARM64)
	char cmdbuf[64];

	snprintf(cmdbuf, 64, "booti 0x%lx 0x%lx:0x%x 0x%lx",
		 kernel_addr_r, ramdisk_addr_r, ramdisk_size, fdt_addr_r);
	run_command(cmdbuf, 0);
#else
	/* We asume it's always zImage on 32-bit platform */
	ulong kaddr_c = env_get_ulong("kaddr_c", 16, 0);
	ulong kaddr_r, kaddr, ksize;

	if (kernel_addr_r && !kaddr_c) {
		kaddr_c = kernel_addr_r;
		kaddr_r = CONFIG_SYS_SDRAM_BASE;
	}

	if (!sysmem_free((phys_addr_t)kaddr_c)) {
		kaddr = kaddr_r;
		ksize = kernel_size * 100 / 45 ; /* Ratio: 45% */
		ksize = ALIGN(ksize, dev_desc->blksz);
		if (!sysmem_alloc_base(MEMBLK_ID_UNCOMP_KERNEL,
				       (phys_addr_t)kaddr, ksize))
			return -ENOMEM;
	}

	hotkey_run(HK_SYSMEM);

	/* Check sysmem overflow */
	sysmem_overflow_check();

	boot_lmb_init(&images);
	images.ep = kernel_addr_r;
	images.initrd_start = ramdisk_addr_r;
	images.initrd_end = ramdisk_addr_r + ramdisk_size;
	images.ft_addr = (void *)fdt_addr_r;
	images.ft_len = fdt_totalsize(fdt_addr_r);
	do_bootm_linux(0, 0, NULL, &images);
#endif
out:
	return ret;
}
