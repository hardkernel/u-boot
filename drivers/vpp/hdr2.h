#ifndef __HDR2_H__
#define __HDR2_H__

enum hdr_module_sel {
	VD1_HDR = 0x1,
	VD2_HDR = 0x2,
	OSD1_HDR = 0x4,
	VDIN0_HDR = 0x8,
	VDIN1_HDR = 0x10,
	DI_HDR = 0x20,
	HDR_MAX
};

enum hdr_matrix_sel {
	HDR_IN_MTX = 0x1,
	HDR_GAMUT_MTX = 0x2,
	HDR_OUT_MTX = 0x4,
	HDR_MTX_MAX
};

enum hdr_lut_sel {
	HDR_EOTF_LUT = 0x1,
	HDR_OOTF_LUT = 0x2,
	HDR_OETF_LUT = 0x4,
	HDR_CGAIN_LUT = 0x8,
	HDR_LUT_MAX
};

enum hdr_process_sel {
	HDR_BYPASS = 0x1,
	HDR_SDR = 0x2,
	SDR_HDR = 0x4,
	HLG_BYPASS = 0x8,
	HLG_SDR = 0x10,
	HLG_HDR = 0x20,
	SDR_HLG = 0X40,
	HDRPLUS_SDR = 0x80,
	HDR_p_MAX
};


#define MTX_ON  1
#define MTX_OFF 0

#define MTX_ONLY  1
#define HDR_ONLY  0

#define LUT_ON  1
#define LUT_OFF 0

#define HDR2_EOTF_LUT_SIZE 143
#define HDR2_OOTF_LUT_SIZE 149
#define HDR2_OETF_LUT_SIZE 149
#define HDR2_CGAIN_LUT_SIZE 65

struct hdr_proc_mtx_param_s {
	int mtx_only;
	int mtx_in[15];
	int mtx_gamut[9];
	int mtx_cgain[15];
	int mtx_ogain[15];
	int mtx_out[15];
	unsigned int mtx_on;
	enum hdr_process_sel p_sel;
};

struct hdr_proc_lut_param_s {
	int eotf_lut[143];
	int oetf_lut[149];
	int ogain_lut[149];
	int cgain_lut[65];
	unsigned int lut_on;
	unsigned int bitdepth;
	unsigned int cgain_en;
};

extern void hdr_func(enum hdr_module_sel module_sel,
	enum hdr_process_sel hdr_process_select);

#endif
