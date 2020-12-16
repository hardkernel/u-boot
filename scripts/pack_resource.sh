#!/bin/sh
#
# Copyright (c) 2019 Fuzhou Rockchip Electronics Co., Ltd
#
# SPDX-License-Identifier: GPL-2.0
#

RSCE_OLD=$1
RSCE_NEW=resource.img
TOOL=../rkbin/tools/resource_tool
IMAGES=./tools/images/
TMP_DIR=.resource_tmp

usage()
{
	echo "Usage:"
	echo "  ./pack_resource <input resource.img>"
}

prepare()
{
	echo
	if [ "${RSCE_OLD}" = '--help' -o "${RSCE_OLD}" = '-h' -o "${RSCE_OLD}" = '--h' ]; then
		usage
		exit 0
	elif [ ! -d "${IMAGES}" ];then
		echo "ERROR: No ${RESOURCE}"
		exit 1
	elif [ -z "${RSCE_OLD}" ];then
		usage
		exit 1
	elif [ ! -f "${RSCE_OLD}" ];then
		echo "ERROR: No ${RSCE_OLD}"
		exit 1
	fi
}

append_images_to_resource()
{
	rm -rf ${TMP_DIR} && mkdir -p ${TMP_DIR}

	echo "Pack ${IMAGES} & ${RSCE_OLD} to ${RSCE_NEW} ..."
	if [ -f "${RSCE_OLD}" ];then
		echo "Unpacking old image(${RSCE_OLD}):"
		${TOOL} --unpack --verbose --image=${RSCE_OLD} ${TMP_DIR} 2>&1 | grep entry | sed "s/^.*://" | xargs echo
	fi

	if [ -d "${IMAGES}" ];then
		cp -r ${IMAGES}/* ${TMP_DIR}
	else
		cp -r ${IMAGES}   ${TMP_DIR}
	fi
	${TOOL} --pack --root=${TMP_DIR} --image=${RSCE_NEW} `find ${TMP_DIR} -type f|sort`

	echo
	echo "Packed resources:"
	${TOOL} --unpack --verbose --image=${RSCE_NEW} ${TMP_DIR} 2>&1 | grep entry | sed "s/^.*://" | xargs echo

	rm -rf ${TMP_DIR}
	echo
	echo "./resource.img with battery images is ready"
}

prepare
append_images_to_resource

