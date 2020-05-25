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
		uboot {
			description = "U-Boot";
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
			hash {
				algo = "sha256";
			};
		};
		optee {
			description = "OP-TEE";
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
			hash {
				algo = "sha256";
			};
		};
		fdt {
			description = "U-Boot dtb";
			data = /incbin/("./u-boot.dtb");
			type = "flat_dt";
			compression = "none";
			hash {
				algo = "sha256";
			};
		};
EOF

MCU_OFFSET=$2
if [ "$MCU_OFFSET" != "" ]; then
MCU_LOAD_ADDR=$((DARM_BASE+$MCU_OFFSET))
MCU_LOAD_ADDR=$(echo "obase=16;${MCU_LOAD_ADDR}"|bc)
cat  << EOF
		mcu {
			description = "mcu";
			data = /incbin/("./mcu.bin");
			type = "standalone";
			compression = "none";
EOF
echo "			load = <0x"$MCU_LOAD_ADDR">;"
cat  << EOF
			arch = "riscv";
			hash {
				algo = "sha256";
			};
		};
EOF
fi

cat  << EOF
	};

	configurations {
		default = "conf";
		conf {
			description = "Rockchip armv7 with OP-TEE";
			rollback-index = <0x0>;
			firmware = "optee";
			loadables = "uboot";
			fdt = "fdt";
EOF

if [ "$MCU_OFFSET" != "" ]; then
echo "			standalone = \"mcu\";"
fi

cat  << EOF
			signature {
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
