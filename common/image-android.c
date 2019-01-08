/*
 * Copyright (c) 2011 Sebastian Andrzej Siewior <bigeasy@linutronix.de>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <image.h>
#include <android_image.h>
#include <malloc.h>
#include <mapmem.h>
#include <errno.h>
#ifdef CONFIG_RKIMG_BOOTLOADER
#include <asm/arch/resource_img.h>
#endif

DECLARE_GLOBAL_DATA_PTR;

#define ANDROID_IMAGE_DEFAULT_KERNEL_ADDR	0x10008000
#define ANDROID_ARG_FDT_FILENAME "rk-kernel.dtb"

static char andr_tmp_str[ANDR_BOOT_ARGS_SIZE + 1];
static u32 android_kernel_comp_type = IH_COMP_NONE;

static ulong android_image_get_kernel_addr(const struct andr_img_hdr *hdr)
{
	/*
	 * All the Android tools that generate a boot.img use this
	 * address as the default.
	 *
	 * Even though it doesn't really make a lot of sense, and it
	 * might be valid on some platforms, we treat that adress as
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
	if (!hdr->ramdisk_size) {
		*rd_data = *rd_len = 0;
		return -1;
	}

	*rd_data = (unsigned long)hdr;
	*rd_data += hdr->page_size;
	*rd_data += ALIGN(hdr->kernel_size, hdr->page_size);
	*rd_len = hdr->ramdisk_size;

	printf("RAM disk load addr 0x%08lx size %u KiB\n",
	       *rd_data, DIV_ROUND_UP(hdr->ramdisk_size, 1024));

	return 0;
}

int android_image_get_fdt(const struct andr_img_hdr *hdr,
			      ulong *rd_data)
{
	if (!hdr->second_size) {
		*rd_data = 0;
		return -1;
	}
/*
 * If kernel dtb is enabled, it means we have read kernel dtb before do_bootm(),
 * that's: init_kernel_dtb() -> rockchip_read_dtb_file().
 * And maybe some operations(optional) are done:
 *
 * 1. apply fdt overlay;
 * 2. select fdt by adc or gpio;
 *
 * After that, we didn't update dtb at all untill run here, it's fine to
 * pass current fdt to kernel.
 *
 * This case has higher priority then the others(#elif, #else...).
 */
#if defined(CONFIG_USING_KERNEL_DTB)
	*rd_data = (ulong)gd->fdt_blob;

/*
 * If kernel dtb is disabled, it means kernel dtb is not read before do_bootm(),
 * we need to read it from boot.img/recovery.img now.
 *
 * For rockchip AOSP firmware(CONFIG_RKIMG_BOOTLOADER), we pack resource.img in
 * second position. we need read kernel dtb by rockchip_read_dtb_file() which
 * can do the above "some operations(optional)".
 */
#elif defined(CONFIG_RKIMG_BOOTLOADER)
	ulong fdt_addr = 0;
	int ret;

	/* Get resource addr and fdt addr */
	fdt_addr = env_get_ulong("fdt_addr_r", 16, 0);
	if (!fdt_addr) {
		printf("No Found FDT Load Address.\n");
		return -1;
	}

	ret = rockchip_read_dtb_file((void *)fdt_addr);
	if (ret < 0) {
		printf("%s: failed to read dtb file, ret=%d\n", __func__, ret);
		return ret;
	}

	*rd_data = fdt_addr;

/*
 * If kernel dtb is disabled and it's not rockchip AOSP firmware, kernel dtb is
 * in second position, let't read it directly.
 */
#else
	*rd_data = (unsigned long)hdr;
	*rd_data += hdr->page_size;
	*rd_data += ALIGN(hdr->kernel_size, hdr->page_size);
	*rd_data += ALIGN(hdr->ramdisk_size, hdr->page_size);

	printf("FDT load addr 0x%08x size %u KiB\n",
	       hdr->second_addr, DIV_ROUND_UP(hdr->second_size, 1024));
#endif

	return 0;
}

long android_image_load(struct blk_desc *dev_desc,
			const disk_partition_t *part_info,
			unsigned long load_address,
			unsigned long max_size) {
	void *buf;
	long blk_cnt = 0;
	long blk_read = 0;
	u32 comp;
	u32 kload_addr;
	u32 blkcnt;
	struct andr_img_hdr *hdr;

	if (max_size < part_info->blksz)
		return -1;

	/*
	 * Read the Android boot.img header and a few parts of
	 * the head of kernel image(2 blocks maybe enough).
	 */
	blkcnt = DIV_ROUND_UP(sizeof(*hdr), 512) + 2;
	hdr = memalign(ARCH_DMA_MINALIGN, blkcnt * 512);
	if (!hdr) {
		printf("%s: no memory\n", __func__);
		return -1;
	}

	if (blk_dread(dev_desc, part_info->start, blkcnt, hdr) != blkcnt)
		blk_read = -1;

	if (!blk_read && android_image_check_header(hdr) != 0) {
		printf("** Invalid Android Image header **\n");
		blk_read = -1;
	}

	/* page_size for image header */
	load_address -= hdr->page_size;

	/* We don't know the size of the Android image before reading the header
	 * so we don't limit the size of the mapped memory.
	 */
	buf = map_sysmem(load_address, 0 /* size */);
	if (!blk_read) {
		blk_cnt = (android_image_get_end(hdr) - (ulong)hdr +
			   part_info->blksz - 1) / part_info->blksz;
		comp = android_image_parse_kernel_comp(hdr);
		/*
		 * We should load a compressed kernel Image
		 * to high memory
		 */
		if (comp != IH_COMP_NONE) {
			load_address += android_image_get_ksize(hdr) * 3;
			load_address = env_get_ulong("kernel_addr_c", 16, load_address);
			load_address -= hdr->page_size;
			unmap_sysmem(buf);
			buf = map_sysmem(load_address, 0 /* size */);
		}

		if (blk_cnt * part_info->blksz > max_size) {
			debug("Android Image too big (%lu bytes, max %lu)\n",
			      android_image_get_end(hdr) - (ulong)hdr,
			      max_size);
			blk_read = -1;
		} else {
			debug("Loading Android Image (%lu blocks) to 0x%lx... ",
			      blk_cnt, load_address);
			blk_read = blk_dread(dev_desc, part_info->start,
					     blk_cnt, buf);
		}

		/*
		 * zImage is not need to decompress
		 * kernel will handle decompress itself
		 */
		if (comp != IH_COMP_NONE && comp != IH_COMP_ZIMAGE) {
			kload_addr = env_get_ulong("kernel_addr_r", 16, 0x02080000);
			android_image_set_kload(buf, kload_addr);
			android_image_set_comp(buf, comp);
		} else {
			android_image_set_comp(buf, IH_COMP_NONE);
		}

	}

	free(hdr);
	unmap_sysmem(buf);

	debug("%lu blocks read: %s\n",
	      blk_read, (blk_read == blk_cnt) ? "OK" : "ERROR");
	if (blk_read != blk_cnt)
		return -1;

	return load_address;
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
}
#endif
