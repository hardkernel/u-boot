/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#ifndef _IRQ_GIC_H_
#define _IRQ_GIC_H_

#include <irq-platform.h>

#define PLATFORM_GIC_IRQS_NR		GIC_IRQS_NR
#define PLATFORM_GPIO_IRQS_NR		GPIO_IRQS_NR
#define PLATFORM_MAX_IRQS_NR		(GIC_IRQS_NR + GPIO_IRQS_NR)

struct irq_chip *arch_gic_irq_init(void);

#endif /* _IRQ_GIC_H_ */
