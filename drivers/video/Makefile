#
# (C) Copyright 2000-2007
# Wolfgang Denk, DENX Software Engineering, wd@denx.de.
#
# See file CREDITS for list of people who contributed to this
# project.
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2 of
# the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston,
# MA 02111-1307 USA
#

include $(TOPDIR)/config.mk

LIB	:= $(obj)libvideo.o

COBJS-$(CONFIG_ATI_RADEON_FB) += ati_radeon_fb.o videomodes.o
COBJS-$(CONFIG_ATMEL_LCD) += atmel_lcdfb.o
COBJS-$(CONFIG_CFB_CONSOLE) += cfb_console.o
COBJS-$(CONFIG_FSL_DIU_FB) += fsl_diu_fb.o
COBJS-$(CONFIG_S6E63D6) += s6e63d6.o
COBJS-$(CONFIG_VIDEO_AMBA) += amba.o
COBJS-$(CONFIG_VIDEO_CT69000) += ct69000.o videomodes.o
COBJS-$(CONFIG_VIDEO_MB862xx) += mb862xx.o videomodes.o
COBJS-$(CONFIG_VIDEO_MB86R0xGDC) += mb86r0xgdc.o videomodes.o
COBJS-$(CONFIG_VIDEO_MX3) += mx3fb.o
COBJS-$(CONFIG_VIDEO_MX5) += mxc_ipuv3_fb.o ipu_common.o ipu_disp.o
COBJS-$(CONFIG_VIDEO_SED13806) += sed13806.o
COBJS-$(CONFIG_SED156X) += sed156x.o
COBJS-$(CONFIG_VIDEO_SM501) += sm501.o
COBJS-$(CONFIG_VIDEO_SMI_LYNXEM) += smiLynxEM.o videomodes.o
COBJS-$(CONFIG_VIDEO_VCXK) += bus_vcxk.o

ifdef CONFIG_AML_MESON
ifdef CONFIG_M3_WA_REF_V1
COBJS-$(CONFIG_VIDEO_AML) += aml_video.o \
	osd/canvas.o \
	osd/m3_osd_hw.o
else ifdef CONFIG_AML_MESON_8
COBJS-$(CONFIG_VIDEO_AML) += aml_video.o \
	osd/canvas.o \
	osd/m8_osd_hw.o
else
COBJS-$(CONFIG_VIDEO_AML) += aml_video.o \
	osd/canvas.o \
	osd/osd_hw.o
endif
COBJS-$(CONFIG_VIDEO_AMLLCD) += lcd/aml_lcd.o
COBJS-$(CONFIG_VIDEO_AMLLCD) += lcd/lcdoutc.o
COBJS-$(CONFIG_AML_LCD_EXTERN_I2C_TC101) += lcd/lcd_extern/i2c_tc101.o
COBJS-$(CONFIG_AML_LCD_EXTERN_SPI_LD070WS2) += lcd/lcd_extern/spi_LD070WS2.o
COBJS-$(CONFIG_AML_LCD_EXTERN_MIPI_N070ICN) += lcd/lcd_extern/mipi_N070ICN.o
COBJS-$(CONFIG_AML_BL_EXTERN_PMU_AML1218) += lcd/bl_extern/pmu_aml1218.o
COBJS-$(CONFIG_AML_BL_EXTERN_I2C_LP8556) += lcd/bl_extern/i2c_lp8556.o
COBJS-$(CONFIG_AML_BL_EXTERN_MIPI_LT070ME05) += lcd/bl_extern/mipi_LT070ME05.o
COBJS-$(CONFIG_VIDEO_AMLTVOUT) += tvout/aml_tvout.o  \
	tvout/tv_out.o

ifdef CONFIG_AML_HDMI_TX
#ifdef CONFIG_AML_MESON_8
COBJS-$(CONFIG_VIDEO_AMLTVOUT) += tvout/hdmi_tx.o
#endif
#ifdef CONFIG_AML_MESON_6
#COBJS-$(CONFIG_VIDEO_AMLTVOUT) += tvout/hdmi_tx_meson.o \
#	tvout/hdmi_tx_reg.o \
#	tvout/hdmi_tx.o \
#	tvout/hdmi_tx_edid.o \
#	tvout/hdmi_tx_video.o \
#	tvout/enc_clk_config.o
#endif
endif
endif

COBJS	:= $(COBJS-y)
SRCS	:= $(COBJS:.o=.c)
OBJS	:= $(addprefix $(obj),$(COBJS))

all:	$(LIB)

$(LIB):	$(obj).depend $(OBJS)
	$(call cmd_link_o_target, $(OBJS))

#########################################################################

# defines $(obj).depend target
include $(SRCTREE)/rules.mk

sinclude $(obj).depend

#########################################################################
