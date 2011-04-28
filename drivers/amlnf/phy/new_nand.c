/*****************************************************************
**                                                              
**  Copyright (C) 2012 Amlogic,Inc.  All rights reserved                         
**                                           
**        Filename : retry_slc.c       	
**        Revision : 1.001	                                        
**        Author: Benjamin Zhao
**        Description: 
**			read retry and enchance slc program function information,  
**        		mainly init nand phy driver.
**            
*****************************************************************/
#include "../include/phynand.h"

static unsigned char pagelist_hynix256[128] = {
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
#ifdef AML_NAND_UBOOT
static unsigned char get_reboot_mode(void)
{
	unsigned reboot_mode_val = reboot_mode;
	unsigned char reboot_flag = 0;

	aml_nand_dbg("check reboot mode here and  reboot_mode_val:0x%x", reboot_mode_val);

	switch(reboot_mode_val)
	{
		case AMLOGIC_FACTORY_RESET_REBOOT:
		case	AMLOGIC_UPDATE_REBOOT:
		case	AMLOGIC_CRASH_REBOOT:
		case	AMLOGIC_FACTORY_TEST_REBOOT:
		case	AMLOGIC_SYSTEM_SWITCH_REBOOT:
		case	AMLOGIC_SAFE_REBOOT:
		case	AMLOGIC_LOCK_REBOOT:
		case AMLOGIC_REBOOT_CLEAR:
			reboot_flag = 1;
			break;
		case AMLOGIC_NORMAL_BOOT:
			reboot_flag = 0;
			break;
		default:
			reboot_flag = 0;
			break;
	}

	return reboot_flag;
}

#endif
/*****************************HYNIX******************************************/

static int get_reg_value_hynix(struct hw_controller *controller,  unsigned char *buf, unsigned char *addr, 
						unsigned char chipnr, unsigned char cnt)
{
	struct amlnand_chip *aml_chip = controller->aml_chip;
	struct nand_flash *flash = &(aml_chip->flash);	
	int i, ret = 0;

	if((flash->new_type == 0) ||(flash->new_type > 10))
		return NAND_SUCCESS;

	aml_nand_dbg("flash->new_type:%d", flash->new_type);
	
	ret = controller->quene_rb(controller, chipnr);
	if(ret){
		aml_nand_msg("quene rb failed chipnr:%d", chipnr);
		return -NAND_FAILED;
	}
	
	controller->cmd_ctrl(controller, NAND_CMD_HYNIX_GET_VALUE, NAND_CTRL_CLE);
	
	for (i=0; i<cnt; i++){
	        controller->cmd_ctrl(controller, addr[i], NAND_CTRL_ALE);
	        NFC_SEND_CMD_IDLE(controller->chip_selected, 10);
		buf[i] = controller->readbyte(controller);
		  NFC_SEND_CMD_IDLE(controller->chip_selected, 10);
		aml_nand_dbg("REG(0x%x): 	value:0x%x, for chip[%d] \n", addr[i], buf[i], chipnr);
        }

	ret = controller->quene_rb(controller, chipnr);
	if(ret){
		aml_nand_msg("quene rb failed chipnr:%d", chipnr);
		return -NAND_FAILED;
	}

	return NAND_SUCCESS;
}

static int set_reg_value_hynix(struct hw_controller *controller,  unsigned char *buf, unsigned char *addr, 
						unsigned char chipnr, unsigned char cnt)
{
	struct amlnand_chip *aml_chip = controller->aml_chip;
	struct nand_flash *flash = &(aml_chip->flash);	
	int i, ret = 0;

	if((flash->new_type == 0) ||(flash->new_type > 10))
		return NAND_SUCCESS;

	//aml_nand_dbg("flash->new_type:%d", flash->new_type);

	ret = controller->quene_rb(controller, chipnr);
	if(ret){
		aml_nand_msg("quene rb failed chipnr:%d", chipnr);
		return -NAND_FAILED;
	}

	controller->cmd_ctrl(controller, NAND_CMD_HYNIX_SET_VALUE_START, NAND_CTRL_CLE);
	
	for (i=0; i<cnt; i++){
	        controller->cmd_ctrl(controller, addr[i], NAND_CTRL_ALE);
		NFC_SEND_CMD_IDLE(controller->chip_selected, 15);
		controller->writebyte(controller, buf[i]);
		NFC_SEND_CMD_IDLE(controller->chip_selected, 0);
		//aml_nand_dbg("REG(0x%x): 	value:0x%x, for chip[%d]\n", addr[i], buf[i], chipnr);
	}
	
	controller->cmd_ctrl(controller, NAND_CMD_HYNIX_SET_VALUE_END, NAND_CTRL_CLE);

	ret = controller->quene_rb(controller, chipnr);
	if(ret){
		aml_nand_msg("quene rb failed chipnr:%d", chipnr);
		return -NAND_FAILED;
	}

	return 0;
}
static int aml_nand_get_20nm_OTP_value(struct hw_controller *controller,  unsigned char *buf,unsigned char chipnr)
{
	int i, j, k, reg_cnt_otp, total_reg_cnt, check_flag = 0;
	unsigned char  *tmp_buf;
	struct read_retry_info *retry_info =  &(controller->retry_info);
	total_reg_cnt = controller->readbyte(controller);
	reg_cnt_otp = controller->readbyte(controller);
	aml_nand_dbg("20 nm flash total_reg_cnt:%d, reg_cnt_otp:%d, chip[%d]", total_reg_cnt, reg_cnt_otp, chipnr);

	for(i=0; i<HYNIX_OTP_COPY; i++){
		check_flag = 0;
		memset(buf, 0, HYNIX_OTP_LEN>>1);
		for(j=0;j<(HYNIX_OTP_LEN>>1);j++){
			buf[j] = controller->readbyte(controller);
			ndelay(100);
		}
		for(j=0;j<64;j+=8){
			for(k=0;k<7;k++){
				if(((buf[k+j] < 0x80) && (buf[k+j+64] < 0x80)) ||
				   ((buf[k+j] > 0x80) && (buf[k+j+64] > 0x80))  ||
				   ((unsigned char)(buf[k+j]^buf[k+j+64]) != 0xFF)){
					aml_nand_dbg("%dst copy at j:%d, k%d, not match %2x %2x\n", \
						i, j, k, buf[k+j], buf[k+j+64]);
					check_flag = 1;
					break;
				}
				if(check_flag){
					break;
				}
			}
			if(check_flag){
				break;
			}
		}
		if(check_flag == 0){
			break;
		}
	}	
		if(check_flag){
		aml_nand_msg(" 20 nm flashdefault vaule abnormal not safe !!!!!, chip[%d]", chipnr);
		BUG();
	}
	else{
		tmp_buf = buf;
		aml_nand_dbg("20 nm flashdefault vaule OK at %dst copy", i);
		memcpy(&retry_info->reg_def_val[chipnr][0], tmp_buf, retry_info->reg_cnt_lp);
		aml_nand_dbg("20 nm flash default vaule");
		for(j=0;j<retry_info->reg_cnt_lp;j++)
			aml_nand_dbg("REG(0x%x):   value:0x%2x, for chip[%d]", retry_info->reg_addr_lp[j],
			                   retry_info->reg_def_val[chipnr][j], chipnr);
		tmp_buf += retry_info->reg_cnt_lp;
		aml_nand_dbg("20 nm flash offset vaule");
		for(j=0;j<retry_info->retry_cnt_lp;j++){
			for(k=0;k<retry_info->reg_cnt_lp;k++){
				retry_info->reg_offs_val_lp[chipnr][j][k] = (char)tmp_buf[0];
				tmp_buf++;
				aml_nand_dbg("Retry[%d]   REG(0x%x):	value:0x%2x, for chip[%d]", j, retry_info->reg_addr_lp[k],
				                 retry_info->reg_offs_val_lp[chipnr][j][k], chipnr);
			}
			aml_nand_dbg("retry_info->retry_cnt_lp:%d", retry_info->retry_cnt_lp);
		}
	}
	return check_flag;
}
static int aml_nand_get_1ynm_OTP_value(struct hw_controller *controller,  unsigned char *buf,unsigned char chipnr)
{
	int i, j, k,m, retry_cnt_otp, total_reg_cnt, check_flag = 0;
	unsigned char  *tmp_buf;
	struct read_retry_info *retry_info =  &(controller->retry_info);
	uchar retry_value_sta[32] ={0};
	memset(buf, 0, 528);
	for(i=0; i<528; i++){
		buf[i] = controller->readbyte(controller);
		 NFC_SEND_CMD_IDLE(controller->chip_selected, 0);
		  NFC_SEND_CMD_IDLE(controller->chip_selected, 0);
	}
	for(i=0; i<HYNIX_OTP_COPY; i++){
		for(j=0;j<8;j++){
			for(k=0;k<4;k++){
				if(retry_value_sta[j*4+k] ==0) {
					m = k+j*4+16+i*64;
					if((unsigned char)(buf[m]^buf[m+32]) == 0xFF){
					aml_nand_dbg("find %d group %d retry %d value ok,buf =0x%02x\n",i,j,k,buf[m]);
						if(j ==0)
							retry_info->reg_def_val[chipnr][k] = buf[m];
						else
						      	 retry_info->reg_offs_val_lp[chipnr][j-1][k] = buf[m];
						retry_value_sta[j*4+k] = 1;
				 }
			    }
			}
		}
	}	
	for(j=0;j<retry_info->reg_cnt_lp;j++)
			aml_nand_dbg("REG(0x%x):   value:0x%2x, for chip[%d]", retry_info->reg_addr_lp[j],
			                   retry_info->reg_def_val[chipnr][j], chipnr);
		for(j=0;j<retry_info->retry_cnt_lp;j++){
			for(k=0;k<retry_info->reg_cnt_lp;k++){
				aml_nand_dbg("Retry[%d]   REG(0x%x):	value:0x%2x, for chip[%d]", j, retry_info->reg_addr_lp[k],
				                 retry_info->reg_offs_val_lp[chipnr][j][k], chipnr);
			}
			aml_nand_dbg("retry_info->retry_cnt_lp:%d", retry_info->retry_cnt_lp);
		}
	for(i=0;i<32;i++)
		if(retry_value_sta[i] ==0) {
			aml_nand_msg("  chip[%d] flash %d vaule abnormal not safe !!!!!\n",chipnr,i);
			return 1;
	}
	return 0;
}
static int get_reg_value_formOTP_hynix(struct hw_controller *controller, unsigned char chipnr)
{
	struct amlnand_chip *aml_chip = controller->aml_chip;
	struct nand_flash *flash = &(aml_chip->flash);	
	struct chip_operation *operation = &(aml_chip->operation);
	struct read_retry_info *retry_info =  &(controller->retry_info);
	int i, j, k, reg_cnt_otp, total_reg_cnt, check_flag = 0;
	unsigned char *one_copy_buf, *tmp_buf;
	int ret = 0;

	if((flash->new_type != HYNIX_20NM_4GB) && (flash->new_type != HYNIX_20NM_8GB)&& (flash->new_type != HYNIX_1YNM_8GB))
		return 0;

	aml_nand_dbg("flash->new_type:%d", flash->new_type);

	one_copy_buf = (unsigned char *)aml_nand_malloc(HYNIX_OTP_LEN);
	if(one_copy_buf == NULL){
		aml_nand_msg("malloc failed and need 0x%x here", HYNIX_OTP_LEN);
		ret = -NAND_MALLOC_FAILURE;
		goto error_exit0;
	}

	ret = controller->quene_rb(controller, chipnr);
	if(ret){
		aml_nand_msg("quene rb failed chipnr:%d", chipnr);
		ret = -NAND_BUSY_FAILURE;
		goto error_exit1;
	}

	ret = operation->reset(aml_chip, chipnr);
	if(ret){
		aml_nand_msg("reset chip failed chipnr:%d", chipnr);
		ret = -NAND_BUSY_FAILURE;
		goto error_exit1;
	}

	controller->cmd_ctrl(controller, 0x36, NAND_CTRL_CLE);

	 NFC_SEND_CMD_IDLE(controller->chip_selected, 0);
	if(flash->new_type == HYNIX_20NM_8GB){
		controller->cmd_ctrl(controller, 0xff, NAND_CTRL_ALE);			//send 0xff add
		 NFC_SEND_CMD_IDLE(controller->chip_selected, 0);
		controller->writebyte(controller, 0x40);							//write 0x40 into 0xff add
		 NFC_SEND_CMD_IDLE(controller->chip_selected, 0);
		controller->cmd_ctrl(controller, 0xcc, NAND_CTRL_ALE);			//send 0xcc add
		NFC_SEND_CMD_IDLE(controller->chip_selected, 0);
		controller->writebyte(controller, 0x4d);							//write 0x4d 
	}
	else if(flash->new_type == HYNIX_20NM_4GB){
		controller->cmd_ctrl(controller, 0xae, NAND_CTRL_ALE);			//send 0xae add
		 NFC_SEND_CMD_IDLE(controller->chip_selected, 0);
		controller->writebyte(controller, 0x00);							//write 0x0 into 0xff add
		 NFC_SEND_CMD_IDLE(controller->chip_selected, 0);
		controller->cmd_ctrl(controller, 0xb0, NAND_CTRL_ALE);			//send 0xb0 add
		NFC_SEND_CMD_IDLE(controller->chip_selected, 0);
		controller->writebyte(controller, 0x4d);							//write 0x4d 
	}
	else if(flash->new_type == HYNIX_1YNM_8GB){
		controller->cmd_ctrl(controller, 0x38, NAND_CTRL_ALE);			//send 0xae add
	 NFC_SEND_CMD_IDLE(controller->chip_selected, 0);
		controller->writebyte(controller, 0x52);							//write 0x0 into 0xff add
		 NFC_SEND_CMD_IDLE(controller->chip_selected, 0);
	}
	 NFC_SEND_CMD_IDLE(controller->chip_selected, 0);
	controller->cmd_ctrl(controller, 0x16, NAND_CTRL_CLE);	//send cmd 0x16
	 NFC_SEND_CMD_IDLE(controller->chip_selected, 0);
	controller->cmd_ctrl(controller, 0x17, NAND_CTRL_CLE);				//send cmd 0x17
	 NFC_SEND_CMD_IDLE(controller->chip_selected, 0);
	controller->cmd_ctrl(controller, 0x04, NAND_CTRL_CLE);				//send cmd 0x04
	 NFC_SEND_CMD_IDLE(controller->chip_selected, 0);
	controller->cmd_ctrl(controller, 0x19, NAND_CTRL_CLE);					//send cmd 0x19
	 NFC_SEND_CMD_IDLE(controller->chip_selected, 0);
	controller->cmd_ctrl(controller, NAND_CMD_READ0, NAND_CTRL_CLE);
	controller->cmd_ctrl(controller, 0, NAND_CTRL_ALE);
	controller->cmd_ctrl(controller, 0>>8, NAND_CTRL_ALE);
	controller->cmd_ctrl(controller, 0x200, NAND_CTRL_ALE);
	controller->cmd_ctrl(controller, 0x200>>8, NAND_CTRL_ALE);
	controller->cmd_ctrl(controller, 0x200>>16, NAND_CTRL_ALE);
	controller->cmd_ctrl(controller, NAND_CMD_READSTART, NAND_CTRL_CLE);
	


#if 1
	ret = controller->quene_rb(controller, chipnr);
	if(ret){
		aml_nand_msg("quene rb failed chipnr:%d", chipnr);
		ret = -NAND_BUSY_FAILURE;
		goto error_exit1;
	}
	
	if (controller->option & NAND_CTRL_NONE_RB)
		controller->cmd_ctrl(controller, NAND_CMD_READ0, NAND_CTRL_CLE);
#else
	udelay(500);
#endif
#if 0
	total_reg_cnt = controller->readbyte(controller);
	reg_cnt_otp = controller->readbyte(controller);
	aml_nand_dbg("20 nm flash total_reg_cnt:%d, reg_cnt_otp:%d, chip[%d]", total_reg_cnt, reg_cnt_otp, chipnr);

	for(i=0; i<HYNIX_OTP_COPY; i++){
		check_flag = 0;
		memset(one_copy_buf, 0, HYNIX_OTP_LEN>>1);
		for(j=0;j<(HYNIX_OTP_LEN>>1);j++){
			one_copy_buf[j] = controller->readbyte(controller);
			ndelay(100);
		}

		for(j=0;j<64;j+=8){
			for(k=0;k<7;k++){
				if(((one_copy_buf[k+j] < 0x80) && (one_copy_buf[k+j+64] < 0x80)) ||
				   ((one_copy_buf[k+j] > 0x80) && (one_copy_buf[k+j+64] > 0x80))  ||
				   ((unsigned char)(one_copy_buf[k+j]^one_copy_buf[k+j+64]) != 0xFF)){
					aml_nand_dbg("%dst copy at j:%d, k%d, not match %2x %2x\n", \
						i, j, k, one_copy_buf[k+j], one_copy_buf[k+j+64]);
					check_flag = 1;
					break;
				}
				if(check_flag){
					break;
				}
			}
			if(check_flag){
				break;
			}
		}
		if(check_flag == 0){
			break;
		}
	}
#else
	if((flash->new_type == HYNIX_20NM_4GB) || (flash->new_type == HYNIX_20NM_8GB))
		 check_flag = aml_nand_get_20nm_OTP_value(controller,one_copy_buf,chipnr);
	else if(flash->new_type == HYNIX_1YNM_8GB)
		 check_flag = aml_nand_get_1ynm_OTP_value(controller,one_copy_buf,chipnr);

#endif

	ret = operation->reset(aml_chip, chipnr);
	if(ret){
		aml_nand_msg("reset chip failed chipnr:%d", chipnr);
		ret = -NAND_BUSY_FAILURE;
		goto error_exit1;
	}

	ret = controller->quene_rb(controller, chipnr);
	if(ret){
		aml_nand_msg("quene rb failed chipnr:%d", chipnr);
		ret = -NAND_BUSY_FAILURE;
		goto error_exit1;
	}
if((flash->new_type == HYNIX_20NM_4GB) || (flash->new_type == HYNIX_20NM_8GB)) {
	controller->cmd_ctrl(controller, 0x38, NAND_CTRL_CLE);			//end read otp mode

	}
else if(flash->new_type == HYNIX_1YNM_8GB) {
	controller->cmd_ctrl(controller, 0x36, NAND_CTRL_CLE);
	controller->cmd_ctrl(controller, 0x38, NAND_CTRL_ALE);
	NFC_SEND_CMD_IDLE(controller->chip_selected, 0);
	controller->writebyte(controller, 0);	
	NFC_SEND_CMD_IDLE(controller->chip_selected, 0);
	controller->cmd_ctrl(controller, 0x16, NAND_CTRL_CLE);
}
	ret = controller->quene_rb(controller, chipnr);
	if(ret){
		aml_nand_msg("quene rb failed chipnr:%d", chipnr);
		ret = -NAND_BUSY_FAILURE;
		goto error_exit1;
	}




	
	aml_nand_free(one_copy_buf);

	return 0;
	
error_exit1:
	aml_nand_free(one_copy_buf);

error_exit0:
	return ret;
}

/* init default offset value here, 
** first time, for 26nm, read directly from nand reg,
** first time, for 20nm, read from nand otp area
** normal booting, read from storage nand blocks
*/
static int readretry_init_hynix(struct hw_controller *controller)
{
	struct amlnand_chip *aml_chip = controller->aml_chip;
	struct chip_operation *operation = &(aml_chip->operation);	
	struct nand_flash *flash = &(aml_chip->flash);	
	struct chip_ops_para *ops_para = &(aml_chip->ops_para);
	struct read_retry_info *retry_info =  &(controller->retry_info);
	struct en_slc_info *slc_info =  &(controller->slc_info);
	int i, ret = 0;

	//read from nand block 

	ret = aml_nand_scan_hynix_info(aml_chip);
	if(ret < 0){
		aml_nand_msg("hynix nand readretry info scan: no info; and get it from nand reg or otp");
	}
#ifdef AML_NAND_UBOOT		
	//read from nand reg or otp
	if(retry_info->default_flag == 0){
		
#ifdef AML_NAND_UBOOT
		nand_get_chip();
#else
		nand_get_chip(aml_chip);
#endif		
		aml_nand_dbg("hynix nand readretry info scan: no info; and get it from nand reg or otp");
		for(i=0; i<controller->chip_num; i++){
			if((flash->new_type == HYNIX_26NM_4GB) || (flash->new_type == HYNIX_26NM_8GB)){
				ret = get_reg_value_hynix(controller, &retry_info->reg_def_val[i][0],\
					&retry_info->reg_addr_lp[0], i, retry_info->reg_cnt_lp);
				if(ret < 0){
					aml_nand_msg("get reg value hynix failed");
					goto error_exit;
				}
			}
			else  if((flash->new_type == HYNIX_20NM_8GB) || (flash->new_type == HYNIX_20NM_4GB)|| (flash->new_type == HYNIX_1YNM_8GB)){
				ret = get_reg_value_formOTP_hynix(controller, i);
				if(ret < 0){
					aml_nand_msg("get reg value hynix failed");
					goto error_exit;
				}
			}
			udelay(2);
		}
#ifdef AML_NAND_UBOOT
		nand_release_chip();
#else
		nand_release_chip(aml_chip);
#endif	
		
	}
#else
	if(retry_info->default_flag == 0){
		aml_nand_msg("hynix nand scan readretry info failed");
		ret = -NAND_FAILED;
	}

#endif
	retry_info->flag = 1;
	
error_exit:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
	return ret;
}


//when ecc fail,set nand retry reg
static int readretry_handle_hynix(struct hw_controller *controller, unsigned char chipnr)
{
	struct amlnand_chip *aml_chip = controller->aml_chip;
	struct nand_flash *flash = &(aml_chip->flash);	
	struct read_retry_info *retry_info =  &(controller->retry_info);
	unsigned char reg_value[READ_RETRY_REG_NUM];
	int i, cur_cnt;
	int retry_zone,retry_offset;

	if((flash->new_type == 0) ||(flash->new_type > 10))
		return NAND_SUCCESS;
	
	if(retry_info->cur_cnt_lp[chipnr] < retry_info->retry_cnt_lp)
	cur_cnt = retry_info->cur_cnt_lp[chipnr];
	else{
		retry_zone = retry_info->cur_cnt_lp[chipnr] /retry_info->retry_cnt_lp;
		retry_offset = retry_info->cur_cnt_lp[chipnr] % retry_info->retry_cnt_lp;
		cur_cnt = (retry_zone + retry_offset) % retry_info->retry_cnt_lp;
	}

	
	//cur_cnt = retry_info->cur_cnt_lp[chipnr];

	aml_nand_dbg("flash->new_type:%d, cur_cnt:%d", flash->new_type, cur_cnt);

	memset(&reg_value[0], 0, READ_RETRY_REG_NUM);

	for(i=0;i<retry_info->reg_cnt_lp;i++){
		if((flash->new_type == HYNIX_26NM_8GB) || (flash->new_type == HYNIX_26NM_4GB)){
			if(retry_info->reg_offs_val_lp[0][cur_cnt][i] == READ_RETRY_ZERO)
				reg_value[i] = 0;
			else
				reg_value[i] = retry_info->reg_def_val[chipnr][i]  + retry_info->reg_offs_val_lp[0][cur_cnt][i];
		}
		else  if((flash->new_type == HYNIX_20NM_8GB) || (flash->new_type == HYNIX_20NM_4GB)|| (flash->new_type == HYNIX_1YNM_8GB)){
			reg_value[i] = retry_info->reg_offs_val_lp[chipnr][cur_cnt][i];
		}
	}

	set_reg_value_hynix(controller, &reg_value[0], &retry_info->reg_addr_lp[0], chipnr, retry_info->reg_cnt_lp);
	udelay(2);

	//cur_cnt++;
	//retry_info->cur_cnt_lp[chipnr] = (cur_cnt > (retry_info->retry_cnt_lp -1)) ? 0 : cur_cnt;
	retry_info->cur_cnt_lp[chipnr]++;
}

static int readretry_set_def_val_hynix(struct hw_controller *controller, unsigned char chipnr)
{
	struct amlnand_chip *aml_chip = controller->aml_chip;
	struct nand_flash *flash = &(aml_chip->flash);	
	struct read_retry_info *retry_info =  &(controller->retry_info);
	struct en_slc_info *slc_info =  &(controller->slc_info);
	int i, ret = 0;

	if((flash->new_type == 0) ||(flash->new_type > 10))
		return NAND_SUCCESS;
	
	aml_nand_dbg("hynix reatry exit");
	memset(&retry_info->cur_cnt_lp[0], 0, MAX_CHIP_NUM);

	i = chipnr;
	//for (i=0; i<controller->chip_num; i++) {
		//for read retry
		ret = set_reg_value_hynix(controller, &retry_info->reg_def_val[i][0], \
								&retry_info->reg_addr_lp[0], i, retry_info->reg_cnt_lp);
		if(ret < 0){
			aml_nand_msg("set retry_info reg value failed for chip[%d]", i);
		}
		//for en-slc
		udelay(2);
		ret = set_reg_value_hynix(controller, &slc_info->reg_def_val[i][0], \
								&slc_info->reg_addr[0], i, slc_info->reg_cnt);
		if(ret < 0){
			aml_nand_msg("set slc_info reg value failed for chip[%d]", i);
		}
	//}

	return ret;
}

static int enslc_init_hynix(struct hw_controller *controller)
{
	struct amlnand_chip *aml_chip = controller->aml_chip;
	struct nand_flash *flash = &(aml_chip->flash);	
	struct en_slc_info *slc_info =  &(controller->slc_info);
	int i, ret = 0;
	
	if((flash->new_type == 0) ||(flash->new_type > HYNIX_20NM_8GB))
		return NAND_SUCCESS;

	//aml_nand_dbg("flash->new_type:%d", flash->new_type);
#ifdef AML_NAND_UBOOT
		nand_get_chip();
#else
		nand_get_chip(aml_chip);
#endif		
	for(i=0; i<controller->chip_num; i++){
		ret = get_reg_value_hynix(controller, &slc_info->reg_def_val[i][0],\
				&slc_info->reg_addr[0], i, slc_info->reg_cnt);
		if(ret){			
			aml_nand_msg("get slc_info def reg value failed for chip[%d]", i);
		}
	}
#ifdef AML_NAND_UBOOT
		nand_release_chip();
#else
		nand_release_chip(aml_chip);
#endif	

	return ret;
}

static int enslc_enter_hynix(struct hw_controller *controller)
{
	struct amlnand_chip *aml_chip = controller->aml_chip;
	struct nand_flash *flash = &(aml_chip->flash);	
	struct en_slc_info *slc_info =  &(controller->slc_info);
	unsigned char reg_value_tmp[EN_SLC_REG_NUM];
	int i, j, ret = 0;

	if((flash->new_type == 0) ||(flash->new_type > HYNIX_20NM_8GB))
		return NAND_SUCCESS;
	
	//aml_nand_dbg("flash->new_type:%d", flash->new_type);

	memset(&reg_value_tmp[0], 0, EN_SLC_REG_NUM);

	for (i=0; i<controller->chip_num; i++) {

		for(j=0;j<slc_info->reg_cnt;j++)
			reg_value_tmp[j] = slc_info->reg_def_val[i][j]  + slc_info->reg_offs_val[j];

		ret = set_reg_value_hynix(controller, &reg_value_tmp[0], &slc_info->reg_addr[0], i, slc_info->reg_cnt);
		if(ret < 0){
			aml_nand_msg("set slc_info reg value failed for chip[%d]", i);
		}
		udelay(2);
		memset(&reg_value_tmp[0], 0, EN_SLC_REG_NUM);
	}

	return ret;
}

//working  in Normal program mode
static int enslc_exit_hynix(struct hw_controller *controller)
{
	struct amlnand_chip *aml_chip = controller->aml_chip;
	struct nand_flash *flash = &(aml_chip->flash);	
	struct en_slc_info *slc_info = &(controller->slc_info);
	int i, ret = 0;

	if((flash->new_type == 0) ||(flash->new_type > HYNIX_20NM_8GB))
		return NAND_SUCCESS;
	
	//aml_nand_dbg("flash->new_type:%d", flash->new_type);

	for (i=0; i<controller->chip_num; i++) {

		ret = set_reg_value_hynix(controller, &slc_info->reg_def_val[i][0], \
									&slc_info->reg_addr[0], i, slc_info->reg_cnt);
		if(ret < 0){
			aml_nand_msg("set slc_info reg value failed for chip[%d]", i);
		}
		udelay(2);
	}

	return ret;
}


//for toshiba
/*******************************************TOSHIBA*********************************************/
static int set_reg_value_toshiba(struct hw_controller *controller,  unsigned char *buf, unsigned char *addr, 
						unsigned char chipnr, unsigned char cnt)
{
	struct amlnand_chip *aml_chip = controller->aml_chip;
	struct nand_flash *flash = &(aml_chip->flash);	
	struct read_retry_info *retry_info =  &(controller->retry_info);
	int i, ret = 0;

	//if(flash->new_type != TOSHIBA_2XNM)
	//	return NAND_SUCCESS;

	aml_nand_dbg("flash->new_type:%d", flash->new_type);

	ret = controller->quene_rb(controller, chipnr);
	if(ret){
		aml_nand_msg("quene rb failed chipnr:%d", chipnr);
		return -NAND_FAILED;
	}

	if(retry_info->cur_cnt_lp[chipnr] == 0){
		controller->cmd_ctrl(controller, NAND_CMD_TOSHIBA_PRE_CON1, NAND_CTRL_CLE);
		 NFC_SEND_CMD_IDLE(controller->chip_selected, 2);
		controller->cmd_ctrl(controller, NAND_CMD_TOSHIBA_PRE_CON2, NAND_CTRL_CLE);
		 NFC_SEND_CMD_IDLE(controller->chip_selected, 2);
	}
	
	for (i=0; i<cnt; i++){
		controller->cmd_ctrl(controller, NAND_CMD_TOSHIBA_SET_VALUE, NAND_CTRL_CLE);
		 NFC_SEND_CMD_IDLE(controller->chip_selected, 2);
	        controller->cmd_ctrl(controller, addr[i], NAND_CTRL_ALE);
		 NFC_SEND_CMD_IDLE(controller->chip_selected, 2);
		controller->writebyte(controller, buf[i]);
		 NFC_SEND_CMD_IDLE(controller->chip_selected, 2);
		aml_nand_dbg("REG(0x%x): 	value:0x%x, for chip[%d]\n", addr[i], buf[i], chipnr);
	}
	
	controller->cmd_ctrl(controller, NAND_CMD_TOSHIBA_BEF_COMMAND1, NAND_CTRL_CLE);
	 NFC_SEND_CMD_IDLE(controller->chip_selected, 2);
	controller->cmd_ctrl(controller, NAND_CMD_TOSHIBA_BEF_COMMAND2, NAND_CTRL_CLE);
	 NFC_SEND_CMD_IDLE(controller->chip_selected, 2);
	
	ret = controller->quene_rb(controller, chipnr);
	if(ret){
		aml_nand_msg("quene rb failed chipnr:%d", chipnr);
		return -NAND_FAILED;
	}

	return NAND_SUCCESS;
}

//when ecc fail,set nand retry reg
static int readretry_handle_toshiba(struct hw_controller *controller, unsigned char chipnr)
{
	struct amlnand_chip *aml_chip = controller->aml_chip;
	struct nand_flash *flash = &(aml_chip->flash);	
	struct read_retry_info *retry_info =  &(controller->retry_info);
	int cur_cnt, ret = 0;

	//if(flash->new_type != TOSHIBA_2XNM)
	//	return NAND_SUCCESS;
	
	cur_cnt = retry_info->cur_cnt_lp[chipnr];

	aml_nand_dbg("flash->new_type:%d, cur_cnt:%d", flash->new_type, cur_cnt);

	ret = set_reg_value_toshiba(controller, &retry_info->reg_offs_val_lp[0][cur_cnt][0],
								&retry_info->reg_addr_lp[0], chipnr, retry_info->reg_cnt_lp);
	if(ret){
		aml_nand_msg("set_reg_value_toshiba failed chipnr:%d", chipnr);
		return -NAND_FAILED;
	}

	cur_cnt++;
	retry_info->cur_cnt_lp[chipnr] = (cur_cnt > (retry_info->retry_cnt_lp -1)) ? 0 : cur_cnt;
	
	return NAND_SUCCESS;
}

static int  readretry_exit_toshiba(struct hw_controller *controller, unsigned char chipnr)
{
	struct amlnand_chip *aml_chip = controller->aml_chip;
	struct nand_flash *flash = &(aml_chip->flash);	
	struct read_retry_info *retry_info =  &(controller->retry_info);
	struct chip_operation *operation = &(aml_chip->operation);
	int cur_cnt, ret = 0,i;
	uint8_t buf[5] = {0};
	//if(flash->new_type != TOSHIBA_2XNM)
	//	return NAND_SUCCESS;
		
	ret = controller->quene_rb(controller, chipnr);
	if(ret){
		aml_nand_msg("quene rb failed chipnr:%d", chipnr);
		return -NAND_FAILED;
	}
	
	aml_nand_dbg("toshiba reatry exit");
	memset(&retry_info->cur_cnt_lp[0], 0, MAX_CHIP_NUM);

	if(flash->new_type != TOSHIBA_A19NM){
		
		for (i=0; i<retry_info->reg_cnt_lp; i++){
			controller->cmd_ctrl(controller, NAND_CMD_TOSHIBA_SET_VALUE, NAND_CTRL_CLE);
			 NFC_SEND_CMD_IDLE(controller->chip_selected, 2);
		        controller->cmd_ctrl(controller, retry_info->reg_addr_lp[i], NAND_CTRL_ALE);
			 NFC_SEND_CMD_IDLE(controller->chip_selected, 2);
			controller->writebyte(controller, buf[i]);
			 NFC_SEND_CMD_IDLE(controller->chip_selected, 2);
			aml_nand_dbg("REG(0x%x): 	value:0x%x, for chip[%d]\n", retry_info->reg_addr_lp[i], buf[i], chipnr);
		}
	}
	ret = operation->reset(aml_chip, chipnr);
	if(ret < 0){
		aml_nand_msg("reset nand failed chipnr:%d", chipnr);		
		return -NAND_FAILED;
	}

	return NAND_SUCCESS;	
}


//for samsung
/*******************************************SUMSUNG*********************************************/
static int set_reg_value_samsung(struct hw_controller *controller,  unsigned char *buf, unsigned char *addr, 
						unsigned char chipnr, unsigned char cnt)
{
	struct amlnand_chip *aml_chip = controller->aml_chip;
	struct nand_flash *flash = &(aml_chip->flash);	
	struct read_retry_info *retry_info =  &(controller->retry_info);
	int i, ret = 0;


	if(flash->new_type != SUMSUNG_2XNM)
		return NAND_SUCCESS;

	aml_nand_dbg("flash->new_type:%d", flash->new_type);

	ret = controller->quene_rb(controller, chipnr);
	if(ret){
		aml_nand_msg("quene rb failed chipnr:%d", chipnr);
		return -NAND_FAILED;
	}

	for (i=0; i<cnt; i++){
		controller->cmd_ctrl(controller, NAND_CMD_SAMSUNG_SET_VALUE, NAND_CTRL_CLE);
		 NFC_SEND_CMD_IDLE(controller->chip_selected, 2);
	        controller->cmd_ctrl(controller, 0, NAND_CTRL_ALE);
		 NFC_SEND_CMD_IDLE(controller->chip_selected, 0);
	        controller->cmd_ctrl(controller, addr[i], NAND_CTRL_ALE);
		 NFC_SEND_CMD_IDLE(controller->chip_selected, 0);
		controller->writebyte(controller, buf[i]);
		 NFC_SEND_CMD_IDLE(controller->chip_selected, 20);
		aml_nand_dbg("REG(0x%x): 	value:0x%x, for chip[%d]\n", addr[i], buf[i], chipnr);
	}
	
	ret = controller->quene_rb(controller, chipnr);
	if(ret){
		aml_nand_msg("quene rb failed chipnr:%d", chipnr);
		return -NAND_FAILED;
	}

	return NAND_SUCCESS;
}

static int readretry_handle_samsung(struct hw_controller *controller, unsigned char chipnr)
{
	struct amlnand_chip *aml_chip = controller->aml_chip;
	struct nand_flash *flash = &(aml_chip->flash);	
	struct read_retry_info *retry_info =  &(controller->retry_info);
	int cur_cnt, ret = 0;

	if(flash->new_type != SUMSUNG_2XNM)
		return NAND_SUCCESS;
	
	cur_cnt = retry_info->cur_cnt_lp[chipnr];

	aml_nand_dbg("flash->new_type:%d, cur_cnt:%d", flash->new_type, cur_cnt);

	ret = set_reg_value_samsung(controller, &retry_info->reg_offs_val_lp[0][cur_cnt][0], \
								&retry_info->reg_addr_lp[0], chipnr, retry_info->reg_cnt_lp);
	if(ret){
		aml_nand_msg("set_reg_value_samsung failed chipnr:%d", chipnr);
		return -NAND_FAILED;
	}

	cur_cnt++;
	retry_info->cur_cnt_lp[chipnr] = (cur_cnt > (retry_info->retry_cnt_lp -1)) ? 0 : cur_cnt;
	
	return NAND_SUCCESS;
}

static int  readretry_exit_samsung(struct hw_controller *controller, unsigned char chipnr)
{
	struct amlnand_chip *aml_chip = controller->aml_chip;
	struct nand_flash *flash = &(aml_chip->flash);	
	struct read_retry_info *retry_info =  &(controller->retry_info);
	struct chip_operation *operation = &(aml_chip->operation);
	int cur_cnt, ret = 0;

	if(flash->new_type != SUMSUNG_2XNM)
		return NAND_SUCCESS;
		
	ret = controller->quene_rb(controller, chipnr);
	if(ret){
		aml_nand_msg("quene rb failed chipnr:%d", chipnr);
		return -NAND_FAILED;
	}
	
	aml_nand_dbg("samsung reatry exit");
	memset(&retry_info->cur_cnt_lp[0], 0, MAX_CHIP_NUM);
	
	ret = set_reg_value_samsung(controller, &retry_info->reg_offs_val_lp[0][0][0], \
								&retry_info->reg_addr_lp[0], chipnr, retry_info->reg_cnt_lp);
	if(ret){
		aml_nand_msg("set_reg_value_samsung failed chipnr:%d", chipnr);
		return -NAND_FAILED;
	}

	return NAND_SUCCESS;	
}


/***********************************MICRON************************************/
static int set_reg_value_micron(struct hw_controller *controller,  unsigned char *buf, unsigned char *addr, 
						unsigned char chipnr, unsigned char cnt)
{
	struct amlnand_chip *aml_chip = controller->aml_chip;
	struct nand_flash *flash = &(aml_chip->flash);	
	struct read_retry_info *retry_info =  &(controller->retry_info);
	int i, ret = 0;


	if(flash->new_type != MICRON_20NM)
		return NAND_SUCCESS;

	aml_nand_dbg("flash->new_type:%d", flash->new_type);

	ret = controller->quene_rb(controller, chipnr);
	if(ret){
		aml_nand_msg("quene rb failed chipnr:%d", chipnr);
		return -NAND_FAILED;
	}

	for (i=0; i<cnt; i++){
		controller->cmd_ctrl(controller, NAND_CMD_MICRON_SET_VALUE, NAND_CTRL_CLE);
		 NFC_SEND_CMD_IDLE(controller->chip_selected, 2);
	         controller->cmd_ctrl(controller, addr[i], NAND_CTRL_ALE);
		NFC_SEND_CMD_IDLE(controller->chip_selected, 10);
		controller->writebyte(controller, buf[i]);
		NFC_SEND_CMD_IDLE(controller->chip_selected, 1);
		controller->writebyte(controller, 0);
		NFC_SEND_CMD_IDLE(controller->chip_selected, 1);
		controller->writebyte(controller, 0);
		NFC_SEND_CMD_IDLE(controller->chip_selected, 1);
		controller->writebyte(controller, 0);
		NFC_SEND_CMD_IDLE(controller->chip_selected, 100);
		aml_nand_dbg("REG(0x%x)  value:0x%x, for chip[%d]\n", addr[i], buf[i], chipnr);
	}
	
	ret = controller->quene_rb(controller, chipnr);
	if(ret){
		aml_nand_msg("quene rb failed chipnr:%d", chipnr);
		return -NAND_FAILED;
	}

	return NAND_SUCCESS;
}

static int readretry_handle_micron(struct hw_controller *controller, unsigned char chipnr)
{
	struct amlnand_chip *aml_chip = controller->aml_chip;
	struct nand_flash *flash = &(aml_chip->flash);	
	struct read_retry_info *retry_info =  &(controller->retry_info);
	int cur_cnt, ret = 0;

	if(flash->new_type != MICRON_20NM)
		return NAND_SUCCESS;
	
	cur_cnt = retry_info->cur_cnt_lp[chipnr];

	aml_nand_dbg("flash->new_type:%d, cur_cnt:%d", flash->new_type, cur_cnt);

	ret = set_reg_value_micron(controller, &retry_info->reg_offs_val_lp[0][cur_cnt][0], \
								&retry_info->reg_addr_lp[0], chipnr, retry_info->reg_cnt_lp);
	if(ret){
		aml_nand_msg("set_reg_value_samsung failed chipnr:%d", chipnr);
		return -NAND_FAILED;
	}

	cur_cnt++;
	retry_info->cur_cnt_lp[chipnr] = (cur_cnt > (retry_info->retry_cnt_lp -1)) ? 0 : cur_cnt;
	
	return NAND_SUCCESS;

}

static int  readretry_exit_micron(struct hw_controller *controller, unsigned char chipnr)
{
	struct amlnand_chip *aml_chip = controller->aml_chip;
	struct nand_flash *flash = &(aml_chip->flash);	
	struct read_retry_info *retry_info =  &(controller->retry_info);
	struct chip_operation *operation = &(aml_chip->operation);
	int cur_cnt, ret = 0;

	if(flash->new_type != MICRON_20NM)
		return NAND_SUCCESS;
		
	ret = controller->quene_rb(controller, chipnr);
	if(ret){
		aml_nand_msg("quene rb failed chipnr:%d", chipnr);
		return -NAND_FAILED;
	}
	
	aml_nand_dbg("micron reatry exit");
	memset(&retry_info->cur_cnt_lp[0], 0, MAX_CHIP_NUM);
	
	ret = set_reg_value_micron(controller, &retry_info->reg_def_val[0][0], &retry_info->reg_addr_lp[0], \
								chipnr, retry_info->reg_cnt_lp);
	if(ret){
		aml_nand_msg("set_reg_value_samsung failed chipnr:%d", chipnr);
		return -NAND_FAILED;
	}	

	return NAND_SUCCESS;	
}
/**************************INTEL***************************************/
static int readretry_handle_intel(struct hw_controller *controller, unsigned char chipnr)
{
	struct amlnand_chip *aml_chip = controller->aml_chip;
	struct nand_flash *flash = &(aml_chip->flash);	
	struct read_retry_info *retry_info =  &(controller->retry_info);
	int cur_cnt, ret = 0;
	int advance = 1;

	if(flash->new_type != INTEL_20NM)
		return NAND_SUCCESS;
	
	cur_cnt = retry_info->cur_cnt_lp[chipnr];
	aml_nand_dbg("flash->new_type:%d, cur_cnt:%d", flash->new_type, cur_cnt);
	
	if(cur_cnt == 3)
		ret = set_reg_value_micron(controller, (uint8_t *)&advance, \
								&retry_info->reg_addr_lp[1], chipnr, retry_info->reg_cnt_lp);
	if(ret){
		aml_nand_msg("set_reg_value_intel failed chipnr:%d", chipnr);
		return -NAND_FAILED;
	}	
	ret = set_reg_value_micron(controller, &retry_info->reg_offs_val_lp[0][cur_cnt][0], \ 
								&retry_info->reg_addr_lp[0], chipnr, retry_info->reg_cnt_lp);
	if(ret){
		aml_nand_msg("set_reg_value_intel failed chipnr:%d", chipnr);
		return -NAND_FAILED;
	}
	NFC_SEND_CMD_IDLE(controller->chip_selected, 10);	

	cur_cnt++;
	retry_info->cur_cnt_lp[chipnr] = (cur_cnt > (retry_info->retry_cnt_lp -1)) ? 0 : cur_cnt;

	return NAND_SUCCESS;
}

static int  readretry_exit_intel(struct hw_controller *controller, unsigned char chipnr)
{
	
	struct amlnand_chip *aml_chip = controller->aml_chip;
	struct nand_flash *flash = &(aml_chip->flash);	
	struct read_retry_info *retry_info =  &(controller->retry_info);
	struct chip_operation *operation = &(aml_chip->operation);
	int cur_cnt, ret = 0;

	if(flash->new_type != INTEL_20NM)
		return NAND_SUCCESS;
	ret = controller->quene_rb(controller, chipnr);
	if(ret){
		aml_nand_msg("quene rb failed chipnr:%d", chipnr);
		return -NAND_FAILED;
	}
	aml_nand_dbg("intel reatry exit");
	memset(&retry_info->cur_cnt_lp[0], 0, MAX_CHIP_NUM);
		ret = set_reg_value_micron(controller, &retry_info->reg_def_val[0][0], &retry_info->reg_addr_lp[0], \
								chipnr, retry_info->reg_cnt_lp);
	if(ret){
		aml_nand_msg("set_reg_value_intel failed chipnr:%d", chipnr);
		return -NAND_FAILED;
	}
	ret = set_reg_value_micron(controller, &retry_info->reg_def_val[0][0], &retry_info->reg_addr_lp[1], \
								chipnr, retry_info->reg_cnt_lp);
	if(ret){
		aml_nand_msg("set_reg_value_intel failed chipnr:%d", chipnr);
		return -NAND_FAILED;
	}
	return NAND_SUCCESS;
}
//for sandisk
/***********************************SANDISK************************************/
static int  readretry_init_sandisk(struct hw_controller *controller)
{
	struct amlnand_chip *aml_chip = controller->aml_chip;
	struct nand_flash *flash = &(aml_chip->flash);	
	struct read_retry_info *retry_info =  &(controller->retry_info);
	unsigned char reg_addr_init[10];
	int i, j, ret = 0;

	reg_addr_init[0] = 0x04;
	reg_addr_init[1] = 0x05;
	reg_addr_init[2] = 0x06;
	reg_addr_init[3] = 0x07;
	reg_addr_init[4] = 0x08;
	reg_addr_init[5] = 0x09;
	reg_addr_init[6] = 0x0a;
	reg_addr_init[7] = 0x0b;
	reg_addr_init[8] = 0x0c;

	//if(flash->new_type != SANDISK_19NM)
	//	return NAND_SUCCESS;

	//aml_nand_dbg("flash->new_type:%d", flash->new_type);

	for(i=0; i<controller->chip_num; i++){
		controller->cmd_ctrl(controller, NAND_CMD_SANDISK_INIT_ONE, NAND_CTRL_CLE);
		NFC_SEND_CMD_IDLE(controller->chip_selected, 2);
		controller->cmd_ctrl(controller, NAND_CMD_SANDISK_INIT_TWO, NAND_CTRL_CLE);
		NFC_SEND_CMD_IDLE(controller->chip_selected, 2);

		for(j=0; j<9; j++){
			controller->cmd_ctrl(controller, NAND_CMD_SANDISK_LOAD_VALUE_ONE, NAND_CTRL_CLE);   		//send cmd 0x53 
			NFC_SEND_CMD_IDLE(controller->chip_selected, 10);
			controller->cmd_ctrl(controller, reg_addr_init[j], NAND_CTRL_ALE);			//send 0x04 add
			NFC_SEND_CMD_IDLE(controller->chip_selected, 10);
			controller->writebyte(controller, 0x0);								//write 0x00 into  add
			NFC_SEND_CMD_IDLE(controller->chip_selected, 10);
		}		
	}
	
	return NAND_SUCCESS;
}

static int set_reg_value_sandisk(struct hw_controller *controller,  unsigned char *buf, unsigned char *addr, 
						unsigned char chipnr, unsigned char cnt)
{
	struct amlnand_chip *aml_chip = controller->aml_chip;
	struct nand_flash *flash = &(aml_chip->flash);	
	struct read_retry_info *retry_info =  &(controller->retry_info);
	int i, ret = 0;


	//if(flash->new_type != SANDISK_19NM)
	//	return NAND_SUCCESS;

	aml_nand_dbg("flash->new_type:%d", flash->new_type);

	ret = controller->quene_rb(controller, chipnr);
	if(ret){
		aml_nand_msg("quene rb failed chipnr:%d", chipnr);
		return -NAND_FAILED;
	}

	
	controller->cmd_ctrl(controller, NAND_CMD_SANDISK_INIT_ONE, NAND_CTRL_CLE);
	NFC_SEND_CMD_IDLE(controller->chip_selected, 2);
	controller->cmd_ctrl(controller, NAND_CMD_SANDISK_INIT_TWO, NAND_CTRL_CLE);
	NFC_SEND_CMD_IDLE(controller->chip_selected, 2);
	
	for (i=0; i<cnt; i++){
		controller->cmd_ctrl(controller, NAND_CMD_SANDISK_LOAD_VALUE_ONE, NAND_CTRL_CLE);
		NFC_SEND_CMD_IDLE(controller->chip_selected, 10);
	        controller->cmd_ctrl(controller, addr[i], NAND_CTRL_ALE);
		NFC_SEND_CMD_IDLE(controller->chip_selected, 10);
		controller->writebyte(controller, buf[i]);
		NFC_SEND_CMD_IDLE(controller->chip_selected, 10);
		aml_nand_dbg("REG(0x%x)  value:0x%x, for chip[%d]\n", addr[i], buf[i], chipnr);
	}

	controller->cmd_ctrl(controller, NAND_CMD_SANDISK_DYNAMIC_ENABLE, NAND_CTRL_CLE);
	NFC_SEND_CMD_IDLE(controller->chip_selected, 10);
	
	ret = controller->quene_rb(controller, chipnr);
	if(ret){
		aml_nand_msg("quene rb failed chipnr:%d", chipnr);
		return -NAND_FAILED;
	}

	return NAND_SUCCESS;
}

static int set_a19_reg_value_sandisk(struct hw_controller *controller,  unsigned char *buf, unsigned char addr, 
						unsigned char chipnr, unsigned char cnt)
{
	struct amlnand_chip *aml_chip = controller->aml_chip;
	struct nand_flash *flash = &(aml_chip->flash);	
	struct read_retry_info *retry_info =  &(controller->retry_info);
	int i, ret = 0;


	//if(flash->new_type != SANDISK_19NM)
	//	return NAND_SUCCESS;

	aml_nand_dbg("flash->new_type:%d", flash->new_type);

	ret = controller->quene_rb(controller, chipnr);
	if(ret){
		aml_nand_msg("quene rb failed chipnr:%d", chipnr);
		return -NAND_FAILED;
	}

	
	controller->cmd_ctrl(controller, NAND_CMD_SANDISK_SET_VALUE, NAND_CTRL_CLE);
	NFC_SEND_CMD_IDLE(controller->chip_selected, 2);
	
	controller->cmd_ctrl(controller, addr, NAND_CTRL_ALE);
	NFC_SEND_CMD_IDLE(controller->chip_selected, 10);
	
	for (i=0; i<cnt; i++){

		controller->writebyte(controller, buf[i]);
		NFC_SEND_CMD_IDLE(controller->chip_selected, 10);
		aml_nand_dbg("REG(0x%x)  value:0x%x, for chip[%d]\n", addr, buf[i], chipnr);
	}

	ret = controller->quene_rb(controller, chipnr);
	if(ret){
		aml_nand_msg("quene rb failed chipnr:%d", chipnr);
		return -NAND_FAILED;
	}

	return NAND_SUCCESS;
}

static int readretry_handle_a19_sandisk(struct hw_controller *controller, unsigned char chipnr)
{
	struct amlnand_chip *aml_chip = controller->aml_chip;
	struct nand_flash *flash = &(aml_chip->flash);	
	struct read_retry_info *retry_info =  &(controller->retry_info);
	unsigned pages_per_blk, tmp_page, pages_per_blk_shift;
	int cur_cnt,  ret = 0;
	int page_info = 0;
	//if(flash->new_type != SANDISK_19NM)
	//	return NAND_SUCCESS;
	
	aml_nand_dbg("flash->new_type:%d, controller->page_addr:%d", flash->new_type, controller->page_addr);

	pages_per_blk = flash->blocksize/flash->pagesize;
	pages_per_blk_shift =  (controller->block_shift - controller->page_shift);	
	
	tmp_page = controller->page_addr % (1 << pages_per_blk_shift);
	if(((tmp_page !=0) && (tmp_page % 2 ) == 0) || (tmp_page == (pages_per_blk -1)))
		page_info =  1;

	cur_cnt = retry_info->cur_cnt_up[chipnr];
	set_a19_reg_value_sandisk(controller, &retry_info->reg_offs_val_lp[page_info][cur_cnt][0], retry_info->reg_addr_lp[0], \
									chipnr, retry_info->reg_cnt_lp);
	controller->cmd_ctrl(controller, NAND_CMD_SANDISK_DSP_OFF, NAND_CTRL_CLE);
	NFC_SEND_CMD_IDLE(controller->chip_selected, 5);
	if(flash->new_type != SANDISK_A19NM){
		controller->cmd_ctrl(controller, NAND_CMD_SANDISK_DSP_ON, NAND_CTRL_CLE);
		NFC_SEND_CMD_IDLE(controller->chip_selected, 5);
	}
	controller->cmd_ctrl(controller, NAND_CMD_SANDISK_RETRY_STA, NAND_CTRL_CLE);
	NFC_SEND_CMD_IDLE(controller->chip_selected, 5);
	
	cur_cnt++;
	retry_info->cur_cnt_up[chipnr] = (cur_cnt > (retry_info->retry_cnt_up -1)) ? 0 : cur_cnt;
		
	return NAND_SUCCESS;

}


static int  readretry_exit_a19_sandisk(struct hw_controller *controller, unsigned char chipnr)
{
	struct amlnand_chip *aml_chip = controller->aml_chip;
	struct nand_flash *flash = &(aml_chip->flash);	
	struct read_retry_info *retry_info =  &(controller->retry_info);
	struct chip_operation *operation = &(aml_chip->operation);
	int cur_cnt, ret = 0;
	uint8_t buf[4] = {0};
	//if(flash->new_type != SANDISK_19NM)
	//	return NAND_SUCCESS;
		
	ret = controller->quene_rb(controller, chipnr);
	if(ret){
		aml_nand_msg("quene rb failed chipnr:%d", chipnr);
		return -NAND_FAILED;
	}
	aml_nand_dbg("sandisk reatry exit");
	
	memset(&retry_info->cur_cnt_lp[0], 0, MAX_CHIP_NUM);
	
	set_a19_reg_value_sandisk(controller, buf, retry_info->reg_addr_lp[0], \
									chipnr, retry_info->reg_cnt_lp);
	ret = controller->quene_rb(controller, chipnr);
	if(ret){
		aml_nand_msg("quene rb failed chipnr:%d", chipnr);
		return -NAND_FAILED;
	}
	
	ret = operation->reset(aml_chip, chipnr);
	if(ret < 0){
		aml_nand_msg("reset nand failed chipnr:%d", chipnr);		
		return -NAND_FAILED;
	}

	return NAND_SUCCESS;	
}
static int readretry_handle_sandisk(struct hw_controller *controller, unsigned char chipnr)
{
	struct amlnand_chip *aml_chip = controller->aml_chip;
	struct nand_flash *flash = &(aml_chip->flash);	
	struct read_retry_info *retry_info =  &(controller->retry_info);
	unsigned pages_per_blk, tmp_page, pages_per_blk_shift;
	int cur_cnt,  ret = 0;

	//if(flash->new_type != SANDISK_19NM)
	//	return NAND_SUCCESS;
	
	aml_nand_dbg("flash->new_type:%d, controller->page_addr:%d", flash->new_type, controller->page_addr);

	pages_per_blk = flash->blocksize/flash->pagesize;
	pages_per_blk_shift =  (controller->block_shift - controller->page_shift);	
	
	tmp_page = controller->page_addr % (1 << pages_per_blk_shift);
	if(((tmp_page !=0) && (tmp_page % 2 ) == 0) || (tmp_page == (pages_per_blk -1))){  //for upper page
		
		cur_cnt = retry_info->cur_cnt_up[chipnr];
		
		aml_nand_dbg("upper page flash->new_type:%d, cur_case:%d", flash->new_type, cur_cnt);
		
		ret = set_reg_value_sandisk(controller, &retry_info->reg_offs_val_up[0][cur_cnt][0], &retry_info->reg_addr_up[0], \
									chipnr, retry_info->reg_cnt_up);
		if(ret){
			aml_nand_msg("set_reg_value_sandisk failed chipnr:%d", chipnr);
			return -NAND_FAILED;
		}
		
		cur_cnt++;
		retry_info->cur_cnt_up[chipnr] = (cur_cnt > (retry_info->retry_cnt_up -1)) ? 0 : cur_cnt;
	}
	else{ //for lower page
		cur_cnt = retry_info->cur_cnt_lp[chipnr];
		
		aml_nand_dbg("low page flash->new_type:%d, cur_case:%d", flash->new_type, cur_cnt);
		
		ret = set_reg_value_sandisk(controller, &retry_info->reg_offs_val_lp[0][cur_cnt][0], &retry_info->reg_addr_lp[0], chipnr, retry_info->reg_cnt_lp);
		if(ret){
			aml_nand_msg("set_reg_value_sandisk failed chipnr:%d", chipnr);
			return -NAND_FAILED;
		}
		
		cur_cnt++;
		retry_info->cur_cnt_lp[chipnr] = (cur_cnt > (retry_info->retry_cnt_lp -1)) ? 0 : cur_cnt;
	}
			
	return NAND_SUCCESS;

}


static int  readretry_exit_sandisk(struct hw_controller *controller, unsigned char chipnr)
{
	struct amlnand_chip *aml_chip = controller->aml_chip;
	struct nand_flash *flash = &(aml_chip->flash);	
	struct read_retry_info *retry_info =  &(controller->retry_info);
	struct chip_operation *operation = &(aml_chip->operation);
	int cur_cnt, ret = 0;

	//if(flash->new_type != SANDISK_19NM)
	//	return NAND_SUCCESS;
		
	ret = controller->quene_rb(controller, chipnr);
	if(ret){
		aml_nand_msg("quene rb failed chipnr:%d", chipnr);
		return -NAND_FAILED;
	}
	aml_nand_dbg("sandisk reatry exit");
	
	memset(&retry_info->cur_cnt_lp[0], 0, MAX_CHIP_NUM);
	memset(&retry_info->cur_cnt_up[0], 0, MAX_CHIP_NUM);

	controller->cmd_ctrl(controller, NAND_CMD_SANDISK_DYNAMIC_DISABLE, NAND_CTRL_CLE);
	NFC_SEND_CMD_IDLE(controller->chip_selected, 2);

	ret = retry_info->init(controller);
	if (ret){
		aml_nand_msg("sandisk reatry exit failed");
		return -NAND_FAILED;
	}
	
	ret = controller->quene_rb(controller, chipnr);
	if(ret){
		aml_nand_msg("quene rb failed chipnr:%d", chipnr);
		return -NAND_FAILED;
	}
	
	ret = operation->reset(aml_chip, chipnr);
	if(ret < 0){
		aml_nand_msg("reset nand failed chipnr:%d", chipnr);		
		return -NAND_FAILED;
	}

	return NAND_SUCCESS;	
}

static int enslc_enter_sandisk(struct hw_controller *controller)
{
	struct amlnand_chip *aml_chip = controller->aml_chip;
	struct nand_flash *flash = &(aml_chip->flash);	
	struct en_slc_info *slc_info =  &(controller->slc_info);
	int i;

	//if(flash->new_type != SANDISK_19NM)
	//	return NAND_SUCCESS;
	
	//aml_nand_dbg("flash->new_type:%d", flash->new_type);
	
	controller->cmd_ctrl(controller, NAND_CMD_SANDISK_SLC, NAND_CTRL_CLE);

	return NAND_SUCCESS;
}


/***********************************END************************************/

/*
  * new nand read retry and enslc configuration.
  * based on nand type setting para.
  * 
  */
 int amlnand_set_readretry_slc_para(struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &(aml_chip->controller);
	struct nand_flash *flash = &(aml_chip->flash);	
	struct read_retry_info *retry_info = &(controller->retry_info);
	struct en_slc_info *slc_info = &(controller->slc_info);
	int ret = 0;

	if(flash->new_type == 0){
		aml_nand_msg("new type equals to zero");
		return NAND_SUCCESS;
	}

	switch(flash->new_type){
		case HYNIX_26NM_4GB:	//hynix 26nm 4GB
			retry_info->flag = 1;
			retry_info->reg_cnt_lp = 4;
			retry_info->retry_cnt_lp = 6;
			
			retry_info->reg_addr_lp[0] = 0xA7;	//not same
			retry_info->reg_addr_lp[1] = 0xAD;
			retry_info->reg_addr_lp[2] = 0xAE;
			retry_info->reg_addr_lp[3] = 0xAF;
			
			retry_info->reg_offs_val_lp[0][0][0] = 0;
			retry_info->reg_offs_val_lp[0][0][1] = 0x06;
			retry_info->reg_offs_val_lp[0][0][2] = 0x0A;
			retry_info->reg_offs_val_lp[0][0][3] = 0x06;
			
			retry_info->reg_offs_val_lp[0][1][0] = READ_RETRY_ZERO;
			retry_info->reg_offs_val_lp[0][1][1] = -0x03;
			retry_info->reg_offs_val_lp[0][1][2] = -0x07;
			retry_info->reg_offs_val_lp[0][1][3] = -0x08;
			
			retry_info->reg_offs_val_lp[0][2][0] = READ_RETRY_ZERO;
			retry_info->reg_offs_val_lp[0][2][1] = -0x06;
			retry_info->reg_offs_val_lp[0][2][2] = -0x0D;
			retry_info->reg_offs_val_lp[0][2][3] = -0x0F;
			
			retry_info->reg_offs_val_lp[0][3][0] = READ_RETRY_ZERO;
			retry_info->reg_offs_val_lp[0][3][1] = -0x09;	//not same
			retry_info->reg_offs_val_lp[0][3][2] = -0x14;
			retry_info->reg_offs_val_lp[0][3][3] = -0x17;
			
			retry_info->reg_offs_val_lp[0][4][0] = READ_RETRY_ZERO;
			retry_info->reg_offs_val_lp[0][4][1] = READ_RETRY_ZERO;
			retry_info->reg_offs_val_lp[0][4][2] = -0x1A;
			retry_info->reg_offs_val_lp[0][4][3] = -0x1E;
			
			retry_info->reg_offs_val_lp[0][5][0] = READ_RETRY_ZERO;
			retry_info->reg_offs_val_lp[0][5][1] = READ_RETRY_ZERO;
			retry_info->reg_offs_val_lp[0][5][2] = -0x20;
			retry_info->reg_offs_val_lp[0][5][3] = -0x25;

			retry_info->init = readretry_init_hynix;
			retry_info->exit = readretry_set_def_val_hynix;
			retry_info->handle = readretry_handle_hynix;

			//slc program
			slc_info->flag = 1;			
			slc_info->reg_cnt = 5;
			
			slc_info->reg_addr[0] = 0xA0;		//not same
			slc_info->reg_addr[1] = 0xA1;
			slc_info->reg_addr[2] = 0xB0;
			slc_info->reg_addr[3] = 0xB1;
			slc_info->reg_addr[4] = 0xC9;
			
			slc_info->reg_offs_val[0] = 0x26;		//not same
			slc_info->reg_offs_val[1] = 0x26;
			slc_info->reg_offs_val[2] = 0x26;
			slc_info->reg_offs_val[3] = 0x26;
			slc_info->reg_offs_val[4] = 0x01;
			
			slc_info->init = enslc_init_hynix;	
			slc_info->enter = enslc_enter_hynix;
			slc_info->exit = enslc_exit_hynix;
			slc_info->pagelist = &pagelist_hynix256;
			break;
			
		case HYNIX_26NM_8GB:	//hynix 26nm 8GB
			//read retry
			retry_info->flag = 1;
			retry_info->reg_cnt_lp = 4;
			retry_info->retry_cnt_lp = 6;

			retry_info->reg_addr_lp[0] = 0xAC;
			retry_info->reg_addr_lp[1] = 0xAD;
			retry_info->reg_addr_lp[2] = 0xAE;
			retry_info->reg_addr_lp[3] = 0xAF;

			retry_info->reg_offs_val_lp[0][0][0] = 0;
			retry_info->reg_offs_val_lp[0][0][1] = 0x06;
			retry_info->reg_offs_val_lp[0][0][2] = 0x0A;
			retry_info->reg_offs_val_lp[0][0][3] = 0x06;

			retry_info->reg_offs_val_lp[0][1][0] = READ_RETRY_ZERO;
			retry_info->reg_offs_val_lp[0][1][1] = -0x03;
			retry_info->reg_offs_val_lp[0][1][2] = -0x07;
			retry_info->reg_offs_val_lp[0][1][3] = -0x08;

			retry_info->reg_offs_val_lp[0][2][0] = READ_RETRY_ZERO;
			retry_info->reg_offs_val_lp[0][2][1] = -0x06;
			retry_info->reg_offs_val_lp[0][2][2] = -0x0D;
			retry_info->reg_offs_val_lp[0][2][3] = -0x0F;

			retry_info->reg_offs_val_lp[0][3][0] = READ_RETRY_ZERO;
			retry_info->reg_offs_val_lp[0][3][1] = -0x0B;
			retry_info->reg_offs_val_lp[0][3][2] = -0x14;
			retry_info->reg_offs_val_lp[0][3][3] = -0x17;

			retry_info->reg_offs_val_lp[0][4][0] = READ_RETRY_ZERO;
			retry_info->reg_offs_val_lp[0][4][1] = READ_RETRY_ZERO;
			retry_info->reg_offs_val_lp[0][4][2] = -0x1A;
			retry_info->reg_offs_val_lp[0][4][3] = -0x1E;

			retry_info->reg_offs_val_lp[0][5][0] = READ_RETRY_ZERO;
			retry_info->reg_offs_val_lp[0][5][1] = READ_RETRY_ZERO;
			retry_info->reg_offs_val_lp[0][5][2] = -0x20;
			retry_info->reg_offs_val_lp[0][5][3] = -0x25;		

			retry_info->init = readretry_init_hynix;
			retry_info->exit = readretry_set_def_val_hynix;
			retry_info->handle = readretry_handle_hynix;

			//slc program
			slc_info->flag = 1;			
			slc_info->reg_cnt = 5;
			
			slc_info->reg_addr[0] = 0xA4;   //not same
			slc_info->reg_addr[1] = 0xA5;
			slc_info->reg_addr[2] = 0xB0;
			slc_info->reg_addr[3] = 0xB1;
			slc_info->reg_addr[4] = 0xC9;
			
			slc_info->reg_offs_val[0] = 0x25;  //not same
			slc_info->reg_offs_val[1] = 0x25;
			slc_info->reg_offs_val[2] = 0x25;
			slc_info->reg_offs_val[3] = 0x25;
			slc_info->reg_offs_val[4] = 0x01;
			
			slc_info->init = enslc_init_hynix;	
			slc_info->enter = enslc_enter_hynix;
			slc_info->exit = enslc_exit_hynix;
			slc_info->pagelist = &pagelist_hynix256;

			break;
			
		case HYNIX_20NM_4GB:	//hynix 20nm 8GB
			//read retry			
			retry_info->flag = 1;
			retry_info->reg_cnt_lp = 8;
			retry_info->retry_cnt_lp = 7;
			
			retry_info->reg_addr_lp[0] = 0xB0;	//not same
			retry_info->reg_addr_lp[1] = 0xB1;
			retry_info->reg_addr_lp[2] = 0xB2;
			retry_info->reg_addr_lp[3] = 0xB3;
			retry_info->reg_addr_lp[4] = 0xB4;
			retry_info->reg_addr_lp[5] = 0xB5;
			retry_info->reg_addr_lp[6] = 0xB6;
			retry_info->reg_addr_lp[7] = 0xB7;

			//for offset value need read from otp area
			
			retry_info->init = readretry_init_hynix;
			retry_info->exit = readretry_set_def_val_hynix;
			retry_info->handle = readretry_handle_hynix;

 			//for slc
			slc_info->flag = 1;			
			slc_info->reg_cnt = 4;
			
			slc_info->reg_addr[0] = 0xA0;		//not same
			slc_info->reg_addr[1] = 0xA1;
			slc_info->reg_addr[2] = 0xA7;
			slc_info->reg_addr[3] = 0xA8;
			
			slc_info->reg_offs_val[0] = 0x0A;		//not same
			slc_info->reg_offs_val[1] = 0x0A;
			slc_info->reg_offs_val[2] = 0x0A;
			slc_info->reg_offs_val[3] = 0x0A;
			
			slc_info->init = enslc_init_hynix;	
			slc_info->enter = enslc_enter_hynix;
			slc_info->exit = enslc_exit_hynix;
			slc_info->pagelist = &pagelist_hynix256;
			break;

		case HYNIX_20NM_8GB:	//hynix 20nm 8GB
			//read retry	
			retry_info->flag = 1;
			retry_info->reg_cnt_lp = 8;
			retry_info->retry_cnt_lp = 7;
			
			retry_info->reg_addr_lp[0] = 0xCC;	//not same
			retry_info->reg_addr_lp[1] = 0xBF;
			retry_info->reg_addr_lp[2] = 0xAA;
			retry_info->reg_addr_lp[3] = 0xAB;
			retry_info->reg_addr_lp[4] = 0xCD;	//not same
			retry_info->reg_addr_lp[5] = 0xAD;
			retry_info->reg_addr_lp[6] = 0xAE;
			retry_info->reg_addr_lp[7] = 0xAF;

			//for offset value need read from otp area
			
			retry_info->init = readretry_init_hynix;
			retry_info->exit = readretry_set_def_val_hynix;
			retry_info->handle = readretry_handle_hynix;

			//for slc
			slc_info->flag = 1;			
			slc_info->reg_cnt = 4;
			
			slc_info->reg_addr[0] = 0xB0;		//not same
			slc_info->reg_addr[1] = 0xB1;
			slc_info->reg_addr[2] = 0xA0;
			slc_info->reg_addr[3] = 0xA1;
			
			slc_info->reg_offs_val[0] = 0x0A;		//not same
			slc_info->reg_offs_val[1] = 0x0A;
			slc_info->reg_offs_val[2] = 0x0A;
			slc_info->reg_offs_val[3] = 0x0A;
			
			slc_info->init = enslc_init_hynix;	
			slc_info->enter = enslc_enter_hynix;
			slc_info->exit = enslc_exit_hynix;
			slc_info->pagelist = &pagelist_hynix256;
			break;
			
		case HYNIX_1YNM_8GB:	//hynix 20nm 8GB
			retry_info->flag = 1;
			retry_info->reg_cnt_lp = 4;
			retry_info->retry_cnt_lp = 7;
			retry_info->reg_addr_lp[0] = 0x38;	//not same
			retry_info->reg_addr_lp[1] = 0x39;
			retry_info->reg_addr_lp[2] = 0x3A;
			retry_info->reg_addr_lp[3] = 0x3B;
			retry_info->init = readretry_init_hynix;
			retry_info->exit = readretry_set_def_val_hynix;
			retry_info->handle = readretry_handle_hynix;
			slc_info->init = enslc_init_hynix;	
			slc_info->enter = enslc_enter_hynix;
			slc_info->exit = enslc_exit_hynix;
			slc_info->pagelist = &pagelist_1ynm_hynix256;
			break;			
			case TOSHIBA_2XNM:	//toshiba 24nm/19nm TOSHIBA_2XNM
				//read retry
			retry_info->flag = 1;
			retry_info->reg_cnt_lp = 4;
			retry_info->retry_cnt_lp = 6;

			retry_info->reg_addr_lp[0] = 0x04;
			retry_info->reg_addr_lp[1] = 0x05;
			retry_info->reg_addr_lp[2] = 0x06;
			retry_info->reg_addr_lp[3] = 0x07;
			
			retry_info->reg_offs_val_lp[0][0][0] = 0;
			retry_info->reg_offs_val_lp[0][0][1] = 0;
			retry_info->reg_offs_val_lp[0][0][2] = 0;
			retry_info->reg_offs_val_lp[0][0][3] = 0;
			
			retry_info->reg_offs_val_lp[0][1][0] = 0x04;
			retry_info->reg_offs_val_lp[0][1][1] = 0x04;
			retry_info->reg_offs_val_lp[0][1][2] = 0x04;
			retry_info->reg_offs_val_lp[0][1][3] = 0x04;
			
			retry_info->reg_offs_val_lp[0][2][0] = 0x7c;
			retry_info->reg_offs_val_lp[0][2][1] = 0x7c;
			retry_info->reg_offs_val_lp[0][2][2] = 0x7c;
			retry_info->reg_offs_val_lp[0][2][3] = 0x7c;
			
			retry_info->reg_offs_val_lp[0][3][0] = 0x78;
			retry_info->reg_offs_val_lp[0][3][1] = 0x78;
			retry_info->reg_offs_val_lp[0][3][2] = 0x78;
			retry_info->reg_offs_val_lp[0][3][3] = 0x78;
			
			retry_info->reg_offs_val_lp[0][4][0] = 0x74;
			retry_info->reg_offs_val_lp[0][4][1] = 0x74;
			retry_info->reg_offs_val_lp[0][4][2] = 0x74;
			retry_info->reg_offs_val_lp[0][4][3] = 0x74;
			
			retry_info->reg_offs_val_lp[0][5][0] = 0x08;
			retry_info->reg_offs_val_lp[0][5][1] = 0x08;
			retry_info->reg_offs_val_lp[0][5][2] = 0x08;
			retry_info->reg_offs_val_lp[0][5][3] = 0x08;
			
			retry_info->handle = readretry_handle_toshiba;
			retry_info->exit = readretry_exit_toshiba;
			break;

			case TOSHIBA_A19NM:	//toshiba 24nm/19nm TOSHIBA_2XNM
				//read retry
			retry_info->flag = 1;
			retry_info->reg_cnt_lp = 5;
			retry_info->retry_cnt_lp = 7;

			retry_info->reg_addr_lp[0] = 0x04;
			retry_info->reg_addr_lp[1] = 0x05;
			retry_info->reg_addr_lp[2] = 0x06;
			retry_info->reg_addr_lp[3] = 0x07;
			retry_info->reg_addr_lp[3] = 0x0D;
			
			retry_info->reg_offs_val_lp[0][0][0] = 0;
			retry_info->reg_offs_val_lp[0][0][1] = 0;
			retry_info->reg_offs_val_lp[0][0][2] = 0;
			retry_info->reg_offs_val_lp[0][0][3] = 0;
			retry_info->reg_offs_val_lp[0][0][4] = 0;
			
			retry_info->reg_offs_val_lp[0][1][0] = 0x04;
			retry_info->reg_offs_val_lp[0][1][1] = 0x04;
			retry_info->reg_offs_val_lp[0][1][2] = 0x04;
			retry_info->reg_offs_val_lp[0][1][3] = 0x04;
			retry_info->reg_offs_val_lp[0][1][4] = 0x00;
			
			retry_info->reg_offs_val_lp[0][2][0] = 0x7c;
			retry_info->reg_offs_val_lp[0][2][1] = 0x7c;
			retry_info->reg_offs_val_lp[0][2][2] = 0x7c;
			retry_info->reg_offs_val_lp[0][2][3] = 0x7c;
			retry_info->reg_offs_val_lp[0][2][4] = 0x00;
			
			retry_info->reg_offs_val_lp[0][3][0] = 0x78;
			retry_info->reg_offs_val_lp[0][3][1] = 0x78;
			retry_info->reg_offs_val_lp[0][3][2] = 0x78;
			retry_info->reg_offs_val_lp[0][3][3] = 0x78;
			retry_info->reg_offs_val_lp[0][3][4] = 0x00;
			
			retry_info->reg_offs_val_lp[0][4][0] = 0x74;
			retry_info->reg_offs_val_lp[0][4][1] = 0x74;
			retry_info->reg_offs_val_lp[0][4][2] = 0x74;
			retry_info->reg_offs_val_lp[0][4][3] = 0x74;
			retry_info->reg_offs_val_lp[0][4][4] = 0x00;
			
			retry_info->reg_offs_val_lp[0][5][0] = 0x08;
			retry_info->reg_offs_val_lp[0][5][1] = 0x08;
			retry_info->reg_offs_val_lp[0][5][2] = 0x08;
			retry_info->reg_offs_val_lp[0][5][3] = 0x08;
			retry_info->reg_offs_val_lp[0][5][4] = 0x00;
            
			retry_info->reg_offs_val_lp[0][6][0] = 0x78;
			retry_info->reg_offs_val_lp[0][6][1] = 0x78;
			retry_info->reg_offs_val_lp[0][6][2] = 0x78;
			retry_info->reg_offs_val_lp[0][6][3] = 0x78;
			retry_info->reg_offs_val_lp[0][6][4] = 0x00;
			retry_info->handle = readretry_handle_toshiba;
			retry_info->exit = readretry_exit_toshiba;
			break;
			
		case SUMSUNG_2XNM:	
				//read retry
			retry_info->flag = 1;			
			retry_info->reg_cnt_lp = 4;
			retry_info->retry_cnt_lp = 15;
			
			retry_info->reg_addr_lp[0] = 0xA7;
			retry_info->reg_addr_lp[1] = 0xA4;
			retry_info->reg_addr_lp[2] = 0xA5;
			retry_info->reg_addr_lp[3] = 0xA6;
			
			retry_info->reg_offs_val_lp[0][0][0] = 0;
			retry_info->reg_offs_val_lp[0][0][1] = 0;
			retry_info->reg_offs_val_lp[0][0][2] = 0;
			retry_info->reg_offs_val_lp[0][0][3] = 0;
			
			retry_info->reg_offs_val_lp[0][1][0] = 0x05;
			retry_info->reg_offs_val_lp[0][1][1] = 0x0A;
			retry_info->reg_offs_val_lp[0][1][2] = 0x00;
			retry_info->reg_offs_val_lp[0][1][3] = 0x00;
			
			retry_info->reg_offs_val_lp[0][2][0] = 0x28;
			retry_info->reg_offs_val_lp[0][2][1] = 0x00;
			retry_info->reg_offs_val_lp[0][2][2] = 0xEc;
			retry_info->reg_offs_val_lp[0][2][3] = 0xD8;
			
			retry_info->reg_offs_val_lp[0][3][0] = 0xED;
			retry_info->reg_offs_val_lp[0][3][1] = 0xF5;
			retry_info->reg_offs_val_lp[0][3][2] = 0xED;
			retry_info->reg_offs_val_lp[0][3][3] = 0xE6;
			
			retry_info->reg_offs_val_lp[0][4][0] = 0x0A;
			retry_info->reg_offs_val_lp[0][4][1] = 0x0F;
			retry_info->reg_offs_val_lp[0][4][2] = 0x05;
			retry_info->reg_offs_val_lp[0][4][3] = 0x00;
			
			retry_info->reg_offs_val_lp[0][5][0] = 0x0F;
			retry_info->reg_offs_val_lp[0][5][1] = 0x0A;
			retry_info->reg_offs_val_lp[0][5][2] = 0xFB;
			retry_info->reg_offs_val_lp[0][5][3] = 0xEC;
			
			retry_info->reg_offs_val_lp[0][6][0] = 0XE8;
			retry_info->reg_offs_val_lp[0][6][1] = 0XEF;
			retry_info->reg_offs_val_lp[0][6][2] = 0XE8;
			retry_info->reg_offs_val_lp[0][6][3] = 0XDC;
			
			retry_info->reg_offs_val_lp[0][7][0] = 0xF1;
			retry_info->reg_offs_val_lp[0][7][1] = 0xFB;
			retry_info->reg_offs_val_lp[0][7][2] = 0xFE;
			retry_info->reg_offs_val_lp[0][7][3] = 0xF0;
			
			retry_info->reg_offs_val_lp[0][8][0] = 0x0A;
			retry_info->reg_offs_val_lp[0][8][1] = 0x00;
			retry_info->reg_offs_val_lp[0][8][2] = 0xFB;
			retry_info->reg_offs_val_lp[0][8][3] = 0xEC;
			
			retry_info->reg_offs_val_lp[0][9][0] = 0xD0;
			retry_info->reg_offs_val_lp[0][9][1] = 0xE2;
			retry_info->reg_offs_val_lp[0][9][2] = 0xD0;
			retry_info->reg_offs_val_lp[0][9][3] = 0xC2;
			
			retry_info->reg_offs_val_lp[0][10][0] = 0x14;
			retry_info->reg_offs_val_lp[0][10][1] = 0x0F;
			retry_info->reg_offs_val_lp[0][10][2] = 0xFB;
			retry_info->reg_offs_val_lp[0][10][3] = 0xEC;
			
			retry_info->reg_offs_val_lp[0][11][0] = 0xE8;
			retry_info->reg_offs_val_lp[0][11][1] = 0xFB;
			retry_info->reg_offs_val_lp[0][11][2] = 0xE8;
			retry_info->reg_offs_val_lp[0][11][3] = 0xDC;
			
			retry_info->reg_offs_val_lp[0][12][0] = 0X1E;
			retry_info->reg_offs_val_lp[0][12][1] = 0X14;
			retry_info->reg_offs_val_lp[0][12][2] = 0XFB;
			retry_info->reg_offs_val_lp[0][12][3] = 0XEC;
			
			retry_info->reg_offs_val_lp[0][13][0] = 0xFB;
			retry_info->reg_offs_val_lp[0][13][1] = 0xFF;
			retry_info->reg_offs_val_lp[0][13][2] = 0xFB;
			retry_info->reg_offs_val_lp[0][13][3] = 0xF8;
			
			retry_info->reg_offs_val_lp[0][14][0] = 0x07;
			retry_info->reg_offs_val_lp[0][14][1] = 0x0C;
			retry_info->reg_offs_val_lp[0][14][2] = 0x02;
			retry_info->reg_offs_val_lp[0][14][3] = 0x00;
			
			retry_info->handle = readretry_handle_samsung;
			retry_info->exit = readretry_exit_samsung;
			break;

		case SANDISK_19NM:
			//read retry low page
			retry_info->flag = 1;			
			retry_info->reg_cnt_lp = 2;
			retry_info->retry_cnt_lp = 16;
			
			retry_info->reg_addr_lp[0] = 0x04;		
			retry_info->reg_addr_lp[1] = 0x07;

			retry_info->reg_offs_val_lp[0][0][0] = 0xF0;
			retry_info->reg_offs_val_lp[0][0][1] = 0xF0;
			
			retry_info->reg_offs_val_lp[0][1][0] = 0xE0;
			retry_info->reg_offs_val_lp[0][1][1] = 0xE0;
			
			retry_info->reg_offs_val_lp[0][2][0] = 0xD0;
			retry_info->reg_offs_val_lp[0][2][1] = 0xD0;
			
			retry_info->reg_offs_val_lp[0][3][0] = 0x10;
			retry_info->reg_offs_val_lp[0][3][1] = 0x10;
			
			retry_info->reg_offs_val_lp[0][4][0] = 0x20;
			retry_info->reg_offs_val_lp[0][4][1] = 0x20;
			
			retry_info->reg_offs_val_lp[0][5][0] = 0x30;
			retry_info->reg_offs_val_lp[0][5][1] = 0x30;
			
			retry_info->reg_offs_val_lp[0][6][0] = 0xC0;
			retry_info->reg_offs_val_lp[0][6][1] = 0xD0;
			
			retry_info->reg_offs_val_lp[0][7][0] = 0x0;
			retry_info->reg_offs_val_lp[0][7][1] = 0x10;
			
			retry_info->reg_offs_val_lp[0][8][0] = 0x0;
			retry_info->reg_offs_val_lp[0][8][1] = 0x20;
			
			retry_info->reg_offs_val_lp[0][9][0] = 0x10;
			retry_info->reg_offs_val_lp[0][9][1] = 0x20;
			
			retry_info->reg_offs_val_lp[0][10][0] = 0xB0;
			retry_info->reg_offs_val_lp[0][10][1] = 0xD0;
			
			retry_info->reg_offs_val_lp[0][11][0] = 0xA0;
			retry_info->reg_offs_val_lp[0][11][1] = 0xD0;
			
			retry_info->reg_offs_val_lp[0][12][0] = 0x90;
			retry_info->reg_offs_val_lp[0][12][1] = 0xD0;
			
			retry_info->reg_offs_val_lp[0][13][0] = 0xB0;
			retry_info->reg_offs_val_lp[0][13][1] = 0xC0;
			
			retry_info->reg_offs_val_lp[0][14][0] = 0xA0;
			retry_info->reg_offs_val_lp[0][14][1] = 0xC0;
			
			retry_info->reg_offs_val_lp[0][15][0] = 0x90;
			retry_info->reg_offs_val_lp[0][15][1] = 0xC0;

			//read retry up page
			retry_info->reg_cnt_up = 2;
			retry_info->retry_cnt_up = 20;
			
			retry_info->reg_addr_up[0] = 0x04;
			retry_info->reg_addr_up[1] = 0x05;

			retry_info->reg_offs_val_up[0][0][0] = 0x0;
			retry_info->reg_offs_val_up[0][0][1] = 0xF0;
			
			retry_info->reg_offs_val_up[0][1][0] = 0xF;
			retry_info->reg_offs_val_up[0][1][1] = 0xE0;
			
			retry_info->reg_offs_val_up[0][2][0] = 0xF;
			retry_info->reg_offs_val_up[0][2][1] = 0xD0;
			
			retry_info->reg_offs_val_up[0][3][0] = 0xE;
			retry_info->reg_offs_val_up[0][3][1] = 0xE0;
			
			retry_info->reg_offs_val_up[0][4][0] = 0xE;
			retry_info->reg_offs_val_up[0][4][1] = 0xD0;
			
			retry_info->reg_offs_val_up[0][5][0] = 0xD;
			retry_info->reg_offs_val_up[0][5][1] = 0xF0;
			
			retry_info->reg_offs_val_up[0][6][0] = 0xD;
			retry_info->reg_offs_val_up[0][6][1] = 0xE0;
			
			retry_info->reg_offs_val_up[0][7][0] = 0xD;
			retry_info->reg_offs_val_up[0][7][1] = 0xD0;
			
			retry_info->reg_offs_val_up[0][8][0] = 0x1;
			retry_info->reg_offs_val_up[0][8][1] = 0x10;
			
			retry_info->reg_offs_val_up[0][9][0] = 0x2;
			retry_info->reg_offs_val_up[0][9][1] = 0x20;
			
			retry_info->reg_offs_val_up[0][10][0] = 0x2;
			retry_info->reg_offs_val_up[0][10][1] = 0x10;
			
			retry_info->reg_offs_val_up[0][11][0] = 0x3;
			retry_info->reg_offs_val_up[0][11][1] = 0x20;
			
			retry_info->reg_offs_val_up[0][12][0] = 0xF;
			retry_info->reg_offs_val_up[0][12][1] = 0x00;
			
			retry_info->reg_offs_val_up[0][13][0] = 0xE;
			retry_info->reg_offs_val_up[0][13][1] = 0xF0;
			
			retry_info->reg_offs_val_up[0][14][0] = 0xD;
			retry_info->reg_offs_val_up[0][14][1] = 0xC0;
			
			retry_info->reg_offs_val_up[0][15][0] = 0xF;
			retry_info->reg_offs_val_up[0][15][1] = 0xF0;
			
			retry_info->reg_offs_val_up[0][16][0] = 0x1;
			retry_info->reg_offs_val_up[0][16][1] = 0x00;
			
			retry_info->reg_offs_val_up[0][17][0] = 0x20;
			retry_info->reg_offs_val_up[0][17][1] = 0x00;
			
			retry_info->reg_offs_val_up[0][18][0] = 0xD;
			retry_info->reg_offs_val_up[0][18][1] = 0xB0;
			
			retry_info->reg_offs_val_up[0][19][0] = 0xC;
			retry_info->reg_offs_val_up[0][19][1] = 0xA0;
			
			retry_info->init = readretry_init_sandisk;
			retry_info->handle = readretry_handle_sandisk;
			retry_info->exit = readretry_exit_sandisk;

			//slc
			slc_info->enter= enslc_enter_sandisk;
			
			break;

	case SANDISK_A19NM:
			//read retry low page
			retry_info->flag = 1;			
			retry_info->reg_cnt_lp = 4;
			retry_info->retry_cnt_lp = 29;
			
			retry_info->reg_addr_lp[0] = 0x11;		
			
	////////////lower page read //////////////////////////////
	
			retry_info->reg_offs_val_lp[0][0][0] = 0x7c;
			retry_info->reg_offs_val_lp[0][0][1] = 0x00;
			retry_info->reg_offs_val_lp[0][0][2] = 0x7c;
			retry_info->reg_offs_val_lp[0][0][3] = 0x00;
			
			retry_info->reg_offs_val_lp[0][1][0] = 0x04;
			retry_info->reg_offs_val_lp[0][1][1] = 0x00;
			retry_info->reg_offs_val_lp[0][1][2] = 0x04;
			retry_info->reg_offs_val_lp[0][1][3] = 0x00;
			
			retry_info->reg_offs_val_lp[0][2][0] = 0x78;
			retry_info->reg_offs_val_lp[0][2][1] = 0x00;
			retry_info->reg_offs_val_lp[0][2][2] = 0x78;
			retry_info->reg_offs_val_lp[0][2][3] = 0x00;
			
			retry_info->reg_offs_val_lp[0][3][0] = 0x08;
			retry_info->reg_offs_val_lp[0][3][1] = 0x00;
			retry_info->reg_offs_val_lp[0][3][2] = 0x08;
			retry_info->reg_offs_val_lp[0][3][3] = 0x00;
			
			retry_info->reg_offs_val_lp[0][4][0] = 0x00;
			retry_info->reg_offs_val_lp[0][4][1] = 0x00;
			retry_info->reg_offs_val_lp[0][4][2] = 0x00;
			retry_info->reg_offs_val_lp[0][4][3] = 0x00;
			
			retry_info->reg_offs_val_lp[0][5][0] = 0x7c;
			retry_info->reg_offs_val_lp[0][5][1] = 0x00;
			retry_info->reg_offs_val_lp[0][5][2] = 0x7c;
			retry_info->reg_offs_val_lp[0][5][3] = 0x00;
			
			retry_info->reg_offs_val_lp[0][6][0] = 0x04;
			retry_info->reg_offs_val_lp[0][6][1] = 0x00;
			retry_info->reg_offs_val_lp[0][6][2] = 0x04;
			retry_info->reg_offs_val_lp[0][6][3] = 0x00;
			
			retry_info->reg_offs_val_lp[0][7][0] = 0x00;
			retry_info->reg_offs_val_lp[0][7][1] = 0x00;
			retry_info->reg_offs_val_lp[0][7][2] = 0x78;
			retry_info->reg_offs_val_lp[0][7][3] = 0x00;
			
			retry_info->reg_offs_val_lp[0][8][0] = 0x00;
			retry_info->reg_offs_val_lp[0][8][1] = 0x00;
			retry_info->reg_offs_val_lp[0][8][2] = 0x74;
			retry_info->reg_offs_val_lp[0][8][3] = 0x00;
			
			retry_info->reg_offs_val_lp[0][9][0] = 0x00;
			retry_info->reg_offs_val_lp[0][9][1] = 0x00;
			retry_info->reg_offs_val_lp[0][9][2] = 0x00;
			retry_info->reg_offs_val_lp[0][9][3] = 0x00;
			
			retry_info->reg_offs_val_lp[0][10][0] = 0x00;
			retry_info->reg_offs_val_lp[0][10][1] = 0x00;
			retry_info->reg_offs_val_lp[0][10][2] = 0x7c;
			retry_info->reg_offs_val_lp[0][10][3] = 0x00;
			
			retry_info->reg_offs_val_lp[0][11][0] = 0x00;
			retry_info->reg_offs_val_lp[0][11][1] = 0x00;
			retry_info->reg_offs_val_lp[0][11][2] = 0x78;
			retry_info->reg_offs_val_lp[0][11][3] = 0x00;
			
			retry_info->reg_offs_val_lp[0][12][0] = 0x00;
			retry_info->reg_offs_val_lp[0][12][1] = 0x00;
			retry_info->reg_offs_val_lp[0][12][2] = 0x74;
			retry_info->reg_offs_val_lp[0][12][3] = 0x00;
			
			retry_info->reg_offs_val_lp[0][13][0] = 0x00;
			retry_info->reg_offs_val_lp[0][13][1] = 0x00;
			retry_info->reg_offs_val_lp[0][13][2] = 0x70;
			retry_info->reg_offs_val_lp[0][13][3] = 0x00;
			
			retry_info->reg_offs_val_lp[0][14][0] = 0x00;
			retry_info->reg_offs_val_lp[0][14][1] = 0x00;
			retry_info->reg_offs_val_lp[0][14][2] = 0x00;
			retry_info->reg_offs_val_lp[0][14][3] = 0x00;
			
			retry_info->reg_offs_val_lp[0][15][0] = 0x00;
			retry_info->reg_offs_val_lp[0][15][1] = 0x00;
			retry_info->reg_offs_val_lp[0][15][2] = 0x7c;
			retry_info->reg_offs_val_lp[0][15][3] = 0x00;
			
			retry_info->reg_offs_val_lp[0][16][0] = 0x10;
			retry_info->reg_offs_val_lp[0][16][1] = 0x00;
			retry_info->reg_offs_val_lp[0][16][2] = 0x04;
			retry_info->reg_offs_val_lp[0][16][3] = 0x00;
			
			retry_info->reg_offs_val_lp[0][17][0] = 0x7c;
			retry_info->reg_offs_val_lp[0][17][1] = 0x00;
			retry_info->reg_offs_val_lp[0][17][2] = 0x7c;
			retry_info->reg_offs_val_lp[0][17][3] = 0x00;

			retry_info->reg_offs_val_lp[0][18][0] = 0x78;
			retry_info->reg_offs_val_lp[0][18][1] = 0x00;
			retry_info->reg_offs_val_lp[0][18][2] = 0x78;
			retry_info->reg_offs_val_lp[0][18][3] = 0x00;
			
			retry_info->reg_offs_val_lp[0][19][0] = 0x78;
			retry_info->reg_offs_val_lp[0][19][1] = 0x00;
			retry_info->reg_offs_val_lp[0][19][2] = 0x74;
			retry_info->reg_offs_val_lp[0][19][3] = 0x00;
			
			retry_info->reg_offs_val_lp[0][20][0] = 0x78;
			retry_info->reg_offs_val_lp[0][20][1] = 0x00;
			retry_info->reg_offs_val_lp[0][20][2] = 0x70;
			retry_info->reg_offs_val_lp[0][20][3] = 0x00;
			
			retry_info->reg_offs_val_lp[0][21][0] = 0x78;
			retry_info->reg_offs_val_lp[0][21][1] = 0x00;
			retry_info->reg_offs_val_lp[0][21][2] = 0x6c;
			retry_info->reg_offs_val_lp[0][21][3] = 0x00;
			
			retry_info->reg_offs_val_lp[0][22][0] = 0x78;
			retry_info->reg_offs_val_lp[0][22][1] = 0x00;
			retry_info->reg_offs_val_lp[0][22][2] = 0x78;
			retry_info->reg_offs_val_lp[0][22][3] = 0x00;
			
			retry_info->reg_offs_val_lp[0][23][0] = 0x78;
			retry_info->reg_offs_val_lp[0][23][1] = 0x00;
			retry_info->reg_offs_val_lp[0][23][2] = 0x74;
			retry_info->reg_offs_val_lp[0][23][3] = 0x00;
			
			retry_info->reg_offs_val_lp[0][24][0] = 0x78;
			retry_info->reg_offs_val_lp[0][24][1] = 0x00;
			retry_info->reg_offs_val_lp[0][24][2] = 0x70;
			retry_info->reg_offs_val_lp[0][24][3] = 0x00;
			
			retry_info->reg_offs_val_lp[0][25][0] = 0x78;
			retry_info->reg_offs_val_lp[0][25][1] = 0x00;
			retry_info->reg_offs_val_lp[0][25][2] = 0x6c;
			retry_info->reg_offs_val_lp[0][25][3] = 0x00;
			
			retry_info->reg_offs_val_lp[0][26][0] = 0x78;
			retry_info->reg_offs_val_lp[0][26][1] = 0x00;
			retry_info->reg_offs_val_lp[0][26][2] = 0x74;
			retry_info->reg_offs_val_lp[0][26][3] = 0x00;
			
			retry_info->reg_offs_val_lp[0][27][0] = 0x78;
			retry_info->reg_offs_val_lp[0][27][1] = 0x00;
			retry_info->reg_offs_val_lp[0][27][2] = 0x70;
			retry_info->reg_offs_val_lp[0][27][3] = 0x00;
			
			retry_info->reg_offs_val_lp[0][28][0] = 0x78;
			retry_info->reg_offs_val_lp[0][28][1] = 0x00;
			retry_info->reg_offs_val_lp[0][28][2] = 0x6c;
			retry_info->reg_offs_val_lp[0][28][3] = 0x00;

////////////upper page read //////////////////////////////
	
			retry_info->reg_offs_val_lp[1][0][0] = 0x00;
			retry_info->reg_offs_val_lp[1][0][1] = 0x00;
			retry_info->reg_offs_val_lp[1][0][2] = 0x00;
			retry_info->reg_offs_val_lp[1][0][3] = 0x7c;
			
			retry_info->reg_offs_val_lp[1][1][0] = 0x00;
			retry_info->reg_offs_val_lp[1][1][1] = 0x00;
			retry_info->reg_offs_val_lp[1][1][2] = 0x00;
			retry_info->reg_offs_val_lp[1][1][3] = 0x04;
			
			retry_info->reg_offs_val_lp[1][2][0] = 0x00;
			retry_info->reg_offs_val_lp[1][2][1] = 0x00;
			retry_info->reg_offs_val_lp[1][2][2] = 0x00;
			retry_info->reg_offs_val_lp[1][2][3] = 0x78;
			
			retry_info->reg_offs_val_lp[1][3][0] = 0x00;
			retry_info->reg_offs_val_lp[1][3][1] = 0x00;
			retry_info->reg_offs_val_lp[1][3][2] = 0x00;
			retry_info->reg_offs_val_lp[1][3][3] = 0x08;
			
			retry_info->reg_offs_val_lp[1][4][0] = 0x00;
			retry_info->reg_offs_val_lp[1][4][1] = 0x7c;
			retry_info->reg_offs_val_lp[1][4][2] = 0x00;
			retry_info->reg_offs_val_lp[1][4][3] = 0x00;
			
			retry_info->reg_offs_val_lp[1][5][0] = 0x00;
			retry_info->reg_offs_val_lp[1][5][1] = 0x7c;
			retry_info->reg_offs_val_lp[1][5][2] = 0x00;
			retry_info->reg_offs_val_lp[1][5][3] = 0x7c;
			
			retry_info->reg_offs_val_lp[1][6][0] = 0x00;
			retry_info->reg_offs_val_lp[1][6][1] = 0x7c;
			retry_info->reg_offs_val_lp[1][6][2] = 0x00;
			retry_info->reg_offs_val_lp[1][6][3] = 0x04;
			
			retry_info->reg_offs_val_lp[1][7][0] = 0x00;
			retry_info->reg_offs_val_lp[1][7][1] = 0x7c;
			retry_info->reg_offs_val_lp[1][7][2] = 0x00;
			retry_info->reg_offs_val_lp[1][7][3] = 0x78;
			
			retry_info->reg_offs_val_lp[1][8][0] = 0x00;
			retry_info->reg_offs_val_lp[1][8][1] = 0x7c;
			retry_info->reg_offs_val_lp[1][8][2] = 0x00;
			retry_info->reg_offs_val_lp[1][8][3] = 0x74;
			
			retry_info->reg_offs_val_lp[1][9][0] = 0x00;
			retry_info->reg_offs_val_lp[1][9][1] = 0x78;
			retry_info->reg_offs_val_lp[1][9][2] = 0x00;
			retry_info->reg_offs_val_lp[1][9][3] = 0x00;
			
			retry_info->reg_offs_val_lp[1][10][0] = 0x00;
			retry_info->reg_offs_val_lp[1][10][1] = 0x78;
			retry_info->reg_offs_val_lp[1][10][2] = 0x00;
			retry_info->reg_offs_val_lp[1][10][3] = 0x7c;
			
			retry_info->reg_offs_val_lp[1][11][0] = 0x00;
			retry_info->reg_offs_val_lp[1][11][1] = 0x78;
			retry_info->reg_offs_val_lp[1][11][2] = 0x00;
			retry_info->reg_offs_val_lp[1][11][3] = 0x78;
			
			retry_info->reg_offs_val_lp[1][12][0] = 0x00;
			retry_info->reg_offs_val_lp[1][12][1] = 0x78;
			retry_info->reg_offs_val_lp[1][12][2] = 0x00;
			retry_info->reg_offs_val_lp[1][12][3] = 0x74;
			
			retry_info->reg_offs_val_lp[1][13][0] = 0x00;
			retry_info->reg_offs_val_lp[1][13][1] = 0x78;
			retry_info->reg_offs_val_lp[1][13][2] = 0x00;
			retry_info->reg_offs_val_lp[1][13][3] = 0x70;
			
			retry_info->reg_offs_val_lp[1][14][0] = 0x00;
			retry_info->reg_offs_val_lp[1][14][1] = 0x04;
			retry_info->reg_offs_val_lp[1][14][2] = 0x00;
			retry_info->reg_offs_val_lp[1][14][3] = 0x00;
			
			retry_info->reg_offs_val_lp[1][15][0] = 0x00;
			retry_info->reg_offs_val_lp[1][15][1] = 0x04;
			retry_info->reg_offs_val_lp[1][15][2] = 0x00;
			retry_info->reg_offs_val_lp[1][15][3] = 0x7c;
			
			retry_info->reg_offs_val_lp[1][16][0] = 0x00;
			retry_info->reg_offs_val_lp[1][16][1] = 0x04;
			retry_info->reg_offs_val_lp[1][16][2] = 0x00;
			retry_info->reg_offs_val_lp[1][16][3] = 0x04;
			
			retry_info->reg_offs_val_lp[1][17][0] = 0x00;
			retry_info->reg_offs_val_lp[1][17][1] = 0x74;
			retry_info->reg_offs_val_lp[1][17][2] = 0x00;
			retry_info->reg_offs_val_lp[1][17][3] = 0x7c;

			retry_info->reg_offs_val_lp[1][18][0] = 0x00;
			retry_info->reg_offs_val_lp[1][18][1] = 0x74;
			retry_info->reg_offs_val_lp[1][18][2] = 0x00;
			retry_info->reg_offs_val_lp[1][18][3] = 0x78;
			
			retry_info->reg_offs_val_lp[1][19][0] = 0x00;
			retry_info->reg_offs_val_lp[1][19][1] = 0x74;
			retry_info->reg_offs_val_lp[1][19][2] = 0x00;
			retry_info->reg_offs_val_lp[1][19][3] = 0x74;
			
			retry_info->reg_offs_val_lp[1][20][0] = 0x00;
			retry_info->reg_offs_val_lp[1][20][1] = 0x74;
			retry_info->reg_offs_val_lp[1][20][2] = 0x00;
			retry_info->reg_offs_val_lp[1][20][3] = 0x70;
			
			retry_info->reg_offs_val_lp[1][21][0] = 0x00;
			retry_info->reg_offs_val_lp[1][21][1] = 0x74;
			retry_info->reg_offs_val_lp[1][21][2] = 0x00;
			retry_info->reg_offs_val_lp[1][21][3] = 0x6c;
			
			retry_info->reg_offs_val_lp[1][22][0] = 0x00;
			retry_info->reg_offs_val_lp[1][22][1] = 0x70;
			retry_info->reg_offs_val_lp[1][22][2] = 0x00;
			retry_info->reg_offs_val_lp[1][22][3] = 0x78;
			
			retry_info->reg_offs_val_lp[1][23][0] = 0x00;
			retry_info->reg_offs_val_lp[1][23][1] = 0x70;
			retry_info->reg_offs_val_lp[1][23][2] = 0x00;
			retry_info->reg_offs_val_lp[1][23][3] = 0x74;
			
			retry_info->reg_offs_val_lp[1][24][0] = 0x00;
			retry_info->reg_offs_val_lp[1][24][1] = 0x70;
			retry_info->reg_offs_val_lp[1][24][2] = 0x00;
			retry_info->reg_offs_val_lp[1][24][3] = 0x70;
			
			retry_info->reg_offs_val_lp[1][25][0] = 0x00;
			retry_info->reg_offs_val_lp[1][25][1] = 0x70;
			retry_info->reg_offs_val_lp[1][25][2] = 0x00;
			retry_info->reg_offs_val_lp[1][25][3] = 0x6c;
			
			retry_info->reg_offs_val_lp[1][26][0] = 0x00;
			retry_info->reg_offs_val_lp[1][26][1] = 0x6c;
			retry_info->reg_offs_val_lp[1][26][2] = 0x00;
			retry_info->reg_offs_val_lp[1][26][3] = 0x74;
			
			retry_info->reg_offs_val_lp[1][27][0] = 0x00;
			retry_info->reg_offs_val_lp[1][27][1] = 0x6c;
			retry_info->reg_offs_val_lp[1][27][2] = 0x00;
			retry_info->reg_offs_val_lp[1][27][3] = 0x70;
			
			retry_info->reg_offs_val_lp[1][28][0] = 0x00;
			retry_info->reg_offs_val_lp[1][28][1] = 0x6c;
			retry_info->reg_offs_val_lp[1][28][2] = 0x00;
			retry_info->reg_offs_val_lp[1][28][3] = 0x6c;			
			
			retry_info->handle = readretry_handle_a19_sandisk;
			retry_info->exit = readretry_exit_a19_sandisk;

			//slc
		//	slc_info->enter= enslc_enter_sandisk;
			
			break;
	case SANDISK_A19NM_4G:
			//read retry low page
			retry_info->flag = 1;			
			retry_info->reg_cnt_lp = 4;
			retry_info->retry_cnt_lp = 30;
			
			retry_info->reg_addr_lp[0] = 0x11;		
			
	////////////lower page read //////////////////////////////
	
			retry_info->reg_offs_val_lp[0][0][0] = 0x7c;
			retry_info->reg_offs_val_lp[0][0][1] = 0x00;
			retry_info->reg_offs_val_lp[0][0][2] = 0x00;
			retry_info->reg_offs_val_lp[0][0][3] = 0x00;
			
			retry_info->reg_offs_val_lp[0][1][0] = 0x04;
			retry_info->reg_offs_val_lp[0][1][1] = 0x00;
			retry_info->reg_offs_val_lp[0][1][2] = 0x7C;
			retry_info->reg_offs_val_lp[0][1][3] = 0x00;
			
			retry_info->reg_offs_val_lp[0][2][0] = 0x78;
			retry_info->reg_offs_val_lp[0][2][1] = 0x00;
			retry_info->reg_offs_val_lp[0][2][2] = 0x78;
			retry_info->reg_offs_val_lp[0][2][3] = 0x00;
			
			retry_info->reg_offs_val_lp[0][3][0] = 0x08;
			retry_info->reg_offs_val_lp[0][3][1] = 0x00;
			retry_info->reg_offs_val_lp[0][3][2] = 0x00;
			retry_info->reg_offs_val_lp[0][3][3] = 0x00;
			
			retry_info->reg_offs_val_lp[0][4][0] = 0x00;
			retry_info->reg_offs_val_lp[0][4][1] = 0x00;
			retry_info->reg_offs_val_lp[0][4][2] = 0x7C;
			retry_info->reg_offs_val_lp[0][4][3] = 0x00;
			
			retry_info->reg_offs_val_lp[0][5][0] = 0x7c;
			retry_info->reg_offs_val_lp[0][5][1] = 0x00;
			retry_info->reg_offs_val_lp[0][5][2] = 0x78;
			retry_info->reg_offs_val_lp[0][5][3] = 0x00;
			
			retry_info->reg_offs_val_lp[0][6][0] = 0x00;
			retry_info->reg_offs_val_lp[0][6][1] = 0x00;
			retry_info->reg_offs_val_lp[0][6][2] = 0x74;
			retry_info->reg_offs_val_lp[0][6][3] = 0x00;
			
			retry_info->reg_offs_val_lp[0][7][0] = 0x00;
			retry_info->reg_offs_val_lp[0][7][1] = 0x00;
			retry_info->reg_offs_val_lp[0][7][2] = 0x00;
			retry_info->reg_offs_val_lp[0][7][3] = 0x00;
			                                       
			retry_info->reg_offs_val_lp[0][8][0] = 0x00;
			retry_info->reg_offs_val_lp[0][8][1] = 0x00;
			retry_info->reg_offs_val_lp[0][8][2] = 0x7C;
			retry_info->reg_offs_val_lp[0][8][3] = 0x00;
			                                       
			retry_info->reg_offs_val_lp[0][9][0] = 0x00;
			retry_info->reg_offs_val_lp[0][9][1] = 0x00;
			retry_info->reg_offs_val_lp[0][9][2] = 0x78;
			retry_info->reg_offs_val_lp[0][9][3] = 0x00;
			
			retry_info->reg_offs_val_lp[0][10][0] = 0x00;
			retry_info->reg_offs_val_lp[0][10][1] = 0x00;
			retry_info->reg_offs_val_lp[0][10][2] = 0x74;
			retry_info->reg_offs_val_lp[0][10][3] = 0x00;
			                                        
			retry_info->reg_offs_val_lp[0][11][0] = 0x00;
			retry_info->reg_offs_val_lp[0][11][1] = 0x00;
			retry_info->reg_offs_val_lp[0][11][2] = 0x70;
			retry_info->reg_offs_val_lp[0][11][3] = 0x00;
			                                        
			retry_info->reg_offs_val_lp[0][12][0] = 0x00;
			retry_info->reg_offs_val_lp[0][12][1] = 0x00;
			retry_info->reg_offs_val_lp[0][12][2] = 0x04;
			retry_info->reg_offs_val_lp[0][12][3] = 0x00;
			                                        
			retry_info->reg_offs_val_lp[0][13][0] = 0x00;
			retry_info->reg_offs_val_lp[0][13][1] = 0x00;
			retry_info->reg_offs_val_lp[0][13][2] = 0x00;
			retry_info->reg_offs_val_lp[0][13][3] = 0x00;
			                                        
			retry_info->reg_offs_val_lp[0][14][0] = 0x0C;
			retry_info->reg_offs_val_lp[0][14][1] = 0x00;
			retry_info->reg_offs_val_lp[0][14][2] = 0x7C;
			retry_info->reg_offs_val_lp[0][14][3] = 0x00;
			                                        
			retry_info->reg_offs_val_lp[0][15][0] = 0x0C;
			retry_info->reg_offs_val_lp[0][15][1] = 0x00;
			retry_info->reg_offs_val_lp[0][15][2] = 0x78;
			retry_info->reg_offs_val_lp[0][15][3] = 0x00;
			                                        
			retry_info->reg_offs_val_lp[0][16][0] = 0x10;
			retry_info->reg_offs_val_lp[0][16][1] = 0x00;
			retry_info->reg_offs_val_lp[0][16][2] = 0x00;
			retry_info->reg_offs_val_lp[0][16][3] = 0x00;
			
			retry_info->reg_offs_val_lp[0][17][0] = 0x10;
			retry_info->reg_offs_val_lp[0][17][1] = 0x00;
			retry_info->reg_offs_val_lp[0][17][2] = 0x04;
			retry_info->reg_offs_val_lp[0][17][3] = 0x00;
                                                    
			retry_info->reg_offs_val_lp[0][18][0] = 0x78;
			retry_info->reg_offs_val_lp[0][18][1] = 0x00;
			retry_info->reg_offs_val_lp[0][18][2] = 0x78;
			retry_info->reg_offs_val_lp[0][18][3] = 0x00;
			                                        
			retry_info->reg_offs_val_lp[0][19][0] = 0x78;
			retry_info->reg_offs_val_lp[0][19][1] = 0x00;
			retry_info->reg_offs_val_lp[0][19][2] = 0x74;
			retry_info->reg_offs_val_lp[0][19][3] = 0x00;
			
			retry_info->reg_offs_val_lp[0][20][0] = 0x78;
			retry_info->reg_offs_val_lp[0][20][1] = 0x00;
			retry_info->reg_offs_val_lp[0][20][2] = 0x70;
			retry_info->reg_offs_val_lp[0][20][3] = 0x00;
			                                        
			retry_info->reg_offs_val_lp[0][21][0] = 0x78;
			retry_info->reg_offs_val_lp[0][21][1] = 0x00;
			retry_info->reg_offs_val_lp[0][21][2] = 0x6c;
			retry_info->reg_offs_val_lp[0][21][3] = 0x00;
			                                        
			retry_info->reg_offs_val_lp[0][22][0] = 0x78;
			retry_info->reg_offs_val_lp[0][22][1] = 0x00;
			retry_info->reg_offs_val_lp[0][22][2] = 0x78;
			retry_info->reg_offs_val_lp[0][22][3] = 0x00;
			                                        
			retry_info->reg_offs_val_lp[0][23][0] = 0x78;
			retry_info->reg_offs_val_lp[0][23][1] = 0x00;
			retry_info->reg_offs_val_lp[0][23][2] = 0x74;
			retry_info->reg_offs_val_lp[0][23][3] = 0x00;
			                                        
			retry_info->reg_offs_val_lp[0][24][0] = 0x78;
			retry_info->reg_offs_val_lp[0][24][1] = 0x00;
			retry_info->reg_offs_val_lp[0][24][2] = 0x6C;
			retry_info->reg_offs_val_lp[0][24][3] = 0x00;
			                                        
			retry_info->reg_offs_val_lp[0][25][0] = 0x78;
			retry_info->reg_offs_val_lp[0][25][1] = 0x00;
			retry_info->reg_offs_val_lp[0][25][2] = 0x70;
			retry_info->reg_offs_val_lp[0][25][3] = 0x00;
			                                        
			retry_info->reg_offs_val_lp[0][26][0] = 0x78;
			retry_info->reg_offs_val_lp[0][26][1] = 0x00;
			retry_info->reg_offs_val_lp[0][26][2] = 0x70;
			retry_info->reg_offs_val_lp[0][26][3] = 0x00;
			                                        
			retry_info->reg_offs_val_lp[0][27][0] = 0x78;
			retry_info->reg_offs_val_lp[0][27][1] = 0x00;
			retry_info->reg_offs_val_lp[0][27][2] = 0x6c;
			retry_info->reg_offs_val_lp[0][27][3] = 0x00;
			                                        
			retry_info->reg_offs_val_lp[0][28][0] = 0x78;
			retry_info->reg_offs_val_lp[0][28][1] = 0x00;
			retry_info->reg_offs_val_lp[0][28][2] = 0x68;
			retry_info->reg_offs_val_lp[0][28][3] = 0x00;

			retry_info->reg_offs_val_lp[0][29][0] = 0x74;
			retry_info->reg_offs_val_lp[0][29][1] = 0x00;
			retry_info->reg_offs_val_lp[0][29][2] = 0x6c;
			retry_info->reg_offs_val_lp[0][29][3] = 0x00;
////////////upper page read //////////////////////////////
	
			retry_info->reg_offs_val_lp[1][0][0] = 0x00;
			retry_info->reg_offs_val_lp[1][0][1] = 0x00;
			retry_info->reg_offs_val_lp[1][0][2] = 0x00;
			retry_info->reg_offs_val_lp[1][0][3] = 0x7c;
			                                       
			retry_info->reg_offs_val_lp[1][1][0] = 0x00;
			retry_info->reg_offs_val_lp[1][1][1] = 0x00;
			retry_info->reg_offs_val_lp[1][1][2] = 0x00;
			retry_info->reg_offs_val_lp[1][1][3] = 0x78;
			                                       
			retry_info->reg_offs_val_lp[1][2][0] = 0x00;
			retry_info->reg_offs_val_lp[1][2][1] = 0x00;
			retry_info->reg_offs_val_lp[1][2][2] = 0x00;
			retry_info->reg_offs_val_lp[1][2][3] = 0x74;
			                                       
			retry_info->reg_offs_val_lp[1][3][0] = 0x00;
			retry_info->reg_offs_val_lp[1][3][1] = 0x7C;
			retry_info->reg_offs_val_lp[1][3][2] = 0x00;
			retry_info->reg_offs_val_lp[1][3][3] = 0x7c;
			                                       
			retry_info->reg_offs_val_lp[1][4][0] = 0x00;
			retry_info->reg_offs_val_lp[1][4][1] = 0x7c;
			retry_info->reg_offs_val_lp[1][4][2] = 0x00;
			retry_info->reg_offs_val_lp[1][4][3] = 0x78;
			                                       
			retry_info->reg_offs_val_lp[1][5][0] = 0x00;
			retry_info->reg_offs_val_lp[1][5][1] = 0x7c;
			retry_info->reg_offs_val_lp[1][5][2] = 0x00;
			retry_info->reg_offs_val_lp[1][5][3] = 0x74;
			                                       
			retry_info->reg_offs_val_lp[1][6][0] = 0x00;
			retry_info->reg_offs_val_lp[1][6][1] = 0x7c;
			retry_info->reg_offs_val_lp[1][6][2] = 0x00;
			retry_info->reg_offs_val_lp[1][6][3] = 0x70;
			                                       
			retry_info->reg_offs_val_lp[1][7][0] = 0x00;
			retry_info->reg_offs_val_lp[1][7][1] = 0x78;
			retry_info->reg_offs_val_lp[1][7][2] = 0x00;
			retry_info->reg_offs_val_lp[1][7][3] = 0x7c;
			                                       
			retry_info->reg_offs_val_lp[1][8][0] = 0x00;
			retry_info->reg_offs_val_lp[1][8][1] = 0x78;
			retry_info->reg_offs_val_lp[1][8][2] = 0x00;
			retry_info->reg_offs_val_lp[1][8][3] = 0x78;
			                                           
			retry_info->reg_offs_val_lp[1][9][0] = 0x00;
			retry_info->reg_offs_val_lp[1][9][1] = 0x78;
			retry_info->reg_offs_val_lp[1][9][2] = 0x00;
			retry_info->reg_offs_val_lp[1][9][3] = 0x74;
			
			retry_info->reg_offs_val_lp[1][10][0] = 0x00;
			retry_info->reg_offs_val_lp[1][10][1] = 0x78;
			retry_info->reg_offs_val_lp[1][10][2] = 0x00;
			retry_info->reg_offs_val_lp[1][10][3] = 0x70;
			                                            
			retry_info->reg_offs_val_lp[1][11][0] = 0x00;
			retry_info->reg_offs_val_lp[1][11][1] = 0x78;
			retry_info->reg_offs_val_lp[1][11][2] = 0x00;
			retry_info->reg_offs_val_lp[1][11][3] = 0x6c;
			                                            
			retry_info->reg_offs_val_lp[1][12][0] = 0x00;
			retry_info->reg_offs_val_lp[1][12][1] = 0x04;
			retry_info->reg_offs_val_lp[1][12][2] = 0x00;
			retry_info->reg_offs_val_lp[1][12][3] = 0x00;
			                                            
			retry_info->reg_offs_val_lp[1][13][0] = 0x00;
			retry_info->reg_offs_val_lp[1][13][1] = 0x04;
			retry_info->reg_offs_val_lp[1][13][2] = 0x00;
			retry_info->reg_offs_val_lp[1][13][3] = 0x7c;
			                                            
			retry_info->reg_offs_val_lp[1][14][0] = 0x00;
			retry_info->reg_offs_val_lp[1][14][1] = 0x04;
			retry_info->reg_offs_val_lp[1][14][2] = 0x00;
			retry_info->reg_offs_val_lp[1][14][3] = 0x78;
			                                        
			retry_info->reg_offs_val_lp[1][15][0] = 0x00;
			retry_info->reg_offs_val_lp[1][15][1] = 0x04;
			retry_info->reg_offs_val_lp[1][15][2] = 0x00;
			retry_info->reg_offs_val_lp[1][15][3] = 0x74;
			                                            
			retry_info->reg_offs_val_lp[1][16][0] = 0x00;
			retry_info->reg_offs_val_lp[1][16][1] = 0x08;
			retry_info->reg_offs_val_lp[1][16][2] = 0x00;
			retry_info->reg_offs_val_lp[1][16][3] = 0x7c;
			
			retry_info->reg_offs_val_lp[1][17][0] = 0x00;
			retry_info->reg_offs_val_lp[1][17][1] = 0x08;
			retry_info->reg_offs_val_lp[1][17][2] = 0x00;
			retry_info->reg_offs_val_lp[1][17][3] = 0x00;
                                                        
			retry_info->reg_offs_val_lp[1][18][0] = 0x00;
			retry_info->reg_offs_val_lp[1][18][1] = 0x74;
			retry_info->reg_offs_val_lp[1][18][2] = 0x00;
			retry_info->reg_offs_val_lp[1][18][3] = 0x74;
			                                            
			retry_info->reg_offs_val_lp[1][19][0] = 0x00;
			retry_info->reg_offs_val_lp[1][19][1] = 0x74;
			retry_info->reg_offs_val_lp[1][19][2] = 0x00;
			retry_info->reg_offs_val_lp[1][19][3] = 0x70;
			                                            
			retry_info->reg_offs_val_lp[1][20][0] = 0x00;
			retry_info->reg_offs_val_lp[1][20][1] = 0x74;
			retry_info->reg_offs_val_lp[1][20][2] = 0x00;
			retry_info->reg_offs_val_lp[1][20][3] = 0x6c;
			                                            
			retry_info->reg_offs_val_lp[1][21][0] = 0x00;
			retry_info->reg_offs_val_lp[1][21][1] = 0x74;
			retry_info->reg_offs_val_lp[1][21][2] = 0x00;
			retry_info->reg_offs_val_lp[1][21][3] = 0x68;
			                                        
			retry_info->reg_offs_val_lp[1][22][0] = 0x00;
			retry_info->reg_offs_val_lp[1][22][1] = 0x70;
			retry_info->reg_offs_val_lp[1][22][2] = 0x00;
			retry_info->reg_offs_val_lp[1][22][3] = 0x74;
			                                            
			retry_info->reg_offs_val_lp[1][23][0] = 0x00;
			retry_info->reg_offs_val_lp[1][23][1] = 0x70;
			retry_info->reg_offs_val_lp[1][23][2] = 0x00;
			retry_info->reg_offs_val_lp[1][23][3] = 0x70;
			                                            
			retry_info->reg_offs_val_lp[1][24][0] = 0x00;
			retry_info->reg_offs_val_lp[1][24][1] = 0x70;
			retry_info->reg_offs_val_lp[1][24][2] = 0x00;
			retry_info->reg_offs_val_lp[1][24][3] = 0x68;
			                                            
			retry_info->reg_offs_val_lp[1][25][0] = 0x00;
			retry_info->reg_offs_val_lp[1][25][1] = 0x70;
			retry_info->reg_offs_val_lp[1][25][2] = 0x00;
			retry_info->reg_offs_val_lp[1][25][3] = 0x6c;
			                                            
			retry_info->reg_offs_val_lp[1][26][0] = 0x00;
			retry_info->reg_offs_val_lp[1][26][1] = 0x6c;
			retry_info->reg_offs_val_lp[1][26][2] = 0x00;
			retry_info->reg_offs_val_lp[1][26][3] = 0x6c;
			                                            
			retry_info->reg_offs_val_lp[1][27][0] = 0x00;
			retry_info->reg_offs_val_lp[1][27][1] = 0x6c;
			retry_info->reg_offs_val_lp[1][27][2] = 0x00;
			retry_info->reg_offs_val_lp[1][27][3] = 0x68;
			                                            
			retry_info->reg_offs_val_lp[1][28][0] = 0x00;
			retry_info->reg_offs_val_lp[1][28][1] = 0x6c;
			retry_info->reg_offs_val_lp[1][28][2] = 0x00;
			retry_info->reg_offs_val_lp[1][28][3] = 0x64;	
			
			retry_info->reg_offs_val_lp[1][29][0] = 0x00;
			retry_info->reg_offs_val_lp[1][29][1] = 0x68;
			retry_info->reg_offs_val_lp[1][29][2] = 0x00;
			retry_info->reg_offs_val_lp[1][29][3] = 0x68;				
			
			retry_info->handle = readretry_handle_a19_sandisk;
			retry_info->exit = readretry_exit_a19_sandisk;

			//slc
		//	slc_info->enter= enslc_enter_sandisk;
			
			break;			
		case MICRON_20NM:
			retry_info->flag = 1;			
			retry_info->reg_cnt_lp = 1;
			retry_info->retry_cnt_lp = 7;

			retry_info->reg_addr_lp[0] = 0x89;
			
			retry_info->reg_def_val[0][0] = 0;
			retry_info->reg_def_val[0][1] = 0;
			retry_info->reg_def_val[0][2] = 0;
			retry_info->reg_def_val[0][3] = 0;
			retry_info->reg_def_val[0][4] = 0;
			retry_info->reg_def_val[0][5] = 0;
			retry_info->reg_def_val[0][6] = 0;
			
			retry_info->reg_offs_val_lp[0][0][0] = 0x1;
			retry_info->reg_offs_val_lp[0][1][0] = 0x2;
			retry_info->reg_offs_val_lp[0][2][0] = 0x3;
			retry_info->reg_offs_val_lp[0][3][0] = 0x4;
			retry_info->reg_offs_val_lp[0][4][0] = 0x5;
			retry_info->reg_offs_val_lp[0][5][0] = 0x6;
			retry_info->reg_offs_val_lp[0][6][0] = 0x7;

			retry_info->handle = readretry_handle_micron;
			retry_info->exit = readretry_exit_micron;
			break;
		case INTEL_20NM:
			retry_info->flag = 1;			
			retry_info->reg_cnt_lp = 2;
			retry_info->retry_cnt_lp = 7;

			retry_info->reg_addr_lp[0] = 0x89;
			retry_info->reg_addr_lp[0] = 0x93;
			
			retry_info->reg_def_val[0][0] = 0;
			retry_info->reg_def_val[0][1] = 0;
			retry_info->reg_def_val[0][2] = 0;
			retry_info->reg_def_val[0][3] = 0;
			retry_info->reg_def_val[0][4] = 0;
			retry_info->reg_def_val[0][5] = 0;
			retry_info->reg_def_val[0][6] = 0;
			
			retry_info->reg_offs_val_lp[0][0][0] = 0x1;
			retry_info->reg_offs_val_lp[0][1][0] = 0x2;
			retry_info->reg_offs_val_lp[0][2][0] = 0x3;
			retry_info->reg_offs_val_lp[0][3][0] = 0x0;
			retry_info->reg_offs_val_lp[0][4][0] = 0x1;
			retry_info->reg_offs_val_lp[0][5][0] = 0x2;
			retry_info->reg_offs_val_lp[0][6][0] = 0x3;

			retry_info->handle = readretry_handle_intel;
			retry_info->exit = readretry_exit_intel;
			break;
		default:
			aml_nand_msg("detect flash->new_type(%d) not support!", flash->new_type);
			return -NAND_FAILED;
	}

	if(flash->new_type == SANDISK_19NM){
		ret = retry_info->init(controller);
		if(ret){
			aml_nand_msg("sandisk readretry init failed");	
			return -NAND_FAILED;
		}
	}

	if((flash->new_type) && (flash->new_type < 10 )){
		ret = slc_info->init(controller);
		if(ret){
			aml_nand_msg("hynix nand get slc default value failed");
			return -NAND_FAILED;
		}
		ret =  retry_info->init(controller);
		if(ret){
			aml_nand_msg("hynix nand readretry init failed");
			return -NAND_FAILED;
		}
	}
	
	return NAND_SUCCESS;
}

