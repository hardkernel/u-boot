
#include <config.h>
#include <io.h>
#include <stdint.h>

/* io defines */
#define wr_reg(addr, data)	(*((volatile uint32_t *)addr))=(uint32_t)(uint64_t)(data)
#define rd_reg(addr)		(*((volatile uint32_t *)addr))
/*clear [mask] 0 bits in [addr], set these 0 bits with [value] corresponding bits*/
#define modify_reg(addr, value, mask) wr_reg(addr, ((rd_reg(addr) & (mask)) | (value)))
#define wait_set(addr, loc) do{}while(0 == (rd_reg(addr) & (1<<loc)));
#define wait_clr(addr, loc) do{}while(1 == (rd_reg(addr) & (1<<loc)));

/* function defines */
unsigned int ddr_init(void);
unsigned int ddr_init_pll(void);
unsigned int ddr_init_dmc(void);
unsigned int ddr_init_pctl(void);
unsigned int hot_boot(void);
unsigned int ddr_test(void);
void ddr_print_info(void);
void mem_test(void);
void print_ddr_info(void);
void ddr_pre_init(void);

#define CFG_DDR_BASE_ADDR					0X0
#define CFG_DDR_START_OFFSET				0X01000000 //SKIP 16MB

/* PUB PIR setting */
#define PUB_PIR_INIT						(1<<0)
#define PUB_PIR_ZCAL						(1<<1)
#define PUB_PIR_CA							(1<<2)
#define PUB_PIR_PLLINIT						(1<<4)
#define PUB_PIR_DCAL						(1<<5)
#define PUB_PIR_PHYRST						(1<<6)
#define PUB_PIR_DRAMRST						(1<<7)
#define PUB_PIR_DRAMINIT					(1<<8)
#define PUB_PIR_WL							(1<<9)
#define PUB_PIR_QSGATE						(1<<10)
#define PUB_PIR_WLADJ						(1<<11)
#define PUB_PIR_RDDSKW						(1<<12)
#define PUB_PIR_WRDSKW						(1<<13)
#define PUB_PIR_RDEYE						(1<<14)
#define PUB_PIR_WREYE						(1<<15)
#define PUB_PIR_ICPC						(1<<16)
#define PUB_PIR_PLLBYP						(1<<17)
#define PUB_PIR_CTLDINIT					(1<<18)
#define PUB_PIR_RDIMMINIT					(1<<19)
#define PUB_PIR_CLRSR						(1<<27)
#define PUB_PIR_LOCKBYP						(1<<28)
#define PUB_PIR_DCALBYP						(1<<29)
#define PUB_PIR_ZCALBYP						(1<<30)
#define PUB_PIR_INITBYP						(1<<31)

/* ddr type defines */
#define CONFIG_DDR_TYPE_DDR3				0
#define CONFIG_DDR_TYPE_LPDDR2				1
#define CONFIG_DDR_TYPE_LPDDR3				2

/* ddr channel defines */
#define CONFIG_DDR0_RANK0_ONLY				1
#define CONFIG_DDR0_RANK01_SAME				2
#define CONFIG_DDR01_SHARE_AC				3

#if 0
/* ddr channel related settings */
#if (CONFIG_DDR_CHANNEL_SET == CONFIG_DDR0_RANK0_ONLY)

  #define CFG_DDR_RANK_SET					2 //b'010: BIT22, BIT21, BIT20
  #define CFG_DDR_CHANNEL_INTERFACE			0 //BIT[17:16], DDR0_DDR1 DATA WIDTH, 0:32BIT, 1:16BIT
  #define CFG_DDR_CHANNEL_SELECT			1 //b'00:DDR0_DDR1, b'01: DDR0_ONLY, b'10:DDR1_ONLY
  #define CFG_DDR_DUAL_RANK_SEL				0 //SET PGCR2[28], RANK0 AND RANK1 USE SAME RANK SELECT SIGNAL
  #define CFG_DDR0_SIZE						(CONFIG_DDR_SIZE)
  #define CFG_DDR1_SIZE						0
#elif (CONFIG_DDR_CHANNEL_SET == CONFIG_DDR0_RANK01_SAME)
  #define CFG_DDR_RANK_SET					4 //b'100: BIT22, BIT21, BIT20
  #define CFG_DDR_CHANNEL_INTERFACE			0
  #define CFG_DDR_CHANNEL_SELECT			1
  #define CFG_DDR_DUAL_RANK_SEL				1
  #define CFG_DDR0_SIZE						(CONFIG_DDR_SIZE)
  #define CFG_DDR1_SIZE						0
#elif (CONFIG_DDR_CHANNEL_SET == CONFIG_DDR01_SHARE_AC)
  #define CFG_DDR_RANK_SET					1 //b'001: BIT22, BIT21, BIT20
  #define CFG_DDR_CHANNEL_INTERFACE			3
  #define CFG_DDR_CHANNEL_SELECT			0
  #define CFG_DDR_DUAL_RANK_SEL				1
  #define CFG_DDR0_SIZE						(CONFIG_DDR_SIZE >> 1)
  #define CFG_DDR1_SIZE						(CONFIG_DDR_SIZE >> 1)
#endif
#endif

/* PHY initialize register (PIR) */
#define DDR_PIR ((PUB_PIR_ZCAL) 		|\
				(PUB_PIR_PLLINIT) 		|\
				(PUB_PIR_DCAL) 			|\
				(PUB_PIR_PHYRST)		|\
				(PUB_PIR_DRAMRST)		|\
				(PUB_PIR_DRAMINIT)		|\
				(PUB_PIR_WL)			|\
				(PUB_PIR_QSGATE)		|\
				(PUB_PIR_WLADJ)			|\
				(PUB_PIR_RDDSKW)		|\
				(PUB_PIR_WRDSKW)		|\
				(PUB_PIR_RDEYE)			|\
				(PUB_PIR_WREYE)			 \
				)

/* PHY general status register (PGSR0) */
#if (CONFIG_DDR_TYPE == CONFIG_DDR_TYPE_DDR3)
#define DDR_PGSR0_CHECK() ((rd_reg(DDR0_PUB_PGSR0) != 0xC0000fff) && \
							(rd_reg(DDR0_PUB_PGSR0) != 0x80000fff))
#elif (CONFIG_DDR_TYPE == CONFIG_DDR_TYPE_LPDDR2)
#define DDR_PGSR0_CHECK()
#elif (CONFIG_DDR_TYPE == CONFIG_DDR_TYPE_LPDDR3)
#define DDR_PGSR0_CHECK()
#endif

/* other regs */
#define SCRATCH0				0xC1107D3C