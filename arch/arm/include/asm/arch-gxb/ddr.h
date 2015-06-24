
#include <config.h>
#include <io.h>
#include <stdint.h>

/* io defines */
//#define wr_reg(addr, data)	(*((volatile uint32_t *)addr))=(uint32_t)(uint64_t)(data)
//#define rd_reg(addr)		(*((volatile uint32_t *)(addr)))
#define wr_reg(addr, data)	writel(data, addr)
#define rd_reg(addr)	readl(addr)
/*clear [mask] 0 bits in [addr], set these 0 bits with [value] corresponding bits*/
#define modify_reg(addr, value, mask) wr_reg(addr, ((rd_reg(addr) & (mask)) | (value)))
#define wait_set(addr, loc) do{}while(0 == (rd_reg(addr) & (1<<loc)));
#define wait_clr(addr, loc) do{}while(1 == (rd_reg(addr) & (1<<loc)));
#define wait_equal(addr, data) do{}while(data != (rd_reg(addr)));

/* function defines */
unsigned int ddr_init(void);
unsigned int ddr_init_pll(void);
unsigned int ddr_init_dmc(void);
unsigned int ddr_init_pctl(void);
unsigned int hot_boot(void);
void ddr_print_info(void);
void ddr_test(void);
void ddr_pre_init(void);
void ddr_debug(void);

#define CFG_DDR_BASE_ADDR					0X0
#define CFG_DDR_START_OFFSET				0X01000000 //SKIP 16MB

/* ddr functions */
#define CONFIG_DDR_ZQ_POWER_DOWN
#define CONFIG_DDR_POWER_DOWN_PHY_VREF

/* pctl status */
#define  UPCTL_STAT_MASK        (7)
#define  UPCTL_STAT_INIT        (0)
#define  UPCTL_STAT_CONFIG      (1)
#define  UPCTL_STAT_ACCESS      (3)
#define  UPCTL_STAT_LOW_POWER   (5)

/* pctl cmds */
#define UPCTL_CMD_INIT         (0)
#define UPCTL_CMD_CONFIG       (1)
#define UPCTL_CMD_GO           (2)
#define UPCTL_CMD_SLEEP        (3)
#define UPCTL_CMD_WAKEUP       (4)

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
#define CONFIG_DDR0_ONLY_16BIT				4

/* ddr type identifier */
#define CONFIG_DDR_TIMMING_LPDDR2			0x02
#define CONFIG_DDR_TIMMING_LPDDR3			0x03
#define CONFIG_DDR_TIMMING_DDR3_7			0x07
#define CONFIG_DDR_TIMMING_DDR3_9			0x09
#define CONFIG_DDR_TIMMING_DDR3_11			0x0B
#define CONFIG_DDR_TIMMING_DDR3_12			0x0C
#define CONFIG_DDR_TIMMING_DDR3_13			0x0D
#define CONFIG_DDR_TIMMING_DDR3_14			0x0E

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
