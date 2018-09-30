
/*
 * drivers/display/lcd/aml_lcd_reg.h
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
*/

#ifndef __AML_LCD_REG_H__
#define __AML_LCD_REG_H__
#include <asm/arch/io.h>
#include <asm/arch/secure_apb.h>
#include <asm/arch/cpu.h>
#include "aml_lcd_dummy_reg.h"

/* ********************************
 * register define
 * ********************************* */
/* base & offset */
#define REG_OFFSET_CBUS(reg)            ((reg) << 2)
#define REG_OFFSET_VCBUS(reg)           ((reg) << 2)
#define REG_OFFSET_DSI_HOST(reg)        ((reg) << 2)
#define REG_OFFSET_TCON_APB(reg)        ((reg) << 2)
#define REG_OFFSET_TCON_APB_BYTE(reg)   (reg)

/* memory mapping */
#define REG_ADDR_AOBUS(reg)             (reg + 0L)
#define REG_ADDR_PERIPHS(reg)           (reg + 0L)
#define REG_ADDR_CBUS(reg)              (REG_BASE_CBUS + REG_OFFSET_CBUS(reg))
#define REG_ADDR_HIU(reg)               (reg + 0L)
#define REG_ADDR_VCBUS(reg)             (REG_BASE_VCBUS + REG_OFFSET_VCBUS(reg))
#define REG_ADDR_DSI_HOST(reg)          (REG_BASE_DSI_HOST + REG_OFFSET_DSI_HOST(reg))
#define REG_ADDR_DSI_PHY(reg)           (reg + 0L)
#define REG_ADDR_TCON_APB(reg)          (REG_TCON_APB_BASE + REG_OFFSET_TCON_APB(reg))
#define REG_ADDR_TCON_APB_BYTE(reg)     (REG_TCON_APB_BASE + REG_OFFSET_TCON_APB_BYTE(reg))


#if (defined(CONFIG_CHIP_AML_GXB) || \
		defined(CONFIG_AML_MESON_GXTVBB))
#define HHI_HPLL_CNTL                           HHI_HDMI_PLL_CNTL
#define HHI_HPLL_CNTL2                          HHI_HDMI_PLL_CNTL2
#define HHI_HPLL_CNTL3                          HHI_HDMI_PLL_CNTL3
#define HHI_HPLL_CNTL4                          HHI_HDMI_PLL_CNTL4
#define HHI_HPLL_CNTL5                          HHI_HDMI_PLL_CNTL5
#define HHI_HPLL_CNTL6                          HHI_HDMI_PLL_CNTL6
#else
#define HHI_HPLL_CNTL                           HHI_HDMI_PLL_CNTL
#define HHI_HPLL_CNTL2                          HHI_HDMI_PLL_CNTL1
#define HHI_HPLL_CNTL3                          HHI_HDMI_PLL_CNTL2
#define HHI_HPLL_CNTL4                          HHI_HDMI_PLL_CNTL3
#define HHI_HPLL_CNTL5                          HHI_HDMI_PLL_CNTL4
#define HHI_HPLL_CNTL6                          HHI_HDMI_PLL_CNTL5
#endif

#define LVDS_CH_SWAP0                           LVDS_PHY_CNTL0
#define LVDS_CH_SWAP1                           LVDS_PHY_CNTL1
#define LVDS_CH_SWAP2                           LVDS_PHY_CNTL2



/*#define HHI_VIID_CLK_DIV     	0x4a*/
#define DAC0_CLK_SEL           28
#define DAC1_CLK_SEL           24
#define DAC2_CLK_SEL           20
#define VCLK2_XD_RST           17
#define VCLK2_XD_EN            16
#define ENCL_CLK_SEL           12
#define VCLK2_XD                0

/*#define HHI_VIID_CLK_CNTL    	0x4b*/
#define VCLK2_EN               19
#define VCLK2_CLK_IN_SEL       16
#define VCLK2_SOFT_RST         15
#define VCLK2_DIV12_EN          4
#define VCLK2_DIV6_EN           3
#define VCLK2_DIV4_EN           2
#define VCLK2_DIV2_EN           1
#define VCLK2_DIV1_EN           0

/*#define HHI_VIID_DIVIDER_CNTL  0x4c*/
#define DIV_CLK_IN_EN          16
#define DIV_CLK_SEL            15
#define DIV_POST_TCNT          12
#define DIV_LVDS_CLK_EN        11
#define DIV_LVDS_DIV2          10
#define DIV_POST_SEL            8
#define DIV_POST_SOFT_RST       7
#define DIV_PRE_SEL             4
#define DIV_PRE_SOFT_RST        3
#define DIV_POST_RST            1
#define DIV_PRE_RST             0

/*#define HHI_VID_CLK_DIV        0x59*/
#define ENCI_CLK_SEL           28
#define ENCP_CLK_SEL           24
#define ENCT_CLK_SEL           20
#define VCLK_XD_RST            17
#define VCLK_XD_EN             16
#define ENCL_CLK_SEL           12
#define VCLK_XD1                8
#define VCLK_XD0                0

/*#define HHI_VID_CLK_CNTL2        0x65*/
#define HDMI_TX_PIXEL_GATE_VCLK  5
#define VDAC_GATE_VCLK           4
#define ENCL_GATE_VCLK           3
#define ENCP_GATE_VCLK           2
#define ENCT_GATE_VCLK           1
#define ENCI_GATE_VCLK           0

/* ********************************
 * register access api
 * ********************************* */
/* use offset address */
static inline unsigned int lcd_hiu_read(unsigned int _reg)
{
	return *(volatile unsigned int *)(REG_ADDR_HIU(_reg));
};

static inline void lcd_hiu_write(unsigned int _reg, unsigned int _value)
{
	*(volatile unsigned int *)REG_ADDR_HIU(_reg) = (_value);
};

static inline void lcd_hiu_setb(unsigned int _reg, unsigned int _value,
		unsigned int _start, unsigned int _len)
{
	lcd_hiu_write(_reg, ((lcd_hiu_read(_reg) &
			~(((1L << (_len))-1) << (_start))) |
			(((_value)&((1L<<(_len))-1)) << (_start))));
}

static inline unsigned int lcd_hiu_getb(unsigned int _reg,
		unsigned int _start, unsigned int _len)
{
	return (lcd_hiu_read(_reg) >> (_start)) & ((1L << (_len)) - 1);
}

static inline void lcd_hiu_set_mask(unsigned int _reg, unsigned int _mask)
{
	lcd_hiu_write(_reg, (lcd_hiu_read(_reg) | (_mask)));
}

static inline void lcd_hiu_clr_mask(unsigned int _reg, unsigned int _mask)
{
	lcd_hiu_write(_reg, (lcd_hiu_read(_reg) & (~(_mask))));
}

static inline unsigned int lcd_cbus_read(unsigned int _reg)
{
	return (*(volatile unsigned int *)REG_ADDR_CBUS(_reg));
};

static inline void lcd_cbus_write(unsigned int _reg, unsigned int _value)
{
	*(volatile unsigned int *)REG_ADDR_CBUS(_reg) = (_value);
};

static inline void lcd_cbus_setb(unsigned int _reg, unsigned int _value,
		unsigned int _start, unsigned int _len)
{
	lcd_cbus_write(_reg, ((lcd_cbus_read(_reg) &
			~(((1L << (_len))-1) << (_start))) |
			(((_value)&((1L<<(_len))-1)) << (_start))));
}

static inline unsigned int lcd_cbus_getb(unsigned int _reg,
		unsigned int _start, unsigned int _len)
{
	return (lcd_cbus_read(_reg) >> (_start)) & ((1L << (_len)) - 1);
}

static inline void lcd_cbus_set_mask(unsigned int _reg, unsigned int _mask)
{
	lcd_cbus_write(_reg, (lcd_cbus_read(_reg) | (_mask)));
}

static inline void lcd_cbus_clr_mask(unsigned int _reg, unsigned int _mask)
{
	lcd_cbus_write(_reg, (lcd_cbus_read(_reg) & (~(_mask))));
}

static inline unsigned int lcd_vcbus_read(unsigned int _reg)
{
	return (*(volatile unsigned int *)REG_ADDR_VCBUS(_reg));
};

static inline void lcd_vcbus_write(unsigned int _reg, unsigned int _value)
{
	*(volatile unsigned int *)REG_ADDR_VCBUS(_reg) = (_value);
};

static inline void lcd_vcbus_setb(unsigned int _reg, unsigned int _value,
		unsigned int _start, unsigned int _len)
{
	lcd_vcbus_write(_reg, ((lcd_vcbus_read(_reg) &
			~(((1L << (_len))-1) << (_start))) |
			(((_value)&((1L<<(_len))-1)) << (_start))));
}

static inline unsigned int lcd_vcbus_getb(unsigned int _reg,
		unsigned int _start, unsigned int _len)
{
	return (lcd_vcbus_read(_reg) >> (_start)) & ((1L << (_len)) - 1);
}

static inline void lcd_vcbus_set_mask(unsigned int _reg, unsigned int _mask)
{
	lcd_vcbus_write(_reg, (lcd_vcbus_read(_reg) | (_mask)));
}

static inline void lcd_vcbus_clr_mask(unsigned int _reg, unsigned int _mask)
{
	lcd_vcbus_write(_reg, (lcd_vcbus_read(_reg) & (~(_mask))));
}

static inline unsigned int lcd_aobus_read(unsigned int _reg)
{
	return (*(volatile unsigned int *)REG_ADDR_AOBUS(_reg));
};

static inline void lcd_aobus_write(unsigned int _reg, unsigned int _value)
{
	*(volatile unsigned int *)REG_ADDR_AOBUS(_reg) = (_value);
};

static inline void lcd_aobus_setb(unsigned int _reg, unsigned int _value,
		unsigned int _start, unsigned int _len)
{
	lcd_aobus_write(_reg, ((lcd_aobus_read(_reg) &
			~(((1L << (_len))-1) << (_start))) |
			(((_value)&((1L<<(_len))-1)) << (_start))));
}

static inline unsigned int lcd_aobus_getb(unsigned int _reg,
		unsigned int _start, unsigned int _len)
{
	return (lcd_aobus_read(_reg) & (((1L << (_len)) - 1) << (_start)));
}

static inline unsigned int lcd_periphs_read(unsigned int _reg)
{
	return (*(volatile unsigned int *)REG_ADDR_PERIPHS(_reg));
};

static inline void lcd_periphs_write(unsigned int _reg, unsigned int _value)
{
	*(volatile unsigned int *)REG_ADDR_PERIPHS(_reg) = (_value);
};

static inline void lcd_periphs_setb(unsigned int _reg, unsigned int _value,
		unsigned int _start, unsigned int _len)
{
	lcd_periphs_write(_reg, ((lcd_periphs_read(_reg) &
			~(((1L << (_len))-1) << (_start))) |
			(((_value)&((1L<<(_len))-1)) << (_start))));
}

static inline unsigned int lcd_periphs_getb(unsigned int _reg,
		unsigned int _start, unsigned int _len)
{
	return (lcd_periphs_read(_reg) & (((1L << (_len)) - 1) << (_start)));
}

static inline void lcd_pinmux_set_mask(unsigned int n, unsigned int _mask)
{
	unsigned int _reg = PERIPHS_PIN_MUX_0;

	if (n > 15)
		return;

	_reg += (n << 2);
	lcd_periphs_write(_reg, (lcd_periphs_read(_reg) | (_mask)));
}

static inline void lcd_pinmux_clr_mask(unsigned int n, unsigned int _mask)
{
	unsigned int _reg = PERIPHS_PIN_MUX_0;

	if (n > 15)
		return;

	_reg += (n << 2);
	lcd_periphs_write(_reg, (lcd_periphs_read(_reg) & (~(_mask))));
}

static inline unsigned int dsi_host_read(unsigned int _reg)
{
	return *(volatile unsigned int *)(REG_ADDR_DSI_HOST(_reg));
};

static inline void dsi_host_write(unsigned int _reg, unsigned int _value)
{
	*(volatile unsigned int *)REG_ADDR_DSI_HOST(_reg) = (_value);
};

static inline void dsi_host_setb(unsigned int _reg, unsigned int _value,
		unsigned int _start, unsigned int _len)
{
	dsi_host_write(_reg, ((dsi_host_read(_reg) &
			~(((1L << (_len))-1) << (_start))) |
			(((_value)&((1L<<(_len))-1)) << (_start))));
}

static inline unsigned int dsi_host_getb(unsigned int _reg,
		unsigned int _start, unsigned int _len)
{
	return (dsi_host_read(_reg) >> (_start)) & ((1L << (_len)) - 1);
}

static inline void dsi_host_set_mask(unsigned int _reg, unsigned int _mask)
{
	dsi_host_write(_reg, (dsi_host_read(_reg) | (_mask)));
}

static inline void dsi_host_clr_mask(unsigned int _reg, unsigned int _mask)
{
	dsi_host_write(_reg, (dsi_host_read(_reg) & (~(_mask))));
}

static inline unsigned int dsi_phy_read(unsigned int _reg)
{
	return *(volatile unsigned int *)(REG_ADDR_DSI_PHY(_reg));
};

static inline void dsi_phy_write(unsigned int _reg, unsigned int _value)
{
	*(volatile unsigned int *)REG_ADDR_DSI_PHY(_reg) = (_value);
};

static inline void dsi_phy_setb(unsigned int _reg, unsigned int _value,
		unsigned int _start, unsigned int _len)
{
	dsi_phy_write(_reg, ((dsi_phy_read(_reg) &
			~(((1L << (_len))-1) << (_start))) |
			(((_value)&((1L<<(_len))-1)) << (_start))));
}

static inline unsigned int dsi_phy_getb(unsigned int _reg,
		unsigned int _start, unsigned int _len)
{
	return (dsi_phy_read(_reg) >> (_start)) & ((1L << (_len)) - 1);
}

static inline void dsi_phy_set_mask(unsigned int _reg, unsigned int _mask)
{
	dsi_phy_write(_reg, (dsi_phy_read(_reg) | (_mask)));
}

static inline void dsi_phy_clr_mask(unsigned int _reg, unsigned int _mask)
{
	dsi_phy_write(_reg, (dsi_phy_read(_reg) & (~(_mask))));
}

static inline unsigned int lcd_tcon_read(unsigned int _reg)
{
	return *(volatile unsigned int *)(REG_ADDR_TCON_APB(_reg));
};

static inline void lcd_tcon_write(unsigned int _reg, unsigned int _value)
{
	*(volatile unsigned int *)REG_ADDR_TCON_APB(_reg) = (_value);
};

static inline void lcd_tcon_setb(unsigned int _reg, unsigned int _value,
		unsigned int _start, unsigned int _len)
{
	lcd_tcon_write(_reg, ((lcd_tcon_read(_reg) &
			~(((1L << (_len))-1) << (_start))) |
			(((_value)&((1L<<(_len))-1)) << (_start))));
}

static inline unsigned int lcd_tcon_getb(unsigned int _reg,
		unsigned int _start, unsigned int _len)
{
	return (lcd_tcon_read(_reg) >> (_start)) & ((1L << (_len)) - 1);
}

static inline void lcd_tcon_set_mask(unsigned int _reg, unsigned int _mask)
{
	lcd_tcon_write(_reg, (lcd_tcon_read(_reg) | (_mask)));
}

static inline void lcd_tcon_clr_mask(unsigned int _reg, unsigned int _mask)
{
	lcd_tcon_write(_reg, (lcd_tcon_read(_reg) & (~(_mask))));
}

static inline unsigned char lcd_tcon_read_byte(unsigned int _reg)
{
	return *(volatile unsigned char *)(REG_ADDR_TCON_APB_BYTE(_reg));
};

static inline void lcd_tcon_write_byte(unsigned int _reg, unsigned char _value)
{
	*(volatile unsigned char *)REG_ADDR_TCON_APB_BYTE(_reg) = (_value);
};

static inline void lcd_tcon_setb_byte(unsigned int _reg, unsigned char _value,
		unsigned int _start, unsigned int _len)
{
	lcd_tcon_write_byte(_reg, ((lcd_tcon_read_byte(_reg) &
			~(((1L << (_len))-1) << (_start))) |
			(((_value)&((1L<<(_len))-1)) << (_start))));
}

static inline unsigned char lcd_tcon_getb_byte(unsigned int _reg,
		unsigned int _start, unsigned int _len)
{
	return (lcd_tcon_read_byte(_reg) >> (_start)) & ((1L << (_len)) - 1);
}

#endif
