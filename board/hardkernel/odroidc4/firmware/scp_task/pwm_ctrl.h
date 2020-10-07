/*
 * board/hardkernel/odroidc4/firmware/scp_task/pwr_ctrl.h
 * table for Dynamic Voltage/Frequency Scaling
 */
#ifndef __PWM_CTRL_H__
#define __PWM_CTRL_H__

static int pwm_voltage_table_ee[][2] = {
	{ 0x090007,  800},
	{ 0x080008,  810},
	{ 0x070009,  820},
	{ 0x06000a,  830},
	{ 0x05000b,  840},
	{ 0x04000c,  850},
	{ 0x03000d,  860},
	{ 0x02000e,  870},
	{ 0x01000f,  880},
	{ 0x000010,  890},
};

#endif //__PWM_CTRL_H__
