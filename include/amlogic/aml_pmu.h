
#ifndef __AML_PMU_H__
#define __AML_PMU_H__

/*
 * function declaration
 */
int aml_pmu_write  (uint32_t add, uint32_t val);                    // single write
int aml_pmu_write16(uint32_t add, uint32_t val);                    // 16bit register write
int aml_pmu_writes (uint32_t add, uint32_t len, uint8_t *buff);     // block write
int aml_pmu_read   (uint32_t add, uint8_t *val);
int aml_pmu_read16 (uint32_t add, uint16_t *val);
int aml_pmu_reads  (uint32_t add, uint32_t len, uint8_t *buff);

int aml_pmu_is_ac_online(void);
int aml_pmu_power_off(void);
int aml_pmu_get_charging_percent(void);
int amp_pmu_set_charging_current(int current);

int aml_pmu_set_gpio(int pin, int val);
int aml_pmu_get_gpio(int pin, uint8_t *val);

#ifdef CONFIG_UBOOT_BATTERY_PARAMETER_TEST
int aml_battery_calibrate(void);
#endif

#endif  /* __AML_PMU_H__ */

