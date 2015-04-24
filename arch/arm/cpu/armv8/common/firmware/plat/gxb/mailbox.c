
#include <stdio.h>
#include <string.h>
#include <io.h>
#include <stdint.h>
#include <asm/arch/romboot.h>
#include <mailbox.h>
#include <asm/arch/secure_apb.h>

void mb_send_data(uint32_t val, uint32_t port)
{
	unsigned long  base_addr = SEC_HIU_MAILBOX_SET_0;
	unsigned long  set_addr;

	if (port > 5) {
		printf("Error: Use the error port num!\n");
		return;
	}

	set_addr = base_addr + port*3*4;

	if (!val) {
		printf("Error: mailbox try to send zero val!\n");
		return;
	}

	writel(val, set_addr);

	return;
}

uint32_t mb_read_data(uint32_t port)
{
	unsigned long base_addr = SEC_HIU_MAILBOX_STAT_0;
	uint32_t val;

	if (port > 5) {
		printf("Error: Use the error port num!\n");
		return 0;
	}

	val = readl(base_addr + port*3*4);

	if (val)
		return val;
	else {
//		print_out("Warning: read mailbox val=0.\n");
		return 0;
	}
}

void mb_clear_data(uint32_t val, uint32_t port)
{
	uint32_t base_addr = SEC_HIU_MAILBOX_CLR_0;

	unsigned long clean_addr = base_addr + port*3*4;

	if (port > 5) {
		printf("Error: Use the error port num!\n");
		return;
	}

	if (!val) {
		printf("Warning: clean val=0.\n");
		return;
	}

	writel(val,clean_addr);

	return;
}

void send_bl30(uint32_t addr, uint32_t size, const uint8_t * sha2, uint32_t sha2_length)
{
	int i;
	printf("send_bl30\n");
	printf("time=0x%x size=0x%x\n", readl(0xc1109988),size);
	*(unsigned int *)MB_SRAM_BASE = size;
	mb_send_data(CMD_DATA_LEN, 3);
	do {} while(mb_read_data(3));
	memcpy((void *)MB_SRAM_BASE, (const void *)sha2, sha2_length);
	mb_send_data(CMD_SHA, 3);
	do {} while(mb_read_data(3));

	for (i = 0; i < size; i+=1024) {
		if (size >= i + 1024)
			memcpy((void *)MB_SRAM_BASE,(const void *)(unsigned long)(addr+i),1024);
		else if(size > i)
			memcpy((void *)MB_SRAM_BASE,(const void *)(unsigned long)(addr+i),(size-i));

		mb_send_data(CMD_DATA, 3);
		do {} while(mb_read_data(3));
	}
	mb_send_data(CMD_OP_SHA, 3);
	do {} while(mb_read_data(3));
	mb_send_data(CMD_END,3);//code transfer end.
	printf("Send OK.\n");
}
