
#include <config.h>
#include <asm/arch/register.h>
#include <asm/arch/io.h>

#include <asm/arch/dsp_state.h>
#include "dsp_firmware.dat"

#define S_1K					(1024)
#define S_1M					(S_1K*S_1K)
//#define S_1M					(64*S_1K)

#define AUDIO_DSP_MEM_SIZE		 S_1M
#define AUDIO_DSP_START_PHY_ADDR 0xa6000000
//#define AUDIO_DSP_START_PHY_ADDR 0xd9000000
#define AUDIO_DSP_START_ADDR	AUDIO_DSP_START_PHY_ADDR//((SYS_MEM_START+SYS_MEM_SIZE)-AUDIO_DSP_MEM_SIZE)
#define AUDIO_DSP_END_ADDR		((AUDIO_DSP_START_ADDR+AUDIO_DSP_MEM_SIZE))
#define REG_MEM_SIZE					(S_1K*4)




#define DSP_REG_OFFSET	(AUDIO_DSP_START_ADDR+ AUDIO_DSP_MEM_SIZE-REG_MEM_SIZE)
#define DSP_REG_END			(AUDIO_DSP_START_ADDR+ AUDIO_DSP_MEM_SIZE-4)
#define DSP_REG(x)			(DSP_REG_OFFSET | ((x)<<5))

#define DSP_ARM_REF_CLK_VAL                DSP_REG(16)

#define DSP_WD(reg,val)	({(*((volatile unsigned long *)(reg)))=val;})


#define DSP_MEM_START  		DSP_REG(7)
#define DSP_MEM_END 	 		DSP_REG(8)

#define DSP_STATUS				DSP_REG(0)
#define DSP_STACK_START   DSP_REG(3)
#define DSP_STACK_END   	DSP_REG(4)
#define DSP_GP_STACK_START   DSP_REG(5)
#define DSP_GP_STACK_END   	DSP_REG(6)

#define DSP_STATUS_HALT		('H'<<24 | 'a'<<16|'l'<<8 |'t')


static int dsp_start=0;

int start_dsp()
{
	unsigned long clk;

	if(dsp_start)
		return 0;
//#ifdef M3_DSP_VSYNC_INTERRUPT
	memcpy((void *)AUDIO_DSP_START_PHY_ADDR,dsp_firmware_code,sizeof(dsp_firmware_code));
	

//#else
	//memcpy((void *)AUDIO_DSP_START_PHY_ADDR,dsp_firmware,sizeof(dsp_firmware));
//#endif
	clk=READ_CBUS_REG_BITS(PREG_CTLREG0_ADDR,4,5);
	clk=clk*1000*1000;
	DSP_WD(DSP_MEM_START,0xa7020000);
	DSP_WD(DSP_MEM_END,0xa7120000);

	DSP_WD(DSP_STACK_START,0xa7000000);
	DSP_WD(DSP_STACK_END,0xa7010000);

	DSP_WD(DSP_GP_STACK_START,0xa7010000);
	DSP_WD(DSP_GP_STACK_END,0xa7020000);

#if 0	
    	CLEAR_MPEG_REG_MASK(AUD_ARC_CTL, (0xfff << 4));
 //   SET_MPEG_REG_MASK(SDRAM_CTL0,1);//arc mapping to ddr memory
    	SET_MPEG_REG_MASK(AUD_ARC_CTL, ((AUDIO_DSP_START_PHY_ADDR)>> 20) << 4);
	
	SET_MPEG_REG_MASK(AUD_ARC_CTL, 1);
	CLEAR_MPEG_REG_MASK(AUD_ARC_CTL, 1);
#endif
#if 1 //off ddr test 
    	CLEAR_MPEG_REG_MASK(MEDIA_CPU_CTL, (0xfff << 4));
 //   SET_MPEG_REG_MASK(SDRAM_CTL0,1);//arc mapping to ddr memory
    	SET_MPEG_REG_MASK(MEDIA_CPU_CTL, ((AUDIO_DSP_START_PHY_ADDR)>> 20) << 4);

	//SET_MPEG_REG_MASK(SDRAM_CTL0, 1);
#else
	unsigned int vaddr2 = AUDIO_DSP_START_PHY_ADDR;
	unsigned int v;
	v = ((vaddr2 & 0xFFFFF)>>12);
	
	__raw_writel((0x1<<4) | ((vaddr2>>14)&0xf),P_AO_REMAP_REG1);
	__raw_writel(v<<8 | 1,0xDA004000);
	printf(" %x ,  *(int*)0xDA004000 0:0x%x\n",v<<8 | 1,*(int*)0xDA004000);
	printf(" %x ,  *(int*)P_AO_REMAP_REG1 0:0x%x\n",(0x1<<4) | ((vaddr2>>14)&0xf),*(int*)P_AO_REMAP_REG1);
	printf("cbus 4154: 0x%x \n",*(unsigned int*)0xc1104154);
#endif
	
	flush_cache(0x80000000, 0x40000000);

	SET_MPEG_REG_MASK(RESET2_REGISTER, RESET_ARC625);
	//WRITE_MPEG_REG(RESET2_REGISTER,RESET_ARC625);
	
	SET_MPEG_REG_MASK(MEDIA_CPU_CTL, 1);
	//WRITE_MPEG_REG(MEDIA_CPU_CTL, 1);
//	printf("MEDIA_CPU_CTL 0:0x%x\n",*(int*)0xc1109964);
	CLEAR_MPEG_REG_MASK(MEDIA_CPU_CTL, 1);
	//WRITE_MPEG_REG(MEDIA_CPU_CTL,0);

//	printf("MEDIA_CPU_CTL 1:0x%x\n",*(int*)0xc1109964);


#if 0
#define RESET_AUD_ARC	(1<<13)
 SET_MPEG_REG_MASK(RESET2_REGISTER, RESET_AUD_ARC);
 SET_MPEG_REG_MASK(RESET2_REGISTER, RESET_AUD_ARC);
  SET_MPEG_REG_MASK(RESET2_REGISTER, RESET_AUD_ARC);
#endif  
		    //clk=clk_get_sys("a9_clk", NULL);
	DSP_WD(DSP_ARM_REF_CLK_VAL, clk);
	//flush_cache(0x84000000, S_1M);
	write_reg(P_AO_RTI_STATUS_REG0, DSP_REQUST_START);
	printf("starting dsp...\n");
	dsp_start=1;
	return 0;
}

int stop_dsp()
{
	if(!dsp_start)
		return 0;
	//CLEAR_MPEG_REG_MASK(AUD_ARC_CTL, 1);
	CLEAR_MPEG_REG_MASK(MEDIA_CPU_CTL, 1);
#define RESET_AUD_ARC	(1<<13)
	SET_MPEG_REG_MASK(RESET2_REGISTER, RESET_AUD_ARC);
	DSP_WD(DSP_STATUS, DSP_STATUS_HALT);
	dsp_start=0;
	return 0;
}



