#!/bin/bash
#
# Copyright (C) 2020 Rockchip Electronics Co., Ltd
#
# SPDX-License-Identifier:     GPL-2.0+
#

# Process args and auto set variables
source ./${srctree}/arch/arm/mach-rockchip/make_fit_args.sh

if [ "${COMPRESSION}" == "gzip" ]; then
	gzip -k -f -9 ${srctree}/images/kernel
	gzip -k -f -9 ${srctree}/images/ramdisk
	SUFFIX=".gz"
else
	COMPRESSION="none"
	SUFFIX=
fi

cat << EOF
/*
 * Copyright (C) 2020 Fuzhou Rockchip Electronics Co., Ltd
 *
 * Minimal dts for a FIT image.
 *
 * SPDX-License-Identifier: GPL-2.0
 */

/dts-v1/;
/ {
	description = "FIT source file for Linux";
	#address-cells = <1>;

	images {
		fdt {
			data = /incbin/("./images/rk-kernel.dtb");
			type = "flat_dt";
			arch = "arm";
			compression = "none";
			load  = <0xffffff00>;
			hash {
				algo = "sha256";
			};
		};

		kernel {
EOF
echo "			data = /incbin/(\"./images/kernel${SUFFIX}\");"
echo "			compression = \"${COMPRESSION}\";"
cat << EOF
			type = "kernel";
			arch = "arm";
			os = "linux";
			entry = <0xffffff01>;
			load  = <0xffffff01>;
			hash {
				algo = "sha256";
			};
		};

		ramdisk {
EOF
echo "			data = /incbin/(\"./images/ramdisk${SUFFIX}\");"
echo "			compression = \"${COMPRESSION}\";"
cat << EOF
			type = "ramdisk";
			arch = "arm";
			os = "linux";
			load  = <0xffffff02>;
			hash {
				algo = "sha256";
			};
		};

		resource {
			data = /incbin/("./images/resource");
			type = "multi";
			arch = "arm";
			compression = "none";
			hash {
				algo = "sha256";
			};
		};
	};

	configurations {
		default = "conf";
		conf {
			description = "Boot Linux kernel with FDT blob";
			rollback-index = <0x0>;
			fdt = "fdt";
			kernel = "kernel";
			ramdisk = "ramdisk";
			multi = "resource";
			signature {
				algo = "sha256,rsa2048";
				padding = "pss";
				key-name-hint = "dev";
				sign-images = "fdt", "kernel", "ramdisk", "multi";
			};
		};
	};
};

EOF
