#
# (C) Copyright 2006
# Wolfgang Denk, DENX Software Engineering, wd@denx.de.
#
# SPDX-License-Identifier:	GPL-2.0+
#

EXTRA_CFLAGS = -Idrivers/nand/include/

obj-$(CONFIG_AML_NAND) += aml_nand_dev.o

aml_nand_dev-y := amlnf_config.o amlnf_ctrl.o amlnf_dev.o cmd_amlnf.o amlnf_env.o amlnf_dtb.o amlnf_key.o cmd_amlnf_test.o
#cmd_amlnf_test.o

