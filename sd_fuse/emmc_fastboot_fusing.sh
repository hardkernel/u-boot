#
# Copyright (C) 2011 Samsung Electronics Co., Ltd.
#              http://www.samsung.com/
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
#
####################################
echo "BL1 fusing"
sudo fastboot flash fwbl1 bl1.HardKernel
echo "BL2 fusing"
sudo fastboot flash bl2 bl2.HardKernel
echo "u-boot fusing"
sudo fastboot flash bootloader ../u-boot.bin
echo "TrustZone S/W fusing"
sudo fastboot flash tzsw tzsw.HardKernel
echo "U-boot image is fused successfully."
