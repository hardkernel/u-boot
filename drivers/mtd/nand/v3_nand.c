
#include <common.h>
#include <nand.h>
#include <asm/io.h>
#include <asm/arch/nand.h>
#include <malloc.h>
#include <linux/err.h>
#include <asm/cache.h>
#include <asm/arch/pinmux.h>

#include <linux/mtd/mtd.h>
#include <linux/mtd/nand.h>
#include <linux/mtd/nand_ecc.h>

int nand_curr_device = -1;
//extern struct aml_nand_platform aml_nand_platform[];
extern struct aml_nand_device aml_nand_mid_device;
#define CONFIG_SYS_NAND_MAX_DEVICE 		4
nand_info_t *pnand_info[CONFIG_SYS_NAND_MAX_DEVICE];
nand_info_t nand_info[CONFIG_SYS_NAND_MAX_DEVICE]={{0}};
#ifdef CONFIG_MTD_DEVICE
/*static __attribute__((unused)) */char dev_name[CONFIG_SYS_MAX_NAND_DEVICE][8];
#endif


#define ECC_INFORMATION(name_a,bch_a,size_a,parity_a,user_a) {                \
        .name=name_a,.bch=bch_a,.size=size_a,.parity=parity_a,.user=user_a    \
    }
static struct ecc_desc_s ecc_list[]={
	[0]=ECC_INFORMATION("NAND_RAW_MODE",NAND_ECC_SOFT_MODE,0,0,0),
	[1]=ECC_INFORMATION("NAND_BCH8_512_MODE",NAND_ECC_BCH8_512_MODE,NAND_ECC_UNIT_SIZE,NAND_BCH8_512_ECC_SIZE,2),
	[2]=ECC_INFORMATION("NAND_BCH8_1K_MODE" ,NAND_ECC_BCH8_1K_MODE,NAND_ECC_UNIT_1KSIZE,NAND_BCH8_1K_ECC_SIZE,2),
	[3]=ECC_INFORMATION("NAND_BCH16_MODE" ,NAND_ECC_BCH16_MODE,NAND_ECC_UNIT_1KSIZE,NAND_BCH16_ECC_SIZE,2),
	[4]=ECC_INFORMATION("NAND_BCH24_MODE" ,NAND_ECC_BCH24_MODE,NAND_ECC_UNIT_1KSIZE,NAND_BCH24_ECC_SIZE,2),
	[5]=ECC_INFORMATION("NAND_BCH30_MODE" ,NAND_ECC_BCH30_MODE,NAND_ECC_UNIT_1KSIZE,NAND_BCH30_ECC_SIZE,2),
	[6]=ECC_INFORMATION("NAND_BCH40_MODE" ,NAND_ECC_BCH40_MODE,NAND_ECC_UNIT_1KSIZE,NAND_BCH40_ECC_SIZE,2),
	[7]=ECC_INFORMATION("NAND_BCH60_MODE" ,NAND_ECC_BCH60_MODE,NAND_ECC_UNIT_1KSIZE,NAND_BCH60_ECC_SIZE,2),
	[8]=ECC_INFORMATION("NAND_SHORT_MODE" ,NAND_ECC_SHORT_MODE,NAND_ECC_UNIT_SHORT,NAND_BCH60_ECC_SIZE,2),
};


static int m3_nand_init(struct aml_nand_platform *plat, unsigned dev_num)
{
	struct aml_nand_chip *aml_chip = NULL;
	struct nand_chip *chip = NULL;
	struct mtd_info *mtd = NULL;
	int err = 0;

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
	aml_chip->mtd = &(nand_info[dev_num]);

	chip = &aml_chip->chip;
	mtd = aml_chip->mtd;
	mtd->priv = chip;
     chip->priv = aml_chip;
	aml_chip->platform = plat;

	mtd->name = plat->name;
    aml_chip->max_ecc=sizeof(ecc_list)/sizeof(ecc_list[0]);
    aml_chip->ecc=ecc_list;
    
#ifdef CONFIG_MTD_DEVICE
	/*
	* Add MTD device so that we can reference it later
	* via the mtdcore infrastructure (e.g. ubi).
	*/
	//printf("ELVIS---plat->name: %s\n", plat->name);
	//if(strcmp(plat->name, NAND_BOOT_NAME))
//	{
//		sprintf(dev_name[dev_num], "nand%d", dev_num);
//		//printf("ELVIS---dev_name[%d]: %s\n", dev_num, dev_name[dev_num]);
//		mtd->name = dev_name[dev_num];
//	}
#endif

	err = aml_nand_init(aml_chip);
	if (err)
		goto exit_error;

//	pnand_info[dev_num] = aml_chip->mtd;
//      memcpy(&nand_info[dev_num], pnand_info[dev_num], sizeof(nand_info_t));
	return 0;

exit_error:
	if (aml_chip)
		kfree(aml_chip);
	mtd->name = NULL;
	return err;
}

#define DRV_NAME	"aml_v3_nand"
#define DRV_VERSION	"1.0"
#define DRV_AUTHOR	"xiaojun_yoyo"
#define DRV_DESC	"Amlogic nand flash uboot driver for A3/M3"
void nand_init(void)
{
	struct aml_nand_platform *plat = NULL;
	int i, ret;
	printk(KERN_INFO "%s, Version %s (c) 2010 Amlogic Inc.\n", DRV_DESC, DRV_VERSION);

	for (i=0; i<aml_nand_mid_device.dev_num; i++) {
		plat = &aml_nand_mid_device.aml_nand_platform[i];
		if (!plat) {
			printk("error for not platform data\n");
			continue;
		}
		//ret = a3_nand_probe(plat, i);
		ret = m3_nand_init(plat, i);
		if (ret) {
			printk("nand init faile: %d\n", ret);
			continue;
		}
	}
	if (aml_nand_mid_device.dev_num  >  0)
		nand_curr_device = (aml_nand_mid_device.dev_num - 1);
	else
		nand_curr_device = 0;
	return;
}

int nand_probe(int dev)
{
	if (dev < 0 || dev >= CONFIG_SYS_MAX_NAND_DEVICE ||
	    !nand_info[dev].name) {
		printk("No such device\n");
		return -1;
	}
	
	return(aml_nand_probe(&(nand_info[dev])));
		
}
