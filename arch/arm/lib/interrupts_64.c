/*
 * (C) Copyright 2013
 * David Feng <fenghua@phytium.com.cn>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <linux/compiler.h>
#include <efi_loader.h>

DECLARE_GLOBAL_DATA_PTR;
#if defined(CONFIG_SPL_BUILD) || !defined(CONFIG_IRQ)

int interrupt_init(void)
{
	return 0;
}

void enable_interrupts(void)
{
	return;
}

int disable_interrupts(void)
{
	return 0;
}
#endif

#if (!defined(CONFIG_SPL_BUILD) && !defined(CONFIG_TPL_BUILD))
#define REG_BITS(val, shift, mask)	(((val) >> (shift)) & (mask))

void show_regs(struct pt_regs *regs)
{
	int i;
	int el = current_el();
	const char *h_scr_name[] = {
		[2] = "HCR_EL2",
		[3] = "SCR_EL3",
	};
	const char *esr_bits_ec[] = {
		[0]  = "EC[31:26] == 000000, Exception with an unknown reason",
		[1]  = "EC[31:26] == 000001, Exception from a WFI or WFE instruction",
		[3]  = "EC[31:26] == 000011, Exception from an MCR or MRC access",
		[4]  = "EC[31:26] == 000100, Exception from an MCRR or MRRC access",
		[5]  = "EC[31:26] == 000101, Exception from an MCR or MRC access",
		[6]  = "EC[31:26] == 000110, Exception from an LDC or STC access to CP14",
		[7]  = "EC[31:26] == 000111, Exception from an access to an Advanced SIMD or floating-point register, resulting from CPACR_EL1.FPEN or CPTR_ELx.TFP",
		[8]  = "EC[31:26] == 001000, Exception from an MCR or MRC access",
		[12] = "EC[31:26] == 001100, Exception from an MCRR or MRRC access",
		[14] = "EC[31:26] == 001110, Exception from an Illegal execution state, or a PC or SP alignment fault",
		[10] = "EC[31:26] == 010001, Exception from HVC or SVC instruction execution",
		[18] = "EC[31:26] == 010010, Exception from HVC or SVC instruction execution",
		[19] = "EC[31:26] == 010011, Exception from SMC instruction execution in AArch32 state",
		[21] = "EC[31:26] == 010101, Exception from HVC or SVC instruction execution",
		[22] = "EC[31:26] == 010110, Exception from HVC or SVC instruction execution",
		[23] = "EC[31:26] == 010111, Exception from SMC instruction execution in AArch64 state",
		[24] = "EC[31:26] == 011000, Exception from MSR, MRS, or System instruction execution in AArch64 state",
		[31] = "EC[31:26] == 011111, IMPLEMENTATION DEFINED exception to EL3",
		[32] = "EC[31:26] == 100000, Exception from an Instruction abort",
		[33] = "EC[31:26] == 100001, Exception from an Instruction abort",
		[34] = "EC[31:26] == 100010, Exception from an Illegal execution state, or a PC or SP alignment fault",
		[36] = "EC[31:26] == 100100, Exception from a Data abort, from lower exception level",
		[37] = "EC[31:26] == 100101, Exception from a Data abort, from current exception level",
		[38] = "EC[31:26] == 100110, Exception from an Illegal execution state, or a PC or SP alignment fault",
		[40] = "EC[31:26] == 101000, Exception from a trapped Floating-point exception",
		[44] = "EC[31:26] == 101100, Exception from a trapped Floating-point exception",
		[47] = "EC[31:26] == 101111, SError interrupt",
		[48] = "EC[31:26] == 110000, Exception from a Breakpoint or Vector Catch debug event",
		[49] = "EC[31:26] == 110001, Exception from a Breakpoint or Vector Catch debug event",
		[50] = "EC[31:26] == 110010, Exception from a Software Step debug event",
		[51] = "EC[31:26] == 110011, Exception from a Software Step debug event",
		[52] = "EC[31:26] == 110100, Exception from a Watchpoint debug event",
		[53] = "EC[31:26] == 110101, Exception from a Watchpoint debug event",
		[56] = "EC[31:26] == 111000, Exception from execution of a Software Breakpoint instructio",
	};
	const char *esr_bits_il[] = {
		"IL[25] == 0, 16-bit instruction trapped",
		"IL[25] == 1, 32-bit instruction trapped",
	};
	const char *daif_bits_f[] = {
		"F[6] == 0, FIQ not masked",
		"F[6] == 1, FIQ masked",
	};
	const char *daif_bits_i[] = {
		"I[7] == 0, IRQ not masked",
		"I[7] == 1, IRQ masked",
	};
	const char *daif_bits_a[] = {
		"A[8] == 0, ABORT not masked",
		"A[8] == 1, ABORT masked",
	};
	const char *daif_bits_d[] = {
		"D[9] == 0, DBG not masked",
		"D[9] == 1, DBG masked",
	};
	const char *spsr_bits_m_aarch32[] = {
		[0]  = "M[3:0] == 0000, User",
		[1]  = "M[3:0] == 0001, FIQ",
		[2]  = "M[3:0] == 0010, IRQ",
		[3]  = "M[3:0] == 0011, Supervisor",
		[6]  = "M[3:0] == 0110, Monitor",
		[7]  = "M[3:0] == 0111, Abort",
		[10] = "M[3:0] == 1010, Hyp",
		[11] = "M[3:0] == 1011, Undefined",
		[15] = "M[3:0] == 1111, System",
	};
	const char *spsr_bits_m_aarch64[] = {
		[0] = "M[3:0] == 0000, EL0t",
		[4] = "M[3:0] == 0100, EL1t",
		[5] = "M[3:0] == 0101, EL1h",
		[8] = "M[3:0] == 1000, EL2t",
		[9] = "M[3:0] == 1001, EL2h",
		[10] = "M[3:0] == 1100, EL3t",
		[11] = "M[3:0] == 1101, EL3h",
	};
	const char *spsr_bits_m[] = {
		"M[4] == 0, Exception taken from AArch64",
		"M[4] == 1, Exception taken from AArch32",
	};
	const char *spsr_bits_f[] = {
		"F[6] == 0, FIQ not masked",
		"F[6] == 1, FIQ masked",
	};
	const char *spsr_bits_i[] = {
		"I[7] == 0, IRQ not masked",
		"I[7] == 1, IRQ masked",
	};
	const char *spsr_bits_a[] = {
		"A[8] == 0, ABORT not masked",
		"A[8] == 1, ABORT masked",
	};
	const char *spsr_bits_d[] = {
		"D[9] == 0, DBG not masked",
		"D[9] == 1, DBG masked",
	};
	const char *sctlr_bits_i[] = {
		"I[12] == 0, Icache disabled",
		"I[12] == 1, Icaches enabled",
	};
	const char *sctlr_bits_c[] = {
		"C[2] == 0, Dcache disabled",
		"C[2] == 1, Dcache enabled",
	};
	const char *sctlr_bits_m[] = {
		"M[0] == 0, MMU disabled",
		"M[0] == 1, MMU enabled",
	};

	printf("* Relocate offset = %016lx\n", gd->reloc_off);

	if (gd->flags & GD_FLG_RELOC) {
		printf("* ELR(PC)    =   %016lx\n", regs->elr - gd->reloc_off);
		printf("* LR         =   %016lx\n", regs->regs[30] - gd->reloc_off);
	} else {
		printf("* ELR(PC)    =   %016lx\n", regs->elr);
		printf("* LR         =   %016lx\n", regs->regs[30]);
	}

	printf("* SP         =   %016lx\n", regs->sp);
	printf("\n");

	/*
	 * System registers
	 */
	/* ESR_EL2 */
	printf("* ESR_EL%d    =   %016lx\n", el, regs->esr);
	printf("\t%s\n", esr_bits_ec[REG_BITS(regs->esr, 26, 0x3f)]);
	printf("\t%s\n", esr_bits_il[REG_BITS(regs->esr, 25, 0x01)]);
	printf("\n");
	/* DAIF */
	printf("* DAIF       =   %016lx\n", regs->daif);
	printf("\t%s\n", daif_bits_d[REG_BITS(regs->daif, 9, 0x1)]);
	printf("\t%s\n", daif_bits_a[REG_BITS(regs->daif, 8, 0x1)]);
	printf("\t%s\n", daif_bits_i[REG_BITS(regs->daif, 7, 0x1)]);
	printf("\t%s\n", daif_bits_f[REG_BITS(regs->daif, 6, 0x1)]);
	printf("\n");
	/* SPSR_ELx */
	printf("* SPSR_EL%d   =	 %016lx\n", el, regs->spsr);
	printf("\t%s\n", spsr_bits_d[REG_BITS(regs->spsr, 9, 0x1)]);
	printf("\t%s\n", spsr_bits_a[REG_BITS(regs->spsr, 8, 0x1)]);
	printf("\t%s\n", spsr_bits_i[REG_BITS(regs->spsr, 7, 0x1)]);
	printf("\t%s\n", spsr_bits_f[REG_BITS(regs->spsr, 6, 0x1)]);
	printf("\t%s\n", spsr_bits_m[REG_BITS(regs->spsr, 4, 0x1)]);
	if (REG_BITS(regs->spsr, 4, 0x1))
		printf("\t%s\n", spsr_bits_m_aarch32[REG_BITS(regs->spsr, 0, 0xf)]);
	else
		printf("\t%s\n", spsr_bits_m_aarch64[REG_BITS(regs->spsr, 0, 0xf)]);
	printf("\n");
	/* SCTLR_EL2 */
	printf("* SCTLR_EL%d  =	 %016lx\n", el, regs->sctlr);
	printf("\t%s\n", sctlr_bits_i[REG_BITS(regs->sctlr, 12, 0x1)]);
	printf("\t%s\n", sctlr_bits_c[REG_BITS(regs->sctlr, 2, 0x1)]);
	printf("\t%s\n", sctlr_bits_m[REG_BITS(regs->sctlr, 0, 0x1)]);
	printf("\n");

	/* Other */
	if (el >= 2)
		printf("* %s    =   %016lx\n", h_scr_name[el], regs->hcr);
	printf("* VBAR_EL%d   =   %016lx\n", el, regs->vbar);
	printf("* TTBR0_EL%d  =   %016lx\n", el, regs->ttbr0);
	printf("\n");

	for (i = 0; i < 29; i += 2)
		printf("x%-2d: %016lx x%-2d: %016lx\n",
		       i, regs->regs[i], i+1, regs->regs[i+1]);
	printf("\n");

#ifdef CONFIG_ROCKCHIP_CRASH_DUMP
	iomem_show_by_compatible("-cru", 0, 0x400);
	iomem_show_by_compatible("-pmucru", 0, 0x400);
	iomem_show_by_compatible("-grf", 0, 0x400);
	iomem_show_by_compatible("-pmugrf", 0, 0x400);
	/* tobe add here ... */
#endif
}

#else
void show_regs(struct pt_regs *regs)
{
	int i;

	if (gd->flags & GD_FLG_RELOC) {
		printf("ELR:     %lx\n", regs->elr - gd->reloc_off);
		printf("LR:      %lx\n", regs->regs[30] - gd->reloc_off);
	} else {
		printf("ELR:     %lx\n", regs->elr);
		printf("LR:      %lx\n", regs->regs[30]);
	}
	for (i = 0; i < 29; i += 2)
		printf("x%-2d: %016lx x%-2d: %016lx\n",
		       i, regs->regs[i], i+1, regs->regs[i+1]);
	printf("\n");
}
#endif

/*
 * do_bad_sync handles the impossible case in the Synchronous Abort vector.
 */
void do_bad_sync(struct pt_regs *pt_regs, unsigned int esr)
{
	efi_restore_gd();
	printf("Bad mode in \"Synchronous Abort\" handler, esr 0x%08x\n", esr);
	show_regs(pt_regs);
	panic("Resetting CPU ...\n");
}

/*
 * do_bad_irq handles the impossible case in the Irq vector.
 */
void do_bad_irq(struct pt_regs *pt_regs, unsigned int esr)
{
	efi_restore_gd();
	printf("Bad mode in \"Irq\" handler, esr 0x%08x\n", esr);
	show_regs(pt_regs);
	panic("Resetting CPU ...\n");
}

/*
 * do_bad_fiq handles the impossible case in the Fiq vector.
 */
void do_bad_fiq(struct pt_regs *pt_regs, unsigned int esr)
{
	efi_restore_gd();
	printf("Bad mode in \"Fiq\" handler, esr 0x%08x\n", esr);
	show_regs(pt_regs);
	panic("Resetting CPU ...\n");
}

/*
 * do_bad_error handles the impossible case in the Error vector.
 */
void do_bad_error(struct pt_regs *pt_regs, unsigned int esr)
{
	efi_restore_gd();
	printf("Bad mode in \"Error\" handler, esr 0x%08x\n", esr);
	show_regs(pt_regs);
	panic("Resetting CPU ...\n");
}

/*
 * do_sync handles the Synchronous Abort exception.
 */
void do_sync(struct pt_regs *pt_regs, unsigned int esr)
{
	efi_restore_gd();
	printf("\"Synchronous Abort\" handler, esr 0x%08x\n", esr);
	show_regs(pt_regs);
	panic("Resetting CPU ...\n");
}

#if defined(CONFIG_SPL_BUILD) || !defined(CONFIG_IRQ)
/*
 * do_irq handles the Irq exception.
 */
void do_irq(struct pt_regs *pt_regs, unsigned int esr)
{
	efi_restore_gd();
	printf("\"Irq\" handler, esr 0x%08x\n", esr);
	show_regs(pt_regs);
	panic("Resetting CPU ...\n");
}
#endif

/*
 * do_fiq handles the Fiq exception.
 */
void do_fiq(struct pt_regs *pt_regs, unsigned int esr)
{
	efi_restore_gd();
	printf("\"Fiq\" handler, esr 0x%08x\n", esr);
	show_regs(pt_regs);
	panic("Resetting CPU ...\n");
}

/*
 * do_error handles the Error exception.
 * Errors are more likely to be processor specific,
 * it is defined with weak attribute and can be redefined
 * in processor specific code.
 */
void __weak do_error(struct pt_regs *pt_regs, unsigned int esr)
{
	efi_restore_gd();
	printf("\"Error\" handler, esr 0x%08x\n", esr);
	show_regs(pt_regs);
	panic("Resetting CPU ...\n");
}
