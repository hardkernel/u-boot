
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

#define	GPIOH_0    16
#define	GPIOH_1    17
#define	GPIOH_2    18
#define	GPIOH_3    19
#define	GPIOH_4    20
#define	GPIOH_5    21
#define	GPIOH_6    22
#define	GPIOH_7    23
#define	GPIOH_8    24
#define	GPIOH_9    25

#define	BOOT_0    26
#define	BOOT_1    27
#define	BOOT_2    28
#define	BOOT_3    29
#define	BOOT_4    30
#define	BOOT_5    31
#define	BOOT_6    32
#define	BOOT_7    33
#define	BOOT_8    34
#define	BOOT_9    35
#define	BOOT_10    36
#define	BOOT_11    37
#define	BOOT_12    38
#define	BOOT_13    39
#define	BOOT_14    40
#define	BOOT_15    41

#define	CARD_0    42
#define	CARD_1    43
#define	CARD_2    44
#define	CARD_3    45
#define	CARD_4    46
#define	CARD_5    47
#define	CARD_6    48

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
#define	GPIODV_10    59
#define	GPIODV_11    60
#define	GPIODV_12    61
#define	GPIODV_13    62
#define	GPIODV_14    63
#define	GPIODV_15    64
#define	GPIODV_16    65
#define	GPIODV_17    66
#define	GPIODV_18    67
#define	GPIODV_19    68
#define	GPIODV_20    69
#define	GPIODV_21    70
#define	GPIODV_22    71
#define	GPIODV_23    72
#define	GPIODV_24    73
#define	GPIODV_25    74
#define	GPIODV_26    75
#define	GPIODV_27    76
#define	GPIODV_28    77
#define	GPIODV_29    78

#define	GPIOX_0    79
#define	GPIOX_1    80
#define	GPIOX_2    81
#define	GPIOX_3    82
#define	GPIOX_4    83
#define	GPIOX_5    84
#define	GPIOX_6    85
#define	GPIOX_7    86
#define	GPIOX_8    87
#define	GPIOX_9    88
#define	GPIOX_10    89
#define	GPIOX_11    90
#define	GPIOX_12    91
#define	GPIOX_13    92
#define	GPIOX_14    93
#define	GPIOX_15    94
#define	GPIOX_16    95
#define	GPIOX_17    96
#define	GPIOX_18    97

#define	GPIOCLK_0    98
#define	GPIOCLK_1    99

#define	GPIO_TEST_N    100



#define EE_OFFSET 10

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
#define	PIN_BOOT_12    (EE_OFFSET + BOOT_12)
#define	PIN_BOOT_13    (EE_OFFSET + BOOT_13)
#define	PIN_BOOT_14    (EE_OFFSET + BOOT_14)
#define	PIN_BOOT_15    (EE_OFFSET + BOOT_15)
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
#define	PIN_GPIODV_12    (EE_OFFSET + GPIODV_12)
#define	PIN_GPIODV_13    (EE_OFFSET + GPIODV_13)
#define	PIN_GPIODV_14    (EE_OFFSET + GPIODV_14)
#define	PIN_GPIODV_15    (EE_OFFSET + GPIODV_15)
#define	PIN_GPIODV_16    (EE_OFFSET + GPIODV_16)
#define	PIN_GPIODV_17    (EE_OFFSET + GPIODV_17)
#define	PIN_GPIODV_18    (EE_OFFSET + GPIODV_18)
#define	PIN_GPIODV_19    (EE_OFFSET + GPIODV_19)
#define	PIN_GPIODV_20    (EE_OFFSET + GPIODV_20)
#define	PIN_GPIODV_21    (EE_OFFSET + GPIODV_21)
#define	PIN_GPIODV_22    (EE_OFFSET + GPIODV_22)
#define	PIN_GPIODV_23    (EE_OFFSET + GPIODV_23)
#define	PIN_GPIODV_24    (EE_OFFSET + GPIODV_24)
#define	PIN_GPIODV_25    (EE_OFFSET + GPIODV_25)
#define	PIN_GPIODV_26    (EE_OFFSET + GPIODV_26)
#define	PIN_GPIODV_27    (EE_OFFSET + GPIODV_27)
#define	PIN_GPIODV_28    (EE_OFFSET + GPIODV_28)
#define	PIN_GPIODV_29    (EE_OFFSET + GPIODV_29)
#define	PIN_GPIOX_0    (EE_OFFSET + GPIOX_0)
#define	PIN_GPIOX_1    (EE_OFFSET + GPIOX_1)
#define	PIN_GPIOX_2    (EE_OFFSET + GPIOX_2)
#define	PIN_GPIOX_3    (EE_OFFSET + GPIOX_3)
#define	PIN_GPIOX_4    (EE_OFFSET + GPIOX_4)
#define	PIN_GPIOX_5    (EE_OFFSET + GPIOX_5)
#define	PIN_GPIOX_6    (EE_OFFSET + GPIOX_6)
#define	PIN_GPIOX_7    (EE_OFFSET + GPIOX_7)
#define	PIN_GPIOX_8    (EE_OFFSET + GPIOX_8)
#define	PIN_GPIOX_9    (EE_OFFSET + GPIOX_9)
#define	PIN_GPIOX_10    (EE_OFFSET + GPIOX_10)
#define	PIN_GPIOX_11    (EE_OFFSET + GPIOX_11)
#define	PIN_GPIOX_12    (EE_OFFSET + GPIOX_12)
#define	PIN_GPIOX_13    (EE_OFFSET + GPIOX_13)
#define	PIN_GPIOX_14    (EE_OFFSET + GPIOX_14)
#define	PIN_GPIOX_15    (EE_OFFSET + GPIOX_15)
#define	PIN_GPIOX_16    (EE_OFFSET + GPIOX_16)
#define	PIN_GPIOX_17    (EE_OFFSET + GPIOX_17)
#define	PIN_GPIOX_18    (EE_OFFSET + GPIOX_18)
#define	PIN_GPIOCLK_0    (EE_OFFSET + GPIOCLK_0)
#define	PIN_GPIOCLK_1    (EE_OFFSET + GPIOCLK_1)

#define	PIN_GPIO_TEST_N    (EE_OFFSET + GPIO_TEST_N)
#endif
