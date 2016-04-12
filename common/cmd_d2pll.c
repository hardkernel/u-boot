/*
 * Command d2pll & ddrtest support.
 */

#include <common.h>
#include <asm/io.h>
#include <asm/arch/io.h>
#include <asm/arch/secure_apb.h>
#include <asm/arch/romboot.h>

void watchdog_reset_system(void)
{
		int i;

		while (1) {
		writel(	0x3	| (1 << 21) // sys reset en
				| (1 << 23) // interrupt en
				| (1 << 24) // clk en
				| (1 << 25) // clk div en
				| (1 << 26) // sys reset now
			, P_WATCHDOG_CNTL);
				writel(0, P_WATCHDOG_RESET);

				writel(readl(P_WATCHDOG_CNTL) | (1<<18), // watchdog en
			P_WATCHDOG_CNTL);
				for (i=0; i<100; i++)
						readl(P_WATCHDOG_CNTL);/*Deceive gcc for waiting some cycles */
	}
}

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
	writel(pll, P_PREG_STICKY_REG1);
	printf("Set pll done [0x%08x]\n", readl(P_PREG_STICKY_REG1));
#ifdef CONFIG_M8B
	writel(0xf080000 | 2000, WATCHDOG_TC);
#else
  //  writel(WATCHDOG_TC, 0xf400000 | 2000);
 // *P_WATCHDOG_RESET = 0;
 watchdog_reset_system();
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
	//writel(WATCHDOG_TC, 0xf400000 | 2000);
	//*P_WATCHDOG_RESET = 0;
	watchdog_reset_system();
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

