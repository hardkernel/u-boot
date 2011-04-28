#ifndef __M8_SEC_MMC__
#define __M8_SEC_MMC__

#define sec_mmc_wr(addr, data) *(volatile unsigned long *) (addr)=data
#define sec_mmc_rd(addr) *(volatile unsigned long *) (addr )

#define DMC_SEC_RANGE0_CTRL   		0xda002000
#define DMC_SEC_RANGE1_CTRL  		0xda002004
#define DMC_SEC_RANGE2_CTRL   		0xda002008
#define DMC_SEC_RANGE3_CTRL  		0xda00200c

#define DMC_SEC_AXI_PORT_CTRL 		0xda002010
#define DMC_SEC_AM_PORT_CTRL  		0xda002014
#define DMC_SEC_CTRL        		0xda002018
 //bit 31.   update sec_req.
 //bit 30.  read only. the update_sec_req in n_clk clock domain.
 //bit 3.   secuity range 3 data scramble  enable.
 //bit 2.   secuity range 2 data scramble  enable.
 //bit 1.   secuity range 1 data scramble  enable.
 //bit 0.   secuity range 0 data scramble  enable.

#define DMC_SEC_KEY  	        	0xda00201c
 //SEC obf key bit [15:0]
 //sec obf key bit [31:16]


#define DMC_SEC_BAD_ACCESS  		0xda002020
 //bit 15.  write 1 to clean the sec violation interrupt. 
 //bit 3.  ddr1 read sec violation read =  1  :  violation.  write 1 to clean. 
 //bit 2.  ddr1 write sec violation read =  1  :  violation.  write 1 to clean. 
 //bit 1.  ddr0 read sec violation read =  1  :  violation.  write 1 to clean. 
 //bit 0.  ddr0 write sec violation read =  1  :  violation.  write 1 to clean. 

#define DMC_DEV_RANGE_CTRL             0xda002024 
  //bit 31:16   range1 eanble bits for each port of Device channel.
  //bit 15:0    range0 eanble bits for each port of device channel.

#define DMC_DEV_RANGE_CTRL1            0xda002028 
  //bit 31:16   range3 eanble bits for each port of Device channel.
  //bit 15:0    range2 eanble bits for each port of device channel.

#define DMC_SEC_VIO0  		0xda002040    //DDR0 read
 // DDR0 read Bad access request information.
 //31.   1: secuity range violation.
 //30.   1: protection range violation.
 //29.   1: DDR space range overflow.
 //26.    WRITE.  1 = write. 
 //25:23. *PROT. 
 //22:21. *BURST.
 //20:18. *SIZE.
 //17:14. *LEN.
 //13:0   bad access ID.  
#define DMC_SEC_VIO1  		0xda002044
// 32 bit address of bad access.    //32bit address after canvas translation.  we can't record the address before cavnas. 

#define DMC_SEC_VIO2  		 0xda002048//DDR1 read
#define DMC_SEC_VIO3  		 0xda00204c
#define DMC_SEC_VIO4  		 0xda002050//DDR0 write
#define DMC_SEC_VIO5  		 0xda002054
#define DMC_SEC_VIO6  		 0xda002058//DDR1 write
#define DMC_SEC_VIO7  		 0xda00205c

#define DMC_PROT_RANGE  	 0xda002080
  //31:16.  protection range end address high 16 bits.
  //15:0.   protection range end address low 16 bits.
#define DMC_PROT_EN 	 	 0xda002084
  //31:16.  projection range enable bit for each port  write access
  //15:0.  projection range enable bit for each ports read access. 
#define DMC_PROT_CTRL 	 	 0xda002088
  // 31:  enable address protection function.
  //30:0.   not used.


#endif //__M8_SEC_MMC__
