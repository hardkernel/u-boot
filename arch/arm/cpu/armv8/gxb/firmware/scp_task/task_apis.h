#ifndef __TASK_APIS_H_
#define __TASK_APIS_H_

void secure_task(void);
void high_task(void);
void low_task(void);

void bss_init(void);

void uart_puts(const char *s);
void wait_uart_empty(void);
void uart_put_hex(unsigned int data, unsigned bitlen);

/* #define dbg_print(s,v) */
/* #define dbg_prints(s) */

#define dbg_print(s, v) {uart_puts(s); uart_put_hex(v, 32); uart_puts("\n"); }
/* #define dbg_prints(s)  {uart_puts(s);wait_uart_empty();} */
#define dbg_prints(s)  {uart_puts(s); }

void enter_suspend(void);

#endif
