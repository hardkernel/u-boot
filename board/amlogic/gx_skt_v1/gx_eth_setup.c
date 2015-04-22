/*************************************************************************
	> File Name: gx_eth_setup.c
	> Author: jianfeng
	> Mail: jianfeng.wang@amlogic.com
	> Created Time: Tue 21 Apr 2015 05:04:50 PM CST
 ************************************************************************/
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
		new_board->name="gxbb";
	}

	new_board->eth_pinmux_setup=NULL ;
	new_board->eth_clock_configure=NULL;
	new_board->eth_hw_reset=NULL;
	return new_board;
}
//pinmux   HHI_GCLK_MPEG1[bit 3]
//
