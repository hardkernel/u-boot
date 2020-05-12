#!/bin/bash

cat << EOF
/*
 * Copyright (C) 2017 Rockchip Electronic Co.,Ltd
 *
 * Simple U-boot fit source file containing U-Boot, dtb and optee
 */

/dts-v1/;

/ {
	description = "Simple image with OP-TEE support";
	#address-cells = <1>;

	images {
		uboot@1 {
			description = "U-Boot";
			image = "u-boot-nodtb.bin";
			data = /incbin/("./u-boot-nodtb.bin");
			type = "standalone";
			os = "U-Boot";
			arch = "arm";
			compression = "none";
EOF

OUTDIR=$PWD
DARM_BASE=`sed -n "/CONFIG_SYS_SDRAM_BASE=/s/CONFIG_SYS_SDRAM_BASE=//p" ${OUTDIR}/include/autoconf.mk|tr -d '\r'`
UBOOT_BASE=`sed -n "/CONFIG_SYS_TEXT_BASE=/s/CONFIG_SYS_TEXT_BASE=//p" ${OUTDIR}/include/autoconf.mk|tr -d '\r'`
echo "			load = <"$UBOOT_BASE">;"
cat << EOF
			hash@1 {
				algo = "sha256";
			};
		};
		optee@1 {
			description = "OP-TEE";
			image = "tee.bin";
			data = /incbin/("./tee.bin");
			type = "firmware";
			arch = "arm";
			os = "op-tee";
			compression = "none";
EOF

if [ -z "$1" -o ! -z "$(echo $1 | sed 's/[x, X, 0-9, a-f, A-F]//g')" ]; then
	TEE_OFFSET=0x8400000
else
	TEE_OFFSET=$1
fi
TEE_LOAD_ADDR=$((DARM_BASE+TEE_OFFSET))
TEE_LOAD_ADDR=$(echo "obase=16;${TEE_LOAD_ADDR}"|bc)
echo "			load = <0x"$TEE_LOAD_ADDR">;"
echo "			entry = <0x"$TEE_LOAD_ADDR">;"
cat << EOF
			hash@1 {
				algo = "sha256";
			};
		};
		fdt@1 {
			description = "U-Boot dtb";
			image = "u-boot.dtb";
			data = /incbin/("./u-boot.dtb");
			type = "flat_dt";
			compression = "none";
			hash@1 {
				algo = "sha256";
			};
		};
EOF

MCU_OFFSET=$2
if [ "$MCU_OFFSET" != "" ]; then
MCU_LOAD_ADDR=$((DARM_BASE+$MCU_OFFSET))
MCU_LOAD_ADDR=$(echo "obase=16;${MCU_LOAD_ADDR}"|bc)
cat  << EOF
		mcu@1 {
			description = "mcu";
			image="mcu.bin";
			data = /incbin/("./mcu.bin");
			type = "standalone";
			compression = "none";
EOF
echo "			load = <0x"$MCU_LOAD_ADDR">;"
cat  << EOF
			arch = "riscv";
			hash@1 {
				algo = "sha256";
			};
		};
EOF
fi

cat  << EOF
	};

	configurations {
		default = "conf@1";
		conf@1 {
			description = "Rockchip armv7 with OP-TEE";
			rollback-index = <0x0>;
			firmware = "optee@1";
			loadables = "uboot@1";
			fdt = "fdt@1";
EOF

if [ "$MCU_OFFSET" != "" ]; then
echo "			standalone = \"mcu@1\";"
fi

cat  << EOF
			signature@1 {
				algo = "sha256,rsa2048";
				key-name-hint = "dev";
EOF

if [ "$MCU_OFFSET" != "" ]; then
echo "			        sign-images = \"fdt\", \"firmware\", \"loadables\", \"standalone\";"
else
echo "			        sign-images = \"fdt\", \"firmware\", \"loadables\";"
fi

cat  << EOF
			};
		};
	};
};
EOF
