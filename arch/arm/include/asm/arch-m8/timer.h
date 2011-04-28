/*
 *  Copyright (C) 2010 AMLOGIC, INC.
 *
 *  Y:\arch\arm\include\asm\arch-m1\serial.h
 * 
 *
 * License terms: GNU General Public License (GPL) version 2
 * Basic register address definitions in physical memory and
 * some block defintions for core devices like the timer.
 * 03/06/10
 *
 * author : jerry.yu
 */
#ifndef __MESON_TIMER_H_
#define __MESON_TIMER_H_
#include "io.h"
//timer E
#define TIMERE_SUB(timea,timeb) ((timea)-(timeb))
#define TIMERE_GET()            (READ_CBUS_REG(ISA_TIMERE))


#endif
