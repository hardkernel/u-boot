// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2021 Rockchip Electronics Co., Ltd
 */

#include <common.h>
#include <amp.h>
#include <bidram.h>
#include <boot_rkimg.h>
#include <config.h>
#include <sysmem.h>
#include <asm/gic.h>
#include <asm/io.h>
#include <asm/arch/rockchip_smccc.h>

DECLARE_GLOBAL_DATA_PTR;

/*
 * [Design Principles]
 *
 * [amp.img]
 *	The amp image with FIT format which consists of non-linux firmwares.
 *	Please refer to: driver/cpu/amp.its.
 *
 *	amp.img generation: ./tools/mkimage -f drivers/cpu/amp.its -E -p 0xe00 amp.img
 *
 * [linux]
 *	We still use the traditional solution for a better compatibility:
 *	boot.img/recovery.img with FIT format or Android format.
 *
 *	The developer need add "/configurations/conf/linux" node to configure:
 *	description, arch, cpu, thumb, hyp, udelay(optional) properties.
 *	The addresses depend on U-Boot: kernel_addr_r, fdt_addr_r and
 *	ramdisk_addr_r. Please refer to: driver/cpu/amp.its.
 *
 * [memory management]
 *	U-Boot is not responsible for memory distribution/fixup any more, please
 *	handle this on kernel dts "/memory".
 *
 * [trust]
 *	The AMP feature requires trust support.
 */

#define AMP_PART		"amp"
#define FIT_HEADER_SIZE		SZ_4K

#define gicd_readl(offset)	readl((void *)GICD_BASE + (offset))
#define gicd_writel(v, offset)	writel(v, (void *)GICD_BASE + (offset))
#define ROCKCHIP_AMP_NODE		"/rockchip-amp"
#define ROCKCHIP_AMP_CPUS_NODE		"/rockchip-amp/amp-cpus"

typedef struct boot_args {
	ulong arg0;
	ulong arg1;
	ulong arg2;
	ulong arg3;
} boot_args_t;

typedef struct boot_cpu {
	u32 arch;
	u32 state;
	u32 entry;
	u32 linux_os;
	u32 boot_on;
} boot_cpu_t;

static boot_cpu_t g_bootcpu;
static u32 os_amp_dispatcher_cpu[8];

static u32 fit_get_u32_default(const void *fit, int noffset,
			       const char *prop, u32 def)
{
	const fdt32_t *val;

	val = fdt_getprop(fit, noffset, prop, NULL);
	if (!val)
		return def;

	return fdt32_to_cpu(*val);
}

static int parse_os_amp_dispatcher(void)
{
	const void *fdt = gd->fdt_blob;
	int noffset, cpu, i = 0;
	u64 mpidr;

	memset(os_amp_dispatcher_cpu, 0xff, sizeof(os_amp_dispatcher_cpu));

	noffset = fdt_path_offset(fdt, ROCKCHIP_AMP_NODE);
	if (noffset < 0)
		return 0;

	if (!fdtdec_get_is_enabled(fdt, noffset))
		return 0;

	noffset = fdt_path_offset(fdt, ROCKCHIP_AMP_CPUS_NODE);
	if (noffset < 0)
		return 0;

	fdt_for_each_subnode(cpu, fdt, noffset) {
		mpidr = fdtdec_get_uint64(fdt, cpu, "id", 0xffffffff);
		if (mpidr == 0xffffffff) /* invalid */
			continue;

		os_amp_dispatcher_cpu[i++] = mpidr;
		AMP_I("cpu[%llx] belong to os amp-dispatcher\n", mpidr);
	}

	return 0;
}

static int load_linux_for_nonboot_cpu(u32 cpu, u32 aarch64, u32 load,
				      u32 *entry, boot_args_t *args)
{
	static const char *boot_cmd[] = {
		"boot_fit", "boot_android ${devtype} ${devnum}" };
	int i, ret;

	env_set_hex("bootm_states_unmask", BOOTM_STATE_OS_GO);
	for (i = 0; i < ARRAY_SIZE(boot_cmd); i++) {
		ret = run_command(boot_cmd[i], 0);
		if (!ret)
			break;
	}
	env_set("bootm_states_unmask", NULL);
	if (ret) {
		AMP_E("Load linux failed, ret=%d\n", ret);
		return ret;
	}

	/* linux boot args */
	if (aarch64) {
		args->arg0 = (ulong)gd->fdt_blob;
		args->arg1 = 0;
		args->arg2 = 0;
	} else {
		args->arg0 = 0;
		args->arg1 = 0;
		args->arg2 = (ulong)gd->fdt_blob;
	}

	/* don't need call cleanup_before_linux() as this nonboot cpu is clean */
	board_quiesce_devices(&images);
	flush_dcache_all();

	/* fixup: ramdisk/fdt/entry depend on U-Boot */
	*entry = (u32)images.ep;

	return 0;
}

static int is_default_pe_state(u32 pe_state)
{
#ifdef CONFIG_ARM64
	return (pe_state == PE_STATE(1, 1, 0, 0));
#else
	return (pe_state == PE_STATE(0, 0, 0, 0));
#endif
}

static void setup_sync_bits_for_linux(void)
{
	u32 val, num_irq, offset;

	val = gicd_readl(GICD_CTLR);
	val &= ~0x3;
	gicd_writel(val, GICD_CTLR);

	num_irq = 32 * ((gicd_readl(GICD_TYPER) & 0x1F) + 1);
	offset = ((num_irq - 1) / 4) * 4;
	gicd_writel(0x0, GICD_IPRIORITYRn + offset);
}

static int smc_cpu_on(u32 cpu, u32 pe_state, u32 entry,
		      boot_args_t *args, bool is_linux)
{
	int ret;

	AMP_I("Brought up cpu[%x] with state 0x%x, entry 0x%08x ...",
	      cpu, pe_state, entry);

	/* if target pe state is default arch state, power up cpu directly */
	if (is_default_pe_state(pe_state))
		goto finish;

	ret = sip_smc_amp_cfg(AMP_PE_STATE, cpu, pe_state, 0);
	if (ret) {
		AMP_E("smc pe-state, ret=%d\n", ret);
		return ret;
	}

	/* only linux needs boot args */
	if (!is_linux)
		goto finish;

	ret = sip_smc_amp_cfg(AMP_BOOT_ARG01, cpu, args->arg0, args->arg1);
	if (ret) {
		AMP_E("smc boot arg01, ret=%d\n", ret);
		return ret;
	}

	ret = sip_smc_amp_cfg(AMP_BOOT_ARG23, cpu, args->arg2, args->arg3);
	if (ret) {
		AMP_E("smc boot arg23, ret=%d\n", ret);
		return ret;
	}

finish:
	ret = psci_cpu_on(cpu, entry);
	if (ret) {
		printf("cpu up failed, ret=%d\n", ret);
		return ret;
	}
	printf("OK\n");

	return 0;
}

__weak int fit_standalone_release(char *id, uintptr_t entry_point)
{
	return 0;
}

static int standalone_handler(const char *id, u32 entry_point, int data_size)
{
	int ret;

	if (!sysmem_alloc_base_by_name(id,
			(phys_addr_t)entry_point, data_size))
		return -ENXIO;

	printf("Handle standalone: '%s' at 0x%08x ...", id, entry_point);

	ret = fit_standalone_release((char *)id, entry_point);
	if (ret) {
		printf("failed, ret=%d\n", ret);
		return ret;
	}
	printf("OK\n");

	return 0;
}

static int brought_up_amp(void *fit, int noffset,
			  boot_cpu_t *bootcpu, int is_linux)
{
	const char *desc;
	boot_args_t args;
	u32 cpu, aarch64, hyp;
	u32 load, load_c, thumb, us;
	u32 pe_state, entry;
	int boot_on;
	int data_size;
	int i, ret;
	u8 type = -ENODATA;
	u8 arch = -ENODATA;

	desc = fdt_getprop(fit, noffset, "description", NULL);
	cpu = fit_get_u32_default(fit, noffset, "cpu", -ENODATA);
	hyp = fit_get_u32_default(fit, noffset, "hyp", 0);
	thumb = fit_get_u32_default(fit, noffset, "thumb", 0);
	entry = load = fit_get_u32_default(fit, noffset, "load", -ENODATA);
	load_c = fit_get_u32_default(fit, noffset, "load_c", -ENODATA);
	us = fit_get_u32_default(fit, noffset, "udelay", 0);
	boot_on = fit_get_u32_default(fit, noffset, "boot-on", 1);
	fit_image_get_arch(fit, noffset, &arch);
	fit_image_get_type(fit, noffset, &type);
	fit_image_get_data_size(fit, noffset, &data_size);
	memset(&args, 0, sizeof(args));

	/* standalone is simple, just handle it and then exit. Allow failure */
	if (type == IH_TYPE_STANDALONE) {
		if (!desc || load == -ENODATA) {
			AMP_E("standalone: \"desc\" or \"load\" property missing!\n");
			goto exit;
		}
		standalone_handler(desc, load, data_size);
		goto exit;
	}

	if (!desc || cpu == -ENODATA || arch == -ENODATA || type == -ENODATA ||
	    (load == -ENODATA && !is_linux)) {
		AMP_E("Property missing!\n");
		return -EINVAL;
	}

	if (is_linux) {
		if (load != -ENODATA)
			env_set_hex("kernel_addr_r", load);
		if (load_c != -ENODATA)
			env_set_hex("kernel_addr_c", load_c);
	}

	aarch64 = (arch == IH_ARCH_ARM) ? 0 : 1;
	pe_state = PE_STATE(aarch64, hyp, thumb, 0);

#ifdef DEBUG
	AMP_I("       desc: %s\n", desc);
	AMP_I("        cpu: 0x%x\n", cpu);
	AMP_I("    aarch64: %d\n", aarch64);
	AMP_I("        hyp: %d\n", hyp);
	AMP_I("      thumb: %d\n", thumb);
	AMP_I("       load: 0x%08x\n", load);
	AMP_I("     load_c: 0x%08x\n", load_c);
	AMP_I("   pe_state: 0x%08x\n", pe_state);
	AMP_I("   linux-os: %d\n\n", is_linux);
#endif

	/* If os amp-dispatcher owns this cpu, don't boot it */
	for (i = 0; i < ARRAY_SIZE(os_amp_dispatcher_cpu); i++) {
		if (cpu == os_amp_dispatcher_cpu[i]) {
			boot_on = 0;
			break;
		}
	}

	/* this cpu is boot cpu ? */
	if ((read_mpidr() & 0x0fff) == cpu) {
		bootcpu->arch = arch;
		bootcpu->entry = entry;
		bootcpu->state = pe_state;
		bootcpu->linux_os = is_linux;
		bootcpu->boot_on = boot_on;
		return 0;
	}

	/* === only nonboot cpu can reach here === */

	/* load or check */
	if (is_linux) {
		ret = load_linux_for_nonboot_cpu(cpu,
				aarch64, load, &entry, &args);
		if (ret)
			return ret;
		/*
		 * Must setup before jump to linux.
		 * This is an appointment on RK amp solution to handle
		 * GIC configure competition.
		 */
		setup_sync_bits_for_linux();
	} else {
		if (!sysmem_alloc_base_by_name(desc,
				(phys_addr_t)load, data_size))
			return -ENXIO;
	}

	if (!boot_on)
		return 0;

	/* boot now */
	ret = smc_cpu_on(cpu, pe_state, entry, &args, is_linux);
	if (ret)
		return ret;
exit:
	if (us)
		udelay(us);

	return 0;
}

static int brought_up_all_amp(void *fit, const char *fit_uname_cfg)
{
	int loadables_index;
	int linux_noffset;
	int conf_noffset;
	int cpu_noffset;
	int ret;
	const char *uname;

	conf_noffset = fit_conf_get_node(fit, fit_uname_cfg);
	if (conf_noffset < 0)
		return conf_noffset;

	/*
	 * If boot cpu is not assigned in amp.img, the default value 0 makes
	 * boot cpu power down itself in final process, so we must initial it.
	 */
	g_bootcpu.boot_on = 1;

	linux_noffset = fdt_subnode_offset(fit, conf_noffset, "linux");
	if (linux_noffset > 0) {
		ret = brought_up_amp(fit, linux_noffset, &g_bootcpu, 1);
		if (ret)
			return ret;
	}

	for (loadables_index = 0;
	     uname = fdt_stringlist_get(fit, conf_noffset,
			FIT_LOADABLE_PROP, loadables_index, NULL), uname;
	     loadables_index++) {
		cpu_noffset = fit_image_get_node(fit, uname);
		if (cpu_noffset < 0)
			return cpu_noffset;

		ret = brought_up_amp(fit, cpu_noffset, &g_bootcpu, 0);
		if (ret)
			return ret;
	}

	/* === only boot cpu can reach here === */

	if (!g_bootcpu.boot_on) {
		AMP_I("Primary cpu[%x, self] with state 0x%x, entry 0x%08x ... Power down!\n",
		      (u32)read_mpidr() & 0x0fff, g_bootcpu.state, g_bootcpu.entry);
		dsb();
		isb();
		/* make sure I am off before os amp-dispatcher probe */
		psci_cpu_off(0);

		/* Never reach here */
		while (1) {
			AMP_E("Primary cpu[%x, self] power down failed\n",
			      (u32)read_mpidr());
			__asm("wfe");
		}
	}

	if (!g_bootcpu.linux_os && g_bootcpu.entry) {
		flush_dcache_all();
		AMP_I("Brought up primary cpu[%x, self] with state 0x%x, entry 0x%08x ...",
		      (u32)read_mpidr() & 0x0fff, g_bootcpu.state, g_bootcpu.entry);
		cleanup_before_linux();
		printf("OK\n");
#ifdef CONFIG_ARM64
		armv8_switch_to_el2(0, 0, 0, g_bootcpu.state, (u64)g_bootcpu.entry,
		     g_bootcpu.arch == IH_ARCH_ARM ? ES_TO_AARCH32 : ES_TO_AARCH64);
#else
		void (*armv7_entry)(void);

		armv7_entry = (void (*)(void))g_bootcpu.entry;
		armv7_entry();
#endif
	}

	/* return: boot cpu continue to boot linux */
	return 0;
}

int amp_cpus_on(void)
{
	struct blk_desc *dev_desc;
	bootm_headers_t images;
	disk_partition_t part;
	void *hdr, *fit;
	int offset, cnt;
	int totalsize;
	int ret = 0;

	dev_desc = rockchip_get_bootdev();
	if (!dev_desc)
		return -EIO;

	if (part_get_info_by_name(dev_desc, AMP_PART, &part) < 0)
		return -ENODEV;

	hdr = memalign(ARCH_DMA_MINALIGN, FIT_HEADER_SIZE);
	if (!hdr)
		return -ENOMEM;

	/* get totalsize */
	offset = part.start;
	cnt = DIV_ROUND_UP(FIT_HEADER_SIZE, part.blksz);
	if (blk_dread(dev_desc, offset, cnt, hdr) != cnt) {
		ret = -EIO;
		goto out2;
	}

	if (fdt_check_header(hdr)) {
		AMP_E("Not fit\n");
		ret = -EINVAL;
		goto out2;
	}

	if (fit_get_totalsize(hdr, &totalsize)) {
		AMP_E("No totalsize\n");
		ret = -EINVAL;
		goto out2;
	}

	/* load image */
	fit = memalign(ARCH_DMA_MINALIGN, ALIGN(totalsize, part.blksz));
	if (!fit) {
		printf("No memory\n");
		ret = -ENOMEM;
		goto out2;
	}

	memcpy(fit, hdr, FIT_HEADER_SIZE);

	offset += cnt;
	cnt = DIV_ROUND_UP(totalsize, part.blksz) - cnt;
	if (blk_dread(dev_desc, offset, cnt, fit + FIT_HEADER_SIZE) != cnt) {
		ret = -EIO;
		goto out1;
	}

	ret = parse_os_amp_dispatcher();
	if (ret < 0) {
		ret = -EINVAL;
		goto out1;
	}

	/* Load loadables */
	memset(&images, 0, sizeof(images));
	images.fit_uname_cfg = "conf";
	images.fit_hdr_os = fit;
	images.verify = 1;
	ret = boot_get_loadable(0, NULL, &images, IH_ARCH_DEFAULT, NULL, NULL);
	if (ret) {
		AMP_E("Load loadables, ret=%d\n", ret);
		goto out1;
	}
	flush_dcache_all();

	/* Wakeup */
	ret = brought_up_all_amp(images.fit_hdr_os, images.fit_uname_cfg);
	if (ret)
		AMP_E("Brought up amps, ret=%d\n", ret);
out1:
	free(fit);
out2:
	free(hdr);

	return ret;
}

int arm64_switch_amp_pe(bootm_headers_t *images)
{
	images->os.arch = g_bootcpu.arch;
	return g_bootcpu.state;
}

