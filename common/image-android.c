/*
 * Copyright (c) 2011 Sebastian Andrzej Siewior <bigeasy@linutronix.de>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <image.h>
#include <android_image.h>
#include <android_bootloader.h>
#include <malloc.h>
#include <mapmem.h>
#include <errno.h>
#include <boot_rkimg.h>
#include <crypto.h>
#include <sysmem.h>
#include <u-boot/sha1.h>
#ifdef CONFIG_RKIMG_BOOTLOADER
#include <asm/arch/resource_img.h>
#endif
#ifdef CONFIG_RK_AVB_LIBAVB_USER
#include <android_avb/avb_slot_verify.h>
#include <android_avb/avb_ops_user.h>
#include <android_avb/rk_avb_ops_user.h>
#endif
#include <optee_include/OpteeClientInterface.h>

DECLARE_GLOBAL_DATA_PTR;

#define ANDROID_IMAGE_DEFAULT_KERNEL_ADDR	0x10008000
#define ANDROID_ARG_FDT_FILENAME "rk-kernel.dtb"
#define ANDROID_Q_VER				10

/* Defined by rockchip legacy mkboot tool(SDK version < 8.1) */
#define ANDROID_ROCKCHIP_LEGACY_PAGE_SIZE	0x4000

static char andr_tmp_str[ANDR_BOOT_ARGS_SIZE + 1];
static u32 android_kernel_comp_type = IH_COMP_NONE;

u32 android_image_major_version(void)
{
	/* MSB 7-bits */
	return gd->bd->bi_andr_version >> 25;
}

u32 android_bcb_msg_sector_offset(void)
{
	/*
	 * Rockchip platforms defines BCB message at the 16KB offset of
	 * misc partition while the Google defines it at 0x0 offset.
	 *
	 * From Android-Q, the 0x0 offset is mandary on Google VTS, so that
	 * this is a compatibility according to android image 'os_version'.
	 */
#ifdef CONFIG_RKIMG_BOOTLOADER
	return (android_image_major_version() >= ANDROID_Q_VER) ? 0x0 : 0x20;
#else
	return 0x0;
#endif
}

static ulong android_image_get_kernel_addr(const struct andr_img_hdr *hdr)
{
	/*
	 * All the Android tools that generate a boot.img use this
	 * address as the default.
	 *
	 * Even though it doesn't really make a lot of sense, and it
	 * might be valid on some platforms, we treat that address as
	 * the default value for this field, and try to execute the
	 * kernel in place in such a case.
	 *
	 * Otherwise, we will return the actual value set by the user.
	 */
	if (hdr->kernel_addr == ANDROID_IMAGE_DEFAULT_KERNEL_ADDR)
		return (ulong)hdr + hdr->page_size;

#ifdef CONFIG_ARCH_ROCKCHIP
	/*
	 * If kernel is compressed, kernel_addr is set as decompressed address
	 * after compressed being loaded to ram, so let's use it.
	 */
	if (android_kernel_comp_type != IH_COMP_NONE &&
	    android_kernel_comp_type != IH_COMP_ZIMAGE)
		return hdr->kernel_addr;

	/*
	 * Compatble with rockchip legacy packing with kernel/ramdisk/second
	 * address base from 0x60000000(SDK versiont < 8.1), these are invalid
	 * address, so we calc it by real size.
	 */
	return (ulong)hdr + hdr->page_size;
#else
	return hdr->kernel_addr;
#endif

}

void android_image_set_comp(struct andr_img_hdr *hdr, u32 comp)
{
	android_kernel_comp_type = comp;
}

u32 android_image_get_comp(const struct andr_img_hdr *hdr)
{
	return android_kernel_comp_type;
}

int android_image_parse_kernel_comp(const struct andr_img_hdr *hdr)
{
	ulong kaddr = android_image_get_kernel_addr(hdr);
	return bootm_parse_comp((const unsigned char *)kaddr);
}

/**
 * android_image_get_kernel() - processes kernel part of Android boot images
 * @hdr:	Pointer to image header, which is at the start
 *			of the image.
 * @verify:	Checksum verification flag. Currently unimplemented.
 * @os_data:	Pointer to a ulong variable, will hold os data start
 *			address.
 * @os_len:	Pointer to a ulong variable, will hold os data length.
 *
 * This function returns the os image's start address and length. Also,
 * it appends the kernel command line to the bootargs env variable.
 *
 * Return: Zero, os start address and length on success,
 *		otherwise on failure.
 */
int android_image_get_kernel(const struct andr_img_hdr *hdr, int verify,
			     ulong *os_data, ulong *os_len)
{
	u32 kernel_addr = android_image_get_kernel_addr(hdr);

	/*
	 * Not all Android tools use the id field for signing the image with
	 * sha1 (or anything) so we don't check it. It is not obvious that the
	 * string is null terminated so we take care of this.
	 */
	strncpy(andr_tmp_str, hdr->name, ANDR_BOOT_NAME_SIZE);
	andr_tmp_str[ANDR_BOOT_NAME_SIZE] = '\0';
	if (strlen(andr_tmp_str))
		printf("Android's image name: %s\n", andr_tmp_str);

	printf("Kernel load addr 0x%08x size %u KiB\n",
	       kernel_addr, DIV_ROUND_UP(hdr->kernel_size, 1024));

	int len = 0;
	if (*hdr->cmdline) {
		debug("Kernel command line: %s\n", hdr->cmdline);
		len += strlen(hdr->cmdline);
	}

	char *bootargs = env_get("bootargs");
	if (bootargs)
		len += strlen(bootargs);

	char *newbootargs = malloc(len + 2);
	if (!newbootargs) {
		puts("Error: malloc in android_image_get_kernel failed!\n");
		return -ENOMEM;
	}
	*newbootargs = '\0';

	if (bootargs) {
		strcpy(newbootargs, bootargs);
		strcat(newbootargs, " ");
	}
	if (*hdr->cmdline)
		strcat(newbootargs, hdr->cmdline);

	env_set("bootargs", newbootargs);

	if (os_data) {
		*os_data = (ulong)hdr;
		*os_data += hdr->page_size;
	}
	if (os_len)
		*os_len = hdr->kernel_size;
	return 0;
}

int android_image_check_header(const struct andr_img_hdr *hdr)
{
	return memcmp(ANDR_BOOT_MAGIC, hdr->magic, ANDR_BOOT_MAGIC_SIZE);
}

ulong android_image_get_end(const struct andr_img_hdr *hdr)
{
	ulong end;
	/*
	 * The header takes a full page, the remaining components are aligned
	 * on page boundary
	 */
	end = (ulong)hdr;
	end += hdr->page_size;
	end += ALIGN(hdr->kernel_size, hdr->page_size);
	end += ALIGN(hdr->ramdisk_size, hdr->page_size);
	end += ALIGN(hdr->second_size, hdr->page_size);

	if (hdr->header_version >= 1)
		end += ALIGN(hdr->recovery_dtbo_size, hdr->page_size);

	return end;
}

u32 android_image_get_ksize(const struct andr_img_hdr *hdr)
{
	return hdr->kernel_size;
}

void android_image_set_kload(struct andr_img_hdr *hdr, u32 load_address)
{
	hdr->kernel_addr = load_address;
}

ulong android_image_get_kload(const struct andr_img_hdr *hdr)
{
	return android_image_get_kernel_addr(hdr);
}

int android_image_get_ramdisk(const struct andr_img_hdr *hdr,
			      ulong *rd_data, ulong *rd_len)
{
	ulong ramdisk_addr_r;

	if (!hdr->ramdisk_size) {
		*rd_data = *rd_len = 0;
		return -1;
	}

	/* Have been loaded by android_image_load_separate() on ramdisk_addr_r */
	ramdisk_addr_r = env_get_ulong("ramdisk_addr_r", 16, 0);
	if (!ramdisk_addr_r) {
		printf("No Found Ramdisk Load Address.\n");
		return -1;
	}

	*rd_data = ramdisk_addr_r;
	*rd_len = hdr->ramdisk_size;

	printf("RAM disk load addr 0x%08lx size %u KiB\n",
	       *rd_data, DIV_ROUND_UP(hdr->ramdisk_size, 1024));

	return 0;
}

int android_image_get_fdt(const struct andr_img_hdr *hdr,
			      ulong *rd_data)
{
	ulong fdt_addr_r;

	if (!hdr->second_size) {
		*rd_data = 0;
		return -1;
	}

	/* Have been loaded by android_image_load_separate() on fdt_addr_r */
	fdt_addr_r = env_get_ulong("fdt_addr_r", 16, 0);
	if (!fdt_addr_r) {
		printf("No Found FDT Load Address.\n");
		return -1;
	}

	*rd_data = fdt_addr_r;

	debug("FDT load addr 0x%08x size %u KiB\n",
	      hdr->second_addr, DIV_ROUND_UP(hdr->second_size, 1024));

	return 0;
}

#ifdef CONFIG_ANDROID_BOOT_IMAGE_HASH
static void print_hash(const char *label, u8 *hash, int len)
{
	int i;

	printf("%s:\n    0x", label ? : "Hash");
	for (i = 0; i < len; i++)
		printf("%02x", hash[i]);
	printf("\n");
}

/*
 * This is only for Non-AVB image, because AVB image is verified by AVB bootflow.
 * The kernel/ramdisk/second address should be the real address in hdr before
 * calling this function.
 *
 * mkbootimg tool always use SHA1 for images.
 */
static int android_image_hash_verify(struct andr_img_hdr *hdr)
{
	u8 hash[20];

#ifdef DEBUG
	android_print_contents(hdr);
#endif

	if (hdr->kernel_addr == ANDROID_IMAGE_DEFAULT_KERNEL_ADDR) {
		printf("No real image address in android hdr\n");
		return -EINVAL;
	}

#ifdef CONFIG_DM_CRYPTO
	struct udevice *dev;
	sha_context ctx;

	dev = crypto_get_device(CRYPTO_SHA1);
	if (!dev) {
		printf("Can't find crypto device for SHA1 capability\n");
		return -ENODEV;
	}

	ctx.algo = CRYPTO_SHA1;
	ctx.length = hdr->kernel_size + sizeof(hdr->kernel_size) +
		     hdr->ramdisk_size + sizeof(hdr->ramdisk_size) +
		     hdr->second_size + sizeof(hdr->second_size);
#ifdef CONFIG_HASH_ROCKCHIP_LEGACY
	ctx.length += sizeof(hdr->tags_addr) + sizeof(hdr->page_size) +
		      sizeof(hdr->unused) + sizeof(hdr->name) +
		      sizeof(hdr->cmdline);
#endif

	crypto_sha_init(dev, &ctx);

	crypto_sha_update(dev, (u32 *)(ulong)hdr->kernel_addr,
			  hdr->kernel_size);
	crypto_sha_update(dev, (u32 *)&hdr->kernel_size,
			  sizeof(hdr->kernel_size));
	crypto_sha_update(dev, (u32 *)(ulong)hdr->ramdisk_addr,
			  hdr->ramdisk_size);
	crypto_sha_update(dev, (u32 *)&hdr->ramdisk_size,
			  sizeof(hdr->ramdisk_size));
	crypto_sha_update(dev, (u32 *)(ulong)hdr->second_addr,
			  hdr->second_size);
	crypto_sha_update(dev, (u32 *)&hdr->second_size,
			  sizeof(hdr->second_size));
#ifdef CONFIG_HASH_ROCKCHIP_LEGACY
	crypto_sha_update(dev, (u32 *)&hdr->tags_addr, sizeof(hdr->tags_addr));
	crypto_sha_update(dev, (u32 *)&hdr->page_size, sizeof(hdr->page_size));
	crypto_sha_update(dev, (u32 *)&hdr->header_version,
			  sizeof(hdr->header_version));
	crypto_sha_update(dev, (u32 *)&hdr->os_version, sizeof(hdr->os_version));
	crypto_sha_update(dev, (u32 *)&hdr->name, sizeof(hdr->name));
	crypto_sha_update(dev, (u32 *)&hdr->cmdline, sizeof(hdr->cmdline));
#endif

	crypto_sha_final(dev, &ctx, hash);

#elif CONFIG_SHA1
	sha1_context ctx;

	sha1_starts(&ctx);
	sha1_update(&ctx, (u8 *)(ulong)hdr->kernel_addr, hdr->kernel_size);
	sha1_update(&ctx, (u8 *)&hdr->kernel_size, sizeof(hdr->kernel_size));
	sha1_update(&ctx, (u8 *)(ulong)hdr->ramdisk_addr, hdr->ramdisk_size);
	sha1_update(&ctx, (u8 *)&hdr->ramdisk_size, sizeof(hdr->ramdisk_size));
	sha1_update(&ctx, (u8 *)(ulong)hdr->second_addr, hdr->second_size);
	sha1_update(&ctx, (u8 *)&hdr->second_size, sizeof(hdr->second_size));
#ifdef CONFIG_HASH_ROCKCHIP_LEGACY
	sha1_update(&ctx, (u8 *)&hdr->tags_addr, sizeof(hdr->tags_addr));
	sha1_update(&ctx, (u8 *)&hdr->page_size, sizeof(hdr->page_size));
	sha1_update(&ctx, (u8 *)&hdr->header_version,
		    sizeof(hdr->header_version));
	sha1_update(&ctx, (u8 *)&hdr->os_version, sizeof(hdr->os_version));
	sha1_update(&ctx, (u8 *)&hdr->name, sizeof(hdr->name));
	sha1_update(&ctx, (u8 *)&hdr->cmdline, sizeof(hdr->cmdline));
#endif

	sha1_finish(&ctx, hash);
#endif	/* CONFIG_SHA1 */

	if (memcmp(hash, hdr->id, 20)) {
		print_hash("SHA1 from image header", (u8 *)hdr->id, 20);
		print_hash("SHA1 real", (u8 *)hash, 20);
		return -EBADFD;
	}

	return 0;
}
#endif

static int android_image_separate(struct andr_img_hdr *hdr,
				  const disk_partition_t *part,
				  void *load_address,
				  void *ram_base)
{
	struct blk_desc *dev_desc = rockchip_get_bootdev();
	ulong ramdisk_addr_r = env_get_ulong("ramdisk_addr_r", 16, 0);
	char *fdt_high = env_get("fdt_high");
	char *ramdisk_high = env_get("initrd_high");
	ulong blk_start, blk_cnt, size;
	ulong start, second_addr_r = 0;
	int ret;

	if (android_image_check_header(hdr)) {
		printf("Bad android image header\n");
		return -EINVAL;
	}

	if (hdr->kernel_size) {
		size = hdr->kernel_size + hdr->page_size;
		blk_cnt = DIV_ROUND_UP(size, dev_desc->blksz);
		if (!sysmem_alloc_base(MEMBLK_ID_KERNEL,
				       (phys_addr_t)load_address,
				       blk_cnt * dev_desc->blksz))
			return -ENXIO;

		if (ram_base) {
			start = (ulong)ram_base;
			memcpy((char *)load_address, (char *)start, size);
		} else {
			blk_start = part->start;
			ret = blk_dread(dev_desc, blk_start,
					blk_cnt, load_address);
			if (ret != blk_cnt) {
				printf("%s: read kernel failed, ret=%d\n",
				      __func__, ret);
				return -1;
			}
		}
	}

	if (hdr->ramdisk_size) {
		size = hdr->page_size + ALIGN(hdr->kernel_size, hdr->page_size);
		blk_cnt = DIV_ROUND_UP(hdr->ramdisk_size, dev_desc->blksz);
		if (!sysmem_alloc_base(MEMBLK_ID_RAMDISK,
				       ramdisk_addr_r,
				       blk_cnt * dev_desc->blksz))
			return -ENXIO;
		if (ram_base) {
			start = (unsigned long)ram_base;
			start += hdr->page_size;
			start += ALIGN(hdr->kernel_size, hdr->page_size);
			memcpy((char *)ramdisk_addr_r,
			       (char *)start, hdr->ramdisk_size);
		} else {
			blk_start = part->start +
				DIV_ROUND_UP(size, dev_desc->blksz);
			ret = blk_dread(dev_desc, blk_start,
					blk_cnt, (void *)ramdisk_addr_r);
			if (ret != blk_cnt) {
				printf("%s: read ramdisk failed, ret=%d\n",
				      __func__, ret);
				return -1;
			}
		}
	}

	/*
	 * Load dtb file by rockchip_read_dtb_file() which support pack
	 * dtb in second position or resource file.
	 */
#ifdef CONFIG_RKIMG_BOOTLOADER
	ulong fdt_addr_r = env_get_ulong("fdt_addr_r", 16, 0);

	if (hdr->second_size && (gd->fdt_blob != (void *)fdt_addr_r)) {
		ulong fdt_size;

		fdt_size = rockchip_read_dtb_file((void *)fdt_addr_r);
		if (fdt_size < 0) {
			printf("%s: read fdt failed\n", __func__);
			return ret;
		}
	}
#endif

#ifdef CONFIG_ANDROID_BOOT_IMAGE_HASH
	if (hdr->second_size) {
		ulong blk_start, blk_cnt;

		/* Just for image data hash calculation */
		second_addr_r = (ulong)malloc(hdr->second_size);
		if (!second_addr_r)
			return -ENOMEM;

		size = hdr->page_size +
		       ALIGN(hdr->kernel_size, hdr->page_size) +
		       ALIGN(hdr->ramdisk_size, hdr->page_size);
		blk_cnt = DIV_ROUND_UP(hdr->second_size, dev_desc->blksz);

		if (ram_base) {
			start = (unsigned long)ram_base;
			start += hdr->page_size;
			start += ALIGN(hdr->kernel_size, hdr->page_size);
			start += ALIGN(hdr->ramdisk_size, hdr->page_size);
			memcpy((char *)second_addr_r,
			       (char *)start, hdr->second_size);
		} else {
			blk_start = part->start +
					DIV_ROUND_UP(size, dev_desc->blksz);
			ret = blk_dread(dev_desc, blk_start, blk_cnt,
					(void *)second_addr_r);
			if (ret != blk_cnt) {
				printf("%s: read second pos failed, ret=%d\n",
				       __func__, ret);
				return -1;
			}
		}
	}
#endif

	/*
	 * Update hdr with real image address.
	 *
	 * kernel_addr depends on load_address can handle both the
	 * compressed and no-compressed kernel position.
	 */
	hdr->kernel_addr = (ulong)load_address + hdr->page_size;
	hdr->second_addr = second_addr_r;
	hdr->ramdisk_addr = ramdisk_addr_r;

	/*
	 * Since images are loaded separate, fdt/ramdisk relocation
	 * can be disabled, it saves boot time.
	 */
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

	return 0;
}

/*
 * 'boot_android' cmd use "kernel_addr_r" as default load address !
 * We update it according to compress type and "kernel_addr_c/r".
 */
int android_image_parse_comp(struct andr_img_hdr *hdr, ulong *load_addr)
{
	ulong kernel_addr_c;
	int comp;

	kernel_addr_c = env_get_ulong("kernel_addr_c", 16, 0);
	comp = android_image_parse_kernel_comp(hdr);

#ifdef CONFIG_ARM64
	/*
	 * On 64-bit kernel, assuming use IMAGE by default.
	 *
	 * kernel_addr_c is for LZ4-IMAGE but maybe not defined.
	 * kernel_addr_r is for IMAGE.
	 */
	if (comp != IH_COMP_NONE) {
		ulong comp_addr;

		if (kernel_addr_c) {
			comp_addr = kernel_addr_c;
		} else {
			printf("Warn: No \"kernel_addr_c\"\n");
			comp_addr = CONFIG_SYS_SDRAM_BASE + 0x2000000;/* 32M */
			env_set_ulong("kernel_addr_c", comp_addr);
		}

		*load_addr = comp_addr - hdr->page_size;
	}
#else
	/*
	 * On 32-bit kernel, assuming use zImage by default.
	 *
	 * kernel_addr_c is for LZ4/zImage but maybe not defined.
	 * kernel_addr_r is for zImage when kernel_addr_c is not defined.
	 * kernel_addr_r is for IMAGE when kernel_addr_c is defined.
	 */
	if (comp == IH_COMP_NONE) {
		if (kernel_addr_c)
			*load_addr = env_get_ulong("kernel_addr_r", 16, 0);
		else
			*load_addr = CONFIG_SYS_SDRAM_BASE + 0x8000;
	} else {
		if (kernel_addr_c)
			*load_addr = kernel_addr_c - hdr->page_size;
	}
#endif

	env_set_ulong("os_comp", comp);
	return comp;
}

void android_image_set_decomp(struct andr_img_hdr *hdr, int comp)
{
	ulong kernel_addr_r;

	/* zImage handles decompress itself */
	if (comp != IH_COMP_NONE && comp != IH_COMP_ZIMAGE) {
		kernel_addr_r = env_get_ulong("kernel_addr_r", 16, 0x02080000);
		android_image_set_kload(hdr, kernel_addr_r);
		android_image_set_comp(hdr, comp);
	} else {
		android_image_set_comp(hdr, IH_COMP_NONE);
	}
}

static int android_image_load_separate(struct andr_img_hdr *hdr,
				       const disk_partition_t *part,
				       void *load_addr)
{
	return android_image_separate(hdr, part, load_addr, NULL);
}

int android_image_memcpy_separate(struct andr_img_hdr *hdr, ulong *load_addr)
{
	ulong comp_addr = *load_addr;
	int comp;

	comp = android_image_parse_comp(hdr, &comp_addr);
	if (android_image_separate(hdr, NULL, (void *)comp_addr, hdr))
		return -1;

	*load_addr = comp_addr;
	android_image_set_decomp((void *)comp_addr, comp);

	return 0;
}

long android_image_load(struct blk_desc *dev_desc,
			const disk_partition_t *part_info,
			unsigned long load_address,
			unsigned long max_size) {
	struct andr_img_hdr *hdr;
	u32 blksz = dev_desc->blksz;
	u32 pszcnt, hdrcnt, kercnt;
	int comp, ret;

	if (max_size < part_info->blksz)
		return -1;

	/*
	 * read Android image header and leave enough space for page_size align
	 * and kernel image header(1 block maybe enough).
	 *
	 * ANDROID_ROCKCHIP_LEGACY_PAGE_SIZE is defined by rockchip legacy
	 * mkboot tool(SDK version < 8.1) and larger than Google defined.
	 *
	 * To compatible this, we malloc enough buffer but only read android
	 * header and kernel image(1 block) from storage(ignore page size).
	 */
	kercnt = 1;
	hdrcnt = DIV_ROUND_UP(sizeof(*hdr), blksz);
	pszcnt = DIV_ROUND_UP(ANDROID_ROCKCHIP_LEGACY_PAGE_SIZE, blksz);

	hdr = memalign(ARCH_DMA_MINALIGN, (hdrcnt + pszcnt + kercnt) * blksz);
	if (!hdr) {
		printf("No memory\n");
		return -1;
	}

	if (blk_dread(dev_desc, part_info->start, hdrcnt, hdr) != hdrcnt) {
		printf("Failed to read image header\n");
		goto fail;
	}

	if (android_image_check_header(hdr) != 0) {
		printf("** Invalid Android Image header **\n");
		goto fail;
	}

	/*
	 * Update and skip pszcnt(hdr is included) according to hdr->page_size,
	 * reading kernel image for compress validation.
	 */
	pszcnt = DIV_ROUND_UP(hdr->page_size, blksz);
	if (blk_dread(dev_desc, part_info->start + pszcnt, kercnt,
		      (void *)((ulong)hdr + hdr->page_size)) != kercnt) {
		printf("Failed to read kernel header\n");
		goto fail;
	}

	load_address -= hdr->page_size;

	/* Let's load kernel now ! */
	comp = android_image_parse_comp(hdr, &load_address);
	ret = android_image_load_separate(hdr, part_info, (void *)load_address);
	if (ret) {
		printf("Failed to load android image\n");
		goto fail;
	}
	android_image_set_decomp((void *)load_address, comp);

	debug("Loading Android Image to 0x%08lx\n", load_address);

	/* Verify image hash */
#ifdef CONFIG_ANDROID_BOOT_IMAGE_HASH
	if (android_image_hash_verify(hdr)) {
		printf("HASH: Image verify failed!\n");
		return -EBADFD;
	}

	printf("HASH: Image verify OK\n");
#endif

	free(hdr);
	return load_address;

fail:
	free(hdr);
	return -1;
}

#if !defined(CONFIG_SPL_BUILD)
/**
 * android_print_contents - prints out the contents of the Android format image
 * @hdr: pointer to the Android format image header
 *
 * android_print_contents() formats a multi line Android image contents
 * description.
 * The routine prints out Android image properties
 *
 * returns:
 *     no returned results
 */
void android_print_contents(const struct andr_img_hdr *hdr)
{
	const char * const p = IMAGE_INDENT_STRING;
	/* os_version = ver << 11 | lvl */
	u32 os_ver = hdr->os_version >> 11;
	u32 os_lvl = hdr->os_version & ((1U << 11) - 1);
	u32 header_version = hdr->header_version;

	printf("%skernel size:      %x\n", p, hdr->kernel_size);
	printf("%skernel address:   %x\n", p, hdr->kernel_addr);
	printf("%sramdisk size:     %x\n", p, hdr->ramdisk_size);
	printf("%sramdisk addrress: %x\n", p, hdr->ramdisk_addr);
	printf("%ssecond size:      %x\n", p, hdr->second_size);
	printf("%ssecond address:   %x\n", p, hdr->second_addr);
	printf("%stags address:     %x\n", p, hdr->tags_addr);
	printf("%spage size:        %x\n", p, hdr->page_size);
	printf("%sheader_version:   %x\n", p, header_version);
	/* ver = A << 14 | B << 7 | C         (7 bits for each of A, B, C)
	 * lvl = ((Y - 2000) & 127) << 4 | M  (7 bits for Y, 4 bits for M) */
	printf("%sos_version:       %x (ver: %u.%u.%u, level: %u.%u)\n",
	       p, hdr->os_version,
	       (os_ver >> 7) & 0x7F, (os_ver >> 14) & 0x7F, os_ver & 0x7F,
	       (os_lvl >> 4) + 2000, os_lvl & 0x0F);
	printf("%sname:             %s\n", p, hdr->name);
	printf("%scmdline:          %s\n", p, hdr->cmdline);

	if (header_version >= 1) {
		printf("%srecovery dtbo size:    %x\n", p, hdr->recovery_dtbo_size);
		printf("%srecovery dtbo offset:  %llx\n", p, hdr->recovery_dtbo_offset);
		printf("%sheader size:           %x\n", p, hdr->header_size);
	}

	if (header_version >= 2) {
		printf("%sdtb size:              %x\n", p, hdr->dtb_size);
		printf("%sdtb addr:              %llx\n", p, hdr->dtb_addr);
	}
}
#endif
