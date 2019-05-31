SOURCES		+=	acs.c				\
			acs_entry.S

ifdef CONFIG_MDUMP_COMPRESS
SOURCES		+=	ramdump.c
endif

LINKERFILE_T		:=	acs.ld.S
