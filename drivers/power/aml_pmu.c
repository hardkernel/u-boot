#include <common.h>
#include <div64.h>
#include <asm/setup.h>
#include <asm/arch/i2c.h>
#include <asm/arch/gpio.h>
#include <aml_i2c.h>
#include <amlogic/aml_lcd.h>
#include <amlogic/aml_pmu.h>
#include <amlogic/aml_pmu_common.h>

#ifdef CONFIG_UBOOT_BATTERY_PARAMETERS
int aml_battery_calibrate(void);
#include <amlogic/battery_parameter.h>
#endif

#define ABS(x)			((x) >0 ? (x) : -(x) )
#define AML_PMU_ADDR    0x35
#define MAX_BUF         100

#ifndef CONFIG_DDR_VOLTAGE              // ddr voltage for resume
#define CONFIG_DDR_VOLTAGE              1500
#endif
#ifndef CONFIG_VDDAO_VOLTAGE            // VDDAO voltage for resume
#define CONFIG_VDDAO_VOLTAGE            1200
#endif

#define USE_UBOOT_REF_TRIMMING      0

#define AML_PMU_VERSION_D       0x03
#define AML_PMU_VERSION_B       0x02

static int aml_pmu_version  = 0;

int aml_pmu_write(uint32_t add, uint32_t val)
{
    int ret;
    uint8_t buf[3] = {};
    buf[0] = add & 0xff;
    buf[1] = (add >> 8) & 0x0f;
    buf[2] = val & 0xff;
    struct i2c_msg msg[] = {
        {
            .addr  = AML_PMU_ADDR,
            .flags = 0,
            .len   = sizeof(buf),
            .buf   = buf,
        }
    };
    ret = aml_i2c_xfer_slow(msg, 1);
    if (ret < 0) {
        printf("%s: i2c transfer failed, ret:%d\n", __FUNCTION__, ret);
        return ret;
    }
    return 0;
}

int aml_pmu_write16(uint32_t add, uint32_t val)
{
    int ret;
    uint8_t buf[4] = {};
    buf[0] = add & 0xff;
    buf[1] = (add >> 8) & 0x0f;
    buf[2] = val & 0xff;
    buf[3] = (val >> 8) & 0xff;
    struct i2c_msg msg[] = {
        {
            .addr  = AML_PMU_ADDR,
            .flags = 0,
            .len   = sizeof(buf),
            .buf   = buf,
        }
    };
    ret = aml_i2c_xfer_slow(msg, 1);
    if (ret < 0) {
        printf("%s: i2c transfer failed, ret:%d\n", __FUNCTION__, ret);
        return ret;
    }
    return 0;
}

int aml_pmu_writes(uint32_t add, uint32_t len, uint8_t *buff)
{
    int ret;
    uint8_t buf[MAX_BUF] = {};
    buf[0] = add & 0xff;
    buf[1] = (add >> 8) & 0x0f;
    memcpy(buf + 2, buff, len);
    struct i2c_msg msg[] = {
        {
            .addr  = AML_PMU_ADDR,
            .flags = 0,
            .len   = len + 2,
            .buf   = buf,
        }
    };
    ret = aml_i2c_xfer_slow(msg, 1);
    if (ret < 0) {
        printf("%s: i2c transfer failed, ret:%d\n", __FUNCTION__, ret);
        return ret;
    }
    return 0;
}

int aml_pmu_read(uint32_t add, uint8_t *val)
{
    int ret;
    uint8_t buf[2] = {};
    buf[0] = add & 0xff;
    buf[1] = (add >> 8) & 0x0f;
    struct i2c_msg msg[] = {
        {
            .addr  = AML_PMU_ADDR,
            .flags = 0,
            .len   = sizeof(buf),
            .buf   = buf,
        },
        {
            .addr  = AML_PMU_ADDR,
            .flags = I2C_M_RD,
            .len   = 1,
            .buf   = val,
        }
    };
    ret = aml_i2c_xfer_slow(msg, 2);
    if (ret < 0) {
        printf("%s: i2c transfer failed, ret:%d\n", __FUNCTION__, ret);
        return ret;
    }
    return 0;
}

int aml_pmu_read16(uint32_t add, uint16_t *val)
{
    int ret;
    uint8_t buf[2] = {};
    buf[0] = add & 0xff;
    buf[1] = (add >> 8) & 0x0f;
    struct i2c_msg msg[] = {
        {
            .addr  = AML_PMU_ADDR,
            .flags = 0,
            .len   = sizeof(buf),
            .buf   = buf,
        },
        {
            .addr  = AML_PMU_ADDR,
            .flags = I2C_M_RD,
            .len   = 2, 
            .buf   = val,
        }
    };
    ret = aml_i2c_xfer_slow(msg, 2);
    if (ret < 0) {
        printf("%s: i2c transfer failed, ret:%d\n", __FUNCTION__, ret);
        return ret;
    }
    return 0;
}

int aml_pmu_reads(uint32_t add, uint32_t len, uint8_t *buff)
{
    int ret;
    uint8_t buf[2] = {};
    buf[0] = add & 0xff;
    buf[1] = (add >> 8) & 0x0f;
    struct i2c_msg msg[] = {
        {
            .addr  = AML_PMU_ADDR,
            .flags = 0,
            .len   = sizeof(buf),
            .buf   = buf,
        },
        {
            .addr  = AML_PMU_ADDR,
            .flags = I2C_M_RD,
            .len   = len,
            .buf   = buff,
        }
    };
    ret = aml_i2c_xfer_slow(msg, 2);
    if (ret < 0) {
        printf("%s: i2c transfer failed, ret:%d\n", __FUNCTION__, ret);
        return ret;
    }
    return 0;
}

int aml_pmu_set_bits(uint32_t add, uint8_t bits, uint8_t mask)
{
    uint8_t val;
    aml_pmu_read(add, &val);
    val &= ~(mask);                                         // clear bits;
    val |=  (bits & mask);                                  // set bits;
    return aml_pmu_write(add, val);
}

int aml_pmu_get_voltage(void)
{
    uint8_t buf[2] = {};
    int     result = 0;
    int     tmp;
    int     i = 0;

    for (i = 0; i < 4; i++) {
        aml_pmu_write(0x009A, 0x04);
        udelay(100);
        aml_pmu_reads(0x00AF, 2, buf);
        tmp = ((buf[1] & 0x0f) << 8) + buf[0];
        if (aml_pmu_version <= AML_PMU_VERSION_B && aml_pmu_version) {
            tmp = tmp * 7200 / 2048;        // A or B version 
        } else if (aml_pmu_version == AML_PMU_VERSION_D) {
            tmp = tmp * 4800 / 2048;        // D version 
        } else {
            printf("[AML_PMU] %s, no valid pmu version is detected, nothing todo!\n", __func__);
        }
        result += tmp;
    }
    return result / 4;
}

int aml_pmu_get_current(void)
{
    uint8_t  buf[2] = {};
    uint32_t tmp;
    int      result = 0;
    int      i;

    for (i = 0; i < 4; i++) {
        aml_pmu_write(0x009A, 0x40);
        udelay(100);
        aml_pmu_reads(0x00AB, 2, buf);
        tmp = ((buf[1] & 0x0f) << 8) + buf[0];
        if (tmp & 0x800) {                                              // complement code
            tmp = (tmp ^ 0xfff) + 1;
        }
        result += (tmp * 4000) / 2048;                                  // LSB of IBAT ADC is 1.95mA
    }
    return result / 4;
}

int aml_pmu_get_coulomb_acc(void)
{
    uint8_t buf[4] = {};
    int result;
    int coulomb;

    aml_pmu_write(0x009A, 0x40);
    aml_pmu_reads(0x00B5, 4, buf);

    result  = (buf[0] <<  0) | 
              (buf[1] <<  8) | 
              (buf[2] << 16) | 
              (buf[3] << 24);
    coulomb = (result) / (3600 * 100);                              // convert to mAh
    coulomb = (coulomb * 4000) / 2048;                              // LSB of current is 1.95mA
    return coulomb;
}

uint32_t aml_pmu_get_coulomb_cnt(void)
{
    uint8_t buf[4] = {};
    uint32_t result;
    
    aml_pmu_write(0x009A, 0x40);
    aml_pmu_reads(0x00b9, 4, buf);

    result = (buf[0] <<  0) | 
             (buf[1] <<  8) | 
             (buf[2] << 16) | 
             (buf[3] << 24);
    return result;
}

int aml_pmu_set_dcin(int enable)
{
    uint8_t val = 0;

    if (!enable) {
        val |= 0x10;
    }
    printf("%s:%s\n", __func__, enable ? "enable" : "disable");

    return aml_pmu_set_bits(0x002d, val, 0x10);
}

int aml_pmu_is_ac_online(void)
{
    uint8_t buf;
    aml_pmu_read(0x00e0, &buf);
    if (buf & 0x18) {
        return 1;    
    } else {
        return 0;    
    }
}

int aml_pmu_get_dc_online(void)
{
    uint8_t buf;
    aml_pmu_read(0x00e0, &buf);
    if (buf & 0x10) {
        return 1;    
    } else {
        return 0;    
    }
}

int aml_pmu_is_usb_online(void)
{
    uint8_t buf;
    aml_pmu_read(0x00e0, &buf);
    if (buf & 0x08 && !(buf & 0x10)) {              // only USB online
        return 1;
    } else {
        return 0;    
    }
}

static inline int do_usb_online(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
    return !aml_pmu_is_usb_online();
}

U_BOOT_CMD(
    usb_online_only,  1,  0,  do_usb_online,
    "get usb adapter online",
    "/N\n"
    "This command will get usb adapter online'\n"
);


int aml_pmu_set_charger(int enable)
{
    uint8_t val = 0; 

    if (aml_pmu_version <= AML_PMU_VERSION_B && aml_pmu_version) {
        if (enable) {                                       // REVB or REVA
            val |=  0x01;
        }
        return aml_pmu_set_bits(0x0017, val, 0x01); 
    } else if (aml_pmu_version == AML_PMU_VERSION_D) {      // REVD
        return aml_pmu_set_bits(0x0011, ((enable & 0x01) << 7), 0x80);
    }
    printf("[AML_PMU] %s, no valid pmu version is detected, nothing todo!\n", __func__);
    return -1;
}

int aml_pmu_power_off(void)
{
    uint8_t buf = (1 << 5);                                 // software goto OFF state
    uint8_t tmp;
    aml_pmu_set_gpio(1, 1);                                 //turn off backlight

    mdelay(200);                                             //for decrease impulse current which can open the backlight led

    aml_pmu_write(0x0019, 0x10);                            
    aml_pmu_write16(0x0084, 0x0001);
    aml_pmu_write(0x0078, 0x04);                            // close LDO6 before power off
  //aml_pmu_write(0x00f4, 0x04);                            // according David Wang, for charge cannot stop
    printf("[AML_PMU] software goto OFF state\n");
    aml_pmu_set_charger(0);                                 // close charger
    if (aml_pmu_version == AML_PMU_VERSION_D) {
        aml_pmu_set_bits(0x004a, 0x00, 0x08);    
    }
    aml_pmu_write(0x0081, buf);
    while (1) {
        printf("power off error\n");
        udelay(1000 * 1000);
    }
}

int aml_pmu_get_charge_status(void)
{
    uint8_t  val[4] = {};
    uint32_t tmp;
    aml_pmu_reads(0x00de, 4, val);
    tmp = (val[0] <<  0) | 
          (val[1] <<  8) |
          (val[2] << 16) |
          (val[3] << 24);
    if (!(val[3] & 0x02)) {                                 // CHG_GAT_BAT_LV is low, battery is discharging
        return 2;    
    } else if ((val[2] & 0x04) && (val[3] & 0x02)) {        // CHG_GAT_BAT_LV & CHG_CHGING are both 1, charging
        return 1;                                           // charging    
    } else {
        return 3;                                           // not charging
    }
    return 0;
}

int aml_pmu_set_usb_curr_limit(int curr)
{
    uint8_t val = 0;
    int ret=0;

    switch (curr) {
    case 100:
        val |= 0x00;
        break;
    case 500:
        val |= 0x10;
        break;
    case 900:
        val |= 0x20;
        break;
    case 0:
    case -1:
        val |= 0x30;
        break;
    default:
        printf("[AML_PMU]%s, invaldi current:%d", __func__, curr);
        return -1;
    }
    ret = aml_pmu_set_bits(0x002c, val, 0x30);
    aml_pmu_read(0x002c, &val);
    printf("[AML_PMU]%s,CHG_IBUS_CTRL_LV:0x%x\n", __func__, val);
    return ret;
}

#ifdef CONFIG_UBOOT_BATTERY_PARAMETERS
int aml_pmu_get_ocv(int charge_status, int rdc)
{
    int vbat = aml_pmu_get_voltage();
    int ibat = aml_pmu_get_current();
    int ocv;

    if (charge_status == 1) {
        ocv = vbat - (ibat * rdc) / 1000;
    } else if (charge_status == 2) {
        ocv = vbat + (ibat * rdc) / 1000;    
    } else {
        ocv = vbat;    
    }
    return ocv;
}
#endif

int aml_pmu_get_charging_percent(void)
{
    int rest_vol;
#ifdef CONFIG_UBOOT_BATTERY_PARAMETERS
    extern int config_battery_rdc;
    extern struct battery_curve config_battery_curve[];
    int i;
    int ocv = 0;
    int ocv_diff, percent_diff, ocv_diff2;
    int percent1, percent2;
    int charge_status = aml_pmu_get_charge_status();
    static int ocv_full  = 0;
    static int ocv_empty = 0;
    static int battery_rdc;
    static struct battery_curve *battery_curve;

    if (get_battery_para_flag() == PARA_UNPARSED) {
        /*
         * this code runs earlier than get_battery_para(), 
         * we need to know battery parameters first.
         */
        if (parse_battery_parameters() > 0) {
            set_battery_para_flag(PARA_PARSE_SUCCESS);
            for (i = 0; i < 16; i++) {                  	// find out full & empty ocv in battery curve
                if (!ocv_empty && board_battery_para.pmu_bat_curve[i].discharge_percent > 0) {
                    ocv_empty = board_battery_para.pmu_bat_curve[i - 1].ocv;    
                }
                if (!ocv_full && board_battery_para.pmu_bat_curve[i].discharge_percent == 100) {
                    ocv_full = board_battery_para.pmu_bat_curve[i].ocv;    
                }
            }
            battery_rdc   = board_battery_para.pmu_battery_rdc;
            battery_curve = board_battery_para.pmu_bat_curve;
        } else {
            set_battery_para_flag(PARA_PARSE_FAILED);
        }
    }
    if (get_battery_para_flag() != PARA_PARSE_SUCCESS && !ocv_full) {
        /*   
         * parse battery parameters failed, use configured parameters
         */
        battery_rdc   = config_battery_rdc;
        battery_curve = config_battery_curve;
        for (i = 0; i < 16; i++) {                      // find out full & empty ocv in battery curve
            if (!ocv_empty && battery_curve[i].discharge_percent > 0) { 
                ocv_empty = battery_curve[i - 1].ocv;    
            }    
            if (!ocv_full && battery_curve[i].discharge_percent == 100) {
                ocv_full = battery_curve[i].ocv;    
            }    
        } 
    }
    for (i = 0; i < 8; i++) {                           // calculate average ocv
        ocv += aml_pmu_get_ocv(charge_status, battery_rdc); 
        udelay(10000); 
    }
    ocv = ocv / 8;
    printf(" ocv is %4d, ", ocv);
    if (ocv >= ocv_full) {
        if (ocv > 4500 || ocv < 0) {
            printf(" SAR ADC ERROR,");
            return 0;
        }
        return 100;    
    } else if (ocv <= ocv_empty) {
        return 0;    
    }
    for (i = 0; i < 15; i++) {                          // find which range this ocv is in
        if (ocv >= battery_curve[i].ocv &&
            ocv <  battery_curve[i + 1].ocv) {
            break;
        }
    }
    percent1 = (battery_curve[i + 1].charge_percent + 
                battery_curve[i + 1].discharge_percent) / 2;
    percent2 = (battery_curve[i].charge_percent + 
                battery_curve[i].discharge_percent) / 2;
    percent_diff = percent1 - percent2; 
    ocv_diff  = battery_curve[i + 1].ocv -
                battery_curve[i].ocv;
    ocv_diff2 = ocv - battery_curve[i].ocv;
    rest_vol  = (percent_diff * ocv_diff2 + ocv_diff / 2)/ocv_diff;
    rest_vol += percent2; 
    if (rest_vol > 100) {
        rest_vol = 100;    
    } else if (rest_vol < 0) {
        rest_vol = 0;    
    }
    return rest_vol;
#endif      /* CONFIG_UBOOT_BATTERY_PARAMETERS */
    /*
     * TODO, need add code to calculate battery capability when cannot get battery parameter
     */
    return 50;
}

int amp_pmu_set_charging_current(int current)
{
    uint8_t val = 0;
    if (current != 1500 && current != 2000) {
        printf("bad charge current:%d\n", current);
        return -1;    
    } 
    if (current == 1500) {                              // only support 1.5A or 2A now
        val &= ~(1 << 5);    
    } else {
        val |=  (1 << 5);
    }
    return aml_pmu_set_bits(0x002d, val, 0x20);
}

int aml_pmu_set_gpio(int pin, int val)
{
    int ret;
    uint32_t data;
    if (pin <= 0 || pin > 4 || val > 1 || val < 0) {
        printf("ERROR, invalid input value, pin = %d, val= %d\n", pin, val);
        return -1;
    }
    printf("%s, gpio:%d, value:%d\n", __func__, pin, val);
#if 0
    ret = aml_pmu_read(0x00C3, &data);
    if (ret) {
        return ret;
    }
    if (val) {
        data |=  (0x01 << (pin - 1));                       // set pin
    } else {
        data &= ~(0x01 << (pin - 1));                       // clear pin
    }
    return aml_pmu_write(0x00C3, data);
#else 
    data = (1 << (pin + 11));
    if (val) {
        aml_pmu_write16(0x0084, data);
    } else {
        aml_pmu_write16(0x0082, data);    
    }
#endif
}

int aml_pmu_get_gpio(int pin, uint8_t *val)
{
    int ret;
    uint8_t data;

    if (pin <= 0 || pin > 4 || !val) {
        printf("ERROR, invalid input value, pin = %d, val= %d\n", pin, val);
        return -1;
    }
    ret = aml_pmu_read(0x00C4, &data);
    if (ret) {
        return ret;
    }
    if (data & (1 << (pin - 1))) {
        *val = 1;
    } else {
        *val = 0;    
    }

    return 0;
}

int set_power_down_slot(void)
{
    /*
     * power down sequence of each application is different,
     * you need to change this sequence of each macro to fit 
     * your application according datasheet
     */
#define UNUSED_SLOT_IDX     0
#define BOOST_SLOT_IDX      2
#define DCDC1_SLOT_IDX      10
#define DCDC2_SLOT_IDX      9
#define DCDC3_SLOT_IDX      7 
#define LDO2_SLOT_IDX       11 
#define LOD3_SLOT_IDX       6
#define LDO4_SLOT_IDx       4
#define LOD5_SLOT_IDX       5
#define LOD6_SLOT_IDX       9
#define EXT_DCDC_SLOT_IDX   8
#define GPIO1_SLOT_IDX      1
#define GPIO2_SLOT_IDX      3
#define GPIO3_SLOT_IDX      3
#define GPIO4_SLOT_IDX      0 

    uint8_t power_down_seq[8] = {
        (DCDC1_SLOT_IDX    << 4) | BOOST_SLOT_IDX,          // 0x09, boost | dc1
        (DCDC3_SLOT_IDX    << 4) | DCDC2_SLOT_IDX,          // 0x0a, dc3   | dc2
        (LOD3_SLOT_IDX     << 4) | LDO2_SLOT_IDX,           // 0x0b, ldo3  | ldo2 
        (LOD5_SLOT_IDX     << 4) | LDO4_SLOT_IDx,           // 0x0c, ldo5  | ldo4
        (UNUSED_SLOT_IDX   << 4) | LOD6_SLOT_IDX,           // 0x0d, unuse | ldo6
        (EXT_DCDC_SLOT_IDX << 4) | UNUSED_SLOT_IDX,         // 0x0e, ex_dc | unuse
        (GPIO2_SLOT_IDX    << 4) | GPIO1_SLOT_IDX,          // 0x0f, gpio2 | gpio1
        (GPIO4_SLOT_IDX    << 4) | GPIO3_SLOT_IDX,          // 0x10, gpio4 | gpio3
    };

    return aml_pmu_writes(0x0009, 8, power_down_seq);
}

#define CHIP_VERSION    2
#if (CHIP_VERSION == 1)
static unsigned int dcdc12_voltage_table[] = {                  // voltage table of DCDC1 & DCDC2
    2100, 2080, 2060, 2040, 2020, 2000, 1980, 1960,
    1940, 1920, 1900, 1880, 1860, 1840, 1820, 1800,
    1780, 1760, 1740, 1720, 1700, 1680, 1660, 1640,
    1620, 1600, 1580, 1560, 1540, 1520, 1500, 1480,
    1460, 1440, 1420, 1400, 1380, 1360, 1340, 1320,
    1300, 1280, 1260, 1240, 1220, 1200, 1180, 1160,
    1140, 1120, 1100, 1080, 1060, 1040, 1020, 1000,
     980,  960,  940,  920,  900,  880,  860,  840
};
#elif (CHIP_VERSION == 2)
static unsigned int dcdc1_voltage_table[] = {                   // voltage table of DCDC1 & DCDC2
    2000, 1980, 1960, 1940, 1920, 1900, 1880, 1860, 
    1840, 1820, 1800, 1780, 1760, 1740, 1720, 1700, 
    1680, 1660, 1640, 1620, 1600, 1580, 1560, 1540, 
    1520, 1500, 1480, 1460, 1440, 1420, 1400, 1380, 
    1360, 1340, 1320, 1300, 1280, 1260, 1240, 1220, 
    1200, 1180, 1160, 1140, 1120, 1100, 1080, 1060, 
    1040, 1020, 1000,  980,  960,  940,  920,  900,  
     880,  860,  840,  820,  800,  780,  760,  740
};

static unsigned int dcdc2_voltage_table[] = {                  // voltage table of DCDC2
    2160, 2140, 2120, 2100, 2080, 2060, 2040, 2020,
    2000, 1980, 1960, 1940, 1920, 1900, 1880, 1860, 
    1840, 1820, 1800, 1780, 1760, 1740, 1720, 1700, 
    1680, 1660, 1640, 1620, 1600, 1580, 1560, 1540, 
    1520, 1500, 1480, 1460, 1440, 1420, 1400, 1380, 
    1360, 1340, 1320, 1300, 1280, 1260, 1240, 1220, 
    1200, 1180, 1160, 1140, 1120, 1100, 1080, 1060, 
    1040, 1020, 1000,  980,  960,  940,  920,  900
};
#endif

int find_idx_by_voltage(int voltage, unsigned int *table)
{
    int i;

    /*
     * under this section divide(/ or %) can not be used, may cause exception
     */
    for (i = 0; i < 64; i++) {
        if (voltage >= table[i]) {
            break;    
        }
    }
    if (voltage == table[i]) {
        return i;    
    }
    return i - 1;
}

#define AML_PMU_DCDC1               0
#define AML_PMU_DCDC2               1
#define AML_PMU_DCDC3               2
#define AML_PMU_BOOST               3
#define AML_PMU_LDO1                4
#define AML_PMU_LDO2                5
#define AML_PMU_LDO3                6
#define AML_PMU_LDO4                7
#define AML_PMU_LDO5                8

void aml_pmu_set_voltage(int dcdc, int voltage)
{
    int idx_to = 0xff;
    int idx_cur;
    unsigned char val;
    unsigned char addr;
    unsigned int *table;

    if (dcdc < 0 || dcdc > AML_PMU_DCDC2 || voltage > 2100 || voltage < 840) {
        return ;                                                // current only support DCDC1&2 voltage adjust
    }
    if (dcdc == AML_PMU_DCDC1) {
        addr  = 0x2f; 
        table = dcdc1_voltage_table;
    } else if (dcdc = AML_PMU_DCDC2) {
        addr  = 0x38;    
        table = dcdc2_voltage_table;
    }
    aml_pmu_read(addr, &val);
    printf(">> %s, val[%x] = 0x%2x\n", __func__, addr, val);
    idx_cur = ((val & 0xfc) >> 2);
    idx_to = find_idx_by_voltage(voltage, table);
    printf("set idx from %x to %x\n", idx_cur, idx_to);
    while (idx_cur != idx_to) {
        if (idx_cur < idx_to) {                                 // adjust to target voltage step by step
            idx_cur++;    
        } else {
            idx_cur--;
        }
        val &= ~0xfc;
        val |= (idx_cur << 2);
        aml_pmu_write(addr, val);
        udelay(100);                                            // atleast delay 100uS
    }
}

void aml_pmu_set_pfm(int dcdc, int en)
{
    unsigned char val;
    if (dcdc < 0 || dcdc > AML_PMU_DCDC3 || en > 1 || en < 0) {
        return ;    
    }
    switch(dcdc) {
    case AML_PMU_DCDC1:
        aml_pmu_read(0x0036, &val);
        if (en) {
            val |=  (1 << 4);                                   // pfm mode
        } else {
            val &= ~(1 << 4);                                   // pwm mode
        }
        aml_pmu_write(0x0036, val);
        break;

    case AML_PMU_DCDC2:
        aml_pmu_read(0x003f, &val);
        if (en) {
            val |=  (1 << 4);    
        } else {
            val &= ~(1 << 4);   
        }
        aml_pmu_write(0x003f, val);
        break;

    case AML_PMU_DCDC3:
        aml_pmu_read(0x0049, &val);
        if (en) {
            val |=  (1 << 7);    
        } else {
            val &= ~(1 << 7);   
        }
        aml_pmu_write(0x0049, val);
        break;

    case AML_PMU_BOOST:
        aml_pmu_read(0x0028, &val);
        if (en) {
            val |=  (1 << 0);    
        } else {
            val &= ~(1 << 0);   
        }
        aml_pmu_write(0x0028, val);
        break;

    default:
        break;
    }
    udelay(100);
}

void check_sar_channel(void)
{
    uint8_t val;
    uint8_t addr[] = {0x9A, 0x9C, 0x9F, 0xA1, 0xA2, 0xA3, 0xA4, 
                      0xA5, 0xA6, 0xA7, 0xA8, 0xA9, 0xAA};
    uint8_t data[] = {0x00, 0x10, 0x00, 0x00, 0x01, 0x0f, 0xE0, 
                      0x8f, 0xc0, 0x8f, 0xc0, 0x4f, 0x80};
    int i;
    for (i = 0; i < sizeof(addr); i++) {
        aml_pmu_read(addr[i], &val);
        if (val != data[i]) {
            printf("[AML_PMU] wrong default value of reg[%02x], is %02x\n", addr[i], val);
            aml_pmu_write(addr[i], data[i]);
        }
    }
}

void check_boot_up_source(void)
{
    uint8_t val1, val2;
    aml_pmu_read(0x8A, &val1);
    aml_pmu_read(0xE0, &val2);
    printf("[AML_PMU]Cause of the power up is reg[8A]:%02x, reg[E0]:%02x\n", val1, val2);
    if ((val1 & 0x01) && !(val2 & 0x18) && aml_pmu_version != AML_PMU_VERSION_D) {
        printf("[AML_PMU] first power up by battery, shutdown system\n");
        aml_pmu_power_off();
    }
}

void check_falut_status(void)
{
    uint8_t val0, val1, val2;
    aml_pmu_read(0x87, &val0);
    aml_pmu_read(0x88, &val1);
    aml_pmu_read(0x89, &val2);
    printf("[AML_PMU]fault status, reg[0x87]=0x%02x, reg[0x88]=0x%02x, reg[0x89]=0x%02x\n", 
           val0, val1, val2);
}

void check_pmu_version(void)
{
    uint8_t val;    
    aml_pmu_read(0x007f, &val);
    printf("[AML_PMU] version of PMU is 0x%02x\n", val);
    if (val == 0 || val > AML_PMU_VERSION_D) {
        printf("[AML_PMU] ### error, unknow PMU version ### \n");    
    } else {
        aml_pmu_version = val;
        if (aml_pmu_version == AML_PMU_VERSION_D) {  
            aml_pmu_set_bits(0x004a, 0x38, 0x38);       // open clock to charger for revD 
            aml_pmu_set_bits(0x0035, 0xc0, 0xe0);       // according David Wang, for PFM threshold
            aml_pmu_set_bits(0x003e, 0xc0, 0xe0);
            aml_pmu_set_bits(0x0047, 0x18, 0x1c);
            aml_pmu_set_bits(0x0033, 0x20, 0xe0);
            aml_pmu_set_bits(0x003c, 0x20, 0xe0);
            aml_pmu_set_bits(0x0045, 0x02, 0x0e);
            aml_pmu_set_bits(0x0034, 0x04, 0x1c);       // according David Wang, adjusting UV threshold
            aml_pmu_set_bits(0x0049, 0x40, 0x40);       // according David Wang, set DC3 pfm threshold
        }
    }
}

void dump_pmu_register(void)
{
    uint8_t val[16];
    int     i;

    printf("[AML_PMU] DUMP ALL REGISTERS\n");
    for (i = 0; i < 16; i++) {
        aml_pmu_reads(i*16, 16, val);
        printf("0x%02x - %02x: ", i * 16, i * 16 + 15);
        printf("%02x %02x %02x %02x ",   val[0],  val[1],  val[2],  val[3]);
        printf("%02x %02x %02x %02x   ", val[4],  val[5],  val[6],  val[7]);
        printf("%02x %02x %02x %02x ",   val[8],  val[9],  val[10], val[11]);
        printf("%02x %02x %02x %02x\n",  val[12], val[13], val[14], val[15]);
    }
}

int aml_pmu_init(void)
{
    uint8_t  val;
    uint8_t  chg_gat_bat_lv;

    printf("Call %s, %d\n", __func__, __LINE__);
    check_falut_status();
    check_pmu_version();
    check_boot_up_source();
#ifdef CONFIG_VBUS_DC_SHORT_CONNECT 
    aml_pmu_set_dcin(0);                        // disable DC_IN as soon as possible
#endif
    check_sar_channel();
    set_power_down_slot();                      // set power down sequence, for test
    aml_pmu_set_usb_curr_limit(500);

    aml_pmu_write(0x00f4, 0x00);                // according David Wang, for charge cannot stop

    aml_pmu_read(0x00e1, &chg_gat_bat_lv);
    aml_pmu_read(0x002c, &val);
    val &= ~(0xf3);
    if (chg_gat_bat_lv & 0x02) {
        val |= 0xe3;                            // vbus current limit to 900mA
    } else {
        val |= 0xd3;                            // according David Wang    
    }
    aml_pmu_write(0x002c, val);                 // CHG_FAST_TIME to 12hours, CHG_TRKL_TIME to 80 min 

    aml_pmu_set_charger(1);    

    aml_pmu_write(0x009d, 0x64);                // select vref=2.4V
    aml_pmu_write(0x009e, 0x14);                // close the useless channel input

    aml_pmu_write(0x00A0, 0x40);                // IBAT_AUTO time 10ms
    aml_pmu_write(0x009B, 0x0c);                // enable IBAT_AUTO, ACCUM

    printf("Call %s, %d\n", __func__, __LINE__);
    aml_pmu_write(0x0019, 0x10);                // manual VBUS off

    aml_pmu_set_bits(0x0013, 0x0e, 0x0e);
    aml_pmu_set_bits(0x0012, 0x0e, 0x0e);

    if (aml_pmu_version != AML_PMU_VERSION_D) {
        aml_pmu_set_bits(0x0020, 0x4e, 0x4e);       // according Harry, for USB_D signal and boost input voltage
        aml_pmu_write(0x0023, 0x13);                // according Harry, bypass USB_D signal
        aml_pmu_set_bits(0x0027, 0x80, 0x80);       // disable skip mode
    } else if (aml_pmu_version == AML_PMU_VERSION_D) {
        //aml_pmu_set_bits(0x0020, 0xce, 0xce);
        aml_pmu_set_bits(0x0020, 0xcf, 0xcf);       // according Harry, boost register change for REVD 
        //aml_pmu_set_bits(0x0022, 0x00, 0x80); 
        //aml_pmu_set_bits(0x0023, 0x51, 0xf1);
        aml_pmu_set_bits(0x0023, 0x53, 0xf3);
        //aml_pmu_set_bits(0x0025, 0x28, 0xfc);
        aml_pmu_set_bits(0x0025, 0x2a, 0xfa);

        //according to shusun,Reduce DC1,DC2 OC current
        printf("###### %s():Reduce DC1,DC2 OC current, Duty max enable ####\n", __func__);
        aml_pmu_set_bits(0x0030, 0x03, 0x07);
        aml_pmu_set_bits(0x0039, 0x03, 0x07);
        aml_pmu_set_bits(0x0042, 0x03, 0x07);

        //according to shusun,Duty max enable
        aml_pmu_set_bits(0x0057, 0x03, 0x03);
        aml_pmu_set_bits(0x0058, 0x02, 0x02);

        //according to shusun,set LDO2& LD03 current limit to 150mA
        printf("###### %s():set LDO2& LD03 current limit to 150mA ####\n", __func__);
        aml_pmu_set_bits(0x005e, 0x01, 0x07);
        aml_pmu_set_bits(0x005f, 0xc0, 0xe0);
        //aml_pmu_set_bits(0x0062, 0x01, 0x07);
        aml_pmu_set_bits(0x0062, 0x03, 0x07);
        aml_pmu_set_bits(0x0063, 0xc0, 0xe0);
        aml_pmu_set_bits(0x0066, 0x01, 0x07);
        aml_pmu_set_bits(0x0067, 0xc0, 0xe0);
        aml_pmu_set_bits(0x006a, 0x01, 0x07);
        aml_pmu_set_bits(0x006b, 0xc0, 0xe0);

    }

    aml_pmu_set_gpio(2, 0);                     // open vccx2 power
    udelay(500 * 1000);

    aml_pmu_set_voltage(AML_PMU_DCDC1, CONFIG_VDDAO_VOLTAGE);   // VDDAO should be set to 1.2V when booting
    aml_pmu_set_pfm(AML_PMU_DCDC1, 0);
    aml_pmu_set_voltage(AML_PMU_DCDC2, CONFIG_DDR_VOLTAGE);
    aml_pmu_set_pfm(AML_PMU_DCDC2, 0);

    aml_pmu_read(0x0086, &val);
    printf("AML PMU addr[0x86] = 0x%02x\n", val);
    aml_pmu_read(0x00df, &val);
    printf("AML PMU addr[0xdf] = 0x%02x\n", val);

    /*   
     * According Harry, for IC damage issure when soft power_up boost
     */
  //aml_pmu_set_bits(0x0027, 0x02, 0x02);       // disable boost UV fault
    aml_pmu_set_bits(0x0021, 0x41, 0x41);
    aml_pmu_read(0x0028, &val);
    printf("reg[0x28] = 0x%02x\n", val);
    if (aml_pmu_version != AML_PMU_VERSION_D) {
        aml_pmu_write(0x0028, 0x02);
    } else if (aml_pmu_version == AML_PMU_VERSION_D) {
        aml_pmu_set_bits(0x0026, 0x40, 0x40);   // according Harry, set boost ocn adj
        /*
         * according Harry, for boost reliablity
         */
        aml_pmu_set_bits(0x0024, 0x20, 0xe0);
        aml_pmu_set_bits(0x001a, 0x00, 0x02);
        aml_pmu_set_bits(0x0028, 0x10, 0x70);
        aml_pmu_set_bits(0x0028, 0x02, 0x0e);
    }
    udelay(100);
    
    aml_pmu_write16(0x0082, 0x0001);            // software boost up
    printf("Call %s, %d exit\n", __func__, __LINE__);

    aml_pmu_set_bits(0x003c, 0x08, 0x1c);       //according david wang

    printf("###### Call %s():discrease limited current, ok ####\n", __func__);

    aml_pmu_set_bits(0x0078, 0x20, 0x30);       // set re-charge threshold to 100mV

    dump_pmu_register();
    return 1;
}

static int aml1212_reads(int addr, unsigned char *buf, int count)
{
    return aml_pmu_reads(addr, count, buf);    
}

static int aml1212_writes(int addr, unsigned char *buf, int count)
{
    return aml_pmu_writes(addr, count, buf);    
}

static int aml_pmu_set_charging_current(int current)
{
    int val;

    if (current > 2000 || current < 0) {
        printf("%s, wrong value of charge current:%d\n", __func__, current);
    }
    if (current == 0) {
        return aml_pmu_set_charger(0);
    }
    if (current > 100) {
        current = current / 1000;    
    } else {
        current = (current * board_battery_para.pmu_battery_cap) / 100 + 100;    
    }
    if (current <= 2000) {
        printf("%s, set charge current to 1500mA\n", __func__);
        return aml_pmu_set_bits(0x002d, 0x00, 0x20);    
    } else {
        printf("%s, set charge current to 2000mA\n", __func__);
        return aml_pmu_set_bits(0x002d, 0x20, 0x20);    
    }
}

int aml_pmu_set_full_charge_voltage(int voltage)
{
    int val;
    switch (voltage) {
    case 4050000: val = 0x00; break;    
    case 4100000: val = 0x01; break;    
    case 4150000: val = 0x02; break;    
    case 4200000: val = 0x03; break;    
    case 4250000: val = 0x04; break;    
    case 4300000: val = 0x05; break;    
    case 4350000: val = 0x06; break;    
    case 4400000: val = 0x07; break;    
    default :
         printf("%s, wrong charge target voltage:%d\n", __func__, voltage);    
         return -1;
    }
    return aml_pmu_set_bits(0x0029, val, 0x07);
}

int aml_pmu_set_charge_end_rate(int rate)
{
    int val;
    switch (rate) {
    case 10: val = 0x00; break;
    case 20: val = 0x08; break;
    default:
         printf("%s, wrong charge end rate:%d\n", __func__, rate);    
         return -1;
    }
    return aml_pmu_set_bits(0x002d, val, 0x08);
}

int aml_pmu_set_trickle_time(int time)
{
    int val;
    switch (time) {
    case 30: val = 0x01; break;
    case 50: val = 0x02; break;
    case 80: val = 0x03; break;
    default:
         printf("%s, wrong trickle charge time:%d\n", __func__, time);    
         return -1;
    }
    return aml_pmu_set_bits(0x002c, val, 0x03);
}

int aml_pmu_set_rapid_time(int time)
{
    int val;
    switch (time) {
    case 360: val = 0x40; break;
    case 540: val = 0x80; break;
    case 720: val = 0xc0; break;
    default:
         printf("%s, wrong trickle charge time:%d\n", __func__, time);    
         return -1;
    }
    return aml_pmu_set_bits(0x002c, val, 0xc0);
}

int aml_pmu_set_long_press_time(int time)
{
    int val;

    aml_pmu_read16(0x0090, &val);
    val &= ~0x7f;
    val |= ((time / 100) - 1);
    return aml_pmu_write16(0x0090, val);
}

int aml_pmu_inti_para(struct battery_parameter *battery)
{
    if (battery) {
        aml_pmu_set_full_charge_voltage(battery->pmu_init_chgvol);
        aml_pmu_set_charge_end_rate    (battery->pmu_init_chgend_rate);
        aml_pmu_set_trickle_time       (battery->pmu_init_chg_pretime);
        aml_pmu_set_rapid_time         (battery->pmu_init_chg_csttime);
        aml_pmu_set_charger            (battery->pmu_init_chg_enabled);
        aml_pmu_set_long_press_time    (battery->pmu_pekoff_time);
        return 0;
    } else {
        return -1;    
    }    
}

struct aml_pmu_driver g_aml_pmu_driver = {
    .pmu_init                    = aml_pmu_init, 
    .pmu_get_battery_capacity    = aml_pmu_get_charging_percent,
    .pmu_get_extern_power_status = aml_pmu_is_ac_online,
    .pmu_set_gpio                = aml_pmu_set_gpio,
    .pmu_get_gpio                = aml_pmu_get_gpio,
    .pmu_reg_read                = aml_pmu_read,
    .pmu_reg_write               = aml_pmu_write,
    .pmu_reg_reads               = aml1212_reads,
    .pmu_reg_writes              = aml1212_writes,
    .pmu_set_bits                = aml_pmu_set_bits,
    .pmu_set_usb_current_limit   = aml_pmu_set_usb_curr_limit,
    .pmu_set_charge_current      = aml_pmu_set_charging_current,
    .pmu_power_off               = aml_pmu_power_off,
    .pmu_init_para               = aml_pmu_inti_para,
#ifdef CONFIG_UBOOT_BATTERY_PARAMETER_TEST
    .pmu_do_battery_calibrate    = aml_battery_calibrate,
#endif
};

struct aml_pmu_driver* aml_pmu_get_driver(void)
{
    return &g_aml_pmu_driver;
}

#ifdef CONFIG_UBOOT_BATTERY_PARAMETER_TEST
////////////////////////////////////////////////////////////////////////
//     This code is add for battery curve calibrate                   //
////////////////////////////////////////////////////////////////////////
// charecter attribute
#define     NoneAttribute       0   
#define     BoldFace            1   
#define     UnderLine           4   
#define     Flicker             5   
#define     ReverseDisplay      7   
#define     Hide                8   
#define     Un_BoldFace         22  
#define     Un_Flicker          25  
#define     Un_ReverseDisplay   27  

// background color
#define     Back_Black          40 
#define     Back_Red            41 
#define     Back_Yellow         43 
#define     Back_Blue           44 
#define     Back_Purple         45 
#define     Back_BottleGreen    46 
#define     Back_White          47

// front color
#define     Font_Black          30
#define     Font_Red            31
#define     Font_Green          42
#define     Font_Yellow         43
#define     Font_Blue           44
#define     Font_Purple         45
#define     Font_BottleGreen    46
#define     Font_White          47

void terminal_print(int x, int y, char *str)
{
    char   buff[200] = {};
    if (y == 35 || y == 36) {
        sprintf(buff,
                "\033[%d;%dH\033[0;%d;%dm%s\033[0m",
                y, x, Back_Black, Font_Black, 
                "                                                     "
                "                                                     ");
        printf(buff);
        sprintf(buff,
                "\033[%d;%dH\033[1;%d;%dm%s\033[0m",
                y, x, Back_Black, Font_Red, str);
    } else {
        sprintf(buff,
                "\033[%d;%dH\033[0;%d;%dm%s\033[0m",
                y, x, Back_Black, Font_Green, str);
    }
    printf(buff);
}

int32_t coulomb = 0;
int32_t ocv     = 0;
int32_t ibat    = 0;
int32_t vbat    = 0;
int32_t rdc     = 98;                           // different platform, change this value

int aml_calculate_rdc(void)
{
    char    buf[100];
    int32_t i_lo, i_hi;
    int32_t v_lo, v_hi;
    int32_t rdc_cal = 0;
    int32_t avg;
    static int32_t rdc_avg = 0;
    static int32_t rdc_cnt = 0;

    v_hi = aml_pmu_get_voltage();
    if (v_hi > 4000) {                          // to avoid PMU don't charge when battery voltage is high
        return 0;    
    }
#if 0
    aml_pmu_read(0x2d, buf);
    buf[0] |= 0x20;
    aml_pmu_write(0x2d, buf[0]);                // charge current to 2A 
    udelay(500000);
    i_hi = aml_pmu_get_current();
    v_hi = aml_pmu_get_voltage();
    buf[0] &= ~(0x20);
    aml_pmu_write(0x2d, buf[0]);                // charge current to 1.5A;
    udelay(500000);
    i_lo = aml_pmu_get_current();
    v_lo = aml_pmu_get_voltage();
#else
    aml_pmu_set_charger(0);                     // close charger
    udelay(500 * 1000);
    i_lo = aml_pmu_get_current();
    v_lo = aml_pmu_get_voltage();
    aml_pmu_set_charger(1);                     // open charger
    udelay(500 * 1000);
    i_hi = aml_pmu_get_current();
    v_hi = aml_pmu_get_voltage();
#endif
    if (i_hi - i_lo > 200) {                    // make sure i_hi > i_lo more than 100mA to avoid SAR ADC error
        rdc_cal = (v_hi - v_lo) * 1000 / (i_hi - i_lo);
    } else {
        rdc_cal = 0;    
    }
    if (rdc_cal > 0 && rdc_cal < 200) {
        rdc_avg += rdc_cal;
        rdc_cnt++;
    }
    if (rdc_cnt) {
        avg = rdc_avg / rdc_cnt;
    }
    sprintf(buf, "i_lo:%4d, i_hi:%4d, u_lo:%4d, u_hi:%4d, rdc_avg:%4d, rdc:%4d\n", 
            i_lo, i_hi, v_lo, v_hi, avg, rdc_cal);
    terminal_print(0, 36, buf);

    if (rdc_cal <= 0 || rdc_cal >= 200) {
        return 0;
    }
    return rdc_cal;
}

int aml_rdc_init(void)
{
    int i = 0;
    int rdc_total = 0;
    int success_cnt = 0;
    int rdc_tmp;
    char buf[100];

    for (i = 0; i < 8; i++) {
        rdc_tmp = aml_calculate_rdc();
        if (rdc_tmp) {
            rdc_total += rdc_tmp;
            success_cnt++;
        }
    }
    if (success_cnt) {
        rdc = rdc_total / success_cnt;
        sprintf(buf, "rdc_total:%4d, success_cnt:%d,set rdc to:%4d mohm\n", 
                rdc_total, success_cnt, rdc);
        terminal_print(0, 35, buf);
    }
    return success_cnt;
}

int aml_update_calibrate(int charge)
{
    uint32_t voltage, current;
    uint8_t  status;
    int     rdc_c = 0;

    coulomb = aml_pmu_get_coulomb_acc(); 
    voltage = aml_pmu_get_voltage(); 
    current = aml_pmu_get_current();
    aml_pmu_read(0x00E0, &status); 
    if (status & 0x04) {                        // charging
        ocv = voltage - (current * rdc) / 1000;
    } else {
        ocv = voltage + (current * rdc) / 1000;
    }
    aml_pmu_read(0x00E1, &status);
    /*
     * work around for can not stop charge
     */
    if (!(status & 0x08) && voltage > 4000 && charge && current < 150) {
        terminal_print(0, 36, "CHG_END_DET find, close charger for 1 second\n");
        aml_pmu_set_charger(0);
        udelay(1000 * 1000);
        status |= 0x01;
        aml_pmu_set_charger(1);
    }
    if (charge && ocv < 4000 && ocv > 3100) {         // for test
        rdc_c = aml_calculate_rdc();    
    }
    ibat = current;
    vbat = voltage;

    return rdc_c;
}

static struct energy_array {
    int     ocv;                            // mV
    int     coulomb;                        // mAh read 
    int     coulomb_p;                      // mAh @ 3700mV
    int64_t energy;                         // mV * mAh
    int     updated_flag;           
};

static struct energy_array battery_energy_charge[16] = {
    {3132, 0, 0, 0, 0},                     // pmu_bat_para1
    {3273, 0, 0, 0, 0},                     // pmu_bat_para2
    {3414, 0, 0, 0, 0},                     // pmu_bat_para3
    {3555, 0, 0, 0, 0},                     // pmu_bat_para4
    {3625, 0, 0, 0, 0},                     // pmu_bat_para5
    {3660, 0, 0, 0, 0},                     // pmu_bat_para6
    {3696, 0, 0, 0, 0},                     // pmu_bat_para7
    {3731, 0, 0, 0, 0},                     // pmu_bat_para8
    {3766, 0, 0, 0, 0},                     // pmu_bat_para9
    {3801, 0, 0, 0, 0},                     // pmu_bat_para10
    {3836, 0, 0, 0, 0},                     // pmu_bat_para11
    {3872, 0, 0, 0, 0},                     // pmu_bat_para12
    {3935, 0, 0, 0, 0},                     // pmu_bat_para13
    {3998, 0, 0, 0, 0},                     // pmu_bat_para14
    {4062, 0, 0, 0, 0},                     // pmu_bat_para15
    {4125, 0, 0, 0, 0}                      // pmu_bat_para16   
};

static struct energy_array battery_energy_discharge[16] = {
    {3132, 0, 0, 0, 0},                     // pmu_bat_para1
    {3273, 0, 0, 0, 0},                     // pmu_bat_para2
    {3414, 0, 0, 0, 0},                     // pmu_bat_para3
    {3555, 0, 0, 0, 0},                     // pmu_bat_para4
    {3625, 0, 0, 0, 0},                     // pmu_bat_para5
    {3660, 0, 0, 0, 0},                     // pmu_bat_para6
    {3696, 0, 0, 0, 0},                     // pmu_bat_para7
    {3731, 0, 0, 0, 0},                     // pmu_bat_para8
    {3766, 0, 0, 0, 0},                     // pmu_bat_para9
    {3801, 0, 0, 0, 0},                     // pmu_bat_para10
    {3836, 0, 0, 0, 0},                     // pmu_bat_para11
    {3872, 0, 0, 0, 0},                     // pmu_bat_para12
    {3935, 0, 0, 0, 0},                     // pmu_bat_para13
    {3998, 0, 0, 0, 0},                     // pmu_bat_para14
    {4062, 0, 0, 0, 0},                     // pmu_bat_para15
    {4125, 0, 0, 0, 0}                      // pmu_bat_para16   
};

int32_t  ocv_history = 0;
uint32_t ocv_float   = 0;

static int32_t update_ocv(int32_t ocv)
{
#if 0
    int32_t i = 0;
    int32_t total = ocv * 4;

    for (i = 0; i < 3; i++) {
        total += ocv_array[i + 1] * (i+1);
        ocv_array[i] = ocv_array[i+1];
    }
    ocv_array[3] = ocv;
    return total / 10;
#else
    int tmp;
    if (ocv - ocv_history >= 64) {                          // truncated difference to 64mV 
        ocv = ocv_history + 64;
    } else if (ocv_history - ocv >= 64) {
        ocv = ocv_history - 64;
    }
    tmp = (ocv_history * 7 + ocv);
    ocv_float = (ocv_float * 7 + ((tmp & 0x07) << 28)) / 8;   // Q27
    ocv_history = tmp / 8;
    if (ocv_float & 0x10000000) {                           // over flow
        ocv_history += 1;
        ocv_float &= ~0x10000000;
    }
    return ocv_float & 0x08000000 ? (ocv_history + 1) : ocv_history;
#endif
}

static void inline update_energy_charge(int ocv, int energy, int coulomb, int coulomb_p) 
{
    int i = 0;    
    char    buf[100] = {};
    for (i = 0; i < 16; i++) {
        if (ocv >= battery_energy_charge[i].ocv && !battery_energy_charge[i].updated_flag) {
            battery_energy_charge[i].energy = energy;
            battery_energy_charge[i].coulomb = coulomb;
            battery_energy_charge[i].coulomb_p = coulomb_p;
            battery_energy_charge[i].updated_flag = 1;
          //sprintf(buf, "update energy %9lld for %4d mV, index:%2d\n", 
          //        battery_energy_charge[i].energy, battery_energy_charge[i].ocv, i);
          //terminal_print(0, 35, buf);
            sprintf(buf, "%2d,  %4d,  %9lld,  %4d,  %4d,\n", 
                    i,
                    battery_energy_charge[i].ocv, 
                    battery_energy_charge[i].energy, 
                    battery_energy_charge[i].coulomb,
                    battery_energy_charge[i].coulomb_p);
            terminal_print(0, 12 + i, buf);
        }
    }
}

static void check_energy_charge(int ocv, int energy, int coulomb, int coulomb_p)
{
    int i;
    for (i = 0; i < 16; i++) {
        if (!battery_energy_charge[i].updated_flag) {
            battery_energy_charge[i].energy       = energy;
            battery_energy_charge[i].coulomb      = coulomb;
            battery_energy_charge[i].coulomb_p    = coulomb_p;
            battery_energy_charge[i].updated_flag = 1;
        }
    }
}

static void inline update_energy_discharge(int ocv, int energy, int coulomb, int coulomb_p) 
{
    int i = 0;
    char    buf[100] = {};
    for (i = 0; i < 16; i++) {
        if (ocv < battery_energy_discharge[i].ocv && !battery_energy_discharge[i].updated_flag) {
            battery_energy_discharge[i].energy = energy;
            battery_energy_discharge[i].coulomb = coulomb;
            battery_energy_discharge[i].coulomb_p = coulomb_p;
            battery_energy_discharge[i].updated_flag = 1;
          //sprintf(buf, "update energy %9lld for %4d mV, index:%2d\n", 
          //       battery_energy_discharge[i].energy, battery_energy_discharge[i].ocv, i);
          //terminal_print(0, 35, buf);
            sprintf(buf, "%2d,  %4d,  %9lld,  %4d,  %4d,\n", 
                    i,
                    battery_energy_discharge[i].ocv, 
                    battery_energy_discharge[i].energy, 
                    battery_energy_discharge[i].coulomb,
                    battery_energy_discharge[i].coulomb_p);
            terminal_print(60, 12 + i, buf);
        }
    }
}

static void check_energy_discharge(int ocv, int energy, int coulomb, int coulomb_p)
{
    int i = 0;
    for (i = 0; i < 16; i++) {
        if (!battery_energy_discharge[i].updated_flag) {
            battery_energy_charge[i].energy       = energy;
            battery_energy_charge[i].coulomb      = coulomb;
            battery_energy_charge[i].coulomb_p    = coulomb_p;
            battery_energy_charge[i].updated_flag = 1;
        }
    }
}

void  ClearScreen(void)                                 // screen clear for terminal
{
    char    buff[15] = {};
    int     length=0;
                
    sprintf(buff, "\033[2J\033[0m");
    while (buff[length] != '\0') { 
        length ++;
    }
    printf(buff);
}

#ifdef CONFIG_VIDEO_AMLLCD
#include <amlogic/aml_lcd.h>
extern struct panel_operations panel_oper;
#endif

int aml_battery_calibrate(void)
{
    int64_t energy_c = 0;
    int64_t energy_p = 0;
    int     prev_coulomb = 0;
    int     prev_ocv  = 0;
    int     prev_ibat = 0;
    int     key;
    int     ibat_cnt = 0;
    int     i;
    int64_t energy_top, energy_visible;
    int     base, offset, range_charge, percent, range_discharge;
    char    buf[200] = {};
    int     size;
    int     ocv_0 = 2;
    int     ocv_avg = 0;
    int     rdc_average = 0, rdc_total = 0, rdc_cnt = 0, rdc_update_flag = 0, rdc_tmp = 0;
    int     charge_eff;

    ClearScreen();
    terminal_print(0,  7, "=============================== WARNING ================================\n");
    terminal_print(0,  8, "Battery calibrate will take several hours to finish. Before calibrate,  \n");
    terminal_print(0,  9, "make sure you have discharge battery with voltage between to 3.0V ~ 3.05V.\n");
    terminal_print(0, 10, "during test, you can press key 'Q' to quit this process.\n");
    terminal_print(0, 11, "'R' = run calibration, 'Q' = quit. Your Choise:\n");

    while (1) {
        if (tstc()) {
            key = getc();
            if (key == 'r' || key == 'R') {
                break;
            }
            if (key == 'q' || key == 'Q') {
                goto out;
            }
        }
        udelay(10000);
    } 

#ifdef CONFIG_VIDEO_AMLLCD
    if (panel_oper.set_bl_level) {                        // to save system current consume
        panel_oper.set_bl_level(10);
    }
#endif
    ClearScreen(); 
    terminal_print(0, 1, "'Q' = quit, 'S' = Skip this step\n");
    terminal_print(0, 4, "coulomb     energy_c    ibat   prev_ibat    ocv"
                         "     ocv_hist    coulomb_p   vbat    rdc\n");
    if (!aml_rdc_init()) {
        terminal_print(0, 36, "#### calculate RDC failed, stop test!!! ####\n");
        goto out;
    }
    aml_update_calibrate(1);
    prev_coulomb = coulomb;
    prev_ocv = ocv;
    prev_ibat = ibat;
    for (i = 0; i < 4; i++) {
        aml_update_calibrate(0);
        ocv_avg += ocv;
    }
    ocv_history = ocv_avg / 4;

    while (1) {
        if (tstc()) {
            key = getc();
            if (key == 'Q' || key == 'q') {
                terminal_print(0, 35, "You have aborted calibrate manually\n");
                goto out;
            }
            if (key == 'S' || key == 's') {
                terminal_print(0, 35, "Skip charging calibrate\n");
                break;
            }
        }
        rdc_tmp = aml_update_calibrate(1);
        if (rdc_tmp) {
            rdc_total += rdc_tmp; 
            rdc_cnt++;
        }
        if (ocv > 3520 && !rdc_update_flag) {
            if (rdc_cnt) {
                rdc_average = rdc_total / rdc_cnt; 
                sprintf(buf, "RDC set to %d mohm, rdc_total:%d, cnt:%d\n", rdc_average, rdc_total, rdc_cnt);
                terminal_print(0, 35, buf);
                rdc = rdc_average;
                rdc_update_flag = 1;
            } else {
                terminal_print(0, 35, "WRONG with rdc calculate, we stop this test now!!!\n");     
                goto out; 
            }
        }
        energy_c += ABS((coulomb - prev_coulomb) * ((ocv + prev_ocv) / 2));
        energy_p = energy_c;
        do_div(energy_p, 3700);
        update_energy_charge(update_ocv(ocv), energy_c, coulomb, energy_p);
        size  = sprintf(buf, 
                        "%4d,   %12lld,   %4d,       %4d,  %4d,        %4d,",
                        coulomb, energy_c, ibat, prev_ibat, ocv, ocv_history);
        size += sprintf(buf + size,
                        "        %4d,  %4d,  %4d  \n",
                        (int32_t)energy_p, vbat, rdc);
        buf[size] = '\0';
        terminal_print(0, 5, buf);
        prev_coulomb = coulomb;
        prev_ocv = ocv;
        prev_ibat = ibat;
        udelay(1000000);
        if (ibat <= 40 && ocv >= 4000) {                        // charging finished
            ibat_cnt++;
            if (ibat_cnt > 50) {
                break;
            }
        }
    }
    check_energy_charge(ocv, energy_c, coulomb, energy_p);
    rdc = rdc_total / rdc_cnt;									// set RDC to average value during charge
    sprintf(buf, "RDC set to %d mohm, rdc_total:%d, cnt:%d    \n", rdc, rdc_total, rdc_cnt);
    terminal_print(0, 35, buf);

    energy_top = energy_c;
    terminal_print(0, 10, "============= RESULT FOR CHARGE ================\n");
    terminal_print(0, 11, "i,    ocv,     energy,     c,   c_e,   off,    %%\n");
    offset = battery_energy_charge[15].coulomb_p - battery_energy_charge[2].coulomb_p;
    i = (battery_energy_charge[3].coulomb_p - battery_energy_charge[2].coulomb_p) * 100;
    if ((i / offset) >= 3) {
        ocv_0 = 2; 
        terminal_print(0, 35, "We set zero reference ocv to 3414mV\n");
    } else {
        ocv_0 = 3;    
        terminal_print(0, 35, "We set zero reference ocv to 3555mV\n");
    }
    base = battery_energy_charge[ocv_0].coulomb_p;
    range_charge = battery_energy_charge[15].coulomb_p - base;
    for (i = 0; i < 16; i++) {
        energy_p = battery_energy_charge[i].energy * 100;
        if (i <= ocv_0) {
            offset  = 0;
            percent = 0;
        } else {
            offset = battery_energy_charge[i].coulomb_p - base;
            percent = 100 * (offset + range_charge / 200) / range_charge;
        }
        size = sprintf(buf, "%2d,  %4d,  %9lld,  %4d,  %4d,  %4d,  %3d\n", 
                       i,
                       battery_energy_charge[i].ocv, 
                       battery_energy_charge[i].energy, 
                       battery_energy_charge[i].coulomb,
                       battery_energy_charge[i].coulomb_p,
                       offset,
                       percent);
        buf[size] = '\0';
        terminal_print(0, 12 + i, buf);
    }
    energy_p = energy_top;
    do_div(energy_p, 3700);
    size = sprintf(buf, "Total charge energy:%9lld(mV * mAh) = %5dmAh@3700mV\n", 
                   energy_top, (int32_t)energy_p);
    buf[size] = '\0';
    terminal_print(0, 30, buf);
    size = sprintf(buf, "Energy visible:%5dmAh@3700mV, percent:%2d\n", 
                   range_charge, range_charge * 100 / (int32_t)energy_p);
    buf[size] = '\0';
    terminal_print(0, 31, buf);

    /*
     * test for discharge
     */
    terminal_print(0, 35, "Please unplug DC power, then press 'R' to contine\n");
    while (1) {
        if (tstc()) {
            key = getc();
            if (key == 'r' || key == 'R') {
                break;
            }
            if (key == 'q' || key == 'Q') {
                goto out;
            }
        }
        udelay(10000);
    } 

    terminal_print(0, 35, "do discharge calibration now, please don't plug DC power during test!\n");

#ifdef CONFIG_VIDEO_AMLLCD
    if (panel_oper.set_bl_level) {                        // to fast discharge 
        panel_oper.set_bl_level(200);
    }
#endif
    energy_c = 0;
    while (1) {
        if (tstc()) {
            key = getc();
            if (key == 'Q' || key == 'q') {
                terminal_print(0, 35, "You have aborted calibrate manually\n");
                goto out;
            }
            if (key == 'S' || key == 's') {
                terminal_print(0, 35, "Skip discharging calibrate\n");
                break;
            }
        }
        aml_update_calibrate(0); 
        energy_c += ABS((prev_coulomb - coulomb) * ((ocv + prev_ocv) / 2));
        energy_p = energy_c;
        do_div(energy_p, 3700);
        update_energy_discharge(update_ocv(ocv), energy_c, coulomb, energy_p);
        size  = sprintf(buf, 
                        "%4d,   %12lld,   %4d,       %4d,  %4d,        %4d,",
                        coulomb, energy_c, ibat, prev_ibat, ocv, ocv_history);
        size += sprintf(buf + size,
                        "        %4d,  %4d,  %4d  \n",
                        (int32_t)energy_p, vbat, rdc);
        buf[size] = '\0';
        terminal_print(0, 5, buf);
        prev_coulomb = coulomb;
        prev_ocv = ocv;
        prev_ibat = ibat;
        udelay(1000000);
        if (ocv < 3350) {
            terminal_print(0, 35, "ocv is too low, we stop discharging test now!\n");
            break;
        }
    }

    check_energy_discharge(ocv, energy_c, coulomb, energy_p);
    energy_top = energy_c;
    terminal_print(60, 10, "============ RESULT FOR DISCHARGE ==============\n");
    terminal_print(60, 11, "i,    ocv,     energy,     c,   c_e,   off,    %%\n");
    base = battery_energy_discharge[15].coulomb_p;
    range_discharge = battery_energy_discharge[ocv_0].coulomb_p - base;
    for (i = 0; i < 16; i++) {
        energy_p = battery_energy_discharge[i].energy * 100;
        if (i < ocv_0) {
            offset  = 0;
            percent = 0;
        } else {
            offset = battery_energy_discharge[i].coulomb_p - base;
            percent = 100 - 100 * (offset + range_discharge / 200) / range_discharge;
        }
        size = sprintf(buf, "%2d,  %4d,  %9lld,  %4d,  %4d,  %4d,  %3d\n", 
                       i,
                       battery_energy_discharge[i].ocv, 
                       battery_energy_discharge[i].energy, 
                       battery_energy_discharge[i].coulomb,
                       battery_energy_discharge[i].coulomb_p,
                       offset,
                       percent);
        buf[size] = '\0';
        terminal_print(60, 12 + i, buf);
    }
    energy_p = energy_top;
    do_div(energy_p, 3700);
    size = sprintf(buf, "Energy visible:%5dmAh@3700mV\n", range_discharge);
    buf[size] = '\0';
    terminal_print(60, 30, buf);
    charge_eff = (100 * (range_discharge + range_charge / 200)) / range_charge;
    if (charge_eff >= 100) {
        charge_eff = 99;                                                // let charge_efficient max to 99
    }
    size = sprintf(buf, "Charging efficient:%d%%\n", charge_eff); 
    buf[size] = '\0';
    terminal_print(60, 31, buf);

out:
    terminal_print(0, 38, "\n\n");
    return 1;
}
#endif /* CONFIG_UBOOT_BATTERY_PARAMETER_TEST */

