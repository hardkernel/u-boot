#ifndef __AML_GPIO__
#define __AML_GPIO__
#include <asm/io.h>
/**
 * struct meson_reg_desc - a register descriptor
 *
 * @reg:	register offset in the regmap
 * @bit:	bit index in register
 *
 * The structure describes the information needed to control pull,
 * pull-enable, direction, etc. for a single pin
 */
struct meson_reg_desc {
	unsigned int reg;
	unsigned int bit;
};

/**
 * enum meson_reg_type - type of registers encoded in @meson_reg_desc
 */
enum meson_reg_type {
	REG_PULLEN,
	REG_PULL,
	REG_DIR,
	REG_OUT,
	REG_IN,
	NUM_REG,
};




struct meson_bank {
	const char *name;
	unsigned int first;
	unsigned int last;
	struct meson_reg_desc regs[NUM_REG];
};
#define GPIO_REG_BIT(reg, bit) ((reg<<5)|bit)
#define GPIO_REG(value) ((value>>5))
#define GPIO_BIT(value) ((value&0x1F))
#define BIT(bit)    (1<<bit)
static inline void regmap_update_bits(unsigned long reg,unsigned mask,unsigned val)
{

	unsigned int tmp, orig;
	orig = readl(reg);
	tmp = orig & ~mask;
	tmp |= val & mask;
	writel(tmp,reg);
	return;
}

#endif
