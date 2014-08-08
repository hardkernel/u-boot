/*
 * Memory setup for SMDK5250 board based on EXYNOS5
 *
 * Copyright (C) 2012 Samsung Electronics
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */

#include <config.h>
#include <asm/io.h>
#include <asm/arch/dmc.h>
#include <asm/arch/clock.h>
#include <asm/arch/power.h>
#include <asm/arch/cpu.h>
#include "setup.h"

#define CONFIG_DMC_CALIBRATION
#undef CONFIG_DMC_CA_CALIBRATION
#define CONFIG_ODTOFF_GATELEVELINGON
#define CONFIG_DMC_BRB
#undef CONFIG_WR_DQ_CAL

#define DDR_R1_FBM_BASE		0x10c30000
#define DDR_R0_FBM_BASE		0x10dc0000
#define FBM_MODESEL0		0x0
#define FBM_THRESHOLDSEL0	0x40


static void set_memclk(void)
{
	struct exynos5_clock *clk = (struct exynos5_clock *)EXYNOS5_CLOCK_BASE;
	volatile u32 ubits;

	/* MEM Clock = 800 MHz */

	/* CLK_SRC_CDREX */
	/* MCLK_DPHY(0:8), MCLK_CDREX(0:4), BPLL(0:0) */
	ubits = (0 << 8) | (0 << 4) | (1 << 0);
	writel(ubits, &clk->src_cdrex);

	/*
	 * CLK_DIV_CDREX
	 * MCLK_DPHY  = 800 / 1 = 800
	 * MCLK_CDREX = 800 / 1 = 800
	 * ACLK_CDREX = MCLK_CDREX / 2 = 400
	 * PCLK_CDREX = 800 / 1 / 6 = 133
	 * MCLK_CDREX2(1/1:28), ACLK_SFRTZASCP(1/2:24), MCLK_DPHY(1/1:20),
	 * MCLK_CDREX(1/1:16), PCLK_CDREX(1/6:4), ACLK_CDREX(1/2:0)
	 */
	ubits = (0 << 28) | (1 << 24) | (0 << 20) | (0 << 16) | (5 << 4) | (1 << 0);
	writel(ubits, &clk->div_cdrex);

	/* CLK_SRC_CORE1 */
	/* MPLL(0:8) : FINPLL=0 */
	ubits = (1 << 8);
	writel(readl(&clk->src_core1) & ~ubits, &clk->src_core1);

	/* Setting MPLL [P,M,S] */
	/* set MPLL_CONT1 */
	ubits = (1 << 21) | (3 << 12) | (8 << 8);
	writel(ubits, &clk->mpll_con1);

	/* set MPLL_CON0 : MPLL=1600Mhz*/
	/* ENABLE(1), MDIV(200), PDIV(3), SDIV(0) */
	ubits = (1 << 31) | (200 << 16) | (3 << 8) | (0 << 0);
	writel(ubits, &clk->mpll_con0);

	/* check mpll locking status */
	while ((readl(&clk->mpll_con0) & (1 << 29)) == 0);

	/* CLK_SRC_CORE1 */
	/* MPLL(0:8) : MOUT_MPLLOUT=1 */
	ubits = (1 << 8);
	writel(ubits, &clk->src_core1);

}
static void dmc_zqinit(u8 dq, u8 ck, u8 cke, u8 cs, u8 ca)
{
	u32 temp;
	u32 zqbase;
	int ch;

	for (ch = 0; ch < 2; ch++) {

		zqbase = 0x10c00000 + (0x10000 * ch);

		temp = readl(zqbase + 0x40);
		temp &= 0xF8FBFFF1;
		temp |= ((dq & 0x7) << 24);
		temp |= ((1<< 18) | (1 << 2));

		writel(temp, zqbase + 0x40);

		temp |= (1 << 1);

		writel(temp, zqbase + 0x40);

		while((readl(zqbase + 0x48) & 0x5) != 0x1);

		temp = readl(zqbase + 0x40);

		temp &= ~(1 << 18);

		writel(temp, zqbase + 0x40);

		temp = ((ck & 0x7) << 9) | ((cke & 0x7) << 6) |
			   ((cs & 0x7) << 3) | (ca & 0x7);

		writel(temp, zqbase + 0xA0);
	}
}

static void dmc_catraining(int ch)
{
	struct exynos5_dmc *dmc = (struct exynos5_dmc *)EXYNOS5_DMC_CTRL_BASE;
	unsigned char code;
	int find_vmw;
	unsigned int phybase;
	unsigned int iord_offset;
	unsigned int temp, mr41, mr48, vwml, vwmr, vwmc;
	unsigned int lock;
	unsigned int resp_mr41, resp_mr48;

	phybase = EXYNOS5_DMC_PHY0_BASE+(0x10000 * ch);
	iord_offset = 0x150 + (0x4 * ch);

	temp = readl(phybase + 0x0000);
	temp |= (1 << 16);
	writel(temp, phybase + 0x0000);

	temp = readl(phybase + 0x0008);
	temp |= (1 << 23);
	writel(temp, phybase + 0x0008);

	code = 0x8;
	find_vmw = 0;
	vwml = vwmr = vwmc = 0;

	if (exynos_pkg_is_pop()) {
		resp_mr41 = 0x5555;
		resp_mr48 = 0x0101;
	} else {
		if ( ch == 0 ) {
			resp_mr41 = 0x69C5;
			resp_mr48 = 0x4040;
		} else {
			resp_mr41 = 0xD14E;
			resp_mr48 = 0x8008;
		}
	}

	while (1) {

		/* code update */
		temp = readl(phybase + 0x0028);
		temp &= 0xFFFFFF00;
		temp |= code;
		writel(temp, phybase + 0x0028);

		/* resync */
		temp = readl(phybase + 0x0028);
		temp &= 0xFEFFFFFF;
		writel(temp, phybase + 0x0028);
		temp |= 0x01000000;
		writel(temp, phybase + 0x0028);
		temp &= 0xFEFFFFFF;
		writel(temp, phybase + 0x0028);

		if (ch == 0) {
			/* Send MRW: MA=0x29 OP=0xA4, 0x50690 */
			writel(0x50690, &dmc->directcmd);
		} else {
			/* Send MRW: MA=0x29 OP=0xA4, 0x10050690 */
			writel(0x10050690, &dmc->directcmd);
		}

		/* Set DMC.CACAL_CONFIG0.deassert_cke=1 */
		writel(0x3FF011, &dmc->cacal_config0);
		/* Set DMC.CACAL_CONFIG1.cacal_csn=1 */
		writel(0x1, &dmc->cacal_config1);
		sdelay(0x100);

		mr41 = readl(EXYNOS5_DMC_CTRL_BASE + iord_offset);
		mr41 &= 0xFFFF;

		/* Set DMC.CACAL_CONFIG0.deassert_cke=0 */
		writel(0x3FF010, &dmc->cacal_config0);
		sdelay(0x100);

		if (ch == 0) {
			/* Send MRW: MA=0x30 OP=0xC0, 0x60300 */
			writel(0x60300, &dmc->directcmd);
		} else {
			/* Send MRW: MA=0x30 OP=0xC0, 0x10060300 */
			writel(0x10060300, &dmc->directcmd);
		}

		/* Set DMC.CACAL_CONFIG0.deassert_cke=1 */
		writel(0x3FF011, &dmc->cacal_config0);
		/* Set DMC.CACAL_CONFIG1.cacal_csn=1 */
		writel(0x1, &dmc->cacal_config1);
		sdelay(0x100);

		mr48 = readl(EXYNOS5_DMC_CTRL_BASE + iord_offset );

		if (exynos_pkg_is_pop()) {
			mr48 &= 0x0303;
		} else {
			if (ch == 0)
				mr48 &= 0xC060;
			else
				mr48 &= 0x8418;
		}

		/* Set DMC.CACAL_CONFIG0.deassert_cke=0 */
		writel(0x3FF010, &dmc->cacal_config0);
		sdelay(0x100);

		if ((find_vmw == 0) && (mr41 == resp_mr41)
				&& (mr48 == resp_mr48)) {
			find_vmw = 0x1;
			vwml = code;
		}

		if ((find_vmw == 1) && ((mr41 != resp_mr41)
					|| (mr48 != resp_mr48))) {
			find_vmw = 0x3;
			vwmr = code - 1;

			if( ch == 0 ) {
				/* Send MRW: MA=0x2A OP=0xA8, 0x50AA0 */
				writel(0x50AA0, &dmc->directcmd);
			} else {
				/* Send MRW: MA=0x2A OP=0xA8, 0x10050AA0 */
				writel(0x10050AA0, &dmc->directcmd);
			}
			break;
		}

		code++;

		if (code == 255)
			while(1);
	}

	vwmc = (vwml + vwmr) / 2;

	{
		unsigned int lock_force;
		unsigned int temp = 0;

		lock_force = (readl( phybase + 0x30 ) >> 8) & 0x7F;

		temp = ((vwml & 0xFF) << 16) |
			   ((vwmr & 0xFF) << 8) |
			   ((vwmc & 0xFF));

		if(ch == 0)
			writel(temp, 0x10040818);
		else
			writel(temp, 0x1004081C);
	}
	/* code update */
	temp = readl(phybase + 0x0028);
	temp &= 0xFFFFFF00;
	temp |= vwmc;
	writel(temp, phybase + 0x0028);

	/* resync */
	temp = readl(phybase + 0x0028);
	temp &= 0xFEFFFFFF;
	writel(temp, phybase + 0x0028);
	temp |= 0x01000000;
	writel(temp, phybase + 0x0028);
	temp &= 0xFEFFFFFF;
	writel(temp, phybase + 0x0028);

	temp = readl(phybase+0x0000);
	temp &= 0xFFFEFFFF;
	writel(temp, phybase + 0x0000);

	/* vmwc convert to offsetd value. */
	lock = readl(phybase + 0x0034);
	lock &= 0x1FF00;
	lock >>= 8;

	if( (lock & 0x3) == 0x3 )
		lock++;

	code = vwmc - (lock >> 2);

	temp = readl(phybase + 0x0028);
	temp &= 0xFFFFFF00;
	temp |= code;
	writel(temp, phybase + 0x0028);

	temp = readl(phybase + 0x0008);
	temp &= 0xFF7FFFFF;
	writel(temp, phybase + 0x0008);
}

#if defined(CONFIG_LPDDR3)
static void mem_ctrl_init_lpddr3()
{
	struct exynos5_phy_control *phy0_ctrl, *phy1_ctrl;
	struct exynos5_dmc *dmc;
	struct exynos5_clock *clk = (struct exynos5_clock *)EXYNOS5_CLOCK_BASE;
	unsigned int lock, temp;

	phy0_ctrl = (struct exynos5_phy_control *)EXYNOS5_DMC_PHY0_BASE;
	phy1_ctrl = (struct exynos5_phy_control *)EXYNOS5_DMC_PHY1_BASE;
	dmc = (struct exynos5_dmc *)EXYNOS5_DMC_CTRL_BASE;

	/* Step2. the right value to PHY_CON0.ctrl_ddr_mode */
	/* PHY.CON0[12:11].ctrl_ddr_mode=LPDDR3 */
	writel(0x17021A40, &phy0_ctrl->phy_con0);
	writel(0x17021A40, &phy1_ctrl->phy_con0);

	/* Step3. Enable CA swap when POP is used */
	/* PHY.CON0.ctrl_atgate=0x0 */
	writel(0x17021A00, &phy0_ctrl->phy_con0);
	writel(0x17021A00, &phy1_ctrl->phy_con0);

	if (exynos_pkg_is_pop()) {
		/* LPDDR3PHY_CON3[31]=1. */
		writel(0x80000000, &clk->lpddr3phy_con3);
		/* PHY.CON24=1. */
		writel(0x1, &phy0_ctrl->phy_con24);
		writel(0x1, &phy1_ctrl->phy_con24);
	} else {
		/* LPDDR3PHY_CON3[31]=0. */
		writel(0x0, &clk->lpddr3phy_con3);
		/* PHY.CON24=0. */
		writel(0x0, &phy0_ctrl->phy_con24);
		writel(0x0, &phy1_ctrl->phy_con24);
	}

	/* Step4. Set PHY for DQS pull-down mode */
	/* PHY.CON14.ctrl_pulld_dq=0x0, ctrl_pulld_dqs=0x0F */
	writel(0x0F, &phy0_ctrl->phy_con14);
	writel(0x0F, &phy1_ctrl->phy_con14);

	/* Step5. Set PHY_CON42.ctrl_bstlen and PHY_CON42.ctrl_rdlat */
	/* PHY.CON42.ctrl_bstlen[12:8]=0x8, ctrl_rdlat[4:0]=0x0C */
	writel(0x80C, &phy0_ctrl->phy_con42);
	writel(0x80C, &phy1_ctrl->phy_con42);

	/* PHY.CON26.T_wrdata_en[20:16]=0x7 */
	writel(0x7107F, &phy0_ctrl->phy_con26);
	writel(0x7107F, &phy1_ctrl->phy_con26);

	/* Set PHY.PHY_CON0.ctrl_read_disable=0x0 */
	/* Set PHY.PHY_CON16.zq_term */
	writel(0x17021A00, &phy0_ctrl->phy_con0);
	writel(0x8080304, &phy0_ctrl->phy_con16);
	writel(0x17021A00, &phy1_ctrl->phy_con0);
	writel(0x8080304, &phy1_ctrl->phy_con16);
	//- Set 0x1003_0B00[0]=0x1
	writel(0x1, 0x10030B00);

	/* Step6. ZQ calibration */
	if (exynos_pkg_is_pop()) {
		/* Set PHY0.CON16.zq_mode_dds=0x6000000 */
		writel(0xE0C0304, &phy0_ctrl->phy_con16);
		/* Set PHY0.CON16.zq_manual_mode=1 */
		writel(0xE0C0304, &phy0_ctrl->phy_con16);
		/* Set PHY0.CON16.zq_manual_str */
		writel(0xE0C0306, &phy0_ctrl->phy_con16);
		/* Wait for PHY0.CON17.zq_done */
		while((readl(&phy0_ctrl->phy_con17) & 0x1) != 0x1);
		/* Set PHY0.CON16.zq_clk_en=0 */
		writel(0xE080304, &phy0_ctrl->phy_con16);

		/* Set PHY1.CON16.zq_mode_dds=0x6000000 */
		writel(0xE0C0304, &phy1_ctrl->phy_con16);
		/* Set PHY1.CON16.zq_manual_mode=1 */
		writel(0xE0C0304, &phy1_ctrl->phy_con16);
		/* Set PHY1.CON16.zq_manual_str */
		writel(0xE0C0306, &phy1_ctrl->phy_con16);
		/* Wait for PHY1.CON17.zq_done */
		while((readl(&phy1_ctrl->phy_con17) & 0x1) != 0x1);
		/* Set PHY1.CON16.zq_clk_en=0 */
		writel(0xE080304, &phy1_ctrl->phy_con16);

		/* PHY0.CON39[11:0]=0xDB6 */
		writel(0xDB6, &phy0_ctrl->phy_con39);
		writel(0xDB6, &phy1_ctrl->phy_con39);
	} else {
		dmc_zqinit(0x4, 0x4, 0x4, 0x4, 0x4);
	}

	/*
	 * Step7. Set CONCONTROL.
	 * At this moment, assert the dfi_init_start field to high.
	 */
	/* DMC.CONCOTROL.rdfetch=0x2 */
	writel(0xFFF2100, &dmc->concontrol);
	/* DMC.CONCOTROL : assert dfi_init_start */
	writel(0x1FFF2100, &dmc->concontrol);
	sdelay(0x10000); //- wait 100ms
	/* DMC.CONCOTROL : deassert dfi_init_start */
	writel(0xFFF2100, &dmc->concontrol);

	/* phase 2 : setting controller register */

	/*
	 * Step8. set memcontrol.
	 * at this moment, switch off all low power feature.
	 */
	writel(0x312700, &dmc->memcontrol);

	/* Step9. set the membaseconfig0 register. */
	/* if there are two external memory chips set the membasecon1 reg.*/
	/* chipbase0=0x40, mask=0x7c0 */
	writel(0x4007c0, &dmc->membaseconfig0);
	/* chipbase1=0x80, mask=0x7c0 */
	writel(0x8007c0, &dmc->membaseconfig1);
	/* set memconfig0,1 */
	writel(0x1323, &dmc->memconfig0);
	writel(0x1323, &dmc->memconfig1);

	/* Step10. Set the PRECHCONFIG register */
	/* DMC.PRECHCONFIG[15:0]=(0x0|0x0) */
	writel(0xFF000000, &dmc->prechconfig);

	/*
	 * Step11.
	 * Set the TIMINGAREF, TIMINGROW, TIMINGDATA,TIMINGPOWER registers
	 * according to memory AC parameters.
	 */
	/* DMC.ivcontrol.iv_size=0x7 */
	writel(0x7, &dmc->ivcontrol);
	/* DMC.TIMINGAREF.tREFI=0x5D */
	writel(0x5D, &dmc->timingaref);
	/* DMC.TIMINGROW=0x34498692 */
	writel(0x34498692, &dmc->timingrow);
	/* DMC.TIMINGDATA=0x3630560C */
	writel(0x3630560C, &dmc->timingdata);
	/* DMC.TIMINGPOWER=0x50380336 */
	writel(0x50380336, &dmc->timingpower);
	writel(0x312700, &dmc->memcontrol);

	/*
	 * Step12.
	 * Set the QOSCONTROL0~15 and BRBQOSCONFIG register
	 * if Qos Scheme is required.
	 */
	/* QOS#0~14.=0xFFF, QOS#15=0x0 */
	writel(0xFFF, &dmc->qoscontrol0);
	writel(0xFFF, &dmc->qoscontrol1);
	writel(0xFFF, &dmc->qoscontrol2);
	writel(0xFFF, &dmc->qoscontrol3);
	writel(0xFFF, &dmc->qoscontrol4);
	writel(0xFFF, &dmc->qoscontrol5);
	writel(0xFFF, &dmc->qoscontrol6);
	writel(0xFFF, &dmc->qoscontrol7);
	writel(0xFFF, &dmc->qoscontrol8);
	writel(0xFFF, &dmc->qoscontrol9);
	writel(0xFFF, &dmc->qoscontrol10);
	writel(0xFFF, &dmc->qoscontrol11);
	writel(0xFFF, &dmc->qoscontrol12);
	writel(0xFFF, &dmc->qoscontrol13);
	writel(0xFFF, &dmc->qoscontrol14);
	writel(0x0, &dmc->qoscontrol15);

	/*
	 * Step13. Set the PHY_CON4.ctrl_offsetr0~3
	 * and PHY_CON6.ctrl_offsetw0~3 to 0x7F.
	 */
	/* READ SDLL : offsetr=0:0x7F, 1:0x7F, 2:0x7F, 3:0x7F */
	writel(0x7F7F7F7F, &phy0_ctrl->phy_con4);
	writel(0x7F7F7F7F, &phy1_ctrl->phy_con4);
	/* WRTIE SDLL : offsetr=0:0x7F, 1:0x7F, 2:0x7F, 3:0x7F */
	writel(0x7F7F7F7F, &phy0_ctrl->phy_con6);
	writel(0x7F7F7F7F, &phy1_ctrl->phy_con6);

	/* Step14. Set the PHY_CON10.ctrl_offsetd value to 0x7F. */
	writel(0x7F, &phy0_ctrl->phy_con10);
	writel(0x7F, &phy1_ctrl->phy_con10);

	/* Step15. Set the PHY_CON12.ctrl_force value to 0x7F.*/
	writel(0x10107F70, &phy0_ctrl->phy_con12);
	writel(0x10107F70, &phy1_ctrl->phy_con12);

	/* Step16. Set the PHY_CON12.ctrl_dll_on value to low.*/
	writel(0x10107F50, &phy0_ctrl->phy_con12);
	writel(0x10107F50, &phy1_ctrl->phy_con12);

	/* Step17. Wait for 10 PCLK cycles. */
	sdelay(0x100);

	/* Step18. Update the DLL information. */
	/* fp_resync=1 */
	writel(0x8, &dmc->phycontrol0);
	/* fp_resync=0 */
	writel(0x0, &dmc->phycontrol0);

	/*
	 * PHASE 3 : Memory Initialization
	 */
	/* Step19. ~ 26. nop, mr63, mr10, mr1, mr2, mr3 command */
	/* port:0x0, cs:0x0 */
	writel(0x7000000, &dmc->directcmd);
	sdelay(0x100);
	writel(0x71C00, &dmc->directcmd);
	sdelay(0x100);
	writel(0x10BFC, &dmc->directcmd);
	sdelay(0x100);
	writel(0x50C, &dmc->directcmd);
	sdelay(0x100);
	writel(0x868, &dmc->directcmd);
	sdelay(0x100);
	writel(0xC04, &dmc->directcmd);
	sdelay(0x100);
	/* port:0x0, cs:0x1 */
	writel(0x7100000, &dmc->directcmd);
	sdelay(0x100);
	writel(0x171C00, &dmc->directcmd);
	sdelay(0x100);
	writel(0x110BFC, &dmc->directcmd);
	sdelay(0x100);
	writel(0x10050C, &dmc->directcmd);
	sdelay(0x100);
	writel(0x100868, &dmc->directcmd);
	sdelay(0x100);
	writel(0x100C04, &dmc->directcmd);
	sdelay(0x100);
	/* port:0x1, cs:0x0 */
	writel(0x17000000, &dmc->directcmd);
	sdelay(0x100);
	writel(0x10071C00, &dmc->directcmd);
	sdelay(0x100);
	writel(0x10010BFC, &dmc->directcmd);
	sdelay(0x100);
	writel(0x1000050C, &dmc->directcmd);
	sdelay(0x100);
	writel(0x10000868, &dmc->directcmd);
	sdelay(0x100);
	writel(0x10000C04, &dmc->directcmd);
	sdelay(0x100);
	/* port:0x1, cs:0x1 */
	writel(0x17100000, &dmc->directcmd);
	sdelay(0x100);
	writel(0x10171C00, &dmc->directcmd);
	sdelay(0x100);
	writel(0x10110BFC, &dmc->directcmd);
	sdelay(0x100);
	writel(0x1010050C, &dmc->directcmd);
	sdelay(0x100);
	writel(0x10100868, &dmc->directcmd);
	sdelay(0x100);
	writel(0x10100C04, &dmc->directcmd);
	sdelay(0x100);

	/* Step.27 Return to the memory operating frequency.*/
	set_memclk();

	/*
	 * Step.28
	 * Set the PHY_CON4.ctrl_offsetr0~3 & PHY_CON6.ctrl_offsetw0~3 to 0x8.
	 */
	/* READ SDLL : offsetr=0:0x08, 1:0x08, 2:0x08, 3:0x08 */
	writel(0x8080808, &phy0_ctrl->phy_con4);
	writel(0x8080808, &phy1_ctrl->phy_con4);
	/* WRTIE SDLL : offsetw=0:0x08, 1:0x08, 2:0x08, 3:0x08 */
	writel(0x8080808, &phy0_ctrl->phy_con6);
	writel(0x8080808, &phy1_ctrl->phy_con6);
	/* Step29. Set the PHY_CON104.ctrl_offsetd value to 0x8. */
	writel(0x8, &phy0_ctrl->phy_con10);
	writel(0x8, &phy1_ctrl->phy_con10);

	/* Step30. ~ 34. */
	/* PHY0_CON12.ctrl_dll_on[5] = 1*/
	writel(0x10107F70, &phy0_ctrl->phy_con12);
	sdelay(0x100);
	/* PHY0_CON12.ctrl_dll_on[6] = 0*/
	writel(0x10107F30, &phy0_ctrl->phy_con12);
	/* PHY0_CON12.ctrl_dll_on[6] = 1*/
	writel(0x10107F70, &phy0_ctrl->phy_con12);
	sdelay(0x100);

	/* PHY1_CON12.ctrl_dll_on[5] = 1*/
	writel(0x10107F70, &phy1_ctrl->phy_con12);
	sdelay(0x100);
	/* PHY1_CON12.ctrl_dll_on[6] = 0*/
	writel(0x10107F30, &phy1_ctrl->phy_con12);
	/* PHY1_CON12.ctrl_dll_on[6] = 1*/
	writel(0x10107F70, &phy1_ctrl->phy_con12);
	sdelay(0x100);

	/* Step35. ~ 36. */
	/* DMC.CONCOTROL : assert dfi_init_start */
	writel(0x1FFF2100, &dmc->concontrol);
	/* Wait for DMC.dfi_init_complete_ch0/1 */
	while((readl(&dmc->phystatus) & 0xC) != 0xC);
	/* DMC.CONCOTROL : deassert dfi_init_start */
	writel(0xFFF2100, &dmc->concontrol);

	/* Step37. Update the DLL information. */
	/* fp_resync=1 */
	writel(0x8, &dmc->phycontrol0);
	/* fp_resync=0 */
	writel(0x0, &dmc->phycontrol0);

#if defined(CONFIG_DMC_CALIBRATION)
	/* 38) Do leveing and calibration */
	/* 39) Perform these steps */

	/*
	 * a. Update PHYCON12.ctrl_force with
	 * by using PHY_CON13.ctrl_lock_value[9:2]
	 */
	lock = (readl(&phy0_ctrl->phy_con13) >> 8) & 0xFF;
	if((lock & 0x3) == 0x3) {
		lock++;
	}

	temp = readl(&phy0_ctrl->phy_con12) & 0xFFFF80FF;
	temp |= ((lock >> 2) << 8);
	writel(temp, &phy0_ctrl->phy_con12);

	lock = (readl(&phy1_ctrl->phy_con13) >> 8) & 0xFF;
	if((lock & 0x3) == 0x3) {
		lock++;
	}

	temp = readl(&phy1_ctrl->phy_con12) & 0xFFFF80FF;
	temp |= ((lock >> 2) << 8);
	writel(temp, &phy1_ctrl->phy_con12);

	/* b. Enable PHY_CON0.ctrl_atgate */
	writel(0x17021A40, &phy0_ctrl->phy_con0);
	writel(0x17021A40, &phy1_ctrl->phy_con0);

	/* d. Enable PHY_CON0.p0_cmd_en */
	writel(0x17025A40, &phy0_ctrl->phy_con0);
	writel(0x17025A40, &phy1_ctrl->phy_con0);

	/* e. Enable PHY_CON2.InitDeskewEn */
	writel(0x10044, &phy0_ctrl->phy_con2);
	writel(0x10044, &phy1_ctrl->phy_con2);

	/* f. Enable PHY_CON0.byte_rdlvl_en */
	writel(0x17027A40, &phy0_ctrl->phy_con0);
	writel(0x17027A40, &phy1_ctrl->phy_con0);

	/* c. Disable PHY_CON12.ctrl_dll_on */
	temp = readl(&phy0_ctrl->phy_con12) & 0xFFFFFFDF;
	writel(temp, &phy0_ctrl->phy_con12);
	temp = readl(&phy1_ctrl->phy_con12) & 0xFFFFFFDF;
	writel(temp, &phy1_ctrl->phy_con12);
	sdelay(0x100);

	/* CA Training. */
#if defined(CONFIG_DMC_CA_CALIBRATION)
	dmc_catraining(0);
	dmc_catraining(1);
#endif

	if (exynos_pkg_is_pop()) {
		unsigned int cal_error = 0;
		unsigned int cal_count = 0;

		/* Read DQ Calibration. */
		/* Set PHY0.CON1.rdlvl_rddata_adj */
		writel(0x92F00FF, &phy0_ctrl->phy_con1);
		writel(0x92F00FF, &phy1_ctrl->phy_con1);
		/* PHY0.CON22.lpddr2_addr=0x041 */
		writel(0x00000041, &phy0_ctrl->phy_con22);
		writel(0x00000041, &phy1_ctrl->phy_con22);
		/* Set PHY0.CON2.rdlvl_en */
		writel( 0x2010044, &phy0_ctrl->phy_con2);
		writel( 0x2010044, &phy1_ctrl->phy_con2);
		/* DMC.RDLVLCONFIG.ctrl_rdlvl_data_en=1 */
		writel(0x2, &dmc->rdlvl_config);
		/* Wait DMC.rdlvl_complete_ch0/1 */
		while((readl(&dmc->phystatus) & 0xC000) != 0xC000) {
			if (cal_count++ > 10) {
				cal_error = 1;
				break;
			} else
				sdelay(100);
		}
		/* Set DMC.RDLVLCONFIG.ctrl_rdlvl_data_en=0 */
		writel(0x0, &dmc->rdlvl_config);

		writel(0xC, &phy0_ctrl->phy_con5);
		cal_error |= readl(&phy0_ctrl->phy_con21);

		writel(0xC, &phy1_ctrl->phy_con5);
		cal_error |= readl(&phy1_ctrl->phy_con21);

		writel(0x0, &phy0_ctrl->phy_con5);
		writel(0x0, &phy1_ctrl->phy_con5);

		if (cal_error) {
			/* clear PHYx.CON2.rdlvl_en */
			writel(readl(&phy0_ctrl->phy_con2) & ~(1<<25), &phy0_ctrl->phy_con2);
			writel(readl(&phy1_ctrl->phy_con2) & ~(1<<25), &phy1_ctrl->phy_con2);
		}
		/* Write DQ Calibration. */
#if defined(CONFIG_WR_DQ_CAL)
		/* Wait for DMC.chip_busy_state CH0 */
		while((readl(&dmc->chipstatus_ch0) & 0x3) != 0x0);
		while((readl(&dmc->chipstatus_ch1) & 0x3) != 0x0);
		/* DMC.WRTRACONFIG */
		writel(0x1, &dmc->wrtra_config);
		/* Read leveling control */
		writel(0x204, &phy0_ctrl->phy_con22);
		writel(0x204, &phy1_ctrl->phy_con22);
		/* Set "rdlvl_rddata_adj" to 0x0001 or 0x0100 in PHY_CON1*/
		writel(0x92F00FF, &phy0_ctrl->phy_con1);
		writel(0x92F00FF, &phy1_ctrl->phy_con1);
		/* PHY_CON2 */
		writel(0x6010044, &phy0_ctrl->phy_con2);
		writel(0x6010044, &phy1_ctrl->phy_con2);
		writel(0xE010044, &phy0_ctrl->phy_con2);
		writel(0xE010044, &phy1_ctrl->phy_con2);
		/* Wait DMC.rdlvl_complete_ch0/1 */
		while((readl(&dmc->phystatus) & 0xC000) != 0xC000);
		writel(0x6010044, &phy0_ctrl->phy_con2);
		writel(0x6010044, &phy1_ctrl->phy_con2);

		writel(0xC, &phy0_ctrl->phy_con5);
		while(readl(&phy0_ctrl->phy_con21) != 0);

		writel(0xC, &phy1_ctrl->phy_con5);
		while(readl(&phy1_ctrl->phy_con21) != 0);

		writel(0x0, &phy0_ctrl->phy_con5);
		writel(0x0, &phy1_ctrl->phy_con5);
#endif
	}

	/* Step43. Enable PHY_CON12.ctrl_dll_on */
	temp = readl(&phy0_ctrl->phy_con12) | 0x20;
	writel(temp, &phy0_ctrl->phy_con12);

	temp = readl(&phy1_ctrl->phy_con12) | 0x20;
	writel(temp, &phy1_ctrl->phy_con12);

	/* Step44. Disable PHY_CON.ctrl_atgate when POP is used */
	if (exynos_pkg_is_pop()) {
		/* PHY_CON0.ctrl_atgate=0x0 */
		writel(0x17027A00, &phy0_ctrl->phy_con0);
		writel(0x17027A00, &phy1_ctrl->phy_con0);
	}
	/* Set PHY_CON0.ctrl_upd_range=0x1 */
	writel(0x17127A00, &phy0_ctrl->phy_con0);
	writel(0x17127A00, &phy1_ctrl->phy_con0);

	/* Step45. Enable PHY_CON2.DLLDeSkewEn */
	if (exynos_pkg_is_pop()) {
		/* PHY_CON2.DllDeskewEn=1. */
		writel(0x2011044, &phy0_ctrl->phy_con2);
		writel(0x2011044, &phy1_ctrl->phy_con2);
	} else {
		/* PHY_CON2.DllDeskewEn=1. */
		writel(0x11044, &phy0_ctrl->phy_con2);
		writel(0x11044, &phy1_ctrl->phy_con2);
	}
	/* Step46. Update the DLL information */
	/* fp_resync=1 */
	writel(0x8, &dmc->phycontrol0);
	/* fp_resync=0 */
	writel(0x0, &dmc->phycontrol0);
#endif

	/* Step47. ODT is not supported in LPDDR2/LPDDR3 */
	if (exynos_pkg_is_pop()) {
		/* Set PHY_PHY_CON0.ctrl_read_disable=0x0 */
		/* Set PHY_PHY_CON16.zq_term. */
		writel(0x17127A00, &phy0_ctrl->phy_con0);
		writel(0xE080304, &phy0_ctrl->phy_con16);
		writel(0x17127A00, &phy1_ctrl->phy_con0);
		writel(0xE080304, &phy1_ctrl->phy_con16);
	}

	/* Step48. Issue the PALL command to memory */
	writel(0x1000000, &dmc->directcmd);
	writel(0x1100000, &dmc->directcmd);
	writel(0x11000000, &dmc->directcmd);
	writel(0x11100000, &dmc->directcmd);
	/* Step49. Set the MEMCONTROL if power-down modes are required. */
	/* DMC.MEMCONTROL.tp_en=0x0. */
	writel(0x312700, &dmc->memcontrol);
	/* DMC.PRECHCONFIG.tp_cnt=0xFF */
	writel(0xFF000000, &dmc->prechconfig);
	/* DMC.PWRDNCONFIG.dsref_cyc=0xFFFF0000 */
	writel(0xFFFF00FF, &dmc->pwrdnconfig);
	/* Set DMC.MEMCONTROL.dsref_en=0x20. */
	writel(0x312720, &dmc->memcontrol);
	/* Set DMC.PWRDNCONFIG.dpwrdn_cyc=0xFF */
	writel(0xFFFF00FF, &dmc->pwrdnconfig);
	/* Set DMC.MEMCONTROL.dpwrdn_en=0x2., dpwrdn_type=0x0 */
	writel(0x312722, &dmc->memcontrol);
	/* DMC.MEMCONTROL.clk_stop_en=0x1. */
	writel(0x312723, &dmc->memcontrol);
	/* Set DMC.PHYCONTROL.io_pd_con=0x1. */
	writel(0xFFF2108, &dmc->concontrol);
	/* Step50. Set the CONCONTROL to turn on an auto refresh counter. */
	writel(0xFFF2128, &dmc->concontrol);

}

#else
static void mem_ctrl_init_ddr3(void)
{
	struct exynos5_phy_control *phy0_ctrl, *phy1_ctrl;
	struct exynos5_dmc *dmc;
	struct exynos5_clock *clk = (struct exynos5_clock *)EXYNOS5_CLOCK_BASE;
	struct exynos5_power *pmu = (struct exynos5_power *)EXYNOS5_POWER_BASE;

	phy0_ctrl = (struct exynos5_phy_control *)EXYNOS5_DMC_PHY0_BASE;
	phy1_ctrl = (struct exynos5_phy_control *)EXYNOS5_DMC_PHY1_BASE;
	dmc = (struct exynos5_dmc *)EXYNOS5_DMC_CTRL_BASE;
	unsigned int ap_odt, dram_odt;

#if defined(CONFIG_ODTOFF_GATELEVELINGON)
	ap_odt = 0xE2C0000;
	dram_odt = 0x2;
#else
	/* ODT On and Gate Leveling Off */
	ap_odt = 0xE240000;
	dram_odt = 0x42;
#endif

	set_memclk();

	/*  wait 300ms */
	sdelay(0x10000);

	/* Run Phyreset when only not wakeup */
	if (!(readl(&pmu->wakeup_stat) & 0x80300000)) {
		/* PHY_RESET[0]=0 */
		writel(0x00000000, &clk->lpddr3phy_ctrl);
		sdelay(100);
		/* PHY_RESET[0]=1 */
		writel(0x00000001, &clk->lpddr3phy_ctrl);
		sdelay(100);
	}

	/* PHY_CON39 : dds of CA = 0x3 */
	writel(0x000006DB, &phy0_ctrl->phy_con39);
	writel(0x000006DB, &phy1_ctrl->phy_con39);
	/* Set PHY_CON42.ctrl_bstlen[12:8]=8, ctrl_rdlat[4:0]=11 */
	writel(0x0000080B, &phy0_ctrl->phy_con42);
	writel(0x0000080B, &phy1_ctrl->phy_con42);

	/* Set PHY.PHY_CON16 */
	/* zq_mode_dds[26:24], zq_mode_term[23:21], zq_clk_div_en[18]=1 */
	writel(ap_odt|0x0304, &phy0_ctrl->phy_con16);
	writel(ap_odt|0x0304, &phy1_ctrl->phy_con16);
	/* zq_mode_dds[26:24], zq_mode_term[23:21], zq_mode_noterm[19]=0 */
	writel(ap_odt|0x0304, &phy0_ctrl->phy_con16);
	writel(ap_odt|0x0304, &phy1_ctrl->phy_con16);
	/* zq_mode_dds[26:24], zq_mode_term[23:21], zq_manual_start[1]=1 */
	writel(ap_odt|0x0306, &phy0_ctrl->phy_con16);
	writel(ap_odt|0x0306, &phy1_ctrl->phy_con16);
	/* Wait for PHY_CON17.zq_done */
	while((readl(&phy0_ctrl->phy_con17) & 0x1) != 0x1);
	while((readl(&phy1_ctrl->phy_con17) & 0x1) != 0x1);
	/* zq_mode_dds[26:24], zq_mode_term[23:21], zq_manual_start[1]=0 */
	writel(ap_odt|0x0304, &phy0_ctrl->phy_con16);
	writel(ap_odt|0x0304, &phy1_ctrl->phy_con16);

	/* PHY_CON14.ctrl_pulld_dqs[3:0]=0xf */
	writel(0x0000000F, &phy0_ctrl->phy_con14);
	writel(0x0000000F, &phy1_ctrl->phy_con14);

	/* dfi_init_start[28]=1, rd_fetch[14:12]=3 */
	writel((0x1FFF0000 | (0x3 << 12)), &dmc->concontrol);
	/* mem_term_en[31]=1, phy_term_en[30]=1, */
	/* gate signal length[29]=1, fp_resync[3]=1*/
	writel(0xE0000008, &dmc->phycontrol0);
	/* mem_term_en[31]=1, phy_term_en[30]=1, */
	/* gate signal length[29]=1, fp_resync[3]=0*/
	writel(0xE0000000, &dmc->phycontrol0);

	/* Set PHY_CON4.ctrl_offsetr0~3 & PHY_CON6.ctrl_offsetw0~3 to 0x8.*/
	/* READ SDLL : offsetr=0:0x08, 1:0x08, 2:0x08, 3:0x08 */
	writel(0x8080808, &phy0_ctrl->phy_con4);
	writel(0x8080808, &phy1_ctrl->phy_con4);
	/* WRTIE SDLL : offsetw=0:0x08, 1:0x08, 2:0x08, 3:0x08 */
	writel(0x8080808, &phy0_ctrl->phy_con6);
	writel(0x8080808, &phy1_ctrl->phy_con6);

	/* Set the PHY_CON104.ctrl_offsetd value to 0x8. */
	writel(0x8, &phy0_ctrl->phy_con10);
	writel(0x8, &phy1_ctrl->phy_con10);

	/* ctrl_force[14:8]=0x0, ctrl_start[6]=0, ctrl_dll_on[5]=1 */
	writel(0x10100030, &phy0_ctrl->phy_con12);
	writel(0x10100030, &phy1_ctrl->phy_con12);
	sdelay(100);
	/* ctrl_dll_start[6]=1 */
	writel(0x10100070, &phy0_ctrl->phy_con12);
	writel(0x10100070, &phy1_ctrl->phy_con12);
	sdelay(100);

	/* Wait for DMC.dfi_init_complete_ch0/1 */
	while((readl(&dmc->phystatus) & 0xC) != 0xC);

	/* mem_term_en[31]=1, phy_term_en[30]=1, */
	/* gate signal length[29]=1, fp_resync[3]=1 */
	writel(0xE0000008, &dmc->phycontrol0);
	/* fp_resync[3]=0 */
	writel(0xE0000000, &dmc->phycontrol0);
	/* fp_resync[3]=1 */
	writel(0xE0000008, &dmc->phycontrol0);
	/* fp_resync[3]=0 */
	writel(0xE0000000, &dmc->phycontrol0);

	/* dfi_init_start[28]=0, rd_fetch[14:12]=3 */
	writel((0x0FFF0000 | (0x3 << 12)), &dmc->concontrol);
	/* DMC.ivcontrol.iv_size=0x7 */
	writel(0x7, &dmc->ivcontrol);

	/* set memconfig0,1 for bank interleaving */
	writel(0x00001333, &dmc->memconfig0);
	writel(0x00001333, &dmc->memconfig1);
	/* chipbase0=0x40, mask=0x780 */
	writel(0x00400780, &dmc->membaseconfig0);
	/* chipbase1=0x80, mask=0x780 */
	writel(0x00800780, &dmc->membaseconfig1);
	/* precharge policy counter */
	writel(0xFF000000, &dmc->prechconfig);

	/* low power counter */
	writel(0xFFFF00FF, &dmc->pwrdnconfig);
	/* refresh counter */
	writel(0x000000BB, &dmc->timingaref);
	/* timing row */
	writel(0x8C36650E, &dmc->timingrow);
	/* timing data */
	writel(0x3630580B, &dmc->timingdata);
	/* timing power */
	writel(0x41000A44, &dmc->timingpower);

	/*
	 * Set the QOSCONTROL0~15 and BRBQOSCONFIG register
	 * if Qos Scheme is required.
	 */
	/* QOS#0~14.=0xFFF, QOS#15=0x0 */
	writel(0xFFF, &dmc->qoscontrol0);
	writel(0xFFF, &dmc->qoscontrol1);
	writel(0xFFF, &dmc->qoscontrol2);
	writel(0xFFF, &dmc->qoscontrol3);
	writel(0xFFF, &dmc->qoscontrol4);
	writel(0xFFF, &dmc->qoscontrol5);
	writel(0xFFF, &dmc->qoscontrol6);
	writel(0xFFF, &dmc->qoscontrol7);
	writel(0xFFF, &dmc->qoscontrol8);
	writel(0xFFF, &dmc->qoscontrol9);
	writel(0xFFF, &dmc->qoscontrol10);
	writel(0xFFF, &dmc->qoscontrol11);
	writel(0xFFF, &dmc->qoscontrol12);
	writel(0xFFF, &dmc->qoscontrol13);
	writel(0xFFF, &dmc->qoscontrol14);
	writel(0x0, &dmc->qoscontrol15);

	/* Issue the PALL command to memory */
	writel(0x01000000, &dmc->directcmd);
	writel(0x01100000, &dmc->directcmd);
	writel(0x11000000, &dmc->directcmd);
	writel(0x11100000, &dmc->directcmd);

	writel(0x07000000, &dmc->directcmd);
	writel(0x00020000 | 0x18, &dmc->directcmd);
	writel(0x00030000, &dmc->directcmd);
	writel(0x00010000 | dram_odt, &dmc->directcmd);
	writel(0x00000000 | 0xD70, &dmc->directcmd);
	writel(0x0a000000, &dmc->directcmd);
	writel(0x17000000, &dmc->directcmd);
	writel(0x10020000 | 0x18, &dmc->directcmd);
	writel(0x10030000, &dmc->directcmd);
	writel(0x10010000 | dram_odt, &dmc->directcmd);
	writel(0x10000000 | 0xD70, &dmc->directcmd);
	writel(0x1a000000, &dmc->directcmd);

#if defined(CONFIG_ODTOFF_GATELEVELINGON)
	/* ctrl_atgate=1 */
	writel(0x17020A40, &phy0_ctrl->phy_con0);
	writel(0x17020A40, &phy1_ctrl->phy_con0);

	/* p0_cmd_en=1 */
	writel(0x17024A40, &phy0_ctrl->phy_con0);
	writel(0x17024A40, &phy1_ctrl->phy_con0);

	/* InitDeskewEn=1 */
	writel(0x00010044, &phy0_ctrl->phy_con2);
	writel(0x00010044, &phy1_ctrl->phy_con2);

	/* byte_rdlvl_en=1 */
	writel(0x17026A40, &phy0_ctrl->phy_con0);
	writel(0x17026A40, &phy1_ctrl->phy_con0);

	/* ctrl_force[14:8], ctrl_dll_on[5]=0 */
	writel(0x10101950, &phy0_ctrl->phy_con12);
	writel(0x10101950, &phy1_ctrl->phy_con12);

	/* rdlvl_gate_en=1 */
	writel(0x01010044, &phy0_ctrl->phy_con2);
	writel(0x01010044, &phy1_ctrl->phy_con2);

	/* ctrl_shgate=1 */
	writel(0x17026B40, &phy0_ctrl->phy_con0);
	writel(0x17026B40, &phy1_ctrl->phy_con0);

	/* ctrl_gateduradj=0 */
	writel(0x9010100, &phy0_ctrl->phy_con1);
	writel(0x9010100, &phy1_ctrl->phy_con1);

	/* ctrl_rdlvl_data_en[1]=1 */
	writel(0x00000001, &dmc->rdlvl_config);
	/* Wait DMC.rdlvl_complete_ch0/1 */
	while((readl(&dmc->phystatus) & 0xC000) != 0xC000);
	/* ctrl_rdlvl_data_en[1]=0 */
	writel(0x00000000, &dmc->rdlvl_config);

	/* ctrl_pulld_dq[11:8]=0x0, ctrl_pulld_dqs[3:0]=0x0 */
	writel(0x00000000, &phy0_ctrl->phy_con14);
	writel(0x00000000, &phy1_ctrl->phy_con14);

	/* ctrl_force[14:8], ctrl_start[6]=1, ctrl_dll_on[5]=1 */
	writel(0x10101970, &phy0_ctrl->phy_con12);
	writel(0x10101970, &phy1_ctrl->phy_con12);
	sdelay(100);

	/* ctrl_shgate[29]=1, fp_resync[3]=1 */
	writel(0xE0000008, &dmc->phycontrol0);
	writel(0xE0000000, &dmc->phycontrol0);

	/* Issue the PALL command to memory */
	writel(0x01000000, &dmc->directcmd);
	writel(0x01100000, &dmc->directcmd);
	writel(0x11000000, &dmc->directcmd);
	writel(0x11100000, &dmc->directcmd);
#endif

	/* bl[22:20]=8, mem_type[11:8]=7, dsref_en[5]=1, */
	/* dpwrdn_en[1]=1, clk_stop_en[0]=1 */
	writel(0x00302620, &dmc->memcontrol);
	/* dfi_init_start[28]=1, rd_fetch[14:12]=3, aref_en[5]=1 */
	writel((0x0FFF0020 | (0x3 << 12)), &dmc->concontrol);
}
#endif

void mem_ctrl_init()
{
	struct exynos5_dmc *dmc = (struct exynos5_dmc *)EXYNOS5_DMC_CTRL_BASE;
#if defined(CONFIG_LPDDR3)
	mem_ctrl_init_lpddr3();
#else
	mem_ctrl_init_ddr3();
#endif

#if defined(CONFIG_DMC_BRB)
	/* DMC BRB QoS */
	writel(0x66668666, &dmc->brbrsvconfig);
	writel(0xFF, &dmc->brbrsvcontrol);
	writel(0x1, &dmc->brbqosconfig);

	/* DMC FBM */
	writel(0x0, DDR_R1_FBM_BASE + FBM_MODESEL0);
	writel(0x4, DDR_R1_FBM_BASE + FBM_THRESHOLDSEL0);
	writel(0x2, DDR_R0_FBM_BASE + FBM_MODESEL0);
	writel(0x1, DDR_R0_FBM_BASE + FBM_THRESHOLDSEL0);
#endif
}
