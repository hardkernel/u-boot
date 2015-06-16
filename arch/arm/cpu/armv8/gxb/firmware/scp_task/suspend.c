#include "config.h"
#include "registers.h"
#include "task_apis.h"
#include "suspend.h"
#include <pwr_ctrl.c>
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

void enter_suspend(void)
{
	int exit_reason = REMOTE_WAKEUP;
	int suspend_from = 0;
	p_pwr_op = &pwr_op_d;
	pwr_op_init(p_pwr_op);
	p_pwr_op->power_off_3v3();
	p_pwr_op->power_off_5v();
	p_pwr_op->power_off_vcck();
	exit_reason = p_pwr_op->detect_key(suspend_from);
	write_flag(exit_reason);
	p_pwr_op->power_on_vcck();
	p_pwr_op->power_on_5v();
	p_pwr_op->power_on_3v3();
}
