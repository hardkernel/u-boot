#
# Copyright (c) 2018 Fuzhou Rockchip Electronics Co., Ltd
#
# SPDX-License-Identifier:	GPL-2.0
#

obj-$(CONFIG_RKNANDC_NAND) += rkflash_blk.o rknandc_base.o rkflash_api.o rkflash_debug.o flash.o nandc.o
obj-$(CONFIG_RKSFC_NAND) += rkflash_blk.o rksfc_base.o  rkflash_api.o rkflash_debug.o sfc_nand.o sfc.o
obj-$(CONFIG_RKSFC_NOR) += rkflash_blk.o rksfc_base.o rkflash_api.o rkflash_debug.o sfc_nor.o sfc.o

ifneq (, $(CONFIG_RKNANDC_NAND)$(CONFIG_RKSFC_NAND))

ifdef CONFIG_ARM64
obj-y += rk_sftl_arm_v8.o
else
obj-y += rk_sftl_arm_v7.o
endif

endif
