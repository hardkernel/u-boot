
/* ddr type defines */
#define CONFIG_DDR_TYPE_DDR3				0
#define CONFIG_DDR_TYPE_DDR4				1
#define CONFIG_DDR_TYPE_LPDDR3				2
#define CONFIG_DDR_TYPE_LPDDR2				3
#define CONFIG_DDR_TYPE_AUTO				0xf /* support ddr3/ddr4 */

/* ddr channel defines */
#define CONFIG_DDR0_16BIT					1
#define CONFIG_DDR0_RANK0					2
#define CONFIG_DDR0_RANK01					3
/* CONFIG_DDR_CHL_AUTO mode support RANK0 and RANK0+1 mode auto detect */
#define CONFIG_DDR_CHL_AUTO					0xF

#define CFG_DDR_BASE_ADDR					0X0
#define CFG_DDR_START_OFFSET				0X01000000 //SKIP 16MB

/* ddr type identifier */
#define CONFIG_DDR_TIMMING_LPDDR2			0x02
#define CONFIG_DDR_TIMMING_LPDDR3			0x03
#define CONFIG_DDR_TIMMING_DDR3_7			0x07
#define CONFIG_DDR_TIMMING_DDR3_9			0x09
#define CONFIG_DDR_TIMMING_DDR3_11			0x0B
#define CONFIG_DDR_TIMMING_DDR3_12			0x0C
#define CONFIG_DDR_TIMMING_DDR3_13			0x0D
#define CONFIG_DDR_TIMMING_DDR3_14			0x0E

#define CONFIG_DDR_TIMMING_DDR4_1600		0x0F
#define CONFIG_DDR_TIMMING_DDR4_1866		0x10
#define CONFIG_DDR_TIMMING_DDR4_2133		0x11
#define CONFIG_DDR_TIMMING_DDR4_2400		0x12
#define CONFIG_DDR_TIMMING_DDR4_2666		0x13
#define CONFIG_DDR_TIMMING_DDR4_3200		0x14

#define CONFIG_DDR_FUNC_TEST				(1<<0)

#define CONFIG_DDR_INIT_RETRY_TOTAL			(10)
#define CONFIG_DDR_PCTL_RETRY_TOTAL			(100)

#define DDR_USE_1_RANK(chl_set)	((chl_set == CONFIG_DDR0_RANK0) || \
				(chl_set == CONFIG_DDR0_16BIT))
#define DDR_USE_2_RANK(chl_set)	((chl_set == CONFIG_DDR0_RANK01))

/* DMC_DDR_CTRL defines */
#define DDR_DDR4_ENABLE						(1<<22)
#define DDR_RANK1_ENABLE					(1<<21)
#define DDR_DDR4_BG_ENABLE					(1<<20)
#define DDR_16BIT_ENABLE					(1<<16)

#define DDR_RANK1_SIZE_CTRL					(3)
#define DDR_RANK0_SIZE_CTRL					(0)


/* how to add a new ddr function?
   1. add CONFIG_DDR_FUNC_XXX in (config).h file
   2. add define in this file.
      2.1 add
        #ifndef CONFIG_DDR_FUNC_XXX
        #define CONFIG_DDR_FUNC_XXX 0
        #endif
      2.2 add
        #define DDR_FUNC_XXX (CONFIG_FUNC_XXX<<X)
      2.3 add DDR_FUNC_XXX |\ in DDR_FUNC
   3. add same define and parser in bl2 code
   */
/* 2.1, 2,2, 2,3 example */
/*
#ifndef CONFIG_CMD_DDR_D2PLL
#define CONFIG_CMD_DDR_D2PLL				0
#endif
#define DDR_FUNC_D2PLL						(CONFIG_CMD_DDR_D2PLL<<0)
#define DDR_FUNC							(EXISTING_FUNCTIONS) |\
											(DDR_FUNC_D2PLL)
*/

/* d2pll support */
#ifndef CONFIG_CMD_DDR_D2PLL
#define CONFIG_CMD_DDR_D2PLL				0
#endif
#define DDR_FUNC_D2PLL						(CONFIG_CMD_DDR_D2PLL<<0)

/* ddr low power function support */
#ifndef CONFIG_DDR_LOW_POWER
#define CONFIG_DDR_LOW_POWER				0
#endif
#define DDR_FUNC_LP							(CONFIG_DDR_LOW_POWER<<1)

/* ddr zq power down support */
#ifndef CONFIG_DDR_ZQ_PD
#define CONFIG_DDR_ZQ_PD					0
#endif
#define DDR_FUNC_ZQ_PD						(CONFIG_DDR_ZQ_PD<<2)

/* ddr vref function */
#ifndef CONFIG_DDR_USE_EXT_VREF
#define CONFIG_DDR_USE_EXT_VREF				0
#endif
#define DDR_FUNC_EXT_VREF					(CONFIG_DDR_USE_EXT_VREF<<3)

/* ddr4 timing test function */
#ifndef CONFIG_DDR4_TIMING_TEST
#define CONFIG_DDR4_TIMING_TEST				0
#endif
#define DDR_FUNC_DDR4_TIMING_TEST			(CONFIG_DDR4_TIMING_TEST<<3)

#define DDR_FUNC							(DDR_FUNC_D2PLL					| \
											DDR_FUNC_LP						| \
											DDR_FUNC_ZQ_PD					| \
											DDR_FUNC_EXT_VREF				| \
											DDR_FUNC_DDR4_TIMING_TEST		| \
											(1 << 31) 						\
											)
