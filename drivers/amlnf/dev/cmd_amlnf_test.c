
#include "../include/phynand.h"

extern int amlnand_init(unsigned char flag);
extern void amlchip_dumpinfo(struct amlnand_chip *aml_chip);
extern void amldev_dumpinfo(struct amlnand_phydev *phydev);
static int plane_mode = 0;
struct aml_nftl_dev * nftl_device;

//just like memset function but the paraments' type is  little different
void * memset_nand_test(void * s, unsigned long c,size_t count)
{
	unsigned long *sl = (unsigned long *) s;
	unsigned long cl = 0;
	char *s8;
	int i;

	/* do it one word at a time (32 bits or 64 bits) while possible */
	if ( ((ulong)s & (sizeof(*sl) - 1)) == 0) {

		for (i = 0; i < sizeof(*sl); i++) {
			cl <<= 8;
			cl |= c & 0xff;
			c =c >>8;
		}
		while (count >= sizeof(*sl)) {
			*sl++ = cl;
			count -= sizeof(*sl);
		}
	}
	/* fill 8 bits at a time */
	/*s8 = (char *)sl;            //this can write one byte 
	while (count--)
		*s8++ = c;*/

	return s;
}
static int nand_erase_ops_test(struct amlnand_phydev *phydev, uint64_t off, uint64_t len)
{
	struct amlnand_chip *aml_chip = phydev->priv;	
	struct phydev_ops *devops = &(phydev->ops);
	struct hw_controller *controller = &(aml_chip->controller); 
	struct chip_operation *operation = &(aml_chip->operation);	
	struct chip_ops_para *ops_para = &(aml_chip->ops_para);

	uint64_t addr, erase_addr, erase_len, erase_off;
	int ret = 0;
	
	erase_addr = erase_off = off;
	erase_len = len ;
	
	if((erase_off+erase_len) > phydev->size ){
		aml_nand_msg("nand write size is out of space");
		ret= -NAND_ERASE_FAILED;
		goto exit_error;
	}

	for (; erase_addr < erase_off + erase_len; erase_addr +=  phydev->erasesize) {
		
		memset(devops, 0x0, sizeof(struct phydev_ops));
		devops->addr = erase_addr;
		devops->len = phydev->erasesize;			
		devops->mode = NAND_HW_ECC;
		
		 ret = phydev->block_isbad(phydev);
		if (ret > 0) {
			aml_nand_msg("Skipping bad block at 0x%08llx", erase_addr);
			continue;

		} else if (ret < 0) {
			aml_nand_msg("nand get bad block failed: ret=%d at addr=%llx",ret, erase_addr);
			ret =  -NAND_ERASE_FAILED;
		}
		
		ret = nand_erase(phydev);
		if (ret < 0){
			aml_nand_msg("nand Erase failure: %d %llx", ret, erase_addr);
			ret =  -NAND_ERASE_FAILED;
		}		
	}


exit_error:

	return ret;
}

static int nand_read_ops_test(struct amlnand_phydev *phydev,uint64_t off , uint64_t len , unsigned char * dat_buf)
{
	struct amlnand_chip *aml_chip =phydev->priv;	
	struct phydev_ops *devops = &(phydev->ops);
	uint64_t offset , write_len;
	unsigned char * buffer = NULL;
	int ret = 0;

	offset = off;
	write_len = len;
	buffer = aml_nand_malloc(2 * phydev->writesize);
	if(!buffer){
		aml_nand_msg("nand read test malloc failed");
		ret = -NAND_READ_FAILED;
		goto exit_error;
	}
	
	if(!dat_buf){
		aml_nand_msg("nand read no buf");
		return -NAND_READ_FAILED;
	}

	if ((offset & (phydev->writesize - 1)) != 0 ||(write_len & (phydev->writesize - 1)) != 0){
		aml_nand_msg ("Attempt to read non page aligned data");
		return -NAND_READ_FAILED;
	}

	if((offset + write_len) > phydev->size){
		aml_nand_msg("Attemp to read out side the dev area");		
		return -NAND_READ_FAILED;
	}
	memset(devops, 0x0, sizeof(struct phydev_ops));
	devops->addr = offset;
	devops->len = phydev->writesize;
	devops->datbuf = buffer;
	devops->oobbuf = NULL;
	devops->mode = NAND_HW_ECC;
	aml_nand_dbg("phydev->writesize= %x",phydev->writesize);		
	do{ 	
		if((devops->addr % phydev->erasesize) == 0 ){
			ret =  phydev->block_isbad(phydev);
			if (ret > 0){
				aml_nand_msg("Skipping bad block at %llx", devops->addr);
				devops->addr += phydev->erasesize;
				continue;
			} else if (ret < 0) {
				aml_nand_msg("AMLNAND get bad block failed: ret=%d at addr=%llx",ret, devops->addr);
				return -1;
			}
		}
		memset(buffer,0x0,(2 * phydev->writesize));
		ret = phydev->read(phydev);
		if((ret)){
			aml_nand_msg("nand read failed at %llx",devops->addr);
		}
		if(memcmp(buffer,dat_buf,phydev->writesize)){
			aml_nand_msg("nand read test verify failed");
			break;
		}
		devops->addr +=  phydev->writesize;
		
	}while(devops->addr < (offset + write_len));


exit_error:
	
	if(buffer){
		aml_nand_free(buffer);
	}

	return ret;
}
static int nand_read_oob_ops_test(struct amlnand_phydev *phydev,uint64_t off , uint64_t len , unsigned char * dat_buf)
{
	struct amlnand_chip *aml_chip =phydev->priv;	
	struct phydev_ops *devops = &(phydev->ops);
	uint64_t offset , write_len;
	unsigned char * buffer = NULL;
	int ret = 0;

	offset = off;
	write_len = len;
	buffer = aml_nand_malloc(2 * phydev->writesize);
	if(!buffer){
		aml_nand_msg("nand read oob test malloc failed");
		ret = -NAND_READ_FAILED;
		goto exit_error;
	}
	
	if(!dat_buf){
		aml_nand_msg("nand read oob no buf");
		return -NAND_READ_FAILED;
	}

	if ((offset & (phydev->writesize - 1)) != 0 ||(write_len & (phydev->writesize - 1)) != 0){
		aml_nand_msg ("Attempt to read non page aligned data");
		return -NAND_READ_FAILED;
	}

	if((offset + write_len) > phydev->size){
		aml_nand_msg("Attemp to read out side the dev area");		
		return -NAND_READ_FAILED;
	}
	memset(devops, 0x0, sizeof(struct phydev_ops));
	devops->addr = offset;
	devops->len = phydev->writesize;
	devops->datbuf = NULL;
	devops->oobbuf = buffer;
	devops->mode = NAND_HW_ECC;
	aml_nand_dbg("phydev->writesize= %x",phydev->writesize);		
	do{ 	
		if((devops->addr % phydev->erasesize) == 0 ){
			ret =  phydev->block_isbad(phydev);
			if (ret > 0){
				aml_nand_msg("Skipping bad block at %llx", devops->addr);
				devops->addr += phydev->erasesize;
				continue;
			} else if (ret < 0) {
				aml_nand_msg("AMLNAND get bad block failed: ret=%d at addr=%llx",ret, devops->addr);
				return -1;
			}
		}
		memset(buffer,0x0,(2 * phydev->writesize));
		ret = phydev->read_oob(phydev);
		if((ret)){
			aml_nand_msg("nand read oob failed at %llx",devops->addr);
		}
		if(memcmp(buffer,dat_buf,phydev->writesize)){
			aml_nand_msg("nand read oob test verify failed");
			break;
		}
		devops->addr +=  phydev->writesize;
		
	}while(devops->addr < (offset + write_len));


exit_error:
	
	if(buffer){
		aml_nand_free(buffer);
	}

	return ret;
}

static int nand_write_ops_test(struct amlnand_phydev *phydev , uint64_t off, uint64_t len, unsigned char * dat_buf, int flag)
{	
	struct amlnand_chip *aml_chip = phydev->priv;	
	struct phydev_ops *devops = &(phydev->ops);
	unsigned char * verify_buf =NULL;
	unsigned char * buffer = NULL;
	uint64_t offset , write_len;
	int ret = 0;

	offset = off;
	write_len = len;
	buffer = dat_buf;
	
	if(!buffer){
		aml_nand_msg("nand write no buf");
		return -NAND_WRITE_FAILED;
	}
	
	if ((offset & (phydev->writesize - 1)) != 0 ||(write_len & (phydev->writesize - 1)) != 0) {
		aml_nand_msg ("Attempt to write non page aligned data");
		return -NAND_WRITE_FAILED;
	}

	if((offset + write_len) > phydev->size){
		aml_nand_msg("Attemp to write out side the dev area : %llx, %llx",(offset + write_len),phydev->size);		
		return -NAND_WRITE_FAILED;
	}
	
	if(flag == 1){
		verify_buf = aml_nand_malloc(2*phydev->writesize);
		if(!verify_buf){
			aml_nand_msg("Attemp to write out side the dev area");
			ret =  -NAND_WRITE_FAILED;
			goto exit_error;
		}
	}
	memset(devops, 0x0, sizeof(struct phydev_ops));
	devops->addr = offset;
	devops->len = phydev->writesize;
	devops->datbuf = buffer;		
	devops->oobbuf = NULL;
	devops->mode = NAND_HW_ECC;
	aml_nand_dbg("phydev->writesize= %x",phydev->writesize);
	do{
		if((devops->addr % phydev->erasesize) == 0 ){
			ret =  phydev->block_isbad(phydev);
			if (ret > 0){
				aml_nand_msg("Skipping bad block at %llx", devops->addr);
				devops->addr += phydev->erasesize;
				continue;
			} else if (ret < 0) {
				aml_nand_msg("AMLNAND get bad block failed: ret=%d at addr=%llx",ret, devops->addr);
				return -1;
			}
		}
		ret = phydev->write(phydev);
		if(ret < 0){
			aml_nand_msg("nand write failed at %llx",devops->addr);
			ret = -NAND_WRITE_FAILED;
			goto exit_error;
		}

		if(flag == 1){ // verify data
			memset(verify_buf, 0x0, (2*phydev->writesize));
			devops->datbuf = verify_buf;
			ret = phydev->read(phydev);
			if(ret){
				aml_nand_msg("nand test read data failed at  %llx",devops->addr);
				ret = -NAND_WRITE_FAILED;
				goto exit_error;
			}
			if(memcmp(verify_buf, buffer, phydev->writesize)){
				aml_nand_msg("nand test verify data failed at  %llx",devops->addr);
				ret = -NAND_WRITE_FAILED;
				goto exit_error;
			}
			devops->datbuf = buffer;
		}
		
		devops->addr +=  phydev->writesize;
		
		if((((phydev->offset + devops->addr) % phydev->erasesize)==0))
			aml_nand_msg("aml nand write devops->addr %llx OK",devops->addr);
		
	}while(devops->addr < (offset + write_len));

	
exit_error:
	
	if(flag == 1){
		if(verify_buf){
			aml_nand_free(verify_buf);
		}
	}
	return ret;
}
//nand_test  4 write and read  every block test
static int amlnand_test4()
{
    struct amlnand_phydev *phydev = NULL;
    struct amlnand_chip *aml_chip;
    struct phydev_ops  *devops;

    int ret =0, i = 0,j = 0, verify_lag  =0;
    unsigned char * data_buf = NULL;
    uint64_t offset = 0 , write_len = 0,read_len=0;
    uint64_t addr, off, size, chipsize, erase_addr, erase_len, erase_off;
    
    list_for_each_entry(phydev,&nphy_dev_list,list){
        data_buf = aml_nand_malloc( phydev->writesize);
        if(!data_buf){
            aml_nand_msg("malloc failed");
            goto exit_0;
        }
    memset(data_buf, 0xa5, phydev->writesize);
    if(strncmp(phydev->name,NAND_BOOT_NAME,strlen((const char*)NAND_BOOT_NAME))){
        aml_nand_msg("nand test 4 : phydev->name %s",phydev->name);
        aml_chip = (struct amlnand_chip *)phydev->priv;
        devops = &phydev->ops;
//erase
        erase_off = 0;
        erase_len = phydev->size ;
        ret = nand_erase_ops_test(phydev, erase_off, erase_len);
        if(ret < 0){
            aml_nand_msg("nand test 4 : erase failed ");
            ret= -NAND_ERASE_FAILED;
            goto exit_0;
        }
        aml_nand_msg("nand test 4 : erase %d times OK ",j);
//write
        offset = 0;
        write_len =  phydev->size;
        verify_lag = 0;  // 1 indicate verify data when write
        ret = nand_write_ops_test(phydev, offset, write_len,data_buf,verify_lag);
        if(ret < 0 ){
            aml_nand_msg("nand test 4 : write failed ");
            ret= -NAND_WRITE_FAILED;
            goto exit_0;
        }   
        aml_nand_msg("nand test 4 : write %d times OK ",j);
//read disturb
        offset = 0;
        read_len =  phydev->size;
        ret = nand_read_ops_test(phydev, offset, read_len,data_buf);
        if(ret < 0 ){
            aml_nand_msg("nand test 4 : read failed ");
            ret= -NAND_READ_FAILED;
            goto exit_0;
        }
        aml_nand_msg("nand test 4 : read %d times OK ",j);
    }    
    if (data_buf) 
       {
        kfree(data_buf);
        data_buf = NULL;
       }
    }

exit_0:
    if (data_buf) {
        kfree(data_buf);
        data_buf = NULL;
    }

    return ret;
    
}

static int amlnand_test3()
{
    struct amlnand_phydev *phydev = NULL;
    struct amlnand_chip *aml_chip;
    struct phydev_ops  *devops;

    int ret =0,j = 0, verify_lag  =0;
    unsigned char * data_buf = NULL;
    uint64_t offset = 0 , write_len = 0,read_len=0, i = 0;
    uint64_t addr, off, size, chipsize, erase_addr, erase_len, erase_off;
    
    list_for_each_entry(phydev,&nphy_dev_list,list){
        data_buf = aml_nand_malloc( phydev->writesize);
        if(!data_buf){
            aml_nand_msg("malloc failed");
            goto exit_0;
        }
    memset(data_buf, 0xa5, phydev->writesize);
    if(strncmp(phydev->name,NAND_BOOT_NAME,strlen((const char*)NAND_BOOT_NAME))){
        aml_nand_msg("nand test 3 : phydev->name %s",phydev->name);
        aml_chip = (struct amlnand_chip *)phydev->priv;
        devops = &phydev->ops;
        aml_nand_msg("nand test 3 : phydev->size=%llx ",phydev->size);
//erase
        erase_off = 0;
        erase_len = phydev->size ;
        ret = nand_erase_ops_test(phydev, erase_off, erase_len);
        if(ret < 0){
            aml_nand_msg("nand test 3 : erase failed ");
            ret= -NAND_ERASE_FAILED;
            goto exit_0;
        }
        aml_nand_msg("nand test 3 : erase OK ");
        for(i=0;i<(phydev->size>>phydev->erasesize_shift)-1;i++){
    //write
            offset = i<<phydev->erasesize_shift;
            write_len =  (i&0xff)*phydev->writesize;
            verify_lag = 0;  // 1 indicate verify data when write
            aml_nand_msg("nand test 3 : poffset=%llx ",offset);
            ret = nand_write_ops_test(phydev, offset, write_len,data_buf,verify_lag);
            if(ret < 0 ){
                aml_nand_msg("nand test 3 : write failed ");
                ret= -NAND_WRITE_FAILED;
                goto exit_0;
            }   
            aml_nand_msg("nand test 3 : write OK ");
    //read disturb
            offset = i<<phydev->erasesize_shift;
            read_len =  (i&0xff)*phydev->writesize;
            ret = nand_read_ops_test(phydev, offset, read_len,data_buf);
            if(ret < 0 ){
                aml_nand_msg("nand test 3 : read failed ");
                ret= -NAND_READ_FAILED;
                goto exit_0;
            }
            aml_nand_msg("nand test 3 : read OK ");
        }
    }    
    if (data_buf) 
       {
        kfree(data_buf);
        data_buf = NULL;
       }
    }

exit_0:
    if (data_buf) {
        kfree(data_buf);
        data_buf = NULL;
    }

    return ret;
    
}

//nand_test  2 Endurance test  
static int amlnand_test2()
{
    struct amlnand_phydev *phydev = NULL;
    struct amlnand_chip *aml_chip;
    struct phydev_ops  *devops;

    int ret =0, i = 0,j = 0, verify_lag  =0;
    unsigned char * data_buf = NULL;
    uint64_t offset = 0 , write_len = 0,read_len=0;
    uint64_t addr, off, size, chipsize, erase_addr, erase_len, erase_off;
    int read_times  = 1000;
    
    list_for_each_entry(phydev,&nphy_dev_list,list){
        data_buf = aml_nand_malloc( phydev->writesize);
        if(!data_buf){
            aml_nand_msg("malloc failed");
            goto exit_0;
        }
        for(j=1;j<3000;j++)
        {
            memset(data_buf, 0xa5, phydev->writesize);
        if(strncmp(phydev->name,NAND_BOOT_NAME,strlen((const char*)NAND_BOOT_NAME))){
            aml_nand_msg("nand test 2 : phydev->name %s",phydev->name);
            aml_chip = (struct amlnand_chip *)phydev->priv;
            devops = &phydev->ops;
//erase
            erase_off = 0;
            erase_len = phydev->size ;
            ret = nand_erase_ops_test(phydev, erase_off, erase_len);
            if(ret < 0){
                aml_nand_msg("nand test 2 : erase failed ");
                ret= -NAND_ERASE_FAILED;
                goto exit_0;
            }
            aml_nand_msg("nand test 2 : erase %d times OK ",j);
//write
            offset = 0;
            write_len =  phydev->size;
            verify_lag = 0;  // 1 indicate verify data when write
            ret = nand_write_ops_test(phydev, offset, write_len,data_buf,verify_lag);
            if(ret < 0 ){
                aml_nand_msg("nand test 2 : write failed ");
                ret= -NAND_WRITE_FAILED;
                goto exit_0;
            }   
            aml_nand_msg("nand test 2 : write %d times OK ",j);
//read disturb
            offset = 0;
            read_len =  phydev->size;
            ret = nand_read_ops_test(phydev, offset, read_len,data_buf);
            if(ret < 0 ){
                aml_nand_msg("nand test 2 : read failed ");
                ret= -NAND_READ_FAILED;
                goto exit_0;
            }
            aml_nand_msg("nand test 2 : read %d times OK ",j);
        }
     }       
    if (data_buf) 
       {
        kfree(data_buf);
        data_buf = NULL;
       }
    }

exit_0:
    if (data_buf) {
        kfree(data_buf);
        data_buf = NULL;
    }

    return ret;


}
//nand_test  1 Read Distub test
static int amlnand_test1(void)
{	
	struct amlnand_phydev *phydev = NULL;
	struct amlnand_chip *aml_chip;
	struct phydev_ops  *devops;

	int ret =0, i = 0, verify_lag  =0;
	unsigned char * data_buf = NULL;
	uint64_t offset = 0 , write_len = 0,read_len=0;
	uint64_t addr, off, size, chipsize, erase_addr, erase_len, erase_off;
	int read_times  = 10000;
	
	list_for_each_entry(phydev,&nphy_dev_list,list){
		data_buf = aml_nand_malloc( phydev->writesize);
		if(!data_buf){
			aml_nand_msg("malloc failed");
			goto exit_0;
		}
		memset(data_buf, 0xa5, phydev->writesize);

		if(strncmp(phydev->name,NAND_BOOT_NAME,strlen((const char*)NAND_BOOT_NAME))){
			aml_nand_msg("nand test 1 : phydev->name %s",phydev->name);
			aml_chip = (struct amlnand_chip *)phydev->priv;
			devops = &phydev->ops;
//erase
			erase_off = 0;
			erase_len = phydev->size ;
			ret = nand_erase_ops_test(phydev, erase_off, erase_len);
			if(ret < 0){
				aml_nand_msg("nand test 1 : erase failed ");
				ret= -NAND_ERASE_FAILED;
				goto exit_0;
			}
            aml_nand_msg("nand test 1 : erase OK");
//write
			offset = 0;
			write_len =  phydev->size;
			verify_lag = 0;  // 1 indicate verify data when write
			ret = nand_write_ops_test(phydev, offset, write_len,data_buf,verify_lag);
			if(ret < 0 ){
				aml_nand_msg("nand test 1 : write failed ");
				ret= -NAND_WRITE_FAILED;
				goto exit_0;
			}
            aml_nand_msg("nand test 1 : write OK");
//read disturb
			for(i = 0; i < read_times; i++){
				offset = 0;
				read_len =	4*phydev->erasesize;
				ret = nand_read_ops_test(phydev, offset, read_len,data_buf);
				if(ret < 0 ){
					aml_nand_msg("nand test 1 : read failed ");
					ret= -NAND_WRITE_FAILED;
					goto exit_0;
				}
                aml_nand_msg("nand test 1 : read %d times OK",i);
			}
			
//erase
			erase_off = 0;
			erase_len = phydev->size ;
			ret = nand_erase_ops_test(phydev, erase_off, erase_len);
			if(ret < 0){
				aml_nand_msg("nand test 1 : erase failed ");
				ret= -NAND_ERASE_FAILED;
				goto exit_0;
			}

		}
		
		if (data_buf) {
			kfree(data_buf);
			data_buf = NULL;
		}

	}

exit_0:
	if (data_buf) {
		kfree(data_buf);
		data_buf = NULL;
	}

	return ret;
}
//nand_test  0 E/P/R Cycle Whole chip
static int amlnand_test0(void)
{	
	struct amlnand_phydev *phydev = NULL;
	struct amlnand_chip *aml_chip;
	struct phydev_ops  *devops;

	int ret =0, i = 0, verify_lag  =0;
	unsigned char * data_buf = NULL;
	uint64_t offset = 0 , write_len = 0,read_len=0;
	uint64_t addr, off, size, chipsize, erase_addr, erase_len, erase_off;

	list_for_each_entry(phydev,&nphy_dev_list,list){

		data_buf = aml_nand_malloc(phydev->writesize);
		if(!data_buf){
			aml_nand_msg("malloc failed");
			ret = -1;
			goto exit_0;
		}
		memset(data_buf, 0xa5, phydev->writesize);

		if(strncmp(phydev->name,NAND_BOOT_NAME,strlen((const char*)NAND_BOOT_NAME))){
			aml_nand_msg("nand test 0 : phydev->name %s",phydev->name);
			aml_chip = (struct amlnand_chip *)phydev->priv;
			devops = &phydev->ops;
//erase
			aml_nand_msg("nand test 0 : erase");
			erase_off = 0;
			erase_len = phydev->size ;
			ret = nand_erase_ops_test(phydev, erase_off, erase_len);
			if(ret < 0){
				aml_nand_msg("nand test 0 : erase failed ");
				ret= -NAND_ERASE_FAILED;
				goto exit_0;
			}
//write
			aml_nand_msg("nand test 0 : write");
			offset = 0;
			write_len =  phydev->size;
			verify_lag = 0;  // 1 indicate verify data when write
			ret = nand_write_ops_test(phydev, offset, write_len,data_buf,verify_lag);
			if(ret < 0 ){
				aml_nand_msg("nand test 0 : write failed ");
				ret= -NAND_WRITE_FAILED;
				goto exit_0;
			}	
//read
			aml_nand_msg("nand test 0 : read");
			offset = 0;
			read_len =  phydev->size;
			ret = nand_read_ops_test(phydev, offset, read_len,data_buf);
			if(ret < 0 ){
				aml_nand_msg("nand test 0 : read failed ");
				ret= -NAND_WRITE_FAILED;
				goto exit_0;
			}
//erase
			erase_off = 0;
			erase_len = phydev->size ;
			ret = nand_erase_ops_test(phydev, erase_off, erase_len);
			if(ret < 0){
				aml_nand_msg("nand test 0 : erase failed ");
				ret= -NAND_ERASE_FAILED;
				goto exit_0;
			}

		}
		
		if (data_buf) {
			kfree(data_buf);
			data_buf = NULL;
		}
	}

exit_0:
	if (data_buf) {
		kfree(data_buf);
		data_buf = NULL;
	}

	return ret;
}


int do_amlnand_test(cmd_tbl_t * cmdtp, int flag, int argc, char *argv[])
{
	int i, ret = 0;
	ulong addr;
	ulong data_write;
	loff_t off, size;
	char *cmd;

	if (argc < 2){
		printf("argc less than 2 :\n");
		goto usage;
	}
	
	cmd = argv[1];

	if (strncmp(cmd, "0", 1) == 0){
		ret = amlnand_test0();
		if(ret < 0){
			aml_nand_msg("amlnand_test0: E/P/R Cycle failed");
		}else
			aml_nand_msg("amlnand_test0: E/P/R Cycle OK");
		return 0;
	}else if (strncmp(cmd, "1", 1) == 0){
		ret = amlnand_test1();
		if(ret < 0){
			aml_nand_msg("amlnand_test1: Read Distub test failed");
		}else
			aml_nand_msg("amlnand_test1: Read Distub test OK");
		return 0;
	}else if (strncmp(cmd, "2", 1) == 0){
		ret = amlnand_test2();
		if(ret < 0){
			aml_nand_msg("amlnand_test2: Endurance test failed");
		}else
			aml_nand_msg("amlnand_test2: Endurance test OK");
		return 0;
	}else if (strncmp(cmd, "3", 1) == 0){
		ret = amlnand_test3();
		if(ret < 0){
			aml_nand_msg("amlnand_test3: write and read random pages of every block test failed");
		}else
			aml_nand_msg("amlnand_test3: write and read random pages of every block test OK");

		return 0;
	}else if (strncmp(cmd, "4", 1) == 0){
		ret = amlnand_test4();
		if(ret < 0){
			aml_nand_msg("amlnand_test4: READ all page  every block test failed");
		}else
			aml_nand_msg("amlnand_test4: READ all page  every block test OK");

		return 0;
	}else{
			goto usage;
	}	

usage:
	cmd_usage(cmdtp);
	return 1;

}

U_BOOT_CMD(amlnf_test, CONFIG_SYS_MAXARGS, 1, do_amlnand_test,
	"AMLPHYNAND sub-system",
	"amlnf_test  0 E/P/R Cycle Whole chip \n"
	"amlnf_test  1 Read Distub test,read block 0~3 10k times \n"
	"amlnf_test  2 Endurance test, E/W/R 10 block 3000 times  \n"
	"amlnf_test  3 write and read random pages of every block test \n"
	"amlnf_test  4 READ all page every block   \n"
	"amlnf_test  5 ...... \n"
	"amlnf_test  8 exit sync \n"
);


