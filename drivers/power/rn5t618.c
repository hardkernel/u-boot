#include <common.h>
#include <div64.h>
#include <asm/setup.h>
#include <asm/arch/i2c.h>
#include <asm/arch/gpio.h>
#include <aml_i2c.h>
#include <amlogic/aml_lcd.h>
#include <amlogic/rn5t618.h>

#include <amlogic/aml_pmu_common.h>
#ifdef CONFIG_UBOOT_BATTERY_PARAMETERS
#include <amlogic/aml_lcd.h>
#include <amlogic/battery_parameter.h>
#endif
#ifdef CONFIG_UBOOT_BATTERY_PARAMETER_TEST
int rn5t618_battery_calibrate(void);
#endif

#define ABS(x)          ((x) >0 ? (x) : -(x) )
#define MAX_BUF         100
#define RN5T618_ADDR    0x32

#define DBG(format, args...) printf("[RN5T618]"format,##args)
static int rn5t618_curr_dir = 0;
static int rn5t618_battery_test = 0;

int rn5t618_write(int add, uint8_t val)
{
    int ret;
    uint8_t buf[2] = {};
    buf[0] = add & 0xff;
    buf[1] = val & 0xff;
    struct i2c_msg msg[] = {
        {
            .addr  = RN5T618_ADDR,
            .flags = 0,
            .len   = sizeof(buf),
            .buf   = buf,
        }
    };
    ret = aml_i2c_xfer_slow(msg, 1);
    if (ret < 0) {
        DBG("%s: i2c transfer failed, ret:%d\n", __func__, ret);
        return ret;
    }
    return 0;
}

int rn5t618_writes(int add, uint8_t *buff, int len)
{
    int ret;
    uint8_t buf[MAX_BUF] = {};
    buf[0] = add & 0xff;
    memcpy(buf + 1, buff, len);
    struct i2c_msg msg[] = {
        {
            .addr  = RN5T618_ADDR,
            .flags = 0,
            .len   = len + 1,
            .buf   = buf,
        }
    };
    ret = aml_i2c_xfer_slow(msg, 1);
    if (ret < 0) {
        DBG("%s: i2c transfer failed, ret:%d\n", __FUNCTION__, ret);
        return ret;
    }
    return 0;
}

int rn5t618_read(int add, uint8_t *val)
{
    int ret;
    uint8_t buf[1] = {};
    buf[0] = add & 0xff;
    struct i2c_msg msg[] = {
        {
            .addr  = RN5T618_ADDR,
            .flags = 0,
            .len   = sizeof(buf),
            .buf   = buf,
        },
        {
            .addr  = RN5T618_ADDR,
            .flags = I2C_M_RD,
            .len   = 1,
            .buf   = val,
        }
    };
    ret = aml_i2c_xfer_slow(msg, 2);
    if (ret < 0) {
        DBG("%s: i2c transfer failed, ret:%d\n", __FUNCTION__, ret);
        return ret;
    }
    return 0;
}

int rn5t618_reads(int add, uint8_t *buff, int len)
{
    int ret;
    uint8_t buf[1] = {};
    buf[0] = add & 0xff;
    struct i2c_msg msg[] = {
        {
            .addr  = RN5T618_ADDR,
            .flags = 0,
            .len   = sizeof(buf),
            .buf   = buf,
        },
        {
            .addr  = RN5T618_ADDR,
            .flags = I2C_M_RD,
            .len   = len,
            .buf   = buff,
        }
    };
    ret = aml_i2c_xfer_slow(msg, 2);
    if (ret < 0) {
        DBG("%s: i2c transfer failed, ret:%d\n", __FUNCTION__, ret);
        return ret;
    }
    return 0;
}

int rn5t618_set_bits(int add, uint8_t bits, uint8_t mask)
{
    uint8_t val;
    rn5t618_read(add, &val);
    val &= ~(mask);                                         // clear bits;
    val |=  (bits & mask);                                  // set bits;
    return rn5t618_write(add, val);
}

int rn5t618_get_battery_voltage(void)
{
    uint8_t val[2];
    int result = 0;
    int tmp;
    int i;
    for (i = 0; i < 8; i++) {
        rn5t618_set_bits(0x0066, 0x01, 0x07);                   // select vbat channel
        udelay(200);
        rn5t618_reads(0x006A, val, 2);
        tmp = (val[0] << 4) | (val[1] & 0x0f);
        tmp = (tmp * 5000) / 4096;                              // resolution: 1.221mV
        result += tmp;
    }

    return result / 8;
}

int rn5t618_get_charge_status(int print)
{
    uint16_t val = 0;
    uint8_t status;

    rn5t618_read(0x00BD, &val);
    if (rn5t618_curr_dir < 0) {
        val |= 0x8000;    
    }
    if (print) {
        printf("-- charge status:0x%04x ", val);
    }
    status = (val & 0x1f);
    if ((val & 0xc0) && (rn5t618_curr_dir == 1)) {
        if (status == 2 || status ==3) {
            return 1;                                       // charging    
        } else {
            return 0;    
        }
    } else {
        return 2;
    }
    return 0;
}

static int rn5t618_get_coulomber(void)
{
    uint8_t val[4];
    int result;

    result = rn5t618_reads(0x00F3, val, 4);
    if (result) {
        printf("%s, failed: %d\n", __func__, __LINE__);
        return result;
    }    

    result = val[3] | (val[2] << 8) | (val[1] << 16) | (val[0] << 24); 
    result = result / (3600);                                           // to mAh
    return result;
}

int rn5t618_get_battery_current(void)
{
    uint8_t val[2];
    int result;

    rn5t618_reads(0x00FB, val, 2);
    result = ((val[0] & 0x3f) << 8) | (val[1]);
    if (result & 0x2000) {                                  // discharging, complement code
        result = result ^ 0x3fff;
        rn5t618_curr_dir = -1;
    } else {
        rn5t618_curr_dir = 1;
    }

    return result;
}

int rn5t618_set_gpio(int gpio, int output)
{
    int val = output ? 1 : 0;
//    DBG("%s, gpio:%d, output:%d\n", __func__, gpio, output);
    if (gpio < 0 || gpio > 3) {
        DBG("%s, wrong input of GPIO:%d\n", __func__, gpio);
        return -1;
    }
    rn5t618_set_bits(0x0091, val << gpio, 1 << gpio);       // set out put value
    rn5t618_set_bits(0x0090, 1 << gpio, 1 << gpio);         // set pin to output mode
    return 0;
}

int rn5t618_get_gpio(int gpio, int *val)
{
    int value;
    if (gpio < 0 || gpio > 3) {
        DBG("%s, wrong input of GPIO:%d\n", __func__, gpio);
        return -1;
    }
    rn5t618_read(0x0097, &value);                           // read status
    *val = (value & (1 << gpio)) ? 1 : 0;
    return 0;
}

#define RN5T618     0
#define RN5T567     1
int ricoh_check_pmu_type()
{
    uint8_t val[2] = {};

    rn5t618_reads(0x00, val, 2);
    printf("LSI version:%02x, OTP version:%02x\n", val[0], val[1]);
    if (val[0] == 0x01 && val[1] == 0x01) {
        printf("PMU type:RN5T567\n");
        return RN5T567;
    } else {
        printf("PMU type:RN5T618\n");
        return RN5T618;
    }
    return -1;
}

void rn5t618_power_off()
{
    uint8_t reg_coulomb[4];
    uint8_t reg_save[4];
    uint8_t flag;
    int32_t save_coulomb, curr_coulomb;

    /*
     * save coulomb registers to PMU before power off
     */
    rn5t618_read(0x01, reg_coulomb);
    if (reg_coulomb[0] > 0x06) {                               // OTP verion is more than RN5T618F
        rn5t618_read(0x0007, &flag);
        printf("---- save flag:%02x\n", flag);
        rn5t618_reads(0x00F3, reg_coulomb, 4);
        rn5t618_write(0x00ff, 0x01);                            // change to register banck 1
        printf("curr coulomb:0x%02x %02x %02x %02x\n", 
               reg_coulomb[0], reg_coulomb[1], reg_coulomb[2], reg_coulomb[3]);
        curr_coulomb = (reg_coulomb[3] <<  0) | 
                       (reg_coulomb[2] <<  8) | 
                       (reg_coulomb[1] << 16) | 
                       (reg_coulomb[0] << 24);
        if (flag & 0x40) {
            rn5t618_read(0x00bd, &reg_save[0]);
            rn5t618_read(0x00bf, &reg_save[1]);
            rn5t618_read(0x00c1, &reg_save[2]);
            rn5t618_read(0x00c3, &reg_save[3]);
            printf("---- already saved coulomb:0x%02x %02x %02x %02x\n",
                   reg_save[0], reg_save[1], reg_save[2], reg_save[3]);
            save_coulomb = (reg_save[3] <<  0) | 
                           (reg_save[2] <<  8) | 
                           (reg_save[1] << 16) | 
                           (reg_save[0] << 24);
            curr_coulomb += save_coulomb;
        }
        reg_coulomb[0] = (curr_coulomb >> 24) & 0xff;
        reg_coulomb[1] = (curr_coulomb >> 16) & 0xff;
        reg_coulomb[2] = (curr_coulomb >>  8) & 0xff;
        reg_coulomb[3] = (curr_coulomb >>  0) & 0xff;
        printf("save coulomb:0x%02x %02x %02x %02x\n", 
               reg_coulomb[0], reg_coulomb[1], reg_coulomb[2], reg_coulomb[3]);
        rn5t618_write(0x00bd, reg_coulomb[0]);
        rn5t618_write(0x00bf, reg_coulomb[1]);
        rn5t618_write(0x00c1, reg_coulomb[2]);
        rn5t618_write(0x00c3, reg_coulomb[3]);
        rn5t618_write(0x00ff, 0x00);                            // back to banck 0;
        rn5t618_set_bits(0x0007, 0x40, 0x60);                   // set flag
        rn5t618_set_bits(0x00EF, 0x08, 0x08);                   
    }

#ifdef CONFIG_RESET_TO_SYSTEM
    rn5t618_set_bits(0x0007, 0x00, 0x01);
#endif
    rn5t618_set_gpio(0, 1);
    rn5t618_set_gpio(1, 1);
    udelay(100 * 1000);
    rn5t618_set_bits(0x00EF, 0x00, 0x10);                     // disable coulomb counter
    rn5t618_set_bits(0x00E0, 0x00, 0x01);                     // disable fuel gauge 
    DBG("%s, send power off command\n", __func__);
    rn5t618_set_bits(0x000f, 0x00, 0x01);                     // do not re-power-on system 
    rn5t618_set_bits(0x000E, 0x01, 0x01);                     // software power off PMU
    udelay(100);
    while (1) {
        udelay(1000 * 1000);
        DBG("%s, error\n", __func__);
    }
}

int rn5t618_set_usb_current_limit(int limit)
{
    int val;
    if ((limit < 0 || limit > 1500) && (limit != -1)) {
       DBG("%s, wrong usb current limit:%d\n", __func__, limit); 
       return -1;
    }
    if (limit == -1) {                                       // -1 means not limit, so set limit to max
        limit = 1500;    
    }
    val = (limit / 100) - 1;
    DBG("%s, set usb current limit to %d\n", __func__, limit);
    return rn5t618_set_bits(0x00B7, val, 0x1f);
}

#ifdef CONFIG_UBOOT_BATTERY_PARAMETERS
static int avg_voltage = 0, avg_current = 0;
int rn5t618_get_ocv(int rdc, int cnt)
{
    int vbat;
    int ibat;
    int ocv;
    int charge_status;

    vbat = rn5t618_get_battery_voltage();
    ibat = rn5t618_get_battery_current();
    charge_status = rn5t618_get_charge_status(!cnt);
    if (charge_status == 1) {
        ocv = vbat - (ibat * rdc) / 1000;
    } else if (charge_status == 2) {
        ocv = vbat + (ibat * rdc) / 1000;    
    } else {
        ocv = vbat;    
    }   
    avg_voltage += vbat;
    avg_current += ibat;
    return ocv;
}
#endif

int rn5t618_get_charging_percent()
{
    int rest_vol;
#ifdef CONFIG_UBOOT_BATTERY_PARAMETERS
    int i;
    int ocv = 0;
    int ocv_diff, percent_diff, ocv_diff2;
    int percent1, percent2;
    int charge_status;
    int para_flag;
    static int ocv_full  = 0;
    static int ocv_empty = 0;
    static int battery_rdc;
    static struct battery_curve *battery_curve;

    para_flag = get_battery_para_flag();
    if (para_flag == PARA_UNPARSED || para_flag == PARA_PARSE_SUCCESS) {
        /*
         * this code runs earlier than get_battery_para(), 
         * we need to know battery parameters first.
         */
        if (para_flag == PARA_UNPARSED) {
            if (parse_battery_parameters() > 0) {
                set_battery_para_flag(PARA_PARSE_SUCCESS);
                para_flag = PARA_PARSE_SUCCESS;
            } else {
                set_battery_para_flag(PARA_PARSE_FAILED);
            }
        }
        if (para_flag == PARA_PARSE_SUCCESS) {
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
        }
    } 
    if (get_battery_para_flag() != PARA_PARSE_SUCCESS && !ocv_full) {
        /*   
         * parse battery parameters failed, use configured parameters
         */
        extern int config_battery_rdc;
        extern struct battery_curve config_battery_curve[]; 
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
    avg_voltage = 0;
    avg_current = 0;
    for (i = 0; i < 8; i++) {                           // calculate average ocv
        ocv += rn5t618_get_ocv(battery_rdc, i); 
        udelay(10000); 
    }
    ocv = ocv / 8;
    avg_voltage /= 8;
    avg_current /= 8;
    printf(", voltage:%4d, current:%4d, ocv is %4d, ", avg_voltage, avg_current * rn5t618_curr_dir, ocv);
    if (ocv >= ocv_full) {
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
    return 50;           // test now
}

int rn5t618_set_charging_current(int current)
{
#ifdef CONFIG_UBOOT_BATTERY_PARAMETERS
    int val;

    if (current > 1800 * 1000 || current < 0) {
        DBG("%s, wrong input of charge current:%d\n", __func__, current);
        return -1;
    }
    if (current > 100) {                        // input is uA
        current = current / 1000;
    } else {                                    // input is charge ratio
        current = (current * board_battery_para.pmu_battery_cap) / 100 + 100; 
    } 
    if (current > 1600) {                       // for safety, do not let charge current large than 90% of max charge current
        current = 1600;    
    }
    val = (current / 100) - 1;
    if (!rn5t618_battery_test) {                // do not print when test
        printf("%s, %dmA\n", __func__, current);
    }
    return rn5t618_set_bits(0x00B8, val, 0x1f);
#else
    return 0;
#endif
}

int rn5t618_charger_online(void)
{
    int val;
    rn5t618_read(0x00BD, &val);
    if (val & 0xc0) {
        return 1;    
    } else {
        return 0;    
    }
}

int rn5t618_set_charge_enable(int enable)
{
    int bits = enable ? 0x03 : 0x00;

    return rn5t618_set_bits(0x00B3, bits, 0x03);
}

int rn5t618_set_full_charge_voltage(int voltage)
{ 
    int bits;

    if (voltage > 4350 * 1000 || voltage < 4050 * 1000) {
        printf("%s, invalid target charge voltage:%d\n", __func__, voltage);
        return -1;
    }    
    if (voltage == 4350000) {
        /*
         * If target charge voltage is 4.35v, should close charger first.
         */
        bits = 0x40;    
        rn5t618_set_charge_enable(0);
        udelay(50 * 1000);
        rn5t618_set_bits(0x00BB, bits, 0x70);
        return 0;
    } else {
        bits = ((voltage - 4050000) / 50000) << 4;
    }    
    return rn5t618_set_bits(0x00BB, bits, 0x70);
}

int rn5t618_set_charge_end_current(int curr)
{
    int bits;

    if (curr < 50000 || curr > 200000) {
        printf("%s, invalid charge end current:%d\n", __func__, curr);
        return -1;
    }
    bits = (curr / 50000 - 1) << 6;
    return rn5t618_set_bits(0x00B8, bits, 0xc0);
}

int rn5t618_set_trickle_time(int minutes)
{
    int bits;

    if (minutes != 40 && minutes != 80) {
        printf("%s, invalid trickle time:%d\n", __func__, minutes);
        return -1;
    }
    bits = (minutes == 40) ? 0x00 : 0x10;
    return rn5t618_set_bits(0x00B9, bits, 0x30);
}

int rn5t618_set_rapid_time(int minutes)
{
    int bits;

    if (minutes > 300 || minutes < 120) {
        printf("%s, invalid rapid charge time:%d\n", __func__, minutes);
        return -1;
    }
    bits = (minutes - 120) / 60;
    return rn5t618_set_bits(0x00B9, bits, 0x03);
}

int rn5t618_set_long_press_time(int ms)
{
    int bits;

    if (ms < 1000 || ms > 12000) {
        printf("%s, invalid long press time:%d\n", __func__, ms);
        return -1;
    }
    switch(ms) {
    case  1000: bits = 0x10; break;
    case  2000: bits = 0x20; break;
    case  4000: bits = 0x30; break;
    case  6000: bits = 0x40; break;
    case  8000: bits = 0x50; break;
    case 10000: bits = 0x60; break;
    case 12000: bits = 0x70; break;
    default : return -1;
    }
    return rn5t618_set_bits(0x0010, bits, 0x70);
}

int rn5t618_set_recharge_voltage(int voltage)
{
    int bits;

    if (voltage < 3850 || voltage > 4100) {
        printf("%s, invalid recharge volatage:%d\n", __func__, voltage);
        return -1;
    }
    if (voltage == 4100) {
        bits = 0x04;
    } else {
        bits = ((voltage - 3850) / 50);
    }
    return rn5t618_set_bits(0x00BB, bits, 0x07);
}

int rn5t618_inti_para(struct battery_parameter *battery)
{
    if (battery) {
        rn5t618_set_full_charge_voltage(battery->pmu_init_chgvol);
        rn5t618_set_charge_end_current (150000);
        rn5t618_set_charging_current   (battery->pmu_init_chgcur);
        rn5t618_set_trickle_time       (battery->pmu_init_chg_pretime);
        rn5t618_set_rapid_time         (battery->pmu_init_chg_csttime);
        rn5t618_set_charge_enable      (battery->pmu_init_chg_enabled);
        rn5t618_set_long_press_time    (battery->pmu_pekoff_time);
        rn5t618_set_recharge_voltage   (4100);
        return 0;
    } else {
        return -1;    
    }
}

void dump_pmu_register(void)
{
    uint8_t val[16];
    int     i;
    uint8_t idx_table[] = {0x0, 0x1, 0x2, 0x3, 0x4, 0x5, 0xb};

    printf("[RN5T618] DUMP ALL REGISTERS\n");
    for (i = 0; i < sizeof(idx_table); i++) {
        rn5t618_reads(idx_table[i] * 16, val, 16);
        printf("0x%02x - %02x: ", idx_table[i] * 16, idx_table[i] * 16 + 15);
        printf("%02x %02x %02x %02x ",   val[0],  val[1],  val[2],  val[3]);
        printf("%02x %02x %02x %02x   ", val[4],  val[5],  val[6],  val[7]);
        printf("%02x %02x %02x %02x ",   val[8],  val[9],  val[10], val[11]);
        printf("%02x %02x %02x %02x\n",  val[12], val[13], val[14], val[15]);
    }
}

uint8_t mov_hex(uint8_t input)
{
    uint8_t tmp = input & 0xf0;
    tmp = tmp | (tmp >> 4);
    return tmp;
}

int rn5t618_check_fault(void)
{
    uint8_t val;
    int i = 0;;
    char *fault_reason[] = {
        "PWRONPOFF",                        // bit 0
        "abnormal temperature",             // bit 1
        "low power condition in VINDET",    // bit 2
        "IODETPOFF",                        // bit 3
        "CPUPOFF",                          // bit 4
        "watchdog power off",               // bit 5
        "overcurrent of DCDC1-3",           // bit 6
        "N_OEPOF"                           // bit 7
    };

    printf("PMU fault status:\n");
    rn5t618_read(0x000A, &val);
    while (val) {
        if (val & 0x01) {
            printf("-- %s\n", fault_reason[i]);    
        }
        i++;
        val >>= 1;
    }
    return 0;
}

#ifdef CONFIG_RESET_TO_SYSTEM
static int prev_boot_flag = 0;
static int rn5t618_reset_flag_operation(int op)
{
    switch (op) {
    case RESET_FLAG_GET:
        return prev_boot_flag; 

    case RESET_FLAG_SET:
        return rn5t618_set_bits(0x0007, 0x01, 0x01);

    case RESET_FLAG_CLR:
        return rn5t618_set_bits(0x0007, 0x00, 0x01);
    }
    return 0;
}
#endif

int rn5t618_init(void)
{
    uint8_t buf[10];

#ifdef CONFIG_RESET_TO_SYSTEM
    rn5t618_read(0x0007, buf);
    printf("boot flags in PMU:0x%x", buf[0]);
    if (buf[0] & 0x7f) {
        /*
         * flag in pmu register is set but not cleared before reboot, 
         * so this boot must be RESET key pressed
         */
        prev_boot_flag = 1;    
    }
#endif

    /*
     * watchdog must be enabled if defined CONFIG_RESET_TO_SYSTEM
     */
#if defined(CONFIG_ENABLE_PMU_WATCHDOG) || defined(CONFIG_RESET_TO_SYSTEM)
    rn5t618_set_bits(0x000b, 0x00, 0xc0);                       // close watch dog timer
    rn5t618_set_bits(0x0012, 0x00, 0x40);                       // disable watchdog
    rn5t618_set_bits(0x000f, 0x01, 0x01);                       // re-power-on system after reset
#endif
#ifdef CONFIG_DISABLE_POWER_KEY_OFF
    rn5t618_set_bits(0x0010, 0x80, 0x80);                       // disable power off PMU by long press power key 
#endif
    rn5t618_check_fault();
    rn5t618_write(0x04, 0xA5);
    rn5t618_read(0x009A, buf);
    printf("reg[0x9A] = 0x%02x\n", buf[0]);
    if ((buf[0] &0xf0) != 0xf0) {
        rn5t618_set_bits(0x9A, 0x00, 0x10);                     // change GPIO3 from PSO to GPIO function
    }

    rn5t618_write(0x0066, 0x00);                                // clear ADRQ to stop ADC 
    rn5t618_set_bits(0x0064, 0x2f, 0x2f);                       // open VBAT and IBAT adc to auto-mode
    rn5t618_set_bits(0x0065, 0x00, 0x07);                       // set AUTO_TIMER to 250 ms
    rn5t618_set_bits(0x0066, 0x28, 0x38);                       // auto mode of ADC, 4 average of each sample
    rn5t618_set_bits(0x00B3, 0x03, 0x03);                       // enable charge of vbus/dcin
    rn5t618_set_bits(0x00BB, 0x34, 0x77);                       // charge target voltage to 4.2v, recharge-voltage to 4.1v
    rn5t618_set_bits(0x002C, 0x00, 0x30);                       // DCDC1 set to auto-mode
    rn5t618_set_bits(0x002E, 0x00, 0x30);                       // DCDC2 set to auto-mode
    rn5t618_set_bits(0x0030, 0x00, 0x30);                       // DCDC3 set to auto-mode
    if (ricoh_check_pmu_type() == RN5T618) {
        rn5t618_set_bits(0x002F, 0x40, 0xc0);                       // DCDC2 frequent set to 2.2MHz
    }
    rn5t618_set_gpio(3, 0);                                     // open GPIO 2, DCDC 3.3
    rn5t618_set_gpio(1, 0);                                     // close GPIO 1, boost 5V 
    rn5t618_set_bits(0x00EF, 0x10, 0x10);                       // enable coulomb counter
    rn5t618_set_bits(0x0010, 0x60, 0x70);                       // set long-press timeout to 10s
//  rn5t618_set_bits(0x00E0, 0x01, 0x01);                       // enable Fuel gauge
    
    /*
     * configure sleep sequence
     */
    rn5t618_reads(0x0016, buf, 3);
    buf[0] = mov_hex(buf[0]);                                   // sleep sequence for DC1
    buf[1] = mov_hex(buf[1]);                                   // sleep sequence for DC2
    buf[2] = mov_hex(buf[2]);                                   // sleep sequence for DC3
    rn5t618_writes(0x0016, buf, 3);
    rn5t618_reads(0x001c, buf, 4);
    buf[0] = mov_hex(buf[0]);                                   // sleep sequence for LDO1
    buf[1] = mov_hex(buf[1]);                                   // sleep sequence for LDO2
    buf[2] = mov_hex(buf[2]);                                   // sleep sequence for LDO3
    buf[3] = mov_hex(buf[3]);                                   // sleep sequence for LDO4
    rn5t618_writes(0x001c, buf, 4);
    rn5t618_reads(0x002A, buf, 1);
    buf[0] = mov_hex(buf[0]);                                   // sleep sequence for LDORTC1 
    rn5t618_writes(0x002A, buf, 1);

    rn5t618_write(0x0013, 0x00);                                // clear watch dog IRQ

    rn5t618_set_bits(0x00B3, 0x00, 0x40);                       // enable rapid-charge to charge end

    rn5t618_set_bits(0x00BC, 0x01, 0x03);                       // set DIE shut temp to 120 Celsius
    rn5t618_set_bits(0x00BA, 0x00, 0x0c);                       // set VWEAK to 3.0V
    rn5t618_set_bits(0x00BB, 0x00, 0x80);                       // set VWEAK to 3.0v
    udelay(100 * 1000);                                         // delay a short time

//    dump_pmu_register();

    return 0;
}

struct aml_pmu_driver g_aml_pmu_driver = {
    .pmu_init                    = rn5t618_init, 
    .pmu_get_battery_capacity    = rn5t618_get_charging_percent,
    .pmu_get_extern_power_status = rn5t618_charger_online,
    .pmu_set_gpio                = rn5t618_set_gpio,
    .pmu_get_gpio                = rn5t618_get_gpio,
    .pmu_reg_read                = rn5t618_read,
    .pmu_reg_write               = rn5t618_write,
    .pmu_reg_reads               = rn5t618_reads,
    .pmu_reg_writes              = rn5t618_writes,
    .pmu_set_bits                = rn5t618_set_bits,
    .pmu_set_usb_current_limit   = rn5t618_set_usb_current_limit,
    .pmu_set_charge_current      = rn5t618_set_charging_current,
    .pmu_power_off               = rn5t618_power_off,
    .pmu_init_para               = rn5t618_inti_para,
#ifdef CONFIG_UBOOT_BATTERY_PARAMETER_TEST
    .pmu_do_battery_calibrate    = rn5t618_battery_calibrate,
#endif
#ifdef CONFIG_RESET_TO_SYSTEM
    .pmu_reset_flag_operation    = rn5t618_reset_flag_operation,
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

int rn5t618_calculate_rdc(void)
{
    char    buf[100];
    int32_t i_lo, i_hi;
    int32_t v_lo, v_hi;
    int32_t rdc_cal = 0;
    int32_t avg;
    static int32_t rdc_avg = 0;
    static int32_t rdc_cnt = 0;

    v_hi = rn5t618_get_battery_voltage();
    if (v_hi > 4000) {                          // to avoid PMU don't charge when battery voltage is high
        return 0;    
    }
    rn5t618_set_charging_current(300 * 1000);           // charge current to 300mA 
    udelay(2500 * 1000);
    i_lo = rn5t618_get_battery_current();
    v_lo = rn5t618_get_battery_voltage();
    rn5t618_set_charging_current(1200 * 1000);          // charge current to 1.2A 
    udelay(2500 * 1000);
    i_hi = rn5t618_get_battery_current();
    v_hi = rn5t618_get_battery_voltage();

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

int rn5t618_rdc_init(void)
{
    int i = 0;
    int rdc_total = 0;
    int success_cnt = 0;
    int rdc_tmp;
    int vbat = 0;
    char buf[100];

    rn5t618_battery_test = 1;
    rn5t618_set_charging_current(300 * 1000);
    do {
        vbat = rn5t618_get_battery_voltage();
        if (vbat < 3100) {
            sprintf(buf, "battery voltage %4d, wait until come into rapid charge state\n", vbat);    
            terminal_print(0, 35, buf);
            udelay(2000 * 1000);
        }
    } while (vbat < 3100);

    for (i = 0; i < 8; i++) {
        rdc_tmp = rn5t618_calculate_rdc();
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

int rn5t618_update_calibrate(int charge)
{
    uint32_t voltage, current;
    uint8_t  status;
    int     rdc_c = 0;

    coulomb = rn5t618_get_coulomber(); 
    voltage = rn5t618_get_battery_voltage(); 
    current = rn5t618_get_battery_current();
    status  = rn5t618_get_charge_status(0);
    if (status == 1) {                        // charging
        ocv = voltage - (current * rdc) / 1000;
    } else {
        ocv = voltage + (current * rdc) / 1000;
    }
    if (charge && ocv < 4000 && ocv > 3100) {         // for test
        rdc_c = rn5t618_calculate_rdc();    
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
    {3942, 0, 0, 0, 0},                     // pmu_bat_para13
    {4012, 0, 0, 0, 0},                     // pmu_bat_para14
    {4083, 0, 0, 0, 0},                     // pmu_bat_para15
    {4153, 0, 0, 0, 0}                      // pmu_bat_para16   
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
    {3942, 0, 0, 0, 0},                     // pmu_bat_para13
    {4012, 0, 0, 0, 0},                     // pmu_bat_para14
    {4083, 0, 0, 0, 0},                     // pmu_bat_para15
    {4153, 0, 0, 0, 0}                      // pmu_bat_para16   
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
extern struct panel_operations panel_oper;
#endif

int rn5t618_battery_calibrate(void)
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
    if (!rn5t618_rdc_init()) {
        terminal_print(0, 36, "#### calculate RDC failed, stop test!!! ####\n");
        goto out;
    }
    rn5t618_update_calibrate(1);
    prev_coulomb = coulomb;
    prev_ocv = ocv;
    prev_ibat = ibat;
    for (i = 0; i < 4; i++) {
        rn5t618_update_calibrate(0);
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
        rdc_tmp = rn5t618_update_calibrate(1);
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
        rn5t618_update_calibrate(0); 
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
    rn5t618_battery_test = 0;
    return 1;
}
#endif /* CONFIG_UBOOT_BATTERY_PARAMETER_TEST */

