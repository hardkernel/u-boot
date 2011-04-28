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

COBJS-$(CONFIG_USB_DWC_OTG_HCD) += usb.o

COBJS	= clock.o $(COBJS-y)
SOBJS := mmutable.o

COBJS-$(CONFIG_AML_ETHERNET) += aml_eth_clk_set.o aml_eth_pinmux.o

COBJS-$(CONFIG_AML_RTC)+=aml_rtc_setting.o

SRCS	:= $(SOBJS:.o=.S) $(COBJS:.o=.c) $(COBJS-y:.o=.c)
OBJS	:= $(addprefix $(obj),$(SOBJS) $(COBJS))

all:	$(obj).depend $(LIB)

$(LIB):	$(OBJS)
	$(call cmd_link_o_target, $(OBJS))

#########################################################################

# defines $(obj).depend target
include $(SRCTREE)/rules.mk

sinclude $(obj).depend

#########################################################################
