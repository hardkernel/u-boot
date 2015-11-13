#!/bin/bash

#bl2 file size 41K, bl21 file size 3K (file size not equal runtime size)
#total 44K

#after encrypt process, bl2 add 4K header, cut off 4K tail

declare -i bl2_size=`du -b $1 | awk '{print int($1)}'`
#46080
declare -i zero_size=41984-$bl2_size
dd if=/dev/zero of=$2 bs=1 count=$zero_size
cat $1 $2 > $3

declare -i bl21_size=`du -b $4 | awk '{print int($1)}'`
#3072
declare -i zero_size_21=7168-$bl21_size
dd if=/dev/zero of=$2 bs=1 count=$zero_size_21
cat $4 $2 > $5

cat $3 $5 > $6

rm $2
