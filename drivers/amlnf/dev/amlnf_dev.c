/*
 * Aml nftl dev
 *
 * (C) 2012 8
 */

#include "../include/amlnf_dev.h"

int boot_device_flag =0;


int is_phydev_off_adjust(void)
{
	int ret = 0;
	#ifdef NAND_ADJUST_PART_TABLE
		ret = 1;
	#endif
	return  ret ;
}
int get_adjust_block_num(void)
{
	int ret = 0;
	#ifdef NAND_ADJUST_PART_TABLE
		ret = ADJUST_BLOCK_NUM;
	#endif
	return	ret ;
}
int amlnf_get_logicdev(struct amlnf_logicdev_t *amlnf_logicdev)
{
#ifndef AML_NAND_UBOOT	
		mutex_lock(&amlnf_logicdev->lock);
#endif
	return 0;
}

int amlnf_free_logicdev(struct amlnf_logicdev_t *amlnf_logicdev)
{
#ifndef AML_NAND_UBOOT	
	mutex_unlock(&amlnf_logicdev->lock);
#endif
	return 0;
}


/*****************************************************************************
*Name         :
*Description  :
*Parameter    :
*Return       :
*Note         :
*****************************************************************************/

#ifndef AML_NAND_UBOOT
/*****************************************************************************
*Name         :
*Description  :
*Parameter    :
*Return       :
*Note         :
*****************************************************************************/
static ssize_t nfdev_debug(struct class *class,struct class_attribute *attr,char *buf)
{
    //struct amlnf_dev* nf_dev = container_of(class, struct amlnf_dev, debug);

    //print_nftl_part(nf_dev -> aml_nftl_part);

    return 0;
}

static struct class_attribute phydev_class_attrs[] = {
    __ATTR(info,       S_IRUGO | S_IWUSR, show_nand_info,    NULL),
    __ATTR(bbt_table,       S_IRUGO | S_IWUSR, show_bbt_table,    NULL),    
    __ATTR(page_read,  S_IRUGO | S_IWUSR, NULL,    nand_page_read),  
    __ATTR(page_write,  S_IRUGO | S_IWUSR, NULL,    nand_page_write),
    __ATTR(version,       S_IRUGO | S_IWUSR, show_amlnf_version_info,    NULL),
    __ATTR_NULL
};

static struct class_attribute logicdev_class_attrs[] = {
    __ATTR(part,  S_IRUGO , show_part_struct,    NULL),
    __ATTR(list,  S_IRUGO , show_list,    NULL),
    __ATTR(gcall,  S_IRUGO , do_gc_all,    NULL),
    __ATTR(gcone,  S_IRUGO , do_gc_one,    NULL),
    __ATTR(test,  S_IRUGO | S_IWUSR , NULL,    do_test),
    __ATTR_NULL
};

static struct class_attribute nfdev_class_attrs[] = {
    __ATTR(debug,  S_IRUGO , nfdev_debug,    NULL),
    __ATTR_NULL
};

/*****************************************************************************
*Name         :
*Description  :
*Parameter    :
*Return       :
*Note         :
*****************************************************************************/
static int phydev_cls_suspend(struct device *dev, pm_message_t state)
{
	struct amlnand_phydev *phydev = (struct amlnand_phydev *)dev_get_drvdata(dev);

	if (phydev && phydev->suspend){
		return phydev->suspend(phydev);
	}
	else{
		return 0;
	}
}

/*****************************************************************************
*Name         :
*Description  :
*Parameter    :
*Return       :
*Note         :
*****************************************************************************/
static int phydev_cls_resume(struct device *dev, pm_message_t state)
{
	struct amlnand_phydev *phydev = (struct amlnand_phydev *)dev_get_drvdata(dev);

	if (phydev && phydev->suspend){
		return phydev->suspend(phydev);
	}
	else{
		return 0;
	}
}


static struct class phydev_class = {
	.name = "amlphydev",
	.owner = THIS_MODULE,
	.suspend = phydev_cls_suspend,
	.resume = phydev_cls_resume,
};

int amlnf_pdev_register(struct amlnand_phydev *phydev, unsigned char dev_num)
{
	int ret = 0;

	//phydev->dev.class = &phydev_class;
	dev_set_name(&phydev->dev, phydev->name,0); 	
	dev_set_drvdata(&phydev->dev, phydev);		
	ret = device_register(&phydev->dev);		
	if (ret != 0){
		aml_nand_msg("device register failed for %s", phydev->name);
		aml_nand_free(phydev);
		goto exit_error0;
	}

	phydev->cls.name = aml_nand_malloc(strlen((const char*)phydev->name)+8);
	snprintf(phydev->cls.name, (MAX_DEVICE_NAME_LEN+8),
	  	 "%s%s", "phy_", (char *)(phydev->name));
	phydev->cls.class_attrs = phydev_class_attrs;
	ret = class_register(&phydev->cls);
	if(ret){
		aml_nand_msg(" class register nand_class fail for %s", phydev->name);	
		goto exit_error1;
	}

	return 0;

exit_error1:
	aml_nand_free(phydev->cls.name);
exit_error0:
	return ret;
}

/*****************************************************************************
*Name         :
*Description  :
*Parameter    :
*Return       :
*Note         :
*****************************************************************************/
static int aml_nftl_thread(void *arg)
{
    struct amlnf_logicdev_t *amlnf_logicdev = arg;
    unsigned long period = NFTL_MAX_SCHEDULE_TIMEOUT / 10;
    struct timespec ts_nftl_current;

    while (!kthread_should_stop()) {
//      struct aml_nftl_part_t *aml_nftl_part = nftl_blk->aml_nftl_part;

        mutex_lock(&amlnf_logicdev->lock);

        if(aml_nftl_get_part_write_cache_nums(amlnf_logicdev->priv) > 0){
            ktime_get_ts(&ts_nftl_current);
            if ((ts_nftl_current.tv_sec - amlnf_logicdev->ts_write_start.tv_sec) >= NFTL_FLUSH_DATA_TIME){
                //aml_nftl_dbg("aml_nftl_thread flush data: %d:%s\n", aml_nftl_part->cache.cache_write_nums,nftl_blk->nbd.ntd->name);
                amlnf_logicdev->flush(amlnf_logicdev);
            }
        }

	logicdev_bg_handle(amlnf_logicdev->priv);	

        mutex_unlock(&amlnf_logicdev->lock);

        set_current_state(TASK_INTERRUPTIBLE);
        schedule_timeout(period);
    }

    amlnf_logicdev->thread = NULL;
    return 0;
}


/*****************************************************************************
*Name         :
*Description  :
*Parameter    :
*Return       :
*Note         :
*****************************************************************************/
static int amlnf_reboot_notifier(struct notifier_block *nb, unsigned long priority, void * arg)
{
	int error = 0;
	struct amlnf_logicdev_t *amlnf_logicdev = amlnf_notifier_to_blk(nb);

	mutex_lock(&amlnf_logicdev->lock);
	error = amlnf_logicdev->flush(amlnf_logicdev);
	mutex_unlock(&amlnf_logicdev->lock);

	if(amlnf_logicdev->thread!=NULL){
		kthread_stop(amlnf_logicdev->thread); //add stop thread to ensure nftl quit safely
		amlnf_logicdev->thread=NULL;
	}

	return error;
}

static int amlnf_blk_open(struct block_device *bdev, fmode_t mode)
{
	return 0;
}

static int amlnf_blk_release(struct gendisk *disk, fmode_t mode)
{
	return 0;
}


static int amlnf_blk_getgeo(struct block_device *bdev, struct hd_geometry *geo)
{
	return 0;
}

static int amlnf_blk_ioctl(struct block_device *bdev, fmode_t mode,
			      unsigned int cmd, unsigned long arg)
{
	return 0;
}


static const struct block_device_operations amlnf_blk_ops = {
	.owner		= THIS_MODULE,
	.open		= amlnf_blk_open,
	.release	= amlnf_blk_release,
	.ioctl		= amlnf_blk_ioctl,
	.getgeo		= amlnf_blk_getgeo,
};

static int amlnf_init_bounce_buf(struct amlnf_dev* nf_dev, struct request_queue *rq)
{
	int ret=0;
	unsigned int bouncesz;
	struct amlnand_phydev *phydev = nf_dev->nand_dev;	

	if(nf_dev->queue && nf_dev->bounce_sg){
		aml_nftl_dbg("_nftl_init_bounce_buf already init %x\n",PAGE_CACHE_SIZE);
		return 0;
	}
	
	nf_dev->queue = rq;

	bouncesz = (phydev->writesize * NFTL_CACHE_FORCE_WRITE_LEN);
	if(bouncesz < AML_NFTL_BOUNCE_SIZE)
		bouncesz = AML_NFTL_BOUNCE_SIZE;

	spin_lock_irq(rq->queue_lock);
	queue_flag_test_and_set(QUEUE_FLAG_NONROT, rq);
	blk_queue_bounce_limit(nf_dev->queue, BLK_BOUNCE_HIGH);
	blk_queue_max_hw_sectors(nf_dev->queue, bouncesz / BYTES_PER_SECTOR);
	blk_queue_physical_block_size(nf_dev->queue, bouncesz);
	blk_queue_max_segments(nf_dev->queue, bouncesz / PAGE_CACHE_SIZE);
	blk_queue_max_segment_size(nf_dev->queue, bouncesz);
	spin_unlock_irq(rq->queue_lock);

	nf_dev->req = NULL;
	nf_dev->bounce_sg = aml_nftl_malloc(sizeof(struct scatterlist) * (bouncesz/PAGE_CACHE_SIZE));
	if (!nf_dev->bounce_sg) {
		ret = -ENOMEM;
		aml_nftl_dbg("aml_nftl_malloc failed need 0x%x",(sizeof(struct scatterlist) * (bouncesz/PAGE_CACHE_SIZE)) );
		blk_cleanup_queue(nf_dev->queue);
		return ret;
	}

	sg_init_table(nf_dev->bounce_sg, bouncesz / PAGE_CACHE_SIZE);

	return 0;
}

/*****************************************************************************
*Name         :
*Description  :
*Parameter    :
*Return       :
*Note         :
*****************************************************************************/
static int aml_nftl_calculate_sg(struct amlnf_dev *nftl_blk, size_t buflen, unsigned **buf_addr, unsigned *offset_addr)
{
    struct scatterlist *sgl;
    unsigned int offset = 0, segments = 0, buf_start = 0;
    struct sg_mapping_iter miter;
    unsigned long flags;
    unsigned int nents;
    unsigned int sg_flags = SG_MITER_ATOMIC;

    nents = nftl_blk->bounce_sg_len;
    sgl = nftl_blk->bounce_sg;

    if (rq_data_dir(nftl_blk->req) == WRITE)
        sg_flags |= SG_MITER_FROM_SG;
    else
        sg_flags |= SG_MITER_TO_SG;

    sg_miter_start(&miter, sgl, nents, sg_flags);

    local_irq_save(flags);

    while (offset < buflen) {
        unsigned int len;
        if(!sg_miter_next(&miter))
            break;

        if (!buf_start) {
            segments = 0;
            *(buf_addr + segments) = (unsigned *)miter.addr;
            *(offset_addr + segments) = offset;
            buf_start = 1;
        }
        else {
            if ((unsigned char *)(*(buf_addr + segments)) + (offset - *(offset_addr + segments)) != miter.addr) {
                segments++;
                *(buf_addr + segments) = (unsigned *)miter.addr;
                *(offset_addr + segments) = offset;
            }
        }

        len = min(miter.length, buflen - offset);
        offset += len;
    }
    *(offset_addr + segments + 1) = offset;

    sg_miter_stop(&miter);

    local_irq_restore(flags);

    return segments;
}


/*****************************************************************************
*Name         :
*Description  :
*Parameter    :
*Return       :
*Note         :
*****************************************************************************/
static int do_nfdev_request(struct amlnf_dev* nf_dev,struct request *req)
{
	int ret = 0, segments, i;
	unsigned long block, nblk, blk_addr, blk_cnt;

	if(!nf_dev->queue || !nf_dev->bounce_sg){
		if (amlnf_init_bounce_buf(nf_dev, nf_dev->queue)){
			aml_nftl_dbg("_nftl_init_bounce_buf  failed\n");
		}
	}

	unsigned short max_segm = queue_max_segments(nf_dev->queue);
	unsigned *buf_addr[max_segm+1];
	unsigned offset_addr[max_segm+1];
	size_t buflen;
	char *buf;

	memset((unsigned char *)buf_addr, 0, (max_segm+1)*4);
	memset((unsigned char *)offset_addr, 0, (max_segm+1)*4);
	nf_dev->req = req;
	block = ((blk_rq_pos(req)<< SHIFT_PER_SECTOR)>>SHIFT_PER_SECTOR);
	nblk = blk_rq_sectors(req);
	buflen = (nblk << SHIFT_PER_SECTOR);

	if (!blk_fs_request(req))
	    return -EIO;

	if (blk_rq_pos(req) + blk_rq_cur_sectors(req) > get_capacity(req->rq_disk))
	    return -EIO;

	if (blk_discard_rq(req))
	    return 0;

	nf_dev->bounce_sg_len = blk_rq_map_sg(nf_dev->queue, nf_dev->req, nf_dev->bounce_sg);
	segments = aml_nftl_calculate_sg(nf_dev, buflen, buf_addr, offset_addr);
	if (offset_addr[segments+1] != (nblk << SHIFT_PER_SECTOR))
	    return -EIO;

	//  aml_nftl_dbg("nftl segments: %d\n", segments+1);

	mutex_lock(&nf_dev->mutex_lock);
	switch(rq_data_dir(req)) {
	case READ:
		for(i=0; i<(segments+1); i++) {
			blk_addr = (block + (offset_addr[i] >> SHIFT_PER_SECTOR));
			blk_cnt = ((offset_addr[i+1] - offset_addr[i]) >> SHIFT_PER_SECTOR);
			buf = (char *)buf_addr[i];
			//              aml_nftl_dbg("read blk_addr: %d blk_cnt: %d buf: %x\n", blk_addr,blk_cnt,buf);
			if (nf_dev->read_sector(nf_dev, blk_addr, blk_cnt, buf)) {
				ret = -EIO;
				break;
			}
		}
		bio_flush_dcache_pages(nf_dev->req->bio);
	break;

	case WRITE:
		bio_flush_dcache_pages(nf_dev->req->bio);
		for(i=0; i<(segments+1); i++) {
			blk_addr = (block + (offset_addr[i] >> SHIFT_PER_SECTOR));
			blk_cnt = ((offset_addr[i+1] - offset_addr[i]) >> SHIFT_PER_SECTOR);
			buf = (char *)buf_addr[i];
			//              aml_nftl_dbg("write blk_addr: %d blk_cnt: %d buf: %x\n", blk_addr,blk_cnt,buf);
			if (nf_dev->write_sector(nf_dev, blk_addr, blk_cnt, buf)) {
				ret = -EIO;
				break;
			}
		}
	break;

	default:
		aml_nftl_dbg("Unknown request 0x%x", rq_data_dir(req));
	break;
	}

	mutex_unlock(&nf_dev->mutex_lock);

	return ret;
}


#define blk_queue_plugged(q)    test_bit(18, &(q)->queue_flags)
static int amlnf_blktrans_thread(void *arg)
{
	struct amlnf_dev* nf_dev = arg;
	struct request_queue *queue = nf_dev->queue;
	struct request *req = NULL;
	int res;
	int background_done = 0;

	spin_lock_irq(queue->queue_lock);
    
	while (!kthread_should_stop()) {
		
                nf_dev->bg_stop = false;
		if (!blk_queue_plugged(queue))
			req = blk_fetch_request(queue);
		if (!req) {
#if 0
			if (nf_dev->background && !background_done) {
				spin_unlock_irq(queue->queue_lock);
				mutex_lock(&nf_dev->lock);
				nf_dev->background(nf_dev);
				mutex_unlock(&nf_dev->lock);
				spin_lock_irq(queue->queue_lock);
				/*
				 * Do background processing just once per idle
				 * period.
				 */
				background_done = !nf_dev->bg_stop;
				continue;
		}
#endif
		set_current_state(TASK_INTERRUPTIBLE);
			
            if (kthread_should_stop())
                set_current_state(TASK_RUNNING);			
			
			spin_unlock_irq(queue->queue_lock);
			schedule();
			spin_lock_irq(queue->queue_lock);
			continue;
		}

		spin_unlock_irq(queue->queue_lock);

		mutex_lock(&nf_dev->mutex_lock_req);
		res = do_nfdev_request(nf_dev, req);
		mutex_unlock(&nf_dev->mutex_lock_req);

		spin_lock_irq(queue->queue_lock);

		if (blk_rq_sectors(req) > 0) {
		 	__blk_end_request(req, res, 512*blk_rq_sectors(req));
			req = NULL;
	        }
	        
	    background_done = 0;
	}

	if (req)
		__blk_end_request_all(req, -EIO);

	spin_unlock_irq(queue->queue_lock);

	return 0;
}

static void amlnf_blktrans_request(struct request_queue *rq)
{
	struct amlnf_dev* nf_dev;
	struct request *req = NULL;

	nf_dev = rq->queuedata;

	if (!nf_dev)
		while ((req = blk_fetch_request(rq)) != NULL)
			__blk_end_request_all(req, -ENODEV);
	else {
		nf_dev->bg_stop = true;
		wake_up_process(nf_dev->thread);
	}
}

int amlnf_ldev_register(void)
{
	struct gendisk *gd;
	struct amlnf_dev* nf_dev = NULL;
	int ret = 0;
	int i=2;
	
	ret = register_blkdev(AMLNF_DEV_MAJOR, "amlnfblk");
	if (ret < 0) {
		aml_nand_msg("Unable to register block device for %s and ret:0x%x",  nf_dev->name, ret);
		goto error0;
	}
	
	list_for_each_entry(nf_dev, &nf_dev_list, list){
		aml_nand_msg(" register block device for %s ",  nf_dev->name);
		i++;
		mutex_init(&nf_dev->mutex_lock_req);	
		mutex_init(&nf_dev->mutex_lock);
		
		kref_init(&nf_dev->ref);
		gd = alloc_disk(1 << 2);
		if (!gd){
			aml_nand_msg("Unable to alloc disk for %s ", nf_dev->name);
			goto error0;
		}

		nf_dev->disk = gd;
		
		gd->private_data = nf_dev;
		gd->major = AMLNF_DEV_MAJOR;
		if(ret){
			gd->major = ret;
		}
		gd->first_minor = (i << 2) ;
		gd->fops = &amlnf_blk_ops;	

		snprintf(gd->disk_name, sizeof(gd->disk_name),  "%s", nf_dev->name);

		set_capacity(gd, nf_dev->size_sector);

		/* Create the request queue */
		spin_lock_init(&nf_dev->queue_lock);
		nf_dev->queue = blk_init_queue(amlnf_blktrans_request, &nf_dev->queue_lock);

		if (!nf_dev->queue)
			goto error3;

		nf_dev->queue->queuedata = nf_dev;
		blk_queue_logical_block_size(nf_dev->queue, BYTES_PER_SECTOR);

		/*if (tr->discard) {
			queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, nf_dev->queue);
			nf_dev->queue->limits.max_discard_sectors = UINT_MAX;
		}*/

		gd->queue = nf_dev->queue;

		/* Create processing thread */
		/* TODO: workqueue ? */
		nf_dev->thread = kthread_run(amlnf_blktrans_thread, nf_dev,
				"%s", nf_dev->name);
		if (IS_ERR(nf_dev->thread)) {
			ret = PTR_ERR(nf_dev->thread);
			goto error4;
		}

		gd->driverfs_dev = &nf_dev->nand_dev->dev;

		if (nf_dev->mask_flags & AMLNF_DEV_RO_MODE)
			set_disk_ro(gd, 1);

		add_disk(gd);
#if 0
		if (nf_dev->disk_attributes) {
			ret = sysfs_create_group(&disk_to_dev(gd)->kobj,
						nf_dev->disk_attributes);
			WARN_ON(ret);
		}
#endif
		amlnf_init_bounce_buf(nf_dev, nf_dev->queue);

	}
#if 0
	nf_dev->debug.name = phydev->cls.name = aml_nand_malloc(strlen((const char*)nf_dev->name)+1);	
	strcpy(nf_dev->debug.name, nf_dev->name);
	nftl_dev->debug.class_attrs = nftl_class_attrs;
	error = class_register(&nftl_dev->debug);
	if(error)
		printk(" class register nand_class fail!\n");
#endif	

	return 0;
	
error4:
	blk_cleanup_queue(nf_dev->queue);
error3:
	put_disk(nf_dev->disk);
error2:
	list_del(&nf_dev->list);
error1:	

error0:
	return ret;
}

#endif

/*****************************************************************************
*Name         :
*Description  :
*Parameter    :
*Return       :
*Note         :
*****************************************************************************/
int amlnf_logicdev_mis_init(struct amlnf_logicdev_t *amlnf_logicdev)
{
	int ret = 0;

#ifndef AML_NAND_UBOOT	
	mutex_init(&amlnf_logicdev->lock);
	
	amlnf_logicdev->nb.notifier_call = amlnf_reboot_notifier;
	register_reboot_notifier(&amlnf_logicdev->nb);

	amlnf_logicdev->thread = kthread_run(aml_nftl_thread, amlnf_logicdev, "%sd", "amlnf_logic");
	if (IS_ERR(amlnf_logicdev->thread)){
		PRINT("aml_nftl_initialize: fail\n");
		return 1;
	}

	  /*setup class*/
	amlnf_logicdev->cls.name = aml_nand_malloc(MAX_DEVICE_NAME_LEN+8);
	snprintf(amlnf_logicdev->cls.name, (MAX_DEVICE_NAME_LEN+8),
		"%s%s", "l_", (char *)(amlnf_logicdev->nand_dev->name));
	amlnf_logicdev->cls.class_attrs = logicdev_class_attrs;
	ret = class_register(&amlnf_logicdev->cls);
	if(ret){
		aml_nand_msg(" class register logdev class fail for %s", amlnf_logicdev->nand_dev->name);   
	}

#endif

	return 0;
}

/*****************************************************************************
*Name         :
*Description  :
*Parameter    :
*Return       :
*Note         :
*****************************************************************************/
int amlnf_dev_init(unsigned flag)
{
	struct amlnand_phydev *phydev = NULL;
	struct amlnf_dev* nf_dev = NULL;
	
	int i = 0, ret = 0;
	
#ifndef AML_NAND_UBOOT
	list_for_each_entry(phydev, &nphy_dev_list, list){
		if ((phydev != NULL)  && 
			(strncmp((char*)phydev->name, NAND_BOOT_NAME, strlen((const char*)NAND_BOOT_NAME)))){				
			ret = amlnf_pdev_register(phydev, i++);
			if(ret < 0){
				aml_nand_msg("nand add nftl failed");
				goto exit_error0;
			}			
		}
	}

	i = 0;
	//list_for_each_entry(nf_dev, &nf_dev_list, list){
	//	if (nf_dev!=NULL){				
	ret = amlnf_ldev_register();
			if(ret < 0){
				aml_nand_msg("nand add nftl failed");
				goto exit_error0;
			}
		//}
	//}
#endif

	return 0;

exit_error0:
	return ret;	
}

#ifdef AML_NAND_UBOOT
static int get_boot_device()
{

	
	if(POR_SPI_BOOT()){
		boot_device_flag = 0; // spi boot 
		aml_nand_msg("SPI BOOT: boot_device_flag %d",boot_device_flag);
		return 0;
	}

	if(POR_NAND_BOOT()){
		boot_device_flag = 1; // nand boot
		aml_nand_msg("NAND BOOT: boot_device_flag %d",boot_device_flag);
		return 0;
	}

	if(POR_EMMC_BOOT()){
		boot_device_flag = -1;
		aml_nand_msg("EMMC BOOT: not init nand");
		return -1;
	}
	if(POR_CARD_BOOT()){
		boot_device_flag = -1;
		aml_nand_msg("CARD BOOT: not init nand");
		return -1;
	}
	
	return ;
}
struct amlnand_phydev *aml_phy_get_dev(char * name)
{
	struct amlnand_phydev * phy_dev = NULL;
	
	list_for_each_entry(phy_dev, &nphy_dev_list, list){
			if(!strncmp((char*)phy_dev->name, name, MAX_DEVICE_NAME_LEN)){
				aml_nand_dbg("nand get phy dev %s ",name);
				return phy_dev;
			}
		}
		
	aml_nand_msg("nand get phy dev %s	failed",name);
	
	return NULL;
}


struct amlnf_dev* aml_nftl_get_dev(char * name)
{
	struct amlnf_dev * nf_dev = NULL;

	list_for_each_entry(nf_dev, &nf_dev_list, list){
		if(!strncmp((char*)nf_dev->name, name, strlen(nf_dev->name))){
			aml_nand_dbg("nand get nftl dev %s ",name);
			return nf_dev;
		}
	}
	
	aml_nand_msg("nand get nftl dev %s  failed",name);
	
	return NULL;
}
#endif

#ifdef AML_NAND_UBOOT
int amlnf_init(unsigned flag)
#else
static int amlnf_init(struct platform_device *pdev)
#endif
{
	int ret = 0;
#ifndef AML_NAND_UBOOT
	unsigned flag = 0;
#endif

	
	INIT_LIST_HEAD (&nphy_dev_list);
	INIT_LIST_HEAD (&nlogic_dev_list);
	INIT_LIST_HEAD (&nf_dev_list);

	ret = get_boot_device();
	if(ret < 0){
		aml_nand_msg("do not init nand : cause boot_device_flag without nand ");
		ret = -1;
		goto exit_error0;	
	}
	
	ret = amlnf_phy_init(flag);
	if(ret < 0){
		aml_nand_msg("nandphy_init failed and ret=0x%x", ret);
		if(ret == -NAND_FAILED){
			ret = -1; // controller failed
		}else if(ret == -NAND_SHIPPED_BADBLOCK_FAILED){
			ret = NAND_SHIPPED_BADBLOCK_FAILED;
		}else{
			ret = 1;
		}
		goto exit_error0;
	}

	ret = amlnf_logic_init(flag);
	if(ret < 0){
		aml_nand_msg("amlnf_add_nftl failed and ret=0x%x", ret);
		ret = 1;
		goto exit_error0;
	}

	ret = amlnf_dev_init(flag);
	if(ret < 0){
		aml_nand_msg("amlnf_add_nftl failed and ret=0x%x", ret);
		ret = 1;
		goto exit_error0;
	}

exit_error0:
	return ret;
}

#ifdef AML_NAND_UBOOT
int amlnf_exit(unsigned flag)
#else
static int amlnf_exit(struct platform_device *pdev)
#endif
{
	amlnf_phy_exit();
	amlnf_logic_exit();
	aml_nand_msg("amlnf_exit : ok");

	return 0;
}


#ifndef AML_NAND_UBOOT
static int amlnf_shutdown(struct platform_device *pdev)
{
	return 0;
}

/* driver device registration */
static struct platform_driver amlnf_driver = {
	.probe		= amlnf_init,
	.remove		= amlnf_exit,
	.shutdown		= amlnf_shutdown,
	.driver		= {
		.name	= DRV_AMLNFDEV_NAME,
		.owner	= THIS_MODULE,
	},
};

static int __init amlnf_module_init(void)
{
	return platform_driver_register(&amlnf_driver);
}

static void __exit amlnf_module_exit(void)
{
	platform_driver_unregister(&amlnf_driver);
}

module_init(amlnf_module_init);
module_exit(amlnf_module_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("AML NAND TEAM");
MODULE_DESCRIPTION("aml nand flash driver");
#endif

