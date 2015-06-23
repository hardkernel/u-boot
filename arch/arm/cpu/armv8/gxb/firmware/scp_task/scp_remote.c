#include "config.h"
#include "registers.h"
#include "task_apis.h"
#undef	P_AO_IR_DEC_STATUS
#undef	P_AO_IR_DEC_FRAME
#define   P_AO_IR_DEC_STATUS                   (0xc8100400 + (0x26 << 2))
#define   P_AO_IR_DEC_FRAME                    (0xc8100400 + (0x25 << 2))

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
unsigned int kk[] = {
	0xe51afb04,
};
void init_remote(void)
{
	unsigned int val;
	val = readl(P_AO_IR_DEC_FRAME);
	return;
}

int remote_detect_key(void)
{
	unsigned power_key;
	if (((readl(P_AO_IR_DEC_STATUS))>>3) & 0x1) {
		power_key = readl(P_AO_IR_DEC_FRAME);
		if ((power_key&IR_POWER_KEY_MASK) == kk[DECODEMODE_NEC])
			return 1;

	}
	return 0;
}
