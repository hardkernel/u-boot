/*
 * AMLOGIC baclight external driver.
 *
 */

#include <common.h>
#include <asm/arch/io.h>
#include <amlogic/aml_bl_extern.h>
#ifdef CONFIG_PLATFORM_HAS_PMU
#include <amlogic/aml_pmu_common.h>
#endif

#ifdef CONFIG_AML_BL_EXTERN
//#define BL_EXT_DEBUG_INFO

#define BL_EXTERN_NAME			"bl_pmu_aml1218"
#define BL_EXTERN_TYPE			BL_EXTERN_OTHER

static unsigned int bl_status = 0;
static unsigned int bl_level = 0;

static struct bl_extern_config_t bl_ext_config = {
    .name = BL_EXTERN_NAME,
    .type = BL_EXTERN_TYPE,
    .gpio_used = 1,
    .gpio = GPIODV_28,
    .dim_min = 0x1b,
    .dim_max = 0x1,
};

static int bl_extern_set_level(unsigned int level)
{
#ifdef CONFIG_PLATFORM_HAS_PMU
    struct aml_pmu_driver *pmu_driver;
    unsigned char temp;
#endif
    int ret = 0;

    bl_level = level;
    if (bl_status) {
        get_bl_level(&bl_ext_config);
        level = bl_ext_config.dim_min - ((level - bl_ext_config.level_min) * (bl_ext_config.dim_min - bl_ext_config.dim_max)) / (bl_ext_config.level_max - bl_ext_config.level_min);
        level &= 0x1f;

#ifdef CONFIG_PLATFORM_HAS_PMU
        pmu_driver = aml_pmu_get_driver();
        if (pmu_driver == NULL) {
            printf("no pmu driver\n");
            return -1;
        }
        else {
            if ((pmu_driver->pmu_reg_write) && (pmu_driver->pmu_reg_read)) {
                ret = pmu_driver->pmu_reg_read(0x005f, &temp);
                temp &= ~(0x3f << 2);
                temp |= (level << 2);
                ret = pmu_driver->pmu_reg_write(0x005f, temp);
            }
            else {
                printf("no pmu_reg_read/write\n");
                return -1;
            }
        }
#endif
    }
    return ret;
}

static int bl_extern_power_on(void)
{
#ifdef CONFIG_PLATFORM_HAS_PMU
    struct aml_pmu_driver *pmu_driver;
    unsigned char temp;
#endif
    int ret = 0;

#ifdef CONFIG_PLATFORM_HAS_PMU
    pmu_driver = aml_pmu_get_driver();
    if (pmu_driver == NULL) {
        printf("no pmu driver\n");
        return -1;
    }
    else {
        if ((pmu_driver->pmu_reg_write) && (pmu_driver->pmu_reg_read)) {
            ret = pmu_driver->pmu_reg_read(0x005e, &temp);
            temp |= (1 << 7);
            ret = pmu_driver->pmu_reg_write(0x005e, temp);//DCEXT_IREF_ADJLV2_EN
        }
        else {
            printf("no pmu_reg_read/write\n");
            return -1;
        }
    }
#endif
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
#ifdef CONFIG_AMLOGIC_BOARD_HAS_PMU
    struct aml_pmu_driver *pmu_driver;
    unsigned char temp;
#endif
    int ret = 0;

    bl_status = 0;
    if (bl_ext_config.gpio_used > 0) {
        bl_extern_gpio_direction_output(bl_ext_config.gpio, 0);
    }
#ifdef CONFIG_AMLOGIC_BOARD_HAS_PMU
    pmu_driver = aml_pmu_get_driver();
    if (pmu_driver == NULL) {
        printf("no pmu driver\n");
        return -1;
    }
    else {
        if ((pmu_driver->pmu_reg_write) && (pmu_driver->pmu_reg_read)) {
            ret = pmu_driver->pmu_reg_read(0x005e, &temp);
            temp &= ~(1 << 7);
            ret = pmu_driver->pmu_reg_write(0x005e, temp);//DCEXT_IREF_ADJLV2_EN
        }
        else {
            printf("no pmu_reg_read/write\n");
            return -1;
        }
    }
#endif

    printf("%s\n", __FUNCTION__);
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
