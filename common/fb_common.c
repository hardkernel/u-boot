/*
* Copyright (C) 2016 The Android Open Source Project
*
* SPDX-License-Identifier: BSD-2-Clause
*/

#include <common.h>
#include <fastboot.h>

void fastboot_fail(const char *reason, char *response)
{
	const char *fail_str = "FAIL";
	strncpy(response, fail_str, FASTBOOT_RESPONSE_LEN);
	strncat(response, reason, FASTBOOT_RESPONSE_LEN - strlen(fail_str) - 1);
}

void fastboot_okay(const char *reason, char *response)
{
	const char *okay_str = "OKAY";
	strncpy(response, okay_str, FASTBOOT_RESPONSE_LEN);
	strncat(response, reason, FASTBOOT_RESPONSE_LEN - strlen(okay_str) - 1);
}
