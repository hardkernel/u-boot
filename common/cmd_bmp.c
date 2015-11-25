/*
 * (C) Copyright 2002
 * Detlev Zundel, DENX Software Engineering, dzu@denx.de.
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

/*
 * BMP handling routines
 */

#include <common.h>
#include <lcd.h>
#include <bmp_layout.h>
#include <command.h>
#include <asm/byteorder.h>
#include <malloc.h>
#include <splash.h>
#include <video.h>

static int bmp_info(ulong addr);
#ifdef CONFIG_OSD_SCALE_ENABLE
static int bmp_scale(void);
#else
static int bmp_scale(ulong src_addr, ulong dst_addr, unsigned int new_width,
		     unsigned new_height);
#endif

/*
 * Allocate and decompress a BMP image using gunzip().
 *
 * Returns a pointer to the decompressed image data. This pointer is
 * aligned to 32-bit-aligned-address + 2.
 * See doc/README.displaying-bmps for explanation.
 *
 * The allocation address is passed to 'alloc_addr' and must be freed
 * by the caller after use.
 *
 * Returns NULL if decompression failed, or if the decompressed data
 * didn't contain a valid BMP signature.
 */
#ifdef CONFIG_VIDEO_BMP_GZIP
bmp_image_t *gunzip_bmp(unsigned long addr, unsigned long *lenp,
			void **alloc_addr)
{
	void *dst;
	unsigned long len;
	bmp_image_t *bmp;

	/*
	 * Decompress bmp image
	 */
	len = CONFIG_SYS_VIDEO_LOGO_MAX_SIZE;
	/* allocate extra 3 bytes for 32-bit-aligned-address + 2 alignment */
	dst = malloc(CONFIG_SYS_VIDEO_LOGO_MAX_SIZE + 3);
	if (dst == NULL) {
		puts("Error: malloc in gunzip failed!\n");
		return NULL;
	}

	bmp = dst;

	/* align to 32-bit-aligned-address + 2 */
	bmp = (bmp_image_t *)((((unsigned int)dst + 1) & ~3) + 2);

	if (gunzip(bmp, CONFIG_SYS_VIDEO_LOGO_MAX_SIZE, (uchar *)addr, &len) != 0) {
		free(dst);
		return NULL;
	}
	if (len == CONFIG_SYS_VIDEO_LOGO_MAX_SIZE)
		puts("Image could be truncated"
		     " (increase CONFIG_SYS_VIDEO_LOGO_MAX_SIZE)!\n");

	/*
	 * Check for bmp mark 'BM'
	 */
	if (!((bmp->header.signature[0] == 'B') &&
	      (bmp->header.signature[1] == 'M'))) {
		free(dst);
		return NULL;
	}

	debug("Gzipped BMP image detected!\n");

	*alloc_addr = dst;
	return bmp;
}
#else
bmp_image_t *gunzip_bmp(unsigned long addr, unsigned long *lenp,
			void **alloc_addr)
{
	return NULL;
}
#endif

static int do_bmp_info(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	ulong addr;

	switch (argc) {
	case 1:		/* use load_addr as default address */
		addr = load_addr;
		break;
	case 2:		/* use argument */
		addr = simple_strtoul(argv[1], NULL, 16);
		break;
	default:
		return CMD_RET_USAGE;
	}

	return (bmp_info(addr));
}

static int do_bmp_display(cmd_tbl_t *cmdtp, int flag, int argc,
			  char *const argv[])
{
	ulong addr;
	int x = 0, y = 0;

	splash_get_pos(&x, &y);

	switch (argc) {
	case 1:		/* use load_addr as default address */
		addr = load_addr;
		break;
	case 2:		/* use argument */
		addr = simple_strtoul(argv[1], NULL, 16);
		x = -1;
		y = -1;
		break;
	case 4:
		addr = simple_strtoul(argv[1], NULL, 16);
		x = simple_strtoul(argv[2], NULL, 10);
		y = simple_strtoul(argv[3], NULL, 10);
		break;
	default:
		return CMD_RET_USAGE;
	}

	return (bmp_display(addr, x, y));
}

static int do_bmp_scale(cmd_tbl_t *cmdtp, int flag, int argc,
			char *const argv[])
{
#ifndef CONFIG_OSD_SCALE_ENABLE
	ulong src_addr, dst_addr;
	unsigned width, height;

	switch (argc) {
	case 3:
		src_addr = simple_strtoul(argv[1], NULL, 16);
		dst_addr = simple_strtoul(argv[2], NULL, 16);
		width = simple_strtoul(getenv("display_width"), NULL, 0);
		height = simple_strtoul(getenv("display_height"), NULL, 0);
		printf("src_addr=0x%x,dst_addr=0x%x,w=%d,h=%d\n", (uint)src_addr,
		       (uint)dst_addr, width, height);
		break;
	default:
		return cmd_usage(cmdtp);
		break;
	}
	return (bmp_scale(src_addr, dst_addr, width, height));
#else
	return (bmp_scale());
#endif
}

static cmd_tbl_t cmd_bmp_sub[] = {
	U_BOOT_CMD_MKENT(info, 3, 0, do_bmp_info, "", ""),
	U_BOOT_CMD_MKENT(display, 5, 0, do_bmp_display, "", ""),
	U_BOOT_CMD_MKENT(scale, 4, 0, do_bmp_scale, "", ""),
};

#ifdef CONFIG_NEEDS_MANUAL_RELOC
void bmp_reloc(void)
{
	fixup_cmdtable(cmd_bmp_sub, ARRAY_SIZE(cmd_bmp_sub));
}
#endif

/*
 * Subroutine:  do_bmp
 *
 * Description: Handler for 'bmp' command..
 *
 * Inputs:	argv[1] contains the subcommand
 *
 * Return:      None
 *
 */
static int do_bmp(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	cmd_tbl_t *c;

	/* Strip off leading 'bmp' command argument */
	argc--;
	argv++;

	c = find_cmd_tbl(argv[0], &cmd_bmp_sub[0], ARRAY_SIZE(cmd_bmp_sub));

	if (c)
		return  c->cmd(cmdtp, flag, argc, argv);
	else
		return CMD_RET_USAGE;
}

U_BOOT_CMD(
	bmp,	5,	1,	do_bmp,
	"manipulate BMP image data",
	"info <imageAddr>              - display image info\n"
	"bmp display <imageAddr> [x y]     - display image at x,y\n"
	"bmp scale [imageAddr scaleAddr]   - scale image\n"
);

/*
 * Subroutine:  bmp_info
 *
 * Description: Show information about bmp file in memory
 *
 * Inputs:	addr		address of the bmp file
 *
 * Return:      None
 *
 */
static int bmp_info(ulong addr)
{
	bmp_image_t *bmp = (bmp_image_t *)addr;
	void *bmp_alloc_addr = NULL;
	unsigned long len;

	if (!((bmp->header.signature[0] == 'B') &&
	      (bmp->header.signature[1] == 'M')))
		bmp = gunzip_bmp(addr, &len, &bmp_alloc_addr);

	if (bmp == NULL) {
		printf("There is no valid bmp file at the given address\n");
		return 1;
	}

	printf("Image size    : %d x %d\n", le32_to_cpu(bmp->header.width),
	       le32_to_cpu(bmp->header.height));
	printf("Bits per pixel: %d\n", le16_to_cpu(bmp->header.bit_count));
	printf("Compression   : %d\n", le32_to_cpu(bmp->header.compression));

	if (bmp_alloc_addr)
		free(bmp_alloc_addr);

	return (0);
}

/*
 * Subroutine:  bmp_display
 *
 * Description: Display bmp file located in memory
 *
 * Inputs:	addr		address of the bmp file
 *
 * Return:      None
 *
 */
int bmp_display(ulong addr, int x, int y)
{
	int ret;
	bmp_image_t *bmp = (bmp_image_t *)addr;
	void *bmp_alloc_addr = NULL;
	unsigned long len;

	if (!((bmp->header.signature[0] == 'B') &&
	      (bmp->header.signature[1] == 'M')))
		bmp = gunzip_bmp(addr, &len, &bmp_alloc_addr);

	if (!bmp) {
		printf("There is no valid bmp file at the given address\n");
		return 1;
	}

#if defined(CONFIG_LCD)
	ret = lcd_display_bitmap((ulong)bmp, x, y);
#elif defined(CONFIG_VIDEO) || defined(CONFIG_AML_OSD)
	ret = video_display_bitmap((unsigned long)bmp, x, y);
#else
# error bmp_display() requires CONFIG_LCD or CONFIG_VIDEO
#endif

	if (bmp_alloc_addr)
		free(bmp_alloc_addr);

	return ret;
}

#ifdef CONFIG_OSD_SCALE_ENABLE
static int bmp_scale(void)
{
	int ret = 0;

	extern int video_scale_bitmap(void);
	ret = video_scale_bitmap();

	return ret;
}
#else
static int bmp_scale(ulong src_addr, ulong dst_addr, unsigned int new_width,
		     unsigned new_height)
{
	bmp_image_t *bmp = (bmp_image_t *)src_addr;
	bmp_image_t *bmp_dst = (bmp_image_t *)dst_addr;
	unsigned long len;
	void *bmp_alloc_addr = NULL;
	char *pBuf = (char *)bmp + bmp->header.data_offset;

	printf("Begin bmp scale ...\n");
	if (!((bmp->header.signature[0] == 'B') &&
	      (bmp->header.signature[1] == 'M')))
		bmp = gunzip_bmp(src_addr, &len, &bmp_alloc_addr);

	if (!bmp) {
		printf("There is no valid bmp file at the given address\n");
		if (bmp_alloc_addr)
			free(bmp_alloc_addr);

		return 1;
	}

	memcpy(bmp_dst, bmp, sizeof(bmp_image_t));
	bmp_dst->header.width = new_width;
	bmp_dst->header.height = new_height;
	char *pBuf_dst = (char *)bmp_dst + bmp_dst->header.data_offset;

#if 1//Fast scale
	int nWidth, nNewWidth, nNewHeight, nNewWidthBit;
	float m_xscale, m_yscale;
	int i, j, x, y, oldoffset;
	char *pNewTmp = NULL;

	m_xscale = (float)bmp_dst->header.width / (float)bmp->header.width;
	m_yscale = (float)bmp_dst->header.height / (float)bmp->header.height;
	nWidth = bmp->header.width;
	//nHeight = bmp->header.height;
	nNewHeight = bmp_dst->header.width;
	nNewWidth =	bmp_dst->header.width;
	nNewWidthBit = (4 - nNewWidth * 3 % 4) % 4 + nNewWidth * 3;

	for (i = 0; i < nNewHeight; i++) {
		pNewTmp = pBuf_dst + nNewWidthBit * i;
		for (j = 0; j < nNewWidth * 3; j += 3) {
			x = (int)(j / m_xscale);
			y = (int)(i / m_yscale);
			oldoffset = (y * nWidth * 3 + x) - (y * nWidth * 3 + x) %
				    3; //correct positon in 3 byte mode
			memcpy(pNewTmp + j, pBuf + oldoffset, 3);
		}
	}
#endif
	printf("End bmp scale \n");

	if (bmp_alloc_addr)
		free(bmp_alloc_addr);

	return 0;
}
#endif
