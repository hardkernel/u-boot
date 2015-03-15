include $(buildsrc)/config.mk
include $(buildtree)/include/autoconf.mk
include $(buildtree)/.config

ARMCC_$(CONFIG_ENABLE_ARMCC_DEBUGROM)=$(shell echo __CC_ARM | armcc -E -  | tail -n 1)
ifneq ($(ARMCC_y),)
targetComplier=arm
else
targetComplier=gcc
endif

MAKEFLAGS += --no-print-directory

.PHONY: all clean realclean distclean

all:
ifdef CONFIG_AML_SMP
	./bin2code smp_code $(srctree)/$(CPUDIR)/$(SOC)/firmware/smp.bin $(srctree)/$(CPUDIR)/$(SOC)/firmware/smp.dat
endif
	$(Q)$(MAKE) -f Makefile.$(targetComplier)

#ifndef CONFIG_M3
#	$(MAKE) -f Makefile.ddr_init
#endif

ifdef CONFIG_AML_EXT_PGM
	$(MAKE) -f Makefile.ft
endif

ifdef CONFIG_AML_SECU_BOOT_V2
	$(MAKE) -f Makefile.usb
endif
ifeq ($(CONFIG_CMD_RUNARC),y)
	$(MAKE) -f Makefile.rbt
endif

ifeq ($(CONFIG_AML_SUSPEND),y)
ifneq ($(CONFIG_MESON_TRUSTZONE),y)
	$(MAKE) -f Makefile.krbt
endif
endif

realclean distclean:
	$(Q)$(MAKE) -f Makefile.$(targetComplier) distclean