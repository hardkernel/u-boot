#ifndef _SECURITYKEY_H_
#define _SECURITYKEY_H_

#include <linux/types.h>

typedef struct aml_keybox_provider_s aml_keybox_provider_t;
struct aml_keybox_provider_s{
	char * name;
	int32_t flag;
	int32_t (* read)(aml_keybox_provider_t * provider,uint8_t * buf,int bytes,int flags);
	int32_t (* write)(aml_keybox_provider_t * provider,uint8_t * buf,int bytes);
	void * priv;
};
int32_t aml_keybox_provider_register(aml_keybox_provider_t * provider);
aml_keybox_provider_t * aml_keybox_provider_get(char * name);


#define NAND_KEY_DEVICE 	"nand_key"


#endif
