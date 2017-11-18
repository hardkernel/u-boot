/*
 * uboot/aml_led.c
 *
 * Copyright (C) 2015 Amlogic, Inc. All rights reserved.
 *
*/

#include <amlogic/aml_led.h>

#define LED_STA_IDLE 0
#define LED_STA_FLASH_ON 1
#define LED_STA_FLASH_OFF 2
#define LED_STA_BREATH 3


static int curve_approximate(struct coord *c, int num, int x)
{
	int x0, y0, x1, y1, y=-1;
	int i;

	for (i=1; i<num; i++) {
		if (x < c[i].x) {
			x0 = c[i-1].x;
			y0 = c[i-1].y;
			x1 = c[i].x;
			y1 = c[i].y;
			if (y1 == y0)
				y = y0;
			else
				y = y0 + (y1-y0)*(x-x0)/(x1-x0);
			break;
		}
	}
	return y;
}

void aml_led_init(struct aml_led *led, struct aml_led_config *config)
{
	int i;

	led->config = config;
	for (i=0; i<LED_EVENT_BUF_SIZE; i++)
		led->event[i] = LED_EVENT_NULL;
	led->count = 0;
	led->time = 0;
	led->state = LED_STA_IDLE;
}


void aml_led_event(struct aml_led *led, int event, int event_data)
{
	int i;

	for (i=0; i<LED_EVENT_BUF_SIZE; i++) {
		if (led->event[i] == LED_EVENT_NULL) {
			led->event[i] = event;
			led->event_data[i] = event_data;
			break;
		}
	}
}

static void aml_led_event_handle(struct aml_led *led)
{
	struct aml_led_config *config = led->config;
	int event;
	int i;

	for (i=0; i<LED_EVENT_BUF_SIZE; i++) {
		event = led->event[i];
		if (event != LED_EVENT_NULL) {
			led->event[i] = LED_EVENT_NULL;
			switch (event) {
				case LED_EVENT_ON:
				led->brightness = config->on_brightness;
				config->set_brightness(led->brightness);
				led->state = LED_STA_IDLE;
				break;

				case LED_EVENT_OFF:
				led->brightness = config->off_brightness;
				config->set_brightness(led->brightness);
				led->state = LED_STA_IDLE;
				break;

				case LED_EVENT_FLASH:
				led->count = led->event_data[i];
				if (led->event_data[i])
					led->count++;
				led->time = config->flash_off_time/LED_TIMER_INTERVAL;
				led->brightness = config->flash_off_brightness;
				config->set_brightness(led->brightness);
				led->state = LED_STA_FLASH_OFF;
				break;

				case LED_EVENT_BREATH:
				led->time = 0;
				led->state = LED_STA_BREATH;
				break;

				default:
				break;
			}
			break;
		}
	}
}

void aml_led_timer_proc(struct aml_led *led)
{
	struct aml_led_config *config = led->config;

	switch (led->state) {
		case LED_STA_IDLE:
		aml_led_event_handle(led);
		break;

		case LED_STA_FLASH_ON:
		if (--led->time == 0) {
			led->time = config->flash_off_time/LED_TIMER_INTERVAL;
			led->brightness = config->flash_off_brightness;
			config->set_brightness(led->brightness);
			led->state = LED_STA_FLASH_OFF;
		}
		break;

		case LED_STA_FLASH_OFF:
		if (--led->time == 0) {
			if ((led->count == 0)
			|| ((led->count>0) && (--led->count))) {
				led->time = config->flash_on_time/LED_TIMER_INTERVAL;
				led->brightness = config->flash_on_brightness;
				config->set_brightness(led->brightness);
				led->state = LED_STA_FLASH_ON;
				if (led->count == 0)
					aml_led_event_handle(led);
			}
			else {
				led->state = LED_STA_IDLE;
				aml_led_event_handle(led);
			}
		}
		break;

		case LED_STA_BREATH:
		led->brightness = curve_approximate(
			config->breath_inflections,
			config->breath_inflections_num,
			led->time);
		if (led->brightness < 0)
			led->time = 0;
		else {
			config->set_brightness(led->brightness);
			led->time += LED_TIMER_INTERVAL;
		}
		aml_led_event_handle(led);
		break;

		default:
		break;
	}
}
