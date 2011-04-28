#
# (C) Copyright 2000-2011
# Jerry Yu , Amlogic  Engineering, jerry.yu@amlogic.com.
#
# (C) Copyright 2011 Amlogic Semiconductor, Inc.
#
#

include $(TOPDIR)/config.mk

LIB	= $(obj)lib$(SOC).o

COBJS-$(CONFIG_AML_SDIO)+=sdio.o
COBJS-$(CONFIG_CMD_RUNARC)+=cmd_arc.o
COBJS-$(CONFIG_DSP_VSYNC_INTERRUPT) += dsp.o
COBJS	= clock.o gpio.o pinmux.o $(COBJS-y)
COBJS  += m6_secure.o
SOBJS := mmutable.o

COBJS-$(CONFIG_AML_ETHERNET) += aml_eth_clk_set.o aml_eth_pinmux.o

COBJS-$(CONFIG_AML_RTC)+=aml_rtc_setting.o

COBJS-$(CONFIG_USB_DWC_OTG_HCD) += usb.o

COBJS-$(CONFIG_VIDEO_AMLLCD) += aml_lcd_gpio.o
COBJS-$(CONFIG_VIDEO_AMLLCD) += lcd/lcd_config.o
COBJS += hdmi_tx_hdcp.o
COBJS-$(CONFIG_AML_HDMI_TX) += hdmi_tx_set.o enc_clk_config.o


ifdef CONFIG_AML_SUSPEND
COBJS += suspend.o
ifndef CONFIG_MESON_TRUSTZONE
COBJS += firmwareld.o
endif
endif

ifdef CONFIG_MESON_TRUSTZONE
COBJS += trustzone.o
endif

ifdef CONFIG_AML_SECURE
COBJS += secure_firmwareld.o
endif

SRCS	:= $(SOBJS:.o=.S) $(COBJS:.o=.c) $(COBJS-y:.o=.c)
OBJS	:= $(addprefix $(obj),$(SOBJS) $(COBJS))

all:	dsp_firmware $(obj).depend $(LIB) 

$(LIB):	$(OBJS)	
	$(call cmd_link_o_target, $(OBJS))	

ifndef CONFIG_MESON_TRUSTZONE

ifdef CONFIG_AML_SUSPEND
FIRMWARE_AUTO_UPDATE=y
export FIRMWARE_AUTO_UPDATE
$(OBJS): power_firmware.dat
power_firmware.dat: arc_code
		make -C $(SRCTREE)/$(CPUDIR)/$(SOC)/firmware/appf

arc_code:
		make -C $(SRCTREE)/$(CPUDIR)/$(SOC)/firmware/arc_power

endif


endif


.PHONY: dsp_firmware
ifdef CONFIG_DSP_VSYNC_INTERRUPT
dsp_firmware:
	make -C $(SRCTREE)/$(CPUDIR)/$(SOC)/dsp_firmware
else
dsp_firmware:
endif

#########################################################################

# defines $(obj).depend target
include $(SRCTREE)/rules.mk

sinclude $(obj).depend

#########################################################################
