
/*
 * arch/arm/cpu/armv8/txl/mailbox.c
 *
 * Copyright (C) 2015 Amlogic, Inc. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

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

static void scpi_send_block(unsigned int command,
			unsigned int *message, unsigned int message_size, unsigned int priority)
{
	mb_init(priority);
	mb_message_start(priority);
	memcpy(ap_mb_payload[priority], message, message_size);
	mb_message_send(command, priority);
	mb_message_wait(priority);
	mb_message_end(priority);
}

void open_scp_log(unsigned int channel)
{
	scpi_send32(SCPI_CMD_OPEN_SCP_LOG, channel, LOW_PRIORITY);
}

int send_usr_data(unsigned int clinet_id, unsigned int *val, unsigned int size)
{
	unsigned long command;

	if (size > 0x1fd)
		return -1;

	command = ((unsigned int)SCPI_CMD_SET_USR_DATA & 0xff) | ((clinet_id & 0xff) << 8) | ((size & 0x1ff) << 20);
	scpi_send_block(command,val,size,0);

	return 0;
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


void send_pwm_delt(int32_t vcck_delt, int32_t ee_delt)
{
	unsigned int *appayload = ap_mb_payload[LOW_PRIORITY];
	mb_message_start(LOW_PRIORITY);
	writel(vcck_delt, appayload);
	writel(ee_delt, appayload+1);
	mb_message_send(SCPI_CMD_REV_PWM_DELT, LOW_PRIORITY);
	mb_message_wait(LOW_PRIORITY);
	mb_message_end(LOW_PRIORITY);
}

void set_boot_first_timeout(unsigned int command)
{
	mb_message_start(LOW_PRIORITY);
	writel(0, ap_mb_payload[LOW_PRIORITY]);
	mb_message_send(command, LOW_PRIORITY);
	mb_message_wait(LOW_PRIORITY);
	mb_message_end(LOW_PRIORITY);
}

#ifdef CONFIG_RING
int oscring_get_value(unsigned char *ringinfo)
{
	struct {
		unsigned int status;
		unsigned char ringinfo[8];
	} *response;
	unsigned int size;

	mb_message_start(LOW_PRIORITY);
	writel(0, ap_mb_payload[LOW_PRIORITY]);
	mb_message_send(
				((0x4 << SIZE_SHIFT) | SCPI_CMD_OSCRING_VALUE),
				LOW_PRIORITY);
	mb_message_receive((void *)&response, &size, LOW_PRIORITY);
	mb_message_end(LOW_PRIORITY);

	memcpy(ringinfo, &response->ringinfo, sizeof(response->ringinfo));
	if (response->status != SCPI_SUCCESS)
		return -1;
	else
		return 0;
}
#endif
