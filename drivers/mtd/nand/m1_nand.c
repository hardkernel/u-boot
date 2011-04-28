
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
nand_info_t *nand_info[CONFIG_SYS_NAND_MAX_DEVICE]={0};
//nand_info_t *pnand_info[CONFIG_SYS_NAND_MAX_DEVICE];	changed by Elvis
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
static struct aml_nand_bch_desc m1_bch_list[] = {
	[0]=ECC_INFORMATION("NAND_RAW_MODE", NAND_ECC_SOFT_MODE, 0, 0, 0),
	[1]=ECC_INFORMATION("NAND_BCH9_MODE", NAND_ECC_BCH9_MODE, NAND_ECC_UNIT_SIZE, NAND_BCH9_ECC_SIZE, 1),
	[2]=ECC_INFORMATION("NAND_BCH8_MODE", NAND_ECC_BCH8_MODE, NAND_ECC_UNIT_SIZE, NAND_BCH8_ECC_SIZE, 2),
	[3]=ECC_INFORMATION("NAND_BCH12_MODE", NAND_ECC_BCH12_MODE, NAND_ECC_UNIT_SIZE, NAND_BCH12_ECC_SIZE, 2),
	[4]=ECC_INFORMATION("NAND_BCH16_MODE", NAND_ECC_BCH16_MODE, NAND_ECC_UNIT_SIZE, NAND_BCH16_ECC_SIZE, 2),
};

static int m1_nand_options_confirm(struct aml_nand_chip *aml_chip)
{
	struct mtd_info *mtd = &aml_chip->mtd;
	struct nand_chip *chip = &aml_chip->chip;
	struct aml_nand_platform *plat = aml_chip->platform;
	struct aml_nand_bch_desc *ecc_supports = aml_chip->bch_desc;
	unsigned max_bch_mode = aml_chip->max_bch_mode;
	unsigned options_selected = 0, options_support = 0, ecc_bytes, options_define;
	int error = 0,i;

	options_selected = (plat->platform_nand_data.chip.options & NAND_ECC_OPTIONS_MASK);
	options_define = (aml_chip->options & NAND_ECC_OPTIONS_MASK);

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
		printk("define oob size: %d could support bch mode: %s\n", aml_chip->oob_size, ecc_supports[options_support].name);
	}

	if ((options_selected > options_define) && (strncmp((char*)plat->name, NAND_BOOT_NAME, strlen((const char*)NAND_BOOT_NAME)))) {
		printk("oob size is not enough for selected bch mode: %s force bch to mode: %s\n", ecc_supports[options_selected].name,ecc_supports[options_define].name);
		options_selected = options_define;
	}

	switch (options_selected) {

		case NAND_ECC_BCH9_MODE:
			chip->ecc.size = NAND_ECC_UNIT_SIZE;				//our hardware ecc unit is 512bytes
			chip->ecc.bytes = NAND_BCH9_ECC_SIZE;
			aml_chip->bch_mode = NAND_ECC_BCH9;
			aml_chip->user_byte_mode = 1;
			break;

		case NAND_ECC_BCH8_MODE:
			chip->ecc.size = NAND_ECC_UNIT_SIZE;
			chip->ecc.bytes = NAND_BCH8_ECC_SIZE;
			aml_chip->bch_mode = NAND_ECC_BCH8;
			aml_chip->user_byte_mode = 2;
			break;

		case NAND_ECC_BCH12_MODE:
			chip->ecc.size = NAND_ECC_UNIT_SIZE;
			chip->ecc.bytes = NAND_BCH12_ECC_SIZE;
			aml_chip->bch_mode = NAND_ECC_BCH12;
			aml_chip->user_byte_mode = 2;
			break;

		case NAND_ECC_BCH16_MODE:
			chip->ecc.size = NAND_ECC_UNIT_SIZE;
			chip->ecc.bytes = NAND_BCH16_ECC_SIZE;
			aml_chip->bch_mode = NAND_ECC_BCH16;
			aml_chip->user_byte_mode = 2;
			break;

		default :
			if ((plat->platform_nand_data.chip.options & NAND_ECC_OPTIONS_MASK) != NAND_ECC_SOFT_MODE) {
				printk("soft ecc or none ecc just support in linux self nand base please selected it at platform options\n");
				error = -ENXIO;
			}
			break;
	}

	options_selected = (plat->platform_nand_data.chip.options & NAND_PLANE_OPTIONS_MASK);
	options_define = (aml_chip->options & NAND_PLANE_OPTIONS_MASK);
	if (options_selected > options_define) {
		printk("multi plane error for selected plane mode: %s force plane to : %s\n", aml_nand_plane_string[options_selected >> 4], aml_nand_plane_string[options_define >> 4]);
		options_selected = options_define;
	}

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

	return error;
}

static void m1_nand_boot_erase_cmd(struct mtd_info *mtd, int page)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	struct nand_chip *chip = mtd->priv;
	loff_t ofs;
	int i, page_addr;

	if (aml_chip->valid_chip[0]) {

		for (i=0; i<M1_BOOT_COPY_NUM; i++) {
			page_addr = page + i*M1_BOOT_PAGES_PER_COPY;
			ofs = (page_addr << chip->page_shift);

			if (chip->block_bad(mtd, ofs, 0))
				continue;

			aml_chip->aml_nand_select_chip(aml_chip, 0);
			aml_chip->aml_nand_command(aml_chip, NAND_CMD_ERASE1, -1, page_addr, i);
			aml_chip->aml_nand_command(aml_chip, NAND_CMD_ERASE2, -1, -1, i);
			chip->waitfunc(mtd, chip);
		}
	}

	return ;
}

static int m1_nand_boot_read_page_hwecc(struct mtd_info *mtd, struct nand_chip *chip, uint8_t *buf, int page)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	uint8_t *oob_buf = chip->oob_poi;
	unsigned pages_per_blk_shift = (chip->phys_erase_shift - chip->page_shift);
	unsigned nand_page_size = (1 << chip->page_shift);
	int error = 0, i = 0, stat = 0, ecc_bytes, user_byte_num;

	user_byte_num = ((nand_page_size / chip->ecc.size) * aml_chip->user_byte_mode);
	ecc_bytes = ((nand_page_size / chip->ecc.size) * chip->ecc.bytes);
	if (aml_chip->oob_size < (ecc_bytes + user_byte_num))
		nand_page_size -= chip->ecc.size;

	memset(buf, 0xff, (1 << chip->page_shift));
	if (aml_chip->valid_chip[i]) {

		if (!aml_chip->aml_nand_wait_devready(aml_chip, i)) {
			printk ("read couldn`t found selected chip: %d ready\n", i);
			error = -EBUSY;
			goto exit;
		}

		error = aml_chip->aml_nand_dma_read(aml_chip, buf, nand_page_size, aml_chip->bch_mode);
		if (error)
			goto exit;

		aml_chip->aml_nand_get_user_byte(aml_chip, oob_buf, user_byte_num);
		stat = aml_chip->aml_nand_hwecc_correct(aml_chip, buf, nand_page_size, oob_buf);
		if (stat < 0) {
			mtd->ecc_stats.failed++;
			printk("aml nand read data ecc failed at page %d chip %d\n", page, i);
		}
		else
			mtd->ecc_stats.corrected += stat;
	}
	else {
		error = -ENODEV;
		goto exit;
	}

exit:
	return error;
}

static void m1_nand_boot_write_page_hwecc(struct mtd_info *mtd, struct nand_chip *chip, const uint8_t *buf)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	uint8_t *oob_buf = chip->oob_poi;
	unsigned nand_page_size = (1 << chip->page_shift);
	int error = 0, i = 0, ecc_bytes, user_byte_num;

	user_byte_num = ((nand_page_size / chip->ecc.size) * aml_chip->user_byte_mode);
	ecc_bytes = ((nand_page_size / chip->ecc.size) * chip->ecc.bytes);
	if (aml_chip->oob_size < (ecc_bytes + user_byte_num))
		nand_page_size -= chip->ecc.size;

	for (i=0; i<mtd->oobavail; i+=2) {
		oob_buf[i] = 0xaa;
		oob_buf[i+1] = 0x55;
	}
	i = 0;
	memset(oob_buf + mtd->oobavail, 0xa5, user_byte_num * (mtd->writesize / nand_page_size));
	if (aml_chip->valid_chip[i]) {

		aml_chip->aml_nand_select_chip(aml_chip, i);

		aml_chip->aml_nand_set_user_byte(aml_chip, oob_buf, user_byte_num);
		error = aml_chip->aml_nand_dma_write(aml_chip, (unsigned char *)buf, nand_page_size, aml_chip->bch_mode);
		if (error)
			goto exit;
		aml_chip->aml_nand_command(aml_chip, NAND_CMD_PAGEPROG, -1, -1, i);
	}
	else {
		error = -ENODEV;
		goto exit;
	}

exit:
	return;
}

static int m1_nand_boot_write_page(struct mtd_info *mtd, struct nand_chip *chip, const uint8_t *buf, int page, int cached, int raw)
{
	int status, i, write_page;

	for (i=0; i<M1_BOOT_COPY_NUM; i++) {

		write_page = page + i*M1_BOOT_PAGES_PER_COPY;
		chip->cmdfunc(mtd, NAND_CMD_SEQIN, 0x00, write_page);

		if (unlikely(raw))
			chip->ecc.write_page_raw(mtd, chip, buf);
		else
			chip->ecc.write_page(mtd, chip, buf);

		if (!cached || !(chip->options & NAND_CACHEPRG)) {

			status = chip->waitfunc(mtd, chip);

			if ((status & NAND_STATUS_FAIL) && (chip->errstat))
				status = chip->errstat(mtd, chip, FL_WRITING, status, write_page);

			if (status & NAND_STATUS_FAIL)
				return -EIO;
		} else {
			status = chip->waitfunc(mtd, chip);
		}
	}

	return 0;
}

static int m1_nand_probe(struct aml_nand_platform *plat, unsigned dev_num)
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

	aml_chip->platform = plat;
	aml_chip->bch_desc = m1_bch_list;
	aml_chip->aml_nand_options_confirm = m1_nand_options_confirm;
	aml_chip->max_bch_mode = sizeof(m1_bch_list) / sizeof(m1_bch_list[0]);
	plat->aml_chip = aml_chip;
	chip = &aml_chip->chip;
	chip->priv = &aml_chip->mtd;
	mtd = &aml_chip->mtd;
	mtd->priv = chip;
	mtd->name = plat->name;

	err = aml_nand_init(aml_chip);
	if (err)
		goto exit_error;

	if (!strncmp((char*)plat->name, NAND_BOOT_NAME, strlen((const char*)NAND_BOOT_NAME))) {
		chip->erase_cmd = m1_nand_boot_erase_cmd;
		chip->ecc.read_page = m1_nand_boot_read_page_hwecc;
		chip->ecc.write_page = m1_nand_boot_write_page_hwecc;
		chip->write_page = m1_nand_boot_write_page;
	}

	nand_info[dev_num] = mtd;
	return 0;

exit_error:
	if (aml_chip)
		kfree(aml_chip);
	mtd->name = NULL;
	return err;
}

#define DRV_NAME	"aml_m1_nand"
#define DRV_VERSION	"1.1"
#define DRV_AUTHOR	"xiaojun_yoyo"
#define DRV_DESC	"Amlogic nand flash uboot driver for m1"

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
		ret = m1_nand_probe(plat, i);
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

