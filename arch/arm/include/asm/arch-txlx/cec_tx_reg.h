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


#define     AO_RTI_STATUS_REG0                                 (0xff800000 + (0x00 << 2))
#define SEC_AO_RTI_STATUS_REG0                                 (0xff800000 + (0x00 << 2))
#define   P_AO_RTI_STATUS_REG0                                 (volatile uint32_t *)(0xff800000 + (0x00 << 2))
#define     AO_RTI_STATUS_REG1                                 (0xff800000 + (0x01 << 2))
#define SEC_AO_RTI_STATUS_REG1                                 (0xff800000 + (0x01 << 2))
#define   P_AO_RTI_STATUS_REG1                                 (volatile uint32_t *)(0xff800000 + (0x01 << 2))
#define     AO_RTI_STATUS_REG2                                 (0xff800000 + (0x02 << 2))
#define SEC_AO_RTI_STATUS_REG2                                 (0xff800000 + (0x02 << 2))
#define   P_AO_RTI_STATUS_REG2                                 (volatile uint32_t *)(0xff800000 + (0x02 << 2))
#define     AO_RTI_PWR_CNTL_REG1                               (0xff800000 + (0x03 << 2))
#define SEC_AO_RTI_PWR_CNTL_REG1                               (0xff800000 + (0x03 << 2))
#define   P_AO_RTI_PWR_CNTL_REG1                               (volatile uint32_t *)(0xff800000 + (0x03 << 2))
#define     AO_RTI_PWR_CNTL_REG0                               (0xff800000 + (0x04 << 2))
#define SEC_AO_RTI_PWR_CNTL_REG0                               (0xff800000 + (0x04 << 2))
#define   P_AO_RTI_PWR_CNTL_REG0                               (volatile uint32_t *)(0xff800000 + (0x04 << 2))
#define     AO_RTI_PIN_MUX_REG                                 (0xff800000 + (0x05 << 2))
#define SEC_AO_RTI_PIN_MUX_REG                                 (0xff800000 + (0x05 << 2))
#define   P_AO_RTI_PIN_MUX_REG                                 (volatile uint32_t *)(0xff800000 + (0x05 << 2))
#define     AO_RTI_PIN_MUX_REG2                                (0xff800000 + (0x06 << 2))
#define SEC_AO_RTI_PIN_MUX_REG2                                (0xff800000 + (0x06 << 2))
#define   P_AO_RTI_PIN_MUX_REG2                                (volatile uint32_t *)(0xff800000 + (0x06 << 2))
#define     AO_RTI_STATUS_REG3                                 (0xff800000 + (0x07 << 2))
#define SEC_AO_RTI_STATUS_REG3                                 (0xff800000 + (0x07 << 2))
#define   P_AO_RTI_STATUS_REG3                                 (volatile uint32_t *)(0xff800000 + (0x07 << 2))
//`define AO_REMAP_REG0               8'h07 //TODO: DELETE. NOT USED
#define     AO_REMAP_REG1                                      (0xff800000 + (0x08 << 2))
#define SEC_AO_REMAP_REG1                                      (0xff800000 + (0x08 << 2))
#define   P_AO_REMAP_REG1                                      (volatile uint32_t *)(0xff800000 + (0x08 << 2))
#define     AO_GPIO_O_EN_N                                     (0xff800000 + (0x09 << 2))
#define SEC_AO_GPIO_O_EN_N                                     (0xff800000 + (0x09 << 2))
#define   P_AO_GPIO_O_EN_N                                     (volatile uint32_t *)(0xff800000 + (0x09 << 2))
#define     AO_GPIO_I                                          (0xff800000 + (0x0a << 2))
#define SEC_AO_GPIO_I                                          (0xff800000 + (0x0a << 2))
#define   P_AO_GPIO_I                                          (volatile uint32_t *)(0xff800000 + (0x0a << 2))
#define     AO_RTI_PULL_UP_REG                                 (0xff800000 + (0x0b << 2))
#define SEC_AO_RTI_PULL_UP_REG                                 (0xff800000 + (0x0b << 2))
#define   P_AO_RTI_PULL_UP_REG                                 (volatile uint32_t *)(0xff800000 + (0x0b << 2))
#define     AO_RTI_JTAG_CONFIG_REG                             (0xff800000 + (0x0c << 2))
#define SEC_AO_RTI_JTAG_CONFIG_REG                             (0xff800000 + (0x0c << 2))
#define   P_AO_RTI_JTAG_CONFIG_REG                             (volatile uint32_t *)(0xff800000 + (0x0c << 2))
#define     AO_RTI_WD_MARK                                     (0xff800000 + (0x0d << 2))
#define SEC_AO_RTI_WD_MARK                                     (0xff800000 + (0x0d << 2))
#define   P_AO_RTI_WD_MARK                                     (volatile uint32_t *)(0xff800000 + (0x0d << 2))
#define     AO_DEBUG_REG0                                      (0xff800000 + (0x28 << 2))
#define SEC_AO_DEBUG_REG0                                      (0xff800000 + (0x28 << 2))
#define   P_AO_DEBUG_REG0                                      (volatile uint32_t *)(0xff800000 + (0x28 << 2))
#define     AO_DEBUG_REG1                                      (0xff800000 + (0x29 << 2))
#define SEC_AO_DEBUG_REG1                                      (0xff800000 + (0x29 << 2))
#define   P_AO_DEBUG_REG1                                      (volatile uint32_t *)(0xff800000 + (0x29 << 2))
#define     AO_DEBUG_REG2                                      (0xff800000 + (0x2a << 2))
#define SEC_AO_DEBUG_REG2                                      (0xff800000 + (0x2a << 2))
#define   P_AO_DEBUG_REG2                                      (volatile uint32_t *)(0xff800000 + (0x2a << 2))
#define     AO_DEBUG_REG3                                      (0xff800000 + (0x2b << 2))
#define SEC_AO_DEBUG_REG3                                      (0xff800000 + (0x2b << 2))
#define   P_AO_DEBUG_REG3                                      (volatile uint32_t *)(0xff800000 + (0x2b << 2))
#define     AO_CECB_CLK_CNTL_REG0                              (0xff800000 + (0xa0 << 2))
#define SEC_AO_CECB_CLK_CNTL_REG0                              (0xff800000 + (0xa0 << 2))
#define   P_AO_CECB_CLK_CNTL_REG0                              (volatile uint32_t *)(0xff800000 + (0xa0 << 2))
#define     AO_CECB_CLK_CNTL_REG1                              (0xff800000 + (0xa1 << 2))
#define SEC_AO_CECB_CLK_CNTL_REG1                              (0xff800000 + (0xa1 << 2))
#define   P_AO_CECB_CLK_CNTL_REG1                              (volatile uint32_t *)(0xff800000 + (0xa1 << 2))
#define     AO_CECB_GEN_CNTL                                   (0xff800000 + (0xa2 << 2))
#define SEC_AO_CECB_GEN_CNTL                                   (0xff800000 + (0xa2 << 2))
#define   P_AO_CECB_GEN_CNTL                                   (volatile uint32_t *)(0xff800000 + (0xa2 << 2))
#define     AO_CECB_RW_REG                                     (0xff800000 + (0xa3 << 2))
#define SEC_AO_CECB_RW_REG                                     (0xff800000 + (0xa3 << 2))
#define   P_AO_CECB_RW_REG                                     (volatile uint32_t *)(0xff800000 + (0xa3 << 2))
#define     AO_CECB_INTR_MASKN                                 (0xff800000 + (0xa4 << 2))
#define SEC_AO_CECB_INTR_MASKN                                 (0xff800000 + (0xa4 << 2))
#define   P_AO_CECB_INTR_MASKN                                 (volatile uint32_t *)(0xff800000 + (0xa4 << 2))
#define     AO_CECB_INTR_CLR                                   (0xff800000 + (0xa5 << 2))
#define SEC_AO_CECB_INTR_CLR                                   (0xff800000 + (0xa5 << 2))
#define   P_AO_CECB_INTR_CLR                                   (volatile uint32_t *)(0xff800000 + (0xa5 << 2))
#define     AO_CECB_INTR_STAT                                  (0xff800000 + (0xa6 << 2))
#define SEC_AO_CECB_INTR_STAT                                  (0xff800000 + (0xa6 << 2))
#define   P_AO_CECB_INTR_STAT                                  (volatile uint32_t *)(0xff800000 + (0xa6 << 2))


#endif  // _HDMI_RX_REG_H

