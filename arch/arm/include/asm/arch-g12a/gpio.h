
/*
 * arch/arm/include/asm/arch-txl/gpio.h
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

#ifndef __ARCH_GPIO_H_
#define __ARCH_GPIO_H_
/*AO Bank*/
#define	GPIOAO_0    0
#define	GPIOAO_1    1
#define	GPIOAO_2    2
#define	GPIOAO_3    3
#define	GPIOAO_4    4
#define	GPIOAO_5    5
#define	GPIOAO_6    6
#define	GPIOAO_7    7
#define	GPIOAO_8    8
#define	GPIOAO_9    9
#define	GPIOAO_10   10
#define	GPIOAO_11   11
#define	GPIOAO_12   12
#define	GPIOAO_13   13

/*EE Bank*/
#define	GPIOZ_0    0
#define	GPIOZ_1    1
#define	GPIOZ_2    2
#define	GPIOZ_3    3
#define	GPIOZ_4    4
#define	GPIOZ_5    5
#define	GPIOZ_6    6
#define	GPIOZ_7    7
#define	GPIOZ_8    8
#define	GPIOZ_9    9
#define	GPIOZ_10    10
#define	GPIOZ_11    11
#define	GPIOZ_12    12
#define	GPIOZ_13    13
#define	GPIOZ_14    14
#define	GPIOZ_15    15
#define	GPIOZ_16    16
#define	GPIOZ_17    17
#define	GPIOZ_18    18
#define	GPIOZ_19    19

#define	GPIOH_0    20
#define	GPIOH_1    21
#define	GPIOH_2    22
#define	GPIOH_3    23
#define	GPIOH_4    24
#define	GPIOH_5    25
#define	GPIOH_6    26
#define	GPIOH_7    27
#define	GPIOH_8    28
#define	GPIOH_9    29
#define	GPIOH_10   30

#define	BOOT_0    31
#define	BOOT_1    32
#define	BOOT_2    33
#define	BOOT_3    34
#define	BOOT_4    35
#define	BOOT_5    36
#define	BOOT_6    37
#define	BOOT_7    38
#define	BOOT_8    39
#define	BOOT_9    40
#define	BOOT_10   41
#define	BOOT_11   42

#define	GPIOC_0    43
#define	GPIOC_1    44
#define	GPIOC_2    45
#define	GPIOC_3    46
#define	GPIOC_4    47
#define	GPIOC_5    48

#define	GPIODV_0    49
#define	GPIODV_1    50
#define	GPIODV_2    51
#define	GPIODV_3    52
#define	GPIODV_4    53
#define	GPIODV_5    54
#define	GPIODV_6    55
#define	GPIODV_7    56
#define	GPIODV_8    57
#define	GPIODV_9    58
#define	GPIODV_10   59

#define	GPIOW_0    60
#define	GPIOW_1    61
#define	GPIOW_2    62
#define	GPIOW_3    63
#define	GPIOW_4    64
#define	GPIOW_5    65
#define	GPIOW_6    66
#define	GPIOW_7    67
#define	GPIOW_8    68
#define	GPIOW_9    69
#define	GPIOW_10   70
#define	GPIOW_11   71
#define	GPIOW_12   72
#define	GPIOW_13   73
#define	GPIOW_14   74
#define	GPIOW_15   75

#define	GPIOY_0		76
#define	GPIOY_1		77
#define	GPIOY_2		78
#define	GPIOY_3		79
#define	GPIOY_4		80
#define	GPIOY_5		81
#define	GPIOY_6		82
#define	GPIOY_7		83
#define	GPIOY_8		84
#define	GPIOY_9		85
#define	GPIOY_10	86
#define	GPIOY_11	87
#define	GPIOY_12	88
#define	GPIOY_13	89
#define	GPIOY_14	90
#define	GPIOY_15	91
#define	GPIOY_16	92
#define	GPIOY_17	93
#define	GPIOY_18	94
#define	GPIOY_19	95
#define	GPIOY_20	96
#define	GPIOY_21	97
#define	GPIOY_22	98
#define	GPIOY_23	99
#define	GPIOY_24	100
#define	GPIOY_25	101
#define	GPIOY_26	102
#define	GPIOY_27	103

#define	GPIO_TEST_N		104

#define EE_OFFSET 14

#define	PIN_GPIOZ_0    (EE_OFFSET + GPIOZ_0)
#define	PIN_GPIOZ_1    (EE_OFFSET + GPIOZ_1)
#define	PIN_GPIOZ_2    (EE_OFFSET + GPIOZ_2)
#define	PIN_GPIOZ_3    (EE_OFFSET + GPIOZ_3)
#define	PIN_GPIOZ_4    (EE_OFFSET + GPIOZ_4)
#define	PIN_GPIOZ_5    (EE_OFFSET + GPIOZ_5)
#define	PIN_GPIOZ_6    (EE_OFFSET + GPIOZ_6)
#define	PIN_GPIOZ_7    (EE_OFFSET + GPIOZ_7)
#define	PIN_GPIOZ_8    (EE_OFFSET + GPIOZ_8)
#define	PIN_GPIOZ_9    (EE_OFFSET + GPIOZ_9)
#define	PIN_GPIOZ_10    (EE_OFFSET + GPIOZ_10)
#define	PIN_GPIOZ_11    (EE_OFFSET + GPIOZ_11)
#define	PIN_GPIOZ_12    (EE_OFFSET + GPIOZ_12)
#define	PIN_GPIOZ_13    (EE_OFFSET + GPIOZ_13)
#define	PIN_GPIOZ_14    (EE_OFFSET + GPIOZ_14)
#define	PIN_GPIOZ_15    (EE_OFFSET + GPIOZ_15)
#define	PIN_GPIOZ_16    (EE_OFFSET + GPIOZ_16)
#define	PIN_GPIOZ_17    (EE_OFFSET + GPIOZ_17)
#define	PIN_GPIOZ_18    (EE_OFFSET + GPIOZ_18)
#define	PIN_GPIOZ_19    (EE_OFFSET + GPIOZ_19)

#define	PIN_GPIOH_0    (EE_OFFSET + GPIOH_0)
#define	PIN_GPIOH_1    (EE_OFFSET + GPIOH_1)
#define	PIN_GPIOH_2    (EE_OFFSET + GPIOH_2)
#define	PIN_GPIOH_3    (EE_OFFSET + GPIOH_3)
#define	PIN_GPIOH_4    (EE_OFFSET + GPIOH_4)
#define	PIN_GPIOH_5    (EE_OFFSET + GPIOH_5)
#define	PIN_GPIOH_6    (EE_OFFSET + GPIOH_6)
#define	PIN_GPIOH_7    (EE_OFFSET + GPIOH_7)
#define	PIN_GPIOH_8    (EE_OFFSET + GPIOH_8)
#define	PIN_GPIOH_9    (EE_OFFSET + GPIOH_9)
#define	PIN_GPIOH_10    (EE_OFFSET + GPIOH_10)

#define	PIN_BOOT_0    (EE_OFFSET + BOOT_0)
#define	PIN_BOOT_1    (EE_OFFSET + BOOT_1)
#define	PIN_BOOT_2    (EE_OFFSET + BOOT_2)
#define	PIN_BOOT_3    (EE_OFFSET + BOOT_3)
#define	PIN_BOOT_4    (EE_OFFSET + BOOT_4)
#define	PIN_BOOT_5    (EE_OFFSET + BOOT_5)
#define	PIN_BOOT_6    (EE_OFFSET + BOOT_6)
#define	PIN_BOOT_7    (EE_OFFSET + BOOT_7)
#define	PIN_BOOT_8    (EE_OFFSET + BOOT_8)
#define	PIN_BOOT_9    (EE_OFFSET + BOOT_9)
#define	PIN_BOOT_10    (EE_OFFSET + BOOT_10)
#define	PIN_BOOT_11    (EE_OFFSET + BOOT_11)

#define	PIN_GPIOC_0    (EE_OFFSET + GPIOC_0)
#define	PIN_GPIOC_1    (EE_OFFSET + GPIOC_1)
#define	PIN_GPIOC_2    (EE_OFFSET + GPIOC_2)
#define	PIN_GPIOC_3    (EE_OFFSET + GPIOC_3)
#define	PIN_GPIOC_4    (EE_OFFSET + GPIOC_4)
#define	PIN_GPIOC_5    (EE_OFFSET + GPIOC_5)

#define	PIN_GPIODV_0    (EE_OFFSET + GPIODV_0)
#define	PIN_GPIODV_1    (EE_OFFSET + GPIODV_1)
#define	PIN_GPIODV_2    (EE_OFFSET + GPIODV_2)
#define	PIN_GPIODV_3    (EE_OFFSET + GPIODV_3)
#define	PIN_GPIODV_4    (EE_OFFSET + GPIODV_4)
#define	PIN_GPIODV_5    (EE_OFFSET + GPIODV_5)
#define	PIN_GPIODV_6    (EE_OFFSET + GPIODV_6)
#define	PIN_GPIODV_7    (EE_OFFSET + GPIODV_7)
#define	PIN_GPIODV_8    (EE_OFFSET + GPIODV_8)
#define	PIN_GPIODV_9    (EE_OFFSET + GPIODV_9)
#define	PIN_GPIODV_10    (EE_OFFSET + GPIODV_10)

#define	PIN_GPIOW_0    (EE_OFFSET + GPIOW_0)
#define	PIN_GPIOW_1    (EE_OFFSET + GPIOW_1)
#define	PIN_GPIOW_2    (EE_OFFSET + GPIOW_2)
#define	PIN_GPIOW_3    (EE_OFFSET + GPIOW_3)
#define	PIN_GPIOW_4    (EE_OFFSET + GPIOW_4)
#define	PIN_GPIOW_5    (EE_OFFSET + GPIOW_5)
#define	PIN_GPIOW_6    (EE_OFFSET + GPIOW_6)
#define	PIN_GPIOW_7    (EE_OFFSET + GPIOW_7)
#define	PIN_GPIOW_8    (EE_OFFSET + GPIOW_8)
#define	PIN_GPIOW_9    (EE_OFFSET + GPIOW_9)
#define	PIN_GPIOW_10   (EE_OFFSET + GPIOW_10)
#define	PIN_GPIOW_11   (EE_OFFSET + GPIOW_11)
#define	PIN_GPIOW_12   (EE_OFFSET + GPIOW_12)
#define	PIN_GPIOW_13   (EE_OFFSET + GPIOW_13)
#define	PIN_GPIOW_14   (EE_OFFSET + GPIOW_14)
#define	PIN_GPIOW_15   (EE_OFFSET + GPIOW_15)

#define	PIN_GPIOY_0		(EE_OFFSET + GPIOY_0)
#define	PIN_GPIOY_1		(EE_OFFSET + GPIOY_1)
#define	PIN_GPIOY_2		(EE_OFFSET + GPIOY_2)
#define	PIN_GPIOY_3		(EE_OFFSET + GPIOY_3)
#define	PIN_GPIOY_4		(EE_OFFSET + GPIOY_4)
#define	PIN_GPIOY_5		(EE_OFFSET + GPIOY_5)
#define	PIN_GPIOY_6		(EE_OFFSET + GPIOY_6)
#define	PIN_GPIOY_7		(EE_OFFSET + GPIOY_7)
#define	PIN_GPIOY_8		(EE_OFFSET + GPIOY_8)
#define	PIN_GPIOY_9		(EE_OFFSET + GPIOY_9)
#define	PIN_GPIOY_10	(EE_OFFSET + GPIOY_10)
#define	PIN_GPIOY_11	(EE_OFFSET + GPIOY_11)
#define	PIN_GPIOY_12	(EE_OFFSET + GPIOY_12)
#define	PIN_GPIOY_13	(EE_OFFSET + GPIOY_13)
#define	PIN_GPIOY_14	(EE_OFFSET + GPIOY_14)
#define	PIN_GPIOY_15	(EE_OFFSET + GPIOY_15)
#define	PIN_GPIOY_16	(EE_OFFSET + GPIOY_16)
#define	PIN_GPIOY_17	(EE_OFFSET + GPIOY_17)
#define	PIN_GPIOY_18	(EE_OFFSET + GPIOY_18)
#define	PIN_GPIOY_19	(EE_OFFSET + GPIOY_19)
#define	PIN_GPIOY_20	(EE_OFFSET + GPIOY_20)
#define	PIN_GPIOY_21	(EE_OFFSET + GPIOY_21)
#define	PIN_GPIOY_22	(EE_OFFSET + GPIOY_22)
#define	PIN_GPIOY_23	(EE_OFFSET + GPIOY_23)
#define	PIN_GPIOY_24	(EE_OFFSET + GPIOY_24)
#define	PIN_GPIOY_25	(EE_OFFSET + GPIOY_25)
#define	PIN_GPIOY_26	(EE_OFFSET + GPIOY_26)
#define	PIN_GPIOY_27	(EE_OFFSET + GPIOY_27)

#define	PIN_GPIO_TEST_N		(EE_OFFSET + GPIO_TEST_N)

#endif
