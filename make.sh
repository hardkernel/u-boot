#!/bin/bash
#
# Copyright (c) 2019 Fuzhou Rockchip Electronics Co., Ltd
#
# SPDX-License-Identifier: GPL-2.0
#

set -e
BOARD=$1
SUBCMD=$1
FUNCADDR=$1
FILE=$2
JOB=`sed -n "N;/processor/p" /proc/cpuinfo|wc -l`
SUPPORT_LIST=`ls configs/*[r,p][x,v,k][0-9][0-9]*_defconfig`

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
)

########################################### User can modify #############################################
# User's rkbin tool relative path
RKBIN_TOOLS=../rkbin/tools

# User's GCC toolchain and relative path
ADDR2LINE_ARM32=arm-linux-gnueabihf-addr2line
ADDR2LINE_ARM64=aarch64-linux-gnu-addr2line
OBJ_ARM32=arm-linux-gnueabihf-objdump
OBJ_ARM64=aarch64-linux-gnu-objdump
GCC_ARM32=arm-linux-gnueabihf-
GCC_ARM64=aarch64-linux-gnu-
TOOLCHAIN_ARM32=../prebuilts/gcc/linux-x86/arm/gcc-linaro-6.3.1-2017.05-x86_64_arm-linux-gnueabihf/bin
TOOLCHAIN_ARM64=../prebuilts/gcc/linux-x86/aarch64/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu/bin

########################################### User not touch #############################################
BIN_PATH_FIXUP="--replace tools/rk_tools/ ./"
RKTOOLS=./tools

# Declare global INI file searching index name for every chip, update in select_chip_info()
RKCHIP="-"
RKCHIP_LABEL="-"
RKCHIP_LOADER="-"
RKCHIP_TRUST="-"

# Declare rkbin repository path, updated in prepare()
RKBIN=

# Declare global toolchain path for CROSS_COMPILE, updated in select_toolchain()
TOOLCHAIN_GCC=
TOOLCHAIN_OBJDUMP=
TOOLCHAIN_ADDR2LINE=

# Declare global default output dir and cmd, update in prepare()
OPTION=

# Declare global plaform configure, updated in fixup_platform_configure()
PLATFORM_RSA=
PLATFORM_SHA=
PLATFORM_UBOOT_IMG_SIZE=
PLATFORM_TRUST_IMG_SIZE=

PACK_FORMAT="rk"

# Out env param
PACK_IGNORE_BL32=$TRUST_PACK_IGNORE_BL32	# Value only: "--ignore-bl32"
#########################################################################################################
help()
{
	echo
	echo "Usage:"
	echo "	./make.sh [board|subcmd|EXT_DTB=<file>]"
	echo
	echo "	 - board:   board name of defconfig"
	echo "	 - subcmd:  |elf*|loader*|spl*|itb|trust*|uboot|map|sym|<addr>|EXT_DTB=*"
	echo "	 - ini:     assigned ini file to pack trust/loader"
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
	echo "	./make.sh spl                      --- pack loader with u-boot-spl.bin and u-boot-tpl.bin"
	echo "	./make.sh spl-s                    --- pack loader only replace miniloader with u-boot-spl.bin"
	echo "	./make.sh itb                      --- pack u-boot.itb(TODO: bl32 is not included for ARMv8)"
	echo
	echo "3. Debug:"
	echo "	./make.sh elf                      --- dump elf file with -D(default)"
	echo "	./make.sh elf-S                    --- dump elf file with -S"
	echo "	./make.sh elf-d                    --- dump elf file with -d"
	echo "	./make.sh elf-*                    --- dump elf file with -*"
	echo "	./make.sh <no reloc_addr>          --- dump function symbol and code position of address(no relocated)"
	echo "	./make.sh <reloc_addr-reloc_off>   --- dump function symbol and code position of address(relocated)"
	echo "	./make.sh map                      --- cat u-boot.map"
	echo "	./make.sh sym                      --- cat u-boot.sym"
}

prepare()
{
	local absolute_path cmd dir count

	case $BOARD in
		# Parse from exit .config
		''|elf*|loader*|spl*|itb|debug*|trust|uboot|map|sym|env|EXT_DTB=*|fit*)
		if [ ! -f .config ]; then
			echo
			echo "Build failed, Can't find .config"
			help
			exit 1
		fi
		;;
	esac

	# Parse help and make defconfig
	case $BOARD in
		#Help
		--help|-help|help|--h|-h)
		help
		exit 0
		;;

		#Subcmd
		''|elf*|loader*|spl*|itb|debug*|trust*|uboot|map|sym|env|EXT_DTB=*|fit*)
		;;

		*)
		#Func address is valid ?
		if [ -z $(echo ${FUNCADDR} | sed 's/[0-9,a-f,A-F,x,X,-]//g') ]; then
			return
		elif [ ! -f configs/${BOARD}_defconfig ]; then
			echo
			echo "Can't find: configs/${BOARD}_defconfig"
			echo
			echo "******** Rockchip Support List *************"
			echo "${SUPPORT_LIST}"
			echo "********************************************"
			echo
			exit 1
		else
			echo "make for ${BOARD}_defconfig by -j${JOB}"
			make ${BOARD}_defconfig ${OPTION}
		fi
		;;
	esac

	# Initialize RKBIN
	if [ -d ${RKBIN_TOOLS} ]; then
		absolute_path=$(cd `dirname ${RKBIN_TOOLS}`; pwd)
		RKBIN=${absolute_path}
	else
		echo
		echo "Can't find '../rkbin/' repository, please download it before pack image!"
		echo "How to obtain? 3 ways:"
		echo "	1. Login your Rockchip gerrit account: \"Projects\" -> \"List\" -> search \"rk/rkbin\" repository"
		echo "	2. Github repository: https://github.com/rockchip-linux/rkbin"
		echo "	3. Download full release SDK repository"
		exit 1
	fi

	if grep  -q '^CONFIG_ROCKCHIP_FIT_IMAGE_PACK=y' .config ; then
		PACK_FORMAT="fit"
	fi
}

select_toolchain()
{
	local absolute_path

	if grep  -q '^CONFIG_ARM64=y' .config ; then
		if [ -d ${TOOLCHAIN_ARM64} ]; then
			absolute_path=$(cd `dirname ${TOOLCHAIN_ARM64}`; pwd)
			TOOLCHAIN_GCC=${absolute_path}/bin/${GCC_ARM64}
			TOOLCHAIN_OBJDUMP=${absolute_path}/bin/${OBJ_ARM64}
			TOOLCHAIN_ADDR2LINE=${absolute_path}/bin/${ADDR2LINE_ARM64}
		else
			echo "Can't find toolchain: ${TOOLCHAIN_ARM64}"
			exit 1
		fi
	else
		if [ -d ${TOOLCHAIN_ARM32} ]; then
			absolute_path=$(cd `dirname ${TOOLCHAIN_ARM32}`; pwd)
			TOOLCHAIN_GCC=${absolute_path}/bin/${GCC_ARM32}
			TOOLCHAIN_OBJDUMP=${absolute_path}/bin/${OBJ_ARM32}
			TOOLCHAIN_ADDR2LINE=${absolute_path}/bin/${ADDR2LINE_ARM32}
		else
			echo "Can't find toolchain: ${TOOLCHAIN_ARM32}"
			exit 1
		fi
	fi

	# echo "toolchain: ${TOOLCHAIN_GCC}"
}

sub_commands()
{
	local cmd=${SUBCMD%-*} opt=${SUBCMD#*-}
	local elf=u-boot map=u-boot.map sym=u-boot.sym

	if [ "$FILE" == "tpl" -o "$FILE" == "spl" ]; then
		elf=`find -name u-boot-${FILE}`
		map=`find -name u-boot-${FILE}.map`
		sym=`find -name u-boot-${FILE}.sym`
	fi

	case $cmd in
		elf)
		if [ -o ! -f ${elf} ]; then
			echo "Can't find elf file: ${elf}"
			exit 1
		else
			# default 'cmd' without option, use '-D'
			if [ "${cmd}" = 'elf' -a "${opt}" = 'elf' ]; then
				opt=D
			fi
			${TOOLCHAIN_OBJDUMP} -${opt} ${elf} | less
			exit 0
		fi
		;;

		debug)
		./scripts/rkpatch.sh ${opt}
		exit 0
		;;

		fit)
		./scripts/fit-vboot.sh $*
		exit 0
		;;

		map)
		cat ${map} | less
		exit 0
		;;

		sym)
		cat ${sym} | less
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

		spl)
		pack_spl_loader_image ${opt}
		exit 0
		;;

		itb)
		pack_uboot_itb_image
		exit 0
		;;

		uboot)
		pack_uboot_image ${opt}
		exit 0
		;;

		env)
		make CROSS_COMPILE=${TOOLCHAIN_GCC} envtools	
		exit 0
		;;

		EXT_DTB=*)
		OPTION=${SUBCMD}
		;;

		*)
		# Search function and code position of address
		RELOC_OFF=${FUNCADDR#*-}
		FUNCADDR=${FUNCADDR%-*}
		if [ -z $(echo ${FUNCADDR} | sed 's/[0-9,a-f,A-F,x,X,-]//g') ] && [ ${FUNCADDR} ]; then
			# With prefix: '0x' or '0X'
			if [ `echo ${FUNCADDR} | sed -n "/0[x,X]/p" | wc -l` -ne 0 ]; then
				FUNCADDR=`echo $FUNCADDR | awk '{ print strtonum($0) }'`
				FUNCADDR=`echo "obase=16;${FUNCADDR}"|bc |tr '[A-Z]' '[a-z]'`
			fi
			if [ `echo ${RELOC_OFF} | sed -n "/0[x,X]/p" | wc -l` -ne 0 ] && [ ${RELOC_OFF} ]; then
				RELOC_OFF=`echo $RELOC_OFF | awk '{ print strtonum($0) }'`
				RELOC_OFF=`echo "obase=16;${RELOC_OFF}"|bc |tr '[A-Z]' '[a-z]'`
			fi

			# If reloc address is assigned, do sub
			if [ "${FUNCADDR}" != "${RELOC_OFF}" ]; then
				# Hex -> Dec -> SUB -> Hex
				FUNCADDR=`echo $((16#${FUNCADDR}))`
				RELOC_OFF=`echo $((16#${RELOC_OFF}))`
				FUNCADDR=$((FUNCADDR-RELOC_OFF))
				FUNCADDR=$(echo "obase=16;${FUNCADDR}"|bc |tr '[A-Z]' '[a-z]')
			fi

			echo
			sed -n "/${FUNCADDR}/p" ${sym}
			${TOOLCHAIN_ADDR2LINE} -e ${elf} ${FUNCADDR}
			exit 0
		fi
		;;
	esac
}

# We select chip info to do:
#	1. RKCHIP: fixup platform configure
#	2. RKCHIP_LOADER: search ini file to pack loader
#	3. RKCHIP_TRUST: search ini file to pack trust
#	4. RKCHIP_LABEL: show build message
#
# We read chip info from .config and 'RKCHIP_INI_DESC'
select_chip_info()
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

	# need fixup ?
	for ITEM in "${CHIP_TYPE_FIXUP_TABLE[@]}"
	do
		CONFIG_XXX=`echo $ITEM | awk '{ print $1 }'`
		if grep  -q "^${CONFIG_XXX}=y" .config ; then
			RKCHIP=`echo $ITEM | awk '{ print $2 }'`
			RKCHIP_LOADER=`echo $ITEM | awk '{ print $3 }'`
			RKCHIP_TRUST=`echo  $ITEM | awk '{ print $4 }'`
			RKCHIP_LABEL=`echo  $ITEM | awk '{ print $5 }'`
		fi
	done

	if [ "$RKCHIP_LOADER" = "-" ]; then
		RKCHIP_LOADER=${RKCHIP}
	fi
	if [ "$RKCHIP_TRUST" = "-" ]; then
		RKCHIP_TRUST=${RKCHIP}
	fi
	if [ "$RKCHIP_LABEL" = "-" ]; then
		RKCHIP_LABEL=${RKCHIP}
	fi

	# echo "## $FUNCNAME: $RKCHIP, $RKCHIP_LOADER, $RKCHIP_TRUST, $RKCHIP_LABEL,"
}

function fixup_platform_configure()
{
	CFG_U_KB="-" CFG_U_NUM="-" CFG_T_KB="-" CFG_T_NUM="-"  CFG_SHA="-" CFG_RSA="-"

	for ITEM in "${CHIP_CFG_FIXUP_TABLE[@]}"
	do
		CONFIG_XXX=`echo $ITEM | awk '{ print $1 }'`
		if grep  -q "^${CONFIG_XXX}=y" .config ; then
			# <*> Fixup rsa/sha pack mode for platforms
			CFG_RSA=`echo $ITEM | awk '{ print $2 }'`
			CFG_SHA=`echo $ITEM | awk '{ print $3 }'`

			# <*> Fixup images size pack for platforms, and ini file
			if grep -q '^CONFIG_ARM64_BOOT_AARCH32=y' .config ; then
				CFG_U_KB=`echo  $ITEM | awk '{ print $6 }' | awk -F "," '{ print $1 }'`
				CFG_U_NUM=`echo $ITEM | awk '{ print $7 }' | awk -F "," '{ print $1 }'`
				CFG_T_KB=`echo  $ITEM | awk '{ print $6 }' | awk -F "," '{ print $2 }'`
				CFG_T_NUM=`echo $ITEM | awk '{ print $7 }' | awk -F "," '{ print $2 }'`

				PAD_LOADER=`echo $ITEM | awk '{ print $8 }'`
				PAD_TRUST=`echo  $ITEM | awk '{ print $9 }'`
				if [ "$PAD_LOADER" != "-" ]; then
					RKCHIP_LOADER=${RKCHIP_LOADER}${PAD_LOADER}
				fi
				if [ "$PAD_TRUST" != "-" ]; then
					RKCHIP_TRUST=${RKCHIP_TRUST}${PAD_TRUST}
				fi
				RKCHIP_LABEL=${RKCHIP_LABEL}"AARCH32"
			else
				CFG_U_KB=`echo  $ITEM | awk '{ print $4 }' | awk -F "," '{ print $1 }'`
				CFG_U_NUM=`echo $ITEM | awk '{ print $5 }' | awk -F "," '{ print $1 }'`
				CFG_T_KB=`echo  $ITEM | awk '{ print $4 }' | awk -F "," '{ print $2 }'`
				CFG_T_NUM=`echo $ITEM | awk '{ print $5 }' | awk -F "," '{ print $2 }'`
			fi
		fi
	done

	if [ "$CFG_SHA" != "-" ]; then
		PLATFORM_SHA="--sha $CFG_SHA"
	fi
	if [ "$CFG_RSA" != "-" ]; then
		PLATFORM_RSA="--rsa $CFG_RSA"
	fi
	if [ "$CFG_U_KB" != "-" ]; then
		PLATFORM_UBOOT_IMG_SIZE="--size $CFG_U_KB $CFG_U_NUM"
	fi
	if [ "$CFG_T_KB" != "-" ]; then
		PLATFORM_TRUST_IMG_SIZE="--size $CFG_T_KB $CFG_T_NUM"
	fi

	# echo "## $FUNCNAME: $PLATFORM_RSA, $PLATFORM_SHA, $PLATFORM_TRUST_IMG_SIZE, $PLATFORM_UBOOT_IMG_SIZE"
	# echo "## $FUNCNAME: $RKCHIP_LOADER, $RKCHIP_TRUST, $RKCHIP_LABEL"
}

pack_uboot_image()
{
	local UBOOT_LOAD_ADDR UBOOT_MAX_KB UBOOT_KB HEAD_KB=2

	# Check file size
	UBOOT_KB=`ls -l u-boot.bin | awk '{print $5}'`
	if [ "$PLATFORM_UBOOT_IMG_SIZE" = "" ]; then
		UBOOT_MAX_KB=1046528
	else
		UBOOT_MAX_KB=`echo $PLATFORM_UBOOT_IMG_SIZE | awk '{print strtonum($2)}'`
		UBOOT_MAX_KB=$(((UBOOT_MAX_KB-HEAD_KB)*1024))
	fi

	if [ $UBOOT_KB -gt $UBOOT_MAX_KB ]; then
		echo
		echo "ERROR: pack uboot failed! u-boot.bin actual: $UBOOT_KB bytes, max limit: $UBOOT_MAX_KB bytes"
		exit 1
	fi

	if [ "$PACK_FORMAT" = "rk" ]; then
		# Pack image
		UBOOT_LOAD_ADDR=`sed -n "/CONFIG_SYS_TEXT_BASE=/s/CONFIG_SYS_TEXT_BASE=//p" include/autoconf.mk|tr -d '\r'`
		if [ ! $UBOOT_LOAD_ADDR ]; then
			UBOOT_LOAD_ADDR=`sed -n "/CONFIG_SYS_TEXT_BASE=/s/CONFIG_SYS_TEXT_BASE=//p" .config|tr -d '\r'`
		fi

		${RKTOOLS}/loaderimage --pack --uboot u-boot.bin uboot.img ${UBOOT_LOAD_ADDR} ${PLATFORM_UBOOT_IMG_SIZE}
		# Delete u-boot.img and u-boot-dtb.img, which makes users not be confused with final uboot.img
		ls u-boot.img >/dev/null 2>&1 && rm u-boot.img -rf
		ls u-boot-dtb.img >/dev/null 2>&1 && rm u-boot-dtb.img -rf
		echo "pack uboot okay! Input: u-boot.bin"
	fi
}

pack_uboot_itb_image()
{
	local ini TEE_OFFSET

	# ARM64
	if grep -Eq ''^CONFIG_ARM64=y'|'^CONFIG_ARM64_BOOT_AARCH32=y'' .config ; then
		ini=${RKBIN}/RKTRUST/${RKCHIP_TRUST}${PLATFORM_AARCH32}TRUST.ini
		if [ ! -f ${ini} ]; then
			echo "pack trust failed! Can't find: ${ini}"
			return
		fi

		bl31=`sed -n '/_bl31_/s/PATH=//p' ${ini} |tr -d '\r'`

		cp ${RKBIN}/${bl31} bl31.elf
		make CROSS_COMPILE=${TOOLCHAIN_GCC} u-boot.itb
		echo "pack u-boot.itb okay! Input: ${ini}"
	else
		ini=${RKBIN}/RKTRUST/${RKCHIP_TRUST}TOS.ini
		if [ ! -f ${ini} ]; then
			echo "pack trust failed! Can't find: ${ini}"
			return
		fi

		TOS=`sed -n "/TOS=/s/TOS=//p" ${ini} |tr -d '\r'`
		TOS_TA=`sed -n "/TOSTA=/s/TOSTA=//p" ${ini} |tr -d '\r'`

		if [ $TOS_TA ]; then
			cp ${RKBIN}/${TOS_TA} tee.bin
		elif [ $TOS ]; then
			cp ${RKBIN}/${TOS} tee.bin
		else
			echo "Can't find any tee bin"
			exit 1
		fi

		TEE_OFFSET=`sed -n "/ADDR=/s/ADDR=//p" ${ini} |tr -d '\r'`
		if [ "$TEE_OFFSET" = "" ]; then
			TEE_OFFSET=0x8400000
		fi

		SPL_FIT_SOURCE=`sed -n "/CONFIG_SPL_FIT_SOURCE=/s/CONFIG_SPL_FIT_SOURCE=//p" .config | tr -d '""'`
		if [ ! -z $SPL_FIT_SOURCE ]; then
			cp $SPL_FIT_SOURCE u-boot.its
		else
			SPL_FIT_GENERATOR=`sed -n "/CONFIG_SPL_FIT_GENERATOR=/s/CONFIG_SPL_FIT_GENERATOR=//p" .config | tr -d '""'`
			$SPL_FIT_GENERATOR $TEE_OFFSET > u-boot.its
		fi

		./tools/mkimage -f u-boot.its -E u-boot.itb
		echo "pack u-boot.itb okay! Input: ${ini}"
	fi
}

pack_spl_loader_image()
{
	local header label="SPL" mode=$1
	local ini=${RKBIN}/RKBOOT/${RKCHIP_LOADER}MINIALL.ini
	local temp_ini=${RKBIN}/.temp/${RKCHIP_LOADER}MINIALL.ini

	if [ "$FILE" != "" ]; then
		ini=$FILE;
	fi

	if [ ! -f ${ini} ]; then
		echo "pack TPL+SPL loader failed! Can't find: ${ini}"
		return
	fi

	ls ${RKBIN}/.temp >/dev/null 2>&1 && rm ${RKBIN}/.temp -rf
	mkdir ${RKBIN}/.temp

	# Copy to .temp folder
	cp spl/u-boot-spl.bin ${RKBIN}/.temp/
	cp ${ini} ${RKBIN}/.temp/${RKCHIP_LOADER}MINIALL.ini -f

	cd ${RKBIN}
	if [ "$mode" = 'spl' ]; then	# pack tpl+spl
		cp tpl/u-boot-tpl.bin ${RKBIN}/.temp/
		# Update ini
		label="TPL+SPL"
		header=`sed -n '/NAME=/s/NAME=//p' ${RKBIN}/RKBOOT/${RKCHIP_LOADER}MINIALL.ini`
		dd if=${RKBIN}/.temp/u-boot-tpl.bin of=${RKBIN}/.temp/tpl.bin bs=1 skip=4
		sed -i "1s/^/${header:0:4}/" ${RKBIN}/.temp/tpl.bin
		sed -i "s/FlashData=.*$/FlashData=.\/.temp\/tpl.bin/"     ${temp_ini}
	fi

	sed -i "s/FlashBoot=.*$/FlashBoot=.\/.temp\/u-boot-spl.bin/"  ${temp_ini}

	${RKTOOLS}/boot_merger ${BIN_PATH_FIXUP} ${temp_ini}
	rm ${RKBIN}/.temp -rf
	cd -
	ls *_loader_*.bin >/dev/null 2>&1 && rm *_loader_*.bin
	mv ${RKBIN}/*_loader_*.bin ./
	filename=`basename *_loader_*.bin`
	if [[ $filename != *spl* ]]; then
		rename 's/loader_/spl_loader_/' *_loader_*.bin
	fi
	echo "pack loader(${label}) okay! Input: ${ini}"
	ls ./*_loader_*.bin
}

pack_loader_image()
{
	local ini=${RKBIN}/RKBOOT/${RKCHIP_LOADER}MINIALL.ini

	if [ "$FILE" != "" ]; then
		ini=$FILE;
	fi

	if [ ! -f $ini ]; then
		echo "pack loader failed! Can't find: $ini"
		return
	fi

	ls *_loader_*.bin >/dev/null 2>&1 && rm *_loader_*.bin

	numline=`cat $ini | wc -l`
	if [ $numline -eq 1 ]; then
		image=`sed -n "/PATH=/p" $ini | tr -d '\r' | cut -d '=' -f 2`
		cp ${RKBIN}/${image} ./
		echo "pack loader okay! Input: ${ini}"
		return;
	fi

	if [ "$PACK_FORMAT" = "rk" ]; then
		cd ${RKBIN}
		${RKTOOLS}/boot_merger ${BIN_PATH_FIXUP} $ini
		cd - && mv ${RKBIN}/*_loader_*.bin ./
		echo "pack loader okay! Input: $ini"
	else
		./scripts/fit-vboot-uboot.sh --no-vboot --no-rebuild >/dev/null
		file=`ls *loader*.bin`
		echo "pack $file okay! Input: $ini"
	fi
}

pack_32bit_trust_image()
{
	local ini=$1 TOS TOS_TA DARM_BASE TEE_LOAD_ADDR TEE_OUTPUT TEE_OFFSET FORMAT

	if [ ! -f ${ini} ]; then
		echo "pack trust failed! Can't find: ${ini}"
		return
	fi

	# Parse orignal path
	TOS=`sed -n "/TOS=/s/TOS=//p" ${ini} |tr -d '\r'`
	TOS_TA=`sed -n "/TOSTA=/s/TOSTA=//p" ${ini} |tr -d '\r'`

	# Parse address and output name
	TEE_OUTPUT=`sed -n "/OUTPUT=/s/OUTPUT=//p" ${ini} |tr -d '\r'`
	if [ "$TEE_OUTPUT" = "" ]; then
		TEE_OUTPUT="./trust.img"
	fi
	TEE_OFFSET=`sed -n "/ADDR=/s/ADDR=//p" ${ini} |tr -d '\r'`
	if [ "$TEE_OFFSET" = "" ]; then
		TEE_OFFSET=0x8400000
	fi

	# OP-TEE is 132M(0x8400000) offset from DRAM base.
	DARM_BASE=`sed -n "/CONFIG_SYS_SDRAM_BASE=/s/CONFIG_SYS_SDRAM_BASE=//p" include/autoconf.mk|tr -d '\r'`
	TEE_LOAD_ADDR=$((DARM_BASE+TEE_OFFSET))

	# Convert Dec to Hex
	TEE_LOAD_ADDR=$(echo "obase=16;${TEE_LOAD_ADDR}"|bc)

	# Replace "./tools/rk_tools/" with "./" to compatible legacy ini content of rkdevelop branch
	TOS=$(echo ${TOS} | sed "s/tools\/rk_tools\//\.\//g")
	TOS_TA=$(echo ${TOS_TA} | sed "s/tools\/rk_tools\//\.\//g")

	if [ "$PACK_FORMAT" = "rk" ]; then
		if [ $TOS_TA ]; then
			${RKTOOLS}/loaderimage --pack --trustos ${RKBIN}/${TOS_TA} ${TEE_OUTPUT} ${TEE_LOAD_ADDR} ${PLATFORM_TRUST_IMG_SIZE}
		elif [ $TOS ]; then
			${RKTOOLS}/loaderimage --pack --trustos ${RKBIN}/${TOS}    ${TEE_OUTPUT} ${TEE_LOAD_ADDR} ${PLATFORM_TRUST_IMG_SIZE}
		else
			echo "Can't find any tee bin"
			exit 1
		fi

		echo "pack trust okay! Input: ${ini}"
	else
		./scripts/fit-vboot-uboot.sh --no-vboot --no-rebuild >/dev/null
		ls uboot.img >/dev/null 2>&1 && rm uboot.img -rf
		ls trust.img >/dev/null 2>&1 && rm trust.img -rf
		echo "pack uboot.fit (with uboot trust) okay! Input: ${ini}"
	fi

	echo
}

pack_64bit_trust_image()
{
	local ini=$1

	if [ ! -f ${ini} ]; then
		echo "pack trust failed! Can't find: ${ini}"
		return
	fi

	cd ${RKBIN}
	${RKTOOLS}/trust_merger ${PLATFORM_SHA} ${PLATFORM_RSA} ${PLATFORM_TRUST_IMG_SIZE} ${BIN_PATH_FIXUP} \
				${PACK_IGNORE_BL32} ${ini}

	cd - && mv ${RKBIN}/trust*.img ./
	echo "pack trust okay! Input: ${ini}"
	echo
}

pack_trust_image()
{
	local ini

	ls trust*.img >/dev/null 2>&1 && rm trust*.img

	# ARM64 uses trust_merger
	if grep -Eq ''^CONFIG_ARM64=y'|'^CONFIG_ARM64_BOOT_AARCH32=y'' .config ; then
		ini=${RKBIN}/RKTRUST/${RKCHIP_TRUST}TRUST.ini
		if [ "$FILE" != "" ]; then
			ini=$FILE;
		fi

		numline=`cat $ini | wc -l`
		if [ $numline -eq 1 ]; then
			image=`sed -n "/PATH=/p" $ini | tr -d '\r' | cut -d '=' -f 2`
			cp ${RKBIN}/${image} ./trust.img
			echo "pack trust okay! Input: ${ini}"
			return;
		fi
		pack_64bit_trust_image ${ini}
	# ARM uses loaderimage
	else
		ini=${RKBIN}/RKTRUST/${RKCHIP_TRUST}TOS.ini
		if [ "$FILE" != "" ]; then
			ini=$FILE;
		fi
		pack_32bit_trust_image ${ini}
	fi
}

finish()
{
	echo
	if [ ! -z "$OPTION" ]; then
		echo "Platform ${RKCHIP_LABEL} is build OK, with exist .config ($OPTION)"
	elif [ "$BOARD" = '' ]; then
		echo "Platform ${RKCHIP_LABEL} is build OK, with exist .config"
	else
		echo "Platform ${RKCHIP_LABEL} is build OK, with new .config(make ${BOARD}_defconfig)"
	fi
}

prepare
select_toolchain
select_chip_info
fixup_platform_configure
sub_commands
make CROSS_COMPILE=${TOOLCHAIN_GCC} ${OPTION} all --jobs=${JOB}
pack_uboot_image
pack_loader_image
pack_trust_image
finish
