# !/bin/bash
set -e

SUFFIX="lzma"
ALGO="lzma"
IMG="u-boot.bin"
IMG_SIZE=`wc -c ${IMG} | awk '{ printf("0x%x", $1); }'`
IMG_ADDR=`sed -n "/CONFIG_SYS_TEXT_BASE=/s/CONFIG_SYS_TEXT_BASE=//p" include/autoconf.mk|tr -d '\r'`
${ALGO} -k -f -9 ${IMG}
./tools/mkimage -A arm -O u-boot -T standalone -C ${ALGO} -a ${IMG_ADDR} -e ${IMG_SIZE} -d ${IMG}.${SUFFIX} ${IMG}.${SUFFIX}.uImage
cat spl/u-boot-spl-pad.bin >> spl/u-boot-spl-nodtb.bin
cat ${IMG}.${SUFFIX}.uImage >> spl/u-boot-spl-nodtb.bin
cp -f spl/u-boot-spl-nodtb.bin spl/u-boot-spl.bin
./make.sh spl


