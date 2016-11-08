/*
* Copyright (C) 2016 The Android Open Source Project
*
* SPDX-License-Identifier: BSD-2-Clause
*/

#include <common.h>
#include <net.h>
#include <net/fastboot.h>
#include <stdlib.h>
#include <version.h>

/* Fastboot port # defined in spec */
#define WELL_KNOWN_PORT 5554

enum {
	FASTBOOT_ERROR = 0,
	FASTBOOT_QUERY = 1,
	FASTBOOT_INIT = 2,
	FASTBOOT_FASTBOOT = 3,
};

struct __attribute__((packed)) fastboot_header {
	uchar id;
	uchar flags;
	unsigned short seq;
};

#define PACKET_SIZE 1024
#define FASTBOOT_HEADER_SIZE sizeof(struct fastboot_header)
#define DATA_SIZE (PACKET_SIZE - FASTBOOT_HEADER_SIZE)
#define FASTBOOT_RESPONSE_LEN (64 + 1)
#define FASTBOOT_VERSION "0.4"

/* Sequence number sent for every packet */
static unsigned short fb_sequence_number = 1;
static const unsigned short fb_packet_size = PACKET_SIZE;
static const unsigned short fb_udp_version = 1;

/* Keep track of last packet for resubmission */
static uchar last_packet[PACKET_SIZE];
static unsigned int last_packet_len = 0;

/* Parsed from first fastboot command packet */
static char *cmd_string = NULL;
static char *cmd_parameter = NULL;

/* Fastboot download parameters */
static unsigned int bytes_received = 0;
static unsigned int bytes_expected = 0;
static unsigned int image_size = 0;

static struct in_addr fastboot_remote_ip;
/* The UDP port at their end */
static int fastboot_remote_port;
/* The UDP port at our end */
static int fastboot_our_port;

static void fb_getvar(char*);
static void fb_download(char*, unsigned int, char*);
static void cleanup_command_data(void);
static void write_fb_response(const char*, const char*, char*);

/**
 * Constructs and sends a packet in response to received fastboot packet
 *
 * @param fb_header            Header for response packet
 * @param fastboot_data        Pointer to received fastboot data
 * @param fastboot_data_len    Length of received fastboot data
 * @param retransmit           Nonzero if sending last sent packet
 */
static void fastboot_send(struct fastboot_header fb_header, char *fastboot_data,
		unsigned int fastboot_data_len, uchar retransmit)
{
	uchar *packet;
	uchar *packet_base;
	int len = 0;
	const char *error_msg = "An error occurred.";
	short tmp;
	struct fastboot_header fb_response_header = fb_header;
	char response[FASTBOOT_RESPONSE_LEN] = {0};
	/*
	 *	We will always be sending some sort of packet, so
	 *	cobble together the packet headers now.
	 */
	packet = net_tx_packet + net_eth_hdr_size() + IP_UDP_HDR_SIZE;
	packet_base = packet;

	/* Resend last packet */
	if (retransmit) {
		memcpy(packet, last_packet, last_packet_len);
		net_send_udp_packet(net_server_ethaddr, fastboot_remote_ip,
				    fastboot_remote_port, fastboot_our_port, last_packet_len);
		return;
	}

	fb_response_header.seq = htons(fb_response_header.seq);
	memcpy(packet, &fb_response_header, sizeof(fb_response_header));
	packet += sizeof(fb_response_header);

	switch (fb_header.id) {
	case FASTBOOT_QUERY:
		tmp = htons(fb_sequence_number);
		memcpy(packet, &tmp, sizeof(tmp));
		packet += sizeof(tmp);
		break;
	case FASTBOOT_INIT:
		tmp = htons(fb_udp_version);
		memcpy(packet, &tmp, sizeof(tmp));
		packet += sizeof(tmp);
		tmp = htons(fb_packet_size);
		memcpy(packet, &tmp, sizeof(tmp));
		packet += sizeof(tmp);
		break;
	case FASTBOOT_ERROR:
		memcpy(packet, error_msg, strlen(error_msg));
		packet += strlen(error_msg);
		break;
	case FASTBOOT_FASTBOOT:
		if (cmd_string == NULL) {
			/* Parse command and send ack */
			cmd_parameter = fastboot_data;
			cmd_string = strsep(&cmd_parameter, ":");
			cmd_string = strdup(cmd_string);
			if (cmd_parameter) {
				cmd_parameter = strdup(cmd_parameter);
			}
		} else if (!strcmp("getvar", cmd_string)) {
			fb_getvar(response);
		} else if (!strcmp("download", cmd_string)) {
			fb_download(fastboot_data, fastboot_data_len, response);
		} else {
			error("command %s not implemented.\n", cmd_string);
			write_fb_response("FAIL", "unrecognized command", response);
		}
		/* Write response to packet */
		memcpy(packet, response, strlen(response));
		packet += strlen(response);
		break;
	default:
		error("ID %d not implemented.\n", fb_header.id);
		return;
	}

	len = packet-packet_base;

	/* Save packet for retransmitting */
	last_packet_len = len;
	memcpy(last_packet, packet_base, last_packet_len);

	net_send_udp_packet(net_server_ethaddr, fastboot_remote_ip,
			    fastboot_remote_port, fastboot_our_port, len);

	/* OKAY and FAIL indicate command is complete */
	if (!strncmp("OKAY", response, 4) ||
			!strncmp("FAIL", response, 4)) {
		cleanup_command_data();
	}
}

/**
 * Writes ascii string specified by cmd_parameter to response.
 *
 * @param repsonse    Pointer to fastboot response buffer
 */
static void fb_getvar(char *response)
{

	if (cmd_parameter == NULL) {
		write_fb_response("FAIL", "missing var", response);
	} else if (!strcmp("version", cmd_parameter)) {
		write_fb_response("OKAY", FASTBOOT_VERSION, response);
	} else if (!strcmp("bootloader-version", cmd_parameter)) {
		write_fb_response("OKAY", U_BOOT_VERSION, response);
	} else if (!strcmp("downloadsize", cmd_parameter) ||
		!strcmp("max-download-size", cmd_parameter)) {
		char buf_size_str[12];
		sprintf(buf_size_str, "0x%08x", CONFIG_FASTBOOT_BUF_SIZE);
		write_fb_response("OKAY", buf_size_str, response);
	} else if (!strcmp("serialno", cmd_parameter)) {
		const char *tmp = getenv("serial#");
		if (tmp) {
			write_fb_response("OKAY", tmp, response);
		} else {
			write_fb_response("FAIL", "Value not set", response);
		}
	} else {
		printf("WARNING: unknown variable: %s\n", cmd_parameter);
		write_fb_response("FAIL", "Variable not implemented", response);
	}
}

/**
 * Copies image data from fastboot_data to CONFIG_FASTBOOT_BUF_ADDR.
 * Writes to response.
 *
 * @param fastboot_data        Pointer to received fastboot data
 * @param fastboot_data_len    Length of received fastboot data
 * @param repsonse             Pointer to fastboot response buffer
 */
static void fb_download(char *fastboot_data, unsigned int fastboot_data_len,
		char *response)
{
	char *tmp;

	if (bytes_expected == 0) {
		if (cmd_parameter == NULL) {
			write_fb_response("FAIL", "Expected command parameter", response);
			return;
		}
		bytes_expected = simple_strtoul(cmd_parameter, &tmp, 16);
		if (bytes_expected == 0) {
			write_fb_response("FAIL", "Expected nonzero image size", response);
			return;
		}
	}
	if (fastboot_data_len == 0 && bytes_received == 0) {
		/* Nothing to download yet. Response is of the form:
		 * [DATA|FAIL]$cmd_parameter
		 *
		 * where cmd_parameter is an 8 digit hexadecimal number
		 */
		if (bytes_expected > CONFIG_FASTBOOT_BUF_SIZE) {
			write_fb_response("FAIL", cmd_parameter, response);
		} else {
			write_fb_response("DATA", cmd_parameter, response);
		}
	} else if (fastboot_data_len == 0 && (bytes_received >= bytes_expected)) {
		/* Download complete. Respond with "OKAY" */
		write_fb_response("OKAY", "", response);
		image_size = bytes_received;
		bytes_expected = bytes_received = 0;
	} else {
		if (fastboot_data_len == 0 ||
				(bytes_received + fastboot_data_len) > bytes_expected) {
			write_fb_response("FAIL", "Received invalid data length", response);
			return;
		}
		/* Download data to CONFIG_FASTBOOT_BUF_ADDR */
		memcpy((void*)CONFIG_FASTBOOT_BUF_ADDR + bytes_received, fastboot_data,
				fastboot_data_len);
		bytes_received += fastboot_data_len;
	}
}

/**
 * Writes a response to response buffer of the form "$tag$reason".
 *
 * @param tag         The first part of the response
 * @param reason      The second part of the response
 * @param repsonse    Pointer to fastboot response buffer
 */
static void write_fb_response(const char* tag, const char *reason,
		char *response)
{
	strncpy(response, tag, strlen(tag));
	strncat(response, reason, FASTBOOT_RESPONSE_LEN - strlen(tag) - 1);
}

/**
 * Frees any resources allocated during current fastboot command.
 */
static void cleanup_command_data(void)
{
	/* cmd_parameter and cmd_string potentially point to memory allocated by
	 * strdup
	 */
	if (cmd_parameter) {
		free(cmd_parameter);
	}
	if (cmd_string) {
		free(cmd_string);
	}
	cmd_parameter = cmd_string = NULL;
}

/**
 * Incoming UDP packet handler.
 *
 * @param packet  Pointer to incoming UDP packet
 * @param dport   Destination UDP port
 * @param sip     Source IP address
 * @param sport   Source UDP port
 * @param len     Packet length
 */
static void fastboot_handler(uchar *packet, unsigned dport, struct in_addr sip,
		unsigned sport, unsigned len)
{
	struct fastboot_header fb_header;
	char fastboot_data[DATA_SIZE] = {0};
	unsigned int fastboot_data_len = 0;

	if (dport != fastboot_our_port) {
		return;
	}

	fastboot_remote_ip = sip;
	fastboot_remote_port = sport;

	if (len < FASTBOOT_HEADER_SIZE || len > PACKET_SIZE) {
		return;
	}
	memcpy(&fb_header, packet, sizeof(fb_header));
	fb_header.flags = 0;
	fb_header.seq = ntohs(fb_header.seq);
	packet += sizeof(fb_header);
	len -= sizeof(fb_header);

	switch (fb_header.id) {
	case FASTBOOT_QUERY:
		fastboot_send(fb_header, fastboot_data, 0, 0);
		break;
	case FASTBOOT_INIT:
	case FASTBOOT_FASTBOOT:
		fastboot_data_len = len;
		if (len > 0) {
			memcpy(fastboot_data, packet, len);
		}
		if (fb_header.seq == fb_sequence_number) {
			fastboot_send(fb_header, fastboot_data, fastboot_data_len, 0);
			fb_sequence_number++;
		} else if (fb_header.seq == fb_sequence_number - 1) {
			/* Retransmit last sent packet */
			fastboot_send(fb_header, fastboot_data, fastboot_data_len, 1);
		}
		break;
	default:
		error("ID %d not implemented.\n", fb_header.id);
		fb_header.id = FASTBOOT_ERROR;
		fastboot_send(fb_header, fastboot_data, 0, 0);
		break;
	}
}

void fastboot_start_server(void)
{
	printf("Using %s device\n", eth_get_name());
	printf("Listening for fastboot command on %pI4\n", &net_ip);

	fastboot_our_port = WELL_KNOWN_PORT;

	net_set_udp_handler(fastboot_handler);

	/* zero out server ether in case the server ip has changed */
	memset(net_server_ethaddr, 0, 6);
}
