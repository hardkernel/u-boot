#include "config.h"
#include "registers.h"
#include "task_apis.h"

void high_task_entry(void) __attribute__ ((section("USER_HIGH_ENTRY_POINT")));
void low_task_entry(void) __attribute__ ((section("USER_LOW_ENTRY_POINT")));

void high_task_entry(void)
{
	high_task();
}

void low_task_entry(void)
{
	low_task();
}
