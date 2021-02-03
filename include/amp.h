/* SPDX-License-Identifier:     GPL-2.0+ */
/*
 * (C) Copyright 2019 Rockchip Electronics Co., Ltd
 */

#ifndef _AMP_H_
#define _AMP_H_

#include <dm.h>

#define MAP_AARCH(aarch64)	((aarch64) ? 1 : 0)
#define MAP_HYP(hyp)		((hyp) ? 1 : 0)
#define MAP_THUMB(thumb)	((thumb) ? 1 : 0)
#define MAP_SECURE(secure)	((secure) ? 0 : 1)

#define	MODE_AARCH64_SHIFT	1
#define	MODE_HYP_SHIFT		2
#define	MODE_THUMB_SHIFT	3
#define	MODE_SECURE_SHIFT	4

#define PE_STATE(aarch64, hyp, thumb, secure)				\
	       (((MAP_AARCH(aarch64) & 0x1) << MODE_AARCH64_SHIFT) |	\
		((MAP_HYP(hyp) & 0x1) << MODE_HYP_SHIFT) |		\
		((MAP_THUMB(thumb) & 0x1) << MODE_THUMB_SHIFT) |	\
		((MAP_SECURE(secure) & 0x1) << MODE_SECURE_SHIFT))

struct dm_amp_ops {
	int (*cpu_on)(struct udevice *dev);
};

struct dm_amp_uclass_platdata {
	const char *desc;
	const char *partition;
	u32 cpu;		/* cpu mpidr */
	u32 aarch64;
	u32 hyp;
	u32 thumb;
	u32 secure;
	u32 load;
	u32 entry;
	u32 reserved_mem[2];	/* [0]: start, [1]: size */
};

int amp_bind_children(struct udevice *dev, const char *drv_name);
int amp_cpus_on(void);
int amp_cpu_on(u32 cpu);

#endif	/* _AMP_H_ */

