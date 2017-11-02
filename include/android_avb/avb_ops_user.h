/*
 * Copyright (C) 2016 The Android Open Source Project
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#ifndef AVB_OPS_USER_H_
#define AVB_OPS_USER_H_

#include <android_avb/libavb.h>
#include <android_avb/avb_ab_flow.h>

#define PERM_ATTR_DIGEST_SIZE 32
#define PERM_ATTR_TOTAL_SIZE  1084

/* Allocates an AvbOps instance suitable for use in Android userspace
 * on the device. Returns NULL on OOM.
 *
 * The returned AvbOps has the following characteristics:
 *
 * - The read_from_partition(), write_to_partition(), and
 *   get_size_of_partition() operations are implemented, however for
 *   these operations to work the fstab file on the device must have a
 *   /misc entry using a by-name device file scheme and the containing
 *   by-name/ subdirectory must have files for other partitions.
 *
 * - The remaining operations are implemented and never fails and
 *   return the following values:
 *   - validate_vbmeta_public_key(): always returns |true|.
 *   - read_rollback_index(): returns 0 for any roolback index.
 *   - write_rollback_index(): no-op.
 *   - read_is_device_unlocked(): always returns |true|.
 *   - get_unique_guid_for_partition(): always returns the empty string.
 *
 * - The |ab_ops| member will point to a valid AvbABOps instance
 *   implemented via libavb_ab/. This should only be used if the AVB
 *   A/B stack is used on the device. This is what is used in
 *   bootctrl.avb boot control implementation.
 *
 * Free with avb_ops_user_free().
 */
AvbOps* avb_ops_user_new(void);

/* Frees an AvbOps instance previously allocated with avb_ops_device_new(). */
void avb_ops_user_free(AvbOps* ops);

/**
 * Provided to fastboot to read how many slot in this system.
 *
 * @param slot_count  We use parameter slot_count to obtain
 *                    how many slots in the system.
 *
 * @return 0 if the command succeeded, -1 if it failed
 */
int avb_read_slot_count(char *slot_count);

/**
 * The android things supply many slots, their name like '_a', '_b'.
 * We can use this function to read current slot is '_a' or '_b'.
 *
 * @slot_suffixes  read value '_a' or '_b'.
 *
 * @return 0 if the command succeeded, -1 if it failed
 */
int avb_read_slot_suffixes(char *slot_suffixes);

/**
 * Use this function to set which slot boot first.
 *
 * @param slot_number set '0' or '1'
 *
 * @return 0 if the command succeeded, -1 if it failed
 */
int avb_set_slot_active(unsigned int *slot_number);

/**
 * Get current slot: '_a' or '_b'.
 *
 * @param select_slot  obtain current slot.
 *
 * @return 0 if the command succeeded, -1 if it failed
 */
int avb_get_current_slot(char *select_slot);

/**
 * The android things defines permanent attributes to
 * store PSK_public, product id. We can use this function
 * to read them.
 *
 * @param attributes  PSK_public, product id....
 *
 * @param size        The size of attributes.
 *
 * @return 0 if the command succeeded, -1 if it failed
 */
int avb_read_permanent_attributes(uint8_t *attributes, uint32_t size);

/**
 * The android things defines permanent attributes to
 * store PSK_public, product id. We can use this function
 * to write them.
 *
 * @param attributes  PSK_public, product id....
 *
 * @param size        The size of attributes.
 *
 * @return 0 if the command succeeded, -1 if it failed
 */
int avb_write_permanent_attributes(uint8_t *attributes, uint32_t size);

/**
 * The funtion can be use to read the device state to judge
 * whether the device can be flash.
 *
 * @param flash_lock_state  A flag indicate the device flash state.
 *
 * @return 0 if the command succeeded, -1 if it failed
 */
int avb_read_flash_lock_state(uint8_t *flash_lock_state);

/**
 * The function is provided to write device flash state.
 *
 * @param flash_lock_state   A flag indicate the device flash state.
 *
 * @return 0 if the command succeeded, -1 if it failed
 */
int avb_write_flash_lock_state(uint8_t flash_lock_state);

/**
 * The android things use the flag of lock state to indicate
 * whether the device can be booted when verified error.
 *
 * @param lock_state  A flag indicate the device lock state.
 *
 * @return 0 if the command succeeded, -1 if it failed
 */
int avb_read_lock_state(uint8_t *lock_state);

/**
 * The android things use the flag of lock state to indicate
 * whether the device can be booted when verified error.
 *
 * @param lock_state   A flag indicate the device lock state.
 *
 * @return 0 if the command succeeded, -1 if it failed
 */
int avb_write_lock_state(uint8_t lock_state);

/**
 * The android things uses fastboot to flash the permanent attributes.
 * And if them were written, there must have a flag to indicate.
 *
 * @param flag   indicate the permanent attributes have been written
 *               or not.
 *
 * @return 0 if the command succeeded, -1 if it failed
 */
int avb_read_perm_attr_flag(uint8_t *flag);

/**
 * The android things uses fastboot to flash the permanent attributes.
 * And if them were written, there must have a flag to indicate.
 *
 * @param flag   We can call this function to write the flag '1'
 *               to indicate the permanent attributes has been
 *               written.
 *
 * @return 0 if the command succeeded, -1 if it failed
 */
int avb_write_perm_attr_flag(uint8_t flag);

#endif
