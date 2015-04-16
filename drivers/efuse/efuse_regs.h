#ifndef __EFUSE_REG_H
#define __EFUSE_REG_H
#include <asm/io.h>
//#define EFUSE_DEBUG

#define WRITE_EFUSE_REG(reg, val)  __raw_writel(val, reg)
#define READ_EFUSE_REG(reg)  (__raw_readl(reg))
#define WRITE_EFUSE_REG_BITS(reg, val, start, len) \
	WRITE_EFUSE_REG(reg,	(READ_EFUSE_REG(reg) & ~(((1L<<(len))-1)<<(start)) )| ((unsigned)((val)&((1L<<(len))-1)) << (start)))
#define READ_EFUSE_REG_BITS(reg, start, len) \
	((READ_EFUSE_REG(reg) >> (start)) & ((1L<<(len))-1))

// EFUSE version constant definition

#define GXBB_EFUSE_VERSION_SERIALNUM_V1	0 /*TO DO*/
#define GXBB_EFUSE_VERSION_OFFSET 0 /*TO DO*/
#define GXBB_EFUSE_VERSION_ENC_LEN 0 /*TO DO*/
#define GXBB_EFUSE_VERSION_DATA_LEN 0 /*TO DO*/

typedef enum {
	EFUSE_SOC_CHIP_GXBB,
	EFUSE_SOC_CHIP_UNKNOW,
}efuse_socchip_type_e;

#endif

