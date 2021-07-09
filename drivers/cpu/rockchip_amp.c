// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2021 Rockchip Electronics Co., Ltd
 */

#include <common.h>
#include <amp.h>
#include <bidram.h>
#include <boot_rkimg.h>
#include <sysmem.h>
#include <asm/arch/rockchip_smccc.h>

#define AMP_PART	"amp"

static u32 primary_pe_arch;
static u32 primary_pe_state;

static u32 fit_get_u32_default(const void *fit, int noffset,
			       const char *prop, u32 def)
{
	const fdt32_t *val;

	val = fdt_getprop(fit, noffset, prop, NULL);
	if (!val)
		return def;

	return fdt32_to_cpu(*val);
}

static int brought_up_all_amp(void *fit, const char *fit_uname_cfg)
{
	const char *uname, *desc;
	u32 cpu, aarch64, hyp;
	u32 thumb, us, secure = 0;
	u32 pe_state, entry, load;
	u32 reserved_mem[2] = { 0, 0, };
	u32 primary_pe_entry = 0;
	int primary_on_linux = 0;
	int conf_noffset, noffset;
	int loadables_index;
	int data_size = -ENODATA;
	u8 arch = -ENODATA;
	int ret;

	aarch64 = IS_ENABLED(CONFIG_ARM64) ? 1 : 0;
	conf_noffset = fit_conf_get_node(fit, fit_uname_cfg);
	for (loadables_index = 0;
	     uname = fdt_stringlist_get(fit, conf_noffset,
			FIT_LOADABLE_PROP, loadables_index, NULL), uname;
	     loadables_index++) {
		noffset = fit_image_get_node(fit, uname);

		desc = fdt_getprop(fit, noffset, "description", NULL);
		cpu = fit_get_u32_default(fit, noffset, "cpu", -ENODATA);
		hyp = fit_get_u32_default(fit, noffset, "hyp", 0);
		thumb = fit_get_u32_default(fit, noffset, "thumb", 0);
		load = fit_get_u32_default(fit, noffset, "load", -ENODATA);
		us = fit_get_u32_default(fit, noffset, "udelay", 0);
		fit_image_get_arch(fit, noffset, &arch);
		fit_image_get_data_size(fit, noffset, &data_size);
		fdtdec_get_int_array(fit, noffset, "memory", reserved_mem, 2);

		if (!desc || cpu == -ENODATA || data_size == -ENODATA ||
		    load == -ENODATA || arch == -ENODATA) {
			AMP_I("property missing!\n");
			return -EINVAL;
		}

		entry = load;
		aarch64 = (arch == IH_ARCH_ARM) ? 0 : 1;
		pe_state = PE_STATE(aarch64, hyp, thumb, secure);

#ifdef DEBUG
		AMP_I("   pe_state: 0x%08x\n", pe_state);
		AMP_I("        cpu: 0x%x\n", cpu);
		AMP_I("    aarch64: %d\n", aarch64);
		AMP_I("        hyp: %d\n", hyp);
		AMP_I("      thumb: %d\n", thumb);
		AMP_I("     secure: %d\n", secure);
		AMP_I("      entry: 0x%08x\n", entry);
		AMP_I("        mem: 0x%08x - 0x%08x\n\n",
		      reserved_mem[0], reserved_mem[0] + reserved_mem[1]);
#endif
		if (!data_size)
			continue;

		if ((read_mpidr() & 0x0fff) == cpu) {
			primary_pe_arch = arch;
			primary_pe_state = pe_state;
			primary_pe_entry = entry;
			primary_on_linux =
				!!fdt_getprop(fit, noffset, "linux-os", NULL);
			continue;
		}

		if (reserved_mem[1]) {
			ret = bidram_reserve_by_name(desc, reserved_mem[0],
						     reserved_mem[1]);
			if (ret) {
				AMP_E("Reserve \"%s\" region at 0x%08x - 0x%08x failed, ret=%d\n",
				      desc, reserved_mem[0],
				      reserved_mem[0] + reserved_mem[1], ret);
				return -ENOMEM;
			}
		} else if (!sysmem_alloc_base_by_name(desc,
					(phys_addr_t)load, data_size)) {
			return -ENXIO;
		}

		AMP_I("Brought up cpu[%x] with state 0x%x, entry 0x%08x ...",
		      cpu, pe_state, entry);

		ret = sip_smc_amp_cfg(AMP_PE_STATE, cpu, pe_state);
		if (ret) {
			printf("amp cfg failed, ret=%d\n", ret);
			return ret;
		}

		ret = psci_cpu_on(cpu, entry);
		if (ret) {
			printf("cpu up failed, ret=%d\n", ret);
			return ret;
		}
		printf("OK\n");
		if (us)
			udelay(us);
	}

	if (!primary_on_linux && primary_pe_entry) {
		flush_dcache_all();
		AMP_I("Brought up cpu[%x, self] with state 0x%x, entry 0x%08x ...",
		      (u32)read_mpidr() & 0x0fff, primary_pe_state, primary_pe_entry);
		cleanup_before_linux();
		printf("OK\n");
		armv8_switch_to_el2(0, 0, 0, primary_pe_state,
				    (u64)primary_pe_entry,
				    aarch64 ? ES_TO_AARCH64 : ES_TO_AARCH32);
	}

	return ret;
}

int amp_cpus_on(void)
{
	struct blk_desc *dev_desc;
	bootm_headers_t images;
	disk_partition_t part;
	void *fit;
	int ret = 0;

	dev_desc = rockchip_get_bootdev();
	if (!dev_desc)
		return -EIO;

	if (part_get_info_by_name(dev_desc, AMP_PART, &part) < 0)
		return -ENODEV;

	fit = sysmem_alloc(MEM_FIT, part.size * part.blksz);
	if (!fit)
		return -ENOMEM;

	if (blk_dread(dev_desc, part.start, part.size, fit) != part.size) {
		ret = -EIO;
		goto out;
	}

	if (fdt_check_header(fit)) {
		printf("No fdt header\n");
		ret = -EINVAL;
		goto out;
	}

	memset(&images, 0, sizeof(images));
	images.fit_uname_cfg = "conf";
	images.fit_hdr_os = fit;
	images.verify = 1;
	ret = boot_get_loadable(0, NULL, &images,
				IH_ARCH_DEFAULT, NULL, NULL);
	if (ret) {
		AMP_E("Failed to load image, ret=%d\n", ret);
		return ret;
	}

	/* flush */
	flush_dcache_all();

	ret = brought_up_all_amp(images.fit_hdr_os, images.fit_uname_cfg);
out:
	sysmem_free((phys_addr_t)fit);

	return ret;
}

int arm64_switch_amp_pe(bootm_headers_t *images)
{
	images->os.arch = primary_pe_arch;
	return primary_pe_state;
}

