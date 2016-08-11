#include "config.h"
#include "data.h"
#include "registers.h"
#include "task_apis.h"
#include "suspend.h"


#define TASK_ID_LOW_MB	2
#define TASK_ID_HIGH_MB	3
#define TASK_ID_SECURE_MB  4
#define TASK_ID_LOW_TIMER  9

enum scpi_client_id {
	SCPI_CL_NONE,
	SCPI_CL_CLOCKS,
	SCPI_CL_DVFS,
	SCPI_CL_POWER,
	SCPI_CL_THERMAL,
	SCPI_CL_REMOTE,
	SCPI_CL_LED_TIMER,
	SCPI_MAX,
};

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

void __switch_back_low_timer(void)
{
	register int p0 asm("r0") = 2;
	register int p1 asm("r1") = TASK_ID_LOW_TIMER;

	asm("svc 0" :  : "r"(p0), "r"(p1));
}

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

unsigned int test_usr_pwr_key=0;
static struct scp_led *g_led = 0;
void scp_led_register(struct scp_led *led)
{
	g_led = led;
}
unsigned int scan_remote_key[1] ={0x5A5A5A5A};
struct user_data {
	unsigned int status;
#define MAX_DVFS_OPPS		16
	unsigned int count;
	unsigned int buf1[MAX_DVFS_OPPS];
} buf_user;

void process_low_task(unsigned command)
{
	unsigned *pcommand =
	    (unsigned *)(&(low_task_share_mem[TASK_COMMAND_OFFSET]));
	unsigned *response =
	    (unsigned *)(&(low_task_share_mem[TASK_RESPONSE_OFFSET]));
	unsigned para1;
	unsigned *irq = (unsigned *)SCP_SHARE_TO_WARMBOOT;
	uart_puts("into process_low_task \n");

	if (command == LOW_TASK_GET_DVFS_INFO) {
		para1 = *(pcommand + 1);
		get_dvfs_info(para1,
			(unsigned char *)(response+2), (response+1));
	} else if ((command & 0xffff) == LOW_TASK_USR_DATA) {//0-15bit: comd; 16-31bit: client_id
		uart_puts("into LOW_TASK_USR_DATA \n");
		if ((command >> 16) == SCPI_CL_POWER) {
			test_usr_pwr_key = *(pcommand + 2);
			dbg_print("test_usr_pwr_key=",test_usr_pwr_key);
		}
		else if ((command >> 16) == SCPI_CL_LED_TIMER) {
			para1 = *(pcommand + 4); /*size locates at *(pcommand + 1), para2 is ledmode*/
			if (g_led && g_led->init) {
				g_led->init(para1);
				g_led->count = 0;
			}
			dbg_print("LED timer. ledmode=0x", para1);
		}
	}
	else if(command == LOW_TASK_USR_LED_TIMER) {
		/*You can add your led op here.*/
		if (g_led && g_led->timer_proc)
			g_led->timer_proc(g_led->count++);
		dbg_prints("LED timer...\n");
	}else if ((command & 0xffff) == LOW_TASK_GET_USR_DATA) {
		if ((command >> 16) == SCPI_CL_POWER) {
			buf_user.count = 1;
			buf_user.buf1[0] = irq[IRQ_AO_IR_DEC];
			*(response + 1) = sizeof(struct user_data);
			memcpy((char *)(response+2), &buf_user, sizeof(struct user_data));
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
		dbg_print("low command=0x\n", command);
		if (command) {
			process_low_task(command);

			*pcommand = 0;
			*response = 0;
		}
		__switch_back_lowmb();
	}
}
