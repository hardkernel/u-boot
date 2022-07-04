/* SPDX-License-Identifier:     GPL-2.0+ */
/*
 * (C) Copyright 2022 Rockchip Electronics Co., Ltd
 *
 */

#ifndef _RK_CFG_H_
#define _RK_CFG_H_

/*      META storage layout        */
/***************************/      /* ----- ITEM start -----*/
/**     META_HEAD  4KB    **/
/***************************/
/**     ITEM 1            **/
/***************************/
/**     ITEM 2            **/
/***************************/
/**     ITEM 3            **/
/***************************/
/**       ....            **/
/***************************/      /* --- ITEM backup start 32KB ---*/
/**     ITEM 1 BACKUP     **/
/***************************/
/**     ITEM 2 BACKUP     **/
/***************************/
/**     ITEM 3 BACKUP     **/
/***************************/
/**       ....            **/
/***************************/
/**     META_END  4KB     **/
/***************************/      /* ----- ITEM backup end -----*/
/**     IQ FILE BIN       **/       /* 320K sensor iq file bin */
/***************************/

/*      META memory layout        */
/***************************/      /* ----- ITEM start -----*/
/**     Amp info  512B    **/
/***************************/
/**     ITEM 1            **/
/***************************/
/**     ITEM 2            **/
/***************************/
/**     ITEM 3            **/
/***************************/
/**       ....            **/
/***************************/      /* --- ITEM backup start 32KB ---*/
/**     ITEM 1 BACKUP     **/
/***************************/
/**     ITEM 2 BACKUP     **/
/***************************/
/**     ITEM 3 BACKUP     **/
/***************************/
/**       ....            **/
/***************************/
/**     META_END  4KB     **/
/***************************/      /* ----- ITEM backup end -----*/
/**     IQ FILE BIN       **/       /* 320K sensor iq file bin */
/***************************/

#define RK_META			0x544d4b52
#define RK_META_END		0x55aabbcc
#define RK_CMDLINE		0x4c444d43
#define RK_META_DATA_OFFSET	0x8

#define ITEM_SIZE		(4 * 1024)
#define MAX_CMDLINE_LENGTH	1024
#define MAX_HEAD_SIZE 4
#define MAX_META_SEGMENT_SIZE (64 * 1024)
#define MAX_META_SENSOR_IQ_BIN_SIZE (320 * 1024)
#define MAX_META_BIN_SIZE (MAX_META_SEGMENT_SIZE + MAX_META_SENSOR_IQ_BIN_SIZE)
#define BACKUP_META_SIZE (MAX_META_SEGMENT_SIZE / 2)
#define META_INFO_HEAD_OFFSET	0
#define META_INFO_SIZE		ITEM_SIZE /* 4K bytes */
#define SENSOR_INIT_OFFSET	(META_INFO_HEAD_OFFSET + META_INFO_SIZE)
#define SENSOR_INIT_MAX_SIZE	ITEM_SIZE /* 4K bytes */
#define CMDLINE_OFFSET		(SENSOR_INIT_OFFSET + SENSOR_INIT_MAX_SIZE)
#define CMDLINE_MAX_SIZE	ITEM_SIZE /* 4K bytes */
#define AE_TABLE_OFFSET		(CMDLINE_OFFSET + CMDLINE_MAX_SIZE)
#define AE_TABLE_MAX_SIZE	ITEM_SIZE /* 4K bytes */
#define SENSOR_IQ_BIN_OFFSET			(MAX_META_SEGMENT_SIZE)
#define SENSOR_IQ_BIN_MAX_SIZE			(320 * 1024)
#define META_SIZE						MAX_META_BIN_SIZE
#define	META_HEAD_RESERVED_SIZE	   (124*4)

#define RK_AMP			0x504d4b52
/* rk_amp_info flags */
#define RK_AMP_DATA_READY	(1 << 0)

struct meta_head {
	uint32_t tag;
	uint32_t load;
	uint32_t size;
	uint8_t  reserved[META_HEAD_RESERVED_SIZE];
	uint32_t crc32;
};

struct rk_amp_info {
	uint32_t tag;
	uint32_t flags;
	uint32_t crc32;
};

struct cmdline_info {
	uint32_t tag;
	uint8_t data[MAX_CMDLINE_LENGTH];
	uint32_t crc32;
};

#endif
