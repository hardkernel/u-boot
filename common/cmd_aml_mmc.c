/*
 * (C) Copyright 2003
 * Kyle Harris, kharris@nexus-tech.net
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
#include <malloc.h>
#include <command.h>
#include <linux/ctype.h>
#include <mmc.h>
#include <partition_table.h>
#include <emmc_partitions.h>
#include <asm/arch/cpu_sdio.h>
#include <asm/arch/sd_emmc.h>
#include <linux/sizes.h>
#include <asm/cpu_id.h>
#include <amlogic/aml_mmc.h>

/* info system. */
#define dtb_err(fmt, ...) printf( "%s()-%d: " fmt , \
                  __func__, __LINE__, ##__VA_ARGS__)

#define dtb_wrn(fmt, ...) printf( "%s()-%d: " fmt , \
                  __func__, __LINE__, ##__VA_ARGS__)

/* for detail debug info */
#define dtb_info(fmt, ...) printf( "%s()-%d: " fmt , \
                  __func__, __LINE__, ##__VA_ARGS__)

struct aml_dtb_rsv {
    u8 data[DTB_BLK_SIZE*DTB_BLK_CNT - 4*sizeof(u32)];
    u32 magic;
    u32 version;
    u32 timestamp;
    u32 checksum;
};

struct aml_dtb_info {
    u32 stamp[2];
    u8 valid[2];
};

#define stamp_after(a,b)   ((int)(b) - (int)(a)  < 0)
/* glb dtb infos */
static struct aml_dtb_info dtb_infos = {{0, 0}, {0, 0}};

#define CONFIG_SECURITYKEY

#if !defined(CONFIG_SYS_MMC_BOOT_DEV)
    #define CONFIG_SYS_MMC_BOOT_DEV (CONFIG_SYS_MMC_ENV_DEV)
#endif

#define GXB_START_BLK   0
#define GXL_START_BLK   1

/* max 2MB for emmc in blks */
#define UBOOT_SIZE  (0x1000)

int info_disprotect = 0;

bool emmckey_is_protected (struct mmc *mmc)
{
#ifdef CONFIG_STORE_COMPATIBLE
#ifdef CONFIG_SECURITYKEY
    if (info_disprotect & DISPROTECT_KEY) {
        printf("%s(): disprotect\n", __func__);
        return 0;
    }else{
        printf("%s(): protect\n", __func__);
        return 1;
    }
#else
        return 0;
#endif
#else
#ifdef CONFIG_SECURITYKEY
        //return mmc->key_protect;
        return 0; /* fixme, */
#else
        return 0;
#endif
#endif
}

unsigned emmc_cur_partition = 0;

int mmc_read_status(struct mmc *mmc, int timeout)
{
    struct mmc_cmd cmd;
    int err, retries = 5;
    int status;

    cmd.cmdidx = MMC_CMD_SEND_STATUS;
    cmd.resp_type = MMC_RSP_R1;
    if (!mmc_host_is_spi(mmc))
        cmd.cmdarg = mmc->rca << 16;
    do {
        err = mmc_send_cmd(mmc, &cmd, NULL);
        if (!err) {
            if ((cmd.response[0] & MMC_STATUS_RDY_FOR_DATA) &&
                (cmd.response[0] & MMC_STATUS_CURR_STATE) !=
                 MMC_STATE_PRG)
                break;
            else if (cmd.response[0] & MMC_STATUS_MASK) {
                printf("Status Error: 0x%08X\n",
                    cmd.response[0]);
                return COMM_ERR;
            }
        } else if (--retries < 0)
            return err;

        udelay(1000);

    } while (timeout--);

    status = (cmd.response[0] & MMC_STATUS_CURR_STATE) >> 9;
    printf("CURR STATE:%d, status = 0x%x\n", status, cmd.response[0]);

    if (timeout <= 0) {
        printf("read status Timeout waiting card ready\n");
        return TIMEOUT;
    }
    if (cmd.response[0] & MMC_STATUS_SWITCH_ERROR) {
        printf("mmc status swwitch error status =0x%x\n", status);
        return SWITCH_ERR;
    }
    return 0;
}

static int get_off_size(struct mmc * mmc, char * name, uint64_t offset, uint64_t  size, u64 * blk, u64 * cnt, u64 * sz_byte)
{
        struct partitions *part_info = NULL;
        uint64_t off = 0;
        int blk_shift = 0;

        blk_shift =  ffs(mmc->read_bl_len) - 1;
        // printf("blk_shift:%d , off:0x%llx , size:0x%llx.\n ",blk_shift,off,size );
        part_info = find_mmc_partition_by_name(name);
        if (part_info == NULL) {
                printf("get partition info failed !!\n");
                return -1;
        }
        off = part_info->offset + offset;

        // printf("part_info->offset:0x%llx , off:0x%llx , size:0x%llx.\n",part_info->offset ,off,size);

        *blk = off >>  blk_shift ;
        *cnt = size >>  blk_shift ;
        *sz_byte = size - ((*cnt) << blk_shift) ;

        // printf("get_partition_off_size : blk:0x%llx , cnt:0x%llx.\n",*blk,*cnt);
        return 0;
}

static int get_partition_size(unsigned char* name, uint64_t* addr)
{
        struct partitions *part_info = NULL;
        part_info = find_mmc_partition_by_name((char *)name);
        if (part_info == NULL) {
                printf("get partition info failed !!\n");
                return -1;
        }

        *addr = part_info->size >> 9; // unit: 512 bytes
        return 0;
}

static inline int isstring(char *p)
{
    char *endptr = p;
    while (*endptr != '\0') {
        if (!(((*endptr >= '0') && (*endptr <= '9'))
                || ((*endptr >= 'a') && (*endptr <= 'f'))
                || ((*endptr >= 'A') && (*endptr <= 'F'))
                || (*endptr == 'x') || (*endptr == 'X')))
            return 1;
        endptr++;
    }

    return 0;
}

/*
    erase bootloader on user/boot0/boot1 which indicate by map.
    bit 0: user
    bit 1: boot0
    bit 2: boot1
*/
int amlmmc_erase_bootloader(int dev, int map)
{
    int ret = 0, i, count = 3;
    int blk_shift;
    unsigned long n;
    char *partname[3] = {"user", "boot0", "boot1"};
    cpu_id_t cpu_id = get_cpu_id();
    struct mmc *mmc = find_mmc_device(dev);

    /* do nothing */
    if (0 == map)
        goto _out;

    if (!mmc) {
        printf("%s() %d: not valid emmc %d\n", __func__, __LINE__, dev);
        ret = -1;
        goto _out;
    }
    /* make sure mmc is initilized! */
    ret = mmc_init(mmc);
    if (ret) {
        printf("%s() %d: emmc %d init %d\n", __func__, __LINE__, dev, ret);
        ret = -2;
        goto _out;
    }

    blk_shift = ffs(mmc->read_bl_len) -1;
    /* erase bootloader in user/boot0/boot1 */
    for (i = 0; i < count; i++) {
        if (map & (0x1 << i)) {
            if (!mmc_select_hwpart(dev, i)) {
                lbaint_t start = 0, blkcnt;

                blkcnt = mmc->capacity >> blk_shift;
                if (0 == i) {
                    struct partitions *part_info;
                    /* get info by partition */
                    part_info = find_mmc_partition_by_name(MMC_BOOT_NAME);
                    if (part_info == NULL) {
                        printf("%s() %d: error!!\n", __func__, __LINE__);
                        /* fixme, do somthing! */
                        continue;
                    } else {
                        start = part_info->offset>> blk_shift;
                        blkcnt = part_info->size>> blk_shift;
                        if (cpu_id.family_id >= MESON_CPU_MAJOR_ID_GXL) {
                            start = GXL_START_BLK;
                            blkcnt -= GXL_START_BLK;
                        }
                    }
                }
/* some customer may use boot1 higher 2M as private data. */
#ifdef CONFIG_EMMC_BOOT1_TOUCH_REGION
                if (2 == i && CONFIG_EMMC_BOOT1_TOUCH_REGION <= mmc->capacity) {
                    blkcnt = CONFIG_EMMC_BOOT1_TOUCH_REGION >> blk_shift;
                }
#endif/* CONFIG_EMMC_BOOT1_TOUCH_REGION */
                printf("Erasing blocks " LBAFU " to " LBAFU " @ %s\n",
                   start, blkcnt, partname[i]);
                n = mmc->block_dev.block_erase(dev, start, blkcnt);
                if (n != 0) {
                    printf("mmc erase %s failed\n", partname[i]);
                    ret = -3;
                    break;
                }
            } else
                printf("%s() %d: switch dev %d to %s fail\n",
                        __func__, __LINE__, dev, partname[i]);
        }
    }
    /* try to switch back to user. */
    mmc_select_hwpart(dev, 0);

_out:
    return ret;
}

/*
    write bootloader on user/boot0/boot1 which indicate by map.
    bit 0: user
    bit 1: boot0
    bit 2: boot1
*/
int amlmmc_write_bootloader(int dev, int map, unsigned int size, const void *src)
{
    int ret = 0, i, count = 3;
    unsigned long n;
    char *partname[3] = {"user", "boot0", "boot1"};
    struct mmc *mmc = find_mmc_device(dev);
    lbaint_t start = GXB_START_BLK, blkcnt;
    cpu_id_t cpu_id = get_cpu_id();

    /* do nothing */
    if (0 == map)
        goto _out;

    if (!mmc) {
        printf("%s() %d: not valid emmc %d\n", __func__, __LINE__, dev);
        ret = -1;
        goto _out;
    }
    /* make sure mmc is initilized! */
    ret = mmc_init(mmc);
    if (ret) {
        printf("%s() %d: emmc %d init %d\n", __func__, __LINE__, dev, ret);
        ret = -2;
        goto _out;
    }

    if (cpu_id.family_id >= MESON_CPU_MAJOR_ID_GXL)
        start = GXL_START_BLK;
    blkcnt = (size + mmc->read_bl_len - 1) / mmc->read_bl_len;

    /* erase bootloader in user/boot0/boot1 */
    for (i = 0; i < count; i++) {
        if (map & (0x1 << i)) {
            if (!mmc_select_hwpart(dev, i)) {
/* some customer may use boot1 higher 2M as private data. */
#ifdef CONFIG_EMMC_BOOT1_TOUCH_REGION
                if (2 == i && CONFIG_EMMC_BOOT1_TOUCH_REGION <= size) {
                    printf("%s(), size %d exceeds TOUCH_REGION %d, skip\n",
                        __func__, size, CONFIG_EMMC_BOOT1_TOUCH_REGION);
                    break;
                }
#endif /* CONFIG_EMMC_BOOT1_TOUCH_REGION */
                printf("Wrting blocks " LBAFU " to " LBAFU " @ %s\n",
                   start, blkcnt, partname[i]);
                n = mmc->block_dev.block_write(dev, start, blkcnt, src);
                if (n != blkcnt) {
                    printf("mmc write %s failed\n", partname[i]);
                    ret = -3;
                    break;
                }
            } else
                printf("%s() %d: switch dev %d to %s fail\n",
                        __func__, __LINE__, dev, partname[i]);
        }
    }
    /* try to switch back to user. */
    mmc_select_hwpart(dev, 0);

_out:
    return ret;
}

static int amlmmc_erase_in_dev(int argc, char *const argv[])
{
    int dev = 0;
    u64 cnt = 0, blk = 0, n = 0;
    struct mmc *mmc;

    dev = simple_strtoul(argv[2], NULL, 10);
    blk = simple_strtoull(argv[3], NULL, 16);
    cnt = simple_strtoull(argv[4], NULL, 16);

    if (dev < 0) {
        printf("Cannot find dev.\n");
        return 1;
    }

    mmc = find_mmc_device(dev);

    if (!mmc)
        return 1;

    printf("MMC erase: dev # %d, start_erase_address(in block) # %#llx,\
            several blocks  # %lld will be erased ...\n ",
            dev, blk, cnt);

    mmc_init(mmc);

    if (cnt != 0)
        n = mmc->block_dev.block_erase(dev, blk, cnt);

    printf("dev # %d, %s, several blocks erased %s\n",
                dev, " ", (n == 0) ? "OK" : "ERROR");

    return (n == 0) ? 0 : 1;
}

static int amlmmc_erase_in_card(int argc, char *const argv[])
{
    int dev = 0;
    u64 cnt = 0, blk = 0, n = 0;
    /*sz_byte =0;*/
    char *name = NULL;
    u64 offset_addr = 0, size = 0;
    struct mmc *mmc;
    int tmp_shift;

    name = argv[2];
    dev = find_dev_num_by_partition_name (name);
    offset_addr = simple_strtoull(argv[3], NULL, 16);
    size = simple_strtoull(argv[4], NULL, 16);
    mmc = find_mmc_device(dev);

    tmp_shift = ffs(mmc->read_bl_len) -1;
    cnt = size >> tmp_shift;
    blk = offset_addr >> tmp_shift;
    /* sz_byte = size - (cnt<<tmp_shift); */

    if (dev < 0) {
        printf("Cannot find dev.\n");
        return 1;
    }

    mmc = find_mmc_device(dev);

    if (!mmc)
        return 1;

    printf("MMC erase: dev # %d, start_erase_address(in block) # %#llx,\
            several blocks  # %lld will be erased ...\n ",
            dev, blk, cnt);

    mmc_init(mmc);

    if (cnt != 0)
        n = mmc->block_dev.block_erase(dev, blk, cnt);

    printf("dev # %d, %s, several blocks erased %s\n",
                dev, argv[2], (n == 0) ? "OK" : "ERROR");

    return (n == 0) ? 0 : 1;
}

static int amlmmc_erase_in_part(int argc, char *const argv[])
{
    int dev = 0;
    u64 cnt = 0, blk = 0, n = 0, sz_byte =0;
    char *name = NULL;
    u64 offset_addr = 0, size = 0;
    struct mmc *mmc;
    struct partitions *part_info;

    name = argv[2];
    dev = find_dev_num_by_partition_name (name);
    offset_addr = simple_strtoull(argv[3], NULL, 16);
    size = simple_strtoull(argv[4], NULL, 16);
    part_info = find_mmc_partition_by_name(name);
    mmc = find_mmc_device(dev);

    if (offset_addr >= part_info->size) {
        printf("Start address out #%s# partition'address region,(addr_byte < 0x%llx)\n",
                        name, part_info->size);
        return 1;
    }
    if ((offset_addr+size) > part_info->size) {
        printf("End address exceeds #%s# partition,(offset = 0x%llx,size = 0x%llx)\n",
                        name, part_info->offset,part_info->size);
        return 1;
    }
    get_off_size(mmc, name, offset_addr, size, &blk, &cnt, &sz_byte);

    if (dev < 0) {
        printf("Cannot find dev.\n");
        return 1;
    }


    if (!mmc)
        return 1;

    printf("MMC erase: dev # %d, start_erase_address(in block) # %#llx,\
            several blocks  # %lld will be erased ...\n ",
            dev, blk, cnt);

    mmc_init(mmc);

    if (cnt != 0)
        n = mmc->block_dev.block_erase(dev, blk, cnt);

    printf("dev # %d, %s, several blocks erased %s\n",
                dev, argv[2], (n == 0) ? "OK" : "ERROR");

    return (n == 0) ? 0 : 1;
}

static int amlmmc_erase_by_add(int argc, char *const argv[])
{
    int ret = 0;

    if (argc != 5)
        return CMD_RET_USAGE;

    if (isdigit(argv[2][0]))
        ret = amlmmc_erase_in_dev(argc, argv);
    else if (strcmp(argv[2], "card") == 0)
        ret = amlmmc_erase_in_card(argc, argv);
    else if (isstring(argv[2]))
        ret = amlmmc_erase_in_part(argc, argv);

    return ret;
}

static int amlmmc_erase_non_loader(int argc, char *const argv[])
{
    int dev;
    u32 n = 0;
    int blk_shift;
    u64 blk = 0, start_blk = 0;
    struct partitions *part_info;
    struct mmc *mmc;

    dev = 1;
    if (dev < 0) {
        printf("Cannot find dev.\n");
        return 1;
    }
    mmc = find_mmc_device(dev);

    if (!mmc)
        return 1;

    mmc_init(mmc);

    blk_shift = ffs(mmc->read_bl_len) -1;
    part_info = find_mmc_partition_by_name(MMC_BOOT_NAME);

    if (part_info == NULL) {
        start_blk = 0;
        printf("no uboot partition for eMMC boot, just erase from 0\n");
    }
    else
        start_blk = (part_info->offset + part_info->size) >> blk_shift;

    if (emmckey_is_protected(mmc)) {
        part_info = find_mmc_partition_by_name(MMC_RESERVED_NAME);
        if (part_info == NULL) {
            return 1;
        }
        blk = part_info->offset;
        // it means: there should be other partitions before reserve-partition.
        if (blk > 0)
            blk -= PARTITION_RESERVED;
        blk >>= blk_shift;
        blk -= start_blk;
        // (1) erase all the area before reserve-partition
        if (blk > 0)
            n = mmc->block_dev.block_erase(dev, start_blk, blk);
        if (n == 0) { // not error
            // (2) erase all the area after reserve-partition
            start_blk = (part_info->offset + part_info->size + PARTITION_RESERVED)
                         >> blk_shift;
            u64 erase_cnt = (mmc->capacity >> blk_shift) - 1 - start_blk;
            n = mmc->block_dev.block_erase(dev, start_blk, erase_cnt);
        }
    } else {
        n = mmc->block_dev.block_erase(dev, start_blk, 0); // erase the whole card
    }
    return (n == 0) ? 0 : 1;
}

static int amlmmc_erase_single_part(int argc, char *const argv[])
{
    char *name = NULL;
    int dev;
    u32 n = 0;
    int blk_shift;
    u64 cnt = 0, blk = 0;
    struct partitions *part_info;
    struct mmc *mmc;

    name = argv[2];
    dev = find_dev_num_by_partition_name(name);
    if (dev < 0) {
        printf("Cannot find dev.\n");
        return 1;
    }
    mmc = find_mmc_device(dev);

    if (!mmc)
        return 1;

    mmc_init(mmc);

    blk_shift = ffs(mmc->read_bl_len) -1;
    if (emmckey_is_protected(mmc)
        && (strncmp(name, MMC_RESERVED_NAME, sizeof(MMC_RESERVED_NAME)) == 0x00)) {
        printf("\"%s-partition\" is been protecting and should no be erased!\n",
                MMC_RESERVED_NAME);
        return 1;
    }

    part_info = find_mmc_partition_by_name(name);
    if (part_info == NULL) {
        return 1;
    }

    blk = part_info->offset >> blk_shift;
    if (emmc_cur_partition && !strncmp(name, "bootloader", strlen("bootloader")))
        cnt = mmc->boot_size >> blk_shift;
    else
        cnt = part_info->size >> blk_shift;
    n = mmc->block_dev.block_erase(dev, blk, cnt);

    return (n == 0) ? 0 : 1;
}

static int amlmmc_erase_whole(int argc, char *const argv[])
{
    char *name = NULL;
    int dev;
    u32 n = 0;
    int blk_shift;
    //u64 cnt = 0,
    u64 blk = 0, start_blk = 0;
    struct partitions *part_info;
    struct mmc *mmc;
    int map;

    name = "logo";
    dev = find_dev_num_by_partition_name(name);
    if (dev < 0) {
        printf("Cannot find dev.\n");
        return 1;
    }
    mmc = find_mmc_device(dev);
    if (!mmc)
        return 1;
    mmc_init(mmc);
    blk_shift = ffs(mmc->read_bl_len) -1;
    start_blk = 0;

    if (emmckey_is_protected(mmc)) {
        part_info = find_mmc_partition_by_name(MMC_RESERVED_NAME);
        if (part_info == NULL) {
            return 1;
        }
        blk = part_info->offset;
        // it means: there should be other partitions before reserve-partition.
        if (blk > 0)
            blk -= PARTITION_RESERVED;
        blk >>= blk_shift;
        blk -= start_blk;
        // (1) erase all the area before reserve-partition
        if (blk > 0)
            n = mmc->block_dev.block_erase(dev, start_blk, blk);
        if (n == 0) { // not error
            // (2) erase all the area after reserve-partition
            start_blk = (part_info->offset + part_info->size + PARTITION_RESERVED)
                         >> blk_shift;
            u64 erase_cnt = (mmc->capacity >> blk_shift) - 1 - start_blk;
            n = mmc->block_dev.block_erase(dev, start_blk, erase_cnt);
        }
    } else {
        n = mmc->block_dev.block_erase(dev, start_blk, 0); // erase the whole card
    }
    map = AML_BL_BOOT;
    if (n == 0)
        n = amlmmc_erase_bootloader(dev, map);
    if (n)
        printf("erase bootloader in boot partition failed\n");
    return (n == 0) ? 0 : 1;
}

static int amlmmc_erase_non_cache(int arc, char *const argv[])
{
    char *name = NULL;
    int dev;
    u32 n = 0;
    int blk_shift;
    u64 blk = 0, start_blk = 0;
    struct partitions *part_info;
    struct mmc *mmc;
    int map;

    name = "logo";
    dev = find_dev_num_by_partition_name(name);
    if (dev < 0) {
         printf("Cannot find dev.\n");
         return 1;
     }
     mmc = find_mmc_device(dev);
     if (!mmc)
         return 1;
     mmc_init(mmc);
     blk_shift = ffs(mmc->read_bl_len) -1;
     if (emmckey_is_protected(mmc)) {
         part_info = find_mmc_partition_by_name(MMC_RESERVED_NAME);
         if (part_info == NULL) {
             return 1;
         }

         blk = part_info->offset;
         // it means: there should be other partitions before reserve-partition.
        if (blk > 0) {
            blk -= PARTITION_RESERVED;
         }
         blk >>= blk_shift;
         blk -= start_blk;
         // (1) erase all the area before reserve-partition
         if (blk > 0) {
             n = mmc->block_dev.block_erase(dev, start_blk, blk);
             // printf("(1) erase blk: 0 --> %llx %s\n", blk, (n == 0) ? "OK" : "ERROR");
         }
         if (n == 0) { // not error
             // (2) erase all the area after reserve-partition
             part_info = find_mmc_partition_by_name(MMC_CACHE_NAME);
             if (part_info == NULL) {
                 return 1;
             }
             start_blk = (part_info->offset + part_info->size + PARTITION_RESERVED)
                          >> blk_shift;
             u64 erase_cnt = (mmc->capacity >> blk_shift) - 1 - start_blk;
             n = mmc->block_dev.block_erase(dev, start_blk, erase_cnt);
         }
     } else {
         n = mmc->block_dev.block_erase(dev, start_blk, 0); // erase the whole card
     }
     map = AML_BL_BOOT;
     if (n == 0) {
         n = amlmmc_erase_bootloader(dev, map);
         if (n)
             printf("erase bootloader in boot partition failed\n");
     }
     return (n == 0) ? 0 : 1;
}

static int amlmmc_erase_dev(int argc, char *const argv[])
{
    return amlmmc_erase_whole(argc, argv);
}

static int amlmmc_erase_allbootloader(int argc, char*const argv[])
{
    int map;
    int rc;
    char *name = NULL;
    int dev;
    map = AML_BL_ALL;

    name = "bootloader";
    dev = find_dev_num_by_partition_name(name);

    if (dev < 0) {
        printf("Cannot find dev.\n");
        return 1;
    }

    rc = amlmmc_erase_bootloader(dev, map);
    return rc;
}

static int amlmmc_erase_by_part(int argc, char *const argv[])
{
    int ret = CMD_RET_USAGE;

    if (argc != 3)
        return ret;

    if (isdigit(argv[2][0]))
        ret = amlmmc_erase_dev(argc, argv);
    else if (strcmp(argv[2], "whole") == 0)
        ret = amlmmc_erase_whole(argc, argv);
    else if (strcmp(argv[2], "non_cache") == 0)
        ret = amlmmc_erase_non_cache(argc, argv);
    else if (strcmp(argv[2], "non_loader") == 0)
        ret = amlmmc_erase_non_loader(argc, argv);
    else if (strcmp(argv[2], "allbootloader") == 0)
        ret = amlmmc_erase_allbootloader(argc, argv);
    else
        ret = amlmmc_erase_single_part(argc, argv);
    return ret;
}

static int do_amlmmc_erase(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
    int ret = CMD_RET_USAGE;

    if (argc == 3)
        ret = amlmmc_erase_by_part(argc, argv);
    else if (argc == 5)
        ret = amlmmc_erase_by_add(argc, argv);

    return ret;
}

static int amlmmc_write_in_part(int argc, char *const argv[])
{
    int dev;
    void *addr = NULL;
    u64 cnt = 0, n = 0, blk = 0, sz_byte = 0;
    char *name = NULL;
    u64 offset = 0, size = 0;
    cpu_id_t cpu_id = get_cpu_id();
    struct mmc *mmc;

    name = argv[2];
    if (strcmp(name, "bootloader") == 0)
        dev = CONFIG_SYS_MMC_BOOT_DEV;
    else
        dev = find_dev_num_by_partition_name (name);
    addr = (void *)simple_strtoul(argv[3], NULL, 16);
    offset  = simple_strtoull(argv[4], NULL, 16);
    size = simple_strtoull(argv[5], NULL, 16);
    if (dev < 0) {
        printf("Cannot find dev.\n");
        return 1;
    }
    mmc = find_mmc_device(dev);
    if (!mmc)
        return 1;

    if (strcmp(name, "bootloader") == 0) {
        cnt = UBOOT_SIZE;
        if (cpu_id.family_id >= MESON_CPU_MAJOR_ID_GXL) {
            blk = GXL_START_BLK;
            cnt -= GXL_START_BLK;
        }
        else
            blk = GXB_START_BLK;
    } else
        get_off_size(mmc, name, offset, size, &blk, &cnt, &sz_byte);

    mmc_init(mmc);
    n = mmc->block_dev.block_write(dev, blk, cnt, addr);
    //write sz_byte bytes
    if ((n == cnt) && (sz_byte != 0)) {
        // printf("sz_byte=%#llx bytes\n",sz_byte);
        void *addr_tmp = malloc(mmc->write_bl_len);
        void *addr_byte = (void*)(addr+cnt*(mmc->write_bl_len));
        ulong start_blk = blk+cnt;

        if (addr_tmp == NULL) {
            printf("mmc write: malloc fail\n");
            return 1;
        }

        if (mmc->block_dev.block_read(dev, start_blk, 1, addr_tmp) != 1) { // read 1 block
            free(addr_tmp);
            printf("mmc read 1 block fail\n");
            return 1;
        }

        memcpy(addr_tmp, addr_byte, sz_byte);
        if (mmc->block_dev.block_write(dev, start_blk, 1, addr_tmp) != 1) { // write 1 block
            free(addr_tmp);
            printf("mmc write 1 block fail\n");
            return 1;
        }
        free(addr_tmp);
    }
    //printf("%#llx blocks , %#llx bytes written: %s\n", n, sz_byte, (n==cnt) ? "OK" : "ERROR");
    return (n == cnt) ? 0 : 1;
}

static int amlmmc_write_in_card(int argc, char *const argv[])
{
    int dev;
    void *addr = NULL;
    u64 cnt = 0, n = 0, blk = 0, sz_byte = 0;
    char *name = NULL;
    u64 offset = 0, size = 0;
    struct mmc *mmc;

    name = argv[2];
    dev = find_dev_num_by_partition_name (name);
    addr = (void *)simple_strtoul(argv[3], NULL, 16);
    offset  = simple_strtoull(argv[4], NULL, 16);
    size = simple_strtoull(argv[5], NULL, 16);
    if (dev < 0) {
        printf("Cannot find dev.\n");
        return 1;
    }
    mmc = find_mmc_device(dev);
    if (!mmc)
        return 1;

    int blk_shift = ffs( mmc->read_bl_len) -1;
    cnt = size >> blk_shift;
    blk = offset >> blk_shift;
    sz_byte = size - (cnt<<blk_shift);
     mmc_init(mmc);

    n = mmc->block_dev.block_write(dev, blk, cnt, addr);

    //write sz_byte bytes
    if ((n == cnt) && (sz_byte != 0)) {
        // printf("sz_byte=%#llx bytes\n",sz_byte);
        void *addr_tmp = malloc(mmc->write_bl_len);
        void *addr_byte = (void*)(addr+cnt*(mmc->write_bl_len));
        ulong start_blk = blk+cnt;

        if (addr_tmp == NULL) {
            printf("mmc write: malloc fail\n");
            return 1;
        }

        if (mmc->block_dev.block_read(dev, start_blk, 1, addr_tmp) != 1) { // read 1 block
            free(addr_tmp);
            printf("mmc read 1 block fail\n");
            return 1;
        }

        memcpy(addr_tmp, addr_byte, sz_byte);
        if (mmc->block_dev.block_write(dev, start_blk, 1, addr_tmp) != 1) { // write 1 block
            free(addr_tmp);
            printf("mmc write 1 block fail\n");
            return 1;
        }
        free(addr_tmp);
    }
    //printf("%#llx blocks , %#llx bytes written: %s\n", n, sz_byte, (n==cnt) ? "OK" : "ERROR");
    return (n == cnt) ? 0 : 1;
}

static int amlmmc_write_in_dev(int argc, char *const argv[])
{
    int dev;
    void *addr = NULL;
    u64 cnt = 0, n = 0, blk = 0;
    struct mmc *mmc;
    dev = simple_strtoul(argv[2], NULL, 10);
    addr = (void *)simple_strtoul(argv[3], NULL, 16);
    blk = simple_strtoull(argv[4], NULL, 16);
    cnt = simple_strtoull(argv[5], NULL, 16);
    if (dev < 0) {
        printf("Cannot find dev.\n");
        return 1;
    }
    mmc = find_mmc_device(dev);
    if (!mmc)
        return 1;

     //printf("MMC write: dev # %d, block # %#llx, count # %#llx ... ",
     //dev, blk, cnt);

    mmc_init(mmc);

    n = mmc->block_dev.block_write(dev, blk, cnt, addr);
    return (n == cnt) ? 0 : 1;
}

static int do_amlmmc_write(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
    int ret = 0;
    if (argc != 6)
        return CMD_RET_USAGE;

    if (isdigit(argv[2][0]))
        ret = amlmmc_write_in_dev(argc, argv);
    else if (strcmp(argv[2], "card") == 0)
        ret = amlmmc_write_in_card(argc, argv);
    else if (isstring(argv[2]))
        ret = amlmmc_write_in_part(argc, argv);

    return ret;
}

static int amlmmc_read_in_dev(int argc, char *const argv[])
{
    int dev;
    void *addr = NULL;
    u64 cnt =0, n = 0, blk = 0;
    struct mmc *mmc;

    dev = simple_strtoul(argv[2], NULL, 10);
    addr = (void *)simple_strtoul(argv[3], NULL, 16);
    blk = simple_strtoull(argv[4], NULL, 16);
    cnt = simple_strtoull(argv[5], NULL, 16);

    if (dev < 0) {
        printf("Cannot find dev.\n");
        return 1;
    }

    mmc = find_mmc_device(dev);
    if (!mmc)
        return 1;
    n = mmc->block_dev.block_read(dev, blk, cnt, addr);

    return (n == cnt) ? 0 : 1;
}

static int amlmmc_read_in_card(int argc, char *const argv[])
{
    int dev;
    void *addr = NULL;
    //u32 flag =0;
    u64 cnt =0, n = 0, blk = 0, sz_byte = 0;
    char *name = NULL;
    u64 offset = 0, size = 0;
    int blk_shift;
    struct mmc *mmc;
    void *addr_tmp;
    void *addr_byte;
    ulong start_blk;

    name = argv[2];
    dev = find_dev_num_by_partition_name (name);
    addr = (void *)simple_strtoul(argv[3], NULL, 16);
    size = simple_strtoull(argv[5], NULL, 16);
    offset = simple_strtoull(argv[4], NULL, 16);

    if (dev < 0) {
        printf("Cannot find dev.\n");
        return 1;
    }

    mmc = find_mmc_device(dev);
    if (!mmc)
        return 1;

    blk_shift = ffs( mmc->read_bl_len) - 1;
    cnt = size >> blk_shift;
    blk = offset >> blk_shift;
    sz_byte = size - (cnt<<blk_shift);

    mmc_init(mmc);
    n = mmc->block_dev.block_read(dev, blk, cnt, addr);

    //read sz_byte bytes
    if ((n == cnt) && (sz_byte != 0)) {
       addr_tmp = malloc(mmc->read_bl_len);
       addr_byte = (void *)(addr+cnt*(mmc->read_bl_len));
       start_blk = blk+cnt;
       if (addr_tmp == NULL) {
           printf("mmc read: malloc fail\n");
           return 1;
       }
       if (mmc->block_dev.block_read(dev, start_blk, 1, addr_tmp) != 1) { // read 1 block
           free(addr_tmp);
           printf("mmc read 1 block fail\n");
           return 1;
       }
       memcpy(addr_byte, addr_tmp, sz_byte);
       free(addr_tmp);
    }
    return (n == cnt) ? 0 : 1;
}

static int amlmmc_read_in_part(int argc, char *const argv[])
{
    int dev;
    void *addr = NULL;
    u64 cnt = 0, n = 0, blk = 0, sz_byte = 0;
    char *name = NULL;
    u64 offset = 0, size = 0;
    struct mmc *mmc;
    void *addr_tmp;
    void *addr_byte;
    ulong start_blk;

    name = argv[2];
    dev = find_dev_num_by_partition_name (name);
    addr = (void *)simple_strtoul(argv[3], NULL, 16);
    offset = simple_strtoull(argv[4], NULL, 16);
    size = simple_strtoull(argv[5], NULL, 16);

    if (dev < 0) {
        printf("Cannot find dev.\n");
        return 1;
    }

    mmc = find_mmc_device(dev);
    if (!mmc)
        return 1;

    get_off_size(mmc, name, offset, size, &blk, &cnt, &sz_byte);
    mmc_init(mmc);
    n = mmc->block_dev.block_read(dev, blk, cnt, addr);

    //read sz_byte bytes
    if ((n == cnt) && (sz_byte != 0)) {
       /*printf("sz_byte=%#llx bytes\n",sz_byte);*/
       addr_tmp = malloc(mmc->read_bl_len);
       addr_byte = (void *)(addr+cnt*(mmc->read_bl_len));
       start_blk = blk+cnt;

       if (addr_tmp == NULL) {
           printf("mmc read: malloc fail\n");
           return 1;
       }

       if (mmc->block_dev.block_read(dev, start_blk, 1, addr_tmp) != 1) { // read 1 block
           free(addr_tmp);
           printf("mmc read 1 block fail\n");
           return 1;
       }

       memcpy(addr_byte, addr_tmp, sz_byte);
       free(addr_tmp);
    }
    return (n == cnt) ? 0 : 1;
}

static int do_amlmmc_read(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
    int ret = 0;

    if (argc != 6)
        return CMD_RET_USAGE;

    if (isdigit(argv[2][0]))
        ret = amlmmc_read_in_dev(argc, argv);
    else if (strcmp(argv[2], "card") == 0)
        ret = amlmmc_read_in_card(argc, argv);
    else if (isstring(argv[2]))
        ret = amlmmc_read_in_part(argc, argv);

    return ret;
}

static int do_amlmmc_env(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
    printf("herh\n");
    env_relocate();
    return 0;
}

static int do_amlmmc_list(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
    print_mmc_devices('\n');
    return 0;
}

static int do_amlmmc_size(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
    char *name;
    uint64_t* addr = NULL;
    int dev;
    struct mmc *mmc = NULL;

    if (argc != 4)
        return CMD_RET_USAGE;

    name = argv[2];
    addr = (uint64_t *)simple_strtoul(argv[3], NULL, 16);
    if (!strcmp(name, "wholeDev")) {
        dev = CONFIG_SYS_MMC_BOOT_DEV;
        mmc = find_mmc_device(dev);
        if (!mmc) {
            puts("no mmc devices available\n");
            return 1;
        }
        mmc_init(mmc);

        *addr = mmc->capacity >> 9; // unit: 512 bytes
        return 0;
    }
    return get_partition_size((unsigned char *)name, addr);
}

static int amlmmc_get_ext_csd(int argc, char *const argv[])
{
    int ret= 0;
    u8 ext_csd[512] = {0};
    int dev, byte;
    struct mmc *mmc;

    if (argc != 4)
        return CMD_RET_USAGE;

    dev = simple_strtoul(argv[2], NULL, 10);
    byte = simple_strtoul(argv[3], NULL, 10);
    mmc = find_mmc_device(dev);

    if (!mmc) {
        puts("no mmc devices available\n");
        return 1;
    }
    mmc_init(mmc);
    ret = mmc_get_ext_csd(mmc, ext_csd);
    printf("read EXT_CSD byte[%d] val[0x%x] %s\n",
            byte, ext_csd[byte], (ret == 0) ? "ok" : "fail");
    ret = ret || ret;
    return ret;
}

static int amlmmc_set_ext_csd(int argc, char *const argv[])
{
    int ret = 0;
    int dev, byte;
    struct mmc *mmc;
    int val;

    if (argc != 5)
        return CMD_RET_USAGE;

    dev = simple_strtoul(argv[2], NULL, 10);
    byte = simple_strtoul(argv[3], NULL, 10);
    val = simple_strtoul(argv[4], NULL, 16);
    if ((byte > 191) || (byte < 0)) {
        printf("byte is not able to write!\n");
        return 1;
    }

    mmc = find_mmc_device(dev);

    if (!mmc) {
        puts("no mmc devices available\n");
        return 1;
    }

    mmc_init(mmc);

    ret = mmc_set_ext_csd(mmc, byte, val);
    printf("write EXT_CSD byte[%d] val[0x%x] %s\n",
            byte, val, (ret == 0) ? "ok" : "fail");
    ret =ret || ret;
    return ret;
}

static int do_amlmmc_ext_csd(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
    int ret = CMD_RET_USAGE;

    if (argc == 4)
        ret = amlmmc_get_ext_csd(argc,argv);
    else if (argc == 5)
        ret = amlmmc_set_ext_csd(argc,argv);

    return ret;
}

static int do_amlmmc_switch(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
    int rc = 0;
    int dev;
    struct mmc *mmc;

    if (argc != 4)
        return CMD_RET_USAGE;

    dev = simple_strtoul(argv[2], NULL, 10);
    mmc = find_mmc_device(dev);

    if (!mmc) {
        puts("no mmc devices available\n");
        return 1;
    }

    mmc_init(mmc);
    printf("mmc switch to ");

    if (strcmp(argv[3], "boot0") == 0) {
        rc = mmc_switch_part(dev, 1);
        if (rc == 0) {
            emmc_cur_partition = 1;
            printf("boot0 success\n");
        } else {
            printf("boot0 failed\n");
        }
    }
    else if(strcmp(argv[3], "boot1") == 0) {
        rc = mmc_switch_part(dev, 2);
        if (rc == 0) {
            emmc_cur_partition = 2;
            printf("boot1 success\n");
        } else {
            printf("boot1 failed\n");
        }
    }
    else if(strcmp(argv[3], "user") == 0) {
        rc = mmc_switch_part(dev, 0);
        if (rc == 0) {
            emmc_cur_partition = 0;
            printf("user success\n");
        } else {
            printf("user failed\n");
       }
    }
#ifdef CONFIG_SUPPORT_EMMC_RPMB
    else if(strcmp(argv[3], "rpmb") == 0) {
        rc = mmc_switch_part(dev, 3);
        if (rc == 0) {
            emmc_cur_partition = 3;
            printf("rpmb success\n");
        } else {
            printf("rpmb failed\n");
        }
    }
#endif
    else
        printf("%s failed\n", argv[3]);
    return rc;
}

static int do_amlmmc_controller(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
    int dev;
    struct mmc *mmc;
    struct aml_card_sd_info *aml_priv;
    struct sd_emmc_global_regs *sd_emmc_reg;

    if (argc != 3)
        return CMD_RET_USAGE;

    dev = simple_strtoul(argv[2], NULL, 10);

    if (dev < 0) {
        printf("Cannot find dev.\n");
        return 1;
    }

    mmc = find_mmc_device(dev);

    if (!mmc)
        return 1;

    aml_priv = mmc->priv;
    sd_emmc_reg = aml_priv->sd_emmc_reg;

    printf("sd_emmc_reg->gclock = 0x%x\n", sd_emmc_reg->gclock);
    printf("sd_emmc_reg->gdelay = 0x%x\n", sd_emmc_reg->gdelay);
    printf("sd_emmc_reg->gadjust = 0x%x\n", sd_emmc_reg->gadjust);
    printf("sd_emmc_reg->gcalout = 0x%x\n", sd_emmc_reg->gcalout);
    if (!mmc->has_init) {
        printf("mmc dev %d has not been initialed\n", dev);
        return 1;
    }
    printf("sd_emmc_reg->gstart = 0x%x\n", sd_emmc_reg->gstart);
    printf("sd_emmc_reg->gcfg = 0x%x\n", sd_emmc_reg->gcfg);
    printf("sd_emmc_reg->gstatus = 0x%x\n", sd_emmc_reg->gstatus);
    printf("sd_emmc_reg->girq_en = 0x%x\n", sd_emmc_reg->girq_en);
    printf("sd_emmc_reg->gcmd_cfg = 0x%x\n", sd_emmc_reg->gcmd_cfg);
    printf("sd_emmc_reg->gcmd_arg = 0x%x\n", sd_emmc_reg->gcmd_arg);
    printf("sd_emmc_reg->gcmd_dat = 0x%x\n", sd_emmc_reg->gcmd_dat);
    printf("sd_emmc_reg->gcmd_rsp0 = 0x%x\n", sd_emmc_reg->gcmd_rsp0);
    printf("sd_emmc_reg->gcmd_rsp1 = 0x%x\n", sd_emmc_reg->gcmd_rsp1);
    printf("sd_emmc_reg->gcmd_rsp2 = 0x%x\n", sd_emmc_reg->gcmd_rsp2);
    printf("sd_emmc_reg->gcmd_rsp3 = 0x%x\n", sd_emmc_reg->gcmd_rsp3);
    return 0;
}

static int do_amlmmc_response(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
    int dev;
    struct mmc *mmc;
    struct aml_card_sd_info *aml_priv;
    struct sd_emmc_global_regs *sd_emmc_reg;

    if (argc != 3)
        return CMD_RET_USAGE;

    dev = simple_strtoul(argv[2], NULL, 10);

    if (dev < 0) {
        printf("Cannot find dev.\n");
        return 1;
    }

    mmc = find_mmc_device(dev);

    if (!mmc)
        return 1;
    if (!mmc->has_init) {
        printf("mmc dev %d has not been initialed\n", dev);
        return 1;
    }

    aml_priv = mmc->priv;
    sd_emmc_reg = aml_priv->sd_emmc_reg;

    printf("last cmd = %d, response0 = 0x%x\n",
        (sd_emmc_reg->gcmd_cfg & 0x3f), sd_emmc_reg->gcmd_rsp0);
    return 0;
}

static int do_amlmmc_status(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
    int rc = 0;
    int dev;
    struct mmc *mmc;

    if (argc != 3)
        return CMD_RET_USAGE;

    dev = simple_strtoul(argv[2], NULL, 10);

    if (dev < 0) {
        printf("Cannot find dev.\n");
        return 1;
    }
    mmc = find_mmc_device(dev);

    if (!mmc)
        return 1;
    if (!mmc->has_init) {
        printf("mmc dev %d has not been initialed\n", dev);
        return 1;
    }
    rc = mmc_read_status(mmc, 1000);
    if (rc)
        return 1;
    else
        return 0;
}

static int do_amlmmc_part(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
    int dev;
    block_dev_desc_t *mmc_dev;
    struct mmc *mmc;

    if (argc != 3)
        return CMD_RET_USAGE;

    dev = simple_strtoul(argv[2], NULL, 10);
    mmc = find_mmc_device(dev);

    if (!mmc) {
        puts("no mmc devices available\n");
        return 1;
    }
    mmc_init(mmc);
    mmc_dev = mmc_get_dev(dev);
    if (mmc_dev != NULL &&
        mmc_dev->type != DEV_TYPE_UNKNOWN) {
        print_part(mmc_dev);
        return 0;
    }
    puts("get mmc type error!\n");
    return 1;
}

static int do_amlmmc_rescan(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
    int dev;
    struct mmc *mmc;

    if (argc != 3)
        return CMD_RET_USAGE;

    dev = simple_strtoul(argv[2], NULL, 10);

    if (dev < 0) {
        printf("Cannot find dev.\n");
        return 1;
    }

    mmc = find_mmc_device(dev);

    if (!mmc)
            return 1;

    return mmc_init(mmc);
}

#ifdef CONFIG_SECURITYKEY
static int do_amlmmc_key(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
    struct mmc *mmc;
    int dev;

    //char *name = "logo";
    dev = CONFIG_SYS_MMC_BOOT_DEV;
    mmc = find_mmc_device(dev);
    if (!mmc) {
        printf("device %d is invalid\n",dev);
        return 1;
    }
    //mmc->key_protect = 0;
#ifdef CONFIG_STORE_COMPATIBLE
    info_disprotect |= DISPROTECT_KEY;  //disprotect
    printf("emmc disprotect key\n");
#endif
    return 0;
}
#endif

static cmd_tbl_t cmd_amlmmc[] = {
    U_BOOT_CMD_MKENT(read,          6, 0, do_amlmmc_read,       "", ""),
    U_BOOT_CMD_MKENT(write,         6, 0, do_amlmmc_write,      "", ""),
    U_BOOT_CMD_MKENT(erase,         5, 0, do_amlmmc_erase,      "", ""),
    U_BOOT_CMD_MKENT(rescan,        3, 0, do_amlmmc_rescan,     "", ""),
    U_BOOT_CMD_MKENT(part,          3, 0, do_amlmmc_part,       "", ""),
    U_BOOT_CMD_MKENT(list,          2, 0, do_amlmmc_list,       "", ""),
    U_BOOT_CMD_MKENT(switch,        4, 0, do_amlmmc_switch,     "", ""),
    U_BOOT_CMD_MKENT(status,        3, 0, do_amlmmc_status,     "", ""),
    U_BOOT_CMD_MKENT(ext_csd,       5, 0, do_amlmmc_ext_csd,    "", ""),
    U_BOOT_CMD_MKENT(response,      3, 0, do_amlmmc_response,   "", ""),
    U_BOOT_CMD_MKENT(controller,    3, 0, do_amlmmc_controller, "", ""),
    U_BOOT_CMD_MKENT(size,          4, 0, do_amlmmc_size,       "", ""),
    U_BOOT_CMD_MKENT(env,           2, 0, do_amlmmc_env,        "", ""),
#ifdef CONFIG_SECURITYKEY
    U_BOOT_CMD_MKENT(key,           2, 0, do_amlmmc_key,        "", ""),
#endif
};

static int do_amlmmcops(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
    cmd_tbl_t *cp;

    cp = find_cmd_tbl(argv[1], cmd_amlmmc, ARRAY_SIZE(cmd_amlmmc));

    if (cp == NULL || argc > cp->maxargs)
        return CMD_RET_USAGE;

    if (flag == CMD_FLAG_REPEAT && !cp->repeatable)
        return CMD_RET_SUCCESS;

    return cp->cmd(cmdtp, flag, argc, argv);
}

U_BOOT_CMD(
    amlmmc, 6, 1, do_amlmmcops,
    "AMLMMC sub system",
    "read  <partition_name> ram_addr addr_byte# cnt_byte\n"
    "amlmmc write <partition_name> ram_addr addr_byte# cnt_byte\n"
    "amlmmc erase <partition_name> addr_byte# cnt_byte\n"
    "amlmmc erase <partition_name>/<device num>\n"
    "amlmmc rescan <device_num>\n"
    "amlmmc part <device_num> - show partition infomation of mmc\n"
    "amlmmc list - lists available devices\n"
    "amlmmc env -  display env partition offset\n"
    "amlmmc switch <device_num> <part name> - part name : boot0, boot1, user\n"
    "amlmmc status <device_num> - read sd/emmc device status\n"
    "amlmmc ext_csd <device_num> <byte> - read sd/emmc device EXT_CSD [byte]\n"
    "amlmmc ext_csd <device_num> <byte> <value> - write sd/emmc device EXT_CSD [byte] value\n"
    "amlmmc response <device_num> - read sd/emmc last command response\n"
    "amlmmc controller <device_num> - read sd/emmc controller register\n"
#ifdef CONFIG_SECURITYKEY
    "amlmmc key - disprotect key partition\n"
#endif
);



/* dtb read&write operation with backup updates */
static u32 _calc_dtb_checksum(struct aml_dtb_rsv * dtb)
{
    int i = 0;
    int size = sizeof(struct aml_dtb_rsv) - sizeof(u32);
    u32 * buffer;
    u32 checksum = 0;

    if ((u64)dtb % 4 != 0) {
        BUG();
    }

    size = size >> 2;
    buffer = (u32*) dtb;
    while (i < size)
        checksum += buffer[i++];

    return checksum;
}

static int _verify_dtb_checksum(struct aml_dtb_rsv * dtb)
{
    u32 checksum;

    checksum = _calc_dtb_checksum(dtb);
    dtb_info("calc %x, store %x\n", checksum, dtb->checksum);

    return !(checksum == dtb->checksum);
}

static int _dtb_read(struct mmc *mmc, u64 blk, u64 cnt, void * addr)
{
    int dev = EMMC_DTB_DEV;
    u64 n;
    n = mmc->block_dev.block_read(dev, blk, cnt, addr);
    if (n != cnt) {
        dtb_err("%s: dev # %d, block # %#llx, count # %#llx ERROR!\n",
                __func__, dev, blk, cnt);
    }

    return (n != cnt);
}

static int _dtb_write(struct mmc *mmc, u64 blk, u64 cnt, void * addr)
{
    int dev = EMMC_DTB_DEV;
    u64 n;
    n = mmc->block_dev.block_write(dev, blk, cnt, addr);
    if (n != cnt) {
        dtb_err("%s: dev # %d, block # %#llx, count # %#llx ERROR!\n",
                __func__, dev, blk, cnt);
    }

    return (n != cnt);
}

static struct mmc *_dtb_init(void)
{
    struct mmc *mmc = find_mmc_device(EMMC_DTB_DEV);
    if (!mmc) {
        dtb_err("not find mmc\n");
        return NULL;
    }

    if (mmc_init(mmc)) {
        dtb_err("mmc init failed\n");
        return NULL;
    }
    return mmc;
}

static int dtb_read_shortcut(struct mmc * mmc, void *addr)
{
    u64 blk, cnt, dtb_glb_offset;
    int dev = EMMC_DTB_DEV;
    struct aml_dtb_info *info = &dtb_infos;
    struct partitions * part = NULL;
    struct virtual_partition *vpart = NULL;
    vpart = aml_get_virtual_partition_by_name(MMC_DTB_NAME);
    part = aml_get_partition_by_name(MMC_RESERVED_NAME);
    dtb_glb_offset = part->offset + vpart->offset;
    /* short cut */
    if (info->valid[0]) {
        dtb_info("short cut in...\n");
        blk = dtb_glb_offset / mmc->read_bl_len;
        cnt = vpart->size / mmc->read_bl_len;
        if (_dtb_read(mmc, blk, cnt, addr)) {
            dtb_err("%s: dev # %d, block # %#llx,cnt # %#llx ERROR!\n",
                    __func__, dev, blk, cnt);
            /*try dtb2 if it's valid */
            if (info->valid[1]) {
                blk = (dtb_glb_offset + vpart->size) / mmc->read_bl_len;
                cnt = vpart->size / mmc->read_bl_len;
                if (_dtb_read(mmc, blk, cnt, addr)) {
                    dtb_err("%s: dev # %d, block # %#llx, cnt # %#llx ERROR!\n",
                        __func__, dev, blk, cnt);
                    return -1;
                }
            }
        }
        return 0;
    }
    return -2;
}

static int update_dtb_info(struct mmc *mmc, void *addr)
{
    int ret = 0, dev = EMMC_DTB_DEV;
    u64 blk, cnt, dtb_glb_offset;
    struct aml_dtb_rsv * dtb = (struct aml_dtb_rsv *) addr;
    struct aml_dtb_info *info = &dtb_infos;
    int cpy = 1, valid = 0;
    struct partitions * part = NULL;
    struct virtual_partition *vpart = NULL;
    vpart = aml_get_virtual_partition_by_name(MMC_DTB_NAME);
    part = aml_get_partition_by_name(MMC_RESERVED_NAME);
    dtb_glb_offset = part->offset + vpart->offset;

    while (cpy >= 0) {
        blk = (dtb_glb_offset + cpy * (vpart->size)) / mmc->read_bl_len;
        cnt = vpart->size / mmc->read_bl_len;
        ret = _dtb_read(mmc, blk, cnt, addr);
        if (ret) {
            dtb_err("%s: dev # %d, block # %#llx, cnt # %#llx ERROR!\n",
                __func__, dev, blk, cnt);
        } else {
            ret = _verify_dtb_checksum(dtb);
            /* check magic avoid whole 0 issue */
            if (!ret && (dtb->magic != 0)) {
                info->stamp[cpy] = dtb->timestamp;
                info->valid[cpy] = 1;
            }
            else
                dtb_wrn("cpy %d is not valid\n", cpy);
        }
        valid += info->valid[cpy];
        cpy --;
    }
    return valid;
}

static int update_invalid_dtb(struct mmc *mmc, void *addr)
{
    int ret = 0, dev = EMMC_DTB_DEV;
    u64 blk, cnt, dtb_glb_offset;
    struct aml_dtb_rsv * dtb = (struct aml_dtb_rsv *) addr;
    struct aml_dtb_info *info = &dtb_infos;
    struct partitions * part = NULL;
    struct virtual_partition *vpart = NULL;
    vpart = aml_get_virtual_partition_by_name(MMC_DTB_NAME);
    part = aml_get_partition_by_name(MMC_RESERVED_NAME);
    dtb_glb_offset = part->offset + vpart->offset;
    cnt = vpart->size / mmc->read_bl_len;

    if (info->valid[1]) {
        blk = (dtb_glb_offset + vpart->size) / mmc->read_bl_len;
        if (_dtb_read(mmc, blk, cnt, addr)) {
        dtb_err("%s: dev # %d, block # %#llx,cnt # %#llx ERROR!\n",
                __func__, dev, blk, cnt);
            ret = -2;
        }
        /* fixme, update the invalid one - dtb1 */
        blk = (dtb_glb_offset) / mmc->read_bl_len;
        if (_dtb_write(mmc, blk, cnt, addr)) {
            dtb_err("%s: dev # %d, block # %#llx,cnt # %#llx ERROR!\n",
                __func__, dev, blk, cnt);
            ret = -4;
        }
        info->valid[0] = 1;
        info->stamp[0] = dtb->timestamp;
        ret = 0;
    } else {
        dtb_info("update dtb2");
        blk = (dtb_glb_offset + vpart->size) / mmc->read_bl_len;
        if (_dtb_write(mmc, blk, cnt, addr)) {
            dtb_err("%s: dev # %d, block # %#llx,cnt # %#llx ERROR!\n",
                __func__, dev, blk, cnt);
            ret = -2;
        }
        info->valid[1] = 1;
        info->stamp[1] = dtb->timestamp;
    }
    return ret;
}

int update_old_dtb(struct mmc *mmc, void *addr)
{
    int ret = 0, dev = EMMC_DTB_DEV;
    u64 blk, cnt, dtb_glb_offset;
    struct aml_dtb_rsv * dtb = (struct aml_dtb_rsv *) addr;
    struct aml_dtb_info *info = &dtb_infos;
    struct partitions * part = NULL;
    struct virtual_partition *vpart = NULL;
    vpart = aml_get_virtual_partition_by_name(MMC_DTB_NAME);
    part = aml_get_partition_by_name(MMC_RESERVED_NAME);
    dtb_glb_offset = part->offset + vpart->offset;
    cnt = vpart->size / mmc->read_bl_len;
    if (stamp_after(info->stamp[1], info->stamp[0])) {
        blk = (dtb_glb_offset + vpart->size) / mmc->read_bl_len;
        if (_dtb_read(mmc, blk, cnt, addr)) {
            dtb_err("%s: dev # %d, block # %#llx,cnt # %#llx ERROR!\n",
                    __func__, dev, blk, cnt);
            ret = -3;
        }
        /*update dtb1*/
        blk = dtb_glb_offset / mmc->read_bl_len;
        if (_dtb_write(mmc, blk, cnt, addr)) {
            dtb_err("%s: dev # %d, block # %#llx,cnt # %#llx ERROR!\n",
                    __func__, dev, blk, cnt);
            ret = -3;
        }
        info->stamp[0] = dtb->timestamp;
        ret = 0;
    } else if (stamp_after(info->stamp[0], info->stamp[1])) {
        /*update dtb2*/
        blk = (dtb_glb_offset + vpart->size) / mmc->read_bl_len;
        if (_dtb_write(mmc, blk, cnt, addr)) {
            dtb_err("%s: dev # %d, block # %#llx,cnt # %#llx ERROR!\n",
                    __func__, dev, blk, cnt);
            ret = -3;
        }
        info->stamp[1] = dtb->timestamp;
    } else {
        dtb_info("do nothing\n");
    }
    return ret;
}

int dtb_read(void *addr)
{
    int ret = 0;
    int valid = 0;
    struct mmc *mmc;

    mmc = _dtb_init();
    if (mmc == NULL)
        return -10;

    if (dtb_read_shortcut(mmc, addr) == 0)
        return ret;

    valid = update_dtb_info(mmc, addr);
    dtb_info("total valid %d\n", valid);
    /* check valid */
    switch (valid) {
        /* none is valid, using the 1st one for compatibility*/
        case 0:
            ret = -1;
            goto _out;
        break;
        /* only 1 is valid, using the valid one */
        case 1:
            update_invalid_dtb(mmc, addr);
        break;
        /* both are valid, pickup new one. */
        case 2:
            update_old_dtb(mmc, addr);
        break;
        default:
            dtb_err("impossble valid values.\n");
            BUG();
        break;
    }
_out:
    return ret;
}


int dtb_write(void *addr)
{
    int ret = 0;
    struct aml_dtb_rsv * dtb = (struct aml_dtb_rsv *) addr;
    struct aml_dtb_info *info = &dtb_infos;
    u64 blk, cnt, dtb_glb_offset;
    int cpy, valid;
    struct mmc * mmc;
    struct partitions * part = NULL;
    struct virtual_partition *vpart = NULL;
    vpart = aml_get_virtual_partition_by_name(MMC_DTB_NAME);
    part = aml_get_partition_by_name(MMC_RESERVED_NAME);
    dtb_glb_offset = part->offset + vpart->offset;

    mmc = _dtb_init();
    if (NULL == mmc)
        return -10;

    /* stamp */
    valid = info->valid[0] + info->valid[1];
    dtb_info("valid %d\n", valid);
    if (0 == valid)
        dtb->timestamp = 0;
    else if (1 == valid) {
        dtb->timestamp = 1 + info->stamp[info->valid[0]?0:1];
    } else {
        /* both are valid */
        if (info->stamp[0] != info->stamp[1]) {
            dtb_wrn("timestamp are not same %d:%d\n",
                info->stamp[0], info->stamp[1]);
            dtb->timestamp = 1 + stamp_after(info->stamp[1], info->stamp[0])?
                info->stamp[1]:info->stamp[0];
        } else
            dtb->timestamp = 1 + info->stamp[0];
    }
    /*setting version and magic*/
    dtb->version = 1; /* base version */
    dtb->magic = 0x00447e41; /*A~D\0*/
    dtb->checksum = _calc_dtb_checksum(dtb);
    dtb_info("new stamp %d, checksum 0x%x, version %d, magic %s\n",
        dtb->timestamp, dtb->checksum, dtb->version, (char *)&dtb->magic);

    for (cpy = 0; cpy < DTB_COPIES; cpy++) {
        blk = (dtb_glb_offset + cpy * (vpart->size)) / mmc->read_bl_len;
        cnt = vpart->size / mmc->read_bl_len;
        ret |= _dtb_write(mmc, blk, cnt, addr);
        info->valid[cpy] = 1;
        info->stamp[cpy] = dtb->timestamp;
    }

    return ret;
}

extern int check_valid_dts(unsigned char *buffer);
int renew_partition_tbl(unsigned char *buffer)
{
    int ret = 0;
    /* todo, check new dts imcoming.... */
    ret = check_valid_dts(buffer);
    /* only the dts new is valid */
    if (!ret) {
        free_partitions();
        get_partition_from_dts(buffer);
        if (0 == mmc_device_init(_dtb_init())) {
            printf("partition table success\n");
            ret = 0;
            goto _out;
        }
        printf("partition table error\n");
        ret = 1;
    }

_out:
    return ret;
}


/* update partition table in reserved partition. */
__weak int emmc_update_ept(unsigned char *buffer)
{
    int ret = 0;

#ifndef DTB_BIND_KERNEL
    dtb_write(buffer);
#endif
    ret = renew_partition_tbl(buffer);
    return ret;
}

/* fixme, should use renew_partition_tbl here! */
__weak int emmc_update_mbr(unsigned char *buffer)
{
    int ret = 0;
    cpu_id_t cpu_id = get_cpu_id();

    if (cpu_id.family_id < MESON_CPU_MAJOR_ID_GXL) {
        ret = -1;
        printf("MBR not support, try dtb\n");
        goto _out;
    }
#ifndef DTB_BIND_KERNEL
    dtb_write(buffer);
#endif
    ret = get_partition_from_dts(buffer);
    if (ret) {
        printf("Fail to get partition talbe from dts\n");
        goto _out;
    }
    ret = mmc_device_init(_dtb_init());
    printf("%s: update mbr %s\n", __func__, ret?"Fail":"Success");
_out:
    return ret;
}

int do_emmc_erase(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
    int dev;
    u64 cnt = 0, n = 0, blk = 0;
    //u64 size;
    struct partitions *part = NULL;
    struct virtual_partition *vpart = NULL;
    struct mmc *mmc;
    if (argc != 3)
        return CMD_RET_USAGE;

    vpart = aml_get_virtual_partition_by_name(MMC_DTB_NAME);
    part = aml_get_partition_by_name(MMC_RESERVED_NAME);
    if (strcmp(argv[2], "dtb") == 0) {
        printf("start erase dtb......\n");
        dev = EMMC_DTB_DEV;
        mmc = find_mmc_device(dev);
        if (!mmc) {
            printf("not find mmc\n");
            return 1;
        }
        blk = (part->offset + vpart->offset) / mmc->read_bl_len;
        cnt = (vpart->size * 2) / mmc->read_bl_len;
        if (cnt != 0)
            n = mmc->block_dev.block_erase(dev, blk, cnt);
        printf("dev # %d, %s, several blocks erased %s\n",
                dev, (flag == 0) ? " ":(argv[2]),(n == 0) ? "OK" : "ERROR");
        return (n == 0) ? 0 : 1;
    } else if (strcmp(argv[2], "key") == 0) {
        printf("start erase key......\n");
        dev = 1;
        mmc = find_mmc_device(dev);
        if (!mmc) {
            printf("not find mmc\n");
            return 1;
        }
        n = mmc_key_erase();
        printf("dev # %d, %s, several blocks erased %s\n",
                dev, (flag == 0) ? " ":(argv[2]),(n == 0) ? "OK" : "ERROR");
        return (n == 0) ? 0 : 1;
    }
    return 1;
}

int do_emmc_dtb_read(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
    int ret = 0;
    void *addr = NULL;

    if (argc != 4)
        return CMD_RET_USAGE;

    addr = (void *)simple_strtoul(argv[2], NULL, 16);
    ret = dtb_read(addr);
    return ret;
}

int do_emmc_dtb_write(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
    int ret = 0;
    void *addr = NULL;

    if (argc != 4)
        return CMD_RET_USAGE;

    addr = (void *)simple_strtoul(argv[2], NULL, 16);
    ret = dtb_write(addr);
    ret |= renew_partition_tbl(addr);
    return ret;
}

static cmd_tbl_t cmd_emmc[] = {
    U_BOOT_CMD_MKENT(dtb_read,  4, 0, do_emmc_dtb_read,  "", ""),
    U_BOOT_CMD_MKENT(dtb_write, 4, 0, do_emmc_dtb_write, "", ""),
    U_BOOT_CMD_MKENT(erase,     3, 0, do_emmc_erase,     "", ""),
};

static int do_emmc_dtb_key(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
    cmd_tbl_t *cp;

    cp = find_cmd_tbl(argv[1], cmd_emmc, ARRAY_SIZE(cmd_emmc));

    if (cp == NULL || argc > cp->maxargs)
        return CMD_RET_USAGE;
    if (flag == CMD_FLAG_REPEAT && !cp->repeatable)
        return CMD_RET_SUCCESS;
    return cp->cmd(cmdtp, flag, argc, argv);
}

U_BOOT_CMD(
    emmc, 4, 1, do_emmc_dtb_key,
    "EMMC sub system",
    "dtb_read addr size\n"
    "emmc dtb_write addr size\n"
    "emmc erase dtb\n"
    "emmc erase key\n");
