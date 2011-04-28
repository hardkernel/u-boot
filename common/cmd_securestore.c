
#include <common.h>
#include <linux/ctype.h>
#include <malloc.h>
#include <linux/types.h>
#include <linux/err.h>
#include <amlogic/secure_storage.h>
//#include <nand.h>
//#include <asm/arch/nand.h>

#define SECURE_STORAGE_WRITE_PERMIT		1
#define SECURE_STORAGE_WRITE_PROHIBIT	0

#define SECUREOS_KEY_DEFAULT_ADDR_TEST		(PHYS_MEMORY_START + 0x04000000)
#define SECUREOS_KEY_DEFAULT_SIZE_TEST		(128*1024)

static int storage_type = 0;
static int storage_status=SECURE_STORAGE_WRITE_PROHIBIT;
static unsigned int securestorage_addr=0,securestorage_len=0;
static int securestorage_start=0;
static int sstorekey_start = 0;

int do_securestore(cmd_tbl_t * cmdtp, int flag, int argc, char *argv[])
{
	unsigned int len,addr;
	const char *cmd;
	int err;
	if (argc < 2)
		goto usage;

	cmd = argv[1];
	if((!strcmp(cmd,"nand"))||(!strcmp(cmd,"spi"))){
		if(!strcmp(cmd,"nand")){
			storage_type = SECURE_STORAGE_NAND_TYPE;
		}
		if(!strcmp(cmd,"spi")){
			storage_type = SECURE_STORAGE_SPI_TYPE;
		}
		if(argc == 3){
			if(!strcmp(argv[2],"permit")){
				storage_status = SECURE_STORAGE_WRITE_PERMIT;
				printf("secure storage write to %s permit\n",cmd);
			}
			if(!strcmp(argv[2],"prohibit")){
				storage_status = SECURE_STORAGE_WRITE_PROHIBIT;
				printf("secure storage write to %s prohibited\n",cmd);
			}
		}
		return 0;
	}
	if(!strcmp(cmd,"emmc")){
		//storage_type = SECURE_STORAGE_EMMC_TYPE;
		return 0;
	}
	if(!storage_type ){
		printf("please set device\n");
		return 1;
	}
	if(!strcmp(cmd,"write")){
		if((argc > 2)&&(argc < 4)){
			goto usage;
		}
		if(storage_status != SECURE_STORAGE_WRITE_PERMIT){
			printf("secure storage write is prohibited\n");
			goto usage;
		}
		if(argc >=4){
			addr = simple_strtoul(argv[2], NULL, 16);
			len = simple_strtoul(argv[3], NULL, 16);
		}
		else{
			addr =  SECUREOS_KEY_DEFAULT_ADDR_TEST;
			len = SECUREOS_KEY_DEFAULT_SIZE_TEST;
		}
		if(storage_type == SECURE_STORAGE_NAND_TYPE){
			err = secure_storage_nand_write((char*)addr,len);
			if(err){
				printf("%s:%d,write key fail to nand\n",__func__,__LINE__);
				return err;
			}
			printf("write to nand ok\n");
		}
		else if(storage_type == SECURE_STORAGE_SPI_TYPE){
			err = secure_storage_spi_write((char*)addr,len);
			if(err){
				printf("%s:%d,write key fail to spi\n",__func__,__LINE__);
				return err;
			}
			printf("write to spi ok\n");
		}
		else{
			printf("not support\n");
			return 1;
		}
		return 0;
	}
	if(!strcmp(cmd,"read")){
		if((argc > 2)&&(argc < 4)){
			goto usage;
		}
		if(argc >=4){
			addr = simple_strtoul(argv[2], NULL, 16);
			len = simple_strtoul(argv[3], NULL, 16);
		}
		else{
			addr =  SECUREOS_KEY_DEFAULT_ADDR_TEST;
			len = SECUREOS_KEY_DEFAULT_SIZE_TEST;
		}
		if(storage_type == SECURE_STORAGE_NAND_TYPE){
			err = secure_storage_nand_read((char*)addr,len);
			if(err){
				printf("%s:%d,read key fail from nand\n",__func__,__LINE__);
				return err;
			}
			printf("from nand read key ok\n");
		}
		else if(storage_type == SECURE_STORAGE_SPI_TYPE){
			err = secure_storage_spi_read((char*)addr,len);
			if(err){
				printf("%s:%d,read key fail from spi\n",__func__,__LINE__);
				return 1;
			}
			printf("from spi read key ok\n");
		}
		else{
			printf("not support\n");
			return 1;
		}
		return 0;
	}
usage:
	cmd_usage(cmdtp);
	return 1;
}

int do_sstorekey(cmd_tbl_t * cmdtp, int flag, int argc, char *argv[])
{
	unsigned int len,addr,query_status;
	unsigned int reallen;
	const char *cmd,*keyname;
	unsigned int seedaddr;
	unsigned int seedlen;
	int err;
	if (argc < 2)
		goto usage;

	cmd = argv[1];
	if(!strcmp(cmd,"init")){
		if(argc>3){
			seedaddr = simple_strtoul(argv[2], NULL, 16);
			seedlen = simple_strtoul(argv[3], NULL, 16);
		}
		else{
			char seedkey[]={1,2,3,4};
			seedaddr = (unsigned int)&seedkey[0];
			seedlen =4;
		}
		securestore_key_init((char *)seedaddr,seedlen);
		if(err){
			printf("%s:%d,secure storage init fail\n",__func__,__LINE__);
			return err;
		}
		sstorekey_start=1;
		printf("start key read/write\n");
		return 0;
	}
	if(!strcmp(cmd,"uninit")){
		securestore_key_uninit();
		sstorekey_start = 0;
		printf("stop key read/write\n");
		return 0;
	}
	if(sstorekey_start == 0){
		printf("please start sstorekey read/write\n");
		return 1;
	}
	if(!strcmp(cmd,"write")){
		if(argc < 5){
			goto usage;
		}
		keyname = argv[2];
		
		addr = simple_strtoul(argv[3], NULL, 16);
		len = simple_strtoul(argv[4], NULL, 16);
		err = securestore_key_write(keyname,addr,len,0);
		if(err){
			if(err == 0x1fe){
				printf("%s:%d,secure storage no space to save key\n",__func__,__LINE__);
			}
			else{
				printf("%s:%d,write a key secure storage fail\n",__func__,__LINE__);
			}
			return err;
		}
		printf("write a key ok\n");
		return 0;
	}
	if(!strcmp(cmd,"read")){
		if(argc < 6){
			goto usage;
		}
		keyname = argv[2];
		addr = simple_strtoul(argv[3], NULL, 16);
		len = simple_strtoul(argv[4], NULL, 16);
		reallen = simple_strtoul(argv[5], NULL, 16);
		err = securestore_key_read(keyname,(char*)addr,len,(unsigned int*)reallen);
		if(err){
			printf("%s:%d,read a key fail\n",__func__,__LINE__);
			return err;
		}
		printf("read a key ok\n");
		return 0;
	}
	if(!strcmp(cmd,"query")){
		if(argc < 4){
			printf("para too few\n");
			goto usage;
		}
		keyname = argv[2];
		query_status = simple_strtoul(argv[3], NULL, 16);
		err = securestore_key_query(keyname,(unsigned int*)query_status);
		if((!err) && ((*(unsigned int*)query_status) == 1)){
			printf("key exist\n");
		}
		else{
			printf("key not exist\n");
		}
		return 0;
	}
usage:
	cmd_usage(cmdtp);
	return 1;
}

U_BOOT_CMD(securestore, CONFIG_SYS_MAXARGS, 1, do_securestore,
	"securestore sub-system",
	"device  [permit/prohibit]  --- device: nand/emmc/spi \n"
	"securestore write [addr] [len]  -- write secure key to device\n"
	"securestore read  [addr] [len]   -- read secure key for device\n"
);

U_BOOT_CMD(sstorekey, CONFIG_SYS_MAXARGS, 1, do_sstorekey,
	"sstorekey sub-system",
	"init/uninit    --- device: nand/emmc/spi \n"
	"sstorekey write key-name data-addr data-len  --write a key \n"
	"sstorekey read key-name data-addr data-len reallen-addr   -- read a key\n"
	"sstorekey query key-name querystatus-addr    ---query a key if it is exist   \n"
);


