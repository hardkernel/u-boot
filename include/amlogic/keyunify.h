#ifndef __KEY_UNIFY_H__
#define __KEY_UNIFY_H__

#ifdef CONFIG_UNIFY_KEY_MANAGE
/*
 * function name: key_unify_init
 * buf : 
 * len  : > 0
 * return : >=0: ok, other: fail
 * */
extern int key_unify_init(char *buf,unsigned int len);
/* funtion name: key_unify_write
 * keyname : key name is ascii string
 * keydata : key data buf
 * datalen : key buf len
 * return  0: ok, -0x1fe: no space, other fail
 * */
extern int key_unify_write(char *keyname,unsigned char *keydata,unsigned int datalen);
/*
 *function name: key_unify_read
 * keyname : key name is ascii string
 * keydata : key data buf
 * datalen : key buf len
 * reallen : key real len
 * return : <0 fail, >=0 ok
 * */
extern int key_unify_read(char *keyname,unsigned char *keydata,unsigned int datalen,unsigned int *reallen);
/*
*    key_unify_query - query whether key was burned.
*    @keyname : key name will be queried.
*    @keystate: query state value, 0: key was NOT burned; 1: key was burned; others: reserved.
*     keypermit: read permit: bit0~bit3
*                write permit: bit4~bit7
*     if it return failed, keypermit is invalid; kerpermit is valid,when it return successful only
*    return: >=0: successful; others: failed. 
*/
extern int key_unify_query(char *keyname,unsigned int *keystate,unsigned int *keypermit);

//get the key device from dtd
const char* key_unify_query_key_device(char *keyname);

//get the key format from dtd
const char* key_unify_query_key_format(char *keyname);

/* function name: key_unify_uninit
 * functiion : 
 * return : >=0 ok, <0 fail
 * */
extern int key_unify_uninit(void);
#else
static inline  int key_unify_init(char *buf,unsigned int len)
{
	return -EINVAL;
}
static inline  int key_unify_write(char *keyname,unsigned char *keydata,unsigned int datalen)
{
	return -EINVAL;
}
static inline  int key_unify_read(char *keyname,unsigned char *keydata,unsigned int datalen,unsigned int *reallen)
{
	return -EINVAL;
}
static inline  int key_unify_query(char *keyname,unsigned int *keystate,unsigned int *keypermit)
{
	return -EINVAL;
}
static inline  int key_unify_uninit(void)
{
	return -EINVAL;
}

//get the key device from dtd
const char* key_unify_query_key_device(char *keyname)
{
	return -EINVAL;
}

//get the key format from dtd
const char* key_unify_query_key_format(char *keyname)
{
	return -EINVAL;
}

#endif

#endif
