# !/bin/bash
set -e

COMPRESS="lzma"
ADDR=`sed -n "/CONFIG_SYS_TEXT_BASE=/s/CONFIG_SYS_TEXT_BASE=//p" include/autoconf.mk|tr -d '\r'`

./tools/mkimage -A arm -O u-boot -T standalone -C ${COMPRESS} -a ${ADDR} -e ${ADDR} -d u-boot.bin.${COMPRESS} u-boot.bin.${COMPRESS}.uImage
cp -f spl/u-boot-spl-nodtb.bin u-boot.bin.decomp
if ! grep -q '^CONFIG_SPL_SEPARATE_BSS=y' .config ; then
	cat spl/u-boot-spl-pad.bin >> u-boot.bin.decomp
fi
cat u-boot.bin.${COMPRESS}.uImage >> u-boot.bin.decomp
cp -f u-boot.bin.decomp spl/u-boot-spl.bin
./make.sh spl


