
int pwm_voltage_table[][2] = {
	{ 0x1c0000,  860},
	{ 0x1b0001,  870},
	{ 0x1a0002,  880},
	{ 0x190003,  890},
	{ 0x180004,  900},
	{ 0x170005,  910},
	{ 0x160006,  920},
	{ 0x150007,  930},
	{ 0x140008,  940},
	{ 0x130009,  950},
	{ 0x12000a,  960},
	{ 0x11000b,  970},
	{ 0x10000c,  980},
	{ 0x0f000d,  990},
	{ 0x0e000e, 1000},
	{ 0x0d000f, 1010},
	{ 0x0c0010, 1020},
	{ 0x0b0011, 1030},
	{ 0x0a0012, 1040},
	{ 0x090013, 1050},
	{ 0x080014, 1060},
	{ 0x070015, 1070},
	{ 0x060016, 1080},
	{ 0x050017, 1090},
	{ 0x040018, 1100},
	{ 0x030019, 1110},
	{ 0x02001a, 1120},
	{ 0x01001b, 1130},
	{ 0x00001c, 1140}
};

struct scpi_opp_entry cpu_dvfs_tbl[] = {
	DVFS( 100000000,  860+50),
	DVFS( 250000000,  860+50),
	DVFS( 500000000,  860+50),
	DVFS( 667000000,  900+50),
	DVFS(1000000000,  940+50),
	DVFS(1200000000, 1020+50),
	DVFS(1512000000, 1110+30),
};
struct scpi_opp_entry vlittle_dvfs_tbl[] = {
	DVFS( 100000000,  860+50),
	DVFS( 250000000,  860+50),
	DVFS( 500000000,  860+50),
	DVFS( 667000000,  900+50),
	DVFS(1000000000,  940+50),
};



#define P_PIN_MUX_REG1         (*((volatile unsigned *)(0xda834400 + (0x2d << 2))))
#define P_PIN_MUX_REG2         (*((volatile unsigned *)(0xda834400 + (0x2e << 2))))

#define P_PWM_MISC_REG_CD	(*((volatile unsigned *)(0xc1100000 + (0x2192 << 2))))
#define P_PWM_PWM_D		(*((volatile unsigned *)(0xc1100000 + (0x2191 << 2))))

#define P_PWM_MISC_REG_EF	(*((volatile unsigned *)(0xc1100000 + (0x21b2 << 2))))
#define P_PWM_PWM_F		(*((volatile unsigned *)(0xc1100000 + (0x21b1 << 2))))

#undef P_AO_PWM_MISC_REG_AB
#undef P_AO_PWM_PWM_A
#define P_AO_PWM_MISC_REG_AB	(*((volatile unsigned *)(0xc8100400 + (0x56 << 2))))
#define P_AO_PWM_PWM_A (*((volatile unsigned *)(0xc8100400 + (0x54 << 2))))

#define P_EE_TIMER_E		(*((volatile unsigned *)(0xc1100000 + (0x2662 << 2))))

#define P_PIN_MUX_AO_REG	(*((volatile unsigned *)(0xc8100000 + (0x5 << 2))))
#define P_PIN_MUX_REG8		(*((volatile unsigned *)(0xda834400 + (0x34 << 2))))
enum pwm_id {
    pwm_a = 0,
    pwm_b,
    pwm_c,
    pwm_d,
    pwm_e,
    pwm_f,
    pwm_ao_a,
};

unsigned int _get_time(void)
{
	return P_EE_TIMER_E;
}

void _udelay_(unsigned int us)
{
	unsigned int t0 = _get_time();

	while (_get_time() - t0 <= us)
		;
}

void pwm_init(int id)
{
	unsigned int reg;

	/*
	 * TODO: support more pwm controllers, right now only support
	 * PWM_B, PWM_D
	 */

	switch (id) {
	case pwm_ao_a:
		reg = P_AO_PWM_MISC_REG_AB;
		reg &= ~(0x7f << 8);
		reg |=  ((1 << 15) | (1 << 0));
		P_AO_PWM_MISC_REG_AB = reg;
		/*
		 * default set to max voltage
		 */
		P_AO_PWM_PWM_A = pwm_voltage_table[ARRAY_SIZE(pwm_voltage_table) - 1][0];
		reg  = P_PIN_MUX_AO_REG;
		reg &= ~(1 << 9);
		reg &= ~(1 << 7);
		P_PIN_MUX_AO_REG = reg;

		reg  = P_PIN_MUX_AO_REG;
		reg |=  (1 << 22);		// enable PWM_AO_A
		P_PIN_MUX_AO_REG = reg;
		break;

	case pwm_f:
		reg = P_PWM_MISC_REG_EF;
		reg &= ~(0x7f << 16);
		reg |=  ((1 << 23) | (1 << 1));
		P_PWM_MISC_REG_EF = reg;
		/*
		 * default set to max voltage
		 */
		P_PWM_PWM_F = pwm_voltage_table[ARRAY_SIZE(pwm_voltage_table) - 1][0];
		reg  = P_PIN_MUX_REG8;
		reg &= ~(1 << 29);
		P_PIN_MUX_REG8 = reg;

		reg  = P_PIN_MUX_REG8;
		reg |=  (1 << 30);		// enable PWM_F
		P_PIN_MUX_REG8 = reg;
		break;

	default:
		break;
	}

	_udelay_(200);
}
int dvfs_get_voltage(unsigned int domain)
{
	int i = 0;
	unsigned int reg_val = 0x040018;

	if (domain == 0)
		reg_val = P_AO_PWM_PWM_A;

	if (domain == 1)
		reg_val = P_PWM_PWM_F;

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
		pwm_init(pwm_f);
		pwm_init(pwm_ao_a);
		init_flag = 1;
	}
	cur = dvfs_get_voltage(domain);
	for (to = 0; to < ARRAY_SIZE(pwm_voltage_table); to++) {
		if (domain == 0) {
			if (pwm_voltage_table[to][1] >= cpu_dvfs_tbl[index].volt_mv) {
				break;
			}
		}
		if (domain == 1) {
			if (pwm_voltage_table[to][1] >= vlittle_dvfs_tbl[index].volt_mv) {
				break;
			}
		}
	}
	if (to >= ARRAY_SIZE(pwm_voltage_table)) {
		to = ARRAY_SIZE(pwm_voltage_table) - 1;
	}
	if (cur < 0 || cur >=ARRAY_SIZE(pwm_voltage_table)) {
		if (domain == 0)
			P_AO_PWM_PWM_A = pwm_voltage_table[to][0];
		if (domain == 1)
			P_PWM_PWM_F  = pwm_voltage_table[to][0];
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
		if (domain == 0)
			P_AO_PWM_PWM_A = pwm_voltage_table[cur][0];
		if (domain == 1)
			P_PWM_PWM_F  = pwm_voltage_table[to][0];
		_udelay(100);
	}
	_udelay(200);
}

void get_dvfs_info_board(unsigned int domain,
		unsigned char *info_out, unsigned int *size_out)
{
	unsigned int cnt;
	if (domain == 0)
		cnt = ARRAY_SIZE(cpu_dvfs_tbl);
	if (domain == 1)
		cnt = ARRAY_SIZE(vlittle_dvfs_tbl);

	buf_opp.latency = 200;
	buf_opp.count = cnt;
	memset(&buf_opp.opp[0], 0,
	       MAX_DVFS_OPPS * sizeof(struct scpi_opp_entry));

	if (domain == 0)
		memcpy(&buf_opp.opp[0], cpu_dvfs_tbl ,
			cnt * sizeof(struct scpi_opp_entry));

	if (domain == 1)
		memcpy(&buf_opp.opp[0], vlittle_dvfs_tbl ,
			cnt * sizeof(struct scpi_opp_entry));

	memcpy(info_out, &buf_opp, sizeof(struct scpi_opp));
	*size_out = sizeof(struct scpi_opp);
	return;
}
