/*
 * Copyright (c) 2015 Amlogic, Inc. All rights reserved.
 *
 * This source code is subject to the terms and conditions defined in the
 * file 'LICENSE' which is part of this source code package.
 *
 *
 * Amlogic FIP image relate defines
 * Author: xiaobo.gu@amlogic.com
 * Created Time: 2015.04.22
 *
 */

#include <arch.h>
#include <arch_helpers.h>
#include <fip.h>
#include <storage.h>
#include <string.h>
#include <platform.h>
#include <platform_def.h>
#include <stdio.h>
#include <config.h>
#include <storage.h>
#include <sha2.h>
#include <mailbox.h>
#include <asm/arch/romboot.h>
#include <cache.h>
#include <fip.h>

void bl2_load_image(void){
	//meminfo_t *bl2_tzram_layout;
	bl31_params_t *bl2_to_bl31_params;
	entry_point_info_t *bl31_ep_info;
	//meminfo_t bl33_mem_info;

	/*load fip header*/
	aml_fip_header_t *fip_header;
	fip_header = (aml_fip_header_t *)(uint64_t)FM_FIP_HEADER_LOAD_ADDR;
	storage_load(BL2_SIZE, (uint64_t)fip_header, sizeof(aml_fip_header_t), "fip header");

	/*load and process bl30*/
	image_info_t bl30_image_info;
	entry_point_info_t bl30_ep_info;
	storage_load(BL2_SIZE + (fip_header->bl30_offset), FM_BL30_LOAD_ADDR, (fip_header->bl30_size), "bl30");
	parse_blx(&bl30_image_info, &bl30_ep_info, FM_BL30_LOAD_ADDR, (fip_header->bl30_size));
	/*process bl30*/
	process_bl30(&bl30_image_info, &bl30_ep_info);
	printf("BL30 addr: 0x%8x\n", bl30_image_info.image_base);
	printf("BL30 size: 0x%8x\n", bl30_image_info.image_size);

	/*load and process bl31*/
	bl2_to_bl31_params = bl2_plat_get_bl31_params();
	bl31_ep_info = bl2_plat_get_bl31_ep_info();
	/* Set the X0 parameter to bl31 */
	bl31_ep_info->args.arg0 = (unsigned long)bl2_to_bl31_params;
	storage_load(BL2_SIZE + (fip_header->bl31_offset), FM_BL31_LOAD_ADDR, (fip_header->bl31_size), "bl31");
	parse_blx(bl2_to_bl31_params->bl31_image_info, bl31_ep_info, FM_BL31_LOAD_ADDR, (fip_header->bl31_size));
	bl2_plat_set_bl31_ep_info(bl2_to_bl31_params->bl31_image_info, bl31_ep_info);
	printf("BL31 addr: 0x%8x\n", bl2_to_bl31_params->bl31_image_info->image_base);
	printf("BL31 size: 0x%8x\n", bl2_to_bl31_params->bl31_image_info->image_size);

#if (NEED_BL32)
	/*
	 * Load the BL32 image if there's one. It is upto to platform
	 * to specify where BL32 should be loaded if it exists. It
	 * could create space in the secure sram or point to a
	 * completely different memory.
	 *
	 * If a platform does not want to attempt to load BL3-2 image
	 * it must leave NEED_BL32=0
	 */
	meminfo_t bl32_mem_info;
	bl2_plat_get_bl32_meminfo(&bl32_mem_info);
	storage_load(BL2_SIZE + fip_header->bl32_offset, FM_BL32_LOAD_ADDR, fip_header->bl32_size, "bl32");
	parse_blx(bl2_to_bl31_params->bl32_image_info, bl2_to_bl31_params->bl32_ep_info,
				FM_BL32_LOAD_ADDR, fip_header->bl32_size);
	bl2_plat_set_bl32_ep_info(bl2_to_bl31_params->bl32_image_info, bl2_to_bl31_params->bl32_ep_info);
	printf("BL32 addr: 0x%8x\n", bl2_to_bl31_params->bl32_image_info->image_base);
	printf("BL32 size: 0x%8x\n", bl2_to_bl31_params->bl32_image_info->image_size);
#endif /* NEED_BL32 */

	/*load and process bl33*/
	storage_load(BL2_SIZE + fip_header->bl33_offset, FM_BL33_LOAD_ADDR, fip_header->bl33_size, "bl33");
	parse_blx(bl2_to_bl31_params->bl33_image_info, bl2_to_bl31_params->bl33_ep_info,
				FM_BL33_LOAD_ADDR, fip_header->bl33_size);
	//bl2_plat_get_bl33_meminfo(&bl33_mem_info);
	bl2_plat_set_bl33_ep_info(bl2_to_bl31_params->bl33_image_info, bl2_to_bl31_params->bl33_ep_info);
	printf("BL33 addr: 0x%8x\n", bl2_to_bl31_params->bl33_image_info->image_base);
	printf("BL33 size: 0x%8x\n", bl2_to_bl31_params->bl33_image_info->image_size);

	/* Flush the params to be passed to memory */
	bl2_plat_flush_bl31_params();

	/*disable mmu and dcache, flush dcache, then enter next firmware*/
	disable_mmu_el1();

	/*
	 * Run BL31 via an SMC to BL1. Information on how to pass control to
	 * the BL32 (if present) and BL33 software images will be passed to
	 * BL31 as an argument.
	 */
#if 1
	smc(RUN_IMAGE, (unsigned long)bl31_ep_info, 0, 0, 0, 0, 0, 0);
#else
	typedef unsigned long (*FUNC_TPL)(void );
	unsigned long bl33_entry = 0x20000000;//TPL_GET_BL_ADDR(FM_BIN_BL33_OFFSET);
	printf("bl33 entry: 0x%8x\n", bl33_entry);
	FUNC_TPL func_tpl=(FUNC_TPL)bl33_entry;
	func_tpl();
#endif
}

/*blx header parse function*/
void parse_blx(image_info_t *image_data,
				entry_point_info_t *entry_point_info,
				unsigned int addr,
				unsigned int length)
{
	image_data->image_base = addr;
	image_data->image_size = length;
	if (entry_point_info != NULL)
		entry_point_info->pc = addr;
	return;
}

/*process bl30, transfer to m3, etc..*/
void process_bl30(image_info_t *image_data,
				entry_point_info_t *entry_point_info)
{
	printf("BL30 addr: 0x%8x\n", image_data->image_base);
	printf("BL30 size: 0x%8x\n", image_data->image_size);

	//printf("start bl30 sha2\n");
	uint8_t bl30_sha2[32] = {0};
	sha2((const uint8_t *)image_data->image_base,
		image_data->image_size,
		bl30_sha2,
		0); /*0 means sha256, else means sha224*/
	//printf("bl30 sha2:");
	int print_loop = 0;
	for (print_loop=0; print_loop<32; print_loop++) {
		if (0 == (print_loop % 16))
			printf("\n");
		//printf("0x%2x ", bl30_sha2[print_loop]);
	}
	//printf("\n");
	/*add code here*/
	send_bl30(image_data->image_base, image_data->image_size, bl30_sha2, sizeof(bl30_sha2));
	return;
}
