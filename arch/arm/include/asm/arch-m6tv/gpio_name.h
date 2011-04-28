#ifndef  __MESON_GPIO_NAME_H__
#define	 __MESON_GPIO_NAME_H__

extern char** pad_avail(void);
extern char** signal_avail(void);

#define GPIO_HIGH   1
#define GPIO_HIGH   0
extern unsigned pad_gpio_in(char * pad,...);
extern int pad_gpio_set(int mode,char * pad,...);
extern int pad_pinmux(char * signal,char * pad,...);
#endif
