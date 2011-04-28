
//#include <asm/arch/io.h>
//#include <asm/arch/reg_addr.h>
#include <asm/system.h>
#include <asm/arch/ao_reg.h>
#include <asm/arch/am_regs.h>
#include <asm/dsp_state.h>

void __raw_writel(unsigned val,unsigned reg)
{
	(*((volatile unsigned int*)(reg)))=(val);
	asm(".long 0x003f236f"); //add sync instruction.
}

unsigned __raw_readl(unsigned reg)
{
	asm(".long 0x003f236f"); //add sync instruction.
	return (*((volatile unsigned int*)(reg)));
}

#define writel __raw_writel
#define readl __raw_readl


void dsp_vsync_int();
void test_viu2_vsync_int()
{
	//static int viu2_vsync_count=0x100000;
	//writel(viu2_vsync_count,P_AO_RTI_STATUS_REG1);
	//viu2_vsync_count++;

	dsp_vsync_int();
}

void test_viu1_vsync_int()
{
	//static int viu1_vsync_count=0x800000;
	//writel(viu1_vsync_count,P_AO_RTI_STATUS_REG1);
	//viu1_vsync_count++;
}


void dsp_vsync_int()
{
	unsigned int fb0_cfg_w0,fb1_cfg_w0;
	unsigned int current_filed;
	unsigned  int  scan_line_number = 0;
	
	fb0_cfg_w0=readl(P_VIU_OSD1_BLK0_CFG_W0);
	fb1_cfg_w0=readl(P_VIU_OSD2_BLK0_CFG_W0);
	
#ifdef __M3__
	if(readl(P_ENCP_VIDEO_MODE) & (1 << 12))
	{
		/*1080I*/
		if(readl(P_VENC_INTFLAG) & 0x200){
			current_filed = 0;
		}else{
			current_filed = 1;
		}
	}else{
		if(readl(P_VENC_INTFLAG) & 4){
			current_filed = 0;
		}else{
			current_filed = 1;
		}
	}
#else
//m6
	if(readl(P_ENCP_VIDEO_MODE) & (1 << 12)){
		/*1080I*/
		scan_line_number = ((readl(P_ENCP_INFO_READ))&0x1fff0000)>>16;
		if (scan_line_number >= 562){
			/* bottom field, odd lines*/
			current_filed = 1;
		}
		else{
			/* top field, even lines*/
			current_filed = 0;
		}
	}
	else{
		if(readl(P_ENCI_INFO_READ) & (1<<29)){
			current_filed = 1;
		}
		else{
			current_filed = 0;
		}
	}
#endif

	fb0_cfg_w0 &=~1;
	fb1_cfg_w0 &=~1;
	fb0_cfg_w0 |= current_filed;
	fb1_cfg_w0 |= current_filed;

	writel(fb0_cfg_w0, P_VIU_OSD1_BLK0_CFG_W0);
	writel(fb0_cfg_w0, P_VIU_OSD1_BLK1_CFG_W0);
	writel(fb0_cfg_w0, P_VIU_OSD1_BLK2_CFG_W0);
	writel(fb0_cfg_w0, P_VIU_OSD1_BLK3_CFG_W0);
	writel(fb1_cfg_w0, P_VIU_OSD2_BLK0_CFG_W0);
	writel(fb1_cfg_w0, P_VIU_OSD2_BLK1_CFG_W0);
	writel(fb1_cfg_w0, P_VIU_OSD2_BLK2_CFG_W0);
	writel(fb1_cfg_w0, P_VIU_OSD2_BLK3_CFG_W0);

}

int dsp_main(void)
{
	unsigned int machine;
	unsigned int cout=0;

	writel(DSP_CURRENT_RUN,P_AO_RTI_STATUS_REG0);

	while(1)
	{
		//writel(cout,P_AO_RTI_STATUS_REG2);
		//cout++;

		machine = readl(P_AO_RTI_STATUS_REG0);
		if(machine == DSP_REQUST_STOP)
		{
			clear_arc2_irq_mask(VIU2_VSYNC_INT);
			//clear_arc2_irq_mask(VIU1_VSYNC_INT);
			writel(DSP_CURRENT_SLEEP,P_AO_RTI_STATUS_REG0);
			arch_sleep();
		}
	}
	return 0;
}



