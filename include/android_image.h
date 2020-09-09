/* SPDX-License-Identifier: BSD-3-Clause */
/*
 * This is from the Android Project,
 * Repository: https://android.googlesource.com/platform/system/tools/mkbootimg
 * File: include/bootimg/bootimg.h
 * Commit: e55998a0f2b61b685d5eb4a486ca3a0c680b1a2f
 *
 * Copyright (C) 2007 The Android Open Source Project
 */

#ifndef _ANDROID_IMAGE_H_
#define _ANDROID_IMAGE_H_

#define ANDR_BOOT_MAGIC "ANDROID!"
#define VENDOR_BOOT_MAGIC "VNDRBOOT"
#define ANDR_BOOT_MAGIC_SIZE 8
#define VENDOR_BOOT_MAGIC_SIZE 8
#define ANDR_BOOT_NAME_SIZE 16
#define VENDOR_BOOT_NAME_SIZE 16
#define ANDR_BOOT_ARGS_SIZE 512
#define ANDR_BOOT_EXTRA_ARGS_SIZE 1024
#define VENDOR_BOOT_ARGS_SIZE 2048
#define ANDR_BOOT_IMG_PAGE_SIZE 4096
#define ANDR_BOOT_IMG_HDR_SIZE (ANDR_BOOT_IMG_PAGE_SIZE)
#define TOTAL_BOOT_ARGS_SIZE (ANDR_BOOT_ARGS_SIZE + ANDR_BOOT_EXTRA_ARGS_SIZE + \
                              VENDOR_BOOT_ARGS_SIZE + 1)
#define VENDOR_BOOT_HDR_SIZE	2112

/*
 * It is expected that callers would explicitly specify which version of the
 * boot image header they need to use.
 */
typedef struct andr_img_hdr andr_img_hdr;

/* The bootloader expects the structure of andr_img_hdr with header
 * version 0 to be as follows: */
struct andr_img_hdr {
    /* Must be ANDR_BOOT_MAGIC. */
    char magic[ANDR_BOOT_MAGIC_SIZE];

    u32 kernel_size; /* size in bytes */
    u32 kernel_addr; /* physical load addr */

    u32 ramdisk_size; /* size in bytes */
    u32 ramdisk_addr; /* physical load addr */

    u32 second_size; /* size in bytes */
    u32 second_addr; /* physical load addr */

    u32 tags_addr; /* physical addr for kernel tags */
    u32 page_size; /* flash page size we assume */

    /* Version of the boot image header. */
    u32 header_version;

    /* Operating system version and security patch level.
     * For version "A.B.C" and patch level "Y-M-D":
     *   (7 bits for each of A, B, C; 7 bits for (Y-2000), 4 bits for M)
     *   os_version = A[31:25] B[24:18] C[17:11] (Y-2000)[10:4] M[3:0] */
    u32 os_version;

    char name[ANDR_BOOT_NAME_SIZE]; /* asciiz product name */

    char cmdline[ANDR_BOOT_ARGS_SIZE];

    u32 id[8]; /* timestamp / checksum / sha1 / etc */

    /* Supplemental command line data; kept here to maintain
     * binary compatibility with older versions of mkbootimg. */
    char extra_cmdline[ANDR_BOOT_EXTRA_ARGS_SIZE];

    /* Fields in boot_img_hdr_v1(Android-9) and newer. */
    u32 recovery_dtbo_size;   /* size in bytes for recovery DTBO/ACPIO image */
    u64 recovery_dtbo_offset; /* offset to recovery dtbo/acpio in boot image */
    u32 header_size;

    /* Fields in boot_img_hdr_v2(Android-10) and newer. */
    u32 dtb_size; /* size in bytes for DTB image */
    u64 dtb_addr; /* physical load address for DTB image */

    /*
     * [Rockchip compatibility]
     *
     * boot_img_hdr_v3(Android-11) is not compatible with boot_img_hdr_v012,
     * we have to partly merge fields from boot_img_hdr_v3 and vendor_boot_img_hdr_v3
     * into this structure to compatible with boot_img_hdr_v012.
     */
    u32 vendor_ramdisk_size; /* size in bytes */
    u32 vendor_page_size;
    u32 vendor_header_version;
    u32 vendor_header_size;
    /*
     * Don't define 'char total_cmdline[TOTAL_BOOT_ARGS_SIZE]' to avoid
     * this structrue is over size than page_size.
     */
    char *total_cmdline;
} __attribute__((packed));

struct boot_img_hdr_v3 {
    /* Must be ANDR_BOOT_MAGIC. */
    uint8_t magic[ANDR_BOOT_MAGIC_SIZE];

    uint32_t kernel_size; /* size in bytes */
    uint32_t ramdisk_size; /* size in bytes */

    /* Operating system version and security patch level.
     * For version "A.B.C" and patch level "Y-M-D":
     *   (7 bits for each of A, B, C; 7 bits for (Y-2000), 4 bits for M)
     *   os_version = A[31:25] B[24:18] C[17:11] (Y-2000)[10:4] M[3:0] */
    uint32_t os_version;

    uint32_t header_size;

    uint32_t reserved[4];

    uint32_t header_version;

    uint8_t cmdline[ANDR_BOOT_ARGS_SIZE + ANDR_BOOT_EXTRA_ARGS_SIZE];
} __attribute__((packed));

struct vendor_boot_img_hdr_v3 {
    /* Must be VENDOR_BOOT_MAGIC. */
    uint8_t magic[VENDOR_BOOT_MAGIC_SIZE];

    /* Version of the vendor boot image header. */
    uint32_t header_version;

    uint32_t page_size; /* flash page size we assume */

    uint32_t kernel_addr; /* physical load addr */
    uint32_t ramdisk_addr; /* physical load addr */

    uint32_t vendor_ramdisk_size; /* size in bytes */

    uint8_t cmdline[VENDOR_BOOT_ARGS_SIZE];

    uint32_t tags_addr; /* physical addr for kernel tags (if required) */
    uint8_t name[VENDOR_BOOT_NAME_SIZE]; /* asciiz product name */

    uint32_t header_size;

    uint32_t dtb_size; /* size in bytes for DTB image */
    uint64_t dtb_addr; /* physical load address for DTB image */
} __attribute__((packed));

/* When a boot header is of version 0, the structure of boot image is as
 * follows:
 *
 * +-----------------+
 * | boot header     | 1 page
 * +-----------------+
 * | kernel          | n pages
 * +-----------------+
 * | ramdisk         | m pages
 * +-----------------+
 * | second stage    | o pages
 * +-----------------+
 *
 * n = (kernel_size + page_size - 1) / page_size
 * m = (ramdisk_size + page_size - 1) / page_size
 * o = (second_size + page_size - 1) / page_size
 *
 * 0. all entities are page_size aligned in flash
 * 1. kernel and ramdisk are required (size != 0)
 * 2. second is optional (second_size == 0 -> no second)
 * 3. load each element (kernel, ramdisk, second) at
 *    the specified physical address (kernel_addr, etc)
 * 4. prepare tags at tag_addr.  kernel_args[] is
 *    appended to the kernel commandline in the tags.
 * 5. r0 = 0, r1 = MACHINE_TYPE, r2 = tags_addr
 * 6. if second_size != 0: jump to second_addr
 *    else: jump to kernel_addr
 */

/* When the boot image header has a version of 2, the structure of the boot
 * image is as follows:
 *
 * +---------------------+
 * | boot header         | 1 page
 * +---------------------+
 * | kernel              | n pages
 * +---------------------+
 * | ramdisk             | m pages
 * +---------------------+
 * | second stage        | o pages
 * +---------------------+
 * | recovery dtbo/acpio | p pages
 * +---------------------+
 * | dtb                 | q pages
 * +---------------------+

 * n = (kernel_size + page_size - 1) / page_size
 * m = (ramdisk_size + page_size - 1) / page_size
 * o = (second_size + page_size - 1) / page_size
 * p = (recovery_dtbo_size + page_size - 1) / page_size
 * q = (dtb_size + page_size - 1) / page_size
 *
 * 0. all entities are page_size aligned in flash
 * 1. kernel, ramdisk and DTB are required (size != 0)
 * 2. recovery_dtbo/recovery_acpio is required for recovery.img in non-A/B
 *    devices(recovery_dtbo_size != 0)
 * 3. second is optional (second_size == 0 -> no second)
 * 4. load each element (kernel, ramdisk, second, dtb) at
 *    the specified physical address (kernel_addr, etc)
 * 5. If booting to recovery mode in a non-A/B device, extract recovery
 *    dtbo/acpio and apply the correct set of overlays on the base device tree
 *    depending on the hardware/product revision.
 * 6. prepare tags at tag_addr.  kernel_args[] is
 *    appended to the kernel commandline in the tags.
 * 7. r0 = 0, r1 = MACHINE_TYPE, r2 = tags_addr
 * 8. if second_size != 0: jump to second_addr
 *    else: jump to kernel_addr
 */

/* When the boot image header has a version of 3, the structure of the boot
 * image is as follows:
 *
 * +---------------------+
 * | boot header         | 4096 bytes
 * +---------------------+
 * | kernel              | m pages
 * +---------------------+
 * | ramdisk             | n pages
 * +---------------------+
 *
 * m = (kernel_size + 4096 - 1) / 4096
 * n = (ramdisk_size + 4096 - 1) / 4096
 *
 * Note that in version 3 of the boot image header, page size is fixed at 4096 bytes.
 *
 * The structure of the vendor boot image (introduced with version 3 and
 * required to be present when a v3 boot image is used) is as follows:
 *
 * +---------------------+
 * | vendor boot header  | o pages
 * +---------------------+
 * | vendor ramdisk      | p pages
 * +---------------------+
 * | dtb                 | q pages
 * +---------------------+
 *
 * o = (2112 + page_size - 1) / page_size
 * p = (vendor_ramdisk_size + page_size - 1) / page_size
 * q = (dtb_size + page_size - 1) / page_size
 *
 * 0. all entities in the boot image are 4096-byte aligned in flash, all
 *    entities in the vendor boot image are page_size (determined by the vendor
 *    and specified in the vendor boot image header) aligned in flash
 * 1. kernel, ramdisk, vendor ramdisk, and DTB are required (size != 0)
 * 2. load the kernel and DTB at the specified physical address (kernel_addr,
 *    dtb_addr)
 * 3. load the vendor ramdisk at ramdisk_addr
 * 4. load the generic ramdisk immediately following the vendor ramdisk in
 *    memory
 * 5. set up registers for kernel entry as required by your architecture
 * 6. if the platform has a second stage bootloader jump to it (must be
 *    contained outside boot and vendor boot partitions), otherwise
 *    jump to kernel_addr
 */

#endif
