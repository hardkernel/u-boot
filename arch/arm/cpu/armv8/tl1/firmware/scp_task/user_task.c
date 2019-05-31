
/*
 * arch/arm/cpu/armv8/txl/firmware/scp_task/user_task.c
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

#include <config.h>
#include "config.h"
#include "data.h"
#include "registers.h"
#include "task_apis.h"

#define TASK_ID_IDLE 0
#define TASK_ID_LOW_MB	3
#define TASK_ID_HIGH_MB	4
#define TASK_ID_SECURE_MB  5

enum scpi_client_id {
	SCPI_CL_NONE,
	SCPI_CL_CLOCKS,
	SCPI_CL_DVFS,
	SCPI_CL_POWER,
	SCPI_CL_THERMAL,
	SCPI_CL_REMOTE,
	SCPI_MAX,
};

void __switch_idle_task(void)
{
	register int p0 asm("r0") = 2;
	register int p1 asm("r1") = TASK_ID_IDLE;

	asm("svc 0" :  : "r"(p0), "r"(p1));
}
void __switch_back_securemb(void)
{
	register int p0 asm("r0") = 2;
	register int p1 asm("r1") = TASK_ID_SECURE_MB;

	asm("svc 0" :  : "r"(p0), "r"(p1));
}
void __switch_back_highmb(void)
{
	register int p0 asm("r0") = 2;
	register int p1 asm("r1") = TASK_ID_HIGH_MB;

	asm("svc 0" :  : "r"(p0), "r"(p1));
}

void __switch_back_lowmb(void)
{
	register int p0 asm("r0") = 2;
	register int p1 asm("r1") = TASK_ID_LOW_MB;

	asm("svc 0" :  : "r"(p0), "r"(p1));
}

void secure_task(void)
{
	volatile unsigned *pcommand =
	    (unsigned *)(&(secure_task_share_mem[TASK_COMMAND_OFFSET]));
	volatile unsigned *response =
	    (unsigned *)(&(secure_task_share_mem[TASK_RESPONSE_OFFSET]));
	unsigned command;
	struct resume_param *presume;
	unsigned int state;

	/*init bss */
	bss_init();
	dbg_prints("secure task start!\n");

	/* suspend pwr ops init*/
	suspend_pwr_ops_init();
	*pcommand = 0;

	while (1) {
		/* do secure task process */
		command = *pcommand;
		if (command) {
			dbg_print("process command ", command);
			if (command == SEC_TASK_GET_WAKEUP_SRC) {
				state = *(pcommand+1);
				suspend_get_wakeup_source(
						(void *)response,  state);
			} else if (command == COMMAND_SUSPEND_ENTER) {
				state = *(pcommand+1);
				enter_suspend(state);
				*pcommand = 0;
				*response = RESPONSE_SUSPEND_LEAVE;
				presume = (struct resume_param *)(response+1);
				presume->method = resume_data.method;
			}
	}
		__switch_back_securemb();
	}
}

void set_wakeup_method(unsigned int method)
{
	resume_data.method = method;
}

void process_high_task(unsigned command)
{
	return;
	/*unsigned *pcommand =
	    (unsigned *)(&(high_task_share_mem[TASK_COMMAND_OFFSET]));*/
}

void high_task(void)
{
	unsigned *pcommand =
	    (unsigned *)(&(high_task_share_mem[TASK_COMMAND_OFFSET]));
	unsigned *response =
	    (unsigned *)(&(high_task_share_mem[TASK_RESPONSE_OFFSET]));
	unsigned command;

	dbg_prints("high task start!\n");
	*pcommand = 0;

	while (1) {
		/* do high task process */
		command = *pcommand;
		if (command) {
			/*dbg_print("process command ", command);*/
			process_high_task(command);
			*pcommand = 0;
			*response = 0;
		}
		__switch_back_highmb();
	}
}

extern unsigned int usr_pwr_key;
#ifdef CONFIG_SUPPORT_CUSOTMER_LOW_TASK
extern void process_customer_low_task(unsigned int, unsigned int *, unsigned int *);
#endif
void process_low_task(unsigned command)
{
	unsigned *pcommand =
	    (unsigned *)(&(low_task_share_mem[TASK_COMMAND_OFFSET]));
#ifdef CONFIG_SUPPORT_CUSOTMER_LOW_TASK
	unsigned *response =
	    (unsigned *)(&(low_task_share_mem[TASK_RESPONSE_OFFSET]));
#endif

	if ((command & 0xffff) == LOW_TASK_USR_DATA) {/*0-15bit: comd; 16-31bit: client_id*/
		if ((command >> 16) == SCPI_CL_REMOTE) {
			usr_pwr_key = *(pcommand + 2);/*tx_size locates at *(pcommand + 1)*/
			dbg_print("pwr_key=",usr_pwr_key);
		} else {
#ifdef CONFIG_SUPPORT_CUSOTMER_LOW_TASK
			process_customer_low_task(command, pcommand, response);
#endif
		}
	}
}

void low_task(void)
{
	unsigned *pcommand =
	    (unsigned *)(&(low_task_share_mem[TASK_COMMAND_OFFSET]));
	unsigned *response =
	    (unsigned *)(&(low_task_share_mem[TASK_RESPONSE_OFFSET]));
	unsigned command;

	*pcommand = 0;
	dbg_prints("low task start!\n");

	while (1) {
		/* do low task process */
		command = *pcommand;
		if (command) {
			process_low_task(command);

			*pcommand = 0;
			*response = 0;
		}
		__switch_back_lowmb();
	}
}
