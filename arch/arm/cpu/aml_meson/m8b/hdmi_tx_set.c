#include <common.h>
#include <asm/arch/reg_addr.h>
#include <asm/arch/io.h>
#include <asm/io.h>
#include "hdmi_tx_reg.h"
#include <amlogic/aml_tv.h>
#include <amlogic/enc_clk_config.h>

#define HDMI_SOURCE_DESCRIPTION 0
#define HDMI_PACKET_VEND        1
#define HDMI_MPEG_SOURCE_INFO   2
#define HDMI_PACKET_AVI         3
#define HDMI_AUDIO_INFO         4
#define HDMI_AUDIO_CONTENT_PROTECTION   5
#define HDMI_PACKET_HBR         6

#define HSYNC_POLARITY      1                       // HSYNC polarity: active high 
#define VSYNC_POLARITY      1                       // VSYNC polarity: active high

#define hdmi_print(str, ...)   

#define msleep(t)       \
    do {                \
        int i;          \
        i = 10000 * t;  \
        while(i--);     \
    } while(0)

#define h_delay()       \
    do {                \
        int i = 1000;   \
        while(i--);     \
    }while(0)

static void hdmi_wr_reg(unsigned int addr, unsigned int data);
static unsigned int hdmi_rd_reg(unsigned int addr);
static unsigned int modulo(unsigned int a, unsigned int b);
static signed int to_signed(unsigned int a);

/*
 * HDMI reg read/write operation
 */
/**************************************  HDMI reg read/write operation start **************************************/

void aml_write_reg32_op(unsigned int _reg, const unsigned _value)
{
    __raw_writel(_value, _reg);
#ifdef HDMI_MINIBOOT_DEBUG
    printf(" A:0x%08x 0x%04x  wD:0x%x ", _reg, (_reg & 0xffff)>>2, _value);
    if(_value == aml_read_reg32(_reg))
        printf("\n");
    else
        printf(" rD: 0x%08x\n", aml_read_reg32(_reg));
#endif
}

unsigned int aml_read_reg32_op(unsigned int _reg)
{
    return __raw_readl(_reg);
}

void aml_set_reg32_bits_op(uint32_t _reg, const uint32_t _val, const uint32_t _start, const uint32_t _len)
{
    unsigned int tmp;
    tmp = (__raw_readl(_reg) & ~(((1L<<(_len))-1)<<(_start))) | ((unsigned int)(_val) << (_start));
    aml_write_reg32_op(_reg, tmp);
}

static void hdmi_wr_reg(unsigned int addr, unsigned int data)
{
    aml_write_reg32_op(P_HDMI_ADDR_PORT, addr);
    aml_write_reg32_op(P_HDMI_ADDR_PORT, addr);
    aml_write_reg32_op(P_HDMI_DATA_PORT, data);
}

static unsigned int hdmi_rd_reg(unsigned int addr)
{
    aml_write_reg32_op(P_HDMI_ADDR_PORT, addr);
    aml_write_reg32_op(P_HDMI_ADDR_PORT, addr);
    
    return aml_read_reg32_op(P_HDMI_DATA_PORT);
}
/************************************** end **************************************/


// Use this self-made function rather than %, because % appears to produce wrong
// value for divisor which are not 2's exponential.
static unsigned int modulo(unsigned int a, unsigned int b)
{
    if (a >= b) {
        return(a-b);
    } else {
        return(a);
    }
}

static signed int to_signed(unsigned int a)
{
    if (a <= 7) {
        return(a);
    } else {
        return(a-16);
    }
}

static void hdmi_tx_misc(HDMI_Video_Codes_t vic)
{
    unsigned int tmp_add_data;
    unsigned int checksum, i;
    
    // Enable APB3 fail on error
    aml_set_reg32_bits_op(P_HDMI_CTRL_PORT, 1, 15, 1);

    // Disable these interrupts: [2] tx_edid_int_rise [1] tx_hpd_int_fall [0] tx_hpd_int_rise
    hdmi_wr_reg(OTHER_BASE_ADDR + HDMI_OTHER_INTR_MASKN, 0x0);

    // HPD glitch filter
    hdmi_wr_reg(TX_HDCP_HPD_FILTER_L, 0xa0);
    hdmi_wr_reg(TX_HDCP_HPD_FILTER_H, 0xa0);

    // Disable MEM power-down
    hdmi_wr_reg(TX_MEM_PD_REG0, 0);

    // Keep TX (except register I/F) in reset, while programming the registers:
    tmp_add_data  = 0;
    tmp_add_data |= 1   << 7; // [7] tx_pixel_rstn
    tmp_add_data |= 1   << 6; // [6] tx_tmds_rstn
    tmp_add_data |= 1   << 5; // [5] tx_audio_master_rstn
    tmp_add_data |= 1   << 4; // [4] tx_audio_sample_rstn
    tmp_add_data |= 1   << 3; // [3] tx_i2s_reset_rstn
    tmp_add_data |= 1   << 2; // [2] tx_dig_reset_n_ch2
    tmp_add_data |= 1   << 1; // [1] tx_dig_reset_n_ch1
    tmp_add_data |= 1   << 0; // [0] tx_dig_reset_n_ch0
    hdmi_wr_reg(TX_SYS5_TX_SOFT_RESET_1, tmp_add_data);

    tmp_add_data  = 0;
    tmp_add_data |= 0   << 4; // [4] HDMI_CH0_RST_IN
    tmp_add_data |= 1   << 2; // [0] tx_ddc_hdcp_reset_n
    tmp_add_data |= 1   << 1; // [0] tx_ddc_edid_reset_n
    tmp_add_data |= 1   << 0; // [0] tx_dig_reset_n_ch3
    hdmi_wr_reg(TX_SYS5_TX_SOFT_RESET_2, tmp_add_data);

    tmp_add_data  = 0;
    tmp_add_data |= 0   << 7; // [7] forced_sys_trigger
    tmp_add_data |= 0   << 6; // [6] sys_trigger_config
    tmp_add_data |= 0   << 5; // [5] mem_acc_seq_mode
    tmp_add_data |= 0   << 4; // [4] mem_acc_seq_start
    tmp_add_data |= 1   << 3; // [3] forced_mem_copy_done
    tmp_add_data |= 1   << 2; // [2] mem_copy_done_config
    tmp_add_data |= 0   << 1; // [1] edid_int_forced_clear
    tmp_add_data |= 0   << 0; // [0] edid_int_auto_clear
    hdmi_wr_reg(TX_HDCP_EDID_CONFIG, tmp_add_data);

    tmp_add_data  = 0;
    tmp_add_data |= 0               << 7; // [7]   Force DTV timing (Auto)
    tmp_add_data |= 0               << 6; // [6]   Force Video Scan, only if [7]is set
    tmp_add_data |= 0               << 5; // [5]   Force Video field, only if [7]is set
    tmp_add_data |= ((vic==39)?0:1) << 4; // [4]   disable_vic39_correction
    tmp_add_data |= 0               << 0; // [3:0] Rsrv
    hdmi_wr_reg(TX_VIDEO_DTV_TIMING, tmp_add_data);
    
    tmp_add_data  = 0;
    tmp_add_data |= 0                       << 7; // [7]   forced_default_phase
    tmp_add_data |= 0                       << 2; // [6:2] Rsrv
    tmp_add_data |= 0   << 0; // [1:0] Color_depth:0=24-bit pixel; 1=30-bit pixel; 2=36-bit pixel; 3=48-bit pixel
    hdmi_wr_reg(TX_VIDEO_DTV_MODE, tmp_add_data);
    
    tmp_add_data  = 0;
    tmp_add_data |= 0                       << 7; // [7]   gc_pack_mode: 0=clear color_depth and pixel_phase when GC packet is transmitting AV_mute/clear info;
                                                  //                     1=do not clear.
    tmp_add_data |= 0                       << 0; // [6:0] forced_islands_per_period_active
    hdmi_wr_reg(TX_PACKET_ALLOC_ACTIVE_1, tmp_add_data);

    tmp_add_data  = 0;
    tmp_add_data |= 0   << 7; // [7]   Force packet timing
    tmp_add_data |= 0   << 6; // [6]   PACKET ALLOC MODE
    tmp_add_data |= 58  << 0; // [5:0] PACKET_START_LATENCY
    hdmi_wr_reg(TX_PACKET_CONTROL_1, tmp_add_data);
    
    hdmi_wr_reg(TX_PACKET_CONTROL_2, 0x2);      //deep_color_request_enable disable
    tmp_add_data  = 0;
    tmp_add_data |= 0   << 6; // [7:6] audio_source_select[1:0]
    tmp_add_data |= 0   << 5; // [5]   external_packet_enable
    tmp_add_data |= 1   << 4; // [4]   internal_packet_enable
    tmp_add_data |= 0   << 2; // [3:2] afe_fifo_source_select_lane_1[1:0]
    tmp_add_data |= 0   << 0; // [1:0] afe_fifo_source_select_lane_0[1:0]
    hdmi_wr_reg(TX_CORE_DATA_CAPTURE_2, tmp_add_data);
    
    tmp_add_data  = 0;
    tmp_add_data |= 0   << 7; // [7]   monitor_lane_1
    tmp_add_data |= 0   << 4; // [6:4] monitor_select_lane_1[2:0]
    tmp_add_data |= 1   << 3; // [3]   monitor_lane_0
    tmp_add_data |= 7   << 0; // [2:0] monitor_select_lane_0[2:0]
    hdmi_wr_reg(TX_CORE_DATA_MONITOR_1, tmp_add_data);
    
    tmp_add_data  = 0;
    tmp_add_data |= 0   << 3; // [7:3] Rsrv
    tmp_add_data |= 2   << 0; // [2:0] monitor_select[2:0]
    hdmi_wr_reg(TX_CORE_DATA_MONITOR_2, tmp_add_data);
    
    tmp_add_data  = 0;
    tmp_add_data |= 1   << 7; // [7]   forced_hdmi
    tmp_add_data |= 1   << 6; // [6]   hdmi_config
    tmp_add_data |= 0   << 4; // [5:4] Rsrv
    tmp_add_data |= 0   << 3; // [3]   bit_swap.
    tmp_add_data |= 0   << 0; // [2:0] channel_swap[2:0]
    hdmi_wr_reg(TX_TMDS_MODE, tmp_add_data);
    
    tmp_add_data  = 0;
    tmp_add_data |= 0   << 7; // [7]   Rsrv
    tmp_add_data |= 0   << 6; // [6]   TX_CONNECT_SEL: 0=use lower channel data[29:0]; 1=use upper channel data[59:30]
    tmp_add_data |= 0   << 0; // [5:0] Rsrv
    hdmi_wr_reg(TX_SYS4_CONNECT_SEL_1, tmp_add_data);
    
    // Normally it makes sense to synch 3 channel output with clock channel's rising edge,
    // as HDMI's serializer is LSB out first, invert tmds_clk pattern from "1111100000" to
    // "0000011111" actually enable data synch with clock rising edge.
    tmp_add_data = 1 << 4; // Set tmds_clk pattern to be "0000011111" before being sent to AFE clock channel
    hdmi_wr_reg(TX_SYS4_CK_INV_VIDEO, tmp_add_data);
    
    tmp_add_data  = 0;
    tmp_add_data |= 0   << 7; // [7] Rsrv
    tmp_add_data |= 0   << 6; // [6] TX_AFE_FIFO channel 2 bypass=0
    tmp_add_data |= 0   << 5; // [5] TX_AFE_FIFO channel 1 bypass=0
    tmp_add_data |= 0   << 4; // [4] TX_AFE_FIFO channel 0 bypass=0
    tmp_add_data |= 1   << 3; // [3] output enable of clk channel (channel 3)
    tmp_add_data |= 1   << 2; // [2] TX_AFE_FIFO channel 2 enable
    tmp_add_data |= 1   << 1; // [1] TX_AFE_FIFO channel 1 enable
    tmp_add_data |= 1   << 0; // [0] TX_AFE_FIFO channel 0 enable
    hdmi_wr_reg(TX_SYS5_FIFO_CONFIG, tmp_add_data);
    
    tmp_add_data  = 0;
    tmp_add_data |= 1  << 6; // [7:6] output_color_format: 0=RGB444; 1=YCbCr444; 2=Rsrv; 3=YCbCr422.
    tmp_add_data |= 1   << 4; // [5:4] input_color_format:  0=RGB444; 1=YCbCr444; 2=Rsrv; 3=YCbCr422.
    tmp_add_data |= 0   << 2; // [3:2] output_color_depth:  0=24-b; 1=30-b; 2=36-b; 3=48-b.
    tmp_add_data |= 0    << 0; // [1:0] input_color_depth:   0=24-b; 1=30-b; 2=36-b; 3=48-b.
    hdmi_wr_reg(TX_VIDEO_DTV_OPTION_L, tmp_add_data);
    
    tmp_add_data  = 0;
    tmp_add_data |= 0                       << 4; // [7:4] Rsrv
    tmp_add_data |= 0   << 2; // [3:2] output_color_range:  0=16-235/240; 1=16-240; 2=1-254; 3=0-255.
    tmp_add_data |= 0    << 0; // [1:0] input_color_range:   0=16-235/240; 1=16-240; 2=1-254; 3=0-255.
    hdmi_wr_reg(TX_VIDEO_DTV_OPTION_H, tmp_add_data);

    tmp_add_data  = 0;
    tmp_add_data |= 0   << 7; // [7] cp_desired
    tmp_add_data |= 0   << 6; // [6] ess_config
    tmp_add_data |= 0   << 5; // [5] set_avmute
    tmp_add_data |= 1   << 4; // [4] clear_avmute
    tmp_add_data |= 0   << 3; // [3] hdcp_1_1
    tmp_add_data |= 0   << 2; // [2] Vsync/Hsync forced_polarity_select
    tmp_add_data |= 0   << 1; // [1] forced_vsync_polarity
    tmp_add_data |= 0   << 0; // [0] forced_hsync_polarity
    hdmi_wr_reg(TX_HDCP_MODE, tmp_add_data);

    // Disable ALL packet generation
    for(i = 0; i < 16; i++) {
        hdmi_wr_reg(TX_PKT_REG_SPD_INFO_BASE_ADDR + i * 32 + 0x1F, 0);
    }

    // AVI frame
    //hdmi_wr_reg(TX_PKT_REG_AVI_INFO_BASE_ADDR+0x00, 0x46);              // PB0: Checksum
    hdmi_wr_reg(TX_PKT_REG_AVI_INFO_BASE_ADDR+0x01, 0x5e);              // PB1 (Note: the value should be meaningful but is not!)
    switch(vic) {
    case HDMI_640x480p60:
    case HDMI_480p60:
    case HDMI_480i60:
    case HDMI_1440x480p60:
    case HDMI_576p50:
    case HDMI_576i50:
        hdmi_wr_reg(TX_PKT_REG_AVI_INFO_BASE_ADDR+0x02, 0x58);              // PB2 (Note: the value should be meaningful but is not!)
        break;
    case HDMI_480p60_16x9:
    case HDMI_480i60_16x9:
    case HDMI_576p50_16x9:
    case HDMI_576i50_16x9:
        hdmi_wr_reg(TX_PKT_REG_AVI_INFO_BASE_ADDR+0x02, 0x68);
        break;
    default:
        hdmi_wr_reg(TX_PKT_REG_AVI_INFO_BASE_ADDR+0x02, 0xa8);              // PB2 (Note: the value should be meaningful but is not!)
        break;
    }
    switch(vic) {
    case HDMI_480p60:
    case HDMI_480i60:
    case HDMI_576p50:
    case HDMI_576i50:
    case HDMI_480p60_16x9:
    case HDMI_480i60_16x9:
    case HDMI_576p50_16x9:
    case HDMI_576i50_16x9:
        hdmi_wr_reg(TX_PKT_REG_AVI_INFO_BASE_ADDR+0x03, 0x03);              // PB3 (Note: the value should be meaningful but is not!)
        break;
    default:
        hdmi_wr_reg(TX_PKT_REG_AVI_INFO_BASE_ADDR+0x03, 0x13);              // PB3 (Note: the value should be meaningful but is not!)
        break;
    }
    hdmi_wr_reg(TX_PKT_REG_AVI_INFO_BASE_ADDR+0x04, vic);               // PB4: [7]    Rsrv
    if((vic >= HDMI_4k2k_30) && (vic <= HDMI_4k2k_smpte)) {
        hdmi_wr_reg(TX_PKT_REG_AVI_INFO_BASE_ADDR+0x04, 0);             // if mode is 4k, then set vic = 0 and set to VSDB
    }
    switch(vic) {
    case HDMI_480i60:
    case HDMI_576i50:
    case HDMI_480i60_16x9:
    case HDMI_576i50_16x9:
        hdmi_wr_reg(TX_PKT_REG_AVI_INFO_BASE_ADDR+0x05, 1); // PB5: [7:4]  Rsrv     [3:0]  PixelRepeat
        break;
    default:
        hdmi_wr_reg(TX_PKT_REG_AVI_INFO_BASE_ADDR+0x05, 0); // PB5: [7:4]  Rsrv     [3:0]  PixelRepeat
        break;
    }
    hdmi_wr_reg(TX_PKT_REG_AVI_INFO_BASE_ADDR+0x1C, 0x82);              // HB0: packet type=0x82
    hdmi_wr_reg(TX_PKT_REG_AVI_INFO_BASE_ADDR+0x1D, 0x02);              // HB1: packet version =0x02
    hdmi_wr_reg(TX_PKT_REG_AVI_INFO_BASE_ADDR+0x1E, 0x0D);              // HB2: payload bytes=13
    
    // calculate Checksum
    checksum = 0;
    for(i = 1; i < 0x1f; i++) {
        checksum += hdmi_rd_reg(TX_PKT_REG_AVI_INFO_BASE_ADDR + i);
    }

    checksum = ((~checksum) & 0xff) + 1;
    hdmi_wr_reg(TX_PKT_REG_AVI_INFO_BASE_ADDR+0x00, checksum);              // PB0: Checksum

    hdmi_wr_reg(TX_PKT_REG_AVI_INFO_BASE_ADDR+0x1F, 0xFF);              // Enable AVI packet generation

    tmp_add_data = 0x18 - 1; // time_divider[7:0] for DDC I2C bus clock
    hdmi_wr_reg(TX_HDCP_CONFIG3, tmp_add_data);
    hdmi_wr_reg(TX_HDCP_CONFIG0, 0x3<<3);
    
    hdmi_wr_reg(TX_HDCP_MODE, 0x40);
    
    // --------------------------------------------------------
    // Release TX out of reset
    // --------------------------------------------------------
    aml_write_reg32_op(P_HHI_HDMI_PLL_CNTL1, 0x00040000);         // turn off phy_clk
    aml_write_reg32_op(P_HHI_HDMI_PLL_CNTL1, 0x00040003);         // turn on phy_clk
    hdmi_wr_reg(TX_SYS5_TX_SOFT_RESET_2, 0x00); // Release reset on TX digital clock channel
    hdmi_wr_reg(TX_SYS5_TX_SOFT_RESET_1, 1<<6); // Release resets all other TX digital clock domain, except tmds_clk
    hdmi_wr_reg(TX_SYS5_TX_SOFT_RESET_1, 0x00); // Final release reset on tmds_clk domain
}

// Enable nessary hdmi related clock gate & power control
static void hdmi_tx_gate(HDMI_Video_Codes_t vic)
{
    aml_set_reg32_bits_op(P_HHI_VPU_MEM_PD_REG1, 0x0, 20, 2);
// Powerup VPU_HDMI
    aml_write_reg32_op(P_AO_RTI_GEN_PWR_SLEEP0, aml_read_reg32_op(P_AO_RTI_GEN_PWR_SLEEP0) & (~(0x1<<8))); // [8] power on
    aml_write_reg32_op(P_HHI_MEM_PD_REG0, aml_read_reg32_op(P_HHI_MEM_PD_REG0) & (~(0xff << 8))); // HDMI MEM-PD

    // Remove VPU_HDMI ISO
    aml_write_reg32_op(P_AO_RTI_GEN_PWR_SLEEP0, aml_read_reg32_op(P_AO_RTI_GEN_PWR_SLEEP0) & (~(0x1<<9))); // [9] VPU_HDMI

    aml_set_reg32_bits_op(P_HHI_GCLK_MPEG2, 1, 4, 1); //enable HDMI PCLK
    aml_set_reg32_bits_op(P_HHI_GCLK_MPEG2, 1, 3, 1); //enable HDMI Int Sync
    aml_write_reg32_op(P_HHI_HDMI_CLK_CNTL,  ((0 << 9)  |   // select XTAL
                             (1 << 8)  |   // Enable gated clock
                             (0 << 0)) );  // Divide by 1
    
    if((vic == HDMI_480i60) || (vic == HDMI_576i50) || (vic == HDMI_480i60_16x9) || (vic == HDMI_576i50_16x9)) {
        // For ENCI
        aml_set_reg32_bits_op(P_HHI_GCLK_OTHER, 1, 8, 1); //enable VCLK2_ENCI
        aml_set_reg32_bits_op(P_HHI_GCLK_OTHER, 1, 2, 1); //enable VCLK2_VENCI
    }
    else {
        // For ENCP
        aml_set_reg32_bits_op(P_HHI_GCLK_OTHER, 1, 4, 1); //enable VCLK2_VENCP
        aml_set_reg32_bits_op(P_HHI_GCLK_OTHER, 1, 9, 1); //enable VCLK2_ENC
    }
    
    aml_set_reg32_bits_op(P_PERIPHS_PIN_MUX_1, 0x7, 24, 3);  //HPD SCL pinmux
}

static void hdmi_tx_clk(HDMI_Video_Codes_t vic)
{
    extern void set_vmode_clk(vmode_t mode);
    set_vmode_clk(vic_to_vmode(vic));
}

static void hdmi_tvenc480i_set(HDMI_Video_Codes_t vic)
{
    unsigned long VFIFO2VD_TO_HDMI_LATENCY = 1; // Annie 01Sep2011: Change value from 2 to 1, due to video encoder path delay change.
    unsigned long TOTAL_PIXELS, PIXEL_REPEAT_HDMI, PIXEL_REPEAT_VENC, ACTIVE_PIXELS;
    unsigned FRONT_PORCH = 38, HSYNC_PIXELS = 124, ACTIVE_LINES = 0, INTERLACE_MODE, TOTAL_LINES, SOF_LINES, VSYNC_LINES;
    unsigned LINES_F0 = 262, LINES_F1 = 263, BACK_PORCH = 114, EOF_LINES = 2, TOTAL_FRAMES;

    unsigned long total_pixels_venc ;
    unsigned long active_pixels_venc;
    unsigned long front_porch_venc  ;
    unsigned long hsync_pixels_venc ;

    unsigned long de_h_begin, de_h_end;
    unsigned long de_v_begin_even, de_v_end_even, de_v_begin_odd, de_v_end_odd;
    unsigned long hs_begin, hs_end;
    unsigned long vs_adjust;
    unsigned long vs_bline_evn, vs_eline_evn, vs_bline_odd, vs_eline_odd;
    unsigned long vso_begin_evn, vso_begin_odd;

    if((vic == HDMI_480i60)||(vic == HDMI_480i60_16x9)){
         INTERLACE_MODE     = 1;                   
         PIXEL_REPEAT_VENC  = 1;                   
         PIXEL_REPEAT_HDMI  = 1;                   
         ACTIVE_PIXELS  =     (720*(1+PIXEL_REPEAT_HDMI)); // Number of active pixels per line.
         ACTIVE_LINES   =     (480/(1+INTERLACE_MODE));    // Number of active lines per field.
         LINES_F0           = 262;                 
         LINES_F1           = 263;                 
         FRONT_PORCH        = 38;                  
         HSYNC_PIXELS       = 124;                  
         BACK_PORCH         = 114;                  
         EOF_LINES          = 4;                   
         VSYNC_LINES        = 3;                   
         SOF_LINES          = 15;                  
         TOTAL_FRAMES       = 4;                   
    }
    else if((vic == HDMI_576i50)||(vic == HDMI_576i50_16x9)){
         INTERLACE_MODE     = 1;                   
         PIXEL_REPEAT_VENC  = 1;                   
         PIXEL_REPEAT_HDMI  = 1;                   
         ACTIVE_PIXELS  =     (720*(1+PIXEL_REPEAT_HDMI)); // Number of active pixels per line.
         ACTIVE_LINES   =     (576/(1+INTERLACE_MODE));    // Number of active lines per field.
         LINES_F0           = 312;                 
         LINES_F1           = 313;                 
         FRONT_PORCH        = 24;                  
         HSYNC_PIXELS       = 126;                  
         BACK_PORCH         = 138;                  
         EOF_LINES          = 2;                   
         VSYNC_LINES        = 3;                   
         SOF_LINES          = 19;                  
         TOTAL_FRAMES       = 4;                   
    }
    TOTAL_PIXELS =(FRONT_PORCH+HSYNC_PIXELS+BACK_PORCH+ACTIVE_PIXELS); // Number of total pixels per line.
    TOTAL_LINES  =(LINES_F0+(LINES_F1*INTERLACE_MODE));                // Number of total lines per frame.

    total_pixels_venc = (TOTAL_PIXELS  / (1+PIXEL_REPEAT_HDMI)) * (1+PIXEL_REPEAT_VENC); // 1716 / 2 * 2 = 1716
    active_pixels_venc= (ACTIVE_PIXELS / (1+PIXEL_REPEAT_HDMI)) * (1+PIXEL_REPEAT_VENC); // 1440 / 2 * 2 = 1440
    front_porch_venc  = (FRONT_PORCH   / (1+PIXEL_REPEAT_HDMI)) * (1+PIXEL_REPEAT_VENC); // 38   / 2 * 2 = 38
    hsync_pixels_venc = (HSYNC_PIXELS  / (1+PIXEL_REPEAT_HDMI)) * (1+PIXEL_REPEAT_VENC); // 124  / 2 * 2 = 124

    // Annie 01Sep2011: Comment out the following 2 lines. Because ENCP is not used for 480i and 576i.
    //hdmi_print(0, "[ENCP_VIDEO_MODE:%x]=%x\n",ENCP_VIDEO_MODE, Rd(ENCP_VIDEO_MODE));
    //Wr(ENCP_VIDEO_MODE,Rd(ENCP_VIDEO_MODE)|(1<<14)); // cfg_de_v = 1

    // Program DE timing
    // Annie 01Sep2011: for 480/576i, replace VFIFO2VD_PIXEL_START with ENCI_VFIFO2VD_PIXEL_START.
    hdmi_print(0, "[ENCI_VFIFO2VD_PIXEL_START:%x]=%x\n",ENCI_VFIFO2VD_PIXEL_START, aml_read_reg32_op(P_ENCI_VFIFO2VD_PIXEL_START)); 
    de_h_begin = modulo(aml_read_reg32_op(P_ENCI_VFIFO2VD_PIXEL_START) + VFIFO2VD_TO_HDMI_LATENCY,   total_pixels_venc); // (233 + 2) % 1716 = 235
    de_h_end   = modulo(de_h_begin + active_pixels_venc,                            total_pixels_venc); // (235 + 1440) % 1716 = 1675
    aml_write_reg32_op(P_ENCI_DE_H_BEGIN, de_h_begin);    // 235
    aml_write_reg32_op(P_ENCI_DE_H_END,   de_h_end);      // 1675

    // Annie 01Sep2011: for 480/576i, replace VFIFO2VD_LINE_TOP/BOT_START with ENCI_VFIFO2VD_LINE_TOP/BOT_START.
    hdmi_print(0, "[ENCI_VFIFO2VD_LINE_TOP_START:%x]=%x\n",ENCI_VFIFO2VD_LINE_TOP_START, aml_read_reg32_op(P_ENCI_VFIFO2VD_LINE_TOP_START)); 
    hdmi_print(0, "[ENCI_VFIFO2VD_LINE_BOT_START:%x]=%x\n",ENCI_VFIFO2VD_LINE_BOT_START, aml_read_reg32_op(P_ENCI_VFIFO2VD_LINE_BOT_START)); 
    de_v_begin_even = aml_read_reg32_op(P_ENCI_VFIFO2VD_LINE_TOP_START);      // 17
    de_v_end_even   = de_v_begin_even + ACTIVE_LINES;   // 17 + 240 = 257
    de_v_begin_odd  = aml_read_reg32_op(P_ENCI_VFIFO2VD_LINE_BOT_START);      // 18
    de_v_end_odd    = de_v_begin_odd + ACTIVE_LINES;    // 18 + 480/2 = 258
    aml_write_reg32_op(P_ENCI_DE_V_BEGIN_EVEN,de_v_begin_even);   // 17
    aml_write_reg32_op(P_ENCI_DE_V_END_EVEN,  de_v_end_even);     // 257
    aml_write_reg32_op(P_ENCI_DE_V_BEGIN_ODD, de_v_begin_odd);    // 18
    aml_write_reg32_op(P_ENCI_DE_V_END_ODD,   de_v_end_odd);      // 258

    // Program Hsync timing
    if (de_h_end + front_porch_venc >= total_pixels_venc) {
        hs_begin    = de_h_end + front_porch_venc - total_pixels_venc;
        vs_adjust   = 1;
    } else {
        hs_begin    = de_h_end + front_porch_venc; // 1675 + 38 = 1713
        vs_adjust   = 1;
    }
    hs_end  = modulo(hs_begin + hsync_pixels_venc,   total_pixels_venc); // (1713 + 124) % 1716 = 121
    aml_write_reg32_op(P_ENCI_DVI_HSO_BEGIN,  hs_begin);  // 1713
    aml_write_reg32_op(P_ENCI_DVI_HSO_END,    hs_end);    // 121
    
    // Program Vsync timing for even field
    if (de_v_end_odd-1 + EOF_LINES + vs_adjust >= LINES_F1) {
        vs_bline_evn = de_v_end_odd-1 + EOF_LINES + vs_adjust - LINES_F1;
        vs_eline_evn = vs_bline_evn + VSYNC_LINES;
        aml_write_reg32_op(P_ENCI_DVI_VSO_BLINE_EVN, vs_bline_evn);
        //vso_bline_evn_reg_wr_cnt ++;
        aml_write_reg32_op(P_ENCI_DVI_VSO_ELINE_EVN, vs_eline_evn);
        //vso_eline_evn_reg_wr_cnt ++;
        aml_write_reg32_op(P_ENCI_DVI_VSO_BEGIN_EVN, hs_begin);
        aml_write_reg32_op(P_ENCI_DVI_VSO_END_EVN,   hs_begin);
    } else {
        vs_bline_odd = de_v_end_odd-1 + EOF_LINES + vs_adjust; // 258-1 + 4 + 0 = 261
        aml_write_reg32_op(P_ENCI_DVI_VSO_BLINE_ODD, vs_bline_odd); // 261
        //vso_bline_odd_reg_wr_cnt ++;
        aml_write_reg32_op(P_ENCI_DVI_VSO_BEGIN_ODD, hs_begin);  // 1713
        if (vs_bline_odd + VSYNC_LINES >= LINES_F1) {
            vs_eline_evn = vs_bline_odd + VSYNC_LINES - LINES_F1; // 261 + 3 - 263 = 1
            aml_write_reg32_op(P_ENCI_DVI_VSO_ELINE_EVN, vs_eline_evn);   // 1
            //vso_eline_evn_reg_wr_cnt ++;
            aml_write_reg32_op(P_ENCI_DVI_VSO_END_EVN,   hs_begin);       // 1713
        } else {
            vs_eline_odd = vs_bline_odd + VSYNC_LINES;
            aml_write_reg32_op(P_ENCI_DVI_VSO_ELINE_ODD, vs_eline_odd);
            //vso_eline_odd_reg_wr_cnt ++;
            aml_write_reg32_op(P_ENCI_DVI_VSO_END_ODD,   hs_begin);
        }
    }
    // Program Vsync timing for odd field
    if (de_v_end_even-1 + EOF_LINES + 1 >= LINES_F0) {
        vs_bline_odd = de_v_end_even-1 + EOF_LINES + 1 - LINES_F0;
        vs_eline_odd = vs_bline_odd + VSYNC_LINES;
        aml_write_reg32_op(P_ENCI_DVI_VSO_BLINE_ODD, vs_bline_odd);
        //vso_bline_odd_reg_wr_cnt ++;
        aml_write_reg32_op(P_ENCI_DVI_VSO_ELINE_ODD, vs_eline_odd);
        //vso_eline_odd_reg_wr_cnt ++;
        vso_begin_odd   = modulo(hs_begin + (total_pixels_venc>>1), total_pixels_venc);
        aml_write_reg32_op(P_ENCI_DVI_VSO_BEGIN_ODD, vso_begin_odd);
        aml_write_reg32_op(P_ENCI_DVI_VSO_END_ODD,   vso_begin_odd);
    } else {
        vs_bline_evn = de_v_end_even-1 + EOF_LINES + 1; // 257-1 + 4 + 1 = 261
        aml_write_reg32_op(P_ENCI_DVI_VSO_BLINE_EVN, vs_bline_evn); // 261
        //vso_bline_evn_reg_wr_cnt ++;
        vso_begin_evn   = modulo(hs_begin + (total_pixels_venc>>1), total_pixels_venc);   // (1713 + 1716/2) % 1716 = 855
        aml_write_reg32_op(P_ENCI_DVI_VSO_BEGIN_EVN, vso_begin_evn);  // 855
        if (vs_bline_evn + VSYNC_LINES >= LINES_F0) {
            vs_eline_odd = vs_bline_evn + VSYNC_LINES - LINES_F0; // 261 + 3 - 262 = 2
            aml_write_reg32_op(P_ENCI_DVI_VSO_ELINE_ODD, vs_eline_odd);   // 2
            //vso_eline_odd_reg_wr_cnt ++;
            aml_write_reg32_op(P_ENCI_DVI_VSO_END_ODD,   vso_begin_evn);  // 855
        } else {
            vs_eline_evn = vs_bline_evn + VSYNC_LINES;
            aml_write_reg32_op(P_ENCI_DVI_VSO_ELINE_EVN, vs_eline_evn);
            //vso_eline_evn_reg_wr_cnt ++;
            aml_write_reg32_op(P_ENCI_DVI_VSO_END_EVN,   vso_begin_evn);
        }
    }

    // Check if there are duplicate or missing timing settings
    //if ((vso_bline_evn_reg_wr_cnt != 1) || (vso_bline_odd_reg_wr_cnt != 1) ||
    //    (vso_eline_evn_reg_wr_cnt != 1) || (vso_eline_odd_reg_wr_cnt != 1)) {
        //stimulus_print("[TEST.C] Error: Multiple or missing timing settings on reg ENCI_DVI_VSO_B(E)LINE_EVN(ODD)!\n");
        //stimulus_finish_fail(1);
    //}

    // Annie 01Sep2011: Register VENC_DVI_SETTING and VENC_DVI_SETTING_MORE are no long valid, use VPU_HDMI_SETTING instead.
    aml_write_reg32_op(P_VPU_HDMI_SETTING, (0                                 << 0) | // [    0] src_sel_enci
                         (0                                 << 1) | // [    1] src_sel_encp
                         (0                                 << 2) | // [    2] inv_hsync. 1=Invert Hsync polarity.
                         (0                                 << 3) | // [    3] inv_vsync. 1=Invert Vsync polarity.
                         (0                                 << 4) | // [    4] inv_dvi_clk. 1=Invert clock to external DVI, (clock invertion exists at internal HDMI).
                         (((1==0)?1:0)  << 5) | // [ 7: 5] data_comp_map. Input data is CrYCb(BRG), map the output data to desired format:
                                                                    //                          0=output CrYCb(BRG);
                                                                    //                          1=output YCbCr(RGB);
                                                                    //                          2=output YCrCb(RBG);
                                                                    //                          3=output CbCrY(GBR);
                                                                    //                          4=output CbYCr(GRB);
                                                                    //                          5=output CrCbY(BGR);
                                                                    //                          6,7=Rsrv.
                         (1                                 << 8) | // [11: 8] wr_rate. 0=A write every clk1; 1=A write every 2 clk1; ...; 15=A write every 16 clk1.
                         (1                                 <<12)   // [15:12] rd_rate. 0=A read every clk2; 1=A read every 2 clk2; ...; 15=A read every 16 clk2.
    );
    aml_set_reg32_bits_op(P_VPU_HDMI_SETTING, 1, 0, 1);  // [    0] src_sel_enci: Enable ENCI output to HDMI

}    

static void hdmi_tvenc1080i_set(HDMI_Video_Codes_t vic)
{
    unsigned long VFIFO2VD_TO_HDMI_LATENCY = 2; // Annie 01Sep2011: Change value from 3 to 2, due to video encoder path delay change.
    unsigned long TOTAL_PIXELS, PIXEL_REPEAT_HDMI, PIXEL_REPEAT_VENC, ACTIVE_PIXELS;
    unsigned FRONT_PORCH = 88, HSYNC_PIXELS, ACTIVE_LINES = 0, INTERLACE_MODE, TOTAL_LINES, SOF_LINES, VSYNC_LINES;
    unsigned LINES_F0, LINES_F1 = 563,BACK_PORCH, EOF_LINES = 2, TOTAL_FRAMES;

    unsigned long total_pixels_venc ;
    unsigned long active_pixels_venc;
    unsigned long front_porch_venc  ;
    unsigned long hsync_pixels_venc ;

    unsigned long de_h_begin, de_h_end;
    unsigned long de_v_begin_even, de_v_end_even, de_v_begin_odd, de_v_end_odd;
    unsigned long hs_begin, hs_end;
    unsigned long vs_adjust;
    unsigned long vs_bline_evn, vs_eline_evn, vs_bline_odd, vs_eline_odd;
    unsigned long vso_begin_evn, vso_begin_odd;
    
    if(vic == HDMI_1080i60){
         INTERLACE_MODE     = 1;                   
         PIXEL_REPEAT_VENC  = 1;                   
         PIXEL_REPEAT_HDMI  = 0;                   
         ACTIVE_PIXELS  =     (1920*(1+PIXEL_REPEAT_HDMI)); // Number of active pixels per line.
         ACTIVE_LINES   =     (1080/(1+INTERLACE_MODE));    // Number of active lines per field.
         LINES_F0           = 562;                 
         LINES_F1           = 563;                 
         FRONT_PORCH        = 88;                  
         HSYNC_PIXELS       = 44;                  
         BACK_PORCH         = 148;                  
         EOF_LINES          = 2;                   
         VSYNC_LINES        = 5;                   
         SOF_LINES          = 15;                  
         TOTAL_FRAMES       = 4;                   
    }
    else if(vic == HDMI_1080i50){
         INTERLACE_MODE     = 1;                   
         PIXEL_REPEAT_VENC  = 1;                   
         PIXEL_REPEAT_HDMI  = 0;                   
         ACTIVE_PIXELS  =     (1920*(1+PIXEL_REPEAT_HDMI)); // Number of active pixels per line.
         ACTIVE_LINES   =     (1080/(1+INTERLACE_MODE));    // Number of active lines per field.
         LINES_F0           = 562;                 
         LINES_F1           = 563;                 
         FRONT_PORCH        = 528;                  
         HSYNC_PIXELS       = 44;                  
         BACK_PORCH         = 148;                  
         EOF_LINES          = 2;                   
         VSYNC_LINES        = 5;                   
         SOF_LINES          = 15;                  
         TOTAL_FRAMES       = 4;                   
    }
    TOTAL_PIXELS =(FRONT_PORCH+HSYNC_PIXELS+BACK_PORCH+ACTIVE_PIXELS); // Number of total pixels per line.
    TOTAL_LINES  =(LINES_F0+(LINES_F1*INTERLACE_MODE));                // Number of total lines per frame.

    total_pixels_venc = (TOTAL_PIXELS  / (1+PIXEL_REPEAT_HDMI)) * (1+PIXEL_REPEAT_VENC); // 2200 / 1 * 2 = 4400
    active_pixels_venc= (ACTIVE_PIXELS / (1+PIXEL_REPEAT_HDMI)) * (1+PIXEL_REPEAT_VENC); // 1920 / 1 * 2 = 3840
    front_porch_venc  = (FRONT_PORCH   / (1+PIXEL_REPEAT_HDMI)) * (1+PIXEL_REPEAT_VENC); // 88   / 1 * 2 = 176
    hsync_pixels_venc = (HSYNC_PIXELS  / (1+PIXEL_REPEAT_HDMI)) * (1+PIXEL_REPEAT_VENC); // 44   / 1 * 2 = 88

//    hdmi_print(0, "[ENCP_VIDEO_MODE:%x]=%x\n",ENCP_VIDEO_MODE, Rd(ENCP_VIDEO_MODE)); 
//    hdmi_print(0, "[ENCP_VIDEO_MODE:%x]=%x\n",ENCP_VIDEO_MODE, aml_read_reg32_op(P_ENCP_VIDEO_MODE)); 
    aml_write_reg32_op(P_ENCP_VIDEO_MODE, aml_read_reg32_op(P_ENCP_VIDEO_MODE)|(1<<14)); // cfg_de_v = 1

    // Program DE timing
    hdmi_print(0, "[ENCP_VIDEO_HAVON_BEGIN:%x]=%x\n",ENCP_VIDEO_HAVON_BEGIN, aml_read_reg32_op(P_ENCP_VIDEO_HAVON_BEGIN)); 
    de_h_begin = modulo(aml_read_reg32_op(P_ENCP_VIDEO_HAVON_BEGIN) + VFIFO2VD_TO_HDMI_LATENCY,  total_pixels_venc); // (383 + 3) % 4400 = 386
    de_h_end   = modulo(de_h_begin + active_pixels_venc,                        total_pixels_venc); // (386 + 3840) % 4400 = 4226
    aml_write_reg32_op(P_ENCP_DE_H_BEGIN, de_h_begin);    // 386
    aml_write_reg32_op(P_ENCP_DE_H_END,   de_h_end);      // 4226
    // Program DE timing for even field
    hdmi_print(0, "[ENCP_VIDEO_VAVON_BLINE:%x]=%x\n",ENCP_VIDEO_VAVON_BLINE, aml_read_reg32_op(P_ENCP_VIDEO_VAVON_BLINE)); 
    de_v_begin_even = aml_read_reg32_op(P_ENCP_VIDEO_VAVON_BLINE);       // 20
    de_v_end_even   = de_v_begin_even + ACTIVE_LINES;   // 20 + 540 = 560
    aml_write_reg32_op(P_ENCP_DE_V_BEGIN_EVEN,de_v_begin_even);   // 20
    aml_write_reg32_op(P_ENCP_DE_V_END_EVEN,  de_v_end_even);     // 560
    // Program DE timing for odd field if needed
    if (INTERLACE_MODE) {
        // Calculate de_v_begin_odd according to enc480p_timing.v:
        //wire[10:0]	cfg_ofld_vavon_bline	= {{7{ofld_vavon_ofst1 [3]}},ofld_vavon_ofst1 [3:0]} + cfg_video_vavon_bline	+ ofld_line;
        hdmi_print(0, "[ENCP_VIDEO_OFLD_VOAV_OFST:%x]=%x\n",ENCP_VIDEO_OFLD_VOAV_OFST, aml_read_reg32_op(P_ENCP_VIDEO_OFLD_VOAV_OFST)); 
        de_v_begin_odd  = to_signed((aml_read_reg32_op(P_ENCP_VIDEO_OFLD_VOAV_OFST) & 0xf0)>>4) + de_v_begin_even + (TOTAL_LINES-1)/2; // 1 + 20 + (1125-1)/2 = 583
        de_v_end_odd    = de_v_begin_odd + ACTIVE_LINES;    // 583 + 540 = 1123
        aml_write_reg32_op(P_ENCP_DE_V_BEGIN_ODD, de_v_begin_odd);// 583
        aml_write_reg32_op(P_ENCP_DE_V_END_ODD,   de_v_end_odd);  // 1123
    }

    // Program Hsync timing
    if (de_h_end + front_porch_venc >= total_pixels_venc) {
        hs_begin    = de_h_end + front_porch_venc - total_pixels_venc; // 4226 + 176 - 4400 = 2





        vs_adjust   = 1;
    } else {
        hs_begin    = de_h_end + front_porch_venc;
        vs_adjust   = 0;
    }
    hs_end  = modulo(hs_begin + hsync_pixels_venc,   total_pixels_venc); // (2 + 88) % 4400 = 90
    aml_write_reg32_op(P_ENCP_DVI_HSO_BEGIN,  hs_begin);  // 2
    aml_write_reg32_op(P_ENCP_DVI_HSO_END,    hs_end);    // 90
    
    // Program Vsync timing for even field
    if (de_v_begin_even >= SOF_LINES + VSYNC_LINES + (1-vs_adjust)) {
        vs_bline_evn = de_v_begin_even - SOF_LINES - VSYNC_LINES - (1-vs_adjust); // 20 - 15 - 5 - 0 = 0
    } else {
        vs_bline_evn = TOTAL_LINES + de_v_begin_even - SOF_LINES - VSYNC_LINES - (1-vs_adjust);
    }
    vs_eline_evn = modulo(vs_bline_evn + VSYNC_LINES, TOTAL_LINES); // (0 + 5) % 1125 = 5
    aml_write_reg32_op(P_ENCP_DVI_VSO_BLINE_EVN, vs_bline_evn);   // 0
    aml_write_reg32_op(P_ENCP_DVI_VSO_ELINE_EVN, vs_eline_evn);   // 5
    vso_begin_evn = hs_begin; // 2
    aml_write_reg32_op(P_ENCP_DVI_VSO_BEGIN_EVN, vso_begin_evn);  // 2
    aml_write_reg32_op(P_ENCP_DVI_VSO_END_EVN,   vso_begin_evn);  // 2
    // Program Vsync timing for odd field if needed
    if (INTERLACE_MODE) {
        vs_bline_odd = de_v_begin_odd-1 - SOF_LINES - VSYNC_LINES;  // 583-1 - 15 - 5   = 562
        vs_eline_odd = de_v_begin_odd-1 - SOF_LINES;                // 583-1 - 15       = 567
        vso_begin_odd   = modulo(hs_begin + (total_pixels_venc>>1), total_pixels_venc); // (2 + 4400/2) % 4400 = 2202
        aml_write_reg32_op(P_ENCP_DVI_VSO_BLINE_ODD, vs_bline_odd);   // 562
        aml_write_reg32_op(P_ENCP_DVI_VSO_ELINE_ODD, vs_eline_odd);   // 567
        aml_write_reg32_op(P_ENCP_DVI_VSO_BEGIN_ODD, vso_begin_odd);  // 2202
        aml_write_reg32_op(P_ENCP_DVI_VSO_END_ODD,   vso_begin_odd);  // 2202
    }

    // Annie 01Sep2011: Register VENC_DVI_SETTING and VENC_DVI_SETTING_MORE are no long valid, use VPU_HDMI_SETTING instead.
    aml_write_reg32_op(P_VPU_HDMI_SETTING, (0                                 << 0) | // [    0] src_sel_enci
                         (0                                 << 1) | // [    1] src_sel_encp
                         (1                    << 2) | // [    2] inv_hsync. 1=Invert Hsync polarity.
                         (1                    << 3) | // [    3] inv_vsync. 1=Invert Vsync polarity.
                         (0                                 << 4) | // [    4] inv_dvi_clk. 1=Invert clock to external DVI, (clock invertion exists at internal HDMI).
                         (((1==0)?1:0)  << 5) | // [ 7: 5] data_comp_map. Input data is CrYCb(BRG), map the output data to desired format:
                                                                    //                          0=output CrYCb(BRG);
                                                                    //                          1=output YCbCr(RGB);
                                                                    //                          2=output YCrCb(RBG);
                                                                    //                          3=output CbCrY(GBR);
                                                                    //                          4=output CbYCr(GRB);
                                                                    //                          5=output CrCbY(BGR);
                                                                    //                          6,7=Rsrv.
#ifdef DOUBLE_CLK_720P_1080I
                         (0                                 << 8) | // [11: 8] wr_rate. 0=A write every clk1; 1=A write every 2 clk1; ...; 15=A write every 16 clk1.
#else                         
                         (1                                 << 8) | // [11: 8] wr_rate. 0=A write every clk1; 1=A write every 2 clk1; ...; 15=A write every 16 clk1.
#endif                         
                         (0                                 <<12)   // [15:12] rd_rate. 0=A read every clk2; 1=A read every 2 clk2; ...; 15=A read every 16 clk2.
    );
    aml_set_reg32_bits_op(P_VPU_HDMI_SETTING, 1, 1, 1);  // [    1] src_sel_encp: Enable ENCP output to HDMI

}    

static void hdmi_tvenc4k2k_set(HDMI_Video_Codes_t vic)
{
    unsigned long VFIFO2VD_TO_HDMI_LATENCY = 2; // Annie 01Sep2011: Change value from 3 to 2, due to video encoder path delay change.
    unsigned long TOTAL_PIXELS, PIXEL_REPEAT_HDMI, PIXEL_REPEAT_VENC, ACTIVE_PIXELS;
    unsigned FRONT_PORCH = 1020, HSYNC_PIXELS, ACTIVE_LINES = 2160, INTERLACE_MODE, TOTAL_LINES, SOF_LINES, VSYNC_LINES;
    unsigned LINES_F0 = 2250, LINES_F1 = 2250,BACK_PORCH, EOF_LINES = 8, TOTAL_FRAMES;

    unsigned long total_pixels_venc ;
    unsigned long active_pixels_venc;
    unsigned long front_porch_venc  ;
    unsigned long hsync_pixels_venc ;

    unsigned long de_h_begin, de_h_end;
    unsigned long de_v_begin_even, de_v_end_even, de_v_begin_odd, de_v_end_odd;
    unsigned long hs_begin, hs_end;
    unsigned long vs_adjust;
    unsigned long vs_bline_evn, vs_eline_evn, vs_bline_odd, vs_eline_odd;
    unsigned long vso_begin_evn, vso_begin_odd;

    if(vic == HDMI_4k2k_30){
         INTERLACE_MODE     = 0;
         PIXEL_REPEAT_VENC  = 0;
         PIXEL_REPEAT_HDMI  = 0;
         ACTIVE_PIXELS  =     (3840*(1+PIXEL_REPEAT_HDMI)); // Number of active pixels per line.
         ACTIVE_LINES   =     (2160/(1+INTERLACE_MODE));    // Number of active lines per field.
         LINES_F0           = 2250;
         LINES_F1           = 2250;
         FRONT_PORCH        = 176;
         HSYNC_PIXELS       = 88;
         BACK_PORCH         = 296;
         EOF_LINES          = 8 + 1;
         VSYNC_LINES        = 10;
         SOF_LINES          = 72 + 1;
         TOTAL_FRAMES       = 3;
    }
    else if(vic == HDMI_4k2k_25){
         INTERLACE_MODE     = 0;
         PIXEL_REPEAT_VENC  = 0;
         PIXEL_REPEAT_HDMI  = 0;
         ACTIVE_PIXELS  =     (3840*(1+PIXEL_REPEAT_HDMI)); // Number of active pixels per line.
         ACTIVE_LINES   =     (2160/(1+INTERLACE_MODE));    // Number of active lines per field.
         LINES_F0           = 2250;
         LINES_F1           = 2250;
         FRONT_PORCH        = 1056;
         HSYNC_PIXELS       = 88;
         BACK_PORCH         = 296;
         EOF_LINES          = 8 + 1;
         VSYNC_LINES        = 10;
         SOF_LINES          = 72 + 1;
         TOTAL_FRAMES       = 3;
    }
    else if(vic == HDMI_4k2k_24){
         INTERLACE_MODE     = 0;
         PIXEL_REPEAT_VENC  = 0;
         PIXEL_REPEAT_HDMI  = 0;
         ACTIVE_PIXELS  =     (3840*(1+PIXEL_REPEAT_HDMI)); // Number of active pixels per line.
         ACTIVE_LINES   =     (2160/(1+INTERLACE_MODE));    // Number of active lines per field.
         LINES_F0           = 2250;
         LINES_F1           = 2250;
         FRONT_PORCH        = 1276;
         HSYNC_PIXELS       = 88;
         BACK_PORCH         = 296;
         EOF_LINES          = 8 + 1;
         VSYNC_LINES        = 10;
         SOF_LINES          = 72 + 1;
         TOTAL_FRAMES       = 3;
    }
    else if(vic == HDMI_4k2k_smpte){
         INTERLACE_MODE     = 0;
         PIXEL_REPEAT_VENC  = 0;
         PIXEL_REPEAT_HDMI  = 0;
         ACTIVE_PIXELS  =     (4096*(1+PIXEL_REPEAT_HDMI)); // Number of active pixels per line.
         ACTIVE_LINES   =     (2160/(1+INTERLACE_MODE));    // Number of active lines per field.
         LINES_F0           = 2250;
         LINES_F1           = 2250;
         FRONT_PORCH        = 1020;
         HSYNC_PIXELS       = 88;
         BACK_PORCH         = 296;
         EOF_LINES          = 8 + 1;
         VSYNC_LINES        = 10;
         SOF_LINES          = 72 + 1;
         TOTAL_FRAMES       = 3;
    }
    else {
        // nothing
    }
    total_pixels_venc = (TOTAL_PIXELS  / (1+PIXEL_REPEAT_HDMI)) * (1+PIXEL_REPEAT_VENC);
    active_pixels_venc= (ACTIVE_PIXELS / (1+PIXEL_REPEAT_HDMI)) * (1+PIXEL_REPEAT_VENC);
    front_porch_venc  = (FRONT_PORCH   / (1+PIXEL_REPEAT_HDMI)) * (1+PIXEL_REPEAT_VENC);
    hsync_pixels_venc = (HSYNC_PIXELS  / (1+PIXEL_REPEAT_HDMI)) * (1+PIXEL_REPEAT_VENC);

    de_h_begin = modulo(aml_read_reg32_op(P_ENCP_VIDEO_HAVON_BEGIN) + VFIFO2VD_TO_HDMI_LATENCY,  total_pixels_venc);
    de_h_end   = modulo(de_h_begin + active_pixels_venc,                        total_pixels_venc);
    aml_write_reg32_op(P_ENCP_DE_H_BEGIN, de_h_begin);
    aml_write_reg32_op(P_ENCP_DE_H_END,   de_h_end);
    // Program DE timing for even field
    de_v_begin_even = aml_read_reg32_op(P_ENCP_VIDEO_VAVON_BLINE);
    de_v_end_even   = modulo(de_v_begin_even + ACTIVE_LINES, TOTAL_LINES);
    aml_write_reg32_op(P_ENCP_DE_V_BEGIN_EVEN,de_v_begin_even);
    aml_write_reg32_op(P_ENCP_DE_V_END_EVEN,  de_v_end_even);
    // Program DE timing for odd field if needed
    if (INTERLACE_MODE) {
        // Calculate de_v_begin_odd according to enc480p_timing.v:
        //wire[10:0]	cfg_ofld_vavon_bline	= {{7{ofld_vavon_ofst1 [3]}},ofld_vavon_ofst1 [3:0]} + cfg_video_vavon_bline	+ ofld_line;
        de_v_begin_odd  = to_signed((aml_read_reg32_op(P_ENCP_VIDEO_OFLD_VOAV_OFST) & 0xf0)>>4) + de_v_begin_even + (TOTAL_LINES-1)/2;
        de_v_end_odd    = modulo(de_v_begin_odd + ACTIVE_LINES, TOTAL_LINES);
        aml_write_reg32_op(P_ENCP_DE_V_BEGIN_ODD, de_v_begin_odd);
        aml_write_reg32_op(P_ENCP_DE_V_END_ODD,   de_v_end_odd);
    }

    // Program Hsync timing
    if (de_h_end + front_porch_venc >= total_pixels_venc) {
        hs_begin    = de_h_end + front_porch_venc - total_pixels_venc;
        vs_adjust   = 1;
    } else {
        hs_begin    = de_h_end + front_porch_venc;
        vs_adjust   = 0;
    }
    hs_end  = modulo(hs_begin + hsync_pixels_venc,   total_pixels_venc);
    aml_write_reg32_op(P_ENCP_DVI_HSO_BEGIN,  hs_begin);
    aml_write_reg32_op(P_ENCP_DVI_HSO_END,    hs_end);
    
    // Program Vsync timing for even field
    if (de_v_begin_even >= SOF_LINES + VSYNC_LINES + (1-vs_adjust)) {
        vs_bline_evn = de_v_begin_even - SOF_LINES - VSYNC_LINES - (1-vs_adjust);
    } else {
        vs_bline_evn = TOTAL_LINES + de_v_begin_even - SOF_LINES - VSYNC_LINES - (1-vs_adjust);
    }
    vs_eline_evn = modulo(vs_bline_evn + VSYNC_LINES, TOTAL_LINES);
    aml_write_reg32_op(P_ENCP_DVI_VSO_BLINE_EVN, vs_bline_evn);
    aml_write_reg32_op(P_ENCP_DVI_VSO_ELINE_EVN, vs_eline_evn);
    vso_begin_evn = hs_begin;
    aml_write_reg32_op(P_ENCP_DVI_VSO_BEGIN_EVN, vso_begin_evn);
    aml_write_reg32_op(P_ENCP_DVI_VSO_END_EVN,   vso_begin_evn);
    // Program Vsync timing for odd field if needed
    if (INTERLACE_MODE) {
        vs_bline_odd = de_v_begin_odd-1 - SOF_LINES - VSYNC_LINES;
        vs_eline_odd = de_v_begin_odd-1 - SOF_LINES;
        vso_begin_odd   = modulo(hs_begin + (total_pixels_venc>>1), total_pixels_venc);
        aml_write_reg32_op(P_ENCP_DVI_VSO_BLINE_ODD, vs_bline_odd);
        aml_write_reg32_op(P_ENCP_DVI_VSO_ELINE_ODD, vs_eline_odd);
        aml_write_reg32_op(P_ENCP_DVI_VSO_BEGIN_ODD, vso_begin_odd);
        aml_write_reg32_op(P_ENCP_DVI_VSO_END_ODD,   vso_begin_odd);
    }
    aml_write_reg32_op(P_VPU_HDMI_SETTING, (0                                 << 0) | // [    0] src_sel_enci
                         (0                                 << 1) | // [    1] src_sel_encp
                         (HSYNC_POLARITY                    << 2) | // [    2] inv_hsync. 1=Invert Hsync polarity.
                         (VSYNC_POLARITY                    << 3) | // [    3] inv_vsync. 1=Invert Vsync polarity.
                         (0                                 << 4) | // [    4] inv_dvi_clk. 1=Invert clock to external DVI, (clock invertion exists at internal HDMI).
                         (((1==0)?1:0)  << 5) | // [ 7: 5] data_comp_map. Input data is CrYCb(BRG), map the output data to desired format:
                                                                    //                          0=output CrYCb(BRG);
                                                                    //                          1=output YCbCr(RGB);
                                                                    //                          2=output YCrCb(RBG);
                                                                    //                          3=output CbCrY(GBR);
                                                                    //                          4=output CbYCr(GRB);
                                                                    //                          5=output CrCbY(BGR);
                                                                    //                          6,7=Rsrv.
                         (0                                 << 8) | // [11: 8] wr_rate. 0=A write every clk1; 1=A write every 2 clk1; ...; 15=A write every 16 clk1.
                         (0                                 <<12)   // [15:12] rd_rate. 0=A read every clk2; 1=A read every 2 clk2; ...; 15=A read every 16 clk2.
    );
    aml_set_reg32_bits_op(P_VPU_HDMI_SETTING, 1, 1, 1);  // [    1] src_sel_encp: Enable ENCP output to HDMI
    aml_write_reg32_op(P_ENCP_VIDEO_EN, 1); // Enable VENC
}

static void hdmi_tvenc_set(HDMI_Video_Codes_t vic)
{
    unsigned long VFIFO2VD_TO_HDMI_LATENCY = 2; // Annie 01Sep2011: Change value from 3 to 2, due to video encoder path delay change.
    unsigned long TOTAL_PIXELS, PIXEL_REPEAT_HDMI, PIXEL_REPEAT_VENC, ACTIVE_PIXELS;
    unsigned FRONT_PORCH, HSYNC_PIXELS, ACTIVE_LINES, INTERLACE_MODE, TOTAL_LINES, SOF_LINES, VSYNC_LINES;
    unsigned LINES_F0, LINES_F1,BACK_PORCH, EOF_LINES, TOTAL_FRAMES;

    unsigned long total_pixels_venc ;
    unsigned long active_pixels_venc;
    unsigned long front_porch_venc  ;
    unsigned long hsync_pixels_venc ;

    unsigned long de_h_begin, de_h_end;
    unsigned long de_v_begin_even, de_v_end_even, de_v_begin_odd, de_v_end_odd;
    unsigned long hs_begin, hs_end;
    unsigned long vs_adjust;
    unsigned long vs_bline_evn, vs_eline_evn, vs_bline_odd, vs_eline_odd;
    unsigned long vso_begin_evn, vso_begin_odd;

    if((vic == HDMI_480p60)||(vic == HDMI_480p60_16x9)){
         INTERLACE_MODE     = 0;                   
         PIXEL_REPEAT_VENC  = 1;                   
         PIXEL_REPEAT_HDMI  = 0;                   
         ACTIVE_PIXELS      = (720*(1+PIXEL_REPEAT_HDMI)); // Number of active pixels per line.
         ACTIVE_LINES       = (480/(1+INTERLACE_MODE));    // Number of active lines per field.
         LINES_F0           = 525;                 
         LINES_F1           = 525;                 
         FRONT_PORCH        = 16;                  
         HSYNC_PIXELS       = 62;                  
         BACK_PORCH         = 60;                  
         EOF_LINES          = 9;                   
         VSYNC_LINES        = 6;                   
         SOF_LINES          = 30;                  
         TOTAL_FRAMES       = 4;                   
    }
    else if((vic == HDMI_576p50)||(vic == HDMI_576p50_16x9)){
         INTERLACE_MODE     = 0;                   
         PIXEL_REPEAT_VENC  = 1;                   
         PIXEL_REPEAT_HDMI  = 0;                   
         ACTIVE_PIXELS      = (720*(1+PIXEL_REPEAT_HDMI)); // Number of active pixels per line.
         ACTIVE_LINES       = (576/(1+INTERLACE_MODE));    // Number of active lines per field.
         LINES_F0           = 625;                 
         LINES_F1           = 625;                 
         FRONT_PORCH        = 12;                  
         HSYNC_PIXELS       = 64;                  
         BACK_PORCH         = 68;                  
         EOF_LINES          = 5;                   
         VSYNC_LINES        = 5;                   
         SOF_LINES          = 39;                  
         TOTAL_FRAMES       = 4;                   
    }
    else if(vic == HDMI_720p60){
         INTERLACE_MODE     = 0;                   
         PIXEL_REPEAT_VENC  = 1;                   
         PIXEL_REPEAT_HDMI  = 0;                   
         ACTIVE_PIXELS      = (1280*(1+PIXEL_REPEAT_HDMI)); // Number of active pixels per line.
         ACTIVE_LINES       = (720/(1+INTERLACE_MODE));    // Number of active lines per field.
         LINES_F0           = 750;                 
         LINES_F1           = 750;                 
         FRONT_PORCH        = 110;                  
         HSYNC_PIXELS       = 40;                  
         BACK_PORCH         = 220;                  
         EOF_LINES          = 5;                   
         VSYNC_LINES        = 5;                   
         SOF_LINES          = 20;                  
         TOTAL_FRAMES       = 4;                   
    }
    else if(vic == HDMI_720p50){
         INTERLACE_MODE     = 0;                   
         PIXEL_REPEAT_VENC  = 1;                   
         PIXEL_REPEAT_HDMI  = 0;                   
         ACTIVE_PIXELS      = (1280*(1+PIXEL_REPEAT_HDMI)); // Number of active pixels per line.
         ACTIVE_LINES       = (720/(1+INTERLACE_MODE));    // Number of active lines per field.
         LINES_F0           = 750;                 
         LINES_F1           = 750;                 
         FRONT_PORCH        = 440;                  
         HSYNC_PIXELS       = 40;                  
         BACK_PORCH         = 220;                  
         EOF_LINES          = 5;                   
         VSYNC_LINES        = 5;                   
         SOF_LINES          = 20;                  
         TOTAL_FRAMES       = 4;                   
    }
    else if(vic == HDMI_1080p50){
         INTERLACE_MODE      =0;              
         PIXEL_REPEAT_VENC   =0;              
         PIXEL_REPEAT_HDMI   =0;              
         ACTIVE_PIXELS       =(1920*(1+PIXEL_REPEAT_HDMI)); // Number of active pixels per line.
         ACTIVE_LINES        =(1080/(1+INTERLACE_MODE));    // Number of active lines per field.
         LINES_F0            =1125;           
         LINES_F1            =1125;           
         FRONT_PORCH         =528;             
         HSYNC_PIXELS        =44;             
         BACK_PORCH          =148;            
         EOF_LINES           =4;              
         VSYNC_LINES         =5;              
         SOF_LINES           =36;             
         TOTAL_FRAMES        =4;              
    }
    else if(vic == HDMI_1080p24){//1080p24 support
         INTERLACE_MODE      =0;              
         PIXEL_REPEAT_VENC   =0;              
         PIXEL_REPEAT_HDMI   =0;              
         ACTIVE_PIXELS       =(1920*(1+PIXEL_REPEAT_HDMI)); // Number of active pixels per line.
         ACTIVE_LINES        =(1080/(1+INTERLACE_MODE));    // Number of active lines per field.
         LINES_F0            =1125;           
         LINES_F1            =1125;           
         FRONT_PORCH         =638;             
         HSYNC_PIXELS        =44;             
         BACK_PORCH          =148;            
         EOF_LINES           =4;              
         VSYNC_LINES         =5;              
         SOF_LINES           =36;             
         TOTAL_FRAMES        =4;    
    }
    else{ //HDMI_1080p60, HDMI_1080p30
         INTERLACE_MODE      =0;              
         PIXEL_REPEAT_VENC   =0;              
         PIXEL_REPEAT_HDMI   =0;              
         ACTIVE_PIXELS       =(1920*(1+PIXEL_REPEAT_HDMI)); // Number of active pixels per line.
         ACTIVE_LINES        =(1080/(1+INTERLACE_MODE));    // Number of active lines per field.
         LINES_F0            =1125;           
         LINES_F1            =1125;           
         FRONT_PORCH         =88;             
         HSYNC_PIXELS        =44;             
         BACK_PORCH          =148;            
         EOF_LINES           =4;              
         VSYNC_LINES         =5;              
         SOF_LINES           =36;             
         TOTAL_FRAMES        =4;              
    }

    TOTAL_PIXELS       = (FRONT_PORCH+HSYNC_PIXELS+BACK_PORCH+ACTIVE_PIXELS); // Number of total pixels per line.
    TOTAL_LINES        = (LINES_F0+(LINES_F1*INTERLACE_MODE));                // Number of total lines per frame.

    total_pixels_venc = (TOTAL_PIXELS  / (1+PIXEL_REPEAT_HDMI)) * (1+PIXEL_REPEAT_VENC); // 858 / 1 * 2 = 1716
    active_pixels_venc= (ACTIVE_PIXELS / (1+PIXEL_REPEAT_HDMI)) * (1+PIXEL_REPEAT_VENC); // 720 / 1 * 2 = 1440
    front_porch_venc  = (FRONT_PORCH   / (1+PIXEL_REPEAT_HDMI)) * (1+PIXEL_REPEAT_VENC); // 16   / 1 * 2 = 32
    hsync_pixels_venc = (HSYNC_PIXELS  / (1+PIXEL_REPEAT_HDMI)) * (1+PIXEL_REPEAT_VENC); // 62   / 1 * 2 = 124

    hdmi_print(0, "[ENCP_VIDEO_MODE:%x]=%x\n",ENCP_VIDEO_MODE, aml_read_reg32_op(P_ENCP_VIDEO_MODE)); 
    aml_write_reg32_op(P_ENCP_VIDEO_MODE,aml_read_reg32_op(P_ENCP_VIDEO_MODE)|(1<<14)); // cfg_de_v = 1
    // Program DE timing
    hdmi_print(0, "[ENCP_VIDEO_HAVON_BEGIN:%x]=%x\n",ENCP_VIDEO_HAVON_BEGIN, aml_read_reg32_op(P_ENCP_VIDEO_HAVON_BEGIN)); 
    de_h_begin = modulo(aml_read_reg32_op(P_ENCP_VIDEO_HAVON_BEGIN) + VFIFO2VD_TO_HDMI_LATENCY,  total_pixels_venc); // (217 + 3) % 1716 = 220
    de_h_end   = modulo(de_h_begin + active_pixels_venc,                        total_pixels_venc); // (220 + 1440) % 1716 = 1660
    aml_write_reg32_op(P_ENCP_DE_H_BEGIN, de_h_begin);    // 220
    aml_write_reg32_op(P_ENCP_DE_H_END,   de_h_end);      // 1660
    // Program DE timing for even field
    hdmi_print(0, "[ENCP_VIDEO_VAVON_BLINE:%x]=%x\n",ENCP_VIDEO_VAVON_BLINE, aml_read_reg32_op(P_ENCP_VIDEO_VAVON_BLINE)); 
    de_v_begin_even = aml_read_reg32_op(P_ENCP_VIDEO_VAVON_BLINE);       // 42
    de_v_end_even   = de_v_begin_even + ACTIVE_LINES;   // 42 + 480 = 522
    aml_write_reg32_op(P_ENCP_DE_V_BEGIN_EVEN,de_v_begin_even);   // 42
    aml_write_reg32_op(P_ENCP_DE_V_END_EVEN,  de_v_end_even);     // 522
    // Program DE timing for odd field if needed
    if (INTERLACE_MODE) {
        // Calculate de_v_begin_odd according to enc480p_timing.v:
        //wire[10:0]    cfg_ofld_vavon_bline    = {{7{ofld_vavon_ofst1 [3]}},ofld_vavon_ofst1 [3:0]} + cfg_video_vavon_bline    + ofld_line;
        hdmi_print(0, "[ENCP_VIDEO_OFLD_VOAV_OFST:%x]=%x\n",ENCP_VIDEO_OFLD_VOAV_OFST, aml_read_reg32_op(P_ENCP_VIDEO_OFLD_VOAV_OFST)); 
        de_v_begin_odd  = to_signed((aml_read_reg32_op(P_ENCP_VIDEO_OFLD_VOAV_OFST) & 0xf0)>>4) + de_v_begin_even + (TOTAL_LINES-1)/2;
        de_v_end_odd    = de_v_begin_odd + ACTIVE_LINES;
        aml_write_reg32_op(P_ENCP_DE_V_BEGIN_ODD, de_v_begin_odd);
        aml_write_reg32_op(P_ENCP_DE_V_END_ODD,   de_v_end_odd);
    }

    // Program Hsync timing
    if (de_h_end + front_porch_venc >= total_pixels_venc) {
        hs_begin    = de_h_end + front_porch_venc - total_pixels_venc;
        vs_adjust   = 1;
    } else {
        hs_begin    = de_h_end + front_porch_venc; // 1660 + 32 = 1692
        vs_adjust   = 0;
    }
    hs_end  = modulo(hs_begin + hsync_pixels_venc,   total_pixels_venc); // (1692 + 124) % 1716 = 100
    aml_write_reg32_op(P_ENCP_DVI_HSO_BEGIN,  hs_begin);  // 1692
    aml_write_reg32_op(P_ENCP_DVI_HSO_END,    hs_end);    // 100
    
    // Program Vsync timing for even field
    if (de_v_begin_even >= SOF_LINES + VSYNC_LINES + (1-vs_adjust)) {
        vs_bline_evn = de_v_begin_even - SOF_LINES - VSYNC_LINES - (1-vs_adjust); // 42 - 30 - 6 - 1 = 5
    } else {
        vs_bline_evn = TOTAL_LINES + de_v_begin_even - SOF_LINES - VSYNC_LINES - (1-vs_adjust);
    }
    vs_eline_evn = modulo(vs_bline_evn + VSYNC_LINES, TOTAL_LINES); // (5 + 6) % 525 = 11
    aml_write_reg32_op(P_ENCP_DVI_VSO_BLINE_EVN, vs_bline_evn);   // 5
    aml_write_reg32_op(P_ENCP_DVI_VSO_ELINE_EVN, vs_eline_evn);   // 11
    vso_begin_evn = hs_begin; // 1692
    aml_write_reg32_op(P_ENCP_DVI_VSO_BEGIN_EVN, vso_begin_evn);  // 1692
    aml_write_reg32_op(P_ENCP_DVI_VSO_END_EVN,   vso_begin_evn);  // 1692
    // Program Vsync timing for odd field if needed
    if (INTERLACE_MODE) {
        vs_bline_odd = de_v_begin_odd-1 - SOF_LINES - VSYNC_LINES;
        vs_eline_odd = de_v_begin_odd-1 - SOF_LINES;
        vso_begin_odd   = modulo(hs_begin + (total_pixels_venc>>1), total_pixels_venc);
        aml_write_reg32_op(P_ENCP_DVI_VSO_BLINE_ODD, vs_bline_odd);
        aml_write_reg32_op(P_ENCP_DVI_VSO_ELINE_ODD, vs_eline_odd);
        aml_write_reg32_op(P_ENCP_DVI_VSO_BEGIN_ODD, vso_begin_odd);
        aml_write_reg32_op(P_ENCP_DVI_VSO_END_ODD,   vso_begin_odd);
    }
    // Annie 01Sep2011: Remove the following line as register VENC_DVI_SETTING_MORE is no long valid, use VPU_HDMI_SETTING instead.
    //Wr(VENC_DVI_SETTING_MORE, (TX_INPUT_COLOR_FORMAT==0)? 1 : 0); // [0] 0=Map data pins from Venc to Hdmi Tx as CrYCb mode;

    switch(vic)
    {
        case HDMI_480p60:
        case HDMI_480p60_16x9:
        case HDMI_576p50:
        case HDMI_576p50_16x9:
//Note: Hsync & Vsync polarity should be negative.
//Refer to HDMI CTS 1.4A Page 169
            // Annie 01Sep2011: Register VENC_DVI_SETTING and VENC_DVI_SETTING_MORE are no long valid, use VPU_HDMI_SETTING instead.
            aml_write_reg32_op(P_VPU_HDMI_SETTING, (0                                 << 0) | // [    0] src_sel_enci
                                 (0                                 << 1) | // [    1] src_sel_encp
                                 (0                                 << 2) | // [    2] inv_hsync. 1=Invert Hsync polarity.
                                 (0                                 << 3) | // [    3] inv_vsync. 1=Invert Vsync polarity.
                                 (0                                 << 4) | // [    4] inv_dvi_clk. 1=Invert clock to external DVI, (clock invertion exists at internal HDMI).
                                 (((1==0)?1:0)  << 5) | // [ 7: 5] data_comp_map. Input data is CrYCb(BRG), map the output data to desired format:
                                                                            //                          0=output CrYCb(BRG);
                                                                            //                          1=output YCbCr(RGB);
                                                                            //                          2=output YCrCb(RBG);
                                                                            //                          3=output CbCrY(GBR);
                                                                            //                          4=output CbYCr(GRB);
                                                                            //                          5=output CrCbY(BGR);
                                                                            //                          6,7=Rsrv.
                                 (1                                 << 8) | // [11: 8] wr_rate. 0=A write every clk1; 1=A write every 2 clk1; ...; 15=A write every 16 clk1.
                                 (0                                 <<12)   // [15:12] rd_rate. 0=A read every clk2; 1=A read every 2 clk2; ...; 15=A read every 16 clk2.
            );
            break;
        case HDMI_720p60:
        case HDMI_720p50:
            // Annie 01Sep2011: Register VENC_DVI_SETTING and VENC_DVI_SETTING_MORE are no long valid, use VPU_HDMI_SETTING instead.
            aml_write_reg32_op(P_VPU_HDMI_SETTING, (0                                 << 0) | // [    0] src_sel_enci
                                 (0                                 << 1) | // [    1] src_sel_encp
                                 (HSYNC_POLARITY                    << 2) | // [    2] inv_hsync. 1=Invert Hsync polarity.
                                 (VSYNC_POLARITY                    << 3) | // [    3] inv_vsync. 1=Invert Vsync polarity.
                                 (0                                 << 4) | // [    4] inv_dvi_clk. 1=Invert clock to external DVI, (clock invertion exists at internal HDMI).
                                 (((1==0)?1:0)  << 5) | // [ 7: 5] data_comp_map. Input data is CrYCb(BRG), map the output data to desired format:
                                                                            //                          0=output CrYCb(BRG);
                                                                            //                          1=output YCbCr(RGB);
                                                                            //                          2=output YCrCb(RBG);
                                                                            //                          3=output CbCrY(GBR);
                                                                            //                          4=output CbYCr(GRB);
                                                                            //                          5=output CrCbY(BGR);
                                                                            //                          6,7=Rsrv.
#ifdef DOUBLE_CLK_720P_1080I
                                 (0                                 << 8) | // [11: 8] wr_rate. 0=A write every clk1; 1=A write every 2 clk1; ...; 15=A write every 16 clk1.
#else
                                 (1                                 << 8) | // [11: 8] wr_rate. 0=A write every clk1; 1=A write every 2 clk1; ...; 15=A write every 16 clk1.
#endif                             
                                 (0                                 <<12)   // [15:12] rd_rate. 0=A read every clk2; 1=A read every 2 clk2; ...; 15=A read every 16 clk2.
            );
            break;
        default:
            // Annie 01Sep2011: Register VENC_DVI_SETTING and VENC_DVI_SETTING_MORE are no long valid, use VPU_HDMI_SETTING instead.
            aml_write_reg32_op(P_VPU_HDMI_SETTING, (0                                 << 0) | // [    0] src_sel_enci
                                 (0                                 << 1) | // [    1] src_sel_encp
                                 (HSYNC_POLARITY                    << 2) | // [    2] inv_hsync. 1=Invert Hsync polarity.
                                 (VSYNC_POLARITY                    << 3) | // [    3] inv_vsync. 1=Invert Vsync polarity.
                                 (0                                 << 4) | // [    4] inv_dvi_clk. 1=Invert clock to external DVI, (clock invertion exists at internal HDMI).
                                 (((1==0)?1:0)  << 5) | // [ 7: 5] data_comp_map. Input data is CrYCb(BRG), map the output data to desired format:
                                                                            //                          0=output CrYCb(BRG);
                                                                            //                          1=output YCbCr(RGB);
                                                                            //                          2=output YCrCb(RBG);
                                                                            //                          3=output CbCrY(GBR);
                                                                            //                          4=output CbYCr(GRB);
                                                                            //                          5=output CrCbY(BGR);
                                                                            //                          6,7=Rsrv.
                                 (0                                 << 8) | // [11: 8] wr_rate. 0=A write every clk1; 1=A write every 2 clk1; ...; 15=A write every 16 clk1.
                                 (0                                 <<12)   // [15:12] rd_rate. 0=A read every clk2; 1=A read every 2 clk2; ...; 15=A read every 16 clk2.
            );
    }

    // Annie 01Sep2011: Register VENC_DVI_SETTING and VENC_DVI_SETTING_MORE are no long valid, use VPU_HDMI_SETTING instead.
    aml_set_reg32_bits_op(P_VPU_HDMI_SETTING, 1, 1, 1);  // [    1] src_sel_encp: Enable ENCP output to HDMI
}    

static void hdmi_tx_enc(HDMI_Video_Codes_t vic)
{
    switch(vic){
        case HDMI_480i60:
        case HDMI_480i60_16x9:
        case HDMI_576i50:
        case HDMI_576i50_16x9:
            hdmi_tvenc480i_set(vic);
            break;
        case HDMI_1080i60:
        case HDMI_1080i50:
            hdmi_tvenc1080i_set(vic);
            break;
        case HDMI_4k2k_30:
        case HDMI_4k2k_25:
        case HDMI_4k2k_24:
        case HDMI_4k2k_smpte:
            hdmi_tvenc4k2k_set(vic);
            break;
        default:
            hdmi_tvenc_set(vic);
        }
}

static void hdmi_tx_phy(HDMI_Video_Codes_t vic)
{
    switch(vic) {
    case HDMI_4k2k_30:
    case HDMI_4k2k_25:
    case HDMI_4k2k_24:
    case HDMI_4k2k_smpte:
        aml_write_reg32_op(P_HHI_HDMI_PHY_CNTL0, 0x08c34d0b);
        break;
    default:
        aml_write_reg32_op(P_HHI_HDMI_PHY_CNTL0, 0x08c31e8b);
    }
    aml_write_reg32_op(P_HHI_HDMI_PHY_CNTL1, 0);
    aml_write_reg32_op(P_HHI_HDMI_PHY_CNTL1, 1);       // Soft Reset HDMI PHY
    h_delay();
    aml_write_reg32_op(P_HHI_HDMI_PHY_CNTL1, 0);
    h_delay();
    aml_write_reg32_op(P_HHI_HDMI_PHY_CNTL1, 2);       // Enable HDMI PHY
}

static void hdmitx_set_packet(int type, unsigned char* DB, unsigned char* HB)
{
    // AVI frame
    int i ;
    unsigned char ucData ;
    unsigned int pkt_reg_base=TX_PKT_REG_AVI_INFO_BASE_ADDR;
    int pkt_data_len=0;
    
    switch(type)
    {
        case HDMI_PACKET_AVI:
            pkt_reg_base=TX_PKT_REG_AVI_INFO_BASE_ADDR; 
            pkt_data_len=13;
            break;
        case HDMI_PACKET_VEND:
            pkt_reg_base=TX_PKT_REG_VEND_INFO_BASE_ADDR;
            pkt_data_len=6;
            break;
        case HDMI_AUDIO_INFO:
            pkt_reg_base=TX_PKT_REG_AUDIO_INFO_BASE_ADDR;
            pkt_data_len=9;
            break;
        case HDMI_SOURCE_DESCRIPTION:
            pkt_reg_base=TX_PKT_REG_SPD_INFO_BASE_ADDR;
            pkt_data_len=25;
        default:
            break;
    }
    
    if(DB){
        for(i=0;i<pkt_data_len;i++){
            hdmi_wr_reg(pkt_reg_base+i+1, DB[i]);  
        }
    
        for(i = 0,ucData = 0; i < pkt_data_len ; i++)
        {
            ucData -= DB[i] ;
        }
        for(i=0; i<3; i++){
            ucData -= HB[i];
        }
        hdmi_wr_reg(pkt_reg_base+0x00, ucData);  
    
        hdmi_wr_reg(pkt_reg_base+0x1C, HB[0]);        
        hdmi_wr_reg(pkt_reg_base+0x1D, HB[1]);        
        hdmi_wr_reg(pkt_reg_base+0x1E, HB[2]);        
        hdmi_wr_reg(pkt_reg_base+0x1F, 0x00ff);        // Enable packet generation
    }
    else{
        hdmi_wr_reg(pkt_reg_base+0x1F, 0x0);        // disable packet generation
    }
}

static void hdmi_tx_set_vend_spec_infofram(HDMI_Video_Codes_t vic)
{
    int i;
    unsigned char VEN_DB[6];
    unsigned char VEN_HB[3];
    VEN_HB[0] = 0x81; 
    VEN_HB[1] = 0x01; 
    VEN_HB[2] = 0x6; 

    if(!((vic >= HDMI_4k2k_30) && (vic <= HDMI_4k2k_smpte)))
        return;

    for(i = 0; i < 0x6; i++){
        VEN_DB[i] = 0;
    }
    VEN_DB[0] = 0x03;
    VEN_DB[1] = 0x0c;
    VEN_DB[2] = 0x00;

    VEN_DB[3] = 0x20;         // 4k x 2k  Spec P156
    if(vic == HDMI_4k2k_30)
        VEN_DB[4] = 0x1;
    else if(vic == HDMI_4k2k_25)
        VEN_DB[4] = 0x2;
    else if(vic == HDMI_4k2k_24)
        VEN_DB[4] = 0x3;
    else if(vic == HDMI_4k2k_smpte)
        VEN_DB[4] = 0x4;
    else {
        // nothing
    }
    hdmitx_set_packet(HDMI_PACKET_VEND, VEN_DB, VEN_HB);
}

// When have below format output, we shall manually configure
// bolow register to get stable Video Timing.
static void hdmi_reconfig_packet_setting(HDMI_Video_Codes_t vic)
{
    switch(vic) {
    case HDMI_1080p50:
        hdmi_wr_reg(TX_PACKET_CONTROL_1, 0x3a);         //0x7e
        hdmi_wr_reg(TX_PACKET_ALLOC_ACTIVE_1, 0x01);    //0x78
        hdmi_wr_reg(TX_PACKET_ALLOC_ACTIVE_2, 0x12);    //0x79
        hdmi_wr_reg(TX_PACKET_ALLOC_EOF_1, 0x10);       //0x7a
        hdmi_wr_reg(TX_PACKET_ALLOC_EOF_2, 0x12);       //0x7b
        hdmi_wr_reg(TX_CORE_ALLOC_VSYNC_0, 0x01);       //0x81
        hdmi_wr_reg(TX_CORE_ALLOC_VSYNC_1, 0x00);       //0x82
        hdmi_wr_reg(TX_CORE_ALLOC_VSYNC_2, 0x0a);       //0x83
        hdmi_wr_reg(TX_PACKET_ALLOC_SOF_1, 0xb6);       //0x7c
        hdmi_wr_reg(TX_PACKET_ALLOC_SOF_2, 0x11);       //0x7d
        hdmi_wr_reg(TX_PACKET_CONTROL_1, 0xba);         //0x7e
        break;
    default:
        break;
    }
    printf("reconfig packet setting done\n");
}

void hdmi_tx_set(HDMI_Video_Codes_t vic) 
{
	// reset SD 4:3 to 16:9 formats
	if((vic == HDMI_480p60) || (vic == HDMI_480i60) || (vic == HDMI_576p50) || (vic == HDMI_576i50))
		vic ++;
	printf("set HDMI vic: %d\n", vic);

    if((vic >= HDMI_4k2k_30) && (vic <= HDMI_4k2k_smpte)) {
        printf("Not supported HDMI mode: %d\n", vic);
        return;
    }
    hdmi_tx_gate(vic);
    hdmi_tx_clk(vic);
    hdmi_tx_misc(vic);
    hdmi_tx_enc(vic);
    hdmi_tx_set_vend_spec_infofram(vic);
    hdmi_reconfig_packet_setting(vic);
    hdmi_tx_phy(vic);
}
