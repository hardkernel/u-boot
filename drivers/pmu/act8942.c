/* 
 * act8942 i2c interface
 * Copyright (C) 2011 Amlogic, Inc.
 *
 *
 * Author:  elvis yu<elvis.yu@amlogic.com>
 */  

#include <asm/arch/gpio.h>
#include <asm/arch/i2c.h>
#include <aml_i2c.h>
#include <act8942.h>

//#define __DBG__
#ifdef __DBG__
#define debug(fmt,args...) do { printf("[DEBUG]: FILE:%s:%d, FUNC:%s--- "fmt"\n",\
                                                     __FILE__,__LINE__,__func__,## args);} \
                                         while (0)
#else
#define debug(fmt,args...)
#endif

struct act8942_operations* act8942_opts = NULL;

unsigned char act8942_i2c_read(unsigned char reg)
{
    unsigned char val = 0;
    struct i2c_msg msgs[] = {
        {
            .addr = ACT8942_ADDR,
            .flags = 0,
            .len = 1,
            .buf = &reg,
        },
        {
            .addr = ACT8942_ADDR,
            .flags = I2C_M_RD,
            .len = 1,
            .buf = &val,
        }
    };

    if ( aml_i2c_xfer(msgs, 2)< 0) {
        printf("%s: i2c transfer failed\n", __FUNCTION__);
    }

    return val;
}

void act8942_i2c_write(unsigned char reg, unsigned char val)
{
    unsigned char buff[2];
    buff[0] = reg;
    buff[1] = val;
    struct i2c_msg msg[] = {
        {
        .addr = ACT8942_ADDR,
        .flags = 0,
        .len = 2,
        .buf = buff,
        }
    };

    if (aml_i2c_xfer(msg, 1) < 0) {
        printf("%s: i2c transfer failed\n", __FUNCTION__);
    }
}

/*
 *	ACINSTAT
 *	ACIN Status. Indicates the state of the ACIN input, typically
 *	in order to identify the type of input supply connected. Value
 *	is 1 when ACIN is above the 1.2V precision threshold, value
 *	is 0 when ACIN is below this threshold.
 */
static inline int is_ac_online(void)
{
	u8 val;	
	val = act8942_i2c_read(ACT8942_APCH_ADDR+0xa);
	
	debug("%s: get from pmu is %d.\n", __FUNCTION__, val);	
	return	(val & 0x2) ? 1 : 0;
}

static inline int is_usb_online(void)
{
	u8 val;
	val = act8942_i2c_read(ACT8942_APCH_ADDR+0xa);
	debug("%s: get from pmu is %d.\n", __FUNCTION__, val);
	//return	(val & 0x2) ? 0 : 1;
	return 0;
}


/*
 *	Charging Status Indication
 *
 *	CSTATE[1]	CSTATE[0]	STATE MACHINE STATUS
 *
 *		1			1		PRECONDITION State
 *		1			0		FAST-CHARGE / TOP-OFF State
 *		0			1		END-OF-CHARGE State
 *		0			0		SUSPEND/DISABLED / FAULT State
 *
 */
static inline int get_charge_status(void)
{
	u8 val;
	
	val = act8942_i2c_read(ACT8942_APCH_ADDR+0xa);

	debug("%s: get from pmu is %d.\n", __FUNCTION__, val);
	
	return ((val>>4) & 0x3) ? 0 : 1; // return 0 don't charge else chargeing
}

/*
 *	Fast charge when CHG_CON(GPIOAO_11) is High.
 *	Slow charge when CHG_CON(GPIOAO_11) is Low.
 */
static int set_charge_current(int level)
{
	clrbits_le32(P_AO_GPIO_O_EN_N, (1<<11));
	setbits_le32(P_AO_GPIO_O_EN_N,((level ? 1 : 0)<<27));  // 27
	//set_gpio_mode(GPIOAO_bank_bit0_11(11), GPIOAO_bit_bit0_11(11), GPIO_OUTPUT_MODE);
	//set_gpio_val(GPIOAO_bank_bit0_11(11), GPIOAO_bit_bit0_11(11), (level ? 1 : 0));
	return 0;
}

static int act8942_operations_init(struct act8942_operations* pdata)
{
	act8942_opts = pdata;
	if(act8942_opts->is_ac_online == NULL)
	{
		act8942_opts->is_ac_online = is_ac_online;
	}
	if(act8942_opts->is_usb_online == NULL)
	{
		act8942_opts->is_usb_online = is_usb_online;
	}
	if(act8942_opts->set_bat_off== NULL)
	{
		printf("act8942_opts->set_bat_off is NULL!\n");
		return -1;
	}
	if(act8942_opts->get_charge_status == NULL)
	{
		act8942_opts->get_charge_status = get_charge_status;
	}
	if(act8942_opts->set_charge_current == NULL)
	{
		act8942_opts->set_charge_current = set_charge_current;
	}
	if(act8942_opts->measure_voltage == NULL)
	{
		printf("act8942_opts->measure_voltage is NULL!\n");
		return -1;
	}
	if(act8942_opts->measure_current == NULL)
	{
		printf("act8942_opts->measure_current is NULL!\n");
		return -1;
	}
	if(act8942_opts->measure_capacity_charging == NULL)
	{
		printf("act8942_opts->measure_capacity_charging is NULL!\n");
		return -1;
	}
	if(act8942_opts->measure_capacity_battery== NULL)
	{
		printf("act8942_opts->measure_capacity_battery is NULL!\n");
		return -1;
	}
	if(act8942_opts->update_period <= 0)
	{
		act8942_opts->update_period = 5000;
	}
	return 0;
}

void act8942_suspend(void)
{
	set_charge_current(1);
	debug("fast charger on early_suspend\n\n");    
}

void act8942_resume(void)
{
    set_charge_current(0);
	debug("slow charger on resume\n\n");
}

void act8942_init(struct act8942_operations *act8942_opts)
{
	act8942_operations_init(act8942_opts);
    debug("act8942_init, address=0x%x", ACT8942_ADDR);
}

inline void	act8942_dump(void)
{
	printf("act8942: [0x%x] : 0x%x\n", ACT8942_SYS_ADDR, act8942_i2c_read(ACT8942_SYS_ADDR));
	printf("act8942: [0x%x] : 0x%x\n", ACT8942_SYS_ADDR+1, act8942_i2c_read(ACT8942_SYS_ADDR+1));
	printf("act8942: [0x%x] : 0x%x\n", ACT8942_REG1_ADDR, act8942_i2c_read(ACT8942_REG1_ADDR));
	printf("act8942: [0x%x] : 0x%x\n", ACT8942_REG1_ADDR+1, act8942_i2c_read(ACT8942_REG1_ADDR+1));
	printf("act8942: [0x%x] : 0x%x\n", ACT8942_REG1_ADDR+2, act8942_i2c_read(ACT8942_REG1_ADDR+2));
	printf("act8942: [0x%x] : 0x%x\n", ACT8942_REG2_ADDR, act8942_i2c_read(ACT8942_REG2_ADDR));
	printf("act8942: [0x%x] : 0x%x\n", ACT8942_REG2_ADDR+1, act8942_i2c_read(ACT8942_REG2_ADDR+1));
	printf("act8942: [0x%x] : 0x%x\n", ACT8942_REG2_ADDR+2, act8942_i2c_read(ACT8942_REG2_ADDR+2));
	printf("act8942: [0x%x] : 0x%x\n", ACT8942_REG3_ADDR, act8942_i2c_read(ACT8942_REG3_ADDR));
	printf("act8942: [0x%x] : 0x%x\n", ACT8942_REG3_ADDR+1, act8942_i2c_read(ACT8942_REG3_ADDR+1));
	printf("act8942: [0x%x] : 0x%x\n", ACT8942_REG3_ADDR+2, act8942_i2c_read(ACT8942_REG3_ADDR+2));
	printf("act8942: [0x%x] : 0x%x\n", ACT8942_REG4_ADDR, act8942_i2c_read(ACT8942_REG4_ADDR));
	printf("act8942: [0x%x] : 0x%x\n", ACT8942_REG4_ADDR+1, act8942_i2c_read(ACT8942_REG4_ADDR+1));
	printf("act8942: [0x%x] : 0x%x\n", ACT8942_REG5_ADDR, act8942_i2c_read(ACT8942_REG5_ADDR));
	printf("act8942: [0x%x] : 0x%x\n", ACT8942_REG5_ADDR+1, act8942_i2c_read(ACT8942_REG5_ADDR+1));
	printf("act8942: [0x%x] : 0x%x\n", ACT8942_REG6_ADDR, act8942_i2c_read(ACT8942_REG6_ADDR));
	printf("act8942: [0x%x] : 0x%x\n", ACT8942_REG6_ADDR+1, act8942_i2c_read(ACT8942_REG6_ADDR+1));
	printf("act8942: [0x%x] : 0x%x\n", ACT8942_REG7_ADDR, act8942_i2c_read(ACT8942_REG7_ADDR));
	printf("act8942: [0x%x] : 0x%x\n", ACT8942_REG7_ADDR+1, act8942_i2c_read(ACT8942_REG7_ADDR+1));
	printf("act8942: [0x%x] : 0x%x\n", ACT8942_APCH_ADDR, act8942_i2c_read(ACT8942_APCH_ADDR));
	printf("act8942: [0x%x] : 0x%x\n", ACT8942_APCH_ADDR+1, act8942_i2c_read(ACT8942_APCH_ADDR+1));
	printf("act8942: [0x%x] : 0x%x\n", ACT8942_APCH_ADDR+8, act8942_i2c_read(ACT8942_APCH_ADDR+8));
	printf("act8942: [0x%x] : 0x%x\n", ACT8942_APCH_ADDR+9, act8942_i2c_read(ACT8942_APCH_ADDR+9));
	printf("act8942: [0x%x] : 0x%x\n", ACT8942_APCH_ADDR+0xa, act8942_i2c_read(ACT8942_APCH_ADDR+0xa));
}


/**********  function  ******************/
/*
 *	ACINSTAT
 *	ACIN Status. Indicates the state of the ACIN input, typically
 *	in order to identify the type of input supply connected. Value
 *	is 1 when ACIN is above the 1.2V precision threshold, value
 *	is 0 when ACIN is below this threshold.
 */
int pmu_is_ac_online(void)
{
	if (act8942_opts->is_ac_online)
	{
		return act8942_opts->is_ac_online();
	}
	else
	{
		printf("is_ac_online is NULL!\n");	
		return 0;
	}
}

int pmu_is_usb_online(void)
{
	if (act8942_opts->is_usb_online)
	{
		return act8942_opts->is_usb_online();
	}
	else
	{
		printf("is_usb_onlineis NULL!\n");	
		return 0;
	}
}


/*
 *	Charging Status Indication
 *
 *	CSTATE[1]	CSTATE[0]	STATE MACHINE STATUS
 *
 *		1			1		PRECONDITION State
 *		1			0		FAST-CHARGE / TOP-OFF State
 *		0			1		END-OF-CHARGE State
 *		0			0		SUSPEND/DISABLED / FAULT State
 *
 */
int pmu_get_charge_status(void)
{
	if (act8942_opts->get_charge_status)
	{
		return act8942_opts->get_charge_status();
	}
	else
	{
		printf("get_charge_status is NULL!\n");
		return 0;
	}
}

/*
 *	Fast charge when CHG_CON(GPIOAO_11) is High.
 *	Slow charge when CHG_CON(GPIOAO_11) is Low.
 */
int pmu_set_charge_current(int level)
{
	if (act8942_opts->set_charge_current)
	{
		return act8942_opts->set_charge_current(level);
	}
	else
	{
		printf("set_charge_current is NULL!\n");
		return -1;
	}
}

int pmu_measure_voltage(void)
{
	if (act8942_opts->measure_voltage)
	{
		return act8942_opts->measure_voltage();
	}
	else
	{
		printf("measure_voltage is NULL!\n");
		return -1;
	}
}

/*
 *	Get Vhigh when BAT_SEL(GPIOA_22) is High.
 *	Get Vlow when BAT_SEL(GPIOA_22) is Low.
 *	I = Vdiff / 0.02R
 *	Vdiff = Vhigh - Vlow
 */
int pmu_measure_current(void)
{
	if (act8942_opts->measure_current)
	{
		return act8942_opts->measure_current();
	}
	else
	{
		printf("measure_current is NULL!\n");
		return -1;
	}
}

int pmu_measure_capacity_charging(void)
{
	if (act8942_opts->measure_capacity_charging)
	{
		return act8942_opts->measure_capacity_charging();
	}
	else
	{
		printf("measure_capacity_charging is NULL!\n");
		return -1;
	}
}

int pmu_measure_capacity_battery(void)
{
	if (act8942_opts->measure_capacity_battery)
	{
		return act8942_opts->measure_capacity_battery();
	}
	else
	{
		printf("measure_capacity_battery is NULL!\n");
		return -1;
	}
}

void pmu_set_bat_off(void)
{
	if (act8942_opts->set_bat_off)
	{
		act8942_opts->set_bat_off();
	}
	else
	{
		printf("set_bat_off is NULL!\n");
	}
}

void pmu_status_print(void)
{
	printf("---------------------------------------------------------\n");
	printf("pmu_is_ac_online                = %d\n", pmu_is_ac_online());
	printf("pmu_is_usb_online               = %d\n", pmu_is_usb_online());
	printf("pmu_get_charge_status           = %d\n", pmu_get_charge_status());
	printf("pmu_measure_voltage             = %duV\n", pmu_measure_voltage());
	printf("pmu_measure_current             = %duA\n", pmu_measure_current());
	printf("pmu_measure_capacity_charging   = %d\n", pmu_measure_capacity_charging());
	printf("---------------------------------------------------------\n");
}
/**********  function  ******************/

