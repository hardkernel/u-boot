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
echo "make for ${BOARD}_defconfig by -j${JOB}"
make ${BOARD}_defconfig O=${DSTDIR}/out
select_toolchain
make CROSS_COMPILE=${TOOLCHAIN}  all --jobs=${JOB} O=${DSTDIR}/out
