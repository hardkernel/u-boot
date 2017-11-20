/*
 * include/amlogic/aml_hdmirx.h
 *
 * Copyright (C) 2012 AMLOGIC, INC. All Rights Reserved.
 * Author: hongmin hua <hongmin hua@amlogic.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the smems of the GNU General Public License as published by
 * the Free Software Foundation; version 2 of the License.
 */

#ifndef _AML_HDMIRX_H
#define _AML_HDMIRX_H

void hdmirx_hw_init(unsigned int port_map,
		unsigned char *pedid_data,
		int edid_size);

#endif /* _AML_HDMIRX_H */
