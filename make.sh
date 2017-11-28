#!/bin/sh
BOARD=$1
DIR=${BOARD#*-}
DSTDIR=rockdev/${DIR}
TOOLCHAIN=arm-linux-gnueabi-
JOB=`sed -n "N;/processor/p" /proc/cpuinfo|wc -l`

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

pack_images()
{
	local sys_text_base dst

	dst=../rkbin/tools
	if [ -d ${dst} ]; then
		path=$(cd `dirname ${dst}`; pwd)
	else
		echo "Can't find '../rkbin/' or '../rkbin/tools/' Responsity, please download it before pack image!"
		exit 1
	fi

	sys_text_base=`sed -n "/CONFIG_SYS_TEXT_BASE=/s/CONFIG_SYS_TEXT_BASE=//p" ${DSTDIR}/out/include/autoconf.mk|tr -d '\r'`
	echo U-Boot entry point address: ${sys_text_base}
	${path}/tools/loaderimage --pack --uboot ${DSTDIR}/out/u-boot.bin uboot.img ${sys_text_base}
}

echo "make for ${BOARD}_defconfig by -j${JOB}"
make ${BOARD}_defconfig O=${DSTDIR}/out
select_toolchain
make CROSS_COMPILE=${TOOLCHAIN}  all --jobs=${JOB} O=${DSTDIR}/out
pack_images
