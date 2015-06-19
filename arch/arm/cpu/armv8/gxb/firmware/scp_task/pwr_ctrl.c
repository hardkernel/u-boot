/*p200/201	GPIOAO_2  powr on	:0, power_off	:1*/

static void power_off_3v3(void)
{
	aml_update_bits(AO_GPIO_O_EN_N, 1<<2, 0);
	aml_update_bits(AO_GPIO_O_EN_N, 1<<18, 1<<18);
}
static void power_on_3v3(void)
{
	aml_update_bits(AO_GPIO_O_EN_N, 1<<2, 0);
	aml_update_bits(AO_GPIO_O_EN_N, 1<<18, 0);
}

static void power_off_5v(void)
{

}
static void power_on_5v(void)
{

}
/*p200/201	GPIOAO_4  powr on	:1, power_off	:0*/
static void power_off_vcck(void)
{
	aml_update_bits(AO_GPIO_O_EN_N, 1<<4, 0);
	aml_update_bits(AO_GPIO_O_EN_N, 1<<20, 0);
}
static void power_on_vcck(void)
{
	aml_update_bits(AO_GPIO_O_EN_N, 1<<4, 0);
	aml_update_bits(AO_GPIO_O_EN_N, 1<<20, 1<<20);
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

