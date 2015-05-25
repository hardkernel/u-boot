#include "config.h"
#include "data.h"
#include "registers.h"
#include "task_apis.h"

#define TASK_ID_LOW_MB	3
#define TASK_ID_HIGH_MB	4
#define TASK_ID_SECURE_MB  5

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
	unsigned *pcommand =
	    (unsigned *)(&(secure_task_share_mem[TASK_COMMAND_OFFSET]));
	unsigned *response =
	    (unsigned *)(&(secure_task_share_mem[TASK_RESPONSE_OFFSET]));
	unsigned command;

	/*init bss */
	bss_init();
	dbg_prints("secure task start!\n");
	*pcommand = 0;

	while (1) {
		/* do secure task process */
		command = *pcommand;
		if (command) {
			dbg_print("process command ", command);

			if (command == COMMAND_SUSPEND_ENTER) {
				enter_suspend();
				*pcommand = 0;
				*response = RESPONSE_SUSPEND_LEAVE;
			}
	}
		__switch_back_highmb();
	}
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
			dbg_print("process command ", command);

			*pcommand = 0;
			*response = 0;
		}
		__switch_back_highmb();
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
			dbg_print("process command ", command);

			*pcommand = 0;
			*response = 0;
		}
		__switch_back_lowmb();
	}
}
