#ifndef VOUT_H
#define VOUT_H

#include <amlogic/vinfo.h>

#define VOUT_VIU1_SEL    1
#define VOUT_VIU2_SEL    2

enum viu_mux_e {
	VIU_MUX_ENCL = 0,
	VIU_MUX_ENCI,
	VIU_MUX_ENCP,
	VIU_MUX_MAX,
};

void vout_init(void);
void vout_vinfo_dump(void);
int vout_get_current_vmode(void);
int vout_get_current_axis(int *axis);
void vout_set_current_vmode(int mode);
struct vinfo_s *vout_get_current_vinfo(void);
extern void vout_viu_mux(int viu_sel, int venc_sel);
extern unsigned long get_fb_addr(void);
#endif

