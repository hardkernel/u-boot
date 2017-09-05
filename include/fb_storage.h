/*
 * Based (loosely) on the Linux code
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#ifndef _FB_STORAGE_H_
#define _FB_STORAGE_H_

void fb_mmc_flash_write(const char *cmd, void *download_buffer,
			unsigned int download_bytes);
void fb_mmc_erase_write(const char *cmd, void *download_buffer);
#endif /* _FB_STORAGE_H_ */
