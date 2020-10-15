#!/bin/bash
#
# Copyright (c) 2019 Hardkernel Co., Ltd
#
# SPDX-License-Identifier: GPL-2.0
#

PWD=$(pwd)
IMAGES=./tools/images/hardkernel
OUT=./sd_fuse
MNT=${PWD}/sd_fuse/mnt
BOARD=$1

if [ -z $1 ]; then
        echo "Usage ./build_recovery.sh <board_name>"
        exit 1
fi

pack_spi_full_image()
{
	dd if=/dev/zero of=${OUT}/spi_recovery.img bs=512 count=12392 conv=fsync,notrunc

	dd if=${OUT}/rk3326_header_miniloader_spiboot.img of=${OUT}/spi_recovery.img bs=512 seek=0 count=2048 conv=fsync,notrunc
	dd if=${OUT}/uboot_spi.img of=${OUT}/spi_recovery.img bs=512 seek=2048 count=2048 conv=fsync,notrunc
	dd if=${OUT}/trust_spi.img of=${OUT}/spi_recovery.img bs=512 seek=4096 count=4096 conv=fsync,notrunc

if [ ${BOARD} = "odroidgo3" ]; then
	dd if=./arch/arm/dts/odroidgo3-kernel.dtb of=${OUT}/spi_recovery.img bs=512 seek=8192 count=200 conv=fsync,notrunc
else
	dd if=./arch/arm/dts/odroidgo2-kernel-v11.dtb of=${OUT}/spi_recovery.img bs=512 seek=8192 count=200 conv=fsync,notrunc
fi
	gzip -k -f ${IMAGES}/*.bmp
if [ ${BOARD} = "odroidgo3" ]; then
	dd if=${IMAGES}/logo_hardkernel_b.bmp.gz of=${OUT}/spi_recovery.img bs=512 seek=8392 conv=fsync,notrunc
	dd if=${IMAGES}/low_battery_b.bmp.gz of=${OUT}/spi_recovery.img bs=512 seek=8792 conv=fsync,notrunc
	dd if=${IMAGES}/recovery_b.bmp.gz of=${OUT}/spi_recovery.img bs=512 seek=9192 conv=fsync,notrunc
	dd if=${IMAGES}/system_error_b.bmp.gz of=${OUT}/spi_recovery.img bs=512 seek=9592 conv=fsync,notrunc
	dd if=${IMAGES}/no_sdcard_b.bmp.gz of=${OUT}/spi_recovery.img bs=512 seek=9992 conv=fsync,notrunc

	dd if=${IMAGES}/battery_0_b.bmp.gz of=${OUT}/spi_recovery.img bs=512 seek=10392 conv=fsync,notrunc
	dd if=${IMAGES}/battery_1_b.bmp.gz of=${OUT}/spi_recovery.img bs=512 seek=10792 conv=fsync,notrunc
	dd if=${IMAGES}/battery_2_b.bmp.gz of=${OUT}/spi_recovery.img bs=512 seek=11192 conv=fsync,notrunc
	dd if=${IMAGES}/battery_3_b.bmp.gz of=${OUT}/spi_recovery.img bs=512 seek=11592 conv=fsync,notrunc
	dd if=${IMAGES}/battery_fail_b.bmp.gz of=${OUT}/spi_recovery.img bs=512 seek=11992 conv=fsync,notrunc
else
	dd if=${IMAGES}/logo_hardkernel.bmp.gz of=${OUT}/spi_recovery.img bs=512 seek=8392 conv=fsync,notrunc
	dd if=${IMAGES}/low_battery.bmp.gz of=${OUT}/spi_recovery.img bs=512 seek=8792 conv=fsync,notrunc
	dd if=${IMAGES}/recovery.bmp.gz of=${OUT}/spi_recovery.img bs=512 seek=9192 conv=fsync,notrunc
	dd if=${IMAGES}/system_error.bmp.gz of=${OUT}/spi_recovery.img bs=512 seek=9592 conv=fsync,notrunc
	dd if=${IMAGES}/no_sdcard.bmp.gz of=${OUT}/spi_recovery.img bs=512 seek=9992 conv=fsync,notrunc

	dd if=${IMAGES}/battery_0.bmp.gz of=${OUT}/spi_recovery.img bs=512 seek=10392 conv=fsync,notrunc
	dd if=${IMAGES}/battery_1.bmp.gz of=${OUT}/spi_recovery.img bs=512 seek=10792 conv=fsync,notrunc
	dd if=${IMAGES}/battery_2.bmp.gz of=${OUT}/spi_recovery.img bs=512 seek=11192 conv=fsync,notrunc
	dd if=${IMAGES}/battery_3.bmp.gz of=${OUT}/spi_recovery.img bs=512 seek=11592 conv=fsync,notrunc
	dd if=${IMAGES}/battery_fail.bmp.gz of=${OUT}/spi_recovery.img bs=512 seek=11992 conv=fsync,notrunc
fi
	rm ${IMAGES}/*.bmp.gz

	md5sum ${OUT}/spi_recovery.img > ${OUT}/spi_recovery.img.md5sum
}

pack_recovery_sdcard_img()
{
	dd if=/dev/zero of=${OUT}/vfat.fs bs=1M count=32 conv=fsync
	mkfs.vfat ${OUT}/vfat.fs

	if [ ! -d "$MNT" ]; then
		mkdir -p "${MNT}"
	fi

	sudo mount ${OUT}/vfat.fs ${MNT}
	sudo cp ${OUT}/spi_recovery.img* ${MNT}
if [ ${BOARD} = "odroidgo3" ]; then
	sudo cp ${IMAGES}/recovery_b.bmp ${MNT}/recovery.bmp
	sudo cp ${IMAGES}/system_error_b.bmp ${MNT}/system_error.bmp
	sudo cp ${IMAGES}/no_sdcard_b.bmp ${MNT}/no_sdcard.bmp
	sudo cp ${IMAGES}/low_battery_b.bmp ${MNT}/low_battery.bmp
	sudo cp ./arch/arm/dts/odroidgo3-kernel.dtb ${MNT}/rk3326-odroidgo3-linux.dtb
else
	sudo cp ${IMAGES}/recovery.bmp ${MNT}
	sudo cp ${IMAGES}/system_error.bmp ${MNT}
	sudo cp ${IMAGES}/no_sdcard.bmp ${MNT}
	sudo cp ${IMAGES}/low_battery.bmp ${MNT}
	sudo cp ./arch/arm/dts/odroidgo2-kernel.dtb ${MNT}/rk3326-odroidgo2-linux.dtb
	sudo cp ./arch/arm/dts/odroidgo2-kernel-v11.dtb ${MNT}/rk3326-odroidgo2-linux-v11.dtb
fi
	sync
	sudo umount ${MNT}

	dd if=/dev/zero of=${OUT}/sdcard_recovery.img conv=fsync bs=512 count=64
	dd if=${OUT}/idbloader.img of=${OUT}/sdcard_recovery.img conv=fsync bs=512 seek=64
	dd if=${OUT}/uboot.img of=${OUT}/sdcard_recovery.img conv=fsync bs=512 seek=16384
	dd if=${OUT}/trust.img of=${OUT}/sdcard_recovery.img conv=fsync bs=512 seek=24576
	dd if=${OUT}/vfat.fs of=${OUT}/sdcard_recovery.img bs=512 seek=32768

	fdisk -u ${OUT}/sdcard_recovery.img << EOF
n
p
1
32768
98303
t
c
w
EOF

	sync
}

finish()
{
	rm ${OUT}/spi_recovery.img*
	rm ${OUT}/vfat.fs

	echo "Build Recovery Image Done!!!"
}

pack_spi_full_image
pack_recovery_sdcard_img
finish
