#ifndef _CACHE_L2X0_H_
#define _CACHE_L2X0_H_
#include "system.h"
#include <asm/arch/cache-l2x0.h>
#define L2X0_CACHE_ID			(L2X0_BASE+0x000)
#define L2X0_CACHE_TYPE			(L2X0_BASE+0x004)
#define L2X0_CTRL			    (L2X0_BASE+0x100)
#define L2X0_AUX_CTRL			(L2X0_BASE+0x104)
#define L2X0_TAG_LATENCY_CTRL	(L2X0_BASE+0x108)
#define L2X0_DATA_LATENCY_CTRL	(L2X0_BASE+0x10C)
#define L2X0_EVENT_CNT_CTRL		(L2X0_BASE+0x200)
#define L2X0_EVENT_CNT1_CFG		(L2X0_BASE+0x204)
#define L2X0_EVENT_CNT0_CFG		(L2X0_BASE+0x208)
#define L2X0_EVENT_CNT1_VAL		(L2X0_BASE+0x20C)
#define L2X0_EVENT_CNT0_VAL		(L2X0_BASE+0x210)
#define L2X0_INTR_MASK			(L2X0_BASE+0x214)
#define L2X0_MASKED_INTR_STAT	(L2X0_BASE+0x218)
#define L2X0_RAW_INTR_STAT		(L2X0_BASE+0x21C)
#define L2X0_INTR_CLEAR			(L2X0_BASE+0x220)
#define L2X0_CACHE_SYNC			(L2X0_BASE+0x730)
#define L2X0_INV_LINE_PA		(L2X0_BASE+0x770)
#define L2X0_INV_WAY			(L2X0_BASE+0x77C)
#define L2X0_CLEAN_LINE_PA		(L2X0_BASE+0x7B0)
#define L2X0_CLEAN_LINE_IDX		(L2X0_BASE+0x7B8)
#define L2X0_CLEAN_WAY			(L2X0_BASE+0x7BC)
#define L2X0_CLEAN_INV_LINE_PA	(L2X0_BASE+0x7F0)
#define L2X0_CLEAN_INV_LINE_IDX	(L2X0_BASE+0x7F8)
#define L2X0_CLEAN_INV_WAY		(L2X0_BASE+0x7FC)
#define L2X0_LOCKDOWN_WAY_D		(L2X0_BASE+0x900)
#define L2X0_LOCKDOWN_WAY_I		(L2X0_BASE+0x904)
#define L2X0_TEST_OPERATION		(L2X0_BASE+0xF00)
#define L2X0_LINE_DATA			(L2X0_BASE+0xF10)
#define L2X0_LINE_TAG			(L2X0_BASE+0xF30)
#define L2X0_DEBUG_CTRL			(L2X0_BASE+0xF40)



void cache_sync(void);
void l2x0_clean_line(unsigned long addr);
void l2x0_flush_line(unsigned long addr);
void l2x0_inv_line(unsigned long addr);
void l2x0_inv_all(void);
void l2x0_clean_all(void);
void l2x0_clean_inv_all(void);
void l2x0_wait_inv(void);
void l2x0_wait_clean(void);
void l2x0_wait_flush(void);
void l2x0_invalid_range(unsigned long start, unsigned long end);
void l2x0_clean_range(unsigned long start, unsigned long end);
void l2x0_flush_range(unsigned long start, unsigned long end);
int l2x0_status(void);
void l2x0_enable(void);
void l2x0_disable(void);



#endif