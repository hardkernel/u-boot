/*
*board/amlogic/txl_p321_v1/firmware/scp_task/pwm_vol_tab.h
*table for Dynamic Voltage/Frequency Scaling
*/
#ifndef __PWM_CTRL_H__
#define __PWM_CTRL_H__

static int pwm_voltage_table_ee[][2] = {
	{ 0x1c0000,  681},
	{ 0x1b0001,  691},
	{ 0x1a0002,  701},
	{ 0x190003,  711},
	{ 0x180004,  721},
	{ 0x170005,  731},
	{ 0x160006,  741},
	{ 0x150007,  751},
	{ 0x140008,  761},
	{ 0x130009,  772},
	{ 0x12000a,  782},
	{ 0x11000b,  792},
	{ 0x10000c,  802},
	{ 0x0f000d,  812},
	{ 0x0e000e,  822},
	{ 0x0d000f,  832},
	{ 0x0c0010,  842},
	{ 0x0b0011,  852},
	{ 0x0a0012,  862},
	{ 0x090013,  872},
	{ 0x080014,  882},
	{ 0x070015,  892},
	{ 0x060016,  902},
	{ 0x050017,  912},
	{ 0x040018,  922},
	{ 0x030019,  932},
	{ 0x02001a,  942},
	{ 0x01001b,  952},
	{ 0x00001c,  962}
};

#endif //__PWM_CTRL_H__
