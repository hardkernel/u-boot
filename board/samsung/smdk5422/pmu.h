/*
 * Copyright@ Samsung Electronics Co. LTD
 *
 * This software is proprietary of Samsung Electronics.
 * No part of this software, either material or conceptual may be copied or distributed, transmitted,
 * transcribed, stored in a retrieval system or translated into any human or computer language in any form by any means,
 * electronic, mechanical, manual or otherwise, or disclosed
 * to third parties without the express written permission of Samsung Electronics.


 * Alternatively, this program is free software in case of open source projec;
 * you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.

 */

//-----------------------------------------------------------------------
//Wakeup condition
#define rWAKEUP_STAT                              (SYSC_PMU_BASE+0x0600)
#define rEXT_REGULATOR_SYS_PWR                    (SYSC_PMU_BASE+0x12C0)
#define rTOP_PWR_SYS_PWR                          (SYSC_PMU_BASE+0x1188)
#define rTOP_PWR_COREBLK_SYS_PWR                  (SYSC_PMU_BASE+0x1198)
#define rTOP_RETENTION_SYS_PWR                    (SYSC_PMU_BASE+0x1184)
#define rTOP_RETENTION_COREBLK_SYS_PWR            (SYSC_PMU_BASE+0x1194)
#define rC2C_CTRL                                 (SYSC_PMU_BASE+0x0024)

#define rINTRAM_MEM_SYS_PWR                       (SYSC_PMU_BASE+0x11B8)
#define rINTRAM_MEM_OPTION                        (SYSC_PMU_BASE+0x2F28)

// EVT0 only : bit21 is GPS_ALIVE, bit20 is C2C_RESET_REQ. Two bits are not connected to bit 31.
#define WAKEUP_STAT_VALID_MASK                    0x80000000
#define INTRAM_MEM_OPTION_MASK                    0x00000010
#define ONEBIT_MASK                               0x00000001
#define TWOBIT_MASK                               0x00000003
#define THREEBIT_MASK                             0x00000007

//-----------------------------------------------------------------------
//BOOT_STAT bitfield
//[4] 1:nRESET, 0:Wakeup
//[3] Reserved
//[2] 1: TOP ON, 0:TOP OFF
//[1] 1: COREBLK ON, 0:COREBLK OFF
//[0] 1: INTRAM ON, 0:INTRAM OFF
typedef enum {
  nRESET = 0x10,                        // Booting sequence #9
  IRAMON_COREON_TOPON    = 0x7,         // Booting sequence #1
  IRAMOFF_COREON_TOPON   = 0x6,         // Booting sequence #2
  IRAMON_COREOFF_TOPON   = 0x5,         // Booting sequence #3
  IRAMOFF_COREOFF_TOPON  = 0x4,         // Booting sequence #4
  IRAMON_COREON_TOPOFF   = 0x3,         // Booting sequence #5
  IRAMOFF_COREON_TOPOFF  = 0x2,         // Booting sequence #6
  IRAMON_COREOFF_TOPOFF  = 0x1,         // Booting sequence #7
  IRAMOFF_COREOFF_TOPOFF = 0x0          // Booting sequence #8
}BOOT_STAT;

BOOT_STAT GetRstStat(void);
