#!/bin/bash
#
# Copyright (c) 2020 Fuzhou Rockchip Electronics Co., Ltd
#
# SPDX-License-Identifier: GPL-2.0
#

set -e

IMAGE_OFFS="0x800"
IMAGE_ITS="image.its"
IMAGE_ITB="image.itb"

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
				IMAGE_ORG=$2
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

	if [ ! -f $IMAGE_ORG ]; then
		echo "ERROR: No $IMAGE_ORG"
		exit 1
	fi

	if [ -z $IMAGE_DIR ]; then
		IMAGE_DIR="out"
	fi

	mkdir -p $IMAGE_DIR
}

function fit_repack()
{
	./scripts/fit-unpack.sh -f $IMAGE_ORG -o $IMAGE_DIR
	FIT_IMAGE_ITS=$IMAGE_DIR/$IMAGE_ITS

	if grep -q 'hashed-nodes' $FIT_IMAGE_ITS ; then
		echo "ERROR: $IMAGE_ORG was signed, unsupport to repack it!"
		exit 1
	fi

	if grep -q 'uboot@1' $FIT_IMAGE_ITS ; then
		IMAGE_NAME="uboot.img"
	else
		IMAGE_NAME="boot.img"
	fi

	rm -rf IMAGE_NAME
	./tools/mkimage -f $FIT_IMAGE_ITS -E -p $IMAGE_OFFS $IMAGE_NAME

	echo
	echo "Image: $IMAGE_NAME is ready."
	echo
}

args_process $*
fit_repack

