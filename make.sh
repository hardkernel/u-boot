#!/bin/sh
set -e
BOARD=$1
DIR=${BOARD#*-}
DSTDIR=rockdev/${DIR}
RKCHIP=$(echo $DIR | tr '[a-z]' '[A-Z]')
TOOLCHAIN=arm-linux-gnueabi-
JOB=`sed -n "N;/processor/p" /proc/cpuinfo|wc -l`

prepare()
{
	local dst

	# Check invaid args and help
	if [ "$BOARD" = '--help' -o "$BOARD" = '-h' -o "$BOARD" = '--h' ]; then
		echo
		echo "Usage: ./make.sh board"
		echo "Example:"
		echo "./make.sh evb-rk3399     ---- build for evb-rk3399_defconfig"
		echo "./make.sh firefly-rk3288 ---- build for firefly-rk3288_defconfig"
		exit 1
	elif [ ! -f configs/${BOARD}_defconfig ]; then
		echo "Can't find: configs/${BOARD}_defconfig"
		exit 1
	fi

	# Initialize RKBIN and RKTOOLS
	dst=../rkbin/tools
	if [ -d ${dst} ]; then
		RKBIN=$(cd `dirname ${dst}`; pwd)
		RKTOOLS=${RKBIN}/tools
	else
		echo
		echo "Can't find '../rkbin/' Responsity, please download it before pack image!"
		echo "How to obtain? 3 ways:"
		echo "	1. Login your Rockchip gerrit account: \"Projects\" -> \"List\" -> search \"rk/rkbin\" Responsity"
		echo "	2. Github Responsity: https://github.com/rockchip-linux/rkbin"
		echo "	3. Download full release SDK Responsity"
		exit 1
	fi
}

select_toolchain()
{
	local dst path
	if grep  -q '^CONFIG_ARM64=y' ${DSTDIR}/out/.config ; then
        	TOOLCHAIN=aarch64-linux-gnu-
		dst=../prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin
		if [ -d ${dst} ]; then
			path=$(cd `dirname ${dst}`; pwd)
			TOOLCHAIN=${path}/bin/aarch64-linux-android-
		fi
	else
		dst=../prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/bin
		if [ -d ${dst} ]; then
			path=$(cd `dirname ${dst}`; pwd)
			TOOLCHAIN=${path}/bin/arm-linux-androideabi-
		fi
	fi
	echo toolchain: ${TOOLCHAIN}
}

pack_uboot_image()
{
	local UBOOT_LOAD_ADDR

	UBOOT_LOAD_ADDR=`sed -n "/CONFIG_SYS_TEXT_BASE=/s/CONFIG_SYS_TEXT_BASE=//p" ${DSTDIR}/out/include/autoconf.mk|tr -d '\r'`
	${RKTOOLS}/loaderimage --pack --uboot ${DSTDIR}/out/u-boot.bin uboot.img ${UBOOT_LOAD_ADDR}
}

pack_loader_image()
{
	cd ${RKBIN}
	${RKTOOLS}/boot_merger ${RKBIN}/RKBOOT/${RKCHIP}MINIALL.ini
	cd -
	mv ${RKBIN}/*_loader_*.bin ./
}

pack_trust_image()
{
	local TOS TOS_TA DARM_BASE TEE_LOAD_ADDR TEE_OFFSET=0x8400000

	# ARM64 uses trust_merger
	if grep  -q '^CONFIG_ARM64=y' ${DSTDIR}/out/.config ; then
		cd ${RKBIN}
		${RKTOOLS}/trust_merger ${RKBIN}/RKTRUST/${RKCHIP}TRUST.ini
		cd -
		mv ${RKBIN}/trust.img ./trust.img
	# ARM uses loaderimage
	else
		# OP-TEE is 132M(0x8400000) offset from DRAM base.
		DARM_BASE=`sed -n "/CONFIG_SYS_SDRAM_BASE=/s/CONFIG_SYS_SDRAM_BASE=//p" ${DSTDIR}/out/include/autoconf.mk|tr -d '\r'`
		TEE_LOAD_ADDR=$((DARM_BASE+TEE_OFFSET))

		# Convert Dec to Hex
		TEE_LOAD_ADDR=$(echo "obase=16;${TEE_LOAD_ADDR}"|bc)

		TOS=`sed -n "/TOS=/s/TOS=//p" ${RKBIN}/RKTRUST/${RKCHIP}TOS.ini|tr -d '\r'`
		TOS_TA=`sed -n "/TOSTA=/s/TOSTA=//p" ${RKBIN}/RKTRUST/${RKCHIP}TOS.ini|tr -d '\r'`

		if [ $TOS_TA -a $TOS ]; then
			${RKTOOLS}/loaderimage --pack --trustos ${RKBIN}/${TOS} ./trust.img ${TEE_LOAD_ADDR}
			${RKTOOLS}/loaderimage --pack --trustos ${RKBIN}/${TOS_TA} ./trust_with_ta.img ${TEE_LOAD_ADDR}
			echo "Both trust.img and trust_with_ta.img are ready"
		elif [ $TOS ]; then
			${RKTOOLS}/loaderimage --pack --trustos ${RKBIN}/${TOS} ./trust.img ${TEE_LOAD_ADDR}
			echo "trust.img is ready"
		elif [ $TOS_TA ]; then
			${RKTOOLS}/loaderimage --pack --trustos ${RKBIN}/${TOS_TA} ./trust.img ${TEE_LOAD_ADDR}
			echo "trust.img with ta is ready"
		else
			echo "Can't find any tee bin"
			exit 1
		fi
	fi
}

prepare
echo "make for ${BOARD}_defconfig by -j${JOB}"
make ${BOARD}_defconfig O=${DSTDIR}/out
select_toolchain
make CROSS_COMPILE=${TOOLCHAIN}  all --jobs=${JOB} O=${DSTDIR}/out
pack_loader_image
pack_uboot_image
pack_trust_image

