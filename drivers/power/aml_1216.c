#include <common.h>
#include <div64.h>
#include <asm/setup.h>
#include <asm/arch/i2c.h>
#include <asm/arch/gpio.h>
#include <aml_i2c.h>
#include <amlogic/aml_lcd.h>
#include <amlogic/aml1216_pmu.h>
#ifdef CONFIG_USB_DWC_OTG_HCD
#include <asm/arch/usb.h>
#endif

#include <amlogic/aml_pmu_common.h>
#ifdef CONFIG_UBOOT_BATTERY_PARAMETERS
#include <amlogic/aml_lcd.h>
#include <amlogic/battery_parameter.h>
#endif
#ifdef CONFIG_UBOOT_BATTERY_PARAMETER_TEST
int aml1216_battery_calibrate(void);
#endif
#define ABS(x)          ((x) >0 ? (x) : -(x) )
#define MAX_BUF         100
#define AML1216_ADDR     0x35

#define DBG(format, args...) printf("[AML1216]"format,##args)
static int aml1216_curr_dir = 0;
static int aml1216_battery_test = 0;
static int charger_sign_bit = 0;

static int pmu_init_chgvol = 0;
static int pmu_init_chg_enabled = 0;
static int battery_rdc = 0;
int aml1216_set_charge_enable(int enable);
int aml1216_write(int add, uint8_t val)
{
    int ret;
    uint8_t buf[3] = {};
    buf[0] = add & 0xff;
    buf[1] = (add >> 8) & 0x0f;
    buf[2] = val & 0xff;
    struct i2c_msg msg[] = {
        {
            .addr  = AML1216_ADDR,
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

int aml1216_write16(uint32_t add, uint32_t val)
{

    int ret;
    uint8_t buf[4] = {};
    buf[0] = add & 0xff;
    buf[1] = (add >> 8) & 0x0f;
    buf[2] = val & 0xff;
    buf[3] = (val >> 8) & 0xff;
    struct i2c_msg msg[] = {
        {
            .addr  = AML1216_ADDR,
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

int aml1216_writes(int add, uint8_t *buff, int len)
{
    int ret;
    uint8_t buf[MAX_BUF] = {};
    buf[0] = add & 0xff;
    buf[1] = (add >> 8) & 0x0f;
    memcpy(buf + 2, buff, len);
    struct i2c_msg msg[] = {
        {
            .addr  = AML1216_ADDR,
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

int aml1216_read(int add, uint8_t *val)
{
    int ret;
    uint8_t buf[2] = {};
    buf[0] = add & 0xff;
    buf[1] = (add >> 8) & 0x0f;
    struct i2c_msg msg[] = {
        {
            .addr  = AML1216_ADDR,
            .flags = 0,
            .len   = sizeof(buf),
            .buf   = buf,
        },
        {
            .addr  = AML1216_ADDR,
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

int aml1216_reads(int add, uint8_t *buff, int len)
{
    int ret;
    uint8_t buf[2] = {};
    buf[0] = add & 0xff;
    buf[1] = (add >> 8) & 0x0f;
    struct i2c_msg msg[] = {
        {
            .addr  = AML1216_ADDR,
            .flags = 0,
            .len   = sizeof(buf),
            .buf   = buf,
        },
        {
            .addr  = AML1216_ADDR,
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

int aml1216_set_bits(int add, uint8_t bits, uint8_t mask)
{
    uint8_t val;
    aml1216_read(add, &val);
    val &= ~(mask);                                         // clear bits;
    val |=  (bits & mask);                                  // set bits;
    return aml1216_write(add, val);
}

int aml1216_get_battery_voltage(void)
{
    uint8_t val[2];
    int result = 0;
    int tmp;
    int i;
    
    aml1216_reads(0x00AF, val, 2);        
    tmp = (((val[1] & 0x1f) << 8) + val[0]);
        
    result = (tmp * 4800) / 4096;
    
    return result;
}

int aml1216_get_dcin_voltage(void)
{
    uint8_t val[2] = {};
    int     result;

    aml1216_write(0x00AA, 0xC1);                            // select DCIN channel
    aml1216_write(0x009A, 0x28);
    udelay(100);
    aml1216_reads(0x00B1, val, 2);
    result = ((val[1] & 0x1f) << 8) + val[0];
    if (result & 0x1000) {                                  // complement code
        result = 0;                                         // avoid ADC offset 
    } else {
        result = (result * 12800) / 4096;
    }

    return result;
}

int aml1216_get_vbus_voltage(void)
{
    uint8_t val[2] = {};
    int     result;

    aml1216_write(0x00AA, 0xC2);                            // select VBUS channel
    aml1216_write(0x009A, 0x28);
    udelay(100);
    aml1216_reads(0x00B1, val, 2);
    result = ((val[1] & 0x1f) << 8) + val[0];
    if (result & 0x1000) {                                  // complement code
        result = 0;                                         // avoid ADC offset 
    } else {
        result = result * 6400 / 4096;
    }

    return result;
}

int aml1216_get_vsys_voltage(void)
{
    uint8_t val[2] = {};
    int     result;

    aml1216_write(0x00AA, 0xC3);                            // select VBUS channel
    aml1216_write(0x009A, 0x28);
    udelay(100);
    aml1216_reads(0x00B1, val, 2);
    result = ((val[1] & 0x1f) << 8) + val[0];
    if (result & 0x1000) {                                  // complement code
        result = 0;                                         // avoid ADC offset 
    } else {
        result = result * 6400 / 4096;
    }

    return result;
}

int aml1216_get_charge_status(int print)
{
    uint8_t val;

    int vsys_voltage = aml1216_get_vsys_voltage();
    if (print) {
        if (aml1216_get_otp_version() == 0) {
            aml1216_set_charge_enable(pmu_init_chg_enabled);    
        }
    }
    /*
     * work around for charge status register can't update problem
     */
    aml1216_read(0x0172, &val);
    if (print) {
        printf("--charge status:0x%02x", val);     
    }
    /*
     * limit duty cycle of DC3 according CHG_GAT_BAT_LV bit
     */
    if (vsys_voltage >= 4350)
    {
        aml1216_set_bits(0x0035, 0x00, 0x07);
        aml1216_set_bits(0x003e, 0x00, 0x07);
        aml1216_set_bits(0x0047, 0x00, 0x07);
        aml1216_set_bits(0x004f, 0x08, 0x08);
    }
    else
    {
        aml1216_set_bits(0x004f, 0x00, 0x08);
        aml1216_set_bits(0x0035, 0x04, 0x07);
        aml1216_set_bits(0x003e, 0x04, 0x07);
        aml1216_set_bits(0x0047, 0x04, 0x07);
    }   
    //aml1216_set_bits(0x004f, (val & 0x01) << 3, 0x08);
    if (val & 0x18) {
        if (charger_sign_bit) {
            /*
             * DCIN & VBUS is ok, charge sign bit si negative, battery is charging now
             */
            return 1;                                       // charging
        } else {
            return 3;                                       // stand by
        }
    } else {
        return 2;                                           // discharging 
    }
}

static int aml1216_get_coulomber(void)
{
    uint8_t buf[8]= {};
    int ret;
    int charge_result;
    int discharge_result;
    
    ret = aml1216_reads(0x0152, buf, 4);
    if (ret) {
        DBG("%s, failed: %d\n", __func__, __LINE__);
        return ret;
    }

    /*
     * Convert to mAh:
     * 8ms per SAR ADC result accumulator, 125 add per second
     * LSB is 5333 / 4096, an hour is 3600 second
     * register value is 32MSB of 48bit register value.
     * coulomb = (65536 * [register vaule] * 5333 / 4096) / (3600 * 125)
     *         = 0.1896178 * [register vaule]
     *         = (97.084302 / 512) * [register vaule]
     * if [register vaule] > 2147483630(mAh) = [2^31 / 97]
     * this simple calculate method ill cause overflow bug due to 32bit 
     * register range, but fortunately, No battery has capacity large than
     * this value
     */
    charge_result  = (buf[0] <<  0) |
                     (buf[1] <<  8) |
                     (buf[2] << 16) |
                     (buf[3] << 24);
    charge_result *= -1;                                                // charge current is negative
    charge_result  = ((charge_result * 97) / 512);                      // convert to mAh

    ret = aml1216_reads(0x0158, buf, 4);
    if (ret) {
        DBG("%s, failed: %d\n", __func__, __LINE__);
        return ret;
    }

    discharge_result  = (buf[0] <<  0) |
                        (buf[1] <<  8) |
                        (buf[2] << 16) |
                        (buf[3] << 24);
    discharge_result = (discharge_result * 97) / 512;                   // convert to mAh
    return charge_result - discharge_result;
}

int aml1216_get_battery_current(void)
{
    uint8_t  buf[2] = {};
    uint32_t tmp, i;
    int      result = 0;

    aml1216_reads(0x00AB, buf, 2);
    tmp = ((buf[1] & 0x01f) << 8) + buf[0];
    charger_sign_bit = tmp & 0x1000;
    if (tmp & 0x1000) {                                              // complement code
        tmp = (tmp ^ 0x1fff) + 1;
    }
    result = (tmp * 5333) / 4096 * (charger_sign_bit ? 1 : -1);
    return result;
    
}

int aml1216_set_gpio(int pin, int val)
{
    int ret;
    uint32_t data;

    if (pin <= 0 || pin > 3 || val > 1 || val < 0) {
        printf("ERROR, invalid input value, pin = %d, val= %d\n", pin, val);
        return -1;
    }
#if 0
    if (val < 2) {
        data = ((val ? 1 : 0) << (pin));
    } else {
        printf("%s, not support value for 1216:%d\n", __func__, val);
        return -1;
    }
    printf("%s, GPIO:%d, val:%d\n", __func__, pin, val);
    return aml1216_set_bits(0x0013, data, (1 << pin));
#else
    data = (1 << (pin + 11));
    printf("%s, GPIO:%d, val:%d\n", __func__, pin, val);
    if (val) {
        aml1216_write16(0x0084, data);
    } else {
        aml1216_write16(0x0082, data);
    }
    return 0;
#endif
}

int aml1216_get_gpio(int pin, int *val)
{
    int ret;
    uint8_t data;

    if (pin <= 0 || pin > 4 || !val) {
        printf("ERROR, invalid input value, pin = %d, val= %d\n", pin, val);
        return -1;
    }
    ret = aml1216_read(0x00C4, &data);
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

int aml1216_get_otp_version()
{
    uint8_t val = 0; 
    int  otp_version = 0;

    aml1216_read(0x007e, &val);
    otp_version = (val & 0x60) >> 5;

    printf("OTP version:%d\n", otp_version);
    return otp_version;
}

static int aml1216_cal_ocv(void)
{
    int para_flag;
    int vbat;
    int ibat;
    int ocv;
    int charge_status;

    if (!battery_rdc) {
        para_flag = get_battery_para_flag();
        if (para_flag == PARA_UNPARSED || para_flag == PARA_PARSE_SUCCESS) {
            if (para_flag == PARA_UNPARSED) {
                if (parse_battery_parameters() > 0) {
                    set_battery_para_flag(PARA_PARSE_SUCCESS);
                    para_flag = PARA_PARSE_SUCCESS;
                } else {
                    set_battery_para_flag(PARA_PARSE_FAILED);
                }
            }
            if (para_flag == PARA_PARSE_SUCCESS) {
                battery_rdc = board_battery_para.pmu_battery_rdc;
                printf("%s, use dts rdc:%d\n", __func__, battery_rdc);
            }
        } else {
            extern int config_battery_rdc;
            battery_rdc = config_battery_rdc;
            printf("%s, use config rdc:%d\n", __func__, battery_rdc);
        }
    }
    vbat = aml1216_get_battery_voltage();
    ibat = aml1216_get_battery_current();
    charge_status = aml1216_get_charge_status(0);
    if (charge_status == 1) {
        ocv = vbat - (ibat * battery_rdc) / 1000;
    } else if (charge_status == 2) {
        ocv = vbat - (ibat * battery_rdc) / 1000;    
    } else {
        ocv = vbat;    
    }   
    return ocv;
}

#ifdef CONFIG_USB_DWC_OTG_HCD
static int curr_usb_mode = 0;
int aml1216_usb_bc_process(int mode)
{
    curr_usb_mode = mode; 
    if ((aml1216_get_otp_version() == 0) && (mode == BC_MODE_SDP)) {
        aml1216_set_charge_enable(0);
    }
    return 0;
}
#endif

int aml1216_set_charge_enable(int enable)
{
    uint8_t val = 0; 
    uint8_t val_t = 0;
    int otp_version = 0;
    int charge_status = 0;
    int ocv = 0;
    int vsys, vbat;

    if (enable) {
        otp_version = aml1216_get_otp_version();
        if (otp_version == 0) {   
            aml1216_set_full_charge_voltage(4050000);
        #ifdef CONFIG_USB_DWC_OTG_HCD
            if (curr_usb_mode == BC_MODE_SDP) {
                printf("pc connected, disable charger\n");
                return aml1216_set_bits(0x0017, 0x00, 0x01);
            } 
        #endif
            vsys = aml1216_get_vsys_voltage();
            vbat = aml1216_get_battery_voltage();
            if ((vbat > 3950) || ((vsys > vbat) && (vsys - vbat < 500))) {   
                printf("%s, vbat:%d, vsys:%d do not open charger.\n", __func__, vbat, vsys);
                return aml1216_set_bits(0x0017, 0x00, 0x01);
            }
        } else if(otp_version >= 1) {
            aml1216_set_full_charge_voltage(pmu_init_chgvol);
        }
    }
    return aml1216_set_bits(0x0017, ((enable & 0x01)), 0x01);
}

void aml1216_power_off()
{
    printf("%s, send power off command\n", __func__);

    uint8_t buf = (1 << 5);                                     // software goto OFF state

    aml1216_write(0x0019, 0x10);                            
    aml1216_write16(0x0084, 0x0001);                            // close boost before cut vccx2
    udelay(10 * 1000);
    aml1216_set_gpio(1, 1);
    aml1216_set_gpio(2, 1);
    aml1216_set_gpio(3, 1);
    DBG("software goto OFF state\n");
    mdelay(10);
    aml1216_write(AML1216_GEN_CNTL1, buf);    
    udelay(1000);
    while (1) {
        udelay(1000 * 1000);
        printf("%s, error\n", __func__);
    }
}

int aml1216_set_usb_current_limit(int limit)
{
    int val;

    if ((limit < 100 || limit > 1600) && (limit != -1)) {
       DBG("%s, wrong usb current limit:%d\n", __func__, limit); 
       return -1;
    }
    if (limit == -1) {                                       // -1 means not limit, so set limit to max
        limit = 1600;    
    }
    val = (limit - 100) / 100;
    val ^= 0x04;                                            // bit 2 is reverse bit 
    DBG("%s, set usb current limit to %d, val:%x\n", __func__, limit, val);
    return aml1216_set_bits(0x002D, val, 0x0f);
}

#ifdef CONFIG_UBOOT_BATTERY_PARAMETERS
static int avg_voltage = 0, avg_current = 0;
int aml1216_get_ocv(int charge_status, int rdc)
{
    int vbat;
    int ibat;
    int ocv;

    vbat = aml1216_get_battery_voltage();
    ibat = aml1216_get_battery_current();
    charge_status = aml1216_get_charge_status(0);
    if (charge_status == 1) {
        ocv = vbat - (ibat * rdc) / 1000;
    } else if (charge_status == 2) {
        ocv = vbat - (ibat * rdc) / 1000;    
    } else {
        ocv = vbat;    
    }   
    avg_voltage += vbat;
    avg_current += ibat;
    return ocv;
}
#endif

int aml1216_get_charging_percent()
{
    int rest_vol;
#ifdef CONFIG_UBOOT_BATTERY_PARAMETERS
    int i;
    int ocv = 0;
    int ocv_diff, percent_diff, ocv_diff2;
    int percent1, percent2;
    int charge_status = aml1216_get_charge_status(1);
    int para_flag;
    static int ocv_full  = 0;
    static int ocv_empty = 0;
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
        ocv += aml1216_get_ocv(charge_status, battery_rdc); 
        udelay(10000); 
    }
    ocv = ocv / 8;
    avg_voltage /= 8;
    avg_current /= 8;
    printf(", voltage:%4d, current:%4d, ocv is %4d, ", avg_voltage, avg_current, ocv);
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

int aml1216_set_charging_current(int current)
{
#ifdef CONFIG_UBOOT_BATTERY_PARAMETERS
    uint8_t cur_val;
    int idx_cur, idx_to;

    if (current > 2100 * 1000 || current < 0) {
        DBG("%s, wrong input of charge current:%d\n", __func__, current);
        return -1;
    }
    if (current > 100) {                        // input is uA
        current = current / 1000;
    } else {                                    // input is charge ratio
        current = (current * board_battery_para.pmu_battery_cap) / 100 + 100; 
    }
#if 0  
    if (current < 750) {                        // for charge current stable issue@4.7uH
        current = 750;    
    }
#endif

    aml1216_read(0x012b, &cur_val);
    idx_to = (current-300) / 150;
    if (!aml1216_battery_test) {                // do not print when test
        printf("%s to %dmA, idx_to:%x, idx_cur:%x\n", __func__, idx_to * 150 + 300, idx_to, cur_val);
    }
    idx_cur = cur_val & 0x0f;
    while (idx_cur != idx_to) {
        if (idx_cur < idx_to) {
            idx_cur++;    
        } else {
            idx_cur--;
        }
        cur_val &= ~0x0f;
        cur_val |= (idx_cur & 0x0f);
        aml1216_write(0x012b, cur_val);
        udelay(100);
    }
    return 0;
#else
    return 0;
#endif
    
}

int aml1216_set_full_charge_voltage(int voltage)
{
    uint8_t val;
    uint8_t tmp;
    
    if (voltage > 4400000 || voltage < 4050000) {
        DBG("%s,Wrong charge voltage:%d\n", __func__, voltage);
        return -1;
    }
    tmp = (((voltage - 4050000) / 50000) << 3) & 0x38;
    aml1216_read(AML1216_CHG_CTRL0, &val);
    val &= ~(0x38);
    val |= tmp;
    aml1216_write(AML1216_CHG_CTRL0, val);

    return 0; 
}


void aml1216_set_pfm(int dcdc, int en)
{
    unsigned char val;
    if (dcdc < 0 || dcdc > AML1216_DCDC3 || en > 1 || en < 0) {
        return ;    
    }
    switch(dcdc) {
    case AML1216_DCDC1:
        aml1216_read(0x0036, &val);
        if (en) {
            val |=  (1 << 5);                                   // pfm mode
        } else {
            val &= ~(1 << 5);                                   // pwm mode
        }
        aml1216_write(0x0036, val);
        break;

    case AML1216_DCDC2:
        aml1216_read(0x0044, &val);
        if (en) {
            val |=  (1 << 5);    
        } else {
            val &= ~(1 << 5);   
        }
        aml1216_write(0x0044, val);
        break;

    case AML1216_DCDC3:
        aml1216_read(0x004e, &val);
        if (en) {
            val |=  (1 << 7);    
        } else {
            val &= ~(1 << 7);   
        }
        aml1216_write(0x004e, val);
        break;

    case AML1216_BOOST:
        aml1216_read(0x0028, &val);
        if (en) {
            val |=  (1 << 0);    
        } else {
            val &= ~(1 << 0);   
        }
        aml1216_write(0x0028, val);
        break;

    default:
        break;
    }
    udelay(100);
}

int aml1216_charger_online(void)
{
    uint8_t val;

    aml1216_read(0x0172, &val);
    if (val & 0x18) {                           // DCIN & VBUS are OK
        return 1;    
    } else {
        return 0;    
    }
}

int find_idx(int start, int target, int step, int size)
{
    int i = 0; 
    do { 
        if (start >= target) {
            break;    
        }    
        start += step;
        i++; 
    } while (i < size);
    return i;
}

int aml1216_set_dcdc_voltage(int dcdc, uint32_t voltage)
{
    int addr;
    int addr1;
    int idx_to_12;
    int idx_to_3;
    int ret;
    int range = 64;
    int step  = 20000;
    int tmp1,tmp2;
    int tmp3,tmp4;

    if (dcdc > 3 || dcdc < 0) {
        return -1;    
    }

    addr = 0x34+(dcdc-1)*9;

    switch (dcdc) {
       case 1:
           addr1 = 0x3c;
           break;

       case 2:
           addr1 = 0x45;
           break;

       case 3:
           step == 50000; 
           range = 43; 
           addr1 = 0x4f;
           break;

       default:
           break;
            
    }
    
    idx_to_12 = find_idx(680 * 1000, voltage, step, range);            // step is 20mV
    idx_to_3 = find_idx(1450 * 1000, voltage, step, range);            // step is 50mV
     
    tmp1 = 0x07 + 1 - idx_to_12;
    tmp1 = tmp1 << 2;

    tmp2 = 0xe0 - (idx_to_12 - 1)%8;
    tmp2 = tmp2 << 5;

    tmp3 = 0x07+ 1 - idx_to_3;
    tmp3 = tmp3 << 2;

    tmp4 = 0x60 - (idx_to_3 - 1)%8;
    tmp4 = tmp4 << 5;

    if (idx_to_12 >= 0) {
        if (dcdc = 3)
        {
              aml1216_set_bits(addr, (uint8_t)tmp3, 0x1c); //set bit[4:2]
              aml1216_set_bits(addr, (uint8_t)tmp4, 0x60);//set bit[6:5]       
         }
        else
        {
              aml1216_set_bits(addr, (uint8_t)tmp1, 0x1c); //set bit[4:2]
              aml1216_set_bits(addr, (uint8_t)tmp2, 0xe0);//set bit[7:5] 
        }
        
        aml1216_set_bits(addr1, 0x40, 0x40);//set bit[6]     
        udelay(100);                          // wait a moment
        
        return ret;
    } else {
        return idx_to_12;
    }
}

int aml1216_set_dcin(int enable)
{
    uint8_t val = 0;

    if (!enable) {
        val |= 0x01;
    }
    printf("%s:%s\n", __func__, enable ? "enable" : "disable");

    return aml1216_set_bits(0x002a, val, 0x01);
}

int aml1216_read16(uint32_t add, uint16_t *val)
{
    int ret;
    uint8_t buf[2] = {};
    buf[0] = add & 0xff;
    buf[1] = (add >> 8) & 0x0f;
    struct i2c_msg msg[] = {
        {
            .addr  = AML1216_ADDR,
            .flags = 0,
            .len   = sizeof(buf),
            .buf   = buf,
        },
        {
            .addr  = AML1216_ADDR,
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

void aml1216_set_long_press(int ms)
{   
    uint16_t val;
    uint16_t tmp;
    
    aml1216_read16(0x0090, &val);
    tmp = ms/100 -1; 
    val |= tmp;                                        // set power key long press to 10s
    return aml1216_set_bits(0x0090, val, 0x7f);

}

void check_boot_up_source(void)
{

    int i = 0;
    uint8_t val1, val2;
    uint32_t val_total;
  
    char *boot_up_source[] = {
        "first_power",                        // bit 0
        "CHG_DCIN_OK",                   // bit 1
        "CHG_VBUS_OK",                   // bit 2
        "software go to ACTIVE",        // bit 3
        "power key short",                 // bit 4
        "unused",                             // bit 6
        "unused ",                            // bit 7
        "CHG_SC_ACTIVE",                            // bit 8
        "CHG_SS_FINISH",                            // bit 9
        "CHG_TRKL_ACTIVE",                        // bit 10
        "CHG_DCIN_OK",                             // bit 11
        "CHG_VBUS_OK",                             // bit 12
        "CHG_CHGING",                              // bit 13
        "CHG_CHGEND",                               // bit 14
        "CHG_BAT_LOW",                            // bit 15        
        "unused",                                      // bit 16
        
    };

        
    aml1216_read(0x8A, &val1);
    aml1216_read(0xE0, &val2);
    
    val_total = val1 | (val2  << 8 ) ;
    
    printf("Cause of the power up:\n");

    while (val_total) {
        if (val_total & 0x01) {
            printf("-- %s\n", boot_up_source[i]);    
        }
        i++;
        val_total >>= 1;
    }
    return 0;
    
}

int aml1216_check_fault(void)
{
    uint8_t val0, val1, val2;
    uint32_t val_total;
    int i = 0;
    char *fault_reason[] = {
        "LDO2 FAULT",                   // bit 0
        "LDO1_OV",                      // bit 1
        "LDO1_UV",                      // bit 2
        "LDO1_OC",                      // bit 3
        "PREUVLO caused the system to move to the OFF state",          // bit 4
        "UVLO caused the system to move to the OFF state",               // bit 5
        "watchdog timer",                 // bit 6
        "Power Key LONG",               // bit 7
        "DC1 fault",                // bit 8
        "DC2 fault",                // bit 9
        "DC3 fault",                // bit 10
        "Charger fault",           // bit 11
        "LDO6 Fault",               // bit 12
        "LDO5 Fault",               // bit 13
        "LDO4 Fault",               // bit 14
        "LDO3 Fault",               // bit 15
        "CHG_DCIN_HOV_raw Fault",     // bit 16
        "LDO1 Fault",                          // bit 17
        "LDO8 Fault",                          // bit 18
        "LDO7 Fault",                         // bit 19
        "Boost fault",                         // bit 20
        "unused",                             // bit 21                 
        
    };

    printf("PMU fault status:\n");
    aml1216_read(0x87, &val0);
    aml1216_read(0x88, &val1);
    aml1216_read(0x89, &val2);

    val_total = val0 | (val1  << 8 ) | (val2  << 16 );
    
    while (val_total) {
        if (val_total & 0x01) {
            printf("-- %s\n", fault_reason[i]);    
        }
        i++;
        val_total >>= 1;
    }
    return 0;
    
}

static void dump_pmu_register(int dump_level)
{
    uint8_t val[16];
    int     i;

    printf("[aml1216] DUMP ALL REGISTERS\n");
    for (i = 0; i < 24; i++) {
        aml1216_reads(i * 16, val, 16);
        printf("0x%03x - %03x: ", i * 16, i * 16 + 15);
        printf("%02x %02x %02x %02x ",   val[0],  val[1],  val[2],  val[3]);
        printf("%02x %02x %02x %02x   ", val[4],  val[5],  val[6],  val[7]);
        printf("%02x %02x %02x %02x ",   val[8],  val[9],  val[10], val[11]);
        printf("%02x %02x %02x %02x\n",  val[12], val[13], val[14], val[15]);
    }
}

int aml1216_set_charge_end_rate(int rate)
{
    int val;
    switch (rate) {
    case 10: val = 0x00; break;
    case 20: val = 0x10; break;
    default:
         printf("%s, wrong charge end rate:%d\n", __func__, rate);    
         return -1;
    }
    return aml1216_set_bits(0x0129, val, 0x10);
}

int aml1216_set_trickle_time(int min)
{
    int val;
    switch (min) {
    case 30: val = 0x04; break;
    case 50: val = 0x08; break;
    case 80: val = 0x0c; break;
    default:
         printf("%s, wrong trickle charge time:%d\n", __func__, min);    
         return -1;
    }
    return aml1216_set_bits(0x012a, val, 0x0c);
}

int aml1216_set_rapid_time(int min)
{
    int val;
    switch (min) {
    case 360: val = 0x04; break;
    case 540: val = 0x08; break;
    case 720: val = 0x0c; break;
    default:
         printf("%s, wrong trickle charge time:%d\n", __func__, min);    
         return -1;
    }
    return aml1216_set_bits(0x0129, val, 0x0c);
}

int aml1216_set_recharge_voltage(void)
{
    return aml1216_set_bits(0x012c, 0x04, 0x0c);
}

int aml1216_init(void)
{
    uint8_t val;
    printf("Call %s, %d\n", __func__, __LINE__);

    aml1216_get_charge_status(0);
    aml1216_check_fault();
    check_boot_up_source();

    aml1216_write(0x2f, 0x22);                      // David Li, increase vsys 120mv
    aml1216_set_bits(0x000f, 0xf0, 0xf0);           // GPIO2 power off last
    aml1216_set_bits(0x0009, 0x01, 0x0f);           // boost power off first

    aml1216_set_bits(0x0035, 0x04, 0x07);           // According David Wang, set DCDC OCP to 2A
    aml1216_set_bits(0x003e, 0x04, 0x07);           // According David Wang, set DCDC OCP to 2A

    aml1216_set_bits(0x0011, 0x03, 0x03);
    aml1216_write(0x009B, 0x0c);//enable auto_sample and accumulate IBAT measurement
    aml1216_write(0x009C, 0x10);
    aml1216_write(0x009D, 0x04);//close force charge and discharge sample mask
    aml1216_write(0x009E, 0x18);//enable VBAT measure result average 4 samples
    aml1216_write(0x009F, 0x60);//enable IBAT measure result average 4 samples
    aml1216_write(0x009A, 0x20);
    aml1216_write(0x00B8, 0x00);
    aml1216_write(0x00A9, 0x8f);

    aml1216_write(0x00A0, 0x00);//select auto-sampling timebase is 2ms
    aml1216_write(0x00A1, 0x15);//set the IBAT measure threshold and enable auto IBAT +VBAT_in_active sample
    aml1216_write(0x00C9, 0x06);// open DCIN_OK and USB_OK IRQ

    aml1216_write16(0x0082, 0x0100);            // open ldo6 
    /*
     * open charger
     */
  //aml1216_set_bits(0x002b, 0x80, 0x80);       // David Li, disable usb current limit
  //aml1216_set_bits(0x002e, 0x80, 0x80);       // David Li, disable dcin current limit
    aml1216_set_bits(0x002c, 0x20, 0x20);       // David Li
    aml1216_set_bits(0x001c, 0x00, 0x60);       // David Li, mask ov fault of charger
    aml1216_set_bits(0x012b, 0x20, 0xf0);       // David Li
    aml1216_set_bits(0x0128, 0x06, 0x06);
    aml1216_write(0x0129, 0x1c);
    aml1216_write(0x012a, 0x8f);                // David Li
    aml1216_write(0x012c, 0x20);

    aml1216_set_gpio(2, 0);                     // open VCCX2
    aml1216_set_gpio(3, 0);                     // close ldo 1.2v
    aml1216_set_bits(0x001A, 0x00, 0x06);
    aml1216_set_bits(0x0023, 0x00, 0x0e);

    aml1216_write(0x0019, 0x10);
    aml1216_set_bits(0x0020, 0x00, 0x02);       // according harry
    aml1216_write(0x0130, 0x45);                // according harry
    aml1216_read(0x00d6, &val);
    if (val & 0x01) {
        printf("find boost fault:%x\n", val);
        aml1216_write16(0x0084, 0x0001);            // close boost before open it, according Harry 
    }
    udelay(1000 * 500);
    printf("%s, open boost\n", __func__);
    aml1216_write16(0x0082, 0x0001);            // software boost up
    udelay(1000);
    aml1216_set_bits(0x1A, 0x06, 0x06);
    udelay(1000);
    aml1216_set_bits(0x12f, 0x30, 0x30);        // open hdmi 5v output following boost
    dump_pmu_register(DUMP_KEY);

    return 0;
}

int aml1216_init_para(struct battery_parameter *battery)
{
    if (battery) {
        battery_rdc = battery->pmu_battery_rdc;
        pmu_init_chgvol = battery->pmu_init_chgvol;
        pmu_init_chg_enabled = battery->pmu_init_chg_enabled;
        aml1216_set_charge_enable(0); 
      //aml1216_set_full_charge_voltage(battery->pmu_init_chgvol);
        aml1216_set_charge_end_rate    (battery->pmu_init_chgend_rate);
        aml1216_set_trickle_time       (battery->pmu_init_chg_pretime);
        aml1216_set_rapid_time         (battery->pmu_init_chg_csttime);
        aml1216_set_charging_current   (battery->pmu_init_chgcur);
        aml1216_set_long_press         (battery->pmu_pekoff_time);
        aml1216_set_recharge_voltage   ();
        aml1216_set_charge_enable      (battery->pmu_init_chg_enabled);
        return 0;
    } else {
        return -1;    
    }    
}

static struct aml_pmu_driver g_aml_pmu_driver = {
    .pmu_init                    = aml1216_init, 
    .pmu_get_battery_capacity    = aml1216_get_charging_percent,
    .pmu_get_extern_power_status = aml1216_charger_online,
    .pmu_set_gpio                = aml1216_set_gpio,
    .pmu_get_gpio                = aml1216_get_gpio,
    .pmu_reg_read                = aml1216_read,
    .pmu_reg_write               = aml1216_write,
    .pmu_reg_reads               = aml1216_reads,
    .pmu_reg_writes              = aml1216_writes,
    .pmu_set_bits                = aml1216_set_bits,
    .pmu_set_usb_current_limit   = aml1216_set_usb_current_limit,
    .pmu_set_charge_current      = aml1216_set_charging_current,
#ifdef CONFIG_USB_DWC_OTG_HCD
    .pmu_usb_bc_process          = aml1216_usb_bc_process,
#endif
    .pmu_power_off               = aml1216_power_off,
    .pmu_init_para               = aml1216_init_para,
#ifdef CONFIG_UBOOT_BATTERY_PARAMETER_TEST
    .pmu_do_battery_calibrate    = aml1216_battery_calibrate,
#endif
    .pmu_dump_register           = dump_pmu_register,
};

struct aml_pmu_driver* aml_pmu_get_driver(void)
{
    uint8_t val;

    if (aml1216_read(0x00, &val)) {
        printf("%s, pmu check fail\n", __func__, val);
        return NULL;
    }

    return &g_aml_pmu_driver;
}

static int do_pmu_reg16(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
    int rw = 0, i;
    int addr;
    unsigned short val;

    if (argc < 1 || argc > 4) {
        return cmd_usage(cmdtp);
    }
    if (!strcmp(argv[1], "r")) {
        rw = 0;    
    } else if (!strcmp(argv[1], "w")) {
        rw = 1;    
    } else {
        return cmd_usage(cmdtp);
    }
    addr = simple_strtoul(argv[2], NULL, 16); 
    if (rw == 1) {
        val = simple_strtoul(argv[3], NULL, 16); 
    }

    if (rw == 0) {
        if (aml1216_read16(addr, &val)) {
            printf("read addr 0x%03x failed\n", addr);
            return -1;
        }
        printf("REG[0x%03x] = 0x%04x\n", addr, val);
    } else if (rw == 1) {
        if (aml1216_write16(addr, val)) {
            printf("write addr 0x%03x failed\n", addr);
            return -1;
        }
        printf("REG[0x%03x] set to 0x%04x\n", addr, val);
    } else {
        printf("ERROR!!\n");    
    }
    return 0;
}

U_BOOT_CMD(
	pmu_reg16,	4,	0,	do_pmu_reg16,
	"pmu_reg16 read/write command for 16bit register of AML PMU",
	"/N\n"
	"pmu_reg16 [r/w] [addr] [value]\n"
    "example:\n"
	"pmu_reg16 r 0x00           ---- read register 0x00 of PMU\n"
	"pmu_reg16 w 0x00 0x0055    ---- write register 0x00 to 0x55\n"
	"\n"
);

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


static uint32_t aml1216_get_chg_status(void)
{
    uint8_t val;

    aml1216_read(0x0172, &val);
    return val;
}

static int32_t coulomb = 0;
static int32_t ocv     = 0;
static int32_t ibat    = 0;
static int32_t vbat    = 0;
static int32_t rdc     = 98;                           // different platform, change this value

int aml1216_calculate_rdc(void)
{
    char    buf[100];
    int     i;
    int32_t i_lo, i_hi;
    int32_t v_lo, v_hi;
    int32_t rdc_cal = 0;
    int32_t avg;
    static int32_t rdc_avg = 0;
    static int32_t rdc_cnt = 0;

    v_hi = aml1216_get_battery_voltage();
    if (v_hi > 4000) {                          // to avoid PMU don't charge when battery voltage is high
        return 0;    
    }
    aml1216_set_charging_current(300 * 1000);       // 300mA
    udelay(1000 * 1000);
    i_lo = 0;
    v_lo = 0;
    for (i = 0; i < 8; i++) {
        v_lo += aml1216_get_battery_voltage();
        i_lo += aml1216_get_battery_current();
        udelay(8000);
    }
    aml1216_set_charging_current(1200 * 1000);      // 1200mA
    udelay(1000 * 1000);
    i_hi = 0;
    v_hi = 0;
    for (i = 0; i < 8; i++) {
        v_hi += aml1216_get_battery_voltage();
        i_hi += aml1216_get_battery_current();
        udelay(8000);
    }
    i_lo /= 8;
    v_lo /= 8;
    i_hi /= 8;
    v_hi /= 8;
    if (i_hi - i_lo > 200) {                    // make sure i_hi > i_lo more than 100mA to avoid SAR ADC error
        rdc_cal = (v_hi - v_lo) * 1000 / (i_hi - i_lo);
    } else {
        rdc_cal = 0;    
    }
    if (rdc_cal > 0 && rdc_cal < 400) {
        rdc_avg += rdc_cal;
        rdc_cnt++;
    }
    if (rdc_cnt) {
        avg = rdc_avg / rdc_cnt;
        rdc = avg;
    }
    sprintf(buf, "i_lo:%4d, i_hi:%4d, u_lo:%4d, u_hi:%4d, rdc_avg:%4d, rdc:%4d\n", 
            i_lo, i_hi, v_lo, v_hi, avg, rdc_cal);
    terminal_print(0, 36, buf);

    if (rdc_cal <= 0 || rdc_cal >= 400) {
        return 0;
    }

    return rdc_cal;
}

int aml1216_rdc_init(void)
{
    int i = 0;
    int rdc_total = 0;
    int success_cnt = 0;
    int rdc_tmp;
    char buf[100];

    aml1216_battery_test = 1;
    aml1216_set_bits(0x009A, 0x80, 0x80);                               // clear cloumber counter
    for (i = 0; i < 8; i++) {
        rdc_tmp = aml1216_calculate_rdc();
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

int aml1216_update_calibrate(int charge)
{
    int32_t  voltage = 0, current = 0;
    uint8_t  status;
    int      rdc_c = 0;
    int      i;

    coulomb = aml1216_get_coulomber(); 
    for (i = 0; i < 8; i++) {
        voltage += aml1216_get_battery_voltage(); 
        current += aml1216_get_battery_current();
        udelay(8000);
    }
    current /= 8;
    voltage /= 8;
    status  = aml1216_get_charge_status(0);
    
    if (current < 0 )
    {
        current = current * (-1);
    }
    if (status == 1) {                        // charging
        ocv = voltage - (current * rdc) / 1000;
    } else {
        ocv = voltage + (current * rdc) / 1000;
    }
    if (charge && ocv < 4000 && ocv > 3100) {         // for test
        rdc_c = aml1216_calculate_rdc();    
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
    {3935, 0, 0, 0, 0},                     // pmu_bat_para13
    {3998, 0, 0, 0, 0},                     // pmu_bat_para14
    {4062, 0, 0, 0, 0},                     // pmu_bat_para15
    {4153, 0, 0, 0, 0}                      // pmu_bat_para16   
};

static int32_t  ocv_history = 0;
static uint32_t ocv_float   = 0;

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
            sprintf(buf, "%2d;  %4d;  %9lld;  %4d;  %4d;\n", 
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
            sprintf(buf, "%2d;  %4d;  %9lld;  %4d;  %4d;\n", 
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

int aml1216_battery_calibrate(void)
{
 #if 1 
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
    uint32_t s_r;
    int     vsys;

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
                         "     ocv_hist    coulomb_p   vbat    rdc   s_r  vsys\n");
    if (!aml1216_rdc_init()) {
        terminal_print(0, 36, "#### calculate RDC failed, stop test!!! ####\n");
        goto out;
    }
    aml1216_update_calibrate(1);
    prev_coulomb = coulomb;
    prev_ocv = ocv;
    prev_ibat = ibat;
    for (i = 0; i < 4; i++) {
        aml1216_update_calibrate(0);
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
        rdc_tmp = aml1216_update_calibrate(1);
        if (rdc_tmp) {
            rdc_total += rdc_tmp; 
            rdc_cnt++;
        }
        if (ocv > 3520 && !rdc_update_flag) {
            if (rdc_cnt) {
                rdc_average = rdc_total / rdc_cnt; 
                sprintf(buf, "RDC set to %d mohm, rdc_total:%d, cnt:%d\n", rdc_average, rdc_total, rdc_cnt);
                terminal_print(0, 35, buf);
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
        s_r = aml1216_get_chg_status();
        vsys = aml1216_get_vsys_voltage();
        size  = sprintf(buf, 
                        "%4d,   %12lld,   %4d,       %4d,  %4d,        %4d,",
                        coulomb, energy_c, ibat, prev_ibat, ocv, ocv_history);
        size += sprintf(buf + size,
                        "        %4d,  %4d,  %4d,  %02x,  %4d\n",
                        (int32_t)energy_p, vbat, rdc, s_r, vsys);
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
    ibat_cnt = 0;
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
        aml1216_update_calibrate(0); 
        energy_c += ABS((prev_coulomb - coulomb) * ((ocv + prev_ocv) / 2));
        energy_p = energy_c;
        do_div(energy_p, 3700);
        update_energy_discharge(update_ocv(ocv), energy_c, coulomb, energy_p);
        s_r = aml1216_get_chg_status();
        vsys = aml1216_get_vsys_voltage();
        size  = sprintf(buf, 
                        "%4d,   %12lld,   %4d,       %4d,  %4d,        %4d,",
                        coulomb, energy_c, ibat, prev_ibat, ocv, ocv_history);
        size += sprintf(buf + size,
                        "        %4d,  %4d,  %4d,  %02x,  %4d\n",
                        (int32_t)energy_p, vbat, rdc, s_r, vsys);
        buf[size] = '\0';
        terminal_print(0, 5, buf);
        prev_coulomb = coulomb;
        prev_ocv = ocv;
        prev_ibat = ibat;
        udelay(1000000);
        if (ocv < 3350) {
            ibat_cnt++;
            if (ibat_cnt > 10) {
                terminal_print(0, 35, "ocv is too low, we stop discharging test now!\n");
                break;
            }
        } else {
            ibat_cnt = 0;    
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
    aml1216_battery_test = 0;
    return 1;
  #endif
  return 0 ;
}
#endif /* CONFIG_UBOOT_BATTERY_PARAMETER_TEST */

