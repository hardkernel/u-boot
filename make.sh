#!/bin/bash
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
# Declare global INI file searching index name for every chip, update in select_chip_info()
RKCHIP=
RKCHIP_LABEL=
RKCHIP_LOADER=
RKCHIP_TRUST=

# Declare global rkbin RKTOOLS and rkbin repository path, updated in prepare()
RKTOOLS=
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
PLATFORM_AARCH32=
#########################################################################################################
help()
{
	echo
	echo "Usage:"
	echo "	./make.sh [board|subcmd] [O=<dir>]"
	echo
	echo "	 - board: board name of defconfig"
	echo "	 - subcmd: loader|loader-all|trust|uboot|elf|map|sym|<addr>|"
	echo "	 - O=<dir>: assigned output directory"
	echo
	echo "Example:"
	echo
	echo "1. Build board:"
	echo "	./make.sh evb-rk3399            ---- build for evb-rk3399_defconfig"
	echo "	./make.sh evb-rk3399 O=rockdev  ---- build for evb-rk3399_defconfig with output dir "./rockdev""
	echo "	./make.sh firefly-rk3288        ---- build for firefly-rk3288_defconfig"
	echo "	./make.sh                       ---- build with exist .config"
	echo
	echo "	After build, images of uboot, loader and trust are all generated."
	echo
	echo "2. Pack helper:"
	echo "	./make.sh trust         --- pack trust.img"
	echo "	./make.sh uboot         --- pack uboot.img"
	echo "	./make.sh loader        --- pack loader bin"
	echo "	./make.sh loader-all	--- pack loader bin (all supported loaders)"
	echo
	echo "3. Debug helper:"
	echo "	./make.sh elf           --- dump elf file with -D(default)"
	echo "	./make.sh elf-S         --- dump elf file with -S"
	echo "	./make.sh elf-d         --- dump elf file with -d"
	echo "	./make.sh <addr>        --- dump function symbol and code position of address"
	echo "	./make.sh map           --- cat u-boot.map"
	echo "	./make.sh sym           --- cat u-boot.sym"
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
			''|elf*|loader*|trust|uboot|map|sym)
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
		''|elf*|loader*|trust|uboot|map|sym)
		;;

		*)
		#Func address is valid ?
		if [ -z $(echo ${FUNCADDR} | sed 's/[0-9,a-f,A-F,x,X]//g') ]; then
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

	# Initialize RKBIN and RKTOOLS
	if [ -d ${RKBIN_TOOLS} ]; then
		absolute_path=$(cd `dirname ${RKBIN_TOOLS}`; pwd)
		RKBIN=${absolute_path}
		RKTOOLS=${absolute_path}/tools
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

		map)
		cat ${OUTDIR}/u-boot.map | less
		exit 0
		;;

		sym)
		cat ${OUTDIR}/u-boot.sym | less
		exit 0
		;;

		trust)
		pack_trust_image
		exit 0
		;;

		loader)
		pack_loader_image ${opt}
		exit 0
		;;

		uboot)
		pack_uboot_image
		exit 0
		;;

		*)
		# Search function and code position of address
		if [ -z $(echo ${FUNCADDR} | sed 's/[0-9,a-f,A-F,x,X]//g') ] && [ ${FUNCADDR} ]; then
			# With prefix: '0x' or '0X'
			if [ `echo ${FUNCADDR} | sed -n "/0[x,X]/p" | wc -l` -ne 0 ]; then
				FUNCADDR=`echo $FUNCADDR | awk '{ print strtonum($0) }'`
				FUNCADDR=`echo "obase=16;${FUNCADDR}"|bc |tr '[A-Z]' '[a-z]'`
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
	local chip_reg='^CONFIG_ROCKCHIP_[R,P][X,V,K][0-9ESX]{2,5}'
	count=`egrep -c ${chip_reg} ${OUTDIR}/.config`
	# Obtain the matching only
	RKCHIP=`egrep -o ${chip_reg} ${OUTDIR}/.config`

	if [ $count -eq 1 ]; then
		RKCHIP=${RKCHIP##*_}
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
	# RK3308/PX30/RK3326 use RSA-PKCS1 V2.1, it's pack magic is "3"
	if [ $RKCHIP = "PX30" -o $RKCHIP = "RK3326" -o $RKCHIP = "RK3308" ]; then
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
	fi

# <*> Fixup PLATFORM_AARCH32 for ARM64 cpu platforms
	if [ $RKCHIP = "RK3308" ]; then
		if grep -q '^CONFIG_ARM64_BOOT_AARCH32=y' ${OUTDIR}/.config ; then
			PLATFORM_AARCH32="AARCH32"
		fi
	fi
}

pack_uboot_image()
{
	local UBOOT_LOAD_ADDR

	UBOOT_LOAD_ADDR=`sed -n "/CONFIG_SYS_TEXT_BASE=/s/CONFIG_SYS_TEXT_BASE=//p" ${OUTDIR}/include/autoconf.mk|tr -d '\r'`
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
	local mode=$1 files ini

	if [ ! -f ${RKBIN}/RKBOOT/${RKCHIP_LOADER}MINIALL.ini ]; then
		echo "pack loader failed! Can't find: ${RKBIN}/RKBOOT/${RKCHIP_LOADER}MINIALL.ini"
		return
	fi

	cd ${RKBIN}

	if [ "${mode}" = 'all' ]; then
		files=`ls ${RKBIN}/RKBOOT/${RKCHIP_LOADER}MINIALL*.ini`
		for ini in $files
		do
			if [ -f "$ini" ]; then
				${RKTOOLS}/boot_merger --replace tools/rk_tools/ ./ $ini
				echo "pack loader okay! Input: $ini"
			fi
		done
	else
		${RKTOOLS}/boot_merger --replace tools/rk_tools/ ./ ${RKBIN}/RKBOOT/${RKCHIP_LOADER}MINIALL.ini
		echo "pack loader okay! Input: ${RKBIN}/RKBOOT/${RKCHIP_LOADER}MINIALL.ini"
	fi

	cd - && mv ${RKBIN}/*_loader_*.bin ./
}

pack_trust_image()
{
	local TOS TOS_TA DARM_BASE TEE_LOAD_ADDR TEE_OFFSET=0x8400000

	# ARM64 uses trust_merger
	if grep -Eq ''^CONFIG_ARM64=y'|'^CONFIG_ARM64_BOOT_AARCH32=y'' ${OUTDIR}/.config ; then
		if [ ! -f ${RKBIN}/RKTRUST/${RKCHIP_TRUST}${PLATFORM_AARCH32}TRUST.ini ]; then
			echo "pack trust failed! Can't find: ${RKBIN}/RKTRUST/${RKCHIP_TRUST}${PLATFORM_AARCH32}TRUST.ini"
			return
		fi

		cd ${RKBIN}
		${RKTOOLS}/trust_merger ${PLATFORM_SHA} ${PLATFORM_RSA} ${PLATFORM_TRUST_IMG_SIZE} --replace tools/rk_tools/ ./ ${RKBIN}/RKTRUST/${RKCHIP_TRUST}${PLATFORM_AARCH32}TRUST.ini

		cd - && mv ${RKBIN}/trust.img ./trust.img
		echo "pack trust okay! Input: ${RKBIN}/RKTRUST/${RKCHIP_TRUST}${PLATFORM_AARCH32}TRUST.ini"
	# ARM uses loaderimage
	else
		if [ ! -f ${RKBIN}/RKTRUST/${RKCHIP_TRUST}TOS.ini ]; then
			echo "pack trust failed! Can't find: ${RKBIN}/RKTRUST/${RKCHIP_TRUST}TOS.ini"
			return
		fi

		# OP-TEE is 132M(0x8400000) offset from DRAM base.
		DARM_BASE=`sed -n "/CONFIG_SYS_SDRAM_BASE=/s/CONFIG_SYS_SDRAM_BASE=//p" ${OUTDIR}/include/autoconf.mk|tr -d '\r'`
		TEE_LOAD_ADDR=$((DARM_BASE+TEE_OFFSET))

		# Convert Dec to Hex
		TEE_LOAD_ADDR=$(echo "obase=16;${TEE_LOAD_ADDR}"|bc)

		# Parse orignal path
		TOS=`sed -n "/TOS=/s/TOS=//p" ${RKBIN}/RKTRUST/${RKCHIP_TRUST}TOS.ini|tr -d '\r'`
		TOS_TA=`sed -n "/TOSTA=/s/TOSTA=//p" ${RKBIN}/RKTRUST/${RKCHIP_TRUST}TOS.ini|tr -d '\r'`

		# replace "./tools/rk_tools/" with "./" to compatible legacy ini content of rkdevelop branch
		TOS=$(echo ${TOS} | sed "s/tools\/rk_tools\//\.\//g")
		TOS_TA=$(echo ${TOS_TA} | sed "s/tools\/rk_tools\//\.\//g")

		if [ x$TOS_TA != x -a x$TOS != x ]; then
			${RKTOOLS}/loaderimage --pack --trustos ${RKBIN}/${TOS} ./trust.img ${TEE_LOAD_ADDR} ${PLATFORM_TRUST_IMG_SIZE}
			${RKTOOLS}/loaderimage --pack --trustos ${RKBIN}/${TOS_TA} ./trust_with_ta.img ${TEE_LOAD_ADDR} ${PLATFORM_TRUST_IMG_SIZE}
			echo "Both trust.img and trust_with_ta.img are ready"
		elif [ $TOS ]; then
			${RKTOOLS}/loaderimage --pack --trustos ${RKBIN}/${TOS} ./trust.img ${TEE_LOAD_ADDR} ${PLATFORM_TRUST_IMG_SIZE}
			echo "trust.img is ready"
		elif [ $TOS_TA ]; then
			${RKTOOLS}/loaderimage --pack --trustos ${RKBIN}/${TOS_TA} ./trust.img ${TEE_LOAD_ADDR} ${PLATFORM_TRUST_IMG_SIZE}
			echo "trust.img with ta is ready"
		else
			echo "Can't find any tee bin"
			exit 1
		fi

		echo "pack trust okay! Input: ${RKBIN}/RKTRUST/${RKCHIP_TRUST}TOS.ini"
	fi
}

finish()
{
	echo
	if [ "$BOARD" = '' ]; then
		echo "Platform ${RKCHIP_LABEL}${PLATFORM_AARCH32} is build OK, with exist .config"
	else
		echo "Platform ${RKCHIP_LABEL}${PLATFORM_AARCH32} is build OK, with new .config(make ${BOARD}_defconfig)"
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
