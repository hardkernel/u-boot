/*
 * ARM KGDB support
 *
 * Author: Deepak Saxena <dsaxena <at> mvista.com>
 *
 * Copyright (C) 2002 MontaVista Software Inc.
 *
 */
#ifndef __ARM_KGDB_H__
#define __ARM_KGDB_H__

#define BREAK_INSTR_SIZE	4
#define KGDB_COMPILED_BREAK	0xe7ffdeff

#ifndef	__ASSEMBLY__

static inline void arch_kgdb_breakpoint(void)
{
	asm(".word 0xe7ffdeff");
}

#endif /* !__ASSEMBLY__ */

/*
 * From Kevin Hilman:
 *
 * gdb is expecting the following registers layout.
 *
 * r0-r15: 1 long word each
 * f0-f7:  unused, 3 long words each !!
 * fps:    unused, 1 long word
 * cpsr:   1 long word
 *
 * Even though f0-f7 and fps are not used, they need to be
 * present in the registers sent for correct processing in
 * the host-side gdb.
 *
 * In particular, it is crucial that CPSR is in the right place,
 * otherwise gdb will not be able to correctly interpret stepping over
 * conditional branches.
 */
#define _GP_REGS		16
#define _FP_REGS		8
#define _EXTRA_REGS		2
#define GDB_MAX_REGS		(_GP_REGS + (_FP_REGS * 3) + _EXTRA_REGS)

#define _R0			0
#define _R1			1
#define _R2			2
#define _R3			3
#define _R4			4
#define _R5			5
#define _R6			6
#define _R7			7
#define _R8			8
#define _R9			9
#define _R10			10
#define _FP			11
#define _IP			12
#define _SPT			13
#define _LR			14
#define _PC			15
#define _CPSR			(GDB_MAX_REGS - 1)

enum kgdb_bptype {
	BP_BREAKPOINT = 0,
	BP_HARDWARE_BREAKPOINT,
	BP_WRITE_WATCHPOINT,
	BP_READ_WATCHPOINT,
	BP_ACCESS_WATCHPOINT
};

enum kgdb_bpstate {
	BP_UNDEFINED = 0,
	BP_REMOVED,
	BP_SET,
	BP_ACTIVE
};

struct kgdb_bkpt {
	unsigned long		bpt_addr;
	unsigned char		saved_instr[BREAK_INSTR_SIZE];
	enum kgdb_bptype	type;
	enum kgdb_bpstate	state;
};

#endif /* __ASM_KGDB_H__ */

