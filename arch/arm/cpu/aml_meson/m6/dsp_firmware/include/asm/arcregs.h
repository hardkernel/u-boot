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
 *  linux/include/asm-arc/arcregs.h
 *
 *  Copyright (C) 
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 * Authors: Amit Bhor ,Ashwin Chaugule
 * Auxiliary register definitions and macros to read and write to them. 
 * Added BCR's reg and masks
 */

#ifndef _ASM_ARC_ARCDEFS_H
#define _ASM_ARC_ARCDEFS_H

/* These are extension BCR's*/
#define ARC_REG_CRC_BCR      0x62
#define ARC_REG_DVFB_BCR     0x64
#define ARC_REG_EXTARITH_BCR 0x65
#define ARC_REG_VECBASE_BCR  0x68
#define ARC_REG_PERIBASE_BCR 0x69
#define ARC_REG_MMU_BCR      0x6f
#define ARC_REG_DCCM_BCR     0x74
#define ARC_REG_TIMERS_BCR   0x75
#define ARC_REG_ICCM_BCR     0x78
#define ARC_REG_XY_MEM_BCR   0x79
#define ARC_REG_MAC_BCR      0x7a
#define ARC_REG_MUL_BCR      0x7b
#define ARC_REG_SWAP_BCR     0x7c
#define ARC_REG_NORM_BCR     0x7d
#define ARC_REG_MIXMAX_BCR   0x7e
#define ARC_REG_BARREL_BCR   0x7f
#define ARC_REG_D_UNCACH_BCR 0x6A

/* status32 Bits Positions */
#define STATUS_H_BIT    0
#define STATUS_E1_BIT   1
#define STATUS_E2_BIT   2
#define STATUS_A1_BIT   3
#define STATUS_A2_BIT   4
#define STATUS_AE_BIT   5
#define STATUS_DE_BIT   6
#define STATUS_U_BIT    7
#define STATUS_L_BIT    12

/* These masks correspond to the status word(STATUS_32) bits */
#define STATUS_H_MASK   (1<<STATUS_H_BIT)   /* Mask for Halt bit */
#define STATUS_E1_MASK  (1<<STATUS_E1_BIT)  /* Mask for Int 1 enable */
#define STATUS_E2_MASK  (1<<STATUS_E2_BIT)  /* Mask for Int 2 enable */
#define STATUS_A1_MASK  (1<<STATUS_A1_BIT)  /* Interrupt 1 active */
#define STATUS_A2_MASK  (1<<STATUS_A2_BIT)  /* Interrupt 2 active */
#define STATUS_AE_MASK  (1<<STATUS_AE_BIT)  /* Exception active */
#define STATUS_DE_MASK  (1<<STATUS_DE_BIT)  /* PC is in delay slot */
#define STATUS_U_MASK   (1<<STATUS_U_BIT)   /* User/Kernel mode bit */
#define STATUS_L_MASK   (1<<STATUS_L_BIT)   /* Loop inhibit bit */

/* These masks correspond to the exception cause register (ecause) bits */

#define ECAUSE_VECTOR_MASK     0xff0000
#define ECAUSE_CODE_MASK       0x00ff00
#define ECAUSE_PARAMETER_MASK  0x0000ff


/* Auxiliary registers not supported by the assembler */
#define AUX_IDENTITY        4
#define AUX_INTR_VEC_BASE   0x25
#define AUX_IRQ_LEV         0x200   /* interrupt priority level setting */
#define AUX_IRQ_HINT        0x201   /* Aux register for generating software interrupts */
#define AUX_IRQ_LV12        0x43    /* interrupt level register */

#define AUX_IENABLE         0x40c   /* Known to the assembler as auxienable, so don't really need this */
#define AUX_ITRIGGER        0x40d

/* Privileged MMU auxiliary register definitions */
#define ARC_REG_TLBPD0      0x405
#define ARC_REG_TLBPD1      0x406
#define ARC_REG_TLBINDEX    0x407   
#define ARC_REG_TLBCOMMAND  0x408
#define ARC_REG_PID         0x409
#define ARC_REG_SCRATCH_DATA0   0x418

/* Instruction cache related Auxiliary registers */
#define ARC_REG_I_CACHE_BUILD_REG 0x77
#define ARC_REG_IC_IVIC     0x10
#define ARC_REG_IC_CTRL     0x11
#define ARC_REG_IC_IVIL     0x19
/* Data cache related Auxiliary registers */
#define ARC_REG_D_CACHE_BUILD_REG 0x72
#define ARC_REG_DC_IVDC     0x47
#define ARC_REG_DC_CTRL     0x48
#define ARC_REG_DC_IVDL     0x4A
#define ARC_REG_DC_FLSH     0x4B
#define ARC_REG_DC_FLDL     0x4C

/* Timer related Aux registers */
#define ARC_REG_TIMER0_LIMIT 0x23 /* timer 0 limit */
#define ARC_REG_TIMER0_CTRL  0x22 /* timer 0 control */
#define ARC_REG_TIMER0_CNT   0x21 /* timer 0 count */
#define ARC_REG_TIMER1_LIMIT 0x102 /* timer 1 limit */
#define ARC_REG_TIMER1_CTRL  0x101 /* timer 1 control */
#define ARC_REG_TIMER1_CNT   0x100 /* timer 1 count */

#define TIMER_CTRL_IE    (1 << 0)    /* Interupt when Count reachs limit */
#define TIMER_CTRL_NH    (1 << 1)    /* Count only when CPU NOT halted */

#ifdef CONFIG_ARC700_SSRAM
/* Synchronous SRAM controller registers */
#define SSRAM_CTRL_BASE 0xc0fc7000  /* Base of the controller registers */
#define SSRAM_CTRL_ID       SSRAM_CTRL_BASE + 0x0
#define SSRAM_CTRL_B0CNFR1  SSRAM_CTRL_BASE + 0x2
#define SSRAM_CTRL_B0CNFR2  SSRAM_CTRL_BASE + 0x3
#define SSRAM_CTRL_B1CNFR1  SSRAM_CTRL_BASE + 0x6
#define SSRAM_CTRL_B1CNFR2  SSRAM_CTRL_BASE + 0x7
#define SSRAM_CTRL_B2CNFR1  SSRAM_CTRL_BASE + 0xa
#define SSRAM_CTRL_B2CNFR2  SSRAM_CTRL_BASE + 0xb
#endif /* CONFIG_ARC700_SSRAM */

#define TLBPD1_MASK 0xffffe1fc /* Mask of bits to be written to the TLBPD1 */

#ifdef CONFIG_ARCH_ARC800

#define ARC_AUX_IDU_REG_CMD     0x2000
#define ARC_AUX_IDU_REG_PARAM   0x2001

#define ARC_AUX_XTL_REG_CMD     0x2002
#define ARC_AUX_XTL_REG_PARAM   0x2003

#define ARC_REG_MP_BCR          0x2021

#define ARC_XTL_REG_SYNTAX_PARAM_PC     1   /* Left shift by 1 */
#define ARC_XTL_REG_SYNTAX_CMD_CPU_ID   8   /* Left shift by 8 */

#define ARC_XTL_CMD_WRITE_PC    0x04
#define ARC_XTL_CMD_CLEAR_HALT  0x02


#endif

// Profiling AUX regs.


#define ARC_PCT_CONTROL         0x255
#define ARC_HWP_CTRL            0xc0fcb018 //Periphbase + b000 + 18
#define PR_CTRL_EN              (1<<0)
#define ARC_PR_ID                   0xc0fcb000


#ifndef __ASSEMBLY__

/****************************************************************** 
 *      Inline ASM macros to read AUX Regs 
 *****************************************************************/

#define read_new_aux_reg(reg)                                   \
({ unsigned int __ret;                                          \
    __asm__ __volatile__("lr    %0, [%1]":"=r"(__ret):"i"(reg));\
    __ret;                                                      \
})
        
/* Aux Reg address is specified as long immediate by caller
 * e.g. 
 *    write_new_aux_reg(0x69, some_val);
 * This generates tightest code.
 */
#define write_new_aux_reg(reg_immed, val)   \
                                          \
    __asm__ __volatile__ (                  \
        "sr   %0, [%1]"                     \
        :                                   \
        :"r"(val),"i"(reg_immed));          \


/* Aux Reg address is specified in a variable
 *  * e.g. 
 *      reg_num = 0x69
 *      write_new_aux_reg2(reg_num, some_val);
 * This has to generate glue code to load the reg num from
 *  memory to a reg hence not recommended.
 */
#define write_new_aux_reg2(reg_in_var, val) \
{                                          \
    unsigned int tmp;                       \
                                            \
    __asm__ __volatile__ (                  \
        "ld   %0, [%2]  \n\t"               \
        "sr   %1, [%0]  \n\t"               \
        :"=&r"(tmp)                         \
        :"r"(val),"memory"(&reg_in_var));   \
}

/**************************************************************** 
 * Register Layouts using bitfields so that we dont have to write
 * bit fiddling ourselves; the compiler can do that for us
 */
struct cpuinfo_arc_processor {
    unsigned int
        family: 8,
        cpu_id: 8,
        chip_id:16;
};

struct cpuinfo_arc_mmu {
    unsigned int   
        num_dTLB        :8,
        num_iTLB        :8,
        entries_per_way :4,
        num_ways        :4,
        ver             :8;
};

#define EXTN_SWAP_VALID     0x1
#define EXTN_NORM_VALID     0x2
#define EXTN_MINMAX_VALID   0x2
#define EXTN_BARREL_VALID   0x2

struct cpuinfo_arc_extn {
    unsigned int

        /* Prog Ref Manual */
        swap:1, norm:2, minmax:2, barrel:2, mul:2, ext_arith:2,

        mac_mul:8,          /* DSP Options Ref Manual */
        crc:1,              /* DSP-LIB Ref Manual */
        dccm:1, iccm:1,
        dvfb:1,             /* Dual Viterbi Butterfly Instrn: 
                               Exotic but not supported by 700
                             */
        padding:9;
};

struct cpuinfo_arc_extn_xymem {
    unsigned int   ver:8,
                    bank_sz:4, num_banks:4,
                    ram_org:2;
};

struct bcr_cache {
    unsigned long ver:8, type:4, sz:4, line_len:4, pad:12;
};


#ifdef CONFIG_ARCH_ARC800
struct cpuinfo_arc800 {
    unsigned int ver:8, scu:1, idu:1, sdu:1, padding:5, mp_arch:16;
};
#endif
 

#endif  /* __ASEMBLY__ */

#endif  /* _ASM_ARC_ARCDEFS_H */
