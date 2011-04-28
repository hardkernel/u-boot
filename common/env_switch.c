#include <common.h>
#include <environment.h>
#include <malloc.h>
#include <spi_flash.h>
#include <search.h>
#include <errno.h>
#include <command.h>
#include <linux/stddef.h>
#include <malloc.h>
#include <nand.h>
#include <asm/arch/nand.h>
#include <linux/err.h>
#include <asm/arch/poc.h>
#include<partition_table.h>
#if defined(CONFIG_STORE_COMPATIBLE) || defined (CONFIG_SPI_NAND_COMPATIBLE) || defined (CONFIG_SPI_NAND_EMMC_COMPATIBLE)

DECLARE_GLOBAL_DATA_PTR;

/* references to names in env_common.c */
extern uchar default_environment[];

uchar env_get_char_spec(int index)
{
	return *((uchar *)(gd->env_addr + index));
}

#ifdef ENV_IS_EMBEDDED
extern uchar environment[];
env_t *env_ptr = (env_t *)(&environment[0]);
#else /* ! ENV_IS_EMBEDDED */
env_t *env_ptr = 0;
#endif /* ENV_IS_EMBEDDED */

char * env_name_spec;

extern void mdelay(unsigned long msec);

int env_init(void)
{
	//printk("env_init %s %d\n",__func__,__LINE__);
	gd->env_addr  = (ulong)&default_environment[0];
	gd->env_valid = 1;
	return 0;
}

void env_relocate_spec(void)
{
	if(POR_NAND_BOOT()){
		printk("NAND BOOT,nand_env_relocate_spec : %s %d \n",__func__,__LINE__);
		env_name_spec = "NAND";
		nand_env_relocate_spec();
	}else if(POR_SPI_BOOT()){
		printk("SPI BOOT,spi_env_relocate_spec : %s %d \n",__func__,__LINE__);
		env_name_spec = "SPI Flash";
		spi_env_relocate_spec();
	}
#if defined(CONFIG_SPI_NAND_EMMC_COMPATIBLE) || defined(CONFIG_STORE_COMPATIBLE)
	else if(POR_EMMC_BOOT()) {
		printk("MMC BOOT, emmc_env_relocate_spec : %s %d \n",__func__,__LINE__);
		env_name_spec = "eMMC";
		emmc_env_relocate_spec();
	}
#endif
	else{
		printk("BOOT FROM CARD? env_relocate_spec\n");
		if(!run_command("sf probe 2", 0)){
			printk("SPI BOOT, spi_env_relocate_spec %s %d \n",__func__,__LINE__);
			env_name_spec = "SPI Flash";
			spi_env_relocate_spec();
		}else if(!run_command("nand exist", 0)){
			printk("NAND BOOT, nand_env_relocate_spec %s %d \n",__func__,__LINE__);
			env_name_spec = "NAND";
			nand_env_relocate_spec();
		}
#if defined(CONFIG_SPI_NAND_EMMC_COMPATIBLE) || defined(CONFIG_STORE_COMPATIBLE)
		else if(!run_command("mmcinfo 1", 0)){
			printk("MMC BOOT, emmc_env_relocate_spec %s %d \n",__func__,__LINE__);
			env_name_spec = "eMMC";
			emmc_env_relocate_spec();
		}
#endif
		else{
			env_name_spec = "None";
			set_default_env("error init device");
		}
	}
}

int saveenv(void)
{
	int ret = 0;

	if(POR_NAND_BOOT()){
		printk("NAND BOOT,nand_saveenv :%s %d \n",__func__,__LINE__);
		ret = nand_saveenv();
	}else if(POR_SPI_BOOT()){
		printk("SPI BOOT,spi_saveenv : %s %d \n",__func__,__LINE__);
		ret = spi_saveenv();
	}
#if defined(CONFIG_SPI_NAND_EMMC_COMPATIBLE) || defined(CONFIG_STORE_COMPATIBLE)
	else if(POR_EMMC_BOOT()){
		printk("MMC BOOT,emmc_saveenv : %s %d \n",__func__,__LINE__);
		ret = emmc_saveenv();
	}
#endif
	else if (POR_CARD_BOOT()){
		printk("BOOT FROM CARD?\n");
		if(!run_command("sf probe 2", 0)){
			printk("SPI BOOT, spi_saveenv %s %d \n",__func__,__LINE__);
			env_name_spec = "SPI Flash";
			spi_saveenv();
		}else if(!run_command("nand exist", 0)){
			printk("NAND BOOT, nand_saveenv %s %d \n",__func__,__LINE__);
			env_name_spec = "NAND";
			nand_saveenv();
		}	
#if defined(CONFIG_SPI_NAND_EMMC_COMPATIBLE) || defined(CONFIG_STORE_COMPATIBLE)
		else if(!run_command("mmcinfo 1", 0)){
			printk("MMC BOOT, emmc_saveenv %s %d \n",__func__,__LINE__);
			env_name_spec = "eMMC";
			emmc_saveenv();
		}
#endif		
		else{
			printk("error init devices, saveenv fail\n");
		}
	}

	return ret;
}

#endif


