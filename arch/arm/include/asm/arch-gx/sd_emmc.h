#ifndef __SD_EMMC_H__
#define __SD_EMMC_H__

#define SD_EMMC_BASE_A 0xd0070000
#define SD_EMMC_BASE_B 0xd0072000
#define SD_EMMC_BASE_C 0xd0074000

#define NEWSD_IRQ_ALL				    0x3fff

#define SD_EMMC_CLKSRC_24M 	24000000
#define SD_EMMC_CLKSRC_DIV2	1000000000

#define NEWSD_IRQ_EN_ALL_INIT
#define NEWSD_MAX_DESC_MUN					512
#define NEWSD_BOUNCE_REQ_SIZE		(512*1024)

#define SD_EMMC_CLKSRC 24000000

#define MMC_RSP_136_NUM					4
#define MAX_RESPONSE_BYTES     4

#define RESPONSE_R1_R3_R6_R7_LENGTH     6
#define RESPONSE_R2_CID_CSD_LENGTH      17
#define RESPONSE_R4_R5_NONE_LENGTH      0

#define SDIO_PORT_A    0
#define SDIO_PORT_B    1
#define SDIO_PORT_C    2

#define CARD_SD_SDIO_INIT          (1<<0)
#define CARD_SD_SDIO_DETECT        (1<<1)
#define CARD_SD_SDIO_PWR_PREPARE   (1<<2)
#define CARD_SD_SDIO_PWR_ON        (1<<3)
#define CARD_SD_SDIO_PWR_OFF       (1<<4)


#define	Cfg_div 	0
#define Cfg_src		6
#define Cfg_co_phase	8
#define	Cfg_tx_phase	10
#define	Cfg_rx_phase	12
#define	Cfg_sram_pd		14
#define	Cfg_tx_delay	16
#define	Cfg_rx_delay	20
#define	Cfg_always_on	24
#define	Cfg_irq_sdio_sleep   25
#define Cfg_irq_sdio_sleep_ds		26

struct sd_emmc_global_regs {
    volatile u32 gclock;     // 0x00
    volatile u32 gdelay;     // 0x04
    volatile u32 gadjust;    // 0x08
    volatile u32 reserved_0c;       // 0x0c
    volatile u32 gcalout;    // 0x10
    volatile u32 reserved_14[11];   // 0x14~0x3c
    volatile u32 gstart;     // 0x40
    volatile u32 gcfg;       // 0x44
    volatile u32 gstatus;    // 0x48
    volatile u32 girq_en;    // 0x4c
    volatile u32 gcmd_cfg;   // 0x50
    volatile u32 gcmd_arg;   // 0x54
    volatile u32 gcmd_dat;   // 0x58
    volatile u32 gcmd_rsp0;   // 0x5c
    volatile u32 gcmd_rsp1;  // 0x60
    volatile u32 gcmd_rsp2;  // 0x64
    volatile u32 gcmd_rsp3;  // 0x68
    volatile u32 reserved_6c;       // 0x6c
    volatile u32 gcurr_cfg;  // 0x70
    volatile u32 gcurr_arg;  // 0x74
    volatile u32 gcurr_dat;  // 0x78
    volatile u32 gcurr_rsp;  // 0x7c
    volatile u32 gnext_cfg;  // 0x80
    volatile u32 gnext_arg;  // 0x84
    volatile u32 gnext_dat;  // 0x88
    volatile u32 gnext_rsp;  // 0x8c
    volatile u32 grxd;       // 0x90
    volatile u32 gtxd;       // 0x94
    volatile u32 reserved_98[90];   // 0x98~0x1fc
    volatile u32 gdesc[128]; // 0x200
    volatile u32 gping[128]; // 0x400
    volatile u32 gpong[128]; // 0x800
};

typedef enum _SD_Error_Status_t {
	SD_NO_ERROR                 = 0,
	SD_ERROR_OUT_OF_RANGE,                  //Bit 31
	SD_ERROR_ADDRESS,                       //Bit 30
	SD_ERROR_BLOCK_LEN,                     //Bit 29
	SD_ERROR_ERASE_SEQ,                     //Bit 28
	SD_ERROR_ERASE_PARAM,                   //Bit 27
	SD_ERROR_WP_VIOLATION,                  //Bit 26
	SD_ERROR_CARD_IS_LOCKED,                    //Bit 25
	SD_ERROR_LOCK_UNLOCK_FAILED,                //Bit 24
	SD_ERROR_COM_CRC,                       //Bit 23
	SD_ERROR_ILLEGAL_COMMAND,               //Bit 22
	SD_ERROR_CARD_ECC_FAILED,                   //Bit 21
	SD_ERROR_CC,                                //Bit 20
	SD_ERROR_GENERAL,                       //Bit 19
	SD_ERROR_Reserved1,                         //Bit 18
	SD_ERROR_Reserved2,                         //Bit 17
	SD_ERROR_CID_CSD_OVERWRITE,             //Bit 16
	SD_ERROR_AKE_SEQ,                           //Bit 03
	SD_ERROR_STATE_MISMATCH,
	SD_ERROR_HEADER_MISMATCH,
	SD_ERROR_DATA_CRC,
	SD_ERROR_TIMEOUT,
	SD_ERROR_DRIVER_FAILURE,
	SD_ERROR_WRITE_PROTECTED,
	SD_ERROR_NO_MEMORY,
	SD_ERROR_SWITCH_FUNCTION_COMUNICATION,
	SD_ERROR_NO_FUNCTION_SWITCH,
	SD_ERROR_NO_CARD_INS
} SD_Error_Status_t;


#define	SD_EMMC_RXD_ERROR				1
#define	SD_EMMC_TXD_ERROR				1<<1
#define	SD_EMMC_DESC_ERROR				1<<2
#define	SD_EMMC_RESP_CRC_ERROR			1<<3
#define	SD_EMMC_RESP_TIMEOUT_ERROR		1<<4
#define	SD_EMMC_DESC_TIMEOUT_ERROR		1<<5

typedef enum _SD_Bus_Width
{
	SD_BUS_SINGLE                   = 1,        //only DAT0
	SD_BUS_WIDE                     = 4         //use DAT0-4
} SD_Bus_Width_t;

//LSB -> MSB, structrue for SD Card Status
typedef struct _SD_Card_Status
{
	unsigned Reserved3: 2;
	unsigned Reserved4: 1;
	unsigned AKE_SEQ_ERROR: 1;                  //Error in the sequence of authentication process.
	unsigned Reserved5: 1;
	unsigned APP_CMD: 1;                        //The card will expect ACMD, or indication that the command has been interpreted as ACMD.
	unsigned NotUsed: 2;

	unsigned READY_FOR_DATA: 1;                 //Corresponds to buffer empty signalling on the bus.
	unsigned CURRENT_STATE: 4;                  //The state of the card when receiving the command.
	unsigned ERASE_RESET: 1;                    //An erase sequence was cleared beforem executing because an out of erase sequence command was received.
	unsigned CARD_ECC_DISABLED: 1;              //The command has been executed without using the internal ECC.
	unsigned WP_ERASE_SKIP: 1;                  //Only partial address space was erased due to existing write protected blocks.

	unsigned CID_CSD_OVERWRITE: 1;              //Can be either one of the following errors:
	unsigned Reserved1: 1;
	unsigned Reserved2: 1;
	unsigned ERROR: 1;                          //A general or an unknown error occurred during the operation.
	unsigned CC_ERROR: 1;                       //Internal card controller error
	unsigned CARD_ECC_FAILED: 1;                //Card internal ECC was applied but failed to correct the data.
	unsigned ILLEGAL_COMMAND: 1;                //Command not legal for the card state
	unsigned COM_CRC_ERROR: 1;                  //The CRC check of the previous command failed.

    unsigned LOCK_UNLOCK_FAILED: 1;             //Set when a sequence or password error has been detected in lock/ unlock card command or if there was an attempt to access a locked card
	unsigned CARD_IS_LOCKED: 1;                 //When set, signals that the card is locked by the host
	unsigned WP_VIOLATION: 1;                   //Attempt to program a write-protected block.
	unsigned ERASE_PARAM: 1;                    //An invalid selection of write-blocks for erase occurred.
	unsigned ERASE_SEQ_ERROR: 1;                //An error in the sequence of erase commands occurred.
	unsigned BLOCK_LEN_ERROR: 1;                //The transferred block length is not allowed for this card, or the number of transferred bytes does not match the block length.
	unsigned ADDRESS_ERROR: 1;                  //A misaligned address that did not match the block length was used in the command.
	unsigned OUT_OF_RANGE: 1;                   //The command??s argument was out of the allowed range for this card.

} SD_Card_Status_t;

//structure for response
typedef struct _SD_Response_R1
{
	SD_Card_Status_t card_status;               //card status
} SD_Response_R1_t;


struct aml_card_sd_info
{
	unsigned sd_emmc_port;				 //0: sdioa, 1:sdiob, 2:sdioc
	unsigned sd_emmc_reg_base;
	char * name;
	int inited_flag;
	int removed_flag;
	int init_retry;
	int single_blk_failed;
	char* desc_buf;
	struct mmc_config cfg;
	struct sd_emmc_global_regs *sd_emmc_reg;
	dma_addr_t		desc_dma_addr;
#ifdef AML_CARD_SD_INFO_DETAILED
	int  (* sd_emmc_init)(unsigned port,struct aml_card_sd_info *sdio);
	int  (* sd_emmc_detect)(unsigned port,struct aml_card_sd_info *sdio);
	void (* sd_emmc_pwr_prepare)(unsigned port,struct aml_card_sd_info *sdio);
	void (* sd_emmc_pwr_on)(unsigned port,struct aml_card_sd_info *sdio);
	void (* sd_emmc_pwr_off)(unsigned port,struct aml_card_sd_info *sdio);
	unsigned int sdio_pwr_flag;
#else
	int  (* sd_emmc_init)(unsigned port);
	int  (* sd_emmc_detect)(unsigned port);
	void (* sd_emmc_pwr_prepare)(unsigned port);
	void (* sd_emmc_pwr_on)(unsigned port);
	void (* sd_emmc_pwr_off)(unsigned port);
#endif
};

struct sd_emmc_desc_info{
    u32 cmd_info;
    u32 cmd_arg;
    u32 data_addr;
    u32 resp_addr;
};

struct cmd_cfg{
    u32 length:9;
    u32 block_mode:1;
    u32 r1b:1;
    u32 end_of_chain:1;
    u32 timeout:4;
    u32 no_resp:1;
    u32 no_cmd:1;
    u32 data_io:1;
    u32 data_wr:1;
    u32 resp_nocrc:1;
    u32 resp_128:1;
    u32 resp_num:1;
    u32 data_num:1;
    u32 cmd_index:6;
    u32 error:1;
    u32 owner:1;
};

struct sd_emmc_status{
	u32 rxd_err:8;      /*[7:0]     RX data CRC error per wire, for multiple block read, the CRC errors are ORed together.*/
	u32 txd_err:1;      /*[8]       TX data CRC error, for multiple block write, any one of blocks CRC error. */
	u32 desc_err:1;     /*[9]       SD/eMMC controller doesn’t own descriptor. The owner bit is “0”, set cfg_ignore_owner to ignore this error.*/
	u32 resp_err:1;     /*[10]      Response CRC error.*/
	u32 resp_timeout:1; /*[11]      No response received before time limit. The timeout limit is set by cfg_resp_timeout.*/
	u32 desc_timeout:1; /*[12]      Descriptor execution time over time limit. The timeout limit is set by descriptor itself.*/
                            /*      Consider the multiple block read/write, set the proper timeout limits.*/
	u32 end_of_chain:1; /*[13]      End of Chain IRQ, Normal IRQ. */
	u32 desc_irq:1;     /*[14]      This descriptor requests an IRQ, Normal IRQ, the descriptor chain execution keeps going on.*/
	u32 irq_sdio:1;     /*[15]      SDIO device uses DAT[1] to request IRQ. */
	u32 dat_i:8;        /*[23:16]   Input data signals. */
	u32 cmd_i:1;        /*[24]      nput response signal. */
	u32 ds:1;           /*[25]      Input data strobe. */
	u32 bus_fsm:1;      /*[30:28]   BUS fsm */
    u32 desc_wr_rdy:1;  /*[31]      Descriptor write back process is done and it is ready for CPU to read.*/
}__attribute__((__may_alias__));


struct sd_emmc_clock{
    u32 div:6;          /*[5:0]     Clock divider. Frequency = clock source/cfg_div, Maximum divider 63. */
                            /*Clock off: cfg_div==0, the clock is disabled */
                            /*Divider bypass: cfg_div==1, clock source is used as core clock without divider. */
    u32 src:2;          /*[7:6]     Clock source, 0: Crystal 24MHz, 1: Fix PLL, 850MHz*/
                            /* 2: MPLL, <637MHz, used for 400MHz exactly. 3: different PLL */
    u32 core_phase:2;   /*[9:8]     Core clock phase. 0: 0 phase, 1: 90 phase, 2: 180 phase, 3: 270 phase.*/
    u32 tx_phase:2;     /*[11:10]   TX clock phase. 0: 0 phase, 1: 90 phase, 2: 180 phase, 3: 270 phase.*/
    u32 rx_phase:2;     /*[13:12]   RX clock phase. 0: 0 phase, 1: 90 phase, 2: 180 phase, 3: 270 phase.*/
    u32 reserved14:2;
    u32 tx_delay:4;     /*[19:16]   TX clock delay line. 0: no delay, n: delay n*200ps. Maximum delay 3ns.*/
    u32 rx_delay:4;     /*[23:20]   RX clock delay line. 0: no delay, n: delay n*200ps. Maximum delay 3ns.*/
    u32 always_on:1;    /*[24]      1: Keep clock always on. 0: Clock on/off controlled by activities. */
                            /*Any APB3 access or descriptor execution will keep clock on.*/
    u32 irq_sdio_sleep:1; /*[25]    1: enable IRQ sdio when in sleep mode. */
    u32 reserved26:6;
};

struct sd_emmc_delay{
    u32 dat0:4;         /*[3:0]       Data 0 delay line. */
    u32 dat1:4;         /*[7:4]       Data 1 delay line. */
    u32 dat2:4;         /*[11:8]      Data 2 delay line. */
    u32 dat3:4;         /*[15:12]     Data 3 delay line. */
    u32 dat4:4;         /*[19:16]     Data 4 delay line. */
    u32 dat5:4;         /*[23:20]     Data 5 delay line. */
    u32 dat6:4;         /*[27:24]     Data 6 delay line. */
    u32 dat7:4;         /*[31:28]     Data 7 delay line. */
};


struct sd_emmc_adjust{
    u32 cmd_delay:4;           /*[3:0]       Command delay line. */
    u32 ds_delay:4;            /*[7:4]       DS delay line. */
    u32 cali_sel:4;            /*[11:8]      Select one signal to be tested.*/
                                        /*Signals are labeled from 0 to 9 the same as delay lines. */
    u32 cali_enable:1;         /*[12]        Enable calibration. */
    u32 adj_enable:1;          /*[13]       Adjust interface timing by resampling the input signals. */
    u32 cali_rise:1;           /*[14]       1: test the rising edge. 0: test the falling edge. */
    u32 reserved15:1;
    u32 adj_delay:6;           /*[21:16]       Resample the input signals when clock index==adj_delay. */
    u32 reserved22:10;
};


struct sd_emmc_calout{
    u32 cali_idx:6;         /*[5:0]       Calibration reading. The event happens at this index. */
    u32 reserved6:1;
    u32 cali_vld:1;         /*[7]         The reading is valid. */
    u32 cali_setup:8;       /*[15:8]      Copied from BASE+0x8 [15:8] include cali_sel, cali_enable, adj_enable, cali_rise. */
    u32 reserved16:16;
};


struct sd_emmc_start{
	u32 init:1;         /*[0]   1: Read descriptor from internal SRAM, limited to 32 descriptors. */
                            /*  0: Read descriptor from external DDR */
	u32 busy:1;         /*[1]   1: Start command chain execution process. 0: Stop */
	u32 addr:30;        /*[31:2] Descriptor address, the last 2 bits are 0, 4 bytes aligned. */
                            /*  When internal SRAM is used, the valid address range is from 0x200~0x3ff */
                            /*  When external DDR is used, the valid address is anywhere in DDR, the length of chain is unlimited.*/
}__attribute__((__may_alias__));


struct sd_emmc_config{
	u32 bus_width:2;    /*[1:0]     0: 1 bit, 1: 4 bits, 2: 8 bits, 3: 2 bits (not supported)*/
	u32 ddr:1;          /*[2]       1: DDR mode, 0: SDR mode */
	u32 dc_ugt:1;       /*[3]       1: DDR access urgent, 0: DDR access normal. */
	u32 bl_len:4;       /*[7:4]     Block length 2^cfg_bl_len, because internal buffer size is limited to 512 bytes, the cfg_bl_len <=9. */
	u32 resp_timeout:4; /*[11:8]    Wait response till 2^cfg_resp_timeout core clock cycles. Maximum 32768 core cycles. */
	u32 rc_cc:4;        /*[15:12]   Wait response-command, command-command gap before next command, 2^cfg_rc_cc core clock cycles. */
	u32 out_fall:1;     /*[16]      DDR mode only. The command and TXD start from rising edge. Set 1 to start from falling edge. */
	u32 blk_gap_ip:1;   /*[17]      1: Enable SDIO data block gap interrupt period. 0: Disabled.*/
	u32 spare:1;        /*[18]      Spare,  ??? need check*/
	u32 ignore_owner:1; /*[19]      Use this descriptor even if its owner bit is “0”.*/
	u32 chk_ds:1;       /*[20]      Check data strobe in HS400.*/
	u32 cmd_low:1;      /*[21]      Hold CMD as output Low, eMMC boot mode.*/
	u32 stop_clk:1;     /*[22]      1: stop clock. 0: normal clock.*/
	                        /*In normal mode, the clock is automatically on/off during reading mode to back off reading in case of*/
	                        /*DDR slow response, stop clock is used in voltage switch.*/
	u32 auto_clk:1;     /*[23]      1: when BUS is idle and no descriptor is available, turn off clock, to save power.*/
                            /*      0: core clock is always on.*/
    u32 txd_add_err:1;	/*[24]   	TXD add error test*/
							/*Test feature, should not be used in normal condition.*/
							/*It will inverted the first CRC bits of the 3rd block.*/
							/*Block index starts from 0, 1, 2, …*/
    u32 txd_retry:1;	/*[25]   	When TXD CRC error, host sends the block again.*/
							/*The total number of retries of one descriptor is limited to 15, */
							/*after 15 retries, the TXD_err is set to high.*/
    u32 revd:8;	        /*[31:26]   reved*/
}__attribute__((__may_alias__));


struct sd_emmc_irq_en{
	u32 rxd_err:8;      /*[7:0]     RX data CRC error per wire.*/
	u32 txd_err:1;      /*[8]       TX data CRC error. */
	u32 desc_err:1;     /*[9]       SD/eMMC controller doesn’t own descriptor. */
	u32 resp_err:1;     /*[10]      Response CRC error.*/
	u32 resp_timeout:1; /*[11]      No response received before time limit. */
	u32 desc_timeout:1; /*[12]      Descriptor execution time over time limit. */
	u32 end_of_chain:1; /*[13]      End of Chain IRQ. */
	u32 desc_irq:1;     /*[14]      This descriptor requests an IRQ. */
	u32 irq_sdio:1;     /*[15]      Enable sdio interrupt. */
    u32 revd:16;	    /*[31:16]   reved*/
};

struct sd_emmc_data_info{
	u32 cnt:10;         /*[9:0]     Rxd words received from BUS. Txd words received from DDR.*/
	u32 blk:9;          /*[24:16]   Rxd Blocks received from BUS. Txd blocks received from DDR.*/
	u32 revd:30;        /*[31:17]   Reved. */
};


struct sd_emmc_card_info{
	u32 txd_cnt:10;     /*[9:0]     Txd BUS cycle counter. */
	u32 txd_blk:9;      /*[24:16]   Txd BUS block counter.*/
	u32 revd:30;        /*[31:17]   Reved. */
};

extern struct aml_card_sd_info * cpu_sd_emmc_get(unsigned port);
extern int                cpu_sd_emmc_init(unsigned port);
extern void               cpu_sd_emmc_pwr_prepare(unsigned port);
struct mmc;//mmc is struct mmc , to avoid include mmc.h , declare it
extern void               sd_emmc_register(struct aml_card_sd_info *);
#endif