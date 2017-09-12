/*
 * Copyright (c) 2016 Rockchip Electronics Co., Ltd
 * Copyright (c) 2016 Andreas Färber
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <asm/armv8/mmu.h>
#include <asm/io.h>
#include <asm/arch/clock.h>
#include <asm/arch/cru_rk3368.h>
#include <asm/arch/grf_rk3368.h>
#include <syscon.h>

DECLARE_GLOBAL_DATA_PTR;

#define IMEM_BASE                  0xFF8C0000

/* Max MCU's SRAM value is 8K, begin at (IMEM_BASE + 4K) */
#define MCU_SRAM_BASE			(IMEM_BASE + 1024 * 4)
#define MCU_SRAM_BASE_BIT31_BIT28	((MCU_SRAM_BASE & GENMASK(31, 28)) >> 28)
#define MCU_SRAM_BASE_BIT27_BIT12	((MCU_SRAM_BASE & GENMASK(27, 12)) >> 12)
/* exsram may using by mcu to accessing dram(0x0-0x20000000) */
#define MCU_EXSRAM_BASE    (0)
#define MCU_EXSRAM_BASE_BIT31_BIT28       ((MCU_EXSRAM_BASE & GENMASK(31, 28)) >> 28)
#define MCU_EXSRAM_BASE_BIT27_BIT12       ((MCU_EXSRAM_BASE & GENMASK(27, 12)) >> 12)
/* experi no used, reserved value = 0 */
#define MCU_EXPERI_BASE    (0)
#define MCU_EXPERI_BASE_BIT31_BIT28       ((MCU_EXPERI_BASE & GENMASK(31, 28)) >> 28)
#define MCU_EXPERI_BASE_BIT27_BIT12       ((MCU_EXPERI_BASE & GENMASK(27, 12)) >> 12)

#define DDR_LATENCY_BASE		(0xffac0000 + 0x14)
#define DDR_READ_LATENCY_VALUE		0x34

#define CPU_AXI_QOS_PRIORITY_BASE	0xffad0300
#define CPU_AXI_QOS_PRIORITY		0x08
#define QOS_PRIORITY_LEVEL_H		2
#define QOS_PRIORITY_LEVEL_L		2

#define ISP_R0_QOS_BASE			0xffad0080
#define QOS_ISP_R0_PRIORITY_LEVEL_H	1
#define QOS_ISP_R0_PRIORITY_LEVEL_L	1

#define ISP_R1_QOS_BASE			0xffad0100
#define QOS_ISP_R1_PRIORITY_LEVEL_H	1
#define QOS_ISP_R1_PRIORITY_LEVEL_L	1

#define ISP_W0_QOS_BASE			0xffad0180
#define QOS_ISP_W0_PRIORITY_LEVEL_H	3
#define QOS_ISP_W0_PRIORITY_LEVEL_L	3

#define ISP_W1_QOS_BASE			0xffad0200
#define QOS_ISP_W1_PRIORITY_LEVEL_H	3
#define QOS_ISP_W1_PRIORITY_LEVEL_L	3

/* cpu axi qos priority */
#define CPU_AXI_QOS_PRIORITY_LEVEL(h, l) \
		((((h) & 3) << 8) | (((h) & 3) << 2) | ((l) & 3))

#define GRF_SOC_CON15			0xff77043c
#define PMU_GRF_SOC_CON0		0xff738100

static struct mm_region rk3368_mem_map[] = {
	{
		.virt = 0x0UL,
		.phys = 0x0UL,
		.size = 0x80000000UL,
		.attrs = PTE_BLOCK_MEMTYPE(MT_NORMAL) |
			 PTE_BLOCK_INNER_SHARE
	}, {
		.virt = 0xf0000000UL,
		.phys = 0xf0000000UL,
		.size = 0x10000000UL,
		.attrs = PTE_BLOCK_MEMTYPE(MT_DEVICE_NGNRNE) |
			 PTE_BLOCK_NON_SHARE |
			 PTE_BLOCK_PXN | PTE_BLOCK_UXN
	}, {
		/* List terminator */
		0,
	}
};

struct mm_region *mem_map = rk3368_mem_map;

int dram_init_banksize(void)
{
	size_t max_size = min((unsigned long)gd->ram_size, gd->ram_top);

	/* Reserve 0x200000 for ATF bl31 */
	gd->bd->bi_dram[0].start = 0x200000;
	gd->bd->bi_dram[0].size = max_size - gd->bd->bi_dram[0].start;

	return 0;
}

#ifdef CONFIG_ARCH_EARLY_INIT_R
static int mcu_init(void)
{
	struct rk3368_grf *grf = syscon_get_first_range(ROCKCHIP_SYSCON_GRF);
	struct rk3368_cru *cru = rockchip_get_cru();

	rk_clrsetreg(&grf->soc_con14, MCU_SRAM_BASE_BIT31_BIT28_MASK,
		     MCU_SRAM_BASE_BIT31_BIT28 << MCU_SRAM_BASE_BIT31_BIT28_SHIFT);
	rk_clrsetreg(&grf->soc_con11, MCU_SRAM_BASE_BIT27_BIT12_MASK,
		     MCU_SRAM_BASE_BIT27_BIT12 << MCU_SRAM_BASE_BIT27_BIT12_SHIFT);
	rk_clrsetreg(&grf->soc_con14, MCU_EXSRAM_BASE_BIT31_BIT28_MASK,
		     MCU_EXSRAM_BASE_BIT31_BIT28 << MCU_EXSRAM_BASE_BIT31_BIT28_SHIFT);
	rk_clrsetreg(&grf->soc_con12, MCU_EXSRAM_BASE_BIT27_BIT12_MASK,
		     MCU_EXSRAM_BASE_BIT27_BIT12 << MCU_EXSRAM_BASE_BIT27_BIT12_SHIFT);
	rk_clrsetreg(&grf->soc_con14, MCU_EXPERI_BASE_BIT31_BIT28_MASK,
		     MCU_EXPERI_BASE_BIT31_BIT28 << MCU_EXPERI_BASE_BIT31_BIT28_SHIFT);
	rk_clrsetreg(&grf->soc_con13, MCU_EXPERI_BASE_BIT27_BIT12_MASK,
		     MCU_EXPERI_BASE_BIT27_BIT12 << MCU_EXPERI_BASE_BIT27_BIT12_SHIFT);

	rk_clrsetreg(&cru->clksel_con[12], MCU_PLL_SEL_MASK | MCU_CLK_DIV_MASK,
		     (MCU_PLL_SEL_GPLL << MCU_PLL_SEL_SHIFT) |
		     (5 << MCU_CLK_DIV_SHIFT));

	 /* mcu dereset, for start running */
	rk_clrreg(&cru->softrst_con[1], MCU_PO_SRST_MASK | MCU_SYS_SRST_MASK);

	return 0;
}

static void cpu_axi_qos_prority_level_config(void)
{
	u32 level;

	/* Set lcdc cpu axi qos priority level */
	level = CPU_AXI_QOS_PRIORITY_LEVEL(QOS_PRIORITY_LEVEL_H,
					   QOS_PRIORITY_LEVEL_L);
	writel(level, CPU_AXI_QOS_PRIORITY_BASE + CPU_AXI_QOS_PRIORITY);

	/* Set cpu isp r0 qos priority level */
	level = CPU_AXI_QOS_PRIORITY_LEVEL(QOS_ISP_R0_PRIORITY_LEVEL_H,
					   QOS_ISP_R0_PRIORITY_LEVEL_L);
	writel(level, ISP_R0_QOS_BASE + CPU_AXI_QOS_PRIORITY);

	/* Set cpu isp r1 qos priority level */
	level = CPU_AXI_QOS_PRIORITY_LEVEL(QOS_ISP_R1_PRIORITY_LEVEL_H,
					   QOS_ISP_R1_PRIORITY_LEVEL_L);
	writel(level, ISP_R1_QOS_BASE + CPU_AXI_QOS_PRIORITY);

	/* Set cpu isp w0 qos priority level */
	level = CPU_AXI_QOS_PRIORITY_LEVEL(QOS_ISP_W0_PRIORITY_LEVEL_H,
					   QOS_ISP_W0_PRIORITY_LEVEL_L);
	writel(level, ISP_W0_QOS_BASE + CPU_AXI_QOS_PRIORITY);

	/* Set cpu isp w1 qos priority level */
	level = CPU_AXI_QOS_PRIORITY_LEVEL(QOS_ISP_W1_PRIORITY_LEVEL_H,
					   QOS_ISP_W1_PRIORITY_LEVEL_L);
	writel(level, ISP_W1_QOS_BASE + CPU_AXI_QOS_PRIORITY);
}

int arch_cpu_init(void)
{
	/* DDR read latency config */
	writel(DDR_READ_LATENCY_VALUE, DDR_LATENCY_BASE);

	/* PWMs select rkpwm clock source */
	rk_setreg(GRF_SOC_CON15, 1 << 12);

	/* PWM2 select 32KHz clock source */
	rk_clrreg(PMU_GRF_SOC_CON0, 1 << 7);

	/* Enable force jtag */
	rk_setreg(GRF_SOC_CON15, 1 << 13);

	/* Cpu axi qos config */
	cpu_axi_qos_prority_level_config();

	return 0;
}

int arch_early_init_r(void)
{
	return mcu_init();
}
#endif
