#!/bin/sh
set -e
BOARD=$1
SUBCMD=$2
RKCHIP=${BOARD##*-}
RKCHIP=$(echo ${RKCHIP} | tr '[a-z]' '[A-Z]')
JOB=`sed -n "N;/processor/p" /proc/cpuinfo|wc -l`

# Declare global default output dir and cmd, update in prepare()
OUTDIR=.
OUTOPT=

# Declare global rkbin tools and rkbin Responsity path, updated in prepare()
TOOLCHAIN_RKBIN=./
RKBIN=./
# RKTOOL path
RKBIN_TOOLS=../rkbin/tools

# Declare global toolchain path for CROSS_COMPILE, updated in select_toolchain()
TOOLCHAIN_GCC=./
TOOLCHAIN_OBJDUMP=./
# GCC toolchain
GCC_ARM32=arm-linux-gnueabihf-
GCC_ARM64=aarch64-linux-gnu-
TOOLCHAIN_ARM32=../prebuilts/gcc/linux-x86/arm/gcc-linaro-6.3.1-2017.05-x86_64_arm-linux-gnueabihf/bin
TOOLCHAIN_ARM64=../prebuilts/gcc/linux-x86/aarch64/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu/bin
# OBJDMP
OBJ_ARM32=arm-linux-gnueabihf-objdump
OBJ_ARM64=aarch64-linux-gnu-objdump

prepare()
{
	local absolute_path cmd

	# Check invaid args and help
	if [ "$BOARD" = '--help' -o "$BOARD" = '-h' -o "$BOARD" = '--h' -o "$BOARD" = '' ]; then
		echo
		echo "Usage: ./make.sh [board]"
		echo "Example:"
		echo "./make.sh evb-rk3399     ---- build for evb-rk3399_defconfig"
		echo "./make.sh firefly-rk3288 ---- build for firefly-rk3288_defconfig"
		exit 1
	elif [ ! -f configs/${BOARD}_defconfig ]; then
		echo "Can't find: configs/${BOARD}_defconfig"
		exit 1
	fi

	# Initialize RKBIN and TOOLCHAIN_RKBIN
	if [ -d ${RKBIN_TOOLS} ]; then
		absolute_path=$(cd `dirname ${RKBIN_TOOLS}`; pwd)
		RKBIN=${absolute_path}
		TOOLCHAIN_RKBIN=${absolute_path}/tools
	else
		echo
		echo "Can't find '../rkbin/' Responsity, please download it before pack image!"
		echo "How to obtain? 3 ways:"
		echo "	1. Login your Rockchip gerrit account: \"Projects\" -> \"List\" -> search \"rk/rkbin\" Responsity"
		echo "	2. Github Responsity: https://github.com/rockchip-linux/rkbin"
		echo "	3. Download full release SDK Responsity"
		exit 1
	fi

	# Assign output directory
	cmd=${SUBCMD%=*}
	if [ "${cmd}" = 'O' ]; then
		OUTDIR=${SUBCMD#*=}
		OUTOPT=O=${OUTDIR}
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
		else
			echo "Can't find toolchain: ${TOOLCHAIN_ARM64}"
			exit 1
		fi
	else
		if [ -d ${TOOLCHAIN_ARM32} ]; then
			absolute_path=$(cd `dirname ${TOOLCHAIN_ARM32}`; pwd)
			TOOLCHAIN_GCC=${absolute_path}/bin/${GCC_ARM32}
			TOOLCHAIN_OBJDUMP=${absolute_path}/bin/${OBJ_ARM32}
		else
			echo "Can't find toolchain: ${TOOLCHAIN_ARM32}"
			exit 1
		fi
	fi

	echo "toolchain: ${TOOLCHAIN_GCC}"
}

sub_commands()
{
	local elf=${SUBCMD%-*} opt=${SUBCMD#*-}

	if [ "$elf" = 'elf' ]; then
		if [ ! -f ${OUTDIR}/u-boot ]; then
			echo "Can't find elf file: ${OUTDIR}/u-boot"
			exit 1
		else
			# default 'elf' without option, use '-D'
			if [ "${elf}" = 'elf' -a "${opt}" = 'elf' ]; then
				opt=D
			fi

			${TOOLCHAIN_OBJDUMP} -${opt} ${OUTDIR}/u-boot | less
			exit 0
		fi
	elif [ "$SUBCMD" = 'trust' ]; then
		pack_trust_image
		exit 0
	elif [ "$SUBCMD" = 'loader' ]; then
		pack_loader_image
		exit 0
	fi
}

fixup_chip_name()
{
	if [ "$RKCHIP" = 'RK3228' -o "$RKCHIP" = 'RK3229' ]; then
		RKCHIP=RK322X
	fi
}

pack_uboot_image()
{
	local UBOOT_LOAD_ADDR

	UBOOT_LOAD_ADDR=`sed -n "/CONFIG_SYS_TEXT_BASE=/s/CONFIG_SYS_TEXT_BASE=//p" ${OUTDIR}/include/autoconf.mk|tr -d '\r'`
	${TOOLCHAIN_RKBIN}/loaderimage --pack --uboot ${OUTDIR}/u-boot.bin uboot.img ${UBOOT_LOAD_ADDR}
	rm u-boot.img u-boot-dtb.img
	echo "pack uboot okay! Input: ${OUTDIR}/u-boot.bin"
}

pack_loader_image()
{
	if [ ! -f ${RKBIN}/RKBOOT/${RKCHIP}MINIALL.ini ]; then
		echo "pack loader failed! Can't find: ${RKBIN}/RKBOOT/${RKCHIP}MINIALL.ini"
		return
	fi

	cd ${RKBIN}
	${TOOLCHAIN_RKBIN}/boot_merger --replace tools/rk_tools/ ./ ${RKBIN}/RKBOOT/${RKCHIP}MINIALL.ini
	cd -
	mv ${RKBIN}/*_loader_*.bin ./
	echo "pack loader okay! Input: ${RKBIN}/RKBOOT/${RKCHIP}MINIALL.ini"
}

pack_trust_image()
{
	local TOS TOS_TA DARM_BASE TEE_LOAD_ADDR TEE_OFFSET=0x8400000

	# ARM64 uses trust_merger
	if grep  -q '^CONFIG_ARM64=y' ${OUTDIR}/.config ; then
		if [ ! -f ${RKBIN}/RKTRUST/${RKCHIP}TRUST.ini ]; then
			echo "pack trust failed! Can't find: ${RKBIN}/RKTRUST/${RKCHIP}TRUST.ini"
			return
		fi

		cd ${RKBIN}
		${TOOLCHAIN_RKBIN}/trust_merger --replace tools/rk_tools/ ./ ${RKBIN}/RKTRUST/${RKCHIP}TRUST.ini
		cd -
		mv ${RKBIN}/trust.img ./trust.img
		echo "pack trust okay! Input: ${RKBIN}/RKTRUST/${RKCHIP}TRUST.ini"
	# ARM uses loaderimage
	else
		if [ ! -f ${RKBIN}/RKTRUST/${RKCHIP}TOS.ini ]; then
			echo "pack trust failed! Can't find: ${RKBIN}/RKTRUST/${RKCHIP}TOS.ini"
			return
		fi

		# OP-TEE is 132M(0x8400000) offset from DRAM base.
		DARM_BASE=`sed -n "/CONFIG_SYS_SDRAM_BASE=/s/CONFIG_SYS_SDRAM_BASE=//p" ${OUTDIR}/include/autoconf.mk|tr -d '\r'`
		TEE_LOAD_ADDR=$((DARM_BASE+TEE_OFFSET))

		# Convert Dec to Hex
		TEE_LOAD_ADDR=$(echo "obase=16;${TEE_LOAD_ADDR}"|bc)

		# Parse orignal path
		TOS=`sed -n "/TOS=/s/TOS=//p" ${RKBIN}/RKTRUST/${RKCHIP}TOS.ini|tr -d '\r'`
		TOS_TA=`sed -n "/TOSTA=/s/TOSTA=//p" ${RKBIN}/RKTRUST/${RKCHIP}TOS.ini|tr -d '\r'`

		# replace "./tools/rk_tools/" with "./" to compatible legacy ini content of rkdevelop branch
		TOS=$(echo ${TOS} | sed "s/tools\/rk_tools\//\.\//g")
		TOS_TA=$(echo ${TOS_TA} | sed "s/tools\/rk_tools\//\.\//g")

		if [ $TOS_TA -a $TOS ]; then
			${TOOLCHAIN_RKBIN}/loaderimage --pack --trustos ${RKBIN}/${TOS} ./trust.img ${TEE_LOAD_ADDR}
			${TOOLCHAIN_RKBIN}/loaderimage --pack --trustos ${RKBIN}/${TOS_TA} ./trust_with_ta.img ${TEE_LOAD_ADDR}
			echo "Both trust.img and trust_with_ta.img are ready"
		elif [ $TOS ]; then
			${TOOLCHAIN_RKBIN}/loaderimage --pack --trustos ${RKBIN}/${TOS} ./trust.img ${TEE_LOAD_ADDR}
			echo "trust.img is ready"
		elif [ $TOS_TA ]; then
			${TOOLCHAIN_RKBIN}/loaderimage --pack --trustos ${RKBIN}/${TOS_TA} ./trust.img ${TEE_LOAD_ADDR}
			echo "trust.img with ta is ready"
		else
			echo "Can't find any tee bin"
			exit 1
		fi

		echo "pack trust okay! Input: ${RKBIN}/RKTRUST/${RKCHIP}TOS.ini"
	fi
}

prepare
echo "make for ${BOARD}_defconfig by -j${JOB}"
make ${BOARD}_defconfig ${OUTOPT}
select_toolchain
fixup_chip_name
sub_commands
make CROSS_COMPILE=${TOOLCHAIN_GCC}  all --jobs=${JOB} ${OUTOPT}
pack_uboot_image
pack_loader_image
pack_trust_image
