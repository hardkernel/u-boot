/*
 * (C) Copyright 2013 Amlogic, Inc
 *
 * This file is used to run commands from misc partition
 * More detail to check the command "run bcb_cmd" usage
 *
 * cheng.wang@amlogic.com,
 * 2015-04-23 @ Shenzhen
 *
 */
#include <common.h>
#include <command.h>
#include <environment.h>
#include <malloc.h>
#ifdef CONFIG_AML_MTD
#include <linux/mtd/mtd.h>
#endif
#include <asm/byteorder.h>
#include <config.h>
#include <asm/arch/io.h>
#include <partition_table.h>
#include <version.h>


#ifdef CONFIG_BOOTLOADER_CONTROL_BLOCK
extern int store_read_ops(
    unsigned char *partition_name,
    unsigned char * buf, uint64_t off, uint64_t size);
extern int store_write_ops(
    unsigned char *partition_name,
    unsigned char * buf, uint64_t off, uint64_t size);

#define COMMANDBUF_SIZE 32
#define STATUSBUF_SIZE      32
#define RECOVERYBUF_SIZE 768

#define BOOTINFO_OFFSET 864
#define SLOTBUF_SIZE    32
#define MISCBUF_SIZE  1088

struct bootloader_message {
    char command[32];
    char status[32];
    char recovery[768];

    // The 'recovery' field used to be 1024 bytes.  It has only ever
    // been used to store the recovery command line, so 768 bytes
    // should be plenty.  We carve off the last 256 bytes to store the
    // stage string (for multistage packages) and possible future
    // expansion.
    char stage[32];
    char slot_suffix[32];
    char reserved[192];
};

typedef struct BrilloSlotInfo {
    uint8_t bootable;
    uint8_t online;
    uint8_t reserved[2];
} BrilloSlotInfo;

typedef struct BrilloBootInfo {
    // Used by fs_mgr. Must be NUL terminated.
    char bootctrl_suffix[4];

    // Magic for identification - must be 'B', 'C', 'c' (short for
    // "boot_control copy" implementation).
    uint8_t magic[3];

    // Version of BrilloBootInfo struct, must be 0 or larger.
    uint8_t version;

    // Currently active slot.
    uint8_t active_slot;

    // Information about each slot.
    BrilloSlotInfo slot_info[2];
    uint8_t attemp_times;

    uint8_t reserved[14];
} BrilloBootInfo;

/*static int clear_misc_partition(char *clearbuf, int size)
{
    char *partition = "misc";

    memset(clearbuf, 0, size);
    if (store_write_ops((unsigned char *)partition,
        (unsigned char *)clearbuf, 0, size) < 0) {
        printf("failed to clear %s.\n", partition);
        return -1;
    }

    return 0;
}*/

bool boot_info_validate(BrilloBootInfo* info)
{
    if (info->magic[0] != 'B' ||
        info->magic[1] != 'C' ||
        info->magic[2] != 'c')
        return false;
    if (info->active_slot >= 2)
        return false;
    return true;
}

void boot_info_reset(BrilloBootInfo* info)
{
  memset(info, '\0', SLOTBUF_SIZE);
  info->magic[0] = 'B';
  info->magic[1] = 'C';
  info->magic[2] = 'c';
  info->active_slot = 0;
  info->slot_info[0].bootable = 1;
  info->slot_info[0].online= 1;
  info->slot_info[1].bootable = 0;
  info->slot_info[1].online= 0;
  info->attemp_times = 0;
  memcpy(info->bootctrl_suffix,"_a",4);
}

void dump_boot_info(BrilloBootInfo* info)
{
    printf("info->attemp_times = %u\n", info->attemp_times);
    printf("info->active_slot = %u\n", info->active_slot);
    printf("info->slot_info[0].bootable = %u\n", info->slot_info[0].bootable);
    printf("info->slot_info[0].online = %u\n", info->slot_info[0].online);
    printf("info->slot_info[1].bootable = %u\n", info->slot_info[1].bootable);
    printf("info->slot_info[1].online = %u\n", info->slot_info[1].online);
    printf("info->attemp_times = %u\n", info->attemp_times);
}


int boot_info_get_attemp_times(BrilloBootInfo* info)
{
    return info->attemp_times;
}

int boot_info_change_online_slot(BrilloBootInfo* info)
{
    BrilloSlotInfo tmp_info;
    memcpy(&tmp_info, &(info->slot_info[0]), sizeof(BrilloSlotInfo));
    memcpy(&(info->slot_info[0]), &(info->slot_info[1]), sizeof(BrilloSlotInfo));
    memcpy(&(info->slot_info[1]), &tmp_info, sizeof(BrilloSlotInfo));
    info->attemp_times = 0;
    return 0;
}


int boot_info_get_online_slot(BrilloBootInfo* info)
{
    if (info->slot_info[0].online == 1)
        return 0;

    if (info->slot_info[1].online == 1)
        return 1;

    return 0;
}

int boot_info_set_active_slot(BrilloBootInfo* info, int slot)
{
    if (slot == 0) {
        info->active_slot = 0;
        info->slot_info[0].bootable = 1;
        info->slot_info[0].online= 1;
        info->slot_info[1].bootable = 0;
        info->slot_info[1].online= 0;
        info->attemp_times = 0;
        memcpy(info->bootctrl_suffix,"_a",4);
    } else {
        info->active_slot = 1;
        info->slot_info[0].bootable = 0;
        info->slot_info[0].online= 0;
        info->slot_info[1].bootable = 1;
        info->slot_info[1].online= 1;
        info->attemp_times = 0;
        memcpy(info->bootctrl_suffix,"_b",4);
    }

    dump_boot_info(info);

    return 0;
}

int boot_info_open_partition(char *miscbuf)
{
    char *partition = "misc";
    //int i;
    printf("Start read %s partition datas!\n", partition);
    if (store_read_ops((unsigned char *)partition,
        (unsigned char *)miscbuf, 0, MISCBUF_SIZE) < 0) {
        printf("failed to store read %s.\n", partition);
        return -1;
    }

    /*for (i = BOOTINFO_OFFSET;i < (BOOTINFO_OFFSET+SLOTBUF_SIZE);i++)
        printf("buf: %c \n", miscbuf[i]);*/
    return 0;
}

bool boot_info_load(BrilloBootInfo *out_info, char *miscbuf)
{
    memcpy(out_info, miscbuf+BOOTINFO_OFFSET, SLOTBUF_SIZE);
    dump_boot_info(out_info);
    return true;
}

bool boot_info_save(BrilloBootInfo *info, char *miscbuf)
{
    char *partition = "misc";
    printf("save boot-info \n");
    memcpy(miscbuf+BOOTINFO_OFFSET, info, SLOTBUF_SIZE);
    dump_boot_info(info);
#ifdef CONFIG_AML_MTD
    if (NAND_BOOT_FLAG == device_boot_flag || SPI_NAND_FLAG == device_boot_flag) {
        int ret = 0;
        ret = run_command("store erase partition misc", 0);
        if (ret != 0) {
            printf("erase partition misc failed!\n");
            return false;
        }
    }
#endif
    store_write_ops((unsigned char *)partition, (unsigned char *)miscbuf, 0, MISCBUF_SIZE);
    return true;
}

static int do_GetValidSlot(
    cmd_tbl_t * cmdtp,
    int flag,
    int argc,
    char * const argv[])
{
    char miscbuf[4096] = {0};
    BrilloBootInfo info;
    int attemp_times;
    int slot;
    int ret = 0;

    if (argc != 1) {
        return cmd_usage(cmdtp);
    }

    ret = boot_info_open_partition(miscbuf);
    if (ret != 0) {
        return -1;
    }
    boot_info_load(&info, miscbuf);

#ifndef CONFIG_AB_SYSTEM
    char command[32];
    memcpy(command, miscbuf, 32);
    if (!memcmp(command, "boot-recovery", strlen("boot-recovery"))) {
        run_command("run init_display", 0);
        run_command("run storeargs", 0);
        if (run_command("run recovery_from_flash", 0) < 0) {
            printf("run_command for cmd:run recovery_from_flash failed.\n");
            return -1;
        }
        printf("run command:run recovery_from_flash successful.\n");
        return 0;
    }
#endif

    if (!boot_info_validate(&info)) {
        printf("boot-info is invalid. Resetting.\n");
        boot_info_reset(&info);
        boot_info_save(&info, miscbuf);
    }

    attemp_times = boot_info_get_attemp_times(&info);
    printf("attemp_times = %d \n", attemp_times);

    if (attemp_times == -1) {
        boot_info_change_online_slot(&info);
    }

    //slot = boot_info_get_online_slot(&info);
    slot = info.active_slot;
    printf("active slot = %d \n", slot);

#ifdef CONFIG_AML_MTD
    //check if boot_a/b on nand
    if (device_boot_flag == NAND_BOOT_FLAG) {
        struct mtd_info *nand;
        nand = get_mtd_device_nm("boot_a");
        if (!IS_ERR(nand)) {
            has_boot_slot = 1;
        }
        else
            has_boot_slot = 0;
    }
#endif

    if (slot == 0) {
        if (has_boot_slot == 1) {
            setenv("active_slot","_a");
            setenv("boot_part","boot_a");
            setenv("slot-suffixes","0");
        }
        else {
            setenv("active_slot","normal");
            setenv("boot_part","boot");
        }
    }
    else {
        if (has_boot_slot == 1) {
            setenv("active_slot","_b");
            setenv("boot_part","boot_b");
            setenv("slot-suffixes","1");
        }
        else {
            setenv("active_slot","normal");
            setenv("boot_part","boot");
        }
    }

    return 0;
}

static int do_SetActiveSlot(
    cmd_tbl_t * cmdtp,
    int flag,
    int argc,
    char * const argv[])
{
    char miscbuf[4096] = {0};
    BrilloBootInfo info;
    int ret = 0;

    if (argc != 2) {
        return cmd_usage(cmdtp);
    }

    if (has_boot_slot == 0) {
        printf("device is not ab mode\n");
        return -1;
    }

    ret = boot_info_open_partition(miscbuf);
    if (ret != 0) {
        return -1;
    }
    boot_info_load(&info, miscbuf);

    if (!boot_info_validate(&info)) {
        printf("boot-info is invalid. Resetting.\n");
        boot_info_reset(&info);
        boot_info_save(&info, miscbuf);
    }

    if (strcmp(argv[1], "a") == 0) {
        setenv("active_slot","_a");
        setenv("boot_part","boot_a");
        setenv("slot-suffixes","0");
        printf("set active slot a \n");
        boot_info_set_active_slot(&info, 0);
    } else if (strcmp(argv[1], "b") == 0) {
        setenv("active_slot","_b");
        setenv("boot_part","boot_b");
        setenv("slot-suffixes","1");
        printf("set active slot b \n");
        boot_info_set_active_slot(&info, 1);
    } else {
        printf("error input slot\n");
        return -1;
    }

    boot_info_save(&info, miscbuf);

    return 0;
}

int do_GetSystemMode (cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
    char* system;
#ifdef CONFIG_SYSTEM_AS_ROOT
    system = CONFIG_SYSTEM_AS_ROOT;
#else
    setenv("system_mode","0");
    return 0;
#endif
    strcpy(system, CONFIG_SYSTEM_AS_ROOT);
    printf("CONFIG_SYSTEM_AS_ROOT: %s \n", CONFIG_SYSTEM_AS_ROOT);
    if (strcmp(system, "systemroot") == 0) {
        setenv("system_mode","1");
    }
    else
        setenv("system_mode","0");

    return 0;

}

int do_GetAvbMode (cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
    setenv("avb2","0");

    return 0;
}

#endif /* CONFIG_BOOTLOADER_CONTROL_BLOCK */

U_BOOT_CMD(
    get_valid_slot, 2, 0, do_GetValidSlot,
    "get_valid_slot",
    "\nThis command will choose valid slot to boot up which saved in misc\n"
    "partition by mark to decide whether execute command!\n"
    "So you can execute command: get_valid_slot"
);

U_BOOT_CMD(
    set_active_slot, 2, 1, do_SetActiveSlot,
    "set_active_slot",
    "\nThis command will set active slot\n"
    "So you can execute command: set_active_slot a"
);

U_BOOT_CMD(
    get_system_as_root_mode, 1,	0, do_GetSystemMode,
    "get_system_as_root_mode",
    "\nThis command will get system_as_root_mode\n"
    "So you can execute command: get_system_as_root_mode"
);

U_BOOT_CMD(
    get_avb_mode, 1,	0, do_GetAvbMode,
    "get_avb_mode",
    "\nThis command will get avb mode\n"
    "So you can execute command: get_avb_mode"
);

