#include <arch.h>
	.global _invalidate_dcache
	.global _clean_dcache
	.global _clean_invd_dcache
	.global _invalidate_dcache_addr
	.global _clean_dcache_addr
	.global _clean_invd_dcache_addr
	.global _invalidate_icache
	.global cache_enable
	.global cache_disable

	/*==============================================
	*MACROs definition
	*==============================================*/
	.macro	disable_irq
	msr	daifset, #2
	.endm

	.macro	enable_irq
	msr	daifclr, #2
	.endm

	.macro	save_and_disable_irqs, olddaif
	mrs	\olddaif, daif
	disable_irq
	.endm

	.macro	restore_irqs, olddaif
	msr	daif, \olddaif
	.endm

	/*==============================================
	* void _invalidate_dcache(void)
	* invalid dcache by Set/Way
	*==============================================*/
	.type _invalidate_dcache, @function
_invalidate_dcache:
	/* ensure ordering with previous memory accesses*/
	dsb	sy
	mrs	x0, clidr_el1			/* read clidr */
	and	x3, x0, #0x7000000		/* extract loc from clidr */
	lsr	x3, x3, #23			/* left align loc bit field */
	cbz	x3, finished_invalid	/*if loc is 0, then no need to clean*/
	mov	x10, #0			/* start clean at cache level 0*/
loop1_invalid:
	add	x2, x10, x10, lsr #1 /*work out 3x current cache level*/
	lsr	x1, x0, x2	/*extract cache type bits from clidr*/
	and	x1, x1, #7	 /*mask of the bits for current cache only*/
	cmp	x1, #2		/*see what cache we have at this level*/
	b.lt	skip_invalid	/*skip if no cache, or just i-cache*/
	save_and_disable_irqs x9	/*make CSSELR and CCSIDR access atomic*/
	msr	csselr_el1, x10		/*select current cache level in csselr*/
	isb			/*isb to sych the new cssr&csidr*/
	mrs	x1, ccsidr_el1		/*read the new ccsidr*/
	restore_irqs x9
	and	x2, x1, #7	 /*extract the length of the cache lines*/
	add	x2, x2, #4		/*add 4 (line length offset)*/
	mov	x4, #0x3ff
	and	x4, x4, x1, lsr #3	/*find maximum number on the way size*/
	clz	w5, w4		/*find bit position of way size increment*/
	mov	x7, #0x7fff
	and	x7, x7, x1, lsr #13	/*extract max number of the index size*/
loop2_invalid:
	mov	x9, x4		/*create working copy of max way size*/
loop3_invalid:
	lsl	x6, x9, x5
	orr	x11, x10, x6		/*factor way and cache number into x11*/
	lsl	x6, x7, x2
	orr	x11, x11, x6		/*factor index number into x11*/
	dc	isw, x11		/*clean & invalidate by set/way*/
	subs	x9, x9, #1		/*decrement the way*/
	b.ge	loop3_invalid
	subs	x7, x7, #1		/*decrement the index*/
	b.ge	loop2_invalid
skip_invalid:
	add	x10, x10, #2		/*increment cache number*/
	cmp	x3, x10
	b.gt	loop1_invalid
finished_invalid:
	mov	x10, #0			/*swith back to cache level 0*/
	msr	csselr_el1, x10		/*select current cache level in csselr*/
	dsb	sy
	isb
	ret


	/*==============================================
	* void _clean_dcache(void)
	* clean dcache by Set/Way
	* ==============================================*/
	.type _clean_dcache, @function
_clean_dcache:
	dsb	sy	 /*ensure ordering with previous memory accesses*/
	mrs	x0, clidr_el1			/*read clidr*/
	and	x3, x0, #0x7000000		/*extract loc from clidr*/
	lsr	x3, x3, #23		/*left align loc bit field*/
	cbz	x3, finished_clean	/*if loc is 0, then no need to clean*/
	mov	x10, #0			/*start clean at cache level 0*/
loop1_clean:
	add	x2, x10, x10, lsr #1	/*work out 3x current cache level*/
	lsr	x1, x0, x2		/*extract cache type bits from clidr*/
	and	x1, x1, #7	 /*mask of the bits for current cache only*/
	cmp	x1, #2			/*see what cache we have at this level*/
	b.lt	skip_clean	/*skip if no cache, or just i-cache*/
	save_and_disable_irqs x9	/*make CSSELR and CCSIDR access atomic*/
	msr	csselr_el1, x10		/*select current cache level in csselr*/
	isb	/*isb to sych the new cssr&csidr*/
	mrs	x1, ccsidr_el1		/*read the new ccsidr*/
	restore_irqs x9
	and	x2, x1, #7	 /*extract the length of the cache lines*/
	add	x2, x2, #4		/*add 4 (line length offset)*/
	mov	x4, #0x3ff
	and	x4, x4, x1, lsr #3	/*find maximum number on the way size*/
	clz	w5, w4		/*find bit position of way size increment*/
	mov	x7, #0x7fff
	and	x7, x7, x1, lsr #13 /*extract max number of the index size*/
loop2_clean:
	mov	x9, x4	/*create working copy of max way size*/
loop3_clean:
	lsl	x6, x9, x5
	orr	x11, x10, x6 	/*factor way and cache number into x11*/
	lsl	x6, x7, x2
	orr	x11, x11, x6		/*factor index number into x11*/
	dc	csw, x11		/*clean & invalidate by set/way*/
	subs	x9, x9, #1		/*decrement the way*/
	b.ge	loop3_clean
	subs	x7, x7, #1		/*decrement the index*/
	b.ge	loop2_clean
skip_clean:
	add	x10, x10, #2	 /*increment cache number*/
	cmp	x3, x10
	b.gt	loop1_clean
finished_clean:
	mov	x10, #0		/*swith back to cache level 0*/
	msr	csselr_el1, x10		/*select current cache level in csselr*/
	dsb	sy
	isb
	ret

	/*==============================================
	* void _clean_invd_dcache(void)
	* clean&invalid dcache by Set/Way
	* ==============================================*/
	.type _clean_invd_dcache, @function
_clean_invd_dcache:
	dsb	sy	 /*ensure ordering with previous memory accesses*/
	mrs	x0, clidr_el1		/*read clidr*/
	and	x3, x0, #0x7000000		/*extract loc from clidr*/
	lsr	x3, x3, #23		/*left align loc bit field*/
	cbz	x3, finished_clean_invd	/*if loc is 0, then no need to clean*/
	mov	x10, #0			/*start clean at cache level 0*/
loop1_clean_invd:
	add	x2, x10, x10, lsr #1	/*work out 3x current cache level*/
	lsr	x1, x0, x2		/*extract cache type bits from clidr*/
	and	x1, x1, #7	/*mask of the bits for current cache only*/
	cmp	x1, #2			/*see what cache we have at this level*/
	b.lt	skip_clean_invd		/*skip if no cache, or just i-cache*/
	save_and_disable_irqs x9	/*make CSSELR and CCSIDR access atomic*/
	msr	csselr_el1, x10		/*select current cache level in csselr*/
	isb			/*isb to sych the new cssr&csidr*/
	mrs	x1, ccsidr_el1	/*read the new ccsidr*/
	restore_irqs x9
	and	x2, x1, #7	/*extract the length of the cache lines*/
	add	x2, x2, #4		/*add 4 (line length offset)*/
	mov	x4, #0x3ff
	and	x4, x4, x1, lsr #3	/*find maximum number on the way size*/
	clz	w5, w4		/*find bit position of way size increment*/
	mov	x7, #0x7fff
	and	x7, x7, x1, lsr #13 /*extract max number of the index size*/
loop2_clean_invd:
	mov	x9, x4		/*create working copy of max way size*/
loop3_clean_invd:
	lsl	x6, x9, x5
	orr	x11, x10, x6		/*factor way and cache number into x11*/
	lsl	x6, x7, x2
	orr	x11, x11, x6		/*factor index number into x11*/
	dc	cisw, x11		/*clean & invalidate by set/way*/
	subs	x9, x9, #1		/*decrement the way*/
	b.ge	loop3_clean_invd
	subs	x7, x7, #1		/*decrement the index*/
	b.ge	loop2_clean_invd
skip_clean_invd:
	add	x10, x10, #2		/*increment cache number*/
	cmp	x3, x10
	b.gt	loop1_clean_invd
finished_clean_invd:
	mov	x10, #0				/*swith back to cache level 0*/
	msr	csselr_el1, x10		/*select current cache level in csselr*/
	dsb	sy
	isb
	ret


	/*==============================================
	* void _invalidate_dcache_addr(unsigned long addr)
	* invalidate dcache by VA
	* ==============================================*/
	.type _invalidate_dcache_addr, @function
_invalidate_dcache_addr:
	dc ivac, x0
	dsb sy
	ret

	/*==============================================
	* void _clean_dcache_addr(unsigned long addr)
	* clean dcache by VA
	* ==============================================*/
	.type _clean_dcache_addr, @function
_clean_dcache_addr:
	dc cvac, x0
	dsb sy
	ret

	/*==============================================
	* void _clean_invd_dcache_addr(unsigned long addr)
	* clean&invalid dcache by VA
	* ==============================================*/
	.type _clean_invd_dcache_addr, @function
_clean_invd_dcache_addr:
	dc civac, x0
	dsb sy
	ret

	/*==============================================
	* void _invalidate_icache(void)
	* invalid icache
	* ==============================================*/
	.type _invalidate_icache, @function
_invalidate_icache:
	ic	ialluis
	isb	sy
	tlbi ALLE3
	ret

	/*==============================================
	* void cache_disable(void)
	* i-cache/d-cache disable
	* ==============================================*/
	.type cache_disable, @function
cache_disable:
	mrs x0, sctlr_el1
	mov x1, #(SCTLR_I_BIT|SCTLR_C_BIT)
	bic x0, x0, x1
	msr sctlr_el1, x0
	dmb sy
	dsb sy
	isb
	ret

	/*==============================================
	* void cache_enable(void)
	* i-cache/d-cache enable
	* ==============================================*/
	.type cache_enable, @function
cache_enable:
	mov	x1, #(SCTLR_I_BIT|SCTLR_C_BIT)
	mrs	x0, sctlr_el1
	orr	x0, x0, x1
	msr	sctlr_el1, x0
	dmb sy
	dsb sy
	isb
	ret
