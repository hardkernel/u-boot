#ifndef _VPU_INC_H_
#define _VPU_INC_H_

extern void vcbus_test(void);
extern int vpu_probe(void);
extern int vpu_remove(void);
extern int vpu_clk_change(int level);
extern void vpu_clk_get(void);

#endif
