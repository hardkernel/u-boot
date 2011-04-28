#ifndef TVOUT_H
#define TVOUT_H

/* same to tv encoder */
enum
{
    TVOUT_480I  = 0,
    TVOUT_480CVBS,
    TVOUT_480P  ,
    TVOUT_576I  ,
    TVOUT_576CVBS,
    TVOUT_576P  ,
    TVOUT_720P  ,
    TVOUT_1080I ,
    TVOUT_1080P ,
    TVOUT_720P_50HZ,
    TVOUT_1080I_50HZ,
    TVOUT_1080P_50HZ,
    TVOUT_1080P_24HZ,
    TVOUT_4K2K_30HZ,
    TVOUT_4K2K_25HZ,
    TVOUT_4K2K_24HZ,
    TVOUT_4K2K_SMPTE,
    TVOUT_MAX   
};

typedef enum {
    VMODE_480I  = 0,
    VMODE_480CVBS,
    VMODE_480P  ,
    VMODE_576I   ,
    VMODE_576CVBS   ,
    VMODE_576P  ,
    VMODE_720P  ,
    VMODE_1080I ,
    VMODE_1080P ,
    VMODE_720P_50HZ ,
    VMODE_1080I_50HZ ,
    VMODE_1080P_50HZ ,
    VMODE_1080P_24HZ ,
    VMODE_4K2K_30HZ,
    VMODE_4K2K_25HZ,
    VMODE_4K2K_24HZ,
    VMODE_4K2K_SMPTE,
    VMODE_LCD   ,
    VMODE_MAX,
    VMODE_INIT_NULL,
} vmode_t;

typedef enum HDMI_Video_Type_ {
    HDMI_Unkown = 0 ,
    HDMI_640x480p60 = 1 ,
    HDMI_480p60,
    HDMI_480p60_16x9,
    HDMI_720p60,
    HDMI_1080i60,
    HDMI_480i60,
    HDMI_480i60_16x9,
    
    HDMI_1440x480p60 = 14 ,
    HDMI_1440x480p60_16x9 = 15 ,
    HDMI_1080p60 = 16,
    HDMI_576p50,
    HDMI_576p50_16x9,
    HDMI_720p50,
    HDMI_1080i50,
    HDMI_576i50,
    HDMI_576i50_16x9,
    HDMI_1080p50 = 31,
    HDMI_1080p24,
    HDMI_1080p25,
    HDMI_1080p30,
    HDMI_4k2k_30 = 68,  //tmp VIC
    HDMI_4k2k_25,
    HDMI_4k2k_24,
    HDMI_4k2k_smpte,
} HDMI_Video_Codes_t ;

#define TVOUT_VALID(m) (m < TVOUT_MAX)

int tv_out_open(int mode);
int tv_out_close(void);
int tv_out_cur_mode(void);
int tv_out_get_info(int mode, unsigned *width, unsigned *height);

typedef struct tv_operations {
	void  (*enable)(void);
	void  (*disable)(void);
	void  (*power_on)(void);
	void  (*power_off)(void);
} tv_operations_t;

extern tv_operations_t tv_oper;


#endif
