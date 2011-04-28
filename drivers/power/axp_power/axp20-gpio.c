/*
 * axp199-gpio.c  --  gpiolib support for Krosspower &axp PMICs
 *
 * Copyright 2011 Amlogic Ltd.
 *
 * Author: Elvis Yu
 *
 *  This program is free software; you can redistribute  it and/or modify it
 *  under  the terms of  the GNU General  Public License as published by the
 *  Free Software Foundation;  either version 2 of the  License, or (at your
 *  option) any later version.
 *
 */
#include <common.h>
#include <asm-generic/errno.h>
#include <axp-mfd.h>

#include <axp-gpio.h>

static int axp_io_state = 0;
int axp_gpio_set_io(int gpio, int io_state)
{
    if(io_state == 1){
        axp_io_state |= (1 << gpio);
        switch (gpio) {
            /*
             * for out put, set pin to high-z state, and remember to a variable
             * in order to prevent unstable state on GPIO.
             */
        case 0: return axp_update(AXP20_GPIO0_CFG, 0x07, 0x07);
        case 1: return axp_update(AXP20_GPIO1_CFG, 0x07, 0x07);
        case 2: return axp_update(AXP20_GPIO2_CFG, 0x07, 0x07);
        case 3: return axp_update(AXP20_GPIO3_CFG, 0x04, 0x04);
        default: return -ENXIO;
        }
    } else if (io_state == 0) {
        axp_io_state &= ~(1 << gpio);
        switch (gpio) {
        case 0: return axp_update(AXP20_GPIO0_CFG, 0x02, 0x07);
        case 1: return axp_update(AXP20_GPIO1_CFG, 0x02, 0x07);
        case 2: return axp_update(AXP20_GPIO2_CFG, 0x02, 0x07);
        case 3: return axp_update(AXP20_GPIO3_CFG, 0x04, 0x04);
        default: return -ENXIO;
        }
    }
    return -EINVAL;
}

int check_io012(int gpio, int val, int *io_state)
{
    if (gpio > 2 || gpio < 0) {
        return -1;    
    }
    if ((val & 0x07) == 0x07 && axp_io_state & (1 << gpio)) {
        *io_state = 1;    
    } else if (val == 0x02) {
        *io_state = 0;    
    } else {
        return -1;    
    }
    return 0;
}

int axp_gpio_get_io(int gpio, int *io_state)
{
    uint8_t val;

    switch (gpio) {
    case 0: axp_read(AXP20_GPIO0_CFG, &val);
            return check_io012(gpio, val & 0x07, io_state);
    case 1: axp_read(AXP20_GPIO1_CFG, &val);
            return check_io012(gpio, val & 0x07, io_state);
    case 2: axp_read(AXP20_GPIO2_CFG, &val);
            return check_io012(gpio, val & 0x07, io_state);
    case 3: axp_read(AXP20_GPIO3_CFG, &val);
            val &= 0x04;
            if (val == 0x0) {
                *io_state = 1;
            } else {
                *io_state = 0;
            }
            break;
    default: return -ENXIO;
    }

    return 0;
}

int axp_gpio_set_value(int gpio, int value)
{
    int io_state,ret;
    /*
     * ignore preve io state, set gpio to what caller want
     */
    printf("%s, gpio:%d, value:%d\n", __func__, gpio, value);
    if(value){
        switch (gpio) {
        case 0: return axp_update(AXP20_GPIO0_CFG, 0x01, 0x07);
        case 1: return axp_update(AXP20_GPIO1_CFG, 0x01, 0x07);
        case 2: return axp_update(AXP20_GPIO2_CFG, 0x01, 0x07);     // Need extern pull up resistor 
        case 3: return axp_update(AXP20_GPIO3_CFG, 0x02, 0x07);     // Need extern pull up resistor
        default: break;
        }
    } else {
        switch (gpio) {
        case 0: return axp_update(AXP20_GPIO0_CFG, 0x00, 0x07);
        case 1: return axp_update(AXP20_GPIO1_CFG, 0x00, 0x07);
        case 2: return axp_update(AXP20_GPIO2_CFG, 0x00, 0x07);
        case 3: return axp_update(AXP20_GPIO3_CFG, 0x00, 0x07);
        default:break;
        }
    }
    return -ENXIO;
}

int axp_gpio_get_value(int gpio, int *value)
{
    int io_state;
    int ret;
    uint8_t val;
    ret = axp_gpio_get_io(gpio,&io_state);
    if(ret)
        return ret;
    if(io_state){
        switch (gpio) {
        case 0:ret = axp_read(AXP20_GPIO0_CFG, &val);*value = val & 0x01;break;
        case 1:ret = axp_read(AXP20_GPIO1_CFG, &val);*value = val & 0x01;break;
        case 2:ret = axp_read(AXP20_GPIO2_CFG, &val);*value = val & 0x01;break; 
        case 3:ret = axp_read(AXP20_GPIO3_CFG, &val);val &= 0x02;*value = val>>1;break;
        default: return -ENXIO;
        }
    } else {
        switch (gpio) {
        case 0:ret = axp_read(AXP20_GPIO012_STATE, &val);val &= 0x10;*value = val>>4;break;
        case 1:ret = axp_read(AXP20_GPIO012_STATE, &val);val &= 0x20;*value = val>>5;break;
        case 2:ret = axp_read(AXP20_GPIO012_STATE, &val);val &= 0x40;*value = val>>6;break;
        case 3:ret = axp_read(AXP20_GPIO3_CFG, &val);*value = val & 0x01;break;
        default: return -ENXIO;
        }
    }
    return ret;
}

