# ------------------------------------------------------------
# Makefile for BL301 SCP User Task
# ------------------------------------------------------------
include $(buildsrc)/config.mk
include $(buildtree)/include/autoconf.mk
include $(buildtree)/.config

# Select ARMv7-m bare-metal toolchain
CROSS_COMPILE=arm-none-eabi-
ASM=$(CROSS_COMPILE)as
CC=$(CROSS_COMPILE)gcc
CPP=$(CROSS_COMPILE)cpp
LD=$(CROSS_COMPILE)ld
OBJCOPY=$(CROSS_COMPILE)objcopy
OBJDUMP=$(CROSS_COMPILE)objdump

ARM_ARCH=armv7-m
ARM_CPU=cortex-m3
CFLAGS_WARN=-Wall -Werror -Wundef -Wstrict-prototypes -Wno-trigraphs      \
            -fno-strict-aliasing -fno-common -fomit-frame-pointer         \
            -Werror-implicit-function-declaration -Wno-format-security    \
            -fno-delete-null-pointer-checks -Wdeclaration-after-statement \
            -Wno-pointer-sign -fno-strict-overflow -fconserve-stack
CFLAGS_DEBUG=-g

# CPU specific compilation flags
CFLAGS_CPU=-march=$(ARM_ARCH) -mcpu=$(ARM_CPU) -mthumb -Os -mno-sched-prolog

# FPU compilation flags
CFLAGS_FPU-$(CONFIG_FPU)=-mfpu=fpv4-sp-d16 -mfloat-abi=hard

CFLAGS_INCLUDE=-I$(buildsrc)/build/include/ \
               -I$(buildsrc)/include/ \
               -I$(buildsrc)/arch/arm/include/ \
               -I. \
               -I./include \
               -I./build

#VPATH_LIST=     $(buildsrc)/board/$(BOARDDIR)
VPATH_LIST=     $(buildsrc)/$(BOARDDIR)

VPATH_LIST:=$(VPATH_LIST:%=%/firmware/scp_task/)

CFLAGS=$(CFLAGS_CPU) $(CFLAGS_WARN) $(VPATH_LIST:%=-I%) $(CFLAGS_INCLUDE) $(CFLAGS_FPU-y)
ASFLAGS= -gdwarf2 -mcpu=$(ARM_CPU)
DUMP_FLAGS = -D -x

LDFLAGS=-Bstatic
#LDFLAGS+=$(LD_LIB_PATH_ARM:%=-L%) -lm -lc -lgcc

# Output directory for build objects
obj=$(buildtree)/scp_task

vpath %.lds ./
vpath %.S ./
vpath %.c $(VPATH_LIST)
vpath %.c ./

#OBJS = user_task_entry.o
OBJS = task_entry.o
OBJS += user_task.o
OBJS += misc.o
OBJS += uart.o
OBJS += suspend.o
OBJS += lib/string.o
OBJS += lib/delay.o

OBJS := $(OBJS:%=$(obj)/%)

all : clean $(obj)/bl301.out $(obj)/bl301.bin

$(obj)/bl301.bin: $(obj)/bl301.out
	@echo "	OBJCOPY $@"
	@$(OBJCOPY)  --gap-fill=0xff -O binary $< $@

$(obj)/bl301.out: Makefile $(OBJS)
	@echo "	LD $@"
	@echo "	OBJDUMP $(obj)/bl301.dis"
	@$(LD) $(OBJS) $(LDFLAGS) -T $(obj)/user_task.lds -Map $(obj)/bl301.map -o $@
	@$(OBJDUMP) $(DUMP_FLAGS) $@ > $(obj)/bl301.dis

$(OBJS): $(obj)/user_task.lds

$(obj)/%.o : %.c
	@echo "	CC $(subst $(obj)/,,$@)"
	@mkdir -p $(@D)
	@$(CC) $(CFLAGS) -MD  -c $< -o $@

$(obj)/misc.s:	misc.S
	@mkdir -p $(@D)
	@echo "	CPP $(subst $(obj)/,,$@)"
	@$(CPP) -D__ASSEMBLY__ -E $< -o $@

$(obj)/task_entry.s:  task_entry.S
	@mkdir -p $(@D)
	@echo "	CPP $(subst $(obj)/,,$@)"
	@$(CPP) -D__ASSEMBLY__ -E $< -o $@

$(obj)/misc.o:	$(obj)/misc.s
	@echo "	CC $(subst $(obj)/,,$@)"
	@mkdir -p $(@D)
	@$(CC) $(CFLAGS) -MD  -c $< -o $@

$(obj)/task_entry.o:	$(obj)/task_entry.s
	@echo "	CC $(subst $(obj)/,,$@)"
	@mkdir -p $(@D)
	@$(CC) $(CFLAGS) -MD  -c $< -o $@

$(obj)/user_task.lds : user_task.lds
	@mkdir -p $(@D)
	@echo "	CPP $(subst $(obj)/,,$@)"
	@$(CPP) $(CFLAGS) -P $< $@

clean:
	@-rm -rf $(obj)/
	@-rm -rf $(OBJS)

-include $(wildcard $(obj)/*.d)
