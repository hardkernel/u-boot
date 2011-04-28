#include <common.h>
#include <malloc.h>
#include <asm/dma-mapping.h>
#include <asm/arch/io.h>
#include <asm/arch/sdio.h>
#include <mmc.h>
#include "mmc_storage.h"

struct list_head  storage_node_list;
struct mmc * storage_device = NULL;
int mmc_storage_test(struct mmc * mmc);

void print_storage_node_info(void)
{
	struct storage_node_t * node = NULL;

	list_for_each_entry(node,&storage_node_list,storage_list){
		store_msg("node->offset_addr %llx , node->timestamp %d ,node->valid_node_flag %d",\
			node->offset_addr, node->timestamp,node->valid_node_flag);
	}
	return;	
}

static void show_data_buf(unsigned char *data_buf)
{
	int i= 0;
	for(i=0;i<512;i++){
		store_msg("data_buf[%d] = %x",i,data_buf[i]);
	}
	return;
}

static unsigned  mmc_checksum(unsigned char *buf,unsigned int lenth)
{
	unsigned int checksum = 0;
	unsigned int cnt;
	for(cnt=0;cnt<lenth;cnt++){
		checksum += buf[cnt];
	}
	store_dbg("mmc_checksum : caculate checksum %d",checksum);
	return checksum;
}

static inline void init_magic(unsigned char * magic)
{
	unsigned char  *source_magic=MMC_STORAGE_MAGIC;
	int i=0;
	for(i = 0; i < 11; i++){
		magic[i] = source_magic[i];
	}
	return;
}

static int check_data(void * cmp)
{
	struct mmc_storage_head_t * head = (struct mmc_storage_head_t * )cmp;
	int ret =0;
	store_dbg("check_data :head->checksum = %d",head->checksum);
	if(head->checksum != mmc_checksum(&(head->data[0]),MMC_STORAGE_AREA_VALID_SIZE)){
		ret = -1;
		store_msg("mmc storage data check_sum failed\n");
	}

	if(!ret){
		store_dbg("mmc storage data check_sum OK\n");
	}
	return ret;

}

static int check_magic(void * cmp, unsigned char * magic)
{
	struct mmc_storage_head_t * head = (struct mmc_storage_head_t * )cmp;
	int ret =0, i = 0;

	for(i = 0; i < 11; i++ ){
		if(head->magic[i] != magic[i]){
			ret = -1;
			break;
		}
	}
	if(!ret)
	store_dbg("check_magic right");
	/*if(head->magic_checksum != mmc_checksum(&(head->magic),MMC_STORAGE_MAGIC_SIZE)){
		ret = -2;
	}*/
	
	return ret ;
}

static int storage_check(struct mmc *device, void * buf)
{
	struct mmc_storage_head_t * storage_data =(struct mmc_storage_head_t *)buf;
	unsigned char magic[MMC_STORAGE_MAGIC_SIZE];
	int ret = 0;
	
	init_magic(&magic[0]);
	store_dbg("storage_check :source magic : %s",magic);
	
	ret = check_magic(storage_data,&magic[0]);
	if(ret){
		store_msg("mmc read storage check magic name failed and ret = %d\n",ret);
		return ret;
	}

	ret = check_data(storage_data);
	if(ret){
		store_msg("mmc check data failed");
		return ret;
	}
	
	return 0;
}

int mmc_storage_read(struct mmc *device, unsigned char * buf, int len)
{
	struct mmc_storage_head_t storage_data;
	struct storage_node_t * storage_node = NULL;
	int part_num, n, blk, cnt, blk_shift, dev, ret = 0, read_len = 0;
	char valid_node_failed = 0;
	
	if(!device->mmc_storage_info->secure_valid){
		store_msg("mmc stoarge invaild : do not read");
		return - STORAGE_READ_FAILED;
	}
	
	part_num = 0;
	read_len = MMC_STORAGE_AREA_SIZE;
	blk_shift = ffs(device->read_bl_len) -1;
	dev = device->block_dev.dev;
	
	// read vaild node
	list_for_each_entry(storage_node,&storage_node_list,storage_list){
		if((storage_node != NULL) && (storage_node->valid_node_flag == 1)){
			memset((unsigned char *)&storage_data,0x0,sizeof(struct mmc_storage_head_t));
			blk = storage_node->offset_addr >> blk_shift;
			cnt = read_len >> blk_shift;
			n = device->block_dev.block_read(dev,blk, cnt, &storage_data);
			if(n != cnt){
				store_msg("storage read valid node failed");
				valid_node_failed  = 1;
			}
			ret = storage_check(device,&storage_data);
			if(ret){
				store_msg("storage check valid node failed");
				valid_node_failed  = 1;
			}
			if(!valid_node_failed){
				store_msg("mmc read storage ok at :  %llx",storage_node->offset_addr);
			}
		}
	}
		//store_dbg("show read buf :");
		//show_data_buf(&storage_data);
		
	// if vaild node failed ,read the bak node
	if(valid_node_failed){
		valid_node_failed = 0;
		list_for_each_entry(storage_node,&storage_node_list,storage_list){
			if((storage_node != NULL) && (storage_node->valid_node_flag == 0)){
				memset((unsigned char *)&storage_data,0x0,sizeof(struct mmc_storage_head_t));
				blk = storage_node->offset_addr >> blk_shift;
				cnt = read_len >> blk_shift;
				n = device->block_dev.block_read(dev,blk, cnt, &storage_data);
				if(n != cnt){
					store_msg("storage read free node failed");
					valid_node_failed  = 1;
				}
				ret = storage_check(device,&storage_data);
				if(ret){
					store_msg("storage check free node failed");
					valid_node_failed  = 1;
				}

				if(!valid_node_failed){
					store_msg("mmc read storage ok at :  %llx",storage_node->offset_addr);
				}
			}
		}
	}

	if(!valid_node_failed){
		memcpy(buf,&storage_data.data[0],len);
		ret = 0;
	}
	else{
		store_msg("mmc read storage failed at");
		ret = -STORAGE_READ_FAILED;
	}

	return ret;
}

int mmc_storage_write(struct mmc *device, unsigned char * buf, int len)
{
	struct mmc_storage_head_t storage_data;
	struct storage_node_t * storage_node = NULL;
	int part_num, n, blk, cnt, blk_shift, dev, ret = 0, write_len = 0;
	char write_failed_flag = 0;
	store_dbg("%s %d",__func__,__LINE__);

	part_num = 0;
	write_len = MMC_STORAGE_AREA_SIZE;
	blk_shift = ffs(device->write_bl_len) -1;
	dev = device->block_dev.dev;
	
	init_magic(&storage_data.magic[0]);
	
	storage_data.magic_checksum = mmc_checksum(&storage_data.magic[0],MMC_STORAGE_MAGIC_SIZE);
	
	storage_data.timestamp = 0;
	storage_data.version = 0;
	memcpy(&storage_data.data[0], buf, len);
	
	storage_data.checksum = mmc_checksum(&storage_data.data[0],MMC_STORAGE_AREA_VALID_SIZE);

	//show_data_buf(&storage_data);
	list_for_each_entry(storage_node,&storage_node_list,storage_list){
		if((storage_node != NULL) && (storage_node->valid_node_flag == 1)){
			storage_data.timestamp = storage_node->timestamp +1; //valid node
		}
	}
	
	list_for_each_entry(storage_node,&storage_node_list,storage_list){
		if((storage_node != NULL) && (part_num < MMC_STORAGE_AREA_COUNT)){
			write_failed_flag = 0;
			blk = storage_node->offset_addr >> blk_shift;
			cnt = write_len >> blk_shift;
			n = device->block_dev.block_write(dev,blk, cnt, &storage_data);
			if(n != cnt){
				store_msg("storage write part %d failed at %llx",part_num,storage_node->offset_addr);
				write_failed_flag = 1; 
			}
			part_num++;
			
			if(!write_failed_flag){
				device->mmc_storage_info->secure_valid = 1;
				store_msg("storage write part %d success at %llx", part_num,storage_node->offset_addr);
			}
		}
	}
	
	return ret;
}


int mmc_storage_init(struct mmc *device)
{
	struct mmc_storage_head_t *data_buf = NULL;
	struct mmc_storage_info_t storage_info;
	struct storage_node_t part0_node, part1_node;
	int cnt_num = 0, part_num = 0,ret = 0;
	int dev, n, blk, cnt, blk_shift;
	uint64_t addr = 0;

	data_buf = malloc(sizeof(struct mmc_storage_head_t));
	if(data_buf == NULL){
		store_msg("mmc_storage_init : data_buf malloc failed");
		goto exit;
	}
	memset(data_buf,0x0,(sizeof(struct mmc_storage_head_t)));

	blk_shift = ffs(device->read_bl_len) -1;
	dev = device->block_dev.dev;
	device->mmc_storage_info->secure_init = 1;
	part0_node.valid_flag  = 0;
	part1_node.valid_flag  = 0;
	part_num = MMC_STORAGE_AREA_COUNT;
	
	addr = MMC_STORAGE_OFFSET;
	for(cnt_num = 0; cnt_num < part_num; cnt_num++){

		blk = addr >> blk_shift;
		cnt = MMC_STORAGE_AREA_SIZE >> blk_shift;
		
		store_dbg("%s %d :  cnt_num %d , blk %d cnt %d blk_shift %d",__func__,__LINE__,cnt_num,blk,cnt,blk_shift);
		n = device->block_dev.block_read(dev,blk,cnt,data_buf);
		if(n != cnt){
			store_msg("storage read failed");
			addr += MMC_STORAGE_AREA_SIZE;
			continue;
		}
		//show_data_buf(data_buf);
		ret = storage_check(device,data_buf);
		if(ret){
			store_msg("storage check : invalid storage in addr %llx",addr);
		}else{
			device->mmc_storage_info->secure_valid = 1;
			if(cnt_num == 0){
				part0_node.offset_addr = addr;
				part0_node.timestamp = data_buf->timestamp;
				part0_node.valid_flag = 1;
			}else if(cnt_num == 1){
				part1_node.offset_addr = addr;
				part1_node.timestamp = data_buf->timestamp;
				part1_node.valid_flag = 1;
			}else{
				store_msg("wrong cnt_num %d",cnt_num);
				break;
			}
		}
		addr += MMC_STORAGE_AREA_SIZE;
	}

	if(device->mmc_storage_info->secure_valid == 1){
		
		if(part0_node.valid_flag && part1_node.valid_flag ){
			if(part0_node.timestamp >= part1_node.timestamp){
				memcpy(device->mmc_storage_info->valid_node,&part0_node,sizeof(struct storage_node_t));
				memcpy(device->mmc_storage_info->free_node,&part1_node,sizeof(struct storage_node_t));
			}else{
				memcpy(device->mmc_storage_info->valid_node,&part1_node,sizeof(struct storage_node_t));
				memcpy(device->mmc_storage_info->free_node,&part0_node,sizeof(struct storage_node_t));
			}

			device->mmc_storage_info->valid_node->valid_node_flag = 1; 
			device->mmc_storage_info->free_node->valid_node_flag = 0; 
			
			list_add_tail(&device->mmc_storage_info->valid_node->storage_list,&storage_node_list);
			list_add_tail(&device->mmc_storage_info->free_node->storage_list,&storage_node_list);

			store_msg("mmc  storage node0  addr = %llx and node1 addr = %llx",part0_node.offset_addr,part1_node.offset_addr);
		}else if(part0_node.valid_flag && (!part1_node.valid_flag)){

			memcpy(device->mmc_storage_info->valid_node,&part0_node,sizeof(struct storage_node_t));
			device->mmc_storage_info->valid_node->valid_node_flag = 1; 
			list_add_tail(&device->mmc_storage_info->valid_node->storage_list,&storage_node_list);

			part1_node.offset_addr = MMC_STORAGE_OFFSET + MMC_STORAGE_AREA_SIZE;
			part1_node.timestamp = 0;
			part1_node.valid_flag = 0;
			part1_node.valid_node_flag = 0;

			memcpy(device->mmc_storage_info->free_node,&part1_node,sizeof(struct storage_node_t));
			device->mmc_storage_info->free_node->valid_node_flag = 0; 
			list_add_tail(&device->mmc_storage_info->free_node->storage_list,&storage_node_list);

			store_msg("mmc storage node0 in mmc addr = %llx",part0_node.offset_addr);
		}else if(part1_node.valid_flag && (!part0_node.valid_flag)){

			memcpy(device->mmc_storage_info->valid_node,&part1_node,sizeof(struct storage_node_t));
			device->mmc_storage_info->valid_node->valid_node_flag = 1; 
			list_add_tail(&device->mmc_storage_info->valid_node->storage_list,&storage_node_list);

			part0_node.offset_addr = MMC_STORAGE_OFFSET;
			part0_node.timestamp = 0;
			part0_node.valid_flag = 0;
			part0_node.valid_node_flag = 0;

			memcpy(device->mmc_storage_info->free_node,&part0_node,sizeof(struct storage_node_t));
			device->mmc_storage_info->free_node->valid_node_flag = 0; 
			list_add_tail(&device->mmc_storage_info->free_node->storage_list,&storage_node_list);

			store_msg("mmc storage node1 in mmc addr = %llx",part1_node.offset_addr);
		}
	}
	else{
		store_msg("##mmc do not find storage##");
	}
	
exit:

	if(data_buf){		
		free(data_buf);
		data_buf = NULL;
	}
	
	return 0;
}

int mmc_storage_check(struct mmc *device)
{
	unsigned char *data_buf = NULL;
	int ret = 0,len;
	
	device->mmc_storage_info->secure_valid = 0;
	device->mmc_storage_info->secure_init= 0;
	device->storage_protect = 1;
	ret = mmc_storage_init(device);
	if(ret){
		store_msg("mmc_storage_init failed");
		goto exit_error;
	}

	if(device->mmc_storage_info->secure_valid == 0){
		

		device->mmc_storage_info->valid_node->offset_addr = MMC_STORAGE_OFFSET;
		device->mmc_storage_info->valid_node->valid_node_flag = 1;
		device->mmc_storage_info->valid_node->timestamp = 0;
		device->mmc_storage_info->valid_node->valid_flag = 0;
		list_add_tail(&device->mmc_storage_info->valid_node->storage_list,&storage_node_list);

		device->mmc_storage_info->free_node->offset_addr = MMC_STORAGE_OFFSET + MMC_STORAGE_AREA_SIZE;
		device->mmc_storage_info->free_node->valid_node_flag = 0;
		device->mmc_storage_info->free_node->timestamp = 0;
		device->mmc_storage_info->free_node->valid_flag = 0;
		list_add_tail(&device->mmc_storage_info->free_node->storage_list,&storage_node_list);

		data_buf = malloc(MMC_STORAGE_AREA_VALID_SIZE);
		if(data_buf == NULL){
			store_msg("mmc_storage_check : data_buf malloc failed");
			goto exit_error;
		}
		memset(data_buf,0x0,MMC_STORAGE_AREA_VALID_SIZE);
		len = MMC_STORAGE_AREA_VALID_SIZE;
		
		ret =  mmc_storage_write(device,data_buf,len);
		if(ret){
			store_msg("mmc_storage_write failed");
			ret = -STORAGE_WRITE_FAILED;
			goto exit_error;
		}
	}

exit_error:

	if(data_buf){
		free(data_buf);
		data_buf = NULL;
	}
	
	return ret;
}

static void storage_buf_free(struct mmc *device)
{

	if(device->mmc_storage_info->valid_node ){
		free(device->mmc_storage_info->valid_node );
		device->mmc_storage_info->valid_node  = NULL;
	}

	if(device->mmc_storage_info->free_node){
		free(device->mmc_storage_info->free_node);
		device->mmc_storage_info->free_node = NULL;
	}

	if(device->mmc_storage_info){
		free(device->mmc_storage_info);
		device->mmc_storage_info = NULL;
	}
	
}

static int storage_buf_malloc(struct mmc *device)
{
	int ret = 0;
	device->mmc_storage_info = malloc(sizeof(struct mmc_storage_info_t));
	if(device->mmc_storage_info == NULL){
		ret = -MMC_MALLOC_FAILED;
		goto exit_error;
	}
	memset(device->mmc_storage_info,0x0,sizeof(struct mmc_storage_info_t));
	device->mmc_storage_info->valid_node = malloc(sizeof(struct storage_node_t));
	if(device->mmc_storage_info->valid_node == NULL){
		ret = -MMC_MALLOC_FAILED;
		goto exit_error;
	}
	
	memset(device->mmc_storage_info->valid_node ,0x0,sizeof(struct storage_node_t));
	device->mmc_storage_info->free_node = malloc(sizeof(struct storage_node_t));
	if(device->mmc_storage_info->free_node == NULL){
		ret = -MMC_MALLOC_FAILED;
		goto exit_error;
	}
	memset(device->mmc_storage_info->free_node ,0x0,sizeof(struct storage_node_t));

	return ret;
	
exit_error:

	if(device->mmc_storage_info){
		free(device->mmc_storage_info);
		device->mmc_storage_info = NULL;
	}
	if(device->mmc_storage_info->valid_node){
		free(device->mmc_storage_info->valid_node );
		device->mmc_storage_info->valid_node  = NULL;
	}
	if(device->mmc_storage_info->free_node){
		free(device->mmc_storage_info->free_node);
		device->mmc_storage_info->free_node = NULL;
	}
	
	return ret;
}

int mmc_storage_probe(struct mmc* mmc)
{
	int ret = 0;
	struct mmc *mmc_device = mmc;
	store_msg("%s %d",__func__,__LINE__);

	ret = storage_buf_malloc(mmc_device);
	if(ret){
		store_msg("mmc storage malloc failed");
		goto exit_error;
	}
	INIT_LIST_HEAD(&storage_node_list);
	
	ret = mmc_storage_check(mmc_device);
	if(ret){
		store_msg("mmc storage check failed");
		goto exit_error;
	}
	storage_device = mmc_device;

#ifdef MMC_STORAGE_DEBUG
	//print_storage_node_info();
	store_msg("mmc storage test:");
	mmc_storage_test(mmc);
#endif

	return ret;
	
exit_error:

	storage_buf_free(mmc);
	return ret;
}


int mmc_storage_exit(void * mmc)
{
	int ret =0;
	
	storage_buf_free(mmc);

	return ret;
}

// wr_flag : 0 read / 1 write
int mmc_secure_storage_ops(unsigned char * buf, int len, int wr_flag)
{
	struct mmc *device = storage_device;
	int err, right_port = 0;

	mmc_init(device);
	
	if(len > MMC_STORAGE_AREA_VALID_SIZE){
		store_msg("mmc secure storage ops fail,len 0x%x is bigger than 0x%x,%s:%d",len,MMC_STORAGE_AREA_VALID_SIZE,__func__,__LINE__);
		return -1;
	}

	if(!device){
		store_msg("mmc secure storage ops failed, NO storage_device");
		return -1;
	}

	if(wr_flag){ // write
		err = mmc_storage_write(device,buf, len);
		if(err){
			store_msg("secure_storage_mmc_ops write failed");
		}
	}else{ //read
		err = mmc_storage_read(device,buf, len);
		if(err){
			store_msg("secure_storage_mmc_ops read failed");
		}
	}
	
	return err;
}

#ifdef MMC_STORAGE_DEBUG

int mmc_storage_test(struct mmc * mmc)
{
	unsigned char * buf = NULL;
	unsigned char * cmp = NULL;
	int ret = 0;


	buf = malloc(MMC_STORAGE_AREA_VALID_SIZE);
	if(!buf){
		store_msg("mmc_storage_test : malloc failed");
		return -1;
	}
	memset(buf,0xa5,MMC_STORAGE_AREA_VALID_SIZE);

	cmp = malloc(MMC_STORAGE_AREA_VALID_SIZE);
	if(!cmp){
		store_msg("mmc_storage_test : malloc failed");
		return -1;
	}
	memset(cmp,0x0,MMC_STORAGE_AREA_VALID_SIZE);
	store_msg("mmc_storage_test : write ");

	//write
	ret  = mmc_secure_storage_ops(buf,MMC_STORAGE_AREA_VALID_SIZE,1);
	if(ret){
		store_msg("mmc_storage_test : ops write failed");
		return -1;
	}
	
	store_msg("mmc_storage_test : read ");
	//read
	ret  = mmc_secure_storage_ops(cmp,MMC_STORAGE_AREA_VALID_SIZE,0);
	if(ret){
		store_msg("mmc_storage_test : ops read failed");
		return -1;
	}
	//show_data_buf(cmp);
	if(memcmp(buf,cmp,MMC_STORAGE_AREA_VALID_SIZE)){
		store_msg("mmc storage test :  failed");
		return -1;
	}
	if(!ret)
	store_msg("mmc storage test :  right");

	return ret;
}

#endif
int secure_storage_emmc_read(char *buf,unsigned int len)
{
	return mmc_secure_storage_ops(buf, len, 0);
}
int secure_storage_emmc_write(char *buf,unsigned int len)
{
	return mmc_secure_storage_ops(buf, len, 1);
}

