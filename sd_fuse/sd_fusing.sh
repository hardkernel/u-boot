#!/bin/sh

#
# fusing script for ODROID-GO2 based on Rockchip RK3326
#

IDBLOADER=idbloader.img
UBOOT=uboot.img
TRUST=trust.img

if [ -z $1 ]; then
        echo "Usage ./sd_fusing.sh <SD card reader's device>"
        exit 1
fi

sudo dd if=$IDBLOADER of=$1 conv=fsync bs=512 seek=64
sudo dd if=$UBOOT of=$1 conv=fsync bs=512 seek=16384
sudo dd if=$TRUST of=$1 conv=fsync bs=512 seek=24576

sync

sudo eject $1

echo Finished
