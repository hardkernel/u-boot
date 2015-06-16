
static void power_off_3v3(void)
{

}
static void power_on_3v3(void)
{

}

static void power_off_5v(void)
{

}
static void power_on_5v(void)
{

}
static void power_off_vcck(void)
{

}
static void power_on_vcck(void)
{

}

static void power_off_ddr(void)
{

}
static void power_on_ddr(void)
{

}

unsigned int detect_key(unsigned int suspend_from)
{

	int exit_reason = 0;
	do {
		if (remote_detect_key()) {
			exit_reason = REMOTE_WAKEUP;
			break;
		}
	} while (1);
	return exit_reason;
}

static void pwr_op_init(struct pwr_op *pwr_op)
{
	pwr_op->power_off_3v3 = power_off_3v3;
	pwr_op->power_on_3v3 = power_on_3v3;
	pwr_op->power_off_5v = power_off_5v;
	pwr_op->power_on_5v = power_on_5v;
	pwr_op->power_off_vcck = power_off_vcck;
	pwr_op->power_on_vcck = power_on_vcck;
	pwr_op->power_off_ddr = power_off_ddr;
	pwr_op->power_on_ddr = power_on_ddr;
	pwr_op->detect_key = detect_key;
}

