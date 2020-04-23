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
	printf "\n# Unpack $file to directory $output/\n"
	fdtget -l $file /images > $output/unpack.txt
	cat $output/unpack.txt | while read line
	do
		# generate image
		node="/images/${line}"
		name=`fdtget -ts $file $node image`
		offs=`fdtget -ti $file $node data-position`
		size=`fdtget -ti $file $node data-size`
		if [ -z $offs ]; then
			continue;
		fi

		if [ $size -ne 0 ]; then
			dd if=$file of=$output/dd.tmp  bs=$offs skip=1  >/dev/null 2>&1
			dd if=$output/dd.tmp of=$output/$name bs=$size count=1 >/dev/null 2>&1
			rm $output/dd.tmp
		else
			touch $output/$name
		fi

		# hash verify
		algo=`fdtget -ts $file $node/hash@1 algo`
		if [ -z $algo ]; then
			printf "    %-20s: %d bytes" $name $size
			continue;
		fi

		data=`fdtget -tx $file $node/hash@1 value`
		data=`echo " "$data | sed "s/ / 0x/g"`
		csum=`"$algo"sum $output/$name | awk '{ print $1}'`

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

		printf "  %-20s: %d bytes... %s" $name $size $algo
		if [ "$csum" = "$hash" -o $size -eq 0 ]; then
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

