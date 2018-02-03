#!/bin/sh
set -e
BOARD=$1
RKCHIP=${BOARD##*-}
DSTDIR=rockdev/${RKCHIP}
RKCHIP=$(echo ${RKCHIP} | tr '[a-z]' '[A-Z]')
JOB=`sed -n "N;/processor/p" /proc/cpuinfo|wc -l`

# Declare global rkbin tools and rkbin Responsity path, updated in prepare()
TOOLCHAIN_RKBIN=./
RKBIN=./
# RKTOOL path
RKBIN_TOOLS=../rkbin/tools

# Declare global toolchain path for CROSS_COMPILE, updated in select_toolchain()
TOOLCHAIN_GCC=./
# GCC toolchain
GCC_ARM32=arm-linux-androideabi-
GCC_ARM64=aarch64-linux-android-
TOOLCHAIN_ARM32=../prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/bin
TOOLCHAIN_ARM64=../prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin

prepare()
{
	local absolute_path

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

	# Clean! We assume that ./u-boot.map, u-boot.cfg or u-boot.lds indicates U-Boot project is not clean,
	# maybe git checkout from rkdevelop.
	if [ -f ./u-boot.map -o -f ./u-boot.cfg -o -f ./u-boot.lds ]; then
		make mrproper
		echo "auto \"make mrproper\" done..."
	fi
}

select_toolchain()
{
	local absolute_path

	if grep  -q '^CONFIG_ARM64=y' ${DSTDIR}/out/.config ; then
		if [ -d ${TOOLCHAIN_ARM64} ]; then
			absolute_path=$(cd `dirname ${TOOLCHAIN_ARM64}`; pwd)
			TOOLCHAIN_GCC=${absolute_path}/bin/${GCC_ARM64}
		else
			echo "Can't find toolchain: ${TOOLCHAIN_GCC}"
			exit 1
		fi
	else
		if [ -d ${TOOLCHAIN_ARM32} ]; then
			absolute_path=$(cd `dirname ${TOOLCHAIN_ARM32}`; pwd)
			TOOLCHAIN_GCC=${absolute_path}/bin/${GCC_ARM32}
		else
			echo "Can't find toolchain: ${TOOLCHAIN_GCC}"
			exit 1
		fi
	fi

	echo "toolchain: ${TOOLCHAIN_GCC}"
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

	UBOOT_LOAD_ADDR=`sed -n "/CONFIG_SYS_TEXT_BASE=/s/CONFIG_SYS_TEXT_BASE=//p" ${DSTDIR}/out/include/autoconf.mk|tr -d '\r'`
	${TOOLCHAIN_RKBIN}/loaderimage --pack --uboot ${DSTDIR}/out/u-boot.bin uboot.img ${UBOOT_LOAD_ADDR}
	echo "pack uboot okay! Input: ${DSTDIR}/out/u-boot.bin"
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
	if grep  -q '^CONFIG_ARM64=y' ${DSTDIR}/out/.config ; then
		if [ ! -f ${RKBIN}/RKTRUST/${RKCHIP}TRUST.ini ]; then
			echo "pack trust failed! Can't find: ${RKBIN}/RKRUST/${RKCHIP}TRUST.ini"
			return
		fi

		cd ${RKBIN}
		${TOOLCHAIN_RKBIN}/trust_merger --replace tools/rk_tools/ ./ ${RKBIN}/RKTRUST/${RKCHIP}TRUST.ini
		cd -
		mv ${RKBIN}/trust.img ./trust.img
		echo "pack trust okay! Input: ${RKBIN}/RKRUST/${RKCHIP}TRUST.ini"
	# ARM uses loaderimage
	else
		if [ ! -f ${RKBIN}/RKTRUST/${RKCHIP}TOS.ini ]; then
			echo "pack trust failed! Can't find: ${RKBIN}/RKTRUST/${RKCHIP}TOS.ini"
			return
		fi

		# OP-TEE is 132M(0x8400000) offset from DRAM base.
		DARM_BASE=`sed -n "/CONFIG_SYS_SDRAM_BASE=/s/CONFIG_SYS_SDRAM_BASE=//p" ${DSTDIR}/out/include/autoconf.mk|tr -d '\r'`
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
make ${BOARD}_defconfig O=${DSTDIR}/out
select_toolchain
make CROSS_COMPILE=${TOOLCHAIN_GCC}  all --jobs=${JOB} O=${DSTDIR}/out
fixup_chip_name
pack_uboot_image
pack_loader_image
pack_trust_image
