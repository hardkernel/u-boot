/*
 * arch/arm/cpu/armv8/txl/firmware/scp_task/hdmi_cec_arc.h
 *
 * Copyright (C) 2012 AMLOGIC, INC. All Rights Reserved.
 * Author: hongmin hua <hongmin hua@amlogic.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the smems of the GNU General Public License as published by
 * the Free Software Foundation; version 2 of the License.
 */


#ifndef _HDMI_CEC_ARC_H
#define _HDMI_CEC_ARC_H

#ifndef CONFIG_CEC_OSD_NAME
#define CONFIG_CEC_OSD_NAME "AML_TV"
#endif

#define CEC_VERSION "cec a ver:2018/10/10\n"

/* cec irq bit flags for AO_CEC_B */
#define CECB_IRQ_TX_DONE		(1 << 0)
#define CECB_IRQ_RX_EOM			(1 << 1)
#define CECB_IRQ_TX_NACK		(1 << 2)
#define CECB_IRQ_TX_ARB_LOST		(1 << 3)
#define CECB_IRQ_TX_ERR_INITIATOR	(1 << 4)
#define CECB_IRQ_RX_ERR_FOLLOWER	(1 << 5)
#define CECB_IRQ_RX_WAKEUP		(1 << 6)
#define CECB_IRQ_EN_MASK		(0xf << 0)

/*CEC UI MASK*/
#define CEC_FUNC_MASK                        0
#define ONE_TOUCH_PLAY_MASK                  1
#define ONE_TOUCH_STANDBY_MASK               2
#define AUTO_POWER_ON_MASK                   3

/*source addr param to kernel define*/
#define LOGIC_ADDR_MASK			0xFFFF0000
#define PHY_ADDR_MASK			0x0000FFFF
#define get_logic_addr(a)		(((a) & LOGIC_ADDR_MASK) >> 16)
#define get_phy_addr(a)			(((a) & PHY_ADDR_MASK) >> 0)


extern unsigned char hdmi_cec_func_config;
void cec_node_init(void);
unsigned int cec_handler(void);
void cec_hw_reset(void);
/* void cec_give_device_power_status(void); */
void udelay(int i);
void check_standby(void);
/*int is_phy_addr_ready(cec_msg_t *msg);*/
void cec_save_port_id(void);
int cec_suspend_handle(void);
int cec_suspend_wakeup_chk(void);
#endif  /* _HDMI_CEC_ARC_H */

