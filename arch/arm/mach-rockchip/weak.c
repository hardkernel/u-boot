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
 * Override __weak fit_rollback_index_verify() for SPL & U-Boot proper.
 */
#if CONFIG_IS_ENABLED(FIT_ROLLBACK_PROTECT)
int fit_rollback_index_verify(const void *fit, uint32_t rollback_fd,
			      uint32_t *fit_index, uint32_t *otp_index)
{
	int conf_noffset, ret;

	conf_noffset = fit_conf_get_node(fit, NULL); /* NULL for default conf */
	if (conf_noffset < 0)
		return conf_noffset;

	ret = fit_image_get_rollback_index(fit, conf_noffset, fit_index);
	if (ret) {
		printf("Failed to get rollback-index from FIT, ret=%d\n", ret);
		return ret;
	}

	ret = fit_read_otp_rollback_index(*fit_index, otp_index);
	if (ret) {
		printf("Failed to get rollback-index from otp, ret=%d\n", ret);
		return ret;
	}

	/* Should update rollback index to otp ! */
	if (*otp_index < *fit_index)
		gd->rollback_index = *fit_index;

	return 0;
}
#endif

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
