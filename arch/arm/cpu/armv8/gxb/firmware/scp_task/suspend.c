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

void switch_to_32k(void)
{
	aml_update_bits(AO_RTI_PWR_CNTL_REG0, 0x7<<2, 0x4<<2);
	aml_update_bits(AO_RTI_PWR_CNTL_REG0, 0x1<<0, 0x1<<0);
}

void switch_to_clk81(void)
{
	aml_update_bits(AO_RTI_PWR_CNTL_REG0, 0x1<<0, 0);
}
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

	switch_to_32k();
	gxbb_com_gate_off();
	p_pwr_op->power_off_at_32k();
	exit_reason = p_pwr_op->detect_key(suspend_from);
	p_pwr_op->power_on_at_32k();
	gxbb_com_gate_on();
	switch_to_clk81();
	uart_puts("exit_reason:0x");
	uart_put_hex(exit_reason, 8);
	uart_puts("\n");
	set_wakeup_method(exit_reason);
	p_pwr_op->power_on_at_24M();
	p_pwr_op->power_on_at_clk81();
}
