/*
 * Driver for NAND support, Rick Bronson
 * borrowed heavily from:
 * (c) 1999 Machine Vision Holdings, Inc.
 * (c) 1999, 2000 David Woodhouse <dwmw2@infradead.org>
 *
 * Added 16-bit nand support
 * (C) 2004 Texas Instruments
 */

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
#include <linux/types.h>
#include <div64.h>
#include <linux/err.h>
int inited=0;
int flag=-1;
extern ssize_t uboot_key_init();
extern ssize_t uboot_get_keylist(char *keyname);
extern ssize_t uboot_key_read(char *keyname, char *keydata);
extern ssize_t uboot_key_write(char *keyname, char *keydata);
extern int nandkey_provider_register();
extern int key_set_version(char *device);
#define debug(fmt,args...) do { printk("[DEBUG]: FILE:%s:%d, FUNC:%s--- "fmt"\n",\
                                                     __FILE__,__LINE__,__func__,## args);} \
                                         while (0)

#ifndef SECUKEY_DEFAULT_ADDRESS
#define SECUKEY_DEFAULT_ADDRESS	(PHYS_MEMORY_START + 0x02000000)
#endif

/* ------------------------------------------------------------------------- */
int do_secukey(cmd_tbl_t * cmdtp, int flag, int argc, char *argv[])
{
	//
	int i, ret = 0,error,num=0;
	char *cmd;
	char *name;
	char *data;
	char namebuf[20];
	char databuf[4096];
	char listkey[1024];
	static char key_device[20]={0};
	memset(namebuf,0,sizeof(namebuf));
	memset(databuf,0,sizeof(databuf));
	memset(listkey,0,sizeof(listkey));
	unsigned long addr;
	/* at least two arguments please */
	if (argc < 2)
		goto usage;
	cmd = argv[1];
	//first read nand key

#ifdef CONFIG_STORE_COMPATIBLE 
	if(!strcmp(cmd,"init") ){
		char store[20];
		if(is_nand_exist()){
			sprintf(store,"%s","nand");
		}else if (is_emmc_exist()){
			sprintf(store,"%s","emmc");
		}else{
			sprintf(store,"%s","auto");
		}
		error =  uboot_key_initial(store);
		if(error < 0){
			printk("uboot key set version fail\n");
			return -1;
		}
		inited=1;
		memset(key_device,0,sizeof(key_device));
		strcpy(key_device,store);
		printk("key save in %s\n",store);
		return 0;
	}
	if(!strcmp(cmd,"unlock") ){
		if(is_nand_exist()){
			run_command("amlnf disprotect key",0);
		}else if (is_emmc_exist()){
			run_command("mmc key",0);
		}else{
			printk("somthing wrong in key\n");
		}
		return 0;
	}
#endif
	if ((!strcmp(cmd,"nand") )||(!strcmp(cmd,"emmc")) || (!strcmp(cmd,"auto") )){
		error =  uboot_key_initial(cmd);
		if(error < 0){
			printk("uboot key set version fail\n");
			return -1;
		}
		inited=1;
		memset(key_device,0,sizeof(key_device));
		strcpy(key_device,cmd);
		if(!strcmp(cmd,"auto")){
			printk("key save is auto select storer(nand or emmc)\n");
		}
		else{
			printk("key save in %s\n",cmd);
		}
		return 0;
	}
	if(!inited){
		printk("please input \"secukey device(nand or emmc or auto)\" cmd\n");
		return -1;
	}
	if(!strcmp(cmd,"list"))
	{
		if (2==argc)
			addr = SECUKEY_DEFAULT_ADDRESS;
		else if(3==argc)
			addr = (ulong)simple_strtoul(argv[2], NULL, 16);
		else {
			printk("wrong command!!\n");
			goto usage;
		}
		error=uboot_get_keylist(listkey);
		if (error>=0){
			printk("the key name list are:\n%s",listkey);
			for (i=0;i<strlen(listkey);i++){
				if(listkey[i]==0x0a)
					num++;
				}
			flag=num;
			memset((char *)(addr),0,4096);
			*((unsigned int *)addr)=flag;
			flag=-1;
			memcpy((char *)(addr+sizeof(int)),listkey,strlen(listkey)+1);
			return 0;
		}
		else{
			printk("key list error!!check the key  name first!!\n");
			return -1;
		}
	}
	if(!strcmp(cmd,"read"))
	{
		name=argv[2];
		if(4==argc)
			addr = (ulong)simple_strtoul(argv[3], NULL, 16);
		else if(3==argc)
			addr = SECUKEY_DEFAULT_ADDRESS;
		else{
			printk("wrong command!!\n");
			goto usage; 
		}
		memcpy(namebuf,name,strlen(name));
		error=uboot_key_read(namebuf, databuf);
		if(error>=0){
			char outputdata[2];
			printk("key size=%d\n",error);
			printk("the key name is :%s\n",namebuf);
			printk("the key data is :");
			memset(outputdata,0,2);
			for(i=0;i<error;i++){
				outputdata[0]=databuf[i];
				printk("%c",outputdata[0]);
			}
			printk("\n");
			#if 0
			flag=strlen(databuf)-1;
			*((unsigned int *)addr)=flag;
			#endif
			memset((char *)(addr),0,4096);
			memcpy((char *)(addr),databuf,4096);
			//flag=-1;
			return 0;
		}
		else{
			printk("read error!!\n");
			return -1;
		}
	}
	if(!strcmp(cmd,"write"))
	{
		if (argc!=4)
			goto usage;
		name=argv[2];
		data=argv[3];
		memcpy(namebuf,name,strlen(name));
		memcpy(databuf,data,strlen(data));
		error=uboot_key_write(namebuf, databuf);
		if(error>=0){
			printk("write key ok!!\n");
			return 0;
		}
		else{
			printk("write error!!\n");
			return -1;
		}
	}
	if(!strcmp(cmd,"in")){
		ulong lenth;
		if (argc!=5){
			goto usage;
		}
		name=argv[2];
		addr = (ulong)simple_strtoul(argv[3], NULL, 16);
		lenth = (ulong)simple_strtoul(argv[4], NULL, 16);
		error = uboot_key_put(key_device,name,(char*)addr,lenth,0);
		if(error < 0){
			printk("%s:%d  in key error\n",__func__,__LINE__);
		}
		printk("lenth:%d\n",lenth);
		return error;
	}
	if(!strcmp(cmd,"out")){
		ulong lenth;
		if (argc!=5){
			goto usage;
		}
		name=argv[2];
		addr = (ulong)simple_strtoul(argv[3], NULL, 16);
		lenth = (ulong)simple_strtoul(argv[4], NULL, 16);
		error = uboot_key_get(key_device,name,(char*)addr,lenth,0);
		if(error < 0){
			printk("%s:%d  out key error\n",__func__,__LINE__);
		}
		printk("lenth:%d\n",lenth);
		return error;
	}
	if(!strcmp(cmd,"storer")){
		char *operate;
		if(argc != 3){
			goto usage;
		}
		operate = argv[2];
		if(!strcmp(operate,"read")){
			int uboot_storer_read(char *buf,int len);
			error = uboot_storer_read(operate,sizeof(operate));
		}
		else if(!strcmp(operate,"write")){
			int uboot_storer_write(char *buf,int len);
			error = uboot_storer_write(operate,sizeof(operate));
		}
		else{
			goto usage;
		}
		if(error < 0){
			printk("%s %s is error\n",cmd,operate);
			return error;
		}
		printk("%s %s is ok\n",cmd,operate);
		return 0;
	}

usage:
	cmd_usage(cmdtp);
	return 1;
}

U_BOOT_CMD(secukey, CONFIG_SYS_MAXARGS, 1, do_secukey,
	"security KEY sub-system",
	"list [addr] - show available security key name\n"
#ifdef CONFIG_STORE_COMPATIBLE
	"secukey  init - auto init key in the right device\n"
	"secukey  unlock - remove protection of key on devices\n"
#endif
	"secukey  device(nand or emmc or auto) - init key in device\n"
	"secukey write keyname data - wirte key data to nand/emmc\n"
	"secukey read keyname [addr]- read the key data\n"
	"secukey in keyname keyaddr keylen\n"
	"secukey out keyname keyaddr keylen\n"
	"secukey storer read   -- read keydata from storer to memory\n"
	"secukey storer write  -- write keydata from memory to storer\n"
);

ssize_t uboot_key_put(char *device,char *key_name, char *key_data,int key_data_len,int ascii_flag);
ssize_t uboot_key_get(char *device,char *key_name, char *key_data,int key_data_len,int ascii_flag);
int do_ssecukey(cmd_tbl_t * cmdtp, int flag, int argc, char *argv[])
{
	ssize_t error=-1;
	char *cmd;
	char *device,*keyname,*keydata;
	ulong addr,lenth,i;
	int ascii_flag;
	cmd = argv[1];
	if(!strcmp(cmd,"list")){
		return 0;
	}
	if(!strcmp(cmd,"put")){
		if(argc < 5){
			printk("para too few\n");
			goto usage;
		}
		device=argv[2];
		keyname=argv[3];
		keydata=argv[4];
		ascii_flag = 0;
		if(argc >=6){
			if(argc == 6){
				printk("para error\n");
				goto usage;
			}
			addr = (ulong)simple_strtoul(argv[5], NULL, 16);
			lenth = (ulong)simple_strtoul(argv[6], NULL, 16);
			printk("addr:0x%x,lenth:%d",addr,lenth);
			ascii_flag = 1;
			#if 0 //test
			char testhexdata[]={0x11,0x22,0x33,0xaa,0x55,0xff,0x77,0x88};
			memcpy((char*)addr,testhexdata,lenth);
			#endif
		}
		else{
			addr = SECUKEY_DEFAULT_ADDRESS;
		}
		if(ascii_flag){
			error = uboot_key_put(device,keyname,(char*)addr,lenth,0);
		}
		else{
			error = uboot_key_put(device,keyname,keydata,sizeof(keydata),1);
		}
		return error;
	}
	if(!strcmp(cmd,"get")){
		if(argc < 4){
			printk("para too few\n");
			goto usage;
		}
		device=argv[2];
		keyname=argv[3];
		ascii_flag = 0;
		if(argc >=5){
			if(argc ==5){
				printk("para error\n");
				goto usage;
			}
			addr = (ulong)simple_strtoul(argv[4], NULL, 16);
			lenth = (ulong)simple_strtoul(argv[5], NULL, 16);
			ascii_flag = 1;
		}
		else{
			addr = SECUKEY_DEFAULT_ADDRESS;
			lenth = 4096;
		}
		if(ascii_flag){
			error = uboot_key_get(device,keyname,(char*)addr,lenth,0);
			char *p=(char*)addr;
			for(i=0;i<lenth;i++){
				//printk();
				printk("%02x ",p[i]);
			}
		}
		else{
			error = uboot_key_get(device,keyname,(char*)addr,lenth,1);
			char outputdata[2];
			char *pd=(char*)addr;
			memset(outputdata,0,2);
			for(i=0;i<lenth;i++){
				outputdata[0]=pd[i];
				printk("%c",outputdata[0]);
			}
		}
		return error;
	}
usage:
	cmd_usage(cmdtp);
	return 1;
}

U_BOOT_CMD(ssecukey, CONFIG_SYS_MAXARGS, 1, do_ssecukey,
	"NAND KEY sub-system",
	"list [addr]\n"
	"ssecukey put device keyname keydata [addr] [len] - put keydata in device\n"
	"ssecukey get device keyname [addr] [len] - put keydata in device\n"
);
