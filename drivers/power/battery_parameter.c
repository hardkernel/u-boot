#include <common.h>
#include <amlogic/battery_parameter.h>
#include <asm/setup.h>
#include <amlogic/aml_pmu_common.h>

#if defined(CONFIG_OF_LIBFDT) && defined(CONFIG_DT_PRELOAD)
#include <libfdt.h>
#endif

/*
 * These are both existed parameters for Amlogic PMU and AXP PMU, 
 * but have different ranges. So we need these macro for checking
 * if these parameters are valid.
 */
#ifdef CONFIG_AML_PMU
#define MAX_CHARGE_CURRENT      2000000                 // max charging current, in uA
#define MIN_CHARGE_CURRENT      0                       // min charging current, in uA
#define MAX_CHARGE_VOLTAGE      4400000                 // max charge target voltage, in uV
#define MIN_CHARGE_VOLTAGE      4050000                 // min charge target voltage, in uV
#define MAX_CHARGE_END_RATE     20                      // max charge end rate, (charge current / target current)
#define MIN_CHARGE_END_RATE     10                      // min charge end rate
#define MAX_ADC_FREQ            1000                    // SAR ADC auto frequent, see reg[A0]
#define MIN_ADC_FREQ            1
#define MAX_PRE_CHARGE_TIME     80                      // max pre-charge(small current) time, in minutes
#define MIN_PRE_CHARGE_TIME     30                      // min pre-charge time
#define MAX_FAST_CHARGE_TIME    720                     // max fast charge(const current) time, in minutes
#define MIN_FAST_CHARGE_TIME    360                     // min fast charge time
#define MAX_VBUS_VOLTAGE_LIMIT  4600                    // max VBUS voltage limit, in mV
#define MIN_VBUS_VOLTAGE_LIMIT  4300                    // min VBUS voltage limit
#define MAX_VBUS_CURRENT_LIMIT  900                     // max VBUS current limit, in mA
#define MIN_VBUS_CURRENT_LIMIT  100                     // min VBUS current limit
#endif

#ifdef CONFIG_AW_AXP20 
#define MAX_CHARGE_CURRENT      1800000                 // max charging current, in uA
#define MIN_CHARGE_CURRENT      0                       // min charging current, in uA
#define MAX_CHARGE_VOLTAGE      4360000                 // max charge target voltage, in uV
#define MIN_CHARGE_VOLTAGE      4100000                 // min charge target voltage, in uV
#define MAX_CHARGE_END_RATE     15                      // max charge end rate, (charge current / target current)
#define MIN_CHARGE_END_RATE     10                      // min charge end rate
#define MAX_ADC_FREQ            200                     // ADC frequent 
#define MIN_ADC_FREQ            25
#define MAX_PRE_CHARGE_TIME     70                      // max pre-charge(small current) time, in minutes
#define MIN_PRE_CHARGE_TIME     40                      // min pre-charge time
#define MAX_FAST_CHARGE_TIME    720                     // max fast charge(const current) time, in minutes
#define MIN_FAST_CHARGE_TIME    360                     // min fast charge time
#define MAX_VBUS_VOLTAGE_LIMIT  4700                    // max VBUS voltage limit, in mV
#define MIN_VBUS_VOLTAGE_LIMIT  4000                    // min VBUS voltage limit
#define MAX_VBUS_CURRENT_LIMIT  900                     // max VBUS current limit, in mA
#define MIN_VBUS_CURRENT_LIMIT  100                     // min VBUS current limit
#endif

#ifdef CONFIG_RN5T618   // TODO:fix these parameters to this PMU 
#define MAX_CHARGE_CURRENT      1800000                 // max charging current, in uA
#define MIN_CHARGE_CURRENT      0                       // min charging current, in uA
#define MAX_CHARGE_VOLTAGE      4350000                 // max charge target voltage, in uV
#define MIN_CHARGE_VOLTAGE      4050000                 // min charge target voltage, in uV
#define MAX_CHARGE_END_RATE     15                      // max charge end rate, (charge current / target current)
#define MIN_CHARGE_END_RATE     10                      // min charge end rate
#define MAX_ADC_FREQ            200                     // ADC frequent 
#define MIN_ADC_FREQ            25
#define MAX_PRE_CHARGE_TIME     80                      // max pre-charge(small current) time, in minutes
#define MIN_PRE_CHARGE_TIME     40                      // min pre-charge time
#define MAX_FAST_CHARGE_TIME    300                     // max fast charge(const current) time, in minutes
#define MIN_FAST_CHARGE_TIME    120                     // min fast charge time
#define MAX_VBUS_VOLTAGE_LIMIT  4400                    // max VBUS voltage limit, in mV
#define MIN_VBUS_VOLTAGE_LIMIT  4100                    // min VBUS voltage limit
#define MAX_VBUS_CURRENT_LIMIT  1500                    // max VBUS current limit, in mA
#define MIN_VBUS_CURRENT_LIMIT  100                     // min VBUS current limit
#endif

#if defined(CONFIG_AML1216) || defined(CONFIG_AML1218)
#define MAX_CHARGE_CURRENT      2000000                 // max charging current, in uA
#define MIN_CHARGE_CURRENT      0                       // min charging current, in uA
#define MAX_CHARGE_VOLTAGE      4400000                 // max charge target voltage, in uV
#define MIN_CHARGE_VOLTAGE      4050000                 // min charge target voltage, in uV
#define MAX_CHARGE_END_RATE     20                      // max charge end rate, (charge current / target current)
#define MIN_CHARGE_END_RATE     10                      // min charge end rate
#define MAX_ADC_FREQ            1000                    // SAR ADC auto frequent, see reg[A0]
#define MIN_ADC_FREQ            1
#define MAX_PRE_CHARGE_TIME     80                      // max pre-charge(small current) time, in minutes
#define MIN_PRE_CHARGE_TIME     30                      // min pre-charge time
#define MAX_FAST_CHARGE_TIME    720                     // max fast charge(const current) time, in minutes
#define MIN_FAST_CHARGE_TIME    360                     // min fast charge time
#define MAX_VBUS_VOLTAGE_LIMIT  4600                    // max VBUS voltage limit, in mV
#define MIN_VBUS_VOLTAGE_LIMIT  4300                    // min VBUS voltage limit
#define MAX_VBUS_CURRENT_LIMIT  900                     // max VBUS current limit, in mA
#define MIN_VBUS_CURRENT_LIMIT  100                     // min VBUS current limit
#endif
/*
 * key word for battery parameter parse
 */
char *str_battery_para[] = {
    "pmu_used",
    "pmu_twi_id",
    "pmu_irq_id",
    "pmu_twi_addr",
    "pmu_battery_rdc",
    "pmu_battery_cap",
    "pmu_battery_technology",
    "pmu_battery_name",
    "pmu_init_chgcur",
    "pmu_suspend_chgcur",
    "pmu_resume_chgcur",
    "pmu_shutdown_chgcur",
    "pmu_init_chgvol",
    "pmu_init_chgend_rate",
    "pmu_init_chg_enabled",
    "pmu_init_adc_freq",
    "pmu_init_adc_freqc",
    "pmu_init_chg_pretime",
    "pmu_init_chg_csttime",
    "pmu_usbvol_limit",
    "pmu_usbvol",
    "pmu_usbcur_limit",
    "pmu_usbcur",
    "pmu_pwroff_vol",
    "pmu_pwron_vol",
    "pmu_pekoff_time",
    "pmu_pekoff_en",
    "pmu_peklong_time",
    "pmu_pekon_time",
    "pmu_pwrok_time",
    "pmu_pwrnoe_time",
    "pmu_intotp_en",
    "pmu_ntc_enable",
    "pmu_ntc_ts_current",
    "pmu_ntc_lowtempvol",
    "pmu_ntc_hightempvol",
    "pmu_charge_efficiency",
    "pmu_bat_curve"
};

/*
 * must be same index with str_battery_para
 */
typedef enum {
    member_UNKNOWN = -1,                            // unknown key word
    member_pmu_used = 0,
    member_pmu_twi_id,
    member_pmu_irq_id,
    member_pmu_twi_addr,
    member_pmu_battery_rdc,
    member_pmu_battery_cap,
    member_pmu_battery_technology,
    member_pmu_battery_name,
    member_pmu_init_chgcur,
    member_pmu_suspend_chgcur,
    member_pmu_resume_chgcur,
    member_pmu_shutdown_chgcur,
    member_pmu_init_chgvol,
    member_pmu_init_chgend_rate,
    member_pmu_init_chg_enabled,
    member_pmu_init_adc_freq,
    member_pmu_init_adc_freqc,
    member_pmu_init_chg_pretime,
    member_pmu_init_chg_csttime,
    member_pmu_usbvol_limit,
    member_pmu_usbvol,
    member_pmu_usbcur_limit,
    member_pmu_usbcur,
    member_pmu_pwroff_vol,
    member_pmu_pwron_vol,
    member_pmu_pekoff_time,
    member_pmu_pekoff_en,
    member_pmu_peklong_time,
    member_pmu_pekon_time,
    member_pmu_pwrok_time,
    member_pmu_pwrnoe_time,
    member_pmu_intotp_en,
    member_pmu_ntc_enable,
    member_pmu_ntc_ts_current,
    member_pmu_ntc_lowtempvol,
    member_pmu_ntc_hightempvol,
    member_pmu_charge_efficiency,
    member_pmu_bat_curve,
} pmu_para_member;

struct battery_parameter board_battery_para = {};
int match_cnt = 0;

#define TYPE_INT	0
#define TYPE_HEX	1

static int ssscanf(char *str, int type, int *value)
{
    char *p;
    char c;
    int val = 0;
    p = str;

    c = *p;
    while (!((c >= '0' && c <= '9') || 
             (c >= 'a' && c <= 'f') ||
             (c >= 'A' && c <= 'F'))) {                     // skip other characters 
        p++;
        c = *p;
    }
    switch (type) {
    case TYPE_INT:
        c = *p;
        while (c >= '0' && c <= '9') {
            val *= 10;
            val += c - '0';   
            p++;
            c = *p;
        }
        break;

    case TYPE_HEX:
        if (*p == '0' && (*(p + 1) == 'x' || *(p + 1) == 'X')) {
            p += 2;                         // skip '0x' '0X'
        }
        c = *p;
        while ((c >= '0' && c <= '9') ||
               (c >= 'a' && c <= 'f') ||
               (c >= 'A' && c <= 'F')) {
            val = val * 16;
            if (c >= '0' && c <= '9') {
                val += c - '0';
            }
            if (c >= 'a' && c <= 'f') {
                val += (c - 'a' + 10);
            }
            if (c >= 'A' && c <= 'F') {
                val += (c - 'a' + 10);
            }
            p++;
            c = *p;
        }
        break;

    default:
        break;
    }

    *value = val;
    return p - str; 
}

int is_letter(char c)
{
    if ((c >= 'a' && c <='z') || (c >= 'A' && c <= 'Z')) {
        return 1;    
    } else {
        return 0;    
    }
}

pmu_para_member match_key_word(char *buf, char **value_offset)
{
    int i = 0;
    int len;
    char *p_find = NULL;
    for (i = 0; i < ARRAY_SIZE(str_battery_para); i++) {
        len = strlen(str_battery_para[i]);
        p_find = strstr(buf, str_battery_para[i]); 
        if (p_find && !is_letter(p_find[len])) {
            *value_offset = memchr(buf + len, '=', 200) + 1;
            return i;
        }
    }
    return member_UNKNOWN;
}

static int get_para_value(char *value, int *member, int range_lo, int range_hi, pmu_para_member member_str)
{
    ssscanf(value, TYPE_INT, member);
    if (*member < range_lo || *member > range_hi) {           // check value of member is valid
        printf("Invalid value of %s = %d\n", 
               str_battery_para[member_str],
               *member);
        return -1;
    }
    match_cnt++;
    return 0;     
}

static int get_para_array(char *str, struct battery_curve *curve, char **return_ptr, int size)
{
    int i = 0;
    
    char *p, *tmp;
    p = memchr(str, '{', size);
    if (!p) {
        printf("Bad formart of battery parameter\n");
        return -1;
    }
    size -= (int)(p - str);
    tmp = p;
    for (i = 0; i < 16; i++) {
        p = memchr(p + 1, '{', size);
        p += ssscanf(p + 1, TYPE_INT, &curve[i].ocv);
        p += ssscanf(p + 1, TYPE_INT, &curve[i].charge_percent);
        p += ssscanf(p + 1, TYPE_INT, &curve[i].discharge_percent);
        if (curve[i].ocv < 3100 || curve[i].ocv > 4200 ||
            curve[i].charge_percent < 0 || curve[i].charge_percent > 100 ||
            curve[i].discharge_percent < 0 || curve[i].discharge_percent > 100) {
            printf("Wrong parameter of battery curve, ocv:%d, charge_percent:%d, discharge_percent:%d\n",
                   curve[i].ocv, curve[i].charge_percent, curve[i].discharge_percent);
            return -1;
        }
        size -= (int)(p - tmp);
        tmp = p; 
    }
    *return_ptr = memchr(p, '}', size); 
    return 0;
}

static char *mem_get_line(char *in, char *buf, int size, int copy_size)
{
    char *p;
    int cnt;
    p = memchr(in, '\n', size);
    if (!p) {
        memcpy(buf, in, size > copy_size ? copy_size : size);
        return NULL;                                                    // next line is NULL
    } else {
        cnt = (int)(p - in);
        memcpy(buf, in, cnt > copy_size ? copy_size : cnt);
    }
    return p + 1;                                                       // address of next line
}

static int parse_battery_para(char *base, int size)
{
    int i; 
    char *offset = base;
    char *value;
    char *tmp1, *tmp2;
    char buf[200] = {};
    char *pre_offset = offset;
    int remain_size = size;
    pmu_para_member tmp_member;

    while (1) {
        memset(buf, 0, sizeof(buf));
        offset = mem_get_line(offset, buf, remain_size, sizeof(buf));
        tmp_member = match_key_word(buf, &value);
        switch (tmp_member) {
        case member_UNKNOWN:
            break;

        case member_pmu_used:
            if (get_para_value(value, &board_battery_para.pmu_used, 0, 1, member_pmu_used) < 0) {
                return -1;    
            }
            break;

        case member_pmu_twi_id:
            if (get_para_value(value, &board_battery_para.pmu_twi_id, 0, 2, member_pmu_twi_id) < 0) {
                return -1;    
            }
            break;

        case member_pmu_irq_id:
            if (get_para_value(value, &board_battery_para.pmu_irq_id, 0, 255, member_pmu_irq_id) < 0) {
                return -1;    
            }
            break;

        case member_pmu_twi_addr:
            ssscanf(value, TYPE_HEX, &board_battery_para.pmu_twi_addr); 
            if (board_battery_para.pmu_twi_addr < 0 || board_battery_para.pmu_twi_addr > 0xff) {
                printf("Invalid value of pmu_twi_addr, pmu_twi_addr=%d\n", board_battery_para.pmu_twi_addr);    
                return -1;
            }
            break;

        case member_pmu_battery_rdc:
            if (get_para_value(value, &board_battery_para.pmu_battery_rdc, 0, 500, member_pmu_battery_rdc) < 0) {
                return -1;    
            }
            break;

        case member_pmu_battery_cap:
            if (get_para_value(value, &board_battery_para.pmu_battery_cap, 0, 0x7fffffff, member_pmu_battery_cap) < 0) {
                return -1;    
            }
            break;

        case member_pmu_battery_technology:
            if (get_para_value(value, &board_battery_para.pmu_battery_technology, 0, 6, member_pmu_battery_technology) < 0) {
                return -1;    
            }
            break;
            
        case member_pmu_battery_name:               // copy string quoted by ""
            tmp1 = memchr(value, '"', 100);
            tmp2 = memchr(tmp1 + 1, '"', 100);
            if ((int)(tmp2 - tmp1) < 20) {
                memcpy(board_battery_para.pmu_battery_name, tmp1 + 1, (int)(tmp2 - tmp1) - 1);
            } else {
                memcpy(board_battery_para.pmu_battery_name, tmp1 + 1, 20);    
            }
            break;

        case member_pmu_init_chgcur:
            if (get_para_value(value, &board_battery_para.pmu_init_chgcur, 
                MIN_CHARGE_CURRENT, MAX_CHARGE_CURRENT, member_pmu_init_chgcur) < 0) {
                return -1;    
            }
            break;
            
        case member_pmu_suspend_chgcur:
            if (get_para_value(value, &board_battery_para.pmu_suspend_chgcur, 
                MIN_CHARGE_CURRENT, MAX_CHARGE_CURRENT, member_pmu_suspend_chgcur) < 0) {
                return -1;    
            }
            break;
            
        case member_pmu_resume_chgcur:
            if (get_para_value(value, &board_battery_para.pmu_resume_chgcur, 
                MIN_CHARGE_CURRENT, MAX_CHARGE_CURRENT, member_pmu_resume_chgcur) < 0) {
                return -1;    
            }
            break;
            
        case member_pmu_shutdown_chgcur:
            if (get_para_value(value, &board_battery_para.pmu_shutdown_chgcur, 
                MIN_CHARGE_CURRENT, MAX_CHARGE_CURRENT, member_pmu_shutdown_chgcur) < 0) {
                return -1;    
            }
            break;

        case member_pmu_init_chgvol:
            if (get_para_value(value, &board_battery_para.pmu_init_chgvol, 
                MIN_CHARGE_VOLTAGE, MAX_CHARGE_VOLTAGE, member_pmu_init_chgvol) < 0) {
                return -1;
            }
            break;

        case member_pmu_init_chgend_rate:
            if (get_para_value(value, &board_battery_para.pmu_init_chgend_rate, 
                MIN_CHARGE_END_RATE, MAX_CHARGE_END_RATE, member_pmu_init_chgend_rate) < 0) {
                return -1;
            }
            break;

        case member_pmu_init_chg_enabled:
            if (get_para_value(value, &board_battery_para.pmu_init_chg_enabled, 0, 1, member_pmu_init_chg_enabled) < 0) {
                return -1;
            }
            break;

        case member_pmu_init_adc_freq:
            if (get_para_value(value, &board_battery_para.pmu_init_adc_freq, 
                MIN_ADC_FREQ, MAX_ADC_FREQ, member_pmu_init_adc_freq) < 0) {
                return -1;
            }
            break;

        case member_pmu_init_adc_freqc:
            if (get_para_value(value, &board_battery_para.pmu_init_adc_freqc, 
                MIN_ADC_FREQ, MAX_ADC_FREQ, member_pmu_init_adc_freqc) < 0) {
                return -1;
            }
            break;

        case member_pmu_init_chg_pretime:
            if (get_para_value(value, &board_battery_para.pmu_init_chg_pretime, 
                MIN_PRE_CHARGE_TIME, MAX_PRE_CHARGE_TIME, member_pmu_init_chg_pretime) < 0) {
                return -1;
            }
            break;
            
        case member_pmu_init_chg_csttime:
            if (get_para_value(value, &board_battery_para.pmu_init_chg_csttime, 
                MIN_FAST_CHARGE_TIME, MAX_FAST_CHARGE_TIME, member_pmu_init_chg_csttime) < 0) {
                return -1;
            }
            break;
            
        case member_pmu_usbvol_limit:
            if (get_para_value(value, &board_battery_para.pmu_usbvol_limit, 0, 1, member_pmu_usbvol_limit) < 0) {
                return -1;
            }
            break;
            
        case member_pmu_usbvol:
            if (get_para_value(value, &board_battery_para.pmu_usbvol, 
                MIN_VBUS_VOLTAGE_LIMIT, MAX_VBUS_VOLTAGE_LIMIT, member_pmu_usbvol) < 0) {
                return -1;
            }
            break;

        case member_pmu_usbcur_limit:
            if (get_para_value(value, &board_battery_para.pmu_usbcur_limit, 0, 1, member_pmu_usbcur_limit) < 0) {
                return -1;
            }
            break;

        case member_pmu_usbcur:
            if (get_para_value(value, &board_battery_para.pmu_usbcur, 
                MIN_VBUS_CURRENT_LIMIT, MAX_VBUS_CURRENT_LIMIT, member_pmu_usbcur) < 0) {
                return -1;
            }
            break;

        case member_pmu_pwroff_vol:
            if (get_para_value(value, &board_battery_para.pmu_pwroff_vol, 2600, 3300, member_pmu_pwroff_vol) < 0) {
                return -1;
            }
            break;

        case member_pmu_pwron_vol:
            if (get_para_value(value, &board_battery_para.pmu_pwron_vol, 2600, 3300, member_pmu_pwron_vol) < 0) {
                return -1;
            }
            break;

        case member_pmu_pekoff_time:
            if (get_para_value(value, &board_battery_para.pmu_pekoff_time, 4000, 10000, member_pmu_pekoff_time) < 0) {
                return -1;
            }
            break;

        case member_pmu_pekoff_en:
            if (get_para_value(value, &board_battery_para.pmu_pekoff_en, 0, 1, member_pmu_pekoff_en) < 0) {
                return -1;
            }
            break;

        case member_pmu_peklong_time:
            if (get_para_value(value, &board_battery_para.pmu_peklong_time, 1000, 2500, member_pmu_peklong_time) < 0) {
                return -1;
            }
            break;

        case member_pmu_pekon_time:
            if (get_para_value(value, &board_battery_para.pmu_pekon_time, 128, 3000, member_pmu_pekon_time) < 0) {
                return -1;
            }
            break;

        case member_pmu_pwrok_time:
            if (get_para_value(value, &board_battery_para.pmu_pwrok_time, 8, 64, member_pmu_pwrok_time) < 0) {
                return -1;
            }
            break;

        case member_pmu_pwrnoe_time:
            if (get_para_value(value, &board_battery_para.pmu_pwrnoe_time, 128, 3000, member_pmu_pwrnoe_time) < 0) {
                return -1;
            }
            break;

        case member_pmu_intotp_en:
            if (get_para_value(value, &board_battery_para.pmu_intotp_en, 0, 1, member_pmu_intotp_en) < 0) {
                return -1;
            }
            break;

        case member_pmu_ntc_enable:
            if (get_para_value(value, &board_battery_para.pmu_ntc_enable, 0, 1, member_pmu_ntc_enable) < 0) {
                return -1;
            }
            break;
            
        case member_pmu_ntc_ts_current:
            if (get_para_value(value, &board_battery_para.pmu_ntc_ts_current, 0, 3, member_pmu_ntc_ts_current) < 0) {
                return -1;
            }
            break;
            
        case member_pmu_ntc_lowtempvol:
            // need implement
            break;

        case member_pmu_ntc_hightempvol:
            // need implement
            break;

        case member_pmu_charge_efficiency:
            if (get_para_value(value, &board_battery_para.pmu_charge_efficiency, 0, 100, member_pmu_charge_efficiency) < 0) {
                return -1;
            }
            break;
            
        case member_pmu_bat_curve:
            if (get_para_array(pre_offset, board_battery_para.pmu_bat_curve, &offset, size) < 0) {
                return -1;    
            }
            break;

        default:
            break;
        }
        if (!offset) {
            break;     
        }
        remain_size -= (int)(offset - pre_offset);
        pre_offset = offset;
    }
    if (match_cnt < 10) {
        printf("No enough parameters found, parse fail, match_cnt:%d\n", match_cnt);
        return -1;
    }
    return 0;
}

int check_parsed_parameters(void)
{
    int i = 0;
    int ocv_full = 0, ocv_empty = 0;
    /*
     * only check some important battery parameters
     */
    if ((!board_battery_para.pmu_battery_rdc) ||
        (!board_battery_para.pmu_battery_cap) ||
        (!board_battery_para.pmu_charge_efficiency)) {
        printf("wrong value of important battery parameters\n");
        return -1;
    }
    for (i = 0; i < 16; i++) {
        if ((board_battery_para.pmu_bat_curve[i].ocv == 0) || 
            (board_battery_para.pmu_bat_curve[i].charge_percent < 0 || board_battery_para.pmu_bat_curve[i].charge_percent > 100) ||
            (board_battery_para.pmu_bat_curve[i].discharge_percent < 0 || board_battery_para.pmu_bat_curve[i].discharge_percent > 100)) {
            printf("wrong valus of battery curve\n");
            printf("%d, ocv:%3d, %3d, %3d\n", 
                   i, 
                   board_battery_para.pmu_bat_curve[i].ocv, 
                   board_battery_para.pmu_bat_curve[i].charge_percent,
                   board_battery_para.pmu_bat_curve[i].discharge_percent);
            return -1;
        }
        if (!ocv_empty && board_battery_para.pmu_bat_curve[i].discharge_percent > 0 && i) {
            ocv_empty = board_battery_para.pmu_bat_curve[i - 1].ocv;
        }
        if (!ocv_full && board_battery_para.pmu_bat_curve[i].discharge_percent == 100) {
            ocv_full = board_battery_para.pmu_bat_curve[i].ocv;
        }
    }
    if (!ocv_full || !ocv_empty) {
        printf("wrong valus of battery curve\n");
        return -1;
    }
    return 0;
}

#if defined(CONFIG_OF_LIBFDT) && defined(CONFIG_DT_PRELOAD)
#define DBG_PARSE   0

#define U32         0
#define STR         1
#define U32_ARRAY   2

int get_member_from_dtb(char *addr, void *value, char *name, int type, int offset, int err_level)
{
    void *data;
    int   i;
    int  *array;

    data = fdt_getprop(addr, offset, name, NULL);
    if (data == NULL) {
        printf("Got %s failed, ", name);
        if (err_level) {
            return -1;    
        } else {
            return 0;
        }
    }
    switch (type) {
    case U32:
        *((u32*)value) = be32_to_cpup((u32*)data);
        if (DBG_PARSE) {
            printf("Got %s, %d\n", name, *((u32*)value));
        }
        break;

    case STR:
        strncpy(value, data, 20);
        if (DBG_PARSE) {
            printf("Got %s, %s\n", name, (char *)data);
        }
        break;

    case U32_ARRAY:
        array = (int *)value;
        for (i = 0; i < 16 * 3; i++) {                                  // fixex size of array
            *array = be32_to_cpup((u32*)data);
            if (DBG_PARSE) {
                printf("Got %s, i: %d, val:%d\n", name, i, *array);
            }
            data = (unsigned char *)data + 4;
            array++;
        }
        break;
    default:
        return 0;
    }
    return 0;
}

#define PARSE_MEMBER(a, b, c, d, e, f)              \
    if (get_member_from_dtb(a, &b, c, d, e, f)) {   \
        return -1;                                  \
    }                                               \

#define PARSE_ARRAY(a, b, c, d, e, f)               \
    if (get_member_from_dtb(a, b, c, d, e, f)) {    \
        return -1;                                  \
    }                                               \

int get_battery_para_form_dtb(char *addr, struct battery_parameter *b)
{
    int ret;
    int offset;
    
    ret = fdt_check_header(addr);
    if (ret) {
        printf("check dts: %s, ", fdt_strerror(ret));
        return -1;
    }
    offset = fdt_path_offset(addr, "/battery_parameter");
    if (offset < 0) {
        printf("Not find /battery_parameter %s, ",fdt_strerror(offset));
        return -1;
    }
    PARSE_MEMBER(addr, b->pmu_twi_id,             "pmu_twi_id",             U32, offset, 0);
    PARSE_MEMBER(addr, b->pmu_irq_id,             "pmu_irq_id",             U32, offset, 0);
    PARSE_MEMBER(addr, b->pmu_twi_addr,           "pmu_twi_addr",           U32, offset, 0);
    PARSE_MEMBER(addr, b->pmu_battery_rdc,        "pmu_battery_rdc",        U32, offset, 1);
    PARSE_MEMBER(addr, b->pmu_battery_cap,        "pmu_battery_cap",        U32, offset, 1);
    PARSE_MEMBER(addr, b->pmu_battery_technology, "pmu_battery_technology", U32, offset, 0);
    PARSE_MEMBER(addr, b->pmu_battery_name,       "pmu_battery_name",       STR, offset, 0);
    PARSE_MEMBER(addr, b->pmu_init_chgvol,        "pmu_init_chgvol",        U32, offset, 1);
    PARSE_MEMBER(addr, b->pmu_init_chgend_rate,   "pmu_init_chgend_rate",   U32, offset, 1);
    PARSE_MEMBER(addr, b->pmu_init_chg_enabled,   "pmu_init_chg_enabled",   U32, offset, 1);
    PARSE_MEMBER(addr, b->pmu_init_adc_freq,      "pmu_init_adc_freq",      U32, offset, 1);
    PARSE_MEMBER(addr, b->pmu_init_adc_freqc,     "pmu_init_adc_freqc",     U32, offset, 1);
    PARSE_MEMBER(addr, b->pmu_init_chg_pretime,   "pmu_init_chg_pretime",   U32, offset, 1);
    PARSE_MEMBER(addr, b->pmu_init_chg_csttime,   "pmu_init_chg_csttime",   U32, offset, 1);
    PARSE_MEMBER(addr, b->pmu_init_chgcur,        "pmu_init_chgcur",        U32, offset, 1);
    PARSE_MEMBER(addr, b->pmu_suspend_chgcur,     "pmu_suspend_chgcur",     U32, offset, 1);
    PARSE_MEMBER(addr, b->pmu_resume_chgcur,      "pmu_resume_chgcur",      U32, offset, 1);
    PARSE_MEMBER(addr, b->pmu_shutdown_chgcur,    "pmu_shutdown_chgcur",    U32, offset, 1);
    PARSE_MEMBER(addr, b->pmu_usbcur_limit,       "pmu_usbcur_limit",       U32, offset, 1);
    PARSE_MEMBER(addr, b->pmu_usbcur,             "pmu_usbcur",             U32, offset, 1);
    PARSE_MEMBER(addr, b->pmu_usbvol_limit,       "pmu_usbvol_limit",       U32, offset, 1);
    PARSE_MEMBER(addr, b->pmu_usbvol,             "pmu_usbvol",             U32, offset, 1);
    PARSE_MEMBER(addr, b->pmu_pwroff_vol,         "pmu_pwroff_vol",         U32, offset, 0);
    PARSE_MEMBER(addr, b->pmu_pwron_vol,          "pmu_pwron_vol",          U32, offset, 0);
    PARSE_MEMBER(addr, b->pmu_pekoff_time,        "pmu_pekoff_time",        U32, offset, 0);
    PARSE_MEMBER(addr, b->pmu_pekoff_en,          "pmu_pekoff_en",          U32, offset, 0);
    PARSE_MEMBER(addr, b->pmu_peklong_time,       "pmu_peklong_time",       U32, offset, 0);
    PARSE_MEMBER(addr, b->pmu_pwrok_time,         "pmu_pwrok_time",         U32, offset, 0);
    PARSE_MEMBER(addr, b->pmu_pwrnoe_time,        "pmu_pwrnoe_time",        U32, offset, 0);
    PARSE_MEMBER(addr, b->pmu_intotp_en,          "pmu_intotp_en",          U32, offset, 0);
    PARSE_MEMBER(addr, b->pmu_pekon_time,         "pmu_pekon_time",         U32, offset, 0);
    PARSE_MEMBER(addr, b->pmu_charge_efficiency,  "pmu_charge_efficiency",  U32, offset, 1);
    PARSE_ARRAY (addr, b->pmu_bat_curve,          "pmu_bat_curve",          U32_ARRAY, offset, 1);

    return 0;
}
#endif

int parse_battery_parameters(void)
{
    char *base_pointer;
    char *env_offset;
    char *offset;
    int   size;
     
#if defined(CONFIG_OF_LIBFDT) && defined(CONFIG_DT_PRELOAD)
    char *dt_addr;
    struct aml_pmu_driver *driver;

    if (getenv("dtbaddr") == NULL) {
    #ifdef CONFIG_DTB_LOAD_ADDR
        dt_addr = (char *)CONFIG_DTB_LOAD_ADDR;
    #else
        dt_addr = (char *)0x83000000;
    #endif
    } else {
        dt_addr = simple_strtoul (getenv ("dtbaddr"), NULL, 16);    
        printf("Get dtb addr %x from env\n", dt_addr);
    }
    if (!get_battery_para_form_dtb(dt_addr, &board_battery_para)) {
        if (check_parsed_parameters()) {
            return -1;
        }
        printf("success parse battery parameter from dtb\n");
        driver = aml_pmu_get_driver();
        if (driver && driver->pmu_init_para) {
            printf("init pmu according battery parameter\n");
            driver->pmu_init_para(&board_battery_para);
        }
        return 1;  
    }
    printf("parse battery parameter from dtb failed\n");
    return -1;
#endif
    base_pointer = getenv(BATTERY_PARA_NAME);
    if (!base_pointer) {
        printf("Not find "BATTERY_PARA_NAME"\n");
        return  -1;
    }
    env_offset = getenv(BATTERY_PARA_SIZE);
    if (!env_offset) {
        printf("Not find "BATTERY_PARA_SIZE"\n");
        return  -1;
    }
    ssscanf(base_pointer, TYPE_HEX, &offset);
    ssscanf(env_offset, TYPE_HEX, &size);
    
    if (parse_battery_para(offset, size) < 0) {
        return -1;
    }

    if (check_parsed_parameters()) {
        return -1;
    }

    printf("Successed for parse battery parameter\n");

    return 1;
}

/*
 * para_flag is a flag to show if battery parameters has been successfully parsed
 */
static int para_flag = PARA_UNPARSED;

int get_battery_para_flag(void)
{
    return para_flag;    
}

void set_battery_para_flag(int val)
{
    if (val > PARA_PARSE_SUCCESS || val < PARA_PARSE_FAILED) {
        printf("%s, wrong input val:%d\n", val);
        return ;
    }
    para_flag = val;
}

struct battery_parameter *get_battery_para(void) 
{
    if (para_flag == PARA_PARSE_SUCCESS) {
        return &board_battery_para;    
    }

    if (parse_battery_parameters() > 0) {
        para_flag = PARA_PARSE_SUCCESS;
        return &board_battery_para;
    } else {
        para_flag = PARA_PARSE_FAILED;
        return NULL;    
    }
}

