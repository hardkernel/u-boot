/*
 * Copyright (C) 2009 Samsung Electronics
 * Minkyu Kang <mk7.kang@samsung.com>
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */
#include <common.h>
#include <asm/io.h>
#include <asm/arch/clock.h>
#include <asm/arch/clk.h>

/* Default is s5pc100 */
unsigned int s5p_cpu_id = 0xC100;
/* Default is EVT1 */
unsigned int s5p_cpu_rev = 1;

#ifdef CONFIG_ARCH_CPU_INIT
int arch_cpu_init(void)
{
	s5p_set_cpu_id();

	return 0;
}
#endif

u32 get_device_type(void)
{
	return s5p_cpu_id;
}

#ifdef CONFIG_DISPLAY_CPUINFO
int print_cpuinfo(void)
{
#ifdef CONFIG_EXYNOS5
	unsigned int cpuid;
	unsigned int subrev;

	__asm__ __volatile__("mrc p15, 0, %0, c0, c0, 0":"=r"(cpuid));
	subrev = (readl(EXYNOS5_PRO_ID) & 0x0000000F);

	printf("CPU: %s%x Rev%x.%x [Samsung SOC on SMP Platform Base on ARM CortexA%d]\n"	\
		, s5p_get_cpu_name(), s5p_cpu_id, s5p_cpu_rev, subrev, ((cpuid >> 4) & 0xf));

#if defined(CONFIG_CPU_EXYNOS5410) || defined(CONFIG_CPU_EXYNOS5420)
	unsigned int apll = get_pll_clk(APLL);
	unsigned int kpll = get_pll_clk(KPLL);
	unsigned int mpll = get_pll_clk(MPLL);
	unsigned int bpll = get_pll_clk(BPLL);

	printf("APLL = %ldMHz, KPLL = %ldMHz\n", apll/1000000, kpll/1000000);
	printf("MPLL = %ldMHz, BPLL = %ldMHz\n", mpll/1000000, bpll/1000000);
#endif
#else
	char buf[32];

	if (s5p_cpu_id == 0x4412 || s5p_cpu_id == 0x4212) {
		printf("CPU: %s%X [Samsung SOC on SMP Platform Base on ARM CortexA9]\n",
			s5p_get_cpu_name(), s5p_cpu_id);
		printf("APLL = %ldMHz, MPLL = %ldMHz\n",
			get_pll_clk(APLL)/1000000, get_pll_clk(MPLL)/1000000);
	}
	else
		printf("CPU:\t%s%X@%sMHz\n",
			s5p_get_cpu_name(), s5p_cpu_id,
			strmhz(buf, get_arm_clk()));
#endif

	return 0;
}
#endif
