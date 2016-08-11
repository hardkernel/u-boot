
/*
  * BL301 whole memory : 16KB

  * Secure Priority Task Entry					128B
  * High Priority Task Entry						128B
  * Low Priority Task Entry						128B

  * Code, data, bss

  * Secure Task share memory:				1k
  * High Priority Task share memory:		1K
  * Low Priority Task share memory:		1k
*/

#define CONFIG_RAM_BASE        (0x10000000 + 40 * 1024)
#define CONFIG_RAM_SIZE         (13 * 1024)
#define CONFIG_RAM_END		(CONFIG_RAM_BASE+CONFIG_RAM_SIZE)

#define CONFIG_TASK_STACK_SIZE	1024
#define TASK_SHARE_MEM_SIZE	1024

#define SECURE_TASK_SHARE_MEM_BASE		0x1000D400
#define SECURE_TASK_RESPONSE_MEM_BASE 0x1000D600
#define HIGH_TASK_SHARE_MEM_BASE			0x1000D800
#define HIGH_TASK_RESPONSE_MEM_BASE		0x1000DA00
#define LOW_TASK_SHARE_MEM_BASE			0x1000DC00
#define LOW_TASK_RESPONSE_MEM_BASE		0x1000DE00

/*
  * BL30/BL301 share memory command list
*/
#define COMMAND_SUSPEND_ENTER			0x1
#define HIGH_TASK_SET_CLOCK	0x2
#define LOW_TASK_GET_DVFS_INFO 0x3
#define HIGH_TASK_GET_DVFS 0x4
#define HIGH_TASK_SET_DVFS 0x5

	/*bl301 resume to BL30*/
#define RESPONSE_SUSPEND_LEAVE			0x1
