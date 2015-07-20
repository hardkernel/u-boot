#ifndef __CVBS_H__
#define __CVBS_H__

void cvbs_show_valid_vmode(void);
int cvbs_set_vmode(char* vmode_name);
int cvbs_set_bist(char* bist_mode);
int cvbs_set_vdac(int status);
int cvbs_reg_debug(int argc, char* const argv[]);

#endif

