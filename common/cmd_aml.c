/*
 * Command for Amlogic Custom.
 *
 * Copyright (C) 2012 Amlogic.
 * Elvis Yu <elvis.yu@amlogic.com>
 */

#include <common.h>
#include <command.h>

#ifdef CONFIG_PLATFORM_HAS_PMU
#include <amlogic/aml_pmu_common.h>
#endif

extern inline void key_init(void);
extern inline int get_key(void);
extern inline int is_ac_online(void);
extern void power_off(void);
extern inline int get_charging_percent(void);
extern inline int set_charging_current(int current);


static int do_getkey (cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	static int key_enable = 0;
	int key_value = 0;
	if(!key_enable){
		key_init();
		key_enable = 1;
		//wait ready for gpio power key,  frank.chen
        	mdelay(20);
	}
	key_value = get_key();
	return !key_value;
}


U_BOOT_CMD(
	getkey,	1,	0,	do_getkey,
	"get POWER key",
	"/N\n"
	"This command will get POWER key'\n"
);

static inline int do_ac_online (cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
#ifdef CONFIG_PLATFORM_HAS_PMU
    struct aml_pmu_driver *pmu_driver;
    pmu_driver = aml_pmu_get_driver();
    if (pmu_driver && pmu_driver->pmu_get_extern_power_status) {
        return !pmu_driver->pmu_get_extern_power_status();    
    } else {
        printf("ERROR!! No pmu_get_battery_capacity hooks!\n");
        return 0;
    }
#else
	return !is_ac_online();
#endif
}


U_BOOT_CMD(
	ac_online,	1,	0,	do_ac_online,
	"get ac adapter online",
	"/N\n"
	"This command will get ac adapter online'\n"
);


static int do_poweroff (cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
#ifdef CONFIG_PLATFORM_HAS_PMU
    struct aml_pmu_driver *pmu_driver;
    pmu_driver = aml_pmu_get_driver();
    if (pmu_driver && pmu_driver->pmu_power_off) {
        pmu_driver->pmu_power_off();    
    } else {
        printf("ERROR!! NO power off hooks!\n");
    }
#else
	power_off();
#endif
	return 0;
}


U_BOOT_CMD(
	poweroff,	1,	0,	do_poweroff,
	"system power off",
	"/N\n"
	"This command will let system power off'\n"
);

static int do_get_batcap (cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	char percent_str[16];
	int percent = 0;
#ifdef CONFIG_PLATFORM_HAS_PMU
    struct aml_pmu_driver *pmu_driver;
    pmu_driver = aml_pmu_get_driver();
    if (pmu_driver && pmu_driver->pmu_get_battery_capacity) {
        percent = pmu_driver->pmu_get_battery_capacity(); 
    } else {
        printf("ERROR!! No pmu_get_battery_capacity hooks!\n");
    }
#else
	percent = get_charging_percent();
#endif
	printf("Battery CAP: %d%%\n", percent);
	sprintf(percent_str, "%d", percent);
	setenv("battery_cap", percent_str);
	return 0;
}


U_BOOT_CMD(
	get_batcap,	1,	0,	do_get_batcap,
	"get battery capability",
	"/N\n"
	"This command will get battery capability\n"
	"capability will set to 'battery_cap'\n"
);

static int do_set_chgcur (cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	int current = simple_strtol(argv[1], NULL, 10);

#ifdef CONFIG_PLATFORM_HAS_PMU
    struct aml_pmu_driver *pmu_driver;
    pmu_driver = aml_pmu_get_driver();
    if (pmu_driver && pmu_driver->pmu_set_charge_current) {
        pmu_driver->pmu_set_charge_current(current);
    	setenv("charging_current", argv[1]);
    } else {
        printf("ERROR!! No pmu_set_charge_current hooks!\n");     
    }
#else
	set_charging_current(current);
	
	printf("Charging current: %smA\n", argv[1]);
	setenv("charging_current", argv[1]);
#endif
	return 0;
}


U_BOOT_CMD(
	set_chgcur,	2,	0,	do_set_chgcur,
	"set battery charging current",
	"/N\n"
	"set_chgcur <current>\n"
	"unit is mA\n"
);

/* set  usb current limit */
#ifdef CONFIG_AW_AXP20
extern int axp_charger_set_usbcur_limit(int usbcur_limit);
#endif
#ifdef CONFIG_AML_PMU
extern int aml_pmu_set_usb_curr_limit(int curr);
#endif
static int pmu_set_usbcur_limit(int usbcur_limit)
{
#ifdef CONFIG_AW_AXP20
    return axp_charger_set_usbcur_limit(usbcur_limit);
#endif
#ifdef CONFIG_AML_PMU
    return aml_pmu_set_usb_curr_limit(usbcur_limit);
#endif
}
static int do_set_usbcur_limit(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
    int usbcur_limit = simple_strtol(argv[1], NULL, 10);
    if (argc < 2)
        return cmd_usage(cmdtp);
#ifdef CONFIG_PLATFORM_HAS_PMU
    struct aml_pmu_driver *pmu_driver;
    pmu_driver = aml_pmu_get_driver();
    if (pmu_driver && pmu_driver->pmu_set_usb_current_limit) {
        pmu_driver->pmu_set_usb_current_limit(usbcur_limit);
        printf("set usbcur_limit: %smA\n", argv[1]);
        if (argc == 2 ) {
            setenv("usbcur_limit", argv[1]);
        }
    } else {
        printf("ERROR!! No pmu_set_usb_current_limit hooks!\n");     
    }
#else
    pmu_set_usbcur_limit(usbcur_limit);
    printf("set usbcur_limit: %smA\n", argv[1]);
    if (argc == 2 )
		{
    setenv("usbcur_limit", argv[1]);
		}
#endif
    return 0;
}
U_BOOT_CMD(
	set_usbcur_limit,	3,	0,	do_set_usbcur_limit,
	"set pmu usb limit current",
	"/N\n"
	"set_usbcur_limit <current>\n"
	"unit is mA\n"
);

#if defined(CONFIG_PLATFORM_HAS_PMU) && defined(CONFIG_UBOOT_BATTERY_PARAMETER_TEST)
static int do_battery_test(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
    struct aml_pmu_driver *pmu_driver;
    pmu_driver = aml_pmu_get_driver();
    if (pmu_driver && pmu_driver->pmu_do_battery_calibrate) {
        pmu_driver->pmu_do_battery_calibrate();
    } else {
        printf("ERROR!! No pmu_do_battery_calibrate hooks!\n");    
    }
    return 0;
}

U_BOOT_CMD(
	battery_test,	1,	0,	do_battery_test,
	"test battery curve",
	"/N\n"
	"battery_test \n"
	"\n"
);

static int do_pmu_reg(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
    struct aml_pmu_driver *pmu_driver;
    int rw = 0, i;
    int addr;
    unsigned char val;

    if (argc < 1 || argc > 4) {
        return cmd_usage(cmdtp);
    }
    pmu_driver = aml_pmu_get_driver();
    if (!strcmp(argv[1], "r")) {
        rw = 0;    
    } else if (!strcmp(argv[1], "w")) {
        rw = 1;    
    } else if (!strcmp(argv[1], "d")) {
        if (pmu_driver && pmu_driver->pmu_dump_register) {
            pmu_driver->pmu_dump_register(DUMP_ALL);
            return 0;
        }    
    } else {
        return cmd_usage(cmdtp);
    }
    addr = simple_strtoul(argv[2], NULL, 16); 
    if (rw == 1) {
        val = simple_strtoul(argv[3], NULL, 16); 
    }

    if (pmu_driver && pmu_driver->pmu_reg_read && rw == 0) {
        if (pmu_driver->pmu_reg_read(addr, &val)) {
            printf("read addr 0x%03x failed\n", addr);
            return -1;
        }
        printf("REG[0x%02x] = 0x%02x\n", addr, val);
    } else if (pmu_driver && pmu_driver->pmu_reg_write && rw == 1) {
        if (pmu_driver->pmu_reg_write(addr, val)) {
            printf("write addr 0x%03x failed\n", addr);
            return -1;
        }
        printf("REG[0x%02x] set to 0x%02x\n", addr, val);
    } else {
        printf("ERROR!! No hooks!\n");    
    }
    return 0;
}

U_BOOT_CMD(
	pmu_reg,	4,	0,	do_pmu_reg,
	"pmu_reg read/write command",
	"/N\n"
	"pmu_reg [r/w] [addr] [value]\n"
    "example:\n"
	"pmu_reg r 0x00         ---- read register 0x00 of PMU\n"
	"pmu_reg w 0x00 0x55    ---- write register 0x00 to 0x55\n"
	"\n"
);
#endif

static int do_gettime (cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
    int time = get_utimer(0);
    printf("***from powerup: %d us.\n", time);
	return time;
}


U_BOOT_CMD(
	time,	1,	0,	do_gettime,
	"get bootup time",
	"/N\n"
);
