/*
 * SPI flash internal definitions
 *
 * Copyright (C) 2011 Amlogic Corporation
 *
 * Licensed under the GPL-2 or later.
 *
 *
 * Dedicated for Amlogic SPI controller use
 */


#ifndef __SPI_FLASH_AMLOGIC_H__
#define __SPI_FLASH_AMLOGIC_H__

#include <spi_flash.h>
#include <asm/arch/io.h>

#ifdef CONFIG_AMLOGIC_SPI_FLASH


/* SPI transfer flags */
//copy from @\u-boot-arm\branches\a3_bringup\include\spi.h
//should place to <inlcude\spi.h>
//but ....
#ifndef SPI_XFER_BEGIN
#define SPI_XFER_BEGIN      0x0001		/* Assert CS before transfer */
#define SPI_XFER_END        0x0002		/* Deassert CS after transfer */
#endif
#define SPI_XFER_ADR        0x0004		/* Set SPI address for read/write */
#define SPI_XFER_CMD        0x0008		/* Trigger SPI command */    
#define SPI_XFER_STATUS		  0x0010		/* Read SPI status register from device */
#define SPI_XFER_ID	    	  0x0020		/* Read SPI device ID */
#define SPI_XFER_COPY		    0x0040		/* Amlogic SPI AHB bus copy */
#define SPI_XFER_READCACHE	0x0080		/* SPI controller data operation: from cache to host */
#define SPI_XFER_WRITECACHE	0x0100		/* SPI controller data operation: from host to cache*/


int spi_flash_cmd_amlogic(struct spi_slave *spi, u32 cmd, void *response, size_t len);
int spi_flash_read_amlogic(struct spi_flash *flash,u32 offset, size_t len, void *buf);
int spi_flash_write_amlogic(struct spi_flash *flash,u32 offset, size_t len, const void *buf);
int spi_flash_erase_amlogic(struct spi_flash *flash,u32 offset, size_t len, u32 sector_size);
int spi_flash_erase_be_amlogic(struct spi_flash *flash,u32 offset, size_t len, u32 sector_size);
#endif //CONFIG_AMLOGIC_SPI_FLASH

/* Manufacturer-specific probe functions */
#ifdef CONFIG_SPI_FLASH_SPANSION
struct spi_flash *spi_flash_probe_spansion(struct spi_slave *spi, u8 *idcode);
#endif 
#ifdef CONFIG_SPI_FLASH_ATEML
struct spi_flash *spi_flash_probe_atmel(struct spi_slave *spi, u8 *idcode);
#endif 
#ifdef CONFIG_SPI_FLASH_EON
struct spi_flash *spi_flash_probe_eon(struct spi_slave *spi, u8 *idcode);
#endif
#ifdef CONFIG_SPI_FLASH_MACRONIX
struct spi_flash *spi_flash_probe_macronix(struct spi_slave *spi, u8 *idcode);
#endif 
#ifdef CONFIG_SPI_FLASH_SST 
struct spi_flash *spi_flash_probe_sst(struct spi_slave *spi, u8 *idcode);
#endif
#ifdef CONFIG_SPI_FLASH_STMICRO
struct spi_flash *spi_flash_probe_stmicro(struct spi_slave *spi, u8 *idcode);
#endif
#ifdef CONFIG_SPI_FLASH_WINBOND
struct spi_flash *spi_flash_probe_winbond(struct spi_slave *spi, u8 *idcode);
#endif
#ifdef CONFIG_SPI_FLASH_RAMTRON
struct spi_flash *spi_fram_probe_ramtron(struct spi_slave *spi, u8 *idcode);
#endif

#ifdef CONFIG_SPI_FLASH_GIGADEVICE
struct spi_flash *spi_flash_probe_gigadevice(struct spi_slave *spi, u8 *idcode);
#endif
#ifdef CONFIG_SPI_FLASH_PMDEVICE
struct spi_flash *spi_flash_probe_pmdevice(struct spi_slave *spi, u8 *idcode);
#endif

#endif //__SPI_FLASH_AMLOGIC_H__
