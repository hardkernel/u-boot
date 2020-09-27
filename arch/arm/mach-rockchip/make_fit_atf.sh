#!/bin/bash
#
# Copyright (C) 2020 Rockchip Electronics Co., Ltd
#
# SPDX-License-Identifier:     GPL-2.0+
#

# Process args and auto set variables
source ./${srctree}/arch/arm/mach-rockchip/make_fit_args.sh

rm -f ${srctree}/*.digest ${srctree}/*.bin.gz ${srctree}/bl31_0x*.bin
${srctree}/arch/arm/mach-rockchip/decode_bl31.py

if [ "${COMPRESSION}" == "gzip" ]; then
	SUFFIX=".gz"
else
	COMPRESSION="none"
	SUFFIX=
fi

function generate_uboot_node()
{
	echo "		uboot {
			description = \"U-Boot(64-bit)\";
			data = /incbin/(\"./u-boot-nodtb.bin${SUFFIX}\");
			type = \"standalone\";
			arch = \"arm64\";
			os = \"U-Boot\";
			compression = \"${COMPRESSION}\";
			load = <"${UBOOT_LOAD_ADDR}">;
			hash {
				algo = \"sha256\";
			};"
	if [ "${COMPRESSION}" == "gzip" ]; then
		echo "			digest {
				value = /incbin/(\"./u-boot-nodtb.bin.digest\");
				algo = \"sha256\";
			};"
		openssl dgst -sha256 -binary -out u-boot-nodtb.bin.digest u-boot-nodtb.bin
		UBOOT_SZ=`ls -l u-boot-nodtb.bin | awk '{ print $5 }'`
		if [ ${UBOOT_SZ} -gt 0 ]; then
			gzip -k -f -9 ${srctree}/u-boot-nodtb.bin
		else
			touch ${srctree}/u-boot-nodtb.bin.gz
		fi
	fi
	echo "		};"
}

function generate_kfdt_node()
{
	if [ -f ${srctree}/dts/kern.dtb ]; then
	echo "		kernel-fdt {
			description = \"Kernel dtb\";
			data = /incbin/(\"./dts/kern.dtb\");
			type = \"flat_dt\";
			arch = \"${ARCH}\";
			compression = \"none\";
			hash {
				algo = \"sha256\";
			};
		};"
	fi
}

function generate_bl31_node()
{
	NUM=1
	for NAME in `ls -l bl31_0x*.bin | sort --key=5 -nr | awk '{ print $9 }'`
	do
		ATF_LOAD_ADDR=`echo ${NAME} | awk -F "_" '{ printf $2 }' | awk -F "." '{ printf $1 }'`
		# only atf-1 support compress
		if [ "${COMPRESSION}" == "gzip" -a ${NUM} -eq 1  ]; then
			openssl dgst -sha256 -binary -out ${NAME}.digest ${NAME}
			gzip -k -f -9 ${NAME}

			echo "		atf-${NUM} {
			description = \"ARM Trusted Firmware\";
			data = /incbin/(\"./${NAME}${SUFFIX}\");
			type = \"firmware\";
			arch = \"arm64\";
			os = \"arm-trusted-firmware\";
			compression = \"${COMPRESSION}\";
			load = <"${ATF_LOAD_ADDR}">;
			hash {
				algo = \"sha256\";
			};
			digest {
				value = /incbin/(\"./${NAME}.digest\");
				algo = \"sha256\";
			};
		};"
		else
			echo "		atf-${NUM} {
			description = \"ARM Trusted Firmware\";
			data = /incbin/(\"./${NAME}\");
			type = \"firmware\";
			arch = \"arm64\";
			os = \"arm-trusted-firmware\";
			compression = \"none\";
			load = <"${ATF_LOAD_ADDR}">;
			hash {
				algo = \"sha256\";
			};
		};"
		fi

		if [ ${NUM} -gt 1 ]; then
			LOADABLE_ATF=${LOADABLE_ATF}", \"atf-${NUM}\""
		fi
		NUM=`expr ${NUM} + 1`
	done
}

function generate_bl32_node()
{
	if [ -z ${TEE_LOAD_ADDR} ]; then
		return
	fi

	echo "		optee {
			description = \"OP-TEE\";
			data = /incbin/(\"./tee.bin${SUFFIX}\");
			type = \"firmware\";
			arch = \"arm64\";
			os = \"op-tee\";
			compression = \"${COMPRESSION}\";
			load = <"0x${TEE_LOAD_ADDR}">;
			hash {
				algo = \"sha256\";
			};"
	if [ "${COMPRESSION}" == "gzip" ]; then
		echo "			digest {
				value = /incbin/(\"./tee.bin.digest\");
				algo = \"sha256\";
			};"
		openssl dgst -sha256 -binary -out tee.bin.digest tee.bin
		gzip -k -f -9 tee.bin
	fi

	LOADABLE_OPTEE=", \"optee\""
	echo "		};"
}
########################################################################################################

cat << EOF
/*
 * Copyright (C) 2020 Rockchip Electronic Co.,Ltd
 *
 * Simple U-boot fit source file containing ATF/OP-TEE/U-Boot/dtb
 */

/dts-v1/;

/ {
	description = "FIT Image with ATF/OP-TEE/U-Boot";
	#address-cells = <1>;

	images {
EOF

	# generate nodes dynamically
	generate_uboot_node
	generate_bl31_node
	generate_bl32_node
	generate_kfdt_node

cat << EOF
		fdt {
			description = "U-Boot dtb";
			data = /incbin/("./u-boot.dtb");
			type = "flat_dt";
			arch = "${ARCH}";
			compression = "none";
			hash {
				algo = "sha256";
			};
		};
	};

	configurations {
		default = "conf";
		conf {
			description = "Rockchip armv8 with ATF";
			rollback-index = <0x0>;
			burn-key-hash = <0>;
			firmware = "atf-1";
			loadables = "uboot"${LOADABLE_ATF}${LOADABLE_OPTEE};
			fdt = "fdt";
			signature {
				algo = "sha256,rsa2048";
				padding = "pss";
				key-name-hint = "dev";
				sign-images = "fdt", "firmware", "loadables";
			};
		};
	};
};
EOF
