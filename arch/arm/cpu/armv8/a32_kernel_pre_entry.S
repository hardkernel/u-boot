#include <asm-offsets.h>
#include <config.h>
#include <version.h>
#include <asm/macro.h>
#include <linux/linkage.h>

#define HCR_RW		(1 << 31)
#define HCR_TGE		(1 << 27)
#define HCR_E2H		(1 << 34)


/* AArch32 SPSR*/
#define AARCH32_SPSR_MODE      (3 << 0)
#define AARCH32_SPSR_STATE     (1 << 4)
#define AARCH32_SPSR_DAIF      (7 << 6)

/*
 * void jump_to_a32_kernel(kernel_ep, machid, dtb pointer)
*/
ENTRY(jump_to_a32_kernel)
	mov x20, x0
	mov x21, x1
	mov x22, x2

	mrs	x0, sctlr_el2
	bic	x0, x0, #(1 << 25)
	msr	sctlr_el2, x0

	mov	x2, xzr

	/* sctlr_el1 */
	mov	x0, #0x0878			// Set/clear RES{1,0} bits
	movk	x0, #0x00c5, lsl #16	// Clear EE and E0E on LE systems
	msr	sctlr_el1, x0

#if 0
	/* Generic timers. */
	mrs	x0, cnthctl_el2
	orr	x0, x0, #3			// Enable EL1 physical timers
	msr	cnthctl_el2, x0
	msr	cntvoff_el2, xzr		// Clear virtual offset

	/* Populate ID registers. */
	mrs	x0, midr_el1
	mrs	x1, mpidr_el1
	msr	vpidr_el2, x0
	msr	vmpidr_el2, x1

	/* Coprocessor traps. */
	mov	x0, #0x33ff
	msr	cptr_el2, x0			// Disable copro. traps to EL2

	msr	hstr_el2, xzr			// Disable CP15 traps to EL2

	/* EL2 debug */
	mrs	x0, id_aa64dfr0_el1		// Check ID_AA64DFR0_EL1 PMUVer
	sbfx	x0, x0, #8, #4
	cmp	x0, #1
	b.lt	4f				// Skip if no PMU present
	mrs	x0, pmcr_el0			// Disable debug access traps
	ubfx	x0, x0, #11, #5			// to EL2 and allow access to
4:
	csel	x0, xzr, x0, lt			// all PMU counters from EL1
	msr	mdcr_el2, x0			// (if they exist)

	/* Stage-2 translation */
	msr	vttbr_el2, xzr
#endif

	/* Hyp configuration. */
	mov	x0, #0			// 32-bit EL1 HCR_EL2.RW=0
	msr	hcr_el2, x0
	isb

	/* spsr */
	mov x0, #(AARCH32_SPSR_MODE | \
				AARCH32_SPSR_STATE  | \
				AARCH32_SPSR_DAIF)
	msr	spsr_el2, x0
	msr	elr_el2, x20
	mov x0, #0
	mov x1, x21
	mov x2, x22
	eret
ENDPROC(jump_to_a32_kernel)
