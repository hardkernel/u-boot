#!/bin/bash
#
# Copyright (c) 2020 Fuzhou Rockchip Electronics Co., Ltd
#
# SPDX-License-Identifier: GPL-2.0
#

FIT_UBOOT_IMAGES=(
	"/images/uboot@1      u-boot-nodtb.bin"
	"/images/optee@1      tee.bin"
	"/images/fdt@1        u-boot.dtb"
)

FIT_BOOT_IMAGES=(
	"/images/kernel@1     kernel.img"
	"/images/ramdisk@1    ramdisk.img"
	"/images/resource@1   resource.img"
	"/images/fdt@1        rk-kernel.dtb"
)

function usage()
{
	echo
	echo "usage:"
	echo "    $0 -f [fit/itb image] -o [output] -u    // unpack uboot.fit/itb"
	echo "    $0 -f [fit/itb image] -o [output] -b    // unpack boot.fit/itb"
	echo
}

function args_process()
{
	if [ $# -ne 5 ]; then
		usage
		exit 1
	fi

	while [ $# -gt 0 ]; do
		case $1 in
			-b|-u)
				TYPE=$1
				shift 1
				;;
			-f)
				IMAGE=$2
				shift 2
				;;
			-o)
				OUTPUT=$2
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
	elif [ -z $OUTPUT ]; then
		echo "ERROR: No output"
		exit 1
	elif [ -z $TYPE ]; then
		echo "ERROR: No args -u or -b"
		exit 1
	fi

	mkdir -p $OUTPUT
}

function copy_image()
{
	LIST=$1

	NODE=`echo $LIST | awk '{ print $1 }'`
	NAME=`echo $LIST | awk '{ print $2 }'`
	OFFS=`fdtget -ti $IMAGE $NODE data-position`
	SIZE=`fdtget -ti $IMAGE $NODE data-size`
	if [ -z $OFFS ]; then
		echo "ERROR: No find $NODE"
		exit 1
	fi

	printf "    %-15s: %d bytes\n" $OUTPUT$NAME $SIZE
	if [ $SIZE -ne 0 ]; then
		dd if=$IMAGE         of=$OUTPUT/dd.tmp  bs=$OFFS skip=1  >/dev/null 2>&1
		dd if=$OUTPUT/dd.tmp of=$OUTPUT/$NAME   bs=$SIZE count=1 >/dev/null 2>&1
		rm $OUTPUT/dd.tmp
	else
		touch $OUTPUT/$NAME
	fi
}

function gen_images()
{
	echo "Image:"
	if [ $TYPE = "-u" ]; then
		for LIST in "${FIT_UBOOT_IMAGES[@]}"
		do
			copy_image "$LIST"
		done
	elif [ $TYPE = "-k" ]; then
		for LIST in "${FIT_BOOT_IMAGES[@]}"
		do
			copy_image "$LIST"
		done
	fi
	echo
}

args_process $*
gen_images