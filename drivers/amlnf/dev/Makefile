

include $(TOPDIR)/config.mk

EXTRA_CFLAGS = -Idrivers/amlnf/include/


LIB	:= $(obj)libamlnf_dev.o

COBJS-y += amlnf_config.o
COBJS-y += amlnf_ctrl.o
COBJS-y += amlnf_dev.o
COBJS-y += cmd_amlnf.o
COBJS-y += amlnf_env.o
COBJS-y += cmd_amlnf_test.o
COBJS-$(CONFIG_SECURITYKEY) += nandkey.o
COBJS-$(CONFIG_SECURE_NAND) += secure_storage.o
COBJS	:= $(COBJS-y)
SRCS	:= $(COBJS:.o=.c)
OBJS	:= $(addprefix $(obj),$(COBJS))

all:	$(LIB)

$(LIB): $(obj).depend $(OBJS)
	$(call cmd_link_o_target, $(OBJS))

#########################################################################

include $(SRCTREE)/rules.mk

sinclude $(obj).depend

#########################################################################
