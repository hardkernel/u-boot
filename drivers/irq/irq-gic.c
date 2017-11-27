/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <asm/io.h>
#include <asm/gic.h>
#include <config.h>
#include <irq-generic.h>
#include "irq-gic.h"

#define gicd_readl(offset)	readl(GICD_BASE + (offset))
#define gicc_readl(offset)	readl(GICC_BASE + (offset))
#define gicd_writel(v, offset)	writel(v, GICD_BASE + (offset))
#define gicc_writel(v, offset)	writel(v, GICC_BASE + (offset))

typedef enum INT_TRIG {
	INT_LEVEL_TRIGGER,
	INT_EDGE_TRIGGER
} eINT_TRIG;

typedef enum INT_SECURE {
	INT_SECURE,
	INT_NOSECURE
} eINT_SECURE;

typedef enum INT_SIGTYPE {
	INT_SIGTYPE_IRQ,
	INT_SIGTYPE_FIQ
} eINT_SIGTYPE;

#define g_gicd		((pGICD_REG)GICD_BASE)
#define g_gicc		((pGICC_REG)GICC_BASE)

__maybe_unused static u8 g_gic_cpumask = 0x01;

static inline void int_set_prio_filter(u32 nprio)
{
	g_gicc->iccpmr = (nprio & 0xff);
}

static inline void int_enable_distributor(void)
{
	g_gicd->icddcr = 0x01;
}

static inline void int_disable_distributor(void)
{
	g_gicd->icddcr = 0x00;
}

static inline void int_enable_secure_signal(void)
{
	g_gicc->iccicr |= 0x01;
}

static inline void int_disable_secure_signal(void)
{
	g_gicc->iccicr &= (~0x01);
}

static inline void int_enable_nosecure_signal(void)
{
	g_gicc->iccicr |= 0x02;
}

static inline void int_disable_nosecure_signal(void)
{
	g_gicc->iccicr &= (~0x02);
}

static int gic_irq_set_trigger(int irq, eINT_TRIG ntrig)
{
	u32 group, offset;

	if (irq >= PLATFORM_GIC_IRQS_NR)
		return -EINVAL;

	group = irq / 16;
	offset = irq % 16;

	if (ntrig == INT_LEVEL_TRIGGER)
		g_gicd->icdicfr[group] &= (~(1 << (2 * offset + 1)));
	else
		g_gicd->icdicfr[group] |= (1 << (2 * offset + 1));

	return 0;
}

__maybe_unused static int gic_irq_set_pending(int irq)
{
	u32 group, offset;

	if (irq >= PLATFORM_GIC_IRQS_NR)
		return -EINVAL;

	group = irq / 32;
	offset = irq % 32;
	g_gicd->icdispr[group] = (0x1 << offset);

	return 0;
}

__maybe_unused static int gic_irq_clear_pending(int irq)
{
	u32 group, offset;

	if (irq >= PLATFORM_GIC_IRQS_NR)
		return -EINVAL;

	group = irq / 32;
	offset = irq % 32;
	g_gicd->icdicpr[group] = (0x1 << offset);

	return 0;
}

__maybe_unused static int gic_irq_set_secure(int irq, eINT_SECURE nsecure)
{
	u32 group, offset;

	if (irq >= PLATFORM_GIC_IRQS_NR)
		return -EINVAL;

	group = irq / 32;
	offset = irq % 32;
	g_gicd->icdiser[group] |= nsecure << offset;

	return 0;
}

__maybe_unused static u32 gic_get_cpumask(void)
{
	u32 mask = 0, i;

	for (i = mask = 0; i < 32; i += 4) {
		mask = g_gicd->itargetsr[i];
		mask |= mask >> 16;
		mask |= mask >> 8;
		if (mask)
			break;
	}

	if (!mask)
		printf("GIC CPU mask not found.\n");

	debug("GIC CPU mask = 0x%08x\n", mask);

	return mask;
}

static int gic_irq_enable(int irq)
{
#ifdef CONFIG_GICV2
	u32 shift = (irq % 4) * 8;
	u32 offset = (irq / 4);
	u32 M, N;

	if (irq >= PLATFORM_GIC_IRQS_NR)
		return -EINVAL;

	M = irq / 32;
	N = irq % 32;

	g_gicc->iccicr &= (~0x08);
	g_gicd->icdiser[M] = (0x1 << N);
	g_gicd->itargetsr[offset] &= ~(0xFF << shift);
	g_gicd->itargetsr[offset] |= (g_gic_cpumask << shift);
#else
	u32 M, N;

	if (irq >= PLATFORM_GIC_IRQS_NR)
		return -EINVAL;

	M = irq / 32;
	N = irq % 32;
	g_gicd->icdiser[M] = (0x1 << N);
#endif

	return 0;
}

static int gic_irq_disable(int irq)
{
	u32 group, offset;

	if (irq >= PLATFORM_GIC_IRQS_NR)
		return -EINVAL;

	group = irq / 32;
	offset = irq % 32;
	g_gicd->icdicer[group] = (0x1 << offset);

	return 0;
}

/*
 * irq_set_type - set the irq trigger type for an irq
 *
 * @irq: irq number
 * @type: IRQ_TYPE_{LEVEL,EDGE}_* value - see asm/arch/irq.h
 */
static int gic_irq_set_type(int irq, unsigned int type)
{
	unsigned int int_type;

	switch (type) {
	case IRQ_TYPE_EDGE_RISING:
	case IRQ_TYPE_EDGE_FALLING:
		int_type = INT_EDGE_TRIGGER;
		break;
	case IRQ_TYPE_LEVEL_HIGH:
	case IRQ_TYPE_LEVEL_LOW:
		int_type = INT_LEVEL_TRIGGER;
		break;
	default:
		return -EINVAL;
	}

	gic_irq_set_trigger(irq, int_type);

	return 0;
}

static void gic_irq_eoi(int irq)
{
#ifdef CONFIG_GICV2
	g_gicc->icceoir = irq;
#else
	asm volatile("msr " __stringify(ICC_EOIR1_EL1) ", %0"
			: : "r" ((u64)irq));
	asm volatile("msr " __stringify(ICC_DIR_EL1) ", %0"
			: : "r" ((u64)irq));
	isb();
#endif
}

static int gic_irq_get(void)
{
#ifdef CONFIG_GICV2
	return g_gicc->icciar & 0x3ff; /* bit9 - bit0 */
#else
	u64 irqstat;

	asm volatile("mrs %0, " __stringify(ICC_IAR1_EL1) : "=r" (irqstat));
	return (u32)irqstat & 0x3ff;
#endif
}

struct gic_dist_data {
	uint32_t ctlr;
	uint32_t icfgr[DIV_ROUND_UP(1020, 16)];
	uint32_t itargetsr[DIV_ROUND_UP(1020, 4)];
	uint32_t ipriorityr[DIV_ROUND_UP(1020, 4)];
	uint32_t igroupr[DIV_ROUND_UP(1020, 32)];
	uint32_t ispendr[DIV_ROUND_UP(1020, 32)];
	uint32_t isenabler[DIV_ROUND_UP(1020, 32)];
};

struct gic_cpu_data {
	uint32_t ctlr;
	uint32_t pmr;
};

static struct gic_dist_data gicd_save;
static struct gic_cpu_data gicc_save;

#define IRQ_REG_X4(irq)		(4 * ((irq) / 4))
#define IRQ_REG_X16(irq)	(4 * ((irq) / 16))
#define IRQ_REG_X32(irq)	(4 * ((irq) / 32))

static int gic_irq_suspend(void)
{
	int irq_nr, i, irq;

	/* irq nr */
	irq_nr = ((gicd_readl(GICD_TYPER) & 0x1f) + 1) * 32;
	if (irq_nr > 1020)
		irq_nr = 1020;

	/* GICC save */
	gicc_save.ctlr = gicc_readl(GICC_CTLR);
	gicc_save.pmr = gicc_readl(GICC_PMR);

	/* GICD save */
	gicd_save.ctlr = gicd_readl(GICD_CTLR);

	for (i = 0, irq = 0; irq < irq_nr; irq += 16)
		gicd_save.icfgr[i++] = gicd_readl(GICD_ICFGR + IRQ_REG_X16(irq));

	for (i = 0, irq = 0; irq < irq_nr; irq += 4)
		gicd_save.itargetsr[i++] = gicd_readl(GICD_ITARGETSRn + IRQ_REG_X4(irq));

	for (i = 0, irq = 0; irq < irq_nr; irq += 4)
		gicd_save.ipriorityr[i++] = gicd_readl(GICD_IPRIORITYRn + IRQ_REG_X4(irq));

	for (i = 0, irq = 0; irq < irq_nr; irq += 32)
		gicd_save.igroupr[i++] = gicd_readl(GICD_IGROUPRn + IRQ_REG_X32(irq));

	for (i = 0, irq = 0; irq < irq_nr; irq += 32)
		gicd_save.ispendr[i++] = gicd_readl(GICD_ISPENDRn + IRQ_REG_X32(irq));

	for (i = 0, irq = 0; irq < irq_nr; irq += 32)
		gicd_save.isenabler[i++] = gicd_readl(GICD_ISENABLERn + IRQ_REG_X32(irq));

	dsb();

	return 0;
}

static int gic_irq_resume(void)
{
	int irq_nr, i, irq;

	irq_nr = ((gicd_readl(GICD_TYPER) & 0x1f) + 1) * 32;
	if (irq_nr > 1020)
		irq_nr = 1020;

	/* Disable ctrl register */
	gicc_writel(0, GICC_CTLR);
	gicd_writel(0, GICD_CTLR);
	dsb();

	/* Clear all interrupt */
	for (i = 0, irq = 0; irq < irq_nr; irq += 32)
		gicd_writel(0xffffffff, GICD_ICENABLERn + IRQ_REG_X32(irq));

	for (i = 0, irq = 0; irq < irq_nr; irq += 16)
		gicd_writel(gicd_save.icfgr[i++], GICD_ICFGR + IRQ_REG_X16(irq));

	for (i = 0, irq = 0; irq < irq_nr; irq += 4)
		gicd_writel(gicd_save.itargetsr[i++], GICD_ITARGETSRn + IRQ_REG_X4(irq));

	for (i = 0, irq = 0; irq < irq_nr; irq += 4)
		gicd_writel(gicd_save.ipriorityr[i++], GICD_IPRIORITYRn + IRQ_REG_X4(irq));

	for (i = 0, irq = 0; irq < irq_nr; irq += 32)
		gicd_writel(gicd_save.igroupr[i++], GICD_IGROUPRn + IRQ_REG_X32(irq));

	for (i = 0, irq = 0; irq < irq_nr; irq += 32)
		gicd_writel(gicd_save.isenabler[i++], GICD_ISENABLERn + IRQ_REG_X32(irq));

	for (i = 0, irq = 0; irq < irq_nr; irq += 32)
		gicd_writel(gicd_save.ispendr[i++], GICD_ISPENDRn + IRQ_REG_X32(irq));
	dsb();

	gicc_writel(gicc_save.pmr, GICC_PMR);
	gicc_writel(gicc_save.ctlr, GICC_CTLR);
	gicd_writel(gicd_save.ctlr, GICD_CTLR);
	dsb();

	return 0;
}

/**************************************regs save and resume**************************/
static int gic_irq_init(void)
{
	/* GICV3 done in: arch/arm/cpu/armv8/start.S */
#ifdef CONFIG_GICV2
	/* end of interrupt */
	g_gicc->icceoir = PLATFORM_GIC_IRQS_NR;

	/* disable gicc and gicd */
	g_gicc->iccicr = 0x00;
	g_gicd->icddcr = 0x00;

	/* enable interrupt */
	g_gicd->icdicer[0] = 0xFFFFFFFF;
	g_gicd->icdicer[1] = 0xFFFFFFFF;
	g_gicd->icdicer[2] = 0xFFFFFFFF;
	g_gicd->icdicer[3] = 0xFFFFFFFF;
	g_gicd->icdicfr[3] &= ~(1 << 1);

	/* set interrupt priority threhold min: 256 */
	int_set_prio_filter(0xff);
	int_enable_secure_signal();
	int_enable_nosecure_signal();
	int_enable_distributor();

	g_gic_cpumask = gic_get_cpumask();
#endif

	return 0;
}

static struct irq_chip gic_irq_chip = {
	.name		= "gic-irq-chip",
	.irq_init	= gic_irq_init,
	.irq_suspend	= gic_irq_suspend,
	.irq_resume	= gic_irq_resume,
	.irq_get	= gic_irq_get,
	.irq_enable	= gic_irq_enable,
	.irq_disable	= gic_irq_disable,
	.irq_eoi	= gic_irq_eoi,
	.irq_set_type	= gic_irq_set_type,
};

struct irq_chip *arch_gic_irq_init(void)
{
	return &gic_irq_chip;
}
