#!/bin/bash
#
# Copyright (c) 2022 Fuzhou Rockchip Electronics Co., Ltd
#
# SPDX-License-Identifier: GPL-2.0
#
set -e

BIN=$1

dec_size=`wc ${BIN} | awk '{ printf $3 }'`
ch0=`printf "%08x\n" $dec_size | sed 's/\(..\)/\1 /g' | awk '{ printf $4 }'`
ch0=`printf '%03o' $((0x$ch0))`
ch1=`printf "%08x\n" $dec_size | sed 's/\(..\)/\1 /g' | awk '{ printf $3 }'`
ch1=`printf '%03o' $((0x$ch1))`
ch2=`printf "%08x\n" $dec_size | sed 's/\(..\)/\1 /g' | awk '{ printf $2 }'`
ch2=`printf '%03o' $((0x$ch2))`
ch3=`printf "%08x\n" $dec_size | sed 's/\(..\)/\1 /g' | awk '{ printf $1 }'`
ch3=`printf '%03o' $((0x$ch3))`

(cat ${BIN} | lzma -9 -k -f && printf \\$ch0\\$ch1\\$ch2\\$ch3) > ${BIN}.lzma
