/*
 * Copyright (C) 2017 Rockchip Electronic Co.,Ltd
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <linux/linkage.h>
#include <asm/assembler.h>

ENTRY(spl_optee_entry)
	ldr lr, =CONFIG_SYS_TEXT_BASE
	ldr r1, =CONFIG_SYS_TEXT_BASE
	mov pc, r3
ENDPROC(spl_optee_entry)
