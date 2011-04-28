/*
 * AMLOGIC timing controller driver.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the named License,
 * or any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA
 *
 * Author:  Elvis Yu <elvis.yu@amlogic.com>
 *
 */
#include <common.h>
#include <malloc.h>
#include <asm/arch/io.h>
#include <asm/arch/vinfo.h>
#include <asm/arch/lcdoutc.h>
#include <amlogic/aml_lcd.h>
#include <asm/arch/mlvds_regs.h>
#include <asm/arch/clock.h>
#include <asm/arch/timing.h>
#include <asm/arch/gpio.h>

//M6 PLL control value
#define M6_PLL_CNTL_CST2 (0x814d3928)
#define M6_PLL_CNTL_CST3 (0x6b425012)
#define M6_PLL_CNTL_CST4 (0x110)

//VID PLL
#define M6_VID_PLL_CNTL_2 (M6_PLL_CNTL_CST2)
#define M6_VID_PLL_CNTL_3 (M6_PLL_CNTL_CST3)
#define M6_VID_PLL_CNTL_4 (M6_PLL_CNTL_CST4)

#define FIQ_VSYNC
#define BL_MAX_LEVEL 0x100
#define PANEL_NAME	"panel"
#define NO_ENCT
#define NO_2ND_PLL

#define VPP_OUT_SATURATE            (1 << 0)
#ifdef PRINT_DEBUG_INFO
#define PRINT_INFO(...)        printf(__VA_ARGS__)
#else
#define PRINT_INFO(...)
#endif

typedef struct {
    Lcd_Config_t conf;
    vinfo_t lcd_info;
} lcd_dev_t;

static lcd_dev_t *pDev = NULL;

static int bit_num = 1;
static int pn_swap = 0;
static int dual_port = 1;
static int lvds_repack = 1;
static int port_reverse = 1;
static int bit_num_flag = 1;
static int lvds_repack_flag = 1;
static int port_reverse_flag = 1;

int flaga = 0;
int flagb = 0;
int flagc = 0;
int flagd = 0;
static void _lcd_init(Lcd_Config_t *pConf) ;

#if 0
static void set_lcd_gamma_table_ttl(u16 *data, u32 rgb_mask)
{
    int i;

    while (!(READ_MPEG_REG(GAMMA_CNTL_PORT) & (0x1 << ADR_RDY)));
    WRITE_MPEG_REG(GAMMA_ADDR_PORT, (0x1 << H_AUTO_INC) |
                                    (0x1 << rgb_mask)   |
                                    (0x0 << HADR));
    for (i=0;i<256;i++) {
        while (!( READ_MPEG_REG(GAMMA_CNTL_PORT) & (0x1 << WR_RDY) )) ;
        WRITE_MPEG_REG(GAMMA_DATA_PORT, data[i]);
    }
    while (!(READ_MPEG_REG(GAMMA_CNTL_PORT) & (0x1 << ADR_RDY)));
    WRITE_MPEG_REG(GAMMA_ADDR_PORT, (0x1 << H_AUTO_INC) |
                                    (0x1 << rgb_mask)   |
                                    (0x23 << HADR));
}

static void set_lcd_gamma_table_lvds(u16 *data, u32 rgb_mask)
{
    int i;

    while (!(READ_MPEG_REG(L_GAMMA_CNTL_PORT) & (0x1 << ADR_RDY)));
    WRITE_MPEG_REG(L_GAMMA_ADDR_PORT, (0x1 << H_AUTO_INC) |
                                    (0x1 << rgb_mask)   |
                                    (0x0 << HADR));
    for (i=0;i<256;i++) {
        while (!( READ_MPEG_REG(L_GAMMA_CNTL_PORT) & (0x1 << WR_RDY) )) ;
        WRITE_MPEG_REG(L_GAMMA_DATA_PORT, data[i]);
    }
    while (!(READ_MPEG_REG(L_GAMMA_CNTL_PORT) & (0x1 << ADR_RDY)));
    WRITE_MPEG_REG(L_GAMMA_ADDR_PORT, (0x1 << H_AUTO_INC) |
                                    (0x1 << rgb_mask)   |
                                    (0x23 << HADR));
}
#endif

static void write_tcon_double(Mlvds_Tcon_Config_t *mlvds_tcon)
{
    unsigned int tmp;
    int channel_num = mlvds_tcon->channel_num;
    int hv_sel = mlvds_tcon->hv_sel;
    int hstart_1 = mlvds_tcon->tcon_1st_hs_addr;
    int hend_1 = mlvds_tcon->tcon_1st_he_addr;
    int vstart_1 = mlvds_tcon->tcon_1st_vs_addr;
    int vend_1 = mlvds_tcon->tcon_1st_ve_addr;
    int hstart_2 = mlvds_tcon->tcon_2nd_hs_addr;
    int hend_2 = mlvds_tcon->tcon_2nd_he_addr;
    int vstart_2 = mlvds_tcon->tcon_2nd_vs_addr;
    int vend_2 = mlvds_tcon->tcon_2nd_ve_addr;

    tmp = READ_MPEG_REG(L_TCON_MISC_SEL_ADDR);
    switch(channel_num)
    {
        case 0 :
            WRITE_MPEG_REG(MTCON0_1ST_HS_ADDR, hstart_1);
            WRITE_MPEG_REG(MTCON0_1ST_HE_ADDR, hend_1);
            WRITE_MPEG_REG(MTCON0_1ST_VS_ADDR, vstart_1);
            WRITE_MPEG_REG(MTCON0_1ST_VE_ADDR, vend_1);
            WRITE_MPEG_REG(MTCON0_2ND_HS_ADDR, hstart_2);
            WRITE_MPEG_REG(MTCON0_2ND_HE_ADDR, hend_2);
            WRITE_MPEG_REG(MTCON0_2ND_VS_ADDR, vstart_2);
            WRITE_MPEG_REG(MTCON0_2ND_VE_ADDR, vend_2);
            tmp &= (~(1 << STH1_SEL)) | (hv_sel << STH1_SEL);
            WRITE_MPEG_REG(L_TCON_MISC_SEL_ADDR, tmp);
            break;
        case 1 :
            WRITE_MPEG_REG(MTCON1_1ST_HS_ADDR, hstart_1);
            WRITE_MPEG_REG(MTCON1_1ST_HE_ADDR, hend_1);
            WRITE_MPEG_REG(MTCON1_1ST_VS_ADDR, vstart_1);
            WRITE_MPEG_REG(MTCON1_1ST_VE_ADDR, vend_1);
            WRITE_MPEG_REG(MTCON1_2ND_HS_ADDR, hstart_2);
            WRITE_MPEG_REG(MTCON1_2ND_HE_ADDR, hend_2);
            WRITE_MPEG_REG(MTCON1_2ND_VS_ADDR, vstart_2);
            WRITE_MPEG_REG(MTCON1_2ND_VE_ADDR, vend_2);
            tmp &= (~(1 << CPV1_SEL)) | (hv_sel << CPV1_SEL);
            WRITE_MPEG_REG(L_TCON_MISC_SEL_ADDR, tmp);
            break;
        case 2 :
            WRITE_MPEG_REG(MTCON2_1ST_HS_ADDR, hstart_1);
            WRITE_MPEG_REG(MTCON2_1ST_HE_ADDR, hend_1);
            WRITE_MPEG_REG(MTCON2_1ST_VS_ADDR, vstart_1);
            WRITE_MPEG_REG(MTCON2_1ST_VE_ADDR, vend_1);
            WRITE_MPEG_REG(MTCON2_2ND_HS_ADDR, hstart_2);
            WRITE_MPEG_REG(MTCON2_2ND_HE_ADDR, hend_2);
            WRITE_MPEG_REG(MTCON2_2ND_VS_ADDR, vstart_2);
            WRITE_MPEG_REG(MTCON2_2ND_VE_ADDR, vend_2);
            tmp &= (~(1 << STV1_SEL)) | (hv_sel << STV1_SEL);
            WRITE_MPEG_REG(L_TCON_MISC_SEL_ADDR, tmp);
            break;
        case 3 :
            WRITE_MPEG_REG(MTCON3_1ST_HS_ADDR, hstart_1);
            WRITE_MPEG_REG(MTCON3_1ST_HE_ADDR, hend_1);
            WRITE_MPEG_REG(MTCON3_1ST_VS_ADDR, vstart_1);
            WRITE_MPEG_REG(MTCON3_1ST_VE_ADDR, vend_1);
            WRITE_MPEG_REG(MTCON3_2ND_HS_ADDR, hstart_2);
            WRITE_MPEG_REG(MTCON3_2ND_HE_ADDR, hend_2);
            WRITE_MPEG_REG(MTCON3_2ND_VS_ADDR, vstart_2);
            WRITE_MPEG_REG(MTCON3_2ND_VE_ADDR, vend_2);
            tmp &= (~(1 << OEV1_SEL)) | (hv_sel << OEV1_SEL);
            WRITE_MPEG_REG(L_TCON_MISC_SEL_ADDR, tmp);
            break;
        case 4 :
            WRITE_MPEG_REG(MTCON4_1ST_HS_ADDR, hstart_1);
            WRITE_MPEG_REG(MTCON4_1ST_HE_ADDR, hend_1);
            WRITE_MPEG_REG(MTCON4_1ST_VS_ADDR, vstart_1);
            WRITE_MPEG_REG(MTCON4_1ST_VE_ADDR, vend_1);
            tmp &= (~(1 << STH2_SEL)) | (hv_sel << STH2_SEL);
            WRITE_MPEG_REG(L_TCON_MISC_SEL_ADDR, tmp);
            break;
        case 5 :
            WRITE_MPEG_REG(MTCON5_1ST_HS_ADDR, hstart_1);
            WRITE_MPEG_REG(MTCON5_1ST_HE_ADDR, hend_1);
            WRITE_MPEG_REG(MTCON5_1ST_VS_ADDR, vstart_1);
            WRITE_MPEG_REG(MTCON5_1ST_VE_ADDR, vend_1);
            tmp &= (~(1 << CPV2_SEL)) | (hv_sel << CPV2_SEL);
            WRITE_MPEG_REG(L_TCON_MISC_SEL_ADDR, tmp);
            break;
        case 6 :
            WRITE_MPEG_REG(MTCON6_1ST_HS_ADDR, hstart_1);
            WRITE_MPEG_REG(MTCON6_1ST_HE_ADDR, hend_1);
            WRITE_MPEG_REG(MTCON6_1ST_VS_ADDR, vstart_1);
            WRITE_MPEG_REG(MTCON6_1ST_VE_ADDR, vend_1);
            tmp &= (~(1 << OEH_SEL)) | (hv_sel << OEH_SEL);
            WRITE_MPEG_REG(L_TCON_MISC_SEL_ADDR, tmp);
            break;
        case 7 :
            WRITE_MPEG_REG(MTCON7_1ST_HS_ADDR, hstart_1);
            WRITE_MPEG_REG(MTCON7_1ST_HE_ADDR, hend_1);
            WRITE_MPEG_REG(MTCON7_1ST_VS_ADDR, vstart_1);
            WRITE_MPEG_REG(MTCON7_1ST_VE_ADDR, vend_1);
            tmp &= (~(1 << OEV3_SEL)) | (hv_sel << OEV3_SEL);
            WRITE_MPEG_REG(L_TCON_MISC_SEL_ADDR, tmp);
            break;
        default:
            break;
    }
}

void vpp_set_matrix_ycbcr2rgb (int vd1_or_vd2_or_post, int mode)
{
   if (vd1_or_vd2_or_post == 0) //vd1
   {
      WRITE_MPEG_REG_BITS(VPP_MATRIX_CTRL, 1, 5, 1);
      WRITE_MPEG_REG_BITS(VPP_MATRIX_CTRL, 1, 8, 2);
   }
   else if (vd1_or_vd2_or_post == 1) //vd2
   {
      WRITE_MPEG_REG_BITS(VPP_MATRIX_CTRL, 1, 4, 1);
      WRITE_MPEG_REG_BITS(VPP_MATRIX_CTRL, 2, 8, 2);
   }
   else
   {
      WRITE_MPEG_REG_BITS(VPP_MATRIX_CTRL, 1, 0, 1);
      WRITE_MPEG_REG_BITS(VPP_MATRIX_CTRL, 0, 8, 2);
      if (mode == 0)
      {
          WRITE_MPEG_REG_BITS(VPP_MATRIX_CTRL, 1, 1, 2);
      }
      else if (mode == 1)
      {
          WRITE_MPEG_REG_BITS(VPP_MATRIX_CTRL, 0, 1, 2);
      }
   }

   if (mode == 0) //ycbcr not full range, 601 conversion
   {
        WRITE_MPEG_REG(VPP_MATRIX_PRE_OFFSET0_1, 0x7c00600);
        WRITE_MPEG_REG(VPP_MATRIX_PRE_OFFSET2, 0x0600);

        //1.164     0       1.596
        //1.164   -0.392    -0.813
        //1.164   2.017     0
        WRITE_MPEG_REG(VPP_MATRIX_COEF00_01, (0x4a8 << 16) |
                            0);
        WRITE_MPEG_REG(VPP_MATRIX_COEF02_10, (0x662 << 16) |
                            0x4a8);
        WRITE_MPEG_REG(VPP_MATRIX_COEF11_12, (0x1e6f << 16) |
                            0x1cbf);
        WRITE_MPEG_REG(VPP_MATRIX_COEF20_21, (0x4a8 << 16) |
                            0x811);
        WRITE_MPEG_REG(VPP_MATRIX_COEF22, 0x0);
        WRITE_MPEG_REG(VPP_MATRIX_OFFSET0_1, 0x0);
        WRITE_MPEG_REG(VPP_MATRIX_OFFSET2, 0x0);
   }
   else if (mode == 1) //ycbcr full range, 601 conversion
   {

        WRITE_MPEG_REG(VPP_MATRIX_PRE_OFFSET0_1, 0x0000600);
        WRITE_MPEG_REG(VPP_MATRIX_PRE_OFFSET2, 0x0600);

        //1     0       1.402
        //1   -0.34414  -0.71414
        //1   1.772     0
        WRITE_MPEG_REG(VPP_MATRIX_COEF00_01, (0x400 << 16) |
                            0);
        WRITE_MPEG_REG(VPP_MATRIX_COEF02_10, (0x59c << 16) |
                            0x400);
        WRITE_MPEG_REG(VPP_MATRIX_COEF11_12, (0x1ea0 << 16) |
                            0x1d25);
        WRITE_MPEG_REG(VPP_MATRIX_COEF20_21, (0x400 << 16) |
                            0x717);
        WRITE_MPEG_REG(VPP_MATRIX_COEF22, 0x0);
        WRITE_MPEG_REG(VPP_MATRIX_OFFSET0_1, 0x0);
        WRITE_MPEG_REG(VPP_MATRIX_OFFSET2, 0x0);
   }
}

static void set_tcon_ttl(Lcd_Config_t *pConf)
{
    Lcd_Timing_t *tcon_adr = &(pConf->lcd_timing);

    //set_lcd_gamma_table_ttl(pConf->lcd_effect.GammaTableR, LCD_H_SEL_R);
    //set_lcd_gamma_table_ttl(pConf->lcd_effect.GammaTableG, LCD_H_SEL_G);
    //set_lcd_gamma_table_ttl(pConf->lcd_effect.GammaTableB, LCD_H_SEL_B);

    //WRITE_MPEG_REG(GAMMA_CNTL_PORT, pConf->lcd_effect.gamma_cntl_port);
    //WRITE_MPEG_REG(GAMMA_VCOM_HSWITCH_ADDR, pConf->lcd_effect.gamma_vcom_hswitch_addr);

    //WRITE_MPEG_REG(RGB_BASE_ADDR,   pConf->lcd_effect.rgb_base_addr);
    //WRITE_MPEG_REG(RGB_COEFF_ADDR,  pConf->lcd_effect.rgb_coeff_addr);
    //WRITE_MPEG_REG(POL_CNTL_ADDR,   pConf->lcd_timing.pol_cntl_addr);
    if(pConf->lcd_basic.lcd_bits == 8)
        WRITE_MPEG_REG(DITH_CNTL_ADDR,  0x400);
    else
        WRITE_MPEG_REG(DITH_CNTL_ADDR,  0x600);

    WRITE_MPEG_REG(STH1_HS_ADDR,    tcon_adr->sth1_hs_addr);
    WRITE_MPEG_REG(STH1_HE_ADDR,    tcon_adr->sth1_he_addr);
    WRITE_MPEG_REG(STH1_VS_ADDR,    tcon_adr->sth1_vs_addr);
    WRITE_MPEG_REG(STH1_VE_ADDR,    tcon_adr->sth1_ve_addr);

    WRITE_MPEG_REG(OEH_HS_ADDR,     tcon_adr->oeh_hs_addr);
    WRITE_MPEG_REG(OEH_HE_ADDR,     tcon_adr->oeh_he_addr);
    WRITE_MPEG_REG(OEH_VS_ADDR,     tcon_adr->oeh_vs_addr);
    WRITE_MPEG_REG(OEH_VE_ADDR,     tcon_adr->oeh_ve_addr);

    WRITE_MPEG_REG(VCOM_HSWITCH_ADDR, tcon_adr->vcom_hswitch_addr);
    WRITE_MPEG_REG(VCOM_VS_ADDR,    tcon_adr->vcom_vs_addr);
    WRITE_MPEG_REG(VCOM_VE_ADDR,    tcon_adr->vcom_ve_addr);

    WRITE_MPEG_REG(CPV1_HS_ADDR,    tcon_adr->cpv1_hs_addr);
    WRITE_MPEG_REG(CPV1_HE_ADDR,    tcon_adr->cpv1_he_addr);
    WRITE_MPEG_REG(CPV1_VS_ADDR,    tcon_adr->cpv1_vs_addr);
    WRITE_MPEG_REG(CPV1_VE_ADDR,    tcon_adr->cpv1_ve_addr);

    WRITE_MPEG_REG(STV1_HS_ADDR,    tcon_adr->stv1_hs_addr);
    WRITE_MPEG_REG(STV1_HE_ADDR,    tcon_adr->stv1_he_addr);
    WRITE_MPEG_REG(STV1_VS_ADDR,    tcon_adr->stv1_vs_addr);
    WRITE_MPEG_REG(STV1_VE_ADDR,    tcon_adr->stv1_ve_addr);

    WRITE_MPEG_REG(OEV1_HS_ADDR,    tcon_adr->oev1_hs_addr);
    WRITE_MPEG_REG(OEV1_HE_ADDR,    tcon_adr->oev1_he_addr);
    WRITE_MPEG_REG(OEV1_VS_ADDR,    tcon_adr->oev1_vs_addr);
    WRITE_MPEG_REG(OEV1_VE_ADDR,    tcon_adr->oev1_ve_addr);

    WRITE_MPEG_REG(INV_CNT_ADDR,    tcon_adr->inv_cnt_addr);
    WRITE_MPEG_REG(TCON_MISC_SEL_ADDR, 	tcon_adr->tcon_misc_sel_addr);
    WRITE_MPEG_REG(DUAL_PORT_CNTL_ADDR, tcon_adr->dual_port_cntl_addr);

    WRITE_MPEG_REG(VPP_MISC, READ_MPEG_REG(VPP_MISC) & ~(VPP_OUT_SATURATE));
}

static void set_tcon_lvds(Lcd_Config_t *pConf)
{
    //Lcd_Timing_t *tcon_adr = &(pConf->lcd_timing);

    vpp_set_matrix_ycbcr2rgb(2, 0);
    WRITE_MPEG_REG(ENCL_VIDEO_RGBIN_CTRL, 3);
    WRITE_MPEG_REG(L_RGB_BASE_ADDR, 0);
    WRITE_MPEG_REG(L_RGB_COEFF_ADDR, 0x400);
    if(pConf->lcd_basic.lcd_bits == 8)
        WRITE_MPEG_REG(L_DITH_CNTL_ADDR,  0x400);
    else if(pConf->lcd_basic.lcd_bits == 6)
        WRITE_MPEG_REG(L_DITH_CNTL_ADDR,  0x600);
    else
        WRITE_MPEG_REG(L_DITH_CNTL_ADDR,  0);
    PRINT_INFO("final LVDS_FIFO_CLK = %d\n", clk_util_clk_msr(24));
    //PRINT_INFO("final cts_encl_clk = %d\n", clk_util_clk_msr(9));
    WRITE_MPEG_REG(VPP_MISC, READ_MPEG_REG(VPP_MISC) & ~(VPP_OUT_SATURATE));
}

// Set the mlvds TCON
// this function should support dual gate or singal gate TCON setting.
// singal gate TCON, Scan Function TO DO.
// scan_function   // 0 - Z1, 1 - Z2, 2- Gong
static void set_tcon_mlvds(Lcd_Config_t *pConf)
{
    Mlvds_Tcon_Config_t *mlvds_tconfig_l = pConf->lvds_mlvds_config.mlvds_tcon_config;
    int dual_gate = pConf->lvds_mlvds_config.mlvds_config->test_dual_gate;
    int bit_num = pConf->lcd_basic.lcd_bits;
    int pair_num = pConf->lvds_mlvds_config.mlvds_config->test_pair_num;

    unsigned int data32;

    int pclk_div;
    int ext_pixel = dual_gate ? pConf->lvds_mlvds_config.mlvds_config->total_line_clk : 0;
    int dual_wr_rd_start;
    int i = 0;

//    PRINT_INFO(" Notice: Setting VENC_DVI_SETTING[0x%4x] and GAMMA_CNTL_PORT[0x%4x].LCD_GAMMA_EN as 0 temporary\n", VENC_DVI_SETTING, GAMMA_CNTL_PORT);
//    PRINT_INFO(" Otherwise, the panel will display color abnormal.\n");
//    WRITE_MPEG_REG(VENC_DVI_SETTING, 0);

    //set_lcd_gamma_table_lvds(pConf->lcd_effect.GammaTableR, LCD_H_SEL_R);
    //set_lcd_gamma_table_lvds(pConf->lcd_effect.GammaTableG, LCD_H_SEL_G);
    //set_lcd_gamma_table_lvds(pConf->lcd_effect.GammaTableB, LCD_H_SEL_B);

    //WRITE_MPEG_REG(L_GAMMA_CNTL_PORT, pConf->lcd_effect.gamma_cntl_port);
    //WRITE_MPEG_REG(L_GAMMA_VCOM_HSWITCH_ADDR, pConf->lcd_effect.gamma_vcom_hswitch_addr);

    //WRITE_MPEG_REG(L_RGB_BASE_ADDR, pConf->lcd_effect.rgb_base_addr);
    //WRITE_MPEG_REG(L_RGB_COEFF_ADDR, pConf->lcd_effect.rgb_coeff_addr);
    //WRITE_MPEG_REG(L_POL_CNTL_ADDR, pConf->pol_cntl_addr);
    if(pConf->lcd_basic.lcd_bits == 8)
        WRITE_MPEG_REG(L_DITH_CNTL_ADDR,  0x400);
    else
        WRITE_MPEG_REG(L_DITH_CNTL_ADDR,  0x600);

//    WRITE_MPEG_REG(L_INV_CNT_ADDR, pConf->inv_cnt_addr);
//    WRITE_MPEG_REG(L_TCON_MISC_SEL_ADDR, pConf->tcon_misc_sel_addr);
//    WRITE_MPEG_REG(L_DUAL_PORT_CNTL_ADDR, pConf->dual_port_cntl_addr);
//
/*
    CLEAR_MPEG_REG_MASK(VPP_MISC, VPP_OUT_SATURATE);
*/
    data32 = (0x9867 << tcon_pattern_loop_data) |
             (1 << tcon_pattern_loop_start) |
             (4 << tcon_pattern_loop_end) |
             (1 << ((mlvds_tconfig_l[6].channel_num)+tcon_pattern_enable)); // POL_CHANNEL use pattern generate

    WRITE_MPEG_REG(L_TCON_PATTERN_HI,  (data32 >> 16));
    WRITE_MPEG_REG(L_TCON_PATTERN_LO, (data32 & 0xffff));

    pclk_div = (bit_num == 8) ? 3 : // phy_clk / 8
                                2 ; // phy_clk / 6
    data32 = (1 << ((mlvds_tconfig_l[7].channel_num)-2+tcon_pclk_enable)) |  // enable PCLK_CHANNEL
            (pclk_div << tcon_pclk_div) |
            (
              (pair_num == 6) ?
              (
              ((bit_num == 8) & dual_gate) ?
              (
                (0 << (tcon_delay + 0*3)) |
                (0 << (tcon_delay + 1*3)) |
                (0 << (tcon_delay + 2*3)) |
                (0 << (tcon_delay + 3*3)) |
                (0 << (tcon_delay + 4*3)) |
                (0 << (tcon_delay + 5*3)) |
                (0 << (tcon_delay + 6*3)) |
                (0 << (tcon_delay + 7*3))
              ) :
              (
                (0 << (tcon_delay + 0*3)) |
                (0 << (tcon_delay + 1*3)) |
                (0 << (tcon_delay + 2*3)) |
                (0 << (tcon_delay + 3*3)) |
                (0 << (tcon_delay + 4*3)) |
                (0 << (tcon_delay + 5*3)) |
                (0 << (tcon_delay + 6*3)) |
                (0 << (tcon_delay + 7*3))
              )
              ) :
              (
              ((bit_num == 8) & dual_gate) ?
              (
                (0 << (tcon_delay + 0*3)) |
                (0 << (tcon_delay + 1*3)) |
                (0 << (tcon_delay + 2*3)) |
                (0 << (tcon_delay + 3*3)) |
                (0 << (tcon_delay + 4*3)) |
                (0 << (tcon_delay + 5*3)) |
                (0 << (tcon_delay + 6*3)) |
                (0 << (tcon_delay + 7*3))
              ) :
              (bit_num == 8) ?
              (
                (0 << (tcon_delay + 0*3)) |
                (0 << (tcon_delay + 1*3)) |
                (0 << (tcon_delay + 2*3)) |
                (0 << (tcon_delay + 3*3)) |
                (0 << (tcon_delay + 4*3)) |
                (0 << (tcon_delay + 5*3)) |
                (0 << (tcon_delay + 6*3)) |
                (0 << (tcon_delay + 7*3))
              ) :
              (
                (0 << (tcon_delay + 0*3)) |
                (0 << (tcon_delay + 1*3)) |
                (0 << (tcon_delay + 2*3)) |
                (0 << (tcon_delay + 3*3)) |
                (0 << (tcon_delay + 4*3)) |
                (0 << (tcon_delay + 5*3)) |
                (0 << (tcon_delay + 6*3)) |
                (0 << (tcon_delay + 7*3))
              )
              )
            );

    WRITE_MPEG_REG(TCON_CONTROL_HI,  (data32 >> 16));
    WRITE_MPEG_REG(TCON_CONTROL_LO, (data32 & 0xffff));


    WRITE_MPEG_REG(L_TCON_DOUBLE_CTL,
                   (1<<(mlvds_tconfig_l[3].channel_num))   // invert CPV
                  );

    // for channel 4-7, set second setting same as first
    WRITE_MPEG_REG(L_DE_HS_ADDR, (0x3 << 14) | ext_pixel);   // 0x3 -- enable double_tcon fir channel7:6
    WRITE_MPEG_REG(L_DE_HE_ADDR, (0x3 << 14) | ext_pixel);   // 0x3 -- enable double_tcon fir channel5:4
    WRITE_MPEG_REG(L_DE_VS_ADDR, (0x3 << 14) | 0);	// 0x3 -- enable double_tcon fir channel3:2
    WRITE_MPEG_REG(L_DE_VE_ADDR, (0x3 << 14) | 0);	// 0x3 -- enable double_tcon fir channel1:0

    dual_wr_rd_start = 0x5d;
    WRITE_MPEG_REG(MLVDS_DUAL_GATE_WR_START, dual_wr_rd_start);
    WRITE_MPEG_REG(MLVDS_DUAL_GATE_WR_END, dual_wr_rd_start + 1280);
    WRITE_MPEG_REG(MLVDS_DUAL_GATE_RD_START, dual_wr_rd_start + ext_pixel - 2);
    WRITE_MPEG_REG(MLVDS_DUAL_GATE_RD_END, dual_wr_rd_start + 1280 + ext_pixel - 2);

    WRITE_MPEG_REG(MLVDS_SECOND_RESET_CTL, (pConf->lvds_mlvds_config.mlvds_config->mlvds_insert_start + ext_pixel));

    data32 = (0 << ((mlvds_tconfig_l[5].channel_num)+mlvds_tcon_field_en)) |  // enable EVEN_F on TCON channel 6
             ( (0x0 << mlvds_scan_mode_odd) | (0x0 << mlvds_scan_mode_even)
             ) | (0 << mlvds_scan_mode_start_line);

    WRITE_MPEG_REG(MLVDS_DUAL_GATE_CTL_HI,  (data32 >> 16));
    WRITE_MPEG_REG(MLVDS_DUAL_GATE_CTL_LO, (data32 & 0xffff));

    PRINT_INFO("write minilvds tcon 0~7.\n");
    for(i = 0; i < 8; i++)
    {
		write_tcon_double(&mlvds_tconfig_l[i]);
    }
}

static void set_video_spread_spectrum(int video_pll_sel, int video_ss_level)
{
    if (video_pll_sel){
        switch (video_ss_level)
        {
        case 0:  // disable ss
            WRITE_MPEG_REG(HHI_VIID_PLL_CNTL2, 0x814d3928 );
            WRITE_MPEG_REG(HHI_VIID_PLL_CNTL3, 0x6b425012 );
            WRITE_MPEG_REG(HHI_VIID_PLL_CNTL4, 0x110 );
        break;
        case 1:  //about 1%
            WRITE_MPEG_REG(HHI_VIID_PLL_CNTL2, 0x16110696);
            WRITE_MPEG_REG(HHI_VIID_PLL_CNTL3, 0x4d625012);
            WRITE_MPEG_REG(HHI_VIID_PLL_CNTL4, 0x130);
        break;
        case 2:  //about 2%
            WRITE_MPEG_REG(HHI_VIID_PLL_CNTL2, 0x16110696);
            WRITE_MPEG_REG(HHI_VIID_PLL_CNTL3, 0x2d425012);
            WRITE_MPEG_REG(HHI_VIID_PLL_CNTL4, 0x130);
        break;
        case 3:  //about 3%
            WRITE_MPEG_REG(HHI_VIID_PLL_CNTL2, 0x16110696);
            WRITE_MPEG_REG(HHI_VIID_PLL_CNTL3, 0x1d425012);
            WRITE_MPEG_REG(HHI_VIID_PLL_CNTL4, 0x130);
        break;
        case 4:  //about 4%
            WRITE_MPEG_REG(HHI_VIID_PLL_CNTL2, 0x16110696);
            WRITE_MPEG_REG(HHI_VIID_PLL_CNTL3, 0x0d125012);
            WRITE_MPEG_REG(HHI_VIID_PLL_CNTL4, 0x130);
        break;
        case 5:  //about 5%
            WRITE_MPEG_REG(HHI_VIID_PLL_CNTL2, 0x16110696);
            WRITE_MPEG_REG(HHI_VIID_PLL_CNTL3, 0x0e425012);
            WRITE_MPEG_REG(HHI_VIID_PLL_CNTL4, 0x130);
        break;
        default:  //disable ss
            WRITE_MPEG_REG(HHI_VIID_PLL_CNTL2, 0x814d3928);
            WRITE_MPEG_REG(HHI_VIID_PLL_CNTL3, 0x6b425012);
            WRITE_MPEG_REG(HHI_VIID_PLL_CNTL4, 0x110);
        }
    }
    else{
        switch (video_ss_level)
        {
        case 0:  // disable ss
            WRITE_MPEG_REG(HHI_VID_PLL_CNTL2, 0x814d3928 );
            WRITE_MPEG_REG(HHI_VID_PLL_CNTL3, 0x6b425012 );
            WRITE_MPEG_REG(HHI_VID_PLL_CNTL4, 0x110 );
        break;
        case 1:  //about 1%
            WRITE_MPEG_REG(HHI_VID_PLL_CNTL2, 0x16110696);
            WRITE_MPEG_REG(HHI_VID_PLL_CNTL3, 0x4d625012);
            WRITE_MPEG_REG(HHI_VID_PLL_CNTL4, 0x130);
        break;
        case 2:  //about 2%
            WRITE_MPEG_REG(HHI_VID_PLL_CNTL2, 0x16110696);
            WRITE_MPEG_REG(HHI_VID_PLL_CNTL3, 0x2d425012);
            WRITE_MPEG_REG(HHI_VID_PLL_CNTL4, 0x130);
        break;
        case 3:  //about 3%
            WRITE_MPEG_REG(HHI_VID_PLL_CNTL2, 0x16110696);
            WRITE_MPEG_REG(HHI_VID_PLL_CNTL3, 0x1d425012);
            WRITE_MPEG_REG(HHI_VID_PLL_CNTL4, 0x130);
        break;
        case 4:  //about 4%
            WRITE_MPEG_REG(HHI_VID_PLL_CNTL2, 0x16110696);
            WRITE_MPEG_REG(HHI_VID_PLL_CNTL3, 0x0d125012);
            WRITE_MPEG_REG(HHI_VID_PLL_CNTL4, 0x130);
        break;
        case 5:  //about 5%
            WRITE_MPEG_REG(HHI_VID_PLL_CNTL2, 0x16110696);
            WRITE_MPEG_REG(HHI_VID_PLL_CNTL3, 0x0e425012);
            WRITE_MPEG_REG(HHI_VID_PLL_CNTL4, 0x130);
        break;
        default:  //disable ss
            WRITE_MPEG_REG(HHI_VID_PLL_CNTL2, 0x814d3928);
            WRITE_MPEG_REG(HHI_VID_PLL_CNTL3, 0x6b425012);
            WRITE_MPEG_REG(HHI_VID_PLL_CNTL4, 0x110);
        }
    }
	//debug("set video spread spectrum %d%%.\n", video_ss_level);
}

static void vclk_set_lcd(int lcd_type, int pll_sel, int pll_div_sel, int vclk_sel, unsigned long pll_reg, unsigned long vid_div_reg, unsigned int xd)
{
    pll_sel = 0;
    debug("setup lcd clk.\n");
    vid_div_reg |= (1 << 16) ; // turn clock gate on
    vid_div_reg |= (pll_sel << 15); // vid_div_clk_sel

    if(vclk_sel) {
      WRITE_MPEG_REG(HHI_VIID_CLK_CNTL, READ_MPEG_REG(HHI_VIID_CLK_CNTL) & ~(1 << 19) );     //disable clk_div0
    }
    else {
      WRITE_MPEG_REG(HHI_VID_CLK_CNTL, READ_MPEG_REG(HHI_VID_CLK_CNTL) & ~(1 << 19) );     //disable clk_div0
      WRITE_MPEG_REG(HHI_VID_CLK_CNTL, READ_MPEG_REG(HHI_VID_CLK_CNTL) & ~(1 << 20) );     //disable clk_div1
    }

    // delay 2uS to allow the sync mux to switch over
    //WRITE_MPEG_REG( ISA_TIMERE, 0); while( READ_MPEG_REG(ISA_TIMERE) < 2 ) {}
	udelay(2);

    if(pll_sel){
        WRITE_MPEG_REG(HHI_VIID_PLL_CNTL, pll_reg );
        M6TV_PLL_RESET(HHI_VIID_PLL_CNTL);
        WRITE_MPEG_REG(HHI_VIID_PLL_CNTL, pll_reg|(1<<29) );
        WRITE_MPEG_REG(HHI_VIID_PLL_CNTL2, 0x814d3928 );
        WRITE_MPEG_REG(HHI_VIID_PLL_CNTL3, 0x6b425012 );
        WRITE_MPEG_REG(HHI_VIID_PLL_CNTL4, 0x110 );
        WRITE_MPEG_REG(HHI_VIID_PLL_CNTL, pll_reg );
        M6TV_PLL_WAIT_FOR_LOCK(HHI_VIID_PLL_CNTL);
    }
    else{
        WRITE_MPEG_REG(HHI_VID_PLL_CNTL, pll_reg );
        M6TV_PLL_RESET(HHI_VID_PLL_CNTL);
        WRITE_MPEG_REG(HHI_VID_PLL_CNTL, pll_reg|(1<<29) );
        WRITE_MPEG_REG(HHI_VID_PLL_CNTL2, M6_VID_PLL_CNTL_2 );
        WRITE_MPEG_REG(HHI_VID_PLL_CNTL3, M6_VID_PLL_CNTL_3 );
        WRITE_MPEG_REG(HHI_VID_PLL_CNTL4, M6_VID_PLL_CNTL_4 );
        WRITE_MPEG_REG(HHI_VID_PLL_CNTL, pll_reg );
        M6TV_PLL_WAIT_FOR_LOCK(HHI_VID_PLL_CNTL);
    }

    if(pll_div_sel ){
        WRITE_MPEG_REG(HHI_VIID_DIVIDER_CNTL,   vid_div_reg);
    }
    else{
        WRITE_MPEG_REG(HHI_VID_DIVIDER_CNTL,   vid_div_reg);
    }

    if(vclk_sel)
        WRITE_MPEG_REG(HHI_VIID_CLK_DIV, (READ_MPEG_REG(HHI_VIID_CLK_DIV) & ~(0xFF << 0)) | (xd-1) );   // setup the XD divider value
    else
        WRITE_MPEG_REG(HHI_VID_CLK_DIV, (READ_MPEG_REG(HHI_VID_CLK_DIV) & ~(0xFF << 0)) | (xd-1) );   // setup the XD divider value

    // delay 5uS
    //WRITE_MPEG_REG(ISA_TIMERE, 0); while( READ_MPEG_REG(ISA_TIMERE) < 5 ) {}
    udelay(5);

    if(vclk_sel) {
        if(pll_div_sel) WRITE_MPEG_REG_BITS(HHI_VIID_CLK_CNTL, 4, 16, 3);  // Bit[18:16] - v2_cntl_clk_in_sel
        else WRITE_MPEG_REG_BITS(HHI_VIID_CLK_CNTL, 0, 16, 3);  // Bit[18:16] - cntl_clk_in_sel
        WRITE_MPEG_REG(HHI_VIID_CLK_CNTL, READ_MPEG_REG(HHI_VIID_CLK_CNTL) |  (1 << 19) );     //enable clk_div0
        //WRITE_MPEG_REG(HHI_VIID_CLK_CNTL, (1 << 19) );     //enable clk_div0
    }
    else {
        if(pll_div_sel) WRITE_MPEG_REG_BITS(HHI_VID_CLK_CNTL, 4, 16, 3);  // Bit[18:16] - v2_cntl_clk_in_sel
        else WRITE_MPEG_REG_BITS(HHI_VID_CLK_CNTL, 0, 16, 3);  // Bit[18:16] - cntl_clk_in_sel
        WRITE_MPEG_REG(HHI_VID_CLK_CNTL, READ_MPEG_REG(HHI_VID_CLK_CNTL) |  (1 << 19) );     //enable clk_div0
        //WRITE_MPEG_REG(HHI_VID_CLK_CNTL, (1 << 19) );     //enable clk_div0
        WRITE_MPEG_REG(HHI_VID_CLK_CNTL, READ_MPEG_REG(HHI_VID_CLK_CNTL) |  (1 << 20) );     //enable clk_div1
        //WRITE_MPEG_REG(HHI_VID_CLK_CNTL, (1 << 20) );     //enable clk_div1
    }

    // delay 2uS
    //WRITE_MPEG_REG(ISA_TIMERE, 0); while( READ_MPEG_REG(ISA_TIMERE) < 2 ) {}
    udelay(2);

    // set tcon_clko setting
    WRITE_MPEG_REG_BITS(HHI_VID_CLK_CNTL,
                    (
                    (0 << 11) |     //clk_div1_sel
                    (1 << 10) |     //clk_inv
                    (0 << 9)  |     //neg_edge_sel
                    (0 << 5)  |     //tcon high_thresh
                    (0 << 1)  |     //tcon low_thresh
                    (1 << 0)        //cntl_clk_en1
                    ),
                    20, 12);

    if(lcd_type == LCD_DIGITAL_TTL){
        if(vclk_sel)
        {
            WRITE_MPEG_REG_BITS(HHI_VID_CLK_DIV, 8, 20, 4); // [23:20] enct_clk_sel, select v2_clk_div1
        }
        else
        {
            WRITE_MPEG_REG_BITS(HHI_VID_CLK_DIV, 0, 20, 4); // [23:20] enct_clk_sel, select v1_clk_div1
        }

    }
    else {
#ifdef NO_ENCT
        WRITE_MPEG_REG_BITS(HHI_VIID_CLK_DIV,
						 0, 	 // select clk_div1
						 12, 4); // [23:20] encl_clk_sel
#else
        WRITE_MPEG_REG_BITS(HHI_VID_CLK_DIV,
						 0, 	 // select clk_div1
						 20, 4); // [23:20] enct_clk_sel
#endif
    }

    if(vclk_sel) {
      WRITE_MPEG_REG_BITS(HHI_VIID_CLK_CNTL,
                   (1<<0),  // Enable cntl_div1_en
                   0, 1    // cntl_div1_en
                   );
      WRITE_MPEG_REG_BITS(HHI_VIID_CLK_CNTL, 1, 15, 1);  //soft reset
      WRITE_MPEG_REG_BITS(HHI_VIID_CLK_CNTL, 0, 15, 1);  //release soft reset
    }
    else {
      WRITE_MPEG_REG_BITS(HHI_VID_CLK_CNTL,
                   (1<<0),  // Enable cntl_div1_en
                   0, 1    // cntl_div1_en
                   );
      WRITE_MPEG_REG_BITS(HHI_VID_CLK_CNTL, 1, 15, 1);  //soft reset
      WRITE_MPEG_REG_BITS(HHI_VID_CLK_CNTL, 0, 15, 1);  //release soft reset
    }

    //PRINT_INFO("video pl1 clk = %d\n", clk_util_clk_msr(6));
    //PRINT_INFO("video2 pl1 clk = %d\n", clk_util_clk_msr(12));
    //PRINT_INFO("video pl12 clk = %d\n", clk_util_clk_msr(62));
    //PRINT_INFO("DDR_PLL_CLK = %d\n", clk_util_clk_msr(3));
    //PRINT_INFO("CLK81 = %d\n", clk_util_clk_msr(7));
    //PRINT_INFO("cts_encl_clk = %d\n", clk_util_clk_msr(9));
    //printf("LVDS_FIFO_CLK = %d\n", clk_util_clk_msr(24));
    //PRINT_INFO("video pll2 clk = %d\n", clk_util_clk_msr(VID2_PLL_CLK));
    //PRINT_INFO("cts_enct clk = %d\n", clk_util_clk_msr(CTS_ENCT_CLK));
    //PRINT_INFO("cts_encl clk = %d\n", clk_util_clk_msr(CTS_ENCL_CLK));
}

static void set_pll_ttl(Lcd_Config_t *pConf)
{
	unsigned pll_reg, div_reg, xd;
	int pll_sel, pll_div_sel, vclk_sel;
	int lcd_type, ss_level;

	pll_reg = pConf->lcd_timing.pll_ctrl;
	div_reg = pConf->lcd_timing.div_ctrl | 0x3;
	ss_level = ((pConf->lcd_timing.clk_ctrl) >>16) & 0xf;
	pll_sel = ((pConf->lcd_timing.clk_ctrl) >>12) & 0x1;
	pll_div_sel = ((pConf->lcd_timing.clk_ctrl) >>8) & 0x1;
	vclk_sel = ((pConf->lcd_timing.clk_ctrl) >>4) & 0x1;
	xd = pConf->lcd_timing.clk_ctrl & 0xf;

	lcd_type = pConf->lcd_basic.lcd_type;

	//printf("ss_level=%d, pll_sel=%d, pll_div_sel=%d, vclk_sel=%d, pll_reg=0x%x, div_reg=0x%x, xd=%d.\n", ss_level, pll_sel, pll_div_sel, vclk_sel, pll_reg, div_reg, xd);
	vclk_set_lcd(lcd_type, pll_sel, pll_div_sel, vclk_sel, pll_reg, div_reg, xd);
	set_video_spread_spectrum(pll_sel, ss_level);
}

static void clk_util_lvds_set_clk_div(  unsigned long   divn_sel,
                                    unsigned long   divn_tcnt,
                                    unsigned long   div2_en  )
{
    // assign          lvds_div_phy_clk_en     = tst_lvds_tmode ? 1'b1         : phy_clk_cntl[10];
    // assign          lvds_div_div2_sel       = tst_lvds_tmode ? atest_i[5]   : phy_clk_cntl[9];
    // assign          lvds_div_sel            = tst_lvds_tmode ? atest_i[7:6] : phy_clk_cntl[8:7];
    // assign          lvds_div_tcnt           = tst_lvds_tmode ? 3'd6         : phy_clk_cntl[6:4];
    // If dividing by 1, just select the divide by 1 path
    if( divn_tcnt == 1 ) {
        divn_sel = 0;
    }
    WRITE_MPEG_REG(LVDS_PHY_CLK_CNTL, ((READ_MPEG_REG(LVDS_PHY_CLK_CNTL) & ~((0x3 << 7) | (1 << 9) | (0x7 << 4))) | ((1 << 10) | (divn_sel << 7) | (div2_en << 9) | (((divn_tcnt-1)&0x7) << 4))) );
}

static void set_pll_lvds(Lcd_Config_t *pConf)
{
    debug("%s\n", __FUNCTION__);

    int pll_div_post;
    int phy_clk_div2;
//    unsigned long rd_data;

    unsigned pll_reg, div_reg, xd;
    int pll_sel, pll_div_sel, vclk_sel;
	int lcd_type;

    PRINT_INFO("%s\n", __FUNCTION__);
#ifdef NO_2ND_PLL
	pll_sel = 0;
#endif
    pll_reg = pConf->lcd_timing.pll_ctrl;//pll_sel ? 0x001514d0 : 0x001514d0;
    pll_div_sel = 1;
    vclk_sel = 0;//((pConf->lcd_timing.clk_ctrl) >>4) & 0x1;
    //xd = pConf->lcd_timing.clk_ctrl & 0xf;
    xd = 1;

    lcd_type = pConf->lcd_basic.lcd_type;

    pll_div_post = 7;

    phy_clk_div2 = 0;

    div_reg = pConf->lcd_timing.div_ctrl | 0x3; //0x00010803;//(div_reg | (1 << 8) | (1 << 11) | ((pll_div_post-1) << 12) | (phy_clk_div2 << 10));
    printf("pll_sel=%d, pll_div_sel=%d, vclk_sel=%d, pll_reg=0x%x, div_reg=0x%x, xd=%d.\n", pll_sel, pll_div_sel, vclk_sel, pll_reg, div_reg, xd);
    vclk_set_lcd(lcd_type, pll_sel, pll_div_sel, vclk_sel, pll_reg, div_reg, xd);
    WRITE_MPEG_REG(HHI_VIID_DIVIDER_CNTL, ((READ_MPEG_REG(HHI_VIID_DIVIDER_CNTL) & ~(0x7 << 8)) | (2 << 8) | (0<<10)) );
	//set_video_spread_spectrum(pll_sel, ss_level);

	//clk_util_lvds_set_clk_div(2, pll_div_post, phy_clk_div2);//test code //
    //    lvds_gen_cntl       <= {10'h0,      // [15:4] unused
    //                            2'h1,       // [5:4] divide by 7 in the PHY
    //                            1'b0,       // [3] fifo_en
    //                            1'b0,       // [2] wr_bist_gate
    //                            2'b00};     // [1:0] fifo_wr mode
    //rd_data = READ_MPEG_REG(LVDS_GEN_CNTL);
    //rd_data = rd_data | (1 << 3) | (3<< 0);
    WRITE_MPEG_REG(LVDS_GEN_CNTL, (READ_MPEG_REG(LVDS_GEN_CNTL)| (1 << 3) | (3<< 0)));
}

static void set_pll_mlvds(Lcd_Config_t *pConf)
{
    debug("%s\n", __FUNCTION__);

    int test_bit_num = pConf->lcd_basic.lcd_bits;
    int test_dual_gate = pConf->lvds_mlvds_config.mlvds_config->test_dual_gate;
    int test_pair_num= pConf->lvds_mlvds_config.mlvds_config->test_pair_num;
    int pll_div_post;
    int phy_clk_div2;
    int FIFO_CLK_SEL;
    int MPCLK_DELAY;
    int MCLK_half;
    int MCLK_half_delay;
    unsigned int data32;
    unsigned long mclk_pattern_dual_6_6;
    int test_high_phase = (test_bit_num != 8) | test_dual_gate;
    unsigned long rd_data;

    unsigned pll_reg, div_reg, xd;
    int pll_sel, pll_div_sel, vclk_sel;
    int lcd_type, ss_level;

    pll_reg = pConf->lcd_timing.pll_ctrl;
    div_reg = pConf->lcd_timing.div_ctrl | 0x3;
    ss_level = ((pConf->lcd_timing.clk_ctrl) >>16) & 0xf;
    pll_sel = ((pConf->lcd_timing.clk_ctrl) >>12) & 0x1;
    //pll_div_sel = ((pConf->lcd_timing.clk_ctrl) >>8) & 0x1;
    pll_div_sel = 1;
    vclk_sel = ((pConf->lcd_timing.clk_ctrl) >>4) & 0x1;
	//xd = pConf->lcd_timing.clk_ctrl & 0xf;
    xd = 1;

    lcd_type = pConf->lcd_basic.lcd_type;

    switch(pConf->lvds_mlvds_config.mlvds_config->TL080_phase)
    {
      case 0 :
        mclk_pattern_dual_6_6 = 0xc3c3c3;
        MCLK_half = 1;
        break;
      case 1 :
        mclk_pattern_dual_6_6 = 0xc3c3c3;
        MCLK_half = 0;
        break;
      case 2 :
        mclk_pattern_dual_6_6 = 0x878787;
        MCLK_half = 1;
        break;
      case 3 :
        mclk_pattern_dual_6_6 = 0x878787;
        MCLK_half = 0;
        break;
      case 4 :
        mclk_pattern_dual_6_6 = 0x3c3c3c;
        MCLK_half = 1;
        break;
       case 5 :
        mclk_pattern_dual_6_6 = 0x3c3c3c;
        MCLK_half = 0;
        break;
       case 6 :
        mclk_pattern_dual_6_6 = 0x787878;
        MCLK_half = 1;
        break;
      default : // case 7
        mclk_pattern_dual_6_6 = 0x787878;
        MCLK_half = 0;
        break;
    }

    pll_div_post = (test_bit_num == 8) ?
                      (
                        test_dual_gate ? 4 :
                                         8
                      ) :
                      (
                        test_dual_gate ? 3 :
                                         6
                      ) ;

    phy_clk_div2 = (test_pair_num != 3);

    div_reg = (div_reg | (1 << 8) | (1 << 11) | ((pll_div_post-1) << 12) | (phy_clk_div2 << 10));
    PRINT_INFO("ss_level=%d, pll_sel=%d, pll_div_sel=%d, vclk_sel=%d, pll_reg=0x%x, div_reg=0x%x, xd=%d.\n", ss_level, pll_sel, pll_div_sel, vclk_sel, pll_reg, div_reg, xd);
    vclk_set_lcd(lcd_type, pll_sel, pll_div_sel, vclk_sel, pll_reg, div_reg, xd);
    set_video_spread_spectrum(pll_sel, ss_level);

    clk_util_lvds_set_clk_div(1, pll_div_post, phy_clk_div2);

	//enable v2_clk div
    // WRITE_MPEG_REG( HHI_VIID_CLK_CNTL, READ_MPEG_REG(HHI_VIID_CLK_CNTL) | (0xF << 0) );
    // WRITE_MPEG_REG( HHI_VID_CLK_CNTL, READ_MPEG_REG(HHI_VID_CLK_CNTL) | (0xF << 0) );

    WRITE_MPEG_REG(LVDS_PHY_CNTL0, 0xffff );

    //    lvds_gen_cntl       <= {10'h0,      // [15:4] unused
    //                            2'h1,       // [5:4] divide by 7 in the PHY
    //                            1'b0,       // [3] fifo_en
    //                            1'b0,       // [2] wr_bist_gate
    //                            2'b00};     // [1:0] fifo_wr mode

    FIFO_CLK_SEL = (test_bit_num == 8) ? 2 : // div8
                                    0 ; // div6
    rd_data = READ_MPEG_REG(LVDS_GEN_CNTL);
    rd_data = (rd_data & 0xffcf) | (FIFO_CLK_SEL<< 4);
    WRITE_MPEG_REG(LVDS_GEN_CNTL, rd_data);

    MPCLK_DELAY = (test_pair_num == 6) ?
                  ((test_bit_num == 8) ? (test_dual_gate ? 5 : 3) : 2) :
                  ((test_bit_num == 8) ? 3 : 3) ;

    MCLK_half_delay = pConf->lvds_mlvds_config.mlvds_config->phase_select ? MCLK_half :
                      (
                      test_dual_gate &
                      (test_bit_num == 8) &
                      (test_pair_num != 6)
                      );

    if(test_high_phase)
    {
        if(test_dual_gate)
        data32 = (MPCLK_DELAY << mpclk_dly) |
                 (((test_bit_num == 8) ? 3 : 2) << mpclk_div) |
                 (1 << use_mpclk) |
                 (MCLK_half_delay << mlvds_clk_half_delay) |
                 (((test_bit_num == 8) ? (
                                           (test_pair_num == 6) ? 0x999999 : // DIV4
                                                                  0x555555   // DIV2
                                         ) :
                                         (
                                           (test_pair_num == 6) ? mclk_pattern_dual_6_6 : // DIV8
                                                                  0x999999   // DIV4
                                         )
                                         ) << mlvds_clk_pattern);      // DIV 8
        else if(test_bit_num == 8)
            data32 = (MPCLK_DELAY << mpclk_dly) |
                     (((test_bit_num == 8) ? 3 : 2) << mpclk_div) |
                     (1 << use_mpclk) |
                     (0 << mlvds_clk_half_delay) |
                     (0xc3c3c3 << mlvds_clk_pattern);      // DIV 8
        else
            data32 = (MPCLK_DELAY << mpclk_dly) |
                     (((test_bit_num == 8) ? 3 : 2) << mpclk_div) |
                     (1 << use_mpclk) |
                     (0 << mlvds_clk_half_delay) |
                     (
                       (
                         (test_pair_num == 6) ? 0xc3c3c3 : // DIV8
                                                0x999999   // DIV4
                       ) << mlvds_clk_pattern
                     );
    }
    else
    {
        if(test_pair_num == 6)
        {
            data32 = (MPCLK_DELAY << mpclk_dly) |
                     (((test_bit_num == 8) ? 3 : 2) << mpclk_div) |
                     (1 << use_mpclk) |
                     (0 << mlvds_clk_half_delay) |
                     (
                       (
                         (test_pair_num == 6) ? 0x999999 : // DIV4
                                                0x555555   // DIV2
                       ) << mlvds_clk_pattern
                     );
        }
        else
        {
            data32 = (1 << mlvds_clk_half_delay) |
                   (0x555555 << mlvds_clk_pattern);      // DIV 2
        }
    }

    //WRITE_MPEG_REG(MLVDS_CLK_CTL_HI,  (data32 >> 16));
    //WRITE_MPEG_REG(MLVDS_CLK_CTL_LO, (data32 & 0xffff));

	//pll_div_sel
    if(1){
		// Set Soft Reset vid_pll_div_pre
		WRITE_MPEG_REG(HHI_VIID_DIVIDER_CNTL, READ_MPEG_REG(HHI_VIID_DIVIDER_CNTL) | 0x00008);
		// Set Hard Reset vid_pll_div_post
		WRITE_MPEG_REG(HHI_VIID_DIVIDER_CNTL, READ_MPEG_REG(HHI_VIID_DIVIDER_CNTL) & 0x1fffd);
		// Set Hard Reset lvds_phy_ser_top
		WRITE_MPEG_REG(LVDS_PHY_CLK_CNTL, READ_MPEG_REG(LVDS_PHY_CLK_CNTL) & 0x7fff);
		// Release Hard Reset lvds_phy_ser_top
		WRITE_MPEG_REG(LVDS_PHY_CLK_CNTL, READ_MPEG_REG(LVDS_PHY_CLK_CNTL) | 0x8000);
		// Release Hard Reset vid_pll_div_post
		WRITE_MPEG_REG(HHI_VIID_DIVIDER_CNTL, READ_MPEG_REG(HHI_VIID_DIVIDER_CNTL) | 0x00002);
		// Release Soft Reset vid_pll_div_pre
		WRITE_MPEG_REG(HHI_VIID_DIVIDER_CNTL, READ_MPEG_REG(HHI_VIID_DIVIDER_CNTL) & 0x1fff7);
	}
	else{
		// Set Soft Reset vid_pll_div_pre
		WRITE_MPEG_REG(HHI_VID_DIVIDER_CNTL, READ_MPEG_REG(HHI_VID_DIVIDER_CNTL) | 0x00008);
		// Set Hard Reset vid_pll_div_post
		WRITE_MPEG_REG(HHI_VID_DIVIDER_CNTL, READ_MPEG_REG(HHI_VID_DIVIDER_CNTL) & 0x1fffd);
		// Set Hard Reset lvds_phy_ser_top
		WRITE_MPEG_REG(LVDS_PHY_CLK_CNTL, READ_MPEG_REG(LVDS_PHY_CLK_CNTL) & 0x7fff);
		// Release Hard Reset lvds_phy_ser_top
		WRITE_MPEG_REG(LVDS_PHY_CLK_CNTL, READ_MPEG_REG(LVDS_PHY_CLK_CNTL) | 0x8000);
		// Release Hard Reset vid_pll_div_post
		WRITE_MPEG_REG(HHI_VID_DIVIDER_CNTL, READ_MPEG_REG(HHI_VID_DIVIDER_CNTL) | 0x00002);
		// Release Soft Reset vid_pll_div_pre
		WRITE_MPEG_REG(HHI_VID_DIVIDER_CNTL, READ_MPEG_REG(HHI_VID_DIVIDER_CNTL) & 0x1fff7);
    }
}

static void venc_set_ttl(Lcd_Config_t *pConf)
{
    PRINT_INFO("%s\n", __FUNCTION__);
    WRITE_MPEG_REG(ENCT_VIDEO_EN,           0);
    WRITE_MPEG_REG(VPU_VIU_VENC_MUX_CTRL,
       (3<<0) |    // viu1 select enct
       (3<<2)      // viu2 select enct
    );
    WRITE_MPEG_REG(ENCT_VIDEO_MODE,        0);
    WRITE_MPEG_REG(ENCT_VIDEO_MODE_ADV,    0x0418);

	// bypass filter
    WRITE_MPEG_REG(ENCT_VIDEO_FILT_CTRL,    0x1000);
    WRITE_MPEG_REG(VENC_DVI_SETTING,        0x11);
    WRITE_MPEG_REG(VENC_VIDEO_PROG_MODE,    0x100);

    WRITE_MPEG_REG(ENCT_VIDEO_MAX_PXCNT,    pConf->lcd_basic.h_period - 1);
    WRITE_MPEG_REG(ENCT_VIDEO_MAX_LNCNT,    pConf->lcd_basic.v_period - 1);

    WRITE_MPEG_REG(ENCT_VIDEO_HAVON_BEGIN,  pConf->lcd_timing.video_on_pixel);
    WRITE_MPEG_REG(ENCT_VIDEO_HAVON_END,    pConf->lcd_basic.h_active - 1 + pConf->lcd_timing.video_on_pixel);
    WRITE_MPEG_REG(ENCT_VIDEO_VAVON_BLINE,  pConf->lcd_timing.video_on_line);
    WRITE_MPEG_REG(ENCT_VIDEO_VAVON_ELINE,  pConf->lcd_basic.v_active + 3  + pConf->lcd_timing.video_on_line);

    WRITE_MPEG_REG(ENCT_VIDEO_HSO_BEGIN,    15);
    WRITE_MPEG_REG(ENCT_VIDEO_HSO_END,      31);
    WRITE_MPEG_REG(ENCT_VIDEO_VSO_BEGIN,    15);
    WRITE_MPEG_REG(ENCT_VIDEO_VSO_END,      31);
    WRITE_MPEG_REG(ENCT_VIDEO_VSO_BLINE,    0);
    WRITE_MPEG_REG(ENCT_VIDEO_VSO_ELINE,    2);

    // enable enct
    WRITE_MPEG_REG(ENCT_VIDEO_EN,           1);
}

static void venc_set_lvds(Lcd_Config_t *pConf)
{
    debug("%s.\n",__FUNCTION__);
    WRITE_MPEG_REG(VPU_VIU_VENC_MUX_CTRL,
    (0<<0) |    // viu1 select encl
    (0<<2)      // viu2 select encl
    );
    WRITE_MPEG_REG(ENCL_VIDEO_EN,           0);
	//int havon_begin = 80;
    WRITE_MPEG_REG(VPU_VIU_VENC_MUX_CTRL,
       (0<<0) |    // viu1 select encl
       (0<<2)      // viu2 select encl
       );
	WRITE_MPEG_REG(ENCL_VIDEO_MODE,         0); // Enable Hsync and equalization pulse switch in center; bit[14] cfg_de_v = 1
	WRITE_MPEG_REG(ENCL_VIDEO_MODE_ADV,     0x0418); // Sampling rate: 1

	// bypass filter
 	WRITE_MPEG_REG(ENCL_VIDEO_FILT_CTRL	,0x1000);

	WRITE_MPEG_REG(ENCL_VIDEO_MAX_PXCNT,	pConf->lcd_basic.h_period - 1);
	WRITE_MPEG_REG(ENCL_VIDEO_MAX_LNCNT,	pConf->lcd_basic.v_period - 1);

	WRITE_MPEG_REG(ENCL_VIDEO_HAVON_BEGIN,	pConf->lcd_timing.video_on_pixel);
	WRITE_MPEG_REG(ENCL_VIDEO_HAVON_END,		pConf->lcd_basic.h_active - 1 + pConf->lcd_timing.video_on_pixel);
	WRITE_MPEG_REG(ENCL_VIDEO_VAVON_BLINE,	pConf->lcd_timing.video_on_line);
	WRITE_MPEG_REG(ENCL_VIDEO_VAVON_ELINE,	pConf->lcd_basic.v_active - 1  + pConf->lcd_timing.video_on_line);

	WRITE_MPEG_REG(ENCL_VIDEO_HSO_BEGIN,	pConf->lcd_timing.sth1_hs_addr);//10);
	WRITE_MPEG_REG(ENCL_VIDEO_HSO_END,	pConf->lcd_timing.sth1_he_addr);//20);
	WRITE_MPEG_REG(ENCL_VIDEO_VSO_BEGIN,	pConf->lcd_timing.stv1_hs_addr);//10);
	WRITE_MPEG_REG(ENCL_VIDEO_VSO_END,	pConf->lcd_timing.stv1_he_addr);//20);
	WRITE_MPEG_REG(ENCL_VIDEO_VSO_BLINE,	pConf->lcd_timing.stv1_vs_addr);//2);
	WRITE_MPEG_REG(ENCL_VIDEO_VSO_ELINE,	pConf->lcd_timing.stv1_ve_addr);//4);

	WRITE_MPEG_REG(ENCL_VIDEO_RGBIN_CTRL, 	0);

	// enable encl
    WRITE_MPEG_REG(ENCL_VIDEO_EN,           1);
}

static void venc_set_mlvds(Lcd_Config_t *pConf)
{
	int ext_pixel,active_h_start,active_v_start,width,height,max_height;
    PRINT_INFO("%s\n", __FUNCTION__);

    WRITE_MPEG_REG(ENCL_VIDEO_EN,           0);

    WRITE_MPEG_REG(VPU_VIU_VENC_MUX_CTRL,
       (0<<0) |    // viu1 select encl
       (0<<2)      // viu2 select encl
       );
	ext_pixel = pConf->lvds_mlvds_config.mlvds_config->test_dual_gate ? pConf->lvds_mlvds_config.mlvds_config->total_line_clk : 0;
	active_h_start = pConf->lcd_timing.video_on_pixel;
	active_v_start = pConf->lcd_timing.video_on_line;
	width = pConf->lcd_basic.h_active;
	height = pConf->lcd_basic.v_active;
	max_height = pConf->lcd_basic.v_period;

	WRITE_MPEG_REG(ENCL_VIDEO_MODE,             0x0040 | (1<<14)); // Enable Hsync and equalization pulse switch in center; bit[14] cfg_de_v = 1
	WRITE_MPEG_REG(ENCL_VIDEO_MODE_ADV,         0x0008); // Sampling rate: 1

	// bypass filter
 	WRITE_MPEG_REG(ENCL_VIDEO_FILT_CTRL,	0x1000);

	WRITE_MPEG_REG(ENCL_VIDEO_YFP1_HTIME,       active_h_start);
	WRITE_MPEG_REG(ENCL_VIDEO_YFP2_HTIME,       active_h_start + width);

	WRITE_MPEG_REG(ENCL_VIDEO_MAX_PXCNT,        pConf->lvds_mlvds_config.mlvds_config->total_line_clk - 1 + ext_pixel);
	WRITE_MPEG_REG(ENCL_VIDEO_MAX_LNCNT,        max_height - 1);

	WRITE_MPEG_REG(ENCL_VIDEO_HAVON_BEGIN,      active_h_start);
	WRITE_MPEG_REG(ENCL_VIDEO_HAVON_END,        active_h_start + width - 1);  // for dual_gate mode still read 1408 pixel at first half of line
	WRITE_MPEG_REG(ENCL_VIDEO_VAVON_BLINE,      active_v_start);
	WRITE_MPEG_REG(ENCL_VIDEO_VAVON_ELINE,      active_v_start + height -1);  //15+768-1);

	WRITE_MPEG_REG(ENCL_VIDEO_HSO_BEGIN,        24);
	WRITE_MPEG_REG(ENCL_VIDEO_HSO_END,          1420 + ext_pixel);
	WRITE_MPEG_REG(ENCL_VIDEO_VSO_BEGIN,        1400 + ext_pixel);
	WRITE_MPEG_REG(ENCL_VIDEO_VSO_END,          1410 + ext_pixel);
	WRITE_MPEG_REG(ENCL_VIDEO_VSO_BLINE,        1);
	WRITE_MPEG_REG(ENCL_VIDEO_VSO_ELINE,        3);

	WRITE_MPEG_REG(ENCL_VIDEO_RGBIN_CTRL, 	0);

	// enable encl
    WRITE_MPEG_REG(ENCL_VIDEO_EN,           1);
}

static void set_control_lvds(Lcd_Config_t *pConf)
{

	//int lvds_repack, port_reverse, pn_swap, bit_num, dual_port;
    PRINT_INFO("%s\n", __FUNCTION__);
#if 0//MESON_CPU_TYPE >= MESON_CPU_TYPE_MESON6TV
    data32 = (0x00 << LVDS_blank_data_r) |
             (0x00 << LVDS_blank_data_g) |
             (0x00 << LVDS_blank_data_b) ;
    WRITE_MPEG_REG(LVDS_BLANK_DATA_HI,  (data32 >> 16));
    WRITE_MPEG_REG(LVDS_BLANK_DATA_LO, (data32 & 0xffff));

	WRITE_MPEG_REG(LVDS_PHY_CNTL0, 0xffff );
	WRITE_MPEG_REG(LVDS_PHY_CNTL1, 0xff00 );
#endif

	//WRITE_MPEG_REG(ENCL_VIDEO_EN,           1);
	if(lvds_repack_flag)
	lvds_repack = (pConf->lvds_mlvds_config.lvds_config->lvds_repack) & 0x1;
	pn_swap = (pConf->lvds_mlvds_config.lvds_config->pn_swap) & 0x1;
	dual_port = (pConf->lvds_mlvds_config.lvds_config->dual_port) & 0x1;
	if(port_reverse_flag)
	port_reverse = (pConf->lvds_mlvds_config.lvds_config->port_reverse) & 0x1;
    if(bit_num_flag)
    	{
		switch(pConf->lcd_basic.lcd_bits)
			{
			case 10:
				bit_num=0;
				break;
			case 8:
				bit_num=1;
				break;
			case 6:
				bit_num=2;
				break;
			case 4:
				bit_num=3;
				break;
			default:
				bit_num=1;
				break;
			}
    	}
	WRITE_MPEG_REG(MLVDS_CONTROL,  (READ_MPEG_REG(MLVDS_CONTROL) & ~(1 << 0)));  //disable mlvds

	WRITE_MPEG_REG(LVDS_PACK_CNTL_ADDR,
					( lvds_repack<<0 ) | // repack
					( port_reverse?(0<<2):(1<<2)) | // odd_even
					( 0<<3 ) | // reserve
					( 0<<4 ) | // lsb first
					( pn_swap<<5 ) | // pn swap
					( dual_port<<6 ) | // dual port
					( 0<<7 ) | // use tcon control
					( bit_num<<8 ) | // 0:10bits, 1:8bits, 2:6bits, 3:4bits.
					( 0<<10 ) | //r_select  //0:R, 1:G, 2:B, 3:0
					( 1<<12 ) | //g_select  //0:R, 1:G, 2:B, 3:0
					( 2<<14 ));  //b_select  //0:R, 1:G, 2:B, 3:0;
    //WRITE_MPEG_REG(LVDS_GEN_CNTL, (READ_MPEG_REG(LVDS_GEN_CNTL) | (1 << 3))); // enable fifo

	//PRINT_INFO("lvds fifo clk = %d.\n", clk_util_clk_msr(LVDS_FIFO_CLK));
}

static void set_control_mlvds(Lcd_Config_t *pConf)
{

	int test_bit_num = pConf->lcd_basic.lcd_bits;
    int test_pair_num = pConf->lvds_mlvds_config.mlvds_config->test_pair_num;
    int test_dual_gate = pConf->lvds_mlvds_config.mlvds_config->test_dual_gate;
    int scan_function = pConf->lvds_mlvds_config.mlvds_config->scan_function;     //0:U->D,L->R  //1:D->U,R->L
    int mlvds_insert_start;
    unsigned int reset_offset;
    unsigned int reset_length;

    unsigned long data32;

    PRINT_INFO("%s\n", __FUNCTION__);
    mlvds_insert_start = test_dual_gate ?
                           ((test_bit_num == 8) ? ((test_pair_num == 6) ? 0x9f : 0xa9) :
                                                  ((test_pair_num == 6) ? pConf->lvds_mlvds_config.mlvds_config->mlvds_insert_start : 0xa7)
                           ) :
                           (
                             (test_pair_num == 6) ? ((test_bit_num == 8) ? 0xa9 : 0xa7) :
                                                    ((test_bit_num == 8) ? 0xae : 0xad)
                           );

    // Enable the LVDS PHY (power down bits)
    WRITE_MPEG_REG(LVDS_PHY_CNTL1,READ_MPEG_REG(LVDS_PHY_CNTL1) | (0x7F << 8) );

    data32 = (0x00 << LVDS_blank_data_r) |
             (0x00 << LVDS_blank_data_g) |
             (0x00 << LVDS_blank_data_b) ;
    WRITE_MPEG_REG(LVDS_BLANK_DATA_HI,  (data32 >> 16));
    WRITE_MPEG_REG(LVDS_BLANK_DATA_LO, (data32 & 0xffff));

    data32 = 0x7fffffff; //  '0'x1 + '1'x32 + '0'x2
    WRITE_MPEG_REG(MLVDS_RESET_PATTERN_HI,  (data32 >> 16));
    WRITE_MPEG_REG(MLVDS_RESET_PATTERN_LO, (data32 & 0xffff));
    data32 = 0x8000; // '0'x1 + '1'x32 + '0'x2
    WRITE_MPEG_REG(MLVDS_RESET_PATTERN_EXT,  (data32 & 0xffff));

    reset_length = 1+32+2;
    reset_offset = test_bit_num - (reset_length%test_bit_num);

    data32 = (reset_offset << mLVDS_reset_offset) |
             (reset_length << mLVDS_reset_length) |
             ((test_pair_num == 6) << mLVDS_data_write_toggle) |
             ((test_pair_num != 6) << mLVDS_data_write_ini) |
             ((test_pair_num == 6) << mLVDS_data_latch_1_toggle) |
             (0 << mLVDS_data_latch_1_ini) |
             ((test_pair_num == 6) << mLVDS_data_latch_0_toggle) |
             (1 << mLVDS_data_latch_0_ini) |
             ((test_pair_num == 6) << mLVDS_reset_1_select) |
             (mlvds_insert_start << mLVDS_reset_start);
    WRITE_MPEG_REG(MLVDS_CONFIG_HI,  (data32 >> 16));
    WRITE_MPEG_REG(MLVDS_CONFIG_LO, (data32 & 0xffff));

    data32 = (1 << mLVDS_double_pattern) |  //POL double pattern
			 (0x3f << mLVDS_ins_reset) |
             (test_dual_gate << mLVDS_dual_gate) |
             ((test_bit_num == 8) << mLVDS_bit_num) |
             ((test_pair_num == 6) << mLVDS_pair_num) |
             (0 << mLVDS_msb_first) |
             (0 << mLVDS_PORT_SWAP) |
             ((scan_function==1 ? 1:0) << mLVDS_MLSB_SWAP) |
             (0 << mLVDS_PN_SWAP) |
             (1 << mLVDS_en);
    WRITE_MPEG_REG(MLVDS_CONTROL,  (data32 & 0xffff));

    WRITE_MPEG_REG(LVDS_PACK_CNTL_ADDR,
                   ( 0 ) | // repack
                   ( 0<<2 ) | // odd_even
                   ( 0<<3 ) | // reserve
                   ( 0<<4 ) | // lsb first
                   ( 0<<5 ) | // pn swap
                   ( 0<<6 ) | // dual port
                   ( 0<<7 ) | // use tcon control
                   ( 1<<8 ) | // 0:10bits, 1:8bits, 2:6bits, 3:4bits.
                   ( (scan_function==1 ? 2:0)<<10 ) |  //r_select // 0:R, 1:G, 2:B, 3:0
                   ( 1<<12 ) |                        //g_select
                   ( (scan_function==1 ? 0:2)<<14 ));  //b_select

    WRITE_MPEG_REG(L_POL_CNTL_ADDR,  (1 << LCD_DCLK_SEL) |
       //(0x1 << LCD_HS_POL) |
       (0x1 << LCD_VS_POL)
    );

    //WRITE_MPEG_REG(LVDS_GEN_CNTL, (READ_MPEG_REG(LVDS_GEN_CNTL) | (1 << 3))); // enable fifo
}

static void init_lvds_phy(Lcd_Config_t *pConf)
{

    PRINT_INFO("%s\n", __FUNCTION__);
    WRITE_MPEG_REG(LVDS_SER_EN, 0xfff );
    WRITE_MPEG_REG(LVDS_PHY_CNTL0, 0x0002 );//0xffff
    WRITE_MPEG_REG(LVDS_PHY_CNTL1, 0xff00 );
    WRITE_MPEG_REG(LVDS_PHY_CNTL3, 0x0ee1 );
    WRITE_MPEG_REG(LVDS_PHY_CNTL4, 0x3fff );
    WRITE_MPEG_REG(LVDS_PHY_CNTL5, 0xac24 );//ac24
    //WRITE_MPEG_REG(LVDS_PHY_CNTL4, READ_MPEG_REG(LVDS_PHY_CNTL4) | (0x7f<<0));  //enable LVDS phy port..
}

static inline void _init_display_driver(Lcd_Config_t *pConf)
{
	int lcd_type;
	const char* lcd_type_table[]={
		"NULL",
		"TTL",
		"LVDS",
		"miniLVDS",
		"invalid",
	};

	lcd_type = pDev->conf.lcd_basic.lcd_type;
	PRINT_INFO("\nInit LCD type: %s.\n", lcd_type_table[lcd_type]);
	PRINT_INFO("lcd frame rate=%d/%d.\n", pDev->conf.lcd_timing.sync_duration_num, pDev->conf.lcd_timing.sync_duration_den);

	switch(lcd_type)
	{
	case LCD_DIGITAL_TTL:
			set_pll_ttl(pConf);
			venc_set_ttl(pConf);
			set_tcon_ttl(pConf);
			break;
	case LCD_DIGITAL_LVDS:
			set_pll_lvds(pConf);
			venc_set_lvds(pConf);
			set_control_lvds(pConf);
			init_lvds_phy(pConf);
			set_tcon_lvds(pConf);
			break;
        case LCD_DIGITAL_MINILVDS:
			set_pll_mlvds(pConf);
			venc_set_mlvds(pConf);
			set_control_mlvds(pConf);
			init_lvds_phy(pConf);
			set_tcon_mlvds(pConf);
			break;
	default:
            PRINT_INFO("Invalid LCD type.\n");
			break;
	}
}

static inline void _disable_display_driver(Lcd_Config_t *pConf)
{
    int pll_sel, vclk_sel;

    pll_sel = 0;//((pConf->lcd_timing.clk_ctrl) >>12) & 0x1;
    vclk_sel = 0;//((pConf->lcd_timing.clk_ctrl) >>4) & 0x1;

    WRITE_MPEG_REG_BITS(HHI_VIID_DIVIDER_CNTL, 0, 11, 1);	//close lvds phy clk gate: 0x104c[11]

    WRITE_MPEG_REG(ENCT_VIDEO_EN, 0);	//disable enct
    WRITE_MPEG_REG(ENCL_VIDEO_EN, 0);	//disable encl

    if (vclk_sel)
        WRITE_MPEG_REG_BITS(HHI_VIID_CLK_CNTL, 0, 0, 5);		//close vclk2 gate: 0x104b[4:0]
    else
        WRITE_MPEG_REG_BITS(HHI_VID_CLK_CNTL, 0, 0, 5);		//close vclk1 gate: 0x105f[4:0]

    if (pll_sel){
        WRITE_MPEG_REG_BITS(HHI_VIID_DIVIDER_CNTL, 0, 16, 1);	//close vid2_pll gate: 0x104c[16]
        WRITE_MPEG_REG_BITS(HHI_VIID_PLL_CNTL, 1, 30, 1);		//power down vid2_pll: 0x1047[30]
    }
    else{
        WRITE_MPEG_REG_BITS(HHI_VID_DIVIDER_CNTL, 0, 16, 1);	//close vid1_pll gate: 0x1066[16]
        WRITE_MPEG_REG_BITS(HHI_VID_PLL_CNTL, 0, 30, 1);		//power down vid1_pll: 0x105c[30]
    }
	printf("disable lcd display driver.\n");
}

static inline void _enable_vsync_interrupt(void)
{
    if ((READ_MPEG_REG(ENCT_VIDEO_EN) & 1) || (READ_MPEG_REG(ENCL_VIDEO_EN) & 1)) {
        WRITE_MPEG_REG(VENC_INTCTRL, 0x200);
#if 0
        while ((READ_MPEG_REG(VENC_INTFLAG) & 0x200) == 0) {
            u32 line1, line2;

            line1 = line2 = READ_MPEG_REG(VENC_ENCP_LINE);

            while (line1 >= line2) {
                line2 = line1;
                line1 = READ_MPEG_REG(VENC_ENCP_LINE);
            }

            READ_MPEG_REG(VENC_INTFLAG);
            READ_MPEG_REG(VENC_INTFLAG);
            READ_MPEG_REG(VENC_INTFLAG);
            READ_MPEG_REG(VENC_INTFLAG);
            if (READ_MPEG_REG(VENC_INTFLAG) & 0x200) {
                break;
            }

            WRITE_MPEG_REG(ENCP_VIDEO_EN, 0);
            READ_MPEG_REG(VENC_INTFLAG);
            READ_MPEG_REG(VENC_INTFLAG);
            READ_MPEG_REG(VENC_INTFLAG);
            READ_MPEG_REG(VENC_INTFLAG);
            READ_MPEG_REG(VENC_INTFLAG);

            WRITE_MPEG_REG(ENCP_VIDEO_EN, 1);
            READ_MPEG_REG(VENC_INTFLAG);
            READ_MPEG_REG(VENC_INTFLAG);
            READ_MPEG_REG(VENC_INTFLAG);
            READ_MPEG_REG(VENC_INTFLAG);
            READ_MPEG_REG(VENC_INTFLAG);
        }
#endif
    }
    else{
        WRITE_MPEG_REG(VENC_INTCTRL, 0x2);
    }
}

#if 0
static void _enable_backlight(u32 brightness_level)
{
    //pDev->conf.backlight_on?pDev->conf.backlight_on():0;
    panel_oper.bl_on();
}
#endif

/*static void _disable_backlight(void)
{
    //pDev->conf.backlight_off?pDev->conf.backlight_off():0;
    panel_oper.bl_off();
}*/
extern void mdelay(unsigned long msec);
static void _lcd_module_enable(void)
{
#if 0
    BUG_ON(pDev==NULL);
   // _init_display_driver(&pDev->conf);
   //md by jack
   panel_oper.power_on();
   udelay(200);
	_init_display_driver(&pDev->conf);//TX_clock
    //_enable_backlight(BL_MAX_LEVEL);	//disable backlight at pannel init
    _enable_vsync_interrupt();
#endif
	printf("_lcd_module_enable---.\n");
	    BUG_ON(pDev==NULL);   
	panel_oper.power_on();//panel power 12v
	udelay(50);
	_init_display_driver(&pDev->conf);//TX_clock
	udelay(50);
	////pull up pwm
   WRITE_CBUS_REG_BITS(PREG_PAD_GPIO1_O,0,30,1);
   WRITE_CBUS_REG_BITS(PREG_PAD_GPIO1_EN_N,1,30,1);
	////pull up pwm
	mdelay(160);
    //_enable_backlight(BL_MAX_LEVEL);	//disable backlight at pannel init
    _enable_vsync_interrupt();
}

#if 0
static const vinfo_t *lcd_get_current_info(void)
{
    return &pDev->lcd_info;
}
#endif

static int lcd_set_current_vmode(vmode_t mode)	//ÉèÖÃÆÁ¿í
{
    if (mode != VMODE_LCD)
        return -1;
    WRITE_MPEG_REG(VPP_POSTBLEND_H_SIZE, pDev->lcd_info.width);
    _lcd_module_enable();
    if (VMODE_INIT_NULL == pDev->lcd_info.mode)
        pDev->lcd_info.mode = VMODE_LCD;
    //_enable_backlight(BL_MAX_LEVEL);
    return 0;
}

static void _init_vout(lcd_dev_t *pDev)
{
    pDev->lcd_info.name = PANEL_NAME;
    pDev->lcd_info.mode = VMODE_LCD;
    pDev->lcd_info.width = pDev->conf.lcd_basic.h_active;
    pDev->lcd_info.height = pDev->conf.lcd_basic.v_active;
    pDev->lcd_info.field_height = pDev->conf.lcd_basic.v_active;
    pDev->lcd_info.aspect_ratio_num = pDev->conf.lcd_basic.screen_ratio_width;
    pDev->lcd_info.aspect_ratio_den = pDev->conf.lcd_basic.screen_ratio_height;
    pDev->lcd_info.screen_real_width= pDev->conf.lcd_basic.screen_actual_width;
    pDev->lcd_info.screen_real_height= pDev->conf.lcd_basic.screen_actual_height;
    pDev->lcd_info.sync_duration_num = pDev->conf.lcd_timing.sync_duration_num;
    pDev->lcd_info.sync_duration_den = pDev->conf.lcd_timing.sync_duration_den;
}

static void _lcd_init(Lcd_Config_t *pConf)
{
	_init_vout(pDev);
    	//_lcd_module_enable();		//remove repeatedly lcd_module_enable
	lcd_set_current_vmode(VMODE_LCD);
}

int lcd_probe(void)
{
    pDev = (lcd_dev_t *)malloc(sizeof(lcd_dev_t));
    if (!pDev) {
        printf("[tcon]: Not enough memory.\n");
        return -1;
    }

    pDev->conf = lcd_config;

    _lcd_init(&pDev->conf);
    return 0;
}

int lcd_remove(void)
{
    _disable_display_driver(&pDev->conf);
    free(pDev);
    return 0;
}
