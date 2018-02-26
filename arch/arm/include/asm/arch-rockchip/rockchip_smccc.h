/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#ifndef __ROCKCHIP_SMCCC_H__
#define __ROCKCHIP_SMCCC_H__

/* Rockchip platform SiP call ID */
#define SIP_ATF_VERSION			0x82000001
#define SIP_ACCESS_REG			0x82000002
#define SIP_SUSPEND_MODE		0x82000003
#define SIP_PENDING_CPUS		0x82000004
#define SIP_UARTDBG_CFG			0x82000005
#define SIP_UARTDBG_CFG64		0xc2000005
#define SIP_MCU_EL3FIQ_CFG		0x82000006
#define SIP_ACCESS_CHIP_STATE64		0xc2000006
#define SIP_SECURE_MEM_CONFIG		0x82000007
#define SIP_ACCESS_CHIP_EXTRA_STATE64	0xc2000007
#define SIP_DRAM_CONFIG			0x82000008
#define SIP_SHARE_MEM			0x82000009
#define SIP_SIP_VERSION			0x8200000a
#define SIP_REMOTECTL_CFG		0x8200000b
#define PSCI_SIP_VPU_RESET		0x8200000c

/* Rockchip Sip version */
#define SIP_IMPLEMENT_V1                (1)
#define SIP_IMPLEMENT_V2                (2)

/* Error return code */
#define IS_SIP_ERROR(x)			(!!(x))

#define SIP_RET_SUCCESS			0
#define SIP_RET_SMC_UNKNOWN		-1
#define SIP_RET_NOT_SUPPORTED		-2
#define SIP_RET_INVALID_PARAMS		-3
#define SIP_RET_INVALID_ADDRESS		-4
#define SIP_RET_DENIED			-5

/* SIP_ACCESS_REG: read or write */
#define SECURE_REG_RD			0x0
#define SECURE_REG_WR			0x1

/* Share mem page types */
typedef enum {
	SHARE_PAGE_TYPE_INVALID = 0,
	SHARE_PAGE_TYPE_UARTDBG,
	SHARE_PAGE_TYPE_DDR,
	SHARE_PAGE_TYPE_MAX,
} share_page_type_t;

/* Stand PSCI system suspend */
int psci_system_suspend(unsigned long unused);

/* Rockchip SMC Calls */
int sip_smc_set_suspend_mode(unsigned long ctrl,
			     unsigned long config1,
			     unsigned long config2);

struct arm_smccc_res sip_smc_dram(unsigned long arg0,
				  unsigned long arg1,
				  unsigned long arg2);

struct arm_smccc_res sip_smc_request_share_mem(unsigned long page_num,
					       share_page_type_t page_type);

int sip_smc_set_sip_version(unsigned long version);
struct arm_smccc_res sip_smc_get_sip_version(void);
int psci_cpu_on(unsigned long cpuid, unsigned long entry_point);

#endif
