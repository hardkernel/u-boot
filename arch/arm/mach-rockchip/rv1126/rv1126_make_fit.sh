#!/bin/bash
#
# Copyright (C) 2020 Rockchip Electronics Co., Ltd
#
# SPDX-License-Identifier:     GPL-2.0+
#

# Process args and auto set variables
source ./${srctree}/arch/arm/mach-rockchip/make_fit_args.sh

# compression
rm -f ${srctree}/mcu.digest ${srctree}/u-boot-nodtb.digest ${srctree}/tee.digest
rm -f ${srctree}/u-boot-nodtb.bin.gz ${srctree}/tee.bin.gz ${srctree}/mcu.bin.gz

if [ "${COMPRESSION}" == "gzip" ]; then
	openssl dgst -sha256 -binary -out ${srctree}/u-boot-nodtb.digest ${srctree}/u-boot-nodtb.bin
	openssl dgst -sha256 -binary -out ${srctree}/tee.digest ${srctree}/tee.bin
	gzip -k -f -9 ${srctree}/tee.bin
	UBOOT_SZ=`ls -l u-boot-nodtb.bin | awk '{ print $5 }'`
	if [ ${UBOOT_SZ} -gt 0 ]; then
		gzip -k -f -9 ${srctree}/u-boot-nodtb.bin
	else
		touch ${srctree}/u-boot-nodtb.bin.gz
	fi
	if [ ! -z "${MCU_LOAD_ADDR}" ]; then
		openssl dgst -sha256 -binary -out ${srctree}/mcu.digest ${srctree}/mcu.bin
		gzip -k -f -9 ${srctree}/mcu.bin
	fi

	SUFFIX=".gz"
else
	COMPRESSION="none"
	SUFFIX=
fi

# u-boot and tee
UBOOT_BODY="			data = /incbin/(\"./u-boot-nodtb.bin${SUFFIX}\");
			compression = \"${COMPRESSION}\";
			load = <"${UBOOT_LOAD_ADDR}">;"

TEE_BODY="			data = /incbin/(\"./tee.bin${SUFFIX}\");
			compression = \"${COMPRESSION}\";
			load = <0x"${TEE_LOAD_ADDR}">;
			entry = <0x"${TEE_LOAD_ADDR}">;"

# digest
if [ "${COMPRESSION}" != "none" ]; then
UBOOT_DIGEST="			digest {
				value = /incbin/(\"./u-boot-nodtb.digest\");
				algo = \"sha256\";
			};"

TEE_DIGEST="			digest {
				value = /incbin/(\"./tee.digest\");
				algo = \"sha256\";
			};"

MCU_DIGEST="			digest {
				value = /incbin/(\"./mcu.digest\");
				algo = \"sha256\";
			};"
fi

# mcu
if [ ! -z "${MCU_LOAD_ADDR}" ]; then
MCU_BODY="		mcu {
			description = \"mcu\";
			type = \"standalone\";
			arch = \"riscv\";
			data = /incbin/(\"./mcu.bin${SUFFIX}\");
			compression = \"${COMPRESSION}\";
			load = <0x"${MCU_LOAD_ADDR}">;
			hash {
				algo = \"sha256\";
			};
${MCU_DIGEST}
		};"

MCU_STANDALONE="			standalone = \"mcu\";"
fi

# /configurations/conf
if [ ! -z "${MCU_LOAD_ADDR}" ]; then
SIGN_IMAGES="			        sign-images = \"fdt\", \"firmware\", \"loadables\", \"standalone\";"
else
SIGN_IMAGES="			        sign-images = \"fdt\", \"firmware\", \"loadables\";"
fi

########################################################################################################

cat << EOF
/*
 * Copyright (C) 2020 Rockchip Electronic Co.,Ltd
 *
 * Simple U-boot fit source file containing U-Boot, dtb and optee
 */

/dts-v1/;

/ {
	description = "FIT Image with U-Boot/OP-TEE/MCU";
	#address-cells = <1>;

	images {
		uboot {
			description = "U-Boot";
			type = "standalone";
			os = "U-Boot";
			arch = "arm";
EOF
echo "${UBOOT_BODY}"
echo "${UBOOT_DIGEST}"
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
echo "${TEE_BODY}"
echo "${TEE_DIGEST}"
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
echo "${MCU_BODY}"
cat  << EOF
	};

	configurations {
		default = "conf";
		conf {
			description = "RV1126 U-Boot FIT";
			rollback-index = <0x0>;
			firmware = "optee";
			loadables = "uboot";
			fdt = "fdt";
EOF
echo "${MCU_STANDALONE}"
cat  << EOF
			signature {
				algo = "sha256,rsa2048";
				padding = "pss";
				key-name-hint = "dev";
EOF
echo "${SIGN_IMAGES}"
cat  << EOF
			};
		};
	};
};
EOF
