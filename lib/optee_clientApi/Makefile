#Copyright 2012 The Chromium Authors
#
# SPDX-License-Identifier:	GPL-2.0+
#

obj-y += OpteeClientMem.o
obj-y += OpteeClientApiLib.o
obj-y += OpteeClientInterface.o
obj-y += OpteeClientSMC.o
obj-y += OpteeClientRPC.o
obj-y += tee_smc-arm64.o

ifdef CONFIG_OPTEE_V1
obj-y += OpteeClientRkFs.o
endif

ifdef CONFIG_OPTEE_V2
obj-y += OpteeClientRkFs-v2.o
endif

