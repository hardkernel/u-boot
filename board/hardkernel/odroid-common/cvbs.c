#include <common.h>
#include <odroid-common.h>

int board_cvbs_probe()
{
	int i;
	int val = 0;
	int probed;

	for (i = 0; i < 10; i++)
		val += get_adc_value(0);
	val /= i;

	debug("CVBS cable loopback = %d\n", val);

	probed = (val > 190) ? 0 : 1;
	setenv_ulong("cvbscable", probed);

	return probed;
}
