/*
 * Command for suspend.
 *
 * Copyright (C) 2012 Amlogic.
 * Elvis Yu <elvis.yu@amlogic.com>
 */

#include <common.h>
#include <command.h>
#include <asm/arch/ao_reg.h>
#ifdef CONFIG_PLATFORM_HAS_PMU
#include <amlogic/aml_pmu_common.h>
#endif
extern void meson_pm_suspend(void);
#define readl(addr) (*(volatile unsigned int*)(addr))
#define writel(b,addr) ((*(volatile unsigned int *) (addr)) = (b))

static int do_suspend (cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
#ifndef CONFIG_M6TV
	run_command("video dev bl_off",1);
	run_command("video dev disable",1);
#endif
    /*
     * set suspend charger current according battery parameter
     */
#if defined(CONFIG_PLATFORM_HAS_PMU) && defined(CONFIG_UBOOT_BATTERY_PARAMETERS)
    struct aml_pmu_driver    *driver;
    struct battery_parameter *para;
    driver = aml_pmu_get_driver();
    para   = get_battery_para();
    if (driver && driver->pmu_set_charge_current && para) {
        driver->pmu_set_charge_current(para->pmu_shutdown_chgcur);
    }
#endif
	meson_pm_suspend();
	return 0;
}



U_BOOT_CMD(
	suspend,	1,	0,	do_suspend,
	"suspend",
	"/N\n"
	"This command will into suspend\n"
);

