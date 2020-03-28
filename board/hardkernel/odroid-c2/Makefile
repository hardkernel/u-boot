# SPDX-License-Identifier: GPL-2.0+
#
# Copyright (C) 2020 Dongjin Kim <tobetter@gmail.com>
#

BOARD_DIR := $(srctree)/board/hardkernel/odroid-c2

files = bl1.bin.hardkernel \
	sd_fusing.sh

targets = $(foreach blob, $(files), $(srctree)/sd_fuse/$(blob))

$(targets):
	$(Q)cp $(BOARD_DIR)/$(shell basename $@) \
		$(shell dirname $@)

prepare:
	$(Q)mkdir -p $(srctree)/sd_fuse

$(srctree)/sd_fuse/u-boot.bin: u-boot.bin
	$(Q)$(BOARD_DIR)/fip_create/fip_create \
		--bl30 $(BOARD_DIR)/fip/gxb/bl30.bin \
		--bl301 $(BOARD_DIR)/fip/gxb/bl301.bin \
		--bl31 $(BOARD_DIR)/fip/gxb/bl31.bin \
		--bl33 u-boot.bin \
		$(BOARD_DIR)/u-boot.bin.fip
	$(Q)$(BOARD_DIR)/fip_create/fip_create --dump \
		$(BOARD_DIR)/u-boot.bin.fip
	$(Q)cat $(BOARD_DIR)/fip/gxb/bl2.bin \
		$(BOARD_DIR)/u-boot.bin.fip \
		> $(BOARD_DIR)/u-boot.bin.bundle
	$(Q)$(BOARD_DIR)/meson-tools/amlbootsig \
		$(BOARD_DIR)/u-boot.bin.bundle \
		$(BOARD_DIR)/u-boot.bin.signed >/dev/null
	$(Q)dd if=$(BOARD_DIR)/u-boot.bin.signed of=$@ bs=512 skip=96

all: $(srctree)/sd_fuse/u-boot.bin $(targets)
