#!/bin/bash
#
# Copyright (c) 2019 Fuzhou Rockchip Electronics Co., Ltd
#
# SPDX-License-Identifier: GPL-2.0
#

set -e
JOB=`sed -n "N;/processor/p" /proc/cpuinfo|wc -l`
SUPPORT_LIST=`ls configs/*[r,p][x,v,k][0-9][0-9]*_defconfig`
CMD_ARGS=$1

# @LOADER: map to $RKCHIP_LOADER for loader ini
# @TRUST:  map to $RKCHIP_TRUST for trust ini
# @LABEL:  map to $RKCHIP_LEBEL for verbose message
# @-:      default state/value
CHIP_TYPE_FIXUP_TABLE=(
	# CONFIG_XXX                         RKCHIP         LOADER       TRUST         LABEL
	"CONFIG_ROCKCHIP_RK3368              RK3368H         -            -             -"
	"CONFIG_ROCKCHIP_RV1108              RV110X          -            -             -"
	"CONFIG_ROCKCHIP_PX3SE               PX3SE           -            -             -"
	"CONFIG_ROCKCHIP_RK3126              RK3126          -            -             -"
	"CONFIG_ROCKCHIP_RK3326              RK3326          -            -             -"
	"CONFIG_ROCKCHIP_RK3128X             RK3128X         -            -             -"
	"CONFIG_ROCKCHIP_PX5                 PX5             -            -             -"
	"CONFIG_ROCKCHIP_RK3399PRO           RK3399PRO       -            -             -"
	"CONFIG_ROCKCHIP_RK1806              RK1806          -            -             -"
	"CONFIG_TARGET_GVA_RK3229            RK322X          RK322XAT     -             -"
	"CONFIG_COPROCESSOR_RK1808           RKNPU-LION      RKNPULION    RKNPULION     -"
)

# <*> Fixup rsa/sha pack mode for platforms
#     RSA: RK3308/PX30/RK3326/RK1808 use RSA-PKCS1 V2.1, it's pack magic is "3", and others use default configure.
#     SHA: RK3368 use rk big endian SHA256, it's pack magic is "2", and others use default configure.
# <*> Fixup images size pack for platforms
# <*> Fixup verbose message about AARCH32
#
# @RSA:     rsa mode
# @SHA:     sha mode
# @A64-KB:  arm64 platform image size: [uboot,trust]
# @A64-NUM: arm64 platform image number of total: [uboot,trust]
# @A32-KB:  arm32 platform image size: [uboot,trust]
# @A32-NUM: arm32 platform image number of total: [uboot,trust]
# @LOADER:  map to $RKCHIP_LOADER for loader ini
# @TRUST:   map to $RKCHIP_TRUST for trust ini
# @-:       default state/value
CHIP_CFG_FIXUP_TABLE=(
	# CONFIG_XXX              RSA     SHA     A64-KB      A64-NUM     A32-KB       A32-NUM      LOAER        TRUST
	"CONFIG_ROCKCHIP_RK3368    -       2       -,-          -,-        -,-          -,-           -           -"
	"CONFIG_ROCKCHIP_RK3036    -       -       512,512      1,1        -,-          -,-           -           -"
	"CONFIG_ROCKCHIP_PX30      3       -       -,-          -,-        -,-          -,-           -           -"
	"CONFIG_ROCKCHIP_RK3326    3       -       -,-          -,-        -,-          -,-           AARCH32     -"
	"CONFIG_ROCKCHIP_RK3308    3       -       1024,1024    2,2        512,512      2,2           -           AARCH32"
	"CONFIG_ROCKCHIP_RK1808    3       -       1024,1024    2,2        -,-          -,-           -           -"
	"CONFIG_ROCKCHIP_RV1126    3       -       -,-          -,-        -,-          -,-           -           -"
)

########################################### User can modify #############################################
# User's rkbin tool relative path
RKBIN_TOOLS=../rkbin/tools

# User's GCC toolchain and relative path
ADDR2LINE_ARM32=arm-linux-gnueabihf-addr2line
ADDR2LINE_ARM64=aarch64-linux-gnu-addr2line
OBJ_ARM32=arm-linux-gnueabihf-objdump
OBJ_ARM64=aarch64-linux-gnu-objdump
NM_ARM32=arm-linux-gnueabihf-nm
NM_ARM64=aarch64-linux-gnu-nm
GCC_ARM32=arm-linux-gnueabihf-
GCC_ARM64=aarch64-linux-gnu-
TOOLCHAIN_ARM32=../prebuilts/gcc/linux-x86/arm/gcc-linaro-6.3.1-2017.05-x86_64_arm-linux-gnueabihf/bin
TOOLCHAIN_ARM64=../prebuilts/gcc/linux-x86/aarch64/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu/bin

########################################### User not touch #############################################
# Declare global INI file searching index name for every chip, update in select_chip_info()
RKCHIP="-"
RKCHIP_LABEL="-"
RKCHIP_LOADER="-"
RKCHIP_TRUST="-"

INI_TRUST=
INI_LOADER=

# Declare rkbin repository path, updated in prepare()
RKBIN=

# Declare global toolchain path for CROSS_COMPILE, updated in select_toolchain()
TOOLCHAIN_GCC=
TOOLCHAIN_NM=
TOOLCHAIN_OBJDUMP=
TOOLCHAIN_ADDR2LINE=

# Declare global plaform configure, updated in fixup_platform_configure()
PLAT_RSA=
PLAT_SHA=
PLAT_UBOOT_SIZE=
PLAT_TRUST_SIZE=
PLAT_TYPE="RKFW" # default

SRCTREE=`pwd`
SCRIPT_FIT="${SRCTREE}/scripts/fit.sh"
SCRIPT_ATF="${SRCTREE}/scripts/atf.sh"
SCRIPT_TOS="${SRCTREE}/scripts/tos.sh"
SCRIPT_SPL="${SRCTREE}/scripts/spl.sh"
SCRIPT_UBOOT="${SRCTREE}/scripts/uboot.sh"
SCRIPT_LOADER="${SRCTREE}/scripts/loader.sh"

#########################################################################################################
function help()
{
	echo
	echo "Usage:"
	echo "	./make.sh [board|sub-command]"
	echo
	echo "	 - board:        board name of defconfig"
	echo "	 - sub-command:  elf*|loader|trust|uboot|--spl|--tpl|itb|map|sym|<addr>"
	echo "	 - ini:          ini file to pack trust/loader"
	echo
	echo "Output:"
	echo "	 When board built okay, there are uboot/trust/loader images in current directory"
	echo
	echo "Example:"
	echo
	echo "1. Build:"
	echo "	./make.sh evb-rk3399               --- build for evb-rk3399_defconfig"
	echo "	./make.sh firefly-rk3288           --- build for firefly-rk3288_defconfig"
	echo "	./make.sh EXT_DTB=rk-kernel.dtb    --- build with exist .config and external dtb"
	echo "	./make.sh                          --- build with exist .config"
	echo "	./make.sh env                      --- build envtools"
	echo
	echo "2. Pack:"
	echo "	./make.sh uboot                    --- pack uboot.img"
	echo "	./make.sh trust                    --- pack trust.img"
	echo "	./make.sh trust <ini>              --- pack trust img with assigned ini file"
	echo "	./make.sh loader                   --- pack loader bin"
	echo "	./make.sh loader <ini>             --- pack loader img with assigned ini file"
	echo "	./make.sh --spl                    --- pack loader with u-boot-spl.bin"
	echo "	./make.sh --tpl                    --- pack loader with u-boot-tpl.bin"
	echo "	./make.sh --tpl --spl              --- pack loader with u-boot-tpl.bin and u-boot-spl.bin"
	echo
	echo "3. Debug:"
	echo "	./make.sh elf                      --- dump elf file with -D(default)"
	echo "	./make.sh elf-S                    --- dump elf file with -S"
	echo "	./make.sh elf-d                    --- dump elf file with -d"
	echo "	./make.sh elf-*                    --- dump elf file with -*"
	echo "	./make.sh <no reloc_addr>          --- unwind address(no relocated)"
	echo "	./make.sh <reloc_addr-reloc_off>   --- unwind address(relocated)"
	echo "	./make.sh map                      --- cat u-boot.map"
	echo "	./make.sh sym                      --- cat u-boot.sym"
}

function prepare()
{
	if [ -d ${RKBIN_TOOLS} ]; then
		absolute_path=$(cd `dirname ${RKBIN_TOOLS}`; pwd)
		RKBIN=${absolute_path}
	else
		echo "ERROR: No ../rkbin repository"
		exit 1
	fi

	if grep -Eq ''^CONFIG_ARM64=y'|'^CONFIG_ARM64_BOOT_AARCH32=y'' .config ; then
		ARM64_TRUSTZONE="y"
	fi

	if grep  -q '^CONFIG_ROCKCHIP_FIT_IMAGE_PACK=y' .config ; then
		PLAT_TYPE="FIT"
	fi
}

function process_args()
{
	while [ $# -gt 0 ]; do
		case $1 in
			*help|--h|-h)
				help
				exit 0
				;;
			# '': build with exist .config
			# loader|trust|uboot: pack image
			# debug*|map|sym|elf*|nm: debug command
			# env: build env tool
			# itb: pack itb image
			# fit: pack non-secure uboot.img && boot.img
			''|loader|trust|uboot|debug*|itb|env|fit|map|sym|elf*|nm)
				if [ "$2" == "spl" -o "$2" == "tpl" ]; then
					ARG_TSPL=$2
					shift 1
				fi
				shift 1
				;;
			# trust/loader ini files for packing trust.img/loader.img
			*.ini|*.INI)
				if [ ! -f $1 ]; then
					echo "ERROR: No $1"
				fi
				if grep -q 'CODE471_OPTION' $1 ; then
					ARG_INI_LOADER=$1
				elif grep -Eq ''BL31_OPTION'|'TOS'' $1 ; then
					ARG_INI_TRUST=$1
				fi
				shift 1
				;;
			--sz-trust) # set trust size
				ARG_TRUST_SIZE="--size $2 $3"
				shift 3
				;;
			--sz-uboot) # set uboot size
				ARG_UBOOT_SIZE="--size $2 $3"
				shift 3
				;;
			--raw-compile)  # FIT: build but not pack image
				ARG_RAW_COMPILE="y"
				shift 1
				;;
			--no-uboot) # FIT: pack uboot.img without u-boot
				ARG_NO_UBOOT="y"
				shift 1
				;;
			--idblock)  # pack idblock.bin
				shift 1
				;;
			--tpl|tpl)  # use tpl file
				ARG_TPL_BIN="tpl/u-boot-tpl.bin"
				shift 1
				;;
			--spl|spl*) # use spl file
				ARG_SPL_BIN="spl/u-boot-spl.bin"
				shift 1
				;;
			*)
				#1. FIT scripts args
				NUM=$(${SCRIPT_FIT} --args $1)
				if  [ ${NUM} -ne 0 ]; then
					[ ${NUM} -eq 1 ] && ARG_LIST_FIT="${ARG_LIST_FIT} $1"
					[ ${NUM} -eq 2 ] && ARG_LIST_FIT="${ARG_LIST_FIT} $1 $2"
					shift ${NUM}
					continue
				#2. unwind function address
				elif [ -z $(echo $1 | sed 's/[0-9,a-f,A-F,x,X,-]//g') ]; then
					ARG_FUNCADDR=$1
				#3. make defconfig
				else
					ARG_BOARD=$1
					if [ ! -f configs/${ARG_BOARD}_defconfig -a ! -f configs/${ARG_BOARD}.config ]; then
						echo -e "\n${SUPPORT_LIST}\n"
						echo "ERROR: No configs/${ARG_BOARD}_defconfig"
						exit 1
					elif [ -f configs/${ARG_BOARD}.config ]; then
						BASE1_DEFCONFIG=`sed -n "/CONFIG_BASE_DEFCONFIG=/s/CONFIG_BASE_DEFCONFIG=//p" configs/${ARG_BOARD}.config |tr -d '\r' | tr -d '"'`
						BASE0_DEFCONFIG=`sed -n "/CONFIG_BASE_DEFCONFIG=/s/CONFIG_BASE_DEFCONFIG=//p" configs/${BASE1_DEFCONFIG} |tr -d '\r' | tr -d '"'`
						MAKE_CMD="make ${BASE0_DEFCONFIG} ${BASE1_DEFCONFIG} ${ARG_BOARD}.config -j${JOB}"
						echo "## ${MAKE_CMD}"
						make ${BASE0_DEFCONFIG} ${BASE1_DEFCONFIG} ${ARG_BOARD}.config ${OPTION}
					else
						MAKE_CMD="make ${ARG_BOARD}_defconfig -j${JOB}"
						echo "## ${MAKE_CMD}"
						make ${ARG_BOARD}_defconfig ${OPTION}
					fi
				fi
				shift 1
				;;
		esac
	done

	if [ ! -f .config ]; then
		echo
		echo "ERROR: No .config"
		help
		exit 1
	fi
}

function select_toolchain()
{
	if grep -q '^CONFIG_ARM64=y' .config ; then
		if [ -d ${TOOLCHAIN_ARM64} ]; then
			absolute_path=$(cd `dirname ${TOOLCHAIN_ARM64}`; pwd)
			TOOLCHAIN_NM=${absolute_path}/bin/${NM_ARM64}
			TOOLCHAIN_GCC=${absolute_path}/bin/${GCC_ARM64}
			TOOLCHAIN_OBJDUMP=${absolute_path}/bin/${OBJ_ARM64}
			TOOLCHAIN_ADDR2LINE=${absolute_path}/bin/${ADDR2LINE_ARM64}
		else
			echo "ERROR: No toolchain: ${TOOLCHAIN_ARM64}"
			exit 1
		fi
	else
		if [ -d ${TOOLCHAIN_ARM32} ]; then
			absolute_path=$(cd `dirname ${TOOLCHAIN_ARM32}`; pwd)
			TOOLCHAIN_NM=${absolute_path}/bin/${NM_ARM32}
			TOOLCHAIN_GCC=${absolute_path}/bin/${GCC_ARM32}
			TOOLCHAIN_OBJDUMP=${absolute_path}/bin/${OBJ_ARM32}
			TOOLCHAIN_ADDR2LINE=${absolute_path}/bin/${ADDR2LINE_ARM32}
		else
			echo "ERROR: No toolchain: ${TOOLCHAIN_ARM32}"
			exit 1
		fi
	fi
}

#
# We select chip info to do:
#	1. RKCHIP:        fixup platform configure
#	2. RKCHIP_LOADER: search ini file to pack loader
#	3. RKCHIP_TRUST:  search ini file to pack trust
#	4. RKCHIP_LABEL:  show build message
#
function select_chip_info()
{
	# Read RKCHIP firstly from .config
	# The regular expression that matching:
	#  - PX30, PX3SE
	#  - RK????, RK????X
	#  - RV????
	CHIP_PATTERN='^CONFIG_ROCKCHIP_[R,P][X,V,K][0-9ESX]{1,5}'
	RKCHIP=`egrep -o ${CHIP_PATTERN} .config`

	# default
	RKCHIP=${RKCHIP##*_}
	# fixup ?
	for item in "${CHIP_TYPE_FIXUP_TABLE[@]}"
	do
		CONFIG_ROCKCHIP_XXX=`echo ${item} | awk '{ print $1 }'`
		if grep  -q "^${CONFIG_ROCKCHIP_XXX}=y" .config ; then
			RKCHIP=`echo ${item} | awk '{ print $2 }'`
			RKCHIP_LOADER=`echo ${item} | awk '{ print $3 }'`
			RKCHIP_TRUST=`echo  ${item} | awk '{ print $4 }'`
			RKCHIP_LABEL=`echo  ${item} | awk '{ print $5 }'`
		fi
	done

	if [ "${RKCHIP_LOADER}" == "-" ]; then
		RKCHIP_LOADER=${RKCHIP}
	fi
	if [ "${RKCHIP_TRUST}" == "-" ]; then
		RKCHIP_TRUST=${RKCHIP}
	fi
	if [ "${RKCHIP_LABEL}" == "-" ]; then
		RKCHIP_LABEL=${RKCHIP}
	fi
}

# Priority: default < CHIP_CFG_FIXUP_TABLE() < make.sh args
function fixup_platform_configure()
{
	U_KB="-" U_NUM="-" T_KB="-" T_NUM="-"  SHA="-" RSA="-"

	for item in "${CHIP_CFG_FIXUP_TABLE[@]}"
	do
		config_xxx=`echo ${item} | awk '{ print $1 }'`
		if grep  -q "^${config_xxx}=y" .config ; then
			# <*> Fixup rsa/sha pack mode for platforms
			RSA=`echo ${item} | awk '{ print $2 }'`
			SHA=`echo ${item} | awk '{ print $3 }'`

			# <*> Fixup images size pack for platforms, and ini file
			if grep -q '^CONFIG_ARM64=y' .config ; then
				U_KB=`echo  ${item} | awk '{ print $4 }' | awk -F "," '{ print $1 }'`
				T_KB=`echo  ${item} | awk '{ print $4 }' | awk -F "," '{ print $2 }'`
				U_NUM=`echo ${item} | awk '{ print $5 }' | awk -F "," '{ print $1 }'`
				T_NUM=`echo ${item} | awk '{ print $5 }' | awk -F "," '{ print $2 }'`
			else
				U_KB=`echo  ${item} | awk '{ print $6 }' | awk -F "," '{ print $1 }'`
				T_KB=`echo  ${item} | awk '{ print $6 }' | awk -F "," '{ print $2 }'`
				U_NUM=`echo ${item} | awk '{ print $7 }' | awk -F "," '{ print $1 }'`
				T_NUM=`echo ${item} | awk '{ print $7 }' | awk -F "," '{ print $2 }'`
				# AArch32
				if grep -q '^CONFIG_ARM64_BOOT_AARCH32=y' .config ; then
					PADDING=`echo ${item} | awk '{ print $8 }'`
					if [ "${PADDING}" != "-" ]; then
						RKCHIP_LOADER=${RKCHIP_LOADER}${PADDING}
					fi
					PADDING=`echo  ${item} | awk '{ print $9 }'`
					if [ "${PADDING}" != "-" ]; then
						RKCHIP_TRUST=${RKCHIP_TRUST}${PADDING}
					fi
					RKCHIP_LABEL=${RKCHIP_LABEL}"AARCH32"
				fi
			fi
		fi
	done

	if [ "${SHA}" != "-" ]; then
		PLAT_SHA="--sha ${SHA}"
	fi
	if [ "${RSA}" != "-" ]; then
		PLAT_RSA="--rsa ${RSA}"
	fi
	if [ "${U_KB}" != "-" ]; then
		PLAT_UBOOT_SIZE="--size ${U_KB} ${U_NUM}"
	fi
	if [ "${T_KB}" != "-" ]; then
		PLAT_TRUST_SIZE="--size ${T_KB} ${T_NUM}"
	fi

	# args
	if [ ! -z "${ARG_UBOOT_SIZE}" ]; then
		PLAT_UBOOT_SIZE=${ARG_UBOOT_SIZE}
	fi

	if [ ! -z "${ARG_TRUST_SIZE}" ]; then
		PLAT_TRUST_SIZE=${ARG_TRUST_SIZE}
	fi
}

# Priority: default < CHIP_TYPE_FIXUP_TABLE() < defconfig < make.sh args
function select_ini_file()
{
	# default
	INI_LOADER=${RKBIN}/RKBOOT/${RKCHIP_LOADER}MINIALL.ini
	if [ "${ARM64_TRUSTZONE}" == "y" ]; then
		INI_TRUST=${RKBIN}/RKTRUST/${RKCHIP_TRUST}TRUST.ini
	else
		INI_TRUST=${RKBIN}/RKTRUST/${RKCHIP_TRUST}TOS.ini
	fi

	# defconfig
	NAME=`sed -n "/CONFIG_LOADER_INI=/s/CONFIG_LOADER_INI=//p" .config |tr -d '\r' | tr -d '"'`
	if [ ! -z "${NAME}" ]; then
		INI_LOADER=${RKBIN}/RKBOOT/${NAME}
	fi
	NAME=`sed -n "/CONFIG_TRUST_INI=/s/CONFIG_TRUST_INI=//p" .config |tr -d '\r' | tr -d '"'`
	if [ ! -z "${NAME}" ]; then
		INI_TRUST=${RKBIN}/RKTRUST/${NAME}
	fi

	# args
	if [ ! -z "${ARG_INI_TRUST}" ]; then
		INI_TRUST=${ARG_INI_TRUST}
	fi
	if [ ! -z "${ARG_INI_LOADER}" ]; then
		INI_LOADER=${ARG_INI_LOADER}
	fi
}

function sub_commands()
{
	# skip "--" parameter, such as "--rollback-index-..."
	if [[ ${CMD_ARGS} != --* ]]; then
		CMD=${CMD_ARGS%-*}
		ARG=${CMD_ARGS#*-}
	else
		CMD=${CMD_ARGS}
	fi

	if [ "${ARG_TSPL}" == "tpl" -o "${ARG_TSPL}" == "spl" ]; then
		ELF=`find -name u-boot-${ARG_TSPL}`
		MAP=`find -name u-boot-${ARG_TSPL}.map`
		SYM=`find -name u-boot-${ARG_TSPL}.sym`
	else
		ELF=u-boot
		MAP=u-boot.map
		SYM=u-boot.sym
	fi

	case ${CMD} in
		elf|nm)
			if [ "${CMD}" == "nm" ]; then
				echo -e "\n${ELF}:     file format elf\n"
				${TOOLCHAIN_NM} -r --size ${ELF} | less
			else
				if [ "${CMD}" == "elf" -a "${ARG}" == "elf" ]; then
					ARG=D # default
				fi
				${TOOLCHAIN_OBJDUMP} -${ARG} ${ELF} | less
			fi
			exit 0
			;;
		map|sym)
			if [ ${CMD} == "map" ]; then
				cat ${MAP} | less
			else
				cat ${SYM} | less
			fi
			exit 0
			;;
		debug)
			./scripts/rkpatch.sh ${ARG}
			exit 0
			;;
		fit)
			# Non-secure
			${SCRIPT_FIT} --boot_img_dir images/ ${ARG_LIST_FIT}
			exit 0
			;;
		uboot)
			pack_uboot_image
			exit 0
			;;
		trust)
			pack_trust_image
			exit 0
			;;
		loader)
			pack_loader_image
			exit 0
			;;
		itb)
			pack_uboot_itb_image
			exit 0
			;;
		env)
			make CROSS_COMPILE=${TOOLCHAIN_GCC} envtools
			exit 0
			;;
		--idblock)
			pack_idblock
			exit 0
			;;
		--tpl|--spl|tpl|spl)
			pack_spl_loader_image
			exit 0
			;;
		*)
			unwind_addr_or_continue
			;;
	esac
}

function unwind_addr_or_continue()
{
	FUNCADDR=${ARG_FUNCADDR}
	RELOCOFF=${FUNCADDR#*-}
	FUNCADDR=${FUNCADDR%-*}

	if [ -z $(echo ${FUNCADDR} | sed 's/[0-9,a-f,A-F,x,X,-]//g') ] && [ ${FUNCADDR} ]; then
		# With prefix: '0x' or '0X'
		if [ `echo ${FUNCADDR} | sed -n "/0[x,X]/p" | wc -l` -ne 0 ]; then
			FUNCADDR=`echo ${FUNCADDR} | awk '{ print strtonum($0) }'`
			FUNCADDR=`echo "obase=16;${FUNCADDR}"|bc | tr '[A-Z]' '[a-z]'`
		fi
		if [ `echo ${RELOCOFF} | sed -n "/0[x,X]/p" | wc -l` -ne 0 ] && [ ${RELOCOFF} ]; then
			RELOCOFF=`echo ${RELOCOFF} | awk '{ print strtonum($0) }'`
			RELOCOFF=`echo "obase=16;${RELOCOFF}"|bc | tr '[A-Z]' '[a-z]'`
		fi

		# If reloc address is assigned, do sub
		if [ "${FUNCADDR}" != "${RELOCOFF}" ]; then
			# Hex -> Dec -> SUB -> Hex
			FUNCADDR=`echo $((16#${FUNCADDR}))`
			RELOCOFF=`echo $((16#${RELOCOFF}))`
			FUNCADDR=$((FUNCADDR-RELOCOFF))
			FUNCADDR=$(echo "obase=16;${FUNCADDR}"|bc | tr '[A-Z]' '[a-z]')
		fi

		echo
		sed -n "/${FUNCADDR}/p" ${SYM}
		${TOOLCHAIN_ADDR2LINE} -e ${ELF} ${FUNCADDR}
		exit 0
	fi
}

function pack_idblock()
{
	INI=${INI_LOADER}
	if [ ! -f ${INI} ]; then
		echo "ERROR: No ${INI}"
		exit 1
	fi

	# chip
	COMMON_H=`grep "_common.h:" include/autoconf.mk.dep | awk -F "/" '{ printf $3 }'`
	PLAT=${COMMON_H%_*}

	# file
	SPL_BIN=${RKBIN}/`sed -n "/FlashBoot=/s/FlashBoot=//p" ${INI} | tr -d '\r'`
	TPL_BIN=${RKBIN}/`sed -n "/FlashData=/s/FlashData=//p" ${INI} | tr -d '\r'`
	if [ ! -z "${ARG_SPL_BIN}" ]; then
		SPL_BIN=${ARG_SPL_BIN}
	fi
	if [ ! -z "${ARG_TPL_BIN}" ]; then
		TPL_BIN=${ARG_TPL_BIN}
	fi

	# pack
	rm idblock.bin -f
	./tools/mkimage -n ${PLAT} -T rksd -d ${TPL_BIN}:${SPL_BIN} idblock.bin
	echo "Input:"
	echo "    ${INI}"
	echo "    ${TPL_BIN}"
	echo "    ${SPL_BIN}"
	echo
	echo "Pack ${PLAT} idblock.bin okay!"
	echo
}

function pack_uboot_itb_image()
{
	INI=${INI_TRUST}
	if [ ! -f ${INI} ]; then
		echo "ERROR: No ${INI}"
		exit 1
	fi

	if [ "${ARM64_TRUSTZONE}" == "y" ]; then
		BL31_ELF=`sed -n '/_bl31_/s/PATH=//p' ${INI} | tr -d '\r'`
		BL32_BIN=`sed -n '/_bl32_/s/PATH=//p' ${INI} | tr -d '\r'`
		rm bl31.elf tee.bin -rf
		cp ${RKBIN}/${BL31_ELF} bl31.elf
		if grep BL32_OPTION -A 1 ${INI} | grep SEC=1 ; then
			cp ${RKBIN}/${BL32_BIN} tee.bin
			TEE_OFFSET=`grep BL32_OPTION -A 3 ${INI} | grep ADDR= | awk -F "=" '{ printf $2 }' | tr -d '\r'`
			TEE_ARG="-t ${TEE_OFFSET}"
		fi
	else
		# TOS
		TOS=`sed -n "/TOS=/s/TOS=//p" ${INI} | tr -d '\r'`
		TOSTA=`sed -n "/TOSTA=/s/TOSTA=//p" ${INI} | tr -d '\r'`
		if [ ! -z "${TOSTA}" ]; then
			cp ${RKBIN}/${TOSTA} tee.bin
		elif [ ! -z "${TOS}" ]; then
			cp ${RKBIN}/${TOS}   tee.bin
		else
			echo "ERROR: No tee bin"
			exit 1
		fi

		TEE_OFFSET=`sed -n "/ADDR=/s/ADDR=//p" ${INI} | tr -d '\r'`
		if [ "${TEE_OFFSET}" == "" ]; then
			TEE_OFFSET=0x8400000
		fi
		TEE_ARG="-t ${TEE_OFFSET}"

		# MCU
		MCU_ENABLED=`awk -F"," '/MCU=/ { printf $3 }' ${INI} | tr -d ' '`
		if [ "${MCU_ENABLED}" == "enabled" -o "${MCU_ENABLED}" == "okay" ]; then
			MCU=`awk -F"," '/MCU=/  { printf $1 }' ${INI} | tr -d ' ' | cut -c 5-`
			cp ${RKBIN}/${MCU} mcu.bin
			MCU_OFFSET=`awk -F"," '/MCU=/ { printf $2 }' ${INI} | tr -d ' '`
			MCU_ARG="-m ${MCU_OFFSET}"
		fi
	fi

	COMPRESSION=`awk -F"," '/COMPRESSION=/  { printf $1 }' ${INI} | tr -d ' ' | cut -c 13-`
	if [ ! -z "${COMPRESSION}" -a "${COMPRESSION}" != "none" ]; then
		COMPRESSION_ARG="-c ${COMPRESSION}"
	fi

	SPL_FIT_SOURCE=`sed -n "/CONFIG_SPL_FIT_SOURCE=/s/CONFIG_SPL_FIT_SOURCE=//p" .config | tr -d '""'`
	if [ ! -z ${SPL_FIT_SOURCE} ]; then
		cp ${SPL_FIT_SOURCE} u-boot.its
	else
		SPL_FIT_GENERATOR=`sed -n "/CONFIG_SPL_FIT_GENERATOR=/s/CONFIG_SPL_FIT_GENERATOR=//p" .config | tr -d '""'`
		if [[ ${SPL_FIT_GENERATOR} == *.py ]]; then
			${SPL_FIT_GENERATOR} u-boot.dtb > u-boot.its
		else
			${SPL_FIT_GENERATOR} ${TEE_ARG} ${COMPRESSION_ARG} ${MCU_ARG} > u-boot.its
		fi
	fi

	./tools/mkimage -f u-boot.its -E u-boot.itb
	echo "pack u-boot.itb okay! Input: ${INI}"
	echo
}

function pack_spl_loader_image()
{
	rm *_loader_*.bin -f
	cd ${RKBIN}
	if [ ! -z "${ARG_SPL_BIN}" -a ! -z "${ARG_TPL_BIN}" ]; then
		${SCRIPT_SPL} --ini ${INI_LOADER} --tpl ${SRCTREE}/${ARG_TPL_BIN} --spl ${SRCTREE}/${ARG_SPL_BIN}
	elif [ ! -z "${ARG_TPL_BIN}" ]; then
		${SCRIPT_SPL} --ini ${INI_LOADER} --tpl ${SRCTREE}/${ARG_TPL_BIN}
	else
		${SCRIPT_SPL} --ini ${INI_LOADER} --spl ${SRCTREE}/${ARG_SPL_BIN}
	fi
	cd -
	if [ -f ${RKBIN}/*_loader_*.bin ]; then
		mv ${RKBIN}/*_loader_*.bin ./
	fi
}

function pack_uboot_image()
{
	rm u-boot.img u-boot-dtb.img -f
	LOAD_ADDR=`sed -n "/CONFIG_SYS_TEXT_BASE=/s/CONFIG_SYS_TEXT_BASE=//p" include/autoconf.mk|tr -d '\r'`
	if [ -z "${LOAD_ADDR}" ]; then
		# upstream U-Boot
		LOAD_ADDR=`grep CONFIG_SYS_TEXT_BASE include/generated/autoconf.h | awk '{ print $3 }' | tr -d '\r'`
	fi

	if [ -z "${LOAD_ADDR}" ]; then
		echo "ERROR: No CONFIG_SYS_TEXT_BASE for u-boot";
		exit 1
	fi

	${SCRIPT_UBOOT} --load ${LOAD_ADDR} ${PLAT_UBOOT_SIZE}
}

function pack_loader_image()
{
	rm *_loader_*.bin -f
	cd ${RKBIN}
	${SCRIPT_LOADER} --ini ${INI_LOADER}
	cd -
	if [ -f ${RKBIN}/*_loader_*.bin ]; then
		mv ${RKBIN}/*_loader_*.bin ./
	fi
}

function pack_trust_image()
{
	DRAM_BASE=`sed -n "/CONFIG_SYS_SDRAM_BASE=/s/CONFIG_SYS_SDRAM_BASE=//p" include/autoconf.mk|tr -d '\r'`

	rm trust*.img -f
	cd ${RKBIN}
	if [ "${ARM64_TRUSTZONE}" == "y" ]; then
		${SCRIPT_ATF} --ini ${INI_TRUST} ${PLAT_SHA} ${PLAT_RSA} ${PLAT_TRUST_SIZE}
	else
		${SCRIPT_TOS} --ini ${INI_TRUST} --base ${DRAM_BASE} ${PLAT_TRUST_SIZE}
	fi
	cd -
	if [ -f ${RKBIN}/trust*.img ]; then
		mv ${RKBIN}/trust*.img ./
	fi
}

function pack_fit_image()
{
	# If we don't plan to have uboot in uboot.img in case of: SPL => Trust => Kernel, creating empty files.
	if [ "${ARG_NO_UBOOT}" == "y" ]; then
		rm u-boot-nodtb.bin u-boot.dtb -f
		touch u-boot-nodtb.bin u-boot.dtb
	fi

	rm uboot.img trust*.img -rf
	${SCRIPT_FIT} ${ARG_LIST_FIT}

	if [ "${ARM64_TRUSTZONE}" == "y" ]; then
		if ! fdtget -l uboot.img /images/atf-1 >/dev/null 2>&1 ; then
			echo -e "\nERROR: Invalid uboot.img, please install: \"pip install pyelftools\""
			echo
			exit 1
		fi
	fi

	echo "pack uboot.img okay! Input: ${INI_TRUST}"
}

function handle_args_late()
{
	ARG_LIST_FIT="${ARG_LIST_FIT} --ini-trust ${INI_TRUST} --ini-loader ${INI_LOADER}"
}

function clean_files()
{
	rm spl/u-boot-spl.dtb tpl/u-boot-tpl.dtb u-boot.dtb -f
	rm spl/u-boot-spl tpl/u-boot-tpl u-boot -f
}

function pack_images()
{
	if [ "${ARG_RAW_COMPILE}" != "y" ]; then
		if [ "${PLAT_TYPE}" == "FIT" ]; then
			pack_fit_image ${ARG_LIST_FIT}
		else
			pack_uboot_image
			pack_trust_image
			pack_loader_image
		fi
	fi
}

function finish()
{
	echo
	if [ "${ARG_BOARD}" == "" ]; then
		echo "Platform ${RKCHIP_LABEL} is build OK, with exist .config"
	else
		echo "Platform ${RKCHIP_LABEL} is build OK, with new .config(${MAKE_CMD})"
	fi
}

process_args $*
prepare
select_toolchain
select_chip_info
fixup_platform_configure
select_ini_file
handle_args_late
sub_commands
clean_files
make PYTHON=python2 CROSS_COMPILE=${TOOLCHAIN_GCC} all --jobs=${JOB}
pack_images
finish
