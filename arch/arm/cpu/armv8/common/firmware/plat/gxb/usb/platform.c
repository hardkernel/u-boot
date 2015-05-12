/* platform dirver header */
/*
 * (C) Copyright 2010 Amlogic, Inc
 *
 * Victor Wan, victor.wan@amlogic.com,
 * 2010-03-24 @ Shanghai
 *
 */
 #include "platform.h"

/*
   cfg = 0 : EXT clock
   cfg = 1 : INT clock
  */
#ifdef CONFIG_M6

#define PREI_USB_PHY_A_REG_BASE       0xC1108400  //0x2100
#define PREI_USB_PHY_B_REG_BASE       0xC1108420	//0X2108

#ifdef __USE_PORT_B
#define PREI_USB_PHY_REG_BASE   PREI_USB_PHY_B_REG_BASE
#else
#define PREI_USB_PHY_REG_BASE   PREI_USB_PHY_A_REG_BASE
#endif

#define P_RESET1_REGISTER                           (volatile unsigned long *)0xc1104408
#define USB_CLK_SEL_XTAL				0
#define USB_CLK_SEL_XTAL_DIV_2	1
#define USB_CLK_SEL_DDR_PLL			2
#define USB_CLK_SEL_MPLL_OUT0		3
#define USB_CLK_SEL_MPLL_OUT1		4
#define USB_CLK_SEL_MPLL_OUT2		5
#define USB_CLK_SEL_FCLK_DIV2		6
#define USB_CLK_SEL_FCLK_DIV3		7

typedef struct usb_aml_regs {
    volatile uint32_t config;
    volatile uint32_t ctrl;
    volatile uint32_t endp_intr;
    volatile uint32_t adp_bc;
    volatile uint32_t dbg_uart;
    volatile uint32_t test;
    volatile uint32_t tune;
} usb_aml_regs_t;

typedef union usb_config_data {
    /** raw register data */
    uint32_t d32;
    /** register bits */
    struct {
        unsigned clk_en:1;
        unsigned clk_sel:3;
        unsigned clk_div:7;
        unsigned reserved:20;
        unsigned test_trig:1;
    } b;
} usb_config_data_t;

typedef union usb_ctrl_data {
    /** raw register data */
    uint32_t d32;
    /** register bits */
    struct {
        unsigned soft_prst:1;
        unsigned soft_hreset:1;
        unsigned ss_scaledown_mode:2;
        unsigned clk_det_rst:1;
        unsigned intr_sel:1;
        unsigned reserved:2;
        unsigned clk_detected:1;
        unsigned sof_sent_rcvd_tgl:1;
        unsigned sof_toggle_out:1;
        unsigned not_used:4;
        unsigned por:1;
        unsigned sleepm:1;
        unsigned txbitstuffennh:1;
        unsigned txbitstuffenn:1;
        unsigned commononn:1;
        unsigned refclksel:2;
        unsigned fsel:3;
        unsigned portreset:1;
        unsigned thread_id:6;
    } b;
} usb_ctrl_data_t;
static void set_usb_phy_config(int cfg)
{

	int time_dly = 500;
	usb_aml_regs_t * usb_aml_regs = (usb_aml_regs_t * )PREI_USB_PHY_REG_BASE;
	usb_config_data_t config;
	usb_ctrl_data_t control;

	*P_RESET1_REGISTER = (1<<2);//usb reset

	config.d32 = usb_aml_regs->config;
	if (cfg == EXT_CLOCK)
	{/* crystal == 24M */
		config.b.clk_sel = USB_CLK_SEL_XTAL_DIV_2;	// 12M, Phy default setting is 12Mhz
		config.b.clk_div = 0; // 24M /(0 + 1) = 12M
	}
	else
	{
#ifndef M3_SIM
		config.b.clk_sel = USB_CLK_SEL_DDR_PLL; // ddr_pll = 600M
#else
		config.b.clk_sel = USB_CLK_SEL_MPLL_OUT0; // ddr_pll = 600M
#endif
		config.b.clk_div = 49; // (600 / (49 + 1)) = 12M
	}
	config.b.clk_en = 1;
	usb_aml_regs->config = config.d32;
	control.d32 = usb_aml_regs->ctrl;
	control.b.fsel = 2;
	control.b.por = 1;
	usb_aml_regs->ctrl = control.d32;
	udelay(time_dly);
	control.b.por = 0;
	usb_aml_regs->ctrl = control.d32;
	udelay(time_dly);

}
#else
static void set_usb_phy_config(int cfg)
{

    int divider =0;
    int clk_sel = 0;
    int i;
    int time_dly = 500;

	// ------------------------------------------------------------
	//  CLK_SEL: These bits select the source for the 12Mhz:
	// 0 = Oscillator pad input (when a 24Mhz XTAL is used),
	// 1 = Oscillator pad input divided by 2 (when a 24mhz XTAL is used),
	// 2 = sys_pll_clk
	// 3 = misc_pll_clk
	// 4 = ddr_pll_clk
	// 5 = audio_pll_clk
	// 6 = vid_pll_clk
	CLEAR_PERIPHS_REG_BITS(PREI_USB_PHY_REG, PREI_USB_PHY_CLK_SEL);
	CLEAR_PERIPHS_REG_BITS(PREI_USB_PHY_REG, PREI_USB_PHY_CLK_DIV);
	if (cfg == EXT_CLOCK)
	{/* crystal == 24M */
		clk_sel = 1; // 12M, Phy default setting is 12Mhz
		divider = 0; // 24M /(0 + 1) = 12M
	}
	else
	{
		clk_sel = 3; // misc_pll = 600M
		divider = 49; // (600 / (49 + 1)) = 12M
	}
	SET_PERIPHS_REG_BITS(PREI_USB_PHY_REG, (divider << 24));
	SET_PERIPHS_REG_BITS(PREI_USB_PHY_REG, (clk_sel<< 5 ));

	/* Force ID to 1 (device mode) */
#ifndef __USE_PORT_B
	SET_PERIPHS_REG_BITS(PREI_USB_PHY_B_REG4,PREI_USB_PHY_B_REG4_IDDIG_OVR);
	SET_PERIPHS_REG_BITS(PREI_USB_PHY_B_REG4,PREI_USB_PHY_B_REG4_IDDIG_VAL);
#else
	SET_PERIPHS_REG_BITS(PREI_USB_PHY_A_REG3,PREI_USB_PHY_A_REG3_IDDIG_OVR);
	SET_PERIPHS_REG_BITS(PREI_USB_PHY_A_REG3,PREI_USB_PHY_A_REG3_IDDIG_VAL);
#endif

	// Open clock gate, to enable CLOCK to usb phy
	SET_PERIPHS_REG_BITS(PREI_USB_PHY_REG, PREI_USB_PHY_CLK_GATE);
	i=0;
	while (i++<time_dly) {};


#ifndef __USE_PORT_B
    /*  Reset USB PHY A  */
    SET_PERIPHS_REG_BITS(PREI_USB_PHY_REG, PREI_USB_PHY_A_AHB_RSET);
    i=0;
    while (i++<time_dly) {};
    CLEAR_PERIPHS_REG_BITS(PREI_USB_PHY_REG, PREI_USB_PHY_A_AHB_RSET);
    i=0;
    while (i++<time_dly) {};
    SET_PERIPHS_REG_BITS(PREI_USB_PHY_REG, PREI_USB_PHY_A_CLK_RSET);
    i=0;
    while (i++<time_dly) {};
    CLEAR_PERIPHS_REG_BITS(PREI_USB_PHY_REG, PREI_USB_PHY_A_CLK_RSET);
    i=0;
    while (i++<time_dly) {};
    SET_PERIPHS_REG_BITS(PREI_USB_PHY_REG, PREI_USB_PHY_A_PLL_RSET);
    i=0;
    while (i++<time_dly) {};
    CLEAR_PERIPHS_REG_BITS(PREI_USB_PHY_REG, PREI_USB_PHY_A_PLL_RSET);
    i=0;
    while (i++<time_dly) {};

    // ------------------------------------------------------------
    // Reset the PHY A by setting POR high for 10uS.
    SET_PERIPHS_REG_BITS(PREI_USB_PHY_REG, PREI_USB_PHY_A_POR);
    i=0;
    while (i++<time_dly) {};
    // Set POR to the PHY high

    CLEAR_PERIPHS_REG_BITS(PREI_USB_PHY_REG, PREI_USB_PHY_A_POR);
    i=0;
    while (i++<time_dly) {};

#else
    /* Reset USB PHY B */
    SET_PERIPHS_REG_BITS(PREI_USB_PHY_REG, PREI_USB_PHY_B_AHB_RSET);
    i=0;
    while (i++<time_dly) {};
    CLEAR_PERIPHS_REG_BITS(PREI_USB_PHY_REG, PREI_USB_PHY_B_AHB_RSET);
    i=0;
    while (i++<time_dly) {};
    SET_PERIPHS_REG_BITS(PREI_USB_PHY_REG, PREI_USB_PHY_B_CLK_RSET);
    i=0;
    while (i++<time_dly) {};
    CLEAR_PERIPHS_REG_BITS(PREI_USB_PHY_REG, PREI_USB_PHY_B_CLK_RSET);
    i=0;
    while (i++<time_dly) {};
    SET_PERIPHS_REG_BITS(PREI_USB_PHY_REG, PREI_USB_PHY_B_PLL_RSET);
    i=0;
    while (i++<time_dly) {};
    CLEAR_PERIPHS_REG_BITS(PREI_USB_PHY_REG, PREI_USB_PHY_B_PLL_RSET);
    i=0;
    while (i++<time_dly) {};

    // ------------------------------------------------------------
    // Reset the PHY B by setting POR high for 10uS.
    SET_PERIPHS_REG_BITS(PREI_USB_PHY_REG, PREI_USB_PHY_B_POR);
    i=0;
    while (i++<time_dly) {};

    // Set POR to the PHY high
    CLEAR_PERIPHS_REG_BITS(PREI_USB_PHY_REG, PREI_USB_PHY_B_POR);
    i=0;
    while (i++<time_dly) {};

#endif

}
#endif
#if 0
int chip_watchdog(void)
{
	watchdog_clear();
	return 0;
};
#endif

#if 1
void usb_memcpy(char * dst,char * src,int len)
{
	while (len--)
	{
		*(unsigned char*)dst++ = *(unsigned char*)src++;
	}
}
void usb_memcpy_32bits(int *dst,int *src,int len)
{
	while (len--)
	{
		*dst = *src;
		dst++;
		src++;
	}
}
#endif

#if 0
SPL_STATIC_FUNC unsigned get_utimer(unsigned base)
{
    return TIMERE_SUB(TIMERE_GET(),base);
}

unsigned long get_timer(unsigned long base)
{
    return get_utimer(base*TICKET_BASE_ON_USEC)/TICKET_BASE_ON_USEC;
}

SPL_STATIC_FUNC void __udelay(unsigned long usec)
{
    unsigned long base=TIMERE_GET();
    while (TIMERE_SUB(TIMERE_GET(),base)<usec);
}
#endif

