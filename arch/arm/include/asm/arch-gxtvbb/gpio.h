
/*
 * arch/arm/include/asm/arch-gxtvbb/gpio.h
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


/* AO Bank */
#define	GPIOAO_0	0
#define	GPIOAO_1	1
#define	GPIOAO_2	2
#define	GPIOAO_3	3
#define	GPIOAO_4	4
#define	GPIOAO_5	5
#define	GPIOAO_6	6
#define	GPIOAO_7	7
#define	GPIOAO_8	8
#define	GPIOAO_9	9
#define	GPIOAO_10	10
#define	GPIOAO_11	11
#define	GPIOAO_12	12
#define	GPIOAO_13	13

/* EE Bank */
#define	GPIOZ_0		0
#define	GPIOZ_1		1
#define	GPIOZ_2		2
#define	GPIOZ_3		3
#define	GPIOZ_4		4
#define	GPIOZ_5		5
#define	GPIOZ_6		6
#define	GPIOZ_7		7
#define	GPIOZ_8		8
#define	GPIOZ_9		9
#define	GPIOZ_10	10
#define	GPIOZ_11	11
#define	GPIOZ_12	12
#define	GPIOZ_13	13
#define	GPIOZ_14	14
#define	GPIOZ_15	15
#define	GPIOZ_16	16
#define	GPIOZ_17	17
#define	GPIOZ_18	18
#define	GPIOZ_19	19
#define	GPIOZ_20	20

#define	GPIOH_0		21
#define	GPIOH_1		22
#define	GPIOH_2		23
#define	GPIOH_3		24
#define	GPIOH_4		25
#define	GPIOH_5		26
#define	GPIOH_6		27
#define	GPIOH_7		28
#define	GPIOH_8		29
#define	GPIOH_9		30
#define	GPIOH_10	31

#define	BOOT_0		32
#define	BOOT_1		33
#define	BOOT_2		34
#define	BOOT_3		35
#define	BOOT_4		36
#define	BOOT_5		37
#define	BOOT_6		38
#define	BOOT_7		39
#define	BOOT_8		40
#define	BOOT_9		41
#define	BOOT_10		42
#define	BOOT_11		43
#define	BOOT_12		44
#define	BOOT_13		45
#define	BOOT_14		46
#define	BOOT_15		47
#define	BOOT_16		48
#define	BOOT_17		49
#define	BOOT_18		50

#define	CARD_0		51
#define	CARD_1		52
#define	CARD_2		53
#define	CARD_3		54
#define	CARD_4		55
#define	CARD_5		56
#define	CARD_6		57

#define	GPIOW_0		58
#define	GPIOW_1		59
#define	GPIOW_2		60
#define	GPIOW_3		61
#define	GPIOW_4		62
#define	GPIOW_5		63
#define	GPIOW_6		64
#define	GPIOW_7		65
#define	GPIOW_8		66
#define	GPIOW_9		67
#define	GPIOW_10	68
#define	GPIOW_11	69
#define	GPIOW_12	70
#define	GPIOW_13	71
#define	GPIOW_14	72
#define	GPIOW_15	73
#define	GPIOW_16	74
#define	GPIOW_17	75
#define	GPIOW_18	76
#define	GPIOW_19	77
#define	GPIOW_20	78

#define	GPIOY_0		79
#define	GPIOY_1		80
#define	GPIOY_2		81
#define	GPIOY_3		82
#define	GPIOY_4		83
#define	GPIOY_5		84
#define	GPIOY_6		85
#define	GPIOY_7		86
#define	GPIOY_8		87
#define	GPIOY_9		88
#define	GPIOY_10	89
#define	GPIOY_11	90
#define	GPIOY_12	91
#define	GPIOY_13	92

#define	GPIOX_0		93
#define	GPIOX_1		94
#define	GPIOX_2		95
#define	GPIOX_3		96
#define	GPIOX_4		97
#define	GPIOX_5		98
#define	GPIOX_6		99
#define	GPIOX_7		100
#define	GPIOX_8		101
#define	GPIOX_9		102
#define	GPIOX_10	103
#define	GPIOX_11	104
#define	GPIOX_12	105
#define	GPIOX_13	106
#define	GPIOX_14	107
#define	GPIOX_15	108
#define	GPIOX_16	109
#define	GPIOX_17	110
#define	GPIOX_18	111
#define	GPIOX_19	112
#define	GPIOX_20	113
#define	GPIOX_21	114
#define	GPIOX_22	115
#define	GPIOX_23	116
#define	GPIOX_24	117
#define	GPIOX_25	118
#define	GPIOX_26	119
#define	GPIOX_27	120

#define	GPIOCLK_0	121

#define	GPIO_TEST_N	122

/* AO REG */
#define	AO		0x10
#define	AO2		0x11


#define EE_OFFSET 14

#define	PIN_GPIOZ_0	(EE_OFFSET + GPIOZ_0)
#define	PIN_GPIOZ_1	(EE_OFFSET + GPIOZ_1)
#define	PIN_GPIOZ_2	(EE_OFFSET + GPIOZ_2)
#define	PIN_GPIOZ_3	(EE_OFFSET + GPIOZ_3)
#define	PIN_GPIOZ_4	(EE_OFFSET + GPIOZ_4)
#define	PIN_GPIOZ_5	(EE_OFFSET + GPIOZ_5)
#define	PIN_GPIOZ_6	(EE_OFFSET + GPIOZ_6)
#define	PIN_GPIOZ_7	(EE_OFFSET + GPIOZ_7)
#define	PIN_GPIOZ_8	(EE_OFFSET + GPIOZ_8)
#define	PIN_GPIOZ_9	(EE_OFFSET + GPIOZ_9)
#define	PIN_GPIOZ_10	(EE_OFFSET + GPIOZ_10)
#define	PIN_GPIOZ_11	(EE_OFFSET + GPIOZ_11)
#define	PIN_GPIOZ_12	(EE_OFFSET + GPIOZ_12)
#define	PIN_GPIOZ_13	(EE_OFFSET + GPIOZ_13)
#define	PIN_GPIOZ_14	(EE_OFFSET + GPIOZ_14)
#define	PIN_GPIOZ_15	(EE_OFFSET + GPIOZ_15)
#define	PIN_GPIOZ_16	(EE_OFFSET + GPIOZ_16)
#define	PIN_GPIOZ_17	(EE_OFFSET + GPIOZ_17)
#define	PIN_GPIOZ_18	(EE_OFFSET + GPIOZ_18)
#define	PIN_GPIOZ_19	(EE_OFFSET + GPIOZ_19)
#define	PIN_GPIOZ_20	(EE_OFFSET + GPIOZ_20)

#define	PIN_GPIOH_0	(EE_OFFSET + GPIOH_0)
#define	PIN_GPIOH_1	(EE_OFFSET + GPIOH_1)
#define	PIN_GPIOH_2	(EE_OFFSET + GPIOH_2)
#define	PIN_GPIOH_3	(EE_OFFSET + GPIOH_3)
#define	PIN_GPIOH_4	(EE_OFFSET + GPIOH_4)
#define	PIN_GPIOH_5	(EE_OFFSET + GPIOH_5)
#define	PIN_GPIOH_6	(EE_OFFSET + GPIOH_6)
#define	PIN_GPIOH_7	(EE_OFFSET + GPIOH_7)
#define	PIN_GPIOH_8	(EE_OFFSET + GPIOH_8)
#define	PIN_GPIOH_9	(EE_OFFSET + GPIOH_9)
#define	PIN_GPIOH_10	(EE_OFFSET + GPIOH_10)

#define	PIN_BOOT_0	(EE_OFFSET + BOOT_0)
#define	PIN_BOOT_1	(EE_OFFSET + BOOT_1)
#define	PIN_BOOT_2	(EE_OFFSET + BOOT_2)
#define	PIN_BOOT_3	(EE_OFFSET + BOOT_3)
#define	PIN_BOOT_4	(EE_OFFSET + BOOT_4)
#define	PIN_BOOT_5	(EE_OFFSET + BOOT_5)
#define	PIN_BOOT_6	(EE_OFFSET + BOOT_6)
#define	PIN_BOOT_7	(EE_OFFSET + BOOT_7)
#define	PIN_BOOT_8	(EE_OFFSET + BOOT_8)
#define	PIN_BOOT_9	(EE_OFFSET + BOOT_9)
#define	PIN_BOOT_10	(EE_OFFSET + BOOT_10)
#define	PIN_BOOT_11	(EE_OFFSET + BOOT_11)
#define	PIN_BOOT_12	(EE_OFFSET + BOOT_12)
#define	PIN_BOOT_13	(EE_OFFSET + BOOT_13)
#define	PIN_BOOT_14	(EE_OFFSET + BOOT_14)
#define	PIN_BOOT_15	(EE_OFFSET + BOOT_15)
#define	PIN_BOOT_16	(EE_OFFSET + BOOT_16)
#define	PIN_BOOT_17	(EE_OFFSET + BOOT_17)
#define	PIN_BOOT_18	(EE_OFFSET + BOOT_18)

#define	PIN_CARD_0	(EE_OFFSET + CARD_0)
#define	PIN_CARD_1	(EE_OFFSET + CARD_1)
#define	PIN_CARD_2	(EE_OFFSET + CARD_2)
#define	PIN_CARD_3	(EE_OFFSET + CARD_3)
#define	PIN_CARD_4	(EE_OFFSET + CARD_4)
#define	PIN_CARD_5	(EE_OFFSET + CARD_5)
#define	PIN_CARD_6	(EE_OFFSET + CARD_6)

#define	PIN_GPIOW_0	(EE_OFFSET + GPIOW_0)
#define	PIN_GPIOW_1	(EE_OFFSET + GPIOW_1)
#define	PIN_GPIOW_2	(EE_OFFSET + GPIOW_2)
#define	PIN_GPIOW_3	(EE_OFFSET + GPIOW_3)
#define	PIN_GPIOW_4	(EE_OFFSET + GPIOW_4)
#define	PIN_GPIOW_5	(EE_OFFSET + GPIOW_5)
#define	PIN_GPIOW_6	(EE_OFFSET + GPIOW_6)
#define	PIN_GPIOW_7	(EE_OFFSET + GPIOW_7)
#define	PIN_GPIOW_8	(EE_OFFSET + GPIOW_8)
#define	PIN_GPIOW_9	(EE_OFFSET + GPIOW_9)
#define	PIN_GPIOW_10	(EE_OFFSET + GPIOW_10)
#define	PIN_GPIOW_11	(EE_OFFSET + GPIOW_11)
#define	PIN_GPIOW_12	(EE_OFFSET + GPIOW_12)
#define	PIN_GPIOW_13	(EE_OFFSET + GPIOW_13)
#define	PIN_GPIOW_14	(EE_OFFSET + GPIOW_14)
#define	PIN_GPIOW_15	(EE_OFFSET + GPIOW_15)
#define	PIN_GPIOW_16	(EE_OFFSET + GPIOW_16)
#define	PIN_GPIOW_17	(EE_OFFSET + GPIOW_17)
#define	PIN_GPIOW_18	(EE_OFFSET + GPIOW_18)
#define	PIN_GPIOW_19	(EE_OFFSET + GPIOW_19)
#define	PIN_GPIOW_20	(EE_OFFSET + GPIOW_20)

#define	PIN_GPIOY_0	(EE_OFFSET + GPIOY_0)
#define	PIN_GPIOY_1	(EE_OFFSET + GPIOY_1)
#define	PIN_GPIOY_2	(EE_OFFSET + GPIOY_2)
#define	PIN_GPIOY_3	(EE_OFFSET + GPIOY_3)
#define	PIN_GPIOY_4	(EE_OFFSET + GPIOY_4)
#define	PIN_GPIOY_5	(EE_OFFSET + GPIOY_5)
#define	PIN_GPIOY_6	(EE_OFFSET + GPIOY_6)
#define	PIN_GPIOY_7	(EE_OFFSET + GPIOY_7)
#define	PIN_GPIOY_8	(EE_OFFSET + GPIOY_8)
#define	PIN_GPIOY_9	(EE_OFFSET + GPIOY_9)
#define	PIN_GPIOY_10	(EE_OFFSET + GPIOY_10)
#define	PIN_GPIOY_11	(EE_OFFSET + GPIOY_11)
#define	PIN_GPIOY_12	(EE_OFFSET + GPIOY_12)
#define	PIN_GPIOY_13	(EE_OFFSET + GPIOY_13)

#define	PIN_GPIOX_0	(EE_OFFSET + GPIOX_0)
#define	PIN_GPIOX_1	(EE_OFFSET + GPIOX_1)
#define	PIN_GPIOX_2	(EE_OFFSET + GPIOX_2)
#define	PIN_GPIOX_3	(EE_OFFSET + GPIOX_3)
#define	PIN_GPIOX_4	(EE_OFFSET + GPIOX_4)
#define	PIN_GPIOX_5	(EE_OFFSET + GPIOX_5)
#define	PIN_GPIOX_6	(EE_OFFSET + GPIOX_6)
#define	PIN_GPIOX_7	(EE_OFFSET + GPIOX_7)
#define	PIN_GPIOX_8	(EE_OFFSET + GPIOX_8)
#define	PIN_GPIOX_9	(EE_OFFSET + GPIOX_9)
#define	PIN_GPIOX_10	(EE_OFFSET + GPIOX_10)
#define	PIN_GPIOX_11	(EE_OFFSET + GPIOX_11)
#define	PIN_GPIOX_12	(EE_OFFSET + GPIOX_12)
#define	PIN_GPIOX_13	(EE_OFFSET + GPIOX_13)
#define	PIN_GPIOX_14	(EE_OFFSET + GPIOX_14)
#define	PIN_GPIOX_15	(EE_OFFSET + GPIOX_15)
#define	PIN_GPIOX_16	(EE_OFFSET + GPIOX_16)
#define	PIN_GPIOX_17	(EE_OFFSET + GPIOX_17)
#define	PIN_GPIOX_18	(EE_OFFSET + GPIOX_18)
#define	PIN_GPIOX_19	(EE_OFFSET + GPIOX_19)
#define	PIN_GPIOX_20	(EE_OFFSET + GPIOX_20)
#define	PIN_GPIOX_21	(EE_OFFSET + GPIOX_21)
#define	PIN_GPIOX_22	(EE_OFFSET + GPIOX_22)
#define	PIN_GPIOX_23	(EE_OFFSET + GPIOX_23)
#define	PIN_GPIOX_24	(EE_OFFSET + GPIOX_24)
#define	PIN_GPIOX_25	(EE_OFFSET + GPIOX_25)
#define	PIN_GPIOX_26	(EE_OFFSET + GPIOX_26)
#define	PIN_GPIOX_27	(EE_OFFSET + GPIOX_27)

#define	PIN_GPIOCLK_0	(EE_OFFSET + GPIOCLK_0)

#define	PIN_GPIO_TEST_N	(EE_OFFSET + GPIO_TEST_N)

#endif
