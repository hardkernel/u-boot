#
# (C) Copyright 2000-2006
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

#########################################################################

ifneq ($(OBJTREE),$(SRCTREE))
ifeq ($(CURDIR),$(SRCTREE))
dir :=
else
dir := $(subst $(SRCTREE)/,,$(CURDIR))
endif

obj := $(if $(dir),$(OBJTREE)/$(dir)/,$(OBJTREE)/)
src := $(if $(dir),$(SRCTREE)/$(dir)/,$(SRCTREE)/)

$(shell mkdir -p $(obj))
else
obj :=
src :=
endif

# clean the slate ...
PLATFORM_RELFLAGS =
PLATFORM_CPPFLAGS =
PLATFORM_LDFLAGS =

#########################################################################

override HOSTCFLAGS	= -Wall -Wstrict-prototypes -O2 -fomit-frame-pointer -std=gnu89\
			  $(HOSTCPPFLAGS)
HOSTSTRIP	= strip

#
# Mac OS X / Darwin's C preprocessor is Apple specific.  It
# generates numerous errors and warnings.  We want to bypass it
# and use GNU C's cpp.	To do this we pass the -traditional-cpp
# option to the compiler.  Note that the -traditional-cpp flag
# DOES NOT have the same semantics as GNU C's flag, all it does
# is invoke the GNU preprocessor in stock ANSI/ISO C fashion.
#
# Apple's linker is similar, thanks to the new 2 stage linking
# multiple symbol definitions are treated as errors, hence the
# -multiply_defined suppress option to turn off this error.
#

ifeq ($(HOSTOS),darwin)
# get major and minor product version (e.g. '10' and '6' for Snow Leopard)
DARWIN_MAJOR_VERSION	= $(shell sw_vers -productVersion | cut -f 1 -d '.')
DARWIN_MINOR_VERSION	= $(shell sw_vers -productVersion | cut -f 2 -d '.')

os_x_before	= $(shell if [ $(DARWIN_MAJOR_VERSION) -le $(1) -a \
	$(DARWIN_MINOR_VERSION) -le $(2) ] ; then echo "$(3)"; else echo "$(4)"; fi ;)

# Snow Leopards build environment has no longer restrictions as described above
HOSTCC		 = $(call os_x_before, 10, 5, "cc", "gcc")
HOSTCFLAGS	+= $(call os_x_before, 10, 4, "-traditional-cpp")
HOSTLDFLAGS	+= $(call os_x_before, 10, 5, "-multiply_defined suppress")
else
HOSTCC		= gcc
endif

ifeq ($(HOSTOS),cygwin)
HOSTCFLAGS	+= -ansi
endif

# We build some files with extra pedantic flags to try to minimize things
# that won't build on some weird host compiler -- though there are lots of
# exceptions for files that aren't complaint.

HOSTCFLAGS_NOPED = $(filter-out -pedantic,$(HOSTCFLAGS))
#HOSTCFLAGS	+= -pedantic

#########################################################################
#
# Option checker (courtesy linux kernel) to ensure
# only supported compiler options are used
#
cc-option = $(shell if $(CC) $(CFLAGS) $(1) -S -o /dev/null -xc /dev/null \
		> /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)

#
# Include the make variables (CC, etc...)
#
AS	= $(CROSS_COMPILE)as
LD	= $(CROSS_COMPILE)ld
CC	= $(CROSS_COMPILE)gcc
CPP	= $(CC) -E
AR	= $(CROSS_COMPILE)ar
NM	= $(CROSS_COMPILE)nm
LDR	= $(CROSS_COMPILE)ldr
STRIP	= $(CROSS_COMPILE)strip
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJDUMP = $(CROSS_COMPILE)objdump
RANLIB	= $(CROSS_COMPILE)RANLIB
MKDIR	= mkdir
#########################################################################

# Load generated board configuration
sinclude $(OBJTREE)/include/autoconf.mk
sinclude $(OBJTREE)/include/config.mk

# Some architecture config.mk files need to know what CPUDIR is set to,
# so calculate CPUDIR before including ARCH/SOC/CPU config.mk files.
# Check if arch/$ARCH/cpu/$CPU exists, otherwise assume arch/$ARCH/cpu contains
# CPU-specific code.
CPUDIR=arch/$(ARCH)/cpu/$(CPU)

ifneq ($(SRCTREE)/$(CPUDIR),$(wildcard $(SRCTREE)/$(CPUDIR)))
CPUDIR=arch/$(ARCH)/cpu
endif
sinclude $(TOPDIR)/arch/$(ARCH)/config.mk	# include architecture dependend rules
sinclude $(TOPDIR)/$(CPUDIR)/config.mk		# include  CPU	specific rules

ifdef	SOC
sinclude $(TOPDIR)/$(CPUDIR)/$(SOC)/config.mk	# include  SoC	specific rules
endif
ifdef	VENDOR
BOARDDIR = $(VENDOR)/$(BOARD)
else
BOARDDIR = $(BOARD)
endif
ifdef	BOARD
sinclude $(TOPDIR)/board/$(BOARDDIR)/config.mk	# include board specific rules
endif

#########################################################################

ifneq (,$(findstring s,$(MAKEFLAGS)))
ARFLAGS = cr
else
ARFLAGS = crv
endif
RELFLAGS= $(PLATFORM_RELFLAGS)
DBGFLAGS= -g # -DDEBUG
OPTFLAGS= -Os #-fomit-frame-pointer
ifndef LDSCRIPT
#LDSCRIPT := $(TOPDIR)/board/$(BOARDDIR)/u-boot.lds.debug
ifeq ($(CONFIG_NAND_U_BOOT),y)
LDSCRIPT := $(TOPDIR)/board/$(BOARDDIR)/u-boot-nand.lds
else
LDSCRIPT := $(TOPDIR)/board/$(BOARDDIR)/u-boot.lds
endif
endif
OBJCFLAGS += --gap-fill=0xff

gccincdir := $(shell $(CC) -print-file-name=include)

CPPFLAGS := $(DBGFLAGS) $(OPTFLAGS) $(RELFLAGS)		\
	-D__KERNEL__
ifneq ($(CONFIG_SYS_TEXT_BASE),)
CPPFLAGS += -DCONFIG_SYS_TEXT_BASE=$(CONFIG_SYS_TEXT_BASE)
endif

ifneq ($(RESET_VECTOR_ADDRESS),)
CPPFLAGS += -DRESET_VECTOR_ADDRESS=$(RESET_VECTOR_ADDRESS)
endif

ifneq ($(OBJTREE),$(SRCTREE))
CPPFLAGS += -I$(OBJTREE)/include2 -I$(OBJTREE)/include
endif

CPPFLAGS += -I$(TOPDIR)/include
CPPFLAGS += -fno-builtin -ffreestanding -nostdinc	\
	-isystem $(gccincdir) -pipe $(PLATFORM_CPPFLAGS)

ifdef BUILD_TAG
CFLAGS := $(CPPFLAGS) -Wall -Wstrict-prototypes \
	-DBUILD_TAG='"$(BUILD_TAG)"'
else
CFLAGS := $(CPPFLAGS) -Wall -Wstrict-prototypes
endif

CFLAGS += $(call cc-option,-fno-stack-protector) -std=gnu89

# $(CPPFLAGS) sets -g, which causes gcc to pass a suitable -g<format>
# option to the assembler.
AFLAGS_DEBUG :=

# turn jbsr into jsr for m68k
ifeq ($(ARCH),m68k)
ifeq ($(findstring 3.4,$(shell $(CC) --version)),3.4)
AFLAGS_DEBUG := -Wa,-gstabs,-S
endif
endif

AFLAGS := $(AFLAGS_DEBUG) -D__ASSEMBLY__ $(CPPFLAGS)

LDFLAGS += $(PLATFORM_LDFLAGS)
LDFLAGS_FINAL += -Bstatic

LDFLAGS_u-boot += -T $(obj)u-boot.lds $(LDFLAGS_FINAL)
ifneq ($(CONFIG_SYS_TEXT_BASE),)
LDFLAGS_u-boot += -Ttext $(CONFIG_SYS_TEXT_BASE)
endif

# Location of a usable BFD library, where we define "usable" as
# "built for ${HOST}, supports ${TARGET}".  Sensible values are
# - When cross-compiling: the root of the cross-environment
# - Linux/ppc (native): /usr
# - NetBSD/ppc (native): you lose ... (must extract these from the
#   binutils build directory, plus the native and U-Boot include
#   files don't like each other)
#
# So far, this is used only by tools/gdb/Makefile.

ifeq ($(HOSTOS),darwin)
BFD_ROOT_DIR =		/usr/local/tools
else
ifeq ($(HOSTARCH),$(ARCH))
# native
BFD_ROOT_DIR =		/usr
else
#BFD_ROOT_DIR =		/LinuxPPC/CDK		# Linux/i386
#BFD_ROOT_DIR =		/usr/pkg/cross		# NetBSD/i386
BFD_ROOT_DIR =		/opt/powerpc
endif
endif

#########################################################################

export	HOSTCC HOSTCFLAGS HOSTLDFLAGS PEDCFLAGS HOSTSTRIP CROSS_COMPILE \
	AS LD CC CPP AR NM STRIP OBJCOPY OBJDUMP MAKE
export	CONFIG_SYS_TEXT_BASE PLATFORM_CPPFLAGS PLATFORM_RELFLAGS CPPFLAGS CFLAGS AFLAGS

#########################################################################

# Allow boards to use custom optimize flags on a per dir/file basis
BCURDIR = $(subst $(SRCTREE)/,,$(CURDIR:$(obj)%=%))
ALL_AFLAGS = $(AFLAGS) $(AFLAGS_$(BCURDIR)/$(@F)) $(AFLAGS_$(BCURDIR))
ALL_CFLAGS = $(CFLAGS) $(CFLAGS_$(BCURDIR)/$(@F)) $(CFLAGS_$(BCURDIR))
$(obj)%.s:	%.S
	$(MKDIR) -p $(@D)
	$(CPP) $(ALL_AFLAGS) -o $@ $<
$(obj)%.o:	%.S
	$(MKDIR) -p $(@D)
	$(CC)  $(ALL_AFLAGS) -o $@ $< -c
$(obj)%.o:	%.c
	$(MKDIR) -p $(@D)
	$(CC)  $(ALL_CFLAGS) -o $@ $< -c
$(obj)%.i:	%.c
	$(MKDIR) -p $(@D)
	$(CPP) $(ALL_CFLAGS) -o $@ $< -c
$(obj)%.s:	%.c
	$(MKDIR) -p $(@D)
	$(CC)  $(ALL_CFLAGS) -o $@ $< -c -S

#########################################################################

# If the list of objects to link is empty, just create an empty built-in.o
cmd_link_o_target = $(if $(strip $1),\
		      $(LD) $(LDFLAGS) -r -o $@ $1,\
		      rm -f $@; $(AR) rcs $@ )

#########################################################################
