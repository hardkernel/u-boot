hostprogs-y := amlbootsig unamlbootsig amlinfo
always := $(hostprogs-y)

COMMON_CFLAGS := -g -I/usr/include/openssl

HOSTCFLAGS_amlbootsig.o := $(COMMON_CFLAGS)
HOSTLOADLIBES_amlbootsig = -lcrypto
amlbootsig-objs := amlbootsig.o

HOSTCFLAGS_unamlbootsig.o := $(COMMON_CFLAGS)
unamlbootsig-objs := unamlbootsig.o

HOSTCFLAGS_amlinfo.o := $(COMMON_CFLAGS)
amlinfo-objs := amlinfo.o
