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
 * Override __weak board_fit_image_post_process() for SPL & U-Boot proper.
 */
#if CONFIG_IS_ENABLED(FIT_IMAGE_POST_PROCESS)

#define FIT_UNCOMP_HASH_NODENAME	"digest"
static int fit_image_check_uncomp_hash(const void *fit, int parent_noffset,
				       const void *data, size_t size)
{
	const char *name;
	char *err_msgp;
	int noffset;

	fdt_for_each_subnode(noffset, fit, parent_noffset) {
		name = fit_get_name(fit, noffset, NULL);
		if (!strncmp(name, FIT_UNCOMP_HASH_NODENAME,
			     strlen(FIT_UNCOMP_HASH_NODENAME))) {
			return fit_image_check_hash(fit, noffset, data,
						    size, &err_msgp);
		}
	}

	return 0;
}

#if CONFIG_IS_ENABLED(MISC_DECOMPRESS) || CONFIG_IS_ENABLED(GZIP)
static int fit_gunzip_image(void *fit, int node, ulong *load_addr,
			    ulong **src_addr, size_t *src_len)
{
#if CONFIG_IS_ENABLED(MISC_DECOMPRESS)
	const void *prop;
#endif
	u64 len = *src_len;
	int ret;
	u8 comp;

	if (fit_image_get_comp(fit, node, &comp))
		return 0;

	if (comp != IH_COMP_GZIP)
		return 0;

#ifndef CONFIG_SPL_BUILD
	/* handled late in bootm_decomp_image() */
	if (fit_image_check_type(fit, node, IH_TYPE_KERNEL))
		return 0;
#endif
	/*
	 * For smaller spl size, we don't use misc_decompress_process()
	 * inside the gunzip().
	 */
#if CONFIG_IS_ENABLED(MISC_DECOMPRESS)
	ret = misc_decompress_process((ulong)(*load_addr),
				      (ulong)(*src_addr), (ulong)(*src_len),
				      DECOM_GZIP, false, &len);
#else
	ret = gunzip((void *)(*load_addr), ALIGN(len, SZ_1M),
		     (void *)(*src_addr), (void *)(&len));
#endif
	if (ret) {
		printf("%s: decompress error, ret=%d\n",
		       fdt_get_name(fit, node, NULL), ret);
		return ret;
	}

	/* check uncompressed data hash */
	ret = fit_image_check_uncomp_hash(fit, node, (void *)(*load_addr), len);
	if (!ret)
		puts("+ ");
	else
		return ret;

	*src_addr = (ulong *)*load_addr;
	*src_len = len;

#if CONFIG_IS_ENABLED(MISC_DECOMPRESS)
	/* mark for misc_decompress_cleanup() */
	prop = fdt_getprop(fit, node, "decomp-async", NULL);
	if (prop)
		misc_decompress_async(comp);
	else
		misc_decompress_sync(comp);
#endif

	return 0;
}
#endif

void board_fit_image_post_process(void *fit, int node, ulong *load_addr,
				  ulong **src_addr, size_t *src_len)
{
#if CONFIG_IS_ENABLED(MISC_DECOMPRESS) || CONFIG_IS_ENABLED(GZIP)
	fit_gunzip_image(fit, node, load_addr, src_addr, src_len);
#endif

#if CONFIG_IS_ENABLED(USING_KERNEL_DTB)
	/* Avoid overriding processed(overlay, hw-dtb, ...) kernel dtb */
	if (fit_image_check_type(fit, node, IH_TYPE_FLATDT) &&
	    !fdt_check_header(gd->fdt_blob)) {
		*src_addr = (void *)gd->fdt_blob;
		*src_len = (size_t)fdt_totalsize(gd->fdt_blob);
	}
#endif
}
#endif /* FIT_IMAGE_POST_PROCESS */

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
