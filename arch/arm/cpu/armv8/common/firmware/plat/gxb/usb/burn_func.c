
/*
 * arch/arm/cpu/armv8/common/firmware/plat/gxb/usb/burn_func.c
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

#include <sys/ctype.h>
#include <console.h>
//#include <serial.h>
//#include "usb_pcd.h"
//#define CONFIG_SYS_MAXARGS		16
int serial_puts(const char *s){
	while (*s) {
		console_putc(*s++);
	}
	return 0;
}
//support 64bit number, console_put_hex(data, 64);
void serial_put_hex(unsigned long data,unsigned int bitlen)
{
	int i;
	for (i=bitlen-4;i>=0;i-=4) {
        if ((data>>i) == 0)
        {
            console_putc(0x30);
            continue;
        }
        unsigned char s = (data>>i)&0xf;
        if (s<10)
            console_putc(0x30+s);
        else
            console_putc(0x61+s-10);
    }
}

/**
 * strcpy - Copy a %NUL terminated string
 * @dest: Where to copy the string to
 * @src: Where to copy the string from
 */
char * strcpy(char * dest,const char *src)
{
	char *tmp = dest;

	while ((*dest++ = *src++) != '\0')
		/* nothing */;
	return tmp;
}


/**
 * strncmp - Compare two length-limited strings
 * @cs: One string
 * @ct: Another string
 * @count: The maximum number of bytes to compare
 */
 /*
int strncmp(const char * cs,const char * ct,size_t count)
{
	register signed char __res = 0;

	while (count) {
		if ((__res = *cs - *ct++) != 0 || !*cs++)
			break;
		count--;
	}

	return __res;
}
*/


int parse_line (char *line, char *argv[])
{
	int nargs = 0;

#ifdef DEBUG_PARSER
	printf ("parse_line: \"%s\"\n", line);
#endif
	while (nargs < CONFIG_SYS_MAXARGS) {

		/* skip any white space */
		while ((*line == ' ') || (*line == '\t')) {
			++line;
		}

		if (*line == '\0') {	/* end of line, no more args	*/
			argv[nargs] = NULL;
#ifdef DEBUG_PARSER
		printf ("parse_line: nargs=%d\n", nargs);
#endif
			return (nargs);
		}

		argv[nargs++] = line;	/* begin of argument string	*/

		/* find end of string */
		while (*line && (*line != ' ') && (*line != '\t')) {
			++line;
		}

		if (*line == '\0') {	/* end of line, no more args	*/
			argv[nargs] = NULL;
#ifdef DEBUG_PARSER
		printf ("parse_line: nargs=%d\n", nargs);
#endif
			return (nargs);
		}

		*line++ = '\0';		/* terminate current arg	 */
	}

#ifdef DEBUG_PARSER
	printf ("parse_line: nargs=%d\n", nargs);
#endif
	return (nargs);
}

unsigned long simple_strtoul(const char *cp,char **endp,unsigned int base)
{
	unsigned long result = 0,value;

	if (*cp == '0') {
		cp++;
		if ((*cp == 'x') && isxdigit(cp[1])) {
			base = 16;
			cp++;
		}
		if (!base) {
			base = 8;
		}
	}
	if (!base) {
		base = 10;
	}
	while (isxdigit(*cp) && (value = isdigit(*cp) ? *cp-'0' : (islower(*cp)
	    ? toupper(*cp) : *cp)-'A'+10) < base) {
		result = result*base + value;
		cp++;
	}
	if (endp)
		*endp = (char *)cp;
	return result;
}

extern void * memset(void * s,int c,size_t count);
u32 checkcum_32(const unsigned char *buf, u32 len)
{
	u32 fake_len, chksum = 0;
	u32 *ptr = (u32 *)buf;
	int i;
	serial_puts("\nbuf=");
	serial_put_hex((unsigned int)(unsigned long long)buf, 32);
	serial_puts("len=");
	serial_put_hex(len, 32);
	if (len%4)
	{
		fake_len = len - len%4 + 4;
		memset((void *)(buf+len), 0, (fake_len-len));
	}
	else
	{
		fake_len = len;
	}
	serial_puts("fake_len=");
	serial_put_hex(fake_len, 32);
	for (i=0; i<fake_len; i+=4, ptr++)
	{
		chksum += *ptr;
	}
	return chksum;
}

int usb_run_command (const char *cmd, char *buffer)
{
	u32 addr = 0, length = 0;
	u32 crc_value, crc_verify = 0;
	int argc;
	char *argv[CONFIG_SYS_MAXARGS + 1];	/* NULL terminated	*/

	serial_puts("cmd:");
	serial_puts(cmd);

	memset(buffer, 0, CMD_BUFF_SIZE);
	if (strncmp(cmd,"crc",(sizeof("crc")-1)) == 0)
	{
		if ((argc = parse_line ((char *)cmd, argv)) == 0) {
			return -1;	/* no command at all */
		}
		addr = simple_strtoul (argv[1], NULL, 16);
		length = simple_strtoul (argv[2], NULL, 10);
		crc_verify = simple_strtoul (argv[3], NULL, 16);
		//crc_value = crc32 (0, (const uchar *) addr, length);
		crc_value = checkcum_32((unsigned char *)(unsigned long long)addr, length);
		serial_puts("crc_value=");
		serial_put_hex(crc_value, 32);
		if (crc_verify == crc_value)
		{
			strcpy(buffer, "success");
		}
		else
		{
			strcpy(buffer, "failed");
		}
	}
	return 0;
}

int burn_board(const char *dev, void *mem_addr, u64 offset, u64 size)
{
	char	str[128];
	printf("burn_board!!!\n");
	printf("CMD: dev=%s, mem_addr=0x%llx, offset=0x%llx, size=0x%llx\n", dev, (unsigned long long)mem_addr, offset, size);
	if (!strncmp("nand", (const char *)(unsigned long long)(*dev), 4))
	{
		sprintf(str, "nand erase 0x%llx 0x%llx}", offset, size);
		printf("command:    %s\n", str);
		//run_command(str, 0);
		sprintf(str, "nand write 0x%llx 0x%llx 0x%llx}", (unsigned long long)mem_addr, offset, size);
		printf("command:    %s\n", str);
		//run_command(str, 0);
	}
	else if(!strncmp("spi", (const char *)(unsigned long long)(*dev), 3))
	{
		//run_command("sf probe 2", 0);
		sprintf(str, "sf erase 0x%llx 0x%llx}", offset, size);
		printf("command:    %s\n", str);
		//run_command(str, 0);
		sprintf(str, "sf write 0x%llx 0x%llx 0x%llx}", (unsigned long long)mem_addr, offset, size);
		printf("command:    %s\n", str);
		//run_command(str, 0);
	}
	else if(!strncmp("emmc", (const char *)(unsigned long long)(*dev), 4))
	{
		sprintf(str, "mmc write 1 0x%llx 0x%llx 0x%llx}", (unsigned long long)mem_addr, offset, size);
		printf("command:    %s\n", str);
		//run_command(str, 0);
	}
	else
	{
		printf("Invalid Argument!\n");
		return -1;
	}
	return 0;
}
