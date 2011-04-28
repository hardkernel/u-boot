/*
 * Command for SARADC.
 *
 * Copyright (C) 2012 Amlogic.
 * Elvis Yu <elvis.yu@amlogic.com>
 */

#include <common.h>
#include <command.h>
#include <asm/saradc.h>

#define SARADC_VALUE "saradc_val"


static int current_channel = -1;

static int do_saradc_open(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	int channel;
	
	channel = simple_strtoul(argv[1], NULL, 10);
	if((channel<0) || (channel>=AML_ADC_SARADC_CHAN_NUM))
	{
		printf("No such channel(%d) in SARADC! open failed!\n", channel);
		return -1;
	}
	saradc_enable();
	current_channel = channel;
//	printf("SARADC open channel(%d).\n", channel);
	
	return 0;
}

static int do_saradc_close(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	
	saradc_disable();
	current_channel = -1;
	printf("SARADC closed.\n");
	return 0;
}

static int do_saradc_getval(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	char value_str[10];
	int val = get_adc_sample(current_channel);
	printf("SARADC channel(%d) is 0x%x.\n", current_channel, val);
	sprintf(value_str, "0x%x", val);
	setenv(SARADC_VALUE, value_str);
	return 0;
}

static int do_saradc_get_in_range(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	char value_str[10];
	int max, min;
	int val = get_adc_sample(current_channel);
	min = simple_strtoul(argv[1], NULL, 10);
	max = simple_strtoul(argv[2], NULL, 10);
	int donot_setenv = 0;
	if(argc > 3){
		donot_setenv = simple_strtoul(argv[2], NULL, 10);
	}
	if((val<min) || (val>max))
	{
		debug("SARADC channel(%d) is 0x%x, Out of range(0x%x~0x%x)!\n",
			current_channel, val, min, max);
		return -1;
	}
	debug("SARADC channel(%d) is 0x%x (0x%x~0x%x).\n",
		current_channel, val, min, max);
	sprintf(value_str, "0x%x", val);
	if(!donot_setenv)
		setenv(SARADC_VALUE, value_str);
	return 0;
}

static cmd_tbl_t cmd_saradc_sub[] = {
	U_BOOT_CMD_MKENT(open, 2, 0, do_saradc_open, "", ""),
	U_BOOT_CMD_MKENT(close, 1, 0, do_saradc_close, "", ""),
	U_BOOT_CMD_MKENT(getval, 1, 0, do_saradc_getval, "", ""),
	U_BOOT_CMD_MKENT(get_in_range, 3, 0, do_saradc_get_in_range, "", ""),
};


static int do_saradc(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	cmd_tbl_t *c;

	/* Strip off leading 'bmp' command argument */
	argc--;
	argv++;

	c = find_cmd_tbl(argv[0], &cmd_saradc_sub[0], ARRAY_SIZE(cmd_saradc_sub));

	if (c) {
		return	c->cmd(cmdtp, flag, argc, argv);
	} else {
		cmd_usage(cmdtp);
		return 1;
	}
}

U_BOOT_CMD(
	saradc,	8,	0,	do_saradc,
	"saradc sub-system",
	"saradc open <channel>		- open a SARADC channel\n"
	"saradc close	- close the SARADC\n"
	"saradc getval	- get the value in current channel\n"
	"saradc get_in_range <min> <max>	- return 0 if current value in the range of current channel\n"
);


