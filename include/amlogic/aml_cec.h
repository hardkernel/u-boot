/*
 * include/amlogic/aml_cec.h
 *
 * Copyright (C) 2012 AMLOGIC, INC. All Rights Reserved.
 * Author: hongmin hua <hongmin hua@amlogic.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the smems of the GNU General Public License as published by
 * the Free Software Foundation; version 2 of the License.
 */


#ifndef _AML_CEC_H
#define _AML_CEC_H


#ifndef CONFIG_CEC_OSD_NAME
#define CONFIG_CEC_OSD_NAME "AML_TV"
#endif

/*CEC UI MASK*/
#define CEC_FUNC_MASK                        0
#define ONE_TOUCH_PLAY_MASK                  1
#define ONE_TOUCH_STANDBY_MASK               2
#define AUTO_POWER_ON_MASK                   3

#define MAX_MSG 16
#define CEC_PLAYBACK_DEVICE_TYPE 4
#define CEC_BROADCAST_ADDR 0xf
#define CEC_VERSION_14A 5

//=========ao cec a==================================
//cec a: read only
#define CEC_RX_MSG_LENGTH          0x90
#define CEC_RX_MSG_STATUS          0x91
#define CEC_RX_NUM_MSG             0x92
#define CEC_TX_MSG_STATUS          0x93
#define CEC_TX_NUM_MSG             0x94

//cec a: tx_msg_cmd definition
#define TX_NO_OP                0  // No transaction
#define TX_REQ_CURRENT          1  // Transmit earliest message in buffer
#define TX_ABORT                2  // Abort transmitting earliest message
#define TX_REQ_NEXT             3  // Overwrite earliest message in buffer and transmit next message

//cec a: tx_msg_status definition
#define TX_IDLE                 0  // No transaction
#define TX_BUSY                 1  // Transmitter is busy
#define TX_DONE                 2  // Message has been successfully transmitted
#define TX_ERROR                3  // Message has been transmitted with error

//cec a: rx_msg_cmd
#define RX_NO_OP                0  // No transaction
#define RX_ACK_CURRENT          1  // Read earliest message in buffer
#define RX_DISABLE              2  // Disable receiving latest message
#define RX_ACK_NEXT             3  // Clear earliest message from buffer and read next message

//cec a: rx_msg_status
#define RX_IDLE                 0  // No transaction
#define RX_BUSY                 1  // Receiver is busy
#define RX_DONE                 2  // Message has been received successfully
#define RX_ERROR                3  // Message has been received with error


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
	cec_msg_buf_t buf[2];          /* message memory */
	unsigned char power_status;
	unsigned char log_addr;
	unsigned char cec_power;
	unsigned char active_source;
	unsigned char rx_write_pos;
	unsigned char rx_read_pos;
	unsigned char rx_buf_size;
} cec_msg_t;

typedef struct {
	unsigned int wk_logic_addr:8;
	unsigned int wk_phy_addr:16;
	unsigned int wk_port_id:8;
}cec_wakeup_t;

extern cec_msg_t cec_msg;

extern int cec_hw_init(int logic_addr, unsigned char fun_cfg);

#endif/*_AML_CEC_H*/

