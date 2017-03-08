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
#include <errno.h>
#include <fastboot.h>

#if defined(CONFIG_FASTBOOT)
/*
 * Partition table and management
 */
struct fbt_partition {
        const char *name;
        const char *type;
        unsigned size_kb;
};

#if !defined(CONFIG_ODROIDC_REV2)
struct fbt_partition sys_partitions[] = {
        {
                .name = "-SPL",         /* SPL */
                .type = "raw",
                .size_kb = 32
        }, {
                .name = "bootloader",
                .type = "raw",
                .size_kb = 512 - (32 + 4)       /* SPL + BCB */
        }, {
                .name = "bcb",          /* Bootloader control block */
                .type = "raw",
                .size_kb = 4
        }, {
                .name = CONFIG_ENV_BLK_PARTITION,       /* "environment" */
                .type = "raw",
                .size_kb = CONFIG_ENV_SIZE / 1024
        }, {
                .name = "dtb",          /* Device Tree */
                .type= "raw",
                .size_kb = 64
        }, {
                .name = "boot",         /* Boot image */
                .type = "boot",
                .size_kb = 8 * 1024
        }, {
                .name = "recovery",     /* Recovery Image */
                .type = "boot",
                .size_kb = 8 * 1024
        }, {
                .name = "logo",         /* Logo */
                .type = "raw",
                .size_kb = 6 * 1024
        }, {
                .name = 0,
                .type = 0,
                .size_kb = 0
        },
};

struct fbt_partition fbt_partitions[] = {
        {
                .name = "system",               /* 2nd primary partition */
                .type = "ext4",
                .size_kb = BOARD_SYSTEMIMAGE_PARTITION_SIZE * 1024
        }, {
                .name = "userdata",             /* 2rd primary partition */
                .type = "ext4",
                .size_kb = BOARD_USERDATAIMAGE_PARTITION_SIZE * 1024
        }, {
                .name = "cache",                /* 3rd parimary partition */
                .type = "ext4",
                .size_kb = BOARD_CACHEIMAGE_PARTITION_SIZE * 1024
        }, {
                .name = "fat",                  /* 1st primary partition */
                .type = "vfat",
                /* FIXME: MUST fit in remaind blocks after followed by this */
                .size_kb = 1024 * 1024,
        }, {
                .name = 0,
                .type = 0,
                .size_kb = 0
        },
};
#else
struct fbt_partition sys_partitions[] = {
        {
                .name = "-SPL",         /* SPL */
                .type = "raw",
                .size_kb = 32
        }, {
                .name = "bootloader",
                .type = "raw",
                .size_kb = 684       /* SPL + BCB */
        }, {
                .name = "bcb",          /* Bootloader control block */
                .type = "raw",
                .size_kb = 4
        }, {
                .name = CONFIG_ENV_BLK_PARTITION,       /* "environment" */
                .type = "raw",
                .size_kb = CONFIG_ENV_SIZE / 1024
        }, {
                .name = "dtb",          /* Device Tree */
                .type= "raw",
                .size_kb = 64
        }, {
                .name = "boot",         /* Boot image */
                .type = "boot",
                .size_kb = 16 * 1024
        }, {
                .name = "recovery",     /* Recovery Image */
                .type = "boot",
                .size_kb = 12 * 1024
        }, {
                .name = "logo",         /* Logo */
                .type = "raw",
                .size_kb = 2 * 1024
        }, {
                .name = 0,
                .type = 0,
                .size_kb = 0
        },
};

struct fbt_partition fbt_partitions[] = {
	{
                .name = "cache",	/* mmcblk0p3 */
                .type = "ext4",
                .size_kb = 1024 * 1024
        },
        {
                .name = "system",	/* mmcblk0p2 */
                .type = "ext4",
                .size_kb = 1024 * 1024
        },
	{
                .name = "fat",		/* mmcblk0p1 */
                .type = "vfat",
                .size_kb = 128 * 1024,
        },
	{
                .name = "userdata",	/* mmcblk0p4 */
                .type = "ext4",
                .size_kb = 0	/* remaining area */
        },
		{
                .name = 0,
                .type = 0,
                .size_kb = 0
        },
};
#endif /* CONFIG_ODROIDC_REV2 */

static unsigned userptn_start_lba = 0;
static unsigned userptn_end_lba = 0;

void board_user_partition(unsigned *start, unsigned *end)
{
        *start = userptn_start_lba;
        *end = userptn_end_lba;
}

void board_print_partition(block_dev_desc_t *blkdev, disk_partition_t *ptn)
{
        u64 length = (u64)blkdev->blksz * ptn->size;

        if (length > (1024 * 1024))
                printf(" %8lu  %12llu(%7lluM)  %s\n",
                                ptn->start,
                                length, length / (1024*1024),
                                ptn->name);
        else
                printf(" %8lu  %12llu(%7lluK)  %s\n",
                                ptn->start,
                                length, length / 1024,
                                ptn->name);
}

int board_find_partition(const char *name, unsigned *start, unsigned *bytes)
{
        int n;
        unsigned next = 0;

        for (n = 0; sizeof(sys_partitions) / sizeof(sys_partitions[0]); n++) {
                struct fbt_partition *fbt = &sys_partitions[n];

                if (!fbt->name || !fbt->size_kb || !fbt->type)
                        break;

                if (!strcmp(name, fbt->name)) {
                        *start = next;
                        *bytes = fbt->size_kb * 1024;
                        return 0;
                }

                next += fbt->size_kb * 2;
        }

        return -EEXIST;
}

int board_fbt_load_ptbl()
{
#if !defined(CONFIG_ODROIDC_REV2)
        char *android_name[] = {
                "fat",
                "system",
                "userdata",
                "cache",
        };
#else
        char *android_name[] = {
                "fat",
                "system",
                "cache",
                "userdata",
        };
#endif
        disk_partition_t ptn;
        int n;
        int res = -1;
        block_dev_desc_t *blkdev;
        unsigned next;

        blkdev = get_dev_by_name(FASTBOOT_BLKDEV);
        if (!blkdev) {
                printf("error getting device %s\n", FASTBOOT_BLKDEV);
                return -1;
        }

        if (!blkdev->lba) {
                printf("device %s has no space\n", FASTBOOT_BLKDEV);
                return -1;
        }

        init_part(blkdev);
        if (blkdev->part_type == PART_TYPE_UNKNOWN) {
                printf("unknown partition table on %s\n", FASTBOOT_BLKDEV);
                return -1;
        }

        printf("lba size = %lu\n", blkdev->blksz);
        printf("lba_start      partition_size          name\n");
        printf("=========  ======================  ==============\n");

        next = 0;
        for (n = 0; sizeof(sys_partitions) / sizeof(sys_partitions[0]); n++) {
                struct fbt_partition *fbt = &sys_partitions[n];

                if (!fbt->name || !fbt->size_kb || !fbt->type)
                        break;

                /* The partition start with '-' will be hidden */
                if (fbt->name[0] == '-') {
                        next += fbt->size_kb * 2;
                        continue;
                }

                ptn.start = next;
                ptn.size = fbt->size_kb * 2;
                ptn.blksz = blkdev->blksz;
                strncpy(ptn.name, fbt->name, sizeof(ptn.name));
                strncpy(ptn.type, fbt->type, sizeof(ptn.type));

                fbt_add_ptn(&ptn);
                board_print_partition(blkdev, &ptn);

                next += ptn.size;
        }

        userptn_start_lba = next;
        userptn_end_lba = blkdev->lba - 1;

        for (n = CONFIG_MIN_PARTITION_NUM; n <= CONFIG_MAX_PARTITION_NUM; n++) {
                if (get_partition_info(blkdev, n, &ptn))
                        continue;       /* No partition <n> */
                if (!ptn.size || !ptn.blksz || !ptn.name[0])
                        continue;       /* Partition <n> is empty (or sick) */

                /* Rename the partition names on MBR to Android partition names */
                if ((n > 0) && (n <= (sizeof(android_name)
                                                / sizeof(android_name[0])))) {
                        strcpy(ptn.name, android_name[n - 1]);
                }

                fbt_add_ptn(&ptn);

                board_print_partition(blkdev, &ptn);

                if ((ptn.start < userptn_start_lba)
                                || (ptn.start + ptn.size  > userptn_end_lba)) {
                        printf("  ** Partition is not allocated properly!!! **\n");
                }

                res = 0;
        }

        printf("=========  ======================  ==============\n");

        return res;
}

int board_fbt_handle_flash(disk_partition_t *ptn,
                struct cmd_fastboot_interface *priv)
{
        if (!strcmp("bootloader", ptn->name)
                        && (0 == ptn->start)) {
                lbaint_t blkcnt = 1;
                char sector[512];
                int err = partition_read_blks(priv->dev_desc, ptn,
                                &blkcnt, sector);
                if (err) {
                        printf("failed to read MBR, error=%d\n", err);
                        return err;
                }

                memcpy(priv->transfer_buffer + 442,
                                &sector[442], sizeof(sector) - 442);
        }

        return 0;
}
#endif
