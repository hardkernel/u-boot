#ifndef AM_REGISTER_H
#define  AM_REGISTER_H

#include <asm/io.h>
/* as m6 has different audioin  base addr as the a3,m1~m3 */
#ifdef __MESON6__
#define REG_OFFSET  0
#else
#define REG_OFFSET  (-(0x600<<2))
#endif
#define MREG_AIU_MEM_IEC958_START_PTR   (0xc1100000+(0x1565<<2))
#define MREG_AIU_MEM_IEC958_RD_PTR      (0xc1100000+(0x1566<<2))
#define MREG_AIU_MEM_IEC958_END_PTR     (0xc1100000+(0x1567<<2))

#define MREG_AIU_MEM_I2S_START_PTR      (0xc1100000+(0x1560<<2))
#define MREG_AIU_MEM_I2S_RD_PTR         (0xc1100000+(0x1561<<2))
#define MREG_AIU_MEM_I2S_END_PTR        (0xc1100000+(0x1562<<2))

#define AUDIN_FIFO0_START               (0xc1100000+(0x2820<<2)+REG_OFFSET)
#define AUDIN_FIFO0_END                 (0xc1100000+(0x2821<<2)+REG_OFFSET)
#define AUDIN_FIFO0_PTR                 (0xc1100000+(0x2822<<2)+REG_OFFSET)
#define AUDIN_FIFO0_INTR                (0xc1100000+(0x2823<<2)+REG_OFFSET)
#define AUDIN_FIFO0_RDPTR               (0xc1100000+(0x2824<<2)+REG_OFFSET)
#define AUDIN_FIFO0_CTRL                (0xc1100000+(0x2825<<2)+REG_OFFSET)

#define AUDIN_I2SIN_CTRL                (0xc1100000+(0x2810<<2)+REG_OFFSET)
    #define I2SIN_DIR       0    // I2S CLK and LRCLK direction. 0 : input 1 : output.
    #define I2SIN_CLK_SEL    1    // I2S clk selection : 0 : from pad input. 1 : from AIU.
    #define I2SIN_LRCLK_SEL 2
    #define I2SIN_POS_SYNC  3
    #define I2SIN_LRCLK_SKEW 4    // 6:4
    #define I2SIN_LRCLK_INVT 7
    #define I2SIN_SIZE       8    //9:8 : 0 16 bit. 1 : 18 bits 2 : 20 bits 3 : 24bits.
    #define I2SIN_CHAN_EN   10    //13:10. 
    #define I2SIN_EN        15
    
#define MREG_AIU_MEM_I2S_CONTROL        (0xc1100000+(0x1564<<2))
#define MREG_AIU_MEM_IEC958_CONTROL     (0xc1100000+(0x1569<<2))

#define MREG_AIU_AIFIFO_STATUS          (0xc1100000+(0x1581<<2))
#define MREG_AIU_AIFIFO_GBIT            (0xc1100000+(0x1582<<2))
#define AIU_MEM_AIFIFO_BYTES_AVAIL      (0xc1100000+(0x1587<<2))
#define AIU_MEM_AIFIFO_CONTROL          (0xc1100000+(0x1588<<2))
#define AIU_MEM_AIFIFO_MAN_WP           (0xc1100000+(0x1589<<2))
#define AIU_MEM_AIFIFO_MAN_RP           (0xc1100000+(0x158a<<2))
#define AIU_MEM_AIFIFO_LEVEL            (0xc1100000+(0x158b<<2))

#define MREG_AIU_958_bpf                (0xc1100000+(0x1500<<2))
#define MREG_AIU_958_brst               (0xc1100000+(0x1501<<2))
#define MREG_AIU_958_length             (0xc1100000+(0x1502<<2))
#define MREG_AIU_958_paddsize           (0xc1100000+(0x1503<<2))

#define ASSIST_HW_REV                   (0xc1100000+(0x1f53<<2))

// TODO
// M6 has different value
#define HHI_AUD_PLL_MOD_LOW_TCNT        (0xc1100000+(0x1081<<2))
#define HHI_AUD_PLL_MOD_NOM_TCNT        (0xc1100000+(0x1083<<2))
#define HHI_AUD_PLL_MOD_HIGH_TCNT       (0xc1100000+(0x1082<<2))  
#define HHI_AUD_PLL_CNTL                (0xc1100000+(0x105b<<2))
#define HHI_AUD_CLK_CNTL                (0xc1100000+(0x105e<<2))
#define HHI_AUD_PLL_MOD_CNTL0           (0xc1100000+(0x1080<<2))

#define MREG_AIU_958_force_left         (0xc1100000+(0x1505<<2))
#define MREG_AIU_958_dcu_ff_ctrl        (0xc1100000+(0x1507<<2))
#define MREG_AIU_MEM_IEC958_CONTROL     (0xc1100000+(0x1569<<2))

#ifdef __MESON6__
#define ASSIST_MBOX1_IRQ_REG            (0xc8010000+(0x0074<<2))
#define ASSIST_MBOX1_CLR_REG            (0xc8010000+(0x0075<<2))
#define ASSIST_MBOX1_MASK               (0xc8010000+(0x0076<<2))
#define ASSIST_MBOX1_FIQ_SEL            (0xc8010000+(0x0077<<2))

#define ASSIST_MBOX2_IRQ_REG            (0xc8010000+(0x0078<<2))
#define ASSIST_MBOX2_CLR_REG            (0xc8010000+(0x0079<<2))
#define ASSIST_MBOX2_MASK               (0xc8010000+(0x007a<<2))
#define ASSIST_MBOX2_FIQ_SEL            (0xc8010000+(0x007b<<2))
#else
#define ASSIST_MBOX1_IRQ_REG            (0xc1100000+(0x1f74<<2))
#define ASSIST_MBOX1_CLR_REG            (0xc1100000+(0x1f75<<2))
#define ASSIST_MBOX1_MASK               (0xc1100000+(0x1f76<<2))
#define ASSIST_MBOX1_FIQ_SEL            (0xc1100000+(0x1f77<<2))

#define ASSIST_MBOX2_IRQ_REG            (0xc1100000+(0x1f78<<2))
#define ASSIST_MBOX2_CLR_REG            (0xc1100000+(0x1f79<<2))
#define ASSIST_MBOX2_MASK               (0xc1100000+(0x1f7a<<2))
#define ASSIST_MBOX2_FIQ_SEL            (0xc1100000+(0x1f7b<<2))
#endif

    #define IRQ2_MAILBOX2_INTA	(1L<<13)
    #define IRQ2_MAILBOX1_INTA	(1L<<12)
    #define IRQ2_MAILBOX0_INTA	(1L<<11)
    #define IRQ2_MAILBOX2_INTB	(1L<<10)
    #define IRQ2_MAILBOX1_INTB	(1L<<9)
    #define IRQ2_MAILBOX0_INTB	(1L<<8)
    
#define IREG_ARC1_GEN_IRQ_CLEAR1      (0xc1100000+(0x2635<<2))
    
#define IREG_TIMER_BASE               (0xc1100000+(0x2650<<2))
#define IREG_TIMER_E_COUNT            (0xc1100000+(0x2655<<2))

#define IREG_ARC2_GEN_IRQ_STATUS0     (0xc1100000+(0x2610<<2))
#define IREG_ARC2_GEN_IRQ_CLEAR0      (0xc1100000+(0x2611<<2))
#define IREG_ARC2_GEN_IRQ_MASK0       (0xc1100000+(0x2612<<2))
#define IREG_ARC2_GEN_FIRQ_MASK0      (0xc1100000+(0x2613<<2))
#define IREG_ARC2_GEN_IRQ_STATUS1     (0xc1100000+(0x2614<<2))
#define IREG_ARC2_GEN_IRQ_CLEAR1      (0xc1100000+(0x2615<<2))
#define IREG_ARC2_GEN_IRQ_MASK1       (0xc1100000+(0x2616<<2))
#define IREG_ARC2_GEN_FIRQ_MASK1      (0xc1100000+(0x2617<<2))

	#define VIU2_VSYNC_INT	(1<<13)
	#define VIU2_HSYNC_INT	(1<<12)
	#define VIU1_VSYNC_INT	(1<<3)
	#define VIU1_HSYNC_INT	(1<<2)


	#define DSP_VIU1_HSYNC  2
	#define DSP_VIU1_VSYNC  3
	#define DSP_VIU2_HSYNC  12
	#define DSP_VIU2_VSYNC  13


#define READ_MPEG_REG(reg)              IO_READ32((reg))
#define WRITE_MPEG_REG(reg,val)         IO_WRITE32((val), (reg))
#define READ_ISA_REG                    READ_MPEG_REG
#define WRITE_ISA_REG                   WRITE_MPEG_REG
#define READ_PERI_REG                   READ_MPEG_REG
#define WRITE_PERI_REG                  WRITE_MPEG_REG


#define WRITE_MPEG_REG_BITS(reg, val, start, len) \
    WRITE_MPEG_REG(reg,	(READ_MPEG_REG(reg) & ~(((1L<<(len))-1)<<(start)) )| ((unsigned)((val)&((1L<<(len))-1)) << (start)))
#define READ_MPEG_REG_BITS(reg, start, len) \
    ((READ_MPEG_REG(reg) >> (start)) & ((1L<<(len))-1))
    
#define CLEAR_MPEG_REG_MASK(reg, mask) WRITE_MPEG_REG(reg, (READ_MPEG_REG(reg)&(~(mask))))
#define SET_MPEG_REG_MASK(reg, mask)   WRITE_MPEG_REG(reg, (READ_MPEG_REG(reg)|(mask)))
#define CLEAR_ISA_REG_MASK        CLEAR_MPEG_REG_MASK
#define SET_ISA_REG_MASK          SET_MPEG_REG_MASK
  
#define read_arc2_irq_status()                       \
    READ_ISA_REG(IREG_ARC2_GEN_IRQ_STATUS0)
#define read_arc2_irq_status1()                       \
    READ_ISA_REG(IREG_ARC2_GEN_IRQ_STATUS1)
#define clear_arc2_irq_status(mask)                  \
    WRITE_ISA_REG(IREG_ARC2_GEN_IRQ_CLEAR0, mask)
#define clear_arc2_irq_status1(mask)                  \
    WRITE_ISA_REG(IREG_ARC2_GEN_IRQ_CLEAR1, mask)
#define clear_arc2_irq_mask(mask)                    \
    CLEAR_ISA_REG_MASK(IREG_ARC2_GEN_IRQ_MASK0, mask)
#define clear_arc2_irq_mask1(mask)                    \
    CLEAR_ISA_REG_MASK(IREG_ARC2_GEN_IRQ_MASK1, mask)
#define set_arc2_irq_mask(mask)                      \
    SET_ISA_REG_MASK(IREG_ARC2_GEN_IRQ_MASK0, mask)
#define set_arc2_irq_mask1(mask)                      \
    SET_ISA_REG_MASK(IREG_ARC2_GEN_IRQ_MASK1, mask)
            
#endif

