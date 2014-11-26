/*
* (C) Copyright 2014 Hardkernel Co,.Ltd
*
* See file CREDITS for list of people who contributed to this
* project.
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public License as
* published by the Free Software Foundation; either version 2 of
* the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program; if not, write to the Free Software
* Foundation, Inc., 59 Temple Place, Suite 330, Boston,
* MA 02111-1307 USA
*/

#include <common.h>
#include <usb_mass_storage.h>

#ifdef CONFIG_USB_GADGET_MASS_STORAGE
static int ums_read_sector(struct ums_device *ums_dev,
                ulong start, lbaint_t blkcnt, void *buf)
{
        if (ums_dev->mmc->block_dev.block_read(ums_dev->dev_num,
                                start + ums_dev->offset, blkcnt, buf) != blkcnt)
                return -1;

        return 0;
}

static int ums_write_sector(struct ums_device *ums_dev,
                ulong start, lbaint_t blkcnt, const void *buf)
{
        if (ums_dev->mmc->block_dev.block_write(ums_dev->dev_num,
                                start + ums_dev->offset, blkcnt, buf) != blkcnt)
                return -1;

        return 0;
}

static void ums_get_capacity(struct ums_device *ums_dev,
                long long int *capacity)
{
        long long int tmp_capacity;

        tmp_capacity = (long long int) ((ums_dev->offset + ums_dev->part_size)
                        * SECTOR_SIZE);
        *capacity = ums_dev->mmc->capacity - tmp_capacity;
}

static struct ums_board_info ums_board = {
        .read_sector = ums_read_sector,
        .write_sector = ums_write_sector,
        .get_capacity = ums_get_capacity,
        .name = "ODROID UMS Disk",
        .ums_dev = {
                .mmc = NULL,
                .dev_num = 0,
                .offset = 0,
                .part_size = 0.
        },
};

struct ums_board_info *board_ums_init(unsigned int dev_num,
                unsigned int offset, unsigned int part_size)
{
        struct mmc *mmc;

        mmc = find_mmc_device(dev_num);
        if (!mmc)
                return NULL;

        ums_board.ums_dev.mmc = mmc;
        ums_board.ums_dev.dev_num = dev_num;
        ums_board.ums_dev.offset = offset;
        ums_board.ums_dev.part_size = part_size;

        return &ums_board;
}
#endif
