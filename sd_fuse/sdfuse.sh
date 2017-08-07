#!/bin/bash


sudo dd if=./idbloader.img of=/dev/sdd conv=fsync bs=512 seek=64
sudo dd if=./uboot.img of=/dev/sdd conv=fsync bs=512 seek=16384
sudo dd if=./trust.img of=/dev/sdd conv=fsync bs=512 seek=24576

