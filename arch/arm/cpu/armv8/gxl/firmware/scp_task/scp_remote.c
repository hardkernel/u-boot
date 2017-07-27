#include <config.h>
#include "config.h"
#include "registers.h"
#include "task_apis.h"

typedef struct reg_remote {
	int reg;
	unsigned int val;
} reg_remote;
#define CONFIG_END 0xffffffff
#define IR_POWER_KEY_MASK 0xffffffff

static const reg_remote RDECODEMODE_NEC[] = {
	{AO_MF_IR_DEC_LDR_ACTIVE, 477 << 16 | 400 << 0},
	{AO_MF_IR_DEC_LDR_IDLE, 248 << 16 | 202 << 0},
	{AO_MF_IR_DEC_LDR_REPEAT, 130 << 16 | 110 << 0},
	{AO_MF_IR_DEC_BIT_0, 60 << 16 | 48 << 0},
	{AO_MF_IR_DEC_REG0, 3 << 28 | (0xFA0 << 12) | 0x13},
	{AO_MF_IR_DEC_STATUS, (111 << 20) | (100 << 10)},
	{AO_MF_IR_DEC_REG1, 0x9f00},
	{AO_MF_IR_DEC_REG2, 0x0},
	{AO_MF_IR_DEC_DURATN2, 0},
	{AO_MF_IR_DEC_DURATN3, 0},
	{CONFIG_END, 0}
};

static const reg_remote RDECODEMODE_DUOKAN[] = {
	{AO_MF_IR_DEC_LDR_ACTIVE, 70 << 16 | 30 << 0},
	{AO_MF_IR_DEC_LDR_IDLE, 50 << 16 | 15 << 0},
	{AO_MF_IR_DEC_LDR_REPEAT, 30 << 16 | 26 << 0},
	{AO_MF_IR_DEC_BIT_0, 66 << 16 | 40 << 0},
	{AO_MF_IR_DEC_REG0, 3 << 28 | (0x4e2 << 12) | 0x13}, //body frame 30ms
	{AO_MF_IR_DEC_STATUS, (80 << 20) | 66 << 10},
	{AO_MF_IR_DEC_REG1, 0x9300},
	{AO_MF_IR_DEC_REG2, 0xb90b},
	{AO_MF_IR_DEC_DURATN2, 97 << 16 | 80 << 0},
	{AO_MF_IR_DEC_DURATN3, 120 << 16 | 97 << 0},
	{AO_MF_IR_DEC_REG3, 5000 << 0},
	{CONFIG_END, 0}
};

static const reg_remote RDECODEMODE_TOSHIBA[] = {
	{AO_MF_IR_DEC_LDR_ACTIVE, 263 << 16 | 194 << 0},
	{AO_MF_IR_DEC_LDR_IDLE, 263 << 16 | 194 << 0},
	{AO_MF_IR_DEC_LDR_REPEAT, 263 << 16 | 194 << 0},
	{AO_MF_IR_DEC_BIT_0, 60 << 16 | 40 << 0},
	{AO_MF_IR_DEC_REG0, 3 << 28 | (0xFA0 << 12) | 0x13},
	{AO_MF_IR_DEC_STATUS, (124 << 20) | (100 << 10)},
	{AO_MF_IR_DEC_REG1, 0x9f50},
	{AO_MF_IR_DEC_REG2, 0x5},
	{AO_MF_IR_DEC_DURATN2, 0},
	{AO_MF_IR_DEC_DURATN3, 0},
	{CONFIG_END, 0}
};

static const reg_remote RDECODEMODE_RCA[] = {
	{AO_MF_IR_DEC_LDR_ACTIVE, ((unsigned)250 << 16) | ((unsigned)160 << 0)},	//rca leader 4000us,200* timebase
	{AO_MF_IR_DEC_LDR_IDLE, 250 << 16 | 160 << 0},	// leader idle 400
	{AO_MF_IR_DEC_LDR_REPEAT, 250 << 16 | 160 << 0},	// leader repeat
	{AO_MF_IR_DEC_BIT_0, 100 << 16 | 48 << 0},	// logic '0' or '00' 1500us
	{AO_MF_IR_DEC_REG0, 3 << 28 | (0xFA0 << 12) | 0x13},	// sys clock boby time.base time = 20 body frame
	{AO_MF_IR_DEC_STATUS, (150 << 20) | (110 << 10)},	// logic '1' or '01'    2500us
	{AO_MF_IR_DEC_REG1, 0x9700},	// boby long decode (8-13) //framn len = 24bit
	/*it may get the wrong customer value and key value from register if the value is set to 0x4,so the register value must set to 0x104 */
	{AO_MF_IR_DEC_REG2, 0x3904},
	{AO_MF_IR_DEC_REG3, 0x2bc},
	{AO_MF_IR_DEC_DURATN2, 0},
	{AO_MF_IR_DEC_DURATN3, 0},
	{CONFIG_END, 0}
};

static const reg_remote RDECODEMODE_RC5[] = {
	{ AO_MF_IR_DEC_LDR_ACTIVE ,  0            },
	{ AO_MF_IR_DEC_LDR_IDLE   ,  0            },
	{ AO_MF_IR_DEC_LDR_REPEAT ,  0            },
	{ AO_MF_IR_DEC_BIT_0      ,  0            },
	{ AO_MF_IR_DEC_REG0       ,  ((3 << 28) | (0x1644 << 12) | 0x13)},
	{ AO_MF_IR_DEC_STATUS     ,  (1 << 30)    },
	{ AO_MF_IR_DEC_REG1       ,  ((1 << 15) | (13 << 8))},
	/*bit[0-3]: RC5; bit[8]: MSB first mode; bit[11]: compare frame method*/
	{ AO_MF_IR_DEC_REG2       ,  ((1 << 13) | (1 << 11) | (1 << 8) | 0x7)},
	/*Half bit for RC5 format: 888.89us*/
	{ AO_MF_IR_DEC_DURATN2    ,  ((49 << 16) | (40 << 0))  },
	/*RC5 typically 1777.78us for whole bit*/
	{ AO_MF_IR_DEC_DURATN3    ,  ((94 << 16) | (83 << 0))  },
	{ AO_MF_IR_DEC_REG3       ,  0			 },
	{CONFIG_END, 0}
};

static const reg_remote *remoteregsTab[] = {
	RDECODEMODE_NEC,
	RDECODEMODE_DUOKAN,
	RDECODEMODE_TOSHIBA,
	RDECODEMODE_RCA,
	RDECODEMODE_RC5,
};

void setremotereg(const reg_remote * r)
{
	writel(r->val, r->reg);
}

int set_remote_mode(int mode)
{
	const reg_remote *reg;

	if (mode >= sizeof(remoteregsTab)/sizeof(remoteregsTab[0])) {
		uart_puts("invalid IR protocol: 0x");
		uart_put_hex(mode, 16);
		uart_puts("\n");
		return -1;
	}
	reg = remoteregsTab[mode];
	while (CONFIG_END != reg->reg)
		setremotereg(reg++);
	return 0;
}

unsigned backuAO_RTI_PIN_MUX_REG;
unsigned backuAO_IR_DEC_REG0;
unsigned backuAO_IR_DEC_REG1;
unsigned backuAO_IR_DEC_LDR_ACTIVE;
unsigned backuAO_IR_DEC_LDR_IDLE;
unsigned backuAO_IR_DEC_BIT_0;
unsigned bakeuAO_IR_DEC_LDR_REPEAT;
/*****************************************************************
**
** func : ir_remote_init
**       in this function will do pin configuration and and initialize for
**       IR Remote hardware decoder mode at 32kHZ on ARC.
**
********************************************************************/
#if 1
void backuremote_register(void)
{
	backuAO_RTI_PIN_MUX_REG = readl(AO_RTI_PIN_MUX_REG);
	backuAO_IR_DEC_REG0 = readl(AO_MF_IR_DEC_REG0);
	backuAO_IR_DEC_REG1 = readl(AO_MF_IR_DEC_REG1);
	backuAO_IR_DEC_LDR_ACTIVE = readl(AO_MF_IR_DEC_LDR_ACTIVE);
	backuAO_IR_DEC_LDR_IDLE = readl(AO_MF_IR_DEC_LDR_IDLE);
	backuAO_IR_DEC_BIT_0 = readl(AO_MF_IR_DEC_BIT_0);
	bakeuAO_IR_DEC_LDR_REPEAT = readl(AO_MF_IR_DEC_LDR_REPEAT);
}

void resume_remote_register(void)
{
	writel(backuAO_RTI_PIN_MUX_REG, AO_RTI_PIN_MUX_REG);
	writel(backuAO_IR_DEC_REG0, AO_MF_IR_DEC_REG0);
	writel(backuAO_IR_DEC_REG1, AO_MF_IR_DEC_REG1);
	writel(backuAO_IR_DEC_LDR_ACTIVE, AO_MF_IR_DEC_LDR_ACTIVE);
	writel(backuAO_IR_DEC_LDR_IDLE, AO_MF_IR_DEC_LDR_IDLE);
	writel(backuAO_IR_DEC_BIT_0, AO_MF_IR_DEC_BIT_0);
	writel(bakeuAO_IR_DEC_LDR_REPEAT, AO_MF_IR_DEC_LDR_REPEAT);
	readl(AO_MF_IR_DEC_FRAME);
}

static int ir_remote_init_32k_mode(void)
{
	//volatile unsigned int status,data_value;
	int val = readl(AO_RTI_PIN_MUX_REG);
	writel((val | (1 << 0)), AO_RTI_PIN_MUX_REG);
	set_remote_mode(CONFIG_IR_REMOTE_USE_PROTOCOL);
	//status = readl(AO_MF_IR_DEC_STATUS);
	readl(AO_MF_IR_DEC_STATUS);
	//data_value = readl(AO_MF_IR_DEC_FRAME);
	readl(AO_MF_IR_DEC_FRAME);
	//step 2 : request nec_remote irq  & enable it
	return 0;
}

void init_custom_trigger(void)
{
	ir_remote_init_32k_mode();
}
#endif

static unsigned int kk[] = {
	CONFIG_IR_REMOTE_POWER_UP_KEY_VAL1,
	CONFIG_IR_REMOTE_POWER_UP_KEY_VAL2,
	CONFIG_IR_REMOTE_POWER_UP_KEY_VAL3,
	CONFIG_IR_REMOTE_POWER_UP_KEY_VAL4,
};

static int init_remote(void)
{
	uart_put_hex(readl(AO_IR_DEC_STATUS), 32);
	uart_put_hex(readl(AO_IR_DEC_FRAME), 32);
	init_custom_trigger();
	return 0;
}

unsigned int usr_pwr_key = CONFIG_IR_REMOTE_POWER_UP_KEY_VAL5;

static int remote_detect_key(void)
{
	unsigned power_key;
	int j;
	if (((readl(AO_MF_IR_DEC_STATUS)) >> 3) & 0x1) { /*to judge the frame whether is effective or not*/
			if (readl(AO_MF_IR_DEC_STATUS) & 0x1) {		  /*to judge the frame whether is repeat frame or not*/
				readl(AO_MF_IR_DEC_FRAME);
				return 0;
			}
			power_key = readl(AO_MF_IR_DEC_FRAME);
			for (j = 0; j < CONFIG_IR_REMOTE_POWER_UP_KEY_CNT; j++) {
					if ((power_key & IR_POWER_KEY_MASK) == kk[j])
							return 1;
			}
			if ((power_key & IR_POWER_KEY_MASK) == usr_pwr_key)
					return 2;
	}

#ifdef CONFIG_COMPAT_IR
	if (((readl(AO_IR_DEC_STATUS)) >> 3) & 0x1) { /*to judge the frame whether is effective or not*/
			if (readl(AO_IR_DEC_STATUS) & 0x1) { 	  /*to judge the frame whether is repeat frame or not*/
				readl(AO_IR_DEC_FRAME);
				return 0;
			}
			power_key = readl(AO_IR_DEC_FRAME);
			for (j = 0; j < CONFIG_IR_REMOTE_POWER_UP_KEY_CNT; j++) {
					if ((power_key & IR_POWER_KEY_MASK) == kk[j])
							return 1;
			}
			if ((power_key & IR_POWER_KEY_MASK) == usr_pwr_key)
					return 2;
	}
#endif

	return 0;

}

