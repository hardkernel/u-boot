/*
 * Copyright (c) 2017 Paweł Jarosz <paweljarosz3691@gmail.com>
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include "imagetool.h"
#include <image.h>
#include <rc4.h>
#include "mkimage.h"
#include "rkcommon.h"

enum {
	RKNAND_SECT_LEN = RK_BLK_SIZE * 4,
};

struct rknand_info {
	uint32_t pagesize;
	uint32_t skippages;
	uint32_t tplsize;
	uint32_t splsize;
	uint32_t tplpaddedsize;
	uint32_t splpaddedsize;
	uint32_t itersize;
	uint32_t tplsplsize;
	char *tplfile;
	char *splfile;
};

struct rknand_info ninfo;

static uint32_t rknand_get_file_size(char *filename)
{
	int dfd;
	struct stat sbuf;

	dfd = open(filename, O_RDONLY | O_BINARY);
	if (dfd < 0) {
		fprintf(stderr, "Can't open %s: %s\n", filename, strerror(errno));
		exit(EXIT_FAILURE);
	}

	if (fstat(dfd, &sbuf) < 0) {
		fprintf(stderr, "Can't stat %s: %s\n", filename, strerror(errno));
		exit(EXIT_FAILURE);
	}

	close(dfd);

	return sbuf.st_size;
}

static void rknand_fill_ninfo(struct image_tool_params *params)
{
	sscanf(params->extraparams, "%u,%u", &ninfo.pagesize, &ninfo.skippages);

	ninfo.tplfile = params->datafile;
	if ((ninfo.splfile = strchr(params->datafile, ':')) != NULL) {
		*ninfo.splfile = '\0';
		ninfo.splfile += 1;
	}

	ninfo.tplsize = rknand_get_file_size(ninfo.tplfile);
	ninfo.splsize = rknand_get_file_size(ninfo.splfile);

	ninfo.tplpaddedsize = ROUND(ninfo.tplsize, RKNAND_SECT_LEN);

	ninfo.splpaddedsize = ROUND(ninfo.splsize, RKNAND_SECT_LEN);

	ninfo.itersize = ninfo.pagesize * (ninfo.skippages + 1);
	ninfo.tplsplsize = ((ninfo.tplpaddedsize + ninfo.splpaddedsize) /
		     RKNAND_SECT_LEN) * ninfo.itersize;
}

static void rknand_set_header(void *buf, struct stat *sbuf, int ifd,
			     struct image_tool_params *params)
{
	int sector, sploffset, splfd, ret;

	ret = rkcommon_set_header(buf, ninfo.tplsize, ninfo.splsize, params);
	if (ret) {
		printf("Warning: TPL image is too large (size %#x) and will "
		       "not boot\n", ninfo.tplsize);
	}

	if ((splfd = open(ninfo.splfile, O_RDONLY | O_BINARY)) < 0) {
		fprintf (stderr, "%s: Can't open %s: %s\n",
			params->cmdname, ninfo.splfile, strerror(errno));
		exit (EXIT_FAILURE);
	}

	sploffset = RKNAND_SECT_LEN + ninfo.tplpaddedsize;
	if (read(splfd, buf + sploffset, ninfo.splsize) != ninfo.splsize) {
		fprintf (stderr, "%s: Read error on %s: %s\n",
			params->cmdname, ninfo.splfile, strerror(errno));
		exit (EXIT_FAILURE);
	}
	close(splfd);

	if (rkcommon_need_rc4_spl(params))
		rkcommon_rc4_encode_spl(buf, sploffset, ninfo.splpaddedsize);

	/*
	 * Spread the image out so we only use the first 2KB of each pagesize
	 * region. This is a feature of the NAND format required by the Rockchip
	 * boot ROM.
	 */
	for (sector = ninfo.tplsplsize / ninfo.itersize - 1; sector >= 0; sector--) {
		memmove(buf + sector * ninfo.itersize + ninfo.pagesize,
			buf + (sector + 1) * RKNAND_SECT_LEN, RKNAND_SECT_LEN);

		if (sector < (ninfo.tplsplsize / ninfo.itersize - 1))
			memset(buf + sector * ninfo.itersize  + ninfo.pagesize +
			       RKNAND_SECT_LEN, 0xFF, ninfo.itersize -
			       RKNAND_SECT_LEN);
	}
	memset(buf + RKNAND_SECT_LEN, 0xFF, ninfo.pagesize - RKNAND_SECT_LEN);
	memset(buf + ninfo.tplsplsize - ninfo.pagesize + RKNAND_SECT_LEN, 0xFF,
	       ninfo.pagesize - RKNAND_SECT_LEN);
}

static int rknand_check_image_type(uint8_t type)
{
	if (type == IH_TYPE_RKNAND)
		return EXIT_SUCCESS;
	else
		return EXIT_FAILURE;
}

static int rknand_vrec_header(struct image_tool_params *params,
			     struct image_type_params *tparams)
{
	rknand_fill_ninfo(params);
	rkcommon_vrec_header(params, tparams, RKNAND_SECT_LEN);

	return ninfo.tplsplsize - tparams->header_size - ninfo.tplsize;
}

/*
 * rknand parameters
 */
U_BOOT_IMAGE_TYPE(
	rknand,
	"Rockchip NAND Boot Image support",
	0,
	NULL,
	rkcommon_check_params,
	rkcommon_verify_header,
	rkcommon_print_header,
	rknand_set_header,
	NULL,
	rknand_check_image_type,
	NULL,
	rknand_vrec_header
);
