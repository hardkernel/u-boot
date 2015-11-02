#!/bin/bash

# Amlogic gerrit code auto-fix script
# Author: xiaobo.gu@amlogic.com
# Init version: 2015.05.01

# get current dir
CUR_P=$(dirname $0)
CUR_P=${CUR_P/\./$(pwd)}
#echo $CUR_P

# prepare variables
REVIEW_OUTPUT=$CUR_P/review.txt
PATCH_FILE_NAME=$CUR_P/patch_name
#CUR_P=`abspath $pwd`
#echo $CUR_P

# get latest patch
git format-patch -s -1 -o $CUR_P > $PATCH_FILE_NAME
PATCH_NAME=`cat $PATCH_FILE_NAME`
#echo $PATCH_NAME

# check patch and generate review summary
python $CUR_P/checkpatch.py $PATCH_NAME > $REVIEW_OUTPUT

# fix files by review summary
python $CUR_P/auto_fix.py $REVIEW_OUTPUT

# cleanup
rm $PATCH_FILE_NAME
rm $REVIEW_OUTPUT
rm $PATCH_NAME