/*
 * Copyright (c) 2013-2014, ARM Limited and Contributors. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * Neither the name of ARM nor the names of its contributors may be used
 * to endorse or promote products derived from this software without specific
 * prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#include <arch.h>
#include <arch_helpers.h>
#include <assert.h>
#include <bl_common.h>
#include <fip.h>
#include <debug.h>
#include <platform.h>
#include <platform_def.h>
#include <stdio.h>
#include "bl2_private.h"
#include <console.h>
#include <plat_init.h>
extern unsigned int ddr_init(void);

/*******************************************************************************
 * The only thing to do in BL2 is to load further images and pass control to
 * BL31. The memory occupied by BL2 will be reclaimed by BL3_x stages. BL2 runs
 * entirely in S-EL1. Since arm standard c libraries are not PIC, printf et al
 * are not available. We rely on assertions to signal error conditions
 ******************************************************************************/
void bl2_main(void)
{
	pinmux_init();

	printf("\n\nBL2 %s.\n%s @ %s\n\n", build_message, CONFIG_SYS_CONFIG_NAME, PLAIN_VERSION);

	/* Perform remaining generic architectural setup in S-El1 */
	bl2_arch_setup();

	/* process usb burning case */
	if (BOOT_DEVICE_USB == get_boot_device()) {
		if (!get_ddr_size()) {
			ddr_init();
			printf("USB mode!\n");
			bl2_to_romcode(USB_BL2_RETURN_ROM_ADDR);
		}
	}
	else {
		ddr_init();
	}

	/* Perform platform setup in BL1 */
	bl2_platform_setup();

	/* Load images */
	bl2_load_image();

	printf("NEVER BE HERE\n");
	while (1);
}
