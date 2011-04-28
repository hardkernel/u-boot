#ifndef __ARCH_MESON_PLAT_CPU_H__
#define __ARCH_MESON_PLAT_CPU_H__

#include <asm/cpu_id.h>

#define MESON_CPU_TYPE_MESON1		0x10
#define MESON_CPU_TYPE_MESON2		0x20
#define MESON_CPU_TYPE_MESON3		0x30
#define MESON_CPU_TYPE_MESON6		0x60
#define MESON_CPU_TYPE_MESON6TV		0x70
#define MESON_CPU_TYPE_MESON6TVD	0x75
#define MESON_CPU_TYPE_MESON8		0x80
#define MESON_CPU_TYPE_MESON8B		0x8B
#define MESON_CPU_TYPE_MESON8M2		0x8C

//set watchdog timer by ms
#define AML_WATCH_DOG_SET(time) \
	writel(0, P_WATCHDOG_RESET); \
	writel((((int)(time * 1000 / AML_WATCHDOG_TIME_SLICE)) | \
	(1<<AML_WATCHDOG_ENABLE_OFFSET) | \
	(AML_WATCHDOG_CPU_RESET_CNTL<<AML_WATCHDOG_CPU_RESET_OFFSET)), P_WATCHDOG_TC);

//disable watchdog
#define AML_WATCH_DOG_DISABLE() \
	writel(0, P_WATCHDOG_TC); \
	writel(0, P_WATCHDOG_RESET);

//start watchdog immediately
#define AML_WATCH_DOG_START() \
	do{ \
		writel(0, P_WATCHDOG_RESET); \
		writel((10|((1<<AML_WATCHDOG_ENABLE_OFFSET)| \
			(AML_WATCHDOG_CPU_RESET_CNTL<<AML_WATCHDOG_CPU_RESET_OFFSET))), P_WATCHDOG_TC); \
		while(1); \
	}while(0);


//Amlogic profile feature, for uboot TPL performance analysis
//2014.05.14
//remark : how to use this feature
//         1. add following variable declaration each *.c file, and the definition 
//             is locate in uboot/arch/arm/lib/board.c
//               #if defined(AML_UBOOT_LOG_PROFILE)
//               extern int __g_nTE1_4BC722B3__ ;
//               extern int __g_nTE2_4BC722B3__ ;
//               extern int __g_nTEFlag_4BC722B3__;
//               extern int __g_nTStep_4BC722B3__;
//               #endif //AML_UBOOT_LOG_PROFILE
//         2. use AML_LOG_INIT(T) to setup the environment
//         3. use AML_LOG_TE(T) to print TimerE for performance analysis
//             3.1 you need to co-work with the uart log and source file (with line number)
//         4. if not define AML_UBOOT_LOG_PROFILE and no any side effect for TPL(code size,performance)
//             4.1 define the AML_UBOOT_LOG_PROFILE in each uboot config file, e.g m8_k200_v1.h
//         5. reference : uboot/common/main.c and uboot/common/cmd_bootm.c

#if defined(AML_UBOOT_LOG_PROFILE)
#define AML_LOG_INIT(T) do{ int nTempA,nTempB;\
	nTempA = readl(0xc1100000+(0x2655<<2));AML_LOG_TE(T);nTempB=readl(0xc1100000+(0x2655<<2));__g_nTStep_4BC722B3__ = (nTempB-nTempA)-100;\
	printf("\n%s: log unit use %d us\n",T,__g_nTStep_4BC722B3__);\
	}while(0);

#define AML_LOG_TE(T) do{\
	if(__g_nTEFlag_4BC722B3__)	{__g_nTE2_4BC722B3__=__g_nTE1_4BC722B3__;__g_nTE1_4BC722B3__ = readl(0xc1100000+(0x2655<<2)); }else \
		{__g_nTE1_4BC722B3__ = __g_nTE2_4BC722B3__; __g_nTE2_4BC722B3__ = readl(0xc1100000+(0x2655<<2));}\
		__g_nTEFlag_4BC722B3__ != __g_nTEFlag_4BC722B3__;	printf("\n%s-Ln%04d: %08d - %08d\n",T,\
		__LINE__,__g_nTEFlag_4BC722B3__ ? (__g_nTE1_4BC722B3__-__g_nTE2_4BC722B3__-__g_nTStep_4BC722B3__) : \
		(__g_nTE2_4BC722B3__ - __g_nTE1_4BC722B3__-__g_nTStep_4BC722B3__),__g_nTEFlag_4BC722B3__ ? __g_nTE1_4BC722B3__: __g_nTE2_4BC722B3__);\
	}while(0);
#else

#define AML_LOG_INIT(T)

#define AML_LOG_TE(T)

#endif

#endif
