/*
 * \file        storage_if.h
 * \brief       interfaces declarations for storage operations
 *
 * \version     1.0.0
 * \date        2013-7-16
 * \author      Sam.Wu <yihui.wu@amlgic.com>
 *
 * Copyright (c) 2013 Amlogic. All Rights Reserved.
 *
 */
#ifndef __STOARGE_IF_H__
#define __STOARGE_IF_H__ 


/***
upgrade_read_ops:

partition_name: env / logo / recovery /boot / system /cache /media

***/
int store_read_ops(unsigned char *partition_name,unsigned char * buf, uint64_t off, uint64_t size);


/***
upgrade_write_ops:

partition_name: env / logo / recovery /boot / system /cache /media

***/
int store_write_ops(unsigned char *partition_name,unsigned char * buf,uint64_t off, uint64_t size);


/***
upgrade_write_ops:

partition_name: env / logo / recovery /boot / system /cache /media

***/
int store_get_partititon_size(unsigned char *partition_name, uint64_t *size);


/***
upgrade_erase_ops:

partition_name: boot / data

flag = 0; indicate erase partition ;
flag = 1; indicate scurb whole nand;

***/
int store_erase_ops(unsigned char *par_name, uint64_t off, uint64_t size, unsigned char flag);

/***
bootloader:
***/
int store_boot_read(unsigned char * buf, uint64_t off, uint64_t size);

int store_boot_write(unsigned char * buf,uint64_t off, uint64_t size);

int store_init(unsigned  flag);

int store_exit(void);

#endif//ifndef __STOARGE_IF_H__

