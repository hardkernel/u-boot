/*
 * AMLOGIC lcd external driver.
 *
 * Communication protocol:
 * I2C 
 *
 */

#include <common.h>
#include <asm/arch/io.h>
#include <asm/arch/pinmux.h>
#include <asm/arch/gpio.h>
#include <asm/arch/lcd_reg.h>
#include <asm/arch/clock.h>
#include <asm/arch/timing.h>
#include <aml_i2c.h>
#include <amlogic/aml_lcd_extern.h>

//#define LCD_EXT_DEBUG_INFO

#define LCD_EXTERN_NAME			"lcd_i2c_tc101"
#define LCD_EXTERN_TYPE			LCD_EXTERN_I2C

#define LCD_EXTERN_I2C_ADDR		(0xfc >> 1) //7bit address
#define LCD_EXTERN_I2C_BUS		AML_I2C_MASTER_A

static unsigned char tc101_init_table[][3] = {
    //{0xff, 0xff, 20},//delay mark(20ms)
    {0xf8, 0x30, 0xb2},
    {0xf8, 0x33, 0xc2},
    {0xf8, 0x31, 0xf0},
    {0xf8, 0x40, 0x80},
    {0xf8, 0x81, 0xec},
    {0xff, 0xff, 0xff},//end mark
};

static unsigned aml_i2c_bus_tmp;
static struct aml_lcd_extern_driver_t lcd_ext_driver;

static int aml_lcd_i2c_write(unsigned i2caddr, unsigned char *buff, unsigned len)
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
#ifdef LCD_EXT_DEBUG_INFO
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

static int aml_lcd_i2c_read(unsigned i2caddr, unsigned char *buff, unsigned len)
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

static int tc101_reg_read(unsigned char reg, unsigned char *buf)
{
    int ret=0;

    return ret;
}

static int tc101_reg_write(unsigned char reg, unsigned char value)
{
    int ret=0;

    return ret;
}

static int tc101_init(void)
{
    unsigned char tData[4];
    int i=0, end_mark=0;
    int ret=0;

    while (end_mark == 0) {
        if ((tc101_init_table[i][0] == 0xff) && (tc101_init_table[i][1] == 0xff)) {    //special mark
            if (tc101_init_table[i][2] == 0xff) { //end mark
                end_mark = 1;
            }
            else { //delay mark
                mdelay(tc101_init_table[i][2]);
            }
        }
        else {
            tData[0]=tc101_init_table[i][0];
            tData[1]=tc101_init_table[i][1];
            tData[2]=tc101_init_table[i][2];
            ret = aml_lcd_i2c_write(LCD_EXTERN_I2C_ADDR, tData, 3);
        }
        i++;
    }
    printf("%s\n", __FUNCTION__);
    return ret;
}

static int tc101_remove(void)
{
    int ret=0;
    printf("%s\n", __FUNCTION__);
    return ret;
}

static struct aml_lcd_extern_pinmux_t aml_lcd_extern_pinmux_set[] = {
    {.reg = 5, .mux = ((1 << 6) | (1 << 7)),},
};

static struct aml_lcd_extern_pinmux_t aml_lcd_extern_pinmux_clr[] = {
    {.reg = 6, .mux = ((1 << 6) | (1 << 7)),},
    {.reg = 8, .mux = ((1 << 14) | (1 << 15)),},
};

static int aml_lcd_extern_port_init(void)
{
    int i;
    unsigned pinmux_reg, pinmux_data;
    int ret=0;

    for (i=0; i<ARRAY_SIZE(aml_lcd_extern_pinmux_set); i++) {
        pinmux_reg = PERIPHS_PIN_MUX_0+aml_lcd_extern_pinmux_set[i].reg;
        pinmux_data = aml_lcd_extern_pinmux_set[i].mux;
        WRITE_LCD_CBUS_REG(pinmux_reg, READ_LCD_CBUS_REG(pinmux_reg) | pinmux_data);
    }
    for (i=0; i<ARRAY_SIZE(aml_lcd_extern_pinmux_clr); i++) {
        pinmux_reg = PERIPHS_PIN_MUX_0+aml_lcd_extern_pinmux_clr[i].reg;
        pinmux_data = ~(aml_lcd_extern_pinmux_clr[i].mux);
        WRITE_LCD_CBUS_REG(pinmux_reg, READ_LCD_CBUS_REG(pinmux_reg) & pinmux_data);
    }

    return ret;
}

static int aml_lcd_extern_change_i2c_bus(unsigned aml_i2c_bus)
{
    int ret=0;
    extern struct aml_i2c_platform g_aml_i2c_plat;

    g_aml_i2c_plat.master_no = aml_i2c_bus;
    ret = aml_i2c_init();

    return ret;
}

static int aml_lcd_extern_init(void)
{
    int ret=0;
    extern struct aml_i2c_platform g_aml_i2c_plat;

    aml_i2c_bus_tmp = g_aml_i2c_plat.master_no;

    aml_lcd_extern_port_init();
    aml_lcd_extern_change_i2c_bus(LCD_EXTERN_I2C_BUS);
    ret = tc101_init();
    aml_lcd_extern_change_i2c_bus(aml_i2c_bus_tmp);

    return ret;
}

static int aml_lcd_extern_remove(void)
{
    int ret=0;
    extern struct aml_i2c_platform g_aml_i2c_plat;

    aml_i2c_bus_tmp = g_aml_i2c_plat.master_no;

    aml_lcd_extern_port_init();
    aml_lcd_extern_change_i2c_bus(LCD_EXTERN_I2C_BUS);
    ret = tc101_remove();
    aml_lcd_extern_change_i2c_bus(aml_i2c_bus_tmp);

    return ret;
}

static struct aml_lcd_extern_driver_t lcd_ext_driver = {
    .name = LCD_EXTERN_NAME,
    .type = LCD_EXTERN_TYPE,
    .reg_read = tc101_reg_read,
    .reg_write = tc101_reg_write,
    .power_on = aml_lcd_extern_init,
    .power_off = aml_lcd_extern_remove,
    .init_on_cmd_8 = NULL,
    .init_off_cmd_8 = NULL,
};

struct aml_lcd_extern_driver_t* aml_lcd_extern_get_driver(void)
{
    return &lcd_ext_driver;
}
