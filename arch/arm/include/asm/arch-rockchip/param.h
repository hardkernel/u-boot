/*
 * (C) Copyright 2019 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#ifndef __ROCKCHIP_PARAM_H_
#define __ROCKCHIP_PARAM_H_

#include <sysmem.h>

/**
 * param_parse_atf_mem() - Parse atf memory region
 *
 * @return sysmem_property structure which contains base and size info.
 */
struct sysmem_property param_parse_atf_mem(void);

/**
 * param_parse_atf_mem() - Parse op-tee memory region
 *
 * @return sysmem_property structure which contains base and size info.
 */
struct sysmem_property param_parse_optee_mem(void);

/**
 * param_parse_atf_mem() - Parse platform common reserved memory region
 *
 * @return sysmem_property structure which contains base and size info.
 */
struct sysmem_property param_parse_common_resv_mem(void);

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
