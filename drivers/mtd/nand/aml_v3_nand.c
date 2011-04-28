// linux/drivers/amlogic/nand/aml_nand.c

//#define  CONFIG_AM_NAND_RBPIN	1

#include <common.h>
#include <nand.h>
#include <asm/io.h>
#include <asm/arch/nand.h>
#include <malloc.h>
#include <linux/err.h>
#include <asm/cache.h>
#include <asm/arch/pinmux.h>
#include <asm/arch/clock.h>

#include <linux/mtd/mtd.h>
#include <linux/mtd/nand.h>
#include <linux/mtd/nand_ecc.h>

#define NAND_DEBUG

#ifdef NAND_DEBUG

#define aml_nand_debug(a...) {printk("%s()[%s,%d]",__func__,__FILE__,__LINE__); printk(a);}
#define aml_nand_debug2(a...)   //{printk(a);}
#else
#define aml_nand_debug(a...) 
#define aml_nand_debug2(a...) 
#endif
#define BUG_printk(a...)     {printk(a);BUG();}

static char *aml_nand_plane_string[]={
	"NAND_SINGLE_PLANE_MODE",
	"NAND_TWO_PLANE_MODE",
};

static char *aml_nand_internal_string[]={
	"NAND_NONE_INTERLEAVING_MODE",
	"NAND_INTERLEAVING_MODE",
};

static struct nand_ecclayout aml_nand_oob_64 = {
	.eccbytes = 60,
	.eccpos = {
		   4, 5, 6, 7, 8, 9, 10, 11,
		   12, 13, 14, 15, 16, 17, 18, 19,
		   20, 21, 22, 23, 24, 25, 26, 27,
		   28, 29, 30, 31, 32, 33, 34, 35,
		   36, 37, 38, 39, 40, 41, 42, 43,
		   44, 45, 46, 47, 48, 49, 50, 51,
		   52, 53, 54, 55, 56, 57, 58, 59,
		   60, 61, 62, 63},
	.oobfree = {
		{.offset = 0,
		 .length = 4}}
};

static struct nand_ecclayout aml_nand_uboot_oob = {
	.eccbytes = 84,
	.oobfree = {
		{.offset = 0,
		 .length = 6}}
};

static struct nand_ecclayout aml_nand_oob_64_2info = {
	.eccbytes = 56,
	.oobfree = {
		{.offset = 0,
		 .length = 8}}
};

static struct nand_ecclayout aml_nand_oob_128 = {
	.eccbytes = 120,
	.oobfree = {
		{.offset = 0,
		 .length = 8}}
};

static struct nand_ecclayout aml_nand_oob_218 = {
	.eccbytes = 200,
	.oobfree = {
		{.offset = 0,
		 .length = 8}}
};

static struct nand_ecclayout aml_nand_oob_224 = {
	.eccbytes = 208,
	.oobfree = {
		{.offset = 0,
		 .length = 8}}
};

static struct nand_ecclayout aml_nand_oob_256 = {
	.eccbytes = 240,
	.oobfree = {
		{.offset = 0,
		 .length = 8}}
};

static struct nand_ecclayout aml_nand_oob_376 = {
	.eccbytes = 352,
	.oobfree = {
		{.offset = 0,
		 .length = 8}}
};

static struct nand_ecclayout aml_nand_oob_436 = {
	.eccbytes = 352,
	.oobfree = {
		{.offset = 0,
		 .length = 8}}
};

static struct nand_ecclayout aml_nand_oob_448 = {
	.eccbytes = 416,
	.oobfree = {
		{.offset = 0,
		 .length = 8*2}}
};

static struct nand_ecclayout aml_nand_oob_752 = {
	.eccbytes = 704,
	.oobfree = {
		{.offset = 0,
		 .length = 8}}
};

static struct nand_ecclayout aml_nand_oob_872 = {
	.eccbytes = 704,
	.oobfree = {
		{.offset = 0,
		 .length = 8}}
};

static struct nand_ecclayout aml_nand_oob_896 = {
	.eccbytes = 832,
	.oobfree = {
		{.offset = 0,
		 .length = 8}}
};

static struct nand_ecclayout aml_nand_oob_1024 = {
	.eccbytes = 832,
	.oobfree = {
		{.offset = 0,
		 .length = 8}}
};

static struct nand_ecclayout aml_nand_oob_1504 = {
	.eccbytes = 1408,
	.oobfree = {
		{.offset = 0,
		 .length = 8}}
};

static struct nand_ecclayout aml_nand_oob_1744 = {
	.eccbytes = 1664,
	.oobfree = {
		{.offset = 0,
		 .length = 8}}
};

static struct nand_ecclayout aml_nand_oob_1792 = {
	.eccbytes = 1664,
	.oobfree = {
		{.offset = 0,
		 .length = 8}}
};

static struct nand_ecclayout aml_nand_oob_3008 = {
	.eccbytes = 2816,
	.oobfree = {
		{.offset = 0,
		 .length = 8}}
};

static struct nand_ecclayout aml_nand_oob_3584 = {
	.eccbytes = 3328,
	.oobfree = {
		{.offset = 0,
		 .length = 8}}
};

static uint8_t nand_mode_time[6] = {9, 7, 6, 5, 5, 4};

struct aml_nand_flash_dev aml_nand_flash_ids[] = {

	{"A revision NAND 2GiB H27UAG8T2A",	{NAND_MFR_HYNIX, 0xd5, 0x94, 0x25, 0x44, 0x41}, 4096, 2048, 0x80000, 224, 1, (NAND_TIMING_MODE5 | NAND_ECC_BCH30_MODE | NAND_TWO_PLANE_MODE)},
	{"A revision NAND 4GiB H27UBG8T2A",	{NAND_MFR_HYNIX, 0xd7, 0x94, 0x25, 0x44, 0x41}, 4096, 4096, 0x80000, 224, 1, (NAND_TIMING_MODE5 | NAND_ECC_BCH30_MODE | NAND_TWO_PLANE_MODE)},
	{"B revision NAND 2GiB H27UAG8T2B",	{NAND_MFR_HYNIX, 0xd5, 0x94, 0x9a, 0x74, 0x42}, 8192, 2048, 0x200000, 448, 1, (NAND_TIMING_MODE5 | NAND_ECC_BCH30_MODE | NAND_TWO_PLANE_MODE)},
	{"B revision NAND 4GiB H27UBG8T2A",	{NAND_MFR_HYNIX, 0xd7, 0x94, 0x9a, 0x74, 0x42}, 8192, 4096, 0x200000, 448, 1, (NAND_TIMING_MODE5 | NAND_ECC_BCH30_MODE | NAND_TWO_PLANE_MODE)},

	{"A revision NAND 4GiB MT29F32G-A", {NAND_MFR_MICRON, 0xd7, 0x94, 0x3e, 0x84}, 4096, 4096, 0x80000, 218, 1, (NAND_TIMING_MODE5 | NAND_ECC_BCH24_MODE | NAND_TWO_PLANE_MODE)},
	{"A revision NAND 16GiB MT29F128G-A", {NAND_MFR_MICRON, 0xd9, 0xd5, 0x3e, 0x88}, 4096, 16384, 0x80000, 218, 1, (NAND_TIMING_MODE5 | NAND_ECC_BCH24_MODE | NAND_TWO_PLANE_MODE)},
	{"B revision NAND 4GiB MT29F32G-B", {NAND_MFR_MICRON, 0x68, 0x04, 0x46, 0x89}, 4096, 4096, 0x100000, 224, 1, (NAND_TIMING_MODE5 | NAND_ECC_BCH30_MODE | NAND_TWO_PLANE_MODE)},
	{"B revision NAND 16GiB MT29F128G-B", {NAND_MFR_MICRON, 0x88, 0x05, 0xc6, 0x89}, 4096, 16384, 0x100000, 224, 1, (NAND_TIMING_MODE5 | NAND_ECC_BCH30_MODE | NAND_TWO_PLANE_MODE)},
	{"C revision NAND 4GiB MT29F32G-C", {NAND_MFR_MICRON, 0x68, 0x04, 0x4a, 0xa9}, 4096, 4096, 0x100000, 224, 1, (NAND_TIMING_MODE5 | NAND_ECC_BCH30_MODE | NAND_TWO_PLANE_MODE)},
	{"4GiB MT29F32G08QAA", {NAND_MFR_MICRON, 0xd5, 0x94, 0x3e, 0x74}, 4096, 4096, 0x100000, 224, 1, (NAND_SYNCIF|NAND_TIMING_MODE5 | NAND_ECC_BCH30_MODE | NAND_TWO_PLANE_MODE )},
	{"C revision NAND 8GiB MT29F64G-C", {NAND_MFR_MICRON, 0x88, 0x04, 0x4b, 0xa9}, 8192, 8192, 0x200000, 448, 1, (NAND_TIMING_MODE5 | NAND_ECC_BCH30_MODE | NAND_TWO_PLANE_MODE)},
	{"C revision NAND 32GiB MT29F256G-C", {NAND_MFR_MICRON, 0xa8, 0x05, 0xcb, 0xa9}, 8192, 32768, 0x200000, 448, 2, (NAND_TIMING_MODE5 | NAND_ECC_BCH30_MODE | NAND_TWO_PLANE_MODE | NAND_INTERLEAVING_MODE)},

	{"E serials NAND 2GiB TC58NVG4D2ETA00", {NAND_MFR_TOSHIBA, 0xD5, 0x94, 0x32, 0x76, 0x54}, 8192, 2048, 0x100000, 376, 1, (NAND_TIMING_MODE5 | NAND_ECC_BCH24_MODE | NAND_TWO_PLANE_MODE)},
	{"E serials NAND 4GiB TC58NVG5D2ETA00", {NAND_MFR_TOSHIBA, 0xD7, 0x94, 0x32, 0x76, 0x54}, 8192, 4096, 0x100000, 376, 1, (NAND_TIMING_MODE5 | NAND_ECC_BCH24_MODE | NAND_TWO_PLANE_MODE)},
	{"F serials NAND 4GiB TC58NVG5D2FTA00", {NAND_MFR_TOSHIBA, 0xD7, 0x94, 0x32, 0x76, 0x55}, 8192, 4096, 0x100000, 448, 1, (NAND_TIMING_MODE5 | NAND_ECC_BCH30_MODE | NAND_TWO_PLANE_MODE)},
	{"Toggle Mode NAND 4GiB TC58NVG5D2HTA00", {NAND_MFR_TOSHIBA,  0xd7, 0x94, 0x32, 0x76,0x56}, 8192, 4096, 0x100000, 640, 2, (NAND_TIMING_MODE5 | NAND_ECC_BCH30_MODE | NAND_TWO_PLANE_MODE|NAND_INTERLEAVING_MODE)},
	{"F serials NAND 8GiB TC58NVG6D2FTA00", {NAND_MFR_TOSHIBA, 0xDE, 0x94, 0x32, 0x76, 0x55}, 8192, 8192, 0x100000, 448, 1, (NAND_TIMING_MODE5 | NAND_ECC_BCH30_MODE | NAND_TWO_PLANE_MODE)},

	{"M Generation NAND 2GiB K9GAG08U0M", {NAND_MFR_SAMSUNG, 0xD5, 0x14, 0xb6, 0x74}, 4096, 2048, 0x80000, 128, 1, (NAND_TIMING_MODE5 | NAND_ECC_BCH8_512_MODE)},
	{"5 Generation NAND 2GiB K9GAG08X0D", {NAND_MFR_SAMSUNG, 0xD5, 0x94, 0x29, 0x34, 0x41}, 4096, 2048, 0x80000, 218, 1, (NAND_TIMING_MODE5 | NAND_ECC_BCH24_MODE | NAND_TWO_PLANE_MODE)},
	{"6 Generation NAND 2GiB K9GAG08U0E", {NAND_MFR_SAMSUNG, 0xD5, 0x84, 0x72, 0x50, 0x42}, 8192, 2048, 0x100000, 436, 1, (NAND_TIMING_MODE5 | NAND_ECC_BCH24_MODE)},
	{"6 Generation NAND 4GiB K9LBG08U0E", {NAND_MFR_SAMSUNG, 0xD7, 0xC5, 0x72, 0x54, 0x42}, 8192, 4096, 0x100000, 436, 1, (NAND_TIMING_MODE5 | NAND_ECC_BCH24_MODE | NAND_TWO_PLANE_MODE)},
	{"6 Generation NAND 8GiB K9HCG08U0E", {NAND_MFR_SAMSUNG, 0xDE, 0xC5, 0x72, 0x54, 0x42}, 8192, 8192, 0x100000, 436, 1, (NAND_TIMING_MODE5 | NAND_ECC_BCH24_MODE | NAND_TWO_PLANE_MODE)},
	{"2 Generation NAND 4GiB K9GBG08U0A", {NAND_MFR_SAMSUNG, 0xD7, 0x94, 0x7a, 0x54, 0x43}, 8192, 4152, 0x100000, 640, 1, (NAND_TIMING_MODE5 | NAND_ECC_BCH40_MODE | NAND_TWO_PLANE_MODE)},
	{"B-die Toggle NAND  4GiB K9GBG08U0B", {NAND_MFR_SAMSUNG, 0xec, 0xD7, 0x94, 0x7a, 0x54}, 8192, 4096, 0x100000, 1024, 1, (NAND_SYNCIF|NAND_TIMING_MODE5 | NAND_ECC_BCH40_MODE | NAND_TWO_PLANE_MODE)},
//	{"B-die Toggle NAND  4GiB K9GBG08U0A", {NAND_MFR_SAMSUNG, 0xD7, 0x94, 0x76, 0x64,0x43 }, 8192, 4096, 0x100000, 1024, 1, (NAND_SYNCIF|NAND_TIMING_MODE5 | NAND_ECC_BCH40_MODE | NAND_TWO_PLANE_MODE)},
	{"2 Generation NAND 8GiB K9LCG08U0A", {NAND_MFR_SAMSUNG, 0xDE, 0xD5, 0x7a, 0x58, 0x43}, 8192, 8304, 0x100000, 640, 2, (NAND_TIMING_MODE5 | NAND_ECC_BCH40_MODE | NAND_TWO_PLANE_MODE | NAND_INTERLEAVING_MODE)},

	{NULL,}
};

static void aml_nand_cmdfunc(struct mtd_info *mtd, unsigned command, int column, int page_addr);


static void aml_platform_hw_init(struct aml_nand_chip *aml_chip)
{
	//struct mtd_info *mtd = aml_chip->mtd;
	//struct nand_chip *chip = &aml_chip->chip;
	struct aml_nand_platform *plat = aml_chip->platform;
	//struct clk *sys_clk;
	unsigned sys_clk_rate, sys_time, start_cycle, end_cycle, bus_cycle, time_mode, tmp;

	if (!plat->T_REA)
		plat->T_REA = 20;
	if (!plat->T_RHOH)
		plat->T_RHOH = 15;

	time_mode = ((plat->platform_nand_data.chip.options & NAND_TIMING_OPTIONS_MASK) >> 8);
	if (time_mode > 5)
		time_mode = 5;

	sys_clk_rate = get_clk81();
	sys_time = (10000 / (sys_clk_rate / 1000000));		//50,55
	bus_cycle = nand_mode_time[time_mode];				//mode=5, bus_c=4;
	
	tmp=300/sys_time;
	if(300%sys_time)
		tmp++;
	
	if(bus_cycle<tmp)
		bus_cycle=tmp;	

	start_cycle = ((NAND_CYCLE_DELAY + plat->T_REA * 10) / sys_time);
	if(((NAND_CYCLE_DELAY + plat->T_REA * 10)%sys_time))
		start_cycle++;

	end_cycle = ((NAND_CYCLE_DELAY + (bus_cycle*sys_time)/2 + plat->T_RHOH * 10) / sys_time);



	/*if (bus_cycle < start_cycle)
		adjust = start_cycle - bus_cycle;
	else if(bus_cycle > end_cycle) {
		if (bus_cycle > 6)
			bus_cycle = 6;
		adjust = ((((~(bus_cycle - start_cycle) + 1)) & 0xf) | 0x8);
	}
	else
		adjust = 0;*/

	bus_cycle -= 1;
	tmp=(start_cycle+end_cycle)/2;
	NFC_SET_CFG(0);
	NFC_SET_TIMING_ASYC(tmp, bus_cycle);
	NFC_SEND_CMD(1<<31);
	printk("time_mode=%d, bus_cycle=%d, tREA=%d, tRHOH=%d, bus_tim=%x system=%d\n",
		time_mode, bus_cycle, plat->T_REA, plat->T_RHOH, tmp, (sys_time/10));
}

static int aml_platform_options_confirm(struct aml_nand_chip *aml_chip)
{
	struct mtd_info *mtd = aml_chip->mtd;
	struct nand_chip *chip = &aml_chip->chip;
	struct aml_nand_platform *plat = aml_chip->platform;
	struct ecc_desc_s * ecc_supports=aml_chip->ecc;
	unsigned max_ecc=aml_chip->max_ecc;
	
	unsigned options_selected = 0, options_support = 0, ecc_bytes, options_define;
	int error = 0,i;


//ecc check 
	options_selected = (plat->platform_nand_data.chip.options & NAND_ECC_OPTIONS_MASK);
	options_define = (aml_chip->options & NAND_ECC_OPTIONS_MASK);
    aml_nand_debug("options_selected=%s options_define=%s\n",
       ecc_supports[options_selected].name,ecc_supports[options_define].name);
    ///caculate the chips support ECC
    for(i=max_ecc-1;i>0;i--)//0 always is raw mode 
    {
        ecc_bytes = aml_chip->oob_size / (aml_chip->page_size / ecc_supports[i].size);
        if(ecc_bytes>=ecc_supports[i].parity+ecc_supports[i].user)
        {
            options_support=ecc_supports[i].bch;
            break;
        }
    }
    if(options_support==0)
        BUG_printk("Could NOT Find out support ecc");
    aml_nand_debug("This one can support %s\n",ecc_supports[options_support].name);

#if 0       
ecc_unit_change:
	ecc_bytes = aml_chip->oob_size / (aml_chip->page_size / chip->ecc.size);
	
	if (chip->ecc.size == NAND_ECC_UNIT_1KSIZE) 
	{
		if (ecc_bytes >= (NAND_BCH60_ECC_SIZE + 2))
			options_support = NAND_ECC_BCH60_MODE;
		else 
		{
			aml_nand_debug(" aml_chip->page_size %d   chip->ecc.size  %d , div res \n",
			    aml_chip->page_size,chip->ecc.size);
			aml_nand_debug("oob_size %d ecc_bytes %d\n",aml_chip->oob_size,ecc_bytes);
			aml_nand_debug("oob size is not enough for 1K UNIT ECC mode: "
			    "%d try 512 UNIT ECC\n", aml_chip->oob_size);
		
			chip->ecc.size = NAND_ECC_UNIT_SIZE;
			goto ecc_unit_change;
		}	
	}
	else {
		/*if (ecc_bytes >= (NAND_BCH16_ECC_SIZE + 2))
			options_support = NAND_ECC_BCH16_MODE;
		else if (ecc_bytes >= (NAND_BCH12_ECC_SIZE + 2))
			options_support = NAND_ECC_BCH12_MODE;
		else*/ 
        if (ecc_bytes >= (NAND_BCH8_512_ECC_SIZE + 2))
			options_support = NAND_ECC_BCH8_512_MODE;
		else {
			options_support = NAND_ECC_SOFT_MODE;
			aml_nand_debug("page size: %d oob size %d is not enough for HW ECC\n", aml_chip->page_size, aml_chip->oob_size);
		}
	}
#endif	
	if (options_define != options_support) {
		options_define = options_support;
		aml_nand_debug("define oob size: %d could support bch mode: %s\n", aml_chip->oob_size, ecc_supports[options_support].name);
	}

	if ((options_selected > options_define) && (strncmp((char*)plat->name, NAND_BOOT_NAME, strlen((const char*)NAND_BOOT_NAME)))) {
		aml_nand_debug("oob size is not enough for selected bch mode: %s force bch to mode: %s\n", 
		    ecc_supports[options_selected].name,ecc_supports[options_define].name);
		options_selected = options_define;
		//BUG_printk("Wrong NAND option, Please Check Your setting and confirm it with U Boot");
	}

	switch (options_selected) {

		case NAND_ECC_BCH8_512_MODE:
			chip->ecc.size = NAND_ECC_UNIT_SIZE;				//our hardware ecc unit is 512bytes
			chip->ecc.bytes = NAND_BCH8_512_ECC_SIZE;
			aml_chip->bch_mode = NAND_ECC_BCH8_512;
			aml_chip->user_byte_mode = 2;
			break;

		case NAND_ECC_BCH8_1K_MODE:
			chip->ecc.size = NAND_ECC_UNIT_1KSIZE;
			chip->ecc.bytes = NAND_BCH8_1K_ECC_SIZE;
			aml_chip->bch_mode = NAND_ECC_BCH8_1K;
			aml_chip->user_byte_mode = 2;
			break;

		case NAND_ECC_BCH30_MODE:
			chip->ecc.size = NAND_ECC_UNIT_1KSIZE;
			chip->ecc.bytes = NAND_BCH30_ECC_SIZE;
			aml_chip->bch_mode = NAND_ECC_BCH30;
			aml_chip->user_byte_mode = 2;
			break;
		case NAND_ECC_BCH40_MODE:
			chip->ecc.size = NAND_ECC_UNIT_1KSIZE;
			chip->ecc.bytes = NAND_BCH40_ECC_SIZE;
			aml_chip->bch_mode = NAND_ECC_BCH40;
			aml_chip->user_byte_mode = 2;
			break;
		case NAND_ECC_BCH60_MODE:
			chip->ecc.size = NAND_ECC_UNIT_1KSIZE;
			chip->ecc.bytes = NAND_BCH60_ECC_SIZE;
			aml_chip->bch_mode = NAND_ECC_BCH60;
			aml_chip->user_byte_mode = 2;
			break;
		case NAND_ECC_SHORT_MODE:
			chip->ecc.size = NAND_ECC_UNIT_SHORT;
			chip->ecc.bytes = NAND_BCH60_ECC_SIZE;
			aml_chip->bch_mode = NAND_ECC_BCH60;
			aml_chip->user_byte_mode = 2;
			break;
		case NAND_ECC_BCH16_MODE:
			chip->ecc.size = NAND_ECC_UNIT_1KSIZE;
			chip->ecc.bytes = NAND_BCH16_ECC_SIZE;
			aml_chip->bch_mode = NAND_ECC_BCH16;
			aml_chip->user_byte_mode = 2;
			break;

		case NAND_ECC_BCH24_MODE:
			chip->ecc.size = NAND_ECC_UNIT_1KSIZE;
			chip->ecc.bytes = NAND_BCH24_ECC_SIZE;
			aml_chip->bch_mode = NAND_ECC_BCH24;
			aml_chip->user_byte_mode = 2;
			break;

		default :
			if ((plat->platform_nand_data.chip.options & NAND_ECC_OPTIONS_MASK) != NAND_ECC_SOFT_MODE) {
				aml_nand_debug("soft ecc or none ecc just support in linux self nand base please selected it at platform options\n");
				error = -ENXIO;
			}
			break;
	}

//plane check 
	options_selected = (plat->platform_nand_data.chip.options & NAND_PLANE_OPTIONS_MASK);
	options_define = (aml_chip->options & NAND_PLANE_OPTIONS_MASK);
	if (options_selected > options_define) {
		aml_nand_debug("multi plane error for selected plane mode: %s force plane to : %s\n", aml_nand_plane_string[options_selected >> 4], aml_nand_plane_string[options_define >> 4]);
		options_selected = options_define;
	}

	switch (options_selected) {

		case NAND_TWO_PLANE_MODE:
			aml_chip->plane_num = 2;
			mtd->erasesize *= 2;
			mtd->writesize *= 2;
			mtd->oobsize *= 2;

			chip->page_shift = ffs(mtd->writesize) - 1;
			chip->pagemask = (chip->chipsize >> chip->page_shift) - 1;			
			chip->bbt_erase_shift = chip->phys_erase_shift = ffs(mtd->erasesize) - 1;
			printk("enter NAND_TWO_PLANE_MODE : erasesize= 0x%x,writesize= 0x%x,oobsize= 0x%x\n", 
					mtd->erasesize,mtd->writesize,mtd->oobsize);

			break;

		default:
			aml_chip->plane_num = 1;
			break;
	}
//interleave check 
	options_selected = (plat->platform_nand_data.chip.options & NAND_INTERLEAVING_OPTIONS_MASK);
	options_define = (aml_chip->options & NAND_INTERLEAVING_OPTIONS_MASK);
	if (options_selected > options_define) {
		aml_nand_debug("internal mode error for selected internal mode: %s force internal mode to : %s\n", aml_nand_internal_string[options_selected >> 16], aml_nand_internal_string[options_define >> 16]);
		options_selected = options_define;
	}

	switch (options_selected) {

		case NAND_INTERLEAVING_MODE:
			aml_chip->ops_mode |= AML_INTERLEAVING_MODE;
			mtd->erasesize *= aml_chip->internal_chipnr;
			mtd->writesize *= aml_chip->internal_chipnr;
			mtd->oobsize *= aml_chip->internal_chipnr;
			break;

		default:		
			break;
	}

	return error;
}

static void aml_platform_cmd_ctrl(struct aml_nand_chip *aml_chip, int cmd,  unsigned int ctrl)
{
	if (cmd == NAND_CMD_NONE)
		return;

	if (ctrl & NAND_CLE)
		cmd=NFC_CMD_CLE(aml_chip->chip_selected, cmd);
	else
		cmd=NFC_CMD_ALE(aml_chip->chip_selected, cmd);

    NFC_SEND_CMD(cmd);
}

static void aml_platform_select_chip(struct aml_nand_chip *aml_chip, int chipnr)
{
	//int i;

	switch (chipnr) {
		case 0:
		case 1:
		case 2:
		case 3:
			aml_chip->chip_selected = aml_chip->chip_enable[chipnr];
			aml_chip->rb_received = aml_chip->rb_enable[chipnr];

			/*for (i=1; i<aml_chip->chip_num; i++) {

				if (aml_chip->valid_chip[i]) {

					if (!((aml_chip->chip_enable[i] >> 10) & 1))
						SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_6, (1 << 4));
					if (!((aml_chip->chip_enable[i] >> 10) & 2))
						SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_6, (1 << 3));
					if (!((aml_chip->chip_enable[i] >> 10) & 4))
						SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_6, (1 << 14));
					if (!((aml_chip->chip_enable[i] >> 10) & 8))
						SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_6, (1 << 13));

					if (!((aml_chip->rb_enable[i] >> 10) & 1))
						SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_6, (1 << 2));
					if (!((aml_chip->rb_enable[i] >> 10) & 2))
						SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_6, (1 << 1));
					if (!((aml_chip->rb_enable[i] >> 10) & 4))
						SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_6, (1 << 12));
					if (!((aml_chip->rb_enable[i] >> 10) & 8))
						SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_6, (1 << 11));
				}
			}*/

			NFC_SEND_CMD_IDLE(aml_chip->chip_selected, 0);

			break;

		default:
			BUG();
			aml_chip->chip_selected = CE_NOT_SEL;
			break;
	}
	return;
}

static void aml_platform_write_byte(struct aml_nand_chip *aml_chip, uint8_t data)
{
#if  0
	NFC_SEND_CMD(aml_chip->chip_selected | IDLE | 5);
	NFC_SEND_CMD(aml_chip->chip_selected | DWR | data);
	NFC_SEND_CMD(aml_chip->chip_selected | IDLE | 5);
	while(NFC_CMDFIFO_SIZE()>0);
//	while (!(NFC_INFO_GET()&(1<<26)));
	return;
#endif

//		writeb(buf ,aml_chip->IO_ADDR_R);
		NFC_SEND_CMD(aml_chip->chip_selected | IDLE | 5);
		if(aml_chip->ops_mode&AML_SYNC_MODE)
			NFC_SEND_CMD(aml_chip->chip_selected | DWR_SYNC | (data&0xff));
		else
			NFC_SEND_CMD(aml_chip->chip_selected | DWR | (data&0xff));
		while(NFC_CMDFIFO_SIZE()>0);	
}


/*ADD RBPIN NO mode*/
static int aml_platform_wait_devready(struct aml_nand_chip *aml_chip, int chipnr)
{	
#if   CONFIG_AM_NAND_RBPIN
	int status;
	unsigned time_out_cnt = 0;
	struct mtd_info *mtd = aml_chip->mtd;
	struct nand_chip *chip = &aml_chip->chip;
	/* wait until command is processed or timeout occures */
	aml_chip->aml_nand_select_chip(aml_chip, chipnr);
	do {
		if (aml_chip->ops_mode == AML_MULTI_CHIP_SHARE_RB) {
			aml_chip->aml_nand_command(aml_chip, NAND_CMD_STATUS, -1, -1, chipnr);
			status = (int)chip->read_byte(mtd);
			if (status & NAND_STATUS_READY)
				break;
		}
		else {
			if (chip->dev_ready) {
				if (chip->dev_ready(mtd))
					break;
			} else {

//   			    if(chip->waitfunc(mtd, chip)& NAND_STATUS_READY)
//							break;  			    
				if (chip->read_byte(mtd) & NAND_STATUS_READY)
					break;
			}
		}

	} while (time_out_cnt++ <= AML_NAND_BUSY_TIMEOUT);

	if (time_out_cnt > AML_NAND_BUSY_TIMEOUT)
		return 0;
#else
//	aml_chip->aml_nand_select_chip(aml_chip, chipnr);
//	aml_chip->aml_nand_command(aml_chip, NAND_CMD_STATUS, -1, -1, chipnr);
//	NFC_SEND_CMD_RBIO(IO6, 10);

#if 0
		while (time_out_cnt++ < 0x10000) {
			status = (int)chip->read_byte(mtd);
			if ((NAND_STATUS_READY|NAND_STATUS_TRUE_READY) ==status& (NAND_STATUS_READY|NAND_STATUS_TRUE_READY))
				break;
			udelay(9);
		}
		

	int 	state = chip->state;
	if( time_out_cnt >0x10000)	
	{
		aml_nand_debug("NAND_CMD_STATUS time out !\n");
		if(state ==FL_READING)	{
			aml_nand_debug("--FL_READING fail !\n");
		}
		if(state ==FL_ERASING)	{
			aml_nand_debug("--FL_ERASING fail !\n");
		}
		else if(state ==FL_WRITING )	{
			aml_nand_debug("--FL_WRITING fail !\n");		
		}
	}
	else
	{
		if(status &(NAND_STATUS_FAIL|NAND_STATUS_FAIL_N1))
		{
			if(state ==FL_ERASING)	{
				aml_nand_debug("FL_ERASING fail !\n");
			}
			else if(state ==FL_WRITING )	{
				aml_nand_debug("FL_WRITING fail !\n");		
			}
		}
	}

	return status;	
#endif
#endif

	return 1;
}

static void aml_platform_get_user_byte(struct aml_nand_chip *aml_chip, unsigned char *oob_buf, int byte_num)
{
	int read_times = 0;
	unsigned int len=PER_INFO_BYTE/sizeof(unsigned int);

	aml_nand_debug2("\nrd oob: ");
	while (byte_num > 0) {
		*oob_buf++ = (aml_chip->user_info_buf[read_times*len] & 0xff);
		byte_num--;
		aml_nand_debug2("0x%02x ",oob_buf[-1]);
		if (aml_chip->user_byte_mode == 2) {
			*oob_buf++ = ((aml_chip->user_info_buf[read_times*len] >> 8) & 0xff);
			byte_num--;
			aml_nand_debug2("0x%02x ",oob_buf[-1]);
		}
		read_times++;   //8 bytes now 
	}
}

static void aml_platform_set_user_byte(struct aml_nand_chip *aml_chip, unsigned char *oob_buf, int byte_num)
{
	int write_times = 0;
	unsigned int len=PER_INFO_BYTE/sizeof(unsigned int);

	aml_nand_debug2("\nwr oob: ");
	while (byte_num > 0) {
		aml_chip->user_info_buf[write_times*len] = *oob_buf++;
		byte_num--;
		aml_nand_debug2("0x%02x ",oob_buf[-1]);
		if (aml_chip->user_byte_mode == 2) {
			aml_chip->user_info_buf[write_times*len] |= (*oob_buf++ << 8);
			byte_num--;
			aml_nand_debug2("0x%02x ",oob_buf[-1]);
		}
		write_times++;   //8 bytes now 
	}
}

#if  1
#define Tdbsy  500  //500ns
#define Tbers  3  //3ms
#define Tprog   900   //900us
#define Tr   50   //<=50us
#else
#define Tdbsy  0  //500ns
#define Tbers  0  //3ms
#define Tprog   0   //900us
#define Tr   0   //<=50us
#endif
static void aml_nand_base_command(struct aml_nand_chip *aml_chip, unsigned command, int column, int page_addr, int chipnr)
{
	struct nand_chip *chip = &aml_chip->chip;
	struct mtd_info *mtd = aml_chip->mtd;
	unsigned command_temp, pages_per_blk_shift, plane_page_addr = 0, plane_blk_addr = 0;
	pages_per_blk_shift = (chip->phys_erase_shift - chip->page_shift);

	if (page_addr != -1) {
//		printk("page_addr = 0x%x\n",page_addr);
//		page_addr /= aml_chip->plane_num;
		plane_page_addr = page_addr &( (1 << pages_per_blk_shift ) -1);
		plane_blk_addr = page_addr >> pages_per_blk_shift;   
		plane_blk_addr <<=1;  //block  No  in plane 0.(PB block No..)
	}

	if (aml_chip->plane_num == 2) {

		switch (command) {

			case NAND_CMD_READ0:
				if (aml_chip->mfr_type == NAND_MFR_MICRON) {
					command_temp = command;
				}
				else {
					command_temp = NAND_CMD_TWOPLANE_PREVIOS_READ;
					column = -1;
				}
//				printk("plane_blk_addr = 0x%x,plane_page_addr=0x0%x\n",plane_blk_addr,plane_page_addr);
				plane_page_addr |= (plane_blk_addr << pages_per_blk_shift);
//				printk("read x0:plane_page_addr =0x0%x\n",plane_page_addr);
				break;

			case NAND_CMD_TWOPLANE_READ1:
				command_temp = NAND_CMD_READ0;
#if 0
				if (aml_chip->mfr_type == NAND_MFR_MICRON)
					//plane_page_addr |= ((plane_blk_addr + 1) << 8);
					return;
				else
#else
				if (aml_chip->mfr_type == NAND_MFR_MICRON) {
					command_temp =NAND_CMD_PLANE2_READ_START;
				}
#endif				
					plane_page_addr |= (plane_blk_addr << pages_per_blk_shift);
//					printk("read x00:plane_page_addr =0x0%x\n",plane_page_addr);
				break;

			case NAND_CMD_TWOPLANE_READ2:
				if (aml_chip->mfr_type == NAND_MFR_MICRON) {
					command_temp =NAND_CMD_PLANE2_READ_START;
				}
				else 
				{
					command_temp = NAND_CMD_READ0;
				}
				plane_page_addr |= ((plane_blk_addr + 1) << pages_per_blk_shift);
//				printk("read y11:plane_page_addr =0x0%x\n",plane_page_addr);
				break;

			case NAND_CMD_SEQIN:
				command_temp = command;
				plane_page_addr |= (plane_blk_addr << pages_per_blk_shift);
//				printk("write x0:plane_page_addr =0x0%x\n",plane_page_addr);				
				break;

			case NAND_CMD_TWOPLANE_WRITE2:
				if ((aml_chip->mfr_type == NAND_MFR_HYNIX) || (aml_chip->mfr_type == NAND_MFR_SAMSUNG))
					command_temp = command;
				else
					command_temp = NAND_CMD_TWOPLANE_WRITE2_MICRO;
				plane_page_addr |= ((plane_blk_addr + 1) << pages_per_blk_shift);   //plane 1  page 
//				printk("write y1:plane_page_addr =0x0%x\n",plane_page_addr);				
				break;

			case NAND_CMD_ERASE1:
				command_temp = command;
				plane_page_addr |= (plane_blk_addr << pages_per_blk_shift);
//				printk("erase x0:plane_page_addr =0x0%x\n",plane_page_addr);				
				break;

			case NAND_CMD_MULTI_CHIP_STATUS:
				command_temp = command;
				plane_page_addr |= (plane_blk_addr << pages_per_blk_shift);
				break;

			default:
				command_temp = command;
				break;

		}
		chip->cmd_ctrl(mtd, command_temp & 0xff, NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);
		//if ((command_temp == NAND_CMD_SEQIN) || (command_temp == NAND_CMD_TWOPLANE_WRITE2) || (command_temp == NAND_CMD_READ0))
			//printk(" NAND plane_page_addr: %x plane_blk_addr %x command: %x \n", plane_page_addr, plane_blk_addr, command);

		if (column != -1 || page_addr != -1) {
			int ctrl = NAND_CTRL_CHANGE | NAND_NCE | NAND_ALE;

			/* Serially input address */
			if (column != -1) {
				/* Adjust columns for 16 bit buswidth */
				if (chip->options & NAND_BUSWIDTH_16)
					column >>= 1;
				chip->cmd_ctrl(mtd, column, ctrl);
				
				switch (command)	{
				case	NAND_CMD_GET_FEATURES:
				case  NAND_CMD_SET_FEATURES:
					break;
				default:
					ctrl &= ~NAND_CTRL_CHANGE;
					chip->cmd_ctrl(mtd, column >> 8, ctrl);
					break;
				}
			}
			if (page_addr != -1) {

				chip->cmd_ctrl(mtd, plane_page_addr, ctrl);
				chip->cmd_ctrl(mtd, plane_page_addr >> 8, NAND_NCE | NAND_ALE);
				/* One more address cycle for devices > 128MiB */
				if (chip->chipsize > (128 << 20))
					chip->cmd_ctrl(mtd, plane_page_addr >> 16, NAND_NCE | NAND_ALE);
			}
		}

		switch (command) {

			case NAND_CMD_READ0:
				plane_page_addr = page_addr % (1 << pages_per_blk_shift);
				
				if (aml_chip->mfr_type == NAND_MFR_MICRON) {
					chip->cmd_ctrl(mtd, 0x32 & 0xff, NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);
					ndelay(Tdbsy); 
					
					plane_page_addr |= ((plane_blk_addr + 1) << pages_per_blk_shift);
//					printk("read y1:plane_page_addr =0x0%x\n",plane_page_addr);				
					command_temp = command;          //read plane1 
					chip->cmd_ctrl(mtd, command_temp & 0xff, NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);
				}
				else {
					command_temp = NAND_CMD_TWOPLANE_PREVIOS_READ;
					column = -1;
					plane_page_addr |= ((plane_blk_addr + 1) << pages_per_blk_shift);
					chip->cmd_ctrl(mtd, command_temp & 0xff, NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);
				}

				break;

			case NAND_CMD_TWOPLANE_READ1:
				if (aml_chip->mfr_type == NAND_MFR_MICRON) {
					page_addr = -1;
					column = -1;
				}
				else {
					command_temp = NAND_CMD_RNDOUT;
					page_addr = -1;
					chip->cmd_ctrl(mtd, command_temp & 0xff, NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);
				}
				break;

			case NAND_CMD_TWOPLANE_READ2:
				if (aml_chip->mfr_type == NAND_MFR_MICRON) {
					page_addr = -1;
					column = -1;
				}
				else {
					command_temp = NAND_CMD_RNDOUT;
					page_addr = -1;
					chip->cmd_ctrl(mtd, command_temp & 0xff, NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);
				}
				break;

			case NAND_CMD_ERASE1:
				if (aml_chip->mfr_type == NAND_MFR_MICRON) {
					command_temp = NAND_CMD_ERASE1_END;
					chip->cmd_ctrl(mtd, command_temp & 0xff, NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);

					ndelay(Tdbsy); 
					aml_chip->aml_nand_wait_devready(aml_chip, chipnr);
				}

				command_temp = command;
				chip->cmd_ctrl(mtd, command_temp & 0xff, NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);
				plane_page_addr = page_addr % (1 << pages_per_blk_shift);
				plane_page_addr |= ((plane_blk_addr + 1) << pages_per_blk_shift);
//				printk("erase y1:plane_page_addr =0x0%x\n",plane_page_addr);				
				break;

			case NAND_CMD_DUMMY_PROGRAM:
				if ((aml_chip->mfr_type == NAND_MFR_MICRON) )
					ndelay(Tdbsy); 
				break;			

			default:
				column = -1;
				page_addr = -1;
				break;
		}

		if (column != -1 || page_addr != -1) {
			int ctrl = NAND_CTRL_CHANGE | NAND_NCE | NAND_ALE;

			/* Serially input address */
			if (column != -1) {
				/* Adjust columns for 16 bit buswidth */
				if (chip->options & NAND_BUSWIDTH_16)
					column >>= 1;
				chip->cmd_ctrl(mtd, column, ctrl);
				ctrl &= ~NAND_CTRL_CHANGE;
				chip->cmd_ctrl(mtd, column >> 8, ctrl);
			}
			if (page_addr != -1) {
				//plane_page_addr |= (1 << (pages_per_blk_shift + 1));
				//BUG_ON((plane_page_addr & 0x7FF) == 0);

				chip->cmd_ctrl(mtd, plane_page_addr, ctrl);
				chip->cmd_ctrl(mtd, plane_page_addr >> 8, NAND_NCE | NAND_ALE);
				/* One more address cycle for devices > 128MiB */
				if (chip->chipsize > (128 << 20))
					chip->cmd_ctrl(mtd, plane_page_addr >> 16, NAND_NCE | NAND_ALE);
			}
		}

		if ((command == NAND_CMD_RNDOUT) || (command == NAND_CMD_TWOPLANE_READ2)){
			chip->cmd_ctrl(mtd, NAND_CMD_RNDOUTSTART, NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);
//			ndelay(Tdbsy); 
		}
		else if ((command == NAND_CMD_TWOPLANE_READ1)) {
			chip->cmd_ctrl(mtd, NAND_CMD_RNDOUTSTART, NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);
//			ndelay(Tdbsy); 
		}
		else if (command == NAND_CMD_READ0) {
			chip->cmd_ctrl(mtd, NAND_CMD_READSTART, NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);
//			udelay(Tr); 
		}

		chip->cmd_ctrl(mtd, NAND_CMD_NONE, NAND_NCE | NAND_CTRL_CHANGE);
	}
	else {
		chip->cmd_ctrl(mtd, command & 0xff, NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);

		if (column != -1 || page_addr != -1) {
			int ctrl = NAND_CTRL_CHANGE | NAND_NCE | NAND_ALE;

			/* Serially input address */
			if (column != -1) {
				/* Adjust columns for 16 bit buswidth */
				if (chip->options & NAND_BUSWIDTH_16)
					column >>= 1;
				chip->cmd_ctrl(mtd, column, ctrl);

				switch (command)	{
				case	NAND_CMD_GET_FEATURES:
				case  NAND_CMD_SET_FEATURES:
					break;
				default:
					ctrl &= ~NAND_CTRL_CHANGE;
					chip->cmd_ctrl(mtd, column >> 8, ctrl);
					break;
				}
			}
			if (page_addr != -1) {

				chip->cmd_ctrl(mtd, page_addr, ctrl);
				chip->cmd_ctrl(mtd, page_addr >> 8, NAND_NCE | NAND_ALE);
				/* One more address cycle for devices > 128MiB */
				if (chip->chipsize > (128 << 20))
					chip->cmd_ctrl(mtd, page_addr >> 16, NAND_NCE | NAND_ALE);
			}
		}
		if (command == NAND_CMD_RNDOUT)
			chip->cmd_ctrl(mtd, NAND_CMD_RNDOUTSTART, NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);
		else if (command == NAND_CMD_READ0)
			chip->cmd_ctrl(mtd, NAND_CMD_READSTART, NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);

		chip->cmd_ctrl(mtd, NAND_CMD_NONE, NAND_NCE | NAND_CTRL_CHANGE);
	}

	/*
	 * program and erase have their own busy handlers
	 * status, sequential in, and deplete1 need no delay
	 */
	switch (command) {

	case NAND_CMD_CACHEDPROG:
	case NAND_CMD_PAGEPROG:
	case NAND_CMD_ERASE1:
	case NAND_CMD_ERASE2:
	case NAND_CMD_SEQIN:
	case NAND_CMD_RNDIN:
	case NAND_CMD_STATUS:
	case NAND_CMD_DEPLETE1:
		return;

		/*
		 * read error status commands require only a short delay
		 */
	case NAND_CMD_STATUS_ERROR:
	case NAND_CMD_STATUS_ERROR0:
	case NAND_CMD_STATUS_ERROR1:
	case NAND_CMD_STATUS_ERROR2:
	case NAND_CMD_STATUS_ERROR3:
 		udelay(chip->chip_delay);
		return;

	case NAND_CMD_RESET:
 		if (!aml_chip->aml_nand_wait_devready(aml_chip, chipnr))
			aml_nand_debug ("couldn`t found selected chip: %d ready\n", chipnr);
 		if (chip->dev_ready)
			break;
		udelay(chip->chip_delay);
		
		chip->cmd_ctrl(mtd, NAND_CMD_STATUS, NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);
		chip->cmd_ctrl(mtd, NAND_CMD_NONE, NAND_NCE | NAND_CTRL_CHANGE);
		while (!(chip->read_byte(mtd) & NAND_STATUS_READY)) ;
		return;

	default:
		/*
		 * If we don't have access to the busy pin, we apply the given
		 * command delay
		 */
		break;
	}

	/* Apply this short delay always to ensure that we do wait tWB in
	 * any case on any machine. */
	ndelay(100);
}

static int aml_platform_dma_waiting(struct aml_nand_chip *aml_chip)
{
	unsigned time_out_cnt = 0;

	NFC_SEND_CMD_IDLE(aml_chip->chip_selected, 0);
	NFC_SEND_CMD_IDLE(aml_chip->chip_selected, 0);
	do {
		if (NFC_CMDFIFO_SIZE() <= 0)
			break;
	}while (time_out_cnt++ <= AML_DMA_BUSY_TIMEOUT);

	if (time_out_cnt < AML_DMA_BUSY_TIMEOUT)
		return 0;

	aml_nand_debug("aml_platform_dma_waiting time out !\n");
	return -EBUSY;
}

static int aml_platform_dma_write(struct aml_nand_chip *aml_chip, unsigned char *buf, int len, unsigned bch_mode)
{
	//struct mtd_info *mtd = aml_chip->mtd;
	struct nand_chip *chip = &aml_chip->chip;
	unsigned count= len/chip->ecc.size,pgsz=0;
	int ret = 0;
	
	if(aml_chip->short_pgsz)		
		pgsz = chip->ecc.size>>3;
		
	if(!bch_mode)
	{
		count = 1;
	}
	
	dcache_flush_range((unsigned)buf,len);	
	dcache_flush_range((unsigned)aml_chip->user_info_buf,count*PER_INFO_BYTE);

	NFC_SEND_CMD_ADL((int)buf);
	NFC_SEND_CMD_ADH((int)buf);
	NFC_SEND_CMD_AIL((int)aml_chip->user_info_buf);
	NFC_SEND_CMD_AIH((int)aml_chip->user_info_buf);	
	
	if(!bch_mode)
		NFC_SEND_CMD_M2N_RAW(aml_chip->ran_mode,len);
	else
		NFC_SEND_CMD_M2N(aml_chip->ran_mode,bch_mode,(aml_chip->short_pgsz==0)?0:1,pgsz,count);			//no seed fixme 

	ret = aml_platform_dma_waiting(aml_chip);
	if (ret)
	{
		aml_nand_debug ("aml_platform_dma_waiting fail\n");
		return ret;
	}
	return ret;		 
}

static int aml_platform_dma_read(struct aml_nand_chip *aml_chip, unsigned char *buf, int len, unsigned bch_mode)
{
	//struct mtd_info *mtd = aml_chip->mtd;
	struct nand_chip *chip = &aml_chip->chip;
//	unsigned dma_unit_size=0;
	unsigned count= len/chip->ecc.size,pgsz=0;
	unsigned int slen=PER_INFO_BYTE/sizeof(unsigned int);

	int ret = 0;
	volatile unsigned int * info_buf=0;
	volatile int cmp=0;
	
	if(aml_chip->short_pgsz)
		pgsz = chip->ecc.size>>3;
	
	if(!bch_mode)
	{
		count = 1;
	}
	memset((unsigned char *)aml_chip->user_info_buf, 0, count*PER_INFO_BYTE);	
	dcache_flush_range((unsigned)aml_chip->user_info_buf,count*PER_INFO_BYTE);
	dcache_invalid_range((unsigned)buf,len);

	NFC_SEND_CMD_ADL((int)buf);
	NFC_SEND_CMD_ADH((int)buf);
	NFC_SEND_CMD_AIL((int)aml_chip->user_info_buf);
	NFC_SEND_CMD_AIH((int)aml_chip->user_info_buf);

	if(!bch_mode)
		NFC_SEND_CMD_N2M_RAW(aml_chip->ran_mode,len);
	else
		NFC_SEND_CMD_N2M(aml_chip->ran_mode,bch_mode,(aml_chip->short_pgsz==0)?0:1,pgsz,count);		//FIXME wrong,bch_mode=0x4000

	ret = aml_platform_dma_waiting(aml_chip);
	if (ret)
		return ret;
	do{
		dcache_invalid_range((unsigned)aml_chip->user_info_buf, count*PER_INFO_BYTE);
		info_buf=(volatile unsigned *)&(aml_chip->user_info_buf[(count-1)*slen]);	
		cmp = *info_buf;	
	}while((cmp)==0);


	return 0;
}

static int aml_platform_hwecc_correct(struct aml_nand_chip *aml_chip, unsigned char *buf, unsigned size, unsigned char *oob_buf)
{
	struct nand_chip *chip = &aml_chip->chip;
	struct mtd_info *mtd = aml_chip->mtd;

	unsigned int len=PER_INFO_BYTE/sizeof(unsigned int);
	unsigned ecc_step_num;
		
	//#define INFO_BYTE 8
	if (size % chip->ecc.size) {
		aml_nand_debug ("error parameter size for ecc correct %x\n", size);
		return -EINVAL;
	}

	 for (ecc_step_num = 0; ecc_step_num < (size / chip->ecc.size); ecc_step_num++) {
	 	//check if there have uncorrectable sector
		if(NAND_ECC_CNT(*(unsigned *)(&aml_chip->user_info_buf[ecc_step_num*len]))==63)
	   	//if (NAND_ECC_FAIL(aml_chip->user_info_buf[ecc_step_num])) 
		{
	 		aml_nand_debug ("nand communication have uncorrectable ecc error ecc_step_num=%d\n",ecc_step_num);
	 		return -EIO;
	 	}
	 	else {
	 	    mtd->ecc_stats.corrected += NAND_ECC_CNT(*(unsigned *)(&aml_chip->user_info_buf[ecc_step_num*len]));
	 	    if(NAND_ECC_CNT(*(unsigned *)(&aml_chip->user_info_buf[ecc_step_num*len]))){
//	 	        aml_nand_debug("ECC CNT=%d ",NAND_ECC_CNT(*(unsigned *)(&aml_chip->user_info_buf[ecc_step_num*len])));
	 	    }
			
		}
	}

	return 0;
}

//nandchip cb  before scan 

static void aml_nand_dma_read_buf(struct mtd_info *mtd, uint8_t *buf, int len)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	
	aml_chip->aml_nand_dma_read(aml_chip, buf, len, 0);
}

static void aml_nand_dma_write_buf(struct mtd_info *mtd, const uint8_t *buf, int len)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);

	aml_chip->aml_nand_dma_write(aml_chip, (unsigned char *)buf, len, 0);
}

static int aml_nand_block_bad(struct mtd_info *mtd, loff_t ofs, int getchip)
{ 
	struct nand_chip * chip = mtd->priv;	
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	struct mtd_oob_ops aml_oob_ops;
	int32_t ret = 0, read_cnt, page;
	uint32_t failed;
	chip->pagebuf = -1;
	//return 0;

//	ofs &=~( (1<<chip->bbt_erase_shift)-1);
	
	if (getchip) {

		aml_oob_ops.mode = MTD_OOB_AUTO;
		aml_oob_ops.len = 0;//mtd->writesize;
		aml_oob_ops.ooblen = mtd->oobavail;
		aml_oob_ops.ooboffs = chip->ecc.layout->oobfree[0].offset;
		aml_oob_ops.datbuf = NULL;//chip->buffers->databuf;
		aml_oob_ops.oobbuf = chip->oob_poi;

		for (read_cnt=0; read_cnt<1; read_cnt++) {
		    failed=mtd->ecc_stats.failed;
			ret = mtd->read_oob(mtd, ofs, &aml_oob_ops);
			if (ret == -EUCLEAN)
				ret = 0;
		    if(ret<0||mtd->ecc_stats.failed!=failed)
		        aml_nand_debug(" NAND detect Bad block at %llx %d\n", (uint64_t)ofs,ret);
			if ((aml_oob_ops.oobbuf[chip->badblockpos] != 0) && (ret == 0))
				return 0;
		}

		if (ret < 0) {
			aml_nand_debug(" NAND detect Bad block at %llx %d\n", (uint64_t)ofs, ret);
			return EFAULT;
		}
		if (aml_oob_ops.oobbuf[chip->badblockpos] == 0) {
			memset(aml_chip->aml_nand_data_buf, 0, (mtd->writesize + mtd->oobsize));
			if (!memcmp(aml_chip->aml_nand_data_buf + mtd->writesize, aml_oob_ops.oobbuf, aml_oob_ops.ooblen)) {
				aml_nand_debug(" NAND detect Bad block at %llx \n", (uint64_t)ofs);
				return -EFAULT;
			}
		}
	}
	else {

		page = (int)(ofs >> chip->page_shift);
		failed=mtd->ecc_stats.failed;
		ret = chip->ecc.read_oob(mtd, chip, page, 1);
		if (ret == -EUCLEAN)
			ret = 0;
		if (ret < 0)
			return -EFAULT;
		if (chip->oob_poi[chip->badblockpos] == 0xFF)
			return 0;

		if (chip->oob_poi[chip->badblockpos] == 0||mtd->ecc_stats.failed!=failed) {
			memset(aml_chip->aml_nand_data_buf, 0, (mtd->writesize + mtd->oobsize));
			if (!memcmp(aml_chip->aml_nand_data_buf + mtd->writesize, chip->oob_poi, mtd->oobavail)) {
				aml_nand_debug(" NAND detect Bad block at %llx \n", (uint64_t)ofs);
				return -EFAULT;
			}	
		}
	}

	return 0;
}

static int aml_nand_block_markbad(struct mtd_info *mtd, loff_t ofs)
{ 
	struct nand_chip * chip = mtd->priv;	
	struct mtd_oob_ops aml_oob_ops;
	//struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);

	aml_oob_ops.mode = MTD_OOB_AUTO;
	aml_oob_ops.len = mtd->writesize;
	aml_oob_ops.ooblen = mtd->oobavail;
	aml_oob_ops.ooboffs = chip->ecc.layout->oobfree[0].offset;
	aml_oob_ops.datbuf = chip->buffers->databuf;
	aml_oob_ops.oobbuf = chip->oob_poi;
	chip->pagebuf = -1;

	memset((unsigned char *)aml_oob_ops.datbuf, 0x0, mtd->writesize);
	memset((unsigned char *)aml_oob_ops.oobbuf, 0x0, aml_oob_ops.ooblen);
//	ofs &=~( (1<<chip->bbt_erase_shift)-1);

	return mtd->write_oob(mtd, ofs, &aml_oob_ops);
}

static void aml_nand_select_chip(struct mtd_info *mtd, int chipnr)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	
	switch (chipnr) {
		case -1:
			NFC_SEND_CMD_STANDBY(3);
//			nand_release_chip();
			break;
		case 0:
			nand_get_chip();								/*FIXME A3 rb0 rb1 ce2 ce3*/
			aml_chip->aml_nand_select_chip(aml_chip, chipnr);
			break;
		case 1:
		case 2:
		case 3:
			aml_chip->aml_nand_select_chip(aml_chip, chipnr);
			break;

		default:
			BUG();
	}
	return;
}

static void aml_nand_cmd_ctrl(struct mtd_info *mtd, int cmd,  unsigned int ctrl)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);

	aml_chip->aml_nand_cmd_ctrl(aml_chip, cmd, ctrl);
}

#if   CONFIG_AM_NAND_RBPIN
static int aml_nand_dev_ready(struct mtd_info *mtd)
{
	struct nand_chip *chip = mtd->priv;
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	unsigned  ce= aml_chip->chip_selected;

#if 	1
	if(aml_chip->rbpin_mode)	
		return NFC_GET_RB_STATUS(aml_chip->rb_received);
	else
	{
		BUG();
		return 1;
	}
#endif		

//	NFC_CMD_FIFO_RESET();
	
   	NFC_SEND_CMD(ce|IDLE | 0);
	NFC_SEND_CMD(ce|CLE|NAND_CMD_STATUS);
   	NFC_SEND_CMD(ce|IDLE | 0);
	NFC_SEND_CMD(RB|IO6|28);
	NFC_SEND_CMD(ce|IDLE | 0);
	while(NFC_CMDFIFO_SIZE()>0);
	NFC_SEND_CMD(ce|DRD|3);

	return readb(chip->IO_ADDR_R);	
		
}
#endif

static int aml_nand_verify_buf(struct mtd_info *mtd, const uint8_t *buf, int len)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	struct nand_chip *chip = mtd->priv;

	chip->read_buf(mtd, aml_chip->aml_nand_data_buf, len);
	if (memcmp(buf, aml_chip->aml_nand_data_buf, len))
		return -EFAULT;

	return 0;
}

static uint8_t aml_platform_read_byte(struct mtd_info *mtd)
{
	struct nand_chip *chip = mtd->priv;
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	
//	NFC_CMD_FIFO_RESET();

	if(aml_chip->ops_mode&AML_SYNC_MODE)
		NFC_SEND_CMD(aml_chip->chip_selected | DRD_SYNC | 0);
	else
		NFC_SEND_CMD(aml_chip->chip_selected | DRD | 0);
	
	NFC_SEND_CMD(aml_chip->chip_selected | IDLE | 5);
	while(NFC_CMDFIFO_SIZE()>0);
	return readb(chip->IO_ADDR_R);
}

static void aml_platform_write_bytes(struct mtd_info *mtd,  uint8_t *buf ,int bytes)
{
	//struct nand_chip *chip = mtd->priv;
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	int i=0;

	while(bytes--)
	{
//		writeb(buf ,chip->IO_ADDR_R);
		NFC_SEND_CMD(aml_chip->chip_selected | IDLE | 5);
		if(aml_chip->ops_mode&AML_SYNC_MODE)
			NFC_SEND_CMD(aml_chip->chip_selected | DWR_SYNC |buf[i]);
		else
			NFC_SEND_CMD(aml_chip->chip_selected | DWR | buf[i]);
		while(NFC_CMDFIFO_SIZE()>0);
	}
}

static void aml_platform_read_bytes(struct mtd_info *mtd,  uint8_t *buf ,int bytes)
{
	struct nand_chip *chip = mtd->priv;
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	int i=0;

	while(bytes--)
	{
		if(aml_chip->ops_mode&AML_SYNC_MODE)
			NFC_SEND_CMD(aml_chip->chip_selected | DRD_SYNC | 0);
		else
			NFC_SEND_CMD(aml_chip->chip_selected | DRD | 0);
		
		NFC_SEND_CMD(aml_chip->chip_selected | IDLE | 5);

		while(NFC_CMDFIFO_SIZE()>0);
		buf[i++] = readb(chip->IO_ADDR_R);
	}
}


static int aml_nand_read_page_raw(struct mtd_info *mtd, struct nand_chip *chip, uint8_t *buf, int page)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	uint8_t *oob_buf = chip->oob_poi;
	unsigned nand_page_size = aml_chip->page_size;
	unsigned nand_oob_size = aml_chip->oob_size;
	int i, error = 0, j = 0, page_addr, internal_chipnr = 1;

	page_addr = aml_chip->page_addr;
	if (aml_chip->ops_mode & AML_INTERLEAVING_MODE)
		internal_chipnr = aml_chip->internal_chipnr;

	for (i=0; i<aml_chip->chip_num; i++) {
		if (aml_chip->valid_chip[i]) {


			for (j=0; j<internal_chipnr; j++) {

				if (j > 0) {
					page_addr |= (1 << aml_chip->internal_chip_shift) * j;
					aml_chip->aml_nand_select_chip(aml_chip, i);
					aml_chip->aml_nand_command(aml_chip, NAND_CMD_READ0, 0, page_addr, i);
				}

				if (aml_chip->plane_num == 2) {

					if (!aml_chip->aml_nand_wait_devready(aml_chip, i)) {
						aml_nand_debug ("couldn`t found selected chip: %d ready\n", i);
						error = -EBUSY;
						goto exit;
					}

					aml_chip->aml_nand_command(aml_chip, NAND_CMD_TWOPLANE_READ1, 0x00, page_addr, i);
					aml_chip->aml_nand_dma_read(aml_chip, aml_chip->aml_nand_data_buf, nand_page_size + nand_oob_size, 0);
					memcpy(buf, aml_chip->aml_nand_data_buf, (nand_page_size + nand_oob_size));
					memcpy(oob_buf, aml_chip->aml_nand_data_buf + nand_page_size, nand_oob_size);

					oob_buf += nand_oob_size;
					buf += (nand_page_size + nand_oob_size);

					if (!aml_chip->aml_nand_wait_devready(aml_chip, i)){
						aml_nand_debug ("couldn`t found selected chip: %d ready\n", i);
						error = -EBUSY;
						goto exit;
					}

					aml_chip->aml_nand_command(aml_chip, NAND_CMD_TWOPLANE_READ2, 0x00, page_addr, i);
					aml_chip->aml_nand_dma_read(aml_chip, aml_chip->aml_nand_data_buf, nand_page_size + nand_oob_size, 0);
					memcpy(buf, aml_chip->aml_nand_data_buf, (nand_page_size + nand_oob_size));
					memcpy(oob_buf, aml_chip->aml_nand_data_buf + nand_page_size, nand_oob_size);

					oob_buf += nand_oob_size;
					buf += (nand_page_size + nand_oob_size);
				}
				else if (aml_chip->plane_num == 1) {

					aml_chip->aml_nand_dma_read(aml_chip, aml_chip->aml_nand_data_buf, nand_page_size + nand_oob_size, 0);
					memcpy(buf, aml_chip->aml_nand_data_buf, nand_page_size);
					memcpy(oob_buf, aml_chip->aml_nand_data_buf + nand_page_size, nand_oob_size);

					oob_buf += nand_oob_size;
					buf += nand_page_size;
				}
				else {
					error = -ENODEV;
					aml_nand_debug ("plane_num mistake\n");
					goto exit;
				}
			}
		}
	}

exit:
	return error;
}

static void aml_nand_write_page_raw(struct mtd_info *mtd, struct nand_chip *chip, const uint8_t *buf)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	uint8_t *oob_buf = chip->oob_poi;
	unsigned nand_page_size =  aml_chip->page_size;   //real size 
	unsigned nand_oob_size = aml_chip->oob_size;
	int i, error = 0, j = 0, page_addr, internal_chipnr = 1;

	page_addr = aml_chip->page_addr;
	if (aml_chip->ops_mode & AML_INTERLEAVING_MODE)
		internal_chipnr = aml_chip->internal_chipnr;

	for (i=0; i<aml_chip->chip_num; i++) {
		if (aml_chip->valid_chip[i]) {

			aml_chip->aml_nand_select_chip(aml_chip, i);

			for (j=0; j<internal_chipnr; j++) {

				if (j > 0) {
					page_addr |= (1 << aml_chip->internal_chip_shift) * j;
					aml_chip->aml_nand_command(aml_chip, NAND_CMD_SEQIN, 0, page_addr, i);
				}
	
				if (aml_chip->plane_num == 2) {
	
					memcpy(aml_chip->aml_nand_data_buf, buf, nand_page_size);
					memcpy(aml_chip->aml_nand_data_buf + nand_page_size, oob_buf, nand_oob_size);
					aml_chip->aml_nand_dma_write(aml_chip, aml_chip->aml_nand_data_buf, nand_page_size + nand_oob_size, 0);
					aml_chip->aml_nand_command(aml_chip, NAND_CMD_DUMMY_PROGRAM, -1, -1, i);
	
					oob_buf += nand_oob_size;
					buf += nand_page_size;
	
					if (!aml_chip->aml_nand_wait_devready(aml_chip, i)) {
						aml_nand_debug ("couldn`t found selected chip: %d ready\n", i);
						error = -EBUSY;
						goto exit;
					}
	
					memcpy(aml_chip->aml_nand_data_buf, buf, nand_page_size);
					memcpy(aml_chip->aml_nand_data_buf + nand_page_size, oob_buf, nand_oob_size);
					aml_chip->aml_nand_command(aml_chip, NAND_CMD_TWOPLANE_WRITE2, 0x00, page_addr, i);
					aml_chip->aml_nand_dma_write(aml_chip, aml_chip->aml_nand_data_buf, nand_page_size + nand_oob_size, 0);
					aml_chip->aml_nand_command(aml_chip, NAND_CMD_PAGEPROG, -1, -1, i);
	
					oob_buf += nand_oob_size;
					buf += nand_page_size;
				}
				else if (aml_chip->plane_num == 1) {
	
					memcpy(aml_chip->aml_nand_data_buf, buf, nand_page_size);
					memcpy(aml_chip->aml_nand_data_buf + nand_page_size, oob_buf, nand_oob_size);
					aml_chip->aml_nand_dma_write(aml_chip, aml_chip->aml_nand_data_buf, nand_page_size + nand_oob_size, 0);
					if (chip->cmdfunc == aml_nand_cmdfunc)
						aml_chip->aml_nand_command(aml_chip, NAND_CMD_PAGEPROG, -1, -1, i);
	
					oob_buf += nand_oob_size;
					buf += nand_page_size;
				}
				else {
					error = -ENODEV;
					aml_nand_debug ("plane_num mistake\n");
					goto exit;
				}
			}
		}
	}

exit:
	return ;
}

static int aml_nand_read_page_hwecc(struct mtd_info *mtd, struct nand_chip *chip, uint8_t *buf, int page)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	uint8_t *oob_buf = chip->oob_poi;
	unsigned nand_page_size =  aml_chip->page_size;   //real size 
	unsigned pages_per_blk_shift = (chip->phys_erase_shift - chip->page_shift);
	int user_byte_num = (((nand_page_size + chip->ecc.size - 1) / chip->ecc.size) * aml_chip->user_byte_mode);
	int error = 0, i = 0, stat = 0, j = 0, page_addr, internal_chipnr = 1;

	if(!strcmp(mtd->name,NAND_BOOT_NAME))
	{
		nand_page_size=3*512;					//compate older	  ,corresponding to applictaion
	}
	
	page_addr = aml_chip->page_addr;
	if (aml_chip->ops_mode & AML_INTERLEAVING_MODE)
		internal_chipnr = aml_chip->internal_chipnr;

	for (i=0; i<aml_chip->chip_num; i++) {

		if (aml_chip->valid_chip[i]) {

			for (j=0; j<internal_chipnr; j++) {

				if (j > 0) {
					page_addr |= (1 << aml_chip->internal_chip_shift) * j;
					aml_chip->aml_nand_select_chip(aml_chip, i);
					aml_chip->aml_nand_command(aml_chip, NAND_CMD_READ0, 0, page_addr, i);
				}


				if (aml_chip->plane_num == 2) {

				if (!aml_chip->aml_nand_wait_devready(aml_chip, i)) {
						aml_nand_debug ("read couldn`t found selected chip: %d ready\n", i);
						error = -EBUSY;
						goto exit;
					}

					aml_chip->aml_nand_command(aml_chip, NAND_CMD_TWOPLANE_READ1, 0x00, page_addr, i);
					error = aml_chip->aml_nand_dma_read(aml_chip, buf, nand_page_size, aml_chip->bch_mode);
					if (error){
						aml_nand_debug ("aml_nand_dma_read plane 0 fail\n");
						goto exit;
					}   

					aml_chip->aml_nand_get_user_byte(aml_chip, oob_buf, user_byte_num);
					stat = aml_chip->aml_nand_hwecc_correct(aml_chip, buf, nand_page_size, oob_buf);
					if (stat < 0) {
						mtd->ecc_stats.failed++;
						aml_nand_debug("aml_nand_hwecc_correct  plane0 failed at page %d chip %d\n", page_addr, i);
//						error = -EIO;goto exit;
					}
					else
						mtd->ecc_stats.corrected += stat;

					oob_buf += user_byte_num;
					buf += nand_page_size;

					if (!aml_chip->aml_nand_wait_devready(aml_chip, i)) {
						aml_nand_debug ("read couldn`t found selected chip: %d ready\n", i);
						error = -EBUSY;
						goto exit;
					}

					aml_chip->aml_nand_command(aml_chip, NAND_CMD_TWOPLANE_READ2, 0x00, page_addr, i);
					error = aml_chip->aml_nand_dma_read(aml_chip, buf, nand_page_size, aml_chip->bch_mode);
					if (error){
						aml_nand_debug ("aml_nand_dma_read plane 1 fail\n");
						goto exit;
					}
	
					aml_chip->aml_nand_get_user_byte(aml_chip, oob_buf, user_byte_num);
					stat = aml_chip->aml_nand_hwecc_correct(aml_chip, buf, nand_page_size, oob_buf);
					if (stat < 0) {
						mtd->ecc_stats.failed++;
						aml_nand_debug("aml_nand_hwecc_correct  plane1 failed at page %d chip %d\n", page_addr , i);
//						error = -EIO;goto exit;
					}
					else
						mtd->ecc_stats.corrected += stat;
	
					oob_buf += user_byte_num;
					buf += nand_page_size;

				}
				else if (aml_chip->plane_num == 1) {
	
					error = aml_chip->aml_nand_dma_read(aml_chip, buf, nand_page_size, aml_chip->bch_mode);
					if (error)
					{
						aml_nand_debug("aml_nand_dma_read ecc failed at blk %d chip %d\n", (page_addr >> pages_per_blk_shift), i);
						goto exit;
					}
	
					aml_chip->aml_nand_get_user_byte(aml_chip, oob_buf, user_byte_num);
					stat = aml_chip->aml_nand_hwecc_correct(aml_chip, buf, nand_page_size, oob_buf);
					if (stat < 0) {
						mtd->ecc_stats.failed++;
						aml_nand_debug("aml_nand_hwecc_correct at blk %d chip %d\n", (page_addr >> pages_per_blk_shift), i);
//						error = -EIO;goto exit;
					}
					else
						mtd->ecc_stats.corrected += stat;
	
					oob_buf += user_byte_num;
					buf += nand_page_size;
				}
				else {
					error = -ENODEV;
					aml_nand_debug ("plane_num mistake\n");
					goto exit;
				}
			}
		}
	}

exit:
	return error;
}

static void aml_nand_write_page_hwecc(struct mtd_info *mtd, struct nand_chip *chip, const uint8_t *buf)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	uint8_t *oob_buf = chip->oob_poi;
	unsigned nand_page_size =  aml_chip->page_size;   //real size 
	int user_byte_num = (((nand_page_size + chip->ecc.size - 1) / chip->ecc.size) * aml_chip->user_byte_mode);
	int error = 0, i = 0, j = 0, page_addr, internal_chipnr = 1;

	if(!strcmp(mtd->name,NAND_BOOT_NAME))
	{
		nand_page_size=3*512;					//compate older	  , corresponding to applictaion
	}
	
	page_addr = aml_chip->page_addr;
	if (aml_chip->ops_mode & AML_INTERLEAVING_MODE)
		internal_chipnr = aml_chip->internal_chipnr;

	for (i=0; i<aml_chip->chip_num; i++) {

		if (aml_chip->valid_chip[i]) {

			for (j=0; j<internal_chipnr; j++) {
				
				aml_chip->aml_nand_select_chip(aml_chip, i);

				if (j > 0) {
					page_addr |= (1 << aml_chip->internal_chip_shift) * j;
					aml_chip->aml_nand_command(aml_chip, NAND_CMD_SEQIN, 0, page_addr, i);
				}
				
				if (aml_chip->plane_num == 2) {
	
					aml_chip->aml_nand_set_user_byte(aml_chip, oob_buf, user_byte_num);
					error = aml_chip->aml_nand_dma_write(aml_chip, (unsigned char *)buf, nand_page_size, aml_chip->bch_mode);
					if (error){
						aml_nand_debug ("aml_nand_dma_write plane 0 fail\n" );
						goto exit;
					}
					aml_chip->aml_nand_command(aml_chip, NAND_CMD_DUMMY_PROGRAM, -1, -1, i);
	
					oob_buf += user_byte_num;
					buf += nand_page_size;
	
					if (!aml_chip->aml_nand_wait_devready(aml_chip, i)) {
						aml_nand_debug ("write couldn`t found selected chip: %d ready\n", i);
						error = -EBUSY;
						goto exit;
					}
	
					aml_chip->aml_nand_command(aml_chip, NAND_CMD_TWOPLANE_WRITE2, 0x00, page_addr, i);
					aml_chip->aml_nand_set_user_byte(aml_chip, oob_buf, user_byte_num);
					error = aml_chip->aml_nand_dma_write(aml_chip, (unsigned char *)buf, nand_page_size, aml_chip->bch_mode);
					if (error){
						aml_nand_debug ("aml_nand_dma_write  plane 1 fail\n");
						goto exit;
					}
					if (aml_chip->cached_prog_status)
						aml_chip->aml_nand_command(aml_chip, NAND_CMD_CACHEDPROG, -1, -1, i);
					else
						aml_chip->aml_nand_command(aml_chip, NAND_CMD_PAGEPROG, -1, -1, i);
	
					oob_buf += user_byte_num;
					buf += nand_page_size;
				}
				else if (aml_chip->plane_num == 1) {

					aml_chip->aml_nand_set_user_byte(aml_chip, oob_buf, user_byte_num);
					error = aml_chip->aml_nand_dma_write(aml_chip, (unsigned char *)buf, nand_page_size, aml_chip->bch_mode);
					if (error){
						aml_nand_debug ("aml_nand_dma_write fail\n");
						goto exit;
					}
					if (chip->cmdfunc == aml_nand_cmdfunc) {
						if (aml_chip->cached_prog_status)
							aml_chip->aml_nand_command(aml_chip, NAND_CMD_CACHEDPROG, -1, -1, i);
						else
							aml_chip->aml_nand_command(aml_chip, NAND_CMD_PAGEPROG, -1, -1, i);
					}

					oob_buf += user_byte_num;
					buf += nand_page_size;
				}
				else {
					error = -ENODEV;
					aml_nand_debug ("plane_num mistake\n");
					goto exit;
				}
			}
		}
	}

exit:
	return;
}


static int aml_nand_read_oob(struct mtd_info *mtd, struct nand_chip *chip, int page, int sndcmd)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	uint8_t *oob_buf = chip->oob_poi;
	unsigned nand_page_size =  aml_chip->page_size;   //real size 
	//unsigned pages_per_blk_shift = (chip->phys_erase_shift - chip->page_shift);
	int user_byte_num = (((nand_page_size + chip->ecc.size - 1) / chip->ecc.size) * aml_chip->user_byte_mode);
	int32_t error = 0, i, stat = 0, j = 0, page_addr, internal_chipnr = 1; 
	unsigned dma_once_size;
	unsigned char *nand_buffer = aml_chip->aml_nand_data_buf;
	unsigned nand_read_size = (mtd->writesize);
	unsigned read_chip_num = (((nand_read_size + (aml_chip->plane_num * nand_page_size) - 1) / (aml_chip->plane_num * nand_page_size)));
	//chip->pagebuf = -1;

	page_addr = page;
	if (aml_chip->ops_mode & AML_INTERLEAVING_MODE) {
		internal_chipnr = aml_chip->internal_chipnr;
		internal_chipnr = (read_chip_num + aml_chip->internal_chipnr - 1) / aml_chip->internal_chipnr;
		read_chip_num = 1;
	}

	if (sndcmd) {
		if (chip->cmdfunc == aml_nand_cmdfunc)
			chip->cmdfunc(mtd, NAND_CMD_READOOB, 0, page_addr);
		else {
			aml_chip->aml_nand_select_chip(aml_chip, 0);
			chip->cmdfunc(mtd, NAND_CMD_READ0, 0, page_addr);
		}
		sndcmd = 0;
	}

	aml_nand_debug2("\n read page 0x%x oob : ",page);

	page_addr = aml_chip->page_addr;
	if(!strcmp(mtd->name,NAND_BOOT_NAME))
	{
		nand_read_size=3*512;				//compate older 	,corresponding to applictaion
	}

	for (i=0; i<read_chip_num; i++) {

		if (aml_chip->valid_chip[i]) {

			if (i > 0) {
				aml_chip->aml_nand_select_chip(aml_chip, i);
				aml_chip->aml_nand_command(aml_chip, NAND_CMD_READ0, 0, page_addr, i);
			}

			for (j=0; j<internal_chipnr; j++) {

				if (j > 0) {
					page_addr |= (1 << aml_chip->internal_chip_shift) * j;
					aml_chip->aml_nand_select_chip(aml_chip, i);
					aml_chip->aml_nand_command(aml_chip, NAND_CMD_READ0, 0, page_addr, i);
				}

				if (!aml_chip->aml_nand_wait_devready(aml_chip, i)) {
					aml_nand_debug ("read oob couldn`t found selected chip: %d ready\n", i);
					error = -EBUSY;
					goto exit;
				}

				if (aml_chip->plane_num == 2) {


					dma_once_size = min(nand_read_size,nand_page_size);

					aml_chip->aml_nand_command(aml_chip, NAND_CMD_TWOPLANE_READ1, 0x00, page_addr, i);
					error = aml_chip->aml_nand_dma_read(aml_chip, nand_buffer, dma_once_size, aml_chip->bch_mode);
					if (error){
						aml_nand_debug("aml_nand_dma_read plane 0 failed %d\n", error);
						return error;
					}

					aml_chip->aml_nand_get_user_byte(aml_chip, oob_buf, user_byte_num);
					stat = aml_chip->aml_nand_hwecc_correct(aml_chip, nand_buffer, dma_once_size, oob_buf);
					if (stat < 0) {
						mtd->ecc_stats.failed++;
						aml_nand_debug("aml_nand_hwecc_correct plane0 failed at page 0x%x\n", page_addr);
//						error = -EIO;goto exit;
					}
					else
						mtd->ecc_stats.corrected += stat;

					oob_buf += user_byte_num;
					nand_read_size -= dma_once_size;

					if (nand_read_size > 0) {

						dma_once_size = min(nand_read_size,nand_page_size);
							
						aml_chip->aml_nand_command(aml_chip, NAND_CMD_TWOPLANE_READ2, 0x00, page_addr, i);
						error = aml_chip->aml_nand_dma_read(aml_chip, nand_buffer, dma_once_size, aml_chip->bch_mode);
						if (error){
							aml_nand_debug("aml_nand_dma_read plane 1 failed %d\n", error);
							return error;
						}

						aml_chip->aml_nand_get_user_byte(aml_chip, oob_buf, user_byte_num);
						stat = aml_chip->aml_nand_hwecc_correct(aml_chip, nand_buffer, dma_once_size, oob_buf);
						if (stat < 0) {
							mtd->ecc_stats.failed++;
							aml_nand_debug("aml_nand_hwecc_correct plane1 failed at page 0x%x\n", page_addr);
//							error = -EIO;goto exit;
						}
						else
							mtd->ecc_stats.corrected += stat;

						oob_buf += user_byte_num;
						nand_read_size -= dma_once_size;
					}
				}
				else if (aml_chip->plane_num == 1) {

					dma_once_size = min(nand_read_size,nand_page_size);

					error = aml_chip->aml_nand_dma_read(aml_chip, nand_buffer, dma_once_size, aml_chip->bch_mode);
					if (error) {
						aml_nand_debug("aml_nand_dma_read failed %d\n", error);
						return error;
					}
	
					aml_chip->aml_nand_get_user_byte(aml_chip, oob_buf, user_byte_num);
					stat = aml_chip->aml_nand_hwecc_correct(aml_chip, nand_buffer, dma_once_size, oob_buf);
					if (stat < 0) {
						mtd->ecc_stats.failed++;
						aml_nand_debug("aml_nand_hwecc_correct failed at page %d xxx\n", page_addr);					
					}
					else
						mtd->ecc_stats.corrected += stat;

					oob_buf += user_byte_num;
					nand_read_size -= dma_once_size;
				}
				else {
					error = -ENODEV;
					aml_nand_debug ("plane_num mistake\n");
					goto exit;
				}
			}
		}
	}

exit:
	return error;
}

static int aml_nand_write_oob(struct mtd_info *mtd, struct nand_chip *chip, int page)
{
	aml_nand_debug("our host controller`s structure couldn`t support oob write\n");
	BUG();
	return 0;
}

//nandchip cb after scan
static void aml_nand_cmdfunc(struct mtd_info *mtd, unsigned command, int column, int page_addr)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	struct nand_chip *chip = &aml_chip->chip;
	int i = 0;
	int status=0;

//remember address for lower 
	if (page_addr != -1) {
#if 0
		int valid_page_num = 1, internal_chip;
		valid_page_num = (mtd->writesize >> chip->page_shift);
		valid_page_num /= aml_chip->plane_num;

		aml_chip->page_addr = page_addr / valid_page_num;      //real address save for next op 
		if (unlikely(aml_chip->page_addr >= aml_chip->internal_page_nums)) {
			internal_chip = aml_chip->page_addr / aml_chip->internal_page_nums; 
			aml_chip->page_addr -= aml_chip->internal_page_nums;
			aml_chip->page_addr |= (1 << aml_chip->internal_chip_shift) * internal_chip;
		}
#else
		aml_chip->page_addr = page_addr;		 
#endif
	}

	/* Emulate NAND_CMD_READOOB */
	if (command == NAND_CMD_READOOB) {
		command = NAND_CMD_READ0;
 	}

	if (command == NAND_CMD_READ0) {
		aml_chip->aml_nand_command(aml_chip, command, column, aml_chip->page_addr, 0);
#if (!CONFIG_AM_NAND_RBPIN)	
//		if(NAND_MFR_SAMSUNG!=aml_chip->mfr_type)
		{
		    status  =  chip->waitfunc(mtd, chip);
			chip->cmd_ctrl(mtd, 0, NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);
		}
			// aml_chip->aml_nand_command(aml_chip, NAND_CMD_READ0, -1, -1, i);  //read mode for next data out
//			printk("rd page=0x%x, status =  0x%x\n", aml_chip->page_addr,status);
 #endif		 
		return;
	}
	
	if (command == NAND_CMD_PAGEPROG)  //filter  0x10 
		return;

	if (command == NAND_CMD_SEQIN) {
		aml_chip->aml_nand_select_chip(aml_chip, 0);
		aml_chip->aml_nand_command(aml_chip, command, column, aml_chip->page_addr, 0);
		return;
	}

	for (i=0; i<aml_chip->chip_num; i++) {
		if (aml_chip->valid_chip[i]) {
			//active ce for operation chip and send cmd
			aml_chip->aml_nand_wait_devready(aml_chip, i);
			aml_chip->aml_nand_command(aml_chip, command, column, aml_chip->page_addr, i);
		}
	}

	return;
}


static int aml_nand_wait(struct mtd_info *mtd, struct nand_chip *chip)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	int status[MAX_CHIP_NUM], state = chip->state, i = 0, time_cnt = 0;

	status[0] = 0;

	/* Apply this short delay always to ensure that we do wait tWB in
	 * any case on any machine. */
	ndelay(100);

	//for (i=0; i<aml_chip->chip_num; i++) {
		if (aml_chip->valid_chip[i]) {
			//active ce for operation chip and send cmd
			aml_chip->aml_nand_select_chip(aml_chip, i);

			if (aml_chip->ops_mode == AML_MULTI_CHIP_SHARE_RB) {

				time_cnt = 0;
				while (time_cnt++ < 0x10000) {
					if (state == FL_ERASING)
						aml_chip->aml_nand_command(aml_chip, NAND_CMD_STATUS_MULTI, -1, -1, i);
					else
						aml_chip->aml_nand_command(aml_chip, NAND_CMD_STATUS, -1, -1, i);
					status[i] = (int)chip->read_byte(mtd);
					if (status[i] & NAND_STATUS_READY_MULTI)
						break;
					udelay(2);
				}
			}
			else {
				if ((state == FL_ERASING) && (chip->options & NAND_IS_AND))
					aml_chip->aml_nand_command(aml_chip, NAND_CMD_STATUS_MULTI, -1, -1, i);
				else
					aml_chip->aml_nand_command(aml_chip, NAND_CMD_STATUS, -1, -1, i);
					
				time_cnt = 0;
				while (time_cnt++ < 0x10000) {
					udelay(chip->chip_delay);
					if (chip->dev_ready) {
						if (chip->dev_ready(mtd))
							break;
					} else {
						status[i] = (int)chip->read_byte(mtd);
						if (status[i] & (NAND_STATUS_READY))
							break;
					}
				}
				
			}

			status[0] |= status[i];
		}
	//}

	if( time_cnt >0x10000)	
	{
		aml_nand_debug("NAND_CMD_STATUS time out !\n");
		if(state ==FL_READING)	{
			aml_nand_debug("--FL_READING fail !\n");
		}
		if(state ==FL_ERASING)	{
			aml_nand_debug("--FL_ERASING fail !\n");
		}
		else if(state ==FL_WRITING )	{
			aml_nand_debug("--FL_WRITING fail !\n");		
		}
	}
	else
	{
#if 0
		if(!(status[0]&NAND_STATUS_READY) &&(status[0]&NAND_STATUS_FAIL_N1) )
		{
			status[0] &=~NAND_STATUS_FAIL_N1;
		} 				
		if(!(status[0]&NAND_STATUS_TRUE_READY) &&(status[0]&NAND_STATUS_FAIL) )
		{
			status[0] &=~NAND_STATUS_FAIL;
		} 				
#endif
		if(status[0] &(NAND_STATUS_FAIL|NAND_STATUS_FAIL_N1))
		{
			if(state ==FL_ERASING)	{
				aml_nand_debug("FL_ERASING fail !status=0x%x \n",status[0]);
			}
			else if(state ==FL_WRITING )	{
				aml_nand_debug("FL_WRITING fail !status=0x%x \n",status[0]);		
			}
		}
	}

	return status[0];
}

static void aml_nand_erase_cmd(struct mtd_info *mtd, int page)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	struct nand_chip *chip = mtd->priv;	
	unsigned i = 0, j = 0, internal_chipnr = 1, page_addr;

#if 0
	unsigned pages_per_blk_shift = (chip->phys_erase_shift - chip->page_shift);
	unsigned vt_page_num, valid_page_num;
	vt_page_num = (mtd->writesize / (1 << chip->page_shift));
	vt_page_num *= (1 << pages_per_blk_shift);
	if (page % vt_page_num)
		return;

	/* Send commands to erase a block */
	page_addr = page;
	valid_page_num = (mtd->writesize >> chip->page_shift);
	valid_page_num /= aml_chip->plane_num;

	page_addr /= valid_page_num;
#else
	page_addr =  page & (~ (1<< (chip->phys_erase_shift  -1))) ;	//address block align 
//	vt_page_num = (1 << pages_per_blk_shift )*aml_chip->plane_num;
//	if (page % vt_page_num){
//		aml_nand_debug("skip page 0x%x!\n" ,page);		
//		return;
//	}
#endif

	if (unlikely(page_addr >= aml_chip->internal_page_nums)) {
		internal_chipnr = page_addr / aml_chip->internal_page_nums;
		page_addr -= aml_chip->internal_page_nums;
		page_addr |= (1 << aml_chip->internal_chip_shift) * internal_chipnr;
	}

	if (unlikely(aml_chip->ops_mode & AML_INTERLEAVING_MODE))
		internal_chipnr = aml_chip->internal_chipnr;
	else
		internal_chipnr = 1;

	for (i=0; i<aml_chip->chip_num; i++) {
		if (aml_chip->valid_chip[i]) {

			aml_chip->aml_nand_select_chip(aml_chip, i);
			for (j=0; j<internal_chipnr; j++) {
				if (j > 0)
					page_addr |= (1 << aml_chip->internal_chip_shift) * j;

				aml_chip->aml_nand_command(aml_chip, NAND_CMD_ERASE1, -1, page_addr, i);
				aml_chip->aml_nand_command(aml_chip, NAND_CMD_ERASE2, -1, -1, i);
			}
		}
	}

	return ;
}


static int aml_nand_write_page(struct mtd_info *mtd, struct nand_chip *chip, const uint8_t *buf, int page, int cached, int raw)
{
	int status;
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);

	chip->cmdfunc(mtd, NAND_CMD_SEQIN, 0x00, page);

	if (unlikely(raw))
		chip->ecc.write_page_raw(mtd, chip, buf);
	else
		chip->ecc.write_page(mtd, chip, buf);

	if (!cached || !(chip->options & NAND_CACHEPRG)) {

		//chip->cmdfunc(mtd, NAND_CMD_PAGEPROG, -1, -1);
		status = chip->waitfunc(mtd, chip);
		if(status&(NAND_STATUS_FAIL|NAND_STATUS_FAIL_N1)){
			aml_nand_debug("wr page=0x%x, status =	0x%x\n", page,status);
		}
		/*
		 * See if operation failed and additional status checks are
		 * available
		 */
		if ((status & NAND_STATUS_FAIL) && (chip->errstat))
			status = chip->errstat(mtd, chip, FL_WRITING, status, page);

		if (status & NAND_STATUS_FAIL)
		{	
			aml_nand_debug("wr page=0x%x, status =  0x%x\n", page,status);
			return -EIO;
		}
	} else {
		//chip->cmdfunc(mtd, NAND_CMD_CACHEDPROG, -1, -1);
		status = chip->waitfunc(mtd, chip);
	}
	if(status&(NAND_STATUS_FAIL|NAND_STATUS_FAIL_N1)){
		aml_nand_debug("wr page=0x%x, status =  0x%x\n", page,status);
	}
	aml_chip->cached_prog_status = 0;

#ifdef CONFIG_MTD_NAND_VERIFY_WRITE
	chip->cmdfunc(mtd, NAND_CMD_READ0, 0x00, page);
	status = chip->ecc.read_page(mtd, chip, chip->buffers->databuf, page);
	if (status == -EUCLEAN)
		status = 0;
	chip->pagebuf = page;

	if (memcmp(buf, chip->buffers->databuf, mtd->writesize)) {
		aml_nand_debug("nand verify failed at %d \n", page);
		return -EFAULT;
	}
#endif

	return 0;
}

static struct aml_nand_flash_dev *aml_nand_get_flash_type(struct mtd_info *mtd,
						  struct nand_chip *chip,
						  int busw, int *maf_id)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	struct aml_nand_platform *plat = aml_chip->platform;
	struct aml_nand_flash_dev *type = NULL;
	int i, maf_idx;
	u8 dev_id[MAX_ID_LEN];
	//int tmp_id, tmp_manf;

	/* Send the command for reading device ID */
	chip->cmdfunc(mtd, NAND_CMD_READID, 0x00, -1);

	/* Read manufacturer and device IDs */
	for (i=0; i<MAX_ID_LEN; i++) {
		dev_id[i] = chip->read_byte(mtd);
	}
	*maf_id = dev_id[0];
	aml_nand_debug("NAND device id: %x %x %x %x %x %x \n", dev_id[0], dev_id[1], dev_id[2], dev_id[3], dev_id[4], dev_id[5]);

	/* Lookup the flash id */
	for (i = 0; aml_nand_flash_ids[i].name != NULL; i++) {
		if(!strncmp((char*)aml_nand_flash_ids[i].id, (char*)dev_id, strlen((const char*)aml_nand_flash_ids[i].id))){
			type = &aml_nand_flash_ids[i];
			break;
		}
	}

	if (!type) {
		if (plat->nand_flash_dev) {
			if(!strncmp((char*)plat->nand_flash_dev->id, (char*)dev_id, strlen((const char*)plat->nand_flash_dev->id))){
				type = plat->nand_flash_dev;
			}
		}

		if (!type)
			return ERR_PTR(-ENODEV);
	}

#ifdef CONFIG_MTD_DEVICE
	//mtd->name = NULL;
	//if (!mtd->info)
//		mtd->info = type->name;
#else
	if (!mtd->name)
		mtd->name = type->name;
#endif

	chip->chipsize = type->chipsize;
	chip->chipsize = chip->chipsize << 20;

	/* Newer devices have all the information in additional id bytes */
	if (!type->pagesize) {
		int extid;
		/* The 3rd id byte holds MLC / multichip data */
		chip->cellinfo = chip->read_byte(mtd);
		/* The 4th id byte is the important one */
		extid = chip->read_byte(mtd);
		/* Calc pagesize */
		mtd->writesize = 1024 << (extid & 0x3);
		extid >>= 2;
		/* Calc oobsize */
		mtd->oobsize = (8 << (extid & 0x01)) * (mtd->writesize >> 9);
		extid >>= 2;
		/* Calc blocksize. Blocksize is multiples of 64KiB */
		mtd->erasesize = (64 * 1024) << (extid & 0x03);
		extid >>= 2;
		/* Get buswidth information */
		busw = (extid & 0x01) ? NAND_BUSWIDTH_16 : 0;

	} else {
		/*
		 * Old devices have chip data hardcoded in the device id table
		 */
		mtd->erasesize = type->erasesize;
		mtd->writesize = type->pagesize;
		mtd->oobsize = type->oobsize;
		busw = type->options & NAND_BUSW_OPTIONS_MASK;
	}

	/* Try to identify manufacturer */
	for (maf_idx = 0; nand_manuf_ids[maf_idx].id != 0x0; maf_idx++) {
		if (nand_manuf_ids[maf_idx].id == *maf_id)
			break;
	}

	/*
	 * Check, if buswidth is correct. Hardware drivers should set
	 * chip correct !
	 */
	if (busw != (chip->options & NAND_BUSWIDTH_16)) {
		aml_nand_debug(KERN_INFO "NAND device: Manufacturer ID:"
		       " 0x%02x, Chip ID: 0x%02x (%s %s)\n", *maf_id,
		       dev_id[0], nand_manuf_ids[maf_idx].name, mtd->name);
		aml_nand_debug(KERN_WARNING "NAND bus width %d instead %d bit\n",
		       (chip->options & NAND_BUSWIDTH_16) ? 16 : 8,
		       busw ? 16 : 8);
		return ERR_PTR(-EINVAL);
	}

	/* Calculate the address shift from the page size */
	chip->page_shift = ffs(mtd->writesize) - 1;
	/* Convert chipsize to number of pages per chip -1. */
	chip->pagemask = (chip->chipsize >> chip->page_shift) - 1;

	chip->bbt_erase_shift = chip->phys_erase_shift = ffs(mtd->erasesize) - 1;
	chip->chip_shift = ffs(chip->chipsize) - 1;

	/* Set the bad block position */
	chip->badblockpos = AML_BADBLK_POS;

	/* Get chip options, preserve non chip based options */
	chip->options &= ~NAND_CHIPOPTIONS_MSK;
	chip->options |= type->options & NAND_CHIPOPTIONS_MSK;

	/*
	 * Set chip as a default. Board drivers can override it, if necessary
	 */
	chip->options |= NAND_NO_AUTOINCR;

	/* Check if chip is a not a samsung device. Do not clear the
	 * options for chips which are not having an extended id.
	 */
	if (*maf_id != NAND_MFR_SAMSUNG && !type->pagesize)
		chip->options &= ~NAND_SAMSUNG_LP_OPTIONS;

	aml_nand_debug(KERN_INFO "NAND device: Manufacturer ID:"
	       " 0x%02x, Chip ID: 0x%02x (%s %s)\n", *maf_id, dev_id[0],
	       nand_manuf_ids[maf_idx].name, type->name);

	return type;
}

static int aml_nand_scan_ident(struct mtd_info *mtd, int maxchips)
{
	int i, busw, nand_maf_id, valid_chip_num = 1;
	struct nand_chip *chip = mtd->priv;
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	struct aml_nand_flash_dev *aml_type;
	unsigned temp_chip_shift;

	/* Get buswidth to select the correct functions */
	busw = chip->options & NAND_BUSWIDTH_16;

	/* Select the device */
	chip->select_chip(mtd, 0);

	//reset chip for some nand need reset after power up
	chip->cmdfunc(mtd, NAND_CMD_RESET, -1, -1);
	aml_chip->aml_nand_wait_devready(aml_chip, 0);

	/* Read the flash type */
	aml_type = aml_nand_get_flash_type(mtd, chip, busw, &nand_maf_id);

	if (IS_ERR(aml_type)) {
		aml_nand_debug(KERN_WARNING "No NAND device found!!!\n");
		chip->select_chip(mtd, -1);
		return PTR_ERR(aml_type);
	}
	aml_chip->mfr_type = aml_type->id[0];

	/* Check for a chip array */
	for (i = 1; i < maxchips; i++) {
		aml_chip->aml_nand_select_chip(aml_chip, i);
		chip->cmdfunc(mtd, NAND_CMD_RESET, -1, -1);
		aml_chip->aml_nand_wait_devready(aml_chip, i);
		/* Send the command for reading device ID */
		chip->cmdfunc(mtd, NAND_CMD_READID, 0x00, -1);
		/* Read manufacturer and device IDs */

		if (nand_maf_id != chip->read_byte(mtd) || aml_type->id[1] != chip->read_byte(mtd))
		//if (nand_maf_id != dev_id[0] || aml_type->id[1] != dev_id[1])
			aml_chip->valid_chip[i] = 0;
		else
			valid_chip_num ++;
	}
	if (i > 1) {
		aml_nand_debug(KERN_INFO "%d NAND chips detected\n", valid_chip_num);
		/*if ((aml_chip->valid_chip[1] == 0) && (aml_chip->valid_chip[2] == 1)) {
			aml_nand_debug("ce1 and ce2 connected\n");
			aml_chip->chip_enable[2] = (aml_chip->chip_enable[1] & aml_chip->chip_enable[2]);
		}*/
	}

	/* Store the number of chips and calc total size for mtd */
	chip->numchips = 1;
	if ((chip->chipsize >> 32) & 0xffffffff)
		chip->chip_shift = ffs((unsigned)(chip->chipsize >> 32)) * valid_chip_num + 32 - 1;
	else 
		chip->chip_shift = ffs((unsigned)chip->chipsize) * valid_chip_num - 1;

	chip->pagemask = ((chip->chipsize * valid_chip_num) >> chip->page_shift) - 1;
	//chip->options |= NAND_CACHEPRG;
	chip->options |= NAND_NO_SUBPAGE_WRITE;		
	aml_chip->internal_chipnr = aml_type->internal_chipnr;
	aml_chip->internal_page_nums = ((chip->chipsize / aml_chip->internal_chipnr) >> chip->page_shift);
	aml_chip->internal_chip_shift = fls((unsigned)aml_chip->internal_page_nums) - 1;
	temp_chip_shift = ffs((unsigned)aml_chip->internal_page_nums) - 1;
	if (aml_chip->internal_chip_shift != temp_chip_shift) {
		aml_chip->internal_chip_shift += 1;
		chip->chip_shift += 1;
		chip->pagemask = ((1 << (chip->chip_shift + 1)) >> chip->page_shift) - 1;
	}

	aml_chip->options = aml_type->options;
	aml_chip->page_size = aml_type->pagesize;
	aml_chip->block_size = aml_type->erasesize;
	aml_chip->oob_size = aml_type->oobsize;
	mtd->erasesize = valid_chip_num * aml_type->erasesize;
	mtd->writesize = valid_chip_num * aml_type->pagesize;
	mtd->oobsize = valid_chip_num * aml_type->oobsize;
	mtd->size = valid_chip_num * chip->chipsize;

	chip->cmdfunc = aml_nand_cmdfunc;
	chip->waitfunc = aml_nand_wait;
	chip->erase_cmd = aml_nand_erase_cmd;
	chip->write_page = aml_nand_write_page;

	return 0;
}

int aml_nand_scan(struct mtd_info *mtd, int maxchips)
{
	int ret;

	ret = aml_nand_scan_ident(mtd, maxchips);
	if (!ret)
		ret = nand_scan_tail(mtd);
	return ret;
}

static uint8_t aml_nand_get_onfi_features(struct aml_nand_chip *aml_chip, uint8_t *buf, int addr)
{
	struct nand_chip *chip = &aml_chip->chip;
	struct mtd_info *mtd = &aml_chip->mtd;
	int i;

	for (i=0; i<aml_chip->chip_num; i++) {

		if (aml_chip->valid_chip[i]) {

			aml_chip->aml_nand_select_chip(aml_chip, i);

			chip->cmd_ctrl(mtd, NAND_CMD_GET_FEATURES, NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);
			chip->cmd_ctrl(mtd, addr, NAND_NCE |NAND_ALE|  NAND_CTRL_CHANGE);
			chip->waitfunc(mtd, chip);
			chip->cmd_ctrl(mtd, 0, NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);			
			
			aml_platform_read_bytes(mtd, buf, 4);
		}
	}

	return 0;
}

static void aml_nand_set_onfi_features(struct aml_nand_chip *aml_chip,  uint8_t *buf, int addr)
{
	struct nand_chip *chip = &aml_chip->chip;
	struct mtd_info *mtd = &aml_chip->mtd;
	int i;

	for (i=0; i<aml_chip->chip_num; i++) {

		if (aml_chip->valid_chip[i]) {

			aml_chip->aml_nand_select_chip(aml_chip, i);
			
			chip->cmd_ctrl(mtd, NAND_CMD_SET_FEATURES, NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);
			chip->cmd_ctrl(mtd, addr, NAND_NCE |NAND_ALE|  NAND_CTRL_CHANGE);

			aml_platform_write_bytes(mtd, buf, 4);
			chip->waitfunc(mtd, chip);
		}
	}
}

static int aml_onfi_timingsetting(struct aml_nand_chip *aml_chip)
{
	struct aml_nand_platform *plat = aml_chip->platform;
	struct nand_chip *chip = &aml_chip->chip;
	struct mtd_info *mtd = aml_chip->mtd;

//	if(aml_chip->mfr_type == NAND_MFR_MICRON)
	{
		uint8_t	P[4];
		int sync =plat->platform_nand_data.chip.options&NAND_SYNC_OPTIONS_MASK;

		memset(P,0,4);

		P[0] = ( aml_chip->options& NAND_TIMING_OPTIONS_MASK) >> 8|(sync?(1<<4):0);
		memcpy(aml_chip->aml_nand_data_buf , P,4);	
		chip->cmd_ctrl(mtd, NAND_CMD_SET_FEATURES, NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);
		chip->cmd_ctrl(mtd, 0x1, NAND_NCE |NAND_ALE|  NAND_CTRL_CHANGE);
		aml_platform_write_bytes(mtd, aml_chip->aml_nand_data_buf, 4);
		chip->waitfunc(mtd, chip);
		
		chip->cmd_ctrl(mtd, NAND_CMD_GET_FEATURES, NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);
		chip->cmd_ctrl(mtd, 0x1, NAND_NCE |NAND_ALE|  NAND_CTRL_CHANGE);
		chip->waitfunc(mtd, chip);
		chip->cmd_ctrl(mtd, 0, NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);

		aml_platform_read_bytes(mtd, aml_chip->aml_nand_data_buf, 4);
		if (memcmp(aml_chip->aml_nand_data_buf, P,4)) {
			int i=0;
			
			printk ("write:" );
			for(i=0;i<4;i++)
				printk ("0x%x ",P[i] );
			printk ("read:" );
			for(i=0;i<4;i++)
				printk ("0x%x ",aml_chip->aml_nand_data_buf[i] );
			return 0;	
		}
		if(sync){
//			int syncmask= ( aml_chip->mfr_type==NAND_MFR_MICRON )?NAND_SYNC_MODE:NAND_TOGGLE_MODE ;
			SET_CBUS_REG_MASK(NAND_CFG,(1<<16)|(NAND_SYNC_MODE<<10));
			NFC_SEND_CMD_STANDBY(3);
			aml_chip->ops_mode |= AML_SYNC_MODE;
			printk ("sync setting ok\n");
		}
		else{
			printk ("async setting ok\n");
		}
	}
}


static int aml_toggle_timingsetting(struct aml_nand_chip *aml_chip)
{
	struct aml_nand_platform *plat = aml_chip->platform;
	{
		uint8_t	P[4];
		int sync =plat->platform_nand_data.chip.options&NAND_SYNC_OPTIONS_MASK;

		memset(P,0,4);

#if  0
	struct nand_chip *chip = &aml_chip->chip;
	struct mtd_info *mtd = aml_chip->mtd;
		P[0] =  (sync?(0x06):0);
		P[1] =  (sync?(0x00):0);
		memcpy(aml_chip->aml_nand_data_buf , P,4);	
		chip->cmd_ctrl(mtd, NAND_CMD_SET_FEATURES, NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);
		chip->cmd_ctrl(mtd, 0x2, NAND_NCE |NAND_ALE|  NAND_CTRL_CHANGE);
		aml_platform_write_bytes(mtd, aml_chip->aml_nand_data_buf, 4);
		chip->waitfunc(mtd, chip);
		
		chip->cmd_ctrl(mtd, NAND_CMD_GET_FEATURES, NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);
		chip->cmd_ctrl(mtd, 0x2, NAND_NCE |NAND_ALE|  NAND_CTRL_CHANGE);
//		chip->waitfunc(mtd, chip);
//		chip->cmd_ctrl(mtd, 0, NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);

		aml_platform_read_bytes(mtd, aml_chip->aml_nand_data_buf, 4);
		if (memcmp(aml_chip->aml_nand_data_buf, P,4)) {
			int i=0;
			
			printk ("write:" );
			for(i=0;i<4;i++)
				printk ("0x%x ",P[i] );
			printk ("read:" );
			for(i=0;i<4;i++)
				printk ("0x%x ",aml_chip->aml_nand_data_buf[i] );
//			return ;	
		}
#endif
		if(sync){
			SET_CBUS_REG_MASK(NAND_CFG,(1<<16)|(NAND_TOGGLE_MODE<<10));
			NFC_SEND_CMD_STANDBY(3);
			aml_chip->ops_mode |= AML_SYNC_MODE;
		}
		

		if(sync){
			printk ("sync setting ok\n");
		}
		else{
			printk ("async setting ok\n");
		}
	}
	return 0;
}


int aml_nand_init(struct aml_nand_chip *aml_chip)
{
	struct aml_nand_platform *plat = aml_chip->platform;
	struct nand_chip *chip = &aml_chip->chip;
	struct mtd_info *mtd = aml_chip->mtd;
	int err = 0, i = 0;
	
	aml_chip->ran_mode=plat->ran_mode; 				//def close, for all part
	aml_chip->rbpin_mode=plat->rbpin_mode;
    aml_chip->short_pgsz=plat->short_pgsz;

	switch (plat->platform_nand_data.chip.options & NAND_ECC_OPTIONS_MASK) {

		case NAND_ECC_SOFT_MODE:
			chip->write_buf = aml_nand_dma_write_buf;
			chip->read_buf = aml_nand_dma_read_buf;
			chip->ecc.read_page_raw = aml_nand_read_page_raw;
			chip->ecc.write_page_raw = aml_nand_write_page_raw;
			chip->ecc.mode = NAND_ECC_SOFT;
			aml_chip->user_byte_mode = 1;
			aml_chip->bch_mode = 0;
			break;

		case NAND_ECC_BCH8_512_MODE:
			chip->write_buf = aml_nand_dma_write_buf;
			chip->read_buf = aml_nand_dma_read_buf;
			chip->block_bad = aml_nand_block_bad;
			chip->block_markbad = aml_nand_block_markbad;
			chip->ecc.mode = NAND_ECC_HW;
			chip->ecc.size = NAND_ECC_UNIT_SIZE;				//our hardware ecc unit is 512bytes
			chip->ecc.bytes = NAND_BCH8_512_ECC_SIZE;
			chip->ecc.read_page_raw = aml_nand_read_page_raw;
			chip->ecc.write_page_raw = aml_nand_write_page_raw;
			chip->ecc.read_page = aml_nand_read_page_hwecc;
			chip->ecc.write_page = aml_nand_write_page_hwecc;
			chip->ecc.read_oob  = aml_nand_read_oob;
			chip->ecc.write_oob = aml_nand_write_oob;
			aml_chip->bch_mode = NAND_ECC_BCH8_512;
			aml_chip->user_byte_mode = 2;
			break;

		case NAND_ECC_BCH8_1K_MODE:
			chip->write_buf = aml_nand_dma_write_buf;
			chip->read_buf = aml_nand_dma_read_buf;
			chip->block_bad = aml_nand_block_bad;
			chip->block_markbad = aml_nand_block_markbad;
			chip->ecc.mode = NAND_ECC_HW;
			chip->ecc.size = NAND_ECC_UNIT_1KSIZE;
			chip->ecc.bytes = NAND_BCH8_1K_ECC_SIZE;
			chip->ecc.read_page_raw = aml_nand_read_page_raw;
			chip->ecc.write_page_raw = aml_nand_write_page_raw;
			chip->ecc.read_page = aml_nand_read_page_hwecc;
			chip->ecc.write_page = aml_nand_write_page_hwecc;
			chip->ecc.read_oob  = aml_nand_read_oob;
			chip->ecc.write_oob = aml_nand_write_oob;
			aml_chip->bch_mode = NAND_ECC_BCH8_1K;
			aml_chip->user_byte_mode = 2;
			break;

		case NAND_ECC_BCH30_MODE:
			chip->write_buf = aml_nand_dma_write_buf;
			chip->read_buf = aml_nand_dma_read_buf;
			chip->block_bad = aml_nand_block_bad;
			chip->block_markbad = aml_nand_block_markbad;
			chip->ecc.mode = NAND_ECC_HW;
			chip->ecc.size = NAND_ECC_UNIT_1KSIZE;
			chip->ecc.bytes = NAND_BCH30_ECC_SIZE;
			chip->ecc.read_page_raw = aml_nand_read_page_raw;
			chip->ecc.write_page_raw = aml_nand_write_page_raw;
			chip->ecc.read_page = aml_nand_read_page_hwecc;
			chip->ecc.write_page = aml_nand_write_page_hwecc;
			chip->ecc.read_oob  = aml_nand_read_oob;
			chip->ecc.write_oob = aml_nand_write_oob;
			aml_chip->bch_mode = NAND_ECC_BCH30;
			aml_chip->user_byte_mode = 2;
			break;

		case NAND_ECC_BCH40_MODE:
			chip->write_buf = aml_nand_dma_write_buf;
			chip->read_buf = aml_nand_dma_read_buf;
			chip->block_bad = aml_nand_block_bad;
			chip->block_markbad = aml_nand_block_markbad;
			chip->ecc.mode = NAND_ECC_HW;
			chip->ecc.size = NAND_ECC_UNIT_1KSIZE;
			chip->ecc.bytes = NAND_BCH40_ECC_SIZE;
			chip->ecc.read_page_raw = aml_nand_read_page_raw;
			chip->ecc.write_page_raw = aml_nand_write_page_raw;
			chip->ecc.read_page = aml_nand_read_page_hwecc;
			chip->ecc.write_page = aml_nand_write_page_hwecc;
			chip->ecc.read_oob  = aml_nand_read_oob;
			chip->ecc.write_oob = aml_nand_write_oob;
			aml_chip->bch_mode = NAND_ECC_BCH40;
			aml_chip->user_byte_mode = 2;
			break;

		case NAND_ECC_BCH60_MODE:
			chip->write_buf = aml_nand_dma_write_buf;
			chip->read_buf = aml_nand_dma_read_buf;
			chip->block_bad = aml_nand_block_bad;
			chip->block_markbad = aml_nand_block_markbad;
			chip->ecc.mode = NAND_ECC_HW;
			chip->ecc.size = NAND_ECC_UNIT_1KSIZE;
			chip->ecc.bytes = NAND_BCH60_ECC_SIZE;
			chip->ecc.read_page_raw = aml_nand_read_page_raw;
			chip->ecc.write_page_raw = aml_nand_write_page_raw;
			chip->ecc.read_page = aml_nand_read_page_hwecc;
			chip->ecc.write_page = aml_nand_write_page_hwecc;
			chip->ecc.read_oob  = aml_nand_read_oob;
			chip->ecc.write_oob = aml_nand_write_oob;
			aml_chip->bch_mode = NAND_ECC_BCH60;
			aml_chip->user_byte_mode = 2;
			break;

		case NAND_ECC_SHORT_MODE:
			chip->write_buf = aml_nand_dma_write_buf;
			chip->read_buf = aml_nand_dma_read_buf;
			chip->block_bad = aml_nand_block_bad;
			chip->block_markbad = aml_nand_block_markbad;
			chip->ecc.mode = NAND_ECC_HW;
			chip->ecc.size = NAND_ECC_UNIT_SHORT;
			chip->ecc.bytes = NAND_BCH60_ECC_SIZE;
			chip->ecc.read_page_raw = aml_nand_read_page_raw;
			chip->ecc.write_page_raw = aml_nand_write_page_raw;
			chip->ecc.read_page = aml_nand_read_page_hwecc;
			chip->ecc.write_page = aml_nand_write_page_hwecc;
			chip->ecc.read_oob  = aml_nand_read_oob;
			chip->ecc.write_oob = aml_nand_write_oob;
			aml_chip->bch_mode = NAND_ECC_BCH60;
			aml_chip->short_pgsz = 1;
			aml_chip->user_byte_mode = 2;
			break;
			
		case NAND_ECC_BCH16_MODE:
			chip->write_buf = aml_nand_dma_write_buf;
			chip->read_buf = aml_nand_dma_read_buf;
			chip->block_bad = aml_nand_block_bad;
			chip->block_markbad = aml_nand_block_markbad;
			chip->ecc.mode = NAND_ECC_HW;
			chip->ecc.size = NAND_ECC_UNIT_1KSIZE;
			chip->ecc.bytes = NAND_BCH16_ECC_SIZE;
			chip->ecc.read_page_raw = aml_nand_read_page_raw;
			chip->ecc.write_page_raw = aml_nand_write_page_raw;
			chip->ecc.read_page = aml_nand_read_page_hwecc;
			chip->ecc.write_page = aml_nand_write_page_hwecc;
			chip->ecc.read_oob  = aml_nand_read_oob;
			chip->ecc.write_oob = aml_nand_write_oob;
			aml_chip->bch_mode = NAND_ECC_BCH16;
			aml_chip->user_byte_mode = 2;
			break;

		case NAND_ECC_BCH24_MODE:
			chip->write_buf = aml_nand_dma_write_buf;
			chip->read_buf = aml_nand_dma_read_buf;
			chip->block_bad = aml_nand_block_bad;
			chip->block_markbad = aml_nand_block_markbad;
			chip->ecc.mode = NAND_ECC_HW;
			chip->ecc.size = NAND_ECC_UNIT_1KSIZE;
			chip->ecc.bytes = NAND_BCH24_ECC_SIZE;
			chip->ecc.read_page_raw = aml_nand_read_page_raw;
			chip->ecc.write_page_raw = aml_nand_write_page_raw;
			chip->ecc.read_page = aml_nand_read_page_hwecc;
			chip->ecc.write_page = aml_nand_write_page_hwecc;
			chip->ecc.read_oob  = aml_nand_read_oob;
			chip->ecc.write_oob = aml_nand_write_oob;
			aml_chip->bch_mode = NAND_ECC_BCH24;
			aml_chip->user_byte_mode = 2;
			break;

		default :
			aml_nand_debug(KERN_WARNING "haven`t found any ecc mode just selected NAND_ECC_NONE\n");
			chip->write_buf = aml_nand_dma_write_buf;
			chip->read_buf = aml_nand_dma_read_buf;
			chip->ecc.read_page_raw = aml_nand_read_page_raw;
			chip->ecc.write_page_raw = aml_nand_write_page_raw;
			chip->ecc.mode = NAND_ECC_NONE;
			aml_chip->user_byte_mode = 1;
			aml_chip->bch_mode = 0;
			break;
	}

	if (!aml_chip->aml_nand_hw_init)
		aml_chip->aml_nand_hw_init = aml_platform_hw_init;
	if (!aml_chip->aml_nand_options_confirm)
		aml_chip->aml_nand_options_confirm = aml_platform_options_confirm;
	if (!aml_chip->aml_nand_cmd_ctrl)
		aml_chip->aml_nand_cmd_ctrl = aml_platform_cmd_ctrl;
	if (!aml_chip->aml_nand_select_chip)
		aml_chip->aml_nand_select_chip = aml_platform_select_chip;
	if (!aml_chip->aml_nand_write_byte)
		aml_chip->aml_nand_write_byte = aml_platform_write_byte;
	if (!aml_chip->aml_nand_wait_devready)
		aml_chip->aml_nand_wait_devready = aml_platform_wait_devready;
	if (!aml_chip->aml_nand_get_user_byte)
		aml_chip->aml_nand_get_user_byte = aml_platform_get_user_byte;
	if (!aml_chip->aml_nand_set_user_byte)
		aml_chip->aml_nand_set_user_byte = aml_platform_set_user_byte;
	if (!aml_chip->aml_nand_command)
		aml_chip->aml_nand_command = aml_nand_base_command;
	if (!aml_chip->aml_nand_dma_read)
		aml_chip->aml_nand_dma_read = aml_platform_dma_read;
	if (!aml_chip->aml_nand_dma_write)
		aml_chip->aml_nand_dma_write = aml_platform_dma_write;
	if (!aml_chip->aml_nand_hwecc_correct)
		aml_chip->aml_nand_hwecc_correct = aml_platform_hwecc_correct;

	if (!chip->IO_ADDR_R)
		chip->IO_ADDR_R = (void __iomem *) CBUS_REG_ADDR(NAND_BUF);
	if (!chip->IO_ADDR_W)
		chip->IO_ADDR_W = (void __iomem *) CBUS_REG_ADDR(NAND_BUF);

	chip->options |=  NAND_SKIP_BBTSCAN;
	if (chip->ecc.mode != NAND_ECC_SOFT) {
		if (aml_chip->user_byte_mode == 2)
			chip->ecc.layout = &aml_nand_oob_64_2info;
		else
			chip->ecc.layout = &aml_nand_oob_64;
	}

	chip->select_chip = aml_nand_select_chip;
	chip->cmd_ctrl = aml_nand_cmd_ctrl;
#if CONFIG_AM_NAND_RBPIN
	chip->dev_ready = aml_nand_dev_ready;
#endif
	chip->verify_buf = aml_nand_verify_buf;
	chip->read_byte = aml_platform_read_byte;

	aml_chip->chip_num = plat->platform_nand_data.chip.nr_chips;

	return 0;
}


int aml_nand_probe(struct mtd_info *mtd)
{	
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);	
	struct nand_chip *chip = &aml_chip->chip;	
	struct aml_nand_platform *plat = aml_chip->platform;
	int err = 0, i = 0;
	
	if(aml_chip->mfr_type != 0)   // probed finish
		return 0;
		
	if (aml_chip->chip_num > MAX_CHIP_NUM) {
		aml_nand_debug("couldn`t support for so many chips\n");
		err = -ENXIO;
		goto exit_error;
	}
	for (i=0; i<aml_chip->chip_num; i++) {
		aml_chip->valid_chip[i] = 1;
		aml_chip->chip_enable[i] = (((plat->chip_enable_pad >> i*4) & 0xf) << 10);
		aml_chip->rb_enable[i] = (((plat->ready_busy_pad >> i*4) & 0xf) << 10);
		/*if ((i > 0) && (aml_chip->rb_enable[i] == aml_chip->rb_enable[0])) {
			aml_chip->ops_mode = AML_MULTI_CHIP_SHARE_RB;
		}*/
	}

	aml_chip->aml_nand_hw_init(aml_chip);

	if (nand_scan(mtd, aml_chip->chip_num) == -ENODEV) {
		chip->options = 0;
		chip->options |=  NAND_SKIP_BBTSCAN;
		if (aml_nand_scan(mtd, aml_chip->chip_num)) {
			err = -ENXIO;
			goto exit_error;
		}
	}
	else {
		for (i=1; i<aml_chip->chip_num; i++) {
			aml_chip->valid_chip[i] = 0;
		}
		aml_chip->options = NAND_DEFAULT_OPTIONS;
		aml_chip->page_size = mtd->writesize;
		aml_chip->block_size = mtd->erasesize;
		aml_chip->oob_size = mtd->oobsize;
		aml_chip->plane_num = 1;
		aml_chip->internal_chipnr = 1;
		chip->ecc.read_page_raw = aml_nand_read_page_raw;
		chip->ecc.write_page_raw = aml_nand_write_page_raw;
	}

	if (chip->ecc.mode != NAND_ECC_SOFT) {
		if (aml_chip->aml_nand_options_confirm(aml_chip)) {
			err = -ENXIO;
			goto exit_error;
		}
	}

	if (plat->platform_nand_data.chip.ecclayout) {
		chip->ecc.layout = plat->platform_nand_data.chip.ecclayout;
	}
	else {

		if (!strncmp((char*)plat->name, NAND_BOOT_NAME, strlen((const char*)NAND_BOOT_NAME))) {
			chip->ecc.layout = &aml_nand_uboot_oob;
		}
		else if (chip->ecc.mode != NAND_ECC_SOFT) {
			switch (mtd->oobsize) {

				case 64:
					chip->ecc.layout = &aml_nand_oob_64_2info;
					break;
				case 128:
					chip->ecc.layout = &aml_nand_oob_128;
					break;
				case 218:
					chip->ecc.layout = &aml_nand_oob_218;
					break;
				case 224:
					chip->ecc.layout = &aml_nand_oob_224;
					printk("ecc layeout select aml_nand_oob_224\n");
					break;
				case 256:
					chip->ecc.layout = &aml_nand_oob_256;
					break;
				case 376:
					chip->ecc.layout = &aml_nand_oob_376;
					break;
				case 436:
					chip->ecc.layout = &aml_nand_oob_436;
					break;				
				case 448:
					chip->ecc.layout = &aml_nand_oob_448;
					printk("ecc layeout select aml_nand_oob_448\n");
					break;
				case 752:
					chip->ecc.layout = &aml_nand_oob_752;
					break;
				case 872:
					chip->ecc.layout = &aml_nand_oob_872;
					break;
				case 896:
					chip->ecc.layout = &aml_nand_oob_896;
					break;
				case 1024:
						chip->ecc.layout = &aml_nand_oob_1024;
						break;
				case 1504:
					chip->ecc.layout = &aml_nand_oob_1504;
					break;
				case 1744:
					chip->ecc.layout = &aml_nand_oob_1744;
					break;
				case 1792:
					chip->ecc.layout = &aml_nand_oob_1792;
					break;
				case 3008:
					chip->ecc.layout = &aml_nand_oob_3008;
					break;
				case 3584:
					chip->ecc.layout = &aml_nand_oob_3584;
					break;
				default:
					aml_nand_debug("havn`t found any oob layout use nand base oob layout " "oobsize %d\n", mtd->oobsize);
					chip->ecc.layout = &aml_nand_oob_64_2info;
					break;
			}
		}
	}

	/*
	 * The number of bytes available for a client to place data into
	 * the out of band area
	 */
	chip->ecc.layout->oobavail = 0;
	for (i = 0; chip->ecc.layout->oobfree[i].length && i < ARRAY_SIZE(chip->ecc.layout->oobfree); i++)
		chip->ecc.layout->oobavail += chip->ecc.layout->oobfree[i].length;
	mtd->oobavail = chip->ecc.layout->oobavail;
	mtd->ecclayout = chip->ecc.layout;

	aml_chip->virtual_page_size = mtd->writesize;
	aml_chip->virtual_block_size = mtd->erasesize;

//	aml_chip->aml_nand_data_buf = dma_alloc_coherent(aml_chip->device, (mtd->writesize + mtd->oobsize), &aml_chip->data_dma_addr, GFP_KERNEL);
	aml_chip->aml_nand_data_buf=kzalloc((mtd->writesize + mtd->oobsize+64),GFP_KERNEL);
	if (aml_chip->aml_nand_data_buf == NULL) {
		aml_nand_debug("no memory for flash data buf\n");
		err = -ENOMEM;
		goto exit_error;
	}else{
	
		if(((unsigned)aml_chip->aml_nand_data_buf%64)!=0)
		{
			unsigned char * ptmp=aml_chip->aml_nand_data_buf;
			ptmp+=64-(((unsigned )aml_chip->aml_nand_data_buf%64));
			aml_chip->aml_nand_data_buf=ptmp;
		}	
		//aml_nand_debug("aml_nand_data_buf addr is 0x%x\n", (unsigned int)aml_chip->aml_nand_data_buf);
	
	}

/*	aml_chip->user_info_buf = dma_alloc_coherent(aml_chip->device, (mtd->writesize / chip->ecc.size)*2*sizeof(int)+64,
		   	&(aml_chip->nand_info_dma_addr), GFP_KERNEL);
*/
	aml_chip->user_info_buf = kzalloc((mtd->writesize/chip->ecc.size)*PER_INFO_BYTE+64,GFP_KERNEL);

	if (aml_chip->user_info_buf == NULL) {
		aml_nand_debug("no memory for flash info buf\n");
		err = -ENOMEM;
		goto exit_error;
	}else{

		if(((unsigned)aml_chip->user_info_buf%64)!=0)
		{
			unsigned char * ptmp1=(unsigned char *)aml_chip->user_info_buf;
			ptmp1+=64-(((unsigned )aml_chip->user_info_buf%64));
			aml_chip->user_info_buf=(unsigned *)ptmp1;
		}
		//aml_nand_debug("user_info_buf addr is 0x%p\n",aml_chip->user_info_buf);
		
	}

	if (chip->buffers)
		kfree(chip->buffers);
	if (mtd->oobsize >= NAND_MAX_OOBSIZE)
	chip->buffers = kzalloc((mtd->writesize + 3*mtd->oobsize), GFP_KERNEL);
	else
		chip->buffers = kzalloc((mtd->writesize + 3*NAND_MAX_OOBSIZE), GFP_KERNEL);
	if (chip->buffers == NULL) {
		aml_nand_debug("no memory for flash data buf\n");
		err = -ENOMEM;
		goto exit_error;
	}
	chip->oob_poi = chip->buffers->databuf + mtd->writesize;
	chip->options |= NAND_OWN_BUFFERS;

//#ifdef CONFIG_MTD_DEVICE
	add_mtd_device(mtd);
//#endif

	if(aml_chip->mfr_type==NAND_MFR_SAMSUNG ||aml_chip->mfr_type ==NAND_MFR_TOSHIBA)
		aml_toggle_timingsetting(aml_chip);
	else
		aml_onfi_timingsetting(aml_chip);

	aml_nand_debug(" %s initialized ok\n",  mtd->name);
	return 0;

exit_error:
	if (aml_chip->user_info_buf) 
	{
		//dma_free_coherent(aml_chip->device, (mtd->writesize / chip->ecc.size)*sizeof(int), aml_chip->user_info_buf, (dma_addr_t)aml_chip->nand_info_dma_addr);
		kfree(aml_chip->user_info_buf);
		aml_chip->user_info_buf = NULL;
	}
	
	if (chip->buffers) {
		kfree(chip->buffers);
		chip->buffers = NULL;
	}
	
	if (aml_chip->aml_nand_data_buf) 
	{
	//	dma_free_coherent(aml_chip->device, (mtd->writesize + mtd->oobsize), aml_chip->aml_nand_data_buf, (dma_addr_t)aml_chip->data_dma_addr);
		kfree(aml_chip->aml_nand_data_buf);
		aml_chip->aml_nand_data_buf = NULL;
	}
	aml_chip->mfr_type=0;
	return err;
}

#define DRV_NAME	"aml-nand"
#define DRV_VERSION	"1.0"
#define DRV_AUTHOR	"xiaojun_yoyo"
#define DRV_DESC	"Amlogic nand flash host controll driver for A3"



