// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2019 Fuzhou Rockchip Electronics Co., Ltd
 */
#include <common.h>
#include <amp.h>
#include <boot_rkimg.h>
#include <bidram.h>
#include <dm.h>
#include <sysmem.h>
#include <asm/arch/rockchip_smccc.h>

#define AMP_I(fmt, args...)	printf("AMP: "fmt, ##args)
#define AMP_E(fmt, args...)	printf("AMP Error: "fmt, ##args)

/*
 * An example for amps dts node configure:
 *
 * amps {
 *	compatible = "uboot,rockchip-amp";
 *	status = "okay";
 *
 *	amp@0 {
 *		description  = "mcu-os1";
 *		partition    = "mcu1";
 *		cpu          = <0x1>;		// this is mpidr!
 *		load         = <0x800000>;
 *		entry        = <0x800000>;
 *		memory       = <0x800000 0x400000>;
 *	};
 *
 *	amp@1 {
 *		......
 *	};
 *
 *	......
 * };
 *
 * U-Boot loads "mcu-os1" firmware to "0x800000" address from partiton
 * "mcu1" for cpu[1], the cpu[1] entry address is 0x800000. And
 * U-Boot reserve memory from 0x800000 with 0x400000 size in order
 * to make it invisible for kernel.
 *
 * Please use rockchip tool "mkkrnlimg" to pack firmware binary, example:
 * ./scripts/mkkrnlimg mcu-os1.bin mcu-os1.img
 */

static int rockchip_amp_cpu_on(struct udevice *dev)
{
	struct dm_amp_uclass_platdata *uc_pdata;
	struct blk_desc *dev_desc;
	disk_partition_t part_info;
	int ret, size;

	uc_pdata = dev_get_uclass_platdata(dev);
	if (!uc_pdata)
		return -ENXIO;

	dev_desc = rockchip_get_bootdev();
	if (!dev_desc)
		return -EEXIST;

	ret = part_get_info_by_name(dev_desc, uc_pdata->partition, &part_info);
	if (ret < 0) {
		AMP_E("\"%s\" find partition \"%s\" failed\n",
		      uc_pdata->desc, uc_pdata->partition);
		return ret;
	}

	ret = bidram_reserve_by_name(uc_pdata->partition,
				     uc_pdata->reserved_mem[0],
				     uc_pdata->reserved_mem[1]);
	if (ret) {
		AMP_E("Reserve \"%s\" region at 0x%08x - 0x%08x failed, ret=%d\n",
		      uc_pdata->desc, uc_pdata->reserved_mem[0],
		      uc_pdata->reserved_mem[0] + uc_pdata->reserved_mem[1], ret);
		return -ENOMEM;
	}

	size = read_rockchip_image(dev_desc, &part_info,
				   (void *)(ulong)uc_pdata->load);
	if (size < 0) {
		AMP_E("\"%s\" load at 0x%08x failed\n",
		      uc_pdata->desc, uc_pdata->load);
		return size;
	}

	flush_dcache_range(uc_pdata->load,
			   uc_pdata->load + ALIGN(size, ARCH_DMA_MINALIGN));

	AMP_I("Brought up cpu[%x] on \"%s\" entry 0x%08x ...",
	      uc_pdata->cpu, uc_pdata->desc, uc_pdata->entry);

	ret = psci_cpu_on(uc_pdata->cpu, uc_pdata->entry);
	if (ret) {
		printf("failed\n");
		return ret;
	}
	printf("OK\n");

	return 0;
}

static const struct dm_amp_ops rockchip_amp_ops = {
	.cpu_on = rockchip_amp_cpu_on,
};

U_BOOT_DRIVER(rockchip_amp) = {
	.name	   = "rockchip_amp",
	.id	   = UCLASS_AMP,
	.ops	   = &rockchip_amp_ops,
};

/* AMP bus driver as all amp parent */
static int rockchip_amp_bus_bind(struct udevice *dev)
{
	return amp_bind_children(dev, "rockchip_amp");
}

static const struct udevice_id rockchip_amp_bus_match[] = {
	{ .compatible = "uboot,rockchip-amp", },
	{},
};

U_BOOT_DRIVER(rockchip_amp_bus) = {
	.name	   = "rockchip_amp_bus",
	.id	   = UCLASS_SIMPLE_BUS,
	.of_match  = rockchip_amp_bus_match,
	.bind	   = rockchip_amp_bus_bind,
};
