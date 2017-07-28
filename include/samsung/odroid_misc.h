#ifndef __ODROID_MISC_H__
#define __ODROID_MISC_H__

#include <asm/gpio.h>

#define	GPIO_LED_G	EXYNOS5420_GPIO_B21
#define	GPIO_LED_B	EXYNOS5420_GPIO_B22
#define	GPIO_LED_R	EXYNOS5420_GPIO_X23

#define	GPIO_POWER_BT	EXYNOS5420_GPIO_X03
#define	GPIO_FAN_CTL	EXYNOS5420_GPIO_B20
#define	GPIO_LCD_PWM	EXYNOS5420_GPIO_B23

extern	void odroid_led_ctrl	(int gpio, int status);
extern	void odroid_misc_init	(void);

#endif /* __ODROID_MISC_H__ */
