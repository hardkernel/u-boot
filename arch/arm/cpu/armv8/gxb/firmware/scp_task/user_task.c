#include "config.h"
#include "data.h"
#include "registers.h"
#include "task_apis.h"

#define TASK_ID_LOW_MB	2
#define TASK_ID_HIGH_MB	3
#define TASK_ID_SECURE_MB  4

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

extern void set_custom_gpio_status(void);

void secure_task(void)
{
	unsigned *pcommand =
	    (unsigned *)(&(secure_task_share_mem[TASK_COMMAND_OFFSET]));
	unsigned *response =
	    (unsigned *)(&(secure_task_share_mem[TASK_RESPONSE_OFFSET]));
 	unsigned command;
	struct resume_param *presume;
	unsigned int state;

	/*init bss */
	bss_init();
	dbg_prints("secure task start!\n");
	*pcommand = 0;

	while (1) {
		/* do secure task process */
		command = *pcommand;
		if (command) {
			dbg_print("process command ", command);

			/* set some gpios to intended status before power-off */
			set_custom_gpio_status();

			if (command == COMMAND_SUSPEND_ENTER) {
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
	unsigned *pcommand =
	    (unsigned *)(&(high_task_share_mem[TASK_COMMAND_OFFSET]));
/*	unsigned *response =
	    (unsigned *)(&(high_task_share_mem[TASK_RESPONSE_OFFSET]));
*/
	if (command == HIGH_TASK_SET_DVFS)
		set_dvfs(*(pcommand + 1), *(pcommand + 2));
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

void process_low_task(unsigned command)
{
	unsigned *pcommand =
	    (unsigned *)(&(low_task_share_mem[TASK_COMMAND_OFFSET]));
	unsigned *response =
	    (unsigned *)(&(low_task_share_mem[TASK_RESPONSE_OFFSET]));
	unsigned para1;

	if (command == LOW_TASK_GET_DVFS_INFO) {
		para1 = *(pcommand + 1);
		get_dvfs_info(para1,
			(unsigned char *)(response+2), (response+1));
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
