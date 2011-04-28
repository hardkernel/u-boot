/*
 * nand_inf.c
 *
 *  Created on: Aug 22, 2011
 *      Author: jerry.yu
 */
#include <amlogic/nand/cntl.h>
#include <amlogic/nand/platform.h>
#include <amlogic/nand/types.h>
#include <malloc.h>
#include <errno.h>

void nand_init(void)
{
	board_mynand_init();
}

