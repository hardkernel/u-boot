#!/bin/bash
#
# Copyright (c) 2020 Fuzhou Rockchip Electronics Co., Ltd
#
# SPDX-License-Identifier: GPL-2.0
#

source scripts/fit-base.sh
fit_process_args $*
fit_rebuild
fit_boot_make_itb
fit_boot_make_img
fit_uboot_make_itb
fit_uboot_make_img

echo
fit_verbose_uboot
fit_verbose_boot
fit_verbose_loader
echo
