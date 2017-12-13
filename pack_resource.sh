#!/bin/sh
OLD_IMAGE=$1
IMAGE=resource.img
TOOL=../rkbin/tools/resource_tool
RESOURCES=./tools/images/

usage()
{
	echo "Usage:"
	echo "  ./pack_resource <input resource.img>"
}

prepare()
{
	echo
	if [ "$OLD_IMAGE" = '--help' -o "$OLD_IMAGE" = '-h' -o "$OLD_IMAGE" = '--h' ]; then
		usage
		exit 0
	elif [ ! -f "$TOOL" ];then
		echo "Can't find '../rkbin/' Responsity, please download it before pack image!"
		echo "How to obtain? 3 ways:"
		echo "	1. Login your Rockchip gerrit account: \"Projects\" -> \"List\" -> search \"rk/rkbin\" Responsity"
		echo "	2. Github Responsity: https://github.com/rockchip-linux/rkbin"
		echo "	3. Download full release SDK Responsity"
		exit 1
	elif [ ! -d "$RESOURCES" ];then
		echo "Can't find resources: $RESOURCES"
		exit 1
	elif [ -z "$OLD_IMAGE" ];then
		echo "Missing: <input image>"
		usage
		exit 1
	elif [ ! -f "$OLD_IMAGE" ];then
		echo "Can't find file: $OLD_IMAGE"
		usage
		exit 1
	fi
}

append_resource()
{
	local TMP_DIR=.resource_tmp
	rm -r $TMP_DIR 2>/dev/null
	mkdir $TMP_DIR

	echo "Pack $RESOURCES & $OLD_IMAGE to $IMAGE ..."
	if [ -f "$OLD_IMAGE" ];then
		echo "Unpacking old image($OLD_IMAGE):"
		$TOOL --unpack --verbose --image=$OLD_IMAGE $TMP_DIR 2>&1|grep entry|sed "s/^.*://"|xargs echo
	fi
	if [ -d "$RESOURCES" ];then
		cp -r $RESOURCES/* $TMP_DIR
	else
		cp -r $RESOURCES $TMP_DIR
	fi
	$TOOL --pack --root=$TMP_DIR --image=$IMAGE `find $TMP_DIR -type f|sort`
	echo "Packed resources:"
	$TOOL --unpack --verbose --image=$IMAGE $TMP_DIR 2>&1|grep entry|sed "s/^.*://"|xargs echo
	rm -r $TMP_DIR 2>/dev/null
	echo
	echo "resource.img is packed ready"
}

prepare
append_resource