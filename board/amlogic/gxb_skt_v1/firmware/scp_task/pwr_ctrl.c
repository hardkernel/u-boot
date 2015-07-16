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


static unsigned int detect_key(unsigned int suspend_from)
{
	int exit_reason = 0;
	init_remote();
#ifdef CONFIG_CEC_WAKEUP
	if (hdmi_cec_func_config & 0x1) {
		remote_cec_hw_reset();
		cec_node_init();
	}
#endif
	do {
	#ifdef CONFIG_CEC_WAKEUP
		if (cec_msg.log_addr) {
			if (hdmi_cec_func_config & 0x1) {
				cec_handler();
				if (cec_msg.cec_power == 0x1) {  //cec power key
					exit_reason = CEC_WAKEUP;
					break;
				}
			}
		} else if (hdmi_cec_func_config & 0x1) {
			cec_node_init();
		}
	#endif
		if (remote_detect_key()) {
			exit_reason = REMOTE_WAKEUP;
			break;
		}
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
}
