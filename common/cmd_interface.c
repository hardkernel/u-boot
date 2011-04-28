#include <common.h>
#include <linux/ctype.h>
#include <linux/mtd/mtd.h>
#include <command.h>
#include <watchdog.h>
#include <malloc.h>
#include <asm/byteorder.h>
#include <jffs2/jffs2.h>
#include <nand.h>
#include <asm/arch/nand.h>
#include <div64.h>
#include <linux/err.h>
#include <spi_flash.h>
#include <asm/io.h>
#include <asm/arch/poc.h>

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
	if(*endptr!='\0')
	{
	    switch(*endptr)
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
			printf("'%s' is not a number\n", argv[0]);
			return -1;
		}
	} else {
		*off = 0;
		*size = 0;
	}

	if (argc >= 2) {
		if (!(str2longlong(argv[1], (unsigned long long *)size))) {
			printf("'%s' is not a number\n", argv[1]);
			return -1;
		}
	}else{
		*size = 0;
	} 

	printf("offset 0x%llx, size 0x%llx\n", *off, *size);

	return 0;
}


int do_boot(cmd_tbl_t * cmdtp, int flag, int argc, char *argv[])
{
	int i, dev, ret = 0;
	ulong addr;
	loff_t off, size;
	char *cmd, *s;

	cmd = argv[1];
	if (argc < 3)
		goto usage;
		
	if (strcmp(cmd, "erase") == 0){

		printk(" %s %d\n",__func__,__LINE__);
		if(POR_NAND_BOOT()){
			printk("NAND BOOT,erase uboot : %s %d\n",__func__,__LINE__);
			run_command("nand device 0",0);
			run_command("nand erase  0",0);
			printk("nand erase  uboot \n");
		}else if(POR_SPI_BOOT()){
			printk("SPI BOOT,spi_env_relocate_spec : %s %d \n",__func__,__LINE__);
			run_command("sf probe 2",0);
			run_command("sf erase 0 200000",0);
			printk("spi erase  uboot \n");
		}else if(POR_EMMC_BOOT()) {
			printk("MMC BOOT, %s %d \n",__func__,__LINE__);
			run_command("mmcinfo 1",0);
			//write 1M 0xff from 0 addr
			run_command("mw.l 82000000 ffffffff 40000", 0);
			run_command("mmc write 1 82000000 0 800", 0);
			printk("mmc erase uboot user partition 0-1MB\n");
		}else{
			if(!run_command("sf probe 2", 0)){
				printk("SPI BOOT,spi_env_relocate_spec : %s %d \n",__func__,__LINE__);
				run_command("sf probe 2",0);
				run_command("sf erase 0 200000",0);
				printk("spi erase  uboot \n");
			}else if(!run_command("nand exist", 0)){
				printk("NAND BOOT,erase uboot : %s %d \n",__func__,__LINE__);
				run_command("nand device 0",0);
				run_command("nand erase  0",0);
				printk("nand erase  uboot \n");
			}else if(!run_command("mmcinfo 1", 0)) {
				printk("MMC BOOT, %s %d \n",__func__,__LINE__);
				//write 1M 0xff from 0 addr
				run_command("mw.l 82000000 ffffffff 40000", 0);
				run_command("mmc write 1 82000000 0 800", 0);
				printk("mmc erase uboot user partition 0-1MB\n");
			}
		}
		
	}else{
		goto usage;
	}

	return ret;
	
usage:
	cmd_usage(cmdtp);
	return 1;
}


U_BOOT_CMD(boot, CONFIG_SYS_MAXARGS, 1, do_boot,
	"SPI-NAND-COMPATIBLE",
	"boot erase - addr off|partition size\n"
	"erase uboot in nand or spi\n"
);

int do_data(cmd_tbl_t * cmdtp, int flag, int argc, char *argv[])
{
	int i, dev, ret = 0;
	ulong addr;
	loff_t off, size;
	char *cmd, *s;
	char	str[128];

	cmd = argv[1];
	if (argc < 3)
		goto usage;
	
	if (get_off_size(argc - 2, argv + 2,  &off, &size) != 0)
		return 1;

	printk("erase data : %s %d  off =%llx ,size=%llx\n",__func__,__LINE__, off, size);
	
	if (strcmp(cmd, "erase") == 0){

		printk(" %s %d\n",__func__,__LINE__);
		if(POR_NAND_BOOT()){
			printk("NAND BOOT,nand_env_relocate_spec : %s %d \n",__func__,__LINE__);
			if(size == 0){
				sprintf(str, "nand erase 0x%llx", off);
				printf("command:	%s\n", str);
				run_command("nand device 1",0);
				run_command(str, 0);
			}else{
				sprintf(str, "nand erase 0x%llx 0x%llx", off, size);
				printf("command:    %s\n", str);
				run_command("nand device 1",0);
				run_command(str, 0);
			}
			printk("nand erase data \n");
		}else if(POR_EMMC_BOOT()) {
			printk("MMC BOOT, %s %d \n",__func__,__LINE__);
			if(size == 0){
				run_command("mmc erase 1", 0);
			}
			printk("mmc erase data \n");
		}else{
			ret = run_command("nand exist", 0);
			printk("do_data else: %s %d , nand exist ret %d\n",__func__,__LINE__, ret);
			if(!run_command("nand exist", 0)){
				if(size == 0){
					sprintf(str, "nand erase 0x%llx", off);
					printf("command:	%s\n", str);
					run_command(str, 0);
				}else{
					sprintf(str, "nand erase 0x%llx 0x%llx", off, size);
					printf("command:	%s\n", str);
					run_command(str, 0);
				}
				printk("nand erase data \n");
			}else if(!run_command("mmcinfo 1", 0)){
				if(size == 0){
					run_command("mmc erase 1", 0);
				}
				printk("mmc erase data \n");
			}
		}
		
	}else{
		goto usage;
	}

	return ret;
	
usage:
	cmd_usage(cmdtp);
	return 1;
}



U_BOOT_CMD(data, CONFIG_SYS_MAXARGS, 1, do_data,
	"SPI-NAND-COMPATIBLE || SPI-NAND-EMMC-COMPATIBLE",
	"data erase - addr off|partition size\n"
	"erase data in nand, spi, mmc\n"
);


