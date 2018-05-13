SOURCES		+=	bl21_main.c		\
			bl21_entrypoint.S	\
			serial.c		\
			timer.c

ifdef CONFIG_MDUMP_COMPRESS
SOURCES		+=	ramdump.c
endif

LINKERFILE_T		:=	bl21.ld.S
