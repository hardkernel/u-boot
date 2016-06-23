#include <common.h>
#include <errno.h>
#include <environment.h>
#include <asm/saradc.h>

inline int get_source_key(int channel)
{
	int adc_chan = channel;
    int adc_val = get_adc_sample_gxbb(adc_chan);
    //printf("get_source_key (%d) at channel (%d)\n", adc_val,adc_chan);
    return adc_val;
}

static void check_auto_update(void)
{
	int source_key_value = -1;
	int times=40;
	while (times--) {
		udelay(100000);
		source_key_value = get_source_key(0);
		if ((source_key_value >= 0) && (source_key_value < 40)) {
			//printk("press update key!\n");
		} else {
			return ;
		}
	}
	run_command ("run update", 0);
}

static void press_key_into_update(void)
{
	saradc_enable();
	check_auto_update();
	//saradc_disable();
}

static int do_forceupdate(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	press_key_into_update();
	return 0;
}

U_BOOT_CMD(
	forceupdate,	1,	1,	do_forceupdate,
	"forceupdate",
	"forceupdate - press adc key before power on\n"
);
