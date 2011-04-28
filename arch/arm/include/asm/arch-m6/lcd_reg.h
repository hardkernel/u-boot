#ifndef LCD_CONTROLLER_REG_H
#define LCD_CONTROLLER_REG_H
#include <asm/arch/io.h>

#define LCD_REG_BASE_ADDR				0xc1100000
#define LCD_CBUS_BASE_ADDR				0xc1100000

#define LCD_REG_OFFSET(reg)				((reg) << 2)
#define LCD_CBUS_OFFSET(reg)			((reg) << 2)

#define LCD_REG_ADDR(reg)				(LCD_REG_BASE_ADDR + LCD_REG_OFFSET(reg))
#define LCD_CBUS_ADDR(reg)				(LCD_CBUS_BASE_ADDR + LCD_CBUS_OFFSET(reg))

#define WRITE_LCD_REG(reg, val) *(volatile unsigned *)LCD_REG_ADDR(reg) = (val)//__raw_writel(val, LCD_REG_ADDR(reg))
#define READ_LCD_REG(reg) *(volatile unsigned *)LCD_REG_ADDR(reg)//(__raw_readl(LCD_REG_ADDR(reg)))
#define WRITE_LCD_REG_BITS(reg, val, start, len) \
	WRITE_LCD_REG(reg, (READ_LCD_REG(reg) & ~(((1L<<(len))-1)<<(start))) | ((unsigned)((val)&((1L<<(len))-1)) << (start)))
	
#define WRITE_LCD_CBUS_REG(reg, val) *(volatile unsigned *)LCD_CBUS_ADDR(reg) = (val)
#define READ_LCD_CBUS_REG(reg) *(volatile unsigned *)LCD_CBUS_ADDR(reg)
#define WRITE_LCD_CBUS_REG_BITS(reg, val, start, len) \
	WRITE_LCD_CBUS_REG(reg, (READ_LCD_CBUS_REG(reg) & ~(((1L<<(len))-1)<<(start))) | ((unsigned)((val)&((1L<<(len))-1)) << (start)))

#endif
