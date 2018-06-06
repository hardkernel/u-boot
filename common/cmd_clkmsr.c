/*
 * Amlogic clkmsr command
 */
#include <common.h>
#include <command.h>
#include <asm/cpu_id.h>
#include <asm/arch/io.h>
#include <asm/arch/regs.h>
#include <asm/arch/clock.h>

static int do_clkmsr(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	int index = 0xff;

	if (argc ==  2)
		index = simple_strtoul(argv[1], NULL, 10);

	clk_msr(index);

	return 0;
}

static int do_ringmsr(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	int index = 0xff;

	if (argc ==  2)
		index = simple_strtoul(argv[1], NULL, 10);
#if defined (CONFIG_AML_MESON_G12A) || defined (CONFIG_AML_MESON_G12B)
	ring_msr(index);
#else
	printf("error: this prj not support sw ring msr %x\n", index);
#endif
	return 0;
}

U_BOOT_CMD(
		clkmsr, 2, 1, do_clkmsr,
		"Amlogic measure clock",
		"	- measure PLL clock.\n"
		"\n"
		"clkmsr [index]"
		"\n"
);

U_BOOT_CMD(
		ringmsr, 2, 1, do_ringmsr,
		"Amlogic measure ring",
		"	- measure ring clock.\n"
		"\n"
		"clkmsr [index]"
		"\n"
);
