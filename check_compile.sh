#!/bin/bash

#------------IMPORTANT------------#
#--RUN THIS SCRIPT BEFOR COMMIT---#
#---------------------------------#

# Author: xiaobo.gu@amlogic.com
# Init version: 20160329

#usage:
#
#./check_compile.sh            -check amlogic board configs
#./check_compile.sh cus        -check customer board configs
#./check_compile.sh all        -check both amlogic and customer boards


folder_board="board/amlogic"
customer_folder="customer/board"

echo "************** Amlogic Compile Check Tool **************"

# filters define:
#    cus: all customer board
#    all: all boards
#    other:
#      gxb: all gxbaby board
#      gxtvbb: all gxtvbb board
#      skt: all socket board
#      p200: p200 board
#      etc.....
declare filter="$1"

# ARRAY_CFG store config names
declare -a ARRAY_CFG
declare -a ARRAY_CFG_C
# TOTAL_CFG store config total num
declare -i TOTAL_CFG
declare -i TOTAL_CFG_C

# if filter!=cus, then include amlogic configs
# get all configs name from board folder
if [ "$1" != "cus" ]
then
  filter=$1
  for file in ${folder_board}/*; do
    temp_file=`basename $file`
    #echo "$temp_file"
    if [ -d ${folder_board}/${temp_file} ] && [ "$temp_file" != "defconfigs" ] && [ "$temp_file" != "configs" ];then
      #echo "  \c"
      #echo $temp_file
      ARRAY_CFG[$TOTAL_CFG]=$temp_file
      TOTAL_CFG=$TOTAL_CFG+1
    fi
  done
fi

# if filter==all || filter==cus, then include customer configs
# get all customer configs name from customer board folder
if [ "$1" == "cus" ] || [ "$1" == "all" ]
then
  filter=""
  if [ -e ${customer_folder} ];then
    for file in ${customer_folder}/*; do
      temp_file=`basename $file`
      if [ -d ${customer_folder}/${temp_file} ] && [ "$temp_file" != "defconfigs" ] && [ "$temp_file" != "configs" ];then
        #echo "  \c"
        #echo $temp_file
        ARRAY_CFG_C[$TOTAL_CFG_C]=$temp_file
        TOTAL_CFG_C=$TOTAL_CFG_C+1
      fi
    done
  fi
fi

echo "************************ START *************************"

# compile check start
# RESULT store compile result
declare RESULT=""
declare -i LOOP_NUM=0
# counter variables
declare -i PASS_COUNTER=0
declare -i FAIL_COUNTER=0

# print bar and alignment
declare -i BAR_TOTAL=30
declare -i BAR_LOOP

RESULT=$RESULT"########### Compile Check Result ###########\n"

if [ "$1" != "cus" ]
then
  RESULT=$RESULT"--------------------------------------------\n"
  RESULT=$RESULT"############## Amlogic Boards ##############\n"
  # loop all cfgs
  for cfg in ${ARRAY_CFG[@]}
  do
    # find filter in config name
    if [[ $(echo $cfg | grep "${filter}") == "" ]]
    then
      # skip !filter configs
      continue
    fi
    LOOP_NUM=$LOOP_NUM+1
    RESULT=$RESULT' '
    # print '0' charactors for alignment
    BAR_LOOP=3-`expr length $LOOP_NUM`
    if [ "$BAR_LOOP" -gt "0" ]
    then
      for tmp in `seq $BAR_LOOP`;do RESULT=$RESULT'0';done
    fi
    RESULT=$RESULT$LOOP_NUM' '
    RESULT=$RESULT$cfg' '
    # print '-' charactors for alignment
    BAR_LOOP=BAR_TOTAL-`expr length $cfg`
    if [ "$BAR_LOOP" -gt "0" ]
    then
      for tmp in `seq $BAR_LOOP`;do RESULT=$RESULT'-';done
    fi
    # compile
    make distclean
    make $cfg'_defconfig'
    make -j
    # check last 'make -j' result
    if [ $? != 0 ]
    then
      RESULT=$RESULT'- failed\n'
      FAIL_COUNTER=$FAIL_COUNTER+1
    else
      RESULT=$RESULT'- pass\n'
      PASS_COUNTER=$PASS_COUNTER+1
    fi
    # print result
    echo -e $RESULT
    #echo $cfg
  done
fi

# check customer configs
if [ "$1" == "cus" ] || [ "$1" == "all" ]
then
  RESULT=$RESULT"--------------------------------------------\n"
  RESULT=$RESULT"############## Customer Boards #############\n"
  for cfg in ${ARRAY_CFG_C[@]}
  do
    LOOP_NUM=$LOOP_NUM+1
    RESULT=$RESULT' '
    BAR_LOOP=3-`expr length $LOOP_NUM`
    if [ "$BAR_LOOP" -gt "0" ]
    then
      for tmp in `seq $BAR_LOOP`;do RESULT=$RESULT'0';done
    fi
    RESULT=$RESULT$LOOP_NUM' '
    RESULT=$RESULT$cfg' '
    BAR_LOOP=BAR_TOTAL-`expr length $cfg`
    if [ "$BAR_LOOP" -gt "0" ]
    then
      for tmp in `seq $BAR_LOOP`;do RESULT=$RESULT'-';done
    fi
    make distclean
    make $cfg'_defconfig'
    make -j
    if [ $? != 0 ]
    then
      RESULT=$RESULT'- failed\n'
      FAIL_COUNTER=$FAIL_COUNTER+1
    else
      RESULT=$RESULT'- pass\n'
      PASS_COUNTER=$PASS_COUNTER+1
    fi
    echo -e $RESULT
  done
fi

echo -e "#################### END ###################\n"