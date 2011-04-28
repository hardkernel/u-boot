/*
 * AMLOGIC backlight external driver.
 *
 */

#include <common.h>
#include <asm/arch/io.h>
#include <asm/arch/lcdoutc.h>
#include <amlogic/aml_bl_extern.h>

#ifdef CONFIG_AML_BL_EXTERN
#ifdef CONFIG_LCD_IF_MIPI_VALID

//#define BL_EXT_DEBUG_INFO

#define BL_EXTERN_NAME			"bl_mipi_LT070ME05"
#define BL_EXTERN_TYPE			BL_EXTERN_OTHER

static unsigned int bl_status = 0;
static unsigned int bl_level = 0;

static struct bl_extern_config_t bl_ext_config = {
    .name = BL_EXTERN_NAME,
    .type = BL_EXTERN_TYPE,
    .gpio_used = 1,
    .gpio = GPIODV_28,
    .dim_min = 10,
    .dim_max = 255,
};

static int bl_extern_set_level(unsigned int level)
{
    unsigned char payload[6]={0x15,0x51,1,0x00,0xff,0xff};

    bl_level = level;
    if (bl_status) {
        get_bl_level(&bl_ext_config);
        level = bl_ext_config.dim_min - ((level - bl_ext_config.level_min) * (bl_ext_config.dim_min - bl_ext_config.dim_max)) / (bl_ext_config.level_max - bl_ext_config.level_min);
        level &= 0xff;

        payload[3] = level;
        dsi_write_cmd(payload);
    }
    return 0;
}

static int bl_extern_power_on(void)
{
    unsigned char temp;
    int ret;

    if (bl_ext_config.gpio_used > 0) {
        bl_extern_gpio_direction_output(bl_ext_config.gpio, 1);
    }
    bl_status = 1;

    if (bl_level > 0) {
        bl_extern_set_level(bl_level);
    }

    printf("%s\n", __FUNCTION__);
    return 0;
}

static int bl_extern_power_off(void)
{
    bl_status = 0;
    if (bl_ext_config.gpio_used > 0) {
        bl_extern_gpio_direction_output(bl_ext_config.gpio, 0);
    }

    printf("%s\n", __FUNCTION__);
    return 0;
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
#endif
