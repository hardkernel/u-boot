/******************************************************************************
 * Copyright ARC International (www.arc.com) 2007-2009
 *
 * Vineetg: Mar 2009 (Supporting 2 levels of Interrupts)
 *  -irqs_enabled( ) need to consider both L1 and L2 
 *  -local_irq_enable shd be cognizant of current IRQ state
 *    and must not re-enable lower priorty IRQs
 *   It is lot more involved now and needs to be written in "C"
 *
 * Vineetg: Feb 2009
 *  -schedular hook prepare_arch_switch( ) is now macro instead of inline func
 *   so that builtin_ret_addr( ) can correctly identify the caller of schdule()
 *
 * Vineetg: Oct 3rd 2008
 *  -Got rid of evil cli()/sti()
 *
 *****************************************************************************/
/******************************************************************************
 * Copyright Codito Technologies (www.codito.com) Oct 01, 2004
 * 
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 *****************************************************************************/

/*
 *  linux/include/asm-arc/system.h
 *
 *  Copyright (C) 
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 * Authors : Amit Bhor, Sameer Dhavale
 */

#ifndef __ASM_ARC_SYSTEM_H
#define __ASM_ARC_SYSTEM_H

#include <asm/arcregs.h>
#include <asm/ptrace.h>
#ifdef  __MW__
#define inline __inline
#endif

//#ifndef __ASSEMBLY__

//#ifdef __KERNEL__


/******************************************************************
 * IRQ Control Macros
 ******************************************************************/

/*
 * Save IRQ state and disable IRQs
 */
#ifndef  __MW__
#define local_irq_save(x)                       \
    __asm__ __volatile__ (                      \
    "lr r20, [status32] \n\t"                   \
    "mov    %0, r20 \n\t"                       \
    "and    r20, r20, %1 \n\t"                  \
    "flag   r20 \n\t"                           \
    :"=r" (x)                                   \
    :"n" (~(STATUS_E1_MASK | STATUS_E2_MASK))   \
    :"r20", "memory");  
#else
#define local_irq_save(x)                       \
    __asm__ __volatile__ (                      \
    "lr %r20, [0x0a] \n\t"                   \
    "mov    %0, %r20 \n\t"                       \
    "and    %r20, %r20, %1 \n\t"                  \
    "flag   %r20 \n\t"                           \
    :"=r" (x)                                   \
    :"n" (~(STATUS_E1_MASK | STATUS_E2_MASK))   \
    :"r20", "memory");  

#endif

/*
 * Conditionally Enable IRQs
 */
extern void local_irq_enable(void); 

/*
 * Unconditionally Disable IRQs
 */
#define local_irq_disable()                     \
    __asm__ __volatile__ (                      \
    "lr r20, [status32] \n\t"                   \
    "and    r20, r20, %0 \n\t"                  \
    "flag r20   \n\t"                           \
    :                                           \
    :"n" (~(STATUS_E1_MASK | STATUS_E2_MASK))   \
    :"r20");    

/*
 * restore saved IRQ state
 */
#define local_irq_restore(x)    \
    __asm__ __volatile__ (      \
    "flag   %0"                 \
    :                           \
    :"r" (x)                    \
    );

/*
 * save IRQ state
 */
#ifndef  __MW__
#define local_save_flags(x)     \
    __asm__ __volatile__ (      \
    "lr r20, [status32] \n\t"   \
    "mov    %0, r20 \n\t"       \
    :"=r" (x)                   \
    :                           \
    :"r20", "memory")  
#else
#define local_save_flags(x)     \
    __asm__ __volatile__ (      \
    "lr %r20, [0x0a] \n\t"   \
    "mov    %0, %r20 \n\t"       \
    :"=r" (x)                   \
    :                           \
    :"r20", "memory")  

#endif
/*
 * Query IRQ state
 */
static inline int irqs_disabled(void)
{
    unsigned long flags;
    local_save_flags(flags);
    return (!(flags & (STATUS_E1_MASK 
#ifdef CONFIG_ARCH_ARC_LV2_INTR
                        | STATUS_E2_MASK
#endif
            )));
}

/* 
 * mask/unmask an interrupt (@x = IRQ bitmap) 
 * e.g. to Disable IRQ 3 and 4, pass 0x18
 *
 * mask = disable IRQ = CLEAR bit in AUX_I_ENABLE
 * unmask = enable IRQ = SET bit in AUX_I_ENABLE
 */

#define mask_interrupt(x)  __asm__ __volatile__ (   \
    "lr     r19, [status32] \n\t"                   \
    "lr r20, [status32] \n\t"                       \
    "and    r20, r20, %1 \n\t"                      \
    "flag   r20 \n\t"                               \
    "lr r20, [auxienable] \n\t"                     \
    "and    r20, r20, %0 \n\t"                      \
    "sr     r20,[auxienable] \n\t"                  \
    "flag   r19 \n\t"                               \
    :                                               \
    :"r" (~(x)),                                    \
    "n" (~(STATUS_E1_MASK | STATUS_E2_MASK))        \
    :"r19", "r20", "memory")
#ifndef  __MW__
#define unmask_interrupt(x)  __asm__ __volatile__ ( \
    "lr     r19, [status32] \n\t"                   \
    "lr r20, [status32] \n\t"                       \
    "and    r20, r20, %1 \n\t"                      \
    "flag   r20 \n\t"                               \
    "lr r20, [auxienable] \n\t"                     \
    "or     r20, r20, %0 \n\t"                      \
    "sr     r20, [auxienable] \n\t"                 \
    "flag   r19 \n\t"                               \
    :                                               \
    :"r" (x),  "n" (STATUS_E1_MASK | STATUS_E2_MASK)\
    :"r19", "r20", "memory")
#else
#define unmask_interrupt(x)  __asm__ __volatile__ ( \
    "lr     %r19, [0x0a] \n\t"                   \
    "lr %r20, [0x0a] \n\t"                       \
    "and    %r20, %r20, %1 \n\t"                      \
    "flag   %r20 \n\t"                               \
    "lr %r20, [auxienable] \n\t"                     \
    "or     %r20, %r20, %0 \n\t"                      \
    "sr     %r20, [auxienable] \n\t"                 \
    "flag   %r19 \n\t"                               \
    :                                               \
    :"r" (x),  "n" (STATUS_E1_MASK | STATUS_E2_MASK)\
    :"r19", "r20", "memory")

#endif

/******************************************************************
 * Barriers
 ******************************************************************/

//TODO-vineetg: Need to see what this does, dont we need sync anywhere
#define mb() __asm__ __volatile__ ("" : : : "memory")
#define rmb() mb()
#define wmb() mb()
#define set_mb(var, value)  do { var = value; mb(); } while (0)
#define set_wmb(var, value) do { var = value; wmb(); } while (0)

/* TODO-vineetg verify the correctness of macros here */
#ifdef CONFIG_SMP
#define smp_mb()        mb()
#define smp_rmb()       rmb()
#define smp_wmb()       wmb()
#else
#define smp_mb()        barrier()
#define smp_rmb()       barrier()
#define smp_wmb()       barrier()
#endif 

#define smp_read_barrier_depends()      do { } while(0)

/******************************************************************
 * Arch Depenedent Context Switch Macro  called by sched
 * This in turn calls the regfile switching macro __switch_to ( )
 ******************************************************************/
struct task_struct; // to prevent cyclic dependencies

/* switch_to macro based on the ARM implementaion */
extern struct task_struct *__switch_to(struct task_struct *prev, 
                                    struct task_struct *next);

#define switch_to(prev, next, last)         \
{                                           \
    do {                                    \
        last = __switch_to( prev, next);    \
        mb();                               \
                                            \
    }while (0);                             \
}   

/* Hook into Schedular to be invoked prior to Context Switch
 *  -If ARC H/W profiling enabled it does some stuff
 *  -If event logging enabled it takes a event snapshot
 *  
 *  Having a funtion would have been cleaner but to get the correct caller
 *  (from __builtin_return_address) it needs to be inline
 */

/* Things to do for event logging prior to Context switch */
#ifdef CONFIG_ARC_DBG_EVENT_TIMELINE
#define PREP_ARCH_SWITCH_ACT1(next)                                 \
do {                                                                \
    if (next->mm)                                                   \
        take_snap(SNAP_PRE_CTXSW_2_U,                               \
                      (unsigned int) __builtin_return_address(0),   \
                      current_thread_info()->preempt_count);        \
    else                                                            \
        take_snap(SNAP_PRE_CTXSW_2_K,                               \
                      (unsigned int) __builtin_return_address(0),   \
                      current_thread_info()->preempt_count);        \
}                                                                   \
while(0)
#else
#define PREP_ARCH_SWITCH_ACT1(next)
#endif


/* Things to do for hardware based profiling prior to Context Switch */
#ifdef CONFIG_ARC_PROFILING
extern void arc_ctx_callout(struct task_struct *next);
#define PREP_ARCH_SWITCH_ACT2(next)    arc_ctx_callout(next)
#else
#define PREP_ARCH_SWITCH_ACT2(next)
#endif

/* This def is the one used by schedular */
#define prepare_arch_switch(next)   \
do {                                \
    PREP_ARCH_SWITCH_ACT1(next);     \
    PREP_ARCH_SWITCH_ACT2(next);    \
}                                   \
while(0)


/******************************************************************
 * Miscll stuff
 ******************************************************************/

/*
 * On SMP systems, when the scheduler does migration-cost autodetection,
 * it needs a way to flush as much of the CPU's caches as possible.
 *
 * TODO: fill this in!
 */
static inline void sched_cacheflush(void)
{
}
#ifndef __ARC600__
extern inline unsigned long __xchg (unsigned long with,
                                    __volatile__ void *ptr, int size)
{
    __asm__ __volatile__ (" ex  %0, [%1]"
                  : "=r" (with),"=r"(ptr)
                  : "0" (with), "1" (ptr)   
                  : "memory" );

    return (with);
}

#define xchg(ptr, with) \
  ((__typeof__ (*(ptr)))__xchg ((unsigned long)(with), (ptr), sizeof (*(ptr))))
#endif
#define arch_align_stack(x) (x)

/******************************************************************
 * Piggyback stuff
 * #defines/headers to be made avail to rest of code w/o explicit include
 * e.g. to call event log macros from any kernel file w/o including 
 *     eventlog.h in that file
 ******************************************************************/




void show_stacktrace(struct task_struct *tsk, struct pt_regs *regs);
void raw_printk(const char *str, unsigned int num);
void raw_printk5(const char *str, unsigned int n1, unsigned int n2, 
                    unsigned int n3, unsigned int n4);

static inline void arch_sleep(void)
{ 
__asm__ ("sleep");
}

static inline void arch_halt(void)
{ 
__asm__ ("flag 1");
}


//#endif /*__KERNEL__*/

//#else  /* !__ASSEMBLY__ */

//#include <asm/event-log.h>  // event log from Assembly

//#endif /* __ASSEMBLY__ */


#endif /* ASM_ARC_SYSTEM_H */
