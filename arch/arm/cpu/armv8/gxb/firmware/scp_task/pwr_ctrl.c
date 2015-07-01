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

static void power_off_at_clk81(void)
{
	power_off_3v3();
	power_off_vcck();
}
static void power_on_at_clk81(void)
{
	power_on_vcck();
	power_on_3v3();
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

unsigned int detect_key(unsigned int suspend_from)
{

	int exit_reason = 0;
	unsigned int time_out = readl(AO_DEBUG_REG2);
	unsigned int init_time = get_time();
	init_remote();
	do {
		if (time_out != 0) {
			if ((get_time() - init_time) >= time_out * 1000 * 1000) {
				exit_reason = AUTO_WAKEUP;
				break;
			}
		}
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

