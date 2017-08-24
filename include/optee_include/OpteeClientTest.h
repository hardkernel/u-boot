/*
 * Copyright 2017, Rockchip Electronics Co., Ltd
 * hisping lin, <hisping.lin@rock-chips.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */
void test_optee(void);
uint32_t trusty_read_rollback_index(uint32_t slot, uint64_t *value);
uint32_t trusty_write_rollback_index(uint32_t slot, uint64_t value);
uint32_t trusty_read_permanent_attributes(uint8_t *attributes, uint32_t size);
uint32_t trusty_write_permanent_attributes(uint8_t *attributes, uint32_t size);
uint32_t trusty_read_lock_state(uint8_t *lock_state);
uint32_t trusty_write_lock_state(uint8_t lock_state);
uint32_t write_to_keymaster
	(uint8_t *filename, uint32_t filename_size,
	uint8_t *data, uint32_t data_size);
