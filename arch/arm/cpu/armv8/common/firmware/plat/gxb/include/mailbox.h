
#ifndef __BL2_MAILBOX_H_
#define __BL2_MAILBOX_H_

#define MB_SRAM_BASE 0xd9013800

#define CMD_SHA         0xc0de0001
#define CMD_OP_SHA      0xc0de0002
#define CMD_DATA_LEN    0xc0dec0d0
#define CMD_DATA        0xc0dec0de
#define CMD_END         0xe00de00d

void *memcpy_t(void *dest, const void *src, size_t len);
void mb_send_data(uint32_t val, uint32_t port);
uint32_t mb_read_data(uint32_t port);
void mb_clear_data(uint32_t val, uint32_t port);
void send_bl30x(uint32_t addr, uint32_t size, const uint8_t * sha2,
	uint32_t sha2_length, const char * name);

#endif /*__BL2_MAILBOX_H_*/