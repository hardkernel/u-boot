#ifdef CONFIG_CEC_WAKEUP
#include <cec_tx_reg.h>
#endif
#include <gpio-gxbb.h>

static void power_off_at_clk81(void)
{
}
static void power_on_at_clk81(void)
{
}

static void power_off_at_24M(void)
{
}
static void power_on_at_24M(void)
{
}

static void power_off_at_32k(void)
{
}
static void power_on_at_32k(void)
{
}

void get_wakeup_source(void *response, unsigned int suspend_from)
{
	struct wakeup_info *p = (struct wakeup_info *)response;
	unsigned val;

	p->status = RESPONSE_OK;
	val = REMOTE_WAKEUP_SRC;
#ifdef CONFIG_CEC_WAKEUP
	if (suspend_from != SYS_POWEROFF)
		val |= CEC_WAKEUP_SRC;
#endif
	p->sources = val;
	p->gpio_info_count = 0;
}

static unsigned int detect_key(unsigned int suspend_from)
{
	int exit_reason = 0;
	unsigned *irq = (unsigned *)SECURE_TASK_SHARE_IRQ;
	/* unsigned *wakeup_en = (unsigned *)SECURE_TASK_RESPONSE_WAKEUP_EN; */

	/* setup wakeup resources*/
	init_remote();
#ifdef CONFIG_CEC_WAKEUP
	if (hdmi_cec_func_config & 0x1) {
		remote_cec_hw_reset();
		cec_node_init();
	}
#endif

	/* *wakeup_en = 1;*/
	do {
		switch (*irq) {
#ifdef CONFIG_CEC_WAKEUP
		case IRQ_AO_CEC_NUM:
			if (suspend_from == SYS_POWEROFF)
				break;
			if (cec_msg.log_addr) {
				if (hdmi_cec_func_config & 0x1) {
					cec_handler();
					if (cec_msg.cec_power == 0x1) {
						/*cec power key*/
						exit_reason = CEC_WAKEUP;
						break;
					}
				}
			} else if (hdmi_cec_func_config & 0x1)
				cec_node_init();
		break;
#endif
		case IRQ_AO_IR_DEC_NUM:
			if (remote_detect_key())
				exit_reason = REMOTE_WAKEUP;
			break;
		default:
			break;
		}
		*irq = 0xffffffff;
		if (exit_reason)
			break;
		else
			asm volatile("wfi");
	} while (1);

	return exit_reason;
}

static void pwr_op_init(struct pwr_op *pwr_op)
{
	pwr_op->power_off_at_clk81 = power_off_at_clk81;
	pwr_op->power_on_at_clk81 = power_on_at_clk81;
	pwr_op->power_off_at_24M = power_off_at_24M;
	pwr_op->power_on_at_24M = power_on_at_24M;
	pwr_op->power_off_at_32k = power_off_at_32k;
	pwr_op->power_on_at_32k = power_on_at_32k;

	pwr_op->detect_key = detect_key;
	pwr_op->get_wakeup_source = get_wakeup_source;
}
