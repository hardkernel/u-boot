/*
 * Copyright (c) 2011 Sebastian Andrzej Siewior <bigeasy@linutronix.de>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <image.h>
#include <android_image.h>
#include <malloc.h>
#include <errno.h>
static const unsigned char lzop_magic[] = {
	0x89, 0x4c, 0x5a, 0x4f, 0x00, 0x0d, 0x0a, 0x1a, 0x0a
};

static char andr_tmp_str[ANDR_BOOT_ARGS_SIZE + 1];

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
	/*
	 * Not all Android tools use the id field for signing the image with
	 * sha1 (or anything) so we don't check it. It is not obvious that the
	 * string is null terminated so we take care of this.
	 */
	ulong end;
	strncpy(andr_tmp_str, hdr->name, ANDR_BOOT_NAME_SIZE);
	andr_tmp_str[ANDR_BOOT_NAME_SIZE] = '\0';
	if (strlen(andr_tmp_str))
		printf("Android's image name: %s\n", andr_tmp_str);

	debug("Kernel load addr 0x%08x size %u KiB\n",
	      hdr->kernel_addr, DIV_ROUND_UP(hdr->kernel_size, 1024));

	int len = 0;
	if (*hdr->cmdline) {
		printf("Kernel command line: %s\n", hdr->cmdline);
		len += strlen(hdr->cmdline);
	}

	char *bootargs = getenv("bootargs");
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

	setenv("bootargs", newbootargs);

	if (os_data) {
		*os_data = (ulong)hdr;
		*os_data += hdr->page_size;
	}
	if (os_len)
		*os_len = hdr->kernel_size;

#if defined(CONFIG_ANDROID_IMG)
			images.ft_len = (ulong)(hdr->second_size);
			end = (ulong)hdr;
			end += hdr->page_size;
			end += ALIGN(hdr->kernel_size, hdr->page_size);
			images.rd_start = end;
			end += ALIGN(hdr->ramdisk_size, hdr->page_size);
			images.ft_addr = (char *)end;
#endif

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

	return end;
}

ulong android_image_get_kload(const struct andr_img_hdr *hdr)
{
	return hdr->kernel_addr;
}

int android_image_get_ramdisk(const struct andr_img_hdr *hdr,
			      ulong *rd_data, ulong *rd_len)
{
	if (!hdr->ramdisk_size)
		return -1;

	debug("RAM disk load addr 0x%08x size %u KiB\n",
	      hdr->ramdisk_addr, DIV_ROUND_UP(hdr->ramdisk_size, 1024));

	*rd_data = (unsigned long)hdr;
	*rd_data += hdr->page_size;
	*rd_data += ALIGN(hdr->kernel_size, hdr->page_size);

	*rd_len = hdr->ramdisk_size;
	return 0;
}

ulong android_image_get_comp(const struct andr_img_hdr *os_hdr)
{
	int i;
	unsigned char *src = (unsigned char *)os_hdr + os_hdr->page_size;
	/* read magic: 9 first bytes */
	for (i = 0; i < ARRAY_SIZE(lzop_magic); i++) {
		if (*src++ != lzop_magic[i])
				break;
	}
	if (i == ARRAY_SIZE(lzop_magic))
		return IH_COMP_LZO;
	else
		return IH_COMP_NONE;
}
int android_image_need_move(ulong *img_addr, const struct andr_img_hdr *hdr)
{
	ulong kernel_load_addr = android_image_get_kload(hdr);
	ulong img_start = *img_addr;
	ulong val = 0;
	if (kernel_load_addr > img_start)
		val = kernel_load_addr - img_start;
	else
		val = img_start - kernel_load_addr;
	if (android_image_get_comp(hdr) == IH_COMP_NONE)
		return 0;
	if (val < 32*1024*1024) {
		ulong total_size = android_image_get_end(hdr)-(ulong)hdr;
		void *reloc_addr = malloc(total_size);
		if (!reloc_addr) {
			puts("Error: malloc in  android_image_need_move failed!\n");
			return -ENOMEM;
		}
		printf("reloc_addr =%lx\n", (ulong)reloc_addr);
		memset(reloc_addr, 0, total_size);
		memmove(reloc_addr, hdr, total_size);
		*img_addr = (ulong)reloc_addr;
		printf("copy done\n");
	}
	return 0;
}
