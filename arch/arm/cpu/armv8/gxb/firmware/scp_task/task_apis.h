#ifndef __TASK_APIS_H_
#define __TASK_APIS_H_

void secure_task(void);
void high_task(void);
void low_task(void);

void bss_init(void);

int uart_putc(int c);
void wait_uart_empty(void);
void uart_put_hex(unsigned int data, unsigned bitlen);
int uart_puts(const char *s);

/* #define dbg_print(s,v) */
/* #define dbg_prints(s) */
#define writel(v, addr) (*((volatile unsigned *)addr) = v)
#define readl(addr) (*((volatile unsigned *)addr))

#define dbg_print(s, v) {uart_puts(s); uart_put_hex(v, 32); uart_puts("\n"); }
/* #define dbg_prints(s)  {uart_puts(s);wait_uart_empty();} */
#define dbg_prints(s)  {uart_puts(s); }

void enter_suspend(unsigned int suspend_from);
void get_dvfs_info(unsigned int domain,
		unsigned char *info_out, unsigned int *size_out);
void set_dvfs(unsigned int domain, unsigned int index);
void *memcpy(void *dest, const void *src, unsigned int count);
void *memset(void *s, int c, unsigned int count);
void _udelay(unsigned int us);
unsigned int get_time(void);

void set_wakeup_method(unsigned int method);
#endif
