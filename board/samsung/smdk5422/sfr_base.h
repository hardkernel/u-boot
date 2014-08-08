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

#ifndef __SFR_ADDR_H__
#define __SFR_ADDR_H__

//S5E5210

#define ISRAM_ADDRESS                           0x02020000
#define DRAM_ADDRESS                            0x20000000

#define CHIP_ID_BASE                            0x10000000
#define SYSC_PMU_BASE                           0x10040000
#define SYSC_CMU_BASE                           0x10010000
#define GPIO_BASE			        0x11400000
#define NFCON_BASE                              0x0CE00000
#define SECKEY_BASE                             0x10100000
#define EFNAND0_BASE							0x18200000
#define EFNAND1_BASE							0x18600000
#endif //__SFR_ADDR_H__
