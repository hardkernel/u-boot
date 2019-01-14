
obj-y	:= clock.o sdio.o gpio.o
obj-y	+= usb.o
obj-y   += bl31_apis.o
obj-y	+= watchdog.o
obj-$(CONFIG_AML_HDMITX20) += hdmitx20/
obj-y	+= timer.o
obj-y	+= mailbox.o
obj-y   += gate_init.o
ifndef CONFIG_ODROID_COMMON
obj-y   += power_cal.o
endif
obj-$(CONFIG_CMD_PLLTEST)	+= pll.o
