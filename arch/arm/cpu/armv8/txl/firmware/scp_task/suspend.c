
/*
 * arch/arm/cpu/armv8/txl/firmware/scp_task/suspend.c
 *
 * Copyright (C) 2015 Amlogic, Inc. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

#include "config.h"
#include "registers.h"
#include "task_apis.h"
#include "suspend.h"
unsigned int time;
#include <scp_remote.c>

#include <pwr_ctrl.c>
#include <hdmi_cec_arc.c>

static struct pwr_op pwr_op_d;
static struct pwr_op *p_pwr_op;

static void gxbb_com_gate_off(void)
{
	/* gate off fix_clk_div2*/
	aml_update_bits(HHI_MPLL_CNTL6, 1<<27, 0);
	/* gate off fix_clk_div4*/
	aml_update_bits(HHI_MPLL_CNTL6, 1<<29, 0);
	/* gate off fix_clk_div5*/
	aml_update_bits(HHI_MPLL_CNTL6, 1<<30, 0);
	/* gate off fix_clk_div7*/
	aml_update_bits(HHI_MPLL_CNTL6, 1<<31, 0);
	/* switch vpu to fclk_div4 */
	aml_update_bits(HHI_VPU_CLK_CNTL, 7 << 9, 0);
	/* gate off mpll 0 ~ 3 */
	aml_update_bits(HHI_MPLL_CNTL7, 1 << 15, 0);
	aml_update_bits(HHI_MPLL_CNTL8, 1 << 15, 0);
	aml_update_bits(HHI_MPLL_CNTL9, 1 << 15, 0);
	aml_update_bits(HHI_MPLL3_CNTL0, 1 << 10, 0);
}
static void gxbb_com_gate_on(void)
{
	/* gate on mpll 0 ~ 3 */
	aml_update_bits(HHI_MPLL_CNTL7, 1 << 15, 1 << 15);
	aml_update_bits(HHI_MPLL_CNTL8, 1 << 15, 1 << 15);
	aml_update_bits(HHI_MPLL_CNTL9, 1 << 15, 1 << 15);
	aml_update_bits(HHI_MPLL3_CNTL0, 1 << 10, 1 << 10);
	/* switch vpu to fclk_div3 */
	aml_update_bits(HHI_VPU_CLK_CNTL, 7 << 9, 1 << 9);
	/* gate on fix_clk_div2*/
	aml_update_bits(HHI_MPLL_CNTL6, 1<<27, 1<<27);
	/* gate on fix_clk_div4*/
	aml_update_bits(HHI_MPLL_CNTL6, 1<<29, 1<<29);
	/* gate on fix_clk_div5*/
	aml_update_bits(HHI_MPLL_CNTL6, 1<<30, 1<<30);
	/* gate on fix_clk_div7*/
	aml_update_bits(HHI_MPLL_CNTL6, 1<<31, 1<<31);
}

void suspend_pwr_ops_init(void)
{
	p_pwr_op = &pwr_op_d;
	pwr_op_init(p_pwr_op);
}

void suspend_get_wakeup_source(void *response, unsigned int suspend_from)
{
	if (!p_pwr_op->get_wakeup_source)
		return;
	p_pwr_op->get_wakeup_source(response, suspend_from);
}

/*
 *suspend_from defines who call this function.
 * 1: suspend
 * 0: power off
*/
void enter_suspend(unsigned int suspend_from)
{
	int exit_reason = UDEFINED_WAKEUP;
#ifdef CONFIG_CEC_WAKEUP
	hdmi_cec_func_config = readl(P_AO_DEBUG_REG0);
	uart_puts("CEC cfg:0x");
	uart_put_hex(hdmi_cec_func_config, 16);
	uart_puts("\n");
#endif
	p_pwr_op->power_off_at_clk81();
	p_pwr_op->power_off_at_24M();

	gxbb_com_gate_off();
	p_pwr_op->power_off_at_32k();
	exit_reason = p_pwr_op->detect_key(suspend_from);
	p_pwr_op->power_on_at_32k();
	gxbb_com_gate_on();
	uart_puts("exit_reason:0x");
	uart_put_hex(exit_reason, 8);
	uart_puts("\n");
	set_wakeup_method(exit_reason);
	p_pwr_op->power_on_at_24M();
	p_pwr_op->power_on_at_clk81();
}
