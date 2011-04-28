//the original file name is sec_mmc.h
//change file name to m8_sec_mmc.h

#ifndef __M8_SEC_MMC__
#define __M8_SEC_MMC__

#define sec_mmc_wr(addr, data) *(volatile unsigned long *) (addr)=data
#define sec_mmc_rd(addr) *(volatile unsigned long *) (addr )

#define DMC_SEC_RANGE0_ST   		0xda002000
#define DMC_SEC_RANGE0_END  		0xda002004
#define DMC_SEC_RANGE1_ST   		0xda002008
#define DMC_SEC_RANGE1_END  		0xda00200c
#define DMC_SEC_RANGE2_ST   		0xda002010
#define DMC_SEC_RANGE2_END  		0xda002014
#define DMC_SEC_RANGE3_ST   		0xda002018
#define DMC_SEC_RANGE3_END  		0xda00201c

#define DMC_SEC_PORT0_RANGE0		0xda002040
#define DMC_SEC_PORT1_RANGE0		0xda002044
#define DMC_SEC_PORT2_RANGE0		0xda002048
#define DMC_SEC_PORT3_RANGE0		0xda00204c
#define DMC_SEC_PORT4_RANGE0		0xda002050
#define DMC_SEC_PORT5_RANGE0		0xda002054
#define DMC_SEC_PORT6_RANGE0		0xda002058
#define DMC_SEC_PORT7_RANGE0		0xda00205c
#define DMC_SEC_PORT8_RANGE0		0xda002060
#define DMC_SEC_PORT9_RANGE0		0xda002064
#define DMC_SEC_PORT10_RANGE0		0xda002068
#define DMC_SEC_PORT11_RANGE0		0xda00206c

#define DMC_SEC_PORT0_RANGE1		0xda002080
#define DMC_SEC_PORT1_RANGE1		0xda002084
#define DMC_SEC_PORT2_RANGE1		0xda002088
#define DMC_SEC_PORT3_RANGE1		0xda00208c
#define DMC_SEC_PORT4_RANGE1		0xda002090
#define DMC_SEC_PORT5_RANGE1		0xda002094
#define DMC_SEC_PORT6_RANGE1		0xda002098
#define DMC_SEC_PORT7_RANGE1		0xda00209c
#define DMC_SEC_PORT8_RANGE1		0xda0020a0
#define DMC_SEC_PORT9_RANGE1		0xda0020a4
#define DMC_SEC_PORT10_RANGE1		0xda0020a8
#define DMC_SEC_PORT11_RANGE1		0xda0020ac

#define DMC_SEC_PORT0_RANGE2		0xda0020c0
#define DMC_SEC_PORT1_RANGE2		0xda0020c4
#define DMC_SEC_PORT2_RANGE2		0xda0020c8
#define DMC_SEC_PORT3_RANGE2		0xda0020cc
#define DMC_SEC_PORT4_RANGE2		0xda0020d0
#define DMC_SEC_PORT5_RANGE2		0xda0020d4
#define DMC_SEC_PORT6_RANGE2		0xda0020d8
#define DMC_SEC_PORT7_RANGE2		0xda0020dc
#define DMC_SEC_PORT8_RANGE2		0xda0020e0
#define DMC_SEC_PORT9_RANGE2		0xda0020e4
#define DMC_SEC_PORT10_RANGE2		0xda0020e8
#define DMC_SEC_PORT11_RANGE2		0xda0020ec

#define DMC_SEC_PORT0_RANGE3		0xda002100
#define DMC_SEC_PORT1_RANGE3		0xda002104
#define DMC_SEC_PORT2_RANGE3		0xda002108
#define DMC_SEC_PORT3_RANGE3		0xda00210c
#define DMC_SEC_PORT4_RANGE3		0xda002110
#define DMC_SEC_PORT5_RANGE3		0xda002114
#define DMC_SEC_PORT6_RANGE3		0xda002118
#define DMC_SEC_PORT7_RANGE3		0xda00211c
#define DMC_SEC_PORT8_RANGE3		0xda002120
#define DMC_SEC_PORT9_RANGE3		0xda002124
#define DMC_SEC_PORT10_RANGE3		0xda002128
#define DMC_SEC_PORT11_RANGE3		0xda00212c

#define DMC_SEC_BAD_ACCESS  		0xda002140
//9:0  SEC Vio group/channe.
//10    read =  1  :  violation.  write 1 to clean. 
#define M8_DMC_SEC_CTRL     		    0xda002144
//bit 31.   update sec_req.
// bit 30.  read only. the update_sec_req in n_clk clock domain.
// bit 3.   secuity range 3 data scramble  enable.
// bit 2.   secuity range 2 data scramble  enable.
// bit 1.   secuity range 1 data scramble  enable.
// bit 0.   secuity range 0 data scramble  enable.

#define DMC_SEC_KEY0                0xda002148
 //SEC obf key bit [15:0]
#define DMC_SEC_KEY1                0xda00214c
 // //sec obf key bit [31:16]

#define M8_DMC_SEC_VIO0  		        0xda002150 //DDR0 READ
// DDR0 read Bad access request information.
//  26.    WRITE.  1 = write. 
//  25:23. *PROT. 
//  22:21. *BURST.
//  20:18. *SIZE.
//  17:14. *LEN.
//  13:0   bad access ID.
#define M8_DMC_SEC_VIO1  		        0xda002154
// 32 bit address of bad access.    //32bit address after canvas translation.  we can't record the address before cavnas.
#define M8_DMC_SEC_VIO2  		        0xda002158 //DDR1 READ
#define M8_DMC_SEC_VIO3  		        0xda00215c
#define M8_DMC_SEC_VIO4  		        0xda002160 //DDR0 WRITE
#define M8_DMC_SEC_VIO5  		        0xda002164
#define M8_DMC_SEC_VIO6  		        0xda002168 //DDR1 WRITE
#define M8_DMC_SEC_VIO7  		        0xda00216c

#endif //__M8_SEC_MMC__