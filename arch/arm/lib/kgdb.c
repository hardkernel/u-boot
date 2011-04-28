#include <common.h>
#include <asm-generic/signal.h>
#include <kgdb.h>


/*
 * kgdb_breakpoint - generate breakpoint exception
 *
 * This function will generate a breakpoint exception.  It is used at the
 * beginning of a program to sync up with a debugger and can be used
 * otherwise as a quick means to stop program execution and "break" into
 * the debugger.
 */ 
void kgdb_breakpoint (int argc, char * const argv[])
{
	arch_kgdb_breakpoint();
}

int kgdb_setjmp(long *buf)
{
	asm("	stmia	r0, {r0-r14}\n	\
		str	lr,[r0, #60]\n	\
		mrs	r1,cpsr\n	\
		str	r1,[r0,#64]\n	\
		ldr	r1,[r0,#4]\n	\
	    ");
	return 0;
}

void kgdb_longjmp(long *buf, int val)
{
	asm("	str	r1,[r0]\n	\
		ldr     r1,[r0, #64]\n	\
		msr     spsr,r1\n	\
		ldmia	r0,{r0-pc}^\n	\
	    ");
}

int kgdb_trap(struct pt_regs *regs)
{
	return SIGTRAP;
}

void kgdb_enter(struct pt_regs *regs, kgdb_data *kdp)
{
	kdp->sigval = kgdb_trap(regs);
	kdp->nregs = 0;
}

void kgdb_exit(struct pt_regs *regs, kgdb_data *kdp)
{
}

int kgdb_getregs(struct pt_regs *regs, char *buf, int max)
{
	int i;
	unsigned long *gdb_regs = (unsigned long *)buf;

	if (max < (GDB_MAX_REGS * sizeof(unsigned long)))
		kgdb_error(KGDBERR_NOSPACE);

	/* Initialize all to zero. */
	for (i = 0; i < GDB_MAX_REGS; i++)
		gdb_regs[i] = 0;

	gdb_regs[_R0]   = regs->ARM_r0;
	gdb_regs[_R1]   = regs->ARM_r1;
	gdb_regs[_R2]   = regs->ARM_r2;
	gdb_regs[_R3]   = regs->ARM_r3;
	gdb_regs[_R4]   = regs->ARM_r4;
	gdb_regs[_R5]   = regs->ARM_r5;
	gdb_regs[_R6]   = regs->ARM_r6;
	gdb_regs[_R7]   = regs->ARM_r7;
	gdb_regs[_R8]   = regs->ARM_r8;
	gdb_regs[_R9]   = regs->ARM_r9;
	gdb_regs[_R10]  = regs->ARM_r10;
	gdb_regs[_FP]   = regs->ARM_fp;
	gdb_regs[_IP]   = regs->ARM_ip;
	gdb_regs[_SPT]  = regs->ARM_sp;
	gdb_regs[_LR]   = regs->ARM_lr;
	gdb_regs[_PC]   = regs->ARM_pc;
	gdb_regs[_CPSR] = regs->ARM_cpsr;

	return GDB_MAX_REGS *sizeof(unsigned long);
}

void kgdb_putreg(struct pt_regs *regs, int regno, char *buf, int length)
{
	unsigned long val=0, *ptr = (unsigned long *)buf;

	if (regno < 0 || GDB_MAX_REGS <= regno)
		kgdb_error(KGDBERR_BADPARAMS);
	else {
		if (length < 4)
			kgdb_error(KGDBERR_NOSPACE);
	}
	if ((unsigned long)ptr & 3)
		kgdb_error(KGDBERR_ALIGNFAULT);
	else
		val = *ptr;

	switch (regno) {
	case _R0:
		regs->ARM_r0 = val; break;
	case _R1:
		regs->ARM_r1 = val; break;
	case _R2:
		regs->ARM_r2 = val; break;
	case _R3:
		regs->ARM_r3 = val; break;
	case _R4:
		regs->ARM_r4 = val; break;
	case _R5:
		regs->ARM_r5 = val; break;
	case _R6:
		regs->ARM_r6 = val; break;
	case _R7:
		regs->ARM_r7 = val; break;
	case _R8:
		regs->ARM_r8 = val; break;
	case _R9:
		regs->ARM_r9 = val; break;
	case _R10:
		regs->ARM_r10 = val; break;
	case _FP:
		regs->ARM_fp = val; break;
	case _IP:
		regs->ARM_ip = val; break;
	case _SPT:
		regs->ARM_sp = val; break;
	case _LR:
		regs->ARM_lr = val; break;
	case _PC:
		regs->ARM_pc = val; break;
	case 0x19:
		regs->ARM_cpsr = val; break;
	default:
		kgdb_error(KGDBERR_BADPARAMS);
	}
}

void kgdb_putregs(struct pt_regs *regs, char *buf, int length)
{
	unsigned long *gdb_regs = (unsigned long *)buf;

	if (length < (GDB_MAX_REGS *sizeof(unsigned long)))
		kgdb_error(KGDBERR_NOSPACE);

	if ((unsigned long)gdb_regs & 3)
		kgdb_error(KGDBERR_ALIGNFAULT);

	regs->ARM_r0	= gdb_regs[_R0];
	regs->ARM_r1	= gdb_regs[_R1];
	regs->ARM_r2	= gdb_regs[_R2];
	regs->ARM_r3	= gdb_regs[_R3];
	regs->ARM_r4	= gdb_regs[_R4];
	regs->ARM_r5	= gdb_regs[_R5];
	regs->ARM_r6	= gdb_regs[_R6];
	regs->ARM_r7	= gdb_regs[_R7];
	regs->ARM_r8	= gdb_regs[_R8];
	regs->ARM_r9	= gdb_regs[_R9];
	regs->ARM_r10	= gdb_regs[_R10];
	regs->ARM_fp	= gdb_regs[_FP];
	regs->ARM_ip	= gdb_regs[_IP];
	regs->ARM_sp	= gdb_regs[_SPT];
	regs->ARM_lr	= gdb_regs[_LR];
	regs->ARM_pc	= gdb_regs[_PC];
	regs->ARM_cpsr	= gdb_regs[_CPSR];
}

void kgdb_interruptible(int yes)
{
#ifdef CONFIG_USE_IRQ
	if (yes)
		enable_interrupts();
	else
		disable_interrupts();
#endif
}

void arch_kgdb_set_sw_break(struct kgdb_bkpt *bkpt)
{
	int addr = bkpt->bpt_addr;
	memcpy(bkpt->saved_instr, (unsigned long *)addr, BREAK_INSTR_SIZE);
	*(unsigned long *)addr = KGDB_COMPILED_BREAK;
	kgdb_flush_cache_all();
}

void arch_kgdb_remove_sw_break(struct kgdb_bkpt *bkpt)
{
	int addr = bkpt->bpt_addr;
	memcpy((unsigned long *)addr, bkpt->saved_instr, BREAK_INSTR_SIZE);
	kgdb_flush_cache_all();
}

