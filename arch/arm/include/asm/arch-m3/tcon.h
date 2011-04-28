/*
 * AMLOGIC TCON controller driver.
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
 * Author:  Tim Yao <timyao@amlogic.com>
 *
 */

#ifndef TCON_H
#define TCON_H

/* for GAMMA_CNTL_PORT */
   /// GAMMA VCOM POL
   #define LCD_GAMMA_VCOM_POL       7
   /// GAMMA DATA REVERSE OUTPUT FOLLOWING VCOM
   #define LCD_GAMMA_RVS_OUT        6
   /// GAMMA ADDR PORT IS RDY
   #define LCD_ADR_RDY              5
   /// GAMMA DATA PORT IS RDY to Write
   #define LCD_WR_RDY               4
   /// GAMMA DATA PORT IS RDY to Read
   #define LCD_RD_RDY               3
   /// RGB10-->RGB8 using Trancate or Round off
   #define LCD_GAMMA_TR             2
   #define LCD_GAMMA_SET            1
   #define LCD_GAMMA_EN             0

/* for GAMMA_ADDR_PORT */
   /// Host Read/Write
   #define LCD_H_RD                 12
   /// Burst Mode
   #define LCD_H_AUTO_INC           11
   #define LCD_H_SEL_R              10
   #define LCD_H_SEL_G              9
   #define LCD_H_SEL_B              8
   /// 7:0
   #define LCD_HADR_MSB             7
   /// 7:0
   #define LCD_HADR                 0

/* for POL_CNTL_ADDR */
   /// FOR RGB format DVI output
   #define LCD_TCON_VSYNC_SEL_DVI   11
   /// FOR RGB format DVI output
   #define LCD_TCON_HSYNC_SEL_DVI   10
   /// FOR RGB format DVI output
   #define LCD_TCON_DE_SEL_DVI      9
   #define LCD_CPH3_POL             8
   #define LCD_CPH2_POL             7
   #define LCD_CPH1_POL             6
   #define LCD_TCON_DE_SEL          5
   #define LCD_TCON_VS_SEL          4
   #define LCD_TCON_HS_SEL          3
   #define LCD_DE_POL               2
   #define LCD_VS_POL               1
   #define LCD_HS_POL               0

/* for DITH_CNTL_ADDR */
   #define LCD_DITH10_EN            10
   #define LCD_DITH8_EN             9
   #define LCD_DITH_MD              8
   /// 7:4
   #define LCD_DITH10_CNTL_MSB      7
   /// 7:4
   #define LCD_DITH10_CNTL          4
   /// 3:0
   #define LCD_DITH8_CNTL_MSB       3
   /// 3:0
   #define LCD_DITH8_CNTL           0

/* for INV_CNT_ADDR */
   #define LCD_INV_EN               4
   #define LCD_INV_CNT_MSB          3
   #define LCD_INV_CNT              0

/* for TCON_MISC_SEL_ADDR */
   #define LCD_STH2_SEL             12
   #define LCD_STH1_SEL             11
   #define LCD_OEH_SEL              10
   #define LCD_VCOM_SEL             9
   #define LCD_DB_LINE_SW           8
   #define LCD_CPV2_SEL             7
   #define LCD_CPV1_SEL             6
   #define LCD_STV2_SEL             5
   #define LCD_STV1_SEL             4
   #define LCD_OEV_UNITE            3
   #define LCD_OEV3_SEL             2
   #define LCD_OEV2_SEL             1
   #define LCD_OEV1_SEL             0

/* for DUAL_PORT_CNTL_ADDR */
   #define LCD_ANALOG_SEL_CPH3      8
   #define LCD_ANALOG_3PHI_CLK_SEL  7
   #define LCD_LVDS_SEL54           6
   #define LCD_LVDS_SEL27           5
   #define LCD_TTL_SEL              4
   #define LCD_DUAL_PIXEL           3
   #define LCD_PORT_SWP             2
   #define LCD_RGB_SWP              1
   #define LCD_BIT_SWP              0

/* for LVDS_PACK_CNTL_ADDR */
   #define LCD_LD_CNT_MSB           7
   #define LCD_LD_CNT               5
   #define LCD_PN_SWP               4
   #define LCD_RES                  3
   #define LCD_LVDS_PORT_SWP        2
   #define LCD_PACK_RVS             1
   #define LCD_PACK_LITTLE          0

// lcd config flags
#define LCD_ANALOG              0
#define LCD_DIGITAL_TTL         1
#define LCD_SWAP_PbPr           2
#define LCD_DIGITAL_LVDS        4
#define LCD_DIGITAL_MLVDS       8

typedef struct {
	u16	width;			/* screen width in pixel unit */
	u16 height;			/* screen height in pixel unit */
	u16 max_width;		/* signal line width in pixel unit */
	u16 max_height;		/* signal line height in pixel unit */

	u16 video_on_line;

	u16 clk_ctrl;		/* video PLL clock settings */
	u32 pll_ctrl;		/* video PLL settings */
	u32 div_ctrl;
	u16 clk_div;		
	u16 pll_sel;
	u16 pll_div_sel;
	u16 clk_sel;

	u16 gamma_cntl_port;
	u16 gamma_vcom_hswitch_addr;

	u16 rgb_base_addr;
	u16 rgb_coeff_addr;
	u16 pol_cntl_addr;
	u16 dith_cntl_addr;    
                    
	u16 sth1_hs_addr;
	u16 sth1_he_addr;
	u16 sth1_vs_addr;
	u16 sth1_ve_addr;
                                
	u16 sth2_hs_addr;
	u16 sth2_he_addr;
	u16 sth2_vs_addr;
	u16 sth2_ve_addr;
                    
	u16 oeh_hs_addr;
	u16 oeh_he_addr;
	u16 oeh_vs_addr;
	u16 oeh_ve_addr;
                                
	u16 vcom_hswitch_addr;
	u16 vcom_vs_addr;
	u16 vcom_ve_addr;
                    
	u16 cpv1_hs_addr;
	u16 cpv1_he_addr;
	u16 cpv1_vs_addr;
	u16 cpv1_ve_addr;
                                
	u16 cpv2_hs_addr;
	u16 cpv2_he_addr;
	u16 cpv2_vs_addr;
	u16 cpv2_ve_addr;
                    
	u16 stv1_hs_addr;
	u16 stv1_he_addr;
	u16 stv1_vs_addr;
	u16 stv1_ve_addr;
                                
	u16 stv2_hs_addr;
	u16 stv2_he_addr;
	u16 stv2_vs_addr;
	u16 stv2_ve_addr;
                                
	u16 oev1_hs_addr;
	u16 oev1_he_addr;
	u16 oev1_vs_addr;
	u16 oev1_ve_addr;
                                
	u16 oev2_hs_addr;
	u16 oev2_he_addr;
	u16 oev2_vs_addr;
	u16 oev2_ve_addr;
                                
	u16 oev3_hs_addr;
	u16 oev3_he_addr;
	u16 oev3_vs_addr;
	u16 oev3_ve_addr;
                                
	u16 inv_cnt_addr;                                    
                    
	u16 tcon_misc_sel_addr;
                    
	u16 dual_port_cntl_addr;
    
	u16 flags;  
    
	u16 screen_width;	/* screen aspect ratio X direction */
 	u16 screen_height;	/* screen aspect ratio Y direction */
	u16 sync_duration_num;
	u16 sync_duration_den;

    u16 GammaTableR[256];
    u16 GammaTableG[256];
    u16 GammaTableB[256];
	void  (*power_on)(void);
	void  (*power_off)(void);
} tcon_conf_t;

tcon_conf_t tcon_config;

#endif /* TCON_H */
