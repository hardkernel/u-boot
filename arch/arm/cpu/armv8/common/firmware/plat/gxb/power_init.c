
#ifdef CONFIG_PLATFORM_POWER_INIT
#include "power.c"
#else
void __attribute__((weak)) power_init(int mode)
{
	/*
	 * fake function for platform without power init
	 */
}
#endif

void platform_power_init(int mode)
{
	power_init(mode);
}
