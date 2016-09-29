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

extern int mmc_key_erase(void);
extern int find_dev_num_by_partition_name (char *name);
extern int mmc_get_ext_csd(struct mmc *mmc, u8 *ext_csd);
extern int mmc_set_ext_csd(struct mmc *mmc, u8 index, u8 value);

/*
 * 2 copies dtb were stored in dtb area.
 * each is 256K.
 * timestamp&checksum are in the tail.
 * |<--------------DTB Area-------------->|
 * |<------DTB1------->|<------DTB2------>|
 */
#define DTB_GLB_OFFSET		(SZ_1M * 40)
#define DTB_BLK_SIZE		(512)
#define DTB_BLK_CNT			(512)
#define DTB_SIZE			(DTB_BLK_CNT * DTB_BLK_SIZE)
#define DTB_COPIES			(2)
#define DTB_AREA_BLK_CNT	(DTB_BLK_CNT * DTB_COPIES)
#define EMMC_DTB_DEV		(1)

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
#define UBOOT_SIZE  (0x1000) // uboot size  2MB
int info_disprotect = 0;
bool emmckey_is_protected (struct mmc *mmc)
{
#ifdef CONFIG_STORE_COMPATIBLE
#ifdef CONFIG_SECURITYKEY
    if (info_disprotect & DISPROTECT_KEY) { // disprotect
        printf("emmckey_is_protected : disprotect\n ");
        return 0;
    }else{
        printf("emmckey_is_protected : protect\n ");
    // protect
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
        *sz_byte = size - ((*cnt)<<blk_shift) ;

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


int do_amlmmcops(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
        int rc = 0;
        /*printf("%s:%d\n",__func__,__LINE__);*/
        /*printf("argc = %d\n",argc);*/
        switch (argc) {
                case 3:
                        if (strcmp(argv[1], "rescan") == 0) {
                                int dev = simple_strtoul(argv[2], NULL, 10);
                                if (dev < 0) {
                                        printf("Cannot find dev.\n");
                                        return 1;
                                }
                                struct mmc *mmc = find_mmc_device(dev);

                                if (!mmc)
                                        return 1;

                                return mmc_init(mmc);
                        } else if (strncmp(argv[1], "part", 4) == 0) {
                                int dev = simple_strtoul(argv[2], NULL, 10);
                                block_dev_desc_t *mmc_dev;
                                struct mmc *mmc = find_mmc_device(dev);

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
                        } else if (strcmp(argv[1], "erase") == 0) {
                                char *name = NULL;
                                int dev;
                                u32 n=0;
                                bool is_part = false;//is argv[2] partition name
                                bool protect_cache = false;
                                bool non_loader = false;
                                int blk_shift;
                                u64 cnt=0, blk =0,start_blk =0;
                                struct partitions *part_info;

                                if (isstring(argv[2])) {
                                        if (!strcmp(argv[2], "whole")) {
                                                name = "logo";
                                                dev = find_dev_num_by_partition_name (name);
                                        }else if(!strcmp(argv[2], "non_cache")){
                                                name = "logo";
                                                dev = find_dev_num_by_partition_name (name);
                                                protect_cache = true;
                                        }
                                        else if(!strcmp(argv[2], "non_loader")){
                                                dev = 1;
                                                non_loader = true;
                                        }
                                        else{
                                                name = argv[2];
                                                dev = find_dev_num_by_partition_name (name);
                                                is_part = true;
                                        }
                                }else if(isdigit(argv[2][0])){
                                        dev = simple_strtoul(argv[2], NULL, 10);
                                }else{
                                        printf("Input is invalid, nothing happen.\n");
                                        return 1;
                                }

                                if (dev < 0) {
                                        printf("Cannot find dev.\n");
                                        return 1;
                                }
                                struct mmc *mmc = find_mmc_device(dev);

                                if (!mmc)
                                        return 1;

                                mmc_init(mmc);

                                blk_shift = ffs(mmc->read_bl_len) -1;
                                if (is_part) { // erase only one partition
                                        if (emmckey_is_protected(mmc)
                                                        && (strncmp(name, MMC_RESERVED_NAME, sizeof(MMC_RESERVED_NAME)) == 0x00)) {
                                                printf("\"%s-partition\" is been protecting and should no be erased!\n", MMC_RESERVED_NAME);
                                                return 1;
                                        }

                                        part_info = find_mmc_partition_by_name(name);
                                        if (part_info == NULL) {
                                                return 1;
                                        }

                                        blk = part_info->offset>> blk_shift;
                                        if (emmc_cur_partition && !strncmp(name, "bootloader", strlen("bootloader"))) {

                                                cnt = mmc->boot_size>> blk_shift;
                                        }
                                        else
                                                cnt = part_info->size>> blk_shift;
                                        n = mmc->block_dev.block_erase(dev, blk, cnt);
                                } else { // erase the whole card if possible

                                        if (non_loader) {
                                                part_info = find_mmc_partition_by_name(MMC_BOOT_NAME);
                                                if (part_info == NULL) {
                                                        start_blk = 0;
                                                        printf("no uboot partition for eMMC boot, just erase from 0\n");
                                                }
                                                else{
                                                        start_blk = (part_info->offset + part_info->size) >> blk_shift;
                                                }
                                        }
                                        else{
                                                start_blk = 0;
                                        }

                                        if (emmckey_is_protected(mmc)) {
                                                part_info = find_mmc_partition_by_name(MMC_RESERVED_NAME);
                                                if (part_info == NULL) {
                                                        return 1;
                                                }

                                                blk = part_info->offset;
                                                if (blk > 0) { // it means: there should be other partitions before reserve-partition.
                                                        blk -= PARTITION_RESERVED;
                                                }
                                                blk >>= blk_shift;
                                                blk -= start_blk;

                                                n=0;

                                                // (1) erase all the area before reserve-partition
                                                if (blk > 0) {
                                                        n = mmc->block_dev.block_erase(dev, start_blk, blk);
                                                        // printf("(1) erase blk: 0 --> %llx %s\n", blk, (n == 0) ? "OK" : "ERROR");
                                                }
                                                if (n == 0) { // not error
                                                        // (2) erase all the area after reserve-partition
                                                        if (protect_cache) {
                                                                part_info = find_mmc_partition_by_name(MMC_CACHE_NAME);
                                                                if (part_info == NULL) {
                                                                        return 1;
                                                                }
                                                        }
                                                        start_blk = (part_info->offset + part_info->size + PARTITION_RESERVED) >> blk_shift;
                                                        u64 erase_cnt = (mmc->capacity >> blk_shift) - 1 - start_blk;
                                                        n = mmc->block_dev.block_erase(dev, start_blk, erase_cnt);
                                                        // printf("(2) erase blk: %#llx --> %#llx %s\n", start_blk, start_blk+erase_cnt, (n == 0) ? "OK" : "ERROR");
                                                }

                                        } else {
                                                n = mmc->block_dev.block_erase(dev, start_blk, 0); // erase the whole card
                                        }

                                        //erase boot partition
                                        if (mmc->boot_size && (n == 0) && (non_loader == false)) {

                                                for (cnt=0;cnt<2;cnt++) {
                                                        rc = mmc_switch_part(dev, cnt+1);
                                                        if (rc != 0) {
                                                                printf("mmc switch %s failed\n", (cnt == 0)?"boot0":"boot1");
                                                                break;
                                                        }

                                                        n = mmc->block_dev.block_erase(dev, 0, mmc->boot_size>>blk_shift);
                                                        if (n != 0) {
                                                                printf("mmc erase %s failed\n", (cnt == 0)?"boot0":"boot1");
                                                                break;
                                                        }
                                                }

                                                rc = mmc_switch_part(dev, 0);
                                                if (rc != 0) {
                                                        printf("mmc switch back to user failed\n");
                                                }
                                        }
                                }

                                // printf("dev # %d, %s, # %#llx blocks erased %s\n",
                                // dev, (is_part == 0) ? "card":(argv[2]) ,
                                // (cnt == 0) ? (int)(mmc->block_dev.lba): cnt ,
                                // (n == 0) ? "OK" : "ERROR");
                                return (n == 0) ? 0 : 1;
                        } else if (strcmp(argv[1], "status") == 0) {
                            int dev = simple_strtoul(argv[2], NULL, 10);
                            if (dev < 0) {
                                printf("Cannot find dev.\n");
                                return 1;
                            }
                            struct mmc *mmc = find_mmc_device(dev);

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
                        } else if (strcmp(argv[1], "response") == 0) {
                            int dev = simple_strtoul(argv[2], NULL, 10);
                            if (dev < 0) {
                                printf("Cannot find dev.\n");
                                return 1;
                            }
                            struct mmc *mmc = find_mmc_device(dev);
                            if (!mmc)
                                return 1;
                            if (!mmc->has_init) {
                                printf("mmc dev %d has not been initialed\n", dev);
                                return 1;
                            }
                            struct aml_card_sd_info *aml_priv = mmc->priv;
                            struct sd_emmc_global_regs *sd_emmc_reg = aml_priv->sd_emmc_reg;

                            printf("last cmd = %d, response0 = 0x%x\n",
                                (sd_emmc_reg->gcmd_cfg & 0x3f), sd_emmc_reg->gcmd_rsp0);
                            return 0;
                        } else if (strcmp(argv[1], "controller") == 0) {
                            int dev = simple_strtoul(argv[2], NULL, 10);
                            if (dev < 0) {
                                printf("Cannot find dev.\n");
                                return 1;
                            }
                            struct mmc *mmc = find_mmc_device(dev);
                            if (!mmc)
                                return 1;
                            struct aml_card_sd_info *aml_priv = mmc->priv;
                            struct sd_emmc_global_regs *sd_emmc_reg = aml_priv->sd_emmc_reg;
                            printf("sd_emmc_reg->gclock = 0x%x\n", sd_emmc_reg->gclock);
                            printf("sd_emmc_reg->gdelay = 0x%x\n", sd_emmc_reg->gdelay);
                            printf("sd_emmc_reg->gadjust = 0x%x\n", sd_emmc_reg->gadjust);
                            printf("sd_emmc_reg->reserved_0c = 0x%x\n", sd_emmc_reg->reserved_0c);
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
                        } else {
                                return cmd_usage(cmdtp);
                        }

                case 0:
                case 1:
                        return CMD_RET_USAGE;
                case 4:
                        if (strcmp(argv[1], "switch") == 0) {
                                int dev = simple_strtoul(argv[2], NULL, 10);
                                struct mmc* mmc = find_mmc_device(dev);
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
                        } else if (strcmp(argv[1], "ext_csd") == 0) {
                            int ret;
                            u8 ext_csd[512] = {0};
                            int dev = simple_strtoul(argv[2], NULL, 10);
                            int bit = simple_strtoul(argv[3], NULL, 10);
                            if ((bit > 511) || (bit < 0)) {
                                printf("bit is out of area!\n");
                                return 1;
                            }
                            struct mmc* mmc = find_mmc_device(dev);
                            if (!mmc) {
                                puts("no mmc devices available\n");
                                return 1;
                            }
                            mmc_init(mmc);
                            ret = mmc_get_ext_csd(mmc, ext_csd);
                            printf("read EXT_CSD bit[%d] val[0x%x] %s\n",
                                    bit, ext_csd[bit], (ret == 0) ? "ok" : "fail");
                            return ret;
                        } else if (strcmp(argv[1], "size") == 0) {
                            char *name;
                            uint64_t* addr =NULL;
                            name = argv[2];
                            addr = (uint64_t *)simple_strtoul(argv[3], NULL, 16);
                            if (!strcmp(name, "wholeDev")) {
                                int dev = CONFIG_SYS_MMC_BOOT_DEV;
                                struct mmc* mmc = find_mmc_device(dev);
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
                        return cmd_usage(cmdtp);

                case 2:
                        if (!strcmp(argv[1], "list")) {
                                print_mmc_devices('\n');
                                return 0;
                        }

                        if (strcmp(argv[1], "env") == 0) {
                                printf("herh\n");
                                env_relocate();
                                return 0 ;
                        }

#ifdef CONFIG_SECURITYKEY
                        if (strcmp(argv[1], "key") == 0) {
                                struct mmc* mmc;
                                //char *name = "logo";
                                int dev = CONFIG_SYS_MMC_BOOT_DEV;
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
                        return cmd_usage(cmdtp);

                default: /* at least 5 args */
                        if (strcmp(argv[1], "read") == 0) {
                                int dev;
                                void *addr =NULL;
                                u32 flag =0;
                                u64 cnt =0,n =0, blk =0, sz_byte =0;
                                char *name=NULL;
                                u64 offset =0,size =0;

                                if (argc != 6) {
                                        printf("Input is invalid, nothing happen.\n");
                                        return 1;
                                }

                                if (isstring(argv[2])) {
                                        name = argv[2];
                                        dev = find_dev_num_by_partition_name (name);
                                        addr = (void *)simple_strtoul(argv[3], NULL, 16);
                                        size = simple_strtoull(argv[5], NULL, 16);
                                        offset  = simple_strtoull(argv[4], NULL, 16);
                                        /*printf("offset %llx size %llx\n",offset,size);*/
                                        flag = 1;
                                        if ((strcmp(argv[2], "card") == 0)) {
                                                flag = 2;
                                        }
                                }else{
                                        dev = simple_strtoul(argv[2], NULL, 10);
                                        addr = (void *)simple_strtoul(argv[3], NULL, 16);
                                        cnt = simple_strtoull(argv[5], NULL, 16);
                                        blk = simple_strtoull(argv[4], NULL, 16);
                                }
                                if (dev < 0) {
                                        printf("Cannot find dev.\n");
                                        return 1;
                                }
                                struct mmc *mmc = find_mmc_device(dev);
                                if (!mmc) {
                                        printf("dev = %d;, no mmc device found",dev);
                                        return 1;
                                }

                                if (flag == 1) { // emmc or tsd
                                        /*printf("offset %#llx size %#llx\n",offset,size);*/
                                        get_off_size(mmc, name, offset, size, &blk, &cnt, &sz_byte);
                                }
                                else if(flag == 2){ // card
                                        int blk_shift = ffs( mmc->read_bl_len) -1;
                                        cnt = size >> blk_shift;
                                        blk = offset >> blk_shift;
                                        sz_byte = size - (cnt<<blk_shift);
                                }


                                /*printf("MMC read: dev # %d, block # %#llx, count # %#llx ...\n",*/
                                                /*dev, blk, cnt);*/
                                mmc_init(mmc);

                                n = mmc->block_dev.block_read(dev, blk, cnt, addr);
                                //read sz_byte bytes
                                if ((n == cnt) && (sz_byte != 0)) {
                                        /*printf("sz_byte=%#llx bytes\n",sz_byte);*/
                                        void *addr_tmp = malloc(mmc->read_bl_len);
                                        void *addr_byte = (void *)(addr+cnt*(mmc->read_bl_len));
                                        ulong start_blk = blk+cnt;

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

                                /* flush cache after read */
                                //flush_cache((ulong)addr, cnt * 512); /* FIXME */

                                //printf("MMC read: dev # %d, block # %#llx, count # %#llx, byte_size # %#llx %s!\n",
                                //                        dev, blk, cnt, sz_byte, (n==cnt) ? "OK" : "ERROR");
                                return (n == cnt) ? 0 : 1;
                        } else if (strcmp(argv[1], "write") == 0) {
                                int dev;
                                void *addr =NULL;
                                u32 flag =0;
                                u64 cnt =0,n =0, blk =0,sz_byte =0;
                                char *name=NULL;
                                u64 offset =0,size =0;
                                cpu_id_t cpu_id = get_cpu_id();
                                if (argc != 6) {
                                        printf("Input is invalid, nothing happen.\n");
                                        return 1;
                                }

                                if (isstring(argv[2])) {
                                        name = argv[2];
                                        if (strcmp(name, "bootloader") == 0)
                                            dev = CONFIG_SYS_MMC_BOOT_DEV;
                                        else
                                            dev = find_dev_num_by_partition_name (name);
                                        addr = (void *)simple_strtoul(argv[3], NULL, 16);
                                        offset  = simple_strtoull(argv[4], NULL, 16);
                                        size = simple_strtoull(argv[5], NULL, 16);
                                        flag = 1;
                                        if ((strcmp(argv[2], "card") == 0)) {
                                            flag = 2;
                                        }
                                }else{
                                        dev = simple_strtoul(argv[2], NULL, 10);
                                        addr = (void *)simple_strtoul(argv[3], NULL, 16);
                                        blk = simple_strtoull(argv[4], NULL, 16);
                                        cnt = simple_strtoull(argv[5], NULL, 16);
                                }
                                if (dev < 0) {
                                        printf("Cannot find dev.\n");
                                        return 1;
                                }
                                struct mmc *mmc = find_mmc_device(dev);

                                if (flag == 1) { // tsd or emmc
                                        if (strcmp(name, "bootloader") == 0) {
                                            cnt = UBOOT_SIZE;
                                            if (cpu_id.family_id >= MESON_CPU_MAJOR_ID_GXL) {
                                                blk = GXL_START_BLK;
                                                cnt -= GXL_START_BLK;
                                            }
                                            else
                                                blk = GXB_START_BLK;
                                            sz_byte = 0;
                                        } else
                                            get_off_size(mmc, name, offset, size, &blk, &cnt, &sz_byte);
                                }
                                else if(flag == 2){ // card
                                        int blk_shift = ffs( mmc->read_bl_len) -1;
                                        cnt = size >> blk_shift;
                                        blk = offset >> blk_shift;
                                        sz_byte = size - (cnt<<blk_shift);
                                }

                                if (!mmc)
                                        return 1;

                                 //printf("MMC write: dev # %d, block # %#llx, count # %#llx ... ",
                                 //dev, blk, cnt);

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
                        else if (strcmp(argv[1], "erase") == 0) {

                                int dev=0;
                                u32 flag=0;
                                u64 cnt = 0, blk = 0, n = 0, sz_byte =0;
                                char *name=NULL;
                                u64 offset_addr =0, size=0;

                                if (argc != 5) {
                                        printf("Input is invalid, nothing happen.\n");
                                        return 1;
                                }

                                if (isstring(argv[2])) {
                                        name = argv[2];
                                        dev = find_dev_num_by_partition_name (name);
                                        offset_addr = simple_strtoull(argv[3], NULL, 16);
                                        size = simple_strtoull(argv[4], NULL, 16);
                                        flag = 1;
                                        if ((strcmp(argv[2], "card") == 0)) {
                                                flag = 2;
                                        }
                                }else if(isdigit(argv[2][0])){
                                        dev = simple_strtoul(argv[2], NULL, 10);
                                        blk = simple_strtoull(argv[3], NULL, 16);
                                        cnt = simple_strtoull(argv[4], NULL, 16);
                                }

                                if (dev < 0) {
                                        printf("Cannot find dev.\n");
                                        return 1;
                                }

                                struct mmc *mmc = find_mmc_device(dev);

                                if (flag == 1) { // mmc write logo add offset size
                                        struct partitions *part_info  = find_mmc_partition_by_name(name);

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
                                }
                                else if(flag == 2){
                                        int tmp_shift = ffs( mmc->read_bl_len) -1;
                                        cnt = size >> tmp_shift;
                                        blk = offset_addr >> tmp_shift;
                                        sz_byte = size - (cnt<<tmp_shift);
                                }

                                if (!mmc)
                                        return 1;

                                printf("MMC erase: dev # %d, start_erase_address(in block) # %#llx, several blocks  # %lld will be erased ...\n ",
                                                dev, blk, cnt);

                                mmc_init(mmc);

                                if (cnt != 0)
                                        n = mmc->block_dev.block_erase(dev, blk, cnt);

                                printf("dev # %d, %s, several blocks erased %s\n",
                                                dev, (flag == 0) ? " ":(argv[2]),(n == 0) ? "OK" : "ERROR");

                                return (n == 0) ? 0 : 1;

                        } else if (strcmp(argv[1], "ext_csd") == 0) {
                            int ret;
                            int dev = simple_strtoul(argv[2], NULL, 10);
                            int bit = simple_strtoul(argv[3], NULL, 10);
                            int val = simple_strtoul(argv[4], NULL, 16);
                            if ((bit > 191) || (bit < 0)) {
                                printf("bit is not able to write!\n");
                                return 1;
                            }
                            struct mmc* mmc = find_mmc_device(dev);
                            if (!mmc) {
                                puts("no mmc devices available\n");
                                return 1;
                            }
                            mmc_init(mmc);
                            ret = mmc_set_ext_csd(mmc, bit, val);
                            printf("write EXT_CSD bit[%d] val[0x%x] %s\n",
                                    bit, val, (ret == 0) ? "ok" : "fail");
                            return ret;

                        } else
                                rc = cmd_usage(cmdtp);

                        return rc;
        }
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
    "amlmmc switch <device_num> <part name> - part name : boot0, boot1, user\n"
    "amlmmc status <device_num> - read sd/emmc device status\n"
    "amlmmc ext_csd <bit> <value> - read/write sd/emmc device EXT_CSD [bit] value\n"
    "amlmmc response <device_num> - read sd/emmc last command response\n"
    "amlmmc controller <device_num> - read sd/emmc controller register\n");

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

static int _dtb_read(struct mmc *mmc, u64 blk, void * addr)
{
    int dev = EMMC_DTB_DEV;
    u64 n, cnt = DTB_BLK_CNT;
    n = mmc->block_dev.block_read(dev, blk, cnt, addr);
	if (n != cnt) {
        dtb_err("%s: dev # %d, block # %#llx, count # %#llx ERROR!\n",
                __func__, dev, blk, cnt);
    }

    return (n != cnt);
}
static int _dtb_write(struct mmc *mmc, u64 blk, void * addr)
{
    int dev = EMMC_DTB_DEV;
    u64 n, cnt = DTB_BLK_CNT;
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
    u64 blk;
    int dev = EMMC_DTB_DEV;
    struct aml_dtb_info *info = &dtb_infos;

    /* short cut */
	if (info->valid[0]) {
        dtb_info("short cut in...\n");
        blk = DTB_GLB_OFFSET / mmc->read_bl_len;
		if (_dtb_read(mmc, blk, addr)) {
            dtb_err("%s: dev # %d, block # %#llx ERROR!\n",
                    __func__, dev, blk);
            /*try dtb2 if it's valid */
			if (info->valid[1]) {
                blk = (DTB_GLB_OFFSET + DTB_SIZE) / mmc->read_bl_len;
				if (_dtb_read(mmc, blk, addr)) {
                    dtb_err("%s: dev # %d, block # %#llx ERROR!\n",
                        __func__, dev, blk);
                    return -1;
                }
            }
        }
        return 0;
    }

    return -2;
}

int dtb_read(void *addr)
{
    int ret = 0, dev = EMMC_DTB_DEV;
    u64 blk;
    struct aml_dtb_rsv * dtb = (struct aml_dtb_rsv *) addr;
    struct aml_dtb_info *info = &dtb_infos;
    int cpy = 1, valid = 0;
    struct mmc * mmc;

    mmc = _dtb_init();
	if (NULL == mmc)
        return -10;

	if (0 == dtb_read_shortcut(mmc, addr))
        return ret;

    /* read dtb2 1st, for compatibility without checksum. */
	while (cpy >= 0) {
        blk = (DTB_GLB_OFFSET + cpy * DTB_SIZE) / mmc->read_bl_len;
		if (_dtb_read(mmc, blk, addr)) {
            dtb_err("%s: dev # %d, block # %#llx ERROR!\n",
                    __func__, dev, blk);
        } else {
            ret = _verify_dtb_checksum(dtb);
			if (!ret) {
                info->stamp[cpy] = dtb->timestamp;
                info->valid[cpy] = 1;
            }
            else
                dtb_wrn("cpy %d is not valid\n", cpy);
        }
        valid += info->valid[cpy];
        cpy --;
    }
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
			if (info->valid[1]) {
                blk = (DTB_GLB_OFFSET + DTB_SIZE) / mmc->read_bl_len;
				if (_dtb_read(mmc, blk, addr)) {
                    dtb_err("%s: dev # %d, block # %#llx, ERROR!\n",
                            __func__, dev, blk);
                    ret = -2;
                }
                /* fixme, update the invalid one - dtb1 */
                blk = (DTB_GLB_OFFSET) / mmc->read_bl_len;
				if (_dtb_write(mmc, blk, addr)) {
                    dtb_err("%s: dev # %d, block # %#llx ERROR!\n",
                            __func__, dev, blk);
                    ret = -4;
                }
                info->valid[0] = 1;
                info->stamp[0] = dtb->timestamp;
                ret = 0;
            } else {
                dtb_info("update dtb2");
                blk = (DTB_GLB_OFFSET + DTB_SIZE) / mmc->read_bl_len;
				if (_dtb_write(mmc, blk, addr)) {
                    dtb_err("%s: dev # %d, block # %#llx ERROR!\n",
                            __func__, dev, blk);
                    ret = -2;
                }
                info->valid[1] = 1;
                info->stamp[1] = dtb->timestamp;
            }
        break;
        /* both are valid, pickup new one. */
        case 2:
			if (stamp_after(info->stamp[1], info->stamp[0])) {
                blk = (DTB_GLB_OFFSET + DTB_SIZE) / mmc->read_bl_len;
				if (_dtb_read(mmc, blk, addr)) {
                    dtb_err("%s: dev # %d, block # %#llx ERROR!\n",
                            __func__, dev, blk);
                    ret = -3;
                }
                /*update dtb1*/
                blk = DTB_GLB_OFFSET / mmc->read_bl_len;
				if (_dtb_write(mmc, blk, addr)) {
                    dtb_err("%s: dev # %d, block # %#llx ERROR!\n",
                            __func__, dev, blk);
                    ret = -3;
                }
                info->stamp[0] = dtb->timestamp;
                ret = 0;
            } else if (stamp_after(info->stamp[0], info->stamp[1])) {
                /*update dtb2*/
                blk = (DTB_GLB_OFFSET + DTB_SIZE) / mmc->read_bl_len;
				if (_dtb_write(mmc, blk, addr)) {
                    dtb_err("%s: dev # %d, block # %#llx ERROR!\n",
                            __func__, dev, blk);
                    ret = -3;
                }
                info->stamp[1] = dtb->timestamp;
            } else {
                dtb_info("do nothing\n");
            }
        break;
        default:
            dtb_err("impossble valid values.\n");
            BUG();
        break;
    }

_out:
    return ret;
}


static int dtb_write(void *addr)
{
    int ret = 0;
    struct aml_dtb_rsv * dtb = (struct aml_dtb_rsv *) addr;
    struct aml_dtb_info *info = &dtb_infos;
    u64 blk;
    int cpy, valid;
    struct mmc * mmc;

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
        blk = (DTB_GLB_OFFSET + cpy * DTB_SIZE) / mmc->read_bl_len;
        ret |= _dtb_write(mmc, blk, addr);
        info->valid[cpy] = 1;
        info->stamp[cpy] = dtb->timestamp;
    }

    return ret;
}

int do_amlmmc_dtb_key(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
        int dev, ret = 0;
        void *addr = NULL;
        u64 cnt =0,n =0, blk =0;
        //u64 size;

    switch (argc) {
        case 3:
            if (strcmp(argv[1], "erase") == 0) {
                if (strcmp(argv[2], "dtb") == 0) {
                    printf("start erase dtb......\n");
                    dev = EMMC_DTB_DEV;
                    struct mmc *mmc = find_mmc_device(dev);
                    if (!mmc) {
                        printf("not find mmc\n");
                        return 1;
                    }
                    blk = DTB_GLB_OFFSET / mmc->read_bl_len;
                    cnt = DTB_AREA_BLK_CNT;
                    if (cnt != 0)
                        n = mmc->block_dev.block_erase(dev, blk, cnt);
                    printf("dev # %d, %s, several blocks erased %s\n",
                            dev, (flag == 0) ? " ":(argv[2]),(n == 0) ? "OK" : "ERROR");
                    return (n == 0) ? 0 : 1;
                }else if (strcmp(argv[2], "key") == 0){
                    printf("start erase key......\n");
                    dev = 1;
                    struct mmc *mmc = find_mmc_device(dev);
                    if (!mmc) {
                        printf("not find mmc\n");
                        return 1;
                    }
                    n = mmc_key_erase();
                    printf("dev # %d, %s, several blocks erased %s\n",
                            dev, (flag == 0) ? " ":(argv[2]),(n == 0) ? "OK" : "ERROR");
                    return (n == 0) ? 0 : 1;
                }
            }
        case 4:
            addr = (void *)simple_strtoul(argv[2], NULL, 16);
            if (strcmp(argv[1], "dtb_read") == 0) {
                /* fixme, */
                ret = dtb_read(addr);
                return 0;

            } else if (strcmp(argv[1], "dtb_write") == 0) {
                /* fixme, should we check the return value? */
                ret = dtb_write(addr);
                ret = mmc_device_init(_dtb_init());
                if (ret == 0) {
                    printf(" partition table success\n");
                    return 0;
                }
                printf(" partition table error\n");
                return 1;
            }
            return 0;
        default:
            break;
    }
    return 1;
}

U_BOOT_CMD(
    emmc, 4, 1, do_amlmmc_dtb_key,
    "EMMC sub system",
    "emmc dtb_read addr size\n"
    "emmc dtb_write addr size\n"
    "emmc erase dtb\n"
    "emmc erase key\n");
