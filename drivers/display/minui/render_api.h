#ifndef _RENDER_API_H_
#define _RENDER_API_H_

#include "minui.h"

void set_fastboot_flag(int flag);
int screen_init(void);
void screen_uninit(void);
int gr_init_ext_font(const char* font, GRFont** dest);
int surface_loadbmp(GRSurface** surface, const char* filename);
void surface_disaplay(GRSurface* surface, int sx, int sy, int dx, int dy);
void screen_setcolor(unsigned int color);
void screen_drawtextline(const GRFont* font, int x, int y, const char *s, bool bold);
void screen_fillrect(int x, int y, int w, int h);
void screen_update(void);

#endif
