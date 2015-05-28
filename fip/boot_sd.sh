#!/bin/bash

declare -i blank_size=512

dd if=/dev/zero of=$1 bs=1 count=$blank_size

cat $1 $2 > $3

rm $1

