/*
dsp_register.h
*/
#ifndef DSP_REGISTER_H
#define DSP_REGISTER_H

#define SYS_MEM_START	0x80000000
#define SYS_MEM_SIZE	0x8000000

#define S_1K					(1024)
#define S_1M					(S_1K*S_1K)

#define AUDIO_DSP_MEM_SIZE		 S_1M
#ifndef __ARC600__
#define AUDIO_DSP_START_ADDR	((SYS_MEM_START+SYS_MEM_SIZE)-AUDIO_DSP_MEM_SIZE)
#define AUDIO_DSP_END_ADDR		((SYS_MEM_START+SYS_MEM_SIZE))
#else
#define AUDIO_DSP_START_ADDR	0//((SYS_MEM_START+SYS_MEM_SIZE)-AUDIO_DSP_MEM_SIZE)
#define AUDIO_DSP_END_ADDR		AUDIO_DSP_MEM_SIZE//((SYS_MEM_START+SYS_MEM_SIZE))
#endif
#ifdef CACHELINE_64BYTE
#define REG_MEM_DOUBLE 2
#else
#define REG_MEM_DOUBLE 1
#endif
#define REG_MEM_SIZE					(S_1K*4*REG_MEM_DOUBLE)




#define DSP_REG_OFFSET	(AUDIO_DSP_START_ADDR+ AUDIO_DSP_MEM_SIZE-REG_MEM_SIZE)
#define DSP_REG_END			(AUDIO_DSP_START_ADDR+ AUDIO_DSP_MEM_SIZE-4)
#define DSP_REG(x)			(DSP_REG_OFFSET | (((x)<<5)*REG_MEM_DOUBLE))

#define DSP_STATUS				DSP_REG(0)
#define DSP_STATUS_HALT		('H'<<24 | 'a'<<16|'l'<<8 |'t')
#define DSP_STATUS_RUNING		('R'<<16|'u'<<8 |'n')
#define DSP_JIFFIES				DSP_REG(1)
#define DSP_STATUS_SLEEP  ('S'<<24 | 'L'<<16|'E'<<8 |'P')
#define DSP_STATUS_WAKEUP  ('W'<<24 | 'A'<<16|'K'<<8 |'E')
#define DSP_AUDIOINFO_READY ('A'<<24 | 'I'<<16|'R'<<8 |'D')
#define DSP_SLEEP_MAGIC_NUM   0x12345678
#define DSP_STACK_START   DSP_REG(3)
#define DSP_STACK_END   	DSP_REG(4)
#define DSP_GP_STACK_START   DSP_REG(5)
#define DSP_GP_STACK_END   	DSP_REG(6)

#define DSP_MEM_START  		DSP_REG(7)
#define DSP_MEM_END 	 		DSP_REG(8)


#define DSP_DECODE_OUT_START_ADDR  	DSP_REG(9)
#define DSP_DECODE_OUT_END_ADDR   	DSP_REG(10)
#define DSP_DECODE_OUT_RD_ADDR  	  DSP_REG(11)
#define DSP_DECODE_OUT_WD_ADDR  		DSP_REG(12)
#define DSP_AUDIOINFO_STATUS                DSP_REG(13)
#define DSP_SLEEP_STATUS                DSP_REG(14)
//#define TEST_AF
//#define TEST_TIME
#ifdef TEST_TIME
#define DSP_TEST_TIME_VALUE                DSP_REG(15)
#endif
#define DSP_ARM_REF_CLK_VAL                DSP_REG(16)

#define DSP_DECODE_OUT_WD_PTR       DSP_REG(18)
#define DSP_BUFFERED_LEN  		    DSP_REG(19)
#define DSP_AFIFO_RD_OFFSET1  		DSP_REG(20)

// don't release to customer
#define DSP_DECODE_OPTION           DSP_REG(21)
  // 15 - digital raw 
#define DSP_AUDIO_FORMAT_INFO       DSP_REG(22)

#define DSP_GET_EXTRA_INFO_FINISH    DSP_REG(23)
#define DSP_HDMI_SR                  DSP_REG(24)
#if  0
#define DSP_LOG_START_ADDR  	DSP_REG(24)
#define DSP_LOG_END_ADDR   	    DSP_REG(25)
#define DSP_LOG_RD_ADDR  	    DSP_REG(26)
#define DSP_LOG_WD_ADDR  		DSP_REG(27)
#else
#define DSP_LOG_START_ADDR  	DSP_REG(28)
#define DSP_LOG_END_ADDR   	    DSP_REG(29)
#define DSP_LOG_RD_ADDR  	    DSP_REG(30)
#define DSP_LOG_WD_ADDR  		DSP_REG(31)
#endif

#define DSP_DECODE_OUT_FRAME_INFO_FIFO_START_ADDR  	         DSP_REG(31)
#define DSP_DECODE_OUT_FRAME_INFO_FIFO_END_ADDR                     DSP_REG(32)
#define DSP_DECODE_OUT_FRAME_INFO_FIFO_RD_ADDR  	                 DSP_REG(33)
#define DSP_DECODE_OUT_FRAME_INFO_FIFO_WD_ADDR  	                 DSP_REG(34)

#define DSP_DECODE_ES_OFFSET  	                             DSP_REG(35)

#define DSP_APE_FRAME_BUFFER_START  	                     DSP_REG(36)
#define DSP_APE_FRAME_BUFFER_END                             DSP_REG(37)

#define MAILBOX1_REG(n)	DSP_REG(40+n)
#define MAILBOX2_REG(n)	DSP_REG(40+32+n)
//----------------------------------------------
#define DSP_DECODE_51PCM_OUT_START_ADDR  	DSP_REG(106)
#define DSP_DECODE_51PCM_OUT_END_ADDR   	DSP_REG(107)
#define DSP_DECODE_51PCM_OUT_RD_ADDR  	    DSP_REG(108)
#define DSP_DECODE_51PCM_OUT_WD_ADDR  		DSP_REG(109)
//------------------------------------------------
#define DSP_WORK_INFO (AUDIO_DSP_END_ADDR - 128)

#if ((DSP_DECODE_51PCM_OUT_WD_ADDR+32) > DSP_WORK_INFO)
#error  error,the register exceed the range 
#endif



#define M1B_IRQ0_PRINT							(0+16)
#define M1B_IRQ1_BUF_OVERFLOW					(1+16)
#define M1B_IRQ2_BUF_UNDERFLOW				(2+16)
#define M1B_IRQ3_DECODE_ERROR					(3+16)
#define M1B_IRQ4_DECODE_FINISH_FRAME 		(4+16)
#define M1B_IRQ5_STREAM_FMT_CHANGED 			(5+16)
#define M1B_IRQ5_STREAM_RD_WD_TEST 			(6+16)
#define M1B_IRQ7_DECODE_FATAL_ERR			(7+16)
#define M1B_IRQ8_IEC958_INFO                (8+16)  // digital raw info


#define M2B_IRQ0_DSP_HALT						(0)
#define M2B_IRQ1_DSP_RESET						(1)
#define M2B_IRQ2_DECODE_START					(2)
#define M2B_IRQ3_DECODE_STOP					(3)
#define M2B_IRQ4_AUDIO_INFO					(4)
#define M2B_IRQ0_DSP_SLEEP					(5)
#define M2B_IRQ0_DSP_WAKEUP					(6)
#define M2B_IRQ0_DSP_AUDIO_FILTER_CONFIG			(7) //used for the audio filter configuration.srs/eq etc

#define CMD_PRINT_LOG					(1234<<8 |1)

#ifndef __ASSEMBLY__
/*mailbox struct*/
struct mail_msg{
int cmd;
int status;//0x1:pending.0:free
char *data;
int len;
};

#define MDEC_TRIGGER_IRQ(irq)	{SET_MPEG_REG_MASK(ASSIST_MBOX0_FIQ_SEL,1<<irq);\
								WRITE_MPEG_REG(ASSIST_MBOX0_IRQ_REG,1<<irq);}
#define SYS_TRIGGER_IRQ(irq)		{SET_MPEG_REG_MASK(ASSIST_MBOX1_FIQ_SEL,1<<irq); \
								WRITE_MPEG_REG(ASSIST_MBOX1_IRQ_REG,1<<irq);}
#define DSP_TRIGGER_IRQ(irq)		{SET_MPEG_REG_MASK(ASSIST_MBOX2_FIQ_SEL,1<<irq); \
								WRITE_MPEG_REG(ASSIST_MBOX2_IRQ_REG,1<<irq);}
#define MDEC_CLEAR_IRQ(irq)		{CLEAR_MPEG_REG_MASK(ASSIST_MBOX0_FIQ_SEL,1<<irq); \
								WRITE_MPEG_REG(ASSIST_MBOX0_CLR_REG,1<<irq);}

#define SYS_CLEAR_IRQ(irq)		{CLEAR_MPEG_REG_MASK(ASSIST_MBOX1_FIQ_SEL,1<<irq); \
								WRITE_MPEG_REG(ASSIST_MBOX1_CLR_REG,1<<irq);}

#define DSP_CLEAR_IRQ(irq)		{CLEAR_MPEG_REG_MASK(ASSIST_MBOX2_FIQ_SEL,1<<irq); \
								WRITE_MPEG_REG(ASSIST_MBOX2_CLR_REG,1<<irq);}

#define MAIBOX0_IRQ_ENABLE(irq)		SET_MPEG_REG_MASK(ASSIST_MBOX0_MASK,1<<irq)
#define MAIBOX1_IRQ_ENABLE(irq)		SET_MPEG_REG_MASK(ASSIST_MBOX1_MASK,1<<irq)
#define MAIBOX2_IRQ_ENABLE(irq)		SET_MPEG_REG_MASK(ASSIST_MBOX2_MASK,1<<irq)
#endif
#endif

