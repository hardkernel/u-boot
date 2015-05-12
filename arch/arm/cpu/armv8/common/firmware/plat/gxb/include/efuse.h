/*
 * Copyright (c) 2014 Amlogic, Inc. All rights reserved.
 *
 * This source code is subject to the terms and conditions defined in the
 * file 'LICENSE' which is part of this source code package.
 *
 */
#ifndef __BL2_EFUSE_H__
#define __BL2_EFUSE_H__

#include <stdint.h>

void efuse_read(uint64_t offset, uint64_t length, const char * buffer);
void efuse_print(uint64_t offset, uint64_t length, const char * buffer);

#endif /* __BL2_EFUSE_H__ */
