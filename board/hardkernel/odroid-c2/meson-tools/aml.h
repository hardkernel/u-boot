/*
 * Copyright (c) 2017 Andreas Färber
 *
 * SPDX-License-Identifier: GPL-2.0+ OR MIT
 */

#ifndef AML_H
#define AML_H

#include <stdint.h>

#define AMLOGIC_SIGNATURE "@AML"

struct __attribute((__packed__)) AmlogicHeader {
	char sig[4];
	uint32_t size;
	uint16_t header_size;
	uint16_t header_version;
	uint32_t id;
	uint32_t encrypted;
	uint32_t digest_offset;
	uint32_t digest_size;
	uint32_t data_offset;
	uint32_t data_size;
	uint32_t padding_offset;
	uint32_t padding_size;
	uint32_t _offset2;
	uint32_t pad2;
	uint32_t payload_offset;
	uint32_t payload_size;
	uint32_t unknown;
};

#endif
