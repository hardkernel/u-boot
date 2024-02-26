#
# SPDX-License-Identifier:	GPL-2.0+
#

VERSION = 2017
PATCHLEVEL = 09
SUBLEVEL =
EXTRAVERSION =
NAME =

# *DOCUMENTATION*
# To see a list of typical targets execute "make help"
# More info can be located in ./README
# Comments in this file are targeted only to the developer, do not
# expect to learn how to build the kernel reading this file.

# o Do not use make's built-in rules and variables
#   (this increases performance and avoids hard-to-debug behaviour);
# o Look for make include files relative to root of kernel src
MAKEFLAGS += -rR --include-dir=$(CURDIR)

# Avoid funny character set dependencies
unexport LC_ALL
LC_COLLATE=C
LC_NUMERIC=C
export LC_COLLATE LC_NUMERIC

# Avoid interference with shell env settings
unexport GREP_OPTIONS

# We are using a recursive build, so we need to do a little thinking
# to get the ordering right.
#
# Most importantly: sub-Makefiles should only ever modify files in
# their own directory. If in some directory we have a dependency on
# a file in another dir (which doesn't happen often, but it's often
# unavoidable when linking the built-in.o targets which finally
# turn into vmlinux), we will call a sub make in that other dir, and
# after that we are sure that everything which is in that other dir
# is now up to date.
#
# The only cases where we need to modify files which have global
# effects are thus separated out and done before the recursive
# descending is started. They are now explicitly listed as the
# prepare rule.

# Beautify output
# ---------------------------------------------------------------------------
#
# Normally, we echo the whole command before executing it. By making
# that echo $($(quiet)$(cmd)), we now have the possibility to set
# $(quiet) to choose other forms of output instead, e.g.
#
#         quiet_cmd_cc_o_c = Compiling $(RELDIR)/$@
#         cmd_cc_o_c       = $(CC) $(c_flags) -c -o $@ $<
#
# If $(quiet) is empty, the whole command will be printed.
# If it is set to "quiet_", only the short version will be printed.
# If it is set to "silent_", nothing will be printed at all, since
# the variable $(silent_cmd_cc_o_c) doesn't exist.
#
# A simple variant is to prefix commands with $(Q) - that's useful
# for commands that shall be hidden in non-verbose mode.
#
#	$(Q)ln $@ :<
#
# If KBUILD_VERBOSE equals 0 then the above command will be hidden.
# If KBUILD_VERBOSE equals 1 then the above command is displayed.
#
# To put more focus on warnings, be less verbose as default
# Use 'make V=1' to see the full commands

ifeq ("$(origin V)", "command line")
  KBUILD_VERBOSE = $(V)
endif
ifndef KBUILD_VERBOSE
  KBUILD_VERBOSE = 0
endif

ifeq ($(KBUILD_VERBOSE),1)
  quiet =
  Q =
else
  quiet=quiet_
  Q = @
endif

ifeq ("$(origin FWVER)", "command line")
  PLAT_FW_VERSION := $(FWVER)
endif
ifeq ("$(origin SPL_FWVER)", "command line")
  PLAT_SPL_FW_VERSION := $(SPL_FWVER)
endif

# If the user is running make -s (silent mode), suppress echoing of
# commands

ifneq ($(filter 4.%,$(MAKE_VERSION)),)	# make-4
ifneq ($(filter %s ,$(firstword x$(MAKEFLAGS))),)
  quiet=silent_
endif
else					# make-3.8x
ifneq ($(filter s% -s%,$(MAKEFLAGS)),)
  quiet=silent_
endif
endif

export quiet Q KBUILD_VERBOSE

# kbuild supports saving output files in a separate directory.
# To locate output files in a separate directory two syntaxes are supported.
# In both cases the working directory must be the root of the kernel src.
# 1) O=
# Use "make O=dir/to/store/output/files/"
#
# 2) Set KBUILD_OUTPUT
# Set the environment variable KBUILD_OUTPUT to point to the directory
# where the output files shall be placed.
# export KBUILD_OUTPUT=dir/to/store/output/files/
# make
#
# The O= assignment takes precedence over the KBUILD_OUTPUT environment
# variable.

# KBUILD_SRC is set on invocation of make in OBJ directory
# KBUILD_SRC is not intended to be used by the regular user (for now)
ifeq ($(KBUILD_SRC),)

# OK, Make called in directory where kernel src resides
# Do we want to locate output files in a separate directory?
ifeq ("$(origin O)", "command line")
  KBUILD_OUTPUT := $(O)
endif

# That's our default target when none is given on the command line
PHONY := _all
_all:

# Cancel implicit rules on top Makefile
$(CURDIR)/Makefile Makefile: ;

ifneq ($(KBUILD_OUTPUT),)
# Invoke a second make in the output directory, passing relevant variables
# check that the output directory actually exists
saved-output := $(KBUILD_OUTPUT)
KBUILD_OUTPUT := $(shell mkdir -p $(KBUILD_OUTPUT) && cd $(KBUILD_OUTPUT) \
								&& /bin/pwd)
$(if $(KBUILD_OUTPUT),, \
     $(error failed to create output directory "$(saved-output)"))

PHONY += $(MAKECMDGOALS) sub-make

$(filter-out _all sub-make $(CURDIR)/Makefile, $(MAKECMDGOALS)) _all: sub-make
	@:

sub-make: FORCE
	$(Q)$(MAKE) -C $(KBUILD_OUTPUT) KBUILD_SRC=$(CURDIR) \
	-f $(CURDIR)/Makefile $(filter-out _all sub-make,$(MAKECMDGOALS))

# Leave processing to above invocation of make
skip-makefile := 1
endif # ifneq ($(KBUILD_OUTPUT),)
endif # ifeq ($(KBUILD_SRC),)

# We process the rest of the Makefile if this is the final invocation of make
ifeq ($(skip-makefile),)

# Do not print "Entering directory ...",
# but we want to display it when entering to the output directory
# so that IDEs/editors are able to understand relative filenames.
MAKEFLAGS += --no-print-directory

# Call a source code checker (by default, "sparse") as part of the
# C compilation.
#
# Use 'make C=1' to enable checking of only re-compiled files.
# Use 'make C=2' to enable checking of *all* source files, regardless
# of whether they are re-compiled or not.
#
# See the file "Documentation/sparse.txt" for more details, including
# where to get the "sparse" utility.

ifeq ("$(origin C)", "command line")
  KBUILD_CHECKSRC = $(C)
endif
ifndef KBUILD_CHECKSRC
  KBUILD_CHECKSRC = 0
endif

# Use make M=dir to specify directory of external module to build
# Old syntax make ... SUBDIRS=$PWD is still supported
# Setting the environment variable KBUILD_EXTMOD take precedence
ifdef SUBDIRS
  KBUILD_EXTMOD ?= $(SUBDIRS)
endif

ifeq ("$(origin M)", "command line")
  KBUILD_EXTMOD := $(M)
endif

# If building an external module we do not care about the all: rule
# but instead _all depend on modules
PHONY += all
ifeq ($(KBUILD_EXTMOD),)
_all: all
else
_all: modules
endif

ifeq ($(KBUILD_SRC),)
        # building in the source tree
        srctree := .
else
        ifeq ($(KBUILD_SRC)/,$(dir $(CURDIR)))
                # building in a subdirectory of the source tree
                srctree := ..
        else
                srctree := $(KBUILD_SRC)
        endif
endif
objtree		:= .
src		:= $(srctree)
obj		:= $(objtree)

VPATH		:= $(srctree)$(if $(KBUILD_EXTMOD),:$(KBUILD_EXTMOD))

export srctree objtree VPATH

# Make sure CDPATH settings don't interfere
unexport CDPATH

#########################################################################

HOSTARCH := $(shell uname -m | \
	sed -e s/i.86/x86/ \
	    -e s/sun4u/sparc64/ \
	    -e s/arm.*/arm/ \
	    -e s/sa110/arm/ \
	    -e s/ppc64/powerpc/ \
	    -e s/ppc/powerpc/ \
	    -e s/macppc/powerpc/\
	    -e s/sh.*/sh/)

HOSTOS := $(shell uname -s | tr '[:upper:]' '[:lower:]' | \
	    sed -e 's/\(cygwin\).*/cygwin/')

export	HOSTARCH HOSTOS

#########################################################################

# set default to nothing for native builds
ifeq ($(HOSTARCH),$(ARCH))
CROSS_COMPILE ?=
endif

KCONFIG_CONFIG	?= .config
export KCONFIG_CONFIG

# SHELL used by kbuild
CONFIG_SHELL := $(shell if [ -x "$$BASH" ]; then echo $$BASH; \
	  else if [ -x /bin/bash ]; then echo /bin/bash; \
	  else echo sh; fi ; fi)

HOSTCC       = cc
HOSTCXX      = c++
HOSTCFLAGS   = -Wall -Wstrict-prototypes -O2 -fomit-frame-pointer \
		$(if $(CONFIG_TOOLS_DEBUG),-g)
HOSTCXXFLAGS = -O2

ifeq ($(HOSTOS),cygwin)
HOSTCFLAGS	+= -ansi
endif

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
HOSTCC       = $(call os_x_before, 10, 5, "cc", "gcc")
HOSTCFLAGS  += $(call os_x_before, 10, 4, "-traditional-cpp")
HOSTLDFLAGS += $(call os_x_before, 10, 5, "-multiply_defined suppress")

# since Lion (10.7) ASLR is on by default, but we use linker generated lists
# in some host tools which is a problem then ... so disable ASLR for these
# tools
HOSTLDFLAGS += $(call os_x_before, 10, 7, "", "-Xlinker -no_pie")
endif

# Decide whether to build built-in, modular, or both.
# Normally, just do built-in.

KBUILD_MODULES :=
KBUILD_BUILTIN := 1

# If we have only "make modules", don't compile built-in objects.
# When we're building modules with modversions, we need to consider
# the built-in objects during the descend as well, in order to
# make sure the checksums are up to date before we record them.

ifeq ($(MAKECMDGOALS),modules)
  KBUILD_BUILTIN := $(if $(CONFIG_MODVERSIONS),1)
endif

# If we have "make <whatever> modules", compile modules
# in addition to whatever we do anyway.
# Just "make" or "make all" shall build modules as well

# U-Boot does not need modules
#ifneq ($(filter all _all modules,$(MAKECMDGOALS)),)
#  KBUILD_MODULES := 1
#endif

#ifeq ($(MAKECMDGOALS),)
#  KBUILD_MODULES := 1
#endif

export KBUILD_MODULES KBUILD_BUILTIN
export KBUILD_CHECKSRC KBUILD_SRC KBUILD_EXTMOD

# We need some generic definitions (do not try to remake the file).
scripts/Kbuild.include: ;
include scripts/Kbuild.include

# Make variables (CC, etc...)

AS		= $(CROSS_COMPILE)as
# Always use GNU ld
ifneq ($(shell $(CROSS_COMPILE)ld.bfd -v 2> /dev/null),)
LD		= $(CROSS_COMPILE)ld.bfd
else
LD		= $(CROSS_COMPILE)ld
endif
CC		= $(CROSS_COMPILE)gcc
CPP		= $(CC) -E
AR		= $(CROSS_COMPILE)ar
NM		= $(CROSS_COMPILE)nm
LDR		= $(CROSS_COMPILE)ldr
STRIP		= $(CROSS_COMPILE)strip
OBJCOPY		= $(CROSS_COMPILE)objcopy
OBJDUMP		= $(CROSS_COMPILE)objdump
AWK		= awk
PERL		= perl
PYTHON		?= python
DTC		?= $(objtree)/scripts/dtc/dtc
CHECK		= sparse

CHECKFLAGS     := -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ \
		  -Wbitwise -Wno-return-void -D__CHECK_ENDIAN__ $(CF)

KBUILD_CPPFLAGS := -D__KERNEL__ -D__UBOOT__

KBUILD_CFLAGS   := -Wall -Wstrict-prototypes \
		   -Wno-format-security \
		   -fno-builtin -ffreestanding
KBUILD_CFLAGS	+= -fshort-wchar -Werror
KBUILD_AFLAGS   := -D__ASSEMBLY__

# Read UBOOTRELEASE from include/config/uboot.release (if it exists)
UBOOTRELEASE = $(shell cat include/config/uboot.release 2> /dev/null)
UBOOTVERSION = $(VERSION)$(if $(PATCHLEVEL),.$(PATCHLEVEL)$(if $(SUBLEVEL),.$(SUBLEVEL)))$(EXTRAVERSION)

export VERSION PATCHLEVEL SUBLEVEL UBOOTRELEASE UBOOTVERSION
export ARCH CPU BOARD VENDOR SOC CPUDIR BOARDDIR
export CONFIG_SHELL HOSTCC HOSTCFLAGS HOSTLDFLAGS CROSS_COMPILE AS LD CC
export CPP AR NM LDR STRIP OBJCOPY OBJDUMP
export MAKE AWK PERL PYTHON
export HOSTCXX HOSTCXXFLAGS CHECK CHECKFLAGS DTC DTC_FLAGS

export KBUILD_CPPFLAGS NOSTDINC_FLAGS UBOOTINCLUDE OBJCOPYFLAGS LDFLAGS
export KBUILD_CFLAGS KBUILD_AFLAGS

# When compiling out-of-tree modules, put MODVERDIR in the module
# tree rather than in the kernel tree. The kernel tree might
# even be read-only.
export MODVERDIR := $(if $(KBUILD_EXTMOD),$(firstword $(KBUILD_EXTMOD))/).tmp_versions

# Files to ignore in find ... statements

export RCS_FIND_IGNORE := \( -name SCCS -o -name BitKeeper -o -name .svn -o    \
			  -name CVS -o -name .pc -o -name .hg -o -name .git \) \
			  -prune -o
export RCS_TAR_IGNORE := --exclude SCCS --exclude BitKeeper --exclude .svn \
			 --exclude CVS --exclude .pc --exclude .hg --exclude .git

# ===========================================================================
# Rules shared between *config targets and build targets

# Basic helpers built in scripts/
PHONY += scripts_basic
scripts_basic:
	$(Q)$(MAKE) $(build)=scripts/basic
	$(Q)rm -f .tmp_quiet_recordmcount

# To avoid any implicit rule to kick in, define an empty command.
scripts/basic/%: scripts_basic ;

PHONY += outputmakefile
# outputmakefile generates a Makefile in the output directory, if using a
# separate output directory. This allows convenient use of make in the
# output directory.
outputmakefile:
ifneq ($(KBUILD_SRC),)
	$(Q)ln -fsn $(srctree) source
	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/mkmakefile \
	    $(srctree) $(objtree) $(VERSION) $(PATCHLEVEL)
endif

# To make sure we do not include .config for any of the *config targets
# catch them early, and hand them over to scripts/kconfig/Makefile
# It is allowed to specify more targets when calling make, including
# mixing *config targets and build targets.
# For example 'make oldconfig all'.
# Detect when mixed targets is specified, and make a second invocation
# of make so .config is not included in this case either (for *config).

version_h := include/generated/version_autogenerated.h
timestamp_h := include/generated/timestamp_autogenerated.h

no-dot-config-targets := clean clobber mrproper distclean \
			 help %docs check% coccicheck \
			 ubootversion backup tests

config-targets := 0
mixed-targets  := 0
dot-config     := 1

ifneq ($(filter $(no-dot-config-targets), $(MAKECMDGOALS)),)
	ifeq ($(filter-out $(no-dot-config-targets), $(MAKECMDGOALS)),)
		dot-config := 0
	endif
endif

ifeq ($(KBUILD_EXTMOD),)
        ifneq ($(filter config %config,$(MAKECMDGOALS)),)
                config-targets := 1
                ifneq ($(words $(MAKECMDGOALS)),1)
                        mixed-targets := 1
                endif
        endif
endif

ifeq ($(mixed-targets),1)
# ===========================================================================
# We're called with mixed targets (*config and build targets).
# Handle them one by one.

PHONY += $(MAKECMDGOALS) __build_one_by_one

$(filter-out __build_one_by_one, $(MAKECMDGOALS)): __build_one_by_one
	@:

__build_one_by_one:
	$(Q)set -e; \
	for i in $(MAKECMDGOALS); do \
		$(MAKE) -f $(srctree)/Makefile $$i; \
	done

else
ifeq ($(config-targets),1)
# ===========================================================================
# *config targets only - make sure prerequisites are updated, and descend
# in scripts/kconfig to make the *config target

KBUILD_DEFCONFIG := sandbox_defconfig
export KBUILD_DEFCONFIG KBUILD_KCONFIG

config: scripts_basic outputmakefile FORCE
	$(Q)$(MAKE) $(build)=scripts/kconfig $@

%config: scripts_basic outputmakefile FORCE
	$(Q)$(MAKE) $(build)=scripts/kconfig $@

else
# ===========================================================================
# Build targets only - this includes vmlinux, arch specific targets, clean
# targets and others. In general all targets except *config targets.

# Additional helpers built in scripts/
# Carefully list dependencies so we do not try to build scripts twice
# in parallel
PHONY += scripts
scripts: scripts_basic include/config/auto.conf
	$(Q)$(MAKE) $(build)=$(@)

ifeq ($(dot-config),1)
# Read in config
-include include/config/auto.conf

# Read in dependencies to all Kconfig* files, make sure to run
# oldconfig if changes are detected.
-include include/config/auto.conf.cmd

# To avoid any implicit rule to kick in, define an empty command
$(KCONFIG_CONFIG) include/config/auto.conf.cmd: ;

# If .config is newer than include/config/auto.conf, someone tinkered
# with it and forgot to run make oldconfig.
# if auto.conf.cmd is missing then we are probably in a cleaned tree so
# we execute the config step to be sure to catch updated Kconfig files
include/config/%.conf: $(KCONFIG_CONFIG) include/config/auto.conf.cmd
	$(Q)$(MAKE) -f $(srctree)/Makefile silentoldconfig
	@# If the following part fails, include/config/auto.conf should be
	@# deleted so "make silentoldconfig" will be re-run on the next build.
	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.autoconf || \
		{ rm -f include/config/auto.conf; false; }
	@# include/config.h has been updated after "make silentoldconfig".
	@# We need to touch include/config/auto.conf so it gets newer
	@# than include/config.h.
	@# Otherwise, 'make silentoldconfig' would be invoked twice.
	$(Q)touch include/config/auto.conf

u-boot.cfg spl/u-boot.cfg tpl/u-boot.cfg: include/config.h FORCE
	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.autoconf $(@)

-include include/autoconf.mk
-include include/autoconf.mk.dep

# We want to include arch/$(ARCH)/config.mk only when include/config/auto.conf
# is up-to-date. When we switch to a different board configuration, old CONFIG
# macros are still remaining in include/config/auto.conf. Without the following
# gimmick, wrong config.mk would be included leading nasty warnings/errors.
ifneq ($(wildcard $(KCONFIG_CONFIG)),)
ifneq ($(wildcard include/config/auto.conf),)
autoconf_is_old := $(shell find . -path ./$(KCONFIG_CONFIG) -newer \
						include/config/auto.conf)
ifeq ($(autoconf_is_old),)
include config.mk
include arch/$(ARCH)/Makefile
endif
endif
endif

# These are set by the arch-specific config.mk. Make sure they are exported
# so they can be used when building an EFI application.
export EFI_LDS		# Filename of EFI link script in arch/$(ARCH)/lib
export EFI_CRT0		# Filename of EFI CRT0 in arch/$(ARCH)/lib
export EFI_RELOC	# Filename of EFU relocation code in arch/$(ARCH)/lib
export CFLAGS_EFI	# Compiler flags to add when building EFI app
export CFLAGS_NON_EFI	# Compiler flags to remove when building EFI app
export EFI_TARGET	# binutils target if EFI is natively supported

# If board code explicitly specified LDSCRIPT or CONFIG_SYS_LDSCRIPT, use
# that (or fail if absent).  Otherwise, search for a linker script in a
# standard location.

ifndef LDSCRIPT
	#LDSCRIPT := $(srctree)/board/$(BOARDDIR)/u-boot.lds.debug
	ifdef CONFIG_SYS_LDSCRIPT
		# need to strip off double quotes
		LDSCRIPT := $(srctree)/$(CONFIG_SYS_LDSCRIPT:"%"=%)
	endif
endif

# If there is no specified link script, we look in a number of places for it
ifndef LDSCRIPT
	ifeq ($(wildcard $(LDSCRIPT)),)
		LDSCRIPT := $(srctree)/board/$(BOARDDIR)/u-boot.lds
	endif
	ifeq ($(wildcard $(LDSCRIPT)),)
		LDSCRIPT := $(srctree)/$(CPUDIR)/u-boot.lds
	endif
	ifeq ($(wildcard $(LDSCRIPT)),)
		LDSCRIPT := $(srctree)/arch/$(ARCH)/cpu/u-boot.lds
	endif
endif

else
# Dummy target needed, because used as prerequisite
include/config/auto.conf: ;
endif # $(dot-config)

#
# Xtensa linker script cannot be preprocessed with -ansi because of
# preprocessor operations on strings that don't make C identifiers.
#
ifeq ($(CONFIG_XTENSA),)
LDPPFLAGS	+= -ansi
endif

ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
KBUILD_CFLAGS	+= -Os
else
KBUILD_CFLAGS	+= -O2
endif

KBUILD_CFLAGS += $(call cc-option,-fno-stack-protector)
KBUILD_CFLAGS += $(call cc-option,-fno-delete-null-pointer-checks)

KBUILD_CFLAGS	+= -g
# $(KBUILD_AFLAGS) sets -g, which causes gcc to pass a suitable -g<format>
# option to the assembler.
KBUILD_AFLAGS	+= -g

# Report stack usage if supported
ifeq ($(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-stack-usage.sh $(CC)),y)
	KBUILD_CFLAGS += -fstack-usage
endif

KBUILD_CFLAGS += $(call cc-option,-Wno-format-nonliteral)
KBUILD_CFLAGS += $(call cc-disable-warning, address-of-packed-member)

# turn jbsr into jsr for m68k
ifeq ($(ARCH),m68k)
ifeq ($(findstring 3.4,$(shell $(CC) --version)),3.4)
KBUILD_AFLAGS += -Wa,-gstabs,-S
endif
endif

# Prohibit date/time macros, which would make the build non-deterministic
KBUILD_CFLAGS   += $(call cc-option,-Werror=date-time)

include scripts/Makefile.extrawarn

# Add user supplied CPPFLAGS, AFLAGS and CFLAGS as the last assignments
KBUILD_CPPFLAGS += $(KCPPFLAGS)
KBUILD_AFLAGS += $(KAFLAGS)
KBUILD_CFLAGS += $(KCFLAGS)

# Use UBOOTINCLUDE when you must reference the include/ directory.
# Needed to be compatible with the O= option
UBOOTINCLUDE    := \
		-Iinclude \
		$(if $(KBUILD_SRC), -I$(srctree)/include) \
		$(if $(CONFIG_$(SPL_)SYS_THUMB_BUILD), \
			$(if $(CONFIG_HAS_THUMB2),, \
				-I$(srctree)/arch/$(ARCH)/thumb1/include),) \
		-I$(srctree)/arch/$(ARCH)/include \
		-include $(srctree)/include/linux/kconfig.h

NOSTDINC_FLAGS += -nostdinc -isystem $(shell $(CC) -print-file-name=include)
CHECKFLAGS     += $(NOSTDINC_FLAGS)

# FIX ME
cpp_flags := $(KBUILD_CPPFLAGS) $(PLATFORM_CPPFLAGS) $(UBOOTINCLUDE) \
							$(NOSTDINC_FLAGS)
c_flags := $(KBUILD_CFLAGS) $(cpp_flags)

#########################################################################
# U-Boot objects....order is important (i.e. start must be first)

HAVE_VENDOR_COMMON_LIB = $(if $(wildcard $(srctree)/board/$(VENDOR)/common/Makefile),y,n)

libs-y += lib/
libs-$(HAVE_VENDOR_COMMON_LIB) += board/$(VENDOR)/common/
libs-$(CONFIG_OF_EMBED) += dts/
ifneq ($(CONFIG_SPL_BUILD)$(CONFIG_SPL_DECOMP_HEADER),yy)
libs-y += fs/
libs-y += net/
libs-y += disk/
libs-y += drivers/
libs-y += drivers/cpu/
libs-y += drivers/dma/
libs-y += drivers/gpio/
libs-y += drivers/i2c/
libs-y += drivers/mtd/
libs-$(CONFIG_CMD_NAND) += drivers/mtd/nand/raw/
libs-y += drivers/mtd/onenand/
libs-$(CONFIG_CMD_UBI) += drivers/mtd/ubi/
libs-y += drivers/mtd/spi/
libs-y += drivers/net/
libs-y += drivers/net/phy/
libs-y += drivers/pci/
libs-y += drivers/power/ \
	drivers/power/domain/ \
	drivers/power/fuel_gauge/ \
	drivers/power/mfd/ \
	drivers/power/pmic/ \
	drivers/power/battery/ \
	drivers/power/regulator/ \
	drivers/power/dvfs/ \
	drivers/power/io-domain/ \
	drivers/power/charge/
libs-y += drivers/spi/
libs-$(CONFIG_FMAN_ENET) += drivers/net/fm/
libs-$(CONFIG_SYS_FSL_DDR) += drivers/ddr/fsl/
libs-$(CONFIG_SYS_FSL_MMDC) += drivers/ddr/fsl/
libs-$(CONFIG_ALTERA_SDRAM) += drivers/ddr/altera/
libs-y += drivers/serial/
libs-y += drivers/usb/cdns3/
libs-y += drivers/usb/dwc3/
libs-y += drivers/usb/common/
libs-y += drivers/usb/emul/
libs-y += drivers/usb/eth/
libs-y += drivers/usb/gadget/
libs-y += drivers/usb/gadget/udc/
libs-y += drivers/usb/host/
libs-y += drivers/usb/musb/
libs-y += drivers/usb/musb-new/
libs-y += drivers/usb/phy/
libs-y += drivers/usb/ulpi/
libs-y += cmd/
libs-y += common/
libs-y += env/
libs-$(CONFIG_API) += api/
libs-$(CONFIG_HAS_POST) += post/
endif
libs-y += test/
libs-y += test/dm/
libs-$(CONFIG_UT_ENV) += test/env/
libs-$(CONFIG_UT_OVERLAY) += test/overlay/

libs-y += $(if $(BOARDDIR),board/$(BOARDDIR)/)
ifneq ($(CONFIG_TARGET_ODROID_M1)$(CONFIG_TARGET_ODROID_M1S),)
libs-y += board/hardkernel/odroid-common/
endif

libs-y := $(sort $(libs-y))

u-boot-dirs	:= $(patsubst %/,%,$(filter %/, $(libs-y))) tools examples

u-boot-alldirs	:= $(sort $(u-boot-dirs) $(patsubst %/,%,$(filter %/, $(libs-))))

libs-y		:= $(patsubst %/, %/built-in.o, $(libs-y))

u-boot-init := $(head-y)
u-boot-main := $(libs-y)


# Add GCC lib
ifeq ($(CONFIG_USE_PRIVATE_LIBGCC),y)
PLATFORM_LIBGCC = arch/$(ARCH)/lib/lib.a
else
PLATFORM_LIBGCC := -L $(shell dirname `$(CC) $(c_flags) -print-libgcc-file-name`) -lgcc
endif
PLATFORM_LIBS += $(PLATFORM_LIBGCC)
export PLATFORM_LIBS
export PLATFORM_LIBGCC

# Special flags for CPP when processing the linker script.
# Pass the version down so we can handle backwards compatibility
# on the fly.
LDPPFLAGS += \
	-include $(srctree)/include/u-boot/u-boot.lds.h \
	-DCPUDIR=$(CPUDIR) \
	$(shell $(LD) --version | \
	  sed -ne 's/GNU ld version \([0-9][0-9]*\)\.\([0-9][0-9]*\).*/-DLD_MAJOR=\1 -DLD_MINOR=\2/p')

#########################################################################
#########################################################################

ifneq ($(CONFIG_BOARD_SIZE_LIMIT),)
BOARD_SIZE_CHECK = \
	@actual=`wc -c $@ | awk '{print $$1}'`; \
	limit=`printf "%d" $(CONFIG_BOARD_SIZE_LIMIT)`; \
	if test $$actual -gt $$limit; then \
		echo "$@ exceeds file size limit:" >&2 ; \
		echo "  limit:  $$limit bytes" >&2 ; \
		echo "  actual: $$actual bytes" >&2 ; \
		echo "  excess: $$((actual - limit)) bytes" >&2; \
		exit 1; \
	fi
else
BOARD_SIZE_CHECK =
endif

# Statically apply RELA-style relocations (currently arm64 only)
# This is useful for arm64 where static relocation needs to be performed on
# the raw binary, but certain simulators only accept an ELF file (but don't
# do the relocation).
ifneq ($(CONFIG_STATIC_RELA),)
# $(1) is u-boot ELF, $(2) is u-boot bin, $(3) is text base
DO_STATIC_RELA = \
	start=$$($(NM) $(1) | grep __rel_dyn_start | cut -f 1 -d ' '); \
	end=$$($(NM) $(1) | grep __rel_dyn_end | cut -f 1 -d ' '); \
	tools/relocate-rela $(2) $(3) $$start $$end
else
DO_STATIC_RELA =
endif

# Always append ALL so that arch config.mk's can add custom ones
ALL-y += u-boot.srec u-boot.bin u-boot.sym System.map binary_size_check
ALL-$(CONFIG_SUPPORT_USBPLUG) += usbplug.bin

ALL-$(CONFIG_ONENAND_U_BOOT) += u-boot-onenand.bin
ifeq ($(CONFIG_SPL_FSL_PBL),y)
ALL-$(CONFIG_RAMBOOT_PBL) += u-boot-with-spl-pbl.bin
else
ifneq ($(CONFIG_SECURE_BOOT), y)
# For Secure Boot The Image needs to be signed and Header must also
# be included. So The image has to be built explicitly
ALL-$(CONFIG_RAMBOOT_PBL) += u-boot.pbl
endif
endif
ALL-$(CONFIG_SPL) += spl/u-boot-spl.bin
ifeq ($(CONFIG_MX6)$(CONFIG_SECURE_BOOT), yy)
ALL-$(CONFIG_SPL_FRAMEWORK) += u-boot-ivt.img
else
ALL-$(CONFIG_SPL_FRAMEWORK) += u-boot.img
endif
ALL-$(CONFIG_TPL) += tpl/u-boot-tpl.bin
ALL-$(CONFIG_OF_SEPARATE) += u-boot.dtb
ifeq ($(CONFIG_SPL_FRAMEWORK),y)
ALL-$(CONFIG_OF_SEPARATE) += u-boot-dtb.img
endif
ALL-$(CONFIG_OF_HOSTFILE) += u-boot.dtb
ifneq ($(CONFIG_SPL_TARGET),)
ALL-$(CONFIG_SPL) += $(CONFIG_SPL_TARGET:"%"=%)
endif
ALL-$(CONFIG_REMAKE_ELF) += u-boot.elf
ALL-$(CONFIG_EFI_APP) += u-boot-app.efi
ALL-$(CONFIG_EFI_STUB) += u-boot-payload.efi

ifneq ($(BUILD_ROM),)
ALL-$(CONFIG_X86_RESET_VECTOR) += u-boot.rom
endif

# enable combined SPL/u-boot/dtb rules for tegra
ifeq ($(CONFIG_TEGRA)$(CONFIG_SPL),yy)
ALL-y += u-boot-tegra.bin u-boot-nodtb-tegra.bin
ALL-$(CONFIG_OF_SEPARATE) += u-boot-dtb-tegra.bin
endif

# Add optional build target if defined in board/cpu/soc headers
ifneq ($(CONFIG_BUILD_TARGET),)
ALL-y += $(CONFIG_BUILD_TARGET:"%"=%)
endif

LDFLAGS_u-boot += $(LDFLAGS_FINAL)

# Avoid 'Not enough room for program headers' error on binutils 2.28 onwards.
LDFLAGS_u-boot += $(call ld-option, --no-dynamic-linker)

ifneq ($(CONFIG_SYS_TEXT_BASE),)
LDFLAGS_u-boot += -Ttext $(CONFIG_SYS_TEXT_BASE)
endif

# Normally we fill empty space with 0xff
quiet_cmd_objcopy = OBJCOPY $@
cmd_objcopy = $(OBJCOPY) --gap-fill=0xff $(OBJCOPYFLAGS) \
	$(OBJCOPYFLAGS_$(@F)) $< $@

# Provide a version which does not do this, for use by EFI
quiet_cmd_zobjcopy = OBJCOPY $@
cmd_zobjcopy = $(OBJCOPY) $(OBJCOPYFLAGS) $(OBJCOPYFLAGS_$(@F)) $< $@

quiet_cmd_efipayload = OBJCOPY $@
cmd_efipayload = $(OBJCOPY) -I binary -O $(EFIPAYLOAD_BFDTARGET) -B $(EFIPAYLOAD_BFDARCH) $< $@

MKIMAGEOUTPUT ?= /dev/null

quiet_cmd_mkimage = MKIMAGE $@
cmd_mkimage = $(objtree)/tools/mkimage $(MKIMAGEFLAGS_$(@F)) -d $< $@ \
	$(if $(KBUILD_VERBOSE:1=), >$(MKIMAGEOUTPUT))

quiet_cmd_mkfitimage = MKIMAGE $@
cmd_mkfitimage = $(objtree)/tools/mkimage $(MKIMAGEFLAGS_$(@F)) -f $(U_BOOT_ITS) -E $@ \
	$(if $(KBUILD_VERBOSE:1=), >$(MKIMAGEOUTPUT))

quiet_cmd_cat = CAT     $@
cmd_cat = cat $(filter-out $(PHONY), $^) > $@

append = cat $(filter-out $< $(PHONY), $^) >> $@

quiet_cmd_pad_cat = CAT     $@
cmd_pad_cat = $(cmd_objcopy) && $(append) || rm -f $@

cfg: u-boot.cfg

quiet_cmd_cfgcheck = CFGCHK  $2
cmd_cfgcheck = $(srctree)/scripts/check-config.sh $2 \
		$(srctree)/scripts/config_whitelist.txt $(srctree)

all:		$(ALL-y) cfg
ifeq ($(CONFIG_DM_I2C_COMPAT)$(CONFIG_SANDBOX),y)
	@echo "===================== WARNING ======================"
	@echo "This board uses CONFIG_DM_I2C_COMPAT. Please remove"
	@echo "(possibly in a subsequent patch in your series)"
	@echo "before sending patches to the mailing list."
	@echo "===================================================="
endif
	@# Check that this build does not use CONFIG options that we do not
	@# know about unless they are in Kconfig. All the existing CONFIG
	@# options are whitelisted, so new ones should not be added.
	$(call cmd,cfgcheck,u-boot.cfg)

PHONY += dtbs
dtbs: dts/dt.dtb
	@:
dts/dt.dtb: u-boot
	$(Q)$(MAKE) $(build)=dts dtbs

quiet_cmd_copy = COPY    $@
      cmd_copy = cp $< $@

quiet_cmd_truncate = ALIGN   $@
      cmd_truncate = truncate -s "%8" $@

ifeq ($(CONFIG_MULTI_DTB_FIT),y)

fit-dtb.blob: dts/dt.dtb FORCE
	$(call if_changed,mkimage)

MKIMAGEFLAGS_fit-dtb.blob = -f auto -A $(ARCH) -T firmware -C none -O u-boot \
	-a 0 -e 0 -E \
	$(patsubst %,-b arch/$(ARCH)/dts/%.dtb,$(subst ",,$(CONFIG_OF_LIST))) -d /dev/null

u-boot-fit-dtb.bin: u-boot-nodtb.bin fit-dtb.blob
	$(call if_changed,cat)

u-boot.bin: u-boot-fit-dtb.bin FORCE
	$(call if_changed,copy)
else ifeq ($(CONFIG_OF_SEPARATE),y)

u-boot-dtb.bin: u-boot-nodtb.bin dts/dt.dtb FORCE
	$(call if_changed,cat)

EMBED_KERN_DTB := $(CONFIG_EMBED_KERNEL_DTB_PATH:"%"=%)
ifneq ($(wildcard $(EMBED_KERN_DTB)),)
u-boot-dtb-kern.bin: u-boot-dtb.bin FORCE
	$(call if_changed,copy)
	$(call if_changed,truncate)
u-boot.bin: u-boot-dtb-kern.bin $(EMBED_KERN_DTB) FORCE
	$(call if_changed,cat)
else
u-boot.bin: u-boot-dtb.bin FORCE
	$(call if_changed,copy)
	$(call if_changed,truncate)
endif

else
u-boot.bin: u-boot-nodtb.bin FORCE
	$(call if_changed,copy)
endif

ifeq ($(CONFIG_SUPPORT_USBPLUG),y)
usbplug.bin: u-boot.bin
	$(call if_changed,copy)
endif

%.imx: %.bin
	$(Q)$(MAKE) $(build)=arch/arm/mach-imx $@

%.vyb: %.imx
	$(Q)$(MAKE) $(build)=arch/arm/cpu/armv7/vf610 $@

quiet_cmd_copy = COPY    $@
      cmd_copy = cp $< $@

u-boot.dtb: dts/dt.dtb FORCE
	$(call cmd,copy)

OBJCOPYFLAGS_u-boot.hex := -O ihex

OBJCOPYFLAGS_u-boot.srec := -O srec

u-boot.hex u-boot.srec: u-boot FORCE
	$(call if_changed,objcopy)

OBJCOPYFLAGS_u-boot-nodtb.bin := -O binary \
		$(if $(CONFIG_X86_16BIT_INIT),-R .start16 -R .resetvec)

binary_size_check: u-boot-nodtb.bin FORCE
	@file_size=$(shell wc -c u-boot-nodtb.bin | awk '{print $$1}') ; \
	map_size=$(shell cat u-boot.map | \
		awk '/_image_copy_start/ {start = $$1} /_image_binary_end/ {end = $$1} END {if (start != "" && end != "") print "ibase=16; " toupper(end) " - " toupper(start)}' \
		| sed 's/0X//g' \
		| bc); \
	if [ "" != "$$map_size" ]; then \
		if test $$map_size -ne $$file_size; then \
			echo "u-boot.map shows a binary size of $$map_size" >&2 ; \
			echo "  but u-boot-nodtb.bin shows $$file_size" >&2 ; \
			exit 1; \
		fi \
	fi

u-boot-nodtb.bin: u-boot FORCE
	$(call if_changed,objcopy)
	$(call DO_STATIC_RELA,$<,$@,$(CONFIG_SYS_TEXT_BASE))
	$(BOARD_SIZE_CHECK)

u-boot.ldr:	u-boot
		$(CREATE_LDR_ENV)
		$(LDR) -T $(CONFIG_CPU) -c $@ $< $(LDR_FLAGS)
		$(BOARD_SIZE_CHECK)

# binman
# ---------------------------------------------------------------------------
quiet_cmd_binman = BINMAN  $@
cmd_binman = $(srctree)/tools/binman/binman -d u-boot.dtb -O . \
		-I . -I $(srctree)/board/$(BOARDDIR) $<

OBJCOPYFLAGS_u-boot.ldr.hex := -I binary -O ihex

OBJCOPYFLAGS_u-boot.ldr.srec := -I binary -O srec

u-boot.ldr.hex u-boot.ldr.srec: u-boot.ldr FORCE
	$(call if_changed,objcopy)

#
# U-Boot entry point, needed for booting of full-blown U-Boot
# from the SPL U-Boot version.
#
ifndef CONFIG_SYS_UBOOT_START
CONFIG_SYS_UBOOT_START := 0
endif

# Create a file containing the configuration options the image was built with
quiet_cmd_cpp_cfg = CFG     $@
cmd_cpp_cfg = $(CPP) -Wp,-MD,$(depfile) $(cpp_flags) $(LDPPFLAGS) -ansi \
	-DDO_DEPS_ONLY -D__ASSEMBLY__ -x assembler-with-cpp -P -dM -E -o $@ $<

# Boards with more complex image requirments can provide an .its source file
# or a generator script
ifneq ($(CONFIG_SPL_FIT_SOURCE),"")
U_BOOT_ITS = $(subst ",,$(CONFIG_SPL_FIT_SOURCE))
else
ifneq ($(CONFIG_SPL_FIT_GENERATOR),"")
U_BOOT_ITS := u-boot.its
$(U_BOOT_ITS): FORCE
	$(srctree)/$(CONFIG_SPL_FIT_GENERATOR) \
	$(patsubst %,arch/$(ARCH)/dts/%.dtb,$(subst ",,$(CONFIG_OF_LIST))) > $@
endif
endif

ifdef CONFIG_SPL_LOAD_FIT
MKIMAGEFLAGS_u-boot.img = -f auto -A $(ARCH) -T firmware -C none -O u-boot \
	-a $(CONFIG_SYS_TEXT_BASE) -e $(CONFIG_SYS_UBOOT_START) \
	-n "U-Boot $(UBOOTRELEASE) for $(BOARD) board" -E \
	$(patsubst %,-b arch/$(ARCH)/dts/%.dtb,$(subst ",,$(CONFIG_OF_LIST)))
else
MKIMAGEFLAGS_u-boot.img = -A $(ARCH) -T firmware -C none -O u-boot \
	-a $(CONFIG_SYS_TEXT_BASE) -e $(CONFIG_SYS_UBOOT_START) \
	-n "U-Boot $(UBOOTRELEASE) for $(BOARD) board"
MKIMAGEFLAGS_u-boot-ivt.img = -A $(ARCH) -T firmware_ivt -C none -O u-boot \
	-a $(CONFIG_SYS_TEXT_BASE) -e $(CONFIG_SYS_UBOOT_START) \
	-n "U-Boot $(UBOOTRELEASE) for $(BOARD) board"
u-boot-ivt.img: MKIMAGEOUTPUT = u-boot-ivt.img.log
CLEAN_FILES += u-boot-ivt.img.log u-boot-dtb.imx.log SPL.log u-boot.imx.log
endif

MKIMAGEFLAGS_u-boot-dtb.img = $(MKIMAGEFLAGS_u-boot.img)

MKIMAGEFLAGS_u-boot.kwb = -n $(srctree)/$(CONFIG_SYS_KWD_CONFIG:"%"=%) \
	-T kwbimage -a $(CONFIG_SYS_TEXT_BASE) -e $(CONFIG_SYS_TEXT_BASE)

MKIMAGEFLAGS_u-boot-spl.kwb = -n $(srctree)/$(CONFIG_SYS_KWD_CONFIG:"%"=%) \
	-T kwbimage -a $(CONFIG_SYS_TEXT_BASE) -e $(CONFIG_SYS_TEXT_BASE) \
	$(if $(KEYDIR),-k $(KEYDIR))

MKIMAGEFLAGS_u-boot.pbl = -n $(srctree)/$(CONFIG_SYS_FSL_PBL_RCW:"%"=%) \
		-R $(srctree)/$(CONFIG_SYS_FSL_PBL_PBI:"%"=%) -T pblimage

u-boot-dtb.img u-boot.img u-boot.kwb u-boot.pbl u-boot-ivt.img: \
		$(if $(CONFIG_SPL_LOAD_FIT),u-boot-nodtb.bin dts/dt.dtb,u-boot.bin) FORCE
	$(call if_changed,mkimage)

u-boot.itb: u-boot-nodtb.bin dts/dt.dtb $(U_BOOT_ITS) FORCE
	$(call if_changed,mkfitimage)

u-boot-spl.kwb: u-boot.img spl/u-boot-spl.bin FORCE
	$(call if_changed,mkimage)

u-boot.sha1:	u-boot.bin
		tools/ubsha1 u-boot.bin

u-boot.dis:	u-boot
		$(OBJDUMP) -d $< > $@

ifdef CONFIG_TPL
SPL_PAYLOAD := tpl/u-boot-with-tpl.bin
else
SPL_PAYLOAD := u-boot.bin
endif

OBJCOPYFLAGS_u-boot-with-spl.bin = -I binary -O binary \
				   --pad-to=$(CONFIG_SPL_PAD_TO)
u-boot-with-spl.bin: spl/u-boot-spl.bin $(SPL_PAYLOAD) FORCE
	$(call if_changed,pad_cat)

MKIMAGEFLAGS_lpc32xx-spl.img = -T lpc32xximage -a $(CONFIG_SPL_TEXT_BASE)

lpc32xx-spl.img: spl/u-boot-spl.bin FORCE
	$(call if_changed,mkimage)

OBJCOPYFLAGS_lpc32xx-boot-0.bin = -I binary -O binary --pad-to=$(CONFIG_SPL_PAD_TO)

lpc32xx-boot-0.bin: lpc32xx-spl.img FORCE
	$(call if_changed,objcopy)

OBJCOPYFLAGS_lpc32xx-boot-1.bin = -I binary -O binary --pad-to=$(CONFIG_SPL_PAD_TO)

lpc32xx-boot-1.bin: lpc32xx-spl.img FORCE
	$(call if_changed,objcopy)

lpc32xx-full.bin: lpc32xx-boot-0.bin lpc32xx-boot-1.bin u-boot.img FORCE
	$(call if_changed,cat)

CLEAN_FILES += lpc32xx-*

OBJCOPYFLAGS_u-boot-with-tpl.bin = -I binary -O binary \
				   --pad-to=$(CONFIG_TPL_PAD_TO)
tpl/u-boot-with-tpl.bin: tpl/u-boot-tpl.bin u-boot.bin FORCE
	$(call if_changed,pad_cat)

SPL: spl/u-boot-spl.bin FORCE
	$(Q)$(MAKE) $(build)=arch/arm/mach-imx $@

u-boot-with-spl.imx u-boot-with-nand-spl.imx: SPL u-boot.bin FORCE
	$(Q)$(MAKE) $(build)=arch/arm/mach-imx $@

MKIMAGEFLAGS_u-boot.ubl = -n $(UBL_CONFIG) -T ublimage -e $(CONFIG_SYS_TEXT_BASE)

u-boot.ubl: u-boot-with-spl.bin FORCE
	$(call if_changed,mkimage)

MKIMAGEFLAGS_u-boot-spl.ais = -s -n $(if $(CONFIG_AIS_CONFIG_FILE), \
	$(srctree)/$(CONFIG_AIS_CONFIG_FILE:"%"=%),"/dev/null") \
	-T aisimage -e $(CONFIG_SPL_TEXT_BASE)
spl/u-boot-spl.ais: spl/u-boot-spl.bin FORCE
	$(call if_changed,mkimage)

OBJCOPYFLAGS_u-boot.ais = -I binary -O binary --pad-to=$(CONFIG_SPL_PAD_TO)
u-boot.ais: spl/u-boot-spl.ais u-boot.img FORCE
	$(call if_changed,pad_cat)

u-boot-signed.sb: u-boot.bin spl/u-boot-spl.bin
	$(Q)$(MAKE) $(build)=arch/arm/cpu/arm926ejs/mxs u-boot-signed.sb
u-boot.sb: u-boot.bin spl/u-boot-spl.bin
	$(Q)$(MAKE) $(build)=arch/arm/cpu/arm926ejs/mxs u-boot.sb

# On x600 (SPEAr600) U-Boot is appended to U-Boot SPL.
# Both images are created using mkimage (crc etc), so that the ROM
# bootloader can check its integrity. Padding needs to be done to the
# SPL image (with mkimage header) and not the binary. Otherwise the resulting image
# which is loaded/copied by the ROM bootloader to SRAM doesn't fit.
# The resulting image containing both U-Boot images is called u-boot.spr
MKIMAGEFLAGS_u-boot-spl.img = -A $(ARCH) -T firmware -C none \
	-a $(CONFIG_SPL_TEXT_BASE) -e $(CONFIG_SPL_TEXT_BASE) -n XLOADER
spl/u-boot-spl.img: spl/u-boot-spl.bin FORCE
	$(call if_changed,mkimage)

OBJCOPYFLAGS_u-boot.spr = -I binary -O binary --pad-to=$(CONFIG_SPL_PAD_TO) \
			  --gap-fill=0xff
u-boot.spr: spl/u-boot-spl.img u-boot.img FORCE
	$(call if_changed,pad_cat)

ifneq ($(CONFIG_ARCH_SOCFPGA),)
quiet_cmd_socboot = SOCBOOT $@
cmd_socboot = cat	spl/u-boot-spl.sfp spl/u-boot-spl.sfp	\
			spl/u-boot-spl.sfp spl/u-boot-spl.sfp	\
			u-boot.img > $@ || rm -f $@
u-boot-with-spl.sfp: spl/u-boot-spl.sfp u-boot.img FORCE
	$(call if_changed,socboot)
endif

# x86 uses a large ROM. We fill it with 0xff, put the 16-bit stuff (including
# reset vector) at the top, Intel ME descriptor at the bottom, and U-Boot in
# the middle. This is handled by binman based on an image description in the
# board's device tree.
ifneq ($(CONFIG_X86_RESET_VECTOR),)
rom: u-boot.rom FORCE

refcode.bin: $(srctree)/board/$(BOARDDIR)/refcode.bin FORCE
	$(call if_changed,copy)

quiet_cmd_ldr = LD      $@
cmd_ldr = $(LD) $(LDFLAGS_$(@F)) \
	       $(filter-out FORCE,$^) -o $@

u-boot.rom: u-boot-x86-16bit.bin u-boot.bin \
		$(if $(CONFIG_SPL_X86_16BIT_INIT),spl/u-boot-spl.bin) \
		$(if $(CONFIG_HAVE_REFCODE),refcode.bin) FORCE
	$(call if_changed,binman)

OBJCOPYFLAGS_u-boot-x86-16bit.bin := -O binary -j .start16 -j .resetvec
u-boot-x86-16bit.bin: u-boot FORCE
	$(call if_changed,objcopy)
endif

ifneq ($(CONFIG_ARCH_SUNXI),)
u-boot-sunxi-with-spl.bin: spl/sunxi-spl.bin u-boot.img u-boot.dtb FORCE
	$(call if_changed,binman)
endif

ifneq ($(CONFIG_TEGRA),)
OBJCOPYFLAGS_u-boot-nodtb-tegra.bin = -O binary --pad-to=$(CONFIG_SYS_TEXT_BASE)
u-boot-nodtb-tegra.bin: spl/u-boot-spl u-boot-nodtb.bin FORCE
	$(call if_changed,pad_cat)

OBJCOPYFLAGS_u-boot-tegra.bin = -O binary --pad-to=$(CONFIG_SYS_TEXT_BASE)
u-boot-tegra.bin: spl/u-boot-spl u-boot.bin FORCE
	$(call if_changed,pad_cat)

u-boot-dtb-tegra.bin: u-boot-tegra.bin FORCE
	$(call if_changed,copy)
endif

OBJCOPYFLAGS_u-boot-app.efi := $(OBJCOPYFLAGS_EFI)
u-boot-app.efi: u-boot FORCE
	$(call if_changed,zobjcopy)

u-boot.bin.o: u-boot.bin FORCE
	$(call if_changed,efipayload)

u-boot-payload.lds: $(LDSCRIPT_EFI) FORCE
	$(call if_changed_dep,cpp_lds)

# Rule to link the EFI payload which contains a stub and a U-Boot binary
quiet_cmd_u-boot_payload ?= LD      $@
      cmd_u-boot_payload ?= $(LD) $(LDFLAGS_EFI_PAYLOAD) -o $@ \
      -T u-boot-payload.lds arch/x86/cpu/call32.o \
      lib/efi/efi.o lib/efi/efi_stub.o u-boot.bin.o \
      $(addprefix arch/$(ARCH)/lib/,$(EFISTUB))

u-boot-payload: u-boot.bin.o u-boot-payload.lds FORCE
	$(call if_changed,u-boot_payload)

OBJCOPYFLAGS_u-boot-payload.efi := $(OBJCOPYFLAGS_EFI)
u-boot-payload.efi: u-boot-payload FORCE
	$(call if_changed,zobjcopy)

u-boot-img.bin: spl/u-boot-spl.bin u-boot.img FORCE
	$(call if_changed,cat)

#Add a target to create boot binary having SPL binary in PBI format
#concatenated with u-boot binary. It is need by PowerPC SoC having
#internal SRAM <= 512KB.
MKIMAGEFLAGS_u-boot-spl.pbl = -n $(srctree)/$(CONFIG_SYS_FSL_PBL_RCW:"%"=%) \
		-R $(srctree)/$(CONFIG_SYS_FSL_PBL_PBI:"%"=%) -T pblimage \
		-A $(ARCH) -a $(CONFIG_SPL_TEXT_BASE)

spl/u-boot-spl.pbl: spl/u-boot-spl.bin FORCE
	$(call if_changed,mkimage)

ifeq ($(ARCH),arm)
UBOOT_BINLOAD := u-boot.img
else
UBOOT_BINLOAD := u-boot.bin
endif

OBJCOPYFLAGS_u-boot-with-spl-pbl.bin = -I binary -O binary --pad-to=$(CONFIG_SPL_PAD_TO) \
			  --gap-fill=0xff

u-boot-with-spl-pbl.bin: spl/u-boot-spl.pbl $(UBOOT_BINLOAD) FORCE
	$(call if_changed,pad_cat)

# PPC4xx needs the SPL at the end of the image, since the reset vector
# is located at 0xfffffffc. So we can't use the "u-boot-img.bin" target
# and need to introduce a new build target with the full blown U-Boot
# at the start padded up to the start of the SPL image. And then concat
# the SPL image to the end.

OBJCOPYFLAGS_u-boot-img-spl-at-end.bin := -I binary -O binary \
	--pad-to=$(CONFIG_UBOOT_PAD_TO) --gap-fill=0xff
u-boot-img-spl-at-end.bin: u-boot.img spl/u-boot-spl.bin FORCE
	$(call if_changed,pad_cat)

# Create a new ELF from a raw binary file.
ifndef PLATFORM_ELFENTRY
  PLATFORM_ELFENTRY = "_start"
endif
quiet_cmd_u-boot-elf ?= LD      $@
	cmd_u-boot-elf ?= $(LD) u-boot-elf.o -o $@ \
	--defsym=$(PLATFORM_ELFENTRY)=$(CONFIG_SYS_TEXT_BASE) \
	-Ttext=$(CONFIG_SYS_TEXT_BASE)
u-boot.elf: u-boot.bin
	$(Q)$(OBJCOPY) -I binary $(PLATFORM_ELFFLAGS) $< u-boot-elf.o
	$(call if_changed,u-boot-elf)

ARCH_POSTLINK := $(wildcard $(srctree)/arch/$(ARCH)/Makefile.postlink)

# Rule to link u-boot
# May be overridden by arch/$(ARCH)/config.mk
quiet_cmd_u-boot__ ?= LD      $@
      cmd_u-boot__ ?= $(LD) $(LDFLAGS) $(LDFLAGS_u-boot) -o $@ \
      -T u-boot.lds $(u-boot-init)                             \
      --start-group $(u-boot-main) --end-group                 \
      $(PLATFORM_LIBS) -Map u-boot.map;                        \
      $(if $(ARCH_POSTLINK), $(MAKE) -f $(ARCH_POSTLINK) $@, true)

quiet_cmd_smap = GEN     common/system_map.o
cmd_smap = \
	smap=`$(call SYSTEM_MAP,u-boot) | \
		awk '$$2 ~ /[tTwW]/ {printf $$1 $$3 "\\\\000"}'` ; \
	$(CC) $(c_flags) -DSYSTEM_MAP="\"$${smap}\"" \
		-c $(srctree)/common/system_map.c -o common/system_map.o

u-boot:	$(u-boot-init) $(u-boot-main) u-boot.lds FORCE
	+$(call if_changed,u-boot__)
ifeq ($(CONFIG_KALLSYMS),y)
	$(call cmd,smap)
	$(call cmd,u-boot__) common/system_map.o
endif

quiet_cmd_sym ?= SYM     $@
      cmd_sym ?= $(OBJDUMP) -t $< > $@
u-boot.sym: u-boot FORCE
	$(call if_changed,sym)

# The actual objects are generated when descending,
# make sure no implicit rule kicks in
$(sort $(u-boot-init) $(u-boot-main)): $(u-boot-dirs) ;

# Handle descending into subdirectories listed in $(vmlinux-dirs)
# Preset locale variables to speed up the build process. Limit locale
# tweaks to this spot to avoid wrong language settings when running
# make menuconfig etc.
# Error messages still appears in the original language

PHONY += $(u-boot-dirs)
$(u-boot-dirs): prepare scripts
	$(Q)$(MAKE) $(build)=$@

tools: prepare
# The "tools" are needed early
$(filter-out tools, $(u-boot-dirs)): tools
# The "examples" conditionally depend on U-Boot (say, when USE_PRIVATE_LIBGCC
# is "yes"), so compile examples after U-Boot is compiled.
examples: $(filter-out examples, $(u-boot-dirs))

define filechk_uboot.release
	echo "$(UBOOTVERSION)$$($(CONFIG_SHELL) $(srctree)/scripts/setlocalversion $(srctree))"
endef

# Store (new) UBOOTRELEASE string in include/config/uboot.release
include/config/uboot.release: include/config/auto.conf FORCE
	$(call filechk,uboot.release)


# Things we need to do before we recursively start building the kernel
# or the modules are listed in "prepare".
# A multi level approach is used. prepareN is processed before prepareN-1.
# archprepare is used in arch Makefiles and when processed asm symlink,
# version.h and scripts_basic is processed / created.

# Listed in dependency order
PHONY += prepare archprepare prepare0 prepare1 prepare2 prepare3

# prepare3 is used to check if we are building in a separate output directory,
# and if so do:
# 1) Check that make has not been executed in the kernel src $(srctree)
prepare3: include/config/uboot.release
ifneq ($(KBUILD_SRC),)
	@$(kecho) '  Using $(srctree) as source for U-Boot'
	$(Q)if [ -f $(srctree)/.config -o -d $(srctree)/include/config ]; then \
		echo >&2 "  $(srctree) is not clean, please run 'make mrproper'"; \
		echo >&2 "  in the '$(srctree)' directory.";\
		/bin/false; \
	fi;
endif

# prepare2 creates a makefile if using a separate output directory
prepare2: prepare3 outputmakefile

prepare1: prepare2 $(version_h) $(timestamp_h) \
                   include/config/auto.conf
ifeq ($(wildcard $(LDSCRIPT)),)
	@echo >&2 "  Could not find linker script."
	@/bin/false
endif

archprepare: prepare1 scripts_basic

prepare0: archprepare FORCE
	$(Q)$(MAKE) $(build)=.

# All the preparing..
prepare: prepare0

# Generate some files
# ---------------------------------------------------------------------------

ifeq ($(CONFIG_SUPPORT_USBPLUG),)
define filechk_version.h
	(echo \#define PLAIN_VERSION \"$(UBOOTRELEASE)\"; \
	echo \#define U_BOOT_VERSION \"U-Boot \" PLAIN_VERSION; \
	if [ -n "$(PLAT_SPL_FW_VERSION)" ]; then \
		echo \#define BUILD_SPL_TAG \"$(PLAT_SPL_FW_VERSION)\"; \
	fi; \
	if [ -n "$(PLAT_FW_VERSION)" ]; then \
        echo \#define BUILD_TAG \"$(PLAT_FW_VERSION)\"; \
	fi; \
	echo \#define CC_VERSION_STRING \"$$(LC_ALL=C $(CC) --version | head -n 1)\"; \
	echo \#define LD_VERSION_STRING \"$$(LC_ALL=C $(LD) --version | head -n 1)\"; )
endef
else
define filechk_version.h
        (echo \#define PLAIN_VERSION \"$(UBOOTRELEASE)\"; \
        echo \#define U_BOOT_VERSION \"USB-PLUG \" PLAIN_VERSION; \
        if [ -n "$(PLAT_SPL_FW_VERSION)" ]; then \
            echo \#define BUILD_SPL_TAG \"$(PLAT_SPL_FW_VERSION)\"; \
        fi; \
        if [ -n "$(PLAT_FW_VERSION)" ]; then \
            echo \#define BUILD_TAG \"$(PLAT_FW_VERSION)\"; \
        fi; \
        echo \#define CC_VERSION_STRING \"$$(LC_ALL=C $(CC) --version | head -n 1)\"; \
        echo \#define LD_VERSION_STRING \"$$(LC_ALL=C $(LD) --version | head -n 1)\"; )
endef
endif

# The SOURCE_DATE_EPOCH mechanism requires a date that behaves like GNU date.
# The BSD date on the other hand behaves different and would produce errors
# with the misused '-d' switch.  Respect that and search a working date with
# well known pre- and suffixes for the GNU variant of date.
define filechk_timestamp.h
	(if test -n "$${SOURCE_DATE_EPOCH}"; then \
		SOURCE_DATE="@$${SOURCE_DATE_EPOCH}"; \
		DATE=""; \
		for date in gdate date.gnu date; do \
			$${date} -u -d "$${SOURCE_DATE}" >/dev/null 2>&1 && DATE="$${date}"; \
		done; \
		if test -n "$${DATE}"; then \
			LC_ALL=C $${DATE} -u -d "$${SOURCE_DATE}" +'#define U_BOOT_DATE "%b %d %C%y"'; \
			LC_ALL=C $${DATE} -u -d "$${SOURCE_DATE}" +'#define U_BOOT_TIME "%T"'; \
			LC_ALL=C $${DATE} -u -d "$${SOURCE_DATE}" +'#define U_BOOT_TZ "%z"'; \
			LC_ALL=C $${DATE} -u -d "$${SOURCE_DATE}" +'#define U_BOOT_DMI_DATE "%m/%d/%Y"'; \
			LC_ALL=C $${DATE} -u -d "$${SOURCE_DATE}" +'#define U_BOOT_BUILD_DATE 0x%Y%m%d'; \
		else \
			return 42; \
		fi; \
	else \
		LC_ALL=C date +'#define U_BOOT_DATE "%b %d %C%y"'; \
		LC_ALL=C date +'#define U_BOOT_TIME "%T"'; \
		LC_ALL=C date +'#define U_BOOT_TZ "%z"'; \
		LC_ALL=C date +'#define U_BOOT_DMI_DATE "%m/%d/%Y"'; \
		LC_ALL=C date +'#define U_BOOT_BUILD_DATE 0x%Y%m%d'; \
	fi)
endef

$(version_h): include/config/uboot.release FORCE
	$(call filechk,version.h)

$(timestamp_h): $(srctree)/Makefile FORCE
	$(call filechk,timestamp.h)

# ---------------------------------------------------------------------------
quiet_cmd_cpp_lds = LDS     $@
cmd_cpp_lds = $(CPP) -Wp,-MD,$(depfile) $(cpp_flags) $(LDPPFLAGS) \
		-D__ASSEMBLY__ -x assembler-with-cpp -P -o $@ $<

u-boot.lds: $(LDSCRIPT) prepare FORCE
	$(call if_changed_dep,cpp_lds)

spl/u-boot-spl.bin: spl/u-boot-spl
	@:
spl/u-boot-spl: tools prepare \
		$(if $(CONFIG_OF_SEPARATE)$(CONFIG_OF_EMBED)$(CONFIG_SPL_OF_PLATDATA),dts/dt.dtb) \
		$(if $(CONFIG_OF_SEPARATE)$(CONFIG_OF_EMBED)$(CONFIG_TPL_OF_PLATDATA),dts/dt.dtb)
	$(Q)$(MAKE) obj=spl -f $(srctree)/scripts/Makefile.spl all

spl/sunxi-spl.bin: spl/u-boot-spl
	@:

spl/sunxi-spl-with-ecc.bin: spl/sunxi-spl.bin
	@:

spl/u-boot-spl.sfp: spl/u-boot-spl
	@:

spl/boot.bin: spl/u-boot-spl
	@:

tpl/u-boot-tpl.bin: tools prepare \
		$(if $(CONFIG_OF_SEPARATE)$(CONFIG_OF_EMBED)$(CONFIG_SPL_OF_PLATDATA),dts/dt.dtb)
	$(Q)$(MAKE) obj=tpl -f $(srctree)/scripts/Makefile.spl all

TAG_SUBDIRS := $(patsubst %,$(srctree)/%,$(u-boot-dirs) include)

FIND := find
FINDFLAGS := -L

tags ctags:
		ctags -w -o ctags `$(FIND) $(FINDFLAGS) $(TAG_SUBDIRS) \
						-name '*.[chS]' -print`
		ln -s ctags tags

etags:
		etags -a -o etags `$(FIND) $(FINDFLAGS) $(TAG_SUBDIRS) \
						-name '*.[chS]' -print`
cscope:
		$(FIND) $(FINDFLAGS) $(TAG_SUBDIRS) -name '*.[chS]' -print > \
						cscope.files
		cscope -b -q -k

SYSTEM_MAP = \
		$(NM) $1 | \
		grep -v '\(compiled\)\|\(\.o$$\)\|\( [aUw] \)\|\(\.\.ng$$\)\|\(LASH[RL]DI\)' | \
		LC_ALL=C sort
System.map:	u-boot
		@$(call SYSTEM_MAP,$<) > $@

#########################################################################

# ARM relocations should all be R_ARM_RELATIVE (32-bit) or
# R_AARCH64_RELATIVE (64-bit).
checkarmreloc: u-boot
	@RELOC="`$(CROSS_COMPILE)readelf -r -W $< | cut -d ' ' -f 4 | \
		grep R_A | sort -u`"; \
	if test "$$RELOC" != "R_ARM_RELATIVE" -a \
		 "$$RELOC" != "R_AARCH64_RELATIVE"; then \
		echo "$< contains unexpected relocations: $$RELOC"; \
		false; \
	fi

envtools: scripts_basic $(version_h) $(timestamp_h)
	$(Q)$(MAKE) $(build)=tools/env

tools-only: scripts_basic $(version_h) $(timestamp_h)
	$(Q)$(MAKE) $(build)=tools

tools-all: export HOST_TOOLS_ALL=y
tools-all: envtools tools ;

cross_tools: export CROSS_BUILD_TOOLS=y
cross_tools: tools ;

.PHONY : CHANGELOG
CHANGELOG:
	git log --no-merges U-Boot-1_1_5.. | \
	unexpand -a | sed -e 's/\s\s*$$//' > $@

#########################################################################

###
# Cleaning is done on three levels.
# make clean     Delete most generated files
#                Leave enough to build external modules
# make mrproper  Delete the current configuration, and all generated files
# make distclean Remove editor backup files, patch leftover files and the like

# Directories & files removed with 'make clean'
CLEAN_DIRS  += $(MODVERDIR) \
	       $(foreach d, spl tpl, $(patsubst %,$d/%, \
			$(filter-out include, $(shell ls -1 $d 2>/dev/null))))

CLEAN_FILES += include/bmp_logo.h include/bmp_logo_data.h \
	       boot* u-boot* MLO* SPL System.map fit-dtb.blob *.bin *.img *.gz .cc

# Directories & files removed with 'make mrproper'
MRPROPER_DIRS  += include/config include/generated spl tpl \
		  .tmp_objdiff
MRPROPER_FILES += .config .config.old include/autoconf.mk* include/config.h \
		  ctags etags tags TAGS cscope* GPATH GTAGS GRTAGS GSYMS

# clean - Delete most, but leave enough to build external modules
#
clean: rm-dirs  := $(CLEAN_DIRS)
clean: rm-files := $(CLEAN_FILES)

clean-dirs	:= $(foreach f,$(u-boot-alldirs),$(if $(wildcard $(srctree)/$f/Makefile),$f))

clean-dirs      := $(addprefix _clean_, $(clean-dirs) doc/DocBook)

PHONY += $(clean-dirs) clean archclean
$(clean-dirs):
	$(Q)$(MAKE) $(clean)=$(patsubst _clean_%,%,$@)

# TODO: Do not use *.cfgtmp
clean: $(clean-dirs)
	$(call cmd,rmdirs)
	$(call cmd,rmfiles)
	@find $(if $(KBUILD_EXTMOD), $(KBUILD_EXTMOD), .) $(RCS_FIND_IGNORE) \
		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
		-o -name '*.ko.*' -o -name '*.su' -o -name '*.cfgtmp' \
		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
		-o -name '*.symtypes' -o -name 'modules.order' \
		-o -name modules.builtin -o -name '.tmp_*.o.*' \
		-o -name 'dsdt.aml' -o -name 'dsdt.asl.tmp' -o -name 'dsdt.c' \
		-o -name '*.gcno' \) -type f -print | xargs rm -f

# mrproper - Delete all generated files, including .config
#
mrproper: rm-dirs  := $(wildcard $(MRPROPER_DIRS))
mrproper: rm-files := $(wildcard $(MRPROPER_FILES))
mrproper-dirs      := $(addprefix _mrproper_,scripts)

PHONY += $(mrproper-dirs) mrproper archmrproper
$(mrproper-dirs):
	$(Q)$(MAKE) $(clean)=$(patsubst _mrproper_%,%,$@)

mrproper: clean $(mrproper-dirs)
	$(call cmd,rmdirs)
	$(call cmd,rmfiles)
	@rm -f arch/*/include/asm/arch

# distclean
#
PHONY += distclean

distclean: mrproper
	@find $(srctree) $(RCS_FIND_IGNORE) \
		\( -name '*.orig' -o -name '*.rej' -o -name '*~' \
		-o -name '*.bak' -o -name '#*#' -o -name '.*.orig' \
		-o -name '.*.rej' -o -name '*%' -o -name 'core' \
		-o -name '*.pyc' \) \
		-type f -print | xargs rm -f
	@rm -f boards.cfg

backup:
	F=`basename $(srctree)` ; cd .. ; \
	gtar --force-local -zcvf `LC_ALL=C date "+$$F-%Y-%m-%d-%T.tar.gz"` $$F

help:
	@echo  'Cleaning targets:'
	@echo  '  clean		  - Remove most generated files but keep the config'
	@echo  '  mrproper	  - Remove all generated files + config + various backup files'
	@echo  '  distclean	  - mrproper + remove editor backup and patch files'
	@echo  ''
	@echo  'Configuration targets:'
	@$(MAKE) -f $(srctree)/scripts/kconfig/Makefile help
	@echo  ''
	@echo  'Other generic targets:'
	@echo  '  all		  - Build all necessary images depending on configuration'
	@echo  '  tests		  - Build U-Boot for sandbox and run tests'
	@echo  '* u-boot	  - Build the bare u-boot'
	@echo  '  dir/            - Build all files in dir and below'
	@echo  '  dir/file.[oisS] - Build specified target only'
	@echo  '  dir/file.lst    - Build specified mixed source/assembly target only'
	@echo  '                    (requires a recent binutils and recent build (System.map))'
	@echo  '  tags/ctags	  - Generate ctags file for editors'
	@echo  '  etags		  - Generate etags file for editors'
	@echo  '  cscope	  - Generate cscope index'
	@echo  '  ubootrelease	  - Output the release version string (use with make -s)'
	@echo  '  ubootversion	  - Output the version stored in Makefile (use with make -s)'
	@echo  "  cfg		  - Don't build, just create the .cfg files"
	@echo  "  envtools	  - Build only the target-side environment tools"
	@echo  ''
	@echo  'Static analysers'
	@echo  '  checkstack      - Generate a list of stack hogs'
	@echo  ''
	@echo  'Documentation targets:'
	@$(MAKE) -f $(srctree)/doc/DocBook/Makefile dochelp
	@echo  ''
	@echo  '  make V=0|1 [targets] 0 => quiet build (default), 1 => verbose build'
	@echo  '  make V=2   [targets] 2 => give reason for rebuild of target'
	@echo  '  make O=dir [targets] Locate all output files in "dir", including .config'
	@echo  '  make C=1   [targets] Check all c source with $$CHECK (sparse by default)'
	@echo  '  make C=2   [targets] Force check of all c source with $$CHECK'
	@echo  '  make RECORDMCOUNT_WARN=1 [targets] Warn about ignored mcount sections'
	@echo  '  make W=n   [targets] Enable extra gcc checks, n=1,2,3 where'
	@echo  '		1: warnings which may be relevant and do not occur too often'
	@echo  '		2: warnings which occur quite often but may still be relevant'
	@echo  '		3: more obscure warnings, can most likely be ignored'
	@echo  '		Multiple levels can be combined with W=12 or W=123'
	@echo  ''
	@echo  'Execute "make" or "make all" to build all targets marked with [*] '
	@echo  'For further info see the ./README file'

tests:
	$(srctree)/test/run

# Documentation targets
# ---------------------------------------------------------------------------
%docs: scripts_basic FORCE
	$(Q)$(MAKE) $(build)=scripts build_docproc
	$(Q)$(MAKE) $(build)=doc/DocBook $@

endif #ifeq ($(config-targets),1)
endif #ifeq ($(mixed-targets),1)

PHONY += checkstack ubootrelease ubootversion

checkstack:
	$(OBJDUMP) -d u-boot $$(find . -name u-boot-spl) | \
	$(PERL) $(src)/scripts/checkstack.pl $(ARCH)

ubootrelease:
	@echo "$(UBOOTVERSION)$$($(CONFIG_SHELL) $(srctree)/scripts/setlocalversion $(srctree))"

ubootversion:
	@echo $(UBOOTVERSION)

# Single targets
# ---------------------------------------------------------------------------
# Single targets are compatible with:
# - build with mixed source and output
# - build with separate output dir 'make O=...'
# - external modules
#
#  target-dir => where to store outputfile
#  build-dir  => directory in kernel source tree to use

ifeq ($(KBUILD_EXTMOD),)
        build-dir  = $(patsubst %/,%,$(dir $@))
        target-dir = $(dir $@)
else
        zap-slash=$(filter-out .,$(patsubst %/,%,$(dir $@)))
        build-dir  = $(KBUILD_EXTMOD)$(if $(zap-slash),/$(zap-slash))
        target-dir = $(if $(KBUILD_EXTMOD),$(dir $<),$(dir $@))
endif

%.s: %.c prepare scripts FORCE
	$(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
%.i: %.c prepare scripts FORCE
	$(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
%.o: %.c prepare scripts FORCE
	$(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
%.lst: %.c prepare scripts FORCE
	$(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
%.s: %.S prepare scripts FORCE
	$(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
%.o: %.S prepare scripts FORCE
	$(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
%.symtypes: %.c prepare scripts FORCE
	$(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)

# Modules
/: prepare scripts FORCE
	$(cmd_crmodverdir)
	$(Q)$(MAKE) KBUILD_MODULES=$(if $(CONFIG_MODULES),1) \
	$(build)=$(build-dir)
%/: prepare scripts FORCE
	$(cmd_crmodverdir)
	$(Q)$(MAKE) KBUILD_MODULES=$(if $(CONFIG_MODULES),1) \
	$(build)=$(build-dir)
%.ko: prepare scripts FORCE
	$(cmd_crmodverdir)
	$(Q)$(MAKE) KBUILD_MODULES=$(if $(CONFIG_MODULES),1)   \
	$(build)=$(build-dir) $(@:.ko=.o)
	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost

quiet_cmd_genenv = GENENV $@
cmd_genenv = $(OBJCOPY) --dump-section .rodata.default_environment=$@ env/common.o; \
	sed --in-place -e 's/\x00/\x0A/g' $@

u-boot-initial-env: u-boot.bin
	$(call if_changed,genenv)

# FIXME Should go into a make.lib or something
# ===========================================================================

quiet_cmd_rmdirs = $(if $(wildcard $(rm-dirs)),CLEAN   $(wildcard $(rm-dirs)))
      cmd_rmdirs = rm -rf $(rm-dirs)

quiet_cmd_rmfiles = $(if $(wildcard $(rm-files)),CLEAN   $(wildcard $(rm-files)))
      cmd_rmfiles = rm -f $(rm-files)

# read all saved command lines

targets := $(wildcard $(sort $(targets)))
cmd_files := $(wildcard .*.cmd $(foreach f,$(targets),$(dir $(f)).$(notdir $(f)).cmd))

ifneq ($(cmd_files),)
  $(cmd_files): ;	# Do not try to update included dependency files
  include $(cmd_files)
endif

endif	# skip-makefile

PHONY += FORCE
FORCE:

# Declare the contents of the .PHONY variable as phony.  We keep that
# information in a variable so we can use it in if_changed and friends.
.PHONY: $(PHONY)
