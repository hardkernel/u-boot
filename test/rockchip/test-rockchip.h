/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#ifndef _TEST_ROCKCHIP_H
#define _TEST_ROCKCHIP_H

int board_timer_test(int argc, char * const argv[]);
int board_key_test(int argc, char * const argv[]);
int board_emmc_test(int argc, char * const argv[]);
int board_regulator_test(int argc, char * const argv[]);
int board_rknand_test(int argc, char * const argv[]);
#if defined(CONFIG_GMAC_ROCKCHIP)
int board_eth_test(int argc, char * const argv[]);
#endif
#if defined(CONFIG_RK_IR)
int board_ir_test(int argc, char * const argv[]);
#endif
int board_brom_dnl_test(int argc, char * const argv[]);
#if defined(CONFIG_ROCKCHIP_VENDOR_PARTITION)
int board_vendor_storage_test(int argc, char * const argv[]);
#endif

#endif /* _TEST_ROCKCHIP_H */
