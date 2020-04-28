#!/bin/bash
#
# Copyright (c) 2019 Fuzhou Rockchip Electronics Co., Ltd
#
# SPDX-License-Identifier: GPL-2.0
#

set -e
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
RKTOOLS=./tools

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
TOOLCHAIN_OBJDUMP=
TOOLCHAIN_ADDR2LINE=

# Declare global default output dir and cmd, update in prepare()
OPTION=

# Declare global plaform configure, updated in fixup_platform_configure()
PLATFORM_RSA=
PLATFORM_SHA=
PLATFORM_UBOOT_IMG_SIZE=
PLATFORM_TRUST_IMG_SIZE=

IMAGE_FORMAT="RKFW"
IMAGE_NOPACK="n"

#########################################################################################################
function help()
{
	echo
	echo "Usage:"
	echo "	./make.sh [board|sub-command]"
	echo
	echo "	 - board:        board name of defconfig"
	echo "	 - sub-command:  elf*|loader*|spl*|itb|trust*|uboot|map|sym|<addr>|EXT_DTB=*"
	echo "	 - ini:          assigned ini file to pack trust/loader"
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
		IMAGE_FORMAT="FIT"
	fi
}

function process_args()
{
	while [ $# -gt 0 ]; do
		case $1 in
			--help|-help|help|--h|-h)
				help
				exit 0
				;;

			''|loader|trust|uboot|spl*|debug*|itb|env|EXT_DTB=*|nopack|fit*)
				ARG_SUBCMD=$1
				shift 1
				;;

			--rollback-index-uboot)
				ARG_ROLLBACK_IDX_UBOOT="--rollback-index-uboot "$2
				shift 2
				;;

			--rollback-index-boot)
				ARG_ROLLBACK_IDX_BOOT="--rollback-index-boot "$2
				shift 2
				;;

			--new-spl)
				ARG_NEW_SPL=$1
				shift 1
				;;
			map|sym|elf*)
				ARG_SUBCMD=$1
				if [ "$2" = "spl" -o "$2" = "tpl" ]; then
					ARG_S_TPL=$2
					shift 1
				fi
				shift 1
				;;

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

			*)
				# FUNC address
				if [ -z $(echo $1 | sed 's/[0-9,a-f,A-F,x,X,-]//g') ]; then
					ARG_FUNCADDR=$1
				else
					ARG_BOARD=$1
					if [ ! -f configs/${ARG_BOARD}_defconfig ]; then
						echo -e "\n${SUPPORT_LIST}\n"
						echo "ERROR: No configs/${ARG_BOARD}_defconfig"
						exit 1
					else
						echo "make for ${ARG_BOARD}_defconfig by -j${JOB}"
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
			TOOLCHAIN_GCC=${absolute_path}/bin/${GCC_ARM32}
			TOOLCHAIN_OBJDUMP=${absolute_path}/bin/${OBJ_ARM32}
			TOOLCHAIN_ADDR2LINE=${absolute_path}/bin/${ADDR2LINE_ARM32}
		else
			echo "ERROR: No toolchain: ${TOOLCHAIN_ARM32}"
			exit 1
		fi
	fi
}

function sub_commands()
{
	# skip "--" parameter, such as "--rollback-index-..."
	if [[ "$ARG_SUBCMD" != "--*" ]]; then
		cmd=${ARG_SUBCMD%-*}
		opt=${ARG_SUBCMD#*-}
	else
		cmd=$ARG_SUBCMD
	fi

	if [ "$ARG_S_TPL" == "tpl" -o "$ARG_S_TPL" == "spl" ]; then
		elf=`find -name u-boot-${ARG_S_TPL}`
		map=`find -name u-boot-${ARG_S_TPL}.map`
		sym=`find -name u-boot-${ARG_S_TPL}.sym`
	else
		elf=u-boot
		map=u-boot.map
		sym=u-boot.sym
	fi

	case $cmd in
		elf)
			if [ ! -f ${elf} ]; then
				echo "ERROR: No elf: ${elf}"
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
			if [ "$opt" = "ns" ]; then
				./scripts/fit-vboot.sh --no-vboot --ini-trust $INI_TRUST --ini-loader $INI_LOADER $ARG_NEW_SPL
			fi
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
			pack_uboot_image
			exit 0
			;;

		env)
			make CROSS_COMPILE=${TOOLCHAIN_GCC} envtools
			exit 0
			;;

		--rollback-index*)
			pack_fit_image $ARG_ROLLBACK_IDX_UBOOT $ARG_ROLLBACK_IDX_BOOT --ini-trust $INI_TRUST --ini-loader $INI_LOADER  $ARG_NEW_SPL
			exit 0
			;;

		EXT_DTB=*)
			OPTION=${ARG_SUBCMD}
			;;

		nopack)
			IMAGE_NOPACK="y"
			;;

		*)
			# Search function and code position of address
			FUNCADDR=$ARG_FUNCADDR

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
function select_chip_info()
{
	# Read RKCHIP firstly from .config
	# The regular expression that matching:
	#  - PX30, PX3SE
	#  - RK????, RK????X
	#  - RV????
	chip_pattern='^CONFIG_ROCKCHIP_[R,P][X,V,K][0-9ESX]{1,5}'
	RKCHIP=`egrep -o ${chip_pattern} .config`

	# default
	RKCHIP=${RKCHIP##*_}

	# need fixup ?
	for item in "${CHIP_TYPE_FIXUP_TABLE[@]}"
	do
		config_xxx=`echo $item | awk '{ print $1 }'`
		if grep  -q "^${config_xxx}=y" .config ; then
			RKCHIP=`echo $item | awk '{ print $2 }'`
			RKCHIP_LOADER=`echo $item | awk '{ print $3 }'`
			RKCHIP_TRUST=`echo  $item | awk '{ print $4 }'`
			RKCHIP_LABEL=`echo  $item | awk '{ print $5 }'`
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
}

function fixup_platform_configure()
{
	u_kb="-" u_num="-" t_kb="-" t_num="-"  sha="-" rsa="-"

	for item in "${CHIP_CFG_FIXUP_TABLE[@]}"
	do
		config_xxx=`echo $item | awk '{ print $1 }'`
		if grep  -q "^${config_xxx}=y" .config ; then
			# <*> Fixup rsa/sha pack mode for platforms
			rsa=`echo $item | awk '{ print $2 }'`
			sha=`echo $item | awk '{ print $3 }'`

			# <*> Fixup images size pack for platforms, and ini file
			if grep -q '^CONFIG_ARM64_BOOT_AARCH32=y' .config ; then
				u_kb=`echo  $item | awk '{ print $6 }' | awk -F "," '{ print $1 }'`
				t_kb=`echo  $item | awk '{ print $6 }' | awk -F "," '{ print $2 }'`
				u_num=`echo $item | awk '{ print $7 }' | awk -F "," '{ print $1 }'`
				t_num=`echo $item | awk '{ print $7 }' | awk -F "," '{ print $2 }'`

				PAD_LOADER=`echo $item | awk '{ print $8 }'`
				PAD_TRUST=`echo  $item | awk '{ print $9 }'`
				if [ "$PAD_LOADER" != "-" ]; then
					RKCHIP_LOADER=${RKCHIP_LOADER}${PAD_LOADER}
				fi
				if [ "$PAD_TRUST" != "-" ]; then
					RKCHIP_TRUST=${RKCHIP_TRUST}${PAD_TRUST}
				fi
				RKCHIP_LABEL=${RKCHIP_LABEL}"AARCH32"
			else
				u_kb=`echo  $item | awk '{ print $4 }' | awk -F "," '{ print $1 }'`
				t_kb=`echo  $item | awk '{ print $4 }' | awk -F "," '{ print $2 }'`
				u_num=`echo $item | awk '{ print $5 }' | awk -F "," '{ print $1 }'`
				t_num=`echo $item | awk '{ print $5 }' | awk -F "," '{ print $2 }'`
			fi
		fi
	done

	if [ "$sha" != "-" ]; then
		PLATFORM_SHA="--sha $sha"
	fi
	if [ "$rsa" != "-" ]; then
		PLATFORM_RSA="--rsa $rsa"
	fi
	if [ "$u_kb" != "-" ]; then
		PLATFORM_UBOOT_IMG_SIZE="--size $u_kb $u_num"
	fi
	if [ "$t_kb" != "-" ]; then
		PLATFORM_TRUST_IMG_SIZE="--size $t_kb $t_num"
	fi
}

function select_ini_file()
{
	# default
	INI_LOADER=${RKBIN}/RKBOOT/${RKCHIP_LOADER}MINIALL.ini
	if [ "$ARM64_TRUSTZONE" = "y" ]; then
		INI_TRUST=${RKBIN}/RKTRUST/${RKCHIP_TRUST}TRUST.ini
	else
		INI_TRUST=${RKBIN}/RKTRUST/${RKCHIP_TRUST}TOS.ini
	fi

	# args
	if [ "$ARG_INI_TRUST" != "" ]; then
		INI_TRUST=$ARG_INI_TRUST
	fi
	if [ "$ARG_INI_LOADER" != "" ]; then
		INI_LOADER=$ARG_INI_LOADER
	fi
}

function pack_uboot_image()
{
	if [ "$IMAGE_FORMAT" != "RKFW" ]; then
		return
	fi

	# Check file size
	head_kb=2
	uboot_kb=`ls -l u-boot.bin | awk '{print $5}'`
	if [ "$PLATFORM_UBOOT_IMG_SIZE" = "" ]; then
		uboot_max_kb=1046528
	else
		uboot_max_kb=`echo $PLATFORM_UBOOT_IMG_SIZE | awk '{print strtonum($2)}'`
		uboot_max_kb=$(((uboot_max_kb-head_kb)*1024))
	fi

	if [ $uboot_kb -gt $uboot_max_kb ]; then
		echo
		echo "ERROR: pack uboot failed! u-boot.bin actual: $uboot_kb bytes, max limit: $uboot_max_kb bytes"
		exit 1
	fi

	# Pack
	uboot_load_addr=`sed -n "/CONFIG_SYS_TEXT_BASE=/s/CONFIG_SYS_TEXT_BASE=//p" include/autoconf.mk|tr -d '\r'`
	if [ -z $uboot_load_addr ]; then
		echo "ERROR: No CONFIG_SYS_TEXT_BASE for u-boot";
		exit 1
	fi
	${RKTOOLS}/loaderimage --pack --uboot u-boot.bin uboot.img ${uboot_load_addr} ${PLATFORM_UBOOT_IMG_SIZE}
	rm u-boot.img u-boot-dtb.img -rf
	echo "pack uboot okay! Input: u-boot.bin"
}

function pack_uboot_itb_image()
{
	ini=$INI_TRUST

	if [ ! -f $INI_TRUST ]; then
		echo "pack trust failed! Can't find: $INI_TRUST"
		return
	fi

	if [ "$ARM64_TRUSTZONE" = "y" ]; then
		bl31=`sed -n '/_bl31_/s/PATH=//p' $ini |tr -d '\r'`
		cp ${RKBIN}/${bl31} bl31.elf
		make CROSS_COMPILE=${TOOLCHAIN_GCC} u-boot.itb
		echo "pack u-boot.itb okay! Input: $ini"
	else
		tos_image=`sed -n "/TOS=/s/TOS=//p" $ini |tr -d '\r'`
		tosta_image=`sed -n "/TOSTA=/s/TOSTA=//p" $ini |tr -d '\r'`
		if [ $tosta_image ]; then
			cp ${RKBIN}/${tosta_image} tee.bin
		elif [ $tos_image ]; then
			cp ${RKBIN}/${tos_image}   tee.bin
		else
			echo "ERROR: No any tee bin"
			exit 1
		fi

		tee_offset=`sed -n "/ADDR=/s/ADDR=//p" $ini |tr -d '\r'`
		if [ "$tee_offset" = "" ]; then
			tee_offset=0x8400000
		fi

		mcu_enabled=`awk -F"," '/MCU=/ { printf $3 }' $ini | tr -d ' '`
		if [ "$mcu_enabled" = "enabled" ]; then
			mcu_image=`awk -F"," '/MCU=/ { printf $1 }' $ini | tr -d ' ' | cut -c 5-`
			mcu_offset=`awk -F"," '/MCU=/ { printf $2 }' $ini | tr -d ' '`
			cp ${RKBIN}/${mcu_image} mcu.bin
		fi

		SPL_FIT_SOURCE=`sed -n "/CONFIG_SPL_FIT_SOURCE=/s/CONFIG_SPL_FIT_SOURCE=//p" .config | tr -d '""'`
		if [ ! -z $SPL_FIT_SOURCE ]; then
			cp $SPL_FIT_SOURCE u-boot.its
		else
			SPL_FIT_GENERATOR=`sed -n "/CONFIG_SPL_FIT_GENERATOR=/s/CONFIG_SPL_FIT_GENERATOR=//p" .config | tr -d '""'`
			$SPL_FIT_GENERATOR $tee_offset $mcu_offset > u-boot.its
		fi
		./tools/mkimage -f u-boot.its -E u-boot.itb
		echo "pack u-boot.itb okay! Input: $ini"
	fi
	echo
}

function pack_spl_loader_image()
{
	mode=$1
	tmp_dir=${RKBIN}/tmp
	tmp_ini=${tmp_dir}/${RKCHIP_LOADER}MINIALL.ini
	ini=$INI_LOADER
	if [ ! -f $INI_LOADER ]; then
		echo "pack loader failed! Can't find: $INI_LOADER"
		return
	fi

	rm ${tmp_dir} -rf
	mkdir ${tmp_dir} -p
	cp spl/u-boot-spl.bin ${tmp_dir}/
	cp $ini $tmp_ini
	if [ "$mode" = 'spl' ]; then	# pack tpl+spl
		label="TPL+SPL"
		cp tpl/u-boot-tpl.bin ${tmp_dir}/
		header=`sed -n '/NAME=/s/NAME=//p' ${ini}`
		dd if=${tmp_dir}/u-boot-tpl.bin of=${tmp_dir}/tpl.bin bs=1 skip=4
		sed -i "1s/^/${header:0:4}/" ${tmp_dir}/tpl.bin
		sed -i "s/FlashData=.*$/FlashData=.\/tmp\/tpl.bin/" $tmp_ini
	else
		label="SPL"
	fi

	sed -i "s/FlashBoot=.*$/FlashBoot=.\/tmp\/u-boot-spl.bin/" $tmp_ini
	cd ${RKBIN}
	${RKTOOLS}/boot_merger $tmp_ini
	rm ${tmp_dir} -rf
	cd -
	rm *_loader_*.bin -rf
	mv ${RKBIN}/*_loader_*.bin ./

	filename=`basename *_loader_*.bin`
	if [[ $filename != *spl* ]]; then
		rename 's/loader_/spl_loader_/' *_loader_*.bin
	fi
	echo "pack loader(${label}) okay! Input: $ini"
}

function pack_loader_image()
{
	ini=$INI_LOADER
	if [ ! -f $INI_LOADER ]; then
		echo "pack loader failed! Can't find: $INI_LOADER"
		return
	fi

	rm *_loader_*.bin -rf
	numline=`cat $ini | wc -l`
	if [ $numline -eq 1 ]; then
		image=`sed -n "/PATH=/p" $ini | tr -d '\r' | cut -d '=' -f 2`
		cp ${RKBIN}/${image} ./
	else
		cd ${RKBIN}
		${RKTOOLS}/boot_merger $ini
		cd - && mv ${RKBIN}/*_loader_*.bin ./
	fi

	file=`ls *loader*.bin`
	echo "pack $file okay! Input: $ini"
}

function pack_arm32_trust_image()
{
	ini=$1
	tos_image=`sed -n "/TOS=/s/TOS=//p" $ini |tr -d '\r'`
	tosta_image=`sed -n "/TOSTA=/s/TOSTA=//p" $ini |tr -d '\r'`
	tee_output=`sed -n "/OUTPUT=/s/OUTPUT=//p" $ini |tr -d '\r'`
	if [ "$tee_output" = "" ]; then
		tee_output="./trust.img"
	fi
	tee_offset=`sed -n "/ADDR=/s/ADDR=//p" $ini |tr -d '\r'`
	if [ "$tee_offset" = "" ]; then
		tee_offset=0x8400000
	fi

	# OP-TEE is 132M(0x8400000) offset from DRAM base.
	dram_base=`sed -n "/CONFIG_SYS_SDRAM_BASE=/s/CONFIG_SYS_SDRAM_BASE=//p" include/autoconf.mk|tr -d '\r'`
	tee_load_addr=$((dram_base+tee_offset))
	tee_load_addr=$(echo "obase=16;${tee_load_addr}"|bc) # Convert Dec to Hex

	if [ $tosta_image ]; then
		${RKTOOLS}/loaderimage --pack --trustos ${RKBIN}/${tosta_image} ${tee_output} ${tee_load_addr} ${PLATFORM_TRUST_IMG_SIZE}
	elif [ $tos_image ]; then
		${RKTOOLS}/loaderimage --pack --trustos ${RKBIN}/${tos_image}   ${tee_output} ${tee_load_addr} ${PLATFORM_TRUST_IMG_SIZE}
	else
		echo "ERROR: No any tee bin"
		exit 1
	fi
	echo "pack trust okay! Input: $ini"
}

function pack_arm64_trust_image()
{
	ini=$1
	cd ${RKBIN}
	${RKTOOLS}/trust_merger ${PLATFORM_SHA} ${PLATFORM_RSA} ${PLATFORM_TRUST_IMG_SIZE} $ini
	cd - && mv ${RKBIN}/trust*.img ./
	echo "pack trust okay! Input: $ini"
}

function pack_trust_image()
{
	if [ "$IMAGE_FORMAT" != "RKFW" ]; then
		return
	fi

	rm trust*.img -rf
	ini=$INI_TRUST
	if [ ! -f $INI_TRUST ]; then
		echo "pack trust failed! Can't find: $INI_TRUST"
		return
	fi

	numline=`cat $ini | wc -l`
	if [ $numline -eq 1 ]; then
		image=`sed -n "/PATH=/p" $ini | tr -d '\r' | cut -d '=' -f 2`
		cp ${RKBIN}/${image} ./trust.img
		echo "pack trust okay! Input: $ini"
		return;
	else
		if [ "$ARM64_TRUSTZONE" = "y" ]; then
			pack_arm64_trust_image $ini
		else
			pack_arm32_trust_image $ini
		fi
	fi
}

function pack_fit_image()
{
	if grep -q '^CONFIG_FIT_SIGNATURE=y' .config ; then
		./scripts/fit-vboot.sh $ARG_ROLLBACK_IDX_UBOOT $ARG_ROLLBACK_IDX_BOOT --ini-trust $INI_TRUST --ini-loader $INI_LOADER $ARG_NEW_SPL
	else
		rm uboot.img trust*.img -rf
		./scripts/fit-vboot-uboot.sh --no-vboot --no-rebuild --ini-trust $INI_TRUST --ini-loader $INI_LOADER  $ARG_NEW_SPL
		echo "pack uboot.img (with uboot trust) okay! Input: $INI_TRUST"
	fi
}

function pack_images()
{
	if [ "$IMAGE_NOPACK" != "y" ]; then
		if [ "$IMAGE_FORMAT" = "RKFW" ]; then
			pack_uboot_image
			pack_trust_image
			pack_loader_image
		elif [ "$IMAGE_FORMAT" = "FIT" ]; then
			pack_fit_image $ARG_ROLLBACK_IDX_UBOOT $ARG_ROLLBACK_IDX_BOOT --ini-trust $INI_TRUST --ini-loader $INI_LOADER  $ARG_NEW_SPL
		fi
	fi
}

function clean_files()
{
	if [ -f spl/u-boot-spl.dtb ]; then
		rm spl/u-boot-spl.dtb -rf
	fi
	if [ -f tpl/u-boot-tpl.dtb ]; then
		rm tpl/u-boot-tpl.dtb -rf
	fi
	if [ -f u-boot.dtb ]; then
		rm u-boot.dtb -rf
	fi
}

function finish()
{
	echo
	if [ ! -z "$OPTION" ]; then
		echo "Platform ${RKCHIP_LABEL} is build OK, with exist .config ($OPTION)"
	elif [ "$ARG_BOARD" = '' ]; then
		echo "Platform ${RKCHIP_LABEL} is build OK, with exist .config"
	else
		echo "Platform ${RKCHIP_LABEL} is build OK, with new .config(make ${ARG_BOARD}_defconfig)"
	fi
}

process_args $*
prepare
select_toolchain
select_chip_info
fixup_platform_configure
select_ini_file
sub_commands
clean_files
make CROSS_COMPILE=${TOOLCHAIN_GCC} ${OPTION} all --jobs=${JOB}
pack_images
finish
