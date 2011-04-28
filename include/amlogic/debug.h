/*
 * debug.h
 *
 *  Created on: Aug 24, 2011
 *      Author: jerry.yu
 */

#ifndef _AMLOGIC_DEBUG_H_
#define _AMLOGIC_DEBUG_H_
#ifndef CONFIG_ENABLE_NAND_DEBUG
#define CONFIG_ENABLE_NAND_DEBUG 0
#endif
#define DEBUG_LEVEL_ASSERT 	1
#define DEBUG_LEVEL_INFO 	2
#define DEBUG_LEVEL_LOG		3
#define DEBUG_LEVEL_DETAILS 4
#if CONFIG_ENABLE_NAND_DEBUG
#define nanddebug(level,a...) if(level<=CONFIG_ENABLE_NAND_DEBUG){ \
		printf("\033[41m%s +%d func=%s:\033[0m",__FILE__,__LINE__,__func__);	\
		printf(a);printf("\n");	\
		}
#undef assert
#define assert(a)	if((a)==0){printf("%s +%d func=%s: %s false\n",__FILE__,__LINE__,__func__,#a);while(1);};
#define debug_sleep()	asm volatile ("wfi")
#else
#define nanddebug(level,a...)
#ifndef assert
#define assert(a) ((void*)0)
#endif
#endif

#include <linux/types.h>
typedef void (* log_print_cb_t)(uint32_t priv,uint16_t size,void * data);
void amlogic_log_print(void);
void amlogic_log(const char * file, const char * func, uint16_t line,log_print_cb_t cb ,uint32_t priv,uint16_t size_in,void * data);
#if CONFIG_ENABLE_NAND_DEBUG>=DEBUG_LEVEL_LOG
#define debug_log(cb,priv,size,data) amlogic_log(__FILE__,__func__,__LINE__,cb,priv,size,data)
#else
#define debug_log(cb,priv,size,data)
#endif

#endif /* DEBUG_H_ */
