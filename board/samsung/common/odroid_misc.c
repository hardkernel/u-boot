/*
 * Odroid Board setup for EXYNOS5 based board
 *
 * Copyright (C) 2017 Hardkernel Co.,Ltd
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */
#include <common.h>
#include <asm/arch/cpu.h>
#include <asm/arch/board.h>
#include <asm/arch/dwmmc.h>
#include <asm/arch/mmc.h>
#include <asm/arch/pinmux.h>
#include <asm/arch/power.h>
#include <asm/arch/system.h>
#include <asm/arch/sromc.h>
#include <asm/gpio.h>
#include <asm/io.h>
#include <samsung/misc.h>
#include <samsung/odroid_misc.h>
#include <errno.h>
#include <version.h>
#include <malloc.h>
#include <memalign.h>
#include <linux/sizes.h>
#include <linux/input.h>
#include <power/pmic.h>
#include <power/regulator.h>
#include <power/s2mps11.h>
#include <dm.h>
#include <adc.h>
#include <mmc.h>

DECLARE_GLOBAL_DATA_PTR;

/* ODROID Debug Message */
/*
#define	ODROID_MISC_DEBUG
*/

/*
	Default Partition Info for Android system
*/
static struct partition_info gPartInfo[PART_MAX] = {
	[PART_FWBL1] = {
		.name 	   = "fwbl1",
		.blk_start = PART_BL1_ST_BLK,
		.size 	   = PART_SIZE_BL1,
		.raw_en    = 1,
	},
	[PART_BL2] = {
		.name 	   = "bl2",
		.blk_start = PART_BL2_ST_BLK,
		.size 	   = PART_SIZE_BL2,
		.raw_en    = 1,
	},
	[PART_BOOTLOADER] = {
		.name 	   = "bootloader",
		.blk_start = PART_UBOOT_ST_BLK,
		.size 	   = PART_SIZE_UBOOT,
		.raw_en    = 1,
	},
	[PART_TZSW] = {
		.name 	   = "tzsw",
		.blk_start = PART_TZSW_ST_BLK,
		.size 	   = PART_SIZE_TZSW,
		.raw_en    = 1,
	},
	[PART_ENV] = {
		.name 	   = "env",
		.blk_start = PART_ENV_ST_BLK,
		.size 	   = PART_SIZE_ENV,
		.raw_en    = 0,
	},
	[PART_KERNEL] = {
		.name 	   = "kernel",
		.blk_start = PART_KERNEL_ST_BLK,
		.size 	   = PART_SIZE_KERNEL,
		.raw_en    = 0,
	},
	[PART_FAT] = {
		.name 	   = "fat",
		.blk_start = 0,
		.size 	   = 0,
		.raw_en    = 0,
	},
	[PART_SYSTEM] = {
		.name 	   = "system",
		.blk_start = 0,
		.size 	   = 0,
		.raw_en    = 0,
	},
	[PART_USERDATA] = {
		.name 	   = "userdata",
		.blk_start = 0,
		.size 	   = 0,
		.raw_en    = 0,
	},
	[PART_CACHE] = {
		.name 	   = "cache",
		.blk_start = 0,
		.size 	   = 0,
		.raw_en    = 0,
	},
};

/*---------------------------------------------------------------------------*/
/* from cmd/mmc.c */
extern int get_mmc_part_info(char *device_name, int part_num,
	u64 *block_start, u64 *block_count, uchar *part_Id);

/*---------------------------------------------------------------------------*/
static void odroid_print_part_info(char *dev_no)
{
	uint i, blk_start, blk_count, kb_size;

	printf("\n*** Partition Information for Andorid ***");
	printf("\nControl Device ID : %s", dev_no);
	printf("\npNo\tStart Block\tBlock Count\tpName");

	for (i = 0; i < PART_MAX; i++) {
		blk_start = gPartInfo[i].blk_start;
		blk_count = gPartInfo[i].size / MOVI_BLK_SIZE;
		kb_size   = gPartInfo[i].size / SZ_1K;
		printf("\n %d \t%8d\t%8d\t%s (%d KB)",
			i, blk_start, blk_count, gPartInfo[i].name, kb_size);
	}
	printf("\n\n");
}

/*---------------------------------------------------------------------------*/
int odroid_get_partition_info(const char *ptn, struct partition_info *pinfo)
{
	int i;

	for (i = 0; i < PART_MAX; i++) {
		if (!strncmp(gPartInfo[i].name, ptn, strlen(ptn)))
			break;
	}
	if (PART_MAX == i)
		return	-1;

	memcpy((void *)pinfo, (void *)&gPartInfo[i],
		sizeof(struct partition_info));
	return	0;
}

/*---------------------------------------------------------------------------*/
/*
	Partition information setup for Android fastboot.

	Partition 1 = fat partition
	Partition 2 - system partition
	Partition 3 - userdata partition
	Partition 4 - cache partition
*/
/*---------------------------------------------------------------------------*/
int odroid_partition_setup(char *dev_no)
{
	u64 blk_st, blk_cnt;
	unsigned char pid, i;

	for (i = 0; i < 4; i++)	{
		if (get_mmc_part_info (dev_no, i + 1, &blk_st, &blk_cnt, &pid))
			goto err;
		if (pid != 0x83 && pid != 0x0C)
			goto err;
		gPartInfo[PART_FAT+i].blk_start = blk_st;
		gPartInfo[PART_FAT+i].size = (blk_cnt * MOVI_BLK_SIZE);
	}

	odroid_print_part_info(dev_no);
	return	0;
err:
	printf( "\n****************************\n" \
		"\n***      Warning!!!      ***\n" \
		"\n****************************\n" \
		"\This is not an Android Partition device!" \
		"\nIf you want Android partitioning," \
		"use fdisk command befor fastboot command.\n\n");
	return	-1;
}

/*---------------------------------------------------------------------------*/
void odroid_led_ctrl(int gpio, int status)
{
	gpio_set_value(gpio, status);
}

/*---------------------------------------------------------------------------*/
static void odroid_pmic_deinit(void)
{
	struct udevice *dev;

	if (pmic_get("s2mps11", &dev))	{
		printf("%s : s2mps11 control error!\n", __func__);
		return;
	}
	/* Master Reset Enable */
	pmic_reg_write(dev, S2MPS11_REG_CTRL1, 0x0);
}

/*---------------------------------------------------------------------------*/
static void odroid_pmic_init(void)
{
	struct udevice *dev;

	if (pmic_get("s2mps11", &dev))	{
		printf("%s : s2mps11 control error!\n", __func__);
		return;
	}

	/* LDO9 : USB 3.0 3.3V */
	pmic_reg_write(dev, S2MPS11_REG_L9CTRL, 0xF2);

	/* LDO15, LDO17 : ETH 3.3V */
	pmic_reg_write(dev, S2MPS11_REG_L15CTRL, 0xF2);
	pmic_reg_write(dev, S2MPS11_REG_L17CTRL, 0xF2);

	/* LDO13, LDO19 : MMC 3.3V */
	pmic_reg_write(dev, S2MPS11_REG_L13CTRL, 0xF2);
	pmic_reg_write(dev, S2MPS11_REG_L19CTRL, 0xF2);

	/* BUCK10 : eMMC 2.85V */
	pmic_reg_write(dev, S2MPS11_REG_B10CTRL2, 0xA8);

	/* Master Reset Enable */
	pmic_reg_write(dev, 0x0c, 0x10);

#if defined(ODROID_MISC_DEBUG)
	/* debug message */
	printf("S2MPS11_REG_L9CTRL = 0x%02X\n",
		pmic_reg_read(dev, S2MPS11_REG_L9CTRL));
	printf("S2MPS11_REG_L15CTRL = 0x%02X\n",
		pmic_reg_read(dev, S2MPS11_REG_L15CTRL));
	printf("S2MPS11_REG_L17CTRL = 0x%02X\n",
		pmic_reg_read(dev, S2MPS11_REG_L17CTRL));
	printf("S2MPS11_REG_L13CTRL = 0x%02X\n",
		pmic_reg_read(dev, S2MPS11_REG_L13CTRL));
	printf("S2MPS11_REG_L19CTRL = 0x%02X\n",
		pmic_reg_read(dev, S2MPS11_REG_L19CTRL));
	printf("S2MPS11_REG_B10CTRL2 = 0x%02X\n",
		pmic_reg_read(dev, S2MPS11_REG_B10CTRL2));
#endif
}

/*---------------------------------------------------------------------------*/
static void odroid_led_deinit(void)
{
	odroid_led_ctrl(GPIO_LED_R, 0);
	odroid_led_ctrl(GPIO_LED_G, 0);
	odroid_led_ctrl(GPIO_LED_B, 0);
	gpio_free(GPIO_LED_R);
	gpio_free(GPIO_LED_G);
	gpio_free(GPIO_LED_B);
}

/*---------------------------------------------------------------------------*/
static void odroid_led_init(void)
{
	if (gpio_request(GPIO_LED_R, "LED-R")) 
		goto	err;
	odroid_led_ctrl(GPIO_LED_R, 0);

	if (gpio_request(GPIO_LED_G, "LED-G"))
		goto	err;
	odroid_led_ctrl(GPIO_LED_G, 0);

	/* Default On */
	if (gpio_request(GPIO_LED_B, "LED-B"))
		goto	err;
	odroid_led_ctrl(GPIO_LED_B, 1);

	return;
err:
	printf("%s : GPIO Control error!\n", __func__);
}

/*---------------------------------------------------------------------------*/
static void odroid_gpio_deinit(void)
{
	gpio_direction_output(GPIO_FAN_CTL, 0);
	gpio_direction_output(GPIO_LCD_PWM, 0);

	gpio_free(GPIO_POWER_BT);
	gpio_free(GPIO_FAN_CTL);
	gpio_free(GPIO_LCD_PWM);
}

/*---------------------------------------------------------------------------*/
static void odroid_gpio_init(void)
{
	/* Power control button pin */
	if (gpio_request(GPIO_POWER_BT, "Power BT"))
		goto err;
	gpio_set_pull(GPIO_POWER_BT, S5P_GPIO_PULL_NONE);
	gpio_direction_input(GPIO_POWER_BT);

	/* FAN Full Enable */
	if (gpio_request(GPIO_FAN_CTL, "FAN Ctrl"))
		goto err;
	gpio_set_pull(GPIO_FAN_CTL, S5P_GPIO_PULL_NONE);
	gpio_direction_output(GPIO_FAN_CTL, 1);

	/* LCD PWM Port High */
	if (gpio_request(GPIO_LCD_PWM, "LCD PWM"))
		goto err;
	gpio_set_pull(GPIO_LCD_PWM, S5P_GPIO_PULL_NONE);
	gpio_direction_output(GPIO_LCD_PWM, 1);

	return;
err:
	printf("%s : GPIO Control error!\n", __func__);
}

/*---------------------------------------------------------------------------*/
static uint upload_file(const char *fname, const char *pname,
	uint mem_addr, struct upload_info *upinfo, bool is_split)
{
	char	cmd[64], i;
	unsigned long	filesize, fileload_part = 0;
	unsigned long	total_fsize = 0;

	/* file load from userdata area */
	fileload_part = getenv_ulong("fileload_part", 10, 0);

	/* mem load start addr */
	upinfo->mem_addr = mem_addr;

	/* max load file count = 64 */
	for(i = 0; i < 64; i++) {
		#if defined(ODROID_MISC_DEBUG)
			printf("%s : %s, fname = %s%c, load_addr = 0x%08x\n",
				__func__, pname, fname,
				is_split ? ('a'+i) : ' ',
				mem_addr);
		#endif
		/* env variable init */
		setenv("filesize", "0");
		filesize = 0;
		memset(cmd, 0x00, sizeof(cmd));

		if (fileload_part)
			sprintf(cmd, "ext4load mmc 0:3 %x media/0/update/%s%c",
				mem_addr, fname,
				is_split ? ('a'+i) : ' ');
		else
			sprintf(cmd, "fatload mmc 0:1 %x update/%s%c",
				mem_addr, fname,
				is_split ? ('a'+i) : ' ');
		run_command(cmd, 0);

		/* file size check */
		if ((filesize = getenv_ulong("filesize", 16, 0))) {
			#if defined(ODROID_MISC_DEBUG)
				printf("%s : filesize = %ld, total_filesize = %ld\n",
					__func__, filesize, total_fsize);
			#endif
			total_fsize += filesize;
		}

		mem_addr += filesize;
		/* load memory overflow */
		if (total_fsize >= (SZ_1G + SZ_512M)) {
			printf("ERROR! Memory overflow! fcount = %d, fsize = %ld\n",
				i, total_fsize);
			upinfo->file_size = 0;
			return	upinfo->mem_addr;
		}
		if (!is_split || !filesize)
			goto out;
	}
out:
	if (total_fsize) {
		strncpy(upinfo->part_name, pname, strlen(pname));
		upinfo->file_size = total_fsize;
		return  (mem_addr + 256) & 0xFFFFFF00;
	}

	printf("ERROR! update/%s%c File Not Found!! filesize = 0\n",
		fname, is_split ? 'a'+i : ' ');
	/* error */
	return  mem_addr;
}

/*---------------------------------------------------------------------------*/
static void update_raw_image(struct upload_info *upinfo)
{
	char cmd[64], is_emmc = 0, ptn;

	memset(cmd, 0x00, sizeof(cmd));

	if (!strncmp(getenv("boot_device"), "eMMC", sizeof("eMMC")))
		is_emmc = 1;

	if (!strncmp(upinfo->part_name, "kernel", sizeof("kernel"))) {
		sprintf(cmd, "movi w k 0 0x%08x", upinfo->mem_addr);
		run_command(cmd, 0);
	} else {
		if (!strncmp(upinfo->part_name, "bootloader", sizeof("bootloader")))
			ptn = 'u';
		if (!strncmp(upinfo->part_name, "bl1", sizeof("bl1")))
			ptn = 'f';
		if (!strncmp(upinfo->part_name, "bl2", sizeof("bl2")))
			ptn = 'b';
		if (!strncmp(upinfo->part_name, "tzsw", sizeof("tzsw")))
			ptn = 't';

		if (is_emmc)
			sprintf(cmd, "movi w z %c 0 0x%08x", ptn, upinfo->mem_addr);
		else
			sprintf(cmd, "movi w %c 0 0x%08x", ptn, upinfo->mem_addr);

		if (is_emmc)
			run_command("emmc open 0", 0);

		run_command(cmd, 0);

		if (is_emmc)
			run_command("emmc close 0", 0);
	}
}

/*---------------------------------------------------------------------------*/
static void update_ptn_image(struct upload_info *upinfo)
{
	char	cmd[64];

	memset(cmd, 0x00, sizeof(cmd));
	sprintf(cmd, "fastboot flash %s 0x%08x 0",
		upinfo->part_name, upinfo->mem_addr);
	run_command(cmd, 0);
}

/*---------------------------------------------------------------------------*/
static void upload_data_write(struct upload_info *upinfo, int is_raw)
{
	if (is_raw) {
		if (upinfo->file_size)
			update_raw_image(upinfo);
	} else {
		if (upinfo->file_size)
			update_ptn_image(upinfo);
	}
}

/*---------------------------------------------------------------------------*/
/* firmware update check */
static void odroid_fw_update(unsigned int option)
{
	unsigned long		upload_addr = 0, i;
	struct upload_info 	upinfo[PART_MAX];
	struct exynos5_power *pmu =
		(struct exynos5_power *)samsung_get_base_power();

	odroid_led_ctrl(GPIO_LED_B, 1);

	memset(upinfo, 0x00, sizeof(upinfo));

	if (option & OPTION_FILELOAD_EXT4)
		setenv_ulong("fileload_part", 3);
	else
		setenv_ulong("fileload_part", 0);

	upload_addr = getenv_ulong("loadaddr", 16, 0);
	if (!upload_addr)
		upload_addr = CFG_FASTBOOT_TRANSFER_BUFFER;

#if 0
	upload_addr = upload_file("system.img",
		"system", upload_addr, &upinfo[PART_SYSTEM], false);

	if (!upinfo[PART_SYSTEM].file_size) {
		/*
		 If the system.img size is larger than 256MB,
		 use 256MB divided images.
		 max file load size is 1.5Gbytes.
		 image name format : system_aa ... system_af(max 6 file)
		*/
		upload_addr = upload_file("system_a",
			"system", upload_addr, &upinfo[PART_SYSTEM], true);
	}
#endif
	upload_addr = upload_file("system_a",
		"system", upload_addr, &upinfo[PART_SYSTEM], true);

	upload_addr = upload_file("cache.img",
		"cache", upload_addr, &upinfo[PART_CACHE], false);

	if (option & OPTION_ERASE_USERDATA) {
		if ((option & OPTION_RESIZE_PART) == 0) {
			upload_addr = upload_file("userdata.img",
				"userdata", upload_addr, &upinfo[PART_USERDATA], false);
		}
	}

	upload_addr = upload_file("zImage",
		"kernel", upload_addr, &upinfo[PART_KERNEL], false);

	if (!upinfo[PART_KERNEL].file_size) {
		upload_addr = upload_file("zImage-dtb",
			"kernel", upload_addr, &upinfo[PART_KERNEL], false);
	}

	if (option & OPTION_UPDATE_UBOOT) {
		upload_addr = upload_file("u-boot.bin",
			"bootloader", upload_addr, &upinfo[PART_BOOTLOADER], false);
		upload_addr = upload_file("bl1.bin",
			"bl1", upload_addr, &upinfo[PART_FWBL1], false);
		upload_addr = upload_file("bl2.bin",
			"bl2", upload_addr, &upinfo[PART_BL2], false);
		upload_addr = upload_file("tzsw.bin",
			"tzsw", upload_addr, &upinfo[PART_TZSW], false);
	}

	/*
		sysip_data1(msb 16 bits) : system mb size
		sysip_data1(lsb 16 bits) : cache mb size
		sysip_data2		 : userdata mb size
		sysip_data3		 : fat mb size

		default : System 1G/Cache 256M/FAT 100M/expand Userdata
			fdisk -c 0 1024 0 256 100
	*/
	if (option & OPTION_RESIZE_PART) {
		char cmd[64];
		memset(cmd, 0x00, sizeof(cmd));
		sprintf(cmd, "fdisk -c 0 %d %d %d %d",
			(pmu->sysip_dat1 & 0xFFFF0000) >> 16,
			(pmu->sysip_dat2),
			(pmu->sysip_dat1 & 0x0000FFFF),
			(pmu->sysip_dat3));
		pmu->sysip_dat1 = 0;	pmu->sysip_dat2 = 0;
		pmu->sysip_dat3 = 0;
		run_command(cmd, 0);
		if (option & OPTION_FILELOAD_EXT4)
			run_command("fatformat mmc 0:3", 0);
	}
	else if (option & OPTION_OLDTYPE_PART)
		run_command("fdisk -c 0", 0);

	if (option & OPTION_ERASE_USERDATA)
		if (option & OPTION_FILELOAD_EXT4)
			run_command("fatformat mmc 0:3", 0);

	for (i = 0; i < PART_MAX; i++)
		upload_data_write(&upinfo[i], i > PART_KERNEL ? 0 : 1);

	if (option & OPTION_ERASE_ENV)
		run_command(UBOOT_ENV_ERASE, 0);

	if (option & OPTION_ERASE_FAT)
		run_command("fatformat mmc 0:1", 0);

	odroid_led_ctrl(GPIO_LED_B, 0);
}

/*---------------------------------------------------------------------------*/
static void odroid_magic_cmd_check(void)
{
	struct exynos5_power *pmu =
		(struct exynos5_power *)samsung_get_base_power();

	unsigned int	cmd, option;

	cmd	= (pmu->sysip_dat0 & 0xFFFF);
	option	= (pmu->inform0	   & 0xFFFF);

#if defined(ODROID_MISC_DEBUG)
	printf("pmu->sysip = 0x%08x, pmu->inform0 = 0x%08x\n",
		cmd, option);
	printf("pmu->sysip1 = 0x%08x\n", pmu->sysip_dat1);
	printf("pmu->sysip2 = 0x%08x\n", pmu->sysip_dat2);
	printf("pmu->sysip3 = 0x%08x\n", pmu->sysip_dat3);

	printf("resize part size : \n");
	printf("system %d Mb, cache %d Mb, fat %d Mb, userdata %d Mb\n",
		(pmu->sysip_dat1 >> 16)	& 0xFFFF,
		(pmu->sysip_dat1)	& 0xFFFF,
		(pmu->sysip_dat2),
		(pmu->sysip_dat3));
#endif
	pmu->sysip_dat0 = 0;	pmu->inform0 = 0;

	switch(cmd) {
	case	FASTBOOT_MAGIC_REBOOT_CMD:
		run_command("fastboot", 0);
		break;
	case	FASTBOOT_MAGIC_UPDATE_CMD:
		if (!odroid_partition_setup("0"))
			odroid_fw_update(option);
		run_command("reset", 0);
		break;
	}
}

/*---------------------------------------------------------------------------*/
void odroid_self_update(uint option)
{
	struct exynos5_power *pmu =
		(struct exynos5_power *)samsung_get_base_power();

	pmu->sysip_dat1 = 0;	pmu->sysip_dat2 = 0;	pmu->sysip_dat3 = 0;

	if (!odroid_partition_setup("0"))
		odroid_fw_update(option);
}

/*---------------------------------------------------------------------------*/
/*
	ODROID XU3/XU3-Lite/XU4 Hardware Init.
	call from board/samsung/common/board.c
*/
/*---------------------------------------------------------------------------*/
void odroid_misc_init(void)
{
	/* Default LDO value setup */
	odroid_pmic_init();
	odroid_gpio_init();
	odroid_led_init();

	/* check Android Image update or fastboot Magic command */
	odroid_magic_cmd_check();
}

/*---------------------------------------------------------------------------*/
void odroid_misc_deinit(void)
{
	odroid_led_deinit();
	odroid_gpio_deinit();
	odroid_pmic_deinit();
}

/*---------------------------------------------------------------------------*/
void odroid_power_off(void)
{
	struct exynos5_power *power =
		(struct exynos5_power *)samsung_get_base_power();

	printf("%s\n", __func__);
	odroid_misc_deinit();

	power->ps_hold_control = 0x5200;
}

/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/
