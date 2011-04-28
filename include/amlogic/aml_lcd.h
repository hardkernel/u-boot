
#ifndef __AMLOGIC_LCD_H_
#define __AMLOGIC_LCD_H_
#include <common.h>
#include <linux/list.h>

extern int aml_lcd_init(void);
extern int lcd_opt_cmd(int argc, char * const argv[]);

typedef struct panel_operations {
	void  (*enable)(void);
	void  (*disable)(void);
	void  (*bl_on)(void);
	void  (*bl_off)(void);
	void  (*set_bl_level)(unsigned level);
	unsigned (*get_bl_level)(void);
	void  (*power_on)(void);
	void  (*power_off)(void);
	void  (*test)(unsigned num);
	void  (*info)(void);
} panel_operations_t;

extern panel_operations_t panel_oper;


#endif


