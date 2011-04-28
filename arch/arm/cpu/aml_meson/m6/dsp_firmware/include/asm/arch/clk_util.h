#ifndef CLK_UTIL_H
#define CLK_UTIL_H

#define ENC_SEL_I 1
#define ENC_SEL_P 2
#define ENC_SEL_L 0
#define ENC_SEL_T 3
#define ENC_SEL_ALL -1
extern void clocks_set_sys_defaults(void);
extern void clocks_set_hdtv(void);
extern void clk_util_clocks_set_lcd240x160( unsigned long pll_divide_m1);
extern void clk_util_clocks_set_lcd480x234(void);
extern void clk_util_clocks_set_lcd1024x768(void);
extern void clk_util_clocks_set_lcd1280x1024(void);

extern void clk_util_set_mpeg_clock( unsigned long hiu_reg, unsigned long xd );
extern void clk_util_set_audio_clock( unsigned long hiu_reg, unsigned long xd );
extern void clk_util_set_video_clock( unsigned long pll_reg, unsigned long vid_div_reg, unsigned long xd );
extern void clk_util_clocks_set_video_other(unsigned long vclk3_freq, unsigned long vclk2_ratio, unsigned long vclk1_ratio);
extern void clk_util_setup_lvds_clock( unsigned long vid_pll_clk_sel, unsigned long phy_clk_div2, unsigned long vid_pll_hiu_reg,
                                        unsigned long vid_pll_xd, unsigned long digclk_sel, unsigned long perform_cal );

unsigned long    clk_util_clk_msr(   unsigned long   clk_mux, unsigned long   uS_gate_time );

void    clk_util_lvds_set_clk_div(  unsigned long   pre_divider,    // 1..6
                                    unsigned long   post_divider,   // 1..7  Use 99 for divide by 3.5
                                    unsigned long   phy_div2_en  ); // 1 = LVDS PHY divide by 2 enable, 0 = PHY divide by 1 

extern void vclk_set_encp_1920x1080( int pll_sel, int pll_div_sel, int vclk_sel, int upsample);
extern void vclk_set_enc_1920x1080( int pll_sel, int pll_div_sel, int vclk_sel, int enc_sel, int upsample);
extern void vclk_set_enc_720x480( int pll_sel, int pll_div_sel, int vclk_sel, int enc_sel, int upsample);

extern void vclk_set_lcd_lvds( int lcd_lvds, int pll_sel, int pll_div_sel, int vclk_sel, 
                   unsigned long pll_reg, unsigned long vid_div_reg, unsigned int xd);

#endif
