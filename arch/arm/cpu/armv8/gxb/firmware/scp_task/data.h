#include "config.h"

#define __aligned(x)      __attribute__((aligned(x)))
#define TASK_COMMAND_OFFSET 0
#define TASK_RESPONSE_OFFSET  0x200

unsigned char high_task_share_mem[TASK_SHARE_MEM_SIZE]
	__attribute__ ((section("USER_HIGH_TASK_SHARE_MEMORY")))
	__aligned(1024);
unsigned char low_task_share_mem[TASK_SHARE_MEM_SIZE]
	__attribute__ ((section("USER_LOW_TASK_SHARE_MEMORY")))
	__aligned(1024);
