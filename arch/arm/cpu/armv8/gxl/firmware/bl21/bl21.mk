SOURCES		+=	bl21_main.c						\
				${ARCH}/bl21_entrypoint.S				\
				serial.c						\
				timer.c

ifeq (${ARCH},aarch32)
SOURCES		+=	aarch32/arm32_aeabi_divmod.c	\
				aarch32/arm32_aeabi_divmod_a32.S
endif

LINKERFILE_T		:=	bl21.ld.S
