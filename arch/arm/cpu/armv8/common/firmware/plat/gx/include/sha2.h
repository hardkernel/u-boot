/*
 * Copyright (c) 2015 Amlogic, Inc. All rights reserved.
 *
 * This source code is subject to the terms and conditions defined in the
 * file 'LICENSE' which is part of this source code package.
 *
 * Hardware SHA2 driver
 */

#ifndef __PLAT_SHA2_H_
#define __PLAT_SHA2_H_

void sha2(const uint8_t *input,
	  uint32_t ilen,
	  uint8_t output[32],
	  uint32_t is224);

#endif /*__PLAT_SHA2_H_*/