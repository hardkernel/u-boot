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

#ifndef _EXYNOS5250_CPU_H
#define _EXYNOS5250_CPU_H

/* EXYNOS5250 */
#define EXYNOS5250_PRO_ID		0x10000000
#define EXYNOS5250_SYSREG_BASE	        0x10050000
#define EXYNOS5250_POWER_BASE	        0x10040000
#define EXYNOS5250_CLOCK_BASE	        0x10010000
#define EXYNOS5250_SROM_BASE	        0x12250000
#define EXYNOS5250_HSMMC_BASE	        0x12200000
#define EXYNOS5250_PWMTIMER_BASE	0x12DD0000
#define EXYNOS5250_INF_REG_BASE	        0x10040800
#define EXYNOS5250_TZPC_BASE		0x10100000
#define EXYNOS5250_UART_BASE       	0x12C00000

#define BIT0 				0x00000001
#define BIT1 				0x00000002
#define BIT2 				0x00000004
#define BIT3 				0x00000008
#define BIT4 				0x00000010
#define BIT5 				0x00000020
#define BIT6				0x00000040
#define BIT7				0x00000080
#define BIT8				0x00000100
#define BIT9				0x00000200
#define BIT10				0x00000400
#define BIT11				0x00000800
#define BIT12				0x00001000
#define BIT13				0x00002000
#define BIT14				0x00004000
#define BIT15				0x00008000
#define BIT16				0x00010000
#define BIT17				0x00020000
#define BIT18				0x00040000
#define BIT19				0x00080000
#define BIT20				0x00100000
#define BIT21				0x00200000
#define BIT22				0x00400000
#define BIT23				0x00800000
#define BIT24				0x01000000
#define BIT25				0x02000000
#define BIT26				0x04000000
#define BIT27				0x08000000
#define BIT28				0x10000000
#define BIT29				0x20000000
#define BIT30				0x40000000
#define BIT31				0x80000000


#define __REG(x)	(*(unsigned int *)(x))

/*
 * CHIP ID
 */
#define CHIP_ID_BASE		EXYNOS5250_PRO_ID
#define PRO_ID_OFFSET	        0x0
#define PRO_ID	        	__REG(CHIP_ID_BASE+PRO_ID_OFFSET)
#define PRO_MAINREV		((PRO_ID >> 0x4) & 0x0f)
#define PRO_SUBREV		(PRO_ID & 0x0f)
#define PRO_PKGINFO             ((PRO_ID >> 0x8) & 0x0f)
#define SCP_TYPE                0x0
#define POP_TYPE                0x2

/*
 * SYSREG
 */
#define USB_CFG_OFFSET			0x230
#define USB_CFG_REG			(EXYNOS5250_SYSREG_BASE + USB_CFG_OFFSET)

/*
 * POWER
 */
#define ELFIN_POWER_BASE                EXYNOS5250_POWER_BASE
#define OMR_OFFSET			0x0
#define SW_RST_REG_OFFSET		0x400
#define SW_RST_REG			__REG(EXYNOS5250_POWER_BASE + SW_RST_REG_OFFSET)

#define FSYS_ARM_CONFIGURATION_OFFSET   0x2200
#define EFNAND_PHY_CONTROL_OFFSET       0x070C
#define SATA_PHY_CONTROL_OFFSET         0x0724

#define INF_REG_BASE			EXYNOS5250_INF_REG_BASE

#define INF_REG0_OFFSET			0x00
#define INF_REG1_OFFSET			0x04
#define INF_REG2_OFFSET			0x08
#define INF_REG3_OFFSET			0x0C
#define INF_REG4_OFFSET			0x10
#define INF_REG5_OFFSET			0x14
#define INF_REG6_OFFSET			0x18
#define INF_REG7_OFFSET			0x1C

#define INF_REG0_REG			__REG(INF_REG_BASE+INF_REG0_OFFSET)
#define INF_REG1_REG			__REG(INF_REG_BASE+INF_REG1_OFFSET)
#define INF_REG2_REG			__REG(INF_REG_BASE+INF_REG2_OFFSET)
#define INF_REG3_REG			__REG(INF_REG_BASE+INF_REG3_OFFSET)
#define INF_REG4_REG			__REG(INF_REG_BASE+INF_REG4_OFFSET)
#define INF_REG5_REG			__REG(INF_REG_BASE+INF_REG5_OFFSET)
#define INF_REG6_REG			__REG(INF_REG_BASE+INF_REG6_OFFSET)
#define INF_REG7_REG			__REG(INF_REG_BASE+INF_REG7_OFFSET)

#define USB_DEVICE_PHY_CONTROL_OFFSET	0x0704
#define USB_PHY_CONTROL_OFFSET		0x0708
#define USB_DEVICE_PHY_CONTROL			(EXYNOS5250_POWER_BASE+USB_DEVICE_PHY_CONTROL_OFFSET)
#define USB_PHY_CONTROL				(EXYNOS5250_POWER_BASE+USB_PHY_CONTROL_OFFSET)

/* Define Mode */
#define S5P_CHECK_SLEEP			0x00000BAD
#define S5P_CHECK_DIDLE			0xBAD00000
#define S5P_CHECK_LPA			0xABAD0000

/*
 * CLOCK
 */
#define ELFIN_CLOCK_BASE		EXYNOS5250_CLOCK_BASE

#define APLL_LOCK_OFFSET                       0x00000
#define APLL_CON0_OFFSET                       0x00100
#define APLL_CON1_OFFSET                       0x00104
#define CLK_SRC_CPU_OFFSET                     0x00200
#define CLK_MUX_STAT_CPU_OFFSET                0x00400
#define CLK_DIV_CPU0_OFFSET                    0x00500
#define CLK_DIV_CPU1_OFFSET                    0x00504
#define CLK_DIV_STAT_CPU0_OFFSET               0x00600
#define CLK_DIV_STAT_CPU1_OFFSET               0x00604
#define CLK_GATE_SCLK_CPU_OFFSET               0x00800
#define CLKOUT_CMU_CPU_OFFSET                  0x00A00
#define CLKOUT_CMU_CPU_DIV_STAT_OFFSET         0x00A04
#define ARMCLK_STOPCTRL_OFFSET                 0x01000
#define PARITYFAIL_STATUS_OFFSET               0x01010
#define PARITYFAIL_CLEAR_OFFSET                0x01014
#define PWR_CTRL_OFFSET                        0x01020
#define PWR_CTRL2_OFFSET                       0x01024
#define APLL_CON0_L8_OFFSET                    0x01100
#define APLL_CON0_L7_OFFSET                    0x01104
#define APLL_CON0_L6_OFFSET                    0x01108
#define APLL_CON0_L5_OFFSET                    0x0110C
#define APLL_CON0_L4_OFFSET                    0x01110
#define APLL_CON0_L3_OFFSET                    0x01114
#define APLL_CON0_L2_OFFSET                    0x01118
#define APLL_CON0_L1_OFFSET                    0x0111C
#define IEM_CONTROL_OFFSET                     0x01120
#define APLL_CON1_L8_OFFSET                    0x01200
#define APLL_CON1_L7_OFFSET                    0x01204
#define APLL_CON1_L6_OFFSET                    0x01208
#define APLL_CON1_L5_OFFSET                    0x0120C
#define APLL_CON1_L4_OFFSET                    0x01210
#define APLL_CON1_L3_OFFSET                    0x01214
#define APLL_CON1_L2_OFFSET                    0x01218
#define APLL_CON1_L1_OFFSET                    0x0121C
#define CLKDIV_IEM_L8_OFFSET                   0x01300
#define CLKDIV_IEM_L7_OFFSET                   0x01304
#define CLKDIV_IEM_L6_OFFSET                   0x01308
#define CLKDIV_IEM_L5_OFFSET                   0x0130C
#define CLKDIV_IEM_L4_OFFSET                   0x01310
#define CLKDIV_IEM_L3_OFFSET                   0x01314
#define CLKDIV_IEM_L2_OFFSET                   0x01318
#define CLKDIV_IEM_L1_OFFSET                   0x0131C
#define MPLL_LOCK_OFFSET                       0x04000
#define MPLL_CON0_OFFSET                       0x04100
#define MPLL_CON1_OFFSET                       0x04104
#define CLK_SRC_CORE0_OFFSET                   0x04200
#define CLK_SRC_CORE1_OFFSET                   0x04204
#define CLK_SRC_MASK_CORE0_OFFSET              0x04300
#define CLK_MUX_STAT_CORE1_OFFSET              0x04404
#define CLK_DIV_CORE0_OFFSET                   0x04500
#define CLK_DIV_CORE1_OFFSET                   0x04504
#define CLK_DIV_SYSRGT_OFFSET                  0x04508
#define CLK_DIV_STAT_CORE0_OFFSET              0x04600
#define CLK_DIV_STAT_CORE1_OFFSET              0x04604
#define CLK_DIV_STAT_SYSRGT_OFFSET             0x04608
#define CLK_GATE_IP_CORE_OFFSET                0x04900
#define CLK_GATE_IP_SYSRGT_OFFSET              0x04904
#define C2C_MONITOR_OFFSET                     0x04910
#define CLKOUT_CMU_CORE_OFFSET                 0x04A00
#define CLKOUT_CMU_CORE_DIV_STAT_OFFSET        0x04A04
#define DCGIDX_MAP0_OFFSET                     0x05000
#define DCGIDX_MAP1_OFFSET                     0x05004
#define DCGIDX_MAP2_OFFSET                     0x05008
#define DCGPERF_MAP0_OFFSET                    0x05020
#define DCGPERF_MAP1_OFFSET                    0x05024
#define DVCIDX_MAP_OFFSET                      0x05040
#define FREQ_CPU_OFFSET                        0x05060
#define FREQ_DPM_OFFSET                        0x05064
#define DVSEMCLK_EN_OFFSET                     0x05080
#define MAXPERF_OFFSET                         0x05084
#define C2C_CONFIG_OFFSET                      0x06000
#define CLK_DIV_ACP_OFFSET                     0x08500
#define CLK_DIV_STAT_ACP_OFFSET                0x08600
#define CLK_GATE_IP_ACP_OFFSET                 0x08800
#define CLK_DIV_SYSLFT_OFFSET                  0x08900
#define CLK_DIV_STAT_SYSLFT_OFFSET             0x08910
#define CLK_GATE_IP_SYSLFT_OFFSET              0x08930
#define CLKOUT_CMU_ACP_OFFSET                  0x08A00
#define CLKOUT_CMU_ACP_DIV_STAT_OFFSET         0x08A04
#define UFMC_CONFIG_OFFSET                     0x08A10
#define CLK_DIV_ISP0_OFFSET                    0x0C300
#define CLK_DIV_ISP1_OFFSET                    0x0C304
#define CLK_DIV_ISP2_OFFSET                    0x0C308
#define CLK_DIV_STAT_ISP0_OFFSET               0x0C400
#define CLK_DIV_STAT_ISP1_OFFSET               0x0C404
#define CLK_DIV_STAT_ISP2_OFFSET               0x0C408
#define CLK_GATE_IP_ISP0_OFFSET                0x0C800
#define CLK_GATE_IP_ISP1_OFFSET                0x0C804
#define CLK_GATE_SCLK_ISP_OFFSET               0x0C900
#define MCUISP_PWR_CTRL_OFFSET                 0x0C910
#define CLKOUT_CMU_ISP_OFFSET                  0x0CA00
#define CLKOUT_CMU_ISP_DIV_STAT_OFFSET         0x0CA04
#define CPLL_LOCK_OFFSET                       0x10020
#define EPLL_LOCK_OFFSET                       0x10030
#define VPLL_LOCK_OFFSET                       0x10040
#define GPLL_LOCK_OFFSET                       0x10050
#define CPLL_CON0_OFFSET                       0x10120
#define CPLL_CON1_OFFSET                       0x10124
#define EPLL_CON0_OFFSET                       0x10130
#define EPLL_CON1_OFFSET                       0x10134
#define EPLL_CON2_OFFSET                       0x10138
#define VPLL_CON0_OFFSET                       0x10140
#define VPLL_CON1_OFFSET                       0x10144
#define VPLL_CON2_OFFSET                       0x10148
#define GPLL_CON0_OFFSET                       0x10150
#define GPLL_CON1_OFFSET                       0x10154
#define CLK_SRC_TOP0_OFFSET                    0x10210
#define CLK_SRC_TOP1_OFFSET                    0x10214
#define CLK_SRC_TOP2_OFFSET                    0x10218
#define CLK_SRC_TOP3_OFFSET                    0x1021C
#define CLK_SRC_GSCL_OFFSET                    0x10220
#define CLK_SRC_DISP1_0_OFFSET                 0x1022C
#define CLK_SRC_MAU_OFFSET                     0x10240
#define CLK_SRC_FSYS_OFFSET                    0x10244
#define CLK_SRC_GEN_OFFSET                     0x10248
#define CLK_SRC_PERIC0_OFFSET                  0x10250
#define CLK_SRC_PERIC1_OFFSET                  0x10254
#define SCLK_SRC_ISP_OFFSET                    0x10270
#define CLK_SRC_MASK_TOP_OFFSET                0x10310
#define CLK_SRC_MASK_GSCL_OFFSET               0x10320
#define CLK_SRC_MASK_DISP1_0_OFFSET            0x1032C
#define CLK_SRC_MASK_DISP1_1_OFFSET            0x10330
#define CLK_SRC_MASK_MAU_OFFSET                0x10334
#define CLK_SRC_MASK_FSYS_OFFSET               0x10340
#define CLK_SRC_MASK_GEN_OFFSET                0x10344
#define CLK_SRC_MASK_PERIC0_OFFSET             0x10350
#define CLK_SRC_MASK_PERIC1_OFFSET             0x10354
#define SCLK_SRC_MASK_ISP_OFFSET               0x10370
#define CLK_MUX_STAT_TOP0_OFFSET               0x10410
#define CLK_MUX_STAT_TOP1_OFFSET               0x10414
#define CLK_MUX_STAT_TOP2_OFFSET               0x10418
#define CLK_MUX_STAT_TOP3_OFFSET               0x1041C
#define CLK_DIV_TOP0_OFFSET                    0x10510
#define CLK_DIV_TOP1_OFFSET                    0x10514
#define CLK_DIV_GSCL_OFFSET                    0x10520
#define CLK_DIV_DISP1_0_OFFSET                 0x1052C
#define CLK_DIV_GEN_OFFSET                     0x1053C
#define CLK_DIV_MAU_OFFSET                     0x10544
#define CLK_DIV_FSYS0_OFFSET                   0x10548
#define CLK_DIV_FSYS1_OFFSET                   0x1054C
#define CLK_DIV_FSYS2_OFFSET                   0x10550
#define CLK_DIV_PERIC0_OFFSET                  0x10558
#define CLK_DIV_PERIC1_OFFSET                  0x1055C
#define CLK_DIV_PERIC2_OFFSET                  0x10560
#define CLK_DIV_PERIC3_OFFSET                  0x10564
#define CLK_DIV_PERIC4_OFFSET                  0x10568
#define CLK_DIV_PERIC5_OFFSET                  0x1056C
#define SCLK_DIV_ISP_OFFSET                    0x10580
#define CLKDIV2_RATIO0_OFFSET                  0x10590
#define CLKDIV2_RATIO1_OFFSET                  0x10594
#define CLKDIV4_RATIO_OFFSET                   0x105A0
#define CLK_DIV_STAT_TOP0_OFFSET               0x10610
#define CLK_DIV_STAT_TOP1_OFFSET               0x10614
#define CLK_DIV_STAT_GSCL_OFFSET               0x10620
#define CLK_DIV_STAT_DISP1_0_OFFSET            0x1062C
#define CLK_DIV_STAT_GEN_OFFSET                0x1063C
#define CLK_DIV_STAT_MAU_OFFSET                0x10644
#define CLK_DIV_STAT_FSYS0_OFFSET              0x10648
#define CLK_DIV_STAT_FSYS1_OFFSET              0x1064C
#define CLK_DIV_STAT_FSYS2_OFFSET              0x10650
#define CLK_DIV_STAT_PERIC0_OFFSET             0x10658
#define CLK_DIV_STAT_PERIC1_OFFSET             0x1065C
#define CLK_DIV_STAT_PERIC2_OFFSET             0x10660
#define CLK_DIV_STAT_PERIC3_OFFSET             0x10664
#define CLK_DIV_STAT_PERIC4_OFFSET             0x10668
#define CLK_DIV_STAT_PERIC5_OFFSET             0x1066C
#define SCLK_DIV_STAT_ISP_OFFSET               0x10680
#define CLKDIV2_STAT0_OFFSET                   0x10690
#define CLKDIV2_STAT1_OFFSET                   0x10694
#define CLKDIV4_STAT_OFFSET                    0x106A0
#define CLK_GATE_TOP_SCLK_DISP1_OFFSET         0x10828
#define CLK_GATE_TOP_SCLK_GEN_OFFSET           0x1082C
#define CLK_GATE_TOP_SCLK_MAU_OFFSET           0x1083C
#define CLK_GATE_TOP_SCLK_FSYS_OFFSET          0x10840
#define CLK_GATE_TOP_SCLK_PERIC_OFFSET         0x10850
#define CLK_GATE_TOP_SCLK_ISP_OFFSET           0x10870
#define CLK_GATE_IP_GSCL_OFFSET                0x10920
#define CLK_GATE_IP_DISP1_OFFSET               0x10928
#define CLK_GATE_IP_MFC_OFFSET                 0x1092C
#define CLK_GATE_IP_G3D_OFFSET                 0x10930
#define CLK_GATE_IP_GEN_OFFSET                 0x10934
#define CLK_GATE_IP_FSYS_OFFSET                0x10944
#define CLK_GATE_IP_PERIC_OFFSET               0x10950
#define CLK_GATE_IP_PERIS_OFFSET               0x10960
#define CLK_GATE_BLOCK_OFFSET                  0x10980
#define MCUIOP_PWR_CTRL_OFFSET                 0x109A0
#define CLKOUT_CMU_TOP_OFFSET                  0x10A00
#define CLKOUT_CMU_TOP_DIV_STAT_OFFSET         0x10A04
#define CLK_SRC_LEX_OFFSET                     0x14200
#define CLK_MUX_STAT_LEX_OFFSET                0x14400
#define CLK_DIV_LEX_OFFSET                     0x14500
#define CLK_DIV_STAT_LEX_OFFSET                0x14600
#define CLK_GATE_IP_LEX_OFFSET                 0x14800
#define CLKOUT_CMU_LEX_OFFSET                  0x14A00
#define CLKOUT_CMU_LEX_DIV_STAT_OFFSET         0x14A04
#define CLK_DIV_R0X_OFFSET                     0x18500
#define CLK_DIV_STAT_R0X_OFFSET                0x18600
#define CLK_GATE_IP_R0X_OFFSET                 0x18800
#define CLKOUT_CMU_R0X_OFFSET                  0x18A00
#define CLKOUT_CMU_R0X_DIV_STAT_OFFSET         0x18A04
#define CLK_DIV_R1X_OFFSET                     0x1C500
#define CLK_DIV_STAT_R1X_OFFSET                0x1C600
#define CLK_GATE_IP_R1X_OFFSET                 0x1C800
#define CLKOUT_CMU_R1X_OFFSET                  0x1CA00
#define CLKOUT_CMU_R1X_DIV_STAT_OFFSET         0x1CA04
#define BPLL_LOCK_OFFSET                       0x20010
#define BPLL_CON0_OFFSET                       0x20110
#define BPLL_CON1_OFFSET                       0x20114
#define CLK_SRC_CDREX_OFFSET                   0x20200
#define CLK_MUX_STAT_CDREX_OFFSET              0x20400
#define CLK_DIV_CDREX_OFFSET                   0x20500
#define CLK_DIV_STAT_CDREX_OFFSET              0x20600
#define CLK_GATE_IP_CDREX_OFFSET               0x20900
#define DMC_FREQ_CTRL_OFFSET                   0x20914
#define DREX2_PAUSE_OFFSET                     0x2091C
#define CLKOUT_CMU_CDREX_OFFSET                0x20A00
#define CLKOUT_CMU_CDREX_DIV_STAT_OFFSET       0x20A04
#define LPDDR3PHY_CTRL                         0x20A10
#define LPDDR3PHY_CTRL_CON0                    0x20A14
#define LPDDR3PHY_CTRL_CON1                    0x20A18
#define LPDDR3PHY_CTRL_CON2                    0x20A1C
#define LPDDR3PHY_CTRL_CON3                    0x20A20
#define PLL_DIV2_SEL_OFFSET                    0x20A24

#define CLK_SRC_FSYS		__REG(ELFIN_CLOCK_BASE+CLK_SRC_FSYS_OFFSET)
#define CLK_DIV_FSYS0		__REG(ELFIN_CLOCK_BASE+CLK_DIV_FSYS0_OFFSET)
#define CLK_DIV_FSYS1		__REG(ELFIN_CLOCK_BASE+CLK_DIV_FSYS1_OFFSET)
#define CLK_DIV_FSYS2		__REG(ELFIN_CLOCK_BASE+CLK_DIV_FSYS2_OFFSET)
#define APLL_CON0_REG		__REG(ELFIN_CLOCK_BASE+APLL_CON0_OFFSET)
#define MPLL_CON0_REG		__REG(ELFIN_CLOCK_BASE+MPLL_CON0_OFFSET)
#define EPLL_CON0_REG		__REG(ELFIN_CLOCK_BASE+EPLL_CON0_OFFSET)
#define VPLL_CON0_REG		__REG(ELFIN_CLOCK_BASE+VPLL_CON0_OFFSET)

/*
 * TZPC
 */
#define TZPC0_OFFSET    		0x00000
#define TZPC1_OFFSET	        	0x10000
#define TZPC2_OFFSET	        	0x20000
#define TZPC3_OFFSET	        	0x30000
#define TZPC4_OFFSET	        	0x40000
#define TZPC5_OFFSET	        	0x50000
#define TZPC6_OFFSET	        	0x60000
#define TZPC7_OFFSET		        0x70000
#define TZPC8_OFFSET	        	0x80000
#define TZPC9_OFFSET    		0x90000

#define ELFIN_TZPC0_BASE		(EXYNOS5250_TZPC_BASE + TZPC0_OFFSET)
#define ELFIN_TZPC1_BASE		(EXYNOS5250_TZPC_BASE + TZPC1_OFFSET)
#define ELFIN_TZPC2_BASE		(EXYNOS5250_TZPC_BASE + TZPC2_OFFSET)
#define ELFIN_TZPC3_BASE		(EXYNOS5250_TZPC_BASE + TZPC3_OFFSET)
#define ELFIN_TZPC4_BASE		(EXYNOS5250_TZPC_BASE + TZPC4_OFFSET)
#define ELFIN_TZPC5_BASE		(EXYNOS5250_TZPC_BASE + TZPC5_OFFSET)
#define ELFIN_TZPC6_BASE		(EXYNOS5250_TZPC_BASE + TZPC6_OFFSET)
#define ELFIN_TZPC7_BASE		(EXYNOS5250_TZPC_BASE + TZPC7_OFFSET)
#define ELFIN_TZPC8_BASE		(EXYNOS5250_TZPC_BASE + TZPC8_OFFSET)
#define ELFIN_TZPC9_BASE		(EXYNOS5250_TZPC_BASE + TZPC9_OFFSET)

#define TZPC_DECPROT0SET_OFFSET		0x804
#define TZPC_DECPROT1SET_OFFSET		0x810
#define TZPC_DECPROT2SET_OFFSET		0x81C
#define TZPC_DECPROT3SET_OFFSET		0x828

/*
 * Memory controller
 */
#define ELFIN_SROM_BASE			EXYNOS5250_SROM_BASE

#define SROM_BW_REG			__REG(ELFIN_SROM_BASE+0x0)
#define SROM_BC0_REG			__REG(ELFIN_SROM_BASE+0x4)
#define SROM_BC1_REG			__REG(ELFIN_SROM_BASE+0x8)
#define SROM_BC2_REG			__REG(ELFIN_SROM_BASE+0xC)
#define SROM_BC3_REG			__REG(ELFIN_SROM_BASE+0x10)

/*
 * SDRAM Controller
 */

/* DMC control register */
#define DMC_CTRL_BASE		0x10DD0000

#define DMC_CONCONTROL 			0x00
#define DMC_MEMCONTROL 			0x04
#define DMC_MEMCONFIG0 			0x08
#define DMC_MEMCONFIG1 			0x0C
#define DMC_DIRECTCMD 			0x10
#define DMC_PRECHCONFIG 		0x14
#define DMC_PHYCONTROL0 		0x18
#define DMC_PWRDNCONFIG 		0x28
#define DMC_TIMINGPZQ    		0x2C
#define DMC_TIMINGAREF 			0x30
#define DMC_TIMINGROW 			0x34
#define DMC_TIMINGDATA 			0x38
#define DMC_TIMINGPOWER 		0x3C
#define DMC_PHYSTATUS 			0x40
#define DMC_CHIPSTATUS_CH0 		0x48
#define DMC_CHIPSTATUS_CH1 		0x4C
#define DMC_MRSTATUS 			0x54
#define DMC_QOSCONTROL0 		0x60
#define DMC_QOSCONTROL1 		0x68
#define DMC_QOSCONTROL2 		0x70
#define DMC_QOSCONTROL3 		0x78
#define DMC_QOSCONTROL4 		0x80
#define DMC_QOSCONTROL5 		0x88
#define DMC_QOSCONTROL6 		0x90
#define DMC_QOSCONTROL7 		0x98
#define DMC_QOSCONTROL8 		0xA0
#define DMC_QOSCONTROL9 		0xA8
#define DMC_QOSCONTROL10 		0xB0
#define DMC_QOSCONTROL11 		0xB8
#define DMC_QOSCONTROL12 		0xC0
#define DMC_QOSCONTROL13 		0xC8
#define DMC_QOSCONTROL14 		0xD0
#define DMC_QOSCONTROL15 		0xD8
#define DMC_IVCONTROL	 		0xF0
#define DMC_WRTRA_CONFIG                0xF4
#define DMC_RDLVL_CONFIG                0xF8
#define DMC_BRBRSVCONTROL               0x0100
#define DMC_BRBRSVCONFIG                0x0104
#define DMC_BRBQOSCONFIG                0x0108
#define DMC_MEMBASECONFIG0              0x010C
#define DMC_MEMBASECONFIG1              0x0110
#define DMC_WRLVLCONFIG0                0x0120
#define DMC_WRLVLCONFIG1                0x0124
#define DMC_WRLVLSTATUS                 0x0128
#define DMC_PEREVCONTROL                0x0130
#define DMC_PEREV0CONFIG                0x0134
#define DMC_PEREV1CONFIG                0x0138
#define DMC_PEREV2CONFIG                0x013C
#define DMC_PEREV3CONFIG                0x0140
#define DMC_CTRL_IO_RDATA_CH0           0x0150
#define DMC_CTRL_IO_RDATA_CH1           0x0154
#define DMC_CACAL_CONFIG0               0x0160
#define DMC_CACAL_CONFIG1               0x0164
#define DMC_CACAL_STATUS                0x0168
#define DMC_PMNC_PPC                    0xE000
#define DMC_CNTENS_PPC                  0xE010
#define DMC_CNTENC_PPC                  0xE020
#define DMC_INTENS_PPC                  0xE030
#define DMC_INTENC_PPC                  0xE040
#define DMC_FLAG_PPC                    0xE050
#define DMC_CCNT_PPC                    0xE100
#define DMC_PMCNT0_PPC                  0xE110
#define DMC_PMCNT1_PPC                  0xE120
#define DMC_PMCNT2_PPC                  0xE130
#define DMC_PMCNT3_PPC                  0xE140

/* PHY Control Register */
#define PHY0_CTRL_BASE                   0x10C00000
#define PHY1_CTRL_BASE                   0x10C10000

#define DMC_PHY_CON0                    0x00
#define DMC_PHY_CON1                    0x04
#define DMC_PHY_CON2                    0x08
#define DMC_PHY_CON3                    0x0C
#define DMC_PHY_CON4                    0x10
#define DMC_PHY_CON6                    0x18
#define DMC_PHY_CON8                    0x20
#define DMC_PHY_CON10                   0x28
#define DMC_PHY_CON11                   0x2C
#define DMC_PHY_CON12                   0x30
#define DMC_PHY_CON13                   0x34
#define DMC_PHY_CON14                   0x38
#define DMC_PHY_CON15                   0x3C
#define DMC_PHY_CON16                   0x40
#define DMC_PHY_CON17                   0x48
#define DMC_PHY_CON18                   0x4C
#define DMC_PHY_CON19                   0x50
#define DMC_PHY_CON20                   0x54
#define DMC_PHY_CON21                   0x58
#define DMC_PHY_CON22                   0x5C
#define DMC_PHY_CON23                   0x60
#define DMC_PHY_CON24                   0x64
#define DMC_PHY_CON25                   0x68
#define DMC_PHY_CON26                   0x6C
#define DMC_PHY_CON27                   0x70
#define DMC_PHY_CON28                   0x74
#define DMC_PHY_CON29                   0x78
#define DMC_PHY_CON30                   0x7C
#define DMC_PHY_CON31                   0x80
#define DMC_PHY_CON32                   0x84
#define DMC_PHY_CON33                   0x88
#define DMC_PHY_CON34                   0x8C
#define DMC_PHY_CON35                   0x90
#define DMC_PHY_CON36                   0x94
#define DMC_PHY_CON37                   0x98
#define DMC_PHY_CON38                   0x9C
#define DMC_PHY_CON39                   0xA0
#define DMC_PHY_CON40                   0xA4
#define DMC_PHY_CON41                   0xA8
#define DMC_PHY_CON42                   0xAC


/*
 * FBM
 */
#define DDR_R1_FBM_BASE		0x10c30000
#define DDR_R0_FBM_BASE		0x10dc0000

#define FBM_MODESEL0		0x0
#define FBM_THRESHOLDSEL0	0x40

/*
 * UART
 */

#define UART0_OFFSET		0x00000
#define UART1_OFFSET		0x10000
#define UART2_OFFSET		0x20000
#define UART3_OFFSET		0x30000

#if defined(CONFIG_SERIAL0)
#define UART_CONSOLE_BASE (EXYNOS5250_UART_BASE + UART0_OFFSET)
#elif defined(CONFIG_SERIAL1)
#define UART_CONSOLE_BASE (EXYNOS5250_UART_BASE  + UART1_OFFSET)
#elif defined(CONFIG_SERIAL2)
#define UART_CONSOLE_BASE (EXYNOS5250_UART_BASE + UART2_OFFSET)
#elif defined(CONFIG_SERIAL3)
#define UART_CONSOLE_BASE (EXYNOS5250_UART_BASE + UART3_OFFSET)
#else
#define UART_CONSOLE_BASE (EXYNOS5250_UART_BASE + UART0_OFFSET)
#endif

#define ULCON_OFFSET			0x00
#define UCON_OFFSET			0x04
#define UFCON_OFFSET			0x08
#define UMCON_OFFSET			0x0C
#define UTRSTAT_OFFSET			0x10
#define UERSTAT_OFFSET			0x14
#define UFSTAT_OFFSET			0x18
#define UMSTAT_OFFSET			0x1C
#define UTXH_OFFSET			0x20
#define URXH_OFFSET			0x24
#define UBRDIV_OFFSET			0x28
#define UDIVSLOT_OFFSET			0x2C
#define UINTP_OFFSET			0x30
#define UINTSP_OFFSET			0x34
#define UINTM_OFFSET			0x38
//#define UTRSTAT_TX_EMPTY		BIT2
//#define UTRSTAT_RX_READY		BIT0
#define UART_ERR_MASK			0xF

/*
 * HS MMC
 */
#define HSMMC_0_OFFSET                  0x00000
#define HSMMC_1_OFFSET                  0x10000
#define HSMMC_2_OFFSET                  0x20000
#define HSMMC_3_OFFSET                  0x30000

#define ELFIN_HSMMC_0_BASE		(EXYNOS5250_HSMMC_BASE + HSMMC_0_OFFSET)
#define ELFIN_HSMMC_1_BASE		(EXYNOS5250_HSMMC_BASE + HSMMC_1_OFFSET)
#define ELFIN_HSMMC_2_BASE		(EXYNOS5250_HSMMC_BASE + HSMMC_2_OFFSET)
#define ELFIN_HSMMC_3_BASE		(EXYNOS5250_HSMMC_BASE + HSMMC_3_OFFSET)

#define HM_SYSAD			(0x00)
#define HM_BLKSIZE			(0x04)
#define HM_BLKCNT			(0x06)
#define HM_ARGUMENT			(0x08)
#define HM_TRNMOD			(0x0c)
#define HM_CMDREG			(0x0e)
#define HM_RSPREG0			(0x10)
#define HM_RSPREG1			(0x14)
#define HM_RSPREG2			(0x18)
#define HM_RSPREG3			(0x1c)
#define HM_BDATA			(0x20)
#define HM_PRNSTS			(0x24)
#define HM_HOSTCTL			(0x28)
#define HM_PWRCON			(0x29)
#define HM_BLKGAP			(0x2a)
#define HM_WAKCON			(0x2b)
#define HM_CLKCON			(0x2c)
#define HM_TIMEOUTCON			(0x2e)
#define HM_SWRST			(0x2f)
#define HM_NORINTSTS			(0x30)
#define HM_ERRINTSTS			(0x32)
#define HM_NORINTSTSEN			(0x34)
#define HM_ERRINTSTSEN			(0x36)
#define HM_NORINTSIGEN			(0x38)
#define HM_ERRINTSIGEN			(0x3a)
#define HM_ACMD12ERRSTS			(0x3c)
#define HM_CAPAREG			(0x40)
#define HM_MAXCURR			(0x48)
#define HM_CONTROL2			(0x80)
#define HM_CONTROL3			(0x84)
#define HM_CONTROL4			(0x8c)
#define HM_HCVER			(0xfe)

/* PENDING BIT */
#define BIT_EINT0			(0x1)
#define BIT_EINT1			(0x1<<1)
#define BIT_EINT2			(0x1<<2)
#define BIT_EINT3			(0x1<<3)
#define BIT_EINT4_7			(0x1<<4)
#define BIT_EINT8_23			(0x1<<5)
#define BIT_BAT_FLT			(0x1<<7)
#define BIT_TICK			(0x1<<8)
#define BIT_WDT				(0x1<<9)
#define BIT_TIMER0			(0x1<<10)
#define BIT_TIMER1			(0x1<<11)
#define BIT_TIMER2			(0x1<<12)
#define BIT_TIMER3			(0x1<<13)
#define BIT_TIMER4			(0x1<<14)
#define BIT_UART2			(0x1<<15)
#define BIT_LCD				(0x1<<16)
#define BIT_DMA0			(0x1<<17)
#define BIT_DMA1			(0x1<<18)
#define BIT_DMA2			(0x1<<19)
#define BIT_DMA3			(0x1<<20)
#define BIT_SDI				(0x1<<21)
#define BIT_SPI0			(0x1<<22)
#define BIT_UART1			(0x1<<23)
#define BIT_USBH			(0x1<<26)
#define BIT_IIC				(0x1<<27)
#define BIT_UART0			(0x1<<28)
#define BIT_SPI1			(0x1<<29)
#define BIT_RTC				(0x1<<30)
#define BIT_ADC				(0x1<<31)
#define BIT_ALLMSK			(0xFFFFFFFF)

#define PWMTIMER_BASE                   EXYNOS5250_PWMTIMER_BASE

/*
 * USBD3 SFR
 */
#define USBDEVICE3_LINK_BASE		0x12000000
#define USBDEVICE3_PHYCTRL_BASE		0x12100000

//==========================
// Global Registers (Gxxxx)
//==========================
// Global Common Registers
#define rGSBUSCFG0			(USBDEVICE3_LINK_BASE + 0xc100)
#define rGSBUSCFG1			(USBDEVICE3_LINK_BASE + 0xc104)
#define rGTXTHRCFG			(USBDEVICE3_LINK_BASE + 0xc108)
#define rGRXTHRCFG			(USBDEVICE3_LINK_BASE + 0xc10c)
#define rGCTL				(USBDEVICE3_LINK_BASE + 0xc110)
#define rGEVTEN				(USBDEVICE3_LINK_BASE + 0xc114)
#define rGSTS				(USBDEVICE3_LINK_BASE + 0xc118)
#define rGSNPSID			(USBDEVICE3_LINK_BASE + 0xc120)
#define rGGPIO				(USBDEVICE3_LINK_BASE + 0xc124)
#define rGUID				(USBDEVICE3_LINK_BASE + 0xc128)
#define rGUCTL				(USBDEVICE3_LINK_BASE + 0xc12c)
#define rGBUSERRADDR_LO			(USBDEVICE3_LINK_BASE + 0xc130)
#define rGBUSERRADDR_HI			(USBDEVICE3_LINK_BASE + 0xc134)

// Global Port to USB Instance Mapping Registers
#define rGPRTBIMAP_LO			(USBDEVICE3_LINK_BASE + 0xc138)
#define rGPRTBIMAP_HI			(USBDEVICE3_LINK_BASE + 0xc13c)
#define rGPRTBIMAP_HS_LO		(USBDEVICE3_LINK_BASE + 0xc180)
#define rGPRTBIMAP_HS_HI		(USBDEVICE3_LINK_BASE + 0xc184)
#define rGPRTBIMAP_FS_LO		(USBDEVICE3_LINK_BASE + 0xc188)
#define rGPRTBIMAP_FS_HI		(USBDEVICE3_LINK_BASE + 0xc18c)

// Global Hardware Parameter Registers
#define rGHWPARAMS0			(USBDEVICE3_LINK_BASE + 0xc140)	// 0x20204000 @c510
#define rGHWPARAMS1			(USBDEVICE3_LINK_BASE + 0xc144)	// 0x0060c93b @c510
#define rGHWPARAMS2			(USBDEVICE3_LINK_BASE + 0xc148)	// 0x12345678 @c510
#define rGHWPARAMS3			(USBDEVICE3_LINK_BASE + 0xc14c)	// 0x10420085 @c510
#define rGHWPARAMS4			(USBDEVICE3_LINK_BASE + 0xc150)	// 0x48820004 @c510
#define rGHWPARAMS5			(USBDEVICE3_LINK_BASE + 0xc154)	// 0x04204108 @c510
#define rGHWPARAMS6			(USBDEVICE3_LINK_BASE + 0xc158)	// 0x04008020 @c510
#define rGHWPARAMS7			(USBDEVICE3_LINK_BASE + 0xc15c)	// 0x018516fe @c510
#define rGHWPARAMS8			(USBDEVICE3_LINK_BASE + 0xc600)	// 0x00000386 @c510

// Global Debug Registers
#define rGDBGFIFOSPACE			(USBDEVICE3_LINK_BASE + 0xc160)
#define rGDBGLTSSM			(USBDEVICE3_LINK_BASE + 0xc164)
#define rGDBGLSPMUX			(USBDEVICE3_LINK_BASE + 0xc170)
#define rGDBGLSP			(USBDEVICE3_LINK_BASE + 0xc174)
#define rGDBGEPINFO0			(USBDEVICE3_LINK_BASE + 0xc178)
#define rGDBGEPINFO1			(USBDEVICE3_LINK_BASE + 0xc17c)

// Global PHY Registers
#define rGUSB2PHYCFG			(USBDEVICE3_LINK_BASE + 0xc200)
#define rGUSB2I2CCTL			(USBDEVICE3_LINK_BASE + 0xc240)
#define rGUSB2PHYACC			(USBDEVICE3_LINK_BASE + 0xc280)
#define rGUSB3PIPECTL			(USBDEVICE3_LINK_BASE + 0xc2c0)

// Global FIFO Size Registers (0 <= num <= 15 @510)
#define rGTXFIFOSIZ(num)		((USBDEVICE3_LINK_BASE + 0xc300) + 0x04*num)
#define rGRXFIFOSIZ0			(USBDEVICE3_LINK_BASE + 0xc380)

// Global Event Buffer Registers (DWC_USB3_DEVICE_NUM_INT = 1 @C510, GHWPARAMS1[20:15])
#define rGEVNTADR_LO0			(USBDEVICE3_LINK_BASE + 0xc400)
#define rGEVNTADR_HI0			(USBDEVICE3_LINK_BASE + 0xc404)
#define rGEVNTSIZ0			(USBDEVICE3_LINK_BASE + 0xc408)
#define rGEVNTCOUNT0			(USBDEVICE3_LINK_BASE + 0xc40c)

//==========================
// Device Registers (Dxxxx)
//==========================
// Device Common Registers
#define rDCFG				(USBDEVICE3_LINK_BASE + 0xc700)
#define rDCTL				(USBDEVICE3_LINK_BASE + 0xc704)
#define rDEVTEN				(USBDEVICE3_LINK_BASE + 0xc708)
#define rDSTS				(USBDEVICE3_LINK_BASE + 0xc70c)
#define rDGCMDPAR			(USBDEVICE3_LINK_BASE + 0xc710)
#define rDGCMD				(USBDEVICE3_LINK_BASE + 0xc714)
#define rDALEPENA			(USBDEVICE3_LINK_BASE + 0xc720)

// Device Endpoint Registers (0 <= ep <= 15)
#define rDOEPCMDPAR2(ep)		((USBDEVICE3_LINK_BASE + 0xc800) + 0x20*ep)
#define rDOEPCMDPAR1(ep)		((USBDEVICE3_LINK_BASE + 0xc804) + 0x20*ep)
#define rDOEPCMDPAR0(ep)		((USBDEVICE3_LINK_BASE + 0xc808) + 0x20*ep)
#define rDOEPCMD(ep)			((USBDEVICE3_LINK_BASE + 0xc80c) + 0x20*ep)

#define rDIEPCMDPAR2(ep)		((USBDEVICE3_LINK_BASE + 0xc810) + 0x20*ep)
#define rDIEPCMDPAR1(ep)		((USBDEVICE3_LINK_BASE + 0xc814) + 0x20*ep)
#define rDIEPCMDPAR0(ep)		((USBDEVICE3_LINK_BASE + 0xc818) + 0x20*ep)
#define rDIEPCMD(ep)			((USBDEVICE3_LINK_BASE + 0xc81c) + 0x20*ep)

//==========================
// USB DEVICE PHY CONTROL REGISTERS
//==========================
#define EXYNOS_PHY_LINKSYSTEM		(USBDEVICE3_PHYCTRL_BASE + 0x04)
#define EXYNOS_PHY_UTMI			(USBDEVICE3_PHYCTRL_BASE + 0x08)
#define EXYNOS_PHY_PIPE			(USBDEVICE3_PHYCTRL_BASE + 0x0C)
#define EXYNOS_PHY_CLKPWR		(USBDEVICE3_PHYCTRL_BASE + 0x10)
#define EXYNOS_PHY_REG0			(USBDEVICE3_PHYCTRL_BASE + 0x14)
#define EXYNOS_PHY_REG1			(USBDEVICE3_PHYCTRL_BASE + 0x18)
#define EXYNOS_PHY_PARAM0		(USBDEVICE3_PHYCTRL_BASE + 0x1C)
#define EXYNOS_PHY_PARAM1		(USBDEVICE3_PHYCTRL_BASE + 0x20)
#define EXYNOS_PHY_TERM			(USBDEVICE3_PHYCTRL_BASE + 0x24)
#define EXYNOS_PHY_TEST			(USBDEVICE3_PHYCTRL_BASE + 0x28)
#define EXYNOS_PHY_ADP			(USBDEVICE3_PHYCTRL_BASE + 0x2C)
#define EXYNOS_PHY_BATCHG		(USBDEVICE3_PHYCTRL_BASE + 0x30)
#define EXYNOS_PHY_RESUME		(USBDEVICE3_PHYCTRL_BASE + 0x34)
#define EXYNOS_PHY_LINK_PORT		(USBDEVICE3_PHYCTRL_BASE + 0x44)

/* USBD 2.0 SFR */
#define USBOTG_LINK_BASE		(0x12140000)
#define USBOTG_PHY_BASE			(0x12130000)

#define EXYNOS5_OTG_SYS	 		(USBOTG_PHY_BASE + 0x038) /* R/W OTG PHY Power Control Register */
#ifndef __ASSEMBLY__
#include <asm/io.h>

#define SAMSUNG_BASE(device, base)				\
static inline unsigned int samsung_get_base_##device(void)	\
{								\
		return base;				        \
}

//SAMSUNG_BASE(clock, CLOCK_BASE)
//SAMSUNG_BASE(gpio, GPIO_BASE)
//SAMSUNG_BASE(pro_id, PRO_ID)
//SAMSUNG_BASE(mmc, MMC_BASE)
//SAMSUNG_BASE(sromc, SROMC_BASE)
SAMSUNG_BASE(timer, PWMTIMER_BASE)
SAMSUNG_BASE(uart, UART_CONSOLE_BASE)
#endif

#endif	/* _EXYNOS5250_CPU_H */
