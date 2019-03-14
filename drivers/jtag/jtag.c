#include <common.h>
#include <command.h>
#include <asm/arch/io.h>
#include <asm/arch/secure_apb.h>

#define JTAG_M3_AO	0
#define JTAG_M3_EE	1
#define JTAG_AP_AO	2
#define JTAG_AP_EE	3
#define JTAG_M4_AO	8
#define JTAG_M4_EE	9

#define REG_END     (volatile uint32_t *)-1
struct jtag_pinctrl_data {
	volatile uint32_t** ao_reg;
	uint32_t* ao_value;
	volatile uint32_t** ee_reg;
	uint32_t* ee_value;
	uint32_t value_save[2]; /*reg save backup*/
};

/* axg */
#if defined(CONFIG_AML_MESON_AXG)

	volatile static uint32_t* ao_reg[] = {P_AO_RTI_PINMUX_REG0, REG_END};
	static uint32_t ao_value[] = {(0x4<<12) | (0x4<<16) | (0x4<<20) | (0x4<<28)};
	volatile static uint32_t* ee_reg[] = {P_PERIPHS_PIN_MUX_4, REG_END};
	static uint32_t ee_value[] = {(0x2<<0) | (0x2<<4) | (0x2<<16) | (0x2<<20)};

/* g12a/g12b/tl1 */
#elif defined(CONFIG_AML_MESON_G12A) || defined(CONFIG_AML_MESON_G12B) || defined(CONFIG_AML_MESON_TL1)

	volatile static uint32_t* ao_reg[] = {P_AO_RTI_PINMUX_REG0, P_AO_RTI_PINMUX_REG1, REG_END};
	static uint32_t ao_value[] = {(1 << 24) | (1 << 28), (1 << 4) | (1 << 0)};
	volatile static uint32_t* ee_reg[] = {P_PERIPHS_PIN_MUX_9, REG_END};
	static uint32_t ee_value[] = {(2 << 0) | (2 << 4) | (2 << 16) | (2 << 20)};

/* txhd */
#elif defined(CONFIG_AML_MESON_TXHD)

	volatile static uint32_t* ao_reg[] = {P_AO_RTI_PIN_MUX_REG, REG_END};
	static uint32_t ao_value[] = {(3 << 12) | (4 << 16) | (4 << 20) | (3 << 28)};
	volatile static uint32_t* ee_reg[] = {P_PERIPHS_PIN_MUX_9, REG_END};
	static uint32_t ee_value[] = {(2 << 0) | (2 << 4) | (2 << 16) | (2 << 20)};

/* axg before */
#else

	volatile static uint32_t* ao_reg[] = {REG_END};
	static uint32_t ao_value[] = {0};
	volatile static uint32_t* ee_reg[] = {REG_END};
	static uint32_t ee_value[] = {0};

#endif

/* set pinmux common code */
static int enabled_flag = 0;
static struct jtag_pinctrl_data jtag_pinctrl = {
	.ao_reg    = ao_reg,
	.ao_value  = ao_value,
	.ee_reg    = ee_reg,
	.ee_value  = ee_value,
};

static void jtag_set_regs(uint32_t* value, volatile uint32_t** reg)
{
	int i;

	for (i = 0; reg[i] != REG_END; i++) {
		if (!enabled_flag)
			jtag_pinctrl.value_save[i] = readl(reg[i]);
		writel(readl(reg[i]) | value[i], reg[i]);
	}
}

void jtag_set_pinmux(unsigned int jtag_sel, int enable)
{
	if (enable) {
		if (jtag_sel == JTAG_AP_AO || jtag_sel == JTAG_M3_AO || jtag_sel == JTAG_M4_AO)
			jtag_set_regs(jtag_pinctrl.ao_value, jtag_pinctrl.ao_reg);
		else
			jtag_set_regs(jtag_pinctrl.ee_value, jtag_pinctrl.ee_reg);
		enabled_flag = 1;
	} else {
		if (enabled_flag == 0)
			return;
		if (jtag_sel == JTAG_AP_AO || jtag_sel == JTAG_M3_AO || jtag_sel == JTAG_M4_AO)
			jtag_set_regs(jtag_pinctrl.value_save, jtag_pinctrl.ao_reg);
		else
			jtag_set_regs(jtag_pinctrl.value_save, jtag_pinctrl.ee_reg);
		enabled_flag = 0;
	}
}
