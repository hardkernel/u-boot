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

/* wake up source*/
#define UDEFINED_WAKEUP_SRC	(1<<0)
#define CHARGING_WAKEUP_SRC (1<<1)
#define REMOTE_WAKEUP_SRC (1<<2)
#define RTC_WAKEUP_SRC	(1<<3)
#define BT_WAKEUP_SRC	(1<<4)
#define WIFI_WAKEUP_SRC	(1<<5)
#define POWER_KEY_WAKEUP_SRC	(1<<6)
#define AUTO_WAKEUP_SRC	(1<<7)
#define CEC_WAKEUP_SRC	(1<<8)

struct pwr_op {
	void (*power_off_at_clk81)(void);
	void (*power_on_at_clk81)(unsigned int);

	void (*power_off_at_24M)(void);
	void (*power_on_at_24M)(void);

	void (*power_off_at_32k)(unsigned int);
	void (*power_on_at_32k)(unsigned int);

	void (*shut_down)(void);

	unsigned int (*detect_key)(unsigned int);
	void (*get_wakeup_source)(void *, unsigned int);
};
static void inline aml_update_bits(unsigned int  reg, unsigned int mask, unsigned int val)
{
	unsigned int tmp, orig;
	orig = readl(reg);
	tmp = orig & ~mask;
	tmp |= val & mask;
	writel(tmp, reg);
}

#define IRQ_TIMERA_NUM      1
#define IRQ_GPIO0_NUM       8
#define IRQ_GPIO1_NUM       9
#define IRQ_AO_IR_DEC_NUM   42
#define IRQ_AO_CEC_NUM      45
#define IRQ_AO_GPIO0_NUM    46

/* GPIO trigger type*/
#define GPIO_IRQ_LOW_LEVEL		0
#define GPIO_IRQ_HIGH_LEVEL		1
#define GPIO_IRQ_FALLING_EDGE	2
#define GPIO_IRQ_RISING_EDGE		3

enum {
	IRQ_TIMERA = 0,
	IRQ_GPIO0,
	IRQ_GPIO1,
	IRQ_GPIO2,
	IRQ_GPIO3,
	IRQ_AO_IR_DEC,
	IRQ_AO_CEC,
	IRQ_AO_GPIO0,
	IRQ_AO_GPIO1,
	IRQ_AO_TIMERA,
	WAKE_UP_MAX = 32,
};

/* M3 CPU has 2 ao-gpio-irq, 4 gpio-irq*/
#define GPIO_WAKEUP_MAX		6
struct wakeup_gpio_info {
	int wakeup_id;
	int gpio_in_idx;
	int gpio_in_ao;
	int gpio_out_idx;
	int gpio_out_ao;
	int irq;
	int trig_type;
};
struct wakeup_info {
	unsigned status;
	unsigned sources;
	unsigned gpio_info_count;
	struct wakeup_gpio_info gpio_info[GPIO_WAKEUP_MAX];
};

#define DIRECTION_IN		1
#define DIRECTION_OUT	0

#define SYS_SUSPEND 1
#define SYS_POWEROFF 0

#endif
