// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2019 Fuzhou Rockchip Electronics Co., Ltd
 */

#include <common.h>
#include <amp.h>
#include <dm.h>
#include <dm/lists.h>

int amp_cpu_on(u32 cpu)
{
	struct dm_amp_uclass_platdata *uc_pdata;
	const struct dm_amp_ops *ops;
	struct udevice *dev;
	struct uclass *uc;
	int ret;

	ret = uclass_get(UCLASS_AMP, &uc);
	if (ret)
		return ret;

	for (uclass_first_device(UCLASS_AMP, &dev);
	     dev;
	     uclass_next_device(&dev)) {
		uc_pdata = dev_get_uclass_platdata(dev);
		if (!uc_pdata || uc_pdata->cpu != cpu)
			continue;

		ops = dev_get_driver_ops(dev);
		if (!ops || !ops->cpu_on)
			return -ENOSYS;

		return ops->cpu_on(dev);
	}

	return -ENODEV;
}

int amp_cpus_on(void)
{
	const struct dm_amp_ops *ops;
	struct udevice *dev;
	struct uclass *uc;
	int ret;

	ret = uclass_get(UCLASS_AMP, &uc);
	if (ret)
		return ret;

	for (uclass_first_device(UCLASS_AMP, &dev);
	     dev;
	     uclass_next_device(&dev)) {
		ops = dev_get_driver_ops(dev);
		if (!ops || !ops->cpu_on)
			continue;
		ret = ops->cpu_on(dev);
	}

	return ret;
}

int amp_bind_children(struct udevice *dev, const char *drv_name)
{
	const char *name;
	ofnode node;
	int ret;

	dev_for_each_subnode(node, dev) {
		/*
		 * If this node has "compatible" property, this is not
		 * a amp subnode, but a normal device. skip.
		 */
		ofnode_get_property(node, "compatible", &ret);
		if (ret >= 0)
			continue;

		if (ret != -FDT_ERR_NOTFOUND)
			return ret;

		name = ofnode_get_name(node);
		if (!name)
			return -EINVAL;
		ret = device_bind_driver_to_node(dev, drv_name, name,
						 node, NULL);
		if (ret)
			return ret;
	}

	return 0;
}

static int amp_pre_probe(struct udevice *dev)
{
	struct dm_amp_uclass_platdata *uc_pdata;

	uc_pdata = dev_get_uclass_platdata(dev);
	if (!uc_pdata)
		return -ENXIO;

	uc_pdata->desc = dev_read_string(dev, "description");
	uc_pdata->partition = dev_read_string(dev, "partition");
	uc_pdata->cpu = dev_read_u32_default(dev, "cpu", -ENODATA);
#ifdef CONFIG_ARM64
	uc_pdata->aarch = dev_read_u32_default(dev, "aarch", 64);
#else
	uc_pdata->aarch = dev_read_u32_default(dev, "aarch", 32);
#endif
	uc_pdata->load = dev_read_u32_default(dev, "load", -ENODATA);
	uc_pdata->entry = dev_read_u32_default(dev, "entry", -ENODATA);

	dev_read_u32_array(dev, "memory",
			   uc_pdata->reserved_mem,
			   ARRAY_SIZE(uc_pdata->reserved_mem));

	if (!uc_pdata->desc || !uc_pdata->partition ||
	    uc_pdata->cpu == -ENODATA || uc_pdata->load == -ENODATA ||
	    uc_pdata->entry == -ENODATA || !uc_pdata->reserved_mem[0] ||
	    !uc_pdata->reserved_mem[1] ||
	    (uc_pdata->aarch != 64 && uc_pdata->aarch != 32)) {
		printf("AMP: \"%s\" is not complete\n", dev->name);
		return -EINVAL;
	}

#ifdef DEBUG
	printf("[%s]:\n", dev_read_name(dev));
	printf("    descrption: %s\n", uc_pdata->desc);
	printf("     partition: %s\n", uc_pdata->partition);
	printf("           cpu: 0x%x\n", uc_pdata->cpu);
	printf("         aarch: %d\n", uc_pdata->aarch);
	printf("          load: 0x%08x\n", uc_pdata->load);
	printf("         entry: 0x%08x\n", uc_pdata->entry);
	printf("  reserved_mem: 0x%08x - 0x%08x\n\n",
	       uc_pdata->reserved_mem[0],
	       uc_pdata->reserved_mem[0] + uc_pdata->reserved_mem[1]);
#endif

	return 0;
}

UCLASS_DRIVER(amp) = {
	.id		= UCLASS_AMP,
	.name		= "amp",
	.pre_probe	= amp_pre_probe,
	.per_device_platdata_auto_alloc_size =
			sizeof(struct dm_amp_uclass_platdata),
};

#ifdef DEBUG
static int do_amp_cpus_on(cmd_tbl_t *cmdtp, int flag,
			  int argc, char *const argv[])
{
	amp_cpus_on();
	return 0;
}

U_BOOT_CMD(
	amp_cpus_on, 1, 1, do_amp_cpus_on,
	"Brought up all amp cpus",
	""
);
#endif
