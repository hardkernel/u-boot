/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <asm/arch/rockchip_smccc.h>
#include <asm/io.h>
#include <asm/psci.h>
#include <asm/suspend.h>
#include <linux/arm-smccc.h>

#ifdef CONFIG_ARM64
#define ARM_PSCI_1_0_SYSTEM_SUSPEND	ARM_PSCI_1_0_FN64_SYSTEM_SUSPEND
#else
#define ARM_PSCI_1_0_SYSTEM_SUSPEND	ARM_PSCI_1_0_FN_SYSTEM_SUSPEND
#endif

/* Rockchip platform SiP call ID */
#define SIP_SUSPEND_MODE		0x82000003

static struct arm_smccc_res __invoke_sip_fn_smc(unsigned long function_id,
						unsigned long arg0,
						unsigned long arg1,
						unsigned long arg2)
{
	struct arm_smccc_res res;

	arm_smccc_smc(function_id, arg0, arg1, arg2, 0, 0, 0, 0, &res);
	return res;
}

int psci_system_suspend(unsigned long unused)
{
	struct arm_smccc_res res;

	res = __invoke_sip_fn_smc(ARM_PSCI_1_0_SYSTEM_SUSPEND,
				  virt_to_phys(cpu_resume), 0, 0);
	return res.a0;
}

int sip_smc_set_suspend_mode(unsigned long ctrl,
			     unsigned long config1,
			     unsigned long config2)
{
	struct arm_smccc_res res;

	res = __invoke_sip_fn_smc(SIP_SUSPEND_MODE, ctrl, config1, config2);
	return res.a0;
}
