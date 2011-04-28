/*
 * (C) Copyright 2000-2010
 * Wolfgang Denk, DENX Software Engineering, wd@denx.de.
 *
 * (C) Copyright 2001 Sysgo Real-Time Solutions, GmbH <www.elinos.com>
 * Andreas Heppel <aheppel@sysgo.de>
 *
 * (C) Copyright 2008 Atmel Corporation
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */
#include <common.h>
#include <environment.h>
#include <malloc.h>
#include <spi_flash.h>
#include <search.h>
#include <errno.h>

#ifndef CONFIG_ENV_SPI_BUS
# define CONFIG_ENV_SPI_BUS	0
#endif
#ifndef CONFIG_ENV_SPI_CS
# define CONFIG_ENV_SPI_CS		0
#endif
#ifndef CONFIG_ENV_SPI_MAX_HZ
# define CONFIG_ENV_SPI_MAX_HZ	1000000
#endif
#ifndef CONFIG_ENV_SPI_MODE
# define CONFIG_ENV_SPI_MODE	SPI_MODE_3
#endif

DECLARE_GLOBAL_DATA_PTR;
extern env_t *env_ptr;
extern uchar default_environment[];

#if defined CONFIG_SPI_NAND_COMPATIBLE || defined CONFIG_SPI_NAND_EMMC_COMPATIBLE || defined CONFIG_STORE_COMPATIBLE

#else
/* references to names in env_common.c */
extern uchar default_environment[];

#ifdef ENV_IS_EMBEDDED
extern uchar environment[];
env_t *env_ptr = (env_t *)(&environment[0]);
#else /* ! ENV_IS_EMBEDDED */
env_t *env_ptr = 0;
#endif /* ENV_IS_EMBEDDED */

char * env_name_spec = "SPI Flash";
#endif

static struct spi_flash *env_flash;

#if defined CONFIG_SPI_NAND_COMPATIBLE || defined CONFIG_SPI_NAND_EMMC_COMPATIBLE || defined CONFIG_STORE_COMPATIBLE

#else
uchar env_get_char_spec(int index)
{
	return *((uchar *)(gd->env_addr + index));
}
#endif

#if defined CONFIG_SPI_NAND_COMPATIBLE || defined CONFIG_SPI_NAND_EMMC_COMPATIBLE || defined CONFIG_STORE_COMPATIBLE
int spi_env_init(void)
#else
int env_init(void)
#endif
{
	/* SPI flash isn't usable before relocation */
	gd->env_addr = (ulong)&default_environment[0];
	gd->env_valid = 1;

	return 0;
}

#if defined CONFIG_SPI_NAND_COMPATIBLE || defined CONFIG_SPI_NAND_EMMC_COMPATIBLE || defined CONFIG_STORE_COMPATIBLE
void spi_env_relocate_spec(void)
{
	int ret;
    env_t env_buf;
    
	env_flash = spi_flash_probe(CONFIG_ENV_SPI_BUS, CONFIG_ENV_SPI_CS,
			CONFIG_ENV_SPI_MAX_HZ, CONFIG_ENV_SPI_MODE);
	if (!env_flash)
		goto err_probe;

	ret = spi_flash_read(env_flash, CONFIG_ENV_IN_SPI_OFFSET, CONFIG_ENV_SIZE, &env_buf);
	if (ret)
		goto err_read;

		env_import(&env_buf, 1);
		gd->env_valid = 1;

		return;

err_read:
	spi_flash_free(env_flash);
	env_flash = NULL;
err_probe:
//err_crc:
	set_default_env("!bad CRC");
}
#else
void env_relocate_spec(void)
{
	int ret;
    env_t env_buf;
    
	env_flash = spi_flash_probe(CONFIG_ENV_SPI_BUS, CONFIG_ENV_SPI_CS,
			CONFIG_ENV_SPI_MAX_HZ, CONFIG_ENV_SPI_MODE);
	if (!env_flash)
		goto err_probe;

	ret = spi_flash_read(env_flash, CONFIG_ENV_OFFSET, CONFIG_ENV_SIZE, &env_buf);
	if (ret)
		goto err_read;

		env_import((const char *)&env_buf, 1);
		gd->env_valid = 1;

		return;

err_read:
	spi_flash_free(env_flash);
	env_flash = NULL;
err_probe:
//err_crc:
	set_default_env("!bad CRC");
}
#endif

#if defined CONFIG_SPI_NAND_COMPATIBLE || defined CONFIG_SPI_NAND_EMMC_COMPATIBLE || defined CONFIG_STORE_COMPATIBLE
int spi_saveenv(void)
{
	u32 saved_size, saved_offset;
	char *saved_buffer = NULL;
	u32 sector = 1;
	int ret;
	env_t *env_ptr = NULL;
	ssize_t	len;	
    	char	*res;

	if (!env_flash) {
        puts("Environment SPI flash not initialized, to probe\n");
        env_flash = spi_flash_probe(CONFIG_ENV_SPI_BUS, CONFIG_ENV_SPI_CS,
                CONFIG_ENV_SPI_MAX_HZ, CONFIG_ENV_SPI_MODE);
        if (!env_flash){
            puts("Fail in spi_flash_probe when save\n");
            return 1;
        }
	}

	/* Is the sector larger than the env (i.e. embedded) */
	if (CONFIG_ENV_SECT_SIZE > CONFIG_ENV_SIZE) {
		saved_size = CONFIG_ENV_SECT_SIZE - CONFIG_ENV_SIZE;
		saved_offset = CONFIG_ENV_IN_SPI_OFFSET + CONFIG_ENV_SIZE;
		saved_buffer = malloc(saved_size);
		if (!saved_buffer) {
			ret = 1;
			goto done;
		}
		ret = spi_flash_read(env_flash, saved_offset, saved_size, saved_buffer);
		if (ret)
			goto done;
	}
	
	if (CONFIG_ENV_SIZE >= CONFIG_ENV_SECT_SIZE) {
		sector = CONFIG_ENV_SIZE / CONFIG_ENV_SECT_SIZE;
		if (CONFIG_ENV_SIZE % CONFIG_ENV_SECT_SIZE)
			sector++;
	}
	env_ptr = (env_t *)malloc (CONFIG_ENV_SIZE);			
	// get env data from hash table	
	memset(env_ptr->data, 0, ENV_SIZE);
	res = (char *)&(env_ptr->data);
	len = hexport_r(&env_htab, '\0', &res, ENV_SIZE);
	if (len < 0) {
		error("Cannot export environment: errno = %d\n", errno);		
		ret=1;
		goto done;		
	}
	env_ptr->crc   = crc32(0, env_ptr->data, ENV_SIZE);			
	

	puts("Erasing SPI flash...");
	ret = spi_flash_erase(env_flash, CONFIG_ENV_IN_SPI_OFFSET, sector * CONFIG_ENV_SECT_SIZE);
	if (ret)
		goto done;

	puts("Writing to SPI flash...");
	ret = spi_flash_write(env_flash, CONFIG_ENV_IN_SPI_OFFSET, CONFIG_ENV_SIZE, env_ptr);
	if (ret)
		goto done;

	if (CONFIG_ENV_SECT_SIZE > CONFIG_ENV_SIZE) {
		udelay(2000);
		ret = spi_flash_write(env_flash, saved_offset, saved_size, saved_buffer);
		if (ret)
			goto done;
	}

	ret = 0;
	puts("done\n");

 done:
	if (saved_buffer)
		free(saved_buffer);
	if(env_ptr)
		free(env_ptr);		
	return ret;
}

#else
int saveenv(void)
{
	u32 saved_size, saved_offset;
	char *saved_buffer = NULL;
	u32 sector = 1;
	int ret;
	env_t *env_ptr = NULL;
	ssize_t	len;	
    char	*res;

	if (!env_flash) {
		puts("Environment SPI flash not initialized\n");
		return 1;
	}

	/* Is the sector larger than the env (i.e. embedded) */
	if (CONFIG_ENV_SECT_SIZE > CONFIG_ENV_SIZE) {
		saved_size = CONFIG_ENV_SECT_SIZE - CONFIG_ENV_SIZE;
		saved_offset = CONFIG_ENV_OFFSET + CONFIG_ENV_SIZE;
		saved_buffer = malloc(saved_size);
		if (!saved_buffer) {
			ret = 1;
			goto done;
		}
		ret = spi_flash_read(env_flash, saved_offset, saved_size, saved_buffer);
		if (ret)
			goto done;
	}
	
	if (CONFIG_ENV_SIZE >= CONFIG_ENV_SECT_SIZE) {
		sector = CONFIG_ENV_SIZE / CONFIG_ENV_SECT_SIZE;
		if (CONFIG_ENV_SIZE % CONFIG_ENV_SECT_SIZE)
			sector++;
	
	}
	env_ptr = (env_t *)malloc (CONFIG_ENV_SIZE);			
	// get env data from hash table	
	memset(env_ptr->data, 0, ENV_SIZE);
	res = (char *)&(env_ptr->data);
	len = hexport_r(&env_htab, '\0', &res, ENV_SIZE);
	if (len < 0) {
		error("Cannot export environment: errno = %d\n", errno);		
		ret=1;
		goto done;		
	}
	env_ptr->crc   = crc32(0, env_ptr->data, ENV_SIZE);			

	puts("Erasing SPI flash...");
	ret = spi_flash_erase(env_flash, CONFIG_ENV_OFFSET, sector * CONFIG_ENV_SECT_SIZE);
	if (ret)
		goto done;

	puts("Writing to SPI flash...");
	ret = spi_flash_write(env_flash, CONFIG_ENV_OFFSET, CONFIG_ENV_SIZE, env_ptr);
	if (ret)
		goto done;

	if (CONFIG_ENV_SECT_SIZE > CONFIG_ENV_SIZE) {
		udelay(2000);
                ret = spi_flash_write(env_flash, saved_offset, saved_size, saved_buffer);
		if (ret)
			goto done;
	}

	ret = 0;
	puts("done\n");

 done:
	if (saved_buffer)
		free(saved_buffer);
	if(env_ptr)
		free(env_ptr);		
	return ret;
}
#endif
