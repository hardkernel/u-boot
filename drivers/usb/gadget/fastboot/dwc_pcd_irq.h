/*
 * Copyright (c) 2015 Amlogic, Inc. All rights reserved.
 *
 * This source code is subject to the terms and conditions defined in the
 * file 'LICENSE' which is part of this source code package.
 *
 * USB low level irq defines
 */
#ifndef __DWC_PCD_IRQ_H__
#define __DWC_PCD_IRQ_H__

#include "dwc_pcd.h"

/**
 * States of EP0.
 */
typedef enum ep0_state {
	EP0_DISCONNECT,
	EP0_IDLE,
	EP0_IN_DATA_PHASE,
	EP0_OUT_DATA_PHASE,
	EP0_STATUS,
	EP0_STALL,
} ep0state_e;

extern int f_dwc_pcd_irq(void);
extern int f_dwc_otg_ep_req_start(pcd_struct_t *pcd, u32 ep_num, u32 is_in, struct usb_request *req);

#endif
