/*
 * Copyright (c) 2017 Andreas Färber
 *
 * SPDX-License-Identifier: GPL-2.0+ OR MIT
 */

#ifndef MESON_FIP_H
#define MESON_FIP_H

#include <stdint.h>

#define FIP_SIGNATURE 0xaa640001

struct __attribute((__packed__)) FipEntry {
	uint64_t uuid[2];
	uint64_t offset_address;
	uint64_t size;
	uint64_t flags;
};

struct __attribute((__packed__)) FipHeader {
	uint32_t name;
	uint32_t serial_number;
	uint64_t flags;
	struct FipEntry entries[0];
};

#endif
