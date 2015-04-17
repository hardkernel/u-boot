#ifndef __GX_SKT_V1_H__
#define __GX_SKT_V1_H__

#include <asm/arch/cpu.h>

//#define CONFIG_AML_MESON  1

//use following switch to enable/disable uboot(TPL) for GXB and Juno
//#define CONFIG_AML_MESON_GX  1

#define CONFIG_VLSI_EMULATOR 1

#define CONFIG_SYS_GENERIC_BOARD  1

#define CONFIG_CMD_BOOTI 1

#define CONFIG_AML_SD_EMMC 1

#ifdef	CONFIG_AML_SD_EMMC
	#define CONFIG_GENERIC_MMC 1
	#define CONFIG_CMD_MMC 1
#endif

#define	CONFIG_PARTITIONS 1

#define CONFIG_AML_VPU 1

/*cortex-a53 cluster is 1, cortex-a57 cluster is 0,
 *  if it is juno board, MPIDR_CLUSTER_MASTER_CORE need define

 * */

#define CONFIG_CMD_MEMORY 1

#if !defined(CONFIG_AML_MESON_GX)
 #define MPIDR_CLUSTER_MASTER_CORE	(1<<8)
#endif


/* Cache Definitions */
#define CONFIG_SYS_DCACHE_OFF
#define CONFIG_SYS_ICACHE_OFF

/* Generic Timer Definitions */
#define COUNTER_FREQUENCY		(0x1800000)	/* 24MHz,it is juno board value */


/*
 * SMP Definitinos
 */
#define CPU_RELEASE_ADDR		secondary_boot_func

#define CONFIG_CONS_INDEX 2
#define CONFIG_BAUDRATE  115200
/*M8 chip serial config*/
#if defined(CONFIG_AML_MESON_GX)
 #define CONFIG_AML_MESON_SERIAL   1
#endif

#ifdef CONFIG_AML_MESON_SERIAL
#define CONFIG_SERIAL_MULTI		1
#endif /*CONFIG_AML_MESON_SERIAL*/

/* PL011 Serial Configuration */
/*#define CONFIG_PL011_SERIAL		1  */
#if !defined(CONFIG_AML_MESON_GX)
 #define CONFIG_PL011_SERIAL
#endif

#ifdef CONFIG_PL011_SERIAL
#undef  CONFIG_CONS_INDEX
#define CONFIG_CONS_INDEX  0
#define CONFIG_SYS_SERIAL2		0x7ff80000  /* SoC UART0 */
#define CONFIG_SYS_SERIAL3		0x7ff70000  /* SoC UART1 */
#define PL011_UART2_CLK_IN_HZ		7273800  /* SoC UART0,UART1 */
#define CONFIG_PL011_CLOCK_2    PL011_UART2_CLK_IN_HZ
#define CONFIG_PL011_CLOCK      CONFIG_PL011_CLOCK_2

#define CONFIG_PL01x_PORTS		{(void *)CONFIG_SYS_SERIAL2,(void *)CONFIG_SYS_SERIAL3}  /*juno board SoC UART0,UART1*/
#endif /*CONFIG_PL011_SERIAL*/



/* Size of malloc() pool */
#define CONFIG_SYS_MALLOC_LEN  (8*1024*1024)

#define CONFIG_SYS_NO_FLASH  1

/* Physical Memory Map */
#define CONFIG_NR_DRAM_BANKS  1

#if !defined(CONFIG_AML_MESON_GX)

#define PHYS_SDRAM_1_BASE			0x80000000UL
#define PHYS_SDRAM_1_SIZE			0x70000000
#define CONFIG_SYS_SDRAM_BASE  		PHYS_SDRAM_1_BASE
#define CONFIG_SYS_LOAD_ADDR		(PHYS_SDRAM_1_BASE + 0x10000000)
//#define CONFIG_SYS_TEXT_BASE  		0xe0000000
//#define CONFIG_SYS_INIT_SP_ADDR		(0x80000000 + 0x7fff0)

#else
//amlogic GXB
#define PHYS_SDRAM_1_BASE			0x00000000UL
#define PHYS_SDRAM_1_SIZE			0x40000000
#define CONFIG_SYS_SDRAM_BASE  		PHYS_SDRAM_1_BASE
//#define CONFIG_SYS_LOAD_ADDR		(PHYS_SDRAM_1_BASE + 0x10000000)
//#define CONFIG_SYS_TEXT_BASE  		0x20000000
#define CONFIG_SYS_INIT_SP_ADDR		(0x20000000)

#endif

#define CONFIG_SYS_CBSIZE		512
#define CONFIG_SYS_PROMPT		SYS_PROMPT
#define CONFIG_SYS_PBSIZE		(CONFIG_SYS_CBSIZE + \
					sizeof(CONFIG_SYS_PROMPT) + 16)


#define CONFIG_SYS_MAXARGS  64
#define CONFIG_BOOTARGS "init=/init console=ttyS0,115200 earlyprintk=aml-uart,0xc81004c0 selinux=0"

#define CONFIG_ENV_IS_NOWHERE  1

#define CONFIG_ENV_SIZE   (64*1024)

#define CONFIG_FIT 1
#define CONFIG_OF_LIBFDT 1
#define CONFIG_ANDROID_BOOT_IMAGE 1
#define CONFIG_SYS_BOOTM_LEN (64<<20) /* Increase max gunzip size*/
#endif

