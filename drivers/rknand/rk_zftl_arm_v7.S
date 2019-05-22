/*
 * Copyright (c) 2016-2017, Fuzhou Rockchip Electronics Co., Ltd
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * date: 2019-05-22
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
	@ args = 0, pretend = 0, frame = 32
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L67
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	lr, r0
	sub	sp, sp, #32
	ldrh	r3, [r3]
	cmp	r3, r1
	bls	.L47
	ldrh	r3, [r2]
	ldr	r0, [r0]
	adds	r3, r3, #1
	strh	r3, [r2]	@ movhi
	ldr	r3, .L67+4
	ldr	r6, [r3]
	movs	r3, #6
	muls	r3, r1, r3
	str	r3, [sp, #8]
	adds	r7, r6, r3
	ldr	r2, [sp, #8]
	movw	r3, #65535
	strh	r3, [r7, #2]	@ movhi
	strh	r3, [r6, r2]	@ movhi
	cbnz	r0, .L50
.L66:
	str	r7, [lr]
	b	.L47
.L50:
	ldr	r3, .L67+8
	ldrh	r5, [r7, #4]
	ldr	r3, [r3]
	ldrh	r4, [r3, r1, lsl #1]
	muls	r4, r5, r4
	str	r3, [sp, #12]
	ldr	r3, .L67+12
	str	r4, [sp, #4]
	ldr	ip, [r3]
	ldr	r3, [ip, r1, lsl #2]
	ubfx	r2, r3, #11, #8
	ldr	r3, .L67+16
	ldrh	r3, [r3]
	str	r3, [sp, #16]
	ldrh	r3, [ip, r1, lsl #2]
	ubfx	r3, r3, #0, #11
	beq	.L51
	ldrh	r4, [sp, #16]
	smulbb	r2, r2, r4
	add	r3, r3, r2
	ldr	r2, [sp, #4]
	uxtah	r3, r2, r3
	str	r3, [sp, #4]
.L51:
	ldr	r3, [sp, #4]
	cmp	r5, #0
	it	eq
	moveq	r3, #-1
	mov	r5, r0
	mov	r8, #0
	str	r3, [sp, #4]
	subs	r3, r0, r6
	asrs	r2, r3, #1
	ldr	r3, .L67+20
	muls	r3, r2, r3
	ldr	r2, .L67
	ldrh	r2, [r2]
	uxth	r3, r3
	str	r2, [sp, #20]
.L58:
	add	r2, r8, #1
	uxth	r8, r2
	ldr	r2, [sp, #20]
	cmp	r8, r2
	bhi	.L47
	cmp	r1, r3
	beq	.L47
	ldr	r2, [sp, #12]
	ldrh	fp, [r5, #4]
	ldrh	r10, [r2, r3, lsl #1]
	ldr	r2, [ip, r3, lsl #2]
	mov	r4, fp
	ubfx	r2, r2, #11, #8
	str	r2, [sp, #24]
	ldrh	r2, [ip, r3, lsl #2]
	ubfx	r2, r2, #0, #11
	str	r2, [sp, #28]
	mov	r2, r10
	muls	r2, r4, r2
	mov	r10, r2
	beq	.L54
	cmp	fp, #0
	beq	.L62
	ldrh	r2, [sp, #24]
	ldrh	r4, [sp, #16]
	smulbb	fp, r2, r4
	ldr	r2, [sp, #28]
	add	fp, fp, r2
	uxtah	r10, r10, fp
.L55:
	ldr	r2, [sp, #4]
	cmp	r2, r10
	bcc	.L56
.L60:
	ldrh	r2, [r5]
	movw	r4, #65535
	cmp	r2, r4
	bne	.L57
	strh	r3, [r7, #2]	@ movhi
	strh	r1, [r5]	@ movhi
.L47:
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L57:
	movs	r3, #6
	mla	r5, r3, r2, r6
	mov	r3, r2
	b	.L58
.L56:
	ldrh	r2, [r5, #2]
	cmp	r0, r5
	strh	r2, [r7, #2]	@ movhi
	ldr	r2, [sp, #8]
	strh	r3, [r6, r2]	@ movhi
	bne	.L59
	strh	r1, [r0, #2]	@ movhi
	b	.L66
.L59:
	ldrh	r2, [r5, #2]
	movs	r3, #6
	muls	r3, r2, r3
	strh	r1, [r6, r3]	@ movhi
	strh	r1, [r5, #2]	@ movhi
	b	.L47
.L54:
	cmp	fp, #0
	bne	.L60
.L62:
	mov	r10, #-1
	b	.L55
.L68:
	.align	2
.L67:
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
	cbz	r0, .L74
	ldr	r3, .L76
	movw	r2, #65535
	movs	r4, #6
	ldr	r3, [r3]
.L71:
	cbz	r1, .L72
	ldrh	r0, [r0]
	cmp	r0, r2
	bne	.L73
	pop	{r4, pc}
.L73:
	subs	r1, r1, #1
	mla	r0, r4, r0, r3
	uxth	r1, r1
	b	.L71
.L74:
	movw	r0, #65535
	pop	{r4, pc}
.L72:
	subs	r0, r0, r3
	asrs	r3, r0, #1
	ldr	r0, .L76+4
	muls	r0, r3, r0
	uxth	r0, r0
	pop	{r4, pc}
.L77:
	.align	2
.L76:
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
	ldr	r3, .L88
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r6, r2
	mov	r7, r0
	mov	r4, r1
	ldr	r3, [r3]
	ldrh	r2, [r3, #16]
	cmp	r2, r1
	beq	.L78
	ldrh	r2, [r3, #48]
	cmp	r2, r1
	beq	.L78
	ldrh	r3, [r3, #80]
	cmp	r3, r1
	beq	.L78
	ldr	r3, .L88+4
	movs	r5, #6
	muls	r5, r1, r5
	ldr	r2, [r0]
	ldr	fp, [r3]
	mov	r8, r3
	add	r10, fp, r5
	cmp	r10, r2
	beq	.L78
	ldrh	r3, [r10, #2]
	movw	r2, #65535
	cmp	r3, r2
	bne	.L82
	ldrh	r2, [fp, r5]
	cmp	r2, r3
	bne	.L82
	movs	r2, #255
	ldr	r1, .L88+8
	ldr	r0, .L88+12
	bl	printf
.L82:
	ldrh	r3, [r10, #2]
	movw	r2, #65535
	cmp	r3, r2
	bne	.L83
	ldrh	r2, [fp, r5]
	cmp	r2, r3
	beq	.L78
.L83:
	ldr	r2, .L88+16
	ldr	r0, [r2]
	ldrh	r2, [r10, #4]
	ldrh	r1, [r0, r4, lsl #1]
	cbz	r2, .L86
	muls	r2, r1, r2
.L84:
	movs	r1, #6
	muls	r1, r3, r1
	ldr	r3, .L88+20
	asrs	r5, r1, #1
	muls	r3, r5, r3
	ldrh	r5, [r0, r3, lsl #1]
	ldr	r0, [r8]
	add	r1, r1, r0
	ldrh	r3, [r1, #4]
	cbz	r3, .L87
	muls	r3, r5, r3
.L85:
	cmp	r2, r3
	bcs	.L78
	mov	r2, r6
	mov	r1, r4
	mov	r0, r7
	bl	_list_remove_node
	mov	r2, r6
	mov	r1, r4
	mov	r0, r7
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	_insert_data_list
.L86:
	mov	r2, #-1
	b	.L84
.L87:
	mov	r3, #-1
	b	.L85
.L78:
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L89:
	.align	2
.L88:
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
	ldr	r3, .L91
	mov	r1, r0
	ldr	r0, [r3]
	b	_list_get_gc_head_node.isra.2
.L92:
	.align	2
.L91:
	.word	.LANCHOR12
	.size	zftl_get_gc_node.part.9, .-zftl_get_gc_node.part.9
	.section	.text.nandc_de_cs.constprop.29,"ax",%progbits
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	nandc_de_cs.constprop.29, %function
nandc_de_cs.constprop.29:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L94
	ldr	r2, [r3]
	ldr	r3, [r2]
	bfc	r3, #0, #8
	bfc	r3, #17, #1
	str	r3, [r2]
	bx	lr
.L95:
	.align	2
.L94:
	.word	.LANCHOR13
	.size	nandc_de_cs.constprop.29, .-nandc_de_cs.constprop.29
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
	ldr	r4, .L218
	ldr	r3, [r4]
	lsls	r3, r3, #19
	bpl	.L97
	ldr	r1, .L218+4
	ldr	r0, .L218+8
	bl	printf
.L97:
	ldr	r3, [r4]
	lsls	r5, r3, #19
	bpl	.L98
	ldr	r3, .L218+12
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
	ldr	r0, .L218+16
	bl	printf
.L98:
	ldr	r3, [r4]
	lsls	r0, r3, #19
	bpl	.L99
	ldr	r3, .L218+12
	ldr	r0, .L218+20
	ldr	r3, [r3]
	ldrb	r1, [r3, #8]	@ zero_extendqisi2
	bl	printf
.L99:
	ldr	r3, [r4]
	lsls	r1, r3, #19
	bpl	.L100
	ldr	r3, .L218+12
	ldr	r0, .L218+24
	ldr	r3, [r3]
	ldrb	r1, [r3, #9]	@ zero_extendqisi2
	bl	printf
.L100:
	ldr	r3, [r4]
	lsls	r2, r3, #19
	bpl	.L101
	ldr	r3, .L218+12
	ldr	r0, .L218+28
	ldr	r3, [r3]
	ldrh	r1, [r3, #10]
	bl	printf
.L101:
	ldr	r3, [r4]
	lsls	r3, r3, #19
	bpl	.L102
	ldr	r3, .L218+12
	ldr	r0, .L218+32
	ldr	r3, [r3]
	ldrb	r1, [r3, #12]	@ zero_extendqisi2
	bl	printf
.L102:
	ldr	r3, [r4]
	lsls	r5, r3, #19
	bpl	.L103
	ldr	r3, .L218+12
	ldr	r0, .L218+36
	ldr	r3, [r3]
	ldrb	r1, [r3, #13]	@ zero_extendqisi2
	bl	printf
.L103:
	ldr	r3, [r4]
	lsls	r0, r3, #19
	bpl	.L104
	ldr	r3, .L218+12
	ldr	r0, .L218+40
	ldr	r3, [r3]
	ldrh	r1, [r3, #14]
	bl	printf
.L104:
	ldr	r3, [r4]
	lsls	r1, r3, #19
	bpl	.L105
	ldr	r3, .L218+12
	ldr	r0, .L218+44
	ldr	r3, [r3]
	ldrb	r1, [r3, #23]	@ zero_extendqisi2
	bl	printf
.L105:
	ldr	r3, [r4]
	lsls	r2, r3, #19
	bpl	.L106
	ldr	r3, .L218+12
	ldr	r0, .L218+48
	ldr	r3, [r3]
	ldrb	r1, [r3, #18]	@ zero_extendqisi2
	bl	printf
.L106:
	ldr	r3, [r4]
	lsls	r3, r3, #19
	bpl	.L107
	ldr	r3, .L218+12
	ldr	r0, .L218+52
	ldr	r3, [r3]
	ldrb	r1, [r3, #19]	@ zero_extendqisi2
	bl	printf
.L107:
	ldr	r3, [r4]
	lsls	r5, r3, #19
	bpl	.L108
	ldr	r3, .L218+12
	ldr	r0, .L218+56
	ldr	r3, [r3]
	ldrb	r1, [r3, #20]	@ zero_extendqisi2
	bl	printf
.L108:
	ldr	r3, [r4]
	lsls	r0, r3, #19
	bpl	.L109
	ldr	r3, .L218+60
	ldr	r0, .L218+64
	ldrb	r1, [r3]	@ zero_extendqisi2
	bl	printf
.L109:
	ldr	r3, [r4]
	lsls	r1, r3, #19
	bpl	.L110
	ldr	r3, .L218+68
	ldr	r0, .L218+72
	ldrb	r1, [r3]	@ zero_extendqisi2
	bl	printf
.L110:
	ldr	r3, [r4]
	lsls	r2, r3, #19
	bpl	.L111
	ldr	r3, .L218+12
	ldr	r0, .L218+76
	ldr	r3, [r3]
	ldrb	r1, [r3, #22]	@ zero_extendqisi2
	bl	printf
.L111:
	ldr	r3, [r4]
	lsls	r3, r3, #19
	bpl	.L112
	ldr	r3, .L218+80
	ldr	r0, .L218+84
	ldrb	r1, [r3]	@ zero_extendqisi2
	bl	printf
.L112:
	ldr	r3, [r4]
	lsls	r5, r3, #19
	bpl	.L113
	ldr	r3, .L218+12
	ldr	r0, .L218+88
	ldr	r3, [r3]
	ldrb	r1, [r3, #16]	@ zero_extendqisi2
	and	r1, r1, #1
	bl	printf
.L113:
	ldr	r3, [r4]
	lsls	r0, r3, #19
	bpl	.L114
	ldr	r3, .L218+12
	ldr	r0, .L218+92
	ldr	r3, [r3]
	ldrh	r1, [r3, #16]
	ubfx	r1, r1, #1, #1
	bl	printf
.L114:
	ldr	r3, [r4]
	lsls	r1, r3, #19
	bpl	.L115
	ldr	r3, .L218+12
	ldr	r0, .L218+96
	ldr	r3, [r3]
	ldrh	r1, [r3, #16]
	ubfx	r1, r1, #2, #1
	bl	printf
.L115:
	ldr	r3, [r4]
	lsls	r2, r3, #19
	bpl	.L116
	ldr	r3, .L218+12
	ldr	r0, .L218+100
	ldr	r3, [r3]
	ldrh	r1, [r3, #16]
	ubfx	r1, r1, #3, #1
	bl	printf
.L116:
	ldr	r3, [r4]
	lsls	r3, r3, #19
	bpl	.L117
	ldr	r3, .L218+12
	ldr	r0, .L218+104
	ldr	r3, [r3]
	ldrh	r1, [r3, #16]
	ubfx	r1, r1, #4, #1
	bl	printf
.L117:
	ldr	r3, [r4]
	lsls	r5, r3, #19
	bpl	.L118
	ldr	r3, .L218+12
	ldr	r0, .L218+108
	ldr	r3, [r3]
	ldrh	r1, [r3, #16]
	ubfx	r1, r1, #5, #1
	bl	printf
.L118:
	ldr	r3, [r4]
	lsls	r0, r3, #19
	bpl	.L119
	ldr	r3, .L218+12
	ldr	r0, .L218+112
	ldr	r3, [r3]
	ldrh	r1, [r3, #16]
	ubfx	r1, r1, #6, #1
	bl	printf
.L119:
	ldr	r3, [r4]
	lsls	r1, r3, #19
	bpl	.L120
	ldr	r3, .L218+12
	ldr	r0, .L218+116
	ldr	r3, [r3]
	ldrh	r1, [r3, #16]
	ubfx	r1, r1, #7, #1
	bl	printf
.L120:
	ldr	r3, [r4]
	lsls	r2, r3, #19
	bpl	.L121
	ldr	r3, .L218+12
	ldr	r0, .L218+120
	ldr	r3, [r3]
	ldrh	r1, [r3, #16]
	ubfx	r1, r1, #8, #1
	bl	printf
.L121:
	ldr	r3, [r4]
	lsls	r3, r3, #19
	bpl	.L122
	ldr	r3, .L218+12
	ldr	r0, .L218+124
	ldr	r3, [r3]
	ldrh	r1, [r3, #16]
	ubfx	r1, r1, #9, #1
	bl	printf
.L122:
	ldr	r3, [r4]
	lsls	r5, r3, #19
	bpl	.L123
	ldr	r3, .L218+12
	ldr	r0, .L218+128
	ldr	r3, [r3]
	ldrh	r1, [r3, #16]
	ubfx	r1, r1, #10, #1
	bl	printf
.L123:
	ldr	r3, [r4]
	lsls	r0, r3, #19
	bpl	.L124
	ldr	r3, .L218+132
	ldr	r0, .L218+136
	ldrb	r2, [r3]	@ zero_extendqisi2
	ldr	r3, .L218+68
	ldrb	r1, [r3]	@ zero_extendqisi2
	bl	printf
.L124:
	ldr	r3, [r4]
	lsls	r1, r3, #19
	bpl	.L125
	ldr	r3, .L218+140
	ldr	r0, .L218+144
	ldrb	r2, [r3, #11]	@ zero_extendqisi2
	ldrb	r1, [r3, #10]	@ zero_extendqisi2
	bl	printf
.L125:
	ldr	r3, [r4]
	lsls	r2, r3, #19
	bpl	.L126
	ldr	r3, .L218+140
	ldr	r0, .L218+148
	ldrb	r2, [r3, #9]	@ zero_extendqisi2
	b	.L219
.L220:
	.align	2
.L218:
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
.L219:
	ldrb	r1, [r3, #8]	@ zero_extendqisi2
	bl	printf
.L126:
	ldr	r3, [r4]
	lsls	r3, r3, #19
	bpl	.L96
	ldr	r3, .L221
	ldr	r0, .L221+4
	ldrb	r1, [r3]	@ zero_extendqisi2
	add	sp, sp, #20
	@ sp needed
	pop	{r4, r5, lr}
	b	printf
.L96:
	add	sp, sp, #20
	@ sp needed
	pop	{r4, r5, pc}
.L222:
	.align	2
.L221:
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
.L224:
	ldr	r3, [sp, #4]
	subs	r2, r3, #1
	str	r2, [sp, #4]
	cmp	r3, #0
	bne	.L224
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
	ldr	r8, .L235+16
	mov	r5, r0
	movs	r4, #0
	ldr	r7, .L235
.L228:
	ldrb	r3, [r8]	@ zero_extendqisi2
	cmp	r4, r3
	bcc	.L232
	pop	{r4, r5, r6, r7, r8, pc}
.L232:
	movs	r3, #85
	movs	r0, #200
	str	r3, [r5, #8]
	ldrsb	r3, [r4, r7]
	str	r3, [r5, #4]
	bl	timer_delay_ns
	ldr	r3, .L235+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #34
	bne	.L229
	adds	r3, r4, r6
	add	r3, r3, r7
.L234:
	ldrsb	r3, [r3, #5]
.L233:
	str	r3, [r5]
	adds	r4, r4, #1
	b	.L228
.L229:
	cmp	r3, #35
	bne	.L231
	ldr	r3, .L235+8
	adds	r2, r4, r6
	add	r3, r3, r2
	b	.L234
.L231:
	ldr	r3, .L235+12
	ldrsb	r3, [r3, r1]
	b	.L233
.L236:
	.align	2
.L235:
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
	ldr	r3, .L242
	push	{r4, r5, r6, r7, r8, lr}
	lsls	r6, r0, #8
	ldr	r4, .L242+4
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
.L240:
	cmp	r5, r8
	bne	.L241
	add	r6, r6, r7
	movs	r3, #22
	str	r3, [r6, #2056]
	pop	{r4, r5, r6, r7, r8, pc}
.L241:
	ldrb	r3, [r5, #1]!	@ zero_extendqisi2
	movs	r0, #120
	str	r3, [r4, #2052]
	bl	timer_delay_ns
	ldrsb	r3, [r1, #1]!
	str	r3, [r4, #2048]
	b	.L240
.L243:
	.align	2
.L242:
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
	ldr	r3, .L249
	ldrb	r3, [r3]	@ zero_extendqisi2
	subs	r3, r3, #1
	cmp	r3, #7
	bhi	.L244
	ldr	r5, .L249+4
	ldr	r3, [r5]
	add	r3, r3, r0
	ldrb	r3, [r3, #120]	@ zero_extendqisi2
	cbz	r3, .L244
	movs	r1, #0
	bl	hynix_set_rr_para
	ldr	r0, [r5]
	movs	r3, #0
	add	r0, r0, r4
	strb	r3, [r0, #120]
.L244:
	pop	{r3, r4, r5, pc}
.L250:
	.align	2
.L249:
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
	ldr	r3, .L254
	ldr	r2, .L254+4
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
.L255:
	.align	2
.L254:
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
	ldr	r3, .L260
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #9
	ldr	r3, .L260+4
	ldr	r3, [r3]
	ite	eq
	ldreq	r0, [r3, #80]
	ldrne	r0, [r3, #304]
	ubfx	r0, r0, #8, #8
	bx	lr
.L261:
	.align	2
.L260:
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
	ldr	r3, .L270
	ands	r1, r0, #6
	ldr	r3, [r3]
	ldr	r2, [r3]
	beq	.L263
	lsls	r1, r0, #29
	ldr	r1, .L270+4
	orr	r2, r2, #24576
	bfc	r2, #15, #1
	ldrb	r1, [r1]	@ zero_extendqisi2
	orr	r2, r2, #196608
	it	mi
	orrmi	r2, r2, #32768
	cmp	r1, #9
	ldr	r1, .L270+8
	bne	.L265
	movw	r0, #8321
	str	r0, [r3, #8]
	str	r1, [r3, #80]
	movs	r1, #38
	str	r1, [r3, #84]
	movs	r1, #39
	str	r1, [r3, #84]
.L266:
	str	r2, [r3]
	bx	lr
.L265:
	movw	r0, #8322
	str	r0, [r3, #344]
	str	r1, [r3, #304]
	movs	r1, #38
	str	r1, [r3, #308]
	movs	r1, #39
	str	r1, [r3, #308]
	b	.L266
.L263:
	bfi	r2, r1, #13, #1
	b	.L266
.L271:
	.align	2
.L270:
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
	ldr	r3, .L273
	movs	r2, #1
	lsl	r0, r2, r0
	ldr	r1, [r3]
	ldr	r3, [r1]
	bfi	r3, r0, #0, #8
	str	r3, [r1]
	bx	lr
.L274:
	.align	2
.L273:
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
	ldr	r3, .L281
	push	{r4, r5, r6, r7, r8, lr}
	mov	r4, r0
	mov	r5, r1
	mov	r6, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r0
	bhi	.L276
	movw	r2, #677
	ldr	r1, .L281+4
	ldr	r0, .L281+8
	bl	printf
.L276:
	ldr	r3, .L281+12
	lsrs	r7, r5, #16
	ldrb	r8, [r3, r4]	@ zero_extendqisi2
	ldr	r3, .L281+16
	mov	r0, r8
	ldr	r4, [r3]
	bl	nandc_cs
	lsrs	r1, r5, #8
	uxtb	r5, r5
	add	r4, r4, r8, lsl #8
.L279:
	movs	r0, #120
	str	r0, [r4, #2056]
	str	r5, [r4, #2052]
	str	r1, [r4, #2052]
	str	r7, [r4, #2052]
	bl	timer_delay_ns
	ldr	r0, [r4, #2048]
	uxtb	r0, r0
	bics	r3, r6, r0
	bne	.L279
	cmp	r0, #255
	beq	.L279
	bl	nandc_de_cs.constprop.29
	pop	{r4, r5, r6, r7, r8, pc}
.L282:
	.align	2
.L281:
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
	tst	r0, #50331648
	push	{r3, r4, r5, r6, r7, r8, r10, lr}
	mov	r10, r1
	ubfx	r4, r0, #0, #21
	ubfx	r8, r0, #21, #3
	bne	.L284
	ldr	r3, .L293
	ldr	r6, .L293+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L285
	ldrb	r3, [r6]	@ zero_extendqisi2
	cbz	r3, .L284
.L285:
	ldr	r3, .L293+8
	mov	r0, r4
	ldrh	r5, [r3]
	mov	r1, r5
	bl	__aeabi_uidiv
	mov	r1, r5
	mul	r7, r5, r0
	mov	r0, r4
	bl	__aeabi_uidivmod
	ldrb	r3, [r6]	@ zero_extendqisi2
	cbz	r3, .L286
	add	r4, r7, r1, lsl #1
.L284:
	mov	r2, r10
	mov	r1, r4
	mov	r0, r8
	pop	{r3, r4, r5, r6, r7, r8, r10, lr}
	b	flash_wait_device_ready_raw
.L286:
	ldr	r3, .L293+12
	ldrh	r4, [r3, r1, lsl #1]
	add	r4, r4, r7
	b	.L284
.L294:
	.align	2
.L293:
	.word	.LANCHOR0
	.word	.LANCHOR1
	.word	.LANCHOR2
	.word	.LANCHOR3
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
	ldr	r3, .L296
	ldr	r2, [r3]
	ldr	r3, [r2]
	bfc	r3, #0, #8
	bfc	r3, #17, #1
	str	r3, [r2]
	bx	lr
.L297:
	.align	2
.L296:
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
	ldr	r1, .L303
	ldr	r4, .L303+4
.L300:
	ldr	r3, [r4]
	ldr	r3, [r3]
	str	r3, [sp, #4]
	ldr	r3, [sp, #4]
	lsls	r3, r3, #22
	bmi	.L301
	movs	r0, #10
	bl	timer_delay_ns
	subs	r1, r1, #1
	bne	.L300
	mov	r0, #-1
.L298:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, pc}
.L301:
	movs	r0, #0
	b	.L298
.L304:
	.align	2
.L303:
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
	ldr	r3, .L326
	push	{r4, lr}
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L305
	ldr	r2, .L326+4
	cmp	r3, #1
	ldr	r4, [r2]
	bne	.L308
.L325:
	ldr	r3, .L326+8
	ldrb	r3, [r3, #29]	@ zero_extendqisi2
	cbz	r3, .L305
	add	r4, r4, r0, lsl #8
	str	r3, [r4, #2056]
	pop	{r4, pc}
.L308:
	cmp	r3, #2
	bne	.L310
	ldr	r3, .L326+12
	ldrb	r2, [r3, r0]	@ zero_extendqisi2
	cbz	r2, .L305
	movs	r2, #0
	strb	r2, [r3, r0]
	b	.L325
.L310:
	cmp	r3, #3
	bne	.L305
	ldr	r3, .L326+12
	ldrb	r2, [r3, r0]	@ zero_extendqisi2
	cbz	r2, .L305
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
.L305:
	pop	{r4, pc}
.L327:
	.align	2
.L326:
	.word	.LANCHOR0
	.word	.LANCHOR13
	.word	.LANCHOR31
	.word	.LANCHOR32
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
	ldr	r3, .L351
	mov	r1, r0
	push	{r4, r5, r6, r7, r8, lr}
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L328
	ldr	r2, .L351+4
	cmp	r3, #1
	ldr	r5, [r2]
	bne	.L331
	ldr	r3, .L351+8
	ldrb	r3, [r3, #30]	@ zero_extendqisi2
.L350:
	cmp	r3, #0
	beq	.L328
	add	r1, r5, r1, lsl #8
	str	r3, [r1, #2056]
	pop	{r4, r5, r6, r7, r8, pc}
.L331:
	cmp	r3, #2
	bne	.L333
	ldr	r0, .L351+12
	ldrb	r3, [r0, r1]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L328
	ldr	r2, .L351+8
	ldrb	r3, [r2, #12]	@ zero_extendqisi2
	cmp	r3, #2
	it	ne
	movne	r3, #4
	strb	r3, [r0, r1]
	ldrb	r3, [r2, #30]	@ zero_extendqisi2
	b	.L350
.L333:
	cmp	r3, #3
	bne	.L328
	ldr	r6, .L351+12
	ldrb	r3, [r6, r0]	@ zero_extendqisi2
	cbnz	r3, .L328
	ldr	r8, .L351+8
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
.L328:
	pop	{r4, r5, r6, r7, r8, pc}
.L352:
	.align	2
.L351:
	.word	.LANCHOR0
	.word	.LANCHOR13
	.word	.LANCHOR31
	.word	.LANCHOR32
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
	ubfx	r4, r1, #21, #3
	ldr	r3, .L361
	mov	r7, r0
	ubfx	r5, r1, #0, #21
	ubfx	r8, r1, #24, #2
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r4
	bhi	.L354
	movw	r2, #845
	ldr	r1, .L361+4
	ldr	r0, .L361+8
	bl	printf
.L354:
	ldr	r3, .L361+12
	ldrb	r6, [r3, r4]	@ zero_extendqisi2
	ldr	r3, .L361+16
	mov	r0, r6
	ldr	r4, [r3]
	lsl	r10, r6, #8
	bl	nandc_cs
	cmp	r8, #0
	bne	.L355
	mov	r0, r5
	bl	slc_phy_page_address_calc
	ldr	r3, .L361+20
	mov	r5, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L356
	mov	r0, r6
	bl	zftl_flash_enter_slc_mode
.L356:
	add	r3, r4, r10
	movs	r2, #0
	str	r2, [r3, #2056]
	str	r2, [r3, #2052]
	str	r2, [r3, #2052]
	uxtb	r2, r5
	str	r2, [r3, #2052]
	lsrs	r2, r5, #8
	lsrs	r5, r5, #16
	str	r2, [r3, #2052]
	str	r5, [r3, #2052]
	str	r7, [r3, #2056]
	pop	{r3, r4, r5, r6, r7, r8, r10, lr}
	b	nandc_de_cs.constprop.29
.L355:
	ldr	r3, .L361+24
	ldr	r3, [r3]
	ldrb	r3, [r3, #12]	@ zero_extendqisi2
	cmp	r3, #3
	bne	.L357
	add	r3, r4, r10
	str	r8, [r3, #2056]
	b	.L356
.L357:
	mov	r0, r6
	bl	zftl_flash_exit_slc_mode
	b	.L356
.L362:
	.align	2
.L361:
	.word	.LANCHOR18
	.word	.LANCHOR33
	.word	.LC0
	.word	.LANCHOR30
	.word	.LANCHOR13
	.word	.LANCHOR0
	.word	.LANCHOR16
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
	ldr	r4, .L368
	ldr	r1, .L368+4
.L365:
	ldr	r3, [r4]
	ldr	r3, [r3]
	str	r3, [sp, #4]
	ldr	r3, [sp, #4]
	lsls	r3, r3, #22
	bmi	.L366
	movs	r0, #10
	bl	timer_delay_ns
	subs	r1, r1, #1
	bne	.L365
	mov	r0, #-1
.L363:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, pc}
.L366:
	movs	r0, #0
	b	.L363
.L369:
	.align	2
.L368:
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
	ldr	r3, .L376
	add	r1, r1, r1, lsl #2
	ldr	r6, .L376+4
	movs	r2, #0
	ldr	r7, .L376+8
	ldrb	r0, [r3]	@ zero_extendqisi2
	ldr	r3, .L376+12
	ldrb	r5, [r3]	@ zero_extendqisi2
.L371:
	cmp	r2, r0
	bcc	.L374
	pop	{r3, r4, r5, r6, r7, lr}
	b	nandc_wait_flash_ready
.L374:
	adds	r3, r2, r1
	cmp	r5, #67
	ite	eq
	addeq	r3, r3, r7
	addne	r3, r3, r6
	ldrsb	r3, [r3, #5]
	adds	r2, r2, #1
	str	r3, [r4]
	b	.L371
.L377:
	.align	2
.L376:
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
	ldr	r3, .L379
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
.L380:
	.align	2
.L379:
	.word	.LANCHOR34
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
	ldr	r2, .L382
	add	r1, r1, r2
	ldrsb	r2, [r1, #1]
	str	r2, [r0]
	str	r3, [r0]
	str	r3, [r0]
	str	r3, [r0]
	b	nandc_wait_flash_ready
.L383:
	.align	2
.L382:
	.word	.LANCHOR35
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
	cbz	r2, .L385
	movs	r3, #18
	rsb	r1, r1, r1, lsl #3
	str	r3, [r0, #4]
	ldr	r3, .L387
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
.L386:
	pop	{r4, r5, r6, lr}
	b	nandc_wait_flash_ready
.L385:
	movs	r3, #20
	str	r3, [r0, #4]
	ldr	r3, .L387+4
	ldrb	r3, [r3, r1]	@ zero_extendqisi2
	str	r3, [r0]
	str	r2, [r0]
	str	r2, [r0]
	str	r2, [r0]
	b	.L386
.L388:
	.align	2
.L387:
	.word	.LANCHOR36
	.word	.LANCHOR37
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
	mov	r8, r3
	ldr	r3, .L403
	mov	r4, r0
	mov	r5, r1
	mov	r6, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r0
	bhi	.L390
	mov	r2, #588
	ldr	r1, .L403+4
	ldr	r0, .L403+8
	bl	printf
.L390:
	ldr	r3, .L403+12
	ldrb	r4, [r3, r4]	@ zero_extendqisi2
	ldr	r3, .L403+16
	add	r7, r4, #8
	ldr	r10, [r3]
	ldr	r3, .L403+20
	ldr	r3, [r3]
	add	r7, r10, r7, lsl #8
	lsls	r3, r3, #27
	bpl	.L391
	mov	r3, r8
	mov	r2, r6
	mov	r1, r4
	ldr	r0, .L403+24
	bl	printf
.L391:
	bl	nandc_wait_flash_ready
	mov	r0, r4
	bl	nandc_cs
	mov	r0, r4
	cmp	r5, #0
	bne	.L392
	bl	zftl_flash_enter_slc_mode
.L393:
	lsls	r4, r4, #8
	movs	r3, #96
	add	r5, r10, r4
	str	r3, [r5, #2056]
	uxtb	r3, r6
	str	r3, [r5, #2052]
	lsrs	r3, r6, #8
	str	r3, [r5, #2052]
	lsrs	r3, r6, #16
	str	r3, [r5, #2052]
	ldr	r3, .L403+28
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L396
	movs	r3, #208
	str	r3, [r5, #2056]
	bl	nandc_wait_flash_ready
	mov	r0, r7
	bl	flash_read_status
	and	fp, r0, #5
.L394:
	add	r1, r10, r4
	movs	r3, #96
	str	r3, [r1, #2056]
	uxtb	r3, r8
	str	r3, [r5, #2052]
	lsr	r3, r8, #8
	str	r3, [r5, #2052]
	lsr	r3, r8, #16
	str	r3, [r5, #2052]
	movs	r3, #208
	str	r3, [r1, #2056]
	bl	nandc_wait_flash_ready
	mov	r0, r7
	bl	flash_read_status
	bl	nandc_de_cs.constprop.29
	and	r3, r0, #5
	orrs	fp, r3, fp
	beq	.L395
	mov	r2, r0
	mov	r1, r6
	ldr	r0, .L403+32
	bl	printf
.L395:
	mov	r0, fp
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L392:
	bl	zftl_flash_exit_slc_mode
	b	.L393
.L396:
	mov	fp, #0
	b	.L394
.L404:
	.align	2
.L403:
	.word	.LANCHOR18
	.word	.LANCHOR38
	.word	.LC0
	.word	.LANCHOR30
	.word	.LANCHOR13
	.word	.LANCHOR14
	.word	.LC32
	.word	.LANCHOR39
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
	ldr	r3, .L417
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r7, r0
	mov	fp, r1
	mov	r6, r2
	ubfx	r8, r2, #0, #21
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r0
	bhi	.L406
	movw	r2, #633
	ldr	r1, .L417+4
	ldr	r0, .L417+8
	bl	printf
.L406:
	ldr	r3, .L417+12
	ldrb	r5, [r3, r7]	@ zero_extendqisi2
	ldr	r3, .L417+16
	add	r10, r5, #8
	ldr	r4, [r3]
	ldr	r3, .L417+20
	ldr	r3, [r3]
	add	r10, r4, r10, lsl #8
	lsls	r3, r3, #27
	bpl	.L407
	mov	r3, fp
	mov	r2, r6
	mov	r1, r5
	ldr	r0, .L417+24
	bl	printf
.L407:
	bl	nandc_wait_flash_ready
	mov	r0, r5
	bl	nandc_cs
	mov	r0, r5
	cmp	fp, #0
	bne	.L408
	bl	zftl_flash_enter_slc_mode
.L409:
	add	r0, r4, r5, lsl #8
	movs	r3, #96
	str	r3, [r0, #2056]
	uxtb	r3, r6
	str	r3, [r0, #2052]
	lsr	r3, r8, #8
	str	r3, [r0, #2052]
	lsr	r3, r8, #16
	str	r3, [r0, #2052]
	movs	r3, #208
	str	r3, [r0, #2056]
	bl	nandc_wait_flash_ready
	mov	r0, r10
	bl	flash_read_status
	bl	nandc_de_cs.constprop.29
	ands	r4, r0, #5
	beq	.L410
	ldr	r3, .L417+28
	mov	r0, r6
	ldrh	r1, [r3]
	bl	__aeabi_uidiv
	mov	r3, r4
	mov	r2, r0
	mov	r1, r7
	ldr	r0, .L417+32
	bl	printf
.L410:
	mov	r0, r4
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L408:
	bl	zftl_flash_exit_slc_mode
	b	.L409
.L418:
	.align	2
.L417:
	.word	.LANCHOR18
	.word	.LANCHOR40
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
	ldr	r3, .L425
	push	{r4, r5, r6, r7, r8, lr}
	movs	r5, #0
	ldr	r7, .L425+4
	ldrb	r4, [r3, #13]	@ zero_extendqisi2
	ldrh	r3, [r3, #14]
	smulbb	r4, r4, r3
	uxth	r4, r4
.L421:
	ldr	r3, .L425+8
	ldrb	r2, [r3]	@ zero_extendqisi2
	uxth	r3, r5
	cmp	r2, r3
	bhi	.L424
	movs	r1, #0
	ldr	r0, .L425+12
	pop	{r4, r5, r6, r7, r8, lr}
	b	printf
.L424:
	ldr	r2, .L425+16
	uxth	r3, r5
	movs	r6, #0
	ldrb	r8, [r2, r3]	@ zero_extendqisi2
.L422:
	uxth	r3, r6
	cmp	r4, r3
	bhi	.L423
	adds	r5, r5, #1
	b	.L421
.L423:
	ldrh	r1, [r7]
	mov	r0, r8
	muls	r1, r6, r1
	adds	r6, r6, #1
	bl	flash_erase_block
	b	.L422
.L426:
	.align	2
.L425:
	.word	.LANCHOR31
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
	ldr	r3, .L446
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	ubfx	r4, r0, #21, #3
	ubfx	r6, r0, #0, #21
	ubfx	r5, r1, #0, #21
	ubfx	r7, r0, #24, #2
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r4
	bhi	.L428
	mov	r2, #940
	ldr	r1, .L446+4
	ldr	r0, .L446+8
	bl	printf
.L428:
	ldr	r3, .L446+12
	ldr	fp, .L446+28
	ldrb	r4, [r3, r4]	@ zero_extendqisi2
	ldr	r3, .L446+16
	mov	r0, r4
	ldr	r8, [r3]
	lsl	r10, r4, #8
	bl	nandc_cs
	cmp	r7, #0
	bne	.L429
	mov	r0, r6
	bl	slc_phy_page_address_calc
	mov	r6, r0
	mov	r0, r5
	bl	slc_phy_page_address_calc
	ldr	r3, .L446+20
	mov	r5, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L430
	mov	r0, r4
	bl	zftl_flash_enter_slc_mode
.L430:
	ldr	r3, .L446+24
	ldrb	r2, [r3, #16]	@ zero_extendqisi2
	mov	r0, r3
	ldrb	r1, [r3, #8]	@ zero_extendqisi2
	cmp	r2, #1
	uxtb	r2, r6
	bne	.L432
	add	r4, r8, r10
	ldrb	r3, [r3, #9]	@ zero_extendqisi2
	str	r1, [r4, #2056]
	movs	r1, #0
	str	r1, [r4, #2052]
	str	r1, [r4, #2052]
	str	r2, [r4, #2052]
	lsrs	r2, r6, #8
	lsrs	r6, r6, #16
	str	r2, [r4, #2052]
	str	r6, [r4, #2052]
	str	r3, [r4, #2056]
	bl	nandc_wait_flash_ready
	ldr	r3, [fp]
	ldrb	r3, [r3, #12]	@ zero_extendqisi2
	cmp	r3, #3
	bne	.L433
	cbz	r7, .L433
	str	r7, [r4, #2056]
.L433:
	movs	r3, #0
	add	r8, r8, r10
	str	r3, [r8, #2056]
	str	r3, [r4, #2052]
	str	r3, [r4, #2052]
	uxtb	r3, r5
	str	r3, [r4, #2052]
	lsrs	r3, r5, #8
	lsrs	r5, r5, #16
	str	r3, [r4, #2052]
	str	r5, [r4, #2052]
.L445:
	movs	r3, #48
	str	r3, [r8, #2056]
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	nandc_de_cs.constprop.29
.L429:
	ldr	r3, [fp]
	ldrb	r3, [r3, #12]	@ zero_extendqisi2
	cmp	r3, #3
	bne	.L431
	add	r3, r8, r10
	str	r7, [r3, #2056]
	b	.L430
.L431:
	mov	r0, r4
	bl	zftl_flash_exit_slc_mode
	b	.L430
.L432:
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
	bne	.L435
	cbz	r7, .L435
	str	r7, [r3, #2056]
.L435:
	ldrb	r2, [r0, #9]	@ zero_extendqisi2
	add	r8, r8, r10
	str	r2, [r8, #2056]
	uxtb	r2, r5
	str	r2, [r3, #2052]
	lsrs	r2, r5, #8
	lsrs	r5, r5, #16
	str	r2, [r3, #2052]
	str	r5, [r3, #2052]
	b	.L445
.L447:
	.align	2
.L446:
	.word	.LANCHOR18
	.word	.LANCHOR41
	.word	.LC0
	.word	.LANCHOR30
	.word	.LANCHOR13
	.word	.LANCHOR0
	.word	.LANCHOR20
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
	ldr	r7, .L491
	mov	r10, #0
	ldr	r8, .L491+24
.L462:
	ldrb	r5, [r7, r10, lsl #3]	@ zero_extendqisi2
	cmp	r5, #69
	beq	.L449
	cmp	r5, #44
	beq	.L449
	add	r3, r5, #119
	uxtb	r3, r3
	cmp	r3, #18
	bhi	.L450
	ldr	r2, .L491+4
	lsr	r3, r2, r3
	lsls	r2, r3, #31
	bpl	.L450
.L449:
	ldr	r3, .L491+8
	cmp	r6, #1
	ldr	r4, [r8]
	ldrb	r1, [r3]	@ zero_extendqisi2
	bne	.L451
	lsls	r3, r1, #31
	bpl	.L450
	ldr	r3, .L491+12
	ldr	r3, [r3]
	lsls	r0, r3, #19
	bpl	.L452
	ldr	r0, .L491+16
	bl	printf
.L452:
	lsl	r3, r10, #8
	cmp	r5, #44
	mov	r1, #239
	add	r2, r4, r3
	str	r1, [r2, #2056]
	beq	.L453
	cmp	r5, #137
	bne	.L454
.L453:
	movs	r1, #1
	adds	r2, r4, r3
	str	r1, [r2, #2052]
	movs	r1, #5
.L488:
	add	r4, r4, r3
	str	r1, [r2, #2048]
.L490:
	movs	r3, #0
	str	r3, [r4, #2048]
	str	r3, [r4, #2048]
	str	r3, [r4, #2048]
.L450:
	add	r10, r10, #1
	cmp	r10, #4
	bne	.L462
	bl	nandc_wait_flash_ready
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L454:
	cmp	r5, #155
	itett	eq
	moveq	r1, #1
	movne	r1, #128
	streq	r1, [r2, #2052]
	moveq	r1, #3
	itt	ne
	strne	r1, [r2, #2052]
	movne	r1, #1
	b	.L488
.L451:
	lsls	r2, r1, #29
	bpl	.L450
	ldr	r3, .L491+12
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L457
	ldr	r0, .L491+20
	bl	printf
.L457:
	lsl	r2, r10, #8
	cmp	r5, #44
	mov	r1, #239
	add	r3, r4, r2
	str	r1, [r3, #2056]
	beq	.L458
	cmp	r5, #137
	bne	.L459
.L458:
	movs	r1, #1
	adds	r3, r4, r2
	str	r1, [r3, #2052]
	movs	r1, #35
.L489:
	str	r1, [r3, #2048]
	add	r4, r4, r2
	b	.L490
.L459:
	cmp	r5, #155
	itett	eq
	moveq	r1, #1
	movne	r1, #128
	streq	r1, [r3, #2052]
	moveq	r1, #37
	itt	ne
	strne	r1, [r3, #2052]
	movne	r1, #0
	b	.L489
.L492:
	.align	2
.L491:
	.word	.LANCHOR42
	.word	294913
	.word	.LANCHOR43
	.word	.LANCHOR14
	.word	.LC37
	.word	.LC38
	.word	.LANCHOR13
	.size	flash_set_interface_mode, .-flash_set_interface_mode
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
	ldr	r3, .L494
	ldr	r3, [r3]
	add	r0, r3, r0, lsl #8
	movs	r3, #255
	str	r3, [r0, #2056]
	b	nandc_wait_flash_ready
.L495:
	.align	2
.L494:
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
	ldr	r3, .L498
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
	bl	nandc_de_cs.constprop.29
	ldrb	r2, [r4]	@ zero_extendqisi2
	subs	r3, r2, #1
	uxtb	r3, r3
	cmp	r3, #253
	bhi	.L496
	ldrb	r1, [r4, #5]	@ zero_extendqisi2
	ldrb	r3, [r4, #1]	@ zero_extendqisi2
	ldr	r0, .L498+4
	str	r1, [sp, #12]
	ldrb	r1, [r4, #4]	@ zero_extendqisi2
	str	r1, [sp, #8]
	ldrb	r1, [r4, #3]	@ zero_extendqisi2
	str	r1, [sp, #4]
	ldrb	r1, [r4, #2]	@ zero_extendqisi2
	str	r1, [sp]
	adds	r1, r5, #1
	bl	printf
.L496:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, pc}
.L499:
	.align	2
.L498:
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
	ldr	r3, .L501
	ldr	r2, .L501+4
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
.L502:
	.align	2
.L501:
	.word	.LANCHOR31
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
	ldr	r3, .L506
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
	ldr	r0, .L506+4
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
.L504:
	ldr	r1, [r4, #2048]
	strb	r1, [r2], #1
	cmp	r2, r3
	bne	.L504
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
	b	nandc_de_cs.constprop.29
.L507:
	.align	2
.L506:
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
	ldr	r3, .L518
	mov	r5, r1
	ldr	r4, [r3]
	ldr	r3, .L518+4
	ldrb	r3, [r3, #29]	@ zero_extendqisi2
	cbz	r3, .L509
	adds	r2, r4, r0
	str	r3, [r2, #2056]
.L510:
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
	beq	.L508
	ldr	r3, .L518+8
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L508
	mov	r1, r5
	ldr	r0, .L518+12
	bl	printf
.L508:
	mov	r0, r4
	pop	{r3, r4, r5, pc}
.L509:
	adds	r3, r4, r0
	movs	r2, #162
	str	r2, [r3, #2056]
	b	.L510
.L519:
	.align	2
.L518:
	.word	.LANCHOR13
	.word	.LANCHOR31
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
	ldr	r3, .L521
	sub	sp, sp, #8
	ldr	r3, [r3]
	ldr	r3, [r3]
	str	r3, [sp, #4]
	ldr	r0, [sp, #4]
	ubfx	r0, r0, #9, #1
	add	sp, sp, #8
	@ sp needed
	bx	lr
.L522:
	.align	2
.L521:
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
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r1, .L537
	movs	r2, #0
	push	{r4, lr}
	movs	r3, #1
	strb	r0, [r1]
	ldr	r1, .L537+4
	ldrb	r1, [r1]	@ zero_extendqisi2
	cmp	r1, #9
	ldr	r1, .L537+8
	ldr	r1, [r1]
	bne	.L524
	cmp	r0, #70
	str	r3, [r1, #16]
	beq	.L525
	cmp	r0, #60
	beq	.L532
	cmp	r0, #40
	ite	eq
	moveq	r2, #2
	movne	r2, r3
.L525:
	lsls	r3, r2, #25
	orr	r3, r3, #1
	str	r3, [r1, #32]
	pop	{r4, pc}
.L532:
	movs	r2, #3
	b	.L525
.L524:
	movs	r4, #16
	str	r3, [r1, #8]
	cmp	r0, r4
	mov	r3, r2
	bfi	r3, r4, #8, #8
	bfi	r3, r2, #18, #1
	bne	.L527
.L530:
	bfc	r3, #4, #1
.L528:
	orr	r3, r3, #1
	str	r3, [r1, #12]
	pop	{r4, pc}
.L527:
	cmp	r0, #24
	bne	.L529
	orr	r3, r3, #16
	b	.L528
.L529:
	cmp	r0, #40
	orr	r3, r3, #262144
	orr	r3, r3, #16
	bne	.L528
	b	.L530
.L538:
	.align	2
.L537:
	.word	.LANCHOR44
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
	ldr	r3, .L542
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #9
	ite	eq
	ldreq	r0, [r0, #296]
	ldrne	r0, [r0, #372]
	bx	lr
.L543:
	.align	2
.L542:
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
	mov	r7, r0
	ldr	r0, .L563
	adds	r6, r1, #1
	ldr	r5, .L563+4
	ldrb	r0, [r0]	@ zero_extendqisi2
	ldr	r10, .L563+24
	cmp	r0, #9
	bne	.L548
	movs	r4, #0
	movs	r1, #1
	bfi	r4, r7, #1, #1
	asrs	r6, r6, r1
	orr	r4, r4, #8
	bfi	r4, r1, #5, #2
	ldr	r1, .L563+8
	orr	r4, r4, #536870912
	orr	r4, r4, #1024
	ldrb	r1, [r1]	@ zero_extendqisi2
	bfc	r4, #4, #1
	bfi	r4, r6, #22, #6
	orr	r4, r4, #128
	cbz	r1, .L549
	ldr	r1, .L563+12
	ldrb	r1, [r1]	@ zero_extendqisi2
	cbz	r1, .L549
	orr	r4, r4, #512
.L549:
	add	r1, r2, #63
	and	r6, r6, #63
	bic	r1, r1, #63
	bic	r0, r2, #63
	add	r1, r1, r6, lsl #10
	str	r2, [r5, #4]
	str	r3, [r5, #8]
	clz	r7, r7
	str	r2, [r5, #12]
	lsrs	r7, r7, #5
	str	r3, [r5, #16]
	bl	flush_dcache_range
	ldr	r0, [r5, #8]
	add	r1, r0, #63
	bic	r0, r0, #63
	bic	r1, r1, #63
	add	r1, r1, r6, lsl #2
	bl	flush_dcache_range
	movs	r3, #1
	ldr	r2, [r10]
	str	r3, [r5, #20]
	movs	r1, #16
	ldr	r3, [r5, #12]
	str	r3, [r2, #52]
	ldr	r3, [r5, #16]
	str	r3, [r2, #56]
	ldr	r3, [r2, #48]
	bfi	r3, r1, #9, #5
	movs	r1, #2
	orr	r3, r3, #448
	bfi	r3, r1, #3, #3
	ldr	r1, .L563+16
	orr	r3, r3, #4
	bfi	r3, r7, #1, #1
	ldrh	r1, [r1]
	orr	r3, r3, #1
	bfi	r3, r1, #16, #11
	str	r3, [r2, #48]
	str	r4, [r2, #16]
	orr	r4, r4, #4
	str	r4, [r2, #16]
.L547:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L548:
	ldr	r0, [r10]
	movs	r4, #0
	bfi	r4, r7, #1, #1
	orr	r4, r4, #8
	ldr	r8, [r0, #12]
	movs	r0, #16
	bfi	r8, r0, #8, #8
	movs	r0, #1
	bfi	r4, r0, #5, #2
	asrs	r6, r6, r0
	orr	r4, r4, #536870912
	orr	r4, r4, #1024
	bfc	r8, #3, #1
	bfc	r4, #4, #1
	bfc	r8, #5, #3
	str	r6, [sp]
	bfi	r4, r6, #22, #6
	cmp	r7, #0
	beq	.L551
	ldr	r0, .L563+20
	lsrs	r1, r1, #1
	str	r1, [sp, #8]
	ldrb	r0, [r0]	@ zero_extendqisi2
	ldr	r1, [r5]
	cmp	r0, #24
	ite	hi
	movhi	r0, #128
	movls	r0, #64
	str	r1, [sp, #12]
	movs	r1, #0
	str	r0, [sp, #4]
	mov	r0, r1
.L553:
	ldr	r6, [sp, #4]
	add	fp, r3, r0, lsl #2
	add	lr, r6, r1
	ldr	r6, [sp, #8]
	cmp	r0, r6
	blt	.L554
.L555:
	ldr	r3, [r5]
	add	r1, r2, #63
	bic	r1, r1, #63
	bic	r0, r2, #63
	str	r2, [r5, #4]
	clz	r7, r7
	str	r3, [r5, #8]
	lsrs	r7, r7, #5
	str	r3, [r5, #16]
	ldr	r3, [sp]
	str	r2, [r5, #12]
	and	r6, r3, #63
	add	r1, r1, r6, lsl #10
	bl	flush_dcache_range
	ldr	r0, [r5, #8]
	add	r1, r0, #63
	bic	r0, r0, #63
	bic	r1, r1, #63
	add	r1, r1, r6, lsl #7
	bl	flush_dcache_range
	movs	r3, #1
	ldr	r2, [r10]
	str	r3, [r5, #20]
	movs	r1, #16
	ldr	r3, [r5, #12]
	str	r3, [r2, #20]
	ldr	r3, [r5, #16]
	str	r3, [r2, #24]
	movs	r3, #0
	bfi	r3, r1, #9, #5
	movs	r1, #2
	orr	r3, r3, #448
	bfi	r3, r1, #3, #3
	orr	r3, r3, #4
	bfi	r3, r7, #1, #1
	orr	r3, r3, #1
	str	r3, [r2, #16]
	str	r8, [r2, #12]
	str	r4, [r2, #8]
	orr	r4, r4, #4
	str	r4, [r2, #8]
	b	.L547
.L554:
	ldrh	ip, [r3, r0, lsl #2]
	bic	r1, r1, #3
	ldrh	fp, [fp, #2]
	adds	r0, r0, #1
	ldr	r6, [sp, #12]
	orr	ip, ip, fp, lsl #16
	str	ip, [r6, r1]
	mov	r1, lr
	b	.L553
.L551:
	ldr	r3, [r5]
	str	r0, [r3]
	b	.L555
.L564:
	.align	2
.L563:
	.word	.LANCHOR28
	.word	.LANCHOR47
	.word	.LANCHOR45
	.word	.LANCHOR46
	.word	.LANCHOR48
	.word	.LANCHOR44
	.word	.LANCHOR13
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
	ldr	r2, .L572
	and	r0, r0, #127
	ldr	r3, .L572+4
	ldrb	r2, [r2]	@ zero_extendqisi2
	ldrh	r3, [r3, r0, lsl #1]
	cbz	r2, .L566
	orr	r3, r3, #-1073741824
.L566:
	ldr	r2, .L572+8
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, #9
	ldr	r2, .L572+12
	ldr	r2, [r2]
	ite	eq
	streq	r3, [r2, #520]
	strne	r3, [r2, #336]
	bx	lr
.L573:
	.align	2
.L572:
	.word	.LANCHOR46
	.word	.LANCHOR49
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
	ldr	r3, .L590
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L575
	ldr	r3, .L590+4
	ldrb	r0, [r3]	@ zero_extendqisi2
	cbnz	r0, .L575
	bl	zftl_flash_exit_slc_mode
.L575:
	ldr	r4, .L590+8
	movs	r0, #0
	bl	hynix_reconfig_rr_para
	ldrb	r3, [r4]	@ zero_extendqisi2
	cbz	r3, .L576
	ldr	r3, .L590+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	lsls	r3, r3, #31
	bpl	.L576
	movs	r0, #1
	bl	flash_set_interface_mode
	movs	r0, #1
	bl	nandc_set_if_mode
	movs	r3, #0
	strb	r3, [r4]
.L576:
	ldr	r1, .L590+16
	ldrb	r3, [r1]	@ zero_extendqisi2
	cbz	r3, .L577
	movs	r0, #0
	strb	r0, [r1]
	bl	nandc_set_seed
	movs	r3, #1
	strb	r3, [r1]
.L577:
	movs	r0, #0
	pop	{r4, pc}
.L591:
	.align	2
.L590:
	.word	.LANCHOR0
	.word	.LANCHOR19
	.word	.LANCHOR21
	.word	.LANCHOR43
	.word	.LANCHOR46
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
	ldr	r3, .L593
	strb	r0, [r3]
	bx	lr
.L594:
	.align	2
.L593:
	.word	.LANCHOR46
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
	ldr	r3, .L596
	adds	r0, r0, #8
	ldr	r3, [r3]
	add	r0, r3, r0, lsl #8
	bx	lr
.L597:
	.align	2
.L596:
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
	ldr	r3, .L601
	movs	r2, #0
	push	{r4, r5, lr}
	mov	r1, r2
	mov	r4, r3
.L599:
	uxtb	r0, r2
	adds	r2, r2, #1
	cmp	r2, #32
	strb	r1, [r3, #2]
	add	r5, r0, #1
	strb	r0, [r3, #1]
	strb	r5, [r3]
	add	r3, r3, #48
	str	r1, [r3, #-40]
	bne	.L599
	movs	r3, #255
	strb	r3, [r4, #1488]
	ldr	r3, .L601+4
	strb	r1, [r3]
	ldr	r3, .L601+8
	strb	r2, [r3]
	pop	{r4, r5, pc}
.L602:
	.align	2
.L601:
	.word	.LANCHOR50
	.word	.LANCHOR51
	.word	.LANCHOR52
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
	bne	.L604
	ldrb	r3, [r1, #1]	@ zero_extendqisi2
	cmp	r3, #255
	bne	.L605
	movs	r2, #74
	ldr	r1, .L610
	ldr	r0, .L610+4
	bl	printf
.L605:
	ldrb	r3, [r4, #1]	@ zero_extendqisi2
	strb	r3, [r5]
	pop	{r4, r5, r6, pc}
.L604:
	ldr	r2, .L610+8
	movs	r1, #48
	mov	r6, r2
.L609:
	mov	r5, r3
	muls	r3, r1, r3
	ldrb	r3, [r2, r3]	@ zero_extendqisi2
	cmp	r3, #255
	bne	.L609
	ldrb	r3, [r4, #1]	@ zero_extendqisi2
	cmp	r3, #255
	bne	.L607
	movs	r2, #81
	ldr	r1, .L610
	ldr	r0, .L610+4
	bl	printf
.L607:
	movs	r3, #48
	ldrb	r2, [r4, #1]	@ zero_extendqisi2
	muls	r3, r5, r3
	strb	r2, [r6, r3]
	pop	{r4, r5, r6, pc}
.L611:
	.align	2
.L610:
	.word	.LANCHOR53
	.word	.LC0
	.word	.LANCHOR50
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
	ldr	r0, .L613
	pop	{r4, lr}
	b	buf_add_tail
.L614:
	.align	2
.L613:
	.word	.LANCHOR54
	.size	queue_read_cmd, .-queue_read_cmd
	.section	.text.buf_free,"ax",%progbits
	.align	1
	.global	buf_free
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	buf_free, %function
buf_free:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	mov	r1, r0
	ldrb	r3, [r0, #2]	@ zero_extendqisi2
	and	r3, r3, #8
	strb	r3, [r0, #2]
	cbz	r3, .L616
	ldr	r3, [r0, #20]
	adds	r3, r3, #1
	beq	.L616
	ldr	r0, .L624
	bl	buf_add_tail
.L617:
	ldr	r2, .L624+4
	ldrb	r3, [r2]	@ zero_extendqisi2
	adds	r3, r3, #1
	strb	r3, [r2]
	pop	{r3, pc}
.L616:
	ldr	r3, .L624
	ldrb	r2, [r3]	@ zero_extendqisi2
	strb	r2, [r1]
	ldrb	r2, [r1, #1]	@ zero_extendqisi2
	strb	r2, [r3]
	b	.L617
.L625:
	.align	2
.L624:
	.word	.LANCHOR51
	.word	.LANCHOR52
	.size	buf_free, .-buf_free
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
	ldr	r4, .L636
	ldrb	r3, [r4]	@ zero_extendqisi2
	cbz	r3, .L627
.L630:
	ldr	r5, .L636+4
	ldr	r2, .L636+8
	ldrb	r6, [r5]	@ zero_extendqisi2
	add	r0, r6, r6, lsl #1
	add	r0, r2, r0, lsl #4
	cbz	r7, .L628
.L629:
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
.L627:
	movs	r2, #121
	ldr	r1, .L636+12
	ldr	r0, .L636+16
	bl	printf
	ldrb	r3, [r4]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L630
.L632:
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, pc}
.L628:
	ldrb	r3, [r4]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L629
	b	.L632
.L637:
	.align	2
.L636:
	.word	.LANCHOR52
	.word	.LANCHOR51
	.word	.LANCHOR50
	.word	.LANCHOR55
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
	bne	.L639
	ldrb	r3, [r1]	@ zero_extendqisi2
	strb	r3, [r0]
.L644:
	movs	r0, #1
	pop	{r4, r5, pc}
.L642:
	mov	r5, r3
	muls	r3, r2, r3
	ldrb	r3, [r0, r3]	@ zero_extendqisi2
	cmp	r4, r3
	bne	.L641
	muls	r2, r5, r2
	ldrb	r3, [r1]	@ zero_extendqisi2
	strb	r3, [r0, r2]
	movs	r3, #255
	strb	r3, [r1]
	b	.L644
.L639:
	ldr	r0, .L645
	movs	r2, #48
.L641:
	cmp	r3, #255
	bne	.L642
	movs	r0, #0
	pop	{r4, r5, pc}
.L646:
	.align	2
.L645:
	.word	.LANCHOR50
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
	ldr	r4, .L652
	ldrb	r3, [r4]	@ zero_extendqisi2
	cbnz	r3, .L648
	movs	r2, #172
	ldr	r1, .L652+4
	ldr	r0, .L652+8
	bl	printf
.L648:
	ldrb	r3, [r4]	@ zero_extendqisi2
	cbz	r3, .L647
	mov	r1, r5
	ldr	r0, .L652+12
	bl	buf_remove_buf
	cmp	r0, #1
	bne	.L647
	ldrb	r3, [r4]	@ zero_extendqisi2
	subs	r3, r3, #1
	strb	r3, [r4]
	ldrb	r3, [r5, #2]	@ zero_extendqisi2
	orr	r3, r3, #1
	strb	r3, [r5, #2]
.L647:
	pop	{r3, r4, r5, pc}
.L653:
	.align	2
.L652:
	.word	.LANCHOR52
	.word	.LANCHOR56
	.word	.LC0
	.word	.LANCHOR51
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
	ldr	r2, .L655
	push	{r4, lr}
	lsrs	r4, r1, #5
	and	r1, r1, #31
	ldrb	r3, [r2, #13]	@ zero_extendqisi2
	ldrh	r2, [r2, #14]
	smulbb	r3, r3, r2
	ldr	r2, .L655+4
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
.L656:
	.align	2
.L655:
	.word	.LANCHOR31
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
	ldr	r3, .L658
	mov	r2, r1
	push	{r4, r5, r6, lr}
	mov	r5, r0
	mov	r6, r1
	mov	r1, r0
	ldrb	r4, [r3, #13]	@ zero_extendqisi2
	ldrh	r3, [r3, #14]
	ldr	r0, .L658+4
	smulbb	r4, r4, r3
	bl	printf
	uxth	r4, r4
	ldr	r3, .L658+8
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
.L659:
	.align	2
.L658:
	.word	.LANCHOR31
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
	ldr	r0, .L661
	bl	buf_add_tail
	ldr	r3, .L661+4
	ldrb	r0, [r3]	@ zero_extendqisi2
	adds	r0, r0, #1
	uxtb	r0, r0
	strb	r0, [r3]
	pop	{r3, pc}
.L662:
	.align	2
.L661:
	.word	.LANCHOR57
	.word	.LANCHOR58
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
	cbnz	r0, .L665
	ldr	r3, .L668
	ldr	r0, [r3]
	bx	lr
.L665:
	cmp	r0, #4
	ite	cc
	movcc	r0, #8192
	movcs	r0, #0
	bx	lr
.L669:
	.align	2
.L668:
	.word	.LANCHOR59
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
	ldr	r3, .L673
	ldrh	r0, [r3]
	bx	lr
.L674:
	.align	2
.L673:
	.word	.LANCHOR60
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
	ldr	r3, .L676
	ldrh	r0, [r3]
	bx	lr
.L677:
	.align	2
.L676:
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
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L712
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r5, r0
	sub	sp, sp, #24
	mov	r4, r1
	mov	r8, r2
	ldrh	r3, [r3]
	cmp	r3, r0
	bhi	.L680
	movw	r2, #339
	ldr	r1, .L712+4
	ldr	r0, .L712+8
	bl	printf
.L680:
	ldr	r3, .L712+12
	lsl	r10, r5, #2
	ldr	r6, .L712+16
	ldr	fp, .L712+44
	ldr	r2, [r3]
	str	r3, [sp, #20]
	ldrh	r7, [r2, r5, lsl #1]
	ldr	r2, [r6]
	tst	r2, #256
	beq	.L681
	ldr	r2, .L712+20
	mov	r1, r5
	ldr	r3, [fp]
	ldr	r0, .L712+24
	ldrh	r2, [r2]
	add	r3, r3, r10
	ldrb	r3, [r3, #2]	@ zero_extendqisi2
	str	r2, [sp, #8]
	ldr	r2, .L712+28
	lsrs	r3, r3, #5
	ldrh	r2, [r2, #52]
	str	r7, [sp]
	str	r2, [sp, #4]
	mov	r2, r4
	bl	printf
.L681:
	ldr	r3, [fp]
	add	r10, r10, r3
	ldrb	r2, [r10, #2]	@ zero_extendqisi2
	ands	r10, r2, #224
	bne	.L682
	cmp	r7, #0
	beq	.L702
	mov	r2, #344
	ldr	r1, .L712+4
	ldr	r0, .L712+8
	bl	printf
.L700:
	movs	r0, #0
	b	.L679
.L682:
	ldr	r1, .L712+28
	ldrh	r3, [r1]
	cmp	r3, r5
	beq	.L700
	ldr	r7, .L712+32
	ldr	r3, [r7]
	ldrh	r0, [r3, #48]
	cmp	r0, r5
	beq	.L700
	ldrh	r0, [r3, #16]
	cmp	r0, r5
	beq	.L700
	ldrh	r0, [r3, #80]
	cmp	r0, r5
	beq	.L700
	ldrh	ip, [r1, #52]!
	movs	r0, #0
.L684:
	cmp	r0, ip
	bcc	.L685
	cmp	r4, #0
	bne	.L689
	ldr	r1, .L712+36
	ldrh	r0, [r1]
	cmp	r5, r0
	beq	.L700
	ldr	lr, .L712+48
	mov	r1, r4
.L688:
	ldrh	r10, [lr, r1, lsl #1]
	cmp	r5, r10
	bne	.L687
	ldr	r7, [r6]
	ands	r7, r7, #256
	beq	.L702
	ldr	r3, [sp, #20]
	lsrs	r2, r2, #5
	mov	r1, r5
	ldr	r3, [r3]
	ldrh	r3, [r3, r5, lsl #1]
	str	r0, [sp, #4]
	str	r5, [sp]
	ldr	r0, .L712+40
	bl	printf
	b	.L700
.L685:
	ldrh	lr, [r1, #2]!
	cmp	lr, r5
	beq	.L700
	adds	r0, r0, #1
	b	.L684
.L687:
	adds	r1, r1, #1
	cmp	r1, #8
	bne	.L688
	add	r3, r3, r8, lsl #7
	add	r10, r3, #136
.L690:
	ldr	r3, [r6]
	lsls	r3, r3, #23
	bpl	.L691
	ldr	r3, .L712+20
	mov	r1, r5
	ldr	r0, .L712+24
	ldrh	r3, [r3]
	str	ip, [sp, #4]
	str	r3, [sp, #8]
	ldr	r3, [sp, #20]
	ldr	r3, [r3]
	ldrh	r3, [r3, r5, lsl #1]
	str	r3, [sp]
	lsrs	r3, r2, #5
	mov	r2, r4
	bl	printf
.L691:
	mov	r3, r10
	add	r1, r10, #128
	movw	r0, #65535
.L694:
	mov	r2, r3
	adds	r3, r3, #2
	ldrh	r6, [r2]
	cmp	r6, r0
	bne	.L692
	strh	r5, [r2]	@ movhi
	cbz	r4, .L693
	ldr	r2, [r7]
	ldrh	r3, [r2, #124]
	adds	r3, r3, #1
	strh	r3, [r2, #124]	@ movhi
.L711:
	movs	r0, #1
.L679:
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L689:
	add	r10, r3, #392
	b	.L690
.L693:
	ldr	r3, [r7]
	add	r8, r3, r8, lsl #1
	ldrh	r3, [r8, #120]
	adds	r3, r3, #1
	strh	r3, [r8, #120]	@ movhi
	b	.L711
.L692:
	cmp	r1, r3
	bne	.L694
	b	.L711
.L702:
	mov	r0, r7
	b	.L679
.L713:
	.align	2
.L712:
	.word	.LANCHOR6
	.word	.LANCHOR61
	.word	.LC0
	.word	.LANCHOR9
	.word	.LANCHOR14
	.word	.LANCHOR62
	.word	.LC43
	.word	.LANCHOR63
	.word	.LANCHOR10
	.word	.LANCHOR64
	.word	.LC44
	.word	.LANCHOR7
	.word	.LANCHOR65
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
	mov	r8, r0
	ldr	r3, .L718
	movs	r7, #1
	ldr	r4, .L718+4
	ldrh	r0, [r3]
	ldr	r3, .L718+8
	lsr	r6, r8, r0
	rsb	r0, r0, #21
	lsl	r0, r7, r0
	ldrb	r1, [r3]	@ zero_extendqisi2
	uxth	r5, r6
	subs	r0, r0, #1
	ands	r0, r0, r6
	bl	__aeabi_uidiv
	uxth	r10, r0
	mov	r3, r8
	mov	r2, r5
	ldr	r1, [r4, #324]
	ldr	r0, .L718+12
	bl	printf
	mov	r1, r7
	movs	r2, #0
	mov	r0, r10
	bl	gc_add_sblk
	ldr	r3, [r4, #324]
	movs	r1, #0
.L715:
	uxth	r2, r1
	cmp	r3, r2
	bhi	.L717
	cmp	r3, #5
	itttt	ls
	addls	r2, r3, #1
	addls	r3, r3, #164
	strls	r2, [r4, #324]
	strhls	r5, [r4, r3, lsl #1]	@ movhi
	b	.L716
.L717:
	adds	r2, r2, #164
	adds	r1, r1, #1
	ldrh	r2, [r4, r2, lsl #1]
	cmp	r5, r2
	bne	.L715
.L716:
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L719:
	.align	2
.L718:
	.word	.LANCHOR66
	.word	.LANCHOR63
	.word	.LANCHOR67
	.word	.LC45
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
	ldr	r3, .L721
	ldr	r3, [r3]
	ldr	r0, [r3, r0, lsl #2]
	bx	lr
.L722:
	.align	2
.L721:
	.word	.LANCHOR68
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
	ldr	r5, .L752
.L724:
	ldr	r1, .L752+4
	ldrb	r7, [r1]	@ zero_extendqisi2
	cmp	r7, #255
	bne	.L737
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L737:
	movs	r3, #48
	muls	r3, r7, r3
	adds	r2, r5, r3
	ldrb	r3, [r5, r3]	@ zero_extendqisi2
	ldrh	r6, [r2, #32]
	strb	r3, [r1]
	ldr	r1, [r2, #36]
	cbz	r1, .L725
	ldr	r3, .L752+8
	movs	r0, #1
	ldr	r2, [r2, #24]
	strh	r0, [r3, #316]	@ movhi
	ldr	r0, .L752+12
	str	r2, [r3, #320]
	bl	printf
	movw	r2, #673
	ldr	r1, .L752+16
	ldr	r0, .L752+20
	bl	printf
.L725:
	ldr	fp, .L752+48
	ldrb	r3, [fp]	@ zero_extendqisi2
	cmp	r3, #3
	bne	.L726
	ldr	r3, .L752+24
	ldr	r3, [r3]
	ldrb	r4, [r3, #89]	@ zero_extendqisi2
	add	r4, r4, r4, lsl #1
.L727:
	ldr	r3, .L752+28
	ldr	r10, .L752+52
	ldr	r3, [r3]
	tst	r3, #256
	beq	.L728
	movs	r3, #48
	mov	r1, r6
	mla	r3, r3, r7, r5
	ldr	r0, .L752+32
	ldrb	r2, [r3, #1]	@ zero_extendqisi2
	ldr	r3, [r10]
	ldrb	r3, [r3, r6]	@ zero_extendqisi2
	str	r3, [sp]
	mov	r3, r6
	bl	printf
.L728:
	movs	r3, #48
	ldr	r2, [r10]
	mla	r3, r3, r7, r5
	ldrb	r2, [r2, r6]	@ zero_extendqisi2
	mov	r8, r6
	ldrb	r3, [r3, #1]	@ zero_extendqisi2
	cmp	r2, r3
	beq	.L729
	movw	r2, #682
	ldr	r1, .L752+16
	ldr	r0, .L752+20
	bl	printf
.L729:
	movs	r3, #48
	mla	r7, r3, r7, r5
	ldrb	r3, [r7, #45]	@ zero_extendqisi2
	cmp	r3, #3
	beq	.L730
	ldrb	r3, [fp]	@ zero_extendqisi2
	cmp	r3, #3
	bne	.L730
	ldr	r3, .L752+36
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L730
	ldr	r3, .L752+40
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L731
	ldr	r3, .L752+44
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L730
.L731:
	ldr	r2, [r10]
	movs	r3, #0
	movs	r1, #48
	mov	r0, r3
	add	r6, r6, r2
.L732:
	uxth	r2, r3
	cmp	r4, r2
	bls	.L724
	ldrb	r2, [r6, r3]	@ zero_extendqisi2
	adds	r3, r3, #1
	mla	r2, r1, r2, r5
	strb	r0, [r2, #45]
	b	.L732
.L726:
	ldr	r3, .L752+40
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L739
	ldr	r3, .L752+44
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L739
	ldr	r3, .L752+24
	ldr	r3, [r3]
	ldrb	r4, [r3, #89]	@ zero_extendqisi2
	lsls	r4, r4, #1
	b	.L727
.L739:
	movs	r4, #1
	b	.L727
.L730:
	ldr	r7, .L752+8
	mov	fp, #255
	movs	r3, #48
	strh	r6, [r7, #312]	@ movhi
.L733:
	sub	r2, r8, r6
	uxth	r2, r2
	cmp	r4, r2
	bls	.L724
	ldr	r2, [r10]
	movs	r1, #0
	str	r3, [sp, #12]
	ldrb	r0, [r2, r8]	@ zero_extendqisi2
	strb	fp, [r2, r8]
	add	r8, r8, #1
	mla	r2, r3, r0, r5
	add	r0, r0, r0, lsl #1
	strb	r1, [r2, #45]
	add	r0, r5, r0, lsl #4
	bl	buf_free
	ldrb	r2, [r7, #7]	@ zero_extendqisi2
	ldr	r3, [sp, #12]
	subs	r2, r2, #1
	strb	r2, [r7, #7]
	b	.L733
.L753:
	.align	2
.L752:
	.word	.LANCHOR50
	.word	.LANCHOR69
	.word	.LANCHOR63
	.word	.LC46
	.word	.LANCHOR70
	.word	.LC0
	.word	.LANCHOR10
	.word	.LANCHOR14
	.word	.LC47
	.word	.LANCHOR75
	.word	.LANCHOR72
	.word	.LANCHOR73
	.word	.LANCHOR71
	.word	.LANCHOR74
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
	ldr	r3, .L763
	push	{r4, r5, r6, r7, lr}
	ldr	r2, [r3]
	ldr	r3, .L763+4
	ldrh	r4, [r2, #124]
	ldrb	r1, [r3]	@ zero_extendqisi2
	cbz	r4, .L755
	add	r3, r2, #392
	movs	r4, #1
.L756:
	add	r6, r3, #128
	movw	r5, #65535
.L760:
	mov	r7, r3
	ldrh	r0, [r3], #2
	cmp	r0, r5
	beq	.L758
	strh	r5, [r7]	@ movhi
	cbz	r4, .L759
	ldrh	r3, [r2, #124]
	subs	r3, r3, #1
	strh	r3, [r2, #124]	@ movhi
	pop	{r4, r5, r6, r7, pc}
.L755:
	add	r3, r1, #60
	ldrh	r3, [r2, r3, lsl #1]
	cbz	r3, .L761
	add	r3, r2, r1, lsl #7
	adds	r3, r3, #136
	b	.L756
.L759:
	add	r2, r2, r1, lsl #1
	ldrh	r3, [r2, #120]
	subs	r3, r3, #1
	strh	r3, [r2, #120]	@ movhi
	pop	{r4, r5, r6, r7, pc}
.L758:
	cmp	r3, r6
	bne	.L760
	pop	{r4, r5, r6, r7, pc}
.L761:
	movw	r0, #65535
	pop	{r4, r5, r6, r7, pc}
.L764:
	.align	2
.L763:
	.word	.LANCHOR10
	.word	.LANCHOR76
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
	ldr	r5, .L779
	ldrb	r0, [r5, #7]	@ zero_extendqisi2
	cbz	r0, .L765
	ldr	r3, .L779+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #1
	bhi	.L772
	ldr	r3, .L779+8
	movs	r7, #48
	ldrh	r4, [r5, #312]
	ldr	r6, .L779+12
	ldrh	r2, [r3]
	ldr	r3, .L779+16
	add	r1, r4, #24
	ldr	r0, .L779+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	muls	r2, r3, r2
	cmp	r2, r1
	it	cs
	movcs	r2, r1
	ldr	r1, [r6]
.L767:
	cmp	r4, r2
	bcc	.L770
.L772:
	movs	r0, #0
.L765:
	pop	{r3, r4, r5, r6, r7, pc}
.L770:
	ldrb	r3, [r1, r4]	@ zero_extendqisi2
	cmp	r3, #255
	beq	.L768
	mla	ip, r7, r3, r0
	ldrb	ip, [ip, #45]	@ zero_extendqisi2
	cmp	ip, #0
	bne	.L768
	add	r3, r3, r3, lsl #1
	add	r0, r0, r3, lsl #4
	bl	buf_free
	ldr	r3, .L779+24
	ldr	r3, [r3]
	lsls	r3, r3, #23
	bpl	.L769
	ldr	r3, [r6]
	mov	r1, r4
	ldr	r0, .L779+28
	ldrb	r2, [r3, r4]	@ zero_extendqisi2
	bl	printf
.L769:
	ldr	r3, [r6]
	movs	r2, #255
	movs	r0, #1
	strb	r2, [r3, r4]
	ldrb	r3, [r5, #7]	@ zero_extendqisi2
	subs	r3, r3, #1
	strb	r3, [r5, #7]
	pop	{r3, r4, r5, r6, r7, pc}
.L768:
	adds	r4, r4, #1
	b	.L767
.L780:
	.align	2
.L779:
	.word	.LANCHOR63
	.word	.LANCHOR52
	.word	.LANCHOR77
	.word	.LANCHOR74
	.word	.LANCHOR78
	.word	.LANCHOR50
	.word	.LANCHOR14
	.word	.LC48
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
	ldr	r4, .L782
	ldr	r0, .L782+4
	ldrh	r4, [r4]
	ldrh	r3, [r0, #310]
	ldrh	r2, [r0, #2]
	ldrh	r1, [r0]
	str	r4, [sp, #8]
	ldrb	r0, [r0, #7]	@ zero_extendqisi2
	str	r0, [sp, #4]
	ldr	r0, .L782+8
	ldrb	r0, [r0]	@ zero_extendqisi2
	str	r0, [sp]
	ldr	r0, .L782+12
	bl	printf
	add	sp, sp, #16
	@ sp needed
	pop	{r4, pc}
.L783:
	.align	2
.L782:
	.word	.LANCHOR79
	.word	.LANCHOR63
	.word	.LANCHOR52
	.word	.LC49
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
	bne	.L785
	ldr	r3, .L788
	mov	r1, r0
.L787:
	ldr	r0, [r3]
	b	_list_get_gc_head_node.isra.2
.L785:
	cmp	r1, #2
	bne	.L786
	b	zftl_get_gc_node.part.9
.L786:
	mov	r1, r0
	ldr	r3, .L788+4
	b	.L787
.L789:
	.align	2
.L788:
	.word	.LANCHOR80
	.word	.LANCHOR81
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
	ldr	r3, .L889
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #32
	str	r2, [sp, #12]
	add	r2, r0, #60
	mov	fp, r0
	ldr	r3, [r3]
	str	r1, [sp, #16]
	ldrh	r5, [r3, r2, lsl #1]
	cbz	r5, .L791
	mov	r0, r5
.L790:
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L791:
	cmp	r0, #0
	bne	.L793
	ldr	r10, .L889+28
	mov	r4, r0
	ldr	r6, .L889+4
	mov	r8, r0
	strh	r0, [r6]	@ movhi
.L794:
	ldrh	r5, [sp, #12]
	uxth	r3, r8
	cmp	r3, r5
	bcs	.L799
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
	beq	.L795
	ldr	r3, .L889+8
	ldr	r3, [r3]
	lsls	r3, r3, #23
	bpl	.L796
	ldr	r3, [r10]
	mov	r1, r0
	ldrh	r3, [r3, r0, lsl #1]
	ldr	r0, .L889+12
	bl	printf
.L796:
	ldr	r3, [r10]
	ldrh	r2, [r3, r7, lsl #1]
	ldr	r3, .L889+16
	ldrh	r3, [r3]
	cmp	r2, r3
	bcs	.L795
	movs	r2, #0
	mov	r0, r7
	mov	r1, r2
	bl	gc_add_sblk
	cmp	r0, #0
	beq	.L798
	adds	r4, r4, #1
	uxth	r4, r4
	cmp	r5, r4
	bcs	.L798
.L799:
	ldr	r3, [sp, #16]
	lsls	r0, r3, #30
	bpl	.L801
	ldr	r6, .L889+20
	mov	r8, #0
	ldr	r7, .L889+24
.L802:
	uxth	r3, r8
	cmp	r5, r3
	bls	.L806
	ldrh	r10, [r7]
	movs	r1, #5
	mov	r0, r10
	add	r10, r10, #1
	bl	zftl_get_gc_node
	movw	r2, #65535
	strh	r10, [r7]	@ movhi
	cmp	r0, r2
	beq	.L803
	ldr	r2, .L889+28
	ldrh	r3, [r6]
	ldr	r2, [r2]
	ldrh	r2, [r2, r0, lsl #1]
	cmp	r2, r3
	bcs	.L803
	movs	r2, #0
	mov	r1, r2
	bl	gc_add_sblk
	cmp	r0, #0
	beq	.L805
	adds	r4, r4, #1
	uxth	r4, r4
	cmp	r5, r4
	bcs	.L805
.L806:
	cmp	r4, r5
	ldr	r1, .L889+32
	bcs	.L808
	ldr	r3, .L889+36
	ldrh	r1, [r1]
	ldrh	r2, [r6]
	ldrh	r0, [r3]
	ldr	r3, .L889+40
	ldrb	r3, [r3]	@ zero_extendqisi2
	muls	r3, r0, r3
	sub	r3, r3, r1, lsr #2
	cmp	r2, r3
	bge	.L801
	add	r2, r2, r1, lsr #3
	strh	r2, [r6]	@ movhi
.L801:
	ldr	r3, [sp, #16]
	lsls	r1, r3, #31
	bpl	.L809
	cmp	r4, r5
	bcs	.L809
	ldr	r8, .L889+48
	movs	r6, #0
	movw	r7, #65535
.L814:
	ldrh	r10, [r8]
	mov	r0, r10
	add	r10, r10, #1
	bl	zftl_get_gc_node.part.9
	cmp	r0, r7
	strh	r10, [r8]	@ movhi
	beq	.L810
	movs	r2, #0
	mov	r1, r2
	bl	gc_add_sblk
	cmp	r0, #0
	beq	.L811
	adds	r4, r4, #1
	uxth	r4, r4
	cmp	r5, r4
	bhi	.L811
.L812:
	ldr	r3, .L889+32
	ldr	r2, .L889+16
	ldrh	r1, [r3]
	ldrh	r3, [r2]
	cmp	r3, r1, lsr #1
	bls	.L809
	sub	r3, r3, r1, lsr #3
	b	.L888
.L795:
	movs	r3, #0
	strh	r3, [r6]	@ movhi
	b	.L799
.L798:
	add	r8, r8, #1
	b	.L794
.L803:
	movs	r3, #0
	strh	r3, [r7]	@ movhi
	b	.L806
.L805:
	add	r8, r8, #1
	b	.L802
.L808:
	ldrh	r3, [r6]
	ldrh	r2, [r1]
	cmp	r3, r2
	itt	hi
	subhi	r3, r3, r2, lsr #3
	strhhi	r3, [r6]	@ movhi
	b	.L801
.L810:
	movs	r3, #0
	strh	r3, [r8]	@ movhi
.L813:
	cmp	r4, r5
	bcs	.L812
	ldr	r2, .L889+16
	ldr	r1, .L889+32
	ldrh	r3, [r2]
	ldrh	r1, [r1]
	cmp	r3, r1
	bcs	.L809
	add	r3, r3, r1, lsr #3
.L888:
	strh	r3, [r2]	@ movhi
.L809:
	ldr	r3, .L889+8
	ldr	r3, [r3]
	lsls	r3, r3, #23
	bpl	.L836
	ldr	r3, [sp, #12]
	mov	r1, fp
	ldr	r2, [sp, #16]
	ldr	r0, .L889+44
	str	r3, [sp]
	mov	r3, r4
	bl	printf
.L836:
	mov	r0, r4
	b	.L790
.L811:
	adds	r6, r6, #1
	uxth	r3, r6
	cmp	r5, r3
	bhi	.L814
	b	.L813
.L890:
	.align	2
.L889:
	.word	.LANCHOR10
	.word	.LANCHOR82
	.word	.LANCHOR14
	.word	.LC50
	.word	.LANCHOR62
	.word	.LANCHOR84
	.word	.LANCHOR83
	.word	.LANCHOR9
	.word	.LANCHOR85
	.word	.LANCHOR77
	.word	.LANCHOR78
	.word	.LC51
	.word	.LANCHOR86
.L793:
	ldr	r3, .L891
	strh	r5, [r3, #314]	@ movhi
	ldr	r3, .L891+4
	strh	r5, [r3]	@ movhi
	ldr	r3, [sp, #16]
	ands	r3, r3, #1
	str	r3, [sp, #20]
	beq	.L839
	ldr	r1, .L891+8
	ldr	r2, .L891+12
	ldr	r6, .L891+16
	ldrh	r3, [r1]
	mov	r10, r1
	ldrh	r0, [r2]
	str	r2, [sp, #24]
	cmp	r3, r0, lsr #2
	bcc	.L816
	ldrh	r2, [r6]
	cmp	r2, r3
	bls	.L840
.L816:
	ldrh	r3, [r6]
	movs	r0, #0
	ldr	r4, .L891+20
	lsrs	r3, r3, #2
	strh	r3, [r4]	@ movhi
	bl	zftl_get_gc_node.part.9
	movw	r2, #65535
	cmp	r0, r2
	beq	.L841
	ldr	r2, .L891+24
	ldr	r1, [r2]
	ldr	r2, .L891+28
	ldrh	r3, [r1, r0, lsl #1]
	movs	r1, #0
	ldrh	r2, [r2]
	cmp	r3, r2, lsr #2
	bcs	.L842
	mov	r2, fp
	strh	r1, [r4]	@ movhi
	bl	gc_add_sblk
	adds	r4, r0, #0
	it	ne
	movne	r4, #1
.L818:
	ldr	r7, .L891+20
	mov	r8, #64
.L820:
	ldrh	r2, [r7]
	mov	r0, r2
	str	r2, [sp, #28]
	bl	zftl_get_gc_node.part.9
	ldr	r2, [sp, #28]
	movw	r3, #65535
	cmp	r0, r3
	add	r2, r2, #1
	strh	r2, [r7]	@ movhi
	beq	.L817
	mov	r2, fp
	movs	r1, #0
	bl	gc_add_sblk
	cbz	r0, .L819
	adds	r4, r4, #1
	ldr	r3, [sp, #12]
	uxth	r4, r4
	cmp	r4, r3
	bcs	.L817
.L819:
	add	r3, r8, #-1
	uxth	r8, r3
	cmp	r8, #0
	bne	.L820
.L817:
	ldr	r3, [sp, #24]
	ldrh	r2, [r10]
	ldrh	r3, [r3]
	cmp	r2, r3, lsr #3
	bhi	.L837
	ldrh	r3, [r6]
	adds	r3, r3, #8
	cmp	r2, r3
	ble	.L815
.L837:
	ldr	r6, .L891+32
	mov	r8, #64
	movw	r7, #65535
	movs	r3, #0
	strh	r3, [r6]	@ movhi
.L822:
	ldrh	r10, [r6]
	movs	r1, #3
	mov	r0, r10
	add	r10, r10, #1
	bl	zftl_get_gc_node
	cmp	r0, r7
	strh	r10, [r6]	@ movhi
	beq	.L815
	mov	r2, fp
	movs	r1, #0
	bl	gc_add_sblk
	cbz	r0, .L821
	adds	r4, r4, #1
	ldr	r3, [sp, #12]
	uxth	r4, r4
	cmp	r4, r3
	bcs	.L815
.L821:
	add	r8, r8, #-1
	uxth	r8, r8
	cmp	r8, #0
	bne	.L822
.L815:
	ldr	r3, [sp, #16]
	lsls	r2, r3, #30
	bpl	.L823
	ldr	r6, .L891+36
	mov	r10, #64
	ldr	r7, .L891+40
	movs	r3, #0
	strh	r3, [r7]	@ movhi
.L828:
	ldrh	r8, [r7]
	movs	r1, #5
	mov	r0, r8
	bl	zftl_get_gc_node
	add	r3, r8, #1
	strh	r3, [r7]	@ movhi
	movw	r3, #65535
	cmp	r0, r3
	beq	.L824
	ldr	r3, [sp, #12]
	cmp	r3, #1
	bne	.L825
	ldr	r3, .L891+44
	ldr	r2, .L891+48
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldrh	r2, [r2]
	smulbb	r3, r3, r2
	ldr	r2, .L891+28
	ldrh	r2, [r2]
	sub	r3, r3, r2, lsr #3
	strh	r3, [r6]	@ movhi
.L825:
	ldr	r3, .L891+24
	ldr	r3, [r3]
	ldrh	r2, [r3, r0, lsl #1]
	ldrh	r3, [r6]
	cmp	r2, r3
	bcs	.L826
	mov	r2, fp
	movs	r1, #0
	bl	gc_add_sblk
	cmp	r0, #0
	beq	.L827
	adds	r4, r4, #1
	ldr	r3, [sp, #12]
	uxth	r4, r4
	adds	r5, r5, #1
	uxth	r5, r5
	cmp	r4, r3
	bcc	.L827
.L824:
	ldr	r3, [sp, #12]
	ldr	r1, .L891+28
	ldr	r0, .L891+44
	cmp	r4, r3
	bcc	.L829
	cmp	r5, #0
	bne	.L830
	ldr	r3, .L891+52
	ldrh	r2, [r3]
	ldr	r3, .L891+56
	ldrh	r3, [r3]
	cmp	r2, r3
	bls	.L830
.L829:
	ldr	r3, .L891+48
	ldrh	r1, [r1]
	ldrh	r2, [r6]
	ldrh	r5, [r3]
	ldrb	r3, [r0]	@ zero_extendqisi2
	lsrs	r1, r1, #3
	muls	r3, r5, r3
	subs	r3, r3, r1
	cmp	r2, r3
	bge	.L823
	add	r2, r2, r1
	strh	r2, [r6]	@ movhi
.L823:
	ldr	r3, [sp, #20]
	cmp	r3, #0
	beq	.L809
	ldr	r5, .L891+60
	mov	r8, #64
	ldr	r7, .L891+24
	movs	r3, #0
	ldr	r6, .L891+32
	strh	r3, [r6]	@ movhi
.L834:
	ldrh	r10, [r6]
	movs	r1, #3
	mov	r0, r10
	add	r10, r10, #1
	bl	zftl_get_gc_node
	movw	r3, #65535
	strh	r10, [r6]	@ movhi
	cmp	r0, r3
	beq	.L831
	ldr	r3, [r7]
	ldrh	r2, [r5]
	ldrh	r3, [r3, r0, lsl #1]
	cmp	r2, r3
	bls	.L832
	cmp	r3, #2
	bls	.L832
	ldr	r3, .L891+12
	ldrh	r2, [r3]
	ldr	r3, .L891+8
	ldrh	r3, [r3]
	cmp	r3, r2, lsr #1
	bls	.L831
.L832:
	mov	r2, fp
	movs	r1, #0
	bl	gc_add_sblk
	cbz	r0, .L833
	adds	r4, r4, #1
	ldr	r3, [sp, #12]
	uxth	r4, r4
	cmp	r4, r3
	bcs	.L831
.L833:
	add	r8, r8, #-1
	uxth	r8, r8
	cmp	r8, #0
	bne	.L834
.L831:
	ldr	r3, [sp, #12]
	cmp	r4, r3
	ldr	r3, .L891+28
	bcs	.L835
	ldrh	r2, [r3]
	ldrh	r3, [r5]
	cmp	r3, r2, lsr #1
	bls	.L809
	sub	r3, r3, r2, lsr #3
	strh	r3, [r5]	@ movhi
	b	.L809
.L841:
	movs	r4, #0
	b	.L818
.L842:
	mov	r4, r1
	b	.L818
.L839:
	ldr	r4, [sp, #20]
	b	.L815
.L826:
	movs	r3, #0
	strh	r3, [r7]	@ movhi
	b	.L824
.L827:
	add	r10, r10, #-1
	uxth	r10, r10
	cmp	r10, #0
	bne	.L828
	b	.L824
.L830:
	ldrh	r1, [r1]
	ldrb	r2, [r0]	@ zero_extendqisi2
	ldrh	r3, [r6]
	muls	r2, r1, r2
	cmp	r3, r2
	itt	gt
	subgt	r3, r3, r1, lsr #3
	strhgt	r3, [r6]	@ movhi
	b	.L823
.L835:
	ldrh	r1, [r3]
	ldr	r3, .L891+44
	ldrh	r2, [r5]
	ldrb	r3, [r3]	@ zero_extendqisi2
	muls	r3, r1, r3
	subs	r3, r3, #32
	cmp	r2, r3
	itt	lt
	addlt	r2, r2, r1, lsr #3
	strhlt	r2, [r5]	@ movhi
	b	.L809
.L840:
	mov	r4, r5
	b	.L817
.L892:
	.align	2
.L891:
	.word	.LANCHOR63
	.word	.LANCHOR87
	.word	.LANCHOR88
	.word	.LANCHOR89
	.word	.LANCHOR90
	.word	.LANCHOR86
	.word	.LANCHOR9
	.word	.LANCHOR85
	.word	.LANCHOR82
	.word	.LANCHOR91
	.word	.LANCHOR83
	.word	.LANCHOR78
	.word	.LANCHOR77
	.word	.LANCHOR92
	.word	.LANCHOR93
	.word	.LANCHOR94
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
	ldr	r3, .L897
	mov	r1, r0
	ldr	r3, [r3]
	add	r3, r3, r0, lsl #2
	ldrb	r3, [r3, #2]	@ zero_extendqisi2
	ands	r3, r3, #24
	bne	.L894
	ldr	r2, .L897+4
	ldr	r0, .L897+8
.L896:
	b	_insert_free_list
.L894:
	cmp	r3, #16
	ittee	eq
	ldreq	r2, .L897+12
	ldreq	r0, .L897+16
	ldrne	r2, .L897+20
	ldrne	r0, .L897+24
	b	.L896
.L898:
	.align	2
.L897:
	.word	.LANCHOR7
	.word	.LANCHOR95
	.word	.LANCHOR96
	.word	.LANCHOR97
	.word	.LANCHOR98
	.word	.LANCHOR99
	.word	.LANCHOR100
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
	ldr	r3, .L904
	mov	r1, r0
	ldr	r3, [r3]
	add	r3, r3, r0, lsl #2
	ldrb	r3, [r3, #2]	@ zero_extendqisi2
	and	r3, r3, #224
	cmp	r3, #64
	bne	.L900
	ldr	r2, .L904+4
	ldr	r0, .L904+8
.L903:
	b	_insert_data_list
.L900:
	cmp	r3, #96
	bne	.L901
	ldr	r2, .L904+12
	ldr	r0, .L904+16
	b	.L903
.L901:
	cmp	r3, #160
	bne	.L899
	ldr	r2, .L904+20
	ldr	r0, .L904+24
	b	.L903
.L899:
	bx	lr
.L905:
	.align	2
.L904:
	.word	.LANCHOR7
	.word	.LANCHOR90
	.word	.LANCHOR12
	.word	.LANCHOR88
	.word	.LANCHOR81
	.word	.LANCHOR92
	.word	.LANCHOR80
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
	ldr	r8, .L923+48
	mov	r5, r0
	mov	r7, r1
	ldr	r3, [r8]
	ldrh	r4, [r3, #588]
	cmp	r4, r6
	beq	.L907
	cbnz	r0, .L907
	mov	r1, r4
	ldr	r0, .L923
	bl	printf
	ldr	r3, [r8]
	strh	r6, [r3, #588]	@ movhi
.L908:
	mov	r0, r4
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L907:
	ldr	r3, .L923+4
	ldr	r6, .L923+8
	ldrh	r1, [r3]
	ldrh	r3, [r6]
	cmp	r1, r3
	bls	.L909
	cmp	r5, #0
	beq	.L915
	lsrs	r1, r1, #3
.L910:
	ldr	r2, .L923+4
	ldr	r0, .L923+12
.L922:
	bl	_list_pop_index_node
	uxth	r4, r0
	movw	r3, #65535
	cmp	r4, r3
	bne	.L914
	ldrh	r3, [r6]
	mov	r2, r7
	mov	r1, r4
	ldr	r0, .L923+16
	str	r3, [sp, #4]
	ldr	r3, .L923+20
	ldrh	r3, [r3]
	str	r3, [sp]
	ldr	r3, .L923+24
	ldr	r3, [r3]
	bl	printf
.L914:
	cmp	r5, #0
	beq	.L908
	ldr	r3, .L923+28
	ldr	r3, [r3]
	lsls	r3, r3, #23
	bpl	.L908
	ldr	r3, .L923+32
	ldr	r1, .L923+36
	ldr	r0, .L923+40
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
	b	.L908
.L915:
	mov	r1, r5
	b	.L910
.L909:
	cbnz	r5, .L912
	lsrs	r1, r3, #2
.L913:
	ldr	r2, .L923+8
	ldr	r0, .L923+44
	b	.L922
.L912:
	rsb	r1, r1, r1, lsl #3
	ubfx	r1, r1, #3, #16
	b	.L913
.L924:
	.align	2
.L923:
	.word	.LC52
	.word	.LANCHOR97
	.word	.LANCHOR99
	.word	.LANCHOR98
	.word	.LC53
	.word	.LANCHOR95
	.word	.LANCHOR96
	.word	.LANCHOR14
	.word	.LANCHOR7
	.word	.LANCHOR9
	.word	.LC54
	.word	.LANCHOR100
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
	bne	.L926
	ldr	r3, .L947
	ldr	r2, .L947+4
	ldrh	r3, [r3]
	ldrh	r1, [r2]
	cmp	r3, r1
	bcc	.L927
	ldr	r2, .L947+8
	ldrh	r2, [r2]
	cmp	r2, r3
	bls	.L928
	cbz	r1, .L928
.L927:
	ldr	r2, .L947+4
	lsrs	r1, r1, #1
.L946:
	ldr	r0, .L947+12
	b	.L945
.L928:
	ldr	r2, .L947
	movs	r1, #0
	ldr	r0, .L947+16
.L945:
	bl	_list_pop_index_node
	uxth	r4, r0
	movw	r3, #65535
	cmp	r4, r3
	bne	.L931
	ldr	r3, .L947+4
	mov	r2, r5
	mov	r1, r4
	ldr	r0, .L947+20
	ldrh	r3, [r3]
	str	r3, [sp, #4]
	ldr	r3, .L947+8
	ldrh	r3, [r3]
	str	r3, [sp]
	ldr	r3, .L947+24
	ldr	r3, [r3]
	bl	printf
	b	.L931
.L926:
	ldr	r7, .L947+28
	movw	r6, #65535
	ldr	r3, [r7]
	ldrh	r4, [r3, #590]
	cmp	r4, r6
	beq	.L930
	cmp	r1, #1
	beq	.L930
	mov	r1, r4
	ldr	r0, .L947+32
	bl	printf
	ldr	r3, [r7]
	strh	r6, [r3, #590]	@ movhi
.L931:
	mov	r0, r4
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, pc}
.L930:
	ldr	r3, .L947+8
	ldr	r2, .L947+4
	ldrh	r3, [r3]
	ldrh	r2, [r2]
	cmp	r3, r2
	bcc	.L932
	ldr	r1, .L947
	ldrh	r1, [r1]
	cmp	r1, r3
	bls	.L933
	cbz	r2, .L933
.L932:
	cmp	r5, #1
	it	eq
	lsreq	r0, r2, #1
	ldr	r2, .L947+4
	mov	r1, r0
	b	.L946
.L933:
	cmp	r5, #1
	ldr	r2, .L947+8
	it	eq
	lsreq	r0, r3, #1
	mov	r1, r0
	ldr	r0, .L947+24
	b	.L945
.L948:
	.align	2
.L947:
	.word	.LANCHOR97
	.word	.LANCHOR99
	.word	.LANCHOR95
	.word	.LANCHOR100
	.word	.LANCHOR98
	.word	.LC53
	.word	.LANCHOR96
	.word	.LANCHOR10
	.word	.LC55
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
	ldr	r3, .L954
	mov	r1, r0
	ldr	r3, [r3]
	add	r3, r3, r0, lsl #2
	ldrb	r3, [r3, #2]	@ zero_extendqisi2
	and	r3, r3, #224
	cmp	r3, #64
	bne	.L950
	ldr	r2, .L954+4
	ldr	r0, .L954+8
.L953:
	b	_list_remove_node
.L950:
	cmp	r3, #96
	bne	.L951
	ldr	r2, .L954+12
	ldr	r0, .L954+16
	b	.L953
.L951:
	cmp	r3, #160
	bne	.L949
	ldr	r2, .L954+20
	ldr	r0, .L954+24
	b	.L953
.L949:
	bx	lr
.L955:
	.align	2
.L954:
	.word	.LANCHOR7
	.word	.LANCHOR90
	.word	.LANCHOR12
	.word	.LANCHOR88
	.word	.LANCHOR81
	.word	.LANCHOR92
	.word	.LANCHOR80
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
	ldr	r3, .L960
	mov	r1, r0
	ldr	r3, [r3]
	add	r3, r3, r0, lsl #2
	ldrb	r3, [r3, #2]	@ zero_extendqisi2
	ands	r3, r3, #24
	bne	.L957
	ldr	r2, .L960+4
	ldr	r0, .L960+8
.L959:
	b	_list_remove_node
.L957:
	cmp	r3, #16
	ittee	eq
	ldreq	r2, .L960+12
	ldreq	r0, .L960+16
	ldrne	r2, .L960+20
	ldrne	r0, .L960+24
	b	.L959
.L961:
	.align	2
.L960:
	.word	.LANCHOR7
	.word	.LANCHOR95
	.word	.LANCHOR96
	.word	.LANCHOR97
	.word	.LANCHOR98
	.word	.LANCHOR99
	.word	.LANCHOR100
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
	ldr	r3, .L967
	mov	r1, r0
	ldr	r3, [r3]
	add	r3, r3, r0, lsl #2
	ldrb	r3, [r3, #2]	@ zero_extendqisi2
	and	r3, r3, #224
	cmp	r3, #64
	bne	.L963
	ldr	r2, .L967+4
	ldr	r0, .L967+8
.L966:
	b	_list_update_data_list
.L963:
	cmp	r3, #96
	bne	.L964
	ldr	r2, .L967+12
	ldr	r0, .L967+16
	b	.L966
.L964:
	cmp	r3, #160
	bne	.L962
	ldr	r2, .L967+20
	ldr	r0, .L967+24
	b	.L966
.L962:
	bx	lr
.L968:
	.align	2
.L967:
	.word	.LANCHOR7
	.word	.LANCHOR90
	.word	.LANCHOR12
	.word	.LANCHOR88
	.word	.LANCHOR81
	.word	.LANCHOR92
	.word	.LANCHOR80
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
	ldr	r0, .L973
	bl	printf
	ldr	r4, [r4]
	cmp	r4, #0
	beq	.L969
	ldr	r6, .L973+4
	movs	r5, #0
	ldr	r7, .L973+8
.L972:
	ldr	r2, [r6]
	ldr	r0, .L973+12
	ldr	r3, .L973+16
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
	ldr	r0, .L973+20
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
	beq	.L969
	ldr	r3, [r6]
	movs	r2, #6
	adds	r5, r5, #1
	uxth	r5, r5
	mla	r4, r2, r4, r3
	ldr	r3, .L973+24
	ldrh	r3, [r3]
	cmp	r3, r5
	bcs	.L972
.L969:
	add	sp, sp, #36
	@ sp needed
	pop	{r4, r5, r6, r7, pc}
.L974:
	.align	2
.L973:
	.word	.LC56
	.word	.LANCHOR4
	.word	-1431655765
	.word	.LANCHOR9
	.word	.LANCHOR7
	.word	.LC57
	.word	.LANCHOR101
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
	ldr	r1, .L976
	ldr	r0, .L976+4
	bl	print_list_info
	ldr	r1, .L976+8
	ldr	r0, .L976+12
	bl	print_list_info
	ldr	r1, .L976+16
	ldr	r0, .L976+20
	bl	print_list_info
	ldr	r1, .L976+24
	ldr	r0, .L976+28
	bl	print_list_info
	ldr	r1, .L976+32
	ldr	r0, .L976+36
	bl	print_list_info
	ldr	r1, .L976+40
	ldr	r0, .L976+44
	pop	{r3, lr}
	b	print_list_info
.L977:
	.align	2
.L976:
	.word	.LANCHOR95
	.word	.LANCHOR96
	.word	.LANCHOR97
	.word	.LANCHOR98
	.word	.LANCHOR99
	.word	.LANCHOR100
	.word	.LANCHOR90
	.word	.LANCHOR12
	.word	.LANCHOR88
	.word	.LANCHOR81
	.word	.LANCHOR92
	.word	.LANCHOR80
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
	ldr	r3, .L983
	ldr	r3, [r3]
	ldr	r2, [r3, #16]
	cmp	r2, #2048
	bls	.L979
	ldr	r1, [r3, #20]
	add	r1, r1, r2, lsr #11
	ubfx	r2, r2, #0, #11
	str	r2, [r3, #16]
	str	r1, [r3, #20]
.L979:
	ldr	r2, [r3, #24]
	cmp	r2, #2048
	bls	.L980
	ldr	r1, [r3, #28]
	add	r1, r1, r2, lsr #11
	ubfx	r2, r2, #0, #11
	str	r2, [r3, #24]
	str	r1, [r3, #28]
.L980:
	ldr	r2, [r3, #32]
	cmp	r2, #1024
	bls	.L981
	ldr	r1, [r3, #36]
	add	r1, r1, r2, lsr #10
	ubfx	r2, r2, #0, #10
	str	r2, [r3, #32]
	str	r1, [r3, #36]
.L981:
	ldr	r2, [r3, #40]
	cmp	r2, #1024
	bls	.L978
	ldr	r1, [r3, #44]
	add	r1, r1, r2, lsr #10
	ubfx	r2, r2, #0, #10
	str	r2, [r3, #40]
	str	r1, [r3, #44]
.L978:
	bx	lr
.L984:
	.align	2
.L983:
	.word	.LANCHOR102
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
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r2, .L994
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r4, #0
	ldr	r3, .L994+4
	mov	r8, r1
	mov	r5, r4
	ldrb	fp, [r2]	@ zero_extendqisi2
	ldr	r2, .L994+8
	ldr	r3, [r3]
	ldrb	r10, [r2]	@ zero_extendqisi2
	ldr	r2, .L994+12
	add	r3, r3, r0, lsl #2
	uxth	r7, r10
	ldrb	r3, [r3, #3]	@ zero_extendqisi2
	smulbb	r0, r0, r7
	subs	r7, r7, #1
	sxth	r7, r7
	uxth	r6, r0
.L986:
	cmp	r5, fp
	blt	.L990
	mov	r3, r4
	movw	r2, #65535
.L991:
	cmp	r3, fp
	blt	.L992
	mov	r0, r4
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L990:
	asr	r1, r3, r5
	lsls	r1, r1, #31
	bmi	.L987
	mov	r1, r10
	mov	r0, r5
	str	r2, [sp, #4]
	str	r3, [sp]
	bl	__aeabi_idiv
	ldr	r2, [sp, #4]
	cmp	r10, #1
	ldr	r3, [sp]
	ldrh	r1, [r2]
	rsb	r1, r1, #21
	lsl	r0, r0, r1
	it	hi
	andhi	r1, r7, r5
	add	r0, r0, r6
	uxth	r0, r0
	it	hi
	addhi	r0, r0, r1
	strh	r0, [r8, r4, lsl #1]	@ movhi
	adds	r4, r4, #1
.L987:
	adds	r5, r5, #1
	b	.L986
.L992:
	strh	r2, [r8, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	b	.L991
.L995:
	.align	2
.L994:
	.word	.LANCHOR78
	.word	.LANCHOR7
	.word	.LANCHOR67
	.word	.LANCHOR66
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
	mov	r6, r1
	ldr	r3, .L1001
	ldr	r7, .L1001+4
	ldrh	r4, [r3]
	rsb	r3, r4, #21
	movs	r4, #1
	asr	r5, r0, r3
	lsls	r4, r4, r3
	ldr	r3, .L1001+8
	subs	r4, r4, #1
	uxtb	r5, r5
	ands	r4, r4, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	sxth	r4, r4
	cbz	r3, .L997
	ldr	r3, .L1001+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L997
	ldrh	r2, [r7]
	clz	r1, r1
	lsrs	r1, r1, #5
	mov	r0, r5
	muls	r2, r4, r2
	bl	flash_erase_block_en
.L997:
	ldrh	r2, [r7]
	uxtb	r1, r6
	mov	r0, r5
	muls	r2, r4, r2
	pop	{r3, r4, r5, r6, r7, lr}
	b	flash_erase_block_en
.L1002:
	.align	2
.L1001:
	.word	.LANCHOR66
	.word	.LANCHOR103
	.word	.LANCHOR72
	.word	.LANCHOR73
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
	ldr	r2, .L1027
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
.L1004:
	ldr	r3, .L1027+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r5, r3
	bge	.L1015
	ldr	r3, .L1027+8
	movs	r4, #0
	ldrb	r2, [r3]	@ zero_extendqisi2
	ldr	r3, .L1027+12
	add	ip, r2, #-1
	ldrh	r0, [r3]
	mul	r10, r2, r5
	mov	r3, r4
	mul	lr, r2, r6
	b	.L1016
.L1006:
	ldr	r1, [sp, #4]
	add	fp, r3, r10
	asr	r1, r1, fp
	lsls	r1, r1, #31
	bmi	.L1005
	add	r1, sp, #72
	add	fp, r1, r4, lsl #2
	and	r1, r3, ip
	add	r1, r1, lr
	muls	r1, r0, r1
	adds	r4, r4, #1
	str	r1, [fp, #-64]
.L1005:
	adds	r3, r3, #1
.L1016:
	cmp	r3, r2
	blt	.L1006
	cmp	r2, #4
	bne	.L1007
	uxtb	fp, r7
	mov	r10, #0
.L1008:
	cmp	r10, r4
	bne	.L1009
.L1010:
	adds	r5, r5, #1
	b	.L1004
.L1009:
	add	r3, sp, #8
	mov	r1, fp
	ldr	r2, [r3, r10, lsl #2]
	uxtb	r0, r5
	add	r10, r10, #1
	bl	flash_erase_block_en
	b	.L1008
.L1007:
	cmp	r4, #2
	bne	.L1011
	ldr	r3, .L1027+16
	uxtb	r4, r5
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1012
	ldr	r3, .L1027+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L1012
	clz	r1, r7
	ldr	r3, [sp, #12]
	ldr	r2, [sp, #8]
	lsrs	r1, r1, #5
	mov	r0, r4
	bl	flash_erase_duplane_block
.L1012:
	ldr	r3, [sp, #12]
	uxtb	r1, r7
	ldr	r2, [sp, #8]
	mov	r0, r4
	bl	flash_erase_duplane_block
	b	.L1010
.L1011:
	cmp	r4, #1
	bne	.L1010
	ldr	r3, .L1027+16
	uxtb	r4, r5
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1014
	ldr	r3, .L1027+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L1014
	clz	r1, r7
	ldr	r2, [sp, #8]
	lsrs	r1, r1, #5
	mov	r0, r4
	bl	flash_erase_block_en
.L1014:
	ldr	r2, [sp, #8]
	uxtb	r1, r7
	mov	r0, r4
	bl	flash_erase_block_en
	b	.L1010
.L1015:
	ldr	r1, .L1027+24
	ldr	r0, [r8]
	cbnz	r7, .L1017
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
	bge	.L1019
	strh	r3, [r2, #96]	@ movhi
.L1019:
	movs	r0, #0
	add	sp, sp, #72
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1017:
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
	b	.L1019
.L1028:
	.align	2
.L1027:
	.word	.LANCHOR7
	.word	.LANCHOR104
	.word	.LANCHOR67
	.word	.LANCHOR103
	.word	.LANCHOR72
	.word	.LANCHOR73
	.word	.LANCHOR102
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
	ldr	r4, .L1038
	ldr	r2, [r4]
	ldrh	r1, [r2, #136]
	cmp	r1, #63
	itt	hi
	movhi	r3, #0
	strhhi	r3, [r2, #136]	@ movhi
	ldrh	r3, [r2, #112]
	cbnz	r3, .L1031
	movw	r2, #1130
	ldr	r1, .L1038+4
	ldr	r0, .L1038+8
	bl	printf
.L1031:
	ldr	r3, [r4]
	movw	r4, #65535
	mov	r6, r4
	movs	r5, #0
.L1035:
	ldrh	r2, [r3, #136]
	add	r1, r3, r2, lsl #1
	adds	r1, r1, #158
.L1032:
	cmp	r2, #63
	ble	.L1034
	strh	r5, [r3, #136]	@ movhi
	b	.L1035
.L1034:
	ldrh	r0, [r1, #2]!
	cmp	r0, r4
	bne	.L1037
	adds	r2, r2, #1
	b	.L1032
.L1037:
	add	r1, r2, #80
	strh	r6, [r3, r1, lsl #1]	@ movhi
	strh	r2, [r3, #136]	@ movhi
	ldrh	r2, [r3, #112]
	subs	r2, r2, #1
	strh	r2, [r3, #112]	@ movhi
	pop	{r4, r5, r6, pc}
.L1039:
	.align	2
.L1038:
	.word	.LANCHOR102
	.word	.LANCHOR105
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
	ldr	r4, .L1048
	ldr	r2, [r4]
	ldrh	r1, [r2, #138]
	cmp	r1, #63
	itt	hi
	movhi	r3, #0
	strhhi	r3, [r2, #138]	@ movhi
	ldrh	r3, [r2, #112]
	cmp	r3, #63
	bls	.L1042
	movw	r2, #1154
	ldr	r1, .L1048+4
	ldr	r0, .L1048+8
	bl	printf
.L1042:
	ldr	r3, [r4]
	movs	r0, #0
	movw	r4, #65535
.L1046:
	ldrh	r2, [r3, #138]
	add	r1, r3, r2, lsl #1
	adds	r1, r1, #158
.L1043:
	cmp	r2, #63
	ble	.L1045
	strh	r0, [r3, #138]	@ movhi
	b	.L1046
.L1045:
	ldrh	r6, [r1, #2]!
	cmp	r6, r4
	bne	.L1044
	add	r1, r2, #80
	strh	r5, [r3, r1, lsl #1]	@ movhi
	strh	r2, [r3, #138]	@ movhi
	ldrh	r2, [r3, #112]
	adds	r2, r2, #1
	strh	r2, [r3, #112]	@ movhi
	pop	{r4, r5, r6, pc}
.L1044:
	adds	r2, r2, #1
	b	.L1043
.L1049:
	.align	2
.L1048:
	.word	.LANCHOR102
	.word	.LANCHOR106
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
	beq	.L1050
	ldr	r3, .L1059
	ldr	r5, [r3]
	add	r6, r5, r4, lsl #2
	ldrb	r3, [r6, #2]	@ zero_extendqisi2
	tst	r3, #224
	bne	.L1050
	ldrb	r2, [r0, #4]	@ zero_extendqisi2
	mov	r0, r4
	bfi	r3, r2, #5, #3
	strb	r3, [r6, #2]
	bl	zftl_remove_free_node
	ldrb	r3, [r6, #2]	@ zero_extendqisi2
	ldr	r2, .L1059+4
	tst	r3, #8
	ldr	r0, [r2]
	beq	.L1054
	ldrh	r1, [r0, #116]
	subs	r1, r1, #1
	strh	r1, [r0, #116]	@ movhi
.L1055:
	and	r3, r3, #224
	cmp	r3, #160
	bne	.L1057
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
.L1054:
	tst	r3, #24
	itete	eq
	ldrheq	r1, [r0, #114]
	ldrhne	r1, [r0, #118]
	addeq	r1, r1, #-1
	addne	r1, r1, #-1
	ite	eq
	strheq	r1, [r0, #114]	@ movhi
	strhne	r1, [r0, #118]	@ movhi
	b	.L1055
.L1057:
	ldrh	r1, [r5, r4, lsl #2]
	cmp	r3, #64
	add	r0, r1, #1
	bfi	r1, r0, #0, #11
	strh	r1, [r5, r4, lsl #2]	@ movhi
	bne	.L1058
	ldr	r2, [r2]
	ldrh	r3, [r2, #122]
	subs	r3, r3, #1
	strh	r3, [r2, #122]	@ movhi
	pop	{r4, r5, r6, pc}
.L1058:
	cmp	r3, #96
	itttt	eq
	ldreq	r2, [r2]
	ldrheq	r3, [r2, #124]
	addeq	r3, r3, #-1
	strheq	r3, [r2, #124]	@ movhi
.L1050:
	pop	{r4, r5, r6, pc}
.L1060:
	.align	2
.L1059:
	.word	.LANCHOR7
	.word	.LANCHOR102
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
	ldr	r3, .L1065
	ldr	r5, [r3]
	ldr	r3, .L1065+4
	ldrh	r2, [r3]
	ldr	r3, .L1065+8
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
	bne	.L1064
	movw	r2, #1593
	ldr	r1, .L1065+12
	ldr	r0, .L1065+16
	bl	printf
.L1064:
	ldr	r3, .L1065+20
	ldrh	r0, [r3]
	mla	r0, r4, r0, r7
	pop	{r3, r4, r5, r6, r7, pc}
.L1066:
	.align	2
.L1065:
	.word	.LANCHOR10
	.word	.LANCHOR85
	.word	.LANCHOR78
	.word	.LANCHOR107
	.word	.LC0
	.word	.LANCHOR103
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
	ldr	r3, .L1071
	uxtb	r2, r0
	push	{r4, r5}
	ldrh	r3, [r3, r2, lsl #1]
	ldr	r2, .L1071+4
	ldr	r1, [r2]
	ldr	r2, .L1071+8
	ldr	r4, [r2]
	movw	r2, #65535
.L1068:
	cmp	r3, r2
	bne	.L1070
	mov	r0, #-1
	pop	{r4, r5}
	bx	lr
.L1070:
	ldr	r5, [r1, r3, lsl #2]
	cmp	r0, r5
	bne	.L1069
	mov	r0, r3
	pop	{r4, r5}
	b	ftl_get_ppa_from_index
.L1069:
	ldrh	r3, [r4, r3, lsl #1]
	b	.L1068
.L1072:
	.align	2
.L1071:
	.word	.LANCHOR108
	.word	.LANCHOR109
	.word	.LANCHOR110
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
	bne	.L1074
	movw	r2, #1716
	ldr	r1, .L1081
	ldr	r0, .L1081+4
	bl	printf
.L1074:
	ldr	r3, .L1081+8
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3]
	cmp	r2, r3
	bne	.L1075
	movw	r2, #1717
	ldr	r1, .L1081
	ldr	r0, .L1081+4
	bl	printf
.L1075:
	ldrh	r3, [r4, #6]
	cbnz	r3, .L1076
	movw	r2, #1718
	ldr	r1, .L1081
	ldr	r0, .L1081+4
	bl	printf
.L1076:
	ldrb	r3, [r4, #5]	@ zero_extendqisi2
	movw	r2, #65535
	movs	r1, #0
	adds	r3, r3, #8
	ldrh	r0, [r4, r3, lsl #1]
	ldr	r3, .L1081+12
	ldrb	r5, [r3]	@ zero_extendqisi2
.L1077:
	cmp	r0, r2
	ldrb	r3, [r4, #5]	@ zero_extendqisi2
	beq	.L1079
	ldr	r1, .L1081+16
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
.L1079:
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
	b	.L1077
.L1082:
	.align	2
.L1081:
	.word	.LANCHOR111
	.word	.LC0
	.word	.LANCHOR85
	.word	.LANCHOR78
	.word	.LANCHOR103
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
	bls	.L1084
	movw	r2, #1749
	ldr	r1, .L1085
	ldr	r0, .L1085+4
	bl	printf
.L1084:
	ldr	r5, .L1085+8
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
.L1086:
	.align	2
.L1085:
	.word	.LANCHOR112
	.word	.LC0
	.word	.LANCHOR102
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
	ldr	r2, .L1098
	push	{r3, r4, r5, r6, r7, lr}
	mov	r1, r2
	ldrh	r3, [r2]
	cmp	r3, #4
	bhi	.L1088
	cbnz	r0, .L1088
	adds	r3, r3, #1
	strh	r3, [r2]	@ movhi
	pop	{r3, r4, r5, r6, r7, pc}
.L1088:
	ldr	r2, .L1098+4
	movs	r3, #0
	mov	r0, r3
	movw	ip, #65535
	strh	r3, [r1]	@ movhi
	ldrh	r5, [r2]
	ldr	r2, .L1098+8
	ldr	r6, [r2]
	ldr	r2, .L1098+12
	ldr	r7, [r2]
	mov	r2, r3
.L1090:
	uxth	r1, r3
	cmp	r5, r1
	bhi	.L1093
	ldr	r3, .L1098+16
	ldr	r4, [r3]
	ldr	r3, .L1098+20
	str	r2, [r4, #524]
	ldr	r3, [r3]
	str	r0, [r4, #528]
	ldrh	r1, [r3, #120]
	cbz	r1, .L1087
	bl	__aeabi_uidiv
	str	r0, [r4, #532]
.L1087:
	pop	{r3, r4, r5, r6, r7, pc}
.L1093:
	ldrh	r1, [r6, r3, lsl #1]
	cmp	r1, ip
	beq	.L1091
	add	r4, r7, r3, lsl #2
	ldrb	r4, [r4, #2]	@ zero_extendqisi2
	and	r4, r4, #224
	cmp	r4, #160
	ite	eq
	addeq	r0, r0, r1
	addne	r2, r2, r1
.L1091:
	adds	r3, r3, #1
	b	.L1090
.L1099:
	.align	2
.L1098:
	.word	.LANCHOR113
	.word	.LANCHOR6
	.word	.LANCHOR9
	.word	.LANCHOR7
	.word	.LANCHOR10
	.word	.LANCHOR102
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
	ldr	r3, .L1104
	ldr	r3, [r3]
	ldrh	r3, [r3, r4, lsl #1]
	cbnz	r3, .L1103
	ldr	r3, .L1104+4
	movs	r0, #1
	str	r0, [r3]
	pop	{r4, pc}
.L1103:
	movs	r0, #0
	pop	{r4, pc}
.L1105:
	.align	2
.L1104:
	.word	.LANCHOR9
	.word	.LANCHOR114
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
	beq	.L1107
	ldr	r3, .L1115
	ldr	r3, [r3]
	ldrh	r4, [r3, r0, lsl #1]
	cbnz	r4, .L1108
	ldr	r3, .L1115+4
	mov	r1, r0
	mov	r2, r4
	ldr	r3, [r3]
	add	r3, r3, r0, lsl #2
	ldr	r0, .L1115+8
	ldrb	r3, [r3, #2]	@ zero_extendqisi2
	lsrs	r3, r3, #5
	bl	printf
.L1113:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L1108:
	subs	r4, r4, #1
	strh	r4, [r3, r0, lsl #1]	@ movhi
.L1107:
	ldr	r3, .L1115+12
	ldrh	r0, [r3]
	mov	r4, r3
	cmp	r5, r0
	beq	.L1113
	movw	r2, #65535
	cmp	r0, r2
	bne	.L1110
	strh	r5, [r3]	@ movhi
	b	.L1113
.L1110:
	bl	ftl_vpn_update
	ldr	r3, .L1115+16
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
	ldr	r3, .L1115+20
	strh	r1, [r3, r2, lsl #1]	@ movhi
	pop	{r3, r4, r5, pc}
.L1116:
	.align	2
.L1115:
	.word	.LANCHOR9
	.word	.LANCHOR7
	.word	.LC58
	.word	.LANCHOR64
	.word	.LANCHOR115
	.word	.LANCHOR65
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
	ldr	r4, .L1128
	movw	r6, #65535
	mov	fp, r6
	ldr	r5, .L1128+4
	ldr	lr, [r4]
	ldr	r4, .L1128+8
	ldrh	r3, [r5, ip, lsl #1]
	ldr	r4, [r4]
.L1118:
	cmp	r3, fp
	beq	.L1122
	ldr	r7, [lr, r3, lsl #2]
	add	r8, lr, r3, lsl #2
	cmp	r0, r7
	bne	.L1119
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
.L1122:
	ldrh	r3, [r5, ip, lsl #1]
	str	r0, [lr, r2, lsl #2]
	strh	r2, [r5, ip, lsl #1]	@ movhi
	strh	r3, [r4, r2, lsl #1]	@ movhi
	adds	r3, r1, #1
	beq	.L1124
	ldr	r3, .L1128+12
	ldrh	r0, [r3]
	movs	r3, #1
	rsb	r2, r0, #21
	lsls	r3, r3, r2
	ldr	r2, .L1128+16
	lsr	r0, r1, r0
	subs	r3, r3, #1
	ldrb	r1, [r2]	@ zero_extendqisi2
	ands	r0, r0, r3
	bl	__aeabi_uidiv
	uxth	r0, r0
	bl	ftl_vpn_decrement
.L1124:
	mov	r0, #-1
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1119:
	mov	r6, r3
	ldrh	r3, [r4, r3, lsl #1]
	b	.L1118
.L1129:
	.align	2
.L1128:
	.word	.LANCHOR109
	.word	.LANCHOR108
	.word	.LANCHOR110
	.word	.LANCHOR66
	.word	.LANCHOR67
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
	ldr	r3, .L1137
	push	{r0, r1, r2, r4, r5, r6, r7, r8, r10, lr}
	ubfx	r6, r0, #21, #3
	ldrb	r4, [r3]	@ zero_extendqisi2
	ldr	r3, .L1137+4
	mov	r1, r4
	smulbb	r2, r6, r4
	uxtb	r8, r2
	ldrh	r2, [r3]
	lsr	r3, r0, r2
	rsb	r2, r2, #21
	movs	r0, #1
	lsls	r0, r0, r2
	subs	r0, r0, #1
	ands	r0, r0, r3
	uxth	r10, r0
	bl	__aeabi_uidiv
	ldr	r3, .L1137+8
	cmp	r4, #1
	it	hi
	addhi	r2, r4, #-1
	mov	r5, r0
	it	hi
	andhi	r2, r2, r10
	uxth	r7, r0
	ldr	r3, [r3]
	itt	hi
	addhi	r2, r2, r8
	uxtbhi	r8, r2
	lsls	r3, r3, #17
	bpl	.L1132
	uxth	r3, r0
	str	r10, [sp]
	mov	r2, r8
	ldr	r0, .L1137+12
	mov	r1, r6
	bl	printf
.L1132:
	ldr	r3, .L1137+16
	ldrh	r3, [r3]
	cmp	r3, r7
	bls	.L1130
	ldr	r3, .L1137+20
	uxth	r5, r5
	movs	r2, #1
	lsl	r8, r2, r8
	ldr	r3, [r3]
	add	r5, r3, r5, lsl #2
	ldrb	r2, [r5, #3]	@ zero_extendqisi2
	orr	r2, r2, r8
	strb	r2, [r5, #3]
.L1130:
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L1138:
	.align	2
.L1137:
	.word	.LANCHOR67
	.word	.LANCHOR66
	.word	.LANCHOR14
	.word	.LC59
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
	ldr	r4, .L1153
	ldr	r3, [r4, #324]
	cbz	r3, .L1151
	ldr	r7, .L1153+4
	mov	r10, #0
.L1141:
	ldr	r3, .L1153+8
	ldrb	r2, [r3]	@ zero_extendqisi2
	uxth	r3, r10
	cmp	r2, r3
	bhi	.L1148
.L1151:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1148:
	ldr	r3, .L1153+12
	uxth	r0, r10
	ldrb	fp, [r3]	@ zero_extendqisi2
	mov	r1, fp
	bl	__aeabi_idiv
	ldrh	r5, [r7]
	uxth	r6, fp
	cmp	fp, #1
	ldr	r2, .L1153+16
	mov	fp, #0
	rsb	r5, r5, #21
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
.L1143:
	ldr	r1, [r4, #324]
	uxth	r6, fp
	mov	r3, r6
	cmp	r1, r6
	bhi	.L1147
	add	r10, r10, #1
	b	.L1141
.L1147:
	adds	r3, r3, #164
	ldrh	r3, [r4, r3, lsl #1]
	cmp	r3, r5
	bne	.L1144
	mov	r0, r2
	mov	r1, r5
	str	r2, [sp, #4]
	bl	printf
	ldrh	r0, [r7]
	lsl	r0, r5, r0
	bl	ftl_mask_bad_block
	ldr	r3, [r4, #324]
	ldr	r2, [sp, #4]
.L1145:
	cmp	r6, r3
	bcc	.L1146
	subs	r3, r3, #1
	str	r3, [r4, #324]
.L1144:
	add	fp, fp, #1
	b	.L1143
.L1146:
	add	r1, r6, #165
	ldrh	r0, [r4, r1, lsl #1]
	add	r1, r6, #164
	adds	r6, r6, #1
	uxth	r6, r6
	strh	r0, [r4, r1, lsl #1]	@ movhi
	b	.L1145
.L1154:
	.align	2
.L1153:
	.word	.LANCHOR63
	.word	.LANCHOR66
	.word	.LANCHOR78
	.word	.LANCHOR67
	.word	.LC60
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
	mov	r6, r0
	ldr	r3, .L1175
	ldr	r10, [r3]
	lsls	r3, r0, #2
	add	r7, r10, r3
	ldrb	r4, [r7, #2]	@ zero_extendqisi2
	lsls	r2, r4, #28
	lsr	r3, r4, #5
	str	r3, [sp, #4]
	bpl	.L1157
	ldr	r2, .L1175+4
	ldrh	r3, [r10, r0, lsl #2]
	ldr	r5, [r10, r0, lsl #2]
	ldr	r2, [r2]
	ubfx	r3, r3, #0, #11
	str	r3, [sp, #12]
	ubfx	r5, r5, #11, #8
	ldrh	fp, [r2, #74]
	ldrh	r8, [r2, #72]
	ldr	r2, .L1175+8
	add	fp, fp, r3
	uxth	fp, fp
	add	r8, r8, r5
	ldrh	r2, [r2]
	uxth	r8, r8
	mov	r0, fp
	mov	r1, r2
	str	r2, [sp, #8]
	bl	__aeabi_uidiv
	ldr	r1, .L1175+12
	uxtah	r0, r8, r0
	ldr	r2, [sp, #8]
	ldr	r3, [sp, #12]
	ldrh	r1, [r1]
	cmp	r0, r1
	ble	.L1158
	ldr	r1, .L1175+16
	ldr	ip, .L1175+52
	ldrh	r0, [r1]
	ldr	r1, .L1175+20
	ldrh	ip, [ip]
	adds	r0, r0, #7
	ldrh	r1, [r1]
	add	r1, r1, ip
	cmp	r0, r1
	blt	.L1159
.L1174:
	movs	r1, #2
	bfi	r4, r1, #3, #2
.L1172:
	strb	r4, [r7, #2]
.L1160:
	ldrb	r1, [r7, #2]	@ zero_extendqisi2
	ands	r1, r1, #24
	bne	.L1164
	muls	r5, r2, r5
	ldrh	r2, [r10, r6, lsl #2]
	add	r5, r5, r5, lsl #1
	add	r3, r3, r5, asr #2
	ubfx	r3, r3, #2, #9
	bfi	r2, r3, #0, #11
	strh	r2, [r10, r6, lsl #2]	@ movhi
.L1157:
	mov	r0, r6
	bl	zftl_remove_data_node
	ldr	r3, .L1175
	lsls	r2, r6, #2
	ldr	r3, [r3]
	add	r3, r3, r2
	ldrb	r2, [r3, #2]	@ zero_extendqisi2
	bfc	r2, #5, #3
	strb	r2, [r3, #2]
	movs	r2, #0
	ldr	r3, .L1175+24
	ldr	r3, [r3]
	strh	r2, [r3, r6, lsl #1]	@ movhi
	ldr	r3, [sp, #4]
	adds	r3, r3, #6
	and	r3, r3, #7
	cmp	r3, #4
	bhi	.L1166
	mov	r0, r6
	bl	gc_free_bad_sblk
.L1166:
	ldrb	r3, [r7, #2]	@ zero_extendqisi2
	lsls	r3, r3, #28
	bpl	.L1167
	ldr	r3, .L1175+28
	ldr	r3, [r3]
	ldrh	r2, [r3, #584]
	cmp	r2, r6
	bne	.L1168
	ldrh	r1, [r3, #588]
	movw	r2, #65535
	strh	r2, [r3, #584]	@ movhi
	cmp	r1, r2
	bne	.L1167
	ldr	r0, .L1175+32
	mov	r1, r6
	strh	r6, [r3, #588]	@ movhi
.L1173:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	printf
.L1159:
	ldr	r1, .L1175+36
	ldr	ip, .L1175+56
	ldrh	r0, [r1]
	ldr	r1, .L1175+40
	ldrh	ip, [ip]
	adds	r0, r0, #7
	ldrh	r1, [r1]
	add	r1, r1, ip
	ldr	ip, .L1175+60
	ldrh	ip, [ip]
	add	r1, r1, ip
	cmp	r0, r1
	blt	.L1174
.L1163:
	bfc	r4, #3, #2
	b	.L1172
.L1158:
	ldr	r1, .L1175+44
	mla	r8, r8, r2, fp
	ldrh	r1, [r1]
	cmp	r8, r1
	ble	.L1160
	ldr	r1, .L1175+36
	ldr	ip, .L1175+56
	ldrh	r0, [r1]
	ldr	r1, .L1175+40
	ldrh	ip, [ip]
	adds	r0, r0, #7
	ldrh	r1, [r1]
	add	r1, r1, ip
	ldr	ip, .L1175+60
	ldrh	ip, [ip]
	add	r1, r1, ip
	cmp	r0, r1
	bge	.L1163
	ldr	r1, .L1175+16
	ldr	ip, .L1175+52
	ldrh	r0, [r1]
	ldr	r1, .L1175+20
	ldrh	ip, [ip]
	adds	r0, r0, #7
	ldrh	r1, [r1]
	add	r1, r1, ip
	cmp	r0, r1
	blt	.L1163
	b	.L1174
.L1164:
	cmp	r1, #16
	bne	.L1157
	mov	r0, r3
	mov	r1, r2
	bl	__aeabi_idiv
	add	r0, r0, r0, lsl #1
	ldr	r3, [r10, r6, lsl #2]
	add	r5, r5, r0, asr #2
	ubfx	r5, r5, #2, #6
	bfi	r3, r5, #11, #8
	str	r3, [r10, r6, lsl #2]
	b	.L1157
.L1168:
	ldrh	r2, [r3, #586]
	cmp	r2, r6
	bne	.L1167
	ldrh	r1, [r3, #590]
	movw	r2, #65535
	strh	r2, [r3, #586]	@ movhi
	cmp	r1, r2
	bne	.L1167
	strh	r6, [r3, #590]	@ movhi
	mov	r1, r6
	ldr	r0, .L1175+48
	b	.L1173
.L1167:
	mov	r0, r6
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	zftl_insert_free_list
.L1176:
	.align	2
.L1175:
	.word	.LANCHOR7
	.word	.LANCHOR102
	.word	.LANCHOR8
	.word	.LANCHOR116
	.word	.LANCHOR93
	.word	.LANCHOR92
	.word	.LANCHOR9
	.word	.LANCHOR10
	.word	.LC61
	.word	.LANCHOR117
	.word	.LANCHOR90
	.word	.LANCHOR118
	.word	.LC62
	.word	.LANCHOR97
	.word	.LANCHOR95
	.word	.LANCHOR88
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
	ldr	r6, .L1214
.L1178:
	uxth	r2, r5
	ldr	r3, .L1214+4
	ldrh	r1, [r3, #52]
	cmp	r1, r2
	bhi	.L1192
	movs	r2, #0
	strh	r2, [r3, #52]	@ movhi
	pop	{r3, r4, r5, r6, r7, pc}
.L1192:
	uxth	r2, r5
	add	r3, r3, r2, lsl #1
	ldrh	r4, [r3, #54]
	ldr	r3, [r6]
	ldrh	r2, [r3, r4, lsl #1]
	cbz	r2, .L1179
	mov	r1, r4
	ldr	r0, .L1214+8
	bl	printf
.L1179:
	ldr	r3, [r6]
	movs	r2, #0
	strh	r2, [r3, r4, lsl #1]	@ movhi
	ldr	r3, .L1214+12
	ldr	r7, [r3]
	ldr	r3, .L1214+16
	ldr	r3, [r3]
	add	r7, r7, r4, lsl #2
	lsls	r3, r3, #23
	bpl	.L1180
	ldrb	r2, [r7, #2]	@ zero_extendqisi2
	mov	r1, r4
	ldr	r0, .L1214+20
	lsrs	r2, r2, #5
	bl	printf
.L1180:
	ldrb	r3, [r7, #2]	@ zero_extendqisi2
	and	r2, r3, #224
	cmp	r2, #224
	beq	.L1181
	tst	r3, #192
	bne	.L1182
.L1181:
	mov	r2, #932
	ldr	r1, .L1214+24
	ldr	r0, .L1214+28
	bl	printf
.L1182:
	mov	r0, r4
	bl	ftl_free_sblk
	ldr	r3, .L1214+32
	ldr	r3, [r3]
	ldrh	r1, [r3, #124]
	cbz	r1, .L1183
	add	r0, r3, #392
	movs	r2, #0
.L1185:
	ldrh	r7, [r0], #2
	cmp	r4, r7
	bne	.L1184
	adds	r2, r2, #196
	movw	r0, #65535
	subs	r1, r1, #1
	strh	r0, [r3, r2, lsl #1]	@ movhi
	strh	r1, [r3, #124]	@ movhi
.L1183:
	ldrh	r1, [r3, #120]
	cbz	r1, .L1186
	add	r0, r3, #136
	movs	r2, #0
.L1188:
	ldrh	r7, [r0], #2
	cmp	r4, r7
	bne	.L1187
	adds	r2, r2, #68
	movw	r0, #65535
	subs	r1, r1, #1
	strh	r0, [r3, r2, lsl #1]	@ movhi
	strh	r1, [r3, #120]	@ movhi
.L1186:
	ldrh	r1, [r3, #122]
	cbz	r1, .L1189
	add	r0, r3, #264
	movs	r2, #0
.L1191:
	ldrh	r7, [r0], #2
	cmp	r4, r7
	bne	.L1190
	adds	r2, r2, #132
	movw	r0, #65535
	subs	r1, r1, #1
	strh	r0, [r3, r2, lsl #1]	@ movhi
	strh	r1, [r3, #122]	@ movhi
.L1189:
	adds	r5, r5, #1
	b	.L1178
.L1184:
	adds	r2, r2, #1
	cmp	r2, #64
	bne	.L1185
	b	.L1183
.L1187:
	adds	r2, r2, #1
	cmp	r2, #64
	bne	.L1188
	b	.L1186
.L1190:
	adds	r2, r2, #1
	cmp	r2, #64
	bne	.L1191
	b	.L1189
.L1215:
	.align	2
.L1214:
	.word	.LANCHOR9
	.word	.LANCHOR63
	.word	.LC63
	.word	.LANCHOR7
	.word	.LANCHOR14
	.word	.LC64
	.word	.LANCHOR119
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
	ldr	r4, .L1217
	ldr	r5, .L1217+4
	ldr	r6, .L1217+8
	ldr	r1, [r4]
	ldr	r0, [r5]
	ldr	r6, [r6]
	ldr	r3, .L1217+12
	ldrh	r2, [r1, #146]
	ldrh	r1, [r1, #148]
	ldrh	r3, [r3]
	str	r6, [sp, #28]
	ldr	r6, [r0, #528]
	str	r6, [sp, #24]
	ldr	r0, [r0, #524]
	str	r0, [sp, #20]
	ldr	r0, .L1217+16
	ldrh	r0, [r0]
	str	r0, [sp, #16]
	ldr	r0, .L1217+20
	ldrh	r0, [r0]
	str	r0, [sp, #12]
	ldr	r0, .L1217+24
	ldrh	r0, [r0]
	str	r0, [sp, #8]
	ldr	r0, .L1217+28
	ldrh	r0, [r0]
	str	r0, [sp, #4]
	ldr	r0, .L1217+32
	ldrh	r0, [r0]
	str	r0, [sp]
	ldr	r0, .L1217+36
	bl	printf
	ldr	r1, [r4]
	ldr	r3, .L1217+40
	ldr	r0, .L1217+44
	ldr	r2, [r1, #64]
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r2, [sp, #4]
	ldr	r2, [r1, #8]
	str	r2, [sp]
	ldr	r2, [r1, #28]
	ldr	r1, [r1, #20]
	bl	printf
	ldr	r1, [r4]
	ldr	r0, .L1217+48
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
	ldr	r0, .L1217+52
	ldr	r2, [r2, #84]
	bl	printf
	ldr	r0, .L1217+56
	ldr	r3, .L1217+60
	ldr	r2, .L1217+64
	ldrh	r0, [r0]
	ldr	r1, .L1217+68
	ldrh	r3, [r3]
	ldrh	r2, [r2]
	ldrh	r1, [r1]
	str	r0, [sp, #4]
	ldr	r0, .L1217+72
	ldrh	r0, [r0]
	str	r0, [sp]
	ldr	r0, .L1217+76
	bl	printf
	ldr	r0, [r5]
	ldrh	r3, [r0, #588]
	ldrh	r2, [r0, #586]
	ldrh	r1, [r0, #584]
	ldrh	r0, [r0, #590]
	str	r0, [sp]
	ldr	r0, .L1217+80
	bl	printf
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, pc}
.L1218:
	.align	2
.L1217:
	.word	.LANCHOR102
	.word	.LANCHOR10
	.word	.LANCHOR120
	.word	.LANCHOR95
	.word	.LANCHOR92
	.word	.LANCHOR88
	.word	.LANCHOR90
	.word	.LANCHOR99
	.word	.LANCHOR97
	.word	.LC65
	.word	.LANCHOR121
	.word	.LC66
	.word	.LC67
	.word	.LC68
	.word	.LANCHOR79
	.word	.LANCHOR62
	.word	.LANCHOR94
	.word	.LANCHOR91
	.word	.LANCHOR84
	.word	.LC69
	.word	.LC70
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
	cbnz	r0, .L1220
	mov	r2, #668
	ldr	r1, .L1229
	ldr	r0, .L1229+4
	bl	printf
	bl	print_ftl_debug_info
	mov	r0, #-1
	pop	{r4, r5, r6, pc}
.L1223:
	mov	r1, r4
	ldr	r0, .L1229+8
	bl	buf_add_tail
	ldr	r3, .L1229+12
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
.L1220:
	ldr	r5, .L1229+16
	ldrb	r1, [r0, #40]	@ zero_extendqisi2
	ldrb	r2, [r5]	@ zero_extendqisi2
	cmp	r1, r2
	bls	.L1225
	movw	r2, #673
	ldr	r1, .L1229
	ldr	r0, .L1229+4
	bl	printf
.L1225:
	ldrb	r3, [r4, #40]	@ zero_extendqisi2
	ldr	r6, .L1229+20
	cbz	r3, .L1222
	ldrb	r2, [r5]	@ zero_extendqisi2
	cmp	r2, r3
	bcs	.L1223
.L1222:
	mov	r0, r4
	bl	buf_free
	ldrb	r0, [r6]	@ zero_extendqisi2
	pop	{r4, r5, r6, pc}
.L1230:
	.align	2
.L1229:
	.word	.LANCHOR122
	.word	.LC0
	.word	.LANCHOR57
	.word	.LANCHOR102
	.word	.LANCHOR123
	.word	.LANCHOR58
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
	ldr	r7, .L1241
.L1232:
	ldr	r2, .L1241+4
	ldrb	r5, [r2]	@ zero_extendqisi2
	cmp	r5, #255
	bne	.L1240
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L1240:
	movs	r3, #48
	add	r6, r5, r5, lsl #1
	muls	r3, r5, r3
	add	r6, r7, r6, lsl #4
	adds	r4, r7, r3
	ldrb	r3, [r7, r3]	@ zero_extendqisi2
	strb	r3, [r2]
	ldr	r3, [r4, #36]
	adds	r3, r3, #1
	bne	.L1233
	ldr	r3, .L1241+8
	movs	r2, #1
	ldr	r10, [r4, #24]
	ldr	r8, .L1241+24
	ldrh	r0, [r3]
	rsb	r3, r0, #21
	lsls	r2, r2, r3
	ldr	r3, .L1241+12
	lsr	r0, r10, r0
	subs	r2, r2, #1
	ldrb	r1, [r3]	@ zero_extendqisi2
	ands	r0, r0, r2
	bl	__aeabi_uidiv
	ldr	r2, [r8]
	movw	r1, #65535
	uxth	r4, r0
	ldr	r0, .L1241+16
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
	bne	.L1235
	movs	r2, #0
	strh	r2, [r3, #22]	@ movhi
.L1236:
	mov	r0, r6
	mov	r8, #1
	bl	ftl_write_buf
	b	.L1232
.L1235:
	ldrh	r2, [r3, #48]
	cmp	r2, r4
	itt	eq
	moveq	r2, #0
	strheq	r2, [r3, #54]	@ movhi
	b	.L1236
.L1233:
	cmp	r8, #0
	beq	.L1238
	ldr	r2, [r4, #24]
	ldr	r1, [r4, #20]
	ldr	r0, .L1241+20
	bl	printf
	mov	r0, r6
	bl	ftl_write_buf
	b	.L1232
.L1238:
	ldrh	r2, [r4, #32]
	ldr	r1, [r4, #28]
	ldr	r0, [r4, #20]
	bl	lpa_hash_update_ppa
	ldrb	r3, [r4, #2]	@ zero_extendqisi2
	lsls	r2, r3, #29
	bpl	.L1239
	bic	r3, r3, #2
	strb	r3, [r4, #2]
	b	.L1232
.L1239:
	mov	r0, r6
	bl	buf_free
	b	.L1232
.L1242:
	.align	2
.L1241:
	.word	.LANCHOR50
	.word	.LANCHOR124
	.word	.LANCHOR66
	.word	.LANCHOR67
	.word	.LC71
	.word	.LC72
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
	cbnz	r0, .L1244
	mov	r2, #964
	ldr	r1, .L1248
	ldr	r0, .L1248+4
	bl	printf
	pop	{r4, lr}
	b	print_ftl_debug_info
.L1244:
	ldr	r3, .L1248+8
	ldrb	r2, [r0, #40]	@ zero_extendqisi2
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r2, r3
	bls	.L1246
	movw	r2, #969
	ldr	r1, .L1248
	ldr	r0, .L1248+4
	bl	printf
.L1246:
	mov	r1, r4
	ldr	r0, .L1248+12
	bl	buf_add_tail
	ldr	r2, .L1248+16
	ldrb	r3, [r2]	@ zero_extendqisi2
	adds	r3, r3, #1
	strb	r3, [r2]
	pop	{r4, pc}
.L1249:
	.align	2
.L1248:
	.word	.LANCHOR125
	.word	.LC0
	.word	.LANCHOR123
	.word	.LANCHOR126
	.word	.LANCHOR127
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
	beq	.L1252
	ldr	r3, .L1259
	ldr	r6, [r3]
	add	r6, r6, r0, lsl #2
	ldrb	r3, [r6, #2]	@ zero_extendqisi2
	tst	r3, #224
	beq	.L1253
	movw	r2, #833
	ldr	r1, .L1259+4
	ldr	r0, .L1259+8
	bl	printf
.L1253:
	ldrb	r3, [r6, #2]	@ zero_extendqisi2
	bfi	r3, r5, #5, #3
	uxtb	r3, r3
	ubfx	r2, r3, #3, #2
	orrs	r7, r7, r2
	bfi	r3, r7, #3, #2
	strb	r3, [r6, #2]
.L1254:
	mov	r0, r4
	pop	{r3, r4, r5, r6, r7, pc}
.L1252:
	bl	print_ftl_debug_info
	mov	r2, r5
	mov	r1, r4
	ldr	r0, .L1259+12
	bl	printf
	mov	r1, r6
	movs	r0, #0
	bl	zftl_get_free_sblk
	mov	r2, r5
	mov	r1, r0
	mov	r4, r0
	ldr	r0, .L1259+12
	bl	printf
	bl	dump_all_list_info
	movw	r2, #843
	ldr	r1, .L1259+4
	ldr	r0, .L1259+8
	bl	printf
	b	.L1254
.L1260:
	.align	2
.L1259:
	.word	.LANCHOR7
	.word	.LANCHOR128
	.word	.LC0
	.word	.LC73
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
	ldr	r2, .L1262
	movs	r3, #255
	movs	r0, #0
	strb	r3, [r2]
	ldr	r2, .L1262+4
	strb	r3, [r2]
	ldr	r2, .L1262+8
	strb	r3, [r2]
	ldr	r2, .L1262+12
	strb	r3, [r2]
	bx	lr
.L1263:
	.align	2
.L1262:
	.word	.LANCHOR54
	.word	.LANCHOR124
	.word	.LANCHOR129
	.word	.LANCHOR69
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
	ldr	r4, .L1273
	ldr	r0, .L1273+4
	ldrb	r1, [r4]	@ zero_extendqisi2
	bl	printf
	ldrb	r4, [r4]	@ zero_extendqisi2
	cmp	r4, #255
	beq	.L1264
	ldr	r5, .L1273+8
	add	r4, r4, r4, lsl #1
	ldr	r6, .L1273+12
	add	r4, r5, r4, lsl #4
.L1266:
	ldr	r3, [r4, #24]
	mov	r0, r6
	ldrb	r2, [r4, #42]	@ zero_extendqisi2
	ldrb	r1, [r4, #1]	@ zero_extendqisi2
	bl	printf
	ldrb	r4, [r4]	@ zero_extendqisi2
	cmp	r4, #255
	beq	.L1264
	add	r4, r4, r4, lsl #1
	add	r4, r5, r4, lsl #4
	b	.L1266
.L1264:
	pop	{r4, r5, r6, pc}
.L1274:
	.align	2
.L1273:
	.word	.LANCHOR54
	.word	.LC74
	.word	.LANCHOR50
	.word	.LC75
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
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1291
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	ldrb	r5, [r3]	@ zero_extendqisi2
	cmp	r5, #255
	beq	.L1283
	ldr	r3, .L1291+4
	ubfx	r10, r0, #21, #3
	ldr	lr, .L1291+12
	mov	ip, #48
	ldrh	r7, [r3]
	movs	r3, #1
	mov	r8, lr
	rsb	r2, r7, #21
	lsls	r3, r3, r2
	ldr	r2, .L1291+8
	subs	r3, r3, #1
	ldrb	r6, [r2]	@ zero_extendqisi2
	asr	r2, r0, r7
	uxth	r3, r3
	subs	r6, r6, #1
	uxth	r6, r6
	ands	r2, r2, r6
	ands	r2, r2, r3
.L1282:
	mla	r0, ip, r5, lr
	ldr	r4, [r0, #24]
	ubfx	fp, r4, #21, #3
	cmp	r10, fp
	bne	.L1277
	lsrs	r4, r4, r7
	ldrb	r0, [r0, #42]	@ zero_extendqisi2
	ands	r4, r4, r6
	ands	r4, r4, r3
	cmp	r2, r4
	bne	.L1278
	cmp	r1, #1
	bne	.L1275
	cmp	r0, #7
	beq	.L1277
	cmp	r0, #9
	beq	.L1277
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1278:
	cmp	r1, #3
	bhi	.L1277
	tbb	[pc, r1]
.L1279:
	.byte	(.L1275-.L1279)/2
	.byte	(.L1280-.L1279)/2
	.byte	(.L1281-.L1279)/2
	.byte	(.L1275-.L1279)/2
	.p2align 1
.L1280:
	cmp	r0, #7
	beq	.L1277
	cmp	r0, #9
	beq	.L1277
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1281:
	cmp	r0, #11
	bne	.L1275
.L1277:
	mul	r5, ip, r5
	ldrb	r5, [r8, r5]	@ zero_extendqisi2
	cmp	r5, #255
	bne	.L1282
.L1283:
	movs	r0, #0
.L1275:
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1292:
	.align	2
.L1291:
	.word	.LANCHOR54
	.word	.LANCHOR66
	.word	.LANCHOR67
	.word	.LANCHOR50
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
	ldr	r5, .L1318
	movs	r4, #48
	mov	fp, #255
	ldr	r6, .L1318+4
	ldrb	r3, [r5]	@ zero_extendqisi2
	ldr	r1, .L1318+8
	ldr	r7, .L1318+12
	str	r3, [sp, #4]
	ldrb	r3, [r6]	@ zero_extendqisi2
	ldrb	r2, [r1]	@ zero_extendqisi2
	ldrb	r10, [r7]	@ zero_extendqisi2
	str	r3, [sp]
	ldr	r3, .L1318+16
.L1294:
	cmp	r2, #255
	beq	.L1295
	mul	r8, r4, r2
	mov	r0, r2
	add	lr, r3, r8
	ldrb	lr, [lr, #42]	@ zero_extendqisi2
	sub	lr, lr, #12
	cmp	lr, #1
	bls	.L1296
.L1295:
	cmp	ip, #0
	beq	.L1293
	strb	r2, [r1]
	b	.L1293
.L1296:
	mul	lr, r4, r0
	ldrb	r2, [r3, r8]	@ zero_extendqisi2
	add	ip, r3, lr
	strb	fp, [r3, lr]
	ldrb	lr, [ip, #43]	@ zero_extendqisi2
	cmp	lr, #1
	bne	.L1299
	ldrh	ip, [ip, #34]
	cmp	ip, #0
	bne	.L1307
	mov	ip, r10
	mov	lr, r7
.L1300:
	cmp	ip, #255
	bne	.L1305
	strb	r2, [r1]
	movs	r2, #48
	mla	r3, r2, r0, r3
	ldrb	r3, [r3, #1]	@ zero_extendqisi2
	strb	r3, [lr]
.L1293:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1299:
	cmp	lr, #0
	bne	.L1301
	ldr	ip, [ip, #20]
	cmp	ip, #-1
	beq	.L1301
	ldr	ip, [sp, #4]
	mov	lr, r5
	b	.L1300
.L1307:
	ldr	ip, [sp]
	mov	lr, r6
	b	.L1300
.L1305:
	mov	lr, ip
	mul	ip, r4, ip
	ldrb	ip, [r3, ip]	@ zero_extendqisi2
	cmp	ip, #255
	bne	.L1305
	mla	r0, r4, r0, r3
	mul	lr, r4, lr
	ldrb	r0, [r0, #1]	@ zero_extendqisi2
	strb	r0, [r3, lr]
.L1301:
	mov	ip, #1
	b	.L1294
.L1319:
	.align	2
.L1318:
	.word	.LANCHOR129
	.word	.LANCHOR69
	.word	.LANCHOR54
	.word	.LANCHOR124
	.word	.LANCHOR50
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
	ldr	r5, .L1336
	ldr	r1, .L1336+4
	ldr	r2, [r5]
	ldrb	r1, [r1]	@ zero_extendqisi2
	ldrh	r3, [r2, #690]
	adds	r3, r3, #1
	uxth	r3, r3
	cmp	r1, r3
	strh	r3, [r2, #690]	@ movhi
	bls	.L1321
	add	r3, r3, #336
	ldrh	r2, [r2, r3, lsl #1]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L1322
.L1321:
	ldr	r7, .L1336+8
	ldr	r4, .L1336+12
.L1334:
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
	cbnz	r0, .L1323
	mov	r1, r6
	mov	r0, r7
	bl	printf
	ldr	r3, [r4]
	add	r6, r3, r6, lsl #2
	ldrb	r3, [r6, #2]	@ zero_extendqisi2
	orr	r3, r3, #224
	strb	r3, [r6, #2]
	b	.L1334
.L1323:
	ldr	r3, [r5]
	movs	r1, #1
	ldr	r2, .L1336+16
	movs	r4, #0
	strh	r4, [r3, #690]	@ movhi
	add	r3, r3, #416
	str	r1, [r2]
	movw	r1, #65535
.L1325:
	ldrh	r0, [r3], #2
	uxth	r2, r4
	cmp	r0, r1
	beq	.L1324
	adds	r4, r4, #1
	cmp	r4, #128
	bne	.L1325
	movs	r2, #194
	ldr	r1, .L1336+20
	ldr	r0, .L1336+24
	bl	printf
	mov	r2, r4
.L1324:
	ldr	r3, [r5]
	adds	r2, r2, #208
	strh	r6, [r3, r2, lsl #1]	@ movhi
	ldrh	r2, [r3, #688]
	adds	r2, r2, #1
	strh	r2, [r3, #688]	@ movhi
.L1322:
	ldr	r2, [r5]
	ldrh	r3, [r2, #690]
	add	r3, r3, #336
	ldrh	r4, [r2, r3, lsl #1]
	movw	r2, #65533
	subs	r3, r4, #1
	uxth	r3, r3
	cmp	r3, r2
	bls	.L1327
	movs	r2, #199
	ldr	r1, .L1336+20
	ldr	r0, .L1336+24
	bl	printf
.L1327:
	ldr	r1, [r5]
	movs	r3, #0
	strh	r3, [r1, #696]	@ movhi
	ldr	r3, .L1336+28
	strh	r4, [r1, #692]	@ movhi
	ldrh	r2, [r3]
	rsb	r2, r2, #21
	asr	r3, r4, r2
	strh	r3, [r1, #694]	@ movhi
	ldr	r1, .L1336+32
	ldr	r1, [r1]
	lsls	r1, r1, #19
	bpl	.L1331
	movs	r1, #1
	uxth	r3, r3
	lsl	r2, r1, r2
	ldr	r0, .L1336+36
	str	r3, [sp]
	mov	r1, r4
	mov	r3, r4
	subs	r2, r2, #1
	bl	printf
.L1331:
	movs	r0, #0
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, pc}
.L1337:
	.align	2
.L1336:
	.word	.LANCHOR102
	.word	.LANCHOR78
	.word	.LC76
	.word	.LANCHOR7
	.word	.LANCHOR130
	.word	.LANCHOR131
	.word	.LC0
	.word	.LANCHOR66
	.word	.LANCHOR14
	.word	.LC77
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
	ldr	r2, .L1348
	movw	r0, #65535
	push	{r3, r4, r5, r6, r7, lr}
	movs	r3, #0
	mov	r1, r2
.L1340:
	ldrh	r5, [r2, r3, lsl #3]
	uxth	r4, r3
	cmp	r5, r0
	beq	.L1339
	adds	r3, r3, #1
	cmp	r3, #32
	bne	.L1340
	movs	r2, #0
	mov	r4, r3
	mov	r0, #32768
.L1342:
	add	r3, r1, r2, lsl #3
	uxth	r5, r2
	ldrh	r3, [r3, #2]
	lsls	r6, r3, #16
	bmi	.L1341
	cmp	r3, r0
	itt	cc
	movcc	r0, r3
	movcc	r4, r5
.L1341:
	adds	r2, r2, #1
	cmp	r2, #32
	bne	.L1342
	cmp	r4, #32
	bne	.L1339
	ldr	r3, .L1348+4
	mov	r2, #-1
	ldrb	r5, [r3]	@ zero_extendqisi2
	movs	r3, #0
.L1344:
	add	r0, r1, r3, lsl #3
	uxth	r6, r3
	ldrh	r0, [r0, #2]
	cmp	r0, r2
	bcs	.L1343
	ldrh	r7, [r1, r3, lsl #3]
	cmp	r7, r5
	itt	ne
	movne	r2, r0
	movne	r4, r6
.L1343:
	adds	r3, r3, #1
	cmp	r3, #32
	bne	.L1344
	cmp	r4, #32
	bne	.L1339
	movw	r2, #297
	ldr	r1, .L1348+8
	ldr	r0, .L1348+12
	bl	printf
.L1339:
	mov	r0, r4
	pop	{r3, r4, r5, r6, r7, pc}
.L1349:
	.align	2
.L1348:
	.word	.LANCHOR132
	.word	.LANCHOR133
	.word	.LANCHOR134
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
	ldr	r3, .L1351
	movs	r0, #0
	str	r0, [r3]
	ldr	r3, .L1351+4
	str	r0, [r3]
	ldr	r3, .L1351+8
	str	r0, [r3]
	bx	lr
.L1352:
	.align	2
.L1351:
	.word	.LANCHOR135
	.word	.LANCHOR136
	.word	.LANCHOR137
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
	ldr	r4, .L1392
	cbnz	r0, .L1355
.L1356:
	strh	r0, [r4, r0, lsl #1]	@ movhi
	adds	r0, r0, #1
	cmp	r0, #256
	bne	.L1356
.L1362:
	movs	r1, #255
	mov	r2, #1024
	ldr	r0, .L1392+4
	bl	ftl_memset
	ldr	r1, .L1392+4
	movs	r3, #0
.L1357:
	ldrh	r2, [r4, r3, lsl #1]
	adds	r3, r3, #1
	cmp	r3, #256
	strh	r2, [r1, r2, lsl #1]	@ movhi
	bne	.L1357
	pop	{r4, pc}
.L1355:
	cmp	r0, #1
	bne	.L1358
	movs	r3, #0
.L1361:
	cmp	r3, #3
	uxth	r2, r3
	bls	.L1359
	tst	r2, #1
	ite	ne
	movne	r1, #3
	moveq	r1, #2
	rsb	r2, r1, r2, lsl #1
	uxth	r2, r2
.L1359:
	strh	r2, [r4, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	cmp	r3, #256
	bne	.L1361
	b	.L1362
.L1358:
	cmp	r0, #2
	bne	.L1363
	movs	r2, #0
.L1365:
	uxth	r3, r2
	cmp	r2, #1
	ittt	hi
	lslhi	r3, r3, #1
	addhi	r3, r3, #-1
	uxthhi	r3, r3
	strh	r3, [r4, r2, lsl #1]	@ movhi
	adds	r2, r2, #1
	cmp	r2, #256
	bne	.L1365
	b	.L1362
.L1363:
	cmp	r0, #3
	bne	.L1366
	movs	r3, #0
.L1369:
	cmp	r3, #5
	uxth	r2, r3
	bls	.L1367
	tst	r2, #1
	ite	ne
	movne	r1, #5
	moveq	r1, #4
	rsb	r2, r1, r2, lsl #1
	uxth	r2, r2
.L1367:
	strh	r2, [r4, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	cmp	r3, #256
	bne	.L1369
	b	.L1362
.L1366:
	cmp	r0, #4
	mov	r3, #0
	bne	.L1370
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
.L1372:
	tst	r3, #1
	ite	ne
	movne	r1, #7
	moveq	r1, #6
	rsb	r1, r1, r3, lsl #1
	adds	r3, r3, #1
	uxth	r3, r3
	strh	r1, [r2, #2]!	@ movhi
	cmp	r3, #256
	bne	.L1372
	b	.L1362
.L1370:
	cmp	r0, #5
	bne	.L1373
.L1374:
	strh	r3, [r4, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	cmp	r3, #16
	bne	.L1374
	ldr	r2, .L1392+8
.L1375:
	strh	r3, [r2, #2]!	@ movhi
	adds	r3, r3, #2
	uxth	r3, r3
	cmp	r3, #496
	bne	.L1375
	b	.L1362
.L1373:
	cmp	r0, #8
	bne	.L1376
.L1377:
	strh	r3, [r4, r3]	@ movhi
	adds	r3, r3, #2
	cmp	r3, #512
	bne	.L1377
	b	.L1362
.L1376:
	cmp	r0, #9
	bne	.L1362
	strh	r3, [r4]	@ movhi
	movs	r3, #1
	strh	r3, [r4, #2]	@ movhi
	mov	r2, r4
	movs	r3, #2
	movw	r1, #509
	strh	r3, [r2, #4]!	@ movhi
	movs	r3, #3
.L1378:
	strh	r3, [r2, #2]!	@ movhi
	adds	r3, r3, #2
	uxth	r3, r3
	cmp	r3, r1
	bne	.L1378
	b	.L1362
.L1393:
	.align	2
.L1392:
	.word	.LANCHOR3
	.word	.LANCHOR138
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
	ldr	r3, .L1411
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L1395
	ldr	r1, .L1411+4
	ldr	r0, .L1411+8
	bl	printf
.L1395:
	ldr	r4, .L1411+12
	movs	r6, #0
	ldr	r5, .L1411+16
	ldr	r7, .L1411+20
	ldrh	r3, [r4, #26]
	ldrb	r1, [r4, #12]	@ zero_extendqisi2
	ldrh	r0, [r4, #10]
	strh	r3, [r7]	@ movhi
	strb	r6, [r5]
	bl	__aeabi_idiv
	ldr	r10, .L1411+48
	movs	r2, #8
	ldr	r3, .L1411+24
	mov	r1, r6
	mov	r8, r10
	strh	r0, [r3]	@ movhi
	ldr	r0, .L1411+28
	bl	ftl_memset
	movs	r2, #32
	mov	r1, r6
	ldr	r0, .L1411+32
	bl	ftl_memset
.L1397:
	ldr	r3, .L1411+36
	movs	r2, #2
	add	r1, r10, r6, lsl #3
	ldr	r0, .L1411+40
	strb	r2, [r6, r3]
	ldrb	r2, [r4]	@ zero_extendqisi2
	bl	flash_mem_cmp8
	cbnz	r0, .L1396
	ldrb	r3, [r5]	@ zero_extendqisi2
	ldr	r2, .L1411+32
	str	r0, [r2, r3, lsl #2]
	adds	r2, r3, #1
	strb	r2, [r5]
	uxtb	r0, r6
	ldr	r2, .L1411+28
	strb	r0, [r2, r3]
	bl	zftl_flash_enter_slc_mode
.L1396:
	adds	r6, r6, #1
	cmp	r6, #4
	bne	.L1397
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	cmp	r3, #2
	beq	.L1398
.L1402:
	ldrb	r2, [r4, #13]	@ zero_extendqisi2
	ldrb	r3, [r5]	@ zero_extendqisi2
	smulbb	r3, r3, r2
	ldrh	r2, [r4, #14]
	smulbb	r3, r3, r2
	ldr	r2, .L1411+44
	strh	r3, [r2]	@ movhi
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1398:
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
	ldr	r3, .L1411+28
.L1401:
	mov	r2, r10
	add	r1, r8, r7, lsl #3
	ldr	r0, .L1411+40
	str	r3, [sp, #4]
	bl	flash_mem_cmp8
	ldr	r3, [sp, #4]
	cbnz	r0, .L1399
	ldr	r1, [sp]
	ldrb	r2, [r5]	@ zero_extendqisi2
	ldr	r0, .L1411+32
	cmp	fp, #0
	it	eq
	moveq	r1, r6
	strb	r7, [r3, r2]
	str	r1, [r0, r2, lsl #2]
	adds	r1, r2, #1
	strb	r1, [r5]
.L1399:
	adds	r7, r7, #1
	cmp	r7, #4
	bne	.L1401
	b	.L1402
.L1412:
	.align	2
.L1411:
	.word	.LANCHOR14
	.word	.LANCHOR139
	.word	.LC1
	.word	.LANCHOR31
	.word	.LANCHOR18
	.word	.LANCHOR2
	.word	.LANCHOR140
	.word	.LANCHOR30
	.word	.LANCHOR141
	.word	.LANCHOR32
	.word	.LANCHOR31+1
	.word	.LANCHOR142
	.word	.LANCHOR42
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
	ldr	r0, .L1414
	bl	ftl_memset
	ldr	r3, .L1414+4
	movs	r1, #255
	ldr	r2, .L1414+8
	ldrh	r3, [r3]
	ldrb	r2, [r2]	@ zero_extendqisi2
	muls	r2, r3, r2
	ldr	r3, .L1414+12
	ldr	r0, [r3]
	lsls	r2, r2, #2
	pop	{r3, lr}
	b	ftl_memset
.L1415:
	.align	2
.L1414:
	.word	.LANCHOR108
	.word	.LANCHOR85
	.word	.LANCHOR78
	.word	.LANCHOR110
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
	ldr	r3, .L1427
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L1417
	movs	r3, #0
	movs	r2, #224
	ldr	r1, .L1427+4
	ldr	r0, .L1427+8
	bl	printf
.L1417:
	ldr	r6, .L1427+12
	mov	r2, #512
	ldr	r4, .L1427+16
	movs	r1, #255
	ldr	r0, .L1427+20
	bl	ftl_memset
	ldrh	r3, [r4]
	movs	r1, #255
	ldrb	r2, [r6]	@ zero_extendqisi2
	ldr	r5, .L1427+24
	muls	r2, r3, r2
	ldr	r0, [r5]
	lsls	r2, r2, #2
	bl	ftl_memset
	ldr	r3, .L1427+28
	movs	r2, #0
	ldrb	r6, [r6]	@ zero_extendqisi2
	ldr	ip, [r5]
	ldr	r7, [r3]
	ldr	r0, .L1427+20
.L1418:
	ldrh	r3, [r4]
	uxth	r5, r2
	mov	r1, r5
	muls	r3, r6, r3
	cmp	r5, r3, lsl #1
	blt	.L1420
	pop	{r3, r4, r5, r6, r7, pc}
.L1420:
	ldr	r3, [r7, r1, lsl #2]
	adds	r2, r2, #1
	cmp	r3, #-1
	itttt	ne
	uxtbne	r3, r3
	ldrhne	lr, [r0, r3, lsl #1]
	strhne	r5, [r0, r3, lsl #1]	@ movhi
	strhne	lr, [ip, r1, lsl #1]	@ movhi
	b	.L1418
.L1428:
	.align	2
.L1427:
	.word	.LANCHOR14
	.word	.LANCHOR143
	.word	.LC78
	.word	.LANCHOR78
	.word	.LANCHOR85
	.word	.LANCHOR108
	.word	.LANCHOR110
	.word	.LANCHOR109
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
	ldr	r1, .L1432
	movs	r2, #0
	ldr	r3, .L1432+4
	strb	r2, [r4, #10]
	ldrb	r0, [r1, #9]	@ zero_extendqisi2
	ldrh	r3, [r3]
	smulbb	r3, r3, r0
	uxth	r3, r3
	strb	r3, [r4, #4]
	lsrs	r3, r3, #8
	strb	r3, [r4, #5]
	ldr	r3, .L1432+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	strb	r3, [r4, #7]
	ldr	r3, .L1432+12
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
	ldr	r0, .L1432+16
	strb	r3, [r4, #9]
	ldr	r3, .L1432+20
	ldrb	r1, [r3]	@ zero_extendqisi2
	mov	r3, r2
.L1430:
	uxtb	r2, r3
	cmp	r1, r2
	bhi	.L1431
	pop	{r4, r5, r6, pc}
.L1431:
	ldrb	r2, [r3, r0]	@ zero_extendqisi2
	adds	r3, r3, #1
	ldrb	r6, [r4, #10]	@ zero_extendqisi2
	lsl	r2, r5, r2
	orrs	r2, r2, r6
	strb	r2, [r4, #10]
	b	.L1430
.L1433:
	.align	2
.L1432:
	.word	.LANCHOR31
	.word	.LANCHOR2
	.word	.LANCHOR44
	.word	.LANCHOR59
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
	ldr	r0, .L1550
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #40
	ldr	r3, [r0]
	ldr	r3, [r3, #32]
	cmp	r3, #10240
	bls	.L1435
	bl	ftl_tmp_into_update
.L1435:
	ldr	r3, .L1550+4
	ldr	r3, [r3]
	ldr	r2, [r3, #568]
	ldr	r1, [r3, #12]
	add	r2, r2, #860160
	add	r2, r2, #3840
	cmp	r1, r2
	bhi	.L1436
	ldr	r4, [r0]
	ldr	r2, [r3, #572]
	ldr	r4, [r4, #36]
	adds	r2, r2, #32
	cmp	r4, r2
	bls	.L1487
.L1436:
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
.L1438:
	ldr	r3, .L1550+8
	ldrh	r3, [r3]
	cmp	r3, r6
	bhi	.L1449
	ldr	r6, .L1550+4
	movs	r3, #0
	movs	r2, #128
	movs	r1, #255
	ldr	r0, [r6]
	strh	r3, [r0, #122]	@ movhi
	add	r0, r0, #264
	bl	ftl_memset
	ldr	r3, [r6]
	ldrh	r1, [r3, #586]
	ldr	r3, .L1550+12
	ldr	r2, [r3]
	ldr	r3, .L1550+16
	ldr	r3, [r3]
	add	r6, r2, r1, lsl #2
	lsls	r0, r3, #21
	bpl	.L1450
	ldr	r0, .L1550+20
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
	ldr	r0, .L1550+24
	bl	printf
.L1450:
	ldrb	r3, [r6, #2]	@ zero_extendqisi2
	lsls	r2, r3, #28
	bpl	.L1451
	and	r2, r3, #192
	ldr	r6, .L1550+4
	cmp	r2, #64
	bne	.L1452
	ldr	r3, [r6]
	movs	r2, #1
	movs	r1, #0
	ldrh	r0, [r3, #586]
	bl	gc_add_sblk
	ldr	r3, .L1550+28
	movs	r2, #1
	strh	r2, [r3, #314]	@ movhi
.L1451:
	ldr	r3, .L1550+4
	ldr	r3, [r3]
	ldrh	r1, [r3, #584]
	ldr	r3, .L1550+12
	ldr	r2, [r3]
	ldr	r3, .L1550+16
	ldr	r3, [r3]
	add	r6, r2, r1, lsl #2
	lsls	r7, r3, #21
	bpl	.L1453
	ldr	r0, .L1550+20
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
	ldr	r0, .L1550+32
	bl	printf
.L1453:
	ldrb	r3, [r6, #2]	@ zero_extendqisi2
	lsls	r0, r3, #28
	bpl	.L1454
	and	r2, r3, #192
	cmp	r2, #64
	bne	.L1455
	ldr	r3, .L1550+4
	movs	r2, #1
	movs	r1, #0
	ldr	r3, [r3]
	ldrh	r0, [r3, #584]
	bl	gc_add_sblk
	ldr	r3, .L1550+28
	movs	r2, #1
	strh	r2, [r3, #314]	@ movhi
.L1454:
	ldr	r3, .L1550+16
	ldr	r3, [r3]
	lsls	r1, r3, #21
	bpl	.L1456
	ldr	r3, .L1550+12
	ldr	r0, .L1550+20
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
	ldr	r0, .L1550+36
	ubfx	r1, r1, #3, #2
	str	r1, [sp]
	mov	r1, r5
	bl	printf
.L1456:
	ldr	r3, .L1550+16
	ldr	r3, [r3]
	lsls	r2, r3, #21
	bpl	.L1457
	ldr	r3, .L1550+12
	ldr	r0, [sp, #20]
	ldr	r5, [sp, #20]
	ldr	r2, [r3]
	ldr	r3, [sp, #20]
	add	r1, r2, r3, lsl #2
	ldr	r3, [r2, r3, lsl #2]
	ldrh	r2, [r2, r0, lsl #2]
	ldr	r0, .L1550+20
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
	ldr	r0, .L1550+40
	ubfx	r1, r1, #3, #2
	str	r1, [sp]
	mov	r1, r5
	bl	printf
.L1457:
	ldr	r6, .L1550
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
	ldr	r5, .L1550+16
	ldr	r3, [r5]
	lsls	r3, r3, #21
	bpl	.L1458
	uxth	r0, r0
	uxth	r3, r7
	ldr	r2, [sp, #28]
	str	r0, [sp]
	ldr	r1, [sp, #24]
	ldr	r0, .L1550+44
	bl	printf
.L1458:
	ldr	r3, [r5]
	ldr	r5, .L1550+48
	tst	r3, #1024
	beq	.L1459
	ldrh	r3, [r5]
	mov	r2, fp
	mov	r1, r4
	ldr	r0, .L1550+52
	str	r3, [sp, #8]
	ldr	r3, .L1550+56
	ldrh	r3, [r3]
	str	r8, [sp]
	str	r3, [sp, #4]
	ldr	r3, [sp, #16]
	bl	printf
.L1459:
	sub	r3, r8, fp
	str	r3, [sp, #20]
	ldr	r2, [sp, #20]
	ldrh	r3, [r5]
	cmp	r2, r3
	bgt	.L1460
	ldr	r2, .L1550+56
	ldr	r3, [sp, #16]
	ldrh	r2, [r2]
	subs	r3, r3, r4
	cmp	r3, r2
	ble	.L1488
.L1460:
	ldr	r3, .L1550+4
	mov	r8, #0
	mov	r7, r8
	ldr	r3, [r3]
	ldrh	r5, [r3, #580]
	ldr	r3, [r6]
	ldrh	r10, [r3, #134]
.L1462:
	ldr	r3, .L1550+8
	ldrh	r3, [r3]
	cmp	r10, r3
	bcc	.L1472
.L1471:
	ldr	r3, .L1550+4
	ldr	r3, [r3]
	str	r5, [r3, #580]
.L1461:
	cmp	fp, #0
	beq	.L1474
	ldr	r3, .L1550
	ldr	r1, [r3]
	ldr	r3, .L1550+8
	ldrh	r2, [r1, #134]
	ldrh	r6, [r3]
	ldr	r3, .L1550+12
	ldr	r3, [r3]
	add	r3, r3, r2, lsl #2
	b	.L1551
.L1552:
	.align	2
.L1550:
	.word	.LANCHOR102
	.word	.LANCHOR10
	.word	.LANCHOR6
	.word	.LANCHOR7
	.word	.LANCHOR14
	.word	.LANCHOR9
	.word	.LC80
	.word	.LANCHOR63
	.word	.LC81
	.word	.LC82
	.word	.LC83
	.word	.LC84
	.word	.LANCHOR144
	.word	.LC85
	.word	.LANCHOR145
.L1551:
.L1475:
	cmp	r2, r6
	bcc	.L1477
	ldrh	r3, [r1, #72]
	add	r3, r3, fp
	strh	r3, [r1, #72]	@ movhi
	ldrh	r3, [r1, #98]
	cmp	fp, r3
	itt	cc
	subcc	r3, r3, fp
	strhcc	r3, [r1, #98]	@ movhi
.L1474:
	cbz	r4, .L1480
	ldr	r3, .L1553
	ldr	r1, [r3]
	ldr	r3, .L1553+4
	ldrh	r2, [r1, #134]
	ldrh	ip, [r3]
	ldr	r3, .L1553+8
	ldr	r3, [r3]
	add	r3, r3, r2, lsl #2
.L1481:
	cmp	r2, ip
	bcc	.L1483
	ldrh	r3, [r1, #74]
	add	r3, r3, r4
	strh	r3, [r1, #74]	@ movhi
	ldrh	r3, [r1, #96]
	cmp	r4, r3
	itt	cc
	subcc	r4, r3, r4
	strhcc	r4, [r1, #96]	@ movhi
.L1480:
	movs	r1, #5
	movs	r0, #0
	bl	zftl_get_gc_node
	movw	r2, #65535
	cmp	r0, r2
	beq	.L1437
	ldr	r2, .L1553+12
	ldr	r3, .L1553+16
	ldr	r2, [r2]
	ldrh	r3, [r3]
	ldrh	r2, [r2, r0, lsl #1]
	cmp	r2, r3
	bhi	.L1437
	adds	r7, r7, #1
	movs	r2, #1
	movs	r1, #0
	bl	gc_add_sblk
.L1437:
	add	r0, r7, r8
	add	sp, sp, #40
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1449:
	ldr	r3, .L1553+8
	lsls	r1, r6, #2
	ldr	r0, [r3]
	add	ip, r0, r1
	ldrb	r3, [ip, #2]	@ zero_extendqisi2
	and	r2, r3, #224
	cmp	r2, #224
	beq	.L1439
	ubfx	lr, r3, #3, #2
	tst	lr, #1
	beq	.L1440
	ldrh	r3, [r0, r1]
	ldr	r2, [r0, r1]
	ubfx	r3, r3, #0, #11
	ubfx	r2, r2, #11, #8
.L1441:
	ldr	r7, [sp, #24]
	cmp	r4, r3
	add	r10, r7, #1
	uxth	r7, r10
	str	r7, [sp, #24]
	ldr	r7, [sp, #32]
	add	r7, r7, r3
	str	r7, [sp, #32]
	bls	.L1486
	ldr	r4, .L1553+20
	ldr	r4, [r4]
	strh	r6, [r4, #586]	@ movhi
	mov	r4, r3
.L1486:
	ldr	r7, [sp, #16]
	movw	r10, #65535
	cmp	r7, r3
	itt	cc
	movcc	r5, r6
	strcc	r3, [sp, #16]
	cmp	r2, r10
	bne	.L1443
.L1445:
	cmp	r3, #9
	bls	.L1448
.L1439:
	adds	r6, r6, #1
	uxth	r6, r6
	b	.L1438
.L1440:
	tst	r3, #24
	bne	.L1442
	ldrh	r3, [r0, r1]
	movw	r2, #65535
	ubfx	r3, r3, #0, #11
	b	.L1441
.L1442:
	ldr	r3, [r0, r1]
	ubfx	r2, r3, #11, #8
	movw	r3, #65535
.L1443:
	ldr	r7, [sp, #28]
	cmp	fp, r2
	it	hi
	movhi	fp, r2
	add	r10, r7, #1
	uxth	r7, r10
	it	hi
	ldrhi	r10, .L1553+20
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
	bhi	.L1445
.L1448:
	ldr	r3, .L1553+24
	ldr	r3, [r3]
	lsls	r7, r3, #23
	bpl	.L1439
	ldr	r3, [r0, r1]
	ldrh	r2, [r0, r1]
	ldr	r1, .L1553+12
	ubfx	r3, r3, #11, #8
	ldr	r0, .L1553+28
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
	b	.L1439
.L1452:
	tst	r3, #224
	bne	.L1451
	ldr	r3, [r6]
	movw	r2, #65535
	ldrh	r10, [r3, #590]
	cmp	r10, r2
	bne	.L1451
	ldrh	r0, [r3, #586]
	ldrh	r3, [r3, #588]
	cmp	r3, r0
	beq	.L1451
	bl	zftl_remove_free_node
	ldr	r3, [r6]
	ldrh	r2, [r3, #586]
	strh	r10, [r3, #586]	@ movhi
	strh	r2, [r3, #590]	@ movhi
	b	.L1451
.L1455:
	tst	r3, #224
	bne	.L1454
	ldr	r10, .L1553+20
	movw	r2, #65535
	ldr	r3, [r10]
	ldrh	r6, [r3, #588]
	cmp	r6, r2
	bne	.L1454
	ldrh	r0, [r3, #584]
	ldrh	r3, [r3, #590]
	cmp	r3, r0
	beq	.L1454
	bl	zftl_remove_free_node
	ldr	r3, [r10]
	ldrh	r2, [r3, #584]
	strh	r6, [r3, #584]	@ movhi
	strh	r2, [r3, #588]	@ movhi
	b	.L1454
.L1472:
	adds	r5, r5, #1
	uxth	r5, r5
	cmp	r3, r5
	it	ls
	movls	r5, #0
	ldr	r3, .L1553+8
	lsls	r6, r5, #2
	ldr	r3, [r3]
	adds	r2, r3, r6
	ldrb	r2, [r2, #2]	@ zero_extendqisi2
	tst	r2, #192
	beq	.L1464
	and	r0, r2, #224
	cmp	r0, #224
	beq	.L1464
	ubfx	r2, r2, #3, #2
	ands	r1, r2, #1
	beq	.L1465
	cmp	r0, #160
.L1548:
	bne	.L1467
	ldr	r2, .L1553+32
	ldr	r0, [sp, #20]
	ldrh	r2, [r2]
	cmp	r0, r2
	ble	.L1468
	ldr	r2, [r3, r6]
	ubfx	r2, r2, #11, #8
	cmp	r2, fp
	bls	.L1469
	cbz	r1, .L1468
	ldrh	r2, [r3, r6]
	ubfx	r2, r2, #0, #11
	cmp	r2, r4
	bgt	.L1468
.L1469:
	movs	r2, #1
	movs	r1, #0
	mov	r0, r5
	str	r3, [sp, #24]
	bl	gc_add_sblk
	ldr	r0, .L1553+36
	movs	r2, #1
	add	r7, r7, r2
	ldr	r3, [sp, #24]
	strh	r2, [r0, #314]	@ movhi
	ldr	r2, .L1553+24
	ldr	r2, [r2]
	tst	r2, #1024
	beq	.L1468
	ldr	r2, .L1553+12
	ldr	r1, [r3, r6]
	ldr	r2, [r2]
	ubfx	r1, r1, #11, #8
	ldrh	ip, [r2, r5, lsl #1]
	ldr	r2, .L1553+8
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
	ldr	r0, .L1553+40
	str	r3, [sp]
	mov	r3, ip
.L1549:
	bl	printf
.L1468:
	cmp	r7, #4
	bhi	.L1471
	cmp	r8, #4
	bhi	.L1471
.L1464:
	add	r10, r10, #1
	uxth	r10, r10
	b	.L1462
.L1465:
	cmp	r2, #2
	b	.L1548
.L1554:
	.align	2
.L1553:
	.word	.LANCHOR102
	.word	.LANCHOR6
	.word	.LANCHOR7
	.word	.LANCHOR9
	.word	.LANCHOR85
	.word	.LANCHOR10
	.word	.LANCHOR14
	.word	.LC79
	.word	.LANCHOR144
	.word	.LANCHOR63
	.word	.LC86
.L1467:
	ldr	r0, .L1555
	ldr	r2, [sp, #16]
	ldrh	r0, [r0]
	subs	r2, r2, r4
	cmp	r2, r0
	ble	.L1468
	ldrh	r2, [r3, r6]
	add	r0, r4, #8
	ubfx	r2, r2, #0, #11
	cmp	r2, r0
	ble	.L1470
	cmp	r1, #0
	beq	.L1468
	ldr	r2, [r3, r6]
	add	r1, fp, #4
	ubfx	r2, r2, #11, #8
	cmp	r2, r1
	bgt	.L1468
.L1470:
	movs	r2, #1
	movs	r1, #0
	mov	r0, r5
	str	r3, [sp, #24]
	bl	gc_add_sblk
	ldr	r0, .L1555+4
	movs	r2, #1
	add	r8, r8, r2
	ldr	r3, [sp, #24]
	strh	r2, [r0, #314]	@ movhi
	ldr	r2, .L1555+8
	ldr	r2, [r2]
	tst	r2, #1024
	beq	.L1468
	ldr	r2, .L1555+12
	ldr	r1, [r3, r6]
	ldr	r2, [r2]
	ubfx	r1, r1, #11, #8
	ldrh	ip, [r2, r5, lsl #1]
	ldr	r2, .L1555+16
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
	ldr	r0, .L1555+20
	str	r3, [sp]
	mov	r3, ip
	b	.L1549
.L1488:
	mov	r8, #0
	mov	r7, r8
	b	.L1461
.L1477:
	ldr	r0, [r3]
	ubfx	r5, r0, #11, #8
	cmp	fp, r5
	bhi	.L1476
	ldrb	ip, [r3, #2]	@ zero_extendqisi2
	tst	ip, #24
	ittt	ne
	subne	r5, r5, fp
	bfine	r0, r5, #11, #8
	strne	r0, [r3]
.L1476:
	adds	r2, r2, #1
	adds	r3, r3, #4
	uxth	r2, r2
	b	.L1475
.L1483:
	ldrh	r0, [r3]
	ubfx	r5, r0, #0, #11
	cmp	r5, r4
	blt	.L1482
	ldrb	r6, [r3, #2]	@ zero_extendqisi2
	and	r6, r6, #24
	cmp	r6, #16
	ittt	ne
	subne	r5, r5, r4
	bfine	r0, r5, #0, #11
	strhne	r0, [r3]	@ movhi
.L1482:
	adds	r2, r2, #1
	adds	r3, r3, #4
	uxth	r2, r2
	b	.L1481
.L1487:
	mov	r8, #0
	mov	r7, r8
	b	.L1437
.L1556:
	.align	2
.L1555:
	.word	.LANCHOR145
	.word	.LANCHOR63
	.word	.LANCHOR14
	.word	.LANCHOR9
	.word	.LANCHOR7
	.word	.LC87
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
	ldr	r8, .L1585+76
	sub	sp, sp, #24
	movs	r1, #0
	movs	r4, #0
	ldr	fp, .L1585+80
	ldrh	r3, [r8]
	ldr	r5, .L1585
	ldr	r0, [fp]
	ldr	r10, .L1585+64
	muls	r2, r3, r2
	ldr	r7, .L1585+4
	ldr	r6, .L1585+8
	bl	ftl_memset
	ldr	r3, .L1585+12
	movs	r2, #16
	ldr	r1, .L1585+16
	mov	r0, #32768
	strh	r4, [r10]	@ movhi
	str	r4, [r3]
	ldr	r3, .L1585+20
	ldrh	r1, [r1]
	strh	r4, [r7]	@ movhi
	str	r4, [r3]
	ldr	r3, .L1585+24
	strh	r4, [r6]	@ movhi
	str	r4, [r3]
	ldr	r3, .L1585+28
	str	r4, [r3]
	ldr	r3, .L1585+32
	str	r4, [r3]
	ldr	r3, .L1585+36
	str	r4, [r3]
	ldr	r3, .L1585+40
	strh	r2, [r3]	@ movhi
	ldr	r2, .L1585+44
	ldr	r3, .L1585+48
	strh	r4, [r2]	@ movhi
	ldr	r2, .L1585+52
	strh	r4, [r3]	@ movhi
	str	r3, [sp, #4]
	strh	r4, [r2]	@ movhi
	ldrb	r2, [r5]	@ zero_extendqisi2
	muls	r1, r2, r1
	bl	__aeabi_idiv
	ldr	r2, .L1585+56
	sxth	r3, r0
	str	fp, [sp, #12]
	mov	fp, r10
	str	r3, [sp]
	ldr	r1, [r2]
	ldr	r3, [sp, #4]
	ldr	r10, .L1585+84
	strh	r4, [r1, #146]	@ movhi
	ldrsh	r4, [r1, #134]
	str	r8, [sp, #8]
	mov	r8, r3
	str	r2, [sp, #16]
	str	r5, [sp, #20]
.L1558:
	ldr	r3, [sp, #8]
	ldrh	r3, [r3]
	cmp	r4, r3
	blt	.L1574
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
	ldr	r2, .L1585+44
	ldrh	r2, [r2]
	strh	r2, [r3, #120]	@ movhi
	ldr	r2, .L1585+52
	ldrh	r2, [r2]
	strh	r2, [r3, #124]	@ movhi
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1574:
	ldr	r5, [r10]
	add	r5, r5, r4, lsl #2
	ldrb	r0, [r5, #3]	@ zero_extendqisi2
	cmp	r0, #0
	beq	.L1575
	ldr	r3, [sp, #20]
	ldrb	lr, [r3]	@ zero_extendqisi2
	ldr	r3, .L1585+56
	ldr	ip, [r3]
	ldr	r3, .L1585+16
	ldrh	r3, [r3]
	str	r3, [sp, #4]
	movs	r3, #0
	mov	r1, r3
.L1560:
	cmp	r3, lr
	blt	.L1563
	cmp	r1, #0
	beq	.L1564
	mov	r0, #32768
	bl	__aeabi_idiv
	adds	r1, r0, #1
	sxth	r1, r1
.L1559:
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
	beq	.L1565
	cmp	r3, #224
	beq	.L1565
	ldr	r2, .L1585+60
	ldr	r2, [r2]
	ldrh	ip, [r2, #16]
	cmp	r4, ip
	beq	.L1565
	ldrh	ip, [r2, #48]
	cmp	r4, ip
	beq	.L1565
	ldrh	r2, [r2, #80]
	cmp	r4, r2
	beq	.L1565
	cmp	r3, #64
	bne	.L1566
	ldr	r2, .L1585+64
	uxth	r1, r4
	ldr	r0, .L1585+32
.L1583:
	bl	_insert_data_list
.L1565:
	adds	r4, r4, #1
	sxth	r4, r4
	b	.L1558
.L1563:
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
	b	.L1560
.L1564:
	ldrb	r3, [r5, #2]	@ zero_extendqisi2
	movw	r2, #65535
	orr	r3, r3, #224
	strb	r3, [r5, #2]
	ldr	r3, .L1585+68
	ldr	r3, [r3]
	strh	r2, [r3, r4, lsl #1]	@ movhi
	b	.L1559
.L1575:
	ldr	r1, [sp]
	b	.L1559
.L1566:
	cmp	r3, #96
	bne	.L1567
	ldr	r2, .L1585+52
	uxth	r1, r4
	ldr	r0, .L1585+28
	b	.L1583
.L1567:
	cmp	r3, #160
	bne	.L1568
	ldr	r2, .L1585+44
	uxth	r1, r4
	ldr	r0, .L1585+36
	b	.L1583
.L1568:
	cmp	r3, #0
	bne	.L1565
	ldr	r3, .L1585+68
	ldr	r3, [r3]
	ldrh	r2, [r3, r0]
	cbz	r2, .L1569
	mov	r1, r4
	ldr	r0, .L1585+72
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
	b	.L1565
.L1569:
	ands	r3, r1, #24
	uxth	r1, r4
	bne	.L1572
	ldr	r2, .L1585+48
	ldr	r0, .L1585+12
.L1584:
	bl	_insert_free_list
	b	.L1565
.L1572:
	cmp	r3, #16
	ittee	eq
	ldreq	r2, .L1585+4
	ldreq	r0, .L1585+20
	ldrne	r2, .L1585+8
	ldrne	r0, .L1585+24
	b	.L1584
.L1586:
	.align	2
.L1585:
	.word	.LANCHOR78
	.word	.LANCHOR97
	.word	.LANCHOR99
	.word	.LANCHOR96
	.word	.LANCHOR77
	.word	.LANCHOR98
	.word	.LANCHOR100
	.word	.LANCHOR81
	.word	.LANCHOR12
	.word	.LANCHOR80
	.word	.LANCHOR101
	.word	.LANCHOR92
	.word	.LANCHOR95
	.word	.LANCHOR88
	.word	.LANCHOR102
	.word	.LANCHOR10
	.word	.LANCHOR90
	.word	.LANCHOR9
	.word	.LC88
	.word	.LANCHOR6
	.word	.LANCHOR4
	.word	.LANCHOR7
	.size	zftl_sblk_list_init, .-zftl_sblk_list_init
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
	ldr	r8, .L1593+12
	mov	r6, r1
	movs	r7, #0
.L1588:
.L1591:
	mov	r0, r6
	ldr	r10, .L1593+16
	bl	ftl_alloc_sblk
	movs	r1, #0
	mov	r5, r0
	bl	ftl_erase_sblk
	add	r1, r4, #16
	mov	r0, r5
	bl	ftl_get_blk_list_in_sblk
	ldr	r1, .L1593
	cmp	r6, #2
	ldrh	r2, [r8]
	uxtb	r0, r0
	strh	r5, [r4]	@ movhi
	ite	eq
	moveq	r3, #0
	ldrbne	r3, [r1]	@ zero_extendqisi2
	ldrb	r1, [r1]	@ zero_extendqisi2
	strb	r0, [r4, #9]
	smulbb	r0, r0, r2
	strh	r7, [r4, #2]	@ movhi
	it	ne
	smulbbne	r3, r3, r2
	strb	r7, [r4, #5]
	mul	r2, r2, r1
	ldr	r1, .L1593+4
	strh	r0, [r4, #6]	@ movhi
	it	ne
	uxthne	r3, r3
	strh	r7, [r4, #10]	@ movhi
	ldr	r0, [r1]
	movs	r1, #255
	strh	r3, [r4, #12]	@ movhi
	lsls	r2, r2, #2
	strb	r6, [r4, #4]
	add	r0, r0, r3, lsl #2
	bl	ftl_memset
	ldr	r3, [r10]
	ldrh	r2, [r4, #6]
	strh	r2, [r3, r5, lsl #1]	@ movhi
	ldrb	r3, [r4, #9]	@ zero_extendqisi2
	cbnz	r3, .L1587
	mov	r1, r5
	ldr	r0, .L1593+8
	bl	printf
	ldr	r3, [r10]
	movw	r2, #65535
	strh	r2, [r3, r5, lsl #1]	@ movhi
	movs	r3, #7
	strb	r3, [r4, #4]
	b	.L1591
.L1587:
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L1594:
	.align	2
.L1593:
	.word	.LANCHOR78
	.word	.LANCHOR109
	.word	.LC76
	.word	.LANCHOR85
	.word	.LANCHOR9
	.size	ftl_open_sblk_init, .-ftl_open_sblk_init
	.section	.text.pm_free_sblk,"ax",%progbits
	.align	1
	.global	pm_free_sblk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	pm_free_sblk, %function
pm_free_sblk:
	@ args = 0, pretend = 0, frame = 280
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1613
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #288
	ldrh	r2, [r3]
	str	r3, [sp, #12]
	cmp	r2, #128
	bls	.L1596
	movs	r2, #78
	ldr	r1, .L1613+4
	ldr	r0, .L1613+8
	bl	printf
.L1596:
	mov	r2, #256
	movs	r1, #0
	add	r0, sp, #32
	movs	r4, #1
	bl	ftl_memset
	ldr	r3, .L1613+12
	add	r10, sp, #32
	ldr	r0, .L1613+16
	ldr	r5, [sp, #12]
	ldrh	r7, [r3]
	ldr	r6, [r0]
	mov	fp, r0
	ldr	r1, .L1613+20
	rsb	r3, r7, #21
	ldrh	r5, [r5]
	lsls	r4, r4, r3
	ldrh	r2, [r6, #698]
	ldrb	r3, [r1]	@ zero_extendqisi2
	add	r8, r6, #704
	str	r5, [sp, #16]
	subs	r4, r4, #1
	movs	r5, #0
	str	r1, [sp, #20]
.L1597:
	uxth	r1, r5
	cmp	r2, r1
	bhi	.L1601
	ldr	r3, .L1613+24
	movs	r5, #0
	ldr	r6, .L1613+28
	str	r5, [sp, #8]
	ldrb	r4, [r3]	@ zero_extendqisi2
	ldrh	r2, [r6]
	str	r3, [sp, #16]
	smulbb	r4, r4, r2
	uxth	r4, r4
.L1602:
	ldr	r3, [sp, #12]
	uxth	r2, r5
	ldrh	r3, [r3]
	cmp	r3, r2
	bhi	.L1608
	ldr	r0, [sp, #8]
	add	sp, sp, #288
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1601:
	ldr	r0, [r8], #4
	mov	r1, r3
	str	r2, [sp, #28]
	str	r3, [sp, #24]
	lsrs	r0, r0, r7
	ands	r0, r0, r4
	bl	__aeabi_uidiv
	uxth	r3, r0
	ldr	r2, [sp, #28]
	add	lr, r6, #416
	str	r3, [sp, #8]
	movs	r1, #0
	ldr	r3, [sp, #24]
.L1598:
	ldr	r0, [sp, #16]
	uxth	ip, r1
	cmp	r0, ip
	bhi	.L1600
	adds	r5, r5, #1
	b	.L1597
.L1600:
	ldrh	ip, [lr], #2
	ldr	r0, [sp, #8]
	cmp	r0, ip
	ittt	eq
	ldrheq	ip, [r10, r1, lsl #1]
	addeq	ip, ip, #1
	strheq	ip, [r10, r1, lsl #1]	@ movhi
	adds	r1, r1, #1
	b	.L1598
.L1608:
	ldr	r3, [fp]
	uxth	r7, r5
	str	r2, [sp, #28]
	add	r8, r7, #208
	ldr	r2, [sp, #20]
	ldrh	r10, [r3, r8, lsl #1]
	ldrh	r0, [r3, #692]
	ldrb	r1, [r2]	@ zero_extendqisi2
	str	r3, [sp, #24]
	bl	__aeabi_idiv
	cmp	r0, r10
	ldr	r3, [sp, #24]
	ldr	r2, [sp, #28]
	bne	.L1603
	ldr	r1, [sp, #16]
	ldrh	r0, [r6]
	ldrb	r1, [r1]	@ zero_extendqisi2
	smulbb	r1, r1, r0
	add	r0, sp, #32
	strh	r1, [r0, r7, lsl #1]	@ movhi
.L1603:
	add	r1, sp, #32
	ldrh	r1, [r1, r7, lsl #1]
	cmp	r4, r1
	bls	.L1604
	cbnz	r1, .L1609
.L1606:
	movw	r2, #65535
	cmp	r10, r2
	beq	.L1605
	ldr	r2, .L1613+32
	ldr	r2, [r2]
	lsls	r2, r2, #19
	bpl	.L1607
	ldrh	r3, [r3, #688]
	movs	r2, #0
	mov	r1, r7
	ldr	r0, .L1613+36
	str	r3, [sp]
	mov	r3, r10
	bl	printf
.L1607:
	ldr	r3, [fp]
	ldrh	r0, [r3, r8, lsl #1]
	bl	ftl_free_sblk
	ldr	r3, [fp]
	movw	r2, #65535
	strh	r2, [r3, r8, lsl #1]	@ movhi
	ldrh	r2, [r3, #688]
	subs	r2, r2, #1
	strh	r2, [r3, #688]	@ movhi
	b	.L1605
.L1604:
	cmp	r1, #0
	beq	.L1606
.L1605:
	adds	r5, r5, #1
	b	.L1602
.L1609:
	str	r2, [sp, #8]
	mov	r4, r1
	b	.L1605
.L1614:
	.align	2
.L1613:
	.word	.LANCHOR146
	.word	.LANCHOR147
	.word	.LC0
	.word	.LANCHOR66
	.word	.LANCHOR102
	.word	.LANCHOR67
	.word	.LANCHOR78
	.word	.LANCHOR85
	.word	.LANCHOR14
	.word	.LC89
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
	ldr	r3, .L1621
	push	{r4, lr}
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L1617
	ldr	r2, .L1621+4
	movs	r1, #105
	ldr	r0, .L1621+8
	bl	printf
.L1617:
	ldr	r4, .L1621+12
	mov	r2, #2048
	movs	r1, #0
	ldr	r0, [r4]
	bl	ftl_memset
	ldr	r0, [r4]
	movs	r2, #32
	ldr	r3, .L1621+16
	ldr	r1, .L1621+20
	adds	r0, r0, #80
	str	r3, [r0, #-80]
	mov	r3, #2032
	str	r3, [r0, #-72]
	movs	r3, #1
	strh	r3, [r0, #-64]	@ movhi
	bl	ftl_memcpy
	ldr	r0, [r4]
	movs	r2, #32
	ldr	r1, .L1621+24
	pop	{r4, lr}
	adds	r0, r0, #48
	b	ftl_memcpy
.L1622:
	.align	2
.L1621:
	.word	.LANCHOR14
	.word	.LANCHOR148
	.word	.LC90
	.word	.LANCHOR27
	.word	1398362953
	.word	.LANCHOR20
	.word	.LANCHOR31
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
.L1624:
	cmp	r3, r2
	bne	.L1625
	pop	{r4, pc}
.L1625:
	ldr	r4, [r1, r3, lsl #2]
	str	r4, [r0, r3, lsl #2]
	adds	r3, r3, #1
	b	.L1624
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
	ldr	r0, .L1628
	bx	lr
.L1629:
	.align	2
.L1628:
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
	ldr	r6, .L1650
	sub	sp, sp, #20
	mov	r4, r0
	str	r3, [sp, #12]
	ldr	r3, [r6]
	lsls	r0, r3, #19
	bpl	.L1632
	mov	r2, r4
	ldr	r1, .L1650+4
	ldr	r0, .L1650+8
	bl	printf
.L1632:
	ldr	r1, [r4, #352]
	movs	r3, #6
	ldr	r2, .L1650+12
	ldr	r5, .L1650+16
	ldr	r7, .L1650+20
	cmp	r1, r2
	ldr	r2, [r4, #128]
	strb	r3, [r5]
	itt	eq
	moveq	r3, #8
	strbeq	r3, [r5]
	ldr	r3, .L1650+24
	str	r4, [r7]
	cmp	r2, r3
	ldr	r2, .L1650+28
	itt	eq
	moveq	r3, #9
	strbeq	r3, [r5]
	ldrb	r3, [r5]	@ zero_extendqisi2
	cmp	r3, #9
	ldr	r3, .L1650+32
	bne	.L1635
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
	bpl	.L1637
	ldr	r1, [r4]
	ldr	r2, [r4, #8]
	ldr	r3, [r4, #80]
	ldr	r0, [r4, #84]
	ldr	r4, [r4, #88]
	stm	sp, {r0, r4}
.L1649:
	ldr	r0, .L1650+36
	bl	printf
.L1637:
	ldr	r3, .L1650+40
	movs	r2, #1
	strb	r2, [r3]
	movs	r3, #0
	ldr	r2, .L1650+44
	strh	r3, [r2]	@ movhi
	ldr	r2, .L1650+48
	strb	r3, [r2]
	ldr	r3, [r6]
	lsls	r3, r3, #19
	bpl	.L1631
	ldrb	r1, [r5]	@ zero_extendqisi2
	ldr	r0, .L1650+52
	bl	printf
.L1631:
	add	sp, sp, #20
	@ sp needed
	pop	{r4, r5, r6, r7, pc}
.L1635:
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
	ldr	r3, .L1650+56
	str	r0, [r3]
	ldr	r3, [r6]
	lsls	r2, r3, #19
	bpl	.L1637
	ldr	r0, [r7]
	ldr	r1, [r0]
	ldr	r2, [r0, #344]
	ldr	r3, [r0, #304]
	ldr	r4, [r0, #308]
	ldr	r0, [r0, #312]
	str	r4, [sp]
	str	r0, [sp, #4]
	b	.L1649
.L1651:
	.align	2
.L1650:
	.word	.LANCHOR14
	.word	.LANCHOR149
	.word	.LC91
	.word	1446522928
	.word	.LANCHOR28
	.word	.LANCHOR13
	.word	1446588464
	.word	1052675
	.word	.LANCHOR45
	.word	.LC92
	.word	.LANCHOR46
	.word	.LANCHOR48
	.word	.LANCHOR44
	.word	.LC93
	.word	.LANCHOR47
	.size	nandc_init, .-nandc_init
	.section	.text.buf_init,"ax",%progbits
	.align	1
	.global	buf_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	buf_init, %function
buf_init:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, lr}
	movs	r5, #0
	ldr	r4, .L1655
	mov	r6, r5
	ldr	r7, .L1655+4
	mov	r8, r4
.L1653:
	ldrb	r0, [r7]	@ zero_extendqisi2
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
	ldrb	r0, [r7]	@ zero_extendqisi2
	lsls	r0, r0, #1
	bl	ftl_malloc
	cmp	r5, #32
	str	r0, [r4, #-36]
	bne	.L1653
	movs	r3, #255
	strb	r3, [r8, #1488]
	ldr	r3, .L1655+8
	strb	r6, [r3]
	ldr	r3, .L1655+12
	strb	r5, [r3]
	pop	{r4, r5, r6, r7, r8, pc}
.L1656:
	.align	2
.L1655:
	.word	.LANCHOR50
	.word	.LANCHOR123
	.word	.LANCHOR51
	.word	.LANCHOR52
	.size	buf_init, .-buf_init
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
	ldr	r3, .L1658
	mov	r2, #340
	push	{r4, r5, r6, lr}
	movs	r4, #0
	ldr	r5, .L1658+4
	mov	r1, r4
	strb	r4, [r3]
	ldr	r3, .L1658+8
	mov	r0, r5
	strb	r4, [r3]
	ldr	r3, .L1658+12
	str	r4, [r3]
	ldr	r3, .L1658+16
	strh	r4, [r3]	@ movhi
	bl	ftl_memset
	movw	r3, #65535
	str	r4, [r5, #8]
	strh	r3, [r5]	@ movhi
	ldr	r3, .L1658+20
	ldrh	r3, [r3]
	lsrs	r2, r3, #1
	lsrs	r1, r3, #2
	strh	r2, [r5, #34]	@ movhi
	ldr	r2, .L1658+24
	strh	r1, [r5, #32]	@ movhi
	ldr	r5, .L1658+28
	strh	r4, [r2]	@ movhi
	ldr	r2, .L1658+32
	strh	r4, [r2]	@ movhi
	ldr	r2, .L1658+36
	strh	r4, [r2]	@ movhi
	ldr	r4, .L1658+40
	ldrb	r0, [r4]	@ zero_extendqisi2
	smulbb	r2, r0, r3
	uxth	r2, r2
	sub	r6, r2, #32
	strh	r6, [r5]	@ movhi
	ldr	r5, .L1658+44
	strh	r2, [r5]	@ movhi
	ldr	r2, .L1658+48
	ldr	r5, .L1658+52
	strh	r3, [r2]	@ movhi
	ldr	r3, .L1658+56
	strh	r1, [r3]	@ movhi
	ldrh	r3, [r5]
	muls	r0, r3, r0
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L1658+60
	str	r0, [r3]
	ldrh	r3, [r5]
	ldrb	r0, [r4]	@ zero_extendqisi2
	muls	r0, r3, r0
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L1658+64
	str	r0, [r3]
	ldrh	r3, [r5]
	ldrb	r0, [r4]	@ zero_extendqisi2
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L1658+68
	str	r0, [r3]
	ldrh	r3, [r5]
	ldrb	r0, [r4]	@ zero_extendqisi2
	muls	r0, r3, r0
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L1658+72
	str	r0, [r3]
	ldrh	r3, [r5]
	ldrb	r0, [r4]	@ zero_extendqisi2
	muls	r0, r3, r0
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L1658+76
	ldr	r2, .L1658+80
	str	r0, [r3]
	ldr	r3, .L1658+84
	ldrh	r3, [r3]
	lsrs	r3, r3, #2
	strh	r3, [r2]	@ movhi
	pop	{r4, r5, r6, pc}
.L1659:
	.align	2
.L1658:
	.word	.LANCHOR76
	.word	.LANCHOR63
	.word	.LANCHOR150
	.word	.LANCHOR151
	.word	.LANCHOR87
	.word	.LANCHOR85
	.word	.LANCHOR86
	.word	.LANCHOR94
	.word	.LANCHOR82
	.word	.LANCHOR83
	.word	.LANCHOR78
	.word	.LANCHOR91
	.word	.LANCHOR84
	.word	.LANCHOR77
	.word	.LANCHOR62
	.word	.LANCHOR152
	.word	.LANCHOR153
	.word	.LANCHOR74
	.word	.LANCHOR68
	.word	.LANCHOR154
	.word	.LANCHOR79
	.word	.LANCHOR89
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
	ldr	r3, .L1664
	add	r1, r1, r0
	push	{r4, lr}
.L1662:
	cmp	r0, r1
	bne	.L1663
	mov	r0, r3
	pop	{r4, pc}
.L1663:
	lsrs	r2, r3, #2
	ldrb	r4, [r0], #1	@ zero_extendqisi2
	add	r2, r2, r3, lsl #5
	add	r2, r2, r4
	eors	r3, r3, r2
	b	.L1662
.L1665:
	.align	2
.L1664:
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
	ldr	r3, .L1671
	ldr	r0, [r3]
	bx	lr
.L1672:
	.align	2
.L1671:
	.word	.LANCHOR59
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
	ldr	r7, .L1682
	mov	fp, r0
	mov	r6, r1
	mov	r8, r2
	mov	r10, r3
	mov	r4, r5
.L1674:
	cmp	r4, r10
	bne	.L1680
	ldr	r1, .L1682+4
	ldr	r0, .L1682+8
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	printf
.L1680:
	cbnz	r5, .L1675
	mov	r2, r4
	mov	r1, fp
	ldr	r0, .L1682+12
	bl	printf
.L1675:
	cmp	r8, #4
	bne	.L1676
	ldr	r1, [r6, r4, lsl #2]
.L1681:
	mov	r0, r7
	adds	r5, r5, #1
	bl	printf
	cmp	r5, #15
	bls	.L1679
	movs	r5, #0
	ldr	r1, .L1682+4
	ldr	r0, .L1682+8
	bl	printf
.L1679:
	adds	r4, r4, #1
	b	.L1674
.L1676:
	cmp	r8, #2
	ite	eq
	ldrsheq	r1, [r6, r4, lsl #1]
	ldrbne	r1, [r6, r4]	@ zero_extendqisi2
	b	.L1681
.L1683:
	.align	2
.L1682:
	.word	.LC95
	.word	.LC96
	.word	.LC97
	.word	.LC94
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
	ldr	r3, .L1795
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
	bne	.L1685
	movs	r3, #167
	mov	r8, #7
	strb	r3, [fp, #128]
	movs	r2, #247
	ldr	r3, .L1795+4
	strb	r2, [r3, #17]
.L1789:
	mov	r10, #4
	b	.L1686
.L1685:
	cmp	r0, #3
	bne	.L1687
	add	r2, fp, #127
	movs	r3, #176
.L1688:
	strb	r3, [r2, #1]!
	adds	r3, r3, #1
	uxtb	r3, r3
	cmp	r3, #184
	bne	.L1688
.L1790:
	mov	r8, #8
	mov	r10, r8
.L1686:
	subs	r3, r4, #1
	cmp	r3, #1
	bhi	.L1694
	movs	r5, #0
.L1695:
	ldr	r3, .L1795+8
	ldrb	r2, [r3]	@ zero_extendqisi2
	uxtb	r3, r5
	cmp	r2, r3
	bhi	.L1700
.L1701:
	strb	r10, [fp, #113]
	strb	r8, [fp, #114]
	add	sp, sp, #56
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1687:
	cmp	r0, #4
	bne	.L1689
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
	b	.L1790
.L1689:
	cmp	r0, #5
	bne	.L1690
	movs	r3, #56
	mov	r8, #8
	strb	r3, [fp, #128]
	movs	r3, #57
	strb	r3, [fp, #129]
	movs	r3, #58
	strb	r3, [fp, #130]
	movs	r3, #59
	strb	r3, [fp, #131]
	b	.L1789
.L1690:
	cmp	r0, #6
	bne	.L1691
	movs	r3, #14
	mov	r8, #12
	strb	r3, [fp, #128]
	movs	r3, #15
	strb	r3, [fp, #129]
	movs	r3, #16
	strb	r3, [fp, #130]
	movs	r3, #17
	strb	r3, [fp, #131]
	b	.L1789
.L1691:
	cmp	r0, #7
	bne	.L1692
	add	r2, fp, #127
	movs	r3, #176
.L1693:
	strb	r3, [r2, #1]!
	adds	r3, r3, #1
	uxtb	r3, r3
	cmp	r3, #184
	bne	.L1693
	movs	r3, #212
	mov	r8, #12
	strb	r3, [fp, #136]
	movs	r3, #213
	strb	r3, [fp, #137]
	mov	r10, #10
	b	.L1686
.L1692:
	cmp	r0, #8
	mov	r3, #7
	bne	.L1748
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
	b	.L1686
.L1748:
	mov	r8, r3
	b	.L1789
.L1700:
	ldr	r2, .L1795+12
	movs	r1, #160
	ldr	r0, [sp]
	add	r7, r10, #-1
	add	r6, fp, #127
	ldrb	r3, [r2, r3]	@ zero_extendqisi2
	ldr	r2, .L1795+16
	uxtab	r7, r0, r7
	ldr	r4, [r2]
	mla	r1, r1, r3, fp
	add	r4, r4, r3, lsl #8
	adds	r1, r1, #144
	subs	r2, r1, #1
	addw	r3, r4, #2056
.L1696:
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
	bne	.L1696
	ldr	r7, .L1795+4
	mov	r0, r1
	movs	r2, #0
.L1697:
	movs	r3, #1
	adds	r6, r7, r2
.L1698:
	ldrb	r4, [r6, r3, lsl #2]	@ zero_extendqisi2
	ldrb	ip, [r0]	@ zero_extendqisi2
	add	r4, r4, ip
	strb	r4, [r0, r3, lsl #3]
	adds	r3, r3, #1
	cmp	r3, #7
	bne	.L1698
	adds	r2, r2, #1
	adds	r0, r0, #1
	cmp	r2, #4
	bne	.L1697
	movs	r3, #0
	adds	r5, r5, #1
	strb	r3, [r1, #16]
	strb	r3, [r1, #24]
	strb	r3, [r1, #32]
	strb	r3, [r1, #40]
	strb	r3, [r1, #48]
	strb	r3, [r1, #41]
	strb	r3, [r1, #49]
	b	.L1695
.L1694:
	subs	r3, r4, #3
	cmp	r3, #5
	bhi	.L1701
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
.L1794:
	str	r3, [sp, #20]
	ldr	r3, .L1795+8
	ldrb	r2, [r3]	@ zero_extendqisi2
	ldrb	r3, [sp, #20]	@ zero_extendqisi2
	cmp	r2, r3
	bls	.L1701
	ldr	r2, .L1795+12
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
	ldr	r3, .L1795+16
	ldr	r3, [r3]
	str	r3, [sp, #4]
	add	r5, r3, r2, lsl #8
	str	r6, [r5, #2056]
	bl	nandc_wait_flash_ready
	cmp	r4, #8
	bne	.L1703
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
.L1704:
	ldm	sp, {r2, r3}
	add	r3, r3, r2, lsl #8
	movs	r2, #48
	str	r2, [r3, #2056]
	bl	nandc_wait_flash_ready
	subs	r3, r4, #5
	cmp	r3, #1
	str	r3, [sp, #28]
	bls	.L1750
	cmp	r4, #8
	beq	.L1750
	cmp	r4, #7
	ite	ne
	movne	r2, #2
	moveq	r2, #32
.L1710:
	ldr	r3, .L1795+20
	subs	r2, r2, #1
	ldr	r5, [sp, #4]
	ldr	r6, [sp]
	ldr	r3, [r3]
	add	r7, r5, r6, lsl #8
	subs	r1, r3, #1
	uxtab	r2, r3, r2
	mov	r0, r1
.L1711:
	ldr	r5, [r7, #2048]
	strb	r5, [r0, #1]!
	cmp	r2, r0
	bne	.L1711
	cmp	r4, #8
	bne	.L1712
	movs	r2, #0
.L1714:
	ldrb	r0, [r3, r2, lsl #2]	@ zero_extendqisi2
	uxtb	r1, r2
	cmp	r0, #50
	beq	.L1713
	add	r0, r3, r2, lsl #2
	ldrb	r0, [r0, #1]	@ zero_extendqisi2
	cmp	r0, #5
	beq	.L1713
	adds	r2, r2, #1
	cmp	r2, #8
	bne	.L1714
.L1715:
	movs	r1, #0
	ldr	r0, .L1795+24
	bl	printf
.L1717:
	b	.L1717
.L1703:
	cmp	r4, #4
	mov	r3, #54
	str	r3, [r5, #2056]
	bne	.L1705
	movs	r3, #64
	str	r6, [r5, #2052]
	str	r3, [r5, #2048]
	movs	r3, #204
.L1791:
	str	r3, [r5, #2052]
	movs	r3, #77
	b	.L1792
.L1796:
	.align	2
.L1795:
	.word	.LANCHOR27
	.word	.LANCHOR155
	.word	.LANCHOR18
	.word	.LANCHOR30
	.word	.LANCHOR13
	.word	.LANCHOR156
	.word	.LC98
.L1705:
	subs	r3, r4, #5
	cmp	r3, #1
	bhi	.L1707
	ldrb	r3, [fp, #128]	@ zero_extendqisi2
	str	r3, [r5, #2052]
	movs	r3, #82
.L1792:
	str	r3, [r5, #2048]
.L1706:
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
	b	.L1704
.L1707:
	cmp	r4, #7
	bne	.L1706
	movs	r3, #174
	str	r3, [r5, #2052]
	movs	r3, #0
	str	r3, [r5, #2048]
	movs	r3, #176
	b	.L1791
.L1750:
	movs	r2, #16
	b	.L1710
.L1713:
	cmp	r1, #6
	bhi	.L1715
.L1716:
	ldr	r3, .L1797
	ldr	ip, [r3]
	mov	r3, ip
.L1726:
	ldr	r1, [sp, #48]
	sub	r2, r3, ip
	cmp	r1, r2
	bgt	.L1727
	ldr	r3, .L1797
	ldr	r1, [r3]
	ldr	r3, [sp, #24]
	adds	r2, r1, r3
	movs	r3, #8
.L1729:
	mov	r5, r2
	movs	r0, #0
.L1728:
	ldrh	r6, [r5]
	adds	r0, r0, #1
	mvns	r6, r6
	strh	r6, [r5], #2	@ movhi
	ldr	r6, [sp, #8]
	cmp	r6, r0
	bgt	.L1728
	ldr	r0, [sp, #44]
	subs	r3, r3, #1
	add	r2, r2, r0
	bne	.L1729
	mov	r6, r1
	str	r3, [sp, #16]
.L1730:
	movs	r0, #0
	mov	r2, r0
.L1734:
	movs	r3, #1
	mov	lr, r6
	lsl	r5, r3, r2
	movs	r3, #0
	str	r3, [sp, #12]
	str	r5, [sp, #32]
	movs	r5, #16
	str	r5, [sp, #36]
.L1732:
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
	bne	.L1732
	ldr	r3, [sp, #12]
	adds	r2, r2, #1
	cmp	r3, #8
	ittt	hi
	ldrhi	r3, [sp, #32]
	orrhi	r0, r0, r3
	uxthhi	r0, r0
	cmp	r2, #16
	bne	.L1734
	ldr	r3, [sp, #16]
	strh	r0, [r6], #2	@ movhi
	adds	r3, r3, #1
	str	r3, [sp, #16]
	ldr	r2, [sp, #16]
	ldr	r3, [sp, #8]
	cmp	r3, r2
	bgt	.L1730
	subs	r2, r1, #4
	add	r0, r1, #28
	movs	r3, #0
.L1737:
	ldr	r5, [r2, #4]!
	cbnz	r5, .L1736
	adds	r3, r3, #1
.L1736:
	cmp	r0, r2
	bne	.L1737
	cmp	r3, #7
	ble	.L1738
	ldr	r0, .L1797+4
	mov	r3, #1024
	movs	r2, #1
	bl	rknand_print_hex
	movs	r1, #0
	ldr	r0, .L1797+8
	bl	printf
.L1739:
	b	.L1739
.L1712:
	cmp	r4, #7
	bne	.L1718
	movs	r2, #0
.L1720:
	ldrb	r0, [r3, r2, lsl #2]	@ zero_extendqisi2
	uxtb	r1, r2
	cmp	r0, #12
	beq	.L1719
	add	r0, r3, r2, lsl #2
	ldrb	r0, [r0, #1]	@ zero_extendqisi2
	cmp	r0, #10
	beq	.L1719
	adds	r2, r2, #1
	cmp	r2, #8
	bne	.L1720
.L1721:
	movs	r1, #0
	ldr	r0, .L1797+8
	bl	printf
.L1722:
	b	.L1722
.L1719:
	cmp	r1, #6
	bls	.L1716
	b	.L1721
.L1718:
	cmp	r4, #6
	bne	.L1716
	adds	r3, r3, #7
.L1723:
	ldrb	r2, [r1, #1]!	@ zero_extendqisi2
	cmp	r2, #12
	beq	.L1716
	ldrb	r2, [r1, #8]	@ zero_extendqisi2
	cmp	r2, #4
	beq	.L1716
	cmp	r3, r1
	bne	.L1723
	movs	r1, #0
	ldr	r0, .L1797+8
	bl	printf
.L1725:
	b	.L1725
.L1727:
	ldr	r2, [r7, #2048]
	strb	r2, [r3], #1
	b	.L1726
.L1738:
	cmp	r4, #6
	beq	.L1752
	cmp	r4, #7
	beq	.L1753
	cmp	r4, #8
	ite	ne
	movne	r0, #8
	moveq	r0, #5
.L1740:
	add	r3, r10, #-1
	ldr	r1, [sp, #40]
	uxtb	r3, r3
	movs	r5, #0
	adds	r3, r3, #1
.L1741:
	mov	lr, r1
	mov	r2, ip
.L1742:
	ldrb	r6, [r2], #1	@ zero_extendqisi2
	strb	r6, [lr], #1
	sub	r6, r2, ip
	uxtb	r6, r6
	cmp	r10, r6
	bhi	.L1742
	adds	r5, r5, #1
	add	ip, ip, r3
	cmp	r8, r5
	add	r1, r1, r0
	bgt	.L1741
	ldm	sp, {r2, r3}
	movs	r6, #255
	add	r5, r3, r2, lsl #8
	str	r6, [r5, #2056]
	bl	nandc_wait_flash_ready
	ldr	r3, [sp, #28]
	cmp	r3, #1
	bhi	.L1744
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
.L1793:
	str	r3, [r5, #2056]
	bl	nandc_wait_flash_ready
	ldr	r3, [sp, #20]
	adds	r3, r3, #1
	b	.L1794
.L1752:
	movs	r0, #4
	b	.L1740
.L1753:
	movs	r0, #10
	b	.L1740
.L1744:
	cmp	r4, #8
	ite	eq
	moveq	r3, #190
	movne	r3, #56
	b	.L1793
.L1798:
	.align	2
.L1797:
	.word	.LANCHOR156
	.word	.LC99
	.word	.LC98
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
	ldr	r3, .L1801
	ldrb	r0, [r3, #19]	@ zero_extendqisi2
	subs	r3, r0, #1
	cmp	r3, #7
	bhi	.L1799
	b	hynix_get_read_retry_default
.L1799:
	bx	lr
.L1802:
	.align	2
.L1801:
	.word	.LANCHOR31
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
	ldr	r3, .L1841
	push	{r0, r1, r2, r4, r5, r6, r7, r8, r10, lr}
	movs	r4, #0
	ldr	r7, .L1841+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldr	r5, .L1841+8
	strb	r4, [r7]
	cmp	r3, #9
	ldr	r6, [r5]
	bne	.L1804
	ldr	r3, [r6, #16]
	str	r3, [sp]
	ldr	r3, [r6, #48]
	ubfx	r3, r3, #1, #1
	cbnz	r3, .L1805
	ldr	r7, .L1841+12
	mov	r4, r3
	ldr	r8, .L1841+32
.L1806:
	ldr	r3, [sp]
	lsls	r0, r3, #11
	bmi	.L1809
	ldr	r3, [r5]
	adds	r4, r4, #1
	ldr	r3, [r3, #16]
	str	r3, [sp]
	bics	r3, r4, #-16777216
	bne	.L1806
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
	b	.L1806
.L1805:
	ldr	r8, .L1841+24
	ldr	r10, .L1841+32
.L1807:
	ldr	r2, [r6, #64]
	ldr	r3, [sp]
	ubfx	r2, r2, #16, #6
	ubfx	r3, r3, #22, #6
	cmp	r2, r3
	bge	.L1809
	ldr	r3, [r5]
	ldr	r3, [r3]
	str	r3, [sp, #4]
	ldr	r3, [sp, #4]
	lsls	r1, r3, #18
	bpl	.L1808
	ldr	r3, [sp, #4]
	lsls	r2, r3, #14
	bpl	.L1808
	ldr	r1, [sp, #4]
	ldr	r0, .L1841+16
	ubfx	r1, r1, #17, #1
.L1840:
	bl	printf
	b	.L1809
.L1808:
	ldr	r3, [sp]
	adds	r4, r4, #1
	ubfx	r3, r3, #22, #6
	cmp	r4, r3, lsl #12
	bne	.L1807
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
	bpl	.L1807
	movs	r3, #1
	strb	r3, [r7]
.L1809:
	ldr	r3, .L1841+20
	movs	r2, #0
	str	r2, [r3, #20]
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L1804:
	ldr	r3, [r6, #8]
	str	r3, [sp]
	ldr	r3, [r6, #16]
	ubfx	r3, r3, #1, #1
	cbnz	r3, .L1815
	ldr	r7, .L1841+12
	mov	r4, r3
	ldr	r8, .L1841+32
.L1816:
	ldr	r3, [sp]
	lsls	r3, r3, #11
	bmi	.L1809
	ldr	r3, [r5]
	adds	r4, r4, #1
	ldr	r3, [r3, #8]
	str	r3, [sp]
	bics	r3, r4, #-16777216
	bne	.L1816
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
	b	.L1816
.L1815:
	ldr	r7, .L1841+24
	ldr	r8, .L1841+32
.L1817:
	ldr	r2, [r6, #28]
	ldr	r3, [sp]
	ubfx	r2, r2, #16, #5
	ubfx	r3, r3, #22, #6
	cmp	r2, r3
	bge	.L1809
	ldr	r3, [r5]
	ldr	r3, [r3]
	str	r3, [sp, #4]
	ldr	r3, [sp, #4]
	lsls	r1, r3, #18
	bpl	.L1818
	ldr	r3, [sp, #4]
	lsls	r2, r3, #14
	bpl	.L1818
	ldr	r1, [sp, #4]
	ldr	r0, .L1841+28
	b	.L1840
.L1818:
	adds	r4, r4, #1
	bics	r3, r4, #-16777216
	bne	.L1817
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
	b	.L1817
.L1842:
	.align	2
.L1841:
	.word	.LANCHOR28
	.word	.LANCHOR157
	.word	.LANCHOR13
	.word	.LC103
	.word	.LC100
	.word	.LANCHOR47
	.word	.LC101
	.word	.LC104
	.word	.LC102
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
	bne	.L1862
	ldr	r3, .L1881
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #9
	bne	.L1845
	ldr	r7, .L1881+4
	lsr	ip, r4, #2
	movs	r2, #1
	mov	r1, r8
	mov	r0, r8
	ldr	r4, [r7]
.L1846:
	cmp	r1, ip
	bcc	.L1850
	ldr	r4, [r4]
	cmp	r2, #0
	it	ne
	movne	r0, #512
	and	r3, r4, #139264
	cmp	r3, #139264
	bne	.L1852
	mov	r1, r4
	ldr	r0, .L1881+8
	bl	printf
	ldr	r3, [r7]
	mov	r0, #-1
	orr	r4, r4, #131072
	str	r4, [r3]
.L1852:
	lsls	r2, r4, #18
	bpl	.L1853
	ldr	r3, .L1881+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L1853
	mov	r1, r4
	ldr	r0, .L1881+16
	bl	printf
	ldr	r3, [r7]
	movs	r2, #1
	str	r2, [r3, #16]
.L1880:
	mov	r0, #-1
.L1844:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L1850:
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
	bmi	.L1864
	ldr	r3, [sp, #4]
	lsls	r3, r3, #13
	bmi	.L1864
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
.L1847:
	adds	r1, r1, #1
	b	.L1846
.L1864:
	mov	r0, #-1
	b	.L1847
.L1845:
	ldr	r3, .L1881+20
	mov	r1, r8
	mov	r0, r8
	ldr	r8, .L1881+28
	lsrs	r7, r4, #1
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #25
	mov	r3, r5
	ite	cc
	movcc	lr, #64
	movcs	lr, #128
.L1855:
	cmp	r0, r7
	add	ip, lr, r1
	add	r3, r3, #4
	bcc	.L1856
	ldr	r7, .L1881+4
	movs	r2, #0
	lsrs	r4, r4, #2
	mov	r0, r2
	ldr	r1, [r7]
.L1857:
	cmp	r2, r4
	bcc	.L1861
	movs	r3, #0
	str	r3, [r1, #16]
	ldr	r4, [r1]
	and	r3, r4, #139264
	cmp	r3, #139264
	bne	.L1853
	mov	r1, r4
	ldr	r0, .L1881+24
	bl	printf
	ldr	r3, [r7]
	orr	r4, r4, #131072
	str	r4, [r3]
	b	.L1880
.L1856:
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
	b	.L1855
.L1861:
	add	r3, r2, #8
	ldr	r3, [r1, r3, lsl #2]
	str	r3, [sp, #4]
	ldr	r3, [sp, #4]
	lsls	r3, r3, #29
	bmi	.L1867
	ldr	r3, [sp, #4]
	lsls	r3, r3, #16
	bmi	.L1867
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
.L1858:
	adds	r2, r2, #1
	b	.L1857
.L1867:
	mov	r0, #-1
	b	.L1858
.L1853:
	adds	r3, r0, #1
	beq	.L1844
	ldr	r3, [r5]
	adds	r3, r3, #1
	bne	.L1844
	ldr	r3, [r5, #4]
	adds	r3, r3, #1
	bne	.L1844
	ldr	r3, [r6]
	adds	r3, r3, #1
	it	eq
	moveq	r0, #512
	b	.L1844
.L1862:
	movs	r0, #0
	b	.L1844
.L1882:
	.align	2
.L1881:
	.word	.LANCHOR28
	.word	.LANCHOR13
	.word	.LC105
	.word	.LANCHOR157
	.word	.LC106
	.word	.LANCHOR44
	.word	.LC107
	.word	.LANCHOR47
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
	@ args = 4, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #24
	str	r3, [sp, #16]
	mov	r5, r0
	mov	r7, r1
	ubfx	r4, r1, #0, #21
	ldr	r3, .L1898
	ubfx	r8, r1, #24, #2
	str	r2, [sp, #12]
	ldr	r6, [r3]
	ldr	r3, .L1898+4
	ldr	r3, [r3]
	lsls	r3, r3, #27
	bpl	.L1884
	mov	r3, r1
	mov	r2, r8
	mov	r1, r0
	ldr	r0, .L1898+8
	bl	printf
.L1884:
	bl	nandc_wait_flash_ready
	mov	r0, r5
	lsl	r10, r5, #8
	bl	nandc_cs
	ldr	r2, .L1898+12
	cmp	r8, #0
	bne	.L1885
	mov	r0, r5
	str	r2, [sp, #20]
	bl	zftl_flash_enter_slc_mode
.L1896:
	ldr	r2, [sp, #20]
	b	.L1886
.L1885:
	ldr	r3, [r2]
	ldrb	r3, [r3, #12]	@ zero_extendqisi2
	cmp	r3, #3
	bne	.L1887
	add	r3, r6, r10
	str	r8, [r3, #2056]
.L1886:
	add	fp, r6, r10
	movs	r1, #0
	str	r1, [fp, #2056]
	uxtb	r7, r7
	str	r1, [fp, #2052]
	str	r1, [fp, #2052]
	lsrs	r1, r4, #8
	str	r7, [fp, #2052]
	ldr	r2, [r2]
	str	r1, [fp, #2052]
	lsrs	r1, r4, #16
	str	r1, [fp, #2052]
	movs	r1, #48
	str	r1, [fp, #2056]
	ldrb	r2, [r2, #12]	@ zero_extendqisi2
	cmp	r2, #3
	bne	.L1888
	cmp	r8, #0
	beq	.L1888
	add	r4, r4, r4, lsl #1
	subs	r0, r4, #1
	add	r0, r0, r8
.L1897:
	bl	nandc_set_seed
	add	r6, r6, r10
	bl	nandc_wait_flash_ready
	movs	r1, #0
	movs	r2, #5
	movs	r3, #224
	str	r2, [r6, #2056]
	str	r1, [fp, #2052]
	mov	r0, r5
	str	r1, [fp, #2052]
	str	r3, [r6, #2056]
	ldr	r3, [sp, #16]
	ldrb	r2, [sp, #56]	@ zero_extendqisi2
	str	r3, [sp]
	ldr	r3, [sp, #12]
	bl	nandc_xfer
	bl	nandc_de_cs.constprop.29
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1887:
	mov	r0, r5
	str	r2, [sp, #20]
	bl	zftl_flash_exit_slc_mode
	b	.L1896
.L1888:
	mov	r0, r4
	b	.L1897
.L1899:
	.align	2
.L1898:
	.word	.LANCHOR13
	.word	.LANCHOR14
	.word	.LC108
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
	mov	fp, r3
	ldr	r3, .L1917
	sub	sp, sp, #24
	mov	r8, r0
	mov	r7, r1
	str	r2, [sp, #16]
	movs	r5, #0
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r4, #-1
	add	r3, r3, r3, lsl #1
	asr	r10, r3, #2
	bl	nandc_wait_flash_ready
	ldr	r3, .L1917+4
	ldr	r3, [r3]
	str	r3, [sp, #12]
.L1901:
	ldr	r3, .L1917+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r5, r3
	bcc	.L1906
.L1905:
	ldr	r3, [sp, #12]
	movs	r0, #200
	add	r8, r3, r8, lsl #8
	movs	r3, #239
	str	r3, [r8, #2056]
	movs	r3, #137
	str	r3, [r8, #2052]
	bl	timer_delay_ns
	cmp	r4, r10
	mov	r3, #0
	str	r3, [r8, #2048]
	str	r3, [r8, #2048]
	str	r3, [r8, #2048]
	str	r3, [r8, #2048]
	bcc	.L1907
	adds	r3, r4, #1
	mov	r2, r7
	it	ne
	movne	r4, #256
	mov	r3, r5
	str	r4, [sp]
	mov	r1, r5
	ldr	r0, .L1917+12
	bl	printf
.L1907:
	bl	nandc_wait_flash_ready
	mov	r0, r4
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1906:
	ldr	r3, [sp, #12]
	movs	r0, #200
	add	r1, r3, r8, lsl #8
	movs	r3, #239
	str	r3, [r1, #2056]
	movs	r3, #137
	str	r3, [r1, #2052]
	bl	timer_delay_ns
	adds	r3, r5, #1
	ldr	r2, [sp, #16]
	str	r3, [r1, #2048]
	mov	r0, r8
	str	r3, [sp, #20]
	movs	r3, #0
	str	r3, [r1, #2048]
	str	r3, [r1, #2048]
	str	r3, [r1, #2048]
	mov	r1, r7
	ldr	r3, [sp, #56]
	str	r3, [sp]
	mov	r3, fp
	bl	flash_read_page
	ldr	r3, .L1917+16
	mov	r6, r0
	ldr	r3, [r3]
	lsls	r1, r3, #19
	bpl	.L1902
	str	r0, [sp]
	mov	r3, r4
	mov	r2, r7
	mov	r1, r5
	ldr	r0, .L1917+20
	bl	printf
.L1902:
	adds	r2, r6, #1
	beq	.L1903
	ldr	r3, .L1917+24
	cmp	r4, #-1
	it	eq
	moveq	r4, r6
	cmp	r6, r10
	ldr	r3, [r3]
	str	r3, [sp, #16]
	ldr	r3, .L1917+28
	ldr	fp, [r3]
	bcc	.L1909
.L1903:
	ldr	r5, [sp, #20]
	b	.L1901
.L1909:
	mov	r4, r6
	b	.L1905
.L1918:
	.align	2
.L1917:
	.word	.LANCHOR44
	.word	.LANCHOR13
	.word	.LANCHOR159
	.word	.LC110
	.word	.LANCHOR14
	.word	.LC109
	.word	.LANCHOR156
	.word	.LANCHOR158
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
	ldr	r3, .L1962
	ldr	fp, [r3]
	ldr	r3, .L1962+4
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
	bne	.L1921
	mov	r4, #-1
	movs	r5, #1
	str	r3, [sp, #20]
.L1928:
	ldr	r3, [sp, #20]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #36
	bne	.L1922
	movs	r2, #0
	mov	r1, r5
	mov	r0, r6
	bl	toshiba_tlc_set_rr_para
	add	r3, fp, r7, lsl #8
	movs	r2, #93
	str	r2, [r3, #2056]
.L1923:
	ldr	r3, [sp, #56]
	mov	r1, r8
	ldr	r2, [sp, #8]
	mov	r0, r7
	str	r3, [sp]
	ldr	r3, [sp, #12]
	bl	flash_read_page
	ldr	r3, .L1962+8
	mov	r10, r0
	ldr	r3, [r3]
	lsls	r1, r3, #27
	bpl	.L1924
	mov	r3, r0
	mov	r2, r8
	mov	r1, r5
	ldr	r0, .L1962+12
	bl	printf
.L1924:
	cmp	r10, #-1
	beq	.L1925
	ldr	r3, .L1962+16
	cmp	r4, #-1
	it	eq
	moveq	r4, r10
	ldr	r3, [r3]
	str	r3, [sp, #8]
	ldr	r3, .L1962+20
	ldr	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L1962+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r10, r3, asr #2
	bcc	.L1943
.L1925:
	ldr	r3, [sp, #16]
	adds	r5, r5, #1
	cmp	r3, r5
	bne	.L1928
.L1927:
	ldr	r3, .L1962+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #36
	bne	.L1929
	movs	r2, #0
.L1961:
	movs	r1, #0
	mov	r0, r6
	bl	toshiba_tlc_set_rr_para
	b	.L1930
.L1922:
	uxtb	r1, r5
	mov	r0, r6
	bl	toshiba_3d_set_slc_rr_para
	b	.L1923
.L1943:
	mov	r4, r10
	b	.L1927
.L1929:
	movs	r1, #0
	mov	r0, r6
	bl	toshiba_3d_set_slc_rr_para
.L1930:
	ldr	r3, .L1962+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #36
	bne	.L1939
	add	r7, fp, r7, lsl #8
	movs	r3, #85
	str	r3, [r7, #2056]
	movs	r3, #0
	str	r3, [r7, #2052]
	str	r3, [r7, #2048]
	movs	r3, #255
	str	r3, [r7, #2056]
.L1939:
	ldr	r3, .L1962+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r4, r3, asr #2
	bcc	.L1940
	adds	r3, r4, #1
	mov	r2, r8
	it	ne
	movne	r4, #256
	mov	r3, r5
	str	r4, [sp]
	mov	r1, r5
	ldr	r0, .L1962+28
	bl	printf
.L1940:
	bl	nandc_wait_flash_ready
	mov	r0, r4
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1921:
	mov	r4, #-1
	movs	r5, #1
	str	r3, [sp, #16]
.L1937:
	ldr	r3, [sp, #16]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #36
	bne	.L1931
	movs	r2, #1
	mov	r1, r5
	mov	r0, r6
	bl	toshiba_tlc_set_rr_para
	add	r3, fp, r7, lsl #8
	movs	r2, #93
.L1960:
	str	r2, [r3, #2056]
	mov	r1, r8
	ldr	r3, [sp, #56]
	mov	r0, r7
	ldr	r2, [sp, #8]
	str	r3, [sp]
	ldr	r3, [sp, #12]
	bl	flash_read_page
	ldr	r3, .L1962+8
	mov	r10, r0
	ldr	r3, [r3]
	lsls	r2, r3, #27
	bpl	.L1933
	mov	r3, r0
	mov	r2, r8
	mov	r1, r5
	ldr	r0, .L1962+32
	bl	printf
.L1933:
	cmp	r10, #-1
	beq	.L1934
	ldr	r3, .L1962+16
	cmp	r4, #-1
	it	eq
	moveq	r4, r10
	ldr	r3, [r3]
	str	r3, [sp, #8]
	ldr	r3, .L1962+20
	ldr	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L1962+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r10, r3, asr #2
	bcc	.L1944
.L1934:
	ldr	r3, [sp, #20]
	adds	r5, r5, #1
	cmp	r3, r5
	bne	.L1937
.L1936:
	ldr	r3, .L1962+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #36
	bne	.L1938
	movs	r2, #1
	b	.L1961
.L1931:
	uxtb	r1, r5
	mov	r0, r6
	bl	toshiba_3d_set_tlc_rr_para
	add	r3, fp, r7, lsl #8
	movs	r2, #38
	b	.L1960
.L1944:
	mov	r4, r10
	b	.L1936
.L1938:
	movs	r1, #0
	mov	r0, r6
	bl	toshiba_3d_set_tlc_rr_para
	b	.L1930
.L1963:
	.align	2
.L1962:
	.word	.LANCHOR13
	.word	.LANCHOR23
	.word	.LANCHOR14
	.word	.LC111
	.word	.LANCHOR156
	.word	.LANCHOR158
	.word	.LANCHOR44
	.word	.LC113
	.word	.LC112
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
	ldr	r3, .L1991
	ldr	r2, .L1991+4
	ldr	r6, [r3]
	ldrb	r3, [r2]	@ zero_extendqisi2
	str	r2, [sp, #20]
	subs	r3, r3, #67
	add	r10, r6, r10, lsl #8
	cmp	r3, #1
	bls	.L1982
	ldr	r3, .L1991+8
	ldrb	r5, [r3]	@ zero_extendqisi2
	cbz	r5, .L1966
	movs	r5, #1
	movs	r0, #1
	bl	nandc_set_if_mode
.L1966:
	add	r3, r6, r7, lsl #8
	movs	r2, #92
	str	r2, [r3, #2056]
	movs	r2, #197
	str	r2, [r3, #2056]
.L1965:
	mov	r8, #1
	mov	fp, #-1
.L1967:
	ldr	r3, .L1991+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	adds	r3, r3, #1
	cmp	r8, r3
	bcc	.L1976
	mov	r4, fp
.L1975:
	ldr	r3, .L1991+4
	movs	r1, #0
	mov	r0, r10
	ldrb	r3, [r3]	@ zero_extendqisi2
	subs	r3, r3, #67
	cmp	r3, #1
	bhi	.L1977
	bl	sandisk_set_rr_para
.L1978:
	add	r6, r6, r7, lsl #8
	movs	r3, #255
	str	r3, [r6, #2056]
	ldr	r3, .L1991+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r4, r3, asr #2
	bcc	.L1979
	adds	r3, r4, #1
	ldr	r2, [sp, #8]
	it	ne
	movne	r4, #256
	mov	r3, r8
	str	r4, [sp]
	mov	r1, r8
	ldr	r0, .L1991+20
	bl	printf
.L1979:
	bl	nandc_wait_flash_ready
	cbz	r5, .L1964
	movs	r0, #4
	bl	nandc_set_if_mode
.L1964:
	mov	r0, r4
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1982:
	movs	r5, #0
	b	.L1965
.L1976:
	ldr	r3, [sp, #20]
	mov	r0, r10
	uxtb	r1, r8
	ldrb	r3, [r3]	@ zero_extendqisi2
	subs	r3, r3, #67
	cmp	r3, #1
	bhi	.L1968
	bl	sandisk_set_rr_para
.L1969:
	ldr	r3, .L1991+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #34
	bne	.L1970
	ldr	r3, .L1991+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	subs	r3, r3, #3
	cmp	r8, r3
	ittt	eq
	addeq	r3, r6, r7, lsl #8
	moveq	r2, #179
	streq	r2, [r3, #2056]
.L1970:
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
	beq	.L1973
	ldr	r3, .L1991+24
	cmp	fp, #-1
	it	eq
	moveq	fp, r0
	ldr	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L1991+28
	ldr	r3, [r3]
	str	r3, [sp, #16]
	ldr	r3, .L1991+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r0, r3, asr #2
	bcc	.L1975
.L1973:
	add	r8, r8, #1
	b	.L1967
.L1968:
	bl	toshiba_set_rr_para
	b	.L1969
.L1977:
	bl	toshiba_set_rr_para
	b	.L1978
.L1992:
	.align	2
.L1991:
	.word	.LANCHOR13
	.word	.LANCHOR23
	.word	.LANCHOR21
	.word	.LANCHOR159
	.word	.LANCHOR44
	.word	.LC113
	.word	.LANCHOR156
	.word	.LANCHOR158
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
	ldr	r3, .L2007
	str	r2, [sp, #8]
	ldr	r3, [r3]
	add	r10, r3, r0
	ldrb	fp, [r3, #114]	@ zero_extendqisi2
	ldrb	r5, [r10, #120]	@ zero_extendqisi2
	bl	nandc_wait_flash_ready
.L1994:
	cmp	r6, fp
	bcc	.L1999
.L1998:
	ldr	r3, .L2007+4
	strb	r5, [r10, #120]
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r4, r3, asr #2
	bcc	.L2000
	adds	r3, r4, #1
	mov	r2, r8
	it	ne
	movne	r4, #256
	mov	r3, r6
	str	r4, [sp]
	mov	r1, r6
	ldr	r0, .L2007+8
	bl	printf
.L2000:
	bl	nandc_wait_flash_ready
	mov	r0, r4
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1999:
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
	beq	.L1996
	ldr	r3, .L2007+12
	cmp	r4, #-1
	it	eq
	moveq	r4, r0
	ldr	r3, [r3]
	str	r3, [sp, #8]
	ldr	r3, .L2007+16
	ldr	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L2007+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r0, r3, asr #2
	bcc	.L2002
.L1996:
	adds	r6, r6, #1
	b	.L1994
.L2002:
	mov	r4, r0
	b	.L1998
.L2008:
	.align	2
.L2007:
	.word	.LANCHOR27
	.word	.LANCHOR44
	.word	.LC114
	.word	.LANCHOR156
	.word	.LANCHOR158
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
.L2015:
	uxtb	r0, r7
	bl	nandc_set_ddr_para
	ldr	r3, [sp, #64]
	mov	r1, fp
	ldr	r2, [sp, #16]
	mov	r0, r8
	str	r3, [sp]
	ldr	r3, [sp, #20]
	bl	flash_read_page
	ldr	r3, .L2032
	mov	r10, r0
	ldr	r3, [r3]
	lsls	r3, r3, #27
	bpl	.L2010
	mov	r3, r0
	mov	r2, fp
	mov	r1, r7
	ldr	r0, .L2032+4
	bl	printf
.L2010:
	adds	r3, r6, #1
	cmp	r10, r3
	bhi	.L2011
	ldr	r3, .L2032+8
	ldr	r3, [r3]
	str	r3, [sp, #16]
	ldr	r3, .L2032+12
	ldr	r3, [r3]
	str	r3, [sp, #20]
	ldr	r3, .L2032+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r10, r3, lsr #2
	bcs	.L2021
	adds	r5, r5, #1
	cmp	r5, #7
	bls	.L2021
	subs	r4, r7, r5
	mov	r6, r10
	movs	r3, #0
	str	r3, [sp, #8]
.L2013:
	ldr	r3, [sp, #24]
	ldr	r2, [sp, #12]
	cmp	r5, r2
	it	cc
	movcc	r4, r3
.L2014:
	cmp	r4, #0
	beq	.L2016
	ldr	r3, .L2032+16
	ldrb	r2, [r3]	@ zero_extendqisi2
	ldr	r3, .L2032+20
	umull	r2, r3, r2, r3
	ubfx	r3, r3, #1, #8
	cmp	r3, r6
	bls	.L2016
	mov	r1, r4
	ldr	r0, .L2032+24
	bl	printf
	uxtb	r0, r4
.L2031:
	bl	nandc_set_ddr_para
	ldr	r3, [sp, #8]
	cbz	r3, .L2009
	mov	r1, r8
	mov	r2, fp
	ldr	r0, .L2032+28
	bl	printf
	mov	r0, r8
	bl	flash_reset
	movs	r0, #1
	bl	flash_set_interface_mode
	movs	r0, #1
	bl	nandc_set_if_mode
	ldr	r3, .L2032+32
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
	ldr	r0, .L2032+36
	bl	printf
	ldr	r3, .L2032+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r6, r3
	bhi	.L2023
	ldr	r2, .L2032+40
	ldr	r3, [r2]
	adds	r3, r3, #1
	cmp	r3, #100
	str	r3, [r2]
	bls	.L2019
	ldr	r3, .L2032+44
	movs	r2, #0
	strb	r2, [r3]
.L2009:
	mov	r0, r6
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2011:
	ldr	r3, [sp, #12]
	cmp	r5, r3
	bls	.L2022
	cmp	r5, #7
	sub	r3, r4, r5
	str	r3, [sp, #24]
	bhi	.L2014
	str	r5, [sp, #12]
.L2022:
	movs	r5, #0
	b	.L2012
.L2021:
	mov	r4, r7
	mov	r6, r10
	movs	r3, #0
	str	r3, [sp, #8]
.L2012:
	adds	r7, r7, #2
	cmp	r7, #50
	bne	.L2015
	b	.L2013
.L2016:
	ldrb	r0, [sp, #28]	@ zero_extendqisi2
	b	.L2031
.L2023:
	ldr	r6, [sp, #8]
.L2019:
	ldr	r4, .L2032+48
	ldrb	r0, [r4]	@ zero_extendqisi2
	bl	flash_set_interface_mode
	ldrb	r0, [r4]	@ zero_extendqisi2
	bl	nandc_set_if_mode
	b	.L2009
.L2033:
	.align	2
.L2032:
	.word	.LANCHOR14
	.word	.LC115
	.word	.LANCHOR156
	.word	.LANCHOR158
	.word	.LANCHOR44
	.word	-1431655765
	.word	.LC116
	.word	.LC117
	.word	.LANCHOR32
	.word	.LC118
	.word	.LANCHOR160
	.word	.LANCHOR21
	.word	.LANCHOR43
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
	ldr	r3, .L2061
	mov	r7, r2
	mov	r5, r0
	mov	r4, r1
	ldr	r10, [sp, #48]
	ldrb	r2, [r3]	@ zero_extendqisi2
	mov	fp, r3
	cmp	r2, r0
	bhi	.L2035
	mov	r2, #398
	ldr	r1, .L2061+4
	ldr	r0, .L2061+8
	bl	printf
.L2035:
	ldr	r3, .L2061+12
	ldrb	r6, [r3, r5]	@ zero_extendqisi2
	ldrb	r3, [fp]	@ zero_extendqisi2
	cmp	r3, r5
	bcs	.L2036
	ldr	r3, .L2061+16
	ldr	r3, [r3]
	lsls	r0, r3, #25
	bmi	.L2037
.L2060:
	mov	r0, #-1
.L2034:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2037:
	mov	r3, r4
	mov	r2, r5
	mov	r1, r6
	ldr	r0, .L2061+20
	bl	printf
	b	.L2060
.L2036:
	tst	r4, #50331648
	bne	.L2039
	ldr	r3, .L2061+24
	ldrb	r2, [r3]	@ zero_extendqisi2
	ldr	r3, .L2061+28
	cbz	r2, .L2040
	ldrb	r2, [r3]	@ zero_extendqisi2
	cbz	r2, .L2039
.L2040:
	ldr	r2, .L2061+32
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
	cbz	r3, .L2041
	add	r4, fp, r1, lsl #1
.L2039:
	mov	r1, r4
	str	r10, [sp]
	mov	r3, r8
	mov	r2, r7
	mov	r0, r6
	bl	flash_read_page
	adds	r1, r0, #1
	bne	.L2034
	ldr	r5, .L2061+36
	ldrb	fp, [r5]	@ zero_extendqisi2
	cmp	fp, #0
	bne	.L2042
.L2045:
	ldr	r3, .L2061+40
	ldr	fp, [r3]
	cmp	fp, #0
	bne	.L2043
.L2044:
	ldrb	r3, [r5]	@ zero_extendqisi2
	mov	r2, r4
	movs	r1, #0
	ldr	r0, .L2061+44
	str	r3, [sp]
	mov	r3, #-1
	bl	printf
	ldr	r3, .L2061+48
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L2060
	str	r10, [sp, #48]
	mov	r3, r8
	mov	r2, r7
	mov	r1, r4
	mov	r0, r6
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	flash_ddr_tuning_read
.L2041:
	ldr	r3, .L2061+52
	ldrh	r4, [r3, r1, lsl #1]
	add	r4, r4, fp
	b	.L2039
.L2042:
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
	beq	.L2045
	b	.L2034
.L2043:
	mov	r3, r8
	str	r10, [sp]
	mov	r2, r7
	mov	r1, r4
	mov	r0, r6
	blx	fp
	adds	r3, r0, #1
	beq	.L2044
	b	.L2034
.L2062:
	.align	2
.L2061:
	.word	.LANCHOR18
	.word	.LANCHOR161
	.word	.LC0
	.word	.LANCHOR30
	.word	.LANCHOR14
	.word	.LC119
	.word	.LANCHOR0
	.word	.LANCHOR1
	.word	.LANCHOR2
	.word	.LANCHOR46
	.word	.LANCHOR162
	.word	.LC120
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
	ldr	r1, .L2073
	mov	fp, r2
	mov	r10, r3
	str	r0, [sp, #12]
	ldrh	r4, [r1]
	ldr	r1, .L2073+4
	subs	r4, r4, #1
	ldrh	r6, [r1, #26]
	sxth	r4, r4
	ldr	r1, [sp, #48]
	mul	r6, r8, r6
	str	r1, [sp]
	adds	r1, r4, r6
	bl	flash_read_page_en
	cmp	r0, #512
	bne	.L2064
	movs	r7, #0
.L2065:
	cmp	r7, r4
	ble	.L2068
.L2064:
	ldr	r3, .L2073+8
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L2069
	ldr	r3, [r10]
	mov	r2, r4
	mov	r1, r8
	ldr	r0, .L2073+12
	bl	printf
.L2069:
	mov	r0, r4
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2068:
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
	b	.L2065
.L2074:
	.align	2
.L2073:
	.word	.LANCHOR140
	.word	.LANCHOR31
	.word	.LANCHOR14
	.word	.LC121
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
	movs	r5, #1
	ldr	r4, .L2076
	ldrh	r4, [r4]
	str	r3, [sp]
	mov	r3, r2
	mov	r2, r1
	rsb	r4, r4, #21
	lsls	r5, r5, r4
	asr	r4, r0, r4
	subs	r5, r5, #1
	and	r1, r5, r0
	uxtb	r0, r4
	bl	flash_get_last_written_page
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, pc}
.L2077:
	.align	2
.L2076:
	.word	.LANCHOR66
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
	ldr	r6, .L2084
	movs	r5, #1
	mov	r8, r1
	ldr	r4, .L2084+4
	ldr	fp, .L2084+8
	ldr	r10, .L2084+12
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
	bne	.L2079
	ldrb	r2, [r6]	@ zero_extendqisi2
	lsls	r2, r2, #31
	bpl	.L2079
	mov	r0, r5
	bl	flash_set_interface_mode
	mov	r0, r5
	bl	nandc_set_if_mode
	movs	r3, #0
	strb	r3, [r4]
.L2080:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2079:
	movs	r2, #1
	strb	r2, [r3]
	b	.L2080
.L2085:
	.align	2
.L2084:
	.word	.LANCHOR43
	.word	.LANCHOR21
	.word	.LANCHOR163
	.word	.LANCHOR164
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
	ldr	r3, .L2100
	push	{r0, r1, r2, r4, r5, r6, r7, r8, r10, lr}
	ubfx	r4, r0, #21, #3
	mov	r7, r1
	mov	r8, r2
	ubfx	r10, r0, #0, #21
	ubfx	r5, r0, #24, #2
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r4
	bhi	.L2087
	movw	r2, #886
	ldr	r1, .L2100+4
	ldr	r0, .L2100+8
	bl	printf
.L2087:
	ldr	r3, .L2100+12
	ldrb	r6, [r3, r4]	@ zero_extendqisi2
	ldr	r3, .L2100+16
	mov	r0, r6
	ldr	r4, [r3]
	bl	nandc_cs
	cbnz	r5, .L2088
	mov	r0, r10
	bl	slc_phy_page_address_calc
	mov	r10, r0
.L2088:
	ldr	r3, .L2100+20
	uxtb	ip, r10
	lsr	r0, r10, #8
	lsr	r2, r10, #16
	ldr	lr, .L2100+28
	ldrb	r3, [r3, #16]	@ zero_extendqisi2
	cmp	r3, #1
	lsl	r3, r6, #8
	bne	.L2089
	add	r3, r3, r4
	movs	r1, #6
.L2099:
	str	r1, [r3, #2056]
	movs	r1, #0
	str	r1, [r3, #2052]
	str	r1, [r3, #2052]
	str	ip, [r3, #2052]
	str	r0, [r3, #2052]
	str	r2, [r3, #2052]
.L2097:
	movs	r2, #224
	str	r2, [r3, #2056]
	ldr	r3, [lr]
	ldrb	r3, [r3, #12]	@ zero_extendqisi2
	cmp	r3, #3
	bne	.L2092
	cbz	r5, .L2092
	add	r10, r10, r10, lsl #1
	subs	r5, r5, #1
	add	r0, r10, r5
.L2098:
	bl	nandc_set_seed
	ldr	r3, .L2100+24
	movs	r1, #0
	mov	r0, r6
	ldrb	r2, [r3, #9]	@ zero_extendqisi2
	mov	r3, r7
	str	r8, [sp]
	bl	nandc_xfer
	bl	nandc_de_cs.constprop.29
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L2089:
	ldr	r1, [lr]
	add	r3, r3, r4
	ldrb	r1, [r1, #12]	@ zero_extendqisi2
	cmp	r1, #3
	bne	.L2091
	movs	r1, #5
	b	.L2099
.L2091:
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
	b	.L2097
.L2092:
	mov	r0, r10
	b	.L2098
.L2101:
	.align	2
.L2100:
	.word	.LANCHOR18
	.word	.LANCHOR165
	.word	.LC0
	.word	.LANCHOR30
	.word	.LANCHOR13
	.word	.LANCHOR20
	.word	.LANCHOR31
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
	ubfx	r6, r0, #21, #3
	ldr	r3, .L2132
	mov	r7, r0
	mov	r8, r1
	ubfx	r4, r0, #0, #21
	str	r2, [sp, #8]
	ubfx	r5, r0, #24, #2
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r6
	bhi	.L2103
	mov	r2, #1008
	ldr	r1, .L2132+4
	ldr	r0, .L2132+8
	bl	printf
.L2103:
	ldr	r3, .L2132+12
	ldrb	r6, [r3, r6]	@ zero_extendqisi2
	ldr	r3, .L2132+16
	mov	r0, r6
	ldr	fp, [r3]
	bl	nandc_cs
	cbnz	r5, .L2104
	mov	r0, r4
	bl	slc_phy_page_address_calc
	mov	r4, r0
.L2104:
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
	ldr	r3, .L2132+20
	ldr	r3, [r3]
	ldrb	r3, [r3, #12]	@ zero_extendqisi2
	cmp	r3, #3
	bne	.L2105
	cmp	r5, #0
	beq	.L2105
	add	r3, r4, r4, lsl #1
	subs	r0, r5, #1
	add	r0, r0, r3
.L2131:
	bl	nandc_set_seed
	ldr	r10, .L2132+48
	movs	r1, #0
	ldr	r3, [sp, #8]
	mov	r0, r6
	ldrb	r2, [r10, #9]	@ zero_extendqisi2
	str	r3, [sp]
	mov	r3, r8
	bl	nandc_xfer
	adds	r1, r0, #1
	bne	.L2107
	ldr	fp, .L2132+36
	ldrb	r3, [fp]	@ zero_extendqisi2
	str	r3, [sp, #12]
	cmp	r3, #0
	beq	.L2108
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
	cbnz	r5, .L2109
.L2114:
	ldr	r3, .L2132+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2109
	ldr	r3, .L2132+28
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r0, r3, asr #2
	blt	.L2109
	ldrb	r3, [r10, #19]	@ zero_extendqisi2
	subs	r3, r3, #4
	cmp	r3, #4
	it	ls
	movls	r0, #256
.L2102:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2105:
	mov	r0, r4
	b	.L2131
.L2109:
	adds	r2, r0, #1
	bne	.L2102
.L2115:
	ldr	r3, .L2132+32
	ldr	fp, [r3]
	cmp	fp, #0
	bne	.L2111
.L2113:
	ldr	r3, .L2132+36
	mov	r2, r7
	movs	r1, #0
	ldr	r0, .L2132+40
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp]
	mov	r3, #-1
	bl	printf
	ldr	r3, .L2132+44
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L2112
	mov	r0, #-1
	b	.L2102
.L2111:
	ldrb	r3, [r10, #9]	@ zero_extendqisi2
	mov	r2, r8
	orr	r1, r4, r5, lsl #24
	mov	r0, r6
	str	r3, [sp]
	ldr	r3, [sp, #8]
	blx	fp
	adds	r3, r0, #1
	beq	.L2113
	b	.L2102
.L2112:
	ldrb	r3, [r10, #9]	@ zero_extendqisi2
	mov	r2, r8
	orr	r1, r4, r5, lsl #24
	mov	r0, r6
	str	r3, [sp]
	ldr	r3, [sp, #8]
	bl	flash_ddr_tuning_read
	b	.L2102
.L2107:
	cmp	r5, #0
	beq	.L2114
	b	.L2102
.L2108:
	cmp	r5, #0
	bne	.L2115
	b	.L2114
.L2133:
	.align	2
.L2132:
	.word	.LANCHOR18
	.word	.LANCHOR166
	.word	.LC0
	.word	.LANCHOR30
	.word	.LANCHOR13
	.word	.LANCHOR16
	.word	.LANCHOR0
	.word	.LANCHOR44
	.word	.LANCHOR162
	.word	.LANCHOR46
	.word	.LC122
	.word	.LANCHOR21
	.word	.LANCHOR31
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
	ldr	r3, .L2233
	ldrb	r5, [r3]	@ zero_extendqisi2
	cmp	r5, #255
	bne	.L2135
.L2168:
	movs	r6, #0
	b	.L2134
.L2135:
	ldr	r4, .L2233+4
	movs	r3, #48
	mla	r3, r3, r5, r4
	ldrb	r2, [r3, #42]	@ zero_extendqisi2
	ldr	r6, [r3, #24]
	subs	r3, r2, #1
	cmp	r3, #10
	bhi	.L2168
	tbh	[pc, r3, lsl #1]
.L2138:
	.2byte	(.L2137-.L2138)/2
	.2byte	(.L2139-.L2138)/2
	.2byte	(.L2140-.L2138)/2
	.2byte	(.L2140-.L2138)/2
	.2byte	(.L2140-.L2138)/2
	.2byte	(.L2140-.L2138)/2
	.2byte	(.L2141-.L2138)/2
	.2byte	(.L2142-.L2138)/2
	.2byte	(.L2143-.L2138)/2
	.2byte	(.L2140-.L2138)/2
	.2byte	(.L2143-.L2138)/2
	.p2align 1
.L2137:
	movs	r1, #64
	mov	r0, r6
	bl	flash_wait_device_ready
	lsls	r0, r0, #25
	bpl	.L2168
	movs	r3, #48
	mla	r3, r3, r5, r4
	ldr	r2, [r3, #8]
	ldr	r1, [r3, #4]
	cbz	r2, .L2145
	ldrb	r0, [r3, #40]	@ zero_extendqisi2
	ldr	r3, .L2233+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r0, r3
	it	eq
	moveq	r1, r2
.L2145:
	movs	r3, #48
	mov	r0, r6
	mla	r4, r3, r5, r4
	ldr	r2, [r4, #12]
	bl	flash_complete_page_read
	str	r0, [r4, #36]
.L2232:
	movs	r3, #13
	strb	r3, [r4, #42]
	ldrb	r3, [r4, #2]	@ zero_extendqisi2
	orr	r3, r3, #8
	strb	r3, [r4, #2]
	b	.L2168
.L2139:
	movs	r1, #64
	mov	r0, r6
	bl	flash_wait_device_ready
	lsls	r1, r0, #25
	bpl	.L2168
	movs	r3, #48
	mul	r1, r3, r5
	ldrb	r6, [r4, r1]	@ zero_extendqisi2
	adds	r2, r4, r1
	ldr	fp, [r2, #4]
	mla	r3, r3, r6, r4
	ldr	r10, [r3, #4]
	ldr	r3, [r2, #8]
	cbz	r3, .L2146
	ldrb	r1, [r2, #40]	@ zero_extendqisi2
	ldr	r2, .L2233+8
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r1, r2
	it	eq
	moveq	fp, r3
.L2146:
	movs	r3, #48
	mla	r3, r3, r6, r4
	ldr	r2, [r3, #8]
	cbz	r2, .L2147
	ldrb	r1, [r3, #40]	@ zero_extendqisi2
	ldr	r3, .L2233+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r1, r3
	it	eq
	moveq	r10, r2
.L2147:
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
	beq	.L2148
	ldr	r3, [r7, #20]
	adds	r2, r3, #1
	beq	.L2149
	ldr	r2, [r7, #12]
	ldr	r2, [r2, #4]
	cmp	r3, r2
	beq	.L2149
.L2148:
	movs	r7, #48
	ldr	r3, .L2233+8
	mla	r7, r7, r5, r4
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r2, fp
	ldr	r0, [r7, #24]
	str	r3, [sp]
	ldr	r3, [r7, #12]
	bic	r1, r0, #14680064
	ubfx	r0, r0, #21, #3
	bl	flash_read_page_en
	ldr	r2, [r7, #20]
	mov	r8, r0
	adds	r3, r2, #1
	beq	.L2150
	ldr	r3, [r7, #12]
	ldr	r1, [r3, #4]
	cmp	r2, r1
	beq	.L2150
	ldr	r0, .L2233+12
	ldr	r0, [r0]
	lsls	r0, r0, #25
	bpl	.L2150
	str	r1, [sp]
	ldr	r1, [r7, #24]
	ldr	r3, [r3]
	ldr	r0, .L2233+16
	bl	printf
.L2150:
	movs	r3, #48
	mla	r3, r3, r5, r4
	ldr	r2, [r3, #20]
	adds	r0, r2, #1
	beq	.L2149
	ldr	r3, [r3, #12]
	ldr	r3, [r3, #4]
	cmp	r2, r3
	beq	.L2149
	mov	r2, #360
	ldr	r1, .L2233+20
	ldr	r0, .L2233+24
	bl	printf
.L2149:
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
	beq	.L2151
	mla	r3, r3, r6, r4
	ldr	r2, [r3, #20]
	adds	r1, r2, #1
	beq	.L2153
	ldr	r3, [r3, #12]
	ldr	r3, [r3, #4]
	cmp	r2, r3
	beq	.L2153
.L2151:
	movs	r5, #48
	ldr	r3, .L2233+8
	mla	r5, r5, r6, r4
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r2, r10
	ldr	r0, [r5, #24]
	str	r3, [sp]
	ldr	r3, [r5, #12]
	bic	r1, r0, #14680064
	ubfx	r0, r0, #21, #3
	bl	flash_read_page_en
	ldr	r2, [r5, #20]
	adds	r3, r2, #1
	beq	.L2155
	ldr	r3, [r5, #12]
	ldr	r1, [r3, #4]
	cmp	r2, r1
	beq	.L2155
	ldr	r0, .L2233+12
	ldr	r0, [r0]
	lsls	r7, r0, #25
	bpl	.L2155
	str	r1, [sp]
	ldr	r0, .L2233+16
	ldr	r3, [r3]
	ldr	r1, [r5, #24]
	bl	printf
.L2155:
	movs	r3, #48
	mla	r3, r3, r6, r4
	ldr	r2, [r3, #20]
	adds	r0, r2, #1
	beq	.L2153
	ldr	r3, [r3, #12]
	ldr	r3, [r3, #4]
	cmp	r2, r3
	beq	.L2153
	movw	r2, #375
	ldr	r1, .L2233+20
	ldr	r0, .L2233+24
	bl	printf
.L2153:
	movs	r3, #48
	mla	r4, r3, r6, r4
	str	r8, [r4, #36]
	b	.L2232
.L2140:
	movs	r1, #64
	mov	r0, r6
	bl	flash_wait_device_ready
	lsls	r1, r0, #25
	mov	r6, r0
	bpl	.L2168
	ands	r2, r0, #5
	mov	r3, #48
	beq	.L2156
	mla	r4, r3, r5, r4
	movs	r3, #12
	mov	r2, r0
	ldr	r0, .L2233+28
	strb	r3, [r4, #42]
	ldrb	r1, [r4, #1]	@ zero_extendqisi2
	str	r3, [sp]
	ldr	r3, [r4, #24]
	bl	printf
.L2231:
	mov	r3, #-1
	str	r3, [r4, #36]
	b	.L2134
.L2234:
	.align	2
.L2233:
	.word	.LANCHOR54
	.word	.LANCHOR50
	.word	.LANCHOR123
	.word	.LANCHOR14
	.word	.LC123
	.word	.LANCHOR167
	.word	.LC0
	.word	.LC124
.L2156:
	mla	r6, r3, r5, r4
	movs	r3, #13
	strb	r3, [r6, #42]
	ldr	r3, .L2235
	str	r2, [r6, #36]
	ldr	r3, [r3]
	ldr	r2, [r3, #156]
	ldr	r3, .L2235+4
	cmp	r2, r3
	bne	.L2168
	ldrh	r3, [r6, #34]
	cmp	r3, #0
	bne	.L2168
	ldr	r3, .L2235+8
	ldr	r0, [r6, #24]
	ldr	r7, .L2235+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldr	r2, .L2235+16
	bic	r1, r0, #14680064
	ubfx	r0, r0, #21, #3
	str	r3, [sp]
	ldr	r3, [r7]
	ldr	r2, [r2]
	bl	flash_read_page_en
	adds	r2, r0, #1
	mov	r3, r0
	beq	.L2157
	ldr	r1, [r6, #12]
	ldr	r2, [r7]
	ldr	r1, [r1]
	ldr	r2, [r2]
	cmp	r1, r2
	beq	.L2168
.L2157:
	movs	r2, #48
	ldr	r0, .L2235+20
	mla	r4, r2, r5, r4
	ldr	r2, .L2235+24
	ldrb	r2, [r2]	@ zero_extendqisi2
	ldrb	r1, [r4, #1]	@ zero_extendqisi2
	str	r2, [sp]
	ldr	r2, [r4, #24]
	bl	printf
	mov	r3, #-1
	str	r3, [r4, #36]
	b	.L2168
.L2143:
	add	r3, r5, r5, lsl #1
	cmp	r2, #11
	it	eq
	moveq	r1, #10
	add	r3, r4, r3, lsl #4
	it	ne
	movne	r1, #3
	ubfx	r0, r6, #21, #3
	movs	r7, #48
.L2159:
	ldrb	r8, [r3]	@ zero_extendqisi2
	cmp	r8, #255
	bne	.L2166
	mov	r6, #-1
	b	.L2134
.L2166:
	mla	r2, r7, r8, r4
	add	r3, r8, r8, lsl #1
	ldrb	ip, [r2, #42]	@ zero_extendqisi2
	add	r3, r4, r3, lsl #4
	cmp	ip, r1
	bne	.L2159
	ldr	r2, [r2, #24]
	ubfx	r2, r2, #21, #3
	cmp	r0, r2
	bne	.L2159
	mov	r0, r6
	movs	r1, #64
	bl	flash_wait_device_ready
	mov	r6, r0
	lsls	r0, r6, #25
	bmi	.L2161
.L2230:
	movs	r6, #0
	b	.L2162
.L2161:
	ands	r2, r6, #15
	mul	r3, r7, r5
	beq	.L2163
	adds	r7, r4, r3
	mov	r10, #12
	ldrb	r1, [r7, #1]	@ zero_extendqisi2
	mov	r2, r6
	str	r10, [sp]
	ldr	r3, [r7, #24]
	ldr	r0, .L2235+28
	bl	printf
	mov	r3, #-1
	strb	r10, [r7, #42]
	str	r3, [r7, #36]
.L2162:
	movs	r3, #48
	mla	r5, r3, r5, r4
	mla	r8, r3, r8, r4
	ldrb	r2, [r5, #42]	@ zero_extendqisi2
	ldr	r3, [r5, #36]
	strb	r2, [r8, #42]
	str	r3, [r8, #36]
.L2134:
	mov	r0, r6
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2163:
	adds	r6, r4, r3
	movs	r3, #13
	strb	r3, [r6, #42]
	ldr	r3, .L2235
	str	r2, [r6, #36]
	ldr	r3, [r3]
	ldr	r2, [r3, #156]
	ldr	r3, .L2235+4
	cmp	r2, r3
	bne	.L2230
	ldrh	r3, [r6, #34]
	cmp	r3, #0
	bne	.L2230
	ldr	r3, .L2235+8
	ldr	r0, [r6, #24]
	ldr	r7, .L2235+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldr	r2, .L2235+16
	bic	r1, r0, #14680064
	ubfx	r0, r0, #21, #3
	str	r3, [sp]
	ldr	r3, [r7]
	ldr	r2, [r2]
	bl	flash_read_page_en
	adds	r1, r0, #1
	mov	r3, r0
	beq	.L2165
	ldr	r1, [r6, #12]
	ldr	r2, [r7]
	ldr	r1, [r1]
	ldr	r2, [r2]
	cmp	r1, r2
	beq	.L2230
.L2165:
	ldr	r2, .L2235+24
	movs	r6, #48
	mla	r6, r6, r5, r4
	ldr	r0, .L2235+32
	ldrb	r2, [r2]	@ zero_extendqisi2
	ldrb	r1, [r6, #1]	@ zero_extendqisi2
	str	r2, [sp]
	ldr	r2, [r6, #24]
	bl	printf
	mov	r3, #-1
	str	r3, [r6, #36]
	b	.L2230
.L2141:
	mov	r0, r6
	movs	r1, #32
	bl	flash_wait_device_ready
	lsls	r2, r0, #26
	mov	r6, r0
	bpl	.L2168
	ands	r2, r0, #15
	mov	r3, #48
	mla	r4, r3, r5, r4
	beq	.L2167
	movs	r3, #12
	strb	r3, [r4, #42]
	b	.L2231
.L2167:
	movs	r3, #13
	str	r2, [r4, #36]
	strb	r3, [r4, #42]
	b	.L2168
.L2142:
	movs	r1, #64
	mov	r0, r6
	bl	flash_wait_device_ready
	lsls	r3, r0, #25
	bpl	.L2168
	movs	r3, #48
	mla	r4, r3, r5, r4
	movs	r3, #7
	str	r0, [r4, #36]
	strb	r3, [r4, #42]
	b	.L2168
.L2236:
	.align	2
.L2235:
	.word	.LANCHOR102
	.word	1145785929
	.word	.LANCHOR123
	.word	.LANCHOR163
	.word	.LANCHOR164
	.word	.LC125
	.word	.LANCHOR46
	.word	.LC126
	.word	.LC127
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
	ldr	r4, .L2240
.L2238:
	ldrb	r3, [r4]	@ zero_extendqisi2
	cmp	r3, #255
	bne	.L2239
	pop	{r4, pc}
.L2239:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2238
.L2241:
	.align	2
.L2240:
	.word	.LANCHOR54
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
	push	{r0, r1, r2, r4, r5, r6, r7, lr}
	mov	r4, r0
	mov	r5, r1
	mov	r6, r2
	mov	r7, r3
	bl	sblk_wait_write_queue_completed
	str	r7, [sp]
	mov	r3, r6
	mov	r2, r5
	mov	r1, r4
	ubfx	r0, r4, #21, #3
	bl	flash_read_page_en
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, pc}
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
	mov	r8, r0
	ldr	r7, .L2269
	sub	sp, sp, #24
	mov	r6, r1
	mov	r4, r0
	mov	r5, r1
.L2245:
	cbnz	r5, .L2255
.L2268:
	ldr	r4, .L2269
.L2256:
	cmp	r6, #0
	bne	.L2258
	mov	r0, r6
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2255:
	ldr	fp, [r4, #24]
	ldrb	r3, [r4]	@ zero_extendqisi2
	str	r3, [sp, #8]
.L2246:
	movs	r1, #0
	mov	r0, fp
	bl	queue_lun_state
	cbnz	r0, .L2247
	cmp	r5, #1
	beq	.L2252
	ldr	r3, .L2269+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L2249
.L2252:
	mov	r0, r4
	bl	queue_read_cmd
	b	.L2250
.L2247:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2246
.L2249:
	ldrb	r2, [r4]	@ zero_extendqisi2
	ubfx	r3, fp, #21, #3
	cmp	r2, #255
	bne	.L2251
	movw	r2, #661
	ldr	r1, .L2269+8
	ldr	r0, .L2269+12
	str	r3, [sp, #4]
	bl	printf
	ldr	r3, [sp, #4]
.L2251:
	ldrb	r2, [r4]	@ zero_extendqisi2
	str	r2, [sp, #12]
	movs	r2, #48
	ldr	r1, [sp, #12]
	muls	r2, r1, r2
	add	r10, r7, r2
	str	r2, [sp, #4]
	ldr	r1, [r10, #24]
	ubfx	r2, r1, #21, #3
	cmp	r3, r2
	bne	.L2252
	ldr	r3, .L2269+16
	ldrh	r3, [r3]
	add	fp, fp, r3
	cmp	r1, fp
	bne	.L2252
	ldr	r3, [sp, #4]
	mov	fp, #255
	ldr	r0, [r4, #24]
	subs	r5, r5, #1
	ldrb	r3, [r7, r3]	@ zero_extendqisi2
	str	r3, [sp, #8]
	bl	flash_start_plane_read
	movs	r2, #2
	movs	r3, #0
	strb	r2, [r4, #42]
	mov	r1, r4
	strb	r3, [r4, #43]
	ldr	r0, .L2269+20
	strb	fp, [r4]
	str	r2, [sp, #20]
	str	r3, [sp, #16]
	bl	buf_add_tail
	ldr	r3, [sp, #16]
	ldr	r2, [sp, #20]
	ldr	r0, .L2269+20
	strb	r3, [r10, #43]
	ldr	r3, [sp, #4]
	strb	r2, [r10, #42]
	strb	fp, [r7, r3]
	ldr	r3, [sp, #12]
	add	r1, r3, r3, lsl #1
	add	r1, r7, r1, lsl #4
	bl	buf_add_tail
.L2250:
	subs	r5, r5, #1
	beq	.L2268
	ldr	r3, [sp, #8]
	add	r4, r3, r3, lsl #1
	add	r4, r7, r4, lsl #4
	b	.L2245
.L2258:
	ldrb	r3, [r8, #42]	@ zero_extendqisi2
	cmp	r3, #13
	bne	.L2257
	ldrb	r3, [r8]	@ zero_extendqisi2
	subs	r6, r6, #1
	cmp	r3, #255
	itt	ne
	addne	r3, r3, r3, lsl #1
	addne	r8, r4, r3, lsl #4
.L2257:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2256
.L2270:
	.align	2
.L2269:
	.word	.LANCHOR50
	.word	.LANCHOR168
	.word	.LANCHOR169
	.word	.LC0
	.word	.LANCHOR103
	.word	.LANCHOR54
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
	ldr	r3, .L2282
	mov	r5, r0
	mov	r6, r1
	mov	r10, r2
	ubfx	r7, r1, #0, #21
	ubfx	r8, r1, #24, #2
	ldr	r4, [r3]
	add	r3, r0, #8
	add	r3, r4, r3, lsl #8
	str	r3, [sp, #4]
	ldr	r3, .L2282+4
	ldr	r3, [r3]
	lsls	r3, r3, #27
	bpl	.L2272
	ldr	r3, [sp, #40]
	mov	r2, r8
	ldr	r0, .L2282+8
	bl	printf
.L2272:
	bl	nandc_wait_flash_ready
	mov	r0, r5
	bl	hynix_reconfig_rr_para
	mov	r0, r5
	bl	nandc_cs
	mov	r0, r5
	cmp	r8, #0
	bne	.L2273
	bl	zftl_flash_enter_slc_mode
.L2274:
	add	r4, r4, r5, lsl #8
	movs	r3, #128
	mov	r0, r7
	str	r3, [r4, #2056]
	movs	r3, #0
	str	r3, [r4, #2052]
	str	r3, [r4, #2052]
	uxtb	r3, r6
	str	r3, [r4, #2052]
	lsrs	r3, r7, #8
	str	r3, [r4, #2052]
	lsrs	r3, r7, #16
	str	r3, [r4, #2052]
	bl	nandc_set_seed
	ldr	r1, .L2282+12
	mov	r2, r10
	mov	r3, fp
	movs	r0, #1
	ldrb	r1, [r1, #9]	@ zero_extendqisi2
	bl	nandc_xfer_start
	bl	nandc_xfer_done
	movs	r3, #16
	str	r3, [r4, #2056]
	bl	nandc_wait_flash_ready
	ldr	r0, [sp, #4]
	bl	flash_read_status
	bl	nandc_de_cs.constprop.29
	ands	r4, r0, #4
	beq	.L2271
	mov	r2, r4
	mov	r1, r6
	ldr	r0, .L2282+16
	bl	printf
.L2271:
	mov	r0, r4
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2273:
	bl	zftl_flash_exit_slc_mode
	b	.L2274
.L2283:
	.align	2
.L2282:
	.word	.LANCHOR13
	.word	.LANCHOR14
	.word	.LC128
	.word	.LANCHOR31
	.word	.LC129
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
	ldr	r7, .L2294
	mov	r6, r0
	mov	r4, r1
	movs	r1, #165
	ldr	r5, .L2294+4
	ldr	r0, [r7]
	bl	ftl_memset
	movs	r2, #8
	movs	r1, #90
	ldr	r0, [r5]
	bl	ftl_memset
	ldr	r3, .L2294+8
	mov	r0, r6
	ldrh	r3, [r3]
	muls	r4, r3, r4
	mov	r1, r4
	bl	flash_erase_block
	adds	r0, r0, #1
	bne	.L2285
.L2287:
	mov	r5, #-1
.L2286:
	mov	r1, r4
	mov	r0, r6
	bl	flash_erase_block
	mov	r0, r5
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L2285:
	ldr	r8, .L2294+12
	mov	r1, r4
	mov	r0, r6
	ldrb	r3, [r8, #9]	@ zero_extendqisi2
	str	r3, [sp]
	ldr	r2, [r7]
	ldr	r3, [r5]
	bl	flash_prog_page
	adds	r0, r0, #1
	beq	.L2287
	ldrb	r3, [r8, #9]	@ zero_extendqisi2
	mov	r1, r4
	mov	r0, r6
	str	r3, [sp]
	ldr	r2, [r7]
	ldr	r3, [r5]
	bl	flash_read_page
	adds	r0, r0, #1
	beq	.L2287
	ldr	r3, [r7]
	ldr	r3, [r3]
	cmp	r3, #-1515870811
	bne	.L2287
	ldr	r3, [r5]
	ldr	r5, [r3]
	subs	r5, r5, #1515870810
	it	ne
	movne	r5, #-1
	b	.L2286
.L2295:
	.align	2
.L2294:
	.word	.LANCHOR156
	.word	.LANCHOR158
	.word	.LANCHOR2
	.word	.LANCHOR31
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
	ldr	r3, .L2303
	push	{r0, r1, r2, r4, r5, r6, r7, r8, r10, lr}
	mov	r6, r0
	mov	r7, r1
	mov	r4, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L2296
	ldr	r5, .L2303+4
	ldrb	r2, [r5, #19]	@ zero_extendqisi2
	subs	r3, r2, #5
	uxtb	r3, r3
	cmp	r3, #30
	bhi	.L2298
	ldr	r2, .L2303+8
	lsr	r3, r2, r3
	lsls	r3, r3, #31
	bmi	.L2300
.L2296:
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L2301:
	ldrh	r2, [r10, r4, lsl #1]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L2296
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
.L2302:
	ldrh	r3, [r5, #10]
	cmp	r3, r4
	bhi	.L2301
	b	.L2296
.L2298:
	cmp	r2, #68
	bne	.L2296
.L2300:
	ldr	r10, .L2303+12
	ldr	r8, .L2303+16
	b	.L2302
.L2304:
	.align	2
.L2303:
	.word	.LANCHOR19
	.word	.LANCHOR31
	.word	1073758215
	.word	.LANCHOR138
	.word	.LANCHOR156
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
	ldr	r3, .L2319
	mov	r4, r0
	mov	r6, r1
	ubfx	r5, r1, #0, #21
	str	r2, [sp, #8]
	ubfx	r8, r1, #24, #2
	ldr	r7, [r3]
	add	r3, r0, #8
	add	r3, r7, r3, lsl #8
	str	r3, [sp, #4]
	ldr	r3, .L2319+4
	ldr	r2, [r3]
	str	r3, [sp, #12]
	tst	r2, #16
	beq	.L2306
	ldr	r3, [sp, #56]
	mov	r2, r8
	ldr	r0, .L2319+8
	bl	printf
.L2306:
	bl	nandc_wait_flash_ready
	mov	r0, r4
	bl	nandc_cs
	mov	r0, r4
	cmp	r8, #0
	bne	.L2307
	bl	zftl_flash_enter_slc_mode
.L2308:
	add	r4, r7, r4, lsl #8
	uxtb	r3, r6
	ldr	r8, .L2319+16
	movs	r7, #0
	mov	r10, #128
	str	r10, [r4, #2056]
	mov	r0, r5
	str	r7, [r4, #2052]
	str	r7, [r4, #2052]
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
	mov	fp, #16
	bl	nandc_xfer_start
	bl	nandc_xfer_done
	str	fp, [r4, #2056]
	bl	nandc_wait_flash_ready
	adds	r0, r5, #1
	str	r10, [r4, #2056]
	uxtb	r3, r0
	str	r7, [r4, #2052]
	str	r7, [r4, #2052]
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
	bl	nandc_de_cs.constprop.29
	ands	r4, r0, #4
	beq	.L2305
	ldr	r3, [sp, #12]
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L2305
	mov	r2, r4
	mov	r1, r6
	ldr	r0, .L2319+12
	bl	printf
.L2305:
	mov	r0, r4
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2307:
	bl	zftl_flash_exit_slc_mode
	b	.L2308
.L2320:
	.align	2
.L2319:
	.word	.LANCHOR13
	.word	.LANCHOR14
	.word	.LC128
	.word	.LC129
	.word	.LANCHOR31
	.size	flash_dual_page_prog, .-flash_dual_page_prog
	.section	.text.fw_flash_page_prog.constprop.26,"ax",%progbits
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	fw_flash_page_prog.constprop.26, %function
fw_flash_page_prog.constprop.26:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, lr}
	mov	r5, r1
	ldr	r7, .L2325
	mov	r6, r2
	ldrb	r1, [r7, #9]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	ldr	r3, .L2325+4
	mov	r4, r0
	ldrb	r8, [r3]	@ zero_extendqisi2
	ldr	r3, .L2325+8
	ldrb	r0, [r3]	@ zero_extendqisi2
	bl	nandc_bch_sel
	ldrb	r3, [r7, #7]	@ zero_extendqisi2
	cmp	r3, #9
	bne	.L2322
	ldr	r7, .L2325+12
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
.L2324:
	mov	r4, r0
	mov	r0, r8
	bl	nandc_bch_sel
	mov	r0, r4
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L2322:
	movs	r3, #4
	mov	r2, r5
	str	r3, [sp]
	mov	r1, r4
	mov	r3, r6
	movs	r0, #0
	bl	flash_prog_page
	b	.L2324
.L2326:
	.align	2
.L2325:
	.word	.LANCHOR31
	.word	.LANCHOR44
	.word	.LANCHOR17
	.word	.LANCHOR156
	.size	fw_flash_page_prog.constprop.26, .-fw_flash_page_prog.constprop.26
	.section	.text.idb_write_data,"ax",%progbits
	.align	1
	.global	idb_write_data
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	idb_write_data, %function
idb_write_data:
	@ args = 0, pretend = 0, frame = 136
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r8, r3
	ldr	r5, .L2444
	adds	r3, r1, r3
	cmp	r3, #63
	sub	sp, sp, #144
	mov	r4, r1
	mov	r7, r2
	ldr	r6, [r5]
	bls	.L2328
	cmp	r1, #576
	bcs	.L2329
	cbnz	r6, .L2330
	mov	r0, #262144
	bl	ftl_malloc
	str	r0, [r5]
	cbnz	r0, .L2331
.L2336:
	mov	r0, #-1
.L2327:
	add	sp, sp, #144
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2331:
	mov	r2, #262144
	mov	r1, r6
	bl	ftl_memset
.L2330:
	ldr	r6, .L2444+4
	ldr	r3, [r6]
	cbz	r3, .L2333
.L2337:
	ldr	r3, .L2444+8
	cmp	r4, #64
	mov	r2, #1
	ldr	r0, [r5]
	str	r2, [r3]
	bhi	.L2438
	rsb	r1, r4, #64
	sub	r2, r8, r1
	add	r1, r7, r1, lsl #9
	lsls	r2, r2, #9
.L2443:
	bl	ftl_memcpy
.L2338:
	movs	r0, #0
	b	.L2327
.L2333:
	mov	r0, #262144
	bl	ftl_malloc
	str	r0, [r6]
	cmp	r0, #0
	bne	.L2337
	b	.L2336
.L2438:
	rsb	r2, r4, #576
	subs	r4, r4, #64
	cmp	r2, r8
	mov	r1, r7
	it	cs
	movcs	r2, r8
	add	r0, r0, r4, lsl #9
	lsls	r2, r2, #9
	b	.L2443
.L2328:
	cmp	r1, #576
	bcc	.L2338
.L2329:
	ldr	r3, .L2444+8
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L2338
	ldr	r7, .L2444+12
	ldr	r2, .L2444+16
	ldr	r10, .L2444+32
	ldrb	r3, [r7]	@ zero_extendqisi2
	ldrb	r4, [r2, #9]	@ zero_extendqisi2
	mov	r8, r2
	ldrh	r5, [r2, #26]
	str	r3, [sp, #20]
	cmp	r3, #0
	beq	.L2390
	ldrb	r3, [r10]	@ zero_extendqisi2
	clz	r3, r3
	lsrs	r3, r3, #5
.L2440:
	movs	r0, #0
	str	r3, [sp, #28]
	bl	zftl_flash_exit_slc_mode
	ldrb	r3, [r10]	@ zero_extendqisi2
	strb	r3, [r7]
	ldr	r3, .L2444+20
	ldr	r2, [r6]
	cmp	r2, r3
	bne	.L2341
	ldrh	r0, [r8, #10]
	ldrb	r1, [r8, #12]	@ zero_extendqisi2
	lsls	r0, r0, #2
	bl	__aeabi_idiv
	cmp	r0, #512
	mov	r3, r0
	it	ge
	movge	r3, #512
	add	r1, r6, #260096
	str	r3, [sp, #32]
	movw	r2, #65023
	movs	r3, #0
.L2345:
	ldr	r0, [r1, #-4]!
	cbnz	r0, .L2343
	ldr	r0, [r6, r3, lsl #2]
	adds	r3, r3, #1
	cmp	r3, #4096
	add	r2, r2, #-1
	it	hi
	movhi	r3, #0
	cmp	r2, #4096
	str	r0, [r1, #2048]
	bne	.L2345
.L2343:
	smulbb	r4, r4, r5
	ldr	r3, [sp, #32]
	ldr	r1, [r6, r2, lsl #2]
	ldr	r0, .L2444+24
	bl	printf
	uxth	r3, r4
	str	r3, [sp, #68]
	movs	r3, #0
	str	r3, [sp, #12]
	str	r3, [sp, #24]
.L2386:
	ldr	r3, .L2444+4
	mov	r2, #512
	movs	r1, #0
	ldr	r0, [r3]
	bl	ftl_memset
	ldr	r3, .L2444+28
	ldr	r2, [sp, #24]
	ldr	r3, [r3]
	add	r3, r3, r2
	ldrb	r3, [r3, #32]	@ zero_extendqisi2
	cmp	r3, #255
	beq	.L2346
	ldr	r2, [sp, #68]
	mul	r10, r2, r3
	ldr	r3, [sp, #28]
	cbz	r3, .L2347
	ldr	r3, [sp, #24]
	ldr	r5, .L2444+12
	ldr	r4, .L2444+32
	cmp	r3, #1
	bne	.L2348
	ldrb	r3, [sp, #20]	@ zero_extendqisi2
.L2441:
	strb	r3, [r5]
	strb	r3, [r4]
.L2347:
	ldr	r8, .L2444+16
	movs	r5, #0
	ldr	r3, .L2444+36
	mov	r0, r10
	ldrb	r7, [r8, #9]	@ zero_extendqisi2
	ldrh	r4, [r8, #26]
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r1, r7
	str	r3, [sp, #72]
	smulbb	r4, r4, r7
	ldr	r3, .L2444+36
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
	str	r1, [sp, #40]
	ldrb	r1, [r8, #12]	@ zero_extendqisi2
	str	r3, [sp, #36]
	lsls	r0, r0, #2
	bl	__aeabi_idiv
	ldr	r3, [sp, #36]
	str	r0, [sp, #44]
	cmp	r10, r3
	bne	.L2393
	ldr	r3, .L2444+40
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #9
	bne	.L2393
	ldr	r3, .L2444+4
	mov	r2, #1024
	mov	r1, r5
	ldr	r4, [r3]
	mov	r0, r4
	bl	ftl_memset
	ldr	r2, .L2444+44
	movs	r3, #12
	str	r5, [r4, #12]
	strb	r5, [r4, #16]
	stm	r4, {r2, r3}
	ldr	r3, .L2444+32
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2350
	ldrb	r3, [r8, #29]	@ zero_extendqisi2
	strb	r3, [r4, #16]
.L2350:
	movs	r3, #4
	strb	r3, [r4, #17]
	ldr	r3, .L2444+16
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
	ldr	r3, [sp, #32]
	str	r0, [r4, #8]
	subs	r3, r3, #4
	str	r3, [sp, #16]
.L2349:
	mov	r8, r6
	mov	fp, #0
.L2352:
	ldr	r3, [sp, #44]
	cmp	r3, fp
	bhi	.L2363
	ldr	r3, .L2444+4
	movs	r4, #0
	mov	r0, r10
	movs	r7, #4
	ldr	r5, [r3]
	ldr	r3, .L2444+16
	ldrb	r2, [r3, #9]	@ zero_extendqisi2
	ldrh	r1, [r3, #26]
	str	r2, [sp, #60]
	ldrh	r3, [sp, #60]
	smulbb	r1, r1, r3
	ldr	r3, .L2444+36
	uxth	r1, r1
	strb	r4, [r3]
	bl	__aeabi_uidivmod
	sub	r3, r10, r1
	str	r1, [sp, #36]
	str	r3, [sp, #64]
	and	r3, r1, #3
	str	r3, [sp, #40]
	ldr	r3, [sp, #16]
	str	r4, [sp, #48]
	str	r3, [sp, #52]
.L2364:
	ldr	r3, [sp, #52]
	cmp	r4, r3
	bcc	.L2380
	ldr	r3, .L2444+36
	ldrb	r2, [sp, #72]	@ zero_extendqisi2
	strb	r2, [r3]
	ldr	r3, [sp, #28]
	cbz	r3, .L2381
	movs	r0, #0
	bl	zftl_flash_exit_slc_mode
	ldr	r2, .L2444+12
	movs	r3, #0
	strb	r3, [r2]
	ldr	r2, .L2444+32
	strb	r3, [r2]
.L2381:
	ldr	r3, [sp, #16]
	movs	r4, #0
	lsls	r1, r3, #7
	ldr	r3, .L2444+4
	ldr	r0, [r3]
.L2382:
	cmp	r4, r1
	bne	.L2384
	ldr	r3, [sp, #12]
	adds	r3, r3, #1
	cmp	r3, #5
	str	r3, [sp, #12]
	bls	.L2346
	b	.L2389
.L2390:
	ldr	r3, [sp, #20]
	b	.L2440
.L2348:
	movs	r0, #0
	bl	zftl_flash_exit_slc_mode
	movs	r3, #0
	b	.L2441
.L2393:
	ldr	r3, [sp, #32]
	mov	r4, r5
	str	r3, [sp, #16]
	b	.L2349
.L2445:
	.align	2
.L2444:
	.word	.LANCHOR135
	.word	.LANCHOR137
	.word	.LANCHOR136
	.word	.LANCHOR0
	.word	.LANCHOR31
	.word	-52655045
	.word	.LC130
	.word	.LANCHOR27
	.word	.LANCHOR19
	.word	.LANCHOR46
	.word	.LANCHOR28
	.word	1179535694
.L2363:
	ldr	r3, [sp, #40]
	add	r5, r3, fp
	ldr	r3, .L2446
	lsrs	r5, r5, #2
	adds	r2, r5, #1
	ldrh	r0, [r3, r2, lsl #1]
	ldr	r3, .L2446+4
	ldrb	r1, [r3]	@ zero_extendqisi2
	cmp	r1, #0
	bne	.L2353
	mov	r2, r0
.L2354:
	ldr	r0, .L2446+8
	ldr	r3, .L2446
	ldrb	r0, [r0]	@ zero_extendqisi2
	cmp	r0, #9
	itt	ne
	addne	r2, r2, #-1
	lslne	r2, r2, #2
	str	r2, [sp, #80]
	movw	r2, #61424
	str	r2, [sp, #84]
	ldrh	r2, [r3, r5, lsl #1]
	cbnz	r1, .L2358
	mov	r5, r2
.L2359:
	mul	r0, r5, r7
	add	r2, sp, #80
	cbnz	r4, .L2360
	ldr	r3, [sp, #36]
	mov	r1, r8
	add	r0, r0, r3
	bl	fw_flash_page_prog.constprop.26
	ldr	r3, .L2446+4
	ldrb	r2, [r3]	@ zero_extendqisi2
	cbnz	r2, .L2361
	adds	r5, r5, #1
	mov	r1, r7
	uxth	r5, r5
	ldr	r0, [sp, #36]
	bl	__aeabi_uidiv
	mov	r2, r5
	mov	r1, r0
	mov	r0, r4
	bl	id_block_prog_msb_ff_data
.L2361:
	ldr	r3, [sp, #16]
	add	r8, r8, #2048
	add	r2, r3, #16
	cmp	fp, r2
	bcc	.L2362
	add	r2, r3, #20
	cmp	fp, r2
	bcs	.L2362
	add	r8, r6, #2048
.L2362:
	add	r3, fp, #4
	movs	r4, #0
	uxth	fp, r3
	b	.L2352
.L2353:
	ldr	r0, .L2446+12
	ldrb	r0, [r0]	@ zero_extendqisi2
	cmp	r0, #0
	beq	.L2354
	lsls	r2, r2, #1
	b	.L2354
.L2358:
	ldr	r2, .L2446+12
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, #0
	beq	.L2359
	lsls	r5, r5, #1
	b	.L2359
.L2360:
	ldr	r3, [sp, #36]
	mov	r1, r4
	add	r0, r0, r3
	bl	fw_flash_page_prog.constprop.26
	b	.L2362
.L2380:
	ldr	r3, [sp, #40]
	mov	r1, r7
	subs	r3, r7, r3
	uxth	r3, r3
	str	r3, [sp, #44]
	ldr	r3, [sp, #36]
	adds	r0, r3, r4
	bl	__aeabi_uidiv
	ldr	r2, .L2446+4
	uxth	r0, r0
	ldr	r3, .L2446
	ldrb	r2, [r2]	@ zero_extendqisi2
	ldrh	r3, [r3, r0, lsl #1]
	cmp	r2, #0
	bne	.L2365
	mov	r0, r3
.L2366:
	ldr	r3, .L2446+16
	ldr	r2, [sp, #64]
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp, #56]
	ldr	r3, [sp, #40]
	add	r3, r3, r2
	ldr	r2, .L2446+20
	ldrb	r1, [r2, #9]	@ zero_extendqisi2
	ldr	r2, [sp, #60]
	mla	r0, r0, r2, r3
	bl	__aeabi_uidiv
	ldr	r3, .L2446+24
	mov	r8, r0
	ldr	r0, [sp, #56]
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp, #76]
	bl	nandc_bch_sel
.L2367:
	str	r7, [sp]
	add	r3, sp, #80
	mov	r2, r5
	mov	r1, r8
	movs	r0, #0
	bl	flash_read_page
	adds	r0, r0, #1
	bne	.L2368
	ldr	r3, .L2446+28
	ldrb	fp, [r3]	@ zero_extendqisi2
	cmp	fp, #0
	bne	.L2369
.L2372:
	ldr	r3, .L2446+32
	ldr	fp, [r3]
	cmp	fp, #0
	bne	.L2370
.L2371:
	ldr	r3, .L2446+36
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2374
	str	r7, [sp]
	add	r3, sp, #80
	mov	r2, r5
	mov	r1, r8
	movs	r0, #0
	bl	flash_ddr_tuning_read
	adds	r0, r0, #1
	bne	.L2368
.L2374:
	ldr	r3, [sp, #56]
	cmp	r3, #16
	bne	.L2375
	mov	r8, #-1
.L2376:
	ldr	r0, [sp, #76]
	bl	nandc_bch_sel
	ldr	r3, [sp, #48]
	cmp	r8, #0
	it	ne
	movne	r3, #-1
	str	r3, [sp, #48]
	ldr	r3, [sp, #64]
	cmp	r10, r3
	bne	.L2378
	cmp	r4, #0
	bne	.L2378
	ldr	r3, [sp, #48]
	cmp	r3, #0
	bne	.L2378
	ldr	r2, [r5]
	ldr	r3, .L2446+40
	cmp	r2, r3
	bne	.L2378
	ldr	r3, [sp, #52]
	ldr	r2, [sp, #44]
	ldrb	r7, [r5, #17]	@ zero_extendqisi2
	add	r3, r3, r2
	str	r3, [sp, #52]
.L2379:
	ldr	r3, [sp, #44]
	add	r3, r3, r4
	uxth	r4, r3
	b	.L2364
.L2365:
	ldr	r3, .L2446+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L2366
	lsls	r0, r0, #1
	b	.L2366
.L2369:
	ldr	r3, .L2446+28
	movs	r0, #0
	mov	r2, r5
	mov	r1, r8
	strb	r0, [r3]
	add	r3, sp, #80
	str	r7, [sp]
	bl	flash_read_page
	ldr	r3, .L2446+28
	adds	r0, r0, #1
	strb	fp, [r3]
	beq	.L2372
.L2368:
	mov	r8, #0
	b	.L2376
.L2370:
	str	r7, [sp]
	add	r3, sp, #80
	mov	r2, r5
	mov	r1, r8
	movs	r0, #0
	blx	fp
	adds	r0, r0, #1
	beq	.L2371
	b	.L2368
.L2375:
	movs	r0, #16
	bl	nandc_bch_sel
	movs	r3, #16
	str	r3, [sp, #56]
	b	.L2367
.L2378:
	ldr	r3, [sp, #44]
	add	r5, r5, r3, lsl #9
	movs	r3, #0
	str	r3, [sp, #40]
	b	.L2379
.L2384:
	ldr	r2, [r0, r4, lsl #2]
	ldr	r3, [r6, r4, lsl #2]
	cmp	r2, r3
	beq	.L2383
	mov	r2, #512
	movs	r1, #0
	bl	ftl_memset
	mov	r1, r4
	ldr	r0, .L2446+44
	bl	printf
	mov	r1, r10
	movs	r0, #0
	bl	flash_erase_block
.L2346:
	ldr	r3, [sp, #24]
	adds	r3, r3, #1
	cmp	r3, #4
	str	r3, [sp, #24]
	bne	.L2386
.L2389:
	ldrb	r2, [sp, #20]	@ zero_extendqisi2
	movs	r0, #0
	ldr	r3, .L2446+48
	strb	r2, [r3]
	movs	r2, #2
	ldr	r3, .L2446+52
	strb	r2, [r3]
	bl	zftl_flash_enter_slc_mode
	ldr	r3, [sp, #12]
	cbnz	r3, .L2341
	mov	r1, r3
	ldr	r0, .L2446+56
	bl	printf
.L2341:
	ldr	r4, .L2446+60
	movs	r5, #0
	ldr	r3, .L2446+64
	ldr	r0, [r4]
	str	r5, [r3]
	cbz	r0, .L2388
	bl	free
	str	r5, [r4]
.L2388:
	ldr	r4, .L2446+68
	ldr	r0, [r4]
	cmp	r0, #0
	beq	.L2338
	bl	free
	movs	r0, #0
	str	r0, [r4]
	b	.L2327
.L2383:
	adds	r4, r4, #1
	b	.L2382
.L2447:
	.align	2
.L2446:
	.word	.LANCHOR3
	.word	.LANCHOR19
	.word	.LANCHOR28
	.word	.LANCHOR1
	.word	.LANCHOR17
	.word	.LANCHOR31
	.word	.LANCHOR44
	.word	.LANCHOR46
	.word	.LANCHOR162
	.word	.LANCHOR21
	.word	1179535694
	.word	.LC131
	.word	.LANCHOR0
	.word	.LANCHOR32
	.word	.LC132
	.word	.LANCHOR135
	.word	.LANCHOR136
	.word	.LANCHOR137
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
	ldr	r3, .L2454
	add	r5, sp, #40
	mov	r4, r0
	mov	r6, r1
	mov	r7, r2
	ldm	r5, {r5, r8, r10}
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, fp
	bhi	.L2449
	movw	r2, #726
	ldr	r1, .L2454+4
	ldr	r0, .L2454+8
	bl	printf
.L2449:
	ldr	r3, .L2454+12
	ldrb	fp, [r3, fp]	@ zero_extendqisi2
	ldr	r3, .L2454+16
	mov	r0, fp
	ldr	r3, [r3]
	lsl	fp, fp, #8
	str	r3, [sp, #4]
	bl	nandc_cs
	ldr	r3, [sp, #4]
	cbz	r4, .L2450
	add	r2, r3, fp
	str	r4, [r2, #2056]
.L2450:
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
	ldr	r1, .L2454+20
	mov	r3, r10
	mov	r2, r8
	movs	r0, #1
	ldrb	r1, [r1, #9]	@ zero_extendqisi2
	bl	nandc_xfer_start
	bl	nandc_xfer_done
	str	r7, [fp, #2056]
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	nandc_de_cs.constprop.29
.L2455:
	.align	2
.L2454:
	.word	.LANCHOR18
	.word	.LANCHOR170
	.word	.LC0
	.word	.LANCHOR30
	.word	.LANCHOR13
	.word	.LANCHOR31
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
	push	{r0, r1, r2, r3, r4, r5, r6, lr}
	mov	r4, r0
	ldr	r3, [r0]
	movs	r1, #1
	ldr	r2, [r3, #12]
	ldr	r5, [r3, #24]
	ldrb	r0, [r3, #44]	@ zero_extendqisi2
	str	r2, [sp, #8]
	movs	r2, #26
	ldr	r3, [r3, #4]
	ubfx	r6, r5, #0, #21
	ubfx	r5, r5, #21, #3
	str	r6, [sp]
	str	r3, [sp, #4]
	mov	r3, r5
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldm	r4, {r2, r3}
	movs	r1, #2
	ldrb	r0, [r2, #44]	@ zero_extendqisi2
	ldr	r2, [r3, #12]
	str	r2, [sp, #8]
	movs	r2, #26
	ldr	r3, [r3, #4]
	str	r6, [sp]
	str	r3, [sp, #4]
	mov	r3, r5
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	r3, [r4, #8]
	movs	r1, #3
	ldr	r2, [r4]
	ldrb	r0, [r2, #44]	@ zero_extendqisi2
	ldr	r2, [r3, #12]
	str	r2, [sp, #8]
	movs	r2, #16
	ldr	r3, [r3, #4]
	str	r6, [sp]
	str	r3, [sp, #4]
	mov	r3, r5
	bl	flash_start_tlc_page_prog
	ldr	r1, [r4]
	movs	r3, #4
	ldr	r0, .L2457
	strb	r3, [r1, #42]
	movs	r3, #1
	strb	r3, [r1, #43]
	movs	r3, #255
	strb	r3, [r1]
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, lr}
	b	buf_add_tail
.L2458:
	.align	2
.L2457:
	.word	.LANCHOR54
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
.L2460:
	movs	r1, #1
	mov	r0, r6
	bl	queue_lun_state
	mov	r4, r0
	cbnz	r0, .L2461
	mov	r0, r5
	bl	queue_tlc_prog_cmd
	mov	r0, r4
	pop	{r4, r5, r6, pc}
.L2461:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2460
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
	ldr	r3, [r0]
	push	{r4, r5, r6, r7, r8, r10, lr}
	mov	r4, r0
	sub	sp, sp, #20
	mov	r7, r1
	mov	r10, r2
	ldr	r5, [r3, #24]
.L2463:
	movs	r1, #1
	mov	r0, r5
	bl	queue_lun_state
	cmp	r0, #0
	bne	.L2464
	cmp	r10, #2
	bne	.L2465
	ldr	r2, [r7]
	movs	r1, #1
	ldr	r3, [r4]
	ldr	r6, [r2, #24]
	ldr	r2, [r3, #12]
	ldr	r5, [r3, #24]
	ldrb	r0, [r3, #44]	@ zero_extendqisi2
	ubfx	r6, r6, #0, #21
	str	r2, [sp, #8]
	movs	r2, #17
	ldr	r3, [r3, #4]
	ubfx	r8, r5, #0, #21
	ubfx	r5, r5, #21, #3
	str	r8, [sp]
	str	r3, [sp, #4]
	mov	r3, r5
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	r3, [r7]
	movs	r1, #1
	ldr	r2, [r4]
	ldrb	r0, [r2, #44]	@ zero_extendqisi2
	ldr	r2, [r3, #12]
	str	r2, [sp, #8]
	movs	r2, #26
	ldr	r3, [r3, #4]
	str	r6, [sp]
	str	r3, [sp, #4]
	mov	r3, r5
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldm	r4, {r2, r3}
	mov	r1, r10
	ldrb	r0, [r2, #44]	@ zero_extendqisi2
	ldr	r2, [r3, #12]
	str	r2, [sp, #8]
	movs	r2, #17
	ldr	r3, [r3, #4]
	str	r8, [sp]
	str	r3, [sp, #4]
	mov	r3, r5
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	r3, [r7, #4]
	mov	r1, r10
	ldr	r2, [r4]
	ldrb	r0, [r2, #44]	@ zero_extendqisi2
	ldr	r2, [r3, #12]
	str	r2, [sp, #8]
	movs	r2, #26
	ldr	r3, [r3, #4]
	str	r6, [sp]
	str	r3, [sp, #4]
	mov	r3, r5
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	r3, [r4, #8]
	movs	r1, #3
	ldr	r2, [r4]
	ldrb	r0, [r2, #44]	@ zero_extendqisi2
	ldr	r2, [r3, #12]
	str	r2, [sp, #8]
	movs	r2, #17
	ldr	r3, [r3, #4]
	str	r8, [sp]
	str	r3, [sp, #4]
	mov	r3, r5
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	r3, [r7, #8]
	movs	r1, #3
	ldr	r2, [r4]
	ldrb	r0, [r2, #44]	@ zero_extendqisi2
	ldr	r2, [r3, #12]
	str	r2, [sp, #8]
	movs	r2, #16
	ldr	r3, [r3, #4]
	str	r6, [sp]
	str	r3, [sp, #4]
	mov	r3, r5
	bl	flash_start_tlc_page_prog
	ldr	r1, [r4]
	movs	r3, #5
	ldr	r0, .L2467
	strb	r3, [r1, #42]
	movs	r3, #1
	strb	r3, [r1, #43]
	movs	r3, #255
	strb	r3, [r1]
	bl	buf_add_tail
.L2466:
	movs	r0, #0
	add	sp, sp, #20
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L2464:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2463
.L2465:
	mov	r0, r4
	bl	queue_tlc_prog_cmd
	b	.L2466
.L2468:
	.align	2
.L2467:
	.word	.LANCHOR54
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
	push	{r0, r1, r2, r3, r4, r5, r6, lr}
	mov	r4, r0
	ldr	r3, [r0, #24]
	ldr	r0, .L2470
	ubfx	r5, r3, #0, #21
	mov	r2, r3
	mov	r1, r5
	ubfx	r6, r3, #21, #3
	bl	printf
	ldr	r3, [r4, #12]
	movs	r2, #26
	movs	r1, #1
	str	r5, [sp]
	movs	r0, #0
	str	r3, [sp, #8]
	ldr	r3, [r4, #4]
	str	r3, [sp, #4]
	mov	r3, r6
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	r3, [r4, #12]
	movs	r2, #26
	movs	r1, #2
	str	r5, [sp]
	movs	r0, #0
	str	r3, [sp, #8]
	ldr	r3, [r4, #4]
	str	r3, [sp, #4]
	mov	r3, r6
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	r3, [r4, #12]
	movs	r2, #16
	movs	r1, #3
	str	r5, [sp]
	movs	r0, #0
	str	r3, [sp, #8]
	ldr	r3, [r4, #4]
	str	r3, [sp, #4]
	mov	r3, r6
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	movs	r1, #64
	ldr	r0, [r4, #24]
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, lr}
	b	flash_wait_device_ready
.L2471:
	.align	2
.L2470:
	.word	.LC133
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
	mov	r7, r3
	ldr	r3, .L2474
	mov	r6, r0
	mov	r4, r1
	mov	r5, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r1
	bhi	.L2473
	mov	r2, #756
	ldr	r1, .L2474+4
	ldr	r0, .L2474+8
	bl	printf
.L2473:
	ldr	r3, .L2474+12
	ldrb	r4, [r3, r4]	@ zero_extendqisi2
	ldr	r3, .L2474+16
	mov	r0, r4
	ldr	r8, [r3]
	bl	nandc_cs
	movs	r3, #128
	mov	r0, r5
	add	r4, r8, r4, lsl #8
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
	ldr	r1, .L2474+20
	mov	r2, r7
	ldr	r3, [sp, #24]
	movs	r0, #1
	ldrb	r1, [r1, #9]	@ zero_extendqisi2
	bl	nandc_xfer_start
	bl	nandc_xfer_done
	str	r6, [r4, #2056]
	pop	{r4, r5, r6, r7, r8, pc}
.L2475:
	.align	2
.L2474:
	.word	.LANCHOR18
	.word	.LANCHOR171
	.word	.LC0
	.word	.LANCHOR30
	.word	.LANCHOR13
	.word	.LANCHOR31
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
	ldr	r3, [r0]
	push	{r0, r1, r2, r4, r5, r6, r7, lr}
	mov	r5, r0
	ldr	r4, [r3, #24]
.L2477:
	movs	r1, #1
	mov	r0, r4
	bl	queue_lun_state
	mov	r6, r0
	cbnz	r0, .L2478
	ldr	r3, [r5]
	ldr	r4, [r3, #24]
	ubfx	r7, r4, #0, #21
	ubfx	r4, r4, #21, #3
	mov	r0, r4
	bl	zftl_flash_exit_slc_mode
	ldr	r3, [r5]
	mov	r1, r4
	movs	r0, #16
	ldr	r2, [r3, #12]
	str	r2, [sp]
	mov	r2, r7
	ldr	r3, [r3, #4]
	bl	flash_start_3d_mlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	r3, [r5, #4]
	mov	r1, r4
	movs	r0, #16
	ldr	r2, [r3, #12]
	str	r2, [sp]
	adds	r2, r7, #1
	ldr	r3, [r3, #4]
	bl	flash_start_3d_mlc_page_prog
	bl	nandc_de_cs.constprop.29
	ldr	r1, [r5]
	movs	r3, #4
	ldr	r0, .L2479
	strb	r3, [r1, #42]
	movs	r3, #1
	strb	r3, [r1, #43]
	movs	r3, #255
	strb	r3, [r1]
	bl	buf_add_tail
	mov	r0, r6
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, pc}
.L2478:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2477
.L2480:
	.align	2
.L2479:
	.word	.LANCHOR54
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
	push	{r0, r1, r4, r5, r6, lr}
	mov	r4, r0
	ldr	r5, [r0, #24]
	ubfx	r6, r5, #0, #21
	ubfx	r5, r5, #21, #3
	mov	r0, r5
	bl	zftl_flash_exit_slc_mode
	ldr	r2, [r4, #24]
	mov	r1, r6
	ldr	r0, .L2482
	adds	r3, r2, #1
	bl	printf
	ldr	r3, [r4, #12]
	mov	r2, r6
	mov	r1, r5
	movs	r0, #16
	str	r3, [sp]
	ldr	r3, [r4, #4]
	bl	flash_start_3d_mlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	r3, [r4, #12]
	adds	r2, r6, #1
	mov	r1, r5
	movs	r0, #16
	str	r3, [sp]
	ldr	r3, [r4, #4]
	bl	flash_start_3d_mlc_page_prog
	bl	nandc_wait_flash_ready
	movs	r1, #64
	ldr	r0, [r4, #24]
	bl	flash_wait_device_ready
	bl	nandc_de_cs.constprop.29
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, pc}
.L2483:
	.align	2
.L2482:
	.word	.LC134
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
	ldr	r2, .L2493
	ubfx	r7, r1, #21, #3
	mov	r10, r3
	ubfx	r5, r1, #0, #21
	ubfx	r3, r1, #24, #2
	str	r0, [sp, #4]
	ldrb	r1, [r2]	@ zero_extendqisi2
	mov	r8, r2
	str	r3, [sp]
	cmp	r1, r7
	bhi	.L2485
	movw	r2, #803
	ldr	r1, .L2493+4
	ldr	r0, .L2493+8
	bl	printf
.L2485:
	ldr	r2, .L2493+12
	ldrb	r6, [r2, r7]	@ zero_extendqisi2
	ldr	r2, .L2493+16
	ldr	r4, [r2]
	bl	nandc_rdy_status
	cbnz	r0, .L2486
	ldrb	r2, [r8]	@ zero_extendqisi2
	cmp	r2, #1
	bne	.L2487
	bl	nandc_wait_flash_ready
.L2486:
	mov	r0, r6
	bl	hynix_reconfig_rr_para
	mov	r0, r6
	bl	nandc_cs
	ldr	r3, [sp]
	cbnz	r3, .L2488
	mov	r0, r5
	bl	slc_phy_page_address_calc
	ldr	r3, .L2493+20
	mov	r5, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2489
	mov	r0, r6
	bl	zftl_flash_enter_slc_mode
.L2489:
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
	ldr	r1, .L2493+24
	mov	r3, r10
	mov	r2, fp
	movs	r0, #1
	ldrb	r1, [r1, #9]	@ zero_extendqisi2
	bl	nandc_xfer_start
	bl	nandc_xfer_done
	ldr	r3, [sp, #4]
	str	r3, [r4, #2056]
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	nandc_de_cs.constprop.29
.L2487:
	movs	r2, #64
	mov	r1, r5
	mov	r0, r7
	bl	flash_wait_device_ready_raw
	b	.L2486
.L2488:
	mov	r0, r6
	bl	zftl_flash_exit_slc_mode
	b	.L2489
.L2494:
	.align	2
.L2493:
	.word	.LANCHOR18
	.word	.LANCHOR172
	.word	.LC0
	.word	.LANCHOR30
	.word	.LANCHOR13
	.word	.LANCHOR0
	.word	.LANCHOR31
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
	ldr	r3, .L2503
	ldr	r2, [r4, #24]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #255
	beq	.L2496
	ldr	r6, .L2503+4
	ubfx	r2, r2, #21, #3
	movs	r5, #48
	mov	r7, r6
.L2498:
	mla	r1, r5, r3, r6
	ldr	r0, [r1, #24]
	ubfx	r0, r0, #21, #3
	cmp	r2, r0
	bne	.L2497
	add	r0, r1, #42
	ldrb	r1, [r1, #42]	@ zero_extendqisi2
	cmp	r1, #7
	bne	.L2497
	movs	r3, #3
	strb	r3, [r0]
.L2496:
	movs	r3, #3
	mov	r1, r4
	strb	r3, [r4, #42]
	movs	r3, #1
	strb	r3, [r4, #43]
	movs	r3, #255
	strb	r3, [r4]
	ldr	r0, .L2503
	pop	{r3, r4, r5, r6, r7, lr}
	b	buf_add_tail
.L2497:
	muls	r3, r5, r3
	ldrb	r3, [r7, r3]	@ zero_extendqisi2
	cmp	r3, #255
	bne	.L2498
	b	.L2496
.L2504:
	.align	2
.L2503:
	.word	.LANCHOR54
	.word	.LANCHOR50
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
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldrh	r3, [r0, #34]
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	mov	r5, r1
	cbz	r3, .L2506
	ldr	r3, .L2532
	ldr	r3, [r3]
	lsls	r3, r3, #23
	bpl	.L2506
	mov	r2, r1
	ldr	r1, [r0, #24]
	ldr	r0, .L2532+4
	bl	printf
.L2506:
	ldr	fp, .L2532+32
	movs	r7, #0
.L2507:
	cbnz	r5, .L2518
.L2531:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2518:
	ldrb	r8, [r4]	@ zero_extendqisi2
	ldr	r6, [r4, #24]
.L2508:
	movs	r1, #1
	mov	r0, r6
	bl	queue_lun_state
	cbnz	r0, .L2509
	cmp	r5, #1
	beq	.L2510
	ldr	r3, .L2532+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L2511
.L2510:
	mov	r0, r4
	bl	queue_prog_cmd
.L2512:
	subs	r5, r5, #1
	beq	.L2531
	add	r8, r8, r8, lsl #1
	add	r4, fp, r8, lsl #4
	b	.L2507
.L2509:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2508
.L2511:
	ldrb	r3, [r4]	@ zero_extendqisi2
	ubfx	r10, r6, #21, #3
	cmp	r3, #255
	bne	.L2513
	movw	r2, #583
	ldr	r1, .L2532+12
	ldr	r0, .L2532+16
	bl	printf
.L2513:
	ldrb	r3, [r4]	@ zero_extendqisi2
	movs	r2, #48
	mla	r3, r2, r3, fp
	ldr	ip, [r3, #24]
	ubfx	r3, ip, #21, #3
	cmp	r10, r3
	bne	.L2514
	ldr	r3, .L2532+20
	mov	r10, #1
	ldrh	r1, [r3]
	ldr	r3, .L2532+24
	lsl	r2, r10, r1
	ldrb	r0, [r3]	@ zero_extendqisi2
	rsb	r3, r1, #21
	lsl	r3, r10, r3
	subs	r2, r2, #1
	uxth	r2, r2
	subs	r0, r0, #1
	subs	r3, r3, #1
	ands	r3, r3, r0
	and	lr, r2, r6
	uxth	r3, r3
	lsrs	r6, r6, r1
	lsr	r1, ip, r1
	ands	r6, r6, r3
	ands	r1, r1, r3
	and	r2, r2, ip
	cmp	r6, r1
	beq	.L2514
	cmp	lr, r2
	bne	.L2514
	cmp	r7, r0
	beq	.L2514
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
	ldr	r0, .L2532+28
	bl	buf_add_tail
	b	.L2512
.L2514:
	mov	r0, r4
	movs	r7, #0
	bl	queue_prog_cmd
	b	.L2512
.L2533:
	.align	2
.L2532:
	.word	.LANCHOR14
	.word	.LC135
	.word	.LANCHOR39
	.word	.LANCHOR173
	.word	.LC0
	.word	.LANCHOR66
	.word	.LANCHOR67
	.word	.LANCHOR54
	.word	.LANCHOR50
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
	ldr	r4, .L2539
	ldr	r5, .L2539+4
	ldrb	r1, [r4]	@ zero_extendqisi2
	cbz	r1, .L2535
	ldrb	r0, [r5]	@ zero_extendqisi2
	ldr	r3, .L2539+8
	add	r0, r0, r0, lsl #1
	add	r0, r3, r0, lsl #4
	bl	sblk_prog_page
.L2535:
	movs	r3, #255
	strb	r3, [r5]
	movs	r3, #0
	strb	r3, [r4]
	bl	sblk_wait_write_queue_completed
	bl	ftl_write_completed
	movw	r0, #65535
	pop	{r3, r4, r5, lr}
	b	ftl_vpn_decrement
.L2540:
	.align	2
.L2539:
	.word	.LANCHOR121
	.word	.LANCHOR174
	.word	.LANCHOR50
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
	sub	sp, sp, #24
	mov	r7, r3
	ldrb	r3, [sp, #60]	@ zero_extendqisi2
	mov	fp, r0
	mov	r4, r1
	mov	r8, r2
	ubfx	r5, r1, #24, #2
	str	r3, [sp, #20]
	ldr	r3, .L2574
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r0
	bhi	.L2542
	movw	r2, #546
	ldr	r1, .L2574+4
	ldr	r0, .L2574+8
	bl	printf
.L2542:
	ldr	r3, .L2574+12
	ldrb	r3, [r3, fp]	@ zero_extendqisi2
	str	r3, [sp, #12]
	cmp	r5, #0
	bne	.L2553
	ldr	r3, .L2574+16
	ldr	r10, .L2574+64
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2544
	ldrb	r3, [r10]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L2553
.L2544:
	ldr	r3, .L2574+20
	mov	r0, r4
	ldrh	r6, [r3]
	mov	r1, r6
	bl	__aeabi_uidiv
	mov	r1, r6
	mul	r5, r6, r0
	mov	r0, r4
	bl	__aeabi_uidivmod
	ldrb	r3, [r10]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L2545
	add	r5, r5, r1, lsl #1
.L2549:
	ldr	r3, .L2574+24
	ldr	r3, [r3]
	lsls	r1, r3, #27
	bpl	.L2546
	mov	r3, r5
	mov	r2, r4
	ldr	r1, [sp, #12]
	ldr	r0, .L2574+28
	bl	printf
.L2546:
	ldr	r3, [sp, #56]
	mov	r2, r8
	mov	r1, r5
	ldr	r0, [sp, #12]
	str	r3, [sp]
	mov	r3, r7
	bl	flash_prog_page
	ldr	r3, [sp, #20]
	str	r0, [sp, #16]
	cmp	r3, #0
	beq	.L2547
	ldr	r3, [sp, #56]
	mov	r1, r4
	ldr	r10, .L2574+44
	mov	r0, fp
	ldr	r2, .L2574+32
	str	r3, [sp]
	ldr	r3, [r10]
	ldr	r2, [r2]
	bl	flash_read_page_en
	adds	r2, r0, #1
	mov	r6, r0
	beq	.L2548
	cmp	r0, #512
	beq	.L2548
	ldr	r3, .L2574+32
	ldr	r2, [r8]
	ldr	r3, [r3]
	ldr	r3, [r3]
	cmp	r2, r3
	bne	.L2548
	ldr	r3, [r10]
	ldr	r2, [r7]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L2547
.L2548:
	movs	r3, #4
	mov	r1, r8
	mov	r2, r3
	ldr	r0, .L2574+36
	bl	rknand_print_hex
	movs	r3, #4
	mov	r1, r7
	mov	r2, r3
	ldr	r0, .L2574+40
	bl	rknand_print_hex
	ldr	r1, .L2574+44
	movs	r3, #4
	mov	r2, r3
	ldr	r0, .L2574+48
	ldr	r1, [r1]
	bl	rknand_print_hex
	ldr	r1, .L2574+32
	movs	r3, #4
	mov	r2, r3
	ldr	r0, .L2574+52
	ldr	r1, [r1]
	bl	rknand_print_hex
	cmp	r6, #512
	beq	.L2549
.L2551:
	mov	r1, r4
	ldr	r0, .L2574+56
	bl	printf
	movw	r2, #577
	ldr	r1, .L2574+4
	ldr	r0, .L2574+8
	bl	printf
	mov	r0, #-1
.L2550:
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2545:
	ldr	r3, .L2574+60
	ldrh	r1, [r3, r1, lsl #1]
	add	r5, r5, r1
	b	.L2549
.L2553:
.L2543:
	mov	r5, r4
	b	.L2549
.L2547:
	ldr	r0, [sp, #16]
	adds	r3, r0, #1
	bne	.L2550
	b	.L2551
.L2575:
	.align	2
.L2574:
	.word	.LANCHOR18
	.word	.LANCHOR175
	.word	.LC0
	.word	.LANCHOR30
	.word	.LANCHOR0
	.word	.LANCHOR2
	.word	.LANCHOR14
	.word	.LC136
	.word	.LANCHOR164
	.word	.LC137
	.word	.LC138
	.word	.LANCHOR163
	.word	.LC139
	.word	.LC140
	.word	.LC141
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
	ldr	r3, .L2603
	mov	r10, r0
	mov	r8, r5
	str	r5, [r3]
	ldr	r3, .L2603+4
	str	r5, [r3]
.L2577:
	uxth	r3, r5
	str	r3, [sp, #12]
	ldr	r3, .L2603+8
	ldr	r2, [sp, #12]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r2
	bls	.L2587
	mov	fp, #0
	b	.L2588
.L2586:
	ldr	r3, .L2603+12
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L2578
	mov	r1, r10
	ldr	r0, .L2603+16
	bl	printf
.L2578:
	ldr	r3, .L2603+20
	ldrb	r4, [r3]	@ zero_extendqisi2
	ldr	r3, [sp, #12]
	smulbb	r4, r4, r10
	add	r4, r4, r6
	uxth	r4, r4
	cbnz	r3, .L2579
	ldr	r3, .L2603+24
	ldr	r3, [r3]
	ldrb	r3, [r3, #47]	@ zero_extendqisi2
	cmp	r3, r4
	bcs	.L2580
.L2579:
	uxtb	r6, r5
	mov	r1, r4
	mov	r0, r6
	bl	flash_check_bad_block
	cbnz	r0, .L2580
	ldr	r3, .L2603+28
	mov	r1, r8
	mov	r0, r6
	ldrh	r7, [r3]
	muls	r7, r4, r7
	mov	r2, r7
	bl	flash_erase_block_en
	cbz	r0, .L2581
	ldr	r3, .L2603+32
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #2
	bne	.L2602
	ldr	r3, .L2603+36
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2602
	mov	r2, r7
	movs	r1, #1
	mov	r0, r6
	bl	flash_erase_block_en
	cbnz	r0, .L2602
.L2585:
	ldr	r3, .L2603+32
	mov	r8, #1
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r7, r7, r3, lsl #24
.L2584:
	movs	r3, #1
	ldr	r2, .L2603
	str	r3, [sp, #4]
	mov	r1, r7
	ldr	r3, .L2603+40
	mov	r0, r6
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp]
	ldr	r3, .L2603+4
	bl	flash_prog_page_en
	cbz	r0, .L2580
.L2602:
	mov	r1, r4
	mov	r0, r6
	bl	flash_mask_bad_block
.L2580:
	add	fp, fp, #1
.L2588:
	ldr	r3, .L2603+20
	uxth	r6, fp
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r6
	bhi	.L2586
	adds	r5, r5, #1
	b	.L2577
.L2581:
	cmp	r8, #0
	beq	.L2584
	b	.L2585
.L2587:
	cmp	r8, #0
	beq	.L2589
	ldr	r3, .L2603+44
	movs	r2, #2
	ldr	r3, [r3]
	add	r10, r3, r10, lsl #2
	ldrb	r3, [r10, #2]	@ zero_extendqisi2
	bfi	r3, r2, #3, #2
	strb	r3, [r10, #2]
.L2589:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2604:
	.align	2
.L2603:
	.word	ftl_tmp_buffer
	.word	.LANCHOR176
	.word	.LANCHOR104
	.word	.LANCHOR14
	.word	.LC142
	.word	.LANCHOR67
	.word	.LANCHOR27
	.word	.LANCHOR103
	.word	.LANCHOR71
	.word	.LANCHOR0
	.word	.LANCHOR123
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
	bne	.L2605
	ldr	r1, .L2607
	movw	r2, #2231
	ldr	r0, .L2607+4
	bl	printf
	mov	r1, r5
	ldr	r0, .L2607+8
	bl	printf
.L2605:
	mov	r0, r4
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, pc}
.L2608:
	.align	2
.L2607:
	.word	.LANCHOR177
	.word	.LC0
	.word	.LC141
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
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r10, #0
	ldr	r6, .L2642
	movs	r1, #0
	ldr	r7, .L2642+4
	ldrb	r2, [r6]	@ zero_extendqisi2
	str	r0, [sp, #12]
	mov	r5, r7
	ldr	r0, .L2642+8
	lsls	r2, r2, #1
	bl	ftl_memset
.L2610:
	ldr	r8, .L2642+48
	ldr	r1, [sp, #12]
	ldrb	fp, [r7]	@ zero_extendqisi2
	ldrh	r3, [r8]
	ldrh	r4, [r7, #2]
	str	r3, [sp, #8]
	ldr	r3, .L2642+12
	ldr	r2, [r3]
	ldr	r3, [r2, #4]
	adds	r3, r3, #1
	str	r3, [r2, #4]
	ldr	r2, .L2642+8
	stm	r2, {r1, r3}
	ldr	r2, .L2642+16
	ldr	r2, [r2]
	lsls	r2, r2, #19
	bpl	.L2611
	mov	r2, r4
	mov	r1, fp
	ldr	r0, .L2642+20
	bl	printf
.L2611:
	ldr	r3, .L2642+24
	ldrh	r0, [r5, #2]
	ldrh	r3, [r3]
	cmp	r3, r0
	bhi	.L2612
	ldr	r4, .L2642+28
	ldr	fp, .L2642+44
.L2616:
	ldrb	r3, [r5, #1]	@ zero_extendqisi2
	adds	r3, r3, #1
	uxtb	r3, r3
	cmp	r3, #7
	strb	r3, [r5, #1]
	bls	.L2613
	ldr	r2, [r4]
	movs	r3, #0
	adds	r2, r2, #40
.L2628:
	ldrb	r1, [r2], #1	@ zero_extendqisi2
	uxth	r10, r3
	cmp	r1, #128
	bls	.L2614
	cmp	r1, #255
	beq	.L2615
	mov	r2, #748
	mov	r1, fp
	ldr	r0, .L2642+32
	bl	printf
.L2614:
	strb	r10, [r5, #1]
	mov	r10, #1
.L2613:
	ldr	r3, [r4]
	ldrb	r2, [r5, #1]	@ zero_extendqisi2
	add	r3, r3, r2
	ldrb	r3, [r3, #40]	@ zero_extendqisi2
	cmp	r3, #255
	strb	r3, [r5]
	beq	.L2616
	ldrh	r4, [r8]
	movs	r0, #0
	muls	r4, r3, r4
	mov	r1, r4
	bl	flash_erase_block
	ldrb	r3, [r6]	@ zero_extendqisi2
	mov	r1, r4
	ldr	r2, .L2642+36
	movs	r0, #0
	str	r3, [sp]
	ldr	r3, .L2642+8
	bl	ftl_prog_page
	movs	r3, #1
	add	r4, r4, r3
	strh	r3, [r5, #2]	@ movhi
.L2617:
	ldrb	r3, [r6]	@ zero_extendqisi2
	mov	r1, r4
	ldr	r2, .L2642+36
	movs	r0, #0
	str	r3, [sp]
	ldr	r3, .L2642+8
	bl	ftl_prog_page
	ldrh	r3, [r5, #2]
	adds	r0, r0, #1
	add	r3, r3, #1
	strh	r3, [r5, #2]	@ movhi
	ldr	r3, .L2642+40
	beq	.L2618
	ldrb	r2, [r3]	@ zero_extendqisi2
	cbz	r2, .L2619
.L2618:
	movs	r2, #0
	strb	r2, [r3]
	b	.L2610
.L2612:
	ldr	r3, [sp, #8]
	mla	r4, fp, r3, r4
	cmp	r0, #0
	bne	.L2617
	mov	r1, r4
	bl	flash_erase_block
	b	.L2617
.L2619:
	cmp	r10, #0
	bne	.L2620
.L2627:
	ldrb	r3, [r5]	@ zero_extendqisi2
	cmp	r3, #255
	bne	.L2641
	mov	r2, #784
	ldr	r1, .L2642+44
	ldr	r0, .L2642+32
	bl	printf
.L2641:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2620:
	ldrb	r4, [r5, #1]	@ zero_extendqisi2
	ldr	r6, .L2642+28
	ldr	r7, .L2642+44
	adds	r4, r4, #1
.L2623:
	cmp	r4, #7
	bhi	.L2627
	ldr	r3, [r6]
	add	r3, r3, r4
	ldrb	r8, [r3, #40]	@ zero_extendqisi2
	uxth	r3, r8
	cmp	r3, #128
	bls	.L2624
	cmp	r3, #255
	beq	.L2625
	movw	r2, #777
	mov	r1, r7
	ldr	r0, .L2642+32
	bl	printf
.L2624:
	ldr	r3, .L2642+48
	movs	r0, #0
	ldrh	r1, [r3]
	mul	r1, r8, r1
	bl	flash_erase_block
.L2625:
	adds	r4, r4, #1
	uxth	r4, r4
	b	.L2623
.L2615:
	adds	r3, r3, #1
	cmp	r3, #8
	bne	.L2628
	mov	r10, r3
	b	.L2614
.L2643:
	.align	2
.L2642:
	.word	.LANCHOR123
	.word	.LANCHOR179
	.word	.LANCHOR178
	.word	.LANCHOR102
	.word	.LANCHOR14
	.word	.LC143
	.word	.LANCHOR85
	.word	.LANCHOR27
	.word	.LC0
	.word	ftl_info_data_buffer
	.word	.LANCHOR181
	.word	.LANCHOR180
	.word	.LANCHOR103
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
	ldr	r3, .L2672
	mov	r1, r4
	ldr	r2, .L2672+4
	strb	r4, [r3]
	movs	r3, #1
	ldr	r0, .L2672+8
	strb	r3, [r2]
	ldr	r2, .L2672+12
	ldr	r5, .L2672+16
	ldr	r6, .L2672+20
	strb	r3, [r2]
	mov	r2, #16384
	ldr	r3, .L2672+24
	str	r0, [r3]
	ldr	r3, .L2672+28
	ldrh	r3, [r3]
	add	r3, r0, r3, lsl #2
	str	r3, [r5]
	bl	ftl_memset
	mov	r2, #16384
	mov	r1, r4
	ldr	r0, .L2672+32
	bl	ftl_memset
	ldr	r2, [r6]
	ldr	r3, .L2672+36
	ldrb	r2, [r2, #40]	@ zero_extendqisi2
	strb	r4, [r3, #1]
	strh	r4, [r3, #2]	@ movhi
	movs	r4, #7
	strb	r2, [r3]
	str	r3, [sp, #12]
.L2646:
	ldr	r3, [r6]
	sxth	r8, r4
	add	r3, r3, r4
	ldrb	r7, [r3, #40]	@ zero_extendqisi2
	cmp	r7, #255
	bne	.L2645
.L2650:
	adds	r4, r4, #-1
	bcs	.L2646
	mov	r8, #0
.L2647:
	ldr	r3, .L2672+40
	ldr	r2, [r3]
	mov	r10, r3
	tst	r2, #4096
	beq	.L2651
	ldr	r3, [r5]
	mov	r2, #4800
	mov	r1, r4
	ldr	r0, .L2672+44
	ldr	r3, [r3]
	bl	printf
.L2651:
	adds	r2, r4, #1
	bne	.L2652
	mov	r2, #16384
	movs	r1, #0
	ldr	r0, .L2672+8
	bl	ftl_memset
	ldr	r3, [r5]
	ldr	r2, .L2672+48
	str	r2, [r3]
	ldr	r2, .L2672+52
	str	r2, [r3, #12]
.L2644:
	mov	r0, r4
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2645:
	ldr	r3, .L2672+56
	movs	r0, #0
	ldr	fp, .L2672+68
	ldr	r2, .L2672+8
	ldrh	r3, [r3]
	muls	r7, r3, r7
	ldrb	r3, [fp]	@ zero_extendqisi2
	str	r3, [sp]
	mov	r1, r7
	ldr	r3, .L2672+60
	bl	ftl_read_page
	cmp	r0, #-1
	mov	r10, r0
	bne	.L2648
	ldrb	r3, [fp]	@ zero_extendqisi2
	adds	r1, r7, #1
	ldr	r2, .L2672+8
	movs	r0, #0
	str	r3, [sp]
	ldr	r3, .L2672+60
	bl	ftl_read_page
	mov	r10, r0
.L2648:
	ldr	r3, .L2672+40
	ldr	r3, [r3]
	lsls	r1, r3, #19
	bpl	.L2649
	ldr	r3, [r5]
	mov	r2, r10
	mov	r1, r4
	ldr	r0, .L2672+64
	ldr	r3, [r3]
	str	r3, [sp]
	mov	r3, #672
	bl	printf
.L2649:
	cmp	r10, #-1
	beq	.L2650
	ldr	r3, [r5]
	ldr	r2, .L2672+48
	ldr	r3, [r3]
	cmp	r3, r2
	bne	.L2650
	mov	r4, r8
	b	.L2647
.L2652:
	ldr	r3, [r6]
	movs	r0, #0
	ldr	r2, .L2672+8
	movs	r4, #0
	add	r3, r3, r8
	ldrb	r1, [r3, #40]	@ zero_extendqisi2
	ldr	r3, [sp, #12]
	strb	r8, [r3, #1]
	strb	r1, [r3]
	movs	r3, #4
	str	r3, [sp]
	ldr	r3, .L2672+60
	bl	flash_get_last_written_page
	uxth	r6, r0
	mov	r7, r0
	adds	r3, r6, #1
	uxth	r8, r3
	ldr	r3, [sp, #12]
	ldrb	fp, [r3]	@ zero_extendqisi2
	ldr	r3, .L2672+56
	ldrh	r3, [r3]
	mul	fp, r3, fp
.L2654:
	subs	r3, r6, r4
	lsls	r3, r3, #16
	bmi	.L2658
	ldr	r3, .L2672+68
	add	r1, r7, fp
	ldr	r2, .L2672+8
	subs	r1, r1, r4
	movs	r0, #0
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp]
	ldr	r3, .L2672+60
	bl	ftl_read_page
	adds	r0, r0, #1
	beq	.L2655
	ldr	r3, [r5]
	ldr	r2, .L2672+48
	ldr	r3, [r3]
	cmp	r3, r2
	bne	.L2655
.L2658:
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
	beq	.L2644
	ldr	r3, [r5]
	movs	r4, #0
	ldr	r0, .L2672+72
	ldr	r1, [r3, #156]
	bl	printf
	b	.L2644
.L2655:
	adds	r4, r4, #1
	b	.L2654
.L2673:
	.align	2
.L2672:
	.word	.LANCHOR182
	.word	.LANCHOR181
	.word	ftl_info_data_buffer
	.word	.LANCHOR183
	.word	.LANCHOR102
	.word	.LANCHOR27
	.word	.LANCHOR7
	.word	.LANCHOR6
	.word	ftl_ext_info_data_buffer
	.word	.LANCHOR179
	.word	.LANCHOR14
	.word	.LC145
	.word	1229739078
	.word	393238
	.word	.LANCHOR103
	.word	.LANCHOR178
	.word	.LC144
	.word	.LANCHOR123
	.word	.LC146
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
	ldr	r3, .L2690
	push	{r0, r1, r2, r4, r5, r6, r7, r8, r10, lr}
	ldr	r3, [r3]
	ldr	r2, [r3, #520]
	cbz	r2, .L2675
	movs	r2, #0
	str	r2, [r3, #520]
.L2675:
	ldr	r5, .L2690+4
	movs	r0, #0
	bl	ftl_total_vpn_update
	mov	r4, r5
.L2679:
	ldr	r3, [r5]
	ldr	r2, [r3, #56]
	adds	r2, r2, #1
	str	r2, [r3, #56]
	ldrh	r2, [r3, #140]
	ldr	r3, .L2690+8
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L2677
	bl	ftl_ext_alloc_new_blk
.L2677:
	ldr	r3, [r4]
	ldrh	r2, [r3, #130]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L2678
	movw	r2, #1819
	ldr	r1, .L2690+12
	ldr	r0, .L2690+16
	bl	printf
.L2678:
	ldr	r1, [r4]
	ldr	r3, .L2690+20
	ldr	r10, .L2690+36
	ldrh	r0, [r1, #130]
	ldrh	r3, [r3]
	ldr	r8, .L2690+40
	rsb	r2, r3, #21
	movs	r3, #1
	asr	r6, r0, r2
	lsls	r3, r3, r2
	ldr	r2, .L2690+24
	subs	r3, r3, #1
	ands	r3, r3, r0
	mov	r0, r8
	ldrh	r7, [r2]
	ldrh	r2, [r1, #140]
	movs	r1, #0
	smlabb	r3, r7, r3, r2
	ldrb	r2, [r10]	@ zero_extendqisi2
	uxth	r7, r3
	lsls	r2, r2, #1
	bl	ftl_memset
	movs	r3, #0
	ldr	r2, .L2690+28
	str	r3, [r8]
	mov	r1, r7
	ldr	r3, [r4]
	uxtb	r0, r6
	ldr	r3, [r3, #56]
	str	r3, [r8, #4]
	ldrb	r3, [r10]	@ zero_extendqisi2
	str	r3, [sp]
	mov	r3, r8
	bl	ftl_prog_page
	ldr	r2, [r4]
	ldrh	r3, [r2, #140]
	adds	r3, r3, #1
	uxth	r3, r3
	cmp	r3, #1
	strh	r3, [r2, #140]	@ movhi
	beq	.L2679
	adds	r0, r0, #1
	ldr	r3, .L2690+32
	beq	.L2680
	ldrb	r0, [r3]	@ zero_extendqisi2
	cbz	r0, .L2681
.L2680:
.L2676:
	movs	r2, #0
	strb	r2, [r3]
	b	.L2679
.L2681:
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L2691:
	.align	2
.L2690:
	.word	.LANCHOR10
	.word	.LANCHOR102
	.word	.LANCHOR85
	.word	.LANCHOR184
	.word	.LC0
	.word	.LANCHOR66
	.word	.LANCHOR103
	.word	ftl_ext_info_data_buffer
	.word	.LANCHOR183
	.word	.LANCHOR123
	.word	.LANCHOR178
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
	ldr	r3, .L2709
	ldr	r5, .L2709+4
	strh	r2, [r3]	@ movhi
	ldr	r3, [r5]
	ldrh	r2, [r3, #130]
	ldr	r3, .L2709+8
	ldrh	r4, [r3]
	rsb	r3, r4, #21
	movs	r4, #1
	asr	r6, r2, r3
	lsls	r4, r4, r3
	uxtb	r10, r6
	subs	r4, r4, #1
	ands	r4, r4, r2
	ldr	r2, .L2709+12
	movs	r3, #4
	mov	r1, r4
	str	r3, [sp]
	mov	r0, r10
	ldr	r3, .L2709+16
	bl	flash_get_last_written_page
	ldr	r3, .L2709+20
	mov	r7, r0
	ldr	r3, [r3]
	lsls	r1, r3, #19
	bpl	.L2693
	ldr	r3, [r5]
	uxth	r6, r6
	movw	r2, #1863
	ldr	r1, .L2709+24
	ldrh	r3, [r3, #130]
	str	r6, [sp]
	str	r3, [sp, #4]
	mov	r3, r0
	ldr	r0, .L2709+28
	bl	printf
.L2693:
	ldr	fp, .L2709+48
	mov	r8, #0
.L2694:
	uxth	r6, r7
	sub	r3, r6, r8
	lsls	r3, r3, #16
	bmi	.L2699
	ldr	r3, .L2709+32
	sub	r1, r7, r8
	ldr	r2, .L2709+12
	ldrh	r0, [r3]
	ldr	r3, .L2709+36
	ldrb	r3, [r3]	@ zero_extendqisi2
	mla	r1, r4, r0, r1
	mov	r0, r10
	str	r3, [sp]
	ldr	r3, .L2709+16
	bl	flash_read_page_en
	adds	r2, r0, #1
	beq	.L2695
	cmp	r0, #512
	beq	.L2695
	ldr	r3, .L2709+40
	ldr	r3, [r3]
	ldr	r3, [r3]
	cmp	r3, fp
	bne	.L2695
.L2699:
	bl	zftl_sblk_list_init
	ldr	r3, [r5]
	ldrh	r2, [r3, #140]
	cmp	r2, r7
	bgt	.L2697
	adds	r6, r6, #1
	strh	r6, [r3, #140]	@ movhi
	bl	ftl_ext_info_flush
.L2697:
	ldr	r3, .L2709+40
	movw	r2, #65535
	movs	r0, #0
	ldr	r3, [r3]
	strh	r2, [r3, #584]	@ movhi
	strh	r2, [r3, #586]	@ movhi
	strh	r2, [r3, #588]	@ movhi
	strh	r2, [r3, #590]	@ movhi
	str	r2, [r3, #560]
	mov	r2, #-1
	str	r0, [r3, #520]
	str	r0, [r3, #604]
	str	r0, [r3, #608]
	str	r2, [r3, #564]
	ldr	r3, .L2709+44
	strh	r2, [r3]	@ movhi
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2695:
	add	r8, r8, #1
	b	.L2694
.L2710:
	.align	2
.L2709:
	.word	.LANCHOR113
	.word	.LANCHOR102
	.word	.LANCHOR66
	.word	ftl_ext_info_data_buffer
	.word	.LANCHOR178
	.word	.LANCHOR14
	.word	.LANCHOR185
	.word	.LC147
	.word	.LANCHOR103
	.word	.LANCHOR123
	.word	.LANCHOR10
	.word	.LANCHOR64
	.word	1162432070
	.size	ftl_ext_info_init, .-ftl_ext_info_init
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
	ldr	r5, .L2713
	ldr	r0, .L2713+4
	bl	ftl_memset
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
	bls	.L2712
	movw	r2, #2053
	ldr	r1, .L2713+8
	ldr	r0, .L2713+12
	bl	printf
.L2712:
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
	ldr	r2, .L2713+16
	ldr	r3, [r5]
	ldrh	r2, [r2]
	strh	r7, [r3, #692]	@ movhi
	strh	r6, [r3, #416]	@ movhi
	rsb	r2, r2, #21
	asr	r2, r7, r2
	ldr	r7, .L2713+20
	strh	r2, [r3, #694]	@ movhi
	movs	r2, #1
	strh	r2, [r3, #688]	@ movhi
	ldr	r2, .L2713+24
	ldrh	r2, [r2]
	strh	r2, [r3, #698]	@ movhi
	ldr	r2, .L2713+28
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
.L2714:
	.align	2
.L2713:
	.word	.LANCHOR102
	.word	ftl_ext_info_data_buffer
	.word	.LANCHOR186
	.word	.LC0
	.word	.LANCHOR66
	.word	.LANCHOR10
	.word	.LANCHOR187
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
	ldr	r6, .L2752
	sub	sp, sp, #40
	movs	r1, #0
	ldr	r0, .L2752+4
	bl	printf
.L2718:
	ldr	r3, [r6]
	add	r3, r3, r4
	ldrb	r5, [r3, #32]	@ zero_extendqisi2
	cmp	r5, #128
	ble	.L2716
	cmp	r5, #255
	beq	.L2717
	movw	r2, #2107
	ldr	r1, .L2752+8
	ldr	r0, .L2752+12
	bl	printf
.L2716:
	ldr	r3, .L2752+16
	movs	r0, #0
	ldrh	r1, [r3]
	muls	r1, r5, r1
	bl	flash_erase_block
.L2717:
	adds	r4, r4, #1
	cmp	r4, #16
	bne	.L2718
	bl	sblk_init
	bl	ftl_info_blk_init
	mov	r2, #16384
	movs	r1, #0
	ldr	r0, .L2752+20
	bl	ftl_memset
	ldr	r2, .L2752+24
	movs	r0, #1
	ldr	r1, .L2752+28
	ldr	r3, [r2]
	ldrh	r1, [r1]
	str	r2, [sp, #24]
	add	r1, r3, r1, lsl #2
.L2719:
	cmp	r3, r1
	bne	.L2720
	ldr	r7, .L2752+32
	movs	r4, #0
	ldr	r2, .L2752+36
	ldr	r3, [r7]
	str	r2, [r3]
	strh	r4, [r3, #148]	@ movhi
.L2721:
	ldr	r3, .L2752+28
	uxth	r0, r4
	ldrh	r3, [r3]
	cmp	r3, r0
	bhi	.L2729
	ldr	r3, .L2752+40
	mov	fp, #15
	ldrb	r5, [r3]	@ zero_extendqisi2
	ldr	r3, .L2752
	mov	r1, r5
	ldr	r3, [r3]
	ldrb	r0, [r3, #47]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	ldr	r3, .L2752+24
	uxtb	r0, r0
	cmp	r5, #1
	uxth	lr, r5
	add	r4, r0, #1
	ldr	r10, [r3]
	it	eq
	moveq	r8, #1
	ldr	r3, .L2752+32
	it	ne
	movne	r8, #3
	movs	r2, #0
	ldr	r6, [r3]
	ldrh	r3, [r6, #148]
.L2732:
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
	bhi	.L2732
	smulbb	r0, r0, lr
	add	r3, r3, lr
	mov	r1, r5
	uxtah	r0, r0, r3
	strh	r0, [r6, #148]	@ movhi
	movs	r0, #16
	bl	__aeabi_idiv
	ldr	r3, .L2752+44
	add	r0, r0, r4
	uxth	r0, r0
	ldr	r3, [r3]
	strh	r0, [r6, #134]	@ movhi
	lsls	r3, r3, #19
	bpl	.L2733
	str	r0, [sp]
	mov	r3, r4
	movs	r2, #128
	movw	r1, #2154
	ldr	r0, .L2752+48
	bl	printf
.L2733:
	ldr	r0, [r7]
	movs	r2, #128
	movs	r1, #255
	movs	r5, #0
	adds	r0, r0, #160
	bl	ftl_memset
	ldr	r3, [sp, #24]
	ldr	r1, [r7]
	ldr	r3, [r3]
	ldrh	fp, [r1, #134]
	str	r3, [sp, #24]
	ldr	r3, .L2752+52
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp, #28]
	ldr	r3, .L2752+40
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp, #12]
	ldr	r3, .L2752+56
	ldrh	r7, [sp, #12]
	ldrh	r3, [r3]
	smulbb	r2, r4, r7
	rsb	r0, r3, #21
	movs	r3, #1
	lsls	r3, r3, r0
	uxth	r2, r2
	uxth	r3, r3
	str	r3, [sp, #20]
.L2734:
	cmp	r4, fp
	bcc	.L2740
	ldr	r3, .L2752+28
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
.L2720:
	ldrb	r2, [r3, #2]	@ zero_extendqisi2
	adds	r3, r3, #4
	and	r2, r2, #31
	bfi	r2, r0, #3, #2
	strb	r2, [r3, #-2]
	b	.L2719
.L2729:
	ldr	r3, .L2752+60
	strh	r0, [r3]	@ movhi
	ldr	r3, .L2752+64
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L2722
	bl	ftl_test_block
.L2722:
	ldr	r3, .L2752+52
	uxth	r1, r4
	ldr	r0, .L2752+24
	movs	r6, #0
	mov	fp, r6
	mov	r8, r6
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldr	r5, [r0]
	str	r3, [sp, #16]
	ldr	r3, .L2752+40
	add	r5, r5, r1, lsl #2
	ldrb	r3, [r3]	@ zero_extendqisi2
	uxth	r2, r3
	str	r2, [sp, #20]
	mul	r2, r3, r1
	ldr	r1, .L2752+32
	ldr	r1, [r1]
	str	r1, [sp, #12]
.L2723:
	ldr	r0, [sp, #16]
	uxth	r1, fp
	cmp	r0, r1
	bhi	.L2741
	cmp	r8, #0
	bne	.L2728
	ldrb	r3, [r5, #2]	@ zero_extendqisi2
	orr	r3, r3, #224
	strb	r3, [r5, #2]
.L2728:
	adds	r4, r4, #1
	b	.L2721
.L2726:
	add	r1, r10, r2
	ldr	r0, [sp, #28]
	str	r3, [sp, #36]
	str	r2, [sp, #32]
	bl	flash_check_bad_block
	ldr	r2, [sp, #32]
	ldr	r3, [sp, #36]
	cbz	r0, .L2724
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
.L2725:
	add	r10, r10, #1
.L2727:
	sub	r1, r10, r6
	ldr	r0, [sp, #20]
	uxth	r1, r1
	cmp	r0, r1
	bhi	.L2726
	add	fp, fp, #1
	add	r6, r6, r3
	subs	r2, r2, r3
	b	.L2723
.L2724:
	add	r8, r8, #1
	uxth	r8, r8
	b	.L2725
.L2741:
	uxtb	r1, fp
	mov	r10, r6
	str	r1, [sp, #28]
	b	.L2727
.L2740:
	ldr	r3, [sp, #24]
	movs	r0, #0
	mov	lr, r0
	mov	ip, r0
	add	r8, r3, r4, lsl #2
	ldrb	r3, [r8, #2]	@ zero_extendqisi2
	orr	r3, r3, #224
	strb	r3, [r8, #2]
.L2735:
	ldr	r6, [sp, #28]
	uxth	r3, ip
	cmp	r3, r6
	bcc	.L2743
	adds	r4, r4, #1
	add	r2, r2, r7
	uxth	r4, r4
	uxth	r2, r2
	b	.L2734
.L2738:
	ldrb	r10, [r8, #3]	@ zero_extendqisi2
	add	r3, lr, r6
	asr	r10, r10, r3
	tst	r10, #1
	bne	.L2736
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
.L2736:
	adds	r6, r6, #1
.L2739:
	uxth	r3, r6
	cmp	r3, r7
	str	r3, [sp, #16]
	bcc	.L2738
	ldr	r3, [sp, #12]
	add	ip, ip, #1
	add	lr, lr, r3
	ldr	r3, [sp, #20]
	add	r0, r0, r3
	uxth	r0, r0
	b	.L2735
.L2743:
	movs	r6, #0
	b	.L2739
.L2753:
	.align	2
.L2752:
	.word	.LANCHOR27
	.word	.LC148
	.word	.LANCHOR188
	.word	.LC0
	.word	.LANCHOR103
	.word	ftl_info_data_buffer
	.word	.LANCHOR7
	.word	.LANCHOR6
	.word	.LANCHOR102
	.word	1229739078
	.word	.LANCHOR67
	.word	.LANCHOR14
	.word	.LC149
	.word	.LANCHOR104
	.word	.LANCHOR66
	.word	.LANCHOR60
	.word	.LANCHOR73
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
	ldr	r0, .L2760
	bl	printf
	bl	sblk_init
	bl	ftl_info_blk_init
	bl	ftl_ext_info_init
	ldr	r2, .L2760+4
	ldr	r3, .L2760+8
	ldrh	r7, [r2]
	ldr	r3, [r3]
	ldr	r2, .L2760+12
	ldrh	r1, [r3, #134]
	ldr	r0, [r2]
	movs	r2, #0
	mov	r5, r2
	mov	r6, r2
	add	r0, r0, r1, lsl #2
.L2755:
	cmp	r1, r7
	bcc	.L2759
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
.L2759:
	ldrb	r4, [r0, #2]	@ zero_extendqisi2
	bfc	r4, #5, #3
	strb	r4, [r0, #2]
	ands	r4, r4, #24
	bne	.L2756
	adds	r6, r6, #1
	uxth	r6, r6
.L2757:
	adds	r1, r1, #1
	uxth	r1, r1
	adds	r0, r0, #4
	b	.L2755
.L2756:
	cmp	r4, #16
	itete	eq
	addeq	r5, r5, #1
	addne	r2, r2, #1
	uxtheq	r5, r5
	uxthne	r2, r2
	b	.L2757
.L2761:
	.align	2
.L2760:
	.word	.LC150
	.word	.LANCHOR6
	.word	.LANCHOR102
	.word	.LANCHOR7
	.size	ftl_re_low_format, .-ftl_re_low_format
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
	push	{r0, r1, r2, lr}
	str	r3, [sp]
	mov	r3, r2
	mov	r2, r1
	ubfx	r1, r0, #0, #21
	ubfx	r0, r0, #21, #3
	bl	ftl_prog_page
	add	sp, sp, #12
	@ sp needed
	ldr	pc, [sp], #4
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
	bne	.L2765
	ldr	r3, .L2767
	ldrh	r5, [r0, #12]
	ldr	r6, [r3]
	bl	ftl_get_new_free_page
	adds	r3, r0, #1
	mov	r7, r0
	beq	.L2766
	ldrh	r0, [r4]
	add	r6, r6, r5, lsl #2
	ldr	r5, .L2767+4
	movs	r4, #0
	bl	ftl_vpn_decrement
	ldr	r3, .L2767+8
	mov	r0, r6
	ldr	r2, .L2767+12
	str	r3, [r5]
	ldr	r3, .L2767+16
	ldrb	r1, [r2]	@ zero_extendqisi2
	ldrh	r3, [r3]
	muls	r1, r3, r1
	lsls	r1, r1, #2
	bl	js_hash
	ldr	r3, .L2767+20
	mov	r2, r5
	str	r0, [r5, #4]
	mov	r1, r6
	mov	r0, r7
	str	r4, [r5, #8]
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r4, [r5, #12]
	bl	ftl_prog_ppa_page
.L2766:
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, pc}
.L2765:
	mov	r0, #-1
	pop	{r3, r4, r5, r6, r7, pc}
.L2768:
	.align	2
.L2767:
	.word	.LANCHOR109
	.word	.LANCHOR176
	.word	-178307901
	.word	.LANCHOR78
	.word	.LANCHOR85
	.word	.LANCHOR123
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
	@ args = 0, pretend = 0, frame = 88
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #96
	ldr	r5, .L2876
	mov	r4, r0
	str	r1, [sp, #24]
	ldr	r3, [r5]
	lsls	r7, r3, #19
	bpl	.L2770
	ldrh	r1, [r0, #2]
	ldr	r0, .L2876+4
	bl	printf
.L2770:
	ldr	r3, [r5]
	lsls	r6, r3, #19
	bpl	.L2771
	ldrb	r1, [r4, #5]	@ zero_extendqisi2
	ldr	r0, .L2876+8
	bl	printf
.L2771:
	ldr	r3, [r5]
	lsls	r0, r3, #19
	bpl	.L2772
	ldrh	r1, [r4]
	ldr	r0, .L2876+12
	bl	printf
.L2772:
	ldr	r3, [r5]
	lsls	r1, r3, #19
	bpl	.L2773
	ldrh	r2, [r4, #18]
	ldrh	r1, [r4, #16]
	ldr	r0, .L2876+16
	bl	printf
.L2773:
	ldrh	r3, [r4, #10]
	ldrh	r2, [r4]
	strh	r3, [r4, #14]	@ movhi
	ldr	r3, .L2876+20
	ldrh	r3, [r3]
	cmp	r2, r3
	bcs	.L2769
	movs	r0, #1
	bl	buf_alloc
	movs	r2, #64
	mov	r5, r0
	movs	r1, #255
	add	r0, sp, #32
	bl	ftl_memset
	ldrb	r6, [r4, #5]	@ zero_extendqisi2
	movs	r3, #2
	ldrh	r7, [r4, #2]
	str	r3, [sp, #12]
	movs	r3, #0
	str	r3, [sp, #16]
.L2775:
	ldr	r3, .L2876+24
	ldrh	r3, [r3]
	cmp	r3, r7
	bhi	.L2788
.L2778:
	ldrh	r3, [r4, #10]
	ldr	r1, .L2876+24
	ldrh	r2, [r4, #6]
	ldrb	r0, [r4, #9]	@ zero_extendqisi2
	strh	r7, [r4, #2]	@ movhi
	add	r2, r2, r3
	ldrh	r3, [r1]
	strb	r6, [r4, #5]
	str	r1, [sp, #20]
	muls	r3, r0, r3
	cmp	r2, r3
	beq	.L2789
	movw	r2, #1493
	ldr	r1, .L2876+28
	ldr	r0, .L2876+32
	bl	printf
.L2789:
	ldr	r3, .L2876+36
	movs	r6, #0
	ldrh	r0, [r4, #10]
	mov	r2, r6
	ldr	r7, [r3]
	str	r3, [sp, #28]
.L2790:
	cmp	r2, r0
	bcc	.L2792
	ldr	r2, [sp, #20]
	ldrb	r3, [r4, #9]	@ zero_extendqisi2
	ldr	r7, .L2876
	ldrh	r2, [r2]
	ldr	r8, .L2876+56
	smulbb	r3, r3, r2
	subs	r3, r3, r0
	add	r6, r6, r3
	ldr	r3, [r7]
	uxth	r6, r6
	tst	r3, #4096
	beq	.L2793
	ldrh	r1, [r4]
	mov	r2, r6
	ldr	r3, [r8]
	ldr	r0, .L2876+40
	ldrh	r3, [r3, r1, lsl #1]
	bl	printf
.L2793:
	ldr	r3, [r8]
	ldrh	r2, [r4]
	strh	r6, [r3, r2, lsl #1]	@ movhi
	ldr	r3, [r7]
	lsls	r0, r3, #17
	bpl	.L2794
	ldr	r3, [sp, #44]
	add	r1, sp, #32
	ldr	r0, .L2876+44
	str	r3, [sp]
	ldm	r1, {r1, r2, r3}
	bl	printf
.L2794:
	ldr	r6, .L2876+48
	movs	r7, #0
	ldr	r8, .L2876
	movs	r1, #0
	ldr	r0, [r5, #4]
	ldrb	r2, [r6]	@ zero_extendqisi2
	lsls	r2, r2, #9
	bl	ftl_memset
	str	r6, [sp, #24]
.L2795:
	ldr	r3, .L2876+52
	ldr	r2, [sp, #12]
	ldrb	r3, [r3]	@ zero_extendqisi2
	muls	r3, r2, r3
	cmp	r7, r3
	bcc	.L2808
	mov	r0, r5
	bl	buf_free
	ldr	r3, [sp, #20]
	ldrh	r2, [r4, #12]
	ldrb	r1, [r4, #9]	@ zero_extendqisi2
	ldrh	r3, [r3]
	mla	r3, r1, r3, r2
	ldr	r2, [sp, #28]
	ldr	r2, [r2]
	add	r3, r3, #1073741824
	subs	r3, r3, #1
	ldr	r3, [r2, r3, lsl #2]
	adds	r3, r3, #1
	beq	.L2809
	movw	r2, #1567
	ldr	r1, .L2876+28
	ldr	r0, .L2876+32
	bl	printf
.L2809:
	ldrh	r3, [r4, #6]
	cmp	r3, #1
	bne	.L2769
	mov	r0, r4
	bl	ftl_write_last_log_page
.L2769:
	add	sp, sp, #96
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2788:
	ldrb	r6, [r4, #5]	@ zero_extendqisi2
.L2776:
	ldrb	r3, [r4, #9]	@ zero_extendqisi2
	cmp	r3, r6
	bhi	.L2787
	movs	r3, #0
	adds	r7, r7, #1
	strb	r3, [r4, #5]
	uxth	r7, r7
	b	.L2775
.L2877:
	.align	2
.L2876:
	.word	.LANCHOR14
	.word	.LC151
	.word	.LC152
	.word	.LC153
	.word	.LC154
	.word	.LANCHOR6
	.word	.LANCHOR85
	.word	.LANCHOR189
	.word	.LC0
	.word	.LANCHOR109
	.word	.LC155
	.word	.LC156
	.word	.LANCHOR123
	.word	.LANCHOR78
	.word	.LANCHOR9
.L2787:
	add	r3, r6, #8
	movw	r2, #65535
	ldrh	r3, [r4, r3, lsl #1]
	cmp	r3, r2
	beq	.L2777
	ldr	r2, .L2878
	ldr	r1, [r5, #4]
	ldrh	r2, [r2]
	mla	r3, r3, r2, r7
	ldr	r2, [r5, #12]
	str	r3, [sp, #20]
	ldr	r3, .L2878+4
	ldr	r0, [sp, #20]
	ldrb	r3, [r3]	@ zero_extendqisi2
	bl	ftl_read_ppa_page
	cmp	r0, #512
	mov	r8, r0
	beq	.L2778
	cmp	r0, #-1
	beq	.L2779
	ldr	r3, [r5, #12]
	ldr	r2, [r3]
	adds	r2, r2, #1
	bne	.L2779
	ldr	r3, [r3, #4]
	adds	r3, r3, #1
	bne	.L2779
	ldr	r3, [r5, #4]
	ldr	r3, [r3]
	adds	r3, r3, #1
	beq	.L2778
.L2779:
	ldr	r3, .L2878+8
	movs	r2, #1
	strb	r2, [r3]
	ldrb	r3, [r4, #9]	@ zero_extendqisi2
	ldrh	r2, [r4, #10]
	mla	r3, r7, r3, r6
	cmp	r2, r3
	beq	.L2780
	movw	r2, #1412
	ldr	r1, .L2878+12
	ldr	r0, .L2878+16
	bl	printf
.L2780:
	ldrh	r3, [r4, #10]
	ldrh	r2, [r4, #6]
	add	r2, r2, r3
	ldr	r3, .L2878+20
	ldrh	r1, [r3]
	ldrb	r3, [r4, #9]	@ zero_extendqisi2
	muls	r3, r1, r3
	cmp	r2, r3
	beq	.L2781
	movw	r2, #1413
	ldr	r1, .L2878+12
	ldr	r0, .L2878+16
	bl	printf
.L2781:
	cmp	r8, #-1
	beq	.L2783
	ldr	r3, [r5, #12]
	ldr	r0, [r3, #4]
	adds	r2, r0, #1
	beq	.L2783
	bl	lpa_hash_get_ppa
	ldr	r3, [sp, #24]
	mov	r8, r0
	cmp	r3, #0
	beq	.L2785
	ldr	r10, [r5, #12]
	ldr	r3, [r10, #8]
	cmp	r0, r3
	beq	.L2785
	cmp	r0, #-1
	beq	.L2785
	ldr	r3, .L2878+24
	mov	fp, #1
	ldr	r2, .L2878+28
	ldrh	r0, [r3]
	ldrb	r1, [r2]	@ zero_extendqisi2
	rsb	r3, r0, #21
	lsl	r3, fp, r3
	lsr	r0, r8, r0
	subs	r3, r3, #1
	ands	r0, r0, r3
	bl	__aeabi_uidiv
	ldr	r3, [sp, #24]
	uxth	r0, r0
	ldrh	r3, [r3]
	cmp	r3, r0
	bne	.L2785
	ldr	r3, [r10]
	mov	r0, r8
	ldr	r10, .L2878+48
	ldr	r1, [r5, #4]
	str	r3, [sp, #12]
	ldr	r3, .L2878+4
	mov	r2, r10
	ldrb	r3, [r3]	@ zero_extendqisi2
	bl	ftl_read_ppa_page
	ldr	r3, [r10]
	ldr	r2, [sp, #12]
	cmp	r2, r3
	bhi	.L2785
	ldr	r3, [r5, #12]
	ldr	r0, [r3, #8]
	adds	r3, r0, #1
	beq	.L2783
	ldr	r3, .L2878+24
	ldrh	r2, [r3]
	rsb	r3, r2, #21
	lsrs	r0, r0, r2
	lsl	r3, fp, r3
	ldr	r2, .L2878+28
	subs	r3, r3, #1
	ands	r0, r0, r3
	ldrb	r1, [r2]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	uxth	r0, r0
	bl	ftl_vpn_decrement
.L2783:
	ldrh	r3, [r4, #6]
	subs	r3, r3, #1
	strh	r3, [r4, #6]	@ movhi
	ldrh	r3, [r4, #10]
	adds	r3, r3, #1
	strh	r3, [r4, #10]	@ movhi
	movs	r3, #4
	str	r3, [sp, #12]
	movs	r3, #1
	str	r3, [sp, #16]
.L2777:
	adds	r6, r6, #1
	uxth	r6, r6
	b	.L2776
.L2792:
	ldrh	r1, [r4, #12]
	add	r1, r1, r2
	adds	r2, r2, #1
	ldr	r3, [r7, r1, lsl #2]
	adds	r3, r3, #1
	itt	ne
	addne	r6, r6, #1
	uxthne	r6, r6
	b	.L2790
.L2808:
	add	fp, sp, #32
	ldr	r0, [fp, r7, lsl #2]
	adds	r1, r0, #1
	bne	.L2796
.L2800:
	ldr	r2, .L2878+32
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
.L2797:
	ldr	r3, [sp, #16]
	cmp	r3, #0
	beq	.L2802
	ldrh	r3, [r4, #6]
	cmp	r3, #1
	bls	.L2802
	ldr	fp, .L2878+52
.L2853:
	mov	r0, r4
	bl	ftl_get_new_free_page
	ldr	r3, [r8]
	mov	r10, r0
	lsls	r0, r3, #17
	bpl	.L2804
	ldr	r3, [r5, #12]
	mov	r1, r10
	mov	r0, fp
	ldr	r2, [r3, #4]
	bl	printf
.L2804:
	ldr	r3, .L2878+36
	ldr	r1, [sp, #12]
	ldrh	r2, [r4, #6]
	ldrb	r3, [r3]	@ zero_extendqisi2
	muls	r3, r1, r3
	adds	r3, r3, #1
	subs	r3, r3, r7
	cmp	r2, r3
	bls	.L2802
	ldr	r3, [sp, #24]
	mov	r0, r10
	ldr	r1, [r5, #4]
	ldr	r2, [r5, #12]
	ldrb	r3, [r3]	@ zero_extendqisi2
	bl	ftl_prog_ppa_page
	mov	r10, r0
	ldrh	r0, [r4]
	bl	ftl_vpn_decrement
	adds	r1, r6, #1
	beq	.L2805
	cmp	r10, #-1
	beq	.L2805
	ldr	r3, [r8]
	lsls	r2, r3, #17
	bpl	.L2806
	ldrh	r2, [r4, #12]
	ldrh	r3, [r4, #10]
	ldr	r1, [r5, #12]
	ldr	r0, .L2878+40
	add	r3, r3, r2
	subs	r3, r3, #1
	ldr	r2, [r1, #8]
	ldr	r1, [r1, #4]
	bl	printf
.L2806:
	ldrh	r1, [r4, #12]
	ldrh	r2, [r4, #10]
	ldr	r3, [r5, #12]
	add	r2, r2, r1
	subs	r2, r2, #1
	ldr	r1, [r3, #8]
	uxth	r2, r2
	ldr	r0, [r3, #4]
	bl	lpa_hash_update_ppa
.L2802:
	adds	r7, r7, #1
	b	.L2795
.L2796:
	ldr	r3, [sp, #24]
	ldr	r2, [r5, #12]
	ldr	r1, [r5, #4]
	ldrb	r3, [r3]	@ zero_extendqisi2
	bl	ftl_read_ppa_page
	ldr	r3, [r5, #12]
	mov	r6, r0
	ldr	r0, [r3, #4]
	bl	lpa_hash_get_ppa
	ldr	r3, [r8]
	mov	r10, r0
	lsls	r2, r3, #17
	bpl	.L2798
	ldr	r3, [r5, #12]
	mov	r1, r0
	ldr	r2, [fp, r7, lsl #2]
	ldr	r0, .L2878+44
	ldr	r3, [r3, #4]
	bl	printf
.L2798:
	ldr	r2, .L2878+32
	add	r3, sp, #32
	ldr	r3, [r3, r7, lsl #2]
	ldr	r1, [r2]
	cmp	r10, r3
	it	ne
	movne	r6, #-1
	ldr	r3, [r5, #12]
	ldr	r2, [r1, #8]
	adds	r0, r2, #1
	str	r0, [r1, #8]
	str	r2, [r3]
	movs	r2, #1
	str	r10, [r3, #8]
	str	r2, [r3, #12]
	adds	r3, r6, #1
	bne	.L2797
	b	.L2800
.L2805:
	ldrh	r3, [r4, #6]
	cmp	r3, #1
	bls	.L2802
	adds	r3, r6, #1
	bne	.L2853
	b	.L2802
.L2879:
	.align	2
.L2878:
	.word	.LANCHOR103
	.word	.LANCHOR123
	.word	.LANCHOR182
	.word	.LANCHOR189
	.word	.LC0
	.word	.LANCHOR85
	.word	.LANCHOR66
	.word	.LANCHOR67
	.word	.LANCHOR102
	.word	.LANCHOR78
	.word	.LC159
	.word	.LC157
	.word	.LANCHOR178
	.word	.LC158
.L2785:
	ldr	r0, [r5, #12]
	ldr	r3, .L2880
	ldr	r2, [r0, #4]
	ldr	r3, [r3]
	cmp	r2, r3
	bcs	.L2783
	ldr	r3, .L2880+4
	ldrb	r1, [r4, #9]	@ zero_extendqisi2
	ldrh	ip, [r4, #10]
	ldrh	r3, [r3]
	muls	r3, r1, r3
	subs	r3, r3, #1
	cmp	ip, r3
	bge	.L2783
	ldr	r3, .L2880+8
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
	ldr	r3, [sp, #20]
	str	r3, [sp, #44]
	b	.L2783
.L2881:
	.align	2
.L2880:
	.word	.LANCHOR120
	.word	.LANCHOR85
	.word	.LANCHOR102
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
	ldr	r7, .L2895
	mov	r8, r1
	mov	r6, r7
.L2883:
	ldr	r3, [r7]
	ldr	r2, [r3, #48]
	ldrh	r1, [r3, #696]
	adds	r2, r2, #1
	str	r2, [r3, #48]
	ldr	r2, .L2895+4
	ldrh	r2, [r2]
	cmp	r1, r2
	bcs	.L2884
	ldrh	r2, [r3, #692]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L2885
.L2884:
	bl	pm_alloc_new_blk
	movs	r0, #0
	bl	ftl_info_flush
.L2885:
	ldr	r3, [r6]
	ldrh	r2, [r3, #692]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L2886
	movs	r2, #230
	ldr	r1, .L2895+8
	ldr	r0, .L2895+12
	bl	printf
.L2886:
	ldr	r3, [r6]
	movs	r1, #0
	ldr	r2, .L2895+16
	ldr	r10, .L2895+32
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
	ldr	r2, .L2895+20
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
	ldr	r3, .L2895+24
	beq	.L2887
	ldrb	r1, [r3]	@ zero_extendqisi2
	cbz	r1, .L2888
.L2887:
	movs	r2, #0
	strb	r2, [r3]
	b	.L2883
.L2888:
	adds	r0, r0, #1
	bne	.L2890
	mov	r1, r5
	ldr	r0, .L2895+28
	bl	printf
	b	.L2883
.L2890:
	ldrh	r3, [r2, #698]
	movs	r0, #0
	cmp	r4, r3
	itt	cc
	addcc	r4, r4, #176
	strcc	r5, [r2, r4, lsl #2]
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L2896:
	.align	2
.L2895:
	.word	.LANCHOR102
	.word	.LANCHOR85
	.word	.LANCHOR190
	.word	.LC0
	.word	.LANCHOR103
	.word	.LANCHOR123
	.word	.LANCHOR192
	.word	.LC160
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
	ldr	r3, .L2926
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r5, r0
	sub	sp, sp, #104
	ldrh	r3, [r3]
	cmp	r3, r0
	bls	.L2897
	ldr	r3, .L2926+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L2899
	ldr	r3, .L2926+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L2897
.L2899:
	ldr	r7, .L2926+12
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
	ldreq	r3, .L2926+16
	movne	r8, #1
	ldrbeq	r8, [r3]	@ zero_extendqisi2
	bl	ftl_get_blk_list_in_sblk
	ldr	r3, .L2926+20
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
	ldr	r0, .L2926+24
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
.L2901:
	ldr	r3, .L2926+20
	uxth	r10, r6
	ldrh	r3, [r3]
	cmp	r3, r10
	bls	.L2907
	mov	r3, r10
	str	r10, [sp, #52]
	lsls	r3, r3, #1
	mov	fp, #0
	subs	r3, r3, #1
	str	r3, [sp, #60]
	b	.L2911
.L2909:
	ldr	r3, [sp, #64]
	add	r2, sp, #104
	add	r3, r2, r3, lsl #1
	ldrh	r3, [r3, #-32]
	str	r3, [sp, #48]
	movw	r3, #65535
	ldr	r2, [sp, #48]
	cmp	r2, r3
	bne	.L2902
.L2908:
	adds	r7, r7, #1
	uxth	r7, r7
.L2903:
	cmp	r8, r7
	bcs	.L2909
	add	fp, fp, #1
.L2911:
	uxth	r3, fp
	str	r3, [sp, #44]
	ldr	r2, [sp, #44]
	ldrb	r3, [sp, #81]	@ zero_extendqisi2
	cmp	r3, r2
	bls	.L2910
	mov	r3, r2
	movs	r7, #1
	adds	r3, r3, #8
	str	r3, [sp, #64]
	b	.L2903
.L2902:
	ldr	r3, .L2926+28
	cmp	r8, #3
	ldr	r2, [sp, #48]
	ldrh	r3, [r3]
	mul	r3, r2, r3
	bne	.L2904
	uxtah	r3, r3, r6
	orr	r3, r3, r7, lsl #24
.L2905:
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
	ldr	r0, .L2926+32
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
	bne	.L2908
.L2907:
	uxth	r2, r6
	ldr	r6, .L2926+36
	ldr	r3, [sp, #44]
	mov	r1, r5
	str	r7, [sp]
	ldr	r0, .L2926+40
	bl	printf
	ldrb	r2, [r6]	@ zero_extendqisi2
	movs	r1, #0
	ldr	r0, [r4, #4]
	ldr	fp, .L2926+4
	lsls	r2, r2, #9
	bl	ftl_memset
	ldrb	r2, [r6]	@ zero_extendqisi2
	movs	r1, #0
	ldr	r0, [r4, #12]
	lsls	r2, r2, #1
	bl	ftl_memset
.L2912:
	ldr	r3, .L2926+20
	ldrh	r3, [r3]
	cmp	r3, r10
	bls	.L2917
	lsl	r3, r10, #1
	movs	r7, #0
	str	r3, [sp, #44]
	b	.L2918
.L2904:
	cmp	r8, #2
	itett	eq
	ldreq	r2, [sp, #60]
	uxtahne	r3, r3, r6
	addeq	r3, r3, r2
	ldreq	r2, .L2926+16
	ittt	eq
	addeq	r3, r3, r7
	ldrbeq	r2, [r2]	@ zero_extendqisi2
	orreq	r3, r3, r2, lsl #24
	b	.L2905
.L2910:
	adds	r6, r6, #1
	b	.L2901
.L2916:
	uxth	r8, r7
	mov	r1, r10
	ldr	r0, .L2926+44
	mov	r2, r8
	bl	printf
	ldrb	ip, [fp]	@ zero_extendqisi2
	add	r2, r8, #8
	ldr	r1, .L2926+28
	cmp	ip, #0
	beq	.L2913
	add	r3, sp, #104
	mov	r0, r4
	add	r2, r3, r2, lsl #1
	ldrh	r3, [r1]
	ldrh	r2, [r2, #-32]
	muls	r3, r2, r3
	orr	r3, r3, r10
	str	r3, [r4, #24]
	bl	sblk_3d_tlc_dump_prog
.L2914:
	adds	r7, r7, #1
.L2918:
	ldrb	r2, [sp, #81]	@ zero_extendqisi2
	uxth	r3, r7
	cmp	r2, r3
	bhi	.L2916
	add	r3, r10, #1
	uxth	r10, r3
	b	.L2912
.L2913:
	ldr	r3, .L2926+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #2
	add	r3, sp, #104
	add	r2, r3, r2, lsl #1
	bne	.L2915
	ldrh	r2, [r2, #-32]
	mov	r0, r4
	ldrh	r3, [r1]
	muls	r3, r2, r3
	ldr	r2, [sp, #44]
	orrs	r3, r3, r2
	orr	r3, r3, #33554432
	str	r3, [r4, #24]
	bl	sblk_mlc_dump_prog
	b	.L2914
.L2915:
	ldrh	r3, [r2, #-32]
	ldrh	r0, [r1]
	muls	r0, r3, r0
	orr	r0, r0, r10
	str	r0, [r4, #24]
	bic	r1, r0, #14680064
	str	ip, [sp, #4]
	ubfx	r0, r0, #21, #3
	ldrb	r3, [r6]	@ zero_extendqisi2
	str	r3, [sp]
	ldr	r3, [r4, #12]
	ldr	r2, [r4, #4]
	bl	flash_prog_page_en
	b	.L2914
.L2917:
	mov	r0, r4
	bl	buf_free
	mov	r1, r5
	ldr	r0, .L2926+48
	bl	printf
.L2897:
	add	sp, sp, #104
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2927:
	.align	2
.L2926:
	.word	.LANCHOR6
	.word	.LANCHOR75
	.word	.LANCHOR72
	.word	.LANCHOR7
	.word	.LANCHOR71
	.word	.LANCHOR85
	.word	.LC161
	.word	.LANCHOR103
	.word	.LC162
	.word	.LANCHOR123
	.word	.LC163
	.word	.LC164
	.word	.LC165
	.size	ftl_dump_write_open_sblk, .-ftl_dump_write_open_sblk
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
	ldr	r3, .L2940
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L2929
	ldr	r2, .L2940+4
	mov	r1, #324
	ldr	r0, .L2940+8
	bl	printf
.L2929:
	ldr	r5, .L2940+12
	movs	r2, #64
	ldr	r6, .L2940+16
	movs	r1, #0
	movs	r7, #0
	ldr	r0, [r5]
	bl	ftl_memset
	movs	r3, #16
	movs	r2, #4
	ldr	r1, [r6]
	ldr	r0, .L2940+20
	bl	rknand_print_hex
	ldr	r4, [r6]
	ldr	r1, [r4, #8]
	add	r0, r4, #16
	bl	js_hash
	str	r5, [sp, #8]
	ldr	r5, .L2940+24
	str	r0, [r4, #12]
	mov	r8, r5
.L2930:
	ldr	fp, .L2940+44
	ldrb	r10, [r5]	@ zero_extendqisi2
	ldrh	r4, [r5, #2]
	ldrh	r3, [fp]
	mov	r1, r10
	ldr	r0, .L2940+28
	mov	r2, r4
	str	r3, [sp, #12]
	bl	printf
	ldr	r2, .L2940+32
	ldrh	r0, [r5, #2]
	ldr	r3, [sp, #12]
	ldrh	r2, [r2]
	subs	r2, r2, #1
	cmp	r0, r2
	blt	.L2931
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
.L2939:
	bl	flash_erase_block
.L2932:
	ldr	r2, [r6]
	mov	r10, #1
	ldr	r3, [sp, #8]
	movs	r0, #0
	ldr	r1, [r2, #4]
	ldr	r3, [r3]
	str	r1, [r3]
	ldr	r1, .L2940+36
	str	r1, [r3, #4]
	movs	r1, #4
	stm	sp, {r1, r10}
	mov	r1, r4
	bl	flash_prog_page_en
	ldrh	r3, [r8, #2]
	adds	r0, r0, #1
	add	r3, r3, r10
	strh	r3, [r8, #2]	@ movhi
	bne	.L2933
	mov	r1, r4
	ldr	r0, .L2940+40
	bl	printf
	b	.L2930
.L2935:
	mov	r7, r10
	b	.L2930
.L2931:
	mla	r4, r10, r3, r4
	cmp	r0, #0
	bne	.L2932
	mov	r1, r4
	b	.L2939
.L2933:
	cmp	r7, #0
	beq	.L2935
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2941:
	.align	2
.L2940:
	.word	.LANCHOR14
	.word	.LANCHOR193
	.word	.LC90
	.word	.LANCHOR194
	.word	.LANCHOR27
	.word	.LC166
	.word	.LANCHOR195
	.word	.LC167
	.word	.LANCHOR140
	.word	1398362953
	.word	.LC168
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
	ldr	r3, .L2971
	ldr	r4, .L2971+4
	ldr	r3, [r3]
	tst	r3, #4096
	beq	.L2943
	ldr	r3, [r4]
	movs	r1, #50
	ldr	r2, .L2971+8
	ldr	r0, .L2971+12
	str	r3, [sp]
	mov	r3, #2048
	bl	printf
.L2943:
	ldr	r7, .L2971+16
	movs	r6, #4
.L2946:
	ldr	r10, .L2971+32
	mov	r8, #4
	ldr	r5, .L2971+20
	movs	r0, #0
	ldr	r2, [r4]
	ldrh	r1, [r10]
	ldr	r3, [r5]
	str	r8, [sp]
	muls	r1, r6, r1
	bl	flash_read_page_en
	adds	r0, r0, #1
	beq	.L2944
	ldr	r2, [r4]
	ldr	r3, [r2]
	cmp	r3, r7
	beq	.L2945
.L2944:
	adds	r6, r6, #1
	cmp	r6, #16
	bne	.L2946
.L2970:
	mov	r0, #-1
.L2942:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2954:
	ldr	r3, [r4]
	ldr	r2, [r3]
	cmp	r2, r7
	bne	.L2955
	ldr	r8, [r3, #4]
.L2948:
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
	beq	.L2949
	ldr	r3, [r4]
	ldr	r2, [r3]
	cmp	r2, r7
	bne	.L2949
	ldr	r2, [r3, #4]
	cmp	r8, r2
	itttt	cc
	ldrbcc	r2, [r3, #37]	@ zero_extendqisi2
	ldrbcc	r3, [r3, #36]	@ zero_extendqisi2
	strbcc	r2, [r6]
	strbcc	r3, [r6, #1]
.L2949:
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
.L2950:
	sub	r0, fp, r6
	sxth	r3, r0
	cmp	r3, #0
	bge	.L2953
	adds	r2, r3, #1
	bne	.L2952
	ldr	r2, [r4]
	ldr	r0, .L2971+24
	str	r3, [sp, #12]
	ldr	r1, [r2]
	bl	printf
	b	.L2970
.L2953:
	str	r8, [sp]
	sub	r1, r10, r6
	ldr	r3, [r5]
	movs	r0, #0
	ldr	r2, [r4]
	bl	flash_read_page_en
	adds	r0, r0, #1
	beq	.L2951
	ldr	r3, [r4]
	ldr	r3, [r3]
	cmp	r3, r7
	beq	.L2952
.L2951:
	adds	r6, r6, #1
	b	.L2950
.L2952:
	cmp	r6, #1
	bls	.L2956
	bl	flash_info_flush
.L2956:
	movs	r0, #0
	b	.L2942
.L2945:
	ldrb	r1, [r2, #36]	@ zero_extendqisi2
	ldrh	r0, [r10]
	ldrb	r3, [r2, #37]	@ zero_extendqisi2
	ldr	r6, .L2971+28
	strb	r1, [r6]
	muls	r1, r0, r1
	strb	r3, [r6, #1]
	movs	r0, #0
	str	r8, [sp]
	ldr	r3, [r5]
	bl	flash_read_page_en
	adds	r0, r0, #1
	bne	.L2954
.L2955:
	mov	r8, #0
	b	.L2948
.L2972:
	.align	2
.L2971:
	.word	.LANCHOR14
	.word	.LANCHOR27
	.word	.LANCHOR196
	.word	.LC169
	.word	1398362953
	.word	.LANCHOR194
	.word	.LC170
	.word	.LANCHOR195
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
	ldr	r6, .L3055
	ldr	r3, [r6]
	lsls	r7, r3, #19
	bpl	.L2974
	ldr	r2, .L3055+4
	movw	r1, #2490
	ldr	r0, .L3055+8
	bl	printf
.L2974:
	ldr	r3, .L3055+12
	mov	r0, r4
	ldr	r7, .L3055+16
	movs	r5, #0
	ldr	r4, .L3055+20
	str	r5, [r3]
	mov	r8, r7
	bl	nandc_init
	ldr	r3, .L3055+24
	movs	r2, #1
	str	r4, [r7]
	mov	r1, r5
	ldr	r7, .L3055+28
	strb	r2, [r3]
	movs	r2, #8
	ldr	r0, .L3055+32
	mov	r10, r7
	bl	ftl_memset
	movs	r2, #32
	mov	r1, r5
	ldr	r0, .L3055+36
	bl	ftl_memset
.L2980:
	lsl	fp, r5, #3
	uxtb	r0, r5
	add	r1, r7, fp
	bl	flash_read_id
	cbnz	r5, .L2975
	ldrb	r3, [r7]	@ zero_extendqisi2
	subs	r3, r3, #1
	uxtb	r3, r3
	cmp	r3, #253
	bls	.L2976
.L2978:
	mvn	r10, #1
.L2973:
	mov	r0, r10
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2976:
	ldrb	r3, [r7, #1]	@ zero_extendqisi2
	cmp	r3, #255
	beq	.L2978
.L2975:
	ldrb	r3, [r10, fp]	@ zero_extendqisi2
	adds	r5, r5, #1
	cmp	r3, #181
	itt	eq
	moveq	r3, #44
	strbeq	r3, [r10, fp]
	cmp	r5, #4
	bne	.L2980
	ldr	r7, .L3055+40
	movs	r5, #0
	ldr	r3, .L3055+28
.L2983:
	mov	r1, r3
	ldrb	r2, [r7, #-1]	@ zero_extendqisi2
	mov	r0, r7
	str	r3, [sp, #4]
	lsl	fp, r5, #5
	bl	flash_mem_cmp8
	ldr	r3, [sp, #4]
	cmp	r0, #0
	bne	.L2981
	ldr	r5, .L3055+44
	ldr	r3, .L3055+48
	add	r5, r5, fp
	ldrb	r2, [r5, #22]	@ zero_extendqisi2
	mov	r1, r3
.L2982:
	lsls	r7, r0, #5
	ldrb	r7, [r7, r3]	@ zero_extendqisi2
	cmp	r7, r2
	beq	.L2984
	adds	r0, r0, #1
	cmp	r0, #4
	bne	.L2982
.L2984:
	add	r1, r1, r0, lsl #5
	movs	r2, #32
	ldr	r0, .L3055+52
	bl	ftl_memcpy
	movs	r2, #32
	mov	r1, r5
	ldr	r0, .L3055+20
	bl	ftl_memcpy
	ldr	r2, .L3055+56
	ldrb	r3, [r2]	@ zero_extendqisi2
	mov	fp, r2
	cmp	r3, #8
	bhi	.L2985
	ldrb	r2, [r4, #20]	@ zero_extendqisi2
	cmp	r2, #60
	bls	.L2986
	movs	r2, #60
	strb	r2, [r4, #20]
.L2986:
	cmp	r3, #8
	bne	.L2985
	ldrb	r3, [r10]	@ zero_extendqisi2
	cmp	r3, #44
	beq	.L2987
	cmp	r3, #137
	bne	.L2985
.L2987:
	ldrb	r3, [r4, #28]	@ zero_extendqisi2
	cmp	r3, #3
	itt	eq
	moveq	r3, #0
	strbeq	r3, [r4, #28]
.L2985:
	ldr	r3, [r6]
	lsls	r5, r3, #19
	bpl	.L2988
	ldr	r2, .L3055+4
	movw	r1, #2515
	ldr	r0, .L3055+8
	bl	printf
.L2988:
	mov	r0, #16384
	ldr	r7, .L3055+60
	bl	ftl_malloc
	ldr	r3, .L3055+64
	mov	r10, #0
	str	r0, [r3]
	mov	r0, #16384
	bl	ftl_malloc
	ldr	r3, .L3055+68
	str	r0, [r3]
	mov	r0, #2048
	bl	ftl_malloc
	str	r0, [r7]
	movs	r0, #64
	bl	ftl_malloc
	ldr	r3, .L3055+72
	str	r0, [r3]
	movs	r0, #64
	bl	ftl_malloc
	ldr	r3, .L3055+76
	str	r0, [r3]
	movs	r0, #64
	bl	ftl_malloc
	ldr	r3, .L3055+80
	str	r0, [r3]
	ldr	r3, .L3055+84
	strb	r10, [r3]
	bl	flash_die_info_init
	ldrb	r0, [r4, #18]	@ zero_extendqisi2
	bl	flash_lsb_page_tbl_build
	ldrb	r0, [r4, #20]	@ zero_extendqisi2
	bl	nandc_bch_sel
	ldr	r2, [r8]
	ldr	r1, .L3055+88
	ldrh	r3, [r2, #16]
	ldrb	r2, [r2, #28]	@ zero_extendqisi2
	mov	r8, r1
	ubfx	r0, r3, #8, #3
	ubfx	r5, r3, #3, #1
	strb	r0, [r1]
	ldr	r0, .L3055+92
	strb	r5, [r0]
	ubfx	r5, r3, #4, #1
	ldr	r0, .L3055+96
	strb	r5, [r0]
	ubfx	r5, r3, #12, #1
	ldr	r0, .L3055+100
	strb	r5, [r0]
	ubfx	r5, r3, #13, #1
	ldr	r0, .L3055+104
	strb	r5, [r0]
	ubfx	r5, r3, #14, #1
	ldr	r0, .L3055+108
	lsrs	r3, r3, #15
	strb	r5, [r0]
	ldr	r0, .L3055+112
	ldr	r5, .L3055+116
	strb	r3, [r0]
	movs	r0, #60
	ldr	r3, .L3055+120
	str	r10, [r5]
	strb	r2, [r3]
	ldr	r3, .L3055+124
	strb	r0, [r3]
	ldrb	r0, [fp]	@ zero_extendqisi2
	cmp	r0, #9
	itt	eq
	moveq	r1, #70
	strbeq	r1, [r3]
	ldr	r3, .L3055+128
	ldrh	r1, [r4, #16]
	strb	r2, [r3]
	ldrb	r2, [r4, #7]	@ zero_extendqisi2
	cmp	r2, #9
	itt	eq
	moveq	r2, #0
	strbeq	r2, [r3]
	tst	r1, #64
	ldrb	r3, [r4, #19]	@ zero_extendqisi2
	ldr	r2, .L3055+132
	strb	r3, [r2]
	mov	r4, r2
	beq	.L2992
	sub	r2, r3, #17
	cmp	r2, #2
	bls	.L2993
	cmp	r3, #21
	bne	.L2994
.L2993:
	ldr	r2, .L3055+136
	cmp	r3, #21
	ldr	r3, .L3055+140
	str	r2, [r5]
	beq	.L3054
	movs	r2, #15
.L3052:
	strb	r2, [r3]
.L2992:
	ldr	r3, [r6]
	lsls	r0, r3, #19
	bpl	.L3004
	ldr	r2, .L3055+4
	movw	r1, #2573
	ldr	r0, .L3055+8
	bl	printf
.L3004:
	ldr	r3, .L3055+144
	movs	r2, #0
	movs	r0, #4
	strb	r2, [r3]
	mov	fp, r3
	ldrb	r2, [r8]	@ zero_extendqisi2
	tst	r2, #1
	beq	.L3005
	bl	nandc_set_if_mode
	movs	r0, #1
	bl	flash_set_interface_mode
	movs	r0, #1
.L3005:
	bl	nandc_set_if_mode
	bl	flash_info_blk_init
	cmp	r0, #-1
	mov	r10, r0
	bne	.L3007
	ldr	r3, [r6]
	lsls	r1, r3, #19
	bpl	.L3008
	ldr	r2, .L3055+4
	movw	r1, #2605
	ldr	r0, .L3055+8
	bl	printf
.L3008:
	ldr	r3, [r7]
	movs	r2, #17
	movs	r0, #0
	strb	r2, [r3, #32]
	bl	zftl_flash_exit_slc_mode
	b	.L2973
.L2981:
	adds	r5, r5, #1
	adds	r7, r7, #32
	cmp	r5, #38
	bne	.L2983
	b	.L2978
.L2994:
	cmp	r3, #33
	beq	.L2997
	sub	r2, r3, #65
	cmp	r2, #1
	bhi	.L2998
.L2997:
	ldr	r3, .L3055+148
	movs	r2, #4
	str	r3, [r5]
	ldr	r3, .L3055+152
	strb	r2, [r3]
.L3053:
	movs	r2, #7
	ldr	r3, .L3055+140
	b	.L3052
.L2998:
	sub	r2, r3, #67
	uxtb	r2, r2
	cmp	r2, #1
	bls	.L2999
	sub	r1, r3, #34
	cmp	r1, #1
	bhi	.L3000
.L2999:
	ldr	r1, .L3055+148
	cmp	r3, #35
	str	r1, [r5]
	ldr	r1, .L3055+140
	beq	.L3001
	cmp	r3, #68
	beq	.L3001
	movs	r3, #7
.L3051:
	cmp	r2, #1
	strb	r3, [r1]
	ldr	r3, .L3055+152
	bhi	.L3003
.L3054:
	movs	r2, #4
	b	.L3052
.L3001:
	movs	r3, #17
	b	.L3051
.L3003:
	movs	r2, #5
	b	.L3052
.L3000:
	subs	r3, r3, #36
	cmp	r3, #1
	bhi	.L2992
	ldr	r3, .L3055+156
	str	r3, [r5]
	b	.L3053
.L3056:
	.align	2
.L3055:
	.word	.LANCHOR14
	.word	.LANCHOR197
	.word	.LC90
	.word	.LANCHOR160
	.word	.LANCHOR16
	.word	.LANCHOR31
	.word	.LANCHOR18
	.word	.LANCHOR42
	.word	.LANCHOR30
	.word	.LANCHOR141
	.word	.LANCHOR198+1
	.word	.LANCHOR198
	.word	.LANCHOR199
	.word	.LANCHOR20
	.word	.LANCHOR28
	.word	.LANCHOR27
	.word	.LANCHOR164
	.word	.LANCHOR156
	.word	.LANCHOR163
	.word	.LANCHOR158
	.word	.LANCHOR194
	.word	.LANCHOR200
	.word	.LANCHOR43
	.word	.LANCHOR168
	.word	.LANCHOR39
	.word	.LANCHOR75
	.word	.LANCHOR72
	.word	.LANCHOR1
	.word	.LANCHOR73
	.word	.LANCHOR162
	.word	.LANCHOR0
	.word	.LANCHOR17
	.word	.LANCHOR19
	.word	.LANCHOR23
	.word	micron_read_retrial
	.word	.LANCHOR159
	.word	.LANCHOR21
	.word	toshiba_read_retrial
	.word	.LANCHOR26
	.word	toshiba_3d_read_retrial
.L3007:
	ldrb	r3, [r4]	@ zero_extendqisi2
	subs	r3, r3, #1
	cmp	r3, #7
	itt	ls
	ldrls	r3, .L3057
	strls	r3, [r5]
	ldrb	r3, [r8]	@ zero_extendqisi2
	lsls	r2, r3, #29
	bpl	.L3011
	ldr	r3, [r7]
	ldrb	r3, [r3, #19]	@ zero_extendqisi2
	cbz	r3, .L3011
	ldr	r2, .L3057+4
	movs	r0, #0
	ldr	r3, .L3057+8
	ldrh	r1, [r2]
	ldrb	r3, [r3]	@ zero_extendqisi2
	muls	r1, r3, r1
	bl	flash_ddr_para_scan
	ldrb	r3, [fp]	@ zero_extendqisi2
	cbnz	r3, .L3011
	ldr	r2, [r7]
	strb	r3, [r2, #19]
	bl	flash_info_flush
.L3011:
	ldr	r3, [r6]
	lsls	r3, r3, #19
	bpl	.L3013
	ldr	r2, .L3057+12
	movw	r1, #2671
	ldr	r0, .L3057+16
	bl	printf
.L3013:
	bl	nand_flash_print_info
	mov	r10, #0
	b	.L2973
.L3058:
	.align	2
.L3057:
	.word	hynix_read_retrial
	.word	.LANCHOR2
	.word	.LANCHOR195
	.word	.LANCHOR197
	.word	.LC90
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
.L3060:
	ldr	r3, .L3069
	ldrh	r2, [r3]
	uxth	r3, r6
	cmp	r2, r3
	bhi	.L3062
	ldr	r1, [sp, #44]
	movs	r3, #32
	ldr	r0, .L3069+4
	movs	r2, #4
	add	r1, r1, #704
	bl	rknand_print_hex
	mov	r0, r4
	bl	buf_free
	cbz	r5, .L3063
	movw	r2, #1351
	ldr	r1, .L3069+8
	ldr	r0, .L3069+12
	bl	printf
.L3063:
	mov	r0, r5
	add	sp, sp, #48
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3062:
	ldr	r3, .L3069+16
	uxth	r7, r6
	ldr	r2, [r4, #12]
	ldr	r1, [r4, #4]
	ldrh	r8, [r3]
	ldr	r3, .L3069+20
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
	ldr	r0, .L3069+24
	str	r3, [sp, #4]
	mov	r3, r8
	bl	printf
	cmp	r10, #-1
	beq	.L3064
	cmp	r10, #512
	it	eq
	moveq	r5, #1
.L3061:
	adds	r6, r6, #1
	b	.L3060
.L3064:
	movs	r5, #1
	b	.L3061
.L3070:
	.align	2
.L3069:
	.word	.LANCHOR85
	.word	.LC171
	.word	.LANCHOR201
	.word	.LC0
	.word	.LANCHOR103
	.word	.LANCHOR123
	.word	.LC162
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
	ldr	r3, .L3072
	push	{r0, r1, r2, r4, r5, r6, r7, lr}
	ldr	r0, .L3072+4
	ldrb	r1, [r3]	@ zero_extendqisi2
	bl	printf
	ldr	r1, .L3072+8
	ldr	r5, .L3072+12
	ldr	r0, .L3072+16
	ldrh	r3, [r1, #2]
	ldrb	r2, [r1, #1]	@ zero_extendqisi2
	ldrb	r1, [r1]	@ zero_extendqisi2
	bl	printf
	ldr	r3, [r5]
	ldr	r4, .L3072+20
	ldr	r0, .L3072+24
	ldrh	r2, [r3, #140]
	ldrh	r1, [r3, #130]
	bl	printf
	ldr	r0, [r4]
	ldr	r7, .L3072+28
	ldrh	r6, [r0, #26]
	ldrb	r3, [r0, #21]	@ zero_extendqisi2
	ldrh	r2, [r0, #18]
	ldrh	r1, [r0, #16]
	str	r6, [sp, #4]
	ldrh	r0, [r0, #22]
	str	r0, [sp]
	ldr	r0, .L3072+32
	bl	printf
	ldr	r0, [r4]
	ldrh	r6, [r0, #58]
	ldrb	r3, [r0, #53]	@ zero_extendqisi2
	ldrh	r2, [r0, #50]
	ldrh	r1, [r0, #48]
	str	r6, [sp, #4]
	ldrh	r0, [r0, #54]
	ldr	r6, .L3072+36
	str	r0, [sp]
	ldr	r0, .L3072+40
	bl	printf
	ldr	r0, [r4]
	ldrh	r4, [r0, #90]
	ldrb	r3, [r0, #85]	@ zero_extendqisi2
	ldrh	r2, [r0, #82]
	ldrh	r1, [r0, #80]
	str	r4, [sp, #4]
	ldrh	r0, [r0, #86]
	ldr	r4, .L3072+44
	str	r0, [sp]
	ldr	r0, .L3072+48
	bl	printf
	ldrh	r2, [r6]
	ldrb	r3, [r4]	@ zero_extendqisi2
	ldr	r1, .L3072+52
	ldr	r0, .L3072+56
	muls	r3, r2, r3
	ldr	r1, [r1]
	movs	r2, #4
	lsls	r3, r3, #1
	bl	rknand_print_hex
	ldr	r1, .L3072+60
	movs	r2, #2
	ldrh	r3, [r7]
	ldr	r0, .L3072+64
	ldr	r1, [r1]
	bl	rknand_print_hex
	ldr	r1, [r5]
	movs	r2, #4
	ldr	r0, .L3072+68
	ldrh	r3, [r1, #698]
	add	r1, r1, #704
	bl	rknand_print_hex
	ldr	r1, .L3072+72
	movs	r2, #4
	ldrh	r3, [r7]
	ldr	r0, .L3072+76
	ldr	r1, [r1]
	bl	rknand_print_hex
	mov	r3, #256
	movs	r2, #2
	ldr	r1, .L3072+80
	ldr	r0, .L3072+84
	bl	rknand_print_hex
	ldrh	r2, [r6]
	ldrb	r3, [r4]	@ zero_extendqisi2
	ldr	r1, .L3072+88
	ldr	r0, .L3072+92
	muls	r3, r2, r3
	ldr	r1, [r1]
	movs	r2, #2
	lsls	r3, r3, #1
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, lr}
	b	rknand_print_hex
.L3073:
	.align	2
.L3072:
	.word	.LANCHOR52
	.word	.LC172
	.word	.LANCHOR179
	.word	.LANCHOR102
	.word	.LC173
	.word	.LANCHOR10
	.word	.LC174
	.word	.LANCHOR6
	.word	.LC175
	.word	.LANCHOR85
	.word	.LC176
	.word	.LANCHOR78
	.word	.LC177
	.word	.LANCHOR109
	.word	.LC178
	.word	.LANCHOR9
	.word	.LC179
	.word	.LC171
	.word	.LANCHOR7
	.word	.LC180
	.word	.LANCHOR108
	.word	.LC181
	.word	.LANCHOR110
	.word	.LC182
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
	mov	r5, r0
	ldr	r3, .L3081
	movs	r4, #1
	mov	r6, r1
	mov	r7, r2
	ldrh	r0, [r3]
	rsb	r3, r0, #21
	lsls	r4, r4, r3
	ldr	r3, .L3081+4
	lsr	r0, r2, r0
	subs	r4, r4, #1
	ldrb	r1, [r3]	@ zero_extendqisi2
	ands	r0, r0, r4
	bl	__aeabi_uidiv
	ldr	r3, .L3081+8
	uxth	r0, r0
	ldr	r3, [r3]
	add	r0, r3, r0, lsl #2
	ldrb	r1, [r0, #2]	@ zero_extendqisi2
	lsrs	r1, r1, #5
	cmp	r1, #1
	beq	.L3075
	cmp	r1, #7
	bne	.L3077
.L3075:
	mov	r3, r7
	mov	r2, r6
	mov	r1, r5
	ldr	r0, .L3081+12
	bl	printf
	bl	dump_ftl_info
	mov	r0, #-1
	pop	{r3, r4, r5, r6, r7, pc}
.L3077:
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, pc}
.L3082:
	.align	2
.L3081:
	.word	.LANCHOR66
	.word	.LANCHOR67
	.word	.LANCHOR7
	.word	.LC183
	.size	pm_ppa_update_check, .-pm_ppa_update_check
	.section	.text.load_l2p_region,"ax",%progbits
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	load_l2p_region, %function
load_l2p_region:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	cmp	r1, #31
	push	{r0, r1, r2, r4, r5, r6, r7, r8, r10, lr}
	mov	r4, r0
	mov	r5, r1
	bls	.L3084
	movs	r2, #31
	ldr	r1, .L3092
	ldr	r0, .L3092+4
	bl	printf
.L3084:
	ldr	r8, .L3092+44
	ldr	r3, [r8]
	ldrh	r2, [r3, #698]
	cmp	r2, r4
	bcs	.L3085
	mov	r1, r4
	ldr	r0, .L3092+8
	bl	printf
	ldr	r3, .L3092+12
	movs	r1, #255
	ldrh	r2, [r3]
	movs	r3, #0
	ldr	r0, [r3, #4]
	bl	ftl_memset
	ldr	r3, [r8]
	ldrh	r3, [r3, #698]
	cmp	r3, r4
	bcs	.L3087
	movs	r2, #35
.L3091:
	ldr	r1, .L3092
	ldr	r0, .L3092+4
	bl	printf
	b	.L3087
.L3085:
	add	r2, r4, #176
	ldr	r7, [r3, r2, lsl #2]
	ldr	r3, .L3092+16
	strh	r4, [r3, r5, lsl #3]	@ movhi
	add	r5, r3, r5, lsl #3
	movs	r3, #0
	strh	r3, [r5, #2]	@ movhi
	cbnz	r7, .L3088
	mov	r2, r7
	mov	r1, r4
	ldr	r0, .L3092+20
	bl	printf
	ldr	r3, .L3092+12
	movs	r1, #255
	ldr	r0, [r5, #4]
	ldrh	r2, [r3]
	bl	ftl_memset
.L3087:
	movs	r0, #0
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L3088:
	ldr	r6, .L3092+24
	mov	r0, r7
	ldr	r10, .L3092+48
	ldr	r1, [r5, #4]
	ldr	r2, [r6]
	ldrb	r3, [r10]	@ zero_extendqisi2
	bl	ftl_read_ppa_page
	ldr	r2, [r6]
	mov	r3, r0
	ldr	r2, [r2]
	cmp	r2, r4
	beq	.L3089
	mov	r1, r4
	str	r7, [sp]
	ldr	r0, .L3092+28
	bl	printf
	ldr	r1, [r8]
	movs	r2, #4
	ldr	r0, .L3092+32
	ldrh	r3, [r1, #698]
	add	r1, r1, #704
	bl	rknand_print_hex
	ldrb	r3, [r10]	@ zero_extendqisi2
	movs	r2, #4
	ldr	r1, [r5, #4]
	ldr	r0, .L3092+36
	lsls	r3, r3, #7
	bl	rknand_print_hex
	movs	r3, #16
	movs	r2, #4
	ldr	r1, [r6]
	ldr	r0, .L3092+40
	bl	rknand_print_hex
.L3089:
	ldr	r3, [r6]
	ldr	r3, [r3]
	cmp	r4, r3
	beq	.L3087
	movs	r2, #59
	b	.L3091
.L3093:
	.align	2
.L3092:
	.word	.LANCHOR202
	.word	.LC0
	.word	.LC184
	.word	.LANCHOR203
	.word	.LANCHOR132
	.word	.LC185
	.word	.LANCHOR191
	.word	.LC186
	.word	.LC187
	.word	.LC188
	.word	.LC189
	.word	.LANCHOR102
	.word	.LANCHOR123
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
	ldr	r4, .L3106
	ldr	r5, .L3106+4
	ldr	r3, [r4]
	ldrh	r2, [r3, #688]
	ldrh	r3, [r5]
	subs	r3, r3, #1
	cmp	r2, r3
	blt	.L3096
	bl	pm_free_sblk
	ldr	r2, [r4]
	ldrh	r3, [r5]
	ldrh	r1, [r2, #688]
	subs	r3, r3, #1
	cmp	r1, r3
	blt	.L3096
	uxth	r0, r0
	movw	r3, #65535
	adds	r0, r0, #208
	ldrh	r7, [r2, r0, lsl #1]
	cmp	r7, r3
	bne	.L3098
	movs	r2, #131
	ldr	r1, .L3106+8
	ldr	r0, .L3106+12
	bl	printf
	bl	pm_free_sblk
	ldr	r3, [r4]
	uxth	r0, r0
	adds	r0, r0, #208
	ldrh	r7, [r3, r0, lsl #1]
.L3098:
	ldr	r5, .L3106+16
	bl	pm_select_ram_region
	mov	r6, r0
	movw	r3, #65535
	ldrh	r0, [r5, r0, lsl #3]
	cmp	r0, r3
	beq	.L3099
	add	r8, r5, r6, lsl #3
	ldr	r1, [r8, #4]
	cbz	r1, .L3099
	ldrsh	r3, [r8, #2]
	cmp	r3, #0
	bge	.L3099
	bl	pm_write_page
	ldrh	r3, [r8, #2]
	ubfx	r3, r3, #0, #15
	strh	r3, [r8, #2]	@ movhi
.L3099:
	mov	fp, #0
.L3100:
	ldr	r1, [r4]
	uxth	r10, fp
	ldrh	r0, [r1, #698]
	cmp	r0, r10
	bhi	.L3102
	bl	pm_free_sblk
.L3096:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3102:
	ldr	r3, .L3106+20
	uxth	r8, fp
	add	ip, r8, #176
	ldrh	r0, [r3]
	ldr	r1, [r1, ip, lsl #2]
	ldr	r3, .L3106+24
	lsr	ip, r1, r0
	rsb	r1, r0, #21
	movs	r0, #1
	lsls	r0, r0, r1
	ldrb	r1, [r3]	@ zero_extendqisi2
	subs	r0, r0, #1
	and	r0, ip, r0
	bl	__aeabi_uidiv
	uxth	r0, r0
	cmp	r0, r7
	bne	.L3101
	mov	r1, r6
	mov	r0, r10
	bl	load_l2p_region
	add	r2, r5, r6, lsl #3
	mov	r0, r8
	ldr	r1, [r2, #4]
	bl	pm_write_page
	movw	r2, #65535
	strh	r2, [r5, r6, lsl #3]	@ movhi
.L3101:
	add	fp, fp, #1
	b	.L3100
.L3107:
	.align	2
.L3106:
	.word	.LANCHOR102
	.word	.LANCHOR146
	.word	.LANCHOR204
	.word	.LC0
	.word	.LANCHOR132
	.word	.LANCHOR66
	.word	.LANCHOR67
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
	ldr	r3, .L3113
	push	{r4, lr}
	add	r4, r3, r0, lsl #3
	ldrh	r0, [r3, r0, lsl #3]
	ldr	r1, [r4, #4]
	bl	pm_write_page
	ldrh	r3, [r4, #2]
	ubfx	r3, r3, #0, #15
	strh	r3, [r4, #2]	@ movhi
	ldr	r4, .L3113+4
	ldr	r3, [r4]
	cbz	r3, .L3109
	bl	pm_gc
	movs	r3, #0
	str	r3, [r4]
.L3109:
	movs	r0, #0
	pop	{r4, pc}
.L3114:
	.align	2
.L3113:
	.word	.LANCHOR132
	.word	.LANCHOR130
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
	ldr	r5, .L3119
.L3117:
	add	r3, r5, r4, lsl #3
	uxth	r0, r4
	ldrsh	r3, [r3, #2]
	cmp	r3, #0
	bge	.L3116
	bl	pm_flush_id
.L3116:
	adds	r4, r4, #1
	cmp	r4, #32
	bne	.L3117
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L3120:
	.align	2
.L3119:
	.word	.LANCHOR132
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
	ldr	r3, .L3141
	movs	r2, #1
	mov	r10, r0
	movs	r0, #64
	ldr	r5, .L3141+4
	str	r4, [r3]
	ldr	r3, .L3141+8
	mov	r7, r5
	strb	r2, [r3]
	bl	ftl_malloc
	ldr	r3, .L3141+12
	mov	r8, r3
	str	r0, [r3]
.L3126:
	movw	r3, #65535
	adds	r6, r5, r4
	strh	r3, [r4, r5]	@ movhi
	movs	r3, #0
	strh	r3, [r6, #2]	@ movhi
	cmp	r10, #0
	beq	.L3125
	ldr	r3, .L3141+16
	ldrb	r0, [r3]	@ zero_extendqisi2
	lsls	r0, r0, #9
	bl	ftl_malloc
	str	r0, [r6, #4]
.L3125:
	adds	r4, r4, #8
	cmp	r4, #256
	bne	.L3126
	ldr	r3, [r7, #4]
	ldr	r4, .L3141+20
	ldr	r10, [r8]
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
	mov	r5, r0
	ldrh	r2, [r1, #696]
	cmp	r2, r0
	bgt	.L3127
	mov	r3, r0
	ldrh	r1, [r1, #692]
	ldr	r0, .L3141+24
	bl	printf
	ldr	r3, [r4]
	ldrsh	r6, [r3, #696]
.L3128:
	cmp	r6, r5
	ble	.L3130
	ldr	r3, .L3141+28
	movs	r2, #1
	add	r5, r5, r2
	strb	r2, [r3]
	ldr	r3, [r4]
	strh	r5, [r3, #696]	@ movhi
	bl	pm_free_sblk
.L3127:
	ldr	r1, [r7, #4]
	mov	r0, #-1
	bl	pm_write_page
	ldr	r1, [r7, #4]
	mov	r0, #-1
	bl	pm_write_page
	ldr	r1, [r7, #4]
	mov	r0, #-1
	bl	pm_write_page
	ldr	r1, [r7, #4]
	mov	r0, #-1
	bl	pm_write_page
	bl	pm_free_sblk
	bl	pm_gc
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3130:
	ldr	r3, [r4]
	ldr	r2, .L3141+32
	ldrh	r8, [r3, #692]
	ldrh	r2, [r2]
	ldrb	r0, [r3, #694]	@ zero_extendqisi2
	ldr	r3, .L3141+16
	mla	r8, r2, r8, r6
	ldr	r2, [sp, #12]
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r1, r8
	str	r3, [sp]
	mov	r3, r10
	bl	flash_read_page_en
	ldr	r3, [r4]
	mov	fp, r0
	ldr	r0, .L3141+36
	ldr	r2, [r3, #48]
	adds	r2, r2, #1
	str	r2, [r3, #48]
	mov	r2, r8
	ldrh	r3, [r3, #694]
	ldr	r1, [r10]
	bl	printf
	cmp	fp, #-1
	beq	.L3129
	cmp	fp, #512
	beq	.L3129
	ldr	r2, [r4]
	ldr	r3, [r10]
	ldrh	r1, [r2, #698]
	cmp	r3, r1
	itt	cc
	addcc	r3, r3, #176
	strcc	r8, [r2, r3, lsl #2]
.L3129:
	adds	r6, r6, #1
	sxth	r6, r6
	b	.L3128
.L3142:
	.align	2
.L3141:
	.word	.LANCHOR130
	.word	.LANCHOR132
	.word	.LANCHOR192
	.word	.LANCHOR191
	.word	.LANCHOR123
	.word	.LANCHOR102
	.word	.LC190
	.word	.LANCHOR182
	.word	.LANCHOR103
	.word	.LC191
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
	ldr	r3, .L3158
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	fp, r0
	str	r2, [sp, #4]
	mov	r7, r1
	ldr	r2, [r3]
	cmp	r0, r2
	bcc	.L3144
	mov	r1, r0
	ldr	r0, .L3158+4
	bl	printf
	ldr	r3, [sp, #4]
	mov	r0, #-1
	cbnz	r3, .L3143
	str	r0, [r7]
.L3143:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3144:
	ldr	r3, .L3158+8
	ldrb	r5, [r3]	@ zero_extendqisi2
	lsls	r1, r5, #7
	bl	__aeabi_uidiv
	ldr	r1, .L3158+12
	uxth	r6, r0
	mov	r10, r0
	movs	r2, #0
	mov	r8, r1
.L3150:
	add	r0, r1, r2, lsl #3
	uxth	r4, r2
	ldr	r0, [r0, #4]
	cbz	r0, .L3146
	ldrh	r0, [r1, r2, lsl #3]
	cmp	r0, r6
	bne	.L3146
.L3147:
	lsls	r5, r5, #7
	ldr	r3, [sp, #4]
	lsls	r4, r4, #3
	smulbb	r5, r5, r6
	sub	r5, fp, r5
	uxth	r5, r5
	cbnz	r3, .L3148
	add	r2, r8, r4
	ldr	r2, [r2, #4]
	ldr	r2, [r2, r5, lsl #2]
	str	r2, [r7]
.L3149:
	add	r4, r4, r8
	movw	r2, #32767
	ldrh	r3, [r4, #2]
	ubfx	r1, r3, #0, #15
	cmp	r1, r2
	beq	.L3153
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
.L3153:
	movs	r0, #0
	b	.L3143
.L3148:
	add	r1, r8, r4
	ldr	r0, [r7]
	ldr	r2, [r1, #4]
	str	r0, [r2, r5, lsl #2]
	ldrh	r2, [r1, #2]
	mvn	r2, r2, lsl #17
	mvn	r2, r2, lsr #17
	strh	r2, [r1, #2]	@ movhi
	ldr	r2, .L3158+16
	strb	r10, [r2]
	b	.L3149
.L3146:
	adds	r2, r2, #1
	cmp	r2, #32
	bne	.L3150
	bl	pm_select_ram_region
	ldrh	r1, [r8, r0, lsl #3]
	movw	r2, #65535
	mov	r4, r0
	cmp	r1, r2
	beq	.L3151
	add	r2, r8, r0, lsl #3
	ldrsh	r2, [r2, #2]
	cmp	r2, #0
	bge	.L3151
	bl	pm_flush_id
.L3151:
	ldr	r2, .L3158+20
	mov	r1, r4
	mov	r0, r6
	strb	r4, [r2]
	bl	load_l2p_region
	b	.L3147
.L3159:
	.align	2
.L3158:
	.word	.LANCHOR120
	.word	.LC192
	.word	.LANCHOR123
	.word	.LANCHOR132
	.word	.LANCHOR133
	.word	.LANCHOR205
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
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r4, #0
	ldr	r3, .L3216
	sub	sp, sp, #64
	ldr	r7, .L3216+4
	strb	r4, [r3]
	ldr	r3, .L3216+8
	ldr	r5, [r7]
	strb	r4, [r3]
	bl	gc_init
	ldrh	r6, [r5, #80]
	movw	r3, #65535
	cmp	r6, r3
	beq	.L3161
	ldr	r2, [r7]
	movs	r0, #1
	ldr	r6, .L3216+12
	strh	r3, [r2, #130]	@ movhi
	bl	buf_alloc
	ldrb	r3, [r5, #89]	@ zero_extendqisi2
	mov	r4, r0
	add	r3, r5, r3, lsl #1
	ldrh	r2, [r3, #94]
	ldr	r3, .L3216+16
	ldrh	r3, [r3]
	muls	r3, r2, r3
	ldrb	r2, [r6]	@ zero_extendqisi2
	cmp	r2, #3
	str	r3, [sp, #56]
	bne	.L3162
	ldr	r2, .L3216+20
	ldrh	r2, [r2]
	subs	r2, r2, #1
	add	r3, r3, r2
	orr	r3, r3, #50331648
.L3211:
	str	r3, [r4, #24]
.L3163:
	movs	r1, #1
	mov	r0, r4
	bl	sblk_read_page
	ldr	r3, [r4, #36]
	adds	r2, r3, #1
	beq	.L3164
	cmp	r3, #512
	beq	.L3164
	ldr	r3, [r4, #12]
	ldr	r2, [r3]
	ldr	r3, .L3216+24
	cmp	r2, r3
	beq	.L3165
.L3164:
	mov	r0, r4
	bl	buf_free
	ldr	r2, [r4, #12]
	ldr	r3, [r4, #4]
	ldr	r0, .L3216+28
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
	ldr	r2, [r4, #36]
	ldr	r3, [r3]
	ldr	r1, [r4, #24]
	movs	r4, #0
	bl	printf
	ldr	r3, .L3216+32
	ldrh	r2, [r5, #80]
	ldr	r3, [r3]
	strh	r4, [r3, r2, lsl #1]	@ movhi
	ldr	r3, [r7]
.L3215:
	ldrh	r2, [r5, #80]
	strh	r2, [r3, #130]	@ movhi
.L3166:
	ldrh	r0, [r5, #80]
	bl	ftl_dump_write_open_sblk
	mov	r2, r4
	ldrh	r1, [r5, #80]
	movw	r4, #65535
	ldr	r0, .L3216+36
	bl	printf
	strh	r4, [r5, #80]	@ movhi
	bl	pm_flush
	bl	ftl_ext_info_flush
	ldr	r3, .L3216+4
	ldr	r2, [r3]
	ldrh	r0, [r2, #130]
	cmp	r0, r4
	mov	r4, r3
	beq	.L3193
	bl	ftl_free_sblk
.L3193:
	ldr	r3, .L3216+40
	movs	r0, #0
	ldr	r2, [r3]
	movw	r3, #65535
	strh	r3, [r2, #126]	@ movhi
	ldr	r2, [r4]
	strh	r3, [r2, #130]	@ movhi
	bl	ftl_info_flush
.L3160:
	add	sp, sp, #64
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3162:
	cmp	r2, #2
	bne	.L3163
	ldr	r2, .L3216+20
	ldrh	r2, [r2]
	add	r3, r3, r2, lsl #1
	subs	r3, r3, #1
	orr	r3, r3, #33554432
	b	.L3211
.L3165:
	ldr	r8, .L3216+60
	ldr	r7, .L3216+44
	ldr	r1, [r4, #4]
	ldrh	r3, [r8]
	ldrb	r2, [r7]	@ zero_extendqisi2
	muls	r2, r3, r2
	ldr	r3, .L3216+48
	ldr	r0, [r3]
	lsls	r2, r2, #2
	bl	ftl_memcpy
	ldrh	r3, [r8]
	ldrb	r2, [r7]	@ zero_extendqisi2
	ldr	r1, [r4, #4]
	muls	r2, r3, r2
	ldr	r3, .L3216+52
	ldr	r0, [r3]
	lsls	r2, r2, #2
	add	r1, r1, r2
	bl	ftl_memcpy
	ldr	r3, .L3216+20
	ldrh	fp, [r3]
	ldrb	r3, [r6]	@ zero_extendqisi2
	cmp	r3, #2
	itt	eq
	moveq	r3, #1
	lsleq	fp, fp, #1
	str	r3, [sp, #36]
	movs	r3, #0
	mov	r10, r3
	str	r3, [sp, #32]
.L3169:
	ldr	r3, [sp, #32]
	cmp	r3, fp
	beq	.L3178
	mov	r8, #0
	b	.L3179
.L3175:
	ldr	r3, [sp, #40]
	ldrh	r2, [r3, #96]
	ldr	r3, .L3216+16
	ldrh	r3, [r3]
	muls	r3, r2, r3
	ldr	r2, .L3216+12
	ldrb	r2, [r2]	@ zero_extendqisi2
	str	r3, [sp, #56]
	cmp	r2, #3
	bne	.L3170
	ldr	r2, [sp, #32]
	add	r3, r3, r2
	orr	r3, r3, r7, lsl #24
.L3213:
	str	r3, [r4, #24]
	movs	r1, #1
	mov	r0, r4
	bl	sblk_read_page
	ldr	r3, .L3216+48
	ldr	r2, [r4, #12]
	ldr	r3, [r3]
	ldr	r1, [r2, #4]
	ldr	r3, [r3, r6]
	cmp	r3, r1
	bne	.L3173
	ldr	r0, .L3216+52
	ldr	r0, [r0]
	ldr	ip, [r0, r6]
	ldr	r0, [r2, #8]
	cmp	ip, r0
	beq	.L3174
.L3173:
	ldr	r0, [r2, #12]
	str	r0, [sp, #16]
	ldr	r0, [r2, #8]
	str	r1, [sp, #8]
	str	r0, [sp, #12]
	ldr	r2, [r2]
	ldr	r0, .L3216+56
	str	r2, [sp, #4]
	ldr	r2, .L3216+52
	ldr	r2, [r2]
	ldr	r2, [r2, r6]
	str	r2, [sp]
	ldr	r2, [r4, #36]
	ldr	r1, [r4, #24]
	bl	printf
	ldr	r3, .L3216+48
	ldr	r3, [r3]
	ldr	r3, [r3, r6]
	adds	r3, r3, #1
	beq	.L3174
	mov	r0, r4
	movs	r4, #0
	bl	buf_free
	ldr	r3, .L3216+32
	ldrh	r2, [r5, #80]
	ldr	r3, [r3]
	strh	r4, [r3, r2, lsl #1]	@ movhi
	ldr	r3, .L3216+4
	ldr	r3, [r3]
	b	.L3215
.L3170:
	cmp	r2, #2
	ldr	r2, [sp, #32]
	itett	eq
	addeq	r2, r2, #-1
	addne	r3, r3, r2
	addeq	r3, r3, r2
	addeq	r3, r3, r7
	it	eq
	orreq	r3, r3, #33554432
	b	.L3213
.L3174:
	add	r10, r10, #1
	adds	r7, r7, #1
	adds	r6, r6, #4
.L3177:
	ldr	r3, [sp, #36]
	cmp	r3, r7
	bcs	.L3175
	add	r8, r8, #1
.L3179:
	ldrb	r3, [r5, #89]	@ zero_extendqisi2
	cmp	r8, r3
	bge	.L3176
	add	r3, r5, r8, lsl #1
	lsl	r6, r10, #2
	str	r3, [sp, #40]
	movs	r7, #1
	b	.L3177
.L3176:
	ldr	r3, [sp, #32]
	adds	r3, r3, #1
	str	r3, [sp, #32]
	b	.L3169
.L3178:
	mov	r0, r4
	movs	r4, #0
	bl	buf_free
	ldr	r3, .L3216+32
	mov	r6, r4
	ldr	r0, .L3216+60
	mov	fp, r4
	ldrh	r1, [r5, #80]
	ldr	r2, [r3]
	ldrh	r0, [r0]
	ldrb	r3, [r5, #89]	@ zero_extendqisi2
	smulbb	r3, r3, r0
	strh	r3, [r2, r1, lsl #1]	@ movhi
.L3180:
	ldr	r3, [sp, #32]
	cmp	r3, r6
	beq	.L3191
	mov	r10, #0
	b	.L3192
.L3217:
	.align	2
.L3216:
	.word	.LANCHOR76
	.word	.LANCHOR10
	.word	.LANCHOR150
	.word	.LANCHOR71
	.word	.LANCHOR103
	.word	.LANCHOR85
	.word	-178307901
	.word	.LC193
	.word	.LANCHOR9
	.word	.LC195
	.word	.LANCHOR102
	.word	.LANCHOR78
	.word	.LANCHOR152
	.word	.LANCHOR153
	.word	.LC194
	.word	.LANCHOR77
.L3188:
	ldr	r3, .L3218
	ldr	r3, [r3]
	ldr	r7, [r3, fp, lsl #2]
	adds	r3, r7, #1
	beq	.L3181
	ldr	r3, .L3218+4
	mov	r0, r7
	ldr	r3, [r3]
	ldr	r3, [r3, fp, lsl #2]
	str	r3, [sp, #40]
	bl	lpa_hash_get_ppa
	str	r0, [sp, #60]
	adds	r0, r0, #1
	bne	.L3182
	movs	r2, #0
	add	r1, sp, #60
	mov	r0, r7
	bl	pm_log2phys
.L3182:
	ldr	r3, [sp, #48]
	ldrh	r2, [r3, #96]
	ldr	r3, .L3218+8
	ldrh	r3, [r3]
	muls	r3, r2, r3
	ldr	r2, .L3218+12
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, #3
	bne	.L3183
	add	r3, r3, r6
	orr	r3, r3, r8, lsl #24
.L3214:
	str	r3, [sp, #56]
	movs	r2, #1
	ldr	r3, .L3218+16
	str	r2, [sp, #52]
	ldr	r1, .L3218+20
	ldrh	r0, [r3]
	ldrb	r1, [r1]	@ zero_extendqisi2
	rsb	r3, r0, #21
	lsl	r3, r2, r3
	ldr	r2, [sp, #40]
	subs	r3, r3, #1
	lsr	r0, r2, r0
	ands	r0, r0, r3
	bl	__aeabi_uidiv
	ldr	r2, [sp, #40]
	ldr	r3, [sp, #60]
	str	r0, [sp, #44]
	cmp	r2, r3
	ldr	r2, [sp, #52]
	bne	.L3186
	add	r1, sp, #56
	mov	r0, r7
	bl	pm_log2phys
	ldrh	r0, [sp, #44]
	adds	r4, r4, #1
	bl	ftl_vpn_decrement
.L3187:
	ldr	r3, .L3218+24
	add	fp, fp, #1
	ldrh	r7, [sp, #44]
	ldr	r3, [r3]
	add	r3, r3, r7, lsl #2
	ldrb	r3, [r3, #2]	@ zero_extendqisi2
	ands	r3, r3, #224
	bne	.L3181
	ldr	r2, .L3218+28
	ldr	r2, [r2]
	ldrh	r1, [r2, r7, lsl #1]
	cbz	r1, .L3181
	strh	r3, [r2, r7, lsl #1]	@ movhi
.L3181:
	add	r8, r8, #1
.L3190:
	ldr	r3, [sp, #36]
	cmp	r3, r8
	bcs	.L3188
	add	r10, r10, #1
.L3192:
	ldrb	r3, [r5, #89]	@ zero_extendqisi2
	cmp	r10, r3
	bge	.L3189
	add	r3, r5, r10, lsl #1
	mov	r8, #1
	str	r3, [sp, #48]
	b	.L3190
.L3183:
	cmp	r2, #2
	itett	eq
	addeq	r2, r6, #-1
	addne	r3, r3, r6
	addeq	r3, r3, r2
	addeq	r3, r3, r8
	it	eq
	orreq	r3, r3, #33554432
	b	.L3214
.L3186:
	ldr	r2, [sp, #56]
	cmp	r3, r2
	it	eq
	addeq	r4, r4, #1
	b	.L3187
.L3189:
	adds	r6, r6, #1
	b	.L3180
.L3191:
	ldr	r3, .L3218+28
	ldrh	r2, [r5, #80]
	ldr	r3, [r3]
	strh	r4, [r3, r2, lsl #1]	@ movhi
	ldrh	r0, [r5, #80]
	bl	zftl_insert_data_list
	b	.L3166
.L3161:
	ldr	r3, [r7]
	ldrh	r3, [r3, #130]
	cmp	r3, r6
	beq	.L3160
	ldr	r5, .L3218+32
	ldr	r2, [r5]
	ldrh	r2, [r2, #126]
	cmp	r2, r3
	bne	.L3195
	bl	pm_flush
	ldr	r3, [r7]
	ldrh	r0, [r3, #130]
	bl	ftl_free_sblk
	ldr	r3, [r5]
	mov	r0, r4
	strh	r6, [r3, #126]	@ movhi
	bl	ftl_info_flush
.L3195:
	ldr	r3, [r7]
	movw	r2, #65535
	strh	r2, [r3, #130]	@ movhi
	b	.L3160
.L3219:
	.align	2
.L3218:
	.word	.LANCHOR152
	.word	.LANCHOR153
	.word	.LANCHOR103
	.word	.LANCHOR71
	.word	.LANCHOR66
	.word	.LANCHOR67
	.word	.LANCHOR7
	.word	.LANCHOR9
	.word	.LANCHOR102
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
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r2, .L3285
	movs	r3, #255
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r5, #0
	ldr	r6, .L3285+4
	sub	sp, sp, #24
	strb	r3, [r2]
	ldr	r2, .L3285+8
	ldr	r1, .L3285+12
	ldr	r0, .L3285+16
	strb	r5, [r2]
	ldr	r2, .L3285+20
	strb	r3, [r2]
	ldr	r2, .L3285+24
	strb	r5, [r2]
	ldr	r2, .L3285+28
	strb	r3, [r2]
	mov	r2, #-1
	ldr	r3, .L3285+32
	strb	r5, [r3]
	ldr	r3, .L3285+36
	str	r2, [r3]
	bl	printf
	ldrb	r3, [r6, #12]	@ zero_extendqisi2
	ldrb	r8, [r6, #9]	@ zero_extendqisi2
	ldrh	r10, [r6, #10]
	str	r3, [sp]
	ldr	r3, .L3285+40
	ldrb	r2, [sp]	@ zero_extendqisi2
	mov	r0, r10
	ldr	r1, [sp]
	strb	r2, [r3]
	ldr	r3, .L3285+44
	strb	r8, [r3]
	ldr	r3, .L3285+48
	strh	r10, [r3]	@ movhi
	bl	__aeabi_idiv
	ldr	r3, .L3285+52
	mov	r7, r0
	ldrb	r1, [r6, #13]	@ zero_extendqisi2
	ldrh	fp, [r6, #14]
	lsl	r6, r8, #9
	ldrb	r4, [r3]	@ zero_extendqisi2
	ldr	r3, .L3285+56
	uxth	r6, r6
	ldr	ip, .L3285+216
	ldr	r0, .L3285+60
	strb	r4, [r3]
	smulbb	r4, r4, r1
	ldr	r3, .L3285+64
	ldr	r2, .L3285+68
	uxtb	r4, r4
	strh	r7, [r0]	@ movhi
	strb	r1, [r3]
	ldr	r3, .L3285+72
	ldr	r1, .L3285+76
	strh	fp, [r2]	@ movhi
	strh	r6, [r3]	@ movhi
	ldr	r3, .L3285+80
	strb	r4, [r1]
	str	r0, [sp, #4]
	ldrh	r3, [r3]
	str	r1, [sp, #8]
	str	r2, [sp, #12]
	strh	r3, [ip]	@ movhi
	mov	ip, #1
.L3221:
	cmp	r3, ip
	uxth	r2, r5
	add	r5, r5, #1
	bcs	.L3222
	mul	r10, r10, r8
	subs	r3, r2, #1
	ldr	r2, .L3285+84
	movs	r0, #0
	movs	r1, #1
	strh	r3, [r2]	@ movhi
	mul	r2, fp, r10
	lsrs	r5, r2, #21
.L3223:
	cmp	r5, r1
	uxth	r3, r0
	add	r0, r0, #1
	bcs	.L3224
	mov	r5, #1892352
	subs	r3, r3, #1
	mul	r1, r5, r4
	uxth	r3, r3
	muls	r2, r4, r2
	lsl	r5, r1, r3
	ldr	r3, .L3285+88
	mov	r1, r8
	ldr	r8, .L3285+220
	str	r5, [r3]
	ldr	r3, .L3285+92
	str	r2, [r3]
	add	r2, r5, #24576
	str	r3, [sp, #20]
	mov	r0, r2
	ldr	r3, .L3285+96
	str	r2, [sp, #16]
	str	r2, [r3]
	bl	__aeabi_uidiv
	ldr	r3, .L3285+100
	add	ip, r6, #-1
	mov	r1, r6
	ldr	r6, .L3285+104
	str	r0, [r3]
	add	r0, ip, r0, lsl #2
	bl	__aeabi_uidiv
	strh	r0, [r6]	@ movhi
	uxth	r0, r0
	mul	r1, r4, r7
	ldr	r7, .L3285+108
	lsls	r0, r0, #4
	bl	__aeabi_idiv
	mul	r1, r4, r10
	ldr	r2, [sp, #16]
	strh	r0, [r8]	@ movhi
	mov	r4, #256
	ldr	r10, .L3285+100
	mov	r0, r2
	subs	r1, r1, #1
	bl	__aeabi_uidiv
	add	r2, fp, fp, lsl #1
	ldr	r1, .L3285+112
	lsr	fp, fp, #4
	adds	r0, r0, #8
	asrs	r2, r2, #2
	strh	r0, [r7]	@ movhi
	cmp	fp, #79
	ldr	r0, .L3285+116
	strh	r2, [r1]	@ movhi
	it	ls
	movls	r1, #80
	ldr	r2, .L3285+120
	mov	ip, #32
	ldr	r3, [sp, #20]
	strh	fp, [r2]	@ movhi
	it	ls
	strhls	r1, [r2]	@ movhi
	mov	r1, #2000
	ldr	r2, .L3285+124
	ldr	fp, .L3285+96
	strh	r1, [r2]	@ movhi
	movs	r1, #50
	strh	r1, [r0]	@ movhi
	ldr	r1, .L3285+128
	strh	r4, [r1]	@ movhi
	movs	r4, #48
	ldr	r1, .L3285+132
	strh	r4, [r1]	@ movhi
	ldr	r4, .L3285+136
	strh	ip, [r4]	@ movhi
	ldr	r4, [sp]
	cmp	r4, #2
	beq	.L3226
	ldr	r4, .L3285+140
	ldrb	r4, [r4]	@ zero_extendqisi2
	cbz	r4, .L3227
.L3226:
	movs	r4, #150
	strh	r4, [r0]	@ movhi
	movs	r0, #64
	strh	r0, [r1]	@ movhi
	movs	r0, #12
	ldr	r1, .L3285+136
	strh	r0, [r1]	@ movhi
	ldr	r0, .L3285+144
	ldrb	r0, [r0]	@ zero_extendqisi2
	cbnz	r0, .L3227
	movs	r0, #4
	strh	r0, [r1]	@ movhi
	mov	r1, #600
	strh	r1, [r2]	@ movhi
	movs	r1, #128
	ldr	r2, .L3285+128
	strh	r1, [r2]	@ movhi
.L3227:
	ldr	r4, .L3285+148
	ldr	r2, [r4]
	lsls	r1, r2, #19
	bpl	.L3229
	mov	r1, r5
	ldr	r0, .L3285+152
	str	r3, [sp]
	bl	printf
	ldr	r3, [sp]
.L3229:
	ldr	r2, [r4]
	lsls	r2, r2, #19
	bpl	.L3230
	ldr	r1, [r3]
	ldr	r0, .L3285+156
	bl	printf
.L3230:
	ldr	r3, [r4]
	lsls	r3, r3, #19
	bpl	.L3231
	ldr	r1, [r10]
	ldr	r0, .L3285+160
	bl	printf
.L3231:
	ldr	r3, [r4]
	lsls	r5, r3, #19
	bpl	.L3232
	ldr	r1, [fp]
	ldr	r0, .L3285+164
	bl	printf
.L3232:
	ldr	r3, [r4]
	lsls	r0, r3, #19
	bpl	.L3233
	ldrh	r1, [r6]
	ldr	r0, .L3285+168
	bl	printf
.L3233:
	ldr	r3, [r4]
	ldr	r5, .L3285+72
	tst	r3, #4096
	beq	.L3234
	ldrh	r1, [r5]
	ldr	r0, .L3285+172
	bl	printf
.L3234:
	ldr	r3, [r4]
	lsls	r1, r3, #19
	bpl	.L3235
	ldrh	r1, [r8]
	ldr	r0, .L3285+176
	bl	printf
.L3235:
	ldr	r3, [r4]
	lsls	r2, r3, #19
	bpl	.L3236
	ldr	r3, .L3285+120
	ldr	r0, .L3285+180
	ldrh	r1, [r3]
	bl	printf
.L3236:
	ldr	r3, [r4]
	lsls	r3, r3, #19
	bpl	.L3237
	ldrh	r1, [r7]
	ldr	r0, .L3285+184
	bl	printf
.L3237:
	bl	buf_init
	ldr	r3, [sp, #12]
	movs	r0, #6
	ldr	r7, .L3285+188
	ldrh	r3, [r3]
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L3285+192
	ldr	r2, [sp, #8]
	str	r0, [r3]
	ldr	r3, [sp, #4]
	ldrb	r0, [r2]	@ zero_extendqisi2
	ldrh	r3, [r3]
	muls	r0, r3, r0
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L3285+196
	ldr	r2, .L3285+200
	str	r0, [r3]
	ldr	r3, .L3285+204
	str	r2, [r3]
	ldr	r3, [sp, #4]
	ldrh	r0, [r3]
	ldr	r3, [sp, #8]
	ldrb	r1, [r3]	@ zero_extendqisi2
	muls	r0, r1, r0
	ldr	r1, .L3285+208
	add	r3, r2, r0, lsl #3
	str	r3, [r1]
	ldr	r1, [sp, #12]
	ldrh	r1, [r1]
	lsrs	r1, r1, #1
	add	r1, r1, r0, lsl #1
	ldr	r0, [r4]
	add	r1, r2, r1, lsl #2
	lsls	r0, r0, #19
	str	r1, [r7]
	bpl	.L3238
	ldr	r0, .L3285+212
	bl	printf
	b	.L3286
.L3287:
	.align	2
.L3285:
	.word	.LANCHOR57
	.word	.LANCHOR31
	.word	.LANCHOR58
	.word	.LC196
	.word	.LC97
	.word	.LANCHOR126
	.word	.LANCHOR127
	.word	.LANCHOR174
	.word	.LANCHOR121
	.word	.LANCHOR206
	.word	.LANCHOR71
	.word	.LANCHOR123
	.word	.LANCHOR77
	.word	.LANCHOR18
	.word	.LANCHOR104
	.word	.LANCHOR85
	.word	.LANCHOR67
	.word	.LANCHOR6
	.word	.LANCHOR203
	.word	.LANCHOR78
	.word	.LANCHOR2
	.word	.LANCHOR66
	.word	.LANCHOR59
	.word	.LANCHOR207
	.word	.LANCHOR208
	.word	.LANCHOR120
	.word	.LANCHOR187
	.word	.LANCHOR93
	.word	.LANCHOR117
	.word	.LANCHOR116
	.word	.LANCHOR89
	.word	.LANCHOR118
	.word	.LANCHOR145
	.word	.LANCHOR144
	.word	.LANCHOR8
	.word	.LANCHOR75
	.word	.LANCHOR0
	.word	.LANCHOR14
	.word	.LC197
	.word	.LC198
	.word	.LC199
	.word	.LC200
	.word	.LC201
	.word	.LC202
	.word	.LC203
	.word	.LC204
	.word	.LC205
	.word	.LANCHOR10
	.word	.LANCHOR4
	.word	.LANCHOR110
	.word	ftl_ext_info_data_buffer
	.word	.LANCHOR109
	.word	.LANCHOR9
	.word	.LC206
	.word	.LANCHOR103
	.word	.LANCHOR146
.L3286:
.L3238:
	ldr	r2, [sp, #4]
	ldr	r1, [sp, #8]
	ldr	r3, [sp, #12]
	ldrh	r2, [r2]
	ldrb	r8, [r1]	@ zero_extendqisi2
	ldrh	r3, [r3]
	mul	r8, r8, r2
	ldrh	r2, [r6]
	lsls	r6, r3, #2
	add	r8, r3, r8, lsl #2
	ldr	r3, [r4]
	add	r6, r6, r2, lsl #2
	lsl	r8, r8, #1
	lsls	r2, r3, #19
	add	r8, r8, #632
	add	r6, r6, #704
	bpl	.L3239
	ldrh	r3, [r5]
	mov	r2, r6
	mov	r1, r8
	ldr	r0, .L3288
	bl	printf
.L3239:
	ldrh	r3, [r5]
	cmp	r8, r3
	bhi	.L3240
	cmp	r6, r3
	bls	.L3241
.L3240:
.L3284:
	b	.L3284
.L3222:
	lsl	ip, ip, #1
	b	.L3221
.L3224:
	lsls	r1, r1, #1
	b	.L3223
.L3241:
	bl	sblk_init
	bl	ftl_info_blk_init
	adds	r3, r0, #1
	beq	.L3220
	bl	ftl_ext_info_init
	bl	gc_init
	movs	r0, #1
	ldr	r4, .L3288+4
	bl	pm_init
	bl	lpa_rebuild_hash
	ldr	r0, [r7]
	movs	r1, #0
	adds	r0, r0, #16
	bl	ftl_open_sblk_recovery
	ldr	r0, [r7]
	add	r1, r0, #16
	adds	r0, r0, #48
	bl	ftl_open_sblk_recovery
	ldr	r2, [r4]
	ldr	r0, [r7]
	ldr	r3, [r2, #8]
	adds	r0, r0, #16
	adds	r3, r3, #16
	str	r3, [r2, #8]
	bl	ftl_info_data_recovery
	ldr	r0, [r7]
	adds	r0, r0, #48
	bl	ftl_info_data_recovery
	ldr	r0, [r7]
	adds	r0, r0, #80
	bl	ftl_info_data_recovery
	bl	gc_recovery
	bl	pm_flush
	movs	r0, #1
	bl	ftl_total_vpn_update
	ldr	r3, .L3288+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L3243
	ldr	r2, [r4]
	ldr	r3, [r2, #68]
	adds	r3, r3, #1
	str	r3, [r2, #68]
.L3243:
	bl	ftl_ext_info_flush
	movs	r0, #0
	bl	ftl_info_flush
	bl	print_ftl_debug_info
	movs	r0, #0
.L3220:
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3289:
	.align	2
.L3288:
	.word	.LC207
	.word	.LANCHOR102
	.word	.LANCHOR182
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
	cbnz	r0, .L3291
	bl	zftl_init
	mov	r4, r0
.L3291:
	bl	idb_init
	mov	r1, r4
	ldr	r0, .L3292
	bl	printf
	mov	r0, r4
	pop	{r4, pc}
.L3293:
	.align	2
.L3292:
	.word	.LC208
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
	ldr	r3, .L3328
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #32
	ldr	r2, .L3328+4
	ldr	r4, [r3]
	ldrh	r2, [r2]
	ldr	r7, .L3328+8
	ldrb	r1, [r4, #89]	@ zero_extendqisi2
	str	r3, [sp, #20]
	muls	r2, r1, r2
	str	r2, [sp, #4]
	ldr	r2, [r7]
	tst	r2, #256
	beq	.L3295
	ldrh	r1, [r4, #80]
	ldr	r0, .L3328+12
	bl	printf
.L3295:
	ldr	r3, .L3328+16
	movs	r6, #0
	ldr	r1, [sp, #4]
	mov	r5, r6
	ldrh	r2, [r4, #80]
	ldr	r3, [r3]
	subs	r1, r1, #1
	strh	r1, [r3, r2, lsl #1]	@ movhi
.L3296:
	ldr	r3, [sp, #4]
	cmp	r5, r3
	bne	.L3305
	ldr	r3, [r7]
	ldr	r5, .L3328+16
	tst	r3, #256
	beq	.L3306
	ldr	r3, [sp, #20]
	ldrh	r0, [r4, #80]
	ldr	r2, [r5]
	ldr	r1, [r3]
	mov	r3, r6
	ldrh	r2, [r2, r0, lsl #1]
	ldrh	r1, [r1, #80]
	ldr	r0, .L3328+20
	bl	printf
.L3306:
	ldrh	r2, [r4, #80]
	ldr	r3, [r5]
	ldrh	r3, [r3, r2, lsl #1]
	cmp	r6, r3
	beq	.L3307
	movw	r2, #617
	ldr	r1, .L3328+24
	ldr	r0, .L3328+28
	bl	printf
.L3307:
	ldrh	r2, [r4, #80]
	ldr	r3, [r5]
	strh	r6, [r3, r2, lsl #1]	@ movhi
	ldrh	r0, [r4, #80]
	bl	zftl_insert_data_list
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3305:
	ldr	r3, .L3328+32
	lsl	r8, r5, #2
	ldr	r3, [r3]
	ldr	r10, [r3, r5, lsl #2]
	cmp	r10, #-1
	beq	.L3297
	ldr	r3, .L3328+36
	mov	r0, r10
	ldrb	r1, [r3]	@ zero_extendqisi2
	lsls	r1, r1, #7
	bl	__aeabi_uidiv
	uxth	r3, r0
	str	r3, [sp, #16]
	ldr	r3, [r7]
	lsls	r1, r3, #23
	bpl	.L3298
	mov	r3, r5
	mov	r2, r10
	ldr	r1, [sp, #16]
	ldr	r0, .L3328+40
	bl	printf
.L3298:
	ldr	fp, .L3328+32
	str	r5, [sp, #12]
.L3304:
	ldr	r3, [fp]
	ldr	r10, [r3, r8]
	cmp	r10, #-1
	beq	.L3299
	ldr	r3, .L3328+36
	mov	r0, r10
	ldrb	r1, [r3]	@ zero_extendqisi2
	lsls	r1, r1, #7
	bl	__aeabi_uidiv
	ldr	r3, [sp, #16]
	uxth	r0, r0
	cmp	r3, r0
	bne	.L3299
	ldr	r3, .L3328+44
	mov	r0, r10
	ldr	r3, [r3]
	ldr	r3, [r3, r8]
	str	r3, [sp, #8]
	bl	lpa_hash_get_ppa
	str	r0, [sp, #28]
	adds	r0, r0, #1
	bne	.L3300
	movs	r2, #0
	add	r1, sp, #28
	mov	r0, r10
	bl	pm_log2phys
.L3300:
	ldr	r3, [sp, #28]
	ldr	r2, [sp, #8]
	cmp	r2, r3
	bne	.L3301
	ldr	r3, .L3328+48
	add	r1, sp, #32
	movs	r2, #1
	mov	r0, r10
	adds	r6, r6, #1
	ldr	r3, [r3]
	ldr	r3, [r3, r8]
	str	r3, [r1, #-8]!
	bl	pm_log2phys
	ldr	r3, .L3328+52
	ldrh	r0, [r3]
	movs	r3, #1
	rsb	r2, r0, #21
	lsls	r3, r3, r2
	ldr	r2, [sp, #8]
	subs	r3, r3, #1
	lsrs	r2, r2, r0
	mov	r0, r2
	ldr	r2, .L3328+56
	ands	r0, r0, r3
	ldrb	r1, [r2]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	uxth	r0, r0
.L3327:
	bl	ftl_vpn_decrement
	ldr	r3, [fp]
	mov	r2, #-1
	str	r2, [r3, r8]
.L3299:
	ldr	r3, [sp, #12]
	add	r8, r8, #4
	adds	r3, r3, #1
	str	r3, [sp, #12]
	ldr	r2, [sp, #12]
	ldr	r3, [sp, #4]
	cmp	r3, r2
	bne	.L3304
.L3297:
	adds	r5, r5, #1
	b	.L3296
.L3301:
	ldr	r2, [r7]
	lsls	r2, r2, #23
	bpl	.L3303
	ldr	r2, [sp, #8]
	mov	r1, r10
	ldr	r0, .L3328+60
	bl	printf
.L3303:
	ldrh	r0, [r4, #80]
	b	.L3327
.L3329:
	.align	2
.L3328:
	.word	.LANCHOR10
	.word	.LANCHOR77
	.word	.LANCHOR14
	.word	.LC209
	.word	.LANCHOR9
	.word	.LC212
	.word	.LANCHOR209
	.word	.LC0
	.word	.LANCHOR152
	.word	.LANCHOR123
	.word	.LC210
	.word	.LANCHOR153
	.word	.LANCHOR154
	.word	.LANCHOR66
	.word	.LANCHOR67
	.word	.LC211
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
	ldr	r4, .L3356
	mov	r0, r1
	movw	r5, #65535
	ldr	r6, .L3356+4
	ldrb	r3, [r4, #4]	@ zero_extendqisi2
	ldrb	ip, [r6]	@ zero_extendqisi2
	add	r2, r4, r3, lsl #1
	ldrh	r7, [r2, #36]
	ldrh	r2, [r4, #2]
.L3331:
	cmp	r7, r5
	beq	.L3333
	cbz	r0, .L3334
	strh	r2, [r4, #2]	@ movhi
.L3334:
	cbz	r1, .L3335
	strb	r3, [r4, #4]
.L3335:
	ldr	r8, .L3356+16
	movs	r0, #1
	ldr	r10, .L3356+20
	mov	fp, #1
	bl	buf_alloc
	mov	r5, r0
.L3336:
	ldrb	r1, [r4, #6]	@ zero_extendqisi2
	cmp	fp, r1
	ble	.L3344
	mov	r0, r5
	bl	buf_free
	ldrb	r3, [r4, #4]	@ zero_extendqisi2
	ldrb	r2, [r6]	@ zero_extendqisi2
	adds	r3, r3, #1
	uxtb	r3, r3
	cmp	r2, r3
	strb	r3, [r4, #4]
	bne	.L3330
	ldrh	r3, [r4, #2]
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #4]
.L3330:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3333:
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
	b	.L3331
.L3344:
	ldrh	r3, [r8]
	cmp	r1, #3
	ldrh	r2, [r4, #2]
	mul	r3, r7, r3
	bne	.L3337
	add	r3, r3, r2
	orr	r3, r3, fp, lsl #24
.L3355:
	str	r3, [r5, #24]
	movs	r1, #1
	mov	r0, r5
	bl	sblk_read_page
	ldr	r3, [r5, #36]
	adds	r2, r3, #1
	beq	.L3341
	cmp	r3, #512
	beq	.L3341
	ldr	r3, [r5, #12]
	ldr	r3, [r3, #4]
	mov	r0, r3
	str	r3, [sp, #4]
	bl	lpa_hash_get_ppa
	str	r0, [sp, #12]
	adds	r0, r0, #1
	ldr	r3, [sp, #4]
	bne	.L3343
	ldr	r2, .L3356+8
	ldr	r2, [r2]
	cmp	r3, r2
	bcs	.L3343
	movs	r2, #0
	add	r1, sp, #12
	mov	r0, r3
	bl	pm_log2phys
.L3343:
	ldr	r2, [r5, #24]
	ldr	r3, [sp, #12]
	cmp	r2, r3
	bne	.L3341
	ldr	r1, .L3356+12
	ldrh	r3, [r4, #20]
	ldr	r1, [r1]
	str	r2, [r1, r3, lsl #2]
	adds	r3, r3, #1
	strh	r3, [r4, #20]	@ movhi
.L3341:
	ldrh	r3, [r4, #22]
	add	fp, fp, #1
	adds	r3, r3, #1
	strh	r3, [r4, #22]	@ movhi
	b	.L3336
.L3337:
	cmp	r1, #2
	ittet	eq
	addeq	r3, r3, r2, lsl #1
	ldrbeq	r2, [r10]	@ zero_extendqisi2
	addne	r3, r3, r2
	addeq	r3, r3, #-1
	itt	eq
	addeq	r3, r3, fp
	orreq	r3, r3, r2, lsl #24
	b	.L3355
.L3357:
	.align	2
.L3356:
	.word	.LANCHOR63
	.word	.LANCHOR78
	.word	.LANCHOR120
	.word	.LANCHOR68
	.word	.LANCHOR103
	.word	.LANCHOR71
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
	ldr	r4, .L3399
	ldrh	r2, [r4]
	cmp	r2, r3
	bne	.L3359
	movw	r2, #1052
	ldr	r1, .L3399+4
	ldr	r0, .L3399+8
	bl	printf
.L3359:
	ldrh	r1, [r4]
	movw	r3, #65535
	cmp	r1, r3
	beq	.L3380
	ldr	r3, .L3399+12
	ldr	r3, [r3]
	lsls	r0, r3, #23
	bpl	.L3361
	ldr	r3, .L3399+16
	ldr	r0, .L3399+20
	ldr	r3, [r3]
	ldrh	r2, [r3, r1, lsl #1]
	bl	printf
.L3361:
	ldr	r1, .L3399+24
	ldrh	r0, [r4]
	bl	ftl_get_blk_list_in_sblk
	uxtb	r0, r0
	strb	r0, [r4, #5]
	cbnz	r0, .L3362
	movw	r3, #65535
	strh	r3, [r4]	@ movhi
.L3358:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3362:
	ldr	r5, .L3399+28
	ldrh	r3, [r4]
	ldr	r2, [r5]
	add	r2, r2, r3, lsl #2
	ldrb	r2, [r2, #2]	@ zero_extendqisi2
	and	r2, r2, #224
	cmp	r2, #32
	beq	.L3363
	cmp	r2, #224
	beq	.L3363
	cbz	r2, .L3364
	ldr	r2, .L3399+32
	ldr	r2, [r2]
	ldrh	r1, [r2, #16]
	cmp	r1, r3
	beq	.L3363
	ldrh	r1, [r2, #48]
	cmp	r1, r3
	beq	.L3363
	ldrh	r2, [r2, #80]
	cmp	r2, r3
	bne	.L3397
.L3363:
	movw	r3, #65535
	movs	r0, #0
	strh	r3, [r4]	@ movhi
	strh	r0, [r4, #20]	@ movhi
	b	.L3358
.L3364:
	ldr	r5, .L3399+16
	ldr	r1, [r5]
	ldrh	r3, [r1, r3, lsl #1]
	cbz	r3, .L3366
	mov	r2, #1072
	ldr	r1, .L3399+4
	ldr	r0, .L3399+8
	bl	printf
.L3366:
	ldrh	r2, [r4]
	movs	r1, #0
	ldr	r3, [r5]
	strh	r1, [r3, r2, lsl #1]	@ movhi
	b	.L3363
.L3397:
	add	r0, r4, r0, lsl #1
	movw	r3, #65535
	ldrh	r6, [r0, #34]
	cmp	r6, r3
	bne	.L3367
	mov	r2, #1080
	ldr	r1, .L3399+4
	ldr	r0, .L3399+8
	bl	printf
.L3367:
	ldr	r2, .L3399+36
	ldrh	r0, [r4]
	ldr	r1, .L3399+40
	ldrh	r2, [r2]
	ldr	r8, .L3399+64
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
	bne	.L3381
	ldr	r2, .L3399+44
	ldrb	r7, [r2]	@ zero_extendqisi2
	cmp	r7, #2
	it	eq
	ldrheq	r3, [r8]
	orr	r6, r6, r7, lsl #24
	itee	ne
	uxthne	r7, r7
	addeq	r3, r3, #-1
	uxtheq	r3, r3
.L3368:
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
	ldr	r6, .L3399+48
	mov	fp, r0
	bl	sblk_read_page
	ldrh	r3, [r8]
	movs	r1, #255
	ldrb	r2, [r6]	@ zero_extendqisi2
	ldr	r8, .L3399+68
	muls	r2, r3, r2
	ldr	r0, [r8]
	lsls	r2, r2, #2
	bl	ftl_memset
	ldr	r3, [fp, #36]
	strh	r5, [r4, #20]	@ movhi
	adds	r2, r3, #1
	beq	.L3398
	cmp	r3, #512
	bne	.L3371
.L3398:
	mov	r0, fp
	bl	buf_free
	mov	r0, #-1
	b	.L3358
.L3381:
	movs	r7, #1
	b	.L3368
.L3371:
	ldr	r3, [fp, #12]
	ldr	r2, [r3]
	ldr	r3, .L3399+52
	cmp	r2, r3
	beq	.L3372
	movw	r2, #1113
	ldr	r1, .L3399+4
	ldr	r0, .L3399+8
	bl	printf
	b	.L3398
.L3372:
	ldrh	r3, [r10]
	ldrb	r6, [r6]	@ zero_extendqisi2
	ldr	r10, .L3399+72
	smulbb	r6, r6, r3
	smulbb	r6, r6, r7
	ldr	r7, [fp, #4]
	uxth	r6, r6
	subs	r7, r7, #4
.L3373:
	cmp	r5, r6
	blt	.L3378
	ldr	r5, .L3399+16
	mov	r0, fp
	bl	buf_free
	ldrh	r1, [r4]
	ldr	r3, [r5]
	ldrh	r2, [r3, r1, lsl #1]
	ldrh	r3, [r4, #20]
	cmp	r2, r3
	beq	.L3379
	ldr	r0, .L3399+56
	bl	printf
.L3379:
	ldr	r3, [r5]
	ldrh	r1, [r4, #20]
	ldrh	r2, [r4]
	strh	r1, [r3, r2, lsl #1]	@ movhi
	movs	r3, #0
	strh	r3, [r4, #24]	@ movhi
	ldrh	r0, [r4, #20]
	b	.L3358
.L3378:
	ldr	r0, [r7, #4]!
	adds	r3, r0, #1
	beq	.L3375
	bl	lpa_hash_get_ppa
	str	r0, [sp, #12]
	adds	r0, r0, #1
	bne	.L3376
	movs	r2, #0
	add	r1, sp, #12
	ldr	r0, [r7]
	bl	pm_log2phys
.L3376:
	ldr	r3, [sp, #12]
	movs	r2, #1
	ldrh	r0, [r10]
	str	r3, [sp, #4]
	rsb	r1, r0, #21
	lsls	r2, r2, r1
	lsr	r0, r3, r0
	ldr	r3, .L3399+60
	subs	r2, r2, #1
	ands	r0, r0, r2
	ldrb	r1, [r3]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	ldrh	r2, [r4]
	ldr	r3, [sp, #4]
	cmp	r0, r2
	bne	.L3375
	ldrh	r2, [r4, #20]
	ldr	r1, [r8]
	str	r3, [r1, r2, lsl #2]
	adds	r2, r2, #1
	strh	r2, [r4, #20]	@ movhi
.L3375:
	adds	r5, r5, #1
	b	.L3373
.L3380:
	movs	r0, #0
	b	.L3358
.L3400:
	.align	2
.L3399:
	.word	.LANCHOR63
	.word	.LANCHOR210
	.word	.LC0
	.word	.LANCHOR14
	.word	.LANCHOR9
	.word	.LC213
	.word	.LANCHOR63+36
	.word	.LANCHOR7
	.word	.LANCHOR10
	.word	.LANCHOR103
	.word	.LANCHOR85
	.word	.LANCHOR71
	.word	.LANCHOR78
	.word	-178307901
	.word	.LC214
	.word	.LANCHOR67
	.word	.LANCHOR77
	.word	.LANCHOR68
	.word	.LANCHOR66
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
	ldr	r4, .L3417
	ldr	r3, [r4]
	ldr	r2, [r3, #544]
	adds	r2, r2, #1
	beq	.L3402
	ldr	r6, .L3417+4
	movs	r5, #11
	ldr	r7, .L3417+8
.L3410:
	ldr	r3, [r4]
	movs	r2, #0
	add	r1, sp, #4
	ldr	r0, [r3, #544]
	bl	pm_log2phys
	ldr	r3, [sp, #4]
	adds	r3, r3, #1
	beq	.L3403
	movs	r0, #1
	bl	buf_alloc
	ldr	r3, [sp, #4]
	mov	r8, r0
	movs	r1, #1
	str	r3, [r0, #24]
	bl	sblk_read_page
	ldr	r3, [r8, #36]
	cmp	r3, #256
	bne	.L3404
	ldr	r3, .L3417+12
	mov	r10, #1
	ldr	r0, [sp, #4]
	ldrh	r2, [r3]
	rsb	r3, r2, #21
	lsrs	r0, r0, r2
	lsl	r3, r10, r3
	ldr	r2, .L3417+16
	subs	r3, r3, #1
	ands	r0, r0, r3
	ldrb	r1, [r2]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	movs	r2, #0
	mov	r1, r10
	uxth	r0, r0
	bl	gc_add_sblk
.L3404:
	ldr	r2, [r8, #12]
	ldr	r3, [r4]
	ldr	r2, [r2, #4]
	ldr	r3, [r3, #544]
	cmp	r2, r3
	beq	.L3405
	mov	r2, #1552
	mov	r1, r6
	mov	r0, r7
	bl	printf
.L3405:
	mov	r0, r8
	bl	buf_free
.L3403:
	ldr	r3, [r4]
	ldr	r1, .L3417+20
	ldr	r2, [r3, #544]
	ldr	r1, [r1]
	adds	r2, r2, #1
	cmp	r2, r1
	str	r2, [r3, #544]
	bcc	.L3406
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
.L3401:
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L3406:
	ldr	r3, [sp, #4]
	adds	r3, r3, #1
	bne	.L3401
	subs	r5, r5, #1
	uxth	r5, r5
	cmp	r5, #0
	bne	.L3410
	b	.L3401
.L3402:
	ldr	r2, [r3, #536]
	ldr	r1, [r3, #12]
	ldr	r0, .L3417+24
	add	r2, r2, #12910592
	add	r2, r2, #49408
	cmp	r1, r2
	bhi	.L3412
	ldr	r4, [r0]
	ldr	r2, [r3, #540]
	ldr	r4, [r4, #44]
	add	r2, r2, #4992
	adds	r2, r2, #8
	cmp	r4, r2
	bls	.L3401
.L3412:
	ldr	r2, [r0]
	ldr	r2, [r2, #44]
	str	r1, [r3, #536]
	str	r2, [r3, #540]
	movs	r2, #0
	str	r2, [r3, #544]
	b	.L3401
.L3418:
	.align	2
.L3417:
	.word	.LANCHOR10
	.word	.LANCHOR211
	.word	.LC0
	.word	.LANCHOR66
	.word	.LANCHOR67
	.word	.LANCHOR120
	.word	.LANCHOR102
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
	@ args = 0, pretend = 0, frame = 80
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	lsls	r3, r0, #2
	ldr	r4, .L3458
	sub	sp, sp, #120
	lsls	r2, r0, #2
	mov	r6, r0
	str	r3, [sp, #68]
	ldr	r3, [r4]
	str	r1, [sp, #60]
	ldr	r1, [r3, r0, lsl #2]
	adds	r2, r3, r2
	ldrb	r2, [r2, #2]	@ zero_extendqisi2
	ubfx	r1, r1, #11, #8
	str	r1, [sp, #4]
	mov	r1, r0
	ldrh	r3, [r3, r0, lsl #2]
	ldr	r0, .L3458+4
	ubfx	r3, r3, #0, #11
	str	r3, [sp]
	ubfx	r3, r2, #3, #2
	lsrs	r2, r2, #5
	bl	printf
	movw	r3, #65535
	cmp	r6, r3
	beq	.L3440
	ldr	r3, .L3458+8
	ldrh	r3, [r3]
	cmp	r3, r6
	bls	.L3440
	ldr	r3, [r4]
	lsls	r2, r6, #2
	add	r1, sp, #104
	strh	r6, [sp, #88]	@ movhi
	mov	r0, r6
	movs	r5, #0
	add	r3, r3, r2
	mov	r10, r5
	ldrb	r3, [r3, #2]	@ zero_extendqisi2
	and	r3, r3, #224
	cmp	r3, #160
	itet	eq
	ldreq	r3, .L3458+12
	movne	fp, #1
	ldrbeq	fp, [r3]	@ zero_extendqisi2
	bl	ftl_get_blk_list_in_sblk
	ldr	r3, .L3458+16
	uxtb	r0, r0
	lsls	r2, r6, #2
	strb	r5, [sp, #93]
	strb	r0, [sp, #97]
	mov	r1, r6
	ldrh	r3, [r3]
	strh	r5, [sp, #90]	@ movhi
	strh	r5, [sp, #98]	@ movhi
	smulbb	r3, r3, r0
	strh	r3, [sp, #94]	@ movhi
	ldr	r3, [r4]
	add	r3, r3, r2
	ldrb	r2, [r3, #2]	@ zero_extendqisi2
	mov	r3, fp
	str	r0, [sp]
	ldr	r0, .L3458+20
	lsrs	r2, r2, #5
	bl	printf
	movs	r0, #1
	bl	buf_alloc
	mov	r7, r0
	str	r5, [sp, #44]
	str	r5, [sp, #40]
.L3422:
	ldr	r3, .L3458+16
	ldrh	r2, [r3]
	uxth	r3, r5
	cmp	r2, r3
	bls	.L3437
	str	r3, [sp, #64]
	lsls	r3, r3, #1
	subs	r3, r3, #1
	str	r3, [sp, #72]
	movs	r3, #0
	b	.L3457
.L3434:
	ldr	r3, [sp, #76]
	add	r2, sp, #120
	add	r3, r2, r3, lsl #1
	ldrh	r3, [r3, #-32]
	str	r3, [sp, #52]
	movw	r3, #65535
	ldr	r2, [sp, #52]
	cmp	r2, r3
	beq	.L3423
	ldr	r3, .L3458+24
	cmp	fp, #3
	ldrh	r4, [r3]
	mov	r3, r2
	mul	r4, r2, r4
	bne	.L3424
	uxtah	r4, r4, r5
	orr	r4, r4, r8, lsl #24
.L3425:
	movs	r1, #1
	str	r4, [r7, #24]
	mov	r0, r7
	bl	sblk_read_page
	ldr	r2, [r7, #12]
	ldr	r3, [r7, #36]
	ldr	r0, .L3458+28
	ldr	r1, [r2, #12]
	str	r3, [sp, #56]
	ldr	r3, [r7, #4]
	str	r1, [sp, #32]
	ldr	r1, [r2, #8]
	str	r1, [sp, #28]
	ldr	r1, [r2, #4]
	str	r1, [sp, #24]
	ldr	r2, [r2]
	ldr	r1, [sp, #52]
	str	r2, [sp, #20]
	ldr	r2, [r3, #12]
	str	r2, [sp, #16]
	ldr	r2, [r3, #8]
	str	r2, [sp, #12]
	ldr	r2, [r3, #4]
	str	r2, [sp, #8]
	ldr	r3, [r3]
	ldr	r2, [sp, #64]
	str	r3, [sp, #4]
	ldr	r3, [sp, #56]
	str	r3, [sp]
	mov	r3, r4
	bl	printf
	ldr	r3, [sp, #56]
	adds	r2, r3, #1
	beq	.L3442
	cmp	r3, #512
	ldr	r3, [sp, #40]
	it	eq
	moveq	r3, #1
.L3456:
	str	r3, [sp, #40]
	ldr	r3, .L3458
	ldr	r2, [sp, #68]
	ldr	r3, [r3]
	add	r3, r3, r2
	ldrb	r3, [r3, #2]	@ zero_extendqisi2
	and	r3, r3, #224
	cmp	r3, #224
	beq	.L3423
	cmp	r3, #32
	beq	.L3423
	ldr	r3, [r7, #12]
	ldr	r0, [r3, #4]
	bl	lpa_hash_get_ppa
	str	r0, [sp, #84]
	adds	r0, r0, #1
	bne	.L3428
	ldr	r3, [r7, #12]
	movs	r2, #0
	add	r1, sp, #84
	ldr	r0, [r3, #4]
	bl	pm_log2phys
.L3428:
	ldr	r3, [sp, #84]
	cmp	r4, r3
	bne	.L3429
	ldr	r3, [sp, #44]
	mov	r1, r4
	ldr	r2, [r7, #12]
	ldr	r0, .L3458+32
	adds	r3, r3, #1
	ldr	r2, [r2, #4]
	str	r3, [sp, #44]
	bl	printf
.L3429:
	ldr	r3, [sp, #60]
	cbz	r3, .L3431
	ldr	r2, [r3, r10, lsl #2]
	lsl	r4, r10, #2
	ldr	r3, [r7, #12]
	ldr	r3, [r3, #4]
	cmp	r3, r2
	beq	.L3432
	ldr	r3, .L3458+36
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L3432
	mov	r1, r10
	ldr	r0, .L3458+40
	bl	printf
.L3432:
	ldr	r3, [sp, #60]
	ldr	r2, [r7, #12]
	ldr	r3, [r3, r4]
	ldr	r2, [r2, #4]
	cmp	r2, r3
	beq	.L3431
	adds	r3, r3, #1
	beq	.L3431
	mov	r2, #1312
	ldr	r1, .L3458+44
	ldr	r0, .L3458+48
	bl	printf
.L3431:
	add	r10, r10, #1
.L3423:
	add	r8, r8, #1
	uxth	r8, r8
.L3436:
	cmp	fp, r8
	bcs	.L3434
	ldr	r3, [sp, #48]
	adds	r3, r3, #1
.L3457:
	str	r3, [sp, #48]
	ldrb	r2, [sp, #97]	@ zero_extendqisi2
	ldrh	r3, [sp, #48]
	cmp	r2, r3
	bls	.L3435
	adds	r3, r3, #8
	mov	r8, #1
	str	r3, [sp, #76]
	b	.L3436
.L3424:
	cmp	fp, #2
	itett	eq
	ldreq	r3, [sp, #72]
	uxtahne	r4, r4, r5
	addeq	r4, r4, r3
	ldreq	r3, .L3458+12
	ittt	eq
	addeq	r4, r4, r8
	ldrbeq	r3, [r3]	@ zero_extendqisi2
	orreq	r4, r4, r3, lsl #24
	b	.L3425
.L3442:
	movs	r3, #1
	b	.L3456
.L3435:
	adds	r5, r5, #1
	b	.L3422
.L3437:
	mov	r0, r7
	bl	buf_free
	ldr	r3, .L3458+52
	mov	r1, r6
	ldr	r0, .L3458+56
	ldr	r2, [r3]
	ldr	r3, [sp, #44]
	ldrh	r2, [r2, r6, lsl #1]
	bl	printf
	ldr	r0, [sp, #40]
.L3419:
	add	sp, sp, #120
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3440:
	movs	r0, #0
	b	.L3419
.L3459:
	.align	2
.L3458:
	.word	.LANCHOR7
	.word	.LC215
	.word	.LANCHOR6
	.word	.LANCHOR71
	.word	.LANCHOR85
	.word	.LC216
	.word	.LANCHOR103
	.word	.LC162
	.word	.LC217
	.word	.LANCHOR14
	.word	.LC218
	.word	.LANCHOR212
	.word	.LC0
	.word	.LANCHOR9
	.word	.LC219
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
	ldr	r3, .L3507
	mov	r4, r0
	sub	sp, sp, #72
	mov	r6, r1
	mov	fp, r2
	ldr	r3, [r3]
	lsls	r0, r3, #19
	bpl	.L3461
	mov	r3, r2
	ldr	r0, .L3507+4
	mov	r2, r1
	mov	r1, r4
	bl	printf
.L3461:
	cmp	r4, #0
	bne	.L3462
	ldr	r3, .L3507+8
	mov	r4, #24576
	ldr	r3, [r3]
.L3463:
	add	r2, r6, fp
	cmp	r3, r2
	bcc	.L3492
	adds	r3, r4, r6
	ldr	r6, .L3507+12
	str	r3, [sp, #28]
	ldr	r3, .L3507+16
	ldr	r0, [sp, #28]
	ldr	r2, [r3]
	ldr	r3, [r2, #24]
	add	r3, r3, fp
	str	r3, [r2, #24]
	ldr	r3, .L3507+20
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
.L3465:
	ldr	r3, [sp, #32]
	cbnz	r3, .L3490
	ldr	r0, [sp, #40]
.L3460:
	add	sp, sp, #72
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3462:
	cmp	r4, #3
	bhi	.L3492
	lsls	r4, r4, #13
	mov	r3, #8192
	b	.L3463
.L3490:
	ldr	r3, .L3507+20
	ldrb	r1, [r3]	@ zero_extendqisi2
	ldr	r3, [sp, #36]
	cmp	r4, r3
	uxth	r7, r1
	bne	.L3466
	ldr	r0, [sp, #28]
	bl	__aeabi_uidivmod
	uxth	r8, r1
	sub	r7, r7, r8
	uxth	r7, r7
	cmp	fp, r7
	bcs	.L3467
	uxth	r7, fp
.L3467:
	ldr	r2, .L3507+12
	movs	r3, #0
.L3470:
	ldr	r1, [r2, #20]
	cmp	r4, r1
	bne	.L3468
	ldrb	r1, [r2, #2]	@ zero_extendqisi2
	lsls	r1, r1, #28
	bpl	.L3468
	movs	r2, #48
	lsls	r7, r7, #9
	mov	r0, r5
	mla	r3, r2, r3, r6
	add	r5, r5, r7
	mov	r2, r7
	ldr	r1, [r3, #4]
	add	r1, r1, r8, lsl #9
	bl	ftl_memcpy
.L3469:
	ldr	r3, [sp, #32]
	adds	r4, r4, #1
	subs	r3, r3, #1
	str	r3, [sp, #32]
.L3476:
	ldr	r3, .L3507+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #2
	bls	.L3477
	ldr	r3, [sp, #32]
	cmp	r3, #0
	bne	.L3465
.L3477:
	ldr	r3, .L3507+28
	ldrb	r1, [r3]	@ zero_extendqisi2
	cmp	r1, #0
	beq	.L3465
	ldr	r3, .L3507+32
	ldrb	r0, [r3]	@ zero_extendqisi2
	add	r0, r0, r0, lsl #1
	add	r0, r6, r0, lsl #4
	bl	sblk_read_page
.L3479:
	ldr	r3, .L3507+28
	ldr	r8, .L3507+32
	ldrb	r2, [r3]	@ zero_extendqisi2
	cmp	r2, #0
	bne	.L3489
	movs	r1, #255
	strb	r2, [r3]
	strb	r1, [r8]
	b	.L3465
.L3466:
	ldr	r3, [sp, #48]
	mov	r8, #0
	cmp	r4, r3
	itttt	eq
	ldreq	r3, [sp, #28]
	addeq	r7, r3, fp
	mlseq	r1, r4, r1, r7
	uxtbeq	r7, r1
	b	.L3467
.L3468:
	adds	r3, r3, #1
	adds	r2, r2, #48
	cmp	r3, #32
	bne	.L3470
	mov	r0, r4
	bl	lpa_hash_get_ppa
	str	r0, [sp, #68]
	adds	r0, r0, #1
	bne	.L3471
	movs	r2, #0
	add	r1, sp, #68
	mov	r0, r4
	bl	pm_log2phys
.L3471:
	ldr	r3, [sp, #68]
	adds	r3, r3, #1
	bne	.L3472
	ldr	r8, .L3507+20
	movs	r7, #0
.L3473:
	ldrb	r3, [r8]	@ zero_extendqisi2
	cmp	r7, r3
	bcs	.L3469
	mla	r3, r3, r4, r7
	ldr	r2, [sp, #28]
	cmp	r2, r3
	bhi	.L3474
	ldr	r2, [sp, #44]
	cmp	r2, r3
	bls	.L3474
	mov	r0, r5
	add	r5, r5, #512
	mov	r2, #512
	movs	r1, #0
	bl	ftl_memset
.L3474:
	adds	r7, r7, #1
	b	.L3473
.L3472:
	movs	r0, #0
	bl	buf_alloc
	cmp	r0, #0
	beq	.L3476
	ldr	r2, .L3507+16
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
	b	.L3469
.L3508:
	.align	2
.L3507:
	.word	.LANCHOR14
	.word	.LC220
	.word	.LANCHOR59
	.word	.LANCHOR50
	.word	.LANCHOR102
	.word	.LANCHOR123
	.word	.LANCHOR52
	.word	.LANCHOR127
	.word	.LANCHOR126
.L3489:
	ldrb	r3, [r8]	@ zero_extendqisi2
	cmp	r3, #255
	bne	.L3480
	mov	r2, #1080
	ldr	r1, .L3509
	ldr	r0, .L3509+4
	bl	printf
.L3480:
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
	bne	.L3481
	ldr	r3, .L3509+8
	str	r8, [sp, #40]
	ldr	r2, [r3]
	ldr	r3, [r2, #552]
	adds	r3, r3, #1
	str	r3, [r2, #552]
.L3482:
	movs	r3, #48
	mla	r3, r3, r7, r6
	ldr	r2, [r3, #12]
	ldr	r3, [r3, #20]
	ldr	r1, [r2, #4]
	cmp	r1, r3
	bne	.L3483
	cmp	r8, #-1
	bne	.L3484
.L3483:
	ldr	r1, .L3509+8
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
	ldr	r0, .L3509+12
	str	r2, [sp, #4]
	ldr	r2, [r10, #24]
	str	r2, [sp]
	mov	r2, r8
	bl	printf
	ldr	r3, .L3509+16
	ldrh	r2, [r3]
	movs	r3, #1
	rsb	r0, r2, #21
	lsls	r3, r3, r0
	ldr	r0, [r10, #24]
	subs	r3, r3, #1
	lsrs	r0, r0, r2
	ldr	r2, .L3509+20
	ands	r0, r0, r3
	ldrb	r1, [r2]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	movs	r1, #0
	uxth	r0, r0
	bl	ftl_sblk_dump
.L3484:
	movs	r3, #48
	mla	r3, r3, r7, r6
	ldr	r2, [r3, #12]
	ldr	r3, [r3, #20]
	ldr	r2, [r2, #4]
	cmp	r2, r3
	bne	.L3485
	cmp	r8, #-1
	bne	.L3486
.L3485:
	movw	r2, #1101
	ldr	r1, .L3509
	ldr	r0, .L3509+4
	bl	printf
.L3486:
	movs	r3, #48
	mla	r7, r3, r7, r6
	ldr	r3, .L3509+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldrb	r2, [r7, #40]	@ zero_extendqisi2
	cmp	r3, r2
	bls	.L3487
	ldrb	r1, [r7, #41]	@ zero_extendqisi2
	lsls	r2, r2, #9
	ldr	r3, [r7, #4]
	ldr	r0, [r7, #8]
	add	r1, r3, r1, lsl #9
	bl	ftl_memcpy
.L3488:
	ldr	r1, [sp, #52]
	ldr	r0, .L3509+28
	bl	buf_remove_buf
	ldr	r0, [sp, #52]
	bl	buf_free
	ldr	r2, .L3509+32
	ldrb	r3, [r2]	@ zero_extendqisi2
	subs	r3, r3, #1
	strb	r3, [r2]
	b	.L3479
.L3481:
	cmp	r8, #256
	bne	.L3482
	ldr	r1, .L3509+16
	ldr	r3, [r2, #24]
	str	r2, [sp, #60]
	movs	r2, #1
	ldrh	r0, [r1]
	ldr	r1, .L3509+20
	str	r3, [sp, #56]
	rsb	ip, r0, #21
	lsl	ip, r2, ip
	lsr	r0, r3, r0
	ldrb	r1, [r1]	@ zero_extendqisi2
	add	ip, ip, #-1
	and	r0, ip, r0
	bl	__aeabi_uidiv
	ldr	r2, [sp, #60]
	mov	r10, r0
	uxth	r1, r0
	ldr	r3, [sp, #56]
	ldr	r0, .L3509+36
	ldr	r2, [r2, #20]
	bl	printf
	movs	r2, #0
	movs	r1, #1
	uxth	r0, r10
	bl	gc_add_sblk
	b	.L3482
.L3487:
	ldrb	r3, [r7, #2]	@ zero_extendqisi2
	bic	r3, r3, #8
	strb	r3, [r7, #2]
	b	.L3488
.L3492:
	mov	r0, #-1
	b	.L3460
.L3510:
	.align	2
.L3509:
	.word	.LANCHOR213
	.word	.LC0
	.word	.LANCHOR10
	.word	.LC222
	.word	.LANCHOR66
	.word	.LANCHOR67
	.word	.LANCHOR123
	.word	.LANCHOR129
	.word	.LANCHOR127
	.word	.LC221
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
	ldr	r4, .L3541
	ldr	r3, .L3541+4
	ldr	r2, [r4, #8]
	ldr	r7, [r3]
	mov	r8, r3
	cbnz	r2, .L3517
	movs	r0, #1
	bl	buf_alloc
	str	r0, [r4, #8]
.L3517:
	ldr	r5, [r4, #8]
	cbnz	r5, .L3518
	movw	r2, #495
	ldr	r1, .L3541+8
	ldr	r0, .L3541+12
	bl	printf
.L3518:
	add	r3, r7, #96
	mov	r10, #0
.L3519:
	ldrb	r1, [r7, #89]	@ zero_extendqisi2
	cmp	r10, r1
	bge	.L3528
	movs	r6, #1
	b	.L3529
.L3527:
	ldr	r2, .L3541+16
	ldrh	r0, [r3]
	ldrh	r1, [r2]
	ldr	r2, .L3541+20
	ldrb	ip, [r2]	@ zero_extendqisi2
	muls	r0, r1, r0
	ldrh	r1, [r4, #12]
	cmp	ip, #3
	bne	.L3520
	add	r1, r1, r0
	orr	r1, r1, r6, lsl #24
.L3540:
	str	r1, [r5, #24]
	mov	r0, r5
	movs	r1, #1
	str	r3, [sp, #28]
	bl	sblk_read_page
	ldr	r1, [r5, #36]
	ldr	fp, .L3541+56
	ldr	r3, [sp, #28]
	adds	r1, r1, #1
	beq	.L3523
	ldr	r0, [fp]
	ldrh	ip, [r4, #18]
	ldr	r1, [r5, #12]
	ldr	r2, [r0, ip, lsl #2]
	ldr	r0, [r1, #4]
	cmp	r2, r0
	bne	.L3523
	ldr	r0, .L3541+24
	ldr	r1, [r1, #8]
	ldr	r0, [r0]
	ldr	r0, [r0, ip, lsl #2]
	cmp	r0, r1
	beq	.L3524
.L3523:
	ldr	r1, [fp]
	ldrh	r0, [r4, #18]
	ldr	r0, [r1, r0, lsl #2]
	adds	r0, r0, #1
	beq	.L3524
	ldr	r6, .L3541+28
	ldrb	r3, [r7, #89]	@ zero_extendqisi2
	ldr	r0, .L3541+32
	ldrh	r2, [r6]
	muls	r3, r2, r3
	movs	r2, #4
	bl	rknand_print_hex
	ldrh	r2, [r6]
	ldrb	r3, [r7, #89]	@ zero_extendqisi2
	ldr	r6, .L3541+24
	ldr	r0, .L3541+36
	muls	r3, r2, r3
	ldr	r1, [r6]
	movs	r2, #4
	bl	rknand_print_hex
	ldr	r3, .L3541+40
	ldr	r3, [r3]
	lsls	r3, r3, #21
	bpl	.L3525
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
	ldr	r0, .L3541+44
	str	r3, [sp, #4]
	ldr	r3, [r6]
	ldr	r3, [r3, r2, lsl #2]
	str	r3, [sp]
	ldr	r3, [r1, r2, lsl #2]
	ldr	r2, [r5, #36]
	ldr	r1, [r5, #24]
	bl	printf
.L3525:
	ldr	r3, [r8]
	movs	r1, #0
	ldrh	r0, [r3, #80]
	bl	ftl_sblk_dump
	ldr	r3, .L3541+48
	mov	r0, #-1
	ldrh	r2, [r7, #80]
	movs	r1, #0
	ldr	r3, [r3]
	strh	r1, [r3, r2, lsl #1]	@ movhi
.L3526:
.L3516:
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3520:
	cmp	ip, #2
	itett	eq
	addeq	r1, r1, #-1
	addne	r1, r1, r0
	addeq	r1, r1, r0
	addeq	r1, r1, r6
	it	eq
	orreq	r1, r1, #33554432
	b	.L3540
.L3524:
	ldrh	r1, [r4, #18]
	adds	r6, r6, #1
	adds	r1, r1, #1
	strh	r1, [r4, #18]	@ movhi
.L3529:
	ldrh	r1, [r4, #16]
	cmp	r6, r1
	ble	.L3527
	add	r10, r10, #1
	adds	r3, r3, #2
	b	.L3519
.L3528:
	ldrh	r3, [r4, #12]
	adds	r2, r3, #1
	strh	r2, [r4, #12]	@ movhi
	ldr	r2, .L3541+52
	ldrb	r0, [r2]	@ zero_extendqisi2
	cmp	r0, #0
	beq	.L3516
	adds	r3, r3, #2
	movs	r0, #0
	strh	r3, [r4, #12]	@ movhi
	b	.L3516
.L3542:
	.align	2
.L3541:
	.word	.LANCHOR63
	.word	.LANCHOR10
	.word	.LANCHOR214
	.word	.LC0
	.word	.LANCHOR103
	.word	.LANCHOR71
	.word	.LANCHOR153
	.word	.LANCHOR77
	.word	.LC223
	.word	.LC224
	.word	.LANCHOR14
	.word	.LC225
	.word	.LANCHOR9
	.word	.LANCHOR72
	.word	.LANCHOR152
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
	ldr	r3, .L3572
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #24
	ldrb	r7, [r0, #9]	@ zero_extendqisi2
	mov	r6, r0
	ldrh	r3, [r3]
	ldr	r2, .L3572+4
	muls	r7, r3, r7
	ldr	r4, [r2]
	ldrh	r3, [r0, #12]
	str	r2, [sp, #4]
	add	r4, r4, r3, lsl #2
	add	r3, r7, #1073741824
	subs	r3, r3, #1
	ldr	r3, [r4, r3, lsl #2]
	adds	r3, r3, #1
	beq	.L3544
	mov	r2, #1640
	ldr	r1, .L3572+8
	ldr	r0, .L3572+12
	bl	printf
.L3544:
	movs	r5, #0
	subs	r4, r4, #4
	mov	r10, r5
.L3545:
	cmp	r10, r7
	bne	.L3551
	ldr	r3, .L3572+16
	ldr	r4, .L3572+20
	ldr	r3, [r3]
	tst	r3, #4096
	beq	.L3552
	ldrh	r1, [r6]
	mov	r2, r5
	ldr	r3, [r4]
	ldr	r0, .L3572+24
	ldrh	r3, [r3, r1, lsl #1]
	bl	printf
.L3552:
	ldrh	r2, [r6]
	ldr	r3, [r4]
	strh	r5, [r3, r2, lsl #1]	@ movhi
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3551:
	ldr	r8, [r4, #4]!
	cmp	r8, #-1
	beq	.L3546
	ldr	r3, .L3572+28
	mov	r0, r8
	ldrb	r1, [r3]	@ zero_extendqisi2
	lsls	r1, r1, #7
	bl	__aeabi_uidiv
	uxth	r3, r0
	str	r3, [sp]
	ldr	r3, .L3572+16
	ldr	r3, [r3]
	lsls	r2, r3, #19
	bpl	.L3547
	mov	r3, r10
	mov	r2, r8
	ldr	r1, [sp]
	ldr	r0, .L3572+32
	bl	printf
.L3547:
	mov	r8, r4
	mov	fp, r10
.L3550:
	ldr	r0, [r8]
	adds	r3, r0, #1
	beq	.L3548
	ldr	r3, .L3572+28
	ldrb	r1, [r3]	@ zero_extendqisi2
	lsls	r1, r1, #7
	bl	__aeabi_uidiv
	ldr	r3, [sp]
	uxth	r0, r0
	cmp	r3, r0
	bne	.L3548
	ldrb	r3, [r6, #9]	@ zero_extendqisi2
	mov	r0, fp
	mov	r1, r3
	str	r3, [sp, #12]
	bl	__aeabi_idivmod
	ldr	r3, .L3572+36
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
	ldr	r0, .L3572+40
	str	r2, [sp, #20]
	ldr	r1, [r8]
	bl	pm_ppa_update_check
	cbz	r0, .L3549
	ldr	r1, [sp, #4]
	mov	r3, r7
	movs	r2, #4
	ldr	r0, .L3572+44
	ldr	r1, [r1]
	bl	rknand_print_hex
.L3549:
	adds	r5, r5, #1
	movs	r2, #1
	uxth	r5, r5
	add	r1, sp, #20
	ldr	r0, [r8]
	bl	pm_log2phys
	mov	r3, #-1
	str	r3, [r8]
.L3548:
	add	fp, fp, #1
	add	r8, r8, #4
	cmp	r7, fp
	bne	.L3550
.L3546:
	add	r10, r10, #1
	b	.L3545
.L3573:
	.align	2
.L3572:
	.word	.LANCHOR85
	.word	.LANCHOR109
	.word	.LANCHOR215
	.word	.LC0
	.word	.LANCHOR14
	.word	.LANCHOR9
	.word	.LC229
	.word	.LANCHOR123
	.word	.LC226
	.word	.LANCHOR103
	.word	.LC227
	.word	.LC228
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
	beq	.L3575
	bl	zftl_insert_data_list
.L3575:
	ldr	r4, .L3579
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
	bne	.L3577
	movw	r5, #65535
	cmp	r6, r5
	beq	.L3577
	mov	r1, r6
	ldr	r0, .L3579+4
	bl	printf
	ldr	r3, [r4]
	ldr	r0, [r3, #564]
	bl	gc_mark_bad_ppa
	ldr	r3, [r4]
	mov	r2, #-1
	str	r5, [r3, #560]
	str	r2, [r3, #564]
.L3577:
	bl	ftl_ext_info_flush
	movs	r0, #0
	bl	ftl_info_flush
	bl	lpa_rebuild_hash
	movs	r0, #0
	pop	{r4, r5, r6, pc}
.L3580:
	.align	2
.L3579:
	.word	.LANCHOR10
	.word	.LC230
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
	ldr	r7, .L3641
.L3582:
	ldr	r1, .L3641+4
	ldrb	r3, [r1]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L3584
	ldr	r0, .L3641+8
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
	ldr	r4, .L3641+12
	ldr	r3, [r4]
	adds	r5, r7, r2
	ldrb	r2, [r7, r2]	@ zero_extendqisi2
	strb	r2, [r0]
	ldr	r2, [r5, #20]
	cmp	r2, r3
	bcc	.L3586
	mov	r2, #502
	ldr	r1, .L3641+16
	ldr	r0, .L3641+20
	bl	printf
.L3586:
	ldr	r2, [sp, #8]
	movs	r3, #48
	mla	r3, r3, r2, r7
	ldr	r2, [r4]
	ldr	r8, [r3, #20]
	cmp	r8, r2
	bcc	.L3587
	ldr	r0, [sp, #20]
	bl	buf_free
	mov	r0, #-1
.L3581:
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3587:
	ldr	r2, [r3, #12]
	ldr	fp, [r3, #4]
	ldrb	r4, [r3, #41]	@ zero_extendqisi2
	ldrb	r3, [r3, #40]	@ zero_extendqisi2
	str	r2, [sp, #12]
	str	r3, [sp, #16]
	ldr	r3, .L3641+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L3589
	ldr	r3, .L3641+28
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	add	r3, r7, r3, lsl #4
.L3590:
	ldrb	r2, [r3]	@ zero_extendqisi2
	cmp	r2, #255
	bne	.L3591
	ldr	r2, [r3, #20]
	cmp	r8, r2
	bne	.L3589
	ldr	r0, [r3, #4]
	lsls	r4, r4, #9
	ldr	r3, [sp, #16]
	add	r1, fp, r4
	add	r0, r0, r4
	lsls	r2, r3, #9
	bl	ftl_memcpy
	ldr	r0, [sp, #20]
	bl	buf_free
	b	.L3582
.L3591:
	add	r2, r2, r2, lsl #1
	add	r3, r7, r2, lsl #4
	b	.L3590
.L3589:
	mov	r0, r8
	bl	lpa_hash_get_ppa
	str	r0, [sp, #28]
	adds	r0, r0, #1
	bne	.L3593
	movs	r2, #0
	add	r1, sp, #28
	mov	r0, r8
	bl	pm_log2phys
.L3593:
	ldr	r3, .L3641+32
	ldr	r2, .L3641
	ldr	r6, [r3]
	movs	r3, #0
	adds	r6, r6, #16
.L3596:
	ldr	r1, [r2, #20]
	cmp	r8, r1
	bne	.L3594
	ldrb	r1, [r2, #2]	@ zero_extendqisi2
	lsls	r0, r1, #28
	bpl	.L3594
	movs	r2, #48
	bic	r1, r1, #8
	mla	r3, r2, r3, r7
	strb	r1, [r3, #2]
	ldr	r5, [r3, #4]
	ldr	r3, [r3, #24]
	str	r3, [sp, #28]
.L3595:
	ldr	r10, .L3641+36
	ldr	r2, [sp, #16]
	ldrb	r3, [r10]	@ zero_extendqisi2
	cmp	r2, r3
	bcs	.L3620
	cbz	r5, .L3598
	cbz	r4, .L3599
	lsls	r2, r4, #9
	mov	r1, r5
	mov	r0, fp
	bl	ftl_memcpy
	ldr	r3, .L3641+32
	ldr	r6, [r3]
	adds	r6, r6, #48
.L3599:
	ldr	r3, [sp, #16]
	ldrb	r2, [r10]	@ zero_extendqisi2
	add	r4, r4, r3
	cmp	r4, r2
	bcc	.L3600
	ldr	r3, .L3641+32
	ldr	r6, [r3]
	adds	r6, r6, #16
.L3620:
	mov	r10, #0
	b	.L3597
.L3594:
	adds	r3, r3, #1
	adds	r2, r2, #48
	cmp	r3, #32
	bne	.L3596
	movs	r5, #0
	b	.L3595
.L3600:
	lsls	r0, r4, #9
	subs	r2, r2, r4
	lsls	r2, r2, #9
	adds	r1, r5, r0
	add	r0, r0, fp
	bl	ftl_memcpy
	b	.L3620
.L3642:
	.align	2
.L3641:
	.word	.LANCHOR50
	.word	.LANCHOR58
	.word	.LANCHOR57
	.word	.LANCHOR120
	.word	.LANCHOR216
	.word	.LC0
	.word	.LANCHOR121
	.word	.LANCHOR174
	.word	.LANCHOR10
	.word	.LANCHOR123
.L3598:
	ldr	r3, [sp, #28]
	adds	r3, r3, #1
	beq	.L3601
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
	bne	.L3602
	ldr	r3, [r5, #36]
	adds	r3, r3, #1
	bne	.L3603
.L3602:
	ldr	r3, .L3643
	ldr	r0, .L3643+4
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
	ldr	r0, .L3643+8
	bl	rknand_print_hex
.L3603:
	ldr	r3, [r5, #12]
	ldr	r3, [r3, #4]
	cmp	r8, r3
	bne	.L3604
	ldr	r3, [r5, #36]
	adds	r3, r3, #1
	bne	.L3605
.L3604:
	movw	r2, #573
	ldr	r1, .L3643+12
	ldr	r0, .L3643+16
	bl	printf
.L3605:
	cbz	r4, .L3606
	ldr	r3, [sp, #28]
	lsls	r2, r4, #9
	adds	r3, r3, #1
	beq	.L3607
	ldr	r1, [r5, #4]
	mov	r0, fp
	bl	ftl_memcpy
.L3608:
	ldr	r3, .L3643
	ldr	r6, [r3]
	adds	r6, r6, #48
.L3606:
	ldr	r3, [sp, #16]
	add	r4, r4, r3
	ldr	r3, .L3643+20
	ldrb	r2, [r3]	@ zero_extendqisi2
	cmp	r4, r2
	bcc	.L3609
	bls	.L3610
	ldr	r3, .L3643
	ldr	r6, [r3]
	adds	r6, r6, #16
.L3610:
	cbz	r5, .L3597
	ldrb	r3, [r5, #2]	@ zero_extendqisi2
	mov	r1, r5
	ldr	r0, .L3643+24
	bic	r3, r3, #8
	strb	r3, [r5, #2]
	bl	buf_remove_buf
	mov	r0, r5
	bl	buf_free
.L3597:
	ldrh	r3, [r6, #6]
	cbnz	r3, .L3612
	bl	ftl_flush
	mov	r0, r6
	bl	ftl_alloc_new_data_sblk
.L3612:
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
	ldr	r0, .L3643+28
	strb	r3, [r2, #2]
	ldrh	r3, [r6, #10]
	add	r3, r3, r1
	ldr	r1, [sp, #20]
	subs	r3, r3, #1
	strh	r3, [r2, #32]	@ movhi
	bl	buf_add_tail
	ldr	r2, .L3643+32
	movs	r1, #0
	ldrb	r3, [r2]	@ zero_extendqisi2
	adds	r3, r3, #1
	uxtb	r3, r3
	strb	r3, [r2]
	cmp	r3, #2
	ldr	r2, .L3643+36
	str	r1, [r2]
	ldrh	r2, [r6, #6]
	bhi	.L3613
	cmp	r2, #1
	bne	.L3585
.L3613:
	ldr	r5, .L3643+28
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
.L3617:
	cmp	r1, r4
	bne	.L3618
	strb	r2, [r5]
	uxtb	r1, r1
	ldr	r2, .L3643+32
	add	r0, r0, r0, lsl #1
	subs	r3, r3, r1
	add	r0, r7, r0, lsl #4
	strb	r3, [r2]
	bl	sblk_prog_page
	ldrh	r3, [r6, #6]
	cmp	r3, #1
	bne	.L3585
	bl	sblk_wait_write_queue_completed
	bl	ftl_write_completed
	mov	r0, r6
	bl	ftl_write_last_log_page
	mov	r0, r6
	bl	ftl_alloc_new_data_sblk
.L3585:
	ldr	r3, .L3643+40
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L3582
.L3584:
	bl	ftl_write_completed
	movs	r0, #0
	b	.L3581
.L3609:
	ldr	r3, [sp, #28]
	subs	r2, r2, r4
	lsls	r2, r2, #9
	lsls	r0, r4, #9
	adds	r3, r3, #1
	beq	.L3611
	ldr	r1, [r5, #4]
	add	r1, r1, r0
	add	r0, r0, fp
	bl	ftl_memcpy
	b	.L3610
.L3611:
	movs	r1, #0
	add	r0, r0, fp
	bl	ftl_memset
	b	.L3610
.L3618:
	mul	r2, ip, r2
	adds	r1, r1, #1
	ldrb	r2, [r7, r2]	@ zero_extendqisi2
	b	.L3617
.L3619:
	lsls	r2, r4, #9
	mov	r10, r5
.L3607:
	movs	r1, #0
	mov	r0, fp
	bl	ftl_memset
	b	.L3608
.L3601:
	cmp	r4, #0
	bne	.L3619
	mov	r10, r4
	mov	r5, r4
	b	.L3606
.L3644:
	.align	2
.L3643:
	.word	.LANCHOR10
	.word	.LC231
	.word	.LC189
	.word	.LANCHOR216
	.word	.LC0
	.word	.LANCHOR123
	.word	.LANCHOR129
	.word	.LANCHOR174
	.word	.LANCHOR121
	.word	.LANCHOR217
	.word	.LANCHOR58
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
	@ args = 0, pretend = 0, frame = 48
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L3742
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #72
	ldrb	r0, [r3]	@ zero_extendqisi2
	cmp	r0, #0
	bne	.L3646
	bl	buf_alloc
	mov	r4, r0
	cmp	r0, #0
	beq	.L3645
	ldr	r6, .L3742+4
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
	beq	.L3648
	cmp	r3, #512
	bne	.L3649
.L3648:
	mov	r2, #732
	ldr	r1, .L3742+8
	ldr	r0, .L3742+12
	bl	printf
.L3649:
	ldr	r3, [r4, #12]
	ldr	r5, [r3, #4]
	mov	r0, r5
	bl	lpa_hash_get_ppa
	str	r0, [sp, #48]
	adds	r0, r0, #1
	bne	.L3650
	movs	r2, #0
	add	r1, sp, #48
	mov	r0, r5
	bl	pm_log2phys
.L3650:
	ldr	r8, [sp, #48]
	cmp	r7, r8
	bne	.L3651
	ldr	r0, .L3742+16
	movs	r3, #0
.L3654:
	adds	r2, r0, r3
	ldr	r1, [r2, #20]
	cmp	r5, r1
	bne	.L3652
	ldrb	r2, [r2, #2]	@ zero_extendqisi2
	lsls	r2, r2, #30
	bpl	.L3652
	mov	r0, r4
	bl	buf_free
	ldr	r3, .L3742+20
	ldr	r3, [r3]
	lsls	r1, r3, #23
	bpl	.L3645
	ldrh	r3, [r6, #22]
	mov	r2, r7
	mov	r1, r5
	ldr	r0, .L3742+24
	bl	printf
.L3645:
	add	sp, sp, #72
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3652:
	adds	r3, r3, #48
	cmp	r3, #1536
	bne	.L3654
	movs	r3, #0
	str	r5, [r4, #20]
	strb	r3, [r4, #41]
	ldr	r3, .L3742+28
	ldrb	r3, [r3]	@ zero_extendqisi2
	strb	r3, [r4, #40]
	ldrb	r3, [r4, #2]	@ zero_extendqisi2
	orr	r3, r3, #10
	strb	r3, [r4, #2]
	ldr	r3, [r4, #12]
	ldr	r3, [r3]
	str	r3, [r4, #16]
	ldr	r3, .L3742+20
	ldr	r3, [r3]
	lsls	r2, r3, #23
	bpl	.L3655
	mov	r0, r5
	bl	lpa_hash_get_ppa
	ldrh	r3, [r6, #22]
	mov	r2, r8
	str	r7, [sp]
	mov	r1, r5
	str	r3, [sp, #4]
	mov	r3, r0
	ldr	r0, .L3742+32
	bl	printf
.L3655:
	mov	r0, r4
	bl	ftl_gc_write_buf
	bl	ftl_write_commit
	ldr	r3, .L3742+36
	ldr	r2, [r3]
	ldr	r3, [r2, #60]
	adds	r3, r3, #1
	str	r3, [r2, #60]
	ldrh	r3, [r6, #24]
	adds	r3, r3, #1
	strh	r3, [r6, #24]	@ movhi
	b	.L3645
.L3651:
	ldr	r3, .L3742+20
	ldr	r3, [r3]
	lsls	r3, r3, #23
	bpl	.L3656
	mov	r0, r5
	bl	lpa_hash_get_ppa
	ldrh	r3, [r6, #22]
	mov	r2, r8
	str	r7, [sp]
	mov	r1, r5
	str	r3, [sp, #4]
	mov	r3, r0
	ldr	r0, .L3742+32
	bl	printf
.L3656:
	mov	r0, r4
	bl	buf_free
	b	.L3645
.L3646:
	ldr	r3, .L3742+40
	ldr	r5, .L3742+4
	ldr	r3, [r3]
	str	r3, [sp, #28]
	ldr	r3, .L3742+44
	ldrb	r8, [r3]	@ zero_extendqisi2
	ldr	r3, [sp, #28]
	cmp	r8, #3
	ldrb	r7, [r3, #89]	@ zero_extendqisi2
	bne	.L3657
	ldr	r3, .L3742+48
	ldrh	r4, [r5, #310]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L3658
	add	r1, r7, r7, lsl #1
	mov	r0, r4
	bl	__aeabi_idiv
	uxth	r10, r0
	sub	r0, r7, r7, lsl #2
	str	r8, [sp, #32]
	smulbb	r0, r0, r10
	add	r0, r0, r4
	uxth	fp, r0
.L3659:
	ldr	r3, [sp, #32]
	muls	r3, r7, r3
	str	r3, [sp, #36]
	ldr	r3, .L3742+52
	ldrh	r1, [r3]
	ldr	r3, .L3742+56
	ldr	r8, [r3]
	muls	r1, r7, r1
	ldrh	r3, [r5, #20]
	movs	r7, #0
	str	r3, [sp, #40]
	subs	r1, r1, #1
	ldr	r3, .L3742+4
.L3662:
	ldr	r0, [sp, #36]
	uxth	r2, r7
	cmp	r2, r0
	blt	.L3664
.L3696:
	movs	r6, #1
	b	.L3660
.L3658:
	mov	r0, r4
	mov	r1, r7
	bl	__aeabi_idiv
	ldr	r3, .L3742+60
	str	r8, [sp, #32]
	ldrh	r6, [r3, r0, lsl #1]
	smulbb	r0, r0, r7
	subs	r0, r4, r0
	lsr	r10, r6, #3
	uxth	fp, r0
	mla	r4, r7, r10, fp
	and	r6, r6, #7
	cmp	r6, #1
	add	r4, r4, r4, lsl #1
	uxth	r4, r4
	beq	.L3659
.L3660:
	ldr	r3, .L3742+20
	ldr	r3, [r3]
	lsls	r0, r3, #23
	bpl	.L3665
	ldr	r3, .L3742+56
	mov	r2, r6
	str	r4, [sp, #8]
	mov	r1, r10
	ldr	r0, .L3742+64
	ldr	r3, [r3]
	ldr	r3, [r3, r4, lsl #2]
	str	r3, [sp, #4]
	ldrh	r3, [r5, #310]
	str	r3, [sp]
	mov	r3, fp
	bl	printf
.L3665:
	movs	r3, #0
.L3740:
	str	r3, [sp, #40]
	ldrh	r3, [sp, #40]
	mov	r8, r3
	str	r3, [sp, #36]
	ldr	r3, [sp, #28]
	ldrb	r1, [r3, #89]	@ zero_extendqisi2
	ldr	r3, [sp, #32]
	mul	r0, r1, r3
	cmp	r8, r0
	blt	.L3681
	ldr	r3, .L3742+44
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #3
	bne	.L3682
	ldr	r3, .L3742+48
	ldrb	r2, [r3]	@ zero_extendqisi2
	ldr	r3, [sp, #48]
	cmp	r2, #0
	beq	.L3683
	movs	r2, #0
.L3686:
	strb	r2, [r3, #44]
	add	r0, sp, #48
	mov	r2, r1
	add	r1, sp, #60
	bl	sblk_xlc_prog_pages
.L3687:
	ldr	r3, [sp, #28]
	ldr	r1, .L3742+48
	ldrb	r2, [r3, #89]	@ zero_extendqisi2
	ldrb	r1, [r1]	@ zero_extendqisi2
	uxth	r3, r2
	cmp	r1, #0
	beq	.L3692
	add	r3, r3, r3, lsl #1
.L3693:
	ldr	r1, .L3742+36
	ldr	r0, [r1]
	ldr	r1, [r0, #52]
	add	r1, r1, r3
	str	r1, [r0, #52]
	ldr	r1, .L3742+4
	ldrh	r0, [r1, #310]
	add	r3, r3, r0
	uxth	r3, r3
	strh	r3, [r1, #310]	@ movhi
	ldr	r1, .L3742+52
	ldrh	r1, [r1]
	muls	r2, r1, r2
	cmp	r3, r2
	itttt	ge
	ldrge	r3, .L3742+40
	movge	r2, #0
	ldrge	r3, [r3]
	strhge	r2, [r3, #86]	@ movhi
	bl	gc_write_completed
	b	.L3645
.L3657:
	ldr	r3, .L3742+68
	mov	r1, r7
	ldrh	r4, [r5, #310]
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r0, r4
	cbnz	r3, .L3661
	bl	__aeabi_idiv
	uxth	r10, r0
	movs	r3, #1
	smulbb	r0, r7, r10
	subs	r0, r4, r0
	uxth	fp, r0
.L3738:
	str	r3, [sp, #32]
	b	.L3659
.L3661:
	bl	__aeabi_idiv
	uxth	r10, r0
	movs	r3, #2
	smulbb	r0, r7, r10
	subs	r0, r4, r0
	uxth	fp, r0
	b	.L3738
.L3743:
	.align	2
.L3742:
	.word	.LANCHOR76
	.word	.LANCHOR63
	.word	.LANCHOR218
	.word	.LC0
	.word	.LANCHOR50
	.word	.LANCHOR14
	.word	.LC232
	.word	.LANCHOR123
	.word	.LC233
	.word	.LANCHOR102
	.word	.LANCHOR10
	.word	.LANCHOR71
	.word	.LANCHOR75
	.word	.LANCHOR77
	.word	.LANCHOR153
	.word	.LANCHOR219
	.word	.LC234
	.word	.LANCHOR72
.L3664:
	add	r2, r2, r4
	cmp	r2, r1
	beq	.L3696
	ldr	r0, [r8, r2, lsl #2]
	adds	r0, r0, #1
	bne	.L3663
	ldrh	r6, [r3, #22]
	str	r3, [sp, #44]
	ldr	r3, [sp, #40]
	cmp	r6, r3
	bcs	.L3645
	mov	r0, r6
	adds	r6, r6, #1
	bl	gc_get_src_ppa_from_index
	ldr	r3, [sp, #44]
	strh	r6, [r3, #22]	@ movhi
	str	r0, [r8, r2, lsl #2]
.L3663:
	adds	r7, r7, #1
	b	.L3662
.L3681:
	ldr	r3, .L3744
	add	r7, r4, r8
	ldr	r3, [r3]
	ldrb	r3, [r3, r7]	@ zero_extendqisi2
	cmp	r3, #255
	bne	.L3667
	movs	r0, #0
	bl	buf_alloc
	mov	r5, r0
	cbnz	r0, .L3668
	bl	sblk_wait_write_queue_completed
	bl	ftl_write_completed
	bl	gc_write_completed
	bl	gc_free_temp_buf
	mov	r0, r5
	bl	buf_alloc
	mov	r5, r0
	cmp	r0, #0
	beq	.L3645
.L3668:
	ldr	r3, .L3744
	ldrb	r2, [r5, #1]	@ zero_extendqisi2
	ldr	r3, [r3]
	strb	r2, [r3, r7]
	ldr	r2, .L3744+4
	strb	r6, [r5, #45]
	ldrb	r3, [r2, #7]	@ zero_extendqisi2
	adds	r3, r3, #1
	strb	r3, [r2, #7]
	ldr	r3, [sp, #36]
	add	r3, r3, r4
	strh	r3, [r5, #32]	@ movhi
	ldr	r3, .L3744+8
	ldrh	r2, [r3]
	ldr	r3, [sp, #28]
	ldrb	r3, [r3, #89]	@ zero_extendqisi2
	muls	r3, r2, r3
	subs	r3, r3, #1
	cmp	r7, r3
	bne	.L3669
	ldr	r3, .L3744+12
	ldr	r0, [r5, #4]
	ldr	r1, [r3]
	mov	r3, #-1
	str	r3, [r1, r7, lsl #2]
	ldr	r3, .L3744+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	muls	r2, r3, r2
	lsls	r2, r2, #2
	bl	ftl_memcpy
	ldr	r3, .L3744+8
	ldr	r2, .L3744+16
	ldr	r0, [r5, #4]
	ldrh	r3, [r3]
	ldrb	r2, [r2]	@ zero_extendqisi2
	muls	r2, r3, r2
	ldr	r3, .L3744+20
	ldr	r1, [r3]
	lsls	r2, r2, #2
	add	r0, r0, r2
	bl	ftl_memcpy
	ldr	r3, .L3744+24
	movs	r1, #0
	ldr	r0, [r5, #12]
	ldrb	r2, [r3]	@ zero_extendqisi2
	lsls	r2, r2, #1
	bl	ftl_memset
	ldr	r3, [r5, #12]
	ldr	r2, .L3744+28
	ldr	r0, [r5, #4]
	str	r3, [sp, #44]
	str	r2, [r3]
	ldr	r3, .L3744+8
	ldrh	r2, [r3]
	ldr	r3, .L3744+16
	ldrb	r1, [r3]	@ zero_extendqisi2
	muls	r1, r2, r1
	lsls	r1, r1, #2
	bl	js_hash
	ldr	r2, .L3744+32
	ldr	r3, [sp, #44]
	ldr	r2, [r2]
	str	r0, [r3, #4]
	ldr	r2, [r2, #132]
.L3739:
	str	r2, [r3, #8]
.L3667:
	ldr	r3, .L3744
	ldr	r2, .L3744+36
	ldr	ip, [r3]
	add	r3, sp, #72
	add	r1, r3, r8, lsl #2
	ldrb	r5, [ip, r7]	@ zero_extendqisi2
	add	r3, r5, r5, lsl #1
	add	r3, r2, r3, lsl #4
	str	r3, [r1, #-24]
	movs	r3, #48
	mla	r2, r3, r5, r2
	movs	r3, #2
	strh	r3, [r2, #34]	@ movhi
	ldr	r3, .L3744+40
	strb	r6, [r2, #45]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #3
	bne	.L3676
	ldr	r3, [sp, #36]
	ldr	r0, .L3744+44
	umull	r0, r1, r3, r0
	ldr	r0, [sp, #28]
	lsrs	r3, r1, #1
	uxtah	r1, fp, r3
	add	r3, r3, r3, lsl #1
	add	r1, r0, r1, lsl #1
	ldrh	r0, [r1, #96]
	ldr	r1, .L3744+48
	ldrh	r1, [r1]
	muls	r1, r0, r1
	ldrh	r0, [r2, #32]
	orr	r1, r1, r10
	str	r1, [r2, #24]
	ldr	r2, .L3744+52
	ldr	lr, [r2]
	ldr	r2, [sp, #36]
	subs	r3, r2, r3
	lsls	r3, r3, #24
	add	r3, r3, #16777216
	orrs	r1, r1, r3
	str	r1, [lr, r0, lsl #2]
.L3677:
	ldr	r3, .L3744+56
	ldr	r3, [r3]
	lsls	r3, r3, #23
	bpl	.L3680
	ldr	r3, .L3744+4
	movs	r2, #48
	ldr	r0, .L3744+60
	ldrb	r1, [r3, #6]	@ zero_extendqisi2
	ldr	r3, .L3744+36
	mla	r5, r2, r5, r3
	ldr	r2, .L3744+44
	ldr	r3, [r5, #12]
	ldr	r3, [r3, #4]
	str	r3, [sp, #20]
	ldr	r3, [sp, #36]
	umull	r2, r3, r3, r2
	mov	r2, r6
	ubfx	r3, r3, #1, #16
	add	r3, r3, fp
	str	r3, [sp, #16]
	ldrb	r3, [r5, #1]	@ zero_extendqisi2
	str	r3, [sp, #12]
	ldrh	r3, [r5, #32]
	str	r3, [sp, #8]
	ldr	r3, [r5, #24]
	str	r3, [sp, #4]
	ldrb	r3, [ip, r7]	@ zero_extendqisi2
	str	r3, [sp]
	mov	r3, r1
	mov	r1, r8
	bl	printf
.L3680:
	ldr	r3, [sp, #40]
	adds	r3, r3, #1
	b	.L3740
.L3669:
	ldr	r3, .L3744+20
	movs	r1, #1
	mov	r0, r5
	ldr	r3, [r3]
	ldr	r3, [r3, r7, lsl #2]
	str	r3, [r5, #24]
	bl	sblk_read_page
	ldr	r3, [r5, #36]
	adds	r1, r3, #1
	beq	.L3670
	cmp	r3, #512
	bne	.L3674
.L3670:
	ldr	r3, .L3744+64
	ldrh	r2, [r3]
	movs	r3, #1
	rsb	r0, r2, #21
	lsls	r3, r3, r0
	ldr	r0, [r5, #24]
	subs	r3, r3, #1
	lsrs	r0, r0, r2
	ldr	r2, .L3744+68
	ands	r0, r0, r3
	ldrb	r1, [r2]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	movs	r1, #0
	uxth	r0, r0
	bl	ftl_sblk_dump
	ldr	r3, [r5, #36]
	adds	r2, r3, #1
	beq	.L3672
	cmp	r3, #512
	bne	.L3674
.L3672:
	ldr	r3, [r5, #12]
	mov	r2, #-1
	str	r2, [r3, #4]
	ldr	r3, [r5, #36]
	cmp	r3, r2
	beq	.L3673
	cmp	r3, #512
	bne	.L3674
.L3673:
	movw	r2, #847
	ldr	r1, .L3744+72
	ldr	r0, .L3744+76
	bl	printf
.L3674:
	ldr	r3, [r5, #12]
	ldr	r2, .L3744+80
	ldr	r1, [r3, #4]
	ldr	r2, [r2]
	cmp	r1, r2
	itt	cs
	movcs	r2, #-1
	strcs	r2, [r3, #4]
	ldr	r2, .L3744+12
	ldr	r1, [r3, #4]
	ldr	r2, [r2]
	str	r1, [r2, r7, lsl #2]
	ldr	r2, [r5, #24]
	b	.L3739
.L3676:
	cmp	r3, #2
	bne	.L3678
	ldr	r3, .L3744+84
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L3679
	ldr	r1, [sp, #28]
	add	r3, r8, fp
	add	r3, r1, r3, lsl #1
	ldr	r1, .L3744+48
	ldrh	r3, [r3, #96]
	ldrh	r1, [r1]
	mla	r3, r1, r3, r10
.L3741:
	orr	r3, r3, #33554432
	str	r3, [r2, #24]
.L3678:
	ldr	r2, .L3744+36
	movs	r3, #48
	mla	r3, r3, r5, r2
	ldr	r1, [r3, #24]
	ldrh	r2, [r3, #32]
	ldr	r3, .L3744+52
	ldr	r3, [r3]
	str	r1, [r3, r2, lsl #2]
	b	.L3677
.L3679:
	ldr	r3, [sp, #36]
	ldr	r1, [sp, #28]
	add	r3, fp, r3, lsr #1
	add	r3, r1, r3, lsl #1
	ldr	r1, .L3744+48
	ldrh	r3, [r3, #96]
	ldrh	r1, [r1]
	mla	r3, r1, r3, r10
	ldr	r1, [sp, #36]
	and	r1, r1, #1
	add	r3, r3, r1
	b	.L3741
.L3683:
	cmp	r6, #1
	bne	.L3685
	movs	r2, #9
	b	.L3686
.L3685:
	cmp	r6, #2
	it	eq
	moveq	r2, #13
	b	.L3686
.L3745:
	.align	2
.L3744:
	.word	.LANCHOR74
	.word	.LANCHOR63
	.word	.LANCHOR77
	.word	.LANCHOR152
	.word	.LANCHOR78
	.word	.LANCHOR153
	.word	.LANCHOR123
	.word	-178307901
	.word	.LANCHOR10
	.word	.LANCHOR50
	.word	.LANCHOR71
	.word	-1431655765
	.word	.LANCHOR103
	.word	.LANCHOR154
	.word	.LANCHOR14
	.word	.LC235
	.word	.LANCHOR66
	.word	.LANCHOR67
	.word	.LANCHOR218
	.word	.LC0
	.word	.LANCHOR120
	.word	.LANCHOR72
.L3682:
	ldr	r3, .L3746
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L3688
	ldr	r3, .L3746+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L3689
.L3688:
	subs	r0, r0, #1
.L3690:
	uxth	r2, r3
	adds	r3, r3, #1
	cmp	r2, r0
	blt	.L3691
	add	r3, sp, #72
	movs	r2, #255
	add	r0, r3, r0, lsl #2
	ldr	r3, [r0, #-24]
	strb	r2, [r3]
	ldrh	r3, [sp, #32]
	ldr	r0, [sp, #48]
	smulbb	r1, r3, r1
	uxtb	r1, r1
	bl	sblk_prog_page
	b	.L3687
.L3689:
	add	r0, sp, #48
	bl	sblk_3d_mlc_prog_pages
	b	.L3687
.L3691:
	add	r4, sp, #72
	add	r5, sp, #72
	add	r4, r4, r2, lsl #2
	add	r2, r5, r2, lsl #2
	ldr	r2, [r2, #-20]
	ldr	r4, [r4, #-24]
	ldrb	r2, [r2, #1]	@ zero_extendqisi2
	strb	r2, [r4]
	b	.L3690
.L3692:
	ldr	r1, .L3746
	ldrb	r1, [r1]	@ zero_extendqisi2
	cmp	r1, #0
	beq	.L3693
	lsls	r3, r3, #1
	uxth	r3, r3
	b	.L3693
.L3747:
	.align	2
.L3746:
	.word	.LANCHOR72
	.word	.LANCHOR73
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
	ldr	r3, .L3924
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #48
	ldr	r4, .L3924+4
	ldrh	r7, [r3]
	ldr	r3, .L3924+8
	ldr	r2, .L3924+12
	str	r0, [sp, #32]
	ldrh	r6, [r3]
	ldrb	r3, [r4]	@ zero_extendqisi2
	mov	r8, r2
	ldr	r5, [r2]
	add	r6, r6, r7
	uxth	r6, r6
	cmp	r3, #6
	bhi	.L3856
	tbh	[pc, r3, lsl #1]
.L3751:
	.2byte	(.L3750-.L3751)/2
	.2byte	(.L3752-.L3751)/2
	.2byte	(.L3753-.L3751)/2
	.2byte	(.L3754-.L3751)/2
	.2byte	(.L3755-.L3751)/2
	.2byte	(.L3756-.L3751)/2
	.2byte	(.L3757-.L3751)/2
	.p2align 1
.L3756:
	ldr	r5, .L3924+16
	movs	r7, #0
.L3758:
	bl	gc_check_data_one_wl
	mov	r10, r0
	cmp	r0, #0
	beq	.L3852
	ldr	r3, [r8]
	movs	r6, #0
	strh	r6, [r5, #52]	@ movhi
	ldrh	r0, [r3, #80]
	bl	ftl_free_sblk
	ldr	r1, .L3924+20
	movw	r3, #65535
	ldr	r2, [r8]
	ldr	r0, [r5, #8]
	ldr	r1, [r1]
	strh	r3, [r2, #80]	@ movhi
	strh	r3, [r1, #126]	@ movhi
	strh	r3, [r2, #130]	@ movhi
	bl	buf_free
	str	r6, [r5, #8]
	strb	r6, [r4]
	b	.L3921
.L3750:
	ldr	r3, .L3924+24
	ldr	r1, .L3924+28
	ldr	r2, .L3924+32
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
	beq	.L3759
	ldr	r3, [sp, #32]
	cbnz	r3, .L3760
	ldr	r3, .L3924+36
	ldrh	r3, [r3]
	cmp	r6, r3, lsl #1
	blt	.L3760
.L3856:
	movs	r5, #16
	b	.L3748
.L3760:
	ldr	r10, .L3924+84
	movs	r1, #5
	ldr	fp, .L3924+72
	ldrh	r0, [r10]
	adds	r0, r0, #1
	uxth	r0, r0
	strh	r0, [r10]	@ movhi
	bl	zftl_get_gc_node
	movw	r3, #65535
	mov	ip, r10
	cmp	r0, r3
	beq	.L3761
	ldr	r1, .L3924+40
	ldr	lr, .L3924+80
	ldr	r2, .L3924+44
	ldr	r1, [r1]
	ldrh	lr, [lr]
	ldr	r3, [r2]
	mov	r10, r2
	ldrh	r1, [r1, r0, lsl #1]
	adds	r3, r3, #1
	cmp	lr, r1
	str	r3, [r2]
	bcs	.L3762
	ldr	r2, .L3924+48
	ldrh	r2, [r2]
	cmp	r3, r2, lsr #4
	bls	.L3761
	ldr	r3, .L3924+52
	ldrh	r3, [r3]
	cmp	r3, r1
	bls	.L3761
.L3762:
	ldrb	r2, [fp]	@ zero_extendqisi2
	movs	r1, #0
	bl	gc_add_sblk
	cbz	r0, .L3763
	movs	r3, #1
	strb	r3, [r4]
	movs	r3, #0
	str	r3, [r10]
	b	.L3856
.L3761:
	movs	r3, #0
	strh	r3, [ip]	@ movhi
.L3763:
	cmp	r7, #15
	bls	.L3858
	ldr	r3, .L3924+56
	ldrh	r2, [r3]
	ldr	r3, .L3924+60
	ldrh	r3, [r3]
	cmp	r2, r3
	bhi	.L3858
	ldr	r3, [sp, #28]
	cmp	r3, #0
	ite	eq
	moveq	r10, #2
	movne	r10, #1
.L3764:
	ldr	r3, .L3924+64
	ldr	r3, [r3]
	lsls	r3, r3, #23
	bpl	.L3765
	ldr	r3, [r8]
	ldrh	r1, [r5, #80]
	ldrb	r2, [fp]	@ zero_extendqisi2
	ldr	r0, .L3924+68
	str	r1, [sp, #16]
	ldrh	r1, [r3, #122]
	str	r1, [sp, #12]
	ldrh	r1, [r3, #120]
	str	r1, [sp, #8]
	movw	r1, #1983
	ldrh	r3, [r3, #124]
	str	r7, [sp]
	str	r3, [sp, #4]
	mov	r3, r6
	bl	printf
.L3765:
	movs	r2, #1
	mov	r1, r10
	ldrb	r0, [fp]	@ zero_extendqisi2
	bl	gc_search_src_blk
	cmp	r0, #0
	ble	.L3766
.L3767:
	movs	r3, #1
.L3922:
	strb	r3, [r4]
	b	.L3856
.L3858:
	mov	r10, #2
	b	.L3764
.L3766:
	movs	r2, #1
	movs	r1, #3
	ldrb	r0, [fp]	@ zero_extendqisi2
	bl	gc_search_src_blk
	cmp	r0, #0
	bgt	.L3767
	b	.L3856
.L3759:
	ldr	r3, .L3924+64
	ldr	r2, [r3]
	str	r3, [sp, #44]
	tst	r2, #256
	beq	.L3769
	ldr	r3, .L3924+72
	movw	r1, #1995
	ldr	r0, .L3924+68
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
.L3769:
	ldr	r3, [sp, #32]
	cmp	r3, #1
	bne	.L3770
	bl	gc_scan_static_data
	ldr	r3, [r8]
	ldr	fp, .L3924+72
	ldrh	r3, [r3, #122]
	cbz	r3, .L3771
.L3772:
	movs	r3, #1
	strb	r3, [fp]
	b	.L3922
.L3771:
	bl	gc_static_wearleveling
	mov	r5, r0
	cmp	r0, #0
	bne	.L3772
	cmp	r7, #0
	bne	.L3773
.L3777:
	movs	r5, #16
.L3774:
	ldr	r0, [r8]
	movs	r1, #1
	ldr	r3, .L3924+72
	ldrh	fp, [r0, #124]
	strb	r1, [r3]
	mov	r8, r3
	cmp	fp, #0
	beq	.L3782
	movs	r2, #0
	strb	r1, [r4]
	strb	r2, [r3]
	ldr	r3, [sp, #44]
	ldr	r3, [r3]
	lsls	r4, r3, #23
	bpl	.L3748
	ldrh	r3, [r0, #122]
	movw	r1, #2085
	str	r3, [sp, #12]
	ldrh	r3, [r0, #120]
	stm	sp, {r7, fp}
	ldr	r0, .L3924+76
	str	r3, [sp, #8]
	mov	r3, r6
	bl	printf
.L3748:
	mov	r0, r5
	add	sp, sp, #48
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3925:
	.align	2
.L3924:
	.word	.LANCHOR99
	.word	.LANCHOR150
	.word	.LANCHOR95
	.word	.LANCHOR10
	.word	.LANCHOR63
	.word	.LANCHOR102
	.word	.LANCHOR97
	.word	.LANCHOR90
	.word	.LANCHOR88
	.word	.LANCHOR79
	.word	.LANCHOR9
	.word	.LANCHOR151
	.word	.LANCHOR6
	.word	.LANCHOR91
	.word	.LANCHOR92
	.word	.LANCHOR93
	.word	.LANCHOR14
	.word	.LC236
	.word	.LANCHOR76
	.word	.LC237
	.word	.LANCHOR85
	.word	.LANCHOR87
.L3773:
	ldr	r3, [sp, #28]
	ldr	r2, .L3926
	cmp	r6, r3
	bcs	.L3775
	ldrh	r3, [r2]
	cmp	r3, r6
	bhi	.L3776
.L3775:
	ldr	r3, [sp, #28]
	ldrh	r2, [r2]
	adds	r3, r6, r3
	cmp	r3, r2
	blt	.L3776
	ldr	r3, .L3926+4
	ldrh	r2, [r3]
	ldr	r3, .L3926+8
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L3777
.L3776:
	mov	r10, #1
	ldr	r2, .L3926+12
	strb	r10, [fp]
	ldr	fp, .L3926+32
	ldrh	r2, [r2]
	ldr	r3, [fp]
	add	r3, r3, r10
	cmp	r3, r2, lsr #5
	str	r3, [fp]
	ldr	r3, .L3926+4
	bls	.L3778
	ldrh	r2, [r3]
	cmp	r2, r7
	bls	.L3778
	movs	r1, #5
	movs	r0, #0
	bl	zftl_get_gc_node
	movw	r3, #65535
	cmp	r0, r3
	beq	.L3777
	ldr	r3, .L3926+16
	ldr	r3, [r3]
	ldrh	r2, [r3, r0, lsl #1]
	ldr	r3, .L3926+20
	ldrh	r1, [r3]
	ldr	r3, .L3926+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	muls	r3, r1, r3
	cmp	r2, r3
	bgt	.L3777
	movs	r2, #4
	movs	r1, #2
	mov	r0, r10
	movs	r3, #0
	str	r3, [fp]
.L3912:
	bl	gc_search_src_blk
	uxth	r0, r0
	cmp	r0, #0
	beq	.L3777
	b	.L3767
.L3778:
	ldrh	r2, [r3]
	ldr	r3, .L3926+8
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L3780
	movs	r2, #1
	movs	r1, #2
	mov	r0, r2
	b	.L3912
.L3780:
	ldr	r3, [sp, #36]
	ldrh	r3, [r3]
	cbnz	r3, .L3781
	ldr	r3, [sp, #40]
	ldrh	r3, [r3]
	cmp	r3, #8
	bls	.L3774
.L3781:
	movs	r1, #1
	movs	r2, #4
	mov	r0, r1
	b	.L3912
.L3770:
	ldr	r3, .L3926+28
	ldrh	r3, [r3]
	cmp	r3, r6
	bcc	.L3856
	b	.L3777
.L3782:
	ldr	r2, .L3926+28
	ldrh	ip, [r2]
	mov	r10, r2
	cmp	r6, ip
	bcs	.L3783
	cmp	r7, #0
	beq	.L3784
	cmp	r7, #16
	bls	.L3785
	ldr	r2, .L3926+4
	ldrh	r0, [r2]
	ldr	r2, .L3926+8
	ldrh	r2, [r2]
	cmp	r0, r2
	bhi	.L3785
	movs	r2, #4
	mov	r0, r1
	str	r3, [sp, #28]
	bl	gc_search_src_blk
	uxth	r0, r0
	ldr	r3, [sp, #28]
	cbnz	r0, .L3786
	ldrb	r0, [r3]	@ zero_extendqisi2
	movs	r2, #4
	movs	r1, #3
.L3914:
	bl	gc_search_src_blk
	uxth	r0, r0
.L3787:
	cbnz	r0, .L3789
	b	.L3748
.L3786:
	movs	r1, #5
	mov	r0, fp
	bl	zftl_get_gc_node
	movw	r3, #65535
	cmp	r0, r3
	beq	.L3789
	ldr	r1, .L3926+16
	ldr	r6, .L3926+20
	ldr	r2, .L3926+32
	ldr	r1, [r1]
	ldrh	r6, [r6]
	ldr	r3, [r2]
	ldrh	r1, [r1, r0, lsl #1]
	adds	r3, r3, #1
	cmp	r6, r1
	str	r3, [r2]
	mov	r6, r2
	bcs	.L3790
	ldr	r2, .L3926+12
	ldrh	r2, [r2]
	cmp	r3, r2, lsr #4
	bls	.L3789
	ldr	r3, .L3926+36
	ldrh	r3, [r3]
	cmp	r3, r1
	bls	.L3789
.L3790:
	ldrb	r2, [r8]	@ zero_extendqisi2
	movs	r1, #0
	bl	gc_add_sblk
	ldr	r3, .L3926+40
	movs	r2, #1
	str	r2, [r3]
	movs	r3, #0
	str	r3, [r6]
.L3789:
	movs	r3, #1
	strb	r3, [r4]
	b	.L3748
.L3785:
	movs	r2, #1
	movs	r1, #2
	mov	r0, r2
.L3920:
	bl	gc_search_src_blk
	uxth	r0, r0
	cmp	r0, #0
	bne	.L3789
	movs	r2, #2
.L3917:
	movs	r1, #3
	ldrb	r0, [r8]	@ zero_extendqisi2
	b	.L3914
.L3784:
	strb	r7, [r3]
	ldr	r3, [sp, #44]
	ldr	r3, [r3]
	lsls	r1, r3, #23
	bpl	.L3792
	ldrh	r3, [r0, #122]
	mov	r2, r7
	movw	r1, #2115
	str	r3, [sp, #12]
	ldrh	r3, [r0, #120]
	str	r7, [sp, #4]
	str	r7, [sp]
	str	r3, [sp, #8]
	mov	r3, r6
	ldr	r0, .L3926+44
	bl	printf
.L3792:
	cmp	r6, #16
	bls	.L3793
	movs	r2, #4
	b	.L3917
.L3793:
	movs	r2, #1
	ldrb	r0, [r8]	@ zero_extendqisi2
	mov	r1, r2
	b	.L3920
.L3783:
	ldr	r3, [sp, #32]
	cmp	r3, #1
	bne	.L3748
	cmp	r6, ip, lsl #1
	bge	.L3794
	ldr	r3, [sp, #28]
	cmp	r3, r7, lsr #1
	bcs	.L3795
	ldr	r3, .L3926+4
	ldrh	r1, [r3]
	ldr	r3, .L3926+8
	ldrh	r3, [r3]
	cmp	r1, r3
	bcs	.L3795
	ldr	r3, .L3926
	ldrh	r3, [r3]
	lsrs	r3, r3, #2
	strh	r3, [r2]	@ movhi
	b	.L3748
.L3795:
	movs	r1, #5
	movs	r0, #0
	bl	zftl_get_gc_node
	movw	r3, #65535
	mov	fp, r0
	cmp	r0, r3
	bne	.L3796
.L3801:
	cmp	r7, #1
	bhi	.L3797
.L3798:
	ldr	r3, [sp, #28]
	cmp	r6, r3
	ldr	r6, .L3926
	bcs	.L3805
	movs	r7, #0
	movs	r0, #4
	strb	r7, [r8]
	bl	zftl_get_gc_node.part.9
	movw	r3, #65535
	cmp	r0, r3
	beq	.L3805
	ldr	r3, .L3926+16
	ldr	r3, [r3]
	ldrh	r2, [r3, r0, lsl #1]
	ldr	r3, .L3926+20
	ldrh	r1, [r3]
	ldr	r3, .L3926+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	muls	r3, r1, r3
	cmp	r2, r3, asr #1
	ble	.L3807
.L3805:
	ldrh	r3, [r6]
	lsrs	r3, r3, #2
	strh	r3, [r10]	@ movhi
	b	.L3748
.L3796:
	ldr	r2, .L3926+32
	ldr	r1, .L3926+12
	ldr	r3, [r2]
	ldrh	r1, [r1]
	adds	r3, r3, #1
	str	r3, [r2]
	cmp	r3, r1, lsr #4
	ldr	r3, .L3926+16
	bls	.L3799
	movs	r1, #0
	str	r1, [r2]
	ldr	r2, [r3]
	ldrh	ip, [r2, r0, lsl #1]
	ldr	r2, .L3926+36
	ldrh	r2, [r2]
	cmp	ip, r2
	bcs	.L3799
	movs	r2, #1
	str	r3, [sp, #32]
	bl	gc_add_sblk
	ldr	r3, [sp, #32]
	cmp	r0, #0
	bne	.L3789
.L3799:
	ldr	r3, [r3]
	ldrh	r2, [r3, fp, lsl #1]
	ldr	r3, .L3926+20
	ldrh	r3, [r3]
	cmp	r2, r3, lsr #1
	bhi	.L3800
	movs	r2, #0
	movs	r1, #1
	mov	r0, fp
	bl	gc_add_sblk
	b	.L3789
.L3800:
	ldr	r3, [sp, #36]
	ldr	r1, [sp, #40]
	ldrh	r3, [r3]
	ldrh	r1, [r1]
	add	r3, r3, r1
	ldr	r1, .L3926
	ldrh	r1, [r1]
	cmp	r3, r1, lsl #1
	ble	.L3801
	ldr	r3, .L3926+36
	ldrh	r3, [r3]
	cmp	r3, r2
	bcc	.L3798
	b	.L3801
.L3927:
	.align	2
.L3926:
	.word	.LANCHOR89
	.word	.LANCHOR92
	.word	.LANCHOR93
	.word	.LANCHOR6
	.word	.LANCHOR9
	.word	.LANCHOR85
	.word	.LANCHOR78
	.word	.LANCHOR79
	.word	.LANCHOR151
	.word	.LANCHOR91
	.word	.LANCHOR114
	.word	.LC237
.L3797:
	cmp	r7, #16
	mov	r1, #1
	strb	r1, [r8]
	bls	.L3802
	ldr	r3, .L3928
	ldrh	r2, [r3]
	ldr	r3, .L3928+4
	ldrh	r3, [r3]
	cmp	r2, r3
	bhi	.L3802
	movs	r2, #4
	mov	r0, r1
	bl	gc_search_src_blk
	uxth	r0, r0
	cbnz	r0, .L3803
	movs	r2, #4
.L3913:
	movs	r1, #3
	ldrb	r0, [r8]	@ zero_extendqisi2
	bl	gc_search_src_blk
	uxth	r0, r0
.L3803:
	ldr	r3, [sp, #28]
	cmp	r6, r3, lsr #1
	ldr	r3, .L3928+8
	ldrh	r3, [r3]
	bls	.L3915
	lsrs	r3, r3, #2
.L3916:
	strh	r3, [r10]	@ movhi
	b	.L3787
.L3802:
	movs	r2, #1
	movs	r1, #2
	mov	r0, r2
	bl	gc_search_src_blk
	uxth	r0, r0
	cmp	r0, #0
	bne	.L3803
	movs	r2, #2
	b	.L3913
.L3807:
	movs	r2, #4
	movs	r1, #3
	mov	r0, r7
	bl	gc_search_src_blk
	ldrh	r3, [r6]
	uxth	r0, r0
.L3915:
	lsrs	r3, r3, #1
	b	.L3916
.L3794:
	ldr	r3, .L3928+8
	mov	r5, fp
	ldrh	r3, [r3]
	lsrs	r3, r3, #2
	strh	r3, [r2]	@ movhi
	b	.L3748
.L3752:
	ldr	r5, .L3928+12
	movw	r3, #65535
	ldrh	r2, [r5]
	cmp	r2, r3
	bne	.L3808
	bl	gc_get_src_blk
	strh	r0, [r5]	@ movhi
.L3808:
	ldrh	r1, [r5]
	movw	r3, #65535
	cmp	r1, r3
	beq	.L3923
	ldr	r3, .L3928+16
	ldrh	r0, [r5, #52]
	ldr	r3, [r3]
	add	r3, r3, r1, lsl #2
	cbz	r0, .L3810
	ldr	r5, .L3928+20
	movs	r2, #0
.L3811:
	uxth	r6, r2
	cmp	r0, r6
	bhi	.L3812
.L3810:
	ldrb	r3, [r3, #2]	@ zero_extendqisi2
	and	r2, r3, #224
	cmp	r2, #224
	beq	.L3813
	tst	r3, #192
	bne	.L3814
.L3813:
	ldr	r3, .L3928+24
	ldr	r3, [r3]
	ldrh	r3, [r3, r1, lsl #1]
	cbz	r3, .L3816
	movw	r2, #2348
	ldr	r1, .L3928+28
	ldr	r0, .L3928+32
	bl	printf
	b	.L3816
.L3812:
	ldrh	r6, [r5, #2]!
	adds	r2, r2, #1
	cmp	r6, r1
	bne	.L3811
.L3816:
	ldr	r3, .L3928+12
	movw	r2, #65535
	strh	r2, [r3]	@ movhi
	b	.L3856
.L3814:
	movs	r3, #2
	b	.L3922
.L3753:
	bl	gc_scan_src_blk
	adds	r0, r0, #1
	bne	.L3817
	movs	r3, #3
	b	.L3922
.L3817:
	ldr	r3, .L3928+12
	movw	r1, #65535
	ldrh	r2, [r3]
	mov	r5, r3
	cmp	r2, r1
	beq	.L3767
	ldrh	r1, [r3, #20]
	cbz	r1, .L3818
	movs	r2, #4
	strb	r2, [r4]
	movs	r2, #0
	strh	r2, [r3, #22]	@ movhi
	b	.L3856
.L3818:
	movs	r3, #1
	strb	r3, [r4]
	ldr	r4, .L3928+24
	ldr	r1, [r4]
	ldrh	r2, [r1, r2, lsl #1]
	cbz	r2, .L3819
	movw	r2, #2376
	ldr	r1, .L3928+28
	ldr	r0, .L3928+32
	bl	printf
.L3819:
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
	bhi	.L3820
	strh	r3, [r5, #26]	@ movhi
	b	.L3816
.L3820:
	strh	r4, [r5, #26]	@ movhi
	bl	ftl_flush
	bl	pm_flush
	bl	ftl_ext_info_flush
	mov	r0, r4
	bl	ftl_info_flush
	b	.L3816
.L3754:
	ldr	r7, .L3928+12
	mov	r5, r7
.L3893:
	bl	gc_scan_src_blk_one_page
	ldr	r3, .L3928+36
	ldrh	r2, [r7, #2]
	ldrh	r3, [r3]
	cmp	r2, r3
	bcs	.L3822
	cmp	r6, #7
	bls	.L3893
	b	.L3856
.L3822:
	ldrh	r3, [r7, #20]
	ldr	r2, .L3928+40
	cbz	r3, .L3823
	ldr	r2, [r2]
	movs	r1, #4
	strb	r1, [r4]
	movs	r1, #0
	strh	r1, [r7, #22]	@ movhi
	tst	r2, #256
	ldr	r4, .L3928+24
	beq	.L3824
	ldrh	r1, [r7]
	ldr	r2, [r4]
	ldr	r0, .L3928+44
	ldrh	r2, [r2, r1, lsl #1]
	bl	printf
.L3824:
	ldr	r3, [r4]
	ldrh	r2, [r5]
	ldrh	r2, [r3, r2, lsl #1]
	ldrh	r3, [r5, #20]
	cmp	r2, r3
	beq	.L3825
	movw	r2, #2410
	ldr	r1, .L3928+28
	ldr	r0, .L3928+32
	bl	printf
.L3825:
	ldrh	r1, [r5, #20]
	ldrh	r2, [r5]
	ldr	r3, [r4]
	strh	r1, [r3, r2, lsl #1]	@ movhi
	b	.L3856
.L3823:
	ldr	r3, .L3928+16
	ldrh	r1, [r7]
	ldr	r6, [r3]
	movs	r3, #1
	strb	r3, [r4]
	ldr	r3, [r2]
	add	r6, r6, r1, lsl #2
	lsls	r2, r3, #23
	bpl	.L3826
	ldrb	r2, [r6, #2]	@ zero_extendqisi2
	ldr	r0, .L3928+48
	lsrs	r2, r2, #5
	bl	printf
.L3826:
	ldrb	r3, [r6, #2]	@ zero_extendqisi2
	and	r2, r3, #224
	cmp	r2, #224
	beq	.L3827
	tst	r3, #192
	bne	.L3828
.L3827:
	movw	r2, #2420
	ldr	r1, .L3928+28
	ldr	r0, .L3928+32
	bl	printf
.L3828:
	ldrh	r0, [r5]
	bl	ftl_free_sblk
	movw	r3, #65535
	strh	r3, [r5]	@ movhi
	ldrh	r3, [r5, #26]
	adds	r3, r3, #1
	uxth	r3, r3
	cmp	r3, #8
	bhi	.L3829
	strh	r3, [r5, #26]	@ movhi
	b	.L3856
.L3829:
	movs	r3, #0
	strh	r3, [r5, #26]	@ movhi
.L3921:
	bl	flt_sys_flush
	b	.L3856
.L3929:
	.align	2
.L3928:
	.word	.LANCHOR92
	.word	.LANCHOR93
	.word	.LANCHOR89
	.word	.LANCHOR63
	.word	.LANCHOR7
	.word	.LANCHOR63+52
	.word	.LANCHOR9
	.word	.LANCHOR220
	.word	.LC0
	.word	.LANCHOR85
	.word	.LANCHOR14
	.word	.LC238
	.word	.LC239
.L3755:
	ldrh	r2, [r5, #80]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L3830
	ldr	r3, .L3930
	ldrb	r7, [r3]	@ zero_extendqisi2
	cmp	r7, #1
	bne	.L3830
	ldr	r6, .L3930+4
	bl	ftl_flush
	movs	r1, #5
	ldrh	r0, [r6, #314]
	cbz	r0, .L3831
	mov	r0, r7
.L3831:
	bl	zftl_gc_get_free_sblk
	movw	r3, #65535
	mov	r4, r0
	cmp	r0, r3
	beq	.L3833
	ldr	r3, .L3930+8
	ldr	r7, [r3]
	add	r7, r7, r0, lsl #2
	ldrb	r3, [r7, #2]	@ zero_extendqisi2
	tst	r3, #224
	beq	.L3834
	movw	r2, #2449
	ldr	r1, .L3930+12
	ldr	r0, .L3930+16
	bl	printf
.L3834:
	ldrb	r3, [r7, #2]	@ zero_extendqisi2
	and	r3, r3, #15
	orr	r3, r3, #176
	strb	r3, [r7, #2]
.L3855:
	movs	r1, #1
	mov	r0, r4
	bl	ftl_erase_sblk
	movs	r3, #5
	add	r1, r5, #96
	strb	r3, [r5, #84]
	mov	r0, r4
	bl	ftl_get_blk_list_in_sblk
	ldr	r3, .L3930+20
	uxtb	r0, r0
	movs	r7, #0
	ldr	r10, .L3930+60
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
	ldr	r5, .L3930+24
	ldrb	r2, [r5]	@ zero_extendqisi2
	muls	r2, r3, r2
	ldr	r3, .L3930+28
	ldr	r0, [r3]
	lsls	r2, r2, #2
	bl	ftl_memset
	ldrh	r3, [r10]
	movs	r1, #255
	ldrb	r2, [r5]	@ zero_extendqisi2
	muls	r2, r3, r2
	ldr	r3, .L3930+32
	ldr	r0, [r3]
	lsls	r2, r2, #2
	bl	ftl_memset
	ldrh	r3, [r10]
	movs	r1, #255
	ldrb	r2, [r5]	@ zero_extendqisi2
	muls	r2, r3, r2
	ldr	r3, .L3930+36
	ldr	r0, [r3]
	bl	ftl_memset
	ldr	r3, [r8]
	movw	r2, #65535
	strh	r2, [r3, #128]	@ movhi
	strh	r2, [r3, #130]	@ movhi
	str	r4, [r3, #132]
	bl	pm_flush
	bl	ftl_ext_info_flush
	ldr	r3, .L3930+40
	mov	r0, r7
	strh	r7, [r6, #52]	@ movhi
	ldr	r3, [r3]
	strh	r4, [r3, #126]	@ movhi
	mov	r3, #-1
	strh	r7, [r6, #310]	@ movhi
	strh	r7, [r6, #312]	@ movhi
	strh	r7, [r6, #316]	@ movhi
	str	r3, [r6, #320]
	bl	ftl_info_flush
	b	.L3856
.L3830:
	ldr	r3, [sp, #32]
	ldr	r10, .L3930
	cmp	r3, #1
	ite	ne
	movne	r7, #1
	moveq	r7, #4
	cmp	r6, #15
	ldr	r6, .L3930+4
	it	ls
	addls	r7, r7, #4
.L3837:
	subs	r7, r7, #1
	uxtb	r7, r7
	cmp	r7, #255
	beq	.L3856
	bl	gc_do_copy_back
	ldrb	r3, [r10]	@ zero_extendqisi2
	cbnz	r3, .L3838
	ldr	r3, .L3930+44
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #3
	bhi	.L3839
	bl	ftl_write_commit
.L3839:
	ldrh	r2, [r6, #22]
	ldrh	r3, [r6, #20]
	cmp	r2, r3
	bcc	.L3837
	movs	r3, #1
	strb	r3, [r4]
	ldr	r4, .L3930+48
	bl	ftl_write_commit
	bl	ftl_flush
	ldrh	r1, [r6]
	ldr	r2, [r4]
	ldrh	r2, [r2, r1, lsl #1]
	cbz	r2, .L3841
	movw	r2, #2524
	ldr	r1, .L3930+12
	ldr	r0, .L3930+16
	bl	printf
.L3841:
	ldrh	r0, [r6]
	ldr	r3, [r4]
	ldrh	r3, [r3, r0, lsl #1]
	cbnz	r3, .L3842
	bl	ftl_free_sblk
	b	.L3816
.L3842:
	movs	r2, #1
	movs	r1, #0
	bl	gc_add_sblk
	b	.L3816
.L3838:
	ldrh	r3, [r6, #316]
	cbz	r3, .L3843
	movs	r5, #0
	strh	r5, [r6, #316]	@ movhi
	bl	sblk_wait_write_queue_completed
	bl	gc_write_completed
	ldr	r0, [r6, #320]
	adds	r3, r0, #1
	beq	.L3844
	bl	ftl_mask_bad_block
.L3844:
	ldr	r3, [r8]
	str	r5, [r6, #320]
	strh	r5, [r6, #52]	@ movhi
	ldrh	r0, [r3, #80]
	bl	ftl_free_sblk
	ldr	r1, .L3930+40
	movw	r3, #65535
	ldr	r0, [r6, #8]
	ldr	r2, [r8]
	ldr	r1, [r1]
	strh	r3, [r2, #80]	@ movhi
	strh	r3, [r1, #126]	@ movhi
	strh	r3, [r2, #130]	@ movhi
	cbz	r0, .L3845
	bl	buf_free
.L3845:
	movs	r5, #0
	str	r5, [r6, #8]
	bl	flt_sys_flush
	movw	r2, #2562
	ldr	r1, .L3930+12
	ldr	r0, .L3930+16
	strb	r5, [r4]
	bl	printf
	b	.L3856
.L3843:
	ldrh	r3, [r5, #86]
	ldrh	r2, [r6, #22]
	cmp	r3, #1
	ldrh	r3, [r6, #20]
	bls	.L3846
	cmp	r2, r3
	bcc	.L3837
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
	b	.L3856
.L3846:
	cmp	r2, r3
	mov	r1, #5
	strb	r1, [r4]
	bcc	.L3847
	ldrh	r3, [r6, #52]
	adds	r2, r3, #1
	strh	r2, [r6, #52]	@ movhi
	add	r3, r6, r3, lsl #1
	ldrh	r2, [r6]
	strh	r2, [r3, #54]	@ movhi
	movw	r3, #65535
	strh	r3, [r6]	@ movhi
.L3847:
	bl	ftl_flush
	bl	sblk_wait_write_queue_completed
	bl	gc_write_completed
	ldr	r3, [r8]
	ldrh	r2, [r5, #80]
	strh	r2, [r3, #128]	@ movhi
	bl	pm_flush
	bl	ftl_ext_info_flush
	ldr	r2, .L3930+52
	movs	r3, #0
	strh	r3, [r6, #12]	@ movhi
	ldr	r3, .L3930+20
	ldrb	r2, [r2]	@ zero_extendqisi2
	ldrh	r3, [r3]
	cmp	r2, #2
	strh	r2, [r6, #16]	@ movhi
	strh	r3, [r6, #14]	@ movhi
	bne	.L3849
	lsls	r3, r3, #1
	strh	r3, [r6, #14]	@ movhi
	ldr	r3, .L3930+56
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L3849
	movs	r3, #1
	strh	r3, [r6, #16]	@ movhi
.L3849:
	movs	r3, #0
	strh	r3, [r6, #18]	@ movhi
	b	.L3856
.L3852:
	ldrh	r2, [r5, #12]
	ldrh	r3, [r5, #14]
	cmp	r2, r3
	bcc	.L3853
	movs	r3, #6
	ldr	r0, [r5, #8]
	strb	r3, [r4]
	bl	buf_free
	str	r10, [r5, #8]
	b	.L3856
.L3853:
	cmp	r6, #15
	bls	.L3758
	ldr	r3, [sp, #32]
	cmp	r3, #1
	bne	.L3856
	adds	r7, r7, #1
	uxtb	r7, r7
	cmp	r7, #4
	bls	.L3758
	b	.L3856
.L3757:
	movw	r6, #65535
	bl	gc_update_l2p_map_new
	bl	gc_free_src_blk
	bl	ftl_flush
	bl	pm_flush
	strh	r6, [r5, #80]	@ movhi
	bl	ftl_ext_info_flush
	ldr	r3, .L3930+40
	movs	r0, #0
	ldr	r3, [r3]
	strh	r6, [r3, #126]	@ movhi
	bl	ftl_info_flush
.L3923:
	movs	r3, #0
	b	.L3922
.L3833:
	movw	r2, #2455
	ldr	r1, .L3930+12
	ldr	r0, .L3930+16
	bl	printf
	b	.L3855
.L3931:
	.align	2
.L3930:
	.word	.LANCHOR76
	.word	.LANCHOR63
	.word	.LANCHOR7
	.word	.LANCHOR220
	.word	.LC0
	.word	.LANCHOR85
	.word	.LANCHOR78
	.word	.LANCHOR152
	.word	.LANCHOR153
	.word	.LANCHOR74
	.word	.LANCHOR102
	.word	.LANCHOR52
	.word	.LANCHOR9
	.word	.LANCHOR71
	.word	.LANCHOR72
	.word	.LANCHOR77
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
	ldr	r3, .L3952
	sub	sp, sp, #24
	mov	r4, r0
	mov	r5, r1
	mov	r7, r2
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L3933
	ldr	r3, [r8]
	str	r3, [sp]
	mov	r3, r2
	mov	r2, r1
	mov	r1, r0
	ldr	r0, .L3952+4
	bl	printf
.L3933:
	cbnz	r4, .L3934
	ldr	r3, .L3952+8
	mov	r4, #24576
	ldr	r3, [r3]
.L3935:
	adds	r2, r5, r7
	cmp	r3, r2
	bcc	.L3948
	ldr	fp, .L3952+24
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
.L3937:
	cbnz	r5, .L3944
	bl	ftl_write_commit
	ldr	r4, .L3952+12
	bl	ftl_flush
	mov	r0, r5
	ldr	r5, .L3952+16
	movs	r1, #1
	bl	zftl_do_gc
.L3945:
	ldrh	r3, [r5]
	ldrh	r2, [r4]
	add	r3, r3, r2
	cmp	r3, #7
	ble	.L3946
	movs	r0, #0
.L3932:
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3934:
	cmp	r4, #3
	bhi	.L3948
	lsls	r4, r4, #13
	mov	r3, #8192
	b	.L3935
.L3944:
	movs	r0, #0
	bl	buf_alloc
	mov	fp, r0
	cbnz	r0, .L3938
	bl	ftl_write_commit
	b	.L3937
.L3938:
	mov	r3, #0
	cmp	r6, r10
	strb	r3, [r0, #41]
	ldr	r3, [sp, #16]
	ldrb	r2, [r3]	@ zero_extendqisi2
	strb	r2, [r0, #40]
	bne	.L3940
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
.L3942:
	ldrb	ip, [fp, #41]	@ zero_extendqisi2
	mov	r1, r8
	ldrb	r2, [fp, #40]	@ zero_extendqisi2
	subs	r5, r5, #1
	ldr	r0, [fp, #4]
	lsls	r2, r2, #9
	add	r0, r0, ip, lsl #9
	bl	ftl_memcpy
	ldr	r3, .L3952+20
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
	b	.L3937
.L3940:
	ldr	r3, [sp, #12]
	cmp	r6, r3
	itttt	eq
	smulbbeq	r2, r6, r2
	addeq	r1, r4, r7
	subeq	r2, r1, r2
	strbeq	r2, [r0, #40]
	b	.L3942
.L3946:
	movs	r1, #1
	movs	r0, #0
	bl	zftl_do_gc
	b	.L3945
.L3948:
	mov	r0, #-1
	b	.L3932
.L3953:
	.align	2
.L3952:
	.word	.LANCHOR14
	.word	.LC240
	.word	.LANCHOR59
	.word	.LANCHOR99
	.word	.LANCHOR95
	.word	.LANCHOR102
	.word	.LANCHOR123
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
	cbnz	r0, .L3959
	mov	r3, r2
	mov	r2, r5
	bl	idb_write_data
.L3959:
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
	ldr	r2, .L4008
	adds	r3, r0, r1
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r1
	sub	sp, sp, #32
	ldr	r2, [r2]
	cmp	r2, r3
	bcc	.L3981
	ldr	r2, .L4008+4
	add	r7, r0, #24576
	ldr	r3, .L4008+8
	ldr	r0, [r2]
	ldr	r1, [r3]
	str	r3, [sp, #12]
	tst	r0, #4096
	str	r2, [sp, #16]
	add	r1, r1, r4
	str	r1, [r3]
	beq	.L3962
	movs	r3, #0
	mov	r2, r7
	str	r3, [sp]
	mov	r3, r4
	ldr	r0, .L4008+12
	bl	printf
.L3962:
	ldr	r8, .L4008+32
	ldr	r10, .L4008+36
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
	beq	.L3963
	subs	r6, r6, r1
	mov	r0, r5
	cmp	r6, r4
	it	cs
	movcs	r6, r4
	bl	lpa_hash_get_ppa
	str	r0, [sp, #24]
	adds	r0, r0, #1
	bne	.L3964
	movs	r2, #0
	add	r1, sp, #24
	mov	r0, r5
	bl	pm_log2phys
.L3964:
	ldr	r3, [sp, #24]
	adds	r3, r3, #1
	beq	.L3966
	movs	r0, #0
	bl	buf_alloc
	mov	r3, r0
	cbz	r0, .L3966
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
.L3966:
	uxth	r6, r6
	adds	r5, r5, #1
	subs	r4, r4, r6
.L3963:
	cbz	r4, .L3968
	bl	ftl_flush
.L3968:
	ldr	fp, .L4008+40
	mov	r3, #-1
	ldr	r6, .L4008+16
	str	r3, [sp, #28]
.L3969:
	ldrb	r3, [r10]	@ zero_extendqisi2
	cmp	r4, r3
	bcs	.L3974
	cmp	r4, #0
	beq	.L3976
	mov	r0, r5
	bl	lpa_hash_get_ppa
	str	r0, [sp, #24]
	adds	r0, r0, #1
	bne	.L3977
	movs	r2, #0
	add	r1, sp, #24
	mov	r0, r5
	bl	pm_log2phys
.L3977:
	ldr	r3, [sp, #24]
	adds	r3, r3, #1
	beq	.L3976
	movs	r0, #0
	bl	buf_alloc
	mov	r6, r0
	cbz	r0, .L3976
	movs	r3, #0
	str	r5, [r0, #20]
	strb	r3, [r0, #41]
	ldr	r3, [sp, #8]
	strb	r4, [r0, #40]
	str	r3, [r0, #16]
	ldrb	r3, [r10]	@ zero_extendqisi2
	cmp	r4, r3
	bcc	.L3979
	movw	r2, #1251
	ldr	r1, .L4008+20
	ldr	r0, .L4008+24
	bl	printf
.L3979:
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
.L3976:
	ldr	r3, [sp, #12]
	ldr	r1, [r3]
	cmp	r1, #8192
	bls	.L3982
	ldr	r3, [sp, #16]
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L3980
	movs	r3, #0
	mov	r2, r7
	str	r3, [sp]
	mov	r3, r4
	ldr	r0, .L4008+12
	bl	printf
.L3980:
	ldr	r3, [sp, #12]
	movs	r4, #0
	str	r4, [r3]
	bl	flt_sys_flush
	ldr	r3, .L4008+28
	movs	r2, #1
	str	r2, [r3]
.L3982:
	movs	r0, #0
	b	.L3960
.L3974:
	mov	r0, r5
	bl	lpa_hash_get_ppa
	str	r0, [sp, #24]
	adds	r0, r0, #1
	beq	.L3970
	movs	r0, #0
	bl	buf_alloc
	mov	r3, r0
	cbz	r0, .L3972
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
.L4007:
	ldr	r2, [r8]
	ldr	r3, [r2, #76]
	adds	r3, r3, #1
	str	r3, [r2, #76]
.L3972:
	ldrb	r3, [r10]	@ zero_extendqisi2
	adds	r5, r5, #1
	subs	r4, r4, r3
	b	.L3969
.L3970:
	movs	r2, #0
	add	r1, sp, #24
	mov	r0, r5
	bl	pm_log2phys
	ldr	r3, [sp, #24]
	adds	r3, r3, #1
	beq	.L3972
	add	r1, sp, #28
	movs	r2, #1
	mov	r0, r5
	bl	pm_log2phys
	ldrh	r2, [fp]
	movs	r3, #1
	ldrb	r1, [r6]	@ zero_extendqisi2
	rsb	r0, r2, #21
	lsls	r3, r3, r0
	ldr	r0, [sp, #24]
	subs	r3, r3, #1
	lsrs	r0, r0, r2
	ands	r0, r0, r3
	bl	__aeabi_uidiv
	uxth	r0, r0
	bl	ftl_vpn_decrement
	b	.L4007
.L3981:
	mov	r0, #-1
.L3960:
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L4009:
	.align	2
.L4008:
	.word	.LANCHOR59
	.word	.LANCHOR14
	.word	.LANCHOR221
	.word	.LC241
	.word	.LANCHOR67
	.word	.LANCHOR222
	.word	.LC0
	.word	.LANCHOR114
	.word	.LANCHOR102
	.word	.LANCHOR123
	.word	.LANCHOR66
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
	.global	g_pm_spare
	.global	pm_first_write
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
	.global	g_maxRetryCount
	.global	g_maxRegNum
	.global	g_retryMode
	.global	g_flash_toggle_mode_en
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
	.set	.LANCHOR42,. + 0
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
	.set	.LANCHOR66,. + 0
	.type	_c_ftl_block_addr_log2, %object
	.size	_c_ftl_block_addr_log2, 2
_c_ftl_block_addr_log2:
	.space	2
	.section	.bss._c_ftl_block_align_addr,"aw",%nobits
	.align	1
	.set	.LANCHOR103,. + 0
	.type	_c_ftl_block_align_addr, %object
	.size	_c_ftl_block_align_addr, 2
_c_ftl_block_align_addr:
	.space	2
	.section	.bss._c_ftl_byte_pre_page,"aw",%nobits
	.align	1
	.set	.LANCHOR203,. + 0
	.type	_c_ftl_byte_pre_page, %object
	.size	_c_ftl_byte_pre_page, 2
_c_ftl_byte_pre_page:
	.space	2
	.section	.bss._c_ftl_nand_blks_per_die,"aw",%nobits
	.align	1
	.type	_c_ftl_nand_blks_per_die, %object
	.size	_c_ftl_nand_blks_per_die, 2
_c_ftl_nand_blks_per_die:
	.space	2
	.section	.bss._c_ftl_nand_die_num,"aw",%nobits
	.set	.LANCHOR104,. + 0
	.type	_c_ftl_nand_die_num, %object
	.size	_c_ftl_nand_die_num, 1
_c_ftl_nand_die_num:
	.space	1
	.section	.bss._c_ftl_nand_planes_num,"aw",%nobits
	.set	.LANCHOR78,. + 0
	.type	_c_ftl_nand_planes_num, %object
	.size	_c_ftl_nand_planes_num, 1
_c_ftl_nand_planes_num:
	.space	1
	.section	.bss._c_ftl_nand_type,"aw",%nobits
	.set	.LANCHOR71,. + 0
	.type	_c_ftl_nand_type, %object
	.size	_c_ftl_nand_type, 1
_c_ftl_nand_type:
	.space	1
	.section	.bss._c_ftl_page_pre_blk,"aw",%nobits
	.align	1
	.set	.LANCHOR77,. + 0
	.type	_c_ftl_page_pre_blk, %object
	.size	_c_ftl_page_pre_blk, 2
_c_ftl_page_pre_blk:
	.space	2
	.section	.bss._c_ftl_page_pre_slc_blk,"aw",%nobits
	.align	1
	.set	.LANCHOR85,. + 0
	.type	_c_ftl_page_pre_slc_blk, %object
	.size	_c_ftl_page_pre_slc_blk, 2
_c_ftl_page_pre_slc_blk:
	.space	2
	.section	.bss._c_ftl_planes_per_die,"aw",%nobits
	.set	.LANCHOR67,. + 0
	.type	_c_ftl_planes_per_die, %object
	.size	_c_ftl_planes_per_die, 1
_c_ftl_planes_per_die:
	.space	1
	.section	.bss._c_ftl_pm_page_num,"aw",%nobits
	.align	1
	.set	.LANCHOR187,. + 0
	.type	_c_ftl_pm_page_num, %object
	.size	_c_ftl_pm_page_num, 2
_c_ftl_pm_page_num:
	.space	2
	.section	.bss._c_ftl_sec_per_page,"aw",%nobits
	.set	.LANCHOR123,. + 0
	.type	_c_ftl_sec_per_page, %object
	.size	_c_ftl_sec_per_page, 1
_c_ftl_sec_per_page:
	.space	1
	.section	.bss._c_max_pm_sblk,"aw",%nobits
	.align	1
	.set	.LANCHOR146,. + 0
	.type	_c_max_pm_sblk, %object
	.size	_c_max_pm_sblk, 2
_c_max_pm_sblk:
	.space	2
	.section	.bss._c_mix_max_slc_ec_count,"aw",%nobits
	.align	1
	.set	.LANCHOR118,. + 0
	.type	_c_mix_max_slc_ec_count, %object
	.size	_c_mix_max_slc_ec_count, 2
_c_mix_max_slc_ec_count:
	.space	2
	.section	.bss._c_mix_max_xlc_ec_count,"aw",%nobits
	.align	1
	.set	.LANCHOR116,. + 0
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
	.set	.LANCHOR145,. + 0
	.type	_c_swl_slc_gc_th, %object
	.size	_c_swl_slc_gc_th, 2
_c_swl_slc_gc_th:
	.space	2
	.section	.bss._c_swl_xlc_gc_th,"aw",%nobits
	.align	1
	.set	.LANCHOR144,. + 0
	.type	_c_swl_xlc_gc_th, %object
	.size	_c_swl_xlc_gc_th, 2
_c_swl_xlc_gc_th:
	.space	2
	.section	.bss._c_totle_data_density,"aw",%nobits
	.align	2
	.set	.LANCHOR208,. + 0
	.type	_c_totle_data_density, %object
	.size	_c_totle_data_density, 4
_c_totle_data_density:
	.space	4
	.section	.bss._c_totle_log_page,"aw",%nobits
	.align	2
	.set	.LANCHOR120,. + 0
	.type	_c_totle_log_page, %object
	.size	_c_totle_log_page, 4
_c_totle_log_page:
	.space	4
	.section	.bss._c_totle_phy_density,"aw",%nobits
	.align	2
	.set	.LANCHOR207,. + 0
	.type	_c_totle_phy_density, %object
	.size	_c_totle_phy_density, 4
_c_totle_phy_density:
	.space	4
	.section	.bss._c_user_data_density,"aw",%nobits
	.align	2
	.set	.LANCHOR59,. + 0
	.type	_c_user_data_density, %object
	.size	_c_user_data_density, 4
_c_user_data_density:
	.space	4
	.section	.bss._gc_after_discard_en,"aw",%nobits
	.align	2
	.set	.LANCHOR114,. + 0
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
	.set	.LANCHOR117,. + 0
	.type	_max_slc_super_block, %object
	.size	_max_slc_super_block, 2
_max_slc_super_block:
	.space	2
	.section	.bss._max_xlc_super_block,"aw",%nobits
	.align	1
	.set	.LANCHOR93,. + 0
	.type	_max_xlc_super_block, %object
	.size	_max_xlc_super_block, 2
_max_xlc_super_block:
	.space	2
	.section	.bss._min_slc_super_block,"aw",%nobits
	.align	1
	.set	.LANCHOR89,. + 0
	.type	_min_slc_super_block, %object
	.size	_min_slc_super_block, 2
_min_slc_super_block:
	.space	2
	.section	.bss.discard_sector_count,"aw",%nobits
	.align	2
	.set	.LANCHOR221,. + 0
	.type	discard_sector_count, %object
	.size	discard_sector_count, 4
discard_sector_count:
	.space	4
	.section	.bss.fill_spare_size,"aw",%nobits
	.align	1
	.set	.LANCHOR48,. + 0
	.type	fill_spare_size, %object
	.size	fill_spare_size, 2
fill_spare_size:
	.space	2
	.section	.bss.flash_ddr_tuning_sdr_read_count,"aw",%nobits
	.align	2
	.set	.LANCHOR160,. + 0
	.type	flash_ddr_tuning_sdr_read_count, %object
	.size	flash_ddr_tuning_sdr_read_count, 4
flash_ddr_tuning_sdr_read_count:
	.space	4
	.section	.bss.flash_read_retry,"aw",%nobits
	.align	2
	.set	.LANCHOR162,. + 0
	.type	flash_read_retry, %object
	.size	flash_read_retry, 4
flash_read_retry:
	.space	4
	.section	.bss.free_buf_count,"aw",%nobits
	.set	.LANCHOR52,. + 0
	.type	free_buf_count, %object
	.size	free_buf_count, 1
free_buf_count:
	.space	1
	.section	.bss.free_mix_sblk,"aw",%nobits
	.align	1
	.set	.LANCHOR99,. + 0
	.type	free_mix_sblk, %object
	.size	free_mix_sblk, 2
free_mix_sblk:
	.space	2
	.section	.bss.free_slc_sblk,"aw",%nobits
	.align	1
	.set	.LANCHOR95,. + 0
	.type	free_slc_sblk, %object
	.size	free_slc_sblk, 2
free_slc_sblk:
	.space	2
	.section	.bss.free_xlc_sblk,"aw",%nobits
	.align	1
	.set	.LANCHOR97,. + 0
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
	.set	.LANCHOR183,. + 0
	.type	ftl_ext_info_first_write, %object
	.size	ftl_ext_info_first_write, 1
ftl_ext_info_first_write:
	.space	1
	.section	.bss.ftl_flush_jiffies,"aw",%nobits
	.align	2
	.set	.LANCHOR217,. + 0
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
	.set	.LANCHOR178,. + 0
	.type	ftl_info_spare, %object
	.size	ftl_info_spare, 256
ftl_info_spare:
	.space	256
	.section	.bss.ftl_low_format_cur_blk,"aw",%nobits
	.align	1
	.set	.LANCHOR60,. + 0
	.type	ftl_low_format_cur_blk, %object
	.size	ftl_low_format_cur_blk, 2
ftl_low_format_cur_blk:
	.space	2
	.section	.bss.ftl_power_lost_flag,"aw",%nobits
	.set	.LANCHOR182,. + 0
	.type	ftl_power_lost_flag, %object
	.size	ftl_power_lost_flag, 1
ftl_power_lost_flag:
	.space	1
	.section	.bss.ftl_sblk_lpa_tbl,"aw",%nobits
	.align	2
	.set	.LANCHOR109,. + 0
	.type	ftl_sblk_lpa_tbl, %object
	.size	ftl_sblk_lpa_tbl, 4
ftl_sblk_lpa_tbl:
	.space	4
	.section	.bss.ftl_sblk_update_list,"aw",%nobits
	.align	1
	.set	.LANCHOR65,. + 0
	.type	ftl_sblk_update_list, %object
	.size	ftl_sblk_update_list, 16
ftl_sblk_update_list:
	.space	16
	.section	.bss.ftl_sblk_update_list_offset,"aw",%nobits
	.align	1
	.set	.LANCHOR115,. + 0
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
	.set	.LANCHOR64,. + 0
	.type	ftl_sblk_vpn_update_id, %object
	.size	ftl_sblk_vpn_update_id, 2
ftl_sblk_vpn_update_id:
	.space	2
	.section	.bss.ftl_sys_info_first_write,"aw",%nobits
	.set	.LANCHOR181,. + 0
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
	.set	.LANCHOR176,. + 0
	.type	ftl_tmp_spare, %object
	.size	ftl_tmp_spare, 256
ftl_tmp_spare:
	.space	256
	.section	.bss.ftl_vpn_update_count,"aw",%nobits
	.align	1
	.set	.LANCHOR113,. + 0
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
	.set	.LANCHOR50,. + 0
	.type	g_buf, %object
	.size	g_buf, 1536
g_buf:
	.space	1536
	.section	.bss.g_die_addr,"aw",%nobits
	.align	2
	.set	.LANCHOR141,. + 0
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
	.set	.LANCHOR72,. + 0
	.type	g_flash_3d_mlc_flag, %object
	.size	g_flash_3d_mlc_flag, 1
g_flash_3d_mlc_flag:
	.space	1
	.section	.bss.g_flash_3d_tlc_flag,"aw",%nobits
	.set	.LANCHOR75,. + 0
	.type	g_flash_3d_tlc_flag, %object
	.size	g_flash_3d_tlc_flag, 1
g_flash_3d_tlc_flag:
	.space	1
	.section	.bss.g_flash_blk_info,"aw",%nobits
	.align	1
	.set	.LANCHOR195,. + 0
	.type	g_flash_blk_info, %object
	.size	g_flash_blk_info, 4
g_flash_blk_info:
	.space	4
	.section	.bss.g_flash_cur_mode,"aw",%nobits
	.set	.LANCHOR32,. + 0
	.type	g_flash_cur_mode, %object
	.size	g_flash_cur_mode, 4
g_flash_cur_mode:
	.space	4
	.section	.bss.g_flash_interface_mode,"aw",%nobits
	.set	.LANCHOR43,. + 0
	.type	g_flash_interface_mode, %object
	.size	g_flash_interface_mode, 1
g_flash_interface_mode:
	.space	1
	.section	.bss.g_flash_multi_page_prog_en,"aw",%nobits
	.set	.LANCHOR39,. + 0
	.type	g_flash_multi_page_prog_en, %object
	.size	g_flash_multi_page_prog_en, 1
g_flash_multi_page_prog_en:
	.space	1
	.section	.bss.g_flash_multi_page_read_en,"aw",%nobits
	.set	.LANCHOR168,. + 0
	.type	g_flash_multi_page_read_en, %object
	.size	g_flash_multi_page_read_en, 1
g_flash_multi_page_read_en:
	.space	1
	.section	.bss.g_flash_page_buffer,"aw",%nobits
	.align	2
	.set	.LANCHOR164,. + 0
	.type	g_flash_page_buffer, %object
	.size	g_flash_page_buffer, 4
g_flash_page_buffer:
	.space	4
	.section	.bss.g_flash_reversd_blks,"aw",%nobits
	.set	.LANCHOR200,. + 0
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
	.set	.LANCHOR163,. + 0
	.type	g_flash_spare_buffer, %object
	.size	g_flash_spare_buffer, 4
g_flash_spare_buffer:
	.space	4
	.section	.bss.g_flash_sys_spare_buffer,"aw",%nobits
	.align	2
	.set	.LANCHOR194,. + 0
	.type	g_flash_sys_spare_buffer, %object
	.size	g_flash_sys_spare_buffer, 4
g_flash_sys_spare_buffer:
	.space	4
	.section	.bss.g_flash_tmp_page_buffer,"aw",%nobits
	.align	2
	.set	.LANCHOR156,. + 0
	.type	g_flash_tmp_page_buffer, %object
	.size	g_flash_tmp_page_buffer, 4
g_flash_tmp_page_buffer:
	.space	4
	.section	.bss.g_flash_tmp_spare_buffer,"aw",%nobits
	.align	2
	.set	.LANCHOR158,. + 0
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
	.set	.LANCHOR179,. + 0
	.type	g_ftl_info_blk, %object
	.size	g_ftl_info_blk, 4
g_ftl_info_blk:
	.space	4
	.section	.bss.g_gc_info,"aw",%nobits
	.align	2
	.set	.LANCHOR63,. + 0
	.type	g_gc_info, %object
	.size	g_gc_info, 340
g_gc_info:
	.space	340
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
	.set	.LANCHOR159,. + 0
	.type	g_maxRetryCount, %object
	.size	g_maxRetryCount, 1
g_maxRetryCount:
	.space	1
	.section	.bss.g_msb_page_tbl,"aw",%nobits
	.align	2
	.set	.LANCHOR138,. + 0
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
	.set	.LANCHOR44,. + 0
	.type	g_nandc_ecc_bits, %object
	.size	g_nandc_ecc_bits, 1
g_nandc_ecc_bits:
	.space	1
	.section	.bss.g_nandc_tran_timeout,"aw",%nobits
	.set	.LANCHOR157,. + 0
	.type	g_nandc_tran_timeout, %object
	.size	g_nandc_tran_timeout, 1
g_nandc_tran_timeout:
	.space	1
	.section	.bss.g_nandc_v6_master_info,"aw",%nobits
	.align	2
	.set	.LANCHOR47,. + 0
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
	.set	.LANCHOR73,. + 0
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
	.set	.LANCHOR140,. + 0
	.type	g_slc_page_num, %object
	.size	g_slc_page_num, 2
g_slc_page_num:
	.space	2
	.section	.bss.g_totle_phy_block,"aw",%nobits
	.align	1
	.set	.LANCHOR142,. + 0
	.type	g_totle_phy_block, %object
	.size	g_totle_phy_block, 2
g_totle_phy_block:
	.space	2
	.section	.bss.gc_des_ppa_tbl,"aw",%nobits
	.align	2
	.set	.LANCHOR154,. + 0
	.type	gc_des_ppa_tbl, %object
	.size	gc_des_ppa_tbl, 4
gc_des_ppa_tbl:
	.space	4
	.section	.bss.gc_free_slc_sblk_th,"aw",%nobits
	.align	1
	.set	.LANCHOR79,. + 0
	.type	gc_free_slc_sblk_th, %object
	.size	gc_free_slc_sblk_th, 2
gc_free_slc_sblk_th:
	.space	2
	.section	.bss.gc_lpa_tbl,"aw",%nobits
	.align	2
	.set	.LANCHOR152,. + 0
	.type	gc_lpa_tbl, %object
	.size	gc_lpa_tbl, 4
gc_lpa_tbl:
	.space	4
	.section	.bss.gc_mode,"aw",%nobits
	.set	.LANCHOR76,. + 0
	.type	gc_mode, %object
	.size	gc_mode, 1
gc_mode:
	.space	1
	.section	.bss.gc_page_buf_id,"aw",%nobits
	.align	2
	.set	.LANCHOR74,. + 0
	.type	gc_page_buf_id, %object
	.size	gc_page_buf_id, 4
gc_page_buf_id:
	.space	4
	.section	.bss.gc_pre_ppa_tbl,"aw",%nobits
	.align	2
	.set	.LANCHOR153,. + 0
	.type	gc_pre_ppa_tbl, %object
	.size	gc_pre_ppa_tbl, 4
gc_pre_ppa_tbl:
	.space	4
	.section	.bss.gc_search_count,"aw",%nobits
	.align	2
	.set	.LANCHOR151,. + 0
	.type	gc_search_count, %object
	.size	gc_search_count, 4
gc_search_count:
	.space	4
	.section	.bss.gc_slc_cache_index,"aw",%nobits
	.align	1
	.set	.LANCHOR82,. + 0
	.type	gc_slc_cache_index, %object
	.size	gc_slc_cache_index, 2
gc_slc_cache_index:
	.space	2
	.section	.bss.gc_slc_data_index,"aw",%nobits
	.align	1
	.set	.LANCHOR86,. + 0
	.type	gc_slc_data_index, %object
	.size	gc_slc_data_index, 2
gc_slc_data_index:
	.space	2
	.section	.bss.gc_slc_mode_tlc_vpn_th,"aw",%nobits
	.align	1
	.set	.LANCHOR84,. + 0
	.type	gc_slc_mode_tlc_vpn_th, %object
	.size	gc_slc_mode_tlc_vpn_th, 2
gc_slc_mode_tlc_vpn_th:
	.space	2
	.section	.bss.gc_slc_mode_vpn_th,"aw",%nobits
	.align	1
	.set	.LANCHOR62,. + 0
	.type	gc_slc_mode_vpn_th, %object
	.size	gc_slc_mode_vpn_th, 2
gc_slc_mode_vpn_th:
	.space	2
	.section	.bss.gc_state,"aw",%nobits
	.set	.LANCHOR150,. + 0
	.type	gc_state, %object
	.size	gc_state, 1
gc_state:
	.space	1
	.section	.bss.gc_tlc_mode_slc_vpn_th,"aw",%nobits
	.align	1
	.set	.LANCHOR94,. + 0
	.type	gc_tlc_mode_slc_vpn_th, %object
	.size	gc_tlc_mode_slc_vpn_th, 2
gc_tlc_mode_slc_vpn_th:
	.space	2
	.section	.bss.gc_tlc_mode_tlc_vpn_th,"aw",%nobits
	.align	1
	.set	.LANCHOR91,. + 0
	.type	gc_tlc_mode_tlc_vpn_th, %object
	.size	gc_tlc_mode_tlc_vpn_th, 2
gc_tlc_mode_tlc_vpn_th:
	.space	2
	.section	.bss.gc_valid_page_ppa,"aw",%nobits
	.align	2
	.set	.LANCHOR68,. + 0
	.type	gc_valid_page_ppa, %object
	.size	gc_valid_page_ppa, 4
gc_valid_page_ppa:
	.space	4
	.section	.bss.gc_xlc_data_index,"aw",%nobits
	.align	1
	.set	.LANCHOR83,. + 0
	.type	gc_xlc_data_index, %object
	.size	gc_xlc_data_index, 2
gc_xlc_data_index:
	.space	2
	.section	.bss.gc_xlc_search_index,"aw",%nobits
	.align	1
	.set	.LANCHOR87,. + 0
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
	.set	.LANCHOR81,. + 0
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
	.set	.LANCHOR80,. + 0
	.type	gp_data_xlc_data_head, %object
	.size	gp_data_xlc_data_head, 4
gp_data_xlc_data_head:
	.space	4
	.section	.bss.gp_flash_check_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR137,. + 0
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
	.set	.LANCHOR100,. + 0
	.type	gp_free_mix_head, %object
	.size	gp_free_mix_head, 4
gp_free_mix_head:
	.space	4
	.section	.bss.gp_free_slc_head,"aw",%nobits
	.align	2
	.set	.LANCHOR96,. + 0
	.type	gp_free_slc_head, %object
	.size	gp_free_slc_head, 4
gp_free_slc_head:
	.space	4
	.section	.bss.gp_free_xlc_head,"aw",%nobits
	.align	2
	.set	.LANCHOR98,. + 0
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
	.set	.LANCHOR102,. + 0
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
	.set	.LANCHOR135,. + 0
	.type	idb_buf, %object
	.size	idb_buf, 4
idb_buf:
	.space	4
	.section	.bss.idb_need_write_back,"aw",%nobits
	.align	2
	.set	.LANCHOR136,. + 0
	.type	idb_need_write_back, %object
	.size	idb_need_write_back, 4
idb_need_write_back:
	.space	4
	.section	.bss.lpa_hash,"aw",%nobits
	.align	1
	.set	.LANCHOR108,. + 0
	.type	lpa_hash, %object
	.size	lpa_hash, 512
lpa_hash:
	.space	512
	.section	.bss.lpa_hash_index,"aw",%nobits
	.align	2
	.set	.LANCHOR110,. + 0
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
	.set	.LANCHOR45,. + 0
	.type	nandc_hw_seed, %object
	.size	nandc_hw_seed, 1
nandc_hw_seed:
	.space	1
	.section	.bss.nandc_randomizer_en,"aw",%nobits
	.set	.LANCHOR46,. + 0
	.type	nandc_randomizer_en, %object
	.size	nandc_randomizer_en, 1
nandc_randomizer_en:
	.space	1
	.section	.bss.p_free_buf_head,"aw",%nobits
	.set	.LANCHOR51,. + 0
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
	.section	.bss.pm_gc_enable,"aw",%nobits
	.align	2
	.set	.LANCHOR130,. + 0
	.type	pm_gc_enable, %object
	.size	pm_gc_enable, 4
pm_gc_enable:
	.space	4
	.section	.bss.pm_last_load_ram_id,"aw",%nobits
	.set	.LANCHOR205,. + 0
	.type	pm_last_load_ram_id, %object
	.size	pm_last_load_ram_id, 1
pm_last_load_ram_id:
	.space	1
	.section	.bss.pm_last_update_ram_id,"aw",%nobits
	.set	.LANCHOR133,. + 0
	.type	pm_last_update_ram_id, %object
	.size	pm_last_update_ram_id, 1
pm_last_update_ram_id:
	.space	1
	.section	.bss.pm_ram_info,"aw",%nobits
	.align	2
	.set	.LANCHOR132,. + 0
	.type	pm_ram_info, %object
	.size	pm_ram_info, 256
pm_ram_info:
	.space	256
	.section	.bss.read_ahead_lpa,"aw",%nobits
	.align	2
	.set	.LANCHOR206,. + 0
	.type	read_ahead_lpa, %object
	.size	read_ahead_lpa, 4
read_ahead_lpa:
	.space	4
	.section	.bss.read_buf_count,"aw",%nobits
	.set	.LANCHOR127,. + 0
	.type	read_buf_count, %object
	.size	read_buf_count, 1
read_buf_count:
	.space	1
	.section	.bss.read_buf_head,"aw",%nobits
	.set	.LANCHOR126,. + 0
	.type	read_buf_head, %object
	.size	read_buf_head, 1
read_buf_head:
	.space	1
	.section	.bss.sblk_gc_write_completed_queue_head,"aw",%nobits
	.set	.LANCHOR69,. + 0
	.type	sblk_gc_write_completed_queue_head, %object
	.size	sblk_gc_write_completed_queue_head, 1
sblk_gc_write_completed_queue_head:
	.space	1
	.section	.bss.sblk_queue_head,"aw",%nobits
	.set	.LANCHOR54,. + 0
	.type	sblk_queue_head, %object
	.size	sblk_queue_head, 1
sblk_queue_head:
	.space	1
	.section	.bss.sblk_read_completed_queue_head,"aw",%nobits
	.set	.LANCHOR129,. + 0
	.type	sblk_read_completed_queue_head, %object
	.size	sblk_read_completed_queue_head, 1
sblk_read_completed_queue_head:
	.space	1
	.section	.bss.sblk_write_completed_queue_head,"aw",%nobits
	.set	.LANCHOR124,. + 0
	.type	sblk_write_completed_queue_head, %object
	.size	sblk_write_completed_queue_head, 1
sblk_write_completed_queue_head:
	.space	1
	.section	.bss.slc_cache_sblk,"aw",%nobits
	.align	1
	.set	.LANCHOR88,. + 0
	.type	slc_cache_sblk, %object
	.size	slc_cache_sblk, 2
slc_cache_sblk:
	.space	2
	.section	.bss.slc_data_sblk,"aw",%nobits
	.align	1
	.set	.LANCHOR90,. + 0
	.type	slc_data_sblk, %object
	.size	slc_data_sblk, 2
slc_data_sblk:
	.space	2
	.section	.bss.write_buf_count,"aw",%nobits
	.set	.LANCHOR58,. + 0
	.type	write_buf_count, %object
	.size	write_buf_count, 1
write_buf_count:
	.space	1
	.section	.bss.write_buf_head,"aw",%nobits
	.set	.LANCHOR57,. + 0
	.type	write_buf_head, %object
	.size	write_buf_head, 1
write_buf_head:
	.space	1
	.section	.bss.write_commit_count,"aw",%nobits
	.set	.LANCHOR121,. + 0
	.type	write_commit_count, %object
	.size	write_commit_count, 1
write_commit_count:
	.space	1
	.section	.bss.write_commit_head,"aw",%nobits
	.set	.LANCHOR174,. + 0
	.type	write_commit_head, %object
	.size	write_commit_head, 1
write_commit_head:
	.space	1
	.section	.bss.xlc_data_sblk,"aw",%nobits
	.align	1
	.set	.LANCHOR92,. + 0
	.type	xlc_data_sblk, %object
	.size	xlc_data_sblk, 2
xlc_data_sblk:
	.space	2
	.section	.bss.zftl_print_list_count,"aw",%nobits
	.align	1
	.set	.LANCHOR101,. + 0
	.type	zftl_print_list_count, %object
	.size	zftl_print_list_count, 2
zftl_print_list_count:
	.space	2
	.section	.data.g_nand_para_info,"aw",%progbits
	.align	1
	.set	.LANCHOR31,. + 0
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
	.set	.LANCHOR155,. + 0
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
	.set	.LANCHOR199,. + 0
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
	.set	.LANCHOR37,. + 0
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
	.set	.LANCHOR36,. + 0
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
	.section	.data.tlc_prog_order,"aw",%progbits
	.align	1
	.set	.LANCHOR219,. + 0
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
	.set	.LANCHOR198,. + 0
	.type	zftl_nand_flash_para_tbl, %object
	.size	zftl_nand_flash_para_tbl, 1216
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
	.byte	2
	.byte	-65
	.byte	-66
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
	.byte	4
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
	.byte	4
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
	.section	.rodata.__func__.10115,"a",%progbits
	.set	.LANCHOR139,. + 0
	.type	__func__.10115, %object
	.size	__func__.10115, 20
__func__.10115:
	.ascii	"flash_die_info_init\000"
	.section	.rodata.__func__.10125,"a",%progbits
	.set	.LANCHOR15,. + 0
	.type	__func__.10125, %object
	.size	__func__.10125, 22
__func__.10125:
	.ascii	"nand_flash_print_info\000"
	.section	.rodata.__func__.10170,"a",%progbits
	.set	.LANCHOR197,. + 0
	.type	__func__.10170, %object
	.size	__func__.10170, 16
__func__.10170:
	.ascii	"nand_flash_init\000"
	.section	.rodata.__func__.10193,"a",%progbits
	.set	.LANCHOR149,. + 0
	.type	__func__.10193, %object
	.size	__func__.10193, 11
__func__.10193:
	.ascii	"nandc_init\000"
	.section	.rodata.__func__.10362,"a",%progbits
	.set	.LANCHOR53,. + 0
	.type	__func__.10362, %object
	.size	__func__.10362, 13
__func__.10362:
	.ascii	"buf_add_tail\000"
	.section	.rodata.__func__.10375,"a",%progbits
	.set	.LANCHOR55,. + 0
	.type	__func__.10375, %object
	.size	__func__.10375, 10
__func__.10375:
	.ascii	"buf_alloc\000"
	.section	.rodata.__func__.10389,"a",%progbits
	.set	.LANCHOR56,. + 0
	.type	__func__.10389, %object
	.size	__func__.10389, 16
__func__.10389:
	.ascii	"buf_remove_free\000"
	.section	.rodata.__func__.10402,"a",%progbits
	.set	.LANCHOR196,. + 0
	.type	__func__.10402, %object
	.size	__func__.10402, 20
__func__.10402:
	.ascii	"flash_info_blk_init\000"
	.section	.rodata.__func__.10413,"a",%progbits
	.set	.LANCHOR148,. + 0
	.type	__func__.10413, %object
	.size	__func__.10413, 21
__func__.10413:
	.ascii	"flash_info_data_init\000"
	.section	.rodata.__func__.10435,"a",%progbits
	.set	.LANCHOR193,. + 0
	.type	__func__.10435, %object
	.size	__func__.10435, 17
__func__.10435:
	.ascii	"flash_info_flush\000"
	.section	.rodata.__func__.10511,"a",%progbits
	.set	.LANCHOR143,. + 0
	.type	__func__.10511, %object
	.size	__func__.10511, 17
__func__.10511:
	.ascii	"lpa_rebuild_hash\000"
	.section	.rodata.__func__.10558,"a",%progbits
	.set	.LANCHOR216,. + 0
	.type	__func__.10558, %object
	.size	__func__.10558, 17
__func__.10558:
	.ascii	"ftl_write_commit\000"
	.section	.rodata.__func__.10576,"a",%progbits
	.set	.LANCHOR122,. + 0
	.type	__func__.10576, %object
	.size	__func__.10576, 14
__func__.10576:
	.ascii	"ftl_write_buf\000"
	.section	.rodata.__func__.10621,"a",%progbits
	.set	.LANCHOR125,. + 0
	.type	__func__.10621, %object
	.size	__func__.10621, 18
__func__.10621:
	.ascii	"zftl_add_read_buf\000"
	.section	.rodata.__func__.10654,"a",%progbits
	.set	.LANCHOR213,. + 0
	.type	__func__.10654, %object
	.size	__func__.10654, 10
__func__.10654:
	.ascii	"zftl_read\000"
	.section	.rodata.__func__.10685,"a",%progbits
	.set	.LANCHOR222,. + 0
	.type	__func__.10685, %object
	.size	__func__.10685, 13
__func__.10685:
	.ascii	"_ftl_discard\000"
	.section	.rodata.__func__.10832,"a",%progbits
	.set	.LANCHOR61,. + 0
	.type	__func__.10832, %object
	.size	__func__.10832, 12
__func__.10832:
	.ascii	"gc_add_sblk\000"
	.section	.rodata.__func__.10879,"a",%progbits
	.set	.LANCHOR214,. + 0
	.type	__func__.10879, %object
	.size	__func__.10879, 21
__func__.10879:
	.ascii	"gc_check_data_one_wl\000"
	.section	.rodata.__func__.10913,"a",%progbits
	.set	.LANCHOR209,. + 0
	.type	__func__.10913, %object
	.size	__func__.10913, 22
__func__.10913:
	.ascii	"gc_update_l2p_map_new\000"
	.section	.rodata.__func__.10926,"a",%progbits
	.set	.LANCHOR70,. + 0
	.type	__func__.10926, %object
	.size	__func__.10926, 19
__func__.10926:
	.ascii	"gc_write_completed\000"
	.section	.rodata.__func__.10955,"a",%progbits
	.set	.LANCHOR218,. + 0
	.type	__func__.10955, %object
	.size	__func__.10955, 16
__func__.10955:
	.ascii	"gc_do_copy_back\000"
	.section	.rodata.__func__.10977,"a",%progbits
	.set	.LANCHOR119,. + 0
	.type	__func__.10977, %object
	.size	__func__.10977, 16
__func__.10977:
	.ascii	"gc_free_src_blk\000"
	.section	.rodata.__func__.11021,"a",%progbits
	.set	.LANCHOR210,. + 0
	.type	__func__.11021, %object
	.size	__func__.11021, 16
__func__.11021:
	.ascii	"gc_scan_src_blk\000"
	.section	.rodata.__func__.11079,"a",%progbits
	.set	.LANCHOR211,. + 0
	.type	__func__.11079, %object
	.size	__func__.11079, 20
__func__.11079:
	.ascii	"gc_scan_static_data\000"
	.section	.rodata.__func__.11146,"a",%progbits
	.set	.LANCHOR220,. + 0
	.type	__func__.11146, %object
	.size	__func__.11146, 11
__func__.11146:
	.ascii	"zftl_do_gc\000"
	.section	.rodata.__func__.11239,"a",%progbits
	.set	.LANCHOR5,. + 0
	.type	__func__.11239, %object
	.size	__func__.11239, 18
__func__.11239:
	.ascii	"_list_remove_node\000"
	.section	.rodata.__func__.11264,"a",%progbits
	.set	.LANCHOR11,. + 0
	.type	__func__.11264, %object
	.size	__func__.11264, 23
__func__.11264:
	.ascii	"_list_update_data_list\000"
	.section	.rodata.__func__.11372,"a",%progbits
	.set	.LANCHOR180,. + 0
	.type	__func__.11372, %object
	.size	__func__.11372, 15
__func__.11372:
	.ascii	"ftl_info_flush\000"
	.section	.rodata.__func__.11404,"a",%progbits
	.set	.LANCHOR128,. + 0
	.type	__func__.11404, %object
	.size	__func__.11404, 15
__func__.11404:
	.ascii	"ftl_alloc_sblk\000"
	.section	.rodata.__func__.11446,"a",%progbits
	.set	.LANCHOR105,. + 0
	.type	__func__.11446, %object
	.size	__func__.11446, 18
__func__.11446:
	.ascii	"ftl_alloc_sys_blk\000"
	.section	.rodata.__func__.11456,"a",%progbits
	.set	.LANCHOR106,. + 0
	.type	__func__.11456, %object
	.size	__func__.11456, 17
__func__.11456:
	.ascii	"ftl_free_sys_blk\000"
	.section	.rodata.__func__.11491,"a",%progbits
	.set	.LANCHOR212,. + 0
	.type	__func__.11491, %object
	.size	__func__.11491, 14
__func__.11491:
	.ascii	"ftl_sblk_dump\000"
	.section	.rodata.__func__.11515,"a",%progbits
	.set	.LANCHOR201,. + 0
	.type	__func__.11515, %object
	.size	__func__.11515, 16
__func__.11515:
	.ascii	"ftl_sysblk_dump\000"
	.section	.rodata.__func__.11537,"a",%progbits
	.set	.LANCHOR189,. + 0
	.type	__func__.11537, %object
	.size	__func__.11537, 23
__func__.11537:
	.ascii	"ftl_open_sblk_recovery\000"
	.section	.rodata.__func__.11567,"a",%progbits
	.set	.LANCHOR107,. + 0
	.type	__func__.11567, %object
	.size	__func__.11567, 23
__func__.11567:
	.ascii	"ftl_get_ppa_from_index\000"
	.section	.rodata.__func__.11588,"a",%progbits
	.set	.LANCHOR215,. + 0
	.type	__func__.11588, %object
	.size	__func__.11588, 19
__func__.11588:
	.ascii	"ftl_update_l2p_map\000"
	.section	.rodata.__func__.11607,"a",%progbits
	.set	.LANCHOR111,. + 0
	.type	__func__.11607, %object
	.size	__func__.11607, 22
__func__.11607:
	.ascii	"ftl_get_new_free_page\000"
	.section	.rodata.__func__.11618,"a",%progbits
	.set	.LANCHOR112,. + 0
	.type	__func__.11618, %object
	.size	__func__.11618, 22
__func__.11618:
	.ascii	"ftl_ext_alloc_new_blk\000"
	.section	.rodata.__func__.11643,"a",%progbits
	.set	.LANCHOR184,. + 0
	.type	__func__.11643, %object
	.size	__func__.11643, 19
__func__.11643:
	.ascii	"ftl_ext_info_flush\000"
	.section	.rodata.__func__.11655,"a",%progbits
	.set	.LANCHOR185,. + 0
	.type	__func__.11655, %object
	.size	__func__.11655, 18
__func__.11655:
	.ascii	"ftl_ext_info_init\000"
	.section	.rodata.__func__.11694,"a",%progbits
	.set	.LANCHOR186,. + 0
	.type	__func__.11694, %object
	.size	__func__.11694, 25
__func__.11694:
	.ascii	"ftl_low_format_data_init\000"
	.section	.rodata.__func__.11709,"a",%progbits
	.set	.LANCHOR188,. + 0
	.type	__func__.11709, %object
	.size	__func__.11709, 15
__func__.11709:
	.ascii	"ftl_low_format\000"
	.section	.rodata.__func__.11757,"a",%progbits
	.set	.LANCHOR177,. + 0
	.type	__func__.11757, %object
	.size	__func__.11757, 14
__func__.11757:
	.ascii	"ftl_prog_page\000"
	.section	.rodata.__func__.11879,"a",%progbits
	.set	.LANCHOR167,. + 0
	.type	__func__.11879, %object
	.size	__func__.11879, 31
__func__.11879:
	.ascii	"queue_wait_first_req_completed\000"
	.section	.rodata.__func__.11933,"a",%progbits
	.set	.LANCHOR173,. + 0
	.type	__func__.11933, %object
	.size	__func__.11933, 15
__func__.11933:
	.ascii	"sblk_prog_page\000"
	.section	.rodata.__func__.11960,"a",%progbits
	.set	.LANCHOR169,. + 0
	.type	__func__.11960, %object
	.size	__func__.11960, 15
__func__.11960:
	.ascii	"sblk_read_page\000"
	.section	.rodata.__func__.12020,"a",%progbits
	.set	.LANCHOR202,. + 0
	.type	__func__.12020, %object
	.size	__func__.12020, 16
__func__.12020:
	.ascii	"load_l2p_region\000"
	.section	.rodata.__func__.12034,"a",%progbits
	.set	.LANCHOR147,. + 0
	.type	__func__.12034, %object
	.size	__func__.12034, 13
__func__.12034:
	.ascii	"pm_free_sblk\000"
	.section	.rodata.__func__.12054,"a",%progbits
	.set	.LANCHOR204,. + 0
	.type	__func__.12054, %object
	.size	__func__.12054, 6
__func__.12054:
	.ascii	"pm_gc\000"
	.section	.rodata.__func__.12070,"a",%progbits
	.set	.LANCHOR131,. + 0
	.type	__func__.12070, %object
	.size	__func__.12070, 17
__func__.12070:
	.ascii	"pm_alloc_new_blk\000"
	.section	.rodata.__func__.12080,"a",%progbits
	.set	.LANCHOR190,. + 0
	.type	__func__.12080, %object
	.size	__func__.12080, 14
__func__.12080:
	.ascii	"pm_write_page\000"
	.section	.rodata.__func__.12098,"a",%progbits
	.set	.LANCHOR134,. + 0
	.type	__func__.12098, %object
	.size	__func__.12098, 21
__func__.12098:
	.ascii	"pm_select_ram_region\000"
	.section	.rodata.__func__.9598,"a",%progbits
	.set	.LANCHOR161,. + 0
	.type	__func__.9598, %object
	.size	__func__.9598, 19
__func__.9598:
	.ascii	"flash_read_page_en\000"
	.section	.rodata.__func__.9640,"a",%progbits
	.set	.LANCHOR175,. + 0
	.type	__func__.9640, %object
	.size	__func__.9640, 19
__func__.9640:
	.ascii	"flash_prog_page_en\000"
	.section	.rodata.__func__.9656,"a",%progbits
	.set	.LANCHOR38,. + 0
	.type	__func__.9656, %object
	.size	__func__.9656, 26
__func__.9656:
	.ascii	"flash_erase_duplane_block\000"
	.section	.rodata.__func__.9667,"a",%progbits
	.set	.LANCHOR40,. + 0
	.type	__func__.9667, %object
	.size	__func__.9667, 21
__func__.9667:
	.ascii	"flash_erase_block_en\000"
	.section	.rodata.__func__.9681,"a",%progbits
	.set	.LANCHOR29,. + 0
	.type	__func__.9681, %object
	.size	__func__.9681, 28
__func__.9681:
	.ascii	"flash_wait_device_ready_raw\000"
	.section	.rodata.__func__.9705,"a",%progbits
	.set	.LANCHOR170,. + 0
	.type	__func__.9705, %object
	.size	__func__.9705, 26
__func__.9705:
	.ascii	"flash_start_tlc_page_prog\000"
	.section	.rodata.__func__.9716,"a",%progbits
	.set	.LANCHOR171,. + 0
	.type	__func__.9716, %object
	.size	__func__.9716, 29
__func__.9716:
	.ascii	"flash_start_3d_mlc_page_prog\000"
	.section	.rodata.__func__.9734,"a",%progbits
	.set	.LANCHOR172,. + 0
	.type	__func__.9734, %object
	.size	__func__.9734, 22
__func__.9734:
	.ascii	"flash_start_page_prog\000"
	.section	.rodata.__func__.9745,"a",%progbits
	.set	.LANCHOR33,. + 0
	.type	__func__.9745, %object
	.size	__func__.9745, 22
__func__.9745:
	.ascii	"flash_start_page_read\000"
	.section	.rodata.__func__.9758,"a",%progbits
	.set	.LANCHOR165,. + 0
	.type	__func__.9758, %object
	.size	__func__.9758, 31
__func__.9758:
	.ascii	"flash_complete_plane_page_read\000"
	.section	.rodata.__func__.9770,"a",%progbits
	.set	.LANCHOR41,. + 0
	.type	__func__.9770, %object
	.size	__func__.9770, 23
__func__.9770:
	.ascii	"flash_start_plane_read\000"
	.section	.rodata.__func__.9783,"a",%progbits
	.set	.LANCHOR166,. + 0
	.type	__func__.9783, %object
	.size	__func__.9783, 25
__func__.9783:
	.ascii	"flash_complete_page_read\000"
	.section	.rodata._list_remove_node.str1.1,"aMS",%progbits,1
.LC0:
	.ascii	"\012!!!!! error @ func:%s - line:%d\012\000"
	.section	.rodata.dump_ftl_info.str1.1,"aMS",%progbits,1
.LC172:
	.ascii	"free_buf_count: %d\012\000"
.LC173:
	.ascii	"g_ftl_info_blk blk:0x%x, index:0x%x, page:0x%x\012\000"
.LC174:
	.ascii	"ftl_ext_info_blk blk:0x%x, page:0x%x\012\000"
.LC175:
	.ascii	"ac_blk:0x%x, page:0x%x, index:0x%x, free:0x%x, page"
	.ascii	"_index:0x%x\012\000"
.LC176:
	.ascii	"tmp_blk:0x%x, page:0x%x, index:0x%x, free:0x%x, pag"
	.ascii	"e_index:0x%x\012\000"
.LC177:
	.ascii	"gc_blk:0x%x, page:0x%x, index:0x%x, free:0x%x, page"
	.ascii	"_index:0x%x\012\000"
.LC178:
	.ascii	"lpa:\000"
.LC179:
	.ascii	"vpn:\000"
.LC180:
	.ascii	"sblk:\000"
.LC181:
	.ascii	"lpa_hash:\000"
.LC182:
	.ascii	"lpa_hash_index:\000"
	.section	.rodata.dump_sblk_queue.str1.1,"aMS",%progbits,1
.LC74:
	.ascii	"dump_sblk_queue: %d\012\000"
.LC75:
	.ascii	"buf id= %d state = %d ppa = %x\012\000"
	.section	.rodata.flash_complete_page_read.str1.1,"aMS",%progbits,1
.LC122:
	.ascii	"flash_complete_page_read %x %x error_ecc %d %d\012\000"
	.section	.rodata.flash_ddr_tuning_read.str1.1,"aMS",%progbits,1
.LC115:
	.ascii	"%d flash_ddr_tuning_read %x ecc=%d\012\000"
.LC116:
	.ascii	"sync para %d\012\000"
.LC117:
	.ascii	"DDR mode Read error %x %x\012\000"
.LC118:
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
.LC121:
	.ascii	"flash_get_last_written_page: %x %x %x\012\000"
	.section	.rodata.flash_info_blk_init.str1.1,"aMS",%progbits,1
.LC169:
	.ascii	"...%d @ %s %d %p\012\000"
.LC170:
	.ascii	"no sys info %x\012\000"
	.section	.rodata.flash_info_data_init.str1.1,"aMS",%progbits,1
.LC90:
	.ascii	"...%d @ %s\012\000"
	.section	.rodata.flash_info_flush.str1.1,"aMS",%progbits,1
.LC166:
	.ascii	"finfo:\000"
.LC167:
	.ascii	"flash_info_flush id = %x, page = %x\012\000"
.LC168:
	.ascii	"sys_info_flush error:%x\012\000"
	.section	.rodata.flash_mask_bad_block.str1.1,"aMS",%progbits,1
.LC42:
	.ascii	"flash_mask_bad_block %d %d\012\000"
	.section	.rodata.flash_prog_page.str1.1,"aMS",%progbits,1
.LC128:
	.ascii	"flash_prog_page %x %x %x\012\000"
.LC129:
	.ascii	"flash_prog_page page_addr = %x status = %x\012\000"
	.section	.rodata.flash_prog_page_en.str1.1,"aMS",%progbits,1
.LC136:
	.ascii	"flash_prog_page_en:%x %x %x\012\000"
.LC137:
	.ascii	"w d:\000"
.LC138:
	.ascii	"w s:\000"
.LC139:
	.ascii	"spare\000"
.LC140:
	.ascii	"data\000"
.LC141:
	.ascii	"write error: %x\012\000"
	.section	.rodata.flash_read_id.str1.1,"aMS",%progbits,1
.LC39:
	.ascii	"No.%d FLASH ID:%x %x %x %x %x %x\012\000"
	.section	.rodata.flash_read_otp_data.str1.1,"aMS",%progbits,1
.LC40:
	.ascii	"otp:%x %x %x %x\012\000"
	.section	.rodata.flash_read_page.str1.1,"aMS",%progbits,1
.LC108:
	.ascii	"flash_read_page %x %x %x\012\000"
	.section	.rodata.flash_read_page_en.str1.1,"aMS",%progbits,1
.LC119:
	.ascii	"flash_read_page_en %x %x %x\012\000"
.LC120:
	.ascii	"flash_read_page_en %x %x error_ecc %d %d\012\000"
	.section	.rodata.flash_set_interface_mode.str1.1,"aMS",%progbits,1
.LC37:
	.ascii	"nand sdr mode %x\012\000"
.LC38:
	.ascii	"nand ddr mode %x\012\000"
	.section	.rodata.ftl_alloc_new_data_sblk.str1.1,"aMS",%progbits,1
.LC230:
	.ascii	"error gc_add_sblk: %x\012\000"
	.section	.rodata.ftl_alloc_sblk.str1.1,"aMS",%progbits,1
.LC73:
	.ascii	"alloc sblk %x %d\012\000"
	.section	.rodata.ftl_dump_write_open_sblk.str1.1,"aMS",%progbits,1
.LC161:
	.ascii	"ftl_sblk_dump_write = %x %d %d %d %d\012\000"
.LC162:
	.ascii	"blk= %x, page=%x, ppa = %x, status = %x, data:%x %x"
	.ascii	" %x %x, spare: %x %x %x %x\012\000"
.LC163:
	.ascii	"ftl_sblk_dump_write2 = %x %d %d %d\012\000"
.LC164:
	.ascii	"ftl_sblk_dump_write = %x %x\012\000"
.LC165:
	.ascii	"ftl_sblk_dump_write done = %x\012\000"
	.section	.rodata.ftl_ext_info_init.str1.1,"aMS",%progbits,1
.LC147:
	.ascii	"%s %d %d %x %x\012\000"
	.section	.rodata.ftl_free_sblk.str1.1,"aMS",%progbits,1
.LC61:
	.ascii	"swl_tlc_free_mini_ec_blk sblk %x\012\000"
.LC62:
	.ascii	"swl_slc_free_mini_ec_blk sblk %x\012\000"
	.section	.rodata.ftl_info_blk_init.str1.1,"aMS",%progbits,1
.LC144:
	.ascii	"%d %x @%d %x\012\000"
.LC145:
	.ascii	"ftl_info_blk_init %d %d %x\012\000"
.LC146:
	.ascii	"ink flag: %x\012\000"
	.section	.rodata.ftl_info_flush.str1.1,"aMS",%progbits,1
.LC143:
	.ascii	"g_ftl_info_blk blk = %x, page = %x version = %d\012"
	.ascii	"\000"
	.section	.rodata.ftl_low_format.str1.1,"aMS",%progbits,1
.LC148:
	.ascii	"ftl_low_format %d\012\000"
.LC149:
	.ascii	"low format %d %d %d %d\012\000"
	.section	.rodata.ftl_mask_bad_block.str1.1,"aMS",%progbits,1
.LC59:
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
	.ascii	"sblk = %x, vpn0 = %d, vpn1 = %d\012\000"
.LC156:
	.ascii	"dump_write_lpa = %x %x %x %x\012\000"
.LC157:
	.ascii	"dump write new ppa = %x, last ppa = %x lpa = %x\012"
	.ascii	"\000"
.LC158:
	.ascii	"dump write = %x %x\012\000"
.LC159:
	.ascii	"dump write hash update = %x %x %x\012\000"
	.section	.rodata.ftl_re_low_format.str1.1,"aMS",%progbits,1
.LC150:
	.ascii	"re low format %d\012\000"
	.section	.rodata.ftl_sblk_dump.str1.1,"aMS",%progbits,1
.LC215:
	.ascii	"ftl_sblk_dump = %x %d %d %d %d\012\000"
.LC216:
	.ascii	"ftl_sblk_dump = %x %x %x %x\012\000"
.LC217:
	.ascii	"page_addr = %x, lpa=%x vpn = %d\012\000"
.LC218:
	.ascii	"index= %x, lpa=%x\012\000"
.LC219:
	.ascii	"block = %x, vpn=%x check vpn = %d\012\000"
	.section	.rodata.ftl_sysblk_dump.str1.1,"aMS",%progbits,1
.LC171:
	.ascii	"l2p:\000"
	.section	.rodata.ftl_test_block.str1.1,"aMS",%progbits,1
.LC142:
	.ascii	"low format %d\012\000"
	.section	.rodata.ftl_update_l2p_map.str1.1,"aMS",%progbits,1
.LC226:
	.ascii	"ftl_update_l2p_map: %x %x %x\012\000"
.LC227:
	.ascii	"ftl_update_l2p_map\000"
.LC228:
	.ascii	"lpa_tbl:\000"
.LC229:
	.ascii	"sblk %x vpn: %d %d\012\000"
	.section	.rodata.ftl_vpn_decrement.str1.1,"aMS",%progbits,1
.LC58:
	.ascii	"ftl_vpn_decrement %x = %d, %d\012\000"
	.section	.rodata.ftl_write_commit.str1.1,"aMS",%progbits,1
.LC231:
	.ascii	"%d read error: ppa:%x, lpa:%x, status:%x\012\000"
	.section	.rodata.ftl_write_completed.str1.1,"aMS",%progbits,1
.LC71:
	.ascii	"ftl prog error =%x, lpa = %x, ppa= %x\012\000"
.LC72:
	.ascii	"ftl re prog: lpa = %x, ppa= %x\012\000"
	.section	.rodata.gc_add_sblk.str1.1,"aMS",%progbits,1
.LC43:
	.ascii	"gc_add_sblk = %d, %d, %d, %d, %d, %d\012\000"
.LC44:
	.ascii	"gc_add_sblk = %d, %d, %d,last update:%d, %d\012\000"
	.section	.rodata.gc_check_data_one_wl.str1.1,"aMS",%progbits,1
.LC223:
	.ascii	"gc_lpa:\000"
.LC224:
	.ascii	"gc_ppa:\000"
.LC225:
	.ascii	"err: ppa = %x, status = %x, %x %x spare: %x %x %x %"
	.ascii	"x\012\000"
	.section	.rodata.gc_do_copy_back.str1.1,"aMS",%progbits,1
.LC232:
	.ascii	"gc page in buf: lpa %x ppa = %x pageindex= %x\012\000"
.LC233:
	.ascii	"gc_do_copy_back: lpa %x des_ppa = %x %x gc_ppa= %x "
	.ascii	"page_index= %d\012\000"
.LC234:
	.ascii	"gc_do_copy_back: %x %x %x %x gc_ppa:%x %x\012\000"
.LC235:
	.ascii	"%d prog_step: %x %x buf id= %x ppa = %x hash=%x id "
	.ascii	"= %x plane = %x lpa=%x\012\000"
	.section	.rodata.gc_free_bad_sblk.str1.1,"aMS",%progbits,1
.LC60:
	.ascii	"gc_free_bad_sblk 0x%x\012\000"
	.section	.rodata.gc_free_src_blk.str1.1,"aMS",%progbits,1
.LC63:
	.ascii	"gc_free_src_blk = %x, vpn = %d\012\000"
.LC64:
	.ascii	"gc_free_src_blk %x, %d\012\000"
	.section	.rodata.gc_free_temp_buf.str1.1,"aMS",%progbits,1
.LC48:
	.ascii	"%d gc_free_temp_buf buf id= %x\012\000"
	.section	.rodata.gc_mark_bad_ppa.str1.1,"aMS",%progbits,1
.LC45:
	.ascii	"gc_mark_bad_ppa %d %x %x\012\000"
	.section	.rodata.gc_recovery.str1.1,"aMS",%progbits,1
.LC193:
	.ascii	"ppa = %x, status = %x, data:%x %x %x %x, spare: %x "
	.ascii	"%x %x %x\012\000"
.LC194:
	.ascii	"ppa = %x, status = %x, %x %x spare: %x %x %x %x\012"
	.ascii	"\000"
.LC195:
	.ascii	"gc_recovery: %x vpn = %x\012\000"
	.section	.rodata.gc_scan_src_blk.str1.1,"aMS",%progbits,1
.LC213:
	.ascii	"gc_scan_src_blk = %x, vpn = %d\012\000"
.LC214:
	.ascii	"gc_scan_src_blk = %x, s vpn0 = %d, c vpn1 = %d\012\000"
	.section	.rodata.gc_search_src_blk.str1.1,"aMS",%progbits,1
.LC50:
	.ascii	"zftl_get_gc_node cache = %x index = %d vpn = %x\012"
	.ascii	"\000"
.LC51:
	.ascii	"gc_search_src_blk mode = %x, src mode = %x, count= "
	.ascii	"%d %d\012\000"
	.section	.rodata.gc_static_wearleveling.str1.1,"aMS",%progbits,1
.LC79:
	.ascii	"gc_static_wearleveling: min blk: %x,sec=%d,xec = %d"
	.ascii	" ,mode=%d, func=%x, bbt=%x vpn = %d\012\000"
.LC80:
	.ascii	"gc_static_wearleveling: min slc blk: %x,sec=%d,xec "
	.ascii	"= %d ,mode=%d, func=%x, bbt=%x vpn = %d\012\000"
.LC81:
	.ascii	"gc_static_wearleveling: min tlc blk: %x,sec=%d,xec "
	.ascii	"= %d ,mode=%d, func=%x, bbt=%x vpn = %d\012\000"
.LC82:
	.ascii	"gc_static_wearleveling: max slc blk: %x,sec=%d,xec "
	.ascii	"= %d ,mode=%d, func=%x, bbt=%x vpn = %d\012\000"
.LC83:
	.ascii	"gc_static_wearleveling: max xlc blk: %x,sec=%d,xec "
	.ascii	"= %d ,mode=%d, func=%x, bbt=%x vpn = %d\012\000"
.LC84:
	.ascii	"gc_static_wearleveling: slc blk: %x, tlc blk: %d av"
	.ascii	"g slc ec: %d, avg tlc ec: %d \012\000"
.LC85:
	.ascii	"gc_static_wearleveling: min slc ec: %x, min tlc ec:"
	.ascii	" %d max slc ec: %d, max tlc ec: %d; %d %d\012\000"
.LC86:
	.ascii	"swl add tlc gc = %x, %d, %d, %d, %d, %d\012\000"
.LC87:
	.ascii	"swl add slc gc  = %x, %d, %d, %d, %d, %d\012\000"
	.section	.rodata.gc_update_l2p_map_new.str1.1,"aMS",%progbits,1
.LC209:
	.ascii	"gc_update_l2p_map_new sblk %x\012\000"
.LC210:
	.ascii	"gc_update_l2p_map_new: %x %x %x\012\000"
.LC211:
	.ascii	"lpa: %x %x %x\012\000"
.LC212:
	.ascii	"gc_update_l2p_map_new: %x vpn = %x vpn1 = %x done\012"
	.ascii	"\000"
	.section	.rodata.gc_write_completed.str1.1,"aMS",%progbits,1
.LC46:
	.ascii	"status: %x, ppa: %x\012\000"
.LC47:
	.ascii	"gc_write_completed: %x  %x  %x %x\012\000"
	.section	.rodata.hynix_get_read_retry_default.str1.1,"aMS",%progbits,1
.LC98:
	.ascii	"otp error! %d\000"
.LC99:
	.ascii	"rr\000"
	.section	.rodata.hynix_read_retrial.str1.1,"aMS",%progbits,1
.LC114:
	.ascii	"hynix RR %d row=%x, count %d, status=%d\012\000"
	.section	.rodata.idb_write_data.str1.1,"aMS",%progbits,1
.LC130:
	.ascii	"1 write_idblock fix data %x %x %x\012\000"
.LC131:
	.ascii	"write_idblock check fail! %x\012\000"
.LC132:
	.ascii	"write_idblock fail! %x\012\000"
	.section	.rodata.load_l2p_region.str1.1,"aMS",%progbits,1
.LC184:
	.ascii	"region_id = %d, pm_max_region = %d\012\000"
.LC185:
	.ascii	"load_l2p_region no ppa = %x , %x, all setting 0xff."
	.ascii	"...\012\000"
.LC186:
	.ascii	"load_l2p_region = %x,%x,%x, %x\012\000"
.LC187:
	.ascii	"pm_ppa:\000"
.LC188:
	.ascii	"data:\000"
.LC189:
	.ascii	"spare:\000"
	.section	.rodata.lpa_rebuild_hash.str1.1,"aMS",%progbits,1
.LC78:
	.ascii	"%s %d %d\012\000"
	.section	.rodata.micron_read_retrial.str1.1,"aMS",%progbits,1
.LC109:
	.ascii	"micron %d row=%x,last status %d,status = %d\012\000"
.LC110:
	.ascii	"micron RR %d row=%x,count %d,status=%d\012\000"
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
.LC91:
	.ascii	"...%s enter... %p\012\000"
.LC92:
	.ascii	"0:%x %x %x %x %x\012\000"
.LC93:
	.ascii	"g_nandc_ver...%d\012\000"
	.section	.rodata.nandc_xfer.str1.1,"aMS",%progbits,1
.LC105:
	.ascii	"dqs data abort %x\012\000"
.LC106:
	.ascii	"dqs data timeout %x\012\000"
.LC107:
	.ascii	"xfer error %x\012\000"
	.section	.rodata.nandc_xfer_done.str1.1,"aMS",%progbits,1
.LC100:
	.ascii	"flash_abort_clear = %d\012\000"
.LC101:
	.ascii	"%d mtrans_cnt = %d page_num = %d\012\000"
.LC102:
	.ascii	"nandc:\000"
.LC103:
	.ascii	"%d flReg.d32=%x %x\012\000"
.LC104:
	.ascii	"nandc_xfer_done read error %x\012\000"
	.section	.rodata.pm_alloc_new_blk.str1.1,"aMS",%progbits,1
.LC76:
	.ascii	"blk %x is bad block\012\000"
.LC77:
	.ascii	"pm_alloc_new_blk: %x %x %x %x\012\000"
	.section	.rodata.pm_free_sblk.str1.1,"aMS",%progbits,1
.LC89:
	.ascii	"ftl_free_no_use_map_blk %x %x %x %d\012\000"
	.section	.rodata.pm_init.str1.1,"aMS",%progbits,1
.LC190:
	.ascii	"pm_init posr %x %x %x\012\000"
.LC191:
	.ascii	"pm_init recovery %x %x %x\012\000"
	.section	.rodata.pm_log2phys.str1.1,"aMS",%progbits,1
.LC192:
	.ascii	"pm_log2phys  lpn = %d, max lpn = %d\012\000"
	.section	.rodata.pm_ppa_update_check.str1.1,"aMS",%progbits,1
.LC183:
	.ascii	"%s w error lpn = %x, max ppa = %d\012\000"
	.section	.rodata.pm_write_page.str1.1,"aMS",%progbits,1
.LC160:
	.ascii	"pm_write_page write error: %x\012\000"
	.section	.rodata.print_ftl_debug_info.str1.1,"aMS",%progbits,1
.LC65:
	.ascii	"bad blk = %x, %x free blk: s:%x,t:%x,m:%x, data blk"
	.ascii	":s:%x,%x,t%x vpn: s:%x t:%x, max_vpn: %x\012\000"
.LC66:
	.ascii	"totle w: %d MB,r: %d MB %d dv:0x%X,poc:%d\012\000"
.LC67:
	.ascii	"gc xlc page: %d,gc slc page: %d, tmp w: %d MB\012\000"
.LC68:
	.ascii	"slc ec: %d,%d,%d,%d,%d,tlc ec: %d,%d,%d,%d,%d\012\000"
.LC69:
	.ascii	"gc th: tlc_tlc: %d tlc_slc: %d slc_slc: %d slc_tlc:"
	.ascii	"%d free_th: %d\012\000"
.LC70:
	.ascii	"swl : %x %x %x %x\012\000"
	.section	.rodata.print_gc_debug_info.str1.1,"aMS",%progbits,1
.LC49:
	.ascii	"gc: b:%x,p:%x,i:%x; free buf=%d %d free slc th: %d\012"
	.ascii	"\000"
	.section	.rodata.print_list_info.str1.1,"aMS",%progbits,1
.LC56:
	.ascii	"list count:%p %d\012\000"
.LC57:
	.ascii	"%d: node:%x %x %x %x, %d %d %d %d %d\012\000"
	.section	.rodata.queue_wait_first_req_completed.str1.1,"aMS",%progbits,1
.LC123:
	.ascii	"read: %x %x %x %x\012\000"
.LC124:
	.ascii	"0set buf %d,status = %x, ppa = %x lun state = %d\012"
	.ascii	"\000"
.LC125:
	.ascii	"prog end %x %x error_ecc %d %d\012\000"
.LC126:
	.ascii	"1set buf %d,status = %x, ppa = %x lun state = %d\012"
	.ascii	"\000"
.LC127:
	.ascii	"dp prog end %x %x error_ecc %d %d\012\000"
	.section	.rodata.random_seed,"a",%progbits
	.align	1
	.set	.LANCHOR49,. + 0
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
.LC208:
	.ascii	"zftl_init %x\012\000"
	.section	.rodata.rknand_print_hex.str1.1,"aMS",%progbits,1
.LC94:
	.ascii	"%s 0x%x:\000"
.LC95:
	.ascii	"%x \000"
.LC96:
	.ascii	"\000"
.LC97:
	.ascii	"%s\012\000"
	.section	.rodata.sandisk_prog_test_bad_block.str1.1,"aMS",%progbits,1
.LC41:
	.ascii	"bad block test:%x %x\012\000"
	.section	.rodata.sblk_3d_tlc_dump_prog.str1.1,"aMS",%progbits,1
.LC133:
	.ascii	"sblk_3d_tlc_dump_prog wl_addr= %x ppa = %x ppa = %x"
	.ascii	"\012\000"
	.section	.rodata.sblk_mlc_dump_prog.str1.1,"aMS",%progbits,1
.LC134:
	.ascii	"sblk_mlc_dump_prog wl_addr= %x ppa = %x ppa = %x\012"
	.ascii	"\000"
	.section	.rodata.sblk_prog_page.str1.1,"aMS",%progbits,1
.LC135:
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
	.set	.LANCHOR35,. + 0
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
	.set	.LANCHOR34,. + 0
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
.LC111:
	.ascii	"toshiba SRR %d row=%x, status=%d\012\000"
.LC112:
	.ascii	"toshiba TRR %d row=%x, status=%d\012\000"
.LC113:
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
.LC241:
	.ascii	"ftl_discard:(%x, %x, %x, %x)\012\000"
	.section	.rodata.zftl_do_gc.str1.1,"aMS",%progbits,1
.LC236:
	.ascii	"gc %d: %d %d %d %d %d %d %d\012\000"
.LC237:
	.ascii	"gc %d: %d %d %d %d %d %d\012\000"
.LC238:
	.ascii	"GC_STATE_SCAN_ALL_PAGE = %x, vpn0 = %d, vpn1 = %d\012"
	.ascii	"\000"
.LC239:
	.ascii	"gc free %x, %d\012\000"
	.section	.rodata.zftl_gc_get_free_sblk.str1.1,"aMS",%progbits,1
.LC52:
	.ascii	"swl_tlc_free_mini_ec_blk alloc sblk %x\012\000"
.LC53:
	.ascii	"zftl_get_free_sblk %x %d, %p %d %d\012\000"
.LC54:
	.ascii	"zftl_gc_get_free_sblk %x %x %x, %d %d %d\012\000"
	.section	.rodata.zftl_get_free_sblk.str1.1,"aMS",%progbits,1
.LC55:
	.ascii	"swl_slc_free_mini_ec_blk alloc sblk %x\012\000"
	.section	.rodata.zftl_init.str1.1,"aMS",%progbits,1
.LC196:
	.ascii	"FTL version: 6.0.16 20190427\000"
.LC197:
	.ascii	"_c_user_data_density := %d\012\000"
.LC198:
	.ascii	"_c_totle_phy_density := %d\012\000"
.LC199:
	.ascii	"_c_totle_log_page := %d\012\000"
.LC200:
	.ascii	"_c_totle_data_density := %d\012\000"
.LC201:
	.ascii	"_c_ftl_pm_page_num := %d\012\000"
.LC202:
	.ascii	"_c_ftl_byte_pre_page := %d\012\000"
.LC203:
	.ascii	"_c_max_pm_sblk := %d\012\000"
.LC204:
	.ascii	"_min_slc_super_block := %d\012\000"
.LC205:
	.ascii	"_max_xlc_super_block := %d\012\000"
.LC206:
	.ascii	"gp_ftl_ext_info %p %p %p\012\000"
.LC207:
	.ascii	"flash info size: %d %d %d\012\000"
	.section	.rodata.zftl_read.str1.1,"aMS",%progbits,1
.LC220:
	.ascii	"ftl_read %x %x %x\012\000"
.LC221:
	.ascii	"ftl_read refresh =%x, lpa = %x, ppa= %x\012\000"
.LC222:
	.ascii	"id=%d, status = %x, lpa = %x, ppa = %x spare = %x %"
	.ascii	"x %x %x\012\000"
	.section	.rodata.zftl_sblk_list_init.str1.1,"aMS",%progbits,1
.LC88:
	.ascii	"free blk vpn error: %x %x\012\000"
	.section	.rodata.zftl_write.str1.1,"aMS",%progbits,1
.LC240:
	.ascii	"ftlwrite %x %x %x %x\012\000"
	.hidden	free
