#ifndef __ODROID_MISC_H__
#define __ODROID_MISC_H__

#include <asm/gpio.h>

#define	GPIO_LED_G	EXYNOS5420_GPIO_B21
#define	GPIO_LED_B	EXYNOS5420_GPIO_B22
#define	GPIO_LED_R	EXYNOS5420_GPIO_X23

#define	GPIO_POWER_BT	EXYNOS5420_GPIO_X03
#define	GPIO_FAN_CTL	EXYNOS5420_GPIO_B20
#define	GPIO_LCD_PWM	EXYNOS5420_GPIO_B23

#define	BOOT_EMMC	0x6
#define	BOOT_EMMC_4_4	0x7

/* Self update option */
#define	OPTION_ERASE_USERDATA	0x01
#define	OPTION_ERASE_FAT	0x02
#define	OPTION_ERASE_ENV	0x04
#define	OPTION_UPDATE_UBOOT	0x08
#define	OPTION_RESIZE_PART	0x10
#define	OPTION_FILELOAD_EXT4	0x20
#define	OPTION_OLDTYPE_PART	0x40

enum	{
	PART_FWBL1 = 0,
	PART_BL2,
	PART_BOOTLOADER,
	PART_TZSW,
	PART_ENV,
	PART_KERNEL,
	PART_FAT,
	PART_SYSTEM,
	PART_USERDATA,
	PART_CACHE,
	PART_MAX
};

struct partition_info {
	const char	name[16];	/* partition name */
	u64		blk_start;	/* start blk number */
	u64		size;		/* size in bytes */
	unsigned int	raw_en;		/* raw access enable for emmc */
};

struct upload_info {
	char	part_name[16];
	uint	mem_addr;
	uint	file_size;
};

extern	int odroid_get_partition_info	(const char *ptn, struct partition_info *pinfo);
extern	int odroid_partition_setup	(char *dev_no);

extern	void odroid_led_ctrl	(int gpio, int status);
extern	void odroid_self_update	(uint option);
extern	void odroid_misc_init	(void);
extern	void odroid_power_off	(void);

#endif /* __ODROID_MISC_H__ */
