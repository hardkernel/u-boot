/*
 * Command for PWM.
 *
 * Copyright (C) 2013 Amlogic.
 * Wenbiao Zhang
 */

#include <common.h>
#include <command.h>
#include <asm/arch/io.h>


#define PWM_B_CLK_ENABLE_BIT    23
#define PWM_B_ENABLE_BIT        1
#define PWM_B_CLK_DIV_BIT       16
#define PWM_B_CLK_SEL_BIT       6


#define PWM_A_CLK_ENABLE_BIT    15
#define PWM_A_ENABLE_BIT        0
#define PWM_A_CLK_DIV_BIT       8
#define PWM_A_CLK_SEL_BIT       4

#define PWM_CLK_ENABLE_MASK    1
#define PWM_ENABLE_MASK        1
#define PWM_CLK_DIV_MASK       0x7f
#define PWM_CLK_SEL_MASK       0x3

struct pwm_pin_mux{
    int id;
    char* pin;
    int reg;
    int bit;
};

int pwm_reg[6][2] = {
        {P_PWM_PWM_A, P_PWM_MISC_REG_AB},
        {P_PWM_PWM_B, P_PWM_MISC_REG_AB},
        {P_PWM_PWM_C, P_PWM_MISC_REG_CD},
        {P_PWM_PWM_D, P_PWM_MISC_REG_CD},
        {P_PWM_PWM_E, P_PWM_MISC_REG_EF},
        {P_PWM_PWM_F, P_PWM_MISC_REG_EF},
};

int pwm_reg_bit[6][4] = {
        {PWM_A_ENABLE_BIT, PWM_A_CLK_ENABLE_BIT, PWM_A_CLK_SEL_BIT, PWM_A_CLK_DIV_BIT},
        {PWM_B_ENABLE_BIT, PWM_B_CLK_ENABLE_BIT, PWM_B_CLK_SEL_BIT, PWM_B_CLK_DIV_BIT},
        {PWM_A_ENABLE_BIT, PWM_A_CLK_ENABLE_BIT, PWM_A_CLK_SEL_BIT, PWM_A_CLK_DIV_BIT},
        {PWM_B_ENABLE_BIT, PWM_B_CLK_ENABLE_BIT, PWM_B_CLK_SEL_BIT, PWM_B_CLK_DIV_BIT},
        {PWM_A_ENABLE_BIT, PWM_A_CLK_ENABLE_BIT, PWM_A_CLK_SEL_BIT, PWM_A_CLK_DIV_BIT},
        {PWM_B_ENABLE_BIT, PWM_B_CLK_ENABLE_BIT, PWM_B_CLK_SEL_BIT, PWM_B_CLK_DIV_BIT},
};

struct pwm_pin_mux pwm_pinmux[] = {
        // A: 
        {0, "GPIOZ_7", P_PERIPHS_PIN_MUX_2, 0},
        {0, "GPIOY_16", P_PERIPHS_PIN_MUX_9, 14},
        {0, "GPIOZ_0", P_PERIPHS_PIN_MUX_9, 16},
        // B: 
        {1, "GPIOX_11", P_PERIPHS_PIN_MUX_2, 3},
        {1, "GPIOZ_1", P_PERIPHS_PIN_MUX_9, 15},
        // C:
        {2, "GPIOZ_8", P_PERIPHS_PIN_MUX_2, 1},
        {2, "GPIODV_9", P_PERIPHS_PIN_MUX_3, 24},
        {2, "GPIODV_29", P_PERIPHS_PIN_MUX_3, 25},
        // D:
        {3, "GPIODV_28", P_PERIPHS_PIN_MUX_3, 26},
        // E:
        {4, "GPIOX_10", P_PERIPHS_PIN_MUX_9, 19},
        // F:
        {5, "TESTN", P_AO_RTI_PIN_MUX_REG, 19},
};

int get_pwm_index(int id, char* pin) {
    int i, ret=-1;
    for(i=0; i<11; i++) {
        if(id == pwm_pinmux[i].id) {
            ret = i;
            if(strcmp(pin, pwm_pinmux[i].pin) == 0) {
                return i;
            }
        }
    }
    return ret;
}

static int do_pwm_enable(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	unsigned int id, clksel, clkdiv;
    int index;
	id = simple_strtoul(argv[1], NULL, 0);
	clksel = simple_strtoul(argv[3], NULL, 0);
	clkdiv = simple_strtoul(argv[4], NULL, 0);

    index = get_pwm_index(id, argv[2]);
    if(index >= 0)
        setbits_le32(pwm_pinmux[index].reg, (1 << pwm_pinmux[index].bit));
    
    clrbits_le32(pwm_reg[id][1], (PWM_CLK_SEL_MASK << pwm_reg_bit[id][2])
                                | (PWM_CLK_DIV_MASK << pwm_reg_bit[id][3]));
    
    setbits_le32(pwm_reg[id][1], (PWM_ENABLE_MASK << pwm_reg_bit[id][0]) 
                            | (PWM_CLK_ENABLE_MASK << pwm_reg_bit[id][1]) 
                            | ((clksel&PWM_CLK_SEL_MASK) << pwm_reg_bit[id][2]) 
                            | ((clkdiv&PWM_CLK_DIV_MASK) << pwm_reg_bit[id][3]));

	return 0;
}

static int do_pwm_disable(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	unsigned int id;
	id = simple_strtoul(argv[1], NULL, 0);
   
    clrbits_le32(pwm_reg[id][1], (PWM_ENABLE_MASK << pwm_reg_bit[id][0]) | (PWM_CLK_ENABLE_MASK << pwm_reg_bit[id][1]));

	return 0;
}

static int do_pwm_config(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
    if(argc < 4)
        return -1;
    
	unsigned int id, high, low;
	id = simple_strtoul(argv[1], NULL, 0);
	high = simple_strtoul(argv[2], NULL, 0);
	low = simple_strtoul(argv[3], NULL, 0);


    writel(((high&0xffff)<<16) | ((low&0xffff) << 0), pwm_reg[id][0]);
    
	return 0;
}

static cmd_tbl_t cmd_pwm_sub[] = {
	U_BOOT_CMD_MKENT(enable, 4, 0, do_pwm_enable, "", ""),
	U_BOOT_CMD_MKENT(disable, 2, 0, do_pwm_disable, "", ""),
	U_BOOT_CMD_MKENT(config, 4, 0, do_pwm_config, "", ""),
};

static int do_pwm(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	cmd_tbl_t *c;

	/* Strip off leading 'bmp' command argument */
	argc--;
	argv++;

	c = find_cmd_tbl(argv[0], &cmd_pwm_sub[0], ARRAY_SIZE(cmd_pwm_sub));

	if (c) {
		return	c->cmd(cmdtp, flag, argc, argv);
	} else {
		cmd_usage(cmdtp);
		return 1;
	}
}

U_BOOT_CMD(
	pwm,	6,	0,	do_pwm,
	"pwm sub-system",
	"pwm enable <id> <pin> <clksel> <clkdiv>	- enable pwm id(0~5-->A~F); clksel: pwm clock source(0~3); clkdiv: devider of pwm clock \n"
	"pwm disable <id>	- disable pwm id \n"
	"pwm config <id> <high> <low> - config duty cycle of pwm id \n"
);

