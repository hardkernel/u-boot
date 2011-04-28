/*
 * (C) Copyright 2003
 * Texas Instruments <www.ti.com>
 *
 * (C) Copyright 2002
 * Sysgo Real-Time Solutions, GmbH <www.elinos.com>
 * Marius Groeger <mgroeger@sysgo.de>
 *
 * (C) Copyright 2002
 * Sysgo Real-Time Solutions, GmbH <www.elinos.com>
 * Alex Zuepke <azu@sysgo.de>
 *
 * (C) Copyright 2002-2004
 * Gary Jennejohn, DENX Software Engineering, <garyj@denx.de>
 *
 * (C) Copyright 2004
 * Philippe Robin, ARM Ltd. <philippe.robin@arm.com>
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
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */

#include <common.h>
#include <asm/proc-armv/ptrace.h>
#ifdef CONFIG_CMD_KGDB
#include <kgdb.h>

#endif
#ifdef CONFIG_ENABLE_WATCHDOG
#include <asm/arch/reg_addr.h>
void reset_chip()
{
			writel((1<<22) | (3<<24)|1000, P_WATCHDOG_TC);
}
#endif
#ifdef CONFIG_USE_IRQ
DECLARE_GLOBAL_DATA_PTR;

int interrupt_init (void)
{
	return 0;
}

/* enable IRQ interrupts */
void enable_interrupts (void)
{
	unsigned long temp;
	__asm__ __volatile__("mrs %0, cpsr\n"
			     "bic %0, %0, #0x80\n"
			     "msr cpsr_c, %0"
			     : "=r" (temp)
			     :
			     : "memory");
}


/*
 * disable IRQ/FIQ interrupts
 * returns true if interrupts had been enabled before we disabled them
 */
int disable_interrupts (void)
{
	unsigned long old,temp;
	__asm__ __volatile__("mrs %0, cpsr\n"
			     "orr %1, %0, #0xc0\n"
			     "msr cpsr_c, %1"
			     : "=r" (old), "=r" (temp)
			     :
			     : "memory");
	return (old & 0x80) == 0;
}
#else
void enable_interrupts (void)
{
	return;
}
int disable_interrupts (void)
{
	return 0;
}
#endif


void bad_mode (void)
{

}

void show_regs (struct pt_regs *regs)
{

}

void do_undefined_instruction (struct pt_regs *pt_regs)
{
#ifdef CONFIG_ENABLE_WATCHDOG
		reset_chip();
#endif
}

void do_software_interrupt (struct pt_regs *pt_regs)
{
#ifdef CONFIG_ENABLE_WATCHDOG
		reset_chip();
#endif
}

void do_prefetch_abort (struct pt_regs *pt_regs)
{
#ifdef CONFIG_ENABLE_WATCHDOG
		reset_chip();
#endif
}

void do_data_abort (struct pt_regs *pt_regs)
{
#ifdef CONFIG_ENABLE_WATCHDOG
		reset_chip();
#endif
}

void do_not_used (struct pt_regs *pt_regs)
{

}

void do_fiq (struct pt_regs *pt_regs)
{
#ifdef CONFIG_ENABLE_WATCHDOG
		reset_chip();
#endif
}

#ifndef CONFIG_USE_IRQ
void do_irq (struct pt_regs *pt_regs)
{
#ifdef CONFIG_ENABLE_WATCHDOG
		reset_chip();
#endif
}
#endif
