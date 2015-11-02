#
# (C) Copyright 2000-2007
# Wolfgang Denk, DENX Software Engineering, wd@denx.de.
#
# SPDX-License-Identifier:	GPL-2.0+
#


EXTRA_CFLAGS = -Idrivers/nand/include/

obj-$(CONFIG_AML_NAND) += aml_nand_phy.o

aml_nand_phy-y := amlnand_init.o chip.o chip_operation.o hw_controller.o id_table.o phydev.o chipenv.o new_nand.o boot_operation.o cmd_utils.o

