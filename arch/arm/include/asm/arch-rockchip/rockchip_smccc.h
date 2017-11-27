/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#ifndef __ROCKCHIP_SMCCC_H__
#define __ROCKCHIP_SMCCC_H__

/* Stand PSCI system suspend */
int psci_system_suspend(unsigned long unused);

int sip_smc_set_suspend_mode(unsigned long ctrl,
			     unsigned long config1,
			     unsigned long config2);
#endif
