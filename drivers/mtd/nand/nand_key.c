#include <common.h>
#include <environment.h>
#include <nand.h>
#include <asm/io.h>
#include <asm/arch/nand.h>
#include <malloc.h>
#include <linux/err.h>
#include <asm/cache.h>
#include <asm/arch/pinmux.h>
#include <asm/arch/reboot.h>
#include <amlogic/securitykey.h>

#include <linux/mtd/mtd.h>
#include <linux/mtd/nand.h>
#include <linux/mtd/nand_ecc.h>

//#define TEST_ERROR_ADDRESS_BLOCK

#define debug(fmt,args...) do { printk("[DEBUG]: FILE:%s:%d, FUNC:%s--- "fmt"\n",\
                                                     __FILE__,__LINE__,__func__,## args);} \
                                         while (0)
#define NAND_KEY_RD_ERR         2
#define NAND_KEY_CONFIG_ERR     3

#define KEYSIZE (CONFIG_KEYSIZE - (sizeof(uint32_t)))
typedef	struct  {
	uint32_t	crc;		/* CRC32 over data bytes	*/
	unsigned char	data[KEYSIZE]; /* Environment data		*/
} mesonkey_t;

#define NAND_KEY_DEVICE_NAME	"nand_key"

static int  default_keyironment_size =  (KEYSIZE - sizeof(struct aml_nand_bbt_info));
static int aml_nand_read_key (struct mtd_info *mtd, uint64_t offset, u_char * buf)
{
	struct env_oobinfo_t *key_oobinfo;
	int error = 0;
	uint64_t addr = offset;
	size_t amount_loaded = 0;
	size_t len;
	struct mtd_oob_ops aml_oob_ops;
	unsigned char *data_buf;
	unsigned char key_oob_buf[sizeof(struct env_oobinfo_t)];

	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	if (!aml_chip->aml_nandkey_info->env_valid)
		return 1;

	data_buf = kzalloc(mtd->writesize, GFP_KERNEL);
	if (data_buf == NULL)
		return -ENOMEM;

	key_oobinfo = (struct env_oobinfo_t *)key_oob_buf;
	while (amount_loaded < CONFIG_KEYSIZE ) {

		aml_oob_ops.mode = MTD_OOB_AUTO;
		aml_oob_ops.len = mtd->writesize;
		aml_oob_ops.ooblen = sizeof(struct env_oobinfo_t);
		aml_oob_ops.ooboffs = mtd->ecclayout->oobfree[0].offset;
		aml_oob_ops.datbuf = data_buf;
		aml_oob_ops.oobbuf = key_oob_buf;

		memset((unsigned char *)aml_oob_ops.datbuf, 0x0, mtd->writesize);
		memset((unsigned char *)aml_oob_ops.oobbuf, 0x0, aml_oob_ops.ooblen);

		error = mtd->read_oob(mtd, addr, &aml_oob_ops);
		if ((error != 0) && (error != -EUCLEAN)) {
			printk("blk check good but read failed: %llx, %d\n", (uint64_t)addr, error);
			error = NAND_KEY_RD_ERR;
			goto exit;
		}

		if (memcmp(key_oobinfo->name, ENV_KEY_MAGIC, 4)) 
			printk("invalid nand key magic: %llx\n", (uint64_t)addr);

		addr += mtd->writesize;
		len = min(mtd->writesize, CONFIG_KEYSIZE - amount_loaded);
		memcpy(buf + amount_loaded, data_buf, len);
		amount_loaded += mtd->writesize;
	}
	if (amount_loaded < CONFIG_KEYSIZE)
	{
		error = NAND_KEY_CONFIG_ERR;
		printk("NAND key config size err,writesize:%d,config size:%d, %s\n",mtd->writesize,CONFIG_KEYSIZE,__func__);
		goto exit;
	}
exit:
	kfree(data_buf);
	return error;
}
#ifdef NAND_KEY_SAVE_MULTI_BLOCK
static int aml_nand_get_key(struct mtd_info *mtd, u_char * buf)
{
	struct aml_nand_bbt_info *nand_bbt_info;
	int error = 0,flag=0;
	uint64_t addr = 0;
	mesonkey_t *key_ptr = (mesonkey_t *)buf;
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	struct env_valid_node_t *cur_valid_node,*tail_valid_node;

	cur_valid_node = aml_chip->aml_nandkey_info->env_valid_node;
	tail_valid_node = cur_valid_node->next;
	do{
		while(tail_valid_node != NULL){
			//if(cur_valid_node->rd_timestamp > tail_valid_node->rd_timestamp)
			if(cur_valid_node->rd_flag == NAND_KEY_RD_ERR)
			{
				cur_valid_node = tail_valid_node;
				tail_valid_node = tail_valid_node->next;
			}
			else {
				break;
			}
		}
		if(cur_valid_node->rd_flag == NAND_KEY_RD_ERR)
		{
			error = NAND_KEY_RD_ERR;
			printk("read fail: don't have valid block get key,%s\n",__func__);
			goto exit;
		}

		addr = cur_valid_node->phy_blk_addr;
		addr *= mtd->erasesize;
		addr += cur_valid_node->phy_page_addr * mtd->writesize;
		printk("read:addr:0x%llx,phy_blk_addr:%d,phy_page_addr:%d,%s:%d\n",addr,cur_valid_node->phy_blk_addr,cur_valid_node->phy_page_addr,__func__,__LINE__);

		error = aml_nand_read_key(mtd,addr,(u_char*)key_ptr);
		if (error) 
		{
			printk("nand key read fail,%s\n",__func__);
			if(NAND_KEY_RD_ERR == error){
				cur_valid_node->rd_flag = NAND_KEY_RD_ERR;
				flag = 1;
			}
			else{
				goto exit;
			}
		}
		else{
			flag=0;
		}
	}while(flag);
	nand_bbt_info = &aml_chip->aml_nandkey_info->nand_bbt_info;
	memcpy(nand_bbt_info->bbt_head_magic,key_ptr->data + default_keyironment_size, sizeof(struct aml_nand_bbt_info));
exit:
	return error;
}
#else
static int aml_nand_get_key(struct mtd_info *mtd, u_char * buf)
{
	struct aml_nand_bbt_info *nand_bbt_info;
	int error = 0;
	uint64_t addr = 0;
	mesonkey_t *key_ptr = (mesonkey_t *)buf;
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);

	addr = aml_chip->aml_nandkey_info->env_valid_node->phy_blk_addr;
	addr *= mtd->erasesize;
	addr += aml_chip->aml_nandkey_info->env_valid_node->phy_page_addr * mtd->writesize;

	error = aml_nand_read_key(mtd,addr,(u_char*)key_ptr);
	if (error) 
	{
		printk("nand key read fail,%s\n",__func__);
		goto exit;
	}
	nand_bbt_info = &aml_chip->aml_nandkey_info->nand_bbt_info;
	memcpy(nand_bbt_info->bbt_head_magic,key_ptr->data + default_keyironment_size, sizeof(struct aml_nand_bbt_info));
exit:
	return error;
}
#endif  //NAND_KEY_SAVE_MULTI_BLOCK

static int aml_nand_write_key(struct mtd_info *mtd, uint64_t offset, u_char *buf)
{
	struct env_oobinfo_t *key_oobinfo;
	int error = 0;
	uint64_t addr = 0;
	size_t amount_saved = 0;
	size_t len;
	struct mtd_oob_ops aml_oob_ops;
	unsigned char *data_buf;
	unsigned char key_oob_buf[sizeof(struct env_oobinfo_t)];

	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	data_buf = kzalloc(mtd->writesize, GFP_KERNEL);
	if (data_buf == NULL)
		return -ENOMEM;

	addr = offset;
	key_oobinfo = (struct env_oobinfo_t *)key_oob_buf;
	memcpy(key_oobinfo->name, ENV_KEY_MAGIC, 4);
	key_oobinfo->ec = aml_chip->aml_nandkey_info->env_valid_node->ec;
	key_oobinfo->timestamp = aml_chip->aml_nandkey_info->env_valid_node->timestamp;
	key_oobinfo->status_page = 1;

	while (amount_saved < CONFIG_KEYSIZE ) {

		aml_oob_ops.mode = MTD_OOB_AUTO;
		aml_oob_ops.len = mtd->writesize;
		aml_oob_ops.ooblen = sizeof(struct env_oobinfo_t);
		aml_oob_ops.ooboffs = mtd->ecclayout->oobfree[0].offset;
		aml_oob_ops.datbuf = data_buf;
		aml_oob_ops.oobbuf = key_oob_buf;

		memset((unsigned char *)aml_oob_ops.datbuf, 0x0, mtd->writesize);
		len = min(mtd->writesize, CONFIG_KEYSIZE - amount_saved);
		memcpy((unsigned char *)aml_oob_ops.datbuf, buf + amount_saved, len);

		error = mtd->write_oob(mtd, addr, &aml_oob_ops);
		if (error) {
			printk("blk check good but write failed: %llx, %d\n", (uint64_t)addr, error);
			goto exit;
		}

		addr += mtd->writesize;;
		amount_saved += mtd->writesize;
	}
	if (amount_saved < CONFIG_KEYSIZE)
	{
		printk("amount_saved < CONFIG_KEYSIZE, %s\n",__func__);
		goto exit;
	}

	aml_chip->aml_nandkey_info->env_valid=1;
exit:
	kfree(data_buf);
	return error;
}
#ifdef NAND_KEY_SAVE_MULTI_BLOCK
static int aml_nand_save_key(struct mtd_info *mtd, u_char *buf)
{
	struct aml_nand_bbt_info *nand_bbt_info;
	struct env_free_node_t *env_free_node, *key_tmp_node;
	int error = 0, pages_per_blk, i = 1;
	uint64_t addr = 0;
	struct erase_info aml_key_erase_info;
	mesonkey_t *key_ptr = (mesonkey_t *)buf;
	int group_block_count=0,group_max_block = NAND_MINIKEY_PART_BLOCKNUM;
	struct env_valid_node_t *tmp_valid_node,*tail_valid_node,*del_valid_node;
	int success_flag;

	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	if (!aml_chip->aml_nandkey_info->env_init) 
		return 1;

	pages_per_blk = mtd->erasesize / mtd->writesize;
	if ((mtd->writesize < CONFIG_KEYSIZE) && (aml_chip->aml_nandkey_info->env_valid == 1))
		i = (CONFIG_KEYSIZE + mtd->writesize - 1) / mtd->writesize;

	if (aml_chip->aml_nandkey_info->env_valid) {
		aml_chip->aml_nandkey_info->env_valid_node->phy_page_addr += i;
		tail_valid_node = aml_chip->aml_nandkey_info->env_valid_node->next;
		while(tail_valid_node){
			tail_valid_node->phy_page_addr += i;
			tail_valid_node = tail_valid_node->next;
		}
		
		if ((aml_chip->aml_nandkey_info->env_valid_node->phy_page_addr + i) > pages_per_blk) {
			env_free_node = kzalloc(sizeof(struct env_free_node_t), GFP_KERNEL);
			if (env_free_node == NULL)
				return -ENOMEM;

			env_free_node->phy_blk_addr = aml_chip->aml_nandkey_info->env_valid_node->phy_blk_addr;
			env_free_node->ec = aml_chip->aml_nandkey_info->env_valid_node->ec;
			env_free_node->next = NULL;
		#ifdef TEST_ERROR_ADDRESS_BLOCK
			printk("free:  env_valid_node->phy_blk_addr:%d,%s:%d\n",aml_chip->aml_nandkey_info->env_valid_node->phy_blk_addr,__func__,__LINE__);
			printk("free:  env_free_node->phy_blk_addr:%d,%s:%d\n",env_free_node->phy_blk_addr,__func__,__LINE__);
		#endif
			key_tmp_node = aml_chip->aml_nandkey_info->env_free_node;
			if(aml_chip->aml_nandkey_info->env_free_node == NULL){
				aml_chip->aml_nandkey_info->env_free_node = env_free_node;
				#ifdef TEST_ERROR_ADDRESS_BLOCK
				printk("aml_chip->aml_nandkey_info->env_free_node: NULL,%s:%d\n",__func__,__LINE__);
				#endif
			}
			else{
				#ifdef TEST_ERROR_ADDRESS_BLOCK
				struct env_free_node_t *test22_env_free_node;
				#endif
				while (key_tmp_node->next != NULL) {
				#ifdef TEST_ERROR_ADDRESS_BLOCK
				test22_env_free_node =key_tmp_node->next;
					printk("free:  key_tmp_node->phy_blk_addr:%d,%s:%d\n",test22_env_free_node->phy_blk_addr,__func__,__LINE__);
				#endif
					key_tmp_node = key_tmp_node->next;
				}
				key_tmp_node->next = env_free_node;
			}
			tail_valid_node = aml_chip->aml_nandkey_info->env_valid_node->next;
			while(tail_valid_node){
				env_free_node = kzalloc(sizeof(struct env_free_node_t), GFP_KERNEL);
				if (env_free_node == NULL)
					return -ENOMEM;
				env_free_node->phy_blk_addr = tail_valid_node->phy_blk_addr;
				#ifdef TEST_ERROR_ADDRESS_BLOCK
				printk("free: tail_valid_node->phy_blk_addr:%d,%s:%d\n",tail_valid_node->phy_blk_addr,__func__,__LINE__);
				printk("free: env_free_node->phy_blk_addr:%d,%s:%d\n",env_free_node->phy_blk_addr,__func__,__LINE__);
				#endif
				env_free_node->ec = tail_valid_node->ec;
				env_free_node->next = NULL;
				aml_chip->aml_nandkey_info->env_valid_node->next = tail_valid_node->next;
				kfree(tail_valid_node);
				tail_valid_node = aml_chip->aml_nandkey_info->env_valid_node->next;
				
				key_tmp_node = aml_chip->aml_nandkey_info->env_free_node;
				while (key_tmp_node->next != NULL) {
					key_tmp_node = key_tmp_node->next;
				}
				key_tmp_node->next = env_free_node;
			}

			key_tmp_node = aml_chip->aml_nandkey_info->env_free_node;
			aml_chip->aml_nandkey_info->env_valid_node->phy_blk_addr = key_tmp_node->phy_blk_addr;
			#ifdef TEST_ERROR_ADDRESS_BLOCK
			printk("valid: key_tmp_node->phy_blk_addr:%d,%s:%d\n",key_tmp_node->phy_blk_addr,__func__,__LINE__);
			printk("valid: aml_chip->aml_nandkey_info->env_valid_node->phy_blk_addr:%d,%s:%d\n",aml_chip->aml_nandkey_info->env_valid_node->phy_blk_addr,__func__,__LINE__);
			#endif
			aml_chip->aml_nandkey_info->env_valid_node->phy_page_addr = 0;
			aml_chip->aml_nandkey_info->env_valid_node->ec = key_tmp_node->ec;
			aml_chip->aml_nandkey_info->env_valid_node->timestamp += 1;
			aml_chip->aml_nandkey_info->env_valid_node->next = NULL;
			aml_chip->aml_nandkey_info->env_free_node = key_tmp_node->next;
			kfree(key_tmp_node);
			
			group_block_count++;
			tail_valid_node = aml_chip->aml_nandkey_info->env_valid_node;
			key_tmp_node = aml_chip->aml_nandkey_info->env_free_node;
			while(key_tmp_node && group_block_count < group_max_block){
				tmp_valid_node = kzalloc(sizeof(struct env_valid_node_t), GFP_KERNEL);
				if (tmp_valid_node == NULL)
					return -ENOMEM;
				tmp_valid_node->ec = key_tmp_node->ec;
				tmp_valid_node->phy_blk_addr = key_tmp_node->phy_blk_addr;
				#ifdef TEST_ERROR_ADDRESS_BLOCK
				printk("free:  key_tmp_node->phy_blk_addr:%d,%s:%d\n",key_tmp_node->phy_blk_addr,__func__,__LINE__);
				printk("valid:  tmp_valid_node->phy_blk_addr:%d,%s:%d\n",tmp_valid_node->phy_blk_addr,__func__,__LINE__);
				#endif
				tmp_valid_node->phy_page_addr = 0;
				tmp_valid_node->timestamp += 1;
				tmp_valid_node->next = NULL;
				aml_chip->aml_nandkey_info->env_free_node = key_tmp_node->next;
				kfree(key_tmp_node);
				key_tmp_node = aml_chip->aml_nandkey_info->env_free_node;
				while(tail_valid_node->next != NULL){
					tail_valid_node = tail_valid_node->next;
				}
				tail_valid_node->next = tmp_valid_node;
				group_block_count++;
			}
		}
	}
	else {

		key_tmp_node = aml_chip->aml_nandkey_info->env_free_node;
		aml_chip->aml_nandkey_info->env_valid_node->phy_blk_addr = key_tmp_node->phy_blk_addr;
		aml_chip->aml_nandkey_info->env_valid_node->phy_page_addr = 0;
		#ifdef TEST_ERROR_ADDRESS_BLOCK
				printk("valid: key_tmp_node->phy_blk_addr:%d,%s:%d\n",key_tmp_node->phy_blk_addr,__func__,__LINE__);
				//printk("tmp_valid_node->phy_blk_addr:%d,%s:%d\n",tmp_valid_node->phy_blk_addr,__func__,__LINE__);
		#endif
		aml_chip->aml_nandkey_info->env_valid_node->ec = key_tmp_node->ec;
		aml_chip->aml_nandkey_info->env_valid_node->timestamp += 1;
		aml_chip->aml_nandkey_info->env_valid_node->next = NULL;
		aml_chip->aml_nandkey_info->env_free_node = key_tmp_node->next;
		kfree(key_tmp_node);
		group_block_count++;
		tail_valid_node = aml_chip->aml_nandkey_info->env_valid_node;
		key_tmp_node = aml_chip->aml_nandkey_info->env_free_node;
		while(key_tmp_node && group_block_count < group_max_block)
		{
			tmp_valid_node = kzalloc(sizeof(struct env_valid_node_t), GFP_KERNEL);
			tmp_valid_node->ec = key_tmp_node->ec;
			tmp_valid_node->phy_blk_addr = key_tmp_node->phy_blk_addr;
			#ifdef TEST_ERROR_ADDRESS_BLOCK
			printk("valid: tmp_valid_node->phy_blk_addr:%d,%s:%d\n",tmp_valid_node->phy_blk_addr,__func__,__LINE__);
			#endif
			tmp_valid_node->phy_page_addr = 0;
			tmp_valid_node->timestamp += 1;
			tmp_valid_node->next = NULL;
			aml_chip->aml_nandkey_info->env_free_node = key_tmp_node->next;
			kfree(key_tmp_node);
			key_tmp_node = aml_chip->aml_nandkey_info->env_free_node;
			while(tail_valid_node->next != NULL){
				tail_valid_node = tail_valid_node->next;
			}
			tail_valid_node->next = tmp_valid_node;
			group_block_count++;
		}
	}

	success_flag = 0;
	tail_valid_node = aml_chip->aml_nandkey_info->env_valid_node;
	while(tail_valid_node != NULL)
	{
		addr = tail_valid_node->phy_blk_addr;
		addr *= mtd->erasesize;
		addr += tail_valid_node->phy_page_addr * mtd->writesize;
		printk("write:addr:0x%llx,phy_blk_addr:%d,phy_page_addr:%d,%s:%d\n",addr,tail_valid_node->phy_blk_addr,tail_valid_node->phy_page_addr,__func__,__LINE__);
		if (tail_valid_node->phy_page_addr == 0) {

			memset(&aml_key_erase_info, 0, sizeof(struct erase_info));
			aml_key_erase_info.mtd = mtd;
			aml_key_erase_info.addr = addr;
			aml_key_erase_info.len = mtd->erasesize;
			aml_chip->key_protect = 1;

			error = mtd->erase(mtd, &aml_key_erase_info);
			if (error) {
				printk("key free blk erase failed %d\n", error);
				mtd->block_markbad(mtd, addr);
				tail_valid_node = tail_valid_node->next;
				aml_chip->key_protect = 0;
				continue;
				//return error;
			}
			aml_chip->key_protect = 0;
			tail_valid_node->ec++;
		}

		nand_bbt_info = &aml_chip->aml_nandkey_info->nand_bbt_info;
		if ((!memcmp(nand_bbt_info->bbt_head_magic, BBT_HEAD_MAGIC, 4)) && (!memcmp(nand_bbt_info->bbt_tail_magic, BBT_TAIL_MAGIC, 4))) {
			memcpy(key_ptr->data + default_keyironment_size, aml_chip->aml_nandkey_info->nand_bbt_info.bbt_head_magic, sizeof(struct aml_nand_bbt_info));
			key_ptr->crc = (crc32((0 ^ 0xffffffffL), key_ptr->data, KEYSIZE) ^ 0xffffffffL);
		}

		error = aml_nand_write_key(mtd, addr, (u_char *) key_ptr);
		if (error) {
			printk("update nand key addr:llx FAILED! \n",addr);
			if((error == -EIO)||(error == -EFAULT)){
				memset(&aml_key_erase_info, 0, sizeof(struct erase_info));
				addr = tail_valid_node->phy_blk_addr;
				addr *= mtd->erasesize;
				aml_key_erase_info.mtd = mtd;
				aml_key_erase_info.addr = addr;
				aml_key_erase_info.len = mtd->erasesize;
				aml_chip->key_protect = 1;  //use it in uboot

				//error = mtd->erase(mtd, &aml_key_erase_info);
				mtd->erase(mtd, &aml_key_erase_info);
				aml_chip->key_protect = 0;  //use it in uboot

				mtd->block_markbad(mtd, addr);
				/*delete current node (tail_valid_node)*/
				if(tail_valid_node == aml_chip->aml_nandkey_info->env_valid_node){
					del_valid_node = tail_valid_node;
					aml_chip->aml_nandkey_info->env_valid_node = tail_valid_node->next;
					tail_valid_node = aml_chip->aml_nandkey_info->env_valid_node;
					kfree(del_valid_node);
				}
				else{
					del_valid_node = tail_valid_node;
					tmp_valid_node = aml_chip->aml_nandkey_info->env_valid_node;
					while((tmp_valid_node->next)&&(tmp_valid_node->next != tail_valid_node)){
						tmp_valid_node = tmp_valid_node->next;
					}
					tmp_valid_node->next = tail_valid_node->next;
					tail_valid_node = tail_valid_node->next;
					kfree(del_valid_node);
				}
				continue;
			}
			else{
				break;
			}
		}
		tail_valid_node = tail_valid_node->next;
		success_flag++;
	}
	if(success_flag > 0){
		error = 0;  //at least a block wirte success
	}
	return error;
}
#else
static int aml_nand_save_key(struct mtd_info *mtd, u_char *buf)
{
	struct aml_nand_bbt_info *nand_bbt_info;
	struct env_free_node_t *env_free_node, *key_tmp_node;
	int error = 0, pages_per_blk, i = 1;
	uint64_t addr = 0;
	struct erase_info aml_key_erase_info;
	mesonkey_t *key_ptr = (mesonkey_t *)buf;

	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	if (!aml_chip->aml_nandkey_info->env_init) 
		return 1;

	pages_per_blk = mtd->erasesize / mtd->writesize;
	if ((mtd->writesize < CONFIG_KEYSIZE) && (aml_chip->aml_nandkey_info->env_valid == 1))
		i = (CONFIG_KEYSIZE + mtd->writesize - 1) / mtd->writesize;

	if (aml_chip->aml_nandkey_info->env_valid) {
		aml_chip->aml_nandkey_info->env_valid_node->phy_page_addr += i;
		if ((aml_chip->aml_nandkey_info->env_valid_node->phy_page_addr + i) > pages_per_blk) {

			env_free_node = kzalloc(sizeof(struct env_free_node_t), GFP_KERNEL);
			if (env_free_node == NULL)
				return -ENOMEM;

			env_free_node->phy_blk_addr = aml_chip->aml_nandkey_info->env_valid_node->phy_blk_addr;
			env_free_node->ec = aml_chip->aml_nandkey_info->env_valid_node->ec;
			key_tmp_node = aml_chip->aml_nandkey_info->env_free_node;
			while (key_tmp_node->next != NULL) {
				key_tmp_node = key_tmp_node->next;
			}
			key_tmp_node->next = env_free_node;

			key_tmp_node = aml_chip->aml_nandkey_info->env_free_node;
			aml_chip->aml_nandkey_info->env_valid_node->phy_blk_addr = key_tmp_node->phy_blk_addr;
			aml_chip->aml_nandkey_info->env_valid_node->phy_page_addr = 0;
			aml_chip->aml_nandkey_info->env_valid_node->ec = key_tmp_node->ec;
			aml_chip->aml_nandkey_info->env_valid_node->timestamp += 1;
			aml_chip->aml_nandkey_info->env_free_node = key_tmp_node->next;
			kfree(key_tmp_node);
		}
	}
	else {

		key_tmp_node = aml_chip->aml_nandkey_info->env_free_node;
		aml_chip->aml_nandkey_info->env_valid_node->phy_blk_addr = key_tmp_node->phy_blk_addr;
		aml_chip->aml_nandkey_info->env_valid_node->phy_page_addr = 0;
		aml_chip->aml_nandkey_info->env_valid_node->ec = key_tmp_node->ec;
		aml_chip->aml_nandkey_info->env_valid_node->timestamp += 1;
		aml_chip->aml_nandkey_info->env_free_node = key_tmp_node->next;
		kfree(key_tmp_node);
	}

	addr = aml_chip->aml_nandkey_info->env_valid_node->phy_blk_addr;
	addr *= mtd->erasesize;
	addr += aml_chip->aml_nandkey_info->env_valid_node->phy_page_addr * mtd->writesize;
	if (aml_chip->aml_nandkey_info->env_valid_node->phy_page_addr == 0) {

		memset(&aml_key_erase_info, 0, sizeof(struct erase_info));
		aml_key_erase_info.mtd = mtd;
		aml_key_erase_info.addr = addr;
		aml_key_erase_info.len = mtd->erasesize;
		aml_chip->key_protect = 1;

		error = mtd->erase(mtd, &aml_key_erase_info);
		if (error) {
			printk("key free blk erase failed %d\n", error);
			mtd->block_markbad(mtd, addr);
			return error;
		}
		aml_chip->key_protect = 0;
		aml_chip->aml_nandkey_info->env_valid_node->ec++;
	}

	nand_bbt_info = &aml_chip->aml_nandkey_info->nand_bbt_info;
	if ((!memcmp(nand_bbt_info->bbt_head_magic, BBT_HEAD_MAGIC, 4)) && (!memcmp(nand_bbt_info->bbt_tail_magic, BBT_TAIL_MAGIC, 4))) {
		memcpy(key_ptr->data + default_keyironment_size, aml_chip->aml_nandkey_info->nand_bbt_info.bbt_head_magic, sizeof(struct aml_nand_bbt_info));
		key_ptr->crc = (crc32((0 ^ 0xffffffffL), key_ptr->data, KEYSIZE) ^ 0xffffffffL);
	}

	error = aml_nand_write_key(mtd, addr, (u_char *) key_ptr);
	if (error) {
		if((error == -EIO)||(error == -EFAULT)){
			memset(&aml_key_erase_info, 0, sizeof(struct erase_info));
			addr = tail_valid_node->phy_blk_addr;
			addr *= mtd->erasesize;
			aml_key_erase_info.mtd = mtd;
			aml_key_erase_info.addr = addr;
			aml_key_erase_info.len = mtd->erasesize;
			aml_chip->key_protect = 1;  //use it in uboot

			//error = mtd->erase(mtd, &aml_key_erase_info);
			mtd->erase(mtd, &aml_key_erase_info);
			aml_chip->key_protect = 0;  //use it in uboot
			mtd->block_markbad(mtd, addr);
			printk("update nand key FAILED!\n");
			return 1;
		}
	}
	
	return error;
}
#endif  //NAND_KEY_SAVE_MULTI_BLOCK

#define KEY_SAVE_NAND_TAIL

#ifdef KEY_SAVE_NAND_TAIL
static int aml_nand_key_init(struct mtd_info *mtd)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	struct nand_chip *chip = &aml_chip->chip;
	struct env_oobinfo_t *key_oobinfo;
	struct env_free_node_t *env_free_node, *key_tmp_node, *key_prev_node;
	#ifdef NAND_KEY_SAVE_MULTI_BLOCK
	struct env_valid_node_t *env_valid_node,*tmp_valid_node;
	struct env_free_node_t  *multi_free_node,*mult_free_tmp_node;
	int have_env_free_node_flag;
	#endif
	int error = 0, start_blk, total_blk, key_blk, i, pages_per_blk, bad_blk_cnt = 0, max_key_blk, max_env_blk,phys_erase_shift;
	uint64_t offset, env_offset;
	unsigned char *data_buf;
	struct mtd_oob_ops aml_oob_ops;
	unsigned char key_oob_buf[sizeof(struct env_oobinfo_t)];

	data_buf = kzalloc(mtd->writesize, GFP_KERNEL);
	if (data_buf == NULL)
		return -ENOMEM;

	aml_chip->aml_nandkey_info = kzalloc(sizeof(struct aml_nandkey_info_t), GFP_KERNEL);
	if (aml_chip->aml_nandkey_info == NULL)
		return -ENOMEM;

	aml_chip->aml_nandkey_info->env_init = 0;
	aml_chip->aml_nandkey_info->mtd = mtd;
	aml_chip->aml_nandkey_info->env_valid_node = kzalloc(sizeof(struct env_valid_node_t), GFP_KERNEL);
	if (aml_chip->aml_nandkey_info->env_valid_node == NULL)
		return -ENOMEM;
	aml_chip->aml_nandkey_info->env_valid_node->phy_blk_addr = -1;
	aml_chip->aml_nandkey_info->env_free_node = NULL;

	phys_erase_shift = fls(mtd->erasesize) - 1;
	max_key_blk = (NAND_MINIKEY_PART_SIZE >> phys_erase_shift);
	if (max_key_blk < NAND_MINIKEY_PART_BLOCKNUM)
		max_key_blk = NAND_MINIKEY_PART_BLOCKNUM;
//	if (nand_boot_flag)
//		offset = (NAND_MINI_PART_SIZE + 1024 * mtd->writesize) / aml_chip->plane_num;
#if 0
	offset = (1024 * mtd->writesize) / aml_chip->plane_num;
	//env size
	max_env_blk = (NAND_MINI_PART_SIZE >> phys_erase_shift);
	if(max_env_blk < NAND_MINI_PART_BLOCKNUM)
		max_env_blk = NAND_MINI_PART_BLOCKNUM;
	start_blk = 0;
	do{
		env_offset = offset + start_blk * mtd->erasesize;
		error = mtd->block_isbad(mtd, env_offset);
		if (error) {
			offset += mtd->erasesize;
			continue;
		}
		start_blk++;
	}while(start_blk < max_env_blk);
	offset += max_env_blk * mtd->erasesize;
#endif
#ifdef NEW_NAND_SUPPORT
	if((aml_chip->new_nand_info.type) && (aml_chip->new_nand_info.type < 10))
		offset += RETRY_NAND_BLK_NUM* mtd->erasesize;
#endif

	//start_blk = (int)(offset >> phys_erase_shift);
	//total_blk = (int)(mtd->size >> phys_erase_shift);
	//aml_chip->aml_nandkey_info->start_block=start_blk;
	//printk("start_blk=%d\n",aml_chip->aml_nandkey_info->start_block);
	//aml_chip->aml_nandkey_info->end_block=start_blk;
	pages_per_blk = (1 << (chip->phys_erase_shift - chip->page_shift));
	key_oobinfo = (struct env_oobinfo_t *)key_oob_buf;
	//if ((default_keyironment_size + sizeof(struct aml_nand_bbt_info)) > KEYSIZE)
	//	total_blk = start_blk + max_key_blk;

//#define REMAIN_TAIL_BLOCK_NUM		8
	offset = mtd->size - mtd->erasesize;
	int remain_block=0;
	int remain_start_block;
	int remain_tatol_block;
	remain_start_block = (int)(offset >> phys_erase_shift);
	remain_tatol_block = REMAIN_TAIL_BLOCK_NUM;
	aml_chip->aml_nandkey_info->start_block=remain_start_block;
	aml_chip->aml_nandkey_info->end_block=remain_start_block;
	bad_blk_cnt=0;
	do{
		offset = mtd->erasesize;
		offset *= remain_start_block;
		error = mtd->block_isbad(mtd, offset);
		if (error == FACTORY_BAD_BLOCK_ERROR) {
			aml_chip->aml_nandkey_info->nand_bbt_info.nand_bbt[bad_blk_cnt++] = remain_start_block;
			if(bad_blk_cnt >= MAX_BAD_BLK_NUM)
			{
				printk("bad block too much,%s\n",__func__);
				return -ENOMEM;
			}
			aml_chip->aml_nandkey_info->start_block--;
			remain_start_block--;
			continue;
		}
		remain_start_block--;
	}while(++remain_block< remain_tatol_block);
	aml_chip->aml_nandkey_info->start_block -= (remain_block-1);
	printk("key start_blk=%d,end_blk=%d,%s:%d\n",aml_chip->aml_nandkey_info->start_block,aml_chip->aml_nandkey_info->end_block,__func__,__LINE__);

	key_blk = 0;
	start_blk = aml_chip->aml_nandkey_info->start_block;
	do {

		offset = mtd->erasesize;
		offset *= start_blk;
		error = mtd->block_isbad(mtd, offset);
		if(error){
			if (error == FACTORY_BAD_BLOCK_ERROR) {
				//aml_chip->aml_nandkey_info->nand_bbt_info.nand_bbt[bad_blk_cnt++] = start_blk;
				//if(bad_blk_cnt >= MAX_BAD_BLK_NUM)
				//{
				//	printk("bad block too much,%s\n",__func__);
				//	return -ENOMEM;
				//}
				//printk("%s: factory bad block  %d\n",__func__,start_blk);
				start_blk++;
				continue;
			}
			if (error == EFAULT) {
				//printk("%s: bad block  %d,key_blk:%d\n",__func__,start_blk,key_blk);
				start_blk++;
				key_blk++;
				continue;
			}
		}

		aml_oob_ops.mode = MTD_OOB_AUTO;
		aml_oob_ops.len = mtd->writesize;
		aml_oob_ops.ooblen = sizeof(struct env_oobinfo_t);
		aml_oob_ops.ooboffs = mtd->ecclayout->oobfree[0].offset;
		aml_oob_ops.datbuf = data_buf;
		aml_oob_ops.oobbuf = key_oob_buf;

		memset((unsigned char *)aml_oob_ops.datbuf, 0x0, mtd->writesize);
		memset((unsigned char *)aml_oob_ops.oobbuf, 0x0, aml_oob_ops.ooblen);

		error = mtd->read_oob(mtd, offset, &aml_oob_ops);
		if ((error != 0) && (error != -EUCLEAN)) {
			printk("blk check good but read failed: %llx, %d\n", (uint64_t)offset, error);
			continue;
		}

		aml_chip->aml_nandkey_info->env_init = 1;
		if (!memcmp(key_oobinfo->name, ENV_KEY_MAGIC, 4)) {
			aml_chip->aml_nandkey_info->env_valid = 1;
			if (aml_chip->aml_nandkey_info->env_valid_node->phy_blk_addr >= 0) {
				env_free_node = kzalloc(sizeof(struct env_free_node_t), GFP_KERNEL);
				if (env_free_node == NULL)
					return -ENOMEM;

				env_free_node->dirty_flag = 1;
				#ifdef NAND_KEY_SAVE_MULTI_BLOCK
				have_env_free_node_flag = 0;
				if (key_oobinfo->timestamp > aml_chip->aml_nandkey_info->env_valid_node->timestamp) {

					env_free_node->phy_blk_addr = aml_chip->aml_nandkey_info->env_valid_node->phy_blk_addr;
					env_free_node->ec = aml_chip->aml_nandkey_info->env_valid_node->ec;
					env_free_node->next = NULL;
					have_env_free_node_flag = 1;
					#ifdef TEST_ERROR_ADDRESS_BLOCK
					printk("free:phy_page_addr:%d,%s,%d\n",env_free_node->phy_blk_addr,__func__,__LINE__);
					#endif

					tmp_valid_node = aml_chip->aml_nandkey_info->env_valid_node->next;
					while (tmp_valid_node != NULL) {
						aml_chip->aml_nandkey_info->env_valid_node->next = tmp_valid_node->next;
						multi_free_node = kzalloc(sizeof(struct env_free_node_t), GFP_KERNEL);
						multi_free_node->phy_blk_addr = tmp_valid_node->phy_blk_addr;
						multi_free_node->ec = tmp_valid_node->ec;
						multi_free_node->next = NULL;
						kfree(tmp_valid_node);
						multi_free_node->dirty_flag = 1;
						mult_free_tmp_node = env_free_node;
						while(mult_free_tmp_node->next != NULL){
							mult_free_tmp_node = mult_free_tmp_node->next;
						}
						mult_free_tmp_node->next = multi_free_node;
						#ifdef TEST_ERROR_ADDRESS_BLOCK
						printk("free:phy_page_addr:%d,%s,%d\n",multi_free_node->phy_blk_addr,__func__,__LINE__);
						#endif
						tmp_valid_node = aml_chip->aml_nandkey_info->env_valid_node->next;
					}
					aml_chip->aml_nandkey_info->env_valid_node->phy_blk_addr = start_blk;
					aml_chip->aml_nandkey_info->env_valid_node->phy_page_addr = 0;
					aml_chip->aml_nandkey_info->env_valid_node->ec = key_oobinfo->ec;
					aml_chip->aml_nandkey_info->env_valid_node->timestamp = key_oobinfo->timestamp;	
					aml_chip->aml_nandkey_info->env_valid_node->next = NULL;
					#ifdef TEST_ERROR_ADDRESS_BLOCK
					printk("valid:phy_blk_addr:%d,phy_page_addr:%d,%s,%d\n",aml_chip->aml_nandkey_info->env_valid_node->phy_blk_addr,aml_chip->aml_nandkey_info->env_valid_node->phy_page_addr,__func__,__LINE__);
					#endif

				}
				else if(key_oobinfo->timestamp == aml_chip->aml_nandkey_info->env_valid_node->timestamp){
					tmp_valid_node = aml_chip->aml_nandkey_info->env_valid_node;
					env_valid_node = kzalloc(sizeof(struct env_valid_node_t), GFP_KERNEL);
					if (env_valid_node == NULL)
						return -ENOMEM;
					env_valid_node->phy_blk_addr = start_blk;
					env_valid_node->phy_page_addr = 0;
					env_valid_node->next = NULL;
					env_valid_node->timestamp = key_oobinfo->timestamp;
					env_valid_node->ec = key_oobinfo->ec;
					while (tmp_valid_node->next != NULL) {
						tmp_valid_node = tmp_valid_node->next;
					}
					tmp_valid_node->next = env_valid_node;
					#ifdef TEST_ERROR_ADDRESS_BLOCK
					printk("valid:phy_blk_addr:%d,phy_page_addr:%d,%s,%d\n",env_valid_node->phy_blk_addr,env_valid_node->phy_page_addr,__func__,__LINE__);
					#endif
				}
				else {
					env_free_node->phy_blk_addr = start_blk;
					#ifdef TEST_ERROR_ADDRESS_BLOCK
					printk("env_free_node->phy_blk_addr:%d,%s:%d\n",env_free_node->phy_blk_addr,__func__,__LINE__);
					#endif
					env_free_node->ec = key_oobinfo->ec;
					have_env_free_node_flag = 1;
				}
				if(have_env_free_node_flag){
					if (aml_chip->aml_nandkey_info->env_free_node == NULL){
						aml_chip->aml_nandkey_info->env_free_node = env_free_node;
					}
					else {
						key_tmp_node = aml_chip->aml_nandkey_info->env_free_node;
						while (key_tmp_node->next != NULL) {
							key_tmp_node = key_tmp_node->next;
						}
						key_tmp_node->next = env_free_node;
					}
				}
				else{
					kfree(env_free_node);
				}
				#else
				if (key_oobinfo->timestamp > aml_chip->aml_nandkey_info->env_valid_node->timestamp) {

					env_free_node->phy_blk_addr = aml_chip->aml_nandkey_info->env_valid_node->phy_blk_addr;
					env_free_node->ec = aml_chip->aml_nandkey_info->env_valid_node->ec;
					aml_chip->aml_nandkey_info->env_valid_node->phy_blk_addr = start_blk;
					aml_chip->aml_nandkey_info->env_valid_node->phy_page_addr = 0;
					aml_chip->aml_nandkey_info->env_valid_node->ec = key_oobinfo->ec;
					aml_chip->aml_nandkey_info->env_valid_node->timestamp = key_oobinfo->timestamp;	
				}
				else {
					env_free_node->phy_blk_addr = start_blk;
					env_free_node->ec = key_oobinfo->ec;
				}
				if (aml_chip->aml_nandkey_info->env_free_node == NULL){
					aml_chip->aml_nandkey_info->env_free_node = env_free_node;
				}
				else {
					key_tmp_node = aml_chip->aml_nandkey_info->env_free_node;
					while (key_tmp_node->next != NULL) {
						key_tmp_node = key_tmp_node->next;
					}
					key_tmp_node->next = env_free_node;
				}
				#endif
			}
			else {

				aml_chip->aml_nandkey_info->env_valid_node->phy_blk_addr = start_blk;
				aml_chip->aml_nandkey_info->env_valid_node->phy_page_addr = 0;
				aml_chip->aml_nandkey_info->env_valid_node->ec = key_oobinfo->ec;
				aml_chip->aml_nandkey_info->env_valid_node->timestamp = key_oobinfo->timestamp;	
			}
		}
		else if (key_blk < max_key_blk) {
			env_free_node = kzalloc(sizeof(struct env_free_node_t), GFP_KERNEL);
			if (env_free_node == NULL)
				return -ENOMEM;

			env_free_node->phy_blk_addr = start_blk;
			env_free_node->ec = key_oobinfo->ec;
			env_free_node->next = NULL;
			#ifdef TEST_ERROR_ADDRESS_BLOCK
			printk("free:  env_free_node->phy_blk_addr:%d,%s:%d\n",env_free_node->phy_blk_addr,__func__,__LINE__);
			#endif
			if (aml_chip->aml_nandkey_info->env_free_node == NULL)
				aml_chip->aml_nandkey_info->env_free_node = env_free_node;
			else {
				key_tmp_node = aml_chip->aml_nandkey_info->env_free_node;
				key_prev_node = key_tmp_node;
				while (key_tmp_node != NULL) {
					if (key_tmp_node->dirty_flag == 1)
						break;
					key_prev_node = key_tmp_node;
					key_tmp_node = key_tmp_node->next;
				}
				if (key_prev_node == key_tmp_node) {
					env_free_node->next = key_tmp_node;
					aml_chip->aml_nandkey_info->env_free_node = env_free_node;
				}
				else {
					key_prev_node->next = env_free_node;
					env_free_node->next = key_tmp_node;
				}
			}
		}
		key_blk++;
		if ((key_blk >= max_key_blk) && (aml_chip->aml_nandkey_info->env_valid == 1))
			break;

	} while ((++start_blk) < (remain_tatol_block+aml_chip->aml_nandkey_info->start_block)); //total_blk  ENV_NAND_SCAN_BLK
	if (start_blk >= (remain_tatol_block + aml_chip->aml_nandkey_info->start_block)) {  //total_blk  ENV_NAND_SCAN_BLK
		memcpy(aml_chip->aml_nandkey_info->nand_bbt_info.bbt_head_magic, BBT_HEAD_MAGIC, 4);
		memcpy(aml_chip->aml_nandkey_info->nand_bbt_info.bbt_tail_magic, BBT_TAIL_MAGIC, 4);
	}

	if (aml_chip->aml_nandkey_info->env_valid == 1) {

		aml_oob_ops.mode = MTD_OOB_AUTO;
		aml_oob_ops.len = mtd->writesize;
		aml_oob_ops.ooblen = sizeof(struct env_oobinfo_t);
		aml_oob_ops.ooboffs = mtd->ecclayout->oobfree[0].offset;
		aml_oob_ops.datbuf = data_buf;
		aml_oob_ops.oobbuf = key_oob_buf;

		for (i=0; i<pages_per_blk; i++) {

			memset((unsigned char *)aml_oob_ops.datbuf, 0x0, mtd->writesize);
			memset((unsigned char *)aml_oob_ops.oobbuf, 0x0, aml_oob_ops.ooblen);

			offset = aml_chip->aml_nandkey_info->env_valid_node->phy_blk_addr;
			offset *= mtd->erasesize;
			offset += i * mtd->writesize;
			error = mtd->read_oob(mtd, offset, &aml_oob_ops);
			if ((error != 0) && (error != -EUCLEAN)) {
				printk("blk check good but read failed: %llx, %d\n", (uint64_t)offset, error);
				continue;
			}

			#ifdef NAND_KEY_SAVE_MULTI_BLOCK
			if (!memcmp(key_oobinfo->name, ENV_KEY_MAGIC, 4)){
				aml_chip->aml_nandkey_info->env_valid_node->phy_page_addr = i;
				tmp_valid_node = aml_chip->aml_nandkey_info->env_valid_node->next;
				while(tmp_valid_node != NULL){
					tmp_valid_node->phy_page_addr = i;
					//printk("valid page:phy_page_addr:%d,%s,%d\n",tmp_valid_node->phy_page_addr,__func__,__LINE__);
					tmp_valid_node = tmp_valid_node->next;
				}
			}
			else
				break;
			#else
			if (!memcmp(key_oobinfo->name, ENV_KEY_MAGIC, 4))
				aml_chip->aml_nandkey_info->env_valid_node->phy_page_addr = i;
			else
				break;
			#endif
		}
	}
	#ifdef NAND_KEY_SAVE_MULTI_BLOCK
	if ((mtd->writesize < CONFIG_KEYSIZE) && (aml_chip->aml_nandkey_info->env_valid == 1)) {
		i = (CONFIG_KEYSIZE + mtd->writesize - 1) / mtd->writesize;
		aml_chip->aml_nandkey_info->env_valid_node->phy_page_addr -= (i - 1);
		
		tmp_valid_node = aml_chip->aml_nandkey_info->env_valid_node->next;
		while(tmp_valid_node != NULL){
			tmp_valid_node->phy_page_addr -= (i - 1);
			tmp_valid_node = tmp_valid_node->next;
		}
	}
	#else
	if ((mtd->writesize < CONFIG_KEYSIZE) && (aml_chip->aml_nandkey_info->env_valid == 1)) {
		i = (CONFIG_KEYSIZE + mtd->writesize - 1) / mtd->writesize;
		aml_chip->aml_nandkey_info->env_valid_node->phy_page_addr -= (i - 1);
	}
	#endif

	offset = aml_chip->aml_nandkey_info->env_valid_node->phy_blk_addr;
	offset *= mtd->erasesize;
	offset += aml_chip->aml_nandkey_info->env_valid_node->phy_page_addr * mtd->writesize;
	//printk("aml nand key valid addr: %llx \n", (uint64_t)offset);
	if(aml_chip->aml_nandkey_info->env_valid_node->phy_blk_addr < 0){
		printk("aml nand key not have valid addr: not wrote\n");
	}
	else{
		printk("aml nand key valid addr: %llx \n", offset);
	}
	#ifdef NAND_KEY_SAVE_MULTI_BLOCK
	tmp_valid_node = aml_chip->aml_nandkey_info->env_valid_node->next;
	while(tmp_valid_node != NULL){
		offset = tmp_valid_node->phy_blk_addr;
		offset *= mtd->erasesize;
		offset += tmp_valid_node->phy_page_addr * mtd->writesize;
		printk("aml nand key valid addr: %llx \n", (uint64_t)offset);
		tmp_valid_node = tmp_valid_node->next;
	}
	#endif
	printk(KERN_DEBUG "CONFIG_KEYSIZE=0x%x; KEYSIZE=0x%x; bbt=0x%x; default_keyironment_size=0x%x\n",
		CONFIG_KEYSIZE, KEYSIZE, sizeof(struct aml_nand_bbt_info), default_keyironment_size);
	kfree(data_buf);
	return 0;
}
#else  //KEY_SAVE_NAND_TAIL
static int aml_nand_key_init(struct mtd_info *mtd)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	struct nand_chip *chip = &aml_chip->chip;
	struct env_oobinfo_t *key_oobinfo;
	struct env_free_node_t *env_free_node, *key_tmp_node, *key_prev_node;
	#ifdef NAND_KEY_SAVE_MULTI_BLOCK
	struct env_valid_node_t *env_valid_node,*tmp_valid_node;
	struct env_free_node_t  *multi_free_node,*mult_free_tmp_node;
	int have_env_free_node_flag;
	#endif
	int error = 0, start_blk, total_blk, key_blk, i, pages_per_blk, bad_blk_cnt = 0, max_key_blk, max_env_blk,phys_erase_shift;
	uint64_t offset, env_offset;
	unsigned char *data_buf;
	struct mtd_oob_ops aml_oob_ops;
	unsigned char key_oob_buf[sizeof(struct env_oobinfo_t)];

	data_buf = kzalloc(mtd->writesize, GFP_KERNEL);
	if (data_buf == NULL)
		return -ENOMEM;

	aml_chip->aml_nandkey_info = kzalloc(sizeof(struct aml_nandkey_info_t), GFP_KERNEL);
	if (aml_chip->aml_nandkey_info == NULL)
		return -ENOMEM;

	aml_chip->aml_nandkey_info->env_init = 0;
	aml_chip->aml_nandkey_info->mtd = mtd;
	aml_chip->aml_nandkey_info->env_valid_node = kzalloc(sizeof(struct env_valid_node_t), GFP_KERNEL);
	if (aml_chip->aml_nandkey_info->env_valid_node == NULL)
		return -ENOMEM;
	aml_chip->aml_nandkey_info->env_valid_node->phy_blk_addr = -1;

	phys_erase_shift = fls(mtd->erasesize) - 1;
	max_key_blk = (NAND_MINIKEY_PART_SIZE >> phys_erase_shift);
	if (max_key_blk < NAND_MINIKEY_PART_BLOCKNUM)
		max_key_blk = NAND_MINIKEY_PART_BLOCKNUM;
//	if (nand_boot_flag)
//		offset = (NAND_MINI_PART_SIZE + 1024 * mtd->writesize) / aml_chip->plane_num;
	offset = (1024 * mtd->writesize) / aml_chip->plane_num;
	//env size
	max_env_blk = (NAND_MINI_PART_SIZE >> phys_erase_shift);
	if(max_env_blk < NAND_MINI_PART_BLOCKNUM)
		max_env_blk = NAND_MINI_PART_BLOCKNUM;
	start_blk = 0;
	do{
		env_offset = offset + start_blk * mtd->erasesize;
		error = mtd->block_isbad(mtd, env_offset);
		if (error) {
			offset += mtd->erasesize;
			continue;
		}
		start_blk++;
	}while(start_blk < max_env_blk);
	offset += max_env_blk * mtd->erasesize;

#ifdef NEW_NAND_SUPPORT
	if((aml_chip->new_nand_info.type) && (aml_chip->new_nand_info.type < 10))
		offset += RETRY_NAND_BLK_NUM* mtd->erasesize;
#endif
	start_blk = (int)(offset >> phys_erase_shift);
	total_blk = (int)(mtd->size >> phys_erase_shift);
	aml_chip->aml_nandkey_info->start_block=start_blk;
	//printk("start_blk=%d\n",aml_chip->aml_nandkey_info->start_block);
	aml_chip->aml_nandkey_info->end_block=start_blk;
	pages_per_blk = (1 << (chip->phys_erase_shift - chip->page_shift));
	key_oobinfo = (struct env_oobinfo_t *)key_oob_buf;
	if ((default_keyironment_size + sizeof(struct aml_nand_bbt_info)) > KEYSIZE)
		total_blk = start_blk + max_key_blk;

	key_blk = 0;
	do {

		offset = mtd->erasesize;
		offset *= start_blk;
		error = mtd->block_isbad(mtd, offset);
		if (error) {
			aml_chip->aml_nandkey_info->nand_bbt_info.nand_bbt[bad_blk_cnt++] = start_blk;
			if(bad_blk_cnt >= MAX_BAD_BLK_NUM)
			{
				printk("bad block too much,%s\n",__func__);
				return -ENOMEM;
			}
			if(key_blk<max_key_blk){
			aml_chip->aml_nandkey_info->end_block++;
			printk("end_block=%d\n",aml_chip->aml_nandkey_info->end_block);
			}
			continue;
		}

		aml_oob_ops.mode = MTD_OOB_AUTO;
		aml_oob_ops.len = mtd->writesize;
		aml_oob_ops.ooblen = sizeof(struct env_oobinfo_t);
		aml_oob_ops.ooboffs = mtd->ecclayout->oobfree[0].offset;
		aml_oob_ops.datbuf = data_buf;
		aml_oob_ops.oobbuf = key_oob_buf;

		memset((unsigned char *)aml_oob_ops.datbuf, 0x0, mtd->writesize);
		memset((unsigned char *)aml_oob_ops.oobbuf, 0x0, aml_oob_ops.ooblen);

		error = mtd->read_oob(mtd, offset, &aml_oob_ops);
		if ((error != 0) && (error != -EUCLEAN)) {
			printk("blk check good but read failed: %llx, %d\n", (uint64_t)offset, error);
			continue;
		}

		aml_chip->aml_nandkey_info->env_init = 1;
		if (!memcmp(key_oobinfo->name, ENV_KEY_MAGIC, 4)) {
			aml_chip->aml_nandkey_info->env_valid = 1;
			if (aml_chip->aml_nandkey_info->env_valid_node->phy_blk_addr >= 0) {
				env_free_node = kzalloc(sizeof(struct env_free_node_t), GFP_KERNEL);
				if (env_free_node == NULL)
					return -ENOMEM;

				env_free_node->dirty_flag = 1;
				#ifdef NAND_KEY_SAVE_MULTI_BLOCK
				have_env_free_node_flag = 0;
				if (key_oobinfo->timestamp > aml_chip->aml_nandkey_info->env_valid_node->timestamp) {

					env_free_node->phy_blk_addr = aml_chip->aml_nandkey_info->env_valid_node->phy_blk_addr;
					env_free_node->ec = aml_chip->aml_nandkey_info->env_valid_node->ec;
					env_free_node->next = NULL;
					have_env_free_node_flag = 1;
					//printk("free:phy_page_addr:%d,%s,%d\n",env_free_node->phy_blk_addr,__func__,__LINE__);

					tmp_valid_node = aml_chip->aml_nandkey_info->env_valid_node->next;
					while (tmp_valid_node != NULL) {
						aml_chip->aml_nandkey_info->env_valid_node->next = tmp_valid_node->next;
						multi_free_node = kzalloc(sizeof(struct env_free_node_t), GFP_KERNEL);
						multi_free_node->phy_blk_addr = tmp_valid_node->phy_blk_addr;
						multi_free_node->ec = tmp_valid_node->ec;
						kfree(tmp_valid_node);
						multi_free_node->dirty_flag = 1;
						mult_free_tmp_node = env_free_node;
						while(mult_free_tmp_node->next != NULL){
							mult_free_tmp_node = mult_free_tmp_node->next;
						}
						mult_free_tmp_node->next = multi_free_node;
						//printk("free:phy_page_addr:%d,%s,%d\n",multi_free_node->phy_blk_addr,__func__,__LINE__);
						tmp_valid_node = aml_chip->aml_nandkey_info->env_valid_node->next;
					}
					aml_chip->aml_nandkey_info->env_valid_node->phy_blk_addr = start_blk;
					aml_chip->aml_nandkey_info->env_valid_node->phy_page_addr = 0;
					aml_chip->aml_nandkey_info->env_valid_node->ec = key_oobinfo->ec;
					aml_chip->aml_nandkey_info->env_valid_node->timestamp = key_oobinfo->timestamp;	
					aml_chip->aml_nandkey_info->env_valid_node->next = NULL;
					//printk("valid:phy_blk_addr:%d,phy_page_addr:%d,%s,%d\n",aml_chip->aml_nandkey_info->env_valid_node->phy_blk_addr,aml_chip->aml_nandkey_info->env_valid_node->phy_page_addr,__func__,__LINE__);

				}
				else if(key_oobinfo->timestamp == aml_chip->aml_nandkey_info->env_valid_node->timestamp){
					tmp_valid_node = aml_chip->aml_nandkey_info->env_valid_node;
					env_valid_node = kzalloc(sizeof(struct env_valid_node_t), GFP_KERNEL);
					if (env_valid_node == NULL)
						return -ENOMEM;
					env_valid_node->phy_blk_addr = start_blk;
					env_valid_node->phy_page_addr = 0;
					env_valid_node->timestamp = key_oobinfo->timestamp;
					env_valid_node->ec = key_oobinfo->ec;
					while (tmp_valid_node->next != NULL) {
						tmp_valid_node = tmp_valid_node->next;
					}
					tmp_valid_node->next = env_valid_node;
					//printk("valid:phy_blk_addr:%d,phy_page_addr:%d,%s,%d\n",env_valid_node->phy_blk_addr,env_valid_node->phy_page_addr,__func__,__LINE__);
				}
				else {
					env_free_node->phy_blk_addr = start_blk;
					env_free_node->ec = key_oobinfo->ec;
					have_env_free_node_flag = 1;
				}
				if(have_env_free_node_flag){
					if (aml_chip->aml_nandkey_info->env_free_node == NULL)
						aml_chip->aml_nandkey_info->env_free_node = env_free_node;
					else {
						key_tmp_node = aml_chip->aml_nandkey_info->env_free_node;
						while (key_tmp_node->next != NULL) {
							key_tmp_node = key_tmp_node->next;
						}
						key_tmp_node->next = env_free_node;
					}
				}
				else{
					kfree(env_free_node);
				}
				#else
				if (key_oobinfo->timestamp > aml_chip->aml_nandkey_info->env_valid_node->timestamp) {

					env_free_node->phy_blk_addr = aml_chip->aml_nandkey_info->env_valid_node->phy_blk_addr;
					env_free_node->ec = aml_chip->aml_nandkey_info->env_valid_node->ec;
					aml_chip->aml_nandkey_info->env_valid_node->phy_blk_addr = start_blk;
					aml_chip->aml_nandkey_info->env_valid_node->phy_page_addr = 0;
					aml_chip->aml_nandkey_info->env_valid_node->ec = key_oobinfo->ec;
					aml_chip->aml_nandkey_info->env_valid_node->timestamp = key_oobinfo->timestamp;	
				}
				else {
					env_free_node->phy_blk_addr = start_blk;
					env_free_node->ec = key_oobinfo->ec;
				}
				if (aml_chip->aml_nandkey_info->env_free_node == NULL)
					aml_chip->aml_nandkey_info->env_free_node = env_free_node;
				else {
					key_tmp_node = aml_chip->aml_nandkey_info->env_free_node;
					while (key_tmp_node->next != NULL) {
						key_tmp_node = key_tmp_node->next;
					}
					key_tmp_node->next = env_free_node;
				}
				#endif
			}
			else {

				aml_chip->aml_nandkey_info->env_valid_node->phy_blk_addr = start_blk;
				aml_chip->aml_nandkey_info->env_valid_node->phy_page_addr = 0;
				aml_chip->aml_nandkey_info->env_valid_node->ec = key_oobinfo->ec;
				aml_chip->aml_nandkey_info->env_valid_node->timestamp = key_oobinfo->timestamp;	
			}
		}
		else if (key_blk < max_key_blk) {
			env_free_node = kzalloc(sizeof(struct env_free_node_t), GFP_KERNEL);
			if (env_free_node == NULL)
				return -ENOMEM;

			env_free_node->phy_blk_addr = start_blk;
			env_free_node->ec = key_oobinfo->ec;
			if (aml_chip->aml_nandkey_info->env_free_node == NULL)
				aml_chip->aml_nandkey_info->env_free_node = env_free_node;
			else {
				key_tmp_node = aml_chip->aml_nandkey_info->env_free_node;
				key_prev_node = key_tmp_node;
				while (key_tmp_node != NULL) {
					if (key_tmp_node->dirty_flag == 1)
						break;
					key_prev_node = key_tmp_node;
					key_tmp_node = key_tmp_node->next;
				}
				if (key_prev_node == key_tmp_node) {
					env_free_node->next = key_tmp_node;
					aml_chip->aml_nandkey_info->env_free_node = env_free_node;
				}
				else {
					key_prev_node->next = env_free_node;
					env_free_node->next = key_tmp_node;
				}
			}
		}
		key_blk++;
		if(key_blk<max_key_blk)
		{
			aml_chip->aml_nandkey_info->end_block++;
			printk("end_block=%d\n",aml_chip->aml_nandkey_info->end_block);
		}
		if ((key_blk >= max_key_blk) && (aml_chip->aml_nandkey_info->env_valid == 1))
			break;

	} while ((++start_blk) < ENV_NAND_SCAN_BLK); //total_blk  ENV_NAND_SCAN_BLK
	if (start_blk >= ENV_NAND_SCAN_BLK) {  //total_blk  ENV_NAND_SCAN_BLK
		memcpy(aml_chip->aml_nandkey_info->nand_bbt_info.bbt_head_magic, BBT_HEAD_MAGIC, 4);
		memcpy(aml_chip->aml_nandkey_info->nand_bbt_info.bbt_tail_magic, BBT_TAIL_MAGIC, 4);
	}

	if (aml_chip->aml_nandkey_info->env_valid == 1) {

		aml_oob_ops.mode = MTD_OOB_AUTO;
		aml_oob_ops.len = mtd->writesize;
		aml_oob_ops.ooblen = sizeof(struct env_oobinfo_t);
		aml_oob_ops.ooboffs = mtd->ecclayout->oobfree[0].offset;
		aml_oob_ops.datbuf = data_buf;
		aml_oob_ops.oobbuf = key_oob_buf;

		for (i=0; i<pages_per_blk; i++) {

			memset((unsigned char *)aml_oob_ops.datbuf, 0x0, mtd->writesize);
			memset((unsigned char *)aml_oob_ops.oobbuf, 0x0, aml_oob_ops.ooblen);

			offset = aml_chip->aml_nandkey_info->env_valid_node->phy_blk_addr;
			offset *= mtd->erasesize;
			offset += i * mtd->writesize;
			error = mtd->read_oob(mtd, offset, &aml_oob_ops);
			if ((error != 0) && (error != -EUCLEAN)) {
				printk("blk check good but read failed: %llx, %d\n", (uint64_t)offset, error);
				continue;
			}

			#ifdef NAND_KEY_SAVE_MULTI_BLOCK
			if (!memcmp(key_oobinfo->name, ENV_KEY_MAGIC, 4)){
				aml_chip->aml_nandkey_info->env_valid_node->phy_page_addr = i;
				tmp_valid_node = aml_chip->aml_nandkey_info->env_valid_node->next;
				while(tmp_valid_node != NULL){
					tmp_valid_node->phy_page_addr = i;
					//printk("valid page:phy_page_addr:%d,%s,%d\n",tmp_valid_node->phy_page_addr,__func__,__LINE__);
					tmp_valid_node = tmp_valid_node->next;
				}
			}
			else
				break;
			#else
			if (!memcmp(key_oobinfo->name, ENV_KEY_MAGIC, 4))
				aml_chip->aml_nandkey_info->env_valid_node->phy_page_addr = i;
			else
				break;
			#endif
		}
	}
	#ifdef NAND_KEY_SAVE_MULTI_BLOCK
	if ((mtd->writesize < CONFIG_KEYSIZE) && (aml_chip->aml_nandkey_info->env_valid == 1)) {
		i = (CONFIG_KEYSIZE + mtd->writesize - 1) / mtd->writesize;
		aml_chip->aml_nandkey_info->env_valid_node->phy_page_addr -= (i - 1);
		
		tmp_valid_node = aml_chip->aml_nandkey_info->env_valid_node->next;
		while(tmp_valid_node != NULL){
			tmp_valid_node->phy_page_addr -= (i - 1);
			tmp_valid_node = tmp_valid_node->next;
		}
	}
	#else
	if ((mtd->writesize < CONFIG_KEYSIZE) && (aml_chip->aml_nandkey_info->env_valid == 1)) {
		i = (CONFIG_KEYSIZE + mtd->writesize - 1) / mtd->writesize;
		aml_chip->aml_nandkey_info->env_valid_node->phy_page_addr -= (i - 1);
	}
	#endif

	offset = aml_chip->aml_nandkey_info->env_valid_node->phy_blk_addr;
	offset *= mtd->erasesize;
	offset += aml_chip->aml_nandkey_info->env_valid_node->phy_page_addr * mtd->writesize;
	//printk("aml nand key valid addr: %llx \n", (uint64_t)offset);
	if(aml_chip->aml_nandkey_info->env_valid_node->phy_blk_addr < 0){
		printk("aml nand key not have valid addr: not wrote\n");
	}
	else{
		printk("aml nand key valid addr: %llx \n", offset);
	}
	#ifdef NAND_KEY_SAVE_MULTI_BLOCK
	tmp_valid_node = aml_chip->aml_nandkey_info->env_valid_node->next;
	while(tmp_valid_node != NULL){
		offset = tmp_valid_node->phy_blk_addr;
		offset *= mtd->erasesize;
		offset += tmp_valid_node->phy_page_addr * mtd->writesize;
		printk("aml nand key valid addr: %llx \n", (uint64_t)offset);
		tmp_valid_node = tmp_valid_node->next;
	}
	#endif
	printk(KERN_DEBUG "CONFIG_KEYSIZE=0x%x; KEYSIZE=0x%x; bbt=0x%x; default_keyironment_size=0x%x\n",
		CONFIG_KEYSIZE, KEYSIZE, sizeof(struct aml_nand_bbt_info), default_keyironment_size);
	kfree(data_buf);
	return 0;
}
#endif
static int aml_nand_key_check(struct mtd_info *mtd)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	struct aml_nand_platform *plat = aml_chip->platform;
	struct platform_nand_chip *chip = &plat->platform_nand_data.chip;
	struct aml_nand_bbt_info *nand_bbt_info;
	struct aml_nand_part_info *aml_nand_part;
	//struct mtd_partition *parts;
	mesonkey_t *key_ptr;
	int error = 0, start_blk, total_blk, update_key_flag = 0, i, j, nr, max_env_blk, phys_erase_shift;
	uint64_t offset, env_offset;

	chip = chip;
	nr = 0;
	error = aml_nand_key_init(mtd);
	if (error)
		return error;
	key_ptr = kzalloc(sizeof(mesonkey_t), GFP_KERNEL);
	if (key_ptr == NULL)
		return -ENOMEM;

	if (aml_chip->aml_nandkey_info->env_valid == 1) {
#if 0
		offset = aml_chip->aml_nandkey_info->env_valid_node->phy_blk_addr;
		offset *= mtd->erasesize;
		offset += aml_chip->aml_nandkey_info->env_valid_node->phy_page_addr * mtd->writesize;

		error = aml_nand_get_key(mtd,(u_char *)key_ptr);
		if (error) {
			printk("nand key read failed: %llx, %d\n", (uint64_t)offset, error);
			goto exit;
		}

		phys_erase_shift = fls(mtd->erasesize) - 1;
		offset = (NAND_MINI_PART_SIZE + 1024 * mtd->writesize / aml_chip->plane_num);
#ifdef NEW_NAND_SUPPORT	
		if((aml_chip->new_nand_info.type) && (aml_chip->new_nand_info.type < 10))
			offset += RETRY_NAND_BLK_NUM* mtd->erasesize;
#endif			
		start_blk = (int)(offset >> phys_erase_shift);
		total_blk = (int)(mtd->size >> phys_erase_shift);
		nand_bbt_info = (struct aml_nand_bbt_info *)(key_ptr->data + default_keyironment_size);
		if ((!memcmp(nand_bbt_info->bbt_head_magic, BBT_HEAD_MAGIC, 4)) && (!memcmp(nand_bbt_info->bbt_tail_magic, BBT_TAIL_MAGIC, 4))) {
			for (i=start_blk; i<total_blk; i++) {
				aml_chip->block_status[i] = NAND_BLOCK_GOOD;
				for (j=0; j<MAX_BAD_BLK_NUM; j++) {
					if (nand_bbt_info->nand_bbt[j] == i) {
						aml_chip->block_status[i] = NAND_BLOCK_BAD;
						break;
					}
				}
			}

			if (chip->set_parts)
				chip->set_parts(mtd->size, chip);
			aml_nand_part = nand_bbt_info->aml_nand_part;
			if (plat->platform_nand_data.chip.nr_partitions == 0) {
				parts = kzalloc((MAX_MTD_PART_NUM * sizeof(struct mtd_partition)), GFP_KERNEL);
				if (!parts) {
					error = -ENOMEM;
					goto exit;
				}
				plat->platform_nand_data.chip.partitions = parts;
				nr = 0;
				while(memcmp(aml_nand_part->mtd_part_magic, MTD_PART_MAGIC, 4) == 0) {
					parts->name = kzalloc(MAX_MTD_PART_NAME_LEN, GFP_KERNEL);
					if (!parts->name) {
						error = -ENOMEM;
						goto exit;
					}		
					strncpy(parts->name, aml_nand_part->mtd_part_name, MAX_MTD_PART_NAME_LEN);
					parts->offset = aml_nand_part->offset;
					parts->size = aml_nand_part->size;
					parts->mask_flags = aml_nand_part->mask_flags;
					nr++;
					parts++;
					aml_nand_part++;
				}
				plat->platform_nand_data.chip.nr_partitions = nr;
			}
			else {
				parts = plat->platform_nand_data.chip.partitions;
				nr = 0;
				if (strlen(parts->name) >= MAX_MTD_PART_NAME_LEN)
					parts->name[MAX_MTD_PART_NAME_LEN - 1] = '\0';
				while(memcmp(aml_nand_part->mtd_part_magic, MTD_PART_MAGIC, 4) == 0) {
					nr++;
					if (nr > plat->platform_nand_data.chip.nr_partitions) {
						update_key_flag = 1;
						memset((unsigned char *)aml_nand_part, 0, sizeof(struct aml_nand_part_info));
						aml_nand_part++;
						continue;
					}

					if (strcmp(parts->name, aml_nand_part->mtd_part_name)) {
						printk("mtd parttion %d name %s changed to %s \n", nr, parts->name, aml_nand_part->mtd_part_name);
						update_key_flag = 1;
						strncpy(aml_nand_part->mtd_part_name, parts->name, MAX_MTD_PART_NAME_LEN);
					}
					if (parts->offset != aml_nand_part->offset) {
						printk("mtd parttion %d offset %llx changed to %llx \n", nr, aml_nand_part->offset, parts->offset);
						update_key_flag = 1;
						aml_nand_part->offset = parts->offset;
					}
					if (parts->size != aml_nand_part->size) {
						printk("mtd parttion %d size %llx changed to %llx \n", nr, aml_nand_part->size, parts->size);
						update_key_flag = 1;
						aml_nand_part->size = parts->size;
					}
					if (parts->mask_flags != aml_nand_part->mask_flags) {
						printk("mtd parttion %d mask_flags %x changed to %x \n", nr, aml_nand_part->mask_flags, parts->mask_flags);
						update_key_flag = 1;
						aml_nand_part->mask_flags = parts->mask_flags;
					}

					parts++;
					aml_nand_part++;
				}
				if (nr < plat->platform_nand_data.chip.nr_partitions) {
					update_key_flag = 1;
					for (i=nr; i<plat->platform_nand_data.chip.nr_partitions; i++) {
						parts = plat->platform_nand_data.chip.partitions + i;
						aml_nand_part = nand_bbt_info->aml_nand_part + i;
						memcpy(aml_nand_part->mtd_part_magic, MTD_PART_MAGIC, 4);
						strncpy(aml_nand_part->mtd_part_name, parts->name, MAX_MTD_PART_NAME_LEN);
						aml_nand_part->offset = parts->offset;
						aml_nand_part->size = parts->size;
						aml_nand_part->mask_flags = parts->mask_flags;
					}
				}
			}

			memcpy((unsigned char *)aml_chip->aml_nandkey_info->nand_bbt_info.bbt_head_magic, (unsigned char *)nand_bbt_info, sizeof(struct aml_nand_bbt_info));
		}
#endif 	
	}else {
			update_key_flag =1 ;
			nand_bbt_info = (struct aml_nand_bbt_info *)(key_ptr->data + default_keyironment_size);
			aml_nand_part = nand_bbt_info->aml_nand_part;			
			
			memcpy(nand_bbt_info->nand_bbt,aml_chip->aml_nandkey_info->nand_bbt_info.nand_bbt,MAX_BAD_BLK_NUM*sizeof(int16_t));
			memcpy(nand_bbt_info->bbt_head_magic, BBT_HEAD_MAGIC, 4);
			memcpy(nand_bbt_info->bbt_tail_magic, BBT_TAIL_MAGIC, 4);	
			phys_erase_shift = fls(mtd->erasesize) - 1;
#ifdef KEY_SAVE_NAND_TAIL
			offset = aml_chip->aml_nandkey_info->start_block;
			offset *= mtd->erasesize;
#else
			//offset = (NAND_MINI_PART_SIZE + 1024 * mtd->writesize / aml_chip->plane_num);
			offset = (1024 * mtd->writesize / aml_chip->plane_num);

			max_env_blk = (NAND_MINI_PART_SIZE >> phys_erase_shift);
			if(max_env_blk < NAND_MINI_PART_BLOCKNUM)
				max_env_blk = NAND_MINI_PART_BLOCKNUM;
			start_blk = 0;
			do{
				env_offset = offset + start_blk * mtd->erasesize;
				error = mtd->block_isbad(mtd, env_offset);
				if (error) {
					offset += mtd->erasesize;
					continue;
				}
				start_blk++;
			}while(start_blk < max_env_blk);
			offset += max_env_blk * mtd->erasesize;

#ifdef NEW_NAND_SUPPORT	
			if((aml_chip->new_nand_info.type) && (aml_chip->new_nand_info.type < 10))
				offset += RETRY_NAND_BLK_NUM* mtd->erasesize;
#endif			
#endif  //KEY_SAVE_NAND_TAIL
			start_blk = (int)(offset >> phys_erase_shift);
			total_blk = (int)(mtd->size >> phys_erase_shift);
			for (i=start_blk; i<total_blk; i++) {
				aml_chip->block_status[i] = NAND_BLOCK_GOOD;
				for (j=0; j<MAX_BAD_BLK_NUM; j++) {
					if (nand_bbt_info->nand_bbt[j] == i) {
						aml_chip->block_status[i] = NAND_BLOCK_BAD;
						break;
					}
				}
			}			
			memcpy(aml_chip->aml_nandkey_info->nand_bbt_info.bbt_head_magic,key_ptr->data + default_keyironment_size, sizeof(struct aml_nand_bbt_info));			
	}
		

	if (update_key_flag) {
		error = aml_nand_save_key(mtd, (u_char *)key_ptr);
		if (error) {
			printk("nand key save failed: %d\n", error);
			goto exit;
		}
	}

exit:
	kfree(key_ptr);
	return 0;
}

static int aml_nand_update_key(struct mtd_info *mtd)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	mesonkey_t *key_ptr;
	uint64_t offset;
	int error = 0;

	key_ptr = kzalloc(sizeof(mesonkey_t), GFP_KERNEL);
	if (key_ptr == NULL)
		return -ENOMEM;

	if (aml_chip->aml_nandkey_info->env_valid == 1) {

		offset = aml_chip->aml_nandkey_info->env_valid_node->phy_blk_addr;
		offset *= mtd->erasesize;
		offset += aml_chip->aml_nandkey_info->env_valid_node->phy_page_addr * mtd->writesize;

		error = aml_nand_read_key (mtd, offset, (u_char *)key_ptr);
		if (error) {
			printk("nand key read failed: %llx, %d\n", (uint64_t)offset, error);
			goto exit;
		}

		error = aml_nand_save_key(mtd, (u_char *)key_ptr);
		if (error) {
			printk("update key bbt failed %d \n", error);
			goto exit;
		}
	}
exit:
	kfree(key_ptr);
	return error;
}


static struct mtd_info *nand_key_mtd = NULL;


/*
 * This funcion reads the u-boot keyionment variables. 
 * The f_pos points directly to the key location.
 */

static int32_t nand_key_read(aml_keybox_provider_t * provider, uint8_t *buf,int len,int flags)
{
	mesonkey_t *key_ptr = NULL;
	int error = 0;

	if(len > default_keyironment_size)
	{
		printk("key data len too much,%s\n",__func__);
		return -EFAULT;
	}
	key_ptr = kzalloc(CONFIG_KEYSIZE, GFP_KERNEL);
	if(key_ptr == NULL)
		return -ENOMEM;
	memset(key_ptr,0,CONFIG_KEYSIZE);
	error = aml_nand_get_key(nand_key_mtd,(u_char *)key_ptr);
	if (error) 
	{
		printk("read key error,%s\n",__func__);
		error = -EFAULT;
		goto exit;
	}
	memcpy(buf, key_ptr->data + 0, len);
exit:
	kfree(key_ptr);
	return 0;
}

static int32_t nand_key_write(aml_keybox_provider_t * provider, uint8_t *buf,int len)
{
	mesonkey_t *key_ptr = NULL;
	int error = 0;

	if(len > default_keyironment_size)
	{
		printk("key data len too much,%s\n",__func__);
		return -EFAULT;
	}
	key_ptr = kzalloc(CONFIG_KEYSIZE, GFP_KERNEL);
	if(key_ptr == NULL)
		return -ENOMEM;
	memset(key_ptr,0,CONFIG_KEYSIZE);
	memcpy(key_ptr->data + 0, buf, len);

	error = aml_nand_save_key(nand_key_mtd, (u_char *)key_ptr);
	if (error) 
	{
		printk("save key error,%s\n",__func__);
		error = -EFAULT;
		goto exit;
	}
exit:
	kfree(key_ptr);
	return error;
}






static aml_keybox_provider_t nand_provider={
		.name="nand_key",
		.read=nand_key_read,
		.write=nand_key_write,

};

int aml_key_init(struct aml_nand_chip *aml_chip)
{
	//struct device *devp;
	//static dev_t nand_key_devno;
	aml_keybox_provider_t *provider;
	int err = 0;
	//pr_info("nand key: nand_key_probe. \n");

	err = aml_nand_key_check(&aml_chip->mtd);
	if(err){
		printk("invalid nand key\n");
	}

	nand_key_mtd = &aml_chip->mtd;
	nand_provider.priv=nand_key_mtd;	

	provider = aml_keybox_provider_get(nand_provider.name);
	if(provider){
		return err;
	}
	err = aml_keybox_provider_register(&nand_provider);
	if(err){
		BUG();
	}
	return err;
}
int nandkey_provider_register(void)
{
	int err = 0;
#if 0
	aml_keybox_provider_t *provider;
	provider = aml_keybox_provider_get(nand_provider.name);
	if(provider){
		return err;
	}
	err = aml_keybox_provider_register(&nand_provider);
	if(err){
		BUG();
	}
#endif
	return err;
}
