#!/bin/bash
#
# Copyright (C) 2021 Rockchip Electronics Co., Ltd
#
# SPDX-License-Identifier:     GPL-2.0+
#

# Process args and auto set variables
source ./${srctree}/arch/arm/mach-rockchip/fit_args.sh
rm -f ${srctree}/*.digest ${srctree}/*.bin.gz ${srctree}/bl31_0x*.bin

# Periph register
MAX_ADDR_VAL=$((0xf0000000))

# compression
if [ "${COMPRESSION}" == "gzip" ]; then
	SUFFIX=".gz"
	COMPRESS_CMD="gzip -kf9"
elif [ "${COMPRESSION}" == "lzma" ]; then
	SUFFIX=".lzma"
	COMPRESS_CMD="${srctree}/scripts/compress.sh lzma"
else
	COMPRESSION="none"
	SUFFIX=
fi

# nodes
function gen_uboot_node()
{
	if [ -z ${UBOOT_LOAD_ADDR} ]; then
		return
	fi

	UBOOT="u-boot-nodtb.bin"
	echo "		uboot {
			description = \"U-Boot\";
			data = /incbin/(\"${UBOOT}${SUFFIX}\");
			type = \"standalone\";
			arch = \"${U_ARCH}\";
			os = \"U-Boot\";
			compression = \"${COMPRESSION}\";
			load = <"${UBOOT_LOAD_ADDR}">;"
	if [ "${COMPRESSION}" != "none" ]; then
		openssl dgst -sha256 -binary -out ${UBOOT}.digest ${UBOOT}
		UBOOT_SZ=`ls -l ${UBOOT} | awk '{ print $5 }'`
		if [ ${UBOOT_SZ} -gt 0 ]; then
			${COMPRESS_CMD} ${srctree}/${UBOOT}
		else
			touch ${srctree}/${UBOOT}${SUFFIX}
		fi
		echo "			digest {
				value = /incbin/(\"./${UBOOT}.digest\");
				algo = \"sha256\";
			};"
	fi
	echo "			hash {
				algo = \"sha256\";
			};
		};"

	LOADABLE_UBOOT="\"uboot\", "
}

function gen_fdt_node()
{
	if [ -z ${UBOOT_LOAD_ADDR} ]; then
		return
	fi

	echo "		fdt {
			description = \"U-Boot dtb\";
			data = /incbin/(\"./u-boot.dtb\");
			type = \"flat_dt\";
			arch = \"${U_ARCH}\";
			compression = \"none\";
			hash {
				algo = \"sha256\";
			};
		};"

	FDT_SIGN=", \"fdt\""
	FDT="fdt = \"fdt\"${PROP_KERN_DTB};"
};

function gen_kfdt_node()
{
	if [ -z ${UBOOT_LOAD_ADDR} ]; then
		return
	fi

	KERN_DTB=`sed -n "/CONFIG_EMBED_KERNEL_DTB_PATH=/s/CONFIG_EMBED_KERNEL_DTB_PATH=//p" .config | tr -d '"'`
	if [ -z ${KERN_DTB} ]; then
		return;
	fi

	if [ -f ${srctree}/${KERN_DTB} ]; then
	PROP_KERN_DTB=', "kern-fdt"';
	echo "		kern-fdt {
			description = \"${KERN_DTB}\";
			data = /incbin/(\"${KERN_DTB}\");
			type = \"flat_dt\";
			arch = \"${U_ARCH}\";
			compression = \"none\";
			hash {
				algo = \"sha256\";
			};
		};"
	fi
}

function gen_bl31_node()
{
	${srctree}/arch/arm/mach-rockchip/decode_bl31.py

	NUM=1
	for ATF in `ls -1 -S bl31_0x*.bin`
	do
		ATF_LOAD_ADDR=`echo ${ATF} | awk -F "_" '{ printf $2 }' | awk -F "." '{ printf $1 }'`
		# only atf-1 support compress
		if [ "${COMPRESSION}" != "none" -a ${NUM} -eq 1  ]; then
			openssl dgst -sha256 -binary -out ${ATF}.digest ${ATF}
			${COMPRESS_CMD} ${ATF}

			echo "		atf-${NUM} {
			description = \"ARM Trusted Firmware\";
			data = /incbin/(\"./${ATF}${SUFFIX}\");
			type = \"firmware\";
			arch = \"${ARCH}\";
			os = \"arm-trusted-firmware\";
			compression = \"${COMPRESSION}\";
			load = <"${ATF_LOAD_ADDR}">;
			hash {
				algo = \"sha256\";
			};
			digest {
				value = /incbin/(\"./${ATF}.digest\");
				algo = \"sha256\";
			};
		};"
		else
			echo "		atf-${NUM} {
			description = \"ARM Trusted Firmware\";
			data = /incbin/(\"./${ATF}\");
			type = \"firmware\";
			arch = \"${ARCH}\";
			os = \"arm-trusted-firmware\";
			compression = \"none\";
			load = <"${ATF_LOAD_ADDR}">;
			hash {
				algo = \"sha256\";
			};
		};"
		fi

		if [ ${NUM} -eq 2 ]; then
			LOADABLE_ATF=${LOADABLE_ATF}"\"atf-${NUM}\""
		elif [ ${NUM} -gt 2 ]; then
			LOADABLE_ATF=${LOADABLE_ATF}", \"atf-${NUM}\""
		fi
		NUM=`expr ${NUM} + 1`
	done
}

function gen_bl32_node()
{
	if [ -z ${TEE_LOAD_ADDR} ]; then
		return
	fi

	if [ "${ARCH}" == "arm" ]; then
		# If not AArch32 mode
		if ! grep  -q '^CONFIG_ARM64_BOOT_AARCH32=y' .config ; then
			ENTRY="entry = <"${TEE_LOAD_ADDR}">;"

			# if disable packing tee.bin
			if ! grep -q '^CONFIG_SPL_OPTEE=y' .config ; then
				return
			fi

		fi
	fi

	TEE="tee.bin"
	echo "		optee {
			description = \"OP-TEE\";
			data = /incbin/(\"${TEE}${SUFFIX}\");
			type = \"firmware\";
			arch = \"${ARCH}\";
			os = \"op-tee\";
			compression = \"${COMPRESSION}\";
			${ENTRY}
			load = <"${TEE_LOAD_ADDR}">;"
	if [ "${COMPRESSION}" != "none" ]; then
		openssl dgst -sha256 -binary -out ${TEE}.digest ${TEE}
		${COMPRESS_CMD} ${TEE}
		echo "			digest {
				value = /incbin/(\"./${TEE}.digest\");
				algo = \"sha256\";
			};"
	fi
	echo "			hash {
				algo = \"sha256\";
			};
		};"
	LOADABLE_OPTEE=", \"optee\""
	FIRMWARE_OPTEE="firmware = \"optee\";"
	FIRMWARE_SIGN="\"firmware\""
}

function gen_mcu_node()
{
	for ((i=0, n=0; i<5; i++))
	do
		if [ ${i} -eq 0 ]; then
			MCU_ADDR=${MCU0_LOAD_ADDR}
		elif [ ${i} -eq 1 ]; then
			MCU_ADDR=${MCU1_LOAD_ADDR}
		elif [ ${i} -eq 2 ]; then
			MCU_ADDR=${MCU2_LOAD_ADDR}
		elif [ ${i} -eq 3 ]; then
			MCU_ADDR=${MCU3_LOAD_ADDR}
		elif [ ${i} -eq 4 ]; then
			MCU_ADDR=${MCU4_LOAD_ADDR}
		fi

		if [ -z ${MCU_ADDR} ]; then
			continue
		fi

		MCU_ADDR_VAL=$((MCU_ADDR))
		MCU="mcu${i}"
		echo "		${MCU} {
			description = \"${MCU}\";
			type = \"standalone\";
			arch = \"riscv\";
			load = <"${MCU_ADDR}">;"

		if [ "${COMPRESSION}" != "none" -a ${MCU_ADDR_VAL} -lt ${MAX_ADDR_VAL} ]; then
			openssl dgst -sha256 -binary -out ${MCU}.bin.digest ${MCU}.bin
			${COMPRESS_CMD} ${MCU}.bin
			echo "			data = /incbin/(\"./${MCU}.bin${SUFFIX}\");
			compression = \"${COMPRESSION}\";
			digest {
				value = /incbin/(\"./${MCU}.bin.digest\");
				algo = \"sha256\";
			};"
		else
			echo "			data = /incbin/(\"./${MCU}.bin\");
			compression = \"none\";"
		fi

		echo "			hash {
				algo = \"sha256\";
			};
		};"

		if [ ${n} -eq 0 ]; then
			STANDALONE_LIST=${STANDALONE_LIST}"\"${MCU}\""
		else
			STANDALONE_LIST=${STANDALONE_LIST}", \"${MCU}\""
		fi
		n=`expr ${n} + 1`

		STANDALONE_SIGN=", \"standalone\""
		STANDALONE_MCU="standalone = ${STANDALONE_LIST};"
	done
}

function gen_loadable_node()
{
	for ((i=0; i<5; i++))
	do
		if [ ${i} -eq 0 ]; then
			LOAD_ADDR=${LOAD0_LOAD_ADDR}
		elif [ ${i} -eq 1 ]; then
			LOAD_ADDR=${LOAD1_LOAD_ADDR}
		elif [ ${i} -eq 2 ]; then
			LOAD_ADDR=${LOAD2_LOAD_ADDR}
		elif [ ${i} -eq 3 ]; then
			LOAD_ADDR=${LOAD3_LOAD_ADDR}
		elif [ ${i} -eq 4 ]; then
			LOAD_ADDR=${LOAD4_LOAD_ADDR}
		fi

		if [ -z ${LOAD_ADDR} ]; then
			continue
		fi

		LOAD_ADDR_VAL=$((LOAD_ADDR))
		LOAD="load${i}"
		echo "		${LOAD} {
			description = \"${LOAD}\";
			type = \"standalone\";
			arch = \"${ARCH}\";
			load = <"${LOAD_ADDR}">;"

		if [ "${COMPRESSION}" != "none" -a ${LOAD_ADDR_VAL} -lt ${MAX_ADDR_VAL} ]; then
			openssl dgst -sha256 -binary -out ${LOAD}.bin.digest ${LOAD}.bin
			${COMPRESS_CMD} ${LOAD}.bin
			echo "			data = /incbin/(\"./${LOAD}.bin${SUFFIX}\");
			compression = \"${COMPRESSION}\";
			digest {
				value = /incbin/(\"./${LOAD}.bin.digest\");
				algo = \"sha256\";
			};"
		else
			echo "			data = /incbin/(\"./${LOAD}.bin\");
			compression = \"none\";"
		fi

		echo "			hash {
				algo = \"sha256\";
			};
		};"

		LOADABLE_OTHER=${LOADABLE_OTHER}", \"${LOAD}\""
	done
}

function gen_header()
{
echo "
/*
 * Copyright (C) 2020 Rockchip Electronic Co.,Ltd
 *
 * Simple U-boot fit source file containing ATF/OP-TEE/U-Boot/dtb/MCU
 */

/dts-v1/;

/ {
	description = \"FIT Image with ATF/OP-TEE/U-Boot/MCU\";
	#address-cells = <1>;

	images {
"
}

function gen_arm64_configurations()
{
PLATFORM=`sed -n "/CONFIG_DEFAULT_DEVICE_TREE/p" .config | awk -F "=" '{ print $2 }' | tr -d '"'`
if grep -q '^CONFIG_FIT_ENABLE_RSASSA_PSS_SUPPORT=y' .config ; then
	ALGO_PADDING="				padding = \"pss\";"
fi
if grep -q '^CONFIG_FIT_ENABLE_RSA4096_SUPPORT=y' .config ; then
	ALGO_NAME="				algo = \"sha256,rsa4096\";"
else
	ALGO_NAME="				algo = \"sha256,rsa2048\";"
fi
if [ -z "${LOADABLE_ATF}" ]; then
	LOADABLE_UBOOT="\"uboot\""
fi

echo "	};

	configurations {
		default = \"conf\";
		conf {
			description = \"${PLATFORM}\";
			rollback-index = <0x0>;
			firmware = \"atf-1\";
			loadables = ${LOADABLE_UBOOT}${LOADABLE_ATF}${LOADABLE_OPTEE}${LOADABLE_OTHER};
			${STANDALONE_MCU}
			${FDT}
			signature {
				${ALGO_NAME}
				${ALGO_PADDING}
				key-name-hint = \"dev\";
				sign-images = \"firmware\", \"loadables\"${FDT_SIGN}${STANDALONE_SIGN};
			};
		};
	};
};
"
}

function gen_arm_configurations()
{
PLATFORM=`sed -n "/CONFIG_DEFAULT_DEVICE_TREE/p" .config | awk -F "=" '{ print $2 }' | tr -d '"'`
if grep -q '^CONFIG_FIT_ENABLE_RSASSA_PSS_SUPPORT=y' .config ; then
        ALGO_PADDING="                          padding = \"pss\";"
fi
if grep -q '^CONFIG_FIT_ENABLE_RSA4096_SUPPORT=y' .config ; then
	ALGO_NAME="				algo = \"sha256,rsa4096\";"
else
	ALGO_NAME="				algo = \"sha256,rsa2048\";"
fi
if [ ! -z "${LOADABLE_UBOOT}" ] || [ ! -z "${LOADABLE_OTHER}" ]; then
	LOADABLE_UBOOT="\"uboot\""
	LOADABLES="loadables = ${LOADABLE_UBOOT}${LOADABLE_OTHER};"
	if [ -z ${FIRMWARE_SIGN} ]; then
		LOADABLES_SIGN="\"loadables\""
	else
		LOADABLES_SIGN=", \"loadables\""
	fi
fi

echo "	};

	configurations {
		default = \"conf\";
		conf {
			description = \"${PLATFORM}\";
			rollback-index = <0x0>;
			${FIRMWARE_OPTEE}
			${LOADABLES}
			${STANDALONE_MCU}
			${FDT}
			signature {
				${ALGO_NAME}
				${ALGO_PADDING}
				key-name-hint = \"dev\";
				sign-images = ${FIRMWARE_SIGN}${LOADABLES_SIGN}${FDT_SIGN}${STANDALONE_SIGN};
			};
		};
	};
};
"
}

