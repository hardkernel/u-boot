/*
 * (C) Copyright 2019 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */
#include <common.h>
#include <boot_rkimg.h>
#include <dm.h>
#include <malloc.h>
#include <of_live.h>
#include <dm/root.h>
#include <asm/arch/hotkey.h>

DECLARE_GLOBAL_DATA_PTR;

/* Here, only fixup cru phandle, pmucru is not included */
static int phandles_fixup_cru(const void *fdt)
{
	const char *props[] = { "clocks", "assigned-clocks" };
	struct udevice *dev;
	struct uclass *uc;
	const char *comp;
	u32 id, nclocks;
	u32 *clocks;
	int phandle, ncells;
	int off, offset;
	int ret, length;
	int i, j;
	int first_phandle = -1;

	phandle = -ENODATA;
	ncells = -ENODATA;

	/* fdt points to kernel dtb, getting cru phandle and "#clock-cells" */
	for (offset = fdt_next_node(fdt, 0, NULL);
	     offset >= 0;
	     offset = fdt_next_node(fdt, offset, NULL)) {
		comp = fdt_getprop(fdt, offset, "compatible", NULL);
		if (!comp)
			continue;

		/* Actually, this is not a good method to get cru node */
		off = strlen(comp) - strlen("-cru");
		if (off > 0 && !strncmp(comp + off, "-cru", 4)) {
			phandle = fdt_get_phandle(fdt, offset);
			ncells = fdtdec_get_int(fdt, offset,
						"#clock-cells", -ENODATA);
			break;
		}
	}

	if (phandle == -ENODATA || ncells == -ENODATA)
		return 0;

	debug("%s: target cru: clock-cells:%d, phandle:0x%x\n",
	      __func__, ncells, fdt32_to_cpu(phandle));

	/* Try to fixup all cru phandle from U-Boot dtb nodes */
	for (id = 0; id < UCLASS_COUNT; id++) {
		ret = uclass_get(id, &uc);
		if (ret)
			continue;

		if (list_empty(&uc->dev_head))
			continue;

		list_for_each_entry(dev, &uc->dev_head, uclass_node) {
			/* Only U-Boot node go further */
			if (!dev_read_bool(dev, "u-boot,dm-pre-reloc") &&
			    !dev_read_bool(dev, "u-boot,dm-spl"))
				continue;

			for (i = 0; i < ARRAY_SIZE(props); i++) {
				if (!dev_read_prop(dev, props[i], &length))
					continue;

				clocks = malloc(length);
				if (!clocks)
					return -ENOMEM;

				/* Read "props[]" which contains cru phandle */
				nclocks = length / sizeof(u32);
				if (dev_read_u32_array(dev, props[i],
						       clocks, nclocks)) {
					free(clocks);
					continue;
				}

				/* Fixup with kernel cru phandle */
				for (j = 0; j < nclocks; j += (ncells + 1)) {
					/*
					 * Check: update pmucru phandle with cru
					 * phandle by mistake.
					 */
					if (first_phandle == -1)
						first_phandle = clocks[j];

					if (clocks[j] != first_phandle) {
						debug("WARN: %s: first cru phandle=%d, this=%d\n",
						      dev_read_name(dev),
						      first_phandle, clocks[j]);
						continue;
					}

					clocks[j] = phandle;
				}

				/*
				 * Override live dt nodes but not fdt nodes,
				 * because all U-Boot nodes has been imported
				 * to live dt nodes, should use "dev_xxx()".
				 */
				dev_write_u32_array(dev, props[i],
						    clocks, nclocks);
				free(clocks);
			}
		}
	}

	return 0;
}

static int phandles_fixup_gpio(const void *fdt, void *ufdt)
{
	struct udevice *dev;
	struct uclass *uc;
	const char *prop = "gpios";
	const char *comp;
	char *gpio_name[10];
	int gpio_off[10];
	int pinctrl;
	int offset;
	int i = 0;
	int n = 0;

	pinctrl = fdt_path_offset(fdt, "/pinctrl");
	if (pinctrl < 0)
		return 0;

	memset(gpio_name, 0, sizeof(gpio_name));
	for (offset = fdt_first_subnode(fdt, pinctrl);
	     offset >= 0;
	     offset = fdt_next_subnode(fdt, offset)) {
		/* assume the font nodes are gpio node */
		if (++i >= ARRAY_SIZE(gpio_name))
			break;

		comp = fdt_getprop(fdt, offset, "compatible", NULL);
		if (!comp)
			continue;

		if (!strcmp(comp, "rockchip,gpio-bank")) {
			gpio_name[n] = (char *)fdt_get_name(fdt, offset, NULL);
			gpio_off[n]  = offset;
			n++;
		}
	}

	if (!gpio_name[0])
		return 0;

	if (uclass_get(UCLASS_KEY, &uc) || list_empty(&uc->dev_head))
		return 0;

	list_for_each_entry(dev, &uc->dev_head, uclass_node) {
		u32 new_phd, phd_old;
		char *name;
		ofnode ofn;

		if (!dev_read_bool(dev, "u-boot,dm-pre-reloc") &&
		    !dev_read_bool(dev, "u-boot,dm-spl"))
			continue;

		if (dev_read_u32_array(dev, prop, &phd_old, 1))
			continue;

		ofn = ofnode_get_by_phandle(phd_old);
		if (!ofnode_valid(ofn))
			continue;

		name = (char *)ofnode_get_name(ofn);
		if (!name)
			continue;

		for (i = 0; i < ARRAY_SIZE(gpio_name); i++) {
			if (gpio_name[i] && !strcmp(name, gpio_name[i])) {
				new_phd = fdt_get_phandle(fdt, gpio_off[i]);
				dev_write_u32_array(dev, prop, &new_phd, 1);
				break;
			}
		}
	}

	return 0;
}

__weak int board_mmc_dm_reinit(struct udevice *dev)
{
	return 0;
}

static int mmc_dm_reinit(void)
{
	struct udevice *dev;
	struct uclass *uc;
	int ret;

	if (uclass_get(UCLASS_MMC, &uc) || list_empty(&uc->dev_head))
		return 0;

	list_for_each_entry(dev, &uc->dev_head, uclass_node) {
		ret = board_mmc_dm_reinit(dev);
		if (ret)
			return ret;
	}

	return 0;
}

int init_kernel_dtb(void)
{
	ulong fdt_addr;
	void *ufdt_blob;
	int ret;

	fdt_addr = env_get_ulong("fdt_addr_r", 16, 0);
	if (!fdt_addr) {
		printf("No Found FDT Load Address.\n");
		return -1;
	}

	ret = rockchip_read_dtb_file((void *)fdt_addr);
	if (ret < 0) {
		if (!fdt_check_header(gd->fdt_blob_kern)) {
			fdt_addr = (ulong)memalign(ARCH_DMA_MINALIGN,
					fdt_totalsize(gd->fdt_blob_kern));
			if (!fdt_addr)
				return -ENOMEM;

			memcpy((void *)fdt_addr, gd->fdt_blob_kern,
			       fdt_totalsize(gd->fdt_blob_kern));
			printf("DTB: embedded kern.dtb\n");
		} else {
			printf("Failed to get kernel dtb, ret=%d\n", ret);
			return ret;
		}
	}

	ufdt_blob = (void *)gd->fdt_blob;
	gd->fdt_blob = (void *)fdt_addr;

	hotkey_run(HK_FDT);

	/*
	 * There is a phandle miss match between U-Boot and kernel dtb node,
	 * we fixup it in U-Boot live dt nodes.
	 *
	 * CRU:	 all nodes.
	 * GPIO: key nodes.
	 */
	phandles_fixup_cru((void *)gd->fdt_blob);
	phandles_fixup_gpio((void *)gd->fdt_blob, (void *)ufdt_blob);

	of_live_build((void *)gd->fdt_blob, (struct device_node **)&gd->of_root);
	dm_scan_fdt((void *)gd->fdt_blob, false);

	/*
	 * There maybe something for the mmc devices to do after kernel dtb
	 * dm setup, eg: regain the clock device binding from kernel dtb.
	 */
	mmc_dm_reinit();

	/* Reserve 'reserved-memory' */
	ret = boot_fdt_add_sysmem_rsv_regions((void *)gd->fdt_blob);
	if (ret)
		return ret;

	return 0;
}
