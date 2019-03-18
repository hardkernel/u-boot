/*
 * (C) Copyright 2019 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#ifndef __ROCKCHIP_PARAM_H_
#define __ROCKCHIP_PARAM_H_

#include <memblk.h>

/**
 * param_parse_ddr_mem() - Parse ddr memory region
 *
 * @out_count: valid count of memblock for memblock list.
 * @return memblock structure list which contains base and size info.
 */
struct memblock *param_parse_ddr_mem(int *out_count);

/**
 * param_parse_atf_mem() - Parse atf memory region
 *
 * @return memblock structure which contains base and size info.
 */
struct memblock param_parse_atf_mem(void);

/**
 * param_parse_atf_mem() - Parse op-tee memory region
 *
 * @return memblock structure which contains base and size info.
 */
struct memblock param_parse_optee_mem(void);

/**
 * param_parse_atf_mem() - Parse platform common reserved memory region
 *
 * @return memblock structure which contains base and size info.
 */
struct memblock param_parse_common_resv_mem(void);

/**
 * param_parse_bootdev() - Parse boot device info.
 *
 * @devtype: out data to store dev type
 * @devnum: out data to store dev number
 *
 * @return 0 on success, otherwise failed.
 */
int param_parse_bootdev(char **devtype, char **devtnum);

#endif
