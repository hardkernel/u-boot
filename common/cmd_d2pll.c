/*
 * Command d2pll & ddrtest support.
 */

#include <common.h>
#include <asm/io.h>
#include <asm/arch/io.h>
#include <asm/arch/secure_apb.h>
#include <asm/arch/romboot.h>
#include <asm/arch/watchdog.h>
#include <asm/cpu_id.h>

int do_ddr2pll(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	char *endp;
	unsigned long pll, zqcr;

	/* need at least two arguments */
	if (argc < 2)
		goto usage;

	pll = simple_strtoul(argv[1], &endp,0);
	if (*argv[1] == 0 || *endp != 0) {
		printf ("Error: Wrong format parament!\n");
		return 1;
	}
	if (argc >2)
	{
		zqcr = simple_strtoul(argv[2], &endp, 16);
		if (*argv[2] == 0 || *endp != 0) {
			zqcr = 0;
		}
	}
	else
	{
		zqcr = 0;
	}

#if defined(CONFIG_M6TV) || defined(CONFIG_M6TVD)
	writel(zqcr | (0x3c << 24), P_PREG_STICKY_REG0);
#else
	writel(zqcr | (0xf13 << 20), P_PREG_STICKY_REG0);
#endif
	writel(pll | (readl(P_PREG_STICKY_REG1)), P_PREG_STICKY_REG1);
	printf("Set pll done [0x%08x]\n", readl(P_PREG_STICKY_REG1));
#ifdef CONFIG_M8B
	writel(0xf080000 | 2000, WATCHDOG_TC);
#else
	reset_system();
#endif

	return 0;

usage:
	cmd_usage(cmdtp);
	return 1;
}

U_BOOT_CMD(
	d2pll,	5,	1,	do_ddr2pll,
	"DDR set PLL function",
	"DDR PLL set: d2pll PLL [ZQCR], e...g... 0x1022c.\n"
);

#define DDR_FULL_TEST_CTRL_BIT		21 //use sticky1 bit21
int do_ddrft(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[]) {
	unsigned long ddr_full_test = 0;
	//printf("sticky1: 0x%x\n", readl(P_PREG_STICKY_REG1));

	if (get_cpu_id().family_id <= MESON_CPU_MAJOR_ID_GXTVBB) {
		printf("Only support gxl/gxm/txl... chips!\n");
		return 0;
	}

	if (argc == 1) {
		/* no parameters, switch 1/0 */
		if ((readl(P_PREG_STICKY_REG1)) & (1<<DDR_FULL_TEST_CTRL_BIT)) {
			writel((~(1<<DDR_FULL_TEST_CTRL_BIT)) & (readl(P_PREG_STICKY_REG1)), P_PREG_STICKY_REG1);
		}
		else {
			writel((1<<DDR_FULL_TEST_CTRL_BIT) | (readl(P_PREG_STICKY_REG1)), P_PREG_STICKY_REG1);
		}
	}
	else if (argc == 2) {
		ddr_full_test = simple_strtoul(argv[1], NULL,0);
		if (ddr_full_test)
			ddr_full_test = 1;
		writel((~(1<<DDR_FULL_TEST_CTRL_BIT)) & (readl(P_PREG_STICKY_REG1)), P_PREG_STICKY_REG1);
		writel((ddr_full_test << DDR_FULL_TEST_CTRL_BIT) | (readl(P_PREG_STICKY_REG1)), P_PREG_STICKY_REG1);
	}

	//printf("sticky1: 0x%x\n", readl(P_PREG_STICKY_REG1));
	if (readl(P_PREG_STICKY_REG1) & (1<<DDR_FULL_TEST_CTRL_BIT))
		printf("ddr full test enabled!\n");
	else
		printf("ddr full test disabled!\n");
	return 0;
}

/* ddr full test support, co-work with d2pll function */
/*
  before d2pll command, use
  ddrft 1
  cmd enable ddr full test function
*/
U_BOOT_CMD(
	ddrft,	5,	1,	do_ddrft,
	"Enable/Disable ddr full test at runtime\n\nOnly support gxl/gxm/txl",
	"[1/0]\n"
);

int do_ddr_sram_tune(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	char *endp;
	unsigned long pll, zqcr;

	/* need at least two arguments */
	if (argc < 2)
		goto usage;

	pll = simple_strtoul(argv[1], &endp, 16);
	if (*argv[1] == 0 || *endp != 0) {
		printf ("Error: Wrong format parament!\n");
		return 1;
	}

	if (argc >2)
	{
		zqcr = simple_strtoul(argv[2], &endp, 16);
		if (*argv[2] == 0 || *endp != 0) {
			zqcr = 0;
		}
	}
	else
	{
		zqcr = 0;
	}
#if defined(CONFIG_M6TV) || defined(CONFIG_M6TVD)
	writel(zqcr | (0x3c << 24), P_PREG_STICKY_REG0);
#else
	writel(zqcr | (0xf13 << 20), P_PREG_STICKY_REG0);
#endif
	//writel(P_PREG_STICKY_REG1, pll);
	writel(pll|(1<<31), P_PREG_STICKY_REG1);//modify
	printf("Set pll done [0x%08x]\n", readl(P_PREG_STICKY_REG1));
#ifdef CONFIG_M8B
	writel(0xf080000 | 2000, WATCHDOG_TC);
#else
	reset_system();
#endif

	return 0;

usage:
	cmd_usage(cmdtp);
	return 1;
}

U_BOOT_CMD(
	ddr_sram_tune,	5,	1,	do_ddr_sram_tune,
	"DDR sram tune dqs",
	"ddr_sram_tune  PLL [ZQCR], e...g... 0x1022c.\n\n"
);

