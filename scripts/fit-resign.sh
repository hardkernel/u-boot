#!/bin/bash
#
# Copyright (c) 2020 Fuzhou Rockchip Electronics Co., Ltd
# SPDX-License-Identifier: GPL-2.0
#
set -e

FIT_IMG=$1
FIT_SIG=$2

if [ $# -ne 2 ]; then
	echo "Usage: $0 [signed fit image] [new signature]"
	exit
elif [ ! -f $FIT_IMG ]; then
	echo "ERROR: No $FIT_IMG"
	exit
elif [ ! -f $FIT_SIG ]; then
	echo "ERROR: No $FIT_SIG"
	exit
fi

SIG_SZ=`ls -l ${FIT_SIG} | awk '{ print $5 }'`
LEN=`./tools/fit_info -f $FIT_IMG -n /configurations/conf@1/signature@1 -p value | sed -n "/LEN:/p" | awk '{ print $2 }'`
OFF=`./tools/fit_info -f $FIT_IMG -n /configurations/conf@1/signature@1 -p value | sed -n "/OFF:/p" | awk '{ print $2 }'`
END=`./tools/fit_info -f $FIT_IMG -n /configurations/conf@1/signature@1 -p value | sed -n "/END:/p" | awk '{ print $2 }'`

if [ -z $LEN ]; then
	echo "ERROR: No valid signature in $FIT_IMG"
	exit
elif [ "$SIG_SZ" -ne "$LEN" ]; then
	echo "ERROR: $FIT_SIG size $SIG_SZ != $FIT_IMG Signature size $LEN"
	exit
fi

dd if=$FIT_IMG of=$FIT_IMG.part1 count=1 bs=$OFF
dd if=$FIT_IMG of=$FIT_IMG.part2 skip=1 ibs=$END

cat $FIT_IMG.part1  >  $FIT_IMG.resig
cat $FIT_SIG        >> $FIT_IMG.resig
cat $FIT_IMG.part2  >> $FIT_IMG.resig

rm $FIT_IMG.part1 && $FIT_IMG.part2

echo
echo "Re-signed fit image is OK: $FIT_IMG.resig"
echo

