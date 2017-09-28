#!/bin/sh

#
# make idbloader
#

tools/mkimage -n rk3399 -T rksd -d tools/rk_tools/bin/rk33/rk3399_ddr_800MHz_v1.08.bin idbloader.img
cat tools/rk_tools/bin/rk33/rk3399_miniloader_v1.06.bin >> idbloader.img
mv idbloader.img ./sd_fuse/
