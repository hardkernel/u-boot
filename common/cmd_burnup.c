#include <command.h>
#include <watchdog.h>
#include <malloc.h>
#include <common.h>
#include <linux/ctype.h>
#include <asm/byteorder.h>
#include <div64.h>
#include <linux/err.h>
#include <partition_table.h>
#include <mmc.h>

#define DbgP(fmt...)   //printf("[burnupDbg]"fmt)
#define MsgP(fmt...)   printf("[burnup]"fmt)
#define ErrP(fmt...)   printf("[burnup]Err:%s,L%d:", __func__, __LINE__),printf(fmt)

static unsigned char *cmd_name = (unsigned char *)("store");
const char*   _usbDownPartImgType = "";

#define MtdAlignBits    (12) //32k
#define MtdAlignSz      (1U << MtdAlignBits)
#define MtdAlignMask    (MtdAlignSz - 1)

/***
upgrade_read_ops:

partition_name: env / logo / recovery /boot / system /cache /media

 ***/

int store_read_ops(unsigned char *partition_name,unsigned char * buf, uint64_t off, uint64_t size)
{
        unsigned char *name;
        uint64_t addr;
        char	str[128];
        int ret =0;

        if (!buf) {
                ErrP("upgrade: no buf!!");
                return -1;
        }

        name = partition_name;
        addr = (unsigned long)buf;
        if ((EMMC_BOOT_FLAG == device_boot_flag) && !strcmp("1", (char*)name))
        {
            if (off & 0x1ff) {
                ErrP("emmc1 invalid offset 0x%llx\n", off);
                return -__LINE__;
            }
            if (size & 0xff) {
                MsgP("NOT align sz 0x%llx\n", size);
            }
            sprintf(str, "mmc read 0x%p 0x%llx 0x%llx", buf, (off>>9), (size>>9));
            ret = run_command(str, 0);
            if (ret) {
                ErrP("Fail in cmd[%s]\n", str);
                return -__LINE__;
            }
            return ret;
        }

#if CONFIG_AML_MTD
        if ((size & MtdAlignMask) && (NAND_BOOT_FLAG == device_boot_flag )) {
                MsgP("Rd:Up sz 0x%llx to align 0x%x\n", size, MtdAlignSz);
                size = ((size + MtdAlignMask)>>MtdAlignBits) << MtdAlignBits;
        }
#if defined(UBIFS_IMG) || defined(CONFIG_CMD_UBIFS)
        if (!strcmp(_usbDownPartImgType, "ubifs")) {
                sprintf(str, "%s  read 0x%llx %s 0x%llx", "ubi", addr, name, size);
                MsgP("cmd[%s]", str);
        } else
#endif
#endif//#if CONFIG_AML_MTD
        {// not ubi part
                sprintf(str, "%s  read %s 0x%llx  0x%llx  0x%llx", cmd_name, name, addr, off, size);
        }

        DbgP("run cmd[%s]\n", str);
        ret = run_command(str, 0);
        if (ret != 0) {
                ErrP("cmd failed, ret=%d, [%s]\n", ret, str);
                return -1;
        }

        return 0;
}

/***
upgrade_write_ops:

partition_name: env / logo / recovery /boot / system /cache /media

 ***/

int store_write_ops(unsigned char *partition_name,unsigned char * buf, uint64_t off, uint64_t size)
{
        unsigned char *name;
        uint64_t addr;
        char	str[128];
        int ret =0;

        if (!buf) {
                store_msg("upgrade: no buf!!");
                return -1;
        }

        name = partition_name;
        addr = (unsigned long)buf;
        if ((EMMC_BOOT_FLAG == device_boot_flag) && !strcmp("1", (char*)name))
        {
            if (off & 0x1ff) {
                ErrP("emmc1 invalid offset 0x%llx\n", off);
                return -__LINE__;
            }
            if (size & 0xff) {
                MsgP("NOT align sz 0x%llx\n", size);
            }
            sprintf(str, "mmc write 0x%p 0x%llx 0x%llx", buf, (off>>9), (size>>9));
            ret = run_command(str, 0);
            if (ret) {
                ErrP("Fail in cmd[%s]\n", str);
                return -__LINE__;
            }
            return ret;
        }

#if CONFIG_AML_MTD
        if ((size & MtdAlignMask) && (NAND_BOOT_FLAG == device_boot_flag )) {
                MsgP("Wr:Up sz 0x%llx to align 0x%x\n", size, MtdAlignSz);
                size = ((size + MtdAlignMask)>>MtdAlignBits) << MtdAlignBits;
        }
#if defined(UBIFS_IMG) || defined(CONFIG_CMD_UBIFS)
        if (!strcmp(_usbDownPartImgType, "ubifs")) {//ubi part
                sprintf(str, "%s  write 0x%llx %s 0x%llx  ", "ubi", addr, name, size);
        } else
#endif// #if defined(UBIFS_IMG) || defined(CONFIG_CMD_UBIFS)
#endif// #if CONFIG_AML_MTD
        {
                sprintf(str, "%s  write %s 0x%llx  0x%llx  0x%llx", cmd_name, name, addr, off, size);
        }

        DbgP("run cmd[%s]\n", str);
        ret = run_command(str, 0);
        if (ret != 0) {
                ErrP("cmd [%s] failed ", str);
                return -1;
        }

        return 0;
}


/***
upgrade_write_ops:

partition_name: env / logo / recovery /boot / system /cache /media

 ***/

int store_get_partititon_size(unsigned char *partition_name, uint64_t *size)
{
    char	str[128];
    int ret=0;

    if (isdigit(*partition_name) && 1 == strlen((char*)partition_name))
    {
        const int curDev = *partition_name - '0';
        sprintf(str, "mmc dev %d", curDev);
        MsgP("cmd[%s]\n", str);
        if (run_command(str, 0)) {
            ErrP("Fail probe dev %d\n", curDev);
            return 0;
        }
        struct mmc *mmc = find_mmc_device(curDev);
        if (!mmc) {
            ErrP("Fail find mmc  %s\n", partition_name);
            return 0;
        }
        if (mmc_init(mmc)) {
            ErrP("FAil init mmc %s\n", partition_name);
            return 0;
        }
        MsgP("mmc %s capacity 0x%llx\n", partition_name, mmc->capacity);
        *size = mmc->capacity;
        run_command("store disprotect key", 0);
        MsgP("cmd[%s]\n", str);
        return 0;
    }

    sprintf(str, "%s  size %s 0x%p ",cmd_name, partition_name, size);
    store_dbg("command:	%s", str);
    ret = run_command(str, 0);
    if (ret != 0) {
        ErrP("cmd [%s] size failed ", str);
        return -1;
    }

    return ret;
}


/***
upgrade_erase_ops:

partition_name: boot / data

flag = 0; indicate erase partition ;
flag = 1; indicate scurb whole nand;

 ***/
int store_erase_ops(unsigned char *par_name, uint64_t off, uint64_t size, unsigned char flag)
{
        unsigned char *name;
        char	str[128];
        int ret=0;

        name = par_name;
        if (flag == 0) {
                sprintf(str, "%s  erase %s 0x%llx  0x%llx",cmd_name, name, off, size);
                store_dbg("command:	%s", str);
                ret = run_command(str, 0);
                if (ret != 0) {
                        store_msg("cmd %s erase failed",cmd_name);
                        return -1;
                }

        }else if(flag == 1){

                sprintf(str, "%s  rom_protect off ",cmd_name);
                store_dbg("command:	%s", str);
                ret = run_command(str, 0);
                if (ret != 0) {
                        store_msg("cmd %s scrub failed ",cmd_name);
                        return -1;
                }

                sprintf(str, "%s  scrub  0x%llx ",cmd_name, (long long unsigned int)0);
                store_dbg("command:	%s", str);
                ret = run_command(str, 0);
                if (ret != 0) {
                        store_msg("cmd %s scrub failed",cmd_name);
                        return -1;
                }
        }

        return 0;
}

/***
bootloader:
 ***/
int store_boot_read(unsigned char * buf, uint64_t off, uint64_t size)
{
        //unsigned char *name;
        uint64_t addr;
        char	str[128];
        int ret =0;

        if (!buf) {
                store_msg("upgrade: no buf!!");
                return -1;
        }

        addr = (unsigned long)buf;
        store_dbg("store_boot_read: addr 0x%llx\n",addr);

        sprintf(str, "%s  rom_read 0x%llx  0x%llx  0x%llx",cmd_name, addr, off, size);
        store_dbg("command:	%s", str);
        ret = run_command(str, 0);
        if (ret != 0) {
                store_msg("cmd %s  rom_read failed",cmd_name);
                return -1;
        }

        return 0;

}

int store_boot_write(unsigned char * buf,uint64_t off, uint64_t size)
{
        //unsigned char *name;
        uint64_t addr;
        char	str[128];
        int ret =0;

        if (!buf) {
                store_msg("upgrade: no buf!!");
                return -1;
        }

        addr = (unsigned long)buf;

        sprintf(str, "%s  rom_write 0x%llx  0x%llx  0x%llx",cmd_name, addr, off, size);
        store_dbg("command:	%s", str);
        ret = run_command(str, 0);
        if (ret != 0) {
                store_msg("cmd %s rom_write failed",cmd_name);
                return -1;
        }

        return 0;

}


int store_init(unsigned  flag)
{
        //unsigned char *name;
        //unsigned long addr;
        char	str[128];
        int ret =0;
        store_dbg("flag : %d",flag);

        sprintf(str, "%s  init %d",cmd_name,flag);
        store_dbg("command:	%s", str);
        ret = run_command(str, 0);
        if (ret != 0) {
                store_msg("cmd [%s] init failed ",str);
                return -1;
        }
        return 0;
}


int store_exit(void)
{
        //unsigned char *name;
        //unsigned long addr;
        char	str[128];
        int ret =0;

        sprintf(str, "%s  exit",cmd_name);
        printf("command:	%s\n", str);
        ret = run_command(str, 0);
        if (ret != 0) {
                store_msg("cmd %s exit failed",cmd_name);
                return -1;
        }

        return 0;

}

//store dtb read/write buf sz
//@rwFlag: 0---read, 1---write, 2---iread
int store_dtb_rw(void* buf, unsigned dtbSz, int rwFlag)
{
    char _cmdBuf[128];
    char* ops = !rwFlag ? "read" : ((1==rwFlag) ? "write" : "iread");

    sprintf(_cmdBuf, "store dtb %s 0x%p 0x%x", ops, buf, dtbSz);
    return run_command(_cmdBuf, 0);
}

#if 0
int do_store_test(cmd_tbl_t * cmdtp, int flag, int argc, char *argv[])
{
        int i, init_flag=0,dev, ret = 0;
        ulong addr;
        uint64_t off, size;
        char *cmd, *s, *area;
        char	str[128];
        unsigned char *buf;

        cmd = argv[1];

        buf = malloc(0x400000);
        if (!buf) {
                printf("do_store_test : malloc failed\n");
                return -1;
        }

        area ="logo";

        if (strcmp(cmd, "read") == 0) {
                ret = store_read_ops(area,buf,0x0,0x40000);
                if (ret < 0) {
                        printf("store read failed\n");
                        return -1;
                }
                printf("store read OK\n");
        }

        if (strcmp(cmd, "boot_read") == 0) {
                ret = store_boot_read(buf,0x0,0x60000);
                if (ret < 0) {
                        printf("store boot_read failed\n");
                        return -1;
                }
                printf("store boot_read OK\n");
        }

        if (strcmp(cmd, "init") == 0) {
                ret = store_init(0x0);
                if (ret < 0) {
                        printf("store init failed\n");
                        return -1;
                }
                printf("store init OK\n");
        }

        if (strcmp(cmd, "write") == 0) {
                memset(buf,0xa5,0x400000);
                ret = store_write_ops(area,buf,0x0,0x40000);
                if (ret < 0) {
                        printf("store write failed\n");
                        return -1;
                }
                printf("store write OK\n");
        }

        if (strcmp(cmd, "erase") == 0) {
                area = "data";
                ret = store_erase_ops(area,0x0,0,0);
                if (ret < 0) {
                        printf("store write failed\n");
                        return -1;
                }
        }

        if (strcmp(cmd, "size") == 0) {
                uint64_t off=0, size;

                ret = store_get_partititon_size(area,&size);
                if (ret < 0) {
                        printf("store write failed\n");
                        return -1;
                }
                printf("off =%llx size=%llx\n",off,size);
        }

        if (buf)
                kfree(buf);
        return 0;

}

U_BOOT_CMD(store_test, CONFIG_SYS_MAXARGS, 1, do_store_test,
                "NAND sub-system",
                "store read name addr off|partition size\n"
                "    read 'size' bytes starting at offset 'off'\n"
                "    to/from memory address 'addr', skipping bad blocks.\n"
                "store write name addr off|partition size\n"
                "    write 'size' bytes starting at offset 'off'\n"
                "    to/from memory address 'addr', skipping bad blocks.\n"
                "store erase boot/data: \n"
                "erase the area which is uboot or datas \n"
                "store scrub off|partition size\n"
                "scrub the area from offset and size \n"
          );
#endif

