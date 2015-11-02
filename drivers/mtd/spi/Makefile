#
# (C) Copyright 2006
# Wolfgang Denk, DENX Software Engineering, wd@denx.de.
#
# SPDX-License-Identifier:	GPL-2.0+
#

obj-$(CONFIG_DM_SPI_FLASH) += sf-uclass.o

ifdef CONFIG_AMLOGIC_SPI_FLASH
obj-$(CONFIG_SPI_FLASH)	+= spi_flash_amlogic.o
else
obj-$(CONFIG_SPI_FLASH)	+= spi_flash.o
endif
obj-$(CONFIG_SPI_FLASH_ATMEL)	+= atmel.o
obj-$(CONFIG_SPI_FLASH_EON)	+= eon.o
obj-$(CONFIG_SPI_FLASH_MACRONIX)	+= macronix.o
obj-$(CONFIG_SPI_FLASH_SPANSION)	+= spansion.o
obj-$(CONFIG_SPI_FLASH_SST)	+= sst.o
obj-$(CONFIG_SPI_FLASH_STMICRO)	+= stmicro.o
obj-$(CONFIG_SPI_FLASH_WINBOND)	+= winbond.o
obj-$(CONFIG_SPI_FRAM_RAMTRON)	+= ramtron.o
obj-$(CONFIG_SPI_M95XXX) += eeprom_m95xxx.o
obj-$(CONFIG_SPI_FLASH_GIGADEVICE) += gigadevice.o
obj-$(CONFIG_SPI_FLASH_PMDEVICE) += pmdevice.o
obj-$(CONFIG_SPI_NOR_SECURE_STORAGE) += spi_secure_storage.o
obj-$(CONFIG_SPI_FLASH_ESMT) += esmt.o
