
/*
 * arch/arm/include/asm/arch-txl/cpu_sdio.h
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

#ifndef __CPU_SDIO_H__
#define __CPU_SDIO_H__

#define SD_EMMC_BASE_A 0xFFE03000
#define SD_EMMC_BASE_B 0xFFE05000
#define SD_EMMC_BASE_C 0xFFE07000

#define SDIO_PORT_A 0
#define SDIO_PORT_B 1
#define SDIO_PORT_C 2

#define	Cfg_div 	0
#define Cfg_src		6
#define Cfg_co_phase	8
#define	Cfg_tx_phase	10
#define	Cfg_rx_phase	12
#define	Cfg_sram_pd		14
#define	Cfg_tx_delay	16
#define	Cfg_rx_delay	22
#define	Cfg_always_on	28
#define	Cfg_irq_sdio_sleep   29
#define Cfg_irq_sdio_sleep_ds		30

#define MMC_HS_COPHASE			3
#define MMC_HS2_COPHASE         2
#define MMC_DDR_COPHASE			2
#define MMC_HS4_COPHASE			2
#define MMC_HS400_TXDELAY		6
#define CLKSRC_BASE            0Xff63c000

#define	SD_EMMC_RXD_ERROR				1
#define	SD_EMMC_TXD_ERROR				1<<1
#define	SD_EMMC_DESC_ERROR				1<<2
#define	SD_EMMC_RESP_CRC_ERROR			1<<3
#define	SD_EMMC_RESP_TIMEOUT_ERROR		1<<4
#define	SD_EMMC_DESC_TIMEOUT_ERROR		1<<5

#define SD_EMMC_VDDEE_REG (*((volatile unsigned *)(0xff807000 + (0x01 << 2))))

struct sd_emmc_global_regs {
    volatile uint32_t gclock;     // 0x00
    volatile uint32_t gdelay;     // 0x04
	volatile uint32_t gdelay1;    //0x08
    volatile uint32_t gadjust;    // 0x0c
    volatile uint32_t gcalout;    // 0x10
    volatile uint32_t reserved_14[4];   // 0x14~0x20
    volatile uint32_t gclktest_log;   // 0x24
    volatile uint32_t gclktest_out;   // 0x28
    volatile uint32_t geyetest_log;   // 0x2c
    volatile uint32_t geyetest_out0;   // 0x30
    volatile uint32_t geyetest_out1;   // 0x34
    volatile uint32_t gintf3;   // 0x38
    volatile uint32_t reserved_3c;   // 0x3c
    volatile uint32_t gstart;     // 0x40
    volatile uint32_t gcfg;       // 0x44
    volatile uint32_t gstatus;    // 0x48
    volatile uint32_t girq_en;    // 0x4c
    volatile uint32_t gcmd_cfg;   // 0x50
    volatile uint32_t gcmd_arg;   // 0x54
    volatile uint32_t gcmd_dat;   // 0x58
    volatile uint32_t gcmd_rsp0;   // 0x5c
    volatile uint32_t gcmd_rsp1;  // 0x60
    volatile uint32_t gcmd_rsp2;  // 0x64
    volatile uint32_t gcmd_rsp3;  // 0x68
    volatile uint32_t reserved_6c;       // 0x6c
    volatile uint32_t gcurr_cfg;  // 0x70
    volatile uint32_t gcurr_arg;  // 0x74
    volatile uint32_t gcurr_dat;  // 0x78
    volatile uint32_t gcurr_rsp;  // 0x7c
    volatile uint32_t gnext_cfg;  // 0x80
    volatile uint32_t gnext_arg;  // 0x84
    volatile uint32_t gnext_dat;  // 0x88
    volatile uint32_t gnext_rsp;  // 0x8c
    volatile uint32_t grxd;       // 0x90
    volatile uint32_t gtxd;       // 0x94
    volatile uint32_t reserved_98[90];   // 0x98~0x1fc
    volatile uint32_t gdesc[128]; // 0x200
    volatile uint32_t gping[128]; // 0x400
    volatile uint32_t gpong[128]; // 0x800
};

struct sd_emmc_adjust_v3 {
	u32 reserved8:8;
	/*[11:8]	  Select one signal to be tested.*/
	u32 cali_sel:4;
	/*[12]		Enable calibration. */
	u32 cali_enable:1;
	/*[13]	   Adjust interface timing
	 *by resampling the input signals.
	 */
	u32 adj_enable:1;
	/*[14]	   1: test the rising edge.
	 *0: test the falling edge.
	 */
	u32 cali_rise:1;
	/*[15]	   1: Sampling the DAT based on DS in HS400 mode.
	 *0: Sampling the DAT based on RXCLK.
	 */
	u32 ds_enable:1;
	/*[21:16]	   Resample the input signals
	 *when clock index==adj_delay.
	 */
	u32 adj_delay:6;
	/*[22]	   1: Use cali_dut first falling edge to adjust
	 *	the timing, set cali_enable to 1 to use this function.
	 *0: no use adj auto.
	 */
	u32 adj_auto:1;
	u32 reserved22:9;
};

struct intf3 {
	u32 clktest_exp:5;
	u32 clktest_on_m:1;
	u32 eyetest_exp:5;
	u32 eyetest_on:1;
	u32 ds_sht_m:6;
	u32 ds_sht_exp:4;
	u32 sd_intf3:1;
};

struct eyetest_log {
	u32 eyetest_times:31;
	u32 eyetest_done:1;
};

union sd_emmc_setup {
    uint32_t d32;
    struct {
        unsigned bw:3;
        unsigned fast:1;
        unsigned par:3;
        unsigned hcs:1;
        unsigned sd:1;
        unsigned sdhc:1;
        unsigned type:6;
        unsigned rca:16;
    } b;
};

struct sd_emmc_desc_info{
    uint32_t cmd_info;
    uint32_t cmd_arg;
    uint32_t data_addr;
    uint32_t resp_addr;
};

struct cmd_cfg{
    uint32_t length:9;
    uint32_t block_mode:1;
    uint32_t r1b:1;
    uint32_t end_of_chain:1;
    uint32_t timeout:4;
    uint32_t no_resp:1;
    uint32_t no_cmd:1;
    uint32_t data_io:1;
    uint32_t data_wr:1;
    uint32_t resp_nocrc:1;
    uint32_t resp_128:1;
    uint32_t resp_num:1;
    uint32_t data_num:1;
    uint32_t cmd_index:6;
    uint32_t error:1;
    uint32_t owner:1;
};

struct sd_emmc_status{
	uint32_t rxd_err:8;      /*[7:0]     RX data CRC error per wire, for multiple block read, the CRC errors are ORed together.*/
	uint32_t txd_err:1;      /*[8]       TX data CRC error, for multiple block write, any one of blocks CRC error. */
	uint32_t desc_err:1;     /*[9]       SD/eMMC controller doesn¡¯t own descriptor. The owner bit is ¡°0¡±, set cfg_ignore_owner to ignore this error.*/
	uint32_t resp_err:1;     /*[10]      Response CRC error.*/
	uint32_t resp_timeout:1; /*[11]      No response received before time limit. The timeout limit is set by cfg_resp_timeout.*/
	uint32_t desc_timeout:1; /*[12]      Descriptor execution time over time limit. The timeout limit is set by descriptor itself.*/
                            /*      Consider the multiple block read/write, set the proper timeout limits.*/
	uint32_t end_of_chain:1; /*[13]      End of Chain IRQ, Normal IRQ. */
	uint32_t desc_irq:1;     /*[14]      This descriptor requests an IRQ, Normal IRQ, the descriptor chain execution keeps going on.*/
	uint32_t irq_sdio:1;     /*[15]      SDIO device uses DAT[1] to request IRQ. */
	uint32_t dat_i:8;        /*[23:16]   Input data signals. */
	uint32_t cmd_i:1;        /*[24]      nput response signal. */
	uint32_t ds:1;           /*[25]      Input data strobe. */
	uint32_t bus_fsm:4;      /*[29:26]   BUS fsm */
    uint32_t desc_wr_rdy:1;  /*[30]      Descriptor write back process is done and it is ready for CPU to read.*/
	uint32_t core_rdy:1;	 /*[31]       desc_busy or sd_emmc_irq or bus_fsm is not idle.*/
};//__attribute__((__may_alias__));


struct sd_emmc_clock{
    uint32_t div:6;          /*[5:0]     Clock divider. Frequency = clock source/cfg_div, Maximum divider 63. */
                            /*Clock off: cfg_div==0, the clock is disabled */
                            /*Divider bypass: cfg_div==1, clock source is used as core clock without divider. */
    uint32_t src:2;          /*[7:6]     Clock source, 0: Crystal 24MHz, 1: Fix PLL, 850MHz*/
                            /* 2: MPLL, <637MHz, used for 400MHz exactly. 3: different PLL */
    uint32_t core_phase:2;   /*[9:8]     Core clock phase. 0: 0 phase, 1: 90 phase, 2: 180 phase, 3: 270 phase.*/
    uint32_t tx_phase:2;     /*[11:10]   TX clock phase. 0: 0 phase, 1: 90 phase, 2: 180 phase, 3: 270 phase.*/
    uint32_t rx_phase:2;     /*[13:12]   RX clock phase. 0: 0 phase, 1: 90 phase, 2: 180 phase, 3: 270 phase.*/
    uint32_t reserved14:2;
    uint32_t tx_delay:6;     /*[21:16]   TX clock delay line. 0: no delay, n: delay n*200ps. Maximum delay 3ns.*/
    uint32_t rx_delay:6;     /*[27:22]   RX clock delay line. 0: no delay, n: delay n*200ps. Maximum delay 3ns.*/
    uint32_t always_on:1;    /*[28]      1: Keep clock always on. 0: Clock on/off controlled by activities. */
                            /*Any APB3 access or descriptor execution will keep clock on.*/
    uint32_t irq_sdio_sleep:1; /*[29]    1: enable IRQ sdio when in sleep mode. */
	uint32_t irq_sdio_sleep_ds:1;/*[30] 1:enable ds as irq*/
    uint32_t reserved26:1;
};

struct sd_emmc_delay{
    uint32_t dat0:6;         /*[3:0]       Data 0 delay line. */
    uint32_t dat1:6;         /*[7:4]       Data 1 delay line. */
    uint32_t dat2:6;         /*[11:8]      Data 2 delay line. */
    uint32_t dat3:6;         /*[15:12]     Data 3 delay line. */
    uint32_t dat4:6;         /*[19:16]     Data 4 delay line. */
	uint32_t spare:2;
};

struct sd_emmc_delay1{
    uint32_t dat5:6;         /*[23:20]     Data 5 delay line. */
    uint32_t dat6:6;         /*[27:24]     Data 6 delay line. */
    uint32_t dat7:6;         /*[31:28]     Data 7 delay line. */
	uint32_t dat8:6;         /*[31:28]     Data 7 delay line. */
	uint32_t dat9:6;         /*[31:28]     Data 7 delay line. */
	uint32_t spare:2;
};

struct sd_emmc_adjust{
    uint32_t cmd_delay:4;           /*[3:0]       Command delay line. */
    uint32_t ds_delay:4;            /*[7:4]       DS delay line. */
    uint32_t cali_sel:4;            /*[11:8]      Select one signal to be tested.*/
                                        /*Signals are labeled from 0 to 9 the same as delay lines. */
    uint32_t cali_enable:1;         /*[12]        Enable calibration. */
    uint32_t adj_enable:1;          /*[13]       Adjust interface timing by resampling the input signals. */
    uint32_t cali_rise:1;           /*[14]       1: test the rising edge. 0: test the falling edge. */
    uint32_t ds_enable:1;			/*[15]		Sampling the DAT based on DS in HS400 mode*/
    uint32_t adj_delay:6;           /*[21:16]       Resample the input signals when clock index==adj_delay. */
    uint32_t adj_auto:1;			/*[22]			Use cali_dut first falling edge to adjust the timing */
										/*set cali_enable to 1 to use this function*/
	uint32_t reserved23:9;
};


struct sd_emmc_calout{
    uint32_t cali_idx:6;         /*[5:0]       Calibration reading. The event happens at this index. */
    uint32_t reserved6:1;
    uint32_t cali_vld:1;         /*[7]         The reading is valid. */
    uint32_t cali_setup:8;       /*[15:8]      Copied from BASE+0x8 [15:8] include cali_sel, cali_enable, adj_enable, cali_rise. */
    uint32_t reserved16:16;
};


struct sd_emmc_start{
	uint32_t init:1;         /*[0]   1: Read descriptor from internal SRAM, limited to 32 descriptors. */
                            /*  0: Read descriptor from external DDR */
	uint32_t busy:1;         /*[1]   1: Start command chain execution process. 0: Stop */
	uint32_t addr:30;        /*[31:2] Descriptor address, the last 2 bits are 0, 4 bytes aligned. */
                            /*  When internal SRAM is used, the valid address range is from 0x200~0x3ff */
                            /*  When external DDR is used, the valid address is anywhere in DDR, the length of chain is unlimited.*/
};//__attribute__((__may_alias__));


struct sd_emmc_config{
	uint32_t bus_width:2;    /*[1:0]     0: 1 bit, 1: 4 bits, 2: 8 bits, 3: 2 bits (not supported)*/
	uint32_t ddr:1;          /*[2]       1: DDR mode, 0: SDR mode */
	uint32_t dc_ugt:1;       /*[3]       1: DDR access urgent, 0: DDR access normal. */
	uint32_t bl_len:4;       /*[7:4]     Block length 2^cfg_bl_len, because internal buffer size is limited to 512 bytes, the cfg_bl_len <=9. */
	uint32_t resp_timeout:4; /*[11:8]    Wait response till 2^cfg_resp_timeout core clock cycles. Maximum 32768 core cycles. */
	uint32_t rc_cc:4;        /*[15:12]   Wait response-command, command-command gap before next command, 2^cfg_rc_cc core clock cycles. */
	uint32_t out_fall:1;     /*[16]      DDR mode only. The command and TXD start from rising edge. Set 1 to start from falling edge. */
	uint32_t blk_gap_ip:1;   /*[17]      1: Enable SDIO data block gap interrupt period. 0: Disabled.*/
	uint32_t spare:1;        /*[18]      Spare,  ??? need check*/
	uint32_t ignore_owner:1; /*[19]      Use this descriptor even if its owner bit is ¡°0¡±.*/
	uint32_t chk_ds:1;       /*[20]      Check data strobe in HS400.*/
	uint32_t cmd_low:1;      /*[21]      Hold CMD as output Low, eMMC boot mode.*/
	uint32_t stop_clk:1;     /*[22]      1: stop clock. 0: normal clock.*/
	                        /*In normal mode, the clock is automatically on/off during reading mode to back off reading in case of*/
	                        /*DDR slow response, stop clock is used in voltage switch.*/
	uint32_t auto_clk:1;     /*[23]      1: when BUS is idle and no descriptor is available, turn off clock, to save power.*/
                            /*      0: core clock is always on.*/
    uint32_t txd_add_err:1;	/*[24]   	TXD add error test*/
							/*Test feature, should not be used in normal condition.*/
							/*It will inverted the first CRC bits of the 3rd block.*/
							/*Block index starts from 0, 1, 2, ¡­*/
    uint32_t txd_retry:1;	/*[25]   	When TXD CRC error, host sends the block again.*/
							/*The total number of retries of one descriptor is limited to 15, */
							/*after 15 retries, the TXD_err is set to high.*/
    uint32_t revd:8;	        /*[31:26]   reved*/
};//__attribute__((__may_alias__));


struct sd_emmc_irq_en{
	uint32_t rxd_err:8;      /*[7:0]     RX data CRC error per wire.*/
	uint32_t txd_err:1;      /*[8]       TX data CRC error. */
	uint32_t desc_err:1;     /*[9]       SD/eMMC controller doesn¡¯t own descriptor. */
	uint32_t resp_err:1;     /*[10]      Response CRC error.*/
	uint32_t resp_timeout:1; /*[11]      No response received before time limit. */
	uint32_t desc_timeout:1; /*[12]      Descriptor execution time over time limit. */
	uint32_t end_of_chain:1; /*[13]      End of Chain IRQ. */
	uint32_t desc_irq:1;     /*[14]      This descriptor requests an IRQ. */
	uint32_t irq_sdio:1;     /*[15]      Enable sdio interrupt. */
    uint32_t revd:16;	    /*[31:16]   reved*/
};

struct sd_emmc_data_info{
	uint32_t cnt:10;         /*[9:0]     Rxd words received from BUS. Txd words received from DDR.*/
	uint32_t blk:9;          /*[24:16]   Rxd Blocks received from BUS. Txd blocks received from DDR.*/
	uint32_t revd:30;        /*[31:17]   Reved. */
};


struct sd_emmc_card_info{
	uint32_t txd_cnt:10;     /*[9:0]     Txd BUS cycle counter. */
	uint32_t txd_blk:9;      /*[24:16]   Txd BUS block counter.*/
	uint32_t revd:30;        /*[31:17]   Reved. */
};

#endif
