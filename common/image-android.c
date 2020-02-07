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

	if (hdr->header_version >= 2) {
		end += ALIGN(hdr->recovery_dtbo_size, hdr->page_size);
		end += ALIGN(hdr->dtb_size, hdr->page_size);
	} else if (hdr->header_version >= 1) {
		end += ALIGN(hdr->recovery_dtbo_size, hdr->page_size);
	}

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

#if defined(CONFIG_DM_CRYPTO) && defined(CONFIG_ANDROID_BOOT_IMAGE_HASH)
static void print_hash(const char *label, u8 *hash, int len)
{
	int i;

	printf("%s:\n    0x", label ? : "Hash");
	for (i = 0; i < len; i++)
		printf("%02x", hash[i]);
	printf("\n");
}
#endif

typedef enum {
	IMG_KERNEL,
	IMG_RAMDISK,
	IMG_SECOND,
	IMG_RECOVERY_DTBO,
	IMG_RK_DTB,	/* within resource.img in second position */
	IMG_DTB,
	IMG_MAX,
} img_t;

static int image_read(img_t img, struct andr_img_hdr *hdr,
		      ulong blkstart, void *ram_base,
		      struct udevice *crypto)
{
	struct blk_desc *desc = rockchip_get_bootdev();
	__maybe_unused u32 sizesz;
	ulong pgsz = hdr->page_size;
	ulong blksz = desc->blksz;
	ulong blkcnt, blkoff;
	ulong offset = 0;
	ulong datasz;
	void *ramdst;
	int ret = 0;

	switch (img) {
	case IMG_KERNEL:
		offset = 0; /* include a page_size(image header) */
		blkcnt = DIV_ROUND_UP(hdr->kernel_size + pgsz, blksz);
		ramdst = (void *)env_get_ulong("android_addr_r", 16, 0);
		datasz = hdr->kernel_size + pgsz;
		sizesz = sizeof(hdr->kernel_size);
		if (!sysmem_alloc_base(MEM_KERNEL,
				(phys_addr_t)ramdst, blkcnt * blksz))
			return -ENOMEM;
		break;
	case IMG_RAMDISK:
		offset = pgsz + ALIGN(hdr->kernel_size, pgsz);
		blkcnt = DIV_ROUND_UP(hdr->ramdisk_size, blksz);
		ramdst = (void *)env_get_ulong("ramdisk_addr_r", 16, 0);
		datasz = hdr->ramdisk_size;
		sizesz = sizeof(hdr->ramdisk_size);
		if (datasz && !sysmem_alloc_base(MEM_RAMDISK,
				(phys_addr_t)ramdst, blkcnt * blksz))
			return -ENOMEM;
		break;
	case IMG_SECOND:
		offset = pgsz +
			 ALIGN(hdr->kernel_size, pgsz) +
			 ALIGN(hdr->ramdisk_size, pgsz);
		blkcnt = DIV_ROUND_UP(hdr->second_size, blksz);
		datasz = hdr->second_size;
		sizesz = sizeof(hdr->second_size);
		ramdst = malloc(blkcnt * blksz);
		break;
	case IMG_RECOVERY_DTBO:
		offset = pgsz +
			 ALIGN(hdr->kernel_size, pgsz) +
			 ALIGN(hdr->ramdisk_size, pgsz) +
			 ALIGN(hdr->second_size, pgsz);
		blkcnt = DIV_ROUND_UP(hdr->recovery_dtbo_size, blksz);
		datasz = hdr->recovery_dtbo_size;
		sizesz = sizeof(hdr->recovery_dtbo_size);
		ramdst = malloc(blkcnt * blksz);
		break;
	case IMG_DTB:
		offset = pgsz +
			 ALIGN(hdr->kernel_size, pgsz) +
			 ALIGN(hdr->ramdisk_size, pgsz) +
			 ALIGN(hdr->second_size, pgsz) +
			 ALIGN(hdr->recovery_dtbo_size, pgsz);
		blkcnt = DIV_ROUND_UP(hdr->dtb_size, blksz);
		datasz = hdr->dtb_size;
		sizesz = sizeof(hdr->dtb_size);
		ramdst = malloc(blkcnt * blksz);
		break;
	case IMG_RK_DTB:
#ifdef CONFIG_RKIMG_BOOTLOADER
		/* No going further, it handles DTBO, HW-ID, etc */
		ramdst = (void *)env_get_ulong("fdt_addr_r", 16, 0);
		if (gd->fdt_blob != (void *)ramdst)
			ret = rockchip_read_dtb_file(ramdst);
#endif
		return ret < 0 ? ret : 0;
	default:
		return -EINVAL;
	}

	if (!ramdst) {
		printf("No memory for image(%d)\n", img);
		return -ENOMEM;
	}

	if (!blksz || !datasz)
		goto crypto_calc;

	/* load */
	if (ram_base) {
		memcpy(ramdst, (char *)((ulong)ram_base + offset), datasz);
	} else {
		blkoff = DIV_ROUND_UP(offset, blksz);
		ret = blk_dread(desc, blkstart + blkoff, blkcnt, ramdst);
		if (ret != blkcnt) {
			printf("Failed to read img(%d), ret=%d\n", img, ret);
			return -EIO;
		}
	}

crypto_calc:
	/* sha1 */
#ifdef CONFIG_DM_CRYPTO
	if (crypto) {
		if (img == IMG_KERNEL) {
			ramdst += pgsz;
			datasz -= pgsz;
		}

		crypto_sha_update(crypto, (u32 *)ramdst, datasz);
		crypto_sha_update(crypto, (u32 *)&datasz, sizesz);
	}
#endif

	return 0;
}

static int android_image_separate(struct andr_img_hdr *hdr,
				  const disk_partition_t *part,
				  void *load_address,
				  void *ram_base)
{
	ulong bstart;

	if (android_image_check_header(hdr)) {
		printf("Bad android image header\n");
		return -EINVAL;
	}

	/* set for image_read(IMG_KERNEL, ...) */
	env_set_hex("android_addr_r", (ulong)load_address);
	bstart = part ? part->start : 0;

	/*
	 * 1. Load images to their individual target ram position
	 *    in order to disable fdt/ramdisk relocation.
	 */
#if defined(CONFIG_DM_CRYPTO) && defined(CONFIG_ANDROID_BOOT_IMAGE_HASH)
	struct udevice *dev;
	sha_context ctx;
	uchar hash[20];

	ctx.length = 0;
	ctx.algo = CRYPTO_SHA1;
	dev = crypto_get_device(ctx.algo);
	if (!dev) {
		printf("Can't find crypto device for SHA1 capability\n");
		return -ENODEV;
	}

  #ifdef CONFIG_ROCKCHIP_CRYPTO_V1
	/* v1: requires total length before sha init */
	ctx.length += hdr->kernel_size + sizeof(hdr->kernel_size) +
		      hdr->ramdisk_size + sizeof(hdr->ramdisk_size) +
		      hdr->second_size + sizeof(hdr->second_size);
	if (hdr->header_version > 0)
		ctx.length += hdr->recovery_dtbo_size +
					sizeof(hdr->recovery_dtbo_size);
	if (hdr->header_version > 1)
		ctx.length += hdr->dtb_size + sizeof(hdr->dtb_size);
  #endif
	crypto_sha_init(dev, &ctx);

	/* load, never change order ! */
	if (image_read(IMG_RK_DTB,  hdr, bstart, ram_base, NULL))
		return -1;
	if (image_read(IMG_KERNEL,  hdr, bstart, ram_base, dev))
		return -1;
	if (image_read(IMG_RAMDISK, hdr, bstart, ram_base, dev))
		return -1;
	if (image_read(IMG_SECOND,  hdr, bstart, ram_base, dev))
		return -1;
	if (hdr->header_version > 0) {
		if (image_read(IMG_RECOVERY_DTBO, hdr, bstart, ram_base, dev))
			return -1;
	}
	if (hdr->header_version > 1) {
		if (image_read(IMG_DTB, hdr, bstart, ram_base, dev))
			return -1;
	}

	crypto_sha_final(dev, &ctx, hash);
	if (memcmp(hash, hdr->id, 20)) {
		print_hash("Hash from header", (u8 *)hdr->id, 20);
		print_hash("Hash real", (u8 *)hash, 20);
		return -EBADFD;
	} else {
		printf("Image hash OK\n");
	}

#else /* !(CONFIG_DM_CRYPTO && CONFIG_ANDROID_BOOT_IMAGE_HASH) */
	if (image_read(IMG_RK_DTB,  hdr, bstart, ram_base, NULL))
		return -1;
	if (image_read(IMG_KERNEL,  hdr, bstart, ram_base, NULL))
		return -1;
	if (image_read(IMG_RAMDISK, hdr, bstart, ram_base, NULL))
		return -1;
	if (image_read(IMG_SECOND,  hdr, bstart, ram_base, NULL))
		return -1;
	if (hdr->header_version > 0) {
		if (image_read(IMG_RECOVERY_DTBO, hdr, bstart, ram_base, NULL))
			return -1;
	}
	if (hdr->header_version > 1) {
		if (image_read(IMG_DTB, hdr, bstart, ram_base, NULL))
			return -1;
	}
#endif

	/* 2. Disable fdt/ramdisk relocation, it saves boot time */
	env_set("bootm-no-reloc", "y");

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
			env_set_hex("kernel_addr_c", comp_addr);
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
		if (kernel_addr_c) {
			*load_addr = env_get_ulong("kernel_addr_r", 16, 0);
		} else {
			*load_addr = CONFIG_SYS_SDRAM_BASE + 0x8000;
			env_set_hex("kernel_addr_r", *load_addr);
		}
		
		*load_addr -= hdr->page_size;
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
	if (comp_addr == (ulong)hdr)
		return 0;

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
