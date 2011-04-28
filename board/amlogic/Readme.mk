ifeq ($(SRCTREE)/customer, $(wildcard $(SRCTREE)/customer))
help: help_customer
else
help:
endif

	@echo =======================================================================
	@echo The mark in board is "Mesonboard_AML8726-M_V1.1"
	@echo config command: \"make arm_8726m_config\"

	@echo =======================================================================
	@echo The mark in board is "M3_SKT_V1"
	@echo config command: \"make m3_skt_v1_config\"

	@echo =======================================================================
	@echo The mark in board is "WA_M3_REF_V1"
	@echo config command: \"make m3_wa_ref_v1_config\"

	@echo =======================================================================
	@echo The mark in board is "M6_SKT_V1"
	@echo config command: \"make m6_skt_v1_config\"

	@echo =======================================================================
	@echo The mark in board is "M6_REF_V1"
	@echo config command: \"make m6_ref_v1_config\"

	@echo =======================================================================
	@echo The mark in board is "M6_REF_V2"
	@echo config command: \"make m6_ref_v2_config\"

	@echo =======================================================================
	@echo The mark in board is "M6_MBX_V1"
	@echo config command: \"make m6_mbx_v1_config\"

	@echo =======================================================================
	@echo The mark in board is "M6_MBX_V1 with TEE"
	@echo config command: \"make m6_mbx_v1_tee_config\"

	@echo =======================================================================
	@echo The mark in board is "M6_G33_1GB_V2"
	@echo config command: \"make m6_g33_1G_v2_config\"

	@echo =======================================================================
	@echo The mark in board is "M6_G33_512_V2"
	@echo config command: \"make m6_g33_512M_v2_config\"

	@echo =======================================================================
	@echo The mark in board is "M6_MBX_V2"
	@echo config command: \"make m6_mbx_v2_config\"

	@echo =======================================================================
	@echo The mark in board is "M6_MBX_V2 with TEE"
	@echo config command: \"make m6_mbx_v2_tee_config\"

	@echo =======================================================================
	@echo The mark in board is "M6_DONGLE_G35_V1 with TEE"
	@echo config command: \"make m6_dongle_g35_v1_config\"
	
	@echo =======================================================================
	@echo The mark in board is "M6S_SKT_V1", relative to chip M6S
	@echo config command: \"make m6s_skt_v1_config\"

	@echo =======================================================================
	@echo The mark in board is "M6L_SKT_V1", relative to chip M6l
	@echo config command: \"make m6l_skt_v1_config\"

	@echo =======================================================================
	@echo The mark in board is "M6TV_SKT_V1"
	@echo config command: \"make m6tv_skt_v1_config\"

	@echo =======================================================================
	@echo The mark in board is "M6TV_REF_V1"
	@echo config command: \"make m6tv_ref_v1_config\"

	@echo =======================================================================
	@echo The mark in board is "M6TVD_SKT_V1"
	@echo config command: \"make m6tvd_skt_v1_config\"

	@echo =======================================================================
	@echo The mark in board is "M8_SKT_V1"
	@echo config command: \"make m8_skt_v1_config\"

	@echo =======================================================================
	@echo The mark in board is "M8_K200_V1"
	@echo config command: \"make m8_k200_v1_config\"

	@echo =======================================================================
	@echo The mark in board is "M8_K100_2G"
	@echo config command: \"make m8_k100_2G_config\"

	@echo =======================================================================
	@echo The mark in board is "M8_K100_1G"
	@echo config command: \"make m8_k100_1G_config\"

	@echo =======================================================================
	@echo The mark in board is "M8_K200_V1 with TEE"
	@echo config command: \"make m8_k200_v1_tee_config\"

	@echo =======================================================================
	@echo The mark in board is "M8_K101_1G"
	@echo config command: \"make m8_k101_1G_config\"

	@echo =======================================================================
	@echo The mark in board is "M8_K101_512M"
	@echo config command: \"make m8_k101_512M_config\"

	@echo =======================================================================
	@echo The mark in board is "M8_k102_V1"
	@echo config command: \"make m8_k102_v1_config\"

	@echo =======================================================================
	@echo The mark in board is "M6TVD_ref_v1"
	@echo config command: \"make m6tvd_ref_v1_config\"

	@echo =======================================================================
	@echo The mark in board is "M8_k150_V1"
	@echo config command: \"make m8_k150_v1_config\"

	@echo =======================================================================
	@echo The mark in board is "M8_k160_V1"
	@echo config command: \"make m8_k160_v1_config\"

	@echo =======================================================================
	@echo The mark in board is "M8B_SKT_V0"
	@echo config command: \"make m8b_skt_v0_config\"

	@echo =======================================================================
	@echo The mark in board is "M8B_SKT_V1"
	@echo config command: \"make m8b_skt_v1_config\"

	@echo =======================================================================
	@echo The mark in board is "M8B_M100_1G"
	@echo config command: \"make m8b_m100_1G_config\"

	@echo =======================================================================
	@echo The mark in board is "M8B_M200_1G"
	@echo config command: \"make m8b_m200_1G_config\"

	@echo =======================================================================
	@echo The mark in board is "M8B_M200_1G with TEE"
	@echo config command: \"make m8b_m200_1G_tee_config\"

	@echo =======================================================================
	@echo The mark in board is "M8B_M101_512M"
	@echo config command: \"make m8b_m101_512M_config\"

	@echo =======================================================================
	@echo The mark in board is "M8B_M102_1G"
	@echo config command: \"make m8b_m102_1G_config\"

	@echo =======================================================================
	@echo The mark in board is "M8B_M201_1G"
	@echo config command: \"make m8b_m201_1G_config\"

	@echo =======================================================================
	@echo The mark in board is "M8B_M201_1G with TEE"
	@echo config command: \"make m8b_m201_1G_tee_config\"

	@echo =======================================================================
	@echo The mark in board is "M8B_M202_512M"
	@echo config command: \"make m8b_m202_512M_config\"
	
	@echo =======================================================================
	@echo The mark in board is "M8B_FT_V1"
	@echo config command: \"make m8b_ft_v1_config\"

	@echo =======================================================================
	@echo The mark in board is "M8M2_SKT_V1"
	@echo config command: \"make m8m2_skt_v1_config\"

	@echo =======================================================================
	@echo The mark in board is "M8M2_N200_V1"
	@echo config command: \"make m8m2_n200_v1_config\"

	@echo =======================================================================
	@echo The mark in board is "M8M2_N100_2G"
	@echo config command: \"make m8m2_n100_2G_config\"

	@echo =======================================================================
	@echo The mark in board is "M8M2_N101_1G"
	@echo config command: \"make m8m2_n101_1G_config\"

	@echo
sinclude $(wildcard $(SRCTREE)/customer/board/Readme.mk)
