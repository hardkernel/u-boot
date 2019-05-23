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
JOB=`sed -n "N;/processor/p" /proc/cpuinfo|wc -l`
SUPPORT_LIST=`ls configs/*[r,p][x,v,k][0-9][0-9]*_defconfig`

# @target board: defined in arch/arm/mach-rockchip/<soc>/Kconfig
# @label: show build message
# @loader: search for ini file to pack loader
# @trust: search for ini file to pack trust
#
# "NA" means use default name reading from .config
#
# Format:           target board               label         loader      trust
RKCHIP_INI_DESC=("CONFIG_TARGET_GVA_RK3229       NA          RK322XAT     NA"
                 "CONFIG_COPROCESSOR_RK1808  RKNPU-LION      RKNPULION    RKNPULION"
# to be add...
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
RKCHIP=
RKCHIP_LABEL=
RKCHIP_LOADER=
RKCHIP_TRUST=

# Declare rkbin repository path, updated in prepare()
RKBIN=

# Declare global toolchain path for CROSS_COMPILE, updated in select_toolchain()
TOOLCHAIN_GCC=
TOOLCHAIN_OBJDUMP=
TOOLCHAIN_ADDR2LINE=

# Declare global default output dir and cmd, update in prepare()
OUTDIR=$2
OUTOPT=

# Declare global plaform configure, updated in fixup_platform_configure()
PLATFORM_RSA=
PLATFORM_SHA=
PLATFORM_UBOOT_IMG_SIZE=
PLATFORM_TRUST_IMG_SIZE=

# Out env param
PACK_IGNORE_BL32=$TRUST_PACK_IGNORE_BL32	# Value only: "--ignore-bl32"
#########################################################################################################
help()
{
	echo
	echo "Usage:"
	echo "	./make.sh [board|subcmd] [O=<dir>]"
	echo
	echo "	 - board: board name of defconfig"
	echo "	 - subcmd: loader|loader-all|trust|trust-all|uboot|elf|map|sym|<addr>|"
	echo "	 - O=<dir>: assigned output directory"
	echo
	echo "Example:"
	echo
	echo "1. Build board:"
	echo "	./make.sh evb-rk3399               --- build for evb-rk3399_defconfig"
	echo "	./make.sh evb-rk3399 O=rockdev     --- build for evb-rk3399_defconfig with output dir "./rockdev""
	echo "	./make.sh firefly-rk3288           --- build for firefly-rk3288_defconfig"
	echo "	./make.sh                          --- build with exist .config"
	echo
	echo "	After build, Images of uboot, loader and trust are all generated."
	echo
	echo "2. Pack helper:"
	echo "	./make.sh uboot                    --- pack uboot.img"
	echo "	./make.sh trust                    --- pack trust.img"
	echo "	./make.sh trust-all                --- pack trust img (all supported)"
	echo "	./make.sh loader                   --- pack loader bin"
	echo "	./make.sh loader-all	           --- pack loader bin (all supported)"
	echo
	echo "3. Debug helper:"
	echo "	./make.sh elf                      --- dump elf file with -D(default)"
	echo "	./make.sh elf-S                    --- dump elf file with -S"
	echo "	./make.sh elf-d                    --- dump elf file with -d"
	echo "	./make.sh <no reloc_addr>          --- dump function symbol and code position of address(no relocated)"
	echo "	./make.sh <reloc_addr-reloc_off>   --- dump function symbol and code position of address(relocated)"
	echo "	./make.sh map                      --- cat u-boot.map"
	echo "	./make.sh sym                      --- cat u-boot.sym"
}

prepare()
{
	local absolute_path cmd dir count

	# Parse output directory 'O=<dir>'
	cmd=${OUTDIR%=*}
	if [ "${cmd}" = 'O' ]; then
		OUTDIR=${OUTDIR#*=}
		OUTOPT=O=${OUTDIR}
	else
		case $BOARD in
			# Parse from exit .config
			''|elf*|loader*|debug*|trust*|uboot|map|sym)
			count=`find -name .config | wc -l`
			dir=`find -name .config`
			# Good, find only one .config
			if [ $count -eq 1 ]; then
				dir=${dir%/*}
				OUTDIR=${dir#*/}
				# Set OUTOPT if not current directory
				if [ $OUTDIR != '.' ]; then
					OUTOPT=O=${OUTDIR}
				fi
			elif [ $count -eq 0 ]; then
				echo
				echo "Build failed, Can't find .config"
				help
				exit 1
			else
				echo
				echo "Build failed, find $count '.config': "
				echo "$dir"
				echo "Please leave only one of them"
				exit 1
			fi
			;;

			*)
			OUTDIR=.
			;;
		esac
	fi

	# Parse help and make defconfig
	case $BOARD in
		#Help
		--help|-help|help|--h|-h)
		help
		exit 0
		;;

		#Subcmd
		''|elf*|loader*|debug*|trust*|uboot|map|sym)
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
			make ${BOARD}_defconfig ${OUTOPT}
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
}

select_toolchain()
{
	local absolute_path

	if grep  -q '^CONFIG_ARM64=y' ${OUTDIR}/.config ; then
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

	case $cmd in
		elf)
		if [ ! -f ${OUTDIR}/u-boot ]; then
			echo "Can't find elf file: ${OUTDIR}/u-boot"
			exit 1
		else
			# default 'cmd' without option, use '-D'
			if [ "${cmd}" = 'elf' -a "${opt}" = 'elf' ]; then
				opt=D
			fi
			${TOOLCHAIN_OBJDUMP} -${opt} ${OUTDIR}/u-boot | less
			exit 0
		fi
		;;

		debug)
		debug_command
		exit 0
		;;

		map)
		cat ${OUTDIR}/u-boot.map | less
		exit 0
		;;

		sym)
		cat ${OUTDIR}/u-boot.sym | less
		exit 0
		;;

		trust)
		pack_trust_image ${opt}
		exit 0
		;;

		loader)
		pack_loader_image ${opt}
		exit 0
		;;

		uboot)
		pack_uboot_image ${opt}
		exit 0
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
			sed -n "/${FUNCADDR}/p" ${OUTDIR}/u-boot.sym
			${TOOLCHAIN_ADDR2LINE} -e ${OUTDIR}/u-boot ${FUNCADDR}
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
	local target_board item value

	# Read RKCHIP firstly from .config
	# The regular expression that matching:
	#  - PX30, PX3SE
	#  - RK????, RK????X
	#  - RV????
	local chip_reg='^CONFIG_ROCKCHIP_[R,P][X,V,K][0-9ESX]{1,5}'
	count=`egrep -c ${chip_reg} ${OUTDIR}/.config`
	# Obtain the matching only
	RKCHIP=`egrep -o ${chip_reg} ${OUTDIR}/.config`

	if [ $count -eq 1 ]; then
		RKCHIP=${RKCHIP##*_}
		grep '^CONFIG_ROCKCHIP_RK3368=y' ${OUTDIR}/.config >/dev/null \
			&& RKCHIP=RK3368H
		grep '^CONFIG_ROCKCHIP_RV1108=y' ${OUTDIR}/.config >/dev/null \
			&& RKCHIP=RV110X
	elif [ $count -gt 1 ]; then
		# Grep the RK CHIP variant
		grep '^CONFIG_ROCKCHIP_PX3SE=y' ${OUTDIR}/.config > /dev/null \
			&& RKCHIP=PX3SE
		grep '^CONFIG_ROCKCHIP_RK3126=y' ${OUTDIR}/.config >/dev/null \
			&& RKCHIP=RK3126
		grep '^CONFIG_ROCKCHIP_RK3326=y' ${OUTDIR}/.config >/dev/null \
			&& RKCHIP=RK3326
		grep '^CONFIG_ROCKCHIP_RK3128X=y' ${OUTDIR}/.config >/dev/null \
			&& RKCHIP=RK3128X
		grep '^CONFIG_ROCKCHIP_PX5=y' ${OUTDIR}/.config >/dev/null \
			&& RKCHIP=PX5
		grep '^CONFIG_ROCKCHIP_RK3399PRO=y' ${OUTDIR}/.config >/dev/null \
			&& RKCHIP=RK3399PRO
	else
		echo "Can't get Rockchip SoC definition in .config"
		exit 1
	fi

	# Default use RKCHIP
	RKCHIP_LABEL=${RKCHIP}
	RKCHIP_LOADER=${RKCHIP}
	RKCHIP_TRUST=${RKCHIP}

	# Read from RKCHIP_INI_DESC
	for item in "${RKCHIP_INI_DESC[@]}"
	do
		target_board=`echo $item | awk '{ print $1 }'`
		if grep  -q "^${target_board}=y" ${OUTDIR}/.config ; then
			value=`echo $item | awk '{ print $2 }'`
			if [ "$value" != "NA" ]; then
				RKCHIP_LABEL=${value};
			fi
			value=`echo $item | awk '{ print $3 }'`
			if [ "$value" != "NA" ]; then
				RKCHIP_LOADER=${value};
			fi
			value=`echo $item | awk '{ print $4 }'`
			if [ "$value" != "NA" ]; then
				RKCHIP_TRUST=${value};
			fi
		fi
	done
}

# Fixup platform special configure
#	1. fixup pack mode;
#	2. fixup image size
#	3. fixup ARM64 cpu boot with AArch32
fixup_platform_configure()
{
	local count plat

# <*> Fixup rsa/sha pack mode for platforms
	# RK3308/PX30/RK3326/RK1808 use RSA-PKCS1 V2.1, it's pack magic is "3"
	if [ $RKCHIP = "PX30" -o $RKCHIP = "RK3326" -o $RKCHIP = "RK3308" -o $RKCHIP = "RK1808" ]; then
		PLATFORM_RSA="--rsa 3"
	# RK3368 use rk big endian SHA256, it's pack magic is "2"
	elif [ $RKCHIP = "RK3368" ]; then
		PLATFORM_SHA="--sha 2"
	# other platforms use default configure
	fi

# <*> Fixup images size pack for platforms
	if [ $RKCHIP = "RK3308" ]; then
		if grep -q '^CONFIG_ARM64_BOOT_AARCH32=y' ${OUTDIR}/.config ; then
			PLATFORM_UBOOT_IMG_SIZE="--size 512 2"
			PLATFORM_TRUST_IMG_SIZE="--size 512 2"
		else
			PLATFORM_UBOOT_IMG_SIZE="--size 1024 2"
			PLATFORM_TRUST_IMG_SIZE="--size 1024 2"
		fi
	elif [ $RKCHIP = "RK1808" ]; then
		PLATFORM_UBOOT_IMG_SIZE="--size 1024 2"
		PLATFORM_TRUST_IMG_SIZE="--size 1024 2"
	fi

# <*> Fixup AARCH32 for ARM64 cpu platforms
	if grep -q '^CONFIG_ARM64_BOOT_AARCH32=y' ${OUTDIR}/.config ; then
		if [ $RKCHIP = "RK3308" ]; then
			RKCHIP_LABEL=${RKCHIP_LABEL}"AARCH32"
			RKCHIP_TRUST=${RKCHIP_TRUST}"AARCH32"
		elif [ $RKCHIP = "RK3326" ]; then
			RKCHIP_LABEL=${RKCHIP_LABEL}"AARCH32"
			RKCHIP_LOADER=${RKCHIP_LOADER}"AARCH32"
		fi
	fi
}

debug_command()
{
		if [ "${cmd}" = 'debug' -a "${opt}" = 'debug' ]; then
			echo
			echo "The commands will modify .config and files, and can't auto restore changes!"
			echo "debug-N, the N:"
			echo "    1. lib/initcall.c debug() -> printf()"
			echo "    2. common/board_r.c and common/board_f.c debug() -> printf()"
			echo "    3. global #define DEBUG"
			echo "    4. enable CONFIG_ROCKCHIP_DEBUGGER"
			echo "    5. enable CONFIG_ROCKCHIP_CRC"
			echo "    6. enable CONFIG_BOOTSTAGE_PRINTF_TIMESTAMP"
			echo "    7. enable CONFIG_ROCKCHIP_CRASH_DUMP"
			echo "    8. set CONFIG_BOOTDELAY=5"
			echo "    9. armv7 start.S: print entry warning"
			echo "   10. armv8 start.S: print entry warning"
			echo "   11. firmware bootflow debug() -> printf()"
			echo "   12. bootstage timing report"
			echo
			echo "Enabled: "
			grep '^CONFIG_ROCKCHIP_DEBUGGER=y' ${OUTDIR}/.config > /dev/null \
			&& echo "    CONFIG_ROCKCHIP_DEBUGGER"
			grep '^CONFIG_ROCKCHIP_CRC=y' ${OUTDIR}/.config > /dev/null \
			&& echo "    CONFIG_ROCKCHIP_CRC"
			grep '^CONFIG_BOOTSTAGE_PRINTF_TIMESTAMP=y' ${OUTDIR}/.config > /dev/null \
			&& echo "    CONFIG_BOOTSTAGE_PRINTF_TIMESTAMP"
			grep '^CONFIG_ROCKCHIP_CRASH_DUMP=y' ${OUTDIR}/.config > /dev/null \
			&& echo "    CONFIG_ROCKCHIP_CRASH_DUMP"

		elif [ "${opt}" = '1' ]; then
			sed -i 's/\<debug\>/printf/g' lib/initcall.c
			sed -i 's/ifdef DEBUG/if 1/g' lib/initcall.c
			echo "DEBUG [1]: lib/initcall.c debug() -> printf()"
		elif [ "${opt}" = '2' ]; then
			sed -i 's/\<debug\>/printf/g' ./common/board_f.c
			sed -i 's/\<debug\>/printf/g' ./common/board_r.c
			echo "DEBUG [2]: common/board_r.c and common/board_f.c debug() -> printf()"
		elif [ "${opt}" = '3' ]; then
			sed -i '$i \#define DEBUG\' include/configs/rockchip-common.h
			echo "DEBUG [3]: global #define DEBUG"
		elif [ "${opt}" = '4' ]; then
			sed -i 's/\# CONFIG_ROCKCHIP_DEBUGGER is not set/CONFIG_ROCKCHIP_DEBUGGER=y/g' ${OUTDIR}/.config
			echo "DEBUG [4]: CONFIG_ROCKCHIP_DEBUGGER is enabled"
		elif [ "${opt}" = '5' ]; then
			sed -i 's/\# CONFIG_ROCKCHIP_CRC is not set/CONFIG_ROCKCHIP_CRC=y/g' ${OUTDIR}/.config
			echo "DEBUG [5]: CONFIG_ROCKCHIP_CRC is enabled"
		elif [ "${opt}" = '6' ]; then
			sed -i 's/\# CONFIG_BOOTSTAGE_PRINTF_TIMESTAMP is not set/CONFIG_BOOTSTAGE_PRINTF_TIMESTAMP=y/g' ${OUTDIR}/.config
			echo "DEBUG [6]: CONFIG_BOOTSTAGE_PRINTF_TIMESTAMP is enabled"
		elif [ "${opt}" = '7' ]; then
			sed -i 's/\# CONFIG_ROCKCHIP_CRASH_DUMP is not set/CONFIG_ROCKCHIP_CRASH_DUMP=y/g' ${OUTDIR}/.config
			echo "DEBUG [7]: CONFIG_ROCKCHIP_CRASH_DUMP is enabled"
		elif [ "${opt}" = '8' ]; then
			sed -i 's/^CONFIG_BOOTDELAY=0/CONFIG_BOOTDELAY=5/g' ${OUTDIR}/.config
			echo "DEBUG [8]: CONFIG_BOOTDELAY is 5s"
		elif [ "${opt}" = '9' ]; then
			sed -i '/save_boot_params_ret:/a\ldr r0, =CONFIG_DEBUG_UART_BASE\nmov r1, #100\nloop:\nmov r2, #0x55\nstr r2, [r0]\nsub r1, r1, #1\ncmp r1, #0\nbne loop\ndsb' \
			./arch/arm/cpu/armv7/start.S
			echo "DEBUG [9]: armv7 start.S entry warning 'UUUU...'"
		elif [ "${opt}" = '10' ]; then
			sed -i '/save_boot_params_ret:/a\ldr x0, =CONFIG_DEBUG_UART_BASE\nmov x1, #100\nloop:\nmov x2, #0x55\nstr x2, [x0]\nsub x1, x1, #1\ncmp x1, #0\nb.ne loop\ndsb sy' \
			./arch/arm/cpu/armv8/start.S
			echo "DEBUG [10]: armv8 start.S entry warning 'UUUU...'"
		elif [ "${opt}" = '11' ]; then
			sed -i 's/\<debug\>/printf/g' common/fdt_support.c
			sed -i 's/\<debug\>/printf/g' common/image-fdt.c
			sed -i 's/\<debug\>/printf/g' common/image.c
			sed -i 's/\<debug\>/printf/g' arch/arm/lib/bootm.c
			sed -i 's/\<debug\>/printf/g' common/bootm.c
			sed -i 's/\<debug\>/printf/g' common/image.c
			sed -i 's/\<debug\>/printf/g' common/image-android.c
			sed -i 's/\<debug\>/printf/g' common/android_bootloader.c
			echo "DEBUG [11]: firmware bootflow debug() -> printf()"
		elif [ "${opt}" = '12' ]; then
			sed -i '$a\CONFIG_BOOTSTAGE=y\' ${OUTDIR}/.config
			sed -i '$a\CONFIG_BOOTSTAGE_REPORT=y\' ${OUTDIR}/.config
			sed -i '$a\CONFIG_CMD_BOOTSTAGE=y\' ${OUTDIR}/.config
			echo "DEBUG [12]: bootstage timing report"
		fi
		echo
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

	# Pack image
	UBOOT_LOAD_ADDR=`sed -n "/CONFIG_SYS_TEXT_BASE=/s/CONFIG_SYS_TEXT_BASE=//p" ${OUTDIR}/include/autoconf.mk|tr -d '\r'`
	if [ ! $UBOOT_LOAD_ADDR ]; then
		UBOOT_LOAD_ADDR=`sed -n "/CONFIG_SYS_TEXT_BASE=/s/CONFIG_SYS_TEXT_BASE=//p" ${OUTDIR}/.config|tr -d '\r'`
	fi

	${RKTOOLS}/loaderimage --pack --uboot ${OUTDIR}/u-boot.bin uboot.img ${UBOOT_LOAD_ADDR} ${PLATFORM_UBOOT_IMG_SIZE}

	# Delete u-boot.img and u-boot-dtb.img, which makes users not be confused with final uboot.img
	if [ -f ${OUTDIR}/u-boot.img ]; then
		rm ${OUTDIR}/u-boot.img
	fi

	if [ -f ${OUTDIR}/u-boot-dtb.img ]; then
		rm ${OUTDIR}/u-boot-dtb.img
	fi

	echo "pack uboot okay! Input: ${OUTDIR}/u-boot.bin"
}

pack_loader_image()
{
	local mode=$1 files ini=${RKBIN}/RKBOOT/${RKCHIP_LOADER}MINIALL.ini

	if [ ! -f $ini ]; then
		echo "pack loader failed! Can't find: $ini"
		return
	fi

	ls *_loader_*.bin >/dev/null && rm *_loader_*.bin
	cd ${RKBIN}

	if [ "${mode}" = 'all' ]; then
		files=`ls ${RKBIN}/RKBOOT/${RKCHIP_LOADER}MINIALL*.ini`
		for ini in $files
		do
			if [ -f "$ini" ]; then
				${RKTOOLS}/boot_merger ${BIN_PATH_FIXUP} $ini
				echo "pack loader okay! Input: $ini"
			fi
		done
	else
		${RKTOOLS}/boot_merger ${BIN_PATH_FIXUP} $ini
		echo "pack loader okay! Input: $ini"
	fi

	cd - && mv ${RKBIN}/*_loader_*.bin ./
}

__pack_32bit_trust_image()
{
	local ini=$1 TOS TOS_TA DARM_BASE TEE_LOAD_ADDR TEE_OUTPUT TEE_OFFSET

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
	DARM_BASE=`sed -n "/CONFIG_SYS_SDRAM_BASE=/s/CONFIG_SYS_SDRAM_BASE=//p" ${OUTDIR}/include/autoconf.mk|tr -d '\r'`
	TEE_LOAD_ADDR=$((DARM_BASE+TEE_OFFSET))

	# Convert Dec to Hex
	TEE_LOAD_ADDR=$(echo "obase=16;${TEE_LOAD_ADDR}"|bc)

	# Replace "./tools/rk_tools/" with "./" to compatible legacy ini content of rkdevelop branch
	TOS=$(echo ${TOS} | sed "s/tools\/rk_tools\//\.\//g")
	TOS_TA=$(echo ${TOS_TA} | sed "s/tools\/rk_tools\//\.\//g")

	if [ $TOS_TA ]; then
		${RKTOOLS}/loaderimage --pack --trustos ${RKBIN}/${TOS_TA} ${TEE_OUTPUT} ${TEE_LOAD_ADDR} ${PLATFORM_TRUST_IMG_SIZE}
	elif [ $TOS ]; then
		${RKTOOLS}/loaderimage --pack --trustos ${RKBIN}/${TOS}    ${TEE_OUTPUT} ${TEE_LOAD_ADDR} ${PLATFORM_TRUST_IMG_SIZE}
	else
		echo "Can't find any tee bin"
		exit 1
	fi

	echo "pack trust okay! Input: ${ini}"
	echo
}

__pack_64bit_trust_image()
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
	local mode=$1 files ini

	ls trust*.img >/dev/null && rm trust*.img
	# ARM64 uses trust_merger
	if grep -Eq ''^CONFIG_ARM64=y'|'^CONFIG_ARM64_BOOT_AARCH32=y'' ${OUTDIR}/.config ; then
		ini=${RKBIN}/RKTRUST/${RKCHIP_TRUST}TRUST.ini
		if [ "${mode}" = 'all' ]; then
			files=`ls ${RKBIN}/RKTRUST/${RKCHIP_TRUST}TRUST*.ini`
			for ini in $files
			do
				__pack_64bit_trust_image ${ini}
			done
		else
			__pack_64bit_trust_image ${ini}
		fi
	# ARM uses loaderimage
	else
		ini=${RKBIN}/RKTRUST/${RKCHIP_TRUST}TOS.ini
		if [ "${mode}" = 'all' ]; then
			files=`ls ${RKBIN}/RKTRUST/${RKCHIP_TRUST}TOS*.ini`
			for ini in $files
			do
				__pack_32bit_trust_image ${ini}
			done
		else
			__pack_32bit_trust_image ${ini}
		fi
	fi
}

finish()
{
	echo
	if [ "$BOARD" = '' ]; then
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
make CROSS_COMPILE=${TOOLCHAIN_GCC}  all --jobs=${JOB} ${OUTOPT}
pack_uboot_image
pack_loader_image
pack_trust_image
finish
