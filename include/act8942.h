/* 
 * act8942 i2c interface
 * Copyright (C) 2011 Amlogic, Inc.
 *
 *
 * Author:  elvis yu<elvis.yu@amlogic.com>
 */

#define ACT8942_ADDR 0x5b

#define ACT8942_SYS_ADDR 0x00
#define ACT8942_REG1_ADDR 0x20
#define ACT8942_REG2_ADDR 0x30
#define ACT8942_REG3_ADDR 0x40
#define ACT8942_REG4_ADDR 0x50
#define ACT8942_REG5_ADDR 0x54
#define ACT8942_REG6_ADDR 0x60
#define ACT8942_REG7_ADDR 0x64
#define ACT8942_APCH_ADDR 0x70

struct act8942_operations {
	int (*is_ac_online)(void);
	int (*is_usb_online)(void);
	void (*set_bat_off)(void);
	int (*get_charge_status)(void);
	int (*set_charge_current)(int level);
	int (*measure_voltage)(void);
	int (*measure_current)(void);
	int (*measure_capacity_charging)(void);
	int (*measure_capacity_battery)(void);

	unsigned int update_period; /* msecs, default is 5000 */
};

void act8942_init(struct act8942_operations *act8942_opts);
unsigned char act8942_i2c_read(unsigned char reg);
void act8942_i2c_write(unsigned char reg, unsigned char val);
