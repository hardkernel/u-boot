
int pwm_voltage_table[31][2] = {
	{ 0x10f001b,  860},
	{ 0x1050025,  870},
	{ 0x0fc002e,  880},
	{ 0x0f30037,  890},
	{ 0x0ea0040,  900},
	{ 0x0e10049,  910},
	{ 0x0d60054,  920},
	{ 0x0cb005f,  930},
	{ 0x0c0006a,  940},
	{ 0x0b50075,  950},
	{ 0x0aa0080,  960},
	{ 0x0a0008a,  970},
	{ 0x0960094,  980},
	{ 0x08d009d,  990},
	{ 0x07b00af, 1000},
	{ 0x07200b8, 1010},
	{ 0x06900c1, 1020},
	{ 0x06000ca, 1030},
	{ 0x05700d3, 1040},
	{ 0x04e00dc, 1050},
	{ 0x04500e5, 1060},
	{ 0x03c00ee, 1070},
	{ 0x03300f7, 1080},
	{ 0x02a0100, 1090},
	{ 0x0180109, 1100},
	{ 0x00f011b, 1110},
	{ 0x00a0120, 1120},
	{ 0x0050125, 1130},
	{ 0x000012a, 1140}
};

struct scpi_opp_entry cpu_dvfs_tbl[] = {
	DVFS( 100000000,  870),
	DVFS( 250000000,  870),
	DVFS( 500000000,  870),
	DVFS(1000000000,  990),
	DVFS(1296000000, 1100),
	DVFS(1536000000, 1100),
	DVFS(1656000000, 1100),
	DVFS(1680000000, 1100),
	DVFS(1752000000, 1100),
	DVFS(1896000000, 1100),
	DVFS(1920000000, 1100),
	DVFS(1944000000, 1100),
	DVFS(2016000000, 1100),
};



#define P_PIN_MUX_REG3		(*((volatile unsigned *)(0xda834400 + (0x2f << 2))))
#define P_PIN_MUX_REG7		(*((volatile unsigned *)(0xda834400 + (0x33 << 2))))
#define P_PWM_MISC_REG_AB	(*((volatile unsigned *)(0xc1100000 + (0x2156 << 2))))
#define P_PWM_PWM_B		(*((volatile unsigned *)(0xc1100000 + (0x2155 << 2))))

enum pwm_id {
	pwm_a = 0,
	pwm_b,
	pwm_c,
	pwm_d,
	pwm_e,
	pwm_f,
};


void pwm_init(int id)
{
	/*
	 * TODO: support more pwm controllers, right now only support PWM_B
	 */
	unsigned int reg;

	reg = P_PWM_MISC_REG_AB;
	reg &= ~(0x7f << 16);
	reg |=  ((1 << 23) | (1 << 1));
	P_PWM_MISC_REG_AB = reg;
	/*
	 * default set to max voltage
	 */
	P_PWM_PWM_B = pwm_voltage_table[ARRAY_SIZE(pwm_voltage_table) - 1][0];

	reg  = P_PIN_MUX_REG7;
	reg &= ~(1 << 22);
	P_PIN_MUX_REG7 = reg;

	reg  = P_PIN_MUX_REG3;
	reg &= ~(1 << 22);
	reg |=  (1 << 21);		// enable PWM_B
	P_PIN_MUX_REG3 = reg;

	_udelay(200);
}

int dvfs_get_voltage(void)
{
	int i = 0;
	unsigned int reg_val;

	reg_val = P_PWM_PWM_B;
	for (i = 0; i < ARRAY_SIZE(pwm_voltage_table); i++) {
		if (pwm_voltage_table[i][0] == reg_val) {
			return i;
		}
	}
	if (i >= ARRAY_SIZE(pwm_voltage_table)) {
	    return -1;
	}
	return -1;
}

void set_dvfs(unsigned int domain, unsigned int index)
{
	int cur, to;
	static int init_flag = 0;

	if (!init_flag) {
		pwm_init(pwm_b);
		init_flag = 1;
	}
	cur = dvfs_get_voltage();
	for (to = 0; to < ARRAY_SIZE(pwm_voltage_table); to++) {
		if (pwm_voltage_table[to][1] >= cpu_dvfs_tbl[index].volt_mv) {
			break;
		}
	}
	if (to >= ARRAY_SIZE(pwm_voltage_table)) {
		to = ARRAY_SIZE(pwm_voltage_table) - 1;
	}
	if (cur < 0 || cur >=ARRAY_SIZE(pwm_voltage_table)) {
		P_PWM_PWM_B = pwm_voltage_table[to][0];
		_udelay(200);
		return ;
	}
	while (cur != to) {
		/*
		 * if target step is far away from current step, don't change
		 * voltage by one-step-done. You should change voltage step by
		 * step to make sure voltage output is stable
		 */
		if (cur < to) {
			if (cur < to - 3) {
				cur += 3;
			} else {
				cur = to;
			}
		} else {
			if (cur > to + 3) {
				cur -= 3;
			} else {
				cur = to;
			}
		}
		P_PWM_PWM_B = pwm_voltage_table[cur][0];
		_udelay(100);
	}
	_udelay(200);
}

