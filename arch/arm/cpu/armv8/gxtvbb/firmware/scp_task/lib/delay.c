#define P_EE_TIMER_E		(*((volatile unsigned *)(0xc1100000 + (0x2662 << 2))))
#define P_AO_TIMER_E		(*((volatile unsigned *)(0xc8100000 + (0x15 << 2))))
#define P_EE_TIMER_CTRL		(*((volatile unsigned *)(0xc8100000 + (0x13 << 2))))

unsigned int get_time(void)
{
	return P_AO_TIMER_E;
}
void _udelay(unsigned int us)
{
	unsigned int t0 = get_time();
	P_EE_TIMER_CTRL |= (0x1 << 4);

	while (get_time() - t0 <= us * 24)
		;
}

