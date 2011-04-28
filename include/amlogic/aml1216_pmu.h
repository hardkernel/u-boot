
#ifndef __AML1216_H__
#define __AML1216_H__

//add for AML1216 ctroller.
#define AML1216_OTP_GEN_CONTROL0        0x17

#define AML1216_CHG_CTRL0               0x29
#define AML1216_CHG_CTRL1               0x2A
#define AML1216_CHG_CTRL2               0x2B
#define AML1216_CHG_CTRL3               0x2C
//#define AML1216_CHG_CTRL4               0x2D
#define AML1216_CHG_CTRL4               0x12B
#define AML1216_CHG_CTRL5               0x2E
#define AML1216_SAR_ADJ                 0x73

#define AML1216_GEN_CNTL0               0x80
#define AML1216_GEN_CNTL1               0x81
#define AML1216_PWR_UP_SW_ENABLE        0x82        // software power up
#define AML1216_PWR_DN_SW_ENABLE        0x84        // software power down
#define AML1216_GEN_STATUS0             0x86
#define AML1216_GEN_STATUS1             0x87
#define AML1216_GEN_STATUS2             0x88
#define AML1216_GEN_STATUS3             0x89
#define AML1216_GEN_STATUS4             0x8A
#define AML1216_WATCH_DOG               0x8F
#define AML1216_PWR_KEY_ADDR            0x90
#define AML1216_SAR_SW_EN_FIELD         0x9A
#define AML1216_SAR_CNTL_REG0           0x9B
#define AML1216_SAR_CNTL_REG2           0x9D
#define AML1216_SAR_CNTL_REG3           0x9E
#define AML1216_SAR_CNTL_REG5           0xA0
#define AML1216_SAR_RD_IBAT_LAST        0xAB        // battery current measure
#define AML1216_SAR_RD_VBAT_ACTIVE      0xAF        // battery voltage measure
#define AML1216_SAR_RD_MANUAL           0xB1        // manual measure
#define AML1216_SAR_RD_IBAT_ACC         0xB5        // IBAT accumulated result, coulomb
#define AML1216_SAR_RD_IBAT_CNT         0xB9        // IBAT measure count
#define AML1216_GPIO_OUTPUT_CTRL        0xC3        // GPIO output control
#define AML1216_GPIO_INPUT_STATUS       0xC4        // GPIO input status
#define AML1216_IRQ_MASK_0              0xC8        // IRQ Mask base address
#define AML1216_IRQ_STATUS_CLR_0        0xCF        // IRQ status base address
#define AML1216_SP_CHARGER_STATUS0      0xDE        // charge status0
#define AML1216_SP_CHARGER_STATUS1      0xDF        // charge status1
#define AML1216_SP_CHARGER_STATUS2      0xE0        // charge status2
#define AML1216_SP_CHARGER_STATUS3      0xE1        // charge status3
#define AML1216_SP_CHARGER_STATUS4      0xE2        // charge status4
#define AML1216_PIN_MUX4                0xF4        // pin mux select 4

#define AML1216_DCDC1                0
#define AML1216_DCDC2                1
#define AML1216_DCDC3                2
#define AML1216_BOOST                3
#define AML1216_LDO1                 4
#define AML1216_LDO2                 5
#define AML1216_LDO3                 6
#define AAML1216_LDO4                7
#define AML1216_LDO5                 8

int aml1216_write   (int add, unsigned char val);
//int aml1216_writes  (int add, unsigned char*buff, int len);
int aml1216_writes  (int add, unsigned char *buff, int len);
int aml1216_read    (int add, unsigned char*val);
int aml1216_reads   (int add, unsigned char*buff, int len);
int aml1216_set_bits(int add, unsigned char bits, unsigned char mask);

int aml1216_set_gpio(int gpio, int output);
int aml1216_get_gpio(int gpio, int *val);
int aml1216_set_usb_current_limit(int limit);

int aml1216_init(void);
int aml1216_set_charging_current(int current);
int aml1216_get_charging_percent(void);
int aml1216_charger_online(void);
void aml1216_power_off(void);
#endif      /* __AML1216_H__ */
