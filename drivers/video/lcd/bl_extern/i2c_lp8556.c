/*
 * AMLOGIC backlight external driver.
 *
 * Communication protocol:
 * I2C 
 *
 */

#include <common.h>
#include <asm/arch/io.h>
#include <asm/arch/pinmux.h>
#include <asm/arch/clock.h>
#include <asm/arch/timing.h>
#include <aml_i2c.h>
#include <amlogic/aml_bl_extern.h>

#ifdef CONFIG_AML_BL_EXTERN
//#define BL_EXT_DEBUG_INFO

#define BL_EXTERN_NAME			"bl_i2c_tc101"
#define BL_EXTERN_TYPE			BL_EXTERN_I2C

#define BL_EXTERN_I2C_ADDR		(0xfc >> 1) //7bit address
#define BL_EXTERN_I2C_BUS		AML_I2C_MASTER_A

static unsigned int bl_status = 0;
static unsigned int bl_level = 0;
static unsigned aml_i2c_bus_tmp;
static struct aml_bl_extern_driver_t bl_ext_driver;

static struct bl_extern_config_t bl_ext_config = {
    .name = BL_EXTERN_NAME,
    .type = BL_EXTERN_TYPE,
    .i2c_addr = BL_EXTERN_I2C_ADDR,
    .i2c_bus = BL_EXTERN_I2C_BUS,
    .gpio_used = 1,
    .gpio = GPIODV_28,
    .dim_min = 10,
    .dim_max = 255,
};

static struct aml_bl_extern_pinmux_t aml_bl_extern_pinmux_set[] = {
    {.reg = 5, .mux = ((1 << 6) | (1 << 7)),},
};

static struct aml_bl_extern_pinmux_t aml_bl_extern_pinmux_clr[] = {
    {.reg = 6, .mux = ((1 << 6) | (1 << 7)),},
    {.reg = 8, .mux = ((1 << 14) | (1 << 15)),},
};

static unsigned char i2c_init_table[][2] = {
    {0xa1, 0x76}, //hight bit(8~11)(0~0X66e set backlight)
    {0xa0, 0x66},  //low bit(0~7)  20mA
    {0x16, 0x1F}, // 5channel LED enable 0x1F
    {0xa9, 0xA0}, //VBOOST_MAX 25V
    {0x9e, 0x12},
    {0xa2, 0x23}, //23
    {0x01, 0x05}, //0x03 pwm+I2c set brightness,0x5 I2c set brightness
    {0xff, 0xff},//ending flag
};

static int aml_bl_i2c_write(unsigned i2caddr, unsigned char *buff, unsigned len)
{
    int res = 0, i;
    struct i2c_msg msg[] = {
        {
        .addr = i2caddr,
        .flags = 0,
        .len = len,
        .buf = buff,
        }
    };
#ifdef BL_EXT_DEBUG_INFO
    printf("%s:", __FUNCTION__);
    for (i=0; i<len; i++) {
        printf(" 0x%02x", buff[i]);
    }
    printf(" [addr 0x%02x]\n", i2caddr);
#endif
    //res = aml_i2c_xfer(msg, 1);
    res = aml_i2c_xfer_slow(msg, 1);
    if (res < 0) {
        printf("%s: i2c transfer failed [addr 0x%02x]\n", __FUNCTION__, i2caddr);
    }

    return res;
}

static int aml_bl_i2c_read(unsigned i2caddr, unsigned char *buff, unsigned len)
{
    int res = 0;
    struct i2c_msg msg[] = {
        {
            .addr  = i2caddr,
            .flags = 0,
            .len   = 1,
            .buf   = buff,
        },
        {
            .addr  = i2caddr,
            .flags = I2C_M_RD,
            .len   = len,
            .buf   = buff,
        }
    };
    //res = aml_i2c_xfer(msg, 2);
    res = aml_i2c_xfer_slow(msg, 2);
    if (res < 0) {
        printf("%s: i2c transfer failed [addr 0x%02x]\n", __FUNCTION__, i2caddr);
    }

    return res;
}

static int bl_extern_i2c_init(void)
{
    unsigned char tData[3];
    int i=0, end_mark=0;
    int ret=0;

    if (bl_ext_config.gpio_used > 0) {
        bl_extern_gpio_direction_output(bl_ext_config.gpio, 1);
    }

    while (end_mark == 0) {
        if (i2c_init_table[i][0] == 0xff) {    //special mark
            if (i2c_init_table[i][1] == 0xff) { //end mark
                end_mark = 1;
            }
            else { //delay mark
                mdelay(i2c_init_table[i][1]);
            }
        }
        else {
            tData[0]=i2c_init_table[i][0];
            tData[1]=i2c_init_table[i][1];
            ret = aml_bl_i2c_write(BL_EXTERN_I2C_ADDR, tData, 2);
        }
        i++;
    }
    bl_status = 1;

    printf("%s\n", __FUNCTION__);
    return ret;
}

static int bl_extern_i2c_off(void)
{
    bl_status = 0;
    if (bl_ext_config.gpio_used > 0) {
        bl_extern_gpio_direction_output(bl_ext_config.gpio, 0);
    }

    printf("%s\n", __FUNCTION__);
    return 0;
}

static int aml_bl_extern_port_init(void)
{
    int i;
    unsigned pinmux_reg, pinmux_data;
    int ret=0;

    for (i=0; i<ARRAY_SIZE(aml_bl_extern_pinmux_set); i++) {
        pinmux_reg = PERIPHS_PIN_MUX_0+aml_bl_extern_pinmux_set[i].reg;
        pinmux_data = aml_bl_extern_pinmux_set[i].mux;
        WRITE_CBUS_REG(pinmux_reg, READ_CBUS_REG(pinmux_reg) | pinmux_data);
    }
    for (i=0; i<ARRAY_SIZE(aml_bl_extern_pinmux_clr); i++) {
        pinmux_reg = PERIPHS_PIN_MUX_0+aml_bl_extern_pinmux_clr[i].reg;
        pinmux_data = ~(aml_bl_extern_pinmux_clr[i].mux);
        WRITE_CBUS_REG(pinmux_reg, READ_CBUS_REG(pinmux_reg) & pinmux_data);
    }

    return ret;
}

static int aml_bl_extern_change_i2c_bus(unsigned aml_i2c_bus)
{
    int ret=0;
    extern struct aml_i2c_platform g_aml_i2c_plat;

    g_aml_i2c_plat.master_no = aml_i2c_bus;
    ret = aml_i2c_init();

    return ret;
}

static int bl_extern_set_level(unsigned int level)
{
    unsigned char tData[3];
    int ret = 0;
    extern struct aml_i2c_platform g_aml_i2c_plat;

    bl_level = level;
    if (bl_status) {
        get_bl_level(&bl_ext_config);
        level = bl_ext_config.dim_min - ((level - bl_ext_config.level_min) * (bl_ext_config.dim_min - bl_ext_config.dim_max)) / (bl_ext_config.level_max - bl_ext_config.level_min);
        level &= 0xff;

        aml_i2c_bus_tmp = g_aml_i2c_plat.master_no;
        aml_bl_extern_port_init();
        aml_bl_extern_change_i2c_bus(BL_EXTERN_I2C_BUS);
        tData[0] = 0x0;
        tData[1] = level;
        ret = aml_bl_i2c_write(BL_EXTERN_I2C_ADDR, tData, 2);
        aml_bl_extern_change_i2c_bus(aml_i2c_bus_tmp);
    }

    return ret;
}

static int bl_extern_power_on(void)
{
    int ret=0;
    extern struct aml_i2c_platform g_aml_i2c_plat;

    aml_i2c_bus_tmp = g_aml_i2c_plat.master_no;

    aml_bl_extern_port_init();
    aml_bl_extern_change_i2c_bus(BL_EXTERN_I2C_BUS);
    ret = bl_extern_i2c_init();
    aml_bl_extern_change_i2c_bus(aml_i2c_bus_tmp);
    if (bl_level > 0) {
        bl_extern_set_level(bl_level);
    }

    return ret;
}

static int bl_extern_power_off(void)
{
    int ret=0;
    extern struct aml_i2c_platform g_aml_i2c_plat;

    aml_i2c_bus_tmp = g_aml_i2c_plat.master_no;

    aml_bl_extern_port_init();
    aml_bl_extern_change_i2c_bus(BL_EXTERN_I2C_BUS);
    ret = bl_extern_i2c_off();
    aml_bl_extern_change_i2c_bus(aml_i2c_bus_tmp);

    return ret;
}

static struct aml_bl_extern_driver_t bl_ext_driver = {
    .name = BL_EXTERN_NAME,
    .type = BL_EXTERN_TYPE,
    .power_on = bl_extern_power_on,
    .power_off = bl_extern_power_off,
    .set_level = bl_extern_set_level,
};

struct aml_bl_extern_driver_t* aml_bl_extern_get_driver(void)
{
    return &bl_ext_driver;
}
#endif
