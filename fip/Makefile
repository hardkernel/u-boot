-include $(buildtree)/include/config/auto.conf
-include $(buildtree)/include/autoconf.mk

AML_USER_KEY := $(srctree)/$(BOARDDIR)/aml-user-key.sig
FIP_BL32_PROCESS =
DDR_FW_NAME := aml_ddr.fw

ifeq ($(CONFIG_AML_BL33_COMPRESS_ENABLE),y)
BL33_COMPRESS_FLAG := --compress lz4
else
BL33_COMPRESS_FLAG :=
endif

ifeq ($(CONFIG_FIP_IMG_SUPPORT),y)
BL3X_SUFFIX := img
else
BL3X_SUFFIX := bin
endif

ifeq ($(CONFIG_AML_SECURE_BOOT_V3),y)
V3_PROCESS_FLAG := --level v3
else
V3_PROCESS_FLAG :=
endif

# BL2 file size 41K, bl21 file size 3K (file size not equal runtime size) = total 44K
# after encrypt process, bl2 add 4K header, cut off 4K tail
# BL2 file size 56K, acs file size 4K = total 60K
# after encrypt process, BL2 add 4K header, cut off 4K tail
# BL30 limit 41K
# BL301 limit 12K
# BL2 limit 56K
# ACS limit 4K, but encrypt tool need 64K bl2.bin, so fix to 8192byte.

define fix_blx
	$(if $(filter "$(strip $(7))","bl30"),
			$(eval blx_bin_limit := 40960)
			$(eval blx01_bin_limit := 13312),
			$(if $(filter "$(strip $(7))","bl2"),
				$(eval blx_bin_limit := 57344)
				$(eval blx01_bin_limit := 4096),,
				$(error $(7))))

	$(eval blx_size := $(shell du -b $(1) | awk '{print int($$1)}'))
	$(if $(filter $(shell expr $(blx_size) \> $(blx_bin_limit)),1),
			$(error "Error: $(7) ($1) too big. $(blx_size) > $(blx_bin_limit)"))

	$(eval zero_size := $(shell expr $(blx_bin_limit) - $(blx_size)))
	$(Q)dd if=/dev/zero of=$(strip $(2)) bs=1 count=$(zero_size) 2> /dev/null
	$(Q)cat $(1) $(2) > $(3)

	$(eval blx_size := $(shell du -b $(4) | awk '{print int($$1)}'))
	$(eval zero_size := $(shell expr $(blx01_bin_limit) - $(blx_size)))
	$(Q)dd if=/dev/zero of=$(strip $(2)) bs=1 count=$(zero_size) 2> /dev/null
	$(Q)cat $(4) $(2) > $(5)
	$(Q)cat $(3) $(5) > $(6)
endef

define encrypt_step
	$(Q)$(buildsrc)/fip/$(SOC)/aml_encrypt_$(SOC) $1
endef

FIP_ARGS := --bl30 $(buildtree)/fip/bl30_new.bin \
	--bl31 $(buildsrc)/fip/$(SOC)/bl31.$(BL3X_SUFFIX) \
	--bl33 $(buildtree)/u-boot.bin

$(buildtree)/fip/fip.bin: FORCE
	$(Q)echo Building $@...
	$(call fix_blx, \
		$(buildsrc)/fip/$(SOC)/bl30.bin, \
		$(buildtree)/fip/zero_tmp, \
		$(buildtree)/fip/bl30_zero.bin, \
		$(buildtree)/scp_task/bl301.bin, \
		$(buildtree)/fip/bl301_zero.bin, \
		$(buildtree)/fip/bl30_new.bin, \
		bl30)
	$(call fix_blx, \
		$(buildsrc)/fip/$(SOC)/bl2.bin, \
		$(buildtree)/fip/zero_tmp, \
		$(buildtree)/fip/bl2_zero.bin, \
		$(buildtree)/$(BOARDDIR)/firmware/acs.bin, \
		$(buildtree)/fip/bl21_zero.bin, \
		$(buildtree)/fip/bl2_new.bin, \
		bl2)
ifeq ($(CONFIG_NEED_BL32),y)
ifneq ($(wildcard $(buildsrc)/fip/$(SOC)/bl32.$(BL3X_SUFFIX)),)
	$(eval FIP_ARGS := $(FIP_ARGS) --bl32 $(buildsrc)/fip/$(SOC)/bl32.$(BL3X_SUFFIX))
	$(eval FIP_BL32_PROCESS := --bl32 $(buildsrc)/fip/$(SOC)/bl32.$(BL3X_SUFFIX).enc)
endif
endif
	$(Q)$(buildsrc)/fip/fip_create $(FIP_ARGS) $@
	$(Q)$(buildsrc)/fip/fip_create --dump $@

	# build final bootloader
	$(Q)cat $(buildtree)/fip/bl2_new.bin $(buildtree)/fip/fip.bin > $(buildtree)/fip/boot_new.bin

ifneq ($(FUSING_FOLDER),)
$(FUSING_FOLDER)/u-boot.bin: $(buildtree)/fip/fip.bin FORCE
	$(Q)echo Building $@...
	@mkdir -p $(FUSING_FOLDER)
ifeq ($(CONFIG_AML_SECURE_BOOT_V3),y)
	$(call encrypt_step, --bl30sig $(V3_PROCESS_FLAG) \
			--input $(buildtree)/fip/bl30_new.bin \
			--output $(buildtree)/fip/bl30_new.bin.g12.enc)
	$(call encrypt_step, --bl3sig --type bl30 $(V3_PROCESS_FLAG) \
			--input $(buildtree)/fip/bl30_new.bin.g12.enc \
			--output $(buildtree)/fip/bl30_new.bin.enc )
	$(call encrypt_step, --bl3sig --type bl31 $(V3_PROCESS_FLAG) \
			--input $(buildsrc)/fip/$(SOC)/bl31.$(BL3X_SUFFIX) \
			--output $(buildtree)/fip/bl31.$(BL3X_SUFFIX).enc)
	$(if $(filter $(FIP_BL32),$(buildsrc)/fip/$(SOC)/bl32.$(BL3X_SUFFIX)), \
			$(call encrypt_step, --bl3sig --type bl32 $(V3_PROCESS_FLAG) \
				--input $(buildsrc)/fip/$(SOC)/bl32.$(BL3X_SUFFIX) \
				--output $(buildtree)/fip/bl32.$(BL3X_SUFFIX).enc))
	$(call encrypt_step, --bl3sig --type bl33 $(V3_PROCESS_FLAG) $(BL33_COMPRESS_FLAG) \
			--input $(buildtree)/u-boot.bin \
			--output $(buildtree)/fip/bl33.bin.enc)
endif
	$(call encrypt_step, --bl2sig \
			--input $(buildtree)/fip/bl2_new.bin \
			--output $(buildtree)/fip/bl2.n.bin.sig)
	$(call encrypt_step,--bootmk $(FIP_BL32_PROCESS) $(V3_PROCESS_FLAG) \
			--bl2 $(buildtree)/fip/bl2.n.bin.sig \
			--bl30 $(buildtree)/fip/bl30_new.bin.enc \
			--bl31 $(buildtree)/fip/bl31.$(BL3X_SUFFIX).enc \
			--bl33 $(buildtree)/fip/bl33.bin.enc \
			--ddrfw1 $(buildsrc)/fip/$(SOC)/ddr4_1d.fw \
			--ddrfw2 $(buildsrc)/fip/$(SOC)/ddr4_2d.fw \
			--ddrfw4 $(buildsrc)/fip/$(SOC)/piei.fw \
			--ddrfw8 $(buildsrc)/fip/$(SOC)/$(DDR_FW_NAME) \
			--output $(FUSING_FOLDER)/u-boot.bin)
ifeq ($(CONFIG_AML_CRYPTO_UBOOT),y)
	$(call encrypt_step, --efsgen --amluserkey $(AML_USER_KEY) \
			--output $(buildtree)/fip/u-boot.bin.encrypt.efuse $(V3_PROCESS_FLAG))
	$(call encrypt_step, --bootsig --aeskey enable --amluserkey $(AML_USER_KEY) \
			--input $(FUSING_FOLDER)/u-boot.bin \
			--output $(buildtree)/fip/u-boot.bin.encrypt $(V3_PROCESS_FLAG))
endif
ifeq ($(CONFIG_AML_CRYPTO_IMG),y)
	$(call encrypt_step, --imgsig --amluserkey $(AML_USER_KEY) \
			--input $(srctree)/$(BOARDDIR)/boot.img \
			--output $(FUSING_FOLDER)/boot.img.encrypt)
endif

fip.bin: $(buildtree)/fip/fip.bin
	$(Q)echo $< is updated.

bootimage: $(FUSING_FOLDER)/u-boot.bin
	$(Q)echo $< is updated.

CLEAN_FILES += $(addprefix $(FUSING_FOLDER)/, u-boot.bin u-boot.bin.sd.bin u-boot.bin.usb.bl2 u-boot.bin.usb.tpl)

distclean:
	$(Q)rm -f $(CLEAN_FILES)
else
bootimage distclean:
endif

PHONY := FORCE
FORCE:

