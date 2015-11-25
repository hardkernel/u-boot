#include <config.h>
#include <common.h>
#include <asm/arch/io.h>
#include <command.h>
#include <malloc.h>
#include <asm/arch/mailbox.h>
#include <asm/arch/secure_apb.h>

/* Bit position for size value in MHU header */
#define SIZE_SHIFT	20
/* Mask to extract size value in MHU header*/
#define SIZE_MASK	0x1ff

static unsigned int *ap_mb_stat[] = {
	(unsigned int *)HIU_MAILBOX_STAT_4,
	(unsigned int *)HIU_MAILBOX_STAT_5,
};
static unsigned int *ap_mb_set[] = {
	(unsigned int *)HIU_MAILBOX_SET_4,
	(unsigned int *)HIU_MAILBOX_SET_5,
};
static unsigned int *ap_mb_clear[] = {
	(unsigned int *)HIU_MAILBOX_CLR_4,
	(unsigned int *)HIU_MAILBOX_CLR_5,
};
static unsigned int *ap_mb_payload[] = {
	(unsigned int *)(P_SHARE_SRAM_BASE + MHU_LOW_AP_TO_SCP_PAYLOAD),
	(unsigned int *)(P_SHARE_SRAM_BASE + MHU_HIGH_AP_TO_SCP_PAYLOAD),
};
static unsigned int *scp_mb_stat[] = {
	(unsigned int *)HIU_MAILBOX_STAT_1,
	(unsigned int *)HIU_MAILBOX_STAT_2,
};
/*
static unsigned int *scp_mb_set[] = {
	(unsigned int *)HIU_MAILBOX_SET_1,
	(unsigned int *)HIU_MAILBOX_SET_2,
};
*/
static unsigned int *scp_mb_clear[] = {
	(unsigned int *)HIU_MAILBOX_CLR_1,
	(unsigned int *)HIU_MAILBOX_CLR_2,
};
static unsigned int *scp_mb_payload[] = {
	(unsigned int *)(P_SHARE_SRAM_BASE + MHU_LOW_SCP_TO_AP_PAYLOAD),
	(unsigned int *)(P_SHARE_SRAM_BASE + MHU_HIGH_SCP_TO_AP_PAYLOAD),
};

static void mb_message_start(unsigned int priority)
{
	while (readl(ap_mb_stat[priority]) != 0)
		;
}
static void mb_message_send(unsigned int command, unsigned int priority)
{
	writel(command, ap_mb_set[priority]);
	while (readl(ap_mb_stat[priority]) != 0)
		;
}
static unsigned int mb_message_wait(unsigned int priority)
{
	unsigned int response;
	while (!(response = readl(scp_mb_stat[priority])))
		;
	return response;
}
static void mb_message_end(unsigned int priority)
{
	writel(0xffffffff, scp_mb_clear[priority]);
}
static unsigned int mb_message_receive(
					void **message_out,
					unsigned int *size_out,
					unsigned int priority)
{
	unsigned int response = mb_message_wait(priority);
	unsigned int size = (response >> SIZE_SHIFT) & SIZE_MASK;

	response &= ~(SIZE_MASK << SIZE_SHIFT);

	if (size_out)
		*size_out = size;
	if (message_out)
		*message_out = (void *)(scp_mb_payload[priority]);

	return response;
}
static void mb_init(unsigned int priority)
{
	writel(0xffffffff, ap_mb_clear[priority]);
}

static void scpi_send32(unsigned int command,
			unsigned int message, unsigned int priority)
{
	mb_init(priority);
	mb_message_start(priority);
	writel(message, ap_mb_payload[priority]);
	mb_message_send(command, priority);
	mb_message_wait(priority);
	mb_message_end(priority);
}

void open_scp_log(void)
{
	scpi_send32(SCPI_CMD_OPEN_SCP_LOG, 0x1, LOW_PRIORITY);
}

/*
*  type:
*		0: data; 1: version
*/
int thermal_calibration(unsigned int type, unsigned int data)
{
	unsigned int *appayload = ap_mb_payload[LOW_PRIORITY];
	unsigned int *response;
	unsigned int size;

	mb_message_start(LOW_PRIORITY);
	writel(type, appayload);
	writel(data, appayload+1);
	mb_message_send(
				((0x8 << SIZE_SHIFT) | SCPI_CMD_THERMAL_CALIB),
				LOW_PRIORITY);
	mb_message_receive((void *)&response, &size, LOW_PRIORITY);
	mb_message_end(LOW_PRIORITY);

	if (*response != SCPI_SUCCESS)
		return -1;
	else
		return 0;
}

int thermal_get_value(unsigned int sensor_id, unsigned int *value)
{
	unsigned int *response;
	unsigned int size;

	mb_message_start(LOW_PRIORITY);
	writel(sensor_id, ap_mb_payload[LOW_PRIORITY]);
	mb_message_send(
				((0x4 << SIZE_SHIFT) | SCPI_CMD_SENSOR_VALUE),
				LOW_PRIORITY);
	mb_message_receive((void *)&response, &size, LOW_PRIORITY);
	mb_message_end(LOW_PRIORITY);

	*value = *(response+1);
	if (*response != SCPI_SUCCESS)
		return -1;
	else
		return 0;
}
