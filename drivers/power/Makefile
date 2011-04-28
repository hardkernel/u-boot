#
# Copyright (c) 2009 Wind River Systems, Inc.
# Tom Rix <Tom.Rix at windriver.com>
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
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston,
# MA 02111-1307 USA
#

include $(TOPDIR)/config.mk

LIB 	:= $(obj)libpower.o

COBJS-$(CONFIG_FTPMU010_POWER)	+= ftpmu010.o
COBJS-$(CONFIG_TWL4030_POWER)	+= twl4030.o
COBJS-$(CONFIG_TWL6030_POWER)	+= twl6030.o
COBJS-$(CONFIG_AW_AXP20) += axp_power/axp_power.o axp_power/axp20-sply.o axp_power/axp20-gpio.o
COBJS-$(CONFIG_AML_PMU) += aml_pmu.o
COBJS-$(CONFIG_RN5T618) += rn5t618.o
COBJS-$(CONFIG_AML1216)  += aml_1216.o
COBJS-$(CONFIG_AML1218)  += aml_1218.o
COBJS-$(CONFIG_UBOOT_BATTERY_PARAMETERS) += battery_parameter.o 

COBJS	:= $(COBJS-y)
SRCS 	:= $(COBJS:.o=.c)
OBJS 	:= $(addprefix $(obj),$(COBJS))

all:	$(LIB)

$(LIB):	$(obj).depend $(OBJS)
	$(call cmd_link_o_target, $(OBJS))


#########################################################################

# defines $(obj).depend target
include $(SRCTREE)/rules.mk

sinclude $(obj).depend

########################################################################
