/*

 *
 */

#ifndef _CPU_H
#define _CPU_H
//#include <config.h>
//#include <asm/plat-cpu.h>
//#include <asm/arch/ddr.h>

#define CONFIG_AML_MESON 1
#define CONFIG_AML_MESON_GX 1

#define CONFIG_SYS_TEXT_BASE  		0x20000000
#define CONFIG_SYS_LOAD_ADDR		(PHYS_SDRAM_1_BASE + CONFIG_SYS_TEXT_BASE)

#endif /* _CPU_H */
