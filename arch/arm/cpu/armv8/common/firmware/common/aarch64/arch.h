/*
 * Copyright (c) 2015 Amlogic, Inc. All rights reserved.
 *
 * This source code is subject to the terms and conditions defined in the
 * file 'LICENSE' which is part of this source code package.
 *
 * AArch64 specific register defines
 */
#ifndef __ARCH_H__
#define __ARCH_H__

/* AArch64 SPSR */
#define AARCH64_SPSR_EL1h  0x5
#define AARCH64_SPSR_F  (1 << 6)
#define AARCH64_SPSR_I  (1 << 7)
#define AARCH64_SPSR_A  (1 << 8)

/* CPSR/SPSR definitions */
#define DAIF_FIQ_BIT		(1 << 0)
#define DAIF_IRQ_BIT		(1 << 1)
#define DAIF_ABT_BIT		(1 << 2)
#define DAIF_DBG_BIT		(1 << 3)
#define SPSR_DAIF_SHIFT		6
#define SPSR_DAIF_MASK		0xf

#define SPSR_AIF_SHIFT		6
#define SPSR_AIF_MASK		0x7

#define SPSR_E_SHIFT		9
#define SPSR_E_MASK			0x1
#define SPSR_E_LITTLE		0x0
#define SPSR_E_BIG			0x1

#define SPSR_T_SHIFT		5
#define SPSR_T_MASK			0x1
#define SPSR_T_ARM			0x0
#define SPSR_T_THUMB		0x1

#define DISABLE_ALL_EXCEPTIONS \
		(DAIF_FIQ_BIT | DAIF_IRQ_BIT | DAIF_ABT_BIT | DAIF_DBG_BIT)


#define MODE_EL_SHIFT		0x2
#define MODE_EL_MASK		0x3
#define MODE_EL3		0x3
#define MODE_EL2		0x2
#define MODE_EL1		0x1
#define MODE_EL0		0x0

/* SCTLR definitions */
#define SCTLR_EL2_RES1  ((1 << 29) | (1 << 28) | (1 << 23) | (1 << 22) | \
			(1 << 18) | (1 << 16) | (1 << 11) | (1 << 5) |  \
			(1 << 4))

#define SCTLR_EL1_RES1  ((1 << 29) | (1 << 28) | (1 << 23) | (1 << 22) | \
			(1 << 11))
#define SCTLR_AARCH32_EL1_RES1 \
			((1 << 23) | (1 << 22) | (1 << 11) | (1 << 4) | \
			(1 << 3))

#define SCTLR_M_BIT		(1 << 0)
#define SCTLR_A_BIT		(1 << 1)
#define SCTLR_C_BIT		(1 << 2)
#define SCTLR_SA_BIT		(1 << 3)
#define SCTLR_I_BIT		(1 << 12)
#define SCTLR_WXN_BIT		(1 << 19)
#define SCTLR_EE_BIT		(1 << 25)


/* Exception Syndrome register bits and bobs */
#define ESR_EC_SHIFT			26
#define ESR_EC_MASK			0x3f
#define ESR_EC_LENGTH			6
#define EC_UNKNOWN			0x0
#define EC_WFE_WFI			0x1
#define EC_AARCH32_CP15_MRC_MCR		0x3
#define EC_AARCH32_CP15_MRRC_MCRR	0x4
#define EC_AARCH32_CP14_MRC_MCR		0x5
#define EC_AARCH32_CP14_LDC_STC		0x6
#define EC_FP_SIMD			0x7
#define EC_AARCH32_CP10_MRC		0x8
#define EC_AARCH32_CP14_MRRC_MCRR	0xc
#define EC_ILLEGAL			0xe
#define EC_AARCH32_SVC			0x11
#define EC_AARCH32_HVC			0x12
#define EC_AARCH32_SMC			0x13
#define EC_AARCH64_SVC			0x15
#define EC_AARCH64_HVC			0x16
#define EC_AARCH64_SMC			0x17
#define EC_AARCH64_SYS			0x18
#define EC_IABORT_LOWER_EL		0x20
#define EC_IABORT_CUR_EL		0x21
#define EC_PC_ALIGN			0x22
#define EC_DABORT_LOWER_EL		0x24
#define EC_DABORT_CUR_EL		0x25
#define EC_SP_ALIGN			0x26
#define EC_AARCH32_FP			0x28
#define EC_AARCH64_FP			0x2c
#define EC_SERROR			0x2f

#define EC_BITS(x)			((x >> ESR_EC_SHIFT) & ESR_EC_MASK)


/******************************************************************************
 * Opcode passed in x0 to tell next EL that we want to run an image.
 * Corresponds to the function ID of the only SMC that the BL1 exception
 * handlers service. That's why the chosen value is the first function ID of
 * the ARM SMC64 range.
 *****************************************************************************/
#define RUN_IMAGE	0xC0000000

/*******************************************************************************
 * Constants that allow assembler code to access members of and the
 * 'entry_point_info' structure at their correct offsets.
 ******************************************************************************/
#define ENTRY_POINT_INFO_PC_OFFSET	0x08
#define ENTRY_POINT_INFO_ARGS_OFFSET	0x18

/* BL2 SMC parameter structre */
#if 0
/***************************************************************************
 * This structure provides version information and the size of the
 * structure, attributes for the structure it represents
 ***************************************************************************/
/* typedef struct param_header { */
/* uint8_t type;		/* type of the structure */ */
/* uint8_t version;    /* version of this structure */ */
/* uint16_t size;      /* size of this structure in bytes */ */
/* uint32_t attr;      /* attributes: unused bits SBZ */ */
/* } param_header_t; */

/*****************************************************************************
 * This structure represents the superset of information needed while
 * switching exception levels. The only two mechanisms to do so are
 * ERET & SMC. Security state is indicated using bit zero of header
 * attribute
 * NOTE: BL1 expects entrypoint followed by spsr while processing
 * SMC to jump to BL31 from the start of entry_point_info
 *****************************************************************************/
/* typedef struct entry_point_info { */
/* param_header_t h; */
/* uintptr_t pc; */
/* uint32_t spsr; */
/* aapcs64_params_t args; */
/* } entry_point_info_t; */

/* BL2 SMC: MUST fill entry_point_info:
* pc, spsr(must be el3), arg0,..(BL2 pass to BL31 parameters) */
#endif

/*******************************************************************************
 * CPU Extended Control register specific definitions.
 ******************************************************************************/
#define CPUECTLR_EL1			S3_1_C15_C2_1	/* Instruction def. */
#define CPUECTLR_SMP_BIT		(1 << 6)

#endif
