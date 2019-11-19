/*
 * Copyright (c) 2016-2017, Fuzhou Rockchip Electronics Co., Ltd
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * date: 2019-09-18
 */
	.arch armv7-a
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 4
	.eabi_attribute 34, 0
	.eabi_attribute 18, 2
	.file	"rk_zftl_arm_v7.S"
	.section	.text.flash_mem_cmp8,"ax",%progbits
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_mem_cmp8, %function
flash_mem_cmp8:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	movs	r3, #0
	push	{r4, r5, lr}
.L2:
	cmp	r3, r2
	bne	.L5
	movs	r0, #0
	pop	{r4, r5, pc}
.L5:
	ldrb	r5, [r0, r3]	@ zero_extendqisi2
	ldrb	r4, [r1, r3]	@ zero_extendqisi2
	adds	r3, r3, #1
	cmp	r5, r4
	beq	.L2
	mov	r0, r3
	pop	{r4, r5, pc}
	.size	flash_mem_cmp8, .-flash_mem_cmp8
	.global	__aeabi_uidiv
	.global	__aeabi_uidivmod
	.section	.text.slc_phy_page_address_calc,"ax",%progbits
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	slc_phy_page_address_calc, %function
slc_phy_page_address_calc:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	mov	r4, r0
	ldr	r3, .L16
	ldr	r7, .L16+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L7
	ldrb	r3, [r7]	@ zero_extendqisi2
	cbz	r3, .L8
.L7:
	ldr	r3, .L16+8
	mov	r0, r4
	ldrh	r5, [r3]
	mov	r1, r5
	bl	__aeabi_uidiv
	mov	r1, r5
	mul	r6, r5, r0
	mov	r0, r4
	bl	__aeabi_uidivmod
	ldrb	r3, [r7]	@ zero_extendqisi2
	cbz	r3, .L9
	add	r4, r6, r1, lsl #1
.L8:
	mov	r0, r4
	pop	{r3, r4, r5, r6, r7, pc}
.L9:
	ldr	r3, .L16+12
	ldrh	r4, [r3, r1, lsl #1]
	add	r4, r4, r6
	b	.L8
.L17:
	.align	2
.L16:
	.word	.LANCHOR0
	.word	.LANCHOR1
	.word	.LANCHOR2
	.word	.LANCHOR3
	.size	slc_phy_page_address_calc, .-slc_phy_page_address_calc
	.section	.text._list_remove_node,"ax",%progbits
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	_list_remove_node, %function
_list_remove_node:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, r8, r10, lr}
	movs	r5, #6
	ldr	r6, .L26
	muls	r5, r1, r5
	movw	r3, #65535
	mov	r8, r2
	mov	r10, r0
	ldr	r7, [r6]
	ldrh	r1, [r7, r5]
	adds	r4, r7, r5
	ldrh	r2, [r4, #2]
	cmp	r1, r3
	ldr	r3, [r0]
	bne	.L19
	cmp	r2, r1
	bne	.L19
	cmp	r4, r3
	bne	.L18
.L19:
	movw	r1, #65535
	cmp	r2, r1
	bne	.L21
	cmp	r4, r3
	beq	.L21
	movs	r2, #188
	ldr	r1, .L26+4
	ldr	r0, .L26+8
	bl	printf
.L21:
	ldr	r3, [r10]
	movw	r1, #65535
	cmp	r4, r3
	ldrh	r3, [r7, r5]
	bne	.L22
	cmp	r3, r1
	ittee	ne
	ldrne	r0, [r6]
	movne	r2, #6
	moveq	r3, #0
	streq	r3, [r10]
	ittt	ne
	mlane	r3, r2, r3, r0
	strne	r3, [r10]
	strhne	r1, [r3, #2]	@ movhi
.L24:
	movw	r3, #65535
	strh	r3, [r7, r5]	@ movhi
	strh	r3, [r4, #2]	@ movhi
	ldrh	r3, [r8]
	subs	r3, r3, #1
	strh	r3, [r8]	@ movhi
.L18:
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L22:
	cmp	r3, r1
	ldrh	r1, [r4, #2]
	bne	.L25
	cmp	r1, r3
	beq	.L24
	movs	r2, #6
	ldr	r0, [r6]
	muls	r1, r2, r1
	strh	r3, [r0, r1]	@ movhi
	b	.L24
.L25:
	ldr	r0, [r6]
	movs	r2, #6
	mla	r6, r2, r3, r0
	strh	r1, [r6, #2]	@ movhi
	ldrh	r1, [r4, #2]
	muls	r2, r1, r2
	strh	r3, [r0, r2]	@ movhi
	b	.L24
.L27:
	.align	2
.L26:
	.word	.LANCHOR4
	.word	.LANCHOR5
	.word	.LC0
	.size	_list_remove_node, .-_list_remove_node
	.section	.text._list_pop_index_node,"ax",%progbits
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	_list_pop_index_node, %function
_list_pop_index_node:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	ldr	r5, [r0]
	cbz	r5, .L34
	ldr	r3, .L35
	movw	r6, #65535
	movs	r7, #6
	ldr	r4, [r3]
.L30:
	cbnz	r1, .L31
.L33:
	subs	r4, r5, r4
	asrs	r3, r4, #1
	ldr	r4, .L35+4
	muls	r4, r3, r4
	uxth	r1, r4
	bl	_list_remove_node
	movw	r3, #65535
	uxth	r0, r4
	strh	r3, [r5]	@ movhi
	strh	r3, [r5, #2]	@ movhi
	pop	{r3, r4, r5, r6, r7, pc}
.L31:
	ldrh	r3, [r5]
	cmp	r3, r6
	beq	.L33
	subs	r1, r1, #1
	mla	r5, r7, r3, r4
	uxth	r1, r1
	b	.L30
.L34:
	movw	r0, #65535
	pop	{r3, r4, r5, r6, r7, pc}
.L36:
	.align	2
.L35:
	.word	.LANCHOR4
	.word	-1431655765
	.size	_list_pop_index_node, .-_list_pop_index_node
	.section	.text._insert_free_list,"ax",%progbits
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	_insert_free_list, %function
_insert_free_list:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L45
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	ldrh	r3, [r3]
	cmp	r3, r1
	bls	.L37
	ldrh	r3, [r2]
	movw	r10, #65535
	ldr	r7, [r0]
	adds	r3, r3, #1
	strh	r3, [r2]	@ movhi
	movs	r2, #6
	ldr	r3, .L45+4
	mul	lr, r2, r1
	ldr	r5, [r3]
	add	r6, r5, lr
	strh	r10, [r6, #2]	@ movhi
	strh	r10, [r5, lr]	@ movhi
	cbnz	r7, .L39
.L44:
	str	r6, [r0]
	b	.L37
.L39:
	ldr	r3, .L45+8
	str	r2, [sp, #4]
	ldr	ip, [r3]
	ldr	r3, .L45+12
	ldrh	r4, [ip, r1, lsl #2]
	ldrh	r8, [r3]
	ldr	r3, [ip, r1, lsl #2]
	ubfx	r4, r4, #0, #11
	ubfx	r3, r3, #11, #8
	smulbb	r3, r3, r8
	add	r3, r3, r4
	uxth	r3, r3
	str	r3, [sp]
	subs	r3, r7, r5
	asrs	r4, r3, #1
	ldr	r3, .L45+16
	muls	r3, r4, r3
	mov	r4, r7
	uxth	r3, r3
.L42:
	ldr	r2, [ip, r3, lsl #2]
	ldrh	fp, [ip, r3, lsl #2]
	ubfx	r2, r2, #11, #8
	smulbb	r2, r2, r8
	ubfx	fp, fp, #0, #11
	add	r2, r2, fp
	uxth	fp, r2
	ldr	r2, [sp]
	cmp	r2, fp
	bls	.L40
	ldrh	r2, [r4]
	cmp	r2, r10
	bne	.L41
	strh	r3, [r6, #2]	@ movhi
	strh	r1, [r4]	@ movhi
.L37:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L41:
	ldr	r3, [sp, #4]
	mla	r4, r3, r2, r5
	mov	r3, r2
	b	.L42
.L40:
	ldrh	r2, [r4, #2]
	cmp	r7, r4
	strh	r2, [r6, #2]	@ movhi
	strh	r3, [r5, lr]	@ movhi
	bne	.L43
	strh	r1, [r7, #2]	@ movhi
	b	.L44
.L43:
	ldrh	r2, [r4, #2]
	movs	r3, #6
	muls	r3, r2, r3
	strh	r1, [r5, r3]	@ movhi
	strh	r1, [r4, #2]	@ movhi
	b	.L37
.L46:
	.align	2
.L45:
	.word	.LANCHOR6
	.word	.LANCHOR4
	.word	.LANCHOR7
	.word	.LANCHOR8
	.word	-1431655765
	.size	_insert_free_list, .-_insert_free_list
	.section	.text._insert_data_list,"ax",%progbits
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	_insert_data_list, %function
_insert_data_list:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L69
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	lr, r0
	sub	sp, sp, #24
	ldrh	r3, [r3]
	cmp	r3, r1
	bls	.L47
	ldrh	r3, [r2]
	ldr	r0, [r0]
	adds	r3, r3, #1
	strh	r3, [r2]	@ movhi
	ldr	r3, .L69+4
	ldr	r5, [r3]
	movs	r3, #6
	mul	r10, r3, r1
	movw	r3, #65535
	add	r6, r5, r10
	strh	r3, [r6, #2]	@ movhi
	strh	r3, [r5, r10]	@ movhi
	cbnz	r0, .L50
.L68:
	str	r6, [lr]
	b	.L47
.L50:
	ldr	r3, .L69+8
	ldrh	r7, [r6, #4]
	ldr	r3, [r3]
	ldrh	r4, [r3, r1, lsl #1]
	muls	r4, r7, r4
	str	r3, [sp, #8]
	ldr	r3, .L69+12
	str	r4, [sp]
	ldr	r8, [r3]
	ldr	r3, [r8, r1, lsl #2]
	ubfx	r2, r3, #11, #8
	ldr	r3, .L69+16
	ldrh	r3, [r3]
	str	r3, [sp, #12]
	ldrh	r3, [r8, r1, lsl #2]
	ubfx	r3, r3, #0, #11
	beq	.L51
	ldrh	r4, [sp, #12]
	smulbb	r2, r2, r4
	add	r3, r3, r2
	ldr	r2, [sp]
	uxtah	r3, r2, r3
	str	r3, [sp]
.L51:
	ldr	r3, [sp]
	cmp	r7, #0
	it	eq
	moveq	r3, #-1
	movs	r7, #0
	str	r7, [sp, #4]
	str	r3, [sp]
	subs	r3, r0, r5
	asrs	r2, r3, #1
	ldr	r3, .L69+20
	muls	r3, r2, r3
	ldr	r2, .L69
	ldrh	r2, [r2]
	uxth	r3, r3
	str	r2, [sp, #20]
	mov	r2, r0
.L57:
	ldr	r7, [sp, #4]
	adds	r7, r7, #1
	uxth	r7, r7
	mov	r4, r7
	str	r7, [sp, #4]
	ldr	r7, [sp, #20]
	cmp	r4, r7
	bhi	.L47
	cmp	r1, r3
	beq	.L47
	ldrh	r7, [r2, #4]
	ldr	r4, [r8, r3, lsl #2]
	ldrh	ip, [r8, r3, lsl #2]
	str	r7, [sp, #16]
	ldr	r7, [sp, #8]
	ubfx	fp, r4, #11, #8
	ldr	r4, [sp, #16]
	ubfx	ip, ip, #0, #11
	ldrh	r7, [r7, r3, lsl #1]
	muls	r7, r4, r7
	itt	ne
	ldrhne	r4, [sp, #12]
	smulbbne	fp, fp, r4
	ldr	r4, [sp, #16]
	itt	ne
	addne	fp, fp, ip
	uxtahne	r7, r7, fp
	cbz	r4, .L55
	ldr	r4, [sp]
	cmp	r4, r7
	bls	.L55
	ldrh	r7, [r2]
	movw	r4, #65535
	cmp	r7, r4
	bne	.L56
	strh	r3, [r6, #2]	@ movhi
	strh	r1, [r2]	@ movhi
.L47:
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L56:
	movs	r3, #6
	mla	r2, r3, r7, r5
	mov	r3, r7
	b	.L57
.L55:
	ldrh	r4, [r2, #2]
	cmp	r0, r2
	strh	r4, [r6, #2]	@ movhi
	strh	r3, [r5, r10]	@ movhi
	bne	.L58
	strh	r1, [r0, #2]	@ movhi
	b	.L68
.L58:
	ldrh	r0, [r2, #2]
	movs	r3, #6
	muls	r3, r0, r3
	strh	r1, [r5, r3]	@ movhi
	strh	r1, [r2, #2]	@ movhi
	b	.L47
.L70:
	.align	2
.L69:
	.word	.LANCHOR6
	.word	.LANCHOR4
	.word	.LANCHOR9
	.word	.LANCHOR7
	.word	.LANCHOR8
	.word	-1431655765
	.size	_insert_data_list, .-_insert_data_list
	.section	.text._list_get_gc_head_node.isra.2,"ax",%progbits
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	_list_get_gc_head_node.isra.2, %function
_list_get_gc_head_node.isra.2:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	cbz	r0, .L76
	ldr	r3, .L78
	movw	r2, #65535
	movs	r4, #6
	ldr	r3, [r3]
.L73:
	cbz	r1, .L74
	ldrh	r0, [r0]
	cmp	r0, r2
	bne	.L75
	pop	{r4, pc}
.L75:
	subs	r1, r1, #1
	mla	r0, r4, r0, r3
	uxth	r1, r1
	b	.L73
.L76:
	movw	r0, #65535
	pop	{r4, pc}
.L74:
	subs	r0, r0, r3
	asrs	r3, r0, #1
	ldr	r0, .L78+4
	muls	r0, r3, r0
	uxth	r0, r0
	pop	{r4, pc}
.L79:
	.align	2
.L78:
	.word	.LANCHOR4
	.word	-1431655765
	.size	_list_get_gc_head_node.isra.2, .-_list_get_gc_head_node.isra.2
	.section	.text._list_update_data_list,"ax",%progbits
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	_list_update_data_list, %function
_list_update_data_list:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L90
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r6, r2
	mov	r7, r0
	mov	r4, r1
	ldr	r3, [r3]
	ldrh	r2, [r3, #16]
	cmp	r2, r1
	beq	.L80
	ldrh	r2, [r3, #48]
	cmp	r2, r1
	beq	.L80
	ldrh	r3, [r3, #80]
	cmp	r3, r1
	beq	.L80
	ldr	r3, .L90+4
	movs	r5, #6
	muls	r5, r1, r5
	ldr	r2, [r0]
	ldr	fp, [r3]
	mov	r8, r3
	add	r10, fp, r5
	cmp	r10, r2
	beq	.L80
	ldrh	r3, [r10, #2]
	movw	r2, #65535
	cmp	r3, r2
	bne	.L84
	ldrh	r2, [fp, r5]
	cmp	r2, r3
	bne	.L84
	movs	r2, #255
	ldr	r1, .L90+8
	ldr	r0, .L90+12
	bl	printf
.L84:
	ldrh	r3, [r10, #2]
	movw	r2, #65535
	cmp	r3, r2
	bne	.L85
	ldrh	r2, [fp, r5]
	cmp	r2, r3
	beq	.L80
.L85:
	ldr	r2, .L90+16
	ldr	r0, [r2]
	ldrh	r2, [r10, #4]
	ldrh	r1, [r0, r4, lsl #1]
	cbz	r2, .L88
	muls	r2, r1, r2
.L86:
	movs	r1, #6
	muls	r1, r3, r1
	ldr	r3, .L90+20
	asrs	r5, r1, #1
	muls	r3, r5, r3
	ldrh	r5, [r0, r3, lsl #1]
	ldr	r0, [r8]
	add	r1, r1, r0
	ldrh	r3, [r1, #4]
	cbz	r3, .L89
	muls	r3, r5, r3
.L87:
	cmp	r2, r3
	bcs	.L80
	mov	r2, r6
	mov	r1, r4
	mov	r0, r7
	bl	_list_remove_node
	mov	r2, r6
	mov	r1, r4
	mov	r0, r7
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	_insert_data_list
.L88:
	mov	r2, #-1
	b	.L86
.L89:
	mov	r3, #-1
	b	.L87
.L80:
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L91:
	.align	2
.L90:
	.word	.LANCHOR10
	.word	.LANCHOR4
	.word	.LANCHOR11
	.word	.LC0
	.word	.LANCHOR9
	.word	-1431655765
	.size	_list_update_data_list, .-_list_update_data_list
	.section	.text.zftl_get_gc_node.part.9,"ax",%progbits
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	zftl_get_gc_node.part.9, %function
zftl_get_gc_node.part.9:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L93
	mov	r1, r0
	ldr	r0, [r3]
	b	_list_get_gc_head_node.isra.2
.L94:
	.align	2
.L93:
	.word	.LANCHOR12
	.size	zftl_get_gc_node.part.9, .-zftl_get_gc_node.part.9
	.section	.text.nandc_de_cs.constprop.30,"ax",%progbits
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	nandc_de_cs.constprop.30, %function
nandc_de_cs.constprop.30:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L96
	ldr	r2, [r3]
	ldr	r3, [r2]
	bfc	r3, #0, #8
	bfc	r3, #17, #1
	str	r3, [r2]
	bx	lr
.L97:
	.align	2
.L96:
	.word	.LANCHOR13
	.size	nandc_de_cs.constprop.30, .-nandc_de_cs.constprop.30
	.section	.text.nand_flash_print_info,"ax",%progbits
	.align	1
	.global	nand_flash_print_info
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	nand_flash_print_info, %function
nand_flash_print_info:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, lr}
	sub	sp, sp, #20
	ldr	r4, .L220
	ldr	r3, [r4]
	lsls	r3, r3, #19
	bpl	.L99
	ldr	r1, .L220+4
	ldr	r0, .L220+8
	bl	printf
.L99:
	ldr	r3, [r4]
	lsls	r5, r3, #19
	bpl	.L100
	ldr	r3, .L220+12
	ldr	r0, [r3]
	ldrb	r5, [r0, #6]	@ zero_extendqisi2
	ldrb	r3, [r0, #3]	@ zero_extendqisi2
	ldrb	r2, [r0, #2]	@ zero_extendqisi2
	ldrb	r1, [r0, #1]	@ zero_extendqisi2
	str	r5, [sp, #8]
	ldrb	r5, [r0, #5]	@ zero_extendqisi2
	str	r5, [sp, #4]
	ldrb	r0, [r0, #4]	@ zero_extendqisi2
	str	r0, [sp]
	ldr	r0, .L220+16
	bl	printf
.L100:
	ldr	r3, [r4]
	lsls	r0, r3, #19
	bpl	.L101
	ldr	r3, .L220+12
	ldr	r0, .L220+20
	ldr	r3, [r3]
	ldrb	r1, [r3, #8]	@ zero_extendqisi2
	bl	printf
.L101:
	ldr	r3, [r4]
	lsls	r1, r3, #19
	bpl	.L102
	ldr	r3, .L220+12
	ldr	r0, .L220+24
	ldr	r3, [r3]
	ldrb	r1, [r3, #9]	@ zero_extendqisi2
	bl	printf
.L102:
	ldr	r3, [r4]
	lsls	r2, r3, #19
	bpl	.L103
	ldr	r3, .L220+12
	ldr	r0, .L220+28
	ldr	r3, [r3]
	ldrh	r1, [r3, #10]
	bl	printf
.L103:
	ldr	r3, [r4]
	lsls	r3, r3, #19
	bpl	.L104
	ldr	r3, .L220+12
	ldr	r0, .L220+32
	ldr	r3, [r3]
	ldrb	r1, [r3, #12]	@ zero_extendqisi2
	bl	printf
.L104:
	ldr	r3, [r4]
	lsls	r5, r3, #19
	bpl	.L105
	ldr	r3, .L220+12
	ldr	r0, .L220+36
	ldr	r3, [r3]
	ldrb	r1, [r3, #13]	@ zero_extendqisi2
	bl	printf
.L105:
	ldr	r3, [r4]
	lsls	r0, r3, #19
	bpl	.L106
	ldr	r3, .L220+12
	ldr	r0, .L220+40
	ldr	r3, [r3]
	ldrh	r1, [r3, #14]
	bl	printf
.L106:
	ldr	r3, [r4]
	lsls	r1, r3, #19
	bpl	.L107
	ldr	r3, .L220+12
	ldr	r0, .L220+44
	ldr	r3, [r3]
	ldrb	r1, [r3, #23]	@ zero_extendqisi2
	bl	printf
.L107:
	ldr	r3, [r4]
	lsls	r2, r3, #19
	bpl	.L108
	ldr	r3, .L220+12
	ldr	r0, .L220+48
	ldr	r3, [r3]
	ldrb	r1, [r3, #18]	@ zero_extendqisi2
	bl	printf
.L108:
	ldr	r3, [r4]
	lsls	r3, r3, #19
	bpl	.L109
	ldr	r3, .L220+12
	ldr	r0, .L220+52
	ldr	r3, [r3]
	ldrb	r1, [r3, #19]	@ zero_extendqisi2
	bl	printf
.L109:
	ldr	r3, [r4]
	lsls	r5, r3, #19
	bpl	.L110
	ldr	r3, .L220+12
	ldr	r0, .L220+56
	ldr	r3, [r3]
	ldrb	r1, [r3, #20]	@ zero_extendqisi2
	bl	printf
.L110:
	ldr	r3, [r4]
	lsls	r0, r3, #19
	bpl	.L111
	ldr	r3, .L220+60
	ldr	r0, .L220+64
	ldrb	r1, [r3]	@ zero_extendqisi2
	bl	printf
.L111:
	ldr	r3, [r4]
	lsls	r1, r3, #19
	bpl	.L112
	ldr	r3, .L220+68
	ldr	r0, .L220+72
	ldrb	r1, [r3]	@ zero_extendqisi2
	bl	printf
.L112:
	ldr	r3, [r4]
	lsls	r2, r3, #19
	bpl	.L113
	ldr	r3, .L220+12
	ldr	r0, .L220+76
	ldr	r3, [r3]
	ldrb	r1, [r3, #22]	@ zero_extendqisi2
	bl	printf
.L113:
	ldr	r3, [r4]
	lsls	r3, r3, #19
	bpl	.L114
	ldr	r3, .L220+80
	ldr	r0, .L220+84
	ldrb	r1, [r3]	@ zero_extendqisi2
	bl	printf
.L114:
	ldr	r3, [r4]
	lsls	r5, r3, #19
	bpl	.L115
	ldr	r3, .L220+12
	ldr	r0, .L220+88
	ldr	r3, [r3]
	ldrb	r1, [r3, #16]	@ zero_extendqisi2
	and	r1, r1, #1
	bl	printf
.L115:
	ldr	r3, [r4]
	lsls	r0, r3, #19
	bpl	.L116
	ldr	r3, .L220+12
	ldr	r0, .L220+92
	ldr	r3, [r3]
	ldrh	r1, [r3, #16]
	ubfx	r1, r1, #1, #1
	bl	printf
.L116:
	ldr	r3, [r4]
	lsls	r1, r3, #19
	bpl	.L117
	ldr	r3, .L220+12
	ldr	r0, .L220+96
	ldr	r3, [r3]
	ldrh	r1, [r3, #16]
	ubfx	r1, r1, #2, #1
	bl	printf
.L117:
	ldr	r3, [r4]
	lsls	r2, r3, #19
	bpl	.L118
	ldr	r3, .L220+12
	ldr	r0, .L220+100
	ldr	r3, [r3]
	ldrh	r1, [r3, #16]
	ubfx	r1, r1, #3, #1
	bl	printf
.L118:
	ldr	r3, [r4]
	lsls	r3, r3, #19
	bpl	.L119
	ldr	r3, .L220+12
	ldr	r0, .L220+104
	ldr	r3, [r3]
	ldrh	r1, [r3, #16]
	ubfx	r1, r1, #4, #1
	bl	printf
.L119:
	ldr	r3, [r4]
	lsls	r5, r3, #19
	bpl	.L120
	ldr	r3, .L220+12
	ldr	r0, .L220+108
	ldr	r3, [r3]
	ldrh	r1, [r3, #16]
	ubfx	r1, r1, #5, #1
	bl	printf
.L120:
	ldr	r3, [r4]
	lsls	r0, r3, #19
	bpl	.L121
	ldr	r3, .L220+12
	ldr	r0, .L220+112
	ldr	r3, [r3]
	ldrh	r1, [r3, #16]
	ubfx	r1, r1, #6, #1
	bl	printf
.L121:
	ldr	r3, [r4]
	lsls	r1, r3, #19
	bpl	.L122
	ldr	r3, .L220+12
	ldr	r0, .L220+116
	ldr	r3, [r3]
	ldrh	r1, [r3, #16]
	ubfx	r1, r1, #7, #1
	bl	printf
.L122:
	ldr	r3, [r4]
	lsls	r2, r3, #19
	bpl	.L123
	ldr	r3, .L220+12
	ldr	r0, .L220+120
	ldr	r3, [r3]
	ldrh	r1, [r3, #16]
	ubfx	r1, r1, #8, #1
	bl	printf
.L123:
	ldr	r3, [r4]
	lsls	r3, r3, #19
	bpl	.L124
	ldr	r3, .L220+12
	ldr	r0, .L220+124
	ldr	r3, [r3]
	ldrh	r1, [r3, #16]
	ubfx	r1, r1, #9, #1
	bl	printf
.L124:
	ldr	r3, [r4]
	lsls	r5, r3, #19
	bpl	.L125
	ldr	r3, .L220+12
	ldr	r0, .L220+128
	ldr	r3, [r3]
	ldrh	r1, [r3, #16]
	ubfx	r1, r1, #10, #1
	bl	printf
.L125:
	ldr	r3, [r4]
	lsls	r0, r3, #19
	bpl	.L126
	ldr	r3, .L220+132
	ldr	r0, .L220+136
	ldrb	r2, [r3]	@ zero_extendqisi2
	ldr	r3, .L220+68
	ldrb	r1, [r3]	@ zero_extendqisi2
	bl	printf
.L126:
	ldr	r3, [r4]
	lsls	r1, r3, #19
	bpl	.L127
	ldr	r3, .L220+140
	ldr	r0, .L220+144
	ldrb	r2, [r3, #11]	@ zero_extendqisi2
	ldrb	r1, [r3, #10]	@ zero_extendqisi2
	bl	printf
.L127:
	ldr	r3, [r4]
	lsls	r2, r3, #19
	bpl	.L128
	ldr	r3, .L220+140
	ldr	r0, .L220+148
	ldrb	r2, [r3, #9]	@ zero_extendqisi2
	b	.L221
.L222:
	.align	2
.L220:
	.word	.LANCHOR14
	.word	.LANCHOR15
	.word	.LC1
	.word	.LANCHOR16
	.word	.LC2
	.word	.LC3
	.word	.LC4
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LC8
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LC12
	.word	.LANCHOR17
	.word	.LC13
	.word	.LANCHOR0
	.word	.LC14
	.word	.LC15
	.word	.LANCHOR18
	.word	.LC16
	.word	.LC17
	.word	.LC18
	.word	.LC19
	.word	.LC20
	.word	.LC21
	.word	.LC22
	.word	.LC23
	.word	.LC24
	.word	.LC25
	.word	.LC26
	.word	.LC27
	.word	.LANCHOR19
	.word	.LC28
	.word	.LANCHOR20
	.word	.LC29
	.word	.LC30
.L221:
	ldrb	r1, [r3, #8]	@ zero_extendqisi2
	bl	printf
.L128:
	ldr	r3, [r4]
	lsls	r3, r3, #19
	bpl	.L98
	ldr	r3, .L223
	ldr	r0, .L223+4
	ldrb	r1, [r3]	@ zero_extendqisi2
	add	sp, sp, #20
	@ sp needed
	pop	{r4, r5, lr}
	b	printf
.L98:
	add	sp, sp, #20
	@ sp needed
	pop	{r4, r5, pc}
.L224:
	.align	2
.L223:
	.word	.LANCHOR21
	.word	.LC31
	.size	nand_flash_print_info, .-nand_flash_print_info
	.section	.text.timer_delay_ns,"ax",%progbits
	.align	1
	.global	timer_delay_ns
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	timer_delay_ns, %function
timer_delay_ns:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	lsrs	r0, r0, #4
	sub	sp, sp, #8
	str	r0, [sp, #4]
.L226:
	ldr	r3, [sp, #4]
	subs	r2, r3, #1
	str	r2, [sp, #4]
	cmp	r3, #0
	bne	.L226
	add	sp, sp, #8
	@ sp needed
	bx	lr
	.size	timer_delay_ns, .-timer_delay_ns
	.section	.text.flash_read_status,"ax",%progbits
	.align	1
	.global	flash_read_status
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_read_status, %function
flash_read_status:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	movs	r3, #112
	mov	r1, r0
	str	r3, [r0, #8]
	movs	r0, #120
	bl	timer_delay_ns
	ldr	r0, [r1]
	uxtb	r0, r0
	pop	{r3, pc}
	.size	flash_read_status, .-flash_read_status
	.section	.text.toshiba_set_rr_para,"ax",%progbits
	.align	1
	.global	toshiba_set_rr_para
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	toshiba_set_rr_para, %function
toshiba_set_rr_para:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, lr}
	add	r6, r1, r1, lsl #2
	ldr	r8, .L237+16
	mov	r5, r0
	movs	r4, #0
	ldr	r7, .L237
.L230:
	ldrb	r3, [r8]	@ zero_extendqisi2
	cmp	r4, r3
	bcc	.L234
	pop	{r4, r5, r6, r7, r8, pc}
.L234:
	movs	r3, #85
	movs	r0, #200
	str	r3, [r5, #8]
	ldrsb	r3, [r4, r7]
	str	r3, [r5, #4]
	bl	timer_delay_ns
	ldr	r3, .L237+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #34
	bne	.L231
	adds	r3, r4, r6
	add	r3, r3, r7
.L236:
	ldrsb	r3, [r3, #5]
.L235:
	str	r3, [r5]
	adds	r4, r4, #1
	b	.L230
.L231:
	cmp	r3, #35
	bne	.L233
	ldr	r3, .L237+8
	adds	r2, r4, r6
	add	r3, r3, r2
	b	.L236
.L233:
	ldr	r3, .L237+12
	ldrsb	r3, [r3, r1]
	b	.L235
.L238:
	.align	2
.L237:
	.word	.LANCHOR22
	.word	.LANCHOR23
	.word	.LANCHOR24
	.word	.LANCHOR25
	.word	.LANCHOR26
	.size	toshiba_set_rr_para, .-toshiba_set_rr_para
	.section	.text.hynix_set_rr_para,"ax",%progbits
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	hynix_set_rr_para, %function
hynix_set_rr_para:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L244
	push	{r4, r5, r6, r7, r8, lr}
	lsls	r6, r0, #8
	ldr	r4, .L244+4
	ldr	r3, [r3]
	ldr	r7, [r4]
	ldrb	r2, [r3, #113]	@ zero_extendqisi2
	add	ip, r3, #128
	ldrb	r5, [r3, #112]	@ zero_extendqisi2
	mul	r4, r1, r2
	cmp	r5, #8
	it	ne
	movne	r5, #160
	add	r1, r3, #112
	add	r2, r2, #-1
	add	r8, ip, r2
	add	r4, r4, #32
	it	ne
	smlabbne	r4, r5, r0, r4
	add	r5, r3, #127
	movs	r0, #54
	add	r1, r1, r4
	adds	r4, r7, r6
	subs	r1, r1, #1
	str	r0, [r4, #2056]
.L242:
	cmp	r5, r8
	bne	.L243
	add	r6, r6, r7
	movs	r3, #22
	str	r3, [r6, #2056]
	pop	{r4, r5, r6, r7, r8, pc}
.L243:
	ldrb	r3, [r5, #1]!	@ zero_extendqisi2
	movs	r0, #120
	str	r3, [r4, #2052]
	bl	timer_delay_ns
	ldrsb	r3, [r1, #1]!
	str	r3, [r4, #2048]
	b	.L242
.L245:
	.align	2
.L244:
	.word	.LANCHOR27
	.word	.LANCHOR13
	.size	hynix_set_rr_para, .-hynix_set_rr_para
	.section	.text.hynix_reconfig_rr_para,"ax",%progbits
	.align	1
	.global	hynix_reconfig_rr_para
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	hynix_reconfig_rr_para, %function
hynix_reconfig_rr_para:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	mov	r4, r0
	ldr	r3, .L251
	ldrb	r3, [r3]	@ zero_extendqisi2
	subs	r3, r3, #1
	cmp	r3, #7
	bhi	.L246
	ldr	r5, .L251+4
	ldr	r3, [r5]
	add	r3, r3, r0
	ldrb	r3, [r3, #120]	@ zero_extendqisi2
	cbz	r3, .L246
	movs	r1, #0
	bl	hynix_set_rr_para
	ldr	r0, [r5]
	movs	r3, #0
	add	r0, r0, r4
	strb	r3, [r0, #120]
.L246:
	pop	{r3, r4, r5, pc}
.L252:
	.align	2
.L251:
	.word	.LANCHOR23
	.word	.LANCHOR27
	.size	hynix_reconfig_rr_para, .-hynix_reconfig_rr_para
	.section	.text.nandc_set_ddr_para,"ax",%progbits
	.align	1
	.global	nandc_set_ddr_para
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	nandc_set_ddr_para, %function
nandc_set_ddr_para:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L256
	ldr	r2, .L256+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldr	r2, [r2]
	cmp	r3, #9
	lsl	r3, r0, #16
	lsl	r0, r0, #8
	orr	r3, r3, r0
	orr	r3, r3, #3
	ite	eq
	streq	r3, [r2, #80]
	strne	r3, [r2, #304]
	bx	lr
.L257:
	.align	2
.L256:
	.word	.LANCHOR28
	.word	.LANCHOR13
	.size	nandc_set_ddr_para, .-nandc_set_ddr_para
	.section	.text.nandc_get_ddr_para,"ax",%progbits
	.align	1
	.global	nandc_get_ddr_para
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	nandc_get_ddr_para, %function
nandc_get_ddr_para:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L262
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #9
	ldr	r3, .L262+4
	ldr	r3, [r3]
	ite	eq
	ldreq	r0, [r3, #80]
	ldrne	r0, [r3, #304]
	ubfx	r0, r0, #8, #8
	bx	lr
.L263:
	.align	2
.L262:
	.word	.LANCHOR28
	.word	.LANCHOR13
	.size	nandc_get_ddr_para, .-nandc_get_ddr_para
	.section	.text.nandc_set_if_mode,"ax",%progbits
	.align	1
	.global	nandc_set_if_mode
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	nandc_set_if_mode, %function
nandc_set_if_mode:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L272
	ands	r1, r0, #6
	ldr	r3, [r3]
	ldr	r2, [r3]
	beq	.L265
	lsls	r1, r0, #29
	ldr	r1, .L272+4
	orr	r2, r2, #24576
	bfc	r2, #15, #1
	ldrb	r1, [r1]	@ zero_extendqisi2
	orr	r2, r2, #196608
	it	mi
	orrmi	r2, r2, #32768
	cmp	r1, #9
	ldr	r1, .L272+8
	bne	.L267
	movw	r0, #8321
	str	r0, [r3, #8]
	str	r1, [r3, #80]
	movs	r1, #38
	str	r1, [r3, #84]
	movs	r1, #39
	str	r1, [r3, #84]
.L268:
	str	r2, [r3]
	bx	lr
.L267:
	movw	r0, #8322
	str	r0, [r3, #344]
	str	r1, [r3, #304]
	movs	r1, #38
	str	r1, [r3, #308]
	movs	r1, #39
	str	r1, [r3, #308]
	b	.L268
.L265:
	bfi	r2, r1, #13, #1
	b	.L268
.L273:
	.align	2
.L272:
	.word	.LANCHOR13
	.word	.LANCHOR28
	.word	1052675
	.size	nandc_set_if_mode, .-nandc_set_if_mode
	.section	.text.nandc_cs,"ax",%progbits
	.align	1
	.global	nandc_cs
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	nandc_cs, %function
nandc_cs:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L275
	movs	r2, #1
	lsl	r0, r2, r0
	ldr	r1, [r3]
	ldr	r3, [r1]
	bfi	r3, r0, #0, #8
	str	r3, [r1]
	bx	lr
.L276:
	.align	2
.L275:
	.word	.LANCHOR13
	.size	nandc_cs, .-nandc_cs
	.section	.text.flash_wait_device_ready_raw,"ax",%progbits
	.align	1
	.global	flash_wait_device_ready_raw
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_wait_device_ready_raw, %function
flash_wait_device_ready_raw:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L283
	push	{r4, r5, r6, r7, r8, lr}
	mov	r4, r0
	mov	r5, r1
	mov	r6, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r0
	bhi	.L278
	movw	r2, #691
	ldr	r1, .L283+4
	ldr	r0, .L283+8
	bl	printf
.L278:
	ldr	r3, .L283+12
	lsrs	r7, r5, #16
	ldrb	r8, [r3, r4]	@ zero_extendqisi2
	ldr	r3, .L283+16
	mov	r0, r8
	ldr	r4, [r3]
	bl	nandc_cs
	lsrs	r1, r5, #8
	uxtb	r5, r5
	add	r4, r4, r8, lsl #8
.L281:
	movs	r0, #120
	str	r0, [r4, #2056]
	str	r5, [r4, #2052]
	str	r1, [r4, #2052]
	str	r7, [r4, #2052]
	bl	timer_delay_ns
	ldr	r0, [r4, #2048]
	uxtb	r0, r0
	bics	r3, r6, r0
	bne	.L281
	cmp	r0, #255
	beq	.L281
	bl	nandc_de_cs.constprop.30
	pop	{r4, r5, r6, r7, r8, pc}
.L284:
	.align	2
.L283:
	.word	.LANCHOR18
	.word	.LANCHOR29
	.word	.LC0
	.word	.LANCHOR30
	.word	.LANCHOR13
	.size	flash_wait_device_ready_raw, .-flash_wait_device_ready_raw
	.section	.text.flash_wait_device_ready,"ax",%progbits
	.align	1
	.global	flash_wait_device_ready
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_wait_device_ready, %function
flash_wait_device_ready:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, r8, r10, lr}
	tst	r0, #50331648
	ldr	r3, .L295
	mov	r7, r1
	ldrb	r5, [r3]	@ zero_extendqisi2
	mov	r3, #1
	rsb	r6, r5, #24
	lsl	r5, r3, r5
	lsl	r4, r3, r6
	asr	r6, r0, r6
	add	r5, r5, #-1
	add	r4, r4, #-1
	and	r5, r5, r6
	and	r4, r4, r0
	uxtb	r5, r5
	bne	.L286
	ldr	r3, .L295+4
	ldr	r10, .L295+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L287
	ldrb	r3, [r10]	@ zero_extendqisi2
	cbz	r3, .L286
.L287:
	ldr	r3, .L295+8
	mov	r0, r4
	ldrh	r6, [r3]
	mov	r1, r6
	bl	__aeabi_uidiv
	mov	r1, r6
	mul	r8, r6, r0
	mov	r0, r4
	bl	__aeabi_uidivmod
	ldrb	r3, [r10]	@ zero_extendqisi2
	cbz	r3, .L288
	add	r4, r8, r1, lsl #1
.L286:
	mov	r2, r7
	mov	r1, r4
	mov	r0, r5
	pop	{r3, r4, r5, r6, r7, r8, r10, lr}
	b	flash_wait_device_ready_raw
.L288:
	ldr	r3, .L295+12
	ldrh	r4, [r3, r1, lsl #1]
	add	r4, r4, r8
	b	.L286
.L296:
	.align	2
.L295:
	.word	.LANCHOR31
	.word	.LANCHOR0
	.word	.LANCHOR2
	.word	.LANCHOR3
	.word	.LANCHOR1
	.size	flash_wait_device_ready, .-flash_wait_device_ready
	.section	.text.nandc_de_cs,"ax",%progbits
	.align	1
	.global	nandc_de_cs
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	nandc_de_cs, %function
nandc_de_cs:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L298
	ldr	r2, [r3]
	ldr	r3, [r2]
	bfc	r3, #0, #8
	bfc	r3, #17, #1
	str	r3, [r2]
	bx	lr
.L299:
	.align	2
.L298:
	.word	.LANCHOR13
	.size	nandc_de_cs, .-nandc_de_cs
	.section	.text.nandc_wait_flash_ready_no_delay,"ax",%progbits
	.align	1
	.global	nandc_wait_flash_ready_no_delay
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	nandc_wait_flash_ready_no_delay, %function
nandc_wait_flash_ready_no_delay:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, lr}
	ldr	r1, .L305
	ldr	r4, .L305+4
.L302:
	ldr	r3, [r4]
	ldr	r3, [r3]
	str	r3, [sp, #4]
	ldr	r3, [sp, #4]
	lsls	r3, r3, #22
	bmi	.L303
	movs	r0, #10
	bl	timer_delay_ns
	subs	r1, r1, #1
	bne	.L302
	mov	r0, #-1
.L300:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, pc}
.L303:
	movs	r0, #0
	b	.L300
.L306:
	.align	2
.L305:
	.word	100000
	.word	.LANCHOR13
	.size	nandc_wait_flash_ready_no_delay, .-nandc_wait_flash_ready_no_delay
	.section	.text.zftl_flash_enter_slc_mode,"ax",%progbits
	.align	1
	.global	zftl_flash_enter_slc_mode
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	zftl_flash_enter_slc_mode, %function
zftl_flash_enter_slc_mode:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L328
	push	{r4, lr}
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L307
	ldr	r2, .L328+4
	cmp	r3, #1
	ldr	r4, [r2]
	bne	.L310
.L327:
	ldr	r3, .L328+8
	ldrb	r3, [r3, #29]	@ zero_extendqisi2
	cbz	r3, .L307
	add	r4, r4, r0, lsl #8
	str	r3, [r4, #2056]
	pop	{r4, pc}
.L310:
	cmp	r3, #2
	bne	.L312
	ldr	r3, .L328+12
	ldrb	r2, [r3, r0]	@ zero_extendqisi2
	cbz	r2, .L307
	movs	r2, #0
	strb	r2, [r3, r0]
	b	.L327
.L312:
	cmp	r3, #3
	bne	.L307
	ldr	r3, .L328+12
	ldrb	r2, [r3, r0]	@ zero_extendqisi2
	cbz	r2, .L307
	add	r4, r4, r0, lsl #8
	movs	r1, #0
	strb	r1, [r3, r0]
	movs	r3, #239
	str	r3, [r4, #2056]
	movs	r3, #145
	str	r3, [r4, #2052]
	movs	r0, #50
	bl	timer_delay_ns
	movs	r3, #1
	str	r1, [r4, #2048]
	movs	r0, #150
	str	r3, [r4, #2048]
	str	r1, [r4, #2048]
	str	r1, [r4, #2048]
	bl	timer_delay_ns
	bl	nandc_wait_flash_ready_no_delay
	movs	r3, #218
	movs	r0, #150
	str	r3, [r4, #2056]
	bl	timer_delay_ns
	pop	{r4, lr}
	b	nandc_wait_flash_ready_no_delay
.L307:
	pop	{r4, pc}
.L329:
	.align	2
.L328:
	.word	.LANCHOR0
	.word	.LANCHOR13
	.word	.LANCHOR32
	.word	.LANCHOR33
	.size	zftl_flash_enter_slc_mode, .-zftl_flash_enter_slc_mode
	.section	.text.zftl_flash_exit_slc_mode,"ax",%progbits
	.align	1
	.global	zftl_flash_exit_slc_mode
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	zftl_flash_exit_slc_mode, %function
zftl_flash_exit_slc_mode:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L353
	mov	r1, r0
	push	{r4, r5, r6, r7, r8, lr}
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L330
	ldr	r2, .L353+4
	cmp	r3, #1
	ldr	r5, [r2]
	bne	.L333
	ldr	r3, .L353+8
	ldrb	r3, [r3, #30]	@ zero_extendqisi2
.L352:
	cmp	r3, #0
	beq	.L330
	add	r1, r5, r1, lsl #8
	str	r3, [r1, #2056]
	pop	{r4, r5, r6, r7, r8, pc}
.L333:
	cmp	r3, #2
	bne	.L335
	ldr	r0, .L353+12
	ldrb	r3, [r0, r1]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L330
	ldr	r2, .L353+8
	ldrb	r3, [r2, #12]	@ zero_extendqisi2
	cmp	r3, #2
	it	ne
	movne	r3, #4
	strb	r3, [r0, r1]
	ldrb	r3, [r2, #30]	@ zero_extendqisi2
	b	.L352
.L335:
	cmp	r3, #3
	bne	.L330
	ldr	r6, .L353+12
	ldrb	r3, [r6, r0]	@ zero_extendqisi2
	cbnz	r3, .L330
	ldr	r8, .L353+8
	lsls	r7, r0, #8
	adds	r4, r5, r7
	add	r5, r5, r7
	ldrb	r3, [r8, #12]	@ zero_extendqisi2
	cmp	r3, #2
	it	ne
	movne	r3, #4
	strb	r3, [r6, r0]
	movs	r3, #239
	str	r3, [r4, #2056]
	movs	r3, #145
	str	r3, [r4, #2052]
	movs	r0, #50
	bl	timer_delay_ns
	ldrb	r3, [r8, #7]	@ zero_extendqisi2
	movs	r0, #150
	cmp	r3, #9
	mov	r3, #1
	itet	ne
	ldrbne	r2, [r6, r1]	@ zero_extendqisi2
	streq	r3, [r4, #2048]
	strne	r2, [r4, #2048]
	str	r3, [r4, #2048]
	movs	r3, #0
	str	r3, [r4, #2048]
	str	r3, [r4, #2048]
	bl	timer_delay_ns
	bl	nandc_wait_flash_ready_no_delay
	movs	r3, #223
	movs	r0, #150
	str	r3, [r5, #2056]
	bl	timer_delay_ns
	pop	{r4, r5, r6, r7, r8, lr}
	b	nandc_wait_flash_ready_no_delay
.L330:
	pop	{r4, r5, r6, r7, r8, pc}
.L354:
	.align	2
.L353:
	.word	.LANCHOR0
	.word	.LANCHOR13
	.word	.LANCHOR32
	.word	.LANCHOR33
	.size	zftl_flash_exit_slc_mode, .-zftl_flash_exit_slc_mode
	.section	.text.flash_start_page_read,"ax",%progbits
	.align	1
	.global	flash_start_page_read
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_start_page_read, %function
flash_start_page_read:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, r8, r10, lr}
	mov	r6, r0
	ldr	r3, .L364
	mov	r10, r1
	ldr	r4, .L364+4
	ldrb	r2, [r3]	@ zero_extendqisi2
	movs	r3, #1
	rsb	r7, r2, #24
	lsls	r3, r3, r2
	lsr	r2, r1, r7
	subs	r3, r3, #1
	ands	r3, r3, r2
	ldrb	r2, [r4]	@ zero_extendqisi2
	uxtb	r8, r3
	cmp	r2, r8
	bhi	.L356
	movw	r2, #866
	ldr	r1, .L364+8
	ldr	r0, .L364+12
	bl	printf
.L356:
	ldrb	r3, [r4]	@ zero_extendqisi2
	cmp	r3, r8
	bls	.L355
	ldr	r3, .L364+16
	movs	r4, #1
	lsls	r4, r4, r7
	ldrb	r7, [r3, r8]	@ zero_extendqisi2
	subs	r4, r4, #1
	ldr	r3, .L364+20
	and	r4, r4, r10
	ubfx	r10, r10, #24, #2
	mov	r0, r7
	ldr	r5, [r3]
	lsl	r8, r7, #8
	bl	nandc_cs
	cmp	r10, #0
	bne	.L358
	mov	r0, r4
	bl	slc_phy_page_address_calc
	ldr	r3, .L364+24
	mov	r4, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L359
	mov	r0, r7
	bl	zftl_flash_enter_slc_mode
.L359:
	add	r3, r5, r8
	movs	r2, #0
	str	r2, [r3, #2056]
	str	r2, [r3, #2052]
	str	r2, [r3, #2052]
	uxtb	r2, r4
	str	r2, [r3, #2052]
	lsrs	r2, r4, #8
	lsrs	r4, r4, #16
	str	r2, [r3, #2052]
	str	r4, [r3, #2052]
	str	r6, [r3, #2056]
	pop	{r3, r4, r5, r6, r7, r8, r10, lr}
	b	nandc_de_cs.constprop.30
.L358:
	ldr	r3, .L364+28
	ldr	r3, [r3]
	ldrb	r3, [r3, #12]	@ zero_extendqisi2
	cmp	r3, #3
	bne	.L360
	ldr	r3, .L364+32
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L360
	add	r3, r5, r8
	str	r10, [r3, #2056]
	b	.L359
.L360:
	mov	r0, r7
	bl	zftl_flash_exit_slc_mode
	b	.L359
.L355:
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L365:
	.align	2
.L364:
	.word	.LANCHOR31
	.word	.LANCHOR18
	.word	.LANCHOR34
	.word	.LC0
	.word	.LANCHOR30
	.word	.LANCHOR13
	.word	.LANCHOR0
	.word	.LANCHOR16
	.word	.LANCHOR35
	.size	flash_start_page_read, .-flash_start_page_read
	.section	.text.nandc_wait_flash_ready,"ax",%progbits
	.align	1
	.global	nandc_wait_flash_ready
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	nandc_wait_flash_ready, %function
nandc_wait_flash_ready:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, lr}
	movs	r0, #150
	bl	timer_delay_ns
	ldr	r4, .L371
	ldr	r1, .L371+4
.L368:
	ldr	r3, [r4]
	ldr	r3, [r3]
	str	r3, [sp, #4]
	ldr	r3, [sp, #4]
	lsls	r3, r3, #22
	bmi	.L369
	movs	r0, #10
	bl	timer_delay_ns
	subs	r1, r1, #1
	bne	.L368
	mov	r0, #-1
.L366:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, pc}
.L369:
	movs	r0, #0
	b	.L366
.L372:
	.align	2
.L371:
	.word	.LANCHOR13
	.word	100000
	.size	nandc_wait_flash_ready, .-nandc_wait_flash_ready
	.section	.text.sandisk_set_rr_para,"ax",%progbits
	.align	1
	.global	sandisk_set_rr_para
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	sandisk_set_rr_para, %function
sandisk_set_rr_para:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	movs	r3, #239
	str	r3, [r0, #8]
	movs	r3, #17
	mov	r4, r0
	str	r3, [r0, #4]
	movs	r0, #200
	bl	timer_delay_ns
	ldr	r3, .L379
	add	r1, r1, r1, lsl #2
	ldr	r6, .L379+4
	movs	r2, #0
	ldr	r7, .L379+8
	ldrb	r0, [r3]	@ zero_extendqisi2
	ldr	r3, .L379+12
	ldrb	r5, [r3]	@ zero_extendqisi2
.L374:
	cmp	r2, r0
	bcc	.L377
	pop	{r3, r4, r5, r6, r7, lr}
	b	nandc_wait_flash_ready
.L377:
	adds	r3, r2, r1
	cmp	r5, #67
	ite	eq
	addeq	r3, r3, r7
	addne	r3, r3, r6
	ldrsb	r3, [r3, #5]
	adds	r2, r2, #1
	str	r3, [r4]
	b	.L374
.L380:
	.align	2
.L379:
	.word	.LANCHOR26
	.word	.LANCHOR24
	.word	.LANCHOR22
	.word	.LANCHOR23
	.size	sandisk_set_rr_para, .-sandisk_set_rr_para
	.section	.text.toshiba_3d_set_tlc_rr_para,"ax",%progbits
	.align	1
	.global	toshiba_3d_set_tlc_rr_para
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	toshiba_3d_set_tlc_rr_para, %function
toshiba_3d_set_tlc_rr_para:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	movs	r6, #0
	movs	r7, #213
	mvn	r3, #118
	adds	r1, r1, #1
	mov	r4, r0
	str	r7, [r0, #8]
	rsb	r1, r1, r1, lsl #3
	str	r6, [r0, #4]
	str	r3, [r0, #4]
	ldr	r3, .L382
	adds	r5, r3, r1
	ldrsb	r3, [r3, r1]
	str	r3, [r0]
	ldrsb	r3, [r5, #1]
	str	r3, [r0]
	ldrsb	r3, [r5, #2]
	str	r3, [r0]
	ldrsb	r3, [r5, #3]
	str	r3, [r0]
	bl	nandc_wait_flash_ready
	mvn	r3, #117
	str	r7, [r4, #8]
	str	r6, [r4, #4]
	str	r3, [r4, #4]
	ldrsb	r3, [r5, #4]
	str	r3, [r4]
	ldrsb	r3, [r5, #5]
	str	r3, [r4]
	ldrsb	r3, [r5, #6]
	str	r3, [r4]
	str	r6, [r4]
	pop	{r3, r4, r5, r6, r7, lr}
	b	nandc_wait_flash_ready
.L383:
	.align	2
.L382:
	.word	.LANCHOR36
	.size	toshiba_3d_set_tlc_rr_para, .-toshiba_3d_set_tlc_rr_para
	.section	.text.toshiba_3d_set_slc_rr_para,"ax",%progbits
	.align	1
	.global	toshiba_3d_set_slc_rr_para
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	toshiba_3d_set_slc_rr_para, %function
toshiba_3d_set_slc_rr_para:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	movs	r3, #213
	mvn	r2, #116
	str	r3, [r0, #8]
	movs	r3, #0
	str	r3, [r0, #4]
	str	r2, [r0, #4]
	ldr	r2, .L385
	add	r1, r1, r2
	ldrsb	r2, [r1, #1]
	str	r2, [r0]
	str	r3, [r0]
	str	r3, [r0]
	str	r3, [r0]
	b	nandc_wait_flash_ready
.L386:
	.align	2
.L385:
	.word	.LANCHOR37
	.size	toshiba_3d_set_slc_rr_para, .-toshiba_3d_set_slc_rr_para
	.section	.text.toshiba_tlc_set_rr_para,"ax",%progbits
	.align	1
	.global	toshiba_tlc_set_rr_para
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	toshiba_tlc_set_rr_para, %function
toshiba_tlc_set_rr_para:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	movs	r6, #239
	mov	r4, r0
	str	r6, [r0, #8]
	cbz	r2, .L388
	movs	r3, #18
	rsb	r1, r1, r1, lsl #3
	str	r3, [r0, #4]
	ldr	r3, .L390
	adds	r5, r3, r1
	ldrb	r3, [r3, r1]	@ zero_extendqisi2
	str	r3, [r0]
	ldrb	r3, [r5, #1]	@ zero_extendqisi2
	str	r3, [r0]
	ldrb	r3, [r5, #2]	@ zero_extendqisi2
	str	r3, [r0]
	ldrb	r3, [r5, #3]	@ zero_extendqisi2
	str	r3, [r0]
	bl	nandc_wait_flash_ready
	movs	r3, #19
	str	r6, [r4, #8]
	str	r3, [r4, #4]
	ldrb	r3, [r5, #4]	@ zero_extendqisi2
	str	r3, [r4]
	ldrb	r3, [r5, #5]	@ zero_extendqisi2
	str	r3, [r4]
	ldrb	r3, [r5, #6]	@ zero_extendqisi2
	str	r3, [r4]
	movs	r3, #0
	str	r3, [r4]
.L389:
	pop	{r4, r5, r6, lr}
	b	nandc_wait_flash_ready
.L388:
	movs	r3, #20
	str	r3, [r0, #4]
	ldr	r3, .L390+4
	ldrb	r3, [r3, r1]	@ zero_extendqisi2
	str	r3, [r0]
	str	r2, [r0]
	str	r2, [r0]
	str	r2, [r0]
	b	.L389
.L391:
	.align	2
.L390:
	.word	.LANCHOR38
	.word	.LANCHOR39
	.size	toshiba_tlc_set_rr_para, .-toshiba_tlc_set_rr_para
	.section	.text.flash_erase_duplane_block,"ax",%progbits
	.align	1
	.global	flash_erase_duplane_block
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_erase_duplane_block, %function
flash_erase_duplane_block:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r5, r2
	ldr	r4, .L408
	mov	r7, r0
	mov	r6, r1
	mov	r8, r3
	ldrb	r2, [r4]	@ zero_extendqisi2
	cmp	r2, r0
	bhi	.L393
	movw	r2, #598
	ldr	r1, .L408+4
	ldr	r0, .L408+8
	bl	printf
.L393:
	ldrb	r3, [r4]	@ zero_extendqisi2
	cmp	r3, r7
	bls	.L400
	ldr	r3, .L408+12
	ldrb	r4, [r3, r7]	@ zero_extendqisi2
	ldr	r3, .L408+16
	add	r7, r4, #8
	ldr	r10, [r3]
	ldr	r3, .L408+20
	ldr	r3, [r3]
	add	r7, r10, r7, lsl #8
	lsls	r3, r3, #27
	bpl	.L395
	mov	r3, r8
	mov	r2, r5
	mov	r1, r4
	ldr	r0, .L408+24
	bl	printf
.L395:
	bl	nandc_wait_flash_ready
	mov	r0, r4
	bl	nandc_cs
	mov	r0, r4
	cmp	r6, #0
	bne	.L396
	bl	zftl_flash_enter_slc_mode
.L397:
	lsls	r4, r4, #8
	movs	r3, #96
	add	r6, r10, r4
	str	r3, [r6, #2056]
	uxtb	r3, r5
	str	r3, [r6, #2052]
	lsrs	r3, r5, #8
	str	r3, [r6, #2052]
	lsrs	r3, r5, #16
	str	r3, [r6, #2052]
	ldr	r3, .L408+28
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L401
	movs	r3, #208
	str	r3, [r6, #2056]
	bl	nandc_wait_flash_ready
	mov	r0, r7
	bl	flash_read_status
	and	fp, r0, #5
.L398:
	add	r0, r10, r4
	movs	r3, #96
	str	r3, [r0, #2056]
	uxtb	r3, r8
	lsr	r2, r8, #16
	str	r3, [r6, #2052]
	lsr	r3, r8, #8
	str	r3, [r6, #2052]
	movs	r3, #208
	str	r2, [r6, #2052]
	str	r3, [r0, #2056]
	bl	nandc_wait_flash_ready
	mov	r0, r7
	bl	flash_read_status
	bl	nandc_de_cs.constprop.30
	and	r3, r0, #5
	orrs	fp, r3, fp
	beq	.L399
	mov	r2, r0
	mov	r1, r5
	ldr	r0, .L408+32
	bl	printf
.L399:
	mov	r0, fp
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L396:
	bl	zftl_flash_exit_slc_mode
	b	.L397
.L401:
	mov	fp, #0
	b	.L398
.L400:
	mov	r0, #-1
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L409:
	.align	2
.L408:
	.word	.LANCHOR18
	.word	.LANCHOR40
	.word	.LC0
	.word	.LANCHOR30
	.word	.LANCHOR13
	.word	.LANCHOR14
	.word	.LC32
	.word	.LANCHOR41
	.word	.LC33
	.size	flash_erase_duplane_block, .-flash_erase_duplane_block
	.section	.text.flash_erase_block_en,"ax",%progbits
	.align	1
	.global	flash_erase_block_en
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_erase_block_en, %function
flash_erase_block_en:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L424
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r7, r2
	ldr	r5, .L424+4
	mov	r6, r0
	mov	fp, r1
	ldrb	r4, [r3]	@ zero_extendqisi2
	rsb	r3, r4, #24
	movs	r4, #1
	lsls	r4, r4, r3
	subs	r4, r4, #1
	ands	r4, r4, r2
	ldrb	r2, [r5]	@ zero_extendqisi2
	cmp	r2, r0
	bhi	.L411
	movw	r2, #645
	ldr	r1, .L424+8
	ldr	r0, .L424+12
	bl	printf
.L411:
	ldrb	r3, [r5]	@ zero_extendqisi2
	cmp	r3, r6
	bls	.L417
	ldr	r3, .L424+16
	ldrb	r8, [r3, r6]	@ zero_extendqisi2
	ldr	r3, .L424+20
	add	r10, r8, #8
	ldr	r5, [r3]
	ldr	r3, .L424+24
	ldr	r3, [r3]
	add	r10, r5, r10, lsl #8
	lsls	r3, r3, #27
	bpl	.L413
	mov	r3, fp
	mov	r2, r7
	mov	r1, r8
	ldr	r0, .L424+28
	bl	printf
.L413:
	bl	nandc_wait_flash_ready
	mov	r0, r8
	bl	nandc_cs
	mov	r0, r8
	cmp	fp, #0
	bne	.L414
	bl	zftl_flash_enter_slc_mode
.L415:
	add	r0, r5, r8, lsl #8
	movs	r3, #96
	str	r3, [r0, #2056]
	uxtb	r3, r4
	str	r3, [r0, #2052]
	lsrs	r3, r4, #8
	lsrs	r4, r4, #16
	str	r3, [r0, #2052]
	movs	r3, #208
	str	r4, [r0, #2052]
	str	r3, [r0, #2056]
	bl	nandc_wait_flash_ready
	mov	r0, r10
	bl	flash_read_status
	bl	nandc_de_cs.constprop.30
	ands	r4, r0, #5
	beq	.L416
	ldr	r3, .L424+32
	mov	r0, r7
	ldrh	r1, [r3]
	bl	__aeabi_uidiv
	mov	r3, r4
	mov	r2, r0
	mov	r1, r6
	ldr	r0, .L424+36
	bl	printf
.L416:
	mov	r0, r4
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L414:
	bl	zftl_flash_exit_slc_mode
	b	.L415
.L417:
	mov	r0, #-1
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L425:
	.align	2
.L424:
	.word	.LANCHOR31
	.word	.LANCHOR18
	.word	.LANCHOR42
	.word	.LC0
	.word	.LANCHOR30
	.word	.LANCHOR13
	.word	.LANCHOR14
	.word	.LC34
	.word	.LANCHOR2
	.word	.LC35
	.size	flash_erase_block_en, .-flash_erase_block_en
	.section	.text.flash_erase_block,"ax",%progbits
	.align	1
	.global	flash_erase_block
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_erase_block, %function
flash_erase_block:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	mov	r2, r1
	movs	r1, #0
	b	flash_erase_block_en
	.size	flash_erase_block, .-flash_erase_block
	.section	.text.flash_erase_all,"ax",%progbits
	.align	1
	.global	flash_erase_all
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_erase_all, %function
flash_erase_all:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L432
	push	{r4, r5, r6, r7, r8, lr}
	movs	r5, #0
	ldr	r7, .L432+4
	ldrb	r4, [r3, #13]	@ zero_extendqisi2
	ldrh	r3, [r3, #14]
	smulbb	r4, r4, r3
	uxth	r4, r4
.L428:
	ldr	r3, .L432+8
	ldrb	r2, [r3]	@ zero_extendqisi2
	uxth	r3, r5
	cmp	r2, r3
	bhi	.L431
	movs	r1, #0
	ldr	r0, .L432+12
	pop	{r4, r5, r6, r7, r8, lr}
	b	printf
.L431:
	ldr	r2, .L432+16
	uxth	r3, r5
	movs	r6, #0
	ldrb	r8, [r2, r3]	@ zero_extendqisi2
.L429:
	uxth	r3, r6
	cmp	r4, r3
	bhi	.L430
	adds	r5, r5, #1
	b	.L428
.L430:
	ldrh	r1, [r7]
	mov	r0, r8
	muls	r1, r6, r1
	adds	r6, r6, #1
	bl	flash_erase_block
	b	.L429
.L433:
	.align	2
.L432:
	.word	.LANCHOR32
	.word	.LANCHOR2
	.word	.LANCHOR18
	.word	.LC36
	.word	.LANCHOR30
	.size	flash_erase_all, .-flash_erase_all
	.section	.text.flash_start_plane_read,"ax",%progbits
	.align	1
	.global	flash_start_plane_read
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_start_plane_read, %function
flash_start_plane_read:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L453
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	ubfx	r7, r0, #24, #2
	ldrb	r5, [r3]	@ zero_extendqisi2
	movs	r3, #1
	rsb	r2, r5, #24
	lsl	r4, r3, r2
	lsl	r5, r3, r5
	ldr	r3, .L453+4
	lsr	r2, r0, r2
	subs	r5, r5, #1
	ands	r5, r5, r2
	subs	r4, r4, #1
	ldrb	r3, [r3]	@ zero_extendqisi2
	uxtb	r5, r5
	and	r6, r4, r0
	ands	r4, r4, r1
	cmp	r3, r5
	bhi	.L435
	movw	r2, #965
	ldr	r1, .L453+8
	ldr	r0, .L453+12
	bl	printf
.L435:
	ldr	r3, .L453+16
	ldr	fp, .L453+36
	ldrb	r5, [r3, r5]	@ zero_extendqisi2
	ldr	r3, .L453+20
	mov	r0, r5
	ldr	r8, [r3]
	lsl	r10, r5, #8
	bl	nandc_cs
	cmp	r7, #0
	bne	.L436
	mov	r0, r6
	bl	slc_phy_page_address_calc
	mov	r6, r0
	mov	r0, r4
	bl	slc_phy_page_address_calc
	ldr	r3, .L453+24
	mov	r4, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L437
	mov	r0, r5
	bl	zftl_flash_enter_slc_mode
.L437:
	ldr	r3, .L453+28
	ldrb	r2, [r3, #16]	@ zero_extendqisi2
	mov	r0, r3
	ldrb	r1, [r3, #8]	@ zero_extendqisi2
	cmp	r2, #1
	uxtb	r2, r6
	bne	.L439
	add	r5, r8, r10
	ldrb	r3, [r3, #9]	@ zero_extendqisi2
	str	r1, [r5, #2056]
	movs	r1, #0
	str	r1, [r5, #2052]
	str	r1, [r5, #2052]
	str	r2, [r5, #2052]
	lsrs	r2, r6, #8
	lsrs	r6, r6, #16
	str	r2, [r5, #2052]
	str	r6, [r5, #2052]
	str	r3, [r5, #2056]
	bl	nandc_wait_flash_ready
	ldr	r3, [fp]
	ldrb	r3, [r3, #12]	@ zero_extendqisi2
	cmp	r3, #3
	bne	.L440
	cbz	r7, .L440
	str	r7, [r5, #2056]
.L440:
	movs	r3, #0
	add	r8, r8, r10
	str	r3, [r8, #2056]
	str	r3, [r5, #2052]
	str	r3, [r5, #2052]
	uxtb	r3, r4
	str	r3, [r5, #2052]
	lsrs	r3, r4, #8
	lsrs	r4, r4, #16
	str	r3, [r5, #2052]
	str	r4, [r5, #2052]
.L452:
	movs	r3, #48
	str	r3, [r8, #2056]
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	nandc_de_cs.constprop.30
.L436:
	ldr	r3, [fp]
	ldrb	r3, [r3, #12]	@ zero_extendqisi2
	cmp	r3, #3
	bne	.L438
	ldr	r3, .L453+32
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L438
	add	r3, r8, r10
	str	r7, [r3, #2056]
	b	.L437
.L438:
	mov	r0, r5
	bl	zftl_flash_exit_slc_mode
	b	.L437
.L439:
	add	r3, r8, r10
	str	r1, [r3, #2056]
	str	r2, [r3, #2052]
	lsrs	r2, r6, #8
	lsrs	r6, r6, #16
	str	r2, [r3, #2052]
	ldr	r2, [fp]
	str	r6, [r3, #2052]
	ldrb	r2, [r2, #12]	@ zero_extendqisi2
	cmp	r2, #3
	bne	.L442
	cbz	r7, .L442
	str	r7, [r3, #2056]
.L442:
	ldrb	r2, [r0, #9]	@ zero_extendqisi2
	add	r8, r8, r10
	str	r2, [r8, #2056]
	uxtb	r2, r4
	str	r2, [r3, #2052]
	lsrs	r2, r4, #8
	lsrs	r4, r4, #16
	str	r2, [r3, #2052]
	str	r4, [r3, #2052]
	b	.L452
.L454:
	.align	2
.L453:
	.word	.LANCHOR31
	.word	.LANCHOR18
	.word	.LANCHOR43
	.word	.LC0
	.word	.LANCHOR30
	.word	.LANCHOR13
	.word	.LANCHOR0
	.word	.LANCHOR20
	.word	.LANCHOR35
	.word	.LANCHOR16
	.size	flash_start_plane_read, .-flash_start_plane_read
	.section	.text.flash_set_interface_mode,"ax",%progbits
	.align	1
	.global	flash_set_interface_mode
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_set_interface_mode, %function
flash_set_interface_mode:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, r8, r10, lr}
	mov	r6, r0
	ldr	r7, .L498
	mov	r10, #0
	ldr	r8, .L498+24
.L469:
	ldrb	r5, [r7, r10, lsl #3]	@ zero_extendqisi2
	cmp	r5, #69
	beq	.L456
	cmp	r5, #44
	beq	.L456
	add	r3, r5, #119
	uxtb	r3, r3
	cmp	r3, #18
	bhi	.L457
	ldr	r2, .L498+4
	lsr	r3, r2, r3
	lsls	r2, r3, #31
	bpl	.L457
.L456:
	ldr	r3, .L498+8
	cmp	r6, #1
	ldr	r4, [r8]
	ldrb	r1, [r3]	@ zero_extendqisi2
	bne	.L458
	lsls	r3, r1, #31
	bpl	.L457
	ldr	r3, .L498+12
	ldr	r3, [r3]
	lsls	r0, r3, #19
	bpl	.L459
	ldr	r0, .L498+16
	bl	printf
.L459:
	lsl	r3, r10, #8
	cmp	r5, #44
	mov	r1, #239
	add	r2, r4, r3
	str	r1, [r2, #2056]
	beq	.L460
	cmp	r5, #137
	bne	.L461
.L460:
	movs	r1, #1
	adds	r2, r4, r3
	str	r1, [r2, #2052]
	movs	r1, #5
.L495:
	add	r4, r4, r3
	str	r1, [r2, #2048]
.L497:
	movs	r3, #0
	str	r3, [r4, #2048]
	str	r3, [r4, #2048]
	str	r3, [r4, #2048]
.L457:
	add	r10, r10, #1
	cmp	r10, #4
	bne	.L469
	bl	nandc_wait_flash_ready
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L461:
	cmp	r5, #155
	itett	eq
	moveq	r1, #1
	movne	r1, #128
	streq	r1, [r2, #2052]
	moveq	r1, #3
	itt	ne
	strne	r1, [r2, #2052]
	movne	r1, #1
	b	.L495
.L458:
	lsls	r2, r1, #29
	bpl	.L457
	ldr	r3, .L498+12
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L464
	ldr	r0, .L498+20
	bl	printf
.L464:
	lsl	r2, r10, #8
	cmp	r5, #44
	mov	r1, #239
	add	r3, r4, r2
	str	r1, [r3, #2056]
	beq	.L465
	cmp	r5, #137
	bne	.L466
.L465:
	movs	r1, #1
	adds	r3, r4, r2
	str	r1, [r3, #2052]
	movs	r1, #35
.L496:
	str	r1, [r3, #2048]
	add	r4, r4, r2
	b	.L497
.L466:
	cmp	r5, #155
	itett	eq
	moveq	r1, #1
	movne	r1, #128
	streq	r1, [r3, #2052]
	moveq	r1, #37
	itt	ne
	strne	r1, [r3, #2052]
	movne	r1, #0
	b	.L496
.L499:
	.align	2
.L498:
	.word	.LANCHOR44
	.word	294913
	.word	.LANCHOR45
	.word	.LANCHOR14
	.word	.LC37
	.word	.LC38
	.word	.LANCHOR13
	.size	flash_set_interface_mode, .-flash_set_interface_mode
	.section	.text.mt_auto_read_calibration_config,"ax",%progbits
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	mt_auto_read_calibration_config, %function
mt_auto_read_calibration_config:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	mov	r5, r1
	mov	r6, r0
	bl	nandc_wait_flash_ready
	ldr	r3, .L501
	movs	r0, #200
	ldr	r4, [r3]
	movs	r3, #239
	add	r4, r4, r6, lsl #8
	str	r3, [r4, #2056]
	movs	r3, #150
	str	r3, [r4, #2052]
	bl	timer_delay_ns
	movs	r3, #0
	str	r5, [r4, #2048]
	str	r3, [r4, #2048]
	str	r3, [r4, #2048]
	str	r3, [r4, #2048]
	pop	{r4, r5, r6, pc}
.L502:
	.align	2
.L501:
	.word	.LANCHOR13
	.size	mt_auto_read_calibration_config, .-mt_auto_read_calibration_config
	.section	.text.flash_reset,"ax",%progbits
	.align	1
	.global	flash_reset
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_reset, %function
flash_reset:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L504
	ldr	r3, [r3]
	add	r0, r3, r0, lsl #8
	movs	r3, #255
	str	r3, [r0, #2056]
	b	nandc_wait_flash_ready
.L505:
	.align	2
.L504:
	.word	.LANCHOR13
	.size	flash_reset, .-flash_reset
	.section	.text.flash_read_id,"ax",%progbits
	.align	1
	.global	flash_read_id
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_read_id, %function
flash_read_id:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, lr}
	mov	r5, r0
	ldr	r3, .L508
	mov	r4, r1
	ldr	r6, [r3]
	bl	flash_reset
	mov	r0, r5
	bl	nandc_cs
	add	r6, r6, r5, lsl #8
	movs	r3, #144
	movs	r0, #200
	str	r3, [r6, #2056]
	movs	r3, #0
	str	r3, [r6, #2052]
	bl	timer_delay_ns
	ldr	r3, [r6, #2048]
	strb	r3, [r4]
	ldr	r3, [r6, #2048]
	strb	r3, [r4, #1]
	ldr	r3, [r6, #2048]
	strb	r3, [r4, #2]
	ldr	r3, [r6, #2048]
	strb	r3, [r4, #3]
	ldr	r3, [r6, #2048]
	strb	r3, [r4, #4]
	ldr	r3, [r6, #2048]
	strb	r3, [r4, #5]
	ldr	r3, [r6, #2048]
	strb	r3, [r4, #6]
	ldr	r3, [r6, #2048]
	strb	r3, [r4, #7]
	bl	nandc_de_cs.constprop.30
	ldrb	r2, [r4]	@ zero_extendqisi2
	subs	r3, r2, #1
	uxtb	r3, r3
	cmp	r3, #253
	bhi	.L506
	ldrb	r1, [r4, #5]	@ zero_extendqisi2
	ldrb	r3, [r4, #1]	@ zero_extendqisi2
	ldr	r0, .L508+4
	str	r1, [sp, #12]
	ldrb	r1, [r4, #4]	@ zero_extendqisi2
	str	r1, [sp, #8]
	ldrb	r1, [r4, #3]	@ zero_extendqisi2
	str	r1, [sp, #4]
	ldrb	r1, [r4, #2]	@ zero_extendqisi2
	str	r1, [sp]
	adds	r1, r5, #1
	bl	printf
.L506:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, pc}
.L509:
	.align	2
.L508:
	.word	.LANCHOR13
	.word	.LC39
	.size	flash_read_id, .-flash_read_id
	.section	.text.flash_read_spare,"ax",%progbits
	.align	1
	.global	flash_read_spare
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_read_spare, %function
flash_read_spare:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	mov	r5, r2
	ldr	r3, .L511
	ldr	r2, .L511+4
	ldrb	r3, [r3, #9]	@ zero_extendqisi2
	ldr	r4, [r2]
	movs	r2, #0
	lsls	r3, r3, #9
	add	r4, r4, r0, lsl #8
	str	r2, [r4, #2056]
	str	r3, [r4, #2052]
	lsrs	r3, r3, #8
	str	r3, [r4, #2052]
	uxtb	r3, r1
	str	r3, [r4, #2052]
	lsrs	r3, r1, #8
	lsrs	r1, r1, #16
	str	r3, [r4, #2052]
	movs	r3, #48
	str	r1, [r4, #2052]
	str	r3, [r4, #2056]
	bl	nandc_wait_flash_ready
	ldr	r3, [r4, #2048]
	strb	r3, [r5]
	pop	{r3, r4, r5, pc}
.L512:
	.align	2
.L511:
	.word	.LANCHOR32
	.word	.LANCHOR13
	.size	flash_read_spare, .-flash_read_spare
	.section	.text.flash_read_otp_data,"ax",%progbits
	.align	1
	.global	flash_read_otp_data
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_read_otp_data, %function
flash_read_otp_data:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L516
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r8, r0
	lsl	r8, r8, #8
	mov	r6, r1
	mov	r5, r2
	ldr	r7, [r3]
	mov	fp, #144
	bl	nandc_cs
	movs	r3, #239
	movs	r0, #50
	add	r4, r7, r8
	mov	r10, #0
	str	r3, [r4, #2056]
	str	fp, [r4, #2052]
	bl	timer_delay_ns
	movs	r3, #1
	str	r3, [r4, #2048]
	str	r10, [r4, #2048]
	str	r10, [r4, #2048]
	str	r10, [r4, #2048]
	bl	nandc_wait_flash_ready
	movs	r3, #238
	ldr	r0, .L516+4
	str	r3, [r4, #2056]
	str	fp, [r4, #2052]
	ldr	r2, [r4, #2048]
	ldr	r3, [r4, #2048]
	ldr	r1, [r4, #2048]
	str	r1, [sp]
	mov	r1, r6
	bl	printf
	bl	nandc_wait_flash_ready
	uxtb	r3, r6
	str	r10, [r4, #2056]
	str	r10, [r4, #2052]
	str	r10, [r4, #2052]
	str	r3, [r4, #2052]
	lsrs	r3, r6, #8
	lsrs	r6, r6, #16
	str	r3, [r4, #2052]
	movs	r3, #48
	str	r6, [r4, #2052]
	str	r3, [r4, #2056]
	bl	nandc_wait_flash_ready
	add	r3, r5, #16384
	mov	r2, r5
.L514:
	ldr	r1, [r4, #2048]
	strb	r1, [r2], #1
	cmp	r2, r3
	bne	.L514
	add	r7, r7, r8
	movs	r3, #239
	str	r3, [r7, #2056]
	movs	r3, #144
	str	r3, [r4, #2052]
	movs	r0, #50
	bl	timer_delay_ns
	movs	r3, #0
	str	r3, [r4, #2048]
	str	r3, [r4, #2048]
	str	r3, [r4, #2048]
	str	r3, [r4, #2048]
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	nandc_de_cs.constprop.30
.L517:
	.align	2
.L516:
	.word	.LANCHOR13
	.word	.LC40
	.size	flash_read_otp_data, .-flash_read_otp_data
	.section	.text.sandisk_prog_test_bad_block,"ax",%progbits
	.align	1
	.global	sandisk_prog_test_bad_block
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	sandisk_prog_test_bad_block, %function
sandisk_prog_test_bad_block:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	lsls	r0, r0, #8
	ldr	r3, .L528
	mov	r5, r1
	ldr	r4, [r3]
	ldr	r3, .L528+4
	ldrb	r3, [r3, #29]	@ zero_extendqisi2
	cbz	r3, .L519
	adds	r2, r4, r0
	str	r3, [r2, #2056]
.L520:
	add	r4, r4, r0
	movs	r3, #128
	str	r3, [r4, #2056]
	movs	r3, #0
	str	r3, [r4, #2052]
	str	r3, [r4, #2052]
	uxtb	r3, r5
	str	r3, [r4, #2052]
	lsrs	r3, r5, #8
	str	r3, [r4, #2052]
	lsrs	r3, r5, #16
	str	r3, [r4, #2052]
	movs	r3, #16
	str	r3, [r4, #2056]
	bl	nandc_wait_flash_ready
	movs	r3, #112
	movs	r0, #80
	str	r3, [r4, #2056]
	bl	timer_delay_ns
	ldr	r2, [r4, #2048]
	ands	r4, r2, #5
	beq	.L518
	ldr	r3, .L528+8
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L518
	mov	r1, r5
	ldr	r0, .L528+12
	bl	printf
.L518:
	mov	r0, r4
	pop	{r3, r4, r5, pc}
.L519:
	adds	r3, r4, r0
	movs	r2, #162
	str	r2, [r3, #2056]
	b	.L520
.L529:
	.align	2
.L528:
	.word	.LANCHOR13
	.word	.LANCHOR32
	.word	.LANCHOR14
	.word	.LC41
	.size	sandisk_prog_test_bad_block, .-sandisk_prog_test_bad_block
	.section	.text.nandc_rdy_status,"ax",%progbits
	.align	1
	.global	nandc_rdy_status
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	nandc_rdy_status, %function
nandc_rdy_status:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L531
	sub	sp, sp, #8
	ldr	r3, [r3]
	ldr	r3, [r3]
	str	r3, [sp, #4]
	ldr	r0, [sp, #4]
	ubfx	r0, r0, #9, #1
	add	sp, sp, #8
	@ sp needed
	bx	lr
.L532:
	.align	2
.L531:
	.word	.LANCHOR13
	.size	nandc_rdy_status, .-nandc_rdy_status
	.section	.text.nandc_bch_sel,"ax",%progbits
	.align	1
	.global	nandc_bch_sel
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	nandc_bch_sel, %function
nandc_bch_sel:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	movs	r3, #0
	push	{r0, r1, r4, lr}
	str	r3, [sp, #4]
	ldr	r2, [sp, #4]
	orr	r2, r2, #1
	str	r2, [sp, #4]
	ldr	r2, .L544
	strb	r0, [r2]
	ldr	r2, .L544+4
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, #9
	ldr	r2, .L544+8
	bne	.L534
	ldr	r2, [r2]
	cmp	r0, #70
	ldr	r1, [sp, #4]
	str	r1, [r2, #16]
	beq	.L535
	cmp	r0, #60
	beq	.L541
	cmp	r0, #40
	ite	eq
	moveq	r3, #2
	movne	r3, #1
.L535:
	movs	r1, #0
	str	r1, [sp]
	ldr	r1, [sp]
	bfi	r1, r3, #25, #3
	str	r1, [sp]
	ldr	r3, [sp]
	orr	r3, r3, #1
	str	r3, [sp]
	ldr	r3, [sp]
	str	r3, [r2, #32]
.L533:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, pc}
.L541:
	movs	r3, #3
	b	.L535
.L534:
	ldr	r1, [r2]
	movs	r4, #16
	ldr	r2, [sp, #4]
	cmp	r0, r4
	str	r2, [r1, #8]
	str	r3, [sp]
	ldr	r2, [sp]
	bfi	r2, r4, #8, #8
	str	r2, [sp]
	ldr	r2, [sp]
	bfi	r2, r3, #18, #1
	str	r2, [sp]
	bne	.L537
.L543:
	ldr	r2, [sp]
	bfi	r2, r3, #4, #1
	str	r2, [sp]
	b	.L538
.L537:
	cmp	r0, #24
	bne	.L539
	ldr	r3, [sp]
	orr	r3, r3, #16
	str	r3, [sp]
.L538:
	ldr	r3, [sp]
	orr	r3, r3, #1
	str	r3, [sp]
	ldr	r3, [sp]
	str	r3, [r1, #12]
	b	.L533
.L539:
	ldr	r2, [sp]
	cmp	r0, #40
	orr	r2, r2, #262144
	str	r2, [sp]
	ldr	r2, [sp]
	orr	r2, r2, #16
	str	r2, [sp]
	bne	.L538
	b	.L543
.L545:
	.align	2
.L544:
	.word	.LANCHOR46
	.word	.LANCHOR28
	.word	.LANCHOR13
	.size	nandc_bch_sel, .-nandc_bch_sel
	.section	.text.zftl_nandc_get_irq_status,"ax",%progbits
	.align	1
	.global	zftl_nandc_get_irq_status
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	zftl_nandc_get_irq_status, %function
zftl_nandc_get_irq_status:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L549
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #9
	ite	eq
	ldreq	r0, [r0, #296]
	ldrne	r0, [r0, #372]
	bx	lr
.L550:
	.align	2
.L549:
	.word	.LANCHOR28
	.size	zftl_nandc_get_irq_status, .-zftl_nandc_get_irq_status
	.section	.text.rk_nandc_flash_ready,"ax",%progbits
	.align	1
	.global	rk_nandc_flash_ready
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	rk_nandc_flash_ready, %function
rk_nandc_flash_ready:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	bx	lr
	.size	rk_nandc_flash_ready, .-rk_nandc_flash_ready
	.section	.text.nandc_iqr_wait_flash_ready,"ax",%progbits
	.align	1
	.global	nandc_iqr_wait_flash_ready
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	nandc_iqr_wait_flash_ready, %function
nandc_iqr_wait_flash_ready:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	bx	lr
	.size	nandc_iqr_wait_flash_ready, .-nandc_iqr_wait_flash_ready
	.section	.text.rk_nandc_flash_xfer_completed,"ax",%progbits
	.align	1
	.global	rk_nandc_flash_xfer_completed
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	rk_nandc_flash_xfer_completed, %function
rk_nandc_flash_xfer_completed:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	bx	lr
	.size	rk_nandc_flash_xfer_completed, .-rk_nandc_flash_xfer_completed
	.section	.text.nandc_xfer_start,"ax",%progbits
	.align	1
	.global	nandc_xfer_start
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	nandc_xfer_start, %function
nandc_xfer_start:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r5, r0
	ldr	r0, .L570
	and	lr, r5, #1
	ldr	r4, .L570+4
	ldrb	r0, [r0]	@ zero_extendqisi2
	ldr	r7, .L570+8
	cmp	r0, #9
	add	r0, r1, #1
	bne	.L555
	movs	r6, #0
	mov	ip, #1
	str	r6, [sp, #4]
	ubfx	r0, r0, #1, #6
	ldr	r1, [sp, #4]
	bfi	r1, lr, #1, #1
	str	r1, [sp, #4]
	ldr	r1, [sp, #4]
	orr	r1, r1, #8
	str	r1, [sp, #4]
	ldr	r1, [sp, #4]
	bfi	r1, ip, #5, #2
	str	r1, [sp, #4]
	ldr	r1, [sp, #4]
	orr	r1, r1, #536870912
	str	r1, [sp, #4]
	ldr	r1, [sp, #4]
	orr	r1, r1, #1024
	str	r1, [sp, #4]
	ldr	r1, [sp, #4]
	bfi	r1, r6, #4, #1
	str	r1, [sp, #4]
	ldr	r1, [sp, #4]
	bfi	r1, r0, #22, #6
	str	r1, [sp, #4]
	ldr	r1, [sp, #4]
	orr	r1, r1, #128
	str	r1, [sp, #4]
	ldr	r1, .L570+12
	ldrb	r1, [r1]	@ zero_extendqisi2
	cbz	r1, .L556
	ldr	r1, .L570+16
	ldrb	r1, [r1]	@ zero_extendqisi2
	cbz	r1, .L556
	ldr	r1, [sp, #4]
	orr	r1, r1, #512
	str	r1, [sp, #4]
.L556:
	ldr	r1, [sp, #4]
	bic	r0, r2, #63
	str	r3, [r4, #8]
	clz	r5, r5
	str	r3, [r4, #16]
	add	r3, r2, #63
	bic	r3, r3, #63
	ubfx	r1, r1, #22, #6
	add	r1, r3, r1, lsl #10
	str	r2, [r4, #4]
	str	r2, [r4, #12]
	lsrs	r5, r5, #5
	bl	flush_dcache_range
	ldr	r0, [r4, #8]
	add	r1, r0, #63
	bic	r0, r0, #63
	bic	r1, r1, #63
	adds	r1, r1, #64
	bl	flush_dcache_range
	movs	r3, #1
	ldr	r2, [r4, #12]
	str	r3, [r4, #20]
	movs	r1, #16
	ldr	r3, [r7]
	str	r2, [r3, #52]
	ldr	r2, [r4, #16]
	str	r2, [r3, #56]
	ldr	r2, [r3, #48]
	str	r2, [sp, #8]
	ldr	r2, [sp, #8]
	bfi	r2, r1, #9, #5
	movs	r1, #2
	str	r2, [sp, #8]
	ldr	r2, [sp, #8]
	orr	r2, r2, #448
	str	r2, [sp, #8]
	ldr	r2, [sp, #8]
	bfi	r2, r1, #3, #3
	str	r2, [sp, #8]
	ldr	r2, [sp, #8]
	orr	r2, r2, #4
	str	r2, [sp, #8]
	ldr	r2, [sp, #8]
	bfi	r2, r5, #1, #1
	str	r2, [sp, #8]
	ldr	r2, [sp, #8]
	orr	r2, r2, #1
	str	r2, [sp, #8]
	ldr	r2, .L570+20
	ldrh	r1, [r2]
	ldr	r2, [sp, #8]
	bfi	r2, r1, #16, #11
	str	r2, [sp, #8]
	ldr	r2, [sp, #8]
	str	r2, [r3, #48]
	ldr	r2, [sp, #4]
	str	r2, [r3, #16]
	ldr	r2, [sp, #4]
	orr	r2, r2, #4
	str	r2, [sp, #4]
	ldr	r2, [sp, #4]
	str	r2, [r3, #16]
.L554:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L555:
	ldr	r6, [r7]
	mov	ip, #16
	ubfx	r0, r0, #1, #6
	ldr	r6, [r6, #12]
	str	r6, [sp, #12]
	ldr	r6, [sp, #12]
	bfi	r6, ip, #8, #8
	str	r6, [sp, #12]
	ldr	r6, [sp, #12]
	bfc	r6, #3, #1
	str	r6, [sp, #12]
	ldr	r6, [sp, #12]
	bfc	r6, #5, #3
	str	r6, [sp, #12]
	movs	r6, #0
	str	r6, [sp, #4]
	ldr	ip, [sp, #4]
	bfi	ip, lr, #1, #1
	mov	lr, #1
	str	ip, [sp, #4]
	ldr	ip, [sp, #4]
	orr	ip, ip, #8
	str	ip, [sp, #4]
	ldr	ip, [sp, #4]
	bfi	ip, lr, #5, #2
	str	ip, [sp, #4]
	ldr	ip, [sp, #4]
	orr	ip, ip, #536870912
	str	ip, [sp, #4]
	ldr	ip, [sp, #4]
	orr	ip, ip, #1024
	str	ip, [sp, #4]
	ldr	ip, [sp, #4]
	bfi	ip, r6, #4, #1
	str	ip, [sp, #4]
	ldr	ip, [sp, #4]
	bfi	ip, r0, #22, #6
	str	ip, [sp, #4]
	cmp	r5, #0
	beq	.L558
	ldr	r0, .L570+24
	lsrs	r1, r1, #1
	ldr	r8, [r4]
	ldrb	r0, [r0]	@ zero_extendqisi2
	cmp	r0, #25
	mov	r0, r6
	ite	cc
	movcc	lr, #64
	movcs	lr, #128
.L560:
	cmp	r0, r1
	add	fp, r3, r0, lsl #2
	add	r10, lr, r6
	blt	.L561
.L562:
	ldr	r3, [r4]
	bic	r0, r2, #63
	ldr	r1, [sp, #4]
	clz	r5, r5
	str	r2, [r4, #4]
	lsrs	r5, r5, #5
	str	r3, [r4, #8]
	str	r3, [r4, #16]
	add	r3, r2, #63
	bic	r3, r3, #63
	ubfx	r1, r1, #22, #6
	add	r1, r3, r1, lsl #10
	str	r2, [r4, #12]
	bl	flush_dcache_range
	ldr	r0, [r4, #8]
	ldr	r1, [sp, #4]
	add	r3, r0, #63
	bic	r0, r0, #63
	bic	r3, r3, #63
	ubfx	r1, r1, #22, #6
	add	r1, r3, r1, lsl #7
	bl	flush_dcache_range
	movs	r3, #1
	ldr	r2, [r4, #12]
	str	r3, [r4, #20]
	movs	r1, #16
	ldr	r3, [r7]
	str	r2, [r3, #20]
	ldr	r2, [r4, #16]
	str	r2, [r3, #24]
	movs	r2, #0
	str	r2, [sp, #8]
	ldr	r2, [sp, #8]
	bfi	r2, r1, #9, #5
	movs	r1, #2
	str	r2, [sp, #8]
	ldr	r2, [sp, #8]
	orr	r2, r2, #448
	str	r2, [sp, #8]
	ldr	r2, [sp, #8]
	bfi	r2, r1, #3, #3
	str	r2, [sp, #8]
	ldr	r2, [sp, #8]
	orr	r2, r2, #4
	str	r2, [sp, #8]
	ldr	r2, [sp, #8]
	bfi	r2, r5, #1, #1
	str	r2, [sp, #8]
	ldr	r2, [sp, #8]
	orr	r2, r2, #1
	str	r2, [sp, #8]
	ldr	r2, [sp, #8]
	str	r2, [r3, #16]
	ldr	r2, [sp, #12]
	str	r2, [r3, #12]
	ldr	r2, [sp, #4]
	str	r2, [r3, #8]
	ldr	r2, [sp, #4]
	orr	r2, r2, #4
	str	r2, [sp, #4]
	ldr	r2, [sp, #4]
	str	r2, [r3, #8]
	b	.L554
.L561:
	ldrh	ip, [r3, r0, lsl #2]
	bic	r6, r6, #3
	ldrh	fp, [fp, #2]
	adds	r0, r0, #1
	orr	ip, ip, fp, lsl #16
	str	ip, [r8, r6]
	mov	r6, r10
	b	.L560
.L558:
	ldr	r3, [r4]
	str	lr, [r3]
	b	.L562
.L571:
	.align	2
.L570:
	.word	.LANCHOR28
	.word	.LANCHOR49
	.word	.LANCHOR13
	.word	.LANCHOR47
	.word	.LANCHOR48
	.word	.LANCHOR50
	.word	.LANCHOR46
	.size	nandc_xfer_start, .-nandc_xfer_start
	.section	.text.nandc_set_seed,"ax",%progbits
	.align	1
	.global	nandc_set_seed
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	nandc_set_seed, %function
nandc_set_seed:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r2, .L579
	and	r0, r0, #127
	ldr	r3, .L579+4
	ldrb	r2, [r2]	@ zero_extendqisi2
	ldrh	r3, [r3, r0, lsl #1]
	cbz	r2, .L573
	orr	r3, r3, #-1073741824
.L573:
	ldr	r2, .L579+8
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, #9
	ldr	r2, .L579+12
	ldr	r2, [r2]
	ite	eq
	streq	r3, [r2, #520]
	strne	r3, [r2, #336]
	bx	lr
.L580:
	.align	2
.L579:
	.word	.LANCHOR48
	.word	.LANCHOR51
	.word	.LANCHOR28
	.word	.LANCHOR13
	.size	nandc_set_seed, .-nandc_set_seed
	.section	.text.zftl_flash_de_init,"ax",%progbits
	.align	1
	.global	zftl_flash_de_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	zftl_flash_de_init, %function
zftl_flash_de_init:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	bl	nandc_wait_flash_ready
	ldr	r3, .L600
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L582
	ldr	r3, .L600+4
	ldrb	r0, [r3]	@ zero_extendqisi2
	cbnz	r0, .L582
	ldr	r3, .L600+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #9
	beq	.L582
	bl	zftl_flash_exit_slc_mode
.L582:
	ldr	r4, .L600+12
	movs	r0, #0
	bl	hynix_reconfig_rr_para
	ldrb	r3, [r4]	@ zero_extendqisi2
	cbz	r3, .L583
	ldr	r3, .L600+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	lsls	r3, r3, #31
	bpl	.L583
	movs	r0, #1
	bl	flash_set_interface_mode
	movs	r0, #1
	bl	nandc_set_if_mode
	movs	r3, #0
	strb	r3, [r4]
.L583:
	ldr	r1, .L600+20
	ldrb	r3, [r1]	@ zero_extendqisi2
	cbz	r3, .L584
	movs	r0, #0
	strb	r0, [r1]
	bl	nandc_set_seed
	movs	r3, #1
	strb	r3, [r1]
.L584:
	movs	r0, #0
	pop	{r4, pc}
.L601:
	.align	2
.L600:
	.word	.LANCHOR0
	.word	.LANCHOR19
	.word	.LANCHOR28
	.word	.LANCHOR21
	.word	.LANCHOR45
	.word	.LANCHOR48
	.size	zftl_flash_de_init, .-zftl_flash_de_init
	.section	.text.nandc_randomizer_enable,"ax",%progbits
	.align	1
	.global	nandc_randomizer_enable
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	nandc_randomizer_enable, %function
nandc_randomizer_enable:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L603
	strb	r0, [r3]
	bx	lr
.L604:
	.align	2
.L603:
	.word	.LANCHOR48
	.size	nandc_randomizer_enable, .-nandc_randomizer_enable
	.section	.text.nandc_get_chip_if,"ax",%progbits
	.align	1
	.global	nandc_get_chip_if
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	nandc_get_chip_if, %function
nandc_get_chip_if:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L606
	adds	r0, r0, #8
	ldr	r3, [r3]
	add	r0, r3, r0, lsl #8
	bx	lr
.L607:
	.align	2
.L606:
	.word	.LANCHOR13
	.size	nandc_get_chip_if, .-nandc_get_chip_if
	.section	.text.buf_reinit,"ax",%progbits
	.align	1
	.global	buf_reinit
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	buf_reinit, %function
buf_reinit:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L611
	movs	r2, #0
	push	{r4, r5, lr}
	mov	r1, r2
	mov	r4, r3
.L609:
	uxtb	r0, r2
	adds	r2, r2, #1
	cmp	r2, #32
	strb	r1, [r3, #2]
	add	r5, r0, #1
	strb	r0, [r3, #1]
	strb	r5, [r3]
	add	r3, r3, #48
	str	r1, [r3, #-40]
	bne	.L609
	movs	r3, #255
	strb	r3, [r4, #1488]
	ldr	r3, .L611+4
	strb	r1, [r3]
	ldr	r3, .L611+8
	strb	r2, [r3]
	pop	{r4, r5, pc}
.L612:
	.align	2
.L611:
	.word	.LANCHOR52
	.word	.LANCHOR53
	.word	.LANCHOR54
	.size	buf_reinit, .-buf_reinit
	.section	.text.buf_add_tail,"ax",%progbits
	.align	1
	.global	buf_add_tail
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	buf_add_tail, %function
buf_add_tail:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	movs	r3, #255
	push	{r4, r5, r6, lr}
	strb	r3, [r1]
	mov	r5, r0
	mov	r4, r1
	ldrb	r3, [r0]	@ zero_extendqisi2
	cmp	r3, #255
	bne	.L614
	ldrb	r3, [r1, #1]	@ zero_extendqisi2
	cmp	r3, #255
	bne	.L615
	movs	r2, #74
	ldr	r1, .L620
	ldr	r0, .L620+4
	bl	printf
.L615:
	ldrb	r3, [r4, #1]	@ zero_extendqisi2
	strb	r3, [r5]
	pop	{r4, r5, r6, pc}
.L614:
	ldr	r2, .L620+8
	movs	r1, #48
	mov	r6, r2
.L619:
	mov	r5, r3
	muls	r3, r1, r3
	ldrb	r3, [r2, r3]	@ zero_extendqisi2
	cmp	r3, #255
	bne	.L619
	ldrb	r3, [r4, #1]	@ zero_extendqisi2
	cmp	r3, #255
	bne	.L617
	movs	r2, #81
	ldr	r1, .L620
	ldr	r0, .L620+4
	bl	printf
.L617:
	movs	r3, #48
	ldrb	r2, [r4, #1]	@ zero_extendqisi2
	muls	r3, r5, r3
	strb	r2, [r6, r3]
	pop	{r4, r5, r6, pc}
.L621:
	.align	2
.L620:
	.word	.LANCHOR55
	.word	.LC0
	.word	.LANCHOR52
	.size	buf_add_tail, .-buf_add_tail
	.section	.text.queue_read_cmd,"ax",%progbits
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	queue_read_cmd, %function
queue_read_cmd:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	mov	r4, r0
	ldr	r1, [r0, #24]
	movs	r0, #48
	bl	flash_start_page_read
	movs	r3, #1
	mov	r1, r4
	strb	r3, [r4, #42]
	movs	r3, #0
	strb	r3, [r4, #43]
	movs	r3, #255
	strb	r3, [r4]
	ldr	r0, .L623
	pop	{r4, lr}
	b	buf_add_tail
.L624:
	.align	2
.L623:
	.word	.LANCHOR56
	.size	queue_read_cmd, .-queue_read_cmd
	.section	.text.zbuf_free,"ax",%progbits
	.align	1
	.global	zbuf_free
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	zbuf_free, %function
zbuf_free:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	mov	r1, r0
	ldrb	r3, [r0, #2]	@ zero_extendqisi2
	and	r3, r3, #8
	strb	r3, [r0, #2]
	cbz	r3, .L626
	ldr	r3, [r0, #20]
	adds	r3, r3, #1
	beq	.L626
	ldr	r0, .L634
	bl	buf_add_tail
.L627:
	ldr	r2, .L634+4
	ldrb	r3, [r2]	@ zero_extendqisi2
	adds	r3, r3, #1
	strb	r3, [r2]
	pop	{r3, pc}
.L626:
	ldr	r3, .L634
	ldrb	r2, [r3]	@ zero_extendqisi2
	strb	r2, [r1]
	ldrb	r2, [r1, #1]	@ zero_extendqisi2
	strb	r2, [r3]
	b	.L627
.L635:
	.align	2
.L634:
	.word	.LANCHOR53
	.word	.LANCHOR54
	.size	zbuf_free, .-zbuf_free
	.section	.text.buf_alloc,"ax",%progbits
	.align	1
	.global	buf_alloc
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	buf_alloc, %function
buf_alloc:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	mov	r7, r0
	ldr	r4, .L646
	ldrb	r3, [r4]	@ zero_extendqisi2
	cbz	r3, .L637
.L640:
	ldr	r5, .L646+4
	ldr	r2, .L646+8
	ldrb	r6, [r5]	@ zero_extendqisi2
	add	r0, r6, r6, lsl #1
	add	r0, r2, r0, lsl #4
	cbz	r7, .L638
.L639:
	movs	r1, #48
	muls	r1, r6, r1
	ldrb	r6, [r2, r1]	@ zero_extendqisi2
	adds	r3, r2, r1
	strb	r6, [r5]
	ldrb	r5, [r4]	@ zero_extendqisi2
	subs	r5, r5, #1
	strb	r5, [r4]
	movs	r4, #1
	strb	r4, [r3, #2]
	movs	r4, #255
	strb	r4, [r2, r1]
	mov	r2, #-1
	str	r2, [r3, #20]
	movs	r2, #0
	strh	r2, [r3, #34]	@ movhi
	str	r2, [r3, #8]
	strb	r2, [r3, #40]
	strb	r2, [r3, #41]
	pop	{r3, r4, r5, r6, r7, pc}
.L637:
	movs	r2, #121
	ldr	r1, .L646+12
	ldr	r0, .L646+16
	bl	printf
	ldrb	r3, [r4]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L640
.L642:
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, pc}
.L638:
	ldrb	r3, [r4]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L639
	b	.L642
.L647:
	.align	2
.L646:
	.word	.LANCHOR54
	.word	.LANCHOR53
	.word	.LANCHOR52
	.word	.LANCHOR57
	.word	.LC0
	.size	buf_alloc, .-buf_alloc
	.section	.text.buf_remove_buf,"ax",%progbits
	.align	1
	.global	buf_remove_buf
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	buf_remove_buf, %function
buf_remove_buf:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, lr}
	ldrb	r4, [r1, #1]	@ zero_extendqisi2
	ldrb	r3, [r0]	@ zero_extendqisi2
	cmp	r4, r3
	bne	.L649
	ldrb	r3, [r1]	@ zero_extendqisi2
	strb	r3, [r0]
.L654:
	movs	r0, #1
	pop	{r4, r5, pc}
.L652:
	mov	r5, r3
	muls	r3, r2, r3
	ldrb	r3, [r0, r3]	@ zero_extendqisi2
	cmp	r4, r3
	bne	.L651
	muls	r2, r5, r2
	ldrb	r3, [r1]	@ zero_extendqisi2
	strb	r3, [r0, r2]
	movs	r3, #255
	strb	r3, [r1]
	b	.L654
.L649:
	ldr	r0, .L655
	movs	r2, #48
.L651:
	cmp	r3, #255
	bne	.L652
	movs	r0, #0
	pop	{r4, r5, pc}
.L656:
	.align	2
.L655:
	.word	.LANCHOR52
	.size	buf_remove_buf, .-buf_remove_buf
	.section	.text.buf_remove_free,"ax",%progbits
	.align	1
	.global	buf_remove_free
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	buf_remove_free, %function
buf_remove_free:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	mov	r5, r0
	ldr	r4, .L662
	ldrb	r3, [r4]	@ zero_extendqisi2
	cbnz	r3, .L658
	movs	r2, #172
	ldr	r1, .L662+4
	ldr	r0, .L662+8
	bl	printf
.L658:
	ldrb	r3, [r4]	@ zero_extendqisi2
	cbz	r3, .L657
	mov	r1, r5
	ldr	r0, .L662+12
	bl	buf_remove_buf
	cmp	r0, #1
	bne	.L657
	ldrb	r3, [r4]	@ zero_extendqisi2
	subs	r3, r3, #1
	strb	r3, [r4]
	ldrb	r3, [r5, #2]	@ zero_extendqisi2
	orr	r3, r3, #1
	strb	r3, [r5, #2]
.L657:
	pop	{r3, r4, r5, pc}
.L663:
	.align	2
.L662:
	.word	.LANCHOR54
	.word	.LANCHOR58
	.word	.LC0
	.word	.LANCHOR53
	.size	buf_remove_free, .-buf_remove_free
	.section	.text.flash_check_bad_block,"ax",%progbits
	.align	1
	.global	flash_check_bad_block
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_check_bad_block, %function
flash_check_bad_block:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r2, .L665
	push	{r4, lr}
	lsrs	r4, r1, #5
	and	r1, r1, #31
	ldrb	r3, [r2, #13]	@ zero_extendqisi2
	ldrh	r2, [r2, #14]
	smulbb	r3, r3, r2
	ldr	r2, .L665+4
	uxth	r3, r3
	ldr	r2, [r2]
	adds	r3, r3, #31
	asrs	r3, r3, #5
	add	r2, r2, r4, lsl #2
	lsls	r3, r3, #2
	uxth	r3, r3
	mla	r0, r0, r3, r2
	ldr	r0, [r0, #912]
	lsrs	r0, r0, r1
	and	r0, r0, #1
	pop	{r4, pc}
.L666:
	.align	2
.L665:
	.word	.LANCHOR32
	.word	.LANCHOR27
	.size	flash_check_bad_block, .-flash_check_bad_block
	.section	.text.flash_mask_bad_block,"ax",%progbits
	.align	1
	.global	flash_mask_bad_block
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_mask_bad_block, %function
flash_mask_bad_block:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L668
	mov	r2, r1
	push	{r4, r5, r6, lr}
	mov	r5, r0
	mov	r6, r1
	mov	r1, r0
	ldrb	r4, [r3, #13]	@ zero_extendqisi2
	ldrh	r3, [r3, #14]
	ldr	r0, .L668+4
	smulbb	r4, r4, r3
	bl	printf
	uxth	r4, r4
	ldr	r3, .L668+8
	add	r0, r4, #31
	asrs	r0, r0, #5
	ldr	r2, [r3]
	movs	r3, #1
	lsls	r0, r0, #2
	uxth	r0, r0
	muls	r0, r5, r0
	lsrs	r5, r6, #5
	and	r6, r6, #31
	lsl	r6, r3, r6
	add	r0, r0, #912
	add	r0, r0, r5, lsl #2
	ldr	r3, [r2, r0]
	orrs	r3, r3, r6
	str	r3, [r2, r0]
	pop	{r4, r5, r6, pc}
.L669:
	.align	2
.L668:
	.word	.LANCHOR32
	.word	.LC42
	.word	.LANCHOR27
	.size	flash_mask_bad_block, .-flash_mask_bad_block
	.section	.text.ftl_gc_write_buf,"ax",%progbits
	.align	1
	.global	ftl_gc_write_buf
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_gc_write_buf, %function
ftl_gc_write_buf:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	mov	r1, r0
	ldrb	r3, [r0, #2]	@ zero_extendqisi2
	orr	r3, r3, #2
	strb	r3, [r0, #2]
	ldr	r0, .L671
	bl	buf_add_tail
	ldr	r3, .L671+4
	ldrb	r0, [r3]	@ zero_extendqisi2
	adds	r0, r0, #1
	uxtb	r0, r0
	strb	r0, [r3]
	pop	{r3, pc}
.L672:
	.align	2
.L671:
	.word	.LANCHOR59
	.word	.LANCHOR60
	.size	ftl_gc_write_buf, .-ftl_gc_write_buf
	.section	.text.zftl_cache_flush,"ax",%progbits
	.align	1
	.global	zftl_cache_flush
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	zftl_cache_flush, %function
zftl_cache_flush:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	bx	lr
	.size	zftl_cache_flush, .-zftl_cache_flush
	.section	.text.zftl_get_density,"ax",%progbits
	.align	1
	.global	zftl_get_density
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	zftl_get_density, %function
zftl_get_density:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	cbnz	r0, .L675
	ldr	r3, .L678
	ldr	r0, [r3]
	bx	lr
.L675:
	cmp	r0, #4
	ite	cc
	movcc	r0, #8192
	movcs	r0, #0
	bx	lr
.L679:
	.align	2
.L678:
	.word	.LANCHOR61
	.size	zftl_get_density, .-zftl_get_density
	.section	.text.gc_hook,"ax",%progbits
	.align	1
	.global	gc_hook
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	gc_hook, %function
gc_hook:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	bx	lr
	.size	gc_hook, .-gc_hook
	.section	.text.vpn_check,"ax",%progbits
	.align	1
	.global	vpn_check
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	vpn_check, %function
vpn_check:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	bx	lr
	.size	vpn_check, .-vpn_check
	.section	.text.FtlGetCurEraseBlock,"ax",%progbits
	.align	1
	.global	FtlGetCurEraseBlock
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlGetCurEraseBlock, %function
FtlGetCurEraseBlock:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L683
	ldrh	r0, [r3]
	bx	lr
.L684:
	.align	2
.L683:
	.word	.LANCHOR62
	.size	FtlGetCurEraseBlock, .-FtlGetCurEraseBlock
	.section	.text.FtlGetAllBlockNum,"ax",%progbits
	.align	1
	.global	FtlGetAllBlockNum
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlGetAllBlockNum, %function
FtlGetAllBlockNum:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L686
	ldrh	r0, [r3]
	bx	lr
.L687:
	.align	2
.L686:
	.word	.LANCHOR6
	.size	FtlGetAllBlockNum, .-FtlGetAllBlockNum
	.section	.text.FtlLowFormat,"ax",%progbits
	.align	1
	.global	FtlLowFormat
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlLowFormat, %function
FtlLowFormat:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	movs	r0, #0
	bx	lr
	.size	FtlLowFormat, .-FtlLowFormat
	.section	.text.gc_add_sblk,"ax",%progbits
	.align	1
	.global	gc_add_sblk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	gc_add_sblk, %function
gc_add_sblk:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r8, r2
	ldr	r3, .L724
	mov	r5, r0
	mov	r4, r1
	ldr	r2, [r3]
	mov	r10, r3
	tst	r2, #256
	beq	.L690
	ldr	r3, .L724+4
	mov	r2, r1
	mov	r1, r0
	ldrh	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L724+8
	ldrh	r3, [r3, #52]
	str	r3, [sp, #8]
	ldr	r3, .L724+12
	ldr	r3, [r3]
	ldrh	r3, [r3, r0, lsl #1]
	str	r3, [sp, #4]
	ldr	r3, .L724+16
	ldr	r3, [r3]
	add	r3, r3, r0, lsl #2
	ldr	r0, .L724+20
	ldrb	r3, [r3, #2]	@ zero_extendqisi2
	lsrs	r3, r3, #5
	str	r3, [sp]
	mov	r3, r8
	bl	printf
.L690:
	ldr	r6, .L724+24
	ldrh	r2, [r6]
	cmp	r2, r5
	bhi	.L691
	mov	r2, #454
	ldr	r1, .L724+28
	ldr	r0, .L724+32
	bl	printf
.L691:
	ldrh	r3, [r6]
	cmp	r3, r5
	bhi	.L692
	ldr	r0, [r10]
	ands	r0, r0, #1024
	beq	.L689
	mov	r3, r8
	mov	r2, r4
	mov	r1, r5
	ldr	r0, .L724+36
	bl	printf
.L712:
	movs	r0, #0
	b	.L689
.L692:
	ldr	r2, .L724+16
	ldr	r3, .L724+12
	ldr	r2, [r2]
	ldr	r3, [r3]
	add	r2, r2, r5, lsl #2
	ldrh	r3, [r3, r5, lsl #1]
	ldrb	r2, [r2, #2]	@ zero_extendqisi2
	ands	r6, r2, #224
	bne	.L694
	cmp	r3, #0
	beq	.L712
	movw	r2, #461
	ldr	r1, .L724+28
	ldr	r0, .L724+32
	bl	printf
	b	.L712
.L694:
	ldr	r6, .L724+8
	ldrh	r1, [r6]
	cmp	r1, r5
	beq	.L712
	ldr	r7, .L724+40
	ldr	r1, [r7]
	ldrh	r0, [r1, #48]
	cmp	r0, r5
	beq	.L712
	ldrh	r0, [r1, #16]
	cmp	r0, r5
	beq	.L712
	ldrh	r0, [r1, #80]
	cmp	r0, r5
	beq	.L712
	ldrh	ip, [r6, #52]!
	movs	r0, #0
.L695:
	cmp	r0, ip
	bcc	.L696
	cmp	r4, #0
	bne	.L700
	ldr	r0, .L724+44
	ldrh	r6, [r0]
	mov	r0, r4
	cmp	r5, r6
	beq	.L689
	ldr	lr, .L724+56
.L699:
	ldrh	fp, [lr, r0, lsl #1]
	cmp	r5, fp
	bne	.L698
	ldr	r0, [r10]
	ands	r0, r0, #256
	beq	.L689
	stm	sp, {r5, r6}
	lsrs	r2, r2, #5
	mov	r1, r5
	ldr	r0, .L724+48
	bl	printf
	b	.L712
.L696:
	ldrh	lr, [r6, #2]!
	cmp	lr, r5
	beq	.L712
	adds	r0, r0, #1
	b	.L695
.L698:
	adds	r0, r0, #1
	cmp	r0, #8
	bne	.L699
	add	r1, r1, r8, lsl #7
	add	r6, r1, #136
.L701:
	ldr	r1, [r10]
	lsls	r1, r1, #23
	bpl	.L702
	ldr	r1, .L724+4
	ldr	r0, .L724+52
	ldrh	r1, [r1]
	stm	sp, {r3, ip}
	lsrs	r3, r2, #5
	mov	r2, r4
	str	r1, [sp, #8]
	mov	r1, r5
	bl	printf
.L702:
	mov	r3, r6
	add	r1, r6, #128
	movw	r0, #65535
.L705:
	mov	r2, r3
	adds	r3, r3, #2
	ldrh	r6, [r2]
	cmp	r6, r0
	bne	.L703
	strh	r5, [r2]	@ movhi
	cbz	r4, .L704
	ldr	r2, [r7]
	ldrh	r3, [r2, #124]
	adds	r3, r3, #1
	strh	r3, [r2, #124]	@ movhi
.L723:
	movs	r0, #1
.L689:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L700:
	add	r6, r1, #392
	b	.L701
.L704:
	ldr	r3, [r7]
	add	r8, r3, r8, lsl #1
	ldrh	r3, [r8, #120]
	adds	r3, r3, #1
	strh	r3, [r8, #120]	@ movhi
	b	.L723
.L703:
	cmp	r3, r1
	bne	.L705
	b	.L723
.L725:
	.align	2
.L724:
	.word	.LANCHOR14
	.word	.LANCHOR63
	.word	.LANCHOR64
	.word	.LANCHOR9
	.word	.LANCHOR7
	.word	.LC43
	.word	.LANCHOR6
	.word	.LANCHOR65
	.word	.LC0
	.word	.LC44
	.word	.LANCHOR10
	.word	.LANCHOR66
	.word	.LC45
	.word	.LC46
	.word	.LANCHOR67
	.size	gc_add_sblk, .-gc_add_sblk
	.section	.text.gc_mark_bad_ppa,"ax",%progbits
	.align	1
	.global	gc_mark_bad_ppa
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	gc_mark_bad_ppa, %function
gc_mark_bad_ppa:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, r8, r10, lr}
	mov	r7, r0
	ldr	r3, .L730
	movs	r6, #1
	ldr	r2, .L730+4
	ldrh	r3, [r3]
	ldr	r8, .L730+16
	lsr	r4, r0, r3
	ldrb	r0, [r2]	@ zero_extendqisi2
	uxth	r5, r4
	rsb	r0, r0, #24
	subs	r0, r0, r3
	ldr	r3, .L730+8
	lsl	r0, r6, r0
	subs	r0, r0, #1
	ldrb	r1, [r3]	@ zero_extendqisi2
	ands	r0, r0, r4
	bl	__aeabi_uidiv
	uxth	r10, r0
	mov	r3, r7
	mov	r2, r5
	ldr	r1, [r8, #580]
	ldr	r0, .L730+12
	bl	printf
	mov	r1, r6
	movs	r2, #0
	mov	r0, r10
	bl	gc_add_sblk
	ldr	r3, [r8, #580]
	movs	r1, #0
.L727:
	uxth	r2, r1
	cmp	r3, r2
	bhi	.L729
	cmp	r3, #5
	itttt	ls
	addls	r2, r3, #1
	addls	r3, r3, #292
	strls	r2, [r8, #580]
	strhls	r5, [r8, r3, lsl #1]	@ movhi
	b	.L728
.L729:
	add	r2, r2, #292
	adds	r1, r1, #1
	ldrh	r2, [r8, r2, lsl #1]
	cmp	r5, r2
	bne	.L727
.L728:
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L731:
	.align	2
.L730:
	.word	.LANCHOR68
	.word	.LANCHOR31
	.word	.LANCHOR69
	.word	.LC47
	.word	.LANCHOR64
	.size	gc_mark_bad_ppa, .-gc_mark_bad_ppa
	.section	.text.gc_get_src_ppa_from_index,"ax",%progbits
	.align	1
	.global	gc_get_src_ppa_from_index
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	gc_get_src_ppa_from_index, %function
gc_get_src_ppa_from_index:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L733
	ldr	r3, [r3]
	ldr	r0, [r3, r0, lsl #2]
	bx	lr
.L734:
	.align	2
.L733:
	.word	.LANCHOR70
	.size	gc_get_src_ppa_from_index, .-gc_get_src_ppa_from_index
	.section	.text.gc_write_completed,"ax",%progbits
	.align	1
	.global	gc_write_completed
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	gc_write_completed, %function
gc_write_completed:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	ldr	r4, .L764
.L736:
	ldr	r1, .L764+4
	ldrb	r7, [r1]	@ zero_extendqisi2
	cmp	r7, #255
	bne	.L749
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L749:
	movs	r3, #48
	muls	r3, r7, r3
	adds	r2, r4, r3
	ldrb	r3, [r4, r3]	@ zero_extendqisi2
	ldrh	r6, [r2, #32]
	strb	r3, [r1]
	ldr	r1, [r2, #36]
	cbz	r1, .L737
	ldr	r3, .L764+8
	movs	r0, #1
	ldr	r2, [r2, #24]
	strh	r0, [r3, #572]	@ movhi
	ldr	r0, .L764+12
	str	r2, [r3, #576]
	bl	printf
	mov	r2, #804
	ldr	r1, .L764+16
	ldr	r0, .L764+20
	bl	printf
.L737:
	ldr	fp, .L764+52
	ldrb	r3, [fp]	@ zero_extendqisi2
	cmp	r3, #3
	bne	.L738
	ldr	r3, .L764+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L738
	ldr	r3, .L764+28
	ldr	r3, [r3]
	ldrb	r5, [r3, #89]	@ zero_extendqisi2
	add	r5, r5, r5, lsl #1
.L739:
	ldr	r3, .L764+32
	ldr	r10, .L764+56
	ldr	r3, [r3]
	tst	r3, #256
	beq	.L740
	ldr	r1, [r10]
	movs	r2, #48
	mla	r2, r2, r7, r4
	ldr	r0, .L764+36
	ldrb	r1, [r1, r6]	@ zero_extendqisi2
	ldrh	r3, [r2, #32]
	ldrb	r2, [r2, #1]	@ zero_extendqisi2
	str	r1, [sp]
	mov	r1, r6
	bl	printf
.L740:
	movs	r3, #48
	ldr	r2, [r10]
	mla	r3, r3, r7, r4
	ldrb	r2, [r2, r6]	@ zero_extendqisi2
	mov	r8, r6
	ldrb	r3, [r3, #1]	@ zero_extendqisi2
	cmp	r2, r3
	beq	.L741
	movw	r2, #813
	ldr	r1, .L764+16
	ldr	r0, .L764+20
	bl	printf
.L741:
	movs	r3, #48
	mla	r7, r3, r7, r4
	ldrb	r3, [r7, #45]	@ zero_extendqisi2
	cmp	r3, #3
	beq	.L742
	ldrb	r3, [fp]	@ zero_extendqisi2
	cmp	r3, #3
	bne	.L742
	ldr	r3, .L764+40
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L742
	ldr	r3, .L764+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L742
	ldr	r3, .L764+44
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L743
	ldr	r3, .L764+48
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L742
.L743:
	ldr	r2, [r10]
	movs	r3, #0
	movs	r1, #48
	mov	r0, r3
	add	r6, r6, r2
.L744:
	uxth	r2, r3
	cmp	r5, r2
	bls	.L736
	ldrb	r2, [r6, r3]	@ zero_extendqisi2
	adds	r3, r3, #1
	mla	r2, r1, r2, r4
	strb	r0, [r2, #45]
	b	.L744
.L738:
	ldr	r3, .L764+44
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L750
	ldr	r3, .L764+48
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	ite	eq
	moveq	r5, #1
	movne	r5, #2
	b	.L739
.L750:
	movs	r5, #1
	b	.L739
.L742:
	ldr	r7, .L764+8
	mov	fp, #255
	movs	r3, #48
	strh	r6, [r7, #568]	@ movhi
.L745:
	sub	r2, r8, r6
	uxth	r2, r2
	cmp	r5, r2
	bls	.L736
	ldr	r2, [r10]
	movs	r1, #0
	str	r3, [sp, #12]
	ldrb	r0, [r2, r8]	@ zero_extendqisi2
	strb	fp, [r2, r8]
	add	r8, r8, #1
	mla	r2, r3, r0, r4
	add	r0, r0, r0, lsl #1
	strb	r1, [r2, #45]
	add	r0, r4, r0, lsl #4
	bl	zbuf_free
	ldrb	r2, [r7, #7]	@ zero_extendqisi2
	ldr	r3, [sp, #12]
	subs	r2, r2, #1
	strb	r2, [r7, #7]
	b	.L745
.L765:
	.align	2
.L764:
	.word	.LANCHOR52
	.word	.LANCHOR71
	.word	.LANCHOR64
	.word	.LC48
	.word	.LANCHOR72
	.word	.LC0
	.word	.LANCHOR35
	.word	.LANCHOR10
	.word	.LANCHOR14
	.word	.LC49
	.word	.LANCHOR77
	.word	.LANCHOR74
	.word	.LANCHOR75
	.word	.LANCHOR73
	.word	.LANCHOR76
	.size	gc_write_completed, .-gc_write_completed
	.section	.text.gc_get_src_blk,"ax",%progbits
	.align	1
	.global	gc_get_src_blk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	gc_get_src_blk, %function
gc_get_src_blk:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L775
	push	{r4, r5, r6, r7, lr}
	ldr	r2, [r3]
	ldr	r3, .L775+4
	ldrh	r4, [r2, #124]
	ldrb	r1, [r3]	@ zero_extendqisi2
	cbz	r4, .L767
	add	r3, r2, #392
	movs	r4, #1
.L768:
	add	r6, r3, #128
	movw	r5, #65535
.L772:
	mov	r7, r3
	ldrh	r0, [r3], #2
	cmp	r0, r5
	beq	.L770
	strh	r5, [r7]	@ movhi
	cbz	r4, .L771
	ldrh	r3, [r2, #124]
	subs	r3, r3, #1
	strh	r3, [r2, #124]	@ movhi
	pop	{r4, r5, r6, r7, pc}
.L767:
	add	r3, r1, #60
	ldrh	r3, [r2, r3, lsl #1]
	cbz	r3, .L773
	add	r3, r2, r1, lsl #7
	adds	r3, r3, #136
	b	.L768
.L771:
	add	r2, r2, r1, lsl #1
	ldrh	r3, [r2, #120]
	subs	r3, r3, #1
	strh	r3, [r2, #120]	@ movhi
	pop	{r4, r5, r6, r7, pc}
.L770:
	cmp	r3, r6
	bne	.L772
	pop	{r4, r5, r6, r7, pc}
.L773:
	movw	r0, #65535
	pop	{r4, r5, r6, r7, pc}
.L776:
	.align	2
.L775:
	.word	.LANCHOR10
	.word	.LANCHOR78
	.size	gc_get_src_blk, .-gc_get_src_blk
	.section	.text.gc_free_temp_buf,"ax",%progbits
	.align	1
	.global	gc_free_temp_buf
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	gc_free_temp_buf, %function
gc_free_temp_buf:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	ldr	r5, .L791
	ldrb	r0, [r5, #7]	@ zero_extendqisi2
	cbz	r0, .L777
	ldr	r3, .L791+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #1
	bhi	.L784
	ldr	r3, .L791+8
	movs	r7, #48
	ldrh	r4, [r5, #568]
	ldr	r6, .L791+12
	ldrh	r2, [r3]
	ldr	r3, .L791+16
	add	r1, r4, #24
	ldr	r0, .L791+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	muls	r2, r3, r2
	cmp	r2, r1
	it	cs
	movcs	r2, r1
	ldr	r1, [r6]
.L779:
	cmp	r4, r2
	bcc	.L782
.L784:
	movs	r0, #0
.L777:
	pop	{r3, r4, r5, r6, r7, pc}
.L782:
	ldrb	r3, [r1, r4]	@ zero_extendqisi2
	cmp	r3, #255
	beq	.L780
	mla	ip, r7, r3, r0
	ldrb	ip, [ip, #45]	@ zero_extendqisi2
	cmp	ip, #0
	bne	.L780
	add	r3, r3, r3, lsl #1
	add	r0, r0, r3, lsl #4
	bl	zbuf_free
	ldr	r3, .L791+24
	ldr	r3, [r3]
	lsls	r3, r3, #23
	bpl	.L781
	ldr	r3, [r6]
	mov	r1, r4
	ldr	r0, .L791+28
	ldrb	r2, [r3, r4]	@ zero_extendqisi2
	bl	printf
.L781:
	ldr	r3, [r6]
	movs	r2, #255
	movs	r0, #1
	strb	r2, [r3, r4]
	ldrb	r3, [r5, #7]	@ zero_extendqisi2
	subs	r3, r3, #1
	strb	r3, [r5, #7]
	pop	{r3, r4, r5, r6, r7, pc}
.L780:
	adds	r4, r4, #1
	b	.L779
.L792:
	.align	2
.L791:
	.word	.LANCHOR64
	.word	.LANCHOR54
	.word	.LANCHOR79
	.word	.LANCHOR76
	.word	.LANCHOR80
	.word	.LANCHOR52
	.word	.LANCHOR14
	.word	.LC50
	.size	gc_free_temp_buf, .-gc_free_temp_buf
	.section	.text.print_gc_debug_info,"ax",%progbits
	.align	1
	.global	print_gc_debug_info
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	print_gc_debug_info, %function
print_gc_debug_info:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, lr}
	ldr	r4, .L794
	ldr	r0, .L794+4
	ldrh	r4, [r4]
	ldrh	r3, [r0, #566]
	ldrh	r2, [r0, #2]
	ldrh	r1, [r0]
	str	r4, [sp, #8]
	ldrb	r0, [r0, #7]	@ zero_extendqisi2
	str	r0, [sp, #4]
	ldr	r0, .L794+8
	ldrb	r0, [r0]	@ zero_extendqisi2
	str	r0, [sp]
	ldr	r0, .L794+12
	bl	printf
	add	sp, sp, #16
	@ sp needed
	pop	{r4, pc}
.L795:
	.align	2
.L794:
	.word	.LANCHOR81
	.word	.LANCHOR64
	.word	.LANCHOR54
	.word	.LC51
	.size	print_gc_debug_info, .-print_gc_debug_info
	.section	.text.zftl_get_gc_node,"ax",%progbits
	.align	1
	.global	zftl_get_gc_node
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	zftl_get_gc_node, %function
zftl_get_gc_node:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	cmp	r1, #5
	bne	.L797
	ldr	r3, .L800
	mov	r1, r0
.L799:
	ldr	r0, [r3]
	b	_list_get_gc_head_node.isra.2
.L797:
	cmp	r1, #2
	bne	.L798
	b	zftl_get_gc_node.part.9
.L798:
	mov	r1, r0
	ldr	r3, .L800+4
	b	.L799
.L801:
	.align	2
.L800:
	.word	.LANCHOR82
	.word	.LANCHOR83
	.size	zftl_get_gc_node, .-zftl_get_gc_node
	.section	.text.gc_search_src_blk,"ax",%progbits
	.align	1
	.global	gc_search_src_blk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	gc_search_src_blk, %function
gc_search_src_blk:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L901
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #32
	str	r2, [sp, #12]
	add	r2, r0, #60
	mov	fp, r0
	ldr	r3, [r3]
	str	r1, [sp, #16]
	ldrh	r5, [r3, r2, lsl #1]
	cbz	r5, .L803
	mov	r0, r5
.L802:
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L803:
	cmp	r0, #0
	bne	.L805
	ldr	r10, .L901+28
	mov	r4, r0
	ldr	r6, .L901+4
	mov	r8, r0
	strh	r0, [r6]	@ movhi
.L806:
	ldrh	r5, [sp, #12]
	uxth	r3, r8
	cmp	r3, r5
	bcs	.L811
	ldrh	r2, [r6]
	movs	r1, #3
	mov	r0, r2
	str	r2, [sp, #20]
	bl	zftl_get_gc_node
	ldr	r2, [sp, #20]
	movw	r3, #65535
	cmp	r0, r3
	mov	r7, r0
	add	r2, r2, #1
	uxth	r2, r2
	strh	r2, [r6]	@ movhi
	beq	.L807
	ldr	r3, .L901+8
	ldr	r3, [r3]
	lsls	r3, r3, #23
	bpl	.L808
	ldr	r3, [r10]
	mov	r1, r0
	ldrh	r3, [r3, r0, lsl #1]
	ldr	r0, .L901+12
	bl	printf
.L808:
	ldr	r3, [r10]
	ldrh	r2, [r3, r7, lsl #1]
	ldr	r3, .L901+16
	ldrh	r3, [r3]
	cmp	r2, r3
	bcs	.L807
	movs	r2, #0
	mov	r0, r7
	mov	r1, r2
	bl	gc_add_sblk
	cmp	r0, #0
	beq	.L810
	adds	r4, r4, #1
	uxth	r4, r4
	cmp	r5, r4
	bcs	.L810
.L811:
	ldr	r3, [sp, #16]
	lsls	r0, r3, #30
	bpl	.L813
	ldr	r6, .L901+20
	mov	r8, #0
	ldr	r7, .L901+24
.L814:
	uxth	r3, r8
	cmp	r5, r3
	bls	.L818
	ldrh	r10, [r7]
	movs	r1, #5
	mov	r0, r10
	add	r10, r10, #1
	bl	zftl_get_gc_node
	movw	r2, #65535
	strh	r10, [r7]	@ movhi
	cmp	r0, r2
	beq	.L815
	ldr	r2, .L901+28
	ldrh	r3, [r6]
	ldr	r2, [r2]
	ldrh	r2, [r2, r0, lsl #1]
	cmp	r2, r3
	bcs	.L815
	movs	r2, #0
	mov	r1, r2
	bl	gc_add_sblk
	cmp	r0, #0
	beq	.L817
	adds	r4, r4, #1
	uxth	r4, r4
	cmp	r5, r4
	bcs	.L817
.L818:
	cmp	r4, r5
	ldr	r1, .L901+32
	bcs	.L820
	ldr	r3, .L901+36
	ldrh	r1, [r1]
	ldrh	r2, [r6]
	ldrh	r0, [r3]
	ldr	r3, .L901+40
	ldrb	r3, [r3]	@ zero_extendqisi2
	muls	r3, r0, r3
	sub	r3, r3, r1, lsr #2
	cmp	r2, r3
	bge	.L813
	add	r2, r2, r1, lsr #3
	strh	r2, [r6]	@ movhi
.L813:
	ldr	r3, [sp, #16]
	lsls	r1, r3, #31
	bpl	.L821
	cmp	r4, r5
	bcs	.L821
	ldr	r8, .L901+48
	movs	r6, #0
	movw	r7, #65535
.L826:
	ldrh	r10, [r8]
	mov	r0, r10
	add	r10, r10, #1
	bl	zftl_get_gc_node.part.9
	cmp	r0, r7
	strh	r10, [r8]	@ movhi
	beq	.L822
	movs	r2, #0
	mov	r1, r2
	bl	gc_add_sblk
	cmp	r0, #0
	beq	.L823
	adds	r4, r4, #1
	uxth	r4, r4
	cmp	r5, r4
	bhi	.L823
.L824:
	ldr	r3, .L901+32
	ldr	r2, .L901+16
	ldrh	r1, [r3]
	ldrh	r3, [r2]
	cmp	r3, r1, lsr #1
	bls	.L821
	sub	r3, r3, r1, lsr #3
	b	.L900
.L807:
	movs	r3, #0
	strh	r3, [r6]	@ movhi
	b	.L811
.L810:
	add	r8, r8, #1
	b	.L806
.L815:
	movs	r3, #0
	strh	r3, [r7]	@ movhi
	b	.L818
.L817:
	add	r8, r8, #1
	b	.L814
.L820:
	ldrh	r3, [r6]
	ldrh	r2, [r1]
	cmp	r3, r2
	itt	hi
	subhi	r3, r3, r2, lsr #3
	strhhi	r3, [r6]	@ movhi
	b	.L813
.L822:
	movs	r3, #0
	strh	r3, [r8]	@ movhi
.L825:
	cmp	r4, r5
	bcs	.L824
	ldr	r2, .L901+16
	ldr	r1, .L901+32
	ldrh	r3, [r2]
	ldrh	r1, [r1]
	cmp	r3, r1
	bcs	.L821
	add	r3, r3, r1, lsr #3
.L900:
	strh	r3, [r2]	@ movhi
.L821:
	ldr	r3, .L901+8
	ldr	r3, [r3]
	lsls	r3, r3, #23
	bpl	.L848
	ldr	r3, [sp, #12]
	mov	r1, fp
	ldr	r2, [sp, #16]
	ldr	r0, .L901+44
	str	r3, [sp]
	mov	r3, r4
	bl	printf
.L848:
	mov	r0, r4
	b	.L802
.L823:
	adds	r6, r6, #1
	uxth	r3, r6
	cmp	r5, r3
	bhi	.L826
	b	.L825
.L902:
	.align	2
.L901:
	.word	.LANCHOR10
	.word	.LANCHOR84
	.word	.LANCHOR14
	.word	.LC52
	.word	.LANCHOR63
	.word	.LANCHOR86
	.word	.LANCHOR85
	.word	.LANCHOR9
	.word	.LANCHOR87
	.word	.LANCHOR79
	.word	.LANCHOR80
	.word	.LC53
	.word	.LANCHOR88
.L805:
	ldr	r3, .L903
	strh	r5, [r3, #570]	@ movhi
	ldr	r3, .L903+4
	strh	r5, [r3]	@ movhi
	ldr	r3, [sp, #16]
	ands	r3, r3, #1
	str	r3, [sp, #20]
	beq	.L851
	ldr	r1, .L903+8
	ldr	r2, .L903+12
	ldr	r6, .L903+16
	ldrh	r3, [r1]
	mov	r10, r1
	ldrh	r0, [r2]
	str	r2, [sp, #24]
	cmp	r3, r0, lsr #2
	bcc	.L828
	ldrh	r2, [r6]
	cmp	r2, r3
	bls	.L852
.L828:
	ldrh	r3, [r6]
	movs	r0, #0
	ldr	r4, .L903+20
	lsrs	r3, r3, #2
	strh	r3, [r4]	@ movhi
	bl	zftl_get_gc_node.part.9
	movw	r2, #65535
	cmp	r0, r2
	beq	.L853
	ldr	r2, .L903+24
	ldr	r1, [r2]
	ldr	r2, .L903+28
	ldrh	r3, [r1, r0, lsl #1]
	movs	r1, #0
	ldrh	r2, [r2]
	cmp	r3, r2, lsr #2
	bcs	.L854
	mov	r2, fp
	strh	r1, [r4]	@ movhi
	bl	gc_add_sblk
	adds	r4, r0, #0
	it	ne
	movne	r4, #1
.L830:
	ldr	r7, .L903+20
	mov	r8, #64
.L832:
	ldrh	r2, [r7]
	mov	r0, r2
	str	r2, [sp, #28]
	bl	zftl_get_gc_node.part.9
	ldr	r2, [sp, #28]
	movw	r3, #65535
	cmp	r0, r3
	add	r2, r2, #1
	strh	r2, [r7]	@ movhi
	beq	.L829
	mov	r2, fp
	movs	r1, #0
	bl	gc_add_sblk
	cbz	r0, .L831
	adds	r4, r4, #1
	ldr	r3, [sp, #12]
	uxth	r4, r4
	cmp	r4, r3
	bcs	.L829
.L831:
	add	r3, r8, #-1
	uxth	r8, r3
	cmp	r8, #0
	bne	.L832
.L829:
	ldr	r3, [sp, #24]
	ldrh	r2, [r10]
	ldrh	r3, [r3]
	cmp	r2, r3, lsr #3
	bhi	.L849
	ldrh	r3, [r6]
	adds	r3, r3, #8
	cmp	r2, r3
	ble	.L827
.L849:
	ldr	r6, .L903+32
	mov	r8, #64
	movw	r7, #65535
	movs	r3, #0
	strh	r3, [r6]	@ movhi
.L834:
	ldrh	r10, [r6]
	movs	r1, #3
	mov	r0, r10
	add	r10, r10, #1
	bl	zftl_get_gc_node
	cmp	r0, r7
	strh	r10, [r6]	@ movhi
	beq	.L827
	mov	r2, fp
	movs	r1, #0
	bl	gc_add_sblk
	cbz	r0, .L833
	adds	r4, r4, #1
	ldr	r3, [sp, #12]
	uxth	r4, r4
	cmp	r4, r3
	bcs	.L827
.L833:
	add	r8, r8, #-1
	uxth	r8, r8
	cmp	r8, #0
	bne	.L834
.L827:
	ldr	r3, [sp, #16]
	lsls	r2, r3, #30
	bpl	.L835
	ldr	r6, .L903+36
	mov	r10, #64
	ldr	r7, .L903+40
	movs	r3, #0
	strh	r3, [r7]	@ movhi
.L840:
	ldrh	r8, [r7]
	movs	r1, #5
	mov	r0, r8
	bl	zftl_get_gc_node
	add	r3, r8, #1
	strh	r3, [r7]	@ movhi
	movw	r3, #65535
	cmp	r0, r3
	beq	.L836
	ldr	r3, [sp, #12]
	cmp	r3, #1
	bne	.L837
	ldr	r3, .L903+44
	ldr	r2, .L903+48
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldrh	r2, [r2]
	smulbb	r3, r3, r2
	ldr	r2, .L903+28
	ldrh	r2, [r2]
	sub	r3, r3, r2, lsr #3
	strh	r3, [r6]	@ movhi
.L837:
	ldr	r3, .L903+24
	ldr	r3, [r3]
	ldrh	r2, [r3, r0, lsl #1]
	ldrh	r3, [r6]
	cmp	r2, r3
	bcs	.L838
	mov	r2, fp
	movs	r1, #0
	bl	gc_add_sblk
	cmp	r0, #0
	beq	.L839
	adds	r4, r4, #1
	ldr	r3, [sp, #12]
	uxth	r4, r4
	adds	r5, r5, #1
	uxth	r5, r5
	cmp	r4, r3
	bcc	.L839
.L836:
	ldr	r3, [sp, #12]
	ldr	r1, .L903+28
	ldr	r0, .L903+44
	cmp	r4, r3
	bcc	.L841
	cmp	r5, #0
	bne	.L842
	ldr	r3, .L903+52
	ldrh	r2, [r3]
	ldr	r3, .L903+56
	ldrh	r3, [r3]
	cmp	r2, r3
	bls	.L842
.L841:
	ldr	r3, .L903+48
	ldrh	r1, [r1]
	ldrh	r2, [r6]
	ldrh	r5, [r3]
	ldrb	r3, [r0]	@ zero_extendqisi2
	lsrs	r1, r1, #3
	muls	r3, r5, r3
	subs	r3, r3, r1
	cmp	r2, r3
	bge	.L835
	add	r2, r2, r1
	strh	r2, [r6]	@ movhi
.L835:
	ldr	r3, [sp, #20]
	cmp	r3, #0
	beq	.L821
	ldr	r5, .L903+60
	mov	r8, #64
	ldr	r7, .L903+24
	movs	r3, #0
	ldr	r6, .L903+32
	strh	r3, [r6]	@ movhi
.L846:
	ldrh	r10, [r6]
	movs	r1, #3
	mov	r0, r10
	add	r10, r10, #1
	bl	zftl_get_gc_node
	movw	r3, #65535
	strh	r10, [r6]	@ movhi
	cmp	r0, r3
	beq	.L843
	ldr	r3, [r7]
	ldrh	r2, [r5]
	ldrh	r3, [r3, r0, lsl #1]
	cmp	r2, r3
	bls	.L844
	cmp	r3, #2
	bls	.L844
	ldr	r3, .L903+12
	ldrh	r2, [r3]
	ldr	r3, .L903+8
	ldrh	r3, [r3]
	cmp	r3, r2, lsr #1
	bls	.L843
.L844:
	mov	r2, fp
	movs	r1, #0
	bl	gc_add_sblk
	cbz	r0, .L845
	adds	r4, r4, #1
	ldr	r3, [sp, #12]
	uxth	r4, r4
	cmp	r4, r3
	bcs	.L843
.L845:
	add	r8, r8, #-1
	uxth	r8, r8
	cmp	r8, #0
	bne	.L846
.L843:
	ldr	r3, [sp, #12]
	cmp	r4, r3
	ldr	r3, .L903+28
	bcs	.L847
	ldrh	r2, [r3]
	ldrh	r3, [r5]
	cmp	r3, r2, lsr #1
	bls	.L821
	sub	r3, r3, r2, lsr #3
	strh	r3, [r5]	@ movhi
	b	.L821
.L853:
	movs	r4, #0
	b	.L830
.L854:
	mov	r4, r1
	b	.L830
.L851:
	ldr	r4, [sp, #20]
	b	.L827
.L838:
	movs	r3, #0
	strh	r3, [r7]	@ movhi
	b	.L836
.L839:
	add	r10, r10, #-1
	uxth	r10, r10
	cmp	r10, #0
	bne	.L840
	b	.L836
.L842:
	ldrh	r1, [r1]
	ldrb	r2, [r0]	@ zero_extendqisi2
	ldrh	r3, [r6]
	muls	r2, r1, r2
	cmp	r3, r2
	itt	gt
	subgt	r3, r3, r1, lsr #3
	strhgt	r3, [r6]	@ movhi
	b	.L835
.L847:
	ldrh	r1, [r3]
	ldr	r3, .L903+44
	ldrh	r2, [r5]
	ldrb	r3, [r3]	@ zero_extendqisi2
	muls	r3, r1, r3
	subs	r3, r3, #32
	cmp	r2, r3
	itt	lt
	addlt	r2, r2, r1, lsr #3
	strhlt	r2, [r5]	@ movhi
	b	.L821
.L852:
	mov	r4, r5
	b	.L829
.L904:
	.align	2
.L903:
	.word	.LANCHOR64
	.word	.LANCHOR89
	.word	.LANCHOR90
	.word	.LANCHOR91
	.word	.LANCHOR92
	.word	.LANCHOR88
	.word	.LANCHOR9
	.word	.LANCHOR87
	.word	.LANCHOR84
	.word	.LANCHOR93
	.word	.LANCHOR85
	.word	.LANCHOR80
	.word	.LANCHOR79
	.word	.LANCHOR94
	.word	.LANCHOR95
	.word	.LANCHOR96
	.size	gc_search_src_blk, .-gc_search_src_blk
	.section	.text.zftl_insert_free_list,"ax",%progbits
	.align	1
	.global	zftl_insert_free_list
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	zftl_insert_free_list, %function
zftl_insert_free_list:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L909
	mov	r1, r0
	ldr	r3, [r3]
	add	r3, r3, r0, lsl #2
	ldrb	r3, [r3, #2]	@ zero_extendqisi2
	ands	r3, r3, #24
	bne	.L906
	ldr	r2, .L909+4
	ldr	r0, .L909+8
.L908:
	b	_insert_free_list
.L906:
	cmp	r3, #16
	ittee	eq
	ldreq	r2, .L909+12
	ldreq	r0, .L909+16
	ldrne	r2, .L909+20
	ldrne	r0, .L909+24
	b	.L908
.L910:
	.align	2
.L909:
	.word	.LANCHOR7
	.word	.LANCHOR97
	.word	.LANCHOR98
	.word	.LANCHOR99
	.word	.LANCHOR100
	.word	.LANCHOR101
	.word	.LANCHOR102
	.size	zftl_insert_free_list, .-zftl_insert_free_list
	.section	.text.zftl_insert_data_list,"ax",%progbits
	.align	1
	.global	zftl_insert_data_list
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	zftl_insert_data_list, %function
zftl_insert_data_list:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L916
	mov	r1, r0
	ldr	r3, [r3]
	add	r3, r3, r0, lsl #2
	ldrb	r3, [r3, #2]	@ zero_extendqisi2
	and	r3, r3, #224
	cmp	r3, #64
	bne	.L912
	ldr	r2, .L916+4
	ldr	r0, .L916+8
.L915:
	b	_insert_data_list
.L912:
	cmp	r3, #96
	bne	.L913
	ldr	r2, .L916+12
	ldr	r0, .L916+16
	b	.L915
.L913:
	cmp	r3, #160
	bne	.L911
	ldr	r2, .L916+20
	ldr	r0, .L916+24
	b	.L915
.L911:
	bx	lr
.L917:
	.align	2
.L916:
	.word	.LANCHOR7
	.word	.LANCHOR92
	.word	.LANCHOR12
	.word	.LANCHOR90
	.word	.LANCHOR83
	.word	.LANCHOR94
	.word	.LANCHOR82
	.size	zftl_insert_data_list, .-zftl_insert_data_list
	.section	.text.zftl_gc_get_free_sblk,"ax",%progbits
	.align	1
	.global	zftl_gc_get_free_sblk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	zftl_gc_get_free_sblk, %function
zftl_gc_get_free_sblk:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, lr}
	movw	r6, #65535
	ldr	r8, .L935+48
	mov	r5, r0
	mov	r7, r1
	ldr	r3, [r8]
	ldrh	r4, [r3, #588]
	cmp	r4, r6
	beq	.L919
	cbnz	r0, .L919
	mov	r1, r4
	ldr	r0, .L935
	bl	printf
	ldr	r3, [r8]
	strh	r6, [r3, #588]	@ movhi
.L920:
	mov	r0, r4
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L919:
	ldr	r3, .L935+4
	ldr	r6, .L935+8
	ldrh	r1, [r3]
	ldrh	r3, [r6]
	cmp	r1, r3
	bls	.L921
	cmp	r5, #0
	beq	.L927
	lsrs	r1, r1, #3
.L922:
	ldr	r2, .L935+4
	ldr	r0, .L935+12
.L934:
	bl	_list_pop_index_node
	uxth	r4, r0
	movw	r3, #65535
	cmp	r4, r3
	bne	.L926
	ldrh	r3, [r6]
	mov	r2, r7
	mov	r1, r4
	ldr	r0, .L935+16
	str	r3, [sp, #4]
	ldr	r3, .L935+20
	ldrh	r3, [r3]
	str	r3, [sp]
	ldr	r3, .L935+24
	ldr	r3, [r3]
	bl	printf
.L926:
	cmp	r5, #0
	beq	.L920
	ldr	r3, .L935+28
	ldr	r3, [r3]
	lsls	r3, r3, #23
	bpl	.L920
	ldr	r3, .L935+32
	ldr	r1, .L935+36
	ldr	r0, .L935+40
	ldr	r3, [r3]
	ldr	r1, [r1]
	ldrh	r1, [r1, r4, lsl #1]
	add	r2, r3, r4, lsl #2
	ldrb	r2, [r2, #2]	@ zero_extendqisi2
	str	r1, [sp, #8]
	ldrh	r1, [r3, r4, lsl #2]
	ubfx	r1, r1, #0, #11
	str	r1, [sp, #4]
	mov	r1, r4
	ldr	r3, [r3, r4, lsl #2]
	ubfx	r3, r3, #11, #8
	str	r3, [sp]
	ubfx	r3, r2, #3, #2
	lsrs	r2, r2, #5
	bl	printf
	b	.L920
.L927:
	mov	r1, r5
	b	.L922
.L921:
	cbnz	r5, .L924
	lsrs	r1, r3, #2
.L925:
	ldr	r2, .L935+8
	ldr	r0, .L935+44
	b	.L934
.L924:
	rsb	r1, r1, r1, lsl #3
	ubfx	r1, r1, #3, #16
	b	.L925
.L936:
	.align	2
.L935:
	.word	.LC54
	.word	.LANCHOR99
	.word	.LANCHOR101
	.word	.LANCHOR100
	.word	.LC55
	.word	.LANCHOR97
	.word	.LANCHOR98
	.word	.LANCHOR14
	.word	.LANCHOR7
	.word	.LANCHOR9
	.word	.LC56
	.word	.LANCHOR102
	.word	.LANCHOR10
	.size	zftl_gc_get_free_sblk, .-zftl_gc_get_free_sblk
	.section	.text.zftl_get_free_sblk,"ax",%progbits
	.align	1
	.global	zftl_get_free_sblk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	zftl_get_free_sblk, %function
zftl_get_free_sblk:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	cmp	r1, #5
	push	{r0, r1, r2, r4, r5, r6, r7, lr}
	mov	r5, r1
	bne	.L938
	ldr	r3, .L959
	ldr	r2, .L959+4
	ldrh	r3, [r3]
	ldrh	r1, [r2]
	cmp	r3, r1
	bcc	.L939
	ldr	r2, .L959+8
	ldrh	r2, [r2]
	cmp	r2, r3
	bls	.L940
	cbz	r1, .L940
.L939:
	ldr	r2, .L959+4
	lsrs	r1, r1, #1
.L958:
	ldr	r0, .L959+12
	b	.L957
.L940:
	ldr	r2, .L959
	movs	r1, #0
	ldr	r0, .L959+16
.L957:
	bl	_list_pop_index_node
	uxth	r4, r0
	movw	r3, #65535
	cmp	r4, r3
	bne	.L943
	ldr	r3, .L959+4
	mov	r2, r5
	mov	r1, r4
	ldr	r0, .L959+20
	ldrh	r3, [r3]
	str	r3, [sp, #4]
	ldr	r3, .L959+8
	ldrh	r3, [r3]
	str	r3, [sp]
	ldr	r3, .L959+24
	ldr	r3, [r3]
	bl	printf
	b	.L943
.L938:
	ldr	r7, .L959+28
	movw	r6, #65535
	ldr	r3, [r7]
	ldrh	r4, [r3, #590]
	cmp	r4, r6
	beq	.L942
	cmp	r1, #1
	beq	.L942
	mov	r1, r4
	ldr	r0, .L959+32
	bl	printf
	ldr	r3, [r7]
	strh	r6, [r3, #590]	@ movhi
.L943:
	mov	r0, r4
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, pc}
.L942:
	ldr	r3, .L959+8
	ldr	r2, .L959+4
	ldrh	r3, [r3]
	ldrh	r2, [r2]
	cmp	r3, r2
	bcc	.L944
	ldr	r1, .L959
	ldrh	r1, [r1]
	cmp	r1, r3
	bls	.L945
	cbz	r2, .L945
.L944:
	cmp	r5, #1
	it	eq
	lsreq	r0, r2, #1
	ldr	r2, .L959+4
	mov	r1, r0
	b	.L958
.L945:
	cmp	r5, #1
	ldr	r2, .L959+8
	it	eq
	lsreq	r0, r3, #1
	mov	r1, r0
	ldr	r0, .L959+24
	b	.L957
.L960:
	.align	2
.L959:
	.word	.LANCHOR99
	.word	.LANCHOR101
	.word	.LANCHOR97
	.word	.LANCHOR102
	.word	.LANCHOR100
	.word	.LC55
	.word	.LANCHOR98
	.word	.LANCHOR10
	.word	.LC57
	.size	zftl_get_free_sblk, .-zftl_get_free_sblk
	.section	.text.zftl_remove_data_node,"ax",%progbits
	.align	1
	.global	zftl_remove_data_node
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	zftl_remove_data_node, %function
zftl_remove_data_node:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L966
	mov	r1, r0
	ldr	r3, [r3]
	add	r3, r3, r0, lsl #2
	ldrb	r3, [r3, #2]	@ zero_extendqisi2
	and	r3, r3, #224
	cmp	r3, #64
	bne	.L962
	ldr	r2, .L966+4
	ldr	r0, .L966+8
.L965:
	b	_list_remove_node
.L962:
	cmp	r3, #96
	bne	.L963
	ldr	r2, .L966+12
	ldr	r0, .L966+16
	b	.L965
.L963:
	cmp	r3, #160
	bne	.L961
	ldr	r2, .L966+20
	ldr	r0, .L966+24
	b	.L965
.L961:
	bx	lr
.L967:
	.align	2
.L966:
	.word	.LANCHOR7
	.word	.LANCHOR92
	.word	.LANCHOR12
	.word	.LANCHOR90
	.word	.LANCHOR83
	.word	.LANCHOR94
	.word	.LANCHOR82
	.size	zftl_remove_data_node, .-zftl_remove_data_node
	.section	.text.zftl_remove_free_node,"ax",%progbits
	.align	1
	.global	zftl_remove_free_node
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	zftl_remove_free_node, %function
zftl_remove_free_node:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L972
	mov	r1, r0
	ldr	r3, [r3]
	add	r3, r3, r0, lsl #2
	ldrb	r3, [r3, #2]	@ zero_extendqisi2
	ands	r3, r3, #24
	bne	.L969
	ldr	r2, .L972+4
	ldr	r0, .L972+8
.L971:
	b	_list_remove_node
.L969:
	cmp	r3, #16
	ittee	eq
	ldreq	r2, .L972+12
	ldreq	r0, .L972+16
	ldrne	r2, .L972+20
	ldrne	r0, .L972+24
	b	.L971
.L973:
	.align	2
.L972:
	.word	.LANCHOR7
	.word	.LANCHOR97
	.word	.LANCHOR98
	.word	.LANCHOR99
	.word	.LANCHOR100
	.word	.LANCHOR101
	.word	.LANCHOR102
	.size	zftl_remove_free_node, .-zftl_remove_free_node
	.section	.text.zftl_list_update_data_list,"ax",%progbits
	.align	1
	.global	zftl_list_update_data_list
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	zftl_list_update_data_list, %function
zftl_list_update_data_list:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L979
	mov	r1, r0
	ldr	r3, [r3]
	add	r3, r3, r0, lsl #2
	ldrb	r3, [r3, #2]	@ zero_extendqisi2
	and	r3, r3, #224
	cmp	r3, #64
	bne	.L975
	ldr	r2, .L979+4
	ldr	r0, .L979+8
.L978:
	b	_list_update_data_list
.L975:
	cmp	r3, #96
	bne	.L976
	ldr	r2, .L979+12
	ldr	r0, .L979+16
	b	.L978
.L976:
	cmp	r3, #160
	bne	.L974
	ldr	r2, .L979+20
	ldr	r0, .L979+24
	b	.L978
.L974:
	bx	lr
.L980:
	.align	2
.L979:
	.word	.LANCHOR7
	.word	.LANCHOR92
	.word	.LANCHOR12
	.word	.LANCHOR90
	.word	.LANCHOR83
	.word	.LANCHOR94
	.word	.LANCHOR82
	.size	zftl_list_update_data_list, .-zftl_list_update_data_list
	.section	.text.print_list_info,"ax",%progbits
	.align	1
	.global	print_list_info
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	print_list_info, %function
print_list_info:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}
	mov	r4, r0
	ldrh	r2, [r1]
	sub	sp, sp, #36
	ldr	r1, [r0]
	ldr	r0, .L985
	bl	printf
	ldr	r4, [r4]
	cmp	r4, #0
	beq	.L981
	ldr	r6, .L985+4
	movs	r5, #0
	ldr	r7, .L985+8
.L984:
	ldr	r2, [r6]
	ldr	r0, .L985+12
	ldr	r3, .L985+16
	subs	r2, r4, r2
	asrs	r2, r2, #1
	ldr	r0, [r0]
	ldr	r1, [r3]
	muls	r2, r7, r2
	ldrh	r3, [r4]
	uxth	r2, r2
	ldrh	r0, [r0, r2, lsl #1]
	add	ip, r1, r2, lsl #2
	str	r0, [sp, #24]
	ldrh	r0, [r1, r2, lsl #2]
	ubfx	r0, r0, #0, #11
	str	r0, [sp, #20]
	ldr	r1, [r1, r2, lsl #2]
	ldr	r0, .L985+20
	ubfx	r1, r1, #11, #8
	str	r1, [sp, #16]
	ldrb	r1, [ip, #2]	@ zero_extendqisi2
	ubfx	r1, r1, #3, #2
	str	r1, [sp, #12]
	ldrb	r1, [ip, #2]	@ zero_extendqisi2
	lsrs	r1, r1, #5
	str	r1, [sp, #8]
	ldrh	r1, [r4, #4]
	str	r1, [sp, #4]
	ldrh	r1, [r4, #2]
	str	r1, [sp]
	mov	r1, r5
	bl	printf
	ldrh	r4, [r4]
	movw	r3, #65535
	cmp	r4, r3
	beq	.L981
	ldr	r3, [r6]
	movs	r2, #6
	adds	r5, r5, #1
	uxth	r5, r5
	mla	r4, r2, r4, r3
	ldr	r3, .L985+24
	ldrh	r3, [r3]
	cmp	r3, r5
	bcs	.L984
.L981:
	add	sp, sp, #36
	@ sp needed
	pop	{r4, r5, r6, r7, pc}
.L986:
	.align	2
.L985:
	.word	.LC58
	.word	.LANCHOR4
	.word	-1431655765
	.word	.LANCHOR9
	.word	.LANCHOR7
	.word	.LC59
	.word	.LANCHOR103
	.size	print_list_info, .-print_list_info
	.section	.text.dump_all_list_info,"ax",%progbits
	.align	1
	.global	dump_all_list_info
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	dump_all_list_info, %function
dump_all_list_info:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	ldr	r1, .L988
	ldr	r0, .L988+4
	bl	print_list_info
	ldr	r1, .L988+8
	ldr	r0, .L988+12
	bl	print_list_info
	ldr	r1, .L988+16
	ldr	r0, .L988+20
	bl	print_list_info
	ldr	r1, .L988+24
	ldr	r0, .L988+28
	bl	print_list_info
	ldr	r1, .L988+32
	ldr	r0, .L988+36
	bl	print_list_info
	ldr	r1, .L988+40
	ldr	r0, .L988+44
	pop	{r3, lr}
	b	print_list_info
.L989:
	.align	2
.L988:
	.word	.LANCHOR97
	.word	.LANCHOR98
	.word	.LANCHOR99
	.word	.LANCHOR100
	.word	.LANCHOR101
	.word	.LANCHOR102
	.word	.LANCHOR92
	.word	.LANCHOR12
	.word	.LANCHOR90
	.word	.LANCHOR83
	.word	.LANCHOR94
	.word	.LANCHOR82
	.size	dump_all_list_info, .-dump_all_list_info
	.section	.text.ftl_tmp_into_update,"ax",%progbits
	.align	1
	.global	ftl_tmp_into_update
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_tmp_into_update, %function
ftl_tmp_into_update:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L995
	ldr	r3, [r3]
	ldr	r2, [r3, #16]
	cmp	r2, #2048
	bls	.L991
	ldr	r1, [r3, #20]
	add	r1, r1, r2, lsr #11
	ubfx	r2, r2, #0, #11
	str	r2, [r3, #16]
	str	r1, [r3, #20]
.L991:
	ldr	r2, [r3, #24]
	cmp	r2, #2048
	bls	.L992
	ldr	r1, [r3, #28]
	add	r1, r1, r2, lsr #11
	ubfx	r2, r2, #0, #11
	str	r2, [r3, #24]
	str	r1, [r3, #28]
.L992:
	ldr	r2, [r3, #32]
	cmp	r2, #1024
	bls	.L993
	ldr	r1, [r3, #36]
	add	r1, r1, r2, lsr #10
	ubfx	r2, r2, #0, #10
	str	r2, [r3, #32]
	str	r1, [r3, #36]
.L993:
	ldr	r2, [r3, #40]
	cmp	r2, #1024
	bls	.L990
	ldr	r1, [r3, #44]
	add	r1, r1, r2, lsr #10
	ubfx	r2, r2, #0, #10
	str	r2, [r3, #40]
	str	r1, [r3, #44]
.L990:
	bx	lr
.L996:
	.align	2
.L995:
	.word	.LANCHOR104
	.size	ftl_tmp_into_update, .-ftl_tmp_into_update
	.global	__aeabi_idiv
	.section	.text.ftl_get_blk_list_in_sblk,"ax",%progbits
	.align	1
	.global	ftl_get_blk_list_in_sblk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_get_blk_list_in_sblk, %function
ftl_get_blk_list_in_sblk:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r4, #0
	ldr	r3, .L1006
	mov	r8, r1
	mov	r5, r4
	ldr	r2, .L1006+4
	ldr	r3, [r3]
	ldrb	r10, [r2]	@ zero_extendqisi2
	ldr	r2, .L1006+8
	add	r3, r3, r0, lsl #2
	ldrb	r3, [r3, #3]	@ zero_extendqisi2
	uxth	r7, r10
	ldrb	fp, [r2]	@ zero_extendqisi2
	smulbb	r0, r0, r7
	ldr	r2, .L1006+12
	str	r3, [sp, #4]
	subs	r7, r7, #1
	ldr	r3, .L1006+16
	sxth	r7, r7
	uxth	r6, r0
	rsb	fp, fp, #24
	ldrb	r3, [r3]	@ zero_extendqisi2
.L998:
	cmp	r5, r3
	blt	.L1002
	mov	r2, r4
	movw	r1, #65535
.L1003:
	cmp	r2, r3
	blt	.L1004
	mov	r0, r4
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1002:
	ldr	r1, [sp, #4]
	asrs	r1, r1, r5
	lsls	r1, r1, #31
	bmi	.L999
	mov	r1, r10
	mov	r0, r5
	str	r2, [sp, #12]
	str	r3, [sp, #8]
	bl	__aeabi_idiv
	ldr	r2, [sp, #12]
	cmp	r10, #1
	ldr	r3, [sp, #8]
	ldrh	r1, [r2]
	sub	r1, fp, r1
	lsl	r0, r0, r1
	it	hi
	andhi	r1, r7, r5
	add	r0, r0, r6
	uxth	r0, r0
	it	hi
	addhi	r0, r0, r1
	strh	r0, [r8, r4, lsl #1]	@ movhi
	adds	r4, r4, #1
.L999:
	adds	r5, r5, #1
	b	.L998
.L1004:
	strh	r1, [r8, r2, lsl #1]	@ movhi
	adds	r2, r2, #1
	b	.L1003
.L1007:
	.align	2
.L1006:
	.word	.LANCHOR7
	.word	.LANCHOR69
	.word	.LANCHOR31
	.word	.LANCHOR68
	.word	.LANCHOR80
	.size	ftl_get_blk_list_in_sblk, .-ftl_get_blk_list_in_sblk
	.section	.text.ftl_erase_phy_blk,"ax",%progbits
	.align	1
	.global	ftl_erase_phy_blk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_erase_phy_blk, %function
ftl_erase_phy_blk:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	mov	r5, r1
	ldr	r3, .L1013
	ldr	r7, .L1013+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	rsb	r4, r3, #24
	ldr	r3, .L1013+8
	ldrh	r3, [r3]
	subs	r3, r4, r3
	movs	r4, #1
	asr	r6, r0, r3
	lsls	r4, r4, r3
	ldr	r3, .L1013+12
	subs	r4, r4, #1
	uxtb	r6, r6
	ands	r4, r4, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	sxth	r4, r4
	cbz	r3, .L1009
	ldr	r3, .L1013+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L1009
	ldrh	r2, [r7]
	clz	r1, r1
	lsrs	r1, r1, #5
	mov	r0, r6
	muls	r2, r4, r2
	bl	flash_erase_block_en
.L1009:
	ldrh	r2, [r7]
	uxtb	r1, r5
	mov	r0, r6
	muls	r2, r4, r2
	pop	{r3, r4, r5, r6, r7, lr}
	b	flash_erase_block_en
.L1014:
	.align	2
.L1013:
	.word	.LANCHOR31
	.word	.LANCHOR105
	.word	.LANCHOR68
	.word	.LANCHOR74
	.word	.LANCHOR75
	.size	ftl_erase_phy_blk, .-ftl_erase_phy_blk
	.section	.text.ftl_erase_sblk,"ax",%progbits
	.align	1
	.global	ftl_erase_sblk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_erase_sblk, %function
ftl_erase_sblk:
	@ args = 0, pretend = 0, frame = 72
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r2, .L1039
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r6, r0
	mov	r7, r1
	movs	r5, #0
	mov	r8, r2
	sub	sp, sp, #72
	ldr	r3, [r2]
	add	r3, r3, r0, lsl #2
	ldrb	r3, [r3, #3]	@ zero_extendqisi2
	str	r3, [sp, #4]
.L1016:
	ldr	r3, .L1039+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r5, r3
	bge	.L1027
	ldr	r3, .L1039+8
	movs	r4, #0
	ldrb	r2, [r3]	@ zero_extendqisi2
	ldr	r3, .L1039+12
	add	ip, r2, #-1
	ldrh	r0, [r3]
	mul	r10, r2, r5
	mov	r3, r4
	mul	lr, r2, r6
	b	.L1028
.L1018:
	ldr	r1, [sp, #4]
	add	fp, r3, r10
	asr	r1, r1, fp
	lsls	r1, r1, #31
	bmi	.L1017
	add	r1, sp, #72
	add	fp, r1, r4, lsl #2
	and	r1, r3, ip
	add	r1, r1, lr
	muls	r1, r0, r1
	adds	r4, r4, #1
	str	r1, [fp, #-64]
.L1017:
	adds	r3, r3, #1
.L1028:
	cmp	r3, r2
	blt	.L1018
	cmp	r2, #4
	bne	.L1019
	uxtb	fp, r7
	mov	r10, #0
.L1020:
	cmp	r10, r4
	bne	.L1021
.L1022:
	adds	r5, r5, #1
	b	.L1016
.L1021:
	add	r3, sp, #8
	mov	r1, fp
	ldr	r2, [r3, r10, lsl #2]
	uxtb	r0, r5
	add	r10, r10, #1
	bl	flash_erase_block_en
	b	.L1020
.L1019:
	cmp	r4, #2
	bne	.L1023
	ldr	r3, .L1039+16
	uxtb	r4, r5
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1024
	ldr	r3, .L1039+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L1024
	clz	r1, r7
	ldr	r3, [sp, #12]
	ldr	r2, [sp, #8]
	lsrs	r1, r1, #5
	mov	r0, r4
	bl	flash_erase_duplane_block
.L1024:
	ldr	r3, [sp, #12]
	uxtb	r1, r7
	ldr	r2, [sp, #8]
	mov	r0, r4
	bl	flash_erase_duplane_block
	b	.L1022
.L1023:
	cmp	r4, #1
	bne	.L1022
	ldr	r3, .L1039+16
	uxtb	r4, r5
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1026
	ldr	r3, .L1039+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L1026
	clz	r1, r7
	ldr	r2, [sp, #8]
	lsrs	r1, r1, #5
	mov	r0, r4
	bl	flash_erase_block_en
.L1026:
	ldr	r2, [sp, #8]
	uxtb	r1, r7
	mov	r0, r4
	bl	flash_erase_block_en
	b	.L1022
.L1027:
	ldr	r1, .L1039+24
	ldr	r0, [r8]
	cbnz	r7, .L1029
	ldrh	r2, [r0, r6, lsl #2]
	adds	r3, r2, #1
	ubfx	r3, r3, #0, #11
	bfi	r2, r3, #0, #11
	strh	r2, [r0, r6, lsl #2]	@ movhi
	ldr	r2, [r1]
	ldr	r1, [r2, #84]
	adds	r1, r1, #1
	str	r1, [r2, #84]
	ldrh	r1, [r2, #96]
	cmp	r1, r3
	bge	.L1031
	strh	r3, [r2, #96]	@ movhi
.L1031:
	movs	r0, #0
	add	sp, sp, #72
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1029:
	ldr	r2, [r0, r6, lsl #2]
	ubfx	r3, r2, #11, #8
	adds	r3, r3, #1
	uxtb	r3, r3
	bfi	r2, r3, #11, #8
	uxth	r3, r3
	str	r2, [r0, r6, lsl #2]
	ldr	r2, [r1]
	ldr	r1, [r2, #80]
	adds	r1, r1, #1
	str	r1, [r2, #80]
	ldrh	r1, [r2, #98]
	cmp	r1, r3
	it	cc
	strhcc	r3, [r2, #98]	@ movhi
	b	.L1031
.L1040:
	.align	2
.L1039:
	.word	.LANCHOR7
	.word	.LANCHOR106
	.word	.LANCHOR69
	.word	.LANCHOR105
	.word	.LANCHOR74
	.word	.LANCHOR75
	.word	.LANCHOR104
	.size	ftl_erase_sblk, .-ftl_erase_sblk
	.section	.text.ftl_alloc_sys_blk,"ax",%progbits
	.align	1
	.global	ftl_alloc_sys_blk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_alloc_sys_blk, %function
ftl_alloc_sys_blk:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	ldr	r4, .L1050
	ldr	r2, [r4]
	ldrh	r1, [r2, #136]
	cmp	r1, #63
	itt	hi
	movhi	r3, #0
	strhhi	r3, [r2, #136]	@ movhi
	ldrh	r3, [r2, #112]
	cbnz	r3, .L1043
	movw	r2, #1140
	ldr	r1, .L1050+4
	ldr	r0, .L1050+8
	bl	printf
.L1043:
	ldr	r3, [r4]
	movw	r4, #65535
	mov	r6, r4
	movs	r5, #0
.L1047:
	ldrh	r2, [r3, #136]
	add	r1, r3, r2, lsl #1
	adds	r1, r1, #158
.L1044:
	cmp	r2, #63
	ble	.L1046
	strh	r5, [r3, #136]	@ movhi
	b	.L1047
.L1046:
	ldrh	r0, [r1, #2]!
	cmp	r0, r4
	bne	.L1049
	adds	r2, r2, #1
	b	.L1044
.L1049:
	add	r1, r2, #80
	strh	r6, [r3, r1, lsl #1]	@ movhi
	strh	r2, [r3, #136]	@ movhi
	ldrh	r2, [r3, #112]
	subs	r2, r2, #1
	strh	r2, [r3, #112]	@ movhi
	pop	{r4, r5, r6, pc}
.L1051:
	.align	2
.L1050:
	.word	.LANCHOR104
	.word	.LANCHOR107
	.word	.LC0
	.size	ftl_alloc_sys_blk, .-ftl_alloc_sys_blk
	.section	.text.ftl_free_sys_blk,"ax",%progbits
	.align	1
	.global	ftl_free_sys_blk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_free_sys_blk, %function
ftl_free_sys_blk:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	mov	r5, r0
	ldr	r4, .L1060
	ldr	r2, [r4]
	ldrh	r1, [r2, #138]
	cmp	r1, #63
	itt	hi
	movhi	r3, #0
	strhhi	r3, [r2, #138]	@ movhi
	ldrh	r3, [r2, #112]
	cmp	r3, #63
	bls	.L1054
	movw	r2, #1164
	ldr	r1, .L1060+4
	ldr	r0, .L1060+8
	bl	printf
.L1054:
	ldr	r3, [r4]
	movs	r0, #0
	movw	r4, #65535
.L1058:
	ldrh	r2, [r3, #138]
	add	r1, r3, r2, lsl #1
	adds	r1, r1, #158
.L1055:
	cmp	r2, #63
	ble	.L1057
	strh	r0, [r3, #138]	@ movhi
	b	.L1058
.L1057:
	ldrh	r6, [r1, #2]!
	cmp	r6, r4
	bne	.L1056
	add	r1, r2, #80
	strh	r5, [r3, r1, lsl #1]	@ movhi
	strh	r2, [r3, #138]	@ movhi
	ldrh	r2, [r3, #112]
	adds	r2, r2, #1
	strh	r2, [r3, #112]	@ movhi
	pop	{r4, r5, r6, pc}
.L1056:
	adds	r2, r2, #1
	b	.L1055
.L1061:
	.align	2
.L1060:
	.word	.LANCHOR104
	.word	.LANCHOR108
	.word	.LC0
	.size	ftl_free_sys_blk, .-ftl_free_sys_blk
	.section	.text.ftl_info_data_recovery,"ax",%progbits
	.align	1
	.global	ftl_info_data_recovery
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_info_data_recovery, %function
ftl_info_data_recovery:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	movw	r3, #65535
	ldrh	r4, [r0]
	cmp	r4, r3
	beq	.L1062
	ldr	r3, .L1071
	ldr	r5, [r3]
	add	r6, r5, r4, lsl #2
	ldrb	r3, [r6, #2]	@ zero_extendqisi2
	tst	r3, #224
	bne	.L1062
	ldrb	r2, [r0, #4]	@ zero_extendqisi2
	mov	r0, r4
	bfi	r3, r2, #5, #3
	strb	r3, [r6, #2]
	bl	zftl_remove_free_node
	ldrb	r3, [r6, #2]	@ zero_extendqisi2
	ldr	r2, .L1071+4
	tst	r3, #8
	ldr	r0, [r2]
	beq	.L1066
	ldrh	r1, [r0, #116]
	subs	r1, r1, #1
	strh	r1, [r0, #116]	@ movhi
.L1067:
	and	r3, r3, #224
	cmp	r3, #160
	bne	.L1069
	ldr	r3, [r5, r4, lsl #2]
	ldr	r2, [r2]
	ubfx	r1, r3, #11, #8
	adds	r1, r1, #1
	bfi	r3, r1, #11, #8
	str	r3, [r5, r4, lsl #2]
	ldrh	r3, [r2, #120]
	subs	r3, r3, #1
	strh	r3, [r2, #120]	@ movhi
	pop	{r4, r5, r6, pc}
.L1066:
	tst	r3, #24
	itete	eq
	ldrheq	r1, [r0, #114]
	ldrhne	r1, [r0, #118]
	addeq	r1, r1, #-1
	addne	r1, r1, #-1
	ite	eq
	strheq	r1, [r0, #114]	@ movhi
	strhne	r1, [r0, #118]	@ movhi
	b	.L1067
.L1069:
	ldrh	r1, [r5, r4, lsl #2]
	cmp	r3, #64
	add	r0, r1, #1
	bfi	r1, r0, #0, #11
	strh	r1, [r5, r4, lsl #2]	@ movhi
	bne	.L1070
	ldr	r2, [r2]
	ldrh	r3, [r2, #122]
	subs	r3, r3, #1
	strh	r3, [r2, #122]	@ movhi
	pop	{r4, r5, r6, pc}
.L1070:
	cmp	r3, #96
	itttt	eq
	ldreq	r2, [r2]
	ldrheq	r3, [r2, #124]
	addeq	r3, r3, #-1
	strheq	r3, [r2, #124]	@ movhi
.L1062:
	pop	{r4, r5, r6, pc}
.L1072:
	.align	2
.L1071:
	.word	.LANCHOR7
	.word	.LANCHOR104
	.size	ftl_info_data_recovery, .-ftl_info_data_recovery
	.section	.text.ftl_get_ppa_from_index,"ax",%progbits
	.align	1
	.global	ftl_get_ppa_from_index
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_get_ppa_from_index, %function
ftl_get_ppa_from_index:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	mov	r4, r0
	ldr	r3, .L1077
	ldr	r5, [r3]
	ldr	r3, .L1077+4
	ldrh	r2, [r3]
	ldr	r3, .L1077+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	mul	r1, r3, r2
	cmp	r0, r1
	itet	ge
	smulbbge	r3, r3, r2
	addlt	r5, r5, #16
	addge	r5, r5, #48
	ldrb	r6, [r5, #9]	@ zero_extendqisi2
	itt	ge
	subge	r4, r0, r3
	uxthge	r4, r4
	mov	r1, r6
	mov	r0, r4
	bl	__aeabi_idiv
	smulbb	r6, r0, r6
	movw	r3, #65535
	mov	r7, r0
	subs	r4, r4, r6
	uxth	r4, r4
	adds	r4, r4, #8
	ldrh	r4, [r5, r4, lsl #1]
	cmp	r4, r3
	bne	.L1076
	movw	r2, #1686
	ldr	r1, .L1077+12
	ldr	r0, .L1077+16
	bl	printf
.L1076:
	ldr	r3, .L1077+20
	ldrh	r0, [r3]
	mla	r0, r4, r0, r7
	pop	{r3, r4, r5, r6, r7, pc}
.L1078:
	.align	2
.L1077:
	.word	.LANCHOR10
	.word	.LANCHOR87
	.word	.LANCHOR80
	.word	.LANCHOR109
	.word	.LC0
	.word	.LANCHOR105
	.size	ftl_get_ppa_from_index, .-ftl_get_ppa_from_index
	.section	.text.lpa_hash_get_ppa,"ax",%progbits
	.align	1
	.global	lpa_hash_get_ppa
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	lpa_hash_get_ppa, %function
lpa_hash_get_ppa:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L1083
	uxtb	r2, r0
	push	{r4, r5}
	ldrh	r3, [r3, r2, lsl #1]
	ldr	r2, .L1083+4
	ldr	r1, [r2]
	ldr	r2, .L1083+8
	ldr	r4, [r2]
	movw	r2, #65535
.L1080:
	cmp	r3, r2
	bne	.L1082
	mov	r0, #-1
	pop	{r4, r5}
	bx	lr
.L1082:
	ldr	r5, [r1, r3, lsl #2]
	cmp	r0, r5
	bne	.L1081
	mov	r0, r3
	pop	{r4, r5}
	b	ftl_get_ppa_from_index
.L1081:
	ldrh	r3, [r4, r3, lsl #1]
	b	.L1080
.L1084:
	.align	2
.L1083:
	.word	.LANCHOR110
	.word	.LANCHOR111
	.word	.LANCHOR112
	.size	lpa_hash_get_ppa, .-lpa_hash_get_ppa
	.section	.text.ftl_get_new_free_page,"ax",%progbits
	.align	1
	.global	ftl_get_new_free_page
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_get_new_free_page, %function
ftl_get_new_free_page:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldrh	r2, [r0]
	push	{r3, r4, r5, lr}
	movw	r3, #65535
	mov	r4, r0
	cmp	r2, r3
	bne	.L1086
	movw	r2, #1809
	ldr	r1, .L1093
	ldr	r0, .L1093+4
	bl	printf
.L1086:
	ldr	r3, .L1093+8
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3]
	cmp	r2, r3
	bne	.L1087
	movw	r2, #1810
	ldr	r1, .L1093
	ldr	r0, .L1093+4
	bl	printf
.L1087:
	ldrh	r3, [r4, #6]
	cbnz	r3, .L1088
	movw	r2, #1811
	ldr	r1, .L1093
	ldr	r0, .L1093+4
	bl	printf
.L1088:
	ldrb	r3, [r4, #5]	@ zero_extendqisi2
	movw	r2, #65535
	movs	r1, #0
	adds	r3, r3, #8
	ldrh	r0, [r4, r3, lsl #1]
	ldr	r3, .L1093+12
	ldrb	r5, [r3]	@ zero_extendqisi2
.L1089:
	cmp	r0, r2
	ldrb	r3, [r4, #5]	@ zero_extendqisi2
	beq	.L1091
	ldr	r1, .L1093+16
	adds	r3, r3, #1
	uxtb	r3, r3
	ldrh	r2, [r4, #2]
	ldrh	r1, [r1]
	cmp	r5, r3
	strb	r3, [r4, #5]
	itttt	eq
	addeq	r3, r2, #1
	strheq	r3, [r4, #2]	@ movhi
	moveq	r3, #0
	strbeq	r3, [r4, #5]
	muls	r0, r1, r0
	ldrh	r1, [r4, #6]
	subs	r1, r1, #1
	strh	r1, [r4, #6]	@ movhi
	orrs	r0, r0, r2
	ldrh	r1, [r4, #10]
	adds	r1, r1, #1
	strh	r1, [r4, #10]	@ movhi
	pop	{r3, r4, r5, pc}
.L1091:
	adds	r3, r3, #1
	uxtb	r3, r3
	cmp	r3, r5
	strb	r3, [r4, #5]
	itttt	eq
	ldrheq	r3, [r4, #2]
	strbeq	r1, [r4, #5]
	addeq	r3, r3, #1
	strheq	r3, [r4, #2]	@ movhi
	ldrb	r3, [r4, #5]	@ zero_extendqisi2
	adds	r3, r3, #8
	ldrh	r0, [r4, r3, lsl #1]
	b	.L1089
.L1094:
	.align	2
.L1093:
	.word	.LANCHOR113
	.word	.LC0
	.word	.LANCHOR87
	.word	.LANCHOR80
	.word	.LANCHOR105
	.size	ftl_get_new_free_page, .-ftl_get_new_free_page
	.section	.text.ftl_ext_alloc_new_blk,"ax",%progbits
	.align	1
	.global	ftl_ext_alloc_new_blk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_ext_alloc_new_blk, %function
ftl_ext_alloc_new_blk:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	bl	ftl_alloc_sys_blk
	subs	r3, r0, #1
	movw	r2, #65533
	uxth	r3, r3
	mov	r4, r0
	cmp	r3, r2
	bls	.L1096
	movw	r2, #1842
	ldr	r1, .L1097
	ldr	r0, .L1097+4
	bl	printf
.L1096:
	ldr	r5, .L1097+8
	movs	r1, #0
	mov	r0, r4
	bl	ftl_erase_phy_blk
	ldr	r3, [r5]
	ldrh	r0, [r3, #130]
	bl	ftl_free_sys_blk
	ldr	r3, [r5]
	movs	r0, #0
	strh	r4, [r3, #130]	@ movhi
	strh	r0, [r3, #140]	@ movhi
	pop	{r3, r4, r5, pc}
.L1098:
	.align	2
.L1097:
	.word	.LANCHOR114
	.word	.LC0
	.word	.LANCHOR104
	.size	ftl_ext_alloc_new_blk, .-ftl_ext_alloc_new_blk
	.section	.text.ftl_total_vpn_update,"ax",%progbits
	.align	1
	.global	ftl_total_vpn_update
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_total_vpn_update, %function
ftl_total_vpn_update:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r2, .L1110
	push	{r3, r4, r5, r6, r7, lr}
	mov	r1, r2
	ldrh	r3, [r2]
	cmp	r3, #4
	bhi	.L1100
	cbnz	r0, .L1100
	adds	r3, r3, #1
	strh	r3, [r2]	@ movhi
	pop	{r3, r4, r5, r6, r7, pc}
.L1100:
	ldr	r2, .L1110+4
	movs	r3, #0
	mov	r0, r3
	movw	ip, #65535
	strh	r3, [r1]	@ movhi
	ldrh	r5, [r2]
	ldr	r2, .L1110+8
	ldr	r6, [r2]
	ldr	r2, .L1110+12
	ldr	r7, [r2]
	mov	r2, r3
.L1102:
	uxth	r1, r3
	cmp	r5, r1
	bhi	.L1105
	ldr	r3, .L1110+16
	ldr	r4, [r3]
	ldr	r3, .L1110+20
	str	r2, [r4, #524]
	ldr	r3, [r3]
	str	r0, [r4, #528]
	ldrh	r1, [r3, #120]
	cbz	r1, .L1099
	bl	__aeabi_uidiv
	str	r0, [r4, #532]
.L1099:
	pop	{r3, r4, r5, r6, r7, pc}
.L1105:
	ldrh	r1, [r6, r3, lsl #1]
	cmp	r1, ip
	beq	.L1103
	add	r4, r7, r3, lsl #2
	ldrb	r4, [r4, #2]	@ zero_extendqisi2
	and	r4, r4, #224
	cmp	r4, #160
	ite	eq
	addeq	r0, r0, r1
	addne	r2, r2, r1
.L1103:
	adds	r3, r3, #1
	b	.L1102
.L1111:
	.align	2
.L1110:
	.word	.LANCHOR115
	.word	.LANCHOR6
	.word	.LANCHOR9
	.word	.LANCHOR7
	.word	.LANCHOR10
	.word	.LANCHOR104
	.size	ftl_total_vpn_update, .-ftl_total_vpn_update
	.section	.text.ftl_debug_info_fill,"ax",%progbits
	.align	1
	.global	ftl_debug_info_fill
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_debug_info_fill, %function
ftl_debug_info_fill:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	movs	r0, #0
	bx	lr
	.size	ftl_debug_info_fill, .-ftl_debug_info_fill
	.section	.text.ftl_vpn_update,"ax",%progbits
	.align	1
	.global	ftl_vpn_update
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_vpn_update, %function
ftl_vpn_update:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	mov	r4, r0
	bl	zftl_list_update_data_list
	ldr	r3, .L1116
	ldr	r3, [r3]
	ldrh	r3, [r3, r4, lsl #1]
	cbnz	r3, .L1115
	ldr	r3, .L1116+4
	movs	r0, #1
	str	r0, [r3]
	pop	{r4, pc}
.L1115:
	movs	r0, #0
	pop	{r4, pc}
.L1117:
	.align	2
.L1116:
	.word	.LANCHOR9
	.word	.LANCHOR116
	.size	ftl_vpn_update, .-ftl_vpn_update
	.section	.text.ftl_vpn_decrement,"ax",%progbits
	.align	1
	.global	ftl_vpn_decrement
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_vpn_decrement, %function
ftl_vpn_decrement:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	movw	r3, #65535
	cmp	r0, r3
	mov	r5, r0
	beq	.L1119
	ldr	r3, .L1127
	ldr	r3, [r3]
	ldrh	r4, [r3, r0, lsl #1]
	cbnz	r4, .L1120
	ldr	r3, .L1127+4
	mov	r1, r0
	mov	r2, r4
	ldr	r3, [r3]
	add	r3, r3, r0, lsl #2
	ldr	r0, .L1127+8
	ldrb	r3, [r3, #2]	@ zero_extendqisi2
	lsrs	r3, r3, #5
	bl	printf
.L1125:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L1120:
	subs	r4, r4, #1
	strh	r4, [r3, r0, lsl #1]	@ movhi
.L1119:
	ldr	r3, .L1127+12
	ldrh	r0, [r3]
	mov	r4, r3
	cmp	r5, r0
	beq	.L1125
	movw	r2, #65535
	cmp	r0, r2
	bne	.L1122
	strh	r5, [r3]	@ movhi
	b	.L1125
.L1122:
	bl	ftl_vpn_update
	ldr	r3, .L1127+16
	adds	r0, r0, #0
	it	ne
	movne	r0, #1
	ldrh	r1, [r4]
	strh	r5, [r4]	@ movhi
	ldrh	r2, [r3]
	adds	r2, r2, #1
	uxth	r2, r2
	cmp	r2, #7
	it	hi
	movhi	r2, #0
	strh	r2, [r3]	@ movhi
	ldrh	r2, [r3]
	ldr	r3, .L1127+20
	strh	r1, [r3, r2, lsl #1]	@ movhi
	pop	{r3, r4, r5, pc}
.L1128:
	.align	2
.L1127:
	.word	.LANCHOR9
	.word	.LANCHOR7
	.word	.LC60
	.word	.LANCHOR66
	.word	.LANCHOR117
	.word	.LANCHOR67
	.size	ftl_vpn_decrement, .-ftl_vpn_decrement
	.section	.text.lpa_hash_update_ppa,"ax",%progbits
	.align	1
	.global	lpa_hash_update_ppa
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	lpa_hash_update_ppa, %function
lpa_hash_update_ppa:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	uxtb	ip, r0
	ldr	r4, .L1140
	movw	r6, #65535
	mov	fp, r6
	ldr	r5, .L1140+4
	ldr	lr, [r4]
	ldr	r4, .L1140+8
	ldrh	r3, [r5, ip, lsl #1]
	ldr	r4, [r4]
.L1130:
	cmp	r3, fp
	beq	.L1134
	ldr	r7, [lr, r3, lsl #2]
	add	r8, lr, r3, lsl #2
	cmp	r0, r7
	bne	.L1131
	cmp	r6, fp
	mov	r10, #-1
	ite	eq
	ldrheq	r6, [r4, r3, lsl #1]
	ldrhne	r7, [r4, r3, lsl #1]
	str	r10, [r8]
	ite	eq
	strheq	r6, [r5, ip, lsl #1]	@ movhi
	strhne	r7, [r4, r6, lsl #1]	@ movhi
	movw	r6, #65535
	strh	r6, [r4, r3, lsl #1]	@ movhi
.L1134:
	ldrh	r3, [r5, ip, lsl #1]
	str	r0, [lr, r2, lsl #2]
	strh	r2, [r5, ip, lsl #1]	@ movhi
	strh	r3, [r4, r2, lsl #1]	@ movhi
	adds	r3, r1, #1
	beq	.L1136
	ldr	r3, .L1140+12
	ldrh	r2, [r3]
	ldr	r3, .L1140+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	rsb	r3, r3, #24
	subs	r0, r3, r2
	movs	r3, #1
	lsls	r3, r3, r0
	lsr	r0, r1, r2
	ldr	r2, .L1140+20
	subs	r3, r3, #1
	ands	r0, r0, r3
	ldrb	r1, [r2]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	uxth	r0, r0
	bl	ftl_vpn_decrement
.L1136:
	mov	r0, #-1
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1131:
	mov	r6, r3
	ldrh	r3, [r4, r3, lsl #1]
	b	.L1130
.L1141:
	.align	2
.L1140:
	.word	.LANCHOR111
	.word	.LANCHOR110
	.word	.LANCHOR112
	.word	.LANCHOR68
	.word	.LANCHOR31
	.word	.LANCHOR69
	.size	lpa_hash_update_ppa, .-lpa_hash_update_ppa
	.section	.text.ftl_mask_bad_block,"ax",%progbits
	.align	1
	.global	ftl_mask_bad_block
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_mask_bad_block, %function
ftl_mask_bad_block:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1149
	push	{r0, r1, r2, r4, r5, r6, r7, r8, r10, lr}
	ldrb	r4, [r3]	@ zero_extendqisi2
	movs	r3, #1
	rsb	r1, r4, #24
	lsl	r4, r3, r4
	lsr	r2, r0, r1
	subs	r4, r4, #1
	ands	r4, r4, r2
	ldr	r2, .L1149+4
	uxtb	r4, r4
	ldrb	r5, [r2]	@ zero_extendqisi2
	smulbb	r2, r4, r5
	uxtb	r8, r2
	ldr	r2, .L1149+8
	ldrh	r6, [r2]
	lsr	r2, r0, r6
	subs	r0, r1, r6
	lsl	r0, r3, r0
	mov	r1, r5
	subs	r0, r0, #1
	ands	r0, r0, r2
	uxth	r10, r0
	bl	__aeabi_uidiv
	ldr	r3, .L1149+12
	cmp	r5, #1
	it	hi
	addhi	r2, r5, #-1
	mov	r6, r0
	it	hi
	andhi	r2, r2, r10
	uxth	r7, r0
	ldr	r3, [r3]
	itt	hi
	addhi	r2, r2, r8
	uxtbhi	r8, r2
	lsls	r3, r3, #17
	bpl	.L1144
	uxth	r3, r0
	str	r10, [sp]
	mov	r2, r8
	ldr	r0, .L1149+16
	mov	r1, r4
	bl	printf
.L1144:
	ldr	r3, .L1149+20
	ldrh	r3, [r3]
	cmp	r3, r7
	bls	.L1142
	ldr	r3, .L1149+24
	uxth	r6, r6
	movs	r2, #1
	lsl	r8, r2, r8
	ldr	r3, [r3]
	add	r6, r3, r6, lsl #2
	ldrb	r2, [r6, #3]	@ zero_extendqisi2
	orr	r2, r2, r8
	strb	r2, [r6, #3]
.L1142:
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L1150:
	.align	2
.L1149:
	.word	.LANCHOR31
	.word	.LANCHOR69
	.word	.LANCHOR68
	.word	.LANCHOR14
	.word	.LC61
	.word	.LANCHOR6
	.word	.LANCHOR7
	.size	ftl_mask_bad_block, .-ftl_mask_bad_block
	.section	.text.gc_free_bad_sblk,"ax",%progbits
	.align	1
	.global	gc_free_bad_sblk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	gc_free_bad_sblk, %function
gc_free_bad_sblk:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r8, r0
	ldr	r4, .L1165
	ldr	r3, [r4, #580]
	cbz	r3, .L1163
	ldr	r7, .L1165+4
	mov	r10, #0
.L1153:
	ldr	r3, .L1165+8
	ldrb	r2, [r3]	@ zero_extendqisi2
	uxth	r3, r10
	cmp	r2, r3
	bhi	.L1160
.L1163:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1160:
	ldr	r3, .L1165+12
	uxth	r0, r10
	ldrb	fp, [r3]	@ zero_extendqisi2
	mov	r1, fp
	bl	__aeabi_idiv
	ldr	r3, .L1165+16
	uxth	r6, fp
	cmp	fp, #1
	ldr	r2, .L1165+20
	mov	fp, #0
	ldrb	r5, [r3]	@ zero_extendqisi2
	ldrh	r3, [r7]
	rsb	r5, r5, #24
	sub	r5, r5, r3
	lsl	r0, r0, r5
	smulbb	r5, r8, r6
	itt	hi
	addhi	r6, r6, #-1
	andhi	r6, r6, r10
	add	r5, r5, r0
	uxth	r5, r5
	itt	hi
	addhi	r5, r5, r6
	uxthhi	r5, r5
.L1155:
	ldr	r1, [r4, #580]
	uxth	r6, fp
	mov	r3, r6
	cmp	r1, r6
	bhi	.L1159
	add	r10, r10, #1
	b	.L1153
.L1159:
	add	r3, r3, #292
	ldrh	r3, [r4, r3, lsl #1]
	cmp	r3, r5
	bne	.L1156
	mov	r0, r2
	mov	r1, r5
	str	r2, [sp, #4]
	bl	printf
	ldrh	r0, [r7]
	lsl	r0, r5, r0
	bl	ftl_mask_bad_block
	ldr	r3, [r4, #580]
	ldr	r2, [sp, #4]
.L1157:
	cmp	r6, r3
	bcc	.L1158
	subs	r3, r3, #1
	str	r3, [r4, #580]
.L1156:
	add	fp, fp, #1
	b	.L1155
.L1158:
	addw	r1, r6, #293
	ldrh	r0, [r4, r1, lsl #1]
	add	r1, r6, #292
	adds	r6, r6, #1
	uxth	r6, r6
	strh	r0, [r4, r1, lsl #1]	@ movhi
	b	.L1157
.L1166:
	.align	2
.L1165:
	.word	.LANCHOR64
	.word	.LANCHOR68
	.word	.LANCHOR80
	.word	.LANCHOR69
	.word	.LANCHOR31
	.word	.LC62
	.size	gc_free_bad_sblk, .-gc_free_bad_sblk
	.section	.text.ftl_free_sblk,"ax",%progbits
	.align	1
	.global	ftl_free_sblk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_free_sblk, %function
ftl_free_sblk:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r5, r0
	ldr	r3, .L1186
	ldr	r8, [r3]
	lsls	r3, r0, #2
	add	r7, r8, r3
	ldrb	r4, [r7, #2]	@ zero_extendqisi2
	lsls	r2, r4, #28
	lsr	r3, r4, #5
	str	r3, [sp, #4]
	bpl	.L1169
	ldr	r3, .L1186+4
	ldrh	fp, [r8, r0, lsl #2]
	ldr	r1, .L1186+8
	ldr	r3, [r3]
	ldr	r0, [r8, r0, lsl #2]
	ubfx	fp, fp, #0, #11
	ldrh	r6, [r1]
	ldrh	r2, [r3, #74]
	ldrh	r3, [r3, #72]
	ubfx	r10, r0, #11, #8
	mov	r1, r6
	add	r2, r2, fp
	uxth	r2, r2
	add	r3, r3, r10
	uxth	r3, r3
	mov	r0, r2
	str	r2, [sp, #8]
	str	r3, [sp, #12]
	bl	__aeabi_uidiv
	ldr	r3, [sp, #12]
	ldr	r1, .L1186+12
	ldr	r2, [sp, #8]
	ldrh	r1, [r1]
	uxtah	r0, r3, r0
	cmp	r0, r1
	ble	.L1170
	ldr	r3, .L1186+16
	ldr	r1, .L1186+20
	ldrh	r2, [r3]
	ldr	r3, .L1186+24
	ldrh	r1, [r1]
	adds	r2, r2, #7
	ldrh	r3, [r3]
	add	r3, r3, r1
	cmp	r2, r3
	blt	.L1171
.L1176:
	movs	r3, #2
	bfi	r4, r3, #3, #2
	b	.L1184
.L1171:
	ldr	r3, .L1186+28
	ldr	r1, .L1186+32
	ldrh	r2, [r3]
	ldr	r3, .L1186+36
	ldrh	r1, [r1]
	adds	r2, r2, #7
	ldrh	r3, [r3]
	add	r3, r3, r1
	ldr	r1, .L1186+40
	ldrh	r1, [r1]
	add	r3, r3, r1
	cmp	r2, r3
	blt	.L1176
.L1185:
	bfc	r4, #3, #2
.L1184:
	strb	r4, [r7, #2]
.L1172:
	ldrb	r3, [r7, #2]	@ zero_extendqisi2
	ands	r3, r3, #24
	bne	.L1177
	mul	r6, r6, r10
	ldrh	r3, [r8, r5, lsl #2]
	lsr	r10, r10, #3
	add	r6, r6, r6, lsl #1
	add	fp, fp, r6, asr #2
	bfi	r3, fp, #0, #11
	strh	r3, [r8, r5, lsl #2]	@ movhi
	ldr	r3, [r8, r5, lsl #2]
	bfi	r3, r10, #11, #8
	str	r3, [r8, r5, lsl #2]
.L1169:
	mov	r0, r5
	bl	zftl_remove_data_node
	ldr	r3, .L1186
	lsls	r2, r5, #2
	ldr	r3, [r3]
	add	r3, r3, r2
	ldrb	r2, [r3, #2]	@ zero_extendqisi2
	bfc	r2, #5, #3
	strb	r2, [r3, #2]
	movs	r2, #0
	ldr	r3, .L1186+44
	ldr	r3, [r3]
	strh	r2, [r3, r5, lsl #1]	@ movhi
	ldr	r3, [sp, #4]
	adds	r3, r3, #6
	and	r3, r3, #7
	cmp	r3, #4
	bhi	.L1179
	mov	r0, r5
	bl	gc_free_bad_sblk
.L1179:
	ldrb	r3, [r7, #2]	@ zero_extendqisi2
	lsls	r3, r3, #28
	bpl	.L1180
	ldr	r3, .L1186+48
	ldr	r3, [r3]
	ldrh	r2, [r3, #586]
	cmp	r2, r5
	bne	.L1180
	ldrh	r1, [r3, #590]
	movw	r2, #65535
	strh	r2, [r3, #586]	@ movhi
	cmp	r1, r2
	bne	.L1180
	strh	r5, [r3, #590]	@ movhi
	mov	r1, r5
	ldr	r0, .L1186+52
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	printf
.L1170:
	mla	r3, r3, r6, r2
	ldr	r2, .L1186+56
	ldrh	r2, [r2]
	cmp	r3, r2
	ble	.L1172
	ldr	r3, .L1186+28
	ldr	r1, .L1186+32
	ldrh	r2, [r3]
	ldr	r3, .L1186+36
	ldrh	r1, [r1]
	ldrh	r3, [r3]
	add	r3, r3, r1
	ldr	r1, .L1186+40
	ldrh	r1, [r1]
	add	r3, r3, r1
	adds	r1, r2, #7
	cmp	r1, r3
	bge	.L1185
	ldr	r1, .L1186+16
	ldr	ip, .L1186+20
	ldrh	r0, [r1]
	ldr	r1, .L1186+24
	ldrh	ip, [ip]
	adds	r0, r0, #7
	ldrh	r1, [r1]
	add	r1, r1, ip
	cmp	r0, r1
	bge	.L1176
	adds	r2, r2, #23
	cmp	r3, r2
	bgt	.L1176
	b	.L1185
.L1177:
	cmp	r3, #16
	bne	.L1169
	mov	r0, fp
	mov	r1, r6
	bl	__aeabi_idiv
	add	r0, r0, r0, lsl #1
	ldr	r3, [r8, r5, lsl #2]
	asr	fp, fp, #5
	add	r10, r10, r0, asr #2
	bfi	r3, r10, #11, #8
	str	r3, [r8, r5, lsl #2]
	bfi	r3, fp, #0, #11
	strh	r3, [r8, r5, lsl #2]	@ movhi
	b	.L1169
.L1180:
	mov	r0, r5
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	zftl_insert_free_list
.L1187:
	.align	2
.L1186:
	.word	.LANCHOR7
	.word	.LANCHOR104
	.word	.LANCHOR8
	.word	.LANCHOR118
	.word	.LANCHOR95
	.word	.LANCHOR99
	.word	.LANCHOR94
	.word	.LANCHOR119
	.word	.LANCHOR97
	.word	.LANCHOR92
	.word	.LANCHOR90
	.word	.LANCHOR9
	.word	.LANCHOR10
	.word	.LC63
	.word	.LANCHOR120
	.size	ftl_free_sblk, .-ftl_free_sblk
	.section	.text.gc_free_src_blk,"ax",%progbits
	.align	1
	.global	gc_free_src_blk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	gc_free_src_blk, %function
gc_free_src_blk:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	movs	r5, #0
	ldr	r6, .L1225
.L1189:
	uxth	r2, r5
	ldr	r3, .L1225+4
	ldrh	r1, [r3, #52]
	cmp	r1, r2
	bhi	.L1203
	movs	r2, #0
	strh	r2, [r3, #52]	@ movhi
	pop	{r3, r4, r5, r6, r7, pc}
.L1203:
	uxth	r2, r5
	add	r3, r3, r2, lsl #1
	ldrh	r4, [r3, #54]
	ldr	r3, [r6]
	ldrh	r2, [r3, r4, lsl #1]
	cbz	r2, .L1190
	mov	r1, r4
	ldr	r0, .L1225+8
	bl	printf
.L1190:
	ldr	r3, [r6]
	movs	r2, #0
	strh	r2, [r3, r4, lsl #1]	@ movhi
	ldr	r3, .L1225+12
	ldr	r7, [r3]
	ldr	r3, .L1225+16
	ldr	r3, [r3]
	add	r7, r7, r4, lsl #2
	lsls	r3, r3, #23
	bpl	.L1191
	ldrb	r2, [r7, #2]	@ zero_extendqisi2
	mov	r1, r4
	ldr	r0, .L1225+20
	lsrs	r2, r2, #5
	bl	printf
.L1191:
	ldrb	r3, [r7, #2]	@ zero_extendqisi2
	and	r2, r3, #224
	cmp	r2, #224
	beq	.L1192
	tst	r3, #192
	bne	.L1193
.L1192:
	movw	r2, #1114
	ldr	r1, .L1225+24
	ldr	r0, .L1225+28
	bl	printf
.L1193:
	mov	r0, r4
	bl	ftl_free_sblk
	ldr	r3, .L1225+32
	ldr	r3, [r3]
	ldrh	r1, [r3, #124]
	cbz	r1, .L1194
	add	r0, r3, #392
	movs	r2, #0
.L1196:
	ldrh	r7, [r0], #2
	cmp	r4, r7
	bne	.L1195
	adds	r2, r2, #196
	movw	r0, #65535
	subs	r1, r1, #1
	strh	r0, [r3, r2, lsl #1]	@ movhi
	strh	r1, [r3, #124]	@ movhi
.L1194:
	ldrh	r1, [r3, #120]
	cbz	r1, .L1197
	add	r0, r3, #136
	movs	r2, #0
.L1199:
	ldrh	r7, [r0], #2
	cmp	r4, r7
	bne	.L1198
	adds	r2, r2, #68
	movw	r0, #65535
	subs	r1, r1, #1
	strh	r0, [r3, r2, lsl #1]	@ movhi
	strh	r1, [r3, #120]	@ movhi
.L1197:
	ldrh	r1, [r3, #122]
	cbz	r1, .L1200
	add	r0, r3, #264
	movs	r2, #0
.L1202:
	ldrh	r7, [r0], #2
	cmp	r4, r7
	bne	.L1201
	adds	r2, r2, #132
	movw	r0, #65535
	subs	r1, r1, #1
	strh	r0, [r3, r2, lsl #1]	@ movhi
	strh	r1, [r3, #122]	@ movhi
.L1200:
	adds	r5, r5, #1
	b	.L1189
.L1195:
	adds	r2, r2, #1
	cmp	r2, #64
	bne	.L1196
	b	.L1194
.L1198:
	adds	r2, r2, #1
	cmp	r2, #64
	bne	.L1199
	b	.L1197
.L1201:
	adds	r2, r2, #1
	cmp	r2, #64
	bne	.L1202
	b	.L1200
.L1226:
	.align	2
.L1225:
	.word	.LANCHOR9
	.word	.LANCHOR64
	.word	.LC64
	.word	.LANCHOR7
	.word	.LANCHOR14
	.word	.LC65
	.word	.LANCHOR121
	.word	.LC0
	.word	.LANCHOR10
	.size	gc_free_src_blk, .-gc_free_src_blk
	.section	.text.print_ftl_debug_info,"ax",%progbits
	.align	1
	.global	print_ftl_debug_info
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	print_ftl_debug_info, %function
print_ftl_debug_info:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	sub	sp, sp, #32
	ldr	r4, .L1228
	ldr	r5, .L1228+4
	ldr	r6, .L1228+8
	ldr	r1, [r4]
	ldr	r0, [r5]
	ldr	r6, [r6]
	ldr	r3, .L1228+12
	ldrh	r2, [r1, #146]
	ldrh	r1, [r1, #148]
	ldrh	r3, [r3]
	str	r6, [sp, #28]
	ldr	r6, [r0, #528]
	str	r6, [sp, #24]
	ldr	r0, [r0, #524]
	str	r0, [sp, #20]
	ldr	r0, .L1228+16
	ldrh	r0, [r0]
	str	r0, [sp, #16]
	ldr	r0, .L1228+20
	ldrh	r0, [r0]
	str	r0, [sp, #12]
	ldr	r0, .L1228+24
	ldrh	r0, [r0]
	str	r0, [sp, #8]
	ldr	r0, .L1228+28
	ldrh	r0, [r0]
	str	r0, [sp, #4]
	ldr	r0, .L1228+32
	ldrh	r0, [r0]
	str	r0, [sp]
	ldr	r0, .L1228+36
	bl	printf
	ldr	r1, [r4]
	ldr	r3, .L1228+40
	ldr	r0, .L1228+44
	ldr	r2, [r1, #64]
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r2, [sp, #4]
	ldr	r2, [r1, #8]
	str	r2, [sp]
	ldr	r2, [r1, #28]
	ldr	r1, [r1, #20]
	bl	printf
	ldr	r1, [r4]
	ldr	r0, .L1228+48
	ldr	r3, [r1, #16]
	ldr	r2, [r1, #60]
	ldr	r1, [r1, #52]
	lsrs	r3, r3, #11
	bl	printf
	ldr	r2, [r4]
	ldrh	r0, [r2, #98]
	ldrh	r3, [r2, #88]
	ldrh	r1, [r2, #74]
	str	r0, [sp, #24]
	ldrh	r0, [r2, #94]
	str	r0, [sp, #20]
	ldrh	r0, [r2, #90]
	str	r0, [sp, #16]
	ldr	r0, [r2, #80]
	str	r0, [sp, #12]
	ldrh	r0, [r2, #72]
	str	r0, [sp, #8]
	ldrh	r0, [r2, #96]
	str	r0, [sp, #4]
	ldrh	r0, [r2, #92]
	str	r0, [sp]
	ldr	r0, .L1228+52
	ldr	r2, [r2, #84]
	bl	printf
	ldr	r0, .L1228+56
	ldr	r3, .L1228+60
	ldr	r2, .L1228+64
	ldrh	r0, [r0]
	ldr	r1, .L1228+68
	ldrh	r3, [r3]
	ldrh	r2, [r2]
	ldrh	r1, [r1]
	str	r0, [sp, #4]
	ldr	r0, .L1228+72
	ldrh	r0, [r0]
	str	r0, [sp]
	ldr	r0, .L1228+76
	bl	printf
	ldr	r4, [r4]
	ldr	r0, [r5]
	ldrh	r5, [r4, #150]
	ldrh	r3, [r0, #588]
	ldrh	r2, [r0, #586]
	ldrh	r1, [r0, #584]
	str	r5, [sp, #8]
	ldr	r4, [r4, #156]
	str	r4, [sp, #4]
	ldrh	r0, [r0, #590]
	str	r0, [sp]
	ldr	r0, .L1228+80
	bl	printf
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, pc}
.L1229:
	.align	2
.L1228:
	.word	.LANCHOR104
	.word	.LANCHOR10
	.word	.LANCHOR122
	.word	.LANCHOR97
	.word	.LANCHOR94
	.word	.LANCHOR90
	.word	.LANCHOR92
	.word	.LANCHOR101
	.word	.LANCHOR99
	.word	.LC66
	.word	.LANCHOR123
	.word	.LC67
	.word	.LC68
	.word	.LC69
	.word	.LANCHOR81
	.word	.LANCHOR63
	.word	.LANCHOR96
	.word	.LANCHOR93
	.word	.LANCHOR86
	.word	.LC70
	.word	.LC71
	.size	print_ftl_debug_info, .-print_ftl_debug_info
	.section	.text.ftl_write_buf,"ax",%progbits
	.align	1
	.global	ftl_write_buf
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_write_buf, %function
ftl_write_buf:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	mov	r4, r0
	cbnz	r0, .L1231
	mov	r2, #676
	ldr	r1, .L1240
	ldr	r0, .L1240+4
	bl	printf
	bl	print_ftl_debug_info
	mov	r0, #-1
	pop	{r4, r5, r6, pc}
.L1234:
	mov	r1, r4
	ldr	r0, .L1240+8
	bl	buf_add_tail
	ldr	r3, .L1240+12
	ldrb	r1, [r4, #40]	@ zero_extendqisi2
	ldrb	r0, [r6]	@ zero_extendqisi2
	ldr	r3, [r3]
	adds	r0, r0, #1
	ldr	r2, [r3, #16]
	uxtb	r0, r0
	strb	r0, [r6]
	add	r2, r2, r1
	str	r2, [r3, #16]
	ldr	r2, [r3, #32]
	adds	r2, r2, #1
	str	r2, [r3, #32]
	pop	{r4, r5, r6, pc}
.L1231:
	ldr	r5, .L1240+16
	ldrb	r1, [r0, #40]	@ zero_extendqisi2
	ldrb	r2, [r5]	@ zero_extendqisi2
	cmp	r1, r2
	bls	.L1236
	movw	r2, #681
	ldr	r1, .L1240
	ldr	r0, .L1240+4
	bl	printf
.L1236:
	ldrb	r3, [r4, #40]	@ zero_extendqisi2
	ldr	r6, .L1240+20
	cbz	r3, .L1233
	ldrb	r2, [r5]	@ zero_extendqisi2
	cmp	r2, r3
	bcs	.L1234
.L1233:
	mov	r0, r4
	bl	zbuf_free
	ldrb	r0, [r6]	@ zero_extendqisi2
	pop	{r4, r5, r6, pc}
.L1241:
	.align	2
.L1240:
	.word	.LANCHOR124
	.word	.LC0
	.word	.LANCHOR59
	.word	.LANCHOR104
	.word	.LANCHOR125
	.word	.LANCHOR60
	.size	ftl_write_buf, .-ftl_write_buf
	.section	.text.ftl_write_completed,"ax",%progbits
	.align	1
	.global	ftl_write_completed
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_write_completed, %function
ftl_write_completed:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, r8, r10, lr}
	mov	r8, #0
	ldr	r7, .L1252
.L1243:
	ldr	r2, .L1252+4
	ldrb	r5, [r2]	@ zero_extendqisi2
	cmp	r5, #255
	bne	.L1251
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L1251:
	movs	r3, #48
	add	r6, r5, r5, lsl #1
	muls	r3, r5, r3
	add	r6, r7, r6, lsl #4
	adds	r4, r7, r3
	ldrb	r3, [r7, r3]	@ zero_extendqisi2
	strb	r3, [r2]
	ldr	r3, [r4, #36]
	adds	r3, r3, #1
	bne	.L1244
	ldr	r2, .L1252+8
	ldr	r3, .L1252+12
	ldr	r10, [r4, #24]
	ldrb	r2, [r2]	@ zero_extendqisi2
	ldrh	r3, [r3]
	ldr	r8, .L1252+28
	rsb	r2, r2, #24
	subs	r0, r2, r3
	movs	r2, #1
	lsls	r2, r2, r0
	lsr	r0, r10, r3
	ldr	r3, .L1252+16
	subs	r2, r2, #1
	ands	r0, r0, r2
	ldrb	r1, [r3]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	ldr	r2, [r8]
	movw	r1, #65535
	uxth	r4, r0
	ldr	r0, .L1252+20
	ldr	r3, [r2, #560]
	cmp	r3, r1
	mov	r3, #48
	mla	r5, r3, r5, r7
	itt	eq
	streq	r4, [r2, #560]
	streq	r10, [r2, #564]
	mov	r3, r10
	mov	r1, r4
	ldr	r2, [r5, #20]
	bl	printf
	ldr	r3, [r8]
	ldr	r2, [r3, #556]
	adds	r2, r2, #1
	str	r2, [r3, #556]
	ldrh	r2, [r3, #16]
	cmp	r2, r4
	bne	.L1246
	movs	r2, #0
	strh	r2, [r3, #22]	@ movhi
.L1247:
	mov	r0, r6
	mov	r8, #1
	bl	ftl_write_buf
	b	.L1243
.L1246:
	ldrh	r2, [r3, #48]
	cmp	r2, r4
	itt	eq
	moveq	r2, #0
	strheq	r2, [r3, #54]	@ movhi
	b	.L1247
.L1244:
	cmp	r8, #0
	beq	.L1249
	ldr	r2, [r4, #24]
	ldr	r1, [r4, #20]
	ldr	r0, .L1252+24
	bl	printf
	mov	r0, r6
	bl	ftl_write_buf
	b	.L1243
.L1249:
	ldrh	r2, [r4, #32]
	ldr	r1, [r4, #28]
	ldr	r0, [r4, #20]
	bl	lpa_hash_update_ppa
	ldrb	r3, [r4, #2]	@ zero_extendqisi2
	lsls	r2, r3, #29
	bpl	.L1250
	bic	r3, r3, #2
	strb	r3, [r4, #2]
	b	.L1243
.L1250:
	mov	r0, r6
	bl	zbuf_free
	b	.L1243
.L1253:
	.align	2
.L1252:
	.word	.LANCHOR52
	.word	.LANCHOR126
	.word	.LANCHOR31
	.word	.LANCHOR68
	.word	.LANCHOR69
	.word	.LC72
	.word	.LC73
	.word	.LANCHOR10
	.size	ftl_write_completed, .-ftl_write_completed
	.section	.text.zftl_add_read_buf,"ax",%progbits
	.align	1
	.global	zftl_add_read_buf
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	zftl_add_read_buf, %function
zftl_add_read_buf:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	mov	r4, r0
	cbnz	r0, .L1255
	mov	r2, #972
	ldr	r1, .L1259
	ldr	r0, .L1259+4
	bl	printf
	pop	{r4, lr}
	b	print_ftl_debug_info
.L1255:
	ldr	r3, .L1259+8
	ldrb	r2, [r0, #40]	@ zero_extendqisi2
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r2, r3
	bls	.L1257
	movw	r2, #977
	ldr	r1, .L1259
	ldr	r0, .L1259+4
	bl	printf
.L1257:
	mov	r1, r4
	ldr	r0, .L1259+12
	bl	buf_add_tail
	ldr	r2, .L1259+16
	ldrb	r3, [r2]	@ zero_extendqisi2
	adds	r3, r3, #1
	strb	r3, [r2]
	pop	{r4, pc}
.L1260:
	.align	2
.L1259:
	.word	.LANCHOR127
	.word	.LC0
	.word	.LANCHOR125
	.word	.LANCHOR128
	.word	.LANCHOR129
	.size	zftl_add_read_buf, .-zftl_add_read_buf
	.section	.text.ftl_alloc_sblk,"ax",%progbits
	.align	1
	.global	ftl_alloc_sblk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_alloc_sblk, %function
ftl_alloc_sblk:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	uxth	r6, r0
	cmp	r0, #5
	mov	r5, r0
	mov	r1, r6
	mov	r0, #0
	ite	ne
	movne	r7, #0
	moveq	r7, #2
	bl	zftl_get_free_sblk
	movw	r3, #65535
	mov	r4, r0
	cmp	r0, r3
	beq	.L1263
	ldr	r3, .L1270
	ldr	r6, [r3]
	add	r6, r6, r0, lsl #2
	ldrb	r3, [r6, #2]	@ zero_extendqisi2
	tst	r3, #224
	beq	.L1264
	mov	r2, #836
	ldr	r1, .L1270+4
	ldr	r0, .L1270+8
	bl	printf
.L1264:
	ldrb	r3, [r6, #2]	@ zero_extendqisi2
	bfi	r3, r5, #5, #3
	uxtb	r3, r3
	ubfx	r2, r3, #3, #2
	orrs	r7, r7, r2
	bfi	r3, r7, #3, #2
	strb	r3, [r6, #2]
.L1265:
	mov	r0, r4
	pop	{r3, r4, r5, r6, r7, pc}
.L1263:
	bl	print_ftl_debug_info
	mov	r2, r5
	mov	r1, r4
	ldr	r0, .L1270+12
	bl	printf
	mov	r1, r6
	movs	r0, #0
	bl	zftl_get_free_sblk
	mov	r2, r5
	mov	r1, r0
	mov	r4, r0
	ldr	r0, .L1270+12
	bl	printf
	bl	dump_all_list_info
	movw	r2, #846
	ldr	r1, .L1270+4
	ldr	r0, .L1270+8
	bl	printf
	b	.L1265
.L1271:
	.align	2
.L1270:
	.word	.LANCHOR7
	.word	.LANCHOR130
	.word	.LC0
	.word	.LC74
	.size	ftl_alloc_sblk, .-ftl_alloc_sblk
	.section	.text.sblk_init,"ax",%progbits
	.align	1
	.global	sblk_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	sblk_init, %function
sblk_init:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r2, .L1273
	movs	r3, #255
	movs	r0, #0
	strb	r3, [r2]
	ldr	r2, .L1273+4
	strb	r3, [r2]
	ldr	r2, .L1273+8
	strb	r3, [r2]
	ldr	r2, .L1273+12
	strb	r3, [r2]
	bx	lr
.L1274:
	.align	2
.L1273:
	.word	.LANCHOR56
	.word	.LANCHOR126
	.word	.LANCHOR131
	.word	.LANCHOR71
	.size	sblk_init, .-sblk_init
	.section	.text.dump_sblk_queue,"ax",%progbits
	.align	1
	.global	dump_sblk_queue
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	dump_sblk_queue, %function
dump_sblk_queue:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	ldr	r4, .L1284
	ldr	r0, .L1284+4
	ldrb	r1, [r4]	@ zero_extendqisi2
	bl	printf
	ldrb	r4, [r4]	@ zero_extendqisi2
	cmp	r4, #255
	beq	.L1275
	ldr	r5, .L1284+8
	add	r4, r4, r4, lsl #1
	ldr	r6, .L1284+12
	add	r4, r5, r4, lsl #4
.L1277:
	ldr	r3, [r4, #24]
	mov	r0, r6
	ldrb	r2, [r4, #42]	@ zero_extendqisi2
	ldrb	r1, [r4, #1]	@ zero_extendqisi2
	bl	printf
	ldrb	r4, [r4]	@ zero_extendqisi2
	cmp	r4, #255
	beq	.L1275
	add	r4, r4, r4, lsl #1
	add	r4, r5, r4, lsl #4
	b	.L1277
.L1275:
	pop	{r4, r5, r6, pc}
.L1285:
	.align	2
.L1284:
	.word	.LANCHOR56
	.word	.LC75
	.word	.LANCHOR52
	.word	.LC76
	.size	dump_sblk_queue, .-dump_sblk_queue
	.section	.text.queue_lun_state,"ax",%progbits
	.align	1
	.global	queue_lun_state
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	queue_lun_state, %function
queue_lun_state:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1305
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	ldrb	r6, [r3]	@ zero_extendqisi2
	cmp	r6, #255
	beq	.L1294
	ldr	r3, .L1305+4
	movs	r2, #1
	ldr	r10, .L1305+16
	mov	r8, #48
	ldrb	r3, [r3]	@ zero_extendqisi2
	rsb	ip, r3, #24
	lsl	r3, r2, r3
	asr	r4, r0, ip
	subs	r3, r3, #1
	uxth	r3, r3
	ands	r4, r4, r3
	str	r4, [sp]
	ldr	r4, .L1305+8
	ldrh	lr, [r4]
	sub	r4, ip, lr
	lsls	r2, r2, r4
	ldr	r4, .L1305+12
	subs	r2, r2, #1
	ldrb	r7, [r4]	@ zero_extendqisi2
	asr	r4, r0, lr
	uxth	r2, r2
	subs	r7, r7, #1
	uxth	r7, r7
	ands	r4, r4, r7
	and	r0, r4, r2
	str	r0, [sp, #4]
.L1293:
	mla	fp, r8, r6, r10
	ldr	r5, [fp, #24]
	lsr	r0, r5, ip
	ands	r0, r0, r3
	mov	r4, r0
	ldr	r0, [sp]
	cmp	r0, r4
	bne	.L1288
	lsr	r5, r5, lr
	ldr	r4, [sp, #4]
	ldrb	r0, [fp, #42]	@ zero_extendqisi2
	ands	r5, r5, r7
	ands	r5, r5, r2
	cmp	r4, r5
	bne	.L1289
	cmp	r1, #1
	bne	.L1286
.L1291:
	cmp	r0, #7
	beq	.L1288
	cmp	r0, #9
.L1302:
	bne	.L1286
.L1288:
	mul	r6, r8, r6
	ldr	r0, .L1305+16
	ldrb	r6, [r0, r6]	@ zero_extendqisi2
	cmp	r6, #255
	bne	.L1293
.L1294:
	movs	r0, #0
.L1286:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1289:
	cmp	r1, #3
	bhi	.L1288
	adr	r5, .L1290
	ldr	pc, [r5, r1, lsl #2]
	.p2align 2
.L1290:
	.word	.L1286+1
	.word	.L1291+1
	.word	.L1292+1
	.word	.L1286+1
	.p2align 1
.L1292:
	cmp	r0, #11
	b	.L1302
.L1306:
	.align	2
.L1305:
	.word	.LANCHOR56
	.word	.LANCHOR31
	.word	.LANCHOR68
	.word	.LANCHOR69
	.word	.LANCHOR52
	.size	queue_lun_state, .-queue_lun_state
	.section	.text.queue_remove_completed_req,"ax",%progbits
	.align	1
	.global	queue_remove_completed_req
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	queue_remove_completed_req, %function
queue_remove_completed_req:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	ip, #0
	ldr	r5, .L1332
	movs	r4, #48
	mov	fp, #255
	ldr	r6, .L1332+4
	ldrb	r3, [r5]	@ zero_extendqisi2
	ldr	r1, .L1332+8
	ldr	r7, .L1332+12
	str	r3, [sp, #4]
	ldrb	r3, [r6]	@ zero_extendqisi2
	ldrb	r2, [r1]	@ zero_extendqisi2
	ldrb	r10, [r7]	@ zero_extendqisi2
	str	r3, [sp]
	ldr	r3, .L1332+16
.L1308:
	cmp	r2, #255
	beq	.L1309
	mul	r8, r4, r2
	mov	r0, r2
	add	lr, r3, r8
	ldrb	lr, [lr, #42]	@ zero_extendqisi2
	sub	lr, lr, #12
	cmp	lr, #1
	bls	.L1310
.L1309:
	cmp	ip, #0
	beq	.L1307
	strb	r2, [r1]
	b	.L1307
.L1310:
	mul	lr, r4, r0
	ldrb	r2, [r3, r8]	@ zero_extendqisi2
	add	ip, r3, lr
	strb	fp, [r3, lr]
	ldrb	lr, [ip, #43]	@ zero_extendqisi2
	cmp	lr, #1
	bne	.L1313
	ldrh	ip, [ip, #34]
	cmp	ip, #0
	bne	.L1321
	mov	ip, r10
	mov	lr, r7
.L1314:
	cmp	ip, #255
	bne	.L1319
	strb	r2, [r1]
	movs	r2, #48
	mla	r3, r2, r0, r3
	ldrb	r3, [r3, #1]	@ zero_extendqisi2
	strb	r3, [lr]
.L1307:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1313:
	cmp	lr, #0
	bne	.L1315
	ldr	ip, [ip, #20]
	cmp	ip, #-1
	beq	.L1315
	ldr	ip, [sp, #4]
	mov	lr, r5
	b	.L1314
.L1321:
	ldr	ip, [sp]
	mov	lr, r6
	b	.L1314
.L1319:
	mov	lr, ip
	mul	ip, r4, ip
	ldrb	ip, [r3, ip]	@ zero_extendqisi2
	cmp	ip, #255
	bne	.L1319
	mla	r0, r4, r0, r3
	mul	lr, r4, lr
	ldrb	r0, [r0, #1]	@ zero_extendqisi2
	strb	r0, [r3, lr]
.L1315:
	mov	ip, #1
	b	.L1308
.L1333:
	.align	2
.L1332:
	.word	.LANCHOR131
	.word	.LANCHOR71
	.word	.LANCHOR56
	.word	.LANCHOR126
	.word	.LANCHOR52
	.size	queue_remove_completed_req, .-queue_remove_completed_req
	.section	.text.pm_alloc_new_blk,"ax",%progbits
	.align	1
	.global	pm_alloc_new_blk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	pm_alloc_new_blk, %function
pm_alloc_new_blk:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r4, r5, r6, r7, lr}
	ldr	r5, .L1350
	ldr	r1, .L1350+4
	ldr	r2, [r5]
	ldrb	r1, [r1]	@ zero_extendqisi2
	ldrh	r3, [r2, #690]
	adds	r3, r3, #1
	uxth	r3, r3
	cmp	r1, r3
	strh	r3, [r2, #690]	@ movhi
	bls	.L1335
	add	r3, r3, #336
	ldrh	r2, [r2, r3, lsl #1]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L1336
.L1335:
	ldr	r7, .L1350+8
	ldr	r4, .L1350+12
.L1348:
	movs	r0, #1
	bl	ftl_alloc_sblk
	movs	r1, #0
	mov	r6, r0
	bl	ftl_erase_sblk
	ldr	r1, [r5]
	mov	r0, r6
	add	r1, r1, #672
	bl	ftl_get_blk_list_in_sblk
	uxth	r0, r0
	cbnz	r0, .L1337
	mov	r1, r6
	mov	r0, r7
	bl	printf
	ldr	r3, [r4]
	add	r6, r3, r6, lsl #2
	ldrb	r3, [r6, #2]	@ zero_extendqisi2
	orr	r3, r3, #224
	strb	r3, [r6, #2]
	b	.L1348
.L1337:
	ldr	r3, [r5]
	movs	r1, #1
	ldr	r2, .L1350+16
	movs	r4, #0
	strh	r4, [r3, #690]	@ movhi
	add	r3, r3, #416
	str	r1, [r2]
	movw	r1, #65535
.L1339:
	ldrh	r0, [r3], #2
	uxth	r2, r4
	cmp	r0, r1
	beq	.L1338
	adds	r4, r4, #1
	cmp	r4, #128
	bne	.L1339
	movs	r2, #227
	ldr	r1, .L1350+20
	ldr	r0, .L1350+24
	bl	printf
	mov	r2, r4
.L1338:
	ldr	r3, [r5]
	adds	r2, r2, #208
	strh	r6, [r3, r2, lsl #1]	@ movhi
	ldrh	r2, [r3, #688]
	adds	r2, r2, #1
	strh	r2, [r3, #688]	@ movhi
.L1336:
	ldr	r2, [r5]
	ldrh	r3, [r2, #690]
	add	r3, r3, #336
	ldrh	r4, [r2, r3, lsl #1]
	movw	r2, #65533
	subs	r3, r4, #1
	uxth	r3, r3
	cmp	r3, r2
	bls	.L1341
	movs	r2, #232
	ldr	r1, .L1350+20
	ldr	r0, .L1350+24
	bl	printf
.L1341:
	ldr	r1, [r5]
	movs	r3, #0
	strh	r3, [r1, #696]	@ movhi
	ldr	r3, .L1350+28
	strh	r4, [r1, #692]	@ movhi
	ldrb	r2, [r3]	@ zero_extendqisi2
	ldr	r3, .L1350+32
	rsb	r2, r2, #24
	ldrh	r3, [r3]
	subs	r2, r2, r3
	asr	r3, r4, r2
	strh	r3, [r1, #694]	@ movhi
	ldr	r1, .L1350+36
	ldr	r1, [r1]
	lsls	r1, r1, #19
	bpl	.L1345
	movs	r1, #1
	uxth	r3, r3
	lsl	r2, r1, r2
	ldr	r0, .L1350+40
	str	r3, [sp]
	mov	r1, r4
	mov	r3, r4
	subs	r2, r2, #1
	bl	printf
.L1345:
	movs	r0, #0
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, pc}
.L1351:
	.align	2
.L1350:
	.word	.LANCHOR104
	.word	.LANCHOR80
	.word	.LC77
	.word	.LANCHOR7
	.word	.LANCHOR132
	.word	.LANCHOR133
	.word	.LC0
	.word	.LANCHOR31
	.word	.LANCHOR68
	.word	.LANCHOR14
	.word	.LC78
	.size	pm_alloc_new_blk, .-pm_alloc_new_blk
	.section	.text.pm_select_ram_region,"ax",%progbits
	.align	1
	.global	pm_select_ram_region
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	pm_select_ram_region, %function
pm_select_ram_region:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r2, .L1362
	movw	r0, #65535
	push	{r3, r4, r5, r6, r7, lr}
	movs	r3, #0
	mov	r1, r2
.L1354:
	ldrh	r5, [r2, r3, lsl #3]
	uxth	r4, r3
	cmp	r5, r0
	beq	.L1353
	adds	r3, r3, #1
	cmp	r3, #32
	bne	.L1354
	movs	r2, #0
	mov	r4, r3
	mov	r0, #32768
.L1356:
	add	r3, r1, r2, lsl #3
	uxth	r5, r2
	ldrh	r3, [r3, #2]
	lsls	r6, r3, #16
	bmi	.L1355
	cmp	r3, r0
	itt	cc
	movcc	r0, r3
	movcc	r4, r5
.L1355:
	adds	r2, r2, #1
	cmp	r2, #32
	bne	.L1356
	cmp	r4, #32
	bne	.L1353
	ldr	r3, .L1362+4
	mov	r2, #-1
	ldrb	r5, [r3]	@ zero_extendqisi2
	movs	r3, #0
.L1358:
	add	r0, r1, r3, lsl #3
	uxth	r6, r3
	ldrh	r0, [r0, #2]
	cmp	r0, r2
	bcs	.L1357
	ldrh	r7, [r1, r3, lsl #3]
	cmp	r7, r5
	itt	ne
	movne	r2, r0
	movne	r4, r6
.L1357:
	adds	r3, r3, #1
	cmp	r3, #32
	bne	.L1358
	cmp	r4, #32
	bne	.L1353
	movw	r2, #331
	ldr	r1, .L1362+8
	ldr	r0, .L1362+12
	bl	printf
.L1353:
	mov	r0, r4
	pop	{r3, r4, r5, r6, r7, pc}
.L1363:
	.align	2
.L1362:
	.word	.LANCHOR134
	.word	.LANCHOR135
	.word	.LANCHOR136
	.word	.LC0
	.size	pm_select_ram_region, .-pm_select_ram_region
	.section	.text.idb_init,"ax",%progbits
	.align	1
	.global	idb_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	idb_init, %function
idb_init:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L1365
	movs	r0, #0
	str	r0, [r3]
	ldr	r3, .L1365+4
	str	r0, [r3]
	ldr	r3, .L1365+8
	str	r0, [r3]
	bx	lr
.L1366:
	.align	2
.L1365:
	.word	.LANCHOR137
	.word	.LANCHOR138
	.word	.LANCHOR139
	.size	idb_init, .-idb_init
	.section	.text.ftl_memset,"ax",%progbits
	.align	1
	.global	ftl_memset
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_memset, %function
ftl_memset:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	b	memset
	.size	ftl_memset, .-ftl_memset
	.section	.text.flash_lsb_page_tbl_build,"ax",%progbits
	.align	1
	.global	flash_lsb_page_tbl_build
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_lsb_page_tbl_build, %function
flash_lsb_page_tbl_build:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	ldr	r4, .L1406
	cbnz	r0, .L1369
.L1370:
	strh	r0, [r4, r0, lsl #1]	@ movhi
	adds	r0, r0, #1
	cmp	r0, #256
	bne	.L1370
.L1376:
	movs	r1, #255
	mov	r2, #1024
	ldr	r0, .L1406+4
	bl	ftl_memset
	ldr	r1, .L1406+4
	movs	r3, #0
.L1371:
	ldrh	r2, [r4, r3, lsl #1]
	adds	r3, r3, #1
	cmp	r3, #256
	strh	r2, [r1, r2, lsl #1]	@ movhi
	bne	.L1371
	pop	{r4, pc}
.L1369:
	cmp	r0, #1
	bne	.L1372
	movs	r3, #0
.L1375:
	cmp	r3, #3
	uxth	r2, r3
	bls	.L1373
	tst	r2, #1
	ite	ne
	movne	r1, #3
	moveq	r1, #2
	rsb	r2, r1, r2, lsl #1
	uxth	r2, r2
.L1373:
	strh	r2, [r4, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	cmp	r3, #256
	bne	.L1375
	b	.L1376
.L1372:
	cmp	r0, #2
	bne	.L1377
	movs	r2, #0
.L1379:
	uxth	r3, r2
	cmp	r2, #1
	ittt	hi
	lslhi	r3, r3, #1
	addhi	r3, r3, #-1
	uxthhi	r3, r3
	strh	r3, [r4, r2, lsl #1]	@ movhi
	adds	r2, r2, #1
	cmp	r2, #256
	bne	.L1379
	b	.L1376
.L1377:
	cmp	r0, #3
	bne	.L1380
	movs	r3, #0
.L1383:
	cmp	r3, #5
	uxth	r2, r3
	bls	.L1381
	tst	r2, #1
	ite	ne
	movne	r1, #5
	moveq	r1, #4
	rsb	r2, r1, r2, lsl #1
	uxth	r2, r2
.L1381:
	strh	r2, [r4, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	cmp	r3, #256
	bne	.L1383
	b	.L1376
.L1380:
	cmp	r0, #4
	mov	r3, #0
	bne	.L1384
	strh	r3, [r4]	@ movhi
	movs	r3, #1
	strh	r3, [r4, #2]	@ movhi
	movs	r3, #2
	strh	r3, [r4, #4]	@ movhi
	movs	r3, #3
	strh	r3, [r4, #6]	@ movhi
	movs	r3, #5
	strh	r3, [r4, #10]	@ movhi
	movs	r3, #7
	strh	r3, [r4, #12]	@ movhi
	mov	r2, r4
	movs	r3, #8
	strh	r0, [r4, #8]	@ movhi
	strh	r3, [r2, #14]!	@ movhi
.L1386:
	tst	r3, #1
	ite	ne
	movne	r1, #7
	moveq	r1, #6
	rsb	r1, r1, r3, lsl #1
	adds	r3, r3, #1
	uxth	r3, r3
	strh	r1, [r2, #2]!	@ movhi
	cmp	r3, #256
	bne	.L1386
	b	.L1376
.L1384:
	cmp	r0, #5
	bne	.L1387
.L1388:
	strh	r3, [r4, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	cmp	r3, #16
	bne	.L1388
	ldr	r2, .L1406+8
.L1389:
	strh	r3, [r2, #2]!	@ movhi
	adds	r3, r3, #2
	uxth	r3, r3
	cmp	r3, #496
	bne	.L1389
	b	.L1376
.L1387:
	cmp	r0, #8
	bne	.L1390
.L1391:
	strh	r3, [r4, r3]	@ movhi
	adds	r3, r3, #2
	cmp	r3, #512
	bne	.L1391
	b	.L1376
.L1390:
	cmp	r0, #9
	bne	.L1376
	strh	r3, [r4]	@ movhi
	movs	r3, #1
	strh	r3, [r4, #2]	@ movhi
	mov	r2, r4
	movs	r3, #2
	movw	r1, #509
	strh	r3, [r2, #4]!	@ movhi
	movs	r3, #3
.L1392:
	strh	r3, [r2, #2]!	@ movhi
	adds	r3, r3, #2
	uxth	r3, r3
	cmp	r3, r1
	bne	.L1392
	b	.L1376
.L1407:
	.align	2
.L1406:
	.word	.LANCHOR3
	.word	.LANCHOR140
	.word	.LANCHOR3+30
	.size	flash_lsb_page_tbl_build, .-flash_lsb_page_tbl_build
	.section	.text.flash_die_info_init,"ax",%progbits
	.align	1
	.global	flash_die_info_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_die_info_init, %function
flash_die_info_init:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1425
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L1409
	ldr	r1, .L1425+4
	ldr	r0, .L1425+8
	bl	printf
.L1409:
	ldr	r4, .L1425+12
	movs	r6, #0
	ldr	r5, .L1425+16
	ldr	r7, .L1425+20
	ldrh	r3, [r4, #26]
	ldrb	r1, [r4, #12]	@ zero_extendqisi2
	ldrh	r0, [r4, #10]
	strh	r3, [r7]	@ movhi
	strb	r6, [r5]
	bl	__aeabi_idiv
	ldr	r10, .L1425+48
	movs	r2, #8
	ldr	r3, .L1425+24
	mov	r1, r6
	mov	r8, r10
	strh	r0, [r3]	@ movhi
	ldr	r0, .L1425+28
	bl	ftl_memset
	movs	r2, #32
	mov	r1, r6
	ldr	r0, .L1425+32
	bl	ftl_memset
.L1411:
	ldr	r3, .L1425+36
	movs	r2, #2
	add	r1, r10, r6, lsl #3
	ldr	r0, .L1425+40
	strb	r2, [r6, r3]
	ldrb	r2, [r4]	@ zero_extendqisi2
	bl	flash_mem_cmp8
	cbnz	r0, .L1410
	ldrb	r3, [r5]	@ zero_extendqisi2
	ldr	r2, .L1425+32
	str	r0, [r2, r3, lsl #2]
	adds	r2, r3, #1
	strb	r2, [r5]
	uxtb	r0, r6
	ldr	r2, .L1425+28
	strb	r0, [r2, r3]
	bl	zftl_flash_enter_slc_mode
.L1410:
	adds	r6, r6, #1
	cmp	r6, #4
	bne	.L1411
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	cmp	r3, #2
	beq	.L1412
.L1416:
	ldrb	r2, [r4, #13]	@ zero_extendqisi2
	ldrb	r3, [r5]	@ zero_extendqisi2
	smulbb	r3, r3, r2
	ldrh	r2, [r4, #14]
	smulbb	r3, r3, r2
	ldr	r2, .L1425+44
	strh	r3, [r2]	@ movhi
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1412:
	ldrh	r6, [r7]
	movs	r7, #0
	ldrb	r3, [r4, #13]	@ zero_extendqisi2
	ldrb	r10, [r4]	@ zero_extendqisi2
	ldrb	fp, [r4, #23]	@ zero_extendqisi2
	muls	r3, r6, r3
	ldrh	r6, [r4, #14]
	and	r6, r6, #65280
	muls	r6, r3, r6
	lsls	r3, r6, #1
	str	r3, [sp]
	ldr	r3, .L1425+28
.L1415:
	mov	r2, r10
	add	r1, r8, r7, lsl #3
	ldr	r0, .L1425+40
	str	r3, [sp, #4]
	bl	flash_mem_cmp8
	ldr	r3, [sp, #4]
	cbnz	r0, .L1413
	ldr	r1, [sp]
	ldrb	r2, [r5]	@ zero_extendqisi2
	ldr	r0, .L1425+32
	cmp	fp, #0
	it	eq
	moveq	r1, r6
	strb	r7, [r3, r2]
	str	r1, [r0, r2, lsl #2]
	adds	r1, r2, #1
	strb	r1, [r5]
.L1413:
	adds	r7, r7, #1
	cmp	r7, #4
	bne	.L1415
	b	.L1416
.L1426:
	.align	2
.L1425:
	.word	.LANCHOR14
	.word	.LANCHOR141
	.word	.LC1
	.word	.LANCHOR32
	.word	.LANCHOR18
	.word	.LANCHOR2
	.word	.LANCHOR142
	.word	.LANCHOR30
	.word	.LANCHOR143
	.word	.LANCHOR33
	.word	.LANCHOR32+1
	.word	.LANCHOR144
	.word	.LANCHOR44
	.size	flash_die_info_init, .-flash_die_info_init
	.section	.text.lpa_hash_init,"ax",%progbits
	.align	1
	.global	lpa_hash_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	lpa_hash_init, %function
lpa_hash_init:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	mov	r2, #512
	movs	r1, #255
	ldr	r0, .L1428
	bl	ftl_memset
	ldr	r3, .L1428+4
	movs	r1, #255
	ldr	r2, .L1428+8
	ldrh	r3, [r3]
	ldrb	r2, [r2]	@ zero_extendqisi2
	muls	r2, r3, r2
	ldr	r3, .L1428+12
	ldr	r0, [r3]
	lsls	r2, r2, #2
	pop	{r3, lr}
	b	ftl_memset
.L1429:
	.align	2
.L1428:
	.word	.LANCHOR110
	.word	.LANCHOR87
	.word	.LANCHOR80
	.word	.LANCHOR112
	.size	lpa_hash_init, .-lpa_hash_init
	.section	.text.lpa_rebuild_hash,"ax",%progbits
	.align	1
	.global	lpa_rebuild_hash
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	lpa_rebuild_hash, %function
lpa_rebuild_hash:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	ldr	r3, .L1441
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L1431
	movs	r3, #0
	movs	r2, #225
	ldr	r1, .L1441+4
	ldr	r0, .L1441+8
	bl	printf
.L1431:
	ldr	r6, .L1441+12
	mov	r2, #512
	ldr	r4, .L1441+16
	movs	r1, #255
	ldr	r0, .L1441+20
	bl	ftl_memset
	ldrh	r3, [r4]
	movs	r1, #255
	ldrb	r2, [r6]	@ zero_extendqisi2
	ldr	r5, .L1441+24
	muls	r2, r3, r2
	ldr	r0, [r5]
	lsls	r2, r2, #2
	bl	ftl_memset
	ldr	r3, .L1441+28
	movs	r2, #0
	ldrb	r6, [r6]	@ zero_extendqisi2
	ldr	ip, [r5]
	ldr	r7, [r3]
	ldr	r0, .L1441+20
.L1432:
	ldrh	r3, [r4]
	uxth	r5, r2
	mov	r1, r5
	muls	r3, r6, r3
	cmp	r5, r3, lsl #1
	blt	.L1434
	pop	{r3, r4, r5, r6, r7, pc}
.L1434:
	ldr	r3, [r7, r1, lsl #2]
	adds	r2, r2, #1
	cmp	r3, #-1
	itttt	ne
	uxtbne	r3, r3
	ldrhne	lr, [r0, r3, lsl #1]
	strhne	r5, [r0, r3, lsl #1]	@ movhi
	strhne	lr, [ip, r1, lsl #1]	@ movhi
	b	.L1432
.L1442:
	.align	2
.L1441:
	.word	.LANCHOR14
	.word	.LANCHOR145
	.word	.LC79
	.word	.LANCHOR80
	.word	.LANCHOR87
	.word	.LANCHOR110
	.word	.LANCHOR112
	.word	.LANCHOR111
	.size	lpa_rebuild_hash, .-lpa_rebuild_hash
	.section	.text.zftl_read_flash_info,"ax",%progbits
	.align	1
	.global	zftl_read_flash_info
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	zftl_read_flash_info, %function
zftl_read_flash_info:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	movs	r2, #11
	movs	r1, #0
	mov	r4, r0
	bl	ftl_memset
	ldr	r1, .L1446
	movs	r2, #0
	ldr	r3, .L1446+4
	strb	r2, [r4, #10]
	ldrb	r0, [r1, #9]	@ zero_extendqisi2
	ldrh	r3, [r3]
	smulbb	r3, r3, r0
	uxth	r3, r3
	strb	r3, [r4, #4]
	lsrs	r3, r3, #8
	strb	r3, [r4, #5]
	ldr	r3, .L1446+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	strb	r3, [r4, #7]
	ldr	r3, .L1446+12
	ldrb	r5, [r3]	@ zero_extendqisi2
	strb	r5, [r4]
	ldrb	r5, [r3, #1]	@ zero_extendqisi2
	strb	r5, [r4, #1]
	ldrb	r5, [r3, #2]	@ zero_extendqisi2
	ldrb	r3, [r3, #3]	@ zero_extendqisi2
	strb	r0, [r4, #6]
	strb	r5, [r4, #2]
	movs	r5, #1
	strb	r3, [r4, #3]
	movs	r3, #32
	strb	r3, [r4, #8]
	ldrb	r3, [r1, #7]	@ zero_extendqisi2
	ldr	r0, .L1446+16
	strb	r3, [r4, #9]
	ldr	r3, .L1446+20
	ldrb	r1, [r3]	@ zero_extendqisi2
	mov	r3, r2
.L1444:
	uxtb	r2, r3
	cmp	r1, r2
	bhi	.L1445
	pop	{r4, r5, r6, pc}
.L1445:
	ldrb	r2, [r3, r0]	@ zero_extendqisi2
	adds	r3, r3, #1
	ldrb	r6, [r4, #10]	@ zero_extendqisi2
	lsl	r2, r5, r2
	orrs	r2, r2, r6
	strb	r2, [r4, #10]
	b	.L1444
.L1447:
	.align	2
.L1446:
	.word	.LANCHOR32
	.word	.LANCHOR2
	.word	.LANCHOR46
	.word	.LANCHOR61
	.word	.LANCHOR30
	.word	.LANCHOR18
	.size	zftl_read_flash_info, .-zftl_read_flash_info
	.section	.text.gc_static_wearleveling,"ax",%progbits
	.align	1
	.global	gc_static_wearleveling
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	gc_static_wearleveling, %function
gc_static_wearleveling:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r0, .L1565
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #40
	ldr	r3, [r0]
	ldr	r3, [r3, #32]
	cmp	r3, #10240
	bls	.L1449
	bl	ftl_tmp_into_update
.L1449:
	ldr	r3, .L1565+4
	ldr	r3, [r3]
	ldr	r2, [r3, #568]
	ldr	r1, [r3, #12]
	add	r2, r2, #860160
	add	r2, r2, #3840
	cmp	r1, r2
	bhi	.L1450
	ldr	r4, [r0]
	ldr	r2, [r3, #572]
	ldr	r4, [r4, #36]
	adds	r2, r2, #32
	cmp	r4, r2
	bls	.L1502
.L1450:
	ldr	r2, [r0]
	movs	r5, #0
	movw	r4, #65535
	mov	r8, r5
	mov	fp, r4
	str	r5, [sp, #20]
	ldrh	r6, [r2, #134]
	ldr	r0, [r2, #36]
	str	r5, [sp, #32]
	str	r1, [r3, #568]
	str	r0, [r3, #572]
	str	r5, [sp, #36]
	str	r5, [sp, #28]
	str	r5, [sp, #24]
	str	r5, [sp, #16]
.L1452:
	ldr	r3, .L1565+8
	ldrh	r3, [r3]
	cmp	r3, r6
	bhi	.L1463
	ldr	r6, .L1565+4
	movs	r3, #0
	movs	r2, #128
	movs	r1, #255
	ldr	r0, [r6]
	strh	r3, [r0, #122]	@ movhi
	add	r0, r0, #264
	bl	ftl_memset
	ldr	r3, [r6]
	ldrh	r1, [r3, #586]
	ldr	r3, .L1565+12
	ldr	r2, [r3]
	ldr	r3, .L1565+16
	ldr	r3, [r3]
	add	r6, r2, r1, lsl #2
	lsls	r0, r3, #21
	bpl	.L1464
	ldr	r0, .L1565+20
	ldr	r3, [r2, r1, lsl #2]
	ldrh	r2, [r2, r1, lsl #2]
	ldr	r0, [r0]
	ubfx	r3, r3, #11, #8
	ubfx	r2, r2, #0, #11
	ldrh	r0, [r0, r1, lsl #1]
	str	r0, [sp, #12]
	ldrb	r0, [r6, #3]	@ zero_extendqisi2
	str	r0, [sp, #8]
	ldrb	r0, [r6, #2]	@ zero_extendqisi2
	lsrs	r0, r0, #5
	str	r0, [sp, #4]
	ldrb	r0, [r6, #2]	@ zero_extendqisi2
	ubfx	r0, r0, #3, #2
	str	r0, [sp]
	ldr	r0, .L1565+24
	bl	printf
.L1464:
	ldrb	r3, [r6, #2]	@ zero_extendqisi2
	and	r2, r3, #224
	cmp	r2, #32
	bne	.L1465
	ldr	r1, .L1565
	ldr	r1, [r1]
	ldrh	r1, [r1, #688]
	cmp	r1, #2
	ittt	hi
	ldrhi	r1, .L1565+28
	movhi	r0, #1
	strhi	r0, [r1]
.L1465:
	lsls	r1, r3, #28
	bpl	.L1466
	and	r3, r3, #192
	ldr	r6, .L1565+4
	cmp	r3, #64
	bne	.L1467
	ldr	r3, [r6]
	movs	r2, #1
	movs	r1, #0
	ldrh	r0, [r3, #586]
	bl	gc_add_sblk
	ldr	r3, .L1565+32
	movs	r2, #1
	strh	r2, [r3, #570]	@ movhi
.L1466:
	ldr	r3, .L1565+4
	ldr	r3, [r3]
	ldrh	r1, [r3, #584]
	ldr	r3, .L1565+12
	ldr	r2, [r3]
	ldr	r3, .L1565+16
	ldr	r3, [r3]
	add	r6, r2, r1, lsl #2
	lsls	r7, r3, #21
	bpl	.L1468
	ldr	r0, .L1565+20
	ldr	r3, [r2, r1, lsl #2]
	ldrh	r2, [r2, r1, lsl #2]
	ldr	r0, [r0]
	ubfx	r3, r3, #11, #8
	ubfx	r2, r2, #0, #11
	ldrh	r0, [r0, r1, lsl #1]
	str	r0, [sp, #12]
	ldrb	r0, [r6, #3]	@ zero_extendqisi2
	str	r0, [sp, #8]
	ldrb	r0, [r6, #2]	@ zero_extendqisi2
	lsrs	r0, r0, #5
	str	r0, [sp, #4]
	ldrb	r0, [r6, #2]	@ zero_extendqisi2
	ubfx	r0, r0, #3, #2
	str	r0, [sp]
	ldr	r0, .L1565+36
	bl	printf
.L1468:
	ldrb	r3, [r6, #2]	@ zero_extendqisi2
	lsls	r0, r3, #28
	bpl	.L1469
	and	r2, r3, #192
	cmp	r2, #64
	bne	.L1470
	ldr	r3, .L1565+4
	movs	r2, #1
	movs	r1, #0
	ldr	r3, [r3]
	ldrh	r0, [r3, #584]
	bl	gc_add_sblk
	ldr	r3, .L1565+32
	movs	r2, #1
	strh	r2, [r3, #570]	@ movhi
.L1469:
	ldr	r3, .L1565+16
	ldr	r3, [r3]
	lsls	r1, r3, #21
	bpl	.L1471
	ldr	r3, .L1565+12
	ldr	r0, .L1565+20
	ldr	r2, [r3]
	ldr	r0, [r0]
	ldr	r3, [r2, r5, lsl #2]
	ldrh	r0, [r0, r5, lsl #1]
	add	r1, r2, r5, lsl #2
	ldrh	r2, [r2, r5, lsl #2]
	ubfx	r3, r3, #11, #8
	str	r0, [sp, #12]
	ldrb	r0, [r1, #3]	@ zero_extendqisi2
	ubfx	r2, r2, #0, #11
	str	r0, [sp, #8]
	ldrb	r0, [r1, #2]	@ zero_extendqisi2
	lsrs	r0, r0, #5
	str	r0, [sp, #4]
	ldrb	r1, [r1, #2]	@ zero_extendqisi2
	ldr	r0, .L1565+40
	ubfx	r1, r1, #3, #2
	str	r1, [sp]
	mov	r1, r5
	bl	printf
.L1471:
	ldr	r3, .L1565+16
	ldr	r3, [r3]
	lsls	r2, r3, #21
	bpl	.L1472
	ldr	r3, .L1565+12
	ldr	r0, [sp, #20]
	ldr	r5, [sp, #20]
	ldr	r2, [r3]
	ldr	r3, [sp, #20]
	add	r1, r2, r3, lsl #2
	ldr	r3, [r2, r3, lsl #2]
	ldrh	r2, [r2, r0, lsl #2]
	ldr	r0, .L1565+20
	ubfx	r3, r3, #11, #8
	ubfx	r2, r2, #0, #11
	ldr	r0, [r0]
	ldrh	r0, [r0, r5, lsl #1]
	str	r0, [sp, #12]
	ldrb	r0, [r1, #3]	@ zero_extendqisi2
	str	r0, [sp, #8]
	ldrb	r0, [r1, #2]	@ zero_extendqisi2
	lsrs	r0, r0, #5
	str	r0, [sp, #4]
	ldrb	r1, [r1, #2]	@ zero_extendqisi2
	ldr	r0, .L1565+44
	ubfx	r1, r1, #3, #2
	str	r1, [sp]
	mov	r1, r5
	bl	printf
.L1472:
	ldr	r6, .L1565
	ldrh	r3, [sp, #16]
	ldr	r1, [sp, #24]
	ldr	r5, [r6]
	ldr	r0, [sp, #32]
	strh	r3, [r5, #96]	@ movhi
	strh	r8, [r5, #98]	@ movhi
	strh	r4, [r5, #92]	@ movhi
	strh	fp, [r5, #94]	@ movhi
	bl	__aeabi_uidiv
	ldr	r1, [sp, #28]
	mov	r7, r0
	strh	r0, [r5, #88]	@ movhi
	ldr	r0, [sp, #36]
	bl	__aeabi_uidiv
	strh	r0, [r5, #90]	@ movhi
	ldr	r5, .L1565+16
	ldr	r3, [r5]
	lsls	r3, r3, #21
	bpl	.L1473
	uxth	r0, r0
	uxth	r3, r7
	ldr	r2, [sp, #28]
	str	r0, [sp]
	ldr	r1, [sp, #24]
	ldr	r0, .L1565+48
	bl	printf
.L1473:
	ldr	r3, [r5]
	ldr	r5, .L1565+52
	tst	r3, #1024
	beq	.L1474
	ldrh	r3, [r5]
	mov	r2, fp
	mov	r1, r4
	ldr	r0, .L1565+56
	str	r3, [sp, #8]
	ldr	r3, .L1565+60
	ldrh	r3, [r3]
	str	r8, [sp]
	str	r3, [sp, #4]
	ldr	r3, [sp, #16]
	bl	printf
.L1474:
	sub	r3, r8, fp
	str	r3, [sp, #20]
	ldr	r2, [sp, #20]
	ldrh	r3, [r5]
	cmp	r2, r3
	bgt	.L1475
	ldr	r2, .L1565+60
	ldr	r3, [sp, #16]
	ldrh	r2, [r2]
	subs	r3, r3, r4
	cmp	r3, r2
	ble	.L1503
.L1475:
	ldr	r3, .L1565+4
	mov	r8, #0
	mov	r7, r8
	ldr	r3, [r3]
	ldrh	r5, [r3, #580]
	ldr	r3, [r6]
	ldrh	r10, [r3, #134]
.L1477:
	ldr	r3, .L1565+8
	ldrh	r3, [r3]
	cmp	r10, r3
	bcc	.L1487
.L1486:
	ldr	r3, .L1565+4
	ldr	r3, [r3]
	str	r5, [r3, #580]
	b	.L1566
.L1567:
	.align	2
.L1565:
	.word	.LANCHOR104
	.word	.LANCHOR10
	.word	.LANCHOR6
	.word	.LANCHOR7
	.word	.LANCHOR14
	.word	.LANCHOR9
	.word	.LC81
	.word	.LANCHOR146
	.word	.LANCHOR64
	.word	.LC82
	.word	.LC83
	.word	.LC84
	.word	.LC85
	.word	.LANCHOR147
	.word	.LC86
	.word	.LANCHOR148
.L1566:
.L1476:
	cmp	fp, #0
	beq	.L1489
	ldr	r3, .L1568
	ldr	r1, [r3]
	ldr	r3, .L1568+4
	ldrh	r2, [r1, #134]
	ldrh	r6, [r3]
	ldr	r3, .L1568+8
	ldr	r3, [r3]
	add	r3, r3, r2, lsl #2
.L1490:
	cmp	r2, r6
	bcc	.L1492
	ldrh	r3, [r1, #72]
	add	r3, r3, fp
	strh	r3, [r1, #72]	@ movhi
	ldrh	r3, [r1, #98]
	cmp	fp, r3
	itt	cc
	subcc	r3, r3, fp
	strhcc	r3, [r1, #98]	@ movhi
.L1489:
	cbz	r4, .L1495
	ldr	r3, .L1568
	ldr	r1, [r3]
	ldr	r3, .L1568+4
	ldrh	r2, [r1, #134]
	ldrh	ip, [r3]
	ldr	r3, .L1568+8
	ldr	r3, [r3]
	add	r3, r3, r2, lsl #2
.L1496:
	cmp	r2, ip
	bcc	.L1498
	ldrh	r3, [r1, #74]
	add	r3, r3, r4
	strh	r3, [r1, #74]	@ movhi
	ldrh	r3, [r1, #96]
	cmp	r4, r3
	itt	cc
	subcc	r4, r3, r4
	strhcc	r4, [r1, #96]	@ movhi
.L1495:
	movs	r1, #5
	movs	r0, #0
	bl	zftl_get_gc_node
	movw	r2, #65535
	cmp	r0, r2
	beq	.L1451
	ldr	r2, .L1568+12
	ldr	r3, .L1568+16
	ldr	r2, [r2]
	ldrh	r3, [r3]
	ldrh	r2, [r2, r0, lsl #1]
	cmp	r2, r3
	bhi	.L1451
	adds	r7, r7, #1
	movs	r2, #1
	movs	r1, #0
	bl	gc_add_sblk
.L1451:
	add	r0, r7, r8
	add	sp, sp, #40
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1463:
	ldr	r3, .L1568+8
	lsls	r1, r6, #2
	ldr	r0, [r3]
	add	ip, r0, r1
	ldrb	r3, [ip, #2]	@ zero_extendqisi2
	and	r2, r3, #224
	cmp	r2, #224
	beq	.L1453
	ubfx	lr, r3, #3, #2
	tst	lr, #1
	beq	.L1454
	ldrh	r3, [r0, r1]
	ldr	r2, [r0, r1]
	ubfx	r3, r3, #0, #11
	ubfx	r2, r2, #11, #8
.L1455:
	ldr	r7, [sp, #24]
	cmp	r4, r3
	add	r10, r7, #1
	uxth	r7, r10
	str	r7, [sp, #24]
	ldr	r7, [sp, #32]
	add	r7, r7, r3
	str	r7, [sp, #32]
	bls	.L1501
	ldr	r4, .L1568+20
	ldr	r4, [r4]
	strh	r6, [r4, #586]	@ movhi
	mov	r4, r3
.L1501:
	ldr	r7, [sp, #16]
	movw	r10, #65535
	cmp	r7, r3
	itt	cc
	movcc	r5, r6
	strcc	r3, [sp, #16]
	cmp	r2, r10
	bne	.L1457
.L1459:
	cmp	r3, #9
	bls	.L1462
.L1453:
	adds	r6, r6, #1
	uxth	r6, r6
	b	.L1452
.L1454:
	tst	r3, #24
	bne	.L1456
	ldrh	r3, [r0, r1]
	movw	r2, #65535
	ubfx	r3, r3, #0, #11
	b	.L1455
.L1456:
	ldr	r3, [r0, r1]
	ubfx	r2, r3, #11, #8
	movw	r3, #65535
.L1457:
	ldr	r7, [sp, #28]
	cmp	fp, r2
	it	hi
	movhi	fp, r2
	add	r10, r7, #1
	uxth	r7, r10
	it	hi
	ldrhi	r10, .L1568+20
	str	r7, [sp, #28]
	it	hi
	ldrhi	r10, [r10]
	ldr	r7, [sp, #36]
	it	hi
	strhhi	r6, [r10, #584]	@ movhi
	cmp	r8, r2
	itt	cc
	strcc	r6, [sp, #20]
	movcc	r8, r2
	cmp	r2, #9
	add	r7, r7, r2
	str	r7, [sp, #36]
	bhi	.L1459
.L1462:
	ldr	r3, .L1568+24
	ldr	r3, [r3]
	lsls	r7, r3, #23
	bpl	.L1453
	ldr	r3, [r0, r1]
	ldrh	r2, [r0, r1]
	ldr	r1, .L1568+12
	ubfx	r3, r3, #11, #8
	ldr	r0, .L1568+28
	ubfx	r2, r2, #0, #11
	ldr	r1, [r1]
	ldrh	r1, [r1, r6, lsl #1]
	str	r1, [sp, #12]
	ldrb	r1, [ip, #3]	@ zero_extendqisi2
	str	r1, [sp, #8]
	ldrb	r1, [ip, #2]	@ zero_extendqisi2
	str	lr, [sp]
	lsrs	r1, r1, #5
	str	r1, [sp, #4]
	mov	r1, r6
	bl	printf
	b	.L1453
.L1467:
	cmp	r2, #0
	bne	.L1466
	ldr	r3, [r6]
	movw	r2, #65535
	ldrh	r10, [r3, #590]
	cmp	r10, r2
	bne	.L1466
	ldrh	r0, [r3, #586]
	ldrh	r3, [r3, #588]
	cmp	r3, r0
	beq	.L1466
	bl	zftl_remove_free_node
	ldr	r3, [r6]
	ldrh	r2, [r3, #586]
	strh	r10, [r3, #586]	@ movhi
	strh	r2, [r3, #590]	@ movhi
	b	.L1466
.L1470:
	and	r3, r3, #248
	cmp	r3, #16
	bne	.L1469
	ldr	r10, .L1568+20
	movw	r2, #65535
	ldr	r3, [r10]
	ldrh	r6, [r3, #588]
	cmp	r6, r2
	bne	.L1469
	ldrh	r0, [r3, #584]
	ldrh	r3, [r3, #590]
	cmp	r3, r0
	beq	.L1469
	bl	zftl_remove_free_node
	ldr	r3, [r10]
	ldrh	r2, [r3, #584]
	strh	r6, [r3, #584]	@ movhi
	strh	r2, [r3, #588]	@ movhi
	b	.L1469
.L1487:
	adds	r5, r5, #1
	uxth	r5, r5
	cmp	r3, r5
	it	ls
	movls	r5, #0
	ldr	r3, .L1568+8
	lsls	r6, r5, #2
	ldr	r3, [r3]
	adds	r2, r3, r6
	ldrb	r2, [r2, #2]	@ zero_extendqisi2
	tst	r2, #192
	beq	.L1479
	and	r0, r2, #224
	cmp	r0, #224
	beq	.L1479
	ubfx	r2, r2, #3, #2
	ands	r1, r2, #1
	beq	.L1480
	cmp	r0, #160
.L1563:
	bne	.L1482
	ldr	r2, .L1568+32
	ldr	r0, [sp, #20]
	ldrh	r2, [r2]
	cmp	r0, r2
	ble	.L1483
	ldr	r2, [r3, r6]
	ubfx	r2, r2, #11, #8
	cmp	r2, fp
	bls	.L1484
	cbz	r1, .L1483
	ldrh	r2, [r3, r6]
	ubfx	r2, r2, #0, #11
	cmp	r2, r4
	bgt	.L1483
.L1484:
	movs	r2, #1
	movs	r1, #0
	mov	r0, r5
	str	r3, [sp, #24]
	bl	gc_add_sblk
	ldr	r0, .L1568+36
	movs	r2, #1
	add	r7, r7, r2
	ldr	r3, [sp, #24]
	strh	r2, [r0, #570]	@ movhi
	ldr	r2, .L1568+24
	ldr	r2, [r2]
	tst	r2, #1024
	beq	.L1483
	ldr	r2, .L1568+12
	ldr	r1, [r3, r6]
	ldr	r2, [r2]
	ubfx	r1, r1, #11, #8
	ldrh	ip, [r2, r5, lsl #1]
	ldr	r2, .L1568+8
	ldr	r2, [r2]
	add	r2, r2, r6
	ldrb	r2, [r2, #2]	@ zero_extendqisi2
	str	r1, [sp, #8]
	ldrh	r1, [r3, r6]
	lsrs	r2, r2, #5
	ubfx	r1, r1, #0, #11
	str	r1, [sp, #4]
	mov	r1, r5
	ldrh	r3, [r0, #52]
	ldr	r0, .L1568+40
	str	r3, [sp]
	mov	r3, ip
.L1564:
	bl	printf
.L1483:
	cmp	r7, #4
	bhi	.L1486
	cmp	r8, #4
	bhi	.L1486
.L1479:
	add	r10, r10, #1
	uxth	r10, r10
	b	.L1477
.L1480:
	cmp	r2, #2
	b	.L1563
.L1569:
	.align	2
.L1568:
	.word	.LANCHOR104
	.word	.LANCHOR6
	.word	.LANCHOR7
	.word	.LANCHOR9
	.word	.LANCHOR87
	.word	.LANCHOR10
	.word	.LANCHOR14
	.word	.LC80
	.word	.LANCHOR147
	.word	.LANCHOR64
	.word	.LC87
.L1482:
	ldr	r0, .L1570
	ldr	r2, [sp, #16]
	ldrh	r0, [r0]
	subs	r2, r2, r4
	cmp	r2, r0
	ble	.L1483
	ldrh	r2, [r3, r6]
	add	r0, r4, #8
	ubfx	r2, r2, #0, #11
	cmp	r2, r0
	ble	.L1485
	cmp	r1, #0
	beq	.L1483
	ldr	r2, [r3, r6]
	add	r1, fp, #4
	ubfx	r2, r2, #11, #8
	cmp	r2, r1
	bgt	.L1483
.L1485:
	movs	r2, #1
	movs	r1, #0
	mov	r0, r5
	str	r3, [sp, #24]
	bl	gc_add_sblk
	ldr	r0, .L1570+4
	movs	r2, #1
	add	r8, r8, r2
	ldr	r3, [sp, #24]
	strh	r2, [r0, #570]	@ movhi
	ldr	r2, .L1570+8
	ldr	r2, [r2]
	tst	r2, #1024
	beq	.L1483
	ldr	r2, .L1570+12
	ldr	r1, [r3, r6]
	ldr	r2, [r2]
	ubfx	r1, r1, #11, #8
	ldrh	ip, [r2, r5, lsl #1]
	ldr	r2, .L1570+16
	ldr	r2, [r2]
	add	r2, r2, r6
	ldrb	r2, [r2, #2]	@ zero_extendqisi2
	str	r1, [sp, #8]
	ldrh	r1, [r3, r6]
	lsrs	r2, r2, #5
	ubfx	r1, r1, #0, #11
	str	r1, [sp, #4]
	mov	r1, r5
	ldrh	r3, [r0, #52]
	ldr	r0, .L1570+20
	str	r3, [sp]
	mov	r3, ip
	b	.L1564
.L1503:
	mov	r8, #0
	mov	r7, r8
	b	.L1476
.L1492:
	ldr	r0, [r3]
	ubfx	r5, r0, #11, #8
	cmp	fp, r5
	bhi	.L1491
	ldrb	ip, [r3, #2]	@ zero_extendqisi2
	tst	ip, #24
	ittt	ne
	subne	r5, r5, fp
	bfine	r0, r5, #11, #8
	strne	r0, [r3]
.L1491:
	adds	r2, r2, #1
	adds	r3, r3, #4
	uxth	r2, r2
	b	.L1490
.L1498:
	ldrh	r0, [r3]
	ubfx	r5, r0, #0, #11
	cmp	r5, r4
	blt	.L1497
	ldrb	r6, [r3, #2]	@ zero_extendqisi2
	and	r6, r6, #24
	cmp	r6, #16
	ittt	ne
	subne	r5, r5, r4
	bfine	r0, r5, #0, #11
	strhne	r0, [r3]	@ movhi
.L1497:
	adds	r2, r2, #1
	adds	r3, r3, #4
	uxth	r2, r2
	b	.L1496
.L1502:
	mov	r8, #0
	mov	r7, r8
	b	.L1451
.L1571:
	.align	2
.L1570:
	.word	.LANCHOR148
	.word	.LANCHOR64
	.word	.LANCHOR14
	.word	.LANCHOR9
	.word	.LANCHOR7
	.word	.LC88
	.size	gc_static_wearleveling, .-gc_static_wearleveling
	.section	.text.zftl_sblk_list_init,"ax",%progbits
	.align	1
	.global	zftl_sblk_list_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	zftl_sblk_list_init, %function
zftl_sblk_list_init:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r2, #6
	ldr	r8, .L1600+76
	sub	sp, sp, #24
	movs	r1, #0
	movs	r4, #0
	ldr	fp, .L1600+80
	ldrh	r3, [r8]
	ldr	r5, .L1600
	ldr	r0, [fp]
	ldr	r10, .L1600+64
	muls	r2, r3, r2
	ldr	r7, .L1600+4
	ldr	r6, .L1600+8
	bl	ftl_memset
	ldr	r3, .L1600+12
	movs	r2, #16
	ldr	r1, .L1600+16
	mov	r0, #32768
	strh	r4, [r10]	@ movhi
	str	r4, [r3]
	ldr	r3, .L1600+20
	ldrh	r1, [r1]
	strh	r4, [r7]	@ movhi
	str	r4, [r3]
	ldr	r3, .L1600+24
	strh	r4, [r6]	@ movhi
	str	r4, [r3]
	ldr	r3, .L1600+28
	str	r4, [r3]
	ldr	r3, .L1600+32
	str	r4, [r3]
	ldr	r3, .L1600+36
	str	r4, [r3]
	ldr	r3, .L1600+40
	strh	r2, [r3]	@ movhi
	ldr	r2, .L1600+44
	ldr	r3, .L1600+48
	strh	r4, [r2]	@ movhi
	ldr	r2, .L1600+52
	strh	r4, [r3]	@ movhi
	str	r3, [sp, #4]
	strh	r4, [r2]	@ movhi
	ldrb	r2, [r5]	@ zero_extendqisi2
	muls	r1, r2, r1
	bl	__aeabi_idiv
	ldr	r2, .L1600+56
	sxth	r3, r0
	str	fp, [sp, #12]
	mov	fp, r10
	str	r3, [sp]
	ldr	r1, [r2]
	ldr	r3, [sp, #4]
	ldr	r10, .L1600+84
	strh	r4, [r1, #146]	@ movhi
	ldrsh	r4, [r1, #134]
	str	r8, [sp, #8]
	mov	r8, r3
	str	r2, [sp, #16]
	str	r5, [sp, #20]
.L1573:
	ldr	r3, [sp, #8]
	ldrh	r3, [r3]
	cmp	r4, r3
	blt	.L1589
	ldr	r3, [sp, #16]
	ldrh	r2, [r8]
	ldr	r3, [r3]
	strh	r2, [r3, #114]	@ movhi
	ldrh	r2, [r7]
	strh	r2, [r3, #118]	@ movhi
	ldrh	r2, [r6]
	strh	r2, [r3, #116]	@ movhi
	ldrh	r2, [fp]
	strh	r2, [r3, #122]	@ movhi
	ldr	r2, .L1600+44
	ldrh	r2, [r2]
	strh	r2, [r3, #120]	@ movhi
	ldr	r2, .L1600+52
	ldrh	r2, [r2]
	strh	r2, [r3, #124]	@ movhi
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1589:
	ldr	r5, [r10]
	add	r5, r5, r4, lsl #2
	ldrb	r0, [r5, #3]	@ zero_extendqisi2
	cmp	r0, #0
	beq	.L1590
	ldr	r3, [sp, #20]
	ldrb	lr, [r3]	@ zero_extendqisi2
	ldr	r3, .L1600+56
	ldr	ip, [r3]
	ldr	r3, .L1600+16
	ldrh	r3, [r3]
	str	r3, [sp, #4]
	movs	r3, #0
	mov	r1, r3
.L1575:
	cmp	r3, lr
	blt	.L1578
	cmp	r1, #0
	beq	.L1579
	mov	r0, #32768
	bl	__aeabi_idiv
	adds	r1, r0, #1
	sxth	r1, r1
.L1574:
	ldr	r3, [sp, #12]
	lsls	r0, r4, #1
	adds	r2, r0, r4
	ldr	r3, [r3]
	add	ip, r3, r2, lsl #1
	strh	r1, [ip, #4]	@ movhi
	movw	r1, #65535
	strh	r1, [ip, #2]	@ movhi
	strh	r1, [r3, r2, lsl #1]	@ movhi
	ldrb	r1, [r5, #2]	@ zero_extendqisi2
	and	r3, r1, #224
	cmp	r3, #32
	beq	.L1580
	cmp	r3, #224
	beq	.L1580
	ldr	r2, .L1600+60
	ldr	r2, [r2]
	ldrh	ip, [r2, #16]
	cmp	r4, ip
	beq	.L1580
	ldrh	ip, [r2, #48]
	cmp	r4, ip
	beq	.L1580
	ldrh	r2, [r2, #80]
	cmp	r4, r2
	beq	.L1580
	cmp	r3, #64
	bne	.L1581
	ldr	r2, .L1600+64
	uxth	r1, r4
	ldr	r0, .L1600+32
.L1598:
	bl	_insert_data_list
.L1580:
	adds	r4, r4, #1
	sxth	r4, r4
	b	.L1573
.L1578:
	asr	r2, r0, r3
	adds	r3, r3, #1
	lsls	r2, r2, #31
	itete	mi
	ldrhmi	r2, [ip, #146]
	ldrpl	r2, [sp, #4]
	addmi	r2, r2, #1
	addpl	r1, r1, r2
	ite	mi
	strhmi	r2, [ip, #146]	@ movhi
	sxthpl	r1, r1
	b	.L1575
.L1579:
	ldrb	r3, [r5, #2]	@ zero_extendqisi2
	movw	r2, #65535
	orr	r3, r3, #224
	strb	r3, [r5, #2]
	ldr	r3, .L1600+68
	ldr	r3, [r3]
	strh	r2, [r3, r4, lsl #1]	@ movhi
	b	.L1574
.L1590:
	ldr	r1, [sp]
	b	.L1574
.L1581:
	cmp	r3, #96
	bne	.L1582
	ldr	r2, .L1600+52
	uxth	r1, r4
	ldr	r0, .L1600+28
	b	.L1598
.L1582:
	cmp	r3, #160
	bne	.L1583
	ldr	r2, .L1600+44
	uxth	r1, r4
	ldr	r0, .L1600+36
	b	.L1598
.L1583:
	cmp	r3, #0
	bne	.L1580
	ldr	r3, .L1600+68
	ldr	r3, [r3]
	ldrh	r2, [r3, r0]
	cbz	r2, .L1584
	mov	r1, r4
	ldr	r0, .L1600+72
	bl	printf
	ldrb	r3, [r5, #2]	@ zero_extendqisi2
	movs	r1, #1
	uxth	r0, r4
	lsls	r2, r3, #27
	ite	mi
	movmi	r2, #5
	movpl	r2, #2
	bfi	r3, r2, #5, #3
	movs	r2, #0
	strb	r3, [r5, #2]
	bl	gc_add_sblk
	b	.L1580
.L1584:
	ands	r3, r1, #24
	uxth	r1, r4
	bne	.L1587
	ldr	r2, .L1600+48
	ldr	r0, .L1600+12
.L1599:
	bl	_insert_free_list
	b	.L1580
.L1587:
	cmp	r3, #16
	ittee	eq
	ldreq	r2, .L1600+4
	ldreq	r0, .L1600+20
	ldrne	r2, .L1600+8
	ldrne	r0, .L1600+24
	b	.L1599
.L1601:
	.align	2
.L1600:
	.word	.LANCHOR80
	.word	.LANCHOR99
	.word	.LANCHOR101
	.word	.LANCHOR98
	.word	.LANCHOR79
	.word	.LANCHOR100
	.word	.LANCHOR102
	.word	.LANCHOR83
	.word	.LANCHOR12
	.word	.LANCHOR82
	.word	.LANCHOR103
	.word	.LANCHOR94
	.word	.LANCHOR97
	.word	.LANCHOR90
	.word	.LANCHOR104
	.word	.LANCHOR10
	.word	.LANCHOR92
	.word	.LANCHOR9
	.word	.LC89
	.word	.LANCHOR6
	.word	.LANCHOR4
	.word	.LANCHOR7
	.size	zftl_sblk_list_init, .-zftl_sblk_list_init
	.section	.text.pm_free_sblk,"ax",%progbits
	.align	1
	.global	pm_free_sblk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	pm_free_sblk, %function
pm_free_sblk:
	@ args = 0, pretend = 0, frame = 272
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #280
	ldr	r5, .L1627
	ldrh	r2, [r5]
	cmp	r2, #128
	bls	.L1603
	movs	r2, #84
	ldr	r1, .L1627+4
	ldr	r0, .L1627+8
	bl	printf
.L1603:
	ldr	r4, .L1627+12
	movs	r2, #0
	ldrh	r5, [r5]
	mov	r3, r2
	movw	r6, #65535
	ldr	r1, [r4]
	ldrh	r0, [r1, #688]
	add	r1, r1, #416
.L1606:
	ldrh	r7, [r1], #2
	cmp	r7, r6
	itt	ne
	addne	r2, r2, #1
	uxthne	r2, r2
	cmp	r2, r0
	bcs	.L1605
	cmp	r2, r5
	bcs	.L1605
	adds	r3, r3, #1
	uxth	r3, r3
	cmp	r3, #128
	bne	.L1606
.L1605:
	adds	r3, r3, #1
	mov	r2, #256
	uxth	r3, r3
	movs	r1, #0
	add	r0, sp, #24
	cmp	r3, #129
	mov	r5, #1
	it	eq
	moveq	r3, #128
	movs	r6, #0
	str	r3, [sp, #8]
	add	fp, sp, #24
	bl	ftl_memset
	ldr	r2, .L1627+16
	ldr	r7, [r4]
	ldrh	r8, [r2]
	ldr	r2, .L1627+20
	add	r10, r7, #704
	ldrh	r3, [r7, #698]
	ldrb	r2, [r2]	@ zero_extendqisi2
	rsb	r2, r2, #24
	sub	r2, r2, r8
	lsls	r5, r5, r2
	ldr	r2, .L1627+24
	subs	r5, r5, #1
	ldrb	r2, [r2]	@ zero_extendqisi2
.L1608:
	uxth	r1, r6
	cmp	r3, r1
	bhi	.L1611
	ldr	r3, .L1627+28
	movs	r5, #0
	ldr	r2, .L1627+32
	movw	r10, #65535
	mov	r8, r5
	ldrb	r6, [r3]	@ zero_extendqisi2
	ldrh	r2, [r2]
	str	r3, [sp, #12]
	smulbb	r6, r6, r2
	uxth	r6, r6
.L1617:
	ldr	r2, [r4]
	add	r7, r5, #208
	uxth	fp, r5
	ldrh	r3, [r2, r7, lsl #1]
	ldrh	r0, [r2, #692]
	str	r2, [sp, #16]
	str	r3, [sp, #20]
	ldr	r3, .L1627+24
	ldrb	r1, [r3]	@ zero_extendqisi2
	bl	__aeabi_idiv
	ldr	r3, [sp, #20]
	ldr	r2, [sp, #16]
	cmp	r0, r3
	bne	.L1612
	ldr	r1, [sp, #12]
	ldr	r0, .L1627+32
	ldrb	r1, [r1]	@ zero_extendqisi2
	ldrh	r0, [r0]
	smulbb	r1, r1, r0
	add	r0, sp, #24
	strh	r1, [r0, r5, lsl #1]	@ movhi
.L1612:
	add	r1, sp, #24
	ldrh	r1, [r1, r5, lsl #1]
	cmp	r1, r6
	bcs	.L1613
	cmp	r1, #0
	itt	ne
	movne	r8, fp
	movne	r6, r1
.L1613:
	ldrh	r0, [r2, #74]
	cmp	r0, #2
	bls	.L1614
	movw	r0, #65535
	cmp	r3, r0
	beq	.L1614
	ldr	r0, .L1627+36
	ldrh	r2, [r2, #92]
	ldr	r0, [r0]
	adds	r2, r2, #4
	ldrh	r0, [r0, r3, lsl #2]
	ubfx	r0, r0, #0, #11
	cmp	r0, r2
	bgt	.L1614
	mov	r10, fp
	str	r0, [sp]
	mov	r2, r1
	ldr	r0, .L1627+40
	mov	r1, r5
	bl	printf
.L1614:
	add	r3, sp, #24
	ldrh	r2, [r3, r5, lsl #1]
	cbnz	r2, .L1615
	ldr	r1, [r4]
	movw	r0, #65535
	ldrh	r3, [r1, r7, lsl #1]
	cmp	r3, r0
	beq	.L1615
	ldr	r0, .L1627+44
	ldr	r0, [r0]
	lsls	r0, r0, #19
	bpl	.L1616
	ldrh	r1, [r1, #688]
	ldr	r0, .L1627+48
	str	r1, [sp]
	mov	r1, r5
	bl	printf
.L1616:
	ldr	r3, [r4]
	ldrh	r0, [r3, r7, lsl #1]
	bl	ftl_free_sblk
	ldr	r3, [r4]
	movw	r2, #65535
	strh	r2, [r3, r7, lsl #1]	@ movhi
	ldrh	r2, [r3, #688]
	subs	r2, r2, #1
	strh	r2, [r3, #688]	@ movhi
.L1615:
	adds	r5, r5, #1
	ldr	r2, [sp, #8]
	uxth	r3, r5
	cmp	r3, r2
	bcc	.L1617
	movw	r0, #65535
	cmp	r10, r0
	ite	ne
	movne	r0, r10
	moveq	r0, r8
	add	sp, sp, #280
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1611:
	ldr	r0, [r10], #4
	mov	r1, r2
	str	r3, [sp, #20]
	str	r2, [sp, #16]
	lsr	r0, r0, r8
	ands	r0, r0, r5
	bl	__aeabi_uidiv
	uxth	r3, r0
	ldr	r2, [sp, #16]
	add	lr, r7, #416
	str	r3, [sp, #12]
	movs	r1, #0
	ldr	r3, [sp, #20]
.L1610:
	ldrh	ip, [lr], #2
	ldr	r0, [sp, #12]
	cmp	r0, ip
	ldr	r0, [sp, #8]
	ittt	eq
	ldrheq	ip, [fp, r1, lsl #1]
	addeq	ip, ip, #1
	strheq	ip, [fp, r1, lsl #1]	@ movhi
	adds	r1, r1, #1
	uxth	ip, r1
	cmp	r0, ip
	bhi	.L1610
	adds	r6, r6, #1
	b	.L1608
.L1628:
	.align	2
.L1627:
	.word	.LANCHOR149
	.word	.LANCHOR150
	.word	.LC0
	.word	.LANCHOR104
	.word	.LANCHOR68
	.word	.LANCHOR31
	.word	.LANCHOR69
	.word	.LANCHOR80
	.word	.LANCHOR87
	.word	.LANCHOR7
	.word	.LC90
	.word	.LANCHOR14
	.word	.LC91
	.size	pm_free_sblk, .-pm_free_sblk
	.section	.text.ftl_memcpy,"ax",%progbits
	.align	1
	.global	ftl_memcpy
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_memcpy, %function
ftl_memcpy:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	b	memcpy
	.size	ftl_memcpy, .-ftl_memcpy
	.section	.text.flash_info_data_init,"ax",%progbits
	.align	1
	.global	flash_info_data_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_info_data_init, %function
flash_info_data_init:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1635
	push	{r4, lr}
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L1631
	ldr	r2, .L1635+4
	movs	r1, #105
	ldr	r0, .L1635+8
	bl	printf
.L1631:
	ldr	r4, .L1635+12
	mov	r2, #2048
	movs	r1, #0
	ldr	r0, [r4]
	bl	ftl_memset
	ldr	r0, [r4]
	movs	r2, #32
	ldr	r3, .L1635+16
	ldr	r1, .L1635+20
	adds	r0, r0, #80
	str	r3, [r0, #-80]
	mov	r3, #2032
	str	r3, [r0, #-72]
	movs	r3, #1
	strh	r3, [r0, #-64]	@ movhi
	bl	ftl_memcpy
	ldr	r0, [r4]
	movs	r2, #32
	ldr	r1, .L1635+24
	pop	{r4, lr}
	adds	r0, r0, #48
	b	ftl_memcpy
.L1636:
	.align	2
.L1635:
	.word	.LANCHOR14
	.word	.LANCHOR151
	.word	.LC92
	.word	.LANCHOR27
	.word	1398362953
	.word	.LANCHOR20
	.word	.LANCHOR32
	.size	flash_info_data_init, .-flash_info_data_init
	.section	.text.ftl_memcpy32,"ax",%progbits
	.align	1
	.global	ftl_memcpy32
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_memcpy32, %function
ftl_memcpy32:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	movs	r3, #0
	push	{r4, lr}
.L1638:
	cmp	r3, r2
	bne	.L1639
	pop	{r4, pc}
.L1639:
	ldr	r4, [r1, r3, lsl #2]
	str	r4, [r0, r3, lsl #2]
	adds	r3, r3, #1
	b	.L1638
	.size	ftl_memcpy32, .-ftl_memcpy32
	.section	.text.ftl_memcmp,"ax",%progbits
	.align	1
	.global	ftl_memcmp
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_memcmp, %function
ftl_memcmp:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	b	memcmp
	.size	ftl_memcmp, .-ftl_memcmp
	.section	.text.rknand_get_clk_rate,"ax",%progbits
	.align	1
	.global	rknand_get_clk_rate
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	rknand_get_clk_rate, %function
rknand_get_clk_rate:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r0, .L1642
	bx	lr
.L1643:
	.align	2
.L1642:
	.word	148000000
	.size	rknand_get_clk_rate, .-rknand_get_clk_rate
	.section	.text.ftl_malloc,"ax",%progbits
	.align	1
	.global	ftl_malloc
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_malloc, %function
ftl_malloc:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	movs	r1, #0
	b	kmalloc
	.size	ftl_malloc, .-ftl_malloc
	.section	.text.nandc_init,"ax",%progbits
	.align	1
	.global	nandc_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	nandc_init, %function
nandc_init:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}
	movs	r3, #0
	ldr	r6, .L1664
	sub	sp, sp, #20
	mov	r4, r0
	str	r3, [sp, #12]
	ldr	r3, [r6]
	lsls	r0, r3, #19
	bpl	.L1646
	mov	r2, r4
	ldr	r1, .L1664+4
	ldr	r0, .L1664+8
	bl	printf
.L1646:
	ldr	r1, [r4, #352]
	movs	r3, #6
	ldr	r2, .L1664+12
	ldr	r5, .L1664+16
	ldr	r7, .L1664+20
	cmp	r1, r2
	ldr	r2, [r4, #128]
	strb	r3, [r5]
	itt	eq
	moveq	r3, #8
	strbeq	r3, [r5]
	ldr	r3, .L1664+24
	str	r4, [r7]
	cmp	r2, r3
	ldr	r2, .L1664+28
	itt	eq
	moveq	r3, #9
	strbeq	r3, [r5]
	ldrb	r3, [r5]	@ zero_extendqisi2
	cmp	r3, #9
	ldr	r3, .L1664+32
	bne	.L1649
	movs	r1, #1
	strb	r1, [r3]
	movs	r1, #2
	ldr	r3, [sp, #12]
	orr	r3, r3, #256
	str	r3, [sp, #12]
	ldr	r3, [sp, #12]
	bfi	r3, r1, #18, #3
	str	r3, [sp, #12]
	ldr	r3, [sp, #12]
	str	r3, [r4]
	movs	r3, #0
	str	r3, [r4, #520]
	movw	r3, #4161
	str	r3, [r4, #4]
	movw	r3, #8321
	str	r3, [r4, #8]
	movs	r3, #38
	str	r2, [r4, #80]
	str	r3, [r4, #84]
	movs	r3, #39
	str	r3, [r4, #84]
	ldr	r3, [r6]
	lsls	r1, r3, #19
	bpl	.L1651
	ldr	r1, [r4]
	ldr	r2, [r4, #8]
	ldr	r3, [r4, #80]
	ldr	r0, [r4, #84]
	ldr	r4, [r4, #88]
	stm	sp, {r0, r4}
.L1663:
	ldr	r0, .L1664+36
	bl	printf
.L1651:
	ldr	r3, .L1664+40
	movs	r2, #1
	strb	r2, [r3]
	movs	r3, #0
	ldr	r2, .L1664+44
	strh	r3, [r2]	@ movhi
	ldr	r2, .L1664+48
	strb	r3, [r2]
	ldr	r3, [r6]
	lsls	r3, r3, #19
	bpl	.L1645
	ldrb	r1, [r5]	@ zero_extendqisi2
	ldr	r0, .L1664+52
	bl	printf
.L1645:
	add	sp, sp, #20
	@ sp needed
	pop	{r4, r5, r6, r7, pc}
.L1649:
	movs	r1, #0
	movs	r0, #1
	strb	r1, [r3]
	ldr	r3, [sp, #12]
	orr	r3, r3, #256
	str	r3, [sp, #12]
	ldr	r3, [sp, #12]
	bfi	r3, r0, #24, #3
	mov	r0, #2048
	str	r3, [sp, #12]
	ldr	r3, [sp, #12]
	str	r3, [r4]
	movw	r3, #4193
	str	r1, [r4, #336]
	str	r3, [r4, #4]
	movw	r3, #8321
	str	r3, [r4, #344]
	movs	r3, #38
	str	r2, [r4, #304]
	str	r3, [r4, #308]
	movs	r3, #39
	str	r3, [r4, #308]
	bl	ftl_malloc
	ldr	r3, .L1664+56
	str	r0, [r3]
	ldr	r3, [r6]
	lsls	r2, r3, #19
	bpl	.L1651
	ldr	r0, [r7]
	ldr	r1, [r0]
	ldr	r2, [r0, #344]
	ldr	r3, [r0, #304]
	ldr	r4, [r0, #308]
	ldr	r0, [r0, #312]
	str	r4, [sp]
	str	r0, [sp, #4]
	b	.L1663
.L1665:
	.align	2
.L1664:
	.word	.LANCHOR14
	.word	.LANCHOR152
	.word	.LC93
	.word	1446522928
	.word	.LANCHOR28
	.word	.LANCHOR13
	.word	1446588464
	.word	1052675
	.word	.LANCHOR47
	.word	.LC94
	.word	.LANCHOR48
	.word	.LANCHOR50
	.word	.LANCHOR46
	.word	.LC95
	.word	.LANCHOR49
	.size	nandc_init, .-nandc_init
	.section	.text.zbuf_init,"ax",%progbits
	.align	1
	.global	zbuf_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	zbuf_init, %function
zbuf_init:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, lr}
	movs	r5, #0
	ldr	r4, .L1669
	mov	r6, r5
	ldr	r8, .L1669+12
	mov	r7, r4
.L1667:
	ldrb	r0, [r8]	@ zero_extendqisi2
	uxtb	r3, r5
	strb	r6, [r4, #2]
	adds	r5, r5, #1
	adds	r2, r3, #1
	strb	r3, [r4, #1]
	strb	r2, [r4]
	adds	r4, r4, #48
	str	r6, [r4, #-40]
	lsls	r0, r0, #9
	bl	ftl_malloc
	str	r0, [r4, #-44]
	movs	r0, #64
	bl	ftl_malloc
	cmp	r5, #32
	str	r0, [r4, #-36]
	bne	.L1667
	movs	r3, #255
	strb	r3, [r7, #1488]
	ldr	r3, .L1669+4
	strb	r6, [r3]
	ldr	r3, .L1669+8
	strb	r5, [r3]
	pop	{r4, r5, r6, r7, r8, pc}
.L1670:
	.align	2
.L1669:
	.word	.LANCHOR52
	.word	.LANCHOR53
	.word	.LANCHOR54
	.word	.LANCHOR125
	.size	zbuf_init, .-zbuf_init
	.section	.text.gc_init,"ax",%progbits
	.align	1
	.global	gc_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	gc_init, %function
gc_init:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1672
	mov	r2, #596
	push	{r4, r5, r6, lr}
	movs	r4, #0
	ldr	r5, .L1672+4
	mov	r1, r4
	strb	r4, [r3]
	ldr	r3, .L1672+8
	mov	r0, r5
	strb	r4, [r3]
	ldr	r3, .L1672+12
	str	r4, [r3]
	ldr	r3, .L1672+16
	strh	r4, [r3]	@ movhi
	bl	ftl_memset
	movw	r3, #65535
	str	r4, [r5, #8]
	strh	r3, [r5]	@ movhi
	ldr	r3, .L1672+20
	ldrh	r3, [r3]
	lsrs	r2, r3, #1
	lsrs	r1, r3, #2
	strh	r2, [r5, #34]	@ movhi
	ldr	r2, .L1672+24
	strh	r1, [r5, #32]	@ movhi
	ldr	r5, .L1672+28
	strh	r4, [r2]	@ movhi
	ldr	r2, .L1672+32
	strh	r4, [r2]	@ movhi
	ldr	r2, .L1672+36
	strh	r4, [r2]	@ movhi
	ldr	r4, .L1672+40
	ldrb	r0, [r4]	@ zero_extendqisi2
	smulbb	r2, r0, r3
	uxth	r2, r2
	sub	r6, r2, #32
	strh	r6, [r5]	@ movhi
	ldr	r5, .L1672+44
	strh	r2, [r5]	@ movhi
	ldr	r2, .L1672+48
	ldr	r5, .L1672+52
	strh	r3, [r2]	@ movhi
	ldr	r3, .L1672+56
	strh	r1, [r3]	@ movhi
	ldrh	r3, [r5]
	muls	r0, r3, r0
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L1672+60
	str	r0, [r3]
	ldrh	r3, [r5]
	ldrb	r0, [r4]	@ zero_extendqisi2
	muls	r0, r3, r0
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L1672+64
	str	r0, [r3]
	ldrh	r3, [r5]
	ldrb	r0, [r4]	@ zero_extendqisi2
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L1672+68
	str	r0, [r3]
	ldrh	r3, [r5]
	ldrb	r0, [r4]	@ zero_extendqisi2
	muls	r0, r3, r0
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L1672+72
	str	r0, [r3]
	ldrh	r3, [r5]
	ldrb	r0, [r4]	@ zero_extendqisi2
	muls	r0, r3, r0
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L1672+76
	ldr	r2, .L1672+80
	str	r0, [r3]
	ldr	r3, .L1672+84
	ldrh	r3, [r3]
	lsrs	r3, r3, #2
	strh	r3, [r2]	@ movhi
	pop	{r4, r5, r6, pc}
.L1673:
	.align	2
.L1672:
	.word	.LANCHOR78
	.word	.LANCHOR64
	.word	.LANCHOR153
	.word	.LANCHOR154
	.word	.LANCHOR89
	.word	.LANCHOR87
	.word	.LANCHOR88
	.word	.LANCHOR96
	.word	.LANCHOR84
	.word	.LANCHOR85
	.word	.LANCHOR80
	.word	.LANCHOR93
	.word	.LANCHOR86
	.word	.LANCHOR79
	.word	.LANCHOR63
	.word	.LANCHOR155
	.word	.LANCHOR156
	.word	.LANCHOR76
	.word	.LANCHOR70
	.word	.LANCHOR157
	.word	.LANCHOR81
	.word	.LANCHOR91
	.size	gc_init, .-gc_init
	.section	.text.ftl_free,"ax",%progbits
	.align	1
	.global	ftl_free
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_free, %function
ftl_free:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	b	free
	.size	ftl_free, .-ftl_free
	.section	.text.js_hash,"ax",%progbits
	.align	1
	.global	js_hash
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	js_hash, %function
js_hash:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1678
	add	r1, r1, r0
	push	{r4, lr}
.L1676:
	cmp	r0, r1
	bne	.L1677
	mov	r0, r3
	pop	{r4, pc}
.L1677:
	lsrs	r2, r3, #2
	ldrb	r4, [r0], #1	@ zero_extendqisi2
	add	r2, r2, r3, lsl #5
	add	r2, r2, r4
	eors	r3, r3, r2
	b	.L1676
.L1679:
	.align	2
.L1678:
	.word	1204201446
	.size	js_hash, .-js_hash
	.section	.text.timer_get_time,"ax",%progbits
	.align	1
	.global	timer_get_time
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	timer_get_time, %function
timer_get_time:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	movs	r0, #0
	bx	lr
	.size	timer_get_time, .-timer_get_time
	.section	.text.FlashCs123Init,"ax",%progbits
	.align	1
	.global	FlashCs123Init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashCs123Init, %function
FlashCs123Init:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	bx	lr
	.size	FlashCs123Init, .-FlashCs123Init
	.section	.text.rk_nand_de_init,"ax",%progbits
	.align	1
	.global	rk_nand_de_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	rk_nand_de_init, %function
rk_nand_de_init:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	b	zftl_flash_de_init
	.size	rk_nand_de_init, .-rk_nand_de_init
	.section	.text.ftl_get_density,"ax",%progbits
	.align	1
	.global	ftl_get_density
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_get_density, %function
ftl_get_density:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	b	zftl_get_density
	.size	ftl_get_density, .-ftl_get_density
	.section	.text.ftl_get_capacity,"ax",%progbits
	.align	1
	.global	ftl_get_capacity
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_get_capacity, %function
ftl_get_capacity:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L1685
	ldr	r0, [r3]
	bx	lr
.L1686:
	.align	2
.L1685:
	.word	.LANCHOR61
	.size	ftl_get_capacity, .-ftl_get_capacity
	.section	.text.rknand_print_hex,"ax",%progbits
	.align	1
	.global	rknand_print_hex
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	rknand_print_hex, %function
rknand_print_hex:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r5, #0
	ldr	r7, .L1696
	mov	fp, r0
	mov	r6, r1
	mov	r8, r2
	mov	r10, r3
	mov	r4, r5
.L1688:
	cmp	r4, r10
	bne	.L1694
	ldr	r1, .L1696+4
	ldr	r0, .L1696+8
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	printf
.L1694:
	cbnz	r5, .L1689
	mov	r2, r4
	mov	r1, fp
	ldr	r0, .L1696+12
	bl	printf
.L1689:
	cmp	r8, #4
	bne	.L1690
	ldr	r1, [r6, r4, lsl #2]
.L1695:
	mov	r0, r7
	adds	r5, r5, #1
	bl	printf
	cmp	r5, #15
	bls	.L1693
	movs	r5, #0
	ldr	r1, .L1696+4
	ldr	r0, .L1696+8
	bl	printf
.L1693:
	adds	r4, r4, #1
	b	.L1688
.L1690:
	cmp	r8, #2
	ite	eq
	ldrsheq	r1, [r6, r4, lsl #1]
	ldrbne	r1, [r6, r4]	@ zero_extendqisi2
	b	.L1695
.L1697:
	.align	2
.L1696:
	.word	.LC97
	.word	.LC98
	.word	.LC99
	.word	.LC96
	.size	rknand_print_hex, .-rknand_print_hex
	.section	.text.hynix_get_read_retry_default,"ax",%progbits
	.align	1
	.global	hynix_get_read_retry_default
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	hynix_get_read_retry_default, %function
hynix_get_read_retry_default:
	@ args = 0, pretend = 0, frame = 56
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1809
	cmp	r0, #2
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #56
	mov	r1, #173
	mov	r2, #174
	mov	r4, r0
	ldr	fp, [r3]
	add	r3, fp, #128
	strb	r0, [fp, #112]
	str	r3, [sp]
	mov	r3, #172
	strb	r3, [fp, #128]
	mov	r3, #175
	strb	r1, [fp, #129]
	strb	r2, [fp, #130]
	strb	r3, [fp, #131]
	bne	.L1699
	movs	r3, #167
	mov	r8, #7
	strb	r3, [fp, #128]
	movs	r2, #247
	ldr	r3, .L1809+4
	strb	r2, [r3, #17]
.L1803:
	mov	r10, #4
	b	.L1700
.L1699:
	cmp	r0, #3
	bne	.L1701
	add	r2, fp, #127
	movs	r3, #176
.L1702:
	strb	r3, [r2, #1]!
	adds	r3, r3, #1
	uxtb	r3, r3
	cmp	r3, #184
	bne	.L1702
.L1804:
	mov	r8, #8
	mov	r10, r8
.L1700:
	subs	r3, r4, #1
	cmp	r3, #1
	bhi	.L1708
	movs	r5, #0
.L1709:
	ldr	r3, .L1809+8
	ldrb	r2, [r3]	@ zero_extendqisi2
	uxtb	r3, r5
	cmp	r2, r3
	bhi	.L1714
.L1715:
	strb	r10, [fp, #113]
	strb	r8, [fp, #114]
	add	sp, sp, #56
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1701:
	cmp	r0, #4
	bne	.L1703
	movs	r0, #204
	strb	r1, [fp, #133]
	strb	r0, [fp, #128]
	movs	r0, #191
	strb	r0, [fp, #129]
	movs	r0, #170
	strb	r0, [fp, #130]
	movs	r0, #171
	strb	r0, [fp, #131]
	movs	r0, #205
	strb	r0, [fp, #132]
	strb	r2, [fp, #134]
	strb	r3, [fp, #135]
	b	.L1804
.L1703:
	cmp	r0, #5
	bne	.L1704
	movs	r3, #56
	mov	r8, #8
	strb	r3, [fp, #128]
	movs	r3, #57
	strb	r3, [fp, #129]
	movs	r3, #58
	strb	r3, [fp, #130]
	movs	r3, #59
	strb	r3, [fp, #131]
	b	.L1803
.L1704:
	cmp	r0, #6
	bne	.L1705
	movs	r3, #14
	mov	r8, #12
	strb	r3, [fp, #128]
	movs	r3, #15
	strb	r3, [fp, #129]
	movs	r3, #16
	strb	r3, [fp, #130]
	movs	r3, #17
	strb	r3, [fp, #131]
	b	.L1803
.L1705:
	cmp	r0, #7
	bne	.L1706
	add	r2, fp, #127
	movs	r3, #176
.L1707:
	strb	r3, [r2, #1]!
	adds	r3, r3, #1
	uxtb	r3, r3
	cmp	r3, #184
	bne	.L1707
	movs	r3, #212
	mov	r8, #12
	strb	r3, [fp, #136]
	movs	r3, #213
	strb	r3, [fp, #137]
	mov	r10, #10
	b	.L1700
.L1706:
	cmp	r0, #8
	mov	r3, #7
	bne	.L1762
	strb	r3, [fp, #129]
	movs	r3, #9
	movs	r2, #6
	strb	r3, [fp, #131]
	movs	r3, #10
	strb	r2, [fp, #128]
	strb	r0, [fp, #130]
	mov	r8, #50
	strb	r3, [fp, #132]
	mov	r10, #5
	b	.L1700
.L1762:
	mov	r8, r3
	b	.L1803
.L1714:
	ldr	r2, .L1809+12
	movs	r1, #160
	ldr	r0, [sp]
	add	r7, r10, #-1
	add	r6, fp, #127
	ldrb	r3, [r2, r3]	@ zero_extendqisi2
	ldr	r2, .L1809+16
	uxtab	r7, r0, r7
	ldr	r4, [r2]
	mla	r1, r1, r3, fp
	add	r4, r4, r3, lsl #8
	adds	r1, r1, #144
	subs	r2, r1, #1
	addw	r3, r4, #2056
.L1710:
	str	r2, [sp, #8]
	movs	r2, #55
	str	r2, [r3]
	ldrb	r0, [r6, #1]!	@ zero_extendqisi2
	str	r3, [sp, #4]
	str	r0, [r4, #2052]
	movs	r0, #80
	bl	timer_delay_ns
	ldr	r0, [r4, #2048]
	cmp	r7, r6
	ldr	r2, [sp, #8]
	ldr	r3, [sp, #4]
	strb	r0, [r2, #1]!
	bne	.L1710
	ldr	r7, .L1809+4
	mov	r0, r1
	movs	r2, #0
.L1711:
	movs	r3, #1
	adds	r6, r7, r2
.L1712:
	ldrb	r4, [r6, r3, lsl #2]	@ zero_extendqisi2
	ldrb	ip, [r0]	@ zero_extendqisi2
	add	r4, r4, ip
	strb	r4, [r0, r3, lsl #3]
	adds	r3, r3, #1
	cmp	r3, #7
	bne	.L1712
	adds	r2, r2, #1
	adds	r0, r0, #1
	cmp	r2, #4
	bne	.L1711
	movs	r3, #0
	adds	r5, r5, #1
	strb	r3, [r1, #16]
	strb	r3, [r1, #24]
	strb	r3, [r1, #32]
	strb	r3, [r1, #40]
	strb	r3, [r1, #48]
	strb	r3, [r1, #41]
	strb	r3, [r1, #49]
	b	.L1709
.L1708:
	subs	r3, r4, #3
	cmp	r3, #5
	bhi	.L1715
	smulbb	r3, r8, r10
	asrs	r2, r3, #1
	lsls	r3, r3, #4
	str	r3, [sp, #48]
	lsls	r3, r2, #2
	str	r2, [sp, #8]
	str	r3, [sp, #44]
	lsls	r3, r2, #1
	str	r3, [sp, #24]
	movs	r3, #0
.L1808:
	str	r3, [sp, #20]
	ldr	r3, .L1809+8
	ldrb	r2, [r3]	@ zero_extendqisi2
	ldrb	r3, [sp, #20]	@ zero_extendqisi2
	cmp	r2, r3
	bls	.L1715
	ldr	r2, .L1809+12
	movs	r6, #255
	ldrb	r3, [r2, r3]	@ zero_extendqisi2
	mov	r0, r3
	str	r3, [sp]
	bl	zftl_flash_exit_slc_mode
	ldr	r3, [sp]
	movs	r1, #160
	ldr	r2, [sp]
	mla	r1, r1, r3, fp
	add	r3, r1, #144
	str	r3, [sp, #40]
	ldr	r3, .L1809+16
	ldr	r3, [r3]
	str	r3, [sp, #4]
	add	r5, r3, r2, lsl #8
	str	r6, [r5, #2056]
	bl	nandc_wait_flash_ready
	cmp	r4, #8
	bne	.L1717
	add	r3, fp, #144
	movs	r2, #23
	str	r3, [sp, #40]
	movs	r3, #120
	str	r3, [r5, #2056]
	movs	r3, #0
	str	r3, [r5, #2052]
	movs	r1, #25
	str	r3, [r5, #2052]
	str	r3, [r5, #2052]
	str	r2, [r5, #2056]
	movs	r2, #4
	str	r2, [r5, #2056]
	str	r1, [r5, #2056]
	movs	r1, #218
	str	r1, [r5, #2056]
	movs	r1, #21
	str	r3, [r5, #2056]
	str	r3, [r5, #2052]
	str	r3, [r5, #2052]
	str	r1, [r5, #2052]
	str	r2, [r5, #2052]
	str	r3, [r5, #2052]
.L1718:
	ldm	sp, {r2, r3}
	add	r3, r3, r2, lsl #8
	movs	r2, #48
	str	r2, [r3, #2056]
	bl	nandc_wait_flash_ready
	subs	r3, r4, #5
	cmp	r3, #1
	str	r3, [sp, #28]
	bls	.L1764
	cmp	r4, #8
	beq	.L1764
	cmp	r4, #7
	ite	ne
	movne	r2, #2
	moveq	r2, #32
.L1724:
	ldr	r3, .L1809+20
	subs	r2, r2, #1
	ldr	r5, [sp, #4]
	ldr	r6, [sp]
	ldr	r3, [r3]
	add	r7, r5, r6, lsl #8
	subs	r1, r3, #1
	uxtab	r2, r3, r2
	mov	r0, r1
.L1725:
	ldr	r5, [r7, #2048]
	strb	r5, [r0, #1]!
	cmp	r2, r0
	bne	.L1725
	cmp	r4, #8
	bne	.L1726
	movs	r2, #0
.L1728:
	ldrb	r0, [r3, r2, lsl #2]	@ zero_extendqisi2
	uxtb	r1, r2
	cmp	r0, #50
	beq	.L1727
	add	r0, r3, r2, lsl #2
	ldrb	r0, [r0, #1]	@ zero_extendqisi2
	cmp	r0, #5
	beq	.L1727
	adds	r2, r2, #1
	cmp	r2, #8
	bne	.L1728
.L1729:
	movs	r1, #0
	ldr	r0, .L1809+24
	bl	printf
.L1731:
	b	.L1731
.L1717:
	cmp	r4, #4
	mov	r3, #54
	str	r3, [r5, #2056]
	bne	.L1719
	movs	r3, #64
	str	r6, [r5, #2052]
	str	r3, [r5, #2048]
	movs	r3, #204
.L1805:
	str	r3, [r5, #2052]
	movs	r3, #77
	b	.L1806
.L1810:
	.align	2
.L1809:
	.word	.LANCHOR27
	.word	.LANCHOR158
	.word	.LANCHOR18
	.word	.LANCHOR30
	.word	.LANCHOR13
	.word	.LANCHOR159
	.word	.LC100
.L1719:
	subs	r3, r4, #5
	cmp	r3, #1
	bhi	.L1721
	ldrb	r3, [fp, #128]	@ zero_extendqisi2
	str	r3, [r5, #2052]
	movs	r3, #82
.L1806:
	str	r3, [r5, #2048]
.L1720:
	ldm	sp, {r2, r3}
	cmp	r4, #6
	add	r3, r3, r2, lsl #8
	mov	r2, #22
	str	r2, [r3, #2056]
	mov	r2, #23
	str	r2, [r3, #2056]
	mov	r2, #4
	str	r2, [r3, #2056]
	mov	r2, #25
	str	r2, [r3, #2056]
	mov	r2, #0
	str	r2, [r3, #2056]
	str	r2, [r3, #2052]
	str	r2, [r3, #2052]
	it	eq
	moveq	r2, #31
	str	r2, [r3, #2052]
	movs	r2, #2
	str	r2, [r3, #2052]
	movs	r2, #0
	str	r2, [r3, #2052]
	b	.L1718
.L1721:
	cmp	r4, #7
	bne	.L1720
	movs	r3, #174
	str	r3, [r5, #2052]
	movs	r3, #0
	str	r3, [r5, #2048]
	movs	r3, #176
	b	.L1805
.L1764:
	movs	r2, #16
	b	.L1724
.L1727:
	cmp	r1, #6
	bhi	.L1729
.L1730:
	ldr	r3, .L1811
	ldr	ip, [r3]
	mov	r3, ip
.L1740:
	ldr	r1, [sp, #48]
	sub	r2, r3, ip
	cmp	r1, r2
	bgt	.L1741
	ldr	r3, .L1811
	ldr	r1, [r3]
	ldr	r3, [sp, #24]
	adds	r2, r1, r3
	movs	r3, #8
.L1743:
	mov	r5, r2
	movs	r0, #0
.L1742:
	ldrh	r6, [r5]
	adds	r0, r0, #1
	mvns	r6, r6
	strh	r6, [r5], #2	@ movhi
	ldr	r6, [sp, #8]
	cmp	r6, r0
	bgt	.L1742
	ldr	r0, [sp, #44]
	subs	r3, r3, #1
	add	r2, r2, r0
	bne	.L1743
	mov	r6, r1
	str	r3, [sp, #16]
.L1744:
	movs	r0, #0
	mov	r2, r0
.L1748:
	movs	r3, #1
	mov	lr, r6
	lsl	r5, r3, r2
	movs	r3, #0
	str	r3, [sp, #12]
	str	r5, [sp, #32]
	movs	r5, #16
	str	r5, [sp, #36]
.L1746:
	ldrh	r3, [lr]
	str	r3, [sp, #52]
	ldr	r3, [sp, #32]
	mov	r5, r3
	ldr	r3, [sp, #52]
	bics	r3, r5, r3
	ittt	eq
	ldreq	r3, [sp, #12]
	addeq	r3, r3, #1
	streq	r3, [sp, #12]
	ldr	r3, [sp, #24]
	add	lr, lr, r3
	ldr	r3, [sp, #36]
	subs	r3, r3, #1
	str	r3, [sp, #36]
	bne	.L1746
	ldr	r3, [sp, #12]
	adds	r2, r2, #1
	cmp	r3, #8
	ittt	hi
	ldrhi	r3, [sp, #32]
	orrhi	r0, r0, r3
	uxthhi	r0, r0
	cmp	r2, #16
	bne	.L1748
	ldr	r3, [sp, #16]
	strh	r0, [r6], #2	@ movhi
	adds	r3, r3, #1
	str	r3, [sp, #16]
	ldr	r2, [sp, #16]
	ldr	r3, [sp, #8]
	cmp	r3, r2
	bgt	.L1744
	subs	r2, r1, #4
	add	r0, r1, #28
	movs	r3, #0
.L1751:
	ldr	r5, [r2, #4]!
	cbnz	r5, .L1750
	adds	r3, r3, #1
.L1750:
	cmp	r0, r2
	bne	.L1751
	cmp	r3, #7
	ble	.L1752
	ldr	r0, .L1811+4
	mov	r3, #1024
	movs	r2, #1
	bl	rknand_print_hex
	movs	r1, #0
	ldr	r0, .L1811+8
	bl	printf
.L1753:
	b	.L1753
.L1726:
	cmp	r4, #7
	bne	.L1732
	movs	r2, #0
.L1734:
	ldrb	r0, [r3, r2, lsl #2]	@ zero_extendqisi2
	uxtb	r1, r2
	cmp	r0, #12
	beq	.L1733
	add	r0, r3, r2, lsl #2
	ldrb	r0, [r0, #1]	@ zero_extendqisi2
	cmp	r0, #10
	beq	.L1733
	adds	r2, r2, #1
	cmp	r2, #8
	bne	.L1734
.L1735:
	movs	r1, #0
	ldr	r0, .L1811+8
	bl	printf
.L1736:
	b	.L1736
.L1733:
	cmp	r1, #6
	bls	.L1730
	b	.L1735
.L1732:
	cmp	r4, #6
	bne	.L1730
	adds	r3, r3, #7
.L1737:
	ldrb	r2, [r1, #1]!	@ zero_extendqisi2
	cmp	r2, #12
	beq	.L1730
	ldrb	r2, [r1, #8]	@ zero_extendqisi2
	cmp	r2, #4
	beq	.L1730
	cmp	r3, r1
	bne	.L1737
	movs	r1, #0
	ldr	r0, .L1811+8
	bl	printf
.L1739:
	b	.L1739
.L1741:
	ldr	r2, [r7, #2048]
	strb	r2, [r3], #1
	b	.L1740
.L1752:
	cmp	r4, #6
	beq	.L1766
	cmp	r4, #7
	beq	.L1767
	cmp	r4, #8
	ite	ne
	movne	r0, #8
	moveq	r0, #5
.L1754:
	add	r3, r10, #-1
	ldr	r1, [sp, #40]
	uxtb	r3, r3
	movs	r5, #0
	adds	r3, r3, #1
.L1755:
	mov	lr, r1
	mov	r2, ip
.L1756:
	ldrb	r6, [r2], #1	@ zero_extendqisi2
	strb	r6, [lr], #1
	sub	r6, r2, ip
	uxtb	r6, r6
	cmp	r10, r6
	bhi	.L1756
	adds	r5, r5, #1
	add	ip, ip, r3
	cmp	r8, r5
	add	r1, r1, r0
	bgt	.L1755
	ldm	sp, {r2, r3}
	movs	r6, #255
	add	r5, r3, r2, lsl #8
	str	r6, [r5, #2056]
	bl	nandc_wait_flash_ready
	ldr	r3, [sp, #28]
	cmp	r3, #1
	bhi	.L1758
	movs	r3, #54
	movs	r2, #22
	str	r3, [r5, #2056]
	ldrb	r3, [fp, #128]	@ zero_extendqisi2
	str	r3, [r7, #2052]
	movs	r3, #0
	str	r3, [r7, #2048]
	str	r2, [r5, #2056]
	str	r3, [r5, #2056]
	str	r3, [r7, #2052]
	str	r3, [r7, #2052]
	movs	r3, #48
	str	r6, [r7, #2052]
	str	r6, [r7, #2052]
	str	r6, [r7, #2052]
.L1807:
	str	r3, [r5, #2056]
	bl	nandc_wait_flash_ready
	ldr	r3, [sp, #20]
	adds	r3, r3, #1
	b	.L1808
.L1766:
	movs	r0, #4
	b	.L1754
.L1767:
	movs	r0, #10
	b	.L1754
.L1758:
	cmp	r4, #8
	ite	eq
	moveq	r3, #190
	movne	r3, #56
	b	.L1807
.L1812:
	.align	2
.L1811:
	.word	.LANCHOR159
	.word	.LC101
	.word	.LC100
	.size	hynix_get_read_retry_default, .-hynix_get_read_retry_default
	.section	.text.flash_get_read_retry_tbl,"ax",%progbits
	.align	1
	.global	flash_get_read_retry_tbl
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_get_read_retry_tbl, %function
flash_get_read_retry_tbl:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L1815
	ldrb	r0, [r3, #19]	@ zero_extendqisi2
	subs	r3, r0, #1
	cmp	r3, #7
	bhi	.L1813
	b	hynix_get_read_retry_default
.L1813:
	bx	lr
.L1816:
	.align	2
.L1815:
	.word	.LANCHOR32
	.size	flash_get_read_retry_tbl, .-flash_get_read_retry_tbl
	.section	.text.nandc_xfer_done,"ax",%progbits
	.align	1
	.global	nandc_xfer_done
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	nandc_xfer_done, %function
nandc_xfer_done:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1855
	push	{r0, r1, r2, r4, r5, r6, r7, r8, r10, lr}
	movs	r4, #0
	ldr	r7, .L1855+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldr	r5, .L1855+8
	strb	r4, [r7]
	cmp	r3, #9
	ldr	r6, [r5]
	bne	.L1818
	ldr	r3, [r6, #16]
	str	r3, [sp]
	ldr	r3, [r6, #48]
	ubfx	r3, r3, #1, #1
	cbnz	r3, .L1819
	ldr	r7, .L1855+12
	mov	r4, r3
	ldr	r8, .L1855+32
.L1820:
	ldr	r3, [sp]
	lsls	r0, r3, #11
	bmi	.L1823
	ldr	r3, [r5]
	adds	r4, r4, #1
	ldr	r3, [r3, #16]
	str	r3, [sp]
	bics	r3, r4, #-16777216
	bne	.L1820
	ldr	r2, [sp]
	mov	r1, r4
	ldr	r3, [r6, #64]
	mov	r0, r7
	ubfx	r3, r3, #16, #6
	bl	printf
	movs	r3, #64
	movs	r2, #4
	ldr	r1, [r5]
	mov	r0, r8
	bl	rknand_print_hex
	b	.L1820
.L1819:
	ldr	r8, .L1855+24
	ldr	r10, .L1855+32
.L1821:
	ldr	r2, [r6, #64]
	ldr	r3, [sp]
	ubfx	r2, r2, #16, #6
	ubfx	r3, r3, #22, #6
	cmp	r2, r3
	bge	.L1823
	ldr	r3, [r5]
	ldr	r3, [r3]
	str	r3, [sp, #4]
	ldr	r3, [sp, #4]
	lsls	r1, r3, #18
	bpl	.L1822
	ldr	r3, [sp, #4]
	lsls	r2, r3, #14
	bpl	.L1822
	ldr	r1, [sp, #4]
	ldr	r0, .L1855+16
	ubfx	r1, r1, #17, #1
.L1854:
	bl	printf
	b	.L1823
.L1822:
	ldr	r3, [sp]
	adds	r4, r4, #1
	ubfx	r3, r3, #22, #6
	cmp	r4, r3, lsl #12
	bne	.L1821
	ldr	r2, [r6, #64]
	mov	r1, r4
	ldr	r3, [sp]
	mov	r0, r8
	ubfx	r2, r2, #16, #5
	ubfx	r3, r3, #22, #6
	bl	printf
	movs	r3, #64
	movs	r2, #4
	ldr	r1, [r5]
	mov	r0, r10
	bl	rknand_print_hex
	ldr	r3, [sp, #4]
	lsls	r3, r3, #18
	bpl	.L1821
	movs	r3, #1
	strb	r3, [r7]
.L1823:
	ldr	r3, .L1855+20
	movs	r2, #0
	str	r2, [r3, #20]
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L1818:
	ldr	r3, [r6, #8]
	str	r3, [sp]
	ldr	r3, [r6, #16]
	ubfx	r3, r3, #1, #1
	cbnz	r3, .L1829
	ldr	r7, .L1855+12
	mov	r4, r3
	ldr	r8, .L1855+32
.L1830:
	ldr	r3, [sp]
	lsls	r3, r3, #11
	bmi	.L1823
	ldr	r3, [r5]
	adds	r4, r4, #1
	ldr	r3, [r3, #8]
	str	r3, [sp]
	bics	r3, r4, #-16777216
	bne	.L1830
	ldr	r2, [sp]
	mov	r1, r4
	ldr	r3, [r6, #28]
	mov	r0, r7
	ubfx	r3, r3, #16, #5
	bl	printf
	movs	r3, #64
	movs	r2, #4
	ldr	r1, [r5]
	mov	r0, r8
	bl	rknand_print_hex
	b	.L1830
.L1829:
	ldr	r7, .L1855+24
	ldr	r8, .L1855+32
.L1831:
	ldr	r2, [r6, #28]
	ldr	r3, [sp]
	ubfx	r2, r2, #16, #5
	ubfx	r3, r3, #22, #6
	cmp	r2, r3
	bge	.L1823
	ldr	r3, [r5]
	ldr	r3, [r3]
	str	r3, [sp, #4]
	ldr	r3, [sp, #4]
	lsls	r1, r3, #18
	bpl	.L1832
	ldr	r3, [sp, #4]
	lsls	r2, r3, #14
	bpl	.L1832
	ldr	r1, [sp, #4]
	ldr	r0, .L1855+28
	b	.L1854
.L1832:
	adds	r4, r4, #1
	bics	r3, r4, #-16777216
	bne	.L1831
	ldr	r2, [r6, #28]
	mov	r1, r4
	ldr	r3, [sp]
	mov	r0, r7
	ubfx	r2, r2, #16, #5
	ubfx	r3, r3, #22, #6
	bl	printf
	movs	r3, #64
	movs	r2, #4
	ldr	r1, [r5]
	mov	r0, r8
	bl	rknand_print_hex
	b	.L1831
.L1856:
	.align	2
.L1855:
	.word	.LANCHOR28
	.word	.LANCHOR160
	.word	.LANCHOR13
	.word	.LC105
	.word	.LC102
	.word	.LANCHOR49
	.word	.LC103
	.word	.LC106
	.word	.LC104
	.size	nandc_xfer_done, .-nandc_xfer_done
	.section	.text.nandc_xfer,"ax",%progbits
	.align	1
	.global	nandc_xfer
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	nandc_xfer, %function
nandc_xfer:
	@ args = 4, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, lr}
	mov	r8, r1
	ldr	r5, [sp, #32]
	mov	r4, r2
	mov	r6, r3
	mov	r1, r4
	mov	r2, r6
	mov	r0, r8
	mov	r3, r5
	bl	nandc_xfer_start
	bl	nandc_xfer_done
	cmp	r8, #0
	bne	.L1876
	ldr	r3, .L1895
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #9
	bne	.L1859
	ldr	r7, .L1895+4
	lsr	ip, r4, #2
	movs	r2, #1
	mov	r1, r8
	mov	r0, r8
	ldr	r4, [r7]
.L1860:
	cmp	r1, ip
	bcc	.L1864
	ldr	r4, [r4]
	cmp	r2, #0
	it	ne
	movne	r0, #512
	and	r3, r4, #139264
	cmp	r3, #139264
	bne	.L1866
	mov	r1, r4
	ldr	r0, .L1895+8
	bl	printf
	ldr	r3, [r7]
	mov	r0, #-1
	orr	r4, r4, #131072
	str	r4, [r3]
.L1866:
	lsls	r2, r4, #18
	bpl	.L1867
	ldr	r3, .L1895+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L1867
	mov	r1, r4
	ldr	r0, .L1895+16
	bl	printf
	ldr	r3, [r7]
	movs	r2, #1
	str	r2, [r3, #16]
.L1894:
	mov	r0, #-1
.L1858:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L1864:
	add	r3, r1, #84
	ldr	r3, [r4, r3, lsl #2]
	str	r3, [sp, #4]
	ldr	lr, [sp, #4]
	ldr	r3, [sp, #4]
	ubfx	r3, r3, #26, #1
	and	r3, r3, lr, lsr #10
	ands	r2, r2, r3
	ldr	r3, [sp, #4]
	lsls	r3, r3, #29
	bmi	.L1878
	ldr	r3, [sp, #4]
	lsls	r3, r3, #13
	bmi	.L1878
	ldr	r3, [sp, #4]
	ubfx	lr, r3, #3, #7
	ldr	r3, [sp, #4]
	ubfx	r3, r3, #19, #7
	cmp	lr, r3
	ldr	r3, [sp, #4]
	ite	gt
	ubfxgt	r3, r3, #3, #7
	ubfxle	r3, r3, #19, #7
	cmp	r0, r3
	it	cc
	movcc	r0, r3
.L1861:
	adds	r1, r1, #1
	b	.L1860
.L1878:
	mov	r0, #-1
	b	.L1861
.L1859:
	ldr	r3, .L1895+20
	mov	r1, r8
	mov	r0, r8
	ldr	r8, .L1895+28
	lsrs	r7, r4, #1
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #25
	mov	r3, r5
	ite	cc
	movcc	lr, #64
	movcs	lr, #128
.L1869:
	cmp	r0, r7
	add	ip, lr, r1
	add	r3, r3, #4
	bcc	.L1870
	ldr	r7, .L1895+4
	movs	r2, #0
	lsrs	r4, r4, #2
	mov	r0, r2
	ldr	r1, [r7]
.L1871:
	cmp	r2, r4
	bcc	.L1875
	movs	r3, #0
	str	r3, [r1, #16]
	ldr	r4, [r1]
	and	r3, r4, #139264
	cmp	r3, #139264
	bne	.L1867
	mov	r1, r4
	ldr	r0, .L1895+24
	bl	printf
	ldr	r3, [r7]
	orr	r4, r4, #131072
	str	r4, [r3]
	b	.L1894
.L1870:
	ldr	r2, [r8]
	bic	r1, r1, #3
	adds	r0, r0, #1
	ldr	r2, [r2, r1]
	strb	r2, [r3, #-4]
	lsrs	r1, r2, #8
	strb	r1, [r3, #-3]
	lsrs	r1, r2, #16
	lsrs	r2, r2, #24
	strb	r1, [r3, #-2]
	mov	r1, ip
	strb	r2, [r3, #-1]
	b	.L1869
.L1875:
	add	r3, r2, #8
	ldr	r3, [r1, r3, lsl #2]
	str	r3, [sp, #4]
	ldr	r3, [sp, #4]
	lsls	r3, r3, #29
	bmi	.L1881
	ldr	r3, [sp, #4]
	lsls	r3, r3, #16
	bmi	.L1881
	ldr	r3, [sp, #4]
	ubfx	ip, r3, #3, #5
	ldr	r3, [sp, #4]
	ubfx	r8, r3, #27, #1
	ldr	r3, [sp, #4]
	ldr	lr, [sp, #4]
	orr	ip, ip, r8, lsl #5
	ubfx	r3, r3, #16, #5
	ubfx	lr, lr, #29, #1
	orr	r3, r3, lr, lsl #5
	cmp	ip, r3
	ldr	r3, [sp, #4]
	itete	hi
	ldrhi	ip, [sp, #4]
	ldrls	ip, [sp, #4]
	ubfxhi	r3, r3, #3, #5
	ubfxls	r3, r3, #16, #5
	ite	hi
	ubfxhi	ip, ip, #27, #1
	ubfxls	ip, ip, #29, #1
	orr	r3, r3, ip, lsl #5
	cmp	r0, r3
	it	cc
	movcc	r0, r3
.L1872:
	adds	r2, r2, #1
	b	.L1871
.L1881:
	mov	r0, #-1
	b	.L1872
.L1867:
	adds	r3, r0, #1
	beq	.L1858
	ldr	r3, [r5]
	adds	r3, r3, #1
	bne	.L1858
	ldr	r3, [r5, #4]
	adds	r3, r3, #1
	bne	.L1858
	ldr	r3, [r6]
	adds	r3, r3, #1
	it	eq
	moveq	r0, #512
	b	.L1858
.L1876:
	movs	r0, #0
	b	.L1858
.L1896:
	.align	2
.L1895:
	.word	.LANCHOR28
	.word	.LANCHOR13
	.word	.LC107
	.word	.LANCHOR160
	.word	.LC108
	.word	.LANCHOR46
	.word	.LC109
	.word	.LANCHOR49
	.size	nandc_xfer, .-nandc_xfer
	.section	.text.flash_read_page,"ax",%progbits
	.align	1
	.global	flash_read_page
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_read_page, %function
flash_read_page:
	@ args = 4, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r5, r0
	str	r3, [sp, #12]
	ubfx	r7, r1, #24, #2
	ldr	r3, .L1911
	str	r2, [sp, #8]
	ldr	r6, [r3]
	ldr	r3, .L1911+4
	ldrb	r4, [r3]	@ zero_extendqisi2
	rsb	r3, r4, #24
	movs	r4, #1
	lsls	r4, r4, r3
	ldr	r3, .L1911+8
	subs	r4, r4, #1
	ldr	r3, [r3]
	ands	r4, r4, r1
	lsls	r3, r3, #27
	bpl	.L1898
	mov	r3, r1
	mov	r2, r7
	mov	r1, r0
	ldr	r0, .L1911+12
	bl	printf
.L1898:
	bl	nandc_wait_flash_ready
	mov	r0, r5
	ldr	r10, .L1911+20
	bl	nandc_cs
	lsl	r8, r5, #8
	cmp	r7, #0
	bne	.L1899
	mov	r0, r5
	bl	zftl_flash_enter_slc_mode
.L1900:
	add	fp, r6, r8
	movs	r2, #0
	str	r2, [fp, #2056]
	str	r2, [fp, #2052]
	str	r2, [fp, #2052]
	uxtb	r2, r4
	str	r2, [fp, #2052]
	lsrs	r2, r4, #8
	str	r2, [fp, #2052]
	lsrs	r2, r4, #16
	str	r2, [fp, #2052]
	movs	r2, #48
	str	r2, [fp, #2056]
	ldr	r2, [r10]
	ldrb	r2, [r2, #12]	@ zero_extendqisi2
	cmp	r2, #3
	bne	.L1902
	cbz	r7, .L1902
	ldr	r2, .L1911+16
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbnz	r2, .L1902
	add	r4, r4, r4, lsl #1
	subs	r0, r4, #1
	add	r0, r0, r7
.L1910:
	bl	nandc_set_seed
	bl	nandc_wait_flash_ready
	add	r6, r6, r8
	movs	r1, #0
	movs	r2, #5
	movs	r3, #224
	str	r2, [r6, #2056]
	mov	r0, r5
	str	r1, [fp, #2052]
	str	r1, [fp, #2052]
	str	r3, [r6, #2056]
	ldr	r3, [sp, #12]
	ldrb	r2, [sp, #48]	@ zero_extendqisi2
	str	r3, [sp]
	ldr	r3, [sp, #8]
	bl	nandc_xfer
	bl	nandc_de_cs.constprop.30
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1899:
	ldr	r3, [r10]
	ldrb	r3, [r3, #12]	@ zero_extendqisi2
	cmp	r3, #3
	bne	.L1901
	ldr	r3, .L1911+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L1901
	add	r3, r6, r8
	str	r7, [r3, #2056]
	b	.L1900
.L1901:
	mov	r0, r5
	bl	zftl_flash_exit_slc_mode
	b	.L1900
.L1902:
	mov	r0, r4
	b	.L1910
.L1912:
	.align	2
.L1911:
	.word	.LANCHOR13
	.word	.LANCHOR31
	.word	.LANCHOR14
	.word	.LC110
	.word	.LANCHOR35
	.word	.LANCHOR16
	.size	flash_read_page, .-flash_read_page
	.section	.text.micron_read_retrial,"ax",%progbits
	.align	1
	.global	micron_read_retrial
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	micron_read_retrial, %function
micron_read_retrial:
	@ args = 4, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #24
	str	r3, [sp, #20]
	mov	r7, r0
	mov	fp, r1
	mov	r10, #0
	ldr	r3, .L1937
	str	r2, [sp, #16]
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	asrs	r3, r3, #2
	str	r3, [sp, #8]
	bl	nandc_wait_flash_ready
	ldr	r3, .L1937+4
	ldr	r5, [r3]
	add	r5, r5, r7, lsl #8
.L1914:
	mov	r8, #0
	mov	r4, #-1
.L1915:
	ldr	r3, .L1937+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r8, r3
	bcc	.L1920
.L1919:
	movs	r3, #239
	movs	r0, #200
	str	r3, [r5, #2056]
	movs	r3, #137
	str	r3, [r5, #2052]
	movs	r6, #0
	bl	timer_delay_ns
	ldr	r3, [sp, #8]
	str	r6, [r5, #2048]
	str	r6, [r5, #2048]
	cmp	r4, r3
	str	r6, [r5, #2048]
	str	r6, [r5, #2048]
	bcc	.L1921
	adds	r1, r4, #1
	mov	r3, r8
	it	ne
	movne	r4, #256
	mov	r2, fp
	str	r4, [sp]
	mov	r1, r8
	ldr	r0, .L1937+12
	bl	printf
	cmp	r10, #0
	bne	.L1923
	adds	r2, r4, #1
	bne	.L1924
	movs	r1, #3
	mov	r0, r7
	bl	mt_auto_read_calibration_config
	mov	r10, #1
	b	.L1914
.L1920:
	movs	r3, #239
	movs	r0, #200
	str	r3, [r5, #2056]
	movs	r3, #137
	str	r3, [r5, #2052]
	bl	timer_delay_ns
	add	r3, r8, #1
	ldr	r2, [sp, #16]
	str	r3, [r5, #2048]
	mov	r1, fp
	str	r3, [sp, #12]
	movs	r3, #0
	str	r3, [r5, #2048]
	mov	r0, r7
	str	r3, [r5, #2048]
	str	r3, [r5, #2048]
	ldr	r3, [sp, #56]
	str	r3, [sp]
	ldr	r3, [sp, #20]
	bl	flash_read_page
	ldr	r3, .L1937+16
	mov	r6, r0
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L1916
	str	r0, [sp]
	mov	r3, r4
	mov	r2, fp
	mov	r1, r8
	ldr	r0, .L1937+20
	bl	printf
.L1916:
	adds	r0, r6, #1
	beq	.L1917
	ldr	r3, .L1937+24
	cmp	r4, #-1
	it	eq
	moveq	r4, r6
	ldr	r3, [r3]
	str	r3, [sp, #16]
	ldr	r3, .L1937+28
	ldr	r3, [r3]
	str	r3, [sp, #20]
	ldr	r3, [sp, #8]
	cmp	r6, r3
	bcc	.L1926
.L1917:
	ldr	r8, [sp, #12]
	b	.L1915
.L1926:
	mov	r4, r6
	b	.L1919
.L1923:
	mov	r1, r6
	mov	r0, r7
	bl	mt_auto_read_calibration_config
	adds	r3, r4, #1
	it	ne
	movne	r4, #256
.L1924:
	bl	nandc_wait_flash_ready
	mov	r0, r4
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1921:
	cmp	r10, #0
	beq	.L1924
	mov	r1, r6
	mov	r0, r7
	bl	mt_auto_read_calibration_config
	mov	r4, #256
	b	.L1924
.L1938:
	.align	2
.L1937:
	.word	.LANCHOR46
	.word	.LANCHOR13
	.word	.LANCHOR162
	.word	.LC112
	.word	.LANCHOR14
	.word	.LC111
	.word	.LANCHOR159
	.word	.LANCHOR161
	.size	micron_read_retrial, .-micron_read_retrial
	.section	.text.toshiba_3d_read_retrial,"ax",%progbits
	.align	1
	.global	toshiba_3d_read_retrial
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	toshiba_3d_read_retrial, %function
toshiba_3d_read_retrial:
	@ args = 4, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #24
	mov	r7, r0
	str	r2, [sp, #8]
	mov	r8, r1
	ubfx	r4, r1, #24, #2
	str	r3, [sp, #12]
	add	r6, r7, #8
	bl	nandc_wait_flash_ready
	ldr	r3, .L1982
	ldr	fp, [r3]
	ldr	r3, .L1982+4
	ldrb	r2, [r3]	@ zero_extendqisi2
	add	r6, fp, r6, lsl #8
	cmp	r2, #36
	ite	ne
	movne	r2, #56
	moveq	r2, #46
	str	r2, [sp, #20]
	ite	ne
	movne	r2, #10
	moveq	r2, #26
	str	r2, [sp, #16]
	cmp	r4, #0
	bne	.L1941
	mov	r4, #-1
	movs	r5, #1
	str	r3, [sp, #20]
.L1948:
	ldr	r3, [sp, #20]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #36
	bne	.L1942
	movs	r2, #0
	mov	r1, r5
	mov	r0, r6
	bl	toshiba_tlc_set_rr_para
	add	r3, fp, r7, lsl #8
	movs	r2, #93
	str	r2, [r3, #2056]
.L1943:
	ldr	r3, [sp, #56]
	mov	r1, r8
	ldr	r2, [sp, #8]
	mov	r0, r7
	str	r3, [sp]
	ldr	r3, [sp, #12]
	bl	flash_read_page
	ldr	r3, .L1982+8
	mov	r10, r0
	ldr	r3, [r3]
	lsls	r1, r3, #27
	bpl	.L1944
	mov	r3, r0
	mov	r2, r8
	mov	r1, r5
	ldr	r0, .L1982+12
	bl	printf
.L1944:
	cmp	r10, #-1
	beq	.L1945
	ldr	r3, .L1982+16
	cmp	r4, #-1
	it	eq
	moveq	r4, r10
	ldr	r3, [r3]
	str	r3, [sp, #8]
	ldr	r3, .L1982+20
	ldr	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L1982+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r10, r3, asr #2
	bcc	.L1963
.L1945:
	ldr	r3, [sp, #16]
	adds	r5, r5, #1
	cmp	r3, r5
	bne	.L1948
.L1947:
	ldr	r3, .L1982+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #36
	bne	.L1949
	movs	r2, #0
.L1981:
	movs	r1, #0
	mov	r0, r6
	bl	toshiba_tlc_set_rr_para
	b	.L1950
.L1942:
	uxtb	r1, r5
	mov	r0, r6
	bl	toshiba_3d_set_slc_rr_para
	b	.L1943
.L1963:
	mov	r4, r10
	b	.L1947
.L1949:
	movs	r1, #0
	mov	r0, r6
	bl	toshiba_3d_set_slc_rr_para
.L1950:
	ldr	r3, .L1982+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #36
	bne	.L1959
	add	r7, fp, r7, lsl #8
	movs	r3, #85
	str	r3, [r7, #2056]
	movs	r3, #0
	str	r3, [r7, #2052]
	str	r3, [r7, #2048]
	movs	r3, #255
	str	r3, [r7, #2056]
.L1959:
	ldr	r3, .L1982+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r4, r3, asr #2
	bcc	.L1960
	adds	r3, r4, #1
	mov	r2, r8
	it	ne
	movne	r4, #256
	mov	r3, r5
	str	r4, [sp]
	mov	r1, r5
	ldr	r0, .L1982+28
	bl	printf
.L1960:
	bl	nandc_wait_flash_ready
	mov	r0, r4
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1941:
	mov	r4, #-1
	movs	r5, #1
	str	r3, [sp, #16]
.L1957:
	ldr	r3, [sp, #16]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #36
	bne	.L1951
	movs	r2, #1
	mov	r1, r5
	mov	r0, r6
	bl	toshiba_tlc_set_rr_para
	add	r3, fp, r7, lsl #8
	movs	r2, #93
.L1980:
	str	r2, [r3, #2056]
	mov	r1, r8
	ldr	r3, [sp, #56]
	mov	r0, r7
	ldr	r2, [sp, #8]
	str	r3, [sp]
	ldr	r3, [sp, #12]
	bl	flash_read_page
	ldr	r3, .L1982+8
	mov	r10, r0
	ldr	r3, [r3]
	lsls	r2, r3, #27
	bpl	.L1953
	mov	r3, r0
	mov	r2, r8
	mov	r1, r5
	ldr	r0, .L1982+32
	bl	printf
.L1953:
	cmp	r10, #-1
	beq	.L1954
	ldr	r3, .L1982+16
	cmp	r4, #-1
	it	eq
	moveq	r4, r10
	ldr	r3, [r3]
	str	r3, [sp, #8]
	ldr	r3, .L1982+20
	ldr	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L1982+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r10, r3, asr #2
	bcc	.L1964
.L1954:
	ldr	r3, [sp, #20]
	adds	r5, r5, #1
	cmp	r3, r5
	bne	.L1957
.L1956:
	ldr	r3, .L1982+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #36
	bne	.L1958
	movs	r2, #1
	b	.L1981
.L1951:
	uxtb	r1, r5
	mov	r0, r6
	bl	toshiba_3d_set_tlc_rr_para
	add	r3, fp, r7, lsl #8
	movs	r2, #38
	b	.L1980
.L1964:
	mov	r4, r10
	b	.L1956
.L1958:
	movs	r1, #0
	mov	r0, r6
	bl	toshiba_3d_set_tlc_rr_para
	b	.L1950
.L1983:
	.align	2
.L1982:
	.word	.LANCHOR13
	.word	.LANCHOR23
	.word	.LANCHOR14
	.word	.LC113
	.word	.LANCHOR159
	.word	.LANCHOR161
	.word	.LANCHOR46
	.word	.LC115
	.word	.LC114
	.size	toshiba_3d_read_retrial, .-toshiba_3d_read_retrial
	.section	.text.toshiba_read_retrial,"ax",%progbits
	.align	1
	.global	toshiba_read_retrial
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	toshiba_read_retrial, %function
toshiba_read_retrial:
	@ args = 4, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #24
	mov	r7, r0
	str	r2, [sp, #12]
	add	r10, r7, #8
	str	r3, [sp, #16]
	str	r1, [sp, #8]
	bl	nandc_wait_flash_ready
	ldr	r3, .L2011
	ldr	r2, .L2011+4
	ldr	r6, [r3]
	ldrb	r3, [r2]	@ zero_extendqisi2
	str	r2, [sp, #20]
	subs	r3, r3, #67
	add	r10, r6, r10, lsl #8
	cmp	r3, #1
	bls	.L2002
	ldr	r3, .L2011+8
	ldrb	r5, [r3]	@ zero_extendqisi2
	cbz	r5, .L1986
	movs	r5, #1
	movs	r0, #1
	bl	nandc_set_if_mode
.L1986:
	add	r3, r6, r7, lsl #8
	movs	r2, #92
	str	r2, [r3, #2056]
	movs	r2, #197
	str	r2, [r3, #2056]
.L1985:
	mov	r8, #1
	mov	fp, #-1
.L1987:
	ldr	r3, .L2011+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	adds	r3, r3, #1
	cmp	r8, r3
	bcc	.L1996
	mov	r4, fp
.L1995:
	ldr	r3, .L2011+4
	movs	r1, #0
	mov	r0, r10
	ldrb	r3, [r3]	@ zero_extendqisi2
	subs	r3, r3, #67
	cmp	r3, #1
	bhi	.L1997
	bl	sandisk_set_rr_para
.L1998:
	add	r6, r6, r7, lsl #8
	movs	r3, #255
	str	r3, [r6, #2056]
	ldr	r3, .L2011+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r4, r3, asr #2
	bcc	.L1999
	adds	r3, r4, #1
	ldr	r2, [sp, #8]
	it	ne
	movne	r4, #256
	mov	r3, r8
	str	r4, [sp]
	mov	r1, r8
	ldr	r0, .L2011+20
	bl	printf
.L1999:
	bl	nandc_wait_flash_ready
	cbz	r5, .L1984
	movs	r0, #4
	bl	nandc_set_if_mode
.L1984:
	mov	r0, r4
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2002:
	movs	r5, #0
	b	.L1985
.L1996:
	ldr	r3, [sp, #20]
	mov	r0, r10
	uxtb	r1, r8
	ldrb	r3, [r3]	@ zero_extendqisi2
	subs	r3, r3, #67
	cmp	r3, #1
	bhi	.L1988
	bl	sandisk_set_rr_para
.L1989:
	ldr	r3, .L2011+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #34
	bne	.L1990
	ldr	r3, .L2011+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	subs	r3, r3, #3
	cmp	r8, r3
	ittt	eq
	addeq	r3, r6, r7, lsl #8
	moveq	r2, #179
	streq	r2, [r3, #2056]
.L1990:
	add	r3, r6, r7, lsl #8
	movs	r2, #38
	add	r1, sp, #8
	str	r2, [r3, #2056]
	movs	r2, #93
	str	r2, [r3, #2056]
	mov	r0, r7
	ldr	r3, [sp, #56]
	str	r3, [sp]
	ldm	r1, {r1, r2, r3}
	bl	flash_read_page
	adds	r2, r0, #1
	mov	r4, r0
	beq	.L1993
	ldr	r3, .L2011+24
	cmp	fp, #-1
	it	eq
	moveq	fp, r0
	ldr	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L2011+28
	ldr	r3, [r3]
	str	r3, [sp, #16]
	ldr	r3, .L2011+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r0, r3, asr #2
	bcc	.L1995
.L1993:
	add	r8, r8, #1
	b	.L1987
.L1988:
	bl	toshiba_set_rr_para
	b	.L1989
.L1997:
	bl	toshiba_set_rr_para
	b	.L1998
.L2012:
	.align	2
.L2011:
	.word	.LANCHOR13
	.word	.LANCHOR23
	.word	.LANCHOR21
	.word	.LANCHOR162
	.word	.LANCHOR46
	.word	.LC115
	.word	.LANCHOR159
	.word	.LANCHOR161
	.size	toshiba_read_retrial, .-toshiba_read_retrial
	.section	.text.hynix_read_retrial,"ax",%progbits
	.align	1
	.global	hynix_read_retrial
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	hynix_read_retrial, %function
hynix_read_retrial:
	@ args = 4, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r6, #0
	str	r3, [sp, #12]
	mov	r4, #-1
	mov	r7, r0
	mov	r8, r1
	ldr	r3, .L2027
	str	r2, [sp, #8]
	ldr	r3, [r3]
	add	r10, r3, r0
	ldrb	fp, [r3, #114]	@ zero_extendqisi2
	ldrb	r5, [r10, #120]	@ zero_extendqisi2
	bl	nandc_wait_flash_ready
.L2014:
	cmp	r6, fp
	bcc	.L2019
.L2018:
	ldr	r3, .L2027+4
	strb	r5, [r10, #120]
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r4, r3, asr #2
	bcc	.L2020
	adds	r3, r4, #1
	mov	r2, r8
	it	ne
	movne	r4, #256
	mov	r3, r6
	str	r4, [sp]
	mov	r1, r6
	ldr	r0, .L2027+8
	bl	printf
.L2020:
	bl	nandc_wait_flash_ready
	mov	r0, r4
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2019:
	adds	r5, r5, #1
	mov	r0, r7
	uxtb	r5, r5
	cmp	fp, r5
	it	ls
	movls	r5, #0
	mov	r1, r5
	bl	hynix_set_rr_para
	ldr	r3, [sp, #48]
	mov	r1, r8
	ldr	r2, [sp, #8]
	mov	r0, r7
	str	r3, [sp]
	ldr	r3, [sp, #12]
	bl	flash_read_page
	adds	r2, r0, #1
	beq	.L2016
	ldr	r3, .L2027+12
	cmp	r4, #-1
	it	eq
	moveq	r4, r0
	ldr	r3, [r3]
	str	r3, [sp, #8]
	ldr	r3, .L2027+16
	ldr	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L2027+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r0, r3, asr #2
	bcc	.L2022
.L2016:
	adds	r6, r6, #1
	b	.L2014
.L2022:
	mov	r4, r0
	b	.L2018
.L2028:
	.align	2
.L2027:
	.word	.LANCHOR27
	.word	.LANCHOR46
	.word	.LC116
	.word	.LANCHOR159
	.word	.LANCHOR161
	.size	hynix_read_retrial, .-hynix_read_retrial
	.section	.text.flash_ddr_tuning_read,"ax",%progbits
	.align	1
	.global	flash_ddr_tuning_read
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_ddr_tuning_read, %function
flash_ddr_tuning_read:
	@ args = 4, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r4, #0
	sub	sp, sp, #32
	mov	r5, r4
	mov	r6, #1024
	movs	r7, #6
	str	r3, [sp, #20]
	mov	r8, r0
	mov	fp, r1
	str	r2, [sp, #16]
	bl	nandc_get_ddr_para
	mov	r3, #-1
	str	r0, [sp, #28]
	str	r4, [sp, #24]
	str	r4, [sp, #12]
	str	r3, [sp, #8]
.L2035:
	uxtb	r0, r7
	bl	nandc_set_ddr_para
	ldr	r3, [sp, #64]
	mov	r1, fp
	ldr	r2, [sp, #16]
	mov	r0, r8
	str	r3, [sp]
	ldr	r3, [sp, #20]
	bl	flash_read_page
	ldr	r3, .L2052
	mov	r10, r0
	ldr	r3, [r3]
	lsls	r3, r3, #27
	bpl	.L2030
	mov	r3, r0
	mov	r2, fp
	mov	r1, r7
	ldr	r0, .L2052+4
	bl	printf
.L2030:
	adds	r3, r6, #1
	cmp	r10, r3
	bhi	.L2031
	ldr	r3, .L2052+8
	ldr	r3, [r3]
	str	r3, [sp, #16]
	ldr	r3, .L2052+12
	ldr	r3, [r3]
	str	r3, [sp, #20]
	ldr	r3, .L2052+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r10, r3, lsr #2
	bcs	.L2041
	adds	r5, r5, #1
	cmp	r5, #7
	bls	.L2041
	subs	r4, r7, r5
	mov	r6, r10
	movs	r3, #0
	str	r3, [sp, #8]
.L2033:
	ldr	r3, [sp, #24]
	ldr	r2, [sp, #12]
	cmp	r5, r2
	it	cc
	movcc	r4, r3
.L2034:
	cmp	r4, #0
	beq	.L2036
	ldr	r3, .L2052+16
	ldrb	r2, [r3]	@ zero_extendqisi2
	ldr	r3, .L2052+20
	umull	r2, r3, r2, r3
	ubfx	r3, r3, #1, #8
	cmp	r3, r6
	bls	.L2036
	mov	r1, r4
	ldr	r0, .L2052+24
	bl	printf
	uxtb	r0, r4
.L2051:
	bl	nandc_set_ddr_para
	ldr	r3, [sp, #8]
	cbz	r3, .L2029
	mov	r1, r8
	mov	r2, fp
	ldr	r0, .L2052+28
	bl	printf
	mov	r0, r8
	bl	flash_reset
	movs	r0, #1
	bl	flash_set_interface_mode
	movs	r0, #1
	bl	nandc_set_if_mode
	ldr	r3, .L2052+32
	movs	r2, #2
	mov	r0, r8
	strb	r2, [r3, r8]
	bl	zftl_flash_enter_slc_mode
	ldr	r3, [sp, #64]
	mov	r1, fp
	ldr	r2, [sp, #16]
	mov	r0, r8
	str	r3, [sp]
	ldr	r3, [sp, #20]
	bl	flash_read_page
	mov	r2, fp
	mov	r3, r0
	mov	r6, r0
	mov	r1, r8
	ldr	r0, .L2052+36
	bl	printf
	ldr	r3, .L2052+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r6, r3
	bhi	.L2043
	ldr	r2, .L2052+40
	ldr	r3, [r2]
	adds	r3, r3, #1
	cmp	r3, #100
	str	r3, [r2]
	bls	.L2039
	ldr	r3, .L2052+44
	movs	r2, #0
	strb	r2, [r3]
.L2029:
	mov	r0, r6
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2031:
	ldr	r3, [sp, #12]
	cmp	r5, r3
	bls	.L2042
	cmp	r5, #7
	sub	r3, r4, r5
	str	r3, [sp, #24]
	bhi	.L2034
	str	r5, [sp, #12]
.L2042:
	movs	r5, #0
	b	.L2032
.L2041:
	mov	r4, r7
	mov	r6, r10
	movs	r3, #0
	str	r3, [sp, #8]
.L2032:
	adds	r7, r7, #2
	cmp	r7, #50
	bne	.L2035
	b	.L2033
.L2036:
	ldrb	r0, [sp, #28]	@ zero_extendqisi2
	b	.L2051
.L2043:
	ldr	r6, [sp, #8]
.L2039:
	ldr	r4, .L2052+48
	ldrb	r0, [r4]	@ zero_extendqisi2
	bl	flash_set_interface_mode
	ldrb	r0, [r4]	@ zero_extendqisi2
	bl	nandc_set_if_mode
	b	.L2029
.L2053:
	.align	2
.L2052:
	.word	.LANCHOR14
	.word	.LC117
	.word	.LANCHOR159
	.word	.LANCHOR161
	.word	.LANCHOR46
	.word	-1431655765
	.word	.LC118
	.word	.LC119
	.word	.LANCHOR33
	.word	.LC120
	.word	.LANCHOR163
	.word	.LANCHOR21
	.word	.LANCHOR45
	.size	flash_ddr_tuning_read, .-flash_ddr_tuning_read
	.section	.text.flash_read_page_en,"ax",%progbits
	.align	1
	.global	flash_read_page_en
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_read_page_en, %function
flash_read_page_en:
	@ args = 4, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r8, r3
	ldr	r3, .L2081
	mov	r7, r2
	mov	r5, r0
	mov	r4, r1
	ldr	r10, [sp, #48]
	ldrb	r2, [r3]	@ zero_extendqisi2
	mov	fp, r3
	cmp	r2, r0
	bhi	.L2055
	mov	r2, #404
	ldr	r1, .L2081+4
	ldr	r0, .L2081+8
	bl	printf
.L2055:
	ldr	r3, .L2081+12
	ldrb	r6, [r3, r5]	@ zero_extendqisi2
	ldrb	r3, [fp]	@ zero_extendqisi2
	cmp	r3, r5
	bcs	.L2056
	ldr	r3, .L2081+16
	ldr	r3, [r3]
	lsls	r0, r3, #25
	bmi	.L2057
.L2080:
	mov	r0, #-1
.L2054:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2057:
	mov	r3, r4
	mov	r2, r5
	mov	r1, r6
	ldr	r0, .L2081+20
	bl	printf
	b	.L2080
.L2056:
	tst	r4, #50331648
	bne	.L2059
	ldr	r3, .L2081+24
	ldrb	r2, [r3]	@ zero_extendqisi2
	ldr	r3, .L2081+28
	cbz	r2, .L2060
	ldrb	r2, [r3]	@ zero_extendqisi2
	cbz	r2, .L2059
.L2060:
	ldr	r2, .L2081+32
	mov	r0, r4
	str	r3, [sp, #12]
	ldrh	r5, [r2]
	mov	r1, r5
	bl	__aeabi_uidiv
	mov	r1, r5
	mul	fp, r5, r0
	mov	r0, r4
	bl	__aeabi_uidivmod
	ldr	r3, [sp, #12]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2061
	add	r4, fp, r1, lsl #1
.L2059:
	mov	r1, r4
	str	r10, [sp]
	mov	r3, r8
	mov	r2, r7
	mov	r0, r6
	bl	flash_read_page
	adds	r1, r0, #1
	bne	.L2054
	ldr	r5, .L2081+36
	ldrb	fp, [r5]	@ zero_extendqisi2
	cmp	fp, #0
	bne	.L2062
.L2065:
	ldr	r3, .L2081+40
	ldr	fp, [r3]
	cmp	fp, #0
	bne	.L2063
.L2064:
	ldrb	r3, [r5]	@ zero_extendqisi2
	mov	r2, r4
	movs	r1, #0
	ldr	r0, .L2081+44
	str	r3, [sp]
	mov	r3, #-1
	bl	printf
	ldr	r3, .L2081+48
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L2080
	str	r10, [sp, #48]
	mov	r3, r8
	mov	r2, r7
	mov	r1, r4
	mov	r0, r6
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	flash_ddr_tuning_read
.L2061:
	ldr	r3, .L2081+52
	ldrh	r4, [r3, r1, lsl #1]
	add	r4, r4, fp
	b	.L2059
.L2062:
	movs	r3, #0
	mov	r2, r7
	strb	r3, [r5]
	mov	r1, r4
	str	r10, [sp]
	mov	r3, r8
	mov	r0, r6
	bl	flash_read_page
	adds	r2, r0, #1
	strb	fp, [r5]
	beq	.L2065
	b	.L2054
.L2063:
	mov	r3, r8
	str	r10, [sp]
	mov	r2, r7
	mov	r1, r4
	mov	r0, r6
	blx	fp
	adds	r3, r0, #1
	beq	.L2064
	b	.L2054
.L2082:
	.align	2
.L2081:
	.word	.LANCHOR18
	.word	.LANCHOR164
	.word	.LC0
	.word	.LANCHOR30
	.word	.LANCHOR14
	.word	.LC121
	.word	.LANCHOR0
	.word	.LANCHOR1
	.word	.LANCHOR2
	.word	.LANCHOR48
	.word	.LANCHOR165
	.word	.LC122
	.word	.LANCHOR21
	.word	.LANCHOR3
	.size	flash_read_page_en, .-flash_read_page_en
	.section	.text.flash_get_last_written_page,"ax",%progbits
	.align	1
	.global	flash_get_last_written_page
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_get_last_written_page, %function
flash_get_last_written_page:
	@ args = 4, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r8, r1
	ldr	r1, .L2093
	mov	fp, r2
	mov	r10, r3
	str	r0, [sp, #12]
	ldrh	r4, [r1]
	ldr	r1, .L2093+4
	subs	r4, r4, #1
	ldrh	r6, [r1, #26]
	sxth	r4, r4
	ldr	r1, [sp, #48]
	mul	r6, r8, r6
	str	r1, [sp]
	adds	r1, r4, r6
	bl	flash_read_page_en
	cmp	r0, #512
	bne	.L2084
	movs	r7, #0
.L2085:
	cmp	r7, r4
	ble	.L2088
.L2084:
	ldr	r3, .L2093+8
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L2089
	ldr	r3, [r10]
	mov	r2, r4
	mov	r1, r8
	ldr	r0, .L2093+12
	bl	printf
.L2089:
	mov	r0, r4
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2088:
	adds	r5, r7, r4
	ldr	r3, [sp, #48]
	add	r5, r5, r5, lsr #31
	mov	r2, fp
	ldr	r0, [sp, #12]
	asrs	r5, r5, #1
	str	r3, [sp]
	mov	r3, r10
	sxtah	r1, r6, r5
	bl	flash_read_page_en
	cmp	r0, #512
	itete	eq
	addeq	r4, r5, #-1
	addne	r5, r5, #1
	sxtheq	r4, r4
	sxthne	r7, r5
	b	.L2085
.L2094:
	.align	2
.L2093:
	.word	.LANCHOR142
	.word	.LANCHOR32
	.word	.LANCHOR14
	.word	.LC123
	.size	flash_get_last_written_page, .-flash_get_last_written_page
	.section	.text.flash_get_last_written_page_ext,"ax",%progbits
	.align	1
	.global	flash_get_last_written_page_ext
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_get_last_written_page_ext, %function
flash_get_last_written_page_ext:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r4, r5, lr}
	ldr	r4, .L2096
	ldr	r5, .L2096+4
	ldrb	r4, [r4]	@ zero_extendqisi2
	ldrh	r5, [r5]
	rsb	r4, r4, #24
	str	r3, [sp]
	mov	r3, r2
	mov	r2, r1
	subs	r4, r4, r5
	movs	r5, #1
	lsls	r5, r5, r4
	asr	r4, r0, r4
	subs	r5, r5, #1
	and	r1, r5, r0
	uxtb	r0, r4
	bl	flash_get_last_written_page
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, pc}
.L2097:
	.align	2
.L2096:
	.word	.LANCHOR31
	.word	.LANCHOR68
	.size	flash_get_last_written_page_ext, .-flash_get_last_written_page_ext
	.section	.text.flash_ddr_para_scan,"ax",%progbits
	.align	1
	.global	flash_ddr_para_scan
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_ddr_para_scan, %function
flash_ddr_para_scan:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r7, r0
	ldr	r6, .L2104
	movs	r5, #1
	mov	r8, r1
	ldr	r4, .L2104+4
	ldr	fp, .L2104+8
	ldr	r10, .L2104+12
	ldrb	r0, [r6]	@ zero_extendqisi2
	strb	r5, [r4]
	bl	flash_set_interface_mode
	ldrb	r0, [r6]	@ zero_extendqisi2
	bl	nandc_set_if_mode
	movs	r3, #4
	ldr	r2, [r10]
	str	r3, [sp]
	mov	r1, r8
	ldr	r3, [fp]
	mov	r0, r7
	bl	flash_ddr_tuning_read
	movs	r3, #4
	ldr	r2, [r10]
	str	r3, [sp]
	mov	r1, r8
	ldr	r3, [fp]
	mov	r0, r7
	bl	flash_read_page
	adds	r0, r0, #1
	mov	r3, r4
	bne	.L2099
	ldrb	r2, [r6]	@ zero_extendqisi2
	lsls	r2, r2, #31
	bpl	.L2099
	mov	r0, r5
	bl	flash_set_interface_mode
	mov	r0, r5
	bl	nandc_set_if_mode
	movs	r3, #0
	strb	r3, [r4]
.L2100:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2099:
	movs	r2, #1
	strb	r2, [r3]
	b	.L2100
.L2105:
	.align	2
.L2104:
	.word	.LANCHOR45
	.word	.LANCHOR21
	.word	.LANCHOR166
	.word	.LANCHOR167
	.size	flash_ddr_para_scan, .-flash_ddr_para_scan
	.section	.text.flash_complete_plane_page_read,"ax",%progbits
	.align	1
	.global	flash_complete_plane_page_read
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_complete_plane_page_read, %function
flash_complete_plane_page_read:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L2122
	push	{r0, r1, r2, r4, r5, r6, r7, r8, r10, lr}
	movs	r5, #1
	ldr	r6, .L2122+4
	mov	r8, r2
	mov	r10, r0
	mov	r7, r1
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldrb	r2, [r6]	@ zero_extendqisi2
	rsb	r4, r3, #24
	lsls	r5, r5, r3
	lsr	r3, r0, r4
	subs	r5, r5, #1
	ands	r5, r5, r3
	uxtb	r5, r5
	cmp	r2, r5
	bhi	.L2107
	movw	r2, #909
	ldr	r1, .L2122+8
	ldr	r0, .L2122+12
	bl	printf
.L2107:
	ldrb	r3, [r6]	@ zero_extendqisi2
	cmp	r3, r5
	bls	.L2115
	ldr	r3, .L2122+16
	movs	r0, #1
	lsl	r4, r0, r4
	ldrb	r6, [r3, r5]	@ zero_extendqisi2
	subs	r4, r4, #1
	ldr	r3, .L2122+20
	and	r4, r4, r10
	ubfx	r10, r10, #24, #2
	mov	r0, r6
	ldr	r5, [r3]
	bl	nandc_cs
	cmp	r10, #0
	bne	.L2109
	mov	r0, r4
	bl	slc_phy_page_address_calc
	mov	r4, r0
.L2109:
	ldr	r3, .L2122+24
	uxtb	ip, r4
	lsrs	r0, r4, #8
	lsrs	r2, r4, #16
	ldr	lr, .L2122+36
	ldrb	r3, [r3, #16]	@ zero_extendqisi2
	cmp	r3, #1
	lsl	r3, r6, #8
	bne	.L2110
	add	r3, r3, r5
	movs	r1, #6
.L2121:
	str	r1, [r3, #2056]
	movs	r1, #0
	str	r1, [r3, #2052]
	str	r1, [r3, #2052]
	str	ip, [r3, #2052]
	str	r0, [r3, #2052]
	str	r2, [r3, #2052]
.L2119:
	movs	r2, #224
	str	r2, [r3, #2056]
	ldr	r3, [lr]
	ldrb	r3, [r3, #12]	@ zero_extendqisi2
	cmp	r3, #3
	bne	.L2113
	cmp	r10, #0
	beq	.L2113
	ldr	r3, .L2122+28
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L2113
	add	r4, r4, r4, lsl #1
	add	r10, r10, #-1
	add	r0, r4, r10
.L2120:
	bl	nandc_set_seed
	ldr	r3, .L2122+32
	movs	r1, #0
	mov	r0, r6
	ldrb	r2, [r3, #9]	@ zero_extendqisi2
	mov	r3, r7
	str	r8, [sp]
	bl	nandc_xfer
	bl	nandc_de_cs.constprop.30
.L2106:
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L2110:
	ldr	r1, [lr]
	add	r3, r3, r5
	ldrb	r1, [r1, #12]	@ zero_extendqisi2
	cmp	r1, #3
	bne	.L2112
	movs	r1, #5
	b	.L2121
.L2112:
	movs	r1, #0
	str	r1, [r3, #2056]
	str	r1, [r3, #2052]
	str	r1, [r3, #2052]
	str	ip, [r3, #2052]
	str	r0, [r3, #2052]
	str	r2, [r3, #2052]
	movs	r2, #5
	str	r2, [r3, #2056]
	str	r1, [r3, #2052]
	str	r1, [r3, #2052]
	b	.L2119
.L2113:
	mov	r0, r4
	b	.L2120
.L2115:
	mov	r0, #-1
	b	.L2106
.L2123:
	.align	2
.L2122:
	.word	.LANCHOR31
	.word	.LANCHOR18
	.word	.LANCHOR168
	.word	.LC0
	.word	.LANCHOR30
	.word	.LANCHOR13
	.word	.LANCHOR20
	.word	.LANCHOR35
	.word	.LANCHOR32
	.word	.LANCHOR16
	.size	flash_complete_plane_page_read, .-flash_complete_plane_page_read
	.section	.text.flash_complete_page_read,"ax",%progbits
	.align	1
	.global	flash_complete_page_read
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_complete_page_read, %function
flash_complete_page_read:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r7, r0
	ldr	r3, .L2154
	mov	r8, r1
	ubfx	r5, r0, #24, #2
	str	r2, [sp, #8]
	ldrb	r6, [r3]	@ zero_extendqisi2
	movs	r3, #1
	rsb	r2, r6, #24
	lsl	r4, r3, r2
	lsl	r6, r3, r6
	ldr	r3, .L2154+4
	lsr	r2, r0, r2
	subs	r6, r6, #1
	ands	r6, r6, r2
	subs	r4, r4, #1
	ldrb	r3, [r3]	@ zero_extendqisi2
	uxtb	r6, r6
	ands	r4, r4, r0
	cmp	r3, r6
	bhi	.L2125
	movw	r2, #1033
	ldr	r1, .L2154+8
	ldr	r0, .L2154+12
	bl	printf
.L2125:
	ldr	r3, .L2154+16
	ldrb	r6, [r3, r6]	@ zero_extendqisi2
	ldr	r3, .L2154+20
	mov	r0, r6
	ldr	fp, [r3]
	bl	nandc_cs
	cbnz	r5, .L2126
	mov	r0, r4
	bl	slc_phy_page_address_calc
	mov	r4, r0
.L2126:
	add	r3, fp, r6, lsl #8
	movs	r2, #5
	str	r2, [r3, #2056]
	movs	r2, #0
	str	r2, [r3, #2052]
	str	r2, [r3, #2052]
	uxtb	r2, r4
	str	r2, [r3, #2052]
	lsrs	r2, r4, #8
	str	r2, [r3, #2052]
	lsrs	r2, r4, #16
	str	r2, [r3, #2052]
	movs	r2, #224
	str	r2, [r3, #2056]
	ldr	r3, .L2154+24
	ldr	r3, [r3]
	ldrb	r3, [r3, #12]	@ zero_extendqisi2
	cmp	r3, #3
	bne	.L2127
	cmp	r5, #0
	beq	.L2127
	ldr	r3, .L2154+28
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L2127
	add	r3, r4, r4, lsl #1
	subs	r0, r5, #1
	add	r0, r0, r3
.L2153:
	bl	nandc_set_seed
	ldr	r10, .L2154+56
	movs	r1, #0
	ldr	r3, [sp, #8]
	mov	r0, r6
	ldrb	r2, [r10, #9]	@ zero_extendqisi2
	str	r3, [sp]
	mov	r3, r8
	bl	nandc_xfer
	adds	r1, r0, #1
	bne	.L2129
	ldr	fp, .L2154+44
	ldrb	r3, [fp]	@ zero_extendqisi2
	str	r3, [sp, #12]
	cmp	r3, #0
	beq	.L2130
	movs	r3, #0
	mov	r2, r8
	strb	r3, [fp]
	orr	r1, r4, r5, lsl #24
	ldrb	r3, [r10, #9]	@ zero_extendqisi2
	mov	r0, r6
	str	r3, [sp]
	ldr	r3, [sp, #8]
	bl	flash_read_page
	ldrb	r3, [sp, #12]	@ zero_extendqisi2
	strb	r3, [fp]
	cbnz	r5, .L2131
.L2136:
	ldr	r3, .L2154+32
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2131
	ldr	r3, .L2154+36
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r0, r3, asr #2
	blt	.L2131
	ldrb	r3, [r10, #19]	@ zero_extendqisi2
	subs	r3, r3, #4
	cmp	r3, #4
	it	ls
	movls	r0, #256
.L2124:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2127:
	mov	r0, r4
	b	.L2153
.L2131:
	adds	r2, r0, #1
	bne	.L2124
.L2137:
	ldr	r3, .L2154+40
	ldr	fp, [r3]
	cmp	fp, #0
	bne	.L2133
.L2135:
	ldr	r3, .L2154+44
	mov	r2, r7
	movs	r1, #0
	ldr	r0, .L2154+48
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp]
	mov	r3, #-1
	bl	printf
	ldr	r3, .L2154+52
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L2134
	mov	r0, #-1
	b	.L2124
.L2133:
	ldrb	r3, [r10, #9]	@ zero_extendqisi2
	mov	r2, r8
	orr	r1, r4, r5, lsl #24
	mov	r0, r6
	str	r3, [sp]
	ldr	r3, [sp, #8]
	blx	fp
	adds	r3, r0, #1
	beq	.L2135
	b	.L2124
.L2134:
	ldrb	r3, [r10, #9]	@ zero_extendqisi2
	mov	r2, r8
	orr	r1, r4, r5, lsl #24
	mov	r0, r6
	str	r3, [sp]
	ldr	r3, [sp, #8]
	bl	flash_ddr_tuning_read
	b	.L2124
.L2129:
	cmp	r5, #0
	beq	.L2136
	b	.L2124
.L2130:
	cmp	r5, #0
	bne	.L2137
	b	.L2136
.L2155:
	.align	2
.L2154:
	.word	.LANCHOR31
	.word	.LANCHOR18
	.word	.LANCHOR169
	.word	.LC0
	.word	.LANCHOR30
	.word	.LANCHOR13
	.word	.LANCHOR16
	.word	.LANCHOR35
	.word	.LANCHOR0
	.word	.LANCHOR46
	.word	.LANCHOR165
	.word	.LANCHOR48
	.word	.LC124
	.word	.LANCHOR21
	.word	.LANCHOR32
	.size	flash_complete_page_read, .-flash_complete_page_read
	.section	.text.queue_wait_first_req_completed,"ax",%progbits
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	queue_wait_first_req_completed, %function
queue_wait_first_req_completed:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	ldr	r3, .L2255
	ldrb	r5, [r3]	@ zero_extendqisi2
	cmp	r5, #255
	bne	.L2157
.L2190:
	movs	r6, #0
	b	.L2156
.L2157:
	ldr	r4, .L2255+4
	movs	r3, #48
	mla	r3, r3, r5, r4
	ldrb	r2, [r3, #42]	@ zero_extendqisi2
	ldr	r6, [r3, #24]
	subs	r3, r2, #1
	cmp	r3, #10
	bhi	.L2190
	tbh	[pc, r3, lsl #1]
.L2160:
	.2byte	(.L2159-.L2160)/2
	.2byte	(.L2161-.L2160)/2
	.2byte	(.L2162-.L2160)/2
	.2byte	(.L2162-.L2160)/2
	.2byte	(.L2162-.L2160)/2
	.2byte	(.L2162-.L2160)/2
	.2byte	(.L2163-.L2160)/2
	.2byte	(.L2164-.L2160)/2
	.2byte	(.L2165-.L2160)/2
	.2byte	(.L2162-.L2160)/2
	.2byte	(.L2165-.L2160)/2
	.p2align 1
.L2159:
	movs	r1, #64
	mov	r0, r6
	bl	flash_wait_device_ready
	lsls	r0, r0, #25
	bpl	.L2190
	movs	r3, #48
	mla	r3, r3, r5, r4
	ldr	r2, [r3, #8]
	ldr	r1, [r3, #4]
	cbz	r2, .L2167
	ldrb	r0, [r3, #40]	@ zero_extendqisi2
	ldr	r3, .L2255+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r0, r3
	it	eq
	moveq	r1, r2
.L2167:
	movs	r3, #48
	mov	r0, r6
	mla	r4, r3, r5, r4
	ldr	r2, [r4, #12]
	bl	flash_complete_page_read
	str	r0, [r4, #36]
.L2254:
	movs	r3, #13
	strb	r3, [r4, #42]
	ldrb	r3, [r4, #2]	@ zero_extendqisi2
	orr	r3, r3, #8
	strb	r3, [r4, #2]
	b	.L2190
.L2161:
	movs	r1, #64
	mov	r0, r6
	bl	flash_wait_device_ready
	lsls	r1, r0, #25
	bpl	.L2190
	movs	r3, #48
	mul	r1, r3, r5
	ldrb	r6, [r4, r1]	@ zero_extendqisi2
	adds	r2, r4, r1
	ldr	fp, [r2, #4]
	mla	r3, r3, r6, r4
	ldr	r10, [r3, #4]
	ldr	r3, [r2, #8]
	cbz	r3, .L2168
	ldrb	r1, [r2, #40]	@ zero_extendqisi2
	ldr	r2, .L2255+8
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r1, r2
	it	eq
	moveq	fp, r3
.L2168:
	movs	r3, #48
	mla	r3, r3, r6, r4
	ldr	r2, [r3, #8]
	cbz	r2, .L2169
	ldrb	r1, [r3, #40]	@ zero_extendqisi2
	ldr	r3, .L2255+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r1, r3
	it	eq
	moveq	r10, r2
.L2169:
	movs	r3, #48
	mov	r1, fp
	mla	r7, r3, r5, r4
	str	r3, [sp, #12]
	ldr	r2, [r7, #12]
	ldr	r0, [r7, #24]
	bl	flash_complete_plane_page_read
	ldr	r3, [sp, #12]
	mov	r8, r0
	mov	r1, r10
	mla	r3, r3, r6, r4
	ldr	r2, [r3, #12]
	ldr	r0, [r3, #24]
	bl	flash_complete_plane_page_read
	cmp	r8, #-1
	str	r0, [sp, #12]
	beq	.L2170
	ldr	r3, [r7, #20]
	adds	r2, r3, #1
	beq	.L2171
	ldr	r2, [r7, #12]
	ldr	r2, [r2, #4]
	cmp	r3, r2
	beq	.L2171
.L2170:
	movs	r7, #48
	ldr	r3, .L2255+12
	mla	r7, r7, r5, r4
	ldrb	r3, [r3]	@ zero_extendqisi2
	movs	r0, #1
	ldr	r1, [r7, #24]
	rsb	r2, r3, #24
	lsls	r0, r0, r3
	subs	r3, r0, #1
	lsr	r0, r1, r2
	lsl	ip, r3, r2
	mov	r2, fp
	ands	r0, r0, r3
	ldr	r3, .L2255+8
	bic	r1, r1, ip
	uxtb	r0, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp]
	ldr	r3, [r7, #12]
	bl	flash_read_page_en
	ldr	r2, [r7, #20]
	mov	r8, r0
	adds	r3, r2, #1
	beq	.L2172
	ldr	r3, [r7, #12]
	ldr	r1, [r3, #4]
	cmp	r2, r1
	beq	.L2172
	ldr	r0, .L2255+16
	ldr	r0, [r0]
	lsls	r0, r0, #25
	bpl	.L2172
	str	r1, [sp]
	ldr	r1, [r7, #24]
	ldr	r3, [r3]
	ldr	r0, .L2255+20
	bl	printf
.L2172:
	movs	r3, #48
	mla	r3, r3, r5, r4
	ldr	r2, [r3, #20]
	adds	r0, r2, #1
	beq	.L2171
	ldr	r3, [r3, #12]
	ldr	r3, [r3, #4]
	cmp	r2, r3
	beq	.L2171
	mov	r2, #360
	ldr	r1, .L2255+24
	ldr	r0, .L2255+28
	bl	printf
.L2171:
	movs	r3, #48
	movs	r2, #13
	mla	r5, r3, r5, r4
	strb	r2, [r5, #42]
	ldrb	r2, [r5, #2]	@ zero_extendqisi2
	str	r8, [r5, #36]
	orr	r2, r2, #8
	strb	r2, [r5, #2]
	ldr	r2, [sp, #12]
	adds	r2, r2, #1
	beq	.L2173
	mla	r3, r3, r6, r4
	ldr	r2, [r3, #20]
	adds	r1, r2, #1
	beq	.L2175
	ldr	r3, [r3, #12]
	ldr	r3, [r3, #4]
	cmp	r2, r3
	beq	.L2175
.L2173:
	ldr	r3, .L2255+12
	movs	r5, #48
	mla	r5, r5, r6, r4
	ldrb	r2, [r3]	@ zero_extendqisi2
	movs	r0, #1
	ldr	r1, [r5, #24]
	rsb	r3, r2, #24
	lsls	r0, r0, r2
	mov	r2, r10
	subs	r0, r0, #1
	lsl	r7, r0, r3
	lsr	r3, r1, r3
	ands	r0, r0, r3
	ldr	r3, .L2255+8
	bic	r1, r1, r7
	uxtb	r0, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp]
	ldr	r3, [r5, #12]
	bl	flash_read_page_en
	ldr	r2, [r5, #20]
	adds	r3, r2, #1
	beq	.L2177
	ldr	r3, [r5, #12]
	ldr	r1, [r3, #4]
	cmp	r2, r1
	beq	.L2177
	ldr	r0, .L2255+16
	ldr	r0, [r0]
	lsls	r7, r0, #25
	bpl	.L2177
	str	r1, [sp]
	ldr	r0, .L2255+20
	ldr	r3, [r3]
	ldr	r1, [r5, #24]
	bl	printf
.L2177:
	movs	r3, #48
	mla	r3, r3, r6, r4
	ldr	r2, [r3, #20]
	adds	r0, r2, #1
	beq	.L2175
	ldr	r3, [r3, #12]
	ldr	r3, [r3, #4]
	cmp	r2, r3
	beq	.L2175
	movw	r2, #375
	ldr	r1, .L2255+24
	ldr	r0, .L2255+28
	bl	printf
.L2175:
	movs	r3, #48
	mla	r4, r3, r6, r4
	str	r8, [r4, #36]
	b	.L2254
.L2162:
	movs	r1, #64
	mov	r0, r6
	bl	flash_wait_device_ready
	lsls	r1, r0, #25
	mov	r6, r0
	bpl	.L2190
	ands	r2, r0, #5
	mov	r3, #48
	beq	.L2178
	mla	r4, r3, r5, r4
	movs	r3, #12
	mov	r2, r0
	ldr	r0, .L2255+32
	strb	r3, [r4, #42]
	ldrb	r1, [r4, #1]	@ zero_extendqisi2
	str	r3, [sp]
	ldr	r3, [r4, #24]
	bl	printf
.L2253:
	mov	r3, #-1
	str	r3, [r4, #36]
	b	.L2156
.L2256:
	.align	2
.L2255:
	.word	.LANCHOR56
	.word	.LANCHOR52
	.word	.LANCHOR125
	.word	.LANCHOR31
	.word	.LANCHOR14
	.word	.LC125
	.word	.LANCHOR170
	.word	.LC0
	.word	.LC126
.L2178:
	mla	r6, r3, r5, r4
	movs	r3, #13
	strb	r3, [r6, #42]
	ldr	r3, .L2257
	str	r2, [r6, #36]
	ldr	r3, [r3]
	ldr	r2, [r3, #156]
	ldr	r3, .L2257+4
	cmp	r2, r3
	bne	.L2190
	ldrh	r3, [r6, #34]
	cmp	r3, #0
	bne	.L2190
	ldr	r3, .L2257+8
	movs	r0, #1
	ldr	r1, [r6, #24]
	ldr	r7, .L2257+12
	ldrb	r2, [r3]	@ zero_extendqisi2
	rsb	r3, r2, #24
	lsls	r0, r0, r2
	ldr	r2, .L2257+16
	subs	r0, r0, #1
	lsl	ip, r0, r3
	lsr	r3, r1, r3
	ands	r0, r0, r3
	ldr	r3, .L2257+20
	bic	r1, r1, ip
	uxtb	r0, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp]
	ldr	r3, [r7]
	ldr	r2, [r2]
	bl	flash_read_page_en
	adds	r2, r0, #1
	mov	r3, r0
	beq	.L2179
	ldr	r1, [r6, #12]
	ldr	r2, [r7]
	ldr	r1, [r1]
	ldr	r2, [r2]
	cmp	r1, r2
	beq	.L2190
.L2179:
	movs	r2, #48
	ldr	r0, .L2257+24
	mla	r4, r2, r5, r4
	ldr	r2, .L2257+28
	ldrb	r2, [r2]	@ zero_extendqisi2
	ldrb	r1, [r4, #1]	@ zero_extendqisi2
	str	r2, [sp]
	ldr	r2, [r4, #24]
	bl	printf
	mov	r3, #-1
	str	r3, [r4, #36]
	b	.L2190
.L2165:
	ldr	r7, .L2257+8
	movs	r3, #1
	cmp	r2, #11
	add	r2, r5, r5, lsl #1
	it	eq
	moveq	r0, #10
	ldrb	ip, [r7]	@ zero_extendqisi2
	add	r2, r4, r2, lsl #4
	mov	r10, r7
	it	ne
	movne	r0, #3
	movs	r7, #48
	rsb	r1, ip, #24
	lsl	r3, r3, ip
	lsr	ip, r6, r1
	subs	r3, r3, #1
	and	ip, ip, r3
	uxth	ip, ip
.L2181:
	ldrb	r8, [r2]	@ zero_extendqisi2
	cmp	r8, #255
	bne	.L2188
	mov	r6, #-1
	b	.L2156
.L2188:
	mla	lr, r7, r8, r4
	add	r2, r8, r8, lsl #1
	ldrb	fp, [lr, #42]	@ zero_extendqisi2
	add	r2, r4, r2, lsl #4
	cmp	fp, r0
	bne	.L2181
	ldr	lr, [lr, #24]
	lsr	lr, lr, r1
	and	lr, lr, r3
	cmp	ip, lr
	bne	.L2181
	mov	r0, r6
	movs	r1, #64
	bl	flash_wait_device_ready
	mov	r6, r0
	lsls	r0, r6, #25
	bmi	.L2183
.L2252:
	movs	r6, #0
	b	.L2184
.L2183:
	ands	r3, r6, #15
	mul	r7, r7, r5
	beq	.L2185
	add	r7, r7, r4
	mov	r10, #12
	ldrb	r1, [r7, #1]	@ zero_extendqisi2
	mov	r2, r6
	str	r10, [sp]
	ldr	r3, [r7, #24]
	ldr	r0, .L2257+32
	bl	printf
	mov	r3, #-1
	strb	r10, [r7, #42]
	str	r3, [r7, #36]
.L2184:
	movs	r3, #48
	mla	r5, r3, r5, r4
	mla	r8, r3, r8, r4
	ldrb	r2, [r5, #42]	@ zero_extendqisi2
	ldr	r3, [r5, #36]
	strb	r2, [r8, #42]
	str	r3, [r8, #36]
.L2156:
	mov	r0, r6
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2185:
	adds	r6, r4, r7
	movs	r2, #13
	str	r3, [r6, #36]
	ldr	r3, .L2257
	strb	r2, [r6, #42]
	ldr	r3, [r3]
	ldr	r2, [r3, #156]
	ldr	r3, .L2257+4
	cmp	r2, r3
	bne	.L2252
	ldrh	r3, [r6, #34]
	cmp	r3, #0
	bne	.L2252
	ldrb	r2, [r10]	@ zero_extendqisi2
	movs	r0, #1
	ldr	r1, [r6, #24]
	ldr	r7, .L2257+12
	rsb	r3, r2, #24
	lsls	r0, r0, r2
	ldr	r2, .L2257+16
	subs	r0, r0, #1
	lsl	ip, r0, r3
	lsr	r3, r1, r3
	ands	r0, r0, r3
	ldr	r3, .L2257+20
	bic	r1, r1, ip
	uxtb	r0, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp]
	ldr	r3, [r7]
	ldr	r2, [r2]
	bl	flash_read_page_en
	adds	r1, r0, #1
	mov	r3, r0
	beq	.L2187
	ldr	r1, [r6, #12]
	ldr	r2, [r7]
	ldr	r1, [r1]
	ldr	r2, [r2]
	cmp	r1, r2
	beq	.L2252
.L2187:
	ldr	r2, .L2257+28
	movs	r6, #48
	mla	r6, r6, r5, r4
	ldr	r0, .L2257+36
	ldrb	r2, [r2]	@ zero_extendqisi2
	ldrb	r1, [r6, #1]	@ zero_extendqisi2
	str	r2, [sp]
	ldr	r2, [r6, #24]
	bl	printf
	mov	r3, #-1
	str	r3, [r6, #36]
	b	.L2252
.L2163:
	mov	r0, r6
	movs	r1, #32
	bl	flash_wait_device_ready
	lsls	r2, r0, #26
	mov	r6, r0
	bpl	.L2190
	ands	r2, r0, #15
	mov	r3, #48
	mla	r4, r3, r5, r4
	beq	.L2189
	movs	r3, #12
	strb	r3, [r4, #42]
	b	.L2253
.L2189:
	movs	r3, #13
	str	r2, [r4, #36]
	strb	r3, [r4, #42]
	b	.L2190
.L2164:
	movs	r1, #64
	mov	r0, r6
	bl	flash_wait_device_ready
	lsls	r3, r0, #25
	bpl	.L2190
	movs	r3, #48
	mla	r4, r3, r5, r4
	movs	r3, #7
	str	r0, [r4, #36]
	strb	r3, [r4, #42]
	b	.L2190
.L2258:
	.align	2
.L2257:
	.word	.LANCHOR104
	.word	1145785929
	.word	.LANCHOR31
	.word	.LANCHOR166
	.word	.LANCHOR167
	.word	.LANCHOR125
	.word	.LC127
	.word	.LANCHOR48
	.word	.LC128
	.word	.LC129
	.size	queue_wait_first_req_completed, .-queue_wait_first_req_completed
	.section	.text.sblk_wait_write_queue_completed,"ax",%progbits
	.align	1
	.global	sblk_wait_write_queue_completed
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	sblk_wait_write_queue_completed, %function
sblk_wait_write_queue_completed:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	ldr	r4, .L2262
.L2260:
	ldrb	r3, [r4]	@ zero_extendqisi2
	cmp	r3, #255
	bne	.L2261
	pop	{r4, pc}
.L2261:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2260
.L2263:
	.align	2
.L2262:
	.word	.LANCHOR56
	.size	sblk_wait_write_queue_completed, .-sblk_wait_write_queue_completed
	.section	.text.ftl_read_page,"ax",%progbits
	.align	1
	.global	ftl_read_page
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_read_page, %function
ftl_read_page:
	@ args = 4, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, lr}
	mov	r4, r0
	ldr	r8, [sp, #24]
	mov	r5, r1
	mov	r6, r2
	mov	r7, r3
	bl	sblk_wait_write_queue_completed
	str	r8, [sp, #24]
	mov	r3, r7
	mov	r2, r6
	mov	r1, r5
	mov	r0, r4
	pop	{r4, r5, r6, r7, r8, lr}
	b	flash_read_page_en
	.size	ftl_read_page, .-ftl_read_page
	.section	.text.ftl_read_ppa_page,"ax",%progbits
	.align	1
	.global	ftl_read_ppa_page
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_read_ppa_page, %function
ftl_read_ppa_page:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r4, r5, r6, r7, r8, r10, lr}
	mov	r10, r3
	ldr	r3, .L2266
	mov	r6, r0
	movs	r5, #1
	mov	r7, r1
	mov	r8, r2
	ldrb	r0, [r3]	@ zero_extendqisi2
	rsb	r4, r0, #24
	lsls	r5, r5, r0
	lsr	r4, r6, r4
	subs	r5, r5, #1
	ands	r4, r4, r5
	uxtb	r4, r4
	bl	sblk_wait_write_queue_completed
	str	r10, [sp]
	mov	r3, r8
	mov	r2, r7
	mov	r1, r6
	mov	r0, r4
	bl	flash_read_page_en
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L2267:
	.align	2
.L2266:
	.word	.LANCHOR31
	.size	ftl_read_ppa_page, .-ftl_read_ppa_page
	.section	.text.sblk_read_page,"ax",%progbits
	.align	1
	.global	sblk_read_page
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	sblk_read_page, %function
sblk_read_page:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r7, r0
	sub	sp, sp, #24
	mov	r6, r1
	mov	r4, r0
	mov	r5, r1
.L2269:
	cbnz	r5, .L2279
.L2292:
	ldr	r4, .L2293
.L2280:
	cmp	r6, #0
	bne	.L2282
	mov	r0, r6
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2279:
	ldr	fp, [r4, #24]
	ldrb	r3, [r4]	@ zero_extendqisi2
	str	r3, [sp, #8]
.L2270:
	movs	r1, #0
	mov	r0, fp
	bl	queue_lun_state
	cbnz	r0, .L2271
	cmp	r5, #1
	beq	.L2276
	ldr	r3, .L2293+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L2273
.L2276:
	mov	r0, r4
	bl	queue_read_cmd
	b	.L2274
.L2271:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2270
.L2273:
	ldr	r3, .L2293+8
	movs	r2, #1
	ldrb	r1, [r3]	@ zero_extendqisi2
	rsb	r3, r1, #24
	lsls	r2, r2, r1
	lsr	r3, fp, r3
	subs	r2, r2, #1
	ands	r3, r3, r2
	ldrb	r2, [r4]	@ zero_extendqisi2
	uxth	r3, r3
	cmp	r2, #255
	bne	.L2275
	movw	r2, #661
	ldr	r1, .L2293+12
	ldr	r0, .L2293+16
	str	r3, [sp, #4]
	bl	printf
	ldr	r3, [sp, #4]
.L2275:
	ldrb	r2, [r4]	@ zero_extendqisi2
	movs	r0, #1
	ldr	r8, .L2293
	str	r2, [sp, #12]
	movs	r2, #48
	ldr	r1, [sp, #12]
	muls	r2, r1, r2
	add	r10, r8, r2
	str	r2, [sp, #4]
	ldr	r2, .L2293+8
	ldr	r1, [r10, #24]
	ldrb	ip, [r2]	@ zero_extendqisi2
	rsb	r2, ip, #24
	lsl	r0, r0, ip
	lsr	r2, r1, r2
	subs	r0, r0, #1
	ands	r2, r2, r0
	uxth	r2, r2
	cmp	r3, r2
	bne	.L2276
	ldr	r3, .L2293+20
	ldrh	r3, [r3]
	add	fp, fp, r3
	cmp	r1, fp
	bne	.L2276
	ldr	r3, [sp, #4]
	mov	fp, #255
	ldr	r0, [r4, #24]
	subs	r5, r5, #1
	ldrb	r3, [r8, r3]	@ zero_extendqisi2
	str	r3, [sp, #8]
	bl	flash_start_plane_read
	movs	r2, #2
	movs	r3, #0
	strb	r2, [r4, #42]
	mov	r1, r4
	strb	r3, [r4, #43]
	ldr	r0, .L2293+24
	strb	fp, [r4]
	str	r2, [sp, #20]
	str	r3, [sp, #16]
	bl	buf_add_tail
	ldr	r3, [sp, #16]
	ldr	r2, [sp, #20]
	ldr	r0, .L2293+24
	strb	r3, [r10, #43]
	ldr	r3, [sp, #4]
	strb	r2, [r10, #42]
	strb	fp, [r8, r3]
	ldr	r3, [sp, #12]
	add	r1, r3, r3, lsl #1
	add	r1, r8, r1, lsl #4
	bl	buf_add_tail
.L2274:
	subs	r5, r5, #1
	beq	.L2292
	ldr	r3, [sp, #8]
	add	r4, r3, r3, lsl #1
	ldr	r3, .L2293
	add	r4, r3, r4, lsl #4
	b	.L2269
.L2282:
	ldrb	r3, [r7, #42]	@ zero_extendqisi2
	cmp	r3, #13
	bne	.L2281
	ldrb	r3, [r7]	@ zero_extendqisi2
	subs	r6, r6, #1
	cmp	r3, #255
	itt	ne
	addne	r3, r3, r3, lsl #1
	addne	r7, r4, r3, lsl #4
.L2281:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2280
.L2294:
	.align	2
.L2293:
	.word	.LANCHOR52
	.word	.LANCHOR171
	.word	.LANCHOR31
	.word	.LANCHOR172
	.word	.LC0
	.word	.LANCHOR105
	.word	.LANCHOR56
	.size	sblk_read_page, .-sblk_read_page
	.section	.text.flash_prog_page,"ax",%progbits
	.align	1
	.global	flash_prog_page
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_prog_page, %function
flash_prog_page:
	@ args = 4, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	fp, r3
	ldr	r3, .L2306
	mov	r6, r0
	mov	r7, r1
	mov	r10, r2
	ubfx	r8, r1, #24, #2
	ldr	r4, [r3]
	add	r3, r0, #8
	add	r3, r4, r3, lsl #8
	str	r3, [sp, #4]
	ldr	r3, .L2306+4
	ldrb	r5, [r3]	@ zero_extendqisi2
	rsb	r3, r5, #24
	movs	r5, #1
	lsls	r5, r5, r3
	ldr	r3, .L2306+8
	subs	r5, r5, #1
	ldr	r3, [r3]
	ands	r5, r5, r1
	lsls	r3, r3, #27
	bpl	.L2296
	ldr	r3, [sp, #40]
	mov	r2, r8
	ldr	r0, .L2306+12
	bl	printf
.L2296:
	bl	nandc_wait_flash_ready
	mov	r0, r6
	bl	hynix_reconfig_rr_para
	mov	r0, r6
	bl	nandc_cs
	mov	r0, r6
	cmp	r8, #0
	bne	.L2297
	bl	zftl_flash_enter_slc_mode
.L2298:
	add	r4, r4, r6, lsl #8
	movs	r3, #128
	mov	r0, r5
	str	r3, [r4, #2056]
	movs	r3, #0
	str	r3, [r4, #2052]
	str	r3, [r4, #2052]
	uxtb	r3, r5
	str	r3, [r4, #2052]
	lsrs	r3, r5, #8
	str	r3, [r4, #2052]
	lsrs	r3, r5, #16
	str	r3, [r4, #2052]
	bl	nandc_set_seed
	ldr	r1, .L2306+16
	mov	r2, r10
	mov	r3, fp
	movs	r0, #1
	ldrb	r1, [r1, #9]	@ zero_extendqisi2
	bl	nandc_xfer_start
	bl	nandc_xfer_done
	movs	r0, #200
	bl	udelay
	movs	r3, #16
	str	r3, [r4, #2056]
	bl	nandc_wait_flash_ready
	ldr	r0, [sp, #4]
	bl	flash_read_status
	bl	nandc_de_cs.constprop.30
	ands	r4, r0, #4
	beq	.L2295
	mov	r2, r4
	mov	r1, r7
	ldr	r0, .L2306+20
	bl	printf
.L2295:
	mov	r0, r4
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2297:
	bl	zftl_flash_exit_slc_mode
	b	.L2298
.L2307:
	.align	2
.L2306:
	.word	.LANCHOR13
	.word	.LANCHOR31
	.word	.LANCHOR14
	.word	.LC130
	.word	.LANCHOR32
	.word	.LC131
	.size	flash_prog_page, .-flash_prog_page
	.section	.text.flash_test_blk,"ax",%progbits
	.align	1
	.global	flash_test_blk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_test_blk, %function
flash_test_blk:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, lr}
	movs	r2, #32
	ldr	r7, .L2318
	mov	r6, r0
	mov	r4, r1
	movs	r1, #165
	ldr	r5, .L2318+4
	ldr	r0, [r7]
	bl	ftl_memset
	movs	r2, #8
	movs	r1, #90
	ldr	r0, [r5]
	bl	ftl_memset
	ldr	r3, .L2318+8
	mov	r0, r6
	ldrh	r3, [r3]
	muls	r4, r3, r4
	mov	r1, r4
	bl	flash_erase_block
	adds	r0, r0, #1
	bne	.L2309
.L2311:
	mov	r5, #-1
.L2310:
	mov	r1, r4
	mov	r0, r6
	bl	flash_erase_block
	mov	r0, r5
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L2309:
	ldr	r8, .L2318+12
	mov	r1, r4
	mov	r0, r6
	ldrb	r3, [r8, #9]	@ zero_extendqisi2
	str	r3, [sp]
	ldr	r2, [r7]
	ldr	r3, [r5]
	bl	flash_prog_page
	adds	r0, r0, #1
	beq	.L2311
	ldrb	r3, [r8, #9]	@ zero_extendqisi2
	mov	r1, r4
	mov	r0, r6
	str	r3, [sp]
	ldr	r2, [r7]
	ldr	r3, [r5]
	bl	flash_read_page
	adds	r0, r0, #1
	beq	.L2311
	ldr	r3, [r7]
	ldr	r3, [r3]
	cmp	r3, #-1515870811
	bne	.L2311
	ldr	r3, [r5]
	ldr	r5, [r3]
	subs	r5, r5, #1515870810
	it	ne
	movne	r5, #-1
	b	.L2310
.L2319:
	.align	2
.L2318:
	.word	.LANCHOR159
	.word	.LANCHOR161
	.word	.LANCHOR2
	.word	.LANCHOR32
	.size	flash_test_blk, .-flash_test_blk
	.section	.text.id_block_prog_msb_ff_data,"ax",%progbits
	.align	1
	.global	id_block_prog_msb_ff_data
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	id_block_prog_msb_ff_data, %function
id_block_prog_msb_ff_data:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L2327
	push	{r0, r1, r2, r4, r5, r6, r7, r8, r10, lr}
	mov	r6, r0
	mov	r7, r1
	mov	r4, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L2320
	ldr	r5, .L2327+4
	ldrb	r2, [r5, #19]	@ zero_extendqisi2
	subs	r3, r2, #5
	uxtb	r3, r3
	cmp	r3, #30
	bhi	.L2322
	ldr	r2, .L2327+8
	lsr	r3, r2, r3
	lsls	r3, r3, #31
	bmi	.L2324
.L2320:
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L2325:
	ldrh	r2, [r10, r4, lsl #1]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L2320
	mov	r2, #16384
	movs	r1, #255
	ldr	r0, [r8]
	bl	ftl_memset
	ldrb	r3, [r5, #9]	@ zero_extendqisi2
	adds	r1, r4, r7
	adds	r4, r4, #1
	mov	r0, r6
	uxth	r4, r4
	str	r3, [sp]
	ldr	r3, [r8]
	mov	r2, r3
	bl	flash_prog_page
.L2326:
	ldrh	r3, [r5, #10]
	cmp	r3, r4
	bhi	.L2325
	b	.L2320
.L2322:
	cmp	r2, #68
	bne	.L2320
.L2324:
	ldr	r10, .L2327+12
	ldr	r8, .L2327+16
	b	.L2326
.L2328:
	.align	2
.L2327:
	.word	.LANCHOR19
	.word	.LANCHOR32
	.word	1073758215
	.word	.LANCHOR140
	.word	.LANCHOR159
	.size	id_block_prog_msb_ff_data, .-id_block_prog_msb_ff_data
	.section	.text.flash_dual_page_prog,"ax",%progbits
	.align	1
	.global	flash_dual_page_prog
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_dual_page_prog, %function
flash_dual_page_prog:
	@ args = 12, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	fp, r3
	ldr	r3, .L2343
	mov	r4, r0
	mov	r7, r1
	ubfx	r8, r1, #24, #2
	str	r2, [sp, #8]
	ldr	r6, [r3]
	add	r3, r0, #8
	add	r3, r6, r3, lsl #8
	str	r3, [sp, #4]
	ldr	r3, .L2343+4
	ldrb	r5, [r3]	@ zero_extendqisi2
	ldr	r3, .L2343+8
	rsb	r0, r5, #24
	movs	r5, #1
	ldr	r2, [r3]
	lsls	r5, r5, r0
	str	r3, [sp, #12]
	subs	r5, r5, #1
	tst	r2, #16
	and	r5, r5, r1
	beq	.L2330
	ldr	r3, [sp, #56]
	mov	r2, r8
	ldr	r0, .L2343+12
	bl	printf
.L2330:
	bl	nandc_wait_flash_ready
	mov	r0, r4
	bl	nandc_cs
	mov	r0, r4
	cmp	r8, #0
	bne	.L2331
	bl	zftl_flash_enter_slc_mode
.L2332:
	add	r4, r6, r4, lsl #8
	uxtb	r3, r5
	ldr	r8, .L2343+20
	movs	r6, #0
	mov	r10, #128
	str	r10, [r4, #2056]
	mov	r0, r5
	str	r6, [r4, #2052]
	str	r6, [r4, #2052]
	str	r3, [r4, #2052]
	lsrs	r3, r5, #8
	str	r3, [r4, #2052]
	lsrs	r3, r5, #16
	str	r3, [r4, #2052]
	bl	nandc_set_seed
	mov	r3, fp
	ldr	r2, [sp, #8]
	ldrb	r1, [r8, #9]	@ zero_extendqisi2
	movs	r0, #1
	bl	nandc_xfer_start
	mov	fp, #16
	bl	nandc_xfer_done
	str	fp, [r4, #2056]
	bl	nandc_wait_flash_ready
	adds	r0, r5, #1
	str	r10, [r4, #2056]
	uxtb	r3, r0
	str	r6, [r4, #2052]
	str	r6, [r4, #2052]
	str	r3, [r4, #2052]
	lsrs	r3, r0, #8
	str	r3, [r4, #2052]
	lsr	r3, r0, fp
	str	r3, [r4, #2052]
	bl	nandc_set_seed
	ldr	r3, [sp, #52]
	movs	r0, #1
	ldr	r2, [sp, #48]
	ldrb	r1, [r8, #9]	@ zero_extendqisi2
	bl	nandc_xfer_start
	bl	nandc_xfer_done
	str	fp, [r4, #2056]
	bl	nandc_wait_flash_ready
	ldr	r0, [sp, #4]
	bl	flash_read_status
	bl	nandc_de_cs.constprop.30
	ands	r4, r0, #4
	beq	.L2329
	ldr	r3, [sp, #12]
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L2329
	mov	r2, r4
	mov	r1, r7
	ldr	r0, .L2343+16
	bl	printf
.L2329:
	mov	r0, r4
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2331:
	bl	zftl_flash_exit_slc_mode
	b	.L2332
.L2344:
	.align	2
.L2343:
	.word	.LANCHOR13
	.word	.LANCHOR31
	.word	.LANCHOR14
	.word	.LC130
	.word	.LC131
	.word	.LANCHOR32
	.size	flash_dual_page_prog, .-flash_dual_page_prog
	.section	.text.fw_flash_page_prog.constprop.27,"ax",%progbits
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	fw_flash_page_prog.constprop.27, %function
fw_flash_page_prog.constprop.27:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, lr}
	mov	r5, r1
	ldr	r7, .L2349
	mov	r6, r2
	ldrb	r1, [r7, #9]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	ldr	r3, .L2349+4
	mov	r4, r0
	ldrb	r8, [r3]	@ zero_extendqisi2
	ldr	r3, .L2349+8
	ldrb	r0, [r3]	@ zero_extendqisi2
	bl	nandc_bch_sel
	ldrb	r3, [r7, #7]	@ zero_extendqisi2
	cmp	r3, #9
	bne	.L2346
	ldr	r7, .L2349+12
	mov	r2, #16384
	movs	r1, #255
	ldr	r0, [r7]
	bl	ftl_memset
	ldr	r3, [r7]
	movs	r2, #4
	str	r2, [sp, #8]
	mov	r1, r4
	mov	r2, r5
	movs	r0, #0
	str	r3, [sp, #4]
	str	r3, [sp]
	mov	r3, r6
	bl	flash_dual_page_prog
.L2348:
	mov	r4, r0
	mov	r0, r8
	bl	nandc_bch_sel
	mov	r0, r4
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L2346:
	movs	r3, #4
	mov	r2, r5
	str	r3, [sp]
	mov	r1, r4
	mov	r3, r6
	movs	r0, #0
	bl	flash_prog_page
	b	.L2348
.L2350:
	.align	2
.L2349:
	.word	.LANCHOR32
	.word	.LANCHOR46
	.word	.LANCHOR17
	.word	.LANCHOR159
	.size	fw_flash_page_prog.constprop.27, .-fw_flash_page_prog.constprop.27
	.section	.text.idb_write_data,"ax",%progbits
	.align	1
	.global	idb_write_data
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	idb_write_data, %function
idb_write_data:
	@ args = 0, pretend = 0, frame = 144
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r8, r3
	ldr	r5, .L2473
	adds	r3, r1, r3
	cmp	r3, #63
	sub	sp, sp, #152
	mov	r4, r1
	mov	r7, r2
	ldr	r6, [r5]
	bls	.L2352
	cmp	r1, #576
	bcs	.L2353
	cbnz	r6, .L2354
	mov	r0, #262144
	bl	ftl_malloc
	str	r0, [r5]
	cbnz	r0, .L2355
.L2360:
	mov	r0, #-1
.L2351:
	add	sp, sp, #152
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2355:
	mov	r2, #262144
	mov	r1, r6
	bl	ftl_memset
.L2354:
	ldr	r6, .L2473+4
	ldr	r3, [r6]
	cbz	r3, .L2357
.L2361:
	ldr	r3, .L2473+8
	cmp	r4, #64
	mov	r2, #1
	ldr	r0, [r5]
	str	r2, [r3]
	bhi	.L2467
	rsb	r1, r4, #64
	sub	r2, r8, r1
	add	r1, r7, r1, lsl #9
	lsls	r2, r2, #9
.L2472:
	bl	ftl_memcpy
.L2362:
	movs	r0, #0
	b	.L2351
.L2357:
	mov	r0, #262144
	bl	ftl_malloc
	str	r0, [r6]
	cmp	r0, #0
	bne	.L2361
	b	.L2360
.L2467:
	rsb	r2, r4, #576
	subs	r4, r4, #64
	cmp	r2, r8
	mov	r1, r7
	it	cs
	movcs	r2, r8
	add	r0, r0, r4, lsl #9
	lsls	r2, r2, #9
	b	.L2472
.L2352:
	cmp	r1, #576
	bcc	.L2362
.L2353:
	ldr	r3, .L2473+8
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L2362
	ldr	r2, .L2473+12
	ldr	r7, .L2473+16
	ldrb	r3, [r2]	@ zero_extendqisi2
	mov	r8, r2
	ldrb	r4, [r7, #9]	@ zero_extendqisi2
	ldrh	r5, [r7, #26]
	str	r3, [sp, #24]
	ldr	r3, .L2473+20
	ldrb	r1, [r3]	@ zero_extendqisi2
	mov	r10, r3
	ldr	r3, [sp, #24]
	str	r1, [sp, #32]
	cmp	r3, #0
	beq	.L2363
	ldrh	r3, [sp, #24]
	str	r3, [sp, #44]
	clz	r3, r1
	lsrs	r3, r3, #5
.L2469:
	movs	r0, #0
	str	r3, [sp, #12]
	bl	zftl_flash_exit_slc_mode
	ldrb	r3, [r10]	@ zero_extendqisi2
	strb	r3, [r8]
	ldr	r3, .L2473+24
	ldr	r2, [r6]
	cmp	r2, r3
	bne	.L2366
	ldrh	r0, [r7, #10]
	ldrb	r1, [r7, #12]	@ zero_extendqisi2
	lsls	r0, r0, #2
	bl	__aeabi_idiv
	cmp	r0, #512
	mov	r3, r0
	it	ge
	movge	r3, #512
	add	r1, r6, #260096
	str	r3, [sp, #36]
	movw	r2, #65023
	movs	r3, #0
.L2370:
	ldr	r0, [r1, #-4]!
	cbnz	r0, .L2368
	ldr	r0, [r6, r3, lsl #2]
	adds	r3, r3, #1
	cmp	r3, #4096
	add	r2, r2, #-1
	it	hi
	movhi	r3, #0
	cmp	r2, #4096
	str	r0, [r1, #2048]
	bne	.L2370
.L2368:
	smulbb	r4, r4, r5
	ldr	r3, [sp, #36]
	ldr	r1, [r6, r2, lsl #2]
	ldr	r0, .L2473+28
	bl	printf
	uxth	r3, r4
	str	r3, [sp, #76]
	movs	r3, #0
	str	r3, [sp, #16]
	str	r3, [sp, #28]
.L2411:
	ldr	r3, .L2473+4
	mov	r2, #512
	movs	r1, #0
	ldr	r0, [r3]
	bl	ftl_memset
	ldr	r3, .L2473+32
	ldr	r2, [sp, #28]
	ldr	r3, [r3]
	add	r3, r3, r2
	ldrb	r3, [r3, #32]	@ zero_extendqisi2
	cmp	r3, #255
	beq	.L2371
	ldr	r2, [sp, #76]
	mul	r10, r2, r3
	ldr	r3, [sp, #12]
	cbz	r3, .L2372
	ldr	r3, [sp, #28]
	ldr	r5, .L2473+12
	ldr	r4, .L2473+20
	bic	r3, r3, #2
	cmp	r3, #1
	bne	.L2373
	ldrb	r3, [sp, #44]	@ zero_extendqisi2
.L2470:
	strb	r3, [r5]
	strb	r3, [r4]
.L2372:
	ldr	r8, .L2473+16
	movs	r5, #0
	ldr	r3, .L2473+36
	mov	r0, r10
	ldrb	r7, [r8, #9]	@ zero_extendqisi2
	ldrh	r4, [r8, #26]
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r1, r7
	str	r3, [sp, #80]
	smulbb	r4, r4, r7
	ldr	r3, .L2473+36
	uxth	r4, r4
	strb	r5, [r3]
	bl	__aeabi_uidiv
	mov	r1, r0
	mov	r0, r5
	bl	flash_erase_block
	mov	r1, r4
	mov	r0, r10
	bl	__aeabi_uidivmod
	ldrh	r0, [r8, #10]
	sub	r3, r10, r1
	str	r1, [sp, #48]
	ldrb	r1, [r8, #12]	@ zero_extendqisi2
	str	r3, [sp, #40]
	lsls	r0, r0, #2
	bl	__aeabi_idiv
	ldr	r3, [sp, #40]
	str	r0, [sp, #52]
	cmp	r10, r3
	bne	.L2419
	ldr	r3, .L2473+40
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #9
	bne	.L2419
	ldr	r3, .L2473+4
	mov	r2, #1024
	mov	r1, r5
	ldr	r4, [r3]
	mov	r0, r4
	bl	ftl_memset
	ldr	r2, .L2473+44
	movs	r3, #12
	str	r5, [r4, #12]
	strb	r5, [r4, #16]
	stm	r4, {r2, r3}
	ldr	r3, .L2473+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2375
	ldrb	r3, [r8, #29]	@ zero_extendqisi2
	strb	r3, [r4, #16]
.L2375:
	movs	r3, #4
	strb	r3, [r4, #17]
	ldr	r3, .L2473+16
	ldrb	r1, [r3, #12]	@ zero_extendqisi2
	ldrh	r0, [r3, #10]
	bl	__aeabi_idiv
	cmp	r7, #8
	mov	r3, #0
	ite	hi
	movhi	r2, #70
	movls	r2, #16
	movs	r1, #12
	strh	r0, [r4, #18]	@ movhi
	strb	r3, [r4, #20]
	adds	r0, r4, r1
	strh	r3, [r4, #22]	@ movhi
	strb	r2, [r4, #21]
	bl	js_hash
	ldr	r3, [sp, #36]
	str	r0, [r4, #8]
	subs	r3, r3, #4
	str	r3, [sp, #20]
.L2374:
	mov	r8, r6
	mov	fp, #0
.L2377:
	ldr	r3, [sp, #52]
	cmp	r3, fp
	bhi	.L2388
	ldr	r3, .L2473+4
	movs	r4, #0
	mov	r0, r10
	movs	r7, #4
	ldr	r5, [r3]
	ldr	r3, .L2473+16
	ldrb	r2, [r3, #9]	@ zero_extendqisi2
	ldrh	r1, [r3, #26]
	str	r2, [sp, #68]
	ldrh	r3, [sp, #68]
	smulbb	r1, r1, r3
	ldr	r3, .L2473+36
	uxth	r1, r1
	strb	r4, [r3]
	bl	__aeabi_uidivmod
	sub	r3, r10, r1
	str	r1, [sp, #40]
	str	r3, [sp, #72]
	and	r3, r1, #3
	str	r3, [sp, #48]
	ldr	r3, [sp, #20]
	str	r4, [sp, #56]
	str	r3, [sp, #60]
.L2389:
	ldr	r3, [sp, #60]
	cmp	r4, r3
	bcc	.L2405
	ldr	r3, .L2473+36
	ldrb	r2, [sp, #80]	@ zero_extendqisi2
	strb	r2, [r3]
	ldr	r3, [sp, #12]
	cbz	r3, .L2406
	movs	r0, #0
	bl	zftl_flash_exit_slc_mode
	ldr	r2, .L2473+12
	movs	r3, #0
	strb	r3, [r2]
	ldr	r2, .L2473+20
	strb	r3, [r2]
.L2406:
	ldr	r3, [sp, #20]
	movs	r4, #0
	lsls	r1, r3, #7
	ldr	r3, .L2473+4
	ldr	r0, [r3]
.L2407:
	cmp	r4, r1
	bne	.L2409
	ldr	r3, [sp, #16]
	adds	r3, r3, #1
	cmp	r3, #5
	str	r3, [sp, #16]
	bls	.L2371
	b	.L2415
.L2363:
	ldr	r3, [sp, #32]
	cmp	r3, #3
	iteet	ne
	ldrne	r3, [sp, #24]
	streq	r3, [sp, #44]
	moveq	r3, #2
	strne	r3, [sp, #44]
	b	.L2469
.L2373:
	movs	r0, #0
	bl	zftl_flash_exit_slc_mode
	movs	r3, #0
	b	.L2470
.L2474:
	.align	2
.L2473:
	.word	.LANCHOR137
	.word	.LANCHOR139
	.word	.LANCHOR138
	.word	.LANCHOR0
	.word	.LANCHOR32
	.word	.LANCHOR19
	.word	-52655045
	.word	.LC132
	.word	.LANCHOR27
	.word	.LANCHOR48
	.word	.LANCHOR28
	.word	1179535694
.L2419:
	ldr	r3, [sp, #36]
	mov	r4, r5
	str	r3, [sp, #20]
	b	.L2374
.L2388:
	ldr	r3, [sp, #48]
	add	r5, r3, fp
	ldr	r3, .L2475
	lsrs	r5, r5, #2
	adds	r2, r5, #1
	ldrh	r0, [r3, r2, lsl #1]
	ldr	r3, .L2475+4
	ldrb	r1, [r3]	@ zero_extendqisi2
	cmp	r1, #0
	bne	.L2378
	mov	r2, r0
.L2379:
	ldr	r0, .L2475+8
	ldr	r3, .L2475
	ldrb	r0, [r0]	@ zero_extendqisi2
	cmp	r0, #9
	itt	ne
	addne	r2, r2, #-1
	lslne	r2, r2, #2
	str	r2, [sp, #88]
	movw	r2, #61424
	str	r2, [sp, #92]
	ldrh	r2, [r3, r5, lsl #1]
	cbnz	r1, .L2383
	mov	r5, r2
.L2384:
	mul	r0, r5, r7
	add	r2, sp, #88
	cbnz	r4, .L2385
	ldr	r3, [sp, #40]
	mov	r1, r8
	add	r0, r0, r3
	bl	fw_flash_page_prog.constprop.27
	ldr	r3, .L2475+4
	ldrb	r2, [r3]	@ zero_extendqisi2
	cbnz	r2, .L2386
	adds	r5, r5, #1
	mov	r1, r7
	uxth	r5, r5
	ldr	r0, [sp, #40]
	bl	__aeabi_uidiv
	mov	r2, r5
	mov	r1, r0
	mov	r0, r4
	bl	id_block_prog_msb_ff_data
.L2386:
	ldr	r3, [sp, #20]
	add	r8, r8, #2048
	add	r2, r3, #16
	cmp	fp, r2
	bcc	.L2387
	add	r2, r3, #20
	cmp	fp, r2
	bcs	.L2387
	add	r8, r6, #2048
.L2387:
	add	r3, fp, #4
	movs	r4, #0
	uxth	fp, r3
	b	.L2377
.L2378:
	ldr	r0, .L2475+12
	ldrb	r0, [r0]	@ zero_extendqisi2
	cmp	r0, #0
	beq	.L2379
	lsls	r2, r2, #1
	b	.L2379
.L2383:
	ldr	r2, .L2475+12
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, #0
	beq	.L2384
	lsls	r5, r5, #1
	b	.L2384
.L2385:
	ldr	r3, [sp, #40]
	mov	r1, r4
	add	r0, r0, r3
	bl	fw_flash_page_prog.constprop.27
	b	.L2387
.L2405:
	ldr	r3, [sp, #48]
	mov	r1, r7
	subs	r3, r7, r3
	uxth	r3, r3
	str	r3, [sp, #52]
	ldr	r3, [sp, #40]
	adds	r0, r3, r4
	bl	__aeabi_uidiv
	ldr	r2, .L2475+4
	uxth	r0, r0
	ldr	r3, .L2475
	ldrb	r2, [r2]	@ zero_extendqisi2
	ldrh	r3, [r3, r0, lsl #1]
	cmp	r2, #0
	bne	.L2390
	mov	r0, r3
.L2391:
	ldr	r3, .L2475+16
	ldr	r2, [sp, #72]
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp, #64]
	ldr	r3, [sp, #48]
	add	r3, r3, r2
	ldr	r2, .L2475+20
	ldrb	r1, [r2, #9]	@ zero_extendqisi2
	ldr	r2, [sp, #68]
	mla	r0, r0, r2, r3
	bl	__aeabi_uidiv
	ldr	r3, .L2475+24
	mov	r8, r0
	ldr	r0, [sp, #64]
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp, #84]
	bl	nandc_bch_sel
.L2392:
	str	r7, [sp]
	add	r3, sp, #88
	mov	r2, r5
	mov	r1, r8
	movs	r0, #0
	bl	flash_read_page
	adds	r0, r0, #1
	bne	.L2393
	ldr	r3, .L2475+28
	ldrb	fp, [r3]	@ zero_extendqisi2
	cmp	fp, #0
	bne	.L2394
.L2397:
	ldr	r3, .L2475+32
	ldr	fp, [r3]
	cmp	fp, #0
	bne	.L2395
.L2396:
	ldr	r3, .L2475+36
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2399
	str	r7, [sp]
	add	r3, sp, #88
	mov	r2, r5
	mov	r1, r8
	movs	r0, #0
	bl	flash_ddr_tuning_read
	adds	r0, r0, #1
	bne	.L2393
.L2399:
	ldr	r3, [sp, #64]
	cmp	r3, #16
	bne	.L2400
	mov	r8, #-1
.L2401:
	ldr	r0, [sp, #84]
	bl	nandc_bch_sel
	ldr	r3, [sp, #56]
	cmp	r8, #0
	it	ne
	movne	r3, #-1
	str	r3, [sp, #56]
	ldr	r3, [sp, #72]
	cmp	r10, r3
	bne	.L2403
	cmp	r4, #0
	bne	.L2403
	ldr	r3, [sp, #56]
	cmp	r3, #0
	bne	.L2403
	ldr	r2, [r5]
	ldr	r3, .L2475+40
	cmp	r2, r3
	bne	.L2403
	ldr	r3, [sp, #60]
	ldr	r2, [sp, #52]
	ldrb	r7, [r5, #17]	@ zero_extendqisi2
	add	r3, r3, r2
	str	r3, [sp, #60]
.L2404:
	ldr	r3, [sp, #52]
	add	r3, r3, r4
	uxth	r4, r3
	b	.L2389
.L2390:
	ldr	r3, .L2475+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L2391
	lsls	r0, r0, #1
	b	.L2391
.L2394:
	ldr	r3, .L2475+28
	movs	r0, #0
	mov	r2, r5
	mov	r1, r8
	strb	r0, [r3]
	add	r3, sp, #88
	str	r7, [sp]
	bl	flash_read_page
	ldr	r3, .L2475+28
	adds	r0, r0, #1
	strb	fp, [r3]
	beq	.L2397
.L2393:
	mov	r8, #0
	b	.L2401
.L2395:
	str	r7, [sp]
	add	r3, sp, #88
	mov	r2, r5
	mov	r1, r8
	movs	r0, #0
	blx	fp
	adds	r0, r0, #1
	beq	.L2396
	b	.L2393
.L2400:
	movs	r0, #16
	bl	nandc_bch_sel
	movs	r3, #16
	str	r3, [sp, #64]
	b	.L2392
.L2403:
	ldr	r3, [sp, #52]
	add	r5, r5, r3, lsl #9
	movs	r3, #0
	str	r3, [sp, #48]
	b	.L2404
.L2409:
	ldr	r2, [r0, r4, lsl #2]
	ldr	r3, [r6, r4, lsl #2]
	cmp	r2, r3
	beq	.L2408
	mov	r2, #512
	movs	r1, #0
	bl	ftl_memset
	mov	r1, r4
	ldr	r0, .L2475+44
	bl	printf
	mov	r1, r10
	movs	r0, #0
	bl	flash_erase_block
.L2371:
	ldr	r3, [sp, #28]
	adds	r3, r3, #1
	cmp	r3, #4
	str	r3, [sp, #28]
	bne	.L2411
.L2415:
	movs	r0, #0
	bl	zftl_flash_exit_slc_mode
	ldr	r3, .L2475+48
	ldrb	r2, [sp, #24]	@ zero_extendqisi2
	strb	r2, [r3]
	ldr	r3, [sp, #12]
	cbz	r3, .L2412
	ldr	r3, .L2475+4
	ldrb	r2, [sp, #32]	@ zero_extendqisi2
	strb	r2, [r3]
.L2412:
	ldr	r3, .L2475+52
	movs	r2, #2
	movs	r0, #0
	strb	r2, [r3]
	bl	zftl_flash_enter_slc_mode
	ldr	r3, [sp, #16]
	cbnz	r3, .L2366
	mov	r1, r3
	ldr	r0, .L2475+56
	bl	printf
.L2366:
	ldr	r4, .L2475+60
	movs	r5, #0
	ldr	r3, .L2475+64
	ldr	r0, [r4]
	str	r5, [r3]
	cbz	r0, .L2414
	bl	free
	str	r5, [r4]
.L2414:
	ldr	r4, .L2475+68
	ldr	r0, [r4]
	cmp	r0, #0
	beq	.L2362
	bl	free
	movs	r0, #0
	str	r0, [r4]
	b	.L2351
.L2408:
	adds	r4, r4, #1
	b	.L2407
.L2476:
	.align	2
.L2475:
	.word	.LANCHOR3
	.word	.LANCHOR19
	.word	.LANCHOR28
	.word	.LANCHOR1
	.word	.LANCHOR17
	.word	.LANCHOR32
	.word	.LANCHOR46
	.word	.LANCHOR48
	.word	.LANCHOR165
	.word	.LANCHOR21
	.word	1179535694
	.word	.LC133
	.word	.LANCHOR0
	.word	.LANCHOR33
	.word	.LC134
	.word	.LANCHOR137
	.word	.LANCHOR138
	.word	.LANCHOR139
	.size	idb_write_data, .-idb_write_data
	.section	.text.flash_start_tlc_page_prog,"ax",%progbits
	.align	1
	.global	flash_start_tlc_page_prog
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_start_tlc_page_prog, %function
flash_start_tlc_page_prog:
	@ args = 12, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	fp, r3
	mov	r7, r2
	ldr	r3, [sp, #44]
	mov	r4, r0
	mov	r6, r1
	ldr	r2, .L2484
	str	r3, [sp]
	ldr	r5, [sp, #40]
	ldrb	r3, [r2]	@ zero_extendqisi2
	mov	r8, r2
	ldr	r10, [sp, #48]
	cmp	r3, fp
	bhi	.L2478
	mov	r2, #740
	ldr	r1, .L2484+4
	ldr	r0, .L2484+8
	bl	printf
.L2478:
	ldrb	r3, [r8]	@ zero_extendqisi2
	cmp	r3, fp
	bls	.L2477
	ldr	r3, .L2484+12
	ldrb	fp, [r3, fp]	@ zero_extendqisi2
	ldr	r3, .L2484+16
	mov	r0, fp
	ldr	r3, [r3]
	lsl	fp, fp, #8
	str	r3, [sp, #4]
	bl	nandc_cs
	ldr	r3, [sp, #4]
	cbz	r4, .L2480
	add	r2, r3, fp
	str	r4, [r2, #2056]
.L2480:
	add	fp, fp, r3
	movs	r3, #128
	str	r6, [fp, #2056]
	str	r3, [fp, #2056]
	movs	r3, #0
	str	r3, [fp, #2052]
	str	r3, [fp, #2052]
	uxtb	r3, r5
	str	r3, [fp, #2052]
	lsrs	r3, r5, #8
	str	r3, [fp, #2052]
	lsrs	r3, r5, #16
	add	r5, r5, r5, lsl #1
	str	r3, [fp, #2052]
	subs	r0, r5, #1
	add	r0, r0, r6
	bl	nandc_set_seed
	ldr	r1, .L2484+20
	mov	r3, r10
	ldr	r2, [sp]
	movs	r0, #1
	ldrb	r1, [r1, #9]	@ zero_extendqisi2
	bl	nandc_xfer_start
	bl	nandc_xfer_done
	str	r7, [fp, #2056]
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	nandc_de_cs.constprop.30
.L2477:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2485:
	.align	2
.L2484:
	.word	.LANCHOR18
	.word	.LANCHOR173
	.word	.LC0
	.word	.LANCHOR30
	.word	.LANCHOR13
	.word	.LANCHOR32
	.size	flash_start_tlc_page_prog, .-flash_start_tlc_page_prog
	.section	.text.queue_tlc_prog_cmd,"ax",%progbits
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	queue_tlc_prog_cmd, %function
queue_tlc_prog_cmd:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L2487
	push	{r4, r5, r6, r7, lr}
	mov	r6, r0
	ldr	r2, [r0]
	movs	r7, #1
	sub	sp, sp, #20
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldr	r1, [r2, #24]
	rsb	r0, r3, #24
	lsl	r5, r7, r0
	lsl	r4, r7, r3
	ldr	r3, [r2, #12]
	subs	r5, r5, #1
	subs	r4, r4, #1
	ands	r5, r5, r1
	lsrs	r1, r1, r0
	ldrb	r0, [r2, #44]	@ zero_extendqisi2
	ands	r4, r4, r1
	str	r3, [sp, #8]
	ldr	r3, [r2, #4]
	uxtb	r4, r4
	mov	r1, r7
	str	r5, [sp]
	movs	r2, #26
	str	r3, [sp, #4]
	mov	r3, r4
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldm	r6, {r2, r3}
	movs	r1, #2
	ldrb	r0, [r2, #44]	@ zero_extendqisi2
	ldr	r2, [r3, #12]
	str	r2, [sp, #8]
	movs	r2, #26
	ldr	r3, [r3, #4]
	str	r5, [sp]
	str	r3, [sp, #4]
	mov	r3, r4
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	r3, [r6, #8]
	movs	r1, #3
	ldr	r2, [r6]
	ldrb	r0, [r2, #44]	@ zero_extendqisi2
	ldr	r2, [r3, #12]
	str	r2, [sp, #8]
	movs	r2, #16
	ldr	r3, [r3, #4]
	str	r5, [sp]
	str	r3, [sp, #4]
	mov	r3, r4
	bl	flash_start_tlc_page_prog
	ldr	r1, [r6]
	movs	r3, #4
	ldr	r0, .L2487+4
	strb	r3, [r1, #42]
	movs	r3, #255
	strb	r7, [r1, #43]
	strb	r3, [r1]
	add	sp, sp, #20
	@ sp needed
	pop	{r4, r5, r6, r7, lr}
	b	buf_add_tail
.L2488:
	.align	2
.L2487:
	.word	.LANCHOR31
	.word	.LANCHOR56
	.size	queue_tlc_prog_cmd, .-queue_tlc_prog_cmd
	.section	.text.sblk_tlc_prog_one_page,"ax",%progbits
	.align	1
	.global	sblk_tlc_prog_one_page
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	sblk_tlc_prog_one_page, %function
sblk_tlc_prog_one_page:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, [r0]
	push	{r4, r5, r6, lr}
	mov	r5, r0
	ldr	r6, [r3, #24]
.L2490:
	movs	r1, #1
	mov	r0, r6
	bl	queue_lun_state
	mov	r4, r0
	cbnz	r0, .L2491
	mov	r0, r5
	bl	queue_tlc_prog_cmd
	mov	r0, r4
	pop	{r4, r5, r6, pc}
.L2491:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2490
	.size	sblk_tlc_prog_one_page, .-sblk_tlc_prog_one_page
	.section	.text.sblk_xlc_prog_pages,"ax",%progbits
	.align	1
	.global	sblk_xlc_prog_pages
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	sblk_xlc_prog_pages, %function
sblk_xlc_prog_pages:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r5, r0
	ldr	r3, [r0]
	mov	r8, r1
	mov	fp, r2
	ldr	r4, [r3, #24]
.L2493:
	movs	r1, #1
	mov	r0, r4
	bl	queue_lun_state
	cmp	r0, #0
	bne	.L2494
	cmp	fp, #2
	bne	.L2495
	ldr	r3, .L2497
	movs	r7, #1
	ldr	r2, [r5]
	ldr	r0, [r8]
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldr	r1, [r2, #24]
	ldr	r0, [r0, #24]
	rsb	ip, r3, #24
	lsl	r6, r7, ip
	lsl	r4, r7, r3
	ldr	r3, [r2, #12]
	subs	r6, r6, #1
	subs	r4, r4, #1
	and	r10, r1, r6
	lsr	r1, r1, ip
	ands	r6, r6, r0
	ldrb	r0, [r2, #44]	@ zero_extendqisi2
	ands	r4, r4, r1
	str	r3, [sp, #8]
	ldr	r3, [r2, #4]
	uxtb	r4, r4
	movs	r2, #17
	str	r10, [sp]
	mov	r1, r7
	str	r3, [sp, #4]
	mov	r3, r4
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	r3, [r8]
	mov	r1, r7
	ldr	r2, [r5]
	ldrb	r0, [r2, #44]	@ zero_extendqisi2
	ldr	r2, [r3, #12]
	str	r2, [sp, #8]
	movs	r2, #26
	ldr	r3, [r3, #4]
	str	r6, [sp]
	str	r3, [sp, #4]
	mov	r3, r4
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldm	r5, {r2, r3}
	mov	r1, fp
	ldrb	r0, [r2, #44]	@ zero_extendqisi2
	ldr	r2, [r3, #12]
	str	r2, [sp, #8]
	movs	r2, #17
	ldr	r3, [r3, #4]
	str	r10, [sp]
	str	r3, [sp, #4]
	mov	r3, r4
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	r3, [r8, #4]
	mov	r1, fp
	ldr	r2, [r5]
	ldrb	r0, [r2, #44]	@ zero_extendqisi2
	ldr	r2, [r3, #12]
	str	r2, [sp, #8]
	movs	r2, #26
	ldr	r3, [r3, #4]
	str	r6, [sp]
	str	r3, [sp, #4]
	mov	r3, r4
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	r3, [r5, #8]
	movs	r1, #3
	ldr	r2, [r5]
	ldrb	r0, [r2, #44]	@ zero_extendqisi2
	ldr	r2, [r3, #12]
	str	r2, [sp, #8]
	movs	r2, #17
	ldr	r3, [r3, #4]
	str	r10, [sp]
	str	r3, [sp, #4]
	mov	r3, r4
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	r3, [r8, #8]
	movs	r1, #3
	ldr	r2, [r5]
	ldrb	r0, [r2, #44]	@ zero_extendqisi2
	ldr	r2, [r3, #12]
	str	r2, [sp, #8]
	movs	r2, #16
	ldr	r3, [r3, #4]
	str	r6, [sp]
	str	r3, [sp, #4]
	mov	r3, r4
	bl	flash_start_tlc_page_prog
	ldr	r1, [r5]
	movs	r3, #5
	ldr	r0, .L2497+4
	strb	r3, [r1, #42]
	movs	r3, #255
	strb	r7, [r1, #43]
	strb	r3, [r1]
	bl	buf_add_tail
.L2496:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2494:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2493
.L2495:
	mov	r0, r5
	bl	queue_tlc_prog_cmd
	b	.L2496
.L2498:
	.align	2
.L2497:
	.word	.LANCHOR31
	.word	.LANCHOR56
	.size	sblk_xlc_prog_pages, .-sblk_xlc_prog_pages
	.section	.text.sblk_3d_tlc_dump_prog,"ax",%progbits
	.align	1
	.global	sblk_3d_tlc_dump_prog
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	sblk_3d_tlc_dump_prog, %function
sblk_3d_tlc_dump_prog:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r2, .L2500
	push	{r4, r5, r6, r7, lr}
	movs	r7, #1
	ldr	r3, [r0, #24]
	sub	sp, sp, #20
	mov	r5, r0
	ldrb	r2, [r2]	@ zero_extendqisi2
	ldr	r0, .L2500+4
	rsb	r1, r2, #24
	lsl	r6, r7, r1
	lsl	r4, r7, r2
	lsr	r1, r3, r1
	subs	r6, r6, #1
	ands	r6, r6, r3
	subs	r4, r4, #1
	mov	r2, r3
	ands	r4, r4, r1
	mov	r1, r6
	uxtb	r4, r4
	bl	printf
	ldr	r3, [r5, #12]
	mov	r1, r7
	movs	r2, #26
	str	r6, [sp]
	movs	r0, #0
	str	r3, [sp, #8]
	ldr	r3, [r5, #4]
	str	r3, [sp, #4]
	mov	r3, r4
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	r3, [r5, #12]
	movs	r2, #26
	movs	r1, #2
	str	r6, [sp]
	movs	r0, #0
	str	r3, [sp, #8]
	ldr	r3, [r5, #4]
	str	r3, [sp, #4]
	mov	r3, r4
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	r3, [r5, #12]
	movs	r2, #16
	movs	r1, #3
	str	r6, [sp]
	movs	r0, #0
	str	r3, [sp, #8]
	ldr	r3, [r5, #4]
	str	r3, [sp, #4]
	mov	r3, r4
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	movs	r1, #64
	ldr	r0, [r5, #24]
	add	sp, sp, #20
	@ sp needed
	pop	{r4, r5, r6, r7, lr}
	b	flash_wait_device_ready
.L2501:
	.align	2
.L2500:
	.word	.LANCHOR31
	.word	.LC135
	.size	sblk_3d_tlc_dump_prog, .-sblk_3d_tlc_dump_prog
	.section	.text.flash_start_3d_mlc_page_prog,"ax",%progbits
	.align	1
	.global	flash_start_3d_mlc_page_prog
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_start_3d_mlc_page_prog, %function
flash_start_3d_mlc_page_prog:
	@ args = 4, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, lr}
	mov	r5, r2
	ldr	r4, .L2505
	mov	r7, r0
	mov	r6, r1
	mov	r8, r3
	ldrb	r2, [r4]	@ zero_extendqisi2
	cmp	r2, r1
	bhi	.L2503
	mov	r2, #772
	ldr	r1, .L2505+4
	ldr	r0, .L2505+8
	bl	printf
.L2503:
	ldrb	r3, [r4]	@ zero_extendqisi2
	cmp	r3, r6
	bls	.L2502
	ldr	r3, .L2505+12
	ldrb	r4, [r3, r6]	@ zero_extendqisi2
	ldr	r3, .L2505+16
	mov	r0, r4
	ldr	r6, [r3]
	bl	nandc_cs
	movs	r3, #128
	mov	r0, r5
	add	r4, r6, r4, lsl #8
	str	r3, [r4, #2056]
	movs	r3, #0
	str	r3, [r4, #2052]
	str	r3, [r4, #2052]
	uxtb	r3, r5
	str	r3, [r4, #2052]
	lsrs	r3, r5, #8
	str	r3, [r4, #2052]
	lsrs	r3, r5, #16
	str	r3, [r4, #2052]
	bl	nandc_set_seed
	ldr	r1, .L2505+20
	mov	r2, r8
	ldr	r3, [sp, #24]
	movs	r0, #1
	ldrb	r1, [r1, #9]	@ zero_extendqisi2
	bl	nandc_xfer_start
	bl	nandc_xfer_done
	str	r7, [r4, #2056]
.L2502:
	pop	{r4, r5, r6, r7, r8, pc}
.L2506:
	.align	2
.L2505:
	.word	.LANCHOR18
	.word	.LANCHOR174
	.word	.LC0
	.word	.LANCHOR30
	.word	.LANCHOR13
	.word	.LANCHOR32
	.size	flash_start_3d_mlc_page_prog, .-flash_start_3d_mlc_page_prog
	.section	.text.sblk_3d_mlc_prog_pages,"ax",%progbits
	.align	1
	.global	sblk_3d_mlc_prog_pages
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	sblk_3d_mlc_prog_pages, %function
sblk_3d_mlc_prog_pages:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r7, r1
	ldr	r10, .L2512
	add	r5, r0, #8
	ldr	fp, .L2512+4
.L2508:
	cbnz	r7, .L2511
	mov	r0, r7
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2511:
	ldr	r3, [r5, #-8]
	ldr	r4, [r3, #24]
.L2509:
	movs	r1, #1
	mov	r0, r4
	bl	queue_lun_state
	cmp	r0, #0
	bne	.L2510
	ldr	r3, [r5, #-8]
	mov	r8, #1
	subs	r7, r7, #1
	adds	r5, r5, #8
	ldr	r2, [r3, #24]
	ldrb	r3, [r10]	@ zero_extendqisi2
	rsb	r1, r3, #24
	lsl	r6, r8, r1
	lsl	r4, r8, r3
	subs	r6, r6, #1
	subs	r4, r4, #1
	ands	r6, r6, r2
	lsrs	r2, r2, r1
	ands	r4, r4, r2
	uxtb	r4, r4
	mov	r0, r4
	bl	zftl_flash_exit_slc_mode
	ldr	r3, [r5, #-16]
	mov	r1, r4
	movs	r0, #16
	ldr	r2, [r3, #12]
	str	r2, [sp]
	mov	r2, r6
	ldr	r3, [r3, #4]
	bl	flash_start_3d_mlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	r3, [r5, #-12]
	mov	r1, r4
	movs	r0, #16
	ldr	r2, [r3, #12]
	str	r2, [sp]
	add	r2, r6, r8
	ldr	r3, [r3, #4]
	bl	flash_start_3d_mlc_page_prog
	bl	nandc_de_cs.constprop.30
	ldr	r1, [r5, #-16]
	movs	r3, #4
	mov	r0, fp
	strb	r3, [r1, #42]
	movs	r3, #255
	strb	r8, [r1, #43]
	strb	r3, [r1]
	bl	buf_add_tail
	b	.L2508
.L2510:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2509
.L2513:
	.align	2
.L2512:
	.word	.LANCHOR31
	.word	.LANCHOR56
	.size	sblk_3d_mlc_prog_pages, .-sblk_3d_mlc_prog_pages
	.section	.text.sblk_mlc_dump_prog,"ax",%progbits
	.align	1
	.global	sblk_mlc_dump_prog
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	sblk_mlc_dump_prog, %function
sblk_mlc_dump_prog:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L2515
	push	{r0, r1, r4, r5, r6, lr}
	mov	r5, r0
	ldr	r2, [r0, #24]
	ldrb	r4, [r3]	@ zero_extendqisi2
	movs	r3, #1
	rsb	r1, r4, #24
	lsl	r6, r3, r1
	lsl	r4, r3, r4
	subs	r6, r6, #1
	subs	r4, r4, #1
	ands	r6, r6, r2
	lsrs	r2, r2, r1
	ands	r4, r4, r2
	uxtb	r4, r4
	mov	r0, r4
	bl	zftl_flash_exit_slc_mode
	ldr	r2, [r5, #24]
	mov	r1, r6
	ldr	r0, .L2515+4
	adds	r3, r2, #1
	bl	printf
	ldr	r3, [r5, #12]
	mov	r2, r6
	mov	r1, r4
	movs	r0, #16
	str	r3, [sp]
	ldr	r3, [r5, #4]
	bl	flash_start_3d_mlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	r3, [r5, #12]
	adds	r2, r6, #1
	mov	r1, r4
	movs	r0, #16
	str	r3, [sp]
	ldr	r3, [r5, #4]
	bl	flash_start_3d_mlc_page_prog
	bl	nandc_wait_flash_ready
	movs	r1, #64
	ldr	r0, [r5, #24]
	bl	flash_wait_device_ready
	bl	nandc_de_cs.constprop.30
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, pc}
.L2516:
	.align	2
.L2515:
	.word	.LANCHOR31
	.word	.LC136
	.size	sblk_mlc_dump_prog, .-sblk_mlc_dump_prog
	.section	.text.flash_start_page_prog,"ax",%progbits
	.align	1
	.global	flash_start_page_prog
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_start_page_prog, %function
flash_start_page_prog:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	fp, r2
	str	r3, [sp, #4]
	mov	r8, r1
	ldr	r3, .L2527
	ldr	r7, .L2527+4
	str	r0, [sp]
	ldrb	r2, [r3]	@ zero_extendqisi2
	movs	r3, #1
	rsb	r4, r2, #24
	lsls	r3, r3, r2
	lsr	r2, r1, r4
	subs	r3, r3, #1
	ands	r3, r3, r2
	ldrb	r2, [r7]	@ zero_extendqisi2
	uxtb	r10, r3
	cmp	r2, r10
	bhi	.L2518
	movw	r2, #821
	ldr	r1, .L2527+8
	ldr	r0, .L2527+12
	bl	printf
.L2518:
	ldrb	r2, [r7]	@ zero_extendqisi2
	cmp	r2, r10
	bls	.L2517
	movs	r2, #1
	lsl	r4, r2, r4
	ldr	r2, .L2527+16
	subs	r4, r4, #1
	ldrb	r6, [r2, r10]	@ zero_extendqisi2
	and	r4, r4, r8
	ldr	r2, .L2527+20
	ldr	r5, [r2]
	bl	nandc_rdy_status
	cbnz	r0, .L2520
	ldrb	r2, [r7]	@ zero_extendqisi2
	cmp	r2, #1
	bne	.L2521
	bl	nandc_wait_flash_ready
.L2520:
	mov	r0, r6
	bl	hynix_reconfig_rr_para
	mov	r0, r6
	bl	nandc_cs
	tst	r8, #50331648
	bne	.L2522
	mov	r0, r4
	bl	slc_phy_page_address_calc
	ldr	r3, .L2527+24
	mov	r4, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2523
	mov	r0, r6
	bl	zftl_flash_enter_slc_mode
.L2523:
	add	r5, r5, r6, lsl #8
	movs	r3, #128
	mov	r0, r4
	str	r3, [r5, #2056]
	movs	r3, #0
	str	r3, [r5, #2052]
	str	r3, [r5, #2052]
	uxtb	r3, r4
	str	r3, [r5, #2052]
	lsrs	r3, r4, #8
	str	r3, [r5, #2052]
	lsrs	r3, r4, #16
	str	r3, [r5, #2052]
	bl	nandc_set_seed
	ldr	r1, .L2527+28
	mov	r2, fp
	ldr	r3, [sp, #4]
	movs	r0, #1
	ldrb	r1, [r1, #9]	@ zero_extendqisi2
	bl	nandc_xfer_start
	bl	nandc_xfer_done
	movs	r0, #200
	bl	udelay
	ldr	r3, [sp]
	str	r3, [r5, #2056]
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	nandc_de_cs.constprop.30
.L2521:
	movs	r2, #64
	mov	r1, r4
	mov	r0, r10
	bl	flash_wait_device_ready_raw
	b	.L2520
.L2522:
	mov	r0, r6
	bl	zftl_flash_exit_slc_mode
	b	.L2523
.L2517:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2528:
	.align	2
.L2527:
	.word	.LANCHOR31
	.word	.LANCHOR18
	.word	.LANCHOR175
	.word	.LC0
	.word	.LANCHOR30
	.word	.LANCHOR13
	.word	.LANCHOR0
	.word	.LANCHOR32
	.size	flash_start_page_prog, .-flash_start_page_prog
	.section	.text.queue_prog_cmd,"ax",%progbits
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	queue_prog_cmd, %function
queue_prog_cmd:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	mov	r4, r0
	ldr	r3, [r0, #12]
	ldr	r2, [r0, #4]
	ldr	r1, [r0, #24]
	movs	r0, #16
	bl	flash_start_page_prog
	ldr	r3, .L2537
	ldr	r2, [r4, #24]
	ldrb	r0, [r3]	@ zero_extendqisi2
	cmp	r0, #255
	beq	.L2530
	ldr	r3, .L2537+4
	movs	r7, #48
	ldr	ip, .L2537+8
	ldrb	r1, [r3]	@ zero_extendqisi2
	movs	r3, #1
	mov	lr, ip
	rsb	r6, r1, #24
	lsls	r3, r3, r1
	asrs	r2, r2, r6
	subs	r3, r3, #1
	uxth	r3, r3
	ands	r2, r2, r3
.L2532:
	mla	r5, r7, r0, ip
	ldr	r1, [r5, #24]
	lsrs	r1, r1, r6
	ands	r1, r1, r3
	cmp	r2, r1
	bne	.L2531
	add	r1, r5, #42
	ldrb	r5, [r5, #42]	@ zero_extendqisi2
	cmp	r5, #7
	bne	.L2531
	movs	r3, #3
	strb	r3, [r1]
.L2530:
	movs	r3, #3
	mov	r1, r4
	strb	r3, [r4, #42]
	movs	r3, #1
	strb	r3, [r4, #43]
	movs	r3, #255
	strb	r3, [r4]
	ldr	r0, .L2537
	pop	{r3, r4, r5, r6, r7, lr}
	b	buf_add_tail
.L2531:
	muls	r0, r7, r0
	ldrb	r0, [lr, r0]	@ zero_extendqisi2
	cmp	r0, #255
	bne	.L2532
	b	.L2530
.L2538:
	.align	2
.L2537:
	.word	.LANCHOR56
	.word	.LANCHOR31
	.word	.LANCHOR52
	.size	queue_prog_cmd, .-queue_prog_cmd
	.section	.text.sblk_prog_page,"ax",%progbits
	.align	1
	.global	sblk_prog_page
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	sblk_prog_page, %function
sblk_prog_page:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldrh	r3, [r0, #34]
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	mov	r5, r1
	cbz	r3, .L2540
	ldr	r3, .L2566
	ldr	r3, [r3]
	lsls	r3, r3, #23
	bpl	.L2540
	mov	r2, r1
	ldr	r1, [r0, #24]
	ldr	r0, .L2566+4
	bl	printf
.L2540:
	ldr	fp, .L2566+36
	movs	r7, #0
.L2541:
	cbnz	r5, .L2552
.L2565:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2552:
	ldrb	r8, [r4]	@ zero_extendqisi2
	ldr	r6, [r4, #24]
.L2542:
	movs	r1, #1
	mov	r0, r6
	bl	queue_lun_state
	cbnz	r0, .L2543
	cmp	r5, #1
	beq	.L2544
	ldr	r3, .L2566+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L2545
.L2544:
	mov	r0, r4
	bl	queue_prog_cmd
.L2546:
	subs	r5, r5, #1
	beq	.L2565
	ldr	r4, .L2566+12
	add	r8, r8, r8, lsl #1
	add	r4, r4, r8, lsl #4
	b	.L2541
.L2543:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2542
.L2545:
	ldrb	r1, [fp]	@ zero_extendqisi2
	movs	r2, #1
	rsb	r3, r1, #24
	lsls	r2, r2, r1
	lsr	r3, r6, r3
	subs	r2, r2, #1
	ands	r3, r3, r2
	uxth	r3, r3
	str	r3, [sp, #4]
	ldrb	r3, [r4]	@ zero_extendqisi2
	cmp	r3, #255
	bne	.L2547
	movw	r2, #583
	ldr	r1, .L2566+16
	ldr	r0, .L2566+20
	bl	printf
.L2547:
	ldr	r2, .L2566+12
	movs	r1, #48
	ldrb	r3, [r4]	@ zero_extendqisi2
	mov	r10, #1
	mla	r3, r1, r3, r2
	ldr	r1, [r3, #24]
	ldrb	r3, [fp]	@ zero_extendqisi2
	rsb	r2, r3, #24
	lsl	r3, r10, r3
	lsr	r0, r1, r2
	subs	r3, r3, #1
	ands	r3, r3, r0
	ldr	r0, [sp, #4]
	uxth	r3, r3
	cmp	r0, r3
	bne	.L2548
	ldr	r3, .L2566+24
	ldrh	r0, [r3]
	ldr	r3, .L2566+28
	ldrb	ip, [r3]	@ zero_extendqisi2
	subs	r3, r2, r0
	lsl	r2, r10, r0
	lsl	r3, r10, r3
	subs	r2, r2, #1
	subs	r3, r3, #1
	uxth	r2, r2
	add	ip, ip, #-1
	and	r3, r3, ip
	uxth	r3, r3
	and	lr, r2, r6
	ands	r2, r2, r1
	lsrs	r6, r6, r0
	lsrs	r1, r1, r0
	ands	r6, r6, r3
	ands	r1, r1, r3
	cmp	r6, r1
	beq	.L2548
	cmp	lr, r2
	bne	.L2548
	cmp	r7, ip
	beq	.L2548
	ldr	r3, [r4, #12]
	movs	r0, #17
	ldr	r2, [r4, #4]
	add	r7, r7, r10
	ldr	r1, [r4, #24]
	bl	flash_start_page_prog
	movs	r3, #9
	strb	r10, [r4, #43]
	strb	r3, [r4, #42]
	movs	r3, #255
	strb	r3, [r4]
	mov	r1, r4
	ldr	r0, .L2566+32
	bl	buf_add_tail
	b	.L2546
.L2548:
	mov	r0, r4
	movs	r7, #0
	bl	queue_prog_cmd
	b	.L2546
.L2567:
	.align	2
.L2566:
	.word	.LANCHOR14
	.word	.LC137
	.word	.LANCHOR41
	.word	.LANCHOR52
	.word	.LANCHOR176
	.word	.LC0
	.word	.LANCHOR68
	.word	.LANCHOR69
	.word	.LANCHOR56
	.word	.LANCHOR31
	.size	sblk_prog_page, .-sblk_prog_page
	.section	.text.ftl_flush,"ax",%progbits
	.align	1
	.global	ftl_flush
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_flush, %function
ftl_flush:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	ldr	r4, .L2573
	ldr	r5, .L2573+4
	ldrb	r1, [r4]	@ zero_extendqisi2
	cbz	r1, .L2569
	ldrb	r0, [r5]	@ zero_extendqisi2
	ldr	r3, .L2573+8
	add	r0, r0, r0, lsl #1
	add	r0, r3, r0, lsl #4
	bl	sblk_prog_page
.L2569:
	movs	r3, #255
	strb	r3, [r5]
	movs	r3, #0
	strb	r3, [r4]
	bl	sblk_wait_write_queue_completed
	bl	ftl_write_completed
	movw	r0, #65535
	pop	{r3, r4, r5, lr}
	b	ftl_vpn_decrement
.L2574:
	.align	2
.L2573:
	.word	.LANCHOR123
	.word	.LANCHOR177
	.word	.LANCHOR52
	.size	ftl_flush, .-ftl_flush
	.section	.text.flash_prog_page_en,"ax",%progbits
	.align	1
	.global	flash_prog_page_en
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_prog_page_en, %function
flash_prog_page_en:
	@ args = 8, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r8, r2
	ldr	r7, .L2610
	sub	sp, sp, #24
	mov	fp, r3
	mov	r6, r0
	ldrb	r3, [sp, #60]	@ zero_extendqisi2
	mov	r4, r1
	ldrb	r2, [r7]	@ zero_extendqisi2
	ubfx	r5, r1, #24, #2
	str	r3, [sp, #20]
	cmp	r2, r0
	bhi	.L2576
	movw	r2, #554
	ldr	r1, .L2610+4
	ldr	r0, .L2610+8
	bl	printf
.L2576:
	ldrb	r3, [r7]	@ zero_extendqisi2
	cmp	r3, r6
	bls	.L2587
	ldr	r3, .L2610+12
	ldrb	r3, [r3, r6]	@ zero_extendqisi2
	str	r3, [sp, #12]
	cmp	r5, #0
	bne	.L2589
	ldr	r3, .L2610+16
	ldr	r10, .L2610+64
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2579
	ldrb	r3, [r10]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L2589
.L2579:
	ldr	r3, .L2610+20
	mov	r0, r4
	ldrh	r7, [r3]
	mov	r1, r7
	bl	__aeabi_uidiv
	mov	r1, r7
	mul	r5, r7, r0
	mov	r0, r4
	bl	__aeabi_uidivmod
	ldrb	r3, [r10]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L2580
	add	r5, r5, r1, lsl #1
.L2584:
	ldr	r3, .L2610+24
	ldr	r3, [r3]
	lsls	r1, r3, #27
	bpl	.L2581
	mov	r3, r5
	mov	r2, r4
	ldr	r1, [sp, #12]
	ldr	r0, .L2610+28
	bl	printf
.L2581:
	ldr	r3, [sp, #56]
	mov	r2, r8
	mov	r1, r5
	ldr	r0, [sp, #12]
	str	r3, [sp]
	mov	r3, fp
	bl	flash_prog_page
	ldr	r3, [sp, #20]
	str	r0, [sp, #16]
	cmp	r3, #0
	beq	.L2582
	ldr	r3, [sp, #56]
	mov	r1, r4
	ldr	r10, .L2610+44
	mov	r0, r6
	ldr	r2, .L2610+32
	str	r3, [sp]
	ldr	r3, [r10]
	ldr	r2, [r2]
	bl	flash_read_page_en
	adds	r2, r0, #1
	mov	r7, r0
	beq	.L2583
	cmp	r0, #512
	beq	.L2583
	ldr	r3, .L2610+32
	ldr	r2, [r8]
	ldr	r3, [r3]
	ldr	r3, [r3]
	cmp	r2, r3
	bne	.L2583
	ldr	r3, [r10]
	ldr	r2, [fp]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L2582
.L2583:
	movs	r3, #4
	mov	r1, r8
	mov	r2, r3
	ldr	r0, .L2610+36
	bl	rknand_print_hex
	movs	r3, #4
	mov	r1, fp
	mov	r2, r3
	ldr	r0, .L2610+40
	bl	rknand_print_hex
	ldr	r1, .L2610+44
	movs	r3, #4
	mov	r2, r3
	ldr	r0, .L2610+48
	ldr	r1, [r1]
	bl	rknand_print_hex
	ldr	r1, .L2610+32
	movs	r3, #4
	mov	r2, r3
	ldr	r0, .L2610+52
	ldr	r1, [r1]
	bl	rknand_print_hex
	cmp	r7, #512
	beq	.L2584
.L2586:
	mov	r1, r4
	ldr	r0, .L2610+56
	bl	printf
	movw	r2, #587
	ldr	r1, .L2610+4
	ldr	r0, .L2610+8
	bl	printf
.L2587:
	mov	r0, #-1
	b	.L2575
.L2580:
	ldr	r3, .L2610+60
	ldrh	r1, [r3, r1, lsl #1]
	add	r5, r5, r1
	b	.L2584
.L2589:
.L2578:
	mov	r5, r4
	b	.L2584
.L2582:
	ldr	r0, [sp, #16]
	adds	r3, r0, #1
	beq	.L2586
.L2575:
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2611:
	.align	2
.L2610:
	.word	.LANCHOR18
	.word	.LANCHOR178
	.word	.LC0
	.word	.LANCHOR30
	.word	.LANCHOR0
	.word	.LANCHOR2
	.word	.LANCHOR14
	.word	.LC138
	.word	.LANCHOR167
	.word	.LC139
	.word	.LC140
	.word	.LANCHOR166
	.word	.LC141
	.word	.LC142
	.word	.LC143
	.word	.LANCHOR3
	.word	.LANCHOR1
	.size	flash_prog_page_en, .-flash_prog_page_en
	.section	.text.ftl_test_block,"ax",%progbits
	.align	1
	.global	ftl_test_block
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_test_block, %function
ftl_test_block:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r5, #0
	ldr	r3, .L2639
	mov	r10, r0
	mov	r8, r5
	str	r5, [r3]
	ldr	r3, .L2639+4
	str	r5, [r3]
.L2613:
	uxth	r3, r5
	str	r3, [sp, #12]
	ldr	r3, .L2639+8
	ldr	r2, [sp, #12]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r2
	bls	.L2623
	mov	fp, #0
	b	.L2624
.L2622:
	ldr	r3, .L2639+12
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L2614
	mov	r1, r10
	ldr	r0, .L2639+16
	bl	printf
.L2614:
	ldr	r3, .L2639+20
	ldrb	r4, [r3]	@ zero_extendqisi2
	ldr	r3, [sp, #12]
	smulbb	r4, r4, r10
	add	r4, r4, r6
	uxth	r4, r4
	cbnz	r3, .L2615
	ldr	r3, .L2639+24
	ldr	r3, [r3]
	ldrb	r3, [r3, #47]	@ zero_extendqisi2
	cmp	r3, r4
	bcs	.L2616
.L2615:
	uxtb	r6, r5
	mov	r1, r4
	mov	r0, r6
	bl	flash_check_bad_block
	cbnz	r0, .L2616
	ldr	r3, .L2639+28
	mov	r1, r8
	mov	r0, r6
	ldrh	r7, [r3]
	muls	r7, r4, r7
	mov	r2, r7
	bl	flash_erase_block_en
	cbz	r0, .L2617
	ldr	r3, .L2639+32
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #2
	bne	.L2638
	ldr	r3, .L2639+36
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2638
	mov	r2, r7
	movs	r1, #1
	mov	r0, r6
	bl	flash_erase_block_en
	cbnz	r0, .L2638
.L2621:
	ldr	r3, .L2639+32
	mov	r8, #1
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r7, r7, r3, lsl #24
.L2620:
	movs	r3, #1
	ldr	r2, .L2639
	str	r3, [sp, #4]
	mov	r1, r7
	ldr	r3, .L2639+40
	mov	r0, r6
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp]
	ldr	r3, .L2639+4
	bl	flash_prog_page_en
	cbz	r0, .L2616
.L2638:
	mov	r1, r4
	mov	r0, r6
	bl	flash_mask_bad_block
.L2616:
	add	fp, fp, #1
.L2624:
	ldr	r3, .L2639+20
	uxth	r6, fp
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r6
	bhi	.L2622
	adds	r5, r5, #1
	b	.L2613
.L2617:
	cmp	r8, #0
	beq	.L2620
	b	.L2621
.L2623:
	cmp	r8, #0
	beq	.L2625
	ldr	r3, .L2639+44
	movs	r2, #2
	ldr	r3, [r3]
	add	r10, r3, r10, lsl #2
	ldrb	r3, [r10, #2]	@ zero_extendqisi2
	bfi	r3, r2, #3, #2
	strb	r3, [r10, #2]
.L2625:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2640:
	.align	2
.L2639:
	.word	ftl_tmp_buffer
	.word	.LANCHOR179
	.word	.LANCHOR106
	.word	.LANCHOR14
	.word	.LC144
	.word	.LANCHOR69
	.word	.LANCHOR27
	.word	.LANCHOR105
	.word	.LANCHOR73
	.word	.LANCHOR0
	.word	.LANCHOR125
	.word	.LANCHOR7
	.size	ftl_test_block, .-ftl_test_block
	.section	.text.ftl_prog_page,"ax",%progbits
	.align	1
	.global	ftl_prog_page
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_prog_page, %function
ftl_prog_page:
	@ args = 4, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r4, r5, r6, r7, lr}
	mov	r4, r0
	mov	r7, r3
	mov	r5, r1
	mov	r6, r2
	bl	sblk_wait_write_queue_completed
	movs	r3, #1
	mov	r0, r4
	str	r3, [sp, #4]
	mov	r2, r6
	ldr	r3, [sp, #32]
	mov	r1, r5
	str	r3, [sp]
	mov	r3, r7
	bl	flash_prog_page_en
	adds	r3, r0, #1
	mov	r4, r0
	bne	.L2641
	ldr	r1, .L2643
	movw	r2, #2324
	ldr	r0, .L2643+4
	bl	printf
	mov	r1, r5
	ldr	r0, .L2643+8
	bl	printf
.L2641:
	mov	r0, r4
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, pc}
.L2644:
	.align	2
.L2643:
	.word	.LANCHOR180
	.word	.LC0
	.word	.LC143
	.size	ftl_prog_page, .-ftl_prog_page
	.section	.text.ftl_info_flush,"ax",%progbits
	.align	1
	.global	ftl_info_flush
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_info_flush, %function
ftl_info_flush:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #24
	ldr	r4, .L2682
	movs	r1, #0
	ldr	r5, .L2682+4
	ldrb	r2, [r4]	@ zero_extendqisi2
	str	r0, [sp, #20]
	ldr	r0, .L2682+8
	lsls	r2, r2, #1
	bl	ftl_memset
	ldr	r3, [r5]
	str	r4, [sp, #12]
	ldrh	r2, [r3, #74]
	cbz	r2, .L2646
	movs	r2, #0
	strh	r2, [r3, #150]	@ movhi
.L2646:
	ldr	r6, .L2682+12
	mov	r8, #0
	mov	r4, r6
.L2656:
	ldr	r7, .L2682+16
	ldr	r2, [r5]
	ldr	r1, [sp, #20]
	ldrh	r3, [r7]
	ldrb	fp, [r6]	@ zero_extendqisi2
	ldrh	r10, [r6, #2]
	str	r3, [sp, #16]
	ldr	r3, [r2, #4]
	adds	r3, r3, #1
	str	r3, [r2, #4]
	ldr	r2, .L2682+8
	stm	r2, {r1, r3}
	ldr	r2, .L2682+20
	ldr	r2, [r2]
	lsls	r2, r2, #19
	bpl	.L2647
	mov	r2, r10
	mov	r1, fp
	ldr	r0, .L2682+24
	bl	printf
.L2647:
	ldr	r3, .L2682+28
	ldrh	r0, [r4, #2]
	ldrh	r3, [r3]
	cmp	r3, r0
	bhi	.L2648
	ldr	r10, .L2682+48
	ldr	fp, .L2682+44
.L2652:
	ldrb	r3, [r4, #1]	@ zero_extendqisi2
	adds	r3, r3, #1
	uxtb	r3, r3
	cmp	r3, #7
	strb	r3, [r4, #1]
	bls	.L2649
	ldr	r2, [r10]
	movs	r3, #0
	adds	r2, r2, #40
.L2665:
	ldrb	r1, [r2], #1	@ zero_extendqisi2
	uxth	r8, r3
	cmp	r1, #128
	bls	.L2650
	cmp	r1, #255
	beq	.L2651
	movw	r2, #751
	mov	r1, fp
	ldr	r0, .L2682+32
	bl	printf
.L2650:
	strb	r8, [r4, #1]
	mov	r8, #1
.L2649:
	ldr	r3, [r10]
	ldrb	r2, [r4, #1]	@ zero_extendqisi2
	add	r3, r3, r2
	ldrb	r3, [r3, #40]	@ zero_extendqisi2
	cmp	r3, #255
	strb	r3, [r4]
	beq	.L2652
	ldrh	r10, [r7]
	movs	r0, #0
	mul	r10, r3, r10
	mov	r1, r10
	bl	flash_erase_block
	ldr	r3, [sp, #12]
	mov	r1, r10
	ldr	r2, .L2682+36
	movs	r0, #0
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp]
	ldr	r3, .L2682+8
	bl	ftl_prog_page
	movs	r3, #1
	add	r10, r10, r3
	strh	r3, [r4, #2]	@ movhi
.L2653:
	ldr	r3, [sp, #12]
	mov	r1, r10
	ldr	r2, .L2682+36
	movs	r0, #0
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp]
	ldr	r3, .L2682+8
	bl	ftl_prog_page
	ldrh	r3, [r4, #2]
	adds	r0, r0, #1
	add	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
	ldr	r3, .L2682+40
	beq	.L2654
	ldrb	r2, [r3]	@ zero_extendqisi2
	cbz	r2, .L2655
.L2654:
	movs	r2, #0
	strb	r2, [r3]
	b	.L2656
.L2648:
	ldr	r3, [sp, #16]
	mla	r10, fp, r3, r10
	cmp	r0, #0
	bne	.L2653
	mov	r1, r10
	bl	flash_erase_block
	b	.L2653
.L2655:
	cmp	r8, #0
	bne	.L2657
.L2664:
	ldrb	r3, [r4]	@ zero_extendqisi2
	cmp	r3, #255
	bne	.L2681
	movw	r2, #787
	ldr	r1, .L2682+44
	ldr	r0, .L2682+32
	bl	printf
.L2681:
	movs	r0, #0
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2657:
	ldrb	r5, [r4, #1]	@ zero_extendqisi2
	ldr	r6, .L2682+48
	ldr	r7, .L2682+44
	adds	r5, r5, #1
.L2660:
	cmp	r5, #7
	bhi	.L2664
	ldr	r3, [r6]
	add	r3, r3, r5
	ldrb	r8, [r3, #40]	@ zero_extendqisi2
	uxth	r3, r8
	cmp	r3, #128
	bls	.L2661
	cmp	r3, #255
	beq	.L2662
	mov	r2, #780
	mov	r1, r7
	ldr	r0, .L2682+32
	bl	printf
.L2661:
	ldr	r3, .L2682+16
	movs	r0, #0
	ldrh	r1, [r3]
	mul	r1, r8, r1
	bl	flash_erase_block
.L2662:
	adds	r5, r5, #1
	uxth	r5, r5
	b	.L2660
.L2651:
	adds	r3, r3, #1
	cmp	r3, #8
	bne	.L2665
	mov	r8, r3
	b	.L2650
.L2683:
	.align	2
.L2682:
	.word	.LANCHOR125
	.word	.LANCHOR104
	.word	.LANCHOR181
	.word	.LANCHOR182
	.word	.LANCHOR105
	.word	.LANCHOR14
	.word	.LC145
	.word	.LANCHOR87
	.word	.LC0
	.word	ftl_info_data_buffer
	.word	.LANCHOR184
	.word	.LANCHOR183
	.word	.LANCHOR27
	.size	ftl_info_flush, .-ftl_info_flush
	.section	.text.ftl_info_blk_init,"ax",%progbits
	.align	1
	.global	ftl_info_blk_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_info_blk_init, %function
ftl_info_blk_init:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r4, #0
	ldr	r3, .L2712
	mov	r1, r4
	ldr	r2, .L2712+4
	strb	r4, [r3]
	movs	r3, #1
	ldr	r0, .L2712+8
	strb	r3, [r2]
	ldr	r2, .L2712+12
	ldr	r5, .L2712+16
	ldr	r6, .L2712+20
	strb	r3, [r2]
	mov	r2, #16384
	ldr	r3, .L2712+24
	str	r0, [r3]
	ldr	r3, .L2712+28
	ldrh	r3, [r3]
	add	r3, r0, r3, lsl #2
	str	r3, [r5]
	bl	ftl_memset
	mov	r2, #16384
	mov	r1, r4
	ldr	r0, .L2712+32
	bl	ftl_memset
	ldr	r2, [r6]
	ldr	r3, .L2712+36
	ldrb	r2, [r2, #40]	@ zero_extendqisi2
	strb	r4, [r3, #1]
	strh	r4, [r3, #2]	@ movhi
	movs	r4, #7
	strb	r2, [r3]
	str	r3, [sp, #12]
.L2686:
	ldr	r3, [r6]
	sxth	r8, r4
	add	r3, r3, r4
	ldrb	r7, [r3, #40]	@ zero_extendqisi2
	cmp	r7, #255
	bne	.L2685
.L2690:
	adds	r4, r4, #-1
	bcs	.L2686
	mov	r8, #0
.L2687:
	ldr	r3, .L2712+40
	ldr	r2, [r3]
	mov	r10, r3
	tst	r2, #4096
	beq	.L2691
	ldr	r3, [r5]
	mov	r2, #4800
	mov	r1, r4
	ldr	r0, .L2712+44
	ldr	r3, [r3]
	bl	printf
.L2691:
	adds	r2, r4, #1
	bne	.L2692
	mov	r2, #16384
	movs	r1, #0
	ldr	r0, .L2712+8
	bl	ftl_memset
	ldr	r3, [r5]
	ldr	r2, .L2712+48
	str	r2, [r3]
	ldr	r2, .L2712+52
	str	r2, [r3, #12]
.L2684:
	mov	r0, r4
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2685:
	ldr	r3, .L2712+56
	movs	r0, #0
	ldr	fp, .L2712+68
	ldr	r2, .L2712+8
	ldrh	r3, [r3]
	muls	r7, r3, r7
	ldrb	r3, [fp]	@ zero_extendqisi2
	str	r3, [sp]
	mov	r1, r7
	ldr	r3, .L2712+60
	bl	ftl_read_page
	cmp	r0, #-1
	mov	r10, r0
	bne	.L2688
	ldrb	r3, [fp]	@ zero_extendqisi2
	adds	r1, r7, #1
	ldr	r2, .L2712+8
	movs	r0, #0
	str	r3, [sp]
	ldr	r3, .L2712+60
	bl	ftl_read_page
	mov	r10, r0
.L2688:
	ldr	r3, .L2712+40
	ldr	r3, [r3]
	lsls	r1, r3, #19
	bpl	.L2689
	ldr	r3, [r5]
	mov	r2, r10
	mov	r1, r4
	ldr	r0, .L2712+64
	ldr	r3, [r3]
	str	r3, [sp]
	mov	r3, #672
	bl	printf
.L2689:
	cmp	r10, #-1
	beq	.L2690
	ldr	r3, [r5]
	ldr	r2, .L2712+48
	ldr	r3, [r3]
	cmp	r3, r2
	bne	.L2690
	mov	r4, r8
	b	.L2687
.L2692:
	ldr	r3, [r6]
	movs	r0, #0
	ldr	r2, .L2712+8
	movs	r4, #0
	add	r3, r3, r8
	ldrb	r1, [r3, #40]	@ zero_extendqisi2
	ldr	r3, [sp, #12]
	strb	r8, [r3, #1]
	strb	r1, [r3]
	movs	r3, #4
	str	r3, [sp]
	ldr	r3, .L2712+60
	bl	flash_get_last_written_page
	uxth	r6, r0
	mov	r7, r0
	adds	r3, r6, #1
	uxth	r8, r3
	ldr	r3, [sp, #12]
	ldrb	fp, [r3]	@ zero_extendqisi2
	ldr	r3, .L2712+56
	ldrh	r3, [r3]
	mul	fp, r3, fp
.L2694:
	subs	r3, r6, r4
	lsls	r3, r3, #16
	bmi	.L2698
	ldr	r3, .L2712+68
	add	r1, r7, fp
	ldr	r2, .L2712+8
	subs	r1, r1, r4
	movs	r0, #0
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp]
	ldr	r3, .L2712+60
	bl	ftl_read_page
	adds	r0, r0, #1
	beq	.L2695
	ldr	r3, [r5]
	ldr	r2, .L2712+48
	ldr	r3, [r3]
	cmp	r3, r2
	bne	.L2695
.L2698:
	ldr	r3, [sp, #12]
	strh	r8, [r3, #2]	@ movhi
	bl	ftl_tmp_into_update
	ldr	r2, [r5]
	movs	r0, #0
	ldr	r3, [r2, #64]
	adds	r3, r3, #1
	str	r3, [r2, #64]
	bl	ftl_info_flush
	movs	r0, #0
	bl	ftl_info_flush
	ldr	r4, [r10]
	ands	r4, r4, #16384
	beq	.L2684
	ldr	r3, [r5]
	movs	r4, #0
	ldr	r0, .L2712+72
	ldr	r1, [r3, #156]
	bl	printf
	b	.L2684
.L2695:
	adds	r4, r4, #1
	b	.L2694
.L2713:
	.align	2
.L2712:
	.word	.LANCHOR185
	.word	.LANCHOR184
	.word	ftl_info_data_buffer
	.word	.LANCHOR186
	.word	.LANCHOR104
	.word	.LANCHOR27
	.word	.LANCHOR7
	.word	.LANCHOR6
	.word	ftl_ext_info_data_buffer
	.word	.LANCHOR182
	.word	.LANCHOR14
	.word	.LC147
	.word	1229739078
	.word	393240
	.word	.LANCHOR105
	.word	.LANCHOR181
	.word	.LC146
	.word	.LANCHOR125
	.word	.LC148
	.size	ftl_info_blk_init, .-ftl_info_blk_init
	.section	.text.ftl_ext_info_flush,"ax",%progbits
	.align	1
	.global	ftl_ext_info_flush
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_ext_info_flush, %function
ftl_ext_info_flush:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L2730
	push	{r0, r1, r2, r4, r5, r6, r7, r8, r10, lr}
	ldr	r3, [r3]
	ldr	r2, [r3, #520]
	cbz	r2, .L2715
	movs	r2, #0
	str	r2, [r3, #520]
.L2715:
	ldr	r6, .L2730+4
	movs	r0, #0
	bl	ftl_total_vpn_update
	mov	r5, r6
.L2719:
	ldr	r3, [r6]
	ldr	r2, [r3, #56]
	adds	r2, r2, #1
	str	r2, [r3, #56]
	ldrh	r2, [r3, #140]
	ldr	r3, .L2730+8
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L2717
	bl	ftl_ext_alloc_new_blk
.L2717:
	ldr	r3, [r5]
	ldrh	r2, [r3, #130]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L2718
	mov	r2, #1912
	ldr	r1, .L2730+12
	ldr	r0, .L2730+16
	bl	printf
.L2718:
	ldr	r3, .L2730+20
	ldr	r2, [r5]
	ldr	r10, .L2730+40
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldrh	r1, [r2, #130]
	ldr	r8, .L2730+44
	rsb	r4, r3, #24
	ldr	r3, .L2730+24
	mov	r0, r8
	ldrh	r3, [r3]
	subs	r3, r4, r3
	movs	r4, #1
	asr	r7, r1, r3
	lsls	r4, r4, r3
	ldr	r3, .L2730+28
	subs	r4, r4, #1
	ands	r4, r4, r1
	ldrh	r1, [r3]
	sxth	r4, r4
	ldrh	r3, [r2, #140]
	ldrb	r2, [r10]	@ zero_extendqisi2
	mla	r4, r1, r4, r3
	lsls	r2, r2, #1
	movs	r1, #0
	bl	ftl_memset
	movs	r3, #0
	ldr	r2, .L2730+32
	str	r3, [r8]
	mov	r1, r4
	ldr	r3, [r5]
	uxtb	r0, r7
	ldr	r3, [r3, #56]
	str	r3, [r8, #4]
	ldrb	r3, [r10]	@ zero_extendqisi2
	str	r3, [sp]
	mov	r3, r8
	bl	ftl_prog_page
	ldr	r2, [r5]
	ldrh	r3, [r2, #140]
	adds	r3, r3, #1
	uxth	r3, r3
	cmp	r3, #1
	strh	r3, [r2, #140]	@ movhi
	beq	.L2719
	adds	r0, r0, #1
	ldr	r3, .L2730+36
	beq	.L2720
	ldrb	r0, [r3]	@ zero_extendqisi2
	cbz	r0, .L2721
.L2720:
.L2716:
	movs	r2, #0
	strb	r2, [r3]
	b	.L2719
.L2721:
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L2731:
	.align	2
.L2730:
	.word	.LANCHOR10
	.word	.LANCHOR104
	.word	.LANCHOR87
	.word	.LANCHOR187
	.word	.LC0
	.word	.LANCHOR31
	.word	.LANCHOR68
	.word	.LANCHOR105
	.word	ftl_ext_info_data_buffer
	.word	.LANCHOR186
	.word	.LANCHOR125
	.word	.LANCHOR181
	.size	ftl_ext_info_flush, .-ftl_ext_info_flush
	.section	.text.ftl_ext_info_init,"ax",%progbits
	.align	1
	.global	ftl_ext_info_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_ext_info_init, %function
ftl_ext_info_init:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r2, #0
	ldr	r3, .L2753
	ldr	r5, .L2753+4
	strh	r2, [r3]	@ movhi
	ldr	r1, .L2753+8
	ldr	r3, [r5]
	ldrh	r4, [r1]
	ldrh	r2, [r3, #130]
	ldr	r3, .L2753+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	rsb	r3, r3, #24
	subs	r3, r3, r4
	movs	r4, #1
	asr	r6, r2, r3
	lsls	r4, r4, r3
	uxtb	r10, r6
	subs	r4, r4, #1
	ands	r4, r4, r2
	ldr	r2, .L2753+16
	movs	r3, #4
	mov	r1, r4
	str	r3, [sp]
	mov	r0, r10
	ldr	r3, .L2753+20
	bl	flash_get_last_written_page
	ldr	r3, .L2753+24
	mov	r7, r0
	ldr	r2, [r3]
	mov	fp, r3
	tst	r2, #4096
	beq	.L2733
	ldr	r3, [r5]
	uxth	r6, r6
	movw	r2, #1956
	ldr	r1, .L2753+28
	ldrh	r3, [r3, #130]
	str	r6, [sp]
	str	r3, [sp, #4]
	mov	r3, r0
	ldr	r0, .L2753+32
	bl	printf
.L2733:
	mov	r8, #0
.L2734:
	uxth	r6, r7
	sub	r3, r6, r8
	lsls	r0, r3, #16
	bmi	.L2739
	ldr	r3, .L2753+36
	sub	r1, r7, r8
	ldr	r2, .L2753+16
	ldrh	r0, [r3]
	ldr	r3, .L2753+40
	ldrb	r3, [r3]	@ zero_extendqisi2
	mla	r1, r4, r0, r1
	mov	r0, r10
	str	r3, [sp]
	ldr	r3, .L2753+20
	bl	flash_read_page_en
	adds	r3, r0, #1
	beq	.L2735
	cmp	r0, #512
	beq	.L2735
	ldr	r3, .L2753+44
	ldr	r2, .L2753+48
	ldr	r3, [r3]
	ldr	r3, [r3]
	cmp	r3, r2
	bne	.L2735
.L2739:
	bl	zftl_sblk_list_init
	ldr	r3, [r5]
	ldrh	r2, [r3, #140]
	cmp	r2, r7
	bgt	.L2737
	adds	r6, r6, #1
	strh	r6, [r3, #140]	@ movhi
	bl	ftl_ext_info_flush
.L2737:
	ldr	r3, .L2753+44
	movw	r1, #65535
	movs	r2, #0
	ldr	r3, [r3]
	strh	r1, [r3, #584]	@ movhi
	strh	r1, [r3, #586]	@ movhi
	strh	r1, [r3, #588]	@ movhi
	strh	r1, [r3, #590]	@ movhi
	str	r1, [r3, #560]
	mov	r1, #-1
	str	r1, [r3, #564]
	ldr	r1, [fp]
	str	r2, [r3, #520]
	str	r2, [r3, #604]
	lsls	r1, r1, #19
	str	r2, [r3, #608]
	bpl	.L2740
	str	r2, [sp]
	ldr	r1, .L2753+28
	ldr	r3, [r3, #12]
	ldr	r0, .L2753+52
	bl	printf
.L2740:
	ldr	r3, .L2753+56
	movw	r2, #65535
	movs	r0, #0
	strh	r2, [r3]	@ movhi
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2735:
	add	r8, r8, #1
	b	.L2734
.L2754:
	.align	2
.L2753:
	.word	.LANCHOR115
	.word	.LANCHOR104
	.word	.LANCHOR68
	.word	.LANCHOR31
	.word	ftl_ext_info_data_buffer
	.word	.LANCHOR181
	.word	.LANCHOR14
	.word	.LANCHOR188
	.word	.LC149
	.word	.LANCHOR105
	.word	.LANCHOR125
	.word	.LANCHOR10
	.word	1162432070
	.word	.LC150
	.word	.LANCHOR66
	.size	ftl_ext_info_init, .-ftl_ext_info_init
	.section	.text.ftl_prog_ppa_page,"ax",%progbits
	.align	1
	.global	ftl_prog_ppa_page
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_prog_ppa_page, %function
ftl_prog_ppa_page:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r4, r5, r6, r7, lr}
	ldr	r4, .L2756
	ldrb	r7, [r4]	@ zero_extendqisi2
	movs	r4, #1
	str	r3, [sp]
	mov	r3, r2
	mov	r2, r1
	rsb	r5, r7, #24
	lsl	r6, r4, r5
	lsls	r4, r4, r7
	lsr	r5, r0, r5
	subs	r4, r4, #1
	subs	r6, r6, #1
	ands	r4, r4, r5
	and	r1, r6, r0
	uxtb	r0, r4
	bl	ftl_prog_page
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, pc}
.L2757:
	.align	2
.L2756:
	.word	.LANCHOR31
	.size	ftl_prog_ppa_page, .-ftl_prog_ppa_page
	.section	.text.ftl_write_last_log_page,"ax",%progbits
	.align	1
	.global	ftl_write_last_log_page
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_write_last_log_page, %function
ftl_write_last_log_page:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	mov	r4, r0
	ldrh	r3, [r0, #6]
	cmp	r3, #1
	bne	.L2760
	ldr	r3, .L2762
	ldrh	r5, [r0, #12]
	ldr	r6, [r3]
	bl	ftl_get_new_free_page
	adds	r3, r0, #1
	mov	r7, r0
	beq	.L2761
	ldrh	r0, [r4]
	add	r6, r6, r5, lsl #2
	ldr	r5, .L2762+4
	movs	r4, #0
	bl	ftl_vpn_decrement
	ldr	r3, .L2762+8
	mov	r0, r6
	ldr	r2, .L2762+12
	str	r3, [r5]
	ldr	r3, .L2762+16
	ldrb	r1, [r2]	@ zero_extendqisi2
	ldrh	r3, [r3]
	muls	r1, r3, r1
	lsls	r1, r1, #2
	bl	js_hash
	ldr	r3, .L2762+20
	mov	r2, r5
	str	r0, [r5, #4]
	mov	r1, r6
	mov	r0, r7
	str	r4, [r5, #8]
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r4, [r5, #12]
	bl	ftl_prog_ppa_page
.L2761:
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, pc}
.L2760:
	mov	r0, #-1
	pop	{r3, r4, r5, r6, r7, pc}
.L2763:
	.align	2
.L2762:
	.word	.LANCHOR111
	.word	.LANCHOR179
	.word	-178307901
	.word	.LANCHOR80
	.word	.LANCHOR87
	.word	.LANCHOR125
	.size	ftl_write_last_log_page, .-ftl_write_last_log_page
	.section	.text.ftl_open_sblk_recovery,"ax",%progbits
	.align	1
	.global	ftl_open_sblk_recovery
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_open_sblk_recovery, %function
ftl_open_sblk_recovery:
	@ args = 0, pretend = 0, frame = 216
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #224
	ldr	r5, .L2891
	mov	r4, r0
	str	r1, [sp, #20]
	ldr	r3, [r5]
	lsls	r3, r3, #19
	bpl	.L2765
	ldrh	r1, [r0, #2]
	ldr	r0, .L2891+4
	bl	printf
.L2765:
	ldr	r3, [r5]
	lsls	r7, r3, #19
	bpl	.L2766
	ldrb	r1, [r4, #5]	@ zero_extendqisi2
	ldr	r0, .L2891+8
	bl	printf
.L2766:
	ldr	r3, [r5]
	lsls	r6, r3, #19
	bpl	.L2767
	ldrh	r1, [r4]
	ldr	r0, .L2891+12
	bl	printf
.L2767:
	ldr	r3, [r5]
	lsls	r0, r3, #19
	bpl	.L2768
	ldrh	r2, [r4, #18]
	ldrh	r1, [r4, #16]
	ldr	r0, .L2891+16
	bl	printf
.L2768:
	ldr	r3, [r5]
	lsls	r1, r3, #19
	bpl	.L2769
	ldrb	r1, [r4, #9]	@ zero_extendqisi2
	ldr	r0, .L2891+20
	bl	printf
.L2769:
	ldrh	r3, [r4, #10]
	ldrh	r2, [r4]
	strh	r3, [r4, #14]	@ movhi
	ldr	r3, .L2891+24
	ldrh	r3, [r3]
	cmp	r2, r3
	bcs	.L2764
	movs	r0, #1
	bl	buf_alloc
	movs	r2, #64
	movs	r1, #255
	mov	r5, r0
	add	r0, sp, #32
	bl	ftl_memset
	movs	r2, #64
	movs	r1, #255
	add	r0, sp, #96
	bl	ftl_memset
	movs	r2, #64
	movs	r1, #255
	add	r0, sp, #160
	bl	ftl_memset
	ldrb	r6, [r4, #5]	@ zero_extendqisi2
	movs	r3, #2
	ldrh	r7, [r4, #2]
	str	r3, [sp, #8]
	movs	r3, #0
	str	r3, [sp, #12]
.L2771:
	ldr	r3, .L2891+28
	ldrh	r3, [r3]
	cmp	r3, r7
	bhi	.L2784
.L2774:
	ldrh	r3, [r4, #10]
	ldr	r1, .L2891+28
	ldrh	r2, [r4, #6]
	ldrb	r0, [r4, #9]	@ zero_extendqisi2
	strh	r7, [r4, #2]	@ movhi
	add	r2, r2, r3
	ldrh	r3, [r1]
	strb	r6, [r4, #5]
	str	r1, [sp, #16]
	muls	r3, r0, r3
	cmp	r2, r3
	beq	.L2785
	movw	r2, #1569
	ldr	r1, .L2891+32
	ldr	r0, .L2891+36
	bl	printf
.L2785:
	ldr	r3, .L2891+40
	movs	r6, #0
	ldrh	r0, [r4, #10]
	mov	r2, r6
	ldr	r7, [r3]
	str	r3, [sp, #20]
.L2786:
	cmp	r2, r0
	bcc	.L2788
	ldr	r2, [sp, #16]
	ldrb	r3, [r4, #9]	@ zero_extendqisi2
	ldr	r7, .L2891
	ldrh	r2, [r2]
	ldr	r8, .L2891+60
	smulbb	r3, r3, r2
	subs	r3, r3, r0
	add	r6, r6, r3
	ldr	r3, [r7]
	uxth	r6, r6
	tst	r3, #4096
	beq	.L2789
	ldrh	r1, [r4]
	mov	r2, r6
	ldr	r3, [r8]
	ldr	r0, .L2891+44
	ldrh	r3, [r3, r1, lsl #1]
	bl	printf
.L2789:
	ldr	r3, [r8]
	ldrh	r2, [r4]
	strh	r6, [r3, r2, lsl #1]	@ movhi
	ldr	r3, [r7]
	lsls	r7, r3, #17
	bpl	.L2790
	ldr	r3, [sp, #44]
	add	r1, sp, #32
	ldr	r0, .L2891+48
	str	r3, [sp]
	ldm	r1, {r1, r2, r3}
	bl	printf
.L2790:
	ldr	r6, .L2891+52
	movs	r7, #0
	ldr	fp, .L2891+56
	movs	r1, #0
	ldr	r0, [r5, #4]
	ldrb	r2, [r6]	@ zero_extendqisi2
	lsls	r2, r2, #9
	bl	ftl_memset
	str	r6, [sp, #24]
.L2791:
	ldrb	r3, [fp]	@ zero_extendqisi2
	ldr	r2, [sp, #8]
	muls	r3, r2, r3
	cmp	r7, r3
	bcc	.L2803
	ldr	r8, .L2891+52
	movs	r6, #0
.L2804:
	ldr	r3, .L2891+56
	ldr	r2, [sp, #8]
	ldrb	r3, [r3]	@ zero_extendqisi2
	muls	r3, r2, r3
	cmp	r6, r3
	bcc	.L2811
	mov	r0, r5
	bl	zbuf_free
	ldr	r3, [sp, #16]
	ldrh	r2, [r4, #12]
	ldrb	r1, [r4, #9]	@ zero_extendqisi2
	ldrh	r3, [r3]
	mla	r3, r1, r3, r2
	ldr	r2, [sp, #20]
	ldr	r2, [r2]
	add	r3, r3, #1073741824
	subs	r3, r3, #1
	ldr	r3, [r2, r3, lsl #2]
	adds	r3, r3, #1
	beq	.L2812
	movw	r2, #1660
	ldr	r1, .L2891+32
	ldr	r0, .L2891+36
	bl	printf
.L2812:
	ldrh	r3, [r4, #6]
	cmp	r3, #1
	bne	.L2764
	mov	r0, r4
	bl	ftl_write_last_log_page
.L2764:
	add	sp, sp, #224
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2784:
	ldrb	r6, [r4, #5]	@ zero_extendqisi2
.L2772:
	ldrb	r3, [r4, #9]	@ zero_extendqisi2
	cmp	r3, r6
	bhi	.L2783
	movs	r3, #0
	adds	r7, r7, #1
	strb	r3, [r4, #5]
	uxth	r7, r7
	b	.L2771
.L2892:
	.align	2
.L2891:
	.word	.LANCHOR14
	.word	.LC151
	.word	.LC152
	.word	.LC153
	.word	.LC154
	.word	.LC155
	.word	.LANCHOR6
	.word	.LANCHOR87
	.word	.LANCHOR189
	.word	.LC0
	.word	.LANCHOR111
	.word	.LC156
	.word	.LC157
	.word	.LANCHOR125
	.word	.LANCHOR80
	.word	.LANCHOR9
.L2783:
	add	r3, r6, #8
	movw	r2, #65535
	ldrh	r3, [r4, r3, lsl #1]
	cmp	r3, r2
	beq	.L2773
	ldr	r2, .L2893
	ldr	r1, [r5, #4]
	ldrh	r2, [r2]
	mla	r3, r3, r2, r7
	ldr	r2, [r5, #12]
	str	r3, [sp, #16]
	ldr	r3, .L2893+4
	ldr	r0, [sp, #16]
	ldrb	r3, [r3]	@ zero_extendqisi2
	bl	ftl_read_ppa_page
	cmp	r0, #512
	mov	r8, r0
	beq	.L2774
	cmp	r0, #-1
	beq	.L2775
	ldr	r3, [r5, #12]
	ldr	r2, [r3]
	adds	r2, r2, #1
	bne	.L2775
	ldr	r3, [r3, #4]
	adds	r3, r3, #1
	bne	.L2775
	ldr	r3, [r5, #4]
	ldr	r3, [r3]
	adds	r3, r3, #1
	beq	.L2774
.L2775:
	ldr	r3, .L2893+8
	movs	r2, #1
	strb	r2, [r3]
	ldrb	r3, [r4, #9]	@ zero_extendqisi2
	ldrh	r2, [r4, #10]
	mla	r3, r7, r3, r6
	cmp	r2, r3
	beq	.L2776
	mov	r2, #1488
	ldr	r1, .L2893+12
	ldr	r0, .L2893+16
	bl	printf
.L2776:
	ldrh	r3, [r4, #10]
	ldrh	r2, [r4, #6]
	add	r2, r2, r3
	ldr	r3, .L2893+20
	ldrh	r1, [r3]
	ldrb	r3, [r4, #9]	@ zero_extendqisi2
	muls	r3, r1, r3
	cmp	r2, r3
	beq	.L2777
	movw	r2, #1489
	ldr	r1, .L2893+12
	ldr	r0, .L2893+16
	bl	printf
.L2777:
	cmp	r8, #-1
	beq	.L2779
	ldr	r3, [r5, #12]
	ldr	r0, [r3, #4]
	adds	r2, r0, #1
	beq	.L2779
	bl	lpa_hash_get_ppa
	ldr	r3, [sp, #20]
	mov	r8, r0
	cmp	r3, #0
	beq	.L2781
	ldr	r10, [r5, #12]
	ldr	r3, [r10, #8]
	cmp	r0, r3
	beq	.L2781
	cmp	r0, #-1
	beq	.L2781
	ldr	r3, .L2893+24
	mov	fp, #1
	ldr	r2, .L2893+28
	ldrh	r0, [r3]
	ldr	r3, .L2893+32
	ldrb	r1, [r2]	@ zero_extendqisi2
	ldrb	r3, [r3]	@ zero_extendqisi2
	rsb	r3, r3, #24
	subs	r3, r3, r0
	lsr	r0, r8, r0
	lsl	r3, fp, r3
	subs	r3, r3, #1
	ands	r0, r0, r3
	bl	__aeabi_uidiv
	ldr	r3, [sp, #20]
	uxth	r0, r0
	ldrh	r3, [r3]
	cmp	r3, r0
	bne	.L2781
	ldr	r3, [r10]
	mov	r0, r8
	ldr	r10, .L2893+52
	ldr	r1, [r5, #4]
	str	r3, [sp, #8]
	ldr	r3, .L2893+4
	mov	r2, r10
	ldrb	r3, [r3]	@ zero_extendqisi2
	bl	ftl_read_ppa_page
	ldr	r3, [r10]
	ldr	r2, [sp, #8]
	cmp	r2, r3
	bhi	.L2781
	ldr	r3, [r5, #12]
	ldr	r0, [r3, #8]
	adds	r3, r0, #1
	beq	.L2779
	ldr	r3, .L2893+24
	ldrh	r2, [r3]
	ldr	r3, .L2893+32
	ldrb	r3, [r3]	@ zero_extendqisi2
	lsrs	r0, r0, r2
	rsb	r3, r3, #24
	subs	r3, r3, r2
	ldr	r2, .L2893+28
	lsl	r3, fp, r3
	subs	r3, r3, #1
	ldrb	r1, [r2]	@ zero_extendqisi2
	ands	r0, r0, r3
	bl	__aeabi_uidiv
	uxth	r0, r0
	bl	ftl_vpn_decrement
.L2779:
	ldrh	r3, [r4, #6]
	subs	r3, r3, #1
	strh	r3, [r4, #6]	@ movhi
	ldrh	r3, [r4, #10]
	adds	r3, r3, #1
	strh	r3, [r4, #10]	@ movhi
	movs	r3, #4
	str	r3, [sp, #8]
	movs	r3, #1
	str	r3, [sp, #12]
.L2773:
	adds	r6, r6, #1
	uxth	r6, r6
	b	.L2772
.L2788:
	ldrh	r1, [r4, #12]
	add	r1, r1, r2
	adds	r2, r2, #1
	ldr	r3, [r7, r1, lsl #2]
	adds	r3, r3, #1
	itt	ne
	addne	r6, r6, #1
	uxthne	r6, r6
	b	.L2786
.L2803:
	add	r10, sp, #32
	ldr	r0, [r10, r7, lsl #2]
	adds	r6, r0, #1
	bne	.L2792
.L2796:
	ldr	r2, .L2893+36
	mov	r6, #-1
	ldr	r3, [r5, #12]
	ldr	r2, [r2]
	ldr	r2, [r2, #8]
	str	r6, [r3, #4]
	str	r6, [r3, #8]
	str	r2, [r3]
	movs	r2, #0
	str	r2, [r3, #12]
	ldr	r3, [r5, #4]
	str	r2, [r3]
.L2793:
	ldr	r3, [sp, #12]
	cmp	r3, #0
	beq	.L2798
	ldrh	r3, [r4, #6]
	cmp	r3, #1
	bls	.L2798
	ldr	r10, .L2893+44
.L2864:
	mov	r0, r4
	bl	ftl_get_new_free_page
	ldr	r3, [r10]
	mov	r8, r0
	lsls	r3, r3, #17
	bpl	.L2800
	ldrh	r2, [r4, #12]
	mov	r1, r0
	ldrh	r3, [r4, #10]
	ldr	r0, .L2893+40
	add	r3, r3, r2
	ldr	r2, [r5, #12]
	subs	r3, r3, #1
	ldr	r2, [r2, #4]
	bl	printf
.L2800:
	ldrb	r3, [fp]	@ zero_extendqisi2
	ldr	r1, [sp, #8]
	ldrh	r2, [r4, #6]
	muls	r3, r1, r3
	adds	r3, r3, #1
	subs	r3, r3, r7
	cmp	r2, r3
	bls	.L2798
	ldr	r3, .L2893+4
	mov	r0, r8
	ldr	r2, [r5, #12]
	ldr	r1, [r5, #4]
	ldrb	r3, [r3]	@ zero_extendqisi2
	bl	ftl_prog_ppa_page
	str	r0, [sp, #28]
	ldrh	r0, [r4]
	bl	ftl_vpn_decrement
	adds	r0, r6, #1
	beq	.L2801
	ldr	r3, [sp, #28]
	adds	r3, r3, #1
	beq	.L2801
	add	r3, sp, #96
	ldrh	r2, [r4, #12]
	str	r8, [r3, r7, lsl #2]
	ldrh	r3, [r4, #10]
	add	r3, r3, r2
	add	r2, sp, #160
	subs	r3, r3, #1
	str	r3, [r2, r7, lsl #2]
.L2798:
	adds	r7, r7, #1
	b	.L2791
.L2792:
	ldr	r3, [sp, #24]
	ldr	r1, [r5, #4]
	ldr	r2, [r5, #12]
	ldrb	r3, [r3]	@ zero_extendqisi2
	bl	ftl_read_ppa_page
	ldr	r3, [r5, #12]
	mov	r6, r0
	ldr	r0, [r3, #4]
	bl	lpa_hash_get_ppa
	ldr	r3, .L2893+44
	mov	r8, r0
	ldr	r3, [r3]
	lsls	r1, r3, #17
	bpl	.L2794
	ldr	r3, [r5, #12]
	mov	r1, r0
	ldr	r2, [r10, r7, lsl #2]
	ldr	r0, .L2893+48
	ldr	r3, [r3, #4]
	bl	printf
.L2794:
	add	r3, sp, #32
	movs	r2, #1
	ldr	r3, [r3, r7, lsl #2]
	cmp	r8, r3
	it	ne
	movne	r6, #-1
	ldr	r3, [r5, #12]
	str	r2, [r3, #12]
	adds	r2, r6, #1
	str	r8, [r3, #8]
	bne	.L2793
	b	.L2796
.L2801:
	ldrh	r3, [r4, #6]
	cmp	r3, #1
	bls	.L2798
	adds	r1, r6, #1
	bne	.L2864
	b	.L2798
.L2894:
	.align	2
.L2893:
	.word	.LANCHOR105
	.word	.LANCHOR125
	.word	.LANCHOR185
	.word	.LANCHOR189
	.word	.LC0
	.word	.LANCHOR87
	.word	.LANCHOR68
	.word	.LANCHOR69
	.word	.LANCHOR31
	.word	.LANCHOR104
	.word	.LC159
	.word	.LANCHOR14
	.word	.LC158
	.word	.LANCHOR181
.L2811:
	add	r10, sp, #96
	ldr	r3, [r10, r6, lsl #2]
	adds	r3, r3, #1
	beq	.L2806
	add	r7, sp, #32
	ldr	r2, [r5, #12]
	ldrb	r3, [r8]	@ zero_extendqisi2
	ldr	r1, [r5, #4]
	ldr	r0, [r7, r6, lsl #2]
	bl	ftl_read_ppa_page
	adds	r2, r0, #1
	beq	.L2807
	cmp	r0, #256
	bne	.L2806
.L2807:
	ldr	r0, [r10, r6, lsl #2]
	ldr	r10, .L2895+20
	ldrb	r3, [r8]	@ zero_extendqisi2
	ldr	r2, [r5, #12]
	ldr	r1, [r5, #4]
	bl	ftl_read_ppa_page
	ldr	r3, [r10]
	mov	fp, r0
	lsls	r3, r3, #17
	bpl	.L2809
	ldr	r2, [r5, #12]
	mov	r1, r0
	ldr	r3, [r7, r6, lsl #2]
	ldr	r0, .L2895
	ldr	r2, [r2, #8]
	bl	printf
.L2809:
	cmp	fp, #-1
	beq	.L2806
	ldr	r1, [r5, #12]
	ldr	r2, [r7, r6, lsl #2]
	ldr	r3, [r1, #8]
	cmp	r2, r3
	bne	.L2806
	ldr	r3, [r10]
	add	r7, sp, #160
	tst	r3, #16384
	beq	.L2810
	ldr	r3, [r7, r6, lsl #2]
	ldr	r1, [r1, #4]
	ldr	r0, .L2895+4
	bl	printf
.L2810:
	ldr	r3, [r5, #12]
	ldrh	r2, [r7, r6, lsl #2]
	ldr	r1, [r3, #8]
	ldr	r0, [r3, #4]
	bl	lpa_hash_update_ppa
.L2806:
	adds	r6, r6, #1
	b	.L2804
.L2781:
	ldr	r0, [r5, #12]
	ldr	r3, .L2895+8
	ldr	r2, [r0, #4]
	ldr	r3, [r3]
	cmp	r2, r3
	bcs	.L2779
	ldr	r3, .L2895+12
	ldrb	r1, [r4, #9]	@ zero_extendqisi2
	ldrh	ip, [r4, #10]
	ldrh	r3, [r3]
	muls	r3, r1, r3
	subs	r3, r3, #1
	cmp	ip, r3
	bge	.L2779
	ldr	r3, .L2895+16
	ldr	r1, [r0]
	ldr	r3, [r3]
	ldr	r2, [r3, #8]
	cmp	r1, r2
	it	hi
	strhi	r1, [r3, #8]
	ldrh	r3, [r4, #12]
	ldr	r1, [r0, #8]
	ldr	r0, [r0, #4]
	add	r2, ip, r3
	uxth	r2, r2
	bl	lpa_hash_update_ppa
	ldr	r3, [sp, #36]
	str	r3, [sp, #32]
	ldr	r3, [sp, #40]
	str	r3, [sp, #36]
	ldr	r3, [sp, #44]
	str	r3, [sp, #40]
	ldr	r3, [sp, #16]
	str	r3, [sp, #44]
	b	.L2779
.L2896:
	.align	2
.L2895:
	.word	.LC159
	.word	.LC160
	.word	.LANCHOR122
	.word	.LANCHOR87
	.word	.LANCHOR104
	.word	.LANCHOR14
	.size	ftl_open_sblk_recovery, .-ftl_open_sblk_recovery
	.section	.text.pm_write_page,"ax",%progbits
	.align	1
	.global	pm_write_page
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	pm_write_page, %function
pm_write_page:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r4, r5, r6, r7, r8, r10, lr}
	mov	r4, r0
	ldr	r7, .L2910
	mov	r8, r1
	mov	r6, r7
.L2898:
	ldr	r3, [r7]
	ldr	r2, [r3, #48]
	ldrh	r1, [r3, #696]
	adds	r2, r2, #1
	str	r2, [r3, #48]
	ldr	r2, .L2910+4
	ldrh	r2, [r2]
	cmp	r1, r2
	bcs	.L2899
	ldrh	r2, [r3, #692]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L2900
.L2899:
	bl	pm_alloc_new_blk
	movs	r0, #0
	bl	ftl_info_flush
.L2900:
	ldr	r3, [r6]
	ldrh	r2, [r3, #692]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L2901
	movw	r2, #263
	ldr	r1, .L2910+8
	ldr	r0, .L2910+12
	bl	printf
.L2901:
	ldr	r3, [r6]
	movs	r1, #0
	ldr	r2, .L2910+16
	ldr	r10, .L2910+32
	ldrh	r5, [r3, #692]
	ldrh	r2, [r2]
	ldrh	r3, [r3, #696]
	ldr	r0, [r10]
	mla	r5, r2, r5, r3
	movs	r2, #64
	bl	ftl_memset
	ldr	r2, [r6]
	ldr	r3, [r10]
	ldrb	r0, [r2, #694]	@ zero_extendqisi2
	str	r4, [r3]
	ldr	r1, [r2, #48]
	ldr	r2, .L2910+20
	str	r1, [r3, #4]
	mov	r1, r5
	ldrb	r2, [r2]	@ zero_extendqisi2
	str	r2, [sp]
	mov	r2, r8
	bl	ftl_prog_page
	ldr	r2, [r6]
	ldrh	r3, [r2, #696]
	adds	r3, r3, #1
	uxth	r3, r3
	cmp	r3, #1
	strh	r3, [r2, #696]	@ movhi
	ldr	r3, .L2910+24
	beq	.L2902
	ldrb	r1, [r3]	@ zero_extendqisi2
	cbz	r1, .L2903
.L2902:
	movs	r2, #0
	strb	r2, [r3]
	b	.L2898
.L2903:
	adds	r0, r0, #1
	bne	.L2905
	mov	r1, r5
	ldr	r0, .L2910+28
	bl	printf
	b	.L2898
.L2905:
	ldrh	r3, [r2, #698]
	movs	r0, #0
	cmp	r4, r3
	itt	cc
	addcc	r4, r4, #176
	strcc	r5, [r2, r4, lsl #2]
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L2911:
	.align	2
.L2910:
	.word	.LANCHOR104
	.word	.LANCHOR87
	.word	.LANCHOR190
	.word	.LC0
	.word	.LANCHOR105
	.word	.LANCHOR125
	.word	.LANCHOR192
	.word	.LC161
	.word	.LANCHOR191
	.size	pm_write_page, .-pm_write_page
	.section	.text.ftl_dump_write_open_sblk,"ax",%progbits
	.align	1
	.global	ftl_dump_write_open_sblk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_dump_write_open_sblk, %function
ftl_dump_write_open_sblk:
	@ args = 0, pretend = 0, frame = 64
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L2941
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r5, r0
	sub	sp, sp, #104
	ldrh	r3, [r3]
	cmp	r3, r0
	bls	.L2912
	ldr	r3, .L2941+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L2914
	ldr	r3, .L2941+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L2912
.L2914:
	ldr	r7, .L2941+12
	lsls	r4, r5, #2
	add	r1, sp, #88
	strh	r5, [sp, #72]	@ movhi
	mov	r0, r5
	movs	r6, #0
	ldr	r3, [r7]
	add	r3, r3, r4
	ldrb	r3, [r3, #2]	@ zero_extendqisi2
	and	r3, r3, #224
	cmp	r3, #160
	itet	eq
	ldreq	r3, .L2941+16
	movne	r8, #1
	ldrbeq	r8, [r3]	@ zero_extendqisi2
	bl	ftl_get_blk_list_in_sblk
	ldr	r3, .L2941+20
	uxtb	r0, r0
	strb	r6, [sp, #77]
	strb	r0, [sp, #81]
	ldrh	r3, [r3]
	strh	r6, [sp, #74]	@ movhi
	strh	r6, [sp, #82]	@ movhi
	smulbb	r0, r3, r0
	ldr	r3, [r7]
	mov	r7, r6
	ldr	r1, [r3, r5, lsl #2]
	add	r4, r4, r3
	ldrb	r2, [r4, #2]	@ zero_extendqisi2
	strh	r0, [sp, #78]	@ movhi
	ubfx	r1, r1, #11, #8
	ldr	r0, .L2941+24
	str	r1, [sp, #4]
	mov	r1, r5
	ldrh	r3, [r3, r5, lsl #2]
	ubfx	r3, r3, #0, #11
	str	r3, [sp]
	ubfx	r3, r2, #3, #2
	lsrs	r2, r2, #5
	bl	printf
	movs	r0, #1
	bl	buf_alloc
	mov	r4, r0
	str	r6, [sp, #44]
.L2916:
	ldr	r3, .L2941+20
	uxth	r10, r6
	ldrh	r3, [r3]
	cmp	r3, r10
	bls	.L2922
	mov	r3, r10
	str	r10, [sp, #52]
	lsls	r3, r3, #1
	mov	fp, #0
	subs	r3, r3, #1
	str	r3, [sp, #60]
	b	.L2926
.L2924:
	ldr	r3, [sp, #64]
	add	r2, sp, #104
	add	r3, r2, r3, lsl #1
	ldrh	r3, [r3, #-32]
	str	r3, [sp, #48]
	movw	r3, #65535
	ldr	r2, [sp, #48]
	cmp	r2, r3
	bne	.L2917
.L2923:
	adds	r7, r7, #1
	uxth	r7, r7
.L2918:
	cmp	r8, r7
	bcs	.L2924
	add	fp, fp, #1
.L2926:
	uxth	r3, fp
	str	r3, [sp, #44]
	ldr	r2, [sp, #44]
	ldrb	r3, [sp, #81]	@ zero_extendqisi2
	cmp	r3, r2
	bls	.L2925
	mov	r3, r2
	movs	r7, #1
	adds	r3, r3, #8
	str	r3, [sp, #64]
	b	.L2918
.L2917:
	ldr	r3, .L2941+28
	cmp	r8, #3
	ldr	r2, [sp, #48]
	ldrh	r3, [r3]
	mul	r3, r2, r3
	bne	.L2919
	uxtah	r3, r3, r6
	orr	r3, r3, r7, lsl #24
.L2920:
	str	r3, [r4, #24]
	movs	r1, #1
	mov	r0, r4
	str	r3, [sp, #68]
	bl	sblk_read_page
	ldr	r1, [r4, #12]
	ldr	r2, [r4, #4]
	ldr	r3, [r4, #36]
	ldr	r0, [r1, #12]
	str	r3, [sp, #56]
	str	r0, [sp, #32]
	ldr	r0, [r1, #8]
	str	r0, [sp, #28]
	ldr	r0, [r1, #4]
	str	r0, [sp, #24]
	ldr	r1, [r1]
	ldr	r0, .L2941+32
	str	r1, [sp, #20]
	ldr	r1, [r2, #12]
	str	r1, [sp, #16]
	ldr	r1, [r2, #8]
	str	r1, [sp, #12]
	ldr	r1, [r2, #4]
	str	r1, [sp, #8]
	ldr	r2, [r2]
	ldr	r1, [sp, #48]
	str	r3, [sp]
	str	r2, [sp, #4]
	ldr	r3, [sp, #68]
	ldr	r2, [sp, #52]
	bl	printf
	ldr	r3, [sp, #56]
	cmp	r3, #512
	bne	.L2923
.L2922:
	uxth	r2, r6
	ldr	r6, .L2941+36
	ldr	r3, [sp, #44]
	mov	r1, r5
	str	r7, [sp]
	ldr	r0, .L2941+40
	bl	printf
	ldrb	r2, [r6]	@ zero_extendqisi2
	movs	r1, #0
	ldr	r0, [r4, #4]
	ldr	fp, .L2941+4
	lsls	r2, r2, #9
	bl	ftl_memset
	ldrb	r2, [r6]	@ zero_extendqisi2
	movs	r1, #0
	ldr	r0, [r4, #12]
	lsls	r2, r2, #1
	bl	ftl_memset
.L2927:
	ldr	r3, .L2941+20
	ldrh	r3, [r3]
	cmp	r3, r10
	bls	.L2932
	lsl	r3, r10, #1
	movs	r7, #0
	str	r3, [sp, #44]
	b	.L2933
.L2919:
	cmp	r8, #2
	itett	eq
	ldreq	r2, [sp, #60]
	uxtahne	r3, r3, r6
	addeq	r3, r3, r2
	ldreq	r2, .L2941+16
	ittt	eq
	addeq	r3, r3, r7
	ldrbeq	r2, [r2]	@ zero_extendqisi2
	orreq	r3, r3, r2, lsl #24
	b	.L2920
.L2925:
	adds	r6, r6, #1
	b	.L2916
.L2931:
	uxth	r8, r7
	mov	r1, r10
	ldr	r0, .L2941+44
	mov	r2, r8
	bl	printf
	ldrb	ip, [fp]	@ zero_extendqisi2
	add	r2, r8, #8
	ldr	r0, .L2941+28
	cmp	ip, #0
	beq	.L2928
	add	r3, sp, #104
	add	r2, r3, r2, lsl #1
	ldrh	r3, [r0]
	mov	r0, r4
	ldrh	r2, [r2, #-32]
	muls	r3, r2, r3
	orr	r3, r3, r10
	str	r3, [r4, #24]
	bl	sblk_3d_tlc_dump_prog
.L2929:
	adds	r7, r7, #1
.L2933:
	ldrb	r2, [sp, #81]	@ zero_extendqisi2
	uxth	r3, r7
	cmp	r2, r3
	bhi	.L2931
	add	r3, r10, #1
	uxth	r10, r3
	b	.L2927
.L2928:
	ldr	r3, .L2941+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #2
	add	r3, sp, #104
	add	r2, r3, r2, lsl #1
	bne	.L2930
	ldrh	r2, [r2, #-32]
	ldrh	r3, [r0]
	mov	r0, r4
	muls	r3, r2, r3
	ldr	r2, [sp, #44]
	orrs	r3, r3, r2
	orr	r3, r3, #33554432
	str	r3, [r4, #24]
	bl	sblk_mlc_dump_prog
	b	.L2929
.L2930:
	ldrh	r3, [r2, #-32]
	ldrh	r1, [r0]
	movs	r0, #1
	muls	r1, r3, r1
	ldr	r3, .L2941+48
	ldrb	r3, [r3]	@ zero_extendqisi2
	orr	r1, r1, r10
	str	r1, [r4, #24]
	rsb	r2, r3, #24
	str	ip, [sp, #4]
	lsls	r0, r0, r3
	subs	r3, r0, #1
	lsr	r0, r1, r2
	lsl	lr, r3, r2
	ands	r0, r0, r3
	ldrb	r3, [r6]	@ zero_extendqisi2
	bic	r1, r1, lr
	uxtb	r0, r0
	str	r3, [sp]
	ldr	r3, [r4, #12]
	ldr	r2, [r4, #4]
	bl	flash_prog_page_en
	b	.L2929
.L2932:
	mov	r0, r4
	bl	zbuf_free
	mov	r1, r5
	ldr	r0, .L2941+52
	bl	printf
.L2912:
	add	sp, sp, #104
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2942:
	.align	2
.L2941:
	.word	.LANCHOR6
	.word	.LANCHOR77
	.word	.LANCHOR74
	.word	.LANCHOR7
	.word	.LANCHOR73
	.word	.LANCHOR87
	.word	.LC162
	.word	.LANCHOR105
	.word	.LC163
	.word	.LANCHOR125
	.word	.LC164
	.word	.LC165
	.word	.LANCHOR31
	.word	.LC166
	.size	ftl_dump_write_open_sblk, .-ftl_dump_write_open_sblk
	.section	.text.ftl_ink_check_sblk,"ax",%progbits
	.align	1
	.global	ftl_ink_check_sblk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_ink_check_sblk, %function
ftl_ink_check_sblk:
	@ args = 0, pretend = 0, frame = 40
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r1, r0
	ldr	r5, .L2961
	sub	sp, sp, #48
	mov	r4, r0
	ldr	r2, [r5]
	ldr	r3, [r2, r0, lsl #2]
	ldrh	r2, [r2, r0, lsl #2]
	ldr	r0, .L2961+4
	ubfx	r3, r3, #11, #8
	ubfx	r2, r2, #0, #11
	bl	printf
	movw	r3, #65535
	str	r5, [sp, #8]
	cmp	r4, r3
	beq	.L2943
	ldr	r3, .L2961+8
	ldrh	r3, [r3]
	cmp	r3, r4
	bls	.L2943
	movs	r1, #0
	mov	r0, r4
	bl	ftl_erase_sblk
	add	r1, sp, #32
	mov	r0, r4
	strh	r4, [sp, #16]	@ movhi
	movs	r6, #0
	bl	ftl_get_blk_list_in_sblk
	strb	r0, [sp, #25]
	movs	r0, #1
	bl	buf_alloc
	ldr	r3, [sp, #8]
	mov	r5, r0
	ldr	r7, .L2961+12
	ldr	r0, [r0, #4]
	ldr	r3, [r3]
	ldrb	r2, [r7]	@ zero_extendqisi2
	ldrh	r3, [r3, r4, lsl #2]
	lsls	r2, r2, #9
	ubfx	r3, r3, #0, #11
	cmp	r3, #1
	ite	le
	movle	r1, #85
	movgt	r1, #170
	bl	ftl_memset
	bl	sblk_wait_write_queue_completed
.L2947:
	ldr	r3, .L2961+16
	uxth	r2, r6
	mov	r8, #0
	ldrh	r1, [r3]
	str	r3, [sp, #12]
	cmp	r1, r2
	bhi	.L2951
.L2952:
	ldr	r3, [sp, #12]
	ldrh	r1, [r3]
	uxth	r3, r8
	cmp	r1, r3
	bls	.L2957
	mov	fp, #0
	movw	r10, #65535
	b	.L2958
.L2949:
	uxth	r3, r8
	add	r2, sp, #48
	add	r3, r2, r3, lsl #1
	movw	r2, #65535
	ldrh	r3, [r3, #-16]
	cmp	r3, r2
	beq	.L2948
	ldr	r2, .L2961+20
	uxth	r1, r6
	ldr	r0, .L2961+24
	mov	r10, #0
	ldrh	r2, [r2]
	mla	r1, r3, r2, r1
	ldr	r2, [r5, #4]
	ldr	r3, .L2961+28
	str	r3, [r2, #4]
	ldr	r3, [r5, #12]
	str	r1, [r2]
	str	r10, [r3]
	ldrb	ip, [r0]	@ zero_extendqisi2
	movs	r0, #1
	str	r10, [sp, #4]
	rsb	fp, ip, #24
	lsl	r0, r0, ip
	add	ip, r0, #-1
	lsr	r0, r1, fp
	lsl	lr, ip, fp
	and	r0, r0, ip
	ldrb	ip, [r7]	@ zero_extendqisi2
	bic	r1, r1, lr
	uxtb	r0, r0
	str	ip, [sp]
	bl	flash_prog_page_en
.L2948:
	add	r8, r8, #1
.L2951:
	ldrb	r2, [sp, #25]	@ zero_extendqisi2
	uxth	r3, r8
	cmp	r2, r3
	bhi	.L2949
	adds	r6, r6, #1
	b	.L2947
.L2956:
	uxth	r6, fp
	add	r3, sp, #48
	adds	r6, r6, #8
	add	r6, r3, r6, lsl #1
	ldrh	r1, [r6, #-32]
	cmp	r1, r10
	beq	.L2954
	ldr	r3, .L2961+20
	uxth	r0, r8
	ldrh	r7, [r3]
	mla	r7, r1, r7, r0
	movs	r1, #1
	mov	r0, r5
	str	r7, [r5, #24]
	bl	sblk_read_page
	ldr	r1, [r5, #4]
	ldr	r1, [r1]
	cmp	r7, r1
	beq	.L2954
	mov	r0, r7
	bl	ftl_mask_bad_block
	strh	r10, [r6, #-32]	@ movhi
.L2954:
	add	fp, fp, #1
.L2958:
	ldrb	r0, [sp, #25]	@ zero_extendqisi2
	uxth	r1, fp
	cmp	r0, r1
	bhi	.L2956
	add	r8, r8, #1
	b	.L2952
.L2957:
	mov	r0, r5
	bl	zbuf_free
	ldr	r3, [sp, #8]
	mov	r1, r4
	ldr	r0, .L2961+32
	ldr	r2, [r3]
	ldr	r3, [r2, r4, lsl #2]
	ldrh	r2, [r2, r4, lsl #2]
	ubfx	r3, r3, #11, #8
	ubfx	r2, r2, #0, #11
	bl	printf
.L2943:
	add	sp, sp, #48
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2962:
	.align	2
.L2961:
	.word	.LANCHOR7
	.word	.LC167
	.word	.LANCHOR6
	.word	.LANCHOR125
	.word	.LANCHOR87
	.word	.LANCHOR105
	.word	.LANCHOR31
	.word	1437269760
	.word	.LC168
	.size	ftl_ink_check_sblk, .-ftl_ink_check_sblk
	.section	.text.ftl_open_sblk_init,"ax",%progbits
	.align	1
	.global	ftl_open_sblk_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_open_sblk_init, %function
ftl_open_sblk_init:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, r8, r10, lr}
	mov	r4, r0
	ldr	r7, .L2973
	mov	r6, r1
	ldr	r8, .L2973+20
.L2964:
.L2968:
	mov	r0, r6
	bl	ftl_alloc_sblk
	ldr	r3, [r7]
	mov	r5, r0
	ldrh	r3, [r3, #150]
	cbz	r3, .L2965
	ldr	r3, [r8]
	ldrh	r3, [r3, r0, lsl #2]
	ubfx	r3, r3, #0, #11
	cmp	r3, #2
	bgt	.L2965
	bl	ftl_ink_check_sblk
.L2965:
	movs	r1, #0
	mov	r0, r5
	bl	ftl_erase_sblk
	add	r1, r4, #16
	mov	r0, r5
	bl	ftl_get_blk_list_in_sblk
	ldr	r2, .L2973+4
	uxtb	r3, r0
	cmp	r6, #2
	strh	r5, [r4]	@ movhi
	strb	r3, [r4, #9]
	mov	r0, #0
	ldrh	r2, [r2]
	mov	r1, #255
	strh	r0, [r4, #2]	@ movhi
	strb	r0, [r4, #5]
	strh	r0, [r4, #10]	@ movhi
	smulbb	r3, r3, r2
	ldr	r10, .L2973+24
	strb	r6, [r4, #4]
	strh	r3, [r4, #6]	@ movhi
	ldr	r3, .L2973+8
	it	ne
	ldrbne	r0, [r3]	@ zero_extendqisi2
	ldrb	r3, [r3]	@ zero_extendqisi2
	it	ne
	smulbbne	r0, r0, r2
	mul	r2, r2, r3
	ldr	r3, .L2973+12
	it	ne
	uxthne	r0, r0
	ldr	r3, [r3]
	strh	r0, [r4, #12]	@ movhi
	lsls	r2, r2, #2
	add	r0, r3, r0, lsl #2
	bl	ftl_memset
	ldr	r3, [r10]
	ldrh	r2, [r4, #6]
	strh	r2, [r3, r5, lsl #1]	@ movhi
	ldrb	r3, [r4, #9]	@ zero_extendqisi2
	cbnz	r3, .L2963
	mov	r1, r5
	ldr	r0, .L2973+16
	bl	printf
	ldr	r3, [r10]
	movw	r2, #65535
	strh	r2, [r3, r5, lsl #1]	@ movhi
	movs	r3, #7
	strb	r3, [r4, #4]
	b	.L2968
.L2963:
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L2974:
	.align	2
.L2973:
	.word	.LANCHOR104
	.word	.LANCHOR87
	.word	.LANCHOR80
	.word	.LANCHOR111
	.word	.LC77
	.word	.LANCHOR7
	.word	.LANCHOR9
	.size	ftl_open_sblk_init, .-ftl_open_sblk_init
	.section	.text.ftl_low_format_data_init,"ax",%progbits
	.align	1
	.global	ftl_low_format_data_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_low_format_data_init, %function
ftl_low_format_data_init:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	mov	r2, #16384
	movs	r1, #0
	ldr	r0, .L2977
	bl	ftl_memset
	ldr	r5, .L2977+4
	bl	zftl_sblk_list_init
	movs	r0, #1
	bl	ftl_alloc_sblk
	movs	r1, #0
	mov	r6, r0
	bl	ftl_erase_sblk
	ldr	r1, [r5]
	mov	r0, r6
	add	r1, r1, #672
	bl	ftl_get_blk_list_in_sblk
	ldr	r3, [r5]
	movs	r2, #0
	ldrh	r7, [r3, #672]
	strh	r2, [r3, #690]	@ movhi
	movw	r2, #65533
	subs	r3, r7, #1
	uxth	r3, r3
	cmp	r3, r2
	bls	.L2976
	movw	r2, #2146
	ldr	r1, .L2977+8
	ldr	r0, .L2977+12
	bl	printf
.L2976:
	ldr	r0, [r5]
	movs	r4, #0
	mov	r2, #256
	movs	r1, #255
	strh	r4, [r0, #696]	@ movhi
	add	r0, r0, #416
	bl	ftl_memset
	ldr	r0, [r5]
	mov	r1, r4
	mov	r2, #4096
	add	r0, r0, #704
	bl	ftl_memset
	ldr	r3, .L2977+16
	ldr	r1, .L2977+20
	ldr	r2, [r5]
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldrh	r1, [r1]
	strh	r7, [r2, #692]	@ movhi
	rsb	r3, r3, #24
	strh	r6, [r2, #416]	@ movhi
	subs	r3, r3, r1
	asr	r3, r7, r3
	ldr	r7, .L2977+24
	strh	r3, [r2, #694]	@ movhi
	movs	r3, #1
	strh	r3, [r2, #688]	@ movhi
	ldr	r3, .L2977+28
	ldrh	r3, [r3]
	strh	r3, [r2, #698]	@ movhi
	ldr	r2, .L2977+32
	ldr	r3, [r7]
	str	r2, [r3]
	bl	ftl_alloc_sys_blk
	mov	r1, r4
	mov	r6, r0
	bl	ftl_erase_phy_blk
	ldr	r3, [r5]
	movs	r1, #2
	ldr	r0, [r7]
	strh	r6, [r3, #130]	@ movhi
	movw	r6, #65535
	strh	r4, [r3, #140]	@ movhi
	adds	r0, r0, #16
	strh	r6, [r0, #568]	@ movhi
	strh	r6, [r0, #570]	@ movhi
	strh	r6, [r0, #572]	@ movhi
	strh	r6, [r0, #574]	@ movhi
	bl	ftl_open_sblk_init
	ldr	r0, [r7]
	movs	r1, #3
	adds	r0, r0, #48
	bl	ftl_open_sblk_init
	ldr	r3, [r5]
	movs	r1, #255
	ldr	r0, [r7]
	ldrh	r2, [r3, #134]
	adds	r0, r0, #136
	strh	r4, [r0, #-12]	@ movhi
	strh	r4, [r0, #-16]	@ movhi
	strh	r2, [r0, #-10]	@ movhi
	mov	r2, #-1
	strh	r4, [r0, #-14]	@ movhi
	strh	r6, [r0, #-56]	@ movhi
	strh	r6, [r0, #-6]	@ movhi
	str	r2, [r0, #408]
	strh	r2, [r3, #126]	@ movhi
	mov	r2, #256
	str	r4, [r0, #384]
	str	r4, [r0, #388]
	str	r4, [r0, #392]
	bl	ftl_memset
	ldr	r0, [r7]
	movs	r2, #128
	movs	r1, #255
	add	r0, r0, #392
	bl	ftl_memset
	bl	ftl_ext_info_flush
	mov	r0, r4
	bl	ftl_info_flush
	bl	ftl_info_blk_init
	mov	r0, r4
	pop	{r3, r4, r5, r6, r7, pc}
.L2978:
	.align	2
.L2977:
	.word	ftl_ext_info_data_buffer
	.word	.LANCHOR104
	.word	.LANCHOR193
	.word	.LC0
	.word	.LANCHOR31
	.word	.LANCHOR68
	.word	.LANCHOR10
	.word	.LANCHOR194
	.word	1162432070
	.size	ftl_low_format_data_init, .-ftl_low_format_data_init
	.section	.text.ftl_low_format,"ax",%progbits
	.align	1
	.global	ftl_low_format
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_low_format, %function
ftl_low_format:
	@ args = 0, pretend = 0, frame = 32
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r4, #8
	ldr	r6, .L3016
	sub	sp, sp, #40
	movs	r1, #0
	ldr	r0, .L3016+4
	bl	printf
.L2982:
	ldr	r3, [r6]
	add	r3, r3, r4
	ldrb	r5, [r3, #32]	@ zero_extendqisi2
	cmp	r5, #128
	ble	.L2980
	cmp	r5, #255
	beq	.L2981
	movw	r2, #2200
	ldr	r1, .L3016+8
	ldr	r0, .L3016+12
	bl	printf
.L2980:
	ldr	r3, .L3016+16
	movs	r0, #0
	ldrh	r1, [r3]
	muls	r1, r5, r1
	bl	flash_erase_block
.L2981:
	adds	r4, r4, #1
	cmp	r4, #16
	bne	.L2982
	bl	sblk_init
	bl	ftl_info_blk_init
	mov	r2, #16384
	movs	r1, #0
	ldr	r0, .L3016+20
	bl	ftl_memset
	ldr	r2, .L3016+24
	movs	r0, #1
	ldr	r1, .L3016+28
	ldr	r3, [r2]
	ldrh	r1, [r1]
	str	r2, [sp, #24]
	add	r1, r3, r1, lsl #2
.L2983:
	cmp	r3, r1
	bne	.L2984
	ldr	r7, .L3016+32
	movs	r4, #0
	ldr	r2, .L3016+36
	ldr	r3, [r7]
	str	r2, [r3]
	strh	r4, [r3, #148]	@ movhi
.L2985:
	ldr	r3, .L3016+28
	uxth	r0, r4
	ldrh	r3, [r3]
	cmp	r3, r0
	bhi	.L2993
	ldr	r3, .L3016+40
	mov	fp, #15
	ldrb	r5, [r3]	@ zero_extendqisi2
	ldr	r3, .L3016
	mov	r1, r5
	ldr	r3, [r3]
	ldrb	r0, [r3, #47]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	ldr	r3, .L3016+24
	uxtb	r0, r0
	cmp	r5, #1
	uxth	lr, r5
	add	r4, r0, #1
	ldr	r10, [r3]
	it	eq
	moveq	r8, #1
	ldr	r3, .L3016+32
	it	ne
	movne	r8, #3
	movs	r2, #0
	ldr	r6, [r3]
	ldrh	r3, [r6, #148]
.L2996:
	add	r1, r10, r2, lsl #2
	cmp	r5, #4
	add	r2, r2, #1
	ldrb	ip, [r1, #2]	@ zero_extendqisi2
	ite	ne
	strbne	r8, [r1, #3]
	strbeq	fp, [r1, #3]
	orr	ip, ip, #224
	strb	ip, [r1, #2]
	uxth	r1, r2
	cmp	r4, r1
	bhi	.L2996
	smulbb	r0, r0, lr
	add	r3, r3, lr
	mov	r1, r5
	uxtah	r0, r0, r3
	strh	r0, [r6, #148]	@ movhi
	movs	r0, #16
	bl	__aeabi_idiv
	ldr	r3, .L3016+44
	add	r0, r0, r4
	uxth	r0, r0
	ldr	r3, [r3]
	strh	r0, [r6, #134]	@ movhi
	lsls	r3, r3, #19
	bpl	.L2997
	str	r0, [sp]
	mov	r3, r4
	movs	r2, #128
	movw	r1, #2247
	ldr	r0, .L3016+48
	bl	printf
.L2997:
	ldr	r0, [r7]
	movs	r2, #128
	movs	r1, #255
	movs	r5, #0
	adds	r0, r0, #160
	bl	ftl_memset
	ldr	r3, [sp, #24]
	ldr	r0, .L3016+52
	ldr	r1, [r7]
	ldr	r3, [r3]
	ldrh	r0, [r0]
	ldrh	fp, [r1, #134]
	str	r3, [sp, #24]
	ldr	r3, .L3016+56
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp, #28]
	ldr	r3, .L3016+40
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp, #12]
	ldr	r3, .L3016+60
	ldrh	r7, [sp, #12]
	ldrb	r3, [r3]	@ zero_extendqisi2
	smulbb	r2, r4, r7
	rsb	r3, r3, #24
	subs	r3, r3, r0
	movs	r0, #1
	lsl	r3, r0, r3
	uxth	r2, r2
	uxth	r3, r3
	str	r3, [sp, #20]
.L2998:
	cmp	r4, fp
	bcc	.L3004
	ldr	r3, .L3016+28
	movs	r4, #0
	strh	r5, [r1, #112]	@ movhi
	strh	r4, [r1, #114]	@ movhi
	ldrh	r3, [r3]
	strh	r4, [r1, #118]	@ movhi
	strh	fp, [r1, #132]	@ movhi
	sub	r3, r3, fp
	strh	r3, [r1, #116]	@ movhi
	bl	ftl_low_format_data_init
	mov	r0, r4
	add	sp, sp, #40
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2984:
	ldrb	r2, [r3, #2]	@ zero_extendqisi2
	adds	r3, r3, #4
	and	r2, r2, #31
	bfi	r2, r0, #3, #2
	strb	r2, [r3, #-2]
	b	.L2983
.L2993:
	ldr	r3, .L3016+64
	strh	r0, [r3]	@ movhi
	ldr	r3, .L3016+68
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L2986
	bl	ftl_test_block
.L2986:
	ldr	r3, .L3016+56
	uxth	r1, r4
	ldr	r0, .L3016+24
	movs	r6, #0
	mov	fp, r6
	mov	r8, r6
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldr	r5, [r0]
	str	r3, [sp, #16]
	ldr	r3, .L3016+40
	add	r5, r5, r1, lsl #2
	ldrb	r3, [r3]	@ zero_extendqisi2
	uxth	r2, r3
	str	r2, [sp, #20]
	mul	r2, r3, r1
	ldr	r1, .L3016+32
	ldr	r1, [r1]
	str	r1, [sp, #12]
.L2987:
	ldr	r0, [sp, #16]
	uxth	r1, fp
	cmp	r0, r1
	bhi	.L3005
	cmp	r8, #0
	bne	.L2992
	ldrb	r3, [r5, #2]	@ zero_extendqisi2
	orr	r3, r3, #224
	strb	r3, [r5, #2]
.L2992:
	adds	r4, r4, #1
	b	.L2985
.L2990:
	add	r1, r10, r2
	ldr	r0, [sp, #28]
	str	r3, [sp, #36]
	str	r2, [sp, #32]
	bl	flash_check_bad_block
	ldr	r2, [sp, #32]
	ldr	r3, [sp, #36]
	cbz	r0, .L2988
	ldrb	r0, [r5, #3]	@ zero_extendqisi2
	movs	r1, #1
	lsl	r1, r1, r10
	orrs	r1, r1, r0
	ldr	r0, [sp, #12]
	strb	r1, [r5, #3]
	ldr	r1, [sp, #12]
	ldrh	r1, [r1, #148]
	adds	r1, r1, #1
	strh	r1, [r0, #148]	@ movhi
.L2989:
	add	r10, r10, #1
.L2991:
	sub	r1, r10, r6
	ldr	r0, [sp, #20]
	uxth	r1, r1
	cmp	r0, r1
	bhi	.L2990
	add	fp, fp, #1
	add	r6, r6, r3
	subs	r2, r2, r3
	b	.L2987
.L2988:
	add	r8, r8, #1
	uxth	r8, r8
	b	.L2989
.L3005:
	uxtb	r1, fp
	mov	r10, r6
	str	r1, [sp, #28]
	b	.L2991
.L3004:
	ldr	r3, [sp, #24]
	movs	r0, #0
	mov	lr, r0
	mov	ip, r0
	add	r8, r3, r4, lsl #2
	ldrb	r3, [r8, #2]	@ zero_extendqisi2
	orr	r3, r3, #224
	strb	r3, [r8, #2]
.L2999:
	ldr	r6, [sp, #28]
	uxth	r3, ip
	cmp	r3, r6
	bcc	.L3007
	adds	r4, r4, #1
	add	r2, r2, r7
	uxth	r4, r4
	uxth	r2, r2
	b	.L2998
.L3002:
	ldrb	r10, [r8, #3]	@ zero_extendqisi2
	add	r3, lr, r6
	asr	r10, r10, r3
	tst	r10, #1
	bne	.L3000
	ldr	r3, [sp, #12]
	add	r10, r5, #80
	adds	r5, r5, #1
	uxth	r5, r5
	cmp	r3, #1
	itett	hi
	ldrhi	r3, [sp, #16]
	movls	r3, r2
	andhi	r3, r3, #1
	addhi	r3, r3, r2
	it	hi
	uxthhi	r3, r3
	add	r3, r3, r0
	strh	r3, [r1, r10, lsl #1]	@ movhi
.L3000:
	adds	r6, r6, #1
.L3003:
	uxth	r3, r6
	cmp	r3, r7
	str	r3, [sp, #16]
	bcc	.L3002
	ldr	r3, [sp, #12]
	add	ip, ip, #1
	add	lr, lr, r3
	ldr	r3, [sp, #20]
	add	r0, r0, r3
	uxth	r0, r0
	b	.L2999
.L3007:
	movs	r6, #0
	b	.L3003
.L3017:
	.align	2
.L3016:
	.word	.LANCHOR27
	.word	.LC169
	.word	.LANCHOR195
	.word	.LC0
	.word	.LANCHOR105
	.word	ftl_info_data_buffer
	.word	.LANCHOR7
	.word	.LANCHOR6
	.word	.LANCHOR104
	.word	1229739078
	.word	.LANCHOR69
	.word	.LANCHOR14
	.word	.LC170
	.word	.LANCHOR68
	.word	.LANCHOR106
	.word	.LANCHOR31
	.word	.LANCHOR62
	.word	.LANCHOR75
	.size	ftl_low_format, .-ftl_low_format
	.section	.text.ftl_re_low_format,"ax",%progbits
	.align	1
	.global	ftl_re_low_format
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_re_low_format, %function
ftl_re_low_format:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	movs	r1, #1
	ldr	r0, .L3024
	bl	printf
	bl	sblk_init
	bl	ftl_info_blk_init
	bl	ftl_ext_info_init
	ldr	r2, .L3024+4
	ldr	r3, .L3024+8
	ldrh	r7, [r2]
	ldr	r3, [r3]
	ldr	r2, .L3024+12
	ldrh	r1, [r3, #134]
	ldr	r0, [r2]
	movs	r2, #0
	mov	r5, r2
	mov	r6, r2
	add	r0, r0, r1, lsl #2
.L3019:
	cmp	r1, r7
	bcc	.L3023
	movs	r4, #0
	strh	r6, [r3, #114]	@ movhi
	strh	r5, [r3, #118]	@ movhi
	strh	r2, [r3, #116]	@ movhi
	strh	r4, [r3, #122]	@ movhi
	strh	r4, [r3, #120]	@ movhi
	strh	r4, [r3, #124]	@ movhi
	bl	ftl_low_format_data_init
	mov	r0, r4
	pop	{r3, r4, r5, r6, r7, pc}
.L3023:
	ldrb	r4, [r0, #2]	@ zero_extendqisi2
	bfc	r4, #5, #3
	strb	r4, [r0, #2]
	ands	r4, r4, #24
	bne	.L3020
	adds	r6, r6, #1
	uxth	r6, r6
.L3021:
	adds	r1, r1, #1
	uxth	r1, r1
	adds	r0, r0, #4
	b	.L3019
.L3020:
	cmp	r4, #16
	itete	eq
	addeq	r5, r5, #1
	addne	r2, r2, #1
	uxtheq	r5, r5
	uxthne	r2, r2
	b	.L3021
.L3025:
	.align	2
.L3024:
	.word	.LC171
	.word	.LANCHOR6
	.word	.LANCHOR104
	.word	.LANCHOR7
	.size	ftl_re_low_format, .-ftl_re_low_format
	.section	.text.flash_info_flush,"ax",%progbits
	.align	1
	.global	flash_info_flush
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_info_flush, %function
flash_info_flush:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	ldr	r3, .L3038
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L3027
	ldr	r2, .L3038+4
	mov	r1, #324
	ldr	r0, .L3038+8
	bl	printf
.L3027:
	ldr	r5, .L3038+12
	movs	r2, #64
	ldr	r6, .L3038+16
	movs	r1, #0
	movs	r7, #0
	ldr	r0, [r5]
	bl	ftl_memset
	movs	r3, #16
	movs	r2, #4
	ldr	r1, [r6]
	ldr	r0, .L3038+20
	bl	rknand_print_hex
	ldr	r4, [r6]
	ldr	r1, [r4, #8]
	add	r0, r4, #16
	bl	js_hash
	str	r5, [sp, #8]
	ldr	r5, .L3038+24
	str	r0, [r4, #12]
	mov	r8, r5
.L3028:
	ldr	fp, .L3038+44
	ldrb	r10, [r5]	@ zero_extendqisi2
	ldrh	r4, [r5, #2]
	ldrh	r3, [fp]
	mov	r1, r10
	ldr	r0, .L3038+28
	mov	r2, r4
	str	r3, [sp, #12]
	bl	printf
	ldr	r2, .L3038+32
	ldrh	r0, [r5, #2]
	ldr	r3, [sp, #12]
	ldrh	r2, [r2]
	subs	r2, r2, #1
	cmp	r0, r2
	blt	.L3029
	ldr	r4, [r6]
	mov	r10, #0
	ldrb	r2, [r5]	@ zero_extendqisi2
	strh	r10, [r5, #2]	@ movhi
	ldr	r3, [r4, #4]
	mov	r0, r4
	ldr	r1, [r4, #8]
	adds	r3, r3, #1
	str	r3, [r4, #4]
	ldrb	r3, [r5, #1]	@ zero_extendqisi2
	strb	r2, [r5, #1]
	ldrh	r2, [r4, #16]
	strb	r3, [r5]
	str	r3, [sp, #12]
	adds	r2, r2, #1
	strh	r2, [r0, #16]!	@ movhi
	bl	js_hash
	ldr	r3, [sp, #12]
	str	r0, [r4, #12]
	mov	r0, r10
	ldrh	r4, [fp]
	muls	r4, r3, r4
	mov	r1, r4
.L3037:
	bl	flash_erase_block
.L3030:
	ldr	r2, [r6]
	mov	r10, #1
	ldr	r3, [sp, #8]
	movs	r0, #0
	ldr	r1, [r2, #4]
	ldr	r3, [r3]
	str	r1, [r3]
	ldr	r1, .L3038+36
	str	r1, [r3, #4]
	movs	r1, #4
	stm	sp, {r1, r10}
	mov	r1, r4
	bl	flash_prog_page_en
	ldrh	r3, [r8, #2]
	adds	r0, r0, #1
	add	r3, r3, r10
	strh	r3, [r8, #2]	@ movhi
	bne	.L3031
	mov	r1, r4
	ldr	r0, .L3038+40
	bl	printf
	b	.L3028
.L3033:
	mov	r7, r10
	b	.L3028
.L3029:
	mla	r4, r10, r3, r4
	cmp	r0, #0
	bne	.L3030
	mov	r1, r4
	b	.L3037
.L3031:
	cmp	r7, #0
	beq	.L3033
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3039:
	.align	2
.L3038:
	.word	.LANCHOR14
	.word	.LANCHOR196
	.word	.LC92
	.word	.LANCHOR197
	.word	.LANCHOR27
	.word	.LC172
	.word	.LANCHOR198
	.word	.LC173
	.word	.LANCHOR142
	.word	1398362953
	.word	.LC174
	.word	.LANCHOR2
	.size	flash_info_flush, .-flash_info_flush
	.section	.text.flash_info_blk_init,"ax",%progbits
	.align	1
	.global	flash_info_blk_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_info_blk_init, %function
flash_info_blk_init:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	ldr	r3, .L3069
	ldr	r4, .L3069+4
	ldr	r3, [r3]
	tst	r3, #4096
	beq	.L3041
	ldr	r3, [r4]
	movs	r1, #50
	ldr	r2, .L3069+8
	ldr	r0, .L3069+12
	str	r3, [sp]
	mov	r3, #2048
	bl	printf
.L3041:
	ldr	r7, .L3069+16
	movs	r6, #4
.L3044:
	ldr	r10, .L3069+32
	mov	r8, #4
	ldr	r5, .L3069+20
	movs	r0, #0
	ldr	r2, [r4]
	ldrh	r1, [r10]
	ldr	r3, [r5]
	str	r8, [sp]
	muls	r1, r6, r1
	bl	flash_read_page_en
	adds	r0, r0, #1
	beq	.L3042
	ldr	r2, [r4]
	ldr	r3, [r2]
	cmp	r3, r7
	beq	.L3043
.L3042:
	adds	r6, r6, #1
	cmp	r6, #16
	bne	.L3044
.L3068:
	mov	r0, #-1
.L3040:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3052:
	ldr	r3, [r4]
	ldr	r2, [r3]
	cmp	r2, r7
	bne	.L3053
	ldr	r8, [r3, #4]
.L3046:
	ldrh	r0, [r10]
	movs	r3, #4
	ldrb	r1, [r6, #1]	@ zero_extendqisi2
	ldr	r2, [r4]
	str	r3, [sp]
	ldr	r3, [r5]
	muls	r1, r0, r1
	movs	r0, #0
	bl	flash_read_page_en
	adds	r0, r0, #1
	beq	.L3047
	ldr	r3, [r4]
	ldr	r2, [r3]
	cmp	r2, r7
	bne	.L3047
	ldr	r2, [r3, #4]
	cmp	r8, r2
	itttt	cc
	ldrbcc	r2, [r3, #37]	@ zero_extendqisi2
	ldrbcc	r3, [r3, #36]	@ zero_extendqisi2
	strbcc	r2, [r6]
	strbcc	r3, [r6, #1]
.L3047:
	mov	r8, #4
	ldrb	r1, [r6]	@ zero_extendqisi2
	ldr	r3, [r5]
	movs	r0, #0
	str	r8, [sp]
	ldr	r2, [r4]
	bl	flash_get_last_written_page
	uxth	fp, r0
	ldrh	r10, [r10]
	add	r3, fp, #1
	strh	r3, [r6, #2]	@ movhi
	ldrb	r3, [r6]	@ zero_extendqisi2
	movs	r6, #0
	mla	r10, r10, r3, r0
.L3048:
	sub	r0, fp, r6
	sxth	r3, r0
	cmp	r3, #0
	bge	.L3051
	adds	r2, r3, #1
	bne	.L3050
	ldr	r2, [r4]
	ldr	r0, .L3069+24
	str	r3, [sp, #12]
	ldr	r1, [r2]
	bl	printf
	b	.L3068
.L3051:
	str	r8, [sp]
	sub	r1, r10, r6
	ldr	r3, [r5]
	movs	r0, #0
	ldr	r2, [r4]
	bl	flash_read_page_en
	adds	r0, r0, #1
	beq	.L3049
	ldr	r3, [r4]
	ldr	r3, [r3]
	cmp	r3, r7
	beq	.L3050
.L3049:
	adds	r6, r6, #1
	b	.L3048
.L3050:
	cmp	r6, #1
	bls	.L3054
	bl	flash_info_flush
.L3054:
	movs	r0, #0
	b	.L3040
.L3043:
	ldrb	r1, [r2, #36]	@ zero_extendqisi2
	ldrh	r0, [r10]
	ldrb	r3, [r2, #37]	@ zero_extendqisi2
	ldr	r6, .L3069+28
	strb	r1, [r6]
	muls	r1, r0, r1
	strb	r3, [r6, #1]
	movs	r0, #0
	str	r8, [sp]
	ldr	r3, [r5]
	bl	flash_read_page_en
	adds	r0, r0, #1
	bne	.L3052
.L3053:
	mov	r8, #0
	b	.L3046
.L3070:
	.align	2
.L3069:
	.word	.LANCHOR14
	.word	.LANCHOR27
	.word	.LANCHOR199
	.word	.LC175
	.word	1398362953
	.word	.LANCHOR197
	.word	.LC176
	.word	.LANCHOR198
	.word	.LANCHOR2
	.size	flash_info_blk_init, .-flash_info_blk_init
	.section	.text.nand_flash_init,"ax",%progbits
	.align	1
	.global	nand_flash_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	nand_flash_init, %function
nand_flash_init:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	ldr	r5, .L3155
	ldr	r3, [r5]
	lsls	r0, r3, #19
	bpl	.L3072
	ldr	r2, .L3155+4
	movw	r1, #2578
	ldr	r0, .L3155+8
	bl	printf
.L3072:
	ldr	r3, .L3155+12
	movs	r7, #0
	mov	r0, r4
	ldr	r8, .L3155+168
	ldr	r6, .L3155+16
	str	r7, [r3]
	bl	nandc_init
	ldr	r3, .L3155+20
	movs	r2, #1
	ldr	r4, .L3155+24
	mov	r1, r7
	ldr	r0, .L3155+28
	strb	r2, [r3]
	movs	r3, #3
	movs	r2, #8
	strb	r3, [r8]
	str	r4, [r6]
	bl	ftl_memset
	movs	r2, #32
	mov	r1, r7
	ldr	r0, .L3155+32
	bl	ftl_memset
	str	r8, [sp]
	ldr	r8, .L3155+36
	mov	r10, r8
.L3078:
	lsl	fp, r7, #3
	uxtb	r0, r7
	add	r1, r8, fp
	bl	flash_read_id
	cbnz	r7, .L3073
	ldrb	r3, [r8]	@ zero_extendqisi2
	subs	r3, r3, #1
	uxtb	r3, r3
	cmp	r3, #253
	bls	.L3074
.L3076:
	mvn	fp, #1
.L3071:
	mov	r0, fp
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3074:
	ldrb	r3, [r8, #1]	@ zero_extendqisi2
	cmp	r3, #255
	beq	.L3076
.L3073:
	ldrb	r3, [r10, fp]	@ zero_extendqisi2
	adds	r7, r7, #1
	cmp	r3, #181
	itt	eq
	moveq	r3, #44
	strbeq	r3, [r10, fp]
	cmp	r7, #4
	bne	.L3078
	ldr	r8, .L3155+172
	movs	r7, #0
	ldr	r3, .L3155+36
.L3081:
	mov	r1, r3
	ldrb	r2, [r8, #-1]	@ zero_extendqisi2
	mov	r0, r8
	str	r3, [sp, #4]
	lsl	fp, r7, #5
	bl	flash_mem_cmp8
	ldr	r3, [sp, #4]
	cmp	r0, #0
	bne	.L3079
	ldr	r7, .L3155+40
	ldr	r3, .L3155+44
	add	r7, r7, fp
	ldrb	r2, [r7, #22]	@ zero_extendqisi2
	mov	r1, r3
.L3080:
	lsl	ip, r0, #5
	ldrb	ip, [ip, r3]	@ zero_extendqisi2
	cmp	ip, r2
	beq	.L3082
	adds	r0, r0, #1
	cmp	r0, #4
	bne	.L3080
.L3082:
	add	r1, r1, r0, lsl #5
	movs	r2, #32
	ldr	r0, .L3155+48
	bl	ftl_memcpy
	movs	r2, #32
	mov	r1, r7
	ldr	r0, .L3155+24
	bl	ftl_memcpy
	ldr	r3, .L3155+52
	ldrb	r2, [r3]	@ zero_extendqisi2
	mov	fp, r3
	cmp	r2, #8
	bhi	.L3083
	ldrb	r3, [r4, #20]	@ zero_extendqisi2
	cmp	r3, #60
	bls	.L3083
	movs	r3, #60
	strb	r3, [r4, #20]
.L3083:
	ldr	r3, [r5]
	lsls	r3, r3, #19
	bpl	.L3114
	ldr	r2, .L3155+4
	movw	r1, #2600
	ldr	r0, .L3155+8
	bl	printf
.L3114:
	ldr	r3, [r6]
	mov	r0, #16384
	ldr	r7, .L3155+56
	mov	r8, #0
	ldrh	r3, [r3, #10]
	cmp	r3, #2304
	ittt	eq
	ldreq	r2, [sp]
	moveq	r3, #2
	strbeq	r3, [r2]
	bl	ftl_malloc
	ldr	r3, .L3155+60
	str	r0, [r3]
	mov	r0, #16384
	bl	ftl_malloc
	ldr	r3, .L3155+64
	str	r0, [r3]
	mov	r0, #2048
	bl	ftl_malloc
	str	r0, [r7]
	movs	r0, #64
	bl	ftl_malloc
	ldr	r3, .L3155+68
	str	r0, [r3]
	movs	r0, #64
	bl	ftl_malloc
	ldr	r3, .L3155+72
	str	r0, [r3]
	movs	r0, #64
	bl	ftl_malloc
	ldr	r3, .L3155+76
	str	r0, [r3]
	ldr	r3, .L3155+80
	strb	r8, [r3]
	bl	flash_die_info_init
	ldrb	r0, [r4, #18]	@ zero_extendqisi2
	bl	flash_lsb_page_tbl_build
	ldrb	r0, [r4, #20]	@ zero_extendqisi2
	bl	nandc_bch_sel
	ldr	r1, [r6]
	ldr	r0, .L3155+84
	ldrh	r3, [r1, #16]
	ubfx	r2, r3, #8, #3
	ubfx	r6, r3, #3, #1
	strb	r2, [r0]
	ldr	r2, .L3155+88
	strb	r6, [r2]
	ubfx	r6, r3, #4, #1
	ldr	r2, .L3155+92
	strb	r6, [r2]
	ubfx	r6, r3, #12, #1
	ldr	r2, .L3155+96
	strb	r6, [r2]
	ubfx	r6, r3, #13, #1
	ldr	r2, .L3155+100
	strb	r6, [r2]
	ubfx	r6, r3, #11, #1
	ldr	r2, .L3155+104
	strb	r6, [r2]
	ldrb	r2, [r1, #31]	@ zero_extendqisi2
	ldr	r6, .L3155+108
	ldrb	r1, [r1, #28]	@ zero_extendqisi2
	ubfx	ip, r2, #1, #1
	ubfx	r2, r2, #2, #1
	strb	ip, [r6]
	ldr	r6, .L3155+112
	strb	r2, [r6]
	ubfx	r6, r3, #14, #1
	ldr	r2, .L3155+116
	lsrs	r3, r3, #15
	strb	r6, [r2]
	ldr	r2, .L3155+120
	ldr	r6, .L3155+124
	strb	r3, [r2]
	movs	r2, #60
	ldr	r3, .L3155+128
	str	r8, [r6]
	mov	r8, r0
	strb	r1, [r3]
	ldr	r3, .L3155+132
	strb	r2, [r3]
	ldrb	r2, [fp]	@ zero_extendqisi2
	cmp	r2, #9
	itt	eq
	moveq	r0, #70
	strbeq	r0, [r3]
	ldr	r3, .L3155+136
	strb	r1, [r3]
	ldrb	r1, [r4, #7]	@ zero_extendqisi2
	cmp	r1, #9
	itt	eq
	moveq	r1, #0
	strbeq	r1, [r3]
	ldrb	r1, [r4, #31]	@ zero_extendqisi2
	lsls	r1, r1, #31
	itt	mi
	movmi	r1, #3
	strbmi	r1, [r3]
	cmp	r2, #8
	bne	.L3088
	ldrb	r2, [r10]	@ zero_extendqisi2
	cmp	r2, #44
	beq	.L3089
	cmp	r2, #137
	bne	.L3088
.L3089:
	ldrb	r2, [r4, #28]	@ zero_extendqisi2
	cmp	r2, #3
	itt	eq
	moveq	r2, #0
	strbeq	r2, [r3]
.L3088:
	ldrh	r1, [r4, #16]
	ldrb	r3, [r4, #19]	@ zero_extendqisi2
	ldr	r2, .L3155+140
	tst	r1, #64
	strb	r3, [r2]
	mov	r4, r2
	beq	.L3091
	sub	r2, r3, #17
	cmp	r2, #2
	bls	.L3092
	cmp	r3, #21
	bne	.L3093
.L3092:
	ldr	r2, .L3155+144
	cmp	r3, #21
	ldr	r3, .L3155+148
	str	r2, [r6]
	beq	.L3154
	movs	r2, #15
.L3152:
	strb	r2, [r3]
.L3091:
	ldr	r3, [r5]
	lsls	r3, r3, #19
	bpl	.L3103
	ldr	r2, .L3155+4
	movw	r1, #2671
	ldr	r0, .L3155+8
	bl	printf
.L3103:
	ldr	r3, .L3155+152
	movs	r2, #0
	movs	r0, #4
	strb	r2, [r3]
	mov	r10, r3
	ldrb	r2, [r8]	@ zero_extendqisi2
	tst	r2, #1
	beq	.L3104
	bl	nandc_set_if_mode
	movs	r0, #1
	bl	flash_set_interface_mode
	movs	r0, #1
.L3104:
	bl	nandc_set_if_mode
	bl	flash_info_blk_init
	cmp	r0, #-1
	mov	fp, r0
	bne	.L3106
	ldr	r3, [r5]
	lsls	r0, r3, #19
	bpl	.L3107
	ldr	r2, .L3155+4
	mov	r1, #2688
	ldr	r0, .L3155+8
	bl	printf
.L3107:
	ldr	r3, [r7]
	movs	r2, #17
	movs	r0, #0
	strb	r2, [r3, #32]
	ldr	r3, .L3155+156
	strb	r0, [r3]
	bl	zftl_flash_exit_slc_mode
	b	.L3071
.L3079:
	adds	r7, r7, #1
	add	r8, r8, #32
	cmp	r7, #44
	bne	.L3081
	b	.L3076
.L3093:
	cmp	r3, #33
	beq	.L3096
	sub	r2, r3, #65
	cmp	r2, #1
	bhi	.L3097
.L3096:
	ldr	r3, .L3155+160
	movs	r2, #4
	str	r3, [r6]
	ldr	r3, .L3155+164
	strb	r2, [r3]
.L3153:
	movs	r2, #7
	ldr	r3, .L3155+148
	b	.L3152
.L3156:
	.align	2
.L3155:
	.word	.LANCHOR14
	.word	.LANCHOR200
	.word	.LC92
	.word	.LANCHOR163
	.word	.LANCHOR16
	.word	.LANCHOR18
	.word	.LANCHOR32
	.word	.LANCHOR30
	.word	.LANCHOR143
	.word	.LANCHOR44
	.word	.LANCHOR201
	.word	.LANCHOR202
	.word	.LANCHOR20
	.word	.LANCHOR28
	.word	.LANCHOR27
	.word	.LANCHOR167
	.word	.LANCHOR159
	.word	.LANCHOR166
	.word	.LANCHOR161
	.word	.LANCHOR197
	.word	.LANCHOR203
	.word	.LANCHOR45
	.word	.LANCHOR171
	.word	.LANCHOR41
	.word	.LANCHOR77
	.word	.LANCHOR74
	.word	.LANCHOR35
	.word	.LANCHOR204
	.word	.LANCHOR205
	.word	.LANCHOR1
	.word	.LANCHOR75
	.word	.LANCHOR165
	.word	.LANCHOR0
	.word	.LANCHOR17
	.word	.LANCHOR19
	.word	.LANCHOR23
	.word	micron_read_retrial
	.word	.LANCHOR162
	.word	.LANCHOR21
	.word	.LANCHOR33
	.word	toshiba_read_retrial
	.word	.LANCHOR26
	.word	.LANCHOR31
	.word	.LANCHOR201+1
.L3097:
	sub	r2, r3, #67
	uxtb	r2, r2
	cmp	r2, #1
	bls	.L3098
	sub	r1, r3, #34
	cmp	r1, #1
	bhi	.L3099
.L3098:
	ldr	r1, .L3157
	cmp	r3, #35
	str	r1, [r6]
	ldr	r1, .L3157+4
	beq	.L3100
	cmp	r3, #68
	beq	.L3100
	movs	r3, #7
.L3151:
	cmp	r2, #1
	strb	r3, [r1]
	ldr	r3, .L3157+8
	bhi	.L3102
.L3154:
	movs	r2, #4
	b	.L3152
.L3100:
	movs	r3, #17
	b	.L3151
.L3102:
	movs	r2, #5
	b	.L3152
.L3099:
	subs	r3, r3, #36
	cmp	r3, #1
	bhi	.L3091
	ldr	r3, .L3157+12
	str	r3, [r6]
	b	.L3153
.L3106:
	ldrb	r3, [r4]	@ zero_extendqisi2
	subs	r3, r3, #1
	cmp	r3, #7
	itt	ls
	ldrls	r3, .L3157+16
	strls	r3, [r6]
	ldrb	r3, [r8]	@ zero_extendqisi2
	lsls	r1, r3, #29
	bpl	.L3110
	ldr	r3, [r7]
	ldrb	r3, [r3, #19]	@ zero_extendqisi2
	cbz	r3, .L3110
	ldr	r2, .L3157+20
	movs	r0, #0
	ldr	r3, .L3157+24
	ldrh	r1, [r2]
	ldrb	r3, [r3]	@ zero_extendqisi2
	muls	r1, r3, r1
	bl	flash_ddr_para_scan
	ldrb	r3, [r10]	@ zero_extendqisi2
	cbnz	r3, .L3110
	ldr	r2, [r7]
	strb	r3, [r2, #19]
	bl	flash_info_flush
.L3110:
	ldr	r3, [r5]
	lsls	r2, r3, #19
	bpl	.L3112
	ldr	r2, .L3157+28
	movw	r1, #2740
	ldr	r0, .L3157+32
	bl	printf
.L3112:
	bl	nand_flash_print_info
	mov	fp, #0
	b	.L3071
.L3158:
	.align	2
.L3157:
	.word	toshiba_read_retrial
	.word	.LANCHOR162
	.word	.LANCHOR26
	.word	toshiba_3d_read_retrial
	.word	hynix_read_retrial
	.word	.LANCHOR2
	.word	.LANCHOR198
	.word	.LANCHOR200
	.word	.LC92
	.size	nand_flash_init, .-nand_flash_init
	.section	.text.ftl_sysblk_dump,"ax",%progbits
	.align	1
	.global	ftl_sysblk_dump
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_sysblk_dump, %function
ftl_sysblk_dump:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	fp, r0
	sub	sp, sp, #48
	movs	r0, #1
	movs	r6, #0
	bl	buf_alloc
	ldr	r3, [r0, #4]
	mov	r4, r0
	mov	r5, r6
	str	r3, [sp, #44]
.L3160:
	ldr	r3, .L3169
	ldrh	r2, [r3]
	uxth	r3, r6
	cmp	r2, r3
	bhi	.L3162
	ldr	r1, [sp, #44]
	movs	r3, #32
	ldr	r0, .L3169+4
	movs	r2, #4
	add	r1, r1, #704
	bl	rknand_print_hex
	mov	r0, r4
	bl	zbuf_free
	cbz	r5, .L3163
	movw	r2, #1422
	ldr	r1, .L3169+8
	ldr	r0, .L3169+12
	bl	printf
.L3163:
	mov	r0, r5
	add	sp, sp, #48
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3162:
	ldr	r3, .L3169+16
	uxth	r7, r6
	ldr	r2, [r4, #12]
	ldr	r1, [r4, #4]
	ldrh	r8, [r3]
	ldr	r3, .L3169+20
	mla	r8, fp, r8, r7
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r0, r8
	bl	ftl_read_ppa_page
	ldr	r2, [r4, #12]
	mov	r10, r0
	ldr	r3, [r4, #4]
	ldr	r1, [r2, #12]
	str	r1, [sp, #32]
	ldr	r1, [r2, #8]
	str	r1, [sp, #28]
	ldr	r1, [r2, #4]
	str	r1, [sp, #24]
	mov	r1, fp
	ldr	r2, [r2]
	str	r2, [sp, #20]
	ldr	r2, [r3, #12]
	str	r2, [sp, #16]
	ldr	r2, [r3, #8]
	str	r2, [sp, #12]
	ldr	r2, [r3, #4]
	str	r2, [sp, #8]
	mov	r2, r7
	ldr	r3, [r3]
	str	r0, [sp]
	ldr	r0, .L3169+24
	str	r3, [sp, #4]
	mov	r3, r8
	bl	printf
	cmp	r10, #-1
	beq	.L3164
	cmp	r10, #512
	it	eq
	moveq	r5, #1
.L3161:
	adds	r6, r6, #1
	b	.L3160
.L3164:
	movs	r5, #1
	b	.L3161
.L3170:
	.align	2
.L3169:
	.word	.LANCHOR87
	.word	.LC177
	.word	.LANCHOR206
	.word	.LC0
	.word	.LANCHOR105
	.word	.LANCHOR125
	.word	.LC163
	.size	ftl_sysblk_dump, .-ftl_sysblk_dump
	.section	.text.dump_ftl_info,"ax",%progbits
	.align	1
	.global	dump_ftl_info
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	dump_ftl_info, %function
dump_ftl_info:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L3172
	push	{r0, r1, r2, r4, r5, r6, r7, lr}
	ldr	r0, .L3172+4
	ldrb	r1, [r3]	@ zero_extendqisi2
	bl	printf
	ldr	r1, .L3172+8
	ldr	r5, .L3172+12
	ldr	r0, .L3172+16
	ldrh	r3, [r1, #2]
	ldrb	r2, [r1, #1]	@ zero_extendqisi2
	ldrb	r1, [r1]	@ zero_extendqisi2
	bl	printf
	ldr	r3, [r5]
	ldr	r4, .L3172+20
	ldr	r0, .L3172+24
	ldrh	r2, [r3, #140]
	ldrh	r1, [r3, #130]
	bl	printf
	ldr	r0, [r4]
	ldr	r7, .L3172+28
	ldrh	r6, [r0, #26]
	ldrb	r3, [r0, #21]	@ zero_extendqisi2
	ldrh	r2, [r0, #18]
	ldrh	r1, [r0, #16]
	str	r6, [sp, #4]
	ldrh	r0, [r0, #22]
	str	r0, [sp]
	ldr	r0, .L3172+32
	bl	printf
	ldr	r0, [r4]
	ldrh	r6, [r0, #58]
	ldrb	r3, [r0, #53]	@ zero_extendqisi2
	ldrh	r2, [r0, #50]
	ldrh	r1, [r0, #48]
	str	r6, [sp, #4]
	ldrh	r0, [r0, #54]
	ldr	r6, .L3172+36
	str	r0, [sp]
	ldr	r0, .L3172+40
	bl	printf
	ldr	r0, [r4]
	ldrh	r4, [r0, #90]
	ldrb	r3, [r0, #85]	@ zero_extendqisi2
	ldrh	r2, [r0, #82]
	ldrh	r1, [r0, #80]
	str	r4, [sp, #4]
	ldrh	r0, [r0, #86]
	ldr	r4, .L3172+44
	str	r0, [sp]
	ldr	r0, .L3172+48
	bl	printf
	ldrh	r2, [r6]
	ldrb	r3, [r4]	@ zero_extendqisi2
	ldr	r1, .L3172+52
	ldr	r0, .L3172+56
	muls	r3, r2, r3
	ldr	r1, [r1]
	movs	r2, #4
	lsls	r3, r3, #1
	bl	rknand_print_hex
	ldr	r1, .L3172+60
	movs	r2, #2
	ldrh	r3, [r7]
	ldr	r0, .L3172+64
	ldr	r1, [r1]
	bl	rknand_print_hex
	ldr	r1, [r5]
	movs	r2, #4
	ldr	r0, .L3172+68
	ldrh	r3, [r1, #698]
	add	r1, r1, #704
	bl	rknand_print_hex
	ldr	r1, .L3172+72
	movs	r2, #4
	ldrh	r3, [r7]
	ldr	r0, .L3172+76
	ldr	r1, [r1]
	bl	rknand_print_hex
	mov	r3, #256
	movs	r2, #2
	ldr	r1, .L3172+80
	ldr	r0, .L3172+84
	bl	rknand_print_hex
	ldrh	r2, [r6]
	ldrb	r3, [r4]	@ zero_extendqisi2
	ldr	r1, .L3172+88
	ldr	r0, .L3172+92
	muls	r3, r2, r3
	ldr	r1, [r1]
	movs	r2, #2
	lsls	r3, r3, #1
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, lr}
	b	rknand_print_hex
.L3173:
	.align	2
.L3172:
	.word	.LANCHOR54
	.word	.LC178
	.word	.LANCHOR182
	.word	.LANCHOR104
	.word	.LC179
	.word	.LANCHOR10
	.word	.LC180
	.word	.LANCHOR6
	.word	.LC181
	.word	.LANCHOR87
	.word	.LC182
	.word	.LANCHOR80
	.word	.LC183
	.word	.LANCHOR111
	.word	.LC184
	.word	.LANCHOR9
	.word	.LC185
	.word	.LC177
	.word	.LANCHOR7
	.word	.LC186
	.word	.LANCHOR110
	.word	.LC187
	.word	.LANCHOR112
	.word	.LC188
	.size	dump_ftl_info, .-dump_ftl_info
	.section	.text.pm_ppa_update_check,"ax",%progbits
	.align	1
	.global	pm_ppa_update_check
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	pm_ppa_update_check, %function
pm_ppa_update_check:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	mov	r7, r2
	ldr	r2, .L3181
	mov	r5, r0
	mov	r6, r1
	ldr	r3, .L3181+4
	ldrb	r4, [r2]	@ zero_extendqisi2
	ldrh	r3, [r3]
	rsb	r4, r4, #24
	subs	r0, r4, r3
	movs	r4, #1
	lsls	r4, r4, r0
	lsr	r0, r7, r3
	ldr	r3, .L3181+8
	subs	r4, r4, #1
	ands	r0, r0, r4
	ldrb	r1, [r3]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	ldr	r3, .L3181+12
	uxth	r0, r0
	ldr	r3, [r3]
	add	r0, r3, r0, lsl #2
	ldrb	r3, [r0, #2]	@ zero_extendqisi2
	lsrs	r3, r3, #5
	cmp	r3, #1
	beq	.L3175
	cmp	r3, #7
	bne	.L3177
.L3175:
	mov	r3, r7
	mov	r2, r6
	mov	r1, r5
	ldr	r0, .L3181+16
	bl	printf
	bl	dump_ftl_info
	mov	r0, #-1
	pop	{r3, r4, r5, r6, r7, pc}
.L3177:
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, pc}
.L3182:
	.align	2
.L3181:
	.word	.LANCHOR31
	.word	.LANCHOR68
	.word	.LANCHOR69
	.word	.LANCHOR7
	.word	.LC189
	.size	pm_ppa_update_check, .-pm_ppa_update_check
	.section	.text.load_l2p_region,"ax",%progbits
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	load_l2p_region, %function
load_l2p_region:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	cmp	r1, #31
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r5, r0
	mov	r7, r1
	bls	.L3184
	movs	r2, #32
	ldr	r1, .L3204
	ldr	r0, .L3204+4
	bl	printf
.L3184:
	ldr	r6, .L3204+8
	ldr	r3, [r6]
	mov	fp, r6
	ldrh	r2, [r3, #698]
	cmp	r2, r5
	bcs	.L3185
	mov	r1, r5
	ldr	r0, .L3204+12
	bl	printf
	ldr	r3, .L3204+16
	movs	r4, #0
	movs	r1, #255
	ldr	r0, [r4, #4]
	ldrh	r2, [r3]
	bl	ftl_memset
	ldr	r3, [r6]
	ldrh	r3, [r3, #698]
	cmp	r3, r5
	bcc	.L3186
.L3202:
	movs	r0, #0
.L3183:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3186:
	movs	r2, #36
.L3203:
	ldr	r1, .L3204
	ldr	r0, .L3204+4
	bl	printf
	b	.L3202
.L3185:
	add	r2, r5, #176
	ldr	r4, [r3, r2, lsl #2]
	movs	r2, #0
	ldr	r3, .L3204+20
	strh	r5, [r3, r7, lsl #3]	@ movhi
	lsls	r7, r7, #3
	str	r3, [sp, #12]
	add	r10, r3, r7
	strh	r2, [r10, #2]	@ movhi
	cbnz	r4, .L3188
	mov	r2, r4
	mov	r1, r5
	ldr	r0, .L3204+24
	bl	printf
	ldr	r3, .L3204+16
	movs	r1, #255
	ldr	r0, [r10, #4]
	ldrh	r2, [r3]
	bl	ftl_memset
	b	.L3202
.L3188:
	ldr	r6, .L3204+28
	mov	r0, r4
	ldr	r8, .L3204+48
	ldr	r1, [r10, #4]
	ldr	r2, [r6]
	ldrb	r3, [r8]	@ zero_extendqisi2
	bl	ftl_read_ppa_page
	ldr	r2, [r6]
	mov	r3, r0
	ldr	r2, [r2]
	cmp	r2, r5
	bne	.L3189
	adds	r1, r0, #1
	beq	.L3189
	cmp	r0, #512
	beq	.L3189
.L3192:
	ldr	r3, [r6]
	ldr	r3, [r3]
	cmp	r5, r3
	beq	.L3202
	movs	r2, #63
	b	.L3203
.L3189:
	mov	r1, r5
	str	r4, [sp]
	ldr	r0, .L3204+32
	bl	printf
	ldr	r1, [fp]
	movs	r2, #4
	ldr	r0, .L3204+36
	ldrh	r3, [r1, #698]
	add	r1, r1, #704
	bl	rknand_print_hex
	ldr	r2, [sp, #12]
	ldrb	r3, [r8]	@ zero_extendqisi2
	ldr	r0, .L3204+40
	add	r2, r2, r7
	mov	r7, r2
	movs	r2, #4
	lsls	r3, r3, #7
	ldr	r1, [r7, #4]
	bl	rknand_print_hex
	movs	r3, #16
	movs	r2, #4
	ldr	r1, [r6]
	ldr	r0, .L3204+44
	bl	rknand_print_hex
	ldrb	r3, [r8]	@ zero_extendqisi2
	mov	r0, r4
	ldr	r2, [r6]
	ldr	r1, [r7, #4]
	bl	ftl_read_ppa_page
	ldr	r3, [r6]
	ldr	r3, [r3]
	cmp	r5, r3
	bne	.L3195
	adds	r3, r0, #1
	beq	.L3183
	cmp	r0, #512
	bne	.L3192
.L3195:
	mov	r0, #-1
	b	.L3183
.L3205:
	.align	2
.L3204:
	.word	.LANCHOR207
	.word	.LC0
	.word	.LANCHOR104
	.word	.LC190
	.word	.LANCHOR208
	.word	.LANCHOR134
	.word	.LC191
	.word	.LANCHOR191
	.word	.LC192
	.word	.LC193
	.word	.LC194
	.word	.LC195
	.word	.LANCHOR125
	.size	load_l2p_region, .-load_l2p_region
	.section	.text.pm_gc,"ax",%progbits
	.align	1
	.global	pm_gc
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	pm_gc, %function
pm_gc:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	ldr	r4, .L3223
	ldr	r5, .L3223+4
	ldr	r3, [r4]
	ldr	r6, .L3223+8
	ldrh	r2, [r5]
	ldrh	r1, [r3, #688]
	subs	r2, r2, #1
	cmp	r1, r2
	bge	.L3207
	ldr	r3, [r6]
	cmp	r3, #0
	beq	.L3208
.L3207:
	bl	pm_free_sblk
	ldr	r2, [r4]
	ldrh	r3, [r5]
	ldrh	r1, [r2, #688]
	subs	r3, r3, #1
	cmp	r1, r3
	bge	.L3209
	ldr	r3, [r6]
	cmp	r3, #0
	beq	.L3208
.L3209:
	uxth	r0, r0
	movw	r5, #65535
	movs	r3, #0
	adds	r0, r0, #208
	str	r3, [r6]
	ldrh	r8, [r2, r0, lsl #1]
	cmp	r8, r5
	bne	.L3211
	movs	r2, #162
	ldr	r1, .L3223+12
	ldr	r0, .L3223+16
	bl	printf
	bl	pm_free_sblk
	ldr	r3, [r4]
	uxth	r0, r0
	adds	r0, r0, #208
	ldrh	r8, [r3, r0, lsl #1]
	cmp	r8, r5
	beq	.L3208
.L3211:
	ldr	r5, .L3223+20
	bl	pm_select_ram_region
	mov	r6, r0
	movw	r3, #65535
	ldrh	r0, [r5, r0, lsl #3]
	cmp	r0, r3
	beq	.L3212
	add	r7, r5, r6, lsl #3
	ldr	r1, [r7, #4]
	cbz	r1, .L3212
	ldrsh	r3, [r7, #2]
	cmp	r3, #0
	bge	.L3212
	bl	pm_write_page
	ldrh	r3, [r7, #2]
	ubfx	r3, r3, #0, #15
	strh	r3, [r7, #2]	@ movhi
.L3212:
	movs	r7, #0
.L3213:
	ldr	r1, [r4]
	uxth	fp, r7
	ldrh	r3, [r1, #698]
	cmp	r3, fp
	bhi	.L3216
	bl	pm_free_sblk
.L3208:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3216:
	ldr	r3, .L3223+24
	uxth	r10, r7
	mov	ip, #1
	ldrh	r0, [r3]
	ldr	r3, .L3223+28
	ldrb	r3, [r3]	@ zero_extendqisi2
	rsb	r3, r3, #24
	subs	r3, r3, r0
	lsl	r3, ip, r3
	add	ip, r10, #176
	ldr	r1, [r1, ip, lsl #2]
	subs	r3, r3, #1
	lsr	r0, r1, r0
	ldr	r1, .L3223+32
	ands	r0, r0, r3
	ldrb	r1, [r1]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	uxth	r0, r0
	cmp	r8, r0
	bne	.L3214
	mov	r1, r6
	mov	r0, fp
	bl	load_l2p_region
	cbnz	r0, .L3215
	add	r3, r5, r6, lsl #3
	mov	r0, r10
	ldr	r1, [r3, #4]
	bl	pm_write_page
.L3215:
	movw	r3, #65535
	strh	r3, [r5, r6, lsl #3]	@ movhi
.L3214:
	adds	r7, r7, #1
	b	.L3213
.L3224:
	.align	2
.L3223:
	.word	.LANCHOR104
	.word	.LANCHOR149
	.word	.LANCHOR146
	.word	.LANCHOR209
	.word	.LC0
	.word	.LANCHOR134
	.word	.LANCHOR68
	.word	.LANCHOR31
	.word	.LANCHOR69
	.size	pm_gc, .-pm_gc
	.section	.text.pm_flush_id,"ax",%progbits
	.align	1
	.global	pm_flush_id
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	pm_flush_id, %function
pm_flush_id:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L3230
	push	{r4, lr}
	add	r4, r3, r0, lsl #3
	ldrh	r0, [r3, r0, lsl #3]
	ldr	r1, [r4, #4]
	bl	pm_write_page
	ldrh	r3, [r4, #2]
	ubfx	r3, r3, #0, #15
	strh	r3, [r4, #2]	@ movhi
	ldr	r4, .L3230+4
	ldr	r3, [r4]
	cbz	r3, .L3226
	bl	pm_gc
	movs	r3, #0
	str	r3, [r4]
.L3226:
	movs	r0, #0
	pop	{r4, pc}
.L3231:
	.align	2
.L3230:
	.word	.LANCHOR134
	.word	.LANCHOR132
	.size	pm_flush_id, .-pm_flush_id
	.section	.text.pm_flush,"ax",%progbits
	.align	1
	.global	pm_flush
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	pm_flush, %function
pm_flush:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	movs	r4, #0
	ldr	r5, .L3236
.L3234:
	add	r3, r5, r4, lsl #3
	uxth	r0, r4
	ldrsh	r3, [r3, #2]
	cmp	r3, #0
	bge	.L3233
	bl	pm_flush_id
.L3233:
	adds	r4, r4, #1
	cmp	r4, #32
	bne	.L3234
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L3237:
	.align	2
.L3236:
	.word	.LANCHOR134
	.size	pm_flush, .-pm_flush
	.section	.text.flt_sys_flush,"ax",%progbits
	.align	1
	.global	flt_sys_flush
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flt_sys_flush, %function
flt_sys_flush:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	bl	ftl_flush
	bl	pm_flush
	bl	ftl_ext_info_flush
	movs	r0, #0
	pop	{r3, lr}
	b	ftl_info_flush
	.size	flt_sys_flush, .-flt_sys_flush
	.section	.text.rk_ftl_de_init,"ax",%progbits
	.align	1
	.global	rk_ftl_de_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	rk_ftl_de_init, %function
rk_ftl_de_init:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	bl	zftl_flash_de_init
	bl	flt_sys_flush
	pop	{r3, lr}
	b	zftl_flash_de_init
	.size	rk_ftl_de_init, .-rk_ftl_de_init
	.section	.text.zftl_deinit,"ax",%progbits
	.align	1
	.global	zftl_deinit
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	zftl_deinit, %function
zftl_deinit:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	b	rk_ftl_de_init
	.size	zftl_deinit, .-zftl_deinit
	.section	.text.pm_init,"ax",%progbits
	.align	1
	.global	pm_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	pm_init, %function
pm_init:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r4, #0
	ldr	r3, .L3262
	movs	r2, #1
	mov	r8, r0
	movs	r0, #64
	ldr	r6, .L3262+4
	str	r4, [r3]
	ldr	r3, .L3262+8
	mov	r5, r6
	str	r4, [r3]
	ldr	r3, .L3262+12
	strb	r2, [r3]
	bl	ftl_malloc
	ldr	r3, .L3262+16
	mov	r10, r3
	str	r0, [r3]
.L3243:
	movw	r3, #65535
	adds	r7, r6, r4
	strh	r3, [r4, r6]	@ movhi
	movs	r3, #0
	strh	r3, [r7, #2]	@ movhi
	cmp	r8, #0
	beq	.L3242
	ldr	r3, .L3262+20
	ldrb	r0, [r3]	@ zero_extendqisi2
	lsls	r0, r0, #9
	bl	ftl_malloc
	str	r0, [r7, #4]
.L3242:
	adds	r4, r4, #8
	cmp	r4, #256
	bne	.L3243
	ldr	r3, [r5, #4]
	ldr	r4, .L3262+24
	ldr	r10, [r10]
	str	r3, [sp, #12]
	ldr	r3, [r4]
	ldr	r2, [sp, #12]
	ldrh	r1, [r3, #692]
	ldrb	r0, [r3, #694]	@ zero_extendqisi2
	movs	r3, #4
	str	r3, [sp]
	mov	r3, r10
	bl	flash_get_last_written_page
	ldr	r1, [r4]
	mov	r6, r0
	ldrh	r2, [r1, #696]
	cmp	r2, r0
	bgt	.L3244
	mov	r3, r0
	ldrh	r1, [r1, #692]
	ldr	r0, .L3262+28
	bl	printf
	ldr	r3, [r4]
	ldrsh	r7, [r3, #696]
.L3245:
	cmp	r7, r6
	ble	.L3247
	ldr	r3, .L3262+32
	movs	r2, #1
	add	r6, r6, r2
	strb	r2, [r3]
	ldr	r3, [r4]
	strh	r6, [r3, #696]	@ movhi
	bl	pm_free_sblk
.L3244:
	ldr	r3, .L3262+36
	movs	r1, #255
	ldr	r0, [r5, #4]
	ldrh	r2, [r3]
	bl	ftl_memset
	ldr	r1, [r5, #4]
	mov	r0, #-1
	bl	pm_write_page
	ldr	r3, .L3262+32
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L3248
	ldr	r1, [r5, #4]
	mov	r0, #-1
	bl	pm_write_page
	ldr	r1, [r5, #4]
	mov	r0, #-1
	bl	pm_write_page
	ldr	r1, [r5, #4]
	mov	r0, #-1
	bl	pm_write_page
.L3248:
	bl	pm_free_sblk
	bl	pm_gc
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3247:
	ldr	r3, [r4]
	ldr	r2, .L3262+40
	ldrh	r8, [r3, #692]
	ldrh	r2, [r2]
	ldrb	r0, [r3, #694]	@ zero_extendqisi2
	ldr	r3, .L3262+20
	mla	r8, r2, r8, r7
	ldr	r2, [sp, #12]
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r1, r8
	str	r3, [sp]
	mov	r3, r10
	bl	flash_read_page_en
	ldr	r3, [r4]
	mov	fp, r0
	ldr	r0, .L3262+44
	ldr	r2, [r3, #48]
	adds	r2, r2, #1
	str	r2, [r3, #48]
	mov	r2, r8
	ldrh	r3, [r3, #694]
	ldr	r1, [r10]
	bl	printf
	cmp	fp, #-1
	beq	.L3246
	cmp	fp, #512
	beq	.L3246
	ldr	r2, [r4]
	ldr	r3, [r10]
	ldrh	r1, [r2, #698]
	cmp	r3, r1
	itt	cc
	addcc	r3, r3, #176
	strcc	r8, [r2, r3, lsl #2]
.L3246:
	adds	r7, r7, #1
	sxth	r7, r7
	b	.L3245
.L3263:
	.align	2
.L3262:
	.word	.LANCHOR146
	.word	.LANCHOR134
	.word	.LANCHOR132
	.word	.LANCHOR192
	.word	.LANCHOR191
	.word	.LANCHOR125
	.word	.LANCHOR104
	.word	.LC196
	.word	.LANCHOR185
	.word	.LANCHOR208
	.word	.LANCHOR105
	.word	.LC197
	.size	pm_init, .-pm_init
	.section	.text.pm_log2phys,"ax",%progbits
	.align	1
	.global	pm_log2phys
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	pm_log2phys, %function
pm_log2phys:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L3279
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	fp, r0
	str	r2, [sp, #4]
	mov	r6, r1
	ldr	r2, [r3]
	cmp	r0, r2
	bcc	.L3265
	mov	r1, r0
	ldr	r0, .L3279+4
	bl	printf
	ldr	r3, [sp, #4]
	mov	r0, #-1
	cbnz	r3, .L3264
	str	r0, [r6]
.L3264:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3265:
	ldr	r3, .L3279+8
	ldrb	r5, [r3]	@ zero_extendqisi2
	lsls	r1, r5, #7
	bl	__aeabi_uidiv
	ldr	r1, .L3279+12
	uxth	r7, r0
	mov	r10, r0
	movs	r2, #0
	mov	r8, r1
.L3271:
	add	r0, r1, r2, lsl #3
	uxth	r4, r2
	ldr	r0, [r0, #4]
	cmp	r0, #0
	beq	.L3267
	ldrh	r0, [r1, r2, lsl #3]
	cmp	r0, r7
	bne	.L3267
.L3268:
	lsls	r5, r5, #7
	ldr	r3, [sp, #4]
	lsls	r4, r4, #3
	smulbb	r5, r5, r7
	sub	r5, fp, r5
	uxth	r5, r5
	cbnz	r3, .L3269
	add	r2, r8, r4
	ldr	r1, .L3279+16
	ldr	r2, [r2, #4]
	ldr	r2, [r2, r5, lsl #2]
	str	r2, [r6]
	ldrb	r0, [r1]	@ zero_extendqisi2
	rsb	r1, r0, #24
	lsrs	r2, r2, r1
	movs	r1, #1
	lsls	r1, r1, r0
	subs	r1, r1, #1
	ands	r2, r2, r1
	ldr	r1, .L3279+20
	ldrb	r1, [r1]	@ zero_extendqisi2
	cmp	r2, r1
	bcc	.L3270
	mov	r2, #-1
	str	r2, [r6]
.L3270:
	add	r4, r4, r8
	movw	r2, #32767
	ldrh	r3, [r4, #2]
	ubfx	r1, r3, #0, #15
	cmp	r1, r2
	beq	.L3274
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
.L3274:
	movs	r0, #0
	b	.L3264
.L3269:
	add	r1, r8, r4
	ldr	r0, [r6]
	ldr	r2, [r1, #4]
	str	r0, [r2, r5, lsl #2]
	ldrh	r2, [r1, #2]
	mvn	r2, r2, lsl #17
	mvn	r2, r2, lsr #17
	strh	r2, [r1, #2]	@ movhi
	ldr	r2, .L3279+24
	strb	r10, [r2]
	b	.L3270
.L3267:
	adds	r2, r2, #1
	cmp	r2, #32
	bne	.L3271
	bl	pm_select_ram_region
	ldrh	r1, [r8, r0, lsl #3]
	movw	r2, #65535
	mov	r4, r0
	cmp	r1, r2
	beq	.L3272
	add	r2, r8, r0, lsl #3
	ldrsh	r2, [r2, #2]
	cmp	r2, #0
	bge	.L3272
	bl	pm_flush_id
.L3272:
	ldr	r2, .L3279+28
	mov	r1, r4
	mov	r0, r7
	strb	r4, [r2]
	bl	load_l2p_region
	b	.L3268
.L3280:
	.align	2
.L3279:
	.word	.LANCHOR122
	.word	.LC198
	.word	.LANCHOR125
	.word	.LANCHOR134
	.word	.LANCHOR31
	.word	.LANCHOR106
	.word	.LANCHOR135
	.word	.LANCHOR210
	.size	pm_log2phys, .-pm_log2phys
	.section	.text.gc_recovery,"ax",%progbits
	.align	1
	.global	gc_recovery
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	gc_recovery, %function
gc_recovery:
	@ args = 0, pretend = 0, frame = 32
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r2, .L3368
	ldr	r3, .L3368+4
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r4, #0
	ldr	r5, [r2]
	sub	sp, sp, #64
	mov	r8, r2
	strb	r4, [r3]
	ldr	r3, .L3368+8
	ldrh	r6, [r5, #80]
	strb	r4, [r3]
	movw	r3, #65535
	cmp	r6, r3
	beq	.L3282
	strh	r3, [r5, #130]	@ movhi
	movs	r0, #1
	bl	buf_alloc
	ldrb	r3, [r5, #89]	@ zero_extendqisi2
	mov	r6, r0
	ldr	r2, .L3368+12
	ldr	r7, .L3368+16
	add	r3, r5, r3, lsl #1
	ldrh	r2, [r2]
	ldrb	r1, [r7]	@ zero_extendqisi2
	ldrh	r3, [r3, #94]
	cmp	r1, #2
	mul	r2, r2, r3
	str	r2, [sp, #56]
	beq	.L3283
	ldr	r3, .L3368+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L3284
.L3283:
	ldr	r3, .L3368+24
	ldrh	r3, [r3]
	subs	r3, r3, #1
	add	r3, r3, r2
	orr	r3, r3, r1, lsl #24
.L3366:
	str	r3, [r6, #24]
.L3285:
	movs	r1, #1
	mov	r0, r6
	bl	sblk_read_page
	ldr	r3, [r6, #36]
	adds	r2, r3, #1
	beq	.L3286
	cmp	r3, #512
	beq	.L3286
	ldr	r3, [r6, #12]
	ldr	r2, [r3]
	ldr	r3, .L3368+28
	cmp	r2, r3
	beq	.L3287
.L3286:
	mov	r0, r6
	movs	r4, #0
	bl	zbuf_free
	ldr	r2, [r6, #12]
	ldr	r3, [r6, #4]
	ldr	r0, .L3368+32
	ldr	r1, [r2, #12]
	str	r1, [sp, #24]
	ldr	r1, [r2, #8]
	str	r1, [sp, #20]
	ldr	r1, [r2, #4]
	str	r1, [sp, #16]
	ldr	r2, [r2]
	str	r2, [sp, #12]
	ldr	r2, [r3, #12]
	str	r2, [sp, #8]
	ldr	r2, [r3, #8]
	str	r2, [sp, #4]
	ldr	r2, [r3, #4]
	str	r2, [sp]
	ldr	r3, [r3]
	ldr	r2, [r6, #36]
	ldr	r1, [r6, #24]
	bl	printf
	ldr	r3, .L3368+36
	ldrh	r2, [r5, #80]
	ldr	r3, [r3]
	strh	r4, [r3, r2, lsl #1]	@ movhi
	ldr	r3, [r8]
.L3367:
	ldrh	r2, [r5, #80]
	strh	r2, [r3, #130]	@ movhi
.L3288:
	ldr	r3, .L3368+36
	ldrh	r0, [r5, #80]
	ldr	r3, [r3]
	ldrh	r3, [r3, r0, lsl #1]
	cbnz	r3, .L3323
	bl	ftl_dump_write_open_sblk
.L3323:
	mov	r2, r4
	ldrh	r1, [r5, #80]
	movw	r4, #65535
	ldr	r0, .L3368+40
	bl	printf
	strh	r4, [r5, #80]	@ movhi
	bl	pm_flush
	bl	ftl_ext_info_flush
	ldr	r3, .L3368
	ldr	r2, [r3]
	ldrh	r0, [r2, #130]
	cmp	r0, r4
	mov	r4, r3
	beq	.L3324
	bl	ftl_free_sblk
.L3324:
	ldr	r3, .L3368+44
	movs	r0, #0
	ldr	r2, [r3]
	movw	r3, #65535
	strh	r3, [r2, #126]	@ movhi
	ldr	r2, [r4]
	strh	r3, [r2, #130]	@ movhi
	bl	ftl_info_flush
.L3281:
	add	sp, sp, #64
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3284:
	cmp	r1, #3
	bne	.L3285
	ldr	r3, .L3368+48
	ldrh	r3, [r3]
	subs	r3, r3, #1
	add	r3, r3, r2
	orr	r3, r3, #50331648
	b	.L3366
.L3287:
	ldr	fp, .L3368+24
	ldr	r10, .L3368+72
	ldr	r1, [r6, #4]
	ldrh	r3, [fp]
	ldrb	r2, [r10]	@ zero_extendqisi2
	ldr	r8, .L3368+64
	muls	r2, r3, r2
	ldr	r3, .L3368+52
	ldr	r0, [r3]
	lsls	r2, r2, #2
	bl	ftl_memcpy
	ldrh	r3, [fp]
	ldrb	r4, [r10]	@ zero_extendqisi2
	muls	r4, r3, r4
	ldr	r3, .L3368+56
	ldrb	r3, [r3]	@ zero_extendqisi2
	lsls	r2, r4, #2
	cmp	r3, r4, asr #6
	bge	.L3289
	movs	r1, #0
	ldr	r0, [r8]
	rsb	r4, r4, r3, lsl #7
	bl	ftl_memset
	ldrh	r1, [fp]
	lsls	r4, r4, #2
	ldrb	r3, [r10]	@ zero_extendqisi2
	mov	r2, r4
	ldr	r0, [r8]
	muls	r3, r1, r3
	ldr	r1, [r6, #4]
	add	r1, r1, r3, lsl #2
	bl	ftl_memcpy
	movs	r3, #1
	str	r3, [sp, #44]
.L3290:
	ldr	r3, .L3368+48
	ldrh	r3, [r3]
	str	r3, [sp, #36]
	ldrb	r3, [r7]	@ zero_extendqisi2
	cmp	r3, #2
	str	r3, [sp, #32]
	bne	.L3291
	ldr	r3, .L3368+60
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L3292
.L3291:
	ldr	r3, .L3368+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L3293
.L3292:
	ldr	r3, [sp, #32]
	ldr	r2, [sp, #36]
	muls	r3, r2, r3
	str	r3, [sp, #36]
	movs	r3, #1
	str	r3, [sp, #32]
.L3293:
	movs	r7, #0
	str	r7, [sp, #40]
.L3294:
	ldr	r3, [sp, #36]
	cmp	r3, r7
	bls	.L3306
	mov	fp, #0
	b	.L3307
.L3289:
	ldr	r1, [r6, #4]
	ldr	r0, [r8]
	add	r1, r1, r2
	bl	ftl_memcpy
	movs	r3, #0
	str	r3, [sp, #44]
	mov	r4, r3
	b	.L3290
.L3302:
	ldr	r3, [sp, #48]
	ldrh	r2, [r3, #96]
	ldr	r3, .L3368+12
	ldrh	r3, [r3]
	muls	r3, r2, r3
	ldr	r2, .L3368+16
	ldrb	r1, [r2]	@ zero_extendqisi2
	str	r3, [sp, #56]
	cmp	r1, #2
	beq	.L3295
	ldr	r2, .L3368+20
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, #0
	beq	.L3296
.L3295:
	subs	r2, r7, #1
	add	r3, r3, r2
	add	r3, r3, r10
	orr	r3, r3, r1, lsl #24
.L3298:
	str	r3, [r6, #24]
	movs	r1, #1
	mov	r0, r6
	bl	sblk_read_page
	ldr	r3, [sp, #44]
	cbz	r3, .L3299
	ldr	r3, .L3368+64
	ldr	r3, [r3]
	ldr	r2, [r3, r8]
	cbnz	r2, .L3299
	ldr	r2, [r6, #12]
	ldr	r2, [r2, #8]
	str	r2, [r3, r8]
.L3299:
	ldr	r3, .L3368+52
	ldr	r2, [r6, #12]
	ldr	r3, [r3]
	ldr	r1, [r2, #4]
	ldr	r3, [r3, r8]
	cmp	r3, r1
	bne	.L3300
	ldr	r0, .L3368+64
	ldr	r0, [r0]
	ldr	ip, [r0, r8]
	ldr	r0, [r2, #8]
	cmp	ip, r0
	beq	.L3301
.L3300:
	ldr	r0, [r2, #12]
	str	r0, [sp, #16]
	ldr	r0, [r2, #8]
	str	r1, [sp, #8]
	str	r0, [sp, #12]
	ldr	r2, [r2]
	ldr	r0, .L3368+68
	str	r2, [sp, #4]
	ldr	r2, .L3368+64
	ldr	r2, [r2]
	ldr	r2, [r2, r8]
	str	r2, [sp]
	ldr	r2, [r6, #36]
	ldr	r1, [r6, #24]
	bl	printf
	ldr	r3, .L3368+52
	ldr	r3, [r3]
	ldr	r3, [r3, r8]
	adds	r3, r3, #1
	beq	.L3301
	mov	r0, r6
	bl	zbuf_free
	ldr	r3, .L3368+36
	movs	r1, #0
	ldrh	r2, [r5, #80]
	ldr	r3, [r3]
	strh	r1, [r3, r2, lsl #1]	@ movhi
	ldr	r3, .L3368
	ldr	r3, [r3]
	b	.L3367
.L3296:
	cmp	r1, #3
	add	r3, r3, r7
	it	eq
	orreq	r3, r3, r10, lsl #24
	b	.L3298
.L3369:
	.align	2
.L3368:
	.word	.LANCHOR10
	.word	.LANCHOR78
	.word	.LANCHOR153
	.word	.LANCHOR105
	.word	.LANCHOR73
	.word	.LANCHOR35
	.word	.LANCHOR79
	.word	-178307901
	.word	.LC199
	.word	.LANCHOR9
	.word	.LC201
	.word	.LANCHOR104
	.word	.LANCHOR87
	.word	.LANCHOR155
	.word	.LANCHOR125
	.word	.LANCHOR74
	.word	.LANCHOR156
	.word	.LC200
	.word	.LANCHOR80
.L3301:
	ldr	r3, [sp, #40]
	add	r10, r10, #1
	add	r8, r8, #4
	adds	r3, r3, #1
	str	r3, [sp, #40]
.L3304:
	ldr	r3, [sp, #32]
	cmp	r3, r10
	bcs	.L3302
	add	fp, fp, #1
.L3307:
	ldrb	r3, [r5, #89]	@ zero_extendqisi2
	cmp	fp, r3
	bge	.L3303
	ldr	r3, [sp, #40]
	mov	r10, #1
	lsl	r8, r3, #2
	add	r3, r5, fp, lsl #1
	str	r3, [sp, #48]
	b	.L3304
.L3303:
	ldr	r3, .L3370
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L3305
	adds	r7, r7, #1
.L3305:
	adds	r7, r7, #1
	b	.L3294
.L3306:
	mov	r0, r6
	movs	r4, #0
	bl	zbuf_free
	ldr	r3, .L3370+4
	mov	fp, r4
	ldr	r0, .L3370+8
	mov	r10, r4
	ldrh	r1, [r5, #80]
	ldr	r2, [r3]
	ldrh	r0, [r0]
	ldrb	r3, [r5, #89]	@ zero_extendqisi2
	smulbb	r3, r3, r0
	strh	r3, [r2, r1, lsl #1]	@ movhi
.L3308:
	ldr	r3, [sp, #36]
	cmp	r3, fp
	bls	.L3321
	mov	r8, #0
	b	.L3322
.L3317:
	ldr	r3, .L3370+12
	ldr	r2, [r3]
	ldr	r3, [r2, r10, lsl #2]
	str	r3, [sp, #40]
	adds	r3, r3, #1
	beq	.L3309
	ldr	r3, .L3370+16
	ldr	r0, [sp, #40]
	ldr	r2, [r3]
	ldr	r3, [r2, r10, lsl #2]
	str	r3, [sp, #44]
	bl	lpa_hash_get_ppa
	str	r0, [sp, #60]
	adds	r0, r0, #1
	bne	.L3310
	movs	r2, #0
	add	r1, sp, #60
	ldr	r0, [sp, #40]
	bl	pm_log2phys
.L3310:
	ldr	r3, [sp, #48]
	ldr	r1, .L3370+20
	ldrh	r2, [r3, #96]
	ldrh	r1, [r1]
	muls	r2, r1, r2
	ldr	r1, .L3370+24
	ldrb	r0, [r1]	@ zero_extendqisi2
	cmp	r0, #2
	beq	.L3311
	ldr	r1, .L3370+28
	ldrb	r1, [r1]	@ zero_extendqisi2
	cmp	r1, #0
	beq	.L3312
.L3311:
	add	r1, fp, #-1
	add	r2, r2, r1
	add	r2, r2, r7
	orr	r2, r2, r0, lsl #24
.L3314:
	str	r2, [sp, #56]
	ldr	r2, .L3370+32
	ldr	r3, [sp, #44]
	ldr	r1, .L3370+36
	ldrh	r0, [r2]
	ldr	r2, .L3370+40
	ldrb	r1, [r1]	@ zero_extendqisi2
	ldrb	r6, [r2]	@ zero_extendqisi2
	movs	r2, #1
	str	r2, [sp, #52]
	rsb	r6, r6, #24
	subs	r6, r6, r0
	lsr	r0, r3, r0
	lsl	r6, r2, r6
	subs	r6, r6, #1
	ands	r0, r0, r6
	bl	__aeabi_uidiv
	ldr	r1, [sp, #60]
	mov	r6, r0
	ldr	r3, [sp, #44]
	ldr	r2, [sp, #52]
	cmp	r3, r1
	bne	.L3315
	add	r1, sp, #56
	ldr	r0, [sp, #40]
	bl	pm_log2phys
	uxth	r0, r6
	adds	r4, r4, #1
	bl	ftl_vpn_decrement
.L3316:
	ldr	r2, .L3370+44
	uxth	r6, r6
	add	r10, r10, #1
	ldr	r2, [r2]
	add	r2, r2, r6, lsl #2
	ldrb	r2, [r2, #2]	@ zero_extendqisi2
	ands	r2, r2, #224
	bne	.L3309
	ldr	r1, .L3370+4
	ldr	r1, [r1]
	ldrh	r0, [r1, r6, lsl #1]
	cbz	r0, .L3309
	strh	r2, [r1, r6, lsl #1]	@ movhi
.L3309:
	adds	r7, r7, #1
.L3319:
	ldr	r3, [sp, #32]
	cmp	r3, r7
	bcs	.L3317
	add	r8, r8, #1
.L3322:
	ldrb	r2, [r5, #89]	@ zero_extendqisi2
	cmp	r8, r2
	bge	.L3318
	add	r3, r5, r8, lsl #1
	movs	r7, #1
	str	r3, [sp, #48]
	b	.L3319
.L3312:
	cmp	r0, #3
	add	r2, r2, fp
	it	eq
	orreq	r2, r2, r7, lsl #24
	b	.L3314
.L3315:
	ldr	r2, [sp, #56]
	cmp	r1, r2
	it	eq
	addeq	r4, r4, #1
	b	.L3316
.L3318:
	ldr	r2, .L3370
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbz	r2, .L3320
	add	fp, fp, #1
.L3320:
	add	fp, fp, #1
	b	.L3308
.L3321:
	ldr	r3, .L3370+4
	ldrh	r2, [r5, #80]
	ldr	r3, [r3]
	strh	r4, [r3, r2, lsl #1]	@ movhi
	ldrh	r0, [r5, #80]
	bl	zftl_insert_data_list
	b	.L3288
.L3282:
	ldrh	r3, [r5, #130]
	cmp	r3, r6
	beq	.L3281
	ldr	r5, .L3370+48
	ldr	r2, [r5]
	ldrh	r2, [r2, #126]
	cmp	r2, r3
	bne	.L3326
	bl	pm_flush
	ldr	r3, [r8]
	ldrh	r0, [r3, #130]
	bl	ftl_free_sblk
	ldr	r3, [r5]
	mov	r0, r4
	strh	r6, [r3, #126]	@ movhi
	bl	ftl_info_flush
.L3326:
	ldr	r3, [r8]
	movw	r2, #65535
	strh	r2, [r3, #130]	@ movhi
	b	.L3281
.L3371:
	.align	2
.L3370:
	.word	.LANCHOR74
	.word	.LANCHOR9
	.word	.LANCHOR79
	.word	.LANCHOR155
	.word	.LANCHOR156
	.word	.LANCHOR105
	.word	.LANCHOR73
	.word	.LANCHOR35
	.word	.LANCHOR68
	.word	.LANCHOR69
	.word	.LANCHOR31
	.word	.LANCHOR7
	.word	.LANCHOR104
	.size	gc_recovery, .-gc_recovery
	.section	.text.zftl_init,"ax",%progbits
	.align	1
	.global	zftl_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	zftl_init, %function
zftl_init:
	@ args = 0, pretend = 0, frame = 32
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r2, .L3442
	movs	r3, #255
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r4, #0
	ldr	r10, .L3442+204
	sub	sp, sp, #32
	strb	r3, [r2]
	ldr	r2, .L3442+4
	ldr	r1, .L3442+8
	ldr	r0, .L3442+12
	strb	r4, [r2]
	ldr	r2, .L3442+16
	ldr	r7, .L3442+20
	strb	r3, [r2]
	ldr	r2, .L3442+24
	strb	r4, [r2]
	ldr	r2, .L3442+28
	strb	r3, [r2]
	mov	r2, #-1
	ldr	r3, .L3442+32
	strb	r4, [r3]
	ldr	r3, .L3442+36
	str	r2, [r3]
	bl	printf
	ldrb	r3, [r10, #12]	@ zero_extendqisi2
	ldrb	r6, [r10, #9]	@ zero_extendqisi2
	ldrh	r5, [r10, #10]
	str	r3, [sp, #4]
	ldr	r3, .L3442+40
	ldrb	r2, [sp, #4]	@ zero_extendqisi2
	mov	r0, r5
	ldr	r1, [sp, #4]
	lsl	fp, r6, #9
	strb	r2, [r3]
	uxth	fp, fp
	ldr	r3, .L3442+44
	strb	r6, [r3]
	ldr	r3, .L3442+48
	strh	r5, [r3]	@ movhi
	bl	__aeabi_idiv
	ldr	r2, .L3442+52
	mov	r3, r0
	ldrb	r1, [r10, #13]	@ zero_extendqisi2
	ldr	ip, .L3442+208
	ldrb	r8, [r2]	@ zero_extendqisi2
	ldr	r2, .L3442+56
	strh	r0, [r7]	@ movhi
	ldrh	r10, [r10, #14]
	strb	r8, [r2]
	smulbb	r8, r8, r1
	ldr	r2, .L3442+60
	ldr	r0, .L3442+64
	uxtb	r8, r8
	str	r7, [sp, #12]
	strb	r1, [r2]
	ldr	r2, .L3442+68
	ldr	r1, .L3442+72
	strb	r8, [r0]
	strh	fp, [r2]	@ movhi
	ldr	r2, .L3442+76
	strh	r10, [r1]	@ movhi
	str	r0, [sp, #16]
	ldrh	r2, [r2]
	str	r1, [sp, #20]
	strh	r2, [ip]	@ movhi
	mov	ip, #1
.L3373:
	cmp	r2, ip
	uxth	r1, r4
	add	r4, r4, #1
	bcs	.L3374
	subs	r2, r1, #1
	ldr	r1, .L3442+80
	movs	r4, #1
	strh	r2, [r1]	@ movhi
	mul	r2, r5, r6
	movs	r5, #0
	mul	r0, r10, r2
	lsrs	r7, r0, #21
.L3375:
	cmp	r7, r4
	uxth	r1, r5
	add	r5, r5, #1
	bcs	.L3376
	mov	r4, #1892352
	subs	r1, r1, #1
	mul	r4, r4, r8
	uxth	r1, r1
	str	r3, [sp, #24]
	mul	r0, r8, r0
	ldr	r7, .L3442+84
	ldr	r5, .L3442+88
	lsl	r3, r4, r1
	ldr	r1, .L3442+92
	str	r2, [sp, #28]
	add	r4, r3, #24576
	str	r0, [r7]
	str	r3, [r1]
	mov	r1, r6
	ldr	r6, .L3442+96
	mov	r0, r4
	str	r4, [r5]
	str	r3, [sp, #8]
	bl	__aeabi_uidiv
	add	ip, fp, #-1
	mov	r1, fp
	str	r0, [r6]
	add	r0, ip, r0, lsl #2
	ldr	fp, .L3442+156
	bl	__aeabi_uidiv
	ldr	r3, [sp, #24]
	strh	r0, [fp]	@ movhi
	uxth	r0, r0
	lsls	r0, r0, #4
	mul	r1, r8, r3
	bl	__aeabi_idiv
	ldr	r2, [sp, #28]
	ldr	r3, .L3442+100
	mul	r1, r8, r2
	strh	r0, [r3]	@ movhi
	mov	r0, r4
	subs	r1, r1, #1
	bl	__aeabi_uidiv
	ldr	r3, .L3442+104
	adds	r0, r0, #8
	ldr	r2, .L3442+108
	movs	r1, #48
	ldr	ip, .L3442+212
	strh	r0, [r3]	@ movhi
	add	r3, r10, r10, lsl #1
	lsr	r10, r10, #4
	ldr	r0, .L3442+112
	asrs	r3, r3, #2
	ldr	r4, [sp, #4]
	cmp	r10, #79
	ldr	lr, .L3442+128
	strh	r3, [r2]	@ movhi
	it	ls
	movls	r2, #80
	ldr	r3, .L3442+116
	str	fp, [sp, #24]
	strh	r10, [r3]	@ movhi
	mov	r10, r0
	it	ls
	strhls	r2, [r3]	@ movhi
	mov	r3, #2000
	strh	r3, [ip]	@ movhi
	movs	r3, #50
	strh	r3, [r0]	@ movhi
	mov	r2, #256
	ldr	r3, .L3442+120
	cmp	r4, #2
	strh	r2, [r3]	@ movhi
	ldr	r2, .L3442+124
	strh	r1, [r2]	@ movhi
	mov	r1, #32
	strh	r1, [lr]	@ movhi
	mov	r8, r2
	mov	lr, ip
	beq	.L3378
	ldr	fp, .L3442+216
	ldrb	fp, [fp]	@ zero_extendqisi2
	cmp	fp, #0
	beq	.L3379
.L3378:
	movs	r2, #150
	movs	r1, #12
	strh	r2, [r10]	@ movhi
	movs	r2, #64
	strh	r2, [r8]	@ movhi
	ldr	r2, .L3442+128
	strh	r1, [r2]	@ movhi
	ldr	r1, .L3442+132
	ldrb	r1, [r1]	@ zero_extendqisi2
	cbnz	r1, .L3381
	movs	r1, #4
	strh	r1, [r2]	@ movhi
	mov	r2, #600
	strh	r2, [lr]	@ movhi
	movs	r2, #128
	strh	r2, [r3]	@ movhi
.L3381:
	ldr	r3, .L3442+136
	ldr	r2, [r3]
	mov	r8, r3
	tst	r2, #4096
	beq	.L3383
	ldr	r1, [sp, #8]
	ldr	r0, .L3442+140
	bl	printf
.L3383:
	ldr	r3, [r8]
	lsls	r0, r3, #19
	bpl	.L3384
	ldr	r1, [r7]
	ldr	r0, .L3442+144
	bl	printf
.L3384:
	ldr	r3, [r8]
	lsls	r1, r3, #19
	bpl	.L3385
	ldr	r1, [r6]
	ldr	r0, .L3442+148
	bl	printf
.L3385:
	ldr	r3, [r8]
	lsls	r2, r3, #19
	bpl	.L3386
	ldr	r1, [r5]
	ldr	r0, .L3442+152
	bl	printf
.L3386:
	ldr	r3, [r8]
	lsls	r3, r3, #19
	bpl	.L3387
	ldr	r3, .L3442+156
	ldr	r0, .L3442+160
	ldrh	r1, [r3]
	bl	printf
.L3387:
	ldr	r3, [r8]
	ldr	r6, .L3442+68
	tst	r3, #4096
	beq	.L3388
	ldrh	r1, [r6]
	ldr	r0, .L3442+164
	bl	printf
.L3388:
	ldr	r3, [r8]
	lsls	r7, r3, #19
	bpl	.L3389
	ldr	r3, .L3442+100
	ldr	r0, .L3442+168
	ldrh	r1, [r3]
	bl	printf
.L3389:
	ldr	r3, [r8]
	lsls	r5, r3, #19
	bpl	.L3390
	ldr	r3, .L3442+116
	ldr	r0, .L3442+172
	ldrh	r1, [r3]
	bl	printf
.L3390:
	ldr	r3, [r8]
	lsls	r4, r3, #19
	bpl	.L3391
	ldr	r3, .L3442+104
	ldr	r0, .L3442+176
	ldrh	r1, [r3]
	bl	printf
.L3391:
	bl	zbuf_init
	ldr	r3, [sp, #20]
	movs	r0, #6
	ldr	r5, .L3442+180
	ldrh	r3, [r3]
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L3442+184
	ldr	r2, [sp, #16]
	str	r0, [r3]
	ldr	r3, [sp, #12]
	ldrb	r0, [r2]	@ zero_extendqisi2
	ldrh	r3, [r3]
	muls	r0, r3, r0
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L3442+188
	ldr	r2, .L3442+192
	str	r0, [r3]
	ldr	r3, .L3442+196
	str	r2, [r3]
	ldr	r3, [sp, #12]
	ldrh	r0, [r3]
	ldr	r3, [sp, #16]
	ldrb	r1, [r3]	@ zero_extendqisi2
	muls	r0, r1, r0
	ldr	r1, .L3442+200
	add	r3, r2, r0, lsl #3
	str	r3, [r1]
	ldr	r1, [sp, #20]
	ldrh	r1, [r1]
	lsrs	r1, r1, #1
	add	r1, r1, r0, lsl #1
	ldr	r0, [r8]
	add	r1, r2, r1, lsl #2
	lsls	r0, r0, #19
	str	r1, [r5]
	bpl	.L3392
	b	.L3443
.L3444:
	.align	2
.L3442:
	.word	.LANCHOR59
	.word	.LANCHOR60
	.word	.LC202
	.word	.LC99
	.word	.LANCHOR128
	.word	.LANCHOR87
	.word	.LANCHOR129
	.word	.LANCHOR177
	.word	.LANCHOR123
	.word	.LANCHOR211
	.word	.LANCHOR73
	.word	.LANCHOR125
	.word	.LANCHOR79
	.word	.LANCHOR18
	.word	.LANCHOR106
	.word	.LANCHOR69
	.word	.LANCHOR80
	.word	.LANCHOR208
	.word	.LANCHOR6
	.word	.LANCHOR2
	.word	.LANCHOR68
	.word	.LANCHOR212
	.word	.LANCHOR213
	.word	.LANCHOR61
	.word	.LANCHOR122
	.word	.LANCHOR149
	.word	.LANCHOR95
	.word	.LANCHOR119
	.word	.LANCHOR118
	.word	.LANCHOR91
	.word	.LANCHOR148
	.word	.LANCHOR147
	.word	.LANCHOR8
	.word	.LANCHOR0
	.word	.LANCHOR14
	.word	.LC203
	.word	.LC204
	.word	.LC205
	.word	.LC206
	.word	.LANCHOR194
	.word	.LC207
	.word	.LC208
	.word	.LC209
	.word	.LC210
	.word	.LC211
	.word	.LANCHOR10
	.word	.LANCHOR4
	.word	.LANCHOR112
	.word	ftl_ext_info_data_buffer
	.word	.LANCHOR111
	.word	.LANCHOR9
	.word	.LANCHOR32
	.word	.LANCHOR105
	.word	.LANCHOR120
	.word	.LANCHOR77
.L3443:
	ldr	r0, .L3445
	bl	printf
.L3392:
	ldr	r2, [sp, #12]
	ldr	r1, [sp, #16]
	ldr	r3, [sp, #20]
	ldrh	r2, [r2]
	ldrb	r7, [r1]	@ zero_extendqisi2
	ldrh	r3, [r3]
	muls	r7, r2, r7
	ldr	r2, [sp, #24]
	lsls	r4, r3, #2
	ldrh	r2, [r2]
	add	r7, r3, r7, lsl #2
	ldr	r3, [r8]
	lsls	r7, r7, #1
	add	r4, r4, r2, lsl #2
	lsls	r2, r3, #19
	add	r7, r7, #632
	add	r4, r4, #704
	bpl	.L3393
	ldrh	r3, [r6]
	mov	r2, r4
	mov	r1, r7
	ldr	r0, .L3445+4
	bl	printf
.L3393:
	ldrh	r3, [r6]
	cmp	r7, r3
	bhi	.L3394
	cmp	r4, r3
	bls	.L3395
.L3394:
.L3441:
	b	.L3441
.L3374:
	lsl	ip, ip, #1
	b	.L3373
.L3376:
	lsls	r4, r4, #1
	b	.L3375
.L3379:
	ldr	r3, .L3445+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L3381
	mov	r3, #1200
	strh	r1, [r0]	@ movhi
	strh	r3, [ip]	@ movhi
	strh	r1, [r2]	@ movhi
	b	.L3381
.L3395:
	bl	sblk_init
	bl	ftl_info_blk_init
	adds	r3, r0, #1
	beq	.L3372
	bl	ftl_ext_info_init
	bl	gc_init
	movs	r0, #1
	ldr	r4, .L3445+12
	bl	pm_init
	bl	lpa_rebuild_hash
	ldr	r0, [r5]
	movs	r1, #0
	adds	r0, r0, #16
	bl	ftl_open_sblk_recovery
	ldr	r0, [r5]
	add	r1, r0, #16
	adds	r0, r0, #48
	bl	ftl_open_sblk_recovery
	ldr	r2, [r4]
	ldr	r0, [r5]
	ldr	r3, [r2, #8]
	adds	r0, r0, #16
	adds	r3, r3, #16
	str	r3, [r2, #8]
	bl	ftl_info_data_recovery
	ldr	r0, [r5]
	adds	r0, r0, #48
	bl	ftl_info_data_recovery
	ldr	r0, [r5]
	adds	r0, r0, #80
	bl	ftl_info_data_recovery
	bl	gc_recovery
	bl	pm_flush
	movs	r0, #1
	bl	ftl_total_vpn_update
	ldr	r3, .L3445+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L3397
	ldr	r2, [r4]
	ldr	r3, [r2, #68]
	adds	r3, r3, #1
	str	r3, [r2, #68]
.L3397:
	bl	ftl_ext_info_flush
	movs	r0, #0
	bl	ftl_info_flush
	bl	print_ftl_debug_info
	movs	r0, #0
.L3372:
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3446:
	.align	2
.L3445:
	.word	.LC212
	.word	.LC213
	.word	.LANCHOR35
	.word	.LANCHOR104
	.word	.LANCHOR185
	.size	zftl_init, .-zftl_init
	.section	.text.rk_ftl_init,"ax",%progbits
	.align	1
	.global	rk_ftl_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	rk_ftl_init, %function
rk_ftl_init:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	bl	nand_flash_init
	mov	r4, r0
	cbnz	r0, .L3448
	bl	zftl_init
	mov	r4, r0
.L3448:
	bl	idb_init
	mov	r1, r4
	ldr	r0, .L3449
	bl	printf
	mov	r0, r4
	pop	{r4, pc}
.L3450:
	.align	2
.L3449:
	.word	.LC214
	.size	rk_ftl_init, .-rk_ftl_init
	.section	.text.gc_update_l2p_map_new,"ax",%progbits
	.align	1
	.global	gc_update_l2p_map_new
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	gc_update_l2p_map_new, %function
gc_update_l2p_map_new:
	@ args = 0, pretend = 0, frame = 32
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L3485
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #32
	ldr	r2, .L3485+4
	ldr	r4, [r3]
	ldrh	r2, [r2]
	ldr	r7, .L3485+8
	ldrb	r1, [r4, #89]	@ zero_extendqisi2
	str	r3, [sp, #20]
	muls	r2, r1, r2
	str	r2, [sp, #4]
	ldr	r2, [r7]
	tst	r2, #256
	beq	.L3452
	ldrh	r1, [r4, #80]
	ldr	r0, .L3485+12
	bl	printf
.L3452:
	ldr	r3, .L3485+16
	movs	r6, #0
	ldr	r1, [sp, #4]
	mov	r5, r6
	ldrh	r2, [r4, #80]
	ldr	r3, [r3]
	subs	r1, r1, #1
	strh	r1, [r3, r2, lsl #1]	@ movhi
.L3453:
	ldr	r3, [sp, #4]
	cmp	r5, r3
	bne	.L3462
	ldr	r3, [r7]
	ldr	r5, .L3485+16
	tst	r3, #256
	beq	.L3463
	ldr	r3, [sp, #20]
	ldrh	r0, [r4, #80]
	ldr	r2, [r5]
	ldr	r1, [r3]
	mov	r3, r6
	ldrh	r2, [r2, r0, lsl #1]
	ldrh	r1, [r1, #80]
	ldr	r0, .L3485+20
	bl	printf
.L3463:
	ldrh	r2, [r4, #80]
	ldr	r3, [r5]
	ldrh	r3, [r3, r2, lsl #1]
	cmp	r6, r3
	beq	.L3464
	mov	r2, #748
	ldr	r1, .L3485+24
	ldr	r0, .L3485+28
	bl	printf
.L3464:
	ldrh	r2, [r4, #80]
	ldr	r3, [r5]
	strh	r6, [r3, r2, lsl #1]	@ movhi
	ldrh	r0, [r4, #80]
	bl	zftl_insert_data_list
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3462:
	ldr	r3, .L3485+32
	lsl	r8, r5, #2
	ldr	r3, [r3]
	ldr	r10, [r3, r5, lsl #2]
	cmp	r10, #-1
	beq	.L3454
	ldr	r3, .L3485+36
	mov	r0, r10
	ldrb	r1, [r3]	@ zero_extendqisi2
	lsls	r1, r1, #7
	bl	__aeabi_uidiv
	uxth	r3, r0
	str	r3, [sp, #16]
	ldr	r3, [r7]
	lsls	r1, r3, #23
	bpl	.L3455
	mov	r3, r5
	mov	r2, r10
	ldr	r1, [sp, #16]
	ldr	r0, .L3485+40
	bl	printf
.L3455:
	ldr	fp, .L3485+32
	str	r5, [sp, #12]
.L3461:
	ldr	r3, [fp]
	ldr	r10, [r3, r8]
	cmp	r10, #-1
	beq	.L3456
	ldr	r3, .L3485+36
	mov	r0, r10
	ldrb	r1, [r3]	@ zero_extendqisi2
	lsls	r1, r1, #7
	bl	__aeabi_uidiv
	ldr	r3, [sp, #16]
	uxth	r0, r0
	cmp	r3, r0
	bne	.L3456
	ldr	r3, .L3485+44
	mov	r0, r10
	ldr	r3, [r3]
	ldr	r3, [r3, r8]
	str	r3, [sp, #8]
	bl	lpa_hash_get_ppa
	str	r0, [sp, #28]
	adds	r0, r0, #1
	bne	.L3457
	movs	r2, #0
	add	r1, sp, #28
	mov	r0, r10
	bl	pm_log2phys
.L3457:
	ldr	r3, [sp, #28]
	ldr	r2, [sp, #8]
	cmp	r2, r3
	bne	.L3458
	ldr	r3, .L3485+48
	add	r1, sp, #32
	movs	r2, #1
	mov	r0, r10
	adds	r6, r6, #1
	ldr	r3, [r3]
	ldr	r3, [r3, r8]
	str	r3, [r1, #-8]!
	bl	pm_log2phys
	ldr	r3, .L3485+52
	ldrh	r2, [r3]
	ldr	r3, .L3485+56
	ldrb	r3, [r3]	@ zero_extendqisi2
	rsb	r3, r3, #24
	subs	r0, r3, r2
	movs	r3, #1
	lsls	r3, r3, r0
	ldr	r0, [sp, #8]
	subs	r3, r3, #1
	lsrs	r0, r0, r2
	ldr	r2, .L3485+60
	ands	r0, r0, r3
	ldrb	r1, [r2]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	uxth	r0, r0
.L3484:
	bl	ftl_vpn_decrement
	ldr	r3, [fp]
	mov	r2, #-1
	str	r2, [r3, r8]
.L3456:
	ldr	r3, [sp, #12]
	add	r8, r8, #4
	adds	r3, r3, #1
	str	r3, [sp, #12]
	ldr	r2, [sp, #12]
	ldr	r3, [sp, #4]
	cmp	r3, r2
	bne	.L3461
.L3454:
	adds	r5, r5, #1
	b	.L3453
.L3458:
	ldr	r2, [r7]
	lsls	r2, r2, #23
	bpl	.L3460
	ldr	r2, [sp, #8]
	mov	r1, r10
	ldr	r0, .L3485+64
	bl	printf
.L3460:
	ldrh	r0, [r4, #80]
	b	.L3484
.L3486:
	.align	2
.L3485:
	.word	.LANCHOR10
	.word	.LANCHOR79
	.word	.LANCHOR14
	.word	.LC215
	.word	.LANCHOR9
	.word	.LC218
	.word	.LANCHOR214
	.word	.LC0
	.word	.LANCHOR155
	.word	.LANCHOR125
	.word	.LC216
	.word	.LANCHOR156
	.word	.LANCHOR157
	.word	.LANCHOR68
	.word	.LANCHOR31
	.word	.LANCHOR69
	.word	.LC217
	.size	gc_update_l2p_map_new, .-gc_update_l2p_map_new
	.section	.text.gc_scan_src_blk_one_page,"ax",%progbits
	.align	1
	.global	gc_scan_src_blk_one_page
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	gc_scan_src_blk_one_page, %function
gc_scan_src_blk_one_page:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r1, #0
	ldr	r4, .L3517
	mov	r0, r1
	movw	r5, #65535
	ldr	r6, .L3517+4
	ldrb	r3, [r4, #4]	@ zero_extendqisi2
	ldrb	ip, [r6]	@ zero_extendqisi2
	add	r2, r4, r3, lsl #1
	ldrh	r7, [r2, #36]
	ldrh	r2, [r4, #2]
.L3488:
	cmp	r7, r5
	beq	.L3490
	cbz	r0, .L3491
	strh	r2, [r4, #2]	@ movhi
.L3491:
	cbz	r1, .L3492
	strb	r3, [r4, #4]
.L3492:
	ldr	r8, .L3517+20
	movs	r0, #1
	ldr	r10, .L3517+24
	mov	fp, #1
	bl	buf_alloc
	mov	r5, r0
.L3493:
	ldrb	r1, [r4, #6]	@ zero_extendqisi2
	cmp	fp, r1
	ble	.L3502
	mov	r0, r5
	bl	zbuf_free
	ldrb	r3, [r4, #4]	@ zero_extendqisi2
	ldrb	r2, [r6]	@ zero_extendqisi2
	adds	r3, r3, #1
	uxtb	r3, r3
	cmp	r2, r3
	strb	r3, [r4, #4]
	bne	.L3487
	ldrh	r3, [r4, #2]
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #4]
.L3487:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3490:
	adds	r3, r3, #1
	uxtb	r3, r3
	cmp	r3, ip
	itt	eq
	moveq	r3, #0
	addeq	r2, r2, #1
	add	r1, r4, r3, lsl #1
	it	eq
	uxtheq	r2, r2
	ldrh	r7, [r1, #36]
	it	eq
	moveq	r0, #1
	movs	r1, #1
	b	.L3488
.L3502:
	ldrh	r3, [r8]
	cmp	r1, #2
	mul	r2, r7, r3
	beq	.L3494
	cmp	r1, #3
	bne	.L3495
	ldr	r3, .L3517+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L3496
.L3494:
	ldrh	r3, [r4, #2]
	add	r3, r2, r3, lsl #1
	ldrb	r2, [r10]	@ zero_extendqisi2
	subs	r3, r3, #1
	add	r3, r3, fp
	orr	r3, r3, r2, lsl #24
.L3516:
	str	r3, [r5, #24]
	movs	r1, #1
	mov	r0, r5
	bl	sblk_read_page
	ldr	r3, [r5, #36]
	adds	r2, r3, #1
	beq	.L3499
	cmp	r3, #512
	beq	.L3499
	ldr	r3, [r5, #12]
	ldr	r3, [r3, #4]
	mov	r0, r3
	str	r3, [sp, #4]
	bl	lpa_hash_get_ppa
	str	r0, [sp, #12]
	adds	r0, r0, #1
	ldr	r3, [sp, #4]
	bne	.L3501
	ldr	r2, .L3517+12
	ldr	r2, [r2]
	cmp	r3, r2
	bcs	.L3501
	movs	r2, #0
	add	r1, sp, #12
	mov	r0, r3
	bl	pm_log2phys
.L3501:
	ldr	r2, [r5, #24]
	ldr	r3, [sp, #12]
	cmp	r2, r3
	bne	.L3499
	ldr	r1, .L3517+16
	ldrh	r3, [r4, #20]
	ldr	r1, [r1]
	str	r2, [r1, r3, lsl #2]
	adds	r3, r3, #1
	strh	r3, [r4, #20]	@ movhi
.L3499:
	ldrh	r3, [r4, #22]
	add	fp, fp, #1
	adds	r3, r3, #1
	strh	r3, [r4, #22]	@ movhi
	b	.L3493
.L3496:
	ldrh	r3, [r4, #2]
	add	r3, r3, r2
	orr	r3, r3, fp, lsl #24
	b	.L3516
.L3495:
	ldrh	r3, [r4, #2]
	add	r3, r3, r2
	b	.L3516
.L3518:
	.align	2
.L3517:
	.word	.LANCHOR64
	.word	.LANCHOR80
	.word	.LANCHOR35
	.word	.LANCHOR122
	.word	.LANCHOR70
	.word	.LANCHOR105
	.word	.LANCHOR73
	.size	gc_scan_src_blk_one_page, .-gc_scan_src_blk_one_page
	.section	.text.gc_scan_src_blk,"ax",%progbits
	.align	1
	.global	gc_scan_src_blk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	gc_scan_src_blk, %function
gc_scan_src_blk:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	movw	r3, #65535
	ldr	r4, .L3563
	ldrh	r2, [r4]
	cmp	r2, r3
	bne	.L3520
	movw	r2, #1235
	ldr	r1, .L3563+4
	ldr	r0, .L3563+8
	bl	printf
.L3520:
	ldrh	r1, [r4]
	movw	r3, #65535
	cmp	r1, r3
	beq	.L3541
	ldr	r3, .L3563+12
	ldr	r3, [r3]
	lsls	r0, r3, #23
	bpl	.L3522
	ldr	r3, .L3563+16
	ldr	r0, .L3563+20
	ldr	r3, [r3]
	ldrh	r2, [r3, r1, lsl #1]
	bl	printf
.L3522:
	ldr	r1, .L3563+24
	ldrh	r0, [r4]
	bl	ftl_get_blk_list_in_sblk
	uxtb	r0, r0
	strb	r0, [r4, #5]
	cbnz	r0, .L3523
	movw	r3, #65535
	strh	r3, [r4]	@ movhi
.L3519:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3523:
	ldr	r5, .L3563+28
	ldrh	r3, [r4]
	ldr	r2, [r5]
	add	r2, r2, r3, lsl #2
	ldrb	r2, [r2, #2]	@ zero_extendqisi2
	and	r2, r2, #224
	cmp	r2, #32
	beq	.L3524
	cmp	r2, #224
	beq	.L3524
	cbz	r2, .L3525
	ldr	r2, .L3563+32
	ldr	r2, [r2]
	ldrh	r1, [r2, #16]
	cmp	r1, r3
	beq	.L3524
	ldrh	r1, [r2, #48]
	cmp	r1, r3
	beq	.L3524
	ldrh	r2, [r2, #80]
	cmp	r2, r3
	bne	.L3561
.L3524:
	movw	r3, #65535
	movs	r0, #0
	strh	r3, [r4]	@ movhi
	strh	r0, [r4, #20]	@ movhi
	b	.L3519
.L3525:
	ldr	r5, .L3563+16
	ldr	r1, [r5]
	ldrh	r3, [r1, r3, lsl #1]
	cbz	r3, .L3527
	movw	r2, #1255
	ldr	r1, .L3563+4
	ldr	r0, .L3563+8
	bl	printf
.L3527:
	ldrh	r2, [r4]
	movs	r1, #0
	ldr	r3, [r5]
	strh	r1, [r3, r2, lsl #1]	@ movhi
	b	.L3524
.L3561:
	add	r0, r4, r0, lsl #1
	movw	r3, #65535
	ldrh	r6, [r0, #34]
	cmp	r6, r3
	bne	.L3528
	movw	r2, #1263
	ldr	r1, .L3563+4
	ldr	r0, .L3563+8
	bl	printf
.L3528:
	ldr	r2, .L3563+36
	ldrh	r0, [r4]
	ldr	r1, .L3563+40
	ldrh	r2, [r2]
	ldr	r8, .L3563+72
	ldrh	r3, [r1]
	mov	r10, r1
	muls	r6, r2, r6
	ldr	r2, [r5]
	subs	r3, r3, #1
	uxth	r3, r3
	add	r2, r2, r0, lsl #2
	ldrb	r2, [r2, #2]	@ zero_extendqisi2
	and	r2, r2, #224
	cmp	r2, #160
	bne	.L3542
	ldr	r2, .L3563+44
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, #2
	uxth	r7, r2
	orr	r6, r6, r2, lsl #24
	ldr	r2, .L3563+48
	it	eq
	ldrheq	r3, [r8]
	ldrb	r2, [r2]	@ zero_extendqisi2
	itt	eq
	addeq	r3, r3, #-1
	uxtheq	r3, r3
	cbz	r2, .L3529
	ldrh	r3, [r8]
	subs	r3, r3, #1
	uxth	r3, r3
.L3529:
	orrs	r6, r6, r3
	strb	r7, [r4, #6]
	movs	r5, #0
	movs	r0, #1
	strh	r5, [r4, #2]	@ movhi
	strb	r5, [r4, #4]
	strh	r5, [r4, #22]	@ movhi
	strh	r5, [r4, #24]	@ movhi
	bl	buf_alloc
	str	r6, [r0, #24]
	movs	r1, #1
	ldr	r6, .L3563+52
	mov	fp, r0
	bl	sblk_read_page
	ldrh	r3, [r8]
	movs	r1, #255
	ldrb	r2, [r6]	@ zero_extendqisi2
	ldr	r8, .L3563+76
	muls	r2, r3, r2
	ldr	r0, [r8]
	lsls	r2, r2, #2
	bl	ftl_memset
	ldr	r3, [fp, #36]
	strh	r5, [r4, #20]	@ movhi
	adds	r2, r3, #1
	beq	.L3562
	cmp	r3, #512
	bne	.L3532
.L3562:
	mov	r0, fp
	bl	zbuf_free
	mov	r0, #-1
	b	.L3519
.L3542:
	movs	r7, #1
	b	.L3529
.L3532:
	ldr	r3, [fp, #12]
	ldr	r2, [r3]
	ldr	r3, .L3563+56
	cmp	r2, r3
	beq	.L3533
	movw	r2, #1298
	ldr	r1, .L3563+4
	ldr	r0, .L3563+8
	bl	printf
	b	.L3562
.L3533:
	ldrh	r3, [r10]
	ldrb	r6, [r6]	@ zero_extendqisi2
	ldr	r10, .L3563+80
	smulbb	r6, r6, r3
	smulbb	r6, r6, r7
	ldr	r7, [fp, #4]
	uxth	r6, r6
	subs	r7, r7, #4
.L3534:
	cmp	r5, r6
	blt	.L3539
	ldr	r5, .L3563+16
	mov	r0, fp
	bl	zbuf_free
	ldrh	r1, [r4]
	ldr	r3, [r5]
	ldrh	r2, [r3, r1, lsl #1]
	ldrh	r3, [r4, #20]
	cmp	r2, r3
	beq	.L3540
	ldr	r0, .L3563+60
	bl	printf
.L3540:
	ldr	r3, [r5]
	ldrh	r1, [r4, #20]
	ldrh	r2, [r4]
	strh	r1, [r3, r2, lsl #1]	@ movhi
	movs	r3, #0
	strh	r3, [r4, #24]	@ movhi
	ldrh	r0, [r4, #20]
	b	.L3519
.L3539:
	ldr	r0, [r7, #4]!
	adds	r3, r0, #1
	beq	.L3536
	bl	lpa_hash_get_ppa
	str	r0, [sp, #12]
	adds	r0, r0, #1
	bne	.L3537
	movs	r2, #0
	add	r1, sp, #12
	ldr	r0, [r7]
	bl	pm_log2phys
.L3537:
	ldr	r2, .L3563+64
	movs	r1, #1
	ldrh	r0, [r10]
	ldr	r3, [sp, #12]
	ldrb	r2, [r2]	@ zero_extendqisi2
	str	r3, [sp, #4]
	rsb	r2, r2, #24
	subs	r2, r2, r0
	lsr	r0, r3, r0
	lsl	r2, r1, r2
	ldr	r1, .L3563+68
	subs	r2, r2, #1
	ands	r0, r0, r2
	ldrb	r1, [r1]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	ldrh	r2, [r4]
	ldr	r3, [sp, #4]
	cmp	r0, r2
	bne	.L3536
	ldrh	r2, [r4, #20]
	ldr	r1, [r8]
	str	r3, [r1, r2, lsl #2]
	adds	r2, r2, #1
	strh	r2, [r4, #20]	@ movhi
.L3536:
	adds	r5, r5, #1
	b	.L3534
.L3541:
	movs	r0, #0
	b	.L3519
.L3564:
	.align	2
.L3563:
	.word	.LANCHOR64
	.word	.LANCHOR215
	.word	.LC0
	.word	.LANCHOR14
	.word	.LANCHOR9
	.word	.LC219
	.word	.LANCHOR64+36
	.word	.LANCHOR7
	.word	.LANCHOR10
	.word	.LANCHOR105
	.word	.LANCHOR87
	.word	.LANCHOR73
	.word	.LANCHOR35
	.word	.LANCHOR80
	.word	-178307901
	.word	.LC220
	.word	.LANCHOR31
	.word	.LANCHOR69
	.word	.LANCHOR79
	.word	.LANCHOR70
	.word	.LANCHOR68
	.size	gc_scan_src_blk, .-gc_scan_src_blk
	.section	.text.gc_scan_static_data,"ax",%progbits
	.align	1
	.global	gc_scan_static_data
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	gc_scan_static_data, %function
gc_scan_static_data:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r4, r5, r6, r7, r8, r10, lr}
	ldr	r4, .L3581
	ldr	r3, [r4]
	ldr	r2, [r3, #544]
	adds	r2, r2, #1
	beq	.L3566
	ldr	r7, .L3581+4
	movs	r5, #11
	ldr	r8, .L3581+28
.L3574:
	ldr	r3, [r4]
	movs	r2, #0
	add	r1, sp, #4
	ldr	r0, [r3, #544]
	bl	pm_log2phys
	ldr	r3, [sp, #4]
	adds	r3, r3, #1
	beq	.L3567
	movs	r0, #1
	bl	buf_alloc
	ldr	r3, [sp, #4]
	mov	r6, r0
	movs	r1, #1
	str	r3, [r0, #24]
	bl	sblk_read_page
	ldr	r3, [r6, #36]
	cmp	r3, #256
	bne	.L3568
	ldr	r3, .L3581+8
	mov	r10, #1
	ldr	r0, [sp, #4]
	ldrh	r2, [r3]
	ldr	r3, .L3581+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	lsrs	r0, r0, r2
	rsb	r3, r3, #24
	subs	r3, r3, r2
	ldr	r2, .L3581+16
	lsl	r3, r10, r3
	subs	r3, r3, #1
	ldrb	r1, [r2]	@ zero_extendqisi2
	ands	r0, r0, r3
	bl	__aeabi_uidiv
	movs	r2, #0
	mov	r1, r10
	uxth	r0, r0
	bl	gc_add_sblk
.L3568:
	ldr	r2, [r6, #12]
	ldr	r3, [r4]
	ldr	r2, [r2, #4]
	ldr	r3, [r3, #544]
	cmp	r2, r3
	beq	.L3569
	movw	r2, #1737
	mov	r1, r7
	mov	r0, r8
	bl	printf
.L3569:
	mov	r0, r6
	bl	zbuf_free
.L3567:
	ldr	r3, [r4]
	ldr	r1, .L3581+20
	ldr	r2, [r3, #544]
	ldr	r1, [r1]
	adds	r2, r2, #1
	cmp	r2, r1
	str	r2, [r3, #544]
	bcc	.L3570
	mov	r2, #-1
	str	r2, [r3, #544]
	ldr	r2, [r3, #548]
	adds	r2, r2, #1
	str	r2, [r3, #548]
	bl	ftl_flush
	bl	pm_flush
	bl	ftl_ext_info_flush
	movs	r0, #0
	bl	ftl_info_flush
.L3565:
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L3570:
	ldr	r3, [sp, #4]
	adds	r3, r3, #1
	bne	.L3565
	subs	r5, r5, #1
	uxth	r5, r5
	cmp	r5, #0
	bne	.L3574
	b	.L3565
.L3566:
	ldr	r2, [r3, #536]
	ldr	r1, [r3, #12]
	ldr	r0, .L3581+24
	add	r2, r2, #12910592
	add	r2, r2, #49408
	cmp	r1, r2
	bhi	.L3576
	ldr	r4, [r0]
	ldr	r2, [r3, #540]
	ldr	r4, [r4, #44]
	add	r2, r2, #4992
	adds	r2, r2, #8
	cmp	r4, r2
	bls	.L3565
.L3576:
	ldr	r2, [r0]
	ldr	r2, [r2, #44]
	str	r1, [r3, #536]
	str	r2, [r3, #540]
	movs	r2, #0
	str	r2, [r3, #544]
	b	.L3565
.L3582:
	.align	2
.L3581:
	.word	.LANCHOR10
	.word	.LANCHOR216
	.word	.LANCHOR68
	.word	.LANCHOR31
	.word	.LANCHOR69
	.word	.LANCHOR122
	.word	.LANCHOR104
	.word	.LC0
	.size	gc_scan_static_data, .-gc_scan_static_data
	.section	.text.ftl_sblk_dump,"ax",%progbits
	.align	1
	.global	ftl_sblk_dump
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_sblk_dump, %function
ftl_sblk_dump:
	@ args = 0, pretend = 0, frame = 88
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	lsls	r3, r0, #2
	ldr	r4, .L3624
	sub	sp, sp, #128
	lsls	r2, r0, #2
	mov	r6, r0
	str	r3, [sp, #72]
	ldr	r3, [r4]
	str	r1, [sp, #68]
	ldr	r1, [r3, r0, lsl #2]
	adds	r2, r3, r2
	ldrb	r2, [r2, #2]	@ zero_extendqisi2
	ubfx	r1, r1, #11, #8
	str	r1, [sp, #4]
	mov	r1, r0
	ldrh	r3, [r3, r0, lsl #2]
	ldr	r0, .L3624+4
	ubfx	r3, r3, #0, #11
	str	r3, [sp]
	ubfx	r3, r2, #3, #2
	lsrs	r2, r2, #5
	bl	printf
	movw	r3, #65535
	cmp	r6, r3
	beq	.L3605
	ldr	r3, .L3624+8
	ldrh	r3, [r3]
	cmp	r3, r6
	bls	.L3605
	ldr	r3, [r4]
	lsls	r2, r6, #2
	add	r1, sp, #112
	strh	r6, [sp, #96]	@ movhi
	mov	r0, r6
	movs	r5, #0
	add	r3, r3, r2
	mov	r10, r5
	ldrb	r3, [r3, #2]	@ zero_extendqisi2
	and	r3, r3, #224
	cmp	r3, #160
	itet	eq
	ldreq	r3, .L3624+12
	movne	fp, #1
	ldrbeq	fp, [r3]	@ zero_extendqisi2
	bl	ftl_get_blk_list_in_sblk
	ldr	r3, .L3624+16
	uxtb	r0, r0
	lsls	r2, r6, #2
	strb	r5, [sp, #101]
	strb	r0, [sp, #105]
	mov	r1, r6
	ldrh	r3, [r3]
	strh	r5, [sp, #98]	@ movhi
	strh	r5, [sp, #106]	@ movhi
	smulbb	r3, r3, r0
	strh	r3, [sp, #102]	@ movhi
	ldr	r3, [r4]
	add	r3, r3, r2
	ldrb	r2, [r3, #2]	@ zero_extendqisi2
	mov	r3, fp
	str	r0, [sp]
	ldr	r0, .L3624+20
	lsrs	r2, r2, #5
	bl	printf
	movs	r0, #1
	bl	buf_alloc
	mov	r7, r0
	str	r5, [sp, #48]
	str	r5, [sp, #44]
.L3586:
	ldr	r3, .L3624+16
	ldrh	r2, [r3]
	uxth	r3, r5
	cmp	r2, r3
	bls	.L3602
	str	r3, [sp, #60]
	lsls	r3, r3, #1
	subs	r2, r3, #1
	str	r2, [sp, #76]
	ldr	r2, [sp, #60]
	add	r3, r3, r2
	subs	r3, r3, #1
	str	r3, [sp, #80]
	movs	r3, #0
	b	.L3623
.L3599:
	ldr	r3, [sp, #84]
	add	r2, sp, #128
	add	r3, r2, r3, lsl #1
	ldrh	r3, [r3, #-32]
	str	r3, [sp, #56]
	movw	r3, #65535
	ldr	r2, [sp, #56]
	cmp	r2, r3
	beq	.L3587
	ldr	r3, .L3624+24
	cmp	fp, #3
	ldrh	r4, [r3]
	mul	r4, r2, r4
	bne	.L3588
	ldr	r3, .L3624+28
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L3589
	ldr	r3, [sp, #80]
.L3621:
	add	r4, r4, r3
	ldr	r3, .L3624+12
	add	r4, r4, r8
	ldrb	r3, [r3]	@ zero_extendqisi2
	orr	r4, r4, r3, lsl #24
	b	.L3590
.L3589:
	uxtah	r4, r4, r5
	orr	r4, r4, r8, lsl #24
.L3590:
	movs	r1, #1
	str	r4, [r7, #24]
	mov	r0, r7
	bl	sblk_read_page
	ldr	r2, [r7, #12]
	ldr	r3, [r7, #36]
	ldr	r0, .L3624+32
	ldr	r1, [r2, #12]
	str	r3, [sp, #64]
	ldr	r3, [r7, #4]
	str	r1, [sp, #32]
	ldr	r1, [r2, #8]
	str	r1, [sp, #28]
	ldr	r1, [r2, #4]
	str	r1, [sp, #24]
	ldr	r2, [r2]
	ldr	r1, [sp, #56]
	str	r2, [sp, #20]
	ldr	r2, [r3, #12]
	str	r2, [sp, #16]
	ldr	r2, [r3, #8]
	str	r2, [sp, #12]
	ldr	r2, [r3, #4]
	str	r2, [sp, #8]
	ldr	r3, [r3]
	ldr	r2, [sp, #60]
	str	r3, [sp, #4]
	ldr	r3, [sp, #64]
	str	r3, [sp]
	mov	r3, r4
	bl	printf
	ldr	r3, [sp, #64]
	adds	r2, r3, #1
	beq	.L3607
	cmp	r3, #512
	ldr	r3, [sp, #44]
	it	eq
	moveq	r3, #1
.L3622:
	str	r3, [sp, #44]
	ldr	r3, .L3624
	ldr	r2, [sp, #72]
	ldr	r3, [r3]
	add	r3, r3, r2
	ldrb	r3, [r3, #2]	@ zero_extendqisi2
	and	r3, r3, #224
	cmp	r3, #224
	beq	.L3587
	cmp	r3, #32
	beq	.L3587
	ldr	r3, [r7, #12]
	ldr	r0, [r3, #4]
	bl	lpa_hash_get_ppa
	str	r0, [sp, #92]
	adds	r0, r0, #1
	bne	.L3593
	ldr	r3, [r7, #12]
	movs	r2, #0
	add	r1, sp, #92
	ldr	r0, [r3, #4]
	bl	pm_log2phys
.L3593:
	ldr	r3, [sp, #92]
	cmp	r4, r3
	bne	.L3594
	ldr	r3, [sp, #48]
	mov	r1, r4
	ldr	r2, [r7, #12]
	ldr	r0, .L3624+36
	adds	r3, r3, #1
	ldr	r2, [r2, #4]
	str	r3, [sp, #48]
	bl	printf
.L3594:
	ldr	r3, [sp, #68]
	cbz	r3, .L3596
	ldr	r2, [r3, r10, lsl #2]
	lsl	r4, r10, #2
	ldr	r3, [r7, #12]
	ldr	r3, [r3, #4]
	cmp	r3, r2
	beq	.L3597
	ldr	r3, .L3624+40
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L3597
	mov	r1, r10
	ldr	r0, .L3624+44
	bl	printf
.L3597:
	ldr	r3, [sp, #68]
	ldr	r2, [r7, #12]
	ldr	r3, [r3, r4]
	ldr	r2, [r2, #4]
	cmp	r2, r3
	beq	.L3596
	adds	r3, r3, #1
	beq	.L3596
	movw	r2, #1383
	ldr	r1, .L3624+48
	ldr	r0, .L3624+52
	bl	printf
.L3596:
	add	r10, r10, #1
.L3587:
	add	r8, r8, #1
	uxth	r8, r8
.L3601:
	cmp	fp, r8
	bcs	.L3599
	ldr	r3, [sp, #52]
	adds	r3, r3, #1
.L3623:
	str	r3, [sp, #52]
	ldrb	r2, [sp, #105]	@ zero_extendqisi2
	ldrh	r3, [sp, #52]
	cmp	r2, r3
	bls	.L3600
	adds	r3, r3, #8
	mov	r8, #1
	str	r3, [sp, #84]
	b	.L3601
.L3588:
	cmp	fp, #2
	bne	.L3591
	ldr	r3, [sp, #76]
	b	.L3621
.L3591:
	uxtah	r4, r4, r5
	b	.L3590
.L3607:
	movs	r3, #1
	b	.L3622
.L3600:
	adds	r5, r5, #1
	b	.L3586
.L3602:
	mov	r0, r7
	bl	zbuf_free
	ldr	r3, .L3624+56
	mov	r1, r6
	ldr	r0, .L3624+60
	ldr	r2, [r3]
	ldr	r3, [sp, #48]
	ldrh	r2, [r2, r6, lsl #1]
	bl	printf
	ldr	r0, [sp, #44]
.L3583:
	add	sp, sp, #128
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3605:
	movs	r0, #0
	b	.L3583
.L3625:
	.align	2
.L3624:
	.word	.LANCHOR7
	.word	.LC221
	.word	.LANCHOR6
	.word	.LANCHOR73
	.word	.LANCHOR87
	.word	.LC222
	.word	.LANCHOR105
	.word	.LANCHOR35
	.word	.LC163
	.word	.LC223
	.word	.LANCHOR14
	.word	.LC224
	.word	.LANCHOR217
	.word	.LC0
	.word	.LANCHOR9
	.word	.LC225
	.size	ftl_sblk_dump, .-ftl_sblk_dump
	.section	.text.zftl_read,"ax",%progbits
	.align	1
	.global	zftl_read
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	zftl_read, %function
zftl_read:
	@ args = 0, pretend = 0, frame = 48
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r5, r3
	ldr	r3, .L3673
	mov	r4, r0
	sub	sp, sp, #72
	mov	r6, r1
	mov	fp, r2
	ldr	r3, [r3]
	lsls	r0, r3, #19
	bpl	.L3627
	mov	r3, r2
	ldr	r0, .L3673+4
	mov	r2, r1
	mov	r1, r4
	bl	printf
.L3627:
	cmp	r4, #0
	bne	.L3628
	ldr	r3, .L3673+8
	mov	r4, #24576
	ldr	r3, [r3]
.L3629:
	add	r2, r6, fp
	cmp	r3, r2
	bcc	.L3658
	adds	r3, r4, r6
	ldr	r6, .L3673+12
	str	r3, [sp, #28]
	ldr	r3, .L3673+16
	ldr	r0, [sp, #28]
	ldr	r2, [r3]
	ldr	r3, [r2, #24]
	add	r3, r3, fp
	str	r3, [r2, #24]
	ldr	r3, .L3673+20
	ldrb	r4, [r3]	@ zero_extendqisi2
	mov	r1, r4
	bl	__aeabi_uidiv
	ldr	r3, [sp, #28]
	mov	r1, r4
	str	r0, [sp, #36]
	add	r3, fp, r3
	subs	r0, r3, #1
	str	r3, [sp, #44]
	bl	__aeabi_uidiv
	ldr	r3, [sp, #36]
	ldr	r4, [sp, #36]
	str	r0, [sp, #48]
	rsb	r3, r3, #1
	add	r3, r3, r0
	str	r3, [sp, #32]
	movs	r3, #0
	str	r3, [sp, #40]
.L3631:
	ldr	r3, [sp, #32]
	cbnz	r3, .L3656
	ldr	r0, [sp, #40]
.L3626:
	add	sp, sp, #72
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3628:
	cmp	r4, #3
	bhi	.L3658
	lsls	r4, r4, #13
	mov	r3, #8192
	b	.L3629
.L3656:
	ldr	r3, .L3673+20
	ldrb	r1, [r3]	@ zero_extendqisi2
	ldr	r3, [sp, #36]
	cmp	r4, r3
	uxth	r7, r1
	bne	.L3632
	ldr	r0, [sp, #28]
	bl	__aeabi_uidivmod
	uxth	r8, r1
	sub	r7, r7, r8
	uxth	r7, r7
	cmp	fp, r7
	bcs	.L3633
	uxth	r7, fp
.L3633:
	ldr	r2, .L3673+12
	movs	r3, #0
.L3636:
	ldr	r1, [r2, #20]
	cmp	r4, r1
	bne	.L3634
	ldrb	r1, [r2, #2]	@ zero_extendqisi2
	lsls	r1, r1, #28
	bpl	.L3634
	movs	r2, #48
	lsls	r7, r7, #9
	mov	r0, r5
	mla	r3, r2, r3, r6
	add	r5, r5, r7
	mov	r2, r7
	ldr	r1, [r3, #4]
	add	r1, r1, r8, lsl #9
	bl	ftl_memcpy
.L3635:
	ldr	r3, [sp, #32]
	adds	r4, r4, #1
	subs	r3, r3, #1
	str	r3, [sp, #32]
.L3642:
	ldr	r3, .L3673+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #2
	bls	.L3643
	ldr	r3, [sp, #32]
	cmp	r3, #0
	bne	.L3631
.L3643:
	ldr	r3, .L3673+28
	ldrb	r1, [r3]	@ zero_extendqisi2
	cmp	r1, #0
	beq	.L3631
	ldr	r3, .L3673+32
	ldrb	r0, [r3]	@ zero_extendqisi2
	add	r0, r0, r0, lsl #1
	add	r0, r6, r0, lsl #4
	bl	sblk_read_page
.L3645:
	ldr	r3, .L3673+28
	ldr	r8, .L3673+32
	ldrb	r2, [r3]	@ zero_extendqisi2
	cmp	r2, #0
	bne	.L3655
	movs	r1, #255
	strb	r2, [r3]
	strb	r1, [r8]
	b	.L3631
.L3632:
	ldr	r3, [sp, #48]
	mov	r8, #0
	cmp	r4, r3
	itttt	eq
	ldreq	r3, [sp, #28]
	addeq	r7, r3, fp
	mlseq	r1, r4, r1, r7
	uxtbeq	r7, r1
	b	.L3633
.L3634:
	adds	r3, r3, #1
	adds	r2, r2, #48
	cmp	r3, #32
	bne	.L3636
	mov	r0, r4
	bl	lpa_hash_get_ppa
	str	r0, [sp, #68]
	adds	r0, r0, #1
	bne	.L3637
	movs	r2, #0
	add	r1, sp, #68
	mov	r0, r4
	bl	pm_log2phys
.L3637:
	ldr	r3, [sp, #68]
	adds	r3, r3, #1
	bne	.L3638
	ldr	r8, .L3673+20
	movs	r7, #0
.L3639:
	ldrb	r3, [r8]	@ zero_extendqisi2
	cmp	r7, r3
	bcs	.L3635
	mla	r3, r3, r4, r7
	ldr	r2, [sp, #28]
	cmp	r2, r3
	bhi	.L3640
	ldr	r2, [sp, #44]
	cmp	r2, r3
	bls	.L3640
	mov	r0, r5
	add	r5, r5, #512
	mov	r2, #512
	movs	r1, #0
	bl	ftl_memset
.L3640:
	adds	r7, r7, #1
	b	.L3639
.L3638:
	movs	r0, #0
	bl	buf_alloc
	cmp	r0, #0
	beq	.L3642
	ldr	r2, .L3673+16
	ldr	r1, [r2]
	ldr	r2, [r1, #40]
	adds	r2, r2, #1
	str	r2, [r1, #40]
	ldr	r2, [sp, #68]
	str	r5, [r0, #8]
	add	r5, r5, r7, lsl #9
	str	r4, [r0, #20]
	str	r2, [r0, #24]
	str	r2, [r0, #28]
	strb	r7, [r0, #40]
	strb	r8, [r0, #41]
	bl	zftl_add_read_buf
	b	.L3635
.L3674:
	.align	2
.L3673:
	.word	.LANCHOR14
	.word	.LC226
	.word	.LANCHOR61
	.word	.LANCHOR52
	.word	.LANCHOR104
	.word	.LANCHOR125
	.word	.LANCHOR54
	.word	.LANCHOR129
	.word	.LANCHOR128
.L3655:
	ldrb	r3, [r8]	@ zero_extendqisi2
	cmp	r3, #255
	bne	.L3646
	mov	r2, #1088
	ldr	r1, .L3675
	ldr	r0, .L3675+4
	bl	printf
.L3646:
	ldrb	r7, [r8]	@ zero_extendqisi2
	add	r3, r7, r7, lsl #1
	add	r3, r6, r3, lsl #4
	str	r3, [sp, #52]
	movs	r3, #48
	muls	r3, r7, r3
	adds	r2, r6, r3
	ldrb	r3, [r6, r3]	@ zero_extendqisi2
	strb	r3, [r8]
	ldr	r8, [r2, #36]
	cmp	r8, #-1
	bne	.L3647
	ldr	r3, .L3675+8
	str	r8, [sp, #40]
	ldr	r2, [r3]
	ldr	r3, [r2, #552]
	adds	r3, r3, #1
	str	r3, [r2, #552]
.L3648:
	movs	r3, #48
	mla	r3, r3, r7, r6
	ldr	r2, [r3, #12]
	ldr	r3, [r3, #20]
	ldr	r1, [r2, #4]
	cmp	r1, r3
	bne	.L3649
	cmp	r8, #-1
	bne	.L3650
.L3649:
	ldr	r1, .L3675+8
	mov	r10, #48
	mla	r10, r10, r7, r6
	ldr	r0, [r1]
	ldr	r1, [r0, #552]
	adds	r1, r1, #1
	str	r1, [r0, #552]
	ldr	r0, [r2, #12]
	ldrb	r1, [r10, #1]	@ zero_extendqisi2
	str	r0, [sp, #16]
	ldr	r0, [r2, #8]
	str	r0, [sp, #12]
	ldr	r0, [r2, #4]
	str	r0, [sp, #8]
	ldr	r2, [r2]
	ldr	r0, .L3675+12
	str	r2, [sp, #4]
	ldr	r2, [r10, #24]
	str	r2, [sp]
	mov	r2, r8
	bl	printf
	ldr	r3, .L3675+16
	ldrh	r2, [r3]
	ldr	r3, .L3675+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	rsb	r3, r3, #24
	subs	r0, r3, r2
	movs	r3, #1
	lsls	r3, r3, r0
	ldr	r0, [r10, #24]
	subs	r3, r3, #1
	lsrs	r0, r0, r2
	ldr	r2, .L3675+24
	ands	r0, r0, r3
	ldrb	r1, [r2]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	movs	r1, #0
	uxth	r0, r0
	bl	ftl_sblk_dump
.L3650:
	movs	r3, #48
	mla	r3, r3, r7, r6
	ldr	r2, [r3, #12]
	ldr	r3, [r3, #20]
	ldr	r2, [r2, #4]
	cmp	r2, r3
	bne	.L3651
	cmp	r8, #-1
	bne	.L3652
.L3651:
	movw	r2, #1109
	ldr	r1, .L3675
	ldr	r0, .L3675+4
	bl	printf
.L3652:
	movs	r3, #48
	mla	r7, r3, r7, r6
	ldr	r3, .L3675+28
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldrb	r2, [r7, #40]	@ zero_extendqisi2
	cmp	r3, r2
	bls	.L3653
	ldrb	r1, [r7, #41]	@ zero_extendqisi2
	lsls	r2, r2, #9
	ldr	r3, [r7, #4]
	ldr	r0, [r7, #8]
	add	r1, r3, r1, lsl #9
	bl	ftl_memcpy
.L3654:
	ldr	r1, [sp, #52]
	ldr	r0, .L3675+32
	bl	buf_remove_buf
	ldr	r0, [sp, #52]
	bl	zbuf_free
	ldr	r2, .L3675+36
	ldrb	r3, [r2]	@ zero_extendqisi2
	subs	r3, r3, #1
	strb	r3, [r2]
	b	.L3645
.L3647:
	cmp	r8, #256
	bne	.L3648
	ldr	r1, .L3675+16
	ldr	r3, [r2, #24]
	str	r2, [sp, #60]
	movs	r2, #1
	ldrh	r0, [r1]
	ldr	r1, .L3675+20
	str	r3, [sp, #56]
	ldrb	ip, [r1]	@ zero_extendqisi2
	ldr	r1, .L3675+24
	rsb	ip, ip, #24
	sub	ip, ip, r0
	lsr	r0, r3, r0
	lsl	ip, r2, ip
	ldrb	r1, [r1]	@ zero_extendqisi2
	add	ip, ip, #-1
	and	r0, ip, r0
	bl	__aeabi_uidiv
	ldr	r2, [sp, #60]
	mov	r10, r0
	uxth	r1, r0
	ldr	r3, [sp, #56]
	ldr	r0, .L3675+40
	ldr	r2, [r2, #20]
	bl	printf
	movs	r2, #0
	movs	r1, #1
	uxth	r0, r10
	bl	gc_add_sblk
	b	.L3648
.L3653:
	ldrb	r3, [r7, #2]	@ zero_extendqisi2
	bic	r3, r3, #8
	strb	r3, [r7, #2]
	b	.L3654
.L3658:
	mov	r0, #-1
	b	.L3626
.L3676:
	.align	2
.L3675:
	.word	.LANCHOR218
	.word	.LC0
	.word	.LANCHOR10
	.word	.LC228
	.word	.LANCHOR68
	.word	.LANCHOR31
	.word	.LANCHOR69
	.word	.LANCHOR125
	.word	.LANCHOR131
	.word	.LANCHOR129
	.word	.LC227
	.size	zftl_read, .-zftl_read
	.section	.text.ftl_vendor_read,"ax",%progbits
	.align	1
	.global	ftl_vendor_read
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_vendor_read, %function
ftl_vendor_read:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	mov	r3, r2
	mov	r2, r1
	add	r1, r0, #512
	movs	r0, #2
	b	zftl_read
	.size	ftl_vendor_read, .-ftl_vendor_read
	.section	.text.zftl_sys_read,"ax",%progbits
	.align	1
	.global	zftl_sys_read
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	zftl_sys_read, %function
zftl_sys_read:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	mov	r3, r2
	mov	r2, r1
	mov	r1, r0
	movs	r0, #2
	b	zftl_read
	.size	zftl_sys_read, .-zftl_sys_read
	.section	.text.StorageSysDataLoad,"ax",%progbits
	.align	1
	.global	StorageSysDataLoad
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	StorageSysDataLoad, %function
StorageSysDataLoad:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	mov	r4, r1
	mov	r5, r0
	mov	r2, #512
	movs	r1, #0
	mov	r0, r4
	bl	ftl_memset
	mov	r3, r4
	mov	r1, r5
	movs	r2, #1
	movs	r0, #2
	pop	{r4, r5, r6, lr}
	b	zftl_read
	.size	StorageSysDataLoad, .-StorageSysDataLoad
	.section	.text.FlashBootVendorRead,"ax",%progbits
	.align	1
	.global	FlashBootVendorRead
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashBootVendorRead, %function
FlashBootVendorRead:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	mov	r3, r2
	mov	r2, r1
	add	r1, r0, #512
	movs	r0, #2
	b	zftl_read
	.size	FlashBootVendorRead, .-FlashBootVendorRead
	.section	.text.ftl_read,"ax",%progbits
	.align	1
	.global	ftl_read
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_read, %function
ftl_read:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	b	zftl_read
	.size	ftl_read, .-ftl_read
	.section	.text.gc_check_data_one_wl,"ax",%progbits
	.align	1
	.global	gc_check_data_one_wl
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	gc_check_data_one_wl, %function
gc_check_data_one_wl:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #32
	ldr	r4, .L3711
	ldr	r3, .L3711+4
	ldr	r2, [r4, #8]
	ldr	r7, [r3]
	mov	r8, r3
	cbnz	r2, .L3683
	movs	r0, #1
	bl	buf_alloc
	str	r0, [r4, #8]
.L3683:
	ldr	r5, [r4, #8]
	cbnz	r5, .L3684
	mov	r2, #612
	ldr	r1, .L3711+8
	ldr	r0, .L3711+12
	bl	printf
.L3684:
	add	r3, r7, #96
	mov	r10, #0
.L3685:
	ldrb	r1, [r7, #89]	@ zero_extendqisi2
	cmp	r10, r1
	bge	.L3695
	movs	r6, #1
	b	.L3696
.L3694:
	ldr	r2, .L3711+16
	ldrh	r1, [r3]
	ldrh	ip, [r2]
	ldr	r2, .L3711+20
	ldrb	r0, [r2]	@ zero_extendqisi2
	mul	ip, ip, r1
	cmp	r0, #2
	beq	.L3686
	ldr	r1, .L3711+24
	ldrb	r1, [r1]	@ zero_extendqisi2
	cmp	r1, #0
	beq	.L3687
.L3686:
	ldrh	r1, [r4, #12]
	subs	r1, r1, #1
	add	r1, r1, ip
	add	r1, r1, r6
	orr	r1, r1, r0, lsl #24
.L3689:
	str	r1, [r5, #24]
	mov	r0, r5
	movs	r1, #1
	str	r3, [sp, #28]
	bl	sblk_read_page
	ldr	r1, [r5, #36]
	ldr	fp, .L3711+68
	ldr	r3, [sp, #28]
	adds	r1, r1, #1
	beq	.L3690
	ldr	r0, [fp]
	ldrh	ip, [r4, #18]
	ldr	r1, [r5, #12]
	ldr	r2, [r0, ip, lsl #2]
	ldr	r0, [r1, #4]
	cmp	r2, r0
	bne	.L3690
	ldr	r0, .L3711+28
	ldr	r1, [r1, #8]
	ldr	r0, [r0]
	ldr	r0, [r0, ip, lsl #2]
	cmp	r0, r1
	beq	.L3691
.L3690:
	ldr	r1, [fp]
	ldrh	r0, [r4, #18]
	ldr	r0, [r1, r0, lsl #2]
	adds	r0, r0, #1
	beq	.L3691
	ldr	r6, .L3711+32
	ldrb	r3, [r7, #89]	@ zero_extendqisi2
	ldr	r0, .L3711+36
	ldrh	r2, [r6]
	muls	r3, r2, r3
	movs	r2, #4
	bl	rknand_print_hex
	ldrh	r2, [r6]
	ldrb	r3, [r7, #89]	@ zero_extendqisi2
	ldr	r6, .L3711+28
	ldr	r0, .L3711+40
	muls	r3, r2, r3
	ldr	r1, [r6]
	movs	r2, #4
	bl	rknand_print_hex
	ldr	r3, .L3711+44
	ldr	r3, [r3]
	lsls	r3, r3, #21
	bpl	.L3692
	ldr	r3, [r5, #12]
	ldrh	r2, [r4, #18]
	ldr	r1, [fp]
	ldr	r0, [r3, #12]
	str	r0, [sp, #16]
	ldr	r0, [r3, #8]
	str	r0, [sp, #12]
	ldr	r0, [r3, #4]
	str	r0, [sp, #8]
	ldr	r3, [r3]
	ldr	r0, .L3711+48
	str	r3, [sp, #4]
	ldr	r3, [r6]
	ldr	r3, [r3, r2, lsl #2]
	str	r3, [sp]
	ldr	r3, [r1, r2, lsl #2]
	ldr	r2, [r5, #36]
	ldr	r1, [r5, #24]
	bl	printf
.L3692:
	ldr	r3, [r8]
	movs	r1, #0
	ldrh	r0, [r3, #80]
	bl	ftl_sblk_dump
	ldr	r3, .L3711+52
	movs	r1, #0
	ldrh	r2, [r7, #80]
	ldr	r3, [r3]
	strh	r1, [r3, r2, lsl #1]	@ movhi
	ldr	r2, [r8]
	ldr	r3, [r2, #556]
	adds	r3, r3, #1
	str	r3, [r2, #556]
	ldr	r3, .L3711+56
	ldr	r3, [r3]
	ldr	r2, [r3, #156]
	ldr	r3, .L3711+60
	cmp	r2, r3
	bne	.L3697
	ldr	r0, [r5, #24]
	bl	ftl_mask_bad_block
.L3697:
	mov	r0, #-1
	b	.L3682
.L3687:
	ldrh	r1, [r4, #12]
	cmp	r0, #3
	add	r1, r1, ip
	it	eq
	orreq	r1, r1, r6, lsl #24
	b	.L3689
.L3691:
	ldrh	r1, [r4, #18]
	adds	r6, r6, #1
	adds	r1, r1, #1
	strh	r1, [r4, #18]	@ movhi
.L3696:
	ldrh	r1, [r4, #16]
	cmp	r6, r1
	ble	.L3694
	add	r10, r10, #1
	adds	r3, r3, #2
	b	.L3685
.L3695:
	ldrh	r3, [r4, #12]
	adds	r2, r3, #1
	strh	r2, [r4, #12]	@ movhi
	ldr	r2, .L3711+64
	ldrb	r0, [r2]	@ zero_extendqisi2
	cbz	r0, .L3682
	movs	r0, #0
	adds	r3, r3, #2
	strh	r3, [r4, #12]	@ movhi
.L3693:
.L3682:
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3712:
	.align	2
.L3711:
	.word	.LANCHOR64
	.word	.LANCHOR10
	.word	.LANCHOR219
	.word	.LC0
	.word	.LANCHOR105
	.word	.LANCHOR73
	.word	.LANCHOR35
	.word	.LANCHOR156
	.word	.LANCHOR79
	.word	.LC229
	.word	.LC230
	.word	.LANCHOR14
	.word	.LC231
	.word	.LANCHOR9
	.word	.LANCHOR104
	.word	1145785929
	.word	.LANCHOR74
	.word	.LANCHOR155
	.size	gc_check_data_one_wl, .-gc_check_data_one_wl
	.global	__aeabi_idivmod
	.section	.text.ftl_update_l2p_map,"ax",%progbits
	.align	1
	.global	ftl_update_l2p_map
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_update_l2p_map, %function
ftl_update_l2p_map:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L3742
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #24
	ldrb	r7, [r0, #9]	@ zero_extendqisi2
	mov	r6, r0
	ldrh	r3, [r3]
	ldr	r2, .L3742+4
	muls	r7, r3, r7
	ldr	r4, [r2]
	ldrh	r3, [r0, #12]
	str	r2, [sp, #4]
	add	r4, r4, r3, lsl #2
	add	r3, r7, #1073741824
	subs	r3, r3, #1
	ldr	r3, [r4, r3, lsl #2]
	adds	r3, r3, #1
	beq	.L3714
	movw	r2, #1733
	ldr	r1, .L3742+8
	ldr	r0, .L3742+12
	bl	printf
.L3714:
	movs	r5, #0
	subs	r4, r4, #4
	mov	r10, r5
.L3715:
	cmp	r10, r7
	bne	.L3721
	ldr	r3, .L3742+16
	ldr	r4, .L3742+20
	ldr	r3, [r3]
	tst	r3, #4096
	beq	.L3722
	ldrh	r1, [r6]
	mov	r2, r5
	ldr	r3, [r4]
	ldr	r0, .L3742+24
	ldrh	r3, [r3, r1, lsl #1]
	bl	printf
.L3722:
	ldrh	r2, [r6]
	ldr	r3, [r4]
	strh	r5, [r3, r2, lsl #1]	@ movhi
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3721:
	ldr	r8, [r4, #4]!
	cmp	r8, #-1
	beq	.L3716
	ldr	r3, .L3742+28
	mov	r0, r8
	ldrb	r1, [r3]	@ zero_extendqisi2
	lsls	r1, r1, #7
	bl	__aeabi_uidiv
	uxth	r3, r0
	str	r3, [sp]
	ldr	r3, .L3742+16
	ldr	r3, [r3]
	lsls	r2, r3, #19
	bpl	.L3717
	mov	r3, r10
	mov	r2, r8
	ldr	r1, [sp]
	ldr	r0, .L3742+32
	bl	printf
.L3717:
	mov	r8, r4
	mov	fp, r10
.L3720:
	ldr	r0, [r8]
	adds	r3, r0, #1
	beq	.L3718
	ldr	r3, .L3742+28
	ldrb	r1, [r3]	@ zero_extendqisi2
	lsls	r1, r1, #7
	bl	__aeabi_uidiv
	ldr	r3, [sp]
	uxth	r0, r0
	cmp	r3, r0
	bne	.L3718
	ldrb	r3, [r6, #9]	@ zero_extendqisi2
	mov	r0, fp
	mov	r1, r3
	str	r3, [sp, #12]
	bl	__aeabi_idivmod
	ldr	r3, .L3742+36
	adds	r1, r1, #8
	ldrh	r0, [r6, r1, lsl #1]
	ldrh	r2, [r3]
	ldr	r3, [sp, #12]
	muls	r2, r0, r2
	mov	r1, r3
	mov	r0, fp
	str	r2, [sp, #8]
	bl	__aeabi_idiv
	ldr	r2, [sp, #8]
	add	r2, r2, r0
	ldr	r0, .L3742+40
	str	r2, [sp, #20]
	ldr	r1, [r8]
	bl	pm_ppa_update_check
	cbz	r0, .L3719
	ldr	r1, [sp, #4]
	mov	r3, r7
	movs	r2, #4
	ldr	r0, .L3742+44
	ldr	r1, [r1]
	bl	rknand_print_hex
.L3719:
	adds	r5, r5, #1
	movs	r2, #1
	uxth	r5, r5
	add	r1, sp, #20
	ldr	r0, [r8]
	bl	pm_log2phys
	mov	r3, #-1
	str	r3, [r8]
.L3718:
	add	fp, fp, #1
	add	r8, r8, #4
	cmp	r7, fp
	bne	.L3720
.L3716:
	add	r10, r10, #1
	b	.L3715
.L3743:
	.align	2
.L3742:
	.word	.LANCHOR87
	.word	.LANCHOR111
	.word	.LANCHOR220
	.word	.LC0
	.word	.LANCHOR14
	.word	.LANCHOR9
	.word	.LC235
	.word	.LANCHOR125
	.word	.LC232
	.word	.LANCHOR105
	.word	.LC233
	.word	.LC234
	.size	ftl_update_l2p_map, .-ftl_update_l2p_map
	.section	.text.ftl_alloc_new_data_sblk,"ax",%progbits
	.align	1
	.global	ftl_alloc_new_data_sblk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_alloc_new_data_sblk, %function
ftl_alloc_new_data_sblk:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	mov	r5, r0
	ldrh	r6, [r0]
	bl	ftl_update_l2p_map
	bl	pm_flush
	ldrh	r0, [r5]
	movw	r3, #65535
	cmp	r0, r3
	beq	.L3745
	bl	zftl_insert_data_list
.L3745:
	ldr	r4, .L3749
	mov	r0, r5
	ldr	r1, [r4]
	adds	r1, r1, #16
	cmp	r5, r1
	ite	eq
	moveq	r1, #2
	movne	r1, #3
	bl	ftl_open_sblk_init
	ldr	r3, [r4]
	ldr	r3, [r3, #560]
	cmp	r3, r6
	bne	.L3747
	movw	r5, #65535
	cmp	r6, r5
	beq	.L3747
	mov	r1, r6
	ldr	r0, .L3749+4
	bl	printf
	ldr	r3, [r4]
	ldr	r0, [r3, #564]
	bl	gc_mark_bad_ppa
	ldr	r3, [r4]
	mov	r2, #-1
	str	r5, [r3, #560]
	str	r2, [r3, #564]
.L3747:
	bl	ftl_ext_info_flush
	movs	r0, #0
	bl	ftl_info_flush
	bl	lpa_rebuild_hash
	movs	r0, #0
	pop	{r4, r5, r6, pc}
.L3750:
	.align	2
.L3749:
	.word	.LANCHOR10
	.word	.LC236
	.size	ftl_alloc_new_data_sblk, .-ftl_alloc_new_data_sblk
	.section	.text.ftl_write_commit,"ax",%progbits
	.align	1
	.global	ftl_write_commit
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_write_commit, %function
ftl_write_commit:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #32
	ldr	r7, .L3811
.L3752:
	ldr	r1, .L3811+4
	ldrb	r3, [r1]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L3754
	ldr	r0, .L3811+8
	subs	r3, r3, #1
	strb	r3, [r1]
	ldrb	r2, [r0]	@ zero_extendqisi2
	str	r2, [sp, #8]
	add	r2, r2, r2, lsl #1
	ldr	r4, [sp, #8]
	add	r2, r7, r2, lsl #4
	str	r2, [sp, #20]
	movs	r2, #48
	muls	r2, r4, r2
	ldr	r4, .L3811+12
	ldr	r3, [r4]
	adds	r5, r7, r2
	ldrb	r2, [r7, r2]	@ zero_extendqisi2
	strb	r2, [r0]
	ldr	r2, [r5, #20]
	cmp	r2, r3
	bcc	.L3756
	mov	r2, #510
	ldr	r1, .L3811+16
	ldr	r0, .L3811+20
	bl	printf
.L3756:
	ldr	r2, [sp, #8]
	movs	r3, #48
	mla	r3, r3, r2, r7
	ldr	r2, [r4]
	ldr	r8, [r3, #20]
	cmp	r8, r2
	bcc	.L3757
	ldr	r0, [sp, #20]
	bl	zbuf_free
	mov	r0, #-1
.L3751:
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3757:
	ldr	r2, [r3, #12]
	ldr	fp, [r3, #4]
	ldrb	r4, [r3, #41]	@ zero_extendqisi2
	ldrb	r3, [r3, #40]	@ zero_extendqisi2
	str	r2, [sp, #12]
	str	r3, [sp, #16]
	ldr	r3, .L3811+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L3759
	ldr	r3, .L3811+28
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	add	r3, r7, r3, lsl #4
.L3760:
	ldrb	r2, [r3]	@ zero_extendqisi2
	cmp	r2, #255
	bne	.L3761
	ldr	r2, [r3, #20]
	cmp	r8, r2
	bne	.L3759
	ldr	r0, [r3, #4]
	lsls	r4, r4, #9
	ldr	r3, [sp, #16]
	add	r1, fp, r4
	add	r0, r0, r4
	lsls	r2, r3, #9
	bl	ftl_memcpy
	ldr	r0, [sp, #20]
	bl	zbuf_free
	b	.L3752
.L3761:
	add	r2, r2, r2, lsl #1
	add	r3, r7, r2, lsl #4
	b	.L3760
.L3759:
	mov	r0, r8
	bl	lpa_hash_get_ppa
	str	r0, [sp, #28]
	adds	r0, r0, #1
	bne	.L3763
	movs	r2, #0
	add	r1, sp, #28
	mov	r0, r8
	bl	pm_log2phys
.L3763:
	ldr	r3, .L3811+32
	ldr	r2, .L3811
	ldr	r6, [r3]
	movs	r3, #0
	adds	r6, r6, #16
.L3766:
	ldr	r1, [r2, #20]
	cmp	r8, r1
	bne	.L3764
	ldrb	r1, [r2, #2]	@ zero_extendqisi2
	lsls	r0, r1, #28
	bpl	.L3764
	movs	r2, #48
	bic	r1, r1, #8
	mla	r3, r2, r3, r7
	strb	r1, [r3, #2]
	ldr	r5, [r3, #4]
	ldr	r3, [r3, #24]
	str	r3, [sp, #28]
.L3765:
	ldr	r10, .L3811+36
	ldr	r2, [sp, #16]
	ldrb	r3, [r10]	@ zero_extendqisi2
	cmp	r2, r3
	bcs	.L3790
	cbz	r5, .L3768
	cbz	r4, .L3769
	lsls	r2, r4, #9
	mov	r1, r5
	mov	r0, fp
	bl	ftl_memcpy
	ldr	r3, .L3811+32
	ldr	r6, [r3]
	adds	r6, r6, #48
.L3769:
	ldr	r3, [sp, #16]
	ldrb	r2, [r10]	@ zero_extendqisi2
	add	r4, r4, r3
	cmp	r4, r2
	bcc	.L3770
	ldr	r3, .L3811+32
	ldr	r6, [r3]
	adds	r6, r6, #16
.L3790:
	mov	r10, #0
	b	.L3767
.L3764:
	adds	r3, r3, #1
	adds	r2, r2, #48
	cmp	r3, #32
	bne	.L3766
	movs	r5, #0
	b	.L3765
.L3770:
	lsls	r0, r4, #9
	subs	r2, r2, r4
	lsls	r2, r2, #9
	adds	r1, r5, r0
	add	r0, r0, fp
	bl	ftl_memcpy
	b	.L3790
.L3812:
	.align	2
.L3811:
	.word	.LANCHOR52
	.word	.LANCHOR60
	.word	.LANCHOR59
	.word	.LANCHOR122
	.word	.LANCHOR221
	.word	.LC0
	.word	.LANCHOR123
	.word	.LANCHOR177
	.word	.LANCHOR10
	.word	.LANCHOR125
.L3768:
	ldr	r3, [sp, #28]
	adds	r3, r3, #1
	beq	.L3771
	movs	r0, #1
	bl	buf_alloc
	ldr	r3, [sp, #28]
	mov	r5, r0
	str	r8, [r0, #20]
	movs	r1, #1
	str	r3, [r0, #24]
	bl	sblk_read_page
	ldr	r3, [r5, #12]
	ldr	r2, [r3, #12]
	ldr	r3, [r3, #4]
	add	r10, r2, #1
	cmp	r8, r3
	bne	.L3772
	ldr	r3, [r5, #36]
	adds	r3, r3, #1
	bne	.L3773
.L3772:
	ldr	r3, .L3813
	ldr	r0, .L3813+4
	ldr	r2, [r3]
	ldr	r3, [r2, #552]
	adds	r3, r3, #1
	str	r3, [r2, #552]
	ldr	r3, [r5, #36]
	ldrb	r1, [r5, #1]	@ zero_extendqisi2
	ldr	r2, [sp, #28]
	str	r3, [sp]
	mov	r3, r8
	bl	printf
	movs	r3, #4
	ldr	r1, [r5, #12]
	mov	r2, r3
	ldr	r0, .L3813+8
	bl	rknand_print_hex
.L3773:
	ldr	r3, [r5, #12]
	ldr	r3, [r3, #4]
	cmp	r8, r3
	bne	.L3774
	ldr	r3, [r5, #36]
	adds	r3, r3, #1
	bne	.L3775
.L3774:
	movw	r2, #581
	ldr	r1, .L3813+12
	ldr	r0, .L3813+16
	bl	printf
.L3775:
	cbz	r4, .L3776
	ldr	r3, [sp, #28]
	lsls	r2, r4, #9
	adds	r3, r3, #1
	beq	.L3777
	ldr	r1, [r5, #4]
	mov	r0, fp
	bl	ftl_memcpy
.L3778:
	ldr	r3, .L3813
	ldr	r6, [r3]
	adds	r6, r6, #48
.L3776:
	ldr	r3, [sp, #16]
	add	r4, r4, r3
	ldr	r3, .L3813+20
	ldrb	r2, [r3]	@ zero_extendqisi2
	cmp	r4, r2
	bcc	.L3779
	bls	.L3780
	ldr	r3, .L3813
	ldr	r6, [r3]
	adds	r6, r6, #16
.L3780:
	cbz	r5, .L3767
	ldrb	r3, [r5, #2]	@ zero_extendqisi2
	mov	r1, r5
	ldr	r0, .L3813+24
	bic	r3, r3, #8
	strb	r3, [r5, #2]
	bl	buf_remove_buf
	mov	r0, r5
	bl	zbuf_free
.L3767:
	ldrh	r3, [r6, #6]
	cbnz	r3, .L3782
	bl	ftl_flush
	mov	r0, r6
	bl	ftl_alloc_new_data_sblk
.L3782:
	mov	r0, r6
	bl	ftl_get_new_free_page
	ldr	r2, [sp, #8]
	movs	r3, #48
	ldr	r4, [sp, #12]
	muls	r3, r2, r3
	adds	r2, r7, r3
	ldr	r1, [r2, #16]
	str	r8, [r4, #4]
	str	r10, [r4, #12]
	str	r1, [r4]
	ldr	r1, [sp, #28]
	str	r1, [r4, #8]
	str	r1, [r2, #28]
	movs	r1, #255
	strb	r1, [r7, r3]
	ldrb	r3, [r2, #2]	@ zero_extendqisi2
	ldrh	r1, [r6, #12]
	str	r0, [r2, #24]
	orr	r3, r3, #10
	ldr	r0, .L3813+28
	strb	r3, [r2, #2]
	ldrh	r3, [r6, #10]
	add	r3, r3, r1
	ldr	r1, [sp, #20]
	subs	r3, r3, #1
	strh	r3, [r2, #32]	@ movhi
	bl	buf_add_tail
	ldr	r2, .L3813+32
	movs	r1, #0
	ldrb	r3, [r2]	@ zero_extendqisi2
	adds	r3, r3, #1
	uxtb	r3, r3
	strb	r3, [r2]
	cmp	r3, #2
	ldr	r2, .L3813+36
	str	r1, [r2]
	ldrh	r2, [r6, #6]
	bhi	.L3783
	cmp	r2, #1
	bne	.L3755
.L3783:
	ldr	r5, .L3813+28
	mov	ip, #48
	ldrb	r1, [r6, #5]	@ zero_extendqisi2
	ldrb	r0, [r5]	@ zero_extendqisi2
	cmp	r1, #0
	mov	r1, #0
	ite	ne
	movne	r4, #2
	moveq	r4, #1
	cmp	r2, #1
	it	eq
	moveq	r4, r3
	mov	r2, r0
.L3787:
	cmp	r1, r4
	bne	.L3788
	strb	r2, [r5]
	uxtb	r1, r1
	ldr	r2, .L3813+32
	add	r0, r0, r0, lsl #1
	subs	r3, r3, r1
	add	r0, r7, r0, lsl #4
	strb	r3, [r2]
	bl	sblk_prog_page
	ldrh	r3, [r6, #6]
	cmp	r3, #1
	bne	.L3755
	bl	sblk_wait_write_queue_completed
	bl	ftl_write_completed
	mov	r0, r6
	bl	ftl_write_last_log_page
	mov	r0, r6
	bl	ftl_alloc_new_data_sblk
.L3755:
	ldr	r3, .L3813+40
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L3752
.L3754:
	bl	ftl_write_completed
	movs	r0, #0
	b	.L3751
.L3779:
	ldr	r3, [sp, #28]
	subs	r2, r2, r4
	lsls	r2, r2, #9
	lsls	r0, r4, #9
	adds	r3, r3, #1
	beq	.L3781
	ldr	r1, [r5, #4]
	add	r1, r1, r0
	add	r0, r0, fp
	bl	ftl_memcpy
	b	.L3780
.L3781:
	movs	r1, #0
	add	r0, r0, fp
	bl	ftl_memset
	b	.L3780
.L3788:
	mul	r2, ip, r2
	adds	r1, r1, #1
	ldrb	r2, [r7, r2]	@ zero_extendqisi2
	b	.L3787
.L3789:
	lsls	r2, r4, #9
	mov	r10, r5
.L3777:
	movs	r1, #0
	mov	r0, fp
	bl	ftl_memset
	b	.L3778
.L3771:
	cmp	r4, #0
	bne	.L3789
	mov	r10, r4
	mov	r5, r4
	b	.L3776
.L3814:
	.align	2
.L3813:
	.word	.LANCHOR10
	.word	.LC237
	.word	.LC195
	.word	.LANCHOR221
	.word	.LC0
	.word	.LANCHOR125
	.word	.LANCHOR131
	.word	.LANCHOR177
	.word	.LANCHOR123
	.word	.LANCHOR222
	.word	.LANCHOR60
	.size	ftl_write_commit, .-ftl_write_commit
	.section	.text.gc_do_copy_back,"ax",%progbits
	.align	1
	.global	gc_do_copy_back
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	gc_do_copy_back, %function
gc_do_copy_back:
	@ args = 0, pretend = 0, frame = 56
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L3959
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #88
	ldrb	r0, [r3]	@ zero_extendqisi2
	cmp	r0, #0
	bne	.L3816
	bl	buf_alloc
	mov	r4, r0
	cmp	r0, #0
	beq	.L3815
	ldr	r6, .L3959+4
	ldrh	r2, [r6, #22]
	mov	r0, r2
	bl	gc_get_src_ppa_from_index
	movs	r1, #1
	adds	r2, r2, #1
	str	r0, [r4, #24]
	mov	r7, r0
	mov	r0, r4
	strh	r2, [r6, #22]	@ movhi
	bl	sblk_read_page
	ldr	r3, [r4, #36]
	adds	r1, r3, #1
	beq	.L3818
	cmp	r3, #512
	bne	.L3819
.L3818:
	movw	r2, #863
	ldr	r1, .L3959+8
	ldr	r0, .L3959+12
	bl	printf
.L3819:
	ldr	r3, [r4, #12]
	ldr	r5, [r3, #4]
	mov	r0, r5
	bl	lpa_hash_get_ppa
	str	r0, [sp, #64]
	adds	r0, r0, #1
	bne	.L3820
	movs	r2, #0
	add	r1, sp, #64
	mov	r0, r5
	bl	pm_log2phys
.L3820:
	ldr	r8, [sp, #64]
	cmp	r7, r8
	bne	.L3821
	ldr	r0, .L3959+16
	movs	r3, #0
.L3824:
	adds	r2, r0, r3
	ldr	r1, [r2, #20]
	cmp	r5, r1
	bne	.L3822
	ldrb	r2, [r2, #2]	@ zero_extendqisi2
	lsls	r2, r2, #30
	bpl	.L3822
	mov	r0, r4
	bl	zbuf_free
	ldr	r3, .L3959+20
	ldr	r3, [r3]
	lsls	r1, r3, #23
	bpl	.L3815
	ldrh	r3, [r6, #22]
	mov	r2, r7
	mov	r1, r5
	ldr	r0, .L3959+24
	bl	printf
.L3815:
	add	sp, sp, #88
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3822:
	adds	r3, r3, #48
	cmp	r3, #1536
	bne	.L3824
	movs	r3, #0
	str	r5, [r4, #20]
	strb	r3, [r4, #41]
	ldr	r3, .L3959+28
	ldrb	r3, [r3]	@ zero_extendqisi2
	strb	r3, [r4, #40]
	ldrb	r3, [r4, #2]	@ zero_extendqisi2
	orr	r3, r3, #10
	strb	r3, [r4, #2]
	ldr	r3, [r4, #12]
	ldr	r3, [r3]
	str	r3, [r4, #16]
	ldr	r3, .L3959+20
	ldr	r3, [r3]
	lsls	r2, r3, #23
	bpl	.L3825
	mov	r0, r5
	bl	lpa_hash_get_ppa
	ldrh	r3, [r6, #22]
	mov	r2, r8
	str	r7, [sp]
	mov	r1, r5
	str	r3, [sp, #4]
	mov	r3, r0
	ldr	r0, .L3959+32
	bl	printf
.L3825:
	mov	r0, r4
	bl	ftl_gc_write_buf
	bl	ftl_write_commit
	ldr	r3, .L3959+36
	ldr	r2, [r3]
	ldr	r3, [r2, #60]
	adds	r3, r3, #1
	str	r3, [r2, #60]
	ldrh	r3, [r6, #24]
	adds	r3, r3, #1
	strh	r3, [r6, #24]	@ movhi
	b	.L3815
.L3821:
	ldr	r3, .L3959+20
	ldr	r3, [r3]
	lsls	r3, r3, #23
	bpl	.L3826
	mov	r0, r5
	bl	lpa_hash_get_ppa
	ldrh	r3, [r6, #22]
	mov	r2, r8
	str	r7, [sp]
	mov	r1, r5
	str	r3, [sp, #4]
	mov	r3, r0
	ldr	r0, .L3959+32
	bl	printf
.L3826:
	mov	r0, r4
	bl	zbuf_free
	b	.L3815
.L3816:
	ldr	r3, .L3959+40
	ldr	r7, .L3959+4
	ldr	r3, [r3]
	str	r3, [sp, #40]
	ldr	r3, .L3959+44
	ldrb	fp, [r3]	@ zero_extendqisi2
	ldr	r3, [sp, #40]
	cmp	fp, #3
	ldrb	r10, [r3, #89]	@ zero_extendqisi2
	bne	.L3827
	ldr	r3, .L3959+48
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L3828
	ldrh	r5, [r7, #566]
	mov	r1, r10
	mov	r0, r5
	bl	__aeabi_idiv
	ldr	r3, .L3959+52
	uxth	r4, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L3829
	ldr	r3, .L3959+56
	ldrh	r3, [r3, r0, lsl #1]
	cmp	r3, #0
	ite	eq
	moveq	fp, #1
	movne	fp, #2
.L3830:
	smulbb	r0, r10, r4
	subs	r0, r5, r0
.L3954:
	uxth	r3, r0
	str	r3, [sp, #32]
.L3831:
	mul	r3, r10, fp
	str	r3, [sp, #44]
	ldr	r3, .L3959+60
	ldrh	r3, [r3]
	mul	r10, r10, r3
	add	r3, r10, #-1
	ldr	r10, .L3959+56
	str	r3, [sp, #48]
	ldr	r3, .L3959+52
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp, #36]
	ldr	r3, .L3959+64
	ldr	r8, [r3]
	ldrh	r3, [r7, #20]
	movs	r7, #0
	str	r3, [sp, #52]
	ldr	r3, .L3959+4
.L3835:
	ldr	r1, [sp, #44]
	uxth	lr, r7
	mov	r2, lr
	cmp	lr, r1
	blt	.L3839
.L3888:
	mov	r8, #1
	b	.L3833
.L3829:
	ldr	r3, .L3959+68
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L3882
	sub	r3, r4, #62
	cmp	r3, #2160
	bcs	.L3883
	mov	r1, fp
	mov	r0, r4
	bl	__aeabi_uidivmod
	uxth	r1, r1
	cmp	r1, #0
	ite	ne
	movne	fp, #1
	moveq	fp, #2
	b	.L3830
.L3882:
	mov	fp, #1
	b	.L3830
.L3883:
	mov	fp, #2
	b	.L3830
.L3828:
	ldr	r3, .L3959+72
	ldrh	r5, [r7, #566]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L3832
	add	r1, r10, r10, lsl #1
	mov	r0, r5
	bl	__aeabi_idiv
	uxth	r4, r0
	sub	r0, r10, r10, lsl #2
	smulbb	r0, r0, r4
	add	r0, r0, r5
	b	.L3954
.L3960:
	.align	2
.L3959:
	.word	.LANCHOR78
	.word	.LANCHOR64
	.word	.LANCHOR223
	.word	.LC0
	.word	.LANCHOR52
	.word	.LANCHOR14
	.word	.LC238
	.word	.LANCHOR125
	.word	.LC239
	.word	.LANCHOR104
	.word	.LANCHOR10
	.word	.LANCHOR73
	.word	.LANCHOR35
	.word	.LANCHOR204
	.word	.LANCHOR224
	.word	.LANCHOR79
	.word	.LANCHOR156
	.word	.LANCHOR205
	.word	.LANCHOR77
.L3832:
	mov	r0, r5
	mov	r1, r10
	bl	__aeabi_idiv
	ldr	r3, .L3961
	ldrh	r8, [r3, r0, lsl #1]
	smulbb	r0, r0, r10
	subs	r5, r5, r0
	lsr	r4, r8, #3
	uxth	r3, r5
	mla	r5, r10, r4, r3
	str	r3, [sp, #32]
	and	r8, r8, #7
	cmp	r8, #1
	add	r5, r5, r5, lsl #1
	uxth	r5, r5
	beq	.L3831
.L3833:
	ldr	r3, .L3961+4
	ldr	r3, [r3]
	lsls	r0, r3, #23
	bpl	.L3840
	ldr	r3, .L3961+8
	mov	r1, r4
	ldr	r2, .L3961+12
	ldr	r0, .L3961+16
	ldr	r3, [r3]
	ldrh	r2, [r2, r4, lsl #1]
	str	r5, [sp, #12]
	str	r2, [sp, #16]
	add	r2, r3, r5, lsl #2
	ldr	r2, [r2, #4]
	str	r2, [sp, #8]
	mov	r2, r8
	ldr	r3, [r3, r5, lsl #2]
	str	r3, [sp, #4]
	ldr	r3, .L3961+20
	ldrh	r3, [r3, #566]
	str	r3, [sp]
	ldr	r3, [sp, #32]
	bl	printf
.L3840:
	movs	r3, #0
.L3956:
	str	r3, [sp, #48]
	ldrh	r3, [sp, #48]
	str	r3, [sp, #44]
	str	r3, [sp, #36]
	ldr	r3, [sp, #40]
	ldr	r1, [sp, #44]
	ldrb	r2, [r3, #89]	@ zero_extendqisi2
	mul	r3, r2, fp
	cmp	r1, r3
	blt	.L3862
	ldr	r1, .L3961+24
	ldrb	r1, [r1]	@ zero_extendqisi2
	cmp	r1, #3
	bne	.L3863
	ldr	r1, .L3961+28
	ldrb	r0, [r1]	@ zero_extendqisi2
	cmp	r0, #0
	beq	.L3864
	movs	r0, #0
	subs	r3, r3, #1
.L3865:
	uxth	r1, r0
	adds	r0, r0, #1
	cmp	r1, r3
	blt	.L3866
.L3957:
	add	r1, sp, #88
	add	r3, r1, r3, lsl #2
	movs	r1, #255
	ldr	r3, [r3, #-24]
	strb	r1, [r3]
	smulbb	r1, fp, r2
	ldr	r0, [sp, #64]
	uxtb	r1, r1
	bl	sblk_prog_page
	b	.L3867
.L3827:
	ldr	r3, .L3961+32
	mov	r1, r10
	ldrh	r5, [r7, #566]
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r0, r5
	cbnz	r3, .L3834
	bl	__aeabi_idiv
	uxth	r4, r0
	mov	fp, #1
	smulbb	r0, r10, r4
	subs	r0, r5, r0
	uxth	r3, r0
	str	r3, [sp, #32]
	b	.L3831
.L3834:
	bl	__aeabi_idiv
	uxth	r4, r0
	mov	fp, #2
	smulbb	r0, r10, r4
	subs	r0, r5, r0
	uxth	r3, r0
	str	r3, [sp, #32]
	b	.L3831
.L3839:
	ldr	r1, [sp, #48]
	add	r2, r2, r5
	cmp	r2, r1
	bne	.L3836
	ldr	r1, [sp, #36]
	cmp	r1, #0
	beq	.L3888
	ldrh	r1, [r10, r4, lsl #1]
	cmp	r1, r4
	bcs	.L3888
	tst	lr, #1
	beq	.L3888
.L3836:
	ldr	r1, [r8, r2, lsl #2]
	adds	r1, r1, #1
	bne	.L3837
	ldrh	r1, [r3, #22]
	ldr	r0, [sp, #52]
	cmp	r1, r0
	bcs	.L3815
	ldr	r0, [sp, #36]
	cbz	r0, .L3838
	ldrh	ip, [r10, r4, lsl #1]
	cmp	ip, r4
	bcs	.L3838
	tst	lr, #1
	beq	.L3838
	ldr	r1, [r8, ip, lsl #2]
	str	r1, [r8, r2, lsl #2]
.L3837:
	adds	r7, r7, #1
	b	.L3835
.L3838:
	mov	r0, r1
	str	r3, [sp, #56]
	bl	gc_get_src_ppa_from_index
	ldr	r3, [sp, #56]
	adds	r1, r1, #1
	strh	r1, [r3, #22]	@ movhi
	str	r0, [r8, r2, lsl #2]
	b	.L3837
.L3962:
	.align	2
.L3961:
	.word	.LANCHOR225
	.word	.LANCHOR14
	.word	.LANCHOR156
	.word	.LANCHOR224
	.word	.LC240
	.word	.LANCHOR64
	.word	.LANCHOR73
	.word	.LANCHOR35
	.word	.LANCHOR74
.L3862:
	ldr	r3, [sp, #44]
	adds	r7, r5, r3
	ldr	r3, .L3963
	ldr	r3, [r3]
	ldrb	r3, [r3, r7]	@ zero_extendqisi2
	cmp	r3, #255
	bne	.L3842
	movs	r0, #0
	bl	buf_alloc
	mov	r6, r0
	cbnz	r0, .L3843
	bl	sblk_wait_write_queue_completed
	bl	ftl_write_completed
	bl	gc_write_completed
	bl	gc_free_temp_buf
	mov	r0, r6
	bl	buf_alloc
	mov	r6, r0
	cmp	r0, #0
	beq	.L3815
.L3843:
	ldr	r3, .L3963
	ldrb	r2, [r6, #1]	@ zero_extendqisi2
	ldr	r3, [r3]
	strb	r2, [r3, r7]
	ldr	r2, .L3963+4
	strb	r8, [r6, #45]
	ldrb	r3, [r2, #7]	@ zero_extendqisi2
	adds	r3, r3, #1
	strb	r3, [r2, #7]
	ldr	r3, [sp, #36]
	add	r3, r3, r5
	strh	r3, [r6, #32]	@ movhi
	ldr	r3, .L3963+8
	ldrh	r2, [r3]
	ldr	r3, [sp, #40]
	ldrb	r3, [r3, #89]	@ zero_extendqisi2
	muls	r3, r2, r3
	subs	r3, r3, #1
	cmp	r7, r3
	bne	.L3844
	ldr	r3, .L3963+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L3845
	ldr	r3, .L3963+16
	ldrh	r3, [r3, r4, lsl #1]
	cmp	r3, r4
	bcs	.L3845
	ldr	r3, [sp, #36]
	lsls	r1, r3, #31
	bmi	.L3844
.L3845:
	ldr	r3, .L3963+20
	ldr	r10, .L3963+40
	ldr	r0, [r6, #4]
	ldr	r1, [r3]
	mov	r3, #-1
	str	r3, [r1, r7, lsl #2]
	ldrb	r3, [r10]	@ zero_extendqisi2
	muls	r2, r3, r2
	lsls	r2, r2, #2
	bl	ftl_memcpy
	ldr	r3, .L3963+8
	ldrb	r2, [r10]	@ zero_extendqisi2
	ldrh	r3, [r3]
	muls	r2, r3, r2
	ldr	r3, .L3963+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	lsls	r2, r2, #2
	mov	r0, r2
	cbz	r3, .L3846
	ldr	r3, .L3963+28
	ldrb	r3, [r3]	@ zero_extendqisi2
	rsb	r2, r2, r3, lsl #9
.L3846:
	ldr	r3, [r6, #4]
	ldr	r1, .L3963+32
	add	r0, r0, r3
	ldr	r1, [r1]
	bl	ftl_memcpy
	ldr	r3, .L3963+28
	movs	r1, #0
	ldr	r0, [r6, #12]
	ldrb	r2, [r3]	@ zero_extendqisi2
	lsls	r2, r2, #1
	bl	ftl_memset
	ldr	r10, [r6, #12]
	ldr	r3, .L3963+36
	ldr	r2, .L3963+40
	ldr	r0, [r6, #4]
	str	r3, [r10]
	ldr	r3, .L3963+8
	ldrb	r1, [r2]	@ zero_extendqisi2
	ldrh	r3, [r3]
	muls	r1, r3, r1
	lsls	r1, r1, #2
	bl	js_hash
	ldr	r3, .L3963+44
	str	r0, [r10, #4]
	ldr	r3, [r3]
	ldr	r3, [r3, #132]
	str	r3, [r10, #8]
.L3842:
	ldr	r3, .L3963
	add	r1, sp, #88
	mov	ip, #48
	ldr	r2, [r3]
	ldr	r3, [sp, #44]
	ldrb	r10, [r2, r7]	@ zero_extendqisi2
	add	r0, r1, r3, lsl #2
	ldr	r1, .L3963+48
	add	r3, r10, r10, lsl #1
	mla	ip, ip, r10, r1
	add	r3, r1, r3, lsl #4
	str	r3, [r0, #-24]
	movs	r3, #2
	strh	r3, [ip, #34]	@ movhi
	ldr	r3, .L3963+52
	strb	r8, [ip, #45]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #3
	bne	.L3853
	ldr	r3, .L3963+56
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L3854
	ldr	r1, .L3963+12
	ldr	r3, [sp, #36]
	ldrb	r1, [r1]	@ zero_extendqisi2
	and	r0, r3, #1
	adds	r3, r0, r4
	cbz	r1, .L3855
	ldr	r1, .L3963+16
	ldrh	r1, [r1, r4, lsl #1]
	cmp	r1, r4
	bcs	.L3855
	cmp	r0, #0
	it	ne
	movne	r3, r1
.L3855:
	ldr	r1, .L3963+48
	movs	r0, #48
	str	r3, [sp, #56]
	str	r2, [sp, #60]
	mla	r3, r0, r10, r1
	ldr	r0, [sp, #36]
	mov	r1, fp
	str	r3, [sp, #52]
	bl	__aeabi_uidiv
	ldr	r3, [sp, #32]
	ldr	r2, [sp, #52]
	uxtah	r0, r3, r0
	ldr	r3, [sp, #40]
	add	r0, r3, r0, lsl #1
	ldr	r3, [sp, #56]
	ldrh	r1, [r0, #96]
	ldr	r0, .L3963+60
	ldrh	r0, [r0]
	mla	r3, r0, r1, r3
	orr	r3, r3, #50331648
	str	r3, [r2, #24]
	ldr	r2, [sp, #60]
.L3859:
	ldr	r1, .L3963+48
	movs	r3, #48
	mla	r3, r3, r10, r1
	ldr	r0, [r3, #24]
	ldrh	r1, [r3, #32]
	ldr	r3, .L3963+64
	ldr	r3, [r3]
	str	r0, [r3, r1, lsl #2]
	b	.L3857
.L3844:
	ldr	r3, .L3963+32
	movs	r1, #1
	mov	r0, r6
	ldr	r3, [r3]
	ldr	r3, [r3, r7, lsl #2]
	str	r3, [r6, #24]
	bl	sblk_read_page
	ldr	r3, [r6, #36]
	adds	r2, r3, #1
	beq	.L3847
	cmp	r3, #512
	bne	.L3851
.L3847:
	ldr	r3, .L3963+68
	ldrh	r2, [r3]
	ldr	r3, .L3963+72
	ldrb	r3, [r3]	@ zero_extendqisi2
	rsb	r3, r3, #24
	subs	r0, r3, r2
	movs	r3, #1
	lsls	r3, r3, r0
	ldr	r0, [r6, #24]
	subs	r3, r3, #1
	lsrs	r0, r0, r2
	ldr	r2, .L3963+76
	ands	r0, r0, r3
	ldrb	r1, [r2]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	movs	r1, #0
	uxth	r0, r0
	bl	ftl_sblk_dump
	ldr	r3, [r6, #36]
	adds	r0, r3, #1
	beq	.L3849
	cmp	r3, #512
	bne	.L3851
.L3849:
	ldr	r3, [r6, #12]
	mov	r2, #-1
	str	r2, [r3, #4]
	ldr	r3, [r6, #36]
	cmp	r3, r2
	beq	.L3850
	cmp	r3, #512
	bne	.L3851
.L3850:
	movw	r2, #1002
	ldr	r1, .L3963+80
	ldr	r0, .L3963+84
	bl	printf
.L3851:
	ldr	r3, [r6, #12]
	ldr	r2, .L3963+88
	ldr	r1, [r3, #4]
	ldr	r2, [r2]
	cmp	r1, r2
	itt	cs
	movcs	r2, #-1
	strcs	r2, [r3, #4]
	ldr	r2, .L3963+20
	ldr	r1, [r3, #4]
	ldr	r2, [r2]
	str	r1, [r2, r7, lsl #2]
	ldr	r2, [r6, #24]
	str	r2, [r3, #8]
	b	.L3842
.L3964:
	.align	2
.L3963:
	.word	.LANCHOR76
	.word	.LANCHOR64
	.word	.LANCHOR79
	.word	.LANCHOR204
	.word	.LANCHOR224
	.word	.LANCHOR155
	.word	.LANCHOR205
	.word	.LANCHOR125
	.word	.LANCHOR156
	.word	-178307901
	.word	.LANCHOR80
	.word	.LANCHOR10
	.word	.LANCHOR52
	.word	.LANCHOR73
	.word	.LANCHOR35
	.word	.LANCHOR105
	.word	.LANCHOR157
	.word	.LANCHOR68
	.word	.LANCHOR31
	.word	.LANCHOR69
	.word	.LANCHOR223
	.word	.LC0
	.word	.LANCHOR122
.L3854:
	ldr	r3, [sp, #36]
	ldr	r0, .L3965
	umull	r0, r1, r3, r0
	ldr	r0, [sp, #40]
	lsrs	r3, r1, #1
	ldr	r1, [sp, #32]
	uxtah	r1, r1, r3
	add	r3, r3, r3, lsl #1
	add	r1, r0, r1, lsl #1
	ldrh	r0, [r1, #96]
	ldr	r1, .L3965+4
	ldrh	r1, [r1]
	muls	r1, r0, r1
	ldr	r0, .L3965+8
	ldr	lr, [r0]
	ldr	r0, [sp, #36]
	orrs	r1, r1, r4
	str	r1, [ip, #24]
	ldrh	ip, [ip, #32]
	subs	r3, r0, r3
	lsls	r3, r3, #24
	add	r3, r3, #16777216
	orrs	r1, r1, r3
	str	r1, [lr, ip, lsl #2]
.L3857:
	ldr	r3, .L3965+12
	ldr	r3, [r3]
	lsls	r1, r3, #23
	bpl	.L3860
	ldr	r1, [r6, #12]
	movs	r0, #48
	ldr	r3, .L3965+16
	ldr	r1, [r1]
	ldrb	r3, [r3, #6]	@ zero_extendqisi2
	str	r1, [sp, #24]
	ldr	r1, .L3965+20
	mla	r10, r0, r10, r1
	ldr	r0, .L3965
	ldr	r1, [r10, #12]
	ldr	r1, [r1, #4]
	str	r1, [sp, #20]
	ldr	r1, [sp, #36]
	umull	r0, r1, r1, r0
	ldr	r0, [sp, #32]
	ubfx	r1, r1, #1, #16
	add	r1, r1, r0
	ldr	r0, .L3965+24
	str	r1, [sp, #16]
	ldrb	r1, [r10, #1]	@ zero_extendqisi2
	str	r1, [sp, #12]
	ldrh	r1, [r10, #32]
	str	r1, [sp, #8]
	ldr	r1, [r10, #24]
	str	r1, [sp, #4]
	ldrb	r2, [r2, r7]	@ zero_extendqisi2
	ldr	r1, [sp, #44]
	str	r2, [sp]
	mov	r2, r8
	bl	printf
.L3860:
	ldr	r3, .L3965+28
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L3861
	ldr	r3, .L3965+32
	ldrh	r3, [r3, r4, lsl #1]
	cmp	r3, r4
	bcs	.L3861
	ldr	r3, [sp, #36]
	lsls	r3, r3, #31
	bpl	.L3861
	ldr	r3, .L3965+36
	movs	r2, #255
	ldr	r3, [r3]
	strb	r2, [r3, r7]
	add	r2, sp, #88
	ldr	r3, [sp, #44]
	add	r3, r2, r3, lsl #2
	ldr	r2, [r3, #-24]
	ldr	r3, [sp, #40]
	ldrb	r1, [r2, #1]	@ zero_extendqisi2
	ldrb	r3, [r3, #89]	@ zero_extendqisi2
	lsls	r3, r3, #1
	mls	r3, r3, fp, r5
	uxth	r3, r3
	strh	r3, [r2, #32]	@ movhi
	ldr	r2, .L3965+36
	ldr	r2, [r2]
	strb	r1, [r2, r3]
	mov	r2, #-1
	ldr	r3, .L3965+40
	ldr	r3, [r3]
	str	r2, [r3, r7, lsl #2]
.L3861:
	ldr	r3, [sp, #48]
	adds	r3, r3, #1
	b	.L3956
.L3853:
	cmp	r3, #2
	bne	.L3859
	ldr	r3, .L3965+44
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L3858
	ldr	r1, [sp, #32]
	ldr	r3, [sp, #44]
	add	r3, r3, r1
	ldr	r1, [sp, #40]
	add	r3, r1, r3, lsl #1
	ldr	r1, .L3965+4
	ldrh	r3, [r3, #96]
	ldrh	r1, [r1]
	mla	r3, r1, r3, r4
.L3955:
	orr	r3, r3, #33554432
	str	r3, [ip, #24]
	b	.L3859
.L3858:
	ldr	r1, [sp, #36]
	ldr	r3, [sp, #32]
	add	r3, r3, r1, lsr #1
	ldr	r1, [sp, #40]
	add	r3, r1, r3, lsl #1
	ldr	r1, .L3965+4
	ldrh	r3, [r3, #96]
	ldrh	r1, [r1]
	mla	r3, r1, r3, r4
	ldr	r1, [sp, #36]
	and	r1, r1, #1
	add	r3, r3, r1
	b	.L3955
.L3866:
	add	r5, sp, #88
	add	r6, sp, #88
	add	r5, r5, r1, lsl #2
	add	r1, r6, r1, lsl #2
	ldr	r1, [r1, #-20]
	ldr	r5, [r5, #-24]
	ldrb	r1, [r1, #1]	@ zero_extendqisi2
	strb	r1, [r5]
	b	.L3865
.L3864:
	ldr	r3, .L3965+48
	ldrb	r1, [r3]	@ zero_extendqisi2
	ldr	r3, [sp, #64]
	cmp	r1, #0
	beq	.L3868
	strb	r0, [r3, #44]
.L3958:
	add	r1, sp, #76
	add	r0, sp, #64
	bl	sblk_xlc_prog_pages
.L3867:
	ldr	r3, .L3965+48
	ldrb	r2, [r3]	@ zero_extendqisi2
	ldr	r3, [sp, #40]
	ldrb	r3, [r3, #89]	@ zero_extendqisi2
	cmp	r2, #0
	beq	.L3876
	add	r3, r3, r3, lsl #1
.L3877:
	ldr	r2, .L3965+52
	ldr	r1, [r2]
	ldr	r2, [r1, #52]
	add	r2, r2, r3
	str	r2, [r1, #52]
	ldr	r2, .L3965+16
	ldrh	r1, [r2, #566]
	add	r3, r3, r1
	uxth	r3, r3
	strh	r3, [r2, #566]	@ movhi
	ldr	r2, .L3965+56
	ldrh	r1, [r2]
	ldr	r2, [sp, #40]
	ldrb	r2, [r2, #89]	@ zero_extendqisi2
	muls	r2, r1, r2
	cmp	r3, r2
	itttt	ge
	ldrge	r3, .L3965+60
	movge	r2, #0
	ldrge	r3, [r3]
	strhge	r2, [r3, #86]	@ movhi
	bl	gc_write_completed
	b	.L3815
.L3868:
	cmp	r8, #1
	bne	.L3869
	movs	r1, #9
.L3871:
	strb	r1, [r3, #44]
	b	.L3958
.L3869:
	cmp	r8, #2
	it	eq
	moveq	r1, #13
	b	.L3871
.L3863:
	ldr	r1, .L3965+44
	ldrb	r0, [r1]	@ zero_extendqisi2
	cbz	r0, .L3872
	ldr	r1, .L3965+64
	ldrb	r0, [r1]	@ zero_extendqisi2
	cbnz	r0, .L3873
.L3872:
	subs	r3, r3, #1
.L3874:
	uxth	r1, r0
	adds	r0, r0, #1
	cmp	r1, r3
	bge	.L3957
	add	r5, sp, #88
	add	r6, sp, #88
	add	r5, r5, r1, lsl #2
	add	r1, r6, r1, lsl #2
	ldr	r1, [r1, #-20]
	ldr	r5, [r5, #-24]
	ldrb	r1, [r1, #1]	@ zero_extendqisi2
	strb	r1, [r5]
	b	.L3874
.L3873:
	mov	r1, r2
	add	r0, sp, #64
	bl	sblk_3d_mlc_prog_pages
	b	.L3867
.L3876:
	ldr	r2, .L3965+44
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbz	r2, .L3878
	lsls	r3, r3, #1
	b	.L3877
.L3878:
	ldr	r2, .L3965+68
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbz	r2, .L3879
	ldr	r1, .L3965+28
	uxth	r2, r3
	mul	r3, r2, fp
	ldrb	r1, [r1]	@ zero_extendqisi2
	cmp	r1, #0
	beq	.L3877
	ldr	r1, .L3965+32
	ldrh	r1, [r1, r4, lsl #1]
	cmp	r1, r4
	it	cc
	movcc	r3, r2
	b	.L3877
.L3879:
	uxth	r3, r3
	b	.L3877
.L3966:
	.align	2
.L3965:
	.word	-1431655765
	.word	.LANCHOR105
	.word	.LANCHOR157
	.word	.LANCHOR14
	.word	.LANCHOR64
	.word	.LANCHOR52
	.word	.LC241
	.word	.LANCHOR204
	.word	.LANCHOR224
	.word	.LANCHOR76
	.word	.LANCHOR156
	.word	.LANCHOR74
	.word	.LANCHOR77
	.word	.LANCHOR104
	.word	.LANCHOR79
	.word	.LANCHOR10
	.word	.LANCHOR75
	.word	.LANCHOR35
	.size	gc_do_copy_back, .-gc_do_copy_back
	.section	.text.zftl_do_gc,"ax",%progbits
	.align	1
	.global	zftl_do_gc
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	zftl_do_gc, %function
zftl_do_gc:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L4148
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #48
	ldr	r4, .L4148+4
	ldrh	r7, [r3]
	ldr	r3, .L4148+8
	ldr	r2, .L4148+12
	str	r0, [sp, #32]
	ldrh	r6, [r3]
	ldrb	r3, [r4]	@ zero_extendqisi2
	mov	r8, r2
	ldr	r5, [r2]
	add	r6, r6, r7
	uxth	r6, r6
	cmp	r3, #6
	bhi	.L4077
	tbh	[pc, r3, lsl #1]
.L3970:
	.2byte	(.L3969-.L3970)/2
	.2byte	(.L3971-.L3970)/2
	.2byte	(.L3972-.L3970)/2
	.2byte	(.L3973-.L3970)/2
	.2byte	(.L3974-.L3970)/2
	.2byte	(.L3975-.L3970)/2
	.2byte	(.L3976-.L3970)/2
	.p2align 1
.L3975:
	ldr	r5, .L4148+16
	movs	r7, #0
.L3977:
	bl	gc_check_data_one_wl
	mov	r10, r0
	cmp	r0, #0
	beq	.L4073
	ldr	r3, [r8]
	movs	r6, #0
	strh	r6, [r5, #52]	@ movhi
	ldrh	r0, [r3, #80]
	bl	ftl_free_sblk
	ldr	r1, .L4148+20
	movw	r3, #65535
	ldr	r2, [r8]
	ldr	r0, [r5, #8]
	ldr	r1, [r1]
	strh	r3, [r2, #80]	@ movhi
	strh	r3, [r1, #126]	@ movhi
	strh	r3, [r2, #130]	@ movhi
	bl	zbuf_free
	str	r6, [r5, #8]
	strb	r6, [r4]
	b	.L4145
.L3969:
	ldr	r3, .L4148+24
	ldr	r1, .L4148+28
	ldr	r2, .L4148+32
	ldrh	r3, [r3]
	str	r1, [sp, #36]
	ldrh	r0, [r2]
	add	r7, r7, r3
	ldrh	r3, [r1]
	uxth	r7, r7
	str	r2, [sp, #40]
	add	r3, r3, r0
	ldrh	r0, [r5, #80]
	uxth	r3, r3
	str	r3, [sp, #28]
	movw	r3, #65535
	cmp	r0, r3
	beq	.L3978
	ldr	r3, [sp, #32]
	cbnz	r3, .L3979
	ldr	r3, .L4148+36
	ldrh	r3, [r3]
	cmp	r6, r3, lsl #1
	blt	.L3979
.L4077:
	movs	r5, #16
	b	.L3967
.L3979:
	ldr	r10, .L4148+84
	movs	r1, #5
	ldr	fp, .L4148+72
	ldrh	r0, [r10]
	adds	r0, r0, #1
	uxth	r0, r0
	strh	r0, [r10]	@ movhi
	bl	zftl_get_gc_node
	movw	r3, #65535
	mov	ip, r10
	cmp	r0, r3
	beq	.L3980
	ldr	r1, .L4148+40
	ldr	lr, .L4148+80
	ldr	r2, .L4148+44
	ldr	r1, [r1]
	ldrh	lr, [lr]
	ldr	r3, [r2]
	mov	r10, r2
	ldrh	r1, [r1, r0, lsl #1]
	adds	r3, r3, #1
	cmp	lr, r1
	str	r3, [r2]
	bcs	.L3981
	ldr	r2, .L4148+48
	ldrh	r2, [r2]
	cmp	r3, r2, lsr #4
	bls	.L3980
	ldr	r3, .L4148+52
	ldrh	r3, [r3]
	cmp	r3, r1
	bls	.L3980
.L3981:
	ldrb	r2, [fp]	@ zero_extendqisi2
	movs	r1, #0
	bl	gc_add_sblk
	cbz	r0, .L3982
	movs	r3, #1
	strb	r3, [r4]
	movs	r3, #0
	str	r3, [r10]
	b	.L4077
.L3980:
	movs	r3, #0
	strh	r3, [ip]	@ movhi
.L3982:
	cmp	r7, #15
	bls	.L4079
	ldr	r3, .L4148+56
	ldrh	r2, [r3]
	ldr	r3, .L4148+60
	ldrh	r3, [r3]
	cmp	r2, r3
	bhi	.L4079
	ldr	r3, [sp, #28]
	cmp	r3, #0
	ite	eq
	moveq	r10, #2
	movne	r10, #1
.L3983:
	ldr	r3, .L4148+64
	ldr	r3, [r3]
	lsls	r3, r3, #23
	bpl	.L3984
	ldr	r3, [r8]
	ldrh	r1, [r5, #80]
	ldrb	r2, [fp]	@ zero_extendqisi2
	ldr	r0, .L4148+68
	str	r1, [sp, #16]
	ldrh	r1, [r3, #122]
	str	r1, [sp, #12]
	ldrh	r1, [r3, #120]
	str	r1, [sp, #8]
	movw	r1, #2170
	ldrh	r3, [r3, #124]
	str	r7, [sp]
	str	r3, [sp, #4]
	mov	r3, r6
	bl	printf
.L3984:
	movs	r2, #1
	mov	r1, r10
	ldrb	r0, [fp]	@ zero_extendqisi2
	bl	gc_search_src_blk
	cmp	r0, #0
	ble	.L3985
.L3986:
	movs	r3, #1
.L4146:
	strb	r3, [r4]
	b	.L4077
.L4079:
	mov	r10, #2
	b	.L3983
.L3985:
	movs	r2, #1
	movs	r1, #3
	ldrb	r0, [fp]	@ zero_extendqisi2
	bl	gc_search_src_blk
	cmp	r0, #0
	bgt	.L3986
	b	.L4077
.L3978:
	ldr	r3, .L4148+64
	ldr	r2, [r3]
	str	r3, [sp, #44]
	tst	r2, #256
	beq	.L3988
	ldr	r3, .L4148+72
	movw	r1, #2182
	ldr	r0, .L4148+68
	ldrb	r2, [r3]	@ zero_extendqisi2
	ldr	r3, [sp, #32]
	str	r3, [sp, #16]
	ldrh	r3, [r5, #122]
	str	r3, [sp, #12]
	ldrh	r3, [r5, #120]
	str	r3, [sp, #8]
	ldrh	r3, [r5, #124]
	str	r7, [sp]
	str	r3, [sp, #4]
	mov	r3, r6
	bl	printf
.L3988:
	ldr	r3, [sp, #32]
	cmp	r3, #1
	bne	.L3989
	bl	gc_scan_static_data
	ldr	r3, [r8]
	ldr	fp, .L4148+72
	ldrh	r3, [r3, #122]
	cbz	r3, .L3990
.L3991:
	movs	r3, #1
	strb	r3, [fp]
	b	.L4146
.L3990:
	bl	gc_static_wearleveling
	mov	r5, r0
	cmp	r0, #0
	bne	.L3991
	cmp	r7, #0
	bne	.L3992
.L3996:
	movs	r5, #16
.L3993:
	ldr	r0, [r8]
	movs	r1, #1
	ldr	r3, .L4148+72
	ldrh	fp, [r0, #124]
	strb	r1, [r3]
	mov	r8, r3
	cmp	fp, #0
	beq	.L4001
	movs	r2, #0
	strb	r1, [r4]
	strb	r2, [r3]
	ldr	r3, [sp, #44]
	ldr	r3, [r3]
	lsls	r4, r3, #23
	bpl	.L3967
	ldrh	r3, [r0, #122]
	mov	r1, #2272
	str	r3, [sp, #12]
	ldrh	r3, [r0, #120]
	stm	sp, {r7, fp}
	ldr	r0, .L4148+76
	str	r3, [sp, #8]
	mov	r3, r6
	bl	printf
.L3967:
	mov	r0, r5
	add	sp, sp, #48
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L4149:
	.align	2
.L4148:
	.word	.LANCHOR101
	.word	.LANCHOR153
	.word	.LANCHOR97
	.word	.LANCHOR10
	.word	.LANCHOR64
	.word	.LANCHOR104
	.word	.LANCHOR99
	.word	.LANCHOR92
	.word	.LANCHOR90
	.word	.LANCHOR81
	.word	.LANCHOR9
	.word	.LANCHOR154
	.word	.LANCHOR6
	.word	.LANCHOR93
	.word	.LANCHOR94
	.word	.LANCHOR95
	.word	.LANCHOR14
	.word	.LC242
	.word	.LANCHOR78
	.word	.LC243
	.word	.LANCHOR87
	.word	.LANCHOR89
.L3992:
	ldr	r3, [sp, #28]
	ldr	r2, .L4150
	cmp	r6, r3
	bcs	.L3994
	ldrh	r3, [r2]
	cmp	r3, r6
	bhi	.L3995
.L3994:
	ldr	r3, [sp, #28]
	ldrh	r2, [r2]
	adds	r3, r6, r3
	cmp	r3, r2
	blt	.L3995
	ldr	r3, .L4150+4
	ldrh	r2, [r3]
	ldr	r3, .L4150+8
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L3996
.L3995:
	mov	r10, #1
	ldr	r2, .L4150+12
	strb	r10, [fp]
	ldr	fp, .L4150+32
	ldrh	r2, [r2]
	ldr	r3, [fp]
	add	r3, r3, r10
	cmp	r3, r2, lsr #5
	str	r3, [fp]
	ldr	r3, .L4150+4
	bls	.L3997
	ldrh	r2, [r3]
	cmp	r2, r7
	bls	.L3997
	movs	r1, #5
	movs	r0, #0
	bl	zftl_get_gc_node
	movw	r3, #65535
	cmp	r0, r3
	beq	.L3996
	ldr	r3, .L4150+16
	ldr	r3, [r3]
	ldrh	r2, [r3, r0, lsl #1]
	ldr	r3, .L4150+20
	ldrh	r1, [r3]
	ldr	r3, .L4150+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	muls	r3, r1, r3
	cmp	r2, r3
	bgt	.L3996
	movs	r2, #4
	movs	r1, #2
	mov	r0, r10
	movs	r3, #0
	str	r3, [fp]
.L4136:
	bl	gc_search_src_blk
	uxth	r0, r0
	cmp	r0, #0
	beq	.L3996
	b	.L3986
.L3997:
	ldrh	r2, [r3]
	ldr	r3, .L4150+8
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L3999
	movs	r2, #1
	movs	r1, #2
	mov	r0, r2
	b	.L4136
.L3999:
	ldr	r3, [sp, #36]
	ldrh	r3, [r3]
	cbnz	r3, .L4000
	ldr	r3, [sp, #40]
	ldrh	r3, [r3]
	cmp	r3, #8
	bls	.L3993
.L4000:
	movs	r1, #1
	movs	r2, #4
	mov	r0, r1
	b	.L4136
.L3989:
	ldr	r3, .L4150+28
	ldrh	r3, [r3]
	cmp	r3, r6
	bcc	.L4077
	b	.L3996
.L4001:
	ldr	r2, .L4150+28
	ldrh	ip, [r2]
	mov	r10, r2
	cmp	r6, ip
	bcs	.L4002
	cmp	r7, #0
	beq	.L4003
	cmp	r7, #16
	bls	.L4004
	ldr	r2, .L4150+4
	ldrh	r0, [r2]
	ldr	r2, .L4150+8
	ldrh	r2, [r2]
	cmp	r0, r2
	bhi	.L4004
	movs	r2, #4
	mov	r0, r1
	str	r3, [sp, #28]
	bl	gc_search_src_blk
	uxth	r0, r0
	ldr	r3, [sp, #28]
	cbnz	r0, .L4005
	ldrb	r0, [r3]	@ zero_extendqisi2
	movs	r2, #4
	movs	r1, #3
.L4142:
	bl	gc_search_src_blk
	uxth	r0, r0
.L4006:
	cbnz	r0, .L4008
	b	.L3967
.L4005:
	movs	r1, #5
	mov	r0, fp
	bl	zftl_get_gc_node
	movw	r3, #65535
	cmp	r0, r3
	beq	.L4008
	ldr	r1, .L4150+16
	ldr	r6, .L4150+20
	ldr	r2, .L4150+32
	ldr	r1, [r1]
	ldrh	r6, [r6]
	ldr	r3, [r2]
	ldrh	r1, [r1, r0, lsl #1]
	adds	r3, r3, #1
	cmp	r6, r1
	str	r3, [r2]
	mov	r6, r2
	bcs	.L4009
	ldr	r2, .L4150+12
	ldrh	r2, [r2]
	cmp	r3, r2, lsr #4
	bls	.L4008
	ldr	r3, .L4150+36
	ldrh	r3, [r3]
	cmp	r3, r1
	bls	.L4008
.L4009:
	ldrb	r2, [r8]	@ zero_extendqisi2
	movs	r1, #0
	bl	gc_add_sblk
	ldr	r3, .L4150+40
	movs	r2, #1
	str	r2, [r3]
	movs	r3, #0
	str	r3, [r6]
.L4008:
	movs	r3, #1
	strb	r3, [r4]
	b	.L3967
.L4004:
	movs	r2, #1
	movs	r1, #2
	mov	r0, r2
.L4144:
	bl	gc_search_src_blk
	uxth	r0, r0
	cmp	r0, #0
	bne	.L4008
	movs	r2, #2
	b	.L4138
.L4003:
	strb	r7, [r3]
	ldr	r3, [sp, #44]
	ldr	r3, [r3]
	lsls	r1, r3, #23
	bpl	.L4011
	ldrh	r3, [r0, #122]
	mov	r2, r7
	movw	r1, #2302
	str	r3, [sp, #12]
	ldrh	r3, [r0, #120]
	str	r7, [sp, #4]
	str	r7, [sp]
	str	r3, [sp, #8]
	mov	r3, r6
	ldr	r0, .L4150+44
	bl	printf
.L4011:
	cmp	r6, #16
	bls	.L4012
	movs	r2, #4
.L4138:
	movs	r1, #3
	ldrb	r0, [r8]	@ zero_extendqisi2
	b	.L4142
.L4012:
	movs	r2, #1
	ldrb	r0, [r8]	@ zero_extendqisi2
	mov	r1, r2
	b	.L4144
.L4002:
	ldr	r3, [sp, #32]
	cmp	r3, #1
	bne	.L3967
	cmp	r6, ip, lsl #1
	bge	.L4013
	ldr	r3, [sp, #28]
	cmp	r3, r7, lsr #1
	bcs	.L4014
	ldr	r3, .L4150+4
	ldrh	r1, [r3]
	ldr	r3, .L4150+8
	ldrh	r3, [r3]
	cmp	r1, r3
	bcs	.L4014
	ldr	r3, .L4150
	ldrh	r3, [r3]
	lsrs	r3, r3, #2
	strh	r3, [r2]	@ movhi
	b	.L3967
.L4014:
	movs	r1, #5
	movs	r0, #0
	bl	zftl_get_gc_node
	movw	r3, #65535
	mov	fp, r0
	cmp	r0, r3
	bne	.L4015
.L4020:
	cmp	r7, #1
	bhi	.L4016
.L4017:
	ldr	r3, [sp, #28]
	cmp	r6, r3
	ldr	r6, .L4150
	bcs	.L4024
	movs	r7, #0
	movs	r0, #4
	strb	r7, [r8]
	bl	zftl_get_gc_node.part.9
	movw	r3, #65535
	cmp	r0, r3
	beq	.L4024
	ldr	r3, .L4150+16
	ldr	r3, [r3]
	ldrh	r2, [r3, r0, lsl #1]
	ldr	r3, .L4150+20
	ldrh	r1, [r3]
	ldr	r3, .L4150+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	muls	r3, r1, r3
	cmp	r2, r3, asr #1
	ble	.L4026
.L4024:
	ldrh	r3, [r6]
	lsrs	r3, r3, #2
	strh	r3, [r10]	@ movhi
	b	.L3967
.L4015:
	ldr	r2, .L4150+32
	ldr	r1, .L4150+12
	ldr	r3, [r2]
	ldrh	r1, [r1]
	adds	r3, r3, #1
	str	r3, [r2]
	cmp	r3, r1, lsr #4
	ldr	r3, .L4150+16
	bls	.L4018
	movs	r1, #0
	str	r1, [r2]
	ldr	r2, [r3]
	ldrh	ip, [r2, r0, lsl #1]
	ldr	r2, .L4150+36
	ldrh	r2, [r2]
	cmp	ip, r2
	bcs	.L4018
	movs	r2, #1
	str	r3, [sp, #32]
	bl	gc_add_sblk
	ldr	r3, [sp, #32]
	cmp	r0, #0
	bne	.L4008
.L4018:
	ldr	r3, [r3]
	ldrh	r2, [r3, fp, lsl #1]
	ldr	r3, .L4150+20
	ldrh	r3, [r3]
	cmp	r2, r3, lsr #1
	bhi	.L4019
	movs	r2, #0
	movs	r1, #1
	mov	r0, fp
	bl	gc_add_sblk
	b	.L4008
.L4019:
	ldr	r3, [sp, #36]
	ldr	r1, [sp, #40]
	ldrh	r3, [r3]
	ldrh	r1, [r1]
	add	r3, r3, r1
	ldr	r1, .L4150
	ldrh	r1, [r1]
	cmp	r3, r1, lsl #1
	ble	.L4020
	ldr	r3, .L4150+36
	ldrh	r3, [r3]
	cmp	r3, r2
	bcc	.L4017
	b	.L4020
.L4151:
	.align	2
.L4150:
	.word	.LANCHOR91
	.word	.LANCHOR94
	.word	.LANCHOR95
	.word	.LANCHOR6
	.word	.LANCHOR9
	.word	.LANCHOR87
	.word	.LANCHOR80
	.word	.LANCHOR81
	.word	.LANCHOR154
	.word	.LANCHOR93
	.word	.LANCHOR116
	.word	.LC243
.L4016:
	cmp	r7, #16
	mov	r1, #1
	strb	r1, [r8]
	bls	.L4021
	ldr	r3, .L4152
	ldrh	r2, [r3]
	ldr	r3, .L4152+4
	ldrh	r3, [r3]
	cmp	r2, r3
	bhi	.L4021
	movs	r2, #4
	mov	r0, r1
	bl	gc_search_src_blk
	uxth	r0, r0
	cbnz	r0, .L4022
	movs	r2, #4
.L4137:
	movs	r1, #3
	ldrb	r0, [r8]	@ zero_extendqisi2
	bl	gc_search_src_blk
	uxth	r0, r0
.L4022:
	ldr	r3, [sp, #28]
	cmp	r6, r3, lsr #1
	ldr	r3, .L4152+8
	ldrh	r3, [r3]
	bls	.L4140
	lsrs	r3, r3, #2
.L4141:
	strh	r3, [r10]	@ movhi
	b	.L4006
.L4021:
	movs	r2, #1
	movs	r1, #2
	mov	r0, r2
	bl	gc_search_src_blk
	uxth	r0, r0
	cmp	r0, #0
	bne	.L4022
	movs	r2, #2
	b	.L4137
.L4026:
	movs	r2, #4
	movs	r1, #3
	mov	r0, r7
	bl	gc_search_src_blk
	ldrh	r3, [r6]
	uxth	r0, r0
.L4140:
	lsrs	r3, r3, #1
	b	.L4141
.L4013:
	ldr	r3, .L4152+8
	mov	r5, fp
	ldrh	r3, [r3]
	lsrs	r3, r3, #2
	strh	r3, [r2]	@ movhi
	b	.L3967
.L3971:
	ldr	r5, .L4152+12
	movw	r3, #65535
	ldrh	r2, [r5]
	cmp	r2, r3
	bne	.L4027
	bl	gc_get_src_blk
	strh	r0, [r5]	@ movhi
.L4027:
	ldrh	r2, [r5]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L4028
	ldr	r1, .L4152+16
	ldrh	r1, [r1]
	cmp	r1, r2
	it	ls
	strhls	r3, [r5]	@ movhi
.L4028:
	ldrh	r6, [r5]
	movw	r3, #65535
	cmp	r6, r3
	beq	.L4147
	ldr	r3, .L4152+20
	ldrh	r1, [r5, #52]
	ldr	r3, [r3]
	add	r3, r3, r6, lsl #2
	cbz	r1, .L4030
	ldr	r0, .L4152+24
	movs	r2, #0
.L4031:
	uxth	r5, r2
	cmp	r1, r5
	bhi	.L4032
.L4030:
	ldrb	r3, [r3, #2]	@ zero_extendqisi2
	and	r2, r3, #224
	cmp	r2, #224
	beq	.L4033
	tst	r3, #192
	bne	.L4034
.L4033:
	ldr	r3, .L4152+28
	ldr	r3, [r3]
	ldrh	r3, [r3, r6, lsl #1]
	cbz	r3, .L4036
	movw	r2, #2537
	ldr	r1, .L4152+32
	ldr	r0, .L4152+36
	bl	printf
	b	.L4036
.L4032:
	ldrh	r5, [r0, #2]!
	adds	r2, r2, #1
	cmp	r5, r6
	bne	.L4031
.L4036:
	ldr	r3, .L4152+12
	movw	r2, #65535
	strh	r2, [r3]	@ movhi
	b	.L4077
.L4034:
	movs	r3, #2
	b	.L4146
.L3972:
	bl	gc_scan_src_blk
	adds	r0, r0, #1
	bne	.L4037
	movs	r3, #3
	b	.L4146
.L4037:
	ldr	r3, .L4152+12
	movw	r1, #65535
	ldrh	r2, [r3]
	mov	r5, r3
	cmp	r2, r1
	beq	.L3986
	ldrh	r1, [r3, #20]
	cbz	r1, .L4038
	movs	r2, #4
	strb	r2, [r4]
	movs	r2, #0
	strh	r2, [r3, #22]	@ movhi
	b	.L4077
.L4038:
	movs	r3, #1
	strb	r3, [r4]
	ldr	r4, .L4152+28
	ldr	r1, [r4]
	ldrh	r2, [r1, r2, lsl #1]
	cbz	r2, .L4039
	movw	r2, #2565
	ldr	r1, .L4152+32
	ldr	r0, .L4152+36
	bl	printf
.L4039:
	ldrh	r0, [r5]
	bl	ftl_free_sblk
	ldr	r3, [r4]
	movs	r4, #0
	ldrh	r2, [r5]
	strh	r4, [r3, r2, lsl #1]	@ movhi
	ldrh	r3, [r5, #26]
	adds	r3, r3, #1
	uxth	r3, r3
	cmp	r3, #8
	bhi	.L4040
	strh	r3, [r5, #26]	@ movhi
	b	.L4036
.L4040:
	strh	r4, [r5, #26]	@ movhi
	bl	ftl_flush
	bl	pm_flush
	bl	ftl_ext_info_flush
	mov	r0, r4
	bl	ftl_info_flush
	b	.L4036
.L3973:
	ldr	r7, .L4152+12
	mov	r5, r7
.L4116:
	bl	gc_scan_src_blk_one_page
	ldr	r3, .L4152+40
	ldrh	r2, [r7, #2]
	ldrh	r3, [r3]
	cmp	r2, r3
	bcs	.L4042
	cmp	r6, #7
	bls	.L4116
	b	.L4077
.L4042:
	ldrh	r3, [r7, #20]
	ldr	r2, .L4152+44
	cbz	r3, .L4043
	ldr	r2, [r2]
	movs	r1, #4
	strb	r1, [r4]
	movs	r1, #0
	strh	r1, [r7, #22]	@ movhi
	tst	r2, #256
	ldr	r4, .L4152+28
	beq	.L4044
	ldrh	r1, [r7]
	ldr	r2, [r4]
	ldr	r0, .L4152+48
	ldrh	r2, [r2, r1, lsl #1]
	bl	printf
.L4044:
	ldr	r3, [r4]
	ldrh	r2, [r5]
	ldrh	r2, [r3, r2, lsl #1]
	ldrh	r3, [r5, #20]
	cmp	r2, r3
	beq	.L4045
	movw	r2, #2599
	ldr	r1, .L4152+32
	ldr	r0, .L4152+36
	bl	printf
.L4045:
	ldrh	r1, [r5, #20]
	ldrh	r2, [r5]
	ldr	r3, [r4]
	strh	r1, [r3, r2, lsl #1]	@ movhi
	b	.L4077
.L4043:
	ldr	r3, .L4152+20
	ldrh	r1, [r7]
	ldr	r6, [r3]
	movs	r3, #1
	strb	r3, [r4]
	ldr	r3, [r2]
	add	r6, r6, r1, lsl #2
	lsls	r2, r3, #23
	bpl	.L4046
	ldrb	r2, [r6, #2]	@ zero_extendqisi2
	ldr	r0, .L4152+52
	lsrs	r2, r2, #5
	bl	printf
.L4046:
	ldrb	r3, [r6, #2]	@ zero_extendqisi2
	and	r2, r3, #224
	cmp	r2, #224
	beq	.L4047
	tst	r3, #192
	bne	.L4048
.L4047:
	movw	r2, #2609
	ldr	r1, .L4152+32
	ldr	r0, .L4152+36
	bl	printf
.L4048:
	ldrh	r0, [r5]
	bl	ftl_free_sblk
	movw	r3, #65535
	strh	r3, [r5]	@ movhi
	ldrh	r3, [r5, #26]
	adds	r3, r3, #1
	uxth	r3, r3
	cmp	r3, #8
	bhi	.L4049
	strh	r3, [r5, #26]	@ movhi
	b	.L4077
.L4049:
	movs	r3, #0
	strh	r3, [r5, #26]	@ movhi
.L4145:
	bl	flt_sys_flush
	b	.L4077
.L4153:
	.align	2
.L4152:
	.word	.LANCHOR94
	.word	.LANCHOR95
	.word	.LANCHOR91
	.word	.LANCHOR64
	.word	.LANCHOR6
	.word	.LANCHOR7
	.word	.LANCHOR64+52
	.word	.LANCHOR9
	.word	.LANCHOR226
	.word	.LC0
	.word	.LANCHOR87
	.word	.LANCHOR14
	.word	.LC244
	.word	.LC245
.L3974:
	ldrh	r2, [r5, #80]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L4050
	ldr	r3, .L4154
	ldrb	r7, [r3]	@ zero_extendqisi2
	cmp	r7, #1
	bne	.L4050
	ldr	r6, .L4154+4
	bl	ftl_flush
	movs	r1, #5
	ldrh	r0, [r6, #570]
	cbz	r0, .L4051
	mov	r0, r7
.L4051:
	bl	zftl_gc_get_free_sblk
	movw	r3, #65535
	mov	r4, r0
	cmp	r0, r3
	beq	.L4053
	ldr	r3, .L4154+8
	ldr	r7, [r3]
	add	r7, r7, r0, lsl #2
	ldrb	r3, [r7, #2]	@ zero_extendqisi2
	tst	r3, #224
	beq	.L4054
	movw	r2, #2638
	ldr	r1, .L4154+12
	ldr	r0, .L4154+16
	bl	printf
.L4054:
	ldrb	r3, [r7, #2]	@ zero_extendqisi2
	and	r3, r3, #15
	orr	r3, r3, #176
	strb	r3, [r7, #2]
.L4076:
	movs	r1, #1
	mov	r0, r4
	bl	ftl_erase_sblk
	movs	r3, #5
	add	r1, r5, #96
	strb	r3, [r5, #84]
	mov	r0, r4
	bl	ftl_get_blk_list_in_sblk
	ldr	r3, .L4154+20
	uxtb	r0, r0
	movs	r7, #0
	ldr	r10, .L4154+60
	strb	r0, [r5, #89]
	movs	r1, #255
	ldrh	r3, [r3]
	strh	r4, [r5, #80]	@ movhi
	strh	r7, [r5, #82]	@ movhi
	strb	r7, [r5, #85]
	smulbb	r0, r3, r0
	strh	r7, [r5, #90]	@ movhi
	ldrh	r3, [r10]
	strh	r0, [r5, #86]	@ movhi
	ldr	r5, .L4154+24
	ldrb	r2, [r5]	@ zero_extendqisi2
	muls	r2, r3, r2
	ldr	r3, .L4154+28
	ldr	r0, [r3]
	lsls	r2, r2, #2
	bl	ftl_memset
	ldrh	r3, [r10]
	movs	r1, #255
	ldrb	r2, [r5]	@ zero_extendqisi2
	muls	r2, r3, r2
	ldr	r3, .L4154+32
	ldr	r0, [r3]
	lsls	r2, r2, #2
	bl	ftl_memset
	ldrh	r3, [r10]
	movs	r1, #255
	ldrb	r2, [r5]	@ zero_extendqisi2
	muls	r2, r3, r2
	ldr	r3, .L4154+36
	ldr	r0, [r3]
	bl	ftl_memset
	ldr	r3, [r8]
	movw	r2, #65535
	strh	r2, [r3, #128]	@ movhi
	strh	r2, [r3, #130]	@ movhi
	str	r4, [r3, #132]
	bl	pm_flush
	bl	ftl_ext_info_flush
	ldr	r3, .L4154+40
	mov	r0, r7
	strh	r7, [r6, #52]	@ movhi
	ldr	r3, [r3]
	strh	r4, [r3, #126]	@ movhi
	mov	r3, #-1
	strh	r7, [r6, #566]	@ movhi
	strh	r7, [r6, #568]	@ movhi
	strh	r7, [r6, #572]	@ movhi
	str	r3, [r6, #576]
	bl	ftl_info_flush
	b	.L4077
.L4050:
	ldr	r3, [sp, #32]
	ldr	r7, .L4154
	cmp	r3, #1
	ite	ne
	movne	r10, #1
	moveq	r10, #4
	cmp	r6, #15
	ldr	r6, .L4154+4
	it	ls
	addls	r10, r10, #4
.L4057:
	add	r10, r10, #-1
	uxtb	r10, r10
	cmp	r10, #255
	beq	.L4077
	bl	gc_do_copy_back
	ldrb	r3, [r7]	@ zero_extendqisi2
	cbnz	r3, .L4058
	ldr	r3, .L4154+44
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #3
	bhi	.L4059
	bl	ftl_write_commit
.L4059:
	ldrh	r2, [r6, #22]
	ldrh	r3, [r6, #20]
	cmp	r2, r3
	bcc	.L4057
	movs	r3, #1
	strb	r3, [r4]
	ldr	r4, .L4154+48
	bl	ftl_write_commit
	bl	ftl_flush
	ldrh	r1, [r6]
	ldr	r2, [r4]
	ldrh	r2, [r2, r1, lsl #1]
	cbz	r2, .L4061
	movw	r2, #2713
	ldr	r1, .L4154+12
	ldr	r0, .L4154+16
	bl	printf
.L4061:
	ldrh	r0, [r6]
	ldr	r3, [r4]
	ldrh	r3, [r3, r0, lsl #1]
	cbnz	r3, .L4062
	bl	ftl_free_sblk
	b	.L4036
.L4062:
	movs	r2, #1
	movs	r1, #0
	bl	gc_add_sblk
	b	.L4036
.L4058:
	ldrh	r3, [r6, #572]
	cbz	r3, .L4063
	movs	r5, #0
	strh	r5, [r6, #572]	@ movhi
	bl	sblk_wait_write_queue_completed
	bl	gc_write_completed
	ldr	r0, [r6, #576]
	adds	r3, r0, #1
	beq	.L4064
	bl	ftl_mask_bad_block
.L4064:
	ldr	r3, [r8]
	str	r5, [r6, #576]
	strh	r5, [r6, #52]	@ movhi
	ldrh	r0, [r3, #80]
	bl	ftl_free_sblk
	ldr	r1, .L4154+40
	movw	r3, #65535
	ldr	r0, [r6, #8]
	ldr	r2, [r8]
	ldr	r1, [r1]
	strh	r3, [r2, #80]	@ movhi
	strh	r3, [r1, #126]	@ movhi
	strh	r3, [r2, #130]	@ movhi
	cbz	r0, .L4065
	bl	zbuf_free
.L4065:
	movs	r5, #0
	str	r5, [r6, #8]
	bl	flt_sys_flush
	movw	r2, #2751
	ldr	r1, .L4154+12
	ldr	r0, .L4154+16
	strb	r5, [r4]
	bl	printf
	b	.L4077
.L4063:
	ldrh	r3, [r5, #86]
	ldrh	r2, [r6, #22]
	cmp	r3, #1
	ldrh	r3, [r6, #20]
	bls	.L4066
	cmp	r2, r3
	bcc	.L4057
	movs	r3, #1
	strb	r3, [r4]
	ldrh	r3, [r6, #52]
	adds	r2, r3, #1
	strh	r2, [r6, #52]	@ movhi
	add	r3, r6, r3, lsl #1
	ldrh	r2, [r6]
	strh	r2, [r3, #54]	@ movhi
	movw	r3, #65535
	strh	r3, [r6]	@ movhi
	b	.L4077
.L4066:
	cmp	r2, r3
	mov	r1, #5
	strb	r1, [r4]
	bcc	.L4067
	ldrh	r3, [r6, #52]
	adds	r2, r3, #1
	strh	r2, [r6, #52]	@ movhi
	add	r3, r6, r3, lsl #1
	ldrh	r2, [r6]
	strh	r2, [r3, #54]	@ movhi
	movw	r3, #65535
	strh	r3, [r6]	@ movhi
.L4067:
	bl	ftl_flush
	bl	sblk_wait_write_queue_completed
	bl	gc_write_completed
	ldr	r3, [r8]
	ldrh	r2, [r5, #80]
	strh	r2, [r3, #128]	@ movhi
	bl	pm_flush
	bl	ftl_ext_info_flush
	movs	r3, #0
	ldr	r2, .L4154+52
	strh	r3, [r6, #12]	@ movhi
	ldr	r3, .L4154+20
	ldrb	r2, [r2]	@ zero_extendqisi2
	ldrh	r3, [r3]
	strh	r3, [r6, #14]	@ movhi
	ldr	r3, .L4154+56
	ldrb	r3, [r3]	@ zero_extendqisi2
	strh	r3, [r6, #16]	@ movhi
	cbz	r2, .L4068
	ldr	r2, .L4154+60
	ldrh	r2, [r2]
	strh	r2, [r6, #14]	@ movhi
	movs	r2, #1
	strh	r2, [r6, #16]	@ movhi
.L4068:
	cmp	r3, #2
	bne	.L4070
	ldrh	r3, [r6, #14]
	lsls	r3, r3, #1
	strh	r3, [r6, #14]	@ movhi
	ldr	r3, .L4154+64
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L4070
	movs	r3, #1
	strh	r3, [r6, #16]	@ movhi
.L4070:
	movs	r3, #0
	strh	r3, [r6, #18]	@ movhi
	b	.L4077
.L4073:
	ldrh	r2, [r5, #12]
	ldrh	r3, [r5, #14]
	cmp	r2, r3
	bcc	.L4074
	movs	r3, #6
	ldr	r0, [r5, #8]
	strb	r3, [r4]
	bl	zbuf_free
	str	r10, [r5, #8]
	b	.L4077
.L4074:
	cmp	r6, #15
	bls	.L3977
	ldr	r3, [sp, #32]
	cmp	r3, #1
	bne	.L4077
	adds	r7, r7, #1
	uxtb	r7, r7
	cmp	r7, #4
	bls	.L3977
	b	.L4077
.L4155:
	.align	2
.L4154:
	.word	.LANCHOR78
	.word	.LANCHOR64
	.word	.LANCHOR7
	.word	.LANCHOR226
	.word	.LC0
	.word	.LANCHOR87
	.word	.LANCHOR80
	.word	.LANCHOR155
	.word	.LANCHOR156
	.word	.LANCHOR76
	.word	.LANCHOR104
	.word	.LANCHOR54
	.word	.LANCHOR9
	.word	.LANCHOR35
	.word	.LANCHOR73
	.word	.LANCHOR79
	.word	.LANCHOR74
.L3976:
	bl	gc_update_l2p_map_new
	bl	gc_free_src_blk
	bl	ftl_flush
	movw	r6, #65535
	bl	pm_flush
	strh	r6, [r5, #80]	@ movhi
	bl	ftl_ext_info_flush
	ldr	r3, .L4156
	movs	r0, #0
	ldr	r3, [r3]
	strh	r6, [r3, #126]	@ movhi
	bl	ftl_info_flush
.L4147:
	movs	r3, #0
	b	.L4146
.L4053:
	movw	r2, #2644
	ldr	r1, .L4156+4
	ldr	r0, .L4156+8
	bl	printf
	b	.L4076
.L4157:
	.align	2
.L4156:
	.word	.LANCHOR104
	.word	.LANCHOR226
	.word	.LC0
	.size	zftl_do_gc, .-zftl_do_gc
	.section	.text.zftl_write,"ax",%progbits
	.align	1
	.global	zftl_write
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	zftl_write, %function
zftl_write:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r8, r3
	ldr	r3, .L4178
	sub	sp, sp, #24
	mov	r4, r0
	mov	r5, r1
	mov	r7, r2
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L4159
	ldr	r3, [r8]
	str	r3, [sp]
	mov	r3, r2
	mov	r2, r1
	mov	r1, r0
	ldr	r0, .L4178+4
	bl	printf
.L4159:
	cbnz	r4, .L4160
	ldr	r3, .L4178+8
	mov	r4, #24576
	ldr	r3, [r3]
.L4161:
	adds	r2, r5, r7
	cmp	r3, r2
	bcc	.L4174
	ldr	fp, .L4178+24
	add	r4, r4, r5
	mov	r0, r4
	ldrb	r5, [fp]	@ zero_extendqisi2
	mov	r1, r5
	bl	__aeabi_uidiv
	mov	r10, r0
	subs	r0, r7, #1
	mov	r1, r5
	add	r0, r0, r4
	bl	__aeabi_uidiv
	sub	r5, r0, r10
	mov	r6, r10
	adds	r5, r5, #1
	str	r0, [sp, #12]
	str	fp, [sp, #16]
.L4163:
	cbnz	r5, .L4170
	bl	ftl_write_commit
	bl	ftl_flush
	ldr	r4, .L4178+12
	mov	r0, r5
	ldr	r5, .L4178+16
	movs	r1, #1
	bl	zftl_do_gc
.L4171:
	ldrh	r3, [r5]
	ldrh	r2, [r4]
	add	r3, r3, r2
	cmp	r3, #7
	ble	.L4172
	movs	r0, #0
.L4158:
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L4160:
	cmp	r4, #3
	bhi	.L4174
	lsls	r4, r4, #13
	mov	r3, #8192
	b	.L4161
.L4170:
	movs	r0, #0
	bl	buf_alloc
	mov	fp, r0
	cbnz	r0, .L4164
	bl	ftl_write_commit
	b	.L4163
.L4164:
	mov	r3, #0
	cmp	r6, r10
	strb	r3, [r0, #41]
	ldr	r3, [sp, #16]
	ldrb	r2, [r3]	@ zero_extendqisi2
	strb	r2, [r0, #40]
	bne	.L4166
	mov	r1, r2
	mov	r0, r4
	str	r2, [sp, #20]
	bl	__aeabi_uidivmod
	ldr	r2, [sp, #20]
	uxtb	r1, r1
	strb	r1, [fp, #41]
	subs	r1, r2, r1
	uxtb	r1, r1
	cmp	r7, r1
	ite	cs
	strbcs	r1, [fp, #40]
	strbcc	r7, [fp, #40]
.L4168:
	ldrb	ip, [fp, #41]	@ zero_extendqisi2
	mov	r1, r8
	ldrb	r2, [fp, #40]	@ zero_extendqisi2
	subs	r5, r5, #1
	ldr	r0, [fp, #4]
	lsls	r2, r2, #9
	add	r0, r0, ip, lsl #9
	bl	ftl_memcpy
	ldr	r3, .L4178+20
	str	r6, [fp, #20]
	adds	r6, r6, #1
	ldr	r1, [r3]
	ldr	r2, [r1, #8]
	adds	r0, r2, #1
	str	r0, [r1, #8]
	mov	r0, fp
	str	r2, [fp, #16]
	bl	ftl_write_buf
	ldrb	r3, [fp, #40]	@ zero_extendqisi2
	add	r8, r8, r3, lsl #9
	b	.L4163
.L4166:
	ldr	r3, [sp, #12]
	cmp	r6, r3
	itttt	eq
	smulbbeq	r2, r6, r2
	addeq	r1, r4, r7
	subeq	r2, r1, r2
	strbeq	r2, [r0, #40]
	b	.L4168
.L4172:
	movs	r1, #1
	movs	r0, #0
	bl	zftl_do_gc
	b	.L4171
.L4174:
	mov	r0, #-1
	b	.L4158
.L4179:
	.align	2
.L4178:
	.word	.LANCHOR14
	.word	.LC246
	.word	.LANCHOR61
	.word	.LANCHOR101
	.word	.LANCHOR97
	.word	.LANCHOR104
	.word	.LANCHOR125
	.size	zftl_write, .-zftl_write
	.section	.text.ftl_vendor_write,"ax",%progbits
	.align	1
	.global	ftl_vendor_write
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_vendor_write, %function
ftl_vendor_write:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	mov	r3, r2
	mov	r2, r1
	add	r1, r0, #512
	movs	r0, #2
	b	zftl_write
	.size	ftl_vendor_write, .-ftl_vendor_write
	.section	.text.zftl_sys_write,"ax",%progbits
	.align	1
	.global	zftl_sys_write
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	zftl_sys_write, %function
zftl_sys_write:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	mov	r3, r2
	mov	r2, r1
	mov	r1, r0
	movs	r0, #2
	b	zftl_write
	.size	zftl_sys_write, .-zftl_sys_write
	.section	.text.StorageSysDataStore,"ax",%progbits
	.align	1
	.global	StorageSysDataStore
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	StorageSysDataStore, %function
StorageSysDataStore:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	mov	r3, r1
	movs	r2, #1
	mov	r1, r0
	movs	r0, #2
	b	zftl_write
	.size	StorageSysDataStore, .-StorageSysDataStore
	.section	.text.FlashBootVendorWrite,"ax",%progbits
	.align	1
	.global	FlashBootVendorWrite
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashBootVendorWrite, %function
FlashBootVendorWrite:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	mov	r3, r2
	mov	r2, r1
	add	r1, r0, #512
	movs	r0, #2
	b	zftl_write
	.size	FlashBootVendorWrite, .-FlashBootVendorWrite
	.section	.text.ftl_write,"ax",%progbits
	.align	1
	.global	ftl_write
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_write, %function
ftl_write:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, lr}
	mov	r7, r1
	mov	r4, r2
	mov	r5, r3
	mov	r6, r0
	cbnz	r0, .L4185
	mov	r3, r2
	mov	r2, r5
	bl	idb_write_data
.L4185:
	mov	r3, r5
	mov	r2, r4
	mov	r1, r7
	mov	r0, r6
	pop	{r4, r5, r6, r7, r8, lr}
	b	zftl_write
	.size	ftl_write, .-ftl_write
	.section	.text.zftl_discard,"ax",%progbits
	.align	1
	.global	zftl_discard
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	zftl_discard, %function
zftl_discard:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r2, .L4234
	adds	r3, r0, r1
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r1
	sub	sp, sp, #32
	ldr	r2, [r2]
	cmp	r2, r3
	bcc	.L4207
	ldr	r2, .L4234+4
	add	r7, r0, #24576
	ldr	r3, .L4234+8
	ldr	r0, [r2]
	ldr	r1, [r3]
	str	r3, [sp, #12]
	tst	r0, #4096
	str	r2, [sp, #16]
	add	r1, r1, r4
	str	r1, [r3]
	beq	.L4188
	movs	r3, #0
	mov	r2, r7
	str	r3, [sp]
	mov	r3, r4
	ldr	r0, .L4234+12
	bl	printf
.L4188:
	ldr	r8, .L4234+36
	ldr	r10, .L4234+40
	ldr	r3, [r8]
	ldr	r2, [r3, #8]
	str	r2, [sp, #8]
	adds	r2, r2, #1
	str	r2, [r3, #8]
	bl	ftl_write_commit
	bl	ftl_flush
	ldrb	r6, [r10]	@ zero_extendqisi2
	mov	r0, r7
	mov	r1, r6
	bl	__aeabi_uidiv
	mov	r1, r6
	mov	r5, r0
	mov	r0, r7
	bl	__aeabi_uidivmod
	mov	fp, r1
	cmp	r1, #0
	beq	.L4189
	subs	r6, r6, r1
	mov	r0, r5
	cmp	r6, r4
	it	cs
	movcs	r6, r4
	bl	lpa_hash_get_ppa
	str	r0, [sp, #24]
	adds	r0, r0, #1
	bne	.L4190
	movs	r2, #0
	add	r1, sp, #24
	mov	r0, r5
	bl	pm_log2phys
.L4190:
	ldr	r3, [sp, #24]
	adds	r3, r3, #1
	beq	.L4192
	movs	r0, #0
	bl	buf_alloc
	mov	r3, r0
	cbz	r0, .L4192
	ldr	r2, [sp, #8]
	movs	r1, #0
	str	r5, [r0, #20]
	strb	fp, [r0, #41]
	str	r2, [r0, #16]
	uxth	r2, r6
	strb	r6, [r0, #40]
	ldr	r0, [r0, #4]
	lsls	r2, r2, #9
	str	r3, [sp, #20]
	add	r0, r0, fp, lsl #9
	bl	ftl_memset
	ldr	r3, [sp, #20]
	mov	r0, r3
	bl	ftl_write_buf
	bl	ftl_write_commit
	ldr	r2, [r8]
	ldr	r3, [r2, #76]
	adds	r3, r3, #1
	str	r3, [r2, #76]
.L4192:
	uxth	r6, r6
	adds	r5, r5, #1
	subs	r4, r4, r6
.L4189:
	cbz	r4, .L4194
	bl	ftl_flush
.L4194:
	ldr	fp, .L4234+44
	mov	r3, #-1
	ldr	r6, .L4234+16
	str	r3, [sp, #28]
.L4195:
	ldrb	r3, [r10]	@ zero_extendqisi2
	cmp	r4, r3
	bcs	.L4200
	cmp	r4, #0
	beq	.L4202
	mov	r0, r5
	bl	lpa_hash_get_ppa
	str	r0, [sp, #24]
	adds	r0, r0, #1
	bne	.L4203
	movs	r2, #0
	add	r1, sp, #24
	mov	r0, r5
	bl	pm_log2phys
.L4203:
	ldr	r3, [sp, #24]
	adds	r3, r3, #1
	beq	.L4202
	movs	r0, #0
	bl	buf_alloc
	mov	r6, r0
	cbz	r0, .L4202
	movs	r3, #0
	str	r5, [r0, #20]
	strb	r3, [r0, #41]
	ldr	r3, [sp, #8]
	strb	r4, [r0, #40]
	str	r3, [r0, #16]
	ldrb	r3, [r10]	@ zero_extendqisi2
	cmp	r4, r3
	bcc	.L4205
	movw	r2, #1259
	ldr	r1, .L4234+20
	ldr	r0, .L4234+24
	bl	printf
.L4205:
	lsls	r2, r4, #9
	movs	r1, #0
	ldr	r0, [r6, #4]
	bl	ftl_memset
	mov	r0, r6
	bl	ftl_write_buf
	bl	ftl_write_commit
	ldr	r2, [r8]
	ldr	r3, [r2, #76]
	adds	r3, r3, #1
	str	r3, [r2, #76]
.L4202:
	ldr	r3, [sp, #12]
	ldr	r1, [r3]
	cmp	r1, #8192
	bls	.L4208
	ldr	r3, [sp, #16]
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L4206
	movs	r3, #0
	mov	r2, r7
	str	r3, [sp]
	mov	r3, r4
	ldr	r0, .L4234+12
	bl	printf
.L4206:
	ldr	r3, [sp, #12]
	movs	r4, #0
	str	r4, [r3]
	bl	flt_sys_flush
	ldr	r3, .L4234+28
	movs	r2, #1
	str	r2, [r3]
.L4208:
	movs	r0, #0
	b	.L4186
.L4200:
	mov	r0, r5
	bl	lpa_hash_get_ppa
	str	r0, [sp, #24]
	adds	r0, r0, #1
	beq	.L4196
	movs	r0, #0
	bl	buf_alloc
	mov	r3, r0
	cbz	r0, .L4198
	ldrb	r2, [r10]	@ zero_extendqisi2
	movs	r1, #0
	strb	r1, [r0, #41]
	str	r5, [r0, #20]
	strb	r2, [r0, #40]
	ldr	r0, [sp, #8]
	lsls	r2, r2, #9
	str	r3, [sp, #20]
	str	r0, [r3, #16]
	ldr	r0, [r3, #4]
	bl	ftl_memset
	ldr	r3, [sp, #20]
	mov	r0, r3
	bl	ftl_write_buf
	bl	ftl_write_commit
.L4233:
	ldr	r2, [r8]
	ldr	r3, [r2, #76]
	adds	r3, r3, #1
	str	r3, [r2, #76]
.L4198:
	ldrb	r3, [r10]	@ zero_extendqisi2
	adds	r5, r5, #1
	subs	r4, r4, r3
	b	.L4195
.L4196:
	movs	r2, #0
	add	r1, sp, #24
	mov	r0, r5
	bl	pm_log2phys
	ldr	r3, [sp, #24]
	adds	r3, r3, #1
	beq	.L4198
	add	r1, sp, #28
	movs	r2, #1
	mov	r0, r5
	bl	pm_log2phys
	ldrb	r3, [r6]	@ zero_extendqisi2
	ldrh	r2, [fp]
	rsb	r3, r3, #24
	subs	r0, r3, r2
	movs	r3, #1
	lsls	r3, r3, r0
	ldr	r0, [sp, #24]
	subs	r3, r3, #1
	lsrs	r0, r0, r2
	ldr	r2, .L4234+32
	ands	r0, r0, r3
	ldrb	r1, [r2]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	uxth	r0, r0
	bl	ftl_vpn_decrement
	b	.L4233
.L4207:
	mov	r0, #-1
.L4186:
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L4235:
	.align	2
.L4234:
	.word	.LANCHOR61
	.word	.LANCHOR14
	.word	.LANCHOR227
	.word	.LC247
	.word	.LANCHOR31
	.word	.LANCHOR228
	.word	.LC0
	.word	.LANCHOR116
	.word	.LANCHOR69
	.word	.LANCHOR104
	.word	.LANCHOR125
	.word	.LANCHOR68
	.size	zftl_discard, .-zftl_discard
	.section	.text.ftl_discard,"ax",%progbits
	.align	1
	.global	ftl_discard
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_discard, %function
ftl_discard:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	mov	r0, r1
	mov	r1, r2
	b	zftl_discard
	.size	ftl_discard, .-ftl_discard
	.section	.text.dump_pm_blk,"ax",%progbits
	.align	1
	.global	dump_pm_blk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	dump_pm_blk, %function
dump_pm_blk:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	movs	r2, #4
	ldr	r4, .L4241
	movs	r5, #0
	movw	r7, #65535
	ldr	r0, .L4241+4
	ldr	r1, [r4]
	ldr	r6, .L4241+8
	ldrh	r3, [r1, #698]
	add	r1, r1, #704
	bl	rknand_print_hex
	ldr	r1, [r4]
	movs	r2, #2
	ldrh	r3, [r6]
	ldr	r0, .L4241+12
	add	r1, r1, #416
	bl	rknand_print_hex
.L4238:
	ldrh	r2, [r6]
	uxth	r3, r5
	cmp	r2, r3
	bhi	.L4240
	pop	{r3, r4, r5, r6, r7, pc}
.L4240:
	ldr	r2, [r4]
	uxth	r3, r5
	adds	r3, r3, #208
	ldrh	r0, [r2, r3, lsl #1]
	cmp	r0, r7
	beq	.L4239
	movs	r1, #0
	bl	ftl_sblk_dump
.L4239:
	adds	r5, r5, #1
	b	.L4238
.L4242:
	.align	2
.L4241:
	.word	.LANCHOR104
	.word	.LC248
	.word	.LANCHOR149
	.word	.LC249
	.size	dump_pm_blk, .-dump_pm_blk
	.global	g_pm_spare
	.global	pm_first_write
	.global	pm_force_gc
	.global	pm_gc_enable
	.global	pm_last_load_ram_id
	.global	pm_last_update_ram_id
	.global	pm_ram_info
	.global	sblk_gc_write_completed_queue_head
	.global	sblk_read_completed_queue_head
	.global	sblk_write_completed_queue_head
	.global	sblk_queue_head
	.global	slc_cache_sblk
	.global	xlc_data_sblk
	.global	slc_data_sblk
	.global	free_mix_sblk
	.global	free_xlc_sblk
	.global	free_slc_sblk
	.global	gp_data_xlc_data_head
	.global	gp_data_slc_data_head
	.global	gp_data_slc_cache_head
	.global	gp_free_mix_head
	.global	gp_free_xlc_head
	.global	gp_free_slc_head
	.global	gp_sblk_list_tbl
	.global	zftl_print_list_count
	.global	ftl_ext_info_first_write
	.global	ftl_sys_info_first_write
	.global	ftl_low_format_cur_blk
	.global	ftl_power_lost_flag
	.global	ftl_vpn_update_count
	.global	ftl_sblk_update_list_offset
	.global	ftl_sblk_update_list
	.global	ftl_sblk_vpn_update_id
	.global	ftl_sblk_lpa_tbl
	.global	ftl_sblk_vpn
	.global	gp_ftl_ext_info
	.global	gp_ftl_info
	.global	gp_blk_info
	.global	ftl_tmp_spare
	.global	ftl_info_spare
	.global	ftl_ext_info_data_buffer
	.global	ftl_info_data_buffer
	.global	ftl_tmp_buffer
	.global	g_ftl_info_blk
	.global	tlc_b05a_prog_tbl
	.global	tlc_prog_order
	.global	gc_des_ppa_tbl
	.global	gc_valid_page_ppa
	.global	gc_page_buf_id
	.global	gc_pre_ppa_tbl
	.global	gc_lpa_tbl
	.global	g_gc_info
	.global	gc_xlc_search_index
	.global	gc_xlc_data_index
	.global	gc_slc_cache_index
	.global	gc_slc_data_index
	.global	gc_free_slc_sblk_th
	.global	gc_slc_mode_vpn_th
	.global	gc_slc_mode_tlc_vpn_th
	.global	gc_tlc_mode_tlc_vpn_th
	.global	gc_tlc_mode_slc_vpn_th
	.global	gc_state
	.global	gc_mode
	.global	p_read_ahead_ext_buf
	.global	discard_sector_count
	.global	read_ahead_lpa
	.global	read_buf_count
	.global	read_buf_head
	.global	write_commit_count
	.global	write_commit_head
	.global	write_buf_count
	.global	write_buf_head
	.global	ftl_flush_jiffies
	.global	lpa_hash
	.global	lpa_hash_index
	.global	_c_slc_to_xlc_ec_ratio
	.global	_c_mix_max_xlc_ec_count
	.global	_c_mix_max_slc_ec_count
	.global	_c_swl_xlc_gc_th
	.global	_c_swl_slc_gc_th
	.global	_gc_after_discard_en
	.global	_last_write_time
	.global	_last_read_time
	.global	_min_slc_super_block
	.global	_max_slc_super_block
	.global	_max_xlc_super_block
	.global	_c_max_pm_sblk
	.global	_c_ftl_pm_page_num
	.global	_c_totle_log_page
	.global	_c_totle_data_density
	.global	_c_user_data_density
	.global	_c_totle_phy_density
	.global	_c_ftl_block_addr_log2
	.global	_c_ftl_block_align_addr
	.global	_c_ftl_byte_pre_page
	.global	_c_ftl_nand_blks_per_die
	.global	_c_ftl_page_pre_slc_blk
	.global	_c_ftl_page_pre_blk
	.global	_c_ftl_blk_pre_plane
	.global	_c_ftl_nand_planes_num
	.global	_c_ftl_planes_per_die
	.global	_c_ftl_sec_per_page
	.global	_c_ftl_nand_die_num
	.global	_c_ftl_nand_type
	.global	zftl_debug
	.global	g_flash_blk_info
	.global	gp_flash_info
	.global	p_free_buf_head
	.global	free_buf_count
	.global	g_buf
	.global	nandc_ecc_sts
	.global	g_nandc_v6_master_info
	.global	nandc_randomizer_en
	.global	nandc_hw_seed
	.global	fill_spare_size
	.global	g_nandc_ecc_bits
	.global	g_nandc_tran_timeout
	.global	g_nandc_ver
	.global	gp_nandc
	.global	hy_f26_ref_value
	.global	sd15_tlc_rr
	.global	sd15_slc_rr
	.global	g_nand_para_info
	.global	gp_nand_para_info
	.global	g_nand_opt_para
	.global	g_msb_page_tbl
	.global	g_lsb_page_tbl
	.global	g_die_addr
	.global	g_die_cs_idx
	.global	IDByte
	.global	flash_read_retry
	.global	_c_ftl_cs_bits
	.global	g_maxRetryCount
	.global	g_maxRegNum
	.global	g_retryMode
	.global	g_flash_toggle_mode_en
	.global	g_flash_micron_3d_tlc_b16a
	.global	g_flash_micron_3d_tlc_b05a
	.global	g_flash_micron_3d_tlc_flag
	.global	g_flash_3d_mlc_flag
	.global	g_flash_3d_tlc_flag
	.global	g_flash_multi_page_prog_en
	.global	g_flash_multi_page_read_en
	.global	g_flash_interface_mode
	.global	g_idb_ecc_bits
	.global	g_idb_slc_mode_enable
	.global	g_one_pass_program
	.global	g_slc_mode_addr2
	.global	g_slc_mode_enable
	.global	g_flash_cur_mode
	.global	g_flash_slc_mode
	.global	g_slc_page_num
	.global	g_totle_phy_block
	.global	g_block_align_addr
	.global	g_flash_reversd_blks
	.global	g_nand_max_die
	.global	g_flash_tmp_spare_buffer
	.global	g_flash_tmp_page_buffer
	.global	g_flash_sys_spare_buffer
	.global	g_flash_spare_buffer
	.global	g_flash_page_buffer
	.section	.bss.IDByte,"aw",%nobits
	.align	2
	.set	.LANCHOR44,. + 0
	.type	IDByte, %object
	.size	IDByte, 32
IDByte:
	.space	32
	.section	.bss._c_ftl_blk_pre_plane,"aw",%nobits
	.align	1
	.set	.LANCHOR6,. + 0
	.type	_c_ftl_blk_pre_plane, %object
	.size	_c_ftl_blk_pre_plane, 2
_c_ftl_blk_pre_plane:
	.space	2
	.section	.bss._c_ftl_block_addr_log2,"aw",%nobits
	.align	1
	.set	.LANCHOR68,. + 0
	.type	_c_ftl_block_addr_log2, %object
	.size	_c_ftl_block_addr_log2, 2
_c_ftl_block_addr_log2:
	.space	2
	.section	.bss._c_ftl_block_align_addr,"aw",%nobits
	.align	1
	.set	.LANCHOR105,. + 0
	.type	_c_ftl_block_align_addr, %object
	.size	_c_ftl_block_align_addr, 2
_c_ftl_block_align_addr:
	.space	2
	.section	.bss._c_ftl_byte_pre_page,"aw",%nobits
	.align	1
	.set	.LANCHOR208,. + 0
	.type	_c_ftl_byte_pre_page, %object
	.size	_c_ftl_byte_pre_page, 2
_c_ftl_byte_pre_page:
	.space	2
	.section	.bss._c_ftl_cs_bits,"aw",%nobits
	.set	.LANCHOR31,. + 0
	.type	_c_ftl_cs_bits, %object
	.size	_c_ftl_cs_bits, 1
_c_ftl_cs_bits:
	.space	1
	.section	.bss._c_ftl_nand_blks_per_die,"aw",%nobits
	.align	1
	.type	_c_ftl_nand_blks_per_die, %object
	.size	_c_ftl_nand_blks_per_die, 2
_c_ftl_nand_blks_per_die:
	.space	2
	.section	.bss._c_ftl_nand_die_num,"aw",%nobits
	.set	.LANCHOR106,. + 0
	.type	_c_ftl_nand_die_num, %object
	.size	_c_ftl_nand_die_num, 1
_c_ftl_nand_die_num:
	.space	1
	.section	.bss._c_ftl_nand_planes_num,"aw",%nobits
	.set	.LANCHOR80,. + 0
	.type	_c_ftl_nand_planes_num, %object
	.size	_c_ftl_nand_planes_num, 1
_c_ftl_nand_planes_num:
	.space	1
	.section	.bss._c_ftl_nand_type,"aw",%nobits
	.set	.LANCHOR73,. + 0
	.type	_c_ftl_nand_type, %object
	.size	_c_ftl_nand_type, 1
_c_ftl_nand_type:
	.space	1
	.section	.bss._c_ftl_page_pre_blk,"aw",%nobits
	.align	1
	.set	.LANCHOR79,. + 0
	.type	_c_ftl_page_pre_blk, %object
	.size	_c_ftl_page_pre_blk, 2
_c_ftl_page_pre_blk:
	.space	2
	.section	.bss._c_ftl_page_pre_slc_blk,"aw",%nobits
	.align	1
	.set	.LANCHOR87,. + 0
	.type	_c_ftl_page_pre_slc_blk, %object
	.size	_c_ftl_page_pre_slc_blk, 2
_c_ftl_page_pre_slc_blk:
	.space	2
	.section	.bss._c_ftl_planes_per_die,"aw",%nobits
	.set	.LANCHOR69,. + 0
	.type	_c_ftl_planes_per_die, %object
	.size	_c_ftl_planes_per_die, 1
_c_ftl_planes_per_die:
	.space	1
	.section	.bss._c_ftl_pm_page_num,"aw",%nobits
	.align	1
	.set	.LANCHOR194,. + 0
	.type	_c_ftl_pm_page_num, %object
	.size	_c_ftl_pm_page_num, 2
_c_ftl_pm_page_num:
	.space	2
	.section	.bss._c_ftl_sec_per_page,"aw",%nobits
	.set	.LANCHOR125,. + 0
	.type	_c_ftl_sec_per_page, %object
	.size	_c_ftl_sec_per_page, 1
_c_ftl_sec_per_page:
	.space	1
	.section	.bss._c_max_pm_sblk,"aw",%nobits
	.align	1
	.set	.LANCHOR149,. + 0
	.type	_c_max_pm_sblk, %object
	.size	_c_max_pm_sblk, 2
_c_max_pm_sblk:
	.space	2
	.section	.bss._c_mix_max_slc_ec_count,"aw",%nobits
	.align	1
	.set	.LANCHOR120,. + 0
	.type	_c_mix_max_slc_ec_count, %object
	.size	_c_mix_max_slc_ec_count, 2
_c_mix_max_slc_ec_count:
	.space	2
	.section	.bss._c_mix_max_xlc_ec_count,"aw",%nobits
	.align	1
	.set	.LANCHOR118,. + 0
	.type	_c_mix_max_xlc_ec_count, %object
	.size	_c_mix_max_xlc_ec_count, 2
_c_mix_max_xlc_ec_count:
	.space	2
	.section	.bss._c_slc_to_xlc_ec_ratio,"aw",%nobits
	.align	1
	.set	.LANCHOR8,. + 0
	.type	_c_slc_to_xlc_ec_ratio, %object
	.size	_c_slc_to_xlc_ec_ratio, 2
_c_slc_to_xlc_ec_ratio:
	.space	2
	.section	.bss._c_swl_slc_gc_th,"aw",%nobits
	.align	1
	.set	.LANCHOR148,. + 0
	.type	_c_swl_slc_gc_th, %object
	.size	_c_swl_slc_gc_th, 2
_c_swl_slc_gc_th:
	.space	2
	.section	.bss._c_swl_xlc_gc_th,"aw",%nobits
	.align	1
	.set	.LANCHOR147,. + 0
	.type	_c_swl_xlc_gc_th, %object
	.size	_c_swl_xlc_gc_th, 2
_c_swl_xlc_gc_th:
	.space	2
	.section	.bss._c_totle_data_density,"aw",%nobits
	.align	2
	.set	.LANCHOR213,. + 0
	.type	_c_totle_data_density, %object
	.size	_c_totle_data_density, 4
_c_totle_data_density:
	.space	4
	.section	.bss._c_totle_log_page,"aw",%nobits
	.align	2
	.set	.LANCHOR122,. + 0
	.type	_c_totle_log_page, %object
	.size	_c_totle_log_page, 4
_c_totle_log_page:
	.space	4
	.section	.bss._c_totle_phy_density,"aw",%nobits
	.align	2
	.set	.LANCHOR212,. + 0
	.type	_c_totle_phy_density, %object
	.size	_c_totle_phy_density, 4
_c_totle_phy_density:
	.space	4
	.section	.bss._c_user_data_density,"aw",%nobits
	.align	2
	.set	.LANCHOR61,. + 0
	.type	_c_user_data_density, %object
	.size	_c_user_data_density, 4
_c_user_data_density:
	.space	4
	.section	.bss._gc_after_discard_en,"aw",%nobits
	.align	2
	.set	.LANCHOR116,. + 0
	.type	_gc_after_discard_en, %object
	.size	_gc_after_discard_en, 4
_gc_after_discard_en:
	.space	4
	.section	.bss._last_read_time,"aw",%nobits
	.align	2
	.type	_last_read_time, %object
	.size	_last_read_time, 4
_last_read_time:
	.space	4
	.section	.bss._last_write_time,"aw",%nobits
	.align	2
	.type	_last_write_time, %object
	.size	_last_write_time, 4
_last_write_time:
	.space	4
	.section	.bss._max_slc_super_block,"aw",%nobits
	.align	1
	.set	.LANCHOR119,. + 0
	.type	_max_slc_super_block, %object
	.size	_max_slc_super_block, 2
_max_slc_super_block:
	.space	2
	.section	.bss._max_xlc_super_block,"aw",%nobits
	.align	1
	.set	.LANCHOR95,. + 0
	.type	_max_xlc_super_block, %object
	.size	_max_xlc_super_block, 2
_max_xlc_super_block:
	.space	2
	.section	.bss._min_slc_super_block,"aw",%nobits
	.align	1
	.set	.LANCHOR91,. + 0
	.type	_min_slc_super_block, %object
	.size	_min_slc_super_block, 2
_min_slc_super_block:
	.space	2
	.section	.bss.discard_sector_count,"aw",%nobits
	.align	2
	.set	.LANCHOR227,. + 0
	.type	discard_sector_count, %object
	.size	discard_sector_count, 4
discard_sector_count:
	.space	4
	.section	.bss.fill_spare_size,"aw",%nobits
	.align	1
	.set	.LANCHOR50,. + 0
	.type	fill_spare_size, %object
	.size	fill_spare_size, 2
fill_spare_size:
	.space	2
	.section	.bss.flash_ddr_tuning_sdr_read_count,"aw",%nobits
	.align	2
	.set	.LANCHOR163,. + 0
	.type	flash_ddr_tuning_sdr_read_count, %object
	.size	flash_ddr_tuning_sdr_read_count, 4
flash_ddr_tuning_sdr_read_count:
	.space	4
	.section	.bss.flash_read_retry,"aw",%nobits
	.align	2
	.set	.LANCHOR165,. + 0
	.type	flash_read_retry, %object
	.size	flash_read_retry, 4
flash_read_retry:
	.space	4
	.section	.bss.free_buf_count,"aw",%nobits
	.set	.LANCHOR54,. + 0
	.type	free_buf_count, %object
	.size	free_buf_count, 1
free_buf_count:
	.space	1
	.section	.bss.free_mix_sblk,"aw",%nobits
	.align	1
	.set	.LANCHOR101,. + 0
	.type	free_mix_sblk, %object
	.size	free_mix_sblk, 2
free_mix_sblk:
	.space	2
	.section	.bss.free_slc_sblk,"aw",%nobits
	.align	1
	.set	.LANCHOR97,. + 0
	.type	free_slc_sblk, %object
	.size	free_slc_sblk, 2
free_slc_sblk:
	.space	2
	.section	.bss.free_xlc_sblk,"aw",%nobits
	.align	1
	.set	.LANCHOR99,. + 0
	.type	free_xlc_sblk, %object
	.size	free_xlc_sblk, 2
free_xlc_sblk:
	.space	2
	.section	.bss.ftl_ext_info_data_buffer,"aw",%nobits
	.align	6
	.type	ftl_ext_info_data_buffer, %object
	.size	ftl_ext_info_data_buffer, 16384
ftl_ext_info_data_buffer:
	.space	16384
	.section	.bss.ftl_ext_info_first_write,"aw",%nobits
	.set	.LANCHOR186,. + 0
	.type	ftl_ext_info_first_write, %object
	.size	ftl_ext_info_first_write, 1
ftl_ext_info_first_write:
	.space	1
	.section	.bss.ftl_flush_jiffies,"aw",%nobits
	.align	2
	.set	.LANCHOR222,. + 0
	.type	ftl_flush_jiffies, %object
	.size	ftl_flush_jiffies, 4
ftl_flush_jiffies:
	.space	4
	.section	.bss.ftl_info_data_buffer,"aw",%nobits
	.align	6
	.type	ftl_info_data_buffer, %object
	.size	ftl_info_data_buffer, 16384
ftl_info_data_buffer:
	.space	16384
	.section	.bss.ftl_info_spare,"aw",%nobits
	.align	6
	.set	.LANCHOR181,. + 0
	.type	ftl_info_spare, %object
	.size	ftl_info_spare, 256
ftl_info_spare:
	.space	256
	.section	.bss.ftl_low_format_cur_blk,"aw",%nobits
	.align	1
	.set	.LANCHOR62,. + 0
	.type	ftl_low_format_cur_blk, %object
	.size	ftl_low_format_cur_blk, 2
ftl_low_format_cur_blk:
	.space	2
	.section	.bss.ftl_power_lost_flag,"aw",%nobits
	.set	.LANCHOR185,. + 0
	.type	ftl_power_lost_flag, %object
	.size	ftl_power_lost_flag, 1
ftl_power_lost_flag:
	.space	1
	.section	.bss.ftl_sblk_lpa_tbl,"aw",%nobits
	.align	2
	.set	.LANCHOR111,. + 0
	.type	ftl_sblk_lpa_tbl, %object
	.size	ftl_sblk_lpa_tbl, 4
ftl_sblk_lpa_tbl:
	.space	4
	.section	.bss.ftl_sblk_update_list,"aw",%nobits
	.align	1
	.set	.LANCHOR67,. + 0
	.type	ftl_sblk_update_list, %object
	.size	ftl_sblk_update_list, 16
ftl_sblk_update_list:
	.space	16
	.section	.bss.ftl_sblk_update_list_offset,"aw",%nobits
	.align	1
	.set	.LANCHOR117,. + 0
	.type	ftl_sblk_update_list_offset, %object
	.size	ftl_sblk_update_list_offset, 2
ftl_sblk_update_list_offset:
	.space	2
	.section	.bss.ftl_sblk_vpn,"aw",%nobits
	.align	2
	.set	.LANCHOR9,. + 0
	.type	ftl_sblk_vpn, %object
	.size	ftl_sblk_vpn, 4
ftl_sblk_vpn:
	.space	4
	.section	.bss.ftl_sblk_vpn_update_id,"aw",%nobits
	.align	1
	.set	.LANCHOR66,. + 0
	.type	ftl_sblk_vpn_update_id, %object
	.size	ftl_sblk_vpn_update_id, 2
ftl_sblk_vpn_update_id:
	.space	2
	.section	.bss.ftl_sys_info_first_write,"aw",%nobits
	.set	.LANCHOR184,. + 0
	.type	ftl_sys_info_first_write, %object
	.size	ftl_sys_info_first_write, 1
ftl_sys_info_first_write:
	.space	1
	.section	.bss.ftl_tmp_buffer,"aw",%nobits
	.align	6
	.type	ftl_tmp_buffer, %object
	.size	ftl_tmp_buffer, 16384
ftl_tmp_buffer:
	.space	16384
	.section	.bss.ftl_tmp_spare,"aw",%nobits
	.align	6
	.set	.LANCHOR179,. + 0
	.type	ftl_tmp_spare, %object
	.size	ftl_tmp_spare, 256
ftl_tmp_spare:
	.space	256
	.section	.bss.ftl_vpn_update_count,"aw",%nobits
	.align	1
	.set	.LANCHOR115,. + 0
	.type	ftl_vpn_update_count, %object
	.size	ftl_vpn_update_count, 2
ftl_vpn_update_count:
	.space	2
	.section	.bss.g_block_align_addr,"aw",%nobits
	.align	1
	.set	.LANCHOR2,. + 0
	.type	g_block_align_addr, %object
	.size	g_block_align_addr, 2
g_block_align_addr:
	.space	2
	.section	.bss.g_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR52,. + 0
	.type	g_buf, %object
	.size	g_buf, 1536
g_buf:
	.space	1536
	.section	.bss.g_die_addr,"aw",%nobits
	.align	2
	.set	.LANCHOR143,. + 0
	.type	g_die_addr, %object
	.size	g_die_addr, 32
g_die_addr:
	.space	32
	.section	.bss.g_die_cs_idx,"aw",%nobits
	.align	2
	.set	.LANCHOR30,. + 0
	.type	g_die_cs_idx, %object
	.size	g_die_cs_idx, 8
g_die_cs_idx:
	.space	8
	.section	.bss.g_flash_3d_mlc_flag,"aw",%nobits
	.set	.LANCHOR74,. + 0
	.type	g_flash_3d_mlc_flag, %object
	.size	g_flash_3d_mlc_flag, 1
g_flash_3d_mlc_flag:
	.space	1
	.section	.bss.g_flash_3d_tlc_flag,"aw",%nobits
	.set	.LANCHOR77,. + 0
	.type	g_flash_3d_tlc_flag, %object
	.size	g_flash_3d_tlc_flag, 1
g_flash_3d_tlc_flag:
	.space	1
	.section	.bss.g_flash_blk_info,"aw",%nobits
	.align	1
	.set	.LANCHOR198,. + 0
	.type	g_flash_blk_info, %object
	.size	g_flash_blk_info, 4
g_flash_blk_info:
	.space	4
	.section	.bss.g_flash_cur_mode,"aw",%nobits
	.set	.LANCHOR33,. + 0
	.type	g_flash_cur_mode, %object
	.size	g_flash_cur_mode, 4
g_flash_cur_mode:
	.space	4
	.section	.bss.g_flash_interface_mode,"aw",%nobits
	.set	.LANCHOR45,. + 0
	.type	g_flash_interface_mode, %object
	.size	g_flash_interface_mode, 1
g_flash_interface_mode:
	.space	1
	.section	.bss.g_flash_micron_3d_tlc_b05a,"aw",%nobits
	.set	.LANCHOR204,. + 0
	.type	g_flash_micron_3d_tlc_b05a, %object
	.size	g_flash_micron_3d_tlc_b05a, 1
g_flash_micron_3d_tlc_b05a:
	.space	1
	.section	.bss.g_flash_micron_3d_tlc_b16a,"aw",%nobits
	.set	.LANCHOR205,. + 0
	.type	g_flash_micron_3d_tlc_b16a, %object
	.size	g_flash_micron_3d_tlc_b16a, 1
g_flash_micron_3d_tlc_b16a:
	.space	1
	.section	.bss.g_flash_micron_3d_tlc_flag,"aw",%nobits
	.set	.LANCHOR35,. + 0
	.type	g_flash_micron_3d_tlc_flag, %object
	.size	g_flash_micron_3d_tlc_flag, 1
g_flash_micron_3d_tlc_flag:
	.space	1
	.section	.bss.g_flash_multi_page_prog_en,"aw",%nobits
	.set	.LANCHOR41,. + 0
	.type	g_flash_multi_page_prog_en, %object
	.size	g_flash_multi_page_prog_en, 1
g_flash_multi_page_prog_en:
	.space	1
	.section	.bss.g_flash_multi_page_read_en,"aw",%nobits
	.set	.LANCHOR171,. + 0
	.type	g_flash_multi_page_read_en, %object
	.size	g_flash_multi_page_read_en, 1
g_flash_multi_page_read_en:
	.space	1
	.section	.bss.g_flash_page_buffer,"aw",%nobits
	.align	2
	.set	.LANCHOR167,. + 0
	.type	g_flash_page_buffer, %object
	.size	g_flash_page_buffer, 4
g_flash_page_buffer:
	.space	4
	.section	.bss.g_flash_reversd_blks,"aw",%nobits
	.set	.LANCHOR203,. + 0
	.type	g_flash_reversd_blks, %object
	.size	g_flash_reversd_blks, 1
g_flash_reversd_blks:
	.space	1
	.section	.bss.g_flash_slc_mode,"aw",%nobits
	.set	.LANCHOR0,. + 0
	.type	g_flash_slc_mode, %object
	.size	g_flash_slc_mode, 1
g_flash_slc_mode:
	.space	1
	.section	.bss.g_flash_spare_buffer,"aw",%nobits
	.align	2
	.set	.LANCHOR166,. + 0
	.type	g_flash_spare_buffer, %object
	.size	g_flash_spare_buffer, 4
g_flash_spare_buffer:
	.space	4
	.section	.bss.g_flash_sys_spare_buffer,"aw",%nobits
	.align	2
	.set	.LANCHOR197,. + 0
	.type	g_flash_sys_spare_buffer, %object
	.size	g_flash_sys_spare_buffer, 4
g_flash_sys_spare_buffer:
	.space	4
	.section	.bss.g_flash_tmp_page_buffer,"aw",%nobits
	.align	2
	.set	.LANCHOR159,. + 0
	.type	g_flash_tmp_page_buffer, %object
	.size	g_flash_tmp_page_buffer, 4
g_flash_tmp_page_buffer:
	.space	4
	.section	.bss.g_flash_tmp_spare_buffer,"aw",%nobits
	.align	2
	.set	.LANCHOR161,. + 0
	.type	g_flash_tmp_spare_buffer, %object
	.size	g_flash_tmp_spare_buffer, 4
g_flash_tmp_spare_buffer:
	.space	4
	.section	.bss.g_flash_toggle_mode_en,"aw",%nobits
	.set	.LANCHOR21,. + 0
	.type	g_flash_toggle_mode_en, %object
	.size	g_flash_toggle_mode_en, 1
g_flash_toggle_mode_en:
	.space	1
	.section	.bss.g_ftl_info_blk,"aw",%nobits
	.align	6
	.set	.LANCHOR182,. + 0
	.type	g_ftl_info_blk, %object
	.size	g_ftl_info_blk, 4
g_ftl_info_blk:
	.space	4
	.section	.bss.g_gc_info,"aw",%nobits
	.align	2
	.set	.LANCHOR64,. + 0
	.type	g_gc_info, %object
	.size	g_gc_info, 596
g_gc_info:
	.space	596
	.section	.bss.g_idb_ecc_bits,"aw",%nobits
	.set	.LANCHOR17,. + 0
	.type	g_idb_ecc_bits, %object
	.size	g_idb_ecc_bits, 1
g_idb_ecc_bits:
	.space	1
	.section	.bss.g_idb_slc_mode_enable,"aw",%nobits
	.set	.LANCHOR19,. + 0
	.type	g_idb_slc_mode_enable, %object
	.size	g_idb_slc_mode_enable, 1
g_idb_slc_mode_enable:
	.space	1
	.section	.bss.g_lsb_page_tbl,"aw",%nobits
	.align	2
	.set	.LANCHOR3,. + 0
	.type	g_lsb_page_tbl, %object
	.size	g_lsb_page_tbl, 512
g_lsb_page_tbl:
	.space	512
	.section	.bss.g_maxRegNum,"aw",%nobits
	.set	.LANCHOR26,. + 0
	.type	g_maxRegNum, %object
	.size	g_maxRegNum, 1
g_maxRegNum:
	.space	1
	.section	.bss.g_maxRetryCount,"aw",%nobits
	.set	.LANCHOR162,. + 0
	.type	g_maxRetryCount, %object
	.size	g_maxRetryCount, 1
g_maxRetryCount:
	.space	1
	.section	.bss.g_msb_page_tbl,"aw",%nobits
	.align	2
	.set	.LANCHOR140,. + 0
	.type	g_msb_page_tbl, %object
	.size	g_msb_page_tbl, 1024
g_msb_page_tbl:
	.space	1024
	.section	.bss.g_nand_max_die,"aw",%nobits
	.set	.LANCHOR18,. + 0
	.type	g_nand_max_die, %object
	.size	g_nand_max_die, 1
g_nand_max_die:
	.space	1
	.section	.bss.g_nand_opt_para,"aw",%nobits
	.set	.LANCHOR20,. + 0
	.type	g_nand_opt_para, %object
	.size	g_nand_opt_para, 32
g_nand_opt_para:
	.space	32
	.section	.bss.g_nandc_ecc_bits,"aw",%nobits
	.set	.LANCHOR46,. + 0
	.type	g_nandc_ecc_bits, %object
	.size	g_nandc_ecc_bits, 1
g_nandc_ecc_bits:
	.space	1
	.section	.bss.g_nandc_tran_timeout,"aw",%nobits
	.set	.LANCHOR160,. + 0
	.type	g_nandc_tran_timeout, %object
	.size	g_nandc_tran_timeout, 1
g_nandc_tran_timeout:
	.space	1
	.section	.bss.g_nandc_v6_master_info,"aw",%nobits
	.align	2
	.set	.LANCHOR49,. + 0
	.type	g_nandc_v6_master_info, %object
	.size	g_nandc_v6_master_info, 28
g_nandc_v6_master_info:
	.space	28
	.section	.bss.g_nandc_ver,"aw",%nobits
	.set	.LANCHOR28,. + 0
	.type	g_nandc_ver, %object
	.size	g_nandc_ver, 1
g_nandc_ver:
	.space	1
	.section	.bss.g_one_pass_program,"aw",%nobits
	.set	.LANCHOR75,. + 0
	.type	g_one_pass_program, %object
	.size	g_one_pass_program, 1
g_one_pass_program:
	.space	1
	.section	.bss.g_pm_spare,"aw",%nobits
	.align	2
	.set	.LANCHOR191,. + 0
	.type	g_pm_spare, %object
	.size	g_pm_spare, 4
g_pm_spare:
	.space	4
	.section	.bss.g_retryMode,"aw",%nobits
	.set	.LANCHOR23,. + 0
	.type	g_retryMode, %object
	.size	g_retryMode, 1
g_retryMode:
	.space	1
	.section	.bss.g_slc_mode_addr2,"aw",%nobits
	.set	.LANCHOR1,. + 0
	.type	g_slc_mode_addr2, %object
	.size	g_slc_mode_addr2, 1
g_slc_mode_addr2:
	.space	1
	.section	.bss.g_slc_mode_enable,"aw",%nobits
	.type	g_slc_mode_enable, %object
	.size	g_slc_mode_enable, 1
g_slc_mode_enable:
	.space	1
	.section	.bss.g_slc_page_num,"aw",%nobits
	.align	1
	.set	.LANCHOR142,. + 0
	.type	g_slc_page_num, %object
	.size	g_slc_page_num, 2
g_slc_page_num:
	.space	2
	.section	.bss.g_totle_phy_block,"aw",%nobits
	.align	1
	.set	.LANCHOR144,. + 0
	.type	g_totle_phy_block, %object
	.size	g_totle_phy_block, 2
g_totle_phy_block:
	.space	2
	.section	.bss.gc_des_ppa_tbl,"aw",%nobits
	.align	2
	.set	.LANCHOR157,. + 0
	.type	gc_des_ppa_tbl, %object
	.size	gc_des_ppa_tbl, 4
gc_des_ppa_tbl:
	.space	4
	.section	.bss.gc_free_slc_sblk_th,"aw",%nobits
	.align	1
	.set	.LANCHOR81,. + 0
	.type	gc_free_slc_sblk_th, %object
	.size	gc_free_slc_sblk_th, 2
gc_free_slc_sblk_th:
	.space	2
	.section	.bss.gc_lpa_tbl,"aw",%nobits
	.align	2
	.set	.LANCHOR155,. + 0
	.type	gc_lpa_tbl, %object
	.size	gc_lpa_tbl, 4
gc_lpa_tbl:
	.space	4
	.section	.bss.gc_mode,"aw",%nobits
	.set	.LANCHOR78,. + 0
	.type	gc_mode, %object
	.size	gc_mode, 1
gc_mode:
	.space	1
	.section	.bss.gc_page_buf_id,"aw",%nobits
	.align	2
	.set	.LANCHOR76,. + 0
	.type	gc_page_buf_id, %object
	.size	gc_page_buf_id, 4
gc_page_buf_id:
	.space	4
	.section	.bss.gc_pre_ppa_tbl,"aw",%nobits
	.align	2
	.set	.LANCHOR156,. + 0
	.type	gc_pre_ppa_tbl, %object
	.size	gc_pre_ppa_tbl, 4
gc_pre_ppa_tbl:
	.space	4
	.section	.bss.gc_search_count,"aw",%nobits
	.align	2
	.set	.LANCHOR154,. + 0
	.type	gc_search_count, %object
	.size	gc_search_count, 4
gc_search_count:
	.space	4
	.section	.bss.gc_slc_cache_index,"aw",%nobits
	.align	1
	.set	.LANCHOR84,. + 0
	.type	gc_slc_cache_index, %object
	.size	gc_slc_cache_index, 2
gc_slc_cache_index:
	.space	2
	.section	.bss.gc_slc_data_index,"aw",%nobits
	.align	1
	.set	.LANCHOR88,. + 0
	.type	gc_slc_data_index, %object
	.size	gc_slc_data_index, 2
gc_slc_data_index:
	.space	2
	.section	.bss.gc_slc_mode_tlc_vpn_th,"aw",%nobits
	.align	1
	.set	.LANCHOR86,. + 0
	.type	gc_slc_mode_tlc_vpn_th, %object
	.size	gc_slc_mode_tlc_vpn_th, 2
gc_slc_mode_tlc_vpn_th:
	.space	2
	.section	.bss.gc_slc_mode_vpn_th,"aw",%nobits
	.align	1
	.set	.LANCHOR63,. + 0
	.type	gc_slc_mode_vpn_th, %object
	.size	gc_slc_mode_vpn_th, 2
gc_slc_mode_vpn_th:
	.space	2
	.section	.bss.gc_state,"aw",%nobits
	.set	.LANCHOR153,. + 0
	.type	gc_state, %object
	.size	gc_state, 1
gc_state:
	.space	1
	.section	.bss.gc_tlc_mode_slc_vpn_th,"aw",%nobits
	.align	1
	.set	.LANCHOR96,. + 0
	.type	gc_tlc_mode_slc_vpn_th, %object
	.size	gc_tlc_mode_slc_vpn_th, 2
gc_tlc_mode_slc_vpn_th:
	.space	2
	.section	.bss.gc_tlc_mode_tlc_vpn_th,"aw",%nobits
	.align	1
	.set	.LANCHOR93,. + 0
	.type	gc_tlc_mode_tlc_vpn_th, %object
	.size	gc_tlc_mode_tlc_vpn_th, 2
gc_tlc_mode_tlc_vpn_th:
	.space	2
	.section	.bss.gc_valid_page_ppa,"aw",%nobits
	.align	2
	.set	.LANCHOR70,. + 0
	.type	gc_valid_page_ppa, %object
	.size	gc_valid_page_ppa, 4
gc_valid_page_ppa:
	.space	4
	.section	.bss.gc_xlc_data_index,"aw",%nobits
	.align	1
	.set	.LANCHOR85,. + 0
	.type	gc_xlc_data_index, %object
	.size	gc_xlc_data_index, 2
gc_xlc_data_index:
	.space	2
	.section	.bss.gc_xlc_search_index,"aw",%nobits
	.align	1
	.set	.LANCHOR89,. + 0
	.type	gc_xlc_search_index, %object
	.size	gc_xlc_search_index, 2
gc_xlc_search_index:
	.space	2
	.section	.bss.gp_blk_info,"aw",%nobits
	.align	2
	.set	.LANCHOR7,. + 0
	.type	gp_blk_info, %object
	.size	gp_blk_info, 4
gp_blk_info:
	.space	4
	.section	.bss.gp_data_slc_cache_head,"aw",%nobits
	.align	2
	.set	.LANCHOR83,. + 0
	.type	gp_data_slc_cache_head, %object
	.size	gp_data_slc_cache_head, 4
gp_data_slc_cache_head:
	.space	4
	.section	.bss.gp_data_slc_data_head,"aw",%nobits
	.align	2
	.set	.LANCHOR12,. + 0
	.type	gp_data_slc_data_head, %object
	.size	gp_data_slc_data_head, 4
gp_data_slc_data_head:
	.space	4
	.section	.bss.gp_data_xlc_data_head,"aw",%nobits
	.align	2
	.set	.LANCHOR82,. + 0
	.type	gp_data_xlc_data_head, %object
	.size	gp_data_xlc_data_head, 4
gp_data_xlc_data_head:
	.space	4
	.section	.bss.gp_flash_check_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR139,. + 0
	.type	gp_flash_check_buf, %object
	.size	gp_flash_check_buf, 4
gp_flash_check_buf:
	.space	4
	.section	.bss.gp_flash_info,"aw",%nobits
	.align	2
	.set	.LANCHOR27,. + 0
	.type	gp_flash_info, %object
	.size	gp_flash_info, 4
gp_flash_info:
	.space	4
	.section	.bss.gp_free_mix_head,"aw",%nobits
	.align	2
	.set	.LANCHOR102,. + 0
	.type	gp_free_mix_head, %object
	.size	gp_free_mix_head, 4
gp_free_mix_head:
	.space	4
	.section	.bss.gp_free_slc_head,"aw",%nobits
	.align	2
	.set	.LANCHOR98,. + 0
	.type	gp_free_slc_head, %object
	.size	gp_free_slc_head, 4
gp_free_slc_head:
	.space	4
	.section	.bss.gp_free_xlc_head,"aw",%nobits
	.align	2
	.set	.LANCHOR100,. + 0
	.type	gp_free_xlc_head, %object
	.size	gp_free_xlc_head, 4
gp_free_xlc_head:
	.space	4
	.section	.bss.gp_ftl_ext_info,"aw",%nobits
	.align	2
	.set	.LANCHOR10,. + 0
	.type	gp_ftl_ext_info, %object
	.size	gp_ftl_ext_info, 4
gp_ftl_ext_info:
	.space	4
	.section	.bss.gp_ftl_info,"aw",%nobits
	.align	2
	.set	.LANCHOR104,. + 0
	.type	gp_ftl_info, %object
	.size	gp_ftl_info, 4
gp_ftl_info:
	.space	4
	.section	.bss.gp_nand_para_info,"aw",%nobits
	.align	2
	.set	.LANCHOR16,. + 0
	.type	gp_nand_para_info, %object
	.size	gp_nand_para_info, 4
gp_nand_para_info:
	.space	4
	.section	.bss.gp_nandc,"aw",%nobits
	.align	2
	.set	.LANCHOR13,. + 0
	.type	gp_nandc, %object
	.size	gp_nandc, 4
gp_nandc:
	.space	4
	.section	.bss.gp_sblk_list_tbl,"aw",%nobits
	.align	2
	.set	.LANCHOR4,. + 0
	.type	gp_sblk_list_tbl, %object
	.size	gp_sblk_list_tbl, 4
gp_sblk_list_tbl:
	.space	4
	.section	.bss.idb_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR137,. + 0
	.type	idb_buf, %object
	.size	idb_buf, 4
idb_buf:
	.space	4
	.section	.bss.idb_need_write_back,"aw",%nobits
	.align	2
	.set	.LANCHOR138,. + 0
	.type	idb_need_write_back, %object
	.size	idb_need_write_back, 4
idb_need_write_back:
	.space	4
	.section	.bss.lpa_hash,"aw",%nobits
	.align	1
	.set	.LANCHOR110,. + 0
	.type	lpa_hash, %object
	.size	lpa_hash, 512
lpa_hash:
	.space	512
	.section	.bss.lpa_hash_index,"aw",%nobits
	.align	2
	.set	.LANCHOR112,. + 0
	.type	lpa_hash_index, %object
	.size	lpa_hash_index, 4
lpa_hash_index:
	.space	4
	.section	.bss.nandc_ecc_sts,"aw",%nobits
	.type	nandc_ecc_sts, %object
	.size	nandc_ecc_sts, 16
nandc_ecc_sts:
	.space	16
	.section	.bss.nandc_hw_seed,"aw",%nobits
	.set	.LANCHOR47,. + 0
	.type	nandc_hw_seed, %object
	.size	nandc_hw_seed, 1
nandc_hw_seed:
	.space	1
	.section	.bss.nandc_randomizer_en,"aw",%nobits
	.set	.LANCHOR48,. + 0
	.type	nandc_randomizer_en, %object
	.size	nandc_randomizer_en, 1
nandc_randomizer_en:
	.space	1
	.section	.bss.p_free_buf_head,"aw",%nobits
	.set	.LANCHOR53,. + 0
	.type	p_free_buf_head, %object
	.size	p_free_buf_head, 1
p_free_buf_head:
	.space	1
	.section	.bss.p_read_ahead_ext_buf,"aw",%nobits
	.align	2
	.type	p_read_ahead_ext_buf, %object
	.size	p_read_ahead_ext_buf, 4
p_read_ahead_ext_buf:
	.space	4
	.section	.bss.pm_first_write,"aw",%nobits
	.set	.LANCHOR192,. + 0
	.type	pm_first_write, %object
	.size	pm_first_write, 1
pm_first_write:
	.space	1
	.section	.bss.pm_force_gc,"aw",%nobits
	.align	2
	.set	.LANCHOR146,. + 0
	.type	pm_force_gc, %object
	.size	pm_force_gc, 4
pm_force_gc:
	.space	4
	.section	.bss.pm_gc_enable,"aw",%nobits
	.align	2
	.set	.LANCHOR132,. + 0
	.type	pm_gc_enable, %object
	.size	pm_gc_enable, 4
pm_gc_enable:
	.space	4
	.section	.bss.pm_last_load_ram_id,"aw",%nobits
	.set	.LANCHOR210,. + 0
	.type	pm_last_load_ram_id, %object
	.size	pm_last_load_ram_id, 1
pm_last_load_ram_id:
	.space	1
	.section	.bss.pm_last_update_ram_id,"aw",%nobits
	.set	.LANCHOR135,. + 0
	.type	pm_last_update_ram_id, %object
	.size	pm_last_update_ram_id, 1
pm_last_update_ram_id:
	.space	1
	.section	.bss.pm_ram_info,"aw",%nobits
	.align	2
	.set	.LANCHOR134,. + 0
	.type	pm_ram_info, %object
	.size	pm_ram_info, 256
pm_ram_info:
	.space	256
	.section	.bss.read_ahead_lpa,"aw",%nobits
	.align	2
	.set	.LANCHOR211,. + 0
	.type	read_ahead_lpa, %object
	.size	read_ahead_lpa, 4
read_ahead_lpa:
	.space	4
	.section	.bss.read_buf_count,"aw",%nobits
	.set	.LANCHOR129,. + 0
	.type	read_buf_count, %object
	.size	read_buf_count, 1
read_buf_count:
	.space	1
	.section	.bss.read_buf_head,"aw",%nobits
	.set	.LANCHOR128,. + 0
	.type	read_buf_head, %object
	.size	read_buf_head, 1
read_buf_head:
	.space	1
	.section	.bss.sblk_gc_write_completed_queue_head,"aw",%nobits
	.set	.LANCHOR71,. + 0
	.type	sblk_gc_write_completed_queue_head, %object
	.size	sblk_gc_write_completed_queue_head, 1
sblk_gc_write_completed_queue_head:
	.space	1
	.section	.bss.sblk_queue_head,"aw",%nobits
	.set	.LANCHOR56,. + 0
	.type	sblk_queue_head, %object
	.size	sblk_queue_head, 1
sblk_queue_head:
	.space	1
	.section	.bss.sblk_read_completed_queue_head,"aw",%nobits
	.set	.LANCHOR131,. + 0
	.type	sblk_read_completed_queue_head, %object
	.size	sblk_read_completed_queue_head, 1
sblk_read_completed_queue_head:
	.space	1
	.section	.bss.sblk_write_completed_queue_head,"aw",%nobits
	.set	.LANCHOR126,. + 0
	.type	sblk_write_completed_queue_head, %object
	.size	sblk_write_completed_queue_head, 1
sblk_write_completed_queue_head:
	.space	1
	.section	.bss.slc_cache_sblk,"aw",%nobits
	.align	1
	.set	.LANCHOR90,. + 0
	.type	slc_cache_sblk, %object
	.size	slc_cache_sblk, 2
slc_cache_sblk:
	.space	2
	.section	.bss.slc_data_sblk,"aw",%nobits
	.align	1
	.set	.LANCHOR92,. + 0
	.type	slc_data_sblk, %object
	.size	slc_data_sblk, 2
slc_data_sblk:
	.space	2
	.section	.bss.write_buf_count,"aw",%nobits
	.set	.LANCHOR60,. + 0
	.type	write_buf_count, %object
	.size	write_buf_count, 1
write_buf_count:
	.space	1
	.section	.bss.write_buf_head,"aw",%nobits
	.set	.LANCHOR59,. + 0
	.type	write_buf_head, %object
	.size	write_buf_head, 1
write_buf_head:
	.space	1
	.section	.bss.write_commit_count,"aw",%nobits
	.set	.LANCHOR123,. + 0
	.type	write_commit_count, %object
	.size	write_commit_count, 1
write_commit_count:
	.space	1
	.section	.bss.write_commit_head,"aw",%nobits
	.set	.LANCHOR177,. + 0
	.type	write_commit_head, %object
	.size	write_commit_head, 1
write_commit_head:
	.space	1
	.section	.bss.xlc_data_sblk,"aw",%nobits
	.align	1
	.set	.LANCHOR94,. + 0
	.type	xlc_data_sblk, %object
	.size	xlc_data_sblk, 2
xlc_data_sblk:
	.space	2
	.section	.bss.zftl_print_list_count,"aw",%nobits
	.align	1
	.set	.LANCHOR103,. + 0
	.type	zftl_print_list_count, %object
	.size	zftl_print_list_count, 2
zftl_print_list_count:
	.space	2
	.section	.data.g_nand_para_info,"aw",%progbits
	.align	1
	.set	.LANCHOR32,. + 0
	.type	g_nand_para_info, %object
	.size	g_nand_para_info, 32
g_nand_para_info:
	.byte	6
	.byte	-104
	.byte	58
	.byte	-104
	.byte	-77
	.byte	118
	.byte	114
	.byte	1
	.byte	1
	.byte	32
	.short	768
	.byte	3
	.byte	2
	.short	758
	.short	5593
	.byte	0
	.byte	37
	.byte	60
	.byte	32
	.byte	2
	.byte	1
	.byte	4
	.byte	0
	.short	256
	.byte	1
	.byte	-94
	.byte	0
	.byte	0
	.section	.data.hy_f26_ref_value,"aw",%progbits
	.set	.LANCHOR158,. + 0
	.type	hy_f26_ref_value, %object
	.size	hy_f26_ref_value, 28
hy_f26_ref_value:
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	6
	.byte	10
	.byte	6
	.byte	0
	.byte	-3
	.byte	-7
	.byte	-8
	.byte	0
	.byte	-6
	.byte	-13
	.byte	-15
	.byte	0
	.byte	-11
	.byte	-20
	.byte	-23
	.byte	0
	.byte	0
	.byte	-26
	.byte	-30
	.byte	0
	.byte	0
	.byte	-32
	.byte	-37
	.section	.data.nand_opt_para,"aw",%progbits
	.set	.LANCHOR202,. + 0
	.type	nand_opt_para, %object
	.size	nand_opt_para, 128
nand_opt_para:
	.byte	1
	.byte	0
	.byte	49
	.byte	63
	.byte	0
	.byte	49
	.byte	-128
	.byte	21
	.byte	0
	.byte	50
	.byte	17
	.byte	-128
	.byte	112
	.byte	120
	.byte	120
	.byte	3
	.byte	1
	.byte	0
	.space	14
	.byte	2
	.byte	0
	.byte	49
	.byte	63
	.byte	0
	.byte	49
	.byte	-128
	.byte	21
	.byte	0
	.byte	0
	.byte	17
	.byte	-127
	.byte	112
	.byte	-15
	.byte	-14
	.byte	0
	.byte	0
	.byte	0
	.space	14
	.byte	3
	.byte	0
	.byte	49
	.byte	63
	.byte	0
	.byte	49
	.byte	-128
	.byte	21
	.byte	96
	.byte	96
	.byte	17
	.byte	-127
	.byte	112
	.byte	-15
	.byte	-14
	.byte	0
	.byte	0
	.byte	0
	.space	14
	.byte	4
	.byte	0
	.byte	49
	.byte	63
	.byte	0
	.byte	49
	.byte	-128
	.byte	21
	.byte	96
	.byte	96
	.byte	17
	.byte	-127
	.byte	112
	.byte	112
	.byte	112
	.byte	0
	.byte	0
	.byte	0
	.space	14
	.section	.data.sd15_slc_rr,"aw",%progbits
	.set	.LANCHOR39,. + 0
	.type	sd15_slc_rr, %object
	.size	sd15_slc_rr, 25
sd15_slc_rr:
	.byte	0
	.byte	8
	.byte	-8
	.byte	16
	.byte	-16
	.byte	24
	.byte	-24
	.byte	32
	.byte	-32
	.byte	32
	.byte	-40
	.byte	48
	.byte	-48
	.byte	56
	.byte	-56
	.byte	64
	.byte	-64
	.byte	72
	.byte	-72
	.byte	80
	.byte	-80
	.byte	88
	.byte	96
	.byte	104
	.byte	112
	.section	.data.sd15_tlc_rr,"aw",%progbits
	.set	.LANCHOR38,. + 0
	.type	sd15_tlc_rr, %object
	.size	sd15_tlc_rr, 329
sd15_tlc_rr:
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	-8
	.byte	0
	.byte	16
	.byte	8
	.byte	8
	.byte	0
	.byte	-8
	.byte	-8
	.byte	-8
	.byte	-16
	.byte	-8
	.byte	-8
	.byte	-8
	.byte	-8
	.byte	-24
	.byte	0
	.byte	0
	.byte	0
	.byte	-8
	.byte	-16
	.byte	-32
	.byte	0
	.byte	8
	.byte	-8
	.byte	8
	.byte	8
	.byte	0
	.byte	0
	.byte	-16
	.byte	-8
	.byte	-8
	.byte	-8
	.byte	0
	.byte	-16
	.byte	-24
	.byte	-16
	.byte	8
	.byte	8
	.byte	-8
	.byte	-16
	.byte	-16
	.byte	0
	.byte	8
	.byte	8
	.byte	8
	.byte	8
	.byte	-8
	.byte	-8
	.byte	-24
	.byte	0
	.byte	-16
	.byte	0
	.byte	-8
	.byte	-16
	.byte	-8
	.byte	-8
	.byte	0
	.byte	8
	.byte	0
	.byte	0
	.byte	-8
	.byte	0
	.byte	-24
	.byte	-8
	.byte	0
	.byte	0
	.byte	-8
	.byte	-24
	.byte	-8
	.byte	8
	.byte	-8
	.byte	0
	.byte	-8
	.byte	8
	.byte	-16
	.byte	-8
	.byte	-8
	.byte	-8
	.byte	8
	.byte	8
	.byte	0
	.byte	0
	.byte	-8
	.byte	-8
	.byte	8
	.byte	-8
	.byte	-8
	.byte	0
	.byte	0
	.byte	-8
	.byte	-16
	.byte	-16
	.byte	-8
	.byte	0
	.byte	0
	.byte	-8
	.byte	0
	.byte	-16
	.byte	8
	.byte	0
	.byte	8
	.byte	0
	.byte	-16
	.byte	-8
	.byte	-16
	.byte	16
	.byte	0
	.byte	16
	.byte	0
	.byte	-8
	.byte	8
	.byte	0
	.byte	-24
	.byte	0
	.byte	-16
	.byte	-8
	.byte	-16
	.byte	-16
	.byte	-16
	.byte	-16
	.byte	0
	.byte	8
	.byte	-8
	.byte	-24
	.byte	0
	.byte	8
	.byte	8
	.byte	16
	.byte	16
	.byte	0
	.byte	8
	.byte	-8
	.byte	8
	.byte	16
	.byte	-8
	.byte	24
	.byte	0
	.byte	8
	.byte	-4
	.byte	0
	.byte	16
	.byte	8
	.byte	24
	.byte	8
	.byte	0
	.byte	-4
	.byte	-8
	.byte	24
	.byte	16
	.byte	16
	.byte	0
	.byte	0
	.byte	0
	.byte	-16
	.byte	0
	.byte	0
	.byte	4
	.byte	0
	.byte	-4
	.byte	-4
	.byte	-4
	.byte	8
	.byte	8
	.byte	16
	.byte	0
	.byte	16
	.byte	-4
	.byte	16
	.byte	0
	.byte	16
	.byte	8
	.byte	0
	.byte	16
	.byte	-4
	.byte	16
	.byte	-8
	.byte	0
	.byte	0
	.byte	-8
	.byte	16
	.byte	-4
	.byte	16
	.byte	-16
	.byte	-8
	.byte	-8
	.byte	-8
	.byte	8
	.byte	-4
	.byte	8
	.byte	-24
	.byte	4
	.byte	-16
	.byte	0
	.byte	8
	.byte	0
	.byte	0
	.byte	-24
	.byte	8
	.byte	-16
	.byte	8
	.byte	0
	.byte	8
	.byte	-24
	.byte	-32
	.byte	16
	.byte	-24
	.byte	8
	.byte	-8
	.byte	8
	.byte	-24
	.byte	-32
	.byte	8
	.byte	0
	.byte	16
	.byte	0
	.byte	16
	.byte	0
	.byte	-32
	.byte	4
	.byte	0
	.byte	-8
	.byte	-16
	.byte	-8
	.byte	0
	.byte	-32
	.byte	4
	.byte	0
	.byte	8
	.byte	-24
	.byte	8
	.byte	0
	.byte	-32
	.byte	4
	.byte	0
	.byte	0
	.byte	-32
	.byte	-4
	.byte	0
	.byte	-24
	.byte	4
	.byte	0
	.byte	16
	.byte	-24
	.byte	16
	.byte	0
	.byte	-24
	.byte	-4
	.byte	0
	.byte	8
	.byte	-32
	.byte	8
	.byte	0
	.byte	0
	.byte	-4
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	-4
	.byte	0
	.byte	0
	.byte	0
	.byte	-4
	.byte	0
	.byte	0
	.byte	-4
	.byte	0
	.byte	-8
	.byte	0
	.byte	-8
	.byte	0
	.byte	0
	.byte	-4
	.byte	0
	.byte	-16
	.byte	0
	.byte	-16
	.byte	0
	.byte	0
	.byte	-16
	.byte	0
	.byte	-16
	.byte	0
	.byte	-16
	.byte	0
	.byte	0
	.byte	-8
	.byte	0
	.byte	-16
	.byte	0
	.byte	-16
	.byte	0
	.byte	0
	.byte	-16
	.byte	0
	.byte	-24
	.byte	0
	.byte	-24
	.byte	0
	.byte	0
	.byte	-24
	.byte	0
	.byte	-24
	.byte	0
	.byte	-24
	.byte	0
	.byte	0
	.byte	-24
	.byte	0
	.byte	-16
	.byte	0
	.byte	-16
	.byte	0
	.byte	0
	.byte	-24
	.byte	0
	.byte	-32
	.byte	0
	.byte	-32
	.byte	0
	.section	.data.tlc_b05a_prog_tbl,"aw",%progbits
	.align	1
	.set	.LANCHOR224,. + 0
	.type	tlc_b05a_prog_tbl, %object
	.size	tlc_b05a_prog_tbl, 1536
tlc_b05a_prog_tbl:
	.short	0
	.short	0
	.short	0
	.short	0
	.short	0
	.short	0
	.short	0
	.short	0
	.short	9
	.short	0
	.short	11
	.short	0
	.short	13
	.short	0
	.short	15
	.short	0
	.short	17
	.short	0
	.short	19
	.short	0
	.short	21
	.short	0
	.short	23
	.short	0
	.short	25
	.short	0
	.short	27
	.short	0
	.short	29
	.short	0
	.short	31
	.short	0
	.short	33
	.short	0
	.short	35
	.short	0
	.short	37
	.short	0
	.short	39
	.short	0
	.short	41
	.short	0
	.short	43
	.short	0
	.short	45
	.short	0
	.short	47
	.short	0
	.short	49
	.short	0
	.short	51
	.short	0
	.short	53
	.short	0
	.short	55
	.short	0
	.short	25
	.short	58
	.short	0
	.short	27
	.short	61
	.short	0
	.short	29
	.short	64
	.short	0
	.short	31
	.short	67
	.short	0
	.short	33
	.short	70
	.short	0
	.short	35
	.short	73
	.short	0
	.short	37
	.short	76
	.short	0
	.short	39
	.short	79
	.short	0
	.short	41
	.short	82
	.short	0
	.short	43
	.short	85
	.short	0
	.short	45
	.short	88
	.short	0
	.short	47
	.short	91
	.short	0
	.short	49
	.short	94
	.short	0
	.short	51
	.short	97
	.short	0
	.short	53
	.short	100
	.short	0
	.short	55
	.short	103
	.short	0
	.short	58
	.short	106
	.short	0
	.short	61
	.short	109
	.short	0
	.short	64
	.short	112
	.short	0
	.short	67
	.short	115
	.short	0
	.short	70
	.short	118
	.short	0
	.short	73
	.short	121
	.short	0
	.short	76
	.short	124
	.short	0
	.short	79
	.short	127
	.short	0
	.short	82
	.short	130
	.short	0
	.short	85
	.short	133
	.short	0
	.short	88
	.short	136
	.short	0
	.short	91
	.short	139
	.short	0
	.short	94
	.short	142
	.short	0
	.short	97
	.short	145
	.short	0
	.short	100
	.short	148
	.short	0
	.short	103
	.short	151
	.short	0
	.short	106
	.short	154
	.short	0
	.short	109
	.short	157
	.short	0
	.short	112
	.short	160
	.short	0
	.short	115
	.short	163
	.short	0
	.short	118
	.short	166
	.short	0
	.short	121
	.short	169
	.short	0
	.short	124
	.short	172
	.short	0
	.short	127
	.short	175
	.short	0
	.short	130
	.short	178
	.short	0
	.short	133
	.short	181
	.short	0
	.short	136
	.short	184
	.short	0
	.short	139
	.short	187
	.short	0
	.short	142
	.short	190
	.short	0
	.short	145
	.short	193
	.short	0
	.short	148
	.short	196
	.short	0
	.short	151
	.short	199
	.short	0
	.short	154
	.short	202
	.short	0
	.short	157
	.short	205
	.short	0
	.short	160
	.short	208
	.short	0
	.short	163
	.short	211
	.short	0
	.short	166
	.short	214
	.short	0
	.short	169
	.short	217
	.short	0
	.short	172
	.short	220
	.short	0
	.short	175
	.short	223
	.short	0
	.short	178
	.short	226
	.short	0
	.short	181
	.short	229
	.short	0
	.short	184
	.short	232
	.short	0
	.short	187
	.short	235
	.short	0
	.short	190
	.short	238
	.short	0
	.short	193
	.short	241
	.short	0
	.short	196
	.short	244
	.short	0
	.short	199
	.short	247
	.short	0
	.short	202
	.short	250
	.short	0
	.short	205
	.short	253
	.short	0
	.short	208
	.short	256
	.short	0
	.short	211
	.short	259
	.short	0
	.short	214
	.short	262
	.short	0
	.short	217
	.short	265
	.short	0
	.short	220
	.short	268
	.short	0
	.short	223
	.short	271
	.short	0
	.short	226
	.short	274
	.short	0
	.short	229
	.short	277
	.short	0
	.short	232
	.short	280
	.short	0
	.short	235
	.short	283
	.short	0
	.short	238
	.short	286
	.short	0
	.short	241
	.short	289
	.short	0
	.short	244
	.short	292
	.short	0
	.short	247
	.short	295
	.short	0
	.short	250
	.short	298
	.short	0
	.short	253
	.short	301
	.short	0
	.short	256
	.short	304
	.short	0
	.short	259
	.short	307
	.short	0
	.short	262
	.short	310
	.short	0
	.short	265
	.short	313
	.short	0
	.short	268
	.short	316
	.short	0
	.short	271
	.short	319
	.short	0
	.short	274
	.short	322
	.short	0
	.short	277
	.short	325
	.short	0
	.short	280
	.short	328
	.short	0
	.short	283
	.short	331
	.short	0
	.short	286
	.short	334
	.short	0
	.short	289
	.short	337
	.short	0
	.short	292
	.short	340
	.short	0
	.short	295
	.short	343
	.short	0
	.short	298
	.short	346
	.short	0
	.short	301
	.short	349
	.short	0
	.short	304
	.short	352
	.short	0
	.short	307
	.short	355
	.short	0
	.short	310
	.short	358
	.short	0
	.short	313
	.short	361
	.short	0
	.short	316
	.short	364
	.short	0
	.short	319
	.short	367
	.short	0
	.short	322
	.short	370
	.short	0
	.short	325
	.short	373
	.short	0
	.short	328
	.short	376
	.short	0
	.short	331
	.short	379
	.short	0
	.short	334
	.short	382
	.short	0
	.short	337
	.short	385
	.short	0
	.short	340
	.short	388
	.short	0
	.short	343
	.short	391
	.short	0
	.short	346
	.short	394
	.short	0
	.short	349
	.short	397
	.short	0
	.short	352
	.short	400
	.short	0
	.short	355
	.short	403
	.short	0
	.short	358
	.short	406
	.short	0
	.short	361
	.short	409
	.short	0
	.short	364
	.short	412
	.short	0
	.short	367
	.short	415
	.short	0
	.short	370
	.short	418
	.short	0
	.short	373
	.short	421
	.short	0
	.short	376
	.short	424
	.short	0
	.short	379
	.short	427
	.short	0
	.short	382
	.short	430
	.short	0
	.short	385
	.short	433
	.short	0
	.short	388
	.short	436
	.short	0
	.short	391
	.short	439
	.short	0
	.short	394
	.short	442
	.short	0
	.short	397
	.short	445
	.short	0
	.short	400
	.short	448
	.short	0
	.short	403
	.short	451
	.short	0
	.short	406
	.short	454
	.short	0
	.short	409
	.short	457
	.short	0
	.short	412
	.short	460
	.short	0
	.short	415
	.short	463
	.short	0
	.short	418
	.short	466
	.short	0
	.short	421
	.short	469
	.short	0
	.short	424
	.short	472
	.short	0
	.short	427
	.short	475
	.short	0
	.short	430
	.short	478
	.short	0
	.short	433
	.short	481
	.short	0
	.short	436
	.short	484
	.short	0
	.short	439
	.short	487
	.short	0
	.short	442
	.short	490
	.short	0
	.short	445
	.short	493
	.short	0
	.short	448
	.short	496
	.short	0
	.short	451
	.short	499
	.short	0
	.short	454
	.short	502
	.short	0
	.short	457
	.short	505
	.short	0
	.short	460
	.short	508
	.short	0
	.short	463
	.short	511
	.short	0
	.short	466
	.short	514
	.short	0
	.short	469
	.short	517
	.short	0
	.short	472
	.short	520
	.short	0
	.short	475
	.short	523
	.short	0
	.short	478
	.short	526
	.short	0
	.short	481
	.short	529
	.short	0
	.short	484
	.short	532
	.short	0
	.short	487
	.short	535
	.short	0
	.short	490
	.short	538
	.short	0
	.short	493
	.short	541
	.short	0
	.short	496
	.short	544
	.short	0
	.short	499
	.short	547
	.short	0
	.short	502
	.short	550
	.short	0
	.short	505
	.short	553
	.short	0
	.short	508
	.short	556
	.short	0
	.short	511
	.short	559
	.short	0
	.short	514
	.short	562
	.short	0
	.short	517
	.short	565
	.short	0
	.short	520
	.short	568
	.short	0
	.short	523
	.short	571
	.short	0
	.short	526
	.short	574
	.short	0
	.short	529
	.short	577
	.short	0
	.short	532
	.short	580
	.short	0
	.short	535
	.short	583
	.short	0
	.short	538
	.short	586
	.short	0
	.short	541
	.short	589
	.short	0
	.short	544
	.short	592
	.short	0
	.short	547
	.short	595
	.short	0
	.short	550
	.short	598
	.short	0
	.short	553
	.short	601
	.short	0
	.short	556
	.short	604
	.short	0
	.short	559
	.short	607
	.short	0
	.short	562
	.short	610
	.short	0
	.short	565
	.short	613
	.short	0
	.short	568
	.short	616
	.short	0
	.short	571
	.short	619
	.short	0
	.short	574
	.short	622
	.short	0
	.short	577
	.short	625
	.short	0
	.short	580
	.short	628
	.short	0
	.short	583
	.short	631
	.short	0
	.short	586
	.short	634
	.short	0
	.short	589
	.short	637
	.short	0
	.short	592
	.short	640
	.short	0
	.short	595
	.short	643
	.short	0
	.short	598
	.short	646
	.short	0
	.short	601
	.short	649
	.short	0
	.short	604
	.short	652
	.short	0
	.short	607
	.short	655
	.short	0
	.short	610
	.short	658
	.short	0
	.short	613
	.short	661
	.short	0
	.short	616
	.short	664
	.short	0
	.short	619
	.short	667
	.short	0
	.short	622
	.short	670
	.short	0
	.short	625
	.short	673
	.short	0
	.short	628
	.short	676
	.short	0
	.short	631
	.short	679
	.short	0
	.short	634
	.short	682
	.short	0
	.short	637
	.short	685
	.short	0
	.short	640
	.short	688
	.short	0
	.short	643
	.short	691
	.short	0
	.short	646
	.short	694
	.short	0
	.short	649
	.short	697
	.short	0
	.short	652
	.short	700
	.short	0
	.short	655
	.short	703
	.short	0
	.short	658
	.short	706
	.short	0
	.short	661
	.short	709
	.short	0
	.short	664
	.short	712
	.short	0
	.short	667
	.short	715
	.short	0
	.short	670
	.short	718
	.short	0
	.short	673
	.short	721
	.short	0
	.short	676
	.short	724
	.short	0
	.short	679
	.short	727
	.short	0
	.short	682
	.short	730
	.short	0
	.short	685
	.short	733
	.short	0
	.short	688
	.short	736
	.short	0
	.short	691
	.short	739
	.short	0
	.short	694
	.short	742
	.short	0
	.short	697
	.short	745
	.short	0
	.short	700
	.short	748
	.short	0
	.short	703
	.short	751
	.short	0
	.short	706
	.short	0
	.short	709
	.short	0
	.short	712
	.short	0
	.short	715
	.short	0
	.short	718
	.short	0
	.short	721
	.short	0
	.short	724
	.short	0
	.short	727
	.short	0
	.section	.data.tlc_prog_order,"aw",%progbits
	.align	1
	.set	.LANCHOR225,. + 0
	.type	tlc_prog_order, %object
	.size	tlc_prog_order, 768
tlc_prog_order:
	.short	1
	.short	9
	.short	2
	.short	17
	.short	10
	.short	3
	.short	25
	.short	18
	.short	11
	.short	33
	.short	26
	.short	19
	.short	41
	.short	34
	.short	27
	.short	49
	.short	42
	.short	35
	.short	57
	.short	50
	.short	43
	.short	65
	.short	58
	.short	51
	.short	73
	.short	66
	.short	59
	.short	81
	.short	74
	.short	67
	.short	89
	.short	82
	.short	75
	.short	97
	.short	90
	.short	83
	.short	105
	.short	98
	.short	91
	.short	113
	.short	106
	.short	99
	.short	121
	.short	114
	.short	107
	.short	129
	.short	122
	.short	115
	.short	137
	.short	130
	.short	123
	.short	145
	.short	138
	.short	131
	.short	153
	.short	146
	.short	139
	.short	161
	.short	154
	.short	147
	.short	169
	.short	162
	.short	155
	.short	177
	.short	170
	.short	163
	.short	185
	.short	178
	.short	171
	.short	193
	.short	186
	.short	179
	.short	201
	.short	194
	.short	187
	.short	209
	.short	202
	.short	195
	.short	217
	.short	210
	.short	203
	.short	225
	.short	218
	.short	211
	.short	233
	.short	226
	.short	219
	.short	241
	.short	234
	.short	227
	.short	249
	.short	242
	.short	235
	.short	257
	.short	250
	.short	243
	.short	265
	.short	258
	.short	251
	.short	273
	.short	266
	.short	259
	.short	281
	.short	274
	.short	267
	.short	289
	.short	282
	.short	275
	.short	297
	.short	290
	.short	283
	.short	305
	.short	298
	.short	291
	.short	313
	.short	306
	.short	299
	.short	321
	.short	314
	.short	307
	.short	329
	.short	322
	.short	315
	.short	337
	.short	330
	.short	323
	.short	345
	.short	338
	.short	331
	.short	353
	.short	346
	.short	339
	.short	361
	.short	354
	.short	347
	.short	369
	.short	362
	.short	355
	.short	377
	.short	370
	.short	363
	.short	385
	.short	378
	.short	371
	.short	393
	.short	386
	.short	379
	.short	401
	.short	394
	.short	387
	.short	409
	.short	402
	.short	395
	.short	417
	.short	410
	.short	403
	.short	425
	.short	418
	.short	411
	.short	433
	.short	426
	.short	419
	.short	441
	.short	434
	.short	427
	.short	449
	.short	442
	.short	435
	.short	457
	.short	450
	.short	443
	.short	465
	.short	458
	.short	451
	.short	473
	.short	466
	.short	459
	.short	481
	.short	474
	.short	467
	.short	489
	.short	482
	.short	475
	.short	497
	.short	490
	.short	483
	.short	505
	.short	498
	.short	491
	.short	513
	.short	506
	.short	499
	.short	521
	.short	514
	.short	507
	.short	529
	.short	522
	.short	515
	.short	537
	.short	530
	.short	523
	.short	545
	.short	538
	.short	531
	.short	553
	.short	546
	.short	539
	.short	561
	.short	554
	.short	547
	.short	569
	.short	562
	.short	555
	.short	577
	.short	570
	.short	563
	.short	585
	.short	578
	.short	571
	.short	593
	.short	586
	.short	579
	.short	601
	.short	594
	.short	587
	.short	609
	.short	602
	.short	595
	.short	617
	.short	610
	.short	603
	.short	625
	.short	618
	.short	611
	.short	633
	.short	626
	.short	619
	.short	641
	.short	634
	.short	627
	.short	649
	.short	642
	.short	635
	.short	657
	.short	650
	.short	643
	.short	665
	.short	658
	.short	651
	.short	673
	.short	666
	.short	659
	.short	681
	.short	674
	.short	667
	.short	689
	.short	682
	.short	675
	.short	697
	.short	690
	.short	683
	.short	705
	.short	698
	.short	691
	.short	713
	.short	706
	.short	699
	.short	721
	.short	714
	.short	707
	.short	729
	.short	722
	.short	715
	.short	737
	.short	730
	.short	723
	.short	745
	.short	738
	.short	731
	.short	753
	.short	746
	.short	739
	.short	761
	.short	754
	.short	747
	.short	769
	.short	762
	.short	755
	.short	777
	.short	770
	.short	763
	.short	785
	.short	778
	.short	771
	.short	793
	.short	786
	.short	779
	.short	801
	.short	794
	.short	787
	.short	809
	.short	802
	.short	795
	.short	817
	.short	810
	.short	803
	.short	825
	.short	818
	.short	811
	.short	833
	.short	826
	.short	819
	.short	841
	.short	834
	.short	827
	.short	849
	.short	842
	.short	835
	.short	857
	.short	850
	.short	843
	.short	865
	.short	858
	.short	851
	.short	873
	.short	866
	.short	859
	.short	881
	.short	874
	.short	867
	.short	889
	.short	882
	.short	875
	.short	897
	.short	890
	.short	883
	.short	905
	.short	898
	.short	891
	.short	913
	.short	906
	.short	899
	.short	921
	.short	914
	.short	907
	.short	929
	.short	922
	.short	915
	.short	937
	.short	930
	.short	923
	.short	945
	.short	938
	.short	931
	.short	953
	.short	946
	.short	939
	.short	961
	.short	954
	.short	947
	.short	969
	.short	962
	.short	955
	.short	977
	.short	970
	.short	963
	.short	985
	.short	978
	.short	971
	.short	993
	.short	986
	.short	979
	.short	1001
	.short	994
	.short	987
	.short	1009
	.short	1002
	.short	995
	.short	1017
	.short	1010
	.short	1003
	.short	1018
	.short	1011
	.short	1019
	.section	.data.zftl_debug,"aw",%progbits
	.align	2
	.set	.LANCHOR14,. + 0
	.type	zftl_debug, %object
	.size	zftl_debug, 4
zftl_debug:
	.word	17476
	.section	.data.zftl_nand_flash_para_tbl,"aw",%progbits
	.align	1
	.set	.LANCHOR201,. + 0
	.type	zftl_nand_flash_para_tbl, %object
	.size	zftl_nand_flash_para_tbl, 1408
zftl_nand_flash_para_tbl:
	.byte	6
	.byte	-104
	.byte	58
	.byte	-104
	.byte	-77
	.byte	118
	.byte	114
	.byte	1
	.byte	1
	.byte	32
	.short	768
	.byte	3
	.byte	2
	.short	758
	.short	5593
	.byte	0
	.byte	37
	.byte	60
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.short	256
	.byte	1
	.byte	-94
	.byte	0
	.byte	0
	.byte	6
	.byte	-104
	.byte	60
	.byte	-104
	.byte	-77
	.byte	118
	.byte	114
	.byte	1
	.byte	1
	.byte	32
	.short	768
	.byte	3
	.byte	2
	.short	1478
	.short	5593
	.byte	0
	.byte	37
	.byte	60
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.short	256
	.byte	1
	.byte	-94
	.byte	0
	.byte	0
	.byte	6
	.byte	-104
	.byte	58
	.byte	-104
	.byte	-93
	.byte	118
	.byte	81
	.byte	1
	.byte	1
	.byte	32
	.short	384
	.byte	3
	.byte	2
	.short	1446
	.short	1497
	.byte	0
	.byte	36
	.byte	60
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.short	256
	.byte	1
	.byte	-94
	.byte	0
	.byte	0
	.byte	6
	.byte	-104
	.byte	-34
	.byte	-108
	.byte	-109
	.byte	118
	.byte	81
	.byte	1
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	2
	.short	1074
	.short	17881
	.byte	2
	.byte	35
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.short	256
	.byte	1
	.byte	-94
	.byte	0
	.byte	0
	.byte	6
	.byte	-104
	.byte	-34
	.byte	-124
	.byte	-109
	.byte	114
	.byte	87
	.byte	1
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	1
	.short	2092
	.short	17857
	.byte	2
	.byte	33
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	1
	.byte	0
	.short	256
	.byte	1
	.byte	-94
	.byte	0
	.byte	0
	.byte	6
	.byte	-104
	.byte	58
	.byte	-108
	.byte	-109
	.byte	118
	.byte	81
	.byte	1
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	2
	.short	2106
	.short	17881
	.byte	2
	.byte	35
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.short	256
	.byte	1
	.byte	-94
	.byte	0
	.byte	0
	.byte	6
	.byte	-104
	.byte	-41
	.byte	-124
	.byte	-109
	.byte	114
	.byte	81
	.byte	1
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	1
	.short	1056
	.short	17857
	.byte	2
	.byte	35
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.short	256
	.byte	1
	.byte	-94
	.byte	0
	.byte	0
	.byte	6
	.byte	-104
	.byte	-41
	.byte	-124
	.byte	-109
	.byte	114
	.byte	80
	.byte	1
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	1
	.short	1060
	.short	17857
	.byte	2
	.byte	34
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.short	256
	.byte	1
	.byte	-94
	.byte	0
	.byte	0
	.byte	6
	.byte	-104
	.byte	-34
	.byte	-108
	.byte	-109
	.byte	118
	.byte	80
	.byte	1
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	2
	.short	1066
	.short	17881
	.byte	2
	.byte	34
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	1
	.byte	0
	.short	256
	.byte	1
	.byte	-94
	.byte	0
	.byte	0
	.byte	6
	.byte	-104
	.byte	-41
	.byte	-124
	.byte	-109
	.byte	114
	.byte	87
	.byte	1
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	1
	.short	1060
	.short	17857
	.byte	2
	.byte	33
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	1
	.byte	0
	.short	256
	.byte	1
	.byte	-94
	.byte	0
	.byte	0
	.byte	6
	.byte	-104
	.byte	-34
	.byte	-108
	.byte	-109
	.byte	118
	.byte	87
	.byte	1
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	2
	.short	1058
	.short	17881
	.byte	2
	.byte	33
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	1
	.byte	0
	.short	256
	.byte	1
	.byte	-94
	.byte	0
	.byte	0
	.byte	6
	.byte	69
	.byte	58
	.byte	-108
	.byte	-109
	.byte	118
	.byte	81
	.byte	8
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	2
	.short	2106
	.short	17881
	.byte	2
	.byte	68
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.short	256
	.byte	1
	.byte	-94
	.byte	0
	.byte	0
	.byte	6
	.byte	69
	.byte	-34
	.byte	-108
	.byte	-109
	.byte	118
	.byte	81
	.byte	8
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	2
	.short	1074
	.short	17881
	.byte	2
	.byte	68
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.short	256
	.byte	1
	.byte	-94
	.byte	0
	.byte	0
	.byte	6
	.byte	69
	.byte	-34
	.byte	-108
	.byte	-109
	.byte	118
	.byte	87
	.byte	8
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	2
	.short	1058
	.short	17881
	.byte	2
	.byte	66
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.short	256
	.byte	1
	.byte	-94
	.byte	0
	.byte	0
	.byte	6
	.byte	69
	.byte	-34
	.byte	-108
	.byte	-109
	.byte	118
	.byte	80
	.byte	8
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	2
	.short	1066
	.short	17881
	.byte	2
	.byte	67
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	1
	.byte	0
	.short	256
	.byte	1
	.byte	-94
	.byte	0
	.byte	0
	.byte	6
	.byte	69
	.byte	-41
	.byte	-124
	.byte	-109
	.byte	114
	.byte	87
	.byte	8
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	1
	.short	1060
	.short	17857
	.byte	2
	.byte	66
	.byte	40
	.byte	32
	.byte	2
	.byte	1
	.byte	1
	.byte	0
	.short	256
	.byte	1
	.byte	-94
	.byte	0
	.byte	0
	.byte	5
	.byte	44
	.byte	100
	.byte	68
	.byte	50
	.byte	-91
	.byte	0
	.byte	4
	.byte	1
	.byte	32
	.short	512
	.byte	2
	.byte	1
	.short	1048
	.short	9671
	.byte	5
	.byte	19
	.byte	70
	.byte	32
	.byte	1
	.byte	0
	.byte	4
	.byte	0
	.short	512
	.byte	1
	.byte	-38
	.byte	-33
	.byte	0
	.byte	5
	.byte	44
	.byte	100
	.byte	100
	.byte	86
	.byte	-91
	.byte	0
	.byte	4
	.byte	1
	.byte	24
	.short	512
	.byte	2
	.byte	2
	.short	700
	.short	479
	.byte	4
	.byte	18
	.byte	60
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.short	512
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.byte	5
	.byte	44
	.byte	68
	.byte	68
	.byte	75
	.byte	-87
	.byte	0
	.byte	4
	.byte	1
	.byte	16
	.short	256
	.byte	2
	.byte	2
	.short	1064
	.short	479
	.byte	3
	.byte	17
	.byte	40
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.short	256
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.byte	5
	.byte	44
	.byte	-124
	.byte	100
	.byte	84
	.byte	-87
	.byte	0
	.byte	4
	.byte	1
	.byte	32
	.short	512
	.byte	2
	.byte	2
	.short	1024
	.short	479
	.byte	4
	.byte	18
	.byte	60
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.short	512
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	5
	.byte	44
	.byte	100
	.byte	100
	.byte	84
	.byte	-92
	.byte	0
	.byte	4
	.byte	1
	.byte	32
	.short	512
	.byte	2
	.byte	1
	.short	1024
	.short	455
	.byte	4
	.byte	18
	.byte	60
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.short	512
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	5
	.byte	44
	.byte	100
	.byte	68
	.byte	75
	.byte	-87
	.byte	0
	.byte	4
	.byte	1
	.byte	16
	.short	256
	.byte	2
	.byte	4
	.short	1024
	.short	449
	.byte	3
	.byte	17
	.byte	40
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.short	256
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.byte	5
	.byte	44
	.byte	-124
	.byte	100
	.byte	60
	.byte	-91
	.byte	0
	.byte	4
	.byte	1
	.byte	32
	.short	512
	.byte	2
	.byte	2
	.short	1024
	.short	479
	.byte	3
	.byte	17
	.byte	40
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.short	512
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.byte	5
	.byte	44
	.byte	-124
	.byte	68
	.byte	52
	.byte	-92
	.byte	0
	.byte	4
	.byte	1
	.byte	32
	.short	512
	.byte	2
	.byte	1
	.short	2184
	.short	9671
	.byte	5
	.byte	19
	.byte	70
	.byte	32
	.byte	1
	.byte	0
	.byte	4
	.byte	0
	.short	512
	.byte	2
	.byte	-38
	.byte	-33
	.byte	0
	.byte	5
	.byte	44
	.byte	100
	.byte	100
	.byte	60
	.byte	-91
	.byte	0
	.byte	4
	.byte	1
	.byte	32
	.short	512
	.byte	2
	.byte	1
	.short	1044
	.short	471
	.byte	3
	.byte	17
	.byte	40
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.short	512
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.byte	5
	.byte	44
	.byte	-124
	.byte	68
	.byte	50
	.byte	-86
	.byte	0
	.byte	4
	.byte	1
	.byte	32
	.short	512
	.byte	2
	.byte	1
	.short	2184
	.short	9671
	.byte	5
	.byte	19
	.byte	70
	.byte	32
	.byte	1
	.byte	0
	.byte	4
	.byte	0
	.short	512
	.byte	2
	.byte	-38
	.byte	-33
	.byte	0
	.byte	5
	.byte	44
	.byte	-124
	.byte	-60
	.byte	52
	.byte	-86
	.byte	0
	.byte	4
	.byte	1
	.byte	32
	.short	512
	.byte	2
	.byte	1
	.short	2184
	.short	9671
	.byte	5
	.byte	19
	.byte	70
	.byte	32
	.byte	1
	.byte	0
	.byte	4
	.byte	0
	.short	512
	.byte	2
	.byte	-38
	.byte	-33
	.byte	0
	.byte	5
	.byte	44
	.byte	-124
	.byte	68
	.byte	52
	.byte	-86
	.byte	0
	.byte	4
	.byte	1
	.byte	32
	.short	512
	.byte	2
	.byte	1
	.short	2184
	.short	9671
	.byte	5
	.byte	19
	.byte	70
	.byte	32
	.byte	1
	.byte	0
	.byte	4
	.byte	0
	.short	512
	.byte	2
	.byte	-38
	.byte	-33
	.byte	0
	.byte	6
	.byte	-101
	.byte	73
	.byte	1
	.byte	0
	.byte	-101
	.byte	73
	.byte	9
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	1
	.short	2144
	.short	-23097
	.byte	8
	.byte	21
	.byte	70
	.byte	32
	.byte	1
	.byte	0
	.byte	8
	.byte	0
	.short	256
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.byte	5
	.byte	44
	.byte	-124
	.byte	100
	.byte	60
	.byte	-87
	.byte	4
	.byte	4
	.byte	1
	.byte	32
	.short	512
	.byte	2
	.byte	2
	.short	1024
	.short	479
	.byte	3
	.byte	17
	.byte	40
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.short	512
	.byte	0
	.byte	0
	.byte	0
	.byte	1
	.byte	5
	.byte	44
	.byte	-124
	.byte	88
	.byte	50
	.byte	-95
	.byte	0
	.byte	4
	.byte	1
	.byte	32
	.short	768
	.byte	3
	.byte	1
	.short	1440
	.short	3527
	.byte	0
	.byte	19
	.byte	70
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.short	1024
	.byte	3
	.byte	0
	.byte	0
	.byte	2
	.byte	6
	.byte	44
	.byte	-92
	.byte	8
	.byte	50
	.byte	-95
	.byte	0
	.byte	4
	.byte	1
	.byte	32
	.short	2304
	.byte	3
	.byte	1
	.short	1008
	.short	3521
	.byte	0
	.byte	19
	.byte	70
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.short	4096
	.byte	3
	.byte	0
	.byte	0
	.byte	4
	.byte	6
	.byte	-83
	.byte	-34
	.byte	20
	.byte	-85
	.byte	66
	.byte	74
	.byte	2
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	2
	.short	1056
	.short	455
	.byte	2
	.byte	6
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.short	256
	.byte	2
	.byte	-65
	.byte	-66
	.byte	0
	.byte	6
	.byte	-83
	.byte	-34
	.byte	-108
	.byte	-21
	.byte	116
	.byte	68
	.byte	2
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	2
	.short	1066
	.short	473
	.byte	1
	.byte	7
	.byte	40
	.byte	32
	.byte	4
	.byte	1
	.byte	3
	.byte	0
	.short	256
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	6
	.byte	-83
	.byte	-34
	.byte	20
	.byte	-89
	.byte	66
	.byte	74
	.byte	2
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	2
	.short	1060
	.short	473
	.byte	2
	.byte	5
	.byte	40
	.byte	32
	.byte	4
	.byte	1
	.byte	3
	.byte	0
	.short	256
	.byte	2
	.byte	-65
	.byte	-66
	.byte	0
	.byte	6
	.byte	-83
	.byte	-41
	.byte	-108
	.byte	-111
	.byte	96
	.byte	68
	.byte	2
	.byte	1
	.byte	16
	.short	256
	.byte	2
	.byte	2
	.short	1046
	.short	473
	.byte	1
	.byte	3
	.byte	40
	.byte	32
	.byte	4
	.byte	1
	.byte	3
	.byte	0
	.short	256
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	6
	.byte	-83
	.byte	58
	.byte	20
	.byte	-85
	.byte	66
	.byte	74
	.byte	2
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	2
	.short	2092
	.short	473
	.byte	2
	.byte	5
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	3
	.byte	0
	.short	256
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	6
	.byte	-83
	.byte	-41
	.byte	20
	.byte	-98
	.byte	52
	.byte	74
	.byte	2
	.byte	1
	.byte	16
	.short	256
	.byte	2
	.byte	2
	.short	1056
	.short	473
	.byte	2
	.byte	5
	.byte	40
	.byte	32
	.byte	4
	.byte	1
	.byte	3
	.byte	0
	.short	256
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	6
	.byte	-83
	.byte	58
	.byte	20
	.byte	3
	.byte	8
	.byte	80
	.byte	2
	.byte	1
	.byte	32
	.short	388
	.byte	2
	.byte	2
	.short	1362
	.short	473
	.byte	9
	.byte	8
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.short	512
	.byte	2
	.byte	-65
	.byte	-66
	.byte	0
	.byte	5
	.byte	-119
	.byte	100
	.byte	100
	.byte	60
	.byte	-95
	.byte	0
	.byte	7
	.byte	1
	.byte	32
	.short	512
	.byte	2
	.byte	1
	.short	1024
	.short	455
	.byte	4
	.byte	17
	.byte	40
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.short	512
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.byte	5
	.byte	-119
	.byte	-124
	.byte	100
	.byte	60
	.byte	-91
	.byte	0
	.byte	7
	.byte	1
	.byte	32
	.short	512
	.byte	2
	.byte	2
	.short	1024
	.short	455
	.byte	4
	.byte	17
	.byte	40
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.short	512
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.byte	6
	.byte	-119
	.byte	100
	.byte	68
	.byte	75
	.byte	-87
	.byte	0
	.byte	7
	.byte	1
	.byte	16
	.short	256
	.byte	2
	.byte	4
	.short	1024
	.short	449
	.byte	3
	.byte	17
	.byte	40
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.short	256
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	6
	.byte	-119
	.byte	-120
	.byte	36
	.byte	75
	.byte	-87
	.byte	-124
	.byte	7
	.byte	1
	.byte	16
	.short	256
	.byte	2
	.byte	4
	.short	1024
	.short	449
	.byte	3
	.byte	17
	.byte	40
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.short	256
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	6
	.byte	-119
	.byte	-92
	.byte	8
	.byte	50
	.byte	-95
	.byte	0
	.byte	7
	.byte	1
	.byte	32
	.short	2304
	.byte	3
	.byte	1
	.short	1008
	.short	3521
	.byte	0
	.byte	19
	.byte	70
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.short	4096
	.byte	3
	.byte	0
	.byte	0
	.byte	4
	.section	.rodata.__func__.10144,"a",%progbits
	.set	.LANCHOR141,. + 0
	.type	__func__.10144, %object
	.size	__func__.10144, 20
__func__.10144:
	.ascii	"flash_die_info_init\000"
	.section	.rodata.__func__.10154,"a",%progbits
	.set	.LANCHOR15,. + 0
	.type	__func__.10154, %object
	.size	__func__.10154, 22
__func__.10154:
	.ascii	"nand_flash_print_info\000"
	.section	.rodata.__func__.10199,"a",%progbits
	.set	.LANCHOR200,. + 0
	.type	__func__.10199, %object
	.size	__func__.10199, 16
__func__.10199:
	.ascii	"nand_flash_init\000"
	.section	.rodata.__func__.10222,"a",%progbits
	.set	.LANCHOR152,. + 0
	.type	__func__.10222, %object
	.size	__func__.10222, 11
__func__.10222:
	.ascii	"nandc_init\000"
	.section	.rodata.__func__.10391,"a",%progbits
	.set	.LANCHOR55,. + 0
	.type	__func__.10391, %object
	.size	__func__.10391, 13
__func__.10391:
	.ascii	"buf_add_tail\000"
	.section	.rodata.__func__.10404,"a",%progbits
	.set	.LANCHOR57,. + 0
	.type	__func__.10404, %object
	.size	__func__.10404, 10
__func__.10404:
	.ascii	"buf_alloc\000"
	.section	.rodata.__func__.10418,"a",%progbits
	.set	.LANCHOR58,. + 0
	.type	__func__.10418, %object
	.size	__func__.10418, 16
__func__.10418:
	.ascii	"buf_remove_free\000"
	.section	.rodata.__func__.10431,"a",%progbits
	.set	.LANCHOR199,. + 0
	.type	__func__.10431, %object
	.size	__func__.10431, 20
__func__.10431:
	.ascii	"flash_info_blk_init\000"
	.section	.rodata.__func__.10442,"a",%progbits
	.set	.LANCHOR151,. + 0
	.type	__func__.10442, %object
	.size	__func__.10442, 21
__func__.10442:
	.ascii	"flash_info_data_init\000"
	.section	.rodata.__func__.10464,"a",%progbits
	.set	.LANCHOR196,. + 0
	.type	__func__.10464, %object
	.size	__func__.10464, 17
__func__.10464:
	.ascii	"flash_info_flush\000"
	.section	.rodata.__func__.10540,"a",%progbits
	.set	.LANCHOR145,. + 0
	.type	__func__.10540, %object
	.size	__func__.10540, 17
__func__.10540:
	.ascii	"lpa_rebuild_hash\000"
	.section	.rodata.__func__.10587,"a",%progbits
	.set	.LANCHOR221,. + 0
	.type	__func__.10587, %object
	.size	__func__.10587, 17
__func__.10587:
	.ascii	"ftl_write_commit\000"
	.section	.rodata.__func__.10605,"a",%progbits
	.set	.LANCHOR124,. + 0
	.type	__func__.10605, %object
	.size	__func__.10605, 14
__func__.10605:
	.ascii	"ftl_write_buf\000"
	.section	.rodata.__func__.10650,"a",%progbits
	.set	.LANCHOR127,. + 0
	.type	__func__.10650, %object
	.size	__func__.10650, 18
__func__.10650:
	.ascii	"zftl_add_read_buf\000"
	.section	.rodata.__func__.10683,"a",%progbits
	.set	.LANCHOR218,. + 0
	.type	__func__.10683, %object
	.size	__func__.10683, 10
__func__.10683:
	.ascii	"zftl_read\000"
	.section	.rodata.__func__.10714,"a",%progbits
	.set	.LANCHOR228,. + 0
	.type	__func__.10714, %object
	.size	__func__.10714, 13
__func__.10714:
	.ascii	"_ftl_discard\000"
	.section	.rodata.__func__.10863,"a",%progbits
	.set	.LANCHOR65,. + 0
	.type	__func__.10863, %object
	.size	__func__.10863, 12
__func__.10863:
	.ascii	"gc_add_sblk\000"
	.section	.rodata.__func__.10910,"a",%progbits
	.set	.LANCHOR219,. + 0
	.type	__func__.10910, %object
	.size	__func__.10910, 21
__func__.10910:
	.ascii	"gc_check_data_one_wl\000"
	.section	.rodata.__func__.10944,"a",%progbits
	.set	.LANCHOR214,. + 0
	.type	__func__.10944, %object
	.size	__func__.10944, 22
__func__.10944:
	.ascii	"gc_update_l2p_map_new\000"
	.section	.rodata.__func__.10957,"a",%progbits
	.set	.LANCHOR72,. + 0
	.type	__func__.10957, %object
	.size	__func__.10957, 19
__func__.10957:
	.ascii	"gc_write_completed\000"
	.section	.rodata.__func__.10986,"a",%progbits
	.set	.LANCHOR223,. + 0
	.type	__func__.10986, %object
	.size	__func__.10986, 16
__func__.10986:
	.ascii	"gc_do_copy_back\000"
	.section	.rodata.__func__.11013,"a",%progbits
	.set	.LANCHOR121,. + 0
	.type	__func__.11013, %object
	.size	__func__.11013, 16
__func__.11013:
	.ascii	"gc_free_src_blk\000"
	.section	.rodata.__func__.11057,"a",%progbits
	.set	.LANCHOR215,. + 0
	.type	__func__.11057, %object
	.size	__func__.11057, 16
__func__.11057:
	.ascii	"gc_scan_src_blk\000"
	.section	.rodata.__func__.11115,"a",%progbits
	.set	.LANCHOR216,. + 0
	.type	__func__.11115, %object
	.size	__func__.11115, 20
__func__.11115:
	.ascii	"gc_scan_static_data\000"
	.section	.rodata.__func__.11182,"a",%progbits
	.set	.LANCHOR226,. + 0
	.type	__func__.11182, %object
	.size	__func__.11182, 11
__func__.11182:
	.ascii	"zftl_do_gc\000"
	.section	.rodata.__func__.11275,"a",%progbits
	.set	.LANCHOR5,. + 0
	.type	__func__.11275, %object
	.size	__func__.11275, 18
__func__.11275:
	.ascii	"_list_remove_node\000"
	.section	.rodata.__func__.11300,"a",%progbits
	.set	.LANCHOR11,. + 0
	.type	__func__.11300, %object
	.size	__func__.11300, 23
__func__.11300:
	.ascii	"_list_update_data_list\000"
	.section	.rodata.__func__.11408,"a",%progbits
	.set	.LANCHOR183,. + 0
	.type	__func__.11408, %object
	.size	__func__.11408, 15
__func__.11408:
	.ascii	"ftl_info_flush\000"
	.section	.rodata.__func__.11440,"a",%progbits
	.set	.LANCHOR130,. + 0
	.type	__func__.11440, %object
	.size	__func__.11440, 15
__func__.11440:
	.ascii	"ftl_alloc_sblk\000"
	.section	.rodata.__func__.11482,"a",%progbits
	.set	.LANCHOR107,. + 0
	.type	__func__.11482, %object
	.size	__func__.11482, 18
__func__.11482:
	.ascii	"ftl_alloc_sys_blk\000"
	.section	.rodata.__func__.11492,"a",%progbits
	.set	.LANCHOR108,. + 0
	.type	__func__.11492, %object
	.size	__func__.11492, 17
__func__.11492:
	.ascii	"ftl_free_sys_blk\000"
	.section	.rodata.__func__.11550,"a",%progbits
	.set	.LANCHOR217,. + 0
	.type	__func__.11550, %object
	.size	__func__.11550, 14
__func__.11550:
	.ascii	"ftl_sblk_dump\000"
	.section	.rodata.__func__.11574,"a",%progbits
	.set	.LANCHOR206,. + 0
	.type	__func__.11574, %object
	.size	__func__.11574, 16
__func__.11574:
	.ascii	"ftl_sysblk_dump\000"
	.section	.rodata.__func__.11598,"a",%progbits
	.set	.LANCHOR189,. + 0
	.type	__func__.11598, %object
	.size	__func__.11598, 23
__func__.11598:
	.ascii	"ftl_open_sblk_recovery\000"
	.section	.rodata.__func__.11631,"a",%progbits
	.set	.LANCHOR109,. + 0
	.type	__func__.11631, %object
	.size	__func__.11631, 23
__func__.11631:
	.ascii	"ftl_get_ppa_from_index\000"
	.section	.rodata.__func__.11652,"a",%progbits
	.set	.LANCHOR220,. + 0
	.type	__func__.11652, %object
	.size	__func__.11652, 19
__func__.11652:
	.ascii	"ftl_update_l2p_map\000"
	.section	.rodata.__func__.11671,"a",%progbits
	.set	.LANCHOR113,. + 0
	.type	__func__.11671, %object
	.size	__func__.11671, 22
__func__.11671:
	.ascii	"ftl_get_new_free_page\000"
	.section	.rodata.__func__.11682,"a",%progbits
	.set	.LANCHOR114,. + 0
	.type	__func__.11682, %object
	.size	__func__.11682, 22
__func__.11682:
	.ascii	"ftl_ext_alloc_new_blk\000"
	.section	.rodata.__func__.11707,"a",%progbits
	.set	.LANCHOR187,. + 0
	.type	__func__.11707, %object
	.size	__func__.11707, 19
__func__.11707:
	.ascii	"ftl_ext_info_flush\000"
	.section	.rodata.__func__.11719,"a",%progbits
	.set	.LANCHOR188,. + 0
	.type	__func__.11719, %object
	.size	__func__.11719, 18
__func__.11719:
	.ascii	"ftl_ext_info_init\000"
	.section	.rodata.__func__.11758,"a",%progbits
	.set	.LANCHOR193,. + 0
	.type	__func__.11758, %object
	.size	__func__.11758, 25
__func__.11758:
	.ascii	"ftl_low_format_data_init\000"
	.section	.rodata.__func__.11773,"a",%progbits
	.set	.LANCHOR195,. + 0
	.type	__func__.11773, %object
	.size	__func__.11773, 15
__func__.11773:
	.ascii	"ftl_low_format\000"
	.section	.rodata.__func__.11821,"a",%progbits
	.set	.LANCHOR180,. + 0
	.type	__func__.11821, %object
	.size	__func__.11821, 14
__func__.11821:
	.ascii	"ftl_prog_page\000"
	.section	.rodata.__func__.11943,"a",%progbits
	.set	.LANCHOR170,. + 0
	.type	__func__.11943, %object
	.size	__func__.11943, 31
__func__.11943:
	.ascii	"queue_wait_first_req_completed\000"
	.section	.rodata.__func__.11997,"a",%progbits
	.set	.LANCHOR176,. + 0
	.type	__func__.11997, %object
	.size	__func__.11997, 15
__func__.11997:
	.ascii	"sblk_prog_page\000"
	.section	.rodata.__func__.12024,"a",%progbits
	.set	.LANCHOR172,. + 0
	.type	__func__.12024, %object
	.size	__func__.12024, 15
__func__.12024:
	.ascii	"sblk_read_page\000"
	.section	.rodata.__func__.12088,"a",%progbits
	.set	.LANCHOR207,. + 0
	.type	__func__.12088, %object
	.size	__func__.12088, 16
__func__.12088:
	.ascii	"load_l2p_region\000"
	.section	.rodata.__func__.12104,"a",%progbits
	.set	.LANCHOR150,. + 0
	.type	__func__.12104, %object
	.size	__func__.12104, 13
__func__.12104:
	.ascii	"pm_free_sblk\000"
	.section	.rodata.__func__.12128,"a",%progbits
	.set	.LANCHOR209,. + 0
	.type	__func__.12128, %object
	.size	__func__.12128, 6
__func__.12128:
	.ascii	"pm_gc\000"
	.section	.rodata.__func__.12144,"a",%progbits
	.set	.LANCHOR133,. + 0
	.type	__func__.12144, %object
	.size	__func__.12144, 17
__func__.12144:
	.ascii	"pm_alloc_new_blk\000"
	.section	.rodata.__func__.12154,"a",%progbits
	.set	.LANCHOR190,. + 0
	.type	__func__.12154, %object
	.size	__func__.12154, 14
__func__.12154:
	.ascii	"pm_write_page\000"
	.section	.rodata.__func__.12172,"a",%progbits
	.set	.LANCHOR136,. + 0
	.type	__func__.12172, %object
	.size	__func__.12172, 21
__func__.12172:
	.ascii	"pm_select_ram_region\000"
	.section	.rodata.__func__.9620,"a",%progbits
	.set	.LANCHOR164,. + 0
	.type	__func__.9620, %object
	.size	__func__.9620, 19
__func__.9620:
	.ascii	"flash_read_page_en\000"
	.section	.rodata.__func__.9662,"a",%progbits
	.set	.LANCHOR178,. + 0
	.type	__func__.9662, %object
	.size	__func__.9662, 19
__func__.9662:
	.ascii	"flash_prog_page_en\000"
	.section	.rodata.__func__.9678,"a",%progbits
	.set	.LANCHOR40,. + 0
	.type	__func__.9678, %object
	.size	__func__.9678, 26
__func__.9678:
	.ascii	"flash_erase_duplane_block\000"
	.section	.rodata.__func__.9689,"a",%progbits
	.set	.LANCHOR42,. + 0
	.type	__func__.9689, %object
	.size	__func__.9689, 21
__func__.9689:
	.ascii	"flash_erase_block_en\000"
	.section	.rodata.__func__.9703,"a",%progbits
	.set	.LANCHOR29,. + 0
	.type	__func__.9703, %object
	.size	__func__.9703, 28
__func__.9703:
	.ascii	"flash_wait_device_ready_raw\000"
	.section	.rodata.__func__.9727,"a",%progbits
	.set	.LANCHOR173,. + 0
	.type	__func__.9727, %object
	.size	__func__.9727, 26
__func__.9727:
	.ascii	"flash_start_tlc_page_prog\000"
	.section	.rodata.__func__.9738,"a",%progbits
	.set	.LANCHOR174,. + 0
	.type	__func__.9738, %object
	.size	__func__.9738, 29
__func__.9738:
	.ascii	"flash_start_3d_mlc_page_prog\000"
	.section	.rodata.__func__.9756,"a",%progbits
	.set	.LANCHOR175,. + 0
	.type	__func__.9756, %object
	.size	__func__.9756, 22
__func__.9756:
	.ascii	"flash_start_page_prog\000"
	.section	.rodata.__func__.9767,"a",%progbits
	.set	.LANCHOR34,. + 0
	.type	__func__.9767, %object
	.size	__func__.9767, 22
__func__.9767:
	.ascii	"flash_start_page_read\000"
	.section	.rodata.__func__.9780,"a",%progbits
	.set	.LANCHOR168,. + 0
	.type	__func__.9780, %object
	.size	__func__.9780, 31
__func__.9780:
	.ascii	"flash_complete_plane_page_read\000"
	.section	.rodata.__func__.9792,"a",%progbits
	.set	.LANCHOR43,. + 0
	.type	__func__.9792, %object
	.size	__func__.9792, 23
__func__.9792:
	.ascii	"flash_start_plane_read\000"
	.section	.rodata.__func__.9805,"a",%progbits
	.set	.LANCHOR169,. + 0
	.type	__func__.9805, %object
	.size	__func__.9805, 25
__func__.9805:
	.ascii	"flash_complete_page_read\000"
	.section	.rodata._list_remove_node.str1.1,"aMS",%progbits,1
.LC0:
	.ascii	"\012!!!!! error @ func:%s - line:%d\012\000"
	.section	.rodata.dump_ftl_info.str1.1,"aMS",%progbits,1
.LC178:
	.ascii	"free_buf_count: %d\012\000"
.LC179:
	.ascii	"g_ftl_info_blk blk:0x%x, index:0x%x, page:0x%x\012\000"
.LC180:
	.ascii	"ftl_ext_info_blk blk:0x%x, page:0x%x\012\000"
.LC181:
	.ascii	"ac_blk:0x%x, page:0x%x, index:0x%x, free:0x%x, page"
	.ascii	"_index:0x%x\012\000"
.LC182:
	.ascii	"tmp_blk:0x%x, page:0x%x, index:0x%x, free:0x%x, pag"
	.ascii	"e_index:0x%x\012\000"
.LC183:
	.ascii	"gc_blk:0x%x, page:0x%x, index:0x%x, free:0x%x, page"
	.ascii	"_index:0x%x\012\000"
.LC184:
	.ascii	"lpa:\000"
.LC185:
	.ascii	"vpn:\000"
.LC186:
	.ascii	"sblk:\000"
.LC187:
	.ascii	"lpa_hash:\000"
.LC188:
	.ascii	"lpa_hash_index:\000"
	.section	.rodata.dump_pm_blk.str1.1,"aMS",%progbits,1
.LC248:
	.ascii	"pm l2p:\000"
.LC249:
	.ascii	"pm blk:\000"
	.section	.rodata.dump_sblk_queue.str1.1,"aMS",%progbits,1
.LC75:
	.ascii	"dump_sblk_queue: %d\012\000"
.LC76:
	.ascii	"buf id= %d state = %d ppa = %x\012\000"
	.section	.rodata.flash_complete_page_read.str1.1,"aMS",%progbits,1
.LC124:
	.ascii	"flash_complete_page_read %x %x error_ecc %d %d\012\000"
	.section	.rodata.flash_ddr_tuning_read.str1.1,"aMS",%progbits,1
.LC117:
	.ascii	"%d flash_ddr_tuning_read %x ecc=%d\012\000"
.LC118:
	.ascii	"sync para %d\012\000"
.LC119:
	.ascii	"DDR mode Read error %x %x\012\000"
.LC120:
	.ascii	"SDR mode Read %x %x ecc:%x\012\000"
	.section	.rodata.flash_erase_all.str1.1,"aMS",%progbits,1
.LC36:
	.ascii	"erase done: %x\012\000"
	.section	.rodata.flash_erase_block_en.str1.1,"aMS",%progbits,1
.LC34:
	.ascii	"flash_erase_block %x %x %x\012\000"
.LC35:
	.ascii	"flash_erase_block %d block = %x status = %x\012\000"
	.section	.rodata.flash_erase_duplane_block.str1.1,"aMS",%progbits,1
.LC32:
	.ascii	"flash_erase_duplane_block %x %x %x\012\000"
.LC33:
	.ascii	"flash_erase_duplane_block pageadd = %x status = %x\012"
	.ascii	"\000"
	.section	.rodata.flash_get_last_written_page.str1.1,"aMS",%progbits,1
.LC123:
	.ascii	"flash_get_last_written_page: %x %x %x\012\000"
	.section	.rodata.flash_info_blk_init.str1.1,"aMS",%progbits,1
.LC175:
	.ascii	"...%d @ %s %d %p\012\000"
.LC176:
	.ascii	"no sys info %x\012\000"
	.section	.rodata.flash_info_data_init.str1.1,"aMS",%progbits,1
.LC92:
	.ascii	"...%d @ %s\012\000"
	.section	.rodata.flash_info_flush.str1.1,"aMS",%progbits,1
.LC172:
	.ascii	"finfo:\000"
.LC173:
	.ascii	"flash_info_flush id = %x, page = %x\012\000"
.LC174:
	.ascii	"sys_info_flush error:%x\012\000"
	.section	.rodata.flash_mask_bad_block.str1.1,"aMS",%progbits,1
.LC42:
	.ascii	"flash_mask_bad_block %d %d\012\000"
	.section	.rodata.flash_prog_page.str1.1,"aMS",%progbits,1
.LC130:
	.ascii	"flash_prog_page %x %x %x\012\000"
.LC131:
	.ascii	"flash_prog_page page_addr = %x status = %x\012\000"
	.section	.rodata.flash_prog_page_en.str1.1,"aMS",%progbits,1
.LC138:
	.ascii	"flash_prog_page_en:%x %x %x\012\000"
.LC139:
	.ascii	"w d:\000"
.LC140:
	.ascii	"w s:\000"
.LC141:
	.ascii	"spare\000"
.LC142:
	.ascii	"data\000"
.LC143:
	.ascii	"write error: %x\012\000"
	.section	.rodata.flash_read_id.str1.1,"aMS",%progbits,1
.LC39:
	.ascii	"No.%d FLASH ID:%x %x %x %x %x %x\012\000"
	.section	.rodata.flash_read_otp_data.str1.1,"aMS",%progbits,1
.LC40:
	.ascii	"otp:%x %x %x %x\012\000"
	.section	.rodata.flash_read_page.str1.1,"aMS",%progbits,1
.LC110:
	.ascii	"flash_read_page %x %x %x\012\000"
	.section	.rodata.flash_read_page_en.str1.1,"aMS",%progbits,1
.LC121:
	.ascii	"flash_read_page_en %x %x %x\012\000"
.LC122:
	.ascii	"flash_read_page_en %x %x error_ecc %d %d\012\000"
	.section	.rodata.flash_set_interface_mode.str1.1,"aMS",%progbits,1
.LC37:
	.ascii	"nand sdr mode %x\012\000"
.LC38:
	.ascii	"nand ddr mode %x\012\000"
	.section	.rodata.ftl_alloc_new_data_sblk.str1.1,"aMS",%progbits,1
.LC236:
	.ascii	"error gc_add_sblk: %x\012\000"
	.section	.rodata.ftl_alloc_sblk.str1.1,"aMS",%progbits,1
.LC74:
	.ascii	"alloc sblk %x %d\012\000"
	.section	.rodata.ftl_dump_write_open_sblk.str1.1,"aMS",%progbits,1
.LC162:
	.ascii	"ftl_sblk_dump_write = %x %d %d %d %d\012\000"
.LC163:
	.ascii	"blk= %x, page=%x, ppa = %x, status = %x, data:%x %x"
	.ascii	" %x %x, spare: %x %x %x %x\012\000"
.LC164:
	.ascii	"ftl_sblk_dump_write2 = %x %d %d %d\012\000"
.LC165:
	.ascii	"ftl_sblk_dump_write = %x %x\012\000"
.LC166:
	.ascii	"ftl_sblk_dump_write done = %x\012\000"
	.section	.rodata.ftl_ext_info_init.str1.1,"aMS",%progbits,1
.LC149:
	.ascii	"%s %d %d %x %x\012\000"
.LC150:
	.ascii	"%s %x %x %x\012\000"
	.section	.rodata.ftl_free_sblk.str1.1,"aMS",%progbits,1
.LC63:
	.ascii	"swl_slc_free_mini_ec_blk sblk %x\012\000"
	.section	.rodata.ftl_info_blk_init.str1.1,"aMS",%progbits,1
.LC146:
	.ascii	"%d %x @%d %x\012\000"
.LC147:
	.ascii	"ftl_info_blk_init %d %d %x\012\000"
.LC148:
	.ascii	"ink flag: %x\012\000"
	.section	.rodata.ftl_info_flush.str1.1,"aMS",%progbits,1
.LC145:
	.ascii	"g_ftl_info_blk blk = %x, page = %x version = %d\012"
	.ascii	"\000"
	.section	.rodata.ftl_ink_check_sblk.str1.1,"aMS",%progbits,1
.LC167:
	.ascii	"ftl_ink_check_sblk = %x %d %d\012\000"
.LC168:
	.ascii	"ftl_ink_check_sblk = %x %d %d end\012\000"
	.section	.rodata.ftl_low_format.str1.1,"aMS",%progbits,1
.LC169:
	.ascii	"ftl_low_format %d\012\000"
.LC170:
	.ascii	"low format %d %d %d %d\012\000"
	.section	.rodata.ftl_mask_bad_block.str1.1,"aMS",%progbits,1
.LC61:
	.ascii	"mask bad block:cs %x %x block: %x %x\012\000"
	.section	.rodata.ftl_open_sblk_recovery.str1.1,"aMS",%progbits,1
.LC151:
	.ascii	"saved_active_page  = %x\012\000"
.LC152:
	.ascii	"saved_active_plane = %x\012\000"
.LC153:
	.ascii	"sblk = %x\012\000"
.LC154:
	.ascii	"phy_blk = %x %x\012\000"
.LC155:
	.ascii	"num_planes = %x\012\000"
.LC156:
	.ascii	"sblk = %x, vpn0 = %d, vpn1 = %d\012\000"
.LC157:
	.ascii	"dump_write_lpa = %x %x %x %x\012\000"
.LC158:
	.ascii	"dump write new ppa = %x, last ppa = %x lpa = %x\012"
	.ascii	"\000"
.LC159:
	.ascii	"dump write = %x %x %x\012\000"
.LC160:
	.ascii	"dump write hash update = %x %x %x\012\000"
	.section	.rodata.ftl_re_low_format.str1.1,"aMS",%progbits,1
.LC171:
	.ascii	"re low format %d\012\000"
	.section	.rodata.ftl_sblk_dump.str1.1,"aMS",%progbits,1
.LC221:
	.ascii	"ftl_sblk_dump = %x %d %d %d %d\012\000"
.LC222:
	.ascii	"ftl_sblk_dump = %x %x %x %x\012\000"
.LC223:
	.ascii	"page_addr = %x, lpa=%x vpn = %d\012\000"
.LC224:
	.ascii	"index= %x, lpa=%x\012\000"
.LC225:
	.ascii	"block = %x, vpn=%x check vpn = %d\012\000"
	.section	.rodata.ftl_sysblk_dump.str1.1,"aMS",%progbits,1
.LC177:
	.ascii	"l2p:\000"
	.section	.rodata.ftl_test_block.str1.1,"aMS",%progbits,1
.LC144:
	.ascii	"low format %d\012\000"
	.section	.rodata.ftl_update_l2p_map.str1.1,"aMS",%progbits,1
.LC232:
	.ascii	"ftl_update_l2p_map: %x %x %x\012\000"
.LC233:
	.ascii	"ftl_update_l2p_map\000"
.LC234:
	.ascii	"lpa_tbl:\000"
.LC235:
	.ascii	"sblk %x vpn: %d %d\012\000"
	.section	.rodata.ftl_vpn_decrement.str1.1,"aMS",%progbits,1
.LC60:
	.ascii	"ftl_vpn_decrement %x = %d, %d\012\000"
	.section	.rodata.ftl_write_commit.str1.1,"aMS",%progbits,1
.LC237:
	.ascii	"%d read error: ppa:%x, lpa:%x, status:%x\012\000"
	.section	.rodata.ftl_write_completed.str1.1,"aMS",%progbits,1
.LC72:
	.ascii	"ftl prog error =%x, lpa = %x, ppa= %x\012\000"
.LC73:
	.ascii	"ftl re prog: lpa = %x, ppa= %x\012\000"
	.section	.rodata.gc_add_sblk.str1.1,"aMS",%progbits,1
.LC43:
	.ascii	"gc_add_sblk = %d, %d, %d, %d, %d, %d, %d\012\000"
.LC44:
	.ascii	"gc_add_sblk = %d, %d, %d\012\000"
.LC45:
	.ascii	"gc_add_sblk = %d, %d, %d,last update:%d, %d\012\000"
.LC46:
	.ascii	"gc_add_sblk = %d, %d, %d, %d, %d, %d\012\000"
	.section	.rodata.gc_check_data_one_wl.str1.1,"aMS",%progbits,1
.LC229:
	.ascii	"gc_lpa:\000"
.LC230:
	.ascii	"gc_ppa:\000"
.LC231:
	.ascii	"err: ppa = %x, status = %x, %x %x spare: %x %x %x %"
	.ascii	"x\012\000"
	.section	.rodata.gc_do_copy_back.str1.1,"aMS",%progbits,1
.LC238:
	.ascii	"gc page in buf: lpa %x ppa = %x pageindex= %x\012\000"
.LC239:
	.ascii	"gc_do_copy_back: lpa %x des_ppa = %x %x gc_ppa= %x "
	.ascii	"page_index= %d\012\000"
.LC240:
	.ascii	"gc_do_copy_back: %x %x %x %x gc_ppa:%x %x %x %d\012"
	.ascii	"\000"
.LC241:
	.ascii	"%d prog_step: %x %x buf id= %x ppa = %x hash=%d id "
	.ascii	"= %x plane = %x lpa=%x %x\012\000"
	.section	.rodata.gc_free_bad_sblk.str1.1,"aMS",%progbits,1
.LC62:
	.ascii	"gc_free_bad_sblk 0x%x\012\000"
	.section	.rodata.gc_free_src_blk.str1.1,"aMS",%progbits,1
.LC64:
	.ascii	"gc_free_src_blk = %x, vpn = %d\012\000"
.LC65:
	.ascii	"gc_free_src_blk %x, %d\012\000"
	.section	.rodata.gc_free_temp_buf.str1.1,"aMS",%progbits,1
.LC50:
	.ascii	"%d gc_free_temp_buf buf id= %x\012\000"
	.section	.rodata.gc_mark_bad_ppa.str1.1,"aMS",%progbits,1
.LC47:
	.ascii	"gc_mark_bad_ppa %d %x %x\012\000"
	.section	.rodata.gc_recovery.str1.1,"aMS",%progbits,1
.LC199:
	.ascii	"ppa = %x, status = %x, data:%x %x %x %x, spare: %x "
	.ascii	"%x %x %x\012\000"
.LC200:
	.ascii	"ppa = %x, status = %x, %x %x spare: %x %x %x %x\012"
	.ascii	"\000"
.LC201:
	.ascii	"gc_recovery: %x vpn = %x\012\000"
	.section	.rodata.gc_scan_src_blk.str1.1,"aMS",%progbits,1
.LC219:
	.ascii	"gc_scan_src_blk = %x, vpn = %d\012\000"
.LC220:
	.ascii	"gc_scan_src_blk = %x, s vpn0 = %d, c vpn1 = %d\012\000"
	.section	.rodata.gc_search_src_blk.str1.1,"aMS",%progbits,1
.LC52:
	.ascii	"zftl_get_gc_node cache = %x index = %d vpn = %x\012"
	.ascii	"\000"
.LC53:
	.ascii	"gc_search_src_blk mode = %x, src mode = %x, count= "
	.ascii	"%d %d\012\000"
	.section	.rodata.gc_static_wearleveling.str1.1,"aMS",%progbits,1
.LC80:
	.ascii	"gc_static_wearleveling: min blk: %x,sec=%d,xec = %d"
	.ascii	" ,mode=%d, func=%x, bbt=%x vpn = %d\012\000"
.LC81:
	.ascii	"gc_static_wearleveling: min slc blk: %x,sec=%d,xec "
	.ascii	"= %d ,mode=%d, func=%x, bbt=%x vpn = %d\012\000"
.LC82:
	.ascii	"gc_static_wearleveling: min tlc blk: %x,sec=%d,xec "
	.ascii	"= %d ,mode=%d, func=%x, bbt=%x vpn = %d\012\000"
.LC83:
	.ascii	"gc_static_wearleveling: max slc blk: %x,sec=%d,xec "
	.ascii	"= %d ,mode=%d, func=%x, bbt=%x vpn = %d\012\000"
.LC84:
	.ascii	"gc_static_wearleveling: max xlc blk: %x,sec=%d,xec "
	.ascii	"= %d ,mode=%d, func=%x, bbt=%x vpn = %d\012\000"
.LC85:
	.ascii	"gc_static_wearleveling: slc blk: %x, tlc blk: %d av"
	.ascii	"g slc ec: %d, avg tlc ec: %d \012\000"
.LC86:
	.ascii	"gc_static_wearleveling: min slc ec: %x, min tlc ec:"
	.ascii	" %d max slc ec: %d, max tlc ec: %d; %d %d\012\000"
.LC87:
	.ascii	"swl add tlc gc = %x, %d, %d, %d, %d, %d\012\000"
.LC88:
	.ascii	"swl add slc gc  = %x, %d, %d, %d, %d, %d\012\000"
	.section	.rodata.gc_update_l2p_map_new.str1.1,"aMS",%progbits,1
.LC215:
	.ascii	"gc_update_l2p_map_new sblk %x\012\000"
.LC216:
	.ascii	"gc_update_l2p_map_new: %x %x %x\012\000"
.LC217:
	.ascii	"lpa: %x %x %x\012\000"
.LC218:
	.ascii	"gc_update_l2p_map_new: %x vpn = %x vpn1 = %x done\012"
	.ascii	"\000"
	.section	.rodata.gc_write_completed.str1.1,"aMS",%progbits,1
.LC48:
	.ascii	"status: %x, ppa: %x\012\000"
.LC49:
	.ascii	"gc_write_completed: %x  %x  %d %x\012\000"
	.section	.rodata.hynix_get_read_retry_default.str1.1,"aMS",%progbits,1
.LC100:
	.ascii	"otp error! %d\000"
.LC101:
	.ascii	"rr\000"
	.section	.rodata.hynix_read_retrial.str1.1,"aMS",%progbits,1
.LC116:
	.ascii	"hynix RR %d row=%x, count %d, status=%d\012\000"
	.section	.rodata.idb_write_data.str1.1,"aMS",%progbits,1
.LC132:
	.ascii	"1 write_idblock fix data %x %x %x\012\000"
.LC133:
	.ascii	"write_idblock check fail! %x\012\000"
.LC134:
	.ascii	"write_idblock fail! %x\012\000"
	.section	.rodata.load_l2p_region.str1.1,"aMS",%progbits,1
.LC190:
	.ascii	"region_id = %d, pm_max_region = %d\012\000"
.LC191:
	.ascii	"load_l2p_region no ppa = %x , %x, all setting 0xff."
	.ascii	"...\012\000"
.LC192:
	.ascii	"load_l2p_region = %x,%x,%x, %x\012\000"
.LC193:
	.ascii	"pm_ppa:\000"
.LC194:
	.ascii	"data:\000"
.LC195:
	.ascii	"spare:\000"
	.section	.rodata.lpa_rebuild_hash.str1.1,"aMS",%progbits,1
.LC79:
	.ascii	"%s %d %d\012\000"
	.section	.rodata.micron_read_retrial.str1.1,"aMS",%progbits,1
.LC111:
	.ascii	"MT %d row=%x,last status %d,status = %d\012\000"
.LC112:
	.ascii	"MT RR %d row=%x,count %d,status=%d\012\000"
	.section	.rodata.nand_flash_print_info.str1.1,"aMS",%progbits,1
.LC1:
	.ascii	"...%s enter...\012\000"
.LC2:
	.ascii	"No.0 FLASH ID: %x %x %x %x %x %x\012\000"
.LC3:
	.ascii	"DiePerChip: %x\012\000"
.LC4:
	.ascii	"SectPerPage: %x\012\000"
.LC5:
	.ascii	"PagePerBlk: %x\012\000"
.LC6:
	.ascii	"Cell: %x\012\000"
.LC7:
	.ascii	"PlanePerDie: %x\012\000"
.LC8:
	.ascii	"BlkPerPlane: %x\012\000"
.LC9:
	.ascii	"die gap: %x\012\000"
.LC10:
	.ascii	"lsbMode: %x\012\000"
.LC11:
	.ascii	"ReadRetryMode: %x\012\000"
.LC12:
	.ascii	"ecc: %x\012\000"
.LC13:
	.ascii	"idb ecc: %x\012\000"
.LC14:
	.ascii	"g_flash_slc_mode: %x\012\000"
.LC15:
	.ascii	"OptMode: %x\012\000"
.LC16:
	.ascii	"g_nand_max_die: %x\012\000"
.LC17:
	.ascii	"Cache read enable: %x\012\000"
.LC18:
	.ascii	"Cache random read enable: %x\012\000"
.LC19:
	.ascii	"Cache prog enable: %x\012\000"
.LC20:
	.ascii	"multi read enable: %x\012\000"
.LC21:
	.ascii	"multi prog enable: %x\012\000"
.LC22:
	.ascii	"interleave enable: %x\012\000"
.LC23:
	.ascii	"read retry enable: %x\012\000"
.LC24:
	.ascii	"randomizer enable: %x\012\000"
.LC25:
	.ascii	"SDR enable: %x\012\000"
.LC26:
	.ascii	"ONFI enable: %x\012\000"
.LC27:
	.ascii	"TOGGLE enable: %x\012\000"
.LC28:
	.ascii	"g_flash_slc_mode: %x %x\012\000"
.LC29:
	.ascii	"MultiPlaneProgCmd: %x %x\012\000"
.LC30:
	.ascii	"MultiPlaneReadCmd: %x %x\012\000"
.LC31:
	.ascii	"g_flash_toggle_mode_en: %x\012\000"
	.section	.rodata.nandc_init.str1.1,"aMS",%progbits,1
.LC93:
	.ascii	"...%s enter... %p\012\000"
.LC94:
	.ascii	"0:%x %x %x %x %x\012\000"
.LC95:
	.ascii	"g_nandc_ver...%d\012\000"
	.section	.rodata.nandc_xfer.str1.1,"aMS",%progbits,1
.LC107:
	.ascii	"dqs data abort %x\012\000"
.LC108:
	.ascii	"dqs data timeout %x\012\000"
.LC109:
	.ascii	"xfer error %x\012\000"
	.section	.rodata.nandc_xfer_done.str1.1,"aMS",%progbits,1
.LC102:
	.ascii	"flash_abort_clear = %d\012\000"
.LC103:
	.ascii	"%d mtrans_cnt = %d page_num = %d\012\000"
.LC104:
	.ascii	"nandc:\000"
.LC105:
	.ascii	"%d flReg.d32=%x %x\012\000"
.LC106:
	.ascii	"nandc_xfer_done read error %x\012\000"
	.section	.rodata.pm_alloc_new_blk.str1.1,"aMS",%progbits,1
.LC77:
	.ascii	"blk %x is bad block\012\000"
.LC78:
	.ascii	"pm_alloc_new_blk: %x %x %x %x\012\000"
	.section	.rodata.pm_free_sblk.str1.1,"aMS",%progbits,1
.LC90:
	.ascii	"GC PM block %x %x %x %d\012\000"
.LC91:
	.ascii	"ftl_free_no_use_map_blk %x %x %x %d\012\000"
	.section	.rodata.pm_init.str1.1,"aMS",%progbits,1
.LC196:
	.ascii	"pm_init posr %x %x %x\012\000"
.LC197:
	.ascii	"pm_init recovery %x %x %x\012\000"
	.section	.rodata.pm_log2phys.str1.1,"aMS",%progbits,1
.LC198:
	.ascii	"pm_log2phys  lpn = %d, max lpn = %d\012\000"
	.section	.rodata.pm_ppa_update_check.str1.1,"aMS",%progbits,1
.LC189:
	.ascii	"%s w error lpn = %x, max ppa = %d\012\000"
	.section	.rodata.pm_write_page.str1.1,"aMS",%progbits,1
.LC161:
	.ascii	"pm_write_page write error: %x\012\000"
	.section	.rodata.print_ftl_debug_info.str1.1,"aMS",%progbits,1
.LC66:
	.ascii	"bad blk = %x, %x free blk: s:%x,t:%x,m:%x, data blk"
	.ascii	":s:%x,%x,t%x vpn: s:%x t:%x, max_vpn: %x\012\000"
.LC67:
	.ascii	"totle w: %d MB,r: %d MB %d dv:0x%X,poc:%d\012\000"
.LC68:
	.ascii	"gc xlc page: %d,gc slc page: %d, tmp w: %d MB\012\000"
.LC69:
	.ascii	"slc ec: %d,%d,%d,%d,%d,tlc ec: %d,%d,%d,%d,%d\012\000"
.LC70:
	.ascii	"gc th: tlc_tlc: %d tlc_slc: %d slc_slc: %d slc_tlc:"
	.ascii	"%d free_th: %d\012\000"
.LC71:
	.ascii	"swl : %x %x %x %x %x %x\012\000"
	.section	.rodata.print_gc_debug_info.str1.1,"aMS",%progbits,1
.LC51:
	.ascii	"gc: b:%x,p:%x,i:%x; free buf=%d %d free slc th: %d\012"
	.ascii	"\000"
	.section	.rodata.print_list_info.str1.1,"aMS",%progbits,1
.LC58:
	.ascii	"list count:%p %d\012\000"
.LC59:
	.ascii	"%d: node:%x %x %x %x, %d %d %d %d %d\012\000"
	.section	.rodata.queue_wait_first_req_completed.str1.1,"aMS",%progbits,1
.LC125:
	.ascii	"read: %x %x %x %x\012\000"
.LC126:
	.ascii	"0set buf %d,status = %x, ppa = %x lun state = %d\012"
	.ascii	"\000"
.LC127:
	.ascii	"prog end %x %x error_ecc %d %d\012\000"
.LC128:
	.ascii	"1set buf %d,status = %x, ppa = %x lun state = %d\012"
	.ascii	"\000"
.LC129:
	.ascii	"dp prog end %x %x error_ecc %d %d\012\000"
	.section	.rodata.random_seed,"a",%progbits
	.align	1
	.set	.LANCHOR51,. + 0
	.type	random_seed, %object
	.size	random_seed, 256
random_seed:
	.short	22378
	.short	1512
	.short	25245
	.short	17827
	.short	25756
	.short	19440
	.short	9026
	.short	10030
	.short	29528
	.short	20467
	.short	29676
	.short	24432
	.short	31328
	.short	6872
	.short	13426
	.short	13842
	.short	8783
	.short	1108
	.short	782
	.short	28837
	.short	30729
	.short	9505
	.short	18676
	.short	23085
	.short	18730
	.short	1085
	.short	32609
	.short	14697
	.short	20858
	.short	15170
	.short	30365
	.short	1607
	.short	32298
	.short	4995
	.short	18905
	.short	1976
	.short	9592
	.short	20204
	.short	17443
	.short	13615
	.short	23330
	.short	29369
	.short	13947
	.short	9398
	.short	32398
	.short	8984
	.short	27600
	.short	21785
	.short	6019
	.short	6311
	.short	31598
	.short	30210
	.short	19327
	.short	13896
	.short	11347
	.short	27545
	.short	3107
	.short	26575
	.short	32270
	.short	19852
	.short	20601
	.short	8349
	.short	9290
	.short	29819
	.short	13579
	.short	3661
	.short	28676
	.short	27331
	.short	32574
	.short	8693
	.short	31253
	.short	9081
	.short	5399
	.short	6842
	.short	20087
	.short	5537
	.short	1274
	.short	11617
	.short	9530
	.short	4866
	.short	8035
	.short	23219
	.short	1178
	.short	23272
	.short	7383
	.short	18944
	.short	12488
	.short	12871
	.short	29340
	.short	20532
	.short	11022
	.short	22514
	.short	228
	.short	22363
	.short	24978
	.short	14584
	.short	12138
	.short	3092
	.short	17916
	.short	16863
	.short	14554
	.short	31457
	.short	29474
	.short	25311
	.short	24121
	.short	3684
	.short	28037
	.short	22865
	.short	22839
	.short	25217
	.short	13217
	.short	27186
	.short	14938
	.short	11180
	.short	29754
	.short	24180
	.short	15150
	.short	32455
	.short	20434
	.short	23848
	.short	29983
	.short	16120
	.short	14769
	.short	20041
	.short	29803
	.short	28406
	.short	17598
	.short	28087
	.section	.rodata.rk_ftl_init.str1.1,"aMS",%progbits,1
.LC214:
	.ascii	"zftl_init %x\012\000"
	.section	.rodata.rknand_print_hex.str1.1,"aMS",%progbits,1
.LC96:
	.ascii	"%s 0x%x:\000"
.LC97:
	.ascii	"%x \000"
.LC98:
	.ascii	"\000"
.LC99:
	.ascii	"%s\012\000"
	.section	.rodata.sandisk_prog_test_bad_block.str1.1,"aMS",%progbits,1
.LC41:
	.ascii	"bad block test:%x %x\012\000"
	.section	.rodata.sblk_3d_tlc_dump_prog.str1.1,"aMS",%progbits,1
.LC135:
	.ascii	"sblk_3d_tlc_dump_prog wl_addr= %x ppa = %x ppa = %x"
	.ascii	"\012\000"
	.section	.rodata.sblk_mlc_dump_prog.str1.1,"aMS",%progbits,1
.LC136:
	.ascii	"sblk_mlc_dump_prog wl_addr= %x ppa = %x ppa = %x\012"
	.ascii	"\000"
	.section	.rodata.sblk_prog_page.str1.1,"aMS",%progbits,1
.LC137:
	.ascii	"sblk_prog_page ppa = %x, count = %d\012\000"
	.section	.rodata.toshiba_15ref_value,"a",%progbits
	.set	.LANCHOR24,. + 0
	.type	toshiba_15ref_value, %object
	.size	toshiba_15ref_value, 95
toshiba_15ref_value:
	.byte	4
	.byte	5
	.byte	6
	.byte	7
	.byte	13
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	2
	.byte	4
	.byte	2
	.byte	0
	.byte	0
	.byte	8
	.byte	8
	.byte	0
	.byte	0
	.byte	0
	.byte	124
	.byte	0
	.byte	124
	.byte	124
	.byte	0
	.byte	122
	.byte	0
	.byte	122
	.byte	122
	.byte	0
	.byte	11
	.byte	126
	.byte	118
	.byte	116
	.byte	0
	.byte	120
	.byte	2
	.byte	120
	.byte	122
	.byte	0
	.byte	126
	.byte	4
	.byte	126
	.byte	122
	.byte	0
	.byte	16
	.byte	118
	.byte	114
	.byte	112
	.byte	0
	.byte	118
	.byte	4
	.byte	118
	.byte	120
	.byte	0
	.byte	4
	.byte	4
	.byte	4
	.byte	118
	.byte	0
	.byte	2
	.byte	0
	.byte	126
	.byte	124
	.byte	0
	.byte	6
	.byte	10
	.byte	6
	.byte	2
	.byte	0
	.byte	116
	.byte	124
	.byte	116
	.byte	118
	.byte	0
	.byte	4
	.byte	4
	.byte	124
	.byte	126
	.byte	0
	.byte	0
	.byte	124
	.byte	120
	.byte	120
	.byte	0
	.byte	124
	.byte	118
	.byte	116
	.byte	114
	.byte	0
	.section	.rodata.toshiba_3D_slc_value,"a",%progbits
	.set	.LANCHOR37,. + 0
	.type	toshiba_3D_slc_value, %object
	.size	toshiba_3D_slc_value, 11
toshiba_3D_slc_value:
	.byte	-117
	.byte	0
	.byte	-8
	.byte	8
	.byte	-16
	.byte	-24
	.byte	24
	.byte	-40
	.byte	40
	.byte	-56
	.byte	56
	.section	.rodata.toshiba_3D_tlc_value,"a",%progbits
	.set	.LANCHOR36,. + 0
	.type	toshiba_3D_tlc_value, %object
	.size	toshiba_3D_tlc_value, 399
toshiba_3D_tlc_value:
	.byte	-119
	.byte	-119
	.byte	-119
	.byte	-119
	.byte	-118
	.byte	-118
	.byte	-118
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	5
	.byte	-2
	.byte	-1
	.byte	0
	.byte	-3
	.byte	-2
	.byte	6
	.byte	-9
	.byte	-12
	.byte	-9
	.byte	-7
	.byte	-13
	.byte	-12
	.byte	-7
	.byte	-6
	.byte	-15
	.byte	-15
	.byte	-2
	.byte	-12
	.byte	-16
	.byte	-6
	.byte	-2
	.byte	-19
	.byte	-19
	.byte	-6
	.byte	-4
	.byte	-12
	.byte	-14
	.byte	-2
	.byte	-11
	.byte	-23
	.byte	-34
	.byte	-4
	.byte	-20
	.byte	-22
	.byte	-2
	.byte	-7
	.byte	-31
	.byte	-30
	.byte	-12
	.byte	-20
	.byte	-18
	.byte	2
	.byte	-15
	.byte	-19
	.byte	-36
	.byte	-12
	.byte	-28
	.byte	-34
	.byte	-6
	.byte	-15
	.byte	-11
	.byte	2
	.byte	-12
	.byte	-8
	.byte	-2
	.byte	2
	.byte	-3
	.byte	-7
	.byte	-10
	.byte	-4
	.byte	-8
	.byte	-6
	.byte	-6
	.byte	-11
	.byte	-27
	.byte	-38
	.byte	-16
	.byte	-12
	.byte	-2
	.byte	2
	.byte	-7
	.byte	-31
	.byte	-22
	.byte	-4
	.byte	-16
	.byte	-22
	.byte	-7
	.byte	-31
	.byte	-23
	.byte	-22
	.byte	-28
	.byte	-28
	.byte	-26
	.byte	2
	.byte	-7
	.byte	-11
	.byte	-14
	.byte	-8
	.byte	-12
	.byte	-10
	.byte	-10
	.byte	-27
	.byte	-25
	.byte	-22
	.byte	-20
	.byte	-28
	.byte	-22
	.byte	-7
	.byte	-23
	.byte	-29
	.byte	-34
	.byte	-24
	.byte	-32
	.byte	-22
	.byte	-10
	.byte	-11
	.byte	-29
	.byte	-18
	.byte	-12
	.byte	-24
	.byte	-22
	.byte	6
	.byte	1
	.byte	-3
	.byte	-6
	.byte	0
	.byte	-4
	.byte	-2
	.byte	10
	.byte	-3
	.byte	-7
	.byte	-6
	.byte	4
	.byte	-4
	.byte	-2
	.byte	-10
	.byte	-23
	.byte	-39
	.byte	-22
	.byte	-19
	.byte	-24
	.byte	-18
	.byte	-14
	.byte	-23
	.byte	-29
	.byte	-30
	.byte	-15
	.byte	-30
	.byte	-30
	.byte	-7
	.byte	-27
	.byte	-35
	.byte	-26
	.byte	-15
	.byte	-24
	.byte	-26
	.byte	6
	.byte	-11
	.byte	5
	.byte	-2
	.byte	-16
	.byte	-16
	.byte	-2
	.byte	-2
	.byte	-15
	.byte	-15
	.byte	-20
	.byte	-8
	.byte	-16
	.byte	-18
	.byte	6
	.byte	5
	.byte	-15
	.byte	-2
	.byte	-24
	.byte	-28
	.byte	-22
	.byte	10
	.byte	-15
	.byte	-3
	.byte	-30
	.byte	-8
	.byte	-24
	.byte	-30
	.byte	-10
	.byte	-27
	.byte	-19
	.byte	-30
	.byte	-12
	.byte	-16
	.byte	-10
	.byte	14
	.byte	-19
	.byte	-3
	.byte	-30
	.byte	4
	.byte	4
	.byte	6
	.byte	2
	.byte	1
	.byte	-3
	.byte	-10
	.byte	-8
	.byte	-4
	.byte	-6
	.byte	-2
	.byte	-15
	.byte	-11
	.byte	-26
	.byte	-8
	.byte	-20
	.byte	-30
	.byte	6
	.byte	-19
	.byte	-3
	.byte	-46
	.byte	0
	.byte	0
	.byte	2
	.byte	6
	.byte	9
	.byte	5
	.byte	2
	.byte	4
	.byte	8
	.byte	6
	.byte	8
	.byte	9
	.byte	9
	.byte	6
	.byte	8
	.byte	8
	.byte	6
	.byte	10
	.byte	13
	.byte	9
	.byte	6
	.byte	8
	.byte	12
	.byte	10
	.byte	2
	.byte	5
	.byte	1
	.byte	-2
	.byte	0
	.byte	0
	.byte	6
	.byte	12
	.byte	1
	.byte	13
	.byte	2
	.byte	12
	.byte	12
	.byte	14
	.byte	-12
	.byte	-14
	.byte	-20
	.byte	-18
	.byte	-16
	.byte	-16
	.byte	-14
	.byte	-12
	.byte	-10
	.byte	-21
	.byte	-14
	.byte	-12
	.byte	-12
	.byte	-10
	.byte	-12
	.byte	-18
	.byte	-22
	.byte	-24
	.byte	-18
	.byte	-18
	.byte	-18
	.byte	-12
	.byte	-14
	.byte	-23
	.byte	-20
	.byte	-20
	.byte	-20
	.byte	-20
	.byte	-12
	.byte	-24
	.byte	-24
	.byte	-30
	.byte	-24
	.byte	-28
	.byte	-28
	.byte	-12
	.byte	-26
	.byte	-25
	.byte	-34
	.byte	-24
	.byte	-24
	.byte	-24
	.byte	-12
	.byte	-13
	.byte	-26
	.byte	-20
	.byte	-14
	.byte	-18
	.byte	-18
	.byte	-12
	.byte	-15
	.byte	-27
	.byte	-22
	.byte	-20
	.byte	-24
	.byte	-22
	.byte	-12
	.byte	-21
	.byte	-28
	.byte	-28
	.byte	-24
	.byte	-26
	.byte	-24
	.byte	20
	.byte	16
	.byte	6
	.byte	10
	.byte	16
	.byte	12
	.byte	12
	.byte	16
	.byte	16
	.byte	8
	.byte	8
	.byte	12
	.byte	12
	.byte	12
	.byte	18
	.byte	18
	.byte	10
	.byte	8
	.byte	14
	.byte	14
	.byte	14
	.byte	16
	.byte	14
	.byte	6
	.byte	6
	.byte	12
	.byte	14
	.byte	8
	.byte	20
	.byte	18
	.byte	8
	.byte	6
	.byte	14
	.byte	14
	.byte	10
	.byte	20
	.byte	20
	.byte	6
	.byte	10
	.byte	10
	.byte	12
	.byte	12
	.byte	10
	.byte	13
	.byte	5
	.byte	2
	.byte	14
	.byte	8
	.byte	6
	.byte	6
	.byte	13
	.byte	9
	.byte	4
	.byte	14
	.byte	10
	.byte	10
	.byte	10
	.byte	13
	.byte	9
	.byte	6
	.byte	8
	.byte	12
	.byte	10
	.byte	2
	.byte	5
	.byte	1
	.byte	-2
	.byte	0
	.byte	0
	.byte	6
	.byte	12
	.byte	1
	.byte	13
	.byte	2
	.byte	12
	.byte	12
	.byte	14
	.section	.rodata.toshiba_3d_read_retrial.str1.1,"aMS",%progbits,1
.LC113:
	.ascii	"toshiba SRR %d row=%x, status=%d\012\000"
.LC114:
	.ascii	"toshiba TRR %d row=%x, status=%d\012\000"
.LC115:
	.ascii	"toshiba RR %d row=%x,count %d,status=%d\012\000"
	.section	.rodata.toshiba_A19ref_value,"a",%progbits
	.set	.LANCHOR22,. + 0
	.type	toshiba_A19ref_value, %object
	.size	toshiba_A19ref_value, 45
toshiba_A19ref_value:
	.byte	4
	.byte	5
	.byte	6
	.byte	7
	.byte	13
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	4
	.byte	4
	.byte	124
	.byte	126
	.byte	0
	.byte	0
	.byte	124
	.byte	120
	.byte	120
	.byte	0
	.byte	124
	.byte	118
	.byte	116
	.byte	114
	.byte	0
	.byte	8
	.byte	8
	.byte	0
	.byte	0
	.byte	0
	.byte	11
	.byte	126
	.byte	118
	.byte	116
	.byte	0
	.byte	16
	.byte	118
	.byte	114
	.byte	112
	.byte	0
	.byte	2
	.byte	0
	.byte	126
	.byte	124
	.byte	0
	.section	.rodata.toshiba_ref_value,"a",%progbits
	.set	.LANCHOR25,. + 0
	.type	toshiba_ref_value, %object
	.size	toshiba_ref_value, 8
toshiba_ref_value:
	.byte	0
	.byte	4
	.byte	124
	.byte	120
	.byte	116
	.byte	8
	.byte	12
	.byte	112
	.section	.rodata.zftl_discard.str1.1,"aMS",%progbits,1
.LC247:
	.ascii	"ftl_discard:(%x, %x, %x, %x)\012\000"
	.section	.rodata.zftl_do_gc.str1.1,"aMS",%progbits,1
.LC242:
	.ascii	"gc %d: %d %d %d %d %d %d %d\012\000"
.LC243:
	.ascii	"gc %d: %d %d %d %d %d %d\012\000"
.LC244:
	.ascii	"GC_STATE_SCAN_ALL_PAGE = %x, vpn0 = %d, vpn1 = %d\012"
	.ascii	"\000"
.LC245:
	.ascii	"gc free %x, %d\012\000"
	.section	.rodata.zftl_gc_get_free_sblk.str1.1,"aMS",%progbits,1
.LC54:
	.ascii	"swl_tlc_free_mini_ec_blk alloc sblk %x\012\000"
.LC55:
	.ascii	"zftl_get_free_sblk %x %d, %p %d %d\012\000"
.LC56:
	.ascii	"zftl_gc_get_free_sblk %x %x %x, %d %d %d\012\000"
	.section	.rodata.zftl_get_free_sblk.str1.1,"aMS",%progbits,1
.LC57:
	.ascii	"swl_slc_free_mini_ec_blk alloc sblk %x\012\000"
	.section	.rodata.zftl_init.str1.1,"aMS",%progbits,1
.LC202:
	.ascii	"FTL version: 6.0.18 20190918\000"
.LC203:
	.ascii	"_c_user_data_density := %d\012\000"
.LC204:
	.ascii	"_c_totle_phy_density := %d\012\000"
.LC205:
	.ascii	"_c_totle_log_page := %d\012\000"
.LC206:
	.ascii	"_c_totle_data_density := %d\012\000"
.LC207:
	.ascii	"_c_ftl_pm_page_num := %d\012\000"
.LC208:
	.ascii	"_c_ftl_byte_pre_page := %d\012\000"
.LC209:
	.ascii	"_c_max_pm_sblk := %d\012\000"
.LC210:
	.ascii	"_min_slc_super_block := %d\012\000"
.LC211:
	.ascii	"_max_xlc_super_block := %d\012\000"
.LC212:
	.ascii	"gp_ftl_ext_info %p %p %p\012\000"
.LC213:
	.ascii	"flash info size: %d %d %d\012\000"
	.section	.rodata.zftl_read.str1.1,"aMS",%progbits,1
.LC226:
	.ascii	"ftl_read %x %x %x\012\000"
.LC227:
	.ascii	"ftl_read refresh =%x, lpa = %x, ppa= %x\012\000"
.LC228:
	.ascii	"id=%d, status = %x, lpa = %x, ppa = %x spare = %x %"
	.ascii	"x %x %x\012\000"
	.section	.rodata.zftl_sblk_list_init.str1.1,"aMS",%progbits,1
.LC89:
	.ascii	"free blk vpn error: %x %x\012\000"
	.section	.rodata.zftl_write.str1.1,"aMS",%progbits,1
.LC246:
	.ascii	"ftlwrite %x %x %x %x\012\000"
	.hidden	free
