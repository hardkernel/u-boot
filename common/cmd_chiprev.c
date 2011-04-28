#include <common.h>
#include <command.h>

#define MX_REV_B_ID  (0x00000bbb)
#define MX_REV_D_ID  (0x00000d67)

int init_env_chiprev(void)
{
	char* rev = NULL;
	extern unsigned int aml_mx_get_id(); 
 
	switch (aml_mx_get_id()) {
	case MX_REV_B_ID:
		rev = "B";
		break;
	case MX_REV_D_ID:
		rev = "D";
		break;
	default: 
		break;
	}

	if (rev) {
		setenv("chiprev", rev);
		printf("chiprev is %s\n", rev);
	} else {
		setenv("chiprev", "B"); //B is the default value
		printf("default chiprev is B\n");
	}
}

static int do_chiprev(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	if (argc > 1) {
		cmd_usage(cmdtp);
		return -1;
	}
	
	init_env_chiprev();

	return 0;
}

U_BOOT_CMD(
	chiprev,	1,	0,	do_chiprev,
	"get the chip info",
	"chiprev"
);


