
#include <asm/arch/storage.h>
#include <partition_table.h>

#define ENV_NAME   "env"
struct partitions * part_table = NULL;
int device_boot_flag = -1;   // indicate spi nand emmc 
int aml_card_type = 0;

void show_partition_table()
{
	int i=0;
	struct partitions * par_table=NULL;
	printf("show partition table: \n");
	for(i=0; i < MAX_PART_NUM; i++){

		par_table =& part_table[i];
		if(par_table->size == -1){
			printf("part: %d, name : %10s, size : %-4s\n",i,par_table->name,"end");
			break;
		}
		else
			printf("part: %d, name : %10s, size : %-4llx\n",i,par_table->name,par_table->size);
	}
	
	return;
}
void init_partiton_table(uint64_t addr)
{
	int i=0,j=0;
	struct partitions * par_table = (struct partitions *)addr;
	struct partitions * tmp_table =NULL;
	struct partitions * soure_table =NULL;

	for(i=0,j=0; i < MAX_PART_NUM; i++){
	
			tmp_table =& part_table[j];		
			soure_table = & par_table[i];
			if((!memcmp(soure_table->name,ENV_NAME,3)) && (POR_SPI_BOOT())){
				continue;
			}
			strncpy (tmp_table->name, soure_table->name, MAX_PART_NAME_LEN);
			tmp_table->offset = soure_table->offset;
			tmp_table->size = soure_table->size;
			tmp_table->size = soure_table->size;
			tmp_table->mask_flags = soure_table->mask_flags;
			j++;
			if(tmp_table->size == NAND_PART_SIZE_FULL){
				break;
			}
		}

}

char * get_acs_struct_addr (char *name)
{
	uint64_t _acs_set_addr, _acs_tmp_addr;

#ifdef CONFIG_MESON_TRUSTZONE
	_acs_set_addr =  meson_trustzone_acs_addr(START_ADDR);
#else
	_acs_set_addr =  *((volatile unsigned int*)START_ADDR);
#endif
	_acs_tmp_addr = _acs_set_addr;

	while(_acs_set_addr < (_acs_tmp_addr + ACS_SET_LEN)){
		if(!memcmp((unsigned char *)_acs_set_addr, name, 4)){
            return _acs_set_addr;
		}
		_acs_set_addr  = _acs_set_addr  + 16;
	}

    return NULL;
}

int  get_partition_table()
{
	int ret=0;
    struct store_config *sc;
	uint64_t addr;

	addr = (uint64_t)get_acs_struct_addr(TABLE_MAGIC_NAME);
	if(addr){
		addr = addr + 12;
#ifdef CONFIG_MESON_TRUSTZONE
		addr =  meson_trustzone_acs_addr(addr);
#else
		addr = *((volatile uint64_t *)addr);
#endif
		// printf("get_patition_table: addr =%llx:\n",addr);
        
		part_table = malloc((MAX_PART_NUM * sizeof(struct partitions)));
		if(part_table == NULL){
			printf("partition_table malloc failed!\n");
			ret = -1;
			goto exit_err;
		}

		init_partiton_table(addr);

		show_partition_table();
	}else{
		printf("get_patition_table: get partition table failed!!\n");
		ret = -1;
		goto exit_err;
	}
    
	addr = (uint64_t)get_acs_struct_addr(STORE_MAGIC_NAME);
	if(addr) {
		addr = addr + 12;
#ifdef CONFIG_MESON_TRUSTZONE
		addr =  meson_trustzone_acs_addr(addr);
#else
		addr = *((volatile uint64_t *)addr);
#endif
		// printf("get_patition_table: store config addr %llx:\n",addr);
        
        sc = (struct store_config *)addr;
        aml_card_type = sc->mmc_configs.type;
        printf("aml_card_type=%#x\n", aml_card_type);
	}else{
		printf("get_patition_table: get store config failed!!\n");
		ret = -1;
		goto exit_err;
	}

	return 0;
	
exit_err:
	
	if(part_table){
		kfree(part_table);
		part_table = NULL;
	}
	return ret;
}

int get_storage_device_flag(int init_ret)
{
	printf("get_boot_device_flag: init_ret %d\n",init_ret);
	if(POR_SPI_BOOT()){
		printf("get_boot_device_flag   SPI BOOT: \n");
		device_boot_flag = SPI_BOOT_FLAG;
		if(init_ret  < 0){
			device_boot_flag = SPI_EMMC_FLAG;
			printf("nand init failed, change the device_boot_flag to %d : spi+mmc\n",SPI_EMMC_FLAG);
		}else{
			device_boot_flag = SPI_NAND_FLAG;
			printf("nand init success, change the device_boot_flag to %d : spi+nand \n",SPI_NAND_FLAG);
		}
		
		return 0;
	}
	if(POR_NAND_BOOT()){
		printf("get_boot_device_flag NAND BOOT: \n");
		device_boot_flag = NAND_BOOT_FLAG;
		return 0;
	}
	if(POR_EMMC_BOOT()){
		printf("get_boot_device_flag EMMC BOOT: \n");
		device_boot_flag = EMMC_BOOT_FLAG;
		return 0;
	}
	if(POR_CARD_BOOT()){
		printf("get_boot_device_flag CARD BOOT: \n");
		device_boot_flag = CARD_BOOT_FLAG;
		return 0;
	}

}


void set_storage_device_flag()
{
	 char  value[4];
	 char *s =NULL;
	 int ret = 0, tmp_num = -1;
	 
	 s = getenv("store");
	 if (!s)
		return; 
	 tmp_num = simple_strtoul(s,NULL,16);
	 printf("set_storage_device_flag: store %d\n",tmp_num);
	 if(tmp_num != device_boot_flag){
		sprintf(value, "%d",device_boot_flag);
		if(!(setenv("store", value))){
			printf("set_storage_device_flag: set  store to %d\n",device_boot_flag);
			//saveenv();
		}
		ret = run_command("put storage",0);
		if(ret){
			printf("#### set storage to bootargs failed\n");
		}
	 }
	return ;
}

bool is_nand_exist (void) // is nand exist
{
    return ((device_boot_flag == NAND_BOOT_FLAG) || (device_boot_flag == SPI_NAND_FLAG));
}

bool is_emmc_exist (void) // is eMMC/TSD exist
{
    return ((device_boot_flag == EMMC_BOOT_FLAG) || (device_boot_flag == SPI_EMMC_FLAG));
}

bool is_spi_exist (void) // is spi exist
{
    return ((device_boot_flag == SPI_BOOT_FLAG) || (device_boot_flag == SPI_NAND_FLAG) || (device_boot_flag == SPI_EMMC_FLAG));
}
