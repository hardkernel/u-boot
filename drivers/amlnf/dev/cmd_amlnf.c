/*****************************************************************
**                                                              
**  Copyright (C) 2012 Amlogic,Inc.  All rights reserved                         
**                                           
**        Filename : driver_uboot.c       	
**        Revision : 1.001	                                        
**        Author: Benjamin Zhao
**        Description: 
**			amlnand_init,  mainly init nand phy driver.
**        		
**            
*****************************************************************/

#include "../include/amlnf_dev.h"

extern int amlnf_init(unsigned char flag);
extern void amldev_dumpinfo(struct amlnand_phydev *phydev);
static int plane_mode = 0;
struct amlnf_dev * nftl_device = NULL;
struct amlnand_phydev *phy_device=NULL;
static int nand_protect = 1;

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

static int
arg_off_size(int argc, char *argv[], uint64_t chipsize, uint64_t *off, uint64_t *size)
{
	if (argc >= 1) {
		if (!(str2longlong(argv[0], (unsigned long long*)off))) {
			aml_nand_dbg("'%s' is not a number", argv[0]);
			return -1;
		}
	} else {
		*off = 0;
	}

	if (argc >= 2){
		if (!(str2longlong(argv[1], (unsigned long long *)size))) {
			aml_nand_dbg("'%s' is not a number", argv[1]);
			return -1;
		}
	} else {
		*size = chipsize - *off;
	}

	if (*size == chipsize)
		aml_nand_dbg("whole chip/dev");
	else
		aml_nand_dbg("offset 0x%llx, size 0x%llx", *off, *size);

	return 0;
}

#define AML_NFTL_ALIGN_SIZE	    512
#define AML_NFTL_ALIGN_SHIFT	9
unsigned char local_buf[AML_NFTL_ALIGN_SIZE];

int amlnand_read(struct amlnf_dev* nftl_dev, unsigned char *buf, uint64_t offset, uint64_t size)
{
    unsigned long ret = 0;
	unsigned long long head_sector;
	unsigned long long head_start_bytes;
	unsigned long long head_bytes_num;

	unsigned long long mid_sector;
	unsigned long long mid_len;

	unsigned long long tail_sector;
	unsigned long long tail_bytes_num;

	mid_len = offset >> AML_NFTL_ALIGN_SHIFT;
	head_start_bytes = offset - (mid_len << AML_NFTL_ALIGN_SHIFT);
	head_bytes_num = AML_NFTL_ALIGN_SIZE - head_start_bytes;
	head_sector = offset >> AML_NFTL_ALIGN_SHIFT;

	if(head_bytes_num >= size)
	{
         ret |= nftl_dev->read_sector(nftl_dev, head_sector, 1, local_buf);
	     memcpy(buf, local_buf+head_start_bytes, size);
	     return ret;
    }

    ret |= nftl_dev->read_sector(nftl_dev, head_sector, 1, local_buf);
    memcpy(buf, local_buf+head_start_bytes, head_bytes_num);

	buf += head_bytes_num;
	offset += head_bytes_num;
	size -= head_bytes_num;

	if(size > AML_NFTL_ALIGN_SIZE)
	{
        mid_len = size >> AML_NFTL_ALIGN_SHIFT;
        mid_sector = offset >> AML_NFTL_ALIGN_SHIFT;
        ret |= nftl_dev->read_sector(nftl_dev, mid_sector, mid_len, buf);
        buf += mid_len << AML_NFTL_ALIGN_SHIFT;
        offset += mid_len << AML_NFTL_ALIGN_SHIFT;
        size = size - (mid_len << AML_NFTL_ALIGN_SHIFT);
    }

	if(size == 0)
       return ret;

	tail_sector = offset >> AML_NFTL_ALIGN_SHIFT;
	tail_bytes_num = size;
    ret |= nftl_dev->read_sector(nftl_dev, tail_sector, 1, local_buf);
    memcpy(buf, local_buf, tail_bytes_num);
    return ret;
}

int amlnand_write(struct amlnf_dev* nftl_dev, unsigned char *buf, uint64_t offset, uint64_t size)
{
    unsigned long ret = 0;
	unsigned long long head_sector;
	unsigned long long head_start_bytes;
	unsigned long long head_bytes_num;

	unsigned long long mid_sector;
	unsigned long long mid_len;

	unsigned long long tail_sector;
	unsigned long long tail_bytes_num;


	mid_len = offset >> AML_NFTL_ALIGN_SHIFT;
	head_start_bytes = offset - (mid_len << AML_NFTL_ALIGN_SHIFT);
	head_bytes_num = AML_NFTL_ALIGN_SIZE - head_start_bytes;
	head_sector = offset >> AML_NFTL_ALIGN_SHIFT;

	if(head_bytes_num >= size)
	{
         ret |= nftl_dev->read_sector(nftl_dev, head_sector, 1, local_buf);
	     memcpy(local_buf+head_start_bytes, buf, size);
	     ret |= nftl_dev->write_sector(nftl_dev, head_sector, 1, local_buf);
	     goto DATA_FLUSH;
    }

    ret |= nftl_dev->read_sector(nftl_dev, head_sector, 1, local_buf);
    memcpy(local_buf+head_start_bytes,buf, head_bytes_num);
    ret |= nftl_dev->write_sector(nftl_dev, head_sector, 1, local_buf);


	buf += head_bytes_num;
	offset += head_bytes_num;
	size -= head_bytes_num;

	if(size > AML_NFTL_ALIGN_SIZE)
	{
        mid_len = size >> AML_NFTL_ALIGN_SHIFT;
        mid_sector = offset >> AML_NFTL_ALIGN_SHIFT;
        ret |= nftl_dev->write_sector(nftl_dev, mid_sector, mid_len, buf);
        buf += mid_len << AML_NFTL_ALIGN_SHIFT;
        offset += mid_len << AML_NFTL_ALIGN_SHIFT;
        size = size - (mid_len << AML_NFTL_ALIGN_SHIFT);
    }

	if(size == 0){
       goto DATA_FLUSH;
    }

	tail_sector = offset >> AML_NFTL_ALIGN_SHIFT;
	tail_bytes_num = size;
    ret |= nftl_dev->read_sector(nftl_dev, tail_sector, 1, local_buf);
    memcpy(local_buf, buf, tail_bytes_num);
    ret |= nftl_dev->write_sector(nftl_dev, tail_sector, 1, local_buf);

DATA_FLUSH:    
	ret = nftl_dev->flush((struct amlnf_dev *)nftl_dev);
	if(ret < 0){
		aml_nand_msg("nftl flush cache failed");
		ret = -1;
	}

    return ret;
}


int do_amlnfphy(cmd_tbl_t * cmdtp, int flag, int argc, char *argv[])
{
	struct amlnand_phydev *phydev = NULL;
	struct phydev_ops  * devops = NULL;
	struct amlnf_dev *nftl_dev;

	uint64_t addr, off, size, chipsize, erase_addr, erase_len, erase_off;
	unsigned erase_shift, write_shift, writesize, erasesize, pages_per_blk;
	unsigned char read, devread, nfread_flag;
	int  dev, start_secor, length,  ret = 0;
	char *cmd,*protect_name, *dev_name;
    uint32_t *markbad_reserved_addr = NULL;

	/* at least two arguments please */
	if (argc < 1)
		goto usage;

	cmd = argv[1];	

	 amlnf_get_chip_size(&chipsize);

	if(strcmp(cmd, "env") == 0){
		aml_nand_dbg("env relocate");	
		env_relocate ();
		return 0;
	}
	if(strcmp(cmd, "disprotect") == 0){
		protect_name = argv[2];
		amlnf_disprotect(protect_name);
		return 0 ;
	}
	if(strcmp(cmd, "exit") == 0){
		amlnf_exit();
		return 0;
	}	
	if (strcmp(cmd, "init") == 0) {

		putc('\n');
		int init_flag = (ulong)simple_strtoul(argv[2], NULL, 16); 
		// flag = 0,indicate normal boot;
		//flag = 1, indicate update; 
		//flag = 2, indicate need erase 
		
		ret = amlnf_init(init_flag);
		if(ret ){
			printk("nand_init failed ret:%x\n", ret);
			return ret;
		}
		
		phydev = aml_phy_get_dev(NAND_CODE_NAME);
		if(!phydev){
			printk("phydev be NULL\n");
			goto usage;
		}
		return 0;
	}


	if((strcmp(cmd, "read_byte") == 0) ||(strcmp(cmd, "write_byte") == 0)){

		if(argc < 6){
			goto usage;
		}

		dev_name = argv[2];
		nftl_dev =NULL;
		nftl_dev = aml_nftl_get_dev(dev_name);
		if(!nftl_dev){
			aml_nand_msg("nftl_dev be NULL");
			return -1;
		}
		aml_nand_dbg("nftl_dev->name =%s",nftl_dev->name );

		addr = (ulong)simple_strtoul(argv[3], NULL, 16);

		nfread_flag = 0;
		if(strncmp(cmd, "read_byte", 9) == 0)
		    nfread_flag = 1;

		aml_nand_dbg("\nNAND %s: addr:%llx ", nfread_flag ? "read_byte" : "write_byte", addr);

		if (arg_off_size(argc - 4, argv + 4, 0x0, &off, &size) != 0)
			goto usage;

	   if(nfread_flag){
	        ret = amlnand_read(nftl_dev,addr,off,size);
	    }else{
	        ret = amlnand_write(nftl_dev,addr,off,size);
	    }

        aml_nand_dbg(" 0x%llx bytes %s : %s", size,nfread_flag ? "read_byte" : "write_byte", ret ? "ERROR" : "OK");

	    return ret;
	}

	if((strcmp(cmd, "read") == 0) ||(strcmp(cmd, "write") == 0)){

		if(argc < 6){
			goto usage;
		}

		nftl_dev =NULL;
		dev_name = argv[2];
		nftl_dev =NULL;
		nftl_dev = aml_nftl_get_dev(dev_name);
		if(!nftl_dev){
			aml_nand_msg("nftl_dev be NULL");
			return -1;
		}
		aml_nand_dbg("nftl_dev->nand_dev->writesize =%x",nftl_dev->nand_dev->writesize);
		aml_nand_dbg("nftl_dev->nand_dev->erasesize =%x",nftl_dev->nand_dev->erasesize);
		aml_nand_dbg("nftl_dev->name =%s",nftl_dev->name );
		
		addr = (ulong)simple_strtoul(argv[3], NULL, 16);
		
		nfread_flag = strncmp(cmd, "read", 4) == 0; /* 1 = read, 0 = write */	
		printf("\nNAND %s: addr:%lx \n", nfread_flag ? "read" : "write", addr);
		
		if (arg_off_size(argc - 4, argv + 4, 0x0, &off, &size) != 0)
			goto usage;

		if (off % 512){
			start_secor = ((int) (off /512) + 1);
			aml_nand_dbg("secor+1");
		}else{
			start_secor =(int) (off /512);
		}
		if(size % 512){
			length = ((int)( (size /512))+1);	
			aml_nand_dbg("length+1");
		}else{
			length = (int)( (size /512));
		}
		
		aml_nand_dbg("start_secor =%d",start_secor);
		aml_nand_dbg("length_sector =%d",length);
		
		if(nfread_flag){
			ret = nftl_dev->read_sector(nftl_dev, start_secor, length, addr);
			if(ret < 0){
				aml_nand_dbg("nftl read %d sector  failed", length);
				return -1;
			}
		}else{
			ret = nftl_dev->write_sector(nftl_dev, start_secor, length, addr);
			if(ret < 0){
				aml_nand_dbg("nftl write %d sector  failed", length);
				return -1;
			}
			ret = nftl_dev->flush(nftl_dev);
			if(ret < 0){
				aml_nand_dbg("nftl flush cache failed");
				return -1;
			}
		}
		
		printf(" %d sector %s : %s\n", length,
			       nfread_flag ? "read" : "write", ret ? "ERROR" : "OK");
		
		return ret;
	}

	if (strcmp(cmd, "chipinfo") == 0){
		putc('\n');
		amlnf_dump_chipinfo();
		return 0;
	}

	if (strcmp(cmd, "size") == 0){

		if(argc < 4){
			goto usage;
		}

		dev_name = argv[2];
		nftl_dev =NULL;
		nftl_dev = aml_nftl_get_dev(dev_name);
		if(!nftl_dev){
			aml_nand_msg("nftl_dev be NULL");
			return -1;
		}
		aml_nand_dbg("nftl_dev->nand_dev->writesize =%x",nftl_dev->nand_dev->writesize);
		aml_nand_dbg("nftl_dev->nand_dev->erasesize =%x",nftl_dev->nand_dev->erasesize);
		aml_nand_dbg("nftl_dev->name =%s",nftl_dev->name );
		
		addr = (ulong)simple_strtoul(argv[3], NULL, 16);
		* (volatile uint64_t *)addr =  nftl_dev->size_sector;
		aml_nand_dbg("nftl_dev->size_sector =%llx",nftl_dev->size_sector);
		aml_nand_dbg("*addr = %llx",(* (volatile uint64_t *)addr));
		
		return 0;
	}
	if ( strncmp(cmd, "rom_protect", 9) == 0) {

		if (argc < 2)
			goto usage;

		if(strncmp(argv[2], "on", 2) == 0)
		{
			nand_protect = 1;
		}
		else	if(strncmp(argv[2], "off", 3) == 0)
		{
			nand_protect = 0;
		}
		else
		{
			goto usage;
		}
		return	0;
	}
	if((strcmp(cmd, "rom_write") == 0) || (strcmp(cmd, "rom_read") == 0)){
		nfread_flag =0;
		if(strncmp(cmd, "rom_read", 8) == 0)
				nfread_flag = 1;
		
		if (argc < 4)
			goto usage;
	
		addr = (ulong)simple_strtoul(argv[2], NULL, 16);
		printf("\nAMLNAND %s: ", nfread_flag ? "rom_read" : "rom_write");
		
		struct amlnand_phydev *tmp_phydev = phydev;
		struct phydev_ops  *tmp_devops = devops;
		
		phydev =aml_phy_get_dev(NAND_BOOT_NAME);
		if(!phydev){
			aml_nand_msg("phydev be NULL");
			return -1;
		}
		devops = &(phydev->ops);
		aml_nand_dbg("phydev->name =%s",phydev->name);		
		amldev_dumpinfo(phydev);

		if (arg_off_size(argc - 3, argv + 3, phydev->size, &off, &size) != 0)
			return -1;

		memset(devops, 0x0, sizeof(struct phydev_ops));

		devops->addr = off;
		devops->len = size;
		devops->mode = NAND_HW_ECC;
		devops->datbuf = (unsigned char *)addr;
			
		if(nfread_flag){
			ret = roomboot_nand_read(phydev);
			if(ret < 0){
				aml_nand_msg("nand read uboot failed");
			}
		}else{
			ret = roomboot_nand_write(phydev);
			if(ret < 0){
				aml_nand_msg("nand write uboot failed");
			}
		}

		printf(" %llu bytes %s : %s\n", size,
			       nfread_flag ? "rom_read" : "rom_write", ret ? "ERROR" : "OK");

		phydev = tmp_phydev;
		devops = tmp_devops;
		
		return ret;	
	}

	if ((strcmp(cmd, "devread") == 0) || (strcmp(cmd, "devwrite") == 0)){
		
		if (argc < 6)
			goto usage;	

		dev_name = argv[2];
		if(strcmp(dev_name, "boot") == 0){
			dev_name = NAND_BOOT_NAME;
		}
		else if(strcmp(dev_name, "code") == 0){
			dev_name = NAND_CODE_NAME;
		}
		else if(strcmp(dev_name, "cache") == 0){
			dev_name = NAND_CACHE_NAME;
		}else if(strcmp(dev_name, "data") == 0){
			dev_name = NAND_DATA_NAME;
		}else{
			aml_nand_msg("input wrong name!! %s",dev_name);
			goto usage;
		}
		addr = (ulong)simple_strtoul(argv[3], NULL, 16);
		aml_nand_dbg("addr = %llx",addr);

		devread = strncmp(cmd, "devread", 7) == 0; /* 1 = devread, 0 = devwrite */	
		printf("\nNAND %s: addr:%lx \n", devread ? "devread" : "devwrite", addr);
		
		if (arg_off_size(argc - 4, argv + 4, chipsize, &off, &size) != 0)
			goto usage;
		
		phydev = aml_phy_get_dev(dev_name);
		if(!phydev){
			aml_nand_msg("phydev be NULL");
			return -1;
		}
		devops = &(phydev->ops);

		memset(devops, 0x0, sizeof(struct phydev_ops));
		devops->addr = off;
		devops->len = size;
		devops->mode = NAND_HW_ECC;
		devops->datbuf = (unsigned char *)addr;
		
		if(devread){		
			ret = nand_read_ops(phydev);	
			if(ret < 0){
				aml_nand_dbg("nand read failed");
			}
		}else{
			ret = nand_write_ops(phydev);
			if(ret < 0){
				aml_nand_dbg("nand write failed");
			}			
		}

		printf(" %llu bytes %s : %s\n", size,
			       devread ? "devread" : "devwrite", ret ? "ERROR" : "OK");
		
		return 0;
				
	}
	
	if((strcmp(cmd, "deverase") == 0) ){

		if(argc < 4){
			goto usage;
		}
		
		int percent=0;
		int percent_complete = -1;
		
		dev_name = argv[2];
		if(strcmp(dev_name, "boot") == 0){
			dev_name = NAND_BOOT_NAME;
		}
		else if(strcmp(dev_name, "code") == 0){
			dev_name = NAND_CODE_NAME;
		}else if(strcmp(dev_name, "cache") == 0){
			dev_name = NAND_CACHE_NAME;
		}else if(strcmp(dev_name, "data") == 0){
			dev_name = NAND_DATA_NAME;
		}else{
			aml_nand_msg("input wrong name!! %s",dev_name);
			goto usage;
		}		
		phydev = aml_phy_get_dev(dev_name);
		if(!phydev){
			aml_nand_msg("phydev be NULL");
			return -1;
		}
	
		devops = &(phydev->ops);
		if(!strcmp(argv[3], "whole"))
		{
			off = 0;
			size = phydev->size;	
			erase_addr =erase_off= off;
			erase_len = size;	
			printf("whole dev.\n");
			
		}else{
			if ((strcmp(cmd, "deverase") == 0) && (argc < 3)){
					goto usage;
			}
			if ((arg_off_size(argc - 3, argv + 3, phydev->size, &off, &size) != 0)){
				goto usage;
			}
			aml_nand_dbg("off:0x%llx size:%llx.\n", off, size);
			erase_addr =erase_off= off;
			erase_len = size;
		}
		
		aml_nand_dbg("erase_len = %llx",erase_len);		
		aml_nand_dbg("erase_off = %llx",erase_off);
		
		if (erase_len < phydev->erasesize){				
			printf("Warning: Erase size 0x%08x smaller than one "	\
				   "erase block 0x%08x\n",erase_len, phydev->erasesize);
			printf("		 Erasing 0x%08x instead\n", phydev->erasesize);
			erase_len = phydev->erasesize;
		}
	
		for (; erase_addr <erase_off + erase_len; erase_addr +=  phydev->erasesize) {
			
			memset(devops, 0x0, sizeof(struct phydev_ops));
			devops->addr = erase_addr;
			devops->len = phydev->erasesize;			
			devops->mode = NAND_HW_ECC;
			
			 ret = phydev->block_isbad(phydev);
			if (ret > 0) {
				printf("\rSkipping bad block at 0x%08llx\n", erase_addr);
				continue;

			} else if (ret < 0) {
				printf("\n:AMLNAND get bad block failed: ret=%d at addr=%llx\n",ret, erase_addr);
				return -1;
			}
			
			ret = nand_erase(phydev);
			if (ret < 0){
				printf("\nAMLNAND Erase failure: %d %llx\n", ret, erase_addr);
				ret = phydev->block_markbad(phydev);
				if (ret < 0)
					printf("AMLNAND bad block mark failed: %llx\n", erase_addr);	
				continue;			
			}

			percent = (erase_addr * 100) / (erase_off + erase_len);
			if ((percent != percent_complete)&&((percent %10)==0)) {
					percent_complete = percent;
					aml_nand_msg("nand erasing %d %% --%d %% complete",percent,percent+10);
			}
		}
		printf("NAND %s %s\n", "ERASE", (ret <0) ? "ERROR" : "OK");
		return 0;
	}
	if(strcmp(cmd, "dump") == 0){

		dev_name = argv[2];
		if(strcmp(dev_name, "boot") == 0){
			dev_name = NAND_BOOT_NAME;
		}else if(strcmp(dev_name, "cache") == 0){
			dev_name = NAND_CACHE_NAME;
		}
		else if(strcmp(dev_name, "code") == 0){
			dev_name = NAND_CODE_NAME;
		}else if(strcmp(dev_name, "data") == 0){
			dev_name = NAND_DATA_NAME;
		}else{
			aml_nand_msg("input wrong name!! %s",dev_name);
			goto usage;
		}
		addr = (ulong)simple_strtoul(argv[3], NULL, 16);
		aml_nand_dbg("addr = %llx",addr);
		
		if (arg_off_size(argc - 4, argv + 4, chipsize, &off, &size) != 0)
			goto usage;
		
		phydev = aml_phy_get_dev(dev_name);
		if(!phydev){
			aml_nand_msg("phydev be NULL");
			return -1;
		}
		
		devops = &(phydev->ops);
		memset(devops, 0x0, sizeof(struct phydev_ops));
		devops->addr = off;
		devops->len = phydev->writesize;
		devops->oobbuf = NULL;
		devops->datbuf = (unsigned char *)addr;
		devops->mode = NAND_SOFT_ECC;

		amlnand_dump_page(phydev);
		return 0;
	}
	if((strcmp(cmd, "scrub") == 0) ||(strcmp(cmd, "erase") == 0) ){
		
		int scrub_flag = !strncmp(cmd, "scrub",5);
		int percent=0;
		int percent_complete = -1;
		if (argc < 2){
			goto usage;
		}
		
		if (scrub_flag){
			puts("Warning: "
			     "devscrub option will erase all factory set "
			     "bad blocks!\n"
			     "         "
			     "There is no reliable way to recover them.\n"
			     "         "
			     "Use this command only for testing purposes "
			     "if you\n"
			     "         "
			     "are sure of what you are doing!\n"
			     "\nReally scrub this NAND flash? <y/N>\n");
			scrub_flag = 0;
			if(nand_protect){
				if (getc() == 'y') {
					puts("y");
					if (getc() == '\r')
						scrub_flag = 1;
					else {
						puts("scrub aborted\n");
						return -1;
					}
				} else {
					puts("scrub aborted\n");
					return -1;
				}
			}
			else{
			    scrub_flag = 1;
			}
		}
		
		if(!strcmp(argv[2], "whole"))
		{
			off = 0;
			size = chipsize; //((uint64_t)flash->chipsize << 20);
			erase_addr =erase_off= off;
			erase_len = size;	
			printf("whole dev.\n");
		}else{

			if ((arg_off_size(argc - 2, argv + 2, chipsize, &off, &size) != 0)){
				goto usage;
			}		
			erase_addr =erase_off= off;
			erase_len = size;
		}

		erase_addr =erase_off= off;
		erase_len = size;
		ret = amlnf_erase_ops(off,erase_len,scrub_flag);
		if(ret < 0){
			aml_nand_msg("nand erase failed");
		}
		
		return ret;
	}
    if(strcmp(cmd, "markbad") == 0){

		if(argc < 4){
			goto usage;
		}
		
		dev_name = argv[2];
		if(strcmp(dev_name, "boot") == 0){
			dev_name = NAND_BOOT_NAME;
		}
		else if(strcmp(dev_name, "code") == 0){
			dev_name = NAND_CODE_NAME;
		}else if(strcmp(dev_name, "cache") == 0){
			dev_name = NAND_CACHE_NAME;
		}else if(strcmp(dev_name, "data") == 0){
			dev_name = NAND_DATA_NAME;
		}else{
			aml_nand_msg("input wrong name!! %s",dev_name);
			goto usage;
		}		
		phydev = aml_phy_get_dev(dev_name);
		if(!phydev){
			aml_nand_msg("phydev be NULL");
			return -1;
		}
	
		devops = &(phydev->ops);

		if ((arg_off_size(argc - 3, argv + 3, phydev->size, &off, &size) != 0)){
			goto usage;
		}
		aml_nand_dbg("off:0x%llx size:%llx.\n", off, size);
		erase_addr =erase_off= off;
		erase_len = size;

		
		aml_nand_dbg("erase_len = %llx",erase_len);		
		aml_nand_dbg("erase_off = %llx",erase_off);
		
		if (erase_len < phydev->erasesize){				
			printf("Warning: markbad size 0x%08x smaller than one "	\
				   "block 0x%08x\n",erase_len, phydev->erasesize);
			printf("		 markbad 0x%08x instead\n", phydev->erasesize);
			erase_len = phydev->erasesize;
		}

        for (; erase_addr <erase_off + erase_len; erase_addr +=  phydev->erasesize) {
            memset(devops, 0x0, sizeof(struct phydev_ops));
            devops->addr = erase_addr;
            devops->len = phydev->erasesize;            
            devops->mode = NAND_HW_ECC;
            
             ret = phydev->block_isbad(phydev);
            if (ret > 0) {
                printf("\rSkipping bad block at 0x%08llx\n", erase_addr);
                continue;

            } else if (ret < 0) {
                printf("\n:AMLNAND get bad block failed: ret=%d at addr=%llx\n",ret, erase_addr);
                return -1;
            }
            
            ret = phydev->block_markbad(phydev);
            if (ret < 0)
                printf("AMLNAND bad block mark failed: %llx\n", erase_addr);    

        }
		printf("NAND %s %s\n", "MARKBAD", (ret <0) ? "ERROR" : "OK");
		return 0;
	}
    if(strcmp(cmd, "markbad_reserved") == 0){

		if(argc < 3){
			goto usage;
		}
		
		if (!(str2long(argv[2], (unsigned long*)markbad_reserved_addr))) {
			aml_nand_dbg("'%s' is not a number", argv[2]);
			goto usage;
		}
		printf("mark_reserved block:%d\n",*markbad_reserved_addr);
        ret = amlnf_markbad_reserved_ops(*markbad_reserved_addr);

		printf("NAND %s %s\n", "MARKBAD", (ret <0) ? "ERROR" : "OK");
		return 0;
	}
usage:
	cmd_usage(cmdtp);
	return 1;
}

U_BOOT_CMD(amlnf, CONFIG_SYS_MAXARGS, 1, do_amlnfphy,
	"AMLPHYNAND sub-system",
	"init - init amlnand_phy here\n"
	"chipinfo - show aml chip information\n"
	"device [dev] - show or set current device\n"
	"plane [dev] - show or set current plane mode\n"
	"read - addr off|partition size\n"
	"write - addr off|partition size\n"
	"    read/write 'size' bytes starting at offset 'off'\n"
	"    to/from memory address 'addr', skipping bad blocks.\n"
	"erase [clean|whole] [off size] - erase 'size' bytes from\n"
	"    offset 'off' (entire device if not specified)\n"
	"dump  addr off\n"
	"    show the raw data to addr at offset off\n"
	"read_byte - addr off|partition size\n"
	"write_byte - addr off|partition size\n"
	"    read_byte/write_byte 'size' bytes starting at offset 'off'\n"
	"    to/from memory address 'addr', skipping bad blocks.\n"
	"devread  - addr off|partition size\n"
	"devwrite - addr off|partition size\n"
	"    read/write 'size' bytes starting at offset 'off' in device[dev]\n"
	"    to/from memory address 'addr', skipping bad blocks.\n"
	"deverase [whole] [off size] - erase 'size' bytes from\n"
	"    offset 'off' (entire device if not specified) in device[dev]\n"  
	"markbad addr -mark block bad at addr\n"
	"mark_reserved reserved_blk_NO -mark reserved_blk_NO bad \n"
	"device name -get nftl device by name\n"
);


