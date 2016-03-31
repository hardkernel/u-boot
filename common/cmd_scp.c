#include <config.h>
#include <common.h>
#include <asm/arch/io.h>
#include <command.h>
#include <malloc.h>
#include <asm/arch/mailbox.h>

static const char * const channel_names[] = {
	"command",
	"accel",
	"charger",
	"chipset",
	"clock",
	"dma",
	"events",
	"gesture",
	"gpio",
	"hostcmd",
	"i2c",
	"keyboard",
	"keyscan",
	"lidangle",
	"lightbar",
	"lpc",
	"motionlid",
	"motionsense",
	"pdhostcmd",
	"port80",
	"pwm",
	"spi",
	"switch",
	"system",
	"task",
	"thermal",
	"usb",
	"usbms",
	"usbcharge",
	"usbpd",
	"vboot",
	"hook",
};

int do_open_scp_log(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	int i = 0;
	for (i = 0;i < ARRAY_SIZE(channel_names); i++) {
		if (!strcmp(argv[1],channel_names[i]))
			break;
	}
	if (i < ARRAY_SIZE(channel_names)) {
		open_scp_log(1 << i);
		printf("open SCP channel %s log!\n",channel_names[i]);
	} else {
		printf("Error paramters\n");
		printf("open paramets is following:\n");
		for (i = 0;i < ARRAY_SIZE(channel_names); i++)
			printf("%s\n",channel_names[i]);
	}
	return 0;
}

U_BOOT_CMD(
	open_scp_log,	2,	1,	do_open_scp_log,
	"print SCP messgage",
	"print SCP log"
);
