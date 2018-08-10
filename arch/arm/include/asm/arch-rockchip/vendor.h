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

struct vendor_item {
	u16  id;
	u16  offset;
	u16  size;
	u16  flag;
};

int vendor_storage_test(void);
int vendor_storage_read(u16 id, void *pbuf, u16 size);
int vendor_storage_write(u16 id, void *pbuf, u16 size);
int flash_vendor_dev_ops_register(int (*read)(struct blk_desc *dev_desc,
					      u32 sec,
					      u32 n_sec,
					      void *p_data),
				  int (*write)(struct blk_desc *dev_desc,
					       u32 sec,
					       u32 n_sec,
					       void *p_data));
#endif /* _ROCKCHIP_VENDOR_ */
