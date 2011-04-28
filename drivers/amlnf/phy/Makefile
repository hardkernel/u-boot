

include $(TOPDIR)/config.mk

EXTRA_CFLAGS = -Idrivers/amlnf/include/


LIB	:= $(obj)libamlnf_phy.o

COBJS-y += amlnand_init.o
COBJS-y += chip.o
COBJS-y += chip_operation.o
COBJS-y += hw_controller.o
COBJS-y += id_table.o
COBJS-y += phydev.o
COBJS-y += chipenv.o
COBJS-y += new_nand.o
COBJS-y += boot_operation.o 
COBJS-y += cmd_utils.o 

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
