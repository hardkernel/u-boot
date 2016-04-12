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
#include <spi.h>
#include <spi_flash.h>
#include <asm/arch/io.h>

#define BUS_SPICC 2

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

#define P_SPI_FLASH_CMD  	(volatile unsigned int *)0xc1108c80
#define P_SPI_FLASH_ADDR 	(volatile unsigned int *)0xc1108c84
#define P_SPI_FLASH_CTRL	(volatile unsigned int *)0xc1108c88
#define P_SPI_FLASH_STATUS	(volatile unsigned int *)0xc1108c90
#define P_SPI_USER_REG 		(volatile unsigned int *)0xc1108c9c
#define P_SPI_FLASH_C0		(volatile unsigned int *)0xc1108cc0

#define P_SPI_START_ADDR 	(volatile unsigned int *)0xCC000000

#define P_PERIPHS_PIN_MUX_4		0xc88344c0
#define P_PERIPHS_PIN_MUX_5		0xc88344c4

#define SPI_FLASH_CMD                              0x2320
    #define SPI_FLASH_READ    31
    #define SPI_FLASH_WREN    30
    #define SPI_FLASH_WRDI    29
    #define SPI_FLASH_RDID    28
    #define SPI_FLASH_RDSR    27
    #define SPI_FLASH_WRSR    26
    #define SPI_FLASH_PP      25
    #define SPI_FLASH_SE      24
    #define SPI_FLASH_BE      23
    #define SPI_FLASH_CE      22
    #define SPI_FLASH_DP      21
    #define SPI_FLASH_RES     20
    #define SPI_HPM           19
    #define SPI_FLASH_USR     18
    #define SPI_FLASH_USR_ADDR 15
    #define SPI_FLASH_USR_DUMMY 14
    #define SPI_FLASH_USR_DIN   13
    #define SPI_FLASH_USR_DOUT   12
    #define SPI_FLASH_USR_DUMMY_BLEN   10
    #define SPI_FLASH_USR_CMD     0
#define SPI_FLASH_ADDR                             0x2321
    #define SPI_FLASH_BYTES_LEN 24
    #define SPI_FLASH_ADDR_START 0
#define SPI_FLASH_CTRL                             0x2322
    #define SPI_ENABLE_AHB    17
    #define SPI_SST_AAI       16
    #define SPI_RES_RID       15
    #define SPI_FREAD_DUAL    14
    #define SPI_READ_READ_EN  13
    #define SPI_CLK_DIV0      12
    #define SPI_CLKCNT_N      8
    #define SPI_CLKCNT_H      4
    #define SPI_CLKCNT_L      0
#define SPI_FLASH_CTRL1                            0x2323
#define SPI_FLASH_STATUS                           0x2324
#define SPI_FLASH_CTRL2                            0x2325
#define SPI_FLASH_CLOCK                            0x2326
#define SPI_FLASH_USER                             0x2327
#define SPI_FLASH_USER1                            0x2328
#define SPI_FLASH_USER2                            0x2329
#define SPI_FLASH_USER3                            0x232a
#define SPI_FLASH_USER4                            0x232b
#define SPI_FLASH_SLAVE                            0x232c
#define SPI_FLASH_SLAVE1                           0x232d
#define SPI_FLASH_SLAVE2                           0x232e
#define SPI_FLASH_SLAVE3                           0x232f
#define SPI_FLASH_C0                               0x2330
#define SPI_FLASH_C1                               0x2331
#define SPI_FLASH_C2                               0x2332
#define SPI_FLASH_C3                               0x2333
#define SPI_FLASH_C4                               0x2334
#define SPI_FLASH_C5                               0x2335
#define SPI_FLASH_C6                               0x2336
#define SPI_FLASH_C7                               0x2337
#define SPI_FLASH_B8                               0x2338
#define SPI_FLASH_B9                               0x2339
#define SPI_FLASH_B10                              0x233a
#define SPI_FLASH_B11                              0x233b
#define SPI_FLASH_B12                              0x233c
#define SPI_FLASH_B13                              0x233d
#define SPI_FLASH_B14                              0x233e
#define SPI_FLASH_B15                              0x233f


int spi_flash_cmd_amlogic(struct spi_slave *spi, u32 cmd, void *response, size_t len);
int spi_flash_read_amlogic(struct spi_flash *flash,u32 offset, size_t len, void *buf);
int spi_flash_write_amlogic(struct spi_flash *flash,u32 offset, size_t len, const void *buf);
int spi_flash_erase_amlogic(struct spi_flash *flash,u32 offset, size_t len, u32 sector_size);
int spi_flash_erase_be_amlogic(struct spi_flash *flash,u32 offset, size_t len, u32 sector_size);
int spi_xfer(struct spi_slave *slave, unsigned int bitlen,
			const void *dout, void *din, unsigned long flags);

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
#ifdef CONFIG_SPI_FLASH_ESMT
struct spi_flash *spi_flash_probe_esmt(struct spi_slave *spi, u8 *idcode);
#endif

#endif //__SPI_FLASH_AMLOGIC_H__
