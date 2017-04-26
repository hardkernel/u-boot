#ifndef __AML_IRBLATER_H
#define __AML_IRBLATER_H

#define MAX_WINDOWS_LEN 512
struct aml_irblaster_drv_s {
	unsigned int protocol;
	unsigned int frequency;
	unsigned int sendvalue;
	unsigned int windows[MAX_WINDOWS_LEN];
	unsigned int windows_num;
	unsigned int dutycycle;
	unsigned int openflag;
	int (*open)(void);
	int (*close)(void);
	int (*test)(unsigned int);
	int (*send)(unsigned int);
	int (*setprotocol)(char *);
	const char *(*getprocotol)(void);
	int (*setfrequency)(unsigned int);
	unsigned int (*getfrequency)(void);
	void (*print_windows)(void);
	int (*read_reg)(volatile unsigned int *, unsigned int);
	int (*write_reg)(volatile unsigned int *, unsigned int);
};

struct aml_irblaster_drv_s *aml_irblaster_get_driver(void);
#endif


