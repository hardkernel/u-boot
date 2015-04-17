#ifndef __VPU_REG_H__
#define __VPU_REG_H__
#include <asm/arch/io.h>

/* ********************************
 * register define
 * ********************************* */
/* base & offset */
#define REG_BASE_AOBUS                  ((volatile unsigned int *)0xc8100000)
#define REG_BASE_CBUS                   ((volatile unsigned int *)IO_CBUS_BASE)
#define REG_OFFSET_AOBUS(reg)           ((reg))
#define REG_OFFSET_CBUS(reg)            ((reg << 2))

/* offset address */
#define AO_RTI_GEN_PWR_SLEEP0           ((0x00 << 10) | (0x3a << 2))

/* M8M2 register */
#define HHI_GP_PLL_CNTL                 0x1010
/* G9TV register */
#define HHI_GP1_PLL_CNTL                0x1016
#define HHI_GP1_PLL_CNTL2               0x1017
#define HHI_GP1_PLL_CNTL3               0x1018
#define HHI_GP1_PLL_CNTL4               0x1019

#define HHI_MEM_PD_REG0                 0x1040
#define HHI_VPU_MEM_PD_REG0             0x1041
#define HHI_VPU_MEM_PD_REG1             0x1042

#define HHI_VPU_CLK_CNTL                0x106f

#define RESET0_REGISTER                 0x1101
#define RESET1_REGISTER                 0x1102
#define RESET2_REGISTER                 0x1103
#define RESET3_REGISTER                 0x1104
#define RESET4_REGISTER                 0x1105
#define RESET0_MASK                     0x1110
#define RESET1_MASK                     0x1111
#define RESET2_MASK                     0x1112
#define RESET3_MASK                     0x1113
#define RESET4_MASK                     0x1114

/* memory mapping */
#define REG_ADDR_AOBUS(reg)             (REG_BASE_AOBUS + REG_OFFSET_AOBUS(reg))
#define REG_ADDR_CBUS(reg)              (REG_BASE_CBUS + REG_OFFSET_CBUS(reg))

/* ********************************
 * register access api
 * ********************************* */
/* use offset address */
static inline unsigned int vpu_reg_read(unsigned int _reg)
{
	//return __raw_readl(REG_ADDR_CBUS(_reg));
	return (*REG_ADDR_CBUS(_reg));
};

static inline void vpu_reg_write(unsigned int _reg, unsigned int _value)
{
	//__raw_writel(_value, REG_ADDR_CBUS(_reg));
	*REG_ADDR_CBUS(_reg) = (_value);
};

static inline void vpu_reg_setb(unsigned int _reg,
		unsigned int _value,
		unsigned int _start,
		unsigned int _len)
{
	vpu_reg_write(_reg, ((vpu_reg_read(_reg) &
			~(((1L << (_len))-1) << (_start))) |
			(((_value)&((1L<<(_len))-1)) << (_start))));
}

static inline unsigned int vpu_reg_getb(unsigned int _reg,
		unsigned int _start, unsigned int _len)
{
	return (vpu_reg_read(_reg) >> (_start)) & ((1L << (_len)) - 1);
}

static inline void vpu_set_mask(unsigned int _reg, unsigned int _mask)
{
	vpu_reg_write(_reg, (vpu_reg_read(_reg) | (_mask)));
}

static inline void vpu_clr_mask(unsigned int _reg, unsigned int _mask)
{
	vpu_reg_write(_reg, (vpu_reg_read(_reg) & (~(_mask))));
}

static inline unsigned int vpu_aobus_read(unsigned int _reg)
{
	//return readl(REG_ADDR_AOBUS(_reg));
	return (*REG_ADDR_AOBUS(_reg));
};

static inline void vpu_aobus_write(unsigned int _reg, unsigned int _value)
{
	//writel(_value, REG_ADDR_AOBUS(_reg));
	*REG_ADDR_CBUS(_reg) = (_value);
};

static inline void vpu_ao_setb(unsigned int _reg,
		unsigned int _value,
		unsigned int _start,
		unsigned int _len)
{
	vpu_aobus_write(_reg, ((vpu_aobus_read(_reg) &
			~(((1L << (_len))-1) << (_start))) |
			(((_value)&((1L<<(_len))-1)) << (_start))));
}

#endif
