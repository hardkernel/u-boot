/*
 * (C) Copyright 2019 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */
#include <common.h>
#include <boot_rkimg.h>
#include <image.h>
#include <malloc.h>
#include <sysmem.h>
#include <asm/arch/fit.h>
#include <asm/arch/resource_img.h>

DECLARE_GLOBAL_DATA_PTR;

#define FIT_PLACEHOLDER_ADDR		0xffffff00

/*
 * Must use args '-E -p' for mkimage to generate FIT image, 4K as max assumption.
 */
#define FIT_FDT_MAX_SIZE		SZ_4K

static int fit_is_ext_type(void *fit)
{
	return fdt_totalsize(fit) < FIT_FDT_MAX_SIZE;
}

static int fit_is_signed(void *fit, const void *sig_blob)
{
	return fdt_subnode_offset(sig_blob, 0, FIT_SIG_NODENAME) < 0 ? 0 : 1;
}

static inline int fit_is_placeholder_addr(ulong addr)
{
	return (addr & 0xffffff00) == FIT_PLACEHOLDER_ADDR;
}

static int fit_is_required(void *fit, const void *sig_blob)
{
	int sig_node;
	int noffset;

	sig_node = fdt_subnode_offset(sig_blob, 0, FIT_SIG_NODENAME);
	if (sig_node < 0)
		return 0;

	fdt_for_each_subnode(noffset, sig_blob, sig_node) {
		const char *required;

		required = fdt_getprop(sig_blob, noffset, "required", NULL);
		if (required && !strcmp(required, "conf"))
			return 1;
	}

	return 0;
}

int fit_fixup_load_entry(void *fit, int images, int defconf,
			 char *name, ulong *load, ulong new_addr)
{
	const char *uname;
	int uname_cfg;
	int err;

	if (!fit_is_placeholder_addr(*load) ||
		fit_is_required(fit, gd_fdt_blob()))
		return 0;

	*load = new_addr;

	uname = fdt_getprop(fit, defconf, name, NULL);
	if (!uname)
		return -ENODEV;

	uname_cfg = fdt_subnode_offset(fit, images, uname);
	if (uname_cfg < 0)
		return -ENODEV;

	err = fit_image_set_load(fit, uname_cfg, new_addr);
	if (err)
		return err;

	fit_image_set_entry(fit, uname_cfg, new_addr);

	return 0;
}

static int fit_get_load_and_data(void *fit, int images, int defconf,
				 const char *name, ulong *load,
				 int *offset, int *size)
{
	const char *uname;
	int uname_cfg;
	int off, sz;
	int err;

	uname = fdt_getprop(fit, defconf, name, NULL);
	if (!uname)
		return -ENODEV;

	uname_cfg = fdt_subnode_offset(fit, images, uname);
	if (uname_cfg < 0)
		return -ENODEV;

	err = fit_image_get_data_size(fit, uname_cfg, &sz);
	if (err)
		return err;

	err = fit_image_get_data_position(fit, uname_cfg, &off);
	if (!err) {
		off -= fdt_totalsize(fit);
	} else {
		err = fit_image_get_data_offset(fit, uname_cfg, &off);
		if (err)
			return err;
	}

	/* optional */
	if (load) {
		err = fit_image_get_load(fit, uname_cfg, load);
		if (err)
			return err;
	}

	*offset = off;
	*size = sz;

	return 0;
}

int fit_image_fixup_and_sysmem_rsv(void *fit)
{
	ulong load, kaddr, faddr, raddr;
	int images, defconf;
	int offset, size;
	int err;

	faddr = env_get_ulong("fdt_addr_r", 16, 0);
	kaddr = env_get_ulong("kernel_addr_r", 16, 0);
	raddr = env_get_ulong("ramdisk_addr_r", 16, 0);

	if (!faddr || !kaddr || !raddr)
		return -EINVAL;

	if (fit_get_image_defconf_node(fit, &images, &defconf)) {
		FIT_I("Failed to get default config\n");
		return -ENODEV;
	}

	/* fdt */
	if (fit_get_load_and_data(fit, images, defconf, FIT_FDT_PROP,
				  &load, &offset, &size)) {
		FIT_I("Invalid fdt node\n");
		return -ENOENT;
	}

#ifdef CONFIG_USING_KERNEL_DTB
	sysmem_free((phys_addr_t)gd->fdt_blob);
#endif
	if (fit_fixup_load_entry(fit, images, defconf,
				 FIT_FDT_PROP, &load, faddr)) {
		FIT_I("Failed to fixup fdt load addr\n");
		return -EINVAL;
	}

	if (!sysmem_alloc_base(MEM_FDT, (phys_addr_t)load,
			       ALIGN(size, RK_BLK_SIZE)))
		return -ENOMEM;

	/* kernel */
	if (fit_get_load_and_data(fit, images, defconf, FIT_KERNEL_PROP,
				  &load, &offset, &size)) {
		FIT_I("Invalid kernel node\n");
		return -EINVAL;
	}

	if (fit_fixup_load_entry(fit, images, defconf,
				 FIT_KERNEL_PROP, &load, kaddr)) {
		FIT_I("Failed to fixup kernel load addr\n");
		return -EINVAL;
	}

	if (!sysmem_alloc_base(MEM_KERNEL, (phys_addr_t)load,
			       ALIGN(size, RK_BLK_SIZE)))
		return -ENOMEM;

	/* ramdisk(optional) */
	err = fit_get_load_and_data(fit, images, defconf, FIT_RAMDISK_PROP,
				    &load, &offset, &size);
	if (err && err != -ENODEV) {
		FIT_I("Invalid ramdisk node\n");
		return err;
	}

	if (size) {
		if (fit_fixup_load_entry(fit, images, defconf,
					 FIT_RAMDISK_PROP, &load, raddr)) {
			FIT_I("Failed to fixup ramdisk load addr\n");
			return -EINVAL;
		}

		if (!sysmem_alloc_base(MEM_RAMDISK, (phys_addr_t)load,
				       ALIGN(size, RK_BLK_SIZE)))
			return -ENOMEM;
	}

	return 0;
}

int fit_sysmem_free_each(void *fit)
{
	ulong raddr, kaddr, faddr;

	raddr = env_get_ulong("ramdisk_addr_r", 16, 0);
	kaddr = env_get_ulong("kernel_addr_r", 16, 0);
	faddr = env_get_ulong("fdt_addr_r", 16, 0);

	sysmem_free((phys_addr_t)fit);
	sysmem_free((phys_addr_t)raddr);
	sysmem_free((phys_addr_t)kaddr);
	sysmem_free((phys_addr_t)faddr);

	return 0;
}

static int fit_image_load_one(void *fit, struct blk_desc *dev_desc,
			      disk_partition_t *part, int images,
			      int defconf, char *name, void *dst)
{
	u32 blknum, blkoff;
	int offset, size;

	if (fit_get_load_and_data(fit, images, defconf, name,
				  NULL, &offset, &size))
		return -EINVAL;

	blkoff = (FIT_ALIGN(fdt_totalsize(fit)) + offset) / dev_desc->blksz;
	blknum = DIV_ROUND_UP(size, dev_desc->blksz);

	if (blk_dread(dev_desc, part->start + blkoff, blknum, dst) != blknum)
		return -EIO;

	return 0;
}

static void *fit_get_blob(struct blk_desc *dev_desc, disk_partition_t *part)
{
	void *fit, *fdt;
	int blknum;

	blknum = DIV_ROUND_UP(sizeof(struct fdt_header), dev_desc->blksz);
	fdt = memalign(ARCH_DMA_MINALIGN, blknum * dev_desc->blksz);
	if (!fdt)
		return NULL;

	if (blk_dread(dev_desc, part->start, blknum, fdt) != blknum) {
		debug("Failed to read fdt header\n");
		goto fail;
	}

	if (fdt_check_header(fdt)) {
		debug("Invalid fdt header\n");
		goto fail;
	}

	if (!fit_is_ext_type(fdt)) {
		debug("Not external type\n");
		goto fail;
	}

	blknum = DIV_ROUND_UP(fdt_totalsize(fdt), dev_desc->blksz);
	fit = memalign(ARCH_DMA_MINALIGN, blknum * dev_desc->blksz);
	if (!fit) {
		debug("No memory\n");
		goto fail;
	}

	if (blk_dread(dev_desc, part->start, blknum, fit) != blknum) {
		free(fit);
		debug("Failed to read fit\n");
		goto fail;
	}

	return fit;

fail:
	free(fdt);
	return NULL;
}

#ifdef CONFIG_ROCKCHIP_RESOURCE_IMAGE
static int fit_image_load_resource(void *fit, struct blk_desc *dev_desc,
				   disk_partition_t *part, int images,
				   int defconf, ulong *addr)
{
	ulong fdt_addr_r, dst;
	int offset, size;
	int err;

	err = fit_get_load_and_data(fit, images, defconf, FIT_MULTI_PROP,
				    NULL, &offset, &size);
	if (err)
		return err;

	fdt_addr_r = env_get_ulong("fdt_addr_r", 16, 0);
	if (!fdt_addr_r)
		return -EINVAL;

	/* reserve enough space before fdt */
	dst = fdt_addr_r -
		ALIGN(size, dev_desc->blksz) - CONFIG_SYS_FDT_PAD;

	if (!sysmem_alloc_base(MEM_RESOURCE, (phys_addr_t)dst,
			       ALIGN(size, dev_desc->blksz)))
		return -ENOMEM;

	*addr = dst;

	return fit_image_load_one(fit, dev_desc, part, images, defconf,
				  FIT_MULTI_PROP, (void *)dst);
}
#else

static int fit_image_load_fdt(void *fit, struct blk_desc *dev_desc,
			      disk_partition_t *part, int images,
			      int defconf, void *dst)
{
	return fit_image_load_one(fit, dev_desc, part, images,
				  defconf, FIT_FDT_PROP, dst);
}

static int fit_image_get_fdt_hash(void *fit, int images, int defconf,
				  char **hash, int *hash_size)
{
	const char *fdt_name;
	const char *name;
	uint8_t *fit_value2;
	uint8_t *fit_value;
	int fit_value_len;
	int hash_off;
	int fdt_off;
	int found = 0;
	char *algo;

	fdt_name = fdt_getprop(fit, defconf, FIT_FDT_PROP, NULL);
	if (!fdt_name)
		return -EBADF;

	fdt_off = fdt_subnode_offset(fit, images, fdt_name);
	if (fdt_off < 0)
		return -EBADF;

	fdt_for_each_subnode(hash_off, fit, fdt_off) {
		name = fit_get_name(fit, hash_off, NULL);
		if (!strncmp(name, FIT_HASH_NODENAME,
			     strlen(FIT_HASH_NODENAME))) {
			found = 1;
			break;
		}
	}

	if (!found)
		return -ENODEV;

	if (fit_image_hash_get_algo(fit, hash_off, &algo))
		return -EINVAL;

	if (fit_image_hash_get_value(fit, hash_off, &fit_value,
				     &fit_value_len))
		return -EINVAL;

	if (!strcmp(algo, "sha1"))
		*hash_size = 20;
	else if (!strcmp(algo, "sha256"))
		*hash_size = 32;
	else
		return -EINVAL;

	/* avoid freed */
	fit_value2 = malloc(fit_value_len);
	if (!fit_value2)
		return -ENOMEM;

	memcpy(fit_value2, fit_value, fit_value_len);
	*hash = (char *)fit_value2;

	return 0;
}
#endif

ulong fit_image_get_bootable_size(void *fit)
{
	ulong off[3] = { 0, 0, 0 };
	ulong max_off, load;
	int images, defconf;
	int offset, size;

	if (fit_get_image_defconf_node(fit, &images, &defconf))
		return -ENODEV;

	if (!fit_get_load_and_data(fit, images, defconf, FIT_FDT_PROP,
				   &load, &offset, &size))
		off[0] = offset + FIT_ALIGN(size);

	if (!fit_get_load_and_data(fit, images, defconf, FIT_KERNEL_PROP,
				   &load, &offset, &size))
		off[1] = offset + FIT_ALIGN(size);

	if (!fit_get_load_and_data(fit, images, defconf, FIT_RAMDISK_PROP,
				   &load, &offset, &size))
		off[2] = offset + FIT_ALIGN(size);

	max_off = max(off[0],  off[1]);
	max_off = max(max_off, off[2]);

	return FIT_ALIGN(fdt_totalsize(fit)) + max_off;
}

void *fit_image_load_bootables(ulong *size)
{
	struct blk_desc *dev_desc;
	disk_partition_t part;
	char *part_name;
	int blknum;
	void *fit;

	dev_desc = rockchip_get_bootdev();
	if (!dev_desc) {
		FIT_I("No dev_desc\n");
		return NULL;
	}

	if (rockchip_get_boot_mode() == BOOT_MODE_RECOVERY)
		part_name = PART_RECOVERY;
	else
		part_name = PART_BOOT;

	if (part_get_info_by_name(dev_desc, part_name, &part) < 0) {
		FIT_I("No %s partition\n", part_name);
		return NULL;
	}

	fit = fit_get_blob(dev_desc, &part);
	if (!fit) {
		FIT_I("No fit blob\n");
		return NULL;
	}

	*size = fit_image_get_bootable_size(fit);
	if (*size == 0) {
		FIT_I("No bootable image size\n");
		return NULL;
	}

	blknum = DIV_ROUND_UP(*size, dev_desc->blksz);
	fit = sysmem_alloc(MEM_FIT, blknum * dev_desc->blksz);
	if (!fit)
		return NULL;

	if (blk_dread(dev_desc, part.start, blknum, fit) != blknum) {
		FIT_I("Failed to load bootable images\n");
		return NULL;
	}

	return fit;
}

static void verbose_msg(void *fit, int defconf)
{
	FIT_I("%ssigned, %sconf-required\n",
	      fit_is_signed(fit, gd_fdt_blob()) ? "" : "no ",
	      fit_is_required(fit, gd_fdt_blob()) ? "" : "no ");

#ifndef CONFIG_ROCKCHIP_RESOURCE_IMAGE
	printf("DTB: %s\n",
	       (char *)fdt_getprop(fit, defconf, FIT_FDT_PROP, NULL));
#endif
}

int rockchip_read_fit_dtb(void *fdt_addr, char **hash, int *hash_size)
{
	struct blk_desc *dev_desc;
	disk_partition_t part;
	char *part_name;
	void *fit;
	ulong rsce __maybe_unused;
	int images;
	int defconf;
	int ret;

	dev_desc = rockchip_get_bootdev();
	if (!dev_desc) {
		FIT_I("No dev_desc!\n");
		return -ENODEV;
	}

	if (rockchip_get_boot_mode() == BOOT_MODE_RECOVERY)
		part_name = PART_RECOVERY;
	else
		part_name = PART_BOOT;

	ret = part_get_info_by_name(dev_desc, part_name, &part);
	if (ret < 0) {
		FIT_I("No %s partition\n", part_name);
		return ret;
	}

	fit = fit_get_blob(dev_desc, &part);
	if (!fit) {
		FIT_I("No fdt blob\n");
		return -EINVAL;
	}

	if (fit_get_image_defconf_node(fit, &images, &defconf)) {
		FIT_I("Failed to get /images and /configures default\n");
		ret = -ENODEV;
		goto out;
	}

#ifdef CONFIG_ROCKCHIP_RESOURCE_IMAGE
	ret = fit_image_load_resource(fit, dev_desc, &part,
				      images, defconf, &rsce);
	if (ret) {
		FIT_I("Failed to load resource\n");
		goto out;
	}

	ret = resource_create_ram_list(dev_desc, (void *)rsce);
	if (ret) {
		FIT_I("Failed to create resource list\n");
		goto out;
	}

	ret = rockchip_read_resource_dtb(fdt_addr, hash, hash_size);
#else
	ret = fit_image_load_fdt(fit, dev_desc, &part, images,
				 defconf, fdt_addr);
	if (ret) {
		FIT_I("Failed to load fdt\n");
		goto out;
	}

	ret = fit_image_get_fdt_hash(fit, images, defconf, hash, hash_size);
	if (ret) {
		FIT_I("Failed to get fdt hash\n");
		goto out;
	}
#endif

	verbose_msg(fit, defconf);
out:
	free(fit);

	return ret;
}
