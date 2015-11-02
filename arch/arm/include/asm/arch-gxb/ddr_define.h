
/* ddr type defines */
#define CONFIG_DDR_TYPE_DDR3				0
#define CONFIG_DDR_TYPE_LPDDR2				1
#define CONFIG_DDR_TYPE_LPDDR3				2

/* ddr channel defines */
#define CONFIG_DDR0_RANK0_ONLY				1
#define CONFIG_DDR0_RANK01_SAME				2
#define CONFIG_DDR0_RANK01_DIFF				3
#define CONFIG_DDR01_SHARE_AC				4
#define CONFIG_DDR0_ONLY_16BIT				5

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

#define DDR_USE_1_CHANNEL(chl_set)	((chl_set == CONFIG_DDR0_RANK01_SAME) || \
				(chl_set == CONFIG_DDR0_ONLY_16BIT) || \
				(chl_set == CONFIG_DDR0_RANK0_ONLY))
#define DDR_USE_2_CHANNEL(chl_set)	((chl_set == CONFIG_DDR01_SHARE_AC) || \
					(chl_set == CONFIG_DDR0_RANK01_DIFF))
