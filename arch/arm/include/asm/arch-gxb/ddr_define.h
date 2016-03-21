
/* ddr type defines */
#define CONFIG_DDR_TYPE_DDR3				0
#define CONFIG_DDR_TYPE_LPDDR2				1
#define CONFIG_DDR_TYPE_LPDDR3				2

#define CONFIG_LPDDR3_CA_TRAINING_USE_LANE0		0
#define CONFIG_LPDDR3_CA_TRAINING_USE_LANE1		1
#define CONFIG_LPDDR3_CA_TRAINING_USE_LANE2		2
#define CONFIG_LPDDR3_CA_TRAINING_USE_LANE3		3

/* ddr channel defines */
#define CONFIG_DDR0_RANK0_ONLY				1
#define CONFIG_DDR0_RANK01_SAME				2
#define CONFIG_DDR0_RANK01_DIFF				3
#define CONFIG_DDR01_SHARE_AC				4
#define CONFIG_DDR0_ONLY_16BIT				5
#define CONFIG_DDR0_RANK01_DIFF_16BIT		6

/* AUTO mode support:
               RANK01 DIFF
               RANK01 SAME */
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
#define CONFIG_LPDDR2_TIMMING_DDR1066		0x21
#define CONFIG_LPDDR3_TIMMING_DDR1600		0x31
#define CONFIG_LPDDR3_TIMMING_DDR1866		0x32

#define CONFIG_DDR_FUNC_TEST				(1<<0)

#define CONFIG_DDR_INIT_RETRY_TOTAL			(5)
#define CONFIG_DDR_PCTL_RETRY_TOTAL			(10)

#define DDR_USE_1_CHANNEL(chl_set)	((chl_set == CONFIG_DDR0_RANK01_SAME) || \
				(chl_set == CONFIG_DDR0_ONLY_16BIT) || \
				(chl_set == CONFIG_DDR0_RANK0_ONLY))
#define DDR_USE_2_CHANNEL(chl_set)	((chl_set == CONFIG_DDR01_SHARE_AC) || \
				(chl_set == CONFIG_DDR0_RANK01_DIFF) || \
					(chl_set == CONFIG_DDR0_RANK01_DIFF_16BIT))

/* lpddr3 ca training setting */
#ifndef CONFIG_LPDDR3_CA_TRAINING_CA0
#define CONFIG_LPDDR3_CA_TRAINING_CA0	CONFIG_LPDDR3_CA_TRAINING_USE_LANE2
#endif
#ifndef CONFIG_LPDDR3_CA_TRAINING_CA1
#define CONFIG_LPDDR3_CA_TRAINING_CA1	CONFIG_LPDDR3_CA_TRAINING_USE_LANE0
#endif

/* lpddr3 remap setting */
#define LPDDR_DIE_ROW_COL_R13_C9		0
#define LPDDR_DIE_ROW_COL_R14_C9		1
#define LPDDR_DIE_ROW_COL_R14_C10		2
#define LPDDR_DIE_ROW_COL_R13_C10		3
#define LPDDR_DIE_ROW_COL_R14_C11		4
#ifndef CONFIG_LPDDR_REMAP_SET
#define CONFIG_LPDDR_REMAP_SET			LPDDR_DIE_ROW_COL_R13_C10
#endif

/* lpddr3 write leveling */
#ifndef CONFIG_LPDDR3_WRITE_LEVELING
#define CONFIG_LPDDR3_WRITE_LEVELING	1
#endif

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

#ifndef CONFIG_CMD_DDR_D2PLL
#define CONFIG_CMD_DDR_D2PLL				0
#endif
#define DDR_FUNC_D2PLL						(CONFIG_CMD_DDR_D2PLL<<0)

#ifndef CONFIG_DDR_FUNC_LPDDR3_CA
#define CONFIG_DDR_FUNC_LPDDR3_CA			0
#endif
#define DDR_FUNC_LPDDR3_CA					(CONFIG_DDR_FUNC_LPDDR3_CA<<1)

#define DDR_FUNC							(DDR_FUNC_D2PLL) |\
											(DDR_FUNC_LPDDR3_CA)
