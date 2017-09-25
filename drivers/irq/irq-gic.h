/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#ifndef _IRQ_GIC_H_
#define _IRQ_GIC_H_

#include <irq-platform.h>

/* INTC Registers */
typedef volatile struct tagGICD_REG {
	u32 icddcr;		/* 0x000 */
	u32 icdictr;		/* 0x004 */
	u32 icdiidr;		/* 0x008 */
	u32 reserved0[29];
	u32 icdisr[4];		/* 0x080 */
	u32 reserved1[28];
	u32 icdiser[4];		/* 0x100 */
	u32 reserved2[28];
	u32 icdicer[4];		/* 0x180: GICD_ISENABLERn */
	u32 reserved3[28];
	u32 icdispr[4];		/* 0x200 */
	u32 reserved4[28];
	u32 icdicpr[4];		/* 0x280 */
	u32 reserved5[28];
	u32 icdiabr[4];		/* 0x300 */
	u32 reserved6[60];
	u32 icdipr_sgi[4];	/* 0x400 */
	u32 icdipr_ppi[4];	/* 0x410 */
	u32 icdipr_spi[18];	/* 0x420 */
	u32 reserved7[230];
	u32 itargetsr[255];	/* 0x800 */
	u32 reserved9[1];
	u32 icdicfr[7];		/* 0xc00: GICD_ICFGRn: trigger level/edge */
	u32 reserved8[185];
	u32 icdsgir;		/* 0xf00 */
} GICD_REG, *pGICD_REG;

typedef volatile struct tagGICC_REG {
	u32 iccicr;		/* 0x00 */
	u32 iccpmr;		/* 0x04: GICC_PMR */
	u32 iccbpr;		/* 0x08 */
	u32 icciar;		/* 0x0c */
	u32 icceoir;		/* 0x10 */
	u32 iccrpr;		/* 0x14 */
	u32 icchpir;		/* 0x18 */
	u32 iccabpr;		/* 0x1c */
	u32 reserved0[55];
	u32 icciidr;		/* 0xfc */
} GICC_REG, *pGICC_REG;

#define PLATFORM_GIC_IRQS_NR		GIC_IRQS_NR
#define PLATFORM_GPIO_IRQS_NR		GPIO_IRQS_NR
#define PLATFORM_MAX_IRQS_NR		(GIC_IRQS_NR + GPIO_IRQS_NR)

struct irq_chip *arch_gic_irq_init(void);

#endif /* _IRQ_GIC_H_ */
