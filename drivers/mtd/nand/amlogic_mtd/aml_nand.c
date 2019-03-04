#include <common.h>
#include <environment.h>
#include <nand.h>
#include <asm/io.h>
#include <malloc.h>
#include <linux/err.h>
#include <asm/cache.h>
// #include <asm/reboot.h>
#include <asm/arch/clock.h>
#include <asm/cpu_id.h>

#include "aml_mtd.h"

#if  0
#define aml_nand_debug(a...) \
	{ printk("%s()[%s,%d]",__func__,__FILE__,__LINE__); printk(a); }
#else
#define aml_nand_debug(a...)
#endif

uint8_t nand_boot_flag = 0;
extern unsigned char pagelist_1ynm_hynix256_mtd[128];
extern struct aml_nand_flash_dev aml_nand_flash_ids[];
extern struct hw_controller *controller;

#define NAND_CMD_SANDISK_DSP_OFF 0x25
#define	SANDISK_A19NM_4G 53
#define	INTEL_20NM 60

/*
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
*/

static struct nand_ecclayout aml_nand_uboot_oob = {
	.eccbytes = 84,
	.oobfree = {
		{.offset = 0,
		 .length = 6}}
};

static struct nand_ecclayout aml_nand_oob_64 = {
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
		 .length = 16}}
};

static struct nand_ecclayout aml_nand_oob_376 = {
	.eccbytes = 352,
	.oobfree = {
		{.offset = 0,
		 .length = 16}}
};

static struct nand_ecclayout aml_nand_oob_436 = {
	.eccbytes = 352,
	.oobfree = {
		{.offset = 0,
		 .length = 16}}
};

static struct nand_ecclayout aml_nand_oob_448 = {
	.eccbytes = 416,
	.oobfree = {
		{.offset = 0,
		 .length = 16}}
};

static struct nand_ecclayout aml_nand_oob_640 = {
	.eccbytes = 608,
	.oobfree = {
		{.offset = 0,
		 .length = 16}}
};

static struct nand_ecclayout aml_nand_oob_744 = {
	.eccbytes = 700,
	.oobfree = {
		{.offset = 0,
		 .length = 16}}
};

static struct nand_ecclayout aml_nand_oob_1280 = {
	.eccbytes = 1200,
	.oobfree = {
		{.offset = 0,
		 .length = 32}}
};

static struct nand_ecclayout aml_nand_oob_1664 = {
	.eccbytes = 1584,
	.oobfree = {
		{.offset = 0,
		 .length = 32}}
};

void aml_platform_get_user_byte(struct aml_nand_chip *aml_chip,
	unsigned char *oob_buf, int byte_num)
{
	int read_times = 0;
	unsigned int len = PER_INFO_BYTE / sizeof(unsigned int);

	while (byte_num > 0) {
		*oob_buf++ = (aml_chip->user_info_buf[read_times*len] & 0xff);
		byte_num--;
		if (aml_chip->user_byte_mode == 2) {
			*oob_buf++ =
			((aml_chip->user_info_buf[read_times*len] >> 8) & 0xff);
			byte_num--;
		}
		read_times++;
	}
}

void aml_platform_set_user_byte(struct aml_nand_chip *aml_chip,
	unsigned char *oob_buf, int byte_num)
{
	int write_times = 0;
	unsigned int len = PER_INFO_BYTE/sizeof(unsigned int);

	while (byte_num > 0) {
		aml_chip->user_info_buf[write_times*len] = *oob_buf++;
		byte_num--;
		if (aml_chip->user_byte_mode == 2) {
			aml_chip->user_info_buf[write_times*len] |=
				(*oob_buf++ << 8);
			byte_num--;
		}
		write_times++;
	}
}

int aml_nand_block_bad_scrub_update_bbt(struct mtd_info *mtd)
{
	return 0;
}

#ifdef NEW_NAND_SUPPORT
/*****************************HYNIX******************************************/
uint8_t aml_nand_get_reg_value_hynix(struct aml_nand_chip *aml_chip,
	uint8_t *buf, uint8_t *addr, int chipnr, int cnt)
{
	struct nand_chip *chip = &aml_chip->chip;
	struct mtd_info *mtd = &aml_chip->mtd;
	int j;

	if ((aml_chip->new_nand_info.type == 0)
		||(aml_chip->new_nand_info.type > 10))
		return 0;


	aml_chip->aml_nand_wait_devready(aml_chip, chipnr);
	aml_chip->aml_nand_command(aml_chip,
		NAND_CMD_HYNIX_GET_VALUE, -1, -1, chipnr);

	for (j = 0; j < cnt; j++) {
	        chip->cmd_ctrl(mtd,
			addr[j], NAND_CTRL_CHANGE | NAND_NCE | NAND_ALE);
	        NFC_SEND_CMD_IDLE(controller, 10);
		buf[j] = chip->read_byte(mtd);
	        NFC_SEND_CMD_IDLE(controller, 10);
        }

        aml_chip->aml_nand_wait_devready(aml_chip, chipnr);

	return 0;
}

static int dummy_read(struct aml_nand_chip *aml_chip, unsigned char chipnr)
{
	struct nand_chip *chip = &aml_chip->chip;
	struct mtd_info *mtd = &aml_chip->mtd;
	int i, ret = 0;

	ret = aml_chip->aml_nand_wait_devready(aml_chip, chipnr);
	aml_chip->aml_nand_command(aml_chip,
		NAND_CMD_READ0, -1, -1, chipnr);
	for (i = 0; i < 5; i++)
        chip->cmd_ctrl(mtd, 0x0, NAND_CTRL_CHANGE | NAND_NCE | NAND_ALE);
	aml_chip->aml_nand_command(aml_chip,
		NAND_CMD_READSTART, -1, -1, chipnr);

	ret = aml_chip->aml_nand_wait_devready(aml_chip, chipnr);

	return ret;
}

uint8_t aml_nand_set_reg_value_hynix(struct aml_nand_chip *aml_chip,
	uint8_t *buf, uint8_t *addr, int chipnr, int cnt)
{
	struct nand_chip *chip = &aml_chip->chip;
	struct mtd_info *mtd = &aml_chip->mtd;
	int j;

	if ((aml_chip->new_nand_info.type == 0)
		||(aml_chip->new_nand_info.type > 10))
		return 0;
	aml_chip->aml_nand_wait_devready(aml_chip, chipnr);
	aml_chip->aml_nand_command(aml_chip,
		NAND_CMD_HYNIX_SET_VALUE_START, -1, -1, chipnr);
	for (j = 0; j < cnt; j++) {
	        chip->cmd_ctrl(mtd, addr[j],
			NAND_CTRL_CHANGE | NAND_NCE | NAND_ALE);
	        NFC_SEND_CMD_IDLE(controller, 15);
		aml_chip->aml_nand_write_byte(aml_chip, buf[j]);
	        NFC_SEND_CMD_IDLE(controller, 0);

	}
	aml_chip->aml_nand_command(aml_chip,
		NAND_CMD_HYNIX_SET_VALUE_END, -1, -1, chipnr);
	aml_chip->aml_nand_wait_devready(aml_chip, chipnr);

	return 0;
}

int8_t aml_nand_get_20nm_OTP_value(struct aml_nand_chip *aml_chip,
	unsigned char *buf,int chipnr)
{
	struct nand_chip *chip = &aml_chip->chip;
	struct mtd_info *mtd = &aml_chip->mtd;
	int i, j, k, reg_cnt_otp, total_reg_cnt, check_flag = 0;
	unsigned char  *tmp_buf;

	total_reg_cnt = chip->read_byte(mtd);
	reg_cnt_otp = chip->read_byte(mtd);

	printk("%s %d : total byte %d\n",
		__func__, __LINE__, total_reg_cnt* reg_cnt_otp);

	for (i = 0; i < 8; i++) {
		check_flag = 0;
		memset(buf, 0, 128);
		for (j = 0; j < 128; j++) {
			buf[j] = chip->read_byte(mtd);
			ndelay(50);
		}
		for (j = 0; j < 64; j += 8) {
			for (k = 0;k < 7;k++) {
				if (((buf[k+j] < 0x80) && (buf[k+j+64] < 0x80))
				|| ((buf[k+j] > 0x80) && (buf[k+j+64] > 0x80))
			|| ((unsigned char)(buf[k+j]^buf[k+j+64]) != 0xFF)) {
					check_flag = 1;
					break;
				}
				if (check_flag)
					break;
			}
			if (check_flag)
				break;
		}
		if (check_flag == 0)
			break;
	}
	if (check_flag) {
		printk("%s %d 20nm flash default vaule abnormal,chip[%d]\n",
			__func__, __LINE__, chipnr);
		BUG();
	} else {
		tmp_buf = buf;
memcpy(&aml_chip->new_nand_info.read_rety_info.reg_default_value[chipnr][0],
		tmp_buf, aml_chip->new_nand_info.read_rety_info.reg_cnt);
		tmp_buf += aml_chip->new_nand_info.read_rety_info.reg_cnt;
		for(j = 0; j < aml_chip->new_nand_info.read_rety_info.retry_cnt;
			j++) {
			for(k = 0;
		k < aml_chip->new_nand_info.read_rety_info.reg_cnt; k++) {
	aml_chip->new_nand_info.read_rety_info.reg_offset_value[chipnr][j][k] =
		(char)tmp_buf[0];
				tmp_buf++;
			}
		}
	}
	return check_flag ;
}

int8_t aml_nand_get_1ynm_OTP_value(struct aml_nand_chip *aml_chip,
	unsigned char *buf,int chipnr)
{
	struct nand_chip *chip = &aml_chip->chip;
	struct mtd_info *mtd = &aml_chip->mtd;
	int i, j=1, k, m;
	int read_otp_cnt =0;
	uchar retry_value_sta[32] ={0};

	memset(buf, 0, 528);
	for (i = 0; i < 528; i++) {
		buf[i] = chip->read_byte(mtd);
		NFC_SEND_CMD_IDLE(controller, 0);
		NFC_SEND_CMD_IDLE(controller, 0);
	}

	for (read_otp_cnt = 0;read_otp_cnt < 8;read_otp_cnt++) {
		for (j = 0; j < 8; j++) {
			for (k = 0;k < 4;k++) {
				if (retry_value_sta[j * 4 + k] ==0) {
					m = k + j * 4 +16 + read_otp_cnt * 64;
					if ((u8)(buf[m] ^ buf[m + 32]) == 0xFF) {
						if (j ==0)
aml_chip->new_nand_info.read_rety_info.reg_default_value[chipnr][k] = buf[m];
						else
aml_chip->new_nand_info.read_rety_info.reg_offset_value[chipnr][j-1][k]= buf[m];
						retry_value_sta[j * 4 + k] = 1;
					}
				}

			}
		}
	}

	for (i = 0; i < controller->chip_num; i++) {
		if (aml_chip->valid_chip[i]) {
			for(j = 0;
			j < aml_chip->new_nand_info.read_rety_info.reg_cnt; j++)
				printk("%s, REG(0x%x):value:0x%2x,chip[%d]\n",
				__func__,
		aml_chip->new_nand_info.read_rety_info.reg_addr[j],
		aml_chip->new_nand_info.read_rety_info.reg_default_value[i][j],
		i);
		}
	}
	for (i = 0; i < controller->chip_num; i++) {
		if (aml_chip->valid_chip[i]) {
for (j = 0; j < aml_chip->new_nand_info.read_rety_info.retry_cnt; j++)
	for (k = 0; k < aml_chip->new_nand_info.read_rety_info.reg_cnt; k++)
		printk("%s, Retry%dst,REG(0x%x):value:0x%2x,chip[%d]\n",
			__func__, j,
		aml_chip->new_nand_info.read_rety_info.reg_addr[k],
	aml_chip->new_nand_info.read_rety_info.reg_offset_value[i][j][k],
		i);
		printk("\n");
		}
	}
	for (i = 0;i < 32; i++)
		if (retry_value_sta[i] == 0) {
			printk("  chip[%d] flash %d vaule abnormal not safe\n",
				chipnr, i);
			return 1;
		}

	return 0 ;
}

uint8_t aml_nand_get_reg_value_formOTP_hynix(struct aml_nand_chip *aml_chip,
	int chipnr)
{
	struct nand_chip *chip = &aml_chip->chip;
	struct mtd_info *mtd = &aml_chip->mtd;
	int  check_flag = 0;
	unsigned char *one_copy_buf;

	if ((aml_chip->new_nand_info.type < 3)
		||(aml_chip->new_nand_info.type > 10))
		return 0;

	one_copy_buf = (unsigned char *)kmalloc(528, GFP_KERNEL);
	if (one_copy_buf == NULL) {
		printk("%s %d no mem!!!!!\n",
			__func__, __LINE__);
		BUG();
		return 0;
	}

	aml_chip->aml_nand_wait_devready(aml_chip, chipnr);
	aml_chip->aml_nand_command(aml_chip,
		NAND_CMD_RESET, -1, -1, chipnr);
	aml_chip->aml_nand_wait_devready(aml_chip, chipnr);

	aml_chip->aml_nand_command(aml_chip,
		NAND_CMD_HYNIX_SET_VALUE_START, -1, -1, chipnr);
	        NFC_SEND_CMD_IDLE(controller, 0);
	if (aml_chip->new_nand_info.type == HYNIX_20NM_8GB) {
		chip->cmd_ctrl(mtd, 0xff,
			NAND_CTRL_CHANGE | NAND_NCE | NAND_ALE);
	        NFC_SEND_CMD_IDLE(controller, 0);
		aml_chip->aml_nand_write_byte(aml_chip,0x40 );
	        NFC_SEND_CMD_IDLE(controller, 0);
		chip->cmd_ctrl(mtd, 0xcc,
			NAND_CTRL_CHANGE | NAND_NCE | NAND_ALE);
	}
	else if(aml_chip->new_nand_info.type == HYNIX_20NM_4GB){
		chip->cmd_ctrl(mtd, 0xae,
			NAND_CTRL_CHANGE | NAND_NCE | NAND_ALE);
	        NFC_SEND_CMD_IDLE(controller, 0);
		aml_chip->aml_nand_write_byte(aml_chip,0x00 );
	        NFC_SEND_CMD_IDLE(controller, 0);
		chip->cmd_ctrl(mtd, 0xb0,
			NAND_CTRL_CHANGE | NAND_NCE | NAND_ALE);
	}
	else if(aml_chip->new_nand_info.type == HYNIX_1YNM_8GB){
		chip->cmd_ctrl(mtd, 0x38,
			NAND_CTRL_CHANGE | NAND_NCE | NAND_ALE);
	        NFC_SEND_CMD_IDLE(controller, 0);
		aml_chip->aml_nand_write_byte(aml_chip,0x52 );
	        NFC_SEND_CMD_IDLE(controller, 0);
	}
	        NFC_SEND_CMD_IDLE(controller, 0);

	if ((aml_chip->new_nand_info.type == HYNIX_20NM_4GB)
		|| (aml_chip->new_nand_info.type == HYNIX_20NM_8GB))
		aml_chip->aml_nand_write_byte(aml_chip,0x4d );

	aml_chip->aml_nand_command(aml_chip, 0x16, -1, -1, chipnr);
	aml_chip->aml_nand_command(aml_chip, 0x17, -1, -1, chipnr);
	aml_chip->aml_nand_command(aml_chip, 0x04, -1, -1, chipnr);
	aml_chip->aml_nand_command(aml_chip, 0x19, -1, -1, chipnr);
	aml_chip->aml_nand_command(aml_chip, NAND_CMD_READ0, 0, 0x200, chipnr);


#if 1
	aml_chip->aml_nand_wait_devready(aml_chip, chipnr);
	if (aml_chip->ops_mode & AML_CHIP_NONE_RB)
		chip->cmd_ctrl(mtd, NAND_CMD_READ0 & 0xff,
			NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);
#else
	udelay(500);
#endif


	if ((aml_chip->new_nand_info.type == HYNIX_20NM_4GB)
		||(aml_chip->new_nand_info.type == HYNIX_20NM_8GB))
		check_flag  = aml_nand_get_20nm_OTP_value(aml_chip,
			one_copy_buf, chipnr);
	else if(aml_chip->new_nand_info.type == HYNIX_1YNM_8GB)
		check_flag  = aml_nand_get_1ynm_OTP_value(aml_chip,
			one_copy_buf,chipnr);

	aml_chip->aml_nand_command(aml_chip, NAND_CMD_RESET, -1, -1, chipnr);

	aml_chip->aml_nand_wait_devready(aml_chip, chipnr);
	if ((aml_chip->new_nand_info.type == HYNIX_20NM_4GB)
		||(aml_chip->new_nand_info.type == HYNIX_20NM_8GB))
		aml_chip->aml_nand_command(aml_chip, 0x38, -1, -1, chipnr);

	else if(aml_chip->new_nand_info.type == HYNIX_1YNM_8GB) {
		aml_chip->aml_nand_command(aml_chip,
			NAND_CMD_HYNIX_SET_VALUE_START, -1, -1, chipnr);
		chip->cmd_ctrl(mtd, 0x38,
			NAND_CTRL_CHANGE | NAND_NCE | NAND_ALE);
		NFC_SEND_CMD_IDLE(controller, 0);
		aml_chip->aml_nand_write_byte(aml_chip,0 );
		NFC_SEND_CMD_IDLE(controller, 0);
		aml_chip->aml_nand_command(aml_chip, 0X16, -1, -1, chipnr);
	}
	aml_chip->aml_nand_wait_devready(aml_chip, chipnr);
	kfree(one_copy_buf);
	return check_flag;
}

void aml_nand_set_readretry_default_value_hynix(struct mtd_info *mtd)
{
	unsigned char hynix_reg_read_value_tmp[READ_RETRY_REG_NUM];
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	struct nand_chip *chip = mtd->priv;
	int i;

	if ((aml_chip->new_nand_info.type == 0)
		|| (aml_chip->new_nand_info.type > 10))
		return;


	memset(&hynix_reg_read_value_tmp[0], 0, READ_RETRY_REG_NUM);

	chip->select_chip(mtd, 0);
	for (i = 0; i < controller->chip_num; i++) {
		if (aml_chip->valid_chip[i]) {
			aml_nand_set_reg_value_hynix(aml_chip,
		&aml_chip->new_nand_info.read_rety_info.reg_default_value[i][0],
		&aml_chip->new_nand_info.read_rety_info.reg_addr[0],
		i, aml_chip->new_nand_info.read_rety_info.reg_cnt);
			/*aml_nand_hynix_get_parameters(aml_chip,
				&hynix_reg_read_value_tmp[0],
				&aml_chip->hynix_reg_read_addr[0], i, 4);*/
		}
	}
}

void aml_nand_enter_enslc_mode_hynix(struct mtd_info *mtd)
{
	unsigned char hynix_reg_program_value_tmp[ENHANCE_SLC_REG_NUM];
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	struct nand_chip *chip = mtd->priv;
	int i, j;

	if ((aml_chip->new_nand_info.type == 0)
		||(aml_chip->new_nand_info.type > 10))
		return;

	memset(&hynix_reg_program_value_tmp[0], 0, ENHANCE_SLC_REG_NUM);

	chip->select_chip(mtd, 0);
	for (i = 0; i < controller->chip_num; i++) {
		if (aml_chip->valid_chip[i]) {
			for(j = 0;
		j < aml_chip->new_nand_info.slc_program_info.reg_cnt;j++)
				hynix_reg_program_value_tmp[j] =
	aml_chip->new_nand_info.slc_program_info.reg_default_value[i][j] +
	aml_chip->new_nand_info.slc_program_info.reg_offset_value[j];

			aml_nand_set_reg_value_hynix(aml_chip,
				&hynix_reg_program_value_tmp[0],
			&aml_chip->new_nand_info.slc_program_info.reg_addr[0],
			i,
			aml_chip->new_nand_info.slc_program_info.reg_cnt);
			memset(&hynix_reg_program_value_tmp[0],
			0, aml_chip->new_nand_info.slc_program_info.reg_cnt);
		}
	}
}

//working in Normal program mode
void aml_nand_exit_enslc_mode_hynix(struct mtd_info *mtd)
{
	//unsigned char hynix_reg_read_value_tmp[5];
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	struct nand_chip *chip = mtd->priv;
	int i;

	if ((aml_chip->new_nand_info.type == 0)
		|| (aml_chip->new_nand_info.type > 10))
		return;

	chip->select_chip(mtd, 0);
	for (i = 0; i < controller->chip_num; i++) {
		if (aml_chip->valid_chip[i])
	aml_nand_set_reg_value_hynix(aml_chip,
	&aml_chip->new_nand_info.slc_program_info.reg_default_value[i][0],
	&aml_chip->new_nand_info.slc_program_info.reg_addr[0],
	i, aml_chip->new_nand_info.slc_program_info.reg_cnt);
		dummy_read(aml_chip,i);
	}
}

int aml_nand_slcprog_1ynm_hynix(struct mtd_info *mtd,
	unsigned char *buf ,unsigned char *oob_buf,unsigned page_addr)
{
	//size_t amount_saved = 0;
	//struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	int pages_per_blk = mtd->erasesize / mtd->writesize;
	int offset_in_blk = page_addr % pages_per_blk ;
	int error =0;
	struct mtd_oob_ops aml_oob_ops;
	struct nand_chip * chip = mtd->priv;
	unsigned char *data_buf;
	loff_t op_add ;
	unsigned op_page_add. temp_value;
	unsigned priv_slc_page, next_msb_page;

	temp_value = pagelist_1ynm_hynix256_mtd[offset_in_blk];
	op_page_add = (page_addr / pages_per_blk) * pages_per_blk + temp_value;
	data_buf = kzalloc(mtd->writesize, GFP_KERNEL);
	if (data_buf == NULL)
		return -ENOMEM;
	temp_value = pagelist_1ynm_hynix256_mtd[offset_in_blk - 1];
	if (offset_in_blk > 1)
		priv_slc_page =
		(page_addr / pages_per_blk) * pages_per_blk + temp_value;
	else
		priv_slc_page = op_page_add;
	next_msb_page = priv_slc_page +1;
	memset(data_buf,0xff,mtd->writesize);
	while (next_msb_page < op_page_add) {
		aml_oob_ops.mode = MTD_OPS_RAW;
		aml_oob_ops.len = mtd->writesize;
		aml_oob_ops.ooblen = mtd->oobavail;
		aml_oob_ops.ooboffs = chip->ecc.layout->oobfree[0].offset;
		aml_oob_ops.datbuf = data_buf;
		aml_oob_ops.oobbuf = oob_buf;
		op_add = next_msb_page*mtd->writesize;
		mtd->_write_oob(mtd, op_add, &aml_oob_ops);
		printk("Eneter 1y nm SLC mode ,must fill 0xff data into %d\n",
			next_msb_page);
		next_msb_page++;
	}
	aml_oob_ops.mode = MTD_OPS_AUTO_OOB;
	aml_oob_ops.len = mtd->writesize;
	aml_oob_ops.ooblen = mtd->oobavail;
	aml_oob_ops.ooboffs = chip->ecc.layout->oobfree[0].offset;
	aml_oob_ops.datbuf = buf;
	aml_oob_ops.oobbuf = oob_buf;
	op_add = op_page_add*mtd->writesize;
	error = mtd->_write_oob(mtd, op_add, &aml_oob_ops);
	printk("Eneter 1y nm SLC mode ,write systerm data into %d\n",
		op_page_add);
	if (error) {
		printk("blk check good but write failed: %llx, %d\n",
			(uint64_t)page_addr, error);
		goto err;
	 }
err:
	kfree(data_buf);
	return error;
}

void aml_nand_read_retry_handle_hynix(struct mtd_info *mtd, int chipnr)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	u8 hynix_reg_read_value[READ_RETRY_REG_NUM];
	int i, cur_cnt;
	int retry_zone,retry_offset;
	struct new_tech_nand_t *new_nand_info;

	new_nand_info = &aml_chip->new_nand_info;

	if ((new_nand_info->type == 0)
		||(new_nand_info->type > 10))
		return;

	if(new_nand_info->read_rety_info.cur_cnt[chipnr]
		< new_nand_info->read_rety_info.retry_cnt)
		cur_cnt =new_nand_info->read_rety_info.cur_cnt[chipnr];
	else {
		retry_zone =
			new_nand_info->read_rety_info.cur_cnt[chipnr]
			/ new_nand_info->read_rety_info.retry_cnt;
		retry_offset =
			new_nand_info->read_rety_info.cur_cnt[chipnr]
			% new_nand_info->read_rety_info.retry_cnt;
		cur_cnt =
	(retry_zone + retry_offset) % new_nand_info->read_rety_info.retry_cnt;
	}

	memset(&hynix_reg_read_value[0], 0, READ_RETRY_REG_NUM);

	for (i = 0; i < new_nand_info->read_rety_info.reg_cnt; i++) {
		if ((new_nand_info->type == HYNIX_26NM_8GB)
			|| (new_nand_info->type == HYNIX_26NM_4GB)) {
		if(new_nand_info->read_rety_info.reg_offset_value[0][cur_cnt][i]
			== READ_RETRY_ZERO)
				hynix_reg_read_value[i] = 0;
			else
				hynix_reg_read_value[i] =
		new_nand_info->read_rety_info.reg_default_value[chipnr][i]
		+ new_nand_info->read_rety_info.reg_offset_value[0][cur_cnt][i];
		} else if((new_nand_info->type == HYNIX_20NM_8GB)
			|| (new_nand_info->type == HYNIX_20NM_4GB)
			|| (new_nand_info->type == HYNIX_1YNM_8GB))
			hynix_reg_read_value[i] =
	new_nand_info->read_rety_info.reg_offset_value[chipnr][cur_cnt][i];
	}

	aml_nand_set_reg_value_hynix(aml_chip,
		&hynix_reg_read_value[0],
		&new_nand_info->read_rety_info.reg_addr[0],
		chipnr,
		new_nand_info->read_rety_info.reg_cnt);
	new_nand_info->read_rety_info.cur_cnt[chipnr]++;
}


void aml_nand_read_retry_exit_hynix(struct mtd_info *mtd, int chipnr)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	struct nand_chip *chip = mtd->priv;
	int i;
	struct new_tech_nand_t *new_nand_info;

	new_nand_info = &aml_chip->new_nand_info;

	if ((new_nand_info->type == 0)
		|| (new_nand_info->type > 10))
		return;

	aml_nand_debug("hyinx retry cnt :%d\n",
		new_nand_info->read_rety_info.cur_cnt[chipnr]);

	chip->select_chip(mtd, chipnr);
	for (i = 0; i < controller->chip_num; i++) {
		if (aml_chip->valid_chip[i])
			aml_nand_set_reg_value_hynix(aml_chip,
			&new_nand_info->read_rety_info.reg_default_value[i][0],
			&new_nand_info->read_rety_info.reg_addr[0],
			i, new_nand_info->read_rety_info.reg_cnt);
	}
	memset(&aml_chip->new_nand_info.read_rety_info.cur_cnt[0],
		0, MAX_CHIP_NUM);
}

void aml_nand_get_slc_default_value_hynix(struct mtd_info *mtd)
{
	struct nand_chip *chip = mtd->priv;
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	int i;

	chip->select_chip(mtd, 0);
	for (i = 0; i < controller->chip_num; i++) {
		if (aml_chip->valid_chip[i])
			aml_nand_get_reg_value_hynix(aml_chip,
	&aml_chip->new_nand_info.slc_program_info.reg_default_value[i][0],
			&aml_chip->new_nand_info.slc_program_info.reg_addr[0],
			i, aml_chip->new_nand_info.slc_program_info.reg_cnt);
	}
}

void aml_nand_get_read_default_value_hynix(struct mtd_info *mtd)
{
	struct mtd_oob_ops aml_oob_ops;
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	struct nand_chip *chip = mtd->priv;
	size_t addr;
	unsigned char *data_buf;
	char oob_buf[4];
	unsigned char page_list[RETRY_NAND_COPY_NUM] = {0x07, 0x0B, 0x0F, 0x13};
	int nand_type, total_blk, phys_erase_shift = fls(mtd->erasesize) - 1;
	int error = 0, i, j;

	data_buf = kzalloc(mtd->writesize, GFP_KERNEL);
	if (data_buf == NULL) {
		printk("%s %d no mem for databuf and mtd->writesize:%d \n",
			__func__, __LINE__, mtd->writesize);
		return;
	}

	addr = nand_boot_flag? (1024*mtd->writesize/aml_chip->plane_num) : 0;
	total_blk = 0;
	aml_chip->new_nand_info.read_rety_info.default_flag = 0;
	if (aml_chip->new_nand_info.type ==HYNIX_1YNM_8GB) {
		page_list[0] = 0;
		page_list[1] = 1;
		page_list[2] = 3;
		page_list[3] = 5;
	}

	while (total_blk < RETRY_NAND_BLK_NUM) {
		nand_type = aml_chip->new_nand_info.type;
		aml_chip->new_nand_info.type = 0;
		error = mtd->_block_isbad(mtd, addr);
		aml_chip->new_nand_info.type = nand_type;
		if (error) {
			printk("%s %d detect bad blk at blk:0x%x\n",
				__func__, __LINE__,
				(u32)addr>> phys_erase_shift);
			addr += mtd->erasesize;
			total_blk++;
			continue;
		}

		aml_oob_ops.mode = MTD_OPS_AUTO_OOB;
		aml_oob_ops.len = mtd->writesize;
		aml_oob_ops.ooblen = 4;
		aml_oob_ops.ooboffs = mtd->ecclayout->oobfree[0].offset;
		aml_oob_ops.datbuf = data_buf;
		aml_oob_ops.oobbuf = (uint8_t *)oob_buf;

		memset(oob_buf, 0, 4);
		memset((unsigned char *)aml_oob_ops.datbuf,
			0x0, mtd->writesize);
		memset((unsigned char *)aml_oob_ops.oobbuf,
			0x0, aml_oob_ops.ooblen);

		for (i = 0; i < RETRY_NAND_COPY_NUM; i++) {
			memset(oob_buf, 0, 4);
			memset((unsigned char *)aml_oob_ops.datbuf,
				0x0, mtd->writesize);
			memset((unsigned char *)aml_oob_ops.oobbuf,
				0x0, aml_oob_ops.ooblen);
			nand_type = aml_chip->new_nand_info.type;
			aml_chip->new_nand_info.type = 0;
			error = mtd->_read_oob(mtd,
			(addr + page_list[i]*mtd->writesize), &aml_oob_ops);
			aml_chip->new_nand_info.type = nand_type;
			if ((error != 0) && (error != -EUCLEAN)) {
				printk("%s %d read failed at blk:%ld pg:%ld\n",
					__func__, __LINE__,
					addr>> phys_erase_shift,
			(addr +  page_list[i]*mtd->writesize)/mtd->writesize);
				continue;
			}
			if (!memcmp(oob_buf, RETRY_NAND_MAGIC, 4)) {
	memcpy(&aml_chip->new_nand_info.read_rety_info.reg_default_value[0][0],
		(unsigned char *)aml_oob_ops.datbuf,
		MAX_CHIP_NUM*READ_RETRY_REG_NUM);
	for (i = 0; i < controller->chip_num; i++) {
		if (aml_chip->valid_chip[i]) {
			for(j = 0;
			j < aml_chip->new_nand_info.read_rety_info.reg_cnt; j++)
			printk("%s, REG(0x%x):	value:0x%2x, for chip[%d]\n",
			__func__,
			aml_chip->new_nand_info.read_rety_info.reg_addr[j],
		aml_chip->new_nand_info.read_rety_info.reg_default_value[i][j],
			i);
		}
	}

			if ((aml_chip->new_nand_info.type == HYNIX_20NM_8GB)
			|| (aml_chip->new_nand_info.type == HYNIX_20NM_4GB)
			|| (aml_chip->new_nand_info.type == HYNIX_1YNM_8GB)) {
				for (i = 0; i < controller->chip_num; i++) {
						if (aml_chip->valid_chip[i])
for (j = 0;j < aml_chip->new_nand_info.read_rety_info.retry_cnt;j++)
memcpy(&aml_chip->new_nand_info.read_rety_info.reg_offset_value[i][j][0],
		(unsigned char *)(aml_oob_ops.datbuf +
		MAX_CHIP_NUM * READ_RETRY_REG_NUM + j * READ_RETRY_REG_NUM
	+ i * HYNIX_RETRY_CNT * READ_RETRY_REG_NUM), READ_RETRY_REG_NUM);
					}
			}
			aml_chip->new_nand_info.read_rety_info.default_flag = 1;
			goto READ_OK;
			}
		}

		addr += mtd->erasesize;
		total_blk++;
	}
	aml_chip->new_nand_info.read_rety_info.default_flag = 0;

	printk("%s %d read def readretry reg value failed"
		"and need read from chip write back to nand using SLC\n",
		__func__, __LINE__);
	chip->select_chip(mtd, 0);

	for (i = 0; i < controller->chip_num; i++) {
		if (aml_chip->valid_chip[i]) {
			if ((aml_chip->new_nand_info.type == HYNIX_26NM_8GB)
			|| (aml_chip->new_nand_info.type == HYNIX_26NM_4GB)) {
				aml_nand_get_reg_value_hynix(aml_chip,
		&aml_chip->new_nand_info.read_rety_info.reg_default_value[i][0],
			&aml_chip->new_nand_info.read_rety_info.reg_addr[0],
			i, aml_chip->new_nand_info.read_rety_info.reg_cnt);
			} else if((aml_chip->new_nand_info.type==HYNIX_20NM_8GB)
			|| (aml_chip->new_nand_info.type == HYNIX_20NM_4GB)
			|| (aml_chip->new_nand_info.type == HYNIX_1YNM_8GB))
				aml_nand_get_reg_value_formOTP_hynix(aml_chip,
					i);
		}
	}
READ_OK:

	kfree(data_buf);
}

void aml_nand_save_read_default_value_hynix(struct mtd_info *mtd)
{
	struct mtd_oob_ops aml_oob_ops;
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	size_t addr;
	unsigned char *data_buf;
	char oob_buf[4];
	unsigned char page_list[RETRY_NAND_COPY_NUM] = {0x07, 0x0B, 0x0F, 0x13};
	int error = 0, i, j, total_blk, phys_erase_shift =fls(mtd->erasesize)-1;
	struct erase_info erase_info_read;

	if (aml_chip->new_nand_info.type != HYNIX_1YNM_8GB )
		for (i = 0;i < controller->chip_num; i++) {
			if (aml_chip->valid_chip[i]) {
for (j = 0; j < aml_chip->new_nand_info.read_rety_info.reg_cnt; j++)
	if ((aml_chip->new_nand_info.read_rety_info.reg_default_value[i][j]<0x18)
||(aml_chip->new_nand_info.read_rety_info.reg_default_value[i][j] > 0xd8)) {
		printk("%s %d def vaule abnormal not safe refuse to save!\n",
			__func__, __LINE__);
		return;
	}
			}
		}

	data_buf = kzalloc(mtd->writesize, GFP_KERNEL);
	if (data_buf == NULL) {
		printk("%s %d no mem for databuf and mtd->writesize:%d \n",
			__func__, __LINE__, mtd->writesize);
		return;
	}

	addr = nand_boot_flag? (1024*mtd->writesize/aml_chip->plane_num) : 0;
	total_blk = 0;
	while (total_blk < RETRY_NAND_BLK_NUM) {
		error = mtd->_block_isbad(mtd, addr);
		if (error) {
			printk("%s %d detect bad blk at blk:%ld\n",
				__func__, __LINE__, addr>> phys_erase_shift);
			addr += mtd->erasesize;
			total_blk++;
			continue;
		}

		memset(&erase_info_read, 0, sizeof(struct erase_info));
		erase_info_read.mtd = mtd;
		erase_info_read.addr = addr;
		erase_info_read.len = mtd->erasesize;

		error = mtd->_erase(mtd, &erase_info_read);
		if (error) {
			printk("%s %d erase failed at blk:%ld\n",
				__func__, __LINE__, addr>> phys_erase_shift);
			mtd->_block_markbad(mtd, addr);
			addr += mtd->erasesize;
			total_blk++;
			continue;
		}
		if (aml_chip->new_nand_info.slc_program_info.enter_enslc_mode)
		aml_chip->new_nand_info.slc_program_info.enter_enslc_mode(mtd);

		aml_oob_ops.mode = MTD_OPS_AUTO_OOB;
		aml_oob_ops.len = mtd->writesize;
		aml_oob_ops.ooblen = 4;
		aml_oob_ops.ooboffs = mtd->ecclayout->oobfree[0].offset;
		aml_oob_ops.datbuf = data_buf;
		aml_oob_ops.oobbuf = (uint8_t *)oob_buf;
		memcpy(oob_buf, RETRY_NAND_MAGIC, 4);
		memset((unsigned char *)aml_oob_ops.datbuf,
			0x0, mtd->writesize);
		memcpy((unsigned char *)aml_oob_ops.datbuf,
		&aml_chip->new_nand_info.read_rety_info.reg_default_value[0][0],
		MAX_CHIP_NUM * READ_RETRY_REG_NUM);

/*
memcpy((unsigned char *)(aml_oob_ops.datbuf + MAX_CHIP_NUM*READ_RETRY_REG_NUM),
	&aml_chip->new_nand_info.read_rety_info.reg_offset_value[0][0][0],
	MAX_CHIP_NUM*READ_RETRY_CNT*READ_RETRY_REG_NUM);
memcpy((unsigned char *)aml_oob_ops.datbuf,
	&aml_chip->new_nand_info.slc_program_info.reg_default_value[0][0],
	MAX_CHIP_NUM*ENHANCE_SLC_REG_NUM);
*/
		for (i = 0; i < controller->chip_num; i++) {
			if (aml_chip->valid_chip[i]) {
				for (j = 0;j < HYNIX_RETRY_CNT; j++)
memcpy((u8 *)(aml_oob_ops.datbuf + MAX_CHIP_NUM * READ_RETRY_REG_NUM +
	j * READ_RETRY_REG_NUM + i * READ_RETRY_REG_NUM * HYNIX_RETRY_CNT),
	&aml_chip->new_nand_info.read_rety_info.reg_offset_value[i][j][0],
	READ_RETRY_REG_NUM);
			}
		}
		for (i = 0; i < RETRY_NAND_COPY_NUM; i++) {
			if (aml_chip->new_nand_info.type != HYNIX_1YNM_8GB )
				error = mtd->_write_oob(mtd,
					addr + page_list[i]*mtd->writesize,
					&aml_oob_ops);
			else
				error= aml_nand_slcprog_1ynm_hynix(mtd,
					data_buf,
					(unsigned char *)oob_buf,
					(addr/mtd->writesize)+i);

			if (error) {
				printk("%s %d write failed blk:%ld page:%ld\n",
					__func__, __LINE__,
					addr>> phys_erase_shift,
		(addr + page_list[i] * mtd->writesize) / mtd->writesize);
				continue;
			}
		}
		if (aml_chip->new_nand_info.type == HYNIX_1YNM_8GB )
			error = aml_nand_slcprog_1ynm_hynix(mtd,
				data_buf,
				(unsigned char *)oob_buf,
				(addr/mtd->writesize) + i);
		if (aml_chip->new_nand_info.slc_program_info.exit_enslc_mode)
		aml_chip->new_nand_info.slc_program_info.exit_enslc_mode(mtd);

		addr += mtd->erasesize;
		total_blk++;
	}

	kfree(data_buf);
}



/*******************************************TOSHIBA*********************************************/
uint8_t aml_nand_set_reg_value_toshiba(struct aml_nand_chip *aml_chip,
	uint8_t *buf, uint8_t *addr, int chipnr, int cnt)
{
	struct nand_chip *chip = &aml_chip->chip;
	struct mtd_info *mtd = &aml_chip->mtd;
	int j;

	aml_chip->aml_nand_wait_devready(aml_chip, chipnr);

	aml_chip->aml_nand_select_chip(aml_chip, chipnr);

	if (aml_chip->new_nand_info.read_rety_info.cur_cnt[chipnr] ==0) {
		aml_chip->aml_nand_command(aml_chip,
			NAND_CMD_TOSHIBA_PRE_CON1, -1, -1, chipnr);
	        NFC_SEND_CMD_IDLE(controller, 2);
		aml_chip->aml_nand_command(aml_chip,
			NAND_CMD_TOSHIBA_PRE_CON2, -1, -1, chipnr);
	        NFC_SEND_CMD_IDLE(controller, 2);
	}

	for (j=0; j<cnt; j++) {
		aml_chip->aml_nand_command(aml_chip,
			NAND_CMD_TOSHIBA_SET_VALUE, -1, -1, chipnr);
	        NFC_SEND_CMD_IDLE(controller, 2);
	        chip->cmd_ctrl(mtd, addr[j],
			NAND_CTRL_CHANGE | NAND_NCE | NAND_ALE);
	        NFC_SEND_CMD_IDLE(controller, 2);
		aml_chip->aml_nand_write_byte(aml_chip, buf[j]);
	        NFC_SEND_CMD_IDLE(controller, 2);
	}

	aml_chip->aml_nand_command(aml_chip,
		NAND_CMD_TOSHIBA_BEF_COMMAND1, -1, -1, chipnr);
	NFC_SEND_CMD_IDLE(controller, 2);
	aml_chip->aml_nand_command(aml_chip,
		NAND_CMD_TOSHIBA_BEF_COMMAND2, -1, -1, chipnr);
	NFC_SEND_CMD_IDLE(controller, 2);
	aml_chip->aml_nand_wait_devready(aml_chip, chipnr);

	return 0;
}


void aml_nand_read_retry_handle_toshiba(struct mtd_info *mtd, int chipnr)
{
	/*
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	int cur_cnt;

	//if(aml_chip->new_nand_info.type != TOSHIBA_24NM)
	//	return;

	if (aml_chip->toggle_mode) {
		NFC_EXIT_SYNC_ADJ() ;
		NFC_EXIT_TOSHIBA_TOGGLE_MODE();
	}
	cur_cnt = aml_chip->new_nand_info.read_rety_info.cur_cnt[chipnr];

	aml_nand_set_reg_value_toshiba(aml_chip,
(u8 *)&aml_chip->new_nand_info.read_rety_info.reg_offset_value[0][cur_cnt][0],
		&aml_chip->new_nand_info.read_rety_info.reg_addr[0],
		chipnr,
		aml_chip->new_nand_info.read_rety_info.reg_cnt);

	cur_cnt++;
	aml_chip->new_nand_info.read_rety_info.cur_cnt[chipnr] =
(cur_cnt > (aml_chip->new_nand_info.read_rety_info.retry_cnt-1)) ? 0 : cur_cnt;

	if (aml_chip->toggle_mode) {
		NFC_SYNC_ADJ();
		NFC_ENABLE_TOSHIBA_TOGGLE_MODE();
	}
	*/
}

void aml_nand_read_retry_exit_toshiba(struct mtd_info *mtd, int chipnr)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);

	struct nand_chip *chip = &aml_chip->chip;
	uint8_t buf[5] = {0};
	int j;

	if (aml_chip->new_nand_info.type == TOSHIBA_A19NM) {
		for (j = 0;
		j < aml_chip->new_nand_info.read_rety_info.reg_cnt; j++) {
			aml_chip->aml_nand_command(aml_chip,
				NAND_CMD_TOSHIBA_SET_VALUE, -1, -1, chipnr);
			udelay(1);
			chip->cmd_ctrl(mtd,
			aml_chip->new_nand_info.read_rety_info.reg_addr[j],
			NAND_CTRL_CHANGE | NAND_NCE | NAND_ALE);
			udelay(1);
			aml_chip->aml_nand_write_byte(aml_chip, buf[j]);
		}
	}
	aml_chip->aml_nand_wait_devready(aml_chip, chipnr);
	aml_chip->aml_nand_command(aml_chip,
		NAND_CMD_RESET, -1, -1, chipnr);
	aml_chip->aml_nand_wait_devready(aml_chip, chipnr);

	memset(&aml_chip->new_nand_info.read_rety_info.cur_cnt[0],
		0, MAX_CHIP_NUM);
}


/*******************************************SUMSUNG***********************/
uint8_t aml_nand_set_reg_value_samsung(struct aml_nand_chip *aml_chip,
	uint8_t *buf, uint8_t *addr, int chipnr, int cnt)
{
	struct nand_chip *chip = &aml_chip->chip;
	struct mtd_info *mtd = &aml_chip->mtd;
	int j;

	if (aml_chip->new_nand_info.type != SUMSUNG_2XNM)
		return 0;

	aml_chip->aml_nand_wait_devready(aml_chip, chipnr);

	aml_chip->aml_nand_select_chip(aml_chip, chipnr);

	for (j = 0; j < cnt; j++) {
		aml_chip->aml_nand_command(aml_chip,
			NAND_CMD_SAMSUNG_SET_VALUE, -1, -1, chipnr);
		chip->cmd_ctrl(mtd,0, NAND_CTRL_CHANGE | NAND_NCE | NAND_ALE);
		chip->cmd_ctrl(mtd,addr[j],
			NAND_CTRL_CHANGE | NAND_NCE | NAND_ALE);
		aml_chip->aml_nand_write_byte(aml_chip, buf[j]);
		NFC_SEND_CMD_IDLE(controller, 20);
	}

	aml_chip->aml_nand_wait_devready(aml_chip, chipnr);
	return 0;
}

void aml_nand_read_retry_handle_samsung(struct mtd_info *mtd, int chipnr)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	int cur_cnt;

	if (aml_chip->new_nand_info.type != SUMSUNG_2XNM)
		return;

	cur_cnt = aml_chip->new_nand_info.read_rety_info.cur_cnt[chipnr];

	aml_nand_set_reg_value_samsung(aml_chip,
(u8 *)&aml_chip->new_nand_info.read_rety_info.reg_offset_value[0][cur_cnt][0],
		&aml_chip->new_nand_info.read_rety_info.reg_addr[0],
		chipnr,
		aml_chip->new_nand_info.read_rety_info.reg_cnt);

	cur_cnt++;
	aml_chip->new_nand_info.read_rety_info.cur_cnt[chipnr] =
(cur_cnt > (aml_chip->new_nand_info.read_rety_info.retry_cnt-1)) ? 0 : cur_cnt;
}

void aml_nand_read_retry_exit_samsung(struct mtd_info *mtd, int chipnr)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);

	if (aml_chip->new_nand_info.type != SUMSUNG_2XNM)
		return;

	aml_nand_debug("samsung retry cnt :%d\n",
		aml_chip->new_nand_info.read_rety_info.cur_cnt[chipnr]);
	aml_nand_set_reg_value_samsung(aml_chip,
(uint8_t *)&aml_chip->new_nand_info.read_rety_info.reg_offset_value[0][0][0],
		&aml_chip->new_nand_info.read_rety_info.reg_addr[0],
		chipnr,
		aml_chip->new_nand_info.read_rety_info.reg_cnt);
	memset(&aml_chip->new_nand_info.read_rety_info.cur_cnt[0],
		0, MAX_CHIP_NUM);
}

void aml_nand_set_reg_default_hynix(void)
{
	struct mtd_info *mtd = (struct mtd_info *)&nand_info[nand_curr_device];

	if (!strcmp(mtd->name,NAND_BOOT_NAME)) {
#ifdef NEW_NAND_SUPPORT
		aml_nand_set_readretry_default_value_hynix(mtd);
		aml_nand_exit_enslc_mode_hynix(mtd);
#endif
	}
}
/***********************************MICRON************************************/

uint8_t aml_nand_set_reg_value_micron(struct aml_nand_chip *aml_chip,
	uint8_t *buf, uint8_t *addr, int chipnr, int cnt)
{
	struct nand_chip *chip = &aml_chip->chip;
	struct mtd_info *mtd = &aml_chip->mtd;
	int i;

	if (aml_chip->new_nand_info.type != MICRON_20NM)
		return 0;

	aml_chip->aml_nand_wait_devready(aml_chip, chipnr);

	aml_chip->aml_nand_select_chip(aml_chip, chipnr);

	aml_chip->aml_nand_command(aml_chip,
		NAND_CMD_MICRON_SET_VALUE, -1, -1, chipnr);

	chip->cmd_ctrl(mtd,addr[0],
		NAND_CTRL_CHANGE | NAND_NCE | NAND_ALE);
	NFC_SEND_CMD_IDLE(controller, 10);
	aml_chip->aml_nand_write_byte(aml_chip, buf[0]);
	for (i = 0; i < 3; i++) {
		NFC_SEND_CMD_IDLE(controller, 1);
		aml_chip->aml_nand_write_byte(aml_chip, 0x0);
	}

	aml_chip->aml_nand_wait_devready(aml_chip, chipnr);

	return 0;
}

void aml_nand_read_retry_handle_micron(struct mtd_info *mtd, int chipnr)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	int cur_cnt;

	if (aml_chip->new_nand_info.type != MICRON_20NM)
		return;

	cur_cnt = aml_chip->new_nand_info.read_rety_info.cur_cnt[chipnr];
	aml_nand_set_reg_value_micron(aml_chip,
(u8 *)&aml_chip->new_nand_info.read_rety_info.reg_offset_value[0][cur_cnt][0],
		&aml_chip->new_nand_info.read_rety_info.reg_addr[0],
		chipnr,
		aml_chip->new_nand_info.read_rety_info.reg_cnt);

	cur_cnt++;
	aml_chip->new_nand_info.read_rety_info.cur_cnt[chipnr] =
(cur_cnt > (aml_chip->new_nand_info.read_rety_info.retry_cnt-1)) ? 0 : cur_cnt;

	return ;
}

void aml_nand_read_retry_exit_micron(struct mtd_info *mtd, int chipnr)
{

	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);

	if (aml_chip->new_nand_info.type != MICRON_20NM)
		return;

	int default_val = 0;
	aml_nand_debug("micron retry cnt :%d\n",
		aml_chip->new_nand_info.read_rety_info.cur_cnt[chipnr]);
	aml_nand_set_reg_value_micron(aml_chip, (uint8_t *)&default_val,
		&aml_chip->new_nand_info.read_rety_info.reg_addr[0],
		chipnr, aml_chip->new_nand_info.read_rety_info.reg_cnt);
	memset(&aml_chip->new_nand_info.read_rety_info.cur_cnt[0],
		0, MAX_CHIP_NUM);

	return ;
}

/**************************INTEL***************************************/
void aml_nand_read_retry_handle_intel(struct mtd_info *mtd, int chipnr)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	int cur_cnt;
	int advance = 1;

	cu_cnt = aml_chip->new_nand_info.read_rety_info.cur_cnt[chipnr];
	printk("intel NAND set partmeters here and read_retry_cnt:%d\n",
		cur_cnt );
	if (cur_cnt == 3)
		aml_nand_set_reg_value_micron(aml_chip, (uint8_t *)&advance,
			&aml_chip->new_nand_info.read_rety_info.reg_addr[1],
			chipnr,
			aml_chip->new_nand_info.read_rety_info.reg_cnt);

	aml_nand_set_reg_value_micron(aml_chip,
(u8 *)&aml_chip->new_nand_info.read_rety_info.reg_offset_value[0][cur_cnt][0],
		&aml_chip->new_nand_info.read_rety_info.reg_addr[0],
		chipnr,
		aml_chip->new_nand_info.read_rety_info.reg_cnt);
	udelay(10);

	cur_cnt++;
	aml_chip->new_nand_info.read_rety_info.cur_cnt[chipnr] =
(cur_cnt > (aml_chip->new_nand_info.read_rety_info.retry_cnt-1)) ? 0 : cur_cnt;
	return ;
}

void aml_nand_read_retry_exit_intel(struct mtd_info *mtd, int chipnr)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	int default_val = 0;

	aml_nand_set_reg_value_micron(aml_chip, (uint8_t *)&default_val,
		&aml_chip->new_nand_info.read_rety_info.reg_addr[0],
		chipnr, aml_chip->new_nand_info.read_rety_info.reg_cnt);
	aml_nand_set_reg_value_micron(aml_chip, (uint8_t *)&default_val,
		&aml_chip->new_nand_info.read_rety_info.reg_addr[1],
		chipnr, aml_chip->new_nand_info.read_rety_info.reg_cnt);
	memset(&aml_chip->new_nand_info.read_rety_info.cur_cnt[0],
		0, MAX_CHIP_NUM);

	return ;
}
/***********************************SANDISK************************************/

uint8_t aml_nand_dynamic_read_init_start(struct aml_nand_chip *aml_chip,
	int chipnr)
{
	struct nand_chip *chip = &aml_chip->chip;
	struct mtd_info *mtd = &aml_chip->mtd;
	uint8_t *buf;
	int i=0;

	buf = &aml_chip->new_nand_info.dynamic_read_info.reg_addr_init[0];

	aml_chip->aml_nand_command(aml_chip, NAND_CMD_SANDISK_INIT_ONE,
		-1, -1, chipnr);

	aml_chip->aml_nand_command(aml_chip,
		NAND_CMD_SANDISK_INIT_TWO, -1, -1, chipnr);

	for (i = 0; i < DYNAMIC_REG_INIT_NUM; i++) {
		aml_chip->aml_nand_command(aml_chip,
			NAND_CMD_SANDISK_LOAD_VALUE_ONE, -1, -1, chipnr);
		NFC_SEND_CMD_IDLE(controller, 10);
		chip->cmd_ctrl(mtd, buf[i],
			NAND_CTRL_CHANGE | NAND_NCE | NAND_ALE);
		NFC_SEND_CMD_IDLE(controller, 10);
		aml_chip->aml_nand_write_byte(aml_chip,0x0 );
		NFC_SEND_CMD_IDLE(controller, 10);
	}
	return 0;
}

void aml_nand_dynamic_read_init(struct mtd_info *mtd)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	int i;

	if ((aml_chip->new_nand_info.type < SANDISK_19NM))
		return;

	aml_chip->new_nand_info.dynamic_read_info.dynamic_read_flag = 1;

	for (i = 0; i < controller->chip_num; i++) {
		if (aml_chip->valid_chip[i]) {
			if ((aml_chip->new_nand_info.type == SANDISK_19NM)
			||(aml_chip->new_nand_info.type == SANDISK_24NM))
				aml_nand_dynamic_read_init_start(aml_chip, i);
		}
	}
}

u8 aml_nand_dynamic_read_load_register_value(struct aml_nand_chip *aml_chip,
	uint8_t *buf, uint8_t *addr, int chipnr, int cnt)
{
	struct nand_chip *chip = &aml_chip->chip;
	struct mtd_info *mtd = &aml_chip->mtd;
	int j;

	if (aml_chip->new_nand_info.type < SANDISK_19NM)
		return 0;

	aml_chip->aml_nand_wait_devready(aml_chip, chipnr);

	aml_chip->aml_nand_select_chip(aml_chip, chipnr);

	aml_chip->aml_nand_command(aml_chip,
		NAND_CMD_SANDISK_INIT_ONE, -1, -1, chipnr);
	aml_chip->aml_nand_command(aml_chip,
		NAND_CMD_SANDISK_INIT_TWO, -1, -1, chipnr);

	for (j = 0; j < cnt; j++) {
		aml_chip->aml_nand_command(aml_chip,
			NAND_CMD_SANDISK_LOAD_VALUE_ONE, -1, -1, chipnr);
		NFC_SEND_CMD_IDLE(controller, 10);
		chip->cmd_ctrl(mtd, addr[j],
			NAND_CTRL_CHANGE | NAND_NCE | NAND_ALE);
		NFC_SEND_CMD_IDLE(controller, 10);
		aml_chip->aml_nand_write_byte(aml_chip, buf[j]);
		NFC_SEND_CMD_IDLE(controller, 10);
	}
	aml_chip->aml_nand_wait_devready(aml_chip, chipnr);
	return 0;
}

void aml_nand_dynamic_read_handle(struct mtd_info *mtd, int page, int chipnr)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	struct nand_chip *chip = &aml_chip->chip;
	u8 dynamic_reg_read_value[DYNAMIC_REG_NUM];
	u8 dynamic_reg_addr_value[DYNAMIC_REG_NUM];
	int cur_lower_page, cur_upper_page , i;
	int pages_per_blk;
	struct new_tech_nand_t *new_nand_info;

	new_nand_info = &aml_chip->new_nand_info;
	if (new_nand_info->type !=SANDISK_19NM)
		return;

	cur_upper_page =
	new_nand_info->dynamic_read_info.cur_upper_page[chipnr];
	cur_lower_page =
	new_nand_info->dynamic_read_info.cur_lower_page[chipnr];

	pages_per_blk = (1 << (chip->phys_erase_shift - chip->page_shift));
	if (((page !=0) && (page % 2 ) == 0) || (page == (pages_per_blk -1))) {
		memset(&dynamic_reg_read_value[0], 0, DYNAMIC_REG_NUM);
		memset(&dynamic_reg_addr_value[0], 0, DYNAMIC_REG_NUM);
		for (i = 0; i < DYNAMIC_REG_NUM; i++) {
			dynamic_reg_read_value[i] =
new_nand_info->dynamic_read_info.reg_offset_value_upper_page[cur_upper_page][i];
			dynamic_reg_addr_value[i] =
			new_nand_info->dynamic_read_info.reg_addr_upper_page[i];

		}

		aml_nand_dynamic_read_load_register_value(aml_chip,
			&dynamic_reg_read_value[0],
			&dynamic_reg_addr_value [0], chipnr, DYNAMIC_REG_NUM);
		udelay(2);

		cur_upper_page++;
	new_nand_info->dynamic_read_info.cur_case_num_upper_page[chipnr] =
		(cur_upper_page > DYNAMIC_READ_CNT_UPPER) ? 0 : cur_upper_page;

		//enable dynamic read
		aml_chip->aml_nand_command(aml_chip,
			NAND_CMD_SANDISK_DYNAMIC_ENABLE, -1, -1, chipnr);
		udelay(1);
	} else {
		memset(&dynamic_reg_read_value[0], 0, DYNAMIC_REG_NUM);
		memset(&dynamic_reg_addr_value[0], 0, DYNAMIC_REG_NUM);
		for (i = 0;i < DYNAMIC_REG_NUM; i++) {
			dynamic_reg_read_value[i] =
new_nand_info->dynamic_read_info.reg_offset_value_lower_page[cur_lower_page][i];
			dynamic_reg_addr_value[i] =
			new_nand_info->dynamic_read_info.reg_addr_lower_page[i];
		}

		aml_nand_dynamic_read_load_register_value(aml_chip,
			&dynamic_reg_read_value[0],
			&dynamic_reg_addr_value [0],
			chipnr, DYNAMIC_REG_NUM);

		cur_lower_page++;
	new_nand_info->dynamic_read_info.cur_case_num_lower_page[chipnr] =
		(cur_lower_page > DYNAMIC_READ_CNT_LOWER) ? 0 : cur_lower_page;

		//enable dynamic read
		aml_chip->aml_nand_command(aml_chip,
			NAND_CMD_SANDISK_DYNAMIC_ENABLE, -1, -1, chipnr);
	}
}


void aml_nand_read_retry_handle_sandisk(struct mtd_info *mtd, int chipnr)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	int cur_cnt;
	struct new_tech_nand_t *new_nand_info;

	new_nand_info = &aml_chip->new_nand_info;
	cur_cnt = new_nand_info->read_rety_info.cur_cnt[chipnr];

	aml_nand_dynamic_read_load_register_value(aml_chip,
(uint8_t *)&new_nand_info->read_rety_info.reg_offset_value[0][cur_cnt][0],
		&new_nand_info->read_rety_info.reg_addr[0],
		chipnr,
		new_nand_info->read_rety_info.reg_cnt);
	cur_cnt++;
	new_nand_info->read_rety_info.cur_cnt[chipnr] =
	(cur_cnt > (new_nand_info->read_rety_info.retry_cnt-1)) ? 0 : cur_cnt;
	return ;
}

void aml_nand_dynamic_read_exit(struct mtd_info *mtd, int chipnr)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);

	if (aml_chip->new_nand_info.type < SANDISK_19NM)
		return;

	aml_chip->aml_nand_wait_devready(aml_chip, chipnr);
	aml_chip->aml_nand_command(aml_chip,
		NAND_CMD_SANDISK_DYNAMIC_DISABLE, -1, -1, chipnr);
	aml_chip->aml_nand_wait_devready(aml_chip, chipnr);

	aml_nand_dynamic_read_init(mtd);

	aml_chip->aml_nand_wait_devready(aml_chip, chipnr);
	aml_chip->aml_nand_command(aml_chip, NAND_CMD_RESET, -1, -1, chipnr);
	aml_chip->aml_nand_wait_devready(aml_chip, chipnr);

	memset(&aml_chip->new_nand_info.read_rety_info.cur_cnt[0],
		0, MAX_CHIP_NUM);
	return ;
}

uint8_t aml_nand_set_featureReg_value_sandisk(struct aml_nand_chip *aml_chip,
	uint8_t *buf, uint8_t addr, int chipnr, int cnt)
{
	struct nand_chip *chip = &aml_chip->chip;
	struct mtd_info *mtd = &aml_chip->mtd;
	int j;

	chip->select_chip(mtd, chipnr);

	aml_chip->aml_nand_wait_devready(aml_chip, chipnr);

	udelay(1);

	chip->cmd_ctrl(mtd, NAND_CMD_SANDISK_SET_VALUE,
		NAND_CTRL_CHANGE | NAND_NCE | NAND_CLE);

	udelay(1);
	chip->cmd_ctrl(mtd, addr, NAND_CTRL_CHANGE | NAND_NCE | NAND_ALE);

	for (j = 0; j < cnt; j++) {
		ndelay(200);
		aml_chip->aml_nand_write_byte(aml_chip, buf[j]);
	}
	udelay(10);
	aml_chip->aml_nand_wait_devready(aml_chip, chipnr);

	return 0;
}

void aml_nand_read_retry_handleA19_sandisk(struct mtd_info *mtd, int chipnr)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	struct nand_chip *chip = &aml_chip->chip;
	int cur_cnt;
	unsigned	page = aml_chip->page_addr;
	int pages_per_blk;
	int page_info = 1;
	struct new_tech_nand_t *new_nand_info;

	new_nand_info = &aml_chip->new_nand_info;
	pages_per_blk = (1 << (chip->phys_erase_shift - chip->page_shift));
	page = page % pages_per_blk;

	if (((page !=0) && (page % 2 ) == 0) || (page == (pages_per_blk -1)))
		page_info =  0;

	cur_cnt = new_nand_info->read_rety_info.cur_cnt[chipnr];

	aml_nand_set_featureReg_value_sandisk(aml_chip,
(u8 *)(&new_nand_info->read_rety_info.reg_offset_value[page_info][cur_cnt][0]),
	(uint8_t)(unsigned int)(new_nand_info->read_rety_info.reg_addr[0]),
	chipnr, new_nand_info->read_rety_info.reg_cnt);

	aml_chip->aml_nand_command(aml_chip,
		NAND_CMD_SANDISK_DSP_OFF, -1, -1, chipnr);

	if (new_nand_info->type == SANDISK_A19NM)
		aml_chip->aml_nand_command(aml_chip,
			NAND_CMD_SANDISK_DSP_ON, -1, -1, chipnr);

	aml_chip->aml_nand_command(aml_chip,
		NAND_CMD_SANDISK_RETRY_STA, -1, -1, chipnr);

	cur_cnt++;
	new_nand_info->read_rety_info.cur_cnt[chipnr] =
	(cur_cnt > (new_nand_info->read_rety_info.retry_cnt-1)) ? 0 : cur_cnt;

	return ;
}

void aml_nand_read_retry_exit_A19_sandisk(struct mtd_info *mtd, int chipnr)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	uint8_t buf[4] = {0};

	aml_nand_set_featureReg_value_sandisk(aml_chip, buf,
(uint8_t)(unsigned int)(aml_chip->new_nand_info.read_rety_info.reg_addr[0]),
		chipnr,
		aml_chip->new_nand_info.read_rety_info.reg_cnt);

	aml_chip->aml_nand_wait_devready(aml_chip, chipnr);
	aml_chip->aml_nand_command(aml_chip, NAND_CMD_RESET, -1, -1, chipnr);
	aml_chip->aml_nand_wait_devready(aml_chip, chipnr);

	memset(&aml_chip->new_nand_info.read_rety_info.cur_cnt[0],
		0, MAX_CHIP_NUM);
}

void aml_nand_enter_slc_mode_sandisk(struct mtd_info *mtd)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);

	aml_chip->new_nand_info.dynamic_read_info.slc_flag = 1;
	return;
}

void aml_nand_exit_slc_mode_sandisk(struct mtd_info *mtd)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);

	aml_chip->new_nand_info.dynamic_read_info.slc_flag = 0;
	return;
}

uint8_t aml_nand_set_featureReg_value_toshiba(struct aml_nand_chip *aml_chip,
	uint8_t *buf, uint8_t addr, int chipnr, int cnt)
{
	struct nand_chip *chip = &aml_chip->chip;
	struct mtd_info *mtd = &aml_chip->mtd;
	int j;

	chip->select_chip(mtd, chipnr);

	aml_chip->aml_nand_wait_devready(aml_chip, chipnr);

	chip->cmd_ctrl(mtd, NAND_CMD_SANDISK_SET_VALUE,
		NAND_CTRL_CHANGE | NAND_NCE | NAND_CLE);

	NFC_SEND_CMD_IDLE(controller, 10);
	chip->cmd_ctrl(mtd, addr, NAND_CTRL_CHANGE | NAND_NCE | NAND_ALE);

	for (j = 0; j < cnt; j++) {
		NFC_SEND_CMD_IDLE(controller, 10);
		aml_chip->aml_nand_write_byte(aml_chip, buf[j]);
	}
	aml_chip->aml_nand_wait_devready(aml_chip, chipnr);
	return 0;
}

void aml_nand_read_set_flash_feature_toshiba(struct mtd_info *mtd, int chipnr)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	uint8_t reg10h[4] ={4,0,0,0};
	uint8_t reg80h[4] ={0,0,0,0};

	aml_nand_set_featureReg_value_toshiba(aml_chip,
		reg10h, NAND_CMD_SANDISK_SET_OUTPUT_DRV, chipnr, 4);

	aml_nand_set_featureReg_value_toshiba(aml_chip,
		reg80h, NAND_CMD_SANDISK_SET_VENDOR_SPC, chipnr, 4);
	printk("set flash toggle mode end\n");
}



void aml_nand_set_toggle_mode_toshiba(struct mtd_info *mtd, int chipnr)
{
	/*
	//switch SDR to Toggle mode
	//first send cmd to switch nand mode from SDR to toggle mode
	//struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);

	//aml_nand_read_set_flash_feature_toshiba(mtd,chipnr);

	//printk("##NAND CFG =0x%x before enable toggle mode \n",
		READ_CBUS_REG(NAND_CFG));
	//second set nand controller pinmux and enable toggle mode
	//NFC_SYNC_ADJ();
	//NFC_ENABLE_TOSHIBA_TOGGLE_MODE();
	//aml_chip->toggle_mode = 1;
	//printk("NAND CFG =0x%x after enable toggle mode \n",
		READ_CBUS_REG(NAND_CFG));
	*/

}

void aml_nand_debug_toggle_flash(struct mtd_info *mtd, int chipnr)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);

	if (aml_chip->mfr_type == NAND_MFR_TOSHIBA)
		aml_nand_set_toggle_mode_toshiba(mtd,0);
	 /*
	else  if(aml_chip->mfr_type == NAND_MFR_MICRON)
		aml_nand_set_toggle_mode_micron(mtd,0);
	*/

}
#endif


/* interface to get partition table from board configs */
extern struct mtd_partition *get_aml_mtd_partition(void);
extern int get_aml_partition_count(void);
static int aml_nand_add_partition(struct aml_nand_chip *aml_chip)
{
	struct mtd_info *mtd = &aml_chip->mtd;
	struct aml_nand_platform *plat = aml_chip->platform;
#ifdef CONFIG_MTD_PARTITIONS
	struct mtd_partition *temp_parts = NULL;
	struct mtd_partition *parts;
	int nr, i, ret = 0;
	loff_t adjust_offset = 0;
	uint64_t part_size = 0;
	int reserved_part_blk_num = RESERVED_BLOCK_NUM;
	uint64_t fip_part_size = 0;
	int normal_base = 0;
#ifndef CONFIG_NOT_SKIP_BAD_BLOCK
	int phys_erase_shift, error = 0;
	uint64_t start_blk = 0, part_blk = 0;
	loff_t offset;

	phys_erase_shift = fls(mtd->erasesize) - 1;
#endif

	if (!strncmp((char*)plat->name,
		NAND_BOOT_NAME, strlen((const char*)NAND_BOOT_NAME))) {\
		/* boot partition must be set as this because of romboot restrict */
		parts = kzalloc(sizeof(struct mtd_partition),
				GFP_KERNEL);
		if (!parts)
			return -ENOMEM;
		parts->name = NAND_BOOT_NAME;
		parts->offset = 0;
		parts->size = (mtd->writesize * 1024);
		nr = 1;
		nand_boot_flag = 1;
	} else {
		/* normal partitions */
		parts = get_aml_mtd_partition();
		nr = get_aml_partition_count();
		if (nand_boot_flag)
			adjust_offset =
				(1024 * mtd->writesize / aml_chip->plane_num);
	#ifdef CONFIG_DISCRETE_BOOTLOADER
		/* reserved area size is fixed 48 blocks and
		 * have fip between rsv and normal, so
		 * don't skip factory bad block and set fip part size.
		 */
		fip_part_size = CONFIG_TPL_SIZE_PER_COPY * CONFIG_TPL_COPY_NUM;
		/* TODO: add fip 2 partition list */
		temp_parts = parts;
		if (strcmp(CONFIG_TPL_PART_NAME, temp_parts->name)) {
			printf("nand: double check your mtd partition table!\n");
			printf("%s should be the 1st part!\n", CONFIG_TPL_PART_NAME);
			return -ENODEV;
		}
		if (temp_parts->size) {
			printf("nand: size of %s should not be pre-set\n",
				temp_parts->name);
			printf("it's should be determined by TPL_COPY_NUM*TPL_SIZE_PER_COPY\n");
			printf("which is %lld\n", fip_part_size);
		}
		temp_parts->offset = adjust_offset + reserved_part_blk_num * mtd->erasesize;
		temp_parts->size = fip_part_size;
		printf("%s: off %lld, size %lld\n", temp_parts->name,
			temp_parts->offset, temp_parts->size);
		normal_base = 1;
	#endif /* CONFIG_DISCRETE_BOOTLOADER */
		adjust_offset += reserved_part_blk_num * mtd->erasesize
			+ fip_part_size;
		for (i = normal_base; i < nr; i++) {
			temp_parts = parts + i;
			if (mtd->size < adjust_offset) {
				printf("%s %d error : over the nand size!!!\n",
				       __func__, __LINE__);
				return -ENOMEM;
			}
			temp_parts->offset = adjust_offset;
			part_size = temp_parts->size;
			if (i == nr - 1)
				part_size = mtd->size - adjust_offset;
	#ifndef CONFIG_NOT_SKIP_BAD_BLOCK
			offset = 0;
			start_blk = 0;
			part_blk = part_size >> phys_erase_shift;
			do {
				offset = adjust_offset + start_blk *
					mtd->erasesize;
				error = mtd->_block_isbad(mtd, offset);
				if (error) {
					pr_info("%s:%d factory bad addr=%llx\n",
						__func__, __LINE__,
					(uint64_t)(offset >>
						   phys_erase_shift));
					if (i != nr - 1) {
						adjust_offset += mtd->erasesize;
						continue;
					}
				}
				start_blk++;
			} while (start_blk < part_blk);
	#endif
			if (temp_parts->name == NULL) {
				temp_parts->name =
					kzalloc(MAX_MTD_PART_NAME_LEN,
						GFP_KERNEL);
				if (!temp_parts->name)
					return -ENOMEM;
				sprintf((char *)temp_parts->name,
					"mtd%d", nr);
			}
			adjust_offset += part_size;
			temp_parts->size = adjust_offset - temp_parts->offset;
		}
	}
	ret = add_mtd_partitions(mtd, parts, nr);
	if (nr == 1)
		kfree(parts);
	return ret;
#else
	return add_mtd_device(mtd);
#endif
}
#ifndef P_PAD_DS_REG0A
#define P_PAD_DS_REG0A (volatile uint32_t *)(0xff634400 + (0x0d0 << 2))
#endif
static void inline nand_get_chip(void )
{
	/* fixme, */
	/* pull up enable */
	cpu_id_t cpu_id = get_cpu_id();

	if ((cpu_id.family_id == MESON_CPU_MAJOR_ID_GXL)
		||(cpu_id.family_id == MESON_CPU_MAJOR_ID_GXBB)) {
		AMLNF_SET_REG_MASK(P_PAD_PULL_UP_EN_REG2, 0x87ff);
		/* pull direction, dqs pull down */
		AMLNF_SET_REG_MASK(P_PAD_PULL_UP_REG2, 0x8700);
	}
	/* switch pinmux */
	if (cpu_id.family_id == MESON_CPU_MAJOR_ID_GXL) {
		AMLNF_CLEAR_REG_MASK(P_PERIPHS_PIN_MUX_7,
			((0x7 << 28) | (0x1FF << 15) | (0xF << 10)));
		AMLNF_SET_REG_MASK(P_PERIPHS_PIN_MUX_7, ((0x1<<31) | 0xff));
	} else if (cpu_id.family_id == MESON_CPU_MAJOR_ID_GXBB) {
		/*AMLNF_SET_REG_MASK(P_PERIPHS_PIN_MUX_4,
			((0x1<<30) | (0x3fff<<20)));*/
		AMLNF_SET_REG_MASK(P_PERIPHS_PIN_MUX_4,
			((0x1<<30) | (0x3ff<<20)));
		AMLNF_CLEAR_REG_MASK(P_PERIPHS_PIN_MUX_0, (0x1 << 19));
		AMLNF_CLEAR_REG_MASK(P_PERIPHS_PIN_MUX_4, (0x3 << 18));
		AMLNF_CLEAR_REG_MASK(P_PERIPHS_PIN_MUX_5, (0xF));
	} else if (cpu_id.family_id == MESON_CPU_MAJOR_ID_AXG) {
		AMLNF_SET_REG_MASK(P_PAD_PULL_UP_EN_REG4, 0x61ff);
		AMLNF_SET_REG_MASK(P_PAD_PULL_UP_REG4, 0x6100);

		AMLNF_WRITE_REG(P_PERIPHS_PIN_MUX_0, 0x11111111);
		AMLNF_WRITE_REG(P_PERIPHS_PIN_MUX_1,
			(AMLNF_READ_REG(P_PERIPHS_PIN_MUX_1) & 0xfff000) | 0x22222);
	} else if (cpu_id.family_id == MESON_CPU_MAJOR_ID_TXHD) {
		AMLNF_SET_REG_MASK(P_PAD_PULL_UP_EN_REG2, 0x3f10ff);
		AMLNF_SET_REG_MASK(P_PAD_PULL_UP_REG2, 0x3f1000);
		AMLNF_WRITE_REG(P_PERIPHS_PIN_MUX_0, 0x11111111);
		AMLNF_WRITE_REG(P_PERIPHS_PIN_MUX_1,
				(AMLNF_READ_REG(P_PERIPHS_PIN_MUX_1) &
				0xfff00000) | 0x22222);
	} else if((cpu_id.family_id == MESON_CPU_MAJOR_ID_G12A)
		|| (cpu_id.family_id == MESON_CPU_MAJOR_ID_G12B)
		|| (cpu_id.family_id == MESON_CPU_MAJOR_ID_SM1)) {
		AMLNF_SET_REG_MASK(P_PAD_PULL_UP_EN_REG0, 0x1FFF);
		AMLNF_SET_REG_MASK(P_PAD_PULL_UP_REG0, 0x1F00);
		AMLNF_WRITE_REG(P_PERIPHS_PIN_MUX_0, 0x11111111);
		AMLNF_WRITE_REG(P_PERIPHS_PIN_MUX_1, 0x22122222);
		if (cpu_id.family_id == MESON_CPU_MAJOR_ID_G12A) {
			if (cpu_id.chip_rev == 0xA)
				writel(0x55555555, P_PAD_DS_REG0A);
			else if (cpu_id.chip_rev == 0xB)
				writel(0xFFFFFFFF, P_PAD_DS_REG0A);
		} else
			writel(0xFFFFFFFF, P_PAD_DS_REG0A);
	} else if (cpu_id.family_id == MESON_CPU_MAJOR_ID_TL1) {

		AMLNF_SET_REG_MASK(P_PAD_PULL_UP_EN_REG0, 0x1FFF);
		AMLNF_SET_REG_MASK(P_PAD_PULL_UP_REG0,
			((AMLNF_READ_REG(P_PAD_PULL_UP_REG0) & (~0x1FFF))
			| 0x1500));

		AMLNF_WRITE_REG(P_PERIPHS_PIN_MUX_0, 0x11111111);
		AMLNF_WRITE_REG(P_PERIPHS_PIN_MUX_1,
			((AMLNF_READ_REG(P_PERIPHS_PIN_MUX_1) & (~0xFFFFF)) | 0x22222));
		writel(0xFFFFFFFF, P_PAD_DS_REG0A);
	} else {
		printk("%s() %d: cpuid 0x%x not support yet!\n",
			__func__, __LINE__, cpu_id.family_id);
		BUG();
	}
	return ;
}

static void inline nand_release_chip(void)
{
	NFC_SEND_CMD_STANDBY(controller, 5);
	/* do not release cs0 & cs1 */
	//fixme, dbg code here.
	//AMLNF_CLEAR_REG_MASK(P_PERIPHS_PIN_MUX_2, ((0x33f<<20) | (0x1<< 30)));
	return;
}

static void aml_nand_select_chip(struct mtd_info *mtd, int chipnr)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);

	switch (chipnr) {
		case -1:
			nand_release_chip();
			break;
		case 0:
			nand_get_chip();
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

void aml_platform_cmd_ctrl(struct aml_nand_chip *aml_chip,
	int cmd, unsigned int ctrl)
{
	if (cmd == NAND_CMD_NONE)
		return;

	if (ctrl & NAND_CLE)
		cmd=NFC_CMD_CLE(controller->chip_selected, cmd);
	else
		cmd=NFC_CMD_ALE(controller->chip_selected, cmd);

	NFC_SEND_CMD(controller, cmd);
}

int aml_platform_wait_devready(struct aml_nand_chip *aml_chip, int chipnr)
{
	struct nand_chip *chip = &aml_chip->chip;
	struct mtd_info *mtd = &aml_chip->mtd;
	unsigned time_out_cnt = 0;
	int status;

	/* wait until command is processed or timeout occures */
	aml_chip->aml_nand_select_chip(aml_chip, chipnr);

	NFC_SEND_CMD_IDLE(controller, 0);
	NFC_SEND_CMD_IDLE(controller, 0);
	while (NFC_CMDFIFO_SIZE(controller) > 0);

	if (aml_chip->ops_mode & AML_CHIP_NONE_RB) {
		aml_chip->aml_nand_command(aml_chip,
			NAND_CMD_STATUS, -1, -1, chipnr);
		udelay(2);
		NFC_SEND_CMD(controller, controller->chip_selected | IDLE | 0);
		NFC_SEND_CMD(controller, controller->chip_selected | IDLE | 0);
		while (NFC_CMDFIFO_SIZE(controller) > 0) ;

		do {
			status = (int)chip->read_byte(mtd);
			if (status & NAND_STATUS_READY)
				break;
			udelay(1);
		} while(time_out_cnt++ <= 0x1000); /*10ms max*/

		if (time_out_cnt > 0x1000)
		    return 0;
	} else {
		do {
			if (chip->dev_ready(mtd))
				break;
		} while(time_out_cnt++ <= 0x40000);

		if (time_out_cnt > 0x40000)
		return 0;
	}
	return 1;
}

void aml_nand_cmd_ctrl(struct mtd_info *mtd, int cmd,  unsigned int ctrl)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);

	aml_chip->aml_nand_cmd_ctrl(aml_chip, cmd, ctrl);
}

int aml_nand_wait(struct mtd_info *mtd, struct nand_chip *chip)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	int status[MAX_CHIP_NUM], i = 0, time_cnt = 0;
	struct aml_nand_platform *plat = aml_chip->platform;
	int read_status =0;
	/* Apply this short delay always to ensure that we do wait tWB in
	 * any case on any machine. */
	ndelay(100);
	//SET_CBUS_REG_MASK(PREG_PAD_GPIO3_O, 1 << 11);
	for (i = 0; i < controller->chip_num; i++) {
		if (aml_chip->valid_chip[i]) {
			//active ce for operation chip and send cmd
			aml_chip->aml_nand_select_chip(aml_chip, i);

			NFC_SEND_CMD(controller,
				controller->chip_selected | IDLE | 0);
			NFC_SEND_CMD(controller,
				controller->chip_selected | IDLE | 0);
			while (NFC_CMDFIFO_SIZE(controller)>0) ;

			//if ((state == FL_ERASING)
			//	&& (chip->options & NAND_IS_AND))
			//	aml_chip->aml_nand_command(aml_chip,
			//		NAND_CMD_STATUS_MULTI, -1, -1, i);
			//else
			aml_chip->aml_nand_command(aml_chip,
				NAND_CMD_STATUS, -1, -1, i);

			NFC_SEND_CMD(controller,
				controller->chip_selected | IDLE | 0);
			NFC_SEND_CMD(controller,
				controller->chip_selected | IDLE | 0);
			while (NFC_CMDFIFO_SIZE(controller)>0) ;

			time_cnt = 0;
retry_status:
			while (time_cnt++ < 0x40000) {
				if (chip->dev_ready) {
					if (chip->dev_ready(mtd))
						break;
					udelay(2);
				} else {
					//if(time_cnt == 1)
				udelay(2);
				if (chip->read_byte(mtd) & NAND_STATUS_READY)
					break;
					//aml_chip->aml_nand_command(aml_chip,
					//	NAND_CMD_STATUS, -1, -1, i);
					//udelay(50);

				}
				//udelay(200);
			}
				status[i] = (int)chip->read_byte(mtd);
			//printk("s:%x\n", status[i]);
			if ((read_status++ < 3) && (!(status[i] & NAND_STATUS_READY))) {
				printk("after wirte,read %d status =%d fail\n",
					read_status,status[i]);
				goto retry_status;
			}
			status[0] |= status[i];
		}
	}
	if (!strncmp((char*)plat->name,
		NAND_BOOT_NAME, strlen((const char*)NAND_BOOT_NAME)))
		status[0] = 0xe0;

	return status[0];
}

/*
 * CONFIG_SYS_NAND_RESET_CNT is used as a timeout mechanism when resetting
 * a flash.  NAND flash is initialized prior to interrupts so standard timers
 * can't be used.  CONFIG_SYS_NAND_RESET_CNT should be set to a value
 * which is greater than (max NAND reset time / NAND status read time).
 * A conservative default of 200000 (500 us / 25 ns) is used as a default.
 */
#ifndef CONFIG_SYS_NAND_RESET_CNT
#define CONFIG_SYS_NAND_RESET_CNT 200000
#endif
void aml_nand_base_command(struct aml_nand_chip *aml_chip,
	unsigned command, int column, int page_addr, int chipnr)
{
	struct nand_chip *chip = &aml_chip->chip;
	struct mtd_info *mtd = &aml_chip->mtd;
	unsigned command_temp;
	unsigned pages_per_blk_shift, plane_page_addr = 0, plane_blk_addr = 0;

	pages_per_blk_shift = (chip->phys_erase_shift - chip->page_shift);
	uint32_t rst_sts_cnt = CONFIG_SYS_NAND_RESET_CNT;
	if (page_addr != -1) {
		page_addr /= aml_chip->plane_num;
		plane_page_addr =(page_addr & ((1 << pages_per_blk_shift) - 1));
		plane_blk_addr = (page_addr >> pages_per_blk_shift);
		plane_blk_addr = (plane_blk_addr << 1);
	}

	if (aml_chip->plane_num == 2) {
		switch (command) {
			case NAND_CMD_READ0:
				if ((aml_chip->mfr_type == NAND_MFR_MICRON)
				|| (aml_chip->mfr_type == NAND_MFR_INTEL))
					command_temp = command;
				else {
					command_temp =
					NAND_CMD_TWOPLANE_PREVIOS_READ;
					column = -1;
				}
				plane_page_addr |=
				(plane_blk_addr << pages_per_blk_shift);
				break;

			case NAND_CMD_TWOPLANE_READ1:
				command_temp = NAND_CMD_READ0;
				if ((aml_chip->mfr_type == NAND_MFR_MICRON)
				|| (aml_chip->mfr_type == NAND_MFR_INTEL))
					/*plane_page_addr |=
						((plane_blk_addr + 1) << 8);*/
					return;
				else
					plane_page_addr |=
					(plane_blk_addr << pages_per_blk_shift);
				break;

			case NAND_CMD_TWOPLANE_READ2:
				if ((aml_chip->mfr_type == NAND_MFR_MICRON)
				|| (aml_chip->mfr_type == NAND_MFR_INTEL))
					command_temp =
						NAND_CMD_PLANE2_READ_START;
				else
					command_temp = NAND_CMD_READ0;
				plane_page_addr |=
				((plane_blk_addr + 1) << pages_per_blk_shift);
				break;

			case NAND_CMD_SEQIN:
				command_temp = command;
				plane_page_addr |=
				(plane_blk_addr << pages_per_blk_shift);
				break;

			case NAND_CMD_TWOPLANE_WRITE2:
				if ((aml_chip->mfr_type == NAND_MFR_HYNIX)
				|| (aml_chip->mfr_type == NAND_MFR_SAMSUNG))
					command_temp = command;
				else
					command_temp =
						NAND_CMD_TWOPLANE_WRITE2_MICRO;
				plane_page_addr |=
				((plane_blk_addr + 1) << pages_per_blk_shift);
				break;

			case NAND_CMD_ERASE1:
				command_temp = command;
				plane_page_addr |=
				(plane_blk_addr << pages_per_blk_shift);
				break;

			case NAND_CMD_MULTI_CHIP_STATUS:
				command_temp = command;
				plane_page_addr |=
				(plane_blk_addr << pages_per_blk_shift);
				break;

			default:
				command_temp = command;
				break;

		}
		chip->cmd_ctrl(mtd,
			command_temp & 0xff,
			NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);

		/*
		if ((command_temp == NAND_CMD_SEQIN)
		|| (command_temp == NAND_CMD_TWOPLANE_WRITE2)
		|| (command_temp == NAND_CMD_READ0))
			printk("plane_page_addr:%x plane_blk_addr:%x cmd:%x\n",
				plane_page_addr, plane_blk_addr, command);
		*/

		if (column != -1 || page_addr != -1) {
			int ctrl = NAND_CTRL_CHANGE | NAND_NCE | NAND_ALE;
			/* Serially input address */
			if (column != -1) {
				/* Adjust columns for 16 bit buswidth */
				if (chip->options & NAND_BUSWIDTH_16 &&
				    !nand_opcode_8bits(command))
					column >>= 1;
				chip->cmd_ctrl(mtd, column, ctrl);
				ctrl &= ~NAND_CTRL_CHANGE;
				if (!nand_opcode_8bits(command))
					chip->cmd_ctrl(mtd, column >> 8, ctrl);
			}
			if (page_addr != -1) {
				chip->cmd_ctrl(mtd, plane_page_addr, ctrl);
				chip->cmd_ctrl(mtd,
				plane_page_addr >> 8, NAND_NCE | NAND_ALE);
				/* One more address cycle for devices > 128MiB*/
				if (chip->chipsize > (128 << 20))
					chip->cmd_ctrl(mtd,
				plane_page_addr >> 16, NAND_NCE | NAND_ALE);
			}
		}

		switch (command) {
			case NAND_CMD_READ0:
				plane_page_addr =
					page_addr % (1 << pages_per_blk_shift);

				if ((aml_chip->mfr_type == NAND_MFR_MICRON)
				|| (aml_chip->mfr_type == NAND_MFR_INTEL)) {
					plane_page_addr |=
				((plane_blk_addr + 1) << pages_per_blk_shift);
					command_temp = command;
					chip->cmd_ctrl(mtd,
					command_temp & 0xff,
					NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);
				} else {
					command_temp =
					NAND_CMD_TWOPLANE_PREVIOS_READ;
					column = -1;
					plane_page_addr |=
				((plane_blk_addr + 1) << pages_per_blk_shift);
					chip->cmd_ctrl(mtd,
					command_temp & 0xff,
					NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);
				}

				break;

			case NAND_CMD_TWOPLANE_READ1:
				if ((aml_chip->mfr_type == NAND_MFR_MICRON)
				|| (aml_chip->mfr_type == NAND_MFR_INTEL)) {
					page_addr = -1;
					column = -1;
				} else {
					command_temp = NAND_CMD_RNDOUT;
					page_addr = -1;
					chip->cmd_ctrl(mtd,
					command_temp & 0xff,
					NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);
				}
				break;

			case NAND_CMD_TWOPLANE_READ2:
				if ((aml_chip->mfr_type == NAND_MFR_MICRON)
				|| (aml_chip->mfr_type == NAND_MFR_INTEL)) {
					page_addr = -1;
					column = -1;
				} else {
					command_temp = NAND_CMD_RNDOUT;
					page_addr = -1;
					chip->cmd_ctrl(mtd,
					command_temp & 0xff,
					NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);
				}
				break;

			case NAND_CMD_ERASE1:
				if ((aml_chip->mfr_type == NAND_MFR_MICRON)
				|| (aml_chip->mfr_type == NAND_MFR_INTEL)) {
					command_temp = NAND_CMD_ERASE1_END;
					chip->cmd_ctrl(mtd,
					command_temp & 0xff,
					NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);
				aml_chip->aml_nand_wait_devready(aml_chip,
					chipnr);
				}

				command_temp = command;
				chip->cmd_ctrl(mtd,
					command_temp & 0xff,
					NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);
				plane_page_addr =
					page_addr % (1 << pages_per_blk_shift);
				plane_page_addr |=
				((plane_blk_addr + 1) << pages_per_blk_shift);
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
				if (chip->options & NAND_BUSWIDTH_16 &&
				    !nand_opcode_8bits(command))
					column >>= 1;
				chip->cmd_ctrl(mtd, column, ctrl);
				ctrl &= ~NAND_CTRL_CHANGE;
				if (!nand_opcode_8bits(command))
					chip->cmd_ctrl(mtd, column >> 8, ctrl);
			}
			if (page_addr != -1) {
				//plane_page_addr |=
				//	(1 << (pages_per_blk_shift + 1));
				//BUG_ON((plane_page_addr & 0x7FF) == 0);

				chip->cmd_ctrl(mtd, plane_page_addr, ctrl);
				chip->cmd_ctrl(mtd, plane_page_addr >> 8,
					NAND_NCE | NAND_ALE);
				/* One more address cycle for devices > 128MiB*/
				if (chip->chipsize > (128 << 20))
					chip->cmd_ctrl(mtd,
				plane_page_addr >> 16, NAND_NCE | NAND_ALE);
			}
		}

		if ((command == NAND_CMD_RNDOUT)
		|| (command == NAND_CMD_TWOPLANE_READ2))
			chip->cmd_ctrl(mtd,
				NAND_CMD_RNDOUTSTART,
				NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);
		else if ((command == NAND_CMD_TWOPLANE_READ1))
			chip->cmd_ctrl(mtd,
				NAND_CMD_RNDOUTSTART,
				NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);

		else if (command == NAND_CMD_READ0)
			chip->cmd_ctrl(mtd,
				NAND_CMD_READSTART,
				NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);

		chip->cmd_ctrl(mtd, NAND_CMD_NONE, NAND_NCE | NAND_CTRL_CHANGE);
	} else {
#ifdef NEW_NAND_SUPPORT
		if (( aml_chip->new_nand_info.dynamic_read_info.slc_flag == 1 )
		&&( aml_chip->new_nand_info.type == SANDISK_19NM )
		&&( (command == NAND_CMD_ERASE1)
		|| (command == NAND_CMD_READ0)
		|| (command == NAND_CMD_SEQIN) )) {
			chip->cmd_ctrl(mtd,
				NAND_CMD_SANDISK_SLC & 0xff,
				NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);
			udelay(2);
		}
#endif
		chip->cmd_ctrl(mtd,
			command & 0xff,
			NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);

		if (column != -1 || page_addr != -1) {
			int ctrl = NAND_CTRL_CHANGE | NAND_NCE | NAND_ALE;

			/* Serially input address */
			if (column != -1) {
				/* Adjust columns for 16 bit buswidth */
				if (chip->options & NAND_BUSWIDTH_16 &&
				    !nand_opcode_8bits(command))
					column >>= 1;
				chip->cmd_ctrl(mtd, column, ctrl);
				ctrl &= ~NAND_CTRL_CHANGE;
				/* Only output a single addr
				 * cycle for 8bits opcodes.
				 */
				if (!nand_opcode_8bits(command))
					chip->cmd_ctrl(mtd, column >> 8, ctrl);
			}
			if (page_addr != -1) {

				chip->cmd_ctrl(mtd, page_addr, ctrl);
				chip->cmd_ctrl(mtd, page_addr >> 8,
					NAND_NCE | NAND_ALE);
				/* One more address cycle for devices > 128MiB*/
				if (chip->chipsize > (128 << 20))
					chip->cmd_ctrl(mtd,
					page_addr >> 16, NAND_NCE | NAND_ALE);
			}
		}
		if (command == NAND_CMD_RNDOUT)
			chip->cmd_ctrl(mtd,
				NAND_CMD_RNDOUTSTART,
				NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);
		else if (command == NAND_CMD_READ0)
			chip->cmd_ctrl(mtd,
				NAND_CMD_READSTART,
				NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);

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
			printk ("couldn`t found selected chip: %d ready\n",
				chipnr);
		chip->cmd_ctrl(mtd,
			NAND_CMD_STATUS,
			NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);
		chip->cmd_ctrl(mtd,
			NAND_CMD_NONE, NAND_NCE | NAND_CTRL_CHANGE);
		while (!(chip->read_byte(mtd) & NAND_STATUS_READY) &&
			(rst_sts_cnt--));
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

void aml_nand_command(struct mtd_info *mtd,
	unsigned command, int column, int page_addr)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	struct nand_chip *chip = &aml_chip->chip;
	int i = 0, valid_page_num = 1;//, internal_chip;

	if (page_addr != -1) {
		valid_page_num = (mtd->writesize >> chip->page_shift);
		valid_page_num /= aml_chip->plane_num;
		aml_chip->page_addr = page_addr / valid_page_num;
	if (unlikely(aml_chip->page_addr >= aml_chip->internal_page_nums)) {
		//internal_chip =
		//aml_chip->page_addr / aml_chip->internal_page_nums;
		aml_chip->page_addr -= aml_chip->internal_page_nums;
		aml_chip->page_addr |=
		(1 << aml_chip->internal_chip_shift)*aml_chip->internal_chipnr;
	}
	} else
		aml_chip->page_addr = page_addr;

	/* Emulate NAND_CMD_READOOB */
	if (command == NAND_CMD_READOOB) {
		command = NAND_CMD_READ0;
		aml_chip->aml_nand_wait_devready(aml_chip, 0);
		aml_chip->aml_nand_command(aml_chip, command,
			column, aml_chip->page_addr, 0);
		return;
	}
	if (command == NAND_CMD_PAGEPROG)
		return;

	/*if (command == NAND_CMD_SEQIN) {
		aml_chip->aml_nand_select_chip(aml_chip, 0);
		aml_chip->aml_nand_command(aml_chip,
			command, column, page_addr, 0);
		return;
	}*/

	for (i=0; i<controller->chip_num; i++) {
		if (aml_chip->valid_chip[i]) {
			//active ce for operation chip and send cmd
			aml_chip->aml_nand_wait_devready(aml_chip, i);
			aml_chip->aml_nand_command(aml_chip,
				command, column, aml_chip->page_addr, i);
		}
	}

	return;
}


void aml_nand_erase_cmd(struct mtd_info *mtd, int page)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	struct nand_chip *chip = mtd->priv;
	unsigned pages_per_blk_shift;
	unsigned vt_page_num, internal_chipnr = 1, page_addr, valid_page_num;
	unsigned i = 0, j = 0;
	unsigned block_addr;

	pages_per_blk_shift = (chip->phys_erase_shift - chip->page_shift);

	vt_page_num = (mtd->writesize / (1 << chip->page_shift));
	vt_page_num *= (1 << pages_per_blk_shift);
	// printk("%s() page 0x%x\n", __func__, page);
	if (page % vt_page_num)
		return;
	/* fixme, skip bootloader */
	if (page < 1024)
		return;
	/* Send commands to erase a block */
	valid_page_num = (mtd->writesize >> chip->page_shift);

	block_addr = ((page / valid_page_num) >> pages_per_blk_shift);

	if (aml_nand_rsv_erase_protect(mtd, block_addr) == -1) {
		printf("%s blk 0x%x is protected\n", __func__, block_addr);
		return;
	}

	/*
	if ((aml_chip->aml_nandenv_info->valid_node->status)
	&& (block_addr == aml_chip->aml_nandenv_info->valid_node->phy_blk_addr))
		aml_nand_free_valid_env(mtd);
	*/

	valid_page_num /= aml_chip->plane_num;

	aml_chip->page_addr = page / valid_page_num;
	if (unlikely(aml_chip->page_addr >= aml_chip->internal_page_nums)) {
		//internal_chipnr =
		//	aml_chip->page_addr / aml_chip->internal_page_nums;
		aml_chip->page_addr -= aml_chip->internal_page_nums;
		aml_chip->page_addr |=
		(1 << aml_chip->internal_chip_shift) *aml_chip->internal_chipnr;
	}

	if (unlikely(aml_chip->ops_mode & AML_INTERLEAVING_MODE))
		internal_chipnr = aml_chip->internal_chipnr;
	else
		internal_chipnr = 1;

	for (i=0; i<controller->chip_num; i++) {
		if (aml_chip->valid_chip[i]) {
			aml_chip->aml_nand_select_chip(aml_chip, i);
			page_addr = aml_chip->page_addr;
			for (j=0; j<internal_chipnr; j++) {
				if (j > 0) {
					page_addr = aml_chip->page_addr;
					page_addr |=
					(1 << aml_chip->internal_chip_shift) *j;
				}
				aml_chip->aml_nand_command(aml_chip,
					NAND_CMD_ERASE1, -1, page_addr, i);
				aml_chip->aml_nand_command(aml_chip,
					NAND_CMD_ERASE2, -1, -1, i);
			}
		}
	}
	return ;
}

void aml_nand_dma_read_buf(struct mtd_info *mtd, uint8_t *buf, int len)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);

	aml_chip->aml_nand_dma_read(aml_chip, buf, len, 0);
}

void aml_nand_dma_write_buf(struct mtd_info *mtd, const uint8_t *buf, int len)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);

	aml_chip->aml_nand_dma_write(aml_chip, (unsigned char *)buf, len, 0);
}

int aml_nand_read_page_raw(struct mtd_info *mtd, struct nand_chip *chip,
	uint8_t *buf, int oob_required, int page)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	unsigned nand_page_size = aml_chip->page_size;
	unsigned nand_oob_size = aml_chip->oob_size;
	uint8_t *oob_buf = chip->oob_poi;
	int i, error = 0, j = 0, page_addr, internal_chipnr = 1;

	if (aml_chip->ops_mode & AML_INTERLEAVING_MODE)
		internal_chipnr = aml_chip->internal_chipnr;

	for (i = 0; i < controller->chip_num; i++) {
		if (aml_chip->valid_chip[i]) {
			page_addr = aml_chip->page_addr;
			for (j = 0; j < internal_chipnr; j++) {
				if (j > 0) {
					page_addr = aml_chip->page_addr;
					page_addr |=
				(1 << aml_chip->internal_chip_shift) * j;
					aml_chip->aml_nand_select_chip(aml_chip,
						i);
					aml_chip->aml_nand_command(aml_chip,
						NAND_CMD_READ0, 0, page_addr,i);
				}

				if (!aml_chip->aml_nand_wait_devready(aml_chip,
					i)) {
				printk ("didn't found selected chip:%dready\n",
					i);
					error = -EBUSY;
					goto exit;
				}

				if (aml_chip->ops_mode & AML_CHIP_NONE_RB)
					chip->cmd_ctrl(mtd,
					NAND_CMD_READ0 & 0xff,
					NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);
				if (aml_chip->plane_num == 2) {
					aml_chip->aml_nand_command(aml_chip,
						NAND_CMD_TWOPLANE_READ1,
						0x00, page_addr, i);
					chip->read_buf(mtd,
						aml_chip->aml_nand_data_buf,
						(nand_page_size+nand_oob_size));
					memcpy(buf, aml_chip->aml_nand_data_buf,
						(nand_page_size+nand_oob_size));
					memcpy(oob_buf,
				aml_chip->aml_nand_data_buf + nand_page_size,
					nand_oob_size);

					oob_buf += nand_oob_size;
					buf += (nand_page_size + nand_oob_size);

					aml_chip->aml_nand_command(aml_chip,
						NAND_CMD_TWOPLANE_READ2,
						0x00, page_addr, i);
					chip->read_buf(mtd,
						aml_chip->aml_nand_data_buf,
						nand_page_size + nand_oob_size);
					memcpy(buf, aml_chip->aml_nand_data_buf,
						nand_page_size + nand_oob_size);
					memcpy(oob_buf,
				aml_chip->aml_nand_data_buf + nand_page_size,
						nand_oob_size);

					oob_buf += nand_oob_size;
					buf += (nand_page_size + nand_oob_size);
				} else if (aml_chip->plane_num == 1) {
					chip->read_buf(mtd,
						aml_chip->aml_nand_data_buf,
						nand_page_size + nand_oob_size);
					memcpy(buf, aml_chip->aml_nand_data_buf,
						nand_page_size);
					memcpy(oob_buf,
				aml_chip->aml_nand_data_buf + nand_page_size,
						nand_oob_size);
					oob_buf += nand_oob_size;
					buf += nand_page_size;
				} else {
					error = -ENODEV;
					goto exit;
				}
			}
		}
	}

exit:
	return error;
}

int aml_nand_write_page_raw(struct mtd_info *mtd,
	struct nand_chip *chip, const uint8_t *buf, int oob_required)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	unsigned nand_page_size = aml_chip->page_size;
	unsigned nand_oob_size = aml_chip->oob_size;
	uint8_t *oob_buf = chip->oob_poi;
	int i, error = 0, j = 0, page_addr, internal_chipnr = 1;

	if (aml_chip->ops_mode & AML_INTERLEAVING_MODE)
		internal_chipnr = aml_chip->internal_chipnr;

	for (i=0; i<controller->chip_num; i++) {
	if (aml_chip->valid_chip[i]) {
		aml_chip->aml_nand_select_chip(aml_chip, i);
		page_addr = aml_chip->page_addr;
		for (j = 0; j < internal_chipnr; j++) {
			if (j > 0) {
				page_addr = aml_chip->page_addr;
				page_addr |=
				(1 << aml_chip->internal_chip_shift) *j;
				aml_chip->aml_nand_command(aml_chip,
				NAND_CMD_SEQIN, 0, page_addr, i);
			}

			if (aml_chip->plane_num == 2) {
				memcpy(aml_chip->aml_nand_data_buf,
					buf, nand_page_size);
		memcpy(aml_chip->aml_nand_data_buf + nand_page_size,
			oob_buf, nand_oob_size);
				chip->write_buf(mtd,
					aml_chip->aml_nand_data_buf,
					nand_page_size + nand_oob_size);
				aml_chip->aml_nand_command(aml_chip,
				NAND_CMD_DUMMY_PROGRAM, -1, -1, i);

				oob_buf += nand_oob_size;
				buf += nand_page_size;

		if (!aml_chip->aml_nand_wait_devready(aml_chip, i)) {
			printk ("didn't found selected chip:%d ready\n",
				i);
			error = -EBUSY;
			goto exit;
		}

		memcpy(aml_chip->aml_nand_data_buf,
			buf, nand_page_size);
		memcpy(aml_chip->aml_nand_data_buf + nand_page_size,
			oob_buf, nand_oob_size);
		aml_chip->aml_nand_command(aml_chip,
			NAND_CMD_TWOPLANE_WRITE2, 0x00, page_addr, i);
		chip->write_buf(mtd, aml_chip->aml_nand_data_buf,
			(nand_page_size + nand_oob_size));
		aml_chip->aml_nand_command(aml_chip,
			NAND_CMD_PAGEPROG, -1, -1, i);

				oob_buf += nand_oob_size;
				buf += nand_page_size;
			} else if (aml_chip->plane_num == 1) {
				memcpy(aml_chip->aml_nand_data_buf,
					buf, nand_page_size);
		memcpy(aml_chip->aml_nand_data_buf + nand_page_size,
			oob_buf, nand_oob_size);
				chip->write_buf(mtd,
					aml_chip->aml_nand_data_buf,
					nand_page_size + nand_oob_size);
			if (chip->cmdfunc == aml_nand_command)
				aml_chip->aml_nand_command(aml_chip,
					NAND_CMD_PAGEPROG,
					-1, -1, i);

				oob_buf += nand_oob_size;
				buf += nand_page_size;
			} else {
				error = -ENODEV;
				goto exit;
			}
		}
	}
	}
exit:
	return error;
}

int aml_nand_read_page_hwecc(struct mtd_info *mtd,
	struct nand_chip *chip, uint8_t *buf, int oob_required, int page)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	uint8_t *oob_buf = chip->oob_poi;
	unsigned nand_page_size = (1 << chip->page_shift);
	unsigned pages_per_blk_shift;
	int user_byte_num;
	int error = 0, i = 0, stat = 0, j = 0, page_addr, internal_chipnr = 1;
	int ran_mode = aml_chip->ran_mode;

	pages_per_blk_shift = (chip->phys_erase_shift - chip->page_shift);
	user_byte_num = (((nand_page_size + chip->ecc.size - 1) /chip->ecc.size)
		* aml_chip->user_byte_mode);

#ifdef NEW_NAND_SUPPORT
	int page_temp, pages_per_blk;

	readretry_failed_cnt = 0
	pages_per_blk =
		(1 << (chip->phys_erase_shift - chip->page_shift));
	int retry_cnt =aml_chip->new_nand_info.read_rety_info.retry_cnt;
	if ((aml_chip->new_nand_info.type == HYNIX_20NM_8GB)
	|| (aml_chip->new_nand_info.type == HYNIX_20NM_4GB)
	|| (aml_chip->new_nand_info.type == HYNIX_1YNM_8GB))
		retry_cnt = aml_chip->new_nand_info.read_rety_info.retry_cnt
			* aml_chip->new_nand_info.read_rety_info.retry_cnt;
#endif
	if (aml_chip->ops_mode & AML_INTERLEAVING_MODE)
		internal_chipnr = aml_chip->internal_chipnr;

	if (nand_page_size > chip->ecc.steps * chip->ecc.size) {
		nand_page_size = chip->ecc.steps * chip->ecc.size;
		user_byte_num = chip->ecc.steps;
	}

	for (i = 0; i < controller->chip_num; i++) {
	if (aml_chip->valid_chip[i]) {
#ifdef NEW_NAND_SUPPORT
		readretry_failed_cnt = 0;
read_retry:
#endif
		page_addr = aml_chip->page_addr;
		for (j = 0; j < internal_chipnr; j++) {
		if (j > 0) {
			page_addr = aml_chip->page_addr;
			page_addr |= (1 << aml_chip->internal_chip_shift) * j;
			aml_chip->aml_nand_select_chip(aml_chip, i);
			aml_chip->aml_nand_command(aml_chip, NAND_CMD_READ0,
				0, page_addr, i);
		}
		if (!aml_chip->aml_nand_wait_devready(aml_chip, i)) {
			printk ("read couldn`t found selected chip: %d ready\n",
				i);
			error = -EBUSY;
			goto exit;
		}
		if (aml_chip->ops_mode & AML_CHIP_NONE_RB)
			chip->cmd_ctrl(mtd, NAND_CMD_READ0 & 0xff,
				NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);
		if (aml_chip->plane_num == 2) {
			aml_chip->aml_nand_command(aml_chip,
				NAND_CMD_TWOPLANE_READ1, 0x00, page_addr, i);
dma_retry_plane0:
			error = aml_chip->aml_nand_dma_read(aml_chip,
				buf, nand_page_size, aml_chip->bch_mode);
			if (error)
				goto exit;

			aml_chip->aml_nand_get_user_byte(aml_chip,
				oob_buf, user_byte_num);
			stat = aml_chip->aml_nand_hwecc_correct(aml_chip,
				buf, nand_page_size, oob_buf);
			if (stat < 0) {
				if (aml_chip->ran_mode
				&& (aml_chip->zero_cnt <  aml_chip->ecc_max)) {
					memset(buf, 0xff, nand_page_size);
					memset(oob_buf, 0xff, user_byte_num);
					goto plane0_ff;
				}

				if (ran_mode && aml_chip->ran_mode) {
					aml_chip->ran_mode = 0;
					ndelay(300);
					aml_chip->aml_nand_command(aml_chip,
						NAND_CMD_RNDOUT, 0, -1, i);
					ndelay(500);
					goto dma_retry_plane0;
				 }
				memset(buf, 0xff, nand_page_size);
				memset(oob_buf, 0xff, user_byte_num);

				mtd->ecc_stats.failed++;
				printk("read ecc pl0 failed at page%d chip%d\n",
					page_addr, i);
			} else {
			if (aml_chip->ecc_cnt_cur > aml_chip->ecc_cnt_limit) {
	printk("%s %d uncorrect ecc_cnt_cur:%d limit:%d pg:%d,blk:%d chip%d\n",
				__func__, __LINE__,
				aml_chip->ecc_cnt_cur, aml_chip->ecc_cnt_limit,
				page_addr, page_addr >> pages_per_blk_shift, i);
				mtd->ecc_stats.corrected++;
			}
				mtd->ecc_stats.corrected += stat;
			}
plane0_ff:
			aml_chip->ran_mode = ran_mode;
			oob_buf += user_byte_num;
			buf += nand_page_size;

			aml_chip->aml_nand_command(aml_chip,
				NAND_CMD_TWOPLANE_READ2, 0x00, page_addr, i);
dma_retry_plane1:
			error = aml_chip->aml_nand_dma_read(aml_chip,
				buf, nand_page_size, aml_chip->bch_mode);
			if (error)
				goto exit;

			aml_chip->aml_nand_get_user_byte(aml_chip,
					oob_buf, user_byte_num);
			stat = aml_chip->aml_nand_hwecc_correct(aml_chip,
					buf, nand_page_size, oob_buf);
			if (stat < 0) {
				if(aml_chip->ran_mode
				&& (aml_chip->zero_cnt <  aml_chip->ecc_max)) {
					memset(buf, 0xff, nand_page_size);
					memset(oob_buf, 0xff, user_byte_num);
					oob_buf += user_byte_num;
					buf += nand_page_size;
					continue;
				}

				if (ran_mode && aml_chip->ran_mode) {
					aml_chip->ran_mode = 0;
					ndelay(300);
					aml_chip->aml_nand_command(aml_chip,
						NAND_CMD_RNDOUT, 0, -1, i);
					ndelay(500);
					goto dma_retry_plane1;
				 }
				memset(buf, 0xff, nand_page_size);
				memset(oob_buf, 0xff, user_byte_num);

				mtd->ecc_stats.failed++;
				printk("read ecc pl1 failed at page%d chip%d\n",
					page_addr, i);
			} else {
			if (aml_chip->ecc_cnt_cur > aml_chip->ecc_cnt_limit) {
	printk("%s %d uncorrect ecc_cnt_cur:%d limit:%d pg:%d blk:%d chip%d\n",
				__func__, __LINE__,
				aml_chip->ecc_cnt_cur, aml_chip->ecc_cnt_limit,
				page_addr, page_addr >> pages_per_blk_shift, i);
				mtd->ecc_stats.corrected++;
			}
				mtd->ecc_stats.corrected += stat;
			}
			aml_chip->ran_mode = ran_mode;
			oob_buf += user_byte_num;
			buf += nand_page_size;

		} else if (aml_chip->plane_num == 1) {
			error = aml_chip->aml_nand_dma_read(aml_chip,
				buf, nand_page_size, aml_chip->bch_mode);
			if (error)
				goto exit;

			aml_chip->aml_nand_get_user_byte(aml_chip,
				oob_buf, user_byte_num);
			stat = aml_chip->aml_nand_hwecc_correct(aml_chip,
				buf, nand_page_size, oob_buf);
			if (stat < 0) {
				if(aml_chip->ran_mode
				&& (aml_chip->zero_cnt <  aml_chip->ecc_max)) {
					memset(buf, 0xff, nand_page_size);
					memset(oob_buf, 0xff, user_byte_num);
					oob_buf += user_byte_num;
					buf += nand_page_size;
					continue;
				}
#ifdef NEW_NAND_SUPPORT
if (aml_chip->new_nand_info.type == SANDISK_19NM) {
	page_temp =
	page_addr - pages_per_blk * (page_addr >> pages_per_blk_shift);
	if (((page_temp % 2 == 0) && (page_temp !=0))
		||(page_temp == (pages_per_blk -1))) {
		if (readretry_failed_cnt++ < DYNAMIC_CNT_UPPER) {
	aml_nand_debug("read ecc failed page:%d blk %d chip%d, retry_cnt:%d\n",
		page_addr, (page_addr >> pages_per_blk_shift),
		i, readretry_failed_cnt);
	aml_chip->new_nand_info.dynamic_read_info.dynamic_read_handle(mtd,
		page_temp, i);
	aml_chip->aml_nand_command(aml_chip, NAND_CMD_READ0, 0, page_addr, i);
	goto read_retry;
		}
	} else {
		if (readretry_failed_cnt++ < DYNAMIC_CNT_LOWER) {
	aml_nand_debug("read ecc failed page:%d blk %d chip%d,retry_cnt:%d\n",
		page_addr, (page_addr >> pages_per_blk_shift),
		i, readretry_failed_cnt);
	aml_chip->new_nand_info.dynamic_read_info.dynamic_read_handle(mtd,
		page_temp, i);
	aml_chip->aml_nand_command(aml_chip, NAND_CMD_READ0, 0, page_addr, i);
	goto read_retry;
		}
	}
} else if(aml_chip->new_nand_info.type) {
	if (readretry_failed_cnt++ < retry_cnt) {
	aml_nand_debug("read ecc failed page:%d blk %d chip%d, retry_cnt:%d\n",
		page_addr, (page_addr >> pages_per_blk_shift),
		i, readretry_failed_cnt);
		aml_chip->new_nand_info.read_rety_info.read_retry_handle(mtd,
			i);
		aml_chip->aml_nand_command(aml_chip,
			NAND_CMD_READ0, 0, page_addr, i);
		goto read_retry;
	}
}
#endif
				//memset(buf, 0xff, nand_page_size);
				memset(oob_buf, 0x22, user_byte_num);
	printk("%s %d read ecc failed here at at page:%d, blk:%d chip[%d]\n",
		__func__, __LINE__, page_addr,
		(page_addr >> pages_per_blk_shift), i);
				mtd->ecc_stats.failed++;
#ifdef NEW_NAND_SUPPORT
				if ((aml_chip->new_nand_info.type)
				&& (aml_chip->new_nand_info.type < 10)) {
					aml_chip->aml_nand_command(aml_chip,
						NAND_CMD_RESET, -1, -1, i);
			if (!aml_chip->aml_nand_wait_devready(aml_chip, i)) {
				printk ("didn't found selected chip%d ready\n",
					i);
				error = -EBUSY;
				goto exit;
			}
				}
#endif
			} else {
				aml_chip->ran_mode = ran_mode;
#ifdef NEW_NAND_SUPPORT
				if (aml_chip->new_nand_info.type == SANDISK_19NM) {
page_temp = page_addr - pages_per_blk * (page_addr >> pages_per_blk_shift);
if (((page_temp % 2 == 0) && (page_temp !=0))
||(page_temp == (pages_per_blk -1))) {
	if (readretry_failed_cnt > DYNAMIC_CNT_UPPER -2) {
		printk("%s %d uncorrected ecc_cnt_cur:%d limit:%d page:%d"
			"blk:%d chip%d retry_cnt:%d\n",
			__func__, __LINE__,
			aml_chip->ecc_cnt_cur, aml_chip->ecc_cnt_limit,
			page_addr, (page_addr >> pages_per_blk_shift),
			i, readretry_failed_cnt);
		mtd->ecc_stats.corrected++;
	}
} else {
	if (readretry_failed_cnt > DYNAMIC_CNT_LOWER -2) {
		printk("%s %d uncorrected ecc_cnt_cur:%d limit:%d page:%d"
			"blk:%d chip%d, retry_cnt:%d\n",
			__func__, __LINE__,
			aml_chip->ecc_cnt_cur, aml_chip->ecc_cnt_limit,
			page_addr, (page_addr >> pages_per_blk_shift),
			i, readretry_failed_cnt);
			mtd->ecc_stats.corrected++;
	}
}
				} else if(aml_chip->new_nand_info.type) {
					if (readretry_failed_cnt>(retry_cnt-2)) {
		printk("%s %d uncorrected ecc_cnt_cur:%d limit:%d page:%d"
			"blk:%d chip%d, retry_cnt:%d\n",
			__func__, __LINE__,
			aml_chip->ecc_cnt_cur,
			aml_chip->ecc_cnt_limit,
			page_addr,
			page_addr >> pages_per_blk_shift, i,
			readretry_failed_cnt);

			mtd->ecc_stats.corrected++;
					}
				}
#endif
				mtd->ecc_stats.corrected += stat;
			}
#ifdef NEW_NAND_SUPPORT
			if ( readretry_failed_cnt ) {
if ((aml_chip->new_nand_info.type == SANDISK_19NM)
	&& (aml_chip->new_nand_info.dynamic_read_info.dynamic_read_exit))
		aml_chip->new_nand_info.dynamic_read_info.dynamic_read_exit(mtd,
			i);
else if((aml_chip->new_nand_info.type)
	&& (aml_chip->new_nand_info.read_rety_info.read_retry_exit))
		aml_chip->new_nand_info.read_rety_info.read_retry_exit(mtd, i);
			}
#endif
			oob_buf += user_byte_num;
			buf += nand_page_size;
		} else {
			error = -ENODEV;
			goto exit;
		}
		}
	}
	}
exit:
	return error;
}

int aml_nand_write_page_hwecc(struct mtd_info *mtd,
	struct nand_chip *chip, const uint8_t *buf, int oob_required)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	uint8_t *oob_buf = chip->oob_poi;
	unsigned nand_page_size = (1 << chip->page_shift);
	int user_byte_num, temp_value;
	int error = 0, i = 0, j = 0, page_addr, internal_chipnr = 1;

	temp_value = nand_page_size + chip->ecc.size - 1;
	user_byte_num = (temp_value /chip->ecc.size) * aml_chip->user_byte_mode;

	if (aml_chip->ops_mode & AML_INTERLEAVING_MODE)
		internal_chipnr = aml_chip->internal_chipnr;

	memset(oob_buf + mtd->oobavail,
		0xa5, user_byte_num * (mtd->writesize / nand_page_size));

	for (i = 0; i < controller->chip_num; i++) {
		if (aml_chip->valid_chip[i]) {
		page_addr = aml_chip->page_addr;
		for (j = 0; j < internal_chipnr; j++) {
		aml_chip->aml_nand_select_chip(aml_chip, i);
		if (j > 0) {
			page_addr = aml_chip->page_addr;
			page_addr |=
				(1 <<aml_chip->internal_chip_shift) * j;
			aml_chip->aml_nand_command(aml_chip,
			NAND_CMD_SEQIN, 0, page_addr, i);
		}
		if (aml_chip->plane_num == 2) {
			aml_chip->aml_nand_set_user_byte(aml_chip,
				oob_buf, user_byte_num);
			error = aml_chip->aml_nand_dma_write(aml_chip,
				(unsigned char *)buf,
				nand_page_size, aml_chip->bch_mode);
			if (error) {
				printk("dma write 1 err at page %x\n",
					page_addr);
				goto exit;
			}
			aml_chip->aml_nand_command(aml_chip,
				NAND_CMD_DUMMY_PROGRAM, -1, -1, i);

			oob_buf += user_byte_num;
			buf += nand_page_size;

			if (!aml_chip->aml_nand_wait_devready(aml_chip, i)) {
				printk ("write couldn't found chip:%d ready\n",
					i);
				error = -EBUSY;
				goto exit;
			}

			aml_chip->aml_nand_command(aml_chip,
				NAND_CMD_TWOPLANE_WRITE2, 0x00, page_addr, i);
			aml_chip->aml_nand_set_user_byte(aml_chip,
				oob_buf, user_byte_num);
			error = aml_chip->aml_nand_dma_write(aml_chip,
				(u8 *)buf,
				nand_page_size, aml_chip->bch_mode);
			if (error) {
				printk("aml_nand_dma_write 2 err at page %x\n",
					page_addr);
				goto exit;
			}
			if (aml_chip->cached_prog_status)
				aml_chip->aml_nand_command(aml_chip,
					NAND_CMD_CACHEDPROG, -1, -1, i);
			else
				aml_chip->aml_nand_command(aml_chip,
					NAND_CMD_PAGEPROG, -1, -1, i);

			oob_buf += user_byte_num;
			buf += nand_page_size;
		} else if (aml_chip->plane_num == 1) {
			aml_chip->aml_nand_set_user_byte(aml_chip,
				oob_buf, user_byte_num);
			error = aml_chip->aml_nand_dma_write(aml_chip,
				(unsigned char *)buf,
				nand_page_size, aml_chip->bch_mode);
			if (error) {
				printk("aml_nand_dma_write err at page %x\n",
					page_addr);
				goto exit;
			}
			if (chip->cmdfunc == aml_nand_command) {
				if (aml_chip->cached_prog_status)
					aml_chip->aml_nand_command(aml_chip,
						NAND_CMD_CACHEDPROG, -1, -1, i);
				else
					aml_chip->aml_nand_command(aml_chip,
						NAND_CMD_PAGEPROG, -1, -1, i);
			}

			oob_buf += user_byte_num;
			buf += nand_page_size;
		}
		else {
			error = -ENODEV;
			goto exit;
		}
		}
		}
	}
exit:
	return error;
}

int aml_nand_write_page(struct mtd_info *mtd,
	struct nand_chip *chip, uint32_t offset,
	int data_len,
	const uint8_t *buf,
	int oob_required, int page, int cached, int raw)
{
	int status;
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);

	chip->cmdfunc(mtd, NAND_CMD_SEQIN, 0x00, page);

	if ((cached) && (chip->options & NAND_CACHEPRG))
		aml_chip->cached_prog_status = 1;
	else
		aml_chip->cached_prog_status = 0;
	if (unlikely(raw))
		chip->ecc.write_page_raw(mtd, chip, buf, 0);
	else
		chip->ecc.write_page(mtd, chip, buf, 0);

	if (!cached || !(chip->options & NAND_CACHEPRG)) {
		status = chip->waitfunc(mtd, chip);
		/*
		 * See if operation failed and additional status checks are
		 * available
		 */
		if ((status & NAND_STATUS_FAIL) && (chip->errstat))
			status = chip->errstat(mtd,
				chip, FL_WRITING, status, page);

		if (status & NAND_STATUS_FAIL) {
			printk("wr page=0x%x, status =  0x%x\n",
				page,status);
			return -EIO;
		}
	} else
		status = chip->waitfunc(mtd, chip);

	aml_chip->cached_prog_status = 0;
	return 0;
}

int aml_nand_read_oob(struct mtd_info *mtd, struct nand_chip *chip, int page)
{
	int32_t page_addr, user_byte_num, internal_chipnr=1;
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	unsigned char *nand_buffer = aml_chip->aml_nand_data_buf;
	unsigned char *oob_buffer = chip->oob_poi;
	unsigned pages_per_blk_shift =chip->phys_erase_shift - chip->page_shift;
	unsigned nand_page_size = (1 << chip->page_shift);
	unsigned nand_read_size = mtd->oobavail, dma_once_size;
	unsigned read_chip_num;
	int ran_mode = aml_chip->ran_mode;
	int32_t error=0, i, stat=0, j=0,

#ifdef NEW_NAND_SUPPORT
	int page_temp, readretry_failed_cnt = 0,
	int pages_per_blk =  (1 << (chip->phys_erase_shift - chip->page_shift));
	int retry_cnt = aml_chip->new_nand_info.read_rety_info.retry_cnt;

	if ((aml_chip->new_nand_info.type == HYNIX_20NM_8GB)
	|| (aml_chip->new_nand_info.type == HYNIX_20NM_4GB)
	|| (aml_chip->new_nand_info.type == HYNIX_1YNM_8GB)) {
		temp = aml_chip->new_nand_info.read_rety_info.retry_cnt;
		retry_cnt = temp * temp;
	}
#endif
	temp = (unsigned)aml_chip->plane_num * nand_page_size;
	read_chip_num = (nand_read_size + temp - 1) / temp;

	if (nand_read_size >= nand_page_size)
		temp = nand_page_size + chip->ecc.size - 1;
	else
		temp = nand_read_size + chip->ecc.size - 1;
	user_byte_num = (temp /chip->ecc.size) * aml_chip->user_byte_mode;
	page_addr = page;
	if (aml_chip->ops_mode & AML_INTERLEAVING_MODE) {
		internal_chipnr = aml_chip->internal_chipnr;
		if (read_chip_num < internal_chipnr) {
			internal_chipnr =
(read_chip_num + aml_chip->internal_chipnr - 1) / aml_chip->internal_chipnr;
			read_chip_num = 1;
		} else
			read_chip_num =
(read_chip_num + aml_chip->internal_chipnr - 1) / aml_chip->internal_chipnr;
	}


	if (chip->cmdfunc == aml_nand_command)
		chip->cmdfunc(mtd, NAND_CMD_READOOB, 0, page_addr);
	else {
		aml_chip->aml_nand_select_chip(aml_chip, 0);
		chip->cmdfunc(mtd, NAND_CMD_READ0, 0, page_addr);
	}

	for (i = 0; i < read_chip_num; i++) {
		if (aml_chip->valid_chip[i]) {
			page_addr = aml_chip->page_addr;
			if (i > 0) {
				aml_chip->aml_nand_select_chip(aml_chip, i);
				aml_chip->aml_nand_command(aml_chip,
					NAND_CMD_READ0, 0, page_addr, i);
			}
#ifdef NEW_NAND_SUPPORT
			readretry_failed_cnt = 0;
read_retry:
#endif
			page_addr = aml_chip->page_addr;
			for (j = 0; j < internal_chipnr; j++) {
			if (j > 0) {
				page_addr = aml_chip->page_addr;
				page_addr |=
				(1 << aml_chip->internal_chip_shift) * j;
				aml_chip->aml_nand_select_chip(aml_chip, i);
				aml_chip->aml_nand_command(aml_chip,
					NAND_CMD_READ0, 0, page_addr, i);
			}

			if (!aml_chip->aml_nand_wait_devready(aml_chip, i)) {
				printk ("read couldn't found chip%d ready\n", i);
				error = -EBUSY;
				goto exit;
			}
			if (aml_chip->ops_mode & AML_CHIP_NONE_RB)
				chip->cmd_ctrl(mtd, NAND_CMD_READ0 & 0xff,
					NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);

			if (aml_chip->plane_num == 2) {
				dma_once_size = min(nand_read_size,
					nand_page_size);
				aml_chip->aml_nand_command(aml_chip,
					NAND_CMD_TWOPLANE_READ1,
					0x00, page_addr, i);
dma_retry_plane0:
				error = aml_chip->aml_nand_dma_read(aml_chip,
					nand_buffer,
					dma_once_size, aml_chip->bch_mode);
				if (error)
					goto exit;

				aml_chip->aml_nand_get_user_byte(aml_chip,
					oob_buffer, user_byte_num);
				stat =aml_chip->aml_nand_hwecc_correct(aml_chip,
					nand_buffer, dma_once_size, oob_buffer);
				if (stat < 0) {
					if(aml_chip->ran_mode
				&& (aml_chip->zero_cnt < aml_chip->ecc_max)){
					    memset(oob_buffer,
						0xff, user_byte_num);
					    goto plane0_ff;
					}

					if (ran_mode && aml_chip->ran_mode) {
						aml_chip->ran_mode = 0;
						ndelay(300);
					aml_chip->aml_nand_command(aml_chip,
						NAND_CMD_RNDOUT, 0, -1, i);
						ndelay(500);
						goto dma_retry_plane0;
					 }
					memset(oob_buffer, 0x22, user_byte_num);

					mtd->ecc_stats.failed++;
					printk("rdoob pl0 failed pg%d chip%d\n",
						page_addr, i);
				} else {
if (aml_chip->ecc_cnt_cur > aml_chip->ecc_cnt_limit) {
	printk("%s %d uncorrect ecc_cnt_cur:%d limit:%d pg:%d blk:%d chip%d\n",
		__func__, __LINE__,
		aml_chip->ecc_cnt_cur,
		aml_chip->ecc_cnt_limit,
		page_addr, (page_addr >> pages_per_blk_shift), i);

	mtd->ecc_stats.corrected++;
}
					mtd->ecc_stats.corrected += stat;
				}
plane0_ff:
				aml_chip->ran_mode = ran_mode;
				oob_buffer += user_byte_num;
				nand_read_size -= dma_once_size;

				if (nand_read_size > 0) {
					dma_once_size = min(nand_read_size,
						nand_page_size);
					aml_chip->aml_nand_command(aml_chip,
						NAND_CMD_TWOPLANE_READ2,
						0x00, page_addr, i);
dma_retry_plane1:
				error = aml_chip->aml_nand_dma_read(aml_chip,
					nand_buffer, dma_once_size,
					aml_chip->bch_mode);
					if (error) {
						aml_chip->ran_mode = ran_mode;
						goto exit;
					}

			aml_chip->aml_nand_get_user_byte(aml_chip,
				oob_buffer, user_byte_num);
			stat = aml_chip->aml_nand_hwecc_correct(aml_chip,
				nand_buffer, dma_once_size, oob_buffer);
					if (stat < 0) {
				if(aml_chip->ran_mode
				&& (aml_chip->zero_cnt <  aml_chip->ecc_max)) {
					memset(oob_buffer, 0xff, user_byte_num);
					aml_chip->ran_mode = ran_mode;
					oob_buffer += user_byte_num;
					nand_read_size -= dma_once_size;
					continue;
				}
				if (ran_mode && aml_chip->ran_mode) {
					aml_chip->ran_mode = 0;
					ndelay(300);
					aml_chip->aml_nand_command(aml_chip,
						NAND_CMD_RNDOUT, 0, -1, i);
					ndelay(500);
					goto dma_retry_plane1;
				}
				memset(oob_buffer, 0xff, user_byte_num);
				mtd->ecc_stats.failed++;
				printk("read oob pl1 failed page %d chip%d \n",
					page_addr, i);
					} else {
			if (aml_chip->ecc_cnt_cur > aml_chip->ecc_cnt_limit) {
printk("%s line:%d uncorrect ecc_cnt_cur:%d limit:%d  page:%d, blk:%d chip%d\n",
					__func__, __LINE__,
					aml_chip->ecc_cnt_cur,
					aml_chip->ecc_cnt_limit,
					page_addr,
					(page_addr >> pages_per_blk_shift), i);
				mtd->ecc_stats.corrected++;
			}
						mtd->ecc_stats.corrected +=stat;
					}
					aml_chip->ran_mode = ran_mode;
					oob_buffer += user_byte_num;
					nand_read_size -= dma_once_size;
				}
			} else if (aml_chip->plane_num == 1) {
				dma_once_size = min(nand_read_size,
					nand_page_size);
				error = aml_chip->aml_nand_dma_read(aml_chip,
				nand_buffer, dma_once_size, aml_chip->bch_mode);
				if (error) {
					aml_chip->ran_mode = ran_mode;
					return error;
				}

				aml_chip->aml_nand_get_user_byte(aml_chip,
					oob_buffer, user_byte_num);
				stat =aml_chip->aml_nand_hwecc_correct(aml_chip,
					nand_buffer, dma_once_size, oob_buffer);
				if (stat < 0) {
					if(aml_chip->ran_mode
				&& (aml_chip->zero_cnt  <  aml_chip->ecc_max)) {
						memset(oob_buffer,
							0xff, user_byte_num);
						oob_buffer += user_byte_num;
						nand_read_size -= dma_once_size;
						continue;
					}
					aml_chip->ran_mode = ran_mode;
#ifdef NEW_NAND_SUPPORT
		if (aml_chip->new_nand_info.type == SANDISK_19NM) {
			temp =
			pages_per_blk* (page_addr >> pages_per_blk_shift);
			page_temp = page_addr - temp;
			if (((page_temp % 2 == 0) && (page_temp !=0))
			||(page_temp == (pages_per_blk -1))) {
				if (readretry_failed_cnt++ < DYNAMIC_CNT_UPPER) {
	aml_nand_debug("read ecc failed pg:%d  blk %d chip %d, retry_cnt:%d\n",
		page_addr, (page_addr >> pages_per_blk_shift),
		i, readretry_failed_cnt);
	aml_chip->new_nand_info.dynamic_read_info.dynamic_read_handle(mtd,
		page_temp, i);
	aml_chip->aml_nand_command(aml_chip, NAND_CMD_READ0, 0, page_addr, i);
						goto read_retry;
				}
			} else {
				if (readretry_failed_cnt++ < DYNAMIC_CNT_LOWER) {
	aml_nand_debug("read ecc failed pg:%d blk%d chip%d, retry_cnt:%d\n",
		page_addr, (page_addr >> pages_per_blk_shift),
		i, readretry_failed_cnt);
	aml_chip->new_nand_info.dynamic_read_info.dynamic_read_handle(mtd, page_temp, i);
	aml_chip->aml_nand_command(aml_chip, NAND_CMD_READ0, 0, page_addr, i);
	goto read_retry;
				}
			}
		} else if(aml_chip->new_nand_info.type) {
			if (readretry_failed_cnt++ < retry_cnt) {
	aml_nand_debug("read ecc failed pg:%d blk %d chip%d retry_cnt:%d\n",
		page_addr, (page_addr >> pages_per_blk_shift),
		i, readretry_failed_cnt);
	aml_chip->new_nand_info.read_rety_info.read_retry_handle(mtd, i);
	aml_chip->aml_nand_command(aml_chip, NAND_CMD_READ0, 0, page_addr, i);
	goto read_retry;
			}
		}
#endif
	printk("##%s %d read oob failed here at at page:%d, blk:%d chip[%d]\n",
		__func__, __LINE__, page_addr,
		page_addr >> pages_per_blk_shift, i);

				memset(oob_buffer, 0x22, user_byte_num);
				mtd->ecc_stats.failed++;
#ifdef NEW_NAND_SUPPORT
				if ((aml_chip->new_nand_info.type)
				&& (aml_chip->new_nand_info.type<10)) {
					aml_chip->aml_nand_command(aml_chip,
						NAND_CMD_RESET, -1, -1, i);
			if (!aml_chip->aml_nand_wait_devready(aml_chip, i)) {
						printk ("read couldn`t found selected chip: %d ready\n", i);
						error = -EBUSY;
						goto exit;
					}
				}
#endif
				} else {
			aml_chip->ran_mode = ran_mode;
#ifdef NEW_NAND_SUPPORT
			if (aml_chip->new_nand_info.type == SANDISK_19NM) {
				temp =
				pages_per_blk*(page_addr>>pages_per_blk_shift);
				page_temp = page_addr - temp;
				if (((page_temp % 2 == 0) && (page_temp !=0))
				||(page_temp == (pages_per_blk -1))) {
if (readretry_failed_cnt > DYNAMIC_CNT_UPPER -2) {
	printk("%s %d uncorrect ecccnt:%d limit:%d pg:%d blk:%d C%d rrcnt:%d\n",
	__func__, __LINE__,
	aml_chip->ecc_cnt_cur, aml_chip->ecc_cnt_limit,
	page_addr, (page_addr >> pages_per_blk_shift), i, readretry_failed_cnt);
	mtd->ecc_stats.corrected++;
}
				} else {
if (readretry_failed_cnt > DYNAMIC_CNT_LOWER -2) {
	printk("%s %d uncorrect ecccnt:%d limit:%d pg:%d blk:%d C%d rrcnt:%d\n",
	__func__, __LINE__,
	aml_chip->ecc_cnt_cur, aml_chip->ecc_cnt_limit,
	page_addr, (page_addr >> pages_per_blk_shift), i, readretry_failed_cnt);
	mtd->ecc_stats.corrected++;
}
				}
			} else if(aml_chip->new_nand_info.type) {
				if (readretry_failed_cnt > (retry_cnt-2)) {
printk("%s line:%d uncorrect ecccnt:%d limit:%d page:%d blk:%d C%d rrcnt:%d\n",
	__func__, __LINE__,
	aml_chip->ecc_cnt_cur, aml_chip->ecc_cnt_limit,
	page_addr, (page_addr >> pages_per_blk_shift), i, readretry_failed_cnt);
mtd->ecc_stats.corrected++;
				}

			}
#endif
					mtd->ecc_stats.corrected += stat;
				}
#ifdef NEW_NAND_SUPPORT
				if ( readretry_failed_cnt ) {
if ((aml_chip->new_nand_info.type == SANDISK_19NM)
	&& (aml_chip->new_nand_info.dynamic_read_info.dynamic_read_exit))
	aml_chip->new_nand_info.dynamic_read_info.dynamic_read_exit(mtd, i);
else if((aml_chip->new_nand_info.type)
	&& (aml_chip->new_nand_info.read_rety_info.read_retry_exit))
	aml_chip->new_nand_info.read_rety_info.read_retry_exit(mtd, i);
				}
#endif
				oob_buffer += user_byte_num;
				nand_read_size -= dma_once_size;
			} else {
				error = -ENODEV;
				goto exit;
			}
			}
		}
	}
exit:
	return nand_read_size;
}

int aml_nand_write_oob(struct mtd_info *mtd, struct nand_chip *chip, int page)
{
	printk("our host controller`s structure couldn`t support oob write\n");
	BUG();
	return 0;
}

int aml_nand_block_bad(struct mtd_info *mtd, loff_t ofs, int getchip)
{
	struct nand_chip * chip = mtd->priv;
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	struct aml_nand_platform *plat = aml_chip->platform;
	struct mtd_oob_ops aml_oob_ops;
	int32_t ret=0, read_cnt, page, mtd_erase_shift, blk_addr, pages_per_blk;
	loff_t addr;

	if ((!strncmp((char*)plat->name,
		NAND_BOOT_NAME, strlen((const char*)NAND_BOOT_NAME))))
		return 0;

	mtd_erase_shift = fls(mtd->erasesize) - 1;
	blk_addr = (int)(ofs >> mtd_erase_shift);

	if (aml_chip->block_status != NULL) {
		if (aml_chip->block_status[blk_addr] == NAND_BLOCK_BAD) {
			printk(" NAND bbt detect Bad block at %llx \n",
				(uint64_t)ofs);
			return EFAULT;
		}
		if (aml_chip->block_status[blk_addr] == NAND_FACTORY_BAD) {
			printk(" NAND bbt detect factory Bad block at %llx \n",
				(uint64_t)ofs);
			return FACTORY_BAD_BLOCK_ERROR;  //159  EFAULT
		} else if (aml_chip->block_status[blk_addr] ==NAND_BLOCK_GOOD)
			return 0;
	}
	chip->pagebuf = -1;
	pages_per_blk = (1 << (chip->phys_erase_shift - chip->page_shift));
	if (getchip) {
		aml_oob_ops.mode = MTD_OPS_AUTO_OOB;
		aml_oob_ops.len = mtd->writesize;
		aml_oob_ops.ooblen = mtd->oobavail;
		aml_oob_ops.ooboffs = chip->ecc.layout->oobfree[0].offset;
		aml_oob_ops.datbuf = chip->buffers->databuf;
		aml_oob_ops.oobbuf = chip->oob_poi;

		for (read_cnt = 0; read_cnt < 2; read_cnt++) {
			addr =
			ofs + (pages_per_blk - 1) * read_cnt * mtd->writesize;
			ret = mtd->_read_oob(mtd, addr, &aml_oob_ops);
			if (ret == -EUCLEAN)
				ret = 0;
			if (ret < 0) {
				printk("1 NAND detect Bad block:%llx\n",
					(uint64_t)addr);
				return EFAULT;
			}
			if (aml_oob_ops.oobbuf[chip->badblockpos] == 0xFF)
				continue;
			if (aml_oob_ops.oobbuf[chip->badblockpos] == 0) {
				memset(aml_chip->aml_nand_data_buf,
					0, aml_oob_ops.ooblen);
				if (!memcmp(aml_chip->aml_nand_data_buf,
				aml_oob_ops.oobbuf, aml_oob_ops.ooblen)) {
					printk("2 NAND detect Bad block:%llx\n",
						(uint64_t)addr);
					return EFAULT;
				}
			}
		}
	} else {
		for (read_cnt=0; read_cnt < 2; read_cnt++) {
			addr =
			ofs + (pages_per_blk - 1) * read_cnt * mtd->writesize;
			page = (int)(addr >> chip->page_shift);
			ret = chip->ecc.read_oob(mtd, chip, page);
			if (ret == -EUCLEAN)
				ret = 0;
			if (ret < 0)
				return EFAULT;
			if (chip->oob_poi[chip->badblockpos] == 0xFF)
				return 0;

			if (chip->oob_poi[chip->badblockpos] == 0) {
				memset(aml_chip->aml_nand_data_buf,
					0, (mtd->writesize + mtd->oobsize));
		if (!memcmp(aml_chip->aml_nand_data_buf + mtd->writesize,
			chip->oob_poi, mtd->oobavail)) {
					printk("3 NAND detect Bad block:%llx\n",
						(uint64_t)addr);
					return EFAULT;
				}
			}
		}
	}

	return 0;
}

int aml_nand_block_markbad(struct mtd_info *mtd, loff_t ofs)
{
	struct nand_chip * chip = mtd->priv;
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	struct mtd_oob_ops aml_oob_ops;
	int blk_addr, mtd_erase_shift;
	int8_t *buf = NULL;

	mtd_erase_shift = fls(mtd->erasesize) - 1;
	blk_addr = (int)(ofs >> mtd_erase_shift);
	if (aml_chip->block_status != NULL) {
		if ((aml_chip->block_status[blk_addr] == NAND_BLOCK_BAD)
		||(aml_chip->block_status[blk_addr] == NAND_FACTORY_BAD)) {
			//return 0;
			goto mark_bad;

		} else if (aml_chip->block_status[blk_addr] ==NAND_BLOCK_GOOD) {
			aml_chip->block_status[blk_addr] = NAND_BLOCK_BAD;
			buf = aml_chip->block_status;
			aml_nand_save_bbt(mtd, (u_char *)buf);
		}
	}
mark_bad:
	/*no erase here, fixit*/
	aml_oob_ops.mode = MTD_OPS_AUTO_OOB;
	aml_oob_ops.len = mtd->writesize;
	aml_oob_ops.ooblen = mtd->oobavail;
	aml_oob_ops.ooboffs = chip->ecc.layout->oobfree[0].offset;
	aml_oob_ops.datbuf = chip->buffers->databuf;
	aml_oob_ops.oobbuf = chip->oob_poi;
	chip->pagebuf = -1;

	memset((unsigned char *)aml_oob_ops.datbuf, 0x0, mtd->writesize);
	memset((unsigned char *)aml_oob_ops.oobbuf, 0x0, aml_oob_ops.ooblen);

	return mtd->_write_oob(mtd, ofs, &aml_oob_ops);
}

static uint8_t aml_platform_read_byte(struct mtd_info *mtd)
{
	//struct nand_chip *chip = mtd->priv;
	//struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	uint8_t status;

	NFC_SEND_CMD_DRD(controller, controller->chip_selected, 0);
	NFC_SEND_CMD_IDLE(controller, NAND_TWB_TIME_CYCLE);

	NFC_SEND_CMD_IDLE(controller, 0);
	NFC_SEND_CMD_IDLE(controller, 0);

	while (NFC_CMDFIFO_SIZE(controller) > 0) ;
	status = amlnf_read_reg32(controller->reg_base + P_NAND_BUF);
	return status;
}

void aml_platform_write_byte(struct aml_nand_chip *aml_chip, uint8_t data)
{
	NFC_SEND_CMD_IDLE(controller, NAND_TWB_TIME_CYCLE);
	NFC_SEND_CMD_DWR(controller, controller->chip_selected, data);
	NFC_SEND_CMD_IDLE(controller, NAND_TWB_TIME_CYCLE);

	NFC_SEND_CMD_IDLE(controller, 0);
	NFC_SEND_CMD_IDLE(controller, 0);

	while (NFC_CMDFIFO_SIZE(controller) > 0)
		;
}

int aml_nand_init(struct aml_nand_chip *aml_chip)
{
	struct aml_nand_platform *plat = aml_chip->platform;
	struct nand_chip *chip = &aml_chip->chip;
	struct mtd_info *mtd = &aml_chip->mtd;
	int err = 0, i = 0;
	int oobmul;
	unsigned valid_chip_num = 0;
	struct nand_oobfree *oobfree = NULL;
	cpu_id_t cpu_id = get_cpu_id();

	chip->IO_ADDR_R = chip->IO_ADDR_W =
		(void __iomem *)((volatile u32 *)(NAND_BASE_APB + P_NAND_BUF));

	chip->options |= NAND_SKIP_BBTSCAN;
	chip->options |= NAND_NO_SUBPAGE_WRITE;

	chip->ecc.layout = &aml_nand_oob_64;
	chip->select_chip = aml_nand_select_chip;
	chip->cmd_ctrl = aml_nand_cmd_ctrl;
	chip->read_byte = aml_platform_read_byte;

	controller->chip_num = plat->platform_nand_data.chip.nr_chips;
	if (controller->chip_num > MAX_CHIP_NUM) {
		err = -ENXIO;
		goto exit_error;
	}

	for (i=0; i<controller->chip_num; i++)
		aml_chip->valid_chip[i] = 1;

	/*use NO RB mode to detect nand chip num*/
	aml_chip->ops_mode |= AML_CHIP_NONE_RB;
	chip->chip_delay = 100;

	aml_chip->aml_nand_hw_init(aml_chip);
	aml_chip->toggle_mode =0;
	aml_chip->bch_info = NAND_ECC_BCH60_1K;
	if ((cpu_id.family_id == MESON_CPU_MAJOR_ID_AXG) ||
	    (cpu_id.family_id == MESON_CPU_MAJOR_ID_TXHD) ||
		(cpu_id.family_id == MESON_CPU_MAJOR_ID_TL1))
		aml_chip->bch_info = NAND_ECC_BCH8_1K;

	chip->options = 0;
	chip->options |=  NAND_SKIP_BBTSCAN;
	chip->options |= NAND_NO_SUBPAGE_WRITE;
	if (aml_nand_scan(mtd, controller->chip_num)) {
		err = -ENXIO;
		goto exit_error;
	}

	valid_chip_num = 0;
	for (i=0; i < controller->chip_num; i++) {
		if (aml_chip->valid_chip[i])
		    valid_chip_num++;
	}

	chip->scan_bbt = aml_nand_scan_bbt;
	if (aml_chip->aml_nand_adjust_timing)
		aml_chip->aml_nand_adjust_timing(aml_chip);

	if (aml_chip->aml_nand_options_confirm(aml_chip)) {
		err = -ENXIO;
		goto exit_error;
	}
	if (plat->platform_nand_data.chip.ecclayout)
		chip->ecc.layout = plat->platform_nand_data.chip.ecclayout;
	else {
		oobmul = mtd->oobsize /aml_chip->oob_size ;
		if (!chip->ecc.layout)
			chip->ecc.layout =
			kzalloc(sizeof(struct nand_ecclayout), GFP_KERNEL);
		if (!chip->ecc.layout) {
			err = -ENOMEM;
			goto exit_error ;
		}
		if (!strncmp((char*)plat->name, NAND_BOOT_NAME,
			strlen((const char*)NAND_BOOT_NAME)))
			memcpy(chip->ecc.layout,
			&aml_nand_uboot_oob, sizeof(struct nand_ecclayout));
		else if (chip->ecc.mode != NAND_ECC_SOFT) {
			switch (aml_chip->oob_size) {
				case 64:
				memcpy(chip->ecc.layout,
					&aml_nand_oob_64,
					sizeof(struct nand_ecclayout));
				break;
				case 128:
				memcpy(chip->ecc.layout,
					&aml_nand_oob_128,
					sizeof(struct nand_ecclayout));
				break;
				case 218:
				memcpy(chip->ecc.layout,
					&aml_nand_oob_218,
					sizeof(struct nand_ecclayout));
				break;
				case 224:
				memcpy(chip->ecc.layout,
					&aml_nand_oob_224,
					sizeof(struct nand_ecclayout));
				break;
				case 256:
				memcpy(chip->ecc.layout,
					&aml_nand_oob_256,
					sizeof(struct nand_ecclayout));
				break;
				case 376:
				memcpy(chip->ecc.layout,
					&aml_nand_oob_376,
					sizeof(struct nand_ecclayout));
				break;
				case 436:
				memcpy(chip->ecc.layout,
					&aml_nand_oob_436,
					sizeof(struct nand_ecclayout));
				break;
				case 448:
				memcpy(chip->ecc.layout,
					&aml_nand_oob_448,
					sizeof(struct nand_ecclayout));
					break;
				case 640:
				memcpy(chip->ecc.layout,
					&aml_nand_oob_640,
					sizeof(struct nand_ecclayout));
				break;
				case 744:
				memcpy(chip->ecc.layout,
					&aml_nand_oob_744,
					sizeof(struct nand_ecclayout));
				break;
				case 1280:
				memcpy(chip->ecc.layout,
					&aml_nand_oob_1280,
					sizeof(struct nand_ecclayout));
				break;
				case 1664:
				memcpy(chip->ecc.layout,
					&aml_nand_oob_1664,
					sizeof(struct nand_ecclayout));
				break;
				default:
				printk("default, use nand base oob layout %d\n",
					mtd->oobsize);
				oobfree[0].length =
		((mtd->writesize / chip->ecc.size) * aml_chip->user_byte_mode);
				break;
			}

			chip->ecc.layout->oobfree[0].length *= oobmul;
			chip->ecc.layout->eccbytes *= oobmul;
			printk("%s :oobmul=%d,oobfree.length=%d,oob_size=%d\n",
				__func__,
				oobmul,
				chip->ecc.layout->oobfree[0].length,
				aml_chip->oob_size);
		}
	}

	/*
	 * The number of bytes available for a client to place data into
	 * the out of band area
	 */
	chip->ecc.layout->oobavail = 0;
	oobfree = chip->ecc.layout->oobfree;
	for (i = 0; oobfree[i].length && i < ARRAY_SIZE(oobfree); i++)
		chip->ecc.layout->oobavail += oobfree[i].length;
	printk("oob avail size %d\n", chip->ecc.layout->oobavail);

	mtd->oobavail = chip->ecc.layout->oobavail;
	mtd->ecclayout = chip->ecc.layout;

	aml_chip->virtual_page_size = mtd->writesize;
	aml_chip->virtual_block_size = mtd->erasesize;

	aml_chip->aml_nand_data_buf =
		kzalloc((mtd->writesize + mtd->oobsize), GFP_KERNEL);
	if (aml_chip->aml_nand_data_buf == NULL) {
		printk("no memory for flash data buf\n");
		err = -ENOMEM;
		goto exit_error;
	}
	aml_chip->user_info_buf =
		kzalloc((mtd->writesize / chip->ecc.size) * PER_INFO_BYTE,
		GFP_KERNEL);
	if (aml_chip->user_info_buf == NULL) {
		printk("no memory for flash info buf\n");
		err = -ENOMEM;
		goto exit_error;
	}

	if (chip->buffers == NULL) {
		printk("no memory for flash data buf\n");
		err = -ENOMEM;
		goto exit_error;
	}

	chip->oob_poi = chip->buffers->databuf + mtd->writesize;
	chip->options |= NAND_OWN_BUFFERS;

#ifdef NEW_NAND_SUPPORT
	if ((aml_chip->new_nand_info.type)
		&& (aml_chip->new_nand_info.type < 10)) {
		if (aml_chip->new_nand_info.slc_program_info.get_default_value)
		aml_chip->new_nand_info.slc_program_info.get_default_value(mtd);
	}
#endif

	if (strncmp((char*)plat->name,
		NAND_BOOT_NAME, strlen((const char*)NAND_BOOT_NAME))) {
#ifdef NEW_NAND_SUPPORT
	if ((aml_chip->new_nand_info.type)
		&& (aml_chip->new_nand_info.type < 10)) {
		if (aml_chip->new_nand_info.read_rety_info.get_default_value)
		aml_chip->new_nand_info.read_rety_info.get_default_value(mtd);
	}
	if ((aml_chip->new_nand_info.type)
		&& ((aml_chip->new_nand_info.type == SANDISK_19NM)
		||(aml_chip->new_nand_info.type == SANDISK_24NM)))
	aml_chip->new_nand_info.dynamic_read_info.dynamic_read_init(mtd);
#endif
	aml_nand_rsv_info_init(mtd);
	err = aml_nand_bbt_check(mtd);
	if (err) {
		printk("invalid nand bbt\n");
		goto exit_error;
	}
#ifndef CONFIG_ENV_IS_IN_NAND
	aml_nand_env_check(mtd);
#endif
	aml_nand_key_check(mtd);
	aml_nand_dtb_check(mtd);

#ifdef NEW_NAND_SUPPORT
	if ((aml_chip->new_nand_info.type)
		&& (aml_chip->new_nand_info.type < 10)
		&& (aml_chip->new_nand_info.read_rety_info.default_flag == 0))
		aml_chip->new_nand_info.read_rety_info.save_default_value(mtd);
#endif
	}
	if (aml_nand_add_partition(aml_chip) != 0) {
		err = -ENXIO;
		goto exit_error;
	}

	printk("%s initialized ok\n", mtd->name);
	return 0;

exit_error:
	if (aml_chip->user_info_buf) {
		kfree(aml_chip->user_info_buf);
		aml_chip->user_info_buf = NULL;
	}
	if (chip->buffers) {
		kfree(chip->buffers);
		chip->buffers = NULL;
	}
	if (aml_chip->aml_nand_data_buf) {
		kfree(aml_chip->aml_nand_data_buf);
		aml_chip->aml_nand_data_buf = NULL;
	}
	if (aml_chip->block_status) {
		kfree(aml_chip->block_status);
		aml_chip->block_status = NULL;
	}
	return err;
}
