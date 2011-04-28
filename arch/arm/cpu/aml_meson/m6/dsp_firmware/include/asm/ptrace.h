/******************************************************************************
 * Copyright Codito Technologies (www.codito.com) Oct 01, 2004
 * 
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 *****************************************************************************/

/*
 *  linux/include/asm-arc/ptrace.h
 *
 *  Copyright (C) 
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 * Authors : Amit Bhor, Sameer Dhavale
 */
#ifndef __ASM_ARC_PTRACE_H
#define __ASM_ARC_PTRACE_H

#include <asm/debug.h>
#include <asm/arcregs.h>

/* Offsets of various elements(registers) of struct pt_regs on the stack.
 * The offsets starts with 4 because sp points to next free element on stack
 */

#define	PT_bta	 	4
#define	PT_lp_start	8
#define PT_lp_end	12
#define PT_lp_count	16
#define PT_status32	20
#define PT_ret		24
#define PT_blink	28
#define PT_fp		32
#define PT_r26		36
#define PT_r12		40
#define PT_r11		44
#define PT_r10		48
#define PT_r9		52
#define PT_r8		56
#define PT_r7		60
#define PT_r6		64
#define PT_r5		68
#define PT_r4		72
#define PT_r3		76
#define PT_r2		80
#define PT_r1		84
#define PT_r0		88
#define PT_orig_r0	92
#define PT_orig_r8	96
#define PT_sp		100


#ifndef __ASSEMBLY__

/* this struct defines the way the registers are stored on the
   stack during a system call. */

struct pt_regs {
	/* After a SAVE_ALL_SYS or a SAVE ALL_INT, SP points to next free 
	 * entry on stack. So this place holder 
	 */ 
	long	stack_place_holder;
	long	bta;		/* bta_l1, bta_l2, erbta */
	long	lp_start;
	long	lp_end;
	long	lp_count;
	long	status32;	/* status32_l1, status32_l2, erstatus */
	long	ret;		/* ilink1, ilink2 or eret*/
	long	blink;
	long	fp;
	long	r26;		/* gp */
	long	r12;
	long	r11;
	long	r10;
	long	r9;
	long	r8;
	long	r7;
	long	r6;
	long	r5;
	long	r4;
	long	r3;
	long	r2;
	long	r1;
	long	r0;
	long	orig_r0;
	long	orig_r8;	/*used to distinguish between an exception, a system call, int1 or int2 */
	long	sp;	/* user sp or kernel sp, depending on where we came from  */ 
};

/* Callee saved registers - need to be saved only when you are scheduled out */

struct callee_regs {
	/* After a SAVE_ALL_SYS or a SAVE ALL_INT, SP points to next free 
	 * entry on stack. So this place holder 
	 */ 
	long	stack_place_holder;
	long	r25;
	long	r24;
	long	r23;
	long	r22;
	long	r21;
	long	r20;
	long 	r19;
	long 	r18;
	long	r17;
	long 	r16;
	long	r15;
	long	r14;
	long	r13;
};

#endif /* !__ASSEMBLY__ */

#ifdef __KERNEL__

#define PTRACE_GETREGS		12
#define PTRACE_SETREGS		13
#define PTRACE_GETFPREGS	14
#define PTRACE_SETFPREGS	15

#define PTRACE_O_TRACESYSGOOD     0x00000001


/* Sameer: Two new macros. I need to check up if we can use
           ret as pc */
#define instruction_pointer(regs) \
	((regs)->ret)

#define profile_pc(regs) instruction_pointer(regs)

#ifndef __ASSEMBLY__

/* return 1 if user mode or 0 if kernel mode */
#define user_mode(regs) ((regs->status32 & STATUS_U_MASK) == STATUS_U_MASK)

#endif /* __ASSEMBLY__ */

#endif /* __KERNEL__ */

#endif /* __ASM_PTRACE_H */

