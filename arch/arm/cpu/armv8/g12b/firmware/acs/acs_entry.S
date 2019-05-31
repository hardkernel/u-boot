
	.globl	acs_entry

acs_entry:
	.word 0
	.word __acs_set
#ifdef CONFIG_MDUMP_COMPRESS
	.word	__ramdump_data
#else
	.word	0x0
#endif