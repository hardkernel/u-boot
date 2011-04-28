

#include <asm/cache.h>
#include <asm/arcregs.h>
#include <asm/dsp_register.h>
#include <asm/system.h>
#include <asm/io.h>
#if 0
#include <codec/codec.h>
#include <core/dsp.h>
#endif
#include <core/dsp_mailbox.h>

#define HALT_IRQ_MAGIC	0x87644232
int halt_system_handle(int num,unsigned long args)
{
#if 0
	if(num==0 && args==HALT_IRQ_MAGIC)
	{
			printk("audio dsp halted now\n");
            if(((DSP_RD(DSP_DECODE_OPTION)>>31)&1) == 1){
              // digital raw output enabled
              WRITE_MPEG_REG(MREG_AIU_958_dcu_ff_ctrl, READ_MPEG_REG(MREG_AIU_958_dcu_ff_ctrl)&0x70);
              WRITE_MPEG_REG_BITS(MREG_AIU_MEM_IEC958_CONTROL, 0, 1, 2);
            }           
			dsp_flush_printk_data();
			DSP_WD(DSP_STATUS,DSP_STATUS_HALT);
			arch_halt();
	}
#endif
	return 0;
}

void test_viu1_vsync_int();
void test_viu2_vsync_int();
int dsp_viu1_vsync_handle(int num,unsigned long args)
{
	test_viu1_vsync_int();
	return 0;
}

int dsp_viu2_vsync_handle(int num,unsigned long args)
{
	test_viu2_vsync_int();
	return 0;
}

int dsp_request_int_int0(int num,char *name,mailbox_func_t fn,unsigned long args);

void start_system( void )
{
#if 0
	dsp_request_mailbox(M2B_IRQ0_DSP_HALT,"halt system",halt_system_handle,HALT_IRQ_MAGIC);
	codec_start();
	while(1);
#endif
	//dsp_request_int_int0(DSP_VIU1_VSYNC,"viu1 vsync", dsp_viu1_vsync_handle, 0);
	dsp_request_int_int0(DSP_VIU2_VSYNC,"viu2 vsync", dsp_viu2_vsync_handle, 0);
}


