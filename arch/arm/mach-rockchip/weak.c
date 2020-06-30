/*
 * (C) Copyright 2020 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <boot_rkimg.h>
#include <misc.h>
#ifdef CONFIG_SPL_BUILD
#include <spl.h>
#endif
#include <optee_include/OpteeClientInterface.h>
#include <optee_include/tee_api_defines.h>

DECLARE_GLOBAL_DATA_PTR;

#if CONFIG_IS_ENABLED(FIT)

/*
 * Override __weak fit_board_verify_required_sigs() for SPL & U-Boot proper.
 */
int fit_board_verify_required_sigs(void)
{
	uint8_t vboot = 0;

#ifdef CONFIG_SPL_BUILD
#if defined(CONFIG_SPL_ROCKCHIP_SECURE_OTP) || \
    defined(CONFIG_SPL_ROCKCHIP_SECURE_OTP_V2)
	struct udevice *dev;

	dev = misc_otp_get_device(OTP_S);
	if (!dev)
		return 1;

	if (misc_otp_read(dev, 0, &vboot, 1)) {
		printf("Can't read verified-boot flag\n");
		return 1;
	}

	vboot = (vboot == 0xff);
#endif
#else /* !CONFIG_SPL_BUILD */
#ifdef CONFIG_OPTEE_CLIENT
	int ret;

	ret = trusty_read_vbootkey_enable_flag(&vboot);
	if (ret) {
		printf("Can't read verified-boot flag, ret=%d\n", ret);
		return 1;
	}
#endif
#endif /* CONFIG_SPL_BUILD*/

	printf("## Verified-boot: %d\n", vboot);

	return vboot;
}

#endif /* CONFIG_IS_ENABLED(FIT) */
