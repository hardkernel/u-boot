#ifndef _VPP_INC_H_
#define _VPP_INC_H_

extern void vpp_init(void);
void vpp_pq_init(int brightness, int contrast, int sat, int hue);
void vpp_pq_load(void);

#define VPP_CM_RGB    0   /* same as COLOR_FMT_RGB444*/
#define VPP_CM_YUV    2   /* same as COLOR_FMT_YUV444*/

extern void vpp_matrix_update(int type);

enum vpp_gamma_sel_e {
	VPP_GAMMA_R = 0,
	VPP_GAMMA_G,
	VPP_GAMMA_B
};

extern void vpp_load_gamma_table(unsigned short *data, unsigned int len, enum vpp_gamma_sel_e flag);
extern void vpp_init_lcd_gamma_table(void);

#endif
