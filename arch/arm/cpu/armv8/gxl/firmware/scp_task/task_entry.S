#include "config.h"
#include "registers.h"

.text
.syntax unified
.code 16

	.global task_entry
.thumb_func
task_entry:
	b secure_task
	b high_task
	b low_task

.section .bss_stack.usr_stack
usr_stack:
.space 3*CONFIG_TASK_STACK_SIZE
