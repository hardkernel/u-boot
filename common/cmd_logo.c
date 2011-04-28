/*
 * Command for logo.
 *
 * Copyright (C) 2014 Amlogic.
 * Wenbiao Zhang
 * 2014.1.13
 */
#include <common.h>


static int do_logo_size(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
    if(argc < 2)
        return cmd_usage(cmdtp);
    
    char* mode = argv[1];
    if(mode != NULL) {
        int width, height, fbw, fbh;
        char buf[8];
        if(strncmp(mode, "480", 3) == 0) {
            width = 720;
            height = 480;
            fbw = 1280;
            fbh = 720;
        } else if(strncmp(mode, "576", 3) == 0) {
            width = 720;
            height = 576;
            fbw = 1280;
            fbh = 720;
        } else if(strncmp(mode, "720", 3) == 0) {
            width = 1280;
            height = 720;
            fbw = 1280;
            fbh = 720;
        } else if(strncmp(mode, "4k2ksmpte", 9) == 0) {
            width = 4096;
            height = 2160;    
            fbw = 1920;
            fbh = 1080;
        } else if(strncmp(mode, "4k2k", 4) == 0) {
            width = 3840;
            height = 2160;    
            fbw = 1920;
            fbh = 1080;
        } else {
            width = 1920;
            height = 1080;
            fbw = 1920;
            fbh = 1080;
        } 
        memset(buf, 0 , 8);
        sprintf(buf, "%d", width);
        setenv("display_width", buf);
        sprintf(buf, "%d", height);
        setenv("display_height", buf);
        sprintf(buf, "%d", fbw);
        setenv("fb_width", buf);
        sprintf(buf, "%d", fbh);
        setenv("fb_height", buf);
    }

    return 0;
}

static int do_logo_source(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
    if(argc < 2)
        return cmd_usage(cmdtp);
    
    char* mode = argv[1];
    if(mode != NULL) {
        int offset, size;
        char buf[12];
        if((strncmp(mode, "720", 3) == 0) || (strncmp(mode, "576", 3) == 0) || (strncmp(mode, "480", 3) == 0)) {
            offset = simple_strtoul(getenv("bootup_720_offset"), NULL, 16);
            size = simple_strtoul(getenv("bootup_720_size"), NULL, 16);
        } else {
            offset = simple_strtoul(getenv("bootup_1080_offset"), NULL, 16);
            size = simple_strtoul(getenv("bootup_1080_size"), NULL, 16);
        }   
        memset(buf, 0, 12);
        sprintf(buf, "0x%x", offset);
        setenv("bootup_offset", buf);
        sprintf(buf, "0x%x", size);
        setenv("bootup_size", buf);
    }

    return 0;
}

static cmd_tbl_t cmd_logo_sub[] = {
	U_BOOT_CMD_MKENT(size, 3, 0, do_logo_size, "", ""),
	U_BOOT_CMD_MKENT(source, 3, 0, do_logo_source, "", ""),
};

static int do_logo(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	cmd_tbl_t *c;

	/* Strip off leading 'bmp' command argument */
	argc--;
	argv++;

	c = find_cmd_tbl(argv[0], &cmd_logo_sub[0], ARRAY_SIZE(cmd_logo_sub));

	if (c) {
		return	c->cmd(cmdtp, flag, argc, argv);
	} else {
		cmd_usage(cmdtp);
		return 1;
	}
}

U_BOOT_CMD(
	logo,	8,	0,	do_logo,
	"logo sub-system",
	"size <mode>		- set display size by outputmode\n"
	"logo source <mode>	- choose bmp resource\n"
);



