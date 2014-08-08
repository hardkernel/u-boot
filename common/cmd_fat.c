/*
 * (C) Copyright 2002
 * Richard Jones, rjones@nexus-tech.net
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
 * Boot support
 */
#include <common.h>
#include <command.h>
#include <s_record.h>
#include <net.h>
#include <ata.h>
#include <part.h>
#include <fat.h>


int do_fat_fsload (cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	long size;
	unsigned long offset;
	unsigned long count;
	char buf [12];
	block_dev_desc_t *dev_desc=NULL;
	int dev=0;
	int part=1;
	char *ep;

	if (argc < 5) {
		printf( "usage: fatload <interface> <dev[:part]> "
			"<addr> <filename> [bytes]\n");
		return 1;
	}

	dev = (int)simple_strtoul(argv[2], &ep, 16);
	dev_desc = get_dev(argv[1],dev);
	if (dev_desc == NULL) {
		puts("\n** Invalid boot device **\n");
		return 1;
	}
	if (*ep) {
		if (*ep != ':') {
			puts("\n** Invalid boot device, use `dev[:part]' **\n");
			return 1;
		}
		part = (int)simple_strtoul(++ep, NULL, 16);
	}
	if (fat_register_device(dev_desc,part)!=0) {
		printf("\n** Unable to use %s %d:%d for fatload **\n",
			argv[1], dev, part);
		return 1;
	}
	offset = simple_strtoul(argv[3], NULL, 16);
	if (argc == 6)
		count = simple_strtoul(argv[5], NULL, 16);
	else
		count = 0;
	size = file_fat_read(argv[4], (unsigned char *)offset, count);

	if(size==-1) {
		printf("\n** Unable to read \"%s\" from %s %d:%d **\n",
			argv[4], argv[1], dev, part);
		return 1;
	}

	printf("\n%ld bytes read\n", size);

	sprintf(buf, "%lX", size);
	setenv("filesize", buf);

	return 0;
}


U_BOOT_CMD(
	fatload,	6,	0,	do_fat_fsload,
	"load binary file from a dos filesystem",
	"<interface> <dev[:part]>  <addr> <filename> [bytes]\n"
	"    - load binary file 'filename' from 'dev' on 'interface'\n"
	"      to address 'addr' from dos filesystem"
);

int do_fat_ls (cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	char *filename = "/";
	int ret;
	int dev=0;
	int part=1;
	char *ep;
	block_dev_desc_t *dev_desc=NULL;

	if (argc < 3) {
		printf("usage: fatls <interface> <dev[:part]> [directory]\n");
		return 0;
	}
	dev = (int)simple_strtoul(argv[2], &ep, 16);
	dev_desc = get_dev(argv[1],dev);
	if (dev_desc == NULL) {
		puts("\n** Invalid boot device **\n");
		return 1;
	}
	if (*ep) {
		if (*ep != ':') {
			puts("\n** Invalid boot device, use `dev[:part]' **\n");
			return 1;
		}
		part = (int)simple_strtoul(++ep, NULL, 16);
	}
	if (fat_register_device(dev_desc,part)!=0) {
		printf("\n** Unable to use %s %d:%d for fatls **\n",
			argv[1], dev, part);
		return 1;
	}
	if (argc == 4)
		ret = file_fat_ls(argv[3]);
	else
		ret = file_fat_ls(filename);

	if(ret!=0)
		printf("No Fat FS detected\n");
	return ret;
}

U_BOOT_CMD(
	fatls,	4,	1,	do_fat_ls,
	"list files in a directory (default /)",
	"<interface> <dev[:part]> [directory]\n"
	"    - list files from 'dev' on 'interface' in a 'directory'"
);

int do_fat_fsinfo (cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	int dev=0;
	int part=1;
	char *ep;
	block_dev_desc_t *dev_desc=NULL;

	if (argc < 2) {
		printf("usage: fatinfo <interface> <dev[:part]>\n");
		return 0;
	}
	dev = (int)simple_strtoul(argv[2], &ep, 16);
	dev_desc = get_dev(argv[1],dev);
	if (dev_desc == NULL) {
		puts("\n** Invalid boot device **\n");
		return 1;
	}
	if (*ep) {
		if (*ep != ':') {
			puts("\n** Invalid boot device, use `dev[:part]' **\n");
			return 1;
		}
		part = (int)simple_strtoul(++ep, NULL, 16);
	}
	if (fat_register_device(dev_desc,part)!=0) {
		printf("\n** Unable to use %s %d:%d for fatinfo **\n",
			argv[1], dev, part);
		return 1;
	}
	return file_fat_detectfs();
}

U_BOOT_CMD(
	fatinfo,	3,	1,	do_fat_fsinfo,
	"print information about filesystem",
	"<interface> <dev[:part]>\n"
	"    - print information about filesystem from 'dev' on 'interface'"
);

#ifdef CONFIG_FAT_WRITE
static int do_fat_fswrite(cmd_tbl_t *cmdtp, int flag,
		int argc, char * const argv[])
{
	long size;
	unsigned long addr;
	unsigned long count;
	block_dev_desc_t *dev_desc = NULL;
	int dev = 0;
	int part = 1;
	char *ep;

	if (argc < 5)
		return cmd_usage(cmdtp);

	dev = (int)simple_strtoul(argv[2], &ep, 16);
	dev_desc = get_dev(argv[1], dev);
	if (dev_desc == NULL) {
		puts("\n** Invalid boot device **\n");
		return 1;
	}
	if (*ep) {
		if (*ep != ':') {
			puts("\n** Invalid boot device, use `dev[:part]' **\n");
			return 1;
		}
		part = (int)simple_strtoul(++ep, NULL, 16);
	}
	if (fat_register_device(dev_desc, part) != 0) {
		printf("\n** Unable to use %s %d:%d for fatwrite **\n",
			argv[1], dev, part);
		return 1;
	}
	addr = simple_strtoul(argv[3], NULL, 16);
	count = simple_strtoul(argv[5], NULL, 16);

	size = file_fat_write(argv[4], (void *)addr, count);
	if (size == -1) {
		printf("\n** Unable to write \"%s\" from %s %d:%d **\n",
			argv[4], argv[1], dev, part);
		return 1;
	}

	printf("%ld bytes written\n", size);

	return 0;
}

U_BOOT_CMD(
	fatwrite,	6,	0,	do_fat_fswrite,
	"write file into a dos filesystem",
	"<interface> <dev[:part]> <addr> <filename> <bytes>\n"
	"    - write file 'filename' from the address 'addr' in RAM\n"
	"      to 'dev' on 'interface'"
);
#endif

int do_fat_format(cmd_tbl_t *cmdtp, int flag, int argc, char *argv[])
{
	int dev = 0;
	int part = 1;
	char *ep;
	block_dev_desc_t *dev_desc = NULL;

	if (argc < 2) {
		printf ("usage : fatformat <interface> <dev[:part]>\n");
		return(0);
	}

	dev = (int)simple_strtoul (argv[2], &ep, 16);
	dev_desc = get_dev(argv[1], dev);

	if (dev_desc == NULL) {
		puts ("\n ** Invalid boot device **\n");
		return 1;
	}

	if (*ep) {
		if (*ep != ':') {
			puts ("\n **Invald boot device,use 'dev[:part]'**\n");
			return 1;
		}
		part = (int)simple_strtoul(++ep, NULL, 16);
		if (part > 4 || part <1) {
			puts ("** Partition Number should be 1 ~ 4 **\n");
		}
	}
	printf("Start format MMC&d partition&d ...\n", dev, part);
	if (fat_format_device(dev_desc, part) != 0) {
		printf("Format failure!!!\n");
	}

	return 0;
}

U_BOOT_CMD(
	fatformat, 3, 0, do_fat_format,
	"fatformat - disk format by FAT32\n",
	"<interface(only support mmc)> <dev:partition num>\n"
	"	- format by FAT32 on 'interface'\n"
);

int do_fat_cfgload(cmd_tbl_t *cmdtp, int flag, int argc, char *argv[])
{
    unsigned long   filesize = 0;
    unsigned char   *fp = (unsigned char *)0x5FFF0000, cmd[512], skip = 0, first = 1;
    unsigned int    wpos = 0;
    
    // file check & update
	setenv("filesize", "0");
    run_command("fatload mmc 0:1 5FFF0000 boot.ini", 0);
    
    if((filesize = getenv_ulong("filesize", 16, 0)))    {
        
        if(filesize > 64 * 1024)    {
            printf("File Size Error! Max file size 64Kbytes. filesize = %d\n", filesize);
            return  0;
        }
        
        while(1)    {
            if(*fp == '#')  skip = 1;
            else    {
                skip = 0;   wpos = 0;
                memset(cmd, 0x00, sizeof(cmd));
            }                

            while(*fp != 0x0A)  {
                if((*fp != 0x0D) && (!skip))     cmd[wpos++] = *fp;

                fp++;
                if(filesize)    filesize--;
                else            break;
            }
            
            if(wpos)    {
                if(wpos < sizeof(cmd)) {
                    if(first)   {
                        if(!strncmp(cmd, "ODROIDXU-UBOOT-CONFIG", sizeof("ODROIDXU-UBOOT-CONFIG"))) {
                            printf("Find boot.ini file from FAT Area!!\n");     first = 0;
                        }
                        else    {
                            printf("Find boot.ini file. But This file is not odroidxu config file!\n");
                            return  0;
                        }
                    }
                    else    {
                        printf("boot.ini command = %s\n", cmd);
                        run_command(cmd, 0);
                    }
                }
                wpos = 0;
            }
            fp++;
            if(filesize)    filesize--;
            else            break;
        }
        return  1;
    }
	return  0;
}

U_BOOT_CMD(
	cfgload, 1, 0, do_fat_cfgload,
	"cfgload - boot.ini textfile load from FAT32\n",
	"<interface(only support mmc 0:1)>\n"
	"	- boot.ini file load from FAT32 on 'interface'\n"
);
