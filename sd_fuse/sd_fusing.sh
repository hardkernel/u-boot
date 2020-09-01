#!/bin/sh
#
# Copyright (C) 2018 Hardkernel Co,. Ltd
# Dongjin Kim <tobetter@gmail.com>
#
# SPDX-License-Identifier:      GPL-2.0+
#

abort() {
	echo "$1"
	exit 1
}

[ -z "$1" ] && abort "usage: $0 <your/memory/card/device>"
[ -z "$UBOOT" ] && UBOOT="${PWD}/u-boot.bin"
if [ ! -f "$UBOOT" ] ; then
	UBOOT="$(echo "$0" | perl -pe 's/[^\/]*$//g')u-boot.bin"
fi
[ ! -f "$UBOOT" ] && abort "error: $UBOOT is not exist"

sudo dd if="$UBOOT" of="$1" conv=fsync,notrunc bs=512 seek=1

sync

sudo eject "$1"
echo "Finished."
