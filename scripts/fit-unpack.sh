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
				file=$2
				shift 2
				;;
			-o)
				output=$2
				shift 2
				;;
			*)
				usage
				exit 1
				;;
		esac
	done

	if [ ! -f $file ]; then
		echo "ERROR: No $file"
		exit 1
	fi

	if [ -z $output ]; then
		output="out"
	fi

	mkdir -p $output
}

function gen_images()
{
	printf "\n## Unpack $file to directory $output/\n"
	fdtget -l $file /images > $output/unpack.txt
	cat $output/unpack.txt | while read line
	do
		node="/images/${line}"
		name=`fdtget -ts $file $node image`
		offs=`fdtget -ti $file $node data-position`
		size=`fdtget -ti $file $node data-size`
		if [ -z $offs ]; then
			continue;
		fi

		printf "    %-15s: %d bytes\n" ${name} $size
		if [ $size -ne 0 ]; then
			dd if=$file of=$output/dd.tmp  bs=$offs skip=1  >/dev/null 2>&1
			dd if=$output/dd.tmp of=$output/$name bs=$size count=1 >/dev/null 2>&1
			rm $output/dd.tmp
		else
			touch $output/$name
		fi
	done

	rm $output/unpack.txt
	echo
}

args_process $*
gen_images