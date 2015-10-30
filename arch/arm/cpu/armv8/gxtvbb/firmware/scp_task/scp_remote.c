#include "config.h"
#include "registers.h"
#include "task_apis.h"

enum{
	DECODEMODE_NEC = 0,
	DECODEMODE_DUOKAN = 1,
	DECODEMODE_RCMM ,
	DECODEMODE_SONYSIRC,
	DECODEMODE_SKIPLEADER ,
	DECODEMODE_MITSUBISHI,
	DECODEMODE_THOMSON,
	DECODEMODE_TOSHIBA,
	DECODEMODE_RC5,
	DECODEMODE_RC6,
	DECODEMODE_COMCAST,
	DECODEMODE_SANYO,
	DECODEMODE_MAX
};

#define IR_POWER_KEY_MASK 0xffffffff
static unsigned int kk[] = {
	0xe51afb04,
};
static int init_remote(void)
{
	uart_put_hex(readl(AO_IR_DEC_STATUS), 32);
	uart_put_hex(readl(AO_IR_DEC_FRAME), 32);
	return 0;
}

static int remote_detect_key(void)
{
	unsigned power_key;
	if (((readl(AO_IR_DEC_STATUS))>>3) & 0x1) {
		power_key = readl(AO_IR_DEC_FRAME);
		if ((power_key&IR_POWER_KEY_MASK) == kk[DECODEMODE_NEC])
			return 1;

	}
	return 0;
}
