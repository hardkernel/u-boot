#!/bin/bash

declare -i bl2_size=`du -b $1 | awk '{print int($1)}'`

declare -i zero_size=49152-$bl2_size

dd if=/dev/zero of=$2 bs=1 count=$zero_size

cat $1 $2 > $3

rm $2
