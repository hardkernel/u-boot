
/*
 * arch/arm/cpu/armv8/txl/firmware/scp_task/cec_tx_reg.h
 *
 * Copyright (C) 2015 Amlogic, Inc. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

#ifndef _CEC_TX_REG_H
#define _CEC_TX_REG_H

#ifndef CONFIG_CEC_OSD_NAME
#define CONFIG_CEC_OSD_NAME "AML_TV"
#endif

#define CEC_VERSION "cec ver:2018/07/03"

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

// tx_msg_status definition
#define TX_IDLE                 0  // No transaction
#define TX_BUSY                 1  // Transmitter is busy
#define TX_DONE                 2  // Message has been successfully transmitted
#define TX_ERROR                3  // Message has been transmitted with error

/*
 * CEC OPCODES
 */
#define	CEC_OC_ABORT_MESSAGE 					0xFF
#define	CEC_OC_ACTIVE_SOURCE 					0x82
#define	CEC_OC_CEC_VERSION 					0x9E
#define	CEC_OC_CLEAR_ANALOGUE_TIMER 				0x33
#define	CEC_OC_CLEAR_DIGITAL_TIMER 				0x99
#define	CEC_OC_CLEAR_EXTERNAL_TIMER 				0xA1
#define	CEC_OC_DECK_CONTROL 					0x42
#define	CEC_OC_DECK_STATUS 					0x1B
#define	CEC_OC_DEVICE_VENDOR_ID 				0x87
#define	CEC_OC_FEATURE_ABORT 					0x00
#define	CEC_OC_GET_CEC_VERSION 					0x9F
#define	CEC_OC_GET_MENU_LANGUAGE 				0x91
#define	CEC_OC_GIVE_AUDIO_STATUS 				0x71
#define	CEC_OC_GIVE_DECK_STATUS 				0x1A
#define	CEC_OC_GIVE_DEVICE_POWER_STATUS 			0x8F
#define	CEC_OC_GIVE_DEVICE_VENDOR_ID 				0x8C
#define	CEC_OC_GIVE_OSD_NAME 					0x46
#define	CEC_OC_GIVE_PHYSICAL_ADDRESS 				0x83
#define	CEC_OC_GIVE_SYSTEM_AUDIO_MODE_STATUS 			0x7D
#define	CEC_OC_GIVE_TUNER_DEVICE_STATUS 			0x08
#define	CEC_OC_IMAGE_VIEW_ON 					0x04
#define	CEC_OC_INACTIVE_SOURCE 					0x9D
#define	CEC_OC_MENU_REQUEST 					0x8D
#define	CEC_OC_MENU_STATUS 					0x8E
#define	CEC_OC_PLAY 						0x41
#define	CEC_OC_POLLING_MESSAGE 					0xFC	/* Fake Code - <Poll Message> has no OP Code and requires only the header byte */
#define	CEC_OC_RECORD_OFF 					0x0B
#define	CEC_OC_RECORD_ON 					0x09
#define	CEC_OC_RECORD_STATUS 					0x0A
#define	CEC_OC_RECORD_TV_SCREEN 				0x0F
#define	CEC_OC_REPORT_AUDIO_STATUS 				0x7A
#define	CEC_OC_REPORT_PHYSICAL_ADDRESS 				0x84
#define	CEC_OC_REPORT_POWER_STATUS 				0x90
#define	CEC_OC_REQUEST_ACTIVE_SOURCE 				0x85
#define	CEC_OC_ROUTING_CHANGE 					0x80
#define	CEC_OC_ROUTING_INFORMATION 				0x81
#define	CEC_OC_SELECT_ANALOGUE_SERVICE 				0x92
#define	CEC_OC_SELECT_DIGITAL_SERVICE 				0x93
#define	CEC_OC_SET_ANALOGUE_TIMER 				0x34
#define	CEC_OC_SET_AUDIO_RATE 					0x9A
#define	CEC_OC_SET_DIGITAL_TIMER 				0x97
#define	CEC_OC_SET_EXTERNAL_TIMER 				0xA2
#define	CEC_OC_SET_MENU_LANGUAGE 				0x32
#define	CEC_OC_SET_OSD_NAME 					0x47
#define	CEC_OC_SET_OSD_STRING 					0x64
#define	CEC_OC_SET_STREAM_PATH 					0x86
#define	CEC_OC_SET_SYSTEM_AUDIO_MODE 				0x72
#define	CEC_OC_SET_TIMER_PROGRAM_TITLE 				0x67
#define	CEC_OC_STANDBY 						0x36
#define	CEC_OC_SYSTEM_AUDIO_MODE_REQUEST 			0x70
#define	CEC_OC_SYSTEM_AUDIO_MODE_STATUS 			0x7E
#define	CEC_OC_TEXT_VIEW_ON 					0x0D
#define	CEC_OC_TIMER_CLEARED_STATUS 				0x43
#define	CEC_OC_TIMER_STATUS 					0x35
#define	CEC_OC_TUNER_DEVICE_STATUS 				0x07
#define	CEC_OC_TUNER_STEP_DECREMENT 				0x06
#define	CEC_OC_TUNER_STEP_INCREMENT 				0x05
#define	CEC_OC_USER_CONTROL_PRESSED 				0x44
#define	CEC_OC_USER_CONTROL_RELEASED 				0x45
#define	CEC_OC_VENDOR_COMMAND 					0x89
#define	CEC_OC_VENDOR_COMMAND_WITH_ID 				0xA0
#define	CEC_OC_VENDOR_REMOTE_BUTTON_DOWN 			0x8A
#define	CEC_OC_VENDOR_REMOTE_BUTTON_UP 				0x8B

/*CEC UI MASK*/
#define CEC_FUNC_MASK                        0
#define ONE_TOUCH_PLAY_MASK                  1
#define ONE_TOUCH_STANDBY_MASK               2
#define AUTO_POWER_ON_MASK                   3

//#define P_HHI_GCLK_MPEG2 CBUS_REG_ADDR(HHI_GCLK_MPEG2)
//#define P_HHI_HDMI_CLK_CNTL CBUS_REG_ADDR(HHI_HDMI_CLK_CNTL)
#define MAX_MSG 16
#define CEC_PLAYBACK_DEVICE_TYPE 4
#define CEC_BROADCAST_ADDR 0xf
#define CEC_VERSION_14A 5

enum _cec_log_dev_addr_e {
    CEC_TV_ADDR = 0x00,
    CEC_RECORDING_DEVICE_1_ADDR,
    CEC_RECORDING_DEVICE_2_ADDR,
    CEC_TUNER_1_ADDR,
    CEC_PLAYBACK_DEVICE_1_ADDR,
    CEC_AUDIO_SYSTEM_ADDR,
    CEC_TUNER_2_ADDR,
    CEC_TUNER_3_ADDR,
    CEC_PLAYBACK_DEVICE_2_ADDR,
    CEC_RECORDING_DEVICE_3_ADDR,
    CEC_TUNER_4_ADDR,
    CEC_PLAYBACK_DEVICE_3_ADDR,
    CEC_RESERVED_1_ADDR,
    CEC_RESERVED_2_ADDR,
    CEC_FREE_USE_ADDR,
    CEC_UNREGISTERED_ADDR
};

typedef enum  {
    CEC_UNRECONIZED_OPCODE = 0x0,
    CEC_NOT_CORRECT_MODE_TO_RESPOND,
    CEC_CANNOT_PROVIDE_SOURCE,
    CEC_INVALID_OPERAND,
    CEC_REFUSED,
    CEC_UNABLE_TO_DETERMINE,
} cec_feature_abort_e;

typedef enum {
    DEVICE_MENU_ACTIVE = 0,
    DEVICE_MENU_INACTIVE,
} cec_device_menu_state_e;

/* cec message structure */
typedef struct {
    unsigned char msg[16];
    unsigned char msg_len;
} cec_msg_buf_t;

typedef struct {
    cec_msg_buf_t buf[2];          // message memory
    unsigned char power_status;
    unsigned char log_addr;
    unsigned char cec_power;
    unsigned char rx_write_pos;
    unsigned char rx_read_pos;
    unsigned char rx_buf_size;
} cec_msg_t;

cec_msg_t cec_msg;
unsigned char hdmi_cec_func_config;
void cec_node_init(void);
unsigned int cec_handler(void);
void remote_cec_hw_reset(void);
//void cec_give_device_power_status(void);
extern void udelay(int i);
int cec_power_on_check(void);

#endif  // _HDMI_RX_REG_H

