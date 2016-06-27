#include <common.h>
#include <amlogic/enc_clk_config.h>
#include <asm/arch/io.h>
#include <asm/io.h>
#include "hw_enc_clk_config.h"
#include "mach_reg.h"
#include <amlogic/hdmi.h>

#define msleep(i) udelay(i*1000)

#define check_clk_config(para)\
	if (para == -1)\
		return;

#define check_div() \
	if (div == -1)\
		return ;\
	switch (div) {\
	case 1:\
		div = 0; break;\
	case 2:\
		div = 1; break;\
	case 4:\
		div = 2; break;\
	case 6:\
		div = 3; break;\
	case 12:\
		div = 4; break;\
	default:\
		break;\
	}

#define WAIT_FOR_PLL_LOCKED(reg)                        \
	do {                                                \
		unsigned int cnt = 10;                          \
		unsigned int time_out = 0;                      \
		while (cnt --) {                                 \
		time_out = 0;                               \
		while ((!(hd_read_reg(reg) & (1 << 31)))\
			& (time_out < 10000))               \
			time_out ++;                            \
		}                                               \
		if (cnt < 9)                                     \
			printk("pll[0x%x] reset %d times\n", reg, 9 - cnt);\
	} while(0);

// viu_channel_sel: 1 or 2
// viu_type_sel: 0: 0=ENCL, 1=ENCI, 2=ENCP, 3=ENCT.
int set_viu_path(unsigned viu_channel_sel, enum viu_type viu_type_sel)
{
	if ((viu_channel_sel > 2) || (viu_channel_sel == 0))
		return -1;
	if (viu_channel_sel == 1)
		hd_set_reg_bits(P_VPU_VIU_VENC_MUX_CTRL, viu_type_sel, 0, 2);
	else
		//viu_channel_sel ==2
		hd_set_reg_bits(P_VPU_VIU_VENC_MUX_CTRL, viu_type_sel, 2, 2);
	return 0;
}

static void set_hdmitx_sys_clk(void)
{
	hd_set_reg_bits(P_HHI_HDMI_CLK_CNTL, 0, 9, 3);
	hd_set_reg_bits(P_HHI_HDMI_CLK_CNTL, 0, 0, 7);
	hd_set_reg_bits(P_HHI_HDMI_CLK_CNTL, 1, 8, 1);
}

static void set_hpll_clk_out(unsigned clk)
{
	check_clk_config(clk);
	// printk("config HPLL = %d\n", clk);
	switch (clk) {
	case 5940:
		hd_write_reg(P_HHI_HDMI_PLL_CNTL, 0x5800027b);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL2, 0x00000000);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL3, 0x135c5091);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL4, 0x801da72c);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL5, 0x71486980);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL6, 0x00000e55);
		hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL, 0x4, 28, 3);
		WAIT_FOR_PLL_LOCKED(P_HHI_HDMI_PLL_CNTL);
		// printk("HPLL: 0x%lx\n", hd_read_reg(P_HHI_HDMI_PLL_CNTL));
		hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL2, 0x4c00, 0, 16); // div_frac
		break;
	case 2970:
		hd_write_reg(P_HHI_HDMI_PLL_CNTL, 0x5800023d);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL2, 0x00000000);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL3, 0x0d5c5091);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL4, 0x801da72c);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL5, 0x71486980);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL6, 0x00000e55);
		hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL, 0x4, 28, 3);
		WAIT_FOR_PLL_LOCKED(P_HHI_HDMI_PLL_CNTL);
		// printk("HPLL: 0x%lx\n", hd_read_reg(P_HHI_HDMI_PLL_CNTL));
		hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL2, 0x4e00, 0, 16); // div_frac
		break;
	case 4320:
		hd_write_reg(P_HHI_HDMI_PLL_CNTL, 0x58000259);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL2, 0x00000000);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL3, 0x0d5c5091);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL4, 0x801da72c);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL5, 0x71486980);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL6, 0x00000e55);
		hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL, 0x4, 28, 3);
		WAIT_FOR_PLL_LOCKED(P_HHI_HDMI_PLL_CNTL);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL, 0x4800025a);
		// printk("HPLL: 0x%lx\n", hd_read_reg(P_HHI_HDMI_PLL_CNTL));
		break;
	case 3197:
		hd_write_reg(P_HHI_HDMI_PLL_CNTL, 0x58000242);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL2, 0x00000000);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL3, 0x0d5c5091);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL4, 0x801da72c);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL5, 0x71486980);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL6, 0x00000e55);
		hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL, 0x4, 28, 3);
		WAIT_FOR_PLL_LOCKED(P_HHI_HDMI_PLL_CNTL);
		hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL2, 0x4e00, 0, 16);
		break;
	case 2685:
		hd_write_reg(P_HHI_HDMI_PLL_CNTL, 0x5800026f);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL2, 0x00000000);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL3, 0x0d5c5091);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL4, 0x801da72c);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL5, 0x71486980);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL6, 0x00000e55);
		hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL, 0x4, 28, 3);
		WAIT_FOR_PLL_LOCKED(P_HHI_HDMI_PLL_CNTL);
		hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL2, 0x4e00, 0, 16);
		break;
	case 2448:
		hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL2, 1, 14, 1); // div mode
		hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL2, 0xe00, 0, 12); // div_frac
		hd_write_reg(P_HHI_HDMI_PLL_CNTL3, 0x135c5091);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL4, 0x801da72c);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL5, 0x71486b00);    //5940 0x71c86900      // 0x71486900 2970
		hd_write_reg(P_HHI_HDMI_PLL_CNTL6, 0x00000e55);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL, 0x00000266);
		hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL, 0x5, 28, 3);  //reset hpll
		hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL, 0x4, 28, 3);
		// printk("waiting HPLL lock\n");
		WAIT_FOR_PLL_LOCKED(P_HHI_HDMI_PLL_CNTL);
		break;
	case 2415:
		hd_write_reg(P_HHI_HDMI_PLL_CNTL, 0x58000264);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL2, 0x00000000);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL3, 0x0d5c5091);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL4, 0x801da72c);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL5, 0x71486980);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL6, 0x00000e55);
		hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL, 0x4, 28, 3);
		WAIT_FOR_PLL_LOCKED(P_HHI_HDMI_PLL_CNTL);
		hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL2, 0x4e00, 0, 16);
		break;
	case 1855:
		hd_write_reg(P_HHI_HDMI_PLL_CNTL, 0x5800024d);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL2, 0x00000000);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL3, 0x0d5c5091);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL4, 0x801da72c);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL5, 0x71486980);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL6, 0x00000e55);
		hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL, 0x4, 28, 3);
		WAIT_FOR_PLL_LOCKED(P_HHI_HDMI_PLL_CNTL);
		hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL2, 0x4e00, 0, 16);
		break;
	case 1540:
		hd_write_reg(P_HHI_HDMI_PLL_CNTL, 0x5800023f);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL2, 0x00000000);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL3, 0x0d5c5091);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL4, 0x801da72c);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL5, 0x71486980);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL6, 0x00000e55);
		hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL, 0x4, 28, 3);
		WAIT_FOR_PLL_LOCKED(P_HHI_HDMI_PLL_CNTL);
		hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL2, 0x4e00, 0, 16);
		break;
	case 1463:
		hd_write_reg(P_HHI_HDMI_PLL_CNTL, 0x58000279);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL2, 0x00000000);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL3, 0x0d5c5091);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL4, 0x801da72c);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL5, 0x71486980);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL6, 0x00000e55);
		hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL, 0x4, 28, 3);
		WAIT_FOR_PLL_LOCKED(P_HHI_HDMI_PLL_CNTL);
		break;
	case 1081:
		hd_write_reg(P_HHI_HDMI_PLL_CNTL, 0x5800025a);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL2, 0x00000000);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL3, 0x0d5c5091);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL4, 0x801da72c);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL5, 0x71486980);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL6, 0x00000e55);
		hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL, 0x4, 28, 3);
		WAIT_FOR_PLL_LOCKED(P_HHI_HDMI_PLL_CNTL);
		break;
	case 1080:
		hd_write_reg(P_HHI_HDMI_PLL_CNTL, 0x5800025a);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL2, 0x00000000);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL3, 0x0d5c5091);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL4, 0x801da72c);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL5, 0x71486980);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL6, 0x00000e55);
		hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL, 0x4, 28, 3);
		WAIT_FOR_PLL_LOCKED(P_HHI_HDMI_PLL_CNTL);
		break;
	case 1067:
		hd_write_reg(P_HHI_HDMI_PLL_CNTL, 0x58000258);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL2, 0x00000000);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL3, 0x0d5c5091);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL4, 0x801da72c);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL5, 0x71486980);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL6, 0x00000e55);
		hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL, 0x4, 28, 3);
		WAIT_FOR_PLL_LOCKED(P_HHI_HDMI_PLL_CNTL);
		break;
	case 854:
		hd_write_reg(P_HHI_HDMI_PLL_CNTL, 0x58000247);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL2, 0x00000000);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL3, 0x0d5c5091);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL4, 0x801da72c);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL5, 0x71486980);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL6, 0x00000e55);
		hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL, 0x4, 28, 3);
		WAIT_FOR_PLL_LOCKED(P_HHI_HDMI_PLL_CNTL);
		break;
	case 711:
		hd_write_reg(P_HHI_HDMI_PLL_CNTL, 0x58000276);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL2, 0x00000000);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL3, 0x0d5c5091);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL4, 0x801da72c);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL5, 0x71486980);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL6, 0x00000e55);
		hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL, 0x4, 28, 3);
		WAIT_FOR_PLL_LOCKED(P_HHI_HDMI_PLL_CNTL);
		break;
	case 650:
		hd_write_reg(P_HHI_HDMI_PLL_CNTL, 0x5800026c);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL2, 0x00000000);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL3, 0x0d5c5091);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL4, 0x801da72c);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL5, 0x71486980);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL6, 0x00000e55);
		hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL, 0x4, 28, 3);
		WAIT_FOR_PLL_LOCKED(P_HHI_HDMI_PLL_CNTL);
		break;
	case 490:
		hd_write_reg(P_HHI_HDMI_PLL_CNTL, 0x58000251);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL2, 0x00000000);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL3, 0x0d5c5091);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL4, 0x801da72c);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL5, 0x71486980);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL6, 0x00000e55);
		hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL, 0x4, 28, 3);
		WAIT_FOR_PLL_LOCKED(P_HHI_HDMI_PLL_CNTL);
		break;
	case 398:
		hd_write_reg(P_HHI_HDMI_PLL_CNTL, 0x58000242);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL2, 0x00000000);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL3, 0x0d5c5091);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL4, 0x801da72c);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL5, 0x71486980);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL6, 0x00000e55);
		hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL, 0x4, 28, 3);
		WAIT_FOR_PLL_LOCKED(P_HHI_HDMI_PLL_CNTL);
		break;
	case 297:
		hd_write_reg(P_HHI_HDMI_PLL_CNTL, 0x58000263);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL2, 0x00000000);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL3, 0x0d5c5091);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL4, 0x801da72c);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL5, 0x71486980);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL6, 0x00000e55);
		hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL, 0x4, 28, 3);
		WAIT_FOR_PLL_LOCKED(P_HHI_HDMI_PLL_CNTL);
		break;
	case 252:
		hd_write_reg(P_HHI_HDMI_PLL_CNTL, 0x58000254);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL2, 0x00000000);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL3, 0x0d5c5091);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL4, 0x801da72c);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL5, 0x71486980);
		hd_write_reg(P_HHI_HDMI_PLL_CNTL6, 0x00000e55);
		hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL, 0x4, 28, 3);
		WAIT_FOR_PLL_LOCKED(P_HHI_HDMI_PLL_CNTL);
		break;
	default:
		printk("error hpll clk: %d\n", clk);
		break;
	}
	// printk("config HPLL done\n");
}

static void set_hpll_od1(unsigned div)
{
    switch (div) {
    case 1:
        hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL2, 0, 16, 2);
        break;
    case 2:
        hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL2, 1, 16, 2);
        break;
    case 4:
        hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL2, 2, 16, 2);
        break;
    case 8:
        hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL2, 3, 16, 2);
        break;
    default:
        break;
    }
}

static void set_hpll_od2(unsigned div)
{
    switch (div) {
    case 1:
        hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL2, 0, 22, 2);
        break;
    case 2:
        hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL2, 1, 22, 2);
        break;
    case 4:
        hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL2, 2, 22, 2);
        break;
    case 8:
        hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL2, 3, 22, 2);
        break;
    default:
        break;
    }
}

static void set_hpll_od3(unsigned div)
{
    switch (div) {
    case 1:
        hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL2, 0, 18, 2);
        break;
    case 2:
        hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL2, 1, 18, 2);
        break;
    case 4:
        hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL2, 2, 18, 2);
        break;
    case 8:
        hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL2, 3, 18, 2);
        break;
    default:
        break;
    }
}

// --------------------------------------------------
//              clocks_set_vid_clk_div
// --------------------------------------------------
// wire            clk_final_en    = control[19];
// wire            clk_div1        = control[18];
// wire    [1:0]   clk_sel         = control[17:16];
// wire            set_preset      = control[15];
// wire    [14:0]  shift_preset    = control[14:0];
static void set_hpll_od3_clk_div(int div_sel)
{
    int shift_val = 0;
    int shift_sel = 0;

    // printk("%s[%d] div = %d\n", __func__, __LINE__, div_sel);
    // Disable the output clock
    hd_set_reg_bits(P_HHI_VID_PLL_CLK_DIV, 0, 19, 1);
    hd_set_reg_bits(P_HHI_VID_PLL_CLK_DIV, 0, 15, 1);

    switch (div_sel) {
    case CLK_UTIL_VID_PLL_DIV_1:      shift_val = 0xFFFF; shift_sel = 0; break;
    case CLK_UTIL_VID_PLL_DIV_2:      shift_val = 0x0aaa; shift_sel = 0; break;
    case CLK_UTIL_VID_PLL_DIV_3:      shift_val = 0x0db6; shift_sel = 0; break;
    case CLK_UTIL_VID_PLL_DIV_3p5:    shift_val = 0x36cc; shift_sel = 1; break;
    case CLK_UTIL_VID_PLL_DIV_3p75:   shift_val = 0x6666; shift_sel = 2; break;
    case CLK_UTIL_VID_PLL_DIV_4:      shift_val = 0x0ccc; shift_sel = 0; break;
    case CLK_UTIL_VID_PLL_DIV_5:      shift_val = 0x739c; shift_sel = 2; break;
    case CLK_UTIL_VID_PLL_DIV_6:      shift_val = 0x0e38; shift_sel = 0; break;
    case CLK_UTIL_VID_PLL_DIV_6p25:   shift_val = 0x0000; shift_sel = 3; break;
    case CLK_UTIL_VID_PLL_DIV_7:      shift_val = 0x3c78; shift_sel = 1; break;
    case CLK_UTIL_VID_PLL_DIV_7p5:    shift_val = 0x78f0; shift_sel = 2; break;
    case CLK_UTIL_VID_PLL_DIV_12:     shift_val = 0x0fc0; shift_sel = 0; break;
    case CLK_UTIL_VID_PLL_DIV_14:     shift_val = 0x3f80; shift_sel = 1; break;
    case CLK_UTIL_VID_PLL_DIV_15:     shift_val = 0x7f80; shift_sel = 2; break;
    case CLK_UTIL_VID_PLL_DIV_2p5:    shift_val = 0x5294; shift_sel = 2; break;
    default:
        printk("Error: clocks_set_vid_clk_div:  Invalid parameter\n");
        break;
    }

    if (shift_val == 0xffff ) {      // if divide by 1
        hd_set_reg_bits(P_HHI_VID_PLL_CLK_DIV, 1, 18, 1);
    } else {
        hd_set_reg_bits(P_HHI_VID_PLL_CLK_DIV, 0, 16, 2);
        hd_set_reg_bits(P_HHI_VID_PLL_CLK_DIV, 0, 15, 1);
        hd_set_reg_bits(P_HHI_VID_PLL_CLK_DIV, 0, 0, 14);

        hd_set_reg_bits(P_HHI_VID_PLL_CLK_DIV, shift_sel, 16, 2);
        hd_set_reg_bits(P_HHI_VID_PLL_CLK_DIV, 1, 15, 1);
        hd_set_reg_bits(P_HHI_VID_PLL_CLK_DIV, shift_val, 0, 14);
        hd_set_reg_bits(P_HHI_VID_PLL_CLK_DIV, 0, 15, 1);
    }
    // Enable the final output clock
    hd_set_reg_bits(P_HHI_VID_PLL_CLK_DIV, 1, 19, 1);
}

static void set_vid_clk_div(unsigned div)
{
    check_clk_config(div);
    if (div == 0)
        div = 1;
    hd_set_reg_bits(P_HHI_VID_CLK_CNTL, 0, 16, 3);   // select vid_pll_clk
    hd_set_reg_bits(P_HHI_VID_CLK_DIV, div-1, 0, 8);
    hd_set_reg_bits(P_HHI_VID_CLK_CNTL, 7, 0, 3);
}

static void set_hdmi_tx_pixel_div(unsigned div)
{
    check_div();
    hd_set_reg_bits(P_HHI_HDMI_CLK_CNTL, div, 16, 4);
    hd_set_reg_bits(P_HHI_VID_CLK_CNTL2, 1, 5, 1);   //enable gate
}
static void set_encp_div(unsigned div)
{
    check_div();
    hd_set_reg_bits(P_HHI_VID_CLK_DIV, div, 24, 4);
    hd_set_reg_bits(P_HHI_VID_CLK_CNTL2, 1, 2, 1);   //enable gate
	hd_set_reg_bits(P_HHI_VID_CLK_CNTL, 1, 19, 1);
}

static void set_enci_div(unsigned div)
{
    check_div();
    hd_set_reg_bits(P_HHI_VID_CLK_DIV, div, 28, 4);
    hd_set_reg_bits(P_HHI_VID_CLK_CNTL2, 1, 0, 1);   //enable gate
}

// mode viu_path viu_type hpll_clk_out od1 od2 od3
// vid_pll_div vid_clk_div hdmi_tx_pixel_div encp_div enci_div
static hw_enc_clk_val_t setting_enc_clk_val[] = {
    {HDMI_720x480i60_16x9, 1, VIU_ENCI, 4320, 4, 4, 1, CLK_UTIL_VID_PLL_DIV_5, 1, 2, -1, 2},
    {HDMI_720x576i50_16x9, 1, VIU_ENCI, 4320, 4, 4, 1, CLK_UTIL_VID_PLL_DIV_5, 1, 2, -1, 2},
    {HDMI_720x576p50_16x9, 1, VIU_ENCP, 4320, 4, 4, 1, CLK_UTIL_VID_PLL_DIV_5, 1, 2, 1, -1},
    {HDMI_720x480p60_16x9, 1, VIU_ENCP, 4320, 4, 4, 1, CLK_UTIL_VID_PLL_DIV_5, 1, 2, 1, -1},
    {HDMI_1280x720p50_16x9, 1, VIU_ENCP, 2970, 4, 1, 1, CLK_UTIL_VID_PLL_DIV_5, 1, 2, 1, -1},
    {HDMI_1280x720p60_16x9, 1, VIU_ENCP, 2970, 4, 1, 1, CLK_UTIL_VID_PLL_DIV_5, 1, 2, 1, -1},
    {HDMI_1920x1080i60_16x9, 1, VIU_ENCP, 2970, 4, 1, 1, CLK_UTIL_VID_PLL_DIV_5, 1, 2, 1, -1},
    {HDMI_1920x1080i50_16x9, 1, VIU_ENCP, 2970, 4, 1, 1, CLK_UTIL_VID_PLL_DIV_5, 1, 2, 1, -1},
    {HDMI_1920x1080p60_16x9, 1, VIU_ENCP, 2970, 1, 2, 2, CLK_UTIL_VID_PLL_DIV_5, 1, 1, 1, -1},
    {HDMI_1920x1080p50_16x9, 1, VIU_ENCP, 2970, 1, 2, 2, CLK_UTIL_VID_PLL_DIV_5, 1, 1, 1, -1},
    {HDMI_1920x1080p24_16x9, 1, VIU_ENCP, 2970, 2, 2, 2, CLK_UTIL_VID_PLL_DIV_5, 1, 1, 1, -1},
    {HDMI_3840x2160p30_16x9, 1, VIU_ENCP, 2970, 1, 1, 1, CLK_UTIL_VID_PLL_DIV_5, 2, 1, 1, -1},
    {HDMI_3840x2160p25_16x9, 1, VIU_ENCP, 2970, 1, 1, 1, CLK_UTIL_VID_PLL_DIV_5, 2, 1, 1, -1},
    {HDMI_3840x2160p24_16x9, 1, VIU_ENCP, 2970, 1, 1, 1, CLK_UTIL_VID_PLL_DIV_5, 2, 1, 1, -1},
    {HDMI_4096x2160p24_256x135, 1, VIU_ENCP, 2970, 1, 1, 1, CLK_UTIL_VID_PLL_DIV_5, 2, 1, 1, -1},
    {HDMI_3840x2160p60_16x9, 1, VIU_ENCP, 5940, 1, 1, 2, CLK_UTIL_VID_PLL_DIV_5, 1, 1, 1, -1},
    {HDMI_3840x2160p50_16x9, 1, VIU_ENCP, 5940, 1, 1, 2, CLK_UTIL_VID_PLL_DIV_5, 1, 1, 1, -1},
    /* VESA */
    {HDMI_1024x600p60_17x10, 1, VIU_ENCP, 490, 4, 2, 2, CLK_UTIL_VID_PLL_DIV_5, 1, 1, 1, -1},
    {HDMI_800x480p60_5x3, 1, VIU_ENCP, 297, 4, 4, 2, CLK_UTIL_VID_PLL_DIV_5, 1, 1, 1, -1},
    {HDMI_3440x1440p60_43x18, 1, VIU_ENCP, 3197, 1, 1, 2, CLK_UTIL_VID_PLL_DIV_5, 1, 1, 1, -1},
    {HDMI_2560x1600p60_8x5, 1, VIU_ENCP, 2685, 2, 1, 2, CLK_UTIL_VID_PLL_DIV_5, 1, 1, 1, -1},
    {HDMI_2560x1440p60_16x9, 1, VIU_ENCP, 2415, 2, 1, 2, CLK_UTIL_VID_PLL_DIV_5, 1, 1, 1, -1},
    {HDMI_2560x1080p60_64x27, 1, VIU_ENCP, 1855, 2, 1, 2, CLK_UTIL_VID_PLL_DIV_5, 1, 1, 1, -1},
    {HDMI_1920x1200p60_8x5, 1, VIU_ENCP, 1540, 2, 1, 2, CLK_UTIL_VID_PLL_DIV_5, 1, 1, 1, -1},
    {HDMI_1680x1050p60_8x5, 1, VIU_ENCP, 1463, 2, 2, 2, CLK_UTIL_VID_PLL_DIV_5, 1, 1, 1, -1},
    {HDMI_1600x900p60_16x9, 1, VIU_ENCP, 1080, 2, 2, 2, CLK_UTIL_VID_PLL_DIV_5, 1, 1, 1, -1},
    {HDMI_1440x900p60_8x5, 1, VIU_ENCP, 1067, 2, 2, 2, CLK_UTIL_VID_PLL_DIV_5, 1, 1, 1, -1},
    {HDMI_1280x1024p60_5x4, 1, VIU_ENCP, 1081, 2, 2, 2, CLK_UTIL_VID_PLL_DIV_5, 1, 1, 1, -1},
    {HDMI_1280x800p60_8x5, 1, VIU_ENCP, 711, 4, 2, 2, CLK_UTIL_VID_PLL_DIV_5, 1, 1, 1, -1},
    {HDMI_1024x768p60_4x3, 1, VIU_ENCP, 650, 4, 2, 2, CLK_UTIL_VID_PLL_DIV_5, 1, 1, 1, -1},
    {HDMI_800x600p60_4x3, 1, VIU_ENCP, 398, 4, 2, 2, CLK_UTIL_VID_PLL_DIV_5, 1, 1, 1, -1},
    {HDMI_640x480p60_4x3, 1, VIU_ENCP, 252, 4, 2, 2, CLK_UTIL_VID_PLL_DIV_5, 1, 1, 1, -1},
};

void set_hdmitx_clk(enum hdmi_vic vic)
{
    int i = 0;
    int j = 0;
    hw_enc_clk_val_t *p_enc =NULL;

    p_enc=&setting_enc_clk_val[0];
    i = sizeof(setting_enc_clk_val) / sizeof(hw_enc_clk_val_t);

    for (j = 0; j < i; j++) {
        if (vic == p_enc[j].vic)
            break;
    }
	if (j == i) {
		printf("Not find VIC = %d for hpll setting\n", vic);
		return;
	}
    set_viu_path(p_enc[j].viu_path, p_enc[j].viu_type);
    set_hdmitx_sys_clk();
    set_hpll_clk_out(p_enc[j].hpll_clk_out);
    set_hpll_od1(p_enc[j].od1);
    set_hpll_od2(p_enc[j].od2);
    set_hpll_od3(p_enc[j].od3);
    set_hpll_od3_clk_div(p_enc[j].vid_pll_div);
	// printk("j = %d  vid_clk_div = %d\n", j, p_enc[j].vid_clk_div);
    set_vid_clk_div(p_enc[j].vid_clk_div);
    set_hdmi_tx_pixel_div(p_enc[j].hdmi_tx_pixel_div);
    set_encp_div(p_enc[j].encp_div);
    set_enci_div(p_enc[j].enci_div);
}

void set_hdmitx_clk_420(void)
{
	/* HPLL VCO output 5.94GHz */
	printf("reset clk for 420 mode\n");
	hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL2, 1, 16, 2);
	hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL2, 0, 22, 2);
	hd_set_reg_bits(P_HHI_HDMI_PLL_CNTL2, 0, 18, 2);
	hd_set_reg_bits(P_HHI_VID_CLK_CNTL, 1, 1, 1);
	hd_set_reg_bits(P_HHI_HDMI_CLK_CNTL, 1, 16, 4);
}
