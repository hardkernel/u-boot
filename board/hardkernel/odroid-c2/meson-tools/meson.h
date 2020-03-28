/*
 * Copyright (c) 2017 Andreas Färber
 *
 * SPDX-License-Identifier: GPL-2.0+
 */

#ifndef MESON_COMMON_H
#define MESON_COMMON_H

#include "fip.h"
#include "aml.h"

#ifndef MIN
#define MIN(a, b) (((a) < (b)) ? (a) : (b))
#endif

#ifndef ROUND_UP
#define ROUND_UP(x, a) (((x) + ((a) - 1)) & ~((a) - 1))
#endif

#endif
