#ifndef __ODROID_PMIC
#define __ODROID_PMIC

#include <aml_i2c.h>

#define RK818_CHIP_ADDR		0x1c
#define RK817_CHIP_ADDR		0x20

#define RK818_I2C_BUS		AML_I2C_MASTER_AO
#define RK817_I2C_BUS		AML_I2C_MASTER_D

#define RK818_BUCK1_ON_VSEL	0x2f
#define RK818_BUCK2_ON_VSEL	0x33
#define RK818_BUCK4_ON_VSEL	0x38
#define RK818_LDO_EN_REG	0x24

#define RK817_BUCK2_ON_VSEL	0xbe
#define RK817_BUCK3_ON_VSEL	0xc1
#define RK817_LDO8_ON_VSEL	0xda

#define RK817_POWER_EN0		0xb1
#define RK817_POWER_EN1		0xb2
#define RK817_POWER_EN2		0xb3

void odroid_pmic_init(void);

#endif
