/*
 * board/amlogic/odroidn2/firmware/scp_task/pwm_ctrl.h
 * table for Dynamic Voltage/Frequency Scaling
 */
#ifndef __PWM_CTRL_H__
#define __PWM_CTRL_H__

static int pwm_voltage_table_ee[][2] = {
	{ 0x100000,  693},
	{ 0x0f0001,  703},
	{ 0x0e0002,  713},
	{ 0x0d0003,  723},
	{ 0x0c0004,  733},
	{ 0x0b0005,  743},
	{ 0x0a0006,  753},
	{ 0x090007,  763},
	{ 0x080008,  773},
	{ 0x070009,  783},
	{ 0x06000a,  792},
	{ 0x05000b,  802},
	{ 0x04000c,  812},
	{ 0x03000d,  822},
	{ 0x02000e,  832},
	{ 0x01000f,  842},
	{ 0x000010,  852},
	{ 0x0000c0,  862},
};

static int pwm_voltage_table_ee_new[][2] = {
	{ 0x0f0001,  700},
	{ 0x0e0002,  710},
	{ 0x0d0003,  720},
	{ 0x0c0004,  730},
	{ 0x0b0005,  740},
	{ 0x0a0006,  750},
	{ 0x090007,  760},
	{ 0x080008,  770},
	{ 0x070009,  780},
	{ 0x06000a,  790},
	{ 0x05000b,  800},
	{ 0x04000c,  810},
	{ 0x03000d,  820},
	{ 0x02000e,  830},
	{ 0x01000f,  840},
	{ 0x000010,  850},
	{ 0x000040,  860},
	{ 0x000160,  870},	/* 863 */
};

#endif //__PWM_CTRL_H__
