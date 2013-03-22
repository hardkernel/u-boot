/*
 * (C) Copyright 2004
 * Jian Zhang, Texas Instruments, jzhang@ti.com.

 * (C) Copyright 2000-2006
 * Wolfgang Denk, DENX Software Engineering, wd@denx.de.
 *
 * (C) Copyright 2001 Sysgo Real-Time Solutions, GmbH <www.elinos.com>
 * Andreas Heppel <aheppel@sysgo.de>

 * (C) Copyright 2011 Samsung Electronics Co. Ltd
 
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

/* #define DEBUG */

#include <common.h>

#if defined(CONFIG_ENV_IS_IN_AUTO) /* Environment is in Nand Flash */

#include <command.h>
#include <environment.h>
#include <linux/stddef.h>
#include <malloc.h>
#include <nand.h>
#include <onenand_uboot.h>
#include <mmc.h>
#include <asm/arch/cpu.h>
#include <asm/arch/movi_partition.h>

#if defined(CONFIG_CMD_ENV) || \
	defined(CONFIG_CMD_NAND) || \
	defined(CONFIG_CMD_MOVINAND) || \
	defined(CONFIG_CMD_ONENAND)
#define CMD_SAVEENV
#endif

/* info for NAND chips, defined in drivers/mtd/nand/nand.c */
extern nand_info_t nand_info[];

/* info for NOR flash chips, defined in board/samsung/common/flash_common.c */
//extern flash_info_t flash_info[];

/* references to names in env_common.c */
extern uchar default_environment[];
extern int default_environment_size;
extern unsigned int OmPin;

char * env_name_spec = "SMDK bootable device";

#ifdef ENV_IS_EMBEDDED
extern uchar environment[];
env_t *env_ptr = (env_t *)(&environment[0]);
#else /* ! ENV_IS_EMBEDDED */
env_t *env_ptr = 0;
#endif /* ENV_IS_EMBEDDED */


/* local functions */
#if !defined(ENV_IS_EMBEDDED)
static void use_default(void);
#endif

DECLARE_GLOBAL_DATA_PTR;

uchar env_get_char_spec (int index)
{
	return ( *((uchar *)(gd->env_addr + index)) );
}


/* this is called before nand_init()
 * so we can't read Nand to validate env data.
 * Mark it OK for now. env_relocate() in env_common.c
 * will call our relocate function which will does
 * the real validation.
 *
 * When using a NAND boot image (like sequoia_nand), the environment
 * can be embedded or attached to the U-Boot image in NAND flash. This way
 * the SPL loads not only the U-Boot image from NAND but also the
 * environment.
 */
int env_init(void)
{
#if defined(ENV_IS_EMBEDDED)
	ulong total;
	int crc1_ok = 0, crc2_ok = 0;
	env_t *tmp_env1, *tmp_env2;

	total = CONFIG_ENV_SIZE;

	tmp_env1 = env_ptr;
	tmp_env2 = (env_t *)((ulong)env_ptr + CONFIG_ENV_SIZE);

	crc1_ok = (crc32(0, tmp_env1->data, ENV_SIZE) == tmp_env1->crc);
	crc2_ok = (crc32(0, tmp_env2->data, ENV_SIZE) == tmp_env2->crc);

	if (!crc1_ok && !crc2_ok)
		gd->env_valid = 0;
	else if(crc1_ok && !crc2_ok)
		gd->env_valid = 1;
	else if(!crc1_ok && crc2_ok)
		gd->env_valid = 2;
	else {
		/* both ok - check serial */
		if(tmp_env1->flags == 255 && tmp_env2->flags == 0)
			gd->env_valid = 2;
		else if(tmp_env2->flags == 255 && tmp_env1->flags == 0)
			gd->env_valid = 1;
		else if(tmp_env1->flags > tmp_env2->flags)
			gd->env_valid = 1;
		else if(tmp_env2->flags > tmp_env1->flags)
			gd->env_valid = 2;
		else /* flags are equal - almost impossible */
			gd->env_valid = 1;
	}

	if (gd->env_valid == 1)
		env_ptr = tmp_env1;
	else if (gd->env_valid == 2)
		env_ptr = tmp_env2;
#else /* ENV_IS_EMBEDDED */
	gd->env_addr  = (ulong)&default_environment[0];
	gd->env_valid = 1;
#endif /* ENV_IS_EMBEDDED */

	return (0);
}

#ifdef CMD_SAVEENV

#if defined(CONFIG_CMD_NAND)
/*
 * The legacy NAND code saved the environment in the first NAND device i.e.,
 * nand_dev_desc + 0. This is also the behaviour using the new NAND code.
 */
int saveenv_nand(void)
{
        size_t total;
        int ret = 0, i;
        u32 erasebase;
        u32 eraselength;
        u32 eraseblock;
        u32 erasesize = nand_info[0].erasesize;
        uint8_t *data;

        puts("Erasing Nand...\n");

        /* If the value of CFG_ENV_OFFSET is not a NAND block boundary, the
         * NAND erase operation will fail. So first check if the CFG_ENV_OFFSET
         * is equal to a NAND block boundary
         */
        if ((CONFIG_ENV_OFFSET % (erasesize - 1)) != 0 ) {
                /* CFG_ENV_OFFSET is not equal to block boundary address. So, read
                 * the read the NAND block (in which ENV has to be stored), and
                 * copy the ENV data into the copied block data.
                 */

                /* Step 1: Find out the starting address of the NAND block to
                 * be erased. Also allocate memory whose size is equal to tbe
                 * NAND block size (NAND erasesize).
                 */
                eraseblock = CONFIG_ENV_OFFSET / erasesize;
                erasebase = eraseblock * erasesize;
                data = (uint8_t*)malloc(erasesize);
                if (data == NULL) {
                        printf("Could not save enviroment variables\n");
                        return 1;
                }

                /* Step 2: Read the NAND block into which the ENV data has
                 * to be copied
                 */
                total = erasesize;
		for (i = 0; i < CONFIG_SYS_MAX_NAND_DEVICE; i++) {
			if (nand_scan(&nand_info[i], 1) == 0) {
				ret = nand_read(&nand_info[0], erasebase, &total, data);
			} else {
				printf("no devices available\n");
				return 1;
			}
		}
                if (ret || total != erasesize) {
                        printf("Could not save enviroment variables %d\n",ret);
                        return 1;
                }

                /* Step 3: Copy the ENV data into the local copy of the block
                 * contents.
                 */
                memcpy((data + (CONFIG_ENV_OFFSET - erasebase)), (void*)env_ptr, CONFIG_ENV_SIZE);
        } else {
                /* CFG_ENV_OFFSET is equal to a NAND block boundary. So
                 * no special care is required when erasing and writing NAND
                 * block
                 */
                data = env_ptr;
                erasebase = CONFIG_ENV_OFFSET;
                erasesize = CONFIG_ENV_SIZE;
        }

        /* Erase the NAND block which will hold the ENV data */
        if (nand_erase(&nand_info[0], erasebase, erasesize))
                return 1;

        puts("Writing to Nand... \n");
        total = erasesize;

        /* Write the ENV data to the NAND block */
        ret = nand_write(&nand_info[0], erasebase, &total, (u_char*)data);
        if (ret || total != erasesize) {
                printf("Could not save enviroment variables\n");
                return 1;
        }

         if ((CONFIG_ENV_OFFSET % (erasesize - 1)) != 0 )
                free(data);

        puts("Saved enviroment variables\n");
        return ret;
}

int saveenv_nand_adv(void)
{
	size_t total;
	int ret = 0;
	
	u_char *tmp;
	total = CONFIG_ENV_OFFSET;

	tmp = (u_char *) malloc(total);
	nand_read(&nand_info[0], 0x0, &total, (u_char *) tmp);

	puts("Erasing Nand...");
	nand_erase(&nand_info[0], 0x0, CONFIG_ENV_OFFSET + CONFIG_ENV_SIZE);

	if (nand_erase(&nand_info[0], 0x0, CONFIG_ENV_OFFSET + CONFIG_ENV_SIZE)) {
		free(tmp);
		return 1;
	}

	puts("Writing to Nand... ");
	ret = nand_write(&nand_info[0], 0x0, &total, (u_char *) tmp);
	total = CONFIG_ENV_SIZE;

	ret = nand_write(&nand_info[0], CONFIG_ENV_OFFSET, &total, (u_char *) env_ptr);

	if (ret || total != CONFIG_ENV_SIZE) {
		free(tmp);
		return 1;
	}

	puts("done\n");
	free(tmp);

	return ret;
}
#endif

int saveenv_movinand(void)
{
	ssize_t	len;
	char	*res;

	res = (char *)&env_ptr->data;
	len = hexport('\0', &res, ENV_SIZE);
	if (len < 0) {
		printf("Cannot export environment");
		return 1;
	}
	env_ptr->crc   = crc32(0, env_ptr->data, ENV_SIZE);

	mmc_init(find_mmc_device(0));
        movi_write_env(virt_to_phys((ulong)env_ptr));
        puts("done\n");

	return 1;
}

#if defined (CONFIG_CMD_ONENAND)
int saveenv_onenand(void)
{

        size_t retlen;
        int ret = 0;
        u32 erasesize = onenand_mtd.erasesize;
        loff_t ofs;
        int blocksize;
        ssize_t	len;
        char *res;

        res = (char *)&env_ptr->data;
	len = hexport('\0', &res, ENV_SIZE);
	if (len < 0) {
		printf("Cannot export environment");
		return 1;
	}
	env_ptr->crc = crc32(0, env_ptr->data, ENV_SIZE);

        ofs = 0xc0000;
#if defined (CONFIG_S5PC110)
        blocksize = 0x40000;
#else
        blocksize = 0x20000;
#endif
        retlen = 0x0;
        uint8_t *ptr;

        ptr = env_ptr;

        struct erase_info instr = {
                .callback       = NULL,
        };

        instr.addr = ofs;
        instr.len = blocksize;
        instr.priv = 0;
        instr.mtd = &onenand_mtd;

        puts("Erasing Onenand...\n");
	onenand_erase(&onenand_mtd, &instr);

        puts("Writing to Onenand... \n");
	ret = onenand_write(&onenand_mtd, ofs, blocksize, &retlen, (ulong)ptr);
        if (ret || blocksize != erasesize) {
                printf("Could not save enviroment variables\n");
                return 1;
        }

        puts("Saved enviroment variables\n");
        return ret;
}
#endif

//int saveenv_nor(void)
//{
//	u32 sect_num;
//	u32 sect_size;
//	u32 pos_env;
//	u8 *tmp_buf, *tmp_pos_env;
//	ulong from, to;	/* unprotect area */
//	flash_info_t *info;
	
//	info = &flash_info[0];	/* NOR flash is located in #1 bank */

	/* find sector for saving environment variables */
//	pos_env = CFG_FLASH_BASE + CFG_ENV_ADDR + CFG_ENV_OFFSET;
//	for (sect_num = 0; sect_num < info->sector_count; sect_num++) {
//		if ((info->start[sect_num] <= pos_env) &&
//			(info->start[sect_num + 1] > pos_env)) {
//			break;
//		}
//	}

	/* unprotect finding sector */
//	from = info->start[sect_num];
//	to = info->start[sect_num + 1] - 1;
//	flash_protect(0, from, to, info); /* unprotect */

	/*
	 * read 64kb one sector from NOR flash to memory
	 * because env var is inserted into unprotected sector
	 */
//	sect_size = info->start[sect_num + 1] - info->start[sect_num];
//	tmp_buf = (u8 *)malloc(sect_size);
//	memcpy(tmp_buf, (u8 *)info->start[sect_num], sect_size);
//	tmp_pos_env = tmp_buf + pos_env - info->start[sect_num];
//	memcpy(tmp_pos_env, (u8 *)env_ptr, CFG_ENV_SIZE);
	
	/* erase unprotected sector */
//	flash_erase(info, sect_num, sect_num);

	/* write modified sector including environment variables */
//	flash_write(tmp_buf, (ulong)info->start[sect_num], sect_size);

//	free(tmp_buf);
//        printf("done\n");
	
//        return 1;
//}
int saveenv(void)
{
#if defined (CONFIG_S5P6450)
	if (INF_REG3_REG == 0)
		saveenv_movinand();
	else if (INF_REG3_REG == 1)
		saveenv_movinand();
	else
		printf("Unknown boot device\n");
#else
        if (INF_REG3_REG == 1) {
#if defined (CONFIG_CMD_ONENAND)
		saveenv_onenand();
#endif
	} else if (INF_REG3_REG == 0x40000) {
#if defined (CONFIG_CMD_NAND)
		saveenv_nand();
#endif
	} else if (INF_REG3_REG == 3)
		saveenv_movinand();
	else if (INF_REG3_REG == 6)
		saveenv_movinand();
	else if (INF_REG3_REG == 7)
		saveenv_movinand();
	else
		printf("Unknown boot device\n");
#endif /* CONFIG_S5P6450 */

        return 0;
}
#endif /* CMD_SAVEENV */

#if defined (CONFIG_CMD_NAND)
/*
 * The legacy NAND code saved the environment in the first NAND device i.e.,
 * nand_dev_desc + 0. This is also the behaviour using the new NAND code.
 */
void env_relocate_spec_nand(void)
{
#if !defined(ENV_IS_EMBEDDED)
	size_t total;
	int ret, i;
	u_char *data;

	data = (u_char*)malloc(CONFIG_ENV_SIZE);
	total = CONFIG_ENV_SIZE;
	for (i = 0; i < CONFIG_SYS_MAX_NAND_DEVICE; i++) {
		if (nand_scan(&nand_info[i], 1) == 0) {
			ret = nand_read(&nand_info[0], CONFIG_ENV_OFFSET, &total, (u_char*)data);
			env_ptr = data;
			if (ret || total != CONFIG_ENV_SIZE)
				return use_default();
			if (crc32(0, env_ptr->data, ENV_SIZE) != env_ptr->crc)
				return use_default();
		} else {
			printf("no devices available\n");
			return use_default();
		}
	}
/*	
*/
#endif /* ! ENV_IS_EMBEDDED */
}
#endif

/*
void env_relocate_spec_nor(void)
{
#if !defined(ENV_IS_EMBEDDED)
	size_t total;
	int ret, i;
	u_char *env_dst, *env_src;

	env_src = (u_char *)(CFG_FLASH_BASE + CFG_ENV_OFFSET);
	env_dst = (u_char *)malloc(CFG_ENV_SIZE);
	total = CFG_ENV_SIZE;
	
	memcpy(env_dst, env_src, total);
	env_ptr = env_dst;
	
	if (crc32(0, env_ptr->data, ENV_SIZE) != env_ptr->crc)
		return use_default();
#endif
}
*/

void env_relocate_spec_movinand(void)
{
#if !defined(ENV_IS_EMBEDDED)
	uint *magic = (uint*)(PHYS_SDRAM_1);

	movi_read_env(virt_to_phys((ulong)env_ptr));
	
	if (crc32(0, env_ptr->data, ENV_SIZE) != env_ptr->crc)
		return use_default();

	env_import((const char *)env_ptr, 1);
#endif /* ! ENV_IS_EMBEDDED */
}

#if defined (CONFIG_CMD_ONENAND)
void env_relocate_spec_onenand(void)
{
#if !defined(ENV_IS_EMBEDDED)
	size_t total;
	int ret, i;
	u_char *data;
	data = (u_char*)malloc(CONFIG_ENV_SIZE);
	total = CONFIG_ENV_SIZE;
        loff_t ofs;
        int blocksize;

        ofs = 0xc0000;
        blocksize = 0x4000;
        struct mtd_oob_ops ops = {
                .retlen         = 0,
        };
        ops.ooblen = blocksize;
        ops.len = blocksize;
        ops.datbuf = data;
        ops.retlen = 0;

	for (i = 0; i < CONFIG_SYS_MAX_ONENAND_DEVICE; i++) {
                ret = onenand_read_oob(&onenand_mtd, ofs, &ops);
                if (ret)
                        printk("Read failed 0x%x, %d\n", (u32)ofs, ret);

		env_ptr = ops.datbuf;
		if (ret || total != CONFIG_ENV_SIZE)
			return use_default();
		if (crc32(0, env_ptr->data, ENV_SIZE) != env_ptr->crc)
			return use_default();
	}

	env_import((const char *)env_ptr, 1);
#endif /* ! ENV_IS_EMBEDDED */
}
#endif

void env_relocate_spec(void)
{
	env_ptr = (env_t *)malloc (CONFIG_ENV_SIZE);
#if defined (CONFIG_S5P6450)
	if (INF_REG3_REG == 0)
		env_relocate_spec_movinand();
	else if (INF_REG3_REG == 1)
		env_relocate_spec_movinand();
	else if (INF_REG3_REG == 8)
		env_relocate_spec_movinand();
	else
		use_default();
#else

	if (INF_REG3_REG == 1) {
#if defined (CONFIG_CMD_ONENAND)
		env_relocate_spec_onenand();
#endif
        } else if (INF_REG3_REG == 0x40000) {
#if defined (CONFIG_CMD_NAND)
               env_relocate_spec_nand();
#endif
	} else if (INF_REG3_REG == 3)
		env_relocate_spec_movinand();
	else if (INF_REG3_REG == 6)
		env_relocate_spec_movinand();
	else if (INF_REG3_REG == 7)
		env_relocate_spec_movinand();
	else
		use_default();
#endif /* CONFIG_S5P6450 */
}

#if !defined(ENV_IS_EMBEDDED)
static void use_default()
{
	char boot_cmd[100];
	
	puts("*** Warning - using default environment\n\n");

	if (default_environment_size > CONFIG_ENV_SIZE) {
		puts("*** Error - default environment is too large\n\n");
		return;
	}

	memset (env_ptr, 0, sizeof(env_t));
	memcpy (env_ptr->data,
			default_environment,
			default_environment_size);
	env_ptr->crc = crc32(0, env_ptr->data, ENV_SIZE);
	gd->env_valid = 1;

	env_import((const char *)env_ptr, 1);
//	if (OmPin == BOOT_MMCSD || OmPin == BOOT_EMMC_4_4 || OmPin == BOOT_EMMC) {
//		sprintf(boot_cmd, "movi read kernel 40008000;movi read rootfs 40A00000 100000;bootm 40008000 40A00000");
//		setenv("bootcmd", boot_cmd);
//	} else if (OmPin == BOOT_ONENAND) {
//		sprintf(boot_cmd, "onenand read kernel 40008000;onenand read rootfs 40A00000;bootm 40008000 40A00000");
//		setenv("bootcmd", boot_cmd);
//	}
}
#endif

#endif /* CONFIG_ENV_IS_IN_NAND */
