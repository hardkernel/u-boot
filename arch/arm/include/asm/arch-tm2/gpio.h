/*
 * Copyright (c) 2017 Amlogic, Inc. All rights reserved.
 * Author: Xingyu Chen <xingyu.chen@amlogic.com>
 *
 * SPDX-License-Identifier: GPL-2.0+
 */

#ifndef _MESON_TM2_GPIO_H
#define _MESON_TM2_GPIO_H

#define EE_OFFSET 15
#define GPIOAO(x) (x)
#define GPIOEE(x) (EE_OFFSET + x)

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
#define GPIOE_0		12
#define GPIOE_1		13
#define GPIOE_2		14

/* Second GPIO chip */
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

#define	GPIOH_0		11
#define	GPIOH_1		12
#define	GPIOH_2		13
#define	GPIOH_3		14
#define	GPIOH_4		15
#define	GPIOH_5		16
#define	GPIOH_6		17
#define	GPIOH_7		18
#define	GPIOH_8		19
#define	GPIOH_9		20
#define	GPIOH_10	21
#define	GPIOH_11	22
#define	GPIOH_12	23
#define	GPIOH_13	24
#define	GPIOH_14	25
#define	GPIOH_15	26
#define	GPIOH_16	27
#define	GPIOH_17	28
#define	GPIOH_18	29
#define	GPIOH_19	30
#define	GPIOH_20	31
#define	GPIOH_21	32
#define	GPIOH_22	33
#define	GPIOH_23	34
#define	GPIOH_24	35

#define	BOOT_0		36
#define	BOOT_1		37
#define	BOOT_2		38
#define	BOOT_3		39
#define	BOOT_4		40
#define	BOOT_5		41
#define	BOOT_6		42
#define	BOOT_7		43
#define	BOOT_8		44
#define	BOOT_9		45
#define	BOOT_10		46
#define	BOOT_11		47
#define	BOOT_12		48
#define	BOOT_13		49

#define	GPIOC_0		50
#define	GPIOC_1		51
#define	GPIOC_2		52
#define	GPIOC_3		53
#define	GPIOC_4		54
#define	GPIOC_5		55
#define	GPIOC_6		56
#define	GPIOC_7		57
#define	GPIOC_8		58
#define	GPIOC_9		59
#define	GPIOC_10	60
#define	GPIOC_11	61
#define	GPIOC_12	62
#define	GPIOC_13	63
#define	GPIOC_14	64

#define	GPIOW_0		65
#define	GPIOW_1		66
#define	GPIOW_2		67
#define	GPIOW_3		68
#define	GPIOW_4		69
#define	GPIOW_5		70
#define	GPIOW_6		71
#define	GPIOW_7		72
#define	GPIOW_8		73
#define	GPIOW_9		74
#define	GPIOW_10	75
#define	GPIOW_11	76

#define	GPIODV_0	77
#define	GPIODV_1	78
#define	GPIODV_2	79
#define	GPIODV_3	80
#define	GPIODV_4	81
#define	GPIODV_5	82
#define	GPIODV_6	83
#define	GPIODV_7	84
#define	GPIODV_8	85
#define	GPIODV_9	86
#define	GPIODV_10	87
#define	GPIODV_11	88

#endif /* _MESON_TM2_GPIO_H */
