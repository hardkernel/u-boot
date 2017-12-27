/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <bootm.h>
#include <linux/list.h>
#include <libfdt.h>
#include <malloc.h>
#include <asm/arch/resource_img.h>
#include <asm/arch/rockchip_crc.h>
#include <boot_rkimg.h>

#define TAG_KERNEL			0x4C4E524B

#define DTB_FILE			"rk-kernel.dtb"

#define BOOTLOADER_MESSAGE_OFFSET_IN_MISC	(16 * 1024)
#define BOOTLOADER_MESSAGE_BLK_OFFSET		(BOOTLOADER_MESSAGE_OFFSET_IN_MISC >> 9)

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
	ulong		mem_start;
	phys_size_t	mem_size;

	lmb_init(&images->lmb);

	mem_start = env_get_bootm_low();
	mem_size = env_get_bootm_size();

	lmb_add(&images->lmb, (phys_addr_t)mem_start, mem_size);

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
 * non-OTA packaged kernel.img & boot.img
 * return the image size on success, and a
 * negative value on error.
 */
static int read_rockchip_image(struct blk_desc *dev_desc,
			       disk_partition_t *part_info,
			       void *dst)
{
	struct rockchip_image *img;
	int header_len = 8;
	int cnt;
	int ret;
#ifdef CONFIG_ROCKCHIP_CRC
	u32 crc32;
#endif

	img = memalign(ARCH_DMA_MINALIGN, RK_BLK_SIZE);
	if (!img) {
		printf("out of memory\n");
		return -ENOMEM;
	}

	/* read first block with header imformation */
	ret = blk_dread(dev_desc, part_info->start, 1, img);
	if (ret < 0)
		goto err;
	if (img->tag != TAG_KERNEL) {
		printf("%s: invalid image tag(0x%x)\n", part_info->name, img->tag);
		ret = -EINVAL;
		goto err;
	}

	memcpy(dst, img->image, RK_BLK_SIZE - header_len);
	/*
	 * read the rest blks
	 * total size  = image size + 8 bytes header + 4 bytes crc32
	 */
	cnt = DIV_ROUND_UP(img->size + 8 + 4, RK_BLK_SIZE);
	ret = blk_dread(dev_desc, part_info->start + 1, cnt - 1,
			dst + RK_BLK_SIZE - header_len);
	if (!ret)
		ret = img->size;

#ifdef CONFIG_ROCKCHIP_CRC
	printf("%s image CRC32 verify... ", part_info->name);
	crc32 = rockchip_crc_verify((unsigned char *)(unsigned long)dst,
				  img->size + 4);
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
	int type = 0;

	#ifdef CONFIG_EMMC_BOOT
		type = IF_TYPE_MMC;
	#endif /* CONFIG_EMMC_BOOT */
	#ifdef CONFIG_QSPI_BOOT
		type = IF_TYPE_SPI_NAND;
	#endif /* CONFIG_QSPI_BOOT */
	#ifdef CONFIG_NAND_BOOT
		type = IF_TYPE_RKNAND;
	#endif /* CONFIG_NAND_BOOT */
	#ifdef CONFIG_NOR_BOOT
		type = IF_TYPE_SPI_NOR;
	#endif /* CONFIG_NOR_BOOT */

	/* For current use(Only EMMC support!) */
	if (!type)
		type = IF_TYPE_MMC;

	return type;
}

struct blk_desc *rockchip_get_bootdev(void)
{
	struct blk_desc *dev_desc;
	int dev_type;

	dev_type = get_bootdev_type();
	dev_desc = blk_get_devnum_by_type(dev_type, 0);

	return dev_desc;
}

static int boot_mode = -1;
int rockchip_get_boot_mode(void)
{
	struct blk_desc *dev_desc;
	disk_partition_t part_info;
	struct bootloader_message *bmsg;
	int size = DIV_ROUND_UP(sizeof(struct bootloader_message), RK_BLK_SIZE)
		   * RK_BLK_SIZE;
	int ret;

	if (boot_mode != -1)
		return boot_mode;

	dev_desc = rockchip_get_bootdev();
	ret = part_get_info_by_name(dev_desc, PART_MISC,
			&part_info);
	if (ret < 0)
		printf("get part %s fail %d\n", PART_MISC, ret);

	bmsg = memalign(ARCH_DMA_MINALIGN, size);
	ret = blk_dread(dev_desc,
			part_info.start + BOOTLOADER_MESSAGE_BLK_OFFSET,
			size >> 9, bmsg);
	if (ret < 0)
		goto err;

	if (!strcmp(bmsg->command, "boot-recovery")) {
		printf("boot mode: recovery\n");
		ret = BOOT_MODE_RECOVERY;
	} else {
		printf("boot mode: normal\n");
		ret = BOOT_MODE_NORMAL;
	}
	boot_mode = ret;
err:
	free(bmsg);

	return ret;
}

int boot_rockchip_image(struct blk_desc *dev_desc, disk_partition_t *boot_part)
{
	ulong fdt_addr_r = env_get_ulong("fdt_addr_r", 16, 0);
	ulong ramdisk_addr_r = env_get_ulong("ramdisk_addr_r", 16, 0);
	ulong kernel_addr_r = env_get_ulong("kernel_addr_r", 16, 0x480000);
	disk_partition_t kernel_part;
	ulong ramdisk_size;
	ulong kernel_size;
	ulong fdt_size;
	int ret = 0;
	int part_num;

	printf("=Booting Rockchip format image=\n");
	part_num = part_get_info_by_name(dev_desc, PART_KERNEL,
					 &kernel_part);

	if (part_num < 0 || !boot_part) {
		printf("%s krenel or boot part info error\n", __func__);
		ret = -EINVAL;
		goto out;
	}

	kernel_size = read_rockchip_image(dev_desc, &kernel_part,
					  (void *)kernel_addr_r);
	if (kernel_size < 0) {
		printf("%s krenel part read error\n", __func__);
		ret = -EINVAL;
		goto out;
	}

	ramdisk_size = read_rockchip_image(dev_desc, boot_part,
					   (void *)ramdisk_addr_r);
	if (ramdisk_size < 0) {
		printf("%s ramdisk part read error\n", __func__);
		ret = -EINVAL;
		goto out;
	}

	fdt_size = rockchip_read_resource_file((void *)fdt_addr_r, DTB_FILE, 0, 0);
	if (fdt_size < 0) {
		printf("%s fdt read error\n", __func__);
		ret = -EINVAL;
		goto out;
	}

	printf("kernel   @ 0x%08lx (0x%08lx)\n", kernel_addr_r, kernel_size);
	printf("ramdisk  @ 0x%08lx (0x%08lx)\n", ramdisk_addr_r, ramdisk_size);
#if defined(CONFIG_ARM64)
	char cmdbuf[64];
	sprintf(cmdbuf, "booti 0x%lx 0x%lx:0x%lx 0x%lx",
		kernel_addr_r, ramdisk_addr_r, ramdisk_size, fdt_addr_r);
	run_command(cmdbuf, 0);
#else
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
