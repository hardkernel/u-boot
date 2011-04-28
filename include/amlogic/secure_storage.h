#ifndef __SECURE_STORAGE__H__
#define __SECURE_STORAGE__H__

#define SECURE_STORAGE_NAND_TYPE	1
#define SECURE_STORAGE_SPI_TYPE		2
#define SECURE_STORAGE_EMMC_TYPE	3


#ifdef CONFIG_SECURE_NAND
extern int secure_storage_nand_read(char *buf,unsigned int len);
extern int secure_storage_nand_write(char *buf,unsigned int len);
#else
static inline int secure_storage_nand_read(char *buf,unsigned int len)
{
	return -1;
}
static inline int secure_storage_nand_write(char *buf,unsigned int len)
{
	return -1;
}
#endif

#ifdef CONFIG_SPI_NOR_SECURE_STORAGE
extern int secure_storage_spi_write(char *buf,unsigned int len);
extern int secure_storage_spi_read(char *buf,unsigned int len);
#else
static inline int secure_storage_spi_write(char *buf,unsigned int len)
{
	return -1;
}
static inline int secure_storage_spi_read(char *buf,unsigned int len)
{
	return -1;
}
#endif

#ifdef CONFIG_SECURE_MMC
extern int secure_storage_emmc_write(char *buf,unsigned int len);
extern int secure_storage_emmc_read(char *buf,unsigned int len);
#else
static inline int secure_storage_emmc_write(char *buf,unsigned int len)
{
	return -1;
}
static inline int secure_storage_emmc_read(char *buf,unsigned int len)
{
	return -1;
}
#endif

#ifdef CONFIG_SECURESTORAGEKEY
/* the CONFIG_SECURESTORAGEKEY is depend on CONFIG_EFUSE CONFIG_SPI_NOR_SECURE_STORAGE CONFIG_SECURE_NAND  CONFIG_RANDOM_GENERATE
 * */
/*
 * function name: securestore_key_init
 *  seed : make random
 * len  : > 0
 * return : 0: ok, other: fail
 * */
extern int securestore_key_init( char *seed,int len);
/*
 *function name: securestore_key_read
 * 
 * */
extern int securestore_key_read(char *keyname,char *keybuf,unsigned int keylen,unsigned int *reallen);
/* funtion name: securestore_key_write
 * keyname : key name is ascii string
 * keybuf : key buf
 * keylen : key buf len
 * keytype: 0: no care key type, 1: aes key, 2:rsa key 
 *          if aes/rsa key, uboot tool need decrypt 
 *
 * return  0: ok, 0x1fe: no space, other fail
 * */
extern int securestore_key_write(char *keyname, char *keybuf,unsigned int keylen,int keytype);
/*
*    securestore_key_query - query whether key was burned.
*    @keyname : key name will be queried.
*    @query_result: query return value, 0: key was NOT burned; 1: key was burned; others: reserved.
*    
*    return: 0: successful; others: failed. 
*/
extern int securestore_key_query(char *keyname, unsigned int *query_return);
/*function name: securestore_key_uninit
 *functiion : 
 * */
extern int securestore_key_uninit();
#else
static inline int securestore_key_init( char *seed,int len)
{
	return -1;
}
static inline int securestore_key_read(char *keyname,char *keybuf,unsigned int keylen,unsigned int *reallen)
{
	return -1;
}
static inline int securestore_key_write(char *keyname, char *keybuf,unsigned int keylen,int keytype)
{
	return -1;
}
static inline int securestore_key_query(char *keyname, unsigned int *query_return)
{
	return -1;
}
static inline int securestore_key_uninit()
{
	return -1;
}
#endif


#endif
