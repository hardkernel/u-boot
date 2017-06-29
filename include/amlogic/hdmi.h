#ifndef __HDMI_H__
#define __HDMI_H__

/* Little-Endian format */
enum scdc_addr {
	SINK_VER = 0x01,
	SOURCE_VER, /* RW */
	UPDATE_0 = 0x10, /* RW */
	UPDATE_1, /* RW */
	TMDS_CFG = 0x20, /* RW */
	SCRAMBLER_ST,
	CONFIG_0 = 0x30, /* RW */
	STATUS_FLAGS_0 = 0x40,
	STATUS_FLAGS_1,
	ERR_DET_0_L = 0x50,
	ERR_DET_0_H,
	ERR_DET_1_L,
	ERR_DET_1_H,
	ERR_DET_2_L,
	ERR_DET_2_H,
	ERR_DET_CHKSUM,
	TEST_CONFIG_0 = 0xC0, /* RW */
	MANUFACT_IEEE_OUI_2 = 0xD0,
	MANUFACT_IEEE_OUI_1,
	MANUFACT_IEEE_OUI_0,
	DEVICE_ID = 0xD3, /* 0xD3 ~ 0xDD */
	/* RW   0xDE ~ 0xFF */
	MANUFACT_SPECIFIC = 0xDE,
};

#define HDMITX_VIC420_OFFSET	0x100
#define HDMITX_VESA_OFFSET	0x300

/* HDMI VIC definitions */
enum hdmi_vic {
	/* Refer to CEA 861-D */
	HDMI_unkown = 0,
	HDMI_640x480p60_4x3 = 1,
	HDMI_720x480p60_4x3 = 2,
	HDMI_720x480p60_16x9 = 3,
	HDMI_1280x720p60_16x9 = 4,
	HDMI_1920x1080i60_16x9 = 5,
	HDMI_720x480i60_4x3 = 6,
	HDMI_720x480i60_16x9 = 7,
	HDMI_720x240p60_4x3 = 8,
	HDMI_720x240p60_16x9 = 9,
	HDMI_2880x480i60_4x3 = 10,
	HDMI_2880x480i60_16x9 = 11,
	HDMI_2880x240p60_4x3 = 12,
	HDMI_2880x240p60_16x9 = 13,
	HDMI_1440x480p60_4x3 = 14,
	HDMI_1440x480p60_16x9 = 15,
	HDMI_1920x1080p60_16x9 = 16,
	HDMI_720x576p50_4x3 = 17,
	HDMI_720x576p50_16x9 = 18,
	HDMI_1280x720p50_16x9 = 19,
	HDMI_1920x1080i50_16x9 = 20,
	HDMI_720x576i50_4x3 = 21,
	HDMI_720x576i50_16x9 = 22,
	HDMI_720x288p_4x3 = 23,
	HDMI_720x288p_16x9 = 24,
	HDMI_2880x576i50_4x3 = 25,
	HDMI_2880x576i50_16x9 = 26,
	HDMI_2880x288p50_4x3 = 27,
	HDMI_2880x288p50_16x9 = 28,
	HDMI_1440x576p_4x3 = 29,
	HDMI_1440x576p_16x9 = 30,
	HDMI_1920x1080p50_16x9 = 31,
	HDMI_1920x1080p24_16x9 = 32,
	HDMI_1920x1080p25_16x9 = 33,
	HDMI_1920x1080p30_16x9 = 34,
	HDMI_2880x480p60_4x3 = 35,
	HDMI_2880x480p60_16x9 = 36,
	HDMI_2880x576p50_4x3 = 37,
	HDMI_2880x576p50_16x9 = 38,
	HDMI_1920x1080i_t1250_50_16x9 = 39,
	HDMI_1920x1080i100_16x9 = 40,
	HDMI_1280x720p100_16x9 = 41,
	HDMI_720x576p100_4x3 = 42,
	HDMI_720x576p100_16x9 = 43,
	HDMI_720x576i100_4x3 = 44,
	HDMI_720x576i100_16x9 = 45,
	HDMI_1920x1080i120_16x9 = 46,
	HDMI_1280x720p120_16x9 = 47,
	HDMI_720x480p120_4x3 = 48,
	HDMI_720x480p120_16x9 = 49,
	HDMI_720x480i120_4x3 = 50,
	HDMI_720x480i120_16x9 = 51,
	HDMI_720x576p200_4x3 = 52,
	HDMI_720x576p200_16x9 = 53,
	HDMI_720x576i200_4x3 = 54,
	HDMI_720x576i200_16x9 = 55,
	HDMI_720x480p240_4x3 = 56,
	HDMI_720x480p240_16x9 = 57,
	HDMI_720x480i240_4x3 = 58,
	HDMI_720x480i240_16x9 = 59,
	/* Refet to CEA 861-F */
	HDMI_1280x720p24_16x9 = 60,
	HDMI_1280x720p25_16x9 = 61,
	HDMI_1280x720p30_16x9 = 62,
	HDMI_1920x1080p120_16x9 = 63,
	HDMI_1920x1080p100_16x9 = 64,
	HDMI_1280x720p24_64x27 = 65,
	HDMI_1280x720p25_64x27 = 66,
	HDMI_1280x720p30_64x27 = 67,
	HDMI_1280x720p50_64x27 = 68,
	HDMI_1280x720p60_64x27 = 69,
	HDMI_1280x720p100_64x27 = 70,
	HDMI_1280x720p120_64x27 = 71,
	HDMI_1920x1080p24_64x27 = 72,
	HDMI_1920x1080p25_64x27 = 73,
	HDMI_1920x1080p30_64x27 = 74,
	HDMI_1920x1080p50_64x27 = 75,
	HDMI_1920x1080p60_64x27 = 76,
	HDMI_1920x1080p100_64x27 = 77,
	HDMI_1920x1080p120_64x27 = 78,
	HDMI_1680x720p24_64x27 = 79,
	HDMI_1680x720p25_64x27 = 80,
	HDMI_1680x720p30_64x27 = 81,
	HDMI_1680x720p50_64x27 = 82,
	HDMI_1680x720p60_64x27 = 83,
	HDMI_1680x720p100_64x27 = 84,
	HDMI_1680x720p120_64x27 = 85,
	HDMI_2560x1080p24_64x27 = 86,
	HDMI_2560x1080p25_64x27 = 87,
	HDMI_2560x1080p30_64x27 = 88,
	HDMI_2560x1080p50_64x27 = 89,
	HDMI_2560x1080p60_64x27 = 90,
	HDMI_2560x1080p100_64x27 = 91,
	HDMI_2560x1080p120_64x27 = 92,
	HDMI_3840x2160p24_16x9 = 93,
	HDMI_3840x2160p25_16x9 = 94,
	HDMI_3840x2160p30_16x9 = 95,
	HDMI_3840x2160p50_16x9 = 96,
	HDMI_3840x2160p60_16x9 = 97,
	HDMI_4096x2160p24_256x135 = 98,
	HDMI_4096x2160p25_256x135 = 99,
	HDMI_4096x2160p30_256x135 = 100,
	HDMI_4096x2160p50_256x135 = 101,
	HDMI_4096x2160p60_256x135 = 102,
	HDMI_3840x2160p24_64x27 = 103,
	HDMI_3840x2160p25_64x27 = 104,
	HDMI_3840x2160p30_64x27 = 105,
	HDMI_3840x2160p50_64x27 = 106,
	HDMI_3840x2160p60_64x27 = 107,
	HDMI_RESERVED = 108,
	/*
	the following vic is for those y420 mode
	they are all beyond OFFSET_HDMITX_VIC420(0x1000)
	and they has same vic with normal vic in the lower bytes.
	*/
	HDMI_VIC_Y420 =	HDMITX_VIC420_OFFSET,
	HDMI_3840x2160p50_16x9_Y420 =
		HDMITX_VIC420_OFFSET + HDMI_3840x2160p50_16x9,
	HDMI_3840x2160p60_16x9_Y420 =
		HDMITX_VIC420_OFFSET + HDMI_3840x2160p60_16x9,
	HDMI_4096x2160p50_256x135_Y420 =
		HDMITX_VIC420_OFFSET + HDMI_4096x2160p50_256x135,
	HDMI_4096x2160p60_256x135_Y420 =
		HDMITX_VIC420_OFFSET + HDMI_4096x2160p60_256x135,
	HDMI_3840x2160p50_64x27_Y420 =
		HDMITX_VIC420_OFFSET + HDMI_3840x2160p50_64x27,
	HDMI_3840x2160p60_64x27_Y420 =
		HDMITX_VIC420_OFFSET + HDMI_3840x2160p60_64x27,
	HDMIV_640x480p60hz = HDMITX_VESA_OFFSET,
	HDMIV_800x480p60hz,
	HDMIV_800x600p60hz,
	HDMIV_852x480p60hz,
	HDMIV_854x480p60hz,
	HDMIV_1024x600p60hz,
	HDMIV_1024x768p60hz,
	HDMIV_1152x864p75hz,
	HDMIV_1280x600p60hz,
	HDMIV_1280x768p60hz,
	HDMIV_1280x800p60hz,
	HDMIV_1280x960p60hz,
	HDMIV_1280x1024p60hz,
	HDMIV_1360x768p60hz,
	HDMIV_1366x768p60hz,
	HDMIV_1400x1050p60hz,
	HDMIV_1440x900p60hz,
	HDMIV_1600x900p60hz,
	HDMIV_1600x1200p60hz,
	HDMIV_1680x1050p60hz,
	HDMIV_1920x1200p60hz,
	HDMIV_2160x1200p90hz,
	HDMIV_2560x1080p60hz,
	HDMIV_2560x1440p60hz,
	HDMIV_2560x1600p60hz,
	HDMIV_3440x1440p60hz,
};

/* CEA TIMING STRUCT DEFINITION */
struct hdmi_cea_timing {
	unsigned int pixel_freq; /* Unit: 1000 */
	unsigned int h_freq; /* Unit: Hz */
	unsigned int v_freq; /* Unit: 0.001 Hz */
	unsigned int vsync_polarity:1; /* 1: positive  0: negative */
	unsigned int hsync_polarity:1;
	unsigned short h_active;
	unsigned short h_total;
	unsigned short h_blank;
	unsigned short h_front;
	unsigned short h_sync;
	unsigned short h_back;
	unsigned short v_active;
	unsigned short v_total;
	unsigned short v_blank;
	unsigned short v_front;
	unsigned short v_sync;
	unsigned short v_back;
	unsigned short v_sync_ln;
};

/* Refer CEA861-D Page 116 Table 55 */
struct dtd {
	unsigned short pixel_clock;
	unsigned short h_active;
	unsigned short h_blank;
	unsigned short v_active;
	unsigned short v_blank;
	unsigned short h_sync_offset;
	unsigned short h_sync;
	unsigned short v_sync_offset;
	unsigned short v_sync;
	unsigned char h_image_size;
	unsigned char v_image_size;
	unsigned char h_border;
	unsigned char v_border;
	unsigned char flags;
	enum hdmi_vic vic;
};

#define VIC_MAX_NUM 256
struct rx_cap {
	unsigned int native_Mode;
	/*video*/
	unsigned int VIC[VIC_MAX_NUM];
	unsigned int VIC_count;
	unsigned int native_VIC;
	/*vendor*/
	unsigned int IEEEOUI;
	unsigned int Max_TMDS_Clock1; /* HDMI1.4b TMDS_CLK */
	unsigned int HF_IEEEOUI;	/* For HDMI Forum */
	unsigned int Max_TMDS_Clock2; /* HDMI2.0 TMDS_CLK */
	/* CEA861-F, Table 56, Colorimetry Data Block */
	unsigned int colorimetry_data;
	unsigned int scdc_present:1;
	unsigned int scdc_rr_capable:1; /* SCDC read request */
	unsigned int lte_340mcsc_scramble:1;
	unsigned int dc_y444:1;
	unsigned int dc_30bit:1;
	unsigned int dc_36bit:1;
	unsigned int dc_48bit:1;
	unsigned int dc_30bit_420:1;
	unsigned int dc_36bit_420:1;
	unsigned int dc_48bit_420:1;
	unsigned char edid_version;
	unsigned char edid_revision;
	unsigned int ColorDeepSupport;
	unsigned int Video_Latency;
	unsigned int Audio_Latency;
	unsigned int Interlaced_Video_Latency;
	unsigned int Interlaced_Audio_Latency;
	unsigned int threeD_present;
	unsigned int threeD_Multi_present;
	unsigned int hdmi_vic_LEN;
	enum hdmi_vic preferred_mode;
	struct dtd dtd[16];
	unsigned char dtd_idx;
	unsigned char flag_vfpdb;
	unsigned char number_of_dtd;
	unsigned char pref_colorspace;
	/*blk0 check sum*/
	unsigned char chksum;
};

enum hdmi_color_depth {
	HDMI_COLOR_DEPTH_24B = 4,
	HDMI_COLOR_DEPTH_30B = 5,
	HDMI_COLOR_DEPTH_36B = 6,
	HDMI_COLOR_DEPTH_48B = 7,
};

enum hdmi_color_format {
	HDMI_COLOR_FORMAT_RGB,
	HDMI_COLOR_FORMAT_444,
	HDMI_COLOR_FORMAT_422,
	HDMI_COLOR_FORMAT_420,
};

enum hdmi_color_range {
	HDMI_COLOR_RANGE_LIM,
	HDMI_COLOR_RANGE_FUL,
};

enum hdmi_audio_packet {
	HDMI_AUDIO_PACKET_SMP = 0x02,
	HDMI_AUDIO_PACKET_1BT = 0x07,
	HDMI_AUDIO_PACKET_DST = 0x08,
	HDMI_AUDIO_PACKET_HBR = 0x09,
};

/* get hdmi cea timing
 * t: struct hdmi_cea_timing *
 */
#define GET_TIMING(name) (t->name)

struct parse_cd {
	enum hdmi_color_depth cd;
	const char *name;
};

struct parse_cs {
	enum hdmi_color_format cs;
	const char *name;
};

struct parse_cr {
	enum hdmi_color_format cr;
	const char *name;
};

#define EDID_BLK_NO	4
#define EDID_BLK_SIZE	128
struct hdmi_format_para {
	enum hdmi_vic vic;
	char *name; /* full name, 1280x720p60hz */
	char *sname; /* short name, 1280x720p60hz -> 720p60hz */
	char ext_name[32];
	enum hdmi_color_depth cd; /* cd8, cd10 or cd12 */
	enum hdmi_color_format cs; /* rgb, y444, y422, y420 */
	enum hdmi_color_range cr; /* limit, full */
	unsigned int pixel_repetition_factor;
	unsigned int progress_mode:1; /* 0: Interlace  1: Progressive */
	unsigned int scrambler_en:1;
	unsigned int tmds_clk_div40:1;
	unsigned int tmds_clk; /* Unit: 1000 */
	struct hdmi_cea_timing timing;
};

struct hdmi_support_mode {
	enum hdmi_vic vic;
	char *sname;
	char y420;
};

struct hdmitx_dev {
	unsigned char rx_edid[512]; /* some RX may exceeds 256Bytes */
	struct {
		int (*get_hpd_state)(void);
		int (*read_edid)(unsigned char *buf, unsigned char addr,
				 unsigned char blk_no);
		void (*turn_off)(void);
		void (*list_support_modes)(void);
		void (*dump_regs)(void);
		void (*test_bist)(unsigned int mode);
		void (*output_blank)(unsigned int blank);
	} HWOp;
	unsigned char rawedid[EDID_BLK_SIZE * EDID_BLK_NO];
	struct rx_cap RXCap;
	struct hdmi_format_para *para;
	enum hdmi_vic vic;
	unsigned int frac_rate_policy;
	unsigned int mode420;
	unsigned int dc30;
};

struct hdmi_format_para *hdmi_get_fmt_paras(enum hdmi_vic vic);
enum hdmi_vic hdmi_get_fmt_vic(char const *name);
void hdmi_parse_attr(struct hdmi_format_para *para, char const *name);
void hdmi_tx_set(struct hdmitx_dev *hdev);
/* Parsing RAW EDID data from edid to pRXCap */
unsigned int hdmi_edid_parsing(unsigned char *edid, struct rx_cap *pRXCap);
struct hdmi_format_para *hdmi_match_dtd_paras(struct dtd *t);

/*
 * Must be called at uboot
 */
void hdmi_tx_init(void);

extern struct hdmitx_dev hdmitx_device;

#ifndef printk
#define printk printf
#endif
#ifndef pr_info
#define pr_info printf
#endif

#define hdmitx_debug() /* printf("hd: %s[%d]\n", __func__, __LINE__) */

#endif
