#!/bin/bash

make distclean
make $1'_config'
make -j

