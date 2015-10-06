/*
 * (C) Copyright 2002
 * Richard Jones, rjones@nexus-tech.net
 *
 * SPDX-License-Identifier:	GPL-2.0+
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
#include <fs.h>

int do_fat_fsload (cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	return do_load(cmdtp, flag, argc, argv, FS_TYPE_FAT);
}


U_BOOT_CMD(
	fatload,	7,	0,	do_fat_fsload,
	"load binary file from a dos filesystem",
	"<interface> [<dev[:part]>]  <addr> <filename> [bytes [pos]]\n"
	"    - Load binary file 'filename' from 'dev' on 'interface'\n"
	"      to address 'addr' from dos filesystem.\n"
	"      'pos' gives the file position to start loading from.\n"
	"      If 'pos' is omitted, 0 is used. 'pos' requires 'bytes'.\n"
	"      'bytes' gives the size to load. If 'bytes' is 0 or omitted,\n"
	"      the load stops on end of file.\n"
	"      If either 'pos' or 'bytes' are not aligned to\n"
	"      ARCH_DMA_MINALIGN then a misaligned buffer warning will\n"
	"      be printed and performance will suffer for the load."
);

static int do_fat_ls(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	return do_ls(cmdtp, flag, argc, argv, FS_TYPE_FAT);
}

U_BOOT_CMD(
	fatls,	4,	1,	do_fat_ls,
	"list files in a directory (default /)",
	"<interface> [<dev[:part]>] [directory]\n"
	"    - list files from 'dev' on 'interface' in a 'directory'"
);

static int do_fat_fsinfo(cmd_tbl_t *cmdtp, int flag, int argc,
			 char * const argv[])
{
	int dev, part;
	block_dev_desc_t *dev_desc;
	disk_partition_t info;

	if (argc < 2) {
		printf("usage: fatinfo <interface> [<dev[:part]>]\n");
		return 0;
	}

	part = get_device_and_partition(argv[1], argv[2], &dev_desc, &info, 1);
	if (part < 0)
		return 1;

	dev = dev_desc->dev;
	if (fat_set_blk_dev(dev_desc, &info) != 0) {
		printf("\n** Unable to use %s %d:%d for fatinfo **\n",
			argv[1], dev, part);
		return 1;
	}
	return file_fat_detectfs();
}

U_BOOT_CMD(
	fatinfo,	3,	1,	do_fat_fsinfo,
	"print information about filesystem",
	"<interface> [<dev[:part]>]\n"
	"    - print information about filesystem from 'dev' on 'interface'"
);

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
			puts ("\n ** Invald boot device, use 'dev[:part]' **\n");
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

int do_system_update(cmd_tbl_t *cmdtp, int flag, int argc, char *argv[])
{
    unsigned char   run_cmd[50];
    unsigned int    update_device_num, load_device_num, system_memory_end, max_load_file_cnt;
    unsigned int    load_img_size, wr_blk_addr, wr_blk_size, filesize;
    unsigned int    load_img_mem_base, load_partition_num;
    unsigned char   *load_img_name_base, *load_partition_type, *raw_write_enable;
    unsigned char   name_f = 'a', name_s = 'a';

    system_memory_end   = getenv_ulong("system_memory_end", 16, 0);
    if(!system_memory_end)   {
        system_memory_end = 0x80000000;
        printf("system memory end addr = 0x%08X\n", system_memory_end);
    }

    max_load_file_cnt   = getenv_ulong("max_load_file_cnt", 16, 0);
    if(!max_load_file_cnt)   {
        max_load_file_cnt = 0x500;
        printf("Max load file count default set = 0x%08X\n", max_load_file_cnt);
    }
    printf("max_load_file_cnt = 0x%08X\n", max_load_file_cnt);

    load_img_name_base  = getenv("load_img_name_base");
    load_partition_type = getenv("load_partition_type");
    raw_write_enable    = getenv("raw_write_enable");
    
    update_device_num   = getenv_ulong("update_device_num", 16, 0);
    load_device_num     = getenv_ulong("load_device_num", 16, 0);
    load_partition_num  = getenv_ulong("load_partition_num", 16, 0);
    
    wr_blk_addr         = 0;
    load_img_size       = getenv_ulong("load_img_size", 16, 0);
    if(load_img_size)
        wr_blk_size     = load_img_size / 512;

    load_img_mem_base   = getenv_ulong("load_img_mem_base", 16, 0);
    if(!load_img_mem_base)  {
        load_img_mem_base = 0x45000000;     // default memory base
        printf("load_img_mem_base default set : 0x%08X\n", load_img_mem_base);
    }
    setenv("load_img_next_base", "0");
    
    while(max_load_file_cnt--)   {
        filesize = 0;    setenv("filesize", "0");
        memset(run_cmd, 0x00, sizeof(run_cmd));
        if(!strncmp(load_partition_type, "fat", sizeof("fat"))) {
            sprintf(run_cmd, "fatload mmc %d:%d 0x%08X %s%c%c",
                                load_device_num, load_partition_num,
                                load_img_mem_base, load_img_name_base, name_f, name_s);
            run_command(run_cmd, 0);
        }
        else if(!strncmp(load_partition_type, "ext4", sizeof("ext4")))   {
            sprintf(run_cmd, "ext4oad mmc %d:%d 0x%08X %s%c%c",
                                load_device_num, load_partition_num,
                                load_img_mem_base, load_img_name_base, name_f, name_s);
            run_command(run_cmd, 0);
        }
        else    {
            printf("Unknown load_partition_type! load_partition_type value fat or ext4!\n");
            return  0;
        }
        if((filesize = getenv_ulong("filesize", 16, 0)))    {
            memset(run_cmd, 0x00, sizeof(run_cmd));
            if(!strncmp(raw_write_enable, "true", sizeof("true")))  {
                sprintf(run_cmd, "mmc write %d 0x%08X 0x%08X 0x%08X", 
                        update_device_num, load_img_mem_base, wr_blk_addr, wr_blk_size);
                wr_blk_addr += wr_blk_size;
                run_command(run_cmd, 0);
            }
            else    {
                if(filesize != load_img_size)   {
                    printf("file load real size = 0x%08X(%d), load_img_next_base = 0x%08X\n", 
                        filesize, filesize, load_img_mem_base + load_img_size);
                    load_img_mem_base = load_img_mem_base + load_img_size;
                }
                else                    
                    load_img_mem_base = load_img_mem_base + filesize;

                if(load_img_mem_base >= system_memory_end) {
                    printf("ERROR! Memory Overflow!\n");    return  0;
                }
                    
                sprintf(run_cmd, "%08X", load_img_mem_base);
                setenv("load_img_next_base", run_cmd);
            }

            name_s += 1;
            if(name_s > 'z')    {
                name_s = 'a';   name_f += 1;
            }

            //printf("run_cmd => %s\n", run_cmd); // debug
        }
        else    {
            printf("Load & write end! load_img_next_base = 0x%08X\n", 
                    getenv_ulong("load_img_next_base", 16, 0));
            return  0;
        }
    }
    printf("ERROR! Max file load & stop\n");
    
	return 0;
}

U_BOOT_CMD(
	system_update, 3, 0, do_system_update,
	"system update - system update by FAT32 or EXT4\n",
	"<interface(only support SDMMC boot mode)>\n"
	"	- boot.ini file load from FAT32 on 'interface'\n"
);

const unsigned char DEFAULT_FILE_NAME[] = "boot.ini";
#define DEFAULT_LOAD_ADDR   0x41000000

int do_fat_cfgload(cmd_tbl_t *cmdtp, int flag, int argc, char *argv[])
{
    unsigned long   filesize = 0;
    unsigned long   cfg_load_base_mem, cfg_load_device, cfg_load_partition;
    unsigned char   *fp, *cfg_file_name, *cfg_load_partition_type, cmd[512], skip = 0, first = 1;
    unsigned int    wpos = 0, rpos = 0;
    
    if((cfg_file_name = getenv("cfg_file_name")) == NULL)   
        cfg_file_name = (unsigned char*)&DEFAULT_FILE_NAME[0];
     
    if((cfg_load_base_mem = getenv_ulong("cfg_load_base_mem", 16, 0)) < DEFAULT_LOAD_ADDR)   
        cfg_load_base_mem = DEFAULT_LOAD_ADDR;
    
    fp = (unsigned char *)cfg_load_base_mem;

    if((cfg_load_device = getenv_ulong("cfg_load_device", 16, 0)) > 1)
        cfg_load_device = 1;
        
    cfg_load_partition = getenv_ulong("cfg_load_partition", 16, 0);
    if((cfg_load_partition < 0) || (cfg_load_partition > 4))
        cfg_load_partition = 1;
    
	memset(cmd, 0x00, sizeof(cmd));
    if((cfg_load_partition_type = getenv("cfg_load_partition_type")) == NULL)   {
        sprintf(cmd, "fatload mmc %d:%d 0x%08X %s",
                cfg_load_device,    cfg_load_partition,
                cfg_load_base_mem,  cfg_file_name);
    }
    else    {
        if(!strncmp(cfg_load_partition_type, "ext4", sizeof("ext4"))) {
            sprintf(cmd, "ext4load mmc %d:%d 0x%08X %s",
                    cfg_load_device,    cfg_load_partition,
                    cfg_load_base_mem,  cfg_file_name);
        }
        else    {
            sprintf(cmd, "fatload mmc %d:%d 0x%08X %s",
                    cfg_load_device,    cfg_load_partition,
                    cfg_load_base_mem,  cfg_file_name);
        }
    }

	setenv("filesize", "0");
    printf("%s : cmd = %s\n", __func__, cmd);
    run_command(cmd, 0);
    
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
                        if(!strncmp(cmd, "ODROID4412-UBOOT-CONFIG", sizeof("ODROID4412-UBOOT-CONFIG"))) {
                            printf("Find boot.ini file from FAT Area!!\n");     first = 0;
                        }
                        else    {
                            printf("Find boot.ini file. But This file is not odroid4412 config file!\n");
                            return  0;
                        }
                    }
                    else    {
                        printf("boot.ini command = %s\n", cmd);

                        rpos = 0;
                        while((cmd[rpos] == ' ') && (cmd[rpos] != 0x00))     rpos++;

                        if(!strncmp(&cmd[rpos], "setenv", 6))  {
                            int             ncnt;
                            unsigned char   env_name[512], env_value[512];
                            
                            ncnt = 0;   rpos = 6;
                            memset(env_name, 0x00, sizeof(env_name));
                            
                            while(cmd[rpos++] != 0x00)    {
                                if(cmd[rpos] != ' ')
                                    env_name[ncnt++] = cmd[rpos];
                                else
                                    break;
                            }

                            ncnt = 0;                            
                            memset(env_value, 0x00, sizeof(env_value));
                            
                            while(cmd[rpos++] != 0x00)    {
                                if(cmd[rpos] != ' ')    {
                                    while(cmd[rpos] != 0x00)   {
                                        if(cmd[rpos] == '\'' || cmd[rpos] == '"')   rpos++;
                                        else    
                                            env_value[ncnt++] = cmd[rpos++];
                                    }
                                }
                            }
                            
                            // sizeof("if") ---> return value = 3 ???
                            // if script env check
                            if( !strncmp(&env_value[0], "if "   , sizeof("if"))     ||
                                !strncmp(&env_value[0], "while ", sizeof("while"))  ||
                                !strncmp(&env_value[0], "until ", sizeof("until"))  ||
                                !strncmp(&env_value[0], "for "  , sizeof("for"))    )   {

                                setenv(env_name, env_value);
                                #if 0   // for DEBUG
                                    printf("env_name = %s, env_value = %s\n", env_name, env_value);
                                #endif
                            }
                            else    {
                                unsigned char   parse_value[512];
                                
                                memset(parse_value, 0x00, sizeof(parse_value));
                                
                                // process_macros function in common/main.c
                                process_macros (env_value, parse_value);
                                
                                setenv(env_name, parse_value);
                                
                                #if 0
                                    printf("parse_value = %s\n", parse_value);
                                #endif
                            }
                        }
                        else
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

// ALIVE LED Port (GPC1.0)
#include <common.h>
#include <asm/arch/cpu.h>
#include <asm/arch/gpio.h>

#define GPIO_GPC1_BASE      0x11400080
#define GPC1CON             *(volatile unsigned long *)(GPIO_GPC1_BASE + 0x00)
#define GPC1DAT             *(volatile unsigned long *)(GPIO_GPC1_BASE + 0x04)

#define GOTGCTL             *(volatile unsigned long *)(0x12480000)

int do_wait_usb_trigger(cmd_tbl_t *cmdtp, int flag, int argc, char *argv[])
{
    if (INF_REG3_REG == BOOT_MMCSD) {
    	char AlreadyTrigger = 0;

        // GPC1.0 Output Setup
        GPC1CON &= 0xFFFFFFF0;   GPC1CON |= 0x00000001;
    
       	writel(readl(USB_PHY_CONTROL)|(1<<0), USB_PHY_CONTROL);	/*USB PHY0 Enable */ // c110
    
      	s3c_usb_init_phy(); s3c_usb_core_soft_reset();  s3c_usb_set_soft_disconnect();
      	
        mdelay(500);
      	if(GOTGCTL == 0x000D0000)   {
      	    AlreadyTrigger = 1;
            // USB Connect Check for emmc recovery
    		printf("disconnect usb cable & reconnect usb cable.. \n");
      	}
      	else    {
            // USB Connect Check for emmc recovery
    		printf("Insert eMMC Module before usb connect.... \n");
        }
    	
        while(AlreadyTrigger || (GOTGCTL != 0x000D0000))    {
            if(AlreadyTrigger && (GOTGCTL != 0x000D0000))   {
        		printf("Insert eMMC Module before usb connect.... \n");
                AlreadyTrigger = 0;
            }
            GPC1DAT = GPC1DAT & 0x01 ? (GPC1DAT & (~0x01)) : (GPC1DAT | 0x01);
            mdelay(500);
        }
        GPC1DAT &= (~0x01);     mdelay(500);
        
    	printf("Trigger Detected... read boot.scr form SDMMC & boot \n");
    }
    else
        printf("Not support this boot mode!\n");

	return  0;
}

U_BOOT_CMD(
	wait_usb_trigger, 1, 0, do_wait_usb_trigger,
	"wait_usb_trigger - wait usb trigger detect for recovery\n",
	"<interface(only support SDMMC boot mode)>\n"
	"	- boot.ini file load from FAT32 on 'interface'\n"
);

#ifdef CONFIG_FAT_WRITE
static int do_fat_fswrite(cmd_tbl_t *cmdtp, int flag,
		int argc, char * const argv[])
{
	long size;
	unsigned long addr;
	unsigned long count;
	block_dev_desc_t *dev_desc = NULL;
	disk_partition_t info;
	int dev = 0;
	int part = 1;

	if (argc < 5)
		return cmd_usage(cmdtp);

	part = get_device_and_partition(argv[1], argv[2], &dev_desc, &info, 1);
	if (part < 0)
		return 1;

	dev = dev_desc->dev;

	if (fat_set_blk_dev(dev_desc, &info) != 0) {
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
