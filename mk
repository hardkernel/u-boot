#!/bin/bash

make SOC=gxb distclean
make $1'_config'
make -j

