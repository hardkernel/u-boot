#ifndef _VPP_INC_H_
#define _VPP_INC_H_

extern void vpp_init(void);
void vpp_pq_init(int brightness, int contrast, int sat, int hue);
void vpp_pq_load(void);

#endif
