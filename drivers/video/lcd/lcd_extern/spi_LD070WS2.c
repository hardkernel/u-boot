/*
 * AMLOGIC lcd external driver.
 *
 * Communication protocol:
 * SPI 
 *
 */

#include <common.h>
#include <asm/arch/io.h>
#include <asm/arch/pinmux.h>
#include <asm/arch/gpio.h>
#include <asm/arch/clock.h>
#include <asm/arch/timing.h>
#include <asm/arch-m8/aml_lcd_gpio.h>
#include <amlogic/aml_lcd_extern.h>

//#define LCD_EXT_DEBUG_INFO

#define LCD_EXTERN_NAME		"lcd_spi_LD070WS2"
#define LCD_EXTERN_TYPE		LCD_EXTERN_SPI

#define GPIO_SPI_CS			GPIOY_5
#define GPIO_SPI_CLK		GPIOZ_13
#define GPIO_SPI_DATA		GPIOZ_14

#define SPI_DELAY		30 //unit: us

static unsigned char spi_init_table[][2] = {
    {0x00,0x21},  //reset
    {0x00,0xa5},  //standby
    {0x01,0x30},  //enable FRC/Dither
    {0x02,0x40},  //enable normally black
    {0x0e,0x5f},  //enable test mode1
    {0x0f,0xa4},  //enable test mode2
    {0x0d,0x00},  //enable SDRRS, enlarge OE width
    {0x02,0x43},  //adjust charge sharing time
    {0x0a,0x28},  //trigger bias reduction
    {0x10,0x41},  //adopt 2 line/1 dot
    {0xff,50},    //delay 50ms
    {0x00,0xad},  //display on
    {0xff,0xff},  //ending flag
};

static unsigned char spi_off_table[][2] = {
    {0x00,0xa5},  //standby
    {0xff,0xff},
};

static void set_lcd_csb(unsigned v)
{
    aml_lcd_gpio_set(GPIO_SPI_CS, v);
    udelay(SPI_DELAY);
}

static void set_lcd_scl(unsigned v)
{
    aml_lcd_gpio_set(GPIO_SPI_CLK, v);
    udelay(SPI_DELAY);
}
    
static void set_lcd_sda(unsigned v)
{
    aml_lcd_gpio_set(GPIO_SPI_DATA, v);
    udelay(SPI_DELAY);
}

static void spi_gpio_init(void)
{
    set_lcd_csb(1);
    set_lcd_scl(1);
    set_lcd_sda(1);
}

static void spi_gpio_off(void)
{
    set_lcd_sda(0);
    set_lcd_scl(0);
    set_lcd_csb(0);
}

static void spi_write_8(unsigned char addr, unsigned char data)
{
    int i;
    unsigned int sdata;

    sdata = (unsigned int)(addr & 0x3f);
    sdata <<= 10;
    sdata |= (data & 0xff);
    sdata &= ~(1<<9); //write flag

    set_lcd_csb(1);
    set_lcd_scl(1);
    set_lcd_sda(1);

    set_lcd_csb(0);
    for (i = 0; i < 16; i++) {
        set_lcd_scl(0);
        if (sdata & 0x8000)
            set_lcd_sda(1);
        else
            set_lcd_sda(0);
        sdata <<= 1;
        set_lcd_scl(1);
    }

    set_lcd_csb(1);
    set_lcd_scl(1);
    set_lcd_sda(1);
    udelay(SPI_DELAY);
}

static void lcd_extern_spi_init(void)
{
    int ending_flag = 0;
    int i=0;

    spi_gpio_init();

    while(ending_flag == 0) {
        if (spi_init_table[i][0] == 0xff) {
            if (spi_init_table[i][1] == 0xff)
                ending_flag = 1;
            else
                mdelay(spi_init_table[i][1]);
        }
        else {
            spi_write_8(spi_init_table[i][0], spi_init_table[i][1]);
        }
        i++;
    }
   // printk("%s\n", __FUNCTION__);
}

static void lcd_extern_spi_off(void)
{
    int ending_flag = 0;
    int i=0;

    spi_gpio_init();

    while(ending_flag == 0) {
        if (spi_off_table[i][0] == 0xff) {
            if (spi_off_table[i][1] == 0xff)
                ending_flag = 1;
            else
                mdelay(spi_off_table[i][1]);
        }
        else {
            spi_write_8(spi_off_table[i][0], spi_off_table[i][1]);
        }
        i++;
    }
    //printk("%s\n", __FUNCTION__);
    mdelay(10);
    spi_gpio_off();
}

static struct aml_lcd_extern_driver_t lcd_ext_driver = {
    .name = LCD_EXTERN_NAME,
    .type = LCD_EXTERN_TYPE,
    .reg_read = NULL,
    .reg_write = NULL,
    .power_on = lcd_extern_spi_init,
    .power_off = lcd_extern_spi_off,
    .init_on_cmd_8 = NULL,
    .init_off_cmd_8 = NULL,
};

struct aml_lcd_extern_driver_t* aml_lcd_extern_get_driver(void)
{
    return &lcd_ext_driver;
}
