#ifndef __ODROID_MISC_H__
#define __ODROID_MISC_H__

#include <asm/gpio.h>

#define	GPIO_LED_G	EXYNOS5420_GPIO_B21
#define	GPIO_LED_B	EXYNOS5420_GPIO_B22
#define	GPIO_LED_R	EXYNOS5420_GPIO_X23

#define	GPIO_POWER_BT	EXYNOS5420_GPIO_X03
#define	GPIO_FAN_CTL	EXYNOS5420_GPIO_B20
#define	GPIO_LCD_PWM	EXYNOS5420_GPIO_B23

enum	{
	PART_FWBL1 = 0,
	PART_BL2,
	PART_BOOTLOADER,
	PART_TZSW,
	PART_ENV,
	PART_KERENEL,
	PART_SYSTEM,
	PART_USERDATA,
	PART_CACHE,
	PART_MAX
};

struct partition_info {
	const char	name[16];	/* partition name */
	unsigned int	blk_start;	/* start blk number */
	unsigned int	size;		/* size in bytes */
	unsigned int	raw_en;		/* raw access enable for emmc */
};

extern	int odroid_get_partition_info	(const char *ptn, struct partition_info *pinfo);
extern	int odroid_partition_setup	(char *dev_no);

extern	void odroid_led_ctrl	(int gpio, int status);
extern	void odroid_misc_init	(void);

#endif /* __ODROID_MISC_H__ */
