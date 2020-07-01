#!/bin/bash
#
# Copyright (c) 2020 Rockchip Electronics Co., Ltd
#
# SPDX-License-Identifier: GPL-2.0
#

srctree=$PWD

function help()
{
	echo
	echo "Description:"
	echo "    Process args for all rockchip fit generator script, and providing variables for it's caller"
	echo
	echo "Usage:"
	echo "    $0 [args]"
	echo
	echo "[args]:"
	echo "--------------------------------------------------------------------------------------------"
	echo "    arg                 type       output variable       description"
	echo "--------------------------------------------------------------------------------------------"
	echo "    -c [comp]     ==>   <string>   COMPRESSION           set compression: \"none\", \"gzip\""
	echo "    -m [offset]   ==>   <hex>      MCU_LOAD_ADDR         set mcu.bin offset address"
	echo "    -t [offset]   ==>   <hex>      TEE_LOAD_ADDR         set tee.bin offset address"
	echo "    -u            ==>   -          UBOOT_LOAD_ADDR       auto get CONFIG_SYS_TEXT_BASE address"
	echo
}

if [ -z $1 ]; then
	help
	exit
fi

# args
while [ $# -gt 0 ]; do
	case $1 in
		--help|-help|help|--h|-h)
			help
			exit
			;;
		-c)
			COMPRESSION=$2
			shift 2
			;;
		-m)
			MCU_OFFSET=$2
			shift 2
			;;
		-t)
			TEE_OFFSET=$2
			shift 2
			;;
		-u)
			UBOOT_LOAD_ADDR=`sed -n "/CONFIG_SYS_TEXT_BASE=/s/CONFIG_SYS_TEXT_BASE=//p" ${srctree}/include/autoconf.mk|tr -d '\r'`
			shift 1
			;;
		*)
			echo "Invalid arg: $1"
			help
			exit 1
			;;
	esac
done

# Base
DARM_BASE=`sed -n "/CONFIG_SYS_SDRAM_BASE=/s/CONFIG_SYS_SDRAM_BASE=//p" ${srctree}/include/autoconf.mk|tr -d '\r'`

# tee
if [ ! -z "${TEE_OFFSET}" ]; then
	TEE_LOAD_ADDR=$((DARM_BASE+TEE_OFFSET))
	TEE_LOAD_ADDR=$(echo "obase=16;${TEE_LOAD_ADDR}"|bc)
fi

# mcu
if [ ! -z "$MCU_OFFSET" ]; then
	MCU_LOAD_ADDR=$((DARM_BASE+$MCU_OFFSET))
	MCU_LOAD_ADDR=$(echo "obase=16;${MCU_LOAD_ADDR}"|bc)
fi

# echo " ## $DARM_BASE, $UBOOT_LOAD_ADDR, $TEE_LOAD_ADDR, $MCU_LOAD_ADDR"
