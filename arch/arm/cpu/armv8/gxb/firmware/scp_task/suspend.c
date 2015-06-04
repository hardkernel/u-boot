#include "config.h"
#include "registers.h"
#include "task_apis.h"

#define	UDEFINED_WAKEUP	0
#define	CHARGING_WAKEUP	1
#define	REMOTE_WAKEUP		2
#define	RTC_WAKEUP			3
#define	BT_WAKEUP			4
#define	WIFI_WAKEUP			5
#define	POWER_KEY_WAKEUP	6
#define writel(val, reg) (*((volatile unsigned *)(reg))) = (val)
#define readl(reg)		(*((volatile unsigned *)(reg)))

static void write_flag(unsigned int flag)
{
	unsigned int val;
	val = readl(SEC_AO_SEC_SD_CFG15);
	val = val & (~(0xf << 28));
	val = val | (flag << 28);
	writel(val, SEC_AO_SEC_SD_CFG15);
}
static int detect_key(void)
{
	int exit_reason = 0;
	do {
		if (remote_detect_key()) {
			exit_reason = 0;
			write_flag(REMOTE_WAKEUP);
			break;
		}
	} while (1);
	return exit_reason;
}

void enter_suspend(void)
{
	detect_key();
}
