/*
 * Copyright 2008, Freescale Semiconductor, Inc
 * Andy Fleming
 *
 * Based vaguely on the Linux code
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
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */

#include <config.h>
#include <common.h>
#include <command.h>
#include <mmc.h>
#include <part.h>
#include <malloc.h>
#include <linux/list.h>
#include <mmc.h>
#include <div64.h>
#include <asm/arch/sdio.h>

#ifdef CONFIG_STORE_COMPATIBLE
#include <emmc_partitions.h>
#include <partition_table.h>
#endif

#include "emmc_key.h"

struct list_head mmc_devices;
static int cur_dev_num = -1;

#define MMC_RD_WR_MAX_BLK_NUM   (256)

extern void mdelay(unsigned long msec);

/* If reserve partition is protected, we should not access it.
 * 0--allow accessed 
 * 1--NOT allow accessed
 */
bool emmckey_is_protected (struct mmc *mmc)
{
#ifdef CONFIG_STORE_COMPATIBLE
	#ifdef CONFIG_SECURITYKEY
	if((info_disprotect & DISPROTECT_KEY)){ // disprotect
		printf("emmckey_is_protected : disprotect\n ");
		return 0;
	}else{ 	
		printf("emmckey_is_protected : protect\n ");
	// protect
		return 1;
	}
	#else
   		 return 0;
	#endif
#else
	#ifdef CONFIG_SECURITYKEY
		return mmc->key_protect;
	#else
		return 0;	
	#endif
#endif
}

bool emmckey_is_access_range_legal (struct mmc *mmc, ulong start, lbaint_t blkcnt)
{
#ifdef CONFIG_SECURITYKEY
	struct aml_emmckey_info_t *emmckey_info;
	emmckey_info = mmc->aml_emmckey_info;
#endif
	if(aml_is_emmc_tsd(mmc)){
		
#ifdef CONFIG_STORE_COMPATIBLE
	#ifdef CONFIG_SECURITYKEY
	if(!(info_disprotect & DISPROTECT_KEY)){ // NOT allow accessing
	        if ((emmckey_info->lba_start <= (start+blkcnt-1)) && ((emmckey_info->lba_end-1) >= start)) {
	                printf("Emmckey: Access range is illegal!\n");
				return false;
	        }
	}
	#endif
#else
	#ifdef CONFIG_SECURITYKEY
	if(mmc->key_protect){ // NOT allow accessing
	        if ((emmckey_info->lba_start <= (start+blkcnt-1)) && ((emmckey_info->lba_end-1) >= start)) {
	                printf("Emmckey: Access range is illegal!\n");
				return false;
	        }
	}
	#endif
#endif
	}

    return true;
}

int __board_mmc_getcd(u8 *cd, struct mmc *mmc) {
	return -1;
}

int board_mmc_getcd(u8 *cd, struct mmc *mmc)__attribute__((weak,
	alias("__board_mmc_getcd")));
	
int mmc_send_cmd(struct mmc *mmc, struct mmc_cmd *cmd, struct mmc_data *data)
{
	return mmc->send_cmd(mmc, cmd, data);
}

int mmc_set_blocklen(struct mmc *mmc, int len)
{
	struct mmc_cmd cmd;

	cmd.cmdidx = MMC_CMD_SET_BLOCKLEN;
	cmd.resp_type = MMC_RSP_R1;
	cmd.cmdarg = len;
	cmd.flags = 0;

	return mmc_send_cmd(mmc, &cmd, NULL);
}

struct mmc *find_mmc_device(int dev_num)
{
	struct mmc *m;
	struct list_head *entry;

	list_for_each(entry, &mmc_devices) {
		m = list_entry(entry, struct mmc, link);

		if (m->block_dev.dev == dev_num)
			return m;
	}

	printf("MMC Device %d not found\n", dev_num);

	return NULL;
}

struct mmc *find_mmc_device_by_port (unsigned sdio_port)
{
    struct mmc *m;
    struct aml_card_sd_info * sdio;
    struct list_head *entry;

    list_for_each(entry, &mmc_devices) {
        m = list_entry(entry, struct mmc, link);
        sdio = m->priv;

        if (sdio->sdio_port == sdio_port)
            return m;
    }

	return NULL;
}


#ifdef CONFIG_MMC_DEVICE
struct mmc find_mmc_device_by_name(char *name)
{
	struct mmc *m;
	struct list_head *entry;

	list_for_each(entry, &mmc_devices) {
		m = list_entry(entry, struct mmc, link);

		if (!strcmp(m->device->name , name))
			return m;
	}

	printf("MMC Device %d not found\n", dev_num);

	return NULL;
}
#endif

static ulong
mmc_write_blocks(struct mmc *mmc, ulong start, lbaint_t blkcnt, const void*src)
{
	struct mmc_cmd cmd;
	struct mmc_data data;

	if ((start + blkcnt) > mmc->block_dev.lba) {
		printf("MMC: block number 0x%lx exceeds max(0x%lx)\n",
			start + blkcnt, mmc->block_dev.lba);
		return 0;
	}

	if (blkcnt > 1)
		cmd.cmdidx = MMC_CMD_WRITE_MULTIPLE_BLOCK;
	else
		cmd.cmdidx = MMC_CMD_WRITE_SINGLE_BLOCK;

	if (mmc->high_capacity)
		cmd.cmdarg = start;
	else
		cmd.cmdarg = start * mmc->write_bl_len;

	cmd.resp_type = MMC_RSP_R1;
	cmd.flags = 0;

	data.src = src;
	data.blocks = blkcnt;
	data.blocksize = mmc->write_bl_len;
	data.flags = MMC_DATA_WRITE;

	if (mmc_send_cmd(mmc, &cmd, &data)) {
		printf("mmc write failed\n");
		return 0;
	}

	if (blkcnt > 1) {
		cmd.cmdidx = MMC_CMD_STOP_TRANSMISSION;
		cmd.cmdarg = 0;
		cmd.resp_type = MMC_RSP_R1b;
		cmd.flags = 0;
		if (mmc_send_cmd(mmc, &cmd, NULL)) {
			printf("mmc fail to send stop cmd\n");
			return 0;
		}
	}

	return blkcnt;
}

static ulong
mmc_bwrite(int dev_num, ulong start, lbaint_t blkcnt, const void*src)
{
	lbaint_t cur, blocks_todo = blkcnt;

	struct mmc *mmc = find_mmc_device(dev_num);

	if (!mmc)
		return 0;

    if (emmckey_is_access_range_legal(mmc, start, blkcnt) == false) {
        return 0; // error: illegal
    }

	if (mmc_set_blocklen(mmc, mmc->write_bl_len))
		return 0;

	do {
		/*
		 * The 65535 constraint comes from some hardware has
		 * only 16 bit width block number counter
		 */
		cur = (blocks_todo > MMC_RD_WR_MAX_BLK_NUM) ? MMC_RD_WR_MAX_BLK_NUM : blocks_todo;
		if(mmc_write_blocks(mmc, start, cur, src) != cur)
			return 0;
		blocks_todo -= cur;
		start += cur;
		src += cur * mmc->write_bl_len;
	} while (blocks_todo > 0);

	return blkcnt;
}

int mmc_read_blocks(struct mmc *mmc, void *dst, ulong start, lbaint_t blkcnt)
{
	struct mmc_cmd cmd;
	struct mmc_data data;

	if (blkcnt > 1)
		cmd.cmdidx = MMC_CMD_READ_MULTIPLE_BLOCK;
	else
		cmd.cmdidx = MMC_CMD_READ_SINGLE_BLOCK;

	if (mmc->high_capacity)
		cmd.cmdarg = start;
	else
		cmd.cmdarg = start * mmc->read_bl_len;

	cmd.resp_type = MMC_RSP_R1;
	cmd.flags = 0;

	data.dest = dst;
	data.blocks = blkcnt;
	data.blocksize = mmc->read_bl_len;
	data.flags = MMC_DATA_READ;

	if (mmc_send_cmd(mmc, &cmd, &data))
		return 0;

	if (blkcnt > 1) {
		cmd.cmdidx = MMC_CMD_STOP_TRANSMISSION;
		cmd.cmdarg = 0;
		cmd.resp_type = MMC_RSP_R1b;
		cmd.flags = 0;
		if (mmc_send_cmd(mmc, &cmd, NULL)) {
			printf("mmc fail to send stop cmd\n");
			return 0;
		}
	}

	return blkcnt;
}

static ulong mmc_bread(int dev_num, ulong start, lbaint_t blkcnt, void *dst)
{
	lbaint_t cur, blocks_todo = blkcnt;

	if (blkcnt == 0)
		return 0;

	struct mmc *mmc = find_mmc_device(dev_num);
	if (!mmc)
		return 0;

	if ((start + blkcnt) > mmc->block_dev.lba) {
		printf("MMC: block number 0x%lx exceeds max(0x%lx)\n",
			start + blkcnt, mmc->block_dev.lba);
		return 0;
	}

    if (emmckey_is_access_range_legal(mmc, start, blkcnt) == false) {
        return 0; // error: illegal
    }

	if (mmc_set_blocklen(mmc, mmc->read_bl_len))
		return 0;

	do {
		/*
		 * The 65535 constraint comes from some hardware has
		 * only 16 bit width block number counter
		 */
		cur = (blocks_todo > MMC_RD_WR_MAX_BLK_NUM) ? MMC_RD_WR_MAX_BLK_NUM : blocks_todo;
		if(mmc_read_blocks(mmc, dst, start, cur) != cur)
			return 0;
		blocks_todo -= cur;
		start += cur;
		dst += cur * mmc->read_bl_len;
	} while (blocks_todo > 0);

	return blkcnt;
}

// if not High Capacity Card, turn the unit from blk_len to byte
#define TURN_TRANSFER_UNIT(val, is_high_cap, blk_len) ((is_high_cap)? (val):((val)*blk_len))
static ulong
__mmc_berase(struct mmc *mmc, ulong start, lbaint_t blkcnt)
{
	struct mmc_cmd cmd;
	int err;
	ulong end, max_end;

	max_end = mmc->capacity/512 - 1;//max end address in block
	end = start + blkcnt - 1;

	if (IS_SD(mmc)){
		printf("card_type:sd or tsd, ");

		int erase_ssize;

		if(mmc->version == SD_VERSION_2){
			erase_ssize = 8;//"8" is a setting value			
		}
		else{
			int erase_blk_en = (mmc->csd[2]>>14) & 0x1;
			erase_ssize = ((mmc->csd[2]>>7) & 0x7f) + 1;

			if (erase_blk_en == 1)
				erase_ssize = 1;
		}
		printf("erase_unit_size = %d, ",erase_ssize);
			
		start = start - start%erase_ssize;
		end = blkcnt ? ((end/erase_ssize + 1)*erase_ssize-1): max_end;

        if (end > max_end) {
		     printf("MMC: group number 0x%lx exceeds max(0x%lx)\n", end , max_end);
		     return 1;
	    }
		cmd.cmdidx = SD_ERASE_WR_BLK_START;
		cmd.resp_type = MMC_RSP_R1;
		cmd.cmdarg = TURN_TRANSFER_UNIT(start, mmc->high_capacity, mmc->write_bl_len);
		cmd.flags = 0;
		err = mmc_send_cmd(mmc, &cmd, NULL);		
		if (err)
			return err;

		cmd.cmdidx = SD_ERASE_WR_BLK_END;
		cmd.resp_type = MMC_RSP_R1;
		cmd.cmdarg = TURN_TRANSFER_UNIT(end, mmc->high_capacity, mmc->write_bl_len);
		cmd.flags = 0;
		err = mmc_send_cmd(mmc, &cmd, NULL);
		if (err)
			return err;		
	}else {
		printf("card_type:mmc or emmc, ");

		int erase_unit;
		char ext_csd[512];			
		
		int err = mmc_send_ext_csd(mmc, ext_csd);		
		if (err)
			return err;

		if(ext_csd[175]){//erase_group_def
			int erase_unit_byte = ((unsigned)ext_csd[224])*512*1024;//byte cnt
			erase_unit = erase_unit_byte / mmc->write_bl_len;//blk cnt
			printf("ext_csd:erase_unit = %d, ",erase_unit);
		}
		else{			
			int erase_gsize = (mmc->csd[2] >> 10) & 0x1f;
			int erase_gmult = (mmc->csd[2] >> 5) & 0x1f;
			erase_unit = (erase_gsize + 1) * (erase_gmult + 1);//blk cnt
			printf("csd:erase_unit = %d, ",erase_unit);
		}

		start = start - start%erase_unit;
		end = blkcnt? ((end/erase_unit + 1)*erase_unit-1) : max_end;
		if (end > max_end) {
			printf("MMC: group number 0x%lx exceeds max(0x%lx)\n",
				end, max_end);
			return 1;
		}
		
		cmd.cmdidx = MMC_TAG_ERASE_GROUP_START;
		cmd.resp_type = MMC_RSP_R1;
		cmd.cmdarg = TURN_TRANSFER_UNIT(start, mmc->high_capacity, mmc->write_bl_len);
		cmd.flags = 0;
		err = mmc_send_cmd(mmc, &cmd, NULL);
		if (err)
			return err;

		cmd.cmdidx = MMC_TAG_ERASE_GROUP_END;
		cmd.resp_type = MMC_RSP_R1;
		cmd.cmdarg = TURN_TRANSFER_UNIT(end, mmc->high_capacity, mmc->write_bl_len);
		cmd.flags = 0;
		err = mmc_send_cmd(mmc, &cmd, NULL);
		if (err)
			return err;
	}
    printf("is being erased ...\n");
	cmd.cmdidx = SD_MMC_ERASE;
	cmd.resp_type = MMC_RSP_R1b;
	cmd.cmdarg = 0;
	cmd.flags = 0;
	err = mmc_send_cmd(mmc, &cmd, NULL);
	if (err)
		return err;

	unsigned int timeout = 0;
	uint *res = (uint*)(&(cmd.response[0]));
	do {		
		cmd.cmdidx = MMC_CMD_SEND_STATUS;
		cmd.cmdarg = mmc->rca << 16;
		cmd.resp_type = MMC_RSP_R1;
		cmd.flags = 0;
		
		err = mmc_send_cmd(mmc, &cmd, NULL);
		if (err || (*res & 0xFDF92000)) {
			printf("error %d requesting status %#x\n", err, *res);
			return -1;
		}
		
		timeout ++;
		if (timeout > 10*60*1000)
			return -1;
		mdelay(1);		
	} while (!(*res & R1_READY_FOR_DATA) || (R1_CURRENT_STATE(*res) == R1_STATE_PRG));

	return 0;
}

static ulong mmc_berase(int dev_num, ulong start, lbaint_t blkcnt)
{
    int ret = 0;
	struct mmc *mmc = find_mmc_device(dev_num);
	
    if (!mmc) 
	  	return 0;
    
    if (emmckey_is_access_range_legal(mmc, start, blkcnt) == false) {
        return blkcnt; // illegal error
    }

    ret = __mmc_berase(mmc, start, blkcnt);

	printf("erase %#lx --> %#lx %s\n",start, start + blkcnt - 1, (ret == 0) ? "OK" : "ERROR");

    return ret;
}

#include <asm/arch/io.h>

int mmc_go_idle(struct mmc* mmc)
{
	struct mmc_cmd cmd;
	int err;

	CLEAR_CBUS_REG_MASK(PREG_PAD_GPIO3_EN_N,(0x1<<3));
	SET_CBUS_REG_MASK(PREG_PAD_GPIO3_O,(0x1<<3));
	CLEAR_CBUS_REG_MASK(PERIPHS_PIN_MUX_6, (0x1<<26)); //D3

	udelay(1000);

    aml_sd_cs_high();
	cmd.cmdidx = MMC_CMD_GO_IDLE_STATE;
	cmd.cmdarg = 0;
	cmd.resp_type = MMC_RSP_NONE;
	cmd.flags = 0;

	err = mmc_send_cmd(mmc, &cmd, NULL);

    aml_sd_cs_dont_care();
	if (err)
		return err;

	udelay(2000);
	SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_6, (0x1<<26)); //D3
	udelay(2000);

	return 0;
}

int
sd_send_op_cond(struct mmc *mmc)
{
	int timeout = 1000;
	int err;
	struct mmc_cmd cmd;
	uint * response= (uint*)(&((cmd.response)[0]));

	do {
		cmd.cmdidx = MMC_CMD_APP_CMD;
		cmd.resp_type = MMC_RSP_R1;
		cmd.cmdarg = 0;
		cmd.flags = 0;

		err = mmc_send_cmd(mmc, &cmd, NULL);

		if (err == TIMEOUT)
			return err;
         else if(err){
             udelay(10000);
             continue; 
         }   
              
		cmd.cmdidx = SD_CMD_APP_SEND_OP_COND;
		cmd.resp_type = MMC_RSP_R3;

		/*
		 * Most cards do not answer if some reserved bits
		 * in the ocr are set. However, Some controller
		 * can set bit 7 (reserved for low voltages), but
		 * how to manage low voltages SD card is not yet
		 * specified.
		 */
		cmd.cmdarg = mmc->voltages & 0xff8000;

		if (mmc->version == SD_VERSION_2)
			cmd.cmdarg |= OCR_HCS;

		err = mmc_send_cmd(mmc, &cmd, NULL);

		if (err)
			return err;

		udelay(1000);
	} while ((!((*response) & OCR_BUSY) || err) && timeout--); //while ((!(((uint *)cmd.response)[0] & OCR_BUSY) || err) && timeout--);

	if (timeout <= 0)
		return UNUSABLE_ERR;

	if (mmc->version != SD_VERSION_2)
		mmc->version = SD_VERSION_1_0;
	
	//mmc->ocr = ((uint *)(cmd.response))[0]; 
	mmc->ocr = *response; 
	
	mmc->high_capacity = ((mmc->ocr & OCR_HCS) == OCR_HCS);
	mmc->rca = 0;

	return 0;
}

int mmc_send_op_cond(struct mmc *mmc)
{
	int timeout = 1000;
	struct mmc_cmd cmd;
	int err;
	uint * response= (uint*)(&((cmd.response)[0]));

	/* Some cards seem to need this */
	mmc_go_idle(mmc);

	do {
		cmd.cmdidx = MMC_CMD_SEND_OP_COND;
		cmd.resp_type = MMC_RSP_R3;
		cmd.cmdarg = OCR_HCS | mmc->voltages;
		cmd.flags = 0;

		err = mmc_send_cmd(mmc, &cmd, NULL);

		if (err)
			return err;

		udelay(1000);
	} while (!((*response) & OCR_BUSY) && timeout--);   //while (!(((uint *)(cmd.response))[0] & OCR_BUSY) && timeout--);

	if (timeout <= 0)
		return UNUSABLE_ERR;

	mmc->version = MMC_VERSION_UNKNOWN;
	//mmc->ocr = ((uint *)(cmd.response))[0];
	mmc->ocr = *response;

	mmc->high_capacity = ((mmc->ocr & OCR_HCS) == OCR_HCS);
	mmc->rca = 1;

	return 0;
}


int mmc_send_ext_csd(struct mmc *mmc, char *ext_csd)
{
	struct mmc_cmd cmd;
	struct mmc_data data;
	int err;

	/*delay for some emmc init fail*/
	mdelay(1);

	/* Get the Card Status Register */
	cmd.cmdidx = MMC_CMD_SEND_EXT_CSD;
	cmd.resp_type = MMC_RSP_R1;
	cmd.cmdarg = 0;
	cmd.flags = 0;

	data.dest = ext_csd;
	data.blocks = 1;
	data.blocksize = 512;
	data.flags = MMC_DATA_READ;

	err = mmc_send_cmd(mmc, &cmd, &data);

	return err;
}


int mmc_switch(struct mmc *mmc, u8 set, u8 index, u8 value)
{
	struct mmc_cmd cmd;

	cmd.cmdidx = MMC_CMD_SWITCH;
	cmd.resp_type = MMC_RSP_R1b;
	cmd.cmdarg = (MMC_SWITCH_MODE_WRITE_BYTE << 24) |
		(index << 16) |
		(value << 8);
	cmd.flags = 0;

	return mmc_send_cmd(mmc, &cmd, NULL);
}

int mmc_change_freq(struct mmc *mmc)
{
	char ext_csd[512];
	char cardtype;
	u64  sector_count;
	int err;
	mmc->card_caps = 0;

	/* Only version 4 supports high-speed */
	if (mmc->version < MMC_VERSION_4)
		return 0;

	mmc->card_caps |= MMC_MODE_4BIT;

	err = mmc_send_ext_csd(mmc, ext_csd);
	mdelay(1);
	if (err)
		return err;
    //printf("ERASED_MEM_CONT is %d\n",ext_csd[181]);

	if (ext_csd[212] || ext_csd[213] || ext_csd[214] || ext_csd[215])
	{
		//mmc->capacity = (*(unsigned *)(&ext_csd[212]))*mmc->read_bl_len;
		sector_count = (((unsigned)ext_csd[215])<<24)|(((unsigned)ext_csd[214])<<16)|(((unsigned)ext_csd[213])<<8)|(((unsigned)ext_csd[212])<<0);
		mmc->capacity = sector_count*mmc->read_bl_len;
        	/*
		 * There are two boot regions of equal size, defined in
		 * multiples of 128K.
		 */
	        mmc->boot_size = ext_csd[EXT_CSD_BOOT_MULT] << 17;
		//mmc->high_capacity = 1;
	}		

	cardtype = ext_csd[196] & 0xf;

	err = mmc_switch(mmc, EXT_CSD_CMD_SET_NORMAL, EXT_CSD_HS_TIMING, 1);
	mdelay(1);
	if (err)
		return err;

	/* Now check to see that it worked */
	err = mmc_send_ext_csd(mmc, ext_csd);

	if (err)
		return err;

	/* No high-speed support */
	if (!ext_csd[185])
		return 0;

	/* High Speed is set, there are two types: 52MHz and 26MHz */
	if (cardtype & MMC_HS_52MHZ)
		mmc->card_caps |= MMC_MODE_HS_52MHz | MMC_MODE_HS;
	else
		mmc->card_caps |= MMC_MODE_HS;

	return 0;
}

int sd_switch(struct mmc *mmc, int mode, int group, u8 value, u8 *resp)
{
	struct mmc_cmd cmd;
	struct mmc_data data;       	

	/* Switch the frequency */
	cmd.cmdidx = SD_CMD_SWITCH_FUNC;
	cmd.resp_type = MMC_RSP_R1;
	cmd.cmdarg = (mode << 31) | 0xffffff;
	cmd.cmdarg &= ~(0xf << (group * 4));
	cmd.cmdarg |= value << (group * 4);
	cmd.flags = 0;

	data.dest = (char *)resp;
	data.blocksize = 64;
	data.blocks = 1;
	data.flags = MMC_DATA_READ;
 
 	return mmc_send_cmd(mmc, &cmd, &data);
}


int sd_change_freq(struct mmc *mmc)
{
	int err;
	struct mmc_cmd cmd;
	uint scr[2];
	uint switch_status[16];
	struct mmc_data data;
	int timeout;

	mmc->card_caps = 0;

	/* Read the SCR to find out if this card supports higher speeds */
	cmd.cmdidx = MMC_CMD_APP_CMD;
	cmd.resp_type = MMC_RSP_R1;
	cmd.cmdarg = mmc->rca << 16;
	cmd.flags = 0;

	err = mmc_send_cmd(mmc, &cmd, NULL);

	if (err)
		return err;

	cmd.cmdidx = SD_CMD_APP_SEND_SCR;
	cmd.resp_type = MMC_RSP_R1;
	cmd.cmdarg = 0;
	cmd.flags = 0;

	timeout = 3;

retry_scr:
	data.dest = (char *)&scr;
	data.blocksize = 8;
	data.blocks = 1;
	data.flags = MMC_DATA_READ;

	err = mmc_send_cmd(mmc, &cmd, &data);

	if (err) {
		if (timeout--)
			goto retry_scr;

		return err;
	}

	mmc->scr[0] = __be32_to_cpu(scr[0]);
	mmc->scr[1] = __be32_to_cpu(scr[1]);

	switch ((mmc->scr[0] >> 24) & 0xf) {
		case 0:
			mmc->version = SD_VERSION_1_0;
			break;
		case 1:
			mmc->version = SD_VERSION_1_10;
			break;
		case 2:
			mmc->version = SD_VERSION_2;
			break;
		default:
			mmc->version = SD_VERSION_1_0;
			break;
	}
    
	if (mmc->scr[0] & SD_DATA_4BIT)
		mmc->card_caps |= MMC_MODE_4BIT;
    
	/* Version 1.0 doesn't support switching */
	if (mmc->version == SD_VERSION_1_0)
		return 0;
        
	timeout = 4;
	while (timeout--) {
		err = sd_switch(mmc, SD_SWITCH_CHECK, 0, 1,
				(u8 *)&switch_status);

		if(err)
			return err;

		// The high-speed function is busy.  Try again 
		if (!(__be32_to_cpu(switch_status[7]) & SD_HIGHSPEED_BUSY))
			break;
	}

	// If high-speed isn't supported, we return 
	if (!(__be32_to_cpu(switch_status[3]) & SD_HIGHSPEED_SUPPORTED))
		return 0;

	err = sd_switch(mmc, SD_SWITCH_SWITCH, 0, 1, (u8 *)&switch_status);

	if (err)
		return err;

	if ((__be32_to_cpu(switch_status[4]) & 0x0f000000) == 0x01000000)
		mmc->card_caps |= MMC_MODE_HS;
       
	return 0;
}

/* frequency bases */
/* divided by 10 to be nice to platforms without floating point */
int fbase[] = {
	10000,
	100000,
	1000000,
	10000000,
};

/* Multiplier values for TRAN_SPEED.  Multiplied by 10 to be nice
 * to platforms without floating point.
 */
int multipliers[] = {
	0,	/* reserved */
	10,
	12,
	13,
	15,
	20,
	25,
	30,
	35,
	40,
	45,
	50,
	55,
	60,
	70,
	80,
};

void mmc_set_ios(struct mmc *mmc)
{
	mmc->set_ios(mmc);
}

void mmc_set_clock(struct mmc *mmc, uint clock)
{
	if (clock > mmc->f_max)
		clock = mmc->f_max;

	if (clock < mmc->f_min)
		clock = mmc->f_min;

	mmc->clock = clock;

	mmc_set_ios(mmc);
}

void mmc_set_bus_width(struct mmc *mmc, uint width)
{
	mmc->bus_width = width;

	mmc_set_ios(mmc);
}

int mmc_startup(struct mmc *mmc)
{
	int err;
	uint mult, freq;
	u64 cmult, csize;
	struct mmc_cmd cmd;
	//char ext_csd[512];	
	uint *cid = (uint*)(&(mmc->cid[0]));
	uint *response = (uint*)(&(cmd.response[0]));
	
	/* Put the Card in Identify Mode */
	cmd.cmdidx = MMC_CMD_ALL_SEND_CID;
	cmd.resp_type = MMC_RSP_R2;
	cmd.cmdarg = 0;
	cmd.flags = 0;

	err = mmc_send_cmd(mmc, &cmd, NULL);

	if (err)
		return err;
    
       memcpy(mmc->cid, cmd.response, 16);

       // ((uint *)mmc->cid)[0] = __be32_to_cpu(((uint *)mmc->cid)[0]);
       //((uint *)mmc->cid)[1] = __be32_to_cpu(((uint *)mmc->cid)[1]);
       // ((uint *)mmc->cid)[2] = __be32_to_cpu(((uint *)mmc->cid)[2]);
       //((uint *)mmc->cid)[3] = __be32_to_cpu(((uint *)mmc->cid)[3]);
		cid[0] = __be32_to_cpu(cid[0]);
      	cid[1] = __be32_to_cpu(cid[1]);
      	cid[2] = __be32_to_cpu(cid[2]);
      	cid[3] = __be32_to_cpu(cid[3]);

	/*
	 * For MMC cards, set the Relative Address.
	 * For SD cards, get the Relatvie Address.
	 * This also puts the cards into Standby State
	 */
	cmd.cmdidx = SD_CMD_SEND_RELATIVE_ADDR;
	cmd.cmdarg = mmc->rca << 16;
	cmd.resp_type = MMC_RSP_R6;
	cmd.flags = 0;

	err = mmc_send_cmd(mmc, &cmd, NULL);

	if (err)
		return err;

	if (IS_SD(mmc))
		mmc->rca = (response[0] >> 16) & 0xffff;
		//mmc->rca = (((uint *)(cmd.response))[0] >> 16) & 0xffff;

	/* Get the Card-Specific Data */
	cmd.cmdidx = MMC_CMD_SEND_CSD;
	cmd.resp_type = MMC_RSP_R2;
	cmd.cmdarg = mmc->rca << 16;
	cmd.flags = 0;

	err = mmc_send_cmd(mmc, &cmd, NULL);

	if (err)
		return err;

	mmc->csd[0] = response[0]; //((uint *)(cmd.response))[0];
	mmc->csd[1] = response[1];//((uint *)(cmd.response))[1];
	mmc->csd[2] = response[2];//((uint *)(cmd.response))[2];
	mmc->csd[3] = response[3];//((uint *)(cmd.response))[3];

	if (mmc->version == MMC_VERSION_UNKNOWN) {
		//int version = (((uint *)(cmd.response))[0]  >> 26) & 0xf;
		int version = (response[0]  >> 26) & 0xf;

		switch (version) {
			case 0:
				mmc->version = MMC_VERSION_1_2;
				break;
			case 1:
				mmc->version = MMC_VERSION_1_4;
				break;
			case 2:
				mmc->version = MMC_VERSION_2_2;
				break;
			case 3:
				mmc->version = MMC_VERSION_3;
				break;
			case 4:
				mmc->version = MMC_VERSION_4;
				break;
			default:
				mmc->version = MMC_VERSION_1_2;
				break;
		}
	}

	/* divide frequency by 10, since the mults are 10x bigger */
	//freq = fbase[(((uint *)(cmd.response))[0]  & 0x7)];
	freq = fbase[(response[0]  & 0x7)];
	//mult = multipliers[((((uint *)(cmd.response))[0] >> 3) & 0xf)];
	mult = multipliers[((response[0] >> 3) & 0xf)];

	mmc->tran_speed = freq * mult;

	//mmc->read_bl_len = 1 << ((((uint *)(cmd.response))[1] >> 16) & 0xf);
	mmc->read_bl_len = 1 << ((response[1] >> 16) & 0xf);

	if (IS_SD(mmc))
		mmc->write_bl_len = mmc->read_bl_len;
	else
		mmc->write_bl_len = 1 << ((response[3] >> 22) & 0xf);

	if (mmc->high_capacity) {
		csize = (mmc->csd[1] & 0x3f) << 16
			| (mmc->csd[2] & 0xffff0000) >> 16;
		cmult = 8;
	} else {
		csize = (mmc->csd[1] & 0x3ff) << 2
			| (mmc->csd[2] & 0xc0000000) >> 30;
		cmult = (mmc->csd[2] & 0x00038000) >> 15;
	}

	mmc->capacity = (csize + 1) << (cmult + 2);
	mmc->capacity *= mmc->read_bl_len;
	mmc->boot_size = 0;
	if (mmc->read_bl_len > 512)
		mmc->read_bl_len = 512;

	if (mmc->write_bl_len > 512)
		mmc->write_bl_len = 512;

	/* Select the card, and put it into Transfer Mode */
	cmd.cmdidx = MMC_CMD_SELECT_CARD;
	cmd.resp_type = MMC_RSP_R1b;
	cmd.cmdarg = mmc->rca << 16;
	cmd.flags = 0;
	err = mmc_send_cmd(mmc, &cmd, NULL);

	if (err)
		return err;

//	if (!IS_SD(mmc) && (mmc->version >= MMC_VERSION_4)) {
		/* check  ext_csd version and capacity */
/*		err = mmc_send_ext_csd(mmc, ext_csd);
		if (!err & (ext_csd[192] >= 2)) {
			mmc->capacity = ext_csd[212] << 0 | ext_csd[213] << 8 |
					ext_csd[214] << 16 | ext_csd[215] << 24;
			mmc->capacity *= 512;
		}
	}*/
	
	if (IS_SD(mmc))
		err = sd_change_freq(mmc);
	else
		err = mmc_change_freq(mmc);

	if (err)
		return err;		

	/* Restrict card's capabilities by what the host can do */
	mmc->card_caps &= mmc->host_caps;

	if (IS_SD(mmc)) {
		if (mmc->card_caps & MMC_MODE_4BIT) {
			cmd.cmdidx = MMC_CMD_APP_CMD;
			cmd.resp_type = MMC_RSP_R1;
			cmd.cmdarg = mmc->rca << 16;
			cmd.flags = 0;

			err = mmc_send_cmd(mmc, &cmd, NULL);
			if (err)
				return err;

			cmd.cmdidx = SD_CMD_APP_SET_BUS_WIDTH;
			cmd.resp_type = MMC_RSP_R1;
			cmd.cmdarg = 2;
			cmd.flags = 0;
			err = mmc_send_cmd(mmc, &cmd, NULL);
			if (err)
				return err;

			mmc_set_bus_width(mmc, 4);
		}

        if (mmc->card_caps & MMC_MODE_HS) {
#ifdef CONFIG_STORE_COMPATIBLE
            if (aml_is_emmc_tsd(mmc)) {
                mmc_set_clock(mmc, 40000000);
                mmc->tran_speed = 40000000;
            } else {
                mmc_set_clock(mmc, 30000000);
                mmc->tran_speed = 20000000;
            }
#else
			mmc_set_clock(mmc, 50000000);
			mmc->tran_speed = 40000000;
#endif
        } else {
			mmc_set_clock(mmc, 25000000);
			mmc->tran_speed = 20000000;
		}
	} else {
		if (mmc->card_caps & MMC_MODE_4BIT) {
			/* Set the card to use 4 bit*/
			err = mmc_switch(mmc, EXT_CSD_CMD_SET_NORMAL,
					EXT_CSD_BUS_WIDTH,
					EXT_CSD_BUS_WIDTH_4);

			if (err)
				return err;

			mmc_set_bus_width(mmc, 4);
		} else if (mmc->card_caps & MMC_MODE_8BIT) {
			/* Set the card to use 8 bit*/
			err = mmc_switch(mmc, EXT_CSD_CMD_SET_NORMAL,
					EXT_CSD_BUS_WIDTH,
					EXT_CSD_BUS_WIDTH_8);

			if (err)
				return err;

			mmc_set_bus_width(mmc, 8);
		}

		if (mmc->card_caps & MMC_MODE_HS) {
			if (mmc->card_caps & MMC_MODE_HS_52MHz)
				mmc_set_clock(mmc, 52000000);
			else {
#ifdef CONFIG_STORE_COMPATIBLE
                if (aml_is_emmc_tsd(mmc)) {
                    mmc_set_clock(mmc, 40000000);
                } else {
                    mmc_set_clock(mmc, 26000000);
                }
#else
                mmc_set_clock(mmc, 26000000);
#endif
            }
		} else
			mmc_set_clock(mmc, 20000000);
	}

	/* fill in device description */
	mmc->block_dev.lun = 0;
	mmc->block_dev.type = 0;
	mmc->block_dev.blksz = mmc->read_bl_len;
	mmc->block_dev.lba = mmc->capacity/mmc->read_bl_len;
	sprintf(mmc->block_dev.vendor,"Man %02x%02x%02x Snr %02x%02x%02x%02x",
			mmc->cid[0], mmc->cid[1], mmc->cid[2],
			mmc->cid[9], mmc->cid[10], mmc->cid[11], mmc->cid[12]);
	sprintf(mmc->block_dev.product,"%c%c%c%c%c", mmc->cid[3],
			mmc->cid[4], mmc->cid[5], mmc->cid[6], mmc->cid[7]);
	sprintf(mmc->block_dev.revision,"%d.%d", mmc->cid[8] >> 4,
			mmc->cid[8] & 0xf);
    debug("MMC init part");
	init_part(&mmc->block_dev);
    //print_part(&mmc->block_dev);
	return 0;
}

int mmc_switch_partition(struct mmc* mmc, unsigned int part)
{
    int err;
    struct mmc_cmd cmd;
    char* partname[3] = {"user", "boot0", "boot1"};
	unsigned int timeout = 0;
	uint *res = (uint*)(&(cmd.response[0]));
    
    if(!IS_SD(mmc) && (mmc->version < MMC_VERSION_4)){
    	printf("mmc do not support boot partition mmc->version:%d \n", mmc->version);
    	err = -1;
    	return err;
    }

    cmd.cmdidx = MMC_CMD_SWITCH;
    cmd.resp_type = MMC_RSP_R1b;
    cmd.cmdarg = (MMC_SWITCH_MODE_WRITE_BYTE << 24) |
        (EXT_CSD_PART_CONFIG << 16) |
        (part << 8);
    cmd.flags = 0;

    err = mmc_send_cmd(mmc, &cmd, NULL);
    if(err){
        printf("mmc switch part %s failed while sending switch cmd\n", partname[part]);
        return err;
    }    

	do {		
		cmd.cmdidx = MMC_CMD_SEND_STATUS;
		cmd.cmdarg = mmc->rca << 16;
		cmd.resp_type = MMC_RSP_R1;
		cmd.flags = 0;
		
		err = mmc_send_cmd(mmc, &cmd, NULL);
		if (err) {
			printf("error %d requesting status %#x\n", err, *res);
			return -1;
		}
		
		timeout ++;
		if (timeout > 100){
		    printf("mmc switch part timeout *res:0x%x\n", *res);
			return -1;
		}
		mdelay(1);		
	} while (R1_CURRENT_STATE(*res) == R1_STATE_PRG);
	
    printf("mmc switch part %s %s\n", partname[part], err?"fail":"success");
    return err;	    
}

int mmc_send_if_cond(struct mmc *mmc)
{
	struct mmc_cmd cmd;
	int err;
	uint *response = (uint*)(&(cmd.response[0]));

	cmd.cmdidx = SD_CMD_SEND_IF_COND;
	/* We set the bit if the host supports voltages between 2.7 and 3.6 V */
	cmd.cmdarg = ((mmc->voltages & 0xff8000) != 0) << 8 | 0xaa;
	cmd.resp_type = MMC_RSP_R7;
	cmd.flags = 0;

	err = mmc_send_cmd(mmc, &cmd, NULL);

	if (err)
		return err;

//	if ((((uint *)(cmd.response))[0] & 0xff) != 0xaa)
	if ((response[0] & 0xff) != 0xaa)
		return UNUSABLE_ERR;
	else
		mmc->version = SD_VERSION_2;

	return 0;
}

int mmc_register(struct mmc *mmc)
{
    struct aml_card_sd_info * sdio=mmc->priv;

	/* Setup the universal parts of the block interface just once */
    if (mmc->block_dev.if_type != IF_TYPE_SD)
        mmc->block_dev.if_type = IF_TYPE_MMC;
	mmc->block_dev.dev = cur_dev_num++;
	mmc->block_dev.removable = 1;
	mmc->block_dev.block_read = mmc_bread;
	mmc->block_dev.block_write = mmc_bwrite;
	mmc->block_dev.block_erase = mmc_berase;

#ifdef CONFIG_MMC_DEVICE
	if(mmc->device){
		mmc->device->dev_num = mmc->block_dev.dev;
	}
#endif

	INIT_LIST_HEAD (&mmc->link);

	list_add_tail (&mmc->link, &mmc_devices);

	printf("[%s] add mmc dev_num=%d, port=%d, if_type=%d\n",
            __FUNCTION__, mmc->block_dev.dev, sdio->sdio_port, mmc->block_dev.if_type);

	return 0;
}

block_dev_desc_t *mmc_get_dev(int dev)
{
	struct mmc *mmc = find_mmc_device(dev);

	return mmc ? &mmc->block_dev : NULL;
}

#define SD_CARD_DEV     0
#define EMMC_INAND_DEV  1

#if defined (CONFIG_PARTITIONS_STORE)
extern  int mmc_device_partitions (struct mmc *mmc);
static int is_init_partition_flag = 0;
#endif

int mmc_init(struct mmc *mmc)
{
	int err;

	err = mmc->init(mmc);
	if (err)
		return err;
	
	if(mmc->is_inited) // has been initialized
        return 0;       

	/* Reset the Card */
	err = mmc_go_idle(mmc);
	if (err)
		return err;
	
	
	// check SDCARD/EMMC to reduce EMMC load env data cycles	
	//tsd could not init as emmc (cmd1)
	if(mmc->block_dev.if_type == IF_TYPE_SD)
	{
		/* Test for SD version 2 */
		err = mmc_send_if_cond(mmc);
		/* If we got an error other than timeout, we bail */
		if (err && err != TIMEOUT)
			return err;
        else if(err)
            err = mmc_go_idle(mmc);
	
		/* Now try to get the SD card's operating condition */
		err = sd_send_op_cond(mmc);
	
		/* If the command timed out, we check for an MMC card */
		if (err == TIMEOUT) {
			err = mmc_send_op_cond(mmc);
	
			if (err) {
				printf("[%s] %s:%d, SD or TSD: Card did not respond to voltage select! "
                        "mmc->block_dev.if_type=%d\n",
                        __FUNCTION__, mmc->name, mmc->block_dev.dev, mmc->block_dev.if_type);
				return UNUSABLE_ERR;
			}
		}
	}
	else
	{
		err = mmc_send_op_cond(mmc);
		if (err) {
				printf("[%s] %s:%d, eMMC: Card did not respond to voltage select! "
                        "mmc->block_dev.if_type=%d\n",
                        __FUNCTION__, mmc->name, mmc->block_dev.dev, mmc->block_dev.if_type);
            return UNUSABLE_ERR;
		}
	}

	err = mmc_startup(mmc);
	printf("[%s] %s:%d, if_type=%d, initialized %s!\n", __FUNCTION__,
            mmc->name, mmc->block_dev.dev, mmc->block_dev.if_type, (err==0)? "OK": "ERROR");
	if(err){
		return err;
	} else {
        mmc->is_inited = true; // init OK
    }

    if (aml_is_emmc_tsd(mmc)) { // eMMC OR TSD
#if defined (CONFIG_PARTITIONS_STORE)
       if (0 == is_init_partition_flag) {
            mmc_device_partitions(mmc);
            is_init_partition_flag = 1;
            printf("eMMC/TSD partition table have been checked OK!\n");
        }
#endif
#ifdef CONFIG_STORE_COMPATIBLE
	    if (!is_partition_checked) {
			
#if defined(CONFIG_SECURITYKEY) && defined(CONFIG_STORE_COMPATIBLE)
		info_disprotect |= DISPROTECT_KEY; //disprotect key
#endif
            if (mmc_device_init(mmc) == 0) {
                is_partition_checked = true;
                printk("eMMC/TSD partition table have been checked OK!\n");
#endif
			#ifdef CONFIG_SECURITYKEY
				err = emmc_key_init(mmc);
				if(err){
					printf("%s:%d,emmc key fail\n",__func__,__LINE__);
				}
                // emmc_key_read();
                // emmc_key_write();
			#endif
			#ifdef CONFIG_SECURE_MMC			
				err = mmc_storage_probe(mmc);
				if(err){
					printf("%s:%d,mmc storage  fail\n",__func__,__LINE__);
				}
			#endif
#ifdef CONFIG_STORE_COMPATIBLE
            }
            else
                printk("eMMC/TSD partition table have been checked ERROR!\n");
			
#if defined(CONFIG_SECURITYKEY) && defined(CONFIG_STORE_COMPATIBLE)
	info_disprotect &= ~DISPROTECT_KEY; //protect key
#endif

        }
#endif
    }


    return err;
}

/*
 * CPU and board-specific MMC initializations.  Aliased function
 * signals caller to move on
 */
static int __def_mmc_init(bd_t *bis)
{
	return -1;
}

int cpu_mmc_init(bd_t *bis) __attribute__((weak, alias("__def_mmc_init")));
int board_mmc_init(bd_t *bis) __attribute__((weak, alias("__def_mmc_init")));

void print_mmc_devices(char separator)
{
	struct mmc *m;
	struct list_head *entry;

	list_for_each(entry, &mmc_devices) {
		m = list_entry(entry, struct mmc, link);

		printf("%s: %d", m->name, m->block_dev.dev);

		if (entry->next != &mmc_devices)
			printf("%c ", separator);
	}

	printf("\n");
}

int mmc_initialize(bd_t *bis)
{
	INIT_LIST_HEAD (&mmc_devices);
	cur_dev_num = 0;

	if (board_mmc_init(bis) < 0)
		cpu_mmc_init(bis);

	print_mmc_devices(',');

	return 0;
}
