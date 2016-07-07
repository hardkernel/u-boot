

#include "../include/phynand.h"
#ifndef AML_NAND_UBOOT
#include<linux/cdev.h>
#include <linux/device.h>

#define DTB_NAME	"amlnf_dtb"
static dev_t amlnf_dtb_no;
struct cdev amlnf_dtb;
struct device *dtb_dev = NULL;
struct class *amlnf_dtb_class = NULL;
#endif  /* AML_NAND_UBOOT */
int dtb_erase_blk = -1;
extern int get_partition_from_dts(unsigned char * buffer);

struct amlnand_chip *aml_chip_dtb = NULL;


int amlnf_dtb_save(u8 *buf, int len)
{
	u8 *dtb_buf = NULL;
	int ret = 0;

	aml_nand_msg("%s: ####", __func__);
	if (aml_chip_dtb == NULL) {
		aml_nand_msg("%s: amlnf not init yet!", __func__);
		return -EFAULT;
	}

	if (len > aml_chip_dtb->dtbsize) {
		aml_nand_msg("warnning!!! %s: length too much", __func__);
		len = aml_chip_dtb->dtbsize;
		/*return -EFAULT;*/
	}
	dtb_buf = aml_nand_malloc(aml_chip_dtb->dtbsize);
	if (dtb_buf == NULL) {
		aml_nand_msg("%s: malloc failed", __func__);
		ret = -1;
		goto exit_err;
	}
	memset(dtb_buf, 0, aml_chip_dtb->dtbsize);
	memcpy(dtb_buf, buf, len);

	ret = amlnand_save_info_by_name(aml_chip_dtb,
		(u8 *)&(aml_chip_dtb->amlnf_dtb),
		dtb_buf,
		(u8 *)DTD_INFO_HEAD_MAGIC,
		aml_chip_dtb->dtbsize);
	if (ret) {
		aml_nand_msg("%s: nand dtd save failed", __func__);
		ret = -EFAULT;
		goto exit_err;
	}
exit_err:
	if (dtb_buf) {
		/* kfree(dtb_buf); */
		kfree(dtb_buf);
		dtb_buf = NULL;
	}
	return ret;
}

int amlnf_dtb_erase(void)
{
	int ret = 0;
	if (aml_chip_dtb == NULL) {
		aml_nand_msg("%s amlnf not ready yet!", __func__);
		return -1;
	}
	ret = amlnand_erase_info_by_name(aml_chip_dtb,
		(u8 *)&(aml_chip_dtb->amlnf_dtb),
		(u8 *)DTD_INFO_HEAD_MAGIC);
	if (ret) {
		aml_nand_msg("dtb error,%s", __func__);
		ret = -EFAULT;
	}
	return ret;
}

int amlnf_dtb_read(u8 *buf, int len)
{
	u8 *dtb_buf = NULL;
	int ret = 0;

	aml_nand_msg("%s: ####", __func__);

	if (len > aml_chip_dtb->dtbsize) {
		aml_nand_msg("warnning!!! %s dtd length too much", __func__);
		len = aml_chip_dtb->dtbsize;
		/*return -EFAULT;*/
	}
	if (aml_chip_dtb == NULL) {
		memset(buf, 0x0, len);
		aml_nand_msg("%s amlnf not ready yet!", __func__);
		return 0;
	}

	if (aml_chip_dtb->amlnf_dtb.arg_valid == 0) {
		memset(buf, 0x0, len);
		aml_nand_msg("%s arg_valid = 0 invalid", __func__);
		return 0;
	}

	dtb_buf = aml_nand_malloc(aml_chip_dtb->dtbsize);
	if (dtb_buf == NULL) {
		aml_nand_msg("%s: malloc failed", __func__);
		ret = -1;
		goto exit_err;
	}
	memset(dtb_buf, 0, aml_chip_dtb->dtbsize);

	ret = amlnand_read_info_by_name(aml_chip_dtb,
		(u8 *)&(aml_chip_dtb->amlnf_dtb),
		(u8 *)dtb_buf,
		(u8 *)DTD_INFO_HEAD_MAGIC,
		aml_chip_dtb->dtbsize);
	if (ret) {
		aml_nand_msg("dtb error,%s", __func__);
		ret = -EFAULT;
		goto exit_err;
	}

	memcpy(buf, dtb_buf, len);
exit_err:
	if (dtb_buf) {
		/* kfree(dtb_buf); */
		kfree(dtb_buf);
		dtb_buf = NULL;
	}
	return ret;
}

/* under kernel */
#ifndef AML_NAND_UBOOT
ssize_t dtb_show(struct class *class, struct class_attribute *attr,
		char *buf)
{
	aml_nand_dbg("dtb_show : #####");
	/* fixme, read back and show in log! */
	return 0;
}

ssize_t dtb_store(struct class *class, struct class_attribute *attr,
		const char *buf, size_t count)
{
	int ret = 0;
	u8 *dtb_ptr = NULL;
	aml_nand_dbg("dtb_store : #####");

	dtb_ptr = kzalloc(aml_chip_dtb->dtbsize, GFP_KERNEL);
	if (dtb_ptr == NULL) {
		aml_nand_msg("%s: malloc buf failed ", __func__);
		return -ENOMEM;
	}
	/* fixme, why read back then write? */
	ret = amlnf_dtb_read(dtb_ptr, aml_chip_dtb->dtbsize);
	if (ret) {
		aml_nand_msg("%s: read failed", __func__);
		kfree(dtb_ptr);
		return -EFAULT;
	}

	ret = amlnf_dtb_save(dtb_ptr, aml_chip_dtb->dtbsize);
	if (ret) {
		aml_nand_msg("%s: save failed", __func__);
		kfree(dtb_ptr);
		return -EFAULT;
	}

	aml_nand_dbg("dtb_store : OK #####");
	return count;
}

static CLASS_ATTR(amlnf_dtb, S_IWUSR | S_IRUGO, dtb_show, dtb_store);

int dtb_open(struct inode *node, struct file *file)
{
	return 0;
}

ssize_t dtb_read(struct file *file,
		char __user *buf,
		size_t count,
		loff_t *ppos)
{
	u8 *dtb_ptr = NULL;
	struct nand_flash *flash = &aml_chip_dtb->flash;
	ssize_t read_size = 0;
	int ret = 0;

	if (*ppos == aml_chip_dtb->dtbsize)
		return 0;

	if (*ppos >= aml_chip_dtb->dtbsize) {
		aml_nand_msg("%s:data access out of space!", __func__);
		return -EFAULT;
	}

	dtb_ptr = vmalloc(aml_chip_dtb->dtbsize + flash->pagesize);
	if (dtb_ptr == NULL) {
		aml_nand_msg("%s: malloc buf failed ", __func__);
		return -ENOMEM;
	}

	amlnand_get_device(aml_chip_dtb, CHIP_READING);
	ret = amlnf_dtb_read((u8 *)dtb_ptr, aml_chip_dtb->dtbsize);
	if (ret) {
		aml_nand_msg("%s: read failed:%d", __func__, ret);
		ret = -EFAULT;
		goto exit;
	}

	if ((*ppos + count) > aml_chip_dtb->dtbsize)
		read_size = aml_chip_dtb->dtbsize - *ppos;
	else
		read_size = count;

	ret = copy_to_user(buf, (dtb_ptr + *ppos), read_size);
	*ppos += read_size;
exit:
	amlnand_release_device(aml_chip_dtb);
	/* kfree(dtb_ptr); */
	vfree(dtb_ptr);
	return read_size;
}

ssize_t dtb_write(struct file *file,
		const char __user *buf,
		size_t count, loff_t *ppos)
{
	u8 *dtb_ptr = NULL;
	ssize_t write_size = 0;
	struct nand_flash *flash = &aml_chip_dtb->flash;
	int ret = 0;

	if (*ppos == aml_chip_dtb->dtbsize)
		return 0;

	if (*ppos >= aml_chip_dtb->dtbsize) {
		aml_nand_msg("%s: data access out of space!", __func__);
		return -EFAULT;
	}

	dtb_ptr = vmalloc(aml_chip_dtb->dtbsize + flash->pagesize);
	if (dtb_ptr == NULL) {
		aml_nand_msg("%s: malloc buf failed ", __func__);
		return -ENOMEM;
	}
	amlnand_get_device(aml_chip_dtb, CHIP_WRITING);

	ret = amlnf_dtb_read((u8 *)dtb_ptr, aml_chip_dtb->dtbsize);
	if (ret) {
		aml_nand_msg("%s: read failed", __func__);
		ret = -EFAULT;
		goto exit;
	}

	if ((*ppos + count) > aml_chip_dtb->dtbsize)
		write_size = aml_chip_dtb->dtbsize - *ppos;
	else
		write_size = count;

	ret = copy_from_user((dtb_ptr + *ppos), buf, write_size);

	ret = amlnf_dtb_save(dtb_ptr, aml_chip_dtb->dtbsize);
	if (ret) {
		aml_nand_msg("%s: read failed", __func__);
		ret = -EFAULT;
		goto exit;
	}

	*ppos += write_size;
exit:
	amlnand_release_device(aml_chip_dtb);
	/* kfree(dtb_ptr); */
	vfree(dtb_ptr);
	return write_size;
}

long dtb_ioctl(struct file *file, u32 cmd, u32 args)
{
	return 0;
}

static const struct file_operations dtb_ops = {
	.open = dtb_open,
	.read = dtb_read,
	.write = dtb_write,
	.unlocked_ioctl = dtb_ioctl,
};
#endif /* AML_NAND_UBOOT */

int amlnf_dtb_init(struct amlnand_chip *aml_chip)
{
	int ret = 0;
	u8 *dtb_buf = NULL;
	aml_chip_dtb = aml_chip;

	dtb_buf = aml_nand_malloc(aml_chip_dtb->dtbsize);
	if (dtb_buf == NULL) {
		aml_nand_msg("nand malloc for dtb_buf failed");
		ret = -1;
		goto exit_err;
	}
	memset(dtb_buf, 0x0, aml_chip_dtb->dtbsize);
	aml_nand_msg("nand dtb: probe.");
	ret = amlnand_info_init(aml_chip,
		(u8 *)&(aml_chip->amlnf_dtb),
		dtb_buf,
		(u8 *)DTD_INFO_HEAD_MAGIC,
		aml_chip_dtb->dtbsize);
	if (ret < 0) {
		aml_nand_msg("%s failed", __func__);
		ret = -1;
		goto exit_err;
	}

#ifndef AML_NAND_UBOOT
	aml_nand_dbg("%s: register dtb cdev", __func__);
	ret = alloc_chrdev_region(&amlnf_dtb_no, 0, 1, DTB_NAME);
	if (ret < 0) {
		aml_nand_msg("%s alloc dtb dev_t number failed", __func__);
		ret = -1;
		goto exit_err;
	}

	cdev_init(&amlnf_dtb, &dtb_ops);
	amlnf_dtb.owner = THIS_MODULE;
	ret = cdev_add(&amlnf_dtb, amlnf_dtb_no, 1);
	if (ret) {
		aml_nand_msg("%s amlnf dtd dev add failed", __func__);
		ret = -1;
		goto exit_err1;
	}

	amlnf_dtb_class = class_create(THIS_MODULE, DTB_NAME);
	if (IS_ERR(amlnf_dtb_class)) {
		aml_nand_msg("%s: amlnf dtd class add failed", __func__);
		ret = -1;
		goto exit_err2;
	}

	ret = class_create_file(amlnf_dtb_class, &class_attr_env);
	if (ret) {
		aml_nand_msg("%s dev add failed", __func__);
		ret = -1;
		goto exit_err2;
	}

	dtb_dev = device_create(amlnf_dtb_class,
		NULL,
		amlnf_dtb_no,
		NULL,
		DTB_NAME);
	if (IS_ERR(dtb_dev)) {
		aml_nand_msg("%s: device_create failed", __func__);
		ret = -1;
		goto exit_err3;
	}

	aml_nand_dbg("%s: register dtd cdev OK", __func__);

	kfree(dtb_buf);
	dtb_buf = NULL;

	return ret;

exit_err3:
	class_remove_file(amlnf_dtb_class, &class_attr_env);
	class_destroy(amlnf_dtb_class);
exit_err2:
	cdev_del(&amlnf_dtb);
exit_err1:
	unregister_chrdev_region(amlnf_dtb_no, 1);

#endif /* AML_NAND_UBOOT */
exit_err:
	if (dtb_buf) {
		kfree(dtb_buf);
		dtb_buf = NULL;
	}
	return ret;
}

int amlnf_dtb_init_partitions(struct amlnand_chip *aml_chip)
{
	int ret = 0;
	u8 *dtb_buf = NULL;
	aml_chip_dtb = aml_chip;

	dtb_buf = aml_nand_malloc(aml_chip_dtb->dtbsize);
	if (dtb_buf == NULL) {
		aml_nand_msg("nand malloc for dtb_buf failed");
		ret = -1;
		goto exit_err;
	}
	memset(dtb_buf, 0x0, aml_chip_dtb->dtbsize);
	aml_nand_msg("%s: probe. ", __func__);
	ret = amlnand_info_init(aml_chip,
		(u8 *)&(aml_chip->amlnf_dtb),
		dtb_buf,
		(u8 *)DTD_INFO_HEAD_MAGIC,
		aml_chip_dtb->dtbsize);
	if (ret < 0) {
		aml_nand_msg("%s failed", __func__);
		ret = -1;
		goto exit_err;
	}

	/*parse partitions table */
	ret = get_partition_from_dts(dtb_buf);
	if (ret) {
		aml_nand_msg("%s  get_partition_from_dts failed", __func__);
	}
exit_err:
	if (dtb_buf) {
		kfree(dtb_buf);
		dtb_buf = NULL;
	}
	return ret;
}


/*****************************************************************************
 Prototype    : amlnf_detect_dtb_partitions
 Description  : if 'dtb, write the bad block, we can't erase this block.
				So we have to find the 'dtb' address in flash and flag it.
 Input        : struct amlnand_chip *aml_chip
 Output       : NULL
 Return Value :	ret
 Called By    : amlnand_get_partition_table

  History        :
  1.Date         : 2015/10/15
	Author       : Fly Mo
	Modification : Created function

*****************************************************************************/
int amlnf_detect_dtb_partitions(struct amlnand_chip *aml_chip)
{
	int ret = 0;
	u8 *dtb_buf = NULL;
	aml_chip_dtb = aml_chip;
	struct nand_arg_info test_amlnf_dtb;
	memset(&test_amlnf_dtb, 0, sizeof(test_amlnf_dtb));
	dtb_erase_blk = -1;
	dtb_buf = aml_nand_malloc(aml_chip_dtb->dtbsize);
	if (dtb_buf == NULL) {
		aml_nand_msg("nand malloc for dtb_buf failed");
		ret = -1;
		goto exit_err;
	}
	memset(dtb_buf, 0x0, aml_chip_dtb->dtbsize);
	test_amlnf_dtb.arg_type = aml_chip->amlnf_dtb.arg_type;
	ret = amlnand_info_init(aml_chip,
		(u8 *)&(test_amlnf_dtb),
		dtb_buf,
		(u8 *)DTD_INFO_HEAD_MAGIC,
		aml_chip_dtb->dtbsize);
	if (test_amlnf_dtb.arg_valid == 1) {
		dtb_erase_blk = test_amlnf_dtb.valid_blk_addr;
	}
	aml_nand_msg("%s:dtb_erase_blk:%d", __func__,dtb_erase_blk);
exit_err:
	if (dtb_buf) {
		kfree(dtb_buf);
		dtb_buf = NULL;
	}
	return ret;
}

/* for blank positions... */
int aml_nand_update_dtb(struct amlnand_chip *aml_chip, char *dtb_ptr)
{
	int ret = 0;
	char malloc_flag = 0;
	char *dtb_buf = NULL;

	if (dtb_buf == NULL) {
		dtb_buf = kzalloc(aml_chip_dtb->dtbsize, GFP_KERNEL);
		malloc_flag = 1;
		if (dtb_buf == NULL)
			return -ENOMEM;
		memset(dtb_buf, 0, aml_chip_dtb->dtbsize);
		ret = amlnand_read_info_by_name(aml_chip,
			(u8 *)&(aml_chip->amlnf_dtb),
			(u8 *)dtb_buf,
			(u8 *)DTD_INFO_HEAD_MAGIC,
			aml_chip_dtb->dtbsize);
		if (ret) {
			aml_nand_msg("read dtb error,%s\n", __func__);
			ret = -EFAULT;
			goto exit;
		}
	} else
		dtb_buf = dtb_ptr;

	ret = amlnand_save_info_by_name(aml_chip,
		(u8 *)&(aml_chip->amlnf_dtb),
		(u8 *)dtb_buf,
		(u8 *)DTD_INFO_HEAD_MAGIC,
		aml_chip_dtb->dtbsize);
	if (ret < 0)
		aml_nand_msg("%s: update failed", __func__);
exit:
	if (malloc_flag && (dtb_buf)) {
		kfree(dtb_buf);
		dtb_buf = NULL;
	}
	return 0;
}


