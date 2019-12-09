# SPDX-License-Identifier: GPL-2.0+
#
# Copyright (C) 2020 Dongjin Kim <tobetter@gmail.com>
#

files = bl1.bin.hardkernel \
	bl2.bin.hardkernel.1mb_uboot \
	tzsw.bin.hardkernel \
	sd_fusing.sh

targets = $(foreach blob, $(files), $(srctree)/sd_fuse/$(blob))

$(targets):
	$(Q)cp board/hardkernel/odroid-xu3/$(shell basename $@) \
		$(shell dirname $@)
prepare:
	$(Q)mkdir -p $(srctree)/sd_fuse

$(srctree)/sd_fuse/u-boot.bin: u-boot.bin
	$(Q)cp u-boot.bin $(srctree)/sd_fuse

all: $(srctree)/sd_fuse/u-boot.bin $(targets)
