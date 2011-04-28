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
#include <asm/arch/poc.h>

#include "version.h"
int nand_curr_device = -1;
//extern struct aml_nand_platform aml_nand_platform[];
extern struct aml_nand_device aml_nand_mid_device;
#define CONFIG_SYS_NAND_MAX_DEVICE 		4
nand_info_t *nand_info[CONFIG_SYS_NAND_MAX_DEVICE]={0};
#ifdef CONFIG_MTD_DEVICE
static __attribute__((unused)) char dev_name[CONFIG_SYS_MAX_NAND_DEVICE][8];
#endif

static char *aml_nand_plane_string[]={
	"NAND_SINGLE_PLANE_MODE",
	"NAND_TWO_PLANE_MODE",
};

static char *aml_nand_internal_string[]={
	"NAND_NONE_INTERLEAVING_MODE",
	"NAND_INTERLEAVING_MODE",
};

#define ECC_INFORMATION(name_a, bch_a, size_a, parity_a, user_a) {                \
        .name=name_a, .bch_mode=bch_a, .bch_unit_size=size_a, .bch_bytes=parity_a, .user_byte_mode=user_a    \
    }
static struct aml_nand_bch_desc m3_bch_list[] = {
	[0]=ECC_INFORMATION("NAND_RAW_MODE", NAND_ECC_SOFT_MODE, 0, 0, 0),
	[1]=ECC_INFORMATION("NAND_SHORT_MODE" ,NAND_ECC_SHORT_MODE, NAND_ECC_UNIT_SHORT, NAND_BCH60_1K_ECC_SIZE, 2),
	[2]=ECC_INFORMATION("NAND_BCH8_MODE", NAND_ECC_BCH8_MODE, NAND_ECC_UNIT_SIZE, NAND_BCH8_ECC_SIZE, 2),
	[3]=ECC_INFORMATION("NAND_BCH24_1K_MODE" ,NAND_ECC_BCH24_1K_MODE, NAND_ECC_UNIT_1KSIZE, NAND_BCH24_1K_ECC_SIZE, 2),
	[4]=ECC_INFORMATION("NAND_BCH30_1K_MODE" ,NAND_ECC_BCH30_1K_MODE, NAND_ECC_UNIT_1KSIZE, NAND_BCH30_1K_ECC_SIZE, 2),
	[5]=ECC_INFORMATION("NAND_BCH40_1K_MODE" ,NAND_ECC_BCH40_1K_MODE, NAND_ECC_UNIT_1KSIZE, NAND_BCH40_1K_ECC_SIZE, 2),
	[6]=ECC_INFORMATION("NAND_BCH60_1K_MODE" ,NAND_ECC_BCH60_1K_MODE, NAND_ECC_UNIT_1KSIZE, NAND_BCH60_1K_ECC_SIZE, 2),
};

extern uint8_t nand_boot_flag;
#ifdef MX_REVD
unsigned char pagelist_hynix256[128] = {
	0x00, 0x01, 0x02, 0x03, 0x06, 0x07, 0x0A, 0x0B,
	0x0E, 0x0F, 0x12, 0x13, 0x16, 0x17, 0x1A, 0x1B,
	0x1E, 0x1F, 0x22, 0x23, 0x26, 0x27, 0x2A, 0x2B,
	0x2E, 0x2F, 0x32, 0x33, 0x36, 0x37, 0x3A, 0x3B,

	0x3E, 0x3F, 0x42, 0x43, 0x46, 0x47, 0x4A, 0x4B,	
	0x4E, 0x4F, 0x52, 0x53, 0x56, 0x57, 0x5A, 0x5B,
	0x5E, 0x5F, 0x62, 0x63, 0x66, 0x67, 0x6A, 0x6B,
	0x6E, 0x6F, 0x72, 0x73, 0x76, 0x77, 0x7A, 0x7B,
	
	0x7E, 0x7F, 0x82, 0x83, 0x86, 0x87, 0x8A, 0x8B,
	0x8E, 0x8F, 0x92, 0x93, 0x96, 0x97, 0x9A, 0x9B,
	0x9E, 0x9F, 0xA2, 0xA3, 0xA6, 0xA7, 0xAA, 0xAB,
	0xAE, 0xAF, 0xB2, 0xB3, 0xB6, 0xB7, 0xBA, 0xBB,

	0xBE, 0xBF, 0xC2, 0xC3, 0xC6, 0xC7, 0xCA, 0xCB,
	0xCE, 0xCF, 0xD2, 0xD3, 0xD6, 0xD7, 0xDA, 0xDB,
	0xDE, 0xDF, 0xE2, 0xE3, 0xE6, 0xE7, 0xEA, 0xEB,
	0xEE, 0xEF, 0xF2, 0xF3, 0xF6, 0xF7, 0xFA, 0xFB,
};
unsigned char pagelist_1ynm_hynix256[128] = {
	0x00, 0x01, 0x03, 0x05, 0x07, 0x09, 0x0b, 0x0d,
	0x0f, 0x11, 0x13, 0x15, 0x17, 0x19, 0x1b, 0x1d,
	0x1f, 0x21, 0x23, 0x25, 0x27, 0x29, 0x2b, 0x2d,
	0x2f, 0x31, 0x33, 0x35, 0x37, 0x39, 0x3b, 0x3d,
	0x3f, 0x41, 0x43, 0x45, 0x47, 0x49, 0x4b, 0x4d,	
	0x4f, 0x51, 0x53, 0x55, 0x57, 0x59, 0x5b, 0x5d,
	0x5f, 0x61, 0x63, 0x65, 0x67, 0x69, 0x6b, 0x6d,
	0x6f, 0x71, 0x73, 0x75, 0x77, 0x79, 0x7b, 0x7d,
	0x7f, 0x81, 0x83, 0x85, 0x87, 0x89, 0x8b, 0x8d,
	0x8f, 0x91, 0x93, 0x95, 0x97, 0x99, 0x9b, 0x9d,
	0x9f, 0xa1, 0xA3, 0xA5, 0xA7, 0xA9, 0xAb, 0xAd,
	0xAf, 0xb1, 0xB3, 0xB5, 0xB7, 0xB9, 0xBb, 0xBd,
	0xBf, 0xc1, 0xC3, 0xC5, 0xC7, 0xC9, 0xCb, 0xCd,
	0xCf, 0xd1, 0xD3, 0xD5, 0xD7, 0xD9, 0xDb, 0xDd,
	0xDf, 0xe1, 0xE3, 0xE5, 0xE7, 0xE9, 0xEb, 0xEd,
	0xEf, 0xf1, 0xF3, 0xF5, 0xF7, 0xF9, 0xFb, 0xFd,
};
#endif
static unsigned mx_nand_check_chiprevd(void)
{
    unsigned flag = 0;
    
    if(aml_mx_get_id() == MX_REV_D_ID){
        flag = 1;
    }
    
    //printk("checking ChiprevD :%d\n", flag);  
    
    return flag;    
}

static void m3_nand_select_chip(struct aml_nand_chip *aml_chip, int chipnr)
{
	int i;
	switch (chipnr) {
		case 0:
		case 1:
		case 2:
		case 3:
			aml_chip->chip_selected = aml_chip->chip_enable[chipnr];
			aml_chip->rb_received = aml_chip->rb_enable[chipnr];

			for (i=0; i<aml_chip->chip_num; i++) {

				if (aml_chip->valid_chip[i]) {

					if (!((aml_chip->chip_enable[i] >> 10) & 1))
						SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_2, (1 << 25));
					if (!((aml_chip->chip_enable[i] >> 10) & 2))
						SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_2, (1 << 24));
					if (!((aml_chip->chip_enable[i] >> 10) & 4))
						SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_2, (1 << 23));
					if (!((aml_chip->chip_enable[i] >> 10) & 8))
						SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_2, (1 << 22));

					if (((aml_chip->ops_mode & AML_CHIP_NONE_RB) == 0) && (aml_chip->rb_enable[i])){ 
						if (!((aml_chip->rb_enable[i] >> 10) & 1))
							SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_2, (1 << 17));
						if (!((aml_chip->rb_enable[i] >> 10) & 2))
							SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_2, (1 << 16));
					}
				}
			}

			NFC_SEND_CMD_IDLE(aml_chip->chip_selected, 0);

			break;

		default:
			BUG();
			aml_chip->chip_selected = CE_NOT_SEL;
			break;
	}
	return;
}

static void m3_nand_hw_init(struct aml_nand_chip *aml_chip)
{
	int sys_clk_rate, sys_time, start_cycle, end_cycle, bus_cycle, bus_timing, Tcycle, T_REA = DEFAULT_T_REA, T_RHOH = DEFAULT_T_RHOH;

	sys_clk_rate = get_clk81();
	sys_time = (10000 / (sys_clk_rate / 1000000));

	start_cycle = (((NAND_CYCLE_DELAY + T_REA * 10) * 10) / sys_time);
	start_cycle = (start_cycle + 9) / 10;

	for (bus_cycle = 4; bus_cycle <= MAX_CYCLE_NUM; bus_cycle++) {
		Tcycle = bus_cycle * sys_time;
		end_cycle = (((NAND_CYCLE_DELAY + Tcycle / 2 + T_RHOH * 10) * 10) / sys_time);
		end_cycle = end_cycle / 10;
		if ((((start_cycle >= 3) && (start_cycle <= ( bus_cycle + 1)))
			|| ((end_cycle >= 3) && (end_cycle <= (bus_cycle + 1))))
			&& (start_cycle <= end_cycle)) {
			break;
		}			
	}
	if (bus_cycle > MAX_CYCLE_NUM)
		return;

	bus_timing = (start_cycle + end_cycle) / 2;
	NFC_SET_CFG(0);
	NFC_SET_TIMING_ASYC(bus_timing, (bus_cycle - 1));
	NFC_SEND_CMD(1<<31);
	return;
}

static void m3_nand_adjust_timing(struct aml_nand_chip *aml_chip)
{
	int sys_clk_rate, sys_time, start_cycle, end_cycle, bus_cycle, bus_timing, Tcycle;

	if (!aml_chip->T_REA)
		aml_chip->T_REA = 20;
	if (!aml_chip->T_RHOH)
		aml_chip->T_RHOH = 15;

	sys_clk_rate = get_clk81();

	sys_time = (10000 / (sys_clk_rate / 1000000));
	start_cycle = (((NAND_CYCLE_DELAY + aml_chip->T_REA * 10) * 10) / sys_time);
	start_cycle = (start_cycle + 9) / 10;

//#ifndef CONFIG_AML_MESON_6
	for (bus_cycle = 4; bus_cycle <= MAX_CYCLE_NUM; bus_cycle++) {
		Tcycle = bus_cycle * sys_time;
		end_cycle = (((NAND_CYCLE_DELAY + Tcycle / 2 + aml_chip->T_RHOH * 10) * 10) / sys_time);
		end_cycle = end_cycle / 10;
		if ((((start_cycle >= 3) && (start_cycle <= ( bus_cycle + 1)))
			|| ((end_cycle >= 3) && (end_cycle <= (bus_cycle + 1))))
			&& (start_cycle <= end_cycle)) {
			break;
		}			
	}
	if (bus_cycle > MAX_CYCLE_NUM)
		return;

	bus_timing = (start_cycle + end_cycle) / 2;
//#ifndef CONFIG_AML_MESON_6
#if 1
	NFC_SET_CFG(0);

	NFC_SET_TIMING_ASYC(bus_timing, (bus_cycle - 1));
	NFC_SEND_CMD(1<<31);

#else

#if 0    
	for (bus_cycle = MAX_CYCLE_NUM; bus_cycle >= 4 ; bus_cycle--) {
		Tcycle = bus_cycle * sys_time;
		end_cycle = (((NAND_CYCLE_DELAY + Tcycle / 2 + aml_chip->T_RHOH * 10) * 10) / sys_time);
		end_cycle = end_cycle / 10;
		if ((((start_cycle >= 3) && (start_cycle <= ( bus_cycle + 1)))
			|| ((end_cycle >= 3) && (end_cycle <= (bus_cycle + 1))))
			&& (start_cycle <= end_cycle)) {
			break;
		}			
	}
	if (bus_cycle < 4)
		return;

	bus_timing = (start_cycle + end_cycle) / 2;
#endif	

	// enable NAND: pull up R and reset pinmux
	WRITE_CBUS_REG(PAD_PULL_UP_REG3,(READ_CBUS_REG(PAD_PULL_UP_REG3)|(0x1f<<12)|(0xff<<0)|(1<<10)));
	CLEAR_CBUS_REG_MASK(PERIPHS_PIN_MUX_6,(0x3f<<24));
	CLEAR_CBUS_REG_MASK(PERIPHS_PIN_MUX_5,((1<<0)|(1<<1)|(1<<2)|(1<<3)));
	CLEAR_CBUS_REG_MASK(PERIPHS_PIN_MUX_4,(0x7c<<24));
	WRITE_CBUS_REG(PERIPHS_PIN_MUX_2,(READ_CBUS_REG(PERIPHS_PIN_MUX_2)|(1<<26)|(1<<25)|(0xf<<18)|(1<<17)));

	NFC_SET_CFG(0);
	NFC_SET_TIMING_ASYC(10, 19);//9,19//10,16
	NFC_SEND_CMD(1<<31);
    // reset
    NFC_SEND_CMD(CE0 | IDLE);
    NFC_SEND_CMD(CE0 | CLE | 0xff);
    NFC_SEND_CMD(CE0 | IDLE | 10); // tWB 200/100 ns.
	NFC_SEND_CMD(RB | 3); 
	NFC_SEND_CMD(RB);

    NFC_SEND_CMD(CE0 | CLE | 0xEF);
    NFC_SEND_CMD(CE0 | ALE | 1);
    NFC_SEND_CMD(CE0 | IDLE | 3); // tADL
    NFC_SEND_CMD(CE0 | DWR | 4);//timming_mode
    NFC_SEND_CMD(CE0 | DWR | 0);
    NFC_SEND_CMD(CE0 | DWR | 0);
    NFC_SEND_CMD(CE0 | DWR | 0);
    NFC_SEND_CMD(CE0 | IDLE | 5); // tWB

    while ((NFC_READ_INFO()>>22&0x1f) > 0);
    //NFC_SET_TIMING_ASYC(5,4);
    NFC_SET_TIMING_ASYC(bus_timing, (bus_cycle-1));
    
#endif//#ifndef CONFIG_ARCH_MESON6

	printk("bus_cycle=%d, bus_timing=%d, start_cycle=%d, end_cycle=%d,system=%d.%dns\n",
		bus_cycle, bus_timing, start_cycle, end_cycle, sys_time/10, sys_time%10);
}

static int m3_nand_options_confirm(struct aml_nand_chip *aml_chip)
{
	struct mtd_info *mtd = &aml_chip->mtd;
	struct nand_chip *chip = &aml_chip->chip;
	struct aml_nand_platform *plat = aml_chip->platform;
	struct aml_nand_bch_desc *ecc_supports = aml_chip->bch_desc;
	unsigned max_bch_mode = aml_chip->max_bch_mode;
	unsigned options_selected = 0, options_support = 0, ecc_bytes, options_define, valid_chip_num = 0;
	int error = 0, i, j;

	options_selected = (plat->platform_nand_data.chip.options & NAND_ECC_OPTIONS_MASK);
	options_define = (aml_chip->options & NAND_ECC_OPTIONS_MASK);
	if(!strncmp((char*)plat->name, NAND_BOOT_NAME, strlen((const char*)NAND_BOOT_NAME))){
	aml_chip->boot_oob_fill_cnt = aml_chip->oob_size -(ecc_supports[1].bch_bytes + ecc_supports[1].user_byte_mode)*(aml_chip->page_size / ecc_supports[1].bch_unit_size);
		printk("m3:###aml_chip->boot_oob_fill_cnt =%d\n",aml_chip->boot_oob_fill_cnt);

	}
	for (i=0; i<max_bch_mode; i++) {
		if (ecc_supports[i].bch_mode == options_selected) {
			break;
		}
	}
	j = i;

    for(i=max_bch_mode-1; i>0; i--) 
    {
        ecc_bytes = aml_chip->oob_size / (aml_chip->page_size / ecc_supports[i].bch_unit_size);
        if(ecc_bytes >= ecc_supports[i].bch_bytes + ecc_supports[i].user_byte_mode)
        {
            options_support = ecc_supports[i].bch_mode;
            break;
        }
    }

	if (options_define != options_support) {
		options_define = options_support;
		//printk("define oob size: %d could support bch mode: %s\n", aml_chip->oob_size, ecc_supports[options_support].name);
	}

	if (options_selected > options_define) {
		printk("oob size is not enough for selected bch mode: %s force bch to mode: %s\n", ecc_supports[j].name,ecc_supports[i].name);
		options_selected = options_define;
	}
	
	aml_chip->oob_fill_cnt = aml_chip->oob_size -(ecc_supports[i].bch_bytes + ecc_supports[i].user_byte_mode)*(aml_chip->page_size / ecc_supports[i].bch_unit_size);
	printk("aml_chip->oob_fill_cnt =%d,aml_chip->oob_size =%d,bch_bytes =%d\n",aml_chip->oob_fill_cnt,aml_chip->oob_size,ecc_supports[i].bch_bytes);

	switch (options_selected) {

		case NAND_ECC_BCH8_MODE:
			chip->ecc.size = NAND_ECC_UNIT_SIZE;
			chip->ecc.bytes = NAND_BCH8_ECC_SIZE;
			aml_chip->bch_mode = NAND_ECC_BCH8;
			aml_chip->user_byte_mode = 2;
			chip->ecc.steps = mtd->writesize / chip->ecc.size;
			break;

		case NAND_ECC_BCH8_1K_MODE:
			chip->ecc.size = NAND_ECC_UNIT_1KSIZE;
			chip->ecc.bytes = NAND_BCH8_1K_ECC_SIZE;
			aml_chip->bch_mode = NAND_ECC_BCH8_1K;
			aml_chip->user_byte_mode = 2;
			break;

		case NAND_ECC_BCH16_1K_MODE:
			chip->ecc.size = NAND_ECC_UNIT_1KSIZE;
			chip->ecc.bytes = NAND_BCH16_1K_ECC_SIZE;
			aml_chip->bch_mode = NAND_ECC_BCH16_1K;
			aml_chip->user_byte_mode = 2;
			break;

		case NAND_ECC_BCH24_1K_MODE:
			chip->ecc.size = NAND_ECC_UNIT_1KSIZE;
			chip->ecc.bytes = NAND_BCH24_1K_ECC_SIZE;
			aml_chip->bch_mode = NAND_ECC_BCH24_1K;
			aml_chip->user_byte_mode = 2;
			break;

		case NAND_ECC_BCH30_1K_MODE:
			chip->ecc.size = NAND_ECC_UNIT_1KSIZE;
			chip->ecc.bytes = NAND_BCH30_1K_ECC_SIZE;
			aml_chip->bch_mode = NAND_ECC_BCH30_1K;
			aml_chip->user_byte_mode = 2;
			break;

		case NAND_ECC_BCH40_1K_MODE:
			chip->ecc.size = NAND_ECC_UNIT_1KSIZE;
			chip->ecc.bytes = NAND_BCH40_1K_ECC_SIZE;
			aml_chip->bch_mode = NAND_ECC_BCH40_1K;
			aml_chip->user_byte_mode = 2;
			break;

		case NAND_ECC_BCH60_1K_MODE:
			chip->ecc.size = NAND_ECC_UNIT_1KSIZE;
			chip->ecc.bytes = NAND_BCH60_1K_ECC_SIZE;
			aml_chip->bch_mode = NAND_ECC_BCH60_1K;
			aml_chip->user_byte_mode = 2;
			break;

		case NAND_ECC_SHORT_MODE:
			chip->ecc.size = NAND_ECC_UNIT_SHORT;
			chip->ecc.bytes = NAND_BCH60_1K_ECC_SIZE;
			aml_chip->bch_mode = NAND_ECC_BCH_SHORT;
			aml_chip->user_byte_mode = 2;
			chip->ecc.steps = mtd->writesize / 512;
			//chip->ecc.steps = 512 * 3 / NAND_ECC_UNIT_SHORT;
			break;

		default :
			if ((plat->platform_nand_data.chip.options & NAND_ECC_OPTIONS_MASK) != NAND_ECC_SOFT_MODE) {
				printk("soft ecc or none ecc just support in linux self nand base please selected it at platform options\n");
				error = -ENXIO;
			}
			break;
	}

	options_selected = (plat->platform_nand_data.chip.options & NAND_INTERLEAVING_OPTIONS_MASK);
	options_define = (aml_chip->options & NAND_INTERLEAVING_OPTIONS_MASK);
	if (options_selected > options_define) {
		printk("internal mode error for selected internal mode: %s force internal mode to : %s\n", aml_nand_internal_string[options_selected >> 16], aml_nand_internal_string[options_define >> 16]);
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
    
	options_selected = (plat->platform_nand_data.chip.options & NAND_PLANE_OPTIONS_MASK);
	options_define = (aml_chip->options & NAND_PLANE_OPTIONS_MASK);
	if (options_selected > options_define) {
		printk("multi plane error for selected plane mode: %s force plane to : %s\n", aml_nand_plane_string[options_selected >> 4], aml_nand_plane_string[options_define >> 4]);
		options_selected = options_define;
	}

	valid_chip_num = 0;
	for (i=0; i<aml_chip->chip_num; i++) {
		if (aml_chip->valid_chip[i]) {
		    valid_chip_num++;
		}
    	}
    
	if (aml_chip->ops_mode & AML_INTERLEAVING_MODE)
		valid_chip_num *= aml_chip->internal_chipnr;	
	
	if(valid_chip_num > 2){
		aml_chip->plane_num = 1;
	    	printk("detect valid_chip_num:%d over 2, and aml_chip->internal_chipnr:%d, disable NAND_TWO_PLANE_MODE here\n", valid_chip_num, aml_chip->internal_chipnr);
	}
	else{	
    	switch (options_selected) {
    
    		case NAND_TWO_PLANE_MODE:
    			aml_chip->plane_num = 2;
    			mtd->erasesize *= 2;
    			mtd->writesize *= 2;
    			mtd->oobsize *= 2;
    			break;
    
    		default:
    			aml_chip->plane_num = 1;
    			break;
    	}  
    }
	  
	return error;
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

	return -EBUSY;
}

static int m3_nand_dma_write(struct aml_nand_chip *aml_chip, unsigned char *buf, int len, unsigned bch_mode)
{
	int ret = 0;
	unsigned dma_unit_size = 0, count = 0;
	struct nand_chip *chip = &aml_chip->chip;
    struct mtd_info *mtd = &aml_chip->mtd;  

	if (bch_mode == NAND_ECC_NONE)
		count = 1;
	else if (bch_mode == NAND_ECC_BCH_SHORT) {
		dma_unit_size = (chip->ecc.size >> 3);
		count = len/chip->ecc.size;
	}
	else
		count = len/chip->ecc.size;

	dcache_flush_range((unsigned)buf, len);	
	dcache_flush_range((unsigned)aml_chip->user_info_buf, count*PER_INFO_BYTE);

	NFC_SEND_CMD_ADL((int)buf);
	NFC_SEND_CMD_ADH((int)buf);
	NFC_SEND_CMD_AIL((int)aml_chip->user_info_buf);
	NFC_SEND_CMD_AIH((int)aml_chip->user_info_buf);	

	if(aml_chip->ran_mode){
		if(aml_chip->plane_num == 2)
	      NFC_SEND_CMD_SEED((aml_chip->page_addr/(mtd->writesize >> chip->page_shift)) * (mtd->writesize >> chip->page_shift));
		else		
				NFC_SEND_CMD_SEED(aml_chip->page_addr);
	}
	if(!bch_mode)
		NFC_SEND_CMD_M2N_RAW(0, len);
	else
		NFC_SEND_CMD_M2N(aml_chip->ran_mode, ((bch_mode == NAND_ECC_BCH_SHORT)?NAND_ECC_BCH60_1K:bch_mode), ((bch_mode == NAND_ECC_BCH_SHORT)?1:0), dma_unit_size, count);

	ret = aml_platform_dma_waiting(aml_chip);
	
	if(aml_chip->oob_fill_cnt >0) {

	NFC_SEND_CMD_M2N_RAW(aml_chip->ran_mode, aml_chip->oob_fill_cnt);
	ret = aml_platform_dma_waiting(aml_chip);
	}
	return ret;	
}

static int m3_nand_dma_read(struct aml_nand_chip *aml_chip, unsigned char *buf, int len, unsigned bch_mode)
{
	volatile unsigned int * info_buf=0;
	volatile int cmp=0;

	struct nand_chip *chip = &aml_chip->chip;
	unsigned dma_unit_size = 0, count = 0, info_times_int_len;
	int ret = 0;
    struct mtd_info *mtd = &aml_chip->mtd;  

	info_times_int_len = PER_INFO_BYTE/sizeof(unsigned int);
	if (bch_mode == NAND_ECC_NONE)
		count = 1;
	else if (bch_mode == NAND_ECC_BCH_SHORT) {
		dma_unit_size = (chip->ecc.size >> 3);
		count = len/chip->ecc.size;
	}
	else
		count = len/chip->ecc.size;

	memset((unsigned char *)aml_chip->user_info_buf, 0, count*PER_INFO_BYTE);	
	dcache_flush_range((unsigned)aml_chip->user_info_buf, count*PER_INFO_BYTE);
	dcache_invalid_range((unsigned)buf, len);

	NFC_SEND_CMD_ADL((int)buf);
	NFC_SEND_CMD_ADH((int)buf);
	NFC_SEND_CMD_AIL((int)aml_chip->user_info_buf);
	NFC_SEND_CMD_AIH((int)aml_chip->user_info_buf);
	if(aml_chip->ran_mode){
		if(aml_chip->plane_num == 2)
	      NFC_SEND_CMD_SEED((aml_chip->page_addr/(mtd->writesize >> chip->page_shift)) * (mtd->writesize >> chip->page_shift));
		else		
				NFC_SEND_CMD_SEED(aml_chip->page_addr);
	}

	if(bch_mode == NAND_ECC_NONE)
		//NFC_SEND_CMD_N2M_RAW(aml_chip->ran_mode,len);
		NFC_SEND_CMD_N2M_RAW(0, len);
	else
		NFC_SEND_CMD_N2M(aml_chip->ran_mode, ((bch_mode == NAND_ECC_BCH_SHORT)?NAND_ECC_BCH60_1K:bch_mode), ((bch_mode == NAND_ECC_BCH_SHORT)?1:0), dma_unit_size, count);

	ret = aml_platform_dma_waiting(aml_chip);
	if (ret)
		return ret;
	do{
		dcache_invalid_range((unsigned)aml_chip->user_info_buf, count*PER_INFO_BYTE);
		info_buf = (volatile unsigned *)&(aml_chip->user_info_buf[(count-1)*info_times_int_len]);	
		cmp = *info_buf;
	}while((cmp)==0);

	return 0;
}

static int m3_nand_hwecc_correct(struct aml_nand_chip *aml_chip, unsigned char *buf, unsigned size, unsigned char *oob_buf)
{
	struct nand_chip *chip = &aml_chip->chip;
//	struct mtd_info *mtd = &aml_chip->mtd;
	unsigned ecc_step_num;
	unsigned info_times_int_len = PER_INFO_BYTE/sizeof(unsigned int);
		
	if (size % chip->ecc.size) {
		printk ("error parameter size for ecc correct %x\n", size);
		return -EINVAL;
	}

	 for (ecc_step_num = 0; ecc_step_num < (size / chip->ecc.size); ecc_step_num++) {
	 	//check if there have uncorrectable sector
		if(NAND_ECC_CNT(*(unsigned *)(&aml_chip->user_info_buf[ecc_step_num*info_times_int_len])) == 0x3f)
		{
			//if((aml_chip->ran_mode) && (NAND_ZERO_CNT(*(unsigned *)(&aml_chip->user_info_buf[ecc_step_num*info_times_int_len])) < 30)){
			//	continue;
			//}
            		aml_chip->zero_cnt = NAND_ZERO_CNT(*(unsigned *)(&aml_chip->user_info_buf[ecc_step_num*info_times_int_len]));
			//printk ("nand communication have uncorrectable ecc error %d\n", ecc_step_num);
			return -EIO;

	 	}
	 	else {
			//mtd->ecc_stats.corrected += NAND_ECC_CNT(*(unsigned *)(&aml_chip->user_info_buf[ecc_step_num*info_times_int_len]));
			aml_chip->ecc_cnt_cur = NAND_ECC_CNT(*(unsigned *)(&aml_chip->user_info_buf[ecc_step_num*info_times_int_len]));
		}
	}

	return 0;
}

static void m3_nand_boot_erase_cmd(struct mtd_info *mtd, int page)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	struct nand_chip *chip = mtd->priv;
	loff_t ofs;
	int i, page_addr;

	if (page >= M3_BOOT_PAGES_PER_COPY)
		return;

	if (aml_chip->valid_chip[0]) {

		for (i=0; i<M3_BOOT_COPY_NUM; i++) {
			page_addr = page + i*M3_BOOT_PAGES_PER_COPY;
			ofs = (page_addr << chip->page_shift);

			if (chip->block_bad(mtd, ofs, 0))
				continue;

			aml_chip->aml_nand_select_chip(aml_chip, 0);
			aml_chip->aml_nand_command(aml_chip, NAND_CMD_ERASE1, -1, page_addr, i);
			aml_chip->aml_nand_command(aml_chip, NAND_CMD_ERASE2, -1, -1, i);
			chip->waitfunc(mtd, chip);
		}
	}

	return;
}

static int m3_nand_boot_read_page_hwecc(struct mtd_info *mtd, struct nand_chip *chip, uint8_t *buf, int page)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	uint8_t *oob_buf = chip->oob_poi;
	unsigned nand_page_size = chip->ecc.steps * chip->ecc.size;
	unsigned pages_per_blk_shift = (chip->phys_erase_shift - chip->page_shift);
	int user_byte_num = (chip->ecc.steps * aml_chip->user_byte_mode);
	int bch_mode = aml_chip->bch_mode, ran_mode;
	int error = 0, i = 0, stat = 0;
	int ecc_size, configure_data_w, pages_per_blk_w, configure_data, pages_per_blk, read_page_tmp, read_page;
	int en_slc = 0;
	
#ifdef MX_REVD
	en_slc = ((aml_chip->new_nand_info.type < 10)&&(aml_chip->new_nand_info.type))? 1:0;
 #endif
 
	if (page >= (M3_BOOT_PAGES_PER_COPY*M3_BOOT_COPY_NUM)) 
	{
		memset(buf, 0, (1 << chip->page_shift));
		printk("nand boot read out of uboot failed, page:%d\n", page);
		goto exit;
	}
    
        if((page % M3_BOOT_PAGES_PER_COPY) == 0)
        {
            if (aml_chip->bch_mode == NAND_ECC_BCH_SHORT)
            {
                configure_data_w = NFC_CMD_N2M(aml_chip->ran_mode, NAND_ECC_BCH60_1K, 1, (chip->ecc.size >> 3), chip->ecc.steps);
            }
            else
            {
                configure_data_w = NFC_CMD_N2M(aml_chip->ran_mode, aml_chip->bch_mode, 0, (chip->ecc.size >> 3), chip->ecc.steps);
            }
            
            ecc_size = chip->ecc.size;  //backup ecc size   
            
            if (aml_chip->bch_mode != NAND_ECC_BCH_SHORT)
            {
                nand_page_size = (mtd->writesize / 512) * NAND_ECC_UNIT_SHORT;
                bch_mode = NAND_ECC_BCH_SHORT;            
                chip->ecc.size = NAND_ECC_UNIT_SHORT;
            }
            else
            {
                bch_mode = aml_chip->bch_mode;
            }
        
            chip->cmdfunc(mtd, NAND_CMD_READ0, 0x00, page);
            memset(buf, 0xff, (1 << chip->page_shift));
            
            if (aml_chip->valid_chip[0]) 
            {
                if (!aml_chip->aml_nand_wait_devready(aml_chip, i)) 
                {
                    printk("nand boot page 0 read couldn`t found selected chip: %d ready\n", i);
                    error = -EBUSY;
                    //goto exit;
                }
                if (aml_chip->ops_mode & AML_CHIP_NONE_RB) 
			chip->cmd_ctrl(mtd, NAND_CMD_READ0 & 0xff, NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);
//#ifndef MX_REVD
			if((mx_nand_check_chiprevd() != 1) && (en_slc == 0)){
                ran_mode = aml_chip->ran_mode;
                aml_chip->ran_mode = 0;
				}
//#endif
                error = aml_chip->aml_nand_dma_read(aml_chip, buf, nand_page_size, bch_mode);
//#ifndef MX_REVD
			if((mx_nand_check_chiprevd() != 1) && (en_slc == 0)){
                aml_chip->ran_mode = ran_mode;
				}
//#endif
                if (error)
                {
                        printk("nand boot page 0 aml_nand_dma_read failed\n");
                    //goto exit;
                }
        
                aml_chip->aml_nand_get_user_byte(aml_chip, oob_buf, user_byte_num);
                stat = aml_chip->aml_nand_hwecc_correct(aml_chip, buf, nand_page_size, oob_buf);
                if (stat < 0) {
                    mtd->ecc_stats.failed++;
                    printk("nand boot page 0 aml nand read data ecc failed at blk 0 chip 0\n");
            }
            else
                mtd->ecc_stats.corrected += stat;
            }
            else {
                printk("nand boot page 0 no valid chip failed\n");
                error = -ENODEV;
                //goto exit;
            }
            
            //check page 0 info here
            memcpy((unsigned char *)(&configure_data), buf, sizeof(int));
            memcpy((unsigned char *)(&pages_per_blk), buf+4, sizeof(int));
            
            pages_per_blk_w = (1 << (chip->phys_erase_shift - chip->page_shift));
            
            if((pages_per_blk_w != pages_per_blk) || (configure_data != configure_data_w))
            {
                printk("nand boot page %d check data failed, and onfigure_data_w:0x%x, pages_per_blk_w:0x%x\n", page, configure_data_w, pages_per_blk_w);
            }           
                        
            //printk("nand boot page %d,  NO.%d, configure_data:0x%x, pages_per_blk:0x%x, other data:%x %x %x %x\n", 
                                   // page, (page / M3_BOOT_PAGES_PER_COPY), configure_data, pages_per_blk, buf[8], buf[9], buf[10], buf[11]);

            bch_mode = aml_chip->bch_mode;
            chip->ecc.size = ecc_size; 
            nand_page_size = chip->ecc.steps * chip->ecc.size;
            
        }       
    
    	read_page = page;
        read_page++;    

#ifdef MX_REVD
			if(en_slc){ 
				read_page = page%M3_BOOT_PAGES_PER_COPY;
			if(aml_chip->new_nand_info.type == HYNIX_1YNM_8GB)
				read_page = pagelist_1ynm_hynix256[read_page+1] + (page/M3_BOOT_PAGES_PER_COPY)*M3_BOOT_PAGES_PER_COPY;
			else
				read_page = pagelist_hynix256[read_page+1] + (page/M3_BOOT_PAGES_PER_COPY)*M3_BOOT_PAGES_PER_COPY;
			}
#endif

	
        chip->cmdfunc(mtd, NAND_CMD_READ0, 0x00, read_page);
        
        memset(buf, 0xff, (1 << chip->page_shift));
        if (aml_chip->valid_chip[0]) 
        {
    
            if (!aml_chip->aml_nand_wait_devready(aml_chip, 0)) 
            {
                printk("read couldn`t found selected chip0 ready, page: %d \n", page);
                error = -EBUSY;
                goto exit;
            }
	    if (aml_chip->ops_mode & AML_CHIP_NONE_RB) 
		chip->cmd_ctrl(mtd, NAND_CMD_READ0 & 0xff, NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);
    
            error = aml_chip->aml_nand_dma_read(aml_chip, buf, nand_page_size, bch_mode);
            if (error)
            {
                error = -ENODEV;
                printk("aml_nand_dma_read failed: page:%d \n", page);
                goto exit;
            }
        
            aml_chip->aml_nand_get_user_byte(aml_chip, oob_buf, user_byte_num);
            stat = aml_chip->aml_nand_hwecc_correct(aml_chip, buf, nand_page_size, oob_buf);
            if (stat < 0) {
                error = -ENODEV;
                mtd->ecc_stats.failed++;
                printk("aml nand read data ecc failed at blk %d chip %d\n", (page >> pages_per_blk_shift), i);
            }
            else
            {
                //printk("nand boot read data ok page %d, stat:%d\n", tmp_page, stat);
                mtd->ecc_stats.corrected += stat;
            }
        }
        else 
        {
            error = -ENODEV;
        }

        exit:

	return error;
}

static void m3_nand_boot_write_page_hwecc(struct mtd_info *mtd, struct nand_chip *chip, const uint8_t *buf)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	uint8_t *oob_buf = chip->oob_poi;
	unsigned nand_page_size = chip->ecc.steps * chip->ecc.size;
	int user_byte_num = (chip->ecc.steps * aml_chip->user_byte_mode);
	int error = 0, i = 0, bch_mode, ecc_size;

	ecc_size = chip->ecc.size;
	if (((aml_chip->page_addr % M3_BOOT_PAGES_PER_COPY) == 0) && (aml_chip->bch_mode != NAND_ECC_BCH_SHORT)) {
		nand_page_size = (mtd->writesize / 512) * NAND_ECC_UNIT_SHORT;
		bch_mode = NAND_ECC_BCH_SHORT;
		chip->ecc.size = NAND_ECC_UNIT_SHORT;
	}
	else
		bch_mode = aml_chip->bch_mode;

	for (i=0; i<mtd->oobavail; i+=2) {
		oob_buf[i] = 0x55;
		oob_buf[i+1] = 0xaa;
	}
	i = 0;
	if (aml_chip->valid_chip[i]) {

		aml_chip->aml_nand_select_chip(aml_chip, i);

		aml_chip->aml_nand_set_user_byte(aml_chip, oob_buf, user_byte_num);
		error = aml_chip->aml_nand_dma_write(aml_chip, (unsigned char *)buf, nand_page_size, bch_mode);
		if (error)
			goto exit;
		aml_chip->aml_nand_command(aml_chip, NAND_CMD_PAGEPROG, -1, -1, i);
	}
	else {
		error = -ENODEV;
		goto exit;
	}

exit:
	if (((aml_chip->page_addr % M3_BOOT_PAGES_PER_COPY) == 0) && (aml_chip->bch_mode != NAND_ECC_BCH_SHORT))
		chip->ecc.size = ecc_size;

	return;
}

static int m3_nand_boot_write_page(struct mtd_info *mtd, struct nand_chip *chip, const uint8_t *buf, int page, int cached, int raw)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	int status, i, write_page, configure_data, pages_per_blk, write_page_tmp, ran_mode;
	int new_nand_type = 0;
	int en_slc = 0;
#ifdef MX_REVD
	int magic = NAND_PAGELIST_MAGIC;
	int page_list[6] = {0x01, 0x02, 0x03, 0x06, 0x07, 0x0A};
	unsigned priv_slc_page,next_msb_page;
	unsigned char *fill_buf =NULL;
#endif	
	

#ifdef CONFIG_SECURE_NAND
	struct mtd_info *mtd_device1;
	struct aml_nand_chip *aml_chip_device1 ; 
	struct aml_nand_platform *plat = NULL;
	int k,nand_read_info,secure_block,valid_chip_num =0;
	unsigned char chip_num=0, plane_num=0,micron_nand=0;

	for(i=0;i<aml_nand_mid_device.dev_num; i++){
		plat = &aml_nand_mid_device.aml_nand_platform[i];
		if(!strncmp((char*)plat->name, NAND_NORMAL_NAME, strlen((const char*)NAND_NORMAL_NAME))){
			mtd_device1 = nand_info[i];
			break;
		}
	}
	aml_chip_device1 = mtd_to_nand_chip(mtd_device1);
#endif

#ifdef MX_REVD
	if(aml_chip->new_nand_info.type == HYNIX_1YNM_8GB) {
		page_list[1] = 0X03;page_list[2] = 0X05;page_list[3] = 0X07;
		page_list[4] = 0X09;page_list[5] = 0X0B;
	}
	new_nand_type = aml_chip->new_nand_info.type;
	en_slc = ((aml_chip->new_nand_info.type < 10)&&(aml_chip->new_nand_info.type))? 1:0;
	if(new_nand_type == HYNIX_1YNM_8GB) {
		fill_buf = kzalloc(mtd->writesize, GFP_KERNEL);
		if (fill_buf == NULL) {
			printk("malloc fill buf fail \n");
			return -ENOMEM;	
		}
		memset(fill_buf, 0xff, mtd->writesize);
	}
#endif

	if(en_slc){
		if (page >= (M3_BOOT_PAGES_PER_COPY/2 - 1))
			return 0;
#ifdef MX_REVD			
			if(aml_chip->new_nand_info.slc_program_info.enter_enslc_mode)
			aml_chip->new_nand_info.slc_program_info.enter_enslc_mode(mtd);
#endif			
	}
	else{
		if (page >= (M3_BOOT_PAGES_PER_COPY - 1))
			return 0;
	}

	pages_per_blk = (1 << (chip->phys_erase_shift - chip->page_shift));
	for (i=0; i<M3_BOOT_COPY_NUM; i++) {

		write_page = page + i*M3_BOOT_PAGES_PER_COPY;
		if ((write_page % M3_BOOT_PAGES_PER_COPY) == 0) {
			if (aml_chip->bch_mode == NAND_ECC_BCH_SHORT)
				configure_data = NFC_CMD_N2M(aml_chip->ran_mode, NAND_ECC_BCH60_1K, 1, (chip->ecc.size >> 3), chip->ecc.steps);
			else
				configure_data = NFC_CMD_N2M(aml_chip->ran_mode, aml_chip->bch_mode, 0, (chip->ecc.size >> 3), chip->ecc.steps);

			//printk("m3_nand_boot_write_page NO:%d, configure_data:0x%x\n", i, configure_data);
			memset(chip->buffers->databuf, 0xbb, mtd->writesize);
			memcpy(chip->buffers->databuf, (unsigned char *)(&configure_data), sizeof(int));
			memcpy(chip->buffers->databuf + sizeof(int), (unsigned char *)(&pages_per_blk), sizeof(int));
			//add for new nand
			memcpy(chip->buffers->databuf + sizeof(int) + sizeof(int), (unsigned char *)(&new_nand_type), sizeof(int));
#ifdef MX_REVD
			if(en_slc ){
				memcpy(chip->buffers->databuf + 5*sizeof(int), (unsigned char *)(&magic), sizeof(int));
				memcpy(chip->buffers->databuf + 6*sizeof(int), (unsigned char *)(&page_list[0]), 6*sizeof(int));
			}
#endif
			
#ifdef CONFIG_SECURE_NAND
			valid_chip_num = 0;
			for (k=0; k<aml_chip_device1->chip_num; k++) {
				if(aml_chip_device1->valid_chip[k]){
					valid_chip_num++;
				}
			}
			
			chip_num = valid_chip_num;
			if(aml_chip_device1->plane_num == 2)
				plane_num = 1;
			
			ran_mode = aml_chip_device1->ran_mode;
			
			if((aml_chip_device1->mfr_type == NAND_MFR_MICRON) || (aml_chip_device1->mfr_type == NAND_MFR_INTEL))
				micron_nand = 1;
			
			nand_read_info = chip_num | (plane_num << 2) |(ran_mode << 3) | (micron_nand << 4);
			memcpy(chip->buffers->databuf +3* sizeof(int), (unsigned char *)(&nand_read_info), sizeof(int));
			
			secure_block = aml_chip_device1->aml_nandsecure_info->start_block;
			memcpy(chip->buffers->databuf +4* sizeof(int), (unsigned char *)(&secure_block), sizeof(int));
			
			printk("chip_num %d,plane_num %d,ran_mode %d micron_nand %d ,secure_block %d\n",chip_num,\
				plane_num,ran_mode,micron_nand,secure_block);
#endif
				
			chip->cmdfunc(mtd, NAND_CMD_SEQIN, 0x00, write_page);
//#ifndef MX_REVD
			if((mx_nand_check_chiprevd() != 1) && (en_slc == 0)){
			ran_mode = aml_chip->ran_mode;
			aml_chip->ran_mode = 0;
			}
//#endif			
			chip->ecc.write_page(mtd, chip, chip->buffers->databuf);
//#ifndef MX_REVD
			if((mx_nand_check_chiprevd() != 1) && (en_slc == 0)){
			aml_chip->ran_mode = ran_mode;
			}
//#endif
			status = chip->waitfunc(mtd, chip);

			if ((status & NAND_STATUS_FAIL) && (chip->errstat))
				status = chip->errstat(mtd, chip, FL_WRITING, status, write_page);

			if (status & NAND_STATUS_FAIL){
                printk("uboot wr 0 page=0x%x, status =  0x%x\n", page,status);
				return -EIO;
			}
		}
#ifdef MX_REVD
		if(en_slc){	
			if(aml_chip->new_nand_info.type == HYNIX_1YNM_8GB)
			write_page = pagelist_1ynm_hynix256[page+1] + i*M3_BOOT_PAGES_PER_COPY;	
			else
			write_page = pagelist_hynix256[page+1] + i*M3_BOOT_PAGES_PER_COPY;
		}
		else{
			write_page++;
		}
#else
		write_page++;
#endif
		if(new_nand_type == HYNIX_1YNM_8GB) {
			if((page+1)>1)
				priv_slc_page = pagelist_1ynm_hynix256[page] + i*M3_BOOT_PAGES_PER_COPY;
			else
				priv_slc_page = page + i*M3_BOOT_PAGES_PER_COPY;
			while((priv_slc_page+1)<write_page) {
				chip->cmdfunc(mtd, NAND_CMD_SEQIN, 0x00, (++priv_slc_page));
				chip->ecc.write_page_raw(mtd, chip, fill_buf);
				chip->waitfunc(mtd, chip);
				printk("%s, fill page:0x%x\n", __func__, priv_slc_page);
			}
		}
		//printk("%s, write_page:0x%x\n", __func__, write_page);	
		chip->cmdfunc(mtd, NAND_CMD_SEQIN, 0x00, write_page);

		if (unlikely(raw))
			chip->ecc.write_page_raw(mtd, chip, buf);
		else
			chip->ecc.write_page(mtd, chip, buf);

		if (!cached || !(chip->options & NAND_CACHEPRG)) {

			status = chip->waitfunc(mtd, chip);

			if ((status & NAND_STATUS_FAIL) && (chip->errstat))
				status = chip->errstat(mtd, chip, FL_WRITING, status, write_page);

			if (status & NAND_STATUS_FAIL){
                		printk("uboot wr page=0x%x, status =  0x%x\n", page,status);
#ifdef MX_REVD                		
                		if(en_slc&&aml_chip->new_nand_info.slc_program_info.exit_enslc_mode)
                			aml_chip->new_nand_info.slc_program_info.exit_enslc_mode(mtd);
 #endif               		
				return -EIO;
			}
		} else {
		
			status = chip->waitfunc(mtd, chip);
		}
	}
#ifdef MX_REVD	
	if(en_slc&&aml_chip->new_nand_info.slc_program_info.exit_enslc_mode)
		aml_chip->new_nand_info.slc_program_info.exit_enslc_mode(mtd);
#endif
	return 0;
}

static int m3_nand_probe(struct aml_nand_platform *plat, unsigned dev_num)
{
	struct aml_nand_chip *aml_chip = NULL;
	struct nand_chip *chip = NULL;
	struct mtd_info *mtd = NULL;
	int err = 0, i;
	unsigned chiprev = 0, nand_type = 0;

	if (!plat) {
		printk("no platform specific information\n");
		goto exit_error;
	}

	aml_chip = kzalloc(sizeof(*aml_chip), GFP_KERNEL);
	if (aml_chip == NULL) {
		printk("no memory for flash info\n");
		err = -ENOMEM;
		goto exit_error;
	}

	/* initialize mtd info data struct */
	aml_chip->platform = plat;
	aml_chip->bch_desc = m3_bch_list;
	aml_chip->max_bch_mode = sizeof(m3_bch_list) / sizeof(m3_bch_list[0]);
	plat->aml_chip = aml_chip;
	chip = &aml_chip->chip;
	chip->priv = &aml_chip->mtd;
	mtd = &aml_chip->mtd;
	mtd->priv = chip;
	mtd->name = plat->name;
	aml_chip->aml_nand_hw_init = m3_nand_hw_init;
	aml_chip->aml_nand_adjust_timing = m3_nand_adjust_timing;
	aml_chip->aml_nand_select_chip = m3_nand_select_chip;
	aml_chip->aml_nand_options_confirm = m3_nand_options_confirm;
	aml_chip->aml_nand_dma_read = m3_nand_dma_read;
	aml_chip->aml_nand_dma_write = m3_nand_dma_write;
	aml_chip->aml_nand_hwecc_correct = m3_nand_hwecc_correct;
	aml_chip->ran_mode = plat->ran_mode; 	
    	aml_chip->rbpin_detect = plat->rbpin_detect; 	

	err = aml_nand_init(aml_chip);
	if (err)
		goto exit_error;
	chiprev = mx_nand_check_chiprevd();
	nand_type = ((aml_chip->new_nand_info.type < 10)&&(aml_chip->new_nand_info.type));
	printk("detect mx chiprevD :%d and nand_type: %d\n", chiprev, aml_chip->new_nand_info.type );
	
	if((chiprev != 1) && nand_type && nand_boot_flag){    //for MX revB and Hynix new nand
        printk("detect CHIP revB with Hynix new nand error\n");
        aml_chip->err_sts = NAND_CHIP_REVB_HY_ERR;
    }

	if (!strncmp((char*)plat->name, NAND_BOOT_NAME, strlen((const char*)NAND_BOOT_NAME))) {
        if((chiprev != 1) && nand_type){    //for MX revB and Hynix new nand
            printk("detect CHIP revB with Hynix new nand error\n");
            aml_chip->err_sts = NAND_CHIP_REVB_HY_ERR;
        }
		chip->erase_cmd = m3_nand_boot_erase_cmd;
		chip->ecc.read_page = m3_nand_boot_read_page_hwecc;
		chip->ecc.write_page = m3_nand_boot_write_page_hwecc;
		chip->write_page = m3_nand_boot_write_page;
		if (chip->ecc.layout)
			chip->ecc.layout->oobfree[0].length = ((mtd->writesize / 512) * aml_chip->user_byte_mode);
		chip->ecc.layout->oobavail = 0;
		for (i = 0; chip->ecc.layout->oobfree[i].length && i < ARRAY_SIZE(chip->ecc.layout->oobfree); i++)
			chip->ecc.layout->oobavail += chip->ecc.layout->oobfree[i].length;
		mtd->oobavail = chip->ecc.layout->oobavail;
		mtd->ecclayout = chip->ecc.layout;
	}

	nand_info[dev_num] = mtd;
	return 0;

exit_error:
	if (aml_chip)
		kfree(aml_chip);
	mtd->name = NULL;
	return err;
}



void nand_init(void)
{
	struct aml_nand_platform *plat = NULL;
	int i, ret;
	printk("%s, Version %s (c) 2010 Amlogic Inc.\n", DRV_DESC, DRV_VERSION);

	for (i=0; i<aml_nand_mid_device.dev_num; i++) {
		plat = &aml_nand_mid_device.aml_nand_platform[i];
		if (!plat) {
			printk("error for not platform data\n");
			continue;
		}

#if defined CONFIG_SPI_NAND_COMPATIBLE || defined CONFIG_SPI_NAND_EMMC_COMPATIBLE
		 if(POR_NAND_BOOT()){
			printk("NAND BOOT : %s %d \n",__func__,__LINE__);
		}
		if( ((!strncmp((char*)plat->name, NAND_BOOT_NAME, strlen((const char*)NAND_BOOT_NAME)))) &&\
			(i == 0) && (POR_SPI_BOOT())){
			printk("SPI BOOT : continue i %d\n",i);
			continue;
		}
#endif
		ret = m3_nand_probe(plat, i);
		if (ret) {
			printk("nand init faile: %d\n", ret);
			continue;
		}
	}

	for(i=0;i<aml_nand_mid_device.dev_num; i++){
		plat = &aml_nand_mid_device.aml_nand_platform[i];
		if(!strncmp((char*)plat->name, NAND_NORMAL_NAME, strlen((const char*)NAND_NORMAL_NAME))){
			nand_curr_device = i;  //normal device
			printk("nand_curr_device =%d\n",nand_curr_device);
			break;
		}else
			nand_curr_device = 0; // uboot device
	}
	
	//if (aml_nand_mid_device.dev_num  >  0)
		//nand_curr_device = (aml_nand_mid_device.dev_num - 2);
	//else
		//nand_curr_device = 0;
	return;
}

//just for nand test command
 int nand_test_init(void)
{
	struct aml_nand_platform *plat = NULL;
	int i, ret=0;
	printk("%s, Version %s (c) 2012 factory nand test .\n", DRV_DESC, DRV_VERSION);

	for (i=0; i<aml_nand_mid_device.dev_num; i++) {
		plat = &aml_nand_mid_device.aml_nand_platform[i];
		if (!plat) {
			printk("error in nand test for not platform data \n");
			continue;
		}
		ret = m3_nand_probe(plat, i);
		if (ret) {
			printk("nand init faile in nand test: %d\n", ret);
			continue;
		}
	}
	if (ret) {
			return -1;
		}
	return 0;
}
/*
int nand_probe(int dev)
{
	if (dev < 0 || dev >= CONFIG_SYS_MAX_NAND_DEVICE ||
	    !nand_info[dev].name) {
		printk("No such device\n");
		return -1;
	}

    return 0;
	//return(aml_nand_probe(&(nand_info[dev])));
		
}
*/
