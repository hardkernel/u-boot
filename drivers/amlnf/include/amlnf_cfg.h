
//#include "amlnf_dev.h"

#define	AML_NAND_UBOOT


/**************PHY****************/
#define	AML_SLC_NAND_SUPPORT	
#define	AML_MLC_NAND_SUPPORT	
//#define	AML_NAND_DBG
#define 	NEW_NAND_SUPPORT

#define 	NAND_ADJUST_PART_TABLE 

#define	AML_NAND_DBG_M8
#define AML_NAND_NEW_OOB

#if (MESON_CPU_TYPE > MESON_CPU_TYPE_MESON8)
#define	AML_NAND_M8B
#endif

/**************LOGIC****************/
#define  PRINT aml_nftl_dbg

#define NFTL_DONT_CACHE_DATA                      0
#define SUPPORT_GC_READ_RECLAIM                   0
#define SUPPORT_WEAR_LEVELING                     1
#define NFTL_ERASE                                0

#ifdef NAND_ADJUST_PART_TABLE
#define PART_RESERVED_BLOCK_RATIO                 10
#define	ADJUST_BLOCK_NUM			       4
#else
#define PART_RESERVED_BLOCK_RATIO                 8
#define	ADJUST_BLOCK_NUM			 	0
#endif
#define MIN_FREE_BLOCK_NUM                        6
#define GC_THRESHOLD_FREE_BLOCK_NUM               4

#define MIN_FREE_BLOCK                            2

#define GC_THRESHOLD_RATIO_NUMERATOR              2
#define GC_THRESHOLD_RATIO_DENOMINATOR            3

#define MAX_CACHE_WRITE_NUM  				      16


//#define CONFIG_NAND_AML_M8

