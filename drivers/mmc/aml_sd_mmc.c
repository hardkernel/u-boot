/*******************************************************************
 * 
 * Copyright C 2005 by Amlogic, Inc. All Rights Reserved.
 *
 * Description: SD/SDHC/MMC Nike Driver
 *
 * Author: Min Chu
 * Created: 2009-4-3 
 *
 *******************************************************************/

#include <common.h>
#include <malloc.h>
#include <asm/dma-mapping.h>
#include <asm/arch/io.h>
#include <asm/arch/sdio.h>
#include <mmc.h>

#ifdef CONFIG_STORE_COMPATIBLE
#include <asm/arch/storage.h>
#endif

#define sd_debug(a...) debug("[%08u,%s]:",(unsigned int)get_timer(0),__func__);debug(a);debug("\n")
#define PREG_SDIO_CFG     	CBUS_REG_ADDR(SDIO_CONFIG)
#define PREG_SDIO_CMD_ARG 	CBUS_REG_ADDR(CMD_ARGUMENT)
#define PREG_SDIO_CMD_SEND  CBUS_REG_ADDR(CMD_SEND)
#define PREG_SDIO_MULT_CFG  CBUS_REG_ADDR(SDIO_MULT_CONFIG)
#define PREG_SDIO_EXT		CBUS_REG_ADDR(SDIO_EXTENSION)
#define PREG_SDIO_MEM_ADDR  CBUS_REG_ADDR(SDIO_M_ADDR)
#define PREG_SDIO_STAT_IRQ  CBUS_REG_ADDR(SDIO_STATUS_IRQ)
#define PREG_SDIO_IRQ_CFG   CBUS_REG_ADDR(SDIO_IRQ_CONFIG)

unsigned sdio_debug_1bit_flag = 0;
extern void mdelay(unsigned long msec);

/*
 * **********************************************************************************************
 * board relative
 * **********************************************************************************************
 */
/*
int aml_sdio_io_init(struct mmc *mmc, ulong flag)
{
	char *pe[MODSIG_SDIO_MAX];
	int padindex, ret;
	unsigned i, sdio_port;
	aml_module_t sdio_module;
	struct aml_card_sd_info *aml_priv = NULL;
	if(mmc == NULL)
		return -1;
	
	aml_priv = mmc->priv;
	sdio_port = aml_priv->sdio_port;
	
	switch (sdio_port) {
	case 0:
		pe[0] = getenv("MODULE_SDIOA.MODSIG_SDIO_CMD");
		pe[1] = getenv("MODULE_SDIOA.MODSIG_SDIO_CLK");
		pe[2] = getenv("MODULE_SDIOA.MODSIG_SDIO_D0");
		pe[3] = getenv("MODULE_SDIOA.MODSIG_SDIO_D1");
		pe[4] = getenv("MODULE_SDIOA.MODSIG_SDIO_D2");
		pe[5] = getenv("MODULE_SDIOA.MODSIG_SDIO_D3");
		pe[6] = getenv("MODULE_SDIOA.MODSIG_SDIO_DET");
		pe[7] = getenv("MODULE_SDIOA.MODSIG_SDIO_WP");
		pe[8] = getenv("MODULE_SDIOA.MODSIG_SDIO_PWR");
		sdio_module = MODULE_SDIOA;
		break;
	case 1:
		pe[0] = getenv("MODULE_SDIOB.MODSIG_SDIO_CMD");
		pe[1] = getenv("MODULE_SDIOB.MODSIG_SDIO_CLK");
		pe[2] = getenv("MODULE_SDIOB.MODSIG_SDIO_D0");
		pe[3] = getenv("MODULE_SDIOB.MODSIG_SDIO_D1");
		pe[4] = getenv("MODULE_SDIOB.MODSIG_SDIO_D2");
		pe[5] = getenv("MODULE_SDIOB.MODSIG_SDIO_D3");
		pe[6] = getenv("MODULE_SDIOB.MODSIG_SDIO_DET");
		pe[7] = getenv("MODULE_SDIOB.MODSIG_SDIO_WP");
		pe[8] = getenv("MODULE_SDIOB.MODSIG_SDIO_PWR");
		sdio_module = MODULE_SDIOB;
		break;
	case 2:
		pe[0] = getenv("MODULE_SDIOC.MODSIG_SDIO_CMD");
		pe[1] = getenv("MODULE_SDIOC.MODSIG_SDIO_CLK");
		pe[2] = getenv("MODULE_SDIOC.MODSIG_SDIO_D0");
		pe[3] = getenv("MODULE_SDIOC.MODSIG_SDIO_D1");
		pe[4] = getenv("MODULE_SDIOC.MODSIG_SDIO_D2");
		pe[5] = getenv("MODULE_SDIOC.MODSIG_SDIO_D3");
		pe[6] = getenv("MODULE_SDIOC.MODSIG_SDIO_DET");
		pe[7] = getenv("MODULE_SDIOC.MODSIG_SDIO_WP");
		pe[8] = getenv("MODULE_SDIOC.MODSIG_SDIO_PWR");
		sdio_module = MODULE_SDIOC;
		break;
	default:
		break;
	}

	for (i = 0; i < MODSIG_SDIO_MAX; i++) {
		if(pe[i] == NULL) {
			printf("MODULE_SDIO%c io %u error! Use default config.\n", 'A'+ sdio_module - MODULE_SDIOA, i);
			set_default_sdio(sdio_port);
			return 0;
		}
	}
	
	padindex = search_pad(pe[0]);
	ret = switch_padsig(padindex, sdio_module, MODSIG_SDIO_CMD, 1);
	if(ret)
		return -1;
	SD_CMD_PAD = padindex;
	
	padindex = search_pad(pe[1]);
	ret = switch_padsig(padindex, sdio_module, MODSIG_SDIO_CLK, 1);
	if(ret)
		return -1;
	SD_CLK_PAD = padindex;
	
	padindex = search_pad(pe[2]);
	ret = switch_padsig(padindex, sdio_module, MODSIG_SDIO_D0, 1);
	if(ret)
		return -1;
	SD_DAT0_PAD = padindex;
	
	padindex = search_pad(pe[3]);
	ret = switch_padsig(padindex, sdio_module, MODSIG_SDIO_D1, 1);
	if(ret)
		return -1;
	SD_DAT1_PAD = padindex;
	
	padindex = search_pad(pe[4]);
	ret = switch_padsig(padindex, sdio_module, MODSIG_SDIO_D2, 1);
	if(ret)
		return -1;
	SD_DAT2_PAD = padindex;
	
	padindex = search_pad(pe[5]);
	ret = switch_padsig(padindex, sdio_module, MODSIG_SDIO_D3, 1);
	if(ret)
		return -1;
	SD_DAT3_PAD = padindex;
	
	padindex = search_pad(pe[6]);
	ret = switch_padsig(padindex, MODULE_GPIO, 0, 1);
	if(ret)
		return -1;
	SD_DET_PAD = padindex;
	ret = ctrl_padlevel(padindex, 1, 0);
	
	padindex = search_pad(pe[7]);
	ret = switch_padsig(padindex, MODULE_GPIO, 0, 1);
	if(ret)
		return -1;
	SD_WP_PAD = padindex;
	ret = ctrl_padlevel(padindex, 1, 0);
	
	padindex = search_pad(pe[8]);
	ret = switch_padsig(padindex, MODULE_GPIO, 0, 1);
	if(ret)
		return -1;
	SD_PWR_PAD = padindex;
	SD_PWR_EN_LEVEL = 0;
	ret = ctrl_padlevel(padindex, 0, 1);
	return 0;
}
 */
void aml_sd_cfg_swth(struct mmc *mmc)
{
	//DECLARE_GLOBAL_DATA_PTR;
	
	struct aml_card_sd_info *aml_priv = mmc->priv;
    
    
	unsigned long sdio_config =	0;
	
	unsigned bus_width=(mmc->bus_width == 4)?1:0;
	if(mmc->clock<mmc->f_min)
	    mmc->clock=mmc->f_min;
	if(mmc->clock>mmc->f_max)
	    mmc->clock=mmc->f_max;
	
	int clk=clk_get_rate(SDIO_CLKSRC);
	unsigned clk_div=(clk / (2*mmc->clock));
		
    writel(1<<soft_reset_bit, PREG_SDIO_IRQ_CFG);
    mdelay(3);
    //printf("test get_clk81:%d,sdio clk_div:0x%x,clock:%d\n",clk,clk_div,mmc->clock);

	sdio_config = ((2 << sdio_write_CRC_ok_status_bit) |
                      (2 << sdio_write_Nwr_bit) |
                      (3 << m_endian_bit) |
                      (bus_width<<bus_width_bit)|
                      (39 << cmd_argument_bits_bit) |
                      (0 << cmd_out_at_posedge_bit) |
                      (0 << cmd_disable_CRC_bit) |
                      (0 << response_latch_at_negedge_bit) |
                      (clk_div << cmd_clk_divide_bit));

	sd_debug("sdio_config=%x",sdio_config);
	writel(sdio_config, PREG_SDIO_CFG);
	writel((aml_priv->sdio_port & 0x3), PREG_SDIO_MULT_CFG);	//Switch to	SDIO_A/B/C
	
	sd_debug("bus_width=%d\tclk_div=%d\n\tclk=%d\tsd_clk=%d",
	    bus_width,clk_div,clk,mmc->clock);
    	    
	sd_debug("port=%d act_clk=%d",aml_priv->sdio_port,clk/(2*(clk_div+1)));
	return;
}

/*
 * **********************************************************************************************
 * amlgic arc chip SD/MMC card interface function
 * **********************************************************************************************
 */
/*
static void sd_inand_prepare_power(void)
{
	ctrl_padlevel(SD_CMD_PAD, 0, 0);
	ctrl_padlevel(SD_CLK_PAD, 0, 0);
	ctrl_padlevel(SD_DAT0_PAD, 0, 0);
	ctrl_padlevel(SD_DAT1_PAD, 0, 0);
	ctrl_padlevel(SD_DAT2_PAD, 0, 0);
	ctrl_padlevel(SD_DAT3_PAD, 0, 0);
}

static void sd_inand_power_on(void)
{
	ctrl_padlevel(SD_PWR_PAD, 0, !SD_PWR_EN_LEVEL);
	udelay(200*1000);
	ctrl_padlevel(SD_PWR_PAD, 0, SD_PWR_EN_LEVEL);
	udelay(200*1000);
}

static void sd_inand_power_off(void)
{
	ctrl_padlevel(SD_PWR_PAD, 0, !SD_PWR_EN_LEVEL);
}
*/
static int sd_inand_check_insert(struct	mmc	*mmc)
{
	int level;
	struct aml_card_sd_info *sd_inand_info = mmc->priv;
	
#ifdef AML_CARD_SD_INFO_DETAILED
	level = sd_inand_info->sdio_detect(sd_inand_info->sdio_port,sd_inand_info);
#else
	level = sd_inand_info->sdio_detect(sd_inand_info->sdio_port);
#endif
	
	if (level) {
		
		if (sd_inand_info->init_retry) {
			#ifdef AML_CARD_SD_INFO_DETAILED
			sd_inand_info->sdio_pwr_off(sd_inand_info->sdio_port,sd_inand_info);
		    #else
			sd_inand_info->sdio_pwr_off(sd_inand_info->sdio_port);
			#endif
			sd_inand_info->init_retry = 0;
		}
		if (sd_inand_info->inited_flag) {
			 #ifdef AML_CARD_SD_INFO_DETAILED
			sd_inand_info->sdio_pwr_off(sd_inand_info->sdio_port,sd_inand_info);
		    #else
			sd_inand_info->sdio_pwr_off(sd_inand_info->sdio_port);
			#endif
			sd_inand_info->removed_flag = 1;
			sd_inand_info->inited_flag = 0;
		}
		return 0;				//No card is inserted
	} else {
		return 1;				//A	card is	inserted
	}
}

//Clear response data buffer
static void sd_inand_clear_response(char * res_buf)
{
	int i;
	if(res_buf == NULL)
		return;
	
	for(i = 0; i < MAX_RESPONSE_BYTES; i++)
		res_buf[i]=0;
}

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
}

#ifdef AML_CARD_SD_INFO_DETAILED
static int sd_inand_staff_init(struct mmc *mmc)
{
	struct aml_card_sd_info * sdio=mmc->priv;
    unsigned base;
	
	sd_debug("");
    sdio->sdio_pwr_prepare(sdio->sdio_port,sdio);
	sd_debug("power off");
	sdio->sdio_pwr_off(sdio->sdio_port,sdio);
		
	if(sdio->sdio_pwr_flag&CARD_SD_SDIO_PWR_OFF)
	{	
	    sdio->sdio_pwr_flag &=~CARD_SD_SDIO_PWR_OFF;
        base=get_timer(0);
#if defined(CONFIG_VLSI_EMULATOR)
 		while(get_timer(base)<1);
#else
        while(get_timer(base)<200);
#endif 
    }
    sd_debug("pre power on");
    sdio->sdio_pwr_on(sdio->sdio_port,sdio);
    sdio->sdio_init(sdio->sdio_port,sdio);
    sd_debug("post power on");
        
    if(sdio->sdio_pwr_flag&CARD_SD_SDIO_PWR_ON)
    {    	
        sdio->sdio_pwr_flag &=~CARD_SD_SDIO_PWR_ON;
        base=get_timer(0);
#if defined(CONFIG_VLSI_EMULATOR)
 		while(get_timer(base)<1);
#else
        while(get_timer(base)<200);
#endif 
    }
    aml_sd_cfg_swth(mmc);
    if(!sdio->inited_flag)
        sdio->inited_flag = 1;
//    int ret=rom_c();
//    sd_debug("rom_c==%d",rom_c());
//    return ret;
	return SD_NO_ERROR;
}
#else
static int sd_inand_staff_init(struct mmc *mmc)
{
	struct aml_card_sd_info * sdio=mmc->priv;
    unsigned base;
		
	sd_debug("");
    sdio->sdio_pwr_prepare(sdio->sdio_port);
	sd_debug("power off");
	sdio->sdio_pwr_off(sdio->sdio_port);
	
	if(sdio->sdio_port == SDIO_PORT_B){  //only power ctrl for external tf card
        base=get_timer(0);
#if defined(CONFIG_VLSI_EMULATOR)
	    while(get_timer(base)<1);
#else
        while(get_timer(base)<200);
#endif 
    }
    sd_debug("pre power on");
    sdio->sdio_pwr_on(sdio->sdio_port);
    sdio->sdio_init(sdio->sdio_port);
    
    //clear sd d1~d3 pinmux,
    //just for sdio debug board, only can work with 1bit mode
    if((sdio->sdio_port == SDIO_PORT_B)&&(sdio_debug_1bit_flag)){   
    	clrbits_le32(P_PERIPHS_PIN_MUX_2,7<<12);
    	mmc->host_caps = MMC_MODE_HS;
    }
    	
    sd_debug("post power on");
    if(sdio->sdio_port == SDIO_PORT_B){   //only power ctrl for external tf card
        base=get_timer(0);
#if defined(CONFIG_VLSI_EMULATOR)
	    while(get_timer(base)<1);
#else
        while(get_timer(base)<200);
#endif 
    }
    
    aml_sd_cfg_swth(mmc);
    if(!sdio->inited_flag)
        sdio->inited_flag = 1;
//    int ret=rom_c();
//    sd_debug("rom_c==%d",rom_c());
//    return ret;
	return SD_NO_ERROR;
}
#endif


/*
 * **********************************************************************************************
 * u-boot interface function
 * **********************************************************************************************
 */

/*
 * Sends a command out on the bus. Takes the mmc pointer,
 * a command pointer, and an optional data pointer.
 */
int aml_sd_send_cmd(struct mmc *mmc, struct mmc_cmd *cmd, struct	mmc_data *data)
{
	int ret = SD_NO_ERROR, num_res;
	unsigned buffer = 0;
	unsigned int cmd_send = 0;
	SDHW_CMD_Send_Reg_t *cmd_send_reg = (void *)&cmd_send;
    sd_debug("cmd=%d",cmd->cmdidx);
    cmd_send_reg->cmd_data = 0x40 | cmd->cmdidx;
	cmd_send_reg->use_int_window = 1;
	
	unsigned int cmd_ext = 0;
	SDHW_Extension_Reg_t *cmd_ext_reg = (void *)&cmd_ext;

	/* check read/write address overflow */
	switch (cmd->cmdidx) {
	case MMC_CMD_READ_SINGLE_BLOCK:
    case MMC_CMD_READ_MULTIPLE_BLOCK:
	case MMC_CMD_WRITE_SINGLE_BLOCK:
	case MMC_CMD_WRITE_MULTIPLE_BLOCK:
		if(mmc->high_capacity)
			ret = mmc->capacity/mmc->read_bl_len <= cmd->cmdarg;
		else
			ret = mmc->capacity <= cmd->cmdarg;
		if(ret)
			return -1;
		else
			break;
	}
	
	sd_inand_clear_response(cmd->response);
	switch (cmd->resp_type) {
	case MMC_RSP_R1:
	case MMC_RSP_R1b:
	case MMC_RSP_R3:
	case MMC_RSP_R6:
	case MMC_RSP_R7:
		cmd_send_reg->cmd_res_bits = 45;		// RESPONSE	have 7(cmd)+32(respnse)+7(crc)-1 data
		break;
	case MMC_RSP_R2:
		cmd_send_reg->cmd_res_bits = 133;		// RESPONSE	have 7(cmd)+120(respnse)+7(crc)-1 data
		cmd_send_reg->res_crc7_from_8 = 1;
		break;
	default:
		cmd_send_reg->cmd_res_bits = 0;			// NO_RESPONSE
		break;
	}

	switch (cmd->cmdidx) {
	case MMC_CMD_READ_SINGLE_BLOCK:
	case MMC_CMD_READ_MULTIPLE_BLOCK:
	case MMC_CMD_SEND_EXT_CSD:					//same as: SD_CMD_SEND_IF_COND
	case SD_CMD_SWITCH_FUNC:					//same as: MMC_CMD_SWITCH
		if(!data)
			break;
//        dcache_flush();
        
		cmd_send_reg->res_with_data = 1;
		cmd_send_reg->repeat_package_times = data->blocks - 1;
		if(mmc->bus_width == SD_BUS_WIDE)
			cmd_ext_reg->data_rw_number = data->blocksize * 8 + (16 - 1) * 4;
		else
			cmd_ext_reg->data_rw_number = data->blocksize * 8 + 16 - 1;		
		buffer = dma_map_single((void*)data->dest,data->blocks*data->blocksize,DMA_FROM_DEVICE);
		//buffer = data->dest;
		//dcache_invalid_range(buffer,data->blocks<<9);
		break;
	case MMC_CMD_WRITE_SINGLE_BLOCK:
	case MMC_CMD_WRITE_MULTIPLE_BLOCK:
	    
		cmd_send_reg->cmd_send_data = 1;
		cmd_send_reg->repeat_package_times = data->blocks - 1;
		if(mmc->bus_width == SD_BUS_WIDE)
			cmd_ext_reg->data_rw_number = data->blocksize * 8 + (16 - 1) * 4;
		else
			cmd_ext_reg->data_rw_number = data->blocksize * 8 + 16 - 1;
		buffer = dma_map_single((void*)data->src,data->blocks*data->blocksize,DMA_TO_DEVICE);//(char *)data->src;
//        dcache_clean_range(buffer,data->blocks<<9);
//        dcache_flush();
		break;
	case SD_CMD_APP_SEND_SCR:
		cmd_send_reg->res_with_data = 1;
		if(mmc->bus_width == SD_BUS_WIDE)
			cmd_ext_reg->data_rw_number = data->blocksize * 8 + (16 - 1) * 4;
		else
			cmd_ext_reg->data_rw_number = data->blocksize * 8 + 16 - 1;
		//buffer = (char *)data->src;
		//dcache_flush();
		buffer = dma_map_single(data->dest,cmd_ext_reg->data_rw_number,DMA_BIDIRECTIONAL);//(char *)data->src;
		break;
	default:
		break;
	}
	
	//cmd with R1b
	switch (cmd->cmdidx) {
	case MMC_CMD_STOP_TRANSMISSION:
		cmd_send_reg->check_dat0_busy =	1;
		break;
	default:
		break;
	}

	//cmd with R3
	switch (cmd->cmdidx) {
	case MMC_CMD_SEND_OP_COND:
	case SD_CMD_APP_SEND_OP_COND:
		cmd_send_reg->res_without_crc7 = 1;
		break;
	default:
		break;
	}

	#define	SD_READ_BUSY_COUNT		5000000//20
	#define	SD_WRITE_BUSY_COUNT		1000000//500000
	#define	SD_RETRY_COUNT			8
	unsigned int timeout, timeout_count, repeat_time = 0;
	
	if(cmd_send_reg->cmd_send_data){
		if(cmd->cmdidx == MMC_CMD_WRITE_MULTIPLE_BLOCK)
			timeout = SD_WRITE_BUSY_COUNT *	(data->blocks);
		else
			timeout = SD_WRITE_BUSY_COUNT;
	} else {
		if(cmd->cmdidx == MMC_CMD_READ_MULTIPLE_BLOCK)
			timeout = SD_READ_BUSY_COUNT * (data->blocks);
		else
			timeout = SD_READ_BUSY_COUNT;
	}
	
	if(cmd->cmdidx == MMC_CMD_STOP_TRANSMISSION)
		timeout = 2000;

	unsigned int status_irq = 0;
	SDIO_Status_IRQ_Reg_t *status_irq_reg = (void *)&status_irq;
	unsigned int irq_config = 0;
	MSHW_IRQ_Config_Reg_t *irq_config_reg = (void *)&irq_config;   
	
CMD_RETRY:
	status_irq_reg->if_int = 1;
	status_irq_reg->cmd_int = 1;
	sd_debug("PREG_SDIO_STAT_IRQ=%x PREG_SDIO_MEM_ADDR=%x PREG_SDIO_CMD_SEND=%x",status_irq,buffer,cmd_send);
	sd_debug("PREG_SDIO_CMD_ARG =%x      PREG_SDIO_EXT=%x",cmd->cmdarg,cmd_ext);
	
	writel(status_irq|(0x1fff<<19), PREG_SDIO_STAT_IRQ);
	   
 
	writel(cmd->cmdarg, PREG_SDIO_CMD_ARG);
	writel(cmd_ext, PREG_SDIO_EXT);
	writel((unsigned int)buffer, PREG_SDIO_MEM_ADDR);
	writel(cmd_send, PREG_SDIO_CMD_SEND);
    
	timeout_count = 0;
	while (1) {
		status_irq = readl(PREG_SDIO_STAT_IRQ);
		if(!status_irq_reg->cmd_busy && status_irq_reg->cmd_int)
			break;

		if((++timeout_count) > timeout) {
			if(!cmd->flags)
				return TIMEOUT;
				
			irq_config_reg->soft_reset = 1;
			writel(irq_config, PREG_SDIO_IRQ_CFG);
				
			if((++repeat_time) > SD_RETRY_COUNT)
				return TIMEOUT;
			goto CMD_RETRY;
		}

		if(cmd_send_reg->cmd_send_data)
			udelay(100);
		if(cmd->cmdidx == MMC_CMD_STOP_TRANSMISSION)
			udelay(1000);
	}
	
	if(cmd_send_reg->cmd_res_bits && !cmd_send_reg->res_without_crc7 && !status_irq_reg->res_crc7_ok)
		return SD_ERROR_COM_CRC;

	switch (cmd->resp_type) {
	case MMC_RSP_R1:
	case MMC_RSP_R1b:
	case MMC_RSP_R3:
	case MMC_RSP_R6:
	case MMC_RSP_R7:
		num_res = RESPONSE_R1_R3_R6_R7_LENGTH;
		break;
	case MMC_RSP_R2:
		num_res = RESPONSE_R2_CID_CSD_LENGTH;
		break;
	default:
		num_res = RESPONSE_R4_R5_NONE_LENGTH;
		break;
	 }
	 
/*	switch (cmd->cmdidx) {
	case MMC_CMD_READ_SINGLE_BLOCK:
	case MMC_CMD_READ_MULTIPLE_BLOCK:
	case MMC_CMD_SEND_EXT_CSD:					//same as: SD_CMD_SEND_IF_COND
	case SD_CMD_SWITCH_FUNC:					//same as: MMC_CMD_SWITCH
	case SD_CMD_APP_SEND_SCR:
		if(!data)
			break;
        dma_unmap_single((void*)data->dest,data->blocks*data->blocksize,buffer);
		break;
	case MMC_CMD_WRITE_SINGLE_BLOCK:
	case MMC_CMD_WRITE_MULTIPLE_BLOCK:
	    dma_unmap_single((void*)data->src,data->blocks*data->blocksize,buffer);
		break;
	default:
		break;
	}*/
    dcache_flush();
	if (num_res > 0) {
		unsigned int multi_config = 0;
		SDIO_Multi_Config_Reg_t *multi_config_reg = (void *)&multi_config;
		multi_config_reg->write_read_out_index = 1;
		writel(multi_config, PREG_SDIO_MULT_CFG);
		num_res--;							// Minus CRC byte
	}
	unsigned int data_temp;
	unsigned int loop_num = (num_res + 3 - 1) /4;
	while (num_res > 0) {
		data_temp = readl(PREG_SDIO_CMD_ARG);
		if(num_res <= 1)
			break;
		cmd->response[--num_res - 1] = data_temp & 0xFF;
		if(num_res <= 1)
			break;
		cmd->response[--num_res - 1] = (data_temp >> 8) & 0xFF;
		if(num_res <= 1)
			break;
		cmd->response[--num_res - 1] = (data_temp >> 16) & 0xFF;
		if(num_res <= 1)
			break;
		cmd->response[--num_res - 1] = (data_temp >> 24) & 0xFF;
	}
	while (loop_num--) {
		((uint *)cmd->response)[loop_num] = __be32_to_cpu(((uint *)cmd->response)[loop_num]);
	}
	
	//check_response
	ret = sd_inand_check_response(cmd);
	if(ret)
		return ret;

	//cmd with adtc
	switch (cmd->cmdidx) {
	case MMC_CMD_READ_SINGLE_BLOCK:
	case MMC_CMD_READ_MULTIPLE_BLOCK:
	case MMC_CMD_SEND_EXT_CSD:							//same as SD_CMD_SEND_IF_COND
	case SD_CMD_SWITCH_FUNC:							//same as: MMC_CMD_SWITCH
		if(!data)
			break;
		if(!status_irq_reg->data_read_crc16_ok)
			return SD_ERROR_DATA_CRC;
		break;
	case MMC_CMD_WRITE_SINGLE_BLOCK:
	case MMC_CMD_WRITE_MULTIPLE_BLOCK:
		if(!status_irq_reg->data_write_crc16_ok)
			return SD_ERROR_DATA_CRC;
		break;
	case SD_CMD_APP_SEND_SCR:
		if(!status_irq_reg->data_read_crc16_ok)
			return SD_ERROR_DATA_CRC;
		break;
	default:
		break;
	}

	
	return SD_NO_ERROR;
}

int aml_sd_init(struct mmc *mmc)
{
	//int ret;
	struct aml_card_sd_info *sdio=mmc->priv;
	//setting io pin mux

	//FIXME M2 socket board
#ifdef CONFIG_BOARD_M2_SOCKET
	CLEAR_CBUS_REG_MASK(PREG_EGPIO_EN_N,(0x1<<8));
	CLEAR_CBUS_REG_MASK(PREG_EGPIO_O,(0x1<<8));
#endif

    if(sdio->inited_flag)
    {       	
        #ifdef AML_CARD_SD_INFO_DETAILED      
        sdio->sdio_init(sdio->sdio_port,sdio);
        #else
        sdio->sdio_init(sdio->sdio_port);
        #endif 
        
        if((sdio->sdio_port == SDIO_PORT_B)&&(sdio_debug_1bit_flag)){   
    		clrbits_le32(P_PERIPHS_PIN_MUX_2,7<<12);
   	 	}
   	 	
       mmc->set_ios(mmc);
        return 0;
    }
        
	if (sd_inand_check_insert(mmc)) {
		sd_inand_staff_init(mmc);
		return 0;
	} else
		return 1;
}

#ifdef CONFIG_STORE_COMPATIBLE
extern int aml_card_type;
#endif
void sdio_register(struct mmc* mmc,struct aml_card_sd_info * aml_priv)
{
#ifdef CONFIG_STORE_COMPATIBLE
    int card_type;
#endif

    strncpy(mmc->name,aml_priv->name,31);
    mmc->priv = aml_priv;
	aml_priv->removed_flag = 1;
	aml_priv->inited_flag = 0;
/*	
	aml_priv->sdio_init=sdio_init;
	aml_priv->sdio_detect=sdio_detect;
	aml_priv->sdio_pwr_off=sdio_pwr_off;
	aml_priv->sdio_pwr_on=sdio_pwr_on;
	aml_priv->sdio_pwr_prepare=sdio_pwr_prepare;
*/	
	mmc->send_cmd = aml_sd_send_cmd;
	mmc->set_ios = aml_sd_cfg_swth;
	mmc->init = aml_sd_init;
	mmc->rca = 1;
	mmc->voltages = MMC_VDD_33_34;
	mmc->host_caps = MMC_MODE_4BIT | MMC_MODE_HS;
	//mmc->host_caps = MMC_MODE_4BIT;
	mmc->bus_width = 1;
	mmc->clock = 300000;
	mmc->f_min = 200000;
	mmc->f_max = 50000000;
    mmc->is_inited = false;
	mmc_register(mmc);
	
	//WRITE_CBUS_REG(RESET6_REGISTER, (1<<8));
        WRITE_CBUS_REG(SDIO_AHB_CBUS_CTRL, 0);

#ifdef CONFIG_STORE_COMPATIBLE
    card_type = AML_GET_CARD_TYPE(aml_card_type, aml_priv->sdio_port);
    if (card_type == CARD_TYPE_MMC)
        mmc->block_dev.if_type = IF_TYPE_MMC;
    else
        mmc->block_dev.if_type = IF_TYPE_SD;
    // printf("\033[0;40;32m [%s] port=%d, aml_card_type=%#x, card_type=%d, mmc->block_dev.if_type=%d \033[0m\n", 
            // __FUNCTION__, aml_priv->sdio_port, aml_card_type, card_type, mmc->block_dev.if_type);
#endif
}

void aml_sd_cs_high (void) // chip select high
{
    /*
	 * Non-SPI hosts need to prevent chipselect going active during
	 * GO_IDLE; that would put chips into SPI mode.  Remind them of
	 * that in case of hardware that won't pull up DAT3/nCS otherwise.
     *
     * Now the way to accomplish this is: 
     * 1) set DAT3-pin as a GPIO pin(by pinmux), and pulls up;
     * 2) send CMD0;
     * 3) set DAT3-pin as a card-dat3-pin(by pinmux);
	 */
    // clear bit[26] to make BOOT_3 used as a GPIO other than SD_D3_C
    clrbits_le32(P_PERIPHS_PIN_MUX_6, (1 << 26)); // make BOOT_3 used as a GPIO other than SD_D3_C
    setbits_le32 (P_PREG_PAD_GPIO3_O,(1 << 3)); // pull up GPIO
    clrbits_le32(P_PREG_PAD_GPIO3_EN_N, (1 << 3));	// enable gpio output
}

void aml_sd_cs_dont_care (void) // chip select don't care
{
    setbits_le32(P_PERIPHS_PIN_MUX_6, (1 << 26)); // make BOOT_3 used as SD_D3_C other than a GPIO
}

bool aml_is_emmc_tsd (struct mmc *mmc) // is eMMC OR TSD
{
    struct aml_card_sd_info * sdio=mmc->priv;

    return ((sdio->sdio_port == SDIO_PORT_C) || (sdio->sdio_port == SDIO_PORT_XC_C));
}
