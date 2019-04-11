
/*
 * board/amlogic/txl_skt_v1/eth_setup.c
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

#include <common.h>
#include <malloc.h>
#include <errno.h>
#include <environment.h>
#include <fdt_support.h>
#include <libfdt.h>
#include <asm/arch/eth_setup.h>
/*
 *
 *setup eth device board socket
 *
 */
struct eth_board_socket* eth_board_setup(char *name){
	struct eth_board_socket* new_board;
	new_board= (struct eth_board_socket*) malloc(sizeof(struct eth_board_socket));
	if (NULL == new_board) return NULL;
	if (name != NULL) {
		new_board->name=(char*)malloc(strlen(name));
		strncpy(new_board->name,name,strlen(name));
	}else{
		new_board->name="gxb";
	}

	new_board->eth_pinmux_setup=NULL ;
	new_board->eth_clock_configure=NULL;
	new_board->eth_hw_reset=NULL;
	return new_board;
}
//pinmux   HHI_GCLK_MPEG1[bit 3]
//
