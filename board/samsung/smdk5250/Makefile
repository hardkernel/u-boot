#
# (C) Copyright 2000, 2001, 2002
# Wolfgang Denk, DENX Software Engineering, wd@denx.de.
#
# (C) Copyright 2008
# Guennadi Liakhovetki, DENX Software Engineering, <lg@denx.de>
#
# (C) Copyright 2011 Samsung Electronics Co. Ltd
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
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston,
# MA 02111-1307 USA
#

include $(TOPDIR)/config.mk

LIB	= $(obj)lib$(BOARD).o

SOBJS-y	:= lowlevel_init.o
COBJS-y	:= pmic.o
COBJS-y	+= smc.o
ifdef CONFIG_CPU_EXYNOS5250_EVT1
SOBJS-y	+= clock_init_smdk5250.o
SOBJS-y	+= mem_init_smdk5250.o
COBJS-y	+= dmc_init.o
else
SOBJS-y	+= clock_init_smdk5250_evt0.o
SOBJS-$(CONFIG_LPDDR2)	+= mem_init_lpddr2_evt0.o
SOBJS-$(CONFIG_LPDDR3)	+= mem_init_lpddr3_evt0.o
SOBJS-$(CONFIG_DDR3)	+= mem_init_ddr3_evt0.o
endif
COBJS-y	+= smdk5250.o

SRCS    := $(SOBJS-y:.o=.S) $(COBJS-y:.o=.c)
OBJS	:= $(addprefix $(obj),$(COBJS-y))
SOBJS	:= $(addprefix $(obj),$(SOBJS-y))

$(LIB):	$(obj).depend $(SOBJS) $(OBJS)
	$(call cmd_link_o_target, $(SOBJS) $(OBJS))

clean:
	rm -f $(SOBJS) $(OBJS)

distclean:	clean
	rm -f $(LIB) core *.bak $(obj).depend

#########################################################################

# defines $(obj).depend target
include $(SRCTREE)/rules.mk

sinclude $(obj).depend

#########################################################################
