#ifndef __SCP_SUSPEND_H_
#define __SCP_SUSPEND_H_
/* wake up reason*/
#define	UDEFINED_WAKEUP	0
#define	CHARGING_WAKEUP	1
#define	REMOTE_WAKEUP		2
#define	RTC_WAKEUP			3
#define	BT_WAKEUP			4
#define	WIFI_WAKEUP			5
#define	POWER_KEY_WAKEUP	6
#define	AUTO_WAKEUP			7
#define CEC_WAKEUP		8

struct pwr_op {
	void (*power_off_at_clk81)(void);
	void (*power_on_at_clk81)(void);

	void (*power_off_at_24M)(void);
	void (*power_on_at_24M)(void);

	void (*power_off_at_32k)(void);
	void (*power_on_at_32k)(void);

	void (*shut_down)(void);

	unsigned int (*detect_key)(unsigned int);
};
static void inline aml_update_bits(unsigned int  reg, unsigned int mask, unsigned int val)
{
	unsigned int tmp, orig;
	orig = readl(reg);
	tmp = orig & ~mask;
	tmp |= val & mask;
	writel(tmp, reg);
}

#endif


