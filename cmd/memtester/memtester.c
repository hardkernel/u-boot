/* SPDX-License-Identifier: GPL-2.0 */
/*
 * memtester version 4
 *
 * Very simple but very effective user-space memory tester.
 * Originally by Simon Kirby <sim@stormix.com> <sim@neato.org>
 * Version 2 by Charles Cazabon <charlesc-memtester@pyropus.ca>
 * Version 3 not publicly released.
 * Version 4 rewrite:
 * Copyright (C) 2004-2012 Charles Cazabon <charlesc-memtester@pyropus.ca>
 * Licensed under the terms of the GNU General Public License version 2 (only).
 * See the file COPYING for details.
 *
 */

#define __version__ "4.3.0"

#include <common.h>
#include <console.h>
#include "sizes.h"
#include "types.h"
#include "tests.h"

#define EXIT_FAIL_NONSTARTER    0x01
#define EXIT_FAIL_ADDRESSLINES  0x02
#define EXIT_FAIL_OTHERTEST     0x04

DECLARE_GLOBAL_DATA_PTR;

/* reserved sp size 1MB */
#define RESERVED_SP_SIZE	0x100000

struct test tests[] = {
	{"Random Value", test_random_value},
	{"Compare XOR", test_xor_comparison},
	{"Compare SUB", test_sub_comparison},
	{"Compare MUL", test_mul_comparison},
	{"Compare DIV", test_div_comparison},
	{"Compare OR", test_or_comparison},
	{"Compare AND", test_and_comparison},
	{"Sequential Increment", test_seqinc_comparison},
	{"Solid Bits", test_solidbits_comparison},
	{"Block Sequential", test_blockseq_comparison},
	{"Checkerboard", test_checkerboard_comparison},
	{"Bit Spread", test_bitspread_comparison},
	{"Bit Flip", test_bitflip_comparison},
	{"Walking Ones", test_walkbits1_comparison},
	{"Walking Zeroes", test_walkbits0_comparison},
#ifdef TEST_NARROW_WRITES
	{"8-bit Writes", test_8bit_wide_random},
	{"16-bit Writes", test_16bit_wide_random},
#endif
	{NULL, NULL}
};

int use_phys;
off_t physaddrbase;

static int do_memtester(cmd_tbl_t *cmdtp, int flag, int argc,
			char *const argv[])
{
	ul loop, i, j;
	ul buf_start;
	ul start_adr[2], length[2];
	ulv * bufa[2], *bufb[2];
	ul count[2];
	ul bufsize = 0;
	ul loops = 0;
	ul testenable = 0;
	int exit_code = 0;
	int abort = 0;

	printf("memtester version " __version__ " (%d-bit)\n", UL_LEN);
	printf("Copyright (C) 2001-2012 Charles Cazabon.\n");
	printf("Licensed under the GNU General Public License version 2 (only).\n");
	printf("\n");

	start_adr[0] = (size_t)gd->bd->bi_dram[0].start;
	if (gd->bd->bi_dram[1].start) {
		length[0] = (size_t)gd->bd->bi_dram[0].size;
		start_adr[1] = (size_t)gd->bd->bi_dram[1].start;
		length[1] = gd->start_addr_sp - RESERVED_SP_SIZE - start_adr[1];
		length[1] &= ~0xfff;
	} else {
		length[0] = gd->start_addr_sp - RESERVED_SP_SIZE - start_adr[0];
		length[0] &= ~0xfff;
		start_adr[1] = 0;
		length[1] = 0;
	}

	printf("available memory for test:\n");
	printf("	start		 end	length\n");
	printf("	0x%08lx - 0x%08lx 0x%08lx\n",
	       start_adr[0], start_adr[0] + length[0], length[0]);
	if (start_adr[1])
		printf("	0x%08lx - 0x%08lx 0x%08lx\n",
		       start_adr[1], start_adr[1] + length[1], length[1]);

	if (argc < 2)
		return CMD_RET_USAGE;

	if (strict_strtoul(argv[1], 0, &buf_start) < 0)
		return CMD_RET_USAGE;

	if (argc > 2)
		if (strict_strtoul(argv[2], 0, &bufsize) < 0)
			return CMD_RET_USAGE;

	if (argc > 3)
		if (strict_strtoul(argv[3], 0, &testenable) < 0)
			return CMD_RET_USAGE;

	if (argc > 4)
		if (strict_strtoul(argv[4], 0, &loops) < 0)
			return CMD_RET_USAGE;

	if (!bufsize) {
		/* test all memory */
		for (i = 0; i < 2; i++) {
			bufa[i] = (ulv *)start_adr[i];
			bufb[i] = (ulv *)(start_adr[i] + length[i] / 2);
			count[i] = length[i] / 2 / sizeof(ul);
		}
	} else {
		bufa[0] = (ulv *)buf_start;
		bufb[0] = (ulv *)(buf_start + bufsize / 2);
		count[0] = bufsize / 2 / sizeof(ul);
		bufa[1] = 0;
		if (start_adr[1]) {
			if (buf_start < start_adr[0] ||
			    (buf_start >= start_adr[0] + length[0] &&
			     buf_start < start_adr[1]) ||
			    ((buf_start + bufsize >
			      start_adr[0] + length[0]) &&
			     buf_start + bufsize < start_adr[1]) ||
			    (buf_start + bufsize >
			    start_adr[1] + length[1])) {
				printf("unavailable memory space\n");
				return CMD_RET_FAILURE;
			}
		} else {
			if (buf_start < start_adr[0] ||
			    (buf_start + bufsize >
			    start_adr[0] + length[0])) {
				printf("unavailable memory space\n");
				return CMD_RET_FAILURE;
			}
		}
	}

	for (loop = 1; ((!loops) || loop <= loops); loop++) {
		for (j = 0; j < 2; j++) {
			if (!bufa[j])
				continue;
			printf("testing:0x%lx - 0x%lx\n", (ul)bufa[j],
			       (ul)bufa[j] + count[j] * 2 * sizeof(ul));
			printf("Loop %lu", loop);
			if (loops)
				printf("/%lu", loops);
			printf(":\n");
			printf("  %-20s: ", "Stuck Address");
			if (!test_stuck_address(bufa[j], count[j] * 2))
				printf("ok\n");
			else
				exit_code |= EXIT_FAIL_ADDRESSLINES;
			for (i = 0;; i++) {
				if (!tests[i].name)
					break;
				/* If using a custom testenable, only run this
				 * test if the bit corresponding to this test
				 * was set by the user.
				 */
				if (testenable && (!((1 << i) & testenable)))
					continue;
				printf("  %-20s: ", tests[i].name);
				if (!tests[i].fp(bufa[j], bufb[j], count[j]))
					printf("ok\n");
				else
					exit_code |= EXIT_FAIL_OTHERTEST;
				if (ctrlc()) {
					abort = 1;
					break;
				}
			}
			printf("\n");
			if (abort)
				break;
		}
		if (abort)
			break;
	}
	if (exit_code & EXIT_FAIL_NONSTARTER)
		printf("Fail: EXIT_FAIL_NONSTARTER\n");
	if (exit_code & EXIT_FAIL_ADDRESSLINES)
		printf("Fail: EXIT_FAIL_ADDRESSLINES\n");
	if (exit_code & EXIT_FAIL_OTHERTEST)
		printf("Fail: EXIT_FAIL_OTHERTEST\n");

	printf("Done.\n");
	return 0;
}

U_BOOT_CMD(memtester, 5, 1, do_memtester,
	   "do memtester",
	   "[start length [testenable [loop]]]\n"
	   "start: start address, should be 4k align\n"
	   "length: test length, should be 4k align, if 0 testing full space\n"
	   "testenable[option]: enable pattern by set bit to 1, null or 0"
	   " enable all pattern\n"
	   "	bit0: Random Value\n"
	   "	bit1: Compare XOR\n"
	   "	bit2: Compare SUB\n"
	   "	bit3: Compare MUL\n"
	   "	bit4: Compare DIV\n"
	   "	bit5: Compare OR\n"
	   "	bit6: Compare AND\n"
	   "	bit7: Sequential Increment\n"
	   "	bit8: Solid Bits\n"
	   "	bit9: Block Sequential\n"
	   "	bit10: Checkerboard\n"
	   "	bit11: Bit Spread\n"
	   "	bit12: Bit Flip\n"
	   "	bit13: Walking Ones\n"
	   "	bit14: Walking Zeroes\n"
	   "	bit15: 8-bit Writes\n"
	   "	bit16: 16-bit Writes\n"
	   "	example: testenable=0x1000,enable Bit Flip only\n"
	   "loop[option]: testing loop, if 0 or null endless loop\n"
	   "example:\n"
	   "	memtester 0x200000 0x1000000: start address: 0x200000 length:"
	   "0x1000000, enable all pattern, endless loop\n"
	   "	memtester 0x200000 0x1000000 0x1000 100: start address:0x200000"
	   " length:0x1000000, Bit Flip only, loop 100 times\n"
	   "	memtester 0 0: testing full space\n");
