
/*
 * arch/arm/cpu/armv8/txl/firmware/scp_task/task_apis.h
 *
 * Copyright (C) 2015 Amlogic, Inc. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

#ifndef __TASK_APIS_H_
#define __TASK_APIS_H_

void secure_task(void);
void high_task(void);
void low_task(void);

void bss_init(void);

int uart_putc(int c);
void wait_uart_empty(void);
void uart_put_hex(unsigned int data, unsigned bitlen);
int uart_puts(const char *s);

/* #define dbg_print(s,v) */
/* #define dbg_prints(s) */
#define writel(v, addr) (*((volatile unsigned *)(addr)) = v)
#define readl(addr) (*((volatile unsigned *)(addr)))

#define dbg_print(s, v) {uart_puts(s); uart_put_hex(v, 32); uart_puts("\n"); }
/* #define dbg_prints(s)  {uart_puts(s);wait_uart_empty();} */
#define dbg_prints(s)  {uart_puts(s); }

void enter_suspend(unsigned int suspend_from);
void get_dvfs_info(unsigned int domain,
		unsigned char *info_out, unsigned int *size_out);
void set_dvfs(unsigned int domain, unsigned int index);
void *memcpy(void *dest, const void *src, unsigned int count);
void *memset(void *s, int c, unsigned int count);
void _udelay(unsigned int us);
unsigned int get_time(void);

void set_wakeup_method(unsigned int method);
void suspend_pwr_ops_init(void);
void suspend_get_wakeup_source(void *reponse, unsigned int suspend_from);
#endif
