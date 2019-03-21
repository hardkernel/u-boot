/* SPDX-License-Identifier:     GPL-2.0+ */
/*
 * (C) Copyright 2019 Rockchip Electronics Co., Ltd
 */

#ifndef _AMP_H_
#define _AMP_H_

#include <dm.h>

struct dm_amp_ops {
	int (*cpu_on)(struct udevice *dev);
};

struct dm_amp_uclass_platdata {
	const char *desc;
	const char *partition;
	u32 cpu;		/* cpu mpidr */
	u32 aarch;
	u32 load;
	u32 entry;
	u32 reserved_mem[2];	/* [0]: start, [1]: size */
};

int amp_bind_children(struct udevice *dev, const char *drv_name);
int amp_cpus_on(void);
int amp_cpu_on(u32 cpu);

#endif	/* _AMP_H_ */
