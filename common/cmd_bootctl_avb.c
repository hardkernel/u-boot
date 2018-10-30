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
#include <asm/byteorder.h>
#include <config.h>
#include <asm/arch/io.h>
#include <partition_table.h>
#include <libavb.h>
#include <version.h>


#ifdef CONFIG_BOOTLOADER_CONTROL_BLOCK
extern int store_read_ops(
    unsigned char *partition_name,
    unsigned char * buf, uint64_t off, uint64_t size);
extern int store_write_ops(
    unsigned char *partition_name,
    unsigned char * buf, uint64_t off, uint64_t size);

#define AB_METADATA_MISC_PARTITION_OFFSET 2048

#define MISCBUF_SIZE  2080


/* Magic for the A/B struct when serialized. */
#define AVB_AB_MAGIC "\0AB0"
#define AVB_AB_MAGIC_LEN 4

/* Versioning for the on-disk A/B metadata - keep in sync with avbtool. */
#define AVB_AB_MAJOR_VERSION 1
#define AVB_AB_MINOR_VERSION 0

/* Size of AvbABData struct. */
#define AVB_AB_DATA_SIZE 32

/* Maximum values for slot data */
#define AVB_AB_MAX_PRIORITY 15
#define AVB_AB_MAX_TRIES_REMAINING 7

/* Struct used for recording per-slot metadata.
 *
 * When serialized, data is stored in network byte-order.
 */
typedef struct AvbABSlotData {
  /* Slot priority. Valid values range from 0 to AVB_AB_MAX_PRIORITY,
   * both inclusive with 1 being the lowest and AVB_AB_MAX_PRIORITY
   * being the highest. The special value 0 is used to indicate the
   * slot is unbootable.
   */
  uint8_t priority;

  /* Number of times left attempting to boot this slot ranging from 0
   * to AVB_AB_MAX_TRIES_REMAINING.
   */
  uint8_t tries_remaining;

  /* Non-zero if this slot has booted successfully, 0 otherwise. */
  uint8_t successful_boot;

  /* Reserved for future use. */
  uint8_t reserved[1];
} AvbABSlotData;

/* Struct used for recording A/B metadata.
 *
 * When serialized, data is stored in network byte-order.
 */
typedef struct AvbABData {
  /* Magic number used for identification - see AVB_AB_MAGIC. */
  uint8_t magic[AVB_AB_MAGIC_LEN];

  /* Version of on-disk struct - see AVB_AB_{MAJOR,MINOR}_VERSION. */
  uint8_t version_major;
  uint8_t version_minor;

  /* Padding to ensure |slots| field start eight bytes in. */
  uint8_t reserved1[2];

  /* Per-slot metadata. */
  AvbABSlotData slots[2];

  /* Reserved for future use. */
  uint8_t reserved2[12];

  /* CRC32 of all 28 bytes preceding this field. */
  uint32_t crc32;
}AvbABData;

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

bool boot_info_validate(AvbABData* info)
{
    if (memcmp(info->magic, AVB_AB_MAGIC, AVB_AB_MAGIC_LEN) != 0) {
        printf("Magic %s is incorrect.\n", info->magic);
        return false;
    }
    if (info->version_major > AVB_AB_MAJOR_VERSION) {
        printf("No support for given major version.\n");
        return false;
    }
    return true;
}

void boot_info_reset(AvbABData* info)
{
    memset(info, '\0', sizeof(AvbABData));
    memcpy(info->magic, AVB_AB_MAGIC, AVB_AB_MAGIC_LEN);
    info->version_major = AVB_AB_MAJOR_VERSION;
    info->version_minor = AVB_AB_MINOR_VERSION;
    info->slots[0].priority = AVB_AB_MAX_PRIORITY;
    info->slots[0].tries_remaining = AVB_AB_MAX_TRIES_REMAINING;
    info->slots[0].successful_boot = 0;
    info->slots[1].priority = AVB_AB_MAX_PRIORITY - 1;
    info->slots[1].tries_remaining = AVB_AB_MAX_TRIES_REMAINING;
    info->slots[1].successful_boot = 0;
}

void dump_boot_info(AvbABData* info)
{
    printf("info->magic = %s\n", info->magic);
    printf("info->version_major = %d\n", info->version_major);
    printf("info->version_minor = %d\n", info->version_minor);
    printf("info->slots[0].priority = %d\n", info->slots[0].priority);
    printf("info->slots[0].tries_remaining = %d\n", info->slots[0].tries_remaining);
    printf("info->slots[0].successful_boot = %d\n", info->slots[0].successful_boot);
    printf("info->slots[1].priority = %d\n", info->slots[1].priority);
    printf("info->slots[1].tries_remaining = %d\n", info->slots[1].tries_remaining);
    printf("info->slots[1].successful_boot = %d\n", info->slots[1].successful_boot);

    printf("info->crc32 = %d\n", info->crc32);
}

static bool slot_is_bootable(AvbABSlotData* slot) {
  return slot->priority > 0 &&
         (slot->successful_boot || (slot->tries_remaining > 0));
}

int get_active_slot(AvbABData* info) {
    if (info->slots[0].priority > info->slots[1].priority)
        return 0;
    else
        return 1;
}


int boot_info_set_active_slot(AvbABData* info, int slot)
{
    unsigned int other_slot_number;

    /* Make requested slot top priority, unsuccessful, and with max tries. */
    info->slots[slot].priority = AVB_AB_MAX_PRIORITY;
    info->slots[slot].tries_remaining = AVB_AB_MAX_TRIES_REMAINING;
    info->slots[slot].successful_boot = 0;

    /* Ensure other slot doesn't have as high a priority. */
    other_slot_number = 1 - slot;
    if (info->slots[other_slot_number].priority == AVB_AB_MAX_PRIORITY) {
        info->slots[other_slot_number].priority = AVB_AB_MAX_PRIORITY - 1;
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

    /*for (i = AB_METADATA_MISC_PARTITION_OFFSET;i < (AB_METADATA_MISC_PARTITION_OFFSET+AVB_AB_DATA_SIZE);i++)
        printf("buf: %c \n", miscbuf[i]);*/
    return 0;
}

bool boot_info_load(AvbABData *out_info, char *miscbuf)
{
    memcpy(out_info, miscbuf+AB_METADATA_MISC_PARTITION_OFFSET, AVB_AB_DATA_SIZE);
    dump_boot_info(out_info);
    return true;
}

bool boot_info_save(AvbABData *info, char *miscbuf)
{
    char *partition = "misc";
    printf("save boot-info \n");
    info->crc32 = avb_htobe32(
      avb_crc32((const uint8_t*)info, sizeof(AvbABData) - sizeof(uint32_t)));

    memcpy(miscbuf+AB_METADATA_MISC_PARTITION_OFFSET, info, AVB_AB_DATA_SIZE);
    dump_boot_info(info);
    store_write_ops((unsigned char *)partition, (unsigned char *)miscbuf, 0, MISCBUF_SIZE);
    return true;
}

static int do_GetValidSlot(
    cmd_tbl_t * cmdtp,
    int flag,
    int argc,
    char * const argv[])
{
    char miscbuf[MISCBUF_SIZE] = {0};
    AvbABData info;
    int slot;
    bool bootable_a, bootable_b;

    if (argc != 1) {
        return cmd_usage(cmdtp);
    }

    boot_info_open_partition(miscbuf);
    boot_info_load(&info, miscbuf);

    if (!boot_info_validate(&info)) {
        printf("boot-info is invalid. Resetting.\n");
        boot_info_reset(&info);
        boot_info_save(&info, miscbuf);
    }

    slot = get_active_slot(&info);
    printf("active slot = %d\n", slot);

    bootable_a = slot_is_bootable(&(info.slots[0]));
    bootable_b = slot_is_bootable(&(info.slots[1]));

    if ((slot == 0) && (bootable_a)) {
        if (has_boot_slot == 1) {
            setenv("active_slot","_a");
            setenv("boot_part","boot_a");
            setenv("slot-suffixes","0");
        }
        else {
            setenv("active_slot","normal");
            setenv("boot_part","boot");
        }
        return 0;
    }

    if ((slot == 1) && (bootable_b)) {
        if (has_boot_slot == 1) {
            setenv("active_slot","_b");
            setenv("boot_part","boot_b");
            setenv("slot-suffixes","1");
        }
        else {
            setenv("active_slot","normal");
            setenv("boot_part","boot");
        }
        return 0;
    }

    return 0;
}

static int do_SetActiveSlot(
    cmd_tbl_t * cmdtp,
    int flag,
    int argc,
    char * const argv[])
{
    char miscbuf[MISCBUF_SIZE] = {0};
    AvbABData info;

    if (argc != 2) {
        return cmd_usage(cmdtp);
    }

    if (has_boot_slot == 0) {
        printf("device is not ab mode\n");
        return -1;
    }

    boot_info_open_partition(miscbuf);
    boot_info_load(&info, miscbuf);

    if (!boot_info_validate(&info)) {
        printf("boot-info is invalid. Resetting.\n");
        boot_info_reset(&info);
        boot_info_save(&info, miscbuf);
    }

    if (strcmp(argv[1], "a") == 0) {
        setenv("active_slot","_a");
        setenv("slot-suffixes","0");
        setenv("boot_part","boot_a");
        printf("set active slot a \n");
        boot_info_set_active_slot(&info, 0);
    } else if (strcmp(argv[1], "b") == 0) {
        setenv("active_slot","_b");
        setenv("slot-suffixes","1");
        setenv("boot_part","boot_b");
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
    strcpy(system, CONFIG_SYSTEM_AS_ROOT);
    printf("CONFIG_SYSTEM_AS_ROOT: %s \n", CONFIG_SYSTEM_AS_ROOT);
    if (strcmp(system, "systemroot") == 0) {
        setenv("system_mode","1");
    }
    else {
        setenv("system_mode","0");
    }
#else
    setenv("system_mode","0");
#endif

    return 0;
}

int do_GetAvbMode (cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
#ifdef CONFIG_AVB2
    char* avbmode;
    avbmode = CONFIG_AVB2;
    strcpy(avbmode, CONFIG_AVB2);
    printf("CONFIG_AVB2: %s \n", CONFIG_AVB2);
    if (strcmp(avbmode, "avb2") == 0) {
        setenv("avb2","1");
    }
    else {
        setenv("avb2","0");
    }
#else
    setenv("avb2","0");
#endif

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

