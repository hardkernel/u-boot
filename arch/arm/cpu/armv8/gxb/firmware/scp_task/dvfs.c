#include "config.h"
#include "registers.h"
#include "task_apis.h"

struct scpi_opp_entry {
	unsigned int freq_hz;
	unsigned int volt_mv;
};
#define DVFS(_freq, _volt) \
{ \
	.freq_hz = _freq, \
	.volt_mv = _volt, \
}

static int pwm_voltage_table[][2] = {
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
	DVFS(100000000, 1050),
	DVFS(250000000, 1050),
	DVFS(500000000, 1050),
	DVFS(1032000000, 1050),
	DVFS(1296000000, 1140),
	DVFS(1536000000, 1140),
	DVFS(1752000000, 1140),
	DVFS(2016000000, 1140),
};
static void *memcpy(void *dest, const void *src, unsigned int count)
{
	char *tmp = dest;
	const char *s = src;

	while (count--)
		*tmp++ = *s++;
	return dest;
}
static void *memset(void *s, int c, unsigned int count)
{
	char *xs = s;

	while (count--)
		*xs++ = c;
	return s;
}

#define SCPI_SUCCESS 0
#define MAX_DVFS_OPPS		16
#define DVFS_LATENCY(hdr)	((hdr) << 16)
#define DVFS_OPP_COUNT(hdr)	((hdr) << 8)
struct scpi_opp {
	unsigned int latency; /* in usecs */
	int count;
	struct scpi_opp_entry opp[MAX_DVFS_OPPS];
} buf_opp;

#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))

void get_dvfs_info(unsigned int domain,
		unsigned char *info_out, unsigned int *size_out)
{
	unsigned int cnt = ARRAY_SIZE(cpu_dvfs_tbl);
	buf_opp.latency = 200;
	buf_opp.count = cnt;
	memset(&buf_opp.opp[0], 0, MAX_DVFS_OPPS * sizeof(struct scpi_opp_entry));
	memcpy(&buf_opp.opp[0], cpu_dvfs_tbl , cnt *sizeof(struct scpi_opp_entry));

	memcpy(info_out, &buf_opp, sizeof(struct scpi_opp));
	*size_out = sizeof(struct scpi_opp);
	return;
}
#define writel(v, addr) (*((unsigned *)addr) = v)
#define readl(addr) (*((unsigned *)addr))

#define P_PIN_MUX_REG3		(*((volatile unsigned *)(0xda834400 + (0x2f << 2))))
#define P_PIN_MUX_REG7		(*((volatile unsigned *)(0xda834400 + (0x33 << 2))))
#define P_PWM_MISC_REG_AB	(*((volatile unsigned *)(0xc1100000 + (0x2156 << 2))))
#define P_PWM_PWM_B		(*((volatile unsigned *)(0xc1100000 + (0x2155 << 2))))
#define P_EE_TIMER_E		(*((volatile unsigned *)(0xc1100000 + (0x2662 << 2))))

enum pwm_id {
	pwm_a = 0,
	pwm_b,
	pwm_c,
	pwm_d,
	pwm_e,
	pwm_f,
};

unsigned int get_time(void)
{
	return P_EE_TIMER_E;
}

void _udelay(unsigned int us)
{
	unsigned int t0 = get_time();

	while (get_time() - t0 <= us)
		;
}

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
}
