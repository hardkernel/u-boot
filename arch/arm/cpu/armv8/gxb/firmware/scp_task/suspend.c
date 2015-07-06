#include "config.h"
#include "registers.h"
#include "task_apis.h"
#include "suspend.h"
unsigned int time;

#include <pwr_ctrl.c>
#include <hdmi_cec_arc.c>
static struct pwr_op pwr_op_d;
static struct pwr_op *p_pwr_op;

static void write_flag(unsigned int flag)
{
	unsigned int val;
	val = readl(SEC_AO_SEC_SD_CFG15);
	val = val & (~(0xf << 28));
	val = val | (flag << 28);
	writel(val, SEC_AO_SEC_SD_CFG15);
}
void switch_to_32k(void)
{
	aml_update_bits(AO_RTI_PWR_CNTL_REG0, 0x7<<2, 0x4<<2);
	aml_update_bits(AO_RTI_PWR_CNTL_REG0, 0x1<<0, 0x1<<0);
}

void switch_to_clk81(void)
{
	aml_update_bits(AO_RTI_PWR_CNTL_REG0, 0x1<<0, 0);
}

void enter_suspend(void)
{
	int exit_reason = UDEFINED_WAKEUP;
	int suspend_from = 0;
	p_pwr_op = &pwr_op_d;
	pwr_op_init(p_pwr_op);
#ifdef CONFIG_CEC_WAKEUP
	hdmi_cec_func_config = readl(P_AO_DEBUG_REG0);
	uart_puts("CEC cfg:0x");
	uart_put_hex(hdmi_cec_func_config, 16);
	uart_puts("\n");
#endif
	p_pwr_op->power_off_at_clk81();
	p_pwr_op->power_off_at_24M();

	switch_to_32k();
	p_pwr_op->power_off_at_32k();
	exit_reason = p_pwr_op->detect_key(suspend_from);
	p_pwr_op->power_on_at_32k();

	switch_to_clk81();
	uart_puts("exit_reason:0x");
	uart_put_hex(exit_reason, 8);
	uart_puts("\n");
	write_flag(exit_reason);
	p_pwr_op->power_on_at_24M();
	p_pwr_op->power_on_at_clk81();
}
