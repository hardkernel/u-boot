#!/bin/bash

make odroidn1_defconfig

make

tools/rk_tools/bin/loaderimage --pack --uboot ./u-boot-dtb.bin uboot.img

tools/mkimage -n rk3399 -T rksd -d tools/rk_tools/bin/rk33/rk3399_ddr_800MHz_v1.08.bin idbloader.img
cat tools/rk_tools/bin/rk33/rk3399_miniloader_v1.06.bin >> idbloader.img

cp tools/rk_tools/bin/rk33/rk3399_loader_v1.08.106.bin sd_fuse

tools/rk_tools/bin/trust_merger tools/rk_tools/trust.ini

cp idbloader.img sd_fuse
cp uboot.img sd_fuse
cp trust.img sd_fuse

