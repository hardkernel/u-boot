/***********************************************
**********Amlogic Configurable SPL**************
***********************************************/

#ifndef __ACS_H
#define __ACS_H

#ifndef __ASSEMBLY__
struct acs_setting{
		char				acs_magic[4];	//acs setting magic word, make sure this piece of data was right.
		unsigned int		chip_type;		//chip type, for PC tool use.
							//chip type define, m3:0x21, m6:0x22, m6tv:0x23, m6tvlite:0x24, m8:0x25
		unsigned int		version;		//version of acs_setting struct, for PC tool use.
		unsigned int		acs_set_length;	//length of current struct.

		//ddr setting part, 16 bytes
		char				ddr_magic[4];		//magic word to indicate that following 12 bytes was ddr setting.
		unsigned int		ddr_set_version;	//struct version, for PC tool use.
		unsigned int		ddr_set_length;		//length of ddr struct.
		unsigned int		ddr_set_addr;		//address of ddr setting.

		//pll setting part, 16 bytes
		char				pll_magic[4];
		unsigned int		pll_set_version;
		unsigned int		pll_set_length;
		unsigned int		pll_set_addr;

		//store partition table setting part, 16 bytes
		char				partition_table_magic[4];
		unsigned int		partition_table_version;
		unsigned int		partition_table_length;
		unsigned int		partition_table_addr;

		//store configs setting part, 16 bytes
		char				store_config_magic[4];
		unsigned int 		store_config_version;
		unsigned int		store_config_length;
		unsigned int		store_config_addr;
		
}__attribute__ ((packed));

#endif
#endif
