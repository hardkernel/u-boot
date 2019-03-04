/*
 * Copyright 2017, Rockchip Electronics Co., Ltd
 * hisping lin, <hisping.lin@rock-chips.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */
#ifndef _OPTEECLIENTTEST_H_
#define _OPTEECLIENTTEST_H_

#include <optee_include/tee_client_api.h>

#define ATAP_HEX_UUID_LEN 32
#define ATTEST_DH_SIZE     8
#define ATTEST_UUID_SIZE     (ATAP_HEX_UUID_LEN+1)
#define ATTEST_CA_OUT_SIZE     256

uint32_t test_optee(void);
uint32_t trusty_read_rollback_index(uint32_t slot, uint64_t *value);
uint32_t trusty_write_rollback_index(uint32_t slot, uint64_t value);
uint32_t trusty_read_permanent_attributes(uint8_t *attributes, uint32_t size);
uint32_t trusty_write_permanent_attributes(uint8_t *attributes, uint32_t size);
uint32_t trusty_read_permanent_attributes_cer(uint8_t *attributes,
					      uint32_t size);
uint32_t trusty_write_permanent_attributes_cer(uint8_t *attributes,
					       uint32_t size);
uint32_t trusty_read_lock_state(uint8_t *lock_state);
uint32_t trusty_write_lock_state(uint8_t lock_state);
uint32_t trusty_read_flash_lock_state(uint8_t *flash_lock_state);
uint32_t trusty_write_flash_lock_state(uint8_t flash_lock_state);

uint32_t trusty_read_attribute_hash(uint32_t *buf, uint32_t length);
uint32_t trusty_write_attribute_hash(uint32_t *buf, uint32_t length);
uint32_t trusty_notify_optee_uboot_end(void);
uint32_t trusty_read_vbootkey_hash(uint32_t *buf, uint32_t length);
uint32_t trusty_write_vbootkey_hash(uint32_t *buf, uint32_t length);
uint32_t trusty_read_vbootkey_enable_flag(uint8_t *flag);
uint32_t trusty_read_permanent_attributes_flag(uint8_t *attributes);
uint32_t trusty_write_permanent_attributes_flag(uint8_t attributes);
uint32_t trusty_attest_dh(uint8_t *dh, uint32_t *dh_size);
uint32_t trusty_attest_uuid(uint8_t *uuid, uint32_t *uuid_size);
uint32_t trusty_attest_get_ca
	(uint8_t *operation_start, uint32_t *operation_size,
	 uint8_t *out, uint32_t *out_len);
uint32_t trusty_attest_set_ca(uint8_t *ca_response, uint32_t *ca_response_size);

#endif
