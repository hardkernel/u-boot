/*
 * (C) Copyright 2008 - 2009
 * Windriver, <www.windriver.com>
 * Tom Rix <Tom.Rix@windriver.com>
 *
 * Copyright 2011 Sebastian Andrzej Siewior <bigeasy@linutronix.de>
 *
 * Copyright 2014 Linaro, Ltd.
 * Rob Herring <robh@kernel.org>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */
#ifndef _FASTBOOT_H_
#define _FASTBOOT_H_

/* The 64 defined bytes plus \0 */
#define FASTBOOT_RESPONSE_LEN (64 + 1)

void fastboot_fail(const char *reason, char *response);
void fastboot_okay(const char *reason, char *response);

/**
 * Send an INFO packet during long commands based on timer. If
 * CONFIG_UDP_FUNCTION_FASTBOOT is defined, an INFO packet is sent
 * if the time is 30 seconds after start. Else, noop.
 *
 * TODO: Handle the situation where both UDP and USB fastboot are
 *       enabled.
 *
 * @param start:  Time since last INFO packet was sent.
 * @param msg:    String describing the reason for waiting
 */
void timed_send_info(ulong *start, const char *msg);

#endif /* _FASTBOOT_H_ */
