/*
 * Copyright (C) 2017 Amlogic, Inc. All rights reserved.
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
 */
#ifndef __AML_NAND_H__
#define __AML_NAND_H__

int amlnf_dtb_save(u8 *buf, unsigned int len);
int amlnf_dtb_erase(void);
int get_boot_num(struct mtd_info *mtd, size_t rwsize);

#define RESERVED_BLOCK_NUM 48

#endif/* __AML_NAND_H__ */
