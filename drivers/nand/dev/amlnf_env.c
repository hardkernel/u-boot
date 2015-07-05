
#include "../include/phynand.h"
#ifndef AML_NAND_UBOOT
#include<linux/cdev.h>
#include <linux/device.h>

#define CONFIG_ENV_SIZE  \
	((get_cpu_type() >= MESON_CPU_MAJOR_ID_M8) ? (64*1024U) : (0x8000U))


#define ENV_NAME	"nand_env"
static dev_t uboot_env_no;
struct cdev uboot_env;
struct device *uboot_dev = NULL;
struct class *uboot_env_class = NULL;
#endif  /* AML_NAND_UBOOT */

struct amlnand_chip *aml_chip_env = NULL;


int amlnf_env_save(u8 *buf, int len)
{
	u8 *env_buf = NULL;
	//struct nand_flash *flash = &aml_chip_env->flash;
	int ret = 0;

	aml_nand_msg("uboot env amlnf_env_save : ####");
	if (aml_chip_env == NULL) {
		aml_nand_msg("uboot env not init yet!,%s", __func__);
		return -EFAULT;
	}

	if (len > CONFIG_ENV_SIZE) {
		aml_nand_msg("uboot env data len too much,%s", __func__);
		return -EFAULT;
	}
	env_buf = aml_nand_malloc(CONFIG_ENV_SIZE);
	if (env_buf == NULL) {
		aml_nand_msg("nand malloc for uboot env failed");
		ret = -1;
		goto exit_err;
	}
	memset(env_buf, 0, CONFIG_ENV_SIZE);
	memcpy(env_buf, buf, len);

	ret = amlnand_save_info_by_name(aml_chip_env,
		(u8 *)&(aml_chip_env->uboot_env),
		env_buf,
		(u8 *)ENV_INFO_HEAD_MAGIC,
		CONFIG_ENV_SIZE);
	if (ret) {
		aml_nand_msg("nand uboot env error,%s", __func__);
		ret = -EFAULT;
		goto exit_err;
	}
exit_err:
	if (env_buf) {
		/* kfree(env_buf); */
		kfree(env_buf);
		env_buf = NULL;
	}
	return ret;
}


int amlnf_env_read(u8 *buf, int len)
{
	u8 *env_buf = NULL;
	int ret = 0;
	//struct nand_flash *flash = &aml_chip_env->flash;

	aml_nand_msg("uboot env amlnf_env_read : ####");

	if (len > CONFIG_ENV_SIZE) {
		aml_nand_msg("uboot env data len too much,%s", __func__);
		return -EFAULT;
	}
	if (aml_chip_env == NULL) {
		memset(buf, 0x0, len);
		aml_nand_msg("uboot env arg_valid = 0 invalid,%s", __func__);
		return 0;
	}

	if (aml_chip_env->uboot_env.arg_valid == 0) {
		memset(buf, 0x0, len);
		aml_nand_msg("uboot env arg_valid = 0 invalid,%s", __func__);
		return 0;
	}

	env_buf = aml_nand_malloc(CONFIG_ENV_SIZE);
	if (env_buf == NULL) {
		aml_nand_msg("nand malloc for uboot env failed");
		ret = -1;
		goto exit_err;
	}
	memset(env_buf, 0, CONFIG_ENV_SIZE);

	ret = amlnand_read_info_by_name(aml_chip_env,
		(u8 *)&(aml_chip_env->uboot_env),
		(u8 *)env_buf,
		(u8 *)ENV_INFO_HEAD_MAGIC,
		CONFIG_ENV_SIZE);
	if (ret) {
		aml_nand_msg("nand uboot env error,%s", __func__);
		ret = -EFAULT;
		goto exit_err;
	}

	memcpy(buf, env_buf, len);
exit_err:
	if (env_buf) {
		/* kfree(env_buf); */
		kfree(env_buf);
		env_buf = NULL;
	}
	return ret;
}
#ifndef AML_NAND_UBOOT
ssize_t env_show(struct class *class, struct class_attribute *attr,
		char *buf)
{
	aml_nand_dbg("env_show : #####");

	return 0;
}

ssize_t env_store(struct class *class, struct class_attribute *attr,
		const char *buf, size_t count)
{
	int ret = 0;
	u8 *env_ptr = NULL;
	aml_nand_dbg("env_store : #####");

	env_ptr = kzalloc(CONFIG_ENV_SIZE, GFP_KERNEL);
	if (env_ptr == NULL) {
		aml_nand_msg("nand_env_read: nand env malloc buf failed ");
		return -ENOMEM;
	}

	ret = amlnf_env_read(env_ptr, CONFIG_ENV_SIZE);
	if (ret) {
		aml_nand_msg("nand_env_read: nand env read failed");
		kfree(env_ptr);
		return -EFAULT;
	}

	ret = amlnf_env_save(env_ptr, CONFIG_ENV_SIZE);
	if (ret) {
		aml_nand_msg("nand_env_read: nand env read failed");
		kfree(env_ptr);
		return -EFAULT;
	}

	aml_nand_dbg("env_store : OK #####");
	return count;
}

static CLASS_ATTR(env, S_IWUSR | S_IRUGO, env_show, env_store);

int uboot_env_open(struct inode *node, struct file *file)
{
	return 0;
}

ssize_t uboot_env_read(struct file *file,
		char __user *buf,
		size_t count,
		loff_t *ppos)
{
	u8 *env_ptr = NULL;
	struct nand_flash *flash = &aml_chip_env->flash;
	ssize_t read_size = 0;
	int ret = 0;

	if (*ppos == CONFIG_ENV_SIZE)
		return 0;

	if (*ppos >= CONFIG_ENV_SIZE) {
		aml_nand_msg("nand env: data access out of space!");
		return -EFAULT;
	}

	/* env_ptr = kzalloc(CONFIG_ENV_SIZE, GFP_KERNEL); */
	env_ptr = vmalloc(CONFIG_ENV_SIZE + flash->pagesize);
	if (env_ptr == NULL) {
		aml_nand_msg("nand_env_read: nand env malloc buf failed ");
		return -ENOMEM;
	}

	amlnand_get_device(aml_chip_env, CHIP_READING);
	ret = amlnf_env_read((u8 *)env_ptr, CONFIG_ENV_SIZE);
	if (ret) {
		aml_nand_msg("nand_env_read: nand env read failed:%d", ret);
		ret = -EFAULT;
		goto exit;
	}

	if ((*ppos + count) > CONFIG_ENV_SIZE)
		read_size = CONFIG_ENV_SIZE - *ppos;
	else
		read_size = count;

	ret = copy_to_user(buf, (env_ptr + *ppos), read_size);
	*ppos += read_size;
exit:
	amlnand_release_device(aml_chip_env);
	/* kfree(env_ptr); */
	vfree(env_ptr);
	return read_size;
}

ssize_t uboot_env_write(struct file *file,
		const char __user *buf,
		size_t count, loff_t *ppos)
{
	u8 *env_ptr = NULL;
	ssize_t write_size = 0;
	struct nand_flash *flash = &aml_chip_env->flash;
	int ret = 0;

	if (*ppos == CONFIG_ENV_SIZE)
		return 0;

	if (*ppos >= CONFIG_ENV_SIZE) {
		aml_nand_msg("nand env: data access out of space!");
		return -EFAULT;
	}

	/* env_ptr = kzalloc(CONFIG_ENV_SIZE, GFP_KERNEL); */
	env_ptr = vmalloc(CONFIG_ENV_SIZE + flash->pagesize);
	if (env_ptr == NULL) {
		aml_nand_msg("nand_env_read: nand env malloc buf failed ");
		return -ENOMEM;
	}
	amlnand_get_device(aml_chip_env, CHIP_WRITING);

	ret = amlnf_env_read((u8 *)env_ptr, CONFIG_ENV_SIZE);
	if (ret) {
		aml_nand_msg("nand_env_read: nand env read failed");
		ret = -EFAULT;
		goto exit;
	}

	if ((*ppos + count) > CONFIG_ENV_SIZE)
		write_size = CONFIG_ENV_SIZE - *ppos;
	else
		write_size = count;

	ret = copy_from_user((env_ptr + *ppos), buf, write_size);

	ret = amlnf_env_save(env_ptr, CONFIG_ENV_SIZE);
	if (ret) {
		aml_nand_msg("nand_env_read: nand env read failed");
		ret = -EFAULT;
		goto exit;
	}

	*ppos += write_size;
exit:
	amlnand_release_device(aml_chip_env);
	/* kfree(env_ptr); */
	vfree(env_ptr);
	return write_size;
}

long uboot_env_ioctl(struct file *file, u32 cmd, u32 args)
{
	return 0;
}

static const struct file_operations uboot_env_ops = {
	.open = uboot_env_open,
	.read = uboot_env_read,
	.write = uboot_env_write,
	.unlocked_ioctl = uboot_env_ioctl,
};
#endif /* AML_NAND_UBOOT */
int aml_ubootenv_init(struct amlnand_chip *aml_chip)
{
	int ret = 0;
	u8 *env_buf = NULL;
	aml_chip_env = aml_chip;

	env_buf = aml_nand_malloc(CONFIG_ENV_SIZE);
	if (env_buf == NULL) {
		aml_nand_msg("nand malloc for secure_ptr failed");
		ret = -1;
		goto exit_err;
	}
	memset(env_buf, 0x0, CONFIG_ENV_SIZE);

	ret = amlnand_info_init(aml_chip,
		(u8 *)&(aml_chip->uboot_env),
		env_buf,
		(u8 *)ENV_INFO_HEAD_MAGIC,
		CONFIG_ENV_SIZE);
	if (ret < 0) {
		aml_nand_msg("%s failed\n", __func__);
		ret = -1;
		goto exit_err;
	}

	/*if(aml_chip->uboot_env.arg_valid == 0){
		memset(env_buf,0x0,CONFIG_ENV_SIZE);
		ret = amlnf_env_save(env_buf,CONFIG_ENV_SIZE);
		if (ret) {
			aml_nand_msg("amlnf_env_save: save env failed");
		}
	}*/
#ifndef AML_NAND_UBOOT
	aml_nand_dbg("%s: register env chardev", __func__);
	ret = alloc_chrdev_region(&uboot_env_no, 0, 1, ENV_NAME);
	if (ret < 0) {
		aml_nand_msg("alloc uboot env dev_t no failed");
		ret = -1;
		goto exit_err;
	}

	cdev_init(&uboot_env, &uboot_env_ops);
	uboot_env.owner = THIS_MODULE;
	ret = cdev_add(&uboot_env, uboot_env_no, 1);
	if (ret) {
		aml_nand_msg("uboot env dev add failed");
		ret = -1;
		goto exit_err1;
	}

	uboot_env_class = class_create(THIS_MODULE, ENV_NAME);
	if (IS_ERR(uboot_env_class)) {
		aml_nand_msg("uboot env dev add failed");
		ret = -1;
		goto exit_err2;
	}

	ret = class_create_file(uboot_env_class, &class_attr_env);
	if (ret) {
		aml_nand_msg("uboot env dev add failed");
		ret = -1;
		goto exit_err2;
	}

	uboot_dev = device_create(uboot_env_class,
		NULL,
		uboot_env_no,
		NULL,
		ENV_NAME);
	if (IS_ERR(uboot_dev)) {
		aml_nand_msg("uboot env dev add failed");
		ret = -1;
		goto exit_err3;
	}

	aml_nand_dbg("%s: register env chardev OK", __func__);

	kfree(env_buf);
	env_buf = NULL;

	return ret;

exit_err3:
	class_remove_file(uboot_env_class, &class_attr_env);
	class_destroy(uboot_env_class);
exit_err2:
	cdev_del(&uboot_env);
exit_err1:
	unregister_chrdev_region(uboot_env_no, 1);

#endif /* AML_NAND_UBOOT */
exit_err:
	if (env_buf) {
		kfree(env_buf);
		env_buf = NULL;
	}
	return ret;
}
/* update env if only it is still readable! */
int aml_nand_update_ubootenv(struct amlnand_chip *aml_chip, char *env_ptr)
{
	int ret = 0;
	char malloc_flag = 0;
	char *env_buf = NULL;

	if (env_buf == NULL) {
		env_buf = kzalloc(CONFIG_ENV_SIZE, GFP_KERNEL);
		malloc_flag = 1;
		if (env_buf == NULL)
			return -ENOMEM;
		memset(env_buf, 0, CONFIG_ENV_SIZE);
		ret = amlnand_read_info_by_name(aml_chip,
			(u8 *)&(aml_chip->uboot_env),
			(u8 *)env_buf,
			(u8 *)ENV_INFO_HEAD_MAGIC,
			CONFIG_ENV_SIZE);
		if (ret) {
			aml_nand_msg("read ubootenv error,%s\n", __func__);
			ret = -EFAULT;
			goto exit;
		}
	} else
		env_buf = env_ptr;

	ret = amlnand_save_info_by_name(aml_chip,
		(u8 *)&(aml_chip->uboot_env),
		(u8 *)env_buf,
		(u8 *)ENV_INFO_HEAD_MAGIC,
		CONFIG_ENV_SIZE);
	if (ret < 0)
		aml_nand_msg("aml_nand_update_secure : update secure failed");
exit:
	if (malloc_flag && (env_buf)) {
		kfree(env_buf);
		env_buf = NULL;
	}
	return 0;
}


