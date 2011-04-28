#include <common.h>
#include <mmc.h>
#include <post.h>

#if CONFIG_POST & CONFIG_SYS_POST_SDCARD
//=======================================================================
int sdcard_post_test(int flags)
{
	struct mmc *mmc;
	int dev_num;

	dev_num = simple_strtoul("mmcinfo", NULL, 0);
	mmc = find_mmc_device(dev_num);

	if (mmc) {
		mmc_init(mmc);		
	    	if((mmc->tran_speed == 0) || (mmc->read_bl_len == 0) || (mmc->capacity == 0)) {		
			post_log("<%d>%s:%d: SDCARD: %s\n", SYSTEST_INFO_L2, __FUNCTION__, __LINE__, "no MMC device available.");
			return -1;
		}		
		
		post_log("<%d>SDCARD: Device: %s\n", SYSTEST_INFO_L2, mmc->name);				
		post_log("<%d>SDCARD: Manufacturer ID: %x\n", SYSTEST_INFO_L2, mmc->cid[0] >> 24);				
		post_log("<%d>SDCARD: OEM: %x\n", SYSTEST_INFO_L2, (mmc->cid[0] >> 8) & 0xffff);
			
		//post_log("<%d>SDCARD: Name: %c%c%c%c%c\n",SYSTEST_INFO_L2, mmc->cid[0] & 0xff,
		//			(mmc->cid[1] >> 24), (mmc->cid[1] >> 16) & 0xff,
		//			(mmc->cid[1] >> 8) & 0xff, mmc->cid[1] & 0xff);
		
		post_log("<%d>SDCARD: Tran Speed: %d\n", SYSTEST_INFO_L2, mmc->tran_speed);				
		post_log("<%d>SDCARD: Rd Block Len: %d\n", SYSTEST_INFO_L2, mmc->read_bl_len);
		
		post_log("<%d>SDCARD: %s version %d.%d\n", SYSTEST_INFO_L2, IS_SD(mmc) ? "SD" : "MMC",
													(mmc->version >> 4) & 0xf, mmc->version & 0xf);		
		post_log("<%d>SDCARD: High Capacity: %s\n", SYSTEST_INFO_L2, mmc->high_capacity ? "Yes" : "No");
		post_log("<%d>SDCARD: Capacity: %lld\n", SYSTEST_INFO_L2, mmc->capacity);	
		post_log("<%d>SDCARD: Bus Width: %d-bit\n", SYSTEST_INFO_L2, mmc->bus_width);		
	}
	else {		
		post_log("<%d>%s:%d: SDCARD: %s\n", SYSTEST_INFO_L2,  __FUNCTION__, __LINE__, "no MMC device available.");		
		return -1;
	}
	return 0;
}


#endif