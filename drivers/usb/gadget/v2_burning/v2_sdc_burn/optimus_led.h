/*
 * \file        optimus_led.h
 * \brief       show burning states by LED
 *              current supported LED source is PWM, other type not supported yet!
 *
 * \version     1.0.0
 * \date        2013/11/9
 * \author      Sam.Wu <yihui.wu@amlgic.com>
 *
 * Copyright (c) 2013 Amlogic Inc.. All Rights Reserved.
 *
 */
#ifndef __OPTIMUS_LED_H__
#define __OPTIMUS_LED_H__

#define LED_TYPE_PWM        0xabcd

#if CONFIG_SD_BURNING_SUPPORT_LED

int optimus_led_open(int ledType);//open the led for show burning states

int optimus_led_close(void);

int optimus_led_show_in_process_of_burning(void);

int optimus_led_show_burning_success(void);

int optimus_led_show_burning_failure(void);

#else
#define optimus_led_open(ledType)                   0
#define optimus_led_close()                         0
#define optimus_led_show_in_process_of_burning()    do{}while(0)
#define optimus_led_show_burning_success()          do{}while(0)
#define optimus_led_show_burning_failure()          do{}while(0)

#endif// #if CONFIG_SD_BURNING_SUPPORT_LED

#endif//ifndef __OPTIMUS_LED_H__

