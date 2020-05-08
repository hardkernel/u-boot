#!/bin/bash
#
# Copyright (c) 2020 Fuzhou Rockchip Electronics Co., Ltd
#
# SPDX-License-Identifier: GPL-2.0
#
set -e

function usage()
{
	echo
	echo "usage:"
	echo "    $0 -f [fit/itb] -o [output]"
	echo
}

function args_process()
{
	if [ $# -ne 4 -a $# -ne 2 ]; then
		usage
		exit 1
	fi

	while [ $# -gt 0 ]; do
		case $1 in
			-f)
				IMAGE=$2
				shift 2
				;;
			-o)
				IMAGE_DIR=$2
				shift 2
				;;
			*)
				usage
				exit 1
				;;
		esac
	done

	if [ ! -f $IMAGE ]; then
		echo "ERROR: No $IMAGE"
		exit 1
	fi

	if [ -z $IMAGE_DIR ]; then
		IMAGE_DIR="out"
	fi

	mkdir -p $IMAGE_DIR
}

function gen_images()
{
	printf "\n# Unpack $IMAGE to directory $IMAGE_DIR/\n"
	fdtget -l $IMAGE /images > $IMAGE_DIR/unpack.txt
	cat $IMAGE_DIR/unpack.txt | while read line
	do
		# generate image
		NODE="/images/${line}"
		NAME=`fdtget -ts $IMAGE $NODE image`
		OFFS=`fdtget -ti $IMAGE $NODE data-position`
		SIZE=`fdtget -ti $IMAGE $NODE data-size`
		if [ -z $OFFS ]; then
			continue;
		fi

		if [ $SIZE -ne 0 ]; then
			dd if=$IMAGE of=$IMAGE_DIR/dd.tmp  bs=$OFFS skip=1  >/dev/null 2>&1
			dd if=$IMAGE_DIR/dd.tmp of=$IMAGE_DIR/$NAME bs=$SIZE count=1 >/dev/null 2>&1
			rm $IMAGE_DIR/dd.tmp
		else
			touch $IMAGE_DIR/$NAME
		fi

		# hash verify
		algo=`fdtget -ts $IMAGE $NODE/hash@1 algo`
		if [ -z $algo ]; then
			printf "    %-20s: %d bytes" $NAME $SIZE
			continue;
		fi

		data=`fdtget -tx $IMAGE $NODE/hash@1 value`
		data=`echo " "$data | sed "s/ / 0x/g"`
		csum=`"$algo"sum $IMAGE_DIR/$NAME | awk '{ print $1}'`

		hash=""
		for((i=1;;i++));
		do
			hex=`echo $data | awk -v idx=$i '{ print $idx }'`
			if [ -z $hex ]; then
				break;
			fi

			hex=`printf "%08x" $hex` # align !!
			hash="$hash$hex"
		done

		printf "  %-20s: %d bytes... %s" $NAME $SIZE $algo
		if [ "$csum" = "$hash" -o $SIZE -eq 0 ]; then
			echo "+"
		else
			echo "-"
		fi
	done

	rm $output/unpack.txt
	echo
}

args_process $*
gen_images

