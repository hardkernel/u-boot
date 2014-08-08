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

#include "types.h"
#include "util.h"
#include "sfr_base.h"
#include "pmu.h"

BOOT_STAT GetRstStat(void)
{
     BOOT_STAT eBootStat;

     u32 uWakeupStat;
     u32 uExtRegulatorSyspwr;
     u32 uTopPwrSyspwr;
     u32 uTopPwrCoreblkSyspwr;
     u32 uTopRetentionSyspwr;
     u32 uTopRetentionCoreblkSyspwr;
     u32 uIntramMemSyspwr;
     u32 uIntramMemOption;
     u32 uEnableC2C;

     int bWakeup;
     int bTopRetention;
     int bCoreblkRetention;
     int bIntramRetention;

     uWakeupStat = ( Inp32(rWAKEUP_STAT) & WAKEUP_STAT_VALID_MASK );
     uExtRegulatorSyspwr = ( Inp32(rEXT_REGULATOR_SYS_PWR) & ONEBIT_MASK );
     uTopPwrSyspwr = ( Inp32(rTOP_PWR_SYS_PWR) & TWOBIT_MASK );
     uTopPwrCoreblkSyspwr = ( Inp32(rTOP_PWR_COREBLK_SYS_PWR) & TWOBIT_MASK );
     uTopRetentionSyspwr = ( Inp32(rTOP_RETENTION_SYS_PWR) & ONEBIT_MASK );
     uTopRetentionCoreblkSyspwr = ( Inp32(rTOP_RETENTION_COREBLK_SYS_PWR) & ONEBIT_MASK );
     uIntramMemSyspwr = ( Inp32(rINTRAM_MEM_SYS_PWR) & TWOBIT_MASK );
     uIntramMemOption = ( Inp32(rINTRAM_MEM_OPTION ) & INTRAM_MEM_OPTION_MASK );
     uEnableC2C = ( Inp32(rC2C_CTRL) & ONEBIT_MASK );

     //condition A
     if( uWakeupStat != 0 )
     {
          bWakeup = true;
     }
     else
     {
          bWakeup = false;
     }

     //condition B
     if( uExtRegulatorSyspwr == 0 )
     {
          bTopRetention = false;
     }
     else if( uTopPwrSyspwr == 3 )
     {
          bTopRetention = true;
     }
     else if( uTopRetentionSyspwr == 0 )
     {
          bTopRetention = true;
     }
     else
     {
          bTopRetention = false;
     }

     //condition C
     if( uExtRegulatorSyspwr == 0 && uEnableC2C == 0 )
     {
          bCoreblkRetention = false;
     }
     else if( uTopPwrCoreblkSyspwr == 3 )
     {
          bCoreblkRetention = true;
     }
     else if( uTopRetentionCoreblkSyspwr == 0 )
     {
          bCoreblkRetention = true;
     }
     else
     {
          bCoreblkRetention = false;
     }

     //condition D
     if( uExtRegulatorSyspwr == 0 && uEnableC2C == 0 )
     {
          bIntramRetention = false;
     }
     else if( uTopPwrCoreblkSyspwr == 3 )
     {
          if( uIntramMemSyspwr == 0 && uIntramMemOption == 0 )
          {
               bIntramRetention = false;
          }
          else
          {
               bIntramRetention = true;
          }
     }
     else
     {
          if( uIntramMemSyspwr == 0 && uIntramMemOption == 0x10 )
          {
               bIntramRetention = true;
          }
          else
          {
               bIntramRetention = false;
          }
     }

     //IROM branch condition should reflect physical states of memory components.
     //Branch condition should take care of all power state
     //starting from external regulator all the way down to leaf conditions.
     if( bWakeup == true )
     {
          if( bTopRetention == true )
          {
               if( bCoreblkRetention == true )
               {
                    if( bIntramRetention == true )
                    {
                         eBootStat = IRAMON_COREON_TOPON;
                    }
                    else
                    {
                         eBootStat = IRAMOFF_COREON_TOPON;
                    }
               }
               else
               {
                    if( bIntramRetention == true )
                    {
                         eBootStat = IRAMON_COREOFF_TOPON;
                    }
                    else
                    {
                         eBootStat = IRAMOFF_COREOFF_TOPON;
                    }
               }
          }
          else
          {
               if( bCoreblkRetention == true )
               {
                    if( bIntramRetention == true )
                    {
                         eBootStat = IRAMON_COREON_TOPOFF;
                    }
                    else
                    {
                         eBootStat = IRAMOFF_COREON_TOPOFF;
                    }
               }
               else
               {
                    if( bIntramRetention == true )
                    {
                         eBootStat = IRAMON_COREOFF_TOPOFF;
                    }
                    else
                    {
                         eBootStat = IRAMOFF_COREOFF_TOPOFF;
                    }
               }
          }
     }
     else
     {
          eBootStat = nRESET;
     }

     return eBootStat;
}
