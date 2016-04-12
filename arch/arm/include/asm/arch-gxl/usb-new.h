/*********************************************************************************
 *
 *  Copyright (C) 2013 AMLOGIC, INC.
 *
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 *
 **********************************************************************************/


#ifndef __ARCH_ARM_MESON_USB_H_U_BOOT__
#define __ARCH_ARM_MESON_USB_H_U_BOOT__

#include <common.h>
#include <asm/types.h>
#include <asm/arch/io.h>

#define USB_PHY_PORT_MAX	1
/* Phy register MACRO definitions */

#define LINKSYSTEM_FLADJ_MASK			(0x3f << 1)
#define LINKSYSTEM_FLADJ(_x)			((_x) << 1)
#define LINKSYSTEM_XHCI_VERSION_CONTROL		(0x1 << 27)

#define PHYUTMI_OTGDISABLE			(1 << 6)
#define PHYUTMI_FORCESUSPEND			(1 << 1)
#define PHYUTMI_FORCESLEEP			(1 << 0)

#define PHYCLKRST_SSC_REFCLKSEL_MASK		(0xff << 23)
#define PHYCLKRST_SSC_REFCLKSEL(_x)		((_x) << 23)

#define PHYCLKRST_SSC_RANGE_MASK		(0x03 << 21)
#define PHYCLKRST_SSC_RANGE(_x)			((_x) << 21)

#define PHYCLKRST_SSC_EN			(0x1 << 20)
#define PHYCLKRST_REF_SSP_EN			(0x1 << 19)
#define PHYCLKRST_REF_CLKDIV2			(0x1 << 18)

#define PHYCLKRST_MPLL_MULTIPLIER_MASK		(0x7f << 11)
#define PHYCLKRST_MPLL_MULTIPLIER_100MHZ_REF	(0x19 << 11)
#define PHYCLKRST_MPLL_MULTIPLIER_50M_REF	(0x02 << 11)
#define PHYCLKRST_MPLL_MULTIPLIER_24MHZ_REF	(0x68 << 11)
#define PHYCLKRST_MPLL_MULTIPLIER_20MHZ_REF	(0x7d << 11)
#define PHYCLKRST_MPLL_MULTIPLIER_19200KHZ_REF	(0x02 << 11)

#define PHYCLKRST_FSEL_MASK			(0x3f << 5)
#define PHYCLKRST_FSEL(_x)			((_x) << 5)
#define PHYCLKRST_FSEL_PAD_100MHZ		(0x27 << 5)
#define PHYCLKRST_FSEL_PAD_24MHZ		(0x2a << 5)
#define PHYCLKRST_FSEL_PAD_20MHZ		(0x31 << 5)
#define PHYCLKRST_FSEL_PAD_19_2MHZ		(0x38 << 5)

#define PHYCLKRST_RETENABLEN			(0x1 << 4)

#define PHYCLKRST_REFCLKSEL_MASK		(0x03 << 2)
#define PHYCLKRST_REFCLKSEL_PAD_REFCLK		(0x2 << 2)
#define PHYCLKRST_REFCLKSEL_EXT_REFCLK		(0x3 << 2)

#define PHYCLKRST_PORTRESET			(0x1 << 1)
#define PHYCLKRST_COMMONONN			(0x1 << 0)

#define PHYPARAM0_REF_USE_PAD			(0x1 << 31)
#define PHYPARAM0_REF_LOSLEVEL_MASK		(0x1f << 26)
#define PHYPARAM0_REF_LOSLEVEL			(0x9 << 26)

#define PHYPARAM1_PCS_TXDEEMPH_MASK		(0x1f << 0)
#define PHYPARAM1_PCS_TXDEEMPH			(0x1c)

#define PHYTEST_POWERDOWN_SSP			(0x1 << 3)
#define PHYTEST_POWERDOWN_HSP			(0x1 << 2)

#define PHYBATCHG_UTMI_CLKSEL			(0x1 << 2)

#define FSEL_CLKSEL_24M				(0x5)

/* XHCI PHY register structure */
#define PHY_REGISTER_SIZE	0x20
/* Register definitions */
struct u2p_aml_regs {
	volatile uint32_t u2p_r0;
	volatile uint32_t u2p_r1;
	volatile uint32_t u2p_r2;
};

//struct u2p_aml_regs amlogic_usb2_phy;

union u2p_r0_t {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned bypass_sel:1;
		unsigned bypass_dm_en:1;
		unsigned bypass_dp_en:1;
		unsigned txbitstuffenh:1;
		unsigned txbitstuffen:1;
		unsigned dmpulldown:1;
		unsigned dppulldown:1;
		unsigned vbusvldextsel:1;
		unsigned vbusvldext:1;
		unsigned adp_prb_en:1;
		unsigned adp_dischrg:1;
		unsigned adp_chrg:1;
		unsigned drvvbus:1;
		unsigned idpullup:1;
		unsigned loopbackenb:1;
		unsigned otgdisable:1;
		unsigned commononn:1;
		unsigned fsel:3;
		unsigned refclksel:2;
		unsigned por:1;
		unsigned vatestenb:2;
		unsigned set_iddq:1;
		unsigned ate_reset:1;
		unsigned fsv_minus:1;
		unsigned fsv_plus:1;
		unsigned bypass_dm_data:1;
		unsigned bypass_dp_data:1;
		unsigned not_used:1;
	} b;
};

union u2p_r1_t {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned burn_in_test:1;
		unsigned aca_enable:1;
		unsigned dcd_enable:1;
		unsigned vdatsrcenb:1;
		unsigned vdatdetenb:1;
		unsigned chrgsel:1;
		unsigned tx_preemp_pulse_tune:1;
		unsigned tx_preemp_amp_tune:2;
		unsigned tx_res_tune:2;
		unsigned tx_rise_tune:2;
		unsigned tx_vref_tune:4;
		unsigned tx_fsls_tune:4;
		unsigned tx_hsxv_tune:2;
		unsigned otg_tune:3;
		unsigned sqrx_tune:3;
		unsigned comp_dis_tune:3;
	} b;
};

union u2p_r2_t {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned data_in:4;
		unsigned data_in_en:4;
		unsigned addr:4;
		unsigned data_out_sel:1;
		unsigned clk:1;
		unsigned data_out:4;
		unsigned aca_pin_range_c:1;
		unsigned aca_pin_range_b:1;
		unsigned aca_pin_range_a:1;
		unsigned aca_pin_gnd:1;
		unsigned aca_pin_float:1;
		unsigned chg_det:1;
		unsigned device_sess_vld:1;
		unsigned adp_probe:1;
		unsigned adp_sense:1;
		unsigned sessend:1;
		unsigned vbusvalid:1;
		unsigned bvalid:1;
		unsigned avalid:1;
		unsigned iddig:1;
	} b;
};

struct usb_aml_regs {
	volatile uint32_t usb_r0;
	volatile uint32_t usb_r1;
	volatile uint32_t usb_r2;
	volatile uint32_t usb_r3;
	volatile uint32_t usb_r4;
	volatile uint32_t usb_r5;
	volatile uint32_t usb_r6;
};

//struct usb_aml_regs amlogic_usb3_phy;

union usb_r0_t {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned p30_fsel:6;
		unsigned p30_phy_reset:1;
		unsigned p30_test_powerdown_hsp:1;
		unsigned p30_test_powerdown_ssp:1;
		unsigned p30_acjt_level:5;
		unsigned p30_tx_vboost_lvl:3;
		unsigned p30_lane0_tx2rx_loopbk:1;
		unsigned p30_lane0_ext_pclk_req:1;
		unsigned p30_pcs_rx_los_mask_val:10;
		unsigned u2d_ss_scaledown_mode:2;
		unsigned u2d_act:1;
	} b;
};

union usb_r1_t {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned u3h_bigendian_gs:1;
		unsigned u3h_pme_en:1;
		unsigned u3h_hub_port_overcurrent:5;
		unsigned u3h_hub_port_perm_attach:5;
		unsigned u3h_host_u2_port_disable:4;
		unsigned u3h_host_u3_port_disable:1;
		unsigned u3h_host_port_power_control_present:1;
		unsigned u3h_host_msi_enable:1;
		unsigned u3h_fladj_30mhz_reg:6;
		unsigned p30_pcs_tx_swing_full:7;
	} b;
};

union usb_r2_t {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned p30_cr_data_in:16;
		unsigned p30_cr_read:1;
		unsigned p30_cr_write:1;
		unsigned p30_cr_cap_addr:1;
		unsigned p30_cr_cap_data:1;
		unsigned p30_pcs_tx_deemph_3p5db:6;
		unsigned p30_pcs_tx_deemph_6db:6;
	} b;
};

union usb_r3_t {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned p30_ssc_en:1;
		unsigned p30_ssc_range:3;
		unsigned p30_ssc_ref_clk_sel:9;
		unsigned p30_ref_ssp_en:1;
		unsigned reserved14:2;
		unsigned p30_los_bias:3;
		unsigned p30_los_level:5;
		unsigned p30_mpll_multiplier:7;
		unsigned reserved31:1;
	} b;
};

union usb_r4_t {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned p21_PORTRESET0:1;
		unsigned p21_SLEEPM0:1;
		unsigned mem_pd:2;
		unsigned p21_only:1;
		unsigned reserved4:27;
	} b;
};

union usb_r5_t {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned iddig_sync:1;
		unsigned iddig_reg:1;
		unsigned iddig_cfg:2;
		unsigned iddig_en0:1;
		unsigned iddig_en1:1;
		unsigned iddig_curr:1;
		unsigned iddig_irq:1;
		unsigned iddig_th:8;
		unsigned iddig_cnt:8;
		unsigned reserved5:8;
	} b;
};

union usb_r6_t {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned p30_cr_data_out:16;
		unsigned p30_cr_ack:1;
		unsigned not_used:15;
	} b;
};

/* usb id mode, only after M2
	 mode = 0 : HARDWARE
	 mode = 1 : SW_HOST
	 mode = 2 : SW_DEVICE
 */
#define USB_ID_MODE_HARDWARE    (1)
#define USB_ID_MODE_SW_HOST     (2)
#define USB_ID_MODE_SW_DEVICE   (3)

struct amlogic_usb_config {
	/* controller */
	unsigned int base_addr;
	/* role */
	int id_mode;
	/* vbus call back */
	void (* set_vbus_power)(char is_power_on);
	unsigned int usb_phy2_base_addr;
	unsigned int usb_phy3_base_addr;
};

//struct amlogic_usb_config amlogic_usb_config_gxl;

#define BOARD_USB_MODE_HOST	0
#define BOARD_USB_MODE_SLAVE	1
#define BOARD_USB_MODE_CHARGER	2
#define BOARD_USB_MODE_MAX	3
struct amlogic_usb_config * board_usb_start(int mode,int index);
int board_usb_stop(int mode,int index);
void board_usb_init(struct amlogic_usb_config * usb_cfg,int mode);
int get_usb_count(void);
#endif

