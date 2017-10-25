
/*
 * common/cmd_rpmb.c
 *
 * Copyright (C) 2017 Amlogic, Inc. All rights reserved.
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
#include <asm/arch/secure_apb.h>

static int do_rpmb_state(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	int nReturn = __LINE__;

#define AML_RPMB_STATE (((readl(AO_SEC_GP_CFG7))>>22) & 0x01)

	char *pARG = getenv("bootargs");

	if (pARG)
	{
		//printf("1 bootargs=%s\n",pARG);

		char *szBuffer=malloc(strlen(pARG)+64);
		nReturn = __LINE__;

		if (szBuffer)
		{
			memset(szBuffer+strlen(pARG),0,64);
			strcpy(szBuffer,pARG);
			char *pFind = strstr(szBuffer,"androidboot.rpmb_state");
			if (!pFind)
				sprintf(szBuffer,"%s androidboot.rpmb_state=%d",pARG,AML_RPMB_STATE);
			else
				pFind[23] = AML_RPMB_STATE ? '1':'0';

			//printf("2 bootargs=%s\n",szBuffer);

			setenv("rpmb_state",AML_RPMB_STATE?"1":"0"); //need this?
			setenv("bootargs",szBuffer);
			free(szBuffer);
			szBuffer = 0;

			nReturn = 0;
		}
		else
			printf("aml log : internal sys error!\n");

	}

	return nReturn;
}

U_BOOT_CMD(rpmb_state, CONFIG_SYS_MAXARGS, 0, do_rpmb_state,
		"RPMB sub-system",
		"RPMB state\n");


/****************************************************/
