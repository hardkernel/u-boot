#ifndef TVOUT_H
#define TVOUT_H

#include "hdmi.h"

enum vmode {
	VMODE_480I = 0,
	VMODE_480CVBS,
	VMODE_480P,
	VMODE_576I,
	VMODE_576CVBS,
	VMODE_576P,
	VMODE_720P,
	VMODE_1080I,
	VMODE_1080P,
	VMODE_720P_50HZ,
	VMODE_1080I_50HZ,
	VMODE_1080P_50HZ,
	VMODE_1080P_24HZ,
	VMODE_4K2K_30HZ,
	VMODE_4K2K_25HZ,
	VMODE_4K2K_24HZ,
	VMODE_4K2K_SMPTE,
	/* timing same as 4k2k30hz, Vsync from 30hz to 50hz */
	VMODE_4K2K_FAKE_5G,
	VMODE_4K2K_60HZ, /* timing same as 4k2k30hz, Vsync from 30hz to 60hz */
	VMODE_4K2K_60HZ_Y420,
	VMODE_4K2K_50HZ, /* timing same as 4k2k25hz, Vsync from 25hz to 50hz */
	VMODE_4K2K_50HZ_Y420,
	VMODE_4K2K_5G,
	VMODE_VGA,
	VMODE_SVGA,
	VMODE_XGA,
	VMODE_SXGA,
	VMODE_WSXGA,
	VMODE_FHDVGA,
	VMODE_LCD,
	VMODE_LVDS_1080P,
	VMODE_LVDS_1080P_50HZ,
	VMODE_LVDS_768P,
	VMODE_MAX,
	VMODE_INIT_NULL,
	VMODE_MASK = 0xFF,
};

enum tvmode {
	TVMODE_480I = 0,
	TVMODE_480CVBS,
	TVMODE_480P,
	TVMODE_576I,
	TVMODE_576CVBS,
	TVMODE_576P,
	TVMODE_720P,
	TVMODE_1080I,
	TVMODE_1080P,
	TVMODE_720P_50HZ,
	TVMODE_1080I_50HZ,
	TVMODE_1080P_50HZ,
	TVMODE_1080P_24HZ,
	TVMODE_4K2K_30HZ,
	TVMODE_4K2K_25HZ,
	TVMODE_4K2K_24HZ,
	TVMODE_4K2K_SMPTE,
	TVMODE_4K2K_FAKE_5G,
	TVMODE_4K2K_60HZ,
	TVMODE_4K2K_60HZ_Y420,
	TVMODE_4K2K_50HZ,
	TVMODE_4K2K_50HZ_Y420,
	TVMODE_VGA,
	TVMODE_SVGA,
	TVMODE_XGA,
	TVMODE_SXGA,
	TVMODE_WSXGA,
	TVMODE_FHDVGA,
	TVMODE_MAX,
};

#define TVMODE_VALID(m) (m < TVMODE_MAX)

int tv_out_open(int mode);
int tv_out_close(void);
int tv_out_cur_mode(void);
int tv_out_get_info(int mode, unsigned *width, unsigned *height);

struct tv_operations {
	void (*enable)(void);
	void (*disable)(void);
	void (*power_on)(void);
	void (*power_off)(void);
};

struct reg_t {
	unsigned int reg;
	unsigned int val;
};

struct tvregs_set_t {
	enum tvmode tvmode;
	const struct reg_t *reg_setting;
};

struct tv_hdmi_set_t {
	enum hdmi_vic vic;
	const struct reg_t *reg_setting;
};

struct tvinfo_s {
	enum tvmode tvmode;
	unsigned int xres;
	unsigned int yres;
	const char *id;
};

#endif
