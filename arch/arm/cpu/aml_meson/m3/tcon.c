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
#include <asm/arch/lcd.h>
#include <amlogic/aml_lcd.h>
 
#define BL_MAX_LEVEL 0x100
#define PANEL_NAME	"panel"

typedef struct {
	lcdConfig_t conf;
	vinfo_t lcd_info;
} tcon_dev_t;

static tcon_dev_t *pDev = NULL;

static void _tcon_init(lcdConfig_t *pConf) ;
static void set_lcd_gamma_table_B(u16 *data, u32 rgb_mask)
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

static void set_lcd_gamma_table_A(u16 *data, u32 rgb_mask)
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

static inline void _init_tcon_B(lcdConfig_t *pConf)
{
    debug("setup tcon\n");
    set_lcd_gamma_table_B(pConf->GammaTableR, H_SEL_R);
    set_lcd_gamma_table_B(pConf->GammaTableG, H_SEL_G);
    set_lcd_gamma_table_B(pConf->GammaTableB, H_SEL_B);

    WRITE_MPEG_REG(GAMMA_CNTL_PORT, pConf->gamma_cntl_port);
    WRITE_MPEG_REG(GAMMA_VCOM_HSWITCH_ADDR, pConf->gamma_vcom_hswitch_addr);

    WRITE_MPEG_REG(RGB_BASE_ADDR,   pConf->rgb_base_addr);
    WRITE_MPEG_REG(RGB_COEFF_ADDR,  pConf->rgb_coeff_addr);
    WRITE_MPEG_REG(POL_CNTL_ADDR,   pConf->pol_cntl_addr);
    WRITE_MPEG_REG(DITH_CNTL_ADDR,  pConf->dith_cntl_addr);

    WRITE_MPEG_REG(STH1_HS_ADDR,    pConf->sth1_hs_addr);
    WRITE_MPEG_REG(STH1_HE_ADDR,    pConf->sth1_he_addr);
    WRITE_MPEG_REG(STH1_VS_ADDR,    pConf->sth1_vs_addr);
    WRITE_MPEG_REG(STH1_VE_ADDR,    pConf->sth1_ve_addr);

    WRITE_MPEG_REG(OEH_HS_ADDR,     pConf->oeh_hs_addr);
    WRITE_MPEG_REG(OEH_HE_ADDR,     pConf->oeh_he_addr);
    WRITE_MPEG_REG(OEH_VS_ADDR,     pConf->oeh_vs_addr);
    WRITE_MPEG_REG(OEH_VE_ADDR,     pConf->oeh_ve_addr);

    WRITE_MPEG_REG(VCOM_HSWITCH_ADDR, pConf->vcom_hswitch_addr);
    WRITE_MPEG_REG(VCOM_VS_ADDR,    pConf->vcom_vs_addr);
    WRITE_MPEG_REG(VCOM_VE_ADDR,    pConf->vcom_ve_addr);

    WRITE_MPEG_REG(CPV1_HS_ADDR,    pConf->cpv1_hs_addr);
    WRITE_MPEG_REG(CPV1_HE_ADDR,    pConf->cpv1_he_addr);
    WRITE_MPEG_REG(CPV1_VS_ADDR,    pConf->cpv1_vs_addr);
    WRITE_MPEG_REG(CPV1_VE_ADDR,    pConf->cpv1_ve_addr);

    WRITE_MPEG_REG(STV1_HS_ADDR,    pConf->stv1_hs_addr);
    WRITE_MPEG_REG(STV1_HE_ADDR,    pConf->stv1_he_addr);
    WRITE_MPEG_REG(STV1_VS_ADDR,    pConf->stv1_vs_addr);
    WRITE_MPEG_REG(STV1_VE_ADDR,    pConf->stv1_ve_addr);

    WRITE_MPEG_REG(OEV1_HS_ADDR,    pConf->oev1_hs_addr);
    WRITE_MPEG_REG(OEV1_HE_ADDR,    pConf->oev1_he_addr);
    WRITE_MPEG_REG(OEV1_VS_ADDR,    pConf->oev1_vs_addr);
    WRITE_MPEG_REG(OEV1_VE_ADDR,    pConf->oev1_ve_addr);

    WRITE_MPEG_REG(INV_CNT_ADDR,    pConf->inv_cnt_addr);
    WRITE_MPEG_REG(TCON_MISC_SEL_ADDR, 	pConf->tcon_misc_sel_addr);
    WRITE_MPEG_REG(DUAL_PORT_CNTL_ADDR, pConf->dual_port_cntl_addr);

    CLEAR_MPEG_REG_MASK(VPP_MISC, VPP_OUT_SATURATE);

    debug("RGB_BASE = %x %x\n", READ_MPEG_REG(RGB_BASE_ADDR),    pConf->rgb_base_addr);
    debug("RGB_COEFF = %x %x\n", READ_MPEG_REG(RGB_COEFF_ADDR),  pConf->rgb_coeff_addr);
    debug("POL_CNTL = %x %x\n", READ_MPEG_REG(POL_CNTL_ADDR),    pConf->pol_cntl_addr);
    debug("DITH_CNTL = %x %x\n", READ_MPEG_REG(DITH_CNTL_ADDR),  pConf->dith_cntl_addr);

    debug("STH1_HS = %x %x\n", READ_MPEG_REG(STH1_HS_ADDR),    pConf->sth1_hs_addr);
    debug("STH1_HE = %x %x\n", READ_MPEG_REG(STH1_HE_ADDR),    pConf->sth1_he_addr);
    debug("STH1_VS = %x %x\n", READ_MPEG_REG(STH1_VS_ADDR),    pConf->sth1_vs_addr);
    debug("STH1_VE = %x %x\n", READ_MPEG_REG(STH1_VE_ADDR),     pConf->sth1_ve_addr);

    debug("OEH_HS = %x %x\n", READ_MPEG_REG(OEH_HS_ADDR),     pConf->oeh_hs_addr);
    debug("OEH_HS = %x %x\n", READ_MPEG_REG(OEH_HE_ADDR),     pConf->oeh_he_addr);
    debug("OEH_HS = %x %x\n", READ_MPEG_REG(OEH_VS_ADDR),     pConf->oeh_vs_addr);
    debug("OEH_HS = %x %x\n", READ_MPEG_REG(OEH_VE_ADDR),     pConf->oeh_ve_addr);

    debug("COM_HSWITCH = %x %x\n", READ_MPEG_REG(VCOM_HSWITCH_ADDR), pConf->vcom_hswitch_addr);
    debug("VCOM_VS = %x %x\n", READ_MPEG_REG(VCOM_VS_ADDR),    pConf->vcom_vs_addr);
    debug("VCOM_VE = %x %x\n", READ_MPEG_REG(VCOM_VE_ADDR),    pConf->vcom_ve_addr);

    debug("CPV1_HS = %x %x\n", READ_MPEG_REG(CPV1_HS_ADDR),    pConf->cpv1_hs_addr);
    debug("CPV1_HE = %x %x\n", READ_MPEG_REG(CPV1_HE_ADDR),    pConf->cpv1_he_addr);
    debug("CPV1_VS = %x %x\n", READ_MPEG_REG(CPV1_VS_ADDR),    pConf->cpv1_vs_addr);
    debug("CPV1_VE = %x %x\n", READ_MPEG_REG(CPV1_VE_ADDR),    pConf->cpv1_ve_addr);

    debug("STV1_HS = %x %x\n", READ_MPEG_REG(STV1_HS_ADDR),    pConf->stv1_hs_addr);
    debug("STV1_HS = %x %x\n", READ_MPEG_REG(STV1_HE_ADDR),    pConf->stv1_he_addr);
    debug("STV1_HS = %x %x\n", READ_MPEG_REG(STV1_VS_ADDR),    pConf->stv1_vs_addr);
    debug("STV1_HS = %x %x\n", READ_MPEG_REG(STV1_VE_ADDR),    pConf->stv1_ve_addr);

    debug("OEV1_HS = %x %x\n", READ_MPEG_REG(OEV1_HS_ADDR),    pConf->oev1_hs_addr);
    debug("OEV1_HE = %x %x\n", READ_MPEG_REG(OEV1_HE_ADDR),    pConf->oev1_he_addr);
    debug("OEV1_VS = %x %x\n", READ_MPEG_REG(OEV1_VS_ADDR),    pConf->oev1_vs_addr);
    debug("OEV1_VE = %x %x\n", READ_MPEG_REG(OEV1_VE_ADDR),    pConf->oev1_ve_addr);

    debug("INV_CNT = %x %x\n", READ_MPEG_REG(INV_CNT_ADDR),    pConf->inv_cnt_addr);
    debug("TCON_MISC_SEL_ADDR = %x %x\n", READ_MPEG_REG(TCON_MISC_SEL_ADDR), 	pConf->tcon_misc_sel_addr);
    debug("DUAL_PORT_CNTL = %x %x\n", READ_MPEG_REG(DUAL_PORT_CNTL_ADDR), pConf->dual_port_cntl_addr);
}

static inline void _init_tcon_A(lcdConfig_t *pConf)
{
    set_lcd_gamma_table_A(pConf->GammaTableR, H_SEL_R);
    set_lcd_gamma_table_A(pConf->GammaTableG, H_SEL_G);
    set_lcd_gamma_table_A(pConf->GammaTableB, H_SEL_B);

    WRITE_MPEG_REG(L_GAMMA_CNTL_PORT, pConf->gamma_cntl_port);
    WRITE_MPEG_REG(L_GAMMA_VCOM_HSWITCH_ADDR, pConf->gamma_vcom_hswitch_addr);

    WRITE_MPEG_REG(L_RGB_BASE_ADDR,   pConf->rgb_base_addr);
    WRITE_MPEG_REG(L_RGB_COEFF_ADDR,  pConf->rgb_coeff_addr);
    WRITE_MPEG_REG(L_POL_CNTL_ADDR,   pConf->pol_cntl_addr);
    WRITE_MPEG_REG(L_DITH_CNTL_ADDR,  pConf->dith_cntl_addr);

    WRITE_MPEG_REG(L_STH1_HS_ADDR,    pConf->sth1_hs_addr);
    WRITE_MPEG_REG(L_STH1_HE_ADDR,    pConf->sth1_he_addr);
    WRITE_MPEG_REG(L_STH1_VS_ADDR,    pConf->sth1_vs_addr);
    WRITE_MPEG_REG(L_STH1_VE_ADDR,    pConf->sth1_ve_addr);

    WRITE_MPEG_REG(L_OEH_HS_ADDR,     pConf->oeh_hs_addr);
    WRITE_MPEG_REG(L_OEH_HE_ADDR,     pConf->oeh_he_addr);
    WRITE_MPEG_REG(L_OEH_VS_ADDR,     pConf->oeh_vs_addr);
    WRITE_MPEG_REG(L_OEH_VE_ADDR,     pConf->oeh_ve_addr);

    WRITE_MPEG_REG(L_VCOM_HSWITCH_ADDR, pConf->vcom_hswitch_addr);
    WRITE_MPEG_REG(L_VCOM_VS_ADDR,    pConf->vcom_vs_addr);
    WRITE_MPEG_REG(L_VCOM_VE_ADDR,    pConf->vcom_ve_addr);

    WRITE_MPEG_REG(L_CPV1_HS_ADDR,    pConf->cpv1_hs_addr);
    WRITE_MPEG_REG(L_CPV1_HE_ADDR,    pConf->cpv1_he_addr);
    WRITE_MPEG_REG(L_CPV1_VS_ADDR,    pConf->cpv1_vs_addr);
    WRITE_MPEG_REG(L_CPV1_VE_ADDR,    pConf->cpv1_ve_addr);

    WRITE_MPEG_REG(L_STV1_HS_ADDR,    pConf->stv1_hs_addr);
    WRITE_MPEG_REG(L_STV1_HE_ADDR,    pConf->stv1_he_addr);
    WRITE_MPEG_REG(L_STV1_VS_ADDR,    pConf->stv1_vs_addr);
    WRITE_MPEG_REG(L_STV1_VE_ADDR,    pConf->stv1_ve_addr);

    WRITE_MPEG_REG(L_OEV1_HS_ADDR,    pConf->oev1_hs_addr);
    WRITE_MPEG_REG(L_OEV1_HE_ADDR,    pConf->oev1_he_addr);
    WRITE_MPEG_REG(L_OEV1_VS_ADDR,    pConf->oev1_vs_addr);
    WRITE_MPEG_REG(L_OEV1_VE_ADDR,    pConf->oev1_ve_addr);

    WRITE_MPEG_REG(L_INV_CNT_ADDR,    pConf->inv_cnt_addr);
    WRITE_MPEG_REG(L_TCON_MISC_SEL_ADDR, 	pConf->tcon_misc_sel_addr);
    WRITE_MPEG_REG(L_DUAL_PORT_CNTL_ADDR, pConf->dual_port_cntl_addr);

    CLEAR_MPEG_REG_MASK(VPP_MISC, VPP_OUT_SATURATE);
}

static void vclk_set_lcd( int pll_sel, int pll_div_sel, int vclk_sel,
                   unsigned long pll_reg, unsigned long vid_div_reg, unsigned int xd)
{
    debug("setup lcd clk.\n");
    vid_div_reg |= (1 << 16) ; // turn clock gate on
    vid_div_reg |= (pll_sel << 15); // vid_div_clk_sel


    if(vclk_sel) {
      WRITE_MPEG_REG( HHI_VIID_CLK_CNTL, READ_MPEG_REG(HHI_VIID_CLK_CNTL) & ~(1 << 19) );     //disable clk_div0
    }
    else {
      WRITE_MPEG_REG( HHI_VID_CLK_CNTL, READ_MPEG_REG(HHI_VID_CLK_CNTL) & ~(1 << 19) );     //disable clk_div0
      WRITE_MPEG_REG( HHI_VID_CLK_CNTL, READ_MPEG_REG(HHI_VID_CLK_CNTL) & ~(1 << 20) );     //disable clk_div1
    }

    // delay 2uS to allow the sync mux to switch over
    //WRITE_MPEG_REG( ISA_TIMERE, 0); while( READ_MPEG_REG(ISA_TIMERE) < 2 ) {}
	udelay(2);

    if(pll_sel){
        WRITE_MPEG_REG( HHI_VIID_PLL_CNTL, pll_reg|(1<<30) );
        WRITE_MPEG_REG( HHI_VIID_PLL_CNTL2, 0x65e31ff );
        WRITE_MPEG_REG( HHI_VIID_PLL_CNTL3, 0x9649a941 );
        WRITE_MPEG_REG( HHI_VIID_PLL_CNTL, pll_reg );
    }
    else{
        WRITE_MPEG_REG( HHI_VID_PLL_CNTL, pll_reg|(1<<30) );
        WRITE_MPEG_REG( HHI_VID_PLL_CNTL2, 0x65e31ff );
        WRITE_MPEG_REG( HHI_VID_PLL_CNTL3, 0x9649a941 );
        WRITE_MPEG_REG( HHI_VID_PLL_CNTL, pll_reg );
    }
    if(pll_div_sel ) WRITE_MPEG_REG( HHI_VIID_DIVIDER_CNTL,   vid_div_reg);
    else WRITE_MPEG_REG( HHI_VID_DIVIDER_CNTL,   vid_div_reg);

    if(vclk_sel) WRITE_MPEG_REG( HHI_VIID_CLK_DIV, (READ_MPEG_REG(HHI_VIID_CLK_DIV) & ~(0xFF << 0)) | (xd-1) );   // setup the XD divider value
    else WRITE_MPEG_REG( HHI_VID_CLK_DIV, (READ_MPEG_REG(HHI_VID_CLK_DIV) & ~(0xFF << 0)) | (xd-1) );   // setup the XD divider value

    // delay 5uS
    //WRITE_MPEG_REG( ISA_TIMERE, 0); while( READ_MPEG_REG(ISA_TIMERE) < 5 ) {}
	udelay(5);

    if(vclk_sel) {
      if(pll_div_sel) WRITE_MPEG_REG_BITS (HHI_VIID_CLK_CNTL, 4, 16, 3);  // Bit[18:16] - v2_cntl_clk_in_sel
      else WRITE_MPEG_REG_BITS (HHI_VIID_CLK_CNTL, 0, 16, 3);  // Bit[18:16] - cntl_clk_in_sel
      WRITE_MPEG_REG( HHI_VIID_CLK_CNTL, READ_MPEG_REG(HHI_VIID_CLK_CNTL) |  (1 << 19) );     //enable clk_div0
    }
    else {
      if(pll_div_sel) WRITE_MPEG_REG_BITS (HHI_VID_CLK_CNTL, 4, 16, 3);  // Bit[18:16] - v2_cntl_clk_in_sel
      else WRITE_MPEG_REG_BITS (HHI_VID_CLK_CNTL, 0, 16, 3);  // Bit[18:16] - cntl_clk_in_sel
      WRITE_MPEG_REG( HHI_VID_CLK_CNTL, READ_MPEG_REG(HHI_VID_CLK_CNTL) |  (1 << 19) );     //enable clk_div0
      WRITE_MPEG_REG( HHI_VID_CLK_CNTL, READ_MPEG_REG(HHI_VID_CLK_CNTL) |  (1 << 20) );     //enable clk_div1
    }
    // delay 2uS
    //WRITE_MPEG_REG( ISA_TIMERE, 0); while( READ_MPEG_REG(ISA_TIMERE) < 2 ) {}
	udelay(2);

    // set tcon_clko setting
    WRITE_MPEG_REG_BITS (HHI_VID_CLK_CNTL,
                    (
                    (0 << 11) |     //clk_div1_sel
                    (1 << 10) |     //clk_inv
                    (0 << 9)  |     //neg_edge_sel
                    (0 << 5)  |     //tcon high_thresh
                    (0 << 1)  |     //tcon low_thresh
                    (1 << 0)        //cntl_clk_en1
                    ),
                    20, 12);

    if(vclk_sel) {
      WRITE_MPEG_REG_BITS (HHI_VIID_CLK_CNTL,
                   (1<<0),  // Enable cntl_div1_en
                   0, 1    // cntl_div1_en
                   );
      WRITE_MPEG_REG_BITS (HHI_VIID_CLK_CNTL, 1, 15, 1);  //soft reset
      WRITE_MPEG_REG_BITS (HHI_VIID_CLK_CNTL, 0, 15, 1);  //release soft reset
    }
    else {
      WRITE_MPEG_REG_BITS (HHI_VID_CLK_CNTL,
                   (1<<0),  // Enable cntl_div1_en
                   0, 1    // cntl_div1_en
                   );
      WRITE_MPEG_REG_BITS (HHI_VID_CLK_CNTL, 1, 15, 1);  //soft reset
      WRITE_MPEG_REG_BITS (HHI_VID_CLK_CNTL, 0, 15, 1);  //release soft reset
    }

    debug("video pl1 clk = %d\n", clk_util_clk_msr(VID_PLL_CLK));
    debug("video pll2 clk = %d\n", clk_util_clk_msr(VID2_PLL_CLK));
    debug("cts_enct clk = %d\n", clk_util_clk_msr(CTS_ENCT_CLK));
}

static void set_lcd_pll(lcdConfig_t *pConf)
{
	unsigned pll_reg, div_reg, xd;
	int pll_sel, pll_div_sel, vclk_sel;

	pll_reg = pConf->pll_ctrl;
	div_reg = pConf->div_ctrl | 0x3;
	xd = pConf->clk_ctrl & 0xf;
	pll_sel = ((pConf->clk_ctrl) >>12) & 0x1;
	pll_div_sel = ((pConf->clk_ctrl) >>8) & 0x1;
	vclk_sel = ((pConf->clk_ctrl) >>4) & 0x1;

	debug("pll_sel=%d, pll_div_sel=%d, vclk_sel=%d, pll_reg=0x%x, div_reg=0x%x, xd=%d.\n", pll_sel, pll_div_sel, vclk_sel, pll_reg, div_reg, xd);
	vclk_set_lcd(pll_sel, pll_div_sel, vclk_sel, pll_reg, div_reg, xd);
}

static void venc_set_lcd(lcdConfig_t *pConf)
{
    debug("setup lcd tvencoder.\n");
    WRITE_MPEG_REG(VPU_VIU_VENC_MUX_CTRL,
       (3<<0) |    // viu1 select enct
       (3<<2)      // viu2 select enct
    );
    WRITE_MPEG_REG(ENCT_VIDEO_MODE,        0);
    WRITE_MPEG_REG(ENCT_VIDEO_MODE_ADV,    0x0418);

    WRITE_MPEG_REG(ENCT_VIDEO_MAX_PXCNT,    pConf->max_width - 1);
    WRITE_MPEG_REG(ENCT_VIDEO_MAX_LNCNT,    pConf->max_height - 1);

    WRITE_MPEG_REG(ENCT_VIDEO_HAVON_BEGIN,  48);
    WRITE_MPEG_REG(ENCT_VIDEO_HAVON_END,    pConf->width - 1 + 48 );
    WRITE_MPEG_REG(ENCT_VIDEO_VAVON_BLINE,  pConf->video_on_line);
    WRITE_MPEG_REG(ENCT_VIDEO_VAVON_ELINE,  pConf->height + 3  + pConf->video_on_line);

    WRITE_MPEG_REG(ENCT_VIDEO_HSO_BEGIN,    15);
    WRITE_MPEG_REG(ENCT_VIDEO_HSO_END,      31);
    WRITE_MPEG_REG(ENCT_VIDEO_VSO_BEGIN,    15);
    WRITE_MPEG_REG(ENCT_VIDEO_VSO_END,      31);
    WRITE_MPEG_REG(ENCT_VIDEO_VSO_BLINE,    0);
    WRITE_MPEG_REG(ENCT_VIDEO_VSO_ELINE,    2);

    // bypass filter
    WRITE_MPEG_REG(ENCT_VIDEO_FILT_CTRL,    0x1000);

    // enable enct
    WRITE_MPEG_REG(ENCT_VIDEO_EN,           1);

}

static inline void _init_tvenc(lcdConfig_t *pConf)
{
    set_lcd_pll(pConf);
    venc_set_lcd(pConf);
}

static inline void _enable_vsync_interrupt(void)
{
    if (READ_MPEG_REG(ENCP_VIDEO_EN) & 1) {
        WRITE_MPEG_REG(VENC_INTCTRL, 0x200);
    }
    else{
        WRITE_MPEG_REG(VENC_INTCTRL, 0x2);
    }
}
static void _enable_backlight(u32 brightness_level)
{
    //pDev->conf.backlight_on?pDev->conf.backlight_on():0;
    panel_oper.bl_on();
}
/*static void _disable_backlight(void)
{
    //pDev->conf.backlight_off?pDev->conf.backlight_off():0;
    panel_oper.bl_off();
}*/
static void _lcd_module_enable(void)
{
    BUG_ON(pDev==NULL);
    //pDev->conf.power_on?pDev->conf.power_on():0;
    panel_oper.power_on();
    _init_tvenc(&pDev->conf);   	  //ENCT
    _init_tcon_B(&pDev->conf);    //TCON
    //_init_tcon_A(&pDev->conf);  //L_TCON
    _enable_vsync_interrupt();
}

//static const vinfo_t *lcd_get_current_info(void)
//{
//	return &pDev->lcd_info;
//}

static int lcd_set_current_vmode(vmode_t mode)	//ÉèÖÃÆÁ¿í
{
    if (mode != VMODE_LCD)
        return -1;
    WRITE_MPEG_REG(VPP_POSTBLEND_H_SIZE, pDev->lcd_info.width);
    _lcd_module_enable();
    if (VMODE_INIT_NULL == pDev->lcd_info.mode)
        pDev->lcd_info.mode = VMODE_LCD;
    else
        _enable_backlight(BL_MAX_LEVEL);
	return 0;
}

/*static vmode_t lcd_validate_vmode(char *mode)
{
	if ((strncmp(mode, PANEL_NAME, strlen(PANEL_NAME))) == 0)
		return VMODE_LCD;

	return VMODE_MAX;
}
static int lcd_vmode_is_supported(vmode_t mode)
{
	mode&=VMODE_MODE_BIT_MASK;
	if(mode == VMODE_LCD)
	    return 1;
	return 0;
}
static int lcd_module_disable(vmode_t cur_vmod)
{
    BUG_ON(pDev==NULL);
    _disable_backlight();
    //pDev->conf.power_off?pDev->conf.power_off():0;
    panel_oper.power_off();
    return 0;
}*/

static void _init_vout(tcon_dev_t *pDev)
{
    pDev->lcd_info.name = PANEL_NAME;
    pDev->lcd_info.mode = VMODE_INIT_NULL;
    pDev->lcd_info.width = pDev->conf.width;
    pDev->lcd_info.height = pDev->conf.height;
    pDev->lcd_info.field_height = pDev->conf.height;
    pDev->lcd_info.aspect_ratio_num = pDev->conf.screen_width;
    pDev->lcd_info.aspect_ratio_den = pDev->conf.screen_height;
    pDev->lcd_info.sync_duration_num = pDev->conf.sync_duration_num;
    pDev->lcd_info.sync_duration_den = pDev->conf.sync_duration_den;
}

static void _tcon_init(lcdConfig_t *pConf)
{
	_init_vout(pDev);
    	_lcd_module_enable();
	lcd_set_current_vmode(VMODE_LCD);
}

int tcon_probe(void)
{
    pDev = (tcon_dev_t *)malloc(sizeof(tcon_dev_t));
    if (!pDev) {
        printf("[tcon]: Not enough memory.\n");
        return -1;
    }

    pDev->conf = lcd_config;

    _tcon_init(&pDev->conf);
    return 0;
}

int tcon_remove(void)
{
    free(pDev);
    return 0;
}
