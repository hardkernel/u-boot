#!/bin/sh

. ./export.sh;
cd ..;
case $1 in
	-h)	clear;
		echo "This is a automated tool to build and flash"
		echo "ORIGEN and SMDKV310(EVT0|EVT1) boards"
		echo"";
		echo "-b:	Build Image";
		echo "-f:	Flash Image";
		echo "-h:	Show Help";
		echo "-v:	Show Version";
		echo"";
		echo "examples:"
		echo "Build image: 	\$ build.sh  -b  origen|smdkv310";
		echo"";
		echo "Flash image: 	\$ build.sh  -f  origen|smdkv310|smdkv310_evt1";
		echo"";
		echo"";;
			
	-v)	clear;
		echo "Version 1.0";
		echo "";
		echo "Written By: Chander kashyap";
		echo "";;

	-b)	make distclean;
		
		case $2 in
			smdkv310 | smdkv310_evt1)	
				make smdkv310_config;;
			
			origen)	
				make origen_config;;
		esac
		make -j8;;

	-f)	umount /media/*;
		
		case $2 in
			smdkv310)
				sudo dd if=spl/smdkv310-spl.bin of=/dev/sdc bs=512 count=32 seek=1;
				sudo dd if=u-boot.bin of=/dev/sdc bs=512 count=1024 seek=65;;

			origen)
				sudo dd if=spl/origen-spl.bin of=/dev/sdc bs=512 count=32 seek=1;
				sudo dd if=u-boot.bin of=/dev/sdc bs=512 count=1024 seek=65 ;;
			smdkv310_evt1)	
				cd  -;sudo dd if=FWL1 of=/dev/sdc bs=512 count=16 seek=1;cd -;
				sudo dd if=spl/smdkv310-spl.bin of=/dev/sdc bs=512 count=32 seek=17;
				sudo dd if=u-boot.bin of=/dev/sdc bs=512 count=1024 seek=49;;
		esac
esac
cd -;
