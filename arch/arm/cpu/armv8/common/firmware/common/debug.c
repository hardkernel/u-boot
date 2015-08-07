/*
 * Copyright (c) 2014, ARM Limited and Contributors. All rights reserved.
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
#include <serial.h>
#include <debug.h>
#include <stdio.h>

/******************************************************************
* This function is invoked from assembler error handling routines and
* prints out the string and the value in 64 bit hex format. These
* are passed to the function as input parameters.
********************************************************************/
void print_string_value(char *s, unsigned long *mem)
{
	unsigned char i, temp;
	unsigned long val;

	while (*s) {
		i = 16;
		while (*s)
			serial_putc(*s++);

		s++;

		serial_putc('\t');
		serial_putc(':');
		serial_putc('0');
		serial_putc('x');

		val = *mem++;

		while (i--) {
			temp = (val >> (i << 2)) & 0xf;
			if (temp <  0xa)
				serial_putc('0' + temp);
			else
				serial_putc('A' + (temp - 0xa));
		}
		serial_putc('\n');
	}
}

/***********************************************************
 * The common implementation of do_panic for all BL stages
 ***********************************************************/

#if DEBUG
void __dead2 do_panic(const char *file, int line)
{
		serial_puts("PANIC in file: ");
		serial_puts(file);
		serial_puts(" line: ");
		serial_put_dec(line);
		serial_puts("\n");
		while (1)
			;
}
#else
void __dead2 do_panic(void)
{
	unsigned long pc_reg;
	__asm__ volatile("mov %0, x30\n"
					: "=r" (pc_reg) : );

	/* x30 reports the next eligible instruction whereas we want the
	 * place where panic() is invoked. Hence decrement by 4.
	 */
	//printf("PANIC in PC location 0x%016X\n", pc_reg - 0x4);
	serial_puts("PANIC in PC location 0x");
	serial_put_hex(pc_reg - 0x4, 64);
	serial_puts("\n");
	while (1)
		;

}
#endif
