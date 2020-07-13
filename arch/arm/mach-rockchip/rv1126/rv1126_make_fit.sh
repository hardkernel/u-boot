#!/bin/bash
#
# Copyright (C) 2020 Rockchip Electronics Co., Ltd
#
# SPDX-License-Identifier:     GPL-2.0+
#

# Process args and auto set variables
source ./${srctree}/arch/arm/mach-rockchip/make_fit_args.sh

if [ "${COMPRESSION}" == "gzip" ]; then
	gzip -k -f -9 ${srctree}/u-boot-nodtb.bin
	gzip -k -f -9 ${srctree}/tee.bin
	SUFFIX=".gz"
else
	COMPRESSION="none"
	SUFFIX=
fi

# mcu
if [ ! -z "${MCU_LOAD_ADDR}" ]; then
	if [ "${COMPRESSION}" == "gzip" ]; then
		gzip -k -f -9 ${srctree}/mcu.bin
	fi
fi

# .its file generation
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
			type = "standalone";
			os = "U-Boot";
			arch = "arm";
EOF

echo "			data = /incbin/(\"./u-boot-nodtb.bin${SUFFIX}\");"
echo "			compression = \"${COMPRESSION}\";"
echo "			load = <"${UBOOT_LOAD_ADDR}">;"

cat << EOF
			hash {
				algo = "sha256";
			};
		};
		optee {
			description = "OP-TEE";
			type = "firmware";
			arch = "arm";
			os = "op-tee";
EOF

echo "			load = <0x"${TEE_LOAD_ADDR}">;"
echo "			entry = <0x"${TEE_LOAD_ADDR}">;"
echo "			data = /incbin/(\"./tee.bin${SUFFIX}\");"
echo "			compression = \"${COMPRESSION}\";"

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

if [ ! -z "${MCU_LOAD_ADDR}" ]; then
cat  << EOF
		mcu {
			description = "mcu";
			type = "standalone";
			arch = "riscv";
EOF

echo "			data = /incbin/(\"./mcu.bin${SUFFIX}\");"
echo "			compression = \"${COMPRESSION}\";"
echo "			load = <0x"${MCU_LOAD_ADDR}">;"

cat  << EOF
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

if [ ! -z "${MCU_LOAD_ADDR}" ]; then
echo "			standalone = \"mcu\";"
fi

cat  << EOF
			signature {
				algo = "sha256,rsa2048";
				padding = "pss";
				key-name-hint = "dev";
EOF

if [ ! -z "${MCU_LOAD_ADDR}" ]; then
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
