/*
 * arch/arm/include/asm/arch-txlx/cec_tx_reg.h
 *
 * Copyright (C) 2012 AMLOGIC, INC. All Rights Reserved.
 * Author: hongmin hua <hongmin hua@amlogic.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the smems of the GNU General Public License as published by
 * the Free Software Foundation; version 2 of the License.
 */


#ifndef _CEC_TX_REG_H
#define _CEC_TX_REG_H

/* FOR AO_CECB */
#define DWC_CECB_CTRL                0x00
#define DWC_CECB_INTR_MASK           0x02
#define DWC_CECB_LADD_LOW            0x05
#define DWC_CECB_LADD_HIGH           0x06
#define DWC_CECB_TX_CNT              0x07
#define DWC_CECB_RX_CNT              0x08
#define DWC_CECB_TX_DATA00           0x10
#define DWC_CECB_TX_DATA01           0x11
#define DWC_CECB_TX_DATA02           0x12
#define DWC_CECB_TX_DATA03           0x13
#define DWC_CECB_TX_DATA04           0x14
#define DWC_CECB_TX_DATA05           0x15
#define DWC_CECB_TX_DATA06           0x16
#define DWC_CECB_TX_DATA07           0x17
#define DWC_CECB_TX_DATA08           0x18
#define DWC_CECB_TX_DATA09           0x19
#define DWC_CECB_TX_DATA10           0x1A
#define DWC_CECB_TX_DATA11           0x1B
#define DWC_CECB_TX_DATA12           0x1C
#define DWC_CECB_TX_DATA13           0x1D
#define DWC_CECB_TX_DATA14           0x1E
#define DWC_CECB_TX_DATA15           0x1F
#define DWC_CECB_RX_DATA00           0x20
#define DWC_CECB_RX_DATA01           0x21
#define DWC_CECB_RX_DATA02           0x22
#define DWC_CECB_RX_DATA03           0x23
#define DWC_CECB_RX_DATA04           0x24
#define DWC_CECB_RX_DATA05           0x25
#define DWC_CECB_RX_DATA06           0x26
#define DWC_CECB_RX_DATA07           0x27
#define DWC_CECB_RX_DATA08           0x28
#define DWC_CECB_RX_DATA09           0x29
#define DWC_CECB_RX_DATA10           0x2A
#define DWC_CECB_RX_DATA11           0x2B
#define DWC_CECB_RX_DATA12           0x2C
#define DWC_CECB_RX_DATA13           0x2D
#define DWC_CECB_RX_DATA14           0x2E
#define DWC_CECB_RX_DATA15           0x2F
#define DWC_CECB_LOCK_BUF            0x30
#define DWC_CECB_WAKEUPCTRL          0x31

/* cec irq bit flags for AO_CEC_B */
#define CECB_IRQ_TX_DONE		(1 << 0)
#define CECB_IRQ_RX_EOM			(1 << 1)
#define CECB_IRQ_TX_NACK		(1 << 2)
#define CECB_IRQ_TX_ARB_LOST		(1 << 3)
#define CECB_IRQ_TX_ERR_INITIATOR	(1 << 4)
#define CECB_IRQ_RX_ERR_FOLLOWER	(1 << 5)
#define CECB_IRQ_RX_WAKEUP		(1 << 6)
#define CECB_IRQ_EN_MASK		(0xf << 0)


/* FOR AO_CECA */
#define AO_CEC_TXTIME_17MS_BIT7_0               0x40
#define AO_CEC_TXTIME_17MS_BIT10_8              0x41
#define AO_CEC_TXTIME_2BIT_BIT7_0               0x42
#define AO_CEC_TXTIME_2BIT_BIT10_8              0x43
#define AO_CEC_TXTIME_4BIT_BIT7_0               0x44
#define AO_CEC_TXTIME_4BIT_BIT10_8              0x45


#define CEC_TX_MSG_LENGTH          0x10
#define CEC_TX_MSG_CMD             0x11
#define CEC_TX_WRITE_BUF           0x12
#define CEC_TX_CLEAR_BUF           0x13
#define CEC_RX_MSG_CMD             0x14
#define CEC_RX_CLEAR_BUF           0x15
#define CEC_LOGICAL_ADDR0          0x16
//#define CEC_LOGICAL_ADDR1          0x17
//#define CEC_LOGICAL_ADDR2          0x18
//#define CEC_LOGICAL_ADDR3          0x19
//#define CEC_LOGICAL_ADDR4          0x1A
#define CEC_CLOCK_DIV_H            0x1B
#define CEC_CLOCK_DIV_L            0x1C

/*wake up param to kernel define*/
#define WAKE_UP_PORT_ID_MASK	0xFFFF0000
#define WAKE_UP_REASON_MASK		0x0000FFFF
#define PHY_ADDR_LEN			4 /*16bit/4bit*/

//********** CEC related **********//
/*read/write*/
#define CEC_TX_MSG_0_HEADER        0x00
/*
#define CEC_TX_MSG_1_OPCODE        0x01
#define CEC_TX_MSG_2_OP1           0x02
#define CEC_TX_MSG_3_OP2           0x03
#define CEC_TX_MSG_4_OP3           0x04
#define CEC_TX_MSG_5_OP4           0x05
#define CEC_TX_MSG_6_OP5           0x06
#define CEC_TX_MSG_7_OP6           0x07
#define CEC_TX_MSG_8_OP7           0x08
#define CEC_TX_MSG_9_OP8           0x09
#define CEC_TX_MSG_A_OP9           0x0A
#define CEC_TX_MSG_B_OP10          0x0B
#define CEC_TX_MSG_C_OP11          0x0C
#define CEC_TX_MSG_D_OP12          0x0D
#define CEC_TX_MSG_E_OP13          0x0E
#define CEC_TX_MSG_F_OP14          0x0F
*/

//read only
#define CEC_TX_MSG_LENGTH          0x10
#define CEC_TX_MSG_CMD             0x11
#define CEC_TX_WRITE_BUF           0x12
#define CEC_TX_CLEAR_BUF           0x13
#define CEC_RX_MSG_CMD             0x14
#define CEC_RX_CLEAR_BUF           0x15
#define CEC_LOGICAL_ADDR0          0x16

/*
#define CEC_LOGICAL_ADDR1          0x17
#define CEC_LOGICAL_ADDR2          0x18
#define CEC_LOGICAL_ADDR3          0x19
#define CEC_LOGICAL_ADDR4          0x1A
#define CEC_CLOCK_DIV_H            0x1B
#define CEC_CLOCK_DIV_L            0x1C
*/

/*read/write*/
#define CEC_RX_MSG_0_HEADER        0x80
/*
#define CEC_RX_MSG_1_OPCODE        0x81
#define CEC_RX_MSG_2_OP1           0x82
#define CEC_RX_MSG_3_OP2           0x83
#define CEC_RX_MSG_4_OP3           0x84
#define CEC_RX_MSG_5_OP4           0x85
#define CEC_RX_MSG_6_OP5           0x86
#define CEC_RX_MSG_7_OP6           0x87
#define CEC_RX_MSG_8_OP7           0x88
#define CEC_RX_MSG_9_OP8           0x89
#define CEC_RX_MSG_A_OP9           0x8A
#define CEC_RX_MSG_B_OP10          0x8B
#define CEC_RX_MSG_C_OP11          0x8C
#define CEC_RX_MSG_D_OP12          0x8D
#define CEC_RX_MSG_E_OP13          0x8E
#define CEC_RX_MSG_F_OP14          0x8F
*/

#endif  // _HDMI_RX_REG_H

