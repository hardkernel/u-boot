#ifndef __ASM_ARM_SYSTEM_H
#define __ASM_ARM_SYSTEM_H

#ifdef __KERNEL__

#define CPU_ARCH_UNKNOWN	0
#define CPU_ARCH_ARMv3		1
#define CPU_ARCH_ARMv4		2
#define CPU_ARCH_ARMv4T		3
#define CPU_ARCH_ARMv5		4
#define CPU_ARCH_ARMv5T		5
#define CPU_ARCH_ARMv5TE	6
#define CPU_ARCH_ARMv5TEJ	7
#define CPU_ARCH_ARMv6		8
#define CPU_ARCH_ARMv7		9

/*
 * CR1 bits (CP#15 CR1)
 */
#define CR_M	(1 << 0)	/* MMU enable				*/
#define CR_A	(1 << 1)	/* Alignment abort enable		*/
#define CR_C	(1 << 2)	/* Dcache enable			*/
#define CR_W	(1 << 3)	/* Write buffer enable			*/
#define CR_P	(1 << 4)	/* 32-bit exception handler		*/
#define CR_D	(1 << 5)	/* 32-bit data address range		*/
#define CR_L	(1 << 6)	/* Implementation defined		*/
#define CR_B	(1 << 7)	/* Big endian				*/
#define CR_S	(1 << 8)	/* System MMU protection		*/
#define CR_R	(1 << 9)	/* ROM MMU protection			*/
#define CR_F	(1 << 10)	/* Implementation defined		*/
#define CR_Z	(1 << 11)	/* Implementation defined		*/
#define CR_I	(1 << 12)	/* Icache enable			*/
#define CR_V	(1 << 13)	/* Vectors relocated to 0xffff0000	*/
#define CR_RR	(1 << 14)	/* Round Robin cache replacement	*/
#define CR_L4	(1 << 15)	/* LDR pc can set T bit			*/
#define CR_DT	(1 << 16)
#define CR_IT	(1 << 18)
#define CR_ST	(1 << 19)
#define CR_FI	(1 << 21)	/* Fast interrupt (lower latency mode)	*/
#define CR_U	(1 << 22)	/* Unaligned access operation		*/
#define CR_XP	(1 << 23)	/* Extended page tables			*/
#define CR_VE	(1 << 24)	/* Vectored interrupts			*/
#define CR_EE	(1 << 25)	/* Exception (Big) Endian		*/
#define CR_TRE	(1 << 28)	/* TEX remap enable			*/
#define CR_AFE	(1 << 29)	/* Access flag enable			*/
#define CR_TE	(1 << 30)	/* Thumb exception enable		*/


// Definitions for section descriptors
//
// - Standard definitions of mode bits and interrupt (I&F) flags in PSRs
#define  Mode_USR         0x10
#define  Mode_FIQ         0x11
#define  Mode_IRQ         0x12
#define  Mode_SVC         0x13
#define  Mode_ABT         0x17
#define  Mode_UNDEF       0x1B
#define  Mode_SYS         0x1F
#define  I_Bit            0x80 // when I bit is set, IRQ is disabled
#define  F_Bit            0x40 // when F bit is set, FIQ is disabled


#define SEC_NG            (1 << 17)
#define SEC_S             (1 << 16)
#define SEC_AP2           (1 << 15)
#define SEC_TEX0          (1 << 12)
#define SEC_TEX1          (1 << 13)
#define SEC_TEX2          (1 << 14)
#define SEC_AP0           (1 << 10)
#define SEC_AP1           (1 << 11)
#define SEC_P             (1 << 9)
#define SEC_XN            (1 << 4)
#define SEC_C             (1 << 3)
#define SEC_B             (1 << 2)

#define SECTION           0x02
#define FAULT		      0

#define  SEC_SO_MEM       (SEC_S | SECTION)
#define  SEC_S_DEVICE     (SEC_S | SEC_B | SECTION)
#define  SEC_WT     	  (SEC_C | SECTION)
#define  SEC_WB		      (SEC_C | SEC_B | SECTION)
#define  SEC_NC		      (SEC_TEX0 | SECTION)
#define  SEC_DEVICE 	  (SEC_TEX1 | SECTION)
#define  SEC_INOUT	      (SEC_TEX2 | SECTION)

#define  SEC_I_NC	      (0)
#define  SEC_I_WBWA	      (SEC_B)
#define  SEC_I_WT	      (SEC_C)
#define  SEC_I_WB	      (SEC_C | SEC_B)
#define  SEC_O_NC	      (0)
#define  SEC_O_WBWA	      (SEC_TEX0)
#define  SEC_O_WT	      (SEC_TEX1)
#define  SEC_O_WB	      (SEC_TEX1 | SEC_TEX0)

#define SEC_PROT_N	      (0)
#define SEC_PROT_RW_NA    (SEC_AP0)
#define SEC_PROT_RW_RO	  (SEC_AP1)
#define SEC_PROT_RW_RW	  (SEC_AP1 | SEC_AP0)
#define SEC_PROT_RO_NA	  (SEC_AP2 | SEC_AP0)
#define SEC_PROT_RO_RO	  (SEC_AP2 | SEC_AP1)



// Definitions for page descriptors

#define PAGE_NGLOBAL          (1 << 11)
#define PAGE_SHARED           (1 << 10)
#define PAGE_APX              (1 << 9)
#define PAGE_TEX1             (1 << 6)
#define PAGE_AP1              (1 << 5)
#define PAGE_AP0              (1 << 4)
#define PAGE_CACHE            (1 << 3)
#define PAGE_BUFFER           (1 << 2)
#define IS_A_PAGE          (1 << 1)
#define PAGE_XN               (1 << 0)

#define IS_A_PAGETABLE     (1 << 0)

#define PAGE_NORMAL                   (PAGE_TEX1 | PAGE_CACHE | PAGE_BUFFER | IS_A_PAGE | PAGE_AP0 | PAGE_AP1)
#define PAGE_SHARED_NORMAL            (PAGE_NORMAL | PAGE_SHARED)
#define PAGE_SHARED_STRONGLY_ORDERED  (PAGE_SHARED | PAGE_AP0 | PAGE_AP1 | IS_A_PAGE)

/*
 * This is used to ensure the compiler did actually allocate the register we
 * asked it for some inline assembly sequences.  Apparently we can't trust
 * the compiler from one version to another so a bit of paranoia won't hurt.
 * This string is meant to be concatenated with the inline asm string and
 * will cause compilation to stop on mismatch.
 * (for details, see gcc PR 15089)
 */
#define __asmeq(x, y)  ".ifnc " x "," y " ; .err ; .endif\n\t"

#ifndef __ASSEMBLY__

#define isb() __asm__ __volatile__ ("" : : : "memory")

#define nop() __asm__ __volatile__("mov\tr0,r0\t@ nop\n\t");

static inline unsigned int get_cr(void)
{
	unsigned int val;
	asm("mrc p15, 0, %0, c1, c0, 0	@ get CR" : "=r" (val) : : "cc");
	return val;
}

static inline void set_cr(unsigned int val)
{
	asm volatile("mcr p15, 0, %0, c1, c0, 0	@ set CR"
	  : : "r" (val) : "cc");
	isb();
}

#endif /* __ASSEMBLY__ */

#define arch_align_stack(x) (x)

#endif /* __KERNEL__ */

#endif
