/*
 * (C) Copyright 2011 Samsung Electronics Co. Ltd
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 */
 
#ifndef _VAL_SMDKV310_H
#define _VAL_SMDKV310_H

#include <config.h>
#include <version.h>

#include <asm/arch/cpu.h>

#if defined(CONFIG_CLK_800_330_165)
#define APLL_MDIV	0xC8
#define APLL_PDIV	0x6
#define APLL_SDIV	0x1

#define MPLL_MDIV	0x6E
#define MPLL_PDIV	0x4
#define MPLL_SDIV	0x1
#elif defined(CONFIG_CLK_800_400_200)
#define APLL_MDIV	0xC8
#define APLL_PDIV	0x6
#define APLL_SDIV	0x1

#define MPLL_MDIV	0xC8
#define MPLL_PDIV	0x6
#define MPLL_SDIV	0x1
#elif defined(CONFIG_CLK_1000_330_165)
#define APLL_MDIV	0xFA
#define APLL_PDIV	0x6
#define APLL_SDIV	0x1

#define MPLL_MDIV	0x6E
#define MPLL_PDIV	0x4
#define MPLL_SDIV	0x1
#elif defined(CONFIG_CLK_1000_400_200) || defined(CONFIG_CLK_1000_200_200)
#define APLL_MDIV	0xFA
#define APLL_PDIV	0x6
#define APLL_SDIV	0x1

#define MPLL_MDIV	0xC8
#define MPLL_PDIV	0x6
#define MPLL_SDIV	0x1
#endif

/* APLL_CON1	*/
#define APLL_AFC_ENB		0
#define APLL_AFC		0x1C
#define APLL_CON1_VAL	((APLL_AFC_ENB << 31) | (APLL_AFC))

/* MPLL_CON1	*/
#define MPLL_AFC_ENB	0x0
#if defined(CONFIG_CLK_800_330_165) || defined(CONFIG_CLK_1000_330_165)
#define MPLL_AFC		0xD
#elif defined(CONFIG_CLK_1000_400_200) || defined(CONFIG_CLK_1000_200_200) || defined(CONFIG_CLK_800_400_200)
#define MPLL_AFC		0x1C
#endif
#define MPLL_CON1_VAL ((MPLL_AFC_ENB << 31) | (MPLL_AFC))

#define EPLL_MDIV	0x2D
#define EPLL_PDIV	0x3
#define EPLL_SDIV	0x1
#define EPLL_K		0x0
#define EPLL_CON1_VAL	(EPLL_K)

#define VPLL_MDIV	0x35
#define VPLL_PDIV	0x3
#define VPLL_SDIV	0x2

#define VPLL_SSCG_EN	0x0
#define VPLL_SEL_PF	0x0
#define VPLL_MRR	0x11
#define VPLL_MFR	0x0
#define VPLL_K		0x400
#define VPLL_CON1_VAL	((VPLL_SSCG_EN <<31) \
						| (VPLL_SEL_PF <<29) \
						| (VPLL_MRR <<24) 	\
						| (VPLL_MFR << 16) 	\
						| (VPLL_K))
/********************************************************/

/* Set PLL	*/
#define set_pll(mdiv, pdiv, sdiv)	(1<<31 | mdiv<<16 | pdiv<<8 | sdiv)

#define APLL_CON0_VAL	set_pll(APLL_MDIV,APLL_PDIV,APLL_SDIV)
#define MPLL_CON0_VAL	set_pll(MPLL_MDIV,MPLL_PDIV,MPLL_SDIV)
#define EPLL_CON0_VAL	set_pll(EPLL_MDIV,EPLL_PDIV,EPLL_SDIV)
#define VPLL_CON0_VAL	set_pll(VPLL_MDIV,VPLL_PDIV,VPLL_SDIV)


/* CLK_SRC_CPU	*/
/* 0 = MOUTAPLL,  1 = SCLKMPLL	*/
#define MUX_HPM_SEL_MOUTAPLL	0
#define MUX_HPM_SEL_SCLKMPLL	1
#define MUX_CORE_SEL_MOUTAPLL	0
#define MUX_CORE_SEL_SCLKMPLL	1

/* 0 = FILPLL, 1 = MOUT */
#define MUX_MPLL_SEL_FILPLL	0
#define MUX_MPLL_SEL_MOUTMPLLFOUT	1

#define MUX_APLL_SEL_FILPLL	0
#define MUX_APLL_SEL_MOUTMPLLFOUT	1

#define CLK_SRC_CPU_VAL_FINPLL	        ((MUX_HPM_SEL_MOUTAPLL << 20)    \
                                | (MUX_CORE_SEL_MOUTAPLL <<16)   \
                                | (MUX_MPLL_SEL_FILPLL << 8)   \
                                | (MUX_APLL_SEL_FILPLL <<0))
                                
#define CLK_SRC_CPU_VAL_MOUTMPLLFOUT		((MUX_HPM_SEL_MOUTAPLL << 20)    \
                                | (MUX_CORE_SEL_MOUTAPLL <<16)   \
                                | (MUX_MPLL_SEL_MOUTMPLLFOUT << 8)   \
                                | (MUX_APLL_SEL_MOUTMPLLFOUT <<0))

/* CLK_DIV_CPU0	*/
#define APLL_RATIO	0x1
#define PCLK_DBG_RATIO	0x1
#define ATB_RATIO	0x3
#define PERIPH_RATIO	0x3
#define COREM1_RATIO	0x7
#define COREM0_RATIO	0x3
#define CORE_RATIO	0x0
#define CLK_DIV_CPU0_VAL        ((APLL_RATIO << 24)     \
                                | (PCLK_DBG_RATIO << 20)\
                                | (ATB_RATIO << 16)     \
                                | (PERIPH_RATIO <<12)   \
				| (COREM1_RATIO << 8)   \
                                | (COREM0_RATIO << 4)   \
                                | (CORE_RATIO))



/* CLK_DIV_CPU1	*/
#define HPM_RATIO	0x0
#define COPY_RATIO	0x3
#define CLK_DIV_CPU1_VAL	((HPM_RATIO << 4) | (COPY_RATIO))

/* CLK_SRC_DMC	*/
#define MUX_PWI_SEL	        0x0
#define MUX_CORE_TIMERS_SEL	0x0
#define MUX_DPHY_SEL		0x0
#define MUX_DMC_BUS_SEL		0x0
#define CLK_SRC_DMC_VAL         ((MUX_PWI_SEL << 16)            \
                                | (MUX_CORE_TIMERS_SEL << 12)   \
                                | (MUX_DPHY_SEL << 8)           \
                                | (MUX_DMC_BUS_SEL << 4))



/* CLK_DIV_DMC0	*/
#if defined(CONFIG_CLK_1000_200_200)
#define CORE_TIMERS_RATIO	0x1
#define COPY2_RATIO		0x3
#define DMCP_RATIO		0x1
#define DMCD_RATIO		0x0
#define DMC_RATIO		0x3
#define DPHY_RATIO		0x1
#define ACP_PCLK_RATIO		0x1
#define ACP_RATIO		0x3
#else
#define CORE_TIMERS_RATIO	0x1
#define COPY2_RATIO		0x3
#define DMCP_RATIO		0x1
#define DMCD_RATIO		0x1
#define DMC_RATIO		0x1
#define DPHY_RATIO		0x1
#define ACP_PCLK_RATIO		0x1
#define ACP_RATIO		0x3
#endif
#define CLK_DIV_DMC0_VAL	((CORE_TIMERS_RATIO << 28) \
							| (COPY2_RATIO << 24) \
							| (DMCP_RATIO << 20)	\
							| (DMCD_RATIO << 16)	\
							| (DMC_RATIO << 12)	\
							| (DPHY_RATIO << 8)	\
							| (ACP_PCLK_RATIO << 4)	\
							| (ACP_RATIO))

/* CLK_DIV_DMC1	*/
#define DPM_RATIO	0x1
#define DVSEM_RATIO	0x1
#define PWI_RATIO	0x1
#define CLK_DIV_DMC1_VAL	((DPM_RATIO << 24) \
						| (DVSEM_RATIO << 16) \
						| (PWI_RATIO << 8))

/* CLK_SRC_TOP0	*/
#define MUX_ONENAND_SEL 0x0 /* 0 = DOUT133, 1 = DOUT166		*/
#define MUX_ACLK_133_SEL	0x0	/* 0 = SCLKMPLL, 1 = SCLKAPLL	*/
#define MUX_ACLK_160_SEL	0x0
#define MUX_ACLK_100_SEL	0x0
#define MUX_ACLK_200_SEL	0x0
#define MUX_VPLL_SEL	0x0
#define MUX_EPLL_SEL	0x0
#define CLK_SRC_TOP0_VAL	((MUX_ONENAND_SEL << 28)	\
							| (MUX_ACLK_133_SEL << 24)	\
							| (MUX_ACLK_160_SEL << 20)	\
							| (MUX_ACLK_100_SEL << 16)	\
							| (MUX_ACLK_200_SEL << 12)	\
							| (MUX_VPLL_SEL << 8)	\
							| (MUX_EPLL_SEL << 4))

/* CLK_SRC_TOP1	*/
#define VPLLSRC_SEL	0x0	/* 0 = FINPLL, 1 = SCLKHDMI27M	*/
#define CLK_SRC_TOP1_VAL	(VPLLSRC_SEL)

/* CLK_DIV_TOP	*/
#define ONENAND_RATIO	0x0
#define ACLK_133_RATIO	0x5
#define ACLK_160_RATIO	0x4
#define ACLK_100_RATIO	0x7
#define ACLK_200_RATIO	0x3
#define CLK_DIV_TOP_VAL	((ONENAND_RATIO << 16) \
							| (ACLK_133_RATIO << 12)	\
							| (ACLK_160_RATIO << 8)	\
							| (ACLK_100_RATIO << 4)	\
							| (ACLK_200_RATIO))

/* CLK_SRC_LEFTBUS	*/
#define MUX_GDL_SEL	0x0
#define CLK_SRC_LEFTBUS_VAL	(MUX_GDL_SEL)

/* CLK_DIV_LEFRBUS	*/
#define GPL_RATIO	0x1
#define GDL_RATIO	0x3
#define CLK_DIV_LEFRBUS_VAL	((GPL_RATIO << 4) \
								| (GDL_RATIO))

/* CLK_SRC_RIGHTBUS	*/
#define MUX_GDR_SEL	0x0
#define CLK_SRC_RIGHTBUS_VAL	(MUX_GDR_SEL)

/* CLK_DIV_RIGHTBUS	*/
#define GPR_RATIO	0x1
#define GDR_RATIO	0x3
#define CLK_DIV_RIGHTBUS_VAL	((GPR_RATIO << 4) \
								| (GDR_RATIO))

/* APLL_LOCK	*/
#define APLL_LOCK_VAL	(0x3C2)
/* MPLL_LOCK	*/
#define MPLL_LOCK_VAL	(0x3C2)
/* EPLL_LOCK	*/
#define EPLL_LOCK_VAL	(0x2336)
/* VPLL_LOCK	*/
#define VPLL_LOCK_VAL	(0x466D)


/* CLK_SRC_PERIL0	*/
#define PWM_SEL		0	
#define UART5_SEL	6
#define UART4_SEL	6
#define UART3_SEL	6
#define UART2_SEL	6
#define UART1_SEL	6
#define UART0_SEL	6
#define CLK_SRC_PERIL0_VAL	((PWM_SEL << 24)\
								| (UART5_SEL << 20)  \
								| (UART4_SEL << 16) \
								| (UART3_SEL << 12) \
								| (UART2_SEL<< 8)	\
								| (UART1_SEL << 4)	\
								| (UART0_SEL))

/* CLK_DIV_PERIL0	*/
#if defined(CONFIG_CLK_800_330_165) || defined(CONFIG_CLK_1000_330_165)
#define UART5_RATIO	7
#define UART4_RATIO	7
#define UART3_RATIO	7
#define UART2_RATIO	7
#define UART1_RATIO	7
#define UART0_RATIO	7
#elif defined(CONFIG_CLK_1000_400_200) || defined(CONFIG_CLK_1000_200_200) || defined(CONFIG_CLK_800_400_200)
#define UART5_RATIO	8
#define UART4_RATIO	8
#define UART3_RATIO	8
#define UART2_RATIO	8
#define UART1_RATIO	8
#define UART0_RATIO	8
#endif
#define CLK_DIV_PERIL0_VAL	((UART5_RATIO << 20) \
								| (UART4_RATIO << 16) \
								| (UART3_RATIO << 12)	\
								| (UART2_RATIO << 8)	\
								| (UART1_RATIO << 4)	\
								| (UART0_RATIO))


#define MPLL_DEC (MPLL_MDIV * MPLL_MDIV / (MPLL_PDIV * 2^(MPLL_SDIV-1)))


#define SCLK_UART               MPLL_DEC/ (UART1_RATIO+1)
#if defined(CONFIG_CLK_800_330_165) || defined(CONFIG_CLK_1000_330_165)
#define UART_UBRDIV_VAL	0x2B/* (SCLK_UART/(115200*16) -1) */
#define UART_UDIVSLOT_VAL	0xC		/*((((SCLK_UART*10/(115200*16) -10))%10)*16/10)*/
#elif defined(CONFIG_CLK_1000_400_200) || defined(CONFIG_CLK_1000_200_200) || defined(CONFIG_CLK_800_400_200)
#define UART_UBRDIV_VAL	0x2F     /* (SCLK_UART/(115200*16) -1) */
#define UART_UDIVSLOT_VAL 0x3		/*((((SCLK_UART*10/(115200*16) -10))%10)*16/10)*/
#endif


#endif

