/*
 * Copyright (c) 2013-2014, ARM Limited and Contributors. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * Neither the name of ARM nor the names of its contributors may be used
 * to endorse or promote products derived from this software without specific
 * prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#include <arch.h>
#include <arch_helpers.h>
#include <assert.h>
#include <bl_common.h>
#include <debug.h>
#include <io_storage.h>
#include <platform.h>
#include <errno.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <storage.h>
#include <sha2.h>
#include <mailbox.h>
#include <asm/arch/romboot.h>
#include <cache.h>

unsigned long page_align(unsigned long value, unsigned dir)
{
	unsigned long page_size = 1 << FOUR_KB_SHIFT;

	/* Round up the limit to the next page boundary */
	if (value & (page_size - 1)) {
		value &= ~(page_size - 1);
		if (dir == UP)
			value += page_size;
	}

	return value;
}

static inline unsigned int is_page_aligned (unsigned long addr) {
	const unsigned long page_size = 1 << FOUR_KB_SHIFT;

	return (addr & (page_size - 1)) == 0;
}

void change_security_state(unsigned int target_security_state)
{
	unsigned long scr = read_scr();

	if (target_security_state == SECURE)
		scr &= ~SCR_NS_BIT;
	else if (target_security_state == NON_SECURE)
		scr |= SCR_NS_BIT;
	else
		assert(0);

	write_scr(scr);
}


/*******************************************************************************
 * The next function has a weak definition. Platform specific code can override
 * it if it wishes to.
 ******************************************************************************/
#pragma weak init_bl2_mem_layout

/*******************************************************************************
 * Function that takes a memory layout into which BL2 has been either top or
 * bottom loaded along with the address where BL2 has been loaded in it. Using
 * this information, it populates bl2_mem_layout to tell BL2 how much memory
 * it has access to and how much is available for use.
 ******************************************************************************/
void init_bl2_mem_layout(meminfo_t *bl1_mem_layout,
			 meminfo_t *bl2_mem_layout,
			 unsigned int load_type,
			 unsigned long bl2_base)
{
	unsigned tmp;

	if (load_type == BOT_LOAD) {
		bl2_mem_layout->total_base = bl2_base;
		tmp = bl1_mem_layout->free_base - bl2_base;
		bl2_mem_layout->total_size = bl1_mem_layout->free_size + tmp;

	} else {
		bl2_mem_layout->total_base = bl1_mem_layout->free_base;
		tmp = bl1_mem_layout->total_base + bl1_mem_layout->total_size;
		bl2_mem_layout->total_size = tmp - bl1_mem_layout->free_base;
	}

	bl2_mem_layout->free_base = bl1_mem_layout->free_base;
	bl2_mem_layout->free_size = bl1_mem_layout->free_size;
	bl2_mem_layout->attr = load_type;

	flush_dcache_range((unsigned long) bl2_mem_layout, sizeof(meminfo_t));
	return;
}

static void dump_load_info(unsigned long image_load_addr,
			   unsigned long image_size,
			   const meminfo_t *mem_layout)
{
#if DEBUG
	printf("Trying to load image at address 0x%lx, size = 0x%lx\r\n",
		image_load_addr, image_size);
	printf("Current memory layout:\r\n");
	printf("  total region = [0x%lx, 0x%lx]\r\n", mem_layout->total_base,
			mem_layout->total_base + mem_layout->total_size);
	printf("  free region = [0x%lx, 0x%lx]\r\n", mem_layout->free_base,
			mem_layout->free_base + mem_layout->free_size);
#endif
}

/* Generic function to return the size of an image */
unsigned long image_size(const char *image_name)
{
	uintptr_t dev_handle;
	uintptr_t image_handle;
	uintptr_t image_spec;
	size_t image_size = 0;
	int io_result = IO_FAIL;

	assert(image_name != NULL);

	/* Obtain a reference to the image by querying the platform layer */
	io_result = plat_get_image_source(image_name, &dev_handle, &image_spec);
	if (io_result != IO_SUCCESS) {
		WARN("Failed to obtain reference to image '%s' (%i)\n",
			image_name, io_result);
		return 0;
	}

	/* Attempt to access the image */
	io_result = io_open(dev_handle, image_spec, &image_handle);
	if (io_result != IO_SUCCESS) {
		WARN("Failed to access image '%s' (%i)\n",
			image_name, io_result);
		return 0;
	}

	/* Find the size of the image */
	io_result = io_size(image_handle, &image_size);
	if ((io_result != IO_SUCCESS) || (image_size == 0)) {
		WARN("Failed to determine the size of the image '%s' file (%i)\n",
			image_name, io_result);
	}
	io_result = io_close(image_handle);
	/* Ignore improbable/unrecoverable error in 'close' */

	/* TODO: Consider maintaining open device connection from this
	 * bootloader stage
	 */
	io_result = io_dev_close(dev_handle);
	/* Ignore improbable/unrecoverable error in 'dev_close' */

	return image_size;
}
/*******************************************************************************
 * Generic function to load an image into the trusted RAM,
 * given a name, extents of free memory & whether the image should be loaded at
 * the bottom or top of the free memory. It updates the memory layout if the
 * load is successful. It also updates the image information and the entry point
 * information in the params passed. The caller might pass a NULL pointer for
 * the entry point if it is not interested in this information, e.g. because
 * the image just needs to be loaded in memory but won't ever be executed.
 ******************************************************************************/
int load_image(meminfo_t *mem_layout,
			 const char *image_name,
			 unsigned int load_type,
			 unsigned long fixed_addr,
			 image_info_t *image_data,
			 entry_point_info_t *entry_point_info)
{
	uintptr_t dev_handle;
	uintptr_t image_handle;
	uintptr_t image_spec;
	unsigned long temp_image_base = 0;
	unsigned long image_base = 0;
	long offset = 0;
	size_t image_size = 0;
	size_t bytes_read = 0;
	int io_result = IO_FAIL;

	assert(mem_layout != NULL);
	assert(image_name != NULL);
	assert(image_data->h.version >= VERSION_1);

	/* Obtain a reference to the image by querying the platform layer */
	io_result = plat_get_image_source(image_name, &dev_handle, &image_spec);
	if (io_result != IO_SUCCESS) {
		WARN("Failed to obtain reference to image '%s' (%i)\n",
			image_name, io_result);
		return io_result;
	}

	/* Attempt to access the image */
	io_result = io_open(dev_handle, image_spec, &image_handle);
	if (io_result != IO_SUCCESS) {
		WARN("Failed to access image '%s' (%i)\n",
			image_name, io_result);
		return io_result;
	}

	/* Find the size of the image */
	io_result = io_size(image_handle, &image_size);
	if ((io_result != IO_SUCCESS) || (image_size == 0)) {
		WARN("Failed to determine the size of the image '%s' file (%i)\n",
			image_name, io_result);
		goto exit;
	}

	/* See if we have enough space */
	if (image_size > mem_layout->free_size) {
		WARN("Cannot load '%s' file: Not enough space.\n",
			image_name);
		dump_load_info(0, image_size, mem_layout);
		goto exit;
	}

	switch (load_type) {

	case TOP_LOAD:

	  /* Load the image in the top of free memory */
	  temp_image_base = mem_layout->free_base + mem_layout->free_size;
	  temp_image_base -= image_size;

	  /* Page align base address and check whether the image still fits */
	  image_base = page_align(temp_image_base, DOWN);
	  assert(image_base <= temp_image_base);

	  if (image_base < mem_layout->free_base) {
		WARN("Cannot load '%s' file: Not enough space.\n",
			image_name);
		dump_load_info(image_base, image_size, mem_layout);
		io_result = -ENOMEM;
		goto exit;
	  }

	  /* Calculate the amount of extra memory used due to alignment */
	  offset = temp_image_base - image_base;

	  break;

	case BOT_LOAD:

	  /* Load the BL2 image in the bottom of free memory */
	  temp_image_base = mem_layout->free_base;
	  image_base = page_align(temp_image_base, UP);
	  assert(image_base >= temp_image_base);

	  /* Page align base address and check whether the image still fits */
	  if (image_base + image_size >
	      mem_layout->free_base + mem_layout->free_size) {
		WARN("Cannot load '%s' file: Not enough space.\n",
		  image_name);
		dump_load_info(image_base, image_size, mem_layout);
		io_result = -ENOMEM;
		goto exit;
	  }

	  /* Calculate the amount of extra memory used due to alignment */
	  offset = image_base - temp_image_base;

	  break;

	default:
	  assert(0);

	}

	/*
	 * Some images must be loaded at a fixed address, not a dynamic one.
	 *
	 * This has been implemented as a hack on top of the existing dynamic
	 * loading mechanism, for the time being.  If the 'fixed_addr' function
	 * argument is different from zero, then it will force the load address.
	 * So we still have this principle of top/bottom loading but the code
	 * determining the load address is bypassed and the load address is
	 * forced to the fixed one.
	 *
	 * This can result in quite a lot of wasted space because we still use
	 * 1 sole meminfo structure to represent the extents of free memory,
	 * where we should use some sort of linked list.
	 *
	 * E.g. we want to load BL2 at address 0x04020000, the resulting memory
	 *      layout should look as follows:
	 * ------------ 0x04040000
	 * |          |  <- Free space (1)
	 * |----------|
	 * |   BL2    |
	 * |----------| 0x04020000
	 * |          |  <- Free space (2)
	 * |----------|
	 * |   BL1    |
	 * ------------ 0x04000000
	 *
	 * But in the current hacky implementation, we'll need to specify
	 * whether BL2 is loaded at the top or bottom of the free memory.
	 * E.g. if BL2 is considered as top-loaded, the meminfo structure
	 * will give the following view of the memory, hiding the chunk of
	 * free memory above BL2:
	 * ------------ 0x04040000
	 * |          |
	 * |          |
	 * |   BL2    |
	 * |----------| 0x04020000
	 * |          |  <- Free space (2)
	 * |----------|
	 * |   BL1    |
	 * ------------ 0x04000000
	 */
	if (fixed_addr != 0) {
		/* Load the image at the given address. */
		image_base = fixed_addr;

		/* Check whether the image fits. */
		if ((image_base < mem_layout->free_base) ||
		    (image_base + image_size >
		       mem_layout->free_base + mem_layout->free_size)) {
			WARN("Cannot load '%s' file: Not enough space.\n",
				image_name);
			dump_load_info(image_base, image_size, mem_layout);
			io_result = -ENOMEM;
			goto exit;
		}

		/* Check whether the fixed load address is page-aligned. */
		if (!is_page_aligned(image_base)) {
			WARN("Cannot load '%s' file at unaligned address 0x%lx\n",
				image_name, fixed_addr);
			io_result = -ENOMEM;
			goto exit;
		}

		/*
		 * Calculate the amount of extra memory used due to fixed
		 * loading.
		 */
		if (load_type == TOP_LOAD) {
			unsigned long max_addr, space_used;
			/*
			 * ------------ max_addr
			 * | /wasted/ |                 | offset
			 * |..........|..............................
			 * |  image   |                 | image_flen
			 * |----------| fixed_addr
			 * |          |
			 * |          |
			 * ------------ total_base
			 */
			max_addr = mem_layout->total_base + mem_layout->total_size;
			/*
			 * Compute the amount of memory used by the image.
			 * Corresponds to all space above the image load
			 * address.
			 */
			space_used = max_addr - fixed_addr;
			/*
			 * Calculate the amount of wasted memory within the
			 * amount of memory used by the image.
			 */
			offset = space_used - image_size;
		} else /* BOT_LOAD */
			/*
			 * ------------
			 * |          |
			 * |          |
			 * |----------|
			 * |  image   |
			 * |..........| fixed_addr
			 * | /wasted/ |                 | offset
			 * ------------ total_base
			 */
			offset = fixed_addr - mem_layout->total_base;
	}

	/* We have enough space so load the image now */
	/* TODO: Consider whether to try to recover/retry a partially successful read */
	io_result = io_read(image_handle, image_base, image_size, &bytes_read);
	if ((io_result != IO_SUCCESS) || (bytes_read < image_size)) {
		WARN("Failed to load '%s' file (%i)\n", image_name, io_result);
		goto exit;
	}

	image_data->image_base = image_base;
	image_data->image_size = image_size;

	if (entry_point_info != NULL)
		entry_point_info->pc = image_base;

	/*
	 * File has been successfully loaded. Update the free memory
	 * data structure & flush the contents of the TZRAM so that
	 * the next EL can see it.
	 */
	/* Update the memory contents */
	flush_dcache_range(image_base, image_size);

	mem_layout->free_size -= image_size + offset;

	/* Update the base of free memory since its moved up */
	if (load_type == BOT_LOAD)
		mem_layout->free_base += offset + image_size;

exit:
	io_close(image_handle);
	/* Ignore improbable/unrecoverable error in 'close' */

	/* TODO: Consider maintaining open device connection from this bootloader stage */
	io_dev_close(dev_handle);
	/* Ignore improbable/unrecoverable error in 'dev_close' */

	return io_result;
}

void bl2_load_image(void){
	//meminfo_t *bl2_tzram_layout;
	bl31_params_t *bl2_to_bl31_params;
	entry_point_info_t *bl31_ep_info;
	//meminfo_t bl33_mem_info;

	/*load fip.bin here*/
	//to do list
	storage_load(BL2_SIZE, TPL_LOAD_ADDR, 0x38000); //temp added, load 224KB

	/* Find out how much free trusted ram remains after BL2 load */
	//bl2_tzram_layout = bl2_plat_sec_mem_layout();

	/*bl30*/
	image_info_t bl30_image_info;
	entry_point_info_t bl30_ep_info;
	/*parse_blx implement in bl2_plat_setup.c*/
	parse_blx(&bl30_image_info,
				&bl30_ep_info,
				FM_BL30_LOAD_ADDR,
				TPL_GET_BL_SIZE(FM_BIN_BL30_SIZE));
	memcpy((void *)FM_BL30_LOAD_ADDR, \
		(const void *)(unsigned long)TPL_GET_BL_ADDR(FM_BIN_BL30_OFFSET),\
		TPL_GET_BL_SIZE(FM_BIN_BL30_SIZE));
	/*process bl30*/
	process_bl30(&bl30_image_info, &bl30_ep_info);

	/*bl31*/
	/*
	 * Get a pointer to the memory the platform has set aside to pass
	 * information to BL31.
	 */
	bl2_to_bl31_params = bl2_plat_get_bl31_params();
	bl31_ep_info = bl2_plat_get_bl31_ep_info();
	/* Set the X0 parameter to bl31 */
	bl31_ep_info->args.arg0 = (unsigned long)bl2_to_bl31_params;
	/*parse_blx implement in bl2_plat_setup.c*/
	parse_blx(bl2_to_bl31_params->bl31_image_info,
				bl31_ep_info,
				FM_BL31_LOAD_ADDR,
				TPL_GET_BL_SIZE(FM_BIN_BL31_SIZE));
	/*copy bl31, or replace with load function*/
	memcpy((void *)FM_BL31_LOAD_ADDR, \
		(const void *)(unsigned long)TPL_GET_BL_ADDR(FM_BIN_BL31_OFFSET),\
		TPL_GET_BL_SIZE(FM_BIN_BL31_SIZE));
	bl2_plat_set_bl31_ep_info(bl2_to_bl31_params->bl31_image_info,
				bl31_ep_info);
	printf("BL31 addr: 0x%8x\n", bl2_to_bl31_params->bl31_image_info->image_base);
	printf("BL31 size: 0x%8x\n", bl2_to_bl31_params->bl31_image_info->image_size);

#ifdef BL32_BASE
	/*
	 * Load the BL32 image if there's one. It is upto to platform
	 * to specify where BL32 should be loaded if it exists. It
	 * could create space in the secure sram or point to a
	 * completely different memory.
	 *
	 * If a platform does not want to attempt to load BL3-2 image
	 * it must leave BL32_BASE undefined
	 */
	meminfo_t bl32_mem_info;
	bl2_plat_get_bl32_meminfo(&bl32_mem_info);
	parse_blx(bl2_to_bl31_params->bl32_image_info,
				bl2_to_bl31_params->bl32_ep_info,
				FM_BL32_LOAD_ADDR,
				TPL_GET_BL_SIZE(FM_BIN_BL32_SIZE));
	memcpy((void *)FM_BL32_LOAD_ADDR, \
		(const void *)(unsigned long)TPL_GET_BL_ADDR(FM_BIN_BL32_OFFSET), \
		TPL_GET_BL_SIZE(FM_BIN_BL33_SIZE));
	bl2_plat_set_bl32_ep_info(bl2_to_bl31_params->bl32_image_info,
				bl2_to_bl31_params->bl32_ep_info);
	printf("BL32 addr: 0x%8x\n", bl2_to_bl31_params->bl32_image_info->image_base);
	printf("BL32 size: 0x%8x\n", bl2_to_bl31_params->bl32_image_info->image_size);

#endif /* BL32_BASE */

	/*bl33*/
	parse_blx(bl2_to_bl31_params->bl33_image_info,
				bl2_to_bl31_params->bl33_ep_info,
				FM_BL33_LOAD_ADDR,
				TPL_GET_BL_SIZE(FM_BIN_BL33_SIZE));
	memcpy((void *)FM_BL33_LOAD_ADDR, \
		(const void *)(unsigned long)TPL_GET_BL_ADDR(FM_BIN_BL33_OFFSET), \
		TPL_GET_BL_SIZE(FM_BIN_BL33_SIZE));
	//bl2_plat_get_bl33_meminfo(&bl33_mem_info);

	bl2_plat_set_bl33_ep_info(bl2_to_bl31_params->bl33_image_info,
				bl2_to_bl31_params->bl33_ep_info);
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
				unsigned int length){

	image_data->image_base = addr;
	image_data->image_size = length;
	if (entry_point_info != NULL)
		entry_point_info->pc = addr;
	return;
}

/*process bl30, transfer to m3, etc..*/
void process_bl30(image_info_t *image_data,
				entry_point_info_t *entry_point_info){
	printf("BL30 addr: 0x%8x\n", image_data->image_base);
	printf("BL30 size: 0x%8x\n", image_data->image_size);

	printf("start bl30 sha2\n");
	uint8_t bl30_sha2[32] = {0};
	sha2((const uint8_t *)image_data->image_base,
		image_data->image_size,
		bl30_sha2,
		0); /*0 means sha256, else means sha224*/
	printf("bl30 sha2:");
	int print_loop = 0;
	for (print_loop=0; print_loop<32; print_loop++) {
		if (0 == (print_loop % 16))
			printf("\n");
		printf("0x%2x ", bl30_sha2[print_loop]);
	}
	printf("\n");
	/*add code here*/
	send_bl30(image_data->image_base, image_data->image_size, bl30_sha2, sizeof(bl30_sha2));
	return;
}