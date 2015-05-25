
/*
 * drivers/usb/gadget/aml_tiny_usbtool/platform.h
 *
 * Copyright (C) 2015 Amlogic, Inc. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

#ifndef __PLATFORM_H__
#define __PLATFORM_H__

//#include "romboot.h"
//Elvis Fool
//#pragma Offwarn(88)  /* disable "Expression has no side-effects" print debug info*/

#if 0

/* ISO C Standard Definitions */
typedef char               int8_t;
typedef	short int          int16_t;
typedef	int                int32_t;
typedef	long               int64_t;
typedef	unsigned char      uint8_t;
typedef	unsigned short int uint16_t;
typedef	unsigned int       uint32_t;
typedef	unsigned long      uint64_t;

typedef unsigned   char    u8_t;
typedef signed     char    s8_t;
typedef unsigned   short   u16_t;
typedef signed     short   s16_t;
typedef unsigned   int     u32_t;
typedef signed     int     s32_t;
typedef unsigned   long    u64_t;
typedef signed     long    s64_t;

/* Linux definitions */
typedef u8_t     __u8;
typedef s8_t     __s8;
typedef u16_t    __u16;
typedef s16_t    __s16;
typedef u32_t    __u32;
typedef s32_t    __s32;
typedef u64_t    __u64;
typedef s64_t    __s64;

typedef u8_t     u_int8_t;
typedef u16_t    u_int16_t;
typedef u32_t    u_int32_t;
typedef u64_t    u_int64_t;

typedef s8_t     s8;
typedef u8_t     u8;
typedef s16_t    s16;
typedef u16_t    u16;
typedef s32_t    s32;
typedef u32_t    u32;
typedef u64_t    u64;

typedef __u16    __le16;
typedef __u16    __be16;
typedef __u32    __le32;
typedef __u32    __be32;
typedef __u64    __le64;
typedef __u64    __be64;
#endif

/* A3,CS2,M3 chip, PORT_A is OTG, work as ROM Boot port */
#ifdef __USE_PORT_B
#define PORT_REG_OFFSET   0x80000
#else
#define PORT_REG_OFFSET   0
#endif


/*M3*/
#define DWC_REG_BASE  (0xC9000000 + PORT_REG_OFFSET)
#define PERI_BASE_ADDR               0xc1100000
#define ISABASE                      0x01000000

#define PREI_USB_PHY_REG              0xc0000000 //0xC1108400

#define PREI_USB_PHY_A_REG3           0xc0000000
#define PREI_USB_PHY_B_REG4           0xc0000020

#define PREI_USB_PHY_A_POR      (1 << 0)
#define PREI_USB_PHY_B_POR      (1 << 1)
#define PREI_USB_PHY_CLK_SEL    (7 << 5) // changed from A1H
#define PREI_USB_PHY_CLK_GATE 	(1 << 8)
#define PREI_USB_PHY_B_AHB_RSET     (1 << 11)
#define PREI_USB_PHY_B_CLK_RSET     (1 << 12)
#define PREI_USB_PHY_B_PLL_RSET     (1 << 13)
#define PREI_USB_PHY_A_AHB_RSET     (1 << 17)
#define PREI_USB_PHY_A_CLK_RSET     (1 << 18)
#define PREI_USB_PHY_A_PLL_RSET     (1 << 19)
#define PREI_USB_PHY_A_DRV_VBUS     (1 << 20)
#define PREI_USB_PHY_B_DRV_VBUS			(1 << 21)
#define PREI_USB_PHY_B_CLK_DETECT   (1 << 22)
#define PREI_USB_PHY_CLK_DIV        (0x7f << 24)
#define PREI_USB_PHY_A_CLK_DETECT   (1 << 31)

#define PREI_USB_PHY_A_REG3_IDDIG_OVR	(1 << 23)
#define PREI_USB_PHY_A_REG3_IDDIG_VAL	(1 << 24)

#define PREI_USB_PHY_B_REG4_IDDIG_OVR	(1 << 23)
#define PREI_USB_PHY_B_REG4_IDDIG_VAL	(1 << 24)



/***********************************************/
#define WRITE_PERI_REG(reg, val) *(volatile unsigned *)(PERI_BASE_ADDR + ((reg)<<2)) = (val)
#define READ_PERI_REG(reg) (*(volatile unsigned *)(PERI_BASE_ADDR + ((reg)<<2)))

#define CLEAR_PERIPHS_REG_BITS(reg, mask) WRITE_PERI_REG(reg, (READ_PERI_REG(reg)&(~(mask))))
#define SET_PERIPHS_REG_BITS(reg, mask)   WRITE_PERI_REG(reg, (READ_PERI_REG(reg)|(mask)))

#define WRITE_ISA_REG(reg, val) *(volatile unsigned *)(ISABASE + (reg)) = (val)
#define READ_ISA_REG(reg) (*(volatile unsigned *)(ISABASE + (reg)))

#define CLEAR_ISA_REG_MASK(reg, mask) WRITE_ISA_REG(reg, (READ_ISA_REG(reg)&(~mask)))
#define SET_ISA_REG_MASK(reg, mask)   WRITE_ISA_REG(reg, (READ_ISA_REG(reg)|(mask)))
/***********************************************/





#define IREG_TIMER_E_COUNT            0x2655


#define flush_cpu_cache()


#define dwc_write_reg32(x, v) 	(*(volatile uint32_t *)(unsigned long long)(x + DWC_REG_BASE))=v
#define dwc_read_reg32(x) (*(volatile uint32_t*)(unsigned long long)(x + DWC_REG_BASE))
// void dwc_modify_reg32( volatile uint32_t *_reg, const uint32_t _clear_mask, const uint32_t _set_mask)
#define dwc_modify_reg32(x, c, s) 	(*(volatile uint32_t *)(unsigned long long)(x + DWC_REG_BASE))=( ((dwc_read_reg32(x)) & (~c)) | (s))

//#define __constant_cpu_to_le16(x) (x)
//#define __constant_cpu_to_le32(x) (x)
//#define cpu_to_le16(x)      (x)
//#define  cpu_to_le32(x)     (x)
//#define le16_to_cpu(x)      (x)
//#define le32_to_cpu(x)      (x)
#define get_unaligned_16(ptr)				(((__u8 *)ptr)[0] | (((__u8 *)ptr)[1]<<8))
#define get_unaligned_32(ptr)				(((__u8 *)ptr)[0] | (((__u8 *)ptr)[1]<<8) | (((__u8 *)ptr)[2]<<16) | (((__u8 *)ptr)[3]<<24))
#define get_unaligned(ptr)				(((__u8 *)ptr)[0] | (((__u8 *)ptr)[1]<<8) | (((__u8 *)ptr)[2]<<16) | (((__u8 *)ptr)[3]<<24))

#ifndef max
#define max(a, b)	(((a) > (b))? (a): (b))
#endif
#ifndef min
#define min(a, b)	(((a) < (b))? (a): (b))
#endif

#define EXT_CLOCK	0
#define INT_CLOCK	1


// 32 bit TimerE, 1us
#define USB_ROM_CONN_TIMEOUT		5*1000*1000  //us (5s timeout,)


/* Meet with spec */
#define USB_ROM_VER_MAJOR	0
#define USB_ROM_STAGE_MAJOR	0
#define USB_ROM_STAGE_MINOR	16		// IPL = 0,	SPL = 8, TPL = 16

#ifdef CONFIG_M6
#define USB_ROM_VER_MINOR	8				// SPEC Version
#else
#define USB_ROM_VER_MINOR	7				// SPEC Version
#endif

#if 1
#define PRINTF(x...)	do{}while(0)
#else
#define PRINTF(x...) printf(x)
#endif

#define ERR(x...) PRINTF(x)
#define DBG(x...) PRINTF(x)
#define USB_ERR(x...)	PRINTF(x)
#define USB_DBG(x...) PRINTF(x)


static void set_usb_phy_config(int cfg);
void usb_parameter_init(int time_out);
int chip_utimer_set(int val);
int chip_watchdog(void);
//#define udelay __udelay
//#define wait_ms(a) _udelay(a*1000);
int update_utime(void);
int get_utime(void);
//int chip_watchdog(void);
//#define usb_memcpy(dst,src,len) rom_memcpy((unsigned)src,(unsigned)dst,(unsigned)len)
//#define usb_memcpy_32bits(dst,src,len) rom_memcpy((unsigned)src,(unsigned)dst,(unsigned)len)

#endif
