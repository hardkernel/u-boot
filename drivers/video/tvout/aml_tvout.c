/*
 * Command for control tv out.
 *
 * Copyright (C) 2011 Amlogic.
 */
#include <common.h>


/********************************************************************************************
*
*										TVOUT
*
*********************************************************************************************/

#include <amlogic/aml_tv.h>
#include <amlogic/vinfo.h>


static void opt_cmd_help(void)
{
	printf("Help:\n");
	printf("tv sub-system\n");
#if CONFIG_AML_MESON_8
	printf("open <mode>	-open the tv out, mode is 4K2K30HZ/4K2K25HZ/4K2K24HZ/4K2KSMPTE/1080P24HZ\n1080P50HZ/1080I50HZ/720P50HZ/1080P/1080I/720P/576P/480P/576I/480I\n");
#endif
#if CONFIG_AML_MESON_6
	printf("open <mode>	-open the tv out, mode is 1080P24HZ/1080P50HZ/1080I50HZ/720P50HZ/1080P/1080I/720P/576P/480P/576I/480I\n");
#endif
	printf("close	-close the tv out\n");
	printf("info	-get current mode info\n");
	printf("tst <mode>	-test tv output, mode is 0-fix,1-colorbar,2-thinline,3-dotgrid\n");
}

static int to_mode(char *mode_name)
{
#if CONFIG_AML_MESON_8
	if((strcmp(mode_name, "4K2K30HZ")==0)||(strcmp(mode_name, "4k2k30hz")==0))
		return TVOUT_4K2K_30HZ;
	if((strcmp(mode_name, "4K2K25HZ")==0)||(strcmp(mode_name, "4k2k25hz")==0))
		return TVOUT_4K2K_25HZ;
	if((strcmp(mode_name, "4K2K24HZ")==0)||(strcmp(mode_name, "4k2k24hz")==0))
		return TVOUT_4K2K_24HZ;
	if((strcmp(mode_name, "4K2KSMPTE")==0)||(strcmp(mode_name, "4k2ksmpte")==0))
		return TVOUT_4K2K_SMPTE;
#endif
	if((strcmp(mode_name, "1080P")==0)||(strcmp(mode_name, "1080p")==0))
		return TVOUT_1080P;
	if((strcmp(mode_name, "1080I")==0)||(strcmp(mode_name, "1080i")==0))
		return TVOUT_1080I;
	if((strcmp(mode_name, "720P")==0)||(strcmp(mode_name, "720p")==0))
		return TVOUT_720P;
	if((strcmp(mode_name, "1080P24HZ")==0)||(strcmp(mode_name, "1080p24hz")==0))
		return TVOUT_1080P_24HZ;
	if((strcmp(mode_name, "1080P50HZ")==0)||(strcmp(mode_name, "1080p50hz")==0))
		return TVOUT_1080P_50HZ;
	if((strcmp(mode_name, "1080I50HZ")==0)||(strcmp(mode_name, "1080i50hz")==0))
		return TVOUT_1080I_50HZ;
	if((strcmp(mode_name, "720P50HZ")==0)||(strcmp(mode_name, "720p50hz")==0))
		return TVOUT_720P_50HZ;
	if((strcmp(mode_name, "576P")==0)||(strcmp(mode_name, "576p")==0))
		return TVOUT_576P;
	if((strcmp(mode_name, "480P")==0)||(strcmp(mode_name, "480p")==0))
		return TVOUT_480P;
	if((strcmp(mode_name, "576I")==0)||(strcmp(mode_name, "576i")==0))
		return TVOUT_576I;
	if((strcmp(mode_name, "480I")==0)||(strcmp(mode_name, "480i")==0))
		return TVOUT_480I;
	if((strcmp(mode_name, "576CVBS")==0)||(strcmp(mode_name, "576cvbs")==0))
		return TVOUT_576CVBS;
	if((strcmp(mode_name, "480CVBS")==0)||(strcmp(mode_name, "480cvbs")==0))
		return TVOUT_480CVBS;
    
	return TVOUT_MAX;
}

static char * to_modestr(int mode)
{
#define CASE_RET(_x_)	case TVOUT_##_x_: return #_x_

	switch(mode)
	{
#if CONFIG_AML_MESON_8
        CASE_RET(4K2K_30HZ);
        CASE_RET(4K2K_25HZ);
        CASE_RET(4K2K_24HZ);
        CASE_RET(4K2K_SMPTE);
#endif
		CASE_RET(1080P_24HZ);
		CASE_RET(1080P_50HZ);
		CASE_RET(1080I_50HZ);
		CASE_RET(720P_50HZ);
		CASE_RET(1080P);
		CASE_RET(1080I);
		CASE_RET(720P);
		CASE_RET(576P);
		CASE_RET(480P);
		CASE_RET(576I);
		CASE_RET(480I);
		default:
		    return "UNKNOWN";
	}
}

static int tvout_open(int argc, char *argv[])
{
	int mode;
	int ret;
#if CONFIG_AML_HDMI_TX
	extern void init_hdmi(void);
#endif
	extern void start_dsp(void);

	if (argc < 2)
		goto usage;

	mode = to_mode(argv[1]);
	if(mode == TVOUT_MAX)
		goto usage;

    tv_oper.enable();
#if CONFIG_AML_HDMI_TX
	init_hdmi();
#endif	
	ret = tv_out_open(mode);
	if (ret!=0) {
		printf("tv %s %s failed\n",argv[0], argv[1]);
		return 1;
	}
#if CONFIG_AML_MESON_6
	if(mode==TVOUT_1080I||mode==TVOUT_576I||mode==TVOUT_480I||
		mode == TVOUT_480CVBS ||mode == TVOUT_576CVBS){
		#ifdef CONFIG_DSP_VSYNC_INTERRUPT
		start_dsp();
		#endif
	}
#endif
	return 0;
usage:
#if CONFIG_AML_MESON_8
	puts("Usage: video dev open <mode>(4K2K30HZ/4K2K25HZ/4K2K24HZ/4K2KSMPTE/1080P24HZ\n1080P50HZ/1080I50HZ/720P50HZ/1080P/1080I/720P/576P/480P/576I/480I)\n");
#endif
#if CONFIG_AML_MESON_6
	puts("Usage: video dev open <mode>(1080P24HZ/1080P50HZ/1080I50HZ/720P50HZ/1080P/1080I/720P/576P/480P/576I/480I)\n");
#endif
	return 1;
}

static int tvout_close(int argc, char *argv[])
{
	int ret;

	ret = tv_out_close();
	if (ret!=0) {
		printf("tv %s failed\n", argv[0]);
		return 1;
	}

	return 0;
}

static int get_cur_info(int argc, char *argv[])
{
	int mode;

	mode = tv_out_cur_mode();
	printf("Current mode: %s\n", to_modestr(mode));
	
	return 0;
}

static int tvout_tst(int argc, char *argv[])
{
	int mode;
	int ret;
	char *endp;
	extern int tv_out_test(int);

	if (argc < 2)
		goto usage;

	mode = simple_strtoul(argv[1], &endp, 0);
	if (*argv[1] == 0 || *endp != 0)
		goto usage;

	ret = tv_out_test(mode);
	if (ret!=0) {
		printf("tv %s %s failed\n",argv[0], argv[1]);
		return 1;
	}

	return 0;

usage:
	puts("Usage: tv tst mode(0-fix,1-colorbar,2-thinline,3-dotgrid)\n");
	return 1;
}

int tvout_opt_cmd(int argc, char *argv[])
{
	if(argc < 1)
	{
		opt_cmd_help();
		return 1;
	}

	if (strcmp(argv[0], "open") == 0)
		return tvout_open(argc, argv);
	if (strcmp(argv[0], "close") == 0)
		return tvout_close(argc, argv);
	if (strcmp(argv[0], "info") == 0)
		return get_cur_info(argc, argv);
	if (strcmp(argv[0], "tst") == 0)
		return tvout_tst(argc, argv);

	opt_cmd_help();
	return 1;
}

