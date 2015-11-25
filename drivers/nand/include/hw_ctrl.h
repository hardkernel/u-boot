
#ifndef __HW_CTRL_H__
#define __HW_CTRL_H__

#include "amlnf_dev.h"

#ifndef AML_NAND_UBOOT
#include <linux/types.h>
#endif /* AML_NAND_UBOOT */

#define	NF_REG_INDEX		0
#define	EXTCLK_REG_INDEX	1
#define	EXTPORT_REG_INDEX	2

#define RETURN_PAGE_ALL_0XFF	0x01
#define RETURN_PAGE_NEED_READRETRY	0x02

#ifdef AML_NAND_UBOOT
#define MESON_CPU_MAJOR_ID_M8 0x19
#define MESON_CPU_MAJOR_ID_GX 0x21	//dbg code for gx pxp.
#endif /* AML_NAND_UBOOT */


#ifdef AML_NAND_UBOOT
static inline int get_cpu_type(void)
{
	return MESON_CPU_MAJOR_ID_GX;
}
#endif /* AML_NAND_UBOOT */
/*
#define	NAND_CYCLE_DELAY_M8	84
*/
/*
#define	NAND_CYCLE_DELAY	90
*/
#define	NAND_CYCLE_DELAY ((get_cpu_type() >= MESON_CPU_MAJOR_ID_M8)?(84) : (90))

/* Nand Flash Controller CLK register address */
/*
#define NAND_CLK_CNTL		0xc110425c
*/
/* Amlogic Nand Flash Controller register address */
/* #define P_NAND_BASE_APB	0xd0048600 */
/* #define P_NAND_BASE_CBUS	0xc1108600 */
/* #define RESOURCE_SIZE	0x40 */

#ifdef AML_NAND_UBOOT
/* m8baby, debug on m201... just for porting*/
#if  0
#define NAND_BASE_APB 	(u32 *)0xd0048600
#define IO_CBUS_PHY_BASE	(0xc1100000)
#define NAND_CLK_CNTL		(u32 *)(IO_CBUS_PHY_BASE + 0x425C)
#define	POC_CONFIG_REG		(u32 *)(IO_CBUS_PHY_BASE + 0x7D54)
#endif /* 0 */

/* gx, for pxp and ic. */
//#define SD_EMMC_BASE_C	(volatile uint32_t *)(0xd0074000)
#define SD_EMMC_BASE_C	(0xd0074000)
#define P_NAND_BASE 	(SD_EMMC_BASE_C | (1<<11))
#define NAND_BASE_APB	(P_NAND_BASE)
#define NAND_CLK_CNTL	(SD_EMMC_BASE_C)	//fixme, need update the clock calculation.
#define	POC_CONFIG_REG	(volatile uint32_t *)(0xc1107d54) //fixme, need check definition.
#endif /* AML_NAND_UBOOT */


/* NAND Write Command And Read Status Register */
#define P_NAND_CMD			(0x00)
/* NAND Configuration Register */
#define P_NAND_CFG			(0x04)
/* NAND Data Address Register */
#define P_NAND_DADR			(0x08)
/* NAND Information Address Register */
#define P_NAND_IADR			(0x0c)
/* NAND Read Data Buffer Register */
#define P_NAND_BUF			(0x10)
/* NAND Information Register */
#define P_NAND_INFO			(0x14)
/* NAND DDR interface Register */
#define P_NAND_DC			(0x18)
/* NAND DDR Address Register */
#define P_NAND_ADR			(0x1c)
/* NAND DDR Low 32 bits Data Register */
#define P_NAND_DL			(0x20)
/* NAND DDR High 32 bits Data Register */
#define P_NAND_DH			(0x24)
/* NAND Command Queus Address Register */
#define P_NAND_CADR			(0x28)
/* NAND Status Address Register */
#define P_NAND_SADR			(0x2c)
/* NAND CS2: SDRAM/NAND pin sharing Register */
#define P_NAND_PINS			(0x30)
/* NAND Version number Register */
#define P_NAND_VER			(0x38)


/*...other way to access cfg...*/
typedef union _nand_cfg {
    /** raw register data */
    u32 d;
    /** register bits */
    struct {
        u32 bus_cyc:5;	//0
        u32 bus_tim:5;	//5
        u32 sync:2;	//10
        u32 cmd_start:1;	//12
        u32 cmd_auto:1;	//13
        u32 apb_mode:1;	//14
        u32 spare_only:1;	//15
        u32 sync_adj:1;	//16
        u32 secure_des:1;	//17
        u32 reserved18:2;	//18
        u32 sts_irq_en:1;	//20
        u32 cmd_irq_en:1;	//21
        u32 reserved22:4;	//25
        u32 oob_on:1;		//26
        u32 oob_mode:1;	//27
        u32 dc_ugt:1;		//28
        u32 nand_wpn:1;	//29
        u32 dma_power:1;	//30
        u32 bus_power:1;	//31
    } b;
} nand_cfg_t;

typedef struct _nand_reg {
	volatile u32 cmd;
	volatile u32 cfg;
} nand_reg_t;

extern nand_reg_t *p_nand_reg;

static inline u32 amlnf_read_reg32(volatile uint32_t *_reg)
{
	/*---*/
#ifndef AML_NAND_UBOOT
	smp_rmb();
#endif /* AML_NAND_UBOOT */
	return __raw_readl(_reg);
};

static inline void amlnf_write_reg32(volatile uint32_t *_reg,
	const u32 _value)
{
	__raw_writel(_value, _reg);
	/*---*/
#ifndef AML_NAND_UBOOT
	smp_mb();
#endif /* AML_NAND_UBOOT */
};

static inline void amlnf_set_reg32_bits(volatile uint32_t *_reg,
	const u32 _value,
	const u32 _start,
	const u32 _len)
{
	/*---*/
#ifndef AML_NAND_UBOOT
	smp_rmb();
#endif /* AML_NAND_UBOOT */
	__raw_writel(((__raw_readl(_reg) & ~(((1L << (_len))-1) << (_start)))
		| ((u32)((_value)&((1L<<(_len))-1)) << (_start))), _reg);
	/*---*/
#ifndef AML_NAND_UBOOT
	smp_wmb();
#endif /* AML_NAND_UBOOT */
}

static inline void amlnf_clrset_reg32_bits(volatile uint32_t *_reg,
	const u32 clr,
	const u32 set)
{
	/*---*/
#ifndef AML_NAND_UBOOT
	smp_rmb();
#endif /* AML_NAND_UBOOT */
	__raw_writel((__raw_readl(_reg) & ~(clr)) | (set), _reg);
	/*---*/
#ifndef AML_NAND_UBOOT
	smp_wmb();
#endif /* AML_NAND_UBOOT */
}

static inline u32 amlnf_get_reg32_bits(volatile uint32_t *_reg,
	const u32 _start,
	const u32 _len)
{
	/*---*/
#ifndef AML_NAND_UBOOT
	smp_rmb();
#endif /* AML_NAND_UBOOT */
	return (__raw_readl(_reg) >> (_start)) & ((1L << (_len)) - 1);
}

static inline void amlnf_set_reg32_mask(volatile uint32_t *_reg,
	const u32 _mask)
{
	/*---*/
#ifndef AML_NAND_UBOOT
	smp_rmb();
#endif /* AML_NAND_UBOOT */
	__raw_writel((__raw_readl(_reg) | (_mask)), _reg);
	/*---*/
#ifndef AML_NAND_UBOOT
	smp_wmb();
#endif /* AML_NAND_UBOOT */
}

static inline void amlnf_clr_reg32_mask(volatile uint32_t *_reg,
	const u32 _mask)
{
	/*---*/
#ifndef AML_NAND_UBOOT
	smp_rmb();
#endif /* AML_NAND_UBOOT */
	__raw_writel((__raw_readl(_reg) & (~(_mask))), _reg);
	/*---*/
#ifndef AML_NAND_UBOOT
	smp_wmb();
#endif /* AML_NAND_UBOOT */
}

/*
#define nfc_readl(host, reg) \
	__raw_readl((host)->reg_base + P_##reg)
#define nfc_writel(host, reg, value) \
	__raw_writel((value), (host)->reg_base + P_##reg)
#define nfc_readw(host, reg) \
	__raw_readw((host)->reg_base + P_##reg)
#define nfc_writew(host, reg, value) \
	__raw_writew((value), (host)->reg_base + P_##reg)
 #define nfc_readb(host, reg) \
	__raw_readb((host)->reg_base + P_##reg)
#define nfc_writeb(host, reg, value) \
	__raw_writeb((value), (host)->reg_base + P_##reg)

#define nfc_set_bits(host, reg) \
	{\
		u32 value;\
		value = __raw_readl((host)->reg_base + P_##reg);\
		value &= ~((( 1L << (_len) )-1) << (_start)); \
		value |= ((u32)((_value)&((1L<<(_len))-1)) << (_start));\
		__raw_writel(value, (host)->reg_base + P_##reg);\
	}
*/

//#define	AMLNF_WRITE_REG(reg, val) (amlnf_write_reg32((volatile uint32_t *)(reg), (val)))
#define	AMLNF_WRITE_REG(reg, val) (amlnf_write_reg32(reg, (val)))
//#define AMLNF_READ_REG(reg) (amlnf_read_reg32((volatile uint32_t *)(reg)))
#define AMLNF_READ_REG(reg) (amlnf_read_reg32(reg))
/*
#define AMLNF_WRITE_REG_BITS(reg, val, start, len) \
	(amlnf_set_reg32_bits((volatile uint32_t *)(reg), (val), start, len))
*/
#define AMLNF_WRITE_REG_BITS(reg, val, start, len) \
	(amlnf_set_reg32_bits(reg, val, start, len))
/*
#define AMLNF_READ_REG_BITS(bus,reg, start, len) \
	(amlnf_get_reg32_bits(reg,start,len))
*/
/*
#define AMLNF_CLEAR_REG_MASK(reg, mask)	(amlnf_clr_reg32_mask((volatile uint32_t *)(reg), (mask)))
#define AMLNF_SET_REG_MASK(reg, mask)	(amlnf_set_reg32_mask((volatile uint32_t *)(reg), (mask)))
*/
#define AMLNF_CLEAR_REG_MASK(reg, mask)	(amlnf_clr_reg32_mask(reg, mask))
#define AMLNF_SET_REG_MASK(reg, mask)	(amlnf_set_reg32_mask(reg, mask))

/*
#define NFC_SET_TIMING(host, mode, cycles, adjust) \
	AMLNF_WRITE_REG_BITS((host)->reg_base + P_NAND_CFG, \
	((cycles)|((adjust&0xf)<<10)|((mode&7)<<5)), 0, 14)
#define NFC_SET_CMD_START(host) \
	AMLNF_SET_REG_MASK((host)->reg_base + P_NAND_CFG, 1<<12)

#define NFC_SET_CMD_AUTO(host) \
	AMLNF_SET_REG_MASK((host)->reg_base + P_NAND_CFG, 1<<13)

#define NFC_SET_STS_IRQ(host, en) \
	AMLNF_WRITE_REG_BITS((host)->reg_base + P_NAND_CFG, en, 20, 1)

#define NFC_SET_CMD_IRQ(host, en) \
	AMLNF_WRITE_REG_BITS((host)->reg_base + P_NAND_CFG, en, 21, 1)
*/
#define NFC_SET_TIMING_ASYC(host, bus_tim, bus_cyc) \
	AMLNF_WRITE_REG_BITS((host)->reg_base + P_NAND_CFG, \
	((bus_cyc&31)|((bus_tim&31)<<5)|(0<<10)), \
	0, \
	12)
/*
#define NFC_SET_TIMING_SYNC(host, bus_tim, bus_cyc, sync_mode) \
	AMLNF_WRITE_REG_BITS((host)->reg_base + P_NAND_CFG, \
	(bus_cyc&31)|((bus_tim&31)<<5)|((sync_mode&2)<<10), \
	0, \
	12)
#define NFC_SET_TIMING_SYNC_ADJUST()
#define NFC_SET_DMA_MODE(host, is_apb, spare_only) \
	AMLNF_WRITE_REG_BITS((host)->reg_base + P_NAND_CFG, \
	((spare_only<<1)|(is_apb)), \
	14, \
	2)
*/
#define NFC_SET_OOB_MODE(host, mode) \
	AMLNF_SET_REG_MASK((host)->reg_base + P_NAND_CFG, mode);
#define NFC_CLR_OOB_MODE(host, mode) \
	AMLNF_CLEAR_REG_MASK((host)->reg_base + P_NAND_CFG, mode);
/*
#define NFC_ENABLE_STS_IRQ(host) \
	AMLNF_SET_REG_MASK((host)->reg_base + P_NAND_CFG, 1<<20)
#define NFC_DISABLE_STS_IRQ(host) \
	AMLNF_CLEAR_REG_MASK((host)->reg_base + P_NAND_CFG, 1<<20)
*/
#define NFC_ENABLE_IO_IRQ(host)	\
	AMLNF_SET_REG_MASK((host)->reg_base + P_NAND_CFG, 1<<21)
#define NFC_DISABLE_IO_IRQ(host) \
	AMLNF_CLEAR_REG_MASK((host)->reg_base + P_NAND_CFG, 1<<21)

#define NFC_ENABLE_ENCRYPT(host)	\
	AMLNF_SET_REG_MASK((host)->reg_base + P_NAND_CFG, 1<<17)
#define NFC_DISABLE_ENCRYPT(host) \
	AMLNF_CLEAR_REG_MASK((host)->reg_base + P_NAND_CFG, 1<<17)


/**
    ADDR operations
*/
#define NFC_SET_DADDR(host, a) \
	(AMLNF_WRITE_REG((host)->reg_base + P_NAND_DADR, (u32)a))
#define NFC_SET_IADDR(host, a) \
	(AMLNF_WRITE_REG((host)->reg_base + P_NAND_IADR, (u32)a))
#define NFC_SET_SADDR(host, a) \
	(AMLNF_WRITE_REG((host)->reg_base + P_NAND_SADR, (u32)a))

#define NFC_INFO_GET(host) \
	(AMLNF_READ_REG((host)->reg_base + P_NAND_CMD))

#define NFC_GET_BUF(host) \
	AMLNF_READ_REG((host)->reg_base + P_NAND_BUF)
#define NFC_SET_CFG(host, val) \
	(AMLNF_WRITE_REG((host)->reg_base + P_NAND_CFG, (u32)val))

/*
   Common Nand Read Flow
*/
#define CE0		(0xe<<10)
#define CE1		(0xd<<10)
#define CE2		(0xb<<10)
#define CE3		(0x7<<10)
#define CE_NOT_SEL	(0xf<<10)
#define IO4		((0xe<<10)|(1<<18))
#define IO5		((0xd<<10)|(1<<18))
#define IO6		((0xb<<10)|(1<<18))
#define CLE		(0x5<<14)
#define ALE		(0x6<<14)
#define DWR		(0x4<<14)
#define DRD		(0x8<<14)
#define IDLE		(0xc<<14)
#define RB		(1<<20)
#define STANDBY		(0xf<<10)

#define M2N		((0<<17) | (2<<20) | (1<<19))
#define N2M		((1<<17) | (2<<20) | (1<<19))

#define M2N_NORAN	0x00200000
#define N2M_NORAN	0x00220000

#define STS		((3<<17) | (2<<20))
#define ADL		((0<<16) | (3<<20))
#define ADH		((1<<16) | (3<<20))
#define AIL		((2<<16) | (3<<20))
#define AIH		((3<<16) | (3<<20))
#define ASL		((4<<16) | (3<<20))
#define ASH		((5<<16) | (3<<20))
#define SEED		((8<<16) | (3<<20))

#define SEED_OFFSET	0xc2

/**
    Nand Flash Controller (M1)
    Global Macros
*/
/**
   Config Group
*/

/**
    CMD relative Macros
    Shortage word . NFCC
*/
#define NFC_CMD_IDLE(ce, time)	((ce)|IDLE|(time&0x3ff))
#define NFC_CMD_CLE(ce, cmd)	((ce)|CLE | (cmd & 0x0ff))
#define NFC_CMD_ALE(ce, addr)	((ce)|ALE | (addr&0x0ff))
#define NFC_CMD_STANDBY(time)	(STANDBY | (time&0x3ff))
#define NFC_CMD_ADL(addr)	(ADL | (addr&0xffff))
#define NFC_CMD_ADH(addr)	(ADH|((addr>>16)&0xffff))
#define NFC_CMD_AIL(addr)	(AIL | (addr&0xffff))
#define NFC_CMD_AIH(addr)	(AIH|((addr>>16)&0xffff))
#define NFC_CMD_DWR(ce, data)	(ce|DWR | (data&0xff))
#define NFC_CMD_DRD(ce, size)	(ce|DRD|size)
#define NFC_CMD_RB(ce, time)	((ce)|RB | (time&0x1f))
#define NFC_CMD_RB_INT(ce, time) \
	((ce)|RB|(((ce>>10)^0xf)<<14)|(time&0x1f))
#define NFC_CMD_RBIO(time, io)		(RB|io|(time&0x1f))
#define NFC_CMD_RBIO_IRQ(time)		(RB|IO6|(1<<16)|(time&0x1f))
#define NFC_CMD_RBIO_INT(io, time)	(RB|(((io>>10)^0x7)<<14)|(time&0x1f))
#define NFC_CMD_SEED(seed)	(SEED|(SEED_OFFSET + (seed&0x7fff)))
#define NFC_CMD_STS(tim)	(STS|(tim&3))
#define NFC_CMD_M2N(ran, ecc, sho, pgsz, pag) \
	((ran?M2N:M2N_NORAN)|(ecc<<14)|(sho<<13)|((pgsz&0x7f)<<6)|(pag&0x3f))
#define NFC_CMD_N2M(ran, ecc, sho, pgsz, pag)\
	((ran?N2M:N2M_NORAN)|(ecc<<14)|(sho<<13)|((pgsz&0x7f)<<6)|(pag&0x3f))

/**
Alias for CMD
#define NFC_CMD_D_ADR(addr)	NFC_CMD_ADL(addr), NFC_CMD_ADH(addr)
#define NFC_CMD_I_ADR(addr)	NFC_CMD_ADI(addr), NFC_CMD_ADI(addr)
*/

#define NAND_ECC_NONE		(0x0)
#define NAND_ECC_BCH8		(0x1)
#define NAND_ECC_BCH8_1K	(0x2)
#define NAND_ECC_BCH16_1K	(0x3)
#define NAND_ECC_BCH24_1K	(0x4)
#define NAND_ECC_BCH24_1K_M8	(0x3)
#define NAND_ECC_BCH30_1K	(0x5)
#define NAND_ECC_BCH30_1K_M8	(0x4)
#define NAND_ECC_BCH40_1K	(0x6)
#define NAND_ECC_BCH40_1K_M8	(0x5)
#define NAND_ECC_BCH50_1K_M8	(0x6)
#define NAND_ECC_BCH60_1K	(0x7)
#define NAND_ECC_BCH_SHORT	(0x8)

/**
Register Operation and Controller Status
*/
#define NFC_SEND_CMD(host, cmd) \
	(AMLNF_WRITE_REG((host)->reg_base + P_NAND_CMD, cmd))
#define NFC_READ_INFO(host) \
	(AMLNF_READ_REG((host)->reg_base + P_NAND_CMD))

/**
    Send command directly
*/
#define NFC_SEND_CMD_IDLE(host, time) \
	{\
		while (NFC_CMDFIFO_SIZE(host) > 0)\
			; \
		NFC_SEND_CMD(host, NFC_CMD_IDLE((host)->chip_selected, time)); \
	}
#define NFC_SEND_CMD_CLE(host, ce, cmd) \
	NFC_SEND_CMD(host, NFC_CMD_CLE(ce, cmd))
#define NFC_SEND_CMD_ALE(host, ce, addr) \
	NFC_SEND_CMD(host, NFC_CMD_ALE(ce, addr))
#define NFC_SEND_CMD_STANDBY(host, time) \
	NFC_SEND_CMD(host, NFC_CMD_STANDBY(time))
#define NFC_SEND_CMD_ADL(host, addr) \
	NFC_SEND_CMD(host, NFC_CMD_ADL(addr))
#define NFC_SEND_CMD_ADH(host, addr) \
	NFC_SEND_CMD(host, NFC_CMD_ADH(addr))
#define NFC_SEND_CMD_AIL(host, addr) \
	NFC_SEND_CMD(host, NFC_CMD_AIL(addr))
#define NFC_SEND_CMD_AIH(host, addr) \
	NFC_SEND_CMD(host, NFC_CMD_AIH(addr))
#define NFC_SEND_CMD_DWR(host, ce, data) \
	NFC_SEND_CMD(host, NFC_CMD_DWR(ce, data))
#define NFC_SEND_CMD_DRD(host, ce, size) \
	NFC_SEND_CMD(host, NFC_CMD_DRD(ce, size))
#define NFC_SEND_CMD_RB(host, ce, time)	\
	NFC_SEND_CMD(host, NFC_CMD_RB(ce, time))
#define NFC_SEND_CMD_SEED(host, seed) \
	NFC_SEND_CMD(host, NFC_CMD_SEED(seed))
#define NFC_SEND_CMD_M2N(host, ran, ecc, sho, pgsz, pag) \
	NFC_SEND_CMD(host, NFC_CMD_M2N(ran, ecc, sho, pgsz, pag))
#define NFC_SEND_CMD_N2M(host, ran, ecc, sho, pgsz, pag) \
	NFC_SEND_CMD(host, NFC_CMD_N2M(ran, ecc, sho, pgsz, pag))

#define NFC_SEND_CMD_M2N_RAW(host, ran, len) \
	NFC_SEND_CMD(host, (ran?M2N:M2N_NORAN)|(len&0x3fff))
#define NFC_SEND_CMD_N2M_RAW(host, ran, len) \
	NFC_SEND_CMD(host, (ran?N2M:N2M_NORAN)|(len&0x3fff))

#define NFC_SEND_CMD_STS(host, time, irq) \
	NFC_SEND_CMD(host, NFC_CMD_STS(time | irq))

#define NFC_SEND_CMD_RB_IRQ(host, time) \
	NFC_SEND_CMD(host, NFC_CMD_RBIO_IRQ(time))

/**
    Cmd Info Macros
*/
#define NFC_CMDFIFO_SIZE(host)		((NFC_INFO_GET(host)>>22)&0x1f)
#define NFC_CHECEK_RB_TIMEOUT(host)	((NFC_INFO_GET(host)>>27)&0x1)
#define NFC_FIFO_CUR_CMD(host)		((NFC_INFO_GET(host)>>22)&0x3FFFFF)
#define NFC_GET_RB_STATUS(host, ce) \
	(((NFC_INFO_GET(host)>>28)&(~(ce>>10)))&0xf)


#define NAND_INFO_DONE(a)	(((a)>>31)&1)
#define NAND_ECC_ENABLE(a)	(((a)>>30)&1)
#define NAND_ECC_CNT(a)		(((a)>>24)&0x3f)
#define NAND_ZERO_CNT(a)	(((a)>>16)&0x3f)
#define NAND_INFO_DATA_2INFO(a)	((a)&0xffff)
#define NAND_INFO_DATA_1INFO(a)	((a)&0xff)

#define POR_CONFIG	READ_CBUS_REG(ASSIST_POR_CONFIG)

#define POC_NAND_CFG	(1<<2)
#define POC_NAND_NO_RB	(1<<0)
#define POC_NAND_ASYNC	(1<<7)

#endif /* __HW_CTRL_H__ */

