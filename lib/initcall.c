/*
 * Copyright (c) 2013 The Chromium OS Authors.
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <initcall.h>
#include <efi.h>

DECLARE_GLOBAL_DATA_PTR;

#define SYS_TICKS_TO_US(ticks)	 ((ticks) / (COUNTER_FREQUENCY / 1000000))

#ifdef DEBUG
static inline void call_get_ticks(ulong *ticks) { *ticks = get_ticks(); }
#else
static inline void call_get_ticks(ulong *ticks) { }
#endif

int initcall_run_list(const init_fnc_t init_sequence[])
{
	const init_fnc_t *init_fnc_ptr;
	__maybe_unused ulong start = 0, end = 0;

	for (init_fnc_ptr = init_sequence; *init_fnc_ptr; ++init_fnc_ptr) {
		unsigned long reloc_ofs = 0;
		int ret;

		if (gd->flags & GD_FLG_RELOC)
			reloc_ofs = gd->reloc_off;
#ifdef CONFIG_EFI_APP
		reloc_ofs = (unsigned long)image_base;
#endif
		debug("initcall: %p", (char *)*init_fnc_ptr - reloc_ofs);
		if (gd->flags & GD_FLG_RELOC)
			debug(" (relocated to %p)\n", (char *)*init_fnc_ptr);
		else
			debug("\n");
		call_get_ticks(&start);
		ret = (*init_fnc_ptr)();
		call_get_ticks(&end);
		if (start != end)
			debug("\t\t\t\t\t\t\t\t#%6ld us\n", SYS_TICKS_TO_US(end - start));
		if (ret) {
			printf("initcall sequence %p failed at call %p (err=%d)\n",
			       init_sequence,
			       (char *)*init_fnc_ptr - reloc_ofs, ret);
			return -1;
		}
	}
	return 0;
}
