#
# (C) Copyright 2000-2003
# Wolfgang Denk, DENX Software Engineering, wd@denx.de.
#
# SPDX-License-Identifier:	GPL-2.0+
#

extra-y	:= start.o

obj-y	+= cpu.o
obj-y	+= generic_timer.o
obj-y	+= cache_v8.o
obj-y	+= exceptions.o
obj-y	+= cache.o
obj-y	+= tlb.o
obj-y	+= transition.o
obj-y	+= cpu_id.o
obj-y	+= board_id.o

obj-y	+= a32_kernel_pre_entry.o

obj-$(CONFIG_FSL_LSCH3) += fsl-lsch3/
obj-$(CONFIG_AML_MESON) += $(SOC)/


ifdef CONFIG_AML_HW_SHA2
obj-$(CONFIG_SUPPORT_EMMC_RPMB) += hard_sha2.o
obj-$(CONFIG_SHA256) += hard_sha2.o
endif

obj-$(CONFIG_AML_HW_AES) += hw_aes.o
