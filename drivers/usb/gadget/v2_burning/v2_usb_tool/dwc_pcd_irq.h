/* dwc driver irq header */
/*
 * (C) Copyright 2010 Amlogic, Inc
 *
 * Victor Wan, victor.wan@amlogic.com,
 * 2010-03-30 @ Shanghai
 *
 */
#ifndef __DWC_PCD_IRQ_H__
#define __DWC_PCD_IRQ_H__

int dwc_pcd_irq(void);
int dwc_otg_irq(void);

/**
 * States of EP0.
 */
typedef enum ep0_state {
	EP0_DISCONNECT,		/* no host */
	EP0_IDLE,
	EP0_IN_DATA_PHASE,
	EP0_OUT_DATA_PHASE,
	EP0_STATUS,
	EP0_STALL,
} ep0state_e;

extern int dwc_common_irq(void);

extern int cb_4_dis_connect_intr(void);
#endif
