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

typedef struct reg_remote {
	int reg;
	unsigned int val;
} reg_remote;
#define CONFIG_END 0xffffffff
#define IR_POWER_KEY_MASK 0xffffffff
#if 0
//32K
static const reg_remote RDECODEMODE_NEC[] = {
	{AO_MF_IR_DEC_LDR_ACTIVE, 350 << 16 | 260 << 0},
	{AO_MF_IR_DEC_LDR_IDLE, 200 << 16 | 120 << 0},
	{AO_MF_IR_DEC_LDR_REPEAT, 100 << 16 | 70 << 0},
	{AO_MF_IR_DEC_BIT_0, 50 << 16 | 20 << 0},
	{AO_MF_IR_DEC_REG0, 3 << 28 | (0xFA0 << 12)},
	{AO_MF_IR_DEC_STATUS, (100 << 20) | (45 << 10)},
	{AO_MF_IR_DEC_REG1, 0x600fdf00},
	{AO_MF_IR_DEC_REG2, 0x0},
	{AO_MF_IR_DEC_DURATN2, 0},
	{AO_MF_IR_DEC_DURATN3, 0},
	{CONFIG_END, 0}
};
#else
//24M
static const reg_remote RDECODEMODE_NEC[] = {
	{AO_MF_IR_DEC_LDR_ACTIVE, 477 << 16 | 400 << 0},
	{AO_MF_IR_DEC_LDR_IDLE, 248 << 16 | 202 << 0},
	{AO_MF_IR_DEC_LDR_REPEAT, 130 << 16 | 110 << 0},
	{AO_MF_IR_DEC_BIT_0, 60 << 16 | 48 << 0},
	{AO_MF_IR_DEC_REG0, 3 << 28 | (0xFA0 << 12) | 0x13},
	{AO_MF_IR_DEC_STATUS, (111 << 20) | (100 << 10)},
	{AO_MF_IR_DEC_REG1, 0x9f50},
	{AO_MF_IR_DEC_REG2, 0x0},
	{AO_MF_IR_DEC_DURATN2, 0},
	{AO_MF_IR_DEC_DURATN3, 0},
	{CONFIG_END, 0}
};
#endif

static const reg_remote *remoteregsTab[] = {
	RDECODEMODE_NEC,
};

void setremotereg(const reg_remote * r)
{
	writel(r->val, r->reg);
}

int set_remote_mode(int mode)
{
	const reg_remote *reg;
	reg = remoteregsTab[mode];
	while (CONFIG_END != reg->reg)
		setremotereg(reg++);
	return 0;
}

/*****************************************************************
**
** func : ir_remote_init
**       in this function will do pin configuration and and initialize for
**       IR Remote hardware decoder mode at 32kHZ on ARC.
**
********************************************************************/
static int ir_remote_init_32k_mode(void)
{
	//volatile unsigned int status,data_value;
	int val = readl(AO_RTI_PIN_MUX_REG);
	writel((val | (1 << 0)), AO_RTI_PIN_MUX_REG);
	set_remote_mode(DECODEMODE_NEC);
	//status = readl(AO_MF_IR_DEC_STATUS);
	uart_put_hex(readl(AO_MF_IR_DEC_STATUS), 32);
	//data_value = readl(AO_MF_IR_DEC_FRAME);
	uart_put_hex(readl(AO_MF_IR_DEC_FRAME), 32);

	//step 2 : request nec_remote irq  & enable it
	return 0;
}

void init_custom_trigger(void)
{
	ir_remote_init_32k_mode();
}

static unsigned int kk[] = {
	0x23dc4db2,
};
static int init_remote(void)
{
	//uart_put_hex(readl(AO_IR_DEC_STATUS), 32);
	//uart_put_hex(readl(AO_IR_DEC_FRAME), 32);
	init_custom_trigger();
	return 0;
}

static int remote_detect_key(void)
{
	unsigned power_key;
	if (((readl(AO_MF_IR_DEC_STATUS))>>3) & 0x1) {
		power_key = readl(AO_MF_IR_DEC_FRAME);
		if ((power_key&IR_POWER_KEY_MASK) == kk[DECODEMODE_NEC])
			return 1;

	}
	return 0;
}
