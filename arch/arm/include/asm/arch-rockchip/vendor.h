/*
 * (C) Copyright 2008-2017 Fuzhou Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */
#ifndef __ROCKCHIP_VENDOR_
#define __ROCKCHIP_VENDOR_

#define VENDOR_SN_ID		1 /* serialno */
#define VENDOR_WIFI_MAC_ID	2 /* wifi mac */
#define VENDOR_LAN_MAC_ID	3 /* lan mac */
#define VENDOR_BLUETOOTH_ID	4 /* bluetooth mac */

int vendor_storage_test(void);
int vendor_storage_read(u16 id, void *pbuf, u16 size);
int vendor_storage_write(u16 id, void *pbuf, u16 size);

#endif /* _ROCKCHIP_VENDOR_ */
