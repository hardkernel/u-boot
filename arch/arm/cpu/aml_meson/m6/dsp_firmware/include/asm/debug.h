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
 *  linux/include/asm-arcnommu/ptrace.h
 *
 *  Copyright (C) 
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 * Authors : Amit Bhor
 */
#ifndef _ASM_ARC_DEBUG_H
#define _ASM_ARC_DEBUG_H

#define ARC_CONTEXT_DEBUG

#ifndef __ASSEMBLY__
#ifdef ARC_CONTEXT_DEBUG
#ifndef __MW__
#define loadtestcontext1() {			\
	__asm__ __volatile__ (			\
			"mov	r0, 0x0 \n\t"	\
			"mov	r1, 0x1 \n\t"	\
			"mov	r2, 0x2 \n\t"	\
			"mov	r3, 0x3 \n\t"	\
			"mov	r4, 0x4 \n\t"	\
			"mov	r5, 0x5 \n\t"	\
			"mov	r6, 0x6 \n\t"	\
			"mov	r7, 0x7 \n\t"	\
			"mov	r8, 0x8 \n\t"	\
			"mov	r9, 0x9 \n\t"	\
			"mov	r10, 0x10 \n\t"	\
			"mov	r11, 0x11 \n\t"	\
			"mov	r12, 0x12 \n\t"	\
			"mov	r13, 0x13 \n\t"	\
			"mov	r14, 0x14 \n\t"	\
			"mov	r15, 0x15 \n\t"	\
			"mov	r16, 0x16 \n\t"	\
			"mov	r17, 0x17 \n\t"	\
			"mov	r18, 0x18 \n\t"	\
			"mov	r19, 0x19 \n\t"	\
			"mov	r20, 0x20 \n\t"	\
			"mov	r21, 0x21 \n\t"	\
			"mov	r22, 0x22 \n\t"	\
			"mov	r23, 0x23 \n\t"	\
			"mov	r24, 0x24 \n\t"	\
			"mov	r25, 0x25 \n\t"	\
			"mov	r26, 0x26 \n\t"	\
			"mov	lp_count, 0x111 \n\t"	\
			"sr	0xdeadb00b, [lp_start] \n\t"	\
			"sr	0xdeadb00b, [lp_end] \n\t"	\
			:					\
			:					\
			: "r0","r1","r2","r3","r4","r5","r6","r7","r8",			\
			  "r9","r10","r11","r12","r13","r14","r15","r16","r17",		\
			  "r18","r19","r20","r21","r22","r23","r24","r25","r26",	\
			  "lp_count"							\
		);									\
}

#define storetestcontext1(var) {			\
	__asm__ __volatile__ (			\
			"st	r0, [%0] \n\t"	\
			"st	r1, [%0] \n\t"	\
			"mov	r2, 0x2 \n\t"	\
			"mov	r3, 0x3 \n\t"	\
			"mov	r4, 0x4 \n\t"	\
			"mov	r5, 0x5 \n\t"	\
			"mov	r6, 0x6 \n\t"	\
			"st	r7, [%0] \n\t"	\
			"mov	r8, 0x8 \n\t"	\
			"mov	r9, 0x9 \n\t"	\
			"mov	r10, 0x10 \n\t"	\
			"mov	r11, 0x11 \n\t"	\
			"mov	r12, 0x12 \n\t"	\
			"mov	r13, 0x13 \n\t"	\
			"mov	r14, 0x14 \n\t"	\
			"mov	r15, 0x15 \n\t"	\
			"mov	r16, 0x16 \n\t"	\
			"mov	r17, 0x17 \n\t"	\
			"mov	r18, 0x18 \n\t"	\
			"mov	r19, 0x19 \n\t"	\
			"mov	r20, 0x20 \n\t"	\
			"mov	r21, 0x21 \n\t"	\
			"mov	r22, 0x22 \n\t"	\
			"mov	r23, 0x23 \n\t"	\
			"mov	r24, 0x24 \n\t"	\
			"mov	r25, 0x25 \n\t"	\
			"mov	r26, 0x26 \n\t"	\
			"mov	lp_count, 0x111 \n\t"	\
			"sr	0xdeadb00b, [lp_start] \n\t"	\
			"sr	0xdeadb00b, [lp_end] \n\t"	\
			:					\
			: "r" (var)				\
			: "r0","r1","r2","r3","r4","r5","r6","r7","r8",			\
			  "r9","r10","r11","r12","r13","r14","r15","r16","r17",		\
			  "r18","r19","r20","r21","r22","r23","r24","r25","r26",	\
			  "lp_count"							\
		);									\
}

#define loadtestcontext2() {			\
	__asm__ __volatile__ (			\
			"mov	r0, 0xf0 \n\t"	\
			"mov	r1, 0xf1 \n\t"	\
			"mov	r2, 0xf2 \n\t"	\
			"mov	r3, 0xf3 \n\t"	\
			"mov	r4, 0xf4 \n\t"	\
			"mov	r5, 0xf5 \n\t"	\
			"mov	r6, 0xf6 \n\t"	\
			"mov	r7, 0xf7 \n\t"	\
			"mov	r8, 0xf8 \n\t"	\
			"mov	r9, 0xf9 \n\t"	\
			"mov	r10, 0xf10 \n\t"	\
			"mov	r11, 0xf11 \n\t"	\
			"mov	r12, 0xf12 \n\t"	\
			"mov	r13, 0xf13 \n\t"	\
			"mov	r14, 0xf14 \n\t"	\
			"mov	r15, 0xf15 \n\t"	\
			"mov	r16, 0xf16 \n\t"	\
			"mov	r17, 0xf17 \n\t"	\
			"mov	r18, 0xf18 \n\t"	\
			"mov	r19, 0xf19 \n\t"	\
			"mov	r20, 0xf20 \n\t"	\
			"mov	r21, 0xf21 \n\t"	\
			"mov	r22, 0xf22 \n\t"	\
			"mov	r23, 0xf23 \n\t"	\
			"mov	r24, 0xf24 \n\t"	\
			"mov	r25, 0xf25 \n\t"	\
			"mov	r26, 0xf26 \n\t"	\
			"mov	lp_count, 0x111 \n\t"	\
			"sr	0xfeadb00b, [lp_start] \n\t"	\
			"sr	0xfeadb00b, [lp_end] \n\t"	\
			:					\
			:					\
			: "r0","r1","r2","r3","r4","r5","r6","r7","r8",			\
			  "r9","r10","r11","r12","r13","r14","r15","r16","r17",		\
			  "r18","r19","r20","r21","r22","r23","r24","r25","r26",	\
			  "lp_count"							\
		);									\
}
#else
#define loadtestcontext1() {			\
	__asm__ __volatile__ (			\
			"mov	r0, 0x0 \n\t"	\
			"mov	r1, 0x1 \n\t"	\
			"mov	r2, 0x2 \n\t"	\
			"mov	r3, 0x3 \n\t"	\
			"mov	r4, 0x4 \n\t"	\
			"mov	r5, 0x5 \n\t"	\
			"mov	r6, 0x6 \n\t"	\
			"mov	r7, 0x7 \n\t"	\
			"mov	r8, 0x8 \n\t"	\
			"mov	r9, 0x9 \n\t"	\
			"mov	r10, 0x10 \n\t"	\
			"mov	r11, 0x11 \n\t"	\
			"mov	r12, 0x12 \n\t"	\
			"mov	r13, 0x13 \n\t"	\
			"mov	r14, 0x14 \n\t"	\
			"mov	r15, 0x15 \n\t"	\
			"mov	r16, 0x16 \n\t"	\
			"mov	r17, 0x17 \n\t"	\
			"mov	r18, 0x18 \n\t"	\
			"mov	r19, 0x19 \n\t"	\
			"mov	r20, 0x20 \n\t"	\
			"mov	r21, 0x21 \n\t"	\
			"mov	r22, 0x22 \n\t"	\
			"mov	r23, 0x23 \n\t"	\
			"mov	r24, 0x24 \n\t"	\
			"mov	r25, 0x25 \n\t"	\
			"mov	r26, 0x26 \n\t"	\
			"mov	%lp_count, 0x111 \n\t"	\
			"sr	0xdeadb00b, [lp_start] \n\t"	\
			"sr	0xdeadb00b, [lp_end] \n\t"	\
			:					\
			:					\
			: "r0","r1","r2","r3","r4","r5","r6","r7","r8",			\
			  "r9","r10","r11","r12","r13","r14","r15","r16","r17",		\
			  "r18","r19","r20","r21","r22","r23","r24","r25","r26",	\
			  "lp_count"							\
		);									\
}

#define storetestcontext1(var) {			\
	__asm__ __volatile__ (			\
			"st	r0, [%0] \n\t"	\
			"st	r1, [%0] \n\t"	\
			"mov	r2, 0x2 \n\t"	\
			"mov	r3, 0x3 \n\t"	\
			"mov	r4, 0x4 \n\t"	\
			"mov	r5, 0x5 \n\t"	\
			"mov	r6, 0x6 \n\t"	\
			"st	r7, [%0] \n\t"	\
			"mov	r8, 0x8 \n\t"	\
			"mov	r9, 0x9 \n\t"	\
			"mov	r10, 0x10 \n\t"	\
			"mov	r11, 0x11 \n\t"	\
			"mov	r12, 0x12 \n\t"	\
			"mov	r13, 0x13 \n\t"	\
			"mov	r14, 0x14 \n\t"	\
			"mov	r15, 0x15 \n\t"	\
			"mov	r16, 0x16 \n\t"	\
			"mov	r17, 0x17 \n\t"	\
			"mov	r18, 0x18 \n\t"	\
			"mov	r19, 0x19 \n\t"	\
			"mov	r20, 0x20 \n\t"	\
			"mov	r21, 0x21 \n\t"	\
			"mov	r22, 0x22 \n\t"	\
			"mov	r23, 0x23 \n\t"	\
			"mov	r24, 0x24 \n\t"	\
			"mov	r25, 0x25 \n\t"	\
			"mov	r26, 0x26 \n\t"	\
			"mov	%lp_count, 0x111 \n\t"	\
			"sr	0xdeadb00b, [lp_start] \n\t"	\
			"sr	0xdeadb00b, [lp_end] \n\t"	\
			:					\
			: "r" (var)				\
			: "r0","r1","r2","r3","r4","r5","r6","r7","r8",			\
			  "r9","r10","r11","r12","r13","r14","r15","r16","r17",		\
			  "r18","r19","r20","r21","r22","r23","r24","r25","r26",	\
			  "lp_count"							\
		);									\
}

#define loadtestcontext2() {			\
	__asm__ __volatile__ (			\
			"mov	r0, 0xf0 \n\t"	\
			"mov	r1, 0xf1 \n\t"	\
			"mov	r2, 0xf2 \n\t"	\
			"mov	r3, 0xf3 \n\t"	\
			"mov	r4, 0xf4 \n\t"	\
			"mov	r5, 0xf5 \n\t"	\
			"mov	r6, 0xf6 \n\t"	\
			"mov	r7, 0xf7 \n\t"	\
			"mov	r8, 0xf8 \n\t"	\
			"mov	r9, 0xf9 \n\t"	\
			"mov	r10, 0xf10 \n\t"	\
			"mov	r11, 0xf11 \n\t"	\
			"mov	r12, 0xf12 \n\t"	\
			"mov	r13, 0xf13 \n\t"	\
			"mov	r14, 0xf14 \n\t"	\
			"mov	r15, 0xf15 \n\t"	\
			"mov	r16, 0xf16 \n\t"	\
			"mov	r17, 0xf17 \n\t"	\
			"mov	r18, 0xf18 \n\t"	\
			"mov	r19, 0xf19 \n\t"	\
			"mov	r20, 0xf20 \n\t"	\
			"mov	r21, 0xf21 \n\t"	\
			"mov	r22, 0xf22 \n\t"	\
			"mov	r23, 0xf23 \n\t"	\
			"mov	r24, 0xf24 \n\t"	\
			"mov	r25, 0xf25 \n\t"	\
			"mov	r26, 0xf26 \n\t"	\
			"mov	%lp_count, 0x111 \n\t"	\
			"sr	0xfeadb00b, [lp_start] \n\t"	\
			"sr	0xfeadb00b, [lp_end] \n\t"	\
			:					\
			:					\
			: "r0","r1","r2","r3","r4","r5","r6","r7","r8",			\
			  "r9","r10","r11","r12","r13","r14","r15","r16","r17",		\
			  "r18","r19","r20","r21","r22","r23","r24","r25","r26",	\
			  "lp_count"							\
		);									\
}

#endif
#endif /* ARC_CONTEXT_DEBUG */			

#endif /* !__ASSEMBLY__ */
#endif /* _ASM_ARC_DEBUG_H */

