#ifndef __CONFIG_ODROIDC_H__
#define __CONFIG_ODROIDC_H__

#define CONFIG_MACH_MESON8_ODROIDC      // generate M8 ODROID-C machid number

#define CONFIG_SYS_LOAD_ADDR		0x12000000

//#define CONFIG_SECURITYKEY            /* Disabled for ODROID_C */

//#define TEST_UBOOT_BOOT_SPEND_TIME

// cart type of each port
#define PORT_A_CARD_TYPE                CARD_TYPE_UNKNOWN
#define PORT_B_CARD_TYPE                CARD_TYPE_UNKNOWN
#define PORT_C_CARD_TYPE                CARD_TYPE_MMC // CARD_TYPE_MMC/CARD_TYPE_SD

//UART Sectoion
#define CONFIG_CONS_INDEX               2
#define CONFIG_IR_REMOTE_WAKEUP         1
//support "boot,bootd"
//#define CONFIG_CMD_BOOTD              1

//Enable HDMI Tx
//#define CONFIG_VIDEO_AMLTVOUT         1
//Enable LCD output
//#define CONFIG_VIDEO_AMLLCD
#define LCD_BPP                         LCD_COLOR24

#define CONFIG_ACS
#ifdef CONFIG_ACS
#define CONFIG_DDR_SIZE_IND_ADDR        0xd9000000      /* pass memory size, spl->uboot */
#endif

#define CONFIG_CMD_PWM                  1

// Enable storage devices
#define CONFIG_VIDEO_AML                1
#define CONFIG_CMD_BMP                  1
#define CONFIG_VIDEO_AMLTVOUT           1
#define CONFIG_AML_HDMI_TX              1
#define CONFIG_OSD_SCALE_ENABLE         1

// Enable storage devices
#define CONFIG_CMD_SF                   1
#if defined(CONFIG_CMD_SF)
        #define SPI_WRITE_PROTECT       1
        #define CONFIG_CMD_MEMORY       1
#endif /*CONFIG_CMD_SF*/

//#define CONFIG_MACHID_CHECK           1
#define CONFIG_CMD_SUSPEND              1
//#define CONFIG_IR_REMOTE              1
#define CONFIG_IR_REMOTE                1
#define CONFIG_L2_OFF                   1

#define CONFIG_CMD_NET                  1
#if defined(CONFIG_CMD_NET)
        #define CONFIG_AML_ETHERNET     1
        #define RGMII_PHY_INTERFACE     1
        #define CONFIG_NET_MULTI        1
        #define CONFIG_CMD_PING         1
        #define CONFIG_CMD_DHCP         1
        #define CONFIG_CMD_RARP         1
        //#define CONFIG_NET_RGMII
        //#define CONFIG_NET_RMII_CLK_EXTERNAL //use external 50MHz clock source
        #define CONFIG_AML_ETHERNET     1               /* to link /driver/net/aml_ethernet.c */
        #define CONFIG_HOSTNAME         arm_m8
        #define CONFIG_ETHADDR          00:15:18:01:81:31       /* Ethernet address */
        #define CONFIG_IPADDR           10.18.9.97              /* Our ip address */
        #define CONFIG_GATEWAYIP        10.18.9.1               /* Our getway ip address */
        #define CONFIG_SERVERIP         10.18.9.113             /* Tftp server ip address */
        #define CONFIG_NETMASK          255.255.255.0
#endif /* (CONFIG_CMD_NET) */

#define CONFIG_SDIO_B1                  1
#define CONFIG_SDIO_A                   1
#define CONFIG_SDIO_B                   1
#define CONFIG_SDIO_C                   1
#define CONFIG_ENABLE_EXT_DEVICE_RETRY  1

#define CONFIG_MMU                      1
#define CONFIG_PAGE_OFFSET              0xc0000000
#define CONFIG_SYS_LONGHELP             1

/* USB
 * Enable CONFIG_MUSB_HCD for Host functionalities MSC, keyboard
 * Enable CONFIG_MUSB_UDD for Device functionalities.
 */
/* #define CONFIG_MUSB_UDC              1 */
#define CONFIG_CMD_USB                  1

#if defined(CONFIG_CMD_USB)
#define CONFIG_M8_USBPORT_BASE_A        0xC9040000
#define CONFIG_M8_USBPORT_BASE_B        0xC90C0000
#define CONFIG_USB_STORAGE              1
#define CONFIG_USB_DWC_OTG_HCD          1
#define CONFIG_USB_DWC_OTG_294          1
#endif /* CONFIG_CMD_USB */

#define CONFIG_ENABLE_CVBS              1

#define CONFIG_UCL                      1
#define CONFIG_SELF_COMPRESS

#define CONFIG_CMD_AUTOSCRIPT

#define CONFIG_CMD_REBOOT               1

#define CONFIG_AML_GATE_INIT            1

/* Environment information */
#define CONFIG_BOOTDELAY                1
#define CONFIG_BOOTFILE                 boot.img
#define CONFIG_DEFAULT_ROOT             /dev/mmcblk0p2
#define CONFIG_CONSOLE_PROTOCOL         "ttyS0,115200n8"

#define XMK_STR(x)      #x
#define MK_STR(x)       XMK_STR(x)

#ifdef CONFIG_ODROIDC_REV2
#define CONFIG_EXTRA_ENV_SETTINGS \
        "boardname=ODROIDC\0" \
        "cecconfig=cec0xf\0"  \
        "bootargs=root=" MK_STR(CONFIG_DEFAULT_ROOT) " rw " \
                "console=" CONFIG_CONSOLE_PROTOCOL " no_console_suspend\0" \
        "bootcmd="\
                "cfgload;" \
                "setenv bootargs root=" MK_STR(CONFIG_DEFAULT_ROOT) " rw " \
                        "console=" CONFIG_CONSOLE_PROTOCOL " no_console_suspend " \
                        "vdaccfg=${vdac_config} " \
                        "logo=osd1,loaded,${fb_addr},${outputmode},full " \
                        "hdmimode=${hdmimode} " \
                        "cvbsmode=${cvbsmode} " \
                        "hdmitx=${cecconfig} " \
                        "androidboot.selinux=disabled " \
                        "androidboot.serialno=${fbt_id#}; " \
                "movi read boot 0 0x12000000;" \
                "movi read dtb 0 0x12800000;" \
                "bootm 0x12000000 - 0x12800000\0" \
        "bootm_low=0x00000000\0" \
        "bootm_size=0x80000000\0" \
        "bootpath=u-boot.bin\0" \
        "bootsize=100000\0" \
        "bootstart=0\0" \
        "chipname=8726m8\0" \
        "console=" CONFIG_CONSOLE_PROTOCOL "\0" \
        "cvbsmode=480cvbs\0" \
        "display_bpp=24\0" \
        "display_color_bg=0\0" \
        "display_color_fg=0xffff\0" \
        "display_color_format_index=24\0" \
        "display_width=1920\0" \
        "display_height=1080\0" \
        "display_layer=osd2\0" \
        "fb_addr=0x7900000\0" \
        "fb_width=1280\0"\
        "fb_height=720\0"\
        "firstboot=1\0" \
        "outputmode=1080p\0" \
        "hdmimode=1080p\0" \
        "initrd_high=60000000\0" \
        "loadaddr=" MK_STR(CONFIG_SYS_LOAD_ADDR) "\0" \
        "loadaddr_logo=0x14000000\0" \
        "preloadlogo=logo size ${outputmode}; video open;" \
                "video clear; video dev open ${outputmode};" \
                "movi read logo 0 ${loadaddr_logo};" \
                "bmp display ${loadaddr_logo}; bmp scale\0" \
        "vdac_config=0x10\0" \
        "video_dev=tvout\0"
#else
#define CONFIG_EXTRA_ENV_SETTINGS \
        "boardname=ODROIDC\0" \
        "bootargs=root=" MK_STR(CONFIG_DEFAULT_ROOT) " rw " \
                "console=" CONFIG_CONSOLE_PROTOCOL " no_console_suspend\0" \
        "bootcmd="\
                "cfgload;" \
                "setenv bootargs root=" MK_STR(CONFIG_DEFAULT_ROOT) " rw " \
                        "console=" CONFIG_CONSOLE_PROTOCOL " no_console_suspend " \
                        "vdaccfg=${vdac_config} " \
                        "logo=osd1,loaded,${fb_addr},${outputmode},full " \
                        "hdmimode=${hdmimode} " \
                        "cvbsmode=${cvbsmode} " \
                        "hdmitx=${cecconfig} " \
                        "androidboot.serialno=${fbt_id#}; " \
                "movi read boot 0 0x12000000;" \
                "movi read dtb 0 0x12800000;" \
                "bootm 0x12000000 - 0x12800000\0" \
        "bootm_low=0x00000000\0" \
        "bootm_size=0x80000000\0" \
        "bootpath=u-boot.bin\0" \
        "bootsize=100000\0" \
        "bootstart=0\0" \
        "chipname=8726m8\0" \
        "console=" CONFIG_CONSOLE_PROTOCOL "\0" \
        "cvbsmode=480cvbs\0" \
        "display_bpp=24\0" \
        "display_color_bg=0\0" \
        "display_color_fg=0xffff\0" \
        "display_color_format_index=24\0" \
        "display_width=1920\0" \
        "display_height=1080\0" \
        "display_layer=osd2\0" \
        "fb_addr=0x7900000\0" \
        "fb_width=1280\0"\
        "fb_height=720\0"\
        "firstboot=1\0" \
        "outputmode=720p\0" \
        "hdmimode=720p\0" \
        "initrd_high=60000000\0" \
        "loadaddr=" MK_STR(CONFIG_SYS_LOAD_ADDR) "\0" \
        "loadaddr_logo=0x14000000\0" \
        "preloadlogo=logo size ${outputmode}; video open;" \
                "video clear; video dev open ${outputmode};" \
                "movi read logo 0 ${loadaddr_logo};" \
                "bmp display ${loadaddr_logo}; bmp scale\0" \
        "vdac_config=0x10\0" \
        "video_dev=tvout\0"
#endif

#define CONFIG_BOOTCOMMAND              "bootm"

#define CONFIG_AUTO_COMPLETE            1

#ifdef CONFIG_ODROIDC_REV2
#define CONFIG_ENV_SIZE                 (32 * 1024)     // unit: bytes
#define CONFIG_ENV_OFFSET               (720 * 1024)    // unit: bytes
#else
#define CONFIG_ENV_SIZE                 (32 * 1024)     // unit: bytes
#define CONFIG_ENV_OFFSET               (512 * 1024)    // unit: bytes
#endif

#define CONFIG_MMC_BOOT

#if defined CONFIG_MMC_BOOT
#define CONFIG_ENV_IS_IN_MMC
#define CONFIG_CMD_SAVEENV
#define CONFIG_SYS_MMC_ENV_DEV          0
#else
#define CONFIG_ENV_IS_NOWHERE           1
#endif

//-----------------------------------------------------------------------
// DDR setting
// For DDR PUB training not check the VT done flag
#define CONFIG_NO_DDR_PUB_VT_CHECK      1

//For M8 DDR clock gating disable
//#define CONFIG_GATEACDDRCLK_DISABLE   1

//For M8 DDR low power feature disable
//#define CONFIG_DDR_LOW_POWER_DISABLE 1

//For M8 DDR PUB WL/WD/RD/RG-LVT, WD/RD-BVT disable
//#define CONFIG_PUB_WLWDRDRGLVTWDRDBVT_DISABLE 1

//Please just define m8 DDR clock here only
//current DDR clock range (408~804)MHz with fixed step 12MHz
#define CFG_DDR_CLK                     636 //696 //768  //792// (636)
#define CFG_DDR_MODE                    CFG_DDR_32BIT

#ifdef CONFIG_ACS
//#define CONFIG_DDR_MODE_AUTO_DETECT   //ddr bus-width auto detection
#endif

//On board DDR capactiy
#if !(defined(CONFIG_DDR3_512MB) || defined(CONFIG_DDR3_1GB) \
        || defined(CONFIG_DDR3_2GB))
        #error "Please set DDR capacity first!\n"
#endif

#define CONFIG_ENABLE_WRITE_LEVELING    1

#define CONFIG_AML_EXT_PGM_SILENT	1

//DDR row/col size
//row size.  2'b01 : A0~A12.   2'b10 : A0~A13.  2'b11 : A0~A14.  2'b00 : A0~A15.
//col size.   2'b01 : A0~A8,      2'b10 : A0~A9  
#define PHYS_MEMORY_START               0x00000000      // ???
#if   defined(CONFIG_DDR3_512MB)
        #define CONFIG_DDR3_ROW_SIZE    2
        #define CONFIG_DDR3_COL_SIZE    2
        #define CONFIG_DDR_ROW_BITS     14
        #define PHYS_MEMORY_SIZE        0x20000000      // 512MB
#elif defined(CONFIG_DDR3_1GB)
        //2Gb(X16) x 4pcs
        #define CONFIG_DDR3_ROW_SIZE    3
        #define CONFIG_DDR3_COL_SIZE    2
        #define CONFIG_DDR_ROW_BITS     15
        #define PHYS_MEMORY_SIZE        0x40000000      // 1GB
#elif defined(CONFIG_DDR3_2GB)
        //4Gb(X16) x 4pcs
        #define CONFIG_DDR3_ROW_SIZE    3
        #define CONFIG_DDR3_COL_SIZE    2
        #define CONFIG_DDR_ROW_BITS     15
        #define PHYS_MEMORY_SIZE        0x80000000      // 2GB
#endif

#define CONFIG_SYS_MEMTEST_START        0x10000000      /* memtest works on */
#define CONFIG_SYS_MEMTEST_END          0x18000000      /* 0 ... 128 MB in DRAM */
#define CONFIG_ENABLE_MEM_DEVICE_TEST   1
#define CONFIG_NR_DRAM_BANKS            1               /* CS1 may or may not be populated */

/* Cache line size */
#define CONFIG_SYS_CACHELINE_SIZE	64

/* Pass open firmware flat tree*/
#define CONFIG_OF_LIBFDT                1
#define CONFIG_SYS_BOOTMAPSZ            PHYS_MEMORY_SIZE        /* Initial Memory map for Linux */
#define CONFIG_ANDROID_IMG              1

#define CONFIG_CMD_IMGPACK              1

//M8 security boot
//#define CONFIG_SECU_BOOT              1

//M8 L1 cache enable for uboot decompress speed up
#define CONFIG_AML_SPL_L1_CACHE_ON      1

//To use RSA2048 key aml-rsa-key.k2a
#define CONFIG_AML_RSA_2048             1


/*-----------------------------------------------------------------------
 * power down
 */
//#define CONFIG_CMD_RUNARC 1 /* runarc */
#define CONFIG_AML_SUSPEND              1

#define CONFIG_CMD_LOGO
#define CONFIG_LOGO_PRELOAD             1

#define CONFIG_BOARD_EARLY_INIT_F       1
#define BOARD_LATE_INIT

#define CONFIG_CMD_FASTBOOT             /* Support 'fastboot' command */
#define CONFIG_CMD_USB_MASS_STORAGE     /* Support 'ums' command */

/* FASTBOOT */
#ifdef CONFIG_CMD_FASTBOOT
#define CONFIG_FASTBOOT
#define CONFIG_USB_GADGET
#define CONFIG_USBDOWNLOAD_GADGET

#define FASTBOOT_BLKDEV                 "mmc0"

#ifndef CONFIG_DOS_PARTITION
#define CONFIG_DOS_PARTITION
#endif

#define CONFIG_MAX_PARTITION_NUM        20      // Max partitions for fastboot

#define CONFIG_CUSTOM_MBR_LBA           (512 * 1024 / 512)

#ifdef CONFIG_ODROIDC_REV2
#define BOARD_CACHEIMAGE_PARTITION_SIZE		512
#define BOARD_SYSTEMIMAGE_PARTITION_SIZE	1024
#define BOARD_STORAGE_PARTITION_SIZE		128
#else
#define BOARD_SYSTEMIMAGE_PARTITION_SIZE        1024            // 1GB
#define BOARD_USERDATAIMAGE_PARTITION_SIZE      (3 * 1024)      // 3GB
#define BOARD_CACHEIMAGE_PARTITION_SIZE         512             // 512MB
#endif

#define CONFIG_ENV_BLK_PARTITION        "environment"

#define CONFIG_FASTBOOT_TRANSFER_BUFFER         CONFIG_SYS_LOAD_ADDR
#define CONFIG_FASTBOOT_TRANSFER_BUFFER_SIZE    SZ_512M
#define FASTBOOT_REBOOT_PARAMETER_ADDR  \
        (CONFIG_FASTBOOT_TRANSFER_BUFFER +CONFIG_FASTBOOT_TRANSFER_BUFFER_SIZE)
#endif /* CONFIG_CMD_FASTBOOT */

#define CONFIG_CMD_INI                  1       /* Support 'ini' command */

/* USB Mass Storage */
#ifdef CONFIG_CMD_USB_MASS_STORAGE
#define CONFIG_USB_GADGET_MASS_STORAGE  1
#define CONFIG_USB_GADGET
#endif

/* USB Gadget */
#ifdef CONFIG_USB_GADGET
#define CONFIG_USB_GADGET_DUALSPEED
#define CONFIG_USB_GADGET_S3C_UDC_OTG
#define CONFIG_USB_GADGET_VBUS_DRAW     0

#define CONFIG_G_DNL_VENDOR_NUM         0x18d1
#define CONFIG_G_DNL_PRODUCT_NUM        0x0002
#define CONFIG_G_DNL_MANUFACTURER       "Hardkernel Co., Ltd"
#endif /* CONFIG_USB_GADGET */

/* FDISK command */
#define CONFIG_MMC_FDISK
#ifdef CONFIG_ODROIDC_REV2
#define CFG_PARTITION_START             (32 * 1024 * 1024)
#else
#define CFG_PARTITION_START             (24 * 1024 * 1024)
#endif

/* Linux reboot command - include/uapi/linux/reboot.h */
#define LINUX_REBOOT_CMD_POWER_OFF      0x4321FEDC
#define LINUX_REBOOT_CMD_RESTART2       0xA1B2C3D4
#define LINUX_REBOOT_CMD_KEXEC          0x45584543
#define LINUX_REBOOT_CMD_RECOVERY       LINUX_REBOOT_CMD_KEXEC
#define LINUX_REBOOT_CMD_FASTBOOT       LINUX_REBOOT_CMD_RESTART2

#define CONFIG_ENV_OVERWRITE

/* File system support */
#define CONFIG_CMD_EXT4

#define CONFIG_CMD_I2C

#ifdef CONFIG_CMD_I2C
#undef	CONFIG_HARD_I2C			/* I2C with hardware support	*/
#define CONFIG_SOFT_I2C			/* I2C bit-banged		*/
#define CONFIG_SYS_I2C_SPEED		50000	/* 50kHz is supported to work */
#define CONFIG_SYS_I2C_SLAVE		0x50

#ifdef CONFIG_SOFT_I2C
/*
 * Software (bit-bang) I2C driver configuration
 */
#define HDMI_SDA	GPIOH_1
#define HDMI_SCL	GPIOH_2

#define I2C_INIT	\
	do { \
		amlogic_gpio_direction_output(HDMI_SCL, 1); \
		amlogic_gpio_direction_output(HDMI_SDA, 1); \
	} while (0)

#define I2C_ACTIVE \
	do { \
	} while (0)

#define I2C_TRISTATE \
	do { \
		amlogic_gpio_direction_input(HDMI_SDA); \
	} while (0)

#define I2C_READ	amlogic_get_value(HDMI_SDA)
#define I2C_SDA(bit) \
	do { \
		if (bit) \
			amlogic_gpio_direction_input(HDMI_SDA); \
		else \
			amlogic_gpio_direction_output(HDMI_SDA, 0); \
	} while (0)
#define I2C_SCL(bit) \
	do { \
		amlogic_gpio_direction_output(HDMI_SCL, bit); \
	} while (0)
#define I2C_DELAY	udelay(5)
#endif
#endif

#define CONFIG_I2C_EDID

#if defined(CONFIG_LOGO_PRELOAD)
#define CONFIG_VIDEO_BMP_GZIP		1
#define CONFIG_SYS_VIDEO_LOGO_MAX_SIZE	(6 << 20) /* Fixed for 1080p gzipped bmp */
#endif /* CONFIG_LOGO_PRELOAD */

#endif //__CONFIG_ODROIDC_H__
