/*
 * arch/arm/cpu/armv8/txlx/hdmirx/hdmirx.h
 *
 * Copyright (C) 2012 AMLOGIC, INC. All Rights Reserved.
 * Author: hongmin hua <hongmin hua@amlogic.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the smems of the GNU General Public License as published by
 * the Free Software Foundation; version 2 of the License.
 */


#ifndef _HDMIRX_H
#define _HDMIRX_H

enum edid_audio_format_e {
	AUDIO_FORMAT_HEADER,
	AUDIO_FORMAT_LPCM,
	AUDIO_FORMAT_AC3,
	AUDIO_FORMAT_MPEG1,
	AUDIO_FORMAT_MP3,
	AUDIO_FORMAT_MPEG2,
	AUDIO_FORMAT_AAC,
	AUDIO_FORMAT_DTS,
	AUDIO_FORMAT_ATRAC,
	AUDIO_FORMAT_OBA,
	AUDIO_FORMAT_DDP,
	AUDIO_FORMAT_DTSHD,
	AUDIO_FORMAT_MAT,
	AUDIO_FORMAT_DST,
	AUDIO_FORMAT_WMAPRO,
};

enum edid_tag_e {
	EDID_TAG_NONE,
	EDID_TAG_AUDIO = 1,
	EDID_TAG_VIDEO = 2,
	EDID_TAG_VENDOR = 3,
	EDID_TAG_HDR = ((0x7<<8)|6),
};

enum port_sts {
	E_PORT0,
	E_PORT1,
	E_PORT2,
	E_PORT3,
	E_PORT_NUM,
	E_5V_LOST = 0xfd,
	E_HPD_RESET = 0xfe,
	E_INIT = 0xff,
};

struct edid_audio_block_t {
	unsigned char max_channel:3;
	unsigned char format_code:5;
	unsigned char freq_32khz:1;
	unsigned char freq_441khz:1;
	unsigned char freq_48khz:1;
	unsigned char freq_882khz:1;
	unsigned char freq_96khz:1;
	unsigned char freq_1764khz:1;
	unsigned char freq_192khz:1;
	unsigned char freq_reserv:1;
	union bit_rate_u {
		struct pcm_t {
			unsigned char rate_16bit:1;
			unsigned char rate_20bit:1;
			unsigned char rate_24bit:1;
			unsigned char rate_reserv:5;
		} pcm;
		unsigned char others;
	} bit_rate;
};

struct edid_hdr_block_t {
	unsigned char ext_tag_code;
	unsigned char sdr:1;
	unsigned char hdr:1;
	unsigned char smtpe_2048:1;
	unsigned char future:5;
	unsigned char meta_des_type1:1;
	unsigned char reserv:7;
	unsigned char max_lumi;
	unsigned char avg_lumi;
	unsigned char min_lumi;
};

struct hdmirx_data_s {
	unsigned char repeater;/*if hdmitx exist,set 1*/
	unsigned char dbg_en;
	unsigned int port_map;
	int up_phy_addr;/*d c b a 4bit*/
	unsigned char *edid_buf;
	int edid_size;
};

enum edid_list_e {
	EDID_LIST_BUFF,
	EDID_LIST_14,
	EDID_LIST_14_AUD,
	EDID_LIST_14_420C,
	EDID_LIST_14_420VD,
	EDID_LIST_20,
	EDID_LIST_NUM
};

/* EDID */
#define MAX_RECEIVE_EDID	33
#define MAX_HDR_LUMI		3
#define MAX_KSV_SIZE		5
#define MAX_REPEAT_COUNT	127
#define MAX_REPEAT_DEPTH	7
#define MAX_KSV_LIST_SIZE	(MAX_KSV_SIZE*MAX_REPEAT_COUNT)
/*size of one format in edid*/
#define FORMAT_SIZE			sizeof(struct edid_audio_block_t)
#define EDID_DEFAULT_START		132
#define EDID_DESCRIP_OFFSET		2
#define EDID_BLOCK1_OFFSET		128
#define EDID_DEFAULT_LEN	256
/** Configuration clock minimum [kHz] */
#define CFG_CLK_MIN				(10000UL)
/** Configuration clock maximum [kHz] */
#define CFG_CLK_MAX				(160000UL)

/** TMDS clock minimum [kHz] */
#define TMDS_CLK_MIN			(24000UL)/* (25000UL) */
#define TMDS_CLK_MAX			(340000UL)/* (600000UL) */
#define HYST_HDMI_TO_DVI 5
/* must = 0, other agilent source fail */
#define HYST_DVI_TO_HDMI 0
#define EDID_CLK_DIV 9 /* sys clk/(9+1) = 20M */
#define ACR_MODE 0

#define MODET_CLK 24000

#define is_audio_support(x) (((x) == AUDIO_FORMAT_LPCM) || \
		((x) == AUDIO_FORMAT_DTS) || ((x) == AUDIO_FORMAT_DDP))

void hdmirx_hw_init(unsigned int port_map,
						  unsigned char *pedid_data,
						  int edid_size);
#endif

