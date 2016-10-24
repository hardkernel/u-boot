#include <common.h>
#include <linux/types.h>
#include <asm/arch/secure_apb.h>
#include <amlogic/secure_storage.h>
#include <asm/arch/bl31_apis.h>

static uint64_t storage_share_in_base;
static uint64_t storage_share_out_base;
static uint64_t storage_share_block_base;
static uint64_t storage_share_block_size;
static uint64_t storage_init_status;

static uint64_t bl31_storage_ops(uint64_t function_id)
{
	asm volatile(
		__asmeq("%0", "x0")
		"smc    #0\n"
		: "+r" (function_id));

	return function_id;
}
uint64_t bl31_storage_ops2(uint64_t function_id, uint64_t arg1)
{
	asm volatile(
		__asmeq("%0", "x0")
		__asmeq("%1", "x1")
		"smc    #0\n"
		: "+r" (function_id)
		: "r"(arg1));

	return function_id;
}
uint64_t bl31_storage_ops3(uint64_t function_id, uint64_t arg1, uint32_t arg2)
{
	asm volatile(
		__asmeq("%0", "x0")
		__asmeq("%1", "x1")
		__asmeq("%2", "x2")
		"smc    #0\n"
		: "+r" (function_id)
		: "r"(arg1), "r"(arg2));

	return function_id;
}

static uint64_t bl31_storage_write(uint8_t *keyname, uint8_t *keybuf,
				uint32_t keylen, uint32_t keyattr)
{
	uint32_t *input = (uint32_t *)storage_share_in_base;
	uint8_t *data;
	uint32_t namelen;

	namelen = strlen((const char *)keyname);
	*input++ = namelen;
	*input++ = keylen;
	*input++ = keyattr;
	data = (uint8_t *)input;
	memcpy(data, keyname, namelen);
	data += namelen;
	memcpy(data, keybuf, keylen);
	return bl31_storage_ops(SECURITY_KEY_WRITE);
}

static uint64_t bl31_storage_read(uint8_t *keyname, uint8_t *keybuf,
				uint32_t keylen, uint32_t *readlen)
{
	uint32_t *input = (uint32_t *)storage_share_in_base;
	uint32_t *output = (uint32_t *)storage_share_out_base;
	uint32_t namelen;
	uint8_t *name, *buf;
	uint64_t ret;

	namelen = strlen((const char *)keyname);
	*input++ = namelen;
	*input++ = keylen;
	name = (uint8_t *)input;
	memcpy(name, keyname, namelen);
	ret = bl31_storage_ops(SECURITY_KEY_READ);
	if (ret == RET_OK) {
		*readlen = *output;
		buf = (uint8_t *)(output+1);
		memcpy(keybuf, buf, *readlen);
	}
	return ret;
}

static uint64_t bl31_storage_query(uint8_t *keyname, uint32_t *retval)
{
	uint32_t *input = (uint32_t *)storage_share_in_base;
	uint32_t *output = (uint32_t *)storage_share_out_base;
	uint32_t namelen;
	uint8_t *name;
	uint64_t ret;

	namelen = strlen((const char *)keyname);
	*input++ = namelen;
	name = (uint8_t *)input;
	memcpy(name, keyname, namelen);
	ret = bl31_storage_ops(SECURITY_KEY_QUERY);
	if (ret == RET_OK)
		*retval = *output;
	return ret;
}

static uint64_t bl31_storage_status(uint8_t *keyname, uint32_t *retval)
{
	uint32_t *input = (uint32_t *)storage_share_in_base;
	uint32_t *output = (uint32_t *)storage_share_out_base;
	uint32_t namelen;
	uint8_t *name;
	uint64_t ret;

	namelen = strlen((const char *)keyname);
	*input++ = namelen;
	name = (uint8_t *)input;
	memcpy(name, keyname, namelen);
	ret = bl31_storage_ops(SECURITY_KEY_STATUS);
	if (ret == RET_OK)
		*retval = *output;
	return ret;
}
static uint64_t bl31_storage_tell(uint8_t *keyname, uint32_t *retval)
{
	uint32_t *input = (uint32_t *)storage_share_in_base;
	uint32_t *output = (uint32_t *)storage_share_out_base;
	uint32_t namelen;
	uint8_t *name;
	uint64_t ret;

	namelen = strlen((const char *)keyname);
	*input++ = namelen;
	name = (uint8_t *)input;
	memcpy(name, keyname, namelen);
	ret = bl31_storage_ops(SECURITY_KEY_TELL);
	if (ret == RET_OK)
		*retval = *output;
	return ret;
}

static uint64_t bl31_storage_verify(uint8_t *keyname, uint8_t *hashbuf)
{
	uint32_t *input = (uint32_t *)storage_share_in_base;
	uint32_t *output = (uint32_t *)storage_share_out_base;
	uint32_t namelen;
	uint8_t *name;
	uint64_t ret;

	namelen = strlen((const char *)keyname);
	*input++ = namelen;
	name = (uint8_t *)input;
	memcpy(name, keyname, namelen);
	ret = bl31_storage_ops(SECURITY_KEY_VERIFY);

	if (ret == RET_OK)
		memcpy(hashbuf, (uint8_t *)output, 32);
	return ret;
}

static uint64_t bl31_storage_list(uint8_t *listbuf,
	uint32_t outlen, uint32_t *readlen)
{
	uint32_t *output = (uint32_t *)storage_share_out_base;
	uint64_t ret;

	ret = bl31_storage_ops(SECURITY_KEY_LIST);
	if (ret == RET_OK) {
		if (*output > outlen)
			*readlen = outlen;
		else
			*readlen = *output;
		memcpy(listbuf, (uint8_t *)(output+1), *readlen);
	}
	return ret;
}

static uint64_t bl31_storage_remove(uint8_t *keyname)
{
	uint32_t *input = (uint32_t *)storage_share_in_base;
	uint32_t namelen;
	uint8_t *name;

	namelen = strlen((const char *)keyname);
	*input++ = namelen;
	name = (uint8_t *)input;
	memcpy(name, keyname, namelen);
	return bl31_storage_ops(SECURITY_KEY_REMOVE);
}

static inline int32_t smc_to_ns_errno(uint64_t errno)
{
	int32_t ret = (int32_t)(errno&0xffffffff);
	return ret;
}

void secure_storage_init(void)
{
		storage_share_in_base =
				bl31_storage_ops(GET_SHARE_STORAGE_IN_BASE);
		storage_share_out_base =
				bl31_storage_ops(GET_SHARE_STORAGE_OUT_BASE);
		storage_share_block_base =
				bl31_storage_ops(GET_SHARE_STORAGE_BLOCK_BASE);
		storage_share_block_size =
				bl31_storage_ops(GET_SHARE_STORAGE_BLOCK_SIZE);
		storage_init_status = 1;
}

void *secure_storage_getbuffer(uint32_t *size)
{
	if (!storage_init_status)
		secure_storage_init();
	else
		storage_share_block_size =
			bl31_storage_ops(GET_SHARE_STORAGE_BLOCK_SIZE);
	*size = (uint32_t)storage_share_block_size;
	return (void *)storage_share_block_base;
}
void secure_storage_notifier(void)
{
	bl31_storage_ops(SECURITY_KEY_NOTIFY);
}

void secure_storage_notifier_ex(uint32_t storagesize, uint32_t rsvarg)
{
	bl31_storage_ops3(SECURITY_KEY_NOTIFY_EX, storagesize, rsvarg);
}

int32_t secure_storage_write(uint8_t *keyname, uint8_t *keybuf,
				uint32_t keylen, uint32_t keyattr)
{
	uint32_t ret;

	if (!storage_init_status)
		secure_storage_init();
	ret = bl31_storage_write(keyname, keybuf, keylen, keyattr);
	return smc_to_ns_errno(ret);
}

int32_t secure_storage_read(uint8_t *keyname, uint8_t *keybuf,
			uint32_t keylen, uint32_t *readlen)
{
	uint64_t ret;
	if (!storage_init_status)
		secure_storage_init();
	ret = bl31_storage_read(keyname, keybuf, keylen, readlen);

	return smc_to_ns_errno(ret);
}

int32_t secure_storage_query(uint8_t *keyname, uint32_t *retval)
{
	uint64_t ret;
	if (!storage_init_status)
		secure_storage_init();
	ret = bl31_storage_query(keyname, retval);

	return smc_to_ns_errno(ret);
}

int32_t secure_storage_status(uint8_t *keyname, uint32_t *retval)
{
	uint64_t ret;
	if (!storage_init_status)
		secure_storage_init();
	ret = bl31_storage_status(keyname, retval);

	return smc_to_ns_errno(ret);
}

int32_t secure_storage_tell(uint8_t *keyname, uint32_t *retval)
{
	uint64_t ret;
	if (!storage_init_status)
		secure_storage_init();
	ret = bl31_storage_tell(keyname, retval);

	return smc_to_ns_errno(ret);
}

int32_t secure_storage_verify(uint8_t *keyname, uint8_t *hashbuf)
{
	uint64_t ret;
	if (!storage_init_status)
		secure_storage_init();
	ret = bl31_storage_verify(keyname, hashbuf);

	return smc_to_ns_errno(ret);
}

int32_t secure_storage_list(uint8_t *listbuf,
		uint32_t buflen, uint32_t *readlen)
{
	uint64_t ret;
	if (!storage_init_status)
		secure_storage_init();
	ret = bl31_storage_list(listbuf, buflen, readlen);

	return smc_to_ns_errno(ret);
}

int32_t secure_storage_remove(uint8_t *keyname)
{
	uint64_t ret;
	if (!storage_init_status)
		secure_storage_init();
	ret = bl31_storage_remove(keyname);

	return smc_to_ns_errno(ret);
}

void secure_storage_set_info(uint32_t info)
{
	register uint64_t x0 asm("x0")= SET_STORAGE_INFO;
	register uint64_t x1 asm("x1") = info;
	asm volatile(
		__asmeq("%0", "x0")
		__asmeq("%1", "x1")
		"smc    #0\n"
		: :"r" (x0), "r"(x1));

}

int32_t secure_storage_set_enctype(uint32_t type)
{
	uint64_t  ret;
	ret = bl31_storage_ops2(SECURITY_KEY_SET_ENCTYPE, type);
	return smc_to_ns_errno(ret);
}

int32_t secure_storage_get_enctype(void)
{
	uint64_t ret;
	ret = bl31_storage_ops(SECURITY_KEY_GET_ENCTYPE);
	return smc_to_ns_errno(ret);
}

int32_t secure_storage_version(void)
{
	uint64_t ret;
	ret = bl31_storage_ops(SECURITY_KEY_VERSION);
	return smc_to_ns_errno(ret);
}
