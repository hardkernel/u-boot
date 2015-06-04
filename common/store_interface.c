#include <config.h>
#include <common.h>
#include <command.h>
#include <watchdog.h>
#include <malloc.h>
#include <nand.h>
#include <asm/arch/nand.h>
#include <linux/ctype.h>
#include <asm/byteorder.h>
#include <div64.h>
#include <linux/err.h>
#include<partition_table.h>

#define MsgP(fmt...)   printf("[store]"fmt)

#define NAND_INIT_FAILED 20
#define STORE_BOOT_NORMAL					0
#define STORE_BOOT_UPGRATE					1
#define STORE_BOOT_ERASE_PROTECT_CACHE       	          2
#define STORE_BOOT_ERASE_ALL   				          3
#define STORE_BOOT_SCRUB_ALL				          4

#define _SPI_FLASH_ERASE_SZ      (CONFIG_ENV_IN_SPI_OFFSET + CONFIG_ENV_SIZE)
#define CONFIG_ENV_IN_SPI_OFFSET 0
//Ignore mbr since mmc driver already handled
//#define MMC_UBOOT_CLEAR_MBR
#define MMC_BOOT_PARTITION_SUPPORT

#ifdef MMC_UBOOT_CLEAR_MBR
static char _mbrFlag[4] ;
#endif

//extern void get_device_boot_flag(void);
static int _info_disprotect_back_before_mmcinfo1 = 0;//mmcinfo 1 will clear info_disprotect before run_command("mmc erase 1")
extern int info_disprotect;
static inline int isstring(char *p)
{
	char *endptr = p;
	while (*endptr != '\0') {
		if (!(((*endptr >= '0') && (*endptr <= '9'))
			|| ((*endptr >= 'a') && (*endptr <= 'f'))
			|| ((*endptr >= 'A') && (*endptr <= 'F'))
			|| (*endptr == 'x') || (*endptr == 'X')))
			return 1;
		endptr++;
	}

	return 0;
}

static inline int str2long(char *p, ulong *num)
{
	char *endptr;
	*num = simple_strtoul(p, &endptr, 16);
	return (*p != '\0' && *endptr == '\0') ? 1 : 0;
}
static inline int str2longlong(char *p, unsigned long long *num)
{
	char *endptr;

	*num = simple_strtoull(p, &endptr, 16);
	if (*endptr != '\0')
	{
	    switch (*endptr)
	    {
	        case 'g':
	        case 'G':
	            *num<<=10;
	        case 'm':
	        case 'M':
	            *num<<=10;
	        case 'k':
	        case 'K':
	            *num<<=10;
	            endptr++;
	            break;
	    }
	}

	return (*p != '\0' && *endptr == '\0') ? 1 : 0;
}

static int get_off_size(int argc, char *argv[],  loff_t *off, loff_t *size)
{
        if (argc >= 1) {
            if (!(str2longlong(argv[0], (unsigned long long*)off))) {
			store_msg("'%s' is not a number\n", argv[0]);
				return -1;
			}
		} else {
				*off = 0;
				*size = 0;
		}

        if (argc >= 2) {
                if (!(str2longlong(argv[1], (unsigned long long *)size))) {
						store_msg("'%s' is not a number\n", argv[1]);
						return -1;
				}
		}else{
				*size = 0;
		}

		store_dbg("offset 0x%llx, size 0x%llx", *off, *size);

		return 0;
}

int do_store(cmd_tbl_t * cmdtp, int flag, int argc, char * const argv[])
{
		int i, init_flag=0, ret = 0;
		uint64_t addr;
		loff_t off=0, size=0;
		char *cmd, *s, *area;
		char	str[128];
		//unsigned char *tmp_buf = NULL;

        if (argc < 2)
				goto usage;

		cmd = argv[1];

        if (strcmp(cmd, "erase") == 0) {

				area = argv[2];

                if (strcmp(area, "boot") == 0) {
                        if (device_boot_flag == NAND_BOOT_FLAG) {
								off =  simple_strtoul(argv[3], NULL, 16);
								size =  simple_strtoul(argv[4], NULL, 16);
								store_dbg("NAND BOOT,erase uboot : %s %d  off =%llx ,size=%llx",__func__,__LINE__, off, size);

								ret = run_command("amlnf  deverase boot 0",0);
                                if (ret != 0) {
										store_msg("nand cmd %s failed ",cmd);
										return -1;
								}
								return ret;
						}else if((device_boot_flag==SPI_EMMC_FLAG)||(device_boot_flag==SPI_NAND_FLAG)){
								off =  simple_strtoul(argv[3], NULL, 16);
								size =  simple_strtoul(argv[4], NULL, 16);

								store_dbg("SPI BOOT,erase uboot :  %s %d  off =%llx ,size=%llx",__func__,__LINE__,off,size);

								ret = run_command("sf probe 2",0);
                                if (ret != 0) {
										store_msg("nand cmd %s failed",cmd);
										return -1;
								}
                                sprintf(str, "sf erase  0 0x%x", CONFIG_ENV_IN_SPI_OFFSET);//store erase boot shoould NOT erase ENV in flash!
                                ret = run_command(str,0);
                                if (ret != 0) {
                                        store_msg("nand cmd %s failed",cmd);
                                        return -1;
                                }
                                return ret;
                        }else if(device_boot_flag == EMMC_BOOT_FLAG){
                                off =  simple_strtoul(argv[3], NULL, 16);
                                size =  simple_strtoul(argv[4], NULL, 16);

                                store_dbg("MMC BOOT,erase uboot :  %s %d  off =%llx ,size=%llx",__func__,__LINE__,off,size);

                                sprintf(str, "amlmmc  erase bootloader");
                                ret = run_command(str, 0);
                                if (ret != 0) {
                                        store_msg("amlmmc cmd %s failed",cmd);
                                        return -1;
                                }

#ifdef MMC_BOOT_PARTITION_SUPPORT

                                for (i=0; i<2; i++) {
                                        //switch to boot partition here
                                        sprintf(str, "amlmmc switch 1 boot%d", i);
                                        store_dbg("command: %s\n", str);
                                        ret = run_command(str, 0);
                                        if (ret == -1) {
                                                //store_msg("mmc cmd %s failed \n",cmd);
                                                return 0;
                                        }
                                        else if(ret != 0){
                                                store_msg("amlmmc cmd %s failed",cmd);
                                                //return -1;
                                                goto E_SWITCH_BACK;
                                        }

                                        //erase boot partition
                                        sprintf(str, "amlmmc erase bootloader");
                                        ret = run_command(str, 0);
                                        if (ret != 0) {
                                                store_msg("amlmmc cmd %s failed",cmd);
                                                //return -1;
                                                goto E_SWITCH_BACK;
                                        }
                                }

E_SWITCH_BACK:
                                //switch back to urs partition
                                sprintf(str, "amlmmc switch 1 user");
                                store_dbg("command: %s\n", str);
                                ret = run_command(str, 0);
                                if (ret != 0) {
                                        store_msg("amlmmc cmd %s failed \n",cmd);
                                        return -1;
                                }

#endif

                                return ret;
                        }else{
                                store_dbg("CARD BOOT,erase uboot :  %s %d  off =%llx ,size=%llx",__func__,__LINE__,off,size);
                                return 0;
                        }
                }
                else if(strcmp(area, "data") == 0){

                        if (device_boot_flag == NAND_BOOT_FLAG) {
                                store_dbg("NAND BOOT,erase data : %s %d  off =%llx ,size=%llx",__func__,__LINE__, off, size);

                                ret = run_command("amlnf  deverase data 0",0);
                                if (ret != 0) {
                                        store_msg("nand cmd %s failed ",cmd);
                                        return -1;
                                }

                                ret = run_command("amlnf  deverase code 0",0);
                                if (ret != 0) {
                                        store_msg("nand cmd %s failed ",cmd);
                                        return -1;
                                }
                                ret = run_command("amlnf  deverase cache 0",0);
                                if (ret != 0) {
                                        store_msg("nand cmd %s failed ",cmd);
                                        return -1;
                                }
                                return ret;
                        }
                        else if(device_boot_flag == SPI_NAND_FLAG){
                                store_dbg("spi+nand , %s %d ",__func__,__LINE__);
                                ret = run_command("amlnf  deverase data 0",0);
                                if (ret != 0) {
                                        store_msg("nand cmd %s failed ",cmd);
                                        return -1;
                                }

                                ret = run_command("amlnf  deverase code 0",0);
                                if (ret != 0) {
                                        store_msg("nand cmd %s failed ",cmd);
                                        return -1;
                                }
                                ret = run_command("amlnf  deverase cache 0",0);
                                if (ret != 0) {
                                        store_msg("nand cmd %s failed ",cmd);
                                        return -1;
                                }
                                return ret;
                        }
                        else if(device_boot_flag == SPI_EMMC_FLAG){
                                store_dbg("spi+mmc , %s %d ",__func__,__LINE__);
                                off = size =0;
                                ret = run_command("mmc  erase  1",0); // whole
                                if (ret != 0) {
                                        store_msg("mmc cmd %s failed ",cmd);
                                        return -1;
                                }

                                return ret;
                        }
                        else if(device_boot_flag==EMMC_BOOT_FLAG){
                                store_dbg("MMC BOOT,erase data : %s %d  off =%llx ,size=%llx",__func__,__LINE__, off, size);
                                off = size =0;
                                ret = run_command("amlmmc erase 1",0); //whole
                                if (ret != 0) {
                                        store_msg("amlmmc cmd %s failed ",cmd);
                                        return -1;
                                }
                                return ret;
                        }else{
                                store_dbg("CARD BOOT,erase data : %s %d  off =%llx ,size=%llx",__func__,__LINE__, off, size);
                                return 0;
                        }
                }
                else {
                        goto usage;
                }

        }
        else if(strcmp(cmd, "read") == 0){
                if (argc < 6)
                        goto usage;

                s = argv[2];
                addr = (ulong)simple_strtoul(argv[3], NULL, 16);
                if (get_off_size(argc - 4, (char **)(argv + 4), &off, &size) != 0)
                        goto usage;

                store_dbg("addr = %llx off= 0x%llx  size=0x%llx",addr,off,size);
                if ((device_boot_flag == NAND_BOOT_FLAG)) {
                        sprintf(str, "amlnf  read_byte %s 0x%llx  0x%llx  0x%llx",s, addr, off, size);
                        store_dbg("command:	%s", str);
                        ret = run_command(str, 0);
                        if (ret != 0) {
                                store_msg("nand cmd %s failed ",cmd);
                                return -1;
                        }
                        return ret;
                }
                else if(device_boot_flag == SPI_NAND_FLAG){
                        sprintf(str, "amlnf  read_byte %s 0x%llx  0x%llx  0x%llx", s, addr, off, size);
                        store_dbg("command:	%s\n", str);
                        ret = run_command(str, 0);
                        if (ret != 0) {
                                store_msg("nand cmd %s failed \n",cmd);
                                return -1;
                        }
                        return ret;
                }
                else if(device_boot_flag == SPI_EMMC_FLAG){
                        store_dbg("spi+mmc , %s %d ",__func__,__LINE__);
                        sprintf(str, "amlmmc  read %s 0x%llx  0x%llx  0x%llx", s, addr, off, size);
                        store_dbg("command:	%s\n", str);
                        ret = run_command(str, 0);
                        if (ret != 0) {
                                store_msg("amlmmc cmd %s failed \n",cmd);
                                return -1;
                        }
                        return ret;
                }
                else if(device_boot_flag==EMMC_BOOT_FLAG) {
                        store_dbg("MMC BOOT, %s %d \n",__func__,__LINE__);
                        sprintf(str, "amlmmc  read %s 0x%llx  0x%llx  0x%llx", s, addr, off, size);
                        store_dbg("command:	%s\n", str);
                        ret = run_command(str, 0);
                        if (ret != 0) {
                                store_msg("amlmmc cmd %s failed \n",cmd);
                                return -1;
                        }
                        return ret;
                }else{
                        store_dbg("CARD BOOT, %s %d ",__func__,__LINE__);

                        return 0;
                }
        }
        else if(strcmp(cmd, "write") == 0){
                if (argc < 6)
                        goto usage;
                s = argv[2];
                addr = (ulong)simple_strtoul(argv[3], NULL, 16);
                if (get_off_size(argc - 4, (char **)(argv + 4), &off, &size) != 0)
                        goto usage;
                if (device_boot_flag == NAND_BOOT_FLAG) {

                        sprintf(str, "amlnf  write_byte %s 0x%llx  0x%llx  0x%llx", s, addr, off, size);
                        store_dbg("command:	%s", str);
                        ret = run_command(str, 0);
                        if (ret != 0) {
                                store_msg("nand cmd %s failed ",cmd);
                                return -1;
                        }
                        return ret;
                }
                else if(device_boot_flag == SPI_NAND_FLAG){
                        store_dbg("spi+nand , %s %d ",__func__,__LINE__);
                        sprintf(str, "amlnf  write_byte %s 0x%llx  0x%llx  0x%llx", s, addr, off, size);
                        store_dbg("command:	%s", str);
                        ret = run_command(str, 0);
                        if (ret != 0) {
                                store_msg("nand cmd %s failed \n",cmd);
                                return -1;
                        }
                        return ret;
                }
                else if(device_boot_flag == SPI_EMMC_FLAG){
                        store_dbg("spi+mmc , %s %d ",__func__,__LINE__);
                        sprintf(str, "amlmmc  write %s 0x%llx  0x%llx  0x%llx", s, addr, off, size);
                        store_dbg("command: %s\n", str);
                        ret = run_command(str, 0);
                        if (ret != 0) {
                                store_msg("amlmmc cmd %s failed \n",cmd);
                                return -1;
                        }
                        return ret;
                }
                else if(device_boot_flag==EMMC_BOOT_FLAG){
                        store_dbg("MMC BOOT, %s %d \n",__func__,__LINE__);
                        sprintf(str, "amlmmc  write %s 0x%llx  0x%llx  0x%llx", s, addr, off, size);
                        store_dbg("command: %s\n", str);
                        ret = run_command(str, 0);
                        if (ret != 0) {
                                store_msg("amlmmc cmd %s failed \n",cmd);
                                return -1;
                        }
                        return ret;
                }else{
                        store_dbg("CARD BOOT, %s %d ",__func__,__LINE__);
                        return 0;
                }
                return ret;
        }
        else if(strcmp(cmd, "rom_write") == 0){
                if (argc < 5)
                        goto usage;
                addr = (ulong)simple_strtoul(argv[2], NULL, 16);
                if (get_off_size(argc - 3, (char **)(argv + 3), &off, &size) != 0)
                        goto usage;
                if (device_boot_flag == NAND_BOOT_FLAG) {
                        sprintf(str, "amlnf  rom_write  0x%llx  0x%llx  0x%llx",  addr, off, size);
                        store_dbg("command:	%s", str);
                        ret = run_command(str, 0);
                        if (ret != 0) {
                                store_msg("nand cmd %s failed",cmd);
                                return -1;
                        }
                        return ret;
                }
                else if ((device_boot_flag==SPI_EMMC_FLAG)||(device_boot_flag==SPI_NAND_FLAG)){
                        ret = run_command("sf  probe 2",0);
                        if (ret != 0) {
                                store_msg("nand cmd %s failed",cmd);
                                return -1;
                        }
                        sprintf(str, "sf  erase  0x%llx  0x%llx ", off, size);
                        ret = run_command(str, 0);
                        if (ret != 0) {
                                store_msg("nand cmd %s failed",cmd);
                                return -1;
                        }
                        sprintf(str, "sf  write 0x%llx  0x%llx  0x%llx ",addr, off, size);
                        store_dbg("command:	%s", str);
                        ret = run_command(str, 0);
                        if (ret != 0) {
                                store_msg("nand cmd %s failed",cmd);
                                return -1;
                        }
                        return ret;
                }
                else if(device_boot_flag==EMMC_BOOT_FLAG){
                        store_dbg("MMC BOOT, %s %d \n",__func__,__LINE__);

#ifndef CONFIG_AML_SECU_BOOT_V2
#ifdef MMC_UBOOT_CLEAR_MBR
                        //modify the 55 AA info for emmc uboot
                        unsigned char *tmp_buf= (unsigned char *)addr;
                        _mbrFlag[0] = tmp_buf[510];
                        _mbrFlag[1] = tmp_buf[511];
                        tmp_buf[510]=0;
                        tmp_buf[511]=0;
#endif
#endif// #if defined(CONFIG_AML_SECU_BOOT_V2)
                        sprintf(str, "amlmmc  write bootloader 0x%llx  0x%llx  0x%llx", addr, off, size);
                        store_dbg("command: %s\n", str);
                        ret = run_command(str, 0);
                        if (ret != 0) {
                                store_msg("amlmmc cmd %s failed \n",cmd);
                                return -1;
                        }
#ifdef MMC_BOOT_PARTITION_SUPPORT

                        for (i=0; i<2; i++) {
                                //switch to boot partition here
                                sprintf(str, "amlmmc switch 1 boot%d", i);
                                store_dbg("command: %s\n", str);
                                ret = run_command(str, 0);
                                if (ret == -1) {
                                        //store_msg("mmc cmd %s failed \n",cmd);
                                        ret = 0;
                                        return ret;
                                }
                                else if(ret != 0){
                                        store_msg("amlmmc cmd %s failed",cmd);
                                        //return -1;
                                        goto W_SWITCH_BACK;
                                }

                                //write uboot to boot partition
                                sprintf(str, "amlmmc  write bootloader 0x%llx  0x%llx  0x%llx", addr, off, size);
                                store_dbg("command: %s\n", str);
                                ret = run_command(str, 0);
                                if (ret != 0) {
                                        store_msg("amlmmc cmd %s failed \n",cmd);
                                        //return -1;
                                        goto W_SWITCH_BACK;
                                }
                        }

W_SWITCH_BACK:
                        //switch back to urs partition
                        sprintf(str, "amlmmc switch 1 user");
                        store_dbg("command: %s\n", str);
                        ret = run_command(str, 0);
                        if (ret != 0) {
                                store_msg("amlmmc cmd %s failed \n",cmd);
                                return -1;
                        }

#endif
                        return ret;
                }else{
                        store_dbg("CARD BOOT, %s %d",__func__,__LINE__);
                        return 0;
                }

        }
        else if(strcmp(cmd, "rom_read") == 0){
                if (argc < 5)
                        goto usage;
                addr = (ulong)simple_strtoul(argv[2], NULL, 16);
                if (get_off_size(argc - 3, (char **)(argv + 3), &off, &size) != 0)
                        goto usage;
                if (device_boot_flag == NAND_BOOT_FLAG) {
                        sprintf(str, "amlnf  rom_read  0x%llx  0x%llx  0x%llx",  addr, off, size);
                        store_dbg("command:	%s", str);
                        ret = run_command(str, 0);
                        if (ret != 0) {
                                store_msg("nand cmd %s failed",cmd);
                                return -1;
                        }
                        return ret;
                }else if ((device_boot_flag==SPI_EMMC_FLAG)||(device_boot_flag==SPI_NAND_FLAG)){
                        ret = run_command("sf  probe 2",0);
                        if (ret != 0) {
                                return -1;
                        }
                        sprintf(str, "sf  read 0x%llx  0x%llx  0x%llx ",addr, off, size);
                        store_dbg("command:	%s", str);
                        ret = run_command(str, 0);
                        if (ret != 0) {
                                store_msg("nand cmd %s failed",cmd);
                                return -1;
                        }
                        return ret;
                }else if (device_boot_flag==EMMC_BOOT_FLAG){
                        store_dbg("MMC BOOT, %s %d \n",__func__,__LINE__);
                        sprintf(str, "amlmmc  read bootloader 0x%llx  0x%llx  0x%llx", addr, off, size);
                        store_dbg("command: %s\n", str);
                        //tmp_buf= (unsigned char *)addr;
                        ret = run_command(str, 0);
                        if (ret != 0) {
                                store_msg("amlmmc cmd %s failed \n",cmd);
                                return -1;
                        }

#ifdef MMC_BOOT_PARTITION_SUPPORT

                        for (i=0; i<2; i++) {
                                //switch to boot partition here
                                sprintf(str, "amlmmc switch 1 boot%d", i);
                                store_dbg("command: %s\n", str);
                                ret = run_command(str, 0);
                                if (ret == -1) {
                                        //store_msg("mmc cmd %s failed \n",cmd);
                                        return 0;
                                }
                                else if(ret != 0){
                                        store_msg("amlmmc cmd %s failed",cmd);
                                        goto R_SWITCH_BACK;
                                        //return -1;
                                }

                                //write uboot to boot partition
                                sprintf(str, "amlmmc  read bootloader 0x%llx  0x%llx  0x%llx", addr, off, size);
                                store_dbg("command: %s\n", str);
                                ret = run_command(str, 0);
                                if (ret != 0) {
                                        store_msg("amlmmc cmd %s failed \n",cmd);
                                        //return -1;
                                        goto R_SWITCH_BACK;
                                }
                        }

R_SWITCH_BACK:
                        //switch back to urs partition
                        sprintf(str, "amlmmc switch 1 user");
                        store_dbg("command: %s\n", str);
                        ret = run_command(str, 0);
                        if (ret != 0) {
                                store_msg("amlmmc cmd %s failed \n",cmd);
                                return -1;
                        }

#endif
#ifndef CONFIG_AML_SECU_BOOT_V2
#ifdef MMC_UBOOT_CLEAR_MBR
                        unsigned char *tmp_buf= (unsigned char *)addr;
                        tmp_buf[510]= _mbrFlag[0];
                        tmp_buf[511]= _mbrFlag[1];
#endif
#endif// #ifndef CONFIG_AML_SECU_BOOT_V2
                        return ret;
                }else{
                        store_dbg("CARD BOOT, %s %d ",__func__,__LINE__);
                        return 0;
                }

        }
        else if (strcmp(cmd, "rom_protect") == 0){
                if (argc < 3)
                        goto usage;

                area = argv[2];
                if (device_boot_flag == NAND_BOOT_FLAG) {
                        sprintf(str, "amlnf  rom_protect  %s", area);
                        store_dbg("command:	%s", str);
                        ret = run_command(str, 0);
                        if (ret != 0) {
                                store_msg("nand cmd %s failed",cmd);
                                return -1;
                        }
                        return ret;
                }
        }
        else if (strcmp(cmd, "scrub") == 0){
                off = (ulong)simple_strtoul(argv[2], NULL, 16);
                sprintf(str, "amlnf  scrub %d", (int)off);
                if (device_boot_flag == NAND_BOOT_FLAG) {
                        ret = run_command(str, 0);
                        if (ret != 0) {
                                store_msg("nand cmd %s failed",cmd);
                                return -1;
                        }
                }
                else if(device_boot_flag == SPI_NAND_FLAG){
                        store_dbg("spi+nand , %s %d ",__func__,__LINE__);
                        ret = run_command(str, 0);
                        if (ret != 0) {
                                store_msg("nand cmd %s failed",cmd);
                                return -1;
                        }
                        ret = run_command("sf probe 2", 0);
                        if (ret != 0) {
                                store_msg("nand cmd %s failed",cmd);
                                return -1;
                        }
                        sprintf(str, "sf erase  0 0x%x", _SPI_FLASH_ERASE_SZ);
                        ret = run_command(str,0);
                        if (ret != 0) {
                                store_msg("nand cmd %s failed",cmd);
                                return -1;
                        }
                        return ret;
                }
                else if(device_boot_flag == SPI_EMMC_FLAG){
                        store_dbg("spi+mmc , %s %d ",__func__,__LINE__);
                        ret = run_command("amlmmc erase whole",0);
                        if (ret != 0) {
                                store_msg("amlmmc cmd %s failed \n",cmd);
                                return -1;
                        }
                        return ret;
                }
                else if(device_boot_flag==EMMC_BOOT_FLAG){
                        store_dbg("MMC BOOT, %s %d \n",__func__,__LINE__);
                        device_boot_flag = EMMC_BOOT_FLAG;
                        run_command("mmc dev 1", 0);
                        ret = run_command("mmcinfo", 0);
                        if (ret != 0) {
                                store_msg("amlmmc cmd %s failed \n",cmd);
                                return -1;
                        }
                        if (_info_disprotect_back_before_mmcinfo1 & DISPROTECT_KEY) {
                                MsgP("mmc key\n");
                                run_command("mmc key", 0);
                        }
                        MsgP("amlmmc erase 1");
                        ret = run_command("amlmmc erase 1", 0);
                }
                return ret;
        }
        else if(strcmp(cmd, "init") == 0){

                init_flag = (argc > 2) ? (int)simple_strtoul(argv[2], NULL, 16) : 0;
                store_dbg("init_flag %d",init_flag);

                if (device_boot_flag == -1) {
                        //get_device_boot_flag();
                }
                if (device_boot_flag == NAND_BOOT_FLAG)
                {
                        if ((init_flag >=STORE_BOOT_ERASE_PROTECT_CACHE) && (init_flag <=STORE_BOOT_SCRUB_ALL)) {
                                sprintf(str, "amlnf  init  %d ",init_flag);
                                run_command(str, 0);
                        }

                        sprintf(str, "amlnf  init  %d ",1);
                        printf("command:	%s -> %d\n", str, init_flag);
                        device_boot_flag = NAND_BOOT_FLAG;
                        ret = run_command(str, 0);
                        if (ret != 0) {
#if	0
                                if ((ret == NAND_INIT_FAILED) && (init_flag == STORE_BOOT_ERASE_ALL)) {
                                        sprintf(str, "amlnf  init  %d ",4);
                                        ret = run_command(str, 0);
                                }
                                if (ret) {
                                        store_msg("nand cmd %s failed,ret=%d ",cmd,ret);
                                        return -1;
                                }
                                return 0;
#else
                                return -1;
#endif
                        }
                        return ret;
                }
                else if((device_boot_flag==SPI_EMMC_FLAG)||(device_boot_flag==SPI_NAND_FLAG))
                {
                        /*
                           if (device_boot_flag == -1)
                           {
                           ret = run_command("sf probe 2", 0);
                           if (ret) {
                           store_msg(" cmd %s failed \n",cmd);
                           return -1;
                           }
                           if ((init_flag > STORE_BOOT_ERASE_PROTECT_CACHE) && (init_flag <= STORE_BOOT_SCRUB_ALL)) {
                           sprintf(str, "sf erase 0 0x%x", _SPI_FLASH_ERASE_SZ);
                           ret = run_command(str,0);
                           }
                           sprintf(str, "amlnf  init  %d ",init_flag);
                           store_dbg("command:	%s", str);
                           ret = run_command(str, 0);
                           if (ret < 0) //fail to init NAND flash
                           {
                           store_msg("nand cmd %s failed \n",cmd);
                           device_boot_flag = SPI_EMMC_FLAG;
                           store_dbg("spi+mmc , %s %d ",__func__,__LINE__);
                           ret = run_command("mmcinfo 1", 0);
                           if (ret != 0) {
                           store_msg("mmc cmd %s failed \n",cmd);
                           return -2;
                           }
                           if (init_flag == STORE_BOOT_ERASE_PROTECT_CACHE) { // OTA upgrade protect cache
                           store_msg("mmc erase non_cache \n");
                           ret = run_command("mmc erase non_cache", 0);
                           }else if(init_flag >= STORE_BOOT_ERASE_ALL){ // erase all except  reserved area
                           if (_info_disprotect_back_before_mmcinfo1 & DISPROTECT_KEY) {
                           MsgP("mmc key;\n");
                           run_command("mmc key", 0);
                           }
                           MsgP("mmc erase 1 \n");
                           ret = run_command("mmc erase 1", 0);
                           }
                           return 0;
                           }
                           else if((ret == NAND_INIT_FAILED)&&(init_flag == STORE_BOOT_ERASE_ALL)){
                           sprintf(str, "amlnf  init  %d ",4);
                           ret = run_command(str, 0);
                           }
                           device_boot_flag = SPI_NAND_FLAG;
                           return 0;
                           }
                           */
                        if (device_boot_flag == SPI_NAND_FLAG) {
                                store_dbg("spi+nand , %s %d ",__func__,__LINE__);

                                if ((init_flag >=STORE_BOOT_ERASE_PROTECT_CACHE) && (init_flag <=STORE_BOOT_SCRUB_ALL)) {
                                        sprintf(str, "amlnf  init  %d ",init_flag);
                                        run_command(str, 0);
                                }
                                sprintf(str, "amlnf  init  %d ",1);
                                store_dbg("command:	%s", str);
                                ret = run_command(str, 0);
#if	0
                                if ((ret == NAND_INIT_FAILED) && (init_flag == STORE_BOOT_ERASE_ALL)) {
                                        sprintf(str, "amlnf  init  %d ",4);
                                        ret = run_command(str, 0);
                                }
#else
                                if (ret == NAND_INIT_FAILED) {
                                        return -1;
                                }
#endif
                                if ((init_flag > STORE_BOOT_ERASE_PROTECT_CACHE) && (init_flag <= STORE_BOOT_SCRUB_ALL)) {
                                        ret = run_command("sf probe 2", 0);
                                        sprintf(str, "sf erase  0 0x%x", _SPI_FLASH_ERASE_SZ);
                                        ret = run_command(str,0);
                                }
                        }
                        if (device_boot_flag == SPI_EMMC_FLAG) {
                                store_dbg("spi+mmc , %s %d ",__func__,__LINE__);
                                ret = run_command("mmcinfo 1", 0);

                                if (init_flag == STORE_BOOT_ERASE_PROTECT_CACHE) { // OTA upgrade protect cache
                                        store_msg("amlmmc erase non_cache \n");
                                        ret = run_command("amlmmc erase non_cache", 0);
                                }else if(init_flag == STORE_BOOT_ERASE_ALL){ // erase all except  reserved area
                                        if (_info_disprotect_back_before_mmcinfo1 & DISPROTECT_KEY) {
                                                run_command("mmc key", 0);
                                        }
                                        MsgP("amlmmc erase 1 \n");
                                        ret = run_command("amlmmc erase 1", 0);
                                }
                                if ((init_flag > STORE_BOOT_ERASE_PROTECT_CACHE) && (init_flag <= STORE_BOOT_SCRUB_ALL)) {
                                        ret = run_command("sf probe 2", 0);
                                        sprintf(str, "sf erase  0 0x%x", _SPI_FLASH_ERASE_SZ);
                                        ret = run_command(str,0);
                                }
                        }

                        if (ret != 0) {
                                store_msg("cmd %s failed \n",cmd);
                                return -1;
                        }

                        return ret;
                }
                else if(device_boot_flag == EMMC_BOOT_FLAG){
                        store_dbg("MMC BOOT, %s %d \n",__func__,__LINE__);
                        device_boot_flag = EMMC_BOOT_FLAG;
                        run_command("mmc dev 1",0);
                        ret = run_command("mmcinfo", 0);
                        if (ret != 0) {
                                store_msg("amlmmc cmd %s failed \n",cmd);
                                return -1;
                        }
                        if (init_flag == STORE_BOOT_ERASE_PROTECT_CACHE) { // OTA upgrade protect cache
                                ret = run_command("amlmmc erase non_cache", 0);
                        }else if(init_flag >= STORE_BOOT_ERASE_ALL){ // erase all except  reserved area
                                if (_info_disprotect_back_before_mmcinfo1 & DISPROTECT_KEY) {
                                        MsgP("amlmmc key\n");
                                        run_command("amlmmc key", 0);
                                }
                                MsgP("amlmmc erase 1");
                                ret = run_command("amlmmc erase 1", 0);
                        }

                        return ret;
                }else{
                        store_dbg("CARD BOOT, %s %d",__func__,__LINE__);
                        return 0;
                }
        }
        else if(strcmp(cmd, "size") == 0){

                if (argc < 4)
                        goto usage;

                s = argv[2];
                addr = (ulong)simple_strtoul(argv[3], NULL, 16);
                if (device_boot_flag == NAND_BOOT_FLAG) {
                        sprintf(str, "amlnf  size  %s %llx",s,addr);
                        store_dbg("command:	%s", str);
                        ret = run_command(str, 0);
                        if (ret != 0) {
                                store_msg("nand cmd %s failed",cmd);
                                return -1;
                        }
                        return ret;
                }
                else if(device_boot_flag == SPI_NAND_FLAG){
                        sprintf(str, "amlnf  size  %s %llx",s,addr);
                        store_dbg("command:	%s", str);
                        ret = run_command(str, 0);
                        if (ret != 0) {
                                store_msg("nand cmd %s failed",cmd);
                                return -1;
                        }
                        return ret;
                }
                else if(device_boot_flag == SPI_EMMC_FLAG){
                        store_dbg("MMC , %s %d ",__func__,__LINE__);
                        sprintf(str, "amlmmc  size  %s %llx",s,addr);
                        store_dbg("command:	%s", str);
                        ret = run_command(str, 0);
                        if (ret != 0) {
                                store_msg("amlmmc cmd %s failed",cmd);
                                return -1;
                        }
                        return ret;
                }
                else if(device_boot_flag==EMMC_BOOT_FLAG){
                        store_dbg("MMC , %s %d ",__func__,__LINE__);
                        sprintf(str, "amlmmc  size  %s %llx",s,addr);
                        store_dbg("command:	%s", str);
                        ret = run_command(str, 0);
                        if (ret != 0) {
                                store_msg("amlmmc cmd %s failed",cmd);
                                return -1;
                        }
                        return ret;
                }
                else if(device_boot_flag==CARD_BOOT_FLAG){
                        store_dbg("CARD BOOT , %s %d ",__func__,__LINE__);
                        return 0;
                }
        }
        else if(strcmp(cmd, "disprotect") == 0){
                area = argv[2];
                if (strcmp(area, "key") == 0) {
                        MsgP("disprotect key\n");
                        info_disprotect |= DISPROTECT_KEY;
                        _info_disprotect_back_before_mmcinfo1 |= DISPROTECT_KEY;
                }
                if (strcmp(area, "secure") == 0) {
                        store_msg("disprotect secure");
                        info_disprotect |= DISPROTECT_SECURE;
                }
                if (strcmp(area, "fbbt") == 0) {
                        store_msg("disprotect fbbt");
                        info_disprotect |= DISPROTECT_FBBT;
                }
                if (strcmp(area, "hynix") == 0) {
                        store_msg("disprotect hynix");
                        info_disprotect |= DISPROTECT_HYNIX;
                }
                return 0;
        }
        else if(strcmp(cmd, "exit") == 0){

                if (device_boot_flag == NAND_BOOT_FLAG) {
                        ret = run_command("amlnf exit", 0);
                        if (ret != 0) {
                                store_msg("nand cmd %s failed",cmd);
                                return -1;
                        }
                }
                return 0;
        }
        else{
                goto usage;
        }

        return ret;

usage:
        cmd_usage(cmdtp);
        return 1;

}


U_BOOT_CMD(store, CONFIG_SYS_MAXARGS, 1, do_store,
	"STORE sub-system",
	"store init flag\n"
	"store read name addr off|partition size\n"
	"    read 'size' bytes starting at offset 'off'\n"
	"    to/from memory address 'addr', skipping bad blocks.\n"
	"store write name addr off|partition size\n"
	"    write 'size' bytes starting at offset 'off'\n"
	"    to/from memory address 'addr', skipping bad blocks.\n"
	"store rom_write add off size.\n"
	"	write uboot to the boot device\n"
	"store erase boot/data: \n"
	"	erase the area which is uboot or data \n"
	"store scrub off|partition size\n"
	"	scrub the area from offset and size \n"
);

