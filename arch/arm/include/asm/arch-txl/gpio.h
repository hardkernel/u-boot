
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
#define	GPIOZ_20    20
#define	GPIOZ_21    21

#define	GPIOH_0    22
#define	GPIOH_1    23
#define	GPIOH_2    24
#define	GPIOH_3    25
#define	GPIOH_4    26
#define	GPIOH_5    27
#define	GPIOH_6    28
#define	GPIOH_7    29
#define	GPIOH_8    30
#define	GPIOH_9    31

#define	BOOT_0    32
#define	BOOT_1    33
#define	BOOT_2    34
#define	BOOT_3    35
#define	BOOT_4    36
#define	BOOT_5    37
#define	BOOT_6    38
#define	BOOT_7    39
#define	BOOT_8    40
#define	BOOT_9    41
#define	BOOT_10    42
#define	BOOT_11    43

#define	CARD_0    44
#define	CARD_1    45
#define	CARD_2    46
#define	CARD_3    47
#define	CARD_4    48
#define	CARD_5    49
#define	CARD_6    50

#define	GPIODV_0    51
#define	GPIODV_1    52
#define	GPIODV_2    53
#define	GPIODV_3    54
#define	GPIODV_4    55
#define	GPIODV_5    56
#define	GPIODV_6    57
#define	GPIODV_7    58
#define	GPIODV_8    59
#define	GPIODV_9    60
#define	GPIODV_10   61
#define	GPIODV_11   62

#define	GPIOW_0    63
#define	GPIOW_1    64
#define	GPIOW_2    65
#define	GPIOW_3    66
#define	GPIOW_4    67
#define	GPIOW_5    68
#define	GPIOW_6    69
#define	GPIOW_7    70
#define	GPIOW_8    71
#define	GPIOW_9    72
#define	GPIOW_10   73
#define	GPIOW_11   74
#define	GPIOW_12   75
#define	GPIOW_13   76
#define	GPIOW_14   77
#define	GPIOW_15   78

#define	GPIOCLK_0    79
#define	GPIOCLK_1    80

#define EE_OFFSET 12

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
#define	PIN_GPIOZ_20    (EE_OFFSET + GPIOZ_20)
#define	PIN_GPIOZ_21    (EE_OFFSET + GPIOZ_21)

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

#define	PIN_CARD_0    (EE_OFFSET + CARD_0)
#define	PIN_CARD_1    (EE_OFFSET + CARD_1)
#define	PIN_CARD_2    (EE_OFFSET + CARD_2)
#define	PIN_CARD_3    (EE_OFFSET + CARD_3)
#define	PIN_CARD_4    (EE_OFFSET + CARD_4)
#define	PIN_CARD_5    (EE_OFFSET + CARD_5)
#define	PIN_CARD_6    (EE_OFFSET + CARD_6)

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
#define	PIN_GPIODV_11    (EE_OFFSET + GPIODV_11)

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

#define	PIN_GPIOCLK_0    (EE_OFFSET + GPIOCLK_0)
#define	PIN_GPIOCLK_1    (EE_OFFSET + GPIOCLK_1)

#define	PIN_GPIO_TEST_N    (EE_OFFSET + GPIO_TEST_N)
#endif
