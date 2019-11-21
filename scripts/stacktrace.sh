#!/bin/bash
#
# Copyright (c) 2019 Fuzhou Rockchip Electronics Co., Ltd
#
# SPDX-License-Identifier: GPL-2.0
#

set -e
ARGS_N=$#
INPUT_FILE=$1
TPL_SPL=$2


if [ "$TPL_SPL" = "tpl" ]; then
	SYMBOL_FILE=`find -name u-boot-tpl.sym`
elif [ "$TPL_SPL" = "spl" ]; then
	SYMBOL_FILE=`find -name u-boot-spl.sym`
else
	SYMBOL_FILE=`find -name u-boot.sym`
fi

echo
if [ $ARGS_N -eq 0 ]; then
	echo "Usage: "
	echo "	./scripts/stacktrace.sh <file> <type>"
	echo
	echo "Param:"
	echo "	<file>: stacktrace info file"
	echo "	<type>: none, spl, tpl"
	echo
	echo "Example:"
	echo "	./scripts/stacktrace.sh ./dump.txt"
	echo "	./scripts/stacktrace.sh ./dump.txt tpl"
	echo "	./scripts/stacktrace.sh ./dump.txt spl"
	echo
	exit 1
elif [ ! -f $INPUT_FILE ]; then
	echo "Can't find input file: $INPUT_FILE"
	exit 1
elif [ "$SYMBOL_FILE" = '' ] || [ ! -f $SYMBOL_FILE ]; then
	echo "Can't find symbol file: ${SYMBOL_FILE}"
	exit 1
fi

echo "SYMBOL File: ${SYMBOL_FILE}"
echo
# Parse PC and LR
echo "Call trace:"
grep '\[< ' $INPUT_FILE | grep '>\]' | grep [PC,LR] | while read line
do
	echo -n " ${line}  "

	frame_pc_str=`echo $line | awk '{ print "0x"$3 }'`
	frame_pc_dec=`echo $line | awk '{ print strtonum("0x"$3); }'`
	frame_pc_hex=`echo "obase=16;${frame_pc_dec}"|bc |tr '[A-Z]' '[a-z]'`

	f_pc_dec=`cat ${SYMBOL_FILE} | sort | awk '/\.text/ { if (strtonum("0x"$1) > '$frame_pc_str') { print fpc; exit; } fpc=strtonum("0x"$1); }'`
	f_pc_hex=`echo "obase=16;${f_pc_dec}"|bc |tr '[A-Z]' '[a-z]'`
	f_offset_dec=$((frame_pc_dec-f_pc_dec))
	f_offset_hex=`echo "obase=16;${f_offset_dec}"|bc |tr '[A-Z]' '[a-z]'`

	cat ${SYMBOL_FILE} | sort |
	awk -v foffset=$f_offset_hex '/\.text/ {
		if (strtonum("0x"$1) > '$frame_pc_str') {
			printf("%s+0x%s/0x%x      ", fname, foffset, fsize);
			exit
		}
		fname=$NF;
		fsize=strtonum("0x"$5);
		fpc=strtonum("0x"$1);
	}'

	func_path=`./make.sh $frame_pc_str | awk '{ print $1 }' | sed -n "/home/p"`
	func_path=`echo ${func_path##*boot/}`
	echo $func_path
done
echo

# Parse stack
echo "Stack:"
grep '\[< ' $INPUT_FILE | grep '>\]' | grep -v [PC,LR] | while read line
do
	echo -n "       ${line}  "

	frame_pc_str=`echo $line | awk '{ print "0x"$2 }'`
	frame_pc_dec=`echo $line | awk '{ print strtonum("0x"$2); }'`
	frame_pc_hex=`echo "obase=16;${frame_pc_dec}"|bc |tr '[A-Z]' '[a-z]'`

	f_pc_dec=`cat ${SYMBOL_FILE} | sort | awk '/\.text/ { if (strtonum("0x"$1) > '$frame_pc_str') { print fpc; exit; } fpc=strtonum("0x"$1); }'`
	f_pc_hex=`echo "obase=16;${f_pc_dec}"|bc |tr '[A-Z]' '[a-z]'`
	f_offset_dec=$((frame_pc_dec-f_pc_dec))
	f_offset_hex=`echo "obase=16;${f_offset_dec}"|bc |tr '[A-Z]' '[a-z]'`

	cat ${SYMBOL_FILE} | sort |
	awk -v foffset=$f_offset_hex '/\.text/ {
		if (strtonum("0x"$1) > '$frame_pc_str') {
			printf("%s+0x%s/0x%x\n", fname, foffset, fsize);
			exit
		}
		fname=$NF;
		fsize=strtonum("0x"$5);
		fpc=strtonum("0x"$1);
	}'
done
echo
