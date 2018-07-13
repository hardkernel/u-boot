/*
 * SPDX-License-Identifier:     GPL-2.0+
 *
 * (C) Copyright 2018 Rockchip Electronics Co., Ltd
 *
 */

#include <asm/io.h>
#include <common.h>
#include <dm.h>
#include <fdtdec.h>

void iomem_show(const char *label, unsigned long base, size_t start, size_t end)
{
	unsigned long val, offset = start, nr = 0;

	if (label)
		printf("%s:\n", label);

	printf("%08lx:  ", base + offset);
	for (offset = start; offset <= end; offset += 0x04) {
		if (nr >= 4) {
			printf("\n%08lx:  ", base + offset);
			nr = 0;
		}
		val = readl((void __iomem *)base + offset);
		printf("%08lx ", val);
		nr++;
	}
	printf("\n");
}

void iomem_show_by_compatible(const char *compat, size_t start, size_t end)
{
	const void *fdt = gd->fdt_blob;
	const char *compatible;
	fdt_addr_t addr;
	int offset;

	if (!compat)
		return;

	for (offset = fdt_next_node(fdt, 0, NULL);
	     offset >= 0;
	     offset = fdt_next_node(fdt, offset, NULL)) {
		compatible = fdt_getprop(fdt, offset, "compatible", NULL);
		if (!compatible)
			continue;

		if (strstr(compatible, compat)) {
			addr = fdtdec_get_addr_size_auto_noparent(fdt, offset,
							"reg", 0, NULL, false);
			compatible = fdt_getprop(fdt, offset, "compatible",
						 NULL);
			iomem_show(compatible, addr, start, end);
			break;
		}
	}

	printf("\n");
}

static int do_iomem_by_compatible(cmd_tbl_t *cmdtp, int flag, int argc,
				  char *const argv[])
{
	size_t start, end;
	const char *compat;

	if (argc != 4)
		return CMD_RET_USAGE;

	compat = argv[1];
	start = simple_strtoul(argv[2], NULL, 0);
	end = simple_strtoul(argv[3], NULL, 0);

	iomem_show_by_compatible(compat, start, end);

	return 0;
}

U_BOOT_CMD(
	iomem,		4,	1,	do_iomem_by_compatible,
	"Show iomem data by device compatible",
	"iomem <compatible> <start offset>  <end offset>\n"
	"  eg: iomem -grf 0x0 0x200"
);
