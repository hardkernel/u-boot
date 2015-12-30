#ifndef VOUT_H
#define VOUT_H

#include <amlogic/vinfo.h>

void vout_init(void);
void vout_vinfo_dump(void);
int vout_get_current_vmode(void);
int vout_get_current_axis(int *axis);
void vout_set_current_vmode(int mode);
vidinfo_t *vout_get_current_vinfo(void);
extern unsigned long get_fb_addr(void);
#endif

