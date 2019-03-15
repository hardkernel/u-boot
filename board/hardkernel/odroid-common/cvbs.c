#include <common.h>
#include <odroid-common.h>

#include <amlogic/hdmi.h>

int board_cvbs_probe()
{
	int i;
	int val = 0;
	int probed;

	/* no probe when HDMI is connected */
	if (hdmitx_device.HWOp.get_hpd_state())
		return 0;

	for (i = 0; i < 10; i++)
		val += get_adc_value(0);
	val /= i;

	debug("CVBS cable loopback = %d\n", val);

	probed = ((0x50 <= val) && (val <= 0xf0));
	setenv_ulong("cvbscable", probed);

	return probed;
}
