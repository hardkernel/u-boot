
#ifndef __AML_PMU_COMMOM_H__
#define __AML_PMU_COMMOM_H__

#include <amlogic/battery_parameter.h>

#define POWER_INIT_MODE_NORMAL              0
#define POWER_INIT_MODE_USB_BURNING         1
#ifdef CONFIG_RESET_TO_SYSTEM
#define RESET_FLAG_GET              0
#define RESET_FLAG_SET              1
#define RESET_FLAG_CLR              2
#endif

#define DUMP_ALL                    0
#define DUMP_KEY                    1

struct aml_pmu_driver {
    int  (*pmu_init)(void);                                                     // initialize PMU board
    int  (*pmu_get_battery_capacity)(void);                                     // return battery percent
    int  (*pmu_get_extern_power_status)(void);                                  // return extern power is online
    int  (*pmu_set_gpio)(int gpio, int value);                                  // export for other driver 
    int  (*pmu_get_gpio)(int gpio, int *value);                                 // export for other driver
    int  (*pmu_reg_read)  (int addr, unsigned char *buf);                       // single register read
    int  (*pmu_reg_write) (int addr, unsigned char value);                      // single register write
    int  (*pmu_reg_reads) (int addr, unsigned char *buf, int count);            // large amount registers reads
    int  (*pmu_reg_writes)(int addr, unsigned char *buf, int count);            // large amount registers writes
    int  (*pmu_set_bits)  (int addr, unsigned char bits, unsigned char mask);   // set bits in mask
    int  (*pmu_set_usb_current_limit)(int curr);                                // set usb current limit
    int  (*pmu_set_charge_current)(int curr);                                   // set charge current
    int  (*pmu_init_para)(struct battery_parameter *battery);                   // init pmu by battery parameter
#ifdef CONFIG_USB_DWC_OTG_HCD
    int  (*pmu_usb_bc_process)(int mode);                                       // special process for usb bc  
#endif
    void (*pmu_power_off)(void);                                                // power off system
#ifdef CONFIG_UBOOT_BATTERY_PARAMETER_TEST
    void (*pmu_do_battery_calibrate)(void);                                     // calibrate battery curve
#endif
#ifdef CONFIG_RESET_TO_SYSTEM
    int  (*pmu_reset_flag_operation)(int op);
#endif
    void (*pmu_dump_register)(int dump_level);
};

extern struct aml_pmu_driver* aml_pmu_get_driver(void);
extern void power_init(int init_mode);

#endif  /* __AML_PMU_COMMOM_H__ */
