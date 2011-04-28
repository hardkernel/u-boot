#include <common.h>
#include <nand.h>
#include <mmc.h>
#include <asm/arch/nand.h>
#include <post.h>

#if CONFIG_POST & CONFIG_SYS_POST_NAND
//============================================================================
static int nand_sub_test(nand_info_t *nand, int idx)
{
	if (!nand) {
		nand_init();
		if (!nand) {			
			post_log("<%d>%s:%d: NAND[device:%d]: no NAND device available.\n", SYSTEST_INFO_L2, __FUNCTION__, __LINE__, idx);
			return -1;
		}
	}
	if (nand->name) {
		//struct nand_chip *chip = nand->priv;					
/*#ifdef CONFIG_MTD_DEVICE
	sprintf(systest_info_line, "NAND: Device %d: %s, %s sector size %u KiB \n", idx, 
			nand->name, nand->info, nand->erasesize >> 10);
	systest_log(systest_info_line, SYSTEST_INFO_L2);
#else 
*/	
	post_log("<%d>NAND: Device %d: %s, sector size %u KiB \n",  SYSTEST_INFO_L2, idx, nand->name, nand->erasesize >> 10)	;
//#endif
	}
	
	return 1;

}

//==================================================================================
int nand_post_test(int flags)
{	
	int i, ret;
	nand_info_t *nand;
	ret = 0;
	for(i = 0; i < CONFIG_SYS_MAX_NAND_DEVICE+1; i++){
		nand = &(nand_info[i]);
		if(nand_sub_test(nand, i) < 0)
			ret = -1;				
	}
	return ret;
}

#endif /*CONFIG_POST*/