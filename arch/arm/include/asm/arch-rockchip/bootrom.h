/*
 * (C) Copyright 2017 Heiko Stuebner <heiko@sntech.de>
 * (C) Copyright 2017 Theobroma Systems Design und Consulting GmbH
 *
 * SPDX-License-Identifier:	GPL-2.0
 */

#ifndef _ASM_ARCH_BOOTROM_H
#define _ASM_ARCH_BOOTROM_H

/*
 * Saved Stack pointer address.
 * Access might be needed in some special cases.
 */
extern u32 SAVE_SP_ADDR;

/**
 * back_to_bootrom() - return to bootrom (for TPL/SPL), passing a
 *                     result code
 *
 * Transfer control back to the Rockchip BROM, restoring necessary
 * register context and passing a command/result code to the BROM
 * to instruct its next actions (e.g. continue boot sequence, enter
 * download mode, ...).
 *
 * This function does not return.
 *
 * @brom_cmd: indicates how the bootrom should continue the boot
 *            sequence (e.g. load the next stage)
 */
enum rockchip_bootrom_cmd {
	/*
	* These can not start at 0, as 0 has a special meaning
	* for setjmp().
	*/

	BROM_BOOT_NEXTSTAGE = 1,  /* continue boot-sequence */
	BROM_BOOT_ENTER_DNL,      /* have BROM enter download-mode */
};

void back_to_bootrom(enum rockchip_bootrom_cmd brom_cmd);
#endif
