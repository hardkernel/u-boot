/*
 * (C) Copyright 2010
 * Texas Instruments, <www.ti.com>
 *
 * Aneesh V <aneesh@ti.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <dm.h>
#include <spl.h>
#include <asm/sections.h>
#include <asm/u-boot.h>
#include <nand.h>
#include <fat.h>
#include <version.h>
#include <image.h>
#include <malloc.h>
#include <mp_boot.h>
#include <dm/root.h>
#include <linux/compiler.h>
#include <fdt_support.h>

DECLARE_GLOBAL_DATA_PTR;

#ifndef CONFIG_SYS_UBOOT_START
#define CONFIG_SYS_UBOOT_START	CONFIG_SYS_TEXT_BASE
#endif
#ifndef CONFIG_SYS_MONITOR_LEN
/* Unknown U-Boot size, let's assume it will not be more than 200 KB */
#define CONFIG_SYS_MONITOR_LEN	(200 * 1024)
#endif

u32 *boot_params_ptr = NULL;

/* Define board data structure */
static bd_t bdata __attribute__ ((section(".data")));

/*
 * Board-specific Platform code can reimplement show_boot_progress () if needed
 */
__weak void show_boot_progress(int val) {}

/*
 * Default function to determine if u-boot or the OS should
 * be started. This implementation always returns 1.
 *
 * Please implement your own board specific funcion to do this.
 *
 * RETURN
 * 0 to not start u-boot
 * positive if u-boot should start
 */
#ifdef CONFIG_SPL_OS_BOOT
__weak int spl_start_uboot(void)
{
	puts("SPL: Please implement spl_start_uboot() for your board\n");
	puts("SPL: Direct Linux boot not active!\n");
	return 1;
}

/* weak default platform specific function to initialize
 * dram banks
 */
__weak int dram_init_banksize(void)
{
	return 0;
}

/*
 * Weak default function for arch specific zImage check. Return zero
 * and fill start and end address if image is recognized.
 */
int __weak bootz_setup(ulong image, ulong *start, ulong *end)
{
	 return 1;
}
#endif

/* Weak default function for arch/board-specific fixups to the spl_image_info */
void __weak spl_perform_fixups(struct spl_image_info *spl_image)
{
}

/* Get the next stage process */
__weak void spl_next_stage(struct spl_image_info *spl)
{
	spl->next_stage = SPL_NEXT_STAGE_UBOOT;
}

/* Weak default function for arch/board-specific preppare before jumping */
int __weak spl_board_prepare_for_jump(struct spl_image_info *spl_image)
{
	return 0;
}

/* Fix storages, like iomux  */
__weak void spl_board_storages_fixup(struct spl_image_loader *loader)
{
	/* Nothing to do! */
}

void spl_fixup_fdt(void)
{
#if defined(CONFIG_SPL_OF_LIBFDT) && defined(CONFIG_SYS_SPL_ARGS_ADDR)
	void *fdt_blob = (void *)CONFIG_SYS_SPL_ARGS_ADDR;
	int err;

	err = fdt_check_header(fdt_blob);
	if (err < 0) {
		printf("fdt_root: %s\n", fdt_strerror(err));
		return;
	}

	/* fixup the memory dt node */
	err = fdt_shrink_to_minimum(fdt_blob, 0);
	if (err == 0) {
		printf("spl: fdt_shrink_to_minimum err - %d\n", err);
		return;
	}

	err = arch_fixup_fdt(fdt_blob);
	if (err) {
		printf("spl: arch_fixup_fdt err - %d\n", err);
		return;
	}
#endif
}

/*
 * Weak default function for board specific cleanup/preparation before
 * Linux boot. Some boards/platforms might not need it, so just provide
 * an empty stub here.
 */
__weak void spl_board_prepare_for_linux(void)
{
	/* Nothing to do! */
}

__weak void spl_board_prepare_for_boot(void)
{
	/* Nothing to do! */
}

void spl_set_header_raw_uboot(struct spl_image_info *spl_image)
{
	spl_image->size = CONFIG_SYS_MONITOR_LEN;
	spl_image->entry_point = CONFIG_SYS_UBOOT_START;
	spl_image->load_addr = CONFIG_SYS_TEXT_BASE;
	spl_image->os = IH_OS_U_BOOT;
	spl_image->name = "U-Boot";
}

int spl_parse_image_header(struct spl_image_info *spl_image,
			   const struct image_header *header)
{
	if (image_get_magic(header) == IH_MAGIC) {
#ifdef CONFIG_SPL_LEGACY_IMAGE_SUPPORT
		u32 header_size = sizeof(struct image_header);

		if (spl_image->flags & SPL_COPY_PAYLOAD_ONLY) {
			/*
			 * On some system (e.g. powerpc), the load-address and
			 * entry-point is located at address 0. We can't load
			 * to 0-0x40. So skip header in this case.
			 */
			spl_image->load_addr = image_get_load(header);
			spl_image->entry_point = image_get_ep(header);
			spl_image->size = image_get_data_size(header);
		} else {
			spl_image->entry_point = image_get_load(header);
			/* Load including the header */
			spl_image->load_addr = spl_image->entry_point -
				header_size;
			spl_image->size = image_get_data_size(header) +
				header_size;
		}
		spl_image->os = image_get_os(header);
		spl_image->name = image_get_name(header);
		debug("spl: payload image: %.*s load addr: 0x%lx size: %d\n",
			IH_NMLEN, spl_image->name,
			spl_image->load_addr, spl_image->size);
#else
		/* LEGACY image not supported */
		debug("Legacy boot image support not enabled, proceeding to other boot methods\n");
		return -EINVAL;
#endif
	} else {
#ifdef CONFIG_SPL_PANIC_ON_RAW_IMAGE
		/*
		 * CONFIG_SPL_PANIC_ON_RAW_IMAGE is defined when the
		 * code which loads images in SPL cannot guarantee that
		 * absolutely all read errors will be reported.
		 * An example is the LPC32XX MLC NAND driver, which
		 * will consider that a completely unreadable NAND block
		 * is bad, and thus should be skipped silently.
		 */
		panic("** no mkimage signature but raw image not supported");
#endif

#ifdef CONFIG_SPL_OS_BOOT
		ulong start, end;

		if (!bootz_setup((ulong)header, &start, &end)) {
			spl_image->name = "Linux";
			spl_image->os = IH_OS_LINUX;
			spl_image->load_addr = CONFIG_SYS_LOAD_ADDR;
			spl_image->entry_point = CONFIG_SYS_LOAD_ADDR;
			spl_image->size = end - start;
			debug("spl: payload zImage, load addr: 0x%lx size: %d\n",
			      spl_image->load_addr, spl_image->size);
			return 0;
		}
#endif

#ifdef CONFIG_SPL_RAW_IMAGE_SUPPORT
		/* Signature not found - assume u-boot.bin */
		debug("mkimage signature not found - ih_magic = %x\n",
			header->ih_magic);
		spl_set_header_raw_uboot(spl_image);
#else
		/* RAW image not supported, proceed to other boot methods. */
		debug("Raw boot image support not enabled, proceeding to other boot methods\n");
		return -EINVAL;
#endif
	}

	return 0;
}

__weak void __noreturn jump_to_image_no_args(struct spl_image_info *spl_image)
{
	typedef void __noreturn (*image_entry_noargs_t)(void);

	image_entry_noargs_t image_entry =
		(image_entry_noargs_t)spl_image->entry_point;

	debug("image entry point: 0x%lX\n", spl_image->entry_point);
	image_entry();
}

/*
 * 64-bit: No special operation.
 *
 * 32-bit: Initial gd->bd->bi_dram[] to active dcache attr of memory.
 *	   Assuming 256MB is enough for SPL(MMU still maps 4GB size).
 */
#ifndef CONFIG_SPL_SYS_DCACHE_OFF
static int spl_dcache_enable(void)
{
	bool free_bd = false;

#ifndef CONFIG_ARM64
	if (!gd->bd) {
		gd->bd = calloc(1, sizeof(bd_t));
		if (!gd->bd) {
			debug("spl: no bd_t memory\n");
			return -ENOMEM;
		}
		gd->bd->bi_dram[0].start = CONFIG_SYS_SDRAM_BASE;
		gd->bd->bi_dram[0].size  = SZ_256M;
		free_bd = true;
	}
#endif
	/* TLB memory should be SZ_16K base align and 4KB end align */
	gd->arch.tlb_size = PGTABLE_SIZE;
	gd->arch.tlb_addr = (ulong)memalign(SZ_16K, ALIGN(PGTABLE_SIZE, SZ_4K));
	if (!gd->arch.tlb_addr) {
		debug("spl: no TLB memory\n");
		return -ENOMEM;
	}

	dcache_enable();
	if (free_bd)
		free(gd->bd);

	return 0;
}
#endif

static int spl_common_init(bool setup_malloc)
{
	int ret;

	debug("spl_early_init()\n");

#if CONFIG_VAL(SYS_MALLOC_F_LEN)
	if (setup_malloc) {
#ifdef CONFIG_MALLOC_F_ADDR
		gd->malloc_base = CONFIG_MALLOC_F_ADDR;
#endif
		gd->malloc_limit = CONFIG_VAL(SYS_MALLOC_F_LEN);
		gd->malloc_ptr = 0;
	}
#endif

	/*
	 * setup D-cache as early as possible after malloc setup
	 * I-cache has been setup at early assembly code by default.
	 */
#ifndef CONFIG_SPL_SYS_DCACHE_OFF
	ret = spl_dcache_enable();
	if (ret) {
		debug("spl_dcache_enable() return error %d\n", ret);
		return ret;
	}
#endif
	ret = bootstage_init(true);
	if (ret) {
		debug("%s: Failed to set up bootstage: ret=%d\n", __func__,
		      ret);
		return ret;
	}
	bootstage_mark_name(BOOTSTAGE_ID_START_SPL, "spl");
	if (CONFIG_IS_ENABLED(OF_CONTROL) && !CONFIG_IS_ENABLED(OF_PLATDATA)) {
		ret = fdtdec_setup();
		if (ret) {
			debug("fdtdec_setup() returned error %d\n", ret);
			return ret;
		}
	}
	if (CONFIG_IS_ENABLED(DM)) {
		bootstage_start(BOOTSTATE_ID_ACCUM_DM_SPL, "dm_spl");
		/* With CONFIG_SPL_OF_PLATDATA, bring in all devices */
		ret = dm_init_and_scan(!CONFIG_IS_ENABLED(OF_PLATDATA));
		bootstage_accum(BOOTSTATE_ID_ACCUM_DM_SPL);
		if (ret) {
			debug("dm_init_and_scan() returned error %d\n", ret);
			return ret;
		}
	}

	return 0;
}

#if !defined(CONFIG_SPL_SKIP_RELOCATE) && !defined(CONFIG_TPL_BUILD)
static void spl_setup_relocate(void)
{
	gd->relocaddr = CONFIG_SPL_RELOC_TEXT_BASE;
	gd->new_gd = (gd_t *)gd;
	gd->start_addr_sp = gd->relocaddr;
	gd->fdt_size = ALIGN(fdt_totalsize(gd->fdt_blob) + 0x1000, 32);

	gd->start_addr_sp -= gd->fdt_size;
	gd->new_fdt = (void *)gd->start_addr_sp;
	memcpy(gd->new_fdt, gd->fdt_blob, gd->fdt_size);
	gd->fdt_blob = gd->new_fdt;

	gd->reloc_off = gd->relocaddr - (unsigned long)__image_copy_start;
}
#else
static void spl_setup_relocate(void)
{

}
#endif

void spl_set_bd(void)
{
	if (!gd->bd)
		gd->bd = &bdata;
}

int spl_early_init(void)
{
	int ret;

	ret = spl_common_init(true);
	if (ret)
		return ret;
	gd->flags |= GD_FLG_SPL_EARLY_INIT;

	spl_setup_relocate();

	return 0;
}

int spl_init(void)
{
	int ret;
	bool setup_malloc = !(IS_ENABLED(CONFIG_SPL_STACK_R) &&
			IS_ENABLED(CONFIG_SPL_SYS_MALLOC_SIMPLE));

	if (!(gd->flags & GD_FLG_SPL_EARLY_INIT)) {
		ret = spl_common_init(setup_malloc);
		if (ret)
			return ret;
	}
	gd->flags |= GD_FLG_SPL_INIT;

	return 0;
}

#ifndef BOOT_DEVICE_NONE
#define BOOT_DEVICE_NONE 0xdeadbeef
#endif

__weak void board_boot_order(u32 *spl_boot_list)
{
	spl_boot_list[0] = spl_boot_device();
}

static struct spl_image_loader *spl_ll_find_loader(uint boot_device)
{
	struct spl_image_loader *drv =
		ll_entry_start(struct spl_image_loader, spl_image_loader);
	const int n_ents =
		ll_entry_count(struct spl_image_loader, spl_image_loader);
	struct spl_image_loader *entry;

	for (entry = drv; entry != drv + n_ents; entry++) {
		if (boot_device == entry->boot_device)
			return entry;
	}

	/* Not found */
	return NULL;
}

static int spl_load_image(struct spl_image_info *spl_image,
			  struct spl_image_loader *loader)
{
	struct spl_boot_device bootdev;

	bootdev.boot_device = loader->boot_device;
	bootdev.boot_device_name = NULL;

	return loader->load_image(spl_image, &bootdev);
}

/**
 * boot_from_devices() - Try loading an booting U-Boot from a list of devices
 *
 * @spl_image: Place to put the image details if successful
 * @spl_boot_list: List of boot devices to try
 * @count: Number of elements in spl_boot_list
 * @return 0 if OK, -ve on error
 */
static int boot_from_devices(struct spl_image_info *spl_image,
			     u32 spl_boot_list[], int count)
{
	int i;

	for (i = 0; i < count && spl_boot_list[i] != BOOT_DEVICE_NONE; i++) {
		struct spl_image_loader *loader;

		loader = spl_ll_find_loader(spl_boot_list[i]);
#if defined(CONFIG_SPL_SERIAL_SUPPORT) && defined(CONFIG_SPL_LIBCOMMON_SUPPORT)
		if (loader)
			printf("Trying to boot from %s\n", loader->name);
		else
			puts("SPL: Unsupported Boot Device!\n");
#endif
		if (loader && !spl_load_image(spl_image, loader)) {
			spl_image->boot_device = spl_boot_list[i];
			return 0;
		}

		spl_board_storages_fixup(loader);
	}

	return -ENODEV;
}

#if defined(CONFIG_DM) && !defined(CONFIG_SPL_SKIP_RELOCATE) && !defined(CONFIG_TPL_BUILD)
static int spl_initr_dm(void)
{
	int ret;

	/* Save the pre-reloc driver model and start a new one */
	gd->dm_root_f = gd->dm_root;
	gd->dm_root = NULL;
	bootstage_start(BOOTSTATE_ID_ACCUM_DM_R, "dm_r");
	ret = dm_init_and_scan(false);
	bootstage_accum(BOOTSTATE_ID_ACCUM_DM_R);
	if (ret)
		return ret;

#if defined(CONFIG_TIMER)
	gd->timer = NULL;
#endif
	serial_init();

	return 0;
}
#else
static int spl_initr_dm(void)
{
	return 0;
}
#endif

#if defined(CONFIG_SPL_KERNEL_BOOT) && !defined(CONFIG_ARM64)
static void boot_jump_linux(struct spl_image_info *spl_image)
{
	void (*kernel_entry)(int zero, int arch, ulong params);

	printf("Jumping to %s(0x%08lx)\n", "Kernel",
	       (ulong)spl_image->entry_point_os);
	spl_cleanup_before_jump(spl_image);
	kernel_entry = (void (*)(int, int, ulong))spl_image->entry_point_os;
	kernel_entry(0, 0, (ulong)spl_image->fdt_addr);
}
#endif

void board_init_r(gd_t *dummy1, ulong dummy2)
{
	u32 spl_boot_list[] = {
		BOOT_DEVICE_NONE,
		BOOT_DEVICE_NONE,
		BOOT_DEVICE_NONE,
		BOOT_DEVICE_NONE,
		BOOT_DEVICE_NONE,
	};
	struct spl_image_info spl_image;

	debug(">>spl:board_init_r()\n");

	spl_initr_dm();

	spl_set_bd();

#ifdef CONFIG_SPL_OS_BOOT
	dram_init_banksize();
#endif

#if defined(CONFIG_SYS_SPL_MALLOC_START)
	mem_malloc_init(CONFIG_SYS_SPL_MALLOC_START,
			CONFIG_SYS_SPL_MALLOC_SIZE);
	gd->flags |= GD_FLG_FULL_MALLOC_INIT;
#endif
	if (!(gd->flags & GD_FLG_SPL_INIT)) {
		if (spl_init())
			hang();
	}
#if !defined(CONFIG_PPC) && !defined(CONFIG_ARCH_MX6)
	/*
	 * timer_init() does not exist on PPC systems. The timer is initialized
	 * and enabled (decrementer) in interrupt_init() here.
	 */
	timer_init();
#endif

#if CONFIG_IS_ENABLED(BOARD_INIT)
	spl_board_init();
#endif

	memset(&spl_image, '\0', sizeof(spl_image));

#ifdef CONFIG_MP_BOOT
	mpb_init_x(0);
#endif

#if CONFIG_IS_ENABLED(ATF)
	/*
	 * Bl32 ep is optional, initial it as an invalid value.
	 * BL33 ep is mandatory, but initial it as a default value is better.
	 */
	spl_image.entry_point_bl32 = -1;
	spl_image.entry_point_bl33 = CONFIG_SYS_TEXT_BASE;
#endif

#if CONFIG_IS_ENABLED(OPTEE)
	/* default address */
	spl_image.entry_point_os = CONFIG_SYS_TEXT_BASE;
#endif

#ifdef CONFIG_SYS_SPL_ARGS_ADDR
	spl_image.arg = (void *)CONFIG_SYS_SPL_ARGS_ADDR;
#endif
	spl_image.boot_device = BOOT_DEVICE_NONE;
	board_boot_order(spl_boot_list);
	spl_next_stage(&spl_image);
	if (boot_from_devices(&spl_image, spl_boot_list,
			      ARRAY_SIZE(spl_boot_list))) {
		puts("SPL: failed to boot from all boot devices\n");
		hang();
	}

	spl_perform_fixups(&spl_image);

#ifdef CONFIG_MP_BOOT
	mpb_init_x(2);
#endif

#ifdef CONFIG_CPU_V7M
	spl_image.entry_point |= 0x1;
#endif
	switch (spl_image.os) {
	case IH_OS_U_BOOT:
		debug("Jumping to U-Boot\n");
		spl_cleanup_before_jump(&spl_image);
		break;
#if CONFIG_IS_ENABLED(ATF)
	case IH_OS_ARM_TRUSTED_FIRMWARE:
		printf("Jumping to %s(0x%08lx) via ARM Trusted Firmware(0x%08lx)\n",
		       spl_image.next_stage == SPL_NEXT_STAGE_UBOOT ? "U-Boot" :
		       (spl_image.next_stage == SPL_NEXT_STAGE_KERNEL ? "Kernel" : "Unknown"),
		       (ulong)spl_image.entry_point_bl33,
		       (ulong)spl_image.entry_point);
		spl_invoke_atf(&spl_image);
		break;
#endif
#if CONFIG_IS_ENABLED(OPTEE)
	case IH_OS_OP_TEE:
		printf("Jumping to %s(0x%08lx) via OP-TEE(0x%08lx)\n",
		       spl_image.next_stage == SPL_NEXT_STAGE_UBOOT ? "U-Boot" :
		       (spl_image.next_stage == SPL_NEXT_STAGE_KERNEL ? "Kernel" : "Unknown"),
		       (ulong)spl_image.entry_point_os,
		       (ulong)spl_image.entry_point);
		spl_cleanup_before_jump(&spl_image);
		spl_optee_entry(NULL, (void *)spl_image.entry_point_os,
				(void *)spl_image.fdt_addr,
				(void *)spl_image.entry_point);
		break;
#endif
	case IH_OS_LINUX:
#ifdef CONFIG_SPL_OS_BOOT
		debug("Jumping to Linux\n");
		spl_fixup_fdt();
		spl_board_prepare_for_linux();
		jump_to_image_linux(&spl_image);
#elif defined(CONFIG_SPL_KERNEL_BOOT) && !defined(CONFIG_ARM64)
		boot_jump_linux(&spl_image);
#endif
		break;
	default:
		debug("Unsupported OS image.. Jumping nevertheless..\n");
	}
#if CONFIG_VAL(SYS_MALLOC_F_LEN) && !defined(CONFIG_SYS_SPL_MALLOC_SIZE)
	debug("SPL malloc() used %#lx bytes (%ld KB)\n", gd->malloc_ptr,
	      gd->malloc_ptr / 1024);
#endif

	debug("loaded - jumping to U-Boot...\n");
#ifdef CONFIG_BOOTSTAGE_STASH
	int ret;

	bootstage_mark_name(BOOTSTAGE_ID_END_SPL, "end_spl");
	ret = bootstage_stash((void *)CONFIG_BOOTSTAGE_STASH_ADDR,
			      CONFIG_BOOTSTAGE_STASH_SIZE);
	if (ret)
		debug("Failed to stash bootstage: err=%d\n", ret);
#endif

	printf("Jumping to U-Boot(0x%08lx)\n", spl_image.entry_point);
	spl_board_prepare_for_boot();
	jump_to_image_no_args(&spl_image);
}

/*
 * This requires UART clocks to be enabled.  In order for this to work the
 * caller must ensure that the gd pointer is valid.
 */
void preloader_console_init(void)
{
	gd->baudrate = CONFIG_BAUDRATE;

	serial_init();		/* serial communications setup */

	gd->have_console = 1;

#ifdef BUILD_SPL_TAG
	puts("\nU-Boot SPL " PLAIN_VERSION " (" U_BOOT_DATE " - " \
			U_BOOT_TIME "), fwver: "BUILD_SPL_TAG"\n");
#else
	puts("\nU-Boot SPL " PLAIN_VERSION " (" U_BOOT_DATE " - " \
			U_BOOT_TIME ")\n");
#endif
#ifdef CONFIG_SPL_DISPLAY_PRINT
	spl_display_print();
#endif
}

/**
 * spl_relocate_stack_gd() - Relocate stack ready for board_init_r() execution
 *
 * Sometimes board_init_f() runs with a stack in SRAM but we want to use SDRAM
 * for the main board_init_r() execution. This is typically because we need
 * more stack space for things like the MMC sub-system.
 *
 * This function calculates the stack position, copies the global_data into
 * place, sets the new gd (except for ARM, for which setting GD within a C
 * function may not always work) and returns the new stack position. The
 * caller is responsible for setting up the sp register and, in the case
 * of ARM, setting up gd.
 *
 * All of this is done using the same layout and alignments as done in
 * board_init_f_init_reserve() / board_init_f_alloc_reserve().
 *
 * @return new stack location, or 0 to use the same stack
 */
ulong spl_relocate_stack_gd(void)
{
#ifdef CONFIG_SPL_STACK_R
	gd_t *new_gd;
	ulong ptr = CONFIG_SPL_STACK_R_ADDR;

#if defined(CONFIG_SPL_SYS_MALLOC_SIMPLE) && CONFIG_VAL(SYS_MALLOC_F_LEN)
	if (CONFIG_SPL_STACK_R_MALLOC_SIMPLE_LEN) {
		ptr -= CONFIG_SPL_STACK_R_MALLOC_SIMPLE_LEN;
		gd->malloc_base = ptr;
		gd->malloc_limit = CONFIG_SPL_STACK_R_MALLOC_SIMPLE_LEN;
		gd->malloc_ptr = 0;
	}
#endif
	/* Get stack position: use 8-byte alignment for ABI compliance */
	ptr = CONFIG_SPL_STACK_R_ADDR - roundup(sizeof(gd_t),16);
	new_gd = (gd_t *)ptr;
	memcpy(new_gd, (void *)gd, sizeof(gd_t));
#if CONFIG_IS_ENABLED(DM)
	dm_fixup_for_gd_move(new_gd);
#endif
#if !defined(CONFIG_ARM)
	gd = new_gd;
#endif
	return ptr;
#else
	return 0;
#endif
}

/* cleanup before jump to next stage */
void spl_cleanup_before_jump(struct spl_image_info *spl_image)
{
	ulong us, tt_us;

	spl_board_prepare_for_jump(spl_image);

	disable_interrupts();

#ifdef CONFIG_ARM64
	disable_serror();
#else
	disable_async_abort();
#endif
	/*
	 * Turn off I-cache and invalidate it
	 */
	icache_disable();
	invalidate_icache_all();

	/*
	 * Turn off D-cache
	 * dcache_disable() in turn flushes the d-cache and disables MMU
	 */
	dcache_disable();
	invalidate_dcache_all();

	dsb();
	isb();

	us = (get_ticks() - gd->sys_start_tick) / 24UL;
	tt_us = get_ticks() / (COUNTER_FREQUENCY / 1000000);
	printf("Total: %ld.%ld/%ld.%ld ms\n\n", us / 1000, us % 1000, tt_us / 1000, tt_us % 1000);
}
