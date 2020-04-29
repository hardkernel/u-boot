#!/bin/bash
#
# Copyright (c) 2020 Fuzhou Rockchip Electronics Co., Ltd
#
# SPDX-License-Identifier: GPL-2.0
#
set -e

FIT_DIR="fit"
KEY_DIR="keys"
FIT_NS_OFFS_UBOOT="0xa00"
FIT_NS_OFFS_BOOT="0x800"
FIT_S_OFFS_UBOOT="0xc00"
FIT_S_OFFS_BOOT="0xc00"
# itb
FIT_ITB_UBOOT="fit/uboot.itb"
FIT_ITB_BOOT="fit/boot.itb"
# resign
FIT_ITB_RESIG="fit/sig-new.itb"
FIT_ITB_RESIG_BACKUP="fit/sig-backup.itb"
FIT_SIG_P1="fit/sig.p1"
FIT_SIG_P2="fit/sig.p2.sig"
FIT_SIG_P3="fit/sig.p3"
# data to be signed
FIT_DATA2SIG_UBOOT="fit/uboot.data2sign"
FIT_DATA2SIG_BOOT="fit/boot.data2sign"
# unmap
FIT_UNMAP_ITB_UBOOT="fit/uboot_unmap_itb.dts"
FIT_UNMAP_ITB_BOOT="fit/boot_unmap_itb.dts"
FIT_UNMAP_KEY_UBOOT="fit/uboot_unmap_key.dts"
FIT_UNMAP_KEY_BOOT="fit/boot_unmap_key.dts"
# file
CHIP_FILE="arch/arm/lib/.asm-offsets.s.cmd"
# placeholder address
FIT_FDT_ADDR_PLACEHOLDER="0xffffff00"
FIT_KERNEL_ADDR_PLACEHOLDER="0xffffff01"
FIT_RAMDISK_ADDR_PLACEHOLDER="0xffffff02"
# output
FIT_IMG_UBOOT="uboot.img"
FIT_IMG_BOOT="boot.img"

function usage_pack()
{
	echo
	echo "usage:"
	echo "    $0 [args]"
	echo
	echo "args:"
	if [[ "$0" = *fit-vboot-boot.sh ]]; then
		echo "    --rollback-index-boot   <decimal integer>"
	elif [[ "$0" = *fit-vboot-uboot.sh ]]; then
		echo "    --rollback-index-uboot  <decimal integer>"
	else
		echo "    --rollback-index-boot   <decimal integer>"
		echo "    --rollback-index-uboot  <decimal integer>"
	fi
	echo "    --no-vboot"
	echo "    --no-check"
	echo "    --new-spl"
	echo
}

function arg_check_decimal()
{
	if [ -z $1 ]; then
		echo "ERROR: $1 is not a decimal integer"
		usage_pack
		exit 1
	fi

	decimal=`echo $1 |sed 's/[0-9]//g'`
	if [ ! -z $decimal ]; then
		echo "ERROR: $1 is not a decimal integer"
		usage_pack
		exit 1
	fi
}

function fit_process_args()
{
	while [ $# -gt 0 ]; do
		case $1 in
			--no-vboot)     # Force to build non-vboot image
				ARG_NO_VBOOT="y"
				shift 1
				;;
			--no-rebuild)   # No rebuild with "./make.sh"
				ARG_NO_REBUILD="y"
				shift 1
				;;
			--no-check)     # No hostcc fit signature check
				ARG_NO_CHECK="y"
				shift 1
				;;
			--ini-trust)    # Assign trust ini file
				ARG_INI_TRUST=$2
				shift 2
				;;
			--ini-loader)   # Assign loader ini file
				ARG_INI_LOADER=$2
				shift 2
				;;
			--new-spl)      # Use current build u-boot-spl.bin to pack loader
				ARG_NEW_SPL="y"
				shift 1
				;;
			--rollback-index-boot)
				ARG_ROLLBACK_IDX_BOOT=$2
				arg_check_decimal $2
				shift 2
				;;
			--rollback-index-uboot)
				ARG_ROLLBACK_IDX_UBOOT=$2
				arg_check_decimal $2
				shift 2
				;;
			*)
				usage_pack
				exit 1
				;;
		esac
	done
}

function its_file_check()
{
	cat $1 | while read line
	do
		image=`echo $line | sed -n "/incbin/p" | awk -F '"' '{ printf $2 }' | tr -d ' '`
		if [ ! -f $image ]; then
			echo "ERROR: No $image"
			exit 1
		fi
	done
}

function fit_rebuild()
{
	if [ "$ARG_NO_REBUILD" != "y" ]; then
		./make.sh nopack
	fi

	if [ -d $FIT_DIR ]; then
		rm $FIT_DIR -rf
	fi

	mkdir -p $FIT_DIR
}

function fit_uboot_make_itb()
{
	./make.sh itb $ARG_INI_TRUST
	its_file_check u-boot.its

	# output uboot.itb
	if [ "$ARG_NO_VBOOT" = "y" ]; then
		SIGN_MSG="no-signed"
		./tools/mkimage -f u-boot.its -E -p $FIT_NS_OFFS_UBOOT $FIT_ITB_UBOOT
		if [ "$ARG_NEW_SPL" = "y" ]; then
			./make.sh spl-s $ARG_INI_LOADER
			echo "pack loader with: spl/u-boot-spl.bin"
		else
			./make.sh loader $ARG_INI_LOADER
		fi
	else
		SIGN_MSG="signed"
		if [ ! -f $KEY_DIR/dev.key ]; then
			echo "ERROR: No $KEY_DIR/dev.key"
			exit 1
		elif [ ! -f $KEY_DIR/dev.crt ]; then
			echo "ERROR: No $KEY_DIR/dev.crt"
			exit 1
		fi

		if ! grep  -q '^CONFIG_SPL_FIT_SIGNATURE=y' .config ; then
			echo "ERROR: CONFIG_SPL_FIT_SIGNATURE is disabled"
			exit 1
		fi

		if grep -q '^CONFIG_SPL_FIT_ROLLBACK_PROTECT=y' .config ; then
			SPL_ROLLBACK_PROTECT="y"
			if [ -z $ARG_ROLLBACK_IDX_UBOOT ]; then
				echo "ERROR: No args \"--rollback-index-uboot <n>\""
				exit 1
			fi
		fi

		if [ "$SPL_ROLLBACK_PROTECT" = "y" ]; then
			sed -i "s/rollback-index = <0x0>/rollback-index = <$ARG_ROLLBACK_IDX_UBOOT>/g" u-boot.its
		fi

		# We need a u-boot.dtb with RSA pub-key insert
		if ! fdtget -l u-boot.dtb /signature >/dev/null 2>&1 ; then
			./tools/mkimage -f u-boot.its -k $KEY_DIR/ -K u-boot.dtb -E -p $FIT_S_OFFS_UBOOT -r $FIT_ITB_UBOOT
			echo "Insert RSA pub into u-boot.dtb"
		fi

		# Pack
		./tools/mkimage -f u-boot.its -k $KEY_DIR/ -K spl/u-boot-spl.dtb -E -p $FIT_S_OFFS_UBOOT -r $FIT_ITB_UBOOT
		mv data2sign.bin $FIT_DATA2SIG_UBOOT

		# rollback-index read back check
		if [ "$SPL_ROLLBACK_PROTECT" = "y" ]; then
			ROLLBACK_IDX_UBOOT=`fdtget -ti $FIT_ITB_UBOOT /configurations/conf@1 rollback-index`
			if [ "$ROLLBACK_IDX_UBOOT" != "$ARG_ROLLBACK_IDX_UBOOT" ]; then
				echo "ERROR: Failed to set rollback-index for $FIT_ITB_UBOOT";
				exit 1
			fi
		fi

		if [ "$ARG_NO_CHECK" != "y" ]; then
			if [ "$ARG_NEW_SPL" = "y" ]; then
				./tools/fit_check_sign -f $FIT_ITB_UBOOT -k spl/u-boot-spl.dtb -s
			else
				# unpack legacy u-boot-spl.dtb
				spl_file="../rkbin/"`sed -n "/FlashBoot=/s/FlashBoot=//p" $ARG_INI_LOADER |tr -d '\r'`
				offs=`fdtdump -s $spl_file | head -1 | awk -F ":" '{ print $2 }' | sed "s/ found fdt at offset //g" | tr -d " "`
				if [ -z $offs ]; then
					echo "ERROR: invalid $spl_file, unable to find fdt blob"
				fi
				offs=`printf %d $offs` # hex -> dec
				dd if=$spl_file of=spl/u-boot-spl-legacy.dtb bs=$offs skip=1  >/dev/null 2>&1

				# check
				./tools/fit_check_sign -f $FIT_ITB_UBOOT -k spl/u-boot-spl-legacy.dtb -s
			fi
		fi

		# minimize spl dtb
		if grep  -q '^CONFIG_SPL_FIT_HW_CRYPTO=y' .config ; then
			fdtput -tx spl/u-boot-spl.dtb /signature/key-dev rsa,r-squared 0x0
			if grep  -q '^CONFIG_SPL_ROCKCHIP_CRYPTO_V1=y' .config ; then
				fdtput -tx spl/u-boot-spl.dtb /signature/key-dev rsa,np 0x0
			else
				fdtput -tx spl/u-boot-spl.dtb /signature/key-dev rsa,c 0x0
			fi
		else
			fdtput -tx spl/u-boot-spl.dtb /signature/key-dev rsa,c 0x0
			fdtput -tx spl/u-boot-spl.dtb /signature/key-dev rsa,np 0x0
			fdtput -tx spl/u-boot-spl.dtb /signature/key-dev rsa,exponent-BN 0x0
		fi

		# repack spl which has rsa pub-key insert
		rm *_loader_*.bin -rf
		if [ "$ARG_NEW_SPL" = "y" ]; then
			cat spl/u-boot-spl-nodtb.bin > spl/u-boot-spl.bin
			if ! grep  -q '^CONFIG_SPL_SEPARATE_BSS=y' .config ; then
				cat spl/u-boot-spl-pad.bin >> spl/u-boot-spl.bin
			fi
			cat spl/u-boot-spl.dtb >> spl/u-boot-spl.bin

			./make.sh spl-s $ARG_INI_LOADER
			echo "pack loader with: spl/u-boot-spl.bin"
		else
			./make.sh loader $ARG_INI_LOADER
		fi
	fi

	# clean
	mv u-boot.its $FIT_DIR
	cp tee.bin $FIT_DIR
	cp u-boot-nodtb.bin $FIT_DIR
	cp u-boot.dtb $FIT_DIR
	cp spl/u-boot-spl.bin $FIT_DIR
	cp spl/u-boot-spl.dtb $FIT_DIR
	rm u-boot.itb u-boot.img u-boot-dtb.img -rf
	./scripts/dtc/dtc -I dtb -O dts $FIT_ITB_UBOOT -o $FIT_UNMAP_ITB_UBOOT >/dev/null 2>&1
	./scripts/dtc/dtc -I dtb -O dts spl/u-boot-spl.dtb -o $FIT_UNMAP_KEY_UBOOT >/dev/null 2>&1
}

function fit_boot_make_itb()
{
	if grep -q '^CONFIG_ARM64=y' .config ; then
		FIT_ITS_BOOT="kernel_arm64.its"
	else
		FIT_ITS_BOOT="kernel_arm.its"
	fi

	cp arch/arm/mach-rockchip/$FIT_ITS_BOOT ./
	its_file_check $FIT_ITS_BOOT

	# output boot.itb
	if [ "$ARG_NO_VBOOT" = "y" ]; then
		SIGN_MSG="no-signed"
		./tools/mkimage -f $FIT_ITS_BOOT -E -p $FIT_NS_OFFS_BOOT $FIT_ITB_BOOT
	else
		SIGN_MSG="signed"

		if [ ! -f $KEY_DIR/dev.key ]; then
			echo "ERROR: No $KEY_DIR/dev.key"
			exit 1
		elif [ ! -f $KEY_DIR/dev.crt ]; then
			echo "ERROR: No $KEY_DIR/dev.crt"
			exit 1
		fi

		if ! grep -q '^CONFIG_FIT_SIGNATURE=y' .config ; then
			echo "ERROR: CONFIG_FIT_SIGNATURE is disabled"
			exit 1
		fi

		if grep -q '^CONFIG_FIT_ROLLBACK_PROTECT=y' .config ; then
			ROLLBACK_PROTECT="y"
			if [ -z $ARG_ROLLBACK_IDX_BOOT ]; then
				echo "ERROR: No args \"--rollback-index-boot <n>\""
				exit 1
			fi
		fi

		# fixup entry and load address
		COMM_FILE=`sed -n "/_common.h/p" $CHIP_FILE | awk '{ print $1 }'`
		FDT_ADDR_R=`awk /fdt_addr_r/            $COMM_FILE | awk -F '=' '{ print $2 }' | awk -F '\\' '{ print $1 }'`
		KERNEL_ADDR_R=`awk /kernel_addr_r/      $COMM_FILE | awk -F '=' '{ print $2 }' | awk -F '\\' '{ print $1 }'`
		RMADISK_ADDR_R=`awk /ramdisk_addr_r/    $COMM_FILE | awk -F '=' '{ print $2 }' | awk -F '\\' '{ print $1 }'`
		sed -i "s/$FIT_FDT_ADDR_PLACEHOLDER/$FDT_ADDR_R/g"         $FIT_ITS_BOOT
		sed -i "s/$FIT_KERNEL_ADDR_PLACEHOLDER/$KERNEL_ADDR_R/g"   $FIT_ITS_BOOT
		sed -i "s/$FIT_RAMDISK_ADDR_PLACEHOLDER/$RMADISK_ADDR_R/g" $FIT_ITS_BOOT
		if [ "$ROLLBACK_PROTECT" = "y" ]; then
			sed -i "s/rollback-index = <0x0>/rollback-index = <$ARG_ROLLBACK_IDX_BOOT>/g" $FIT_ITS_BOOT
		fi

		./tools/mkimage -f $FIT_ITS_BOOT -k $KEY_DIR/ -K u-boot.dtb -E -p $FIT_S_OFFS_BOOT -r $FIT_ITB_BOOT
		mv data2sign.bin $FIT_DATA2SIG_BOOT

		# rollback-index read back check
		if [ "$ROLLBACK_PROTECT" = "y" ]; then
			ROLLBACK_IDX_BOOT=`fdtget -ti $FIT_ITB_BOOT /configurations/conf@1 rollback-index`
			if [ "$ROLLBACK_IDX_BOOT" != "$ARG_ROLLBACK_IDX_BOOT" ]; then
				echo "ERROR: Failed to set rollback-index for $FIT_ITB_BOOT";
				exit 1
			fi
		fi

		if [ "$ARG_NO_CHECK" != "y" ]; then
			./tools/fit_check_sign -f $FIT_ITB_BOOT -k u-boot.dtb
		fi

		# minimize u-boot dtb
		if grep  -q '^CONFIG_FIT_HW_CRYPTO=y' .config ; then
			fdtput -tx u-boot.dtb /signature/key-dev rsa,r-squared 0x0
			if grep  -q '^CONFIG_ROCKCHIP_CRYPTO_V1=y' .config ; then
				fdtput -tx u-boot.dtb /signature/key-dev rsa,np 0x0
			else
				fdtput -tx u-boot.dtb /signature/key-dev rsa,c 0x0
			fi
		else
			fdtput -tx u-boot.dtb /signature/key-dev rsa,c 0x0
			fdtput -tx u-boot.dtb /signature/key-dev rsa,np 0x0
			fdtput -tx u-boot.dtb /signature/key-dev rsa,exponent-BN 0x0
		fi
	fi

	# clean
	mv $FIT_ITS_BOOT $FIT_DIR
	./scripts/dtc/dtc -I dtb -O dts $FIT_ITB_BOOT -o $FIT_UNMAP_ITB_BOOT >/dev/null 2>&1
	./scripts/dtc/dtc -I dtb -O dts u-boot.dtb    -o $FIT_UNMAP_KEY_BOOT >/dev/null 2>&1
}

function fit_uboot_make_img()
{
	ITB_FILE=$1

	if [ -z $ITB_FILE ]; then
		ITB_FILE=$FIT_ITB_UBOOT
	fi

	ITB_MAX_NUM=`sed -n "/SPL_FIT_IMAGE_MULTIPLE/p" .config | awk -F "=" '{ print $2 }'`
	ITB_MAX_KB=`sed  -n "/SPL_FIT_IMAGE_KB/p" .config | awk -F "=" '{ print $2 }'`
	ITB_MAX_BS=$((ITB_MAX_KB*1024))
	FIT_MAX_BS=$((ITB_MAX_BS*ITB_MAX_NUM))
	THIS_BS=`ls -l $ITB_FILE | awk '{print $5}'`

	if [ $THIS_BS -eq $FIT_MAX_BS ]; then
		echo
		echo "ERROR: $ITB_FILE is too big, maybe it's not a .itb ?"
		exit 1
	elif [ $THIS_BS -gt $ITB_MAX_BS ]; then
		echo
		echo "ERROR: pack $FIT_IMG_UBOOT failed! $ITB_FILE actual: $THIS_BS bytes, max limit: $ITB_MAX_BS bytes"
		exit 1
	fi

	# multiple backup
	rm $FIT_IMG_UBOOT -rf
	for ((i = 0; i < $ITB_MAX_NUM; i++));
	do
		cat $ITB_FILE >> $FIT_IMG_UBOOT
		truncate -s %${ITB_MAX_KB}K $FIT_IMG_UBOOT
	done
}

function fit_boot_make_img()
{
	ITB_FILE=$1

	if [ -z $ITB_FILE ]; then
		ITB_FILE=$FIT_ITB_BOOT
	fi

	if [ "$ITB_FILE" != "$FIT_IMG_BOOT" ]; then
		cp $ITB_FILE $FIT_IMG_BOOT -f
	fi
}

function usage_resign()
{
	echo
	echo "usage:"
	echo "    $0 -f [itb_image] -s [sig]"
	echo
}

function fit_resign()
{
	if [ $# -ne 4 ]; then
		usage_resign
		exit 1
	fi

	while [ $# -gt 0 ]; do
		case $1 in
			-f)
				FIT_ITB=$2
				shift 2
				;;
			-s)
				FIT_SIG=$2
				shift 2
				;;
			*)
				usage_resign
				exit 1
				;;
		esac
	done

	# check
	if [ ! -f $FIT_ITB ]; then
		echo "ERROR: No $FIT_ITB"
		exit 1
	elif [ ! -f $FIT_SIG ]; then
		echo "ERROR: No $FIT_SIG"
		exit 1
	fi

	# confirm location
	SIG_SZ=`ls -l ${FIT_SIG} | awk '{ print $5 }'`
	LEN=`./tools/fit_info -f $FIT_ITB -n /configurations/conf@1/signature@1 -p value | sed -n "/LEN:/p" | awk '{ print $2 }'`
	OFF=`./tools/fit_info -f $FIT_ITB -n /configurations/conf@1/signature@1 -p value | sed -n "/OFF:/p" | awk '{ print $2 }'`
	END=`./tools/fit_info -f $FIT_ITB -n /configurations/conf@1/signature@1 -p value | sed -n "/END:/p" | awk '{ print $2 }'`

	if [ -z $LEN ]; then
		echo "ERROR: No valid signature in $FIT_ITB"
		exit 1
	elif [ "$SIG_SZ" -ne "$LEN" ]; then
		echo "ERROR: $FIT_SIG size $SIG_SZ != $FIT_ITB Signature size $LEN"
		exit 1
	fi

	# backup
	cp $FIT_ITB  $FIT_ITB_RESIG_BACKUP
	cp $FIT_SIG  $FIT_SIG_P2

	# generate .itb
	dd if=$FIT_ITB of=$FIT_SIG_P1 count=1 bs=$OFF
	dd if=$FIT_ITB of=$FIT_SIG_P3 skip=1 ibs=$END
	cat $FIT_SIG_P1  >  $FIT_ITB
	cat $FIT_SIG     >> $FIT_ITB
	cat $FIT_SIG_P3  >> $FIT_ITB

	# generate
	echo
	if fdtget -l $FIT_ITB /images/uboot@1 >/dev/null 2>&1 ; then
		fit_uboot_make_img  $FIT_ITB
		echo "Image(re-signed):  $FIT_IMG_UBOOT is ready"
	else
		fit_boot_make_img $FIT_ITB
		echo "Image(re-signed):  $FIT_IMG_BOOT is ready"
	fi
}

function fit_verbose_uboot()
{
	if [ "$SPL_ROLLBACK_PROTECT" = "y" ]; then
		echo "Image($SIGN_MSG, rollback-index=$ROLLBACK_IDX_UBOOT):  $FIT_IMG_UBOOT (with uboot trust) is ready"
	else
		echo "Image($SIGN_MSG):  $FIT_IMG_UBOOT (with uboot trust) is ready"
	fi
}

function fit_verbose_boot()
{
	if [ "$ROLLBACK_PROTECT" = "y" ]; then
		echo "Image($SIGN_MSG, rollback-index=$ROLLBACK_IDX_BOOT):  $FIT_IMG_BOOT (with kernel dtb ramdisk resource) is ready"
	else
		echo "Image($SIGN_MSG):  $FIT_IMG_BOOT (with kernel dtb ramdisk resource) is ready"
	fi
}

function fit_verbose_loader()
{
	LOADER=`ls *loader*.bin`
	echo "Image(no-signed):  $LOADER (with spl, ddr, usbplug) is ready"
}
