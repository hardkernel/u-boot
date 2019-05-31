
/*
 * drivers/mmc/aml_sd_emmc.c
 *
 * Copyright (C) 2015 Amlogic, Inc. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

#include <common.h>
#include <malloc.h>
//#include <asm/dma-mapping.h>
#include <asm/io.h>
#include <mmc.h>
#include <asm/arch/sd_emmc.h>
#include <asm/arch/cpu_sdio.h>
#ifdef CONFIG_STORE_COMPATIBLE
#include <storage.h>
#endif
#include <asm/cpu_id.h>
//#define SD_DEBUG_ENABLE

#ifdef SD_DEBUG_ENABLE
	#define sd_debug(a...) printf(a);
#else
	#define sd_debug(a...)
#endif

//#define EMMC_DEBUG_ENABLE
#ifdef EMMC_DEBUG_ENABLE
	#define emmc_debug(a...) printf(a);
#else
	#define emmc_debug(a...)
#endif

extern bool aml_is_emmc_tsd (struct mmc *mmc);
/*
 * **********************************************************************************************
 * board relative
 * **********************************************************************************************
 */

unsigned long sd_emmc_base_addr[3] = {SD_EMMC_BASE_A,
										SD_EMMC_BASE_B,
										SD_EMMC_BASE_C};

static struct aml_card_sd_info aml_sd_emmc_ports[]={
    { .sd_emmc_port=SDIO_PORT_A,.name="SDIO Port A"},
    { .sd_emmc_port=SDIO_PORT_B,.name="SDIO Port B"},
    { .sd_emmc_port=SDIO_PORT_C,.name="SDIO Port C"},
};

struct aml_card_sd_info * cpu_sd_emmc_get(unsigned port)
{
    if (port<SDIO_PORT_C+1)
        return &aml_sd_emmc_ports[port];
    return NULL;
}

int aml_fixdiv_calc(struct mmc *mmc)
{
	int ret = 0;
	unsigned int full_div, source_cycle;    /* in ns*/
	unsigned int sdclk_idx, todly_idx_max, todly_idx_min;
	unsigned inv_idx_min, inv_idx_max;
	unsigned int val_idx_min, val_idx_max, val_idx_win, val_idx_sta;

	if (mmc->clk_lay.core == mmc->clk_lay.old_core)
		return 1;
	mmc->clk_lay.old_core = mmc->clk_lay.core;

	printf(">>>calc: source clk %d, core clk %d\n", mmc->clk_lay.source, mmc->clk_lay.core);
	full_div = mmc->clk_lay.source / mmc->clk_lay.core;
	sdclk_idx = full_div / 2;
	sdclk_idx -= full_div % 2 ? 0 : 1;

	printf("full_div %d, sdclk_idx %d\n", full_div, sdclk_idx);
	/* ns */
	source_cycle = 1000000000 / mmc->clk_lay.source;
	printf("cycle of source clock is %d \n", source_cycle);
	if (source_cycle < TODLY_MAX_NS) {
		todly_idx_max = (TODLY_MAX_NS + source_cycle - 1) / source_cycle;
		todly_idx_min = TODLY_MIN_NS / source_cycle;
		printf("todly_idx_min %d, todly_idx_max %d\n", todly_idx_min, todly_idx_max);
		inv_idx_min = todly_idx_min + sdclk_idx;
		inv_idx_max = todly_idx_max + sdclk_idx;
		printf("inv_idx_min %d, inv_idx_max %d\n", inv_idx_min, inv_idx_max);
		inv_idx_min = inv_idx_min % full_div;
		inv_idx_max = inv_idx_max % full_div;
		printf("ROUND: inv_idx_min %d, inv_idx_max %d\n", inv_idx_min, inv_idx_max);

		if (inv_idx_min > inv_idx_max) {
			val_idx_min = inv_idx_max + 1;
			val_idx_max = inv_idx_min - 1;
			val_idx_sta = val_idx_min;
			val_idx_win = val_idx_max - val_idx_min;
		} else if (inv_idx_min <= inv_idx_max) {
			val_idx_max = inv_idx_max + 1;
			val_idx_min = inv_idx_min - 1;
			val_idx_sta = val_idx_max;
			val_idx_win = (full_div + val_idx_min) -  val_idx_max;
		}
	} else {
		val_idx_max = sdclk_idx + 1;
		val_idx_min = sdclk_idx - 1;
		val_idx_sta = val_idx_max;
		val_idx_win = full_div / 2;
		//val_idx_win = (full_div + val_idx_min) -  val_idx_max;
	}

	printf("val_idx_sta %d, val_idx_win %d\n", val_idx_sta, val_idx_win);
	mmc->fixdiv = val_idx_sta + (val_idx_win >> 1);

	printf("fixdiv = %d\n", mmc->fixdiv);
	return ret;
}

void aml_sd_cfg_swth(struct mmc *mmc)
{
	unsigned sd_emmc_clkc =	0,clk,clk_src,clk_div = 0;
	unsigned vconf;
	unsigned bus_width=(mmc->bus_width == 1)?0:mmc->bus_width/4;
	struct aml_card_sd_info *aml_priv = mmc->priv;
	struct sd_emmc_global_regs *sd_emmc_reg = aml_priv->sd_emmc_reg;
	struct sd_emmc_config* sd_emmc_cfg = (struct sd_emmc_config*)&vconf;
	emmc_debug("mmc->clock=%d; clk_div=%d\n",mmc->clock ,clk_div);
	unsigned int adj = 0;

	/* reset gdelay , gadjust register */
	sd_emmc_reg->gdelay = 0;
	sd_emmc_reg->gadjust = 0;

	if (mmc->clock > 12000000) {
		clk = SD_EMMC_CLKSRC_DIV2;
		clk_src = 1;
	}else{
		clk = SD_EMMC_CLKSRC_24M;
		clk_src = 0;
	}

	if (mmc->clock<mmc->cfg->f_min)
	    mmc->clock=mmc->cfg->f_min;
	if (mmc->clock>mmc->cfg->f_max)
	    mmc->clock=mmc->cfg->f_max;

	clk_div= clk / mmc->clock;
#if CONFIG_EMMC_DDR52_EN
	if (mmc->ddr_mode) {
		clk_div /= 2;
		sd_debug("DDR: \n");
	}
#endif

	sd_emmc_clkc =((0 << Cfg_irq_sdio_sleep_ds) |
						(0 << Cfg_irq_sdio_sleep) |
						(1 << Cfg_always_on) |
						(0 << Cfg_rx_delay) |
						(0 << Cfg_tx_delay) |
						(0 << Cfg_sram_pd) |
						(0 << Cfg_rx_phase) |
						(0 << Cfg_tx_phase) |
						(2 << Cfg_co_phase) |
						(clk_src << Cfg_src) |
						(clk_div << Cfg_div));


	sd_emmc_reg->gclock = sd_emmc_clkc;
	vconf = sd_emmc_reg->gcfg;

	sd_emmc_cfg->bus_width = bus_width;     //1bit mode
    sd_emmc_cfg->bl_len = 9;      //512byte block length
    sd_emmc_cfg->resp_timeout = 7;      //64 CLK cycle, here 2^8 = 256 clk cycles
    sd_emmc_cfg->rc_cc = 4;      //1024 CLK cycle, Max. 100mS.
#if CONFIG_EMMC_DDR52_EN
    sd_emmc_cfg->ddr = mmc->ddr_mode;
#endif
    sd_emmc_reg->gcfg = vconf;

    sd_emmc_para_config(sd_emmc_reg, mmc->clock, aml_priv->sd_emmc_port);

	if (mmc->cfg->ops->calc && (!strcmp(mmc->cfg->name, "SDIO Port C"))) {
		mmc->clk_lay.source = mmc->clock * clk_div;
		mmc->clk_lay.core = mmc->clock;
		if (!mmc->cfg->ops->calc(mmc)) {
			sd_emmc_clkc = sd_emmc_reg->gclock;
			sd_emmc_clkc &= ~(3 << Cfg_tx_phase);
			sd_emmc_clkc &= ~(3 << Cfg_co_phase);
			sd_emmc_clkc |= (2 << Cfg_tx_phase);
			sd_emmc_reg->gclock = sd_emmc_clkc;
			adj |= (mmc->fixdiv << 16);
			adj |= (1 << 13);
			sd_emmc_reg->gadjust = adj;
			printf("fixdiv calc done: clk = 0x%x, adj = 0x%x\n", sd_emmc_clkc, adj);
		}
	}

    printf("co-phase 0x%x, tx-dly %d, clock %d\n",
        (sd_emmc_reg->gclock >> Cfg_co_phase) & 3,
        (sd_emmc_reg->gclock >> Cfg_tx_delay) & 0x3f,
        mmc->clock);

    emmc_debug("bus_width=%d; tclk_div=%d; tclk=%d;sd_clk=%d\n",
        bus_width,clk_div,clk,mmc->clock);
    emmc_debug("port=%d act_clk=%d\n",aml_priv->sd_emmc_port,clk/clk_div);
    return;
}

static int sd_inand_check_insert(struct	mmc	*mmc)
{
	int level;
	struct aml_card_sd_info *sd_inand_info = mmc->priv;

	level = sd_inand_info->sd_emmc_detect(sd_inand_info->sd_emmc_port);

	if (level) {

		if (sd_inand_info->init_retry) {
			sd_inand_info->sd_emmc_pwr_off(sd_inand_info->sd_emmc_port);
			sd_inand_info->init_retry = 0;
		}
		if (sd_inand_info->inited_flag) {
			sd_inand_info->sd_emmc_pwr_off(sd_inand_info->sd_emmc_port);
			sd_inand_info->removed_flag = 1;
			sd_inand_info->inited_flag = 0;
		}
		return 0;				//No card is inserted
	} else {
		return 1;				//A	card is	inserted
	}
}

//Clear response data buffer
static void sd_inand_clear_response(unsigned * res_buf)
{
	int i;
	if (res_buf == NULL)
		return;

	for (i = 0; i < MAX_RESPONSE_BYTES; i++)
		res_buf[i]=0;
}

/*
static int sd_inand_check_response(struct mmc_cmd *cmd)
{
	int ret = SD_NO_ERROR;
	SD_Response_R1_t *r1 = (SD_Response_R1_t *)cmd->response;
	switch (cmd->resp_type) {
	case MMC_RSP_R1:
	case MMC_RSP_R1b:
		if (r1->card_status.OUT_OF_RANGE)
			return SD_ERROR_OUT_OF_RANGE;
		else if (r1->card_status.ADDRESS_ERROR)
			return SD_ERROR_ADDRESS;
		else if (r1->card_status.BLOCK_LEN_ERROR)
			return SD_ERROR_BLOCK_LEN;
		else if (r1->card_status.ERASE_SEQ_ERROR)
			return SD_ERROR_ERASE_SEQ;
		else if (r1->card_status.ERASE_PARAM)
			return SD_ERROR_ERASE_PARAM;
		else if (r1->card_status.WP_VIOLATION)
			return SD_ERROR_WP_VIOLATION;
		else if (r1->card_status.CARD_IS_LOCKED)
			return SD_ERROR_CARD_IS_LOCKED;
		else if (r1->card_status.LOCK_UNLOCK_FAILED)
			return SD_ERROR_LOCK_UNLOCK_FAILED;
		else if (r1->card_status.COM_CRC_ERROR)
			return SD_ERROR_COM_CRC;
		else if (r1->card_status.ILLEGAL_COMMAND)
			return SD_ERROR_ILLEGAL_COMMAND;
		else if (r1->card_status.CARD_ECC_FAILED)
			return SD_ERROR_CARD_ECC_FAILED;
		else if (r1->card_status.CC_ERROR)
			return SD_ERROR_CC;
		else if (r1->card_status.ERROR)
			return SD_ERROR_GENERAL;
		else if (r1->card_status.CID_CSD_OVERWRITE)
			return SD_ERROR_CID_CSD_OVERWRITE;
		else if (r1->card_status.AKE_SEQ_ERROR)
			return SD_ERROR_AKE_SEQ;
		break;
	default:
		break;
	}
	return ret;
}*/
extern unsigned sd_debug_board_1bit_flag;
static int sd_inand_staff_init(struct mmc *mmc)
{
	struct aml_card_sd_info * sdio=mmc->priv;
	//unsigned base;

	sd_debug("");
    sdio->sd_emmc_pwr_prepare(sdio->sd_emmc_port);
	sd_debug("power off");
	sdio->sd_emmc_pwr_off(sdio->sd_emmc_port);
	//try to init mmc controller clock firstly
	mmc->clock = 400000;
	aml_sd_cfg_swth(mmc);
	//only power ctrl for external tf card
	if (sdio->sd_emmc_port == SDIO_PORT_B) {
		//base=get_timer(0);
#if defined(CONFIG_VLSI_EMULATOR)
	    //while (get_timer(base)<1) ;
#else
		//while (get_timer(base)<200) ;
#endif
    }
    sdio->sd_emmc_pwr_on(sdio->sd_emmc_port);
    sdio->sd_emmc_init(sdio->sd_emmc_port);
	if (sd_debug_board_1bit_flag == 1) {
        struct mmc_config *cfg;
        cfg = &((struct aml_card_sd_info *)mmc->priv)->cfg;
        cfg->host_caps = MMC_MODE_HS;
        mmc->cfg = cfg;
    }
    //only power ctrl for external tf card
    if (sdio->sd_emmc_port == SDIO_PORT_B) {
        //base=get_timer(0);
#if defined(CONFIG_VLSI_EMULATOR)
        //while (get_timer(base)<1) ;
#else
        //while (get_timer(base)<200) ;
#endif
    }
    if (!sdio->inited_flag)
        sdio->inited_flag = 1;
	return SD_NO_ERROR;
}


/*
 * **********************************************************************************************
 * u-boot interface function
 * **********************************************************************************************
 */

int aml_sd_send_cmd_ffu(struct mmc *mmc, struct mmc_cmd *cmd, struct mmc_data *data)
{
	int ret = SD_NO_ERROR;
	u32 resp_buffer;
	u32 vstart = 0;
	u32 status_irq = 0;
	u32 *write_buffer = NULL;
	struct sd_emmc_status *status_irq_reg = (void *)&status_irq;
	struct sd_emmc_start *desc_start = (struct sd_emmc_start*)&vstart;
	struct aml_card_sd_info *aml_priv = mmc->priv;
	struct sd_emmc_global_regs *sd_emmc_reg = aml_priv->sd_emmc_reg;
	struct cmd_cfg *des_cmd_cur = NULL;
	struct sd_emmc_desc_info *desc_cur = (struct sd_emmc_desc_info*)aml_priv->desc_buf;
	u32 blks = 0, desc_cnt = 0;

	memset(desc_cur, 0, (NEWSD_MAX_DESC_MUN>>2)*sizeof(struct sd_emmc_desc_info));

	des_cmd_cur = (struct cmd_cfg *)&(desc_cur->cmd_info);
	des_cmd_cur->cmd_index = 0x80 | cmd->cmdidx; //bit:31 owner = 1 bit:24-29 cmdidx
	desc_cur->cmd_arg = cmd->cmdarg;

	sd_inand_clear_response(cmd->response);

	//check response type
	if (cmd->resp_type & MMC_RSP_PRESENT) {
		resp_buffer = (unsigned long)cmd->response;
		des_cmd_cur->no_resp = 0;

		//save Resp into Resp addr, and check response from register for RSP_136
		if (cmd->resp_type & MMC_RSP_136)
			des_cmd_cur->resp_128 = 1;

		if (cmd->resp_type & MMC_RSP_BUSY)
			des_cmd_cur->r1b = 1;    //check data0 busy after R1 reponse

		if (!(cmd->resp_type & MMC_RSP_CRC))
			des_cmd_cur->resp_nocrc = 1;

		des_cmd_cur->resp_num = 0;
		desc_cur->resp_addr = resp_buffer;
	}else
		des_cmd_cur->no_resp = 1;

	if (data) {
		des_cmd_cur->data_io = 1; // cmd has data read or write
		if (data->flags == MMC_DATA_WRITE) {
			write_buffer = (u32 *)malloc(data->blocks * data->blocksize);
			memset(write_buffer, 0, data->blocks * data->blocksize);
			memcpy(write_buffer, (u32 *)data->src, data->blocks*data->blocksize);
			flush_dcache_range((unsigned)(long)write_buffer,(unsigned long)(write_buffer+data->blocks*data->blocksize));
			if (data->blocks > 1) {
				blks = data->blocks;
				desc_cnt = 0;
				while (blks) {
					des_cmd_cur = (struct cmd_cfg *)&(desc_cur->cmd_info);
					des_cmd_cur->block_mode = 1;
					if (blks > 511) {
						des_cmd_cur->length = 511;
						blks -= 511;
					} else {
						des_cmd_cur->length = blks;
						blks = 0;
					}
					if (desc_cnt != 0) {
						des_cmd_cur->no_resp = 1;
						des_cmd_cur->no_cmd = 1;
					}
					des_cmd_cur->data_num = 0;
					des_cmd_cur->data_io = 1; // cmd has data read or write
					des_cmd_cur->owner = 1;
					des_cmd_cur->data_wr = 1;
					desc_cur->data_addr = ((unsigned long)(write_buffer) + (desc_cnt * 511 * 512));
					desc_cur->data_addr &= ~(1<<0);   //DDR
					if (blks) {
						desc_cur++;
						desc_cnt++;
						memset(desc_cur, 0, sizeof(struct sd_emmc_desc_info));
					}
				}
			} else {
				printf("data blks < 1\n");
				return 1;
			}
		} else {
			printf("ffu (flags == read) error\n");
			return 1;
		}
	}

	/*Prepare desc for config register*/
	des_cmd_cur->end_of_chain = 1; //the end flag of descriptor chain
	sd_emmc_reg->gstatus = NEWSD_IRQ_ALL;

	invalidate_dcache_range((unsigned long)aml_priv->desc_buf,
			(unsigned long)(aml_priv->desc_buf+NEWSD_MAX_DESC_MUN*(sizeof(struct sd_emmc_desc_info))));
	//start transfer cmd
	desc_start->init = 0;
	desc_start->busy = 1;
	desc_start->addr = (unsigned long)aml_priv->desc_buf >> 2;

	sd_emmc_reg->gstart = vstart;

	while (1) {
		status_irq = sd_emmc_reg->gstatus;
		if (status_irq_reg->end_of_chain)
			break;
	}
	if (status_irq_reg->rxd_err) {
		ret |= SD_EMMC_RXD_ERROR;
		if (!mmc->refix)
			printf("emmc/sd read error, cmd%d, status=0x%x\n",
					cmd->cmdidx, status_irq);
	}
	if (status_irq_reg->txd_err) {
		ret |= SD_EMMC_TXD_ERROR;
		if (!mmc->refix)
			printf("emmc/sd write error, cmd%d, status=0x%x\n",
					cmd->cmdidx, status_irq);
	}
	if (status_irq_reg->desc_err) {
		ret |= SD_EMMC_DESC_ERROR;
		if (!mmc->refix)
			printf("emmc/sd descripter error, cmd%d, status=0x%x\n",
					cmd->cmdidx, status_irq);
	}
	if (status_irq_reg->resp_err) {
		ret |= SD_EMMC_RESP_CRC_ERROR;
		if (!mmc->refix)
			printf("emmc/sd response crc error, cmd%d, status=0x%x\n",
					cmd->cmdidx, status_irq);
	}
	if (status_irq_reg->resp_timeout) {
		ret |= SD_EMMC_RESP_TIMEOUT_ERROR;
		if (!mmc->refix)
			printf("emmc/sd response timeout, cmd%d, status=0x%x\n",
					cmd->cmdidx, status_irq);
	}
	if (status_irq_reg->desc_timeout) {
		ret |= SD_EMMC_DESC_TIMEOUT_ERROR;
		if (!mmc->refix)
			printf("emmc/sd descripter timeout, cmd%d, status=0x%x\n",
					cmd->cmdidx, status_irq);
	}

	if (cmd->resp_type & MMC_RSP_136) {
		cmd->response[0] = sd_emmc_reg->gcmd_rsp3;
		cmd->response[1] = sd_emmc_reg->gcmd_rsp2;
		cmd->response[2] = sd_emmc_reg->gcmd_rsp1;
		cmd->response[3] = sd_emmc_reg->gcmd_rsp0;
	} else {
		cmd->response[0] = sd_emmc_reg->gcmd_rsp0;
	}

	sd_debug("cmd->cmdidx = %d, cmd->cmdarg=0x%x, ret=0x%x\n",cmd->cmdidx,cmd->cmdarg,ret);
	sd_debug("cmd->response[0]=0x%x;\n",cmd->response[0]);
	sd_debug("cmd->response[1]=0x%x;\n",cmd->response[1]);
	sd_debug("cmd->response[2]=0x%x;\n",cmd->response[2]);
	sd_debug("cmd->response[3]=0x%x;\n",cmd->response[3]);
	if (des_cmd_cur->data_wr == 1) {
		free(write_buffer);
		write_buffer = NULL;
	}
	if (ret) {
		if (status_irq_reg->resp_timeout)
			return TIMEOUT;
		else
			return ret;
	}

	return SD_NO_ERROR;
}

/*
 * Sends a command out on the bus. Takes the mmc pointer,
 * a command pointer, and an optional data pointer.
 */
int aml_sd_send_cmd(struct mmc *mmc, struct mmc_cmd *cmd, struct mmc_data *data)
{
        int ret = SD_NO_ERROR;
        //u32 vconf;
        u32 buffer = 0;
        u32 resp_buffer;
        u32 vstart = 0;
        u32 status_irq = 0;
        //u32 inalign = 0;
        u32 *write_buffer = NULL;
        struct sd_emmc_status *status_irq_reg = (void *)&status_irq;
        struct sd_emmc_start *desc_start = (struct sd_emmc_start*)&vstart;
        //struct sd_emmc_config* sd_emmc_cfg = (struct sd_emmc_config*)&vconf;
        struct aml_card_sd_info *aml_priv = mmc->priv;
        struct sd_emmc_global_regs *sd_emmc_reg = aml_priv->sd_emmc_reg;
        struct cmd_cfg *des_cmd_cur = NULL;
        struct sd_emmc_desc_info *desc_cur = (struct sd_emmc_desc_info*)aml_priv->desc_buf;

        //vconf = sd_emmc_reg->gcfg;

        memset(desc_cur, 0, (NEWSD_MAX_DESC_MUN>>2)*sizeof(struct sd_emmc_desc_info));

        des_cmd_cur = (struct cmd_cfg *)&(desc_cur->cmd_info);
        des_cmd_cur->cmd_index = 0x80 | cmd->cmdidx; //bit:31 owner = 1 bit:24-29 cmdidx
        desc_cur->cmd_arg = cmd->cmdarg;

        sd_inand_clear_response(cmd->response);

        //check response type
        if (cmd->resp_type & MMC_RSP_PRESENT) {
                resp_buffer = (unsigned long)cmd->response;//dma_map_single((void*)cmd->response,sizeof(uint)*4,DMA_FROM_DEVICE);
                des_cmd_cur->no_resp = 0;

                //save Resp into Resp addr, and check response from register for RSP_136
                if (cmd->resp_type & MMC_RSP_136)
                        des_cmd_cur->resp_128 = 1;

                if (cmd->resp_type & MMC_RSP_BUSY)
                        des_cmd_cur->r1b = 1;    //check data0 busy after R1 reponse

                if (!(cmd->resp_type & MMC_RSP_CRC))
                        des_cmd_cur->resp_nocrc = 1;

                des_cmd_cur->resp_num = 0;
                desc_cur->resp_addr = resp_buffer;
        }else
                des_cmd_cur->no_resp = 1;

        if (data) {
                des_cmd_cur->data_io = 1; // cmd has data read or write
                if (data->flags == MMC_DATA_READ) {
                        des_cmd_cur->data_wr = 0;  //read data from sd/emmc
                        buffer = (unsigned long)data->dest;//dma_map_single((void*)data->dest,data->blocks*data->blocksize,DMA_FROM_DEVICE);
                        invalidate_dcache_range((unsigned long)data->dest, (unsigned long)(data->dest+data->blocks*data->blocksize));
                }else{
                        des_cmd_cur->data_wr = 1;
                        //buffer = (unsigned long)data->src;//dma_map_single((void*)data->src,data->blocks*data->blocksize,DMA_TO_DEVICE);//(char *)data->src;
                        write_buffer = (u32 *)malloc(128*1024);
                        memset(write_buffer, 0 ,128*1024);
                        memcpy(write_buffer, (u32 *)data->src, data->blocks*data->blocksize);
                        flush_dcache_range((unsigned)(long)write_buffer,(unsigned long)(write_buffer+data->blocks*data->blocksize));
                }

                if (data->blocks > 1) {
                        des_cmd_cur->block_mode = 1;
                        des_cmd_cur->length = data->blocks;
                }else{
                        des_cmd_cur->block_mode = 0;
                        des_cmd_cur->length = data->blocksize;
                }
                des_cmd_cur->data_num = 0;
                if (des_cmd_cur->data_wr == 1)
                        desc_cur->data_addr = (unsigned long)write_buffer;
                else
                        desc_cur->data_addr = buffer;
                desc_cur->data_addr &= ~(1<<0);   //DDR

        }
        if (data) {
                if ((data->blocks*data->blocksize <0x200) && (data->flags == MMC_DATA_READ)) {
                        desc_cur->data_addr = (unsigned long)sd_emmc_reg->gping;
                        desc_cur->data_addr |= 1<<0;
                }
                //des_cmd_cur->timeout = 7;
        }
        /*Prepare desc for config register*/
        des_cmd_cur->owner = 1;
        des_cmd_cur->end_of_chain = 0;

        //sd_emmc_reg->gcfg = vconf;

        des_cmd_cur->end_of_chain = 1; //the end flag of descriptor chain

        sd_emmc_reg->gstatus = NEWSD_IRQ_ALL;

        invalidate_dcache_range((unsigned long)aml_priv->desc_buf,
                        (unsigned long)(aml_priv->desc_buf+NEWSD_MAX_DESC_MUN*(sizeof(struct sd_emmc_desc_info))));
        //start transfer cmd
        desc_start->init = 0;
        desc_start->busy = 1;
        desc_start->addr = (unsigned long)aml_priv->desc_buf >> 2;
#if 0
        sd_emmc_reg->gstart = vstart;
#else
        sd_emmc_reg->gcmd_cfg = desc_cur->cmd_info;
        sd_emmc_reg->gcmd_dat = desc_cur->data_addr;
        sd_emmc_reg->gcmd_arg = desc_cur->cmd_arg;
#endif
    //waiting end of chain
        //mmc->refix = 0;
        while (1) {
                status_irq = sd_emmc_reg->gstatus;
                if (status_irq_reg->end_of_chain)
                        break;
        }
        if (status_irq_reg->rxd_err) {
                ret |= SD_EMMC_RXD_ERROR;
                if (!mmc->refix)
                    printf("emmc/sd read error, cmd%d, status=0x%x\n",
                        cmd->cmdidx, status_irq);
        }
        if (status_irq_reg->txd_err) {
                ret |= SD_EMMC_TXD_ERROR;
                if (!mmc->refix)
                    printf("emmc/sd write error, cmd%d, status=0x%x\n",
                        cmd->cmdidx, status_irq);
        }
        if (status_irq_reg->desc_err) {
                ret |= SD_EMMC_DESC_ERROR;
                if (!mmc->refix)
                    printf("emmc/sd descripter error, cmd%d, status=0x%x\n",
                        cmd->cmdidx, status_irq);
        }
        if (status_irq_reg->resp_err) {
                ret |= SD_EMMC_RESP_CRC_ERROR;
                if (!mmc->refix)
                    printf("emmc/sd response crc error, cmd%d, status=0x%x\n",
                        cmd->cmdidx, status_irq);
        }
        if (status_irq_reg->resp_timeout) {
                ret |= SD_EMMC_RESP_TIMEOUT_ERROR;
                if (!mmc->refix)
                    printf("emmc/sd response timeout, cmd%d, status=0x%x\n",
                        cmd->cmdidx, status_irq);
        }
        if (status_irq_reg->desc_timeout) {
                ret |= SD_EMMC_DESC_TIMEOUT_ERROR;
                if (!mmc->refix)
                    printf("emmc/sd descripter timeout, cmd%d, status=0x%x\n",
                        cmd->cmdidx, status_irq);
        }
        if (data) {
                if ((data->blocks*data->blocksize <0x200) && (data->flags == MMC_DATA_READ)) {
                        memcpy(data->dest, (const void *)sd_emmc_reg->gping,data->blocks*data->blocksize);
                }
        }
        /*we get response [0]:bit0~31
         *        response [1]:bit32~63
         *        response [2]:bit64~95
         *        response [3]:bit96~127
         * actually mmc driver definition is:
         *		 response [0]:bit96~127
         *        response [1]:bit64~95
         *        response [2]:bit32~63
         *        response [3]:bit0~31
         */

        if (cmd->resp_type & MMC_RSP_136) {
                cmd->response[0] = sd_emmc_reg->gcmd_rsp3;
                cmd->response[1] = sd_emmc_reg->gcmd_rsp2;
                cmd->response[2] = sd_emmc_reg->gcmd_rsp1;
                cmd->response[3] = sd_emmc_reg->gcmd_rsp0;
        } else {
                cmd->response[0] = sd_emmc_reg->gcmd_rsp0;
        }


        sd_debug("cmd->cmdidx = %d, cmd->cmdarg=0x%x, ret=0x%x\n",cmd->cmdidx,cmd->cmdarg,ret);
        sd_debug("cmd->response[0]=0x%x;\n",cmd->response[0]);
        sd_debug("cmd->response[1]=0x%x;\n",cmd->response[1]);
        sd_debug("cmd->response[2]=0x%x;\n",cmd->response[2]);
        sd_debug("cmd->response[3]=0x%x;\n",cmd->response[3]);
        if (des_cmd_cur->data_wr == 1) {
                free(write_buffer);
                write_buffer = NULL;
        }
        if (ret) {
                if (status_irq_reg->resp_timeout)
                        return TIMEOUT;
                else
                        return ret;
        }

        return SD_NO_ERROR;
}

int aml_sd_init(struct mmc *mmc)
{
	struct aml_card_sd_info *sdio=mmc->priv;

    if (sdio->inited_flag) {
		sdio->sd_emmc_init(sdio->sd_emmc_port);
		mmc->cfg->ops->set_ios(mmc);
        return 0;
    }

	if (sd_inand_check_insert(mmc)) {
		sd_inand_staff_init(mmc);
		return 0;
	} else
		return 1;
}

#define MAX_CALI_RETRY	(3)
#define MAX_DELAY_CNT	(16)
#define CALI_BLK_CNT	(10)
#define REFIX_BLK_CNT	(100)
#define CALI_PATTERN_ADDR	(0x13800)
u8 line_x, cal_time;
u8 dly_tmp;
u8 max_index;

int aml_send_calibration_blocks(struct mmc *mmc, char *buffer, u32 start_blk, u32 cnt)
{
	int err = 0, ret = 0;
	struct mmc_cmd cmd = {0};
	struct mmc_cmd stop = {0};
	struct mmc_data data = {{0}, 0};

	stop.cmdidx = MMC_CMD_STOP_TRANSMISSION;
	stop.cmdarg = 0;
	stop.resp_type = MMC_RSP_R1b;

	if (cnt > 1)
		cmd.cmdidx = MMC_CMD_READ_MULTIPLE_BLOCK;
	else
		cmd.cmdidx = MMC_CMD_READ_SINGLE_BLOCK;
	cmd.cmdarg = start_blk;          //start address = 0
	cmd.resp_type = MMC_RSP_R1;

	data.dest = buffer;
	data.blocks = cnt;
	data.blocksize = mmc->read_bl_len;
	data.flags = MMC_DATA_READ;

	err = aml_sd_send_cmd(mmc, &cmd, &data);
	if (err)
		emmc_debug("%s [%d] send calibration read blocks error %d cnt = %d\n", __func__, __LINE__, err, cnt);
	if (cnt > 1 || err) {
		ret = aml_sd_send_cmd(mmc, &stop, NULL);
		if (ret)
		emmc_debug("%s [%d] send calibration stop blocks error %d\n", __func__, __LINE__, ret);
	}
	if (ret || err)
		return -1;
	return 0;
}

int sd_emmc_test_adj(struct mmc *mmc)
{
	int err = 0, ret = 0;
	struct mmc_cmd cmd = {0};
	struct mmc_cmd stop = {0};
	struct mmc_data data = {{0}, 0};
	char *blk_test = NULL;

	struct aml_card_sd_info *aml_priv = mmc->priv;
	struct sd_emmc_global_regs *sd_emmc_reg = aml_priv->sd_emmc_reg;
	u32 adjust = sd_emmc_reg->gadjust;
	struct sd_emmc_adjust *gadjust = (struct sd_emmc_adjust *)&adjust;
	u32 vclk, clk_div, retry;
	struct sd_emmc_clock *clkc = (struct sd_emmc_clock *)&(vclk);
	vclk = sd_emmc_reg->gclock;
	clk_div = clkc->div;
	retry = clk_div;

	blk_test = malloc(0x400 * mmc->read_bl_len);
	if (!blk_test)
		return -1;

	stop.cmdidx = MMC_CMD_STOP_TRANSMISSION;
	stop.cmdarg = 0;
	stop.resp_type = MMC_RSP_R1b;

	cmd.cmdarg = 0x14000;
	cmd.cmdidx = MMC_CMD_READ_MULTIPLE_BLOCK;
	cmd.resp_type = MMC_RSP_R1;

	data.dest = blk_test;
	data.blocks = 0x400;
	data.blocksize = mmc->read_bl_len;
	data.flags = MMC_DATA_READ;

__Retry:
	err = aml_sd_send_cmd(mmc, &cmd, &data);
	if (err)
		emmc_debug("%s [%d] send test read blocks error %d\n", __func__, __LINE__, err);
	ret = aml_sd_send_cmd(mmc, &stop, NULL);
	if (ret)
		emmc_debug("%s [%d] send test stop blocks error %d\n", __func__, __LINE__, ret);

	if (ret || err) {
		if (retry == 0) {
			free(blk_test);
			return 1;
		}
		retry--;
		gadjust->adj_delay--;
		sd_emmc_reg->gadjust = adjust;
		printf("adj retry sampling point:(%d)->(%d)",
			gadjust->adj_delay+1, gadjust->adj_delay);
		emmc_debug("%s [%d]:  delay = 0x%x   gadjust =0x%x\n",
			__func__, __LINE__, sd_emmc_reg->gdelay, sd_emmc_reg->gadjust);
		goto __Retry;
	}
	free(blk_test);
	return 0;
}

int aml_sd_retry_refix(struct mmc *mmc)
{
	struct aml_card_sd_info *aml_priv = mmc->priv;
	struct sd_emmc_global_regs *sd_emmc_reg = aml_priv->sd_emmc_reg;
	u32 start_blk = 0;
	u32 vclk, clk_div;
	struct sd_emmc_clock *clkc = (struct sd_emmc_clock *)&(vclk);
	u32 adjust = sd_emmc_reg->gadjust;
	struct sd_emmc_adjust *gadjust = (struct sd_emmc_adjust *)&adjust;
	int err = 0, ret = 0, adj_delay = 0;
	char *blk_test = NULL;
#ifdef MMC_HS200_MODE
	int pre_status = 0;
	int start = 0;
#endif
	emmc_debug("tuning..................\n");

	//const u8 *blk_pattern = tuning_data->blk_pattern;
	//u8 *blk_test;
	//unsigned int blksz = tuning_data->blksz;
	//int ret = 0;
	int n, nmatch, ntries = 10;
	int wrap_win_start = -1, wrap_win_size = 0;
	int best_win_start = -1, best_win_size = -1;
	int curr_win_start = -1, curr_win_size = 0;
	u8 rx_tuning_result[25/SAMPLE_STEP_COUNT] = { 0 };

	blk_test = malloc(REFIX_BLK_CNT * mmc->read_bl_len);
	if (!blk_test)
		return -1;
	vclk = sd_emmc_reg->gclock;
	clk_div = clkc->div;

	for (adj_delay = 0; adj_delay < clk_div; adj_delay+=SAMPLE_STEP_COUNT) {
		// Perform tuning ntries times per clk_div increment
		gadjust->adj_delay = adj_delay;
		gadjust->adj_enable = 1;
		gadjust->cali_enable = 0;
		gadjust->cali_rise = 0;
		sd_emmc_reg->gadjust = adjust;
		start_blk = CALI_PATTERN_ADDR;
		emmc_debug("%s [%d]: gadjust =0x%x\n",
			__func__, __LINE__, sd_emmc_reg->gadjust);
		for (n = 0, nmatch = 0; n < ntries; n++) {

			memset(blk_test, 0, REFIX_BLK_CNT);

			err = aml_send_calibration_blocks(mmc, blk_test, start_blk, REFIX_BLK_CNT);

			if (!err && !ret)
				nmatch++;
			else {
				emmc_debug("refix error: adj_delay=%d nmatch=%d err=%d ret=%d\n",adj_delay, nmatch, err, ret);
				break;
			}
		}

		if (adj_delay < sizeof(rx_tuning_result) / sizeof (rx_tuning_result[0]))
			rx_tuning_result[adj_delay] = nmatch;

		if (nmatch == ntries) {
			if (adj_delay == 0)
				wrap_win_start = adj_delay;

			if (wrap_win_start >= 0)
				wrap_win_size += SAMPLE_STEP_COUNT;

			if (curr_win_start < 0)
				curr_win_start = adj_delay;

			curr_win_size += SAMPLE_STEP_COUNT;
		} else {
			if (curr_win_start >= 0) {
				if (best_win_start < 0) {
					best_win_start = curr_win_start;
					best_win_size = curr_win_size;
				}
				else {
					if (best_win_size < curr_win_size) {
						best_win_start = curr_win_start;
						best_win_size = curr_win_size;
					}
				}

				wrap_win_start = -1;
				curr_win_start = -1;
				curr_win_size = 0;
			}
		}
		emmc_debug("adj_delay:[%d]\n", adj_delay);
		emmc_debug("curr_win_start=%d, curr_win_size=%d\n",curr_win_start, curr_win_size);
		emmc_debug("wrap_win_start=%d, wrap_win_size=%d\n",wrap_win_start, wrap_win_size);
		emmc_debug("best_win_start=%d, best_win_size=%d\n\n",best_win_start, best_win_size);
	}

#if 0
	for (n = 0; n <= clkc->div; n++) {
		if (n < sizeof(rx_tuning_result) / sizeof (rx_tuning_result[0]))
			printf("RX[%d]=%d\n", n, rx_tuning_result[n]);
	}
#endif

	if (curr_win_start >= 0) {
		if (best_win_start < 0) {
			best_win_start = curr_win_start;
			best_win_size = curr_win_size;
		} else if (wrap_win_size > 0) {
			// Wrap around case
			if (curr_win_size + wrap_win_size > best_win_size) {
				best_win_start = curr_win_start;
				best_win_size = curr_win_size + wrap_win_size;
			}
		} else if (best_win_size < curr_win_size) {
			best_win_start = curr_win_start;
			best_win_size = curr_win_size;
		}

		curr_win_start = -1;
		curr_win_size = 0;
	}


	if (best_win_start < 0) {
		printf("Tuning failed to find a valid window, using default rx phase\n");
		ret = -1;
		//writel(vclk2_bak, host->base + SDHC_CLK2);
	} else {
		adj_delay = best_win_start + (best_win_size / 2);
		if (adj_delay >= clkc->div)
			adj_delay -= clkc->div;

		gadjust->adj_enable = 1;
		gadjust->cali_enable = 0;
		gadjust->cali_rise = 0;
		gadjust->adj_delay = adj_delay;
		sd_emmc_reg->gadjust = adjust;
	}
	printf("%s[%d]:delay = 0x%x,gadjust =0x%x\n",
		__func__, __LINE__, sd_emmc_reg->gdelay, sd_emmc_reg->gadjust);
	emmc_debug("%s [%d]: adj_delay = %d\n", __func__, __LINE__, adj_delay);
	free(blk_test);

#ifdef MMC_HS200_MODE
	for (n = 0; n < clkc->div; n++) {
		if (n == clkc->div - 1) {
			if (rx_tuning_result[n] == ntries && pre_status == 1)
				printf("meson-mmc: emmc: [ %d -- %d ] is ok\n", start, n);
			else if (rx_tuning_result[n] != ntries && pre_status == -1)
				printf("meson-mmc: emmc: [ %d -- %d ] is nok\n", start, n);
			else if (rx_tuning_result[n] == ntries && pre_status != 1)
				printf("meson-mmc: emmc: [ %d ] is ok\n", n);
			else if (rx_tuning_result[n] != ntries && pre_status == 1)
				printf("meson-mmc: emmc: [ %d ] is nok\n", n);
		}
		if (rx_tuning_result[n] == ntries) {
			if (pre_status == -1) {
				if (start == n - 1)
					printf("meson-mmc: emmc: [ %d ] is nok\n", start);
				else
					printf("meson-mmc: emmc: [ %d -- %d] is nok\n", start, n-1);
			} else if (pre_status == 1)
				continue;
			start = n;
			pre_status = 1;
		} else if (rx_tuning_result[n] != ntries) {
			if (pre_status == 1) {
				if (start == n - 1)
					printf("meson-mmc: emmc: [ %d ] is ok\n", start);
				else
					printf("meson-mmc: emmc: [ %d -- %d ] is ok\n", start, n-1);
			} else if (pre_status == -1)
				continue;
			start = n;
			pre_status = -1;
		}
	}

	printf("meson-mmc: emmc: %s[%d]:delay1 = 0x%x,delay2 = 0x%x, gadjust =0x%x\n",
		__func__, __LINE__, sd_emmc_reg->gdelay,
		sd_emmc_reg->gdelay1,
		sd_emmc_reg->gadjust);
	printf("meson-mmc: emmc: %s [%d]: adj_delay = %d\n", __func__, __LINE__,
			adj_delay);
#endif
/* test adj sampling point*/
	ret = sd_emmc_test_adj(mmc);

	return ret;
}

int aml_sd_calibration(struct mmc *mmc)
{
	struct aml_card_sd_info *aml_priv = mmc->priv;
	struct sd_emmc_global_regs *sd_emmc_reg = aml_priv->sd_emmc_reg;
	cpu_id_t cpu_id = get_cpu_id();
	if (cpu_id.family_id == MESON_CPU_MAJOR_ID_GXBB)
		sd_emmc_reg->gdelay = 0x85854055;
	else if (cpu_id.family_id == MESON_CPU_MAJOR_ID_GXTVBB)
		sd_emmc_reg->gdelay = 0x10101331;
	return 0;
}

static const struct mmc_ops aml_sd_emmc_ops = {
	.send_cmd	= aml_sd_send_cmd,
	.set_ios	= aml_sd_cfg_swth,
	.init		= aml_sd_init,
//	.getcd		= ,
//	.getwp		= ,
#ifdef MMC_ADJ_FIXED
	.calibration = aml_sd_calibration,
	.refix = aml_sd_retry_refix,
#endif
#ifdef MMC_ADJ_FIX_CALC
	.calc = aml_fixdiv_calc,
#endif
};

void sd_emmc_register(struct aml_card_sd_info * aml_priv)
{
	struct mmc_config *cfg;

	aml_priv->removed_flag = 1;
	aml_priv->inited_flag = 0;
	aml_priv->sd_emmc_reg = (struct sd_emmc_global_regs *)sd_emmc_base_addr[aml_priv->sd_emmc_port];

	cfg = &aml_priv->cfg;
	cfg->name = aml_priv->name;
	cfg->ops = &aml_sd_emmc_ops;

	cfg->voltages = MMC_VDD_33_34|MMC_VDD_32_33|MMC_VDD_31_32|MMC_VDD_165_195;
	cfg->host_caps = MMC_MODE_8BIT|MMC_MODE_4BIT | MMC_MODE_HS_52MHz | MMC_MODE_HS |
#if CONFIG_EMMC_DDR52_EN
			     MMC_MODE_HC | MMC_MODE_DDR_52MHz;
#else
			     MMC_MODE_HC;
#endif
	cfg->f_min = 400000;
#ifdef MMC_HS200_MODE
	cfg->f_max = 198000000;
#else
	cfg->f_max = 40000000;
#endif
	/**
	 * For blank emmc, part-type should be unknown.
	 * But fastboot will not happy about this when
	 * gpt or mbr are being flashed.
	 * a predefined parttype had to be added here
	 * to satisfy the fastboot.
	 */
#ifdef CONFIG_AML_GPT
	cfg->part_type = PART_TYPE_EFI;
#else
	cfg->part_type = PART_TYPE_AML;
#endif
	cfg->b_max = 256;
	mmc_create(cfg,aml_priv);
}

bool aml_is_emmc_tsd (struct mmc *mmc) // is eMMC OR TSD
{
    struct aml_card_sd_info * sdio=mmc->priv;

    return ((sdio->sd_emmc_port == SDIO_PORT_C));
}
