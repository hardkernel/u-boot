#ifndef __ODROID_COMMON_H
#define __ODROID_COMMON_H

extern int load_from_mmc(unsigned long addr, int devnum, int partnum, char *filename);
extern int load_from_cramfs(unsigned long addr, char *filename);

extern int set_panel_name(const char *name);

#endif
