#ifndef TVOUT_H
#define TVOUT_H

#define TVOUT_VALID(m) (m < TVOUT_MAX)

int tv_out_open(int mode);
int tv_out_close(void);
int tv_out_cur_mode(void);
int tv_out_get_info(int mode, unsigned *width, unsigned *height);

#endif


