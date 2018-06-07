/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <asm/io.h>
#include <asm/u-boot-arm.h>
#include <irq-generic.h>
#include "irq-gic.h"
#include "irq-gpio.h"

DECLARE_GLOBAL_DATA_PTR;

struct irq_desc {
	interrupt_handler_t *handle_irq;
	void *data;
};

static struct irq_desc irqs_desc[PLATFORM_MAX_IRQS_NR];
static struct irq_chip *gic_irq_chip, *gpio_irq_chip;
static bool initialized;

static int irq_bad(int irq)
{
	if (irq >= PLATFORM_MAX_IRQS_NR) {
		printf("WARN: IRQ %d is out of max supported IRQ %d\n",
		       irq, PLATFORM_MAX_IRQS_NR);
		return -EINVAL;
	}

	if (!initialized) {
		printf("WARN: Interrupt framework is not initialized\n");
		return -EINVAL;
	}

	return 0;
}

/* general interrupt handler for gpio chip */
void _generic_gpio_handle_irq(int irq)
{
	if (irq_bad(irq))
		return;

	if (irq < PLATFORM_GIC_IRQS_NR) {
		printf("WRAN: IRQ %d is not a GPIO irq\n", irq);
		return;
	}

	if (irqs_desc[irq].handle_irq)
		irqs_desc[irq].handle_irq(irq, irqs_desc[irq].data);
}

void _do_generic_irq_handler(void)
{
	u32 irq = gic_irq_chip->irq_get();

	if (irq < PLATFORM_GIC_IRQS_NR) {
		if (irqs_desc[irq].handle_irq)
			irqs_desc[irq].handle_irq(irq, irqs_desc[irq].data);
	}

	gic_irq_chip->irq_eoi(irq);
}

static int chip_irq_bad(struct irq_chip *chip)
{
	if (!chip->name ||
	    !chip->irq_init ||
	    !chip->irq_enable ||
	    !chip->irq_disable ||
	    !chip->irq_set_type)
		return -EINVAL;

	return 0;
}

static int _do_arch_irq_init(void)
{
	int irq, err = -EINVAL;

	/* After relocation done, bss data initialized */
	if (!(gd->flags & GD_FLG_RELOC)) {
		printf("WARN: interrupt should be init after reloc\n");
		return -EINVAL;
	}

	/*
	 * should set true before arch_gpio_irq_init(), otherwise
	 *  can't request irqs for gpio banks.
	 */
	initialized = true;

	for (irq = 0; irq < PLATFORM_MAX_IRQS_NR; irq++) {
		irqs_desc[irq].handle_irq = NULL;
		irqs_desc[irq].data = NULL;
	}

	gic_irq_chip = arch_gic_irq_init();
	if (chip_irq_bad(gic_irq_chip)) {
		printf("ERROR: bad gic irq chip\n");
		goto out;
	}

	gpio_irq_chip = arch_gpio_irq_init();
	if (chip_irq_bad(gpio_irq_chip)) {
		printf("ERROR: bad gpio irq chip\n");
		goto out;
	}

	err = gic_irq_chip->irq_init();
	if (err) {
		printf("ERROR: gic interrupt init failed\n");
		goto out;
	}

	err = gpio_irq_chip->irq_init();
	if (err) {
		printf("ERROR: gpio interrupt init failed\n");
		goto out;
	}

	return 0;

out:
	initialized = false;

	return err;
}

int irq_handler_enable(int irq)
{
	if (irq_bad(irq))
		return -EINVAL;

	if (irq < PLATFORM_GIC_IRQS_NR)
		return gic_irq_chip->irq_enable(irq);
	else
		return gpio_irq_chip->irq_enable(irq);
}

int irq_handler_disable(int irq)
{
	if (irq_bad(irq))
		return -EINVAL;

	if (irq < PLATFORM_GIC_IRQS_NR)
		return gic_irq_chip->irq_disable(irq);
	else
		return gpio_irq_chip->irq_disable(irq);
}

int irq_set_irq_type(int irq, unsigned int type)
{
	if (irq_bad(irq))
		return -EINVAL;

	if (irq < PLATFORM_GIC_IRQS_NR)
		return gic_irq_chip->irq_set_type(irq, type);
	else
		return gpio_irq_chip->irq_set_type(irq, type);
}

int irq_revert_irq_type(int irq)
{
	if (irq_bad(irq))
		return -EINVAL;

	if (irq < PLATFORM_GIC_IRQS_NR)
		return 0;
	else
		return gpio_irq_chip->irq_revert_type(irq);
}

int irq_get_gpio_level(int irq)
{
	if (irq_bad(irq))
		return -EINVAL;

	if (irq < PLATFORM_GIC_IRQS_NR)
		return 0;
	else
		return gpio_irq_chip->irq_get_gpio_level(irq);
}

void irq_install_handler(int irq, interrupt_handler_t *handler, void *data)
{
	if (irq_bad(irq))
		return;

	irqs_desc[irq].handle_irq = handler;
	irqs_desc[irq].data = data;
}

void irq_free_handler(int irq)
{
	if (irq_handler_disable(irq))
		return;

	irqs_desc[irq].handle_irq = NULL;
	irqs_desc[irq].data = NULL;
}

int irqs_suspend(void)
{
	int err;

	err = gic_irq_chip->irq_suspend();
	if (err) {
		printf("ERROR: irqs suspend failed\n");
		return err;
	}

	return 0;
}

int irqs_resume(void)
{
	int err;

	err = gic_irq_chip->irq_resume();
	if (err) {
		printf("ERROR: irqs resume failed\n");
		return err;
	}

	return 0;
}

#ifdef CONFIG_ARM64
static void cpu_local_irq_enable(void)
{
	asm volatile("msr daifclr, #0x02");
}

static int cpu_local_irq_disable(void)
{
	asm volatile("msr daifset, #0x02");

	return 0;
}

void do_irq(struct pt_regs *pt_regs, unsigned int esr)
{
#ifdef CONFIG_ROCKCHIP_DEBUGGER
	printf("\n>>> Rockchip Debugger:\n");
	show_regs(pt_regs);
#endif

	_do_generic_irq_handler();
}
#else
static void cpu_local_irq_enable(void)
{
	unsigned long cpsr;

	__asm__ __volatile__("mrs %0, cpsr\n"
			     "bic %0, %0, #0x80\n"
			     "msr cpsr_c, %0"
			     : "=r" (cpsr) : : "memory");
}

static int cpu_local_irq_disable(void)
{
	unsigned long old_cpsr, new_cpsr;

	__asm__ __volatile__("mrs %0, cpsr\n"
			     "orr %1, %0, #0xc0\n"
			     "msr cpsr_c, %1"
			     : "=r" (old_cpsr), "=r" (new_cpsr)
			     :
			     : "memory");

	return (old_cpsr & 0x80) == 0;
}

void do_irq(struct pt_regs *pt_regs)
{
#ifdef CONFIG_ROCKCHIP_DEBUGGER
	printf("\n>>> Rockchp Debugger:\n");
	show_regs(pt_regs);
#endif

	_do_generic_irq_handler();
}
#endif

int arch_interrupt_init(void)
{
#ifndef CONFIG_ARM64
	unsigned long cpsr __maybe_unused;

	/* stack has been reserved in: arch_reserve_stacks() */
	IRQ_STACK_START = gd->irq_sp;

	__asm__ __volatile__("mrs %0, cpsr\n"
			     : "=r" (cpsr)
			     :
			     : "memory");

	__asm__ __volatile__("msr cpsr_c, %0\n"
			     "mov sp, %1\n"
			     :
			     : "r" (IRQ_MODE | I_BIT |
				    F_BIT | (cpsr & ~FIQ_MODE)),
			       "r" (IRQ_STACK_START)
			     : "memory");

	__asm__ __volatile__("msr cpsr_c, %0"
			     :
			     : "r" (cpsr)
			     : "memory");
#endif
	return _do_arch_irq_init();
}

int interrupt_init(void)
{
	return arch_interrupt_init();
}

void enable_interrupts(void)
{
	cpu_local_irq_enable();
}

int disable_interrupts(void)
{
	return cpu_local_irq_disable();
}
