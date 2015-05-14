/*
  * High Priority Task share memory:		1K
  * Low Priority Task share memory:		1k
  * High Priority Task Entry						512
  * Low Priority Task Entry						512
  * Code, data, bss
  * Low Priority Task Stack						1K
  * High Priority Task Stack						1K
*/

#define CONFIG_RAM_BASE        (0x10000000 + 40 * 1024)
#define CONFIG_RAM_SIZE         (12 * 1024)

#define CONFIG_TASK_STACK_SIZE	1024
#define TASK_SHARE_MEM_SIZE	1024
