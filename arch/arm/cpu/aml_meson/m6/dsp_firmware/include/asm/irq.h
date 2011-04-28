#ifndef DSP_IRQ_HEADERS
#define  DSP_IRQ_HEADERS

#ifndef NULL
#define NULL ((void *)0)
#endif
    	
#define dsp_irq_disable()                     \
    __asm__ __volatile__ (                      \
    "lr r20, [status32] \n\t"                   \
    "and    r20, r20, %0 \n\t"                  \
    "flag r20   \n\t"                           \
    :                                           \
    :"n" (~(STATUS_E1_MASK | STATUS_E2_MASK))   \
    :"r20");    
#ifndef  __MW__
#define dsp_irq_enable()                     \
    __asm__ __volatile__ (                      \
    "lr r20, [status32] \n\t"                   \
    "or    r20, r20, %0 \n\t"                  \
    "flag r20   \n\t"                           \
    :                                           \
    :"n" ((STATUS_E1_MASK | STATUS_E2_MASK))   \
    :"r20");  
#else
#define dsp_irq_enable()                     \
    __asm__ __volatile__ (                      \
    "lr %r20, [0x0a] \n\t"                   \
    "or    %r20, %r20, %0 \n\t"                  \
    "flag %r20   \n\t"                           \
    :                                           \
    :"n" ((STATUS_E1_MASK | STATUS_E2_MASK))   \
    :"r20");  

#endif
  
typedef int (*irq_func_t)(unsigned long);
struct dsp_irq_stuct
{
	char 		*name;
	irq_func_t 	func;
	unsigned long 	args;
	unsigned long poll_num;
};
void dsp_irq_init(void );
int  dsp_request_irq(int irq,irq_func_t fn,char *name,unsigned long args);
#endif
