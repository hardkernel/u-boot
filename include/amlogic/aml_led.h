#ifndef __AML_LED_H__
#define __AML_LED_H__

#define LED_TIMER_INTERVAL 10 //ms

#define LED_EVENT_NULL 0
#define LED_EVENT_OFF 1
#define LED_EVENT_ON 2
#define LED_EVENT_FLASH 3
#define LED_EVENT_BREATH 4

#define SHUTDOWN_MODE 0
#define SUSPEND_RESUME_MODE 1
#define RECOVERY_MODE 2


enum led_workmode {
	LWM_OFF,
	LWM_ON,
	LWM_FLASH,
	LWM_BREATH,
	LWM_NULL,
};

/* s,b,w type is enum led_workmode */
#define lwm_set_standby(mode, s) do {mode |= (s) << 0;} while(0)
#define lwm_set_booting(mode, b) do {mode |= (b) << 4;} while(0)
#define lwm_set_working(mode, w) do {mode |= (w) << 8;} while(0)
#define lwm_set_suspend(mode, s) do {mode |= (s) << 12;} while(0)

#define lwm_get_standby(mode) (((mode) >> 0) & 0xF)
#define lwm_get_booting(mode) (((mode) >> 4) & 0xF)
#define lwm_get_working(mode) (((mode) >> 8) & 0xF)
#define lwm_get_suspend(mode) (((mode) >> 12) & 0xF)

struct coord {
	int x;
	int y;
};

struct aml_led_config {
	int off_brightness;
	int on_brightness;
	int flash_off_brightness;
	int flash_off_time;
	int flash_on_brightness;
	int flash_on_time;
	struct coord *breath_inflections;
	int breath_inflections_num;
	void (*set_brightness)(int brightness);
};

#define LED_EVENT_BUF_SIZE 3
struct aml_led {
	int event[LED_EVENT_BUF_SIZE];
	int event_data[LED_EVENT_BUF_SIZE];
	int state;
	int brightness;
	int time;
	int count;
	struct aml_led_config *config;
};

void aml_led_init(struct aml_led *led, struct aml_led_config *config);
void aml_led_timer_proc(struct aml_led *led);
void aml_led_event(struct aml_led *led, int event, int event_data);

#endif