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

/* Sequence number sent for every packet */
static unsigned short fb_sequence_number = 1;
static const unsigned short fb_packet_size = PACKET_SIZE;
static const unsigned short fb_udp_version = 1;

/* Keep track of last packet for resubmission */
static uchar last_packet[PACKET_SIZE];
static unsigned int last_packet_len = 0;

static struct in_addr fastboot_remote_ip;
/* The UDP port at their end */
static int fastboot_remote_port;
/* The UDP port at our end */
static int fastboot_our_port;

/**
 * Constructs and sends a packet in response to received fastboot packet
 *
 * @param fb_header    Header for response packet
 * @param retransmit   Nonzero if sending last sent packet
 */
static void fastboot_send(struct fastboot_header fb_header, uchar retransmit)
{
	uchar *packet;
	uchar *packet_base;
	int len = 0;
	const char *error_msg = "An error occurred.";
	short tmp;
	struct fastboot_header fb_response_header = fb_header;
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
		fastboot_send(fb_header, 0);
		break;
	case FASTBOOT_INIT:
		if (fb_header.seq == fb_sequence_number) {
			fastboot_send(fb_header, 0);
			fb_sequence_number++;
		} else if (fb_header.seq == fb_sequence_number - 1) {
			/* Retransmit last sent packet */
			fastboot_send(fb_header, 1);
		}
		break;
	case FASTBOOT_FASTBOOT:
	default:
		error("ID %d not implemented.\n", fb_header.id);
		fb_header.id = FASTBOOT_ERROR;
		fastboot_send(fb_header, 0);
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
