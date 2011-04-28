#include <common.h>
//#include <asm/arch/am_reg_addr.h>
#include <asm/arch/clock.h>

#include <config.h>


#include <asm/arch/dsp_state.h>

static int dsp_machine=0;

static int tv_check_dsp_status(int argc, char *argv[])
{
	unsigned int dsp_status=0;
	int count;

	printf("check func:argc:%d\n",argc);
	if (argc < 2)
		goto usage;

	//dsp_machine = 0;
	for(count=0;count<1000;count++)
	{
		dsp_status = read_reg(P_AO_RTI_STATUS_REG0);
		if(dsp_status == DSP_CURRENT_RUN)
		{
			dsp_machine = 1;
			printf("dsp is runing\n");
			break;
		}
		else if(dsp_status == DSP_REQUST_START)
		{	//continue;
		}
		else
		{
			break;
		}
	}
	if(dsp_status != DSP_CURRENT_RUN)
	{
		printf("dsp is not start\n");
	}
	return 0;

usage:
	return 1;
}

static int tv_request_stop_dsp(int argc, char *argv[])
{
	unsigned int dsp_status=0;
	if(dsp_machine == 1)
	{
		write_reg(P_AO_RTI_STATUS_REG0, DSP_REQUST_STOP);
		printf("request stop dsp\n");
		while(1)
		{
			dsp_status = read_reg(P_AO_RTI_STATUS_REG0);
			if(dsp_status == DSP_CURRENT_SLEEP)
			{
				write_reg(P_AO_RTI_STATUS_REG0, DSP_CURRENT_END);
				printf("dsp was sleep\n");
				break;
			}
		}
		dsp_machine = 0;
		stop_dsp();
		return 0;
	}
	printf("dsp is not using\n");
	return 1;
}

static int tv_request_start_dsp(int argc, char *argv[])
{
	if(dsp_machine == 0){
		start_dsp();
		printf("start dsp \n");
		return 0;
	}
	printf("start dsp fail dsp_machine:%d\n",dsp_machine);
	return 1;
}
static int do_tvdsp(cmd_tbl_t *cmdtp, int flag, int argc, char *argv[])
{
	const char *cmd;
	cmd = argv[1];

	printf("test tvdsp\n");
	printf("%s\n",cmd);
	if (strcmp(cmd, "start") == 0)
		return tv_request_start_dsp(argc,argv);
	if (strcmp(cmd, "check") == 0)
		return tv_check_dsp_status(argc,argv);
	if (strcmp(cmd, "stop") == 0)
		return tv_request_stop_dsp(argc,argv);

	cmd_usage(cmdtp);
	return 1;
}

U_BOOT_CMD(
	tvdsp, 8, 0, do_tvdsp,
	"dspv sub-system",
	"check dsp\n"
	"                - check dsp(arc) is running\n"
	"tvdsp stop      - request stop dsp(arc)\n"
);




