/*
 * (C) Copyright 2012
 * Elvis Yu, Amlogic Software Engineering, elvis.yu@amlogic.com.
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */

/*
 * Math functions
 */
#include <common.h>
#include <command.h>


int do_calc (cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	int val0, val1, result = 0;
	char operator;
	char result_str[32];

	if (argc != 5)
		return cmd_usage(cmdtp);

	

	val0 = simple_strtol(argv[1], NULL, 10);
	val1 = simple_strtol(argv[3], NULL, 10);

	if(strlen(argv[2]) != 1)
	{
		return cmd_usage(cmdtp);
	}

	operator = argv[2][0];

	switch(operator)
	{
		case '+':
		{
			result = val0 + val1;
			break;
		}
		case '-':
		{
			result = val0 - val1;
			break;
		}
		case '*':
		{
			result = val0 * val1;
			break;
		}
		case '/':
		{
			if(val1 == 0)
			{
				printf("Division by zero!\n");
				return -1;
			}
			result = val0 / val1;
			break;
		}
	}

	sprintf(result_str, "%d", result);

	setenv(argv[4], result_str);
	
	return 0;
}

U_BOOT_CMD(
	calc ,    5,    1,     do_calc,
	"command for calculate",
	"N\n"
	"calc <val0> <operator> <val1> <result>\n"
);


