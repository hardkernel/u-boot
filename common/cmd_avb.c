/*
 * (C) Copyright 2018 Amlogic, Inc
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
#include <emmc_partitions.h>
#include <amlogic/storage_if.h>
#include <asm/arch/bl31_apis.h>
#ifdef CONFIG_AML_ANTIROLLBACK
#include <anti-rollback.h>
#endif

#define AVB_USE_TESTKEY
#define MAX_DTB_SIZE (AML_DTB_IMG_MAX_SZ + 512)
#define AVB_NUM_SLOT (4)

#ifdef AVB_USE_TESTKEY
extern const char testkey2048[520];
extern const int testkey2048_length;
#endif
AvbOps avb_ops_;

static AvbIOResult read_from_partition(AvbOps* ops, const char* partition, int64_t offset,
        size_t num_bytes, void* buffer, size_t* out_num_read)
{
    int rc = 0;
    uint64_t part_bytes = 0;

    if (ops->get_size_of_partition(ops, partition, &part_bytes) != AVB_IO_RESULT_OK) {
        return AVB_IO_RESULT_ERROR_NO_SUCH_PARTITION;
    }
    if (part_bytes < offset)
        return AVB_IO_RESULT_ERROR_RANGE_OUTSIDE_PARTITION;

    *out_num_read = 0;
    if (!memcmp(partition, "dtb", strlen("dtb"))) {
        char *dtb_buf = malloc(MAX_DTB_SIZE);

        if (!dtb_buf)
            return AVB_IO_RESULT_ERROR_OOM;

        rc = store_dtb_rw(dtb_buf, MAX_DTB_SIZE, 2);
        if (rc) {
            printf("Failed to read dtb\n");
            free(dtb_buf);
            return AVB_IO_RESULT_ERROR_IO;
        } else {
            *out_num_read = num_bytes > MAX_DTB_SIZE ? MAX_DTB_SIZE : num_bytes;
            memcpy(buffer, dtb_buf, *out_num_read);
            free(dtb_buf);
            return AVB_IO_RESULT_OK;
        }
    } else {
        rc = store_read_ops((unsigned char *)partition, buffer, offset, num_bytes);
        if (rc) {
            printf("Failed to read %zdB from part[%s] at offset %lld\n", num_bytes, partition, offset);
            return AVB_IO_RESULT_ERROR_IO;
        }
        *out_num_read = num_bytes;
    }

    return AVB_IO_RESULT_OK;
}

static AvbIOResult write_to_partition(AvbOps* ops, const char* partition,
        int64_t offset, size_t num_bytes, const void* buffer)
{
    int rc = 0;
    uint64_t part_bytes = 0;

    if (ops->get_size_of_partition(ops, partition, &part_bytes) != AVB_IO_RESULT_OK) {
        return AVB_IO_RESULT_ERROR_NO_SUCH_PARTITION;
    }
    if (part_bytes < offset)
        return AVB_IO_RESULT_ERROR_RANGE_OUTSIDE_PARTITION;

    if (!memcmp(partition, "dtb", strlen("dtb"))) {
        if (offset)
            return AVB_IO_RESULT_ERROR_IO;
        rc = store_dtb_rw((void *)buffer, num_bytes, 1);
        if (rc) {
            printf("Failed to write dtb\n");
            return AVB_IO_RESULT_ERROR_IO;
        } else {
            return AVB_IO_RESULT_OK;
        }
    } else {
        rc = store_write_ops((unsigned char *)partition, (unsigned char *)buffer, offset, num_bytes);
        if (rc) {
            printf("Failed to write %zdB from part[%s] at offset %lld\n", num_bytes, partition, offset);
            return AVB_IO_RESULT_ERROR_IO;
        }
    }

    return AVB_IO_RESULT_OK;
}

static AvbIOResult get_unique_guid_for_partition(AvbOps* ops, const char* partition,
        char* guid_buf, size_t guid_buf_size)
{
    char *s1;
    int ret;
    char part_name[128];
    memset(guid_buf, 0, guid_buf_size);
    run_command("get_valid_slot;", 0);
    s1 = getenv("active_slot");
    printf("active_slot is %s\n", s1);
    if (!memcmp(partition, "system", strlen("system"))) {
        if (strcmp(s1, "_a") == 0) {
            ret = get_partition_num_by_name("system_a");
            sprintf(part_name, "/dev/mmcblk0p%d", ret+1);
            strncpy(guid_buf, part_name, guid_buf_size);
        } else if (strcmp(s1, "_b") == 0) {
            ret = get_partition_num_by_name("system_b");
            sprintf(part_name, "/dev/mmcblk0p%d", ret+1);
            strncpy(guid_buf, part_name, guid_buf_size);
        } else {
            ret = get_partition_num_by_name("system");
            sprintf(part_name, "/dev/mmcblk0p%d", ret+1);
            strncpy(guid_buf, part_name, guid_buf_size);
        }
    } else if (!memcmp(partition, "vbmeta", strlen("vbmeta")))
        strncpy(guid_buf, "/dev/block/vbmeta", guid_buf_size);
    return AVB_IO_RESULT_OK;
}

static AvbIOResult get_size_of_partition(AvbOps* ops, const char* partition,
        uint64_t* out_size_num_bytes)
{
    int rc = 0;

	if (!memcmp(partition, "dtb", strlen("dtb"))) {
		*out_size_num_bytes = MAX_DTB_SIZE;
    } else {
        rc = store_get_partititon_size((unsigned char *)partition, out_size_num_bytes);
        if (rc) {
            printf("Failed to get partition[%s] size\n", partition);
            return AVB_IO_RESULT_ERROR_NO_SUCH_PARTITION;
        }
        *out_size_num_bytes *= 512;
    }

    return AVB_IO_RESULT_OK;
}

static AvbIOResult validate_vbmeta_public_key(AvbOps* ops, const uint8_t* public_key_data,
        size_t public_key_length, const uint8_t* public_key_metadata, size_t public_key_metadata_length,
        bool* out_is_trusted)
{
#ifdef AVB_USE_TESTKEY
    printf("Verified using testkey\n");
    if (testkey2048_length != public_key_length) {
        *out_is_trusted = false;
        return AVB_IO_RESULT_OK;
    }
    if (!avb_safe_memcmp(public_key_data, testkey2048, testkey2048_length))
        *out_is_trusted = true;
    else
        *out_is_trusted = false;
#else
    unsigned long bl31_addr = get_sharemem_info(GET_SHARE_MEM_INPUT_BASE);
    memcpy((void *)bl31_addr, public_key_data, public_key_length);
    flush_cache(bl31_addr, public_key_length);
    *out_is_trusted = aml_sec_boot_check(AML_D_P_AVB_PUBKEY_VERIFY,
            bl31_addr, public_key_length, 0);
#endif
    return AVB_IO_RESULT_OK;
}

static AvbIOResult read_rollback_index(AvbOps* ops, size_t rollback_index_location,
        uint64_t* out_rollback_index)
{
#ifdef CONFIG_AML_ANTIROLLBACK
    uint32_t version;
    if (get_avb_antirollback(rollback_index_location, &version)) {
        *out_rollback_index = version;
    } else {
        printf("failed to read rollback index: %zd\n", rollback_index_location);
        return AVB_IO_RESULT_ERROR_NO_SUCH_VALUE;
    }
#else
    *out_rollback_index = 0;
#endif
    return AVB_IO_RESULT_OK;
}

static AvbIOResult write_rollback_index(AvbOps* ops, size_t rollback_index_location,
        uint64_t rollback_index)
{
#ifdef CONFIG_AML_ANTIROLLBACK
    uint32_t version = rollback_index;
    if (set_avb_antirollback(rollback_index_location, version)) {
        return AVB_IO_RESULT_OK;
    } else {
        printf("failed to set rollback index: %zd, version: %u\n", rollback_index_location, version);
        return AVB_IO_RESULT_ERROR_NO_SUCH_VALUE;
    }
#endif
    return AVB_IO_RESULT_OK;
}

static AvbIOResult read_is_device_unlocked(AvbOps* ops, bool* out_is_unlocked)
{
#ifdef CONFIG_AML_ANTIROLLBACK
    uint32_t lock_state;
    char *lock_s;

    if (get_avb_lock_state(&lock_state)) {
        *out_is_unlocked = !lock_state;
        lock_s = getenv("lock");
        if (*out_is_unlocked) {
            lock_s[4] = '0';
        } else {
            lock_s[4] = '1';
        }
        setenv("lock", lock_s);
        return AVB_IO_RESULT_OK;
    } else {
        printf("failed to read device lock status from rpmb\n");
        return AVB_IO_RESULT_ERROR_IO;
    }
#else
    char *lock_s;
    LockData_t info;

    lock_s = getenv("lock");
    if (!lock_s)
        return AVB_IO_RESULT_ERROR_IO;

    memset(&info, 0, sizeof(struct LockData));

    info.version_major = (int)(lock_s[0] - '0');
    info.version_minor = (int)(lock_s[1] - '0');
    info.lock_state = (int)(lock_s[4] - '0');
    info.lock_critical_state = (int)(lock_s[5] - '0');
    info.lock_bootloader = (int)(lock_s[6] - '0');

    if (info.lock_state == 1)
        *out_is_unlocked = false;
    else
        *out_is_unlocked = true;
    return AVB_IO_RESULT_OK;
#endif
}

static int avb_init(void)
{

    memset(&avb_ops_, 0, sizeof(AvbOps));
    avb_ops_.read_from_partition = read_from_partition;
    avb_ops_.get_preloaded_partition = NULL;
    avb_ops_.write_to_partition = write_to_partition;
    avb_ops_.validate_vbmeta_public_key = validate_vbmeta_public_key;
    avb_ops_.read_rollback_index = read_rollback_index;
    avb_ops_.write_rollback_index = write_rollback_index;
    avb_ops_.read_is_device_unlocked = read_is_device_unlocked;
    avb_ops_.get_unique_guid_for_partition = get_unique_guid_for_partition;
    avb_ops_.get_size_of_partition = get_size_of_partition;
    avb_ops_.read_persistent_value = NULL;
    avb_ops_.write_persistent_value = NULL;

    //avb_ops_.user_data = NULL;

    return 0;
}

int is_device_unlocked(void)
{
    AvbIOResult ret;
    bool out_is_unlocked;
    ret = read_is_device_unlocked(&avb_ops_, &out_is_unlocked);
    if (ret == AVB_IO_RESULT_OK)
        return out_is_unlocked;
    else
        return 0;
}

int avb_verify(AvbSlotVerifyData** out_data)
{
    /* The last slot must be NULL */
    const char * requested_partitions[AVB_NUM_SLOT + 1] = {"boot", "dtb", NULL, NULL, NULL};
    AvbSlotVerifyResult result = AVB_SLOT_VERIFY_RESULT_OK;
    char *s1;
    char *ab_suffix;
    uint32_t i = 0;

    run_command("get_valid_slot;", 0);
    s1 = getenv("active_slot");
    printf("active_slot is %s\n", s1);
    if (strcmp(s1, "normal") == 0) {
        ab_suffix = "";
    } else {
        ab_suffix = getenv("active_slot");
    }
    printf("ab_suffix is %s\n", ab_suffix);

    AvbSlotVerifyFlags flags = AVB_SLOT_VERIFY_FLAGS_NONE;
    char *upgradestep = NULL;

    avb_init();

    upgradestep = getenv("upgrade_step");

    if (is_device_unlocked() || !strcmp(upgradestep, "3"))
        flags |= AVB_SLOT_VERIFY_FLAGS_ALLOW_VERIFICATION_ERROR;

    if (!strcmp(ab_suffix, "")) {
        for (i = 0; i < AVB_NUM_SLOT; i++) {
            if (requested_partitions[i] == NULL) {
                requested_partitions[i] = "recovery";
                break;
            }
        }
        if (i == AVB_NUM_SLOT) {
            printf("ERROR: failed to find an empty slot for recovery");
            return AVB_SLOT_VERIFY_RESULT_ERROR_INVALID_ARGUMENT;
        }
    }

    result = avb_slot_verify(&avb_ops_, requested_partitions, ab_suffix,
            flags,
            AVB_HASHTREE_ERROR_MODE_RESTART_AND_INVALIDATE, out_data);

    if (!strcmp(upgradestep, "3"))
        result = AVB_SLOT_VERIFY_RESULT_OK;

    return result;
}

static int do_avb_verify(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
    AvbSlotVerifyResult result = AVB_SLOT_VERIFY_RESULT_OK;
    AvbSlotVerifyData* out_data;
    uint32_t i = 0;

    result = avb_verify(&out_data);

    printf("result: %d\n", result);
    if (result == AVB_SLOT_VERIFY_RESULT_OK) {
#ifdef CONFIG_AML_ANTIROLLBACK
        uint32_t version;
        uint32_t lock_state;
#endif

        printf("ab_suffix: %s\n", out_data->ab_suffix);
        printf("vbmeta: name: %s, size: %zd, result: %d\n",
                out_data->vbmeta_images->partition_name,
                out_data->vbmeta_images->vbmeta_size,
                out_data->vbmeta_images->verify_result);
        printf("num of vbmeta: %zd\n", out_data->num_vbmeta_images);
        printf("loaded name: %s, size: %zd, preload: %d\n", out_data->loaded_partitions->partition_name,
                out_data->loaded_partitions->data_size, out_data->loaded_partitions->preloaded);
        printf("num of loaded: %zd\n", out_data->num_loaded_partitions);
        printf("cmdline: %s\n", out_data->cmdline);
        for (i = 0; i < AVB_MAX_NUMBER_OF_ROLLBACK_INDEX_LOCATIONS; i++)
            printf("rollback(%d) = %llu\n", i, out_data->rollback_indexes[i]);

#ifdef CONFIG_AML_ANTIROLLBACK
        for (i = 0; i < AVB_MAX_NUMBER_OF_ROLLBACK_INDEX_LOCATIONS; i++)
            if (get_avb_antirollback(i, &version))
                printf("rpmb rollback(%d) = %u\n", i, version);
        if (get_avb_lock_state(&lock_state))
            printf("rpmb lock state: %u\n", lock_state);
#endif

        avb_slot_verify_data_free(out_data);
    }

    return result;
}

static cmd_tbl_t cmd_avb_sub[] = {
    U_BOOT_CMD_MKENT(verify, 4, 0, do_avb_verify, "", ""),
};

static int do_avb_ops(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
    cmd_tbl_t *c;

    /* Strip off leading 'bmp' command argument */
    argc--;
    argv++;

    c = find_cmd_tbl(argv[0], &cmd_avb_sub[0], ARRAY_SIZE(cmd_avb_sub));

    if (c) {
        return	c->cmd(cmdtp, flag, argc, argv);
    } else {
        cmd_usage(cmdtp);
        return 1;
    }
}


U_BOOT_CMD(
        avb, 2, 0, do_avb_ops,
        "avb",
        "\nThis command will trigger related avb operations\n"
        );
