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
			data = /incbin/("./u-boot-nodtb.bin");
			type = "standalone";
			os = "U-Boot";
			arch = "arm";
			compression = "none";
EOF

OUTDIR=$PWD
DARM_BASE=`sed -n "/CONFIG_SYS_SDRAM_BASE=/s/CONFIG_SYS_SDRAM_BASE=//p" ${OUTDIR}/include/autoconf.mk|tr -d '\r'`
UBOOT_OFFSET=0x00200000
UBOOT_BASE=$((DARM_BASE+UBOOT_OFFSET))
UBOOT_BASE=$(echo "obase=16;${UBOOT_BASE}"|bc)
echo "			load = <0x"$UBOOT_BASE">;"

cat << EOF
		};
		optee@1 {
			description = "OP-TEE";
			data = /incbin/("./tee.bin");
			type = "firmware";
			arch = "arm";
			os = "op-tee";
			compression = "none";
EOF

TEE_OFFSET=0x8400000
TEE_LOAD_ADDR=$((DARM_BASE+TEE_OFFSET))
TEE_LOAD_ADDR=$(echo "obase=16;${TEE_LOAD_ADDR}"|bc)
echo "			load = <0x"$TEE_LOAD_ADDR">;"
echo "			entry = <0x"$TEE_LOAD_ADDR">;"

cat << EOF
		};
		fdt@1 {
			description = "dtb";
			data = /incbin/("./u-boot.dtb");
			type = "flat_dt";
			compression = "none";
		};
	};

	configurations {
		default = "conf@1";
		conf@1 {
			description = "Rockchip armv7 with OP-TEE";
			firmware = "optee@1";
			loadables = "uboot@1";
			fdt = "fdt@1";
		};
	};
};
EOF
