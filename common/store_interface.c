#include <config.h>
#include <common.h>
#include <command.h>
#include <watchdog.h>
#include <malloc.h>
#if defined(CONFIG_AML_NAND) || defined (CONFIG_AML_MTD)
#include <nand.h>
#endif
#include <mmc.h>
#include <linux/ctype.h>
#include <asm/byteorder.h>
#include <div64.h>
#include <linux/err.h>
#include<partition_table.h>
#include<emmc_partitions.h>
#include <libfdt.h>
#include <linux/string.h>
#include <asm/cpu_id.h>
#include <asm/arch/bl31_apis.h>
#include <asm/arch/cpu_config.h>

#if defined(CONFIG_AML_NAND) || defined (CONFIG_AML_MTD)
extern int amlnf_init(unsigned flag);
extern void nand_init(void);
extern int amlnf_key_write(u8 *buf, int len, uint32_t *actual_lenth);
extern int amlnf_key_read(u8 * buf, int len, uint32_t *actual_lenth);
extern int amlnf_ddr_parameter_read(u8 *buf, int len);
extern int amlnf_ddr_parameter_write(u8 *buf, int len);
extern int amlnf_ddr_parameter_erase(void);
#endif

#if defined(CONFIG_DISCRETE_BOOTLOADER)
#ifndef CONFIG_TPL_VAL_NUM_MIN
#define CONFIG_TPL_VAL_NUM_MIN  (CONFIG_TPL_COPY_NUM/2)
#endif// #ifndef CONFIG_TPL_VAL_NUM_MIN
#ifndef CONFIG_BL2_VAL_NUM_MIN
#define CONFIG_BL2_VAL_NUM_MIN  (CONFIG_BL2_COPY_NUM/2)
#endif// #ifndef CONFIG_BL2_VAL_NUM_MIN
static uint32_t _bootloaderOrgCrc[2];  //0 for bl2, 1 for tpl
#endif// #if defined(CONFIG_DISCRETE_BOOTLOADER)

extern int get_partition_from_dts(unsigned char * buffer);

/* key opeartions of emmc */
extern int mmc_key_read(unsigned char *buf,
		unsigned int size, uint32_t *actual_lenth);
extern int mmc_key_write(unsigned char *buf,
		unsigned int size, uint32_t *actual_lenth);
extern int mmc_key_erase(void);
extern int find_dev_num_by_partition_name (char *name);
extern unsigned emmc_cur_partition;

extern int mmc_ddr_parameter_read(unsigned char *buf, unsigned int size);
extern int mmc_ddr_parameter_write(unsigned char *buf, unsigned int size);
extern int mmc_ddr_parameter_erase(void);

#define debugP(fmt...) //printf("Dbg[store]L%d:", __LINE__),printf(fmt)
#define MsgP(fmt...)   printf("[store]"fmt)
#define ErrP(fmt...)   printf("[store]Err:%s,L%d:", __func__, __LINE__),printf(fmt)

#define NAND_INIT_FAILED 20
#define STORE_BOOT_NORMAL				0
#define STORE_BOOT_UPGRATE				1
#define STORE_BOOT_ERASE_PROTECT_CACHE	2
#define STORE_BOOT_ERASE_ALL			3
#define STORE_BOOT_SCRUB_ALL			4

#define _SPI_FLASH_ERASE_SZ      (CONFIG_ENV_IN_SPI_OFFSET + CONFIG_ENV_SIZE)
#define CONFIG_ENV_IN_SPI_OFFSET 0
//Ignore mbr since mmc driver already handled
//#define MMC_UBOOT_CLEAR_MBR
#define MMC_BOOT_PARTITION_SUPPORT

#ifdef MMC_UBOOT_CLEAR_MBR
static char _mbrFlag[4] ;
#endif

#ifdef CONFIG_AML_MTD
static int mtd_find_phy_off_by_lgc_off(const char* partName, const loff_t logicAddr, loff_t* phyAddr)
{
	nand_info_t * mtdPartInf = NULL;
	loff_t off = 0;
	static struct {
		loff_t lastblkPhyOff;
		loff_t lastblkLgcOff;
		char   partName[64];
	}_map4SpeedUp = {0};
	int canSpeedUp = 0;

	if (!(NAND_BOOT_FLAG == device_boot_flag || SPI_NAND_FLAG == device_boot_flag)) {
		return 0;
	}

	mtdPartInf = get_mtd_device_nm(partName);
	if (IS_ERR(mtdPartInf)) {
		ErrP("device(%s) is err\n", partName);
		return CMD_RET_FAILURE;
	}
	const unsigned eraseSz = mtdPartInf->erasesize;
	const unsigned offsetInBlk = logicAddr & (eraseSz - 1);

	if ( !strcmp(partName, _map4SpeedUp.partName) && logicAddr >= _map4SpeedUp.lastblkLgcOff) {
		canSpeedUp = 1;
	} else {
		_map4SpeedUp.lastblkLgcOff = _map4SpeedUp.lastblkPhyOff = 0;
		strncpy(_map4SpeedUp.partName, partName, 63);
	}

	if ( canSpeedUp ) {
		if ( logicAddr >= _map4SpeedUp.lastblkLgcOff &&
				logicAddr < _map4SpeedUp.lastblkLgcOff + eraseSz) {
			*phyAddr = _map4SpeedUp.lastblkPhyOff + offsetInBlk;
			return 0;
		}
		_map4SpeedUp.lastblkPhyOff += eraseSz;
		_map4SpeedUp.lastblkLgcOff += eraseSz;
		off = _map4SpeedUp.lastblkPhyOff;
	}
	for (; off < mtdPartInf->size; off += eraseSz, _map4SpeedUp.lastblkPhyOff += eraseSz) {
		if (nand_block_isbad(mtdPartInf, off)) {
			MsgP("  %08llx\n", (unsigned long long)off);
		} else {
			if ( logicAddr >= _map4SpeedUp.lastblkLgcOff &&
					logicAddr < _map4SpeedUp.lastblkLgcOff + eraseSz) {
				*phyAddr = _map4SpeedUp.lastblkPhyOff + offsetInBlk;
				return 0;
			}
			_map4SpeedUp.lastblkLgcOff += eraseSz;
		}
	}

	return __LINE__;
}
#endif// #ifdef CONFIG_AML_MTD


/* mmcinfo 1 will clear info_disprotect before run_command("mmc erase 1") */
static int _info_disprotect_back_before_mmcinfo1 = 0;
extern int info_disprotect;
static inline int isstring(char *p)
{
	char *endptr = p;
	while (*endptr != '\0') {
		if (!(((*endptr >= '0') && (*endptr <= '9'))
			|| ((*endptr >= 'a') && (*endptr <= 'f'))
			|| ((*endptr >= 'A') && (*endptr <= 'F'))
			|| (*endptr == 'x') || (*endptr == 'X')))
			return 1;
		endptr++;
	}

	return 0;
}

static inline int str2long(char *p, ulong *num)
{
	char *endptr;
	*num = simple_strtoul(p, &endptr, 16);
	return (*p != '\0' && *endptr == '\0') ? 1 : 0;
}

static inline int str2longlong(char *p, unsigned long long *num)
{
	char *endptr;

	*num = simple_strtoull(p, &endptr, 16);
	if (*endptr != '\0')
	{
	    switch (*endptr)
	    {
	        case 'g':
	        case 'G':
	            *num<<=10;
	        case 'm':
	        case 'M':
	            *num<<=10;
	        case 'k':
	        case 'K':
	            *num<<=10;
	            endptr++;
	            break;
	    }
	}

	return (*p != '\0' && *endptr == '\0') ? 1 : 0;
}

static int emmc_init(void)
{
	int ret = -1;
	struct mmc *mmc = NULL;
	mmc = find_mmc_device(CONFIG_SYS_MMC_ENV_DEV);
	if (mmc) {
		ret = mmc_init(mmc); // init eMMC/tSD+
	}
	return ret;
}

static int get_device_boot_flag(void)
{
	int ret=0;
	if (1) {//nand and emmc
		//try eMMC init
		device_boot_flag = EMMC_BOOT_FLAG;
		ret = emmc_init();
		if (!ret) {
			printf("XXXXXXX======enter EMMC boot======XXXXXX\n");
			return 0;
		}
		printf("EMMC init failed\n");

#if defined(CONFIG_AML_NAND) || defined(CONFIG_AML_MTD)
		//try nand first
	#if defined(CONFIG_AML_NAND)
		ret = amlnf_init(0x5);
	#elif defined(CONFIG_AML_MTD)
		nand_init();
	#endif
		ret = (device_boot_flag == NAND_BOOT_FLAG) ? 0 : __LINE__;
		if (!ret) {
			printf("XXXXXXX======enter NAND boot======XXXXXX\n");
			return 0;
		}
		printf("NAND init failed\n");
#else
		printf("check again, may error code used!\n");
#endif
	}

	printf("device_boot_flag=%d\n",device_boot_flag);
	return -1;
}

static int get_off_size(int argc, char *argv[],  loff_t *off, loff_t *size)
{
		if (argc >= 1) {
			if (!(str2longlong(argv[0], (unsigned long long*)off))) {
			store_msg("'%s' is not a number\n", argv[0]);
				return -1;
			}
		} else {
				*off = 0;
				*size = 0;
		}

		if (argc >= 2) {
				if (!(str2longlong(argv[1], (unsigned long long *)size))) {
						store_msg("'%s' is not a number\n", argv[1]);
						return -1;
				}
		}else{
				*size = 0;
		}

		store_dbg("offset 0x%llx, size 0x%llx", *off, *size);

		return 0;
}

//store dtb read/write buff size
static int do_store_dtb_ops(cmd_tbl_t * cmdtp, int flag, int argc, char * const argv[])
{
		int ret = 0;
		char _cmdBuf[128];
		char* ops = argv[2];
		const unsigned maxDtbSz = 256 * 1024;
		unsigned actualDtbSz = 0;
		char* devCmd = NULL;
		char* dtbLoadaddr = argv[3];

		if (argc < 4) return CMD_RET_USAGE;

		const int is_write = !strcmp("write", ops);
		if (!is_write) {
				ret = !strcmp("read", ops) || !strcmp("iread", ops);//must be 0
				if (!ret) return CMD_RET_USAGE;
		}

		actualDtbSz = maxDtbSz;
		if (argc > 4) {
				const unsigned bufSz = simple_strtoul(argv[4], NULL, 0);
				if (bufSz > maxDtbSz) {
						ErrP("bufSz (%s) > max 0x%x\n", argv[4], maxDtbSz);
						return CMD_RET_FAILURE;
				}
		}

		ops = is_write ? "dtb_write" : "dtb_read";

		switch (device_boot_flag)
		{
				case NAND_BOOT_FLAG:
				case SPI_NAND_FLAG:
						{
								devCmd = "amlnf";
						}
						break;

				case EMMC_BOOT_FLAG:
				case SPI_EMMC_FLAG:
						{
								devCmd = "emmc";
						}
						break;

				default:
						ErrP("device_boot_flag=0x%x err\n", device_boot_flag);
						return CMD_RET_FAILURE;
		}

		sprintf(_cmdBuf, "%s %s %s 0x%x", devCmd, ops, dtbLoadaddr, actualDtbSz);
		MsgP("To run cmd[%s]\n", _cmdBuf);
		ret = run_command(_cmdBuf, 0);

		unsigned long dtImgAddr = simple_strtoul(dtbLoadaddr, NULL, 16);
		//
		//ONLY need decrypting when 'store dtb read'
	   if (!strcmp("read", argv[2]))
	   {
		   flush_cache(dtImgAddr, AML_DTB_IMG_MAX_SZ);
		   ret = aml_sec_boot_check(AML_D_P_IMG_DECRYPT, dtImgAddr, AML_DTB_IMG_MAX_SZ, 0);
		   if (ret) {
			   MsgP("decrypt dtb: Sig Check %d\n",ret);
			   return ret;
		   }
	   }

	   if (!is_write && strcmp("iread", argv[2]))
	   {
			ulong nCheckOffset;
			nCheckOffset = aml_sec_boot_check(AML_D_Q_IMG_SIG_HDR_SIZE,GXB_IMG_LOAD_ADDR,GXB_EFUSE_PATTERN_SIZE,GXB_IMG_DEC_ALL);
			if (AML_D_Q_IMG_SIG_HDR_SIZE == (nCheckOffset & 0xFFFF))
				nCheckOffset = (nCheckOffset >> 16) & 0xFFFF;
			else
				nCheckOffset = 0;

			if (nCheckOffset)
				memmove((char *)dtImgAddr, (char*)dtImgAddr + nCheckOffset, AML_DTB_IMG_MAX_SZ);
		}
#ifdef CONFIG_MULTI_DTB
		if (!is_write && strcmp("iread", argv[2]))
		{
				extern unsigned long get_multi_dt_entry(unsigned long fdt_addr);

				unsigned long fdtAddr = get_multi_dt_entry(dtImgAddr);
				ret = fdt_check_header((char*)fdtAddr);
				if (ret) {
						ErrP("Fail in fdt check header\n");
						return CMD_RET_FAILURE;
				}
				unsigned fdtsz    = fdt_totalsize((char*)fdtAddr);
				memmove((char*)dtImgAddr, (char*)fdtAddr, fdtsz);
		}
#endif// #ifdef CONFIG_MULTI_DTB

		return ret;
}

/*
  write mbr to emmc only.
  store mbr Addr
 */
extern int emmc_update_mbr(unsigned char *buffer);
static int do_store_mbr_ops(cmd_tbl_t * cmdtp, int flag, int argc, char * const argv[])
{
	int ret = 0;
	unsigned char *buffer;
	cpu_id_t cpu_id = get_cpu_id();

	if ((cpu_id.family_id < MESON_CPU_MAJOR_ID_GXL)
	   || (device_boot_flag != EMMC_BOOT_FLAG)) {
		ret = -1;
		ErrP("MBR not support, try [store dtb write Addr]\n");
		goto _out;
	}

	if (argc < 3) return CMD_RET_USAGE;

	buffer = (unsigned char *)simple_strtoul(argv[2], NULL, 16);
	ret = emmc_update_mbr(buffer);
	if (ret) {
		ErrP("fail to update mbr\n");
		goto _out;
	}
_out:
	return ret;
}

#define IS_STORAGE_EMMC_BOOT(device) (((device) == EMMC_BOOT_FLAG)	\
	|| ((device) == SPI_EMMC_FLAG))

#define STORAGE_BOOT_UNKNOWN(device) (((device) != EMMC_BOOT_FLAG)	\
	&& ((device) != SPI_EMMC_FLAG)	\
	&& ((device) != NAND_BOOT_FLAG)	\
	&& ((device) != SPI_NAND_FLAG))

int store_ddr_parameter_read(uint8_t *buffer,
			     uint32_t length)
{
	int ret = 0;

	if (STORAGE_BOOT_UNKNOWN(device_boot_flag)) {
		ErrP("device_boot_flag=0x%x err\n", device_boot_flag);
		return -ENODEV;
	}

	if (IS_STORAGE_EMMC_BOOT(device_boot_flag))
		ret = mmc_ddr_parameter_read(buffer, (int)length);
#if defined(CONFIG_AML_MTD)
	else
		ret = amlnf_ddr_parameter_read(buffer, (int)length);
#endif
	return ret;
}

int store_ddr_parameter_write(uint8_t *buffer, uint32_t length)
{
	int ret = 0;

	if (STORAGE_BOOT_UNKNOWN(device_boot_flag)) {
		ErrP("device_boot_flag=0x%x err\n", device_boot_flag);
		return -ENODEV;
	}

	if (IS_STORAGE_EMMC_BOOT(device_boot_flag))
		ret = mmc_ddr_parameter_write(buffer, (int)length);
#if defined(CONFIG_AML_MTD)
	else
		ret = amlnf_ddr_parameter_write(buffer, (int)length);
#endif
	return ret;
}

int store_ddr_parameter_erase(void)
{
	int ret = 0;

	if (STORAGE_BOOT_UNKNOWN(device_boot_flag)) {
		ErrP("device_boot_flag=0x%x err\n", device_boot_flag);
		return -ENODEV;
	}

	if (IS_STORAGE_EMMC_BOOT(device_boot_flag))
		ret = mmc_ddr_parameter_erase();
#if defined(CONFIG_AML_MTD)
	else
		ret = amlnf_ddr_parameter_erase();
#endif
	return ret;
}

int store_key_read(uint8_t *buffer,
		   uint32_t length, uint32_t *actual_lenth)
{
	int ret = 0;

	if (STORAGE_BOOT_UNKNOWN(device_boot_flag)) {
		ErrP("device_boot_flag=0x%x err\n", device_boot_flag);
		return -ENODEV;
	}

	if (IS_STORAGE_EMMC_BOOT(device_boot_flag))
		ret = mmc_key_read(buffer, (int)length, actual_lenth);
#if defined(CONFIG_AML_NAND) || defined(CONFIG_AML_MTD)
	else
		ret = amlnf_key_read(buffer, (int)length, actual_lenth);
#endif
	return ret;
}

int store_key_write(uint8_t *buffer,
		    uint32_t length, uint32_t *actual_lenth)
{
	int ret = 0;

	if (STORAGE_BOOT_UNKNOWN(device_boot_flag)) {
		ErrP("device_boot_flag=0x%x err\n", device_boot_flag);
		return -ENODEV;
	}

	if (IS_STORAGE_EMMC_BOOT(device_boot_flag))
		ret = mmc_key_write(buffer, (int)length, actual_lenth);
#if defined(CONFIG_AML_NAND) || defined(CONFIG_AML_MTD)
	else
		ret = amlnf_key_write(buffer, (int)length, actual_lenth);
#endif
	return ret;
}

static int do_store_key_ops(cmd_tbl_t * cmdtp, int flag, int argc, char * const argv[])
{
	int ret = 0;
	char _cmdBuf[128];
	char* ops = argv[2];
	const unsigned maxKyeSz = 256 * 1024;
	unsigned actualDtbSz = 0;
	char* devCmd = NULL;

	if (argc < 4) return CMD_RET_USAGE;

	const int is_write = !strcmp("write", ops);
	if (!is_write) {
		ret = strcmp("read", ops);//must be 0
		if (ret) return CMD_RET_USAGE;
	}

	actualDtbSz = maxKyeSz;
	if (argc > 4) {
		const unsigned bufSz = simple_strtoul(argv[4], NULL, 0);
		if (bufSz > maxKyeSz) {
			ErrP("bufSz (%s) > max 0x%x\n", argv[4], maxKyeSz);
			return CMD_RET_FAILURE;
		}
	}

	ops = is_write ? "key_write" : "key_read";

	switch (device_boot_flag) {
	case NAND_BOOT_FLAG:
	case SPI_NAND_FLAG:
		devCmd = "amlnf";
		break;
	case EMMC_BOOT_FLAG:
	case SPI_EMMC_FLAG:
		devCmd = "emmc";
		break;
	default:
		ErrP("device_boot_flag=0x%x err\n", device_boot_flag);
		return CMD_RET_FAILURE;
	}

	sprintf(_cmdBuf, "%s %s %s 0x%x", devCmd, ops, argv[3], actualDtbSz);
	MsgP("To run cmd[%s]\n", _cmdBuf);
	ret = run_command(_cmdBuf, 0);

	return ret;
}

static int do_store_ddr_parameter_ops(cmd_tbl_t * cmdtp,
				      int flag, int argc, char * const argv[])
{
	unsigned long addr;
	int ret = 0;
	char* ops = argv[2];
	const unsigned maxDdrPSz = 2 * 1024;
	unsigned int actualDtbSz = 0;

	if (!strcmp("erase", ops) && (argc == 3)) {
		 ret = store_ddr_parameter_erase();
		 return ret;
	}

	if (argc < 4) return CMD_RET_USAGE;

	const int is_write = !strcmp("write", ops);
	if (!is_write) {
		ret = strcmp("read", ops);//must be 0
		if (ret) return CMD_RET_USAGE;
	}
	actualDtbSz = maxDdrPSz;
	if (argc > 4) {
		const unsigned bufSz = simple_strtoul(argv[4], NULL, 0);
		if (bufSz > maxDdrPSz) {
			ErrP("bufSz (%s) > max 0x%x\n", argv[4], maxDdrPSz);
			return CMD_RET_FAILURE;
		}
	}
	addr = (ulong)simple_strtoul(argv[3], NULL, 16);
	if (is_write)
		store_ddr_parameter_write((uint8_t *)addr, actualDtbSz);
	else
		store_ddr_parameter_read((uint8_t *)addr, actualDtbSz);

	return ret;
}

static int do_store_init(cmd_tbl_t * cmdtp, int flag, int argc, char * const argv[])
{
	int i, init_flag=0, ret = 0;
	char *cmd = "";
	char	str[128];

	init_flag = (argc > 2) ? (int)simple_strtoul(argv[2], NULL, 16) : 0;
	store_dbg("init_flag %d",init_flag);

	//Forcing updateing device_boot_flag every time 'store init'
	if (device_boot_flag == _AML_DEVICE_BOOT_FLAG_DEFAULT || 1) {
		i = get_device_boot_flag();
		if (i) {
			MsgP("ERR:FAILED in get_device_boot_flag\n");
			return __LINE__;
		}
	}

	switch (device_boot_flag)
	{
#if defined(CONFIG_AML_NAND)
		case NAND_BOOT_FLAG:
			{
				if ((init_flag >=STORE_BOOT_ERASE_PROTECT_CACHE) && (init_flag <=STORE_BOOT_SCRUB_ALL)) {
					sprintf(str, "amlnf  init  %d ",init_flag);
					run_command(str, 0);
				}

				sprintf(str, "amlnf  init  %d ",1);
				printf("command:	%s <- %d\n", str, init_flag);
				device_boot_flag = NAND_BOOT_FLAG;
				ret = run_command(str, 0);
				if (ret != 0) {
					return -1;
				}
				return ret;
			}
			break;
#endif// #if defined(CONFIG_AML_NAND)
#ifdef	CONFIG_AML_MTD
		case NAND_BOOT_FLAG:
			{
				ret = run_command("nand init", 0);
				if (init_flag >= STORE_BOOT_ERASE_PROTECT_CACHE) {
					ret |= run_command("amlnf rom_erase",0);
					ret |= run_command("nand device 1", 0);
					ret |= run_command("nand erase.chip", 0);
				}
			}
			return ret;
#endif// #ifdef	CONFIG_AML_MTD
		case EMMC_BOOT_FLAG:
			{
				store_dbg("MMC BOOT, %s %d \n",__func__,__LINE__);
				device_boot_flag = EMMC_BOOT_FLAG;
				sprintf(str, "mmc dev %d", CONFIG_SYS_MMC_ENV_DEV);
				run_command(str,0);
				ret = run_command("mmcinfo", 0);
				if (ret != 0) {
					store_msg("amlmmc cmd %s failed \n",cmd);
					return -1;
				}
				if (init_flag == STORE_BOOT_ERASE_PROTECT_CACHE) { // OTA upgrade protect cache
					ret = run_command("amlmmc erase non_cache", 0);
				}else if(init_flag >= STORE_BOOT_ERASE_ALL){ // erase all except  reserved area
					if (_info_disprotect_back_before_mmcinfo1 & DISPROTECT_KEY) {
						MsgP("amlmmc key\n");
						run_command("amlmmc key", 0);
					}
					sprintf(str, "amlmmc erase %d", CONFIG_SYS_MMC_ENV_DEV);
					MsgP("amlmmc erase %d", CONFIG_SYS_MMC_ENV_DEV);
					ret = run_command(str, 0);
				}

				return ret;
			}
			break;
		case SPI_EMMC_FLAG:
		case SPI_NAND_FLAG:
			{
				/*
				   if (device_boot_flag == -1)
				   {
				   ret = run_command("sf probe 2", 0);
				   if (ret) {
				   store_msg(" cmd %s failed \n",cmd);
				   return -1;
				   }
				   if ((init_flag > STORE_BOOT_ERASE_PROTECT_CACHE) && (init_flag <= STORE_BOOT_SCRUB_ALL)) {
				   sprintf(str, "sf erase 0 0x%x", _SPI_FLASH_ERASE_SZ);
				   ret = run_command(str,0);
				   }
				   sprintf(str, "amlnf  init  %d ",init_flag);
				   store_dbg("command:	%s", str);
				   ret = run_command(str, 0);
				   if (ret < 0) //fail to init NAND flash
				   {
				   store_msg("nand cmd %s failed \n",cmd);
				   device_boot_flag = SPI_EMMC_FLAG;
				   store_dbg("spi+mmc , %s %d ",__func__,__LINE__);
				   ret = run_command("mmcinfo 1", 0);
				   if (ret != 0) {
				   store_msg("mmc cmd %s failed \n",cmd);
				   return -2;
				   }
				   if (init_flag == STORE_BOOT_ERASE_PROTECT_CACHE) { // OTA upgrade protect cache
				   store_msg("mmc erase non_cache \n");
				   ret = run_command("mmc erase non_cache", 0);
				   }else if(init_flag >= STORE_BOOT_ERASE_ALL){ // erase all except  reserved area
				   if (_info_disprotect_back_before_mmcinfo1 & DISPROTECT_KEY) {
				   MsgP("mmc key;\n");
				   run_command("mmc key", 0);
				   }
				   MsgP("mmc erase 1 \n");
				   ret = run_command("mmc erase 1", 0);
				   }
				   return 0;
				   }
				   else if((ret == NAND_INIT_FAILED)&&(init_flag == STORE_BOOT_ERASE_ALL)){
				   sprintf(str, "amlnf  init  %d ",4);
				   ret = run_command(str, 0);
				   }
				   device_boot_flag = SPI_NAND_FLAG;
				   return 0;
				   }
				   */
				if (device_boot_flag == SPI_NAND_FLAG) {
					store_dbg("spi+nand , %s %d ",__func__,__LINE__);
#if defined(CONFIG_AML_NAND)
					if ((init_flag >=STORE_BOOT_ERASE_PROTECT_CACHE) && (init_flag <=STORE_BOOT_SCRUB_ALL)) {
						sprintf(str, "amlnf  init  %d ",init_flag);
						run_command(str, 0);
					}
					sprintf(str, "amlnf  init  %d ",1);
					store_dbg("command:	%s", str);
					ret = run_command(str, 0);
#else
					ret = NAND_INIT_FAILED;
#endif
#if	0
					if ((ret == NAND_INIT_FAILED) && (init_flag == STORE_BOOT_ERASE_ALL)) {
						sprintf(str, "amlnf  init  %d ",4);
						ret = run_command(str, 0);
					}
#else
					if (ret == NAND_INIT_FAILED) {
						return -1;
					}
#endif
					if ((init_flag > STORE_BOOT_ERASE_PROTECT_CACHE) && (init_flag <= STORE_BOOT_SCRUB_ALL)) {
						ret = run_command("sf probe 2", 0);
						sprintf(str, "sf erase  0 0x%x", _SPI_FLASH_ERASE_SZ);
						ret = run_command(str,0);
					}
				}
				if (device_boot_flag == SPI_EMMC_FLAG) {
					store_dbg("spi+mmc , %s %d ",__func__,__LINE__);
					ret = run_command("mmcinfo 1", 0);

					if (init_flag == STORE_BOOT_ERASE_PROTECT_CACHE) { // OTA upgrade protect cache
						store_msg("amlmmc erase non_cache \n");
						ret = run_command("amlmmc erase non_cache", 0);
					}else if(init_flag == STORE_BOOT_ERASE_ALL){ // erase all except  reserved area
						if (_info_disprotect_back_before_mmcinfo1 & DISPROTECT_KEY) {
							run_command("mmc key", 0);
						}
						MsgP("amlmmc erase 1 \n");
						ret = run_command("amlmmc erase 1", 0);
					}
					if ((init_flag > STORE_BOOT_ERASE_PROTECT_CACHE) && (init_flag <= STORE_BOOT_SCRUB_ALL)) {
						ret = run_command("sf probe 2", 0);
						sprintf(str, "sf erase  0 0x%x", _SPI_FLASH_ERASE_SZ);
						ret = run_command(str,0);
					}
				}

				if (ret != 0) {
					store_msg("cmd %s failed \n",cmd);
					return -1;
				}

				return ret;
			}
		default:
			store_dbg("CARD BOOT, %s %d",__func__,__LINE__);
			return CMD_RET_FAILURE;
	}

	return 0;
}

static int do_store_exit(cmd_tbl_t * cmdtp, int flag, int argc, char * const argv[])
{
#if defined(CONFIG_AML_NAND)
	if (device_boot_flag == NAND_BOOT_FLAG) {
		int ret = run_command("amlnf exit", 0);
		if (ret != 0) {
			MsgP("amlnf exit failed");
			return -1;
		}
	}
#endif
	return 0;
}

static int do_store_disprotect(cmd_tbl_t * cmdtp, int flag, int argc, char * const argv[])
{
	char *area;

	area = argv[2];
	if (strcmp(area, "key") == 0) {
		MsgP("disprotect key\n");
		info_disprotect |= DISPROTECT_KEY;
		_info_disprotect_back_before_mmcinfo1 |= DISPROTECT_KEY;
	}
	if (strcmp(area, "fbbt") == 0) {
		store_msg("disprotect fbbt");
		info_disprotect |= DISPROTECT_FBBT;
	}
	if (strcmp(area, "hynix") == 0) {
		store_msg("disprotect hynix");
		info_disprotect |= DISPROTECT_HYNIX;
	}

	return 0;
}

static int do_store_size(cmd_tbl_t * cmdtp, int flag, int argc, char * const argv[])
{
	int ret = 0;
	uint64_t addr;
	char *cmd = NULL, *s = NULL;
	char	str[128];

	if (argc < 4) return CMD_RET_USAGE;

	s = argv[2];
	addr = (ulong)simple_strtoul(argv[3], NULL, 16);
	if ( !addr ) {
		ErrP("addr(%s) is invalid\n", argv[3]);
		return CMD_RET_FAILURE;
	}

	if (device_boot_flag == NAND_BOOT_FLAG) {
#if defined(CONFIG_AML_NAND)
		sprintf(str, "amlnf  size  %s %llx",s,addr);
		store_dbg("command:	%s", str);
		ret = run_command(str, 0);
#elif defined(CONFIG_AML_MTD)
		{//get mtd part logic size (i.e, not including the bad blocks)
			nand_info_t * mtdPartInf = NULL;
			loff_t off = 0;
			uint64_t partSzLgc = 0;
			const char* partName = s;

			mtdPartInf = get_mtd_device_nm(partName);
			if (IS_ERR(mtdPartInf)) {
				ErrP("device(%s) is err\n", partName);
				return CMD_RET_FAILURE;
			}
			const unsigned eraseSz   = mtdPartInf->erasesize;
			const uint64_t partSzPhy = mtdPartInf->size;

			partSzLgc = partSzPhy;
			for (; off < partSzPhy; off += eraseSz) {
				if (nand_block_isbad(mtdPartInf, off)) {
					partSzLgc -= eraseSz;
				}
			}
			uint64_t* pAddr = (uint64_t*)addr;
			*pAddr = partSzLgc;
		}
#else
		ret = -1;
#endif// #if defined(CONFIG_AML_NAND)
		if (ret != 0) {
			store_msg("nand cmd %s failed",cmd);
			return -1;
		}
		return ret;
	}
	else if(device_boot_flag == SPI_NAND_FLAG){
		#if defined(CONFIG_AML_NAND)
		sprintf(str, "amlnf  size  %s %llx",s,addr);
		store_dbg("command:	%s", str);
		ret = run_command(str, 0);
		#else
		ret = -1;
		#endif
		if (ret != 0) {
			store_msg("nand cmd %s failed",cmd);
			return -1;
		}
		return ret;
	}
	else if(device_boot_flag == SPI_EMMC_FLAG){
		store_dbg("MMC , %s %d ",__func__,__LINE__);
		sprintf(str, "amlmmc  size  %s %llx",s,addr);
		store_dbg("command:	%s", str);
		ret = run_command(str, 0);
		if (ret != 0) {
			store_msg("amlmmc cmd %s failed",cmd);
			return -1;
		}
		return ret;
	}
	else if(device_boot_flag==EMMC_BOOT_FLAG){
		store_dbg("MMC , %s %d ",__func__,__LINE__);
		sprintf(str, "amlmmc  size  %s %llx",s,addr);
		store_dbg("command:	%s", str);
		ret = run_command(str, 0);
		if (ret != 0) {
			store_msg("amlmmc cmd %s failed",cmd);
			return -1;
		}
		return ret;
	}
	else if(device_boot_flag==CARD_BOOT_FLAG){
		store_dbg("CARD BOOT , %s %d ",__func__,__LINE__);
		return CMD_RET_FAILURE;
	}

	return CMD_RET_FAILURE;
}

static int do_store_erase(cmd_tbl_t * cmdtp, int flag, int argc, char * const argv[])
{
	int i, ret = 0;
	loff_t size=0;
	char *cmd = NULL, *area;
	char	str[128];
	loff_t off;

	if (argc < 3) return CMD_RET_USAGE;

	off = off;
	area = argv[2];
	cmd = argv[2];

	if (strcmp(area, "boot") == 0) {
			off =  argc > 3 ? simple_strtoul(argv[3], NULL, 16) : 0;
			size =  argc > 4 ? simple_strtoul(argv[4], NULL, 16) : 0x60000;
		if (device_boot_flag == NAND_BOOT_FLAG) {
			#if defined(CONFIG_AML_NAND)
			store_dbg("NAND BOOT,erase uboot : %s %d  off =%llx ,size=%llx",__func__,__LINE__, off, size);

			ret = run_command("amlnf deverase boot 0",0);
			#elif defined(CONFIG_AML_MTD)
			ret = run_command("amlnf rom_erase",0);
			#else
			ret = -1;
			#endif
			if (ret != 0) {
				store_msg("nand cmd %s failed ",cmd);
				return -1;
			}
			return ret;
		}else if((device_boot_flag==SPI_EMMC_FLAG)||(device_boot_flag==SPI_NAND_FLAG)){
			store_dbg("SPI BOOT,erase uboot :  %s %d  off =%llx ,size=%llx",__func__,__LINE__,off,size);

			ret = run_command("sf probe 2",0);
			if (ret != 0) {
				store_msg("nand cmd %s failed",cmd);
				return -1;
			}
			sprintf(str, "sf erase  0 0x%x", CONFIG_ENV_IN_SPI_OFFSET);//store erase boot shoould NOT erase ENV in flash!
			ret = run_command(str,0);
			if (ret != 0) {
				store_msg("nand cmd %s failed",cmd);
				return -1;
			}
			return ret;
		}else if(device_boot_flag == EMMC_BOOT_FLAG){
			store_dbg("MMC BOOT,erase uboot :  %s %d  off =%llx ,size=%llx",__func__,__LINE__,off,size);

			sprintf(str, "amlmmc  erase bootloader");
			ret = run_command(str, 0);
			if (ret != 0) {
				store_msg("amlmmc cmd %s failed",cmd);
				return -1;
			}

#ifdef MMC_BOOT_PARTITION_SUPPORT
			printf("%s() %d\n", __func__, __LINE__);

			for (i=0; i<2; i++) {
				printf("%s() %d, i = %d\n", __func__, __LINE__, i);
				//switch to boot partition here
				sprintf(str, "amlmmc switch 1 boot%d", i);
				store_dbg("command: %s\n", str);
				ret = run_command(str, 0);
				if (ret == -1) {
					//store_msg("mmc cmd %s failed \n",cmd);
					return 0;
				}
				else if(ret != 0){
					store_msg("amlmmc cmd %s failed",cmd);
					//return -1;
					goto E_SWITCH_BACK;
				}

				//erase boot partition
				sprintf(str, "amlmmc erase bootloader");
				ret = run_command(str, 0);
				if (ret != 0) {
					store_msg("amlmmc cmd %s failed",cmd);
					//return -1;
					goto E_SWITCH_BACK;
				}
			}

E_SWITCH_BACK:
			//switch back to urs partition
			sprintf(str, "amlmmc switch 1 user");
			store_dbg("command: %s\n", str);
			ret = run_command(str, 0);
			if (ret != 0) {
				store_msg("amlmmc cmd %s failed \n",cmd);
				return -1;
			}

#endif

			return ret;
		}else{
			store_dbg("CARD BOOT,erase uboot :  %s %d  off =%llx ,size=%llx",__func__,__LINE__,off,size);
			return 0;
		}
	}
	else if (strcmp(area, "data") == 0){
		if (device_boot_flag == NAND_BOOT_FLAG) {
			store_dbg("NAND BOOT,erase data : %s %d  off =%llx ,size=%llx",__func__,__LINE__, off, size);
			#if defined(CONFIG_AML_NAND)
			ret = run_command("amlnf  deverase data 0",0);
			if (ret != 0) {
				store_msg("nand cmd %s failed ",cmd);
				return -1;
			}
			ret = run_command("amlnf  deverase code 0",0);
			if (ret != 0) {
				store_msg("nand cmd %s failed ",cmd);
				return -1;
			}
			ret = run_command("amlnf  deverase cache 0",0);
			if (ret != 0) {
				store_msg("nand cmd %s failed ",cmd);
				return -1;
			}
			#elif defined(CONFIG_AML_MTD)
				ret = run_command("nand device 1", 0);
				ret |= run_command("nand erase.chip", 0);
			#endif
			return ret;
		}
		else if(device_boot_flag == SPI_NAND_FLAG){
			store_dbg("spi+nand , %s %d ",__func__,__LINE__);
			#if defined(CONFIG_AML_NAND)
			ret = run_command("amlnf  deverase data 0",0);
			if (ret != 0) {
				store_msg("nand cmd %s failed ",cmd);
				return -1;
			}

			ret = run_command("amlnf  deverase code 0",0);
			if (ret != 0) {
				store_msg("nand cmd %s failed ",cmd);
				return -1;
			}
			ret = run_command("amlnf  deverase cache 0",0);
			if (ret != 0) {
				store_msg("nand cmd %s failed ",cmd);
				return -1;
			}
			#endif
			return ret;
		}
		else if(device_boot_flag == SPI_EMMC_FLAG){
			store_dbg("spi+mmc , %s %d ",__func__,__LINE__);
			off = size =0;
			ret = run_command("mmc  erase  1",0); // whole
			if (ret != 0) {
				store_msg("mmc cmd %s failed ",cmd);
				return -1;
			}

			return ret;
		}
		else if(device_boot_flag==EMMC_BOOT_FLAG){
			store_dbg("MMC BOOT,erase data : %s %d  off =%llx ,size=%llx",__func__,__LINE__, off, size);
			off = size =0;
			ret = run_command("amlmmc erase 1",0); //whole
			if (ret != 0) {
				store_msg("amlmmc cmd %s failed ",cmd);
				return -1;
			}
			return ret;
		}else{
			store_dbg("CARD BOOT,erase data : %s %d  off =%llx ,size=%llx",__func__,__LINE__, off, size);
			return 0;
		}
	}
	else if (strcmp(area, "key") == 0){
		if (device_boot_flag == EMMC_BOOT_FLAG) {
			sprintf(str, "emmc erase key");
			ret = run_command(str, 0);
			if (ret != 0) {
				store_msg("emmc cmd %s failed",cmd);
				return CMD_RET_USAGE;
			}
		} else if (device_boot_flag == NAND_BOOT_FLAG) {
		#if defined(CONFIG_AML_NAND) || defined(CONFIG_AML_MTD)
			sprintf(str, "amlnf key_erase");
			ret = run_command(str, 0);
			if (ret != 0) {
				store_msg("emmc cmd %s failed",cmd);
				return CMD_RET_USAGE;
			}
		#endif
		}
	}
	else if (strcmp(area, "dtb") == 0) {
		if (device_boot_flag == EMMC_BOOT_FLAG) {
			sprintf(str, "emmc erase dtb");
			ret = run_command(str, 0);
			if (ret != 0) {
				store_msg("emmc cmd %s failed",cmd);
				return CMD_RET_USAGE;
			}
		} else if (device_boot_flag == NAND_BOOT_FLAG) {
		#if defined(CONFIG_AML_NAND) || defined(CONFIG_AML_MTD)
			sprintf(str, "amlnf dtb_erase");
			ret = run_command(str, 0);
			if (ret != 0) {
				store_msg("emmc cmd %s failed",cmd);
				return CMD_RET_USAGE;
			}
		#endif
		}
	} else if (strcmp(area, "partition") == 0) {
		if (device_boot_flag == EMMC_BOOT_FLAG) {
			int blk_shift;
			int dev, n;
			u64 cnt=0, blk =0;
			struct partitions *part_info;
			struct mmc *mmc = NULL;
			char *p_name = NULL;

			p_name = argv[3];
			if (!p_name)
				return CMD_RET_USAGE;

			dev = find_dev_num_by_partition_name(p_name);
			mmc = find_mmc_device(dev);
			if (!mmc)
				return CMD_RET_FAILURE;

			mmc_init(mmc);
			blk_shift = ffs(mmc->read_bl_len) -1;
			if (!(info_disprotect & DISPROTECT_KEY)
					&& (strncmp(p_name, MMC_RESERVED_NAME,
							sizeof(MMC_RESERVED_NAME)) == 0x00)) {
				printf("\"%s-partition\" is been protecting and should no be erased!\n",
						MMC_RESERVED_NAME);
				return CMD_RET_FAILURE;
			}

			part_info = find_mmc_partition_by_name(p_name);
			if (part_info == NULL)
				return CMD_RET_FAILURE;

			blk = part_info->offset>> blk_shift;
			if (emmc_cur_partition
					&& !strncmp(p_name, "bootloader", strlen("bootloader")))
				cnt = mmc->boot_size>> blk_shift;
			else
				cnt = part_info->size>> blk_shift;
			n = mmc->block_dev.block_erase(dev, blk, cnt);
			printf("store erase \"%s-partition\" is %s\n", p_name, n ? "fail" : "ok");
			if (n)
				return CMD_RET_FAILURE;
		}
		else if (NAND_BOOT_FLAG == device_boot_flag){
#ifdef CONFIG_AML_MTD
			if ( 4 > argc ) return CMD_RET_USAGE;
			sprintf(str, "nand erase.part %s", argv[3]);
			return run_command(str, 0);
#else
			return CMD_RET_USAGE;
#endif//#ifdef CONFIG_AML_MTD
		}
		else return CMD_RET_USAGE;
	} else
		return CMD_RET_USAGE;

	return 0;
}

static int do_store_scrub(cmd_tbl_t * cmdtp, int flag, int argc, char * const argv[])
{
	int ret = 0;
	loff_t off=0;
	char *cmd = NULL;
	char	str[128];

	off = (ulong)simple_strtoul(argv[2], NULL, 16);
	sprintf(str, "amlnf  scrub %d", (int)off);
	if (device_boot_flag == NAND_BOOT_FLAG) {
		#if defined(CONFIG_AML_NAND)
		ret = run_command(str, 0);
		#elif defined(CONFIG_AML_MTD)
		printf("%s() fixme, to do...\n", __func__);
		#else
		ret = -1;
		#endif
		if (ret != 0) {
			store_msg("nand cmd %s failed",cmd);
			return -1;
		}
	}
	else if(device_boot_flag == SPI_NAND_FLAG){
		store_dbg("spi+nand , %s %d ",__func__,__LINE__);
		#if defined(CONFIG_AML_NAND)
		ret = run_command(str, 0);
		if (ret != 0) {
			store_msg("nand cmd %s failed",cmd);
			return -1;
		}
		#endif

		ret = run_command("sf probe 2", 0);
		if (ret != 0) {
			store_msg("nand cmd %s failed",cmd);
			return -1;
		}
		sprintf(str, "sf erase  0 0x%x", _SPI_FLASH_ERASE_SZ);
		ret = run_command(str,0);
		if (ret != 0) {
			store_msg("nand cmd %s failed",cmd);
			return -1;
		}
		return ret;
	}
	else if(device_boot_flag == SPI_EMMC_FLAG){
		store_dbg("spi+mmc , %s %d ",__func__,__LINE__);
		ret = run_command("amlmmc erase whole",0);
		if (ret != 0) {
			store_msg("amlmmc cmd %s failed \n",cmd);
			return -1;
		}
		return ret;
	}
	else if(device_boot_flag==EMMC_BOOT_FLAG){
		store_dbg("MMC BOOT, %s %d \n",__func__,__LINE__);
		device_boot_flag = EMMC_BOOT_FLAG;
		run_command("mmc dev 1", 0);
		ret = run_command("mmcinfo", 0);
		if (ret != 0) {
			store_msg("amlmmc cmd %s failed \n",cmd);
			return -1;
		}
		if (_info_disprotect_back_before_mmcinfo1 & DISPROTECT_KEY) {
			MsgP("mmc key\n");
			run_command("mmc key", 0);
		}
		MsgP("amlmmc erase 1");
		ret = run_command("amlmmc erase 1", 0);
	}

	return ret;
}

static int do_store_rom_protect(cmd_tbl_t * cmdtp, int flag, int argc, char * const argv[])
{

#if defined(CONFIG_AML_NAND)
	char *cmd = NULL;
	char	str[128];
	char *area = argv[2];
#endif

	if (argc < 3)return CMD_RET_USAGE;

	if (device_boot_flag == NAND_BOOT_FLAG) {
#if defined(CONFIG_AML_NAND)
		sprintf(str, "amlnf  rom_protect  %s", area);
		store_dbg("command:	%s", str);
		int ret = run_command(str, 0);
		if (ret != 0) {
			store_msg("nand cmd %s failed",cmd);
			return -1;
		}
#elif defined(CONFIG_AML_MTD)
		printf("%s() fixme, to do...\n", __func__);
#else
		return -1;
#endif
	}

	return CMD_RET_SUCCESS;
}

static int do_store_rom_write(cmd_tbl_t * cmdtp, int flag, int argc, char * const argv[])
{
	uint64_t addr;
	loff_t off=0, size=0;
	char *cmd = NULL;
	char	str[128];
	int ret = 0;
	if (argc < 5) return CMD_RET_USAGE;

	addr = (ulong)simple_strtoul(argv[2], NULL, 16);
	if (get_off_size(argc - 3, (char **)(argv + 3), &off, &size) != 0) return CMD_RET_FAILURE;

	if (device_boot_flag == NAND_BOOT_FLAG) {
#if defined(CONFIG_AML_NAND) || defined(CONFIG_AML_MTD)
#ifndef CONFIG_DISCRETE_BOOTLOADER
		sprintf(str, "amlnf rom_write 0x%llx 0x%llx 0x%llx", addr, off, size);
		store_dbg("command:	%s", str);
		ret = run_command(str, 0);
#else
/*
 *store rom_write addr offset size <iCopy>
 //Used to update the whole bootloader, i.e, update 'bl2 + tpl' at the same time
 @iCopy is optional,
	if used, must < min(tplCpyNum, Bl2CpyNum), and update only the specified copy
	if not used, update all the copies of bl2 and tpl
*/
		const int Bl2Size       = BL2_SIZE;
		const int Bl2CpyNum     = CONFIG_BL2_COPY_NUM; //TODO: decided by efuse, no macro
		const int tplCapSize    = CONFIG_TPL_SIZE_PER_COPY;
		const int tplCpyNum     = CONFIG_TPL_COPY_NUM;
		const int bootloaderMaxSz = Bl2Size + tplCapSize;
		const int tplWriteSz     = size - Bl2Size;
		loff_t copyOff = 0;
		const int iCopy2Update  = argc > 5 ? simple_strtoul(argv[5], NULL, 0) : -1;
		const int TPL_MIN_SZ    = (1U << 16);
		const int updateTpl     = TPL_MIN_SZ < tplWriteSz;
		int i = 0;

		if ( bootloaderMaxSz < size ) {
			ErrP("bootloader sz 0x%llx too large,max sz 0x%x\n", size, bootloaderMaxSz );
			return CMD_RET_FAILURE;
		}
		if ( !updateTpl ) {
			MsgP("Warnning:tplWriteSz 0x%x too small, update bl2 only but not update tpl\n", tplWriteSz);
		}
		if (iCopy2Update >= tplCpyNum || iCopy2Update >= Bl2CpyNum) {
			ErrP("iCopy2Update[%s] invalid, must < min(%d, %d)\n", argv[5], tplCpyNum, Bl2CpyNum);
			return CMD_RET_FAILURE;
		}
		for (i = 0; i < Bl2CpyNum; ++i)
		{
			if (iCopy2Update >= 0 && iCopy2Update != i) continue;

			sprintf(str, "amlnf rom_erase %d", i);
			ret = run_command(str, 0);
			if (ret) {
				ErrP("Failed at erase bl2[%d],ret=%d\n", i, ret);
				return CMD_RET_FAILURE;
			}

			//copyOff = i * Bl2Size;
			sprintf(str, "amlnf bl2_write 0x%llx %d 0x%x", addr, i, Bl2Size);
			debugP("runCmd[%s]\n", str);
			ret = run_command(str, 0);
			if (ret) {
				ErrP("Failed at pgram bl2[%d],ret=%d\n", i, ret);
				return CMD_RET_FAILURE;
			}
		}
		addr += Bl2Size;
		for ( i = 0; i < tplCpyNum && updateTpl; ++i )
		{
			if (iCopy2Update >= 0 && iCopy2Update != i) continue;

			sprintf(str, "amlnf fip_erase %d", i);
			ret = run_command(str, 0);
			if (ret) {
				ErrP("Failed at erase tpl[%d],ret=%d\n", i, ret);
				return CMD_RET_FAILURE;
			}

			copyOff = i * tplCapSize;
			sprintf(str, "amlnf fip_write 0x%llx %llx 0x%x", addr, copyOff, tplWriteSz);
			debugP("runCmd[%s]\n", str);
			ret = run_command(str, 0);
			if (ret) {
				ErrP("Failed at pgram bl2[%d],ret=%d\n", i, ret);
				return CMD_RET_FAILURE;
			}
		}
#if CONFIG_TPL_VAL_NUM_MIN
		_bootloaderOrgCrc[0] = crc32(0, (unsigned char*)(addr - Bl2Size), Bl2Size);
		_bootloaderOrgCrc[1] = crc32(0, (unsigned char*)addr, tplWriteSz);
#endif// #if CONFIG_TPL_VAL_NUM_MIN
#endif//#ifndef CONFIG_DISCRETE_BOOTLOADER
#else
		ret = -1;
#endif
		if (ret != 0) {
			store_msg("nand cmd %s failed",cmd);
			return -1;
		}
		return ret;
	}
	else if ((device_boot_flag==SPI_EMMC_FLAG)||(device_boot_flag==SPI_NAND_FLAG)){
		ret = run_command("sf  probe 2",0);
		if (ret != 0) {
			store_msg("nand cmd %s failed",cmd);
			return -1;
		}
		sprintf(str, "sf  erase  0x%llx  0x%llx ", off, size);
		ret = run_command(str, 0);
		if (ret != 0) {
			store_msg("nand cmd %s failed",cmd);
			return -1;
		}
		sprintf(str, "sf  write 0x%llx  0x%llx  0x%llx ",addr, off, size);
		store_dbg("command:	%s", str);
		ret = run_command(str, 0);
		if (ret != 0) {
			store_msg("nand cmd %s failed",cmd);
			return -1;
		}
		return ret;
	}
	else if(device_boot_flag==EMMC_BOOT_FLAG){
		store_dbg("MMC BOOT, %s %d \n",__func__,__LINE__);

#ifndef CONFIG_AML_SECU_BOOT_V2
#ifdef MMC_UBOOT_CLEAR_MBR
		//modify the 55 AA info for emmc uboot
		unsigned char *tmp_buf= (unsigned char *)addr;
		_mbrFlag[0] = tmp_buf[510];
		_mbrFlag[1] = tmp_buf[511];
		tmp_buf[510]=0;
		tmp_buf[511]=0;
#endif
#endif// #if defined(CONFIG_AML_SECU_BOOT_V2)
		sprintf(str, "amlmmc  write bootloader 0x%llx  0x%llx  0x%llx", addr, off, size);
		store_dbg("command: %s\n", str);
		ret = run_command(str, 0);
		if (ret != 0) {
			store_msg("amlmmc cmd %s failed \n",cmd);
			return -1;
		}
		return ret;
	} else {
		store_dbg("CARD BOOT, %s %d",__func__,__LINE__);
		return 0;
	}
}

static int do_store_rom_read(cmd_tbl_t * cmdtp, int flag, int argc, char * const argv[])
{
	uint64_t addr;
	loff_t off=0, size=0;
	char *cmd = NULL;
	char	str[128];
	int ret = 0;
	int i = 0;
	cpu_id_t cpu_id = get_cpu_id();

	if (argc < 5) return CMD_RET_USAGE;

	addr = (ulong)simple_strtoul(argv[2], NULL, 16);
	if (get_off_size(argc - 3, (char **)(argv + 3), &off, &size) != 0) return CMD_RET_FAILURE;

	if (device_boot_flag == NAND_BOOT_FLAG) {
#if defined(CONFIG_AML_NAND) || defined(CONFIG_AML_MTD)
#ifndef CONFIG_DISCRETE_BOOTLOADER
		sprintf(str, "amlnf rom_read 0x%llx 0x%llx 0x%llx", addr, off, size);
		store_dbg("command:	%s", str);
		ret = run_command(str, 0);
#else
/*
 *store rom_read addr offset size <iCopy>
 //Used to read the whole bootloader, i.e, update 'bl2 + tpl' at the same time
 @iCopy is optional,
	if used, must < min(tplCpyNum, Bl2CpyNum), and read only the specified copy
	if not used, check if all the copies of 'bl2 + tpl' are same content
*/
		const int Bl2Size       = BL2_SIZE;
		const int Bl2CpyNum     = CONFIG_BL2_COPY_NUM; //TODO: decided by efuse, no macro
		const int tplCapSize    = CONFIG_TPL_SIZE_PER_COPY;
		const int tplCpyNum     = CONFIG_TPL_COPY_NUM;
		const int bootloaderMaxSz = Bl2Size + tplCapSize;
		const int tplRealSz     = size - Bl2Size;
		loff_t copyOff = 0;
		int iCopy2Update  = argc > 5 ? simple_strtoul(argv[5], NULL, 0) : -1;
		char* tmpBuf = NULL;
		int okCrcNum = 0;
		const int verifyMode = (off == (1ULL << 62) - 1) && (iCopy2Update < 0); //verify mode
		if (!verifyMode && iCopy2Update < 0) iCopy2Update = 0; //default read copy 0 if no verify mode

		if ( bootloaderMaxSz < size || tplRealSz < 0 ) {
			ErrP("bootloader sz 0x%llx invalid,  max sz %d\n", size, bootloaderMaxSz );
			return CMD_RET_FAILURE;
		}
		if (iCopy2Update >= tplCpyNum || iCopy2Update >= Bl2CpyNum) {
			ErrP("iCopy2Update[%s] invalid, must < min(%d, %d)\n", argv[5], tplCpyNum, Bl2CpyNum);
			return CMD_RET_FAILURE;
		}

		tmpBuf = (char*)malloc(size);
		if ( !tmpBuf ) {
			ErrP("Failed maloc 0x%llx bytes\n", size);
			return CMD_RET_FAILURE;
		}
		memset(tmpBuf, 0, size);

		char* readBuf = tmpBuf;
		const uint32_t orgBl2Crc = _bootloaderOrgCrc[0];
		for (i = 0; i < Bl2CpyNum; ++i)
		{
			if (iCopy2Update >= 0 && iCopy2Update != i) continue;

			sprintf(str, "amlnf bl2_read 0x%p %x 0x%x", readBuf, i, Bl2Size);
			debugP("runCmd[%s]\n", str);
			ret = run_command(str, 0);
			if (ret) {
				ErrP("Failed at pgram bl2[%d],ret=%d\n", i, ret);
				return CMD_RET_FAILURE;
			}
#if CONFIG_BL2_VAL_NUM_MIN
			if (verifyMode) //copy index not specified, need read all copies
			{
				const uint32_t readCrc = crc32(0, (unsigned char*)readBuf, Bl2Size);
				if (readCrc == orgBl2Crc) {
					okCrcNum += 1;
					if ( okCrcNum >= CONFIG_BL2_VAL_NUM_MIN ) {
						break;
					}
				}
			}
#endif//#if CONFIG_BL2_VAL_NUM_MIN
		}
#if CONFIG_BL2_VAL_NUM_MIN
		if (okCrcNum < CONFIG_BL2_VAL_NUM_MIN && verifyMode) {
			ErrP("okCrcNum(%d) < CONFIG_BL2_VAL_NUM_MIN(%d)\n", okCrcNum, CONFIG_BL2_VAL_NUM_MIN);
			return CMD_RET_FAILURE;
		}
		okCrcNum = 0;
#endif//#if CONFIG_BL2_VAL_NUM_MIN
		memcpy((char*)addr, readBuf, Bl2Size);

		if (tplRealSz > 0) // to support dump only bl2
		{
			const uint32_t orgTplCrc = _bootloaderOrgCrc[1];
			for ( i = 0; i < tplCpyNum && !ret; ++i )
			{
				if (iCopy2Update >= 0 && iCopy2Update != i) continue;

				copyOff = i * tplCapSize;
				sprintf(str, "amlnf fip_read 0x%p %llx 0x%x", readBuf, copyOff, tplRealSz);
				debugP("runCmd[%s]\n", str);
				ret = run_command(str, 0);
				if (ret) {
					ErrP("Failed at pgram bl2[%d],ret=%d\n", i, ret);
					return CMD_RET_FAILURE;
				}
#if CONFIG_TPL_VAL_NUM_MIN
				if (verifyMode) //copy index not specified, need read all copies
				{
					const uint32_t readCrc = crc32(0, (unsigned char*)readBuf, tplRealSz);
					if (orgTplCrc == readCrc) {
						okCrcNum += 1;
						if ( okCrcNum >= CONFIG_TPL_VAL_NUM_MIN ) {
							break;
						}
					}
				}
#endif//#if CONFIG_TPL_VAL_NUM_MIN
			}
#if CONFIG_TPL_VAL_NUM_MIN
			if (okCrcNum < CONFIG_TPL_VAL_NUM_MIN && verifyMode) {
				ErrP("okCrcNum(%d) < CONFIG_TPL_VAL_NUM_MIN(%d)\n", okCrcNum, CONFIG_TPL_VAL_NUM_MIN);
				return CMD_RET_FAILURE;
			}
#endif//#if CONFIG_TPL_VAL_NUM_MIN
			memcpy((char*)addr + Bl2Size, (unsigned char*)readBuf, tplRealSz);
		}
		free(tmpBuf);
#endif// #ifndef CONFIG_DISCRETE_BOOTLOADER
#else
		ret = -1;
#endif// #if defined(CONFIG_AML_NAND) || defined(CONFIG_AML_MTD)
		if (ret != 0) {
			store_msg("nand cmd %s failed",cmd);
			return -1;
		}
		return ret;
	}else if ((device_boot_flag==SPI_EMMC_FLAG)||(device_boot_flag==SPI_NAND_FLAG)){
		ret = run_command("sf  probe 2",0);
		if (ret != 0) {
			return -1;
		}
		sprintf(str, "sf  read 0x%llx  0x%llx  0x%llx ",addr, off, size);
		store_dbg("command:	%s", str);
		ret = run_command(str, 0);
		if (ret != 0) {
			store_msg("nand cmd %s failed",cmd);
			return -1;
		}
		return ret;
	}else if (device_boot_flag==EMMC_BOOT_FLAG){
	   if ( cpu_id.family_id >= MESON_CPU_MAJOR_ID_GXL)
				off += 512;
		store_dbg("MMC BOOT, %s %d \n",__func__,__LINE__);
		sprintf(str, "amlmmc  read bootloader 0x%llx  0x%llx  0x%llx", addr, off, size);
		store_dbg("command: %s\n", str);
		//tmp_buf= (unsigned char *)addr;
		ret = run_command(str, 0);
		if (ret != 0) {
			store_msg("amlmmc cmd %s failed \n",cmd);
			return -1;
		}

#ifdef MMC_BOOT_PARTITION_SUPPORT

		for (i=0; i<2; i++) {
			//switch to boot partition here
			sprintf(str, "amlmmc switch 1 boot%d", i);
			store_dbg("command: %s\n", str);
			ret = run_command(str, 0);
			if (ret == -1) {
				//store_msg("mmc cmd %s failed \n",cmd);
				return 0;
			}
			else if(ret != 0){
				store_msg("amlmmc cmd %s failed",cmd);
				goto R_SWITCH_BACK;
				//return -1;
			}

			//write uboot to boot partition
			sprintf(str, "amlmmc  read bootloader 0x%llx  0x%llx  0x%llx", addr, off, size);
			store_dbg("command: %s\n", str);
			ret = run_command(str, 0);
			if (ret != 0) {
				store_msg("amlmmc cmd %s failed \n",cmd);
				//return -1;
				goto R_SWITCH_BACK;
			}
		}

R_SWITCH_BACK:
		//switch back to urs partition
		sprintf(str, "amlmmc switch 1 user");
		store_dbg("command: %s\n", str);
		ret = run_command(str, 0);
		if (ret != 0) {
			store_msg("amlmmc cmd %s failed \n",cmd);
			return -1;
		}

#endif
#ifndef CONFIG_AML_SECU_BOOT_V2
#ifdef MMC_UBOOT_CLEAR_MBR
		unsigned char *tmp_buf= (unsigned char *)addr;
		tmp_buf[510]= _mbrFlag[0];
		tmp_buf[511]= _mbrFlag[1];
#endif
#endif// #ifndef CONFIG_AML_SECU_BOOT_V2
		return ret;
	}else{
		store_dbg("CARD BOOT, %s %d ",__func__,__LINE__);
		return 0;
	}

}

static int do_store_read(cmd_tbl_t * cmdtp, int flag, int argc, char * const argv[])
{
	uint64_t addr;
	loff_t off=0, size=0;
	char *cmd = NULL;
	char	str[128];
	int ret = 0;
	char * s = argv[2];

	if (argc < 6) return CMD_RET_USAGE;

	addr = (ulong)simple_strtoul(argv[3], NULL, 16);

	if (get_off_size(argc - 4, (char **)(argv + 4), &off, &size) != 0) return CMD_RET_FAILURE;

	store_dbg("addr = %llx off= 0x%llx  size=0x%llx",addr,off,size);
	if ((device_boot_flag == NAND_BOOT_FLAG)) {
#if defined(CONFIG_AML_NAND) || defined(CONFIG_AML_MTD)
#if defined(CONFIG_AML_NAND)
	sprintf(str, "amlnf  read_byte %s 0x%llx  0x%llx  0x%llx",s, addr, off, size);
#elif defined(CONFIG_AML_MTD)
	#if  defined(CONFIG_DISCRETE_BOOTLOADER)
	if ( !strcmp(CONFIG_TPL_PART_NAME, s) ) {
		const int tplCapSize    = CONFIG_TPL_SIZE_PER_COPY;
		const int tplCpyNum     = CONFIG_TPL_COPY_NUM;
		const int iCopy2Update  = argc > 6 ? simple_strtoul(argv[6], NULL, 0) : 0;//0 copy at default

		if (iCopy2Update >= tplCpyNum) {
			ErrP("iCopy2Update[%s] invalid, must < max(%d)\n", argv[6], tplCpyNum);
			return CMD_RET_FAILURE;
		}

		loff_t copyOff = iCopy2Update * tplCapSize;
		sprintf(str, "amlnf fip_read 0x%llx %llx 0x%llx", addr, copyOff, size);
	} else
	#endif // #if  defined(CONFIG_DISCRETE_BOOTLOADER)
	{
		ret =  mtd_find_phy_off_by_lgc_off(s, off, &off);
		if (ret) {
			ErrP("Fail in find phy addr by logic off (0x%llx),ret(%d)\n", off, ret);
			return CMD_RET_FAILURE;
		}
		sprintf(str, "nand  read %s 0x%llx  0x%llx  0x%llx",s, addr, off, size);
	}
#endif // #if defined(CONFIG_AML_NAND)
#else
		ret = -1;
#endif
		ret = run_command(str, 0);
		if (ret != 0) {
			store_msg("nand cmd [%s] failed ",str);
			return -1;
		}
		return ret;
	}
	else if(device_boot_flag == SPI_NAND_FLAG){
		#if defined(CONFIG_AML_NAND)
		sprintf(str, "amlnf  read_byte %s 0x%llx  0x%llx  0x%llx", s, addr, off, size);
		store_dbg("command:	%s\n", str);
		ret = run_command(str, 0);
		#else
		ret = -1;
		#endif
		if (ret != 0) {
			store_msg("nand cmd %s failed \n",cmd);
			return -1;
		}
		return ret;
	}
	else if(device_boot_flag == SPI_EMMC_FLAG){
		store_dbg("spi+mmc , %s %d ",__func__,__LINE__);
		sprintf(str, "amlmmc  read %s 0x%llx  0x%llx  0x%llx", s, addr, off, size);
		store_dbg("command:	%s\n", str);
		ret = run_command(str, 0);
		if (ret != 0) {
			store_msg("amlmmc cmd %s failed \n",cmd);
			return -1;
		}
		return ret;
	}
	else if(device_boot_flag==EMMC_BOOT_FLAG) {
		store_dbg("MMC BOOT, %s %d \n",__func__,__LINE__);
		sprintf(str, "amlmmc  read %s 0x%llx  0x%llx  0x%llx", s, addr, off, size);
		store_dbg("command:	%s\n", str);
		ret = run_command(str, 0);
		if (ret != 0) {
			store_msg("amlmmc cmd %s failed \n",cmd);
			return -1;
		}
		return ret;
	}else{
		store_dbg("CARD BOOT, %s %d ",__func__,__LINE__);

		return 0;
	}
}

static int do_store_write(cmd_tbl_t * cmdtp, int flag, int argc, char * const argv[])
{
	uint64_t addr;
	loff_t off=0, size=0;
	char *cmd = NULL;
	char	str[128];
	int ret = 0;
	char * s = argv[2];

	if (argc < 6) return CMD_RET_USAGE;

	addr = (ulong)simple_strtoul(argv[3], NULL, 16);
	if (get_off_size(argc - 4, (char **)(argv + 4), &off, &size) != 0) return CMD_RET_FAILURE;

	if (device_boot_flag == NAND_BOOT_FLAG) {
#if defined(CONFIG_AML_NAND) || defined(CONFIG_AML_MTD)
	#if defined(CONFIG_AML_NAND)
		sprintf(str, "amlnf write_byte %s 0x%llx  0x%llx  0x%llx", s, addr, off, size);
		ret = run_command(str, 0);
	#elif defined(CONFIG_AML_MTD)
		#if  defined(CONFIG_DISCRETE_BOOTLOADER)
		if ( !strcmp(CONFIG_TPL_PART_NAME, s) ) {
			const int tplCapSize    = CONFIG_TPL_SIZE_PER_COPY;
			const int tplCpyNum     = CONFIG_TPL_COPY_NUM;
			const int iCopy2Update  = argc > 6 ? simple_strtoul(argv[6], NULL, 0) : -1; //only update one copy
			int i = 0;

			debugP("iCopy2Update=%d, tplCpyNum=%d\n", iCopy2Update, tplCpyNum);
			if (iCopy2Update >= tplCpyNum) {
				ErrP("iCopy2Update[%s] invalid, must < max(%d)\n", argv[6], tplCpyNum);
				return CMD_RET_FAILURE;
			}

			for ( i = 0; i < tplCpyNum; ++i )
			{
				if (iCopy2Update >= 0 && iCopy2Update != i) continue;

				sprintf(str, "amlnf fip_erase %d", i);
				ret = run_command(str, 0);
				if (ret) {
					ErrP("Failed at erase tpl[%d],ret=%d\n", i, ret);
					return CMD_RET_FAILURE;
				}

				loff_t copyOff = i * tplCapSize;
				sprintf(str, "amlnf fip_write 0x%llx %llx 0x%llx", addr, copyOff, size);
				debugP("runCmd[%s]\n", str);
				ret = run_command(str, 0);
				if (ret) {
					ErrP("Failed at pgram bl2[%d],ret=%d\n", i, ret);
					return CMD_RET_FAILURE;
				}
			}
		} else
		#endif // #if  defined(CONFIG_DISCRETE_BOOTLOADER)
		{
			ret =  mtd_find_phy_off_by_lgc_off(s, off, &off);
			if (ret) {
				ErrP("Fail in find phy addr by logic off (0x%llx),ret(%d)\n", off, ret);
			}
			sprintf(str, "nand write %s 0x%llx  0x%llx  0x%llx",s, addr, off, size);
			ret = run_command(str, 0);
		}
   #endif
#else
		ret = -1;
#endif
		if (ret != 0) {
			store_msg("nand cmd %s failed ",cmd);
			return -1;
		}
		return ret;
	}
	else if(device_boot_flag == SPI_NAND_FLAG){
		store_dbg("spi+nand , %s %d ",__func__,__LINE__);
		#if defined(CONFIG_AML_NAND)
		sprintf(str, "amlnf  write_byte %s 0x%llx  0x%llx  0x%llx", s, addr, off, size);
		store_dbg("command:	%s", str);
		ret = run_command(str, 0);
		#else
		ret = -1;
		#endif
		if (ret != 0) {
			store_msg("nand cmd %s failed \n",cmd);
			return -1;
		}
		return ret;
	}
	else if(device_boot_flag == SPI_EMMC_FLAG){
		store_dbg("spi+mmc , %s %d ",__func__,__LINE__);
		sprintf(str, "amlmmc  write %s 0x%llx  0x%llx  0x%llx", s, addr, off, size);
		store_dbg("command: %s\n", str);
		ret = run_command(str, 0);
		if (ret != 0) {
			store_msg("amlmmc cmd %s failed \n",cmd);
			return -1;
		}
		return ret;
	}
	else if(device_boot_flag==EMMC_BOOT_FLAG){
		store_dbg("MMC BOOT, %s %d \n",__func__,__LINE__);
		sprintf(str, "amlmmc  write %s 0x%llx  0x%llx  0x%llx", s, addr, off, size);
		store_dbg("command: %s\n", str);
		ret = run_command(str, 0);
		if (ret != 0) {
			store_msg("amlmmc cmd %s failed \n",cmd);
			return -1;
		}
		return ret;
	}else{
		store_dbg("CARD BOOT, %s %d ",__func__,__LINE__);
		return CMD_RET_FAILURE;
	}
	return ret;
}

static cmd_tbl_t cmd_store_sub[] = {
	U_BOOT_CMD_MKENT(init,          4, 0, do_store_init, "", ""),
	U_BOOT_CMD_MKENT(exit,          3, 0, do_store_exit, "", ""),
	U_BOOT_CMD_MKENT(disprotect,    3, 0, do_store_disprotect, "", ""),
	U_BOOT_CMD_MKENT(rom_protect,   5, 0, do_store_rom_protect, "", ""),
	U_BOOT_CMD_MKENT(size,          5, 0, do_store_size, "", ""),
	U_BOOT_CMD_MKENT(scrub,         3, 0, do_store_scrub, "", ""),
	U_BOOT_CMD_MKENT(erase,         5, 0, do_store_erase, "", ""),
	U_BOOT_CMD_MKENT(read,          7, 0, do_store_read, "", ""),
	U_BOOT_CMD_MKENT(write,         7, 0, do_store_write, "", ""),
	U_BOOT_CMD_MKENT(rom_read,      5, 0, do_store_rom_read, "", ""),
	U_BOOT_CMD_MKENT(rom_write,     5, 0, do_store_rom_write, "", ""),
	U_BOOT_CMD_MKENT(dtb,           5, 0, do_store_dtb_ops, "", ""),
	U_BOOT_CMD_MKENT(key,           5, 0, do_store_key_ops, "", ""),
	U_BOOT_CMD_MKENT(ddr_parameter, 5, 0, do_store_ddr_parameter_ops, "", ""),
	U_BOOT_CMD_MKENT(mbr,           3, 0, do_store_mbr_ops, "", ""),
};

static int do_store(cmd_tbl_t * cmdtp, int flag, int argc, char * const argv[])
{
	cmd_tbl_t *c;

	if (argc < 2) return CMD_RET_USAGE;
	c = find_cmd_tbl(argv[1], cmd_store_sub, ARRAY_SIZE(cmd_store_sub));
	if (c)
		return	c->cmd(cmdtp, flag, argc, argv);

	return CMD_RET_USAGE;
}

U_BOOT_CMD(store, CONFIG_SYS_MAXARGS, 1, do_store,
	"STORE sub-system",
	"init flag\n"
	"store read name addr off|partition size\n"
	"    read 'size' bytes starting at offset 'off'\n"
	"    to/from memory address 'addr', skipping bad blocks.\n"
	"store write name addr off|partition size\n"
	"    write 'size' bytes starting at offset 'off'\n"
	"    to/from memory address 'addr', skipping bad blocks.\n"
	"store rom_write add off size.\n"
	"	write uboot to the boot device\n"
	"store erase boot/data: \n"
	"	erase the area which is uboot or data \n"
	"store erase partition <partition_name>: \n"
	"	erase the area which partition in u-boot \n"
	"store erase dtb \n"
	"store erase key \n"
	"store disprotect key \n"
	"store rom_protect on/off \n"
	"store scrub off|partition size\n"
	"	scrub the area from offset and size \n"
	"store dtb iread/read/write addr <size>\n"
	"	read/write dtb, size is optional \n"
	"store key read/write addr <size>\n"
	"	read/write key, size is optional \n"
	"store ddr_parameter read/write addr <size>\n"
	"	read/write ddr parameter, size is optional \n"
	"store mbr addr\n"
	"   update mbr/partition table by dtb\n"
);

