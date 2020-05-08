#!/bin/bash
#
# Copyright (c) 2020 Fuzhou Rockchip Electronics Co., Ltd
#
# SPDX-License-Identifier: GPL-2.0
#
set -e

IMAGE_ITS="image.its"

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

	echo
}

function gen_its()
{
	./scripts/dtc/dtc -I dtb -O dts $IMAGE -o $IMAGE_DIR/$IMAGE_ITS >/dev/null 2>&1

	FIT_IMAGE_ITS=$IMAGE_DIR/$IMAGE_ITS

	# remove
	sed -i "/memreserve/d"       $FIT_IMAGE_ITS
	sed -i "/data-size/d"        $FIT_IMAGE_ITS
	sed -i "/data-position/d"    $FIT_IMAGE_ITS
	sed -i "/value/d"            $FIT_IMAGE_ITS
	sed -i "/hashed-strings/d"   $FIT_IMAGE_ITS
	sed -i "/hashed-nodes/d"     $FIT_IMAGE_ITS
	sed -i "/signer-version/d"   $FIT_IMAGE_ITS
	sed -i "/signer-name/d"      $FIT_IMAGE_ITS
	sed -i "/timestamp/d"        $FIT_IMAGE_ITS

	# add placeholder
	sed -i '/image = /a\	\	\	data = /incbin/("IMAGE_PATH");' $FIT_IMAGE_ITS

	# fixup placeholder: "data = /incbin/("...");"
	num=`grep 'image =' $FIT_IMAGE_ITS | wc -l`
	for ((i = 1; i <= $num; i++));
	do
		NAME=`grep 'image =' $FIT_IMAGE_ITS | sed -n ''${i}p'' | awk '{ printf $3 }' | tr -d '";'`
		sed -i ''$i',/IMAGE_PATH/{s/IMAGE_PATH/.\/'$NAME'/}'  $FIT_IMAGE_ITS
	done
}

args_process $*
gen_images
gen_its

