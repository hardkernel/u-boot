/*
 * GPIO definitions for Amlogic Meson8b SoCs
 *
 * Copyright (C) 2015 Endless Mobile, Inc.
 * Author: Carlo Caione <carlo@endlessm.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * version 2 as published by the Free Software Foundation.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef _MESONAXG_GPIO_H
#define _MESONAXG_GPIO_H

#define EE_OFFSET 14

/* First GPIO chip */
#define GPIOAO_0	0
#define GPIOAO_1	1
#define GPIOAO_2	2
#define GPIOAO_3	3
#define GPIOAO_4	4
#define GPIOAO_5	5
#define GPIOAO_6	6
#define GPIOAO_7	7
#define GPIOAO_8	8
#define GPIOAO_9	9
#define GPIOAO_10	10
#define GPIOAO_11	11
#define GPIOAO_12	12
#define GPIOAO_13	13

/* Second GPIO chip */
#define GPIOZ_0		0
#define GPIOZ_1		1
#define GPIOZ_2		2
#define GPIOZ_3		3
#define GPIOZ_4		4
#define GPIOZ_5		5
#define GPIOZ_6		6
#define GPIOZ_7		7
#define GPIOZ_8		8
#define GPIOZ_9		9
#define GPIOZ_10	10
#define BOOT_0		11
#define BOOT_1		12
#define BOOT_2		13
#define BOOT_3		14
#define BOOT_4		15
#define BOOT_5		16
#define BOOT_6		17
#define BOOT_7		18
#define BOOT_8		19
#define BOOT_9		20
#define BOOT_10		21
#define BOOT_11		22
#define BOOT_12		23
#define BOOT_13		24
#define BOOT_14		25
#define GPIOA_0		26
#define GPIOA_1		27
#define GPIOA_2		28
#define GPIOA_3		29
#define GPIOA_4		30
#define GPIOA_5		31
#define GPIOA_6		32
#define GPIOA_7		33
#define GPIOA_8		34
#define GPIOA_9		35
#define GPIOA_10	36
#define GPIOA_11	37
#define GPIOA_12	38
#define GPIOA_13	39
#define GPIOA_14	40
#define GPIOA_15	41
#define GPIOA_16	42
#define GPIOA_17	43
#define GPIOA_18	44
#define GPIOA_19	45
#define GPIOA_20	46
#define GPIOX_0		47
#define GPIOX_1		48
#define GPIOX_2		49
#define GPIOX_3		50
#define GPIOX_4		51
#define GPIOX_5		52
#define GPIOX_6		53
#define GPIOX_7		54
#define GPIOX_8		55
#define GPIOX_9		56
#define GPIOX_10	57
#define GPIOX_11	58
#define GPIOX_12	59
#define GPIOX_13	60
#define GPIOX_14	61
#define GPIOX_15	62
#define GPIOX_16	63
#define GPIOX_17	64
#define GPIOX_18	65
#define GPIOX_19	66
#define GPIOX_20	67
#define GPIOX_21	68
#define GPIOX_22	69
#define GPIOY_0		70
#define GPIOY_1		71
#define GPIOY_2		72
#define GPIOY_3		73
#define GPIOY_4		74
#define GPIOY_5		75
#define GPIOY_6		76
#define GPIOY_7		77
#define GPIOY_8		78
#define GPIOY_9		79
#define GPIOY_10	80
#define GPIOY_11	81
#define GPIOY_12	82
#define GPIOY_13	83
#define GPIOY_14	84
#define GPIOY_15	85

/*GPIOZ*/
#define PIN_GPIOZ_0		(EE_OFFSET + GPIOZ_0)
#define PIN_GPIOZ_1		(EE_OFFSET + GPIOZ_1)
#define PIN_GPIOZ_2		(EE_OFFSET + GPIOZ_2)
#define PIN_GPIOZ_3		(EE_OFFSET + GPIOZ_3)
#define PIN_GPIOZ_4		(EE_OFFSET + GPIOZ_4)
#define PIN_GPIOZ_5		(EE_OFFSET + GPIOZ_5)
#define PIN_GPIOZ_6		(EE_OFFSET + GPIOZ_6)
#define PIN_GPIOZ_7		(EE_OFFSET + GPIOZ_7)
#define PIN_GPIOZ_8		(EE_OFFSET + GPIOZ_8)
#define PIN_GPIOZ_9		(EE_OFFSET + GPIOZ_9)
#define PIN_GPIOZ_10	(EE_OFFSET + GPIOZ_10)

/*BOOT*/
#define PIN_BOOT_0		(EE_OFFSET + BOOT_0)
#define PIN_BOOT_1		(EE_OFFSET + BOOT_1)
#define PIN_BOOT_2		(EE_OFFSET + BOOT_2)
#define PIN_BOOT_3		(EE_OFFSET + BOOT_3)
#define PIN_BOOT_4		(EE_OFFSET + BOOT_4)
#define PIN_BOOT_5		(EE_OFFSET + BOOT_5)
#define PIN_BOOT_6		(EE_OFFSET + BOOT_6)
#define PIN_BOOT_7		(EE_OFFSET + BOOT_7)
#define PIN_BOOT_8		(EE_OFFSET + BOOT_8)
#define PIN_BOOT_9		(EE_OFFSET + BOOT_9)
#define PIN_BOOT_10		(EE_OFFSET + BOOT_10)
#define PIN_BOOT_11		(EE_OFFSET + BOOT_11)
#define PIN_BOOT_12		(EE_OFFSET + BOOT_12)
#define PIN_BOOT_13		(EE_OFFSET + BOOT_13)
#define PIN_BOOT_14		(EE_OFFSET + BOOT_14)

/*GPIOA*/
#define PIN_GPIOA_0	    (EE_OFFSET + GPIOA_0)
#define PIN_GPIOA_1		(EE_OFFSET + GPIOA_1)
#define PIN_GPIOA_2		(EE_OFFSET + GPIOA_2)
#define PIN_GPIOA_3		(EE_OFFSET + GPIOA_3)
#define PIN_GPIOA_4		(EE_OFFSET + GPIOA_4)
#define PIN_GPIOA_5		(EE_OFFSET + GPIOA_5)
#define PIN_GPIOA_6		(EE_OFFSET + GPIOA_6)
#define PIN_GPIOA_7		(EE_OFFSET + GPIOA_7)
#define PIN_GPIOA_8		(EE_OFFSET + GPIOA_8)
#define PIN_GPIOA_9		(EE_OFFSET + GPIOA_9)
#define PIN_GPIOA_10	(EE_OFFSET + GPIOA_10)
#define PIN_GPIOA_11	(EE_OFFSET + GPIOA_11)
#define PIN_GPIOA_12	(EE_OFFSET + GPIOA_12)
#define PIN_GPIOA_13	(EE_OFFSET + GPIOA_13)
#define PIN_GPIOA_14	(EE_OFFSET + GPIOA_14)
#define PIN_GPIOA_15	(EE_OFFSET + GPIOA_15)
#define PIN_GPIOA_16	(EE_OFFSET + GPIOA_16)
#define PIN_GPIOA_17	(EE_OFFSET + GPIOA_17)
#define PIN_GPIOA_18	(EE_OFFSET + GPIOA_18)
#define PIN_GPIOA_19	(EE_OFFSET + GPIOA_19)
#define PIN_GPIOA_20	(EE_OFFSET + GPIOA_20)

/*GPIOX*/
#define PIN_GPIOX_0		(EE_OFFSET + GPIOX_0)
#define PIN_GPIOX_1		(EE_OFFSET + GPIOX_1)
#define PIN_GPIOX_2		(EE_OFFSET + GPIOX_2)
#define PIN_GPIOX_3		(EE_OFFSET + GPIOX_3)
#define PIN_GPIOX_4		(EE_OFFSET + GPIOX_4)
#define PIN_GPIOX_5		(EE_OFFSET + GPIOX_5)
#define PIN_GPIOX_6		(EE_OFFSET + GPIOX_6)
#define PIN_GPIOX_7		(EE_OFFSET + GPIOX_7)
#define PIN_GPIOX_8		(EE_OFFSET + GPIOX_8)
#define PIN_GPIOX_9		(EE_OFFSET + GPIOX_9)
#define PIN_GPIOX_10	(EE_OFFSET + GPIOX_10)
#define PIN_GPIOX_11	(EE_OFFSET + GPIOX_11)
#define PIN_GPIOX_12	(EE_OFFSET + GPIOX_12)
#define PIN_GPIOX_13	(EE_OFFSET + GPIOX_13)
#define PIN_GPIOX_14	(EE_OFFSET + GPIOX_14)
#define PIN_GPIOX_15	(EE_OFFSET + GPIOX_15)
#define PIN_GPIOX_16	(EE_OFFSET + GPIOX_16)
#define PIN_GPIOX_17	(EE_OFFSET + GPIOX_17)
#define PIN_GPIOX_18	(EE_OFFSET + GPIOX_18)
#define PIN_GPIOX_19	(EE_OFFSET + GPIOX_19)
#define PIN_GPIOX_20	(EE_OFFSET + GPIOX_20)
#define PIN_GPIOX_21	(EE_OFFSET + GPIOX_21)
#define PIN_GPIOX_22	(EE_OFFSET + GPIOX_22)

/*GPIOY*/
#define PIN_GPIOY_0		(EE_OFFSET + GPIOY_0)
#define PIN_GPIOY_1		(EE_OFFSET + GPIOY_1)
#define PIN_GPIOY_2		(EE_OFFSET + GPIOY_2)
#define PIN_GPIOY_3		(EE_OFFSET + GPIOY_3)
#define PIN_GPIOY_4		(EE_OFFSET + GPIOY_4)
#define PIN_GPIOY_5		(EE_OFFSET + GPIOY_5)
#define PIN_GPIOY_6		(EE_OFFSET + GPIOY_6)
#define PIN_GPIOY_7		(EE_OFFSET + GPIOY_7)
#define PIN_GPIOY_8		(EE_OFFSET + GPIOY_8)
#define PIN_GPIOY_9		(EE_OFFSET + GPIOY_9)
#define PIN_GPIOY_10	(EE_OFFSET + GPIOY_10)
#define PIN_GPIOY_11	(EE_OFFSET + GPIOY_11)
#define PIN_GPIOY_12	(EE_OFFSET + GPIOY_12)
#define PIN_GPIOY_13	(EE_OFFSET + GPIOY_13)
#define PIN_GPIOY_14	(EE_OFFSET + GPIOY_14)
#define PIN_GPIOY_15	(EE_OFFSET + GPIOY_15)

#endif /* _DT_BINDINGS_MESONAXG_GPIO_H */
