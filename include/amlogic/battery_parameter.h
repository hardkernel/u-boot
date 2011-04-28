#ifndef __BATTERY_PARAMETER_H__
#define __BATTERY_PARAMETER_H__

#define BATTERY_PARA_NAME               "Battery_Parameter.txt_offset"
#define BATTERY_PARA_SIZE               "Battery_Parameter.txt_size"
#define PARA_UNPARSED        0
#define PARA_PARSE_FAILED   -1
#define PARA_PARSE_SUCCESS   1

/*
 * add for customer battery parameters
 */
struct battery_curve {
    int ocv;
    int charge_percent;
    int discharge_percent;
};

struct battery_parameter {
    int     pmu_used;
    int     pmu_twi_id;
    int     pmu_irq_id;
    int     pmu_twi_addr;
    int     pmu_battery_rdc;
    int     pmu_battery_cap;
    int     pmu_battery_technology;
    char    pmu_battery_name[20];
    int     pmu_init_chgcur;
    int     pmu_suspend_chgcur;
    int     pmu_resume_chgcur;
    int     pmu_shutdown_chgcur;
    int     pmu_init_chgvol;
    int     pmu_init_chgend_rate;
    int     pmu_init_chg_enabled;
    int     pmu_init_adc_freq;
    int     pmu_init_adc_freqc;
    int     pmu_init_chg_pretime;
    int     pmu_init_chg_csttime;

    int     pmu_usbvol_limit;
    int     pmu_usbvol;
    int     pmu_usbcur_limit;
    int     pmu_usbcur;

    int     pmu_pwroff_vol;
    int     pmu_pwron_vol;

    int     pmu_pekoff_time;
    int     pmu_pekoff_en;
    int     pmu_peklong_time;
    int     pmu_pekon_time;
    int     pmu_pwrok_time;
    int     pmu_pwrnoe_time;
    int     pmu_intotp_en;

    int     pmu_ntc_enable;
    int     pmu_ntc_ts_current;
    int     pmu_ntc_lowtempvol;
    int     pmu_ntc_hightempvol;
    
    int     pmu_charge_efficiency;
    struct  battery_curve pmu_bat_curve[16];
};

extern struct battery_parameter board_battery_para;
extern struct battery_parameter *get_battery_para(void);

extern int  parse_battery_parameters(void);
extern int  get_battery_para_flag(void);
extern void set_battery_para_flag(int val);

#endif /* __BATTERY_PARAMETER_H__ */
