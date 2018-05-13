
#ifdef CONFIG_MDUMP_COMPRESS
#include "ramdump.h"

struct ram_compress_full __ramdump_data = {
	.store_phy_addr = (void *)CONFIG_COMPRESSED_DATA_ADDR,
	.full_memsize   = CONFIG_DDR_TOTAL_SIZE,
	.section_count  = CONFIG_COMPRESS_SECTION,
	.sections       = {
		{
			/* memory afer compressed data address */
			.phy_addr      = (void *)CONFIG_COMPRESSED_DATA_ADDR,
			.section_size  = CONFIG_DDR_TOTAL_SIZE -
					 CONFIG_COMPRESSED_DATA_ADDR,
			.section_index = 5,
			.compress_type = RAM_COMPRESS_NORMAL,
		},
		{
			/* memory in reserved bottom */
			.phy_addr      = (void *)CONFIG_COMPRESS_START_ADDR,
			.section_size  = CONFIG_1ST_RESERVED_SIZE,
			.section_index = 1,
			.compress_type = RAM_COMPRESS_SET,
			.set_value     = 0x0,
		},
		{
			/* memory before bl2 */
			.phy_addr      = (void *)CONFIG_1ST_RESERVED_END,
			.section_size  = CONFIG_BL2_IGNORE_ADDR -
					 CONFIG_1ST_RESERVED_END,
			.section_index = 2,
			.compress_type = RAM_COMPRESS_NORMAL,
		},
		{
			/* memory in reserved bl2 */
			.phy_addr      = (void *)CONFIG_BL2_IGNORE_ADDR,
			.section_size  = CONFIG_BL2_IGNORE_SIZE,
			.section_index = 3,
			.compress_type = RAM_COMPRESS_SET,
			.set_value     = 0x0,
		},
		{
			/* segment 4: normal compress */
			.phy_addr      = (void *)CONFIG_SEG4_ADDR,
			.section_size  = CONFIG_COMPRESSED_DATA_ADDR -
					 CONFIG_SEG4_ADDR,
			.section_index = 4,
			.compress_type = RAM_COMPRESS_NORMAL,
		}
	},
};
#endif /* CONFIG_MDUMP_COMPRESS */

