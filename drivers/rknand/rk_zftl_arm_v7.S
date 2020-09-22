/*
 * Copyright (c) 2016-2017, Fuzhou Rockchip Electronics Co., Ltd
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * date: 2020-11-30
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
	movs	r2, #202
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
	movw	r2, #273
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
	.section	.text.nandc_de_cs.constprop.33,"ax",%progbits
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	nandc_de_cs.constprop.33, %function
nandc_de_cs.constprop.33:
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
	.size	nandc_de_cs.constprop.33, .-nandc_de_cs.constprop.33
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
	ldr	r4, .L216
	ldr	r3, [r4]
	lsls	r5, r3, #19
	bpl	.L99
	ldr	r1, .L216+4
	ldr	r0, .L216+8
	bl	printf
.L99:
	ldr	r3, [r4]
	lsls	r0, r3, #19
	bpl	.L100
	ldr	r3, .L216+12
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
	ldr	r0, .L216+16
	bl	printf
.L100:
	ldr	r3, [r4]
	lsls	r1, r3, #19
	bpl	.L101
	ldr	r3, .L216+12
	ldr	r0, .L216+20
	ldr	r3, [r3]
	ldrb	r1, [r3, #8]	@ zero_extendqisi2
	bl	printf
.L101:
	ldr	r3, [r4]
	lsls	r2, r3, #19
	bpl	.L102
	ldr	r3, .L216+12
	ldr	r0, .L216+24
	ldr	r3, [r3]
	ldrb	r1, [r3, #9]	@ zero_extendqisi2
	bl	printf
.L102:
	ldr	r3, [r4]
	lsls	r3, r3, #19
	bpl	.L103
	ldr	r3, .L216+12
	ldr	r0, .L216+28
	ldr	r3, [r3]
	ldrh	r1, [r3, #10]
	bl	printf
.L103:
	ldr	r3, [r4]
	lsls	r5, r3, #19
	bpl	.L104
	ldr	r3, .L216+12
	ldr	r0, .L216+32
	ldr	r3, [r3]
	ldrb	r1, [r3, #12]	@ zero_extendqisi2
	bl	printf
.L104:
	ldr	r3, [r4]
	lsls	r0, r3, #19
	bpl	.L105
	ldr	r3, .L216+12
	ldr	r0, .L216+36
	ldr	r3, [r3]
	ldrb	r1, [r3, #13]	@ zero_extendqisi2
	bl	printf
.L105:
	ldr	r3, [r4]
	lsls	r1, r3, #19
	bpl	.L106
	ldr	r3, .L216+12
	ldr	r0, .L216+40
	ldr	r3, [r3]
	ldrh	r1, [r3, #14]
	bl	printf
.L106:
	ldr	r3, [r4]
	lsls	r2, r3, #19
	bpl	.L107
	ldr	r3, .L216+12
	ldr	r0, .L216+44
	ldr	r3, [r3]
	ldrb	r1, [r3, #23]	@ zero_extendqisi2
	bl	printf
.L107:
	ldr	r3, [r4]
	lsls	r3, r3, #19
	bpl	.L108
	ldr	r3, .L216+12
	ldr	r0, .L216+48
	ldr	r3, [r3]
	ldrb	r1, [r3, #18]	@ zero_extendqisi2
	bl	printf
.L108:
	ldr	r3, [r4]
	lsls	r5, r3, #19
	bpl	.L109
	ldr	r3, .L216+12
	ldr	r0, .L216+52
	ldr	r3, [r3]
	ldrb	r1, [r3, #19]	@ zero_extendqisi2
	bl	printf
.L109:
	ldr	r3, [r4]
	lsls	r0, r3, #19
	bpl	.L110
	ldr	r3, .L216+12
	ldr	r0, .L216+56
	ldr	r3, [r3]
	ldrb	r1, [r3, #20]	@ zero_extendqisi2
	bl	printf
.L110:
	ldr	r3, [r4]
	lsls	r1, r3, #19
	bpl	.L111
	ldr	r3, .L216+60
	ldr	r0, .L216+64
	ldrb	r1, [r3]	@ zero_extendqisi2
	bl	printf
.L111:
	ldr	r3, [r4]
	lsls	r2, r3, #19
	bpl	.L112
	ldr	r3, .L216+12
	ldr	r0, .L216+68
	ldr	r3, [r3]
	ldrb	r1, [r3, #22]	@ zero_extendqisi2
	bl	printf
.L112:
	ldr	r3, [r4]
	lsls	r3, r3, #19
	bpl	.L113
	ldr	r3, .L216+72
	ldr	r0, .L216+76
	ldrb	r1, [r3]	@ zero_extendqisi2
	bl	printf
.L113:
	ldr	r3, [r4]
	lsls	r5, r3, #19
	bpl	.L114
	ldr	r3, .L216+12
	ldr	r0, .L216+80
	ldr	r3, [r3]
	ldrb	r1, [r3, #16]	@ zero_extendqisi2
	and	r1, r1, #1
	bl	printf
.L114:
	ldr	r3, [r4]
	lsls	r0, r3, #19
	bpl	.L115
	ldr	r3, .L216+12
	ldr	r0, .L216+84
	ldr	r3, [r3]
	ldrh	r1, [r3, #16]
	ubfx	r1, r1, #1, #1
	bl	printf
.L115:
	ldr	r3, [r4]
	lsls	r1, r3, #19
	bpl	.L116
	ldr	r3, .L216+12
	ldr	r0, .L216+88
	ldr	r3, [r3]
	ldrh	r1, [r3, #16]
	ubfx	r1, r1, #2, #1
	bl	printf
.L116:
	ldr	r3, [r4]
	lsls	r2, r3, #19
	bpl	.L117
	ldr	r3, .L216+12
	ldr	r0, .L216+92
	ldr	r3, [r3]
	ldrh	r1, [r3, #16]
	ubfx	r1, r1, #3, #1
	bl	printf
.L117:
	ldr	r3, [r4]
	lsls	r3, r3, #19
	bpl	.L118
	ldr	r3, .L216+12
	ldr	r0, .L216+96
	ldr	r3, [r3]
	ldrh	r1, [r3, #16]
	ubfx	r1, r1, #4, #1
	bl	printf
.L118:
	ldr	r3, [r4]
	lsls	r5, r3, #19
	bpl	.L119
	ldr	r3, .L216+12
	ldr	r0, .L216+100
	ldr	r3, [r3]
	ldrh	r1, [r3, #16]
	ubfx	r1, r1, #5, #1
	bl	printf
.L119:
	ldr	r3, [r4]
	lsls	r0, r3, #19
	bpl	.L120
	ldr	r3, .L216+12
	ldr	r0, .L216+104
	ldr	r3, [r3]
	ldrh	r1, [r3, #16]
	ubfx	r1, r1, #6, #1
	bl	printf
.L120:
	ldr	r3, [r4]
	lsls	r1, r3, #19
	bpl	.L121
	ldr	r3, .L216+12
	ldr	r0, .L216+108
	ldr	r3, [r3]
	ldrh	r1, [r3, #16]
	ubfx	r1, r1, #7, #1
	bl	printf
.L121:
	ldr	r3, [r4]
	lsls	r2, r3, #19
	bpl	.L122
	ldr	r3, .L216+12
	ldr	r0, .L216+112
	ldr	r3, [r3]
	ldrh	r1, [r3, #16]
	ubfx	r1, r1, #8, #1
	bl	printf
.L122:
	ldr	r3, [r4]
	lsls	r3, r3, #19
	bpl	.L123
	ldr	r3, .L216+12
	ldr	r0, .L216+116
	ldr	r3, [r3]
	ldrh	r1, [r3, #16]
	ubfx	r1, r1, #9, #1
	bl	printf
.L123:
	ldr	r3, [r4]
	lsls	r5, r3, #19
	bpl	.L124
	ldr	r3, .L216+12
	ldr	r0, .L216+120
	ldr	r3, [r3]
	ldrh	r1, [r3, #16]
	ubfx	r1, r1, #10, #1
	bl	printf
.L124:
	ldr	r3, [r4]
	lsls	r0, r3, #19
	bpl	.L125
	ldr	r3, .L216+124
	ldr	r0, .L216+128
	ldrb	r2, [r3]	@ zero_extendqisi2
	ldr	r3, .L216+132
	ldrb	r1, [r3]	@ zero_extendqisi2
	bl	printf
.L125:
	ldr	r3, [r4]
	lsls	r1, r3, #19
	bpl	.L126
	ldr	r3, .L216+136
	ldr	r0, .L216+140
	ldrb	r2, [r3, #11]	@ zero_extendqisi2
	ldrb	r1, [r3, #10]	@ zero_extendqisi2
	bl	printf
.L126:
	ldr	r3, [r4]
	lsls	r2, r3, #19
	bpl	.L127
	ldr	r3, .L216+136
	ldr	r0, .L216+144
	ldrb	r2, [r3, #9]	@ zero_extendqisi2
	ldrb	r1, [r3, #8]	@ zero_extendqisi2
	bl	printf
.L127:
	ldr	r3, [r4]
	lsls	r3, r3, #19
	bpl	.L98
	ldr	r3, .L216+148
	b	.L217
.L218:
	.align	2
.L216:
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
	.word	.LC14
	.word	.LANCHOR18
	.word	.LC15
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
	.word	.LANCHOR19
	.word	.LC27
	.word	.LANCHOR0
	.word	.LANCHOR20
	.word	.LC28
	.word	.LC29
	.word	.LANCHOR21
.L217:
	ldr	r0, .L219
	ldrb	r1, [r3]	@ zero_extendqisi2
	add	sp, sp, #20
	@ sp needed
	pop	{r4, r5, lr}
	b	printf
.L98:
	add	sp, sp, #20
	@ sp needed
	pop	{r4, r5, pc}
.L220:
	.align	2
.L219:
	.word	.LC30
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
.L222:
	ldr	r3, [sp, #4]
	subs	r2, r3, #1
	str	r2, [sp, #4]
	cmp	r3, #0
	bne	.L222
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
	ldr	r8, .L233+16
	mov	r5, r0
	movs	r4, #0
	ldr	r7, .L233
.L226:
	ldrb	r3, [r8]	@ zero_extendqisi2
	cmp	r4, r3
	bcc	.L230
	pop	{r4, r5, r6, r7, r8, pc}
.L230:
	movs	r3, #85
	movs	r0, #200
	str	r3, [r5, #8]
	ldrsb	r3, [r4, r7]
	str	r3, [r5, #4]
	bl	timer_delay_ns
	ldr	r3, .L233+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #34
	bne	.L227
	adds	r3, r4, r6
	add	r3, r3, r7
.L232:
	ldrsb	r3, [r3, #5]
.L231:
	str	r3, [r5]
	adds	r4, r4, #1
	b	.L226
.L227:
	cmp	r3, #35
	bne	.L229
	ldr	r3, .L233+8
	adds	r2, r4, r6
	add	r3, r3, r2
	b	.L232
.L229:
	ldr	r3, .L233+12
	ldrsb	r3, [r3, r1]
	b	.L231
.L234:
	.align	2
.L233:
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
	ldr	r3, .L240
	push	{r4, r5, r6, r7, r8, lr}
	lsls	r6, r0, #8
	ldr	r4, .L240+4
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
.L238:
	cmp	r5, r8
	bne	.L239
	add	r6, r6, r7
	movs	r3, #22
	str	r3, [r6, #2056]
	pop	{r4, r5, r6, r7, r8, pc}
.L239:
	ldrb	r3, [r5, #1]!	@ zero_extendqisi2
	movs	r0, #120
	str	r3, [r4, #2052]
	bl	timer_delay_ns
	ldrsb	r3, [r1, #1]!
	str	r3, [r4, #2048]
	b	.L238
.L241:
	.align	2
.L240:
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
	ldr	r3, .L247
	ldrb	r3, [r3]	@ zero_extendqisi2
	subs	r3, r3, #1
	cmp	r3, #7
	bhi	.L242
	ldr	r5, .L247+4
	ldr	r3, [r5]
	add	r3, r3, r0
	ldrb	r3, [r3, #120]	@ zero_extendqisi2
	cbz	r3, .L242
	movs	r1, #0
	bl	hynix_set_rr_para
	ldr	r0, [r5]
	movs	r3, #0
	add	r0, r0, r4
	strb	r3, [r0, #120]
.L242:
	pop	{r3, r4, r5, pc}
.L248:
	.align	2
.L247:
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
	ldr	r3, .L252
	ldr	r2, .L252+4
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
.L253:
	.align	2
.L252:
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
	ldr	r3, .L258
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #9
	ldr	r3, .L258+4
	ldr	r3, [r3]
	ite	eq
	ldreq	r0, [r3, #80]
	ldrne	r0, [r3, #304]
	ubfx	r0, r0, #8, #8
	bx	lr
.L259:
	.align	2
.L258:
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
	ldr	r3, .L268
	ands	r1, r0, #6
	ldr	r3, [r3]
	ldr	r2, [r3]
	beq	.L261
	lsls	r1, r0, #29
	ldr	r1, .L268+4
	orr	r2, r2, #24576
	bfc	r2, #15, #1
	ldrb	r1, [r1]	@ zero_extendqisi2
	orr	r2, r2, #196608
	it	mi
	orrmi	r2, r2, #32768
	cmp	r1, #9
	ldr	r1, .L268+8
	bne	.L263
	movw	r0, #8321
	str	r0, [r3, #8]
	str	r1, [r3, #80]
	movs	r1, #38
	str	r1, [r3, #84]
	movs	r1, #39
	str	r1, [r3, #84]
.L264:
	str	r2, [r3]
	bx	lr
.L263:
	movw	r0, #8322
	str	r0, [r3, #344]
	str	r1, [r3, #304]
	movs	r1, #38
	str	r1, [r3, #308]
	movs	r1, #39
	str	r1, [r3, #308]
	b	.L264
.L261:
	bfi	r2, r1, #13, #1
	b	.L264
.L269:
	.align	2
.L268:
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
	ldr	r3, .L271
	movs	r2, #1
	lsl	r0, r2, r0
	ldr	r1, [r3]
	ldr	r3, [r1]
	bfi	r3, r0, #0, #8
	str	r3, [r1]
	bx	lr
.L272:
	.align	2
.L271:
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
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	mov	r5, r1
	mov	fp, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r0
	bhi	.L274
	movw	r2, #805
	ldr	r1, .L283+4
	ldr	r0, .L283+8
	bl	printf
.L274:
	ldr	r3, .L283+12
	lsrs	r7, r5, #8
	lsr	r8, r5, #16
	lsr	r10, r5, #24
	ldrb	r6, [r3, r4]	@ zero_extendqisi2
	ldr	r3, .L283+16
	ldr	r4, [r3]
	add	r4, r4, r6, lsl #8
.L280:
	mov	r0, r6
	bl	nandc_cs
	movs	r3, #120
	str	r3, [r4, #2056]
	uxtb	r3, r5
	str	r3, [r4, #2052]
	ldr	r3, .L283+20
	str	r7, [r4, #2052]
	str	r8, [r4, #2052]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L275
	str	r10, [r4, #2052]
.L275:
	movs	r0, #120
	bl	timer_delay_ns
	ldr	r0, [r4, #2048]
	uxtb	r0, r0
	bl	nandc_de_cs.constprop.33
	bics	r3, fp, r0
	bne	.L280
	cmp	r0, #255
	beq	.L280
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L284:
	.align	2
.L283:
	.word	.LANCHOR18
	.word	.LANCHOR29
	.word	.LC0
	.word	.LANCHOR30
	.word	.LANCHOR13
	.word	.LANCHOR31
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
	.word	.LANCHOR32
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
	ldr	r3, .L327
	push	{r4, r5, r6, lr}
	mov	r6, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L307
	ldr	r2, .L327+4
	cmp	r3, #1
	ldr	r4, [r2]
	bne	.L310
	ldr	r3, .L327+8
	ldrb	r3, [r3, #29]	@ zero_extendqisi2
	cbz	r3, .L307
.L326:
	add	r4, r4, r6, lsl #8
.L325:
	str	r3, [r4, #2056]
.L307:
	pop	{r4, r5, r6, pc}
.L310:
	cmp	r3, #2
	bne	.L312
	ldr	r3, .L327+12
	ldrb	r2, [r3, r0]	@ zero_extendqisi2
	cmp	r2, #0
	beq	.L307
	ldr	r5, .L327+8
	movs	r2, #0
	strb	r2, [r3, r0]
	ldrb	r3, [r5, #29]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L307
	bl	nandc_wait_flash_ready_no_delay
	ldrb	r3, [r5, #29]	@ zero_extendqisi2
	b	.L326
.L312:
	cmp	r3, #3
	bne	.L307
	ldr	r5, .L327+12
	ldrb	r3, [r5, r0]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L307
	add	r4, r4, r6, lsl #8
	bl	nandc_wait_flash_ready_no_delay
	movs	r3, #239
	movs	r1, #0
	str	r3, [r4, #2056]
	movs	r3, #145
	str	r3, [r4, #2052]
	movs	r0, #100
	strb	r1, [r5, r6]
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
	b	.L325
.L328:
	.align	2
.L327:
	.word	.LANCHOR0
	.word	.LANCHOR13
	.word	.LANCHOR33
	.word	.LANCHOR34
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
	ldr	r3, .L350
	push	{r4, r5, r6, r7, r8, lr}
	mov	r4, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L329
	ldr	r2, .L350+4
	cmp	r3, #1
	ldr	r5, [r2]
	bne	.L332
	ldr	r3, .L350+8
	ldrb	r3, [r3, #30]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L329
.L349:
	add	r4, r5, r4, lsl #8
	str	r3, [r4, #2056]
	pop	{r4, r5, r6, r7, r8, pc}
.L332:
	cmp	r3, #2
	bne	.L334
	ldr	r2, .L350+12
	ldrb	r3, [r2, r0]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L329
	ldr	r6, .L350+8
	ldrb	r3, [r6, #12]	@ zero_extendqisi2
	cmp	r3, #2
	it	ne
	movne	r3, #4
	strb	r3, [r2, r0]
	ldrb	r3, [r6, #30]	@ zero_extendqisi2
	cbz	r3, .L329
	bl	nandc_wait_flash_ready_no_delay
	ldrb	r3, [r6, #30]	@ zero_extendqisi2
	b	.L349
.L334:
	cmp	r3, #3
	bne	.L329
	ldr	r6, .L350+12
	ldrb	r3, [r6, r0]	@ zero_extendqisi2
	cbnz	r3, .L329
	ldr	r8, .L350+8
	lsls	r7, r4, #8
	bl	nandc_wait_flash_ready_no_delay
	ldrb	r3, [r8, #12]	@ zero_extendqisi2
	adds	r1, r5, r7
	movs	r0, #100
	add	r5, r5, r7
	cmp	r3, #2
	it	ne
	movne	r3, #4
	strb	r3, [r6, r4]
	movs	r3, #239
	str	r3, [r1, #2056]
	movs	r3, #145
	str	r3, [r1, #2052]
	bl	timer_delay_ns
	ldrb	r3, [r8, #7]	@ zero_extendqisi2
	movs	r0, #150
	cmp	r3, #9
	mov	r3, #1
	itet	ne
	ldrbne	r2, [r6, r4]	@ zero_extendqisi2
	streq	r3, [r1, #2048]
	strne	r2, [r1, #2048]
	str	r3, [r1, #2048]
	movs	r3, #0
	str	r3, [r1, #2048]
	str	r3, [r1, #2048]
	bl	timer_delay_ns
	bl	nandc_wait_flash_ready_no_delay
	movs	r3, #223
	str	r3, [r5, #2056]
.L329:
	pop	{r4, r5, r6, r7, r8, pc}
.L351:
	.align	2
.L350:
	.word	.LANCHOR0
	.word	.LANCHOR13
	.word	.LANCHOR33
	.word	.LANCHOR34
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
	ldr	r3, .L366
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r5, r0
	ldr	r4, .L366+4
	mov	fp, r1
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
	bhi	.L353
	movw	r2, #1001
	ldr	r1, .L366+8
	ldr	r0, .L366+12
	bl	printf
.L353:
	ldrb	r3, [r4]	@ zero_extendqisi2
	cmp	r3, r8
	bls	.L352
	ldr	r3, .L366+16
	movs	r4, #1
	lsls	r4, r4, r7
	ldr	r6, .L366+20
	ldrb	r10, [r3, r8]	@ zero_extendqisi2
	subs	r4, r4, #1
	ldr	r3, .L366+24
	and	r4, r4, fp
	ubfx	fp, fp, #24, #2
	mov	r0, r10
	ldr	r7, [r3]
	lsl	r8, r10, #8
	bl	nandc_cs
	cmp	fp, #0
	bne	.L355
	mov	r0, r4
	bl	slc_phy_page_address_calc
	ldr	r3, .L366+28
	mov	r4, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L356
	mov	r0, r10
	bl	zftl_flash_enter_slc_mode
.L356:
	ldr	r3, [r6]
	ldrb	r2, [r3, #7]	@ zero_extendqisi2
	cmp	r2, #1
	bne	.L358
	ldrb	r3, [r3, #12]	@ zero_extendqisi2
	cmp	r3, #2
	ittt	eq
	addeq	r3, r7, r8
	moveq	r2, #38
	streq	r2, [r3, #2056]
.L358:
	add	r3, r7, r8
	movs	r2, #0
	str	r2, [r3, #2056]
	str	r2, [r3, #2052]
	str	r2, [r3, #2052]
	uxtb	r2, r4
	str	r2, [r3, #2052]
	lsrs	r2, r4, #8
	str	r2, [r3, #2052]
	lsrs	r2, r4, #16
	str	r2, [r3, #2052]
	ldr	r2, .L366+32
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbz	r2, .L359
	lsrs	r4, r4, #24
	str	r4, [r3, #2052]
.L359:
	add	r3, r7, r8
	str	r5, [r3, #2056]
.L352:
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L355:
	ldr	r3, [r6]
	ldrb	r3, [r3, #12]	@ zero_extendqisi2
	cmp	r3, #3
	bne	.L357
	ldr	r3, .L366+36
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L357
	ldr	r3, .L366+40
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L357
	add	r3, r7, r8
	str	fp, [r3, #2056]
	b	.L356
.L357:
	mov	r0, r10
	bl	zftl_flash_exit_slc_mode
	b	.L356
.L367:
	.align	2
.L366:
	.word	.LANCHOR32
	.word	.LANCHOR18
	.word	.LANCHOR35
	.word	.LC0
	.word	.LANCHOR30
	.word	.LANCHOR16
	.word	.LANCHOR13
	.word	.LANCHOR0
	.word	.LANCHOR31
	.word	.LANCHOR36
	.word	.LANCHOR37
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
	ldr	r4, .L373
	ldr	r1, .L373+4
.L370:
	ldr	r3, [r4]
	ldr	r3, [r3]
	str	r3, [sp, #4]
	ldr	r3, [sp, #4]
	lsls	r3, r3, #22
	bmi	.L371
	movs	r0, #10
	bl	timer_delay_ns
	subs	r1, r1, #1
	bne	.L370
	mov	r0, #-1
.L368:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, pc}
.L371:
	movs	r0, #0
	b	.L368
.L374:
	.align	2
.L373:
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
	ldr	r3, .L381
	add	r1, r1, r1, lsl #2
	ldr	r6, .L381+4
	movs	r2, #0
	ldr	r7, .L381+8
	ldrb	r0, [r3]	@ zero_extendqisi2
	ldr	r3, .L381+12
	ldrb	r5, [r3]	@ zero_extendqisi2
.L376:
	cmp	r2, r0
	bcc	.L379
	pop	{r3, r4, r5, r6, r7, lr}
	b	nandc_wait_flash_ready
.L379:
	adds	r3, r2, r1
	cmp	r5, #67
	ite	eq
	addeq	r3, r3, r7
	addne	r3, r3, r6
	ldrsb	r3, [r3, #5]
	adds	r2, r2, #1
	str	r3, [r4]
	b	.L376
.L382:
	.align	2
.L381:
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
	ldr	r3, .L384
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
.L385:
	.align	2
.L384:
	.word	.LANCHOR38
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
	ldr	r2, .L387
	add	r1, r1, r2
	ldrsb	r2, [r1, #1]
	str	r2, [r0]
	str	r3, [r0]
	str	r3, [r0]
	str	r3, [r0]
	b	nandc_wait_flash_ready
.L388:
	.align	2
.L387:
	.word	.LANCHOR39
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
	cbz	r2, .L390
	movs	r3, #18
	rsb	r1, r1, r1, lsl #3
	str	r3, [r0, #4]
	ldr	r3, .L392
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
.L391:
	pop	{r4, r5, r6, lr}
	b	nandc_wait_flash_ready
.L390:
	movs	r3, #20
	str	r3, [r0, #4]
	ldr	r3, .L392+4
	ldrb	r3, [r3, r1]	@ zero_extendqisi2
	str	r3, [r0]
	str	r2, [r0]
	str	r2, [r0]
	str	r2, [r0]
	b	.L391
.L393:
	.align	2
.L392:
	.word	.LANCHOR40
	.word	.LANCHOR41
	.size	toshiba_tlc_set_rr_para, .-toshiba_tlc_set_rr_para
	.section	.text.ymtc_3d_set_tlc_rr_para,"ax",%progbits
	.align	1
	.global	ymtc_3d_set_tlc_rr_para
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ymtc_3d_set_tlc_rr_para, %function
ymtc_3d_set_tlc_rr_para:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	movs	r7, #239
	movs	r3, #160
	str	r7, [r0, #8]
	rsb	r1, r1, r1, lsl #3
	movs	r6, #0
	str	r3, [r0, #4]
	mov	r4, r0
	ldr	r3, .L395
	adds	r5, r3, r1
	ldrsb	r3, [r3, r1]
	str	r3, [r0]
	ldrsb	r3, [r5, #4]
	str	r3, [r0]
	str	r6, [r0]
	str	r6, [r0]
	bl	nandc_wait_flash_ready
	movs	r3, #161
	str	r7, [r4, #8]
	str	r3, [r4, #4]
	ldrsb	r3, [r5, #1]
	str	r3, [r4]
	ldrsb	r3, [r5, #3]
	str	r3, [r4]
	ldrsb	r3, [r5, #5]
	str	r3, [r4]
	str	r6, [r4]
	bl	nandc_wait_flash_ready
	movs	r3, #162
	str	r7, [r4, #8]
	str	r3, [r4, #4]
	ldrsb	r3, [r5, #2]
	str	r3, [r4]
	ldrsb	r3, [r5, #6]
	str	r3, [r4]
	str	r6, [r4]
	str	r6, [r4]
	pop	{r3, r4, r5, r6, r7, lr}
	b	nandc_wait_flash_ready
.L396:
	.align	2
.L395:
	.word	.LANCHOR42
	.size	ymtc_3d_set_tlc_rr_para, .-ymtc_3d_set_tlc_rr_para
	.section	.text.ymtc_3d_set_slc_rr_para,"ax",%progbits
	.align	1
	.global	ymtc_3d_set_slc_rr_para
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ymtc_3d_set_slc_rr_para, %function
ymtc_3d_set_slc_rr_para:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	movs	r3, #239
	str	r3, [r0, #8]
	movs	r3, #163
	str	r3, [r0, #4]
	ldr	r3, .L398
	ldrsb	r3, [r3, r1]
	str	r3, [r0]
	movs	r3, #0
	str	r3, [r0]
	str	r3, [r0]
	str	r3, [r0]
	b	nandc_wait_flash_ready
.L399:
	.align	2
.L398:
	.word	.LANCHOR43
	.size	ymtc_3d_set_slc_rr_para, .-ymtc_3d_set_slc_rr_para
	.section	.text.flash_erase_duplane_block,"ax",%progbits
	.align	1
	.global	flash_erase_duplane_block
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_erase_duplane_block, %function
flash_erase_duplane_block:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r5, r2
	ldr	r4, .L424
	mov	r7, r0
	mov	r6, r1
	mov	r10, r3
	ldrb	r2, [r4]	@ zero_extendqisi2
	cmp	r2, r0
	bhi	.L401
	mov	r2, #688
	ldr	r1, .L424+4
	ldr	r0, .L424+8
	bl	printf
.L401:
	ldrb	r3, [r4]	@ zero_extendqisi2
	cmp	r3, r7
	bls	.L410
	ldr	r3, .L424+12
	ldrb	r4, [r3, r7]	@ zero_extendqisi2
	ldr	r3, .L424+16
	add	r7, r4, #8
	ldr	r8, [r3]
	ldr	r3, .L424+20
	ldr	r3, [r3]
	add	r7, r8, r7, lsl #8
	lsls	r3, r3, #27
	bpl	.L403
	mov	r3, r10
	mov	r2, r5
	mov	r1, r4
	ldr	r0, .L424+24
	bl	printf
.L403:
	bl	nandc_wait_flash_ready
	mov	r0, r4
	bl	nandc_cs
	mov	r0, r4
	cmp	r6, #0
	bne	.L404
	bl	zftl_flash_enter_slc_mode
.L405:
	lsls	r4, r4, #8
	movs	r3, #96
	add	r6, r8, r4
	str	r3, [r6, #2056]
	uxtb	r3, r5
	str	r3, [r6, #2052]
	lsrs	r3, r5, #8
	str	r3, [r6, #2052]
	lsrs	r3, r5, #16
	str	r3, [r6, #2052]
	ldr	r3, .L424+28
	ldrb	r2, [r3]	@ zero_extendqisi2
	cbz	r2, .L406
	lsrs	r2, r5, #24
	str	r2, [r6, #2052]
.L406:
	ldr	r2, .L424+32
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, #0
	bne	.L411
	add	r2, r8, r4
	movs	r1, #208
	str	r1, [r2, #2056]
	str	r3, [sp, #4]
	bl	nandc_wait_flash_ready
	mov	r0, r7
	bl	flash_read_status
	ldr	r3, [sp, #4]
	and	fp, r0, #5
.L407:
	add	r2, r8, r4
	movs	r1, #96
	str	r1, [r2, #2056]
	uxtb	r2, r10
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r2, [r6, #2052]
	lsr	r2, r10, #8
	str	r2, [r6, #2052]
	lsr	r2, r10, #16
	str	r2, [r6, #2052]
	cbz	r3, .L408
	lsr	r2, r10, #24
	str	r2, [r6, #2052]
.L408:
	movs	r3, #208
	add	r0, r8, r4
	str	r3, [r0, #2056]
	bl	nandc_wait_flash_ready
	mov	r0, r7
	bl	flash_read_status
	bl	nandc_de_cs.constprop.33
	and	r3, r0, #5
	orrs	fp, r3, fp
	beq	.L409
	mov	r2, r0
	mov	r1, r5
	ldr	r0, .L424+36
	bl	printf
.L409:
	mov	r0, fp
.L400:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L404:
	bl	zftl_flash_exit_slc_mode
	b	.L405
.L411:
	mov	fp, #0
	b	.L407
.L410:
	mov	r0, #-1
	b	.L400
.L425:
	.align	2
.L424:
	.word	.LANCHOR18
	.word	.LANCHOR44
	.word	.LC0
	.word	.LANCHOR30
	.word	.LANCHOR13
	.word	.LANCHOR14
	.word	.LC31
	.word	.LANCHOR31
	.word	.LANCHOR45
	.word	.LC32
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
	ldr	r3, .L444
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r7, r2
	ldr	r5, .L444+4
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
	bhi	.L427
	movw	r2, #750
	ldr	r1, .L444+8
	ldr	r0, .L444+12
	bl	printf
.L427:
	ldrb	r3, [r5]	@ zero_extendqisi2
	cmp	r3, r6
	bls	.L434
	ldr	r3, .L444+16
	ldrb	r5, [r3, r6]	@ zero_extendqisi2
	ldr	r3, .L444+20
	add	r10, r5, #8
	ldr	r8, [r3]
	ldr	r3, .L444+24
	ldr	r3, [r3]
	add	r10, r8, r10, lsl #8
	lsls	r3, r3, #27
	bpl	.L429
	mov	r3, fp
	mov	r2, r7
	mov	r1, r5
	ldr	r0, .L444+28
	bl	printf
.L429:
	bl	nandc_wait_flash_ready
	mov	r0, r5
	bl	nandc_cs
	mov	r0, r5
	cmp	fp, #0
	bne	.L430
	bl	zftl_flash_enter_slc_mode
.L431:
	lsls	r5, r5, #8
	movs	r2, #96
	add	r3, r8, r5
	str	r2, [r3, #2056]
	uxtb	r2, r4
	str	r2, [r3, #2052]
	lsrs	r2, r4, #8
	str	r2, [r3, #2052]
	lsrs	r2, r4, #16
	str	r2, [r3, #2052]
	ldr	r2, .L444+32
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbz	r2, .L432
	lsrs	r4, r4, #24
	str	r4, [r3, #2052]
.L432:
	movs	r3, #208
	add	r5, r5, r8
	str	r3, [r5, #2056]
	bl	nandc_wait_flash_ready
	mov	r0, r10
	bl	flash_read_status
	bl	nandc_de_cs.constprop.33
	ands	r4, r0, #5
	beq	.L433
	ldr	r3, .L444+36
	mov	r0, r7
	ldrh	r1, [r3]
	bl	__aeabi_uidiv
	mov	r3, r4
	mov	r4, #-1
	mov	r2, r0
	mov	r1, r6
	ldr	r0, .L444+40
	bl	printf
.L433:
	mov	r0, r4
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L430:
	bl	zftl_flash_exit_slc_mode
	b	.L431
.L434:
	mov	r0, #-1
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L445:
	.align	2
.L444:
	.word	.LANCHOR32
	.word	.LANCHOR18
	.word	.LANCHOR46
	.word	.LC0
	.word	.LANCHOR30
	.word	.LANCHOR13
	.word	.LANCHOR14
	.word	.LC33
	.word	.LANCHOR31
	.word	.LANCHOR2
	.word	.LC34
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
	ldr	r3, .L452
	push	{r4, r5, r6, r7, r8, lr}
	movs	r5, #0
	ldr	r7, .L452+4
	ldrb	r4, [r3, #13]	@ zero_extendqisi2
	ldrh	r3, [r3, #14]
	smulbb	r4, r4, r3
	uxth	r4, r4
.L448:
	ldr	r3, .L452+8
	ldrb	r2, [r3]	@ zero_extendqisi2
	uxth	r3, r5
	cmp	r2, r3
	bhi	.L451
	movs	r1, #0
	ldr	r0, .L452+12
	pop	{r4, r5, r6, r7, r8, lr}
	b	printf
.L451:
	ldr	r2, .L452+16
	uxth	r3, r5
	movs	r6, #0
	ldrb	r8, [r2, r3]	@ zero_extendqisi2
.L449:
	uxth	r3, r6
	cmp	r4, r3
	bhi	.L450
	adds	r5, r5, #1
	b	.L448
.L450:
	ldrh	r1, [r7]
	mov	r0, r8
	muls	r1, r6, r1
	adds	r6, r6, #1
	bl	flash_erase_block
	b	.L449
.L453:
	.align	2
.L452:
	.word	.LANCHOR33
	.word	.LANCHOR2
	.word	.LANCHOR18
	.word	.LC35
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
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L482
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	ubfx	r10, r0, #24, #2
	ldrb	r5, [r3]	@ zero_extendqisi2
	movs	r3, #1
	rsb	r2, r5, #24
	lsl	r4, r3, r2
	lsl	r5, r3, r5
	ldr	r3, .L482+4
	lsr	r2, r0, r2
	subs	r5, r5, #1
	ands	r5, r5, r2
	subs	r4, r4, #1
	ldrb	r3, [r3]	@ zero_extendqisi2
	uxtb	r5, r5
	and	r7, r4, r0
	ands	r4, r4, r1
	cmp	r3, r5
	bhi	.L455
	mov	r2, #1128
	ldr	r1, .L482+8
	ldr	r0, .L482+12
	bl	printf
.L455:
	ldr	r3, .L482+16
	ldr	fp, .L482+44
	ldrb	r5, [r3, r5]	@ zero_extendqisi2
	ldr	r3, .L482+20
	mov	r0, r5
	ldr	r6, [r3]
	lsl	r8, r5, #8
	bl	nandc_cs
	cmp	r10, #0
	bne	.L456
	mov	r0, r7
	bl	slc_phy_page_address_calc
	mov	r7, r0
	mov	r0, r4
	bl	slc_phy_page_address_calc
	ldr	r3, .L482+24
	mov	r4, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L457
	mov	r0, r5
	bl	zftl_flash_enter_slc_mode
.L457:
	ldr	r2, .L482+28
	uxtb	ip, r7
	lsrs	r0, r7, #8
	ldrb	r3, [r2, #16]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L459
	ldrb	r3, [r2, #8]	@ zero_extendqisi2
	add	r5, r6, r8
	str	r3, [r5, #2056]
	movs	r3, #0
	str	r3, [r5, #2052]
	str	r3, [r5, #2052]
	lsrs	r3, r7, #16
	str	ip, [r5, #2052]
	str	r0, [r5, #2052]
	str	r3, [r5, #2052]
	ldr	r3, .L482+32
	ldrb	r1, [r3]	@ zero_extendqisi2
	cbz	r1, .L460
	lsrs	r7, r7, #24
	str	r7, [r5, #2052]
.L460:
	ldrb	r2, [r2, #9]	@ zero_extendqisi2
	add	r7, r6, r8
	str	r3, [sp, #4]
	str	r2, [r7, #2056]
	bl	nandc_wait_flash_ready
	ldr	r2, [fp]
	ldr	r3, [sp, #4]
	ldrb	r2, [r2, #12]	@ zero_extendqisi2
	cmp	r2, #3
	bne	.L461
	cmp	r10, #0
	beq	.L461
	str	r10, [r7, #2056]
.L461:
	movs	r2, #0
	add	r1, r6, r8
	str	r2, [r1, #2056]
	str	r2, [r5, #2052]
	str	r2, [r5, #2052]
	uxtb	r2, r4
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r2, [r5, #2052]
	lsrs	r2, r4, #8
	str	r2, [r5, #2052]
	lsrs	r2, r4, #16
	str	r2, [r5, #2052]
	cbz	r3, .L462
	lsrs	r4, r4, #24
	str	r4, [r5, #2052]
.L462:
	add	r6, r6, r8
.L481:
	movs	r3, #48
	str	r3, [r6, #2056]
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	nandc_de_cs.constprop.33
.L456:
	ldr	r3, [fp]
	ldrb	r3, [r3, #12]	@ zero_extendqisi2
	cmp	r3, #3
	bne	.L458
	ldr	r3, .L482+36
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L458
	ldr	r3, .L482+40
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L458
	add	r3, r6, r8
	str	r10, [r3, #2056]
	b	.L457
.L458:
	mov	r0, r5
	bl	zftl_flash_exit_slc_mode
	b	.L457
.L459:
	ldr	r1, [fp]
	ldrb	r3, [r1, #7]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L464
	ldrb	r3, [r1, #12]	@ zero_extendqisi2
	cmp	r3, #2
	ittt	eq
	addeq	r3, r6, r8
	moveq	r5, #38
	streq	r5, [r3, #2056]
.L464:
	ldrb	r5, [r2, #8]	@ zero_extendqisi2
	lsrs	r7, r7, #16
	add	r3, r6, r8
	str	r5, [r3, #2056]
	str	ip, [r3, #2052]
	str	r0, [r3, #2052]
	str	r7, [r3, #2052]
	ldrb	r1, [r1, #12]	@ zero_extendqisi2
	cmp	r1, #3
	bne	.L465
	cmp	r10, #0
	beq	.L465
	str	r10, [r3, #2056]
.L465:
	ldrb	r2, [r2, #9]	@ zero_extendqisi2
	add	r6, r6, r8
	str	r2, [r6, #2056]
	uxtb	r2, r4
	str	r2, [r3, #2052]
	lsrs	r2, r4, #8
	lsrs	r4, r4, #16
	str	r2, [r3, #2052]
	str	r4, [r3, #2052]
	b	.L481
.L483:
	.align	2
.L482:
	.word	.LANCHOR32
	.word	.LANCHOR18
	.word	.LANCHOR47
	.word	.LC0
	.word	.LANCHOR30
	.word	.LANCHOR13
	.word	.LANCHOR0
	.word	.LANCHOR20
	.word	.LANCHOR31
	.word	.LANCHOR36
	.word	.LANCHOR37
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
	ldr	r7, .L528
	mov	r10, #0
	ldr	r8, .L528+24
.L498:
	ldrb	r5, [r7, r10, lsl #3]	@ zero_extendqisi2
	cmp	r5, #69
	beq	.L485
	cmp	r5, #44
	beq	.L485
	add	r3, r5, #119
	uxtb	r3, r3
	cmp	r3, #18
	bhi	.L486
	ldr	r2, .L528+4
	lsr	r3, r2, r3
	lsls	r2, r3, #31
	bpl	.L486
.L485:
	ldr	r3, .L528+8
	cmp	r6, #1
	ldr	r4, [r8]
	ldrb	r1, [r3]	@ zero_extendqisi2
	bne	.L487
	lsls	r3, r1, #31
	bpl	.L486
	ldr	r3, .L528+12
	ldr	r3, [r3]
	lsls	r0, r3, #19
	bpl	.L488
	ldr	r0, .L528+16
	bl	printf
.L488:
	lsl	r3, r10, #8
	cmp	r5, #44
	mov	r1, #239
	add	r2, r4, r3
	str	r1, [r2, #2056]
	beq	.L489
	cmp	r5, #137
	bne	.L490
.L489:
	adds	r2, r4, r3
.L527:
	movs	r1, #1
	str	r1, [r2, #2052]
	movs	r1, #5
.L524:
	add	r4, r4, r3
	str	r1, [r2, #2048]
.L526:
	movs	r3, #0
	str	r3, [r4, #2048]
	str	r3, [r4, #2048]
	str	r3, [r4, #2048]
.L486:
	add	r10, r10, #1
	cmp	r10, #4
	bne	.L498
	bl	nandc_wait_flash_ready
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L490:
	cmp	r5, #155
	beq	.L527
	movs	r1, #128
	str	r1, [r2, #2052]
	movs	r1, #1
	b	.L524
.L487:
	lsls	r2, r1, #29
	bpl	.L486
	ldr	r3, .L528+12
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L493
	ldr	r0, .L528+20
	bl	printf
.L493:
	lsl	r2, r10, #8
	cmp	r5, #44
	mov	r1, #239
	add	r3, r4, r2
	str	r1, [r3, #2056]
	beq	.L494
	cmp	r5, #137
	bne	.L495
.L494:
	movs	r1, #1
	adds	r3, r4, r2
	str	r1, [r3, #2052]
	movs	r1, #35
.L525:
	str	r1, [r3, #2048]
	add	r4, r4, r2
	b	.L526
.L495:
	cmp	r5, #155
	itett	eq
	moveq	r1, #1
	movne	r1, #128
	streq	r1, [r3, #2052]
	moveq	r1, #37
	itt	ne
	strne	r1, [r3, #2052]
	movne	r1, #0
	b	.L525
.L529:
	.align	2
.L528:
	.word	.LANCHOR48
	.word	294913
	.word	.LANCHOR49
	.word	.LANCHOR14
	.word	.LC36
	.word	.LC37
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
	ldr	r3, .L531
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
.L532:
	.align	2
.L531:
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
	ldr	r3, .L534
	ldr	r3, [r3]
	add	r0, r3, r0, lsl #8
	movs	r3, #255
	str	r3, [r0, #2056]
	b	nandc_wait_flash_ready
.L535:
	.align	2
.L534:
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
	ldr	r3, .L538
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
	bl	nandc_de_cs.constprop.33
	ldrb	r2, [r4]	@ zero_extendqisi2
	subs	r3, r2, #1
	uxtb	r3, r3
	cmp	r3, #253
	bhi	.L536
	ldrb	r1, [r4, #5]	@ zero_extendqisi2
	ldrb	r3, [r4, #1]	@ zero_extendqisi2
	ldr	r0, .L538+4
	str	r1, [sp, #12]
	ldrb	r1, [r4, #4]	@ zero_extendqisi2
	str	r1, [sp, #8]
	ldrb	r1, [r4, #3]	@ zero_extendqisi2
	str	r1, [sp, #4]
	ldrb	r1, [r4, #2]	@ zero_extendqisi2
	str	r1, [sp]
	adds	r1, r5, #1
	bl	printf
.L536:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, pc}
.L539:
	.align	2
.L538:
	.word	.LANCHOR13
	.word	.LC38
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
	ldr	r3, .L541
	ldr	r2, .L541+4
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
.L542:
	.align	2
.L541:
	.word	.LANCHOR33
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
	ldr	r3, .L546
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
	ldr	r0, .L546+4
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
.L544:
	ldr	r1, [r4, #2048]
	strb	r1, [r2], #1
	cmp	r2, r3
	bne	.L544
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
	b	nandc_de_cs.constprop.33
.L547:
	.align	2
.L546:
	.word	.LANCHOR13
	.word	.LC39
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
	push	{r4, r5, r6, r7, r8, lr}
	mov	r8, r1
	ldr	r3, .L562
	lsls	r6, r0, #8
	ldr	r7, .L562+4
	ldr	r5, [r3]
	ldrb	r3, [r7, #29]	@ zero_extendqisi2
	cbz	r3, .L549
	adds	r2, r5, r6
	str	r3, [r2, #2056]
.L550:
	adds	r4, r5, r6
	movs	r3, #128
	str	r3, [r4, #2056]
	movs	r3, #0
	str	r3, [r4, #2052]
	str	r3, [r4, #2052]
	uxtb	r3, r8
	str	r3, [r4, #2052]
	lsr	r3, r8, #8
	str	r3, [r4, #2052]
	lsr	r3, r8, #16
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
	beq	.L551
	ldr	r3, .L562+8
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L551
	mov	r1, r8
	ldr	r0, .L562+12
	bl	printf
.L551:
	ldrb	r3, [r7, #30]	@ zero_extendqisi2
	cbz	r3, .L548
	add	r5, r5, r6
	str	r3, [r5, #2056]
.L548:
	mov	r0, r4
	pop	{r4, r5, r6, r7, r8, pc}
.L549:
	adds	r3, r5, r6
	movs	r2, #162
	str	r2, [r3, #2056]
	b	.L550
.L563:
	.align	2
.L562:
	.word	.LANCHOR13
	.word	.LANCHOR33
	.word	.LANCHOR14
	.word	.LC40
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
	ldr	r3, .L565
	sub	sp, sp, #8
	ldr	r3, [r3]
	ldr	r3, [r3]
	str	r3, [sp, #4]
	ldr	r0, [sp, #4]
	ubfx	r0, r0, #9, #1
	add	sp, sp, #8
	@ sp needed
	bx	lr
.L566:
	.align	2
.L565:
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
	ldr	r2, .L578
	strb	r0, [r2]
	ldr	r2, .L578+4
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, #9
	ldr	r2, .L578+8
	bne	.L568
	ldr	r2, [r2]
	cmp	r0, #70
	ldr	r1, [sp, #4]
	str	r1, [r2, #16]
	beq	.L569
	cmp	r0, #60
	beq	.L575
	cmp	r0, #40
	ite	eq
	moveq	r3, #2
	movne	r3, #1
.L569:
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
.L567:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, pc}
.L575:
	movs	r3, #3
	b	.L569
.L568:
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
	bne	.L571
.L577:
	ldr	r2, [sp]
	bfi	r2, r3, #4, #1
	str	r2, [sp]
	b	.L572
.L571:
	cmp	r0, #24
	bne	.L573
	ldr	r3, [sp]
	orr	r3, r3, #16
	str	r3, [sp]
.L572:
	ldr	r3, [sp]
	orr	r3, r3, #1
	str	r3, [sp]
	ldr	r3, [sp]
	str	r3, [r1, #12]
	b	.L567
.L573:
	ldr	r2, [sp]
	cmp	r0, #40
	orr	r2, r2, #262144
	str	r2, [sp]
	ldr	r2, [sp]
	orr	r2, r2, #16
	str	r2, [sp]
	bne	.L572
	b	.L577
.L579:
	.align	2
.L578:
	.word	.LANCHOR50
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
	ldr	r3, .L583
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #9
	ite	eq
	ldreq	r0, [r0, #296]
	ldrne	r0, [r0, #372]
	bx	lr
.L584:
	.align	2
.L583:
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
	ldr	r0, .L604
	and	lr, r5, #1
	ldr	r4, .L604+4
	ldrb	r0, [r0]	@ zero_extendqisi2
	ldr	r7, .L604+8
	cmp	r0, #9
	add	r0, r1, #1
	bne	.L589
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
	ldr	r1, .L604+12
	ldrb	r1, [r1]	@ zero_extendqisi2
	cbz	r1, .L590
	ldr	r1, .L604+16
	ldrb	r1, [r1]	@ zero_extendqisi2
	cbz	r1, .L590
	ldr	r1, [sp, #4]
	orr	r1, r1, #512
	str	r1, [sp, #4]
.L590:
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
	ldr	r2, .L604+20
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
.L588:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L589:
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
	beq	.L592
	ldr	r0, .L604+24
	lsrs	r1, r1, #1
	ldr	r8, [r4]
	ldrb	r0, [r0]	@ zero_extendqisi2
	cmp	r0, #25
	mov	r0, r6
	ite	cc
	movcc	lr, #64
	movcs	lr, #128
.L594:
	cmp	r0, r1
	add	fp, r3, r0, lsl #2
	add	r10, lr, r6
	blt	.L595
.L596:
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
	b	.L588
.L595:
	ldrh	ip, [r3, r0, lsl #2]
	bic	r6, r6, #3
	ldrh	fp, [fp, #2]
	adds	r0, r0, #1
	orr	ip, ip, fp, lsl #16
	str	ip, [r8, r6]
	mov	r6, r10
	b	.L594
.L592:
	ldr	r3, [r4]
	str	lr, [r3]
	b	.L596
.L605:
	.align	2
.L604:
	.word	.LANCHOR28
	.word	.LANCHOR53
	.word	.LANCHOR13
	.word	.LANCHOR51
	.word	.LANCHOR52
	.word	.LANCHOR54
	.word	.LANCHOR50
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
	ldr	r2, .L613
	and	r0, r0, #127
	ldr	r3, .L613+4
	ldrb	r2, [r2]	@ zero_extendqisi2
	ldrh	r3, [r3, r0, lsl #1]
	cbz	r2, .L607
	orr	r3, r3, #-1073741824
.L607:
	ldr	r2, .L613+8
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, #9
	ldr	r2, .L613+12
	ldr	r2, [r2]
	ite	eq
	streq	r3, [r2, #520]
	strne	r3, [r2, #336]
	bx	lr
.L614:
	.align	2
.L613:
	.word	.LANCHOR52
	.word	.LANCHOR55
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
	ldr	r3, .L634
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L616
	ldr	r3, .L634+4
	ldrb	r0, [r3]	@ zero_extendqisi2
	cbnz	r0, .L616
	ldr	r3, .L634+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #9
	beq	.L616
	bl	zftl_flash_exit_slc_mode
.L616:
	ldr	r4, .L634+12
	movs	r0, #0
	bl	hynix_reconfig_rr_para
	ldrb	r3, [r4]	@ zero_extendqisi2
	cbz	r3, .L617
	ldr	r3, .L634+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	lsls	r3, r3, #31
	bpl	.L617
	movs	r0, #1
	bl	flash_set_interface_mode
	movs	r0, #1
	bl	nandc_set_if_mode
	movs	r3, #0
	strb	r3, [r4]
.L617:
	ldr	r1, .L634+20
	ldrb	r3, [r1]	@ zero_extendqisi2
	cbz	r3, .L618
	movs	r0, #0
	strb	r0, [r1]
	bl	nandc_set_seed
	movs	r3, #1
	strb	r3, [r1]
.L618:
	movs	r0, #0
	pop	{r4, pc}
.L635:
	.align	2
.L634:
	.word	.LANCHOR0
	.word	.LANCHOR19
	.word	.LANCHOR28
	.word	.LANCHOR21
	.word	.LANCHOR49
	.word	.LANCHOR52
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
	ldr	r3, .L637
	strb	r0, [r3]
	bx	lr
.L638:
	.align	2
.L637:
	.word	.LANCHOR52
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
	ldr	r3, .L640
	adds	r0, r0, #8
	ldr	r3, [r3]
	add	r0, r3, r0, lsl #8
	bx	lr
.L641:
	.align	2
.L640:
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
	ldr	r3, .L645
	movs	r2, #0
	push	{r4, r5, lr}
	mov	r1, r2
	mov	r4, r3
.L643:
	uxtb	r0, r2
	adds	r2, r2, #1
	cmp	r2, #32
	strb	r1, [r3, #2]
	add	r5, r0, #1
	strb	r0, [r3, #1]
	strb	r5, [r3]
	add	r3, r3, #48
	str	r1, [r3, #-40]
	bne	.L643
	movs	r3, #255
	strb	r3, [r4, #1488]
	ldr	r3, .L645+4
	strb	r1, [r3]
	ldr	r3, .L645+8
	strb	r2, [r3]
	pop	{r4, r5, pc}
.L646:
	.align	2
.L645:
	.word	.LANCHOR56
	.word	.LANCHOR57
	.word	.LANCHOR58
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
	bne	.L648
	ldrb	r3, [r1, #1]	@ zero_extendqisi2
	cmp	r3, #255
	bne	.L649
	movs	r2, #74
	ldr	r1, .L654
	ldr	r0, .L654+4
	bl	printf
.L649:
	ldrb	r3, [r4, #1]	@ zero_extendqisi2
	strb	r3, [r5]
	pop	{r4, r5, r6, pc}
.L648:
	ldr	r2, .L654+8
	movs	r1, #48
	mov	r6, r2
.L653:
	mov	r5, r3
	muls	r3, r1, r3
	ldrb	r3, [r2, r3]	@ zero_extendqisi2
	cmp	r3, #255
	bne	.L653
	ldrb	r3, [r4, #1]	@ zero_extendqisi2
	cmp	r3, #255
	bne	.L651
	movs	r2, #81
	ldr	r1, .L654
	ldr	r0, .L654+4
	bl	printf
.L651:
	movs	r3, #48
	ldrb	r2, [r4, #1]	@ zero_extendqisi2
	muls	r3, r5, r3
	strb	r2, [r6, r3]
	pop	{r4, r5, r6, pc}
.L655:
	.align	2
.L654:
	.word	.LANCHOR59
	.word	.LC0
	.word	.LANCHOR56
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
	ldr	r0, .L657
	pop	{r4, lr}
	b	buf_add_tail
.L658:
	.align	2
.L657:
	.word	.LANCHOR60
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
	cbz	r3, .L660
	ldr	r3, [r0, #20]
	adds	r3, r3, #1
	beq	.L660
	ldr	r0, .L668
	bl	buf_add_tail
.L661:
	ldr	r2, .L668+4
	ldrb	r3, [r2]	@ zero_extendqisi2
	adds	r3, r3, #1
	strb	r3, [r2]
	pop	{r3, pc}
.L660:
	ldr	r3, .L668
	ldrb	r2, [r3]	@ zero_extendqisi2
	strb	r2, [r1]
	ldrb	r2, [r1, #1]	@ zero_extendqisi2
	strb	r2, [r3]
	b	.L661
.L669:
	.align	2
.L668:
	.word	.LANCHOR57
	.word	.LANCHOR58
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
	ldr	r4, .L680
	ldrb	r3, [r4]	@ zero_extendqisi2
	cbz	r3, .L671
.L674:
	ldr	r5, .L680+4
	ldr	r2, .L680+8
	ldrb	r6, [r5]	@ zero_extendqisi2
	add	r0, r6, r6, lsl #1
	add	r0, r2, r0, lsl #4
	cbz	r7, .L672
.L673:
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
.L671:
	movs	r2, #121
	ldr	r1, .L680+12
	ldr	r0, .L680+16
	bl	printf
	ldrb	r3, [r4]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L674
.L676:
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, pc}
.L672:
	ldrb	r3, [r4]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L673
	b	.L676
.L681:
	.align	2
.L680:
	.word	.LANCHOR58
	.word	.LANCHOR57
	.word	.LANCHOR56
	.word	.LANCHOR61
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
	bne	.L683
	ldrb	r3, [r1]	@ zero_extendqisi2
	strb	r3, [r0]
.L688:
	movs	r0, #1
	pop	{r4, r5, pc}
.L686:
	mov	r5, r3
	muls	r3, r2, r3
	ldrb	r3, [r0, r3]	@ zero_extendqisi2
	cmp	r4, r3
	bne	.L685
	muls	r2, r5, r2
	ldrb	r3, [r1]	@ zero_extendqisi2
	strb	r3, [r0, r2]
	movs	r3, #255
	strb	r3, [r1]
	b	.L688
.L683:
	ldr	r0, .L689
	movs	r2, #48
.L685:
	cmp	r3, #255
	bne	.L686
	movs	r0, #0
	pop	{r4, r5, pc}
.L690:
	.align	2
.L689:
	.word	.LANCHOR56
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
	ldr	r4, .L696
	ldrb	r3, [r4]	@ zero_extendqisi2
	cbnz	r3, .L692
	movs	r2, #172
	ldr	r1, .L696+4
	ldr	r0, .L696+8
	bl	printf
.L692:
	ldrb	r3, [r4]	@ zero_extendqisi2
	cbz	r3, .L691
	mov	r1, r5
	ldr	r0, .L696+12
	bl	buf_remove_buf
	cmp	r0, #1
	bne	.L691
	ldrb	r3, [r4]	@ zero_extendqisi2
	subs	r3, r3, #1
	strb	r3, [r4]
	ldrb	r3, [r5, #2]	@ zero_extendqisi2
	orr	r3, r3, #1
	strb	r3, [r5, #2]
.L691:
	pop	{r3, r4, r5, pc}
.L697:
	.align	2
.L696:
	.word	.LANCHOR58
	.word	.LANCHOR62
	.word	.LC0
	.word	.LANCHOR57
	.size	buf_remove_free, .-buf_remove_free
	.section	.text.dump_buf_info,"ax",%progbits
	.align	1
	.global	dump_buf_info
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	dump_buf_info, %function
dump_buf_info:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L701
	push	{r4, r5, r6, lr}
	sub	sp, sp, #24
	ldr	r0, .L701+4
	ldrb	r1, [r3]	@ zero_extendqisi2
	bl	printf
	ldr	r3, .L701+8
	ldr	r0, .L701+12
	ldr	r4, .L701+16
	ldrb	r1, [r3]	@ zero_extendqisi2
	bl	printf
	ldr	r3, .L701+20
	add	r5, r4, #1536
	ldr	r0, .L701+24
	ldr	r6, .L701+28
	ldrb	r1, [r3]	@ zero_extendqisi2
	bl	printf
	ldr	r3, .L701+32
	ldr	r0, .L701+36
	ldrb	r1, [r3]	@ zero_extendqisi2
	bl	printf
	ldr	r3, .L701+40
	ldr	r0, .L701+44
	ldrb	r1, [r3]	@ zero_extendqisi2
	bl	printf
	ldr	r3, .L701+48
	ldr	r0, .L701+52
	ldrb	r1, [r3]	@ zero_extendqisi2
	bl	printf
.L699:
	ldr	r0, [r4, #24]
	adds	r4, r4, #48
	ldrb	r3, [r4, #-46]	@ zero_extendqisi2
	ldrb	r2, [r4, #-48]	@ zero_extendqisi2
	str	r0, [sp, #16]
	ldr	r0, [r4, #-28]
	ldrb	r1, [r4, #-47]	@ zero_extendqisi2
	str	r0, [sp, #12]
	ldr	r0, [r4, #-12]
	str	r0, [sp, #8]
	ldrb	r0, [r4, #-6]	@ zero_extendqisi2
	str	r0, [sp, #4]
	ldrh	r0, [r4, #-14]
	str	r0, [sp]
	mov	r0, r6
	bl	printf
	cmp	r4, r5
	bne	.L699
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, pc}
.L702:
	.align	2
.L701:
	.word	.LANCHOR60
	.word	.LC41
	.word	.LANCHOR63
	.word	.LC42
	.word	.LANCHOR56
	.word	.LANCHOR64
	.word	.LC43
	.word	.LC47
	.word	.LANCHOR65
	.word	.LC44
	.word	.LANCHOR57
	.word	.LC45
	.word	.LANCHOR58
	.word	.LC46
	.size	dump_buf_info, .-dump_buf_info
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
	ldr	r2, .L704
	push	{r4, lr}
	lsrs	r4, r1, #5
	and	r1, r1, #31
	ldrb	r3, [r2, #13]	@ zero_extendqisi2
	ldrh	r2, [r2, #14]
	smulbb	r3, r3, r2
	ldr	r2, .L704+4
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
.L705:
	.align	2
.L704:
	.word	.LANCHOR33
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
	ldr	r3, .L707
	mov	r2, r1
	push	{r4, r5, r6, lr}
	mov	r5, r0
	mov	r6, r1
	mov	r1, r0
	ldrb	r4, [r3, #13]	@ zero_extendqisi2
	ldrh	r3, [r3, #14]
	ldr	r0, .L707+4
	smulbb	r4, r4, r3
	bl	printf
	uxth	r4, r4
	ldr	r3, .L707+8
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
.L708:
	.align	2
.L707:
	.word	.LANCHOR33
	.word	.LC48
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
	ldr	r0, .L710
	bl	buf_add_tail
	ldr	r3, .L710+4
	ldrb	r0, [r3]	@ zero_extendqisi2
	adds	r0, r0, #1
	uxtb	r0, r0
	strb	r0, [r3]
	pop	{r3, pc}
.L711:
	.align	2
.L710:
	.word	.LANCHOR66
	.word	.LANCHOR67
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
	cbnz	r0, .L714
	ldr	r3, .L717
	ldr	r0, [r3]
	bx	lr
.L714:
	cmp	r0, #4
	ite	cc
	movcc	r0, #8192
	movcs	r0, #0
	bx	lr
.L718:
	.align	2
.L717:
	.word	.LANCHOR68
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
	.section	.text.ftl_scan_all_data,"ax",%progbits
	.align	1
	.global	ftl_scan_all_data
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_scan_all_data, %function
ftl_scan_all_data:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	bx	lr
	.size	ftl_scan_all_data, .-ftl_scan_all_data
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
	ldr	r3, .L723
	ldrh	r0, [r3]
	bx	lr
.L724:
	.align	2
.L723:
	.word	.LANCHOR69
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
	ldr	r3, .L726
	ldrh	r0, [r3]
	bx	lr
.L727:
	.align	2
.L726:
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
	ldr	r3, .L764
	mov	r5, r0
	mov	r4, r1
	ldr	r2, [r3]
	mov	r10, r3
	tst	r2, #256
	beq	.L730
	ldr	r3, .L764+4
	mov	r2, r1
	mov	r1, r0
	ldrh	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L764+8
	ldrh	r3, [r3, #52]
	str	r3, [sp, #8]
	ldr	r3, .L764+12
	ldr	r3, [r3]
	ldrh	r3, [r3, r0, lsl #1]
	str	r3, [sp, #4]
	ldr	r3, .L764+16
	ldr	r3, [r3]
	add	r3, r3, r0, lsl #2
	ldr	r0, .L764+20
	ldrb	r3, [r3, #2]	@ zero_extendqisi2
	lsrs	r3, r3, #5
	str	r3, [sp]
	mov	r3, r8
	bl	printf
.L730:
	ldr	r6, .L764+24
	ldrh	r2, [r6]
	cmp	r2, r5
	bhi	.L731
	movw	r2, #543
	ldr	r1, .L764+28
	ldr	r0, .L764+32
	bl	printf
.L731:
	ldrh	r3, [r6]
	cmp	r3, r5
	bhi	.L732
	ldr	r0, [r10]
	ands	r0, r0, #1024
	beq	.L729
	mov	r3, r8
	mov	r2, r4
	mov	r1, r5
	ldr	r0, .L764+36
	bl	printf
.L752:
	movs	r0, #0
	b	.L729
.L732:
	ldr	r2, .L764+16
	ldr	r3, .L764+12
	ldr	r2, [r2]
	ldr	r3, [r3]
	add	r2, r2, r5, lsl #2
	ldrh	r3, [r3, r5, lsl #1]
	ldrb	r2, [r2, #2]	@ zero_extendqisi2
	ands	r6, r2, #224
	bne	.L734
	cmp	r3, #0
	beq	.L752
	movw	r2, #553
	ldr	r1, .L764+28
	ldr	r0, .L764+32
	bl	printf
	b	.L752
.L734:
	ldr	r6, .L764+8
	ldrh	r1, [r6]
	cmp	r1, r5
	beq	.L752
	ldr	r7, .L764+40
	ldr	r1, [r7]
	ldrh	r0, [r1, #48]
	cmp	r0, r5
	beq	.L752
	ldrh	r0, [r1, #16]
	cmp	r0, r5
	beq	.L752
	ldrh	r0, [r1, #80]
	cmp	r0, r5
	beq	.L752
	ldrh	ip, [r6, #52]!
	movs	r0, #0
.L735:
	cmp	r0, ip
	bcc	.L736
	cmp	r4, #0
	bne	.L740
	ldr	r0, .L764+44
	ldrh	r6, [r0]
	mov	r0, r4
	cmp	r5, r6
	beq	.L729
	ldr	lr, .L764+56
.L739:
	ldrh	fp, [lr, r0, lsl #1]
	cmp	r5, fp
	bne	.L738
	ldr	r0, [r10]
	ands	r0, r0, #256
	beq	.L729
	stm	sp, {r5, r6}
	lsrs	r2, r2, #5
	mov	r1, r5
	ldr	r0, .L764+48
	bl	printf
	b	.L752
.L736:
	ldrh	lr, [r6, #2]!
	cmp	lr, r5
	beq	.L752
	adds	r0, r0, #1
	b	.L735
.L738:
	adds	r0, r0, #1
	cmp	r0, #8
	bne	.L739
	add	r1, r1, r8, lsl #7
	add	r6, r1, #136
.L741:
	ldr	r1, [r10]
	lsls	r1, r1, #23
	bpl	.L742
	ldr	r1, .L764+4
	ldr	r0, .L764+52
	ldrh	r1, [r1]
	stm	sp, {r3, ip}
	lsrs	r3, r2, #5
	mov	r2, r4
	str	r1, [sp, #8]
	mov	r1, r5
	bl	printf
.L742:
	mov	r3, r6
	add	r1, r6, #128
	movw	r0, #65535
.L745:
	mov	r2, r3
	adds	r3, r3, #2
	ldrh	r6, [r2]
	cmp	r6, r0
	bne	.L743
	strh	r5, [r2]	@ movhi
	cbz	r4, .L744
	ldr	r2, [r7]
	ldrh	r3, [r2, #124]
	adds	r3, r3, #1
	strh	r3, [r2, #124]	@ movhi
.L763:
	movs	r0, #1
.L729:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L740:
	add	r6, r1, #392
	b	.L741
.L744:
	ldr	r3, [r7]
	add	r8, r3, r8, lsl #1
	ldrh	r3, [r8, #120]
	adds	r3, r3, #1
	strh	r3, [r8, #120]	@ movhi
	b	.L763
.L743:
	cmp	r3, r1
	bne	.L745
	b	.L763
.L765:
	.align	2
.L764:
	.word	.LANCHOR14
	.word	.LANCHOR70
	.word	.LANCHOR71
	.word	.LANCHOR9
	.word	.LANCHOR7
	.word	.LC49
	.word	.LANCHOR6
	.word	.LANCHOR72
	.word	.LC0
	.word	.LC50
	.word	.LANCHOR10
	.word	.LANCHOR73
	.word	.LC51
	.word	.LC52
	.word	.LANCHOR74
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
	ldr	r3, .L770
	movs	r6, #1
	ldr	r2, .L770+4
	ldrh	r3, [r3]
	ldr	r8, .L770+16
	lsr	r4, r0, r3
	ldrb	r0, [r2]	@ zero_extendqisi2
	uxth	r5, r4
	rsb	r0, r0, #24
	subs	r0, r0, r3
	ldr	r3, .L770+8
	lsl	r0, r6, r0
	subs	r0, r0, #1
	ldrb	r1, [r3]	@ zero_extendqisi2
	ands	r0, r0, r4
	bl	__aeabi_uidiv
	uxth	r10, r0
	mov	r3, r7
	mov	r2, r5
	ldr	r1, [r8, #2116]
	ldr	r0, .L770+12
	bl	printf
	mov	r1, r6
	movs	r2, #0
	mov	r0, r10
	bl	gc_add_sblk
	ldr	r3, [r8, #2116]
	movs	r1, #0
.L767:
	uxth	r2, r1
	cmp	r3, r2
	bhi	.L769
	cmp	r3, #5
	itttt	ls
	addls	r2, r3, #1
	addwls	r3, r3, #1060
	strls	r2, [r8, #2116]
	strhls	r5, [r8, r3, lsl #1]	@ movhi
	b	.L768
.L769:
	addw	r2, r2, #1060
	adds	r1, r1, #1
	ldrh	r2, [r8, r2, lsl #1]
	cmp	r5, r2
	bne	.L767
.L768:
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L771:
	.align	2
.L770:
	.word	.LANCHOR75
	.word	.LANCHOR32
	.word	.LANCHOR76
	.word	.LC53
	.word	.LANCHOR71
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
	ldr	r3, .L773
	ldr	r3, [r3]
	ldr	r0, [r3, r0, lsl #2]
	bx	lr
.L774:
	.align	2
.L773:
	.word	.LANCHOR77
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
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	ldr	r5, .L802
.L776:
	ldr	r1, .L802+4
	ldrb	r8, [r1]	@ zero_extendqisi2
	cmp	r8, #255
	bne	.L789
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L789:
	movs	r3, #48
	mul	r3, r3, r8
	adds	r2, r5, r3
	ldrb	r3, [r5, r3]	@ zero_extendqisi2
	ldrh	r6, [r2, #32]
	strb	r3, [r1]
	ldr	r1, [r2, #36]
	cbz	r1, .L777
	ldr	r3, .L802+8
	movs	r0, #1
	ldr	r2, [r2, #24]
	strh	r0, [r3, #2108]	@ movhi
	ldr	r0, .L802+12
	str	r2, [r3, #2112]
	bl	printf
	mov	r2, #956
	ldr	r1, .L802+16
	ldr	r0, .L802+20
	bl	printf
.L777:
	ldr	r10, .L802+56
	ldrb	r3, [r10]	@ zero_extendqisi2
	cmp	r3, #3
	bne	.L778
	ldr	r3, .L802+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L778
	ldr	r3, .L802+28
	ldr	r3, [r3]
	ldrb	r4, [r3, #89]	@ zero_extendqisi2
	ldr	r3, .L802+32
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r4
	bhi	.L790
	cmp	r4, #2
	it	cs
	movcs	r4, #2
.L779:
	add	r4, r4, r4, lsl #1
.L780:
	ldr	r3, .L802+36
	movs	r2, #48
	mla	r2, r2, r8, r5
	ldr	r1, [r3]
	mov	r7, r6
	mov	fp, r3
	ldrb	r2, [r2, #1]	@ zero_extendqisi2
	ldrb	r1, [r1, r6]	@ zero_extendqisi2
	cmp	r1, r2
	beq	.L781
	mov	r2, #976
	ldr	r1, .L802+16
	ldr	r0, .L802+20
	str	r3, [sp, #4]
	bl	printf
	ldr	r3, [sp, #4]
.L781:
	movs	r2, #48
	mla	r8, r2, r8, r5
	ldrb	r2, [r8, #45]	@ zero_extendqisi2
	cmp	r2, #3
	beq	.L782
	ldrb	r2, [r10]	@ zero_extendqisi2
	cmp	r2, #3
	bne	.L782
	ldr	r2, .L802+40
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbnz	r2, .L782
	ldr	r2, .L802+24
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbnz	r2, .L782
	ldr	r2, .L802+44
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbnz	r2, .L782
	ldr	r2, .L802+48
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbz	r2, .L783
	ldr	r2, .L802+52
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbnz	r2, .L782
.L783:
	ldr	r2, [r3]
	movs	r3, #0
	movs	r1, #48
	mov	r0, r3
	add	r6, r6, r2
.L784:
	uxth	r2, r3
	cmp	r4, r2
	bls	.L776
	ldrb	r2, [r6, r3]	@ zero_extendqisi2
	adds	r3, r3, #1
	mla	r2, r1, r2, r5
	strb	r0, [r2, #45]
	b	.L784
.L790:
	movs	r4, #1
	b	.L779
.L778:
	ldr	r3, .L802+48
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L791
	ldr	r3, .L802+52
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	ite	eq
	moveq	r4, #1
	movne	r4, #2
	b	.L780
.L791:
	movs	r4, #1
	b	.L780
.L782:
	ldr	r3, .L802+8
	mov	r10, #255
	strh	r6, [r3, #2104]	@ movhi
	mov	r8, r3
	movs	r3, #48
.L785:
	subs	r2, r7, r6
	uxth	r2, r2
	cmp	r4, r2
	bls	.L776
	ldr	r2, [fp]
	movs	r1, #0
	str	r3, [sp, #4]
	ldrb	r0, [r2, r7]	@ zero_extendqisi2
	strb	r10, [r2, r7]
	adds	r7, r7, #1
	mla	r2, r3, r0, r5
	add	r0, r0, r0, lsl #1
	strb	r1, [r2, #45]
	add	r0, r5, r0, lsl #4
	bl	zbuf_free
	ldrb	r2, [r8, #7]	@ zero_extendqisi2
	ldr	r3, [sp, #4]
	subs	r2, r2, #1
	strb	r2, [r8, #7]
	b	.L785
.L803:
	.align	2
.L802:
	.word	.LANCHOR56
	.word	.LANCHOR64
	.word	.LANCHOR71
	.word	.LC54
	.word	.LANCHOR78
	.word	.LC0
	.word	.LANCHOR36
	.word	.LANCHOR10
	.word	.LANCHOR80
	.word	.LANCHOR83
	.word	.LANCHOR84
	.word	.LANCHOR37
	.word	.LANCHOR81
	.word	.LANCHOR82
	.word	.LANCHOR79
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
	ldr	r3, .L813
	push	{r4, r5, r6, r7, lr}
	ldr	r2, [r3]
	ldr	r3, .L813+4
	ldrh	r4, [r2, #124]
	ldrb	r1, [r3]	@ zero_extendqisi2
	cbz	r4, .L805
	add	r3, r2, #392
	movs	r4, #1
.L806:
	add	r6, r3, #128
	movw	r5, #65535
.L810:
	mov	r7, r3
	ldrh	r0, [r3], #2
	cmp	r0, r5
	beq	.L808
	strh	r5, [r7]	@ movhi
	cbz	r4, .L809
	ldrh	r3, [r2, #124]
	subs	r3, r3, #1
	strh	r3, [r2, #124]	@ movhi
	pop	{r4, r5, r6, r7, pc}
.L805:
	add	r3, r1, #60
	ldrh	r3, [r2, r3, lsl #1]
	cbz	r3, .L811
	add	r3, r2, r1, lsl #7
	adds	r3, r3, #136
	b	.L806
.L809:
	add	r2, r2, r1, lsl #1
	ldrh	r3, [r2, #120]
	subs	r3, r3, #1
	strh	r3, [r2, #120]	@ movhi
	pop	{r4, r5, r6, r7, pc}
.L808:
	cmp	r3, r6
	bne	.L810
	pop	{r4, r5, r6, r7, pc}
.L811:
	movw	r0, #65535
	pop	{r4, r5, r6, r7, pc}
.L814:
	.align	2
.L813:
	.word	.LANCHOR10
	.word	.LANCHOR85
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
	ldr	r5, .L829
	ldrb	r0, [r5, #7]	@ zero_extendqisi2
	cbz	r0, .L815
	ldr	r3, .L829+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #1
	bhi	.L822
	ldr	r3, .L829+8
	movs	r7, #48
	ldrh	r4, [r5, #2104]
	ldr	r6, .L829+12
	ldrh	r2, [r3]
	ldr	r3, .L829+16
	add	r1, r4, #24
	ldr	r0, .L829+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	muls	r2, r3, r2
	cmp	r2, r1
	it	cs
	movcs	r2, r1
	ldr	r1, [r6]
.L817:
	cmp	r4, r2
	bcc	.L820
.L822:
	movs	r0, #0
.L815:
	pop	{r3, r4, r5, r6, r7, pc}
.L820:
	ldrb	r3, [r1, r4]	@ zero_extendqisi2
	cmp	r3, #255
	beq	.L818
	mla	ip, r7, r3, r0
	ldrb	ip, [ip, #45]	@ zero_extendqisi2
	cmp	ip, #0
	bne	.L818
	add	r3, r3, r3, lsl #1
	add	r0, r0, r3, lsl #4
	bl	zbuf_free
	ldr	r3, .L829+24
	ldr	r3, [r3]
	lsls	r3, r3, #23
	bpl	.L819
	ldr	r3, [r6]
	mov	r1, r4
	ldr	r0, .L829+28
	ldrb	r2, [r3, r4]	@ zero_extendqisi2
	bl	printf
.L819:
	ldr	r3, [r6]
	movs	r2, #255
	movs	r0, #1
	strb	r2, [r3, r4]
	ldrb	r3, [r5, #7]	@ zero_extendqisi2
	subs	r3, r3, #1
	strb	r3, [r5, #7]
	pop	{r3, r4, r5, r6, r7, pc}
.L818:
	adds	r4, r4, #1
	b	.L817
.L830:
	.align	2
.L829:
	.word	.LANCHOR71
	.word	.LANCHOR58
	.word	.LANCHOR86
	.word	.LANCHOR83
	.word	.LANCHOR80
	.word	.LANCHOR56
	.word	.LANCHOR14
	.word	.LC55
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
	ldr	r4, .L832
	ldr	r0, .L832+4
	ldrh	r4, [r4]
	ldrh	r3, [r0, #2102]
	ldrh	r2, [r0, #2]
	ldrh	r1, [r0]
	str	r4, [sp, #8]
	ldrb	r0, [r0, #7]	@ zero_extendqisi2
	str	r0, [sp, #4]
	ldr	r0, .L832+8
	ldrb	r0, [r0]	@ zero_extendqisi2
	str	r0, [sp]
	ldr	r0, .L832+12
	bl	printf
	add	sp, sp, #16
	@ sp needed
	pop	{r4, pc}
.L833:
	.align	2
.L832:
	.word	.LANCHOR87
	.word	.LANCHOR71
	.word	.LANCHOR58
	.word	.LC56
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
	bne	.L835
	ldr	r3, .L838
	mov	r1, r0
.L837:
	ldr	r0, [r3]
	b	_list_get_gc_head_node.isra.2
.L835:
	cmp	r1, #2
	bne	.L836
	b	zftl_get_gc_node.part.9
.L836:
	mov	r1, r0
	ldr	r3, .L838+4
	b	.L837
.L839:
	.align	2
.L838:
	.word	.LANCHOR88
	.word	.LANCHOR89
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
	ldr	r3, .L951
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #32
	str	r0, [sp, #8]
	mov	r6, r2
	ldr	r0, [r3]
	ldr	r3, [sp, #8]
	str	r1, [sp, #20]
	adds	r3, r3, #60
	ldrh	r3, [r0, r3, lsl #1]
	str	r3, [sp, #16]
	cbz	r3, .L841
	mov	r0, r3
.L840:
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L841:
	ldr	r3, .L951+4
	ldrh	r2, [r3, #52]
	cmp	r2, #1
	bhi	.L843
	ldrh	r4, [sp, #16]
	ldr	r1, .L951+8
	strh	r4, [r1]	@ movhi
	ldr	r1, .L951+12
	strh	r4, [r1]	@ movhi
	ldr	r1, .L951+16
	strh	r4, [r1]	@ movhi
.L843:
	ldr	r1, [sp, #8]
	cmp	r1, #0
	bne	.L844
	ldr	r7, .L951+12
	mov	r8, r1
	mov	r4, r1
.L845:
	uxth	r3, r8
	cmp	r6, r3
	blt	.L850
	ldrh	r10, [r7]
	movs	r1, #3
	mov	r0, r10
	bl	zftl_get_gc_node
	add	r2, r10, #1
	movw	r3, #65535
	uxth	r2, r2
	cmp	r0, r3
	mov	r5, r0
	strh	r2, [r7]	@ movhi
	beq	.L846
	ldr	r3, .L951+20
	ldr	r10, .L951+40
	ldr	r3, [r3]
	tst	r3, #256
	beq	.L847
	ldr	r3, [r10]
	mov	r1, r0
	ldrh	r3, [r3, r0, lsl #1]
	ldr	r0, .L951+24
	bl	printf
.L847:
	ldr	r3, [r10]
	ldrh	r2, [r3, r5, lsl #1]
	ldr	r3, .L951+28
	ldrh	r3, [r3]
	cmp	r2, r3
	bcs	.L846
	movs	r2, #0
	mov	r0, r5
	mov	r1, r2
	bl	gc_add_sblk
	cmp	r0, #0
	beq	.L849
	adds	r4, r4, #1
	uxth	r4, r4
	cmp	r4, r6
	bcc	.L849
.L850:
	ldr	r3, [sp, #20]
	lsls	r0, r3, #30
	bpl	.L852
	ldr	r3, .L951+32
	ldrh	r3, [r3]
	cmp	r3, #32
	bls	.L852
	ldr	r5, .L951+36
	mov	r10, #0
	ldr	r7, .L951+16
.L853:
	uxth	r3, r10
	cmp	r6, r3
	blt	.L857
	ldrh	r8, [r7]
	movs	r1, #5
	mov	r0, r8
	add	r8, r8, #1
	bl	zftl_get_gc_node
	movw	r2, #65535
	strh	r8, [r7]	@ movhi
	cmp	r0, r2
	beq	.L854
	ldr	r2, .L951+40
	ldrh	r3, [r5]
	ldr	r2, [r2]
	ldrh	r2, [r2, r0, lsl #1]
	cmp	r2, r3
	bcs	.L854
	movs	r2, #0
	mov	r1, r2
	bl	gc_add_sblk
	cmp	r0, #0
	beq	.L856
	adds	r4, r4, #1
	uxth	r4, r4
	cmp	r4, r6
	bcc	.L856
.L857:
	cmp	r4, r6
	ldr	r1, .L951+44
	bcs	.L859
	ldr	r3, .L951+48
	ldrh	r1, [r1]
	ldrh	r2, [r5]
	ldrh	r0, [r3]
	ldr	r3, .L951+52
	ldrb	r3, [r3]	@ zero_extendqisi2
	muls	r3, r0, r3
	sub	r3, r3, r1, lsr #2
	cmp	r2, r3
	bge	.L852
	add	r2, r2, r1, lsr #3
	strh	r2, [r5]	@ movhi
.L852:
	ldr	r3, [sp, #20]
	lsls	r1, r3, #31
	bpl	.L860
	uxth	r5, r6
	cmp	r4, r5
	bcs	.L860
	ldr	r10, .L951+8
	movs	r7, #0
	movw	r8, #65535
.L865:
	ldrh	fp, [r10]
	mov	r0, fp
	add	fp, fp, #1
	bl	zftl_get_gc_node.part.9
	cmp	r0, r8
	strh	fp, [r10]	@ movhi
	beq	.L861
	movs	r2, #0
	mov	r1, r2
	bl	gc_add_sblk
	cmp	r0, #0
	beq	.L862
	adds	r4, r4, #1
	uxth	r4, r4
	cmp	r5, r4
	bhi	.L862
.L863:
	ldr	r3, .L951+44
	ldr	r2, .L951+28
	ldrh	r1, [r3]
	ldrh	r3, [r2]
	cmp	r3, r1, lsr #1
	bls	.L860
	sub	r3, r3, r1, lsr #3
	b	.L950
.L846:
	movs	r3, #0
	strh	r3, [r7]	@ movhi
	b	.L850
.L849:
	add	r8, r8, #1
	b	.L845
.L854:
	movs	r3, #0
	strh	r3, [r7]	@ movhi
	b	.L857
.L856:
	add	r10, r10, #1
	b	.L853
.L859:
	ldrh	r3, [r5]
	ldrh	r2, [r1]
	cmp	r3, r2
	itt	hi
	subhi	r3, r3, r2, lsr #3
	strhhi	r3, [r5]	@ movhi
	b	.L852
.L861:
	movs	r3, #0
	strh	r3, [r10]	@ movhi
.L864:
	cmp	r4, r5
	bcs	.L863
	ldr	r2, .L951+28
	ldr	r1, .L951+44
	ldrh	r3, [r2]
	ldrh	r1, [r1]
	cmp	r3, r1
	bcs	.L860
	add	r3, r3, r1, lsr #3
.L950:
	strh	r3, [r2]	@ movhi
.L860:
	ldr	r3, .L951+20
	ldr	r3, [r3]
	lsls	r3, r3, #23
	bpl	.L896
	str	r6, [sp]
	mov	r3, r4
	ldr	r2, [sp, #20]
	ldr	r1, [sp, #8]
	ldr	r0, .L951+56
	bl	printf
.L896:
	mov	r0, r4
	b	.L840
.L862:
	adds	r7, r7, #1
	uxth	r3, r7
	cmp	r5, r3
	bhi	.L865
	b	.L864
.L952:
	.align	2
.L951:
	.word	.LANCHOR10
	.word	.LANCHOR71
	.word	.LANCHOR90
	.word	.LANCHOR91
	.word	.LANCHOR92
	.word	.LANCHOR14
	.word	.LC57
	.word	.LANCHOR70
	.word	.LANCHOR93
	.word	.LANCHOR94
	.word	.LANCHOR9
	.word	.LANCHOR95
	.word	.LANCHOR86
	.word	.LANCHOR80
	.word	.LC58
.L844:
	ldr	r1, .L953
	cmp	r6, #1
	ldr	r4, .L953+4
	ldrb	r1, [r1]	@ zero_extendqisi2
	ldrh	r4, [r4]
	smulbb	r1, r1, r4
	uxth	r1, r1
	str	r1, [sp, #12]
	bne	.L866
	cbz	r2, .L866
	ldrh	r0, [r0, #80]
	movw	r1, #65535
	cmp	r0, r1
	beq	.L899
	ldr	r0, [sp, #12]
	ldrh	r1, [r3, #2102]
	subs	r1, r0, r1
	uxth	r1, r1
	str	r1, [sp, #12]
.L899:
	movs	r6, #8
.L866:
	movs	r5, #0
	strh	r5, [r3, #2106]	@ movhi
	ldr	r3, .L953+8
	strh	r5, [r3]	@ movhi
	ldr	r3, [sp, #20]
	ands	r3, r3, #1
	str	r3, [sp, #24]
	beq	.L900
	ldr	r3, .L953+12
	ldr	r1, .L953+16
	ldrh	r3, [r3]
	ldrh	r1, [r1]
	cmp	r3, r1, lsr #2
	bhi	.L868
	ldr	r1, .L953+20
	ldrh	r1, [r1]
	cmp	r1, r3
	bcs	.L901
.L868:
	cmp	r2, #1
	bls	.L870
.L872:
	movs	r4, #0
.L871:
	ldr	r8, .L953+52
	movs	r5, #0
	ldr	r10, .L953+48
	movs	r7, #64
.L875:
	ldrh	r3, [r8]
	mov	r0, r3
	str	r3, [sp, #28]
	bl	zftl_get_gc_node.part.9
	movw	r2, #65535
	mov	fp, r0
	cmp	r0, r2
	beq	.L873
	ldr	r3, [sp, #28]
	movs	r1, #0
	ldr	r2, [sp, #8]
	adds	r3, r3, #1
	strh	r3, [r8]	@ movhi
	bl	gc_add_sblk
	cmp	r0, #0
	beq	.L874
	ldr	r3, [r10]
	adds	r4, r4, #1
	uxth	r4, r4
	ldrh	r3, [r3, fp, lsl #1]
	cmp	r4, r6
	add	r5, r5, r3
	uxth	r5, r5
	bcs	.L869
	ldr	r3, [sp, #12]
	cmp	r3, r5
	bcc	.L869
	ldr	r3, .L953+20
	ldr	r2, .L953+12
	ldrh	r3, [r3]
	ldrh	r2, [r2]
	cmp	r3, r2, lsl #1
	ble	.L874
.L869:
	ldr	r3, .L953+20
	ldrh	r2, [r3]
	ldr	r3, .L953+16
	ldrh	r3, [r3]
	cmp	r2, r3, lsr #2
	bhi	.L897
	ldr	r3, .L953+12
	ldrh	r3, [r3]
	adds	r3, r3, #8
	cmp	r2, r3
	ble	.L867
.L897:
	ldr	r3, [sp, #12]
	cmp	r3, r5
	bls	.L867
	ldr	r8, .L953+40
	movs	r7, #64
	ldr	r10, .L953+48
.L878:
	ldrh	r3, [r8]
	movs	r1, #3
	mov	r0, r3
	str	r3, [sp, #28]
	bl	zftl_get_gc_node
	movw	r2, #65535
	mov	fp, r0
	cmp	r0, r2
	ldr	r3, [sp, #28]
	beq	.L876
	adds	r3, r3, #1
	ldr	r2, [sp, #8]
	movs	r1, #0
	strh	r3, [r8]	@ movhi
	bl	gc_add_sblk
	cmp	r0, #0
	beq	.L877
	ldr	r3, [r10]
	adds	r4, r4, #1
	uxth	r4, r4
	ldrh	r3, [r3, fp, lsl #1]
	cmp	r4, r6
	add	r5, r5, r3
	uxth	r5, r5
	bcs	.L867
	ldr	r3, [sp, #12]
	cmp	r3, r5
	bcs	.L877
.L867:
	ldr	r3, [sp, #20]
	lsls	r2, r3, #30
	bpl	.L879
	ldr	r3, .L953+24
	ldrh	r3, [r3]
	cmp	r3, #32
	bls	.L879
	ldr	r3, [sp, #12]
	cmp	r5, r3
	bcs	.L879
	ldr	r8, .L953+56
	mov	fp, #64
.L885:
	ldrh	r10, [r8]
	movs	r1, #5
	mov	r0, r10
	bl	zftl_get_gc_node
	movw	r3, #65535
	mov	r7, r0
	cmp	r0, r3
	beq	.L880
	cmp	r6, #1
	add	r0, r10, #1
	strh	r0, [r8]	@ movhi
	bne	.L881
	ldr	r3, .L953
	ldr	r2, .L953+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldrh	r2, [r2]
	smulbb	r3, r3, r2
	ldr	r2, .L953+28
	ldrh	r2, [r2]
	sub	r3, r3, r2, lsr #3
	ldr	r2, .L953+32
	strh	r3, [r2]	@ movhi
.L881:
	ldr	r10, .L953+48
	ldr	r3, [r10]
	ldrh	r2, [r3, r7, lsl #1]
	ldr	r3, .L953+32
	ldrh	r3, [r3]
	cmp	r2, r3
	bcs	.L882
	ldr	r2, [sp, #8]
	movs	r1, #0
	mov	r0, r7
	bl	gc_add_sblk
	cmp	r0, #0
	beq	.L883
	ldr	r0, [sp, #16]
	adds	r4, r4, #1
	uxth	r4, r4
	adds	r0, r0, #1
	cmp	r4, r6
	uxth	r3, r0
	str	r3, [sp, #16]
	ldr	r3, [r10]
	ldrh	r3, [r3, r7, lsl #1]
	add	r5, r5, r3
	uxth	r5, r5
	bcs	.L884
	ldr	r3, [sp, #12]
	cmp	r3, r5
	bcs	.L883
.L884:
	cmp	r4, r6
	ldr	r0, .L953+28
	ldr	r2, .L953+32
	bcc	.L886
	ldr	r3, [sp, #16]
	cmp	r3, #0
	bne	.L887
	ldr	r3, .L953+24
	ldrh	r1, [r3]
	ldr	r3, .L953+36
	ldrh	r3, [r3]
	cmp	r1, r3
	bls	.L887
.L886:
	ldrh	r3, [r0]
	ldrh	r1, [r2]
	lsrs	r0, r3, #3
	ldr	r3, .L953+4
	ldrh	r7, [r3]
	ldr	r3, .L953
	ldrb	r3, [r3]	@ zero_extendqisi2
	muls	r3, r7, r3
	subs	r3, r3, r0
	cmp	r1, r3
	bge	.L879
	adds	r3, r1, r0
	strh	r3, [r2]	@ movhi
.L879:
	ldr	r3, [sp, #24]
	cmp	r3, #0
	beq	.L860
	uxth	fp, r6
	cmp	r4, fp
	bcs	.L860
	ldr	r3, [sp, #12]
	cmp	r5, r3
	bcs	.L860
	ldr	r3, .L953+40
	mov	r8, #64
	ldr	r7, .L953+44
.L895:
	ldrh	r2, [r3]
	movs	r1, #3
	str	r3, [sp, #24]
	mov	r0, r2
	str	r2, [sp, #16]
	bl	zftl_get_gc_node
	movw	r1, #65535
	mov	r10, r0
	cmp	r0, r1
	ldr	r2, [sp, #16]
	ldr	r3, [sp, #24]
	beq	.L889
	adds	r2, r2, #1
	strh	r2, [r3]	@ movhi
	ldr	r2, .L953+48
	ldr	r2, [r2]
	ldrh	r1, [r2, r0, lsl #1]
	ldrh	r2, [r7]
	cmp	r1, r2
	bcs	.L890
	ldr	r2, .L953+16
	ldrh	r1, [r2]
	ldr	r2, .L953+20
	ldrh	r2, [r2]
	cmp	r2, r1, lsr #1
	bls	.L891
.L890:
	ldr	r2, [sp, #8]
	movs	r1, #0
	mov	r0, r10
	str	r3, [sp, #16]
	bl	gc_add_sblk
	ldr	r3, [sp, #16]
	cmp	r0, #0
	beq	.L892
	ldr	r2, .L953+48
	adds	r4, r4, #1
	uxth	r4, r4
	ldr	r2, [r2]
	cmp	fp, r4
	ldrh	r2, [r2, r10, lsl #1]
	add	r5, r5, r2
	uxth	r5, r5
	bls	.L893
	ldr	r2, [sp, #12]
	cmp	r2, r5
	bcs	.L892
.L894:
	ldr	r3, .L953+28
	ldrh	r2, [r3]
	ldrh	r3, [r7]
	cmp	r3, r2, lsr #1
	bls	.L860
	sub	r3, r3, r2, lsr #3
	strh	r3, [r7]	@ movhi
	b	.L860
.L954:
	.align	2
.L953:
	.word	.LANCHOR80
	.word	.LANCHOR86
	.word	.LANCHOR96
	.word	.LANCHOR97
	.word	.LANCHOR98
	.word	.LANCHOR99
	.word	.LANCHOR93
	.word	.LANCHOR95
	.word	.LANCHOR100
	.word	.LANCHOR101
	.word	.LANCHOR91
	.word	.LANCHOR102
	.word	.LANCHOR9
	.word	.LANCHOR90
	.word	.LANCHOR92
.L870:
	ldr	r4, .L955
	lsrs	r3, r3, #2
	movs	r0, #0
	strh	r3, [r4]	@ movhi
	bl	zftl_get_gc_node.part.9
	movw	r2, #65535
	cmp	r0, r2
	beq	.L872
	ldr	r2, .L955+4
	ldr	r1, [r2]
	ldr	r2, .L955+8
	ldrh	r3, [r1, r0, lsl #1]
	ldrh	r2, [r2]
	cmp	r3, r2, lsr #2
	bcs	.L872
	movs	r3, #1
	ldr	r2, [sp, #8]
	movs	r1, #0
	strh	r3, [r4]	@ movhi
	bl	gc_add_sblk
	adds	r4, r0, #0
	it	ne
	movne	r4, #1
	b	.L871
.L873:
	movs	r3, #0
	strh	r3, [r8]	@ movhi
	b	.L869
.L874:
	subs	r7, r7, #1
	uxth	r7, r7
	cmp	r7, #0
	bne	.L875
	b	.L869
.L876:
	cmp	r3, #64
	bls	.L867
	movs	r3, #0
	strh	r3, [r8]	@ movhi
	b	.L867
.L877:
	subs	r7, r7, #1
	uxth	r7, r7
	cmp	r7, #0
	bne	.L878
	b	.L867
.L900:
	ldr	r5, [sp, #24]
	mov	r4, r5
	b	.L867
.L882:
	ldr	r3, .L955+12
	movs	r2, #0
	strh	r2, [r3]	@ movhi
	b	.L884
.L880:
	movs	r3, #0
	strh	r3, [r8]	@ movhi
	b	.L884
.L883:
	add	fp, fp, #-1
	uxth	fp, fp
	cmp	fp, #0
	bne	.L885
	b	.L884
.L887:
	ldr	r1, .L955+16
	ldrh	r0, [r0]
	ldrh	r3, [r2]
	ldrb	r1, [r1]	@ zero_extendqisi2
	muls	r1, r0, r1
	cmp	r3, r1
	ble	.L860
	sub	r3, r3, r0, lsr #3
	b	.L950
.L889:
	cmp	r2, #64
	bls	.L891
	movs	r2, #0
	strh	r2, [r3]	@ movhi
.L891:
	cmp	r4, fp
	bcc	.L894
.L893:
	ldr	r3, .L955+8
	ldrh	r2, [r7]
	ldrh	r1, [r3]
	ldr	r3, .L955+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	muls	r3, r1, r3
	subs	r3, r3, #32
	cmp	r2, r3
	itt	lt
	addlt	r2, r2, r1, lsr #3
	strhlt	r2, [r7]	@ movhi
	b	.L860
.L892:
	add	r8, r8, #-1
	uxth	r8, r8
	cmp	r8, #0
	bne	.L895
	b	.L891
.L901:
	mov	r4, r5
	b	.L869
.L956:
	.align	2
.L955:
	.word	.LANCHOR90
	.word	.LANCHOR9
	.word	.LANCHOR95
	.word	.LANCHOR92
	.word	.LANCHOR80
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
	ldr	r3, .L961
	mov	r1, r0
	ldr	r3, [r3]
	add	r3, r3, r0, lsl #2
	ldrb	r3, [r3, #2]	@ zero_extendqisi2
	ands	r3, r3, #24
	bne	.L958
	ldr	r2, .L961+4
	ldr	r0, .L961+8
.L960:
	b	_insert_free_list
.L958:
	cmp	r3, #16
	ittee	eq
	ldreq	r2, .L961+12
	ldreq	r0, .L961+16
	ldrne	r2, .L961+20
	ldrne	r0, .L961+24
	b	.L960
.L962:
	.align	2
.L961:
	.word	.LANCHOR7
	.word	.LANCHOR103
	.word	.LANCHOR104
	.word	.LANCHOR105
	.word	.LANCHOR106
	.word	.LANCHOR107
	.word	.LANCHOR108
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
	ldr	r3, .L968
	mov	r1, r0
	ldr	r3, [r3]
	add	r3, r3, r0, lsl #2
	ldrb	r3, [r3, #2]	@ zero_extendqisi2
	and	r3, r3, #224
	cmp	r3, #64
	bne	.L964
	ldr	r2, .L968+4
	ldr	r0, .L968+8
.L967:
	b	_insert_data_list
.L964:
	cmp	r3, #96
	bne	.L965
	ldr	r2, .L968+12
	ldr	r0, .L968+16
	b	.L967
.L965:
	cmp	r3, #160
	bne	.L963
	ldr	r2, .L968+20
	ldr	r0, .L968+24
	b	.L967
.L963:
	bx	lr
.L969:
	.align	2
.L968:
	.word	.LANCHOR7
	.word	.LANCHOR97
	.word	.LANCHOR12
	.word	.LANCHOR99
	.word	.LANCHOR89
	.word	.LANCHOR93
	.word	.LANCHOR88
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
	movw	r5, #65535
	ldr	r8, .L991+48
	mov	r4, r0
	mov	r6, r1
	ldr	r3, [r8]
	ldrh	r7, [r3, #588]
	cmp	r7, r5
	beq	.L971
	cbnz	r0, .L971
	mov	r1, r7
	ldr	r0, .L991
	bl	printf
	ldr	r3, [r8]
	strh	r5, [r3, #588]	@ movhi
.L972:
	mov	r0, r7
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L971:
	ldr	r3, .L991+4
	ldr	r5, .L991+8
	ldrh	r1, [r3]
	ldrh	r3, [r5]
	cmp	r1, r3
	bcc	.L973
	ldr	r2, .L991+12
	ldrh	r2, [r2]
	cmp	r2, r1
	bls	.L974
	cmp	r3, #0
	beq	.L974
.L973:
	cmp	r4, #0
	bne	.L975
	lsrs	r1, r3, #2
.L976:
	ldr	r2, .L991+8
	ldr	r0, .L991+16
.L990:
	bl	_list_pop_index_node
	uxth	r7, r0
	movw	r3, #65535
	cmp	r7, r3
	bne	.L979
	ldrh	r3, [r5]
	mov	r2, r6
	mov	r1, r7
	ldr	r0, .L991+20
	str	r3, [sp, #4]
	ldr	r3, .L991+12
	ldrh	r3, [r3]
	str	r3, [sp]
	ldr	r3, .L991+24
	ldr	r3, [r3]
	bl	printf
.L979:
	cmp	r4, #0
	beq	.L972
	ldr	r3, .L991+28
	ldr	r3, [r3]
	lsls	r3, r3, #23
	bpl	.L972
	ldr	r3, .L991+32
	ldr	r1, .L991+36
	ldr	r0, .L991+40
	ldr	r3, [r3]
	ldr	r1, [r1]
	ldrh	r1, [r1, r7, lsl #1]
	add	r2, r3, r7, lsl #2
	ldrb	r2, [r2, #2]	@ zero_extendqisi2
	str	r1, [sp, #8]
	ldrh	r1, [r3, r7, lsl #2]
	ubfx	r1, r1, #0, #11
	str	r1, [sp, #4]
	mov	r1, r7
	ldr	r3, [r3, r7, lsl #2]
	ubfx	r3, r3, #11, #8
	str	r3, [sp]
	ubfx	r3, r2, #3, #2
	lsrs	r2, r2, #5
	bl	printf
	b	.L972
.L975:
	rsb	r1, r1, r1, lsl #3
	ubfx	r1, r1, #3, #16
	b	.L976
.L974:
	cbz	r4, .L980
	lsrs	r1, r1, #3
.L978:
	ldr	r2, .L991+4
	ldr	r0, .L991+44
	b	.L990
.L980:
	mov	r1, r4
	b	.L978
.L992:
	.align	2
.L991:
	.word	.LC59
	.word	.LANCHOR105
	.word	.LANCHOR107
	.word	.LANCHOR103
	.word	.LANCHOR108
	.word	.LC60
	.word	.LANCHOR104
	.word	.LANCHOR14
	.word	.LANCHOR7
	.word	.LANCHOR9
	.word	.LC61
	.word	.LANCHOR106
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
	bne	.L994
	ldr	r3, .L1015
	ldr	r2, .L1015+4
	ldrh	r3, [r3]
	ldrh	r1, [r2]
	cmp	r3, r1
	bcc	.L995
	ldr	r2, .L1015+8
	ldrh	r2, [r2]
	cmp	r2, r3
	bls	.L996
	cbz	r1, .L996
.L995:
	ldr	r2, .L1015+4
	lsrs	r1, r1, #1
.L1014:
	ldr	r0, .L1015+12
	b	.L1013
.L996:
	ldr	r2, .L1015
	movs	r1, #0
	ldr	r0, .L1015+16
.L1013:
	bl	_list_pop_index_node
	uxth	r4, r0
	movw	r3, #65535
	cmp	r4, r3
	bne	.L999
	ldr	r3, .L1015+4
	mov	r2, r5
	mov	r1, r4
	ldr	r0, .L1015+20
	ldrh	r3, [r3]
	str	r3, [sp, #4]
	ldr	r3, .L1015+8
	ldrh	r3, [r3]
	str	r3, [sp]
	ldr	r3, .L1015+24
	ldr	r3, [r3]
	bl	printf
	b	.L999
.L994:
	ldr	r7, .L1015+28
	movw	r6, #65535
	ldr	r3, [r7]
	ldrh	r4, [r3, #590]
	cmp	r4, r6
	beq	.L998
	cmp	r1, #1
	beq	.L998
	mov	r1, r4
	ldr	r0, .L1015+32
	bl	printf
	ldr	r3, [r7]
	strh	r6, [r3, #590]	@ movhi
.L999:
	mov	r0, r4
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, pc}
.L998:
	ldr	r3, .L1015+8
	ldr	r2, .L1015+4
	ldrh	r3, [r3]
	ldrh	r2, [r2]
	cmp	r3, r2
	bcc	.L1000
	ldr	r1, .L1015
	ldrh	r1, [r1]
	cmp	r1, r3
	bls	.L1001
	cbz	r2, .L1001
.L1000:
	cmp	r5, #1
	it	eq
	lsreq	r0, r2, #1
	ldr	r2, .L1015+4
	mov	r1, r0
	b	.L1014
.L1001:
	cmp	r5, #1
	ldr	r2, .L1015+8
	it	eq
	lsreq	r0, r3, #1
	mov	r1, r0
	ldr	r0, .L1015+24
	b	.L1013
.L1016:
	.align	2
.L1015:
	.word	.LANCHOR105
	.word	.LANCHOR107
	.word	.LANCHOR103
	.word	.LANCHOR108
	.word	.LANCHOR106
	.word	.LC60
	.word	.LANCHOR104
	.word	.LANCHOR10
	.word	.LC62
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
	ldr	r3, .L1022
	mov	r1, r0
	ldr	r3, [r3]
	add	r3, r3, r0, lsl #2
	ldrb	r3, [r3, #2]	@ zero_extendqisi2
	and	r3, r3, #224
	cmp	r3, #64
	bne	.L1018
	ldr	r2, .L1022+4
	ldr	r0, .L1022+8
.L1021:
	b	_list_remove_node
.L1018:
	cmp	r3, #96
	bne	.L1019
	ldr	r2, .L1022+12
	ldr	r0, .L1022+16
	b	.L1021
.L1019:
	cmp	r3, #160
	bne	.L1017
	ldr	r2, .L1022+20
	ldr	r0, .L1022+24
	b	.L1021
.L1017:
	bx	lr
.L1023:
	.align	2
.L1022:
	.word	.LANCHOR7
	.word	.LANCHOR97
	.word	.LANCHOR12
	.word	.LANCHOR99
	.word	.LANCHOR89
	.word	.LANCHOR93
	.word	.LANCHOR88
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
	ldr	r3, .L1028
	mov	r1, r0
	ldr	r3, [r3]
	add	r3, r3, r0, lsl #2
	ldrb	r3, [r3, #2]	@ zero_extendqisi2
	ands	r3, r3, #24
	bne	.L1025
	ldr	r2, .L1028+4
	ldr	r0, .L1028+8
.L1027:
	b	_list_remove_node
.L1025:
	cmp	r3, #16
	ittee	eq
	ldreq	r2, .L1028+12
	ldreq	r0, .L1028+16
	ldrne	r2, .L1028+20
	ldrne	r0, .L1028+24
	b	.L1027
.L1029:
	.align	2
.L1028:
	.word	.LANCHOR7
	.word	.LANCHOR103
	.word	.LANCHOR104
	.word	.LANCHOR105
	.word	.LANCHOR106
	.word	.LANCHOR107
	.word	.LANCHOR108
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
	ldr	r3, .L1035
	mov	r1, r0
	ldr	r3, [r3]
	add	r3, r3, r0, lsl #2
	ldrb	r3, [r3, #2]	@ zero_extendqisi2
	and	r3, r3, #224
	cmp	r3, #64
	bne	.L1031
	ldr	r2, .L1035+4
	ldr	r0, .L1035+8
.L1034:
	b	_list_update_data_list
.L1031:
	cmp	r3, #96
	bne	.L1032
	ldr	r2, .L1035+12
	ldr	r0, .L1035+16
	b	.L1034
.L1032:
	cmp	r3, #160
	bne	.L1030
	ldr	r2, .L1035+20
	ldr	r0, .L1035+24
	b	.L1034
.L1030:
	bx	lr
.L1036:
	.align	2
.L1035:
	.word	.LANCHOR7
	.word	.LANCHOR97
	.word	.LANCHOR12
	.word	.LANCHOR99
	.word	.LANCHOR89
	.word	.LANCHOR93
	.word	.LANCHOR88
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
	ldr	r0, .L1041
	bl	printf
	ldr	r4, [r4]
	cmp	r4, #0
	beq	.L1037
	ldr	r6, .L1041+4
	movs	r5, #0
	ldr	r7, .L1041+8
.L1040:
	ldr	r2, [r6]
	ldr	r0, .L1041+12
	ldr	r3, .L1041+16
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
	ldr	r0, .L1041+20
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
	beq	.L1037
	ldr	r3, [r6]
	movs	r2, #6
	adds	r5, r5, #1
	uxth	r5, r5
	mla	r4, r2, r4, r3
	ldr	r3, .L1041+24
	ldrh	r3, [r3]
	cmp	r3, r5
	bcs	.L1040
.L1037:
	add	sp, sp, #36
	@ sp needed
	pop	{r4, r5, r6, r7, pc}
.L1042:
	.align	2
.L1041:
	.word	.LC63
	.word	.LANCHOR4
	.word	-1431655765
	.word	.LANCHOR9
	.word	.LANCHOR7
	.word	.LC64
	.word	.LANCHOR109
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
	ldr	r1, .L1044
	ldr	r0, .L1044+4
	bl	print_list_info
	ldr	r1, .L1044+8
	ldr	r0, .L1044+12
	bl	print_list_info
	ldr	r1, .L1044+16
	ldr	r0, .L1044+20
	bl	print_list_info
	ldr	r1, .L1044+24
	ldr	r0, .L1044+28
	bl	print_list_info
	ldr	r1, .L1044+32
	ldr	r0, .L1044+36
	bl	print_list_info
	ldr	r1, .L1044+40
	ldr	r0, .L1044+44
	pop	{r3, lr}
	b	print_list_info
.L1045:
	.align	2
.L1044:
	.word	.LANCHOR103
	.word	.LANCHOR104
	.word	.LANCHOR105
	.word	.LANCHOR106
	.word	.LANCHOR107
	.word	.LANCHOR108
	.word	.LANCHOR97
	.word	.LANCHOR12
	.word	.LANCHOR99
	.word	.LANCHOR89
	.word	.LANCHOR93
	.word	.LANCHOR88
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
	ldr	r3, .L1051
	ldr	r3, [r3]
	ldr	r2, [r3, #16]
	cmp	r2, #2048
	bls	.L1047
	ldr	r1, [r3, #20]
	add	r1, r1, r2, lsr #11
	ubfx	r2, r2, #0, #11
	str	r2, [r3, #16]
	str	r1, [r3, #20]
.L1047:
	ldr	r2, [r3, #24]
	cmp	r2, #2048
	bls	.L1048
	ldr	r1, [r3, #28]
	add	r1, r1, r2, lsr #11
	ubfx	r2, r2, #0, #11
	str	r2, [r3, #24]
	str	r1, [r3, #28]
.L1048:
	ldr	r2, [r3, #32]
	cmp	r2, #1024
	bls	.L1049
	ldr	r1, [r3, #36]
	add	r1, r1, r2, lsr #10
	ubfx	r2, r2, #0, #10
	str	r2, [r3, #32]
	str	r1, [r3, #36]
.L1049:
	ldr	r2, [r3, #40]
	cmp	r2, #1024
	bls	.L1046
	ldr	r1, [r3, #44]
	add	r1, r1, r2, lsr #10
	ubfx	r2, r2, #0, #10
	str	r2, [r3, #40]
	str	r1, [r3, #44]
.L1046:
	bx	lr
.L1052:
	.align	2
.L1051:
	.word	.LANCHOR110
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
	ldr	r3, .L1062
	mov	r8, r1
	mov	r5, r4
	ldr	r2, .L1062+4
	ldr	r3, [r3]
	ldrb	r10, [r2]	@ zero_extendqisi2
	ldr	r2, .L1062+8
	add	r3, r3, r0, lsl #2
	ldrb	r3, [r3, #3]	@ zero_extendqisi2
	uxth	r7, r10
	ldrb	fp, [r2]	@ zero_extendqisi2
	smulbb	r0, r0, r7
	ldr	r2, .L1062+12
	str	r3, [sp, #4]
	subs	r7, r7, #1
	ldr	r3, .L1062+16
	sxth	r7, r7
	uxth	r6, r0
	rsb	fp, fp, #24
	ldrb	r3, [r3]	@ zero_extendqisi2
.L1054:
	cmp	r5, r3
	blt	.L1058
	mov	r2, r4
	movw	r1, #65535
.L1059:
	cmp	r2, r3
	blt	.L1060
	mov	r0, r4
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1058:
	ldr	r1, [sp, #4]
	asrs	r1, r1, r5
	lsls	r1, r1, #31
	bmi	.L1055
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
.L1055:
	adds	r5, r5, #1
	b	.L1054
.L1060:
	strh	r1, [r8, r2, lsl #1]	@ movhi
	adds	r2, r2, #1
	b	.L1059
.L1063:
	.align	2
.L1062:
	.word	.LANCHOR7
	.word	.LANCHOR76
	.word	.LANCHOR32
	.word	.LANCHOR75
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
	ldr	r3, .L1069
	ldr	r7, .L1069+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	rsb	r4, r3, #24
	ldr	r3, .L1069+8
	ldrh	r3, [r3]
	subs	r3, r4, r3
	movs	r4, #1
	asr	r6, r0, r3
	lsls	r4, r4, r3
	ldr	r3, .L1069+12
	subs	r4, r4, #1
	uxtb	r6, r6
	ands	r4, r4, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	sxth	r4, r4
	cbz	r3, .L1065
	ldr	r3, .L1069+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L1065
	ldrh	r2, [r7]
	clz	r1, r1
	lsrs	r1, r1, #5
	mov	r0, r6
	muls	r2, r4, r2
	bl	flash_erase_block_en
.L1065:
	ldrh	r2, [r7]
	uxtb	r1, r5
	mov	r0, r6
	muls	r2, r4, r2
	pop	{r3, r4, r5, r6, r7, lr}
	b	flash_erase_block_en
.L1070:
	.align	2
.L1069:
	.word	.LANCHOR32
	.word	.LANCHOR111
	.word	.LANCHOR75
	.word	.LANCHOR81
	.word	.LANCHOR82
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
	ldr	r2, .L1095
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
.L1072:
	ldr	r3, .L1095+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r5, r3
	bge	.L1083
	ldr	r3, .L1095+8
	movs	r4, #0
	ldrb	r2, [r3]	@ zero_extendqisi2
	ldr	r3, .L1095+12
	add	ip, r2, #-1
	ldrh	r0, [r3]
	mul	r10, r2, r5
	mov	r3, r4
	mul	lr, r2, r6
	b	.L1084
.L1074:
	ldr	r1, [sp, #4]
	add	fp, r3, r10
	asr	r1, r1, fp
	lsls	r1, r1, #31
	bmi	.L1073
	add	r1, sp, #72
	add	fp, r1, r4, lsl #2
	and	r1, r3, ip
	add	r1, r1, lr
	muls	r1, r0, r1
	adds	r4, r4, #1
	str	r1, [fp, #-64]
.L1073:
	adds	r3, r3, #1
.L1084:
	cmp	r3, r2
	blt	.L1074
	cmp	r2, #4
	bne	.L1075
	uxtb	fp, r7
	mov	r10, #0
.L1076:
	cmp	r10, r4
	bne	.L1077
.L1078:
	adds	r5, r5, #1
	b	.L1072
.L1077:
	add	r3, sp, #8
	mov	r1, fp
	ldr	r2, [r3, r10, lsl #2]
	uxtb	r0, r5
	add	r10, r10, #1
	bl	flash_erase_block_en
	b	.L1076
.L1075:
	cmp	r4, #2
	bne	.L1079
	ldr	r3, .L1095+16
	uxtb	r4, r5
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1080
	ldr	r3, .L1095+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L1080
	clz	r1, r7
	ldr	r3, [sp, #12]
	ldr	r2, [sp, #8]
	lsrs	r1, r1, #5
	mov	r0, r4
	bl	flash_erase_duplane_block
.L1080:
	ldr	r3, [sp, #12]
	uxtb	r1, r7
	ldr	r2, [sp, #8]
	mov	r0, r4
	bl	flash_erase_duplane_block
	b	.L1078
.L1079:
	cmp	r4, #1
	bne	.L1078
	ldr	r3, .L1095+16
	uxtb	r4, r5
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1082
	ldr	r3, .L1095+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L1082
	clz	r1, r7
	ldr	r2, [sp, #8]
	lsrs	r1, r1, #5
	mov	r0, r4
	bl	flash_erase_block_en
.L1082:
	ldr	r2, [sp, #8]
	uxtb	r1, r7
	mov	r0, r4
	bl	flash_erase_block_en
	b	.L1078
.L1083:
	ldr	r1, .L1095+24
	ldr	r0, [r8]
	cbnz	r7, .L1085
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
	bge	.L1087
	strh	r3, [r2, #96]	@ movhi
.L1087:
	movs	r0, #0
	add	sp, sp, #72
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1085:
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
	b	.L1087
.L1096:
	.align	2
.L1095:
	.word	.LANCHOR7
	.word	.LANCHOR112
	.word	.LANCHOR76
	.word	.LANCHOR111
	.word	.LANCHOR81
	.word	.LANCHOR82
	.word	.LANCHOR110
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
	ldr	r4, .L1106
	ldr	r2, [r4]
	ldrh	r1, [r2, #136]
	cmp	r1, #63
	itt	hi
	movhi	r3, #0
	strhhi	r3, [r2, #136]	@ movhi
	ldrh	r3, [r2, #112]
	cbnz	r3, .L1099
	movw	r2, #1283
	ldr	r1, .L1106+4
	ldr	r0, .L1106+8
	bl	printf
.L1099:
	ldr	r3, [r4]
	movw	r4, #65535
	mov	r6, r4
	movs	r5, #0
.L1103:
	ldrh	r2, [r3, #136]
	add	r1, r3, r2, lsl #1
	adds	r1, r1, #158
.L1100:
	cmp	r2, #63
	ble	.L1102
	strh	r5, [r3, #136]	@ movhi
	b	.L1103
.L1102:
	ldrh	r0, [r1, #2]!
	cmp	r0, r4
	bne	.L1105
	adds	r2, r2, #1
	b	.L1100
.L1105:
	add	r1, r2, #80
	strh	r6, [r3, r1, lsl #1]	@ movhi
	strh	r2, [r3, #136]	@ movhi
	ldrh	r2, [r3, #112]
	subs	r2, r2, #1
	strh	r2, [r3, #112]	@ movhi
	pop	{r4, r5, r6, pc}
.L1107:
	.align	2
.L1106:
	.word	.LANCHOR110
	.word	.LANCHOR113
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
	ldr	r4, .L1116
	ldr	r2, [r4]
	ldrh	r1, [r2, #138]
	cmp	r1, #63
	itt	hi
	movhi	r3, #0
	strhhi	r3, [r2, #138]	@ movhi
	ldrh	r3, [r2, #112]
	cmp	r3, #63
	bls	.L1110
	movw	r2, #1310
	ldr	r1, .L1116+4
	ldr	r0, .L1116+8
	bl	printf
.L1110:
	ldr	r3, [r4]
	movs	r0, #0
	movw	r4, #65535
.L1114:
	ldrh	r2, [r3, #138]
	add	r1, r3, r2, lsl #1
	adds	r1, r1, #158
.L1111:
	cmp	r2, #63
	ble	.L1113
	strh	r0, [r3, #138]	@ movhi
	b	.L1114
.L1113:
	ldrh	r6, [r1, #2]!
	cmp	r6, r4
	bne	.L1112
	add	r1, r2, #80
	strh	r5, [r3, r1, lsl #1]	@ movhi
	strh	r2, [r3, #138]	@ movhi
	ldrh	r2, [r3, #112]
	adds	r2, r2, #1
	strh	r2, [r3, #112]	@ movhi
	pop	{r4, r5, r6, pc}
.L1112:
	adds	r2, r2, #1
	b	.L1111
.L1117:
	.align	2
.L1116:
	.word	.LANCHOR110
	.word	.LANCHOR114
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
	beq	.L1118
	ldr	r3, .L1127
	ldr	r5, [r3]
	add	r6, r5, r4, lsl #2
	ldrb	r3, [r6, #2]	@ zero_extendqisi2
	tst	r3, #224
	bne	.L1118
	ldrb	r2, [r0, #4]	@ zero_extendqisi2
	mov	r0, r4
	bfi	r3, r2, #5, #3
	strb	r3, [r6, #2]
	bl	zftl_remove_free_node
	ldrb	r3, [r6, #2]	@ zero_extendqisi2
	ldr	r2, .L1127+4
	tst	r3, #8
	ldr	r0, [r2]
	beq	.L1122
	ldrh	r1, [r0, #116]
	subs	r1, r1, #1
	strh	r1, [r0, #116]	@ movhi
.L1123:
	and	r3, r3, #224
	cmp	r3, #160
	bne	.L1125
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
.L1122:
	tst	r3, #24
	itete	eq
	ldrheq	r1, [r0, #114]
	ldrhne	r1, [r0, #118]
	addeq	r1, r1, #-1
	addne	r1, r1, #-1
	ite	eq
	strheq	r1, [r0, #114]	@ movhi
	strhne	r1, [r0, #118]	@ movhi
	b	.L1123
.L1125:
	ldrh	r1, [r5, r4, lsl #2]
	cmp	r3, #64
	add	r0, r1, #1
	bfi	r1, r0, #0, #11
	strh	r1, [r5, r4, lsl #2]	@ movhi
	bne	.L1126
	ldr	r2, [r2]
	ldrh	r3, [r2, #122]
	subs	r3, r3, #1
	strh	r3, [r2, #122]	@ movhi
	pop	{r4, r5, r6, pc}
.L1126:
	cmp	r3, #96
	itttt	eq
	ldreq	r2, [r2]
	ldrheq	r3, [r2, #124]
	addeq	r3, r3, #-1
	strheq	r3, [r2, #124]	@ movhi
.L1118:
	pop	{r4, r5, r6, pc}
.L1128:
	.align	2
.L1127:
	.word	.LANCHOR7
	.word	.LANCHOR110
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
	ldr	r3, .L1133
	ldr	r5, [r3]
	ldr	r3, .L1133+4
	ldrh	r2, [r3]
	ldr	r3, .L1133+8
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
	bne	.L1132
	movw	r2, #1937
	ldr	r1, .L1133+12
	ldr	r0, .L1133+16
	bl	printf
.L1132:
	ldr	r3, .L1133+20
	ldrh	r0, [r3]
	mla	r0, r4, r0, r7
	pop	{r3, r4, r5, r6, r7, pc}
.L1134:
	.align	2
.L1133:
	.word	.LANCHOR10
	.word	.LANCHOR95
	.word	.LANCHOR80
	.word	.LANCHOR115
	.word	.LC0
	.word	.LANCHOR111
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
	ldr	r3, .L1139
	uxtb	r2, r0
	push	{r4, r5}
	ldrh	r3, [r3, r2, lsl #1]
	ldr	r2, .L1139+4
	ldr	r1, [r2]
	ldr	r2, .L1139+8
	ldr	r4, [r2]
	movw	r2, #65535
.L1136:
	cmp	r3, r2
	bne	.L1138
	mov	r0, #-1
	pop	{r4, r5}
	bx	lr
.L1138:
	ldr	r5, [r1, r3, lsl #2]
	cmp	r0, r5
	bne	.L1137
	mov	r0, r3
	pop	{r4, r5}
	b	ftl_get_ppa_from_index
.L1137:
	ldrh	r3, [r4, r3, lsl #1]
	b	.L1136
.L1140:
	.align	2
.L1139:
	.word	.LANCHOR116
	.word	.LANCHOR117
	.word	.LANCHOR118
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
	bne	.L1142
	mov	r2, #2080
	ldr	r1, .L1149
	ldr	r0, .L1149+4
	bl	printf
.L1142:
	ldr	r3, .L1149+8
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3]
	cmp	r2, r3
	bne	.L1143
	movw	r2, #2081
	ldr	r1, .L1149
	ldr	r0, .L1149+4
	bl	printf
.L1143:
	ldrh	r3, [r4, #6]
	cbnz	r3, .L1144
	movw	r2, #2082
	ldr	r1, .L1149
	ldr	r0, .L1149+4
	bl	printf
.L1144:
	ldrb	r3, [r4, #5]	@ zero_extendqisi2
	movw	r2, #65535
	movs	r1, #0
	adds	r3, r3, #8
	ldrh	r0, [r4, r3, lsl #1]
	ldr	r3, .L1149+12
	ldrb	r5, [r3]	@ zero_extendqisi2
.L1145:
	cmp	r0, r2
	ldrb	r3, [r4, #5]	@ zero_extendqisi2
	beq	.L1147
	ldr	r1, .L1149+16
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
.L1147:
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
	b	.L1145
.L1150:
	.align	2
.L1149:
	.word	.LANCHOR119
	.word	.LC0
	.word	.LANCHOR95
	.word	.LANCHOR80
	.word	.LANCHOR111
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
	bls	.L1152
	movw	r2, #2117
	ldr	r1, .L1153
	ldr	r0, .L1153+4
	bl	printf
.L1152:
	ldr	r5, .L1153+8
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
.L1154:
	.align	2
.L1153:
	.word	.LANCHOR120
	.word	.LC0
	.word	.LANCHOR110
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
	ldr	r2, .L1166
	push	{r3, r4, r5, r6, r7, lr}
	mov	r1, r2
	ldrh	r3, [r2]
	cmp	r3, #4
	bhi	.L1156
	cbnz	r0, .L1156
	adds	r3, r3, #1
	strh	r3, [r2]	@ movhi
	pop	{r3, r4, r5, r6, r7, pc}
.L1156:
	ldr	r2, .L1166+4
	movs	r3, #0
	mov	r0, r3
	movw	ip, #65535
	strh	r3, [r1]	@ movhi
	ldrh	r5, [r2]
	ldr	r2, .L1166+8
	ldr	r6, [r2]
	ldr	r2, .L1166+12
	ldr	r7, [r2]
	mov	r2, r3
.L1158:
	uxth	r1, r3
	cmp	r5, r1
	bhi	.L1161
	ldr	r3, .L1166+16
	ldr	r4, [r3]
	ldr	r3, .L1166+20
	str	r2, [r4, #524]
	ldr	r3, [r3]
	str	r0, [r4, #528]
	ldrh	r1, [r3, #120]
	cbz	r1, .L1155
	bl	__aeabi_uidiv
	str	r0, [r4, #532]
.L1155:
	pop	{r3, r4, r5, r6, r7, pc}
.L1161:
	ldrh	r1, [r6, r3, lsl #1]
	cmp	r1, ip
	beq	.L1159
	add	r4, r7, r3, lsl #2
	ldrb	r4, [r4, #2]	@ zero_extendqisi2
	and	r4, r4, #224
	cmp	r4, #160
	ite	eq
	addeq	r0, r0, r1
	addne	r2, r2, r1
.L1159:
	adds	r3, r3, #1
	b	.L1158
.L1167:
	.align	2
.L1166:
	.word	.LANCHOR121
	.word	.LANCHOR6
	.word	.LANCHOR9
	.word	.LANCHOR7
	.word	.LANCHOR10
	.word	.LANCHOR110
	.size	ftl_total_vpn_update, .-ftl_total_vpn_update
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
	ldr	r3, .L1171
	ldr	r3, [r3]
	ldrh	r3, [r3, r4, lsl #1]
	cbnz	r3, .L1170
	ldr	r3, .L1171+4
	movs	r0, #1
	str	r0, [r3]
	pop	{r4, pc}
.L1170:
	movs	r0, #0
	pop	{r4, pc}
.L1172:
	.align	2
.L1171:
	.word	.LANCHOR9
	.word	.LANCHOR122
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
	beq	.L1174
	ldr	r3, .L1182
	ldr	r3, [r3]
	ldrh	r4, [r3, r0, lsl #1]
	cbnz	r4, .L1175
	ldr	r3, .L1182+4
	mov	r1, r0
	mov	r2, r4
	ldr	r3, [r3]
	add	r3, r3, r0, lsl #2
	ldr	r0, .L1182+8
	ldrb	r3, [r3, #2]	@ zero_extendqisi2
	lsrs	r3, r3, #5
	bl	printf
.L1180:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L1175:
	subs	r4, r4, #1
	strh	r4, [r3, r0, lsl #1]	@ movhi
.L1174:
	ldr	r3, .L1182+12
	ldrh	r0, [r3]
	mov	r4, r3
	cmp	r5, r0
	beq	.L1180
	movw	r2, #65535
	cmp	r0, r2
	bne	.L1177
	strh	r5, [r3]	@ movhi
	b	.L1180
.L1177:
	bl	ftl_vpn_update
	ldr	r3, .L1182+16
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
	ldr	r3, .L1182+20
	strh	r1, [r3, r2, lsl #1]	@ movhi
	pop	{r3, r4, r5, pc}
.L1183:
	.align	2
.L1182:
	.word	.LANCHOR9
	.word	.LANCHOR7
	.word	.LC65
	.word	.LANCHOR73
	.word	.LANCHOR123
	.word	.LANCHOR74
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
	ldr	r4, .L1195
	movw	r6, #65535
	mov	fp, r6
	ldr	r5, .L1195+4
	ldr	lr, [r4]
	ldr	r4, .L1195+8
	ldrh	r3, [r5, ip, lsl #1]
	ldr	r4, [r4]
.L1185:
	cmp	r3, fp
	beq	.L1189
	ldr	r7, [lr, r3, lsl #2]
	add	r8, lr, r3, lsl #2
	cmp	r0, r7
	bne	.L1186
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
.L1189:
	ldrh	r3, [r5, ip, lsl #1]
	str	r0, [lr, r2, lsl #2]
	strh	r2, [r5, ip, lsl #1]	@ movhi
	strh	r3, [r4, r2, lsl #1]	@ movhi
	adds	r3, r1, #1
	beq	.L1191
	ldr	r3, .L1195+12
	ldrh	r2, [r3]
	ldr	r3, .L1195+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	rsb	r3, r3, #24
	subs	r0, r3, r2
	movs	r3, #1
	lsls	r3, r3, r0
	lsr	r0, r1, r2
	ldr	r2, .L1195+20
	subs	r3, r3, #1
	ands	r0, r0, r3
	ldrb	r1, [r2]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	uxth	r0, r0
	bl	ftl_vpn_decrement
.L1191:
	mov	r0, #-1
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1186:
	mov	r6, r3
	ldrh	r3, [r4, r3, lsl #1]
	b	.L1185
.L1196:
	.align	2
.L1195:
	.word	.LANCHOR117
	.word	.LANCHOR116
	.word	.LANCHOR118
	.word	.LANCHOR75
	.word	.LANCHOR32
	.word	.LANCHOR76
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
	ldr	r3, .L1204
	push	{r0, r1, r2, r4, r5, r6, r7, r8, r10, lr}
	ldrb	r4, [r3]	@ zero_extendqisi2
	movs	r3, #1
	rsb	r1, r4, #24
	lsl	r4, r3, r4
	lsr	r2, r0, r1
	subs	r4, r4, #1
	ands	r4, r4, r2
	ldr	r2, .L1204+4
	uxtb	r4, r4
	ldrb	r5, [r2]	@ zero_extendqisi2
	smulbb	r2, r4, r5
	uxtb	r8, r2
	ldr	r2, .L1204+8
	ldrh	r6, [r2]
	lsr	r2, r0, r6
	subs	r0, r1, r6
	lsl	r0, r3, r0
	mov	r1, r5
	subs	r0, r0, #1
	ands	r0, r0, r2
	uxth	r10, r0
	bl	__aeabi_uidiv
	ldr	r3, .L1204+12
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
	bpl	.L1199
	uxth	r3, r0
	str	r10, [sp]
	mov	r2, r8
	ldr	r0, .L1204+16
	mov	r1, r4
	bl	printf
.L1199:
	ldr	r3, .L1204+20
	ldrh	r3, [r3]
	cmp	r3, r7
	bls	.L1197
	ldr	r3, .L1204+24
	uxth	r6, r6
	movs	r2, #1
	lsl	r8, r2, r8
	ldr	r3, [r3]
	add	r6, r3, r6, lsl #2
	ldrb	r2, [r6, #3]	@ zero_extendqisi2
	orr	r2, r2, r8
	strb	r2, [r6, #3]
.L1197:
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L1205:
	.align	2
.L1204:
	.word	.LANCHOR32
	.word	.LANCHOR76
	.word	.LANCHOR75
	.word	.LANCHOR14
	.word	.LC66
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
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r8, r0
	ldr	r4, .L1226
	ldr	r3, [r4, #2116]
	cbz	r3, .L1223
	mov	fp, #0
.L1208:
	ldr	r3, .L1226+4
	ldrb	r2, [r3]	@ zero_extendqisi2
	uxth	r3, fp
	cmp	r2, r3
	bhi	.L1218
.L1223:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1218:
	ldr	r3, .L1226+8
	uxth	r0, fp
	mov	r10, #0
	ldrb	r7, [r3]	@ zero_extendqisi2
	mov	r1, r7
	bl	__aeabi_idiv
	ldr	r3, .L1226+12
	uxth	r6, r7
	cmp	r7, #1
	ldrb	r5, [r3]	@ zero_extendqisi2
	ldr	r3, .L1226+16
	rsb	r5, r5, #24
	ldrh	r2, [r3]
	mov	r7, r3
	sub	r5, r5, r2
	lsl	r0, r0, r5
	smulbb	r5, r8, r6
	itt	hi
	addhi	r6, r6, #-1
	andhi	r6, r6, fp
	add	r5, r5, r0
	uxth	r5, r5
	itt	hi
	addhi	r5, r5, r6
	uxthhi	r5, r5
.L1210:
	ldr	r0, [r4, #2116]
	uxth	r6, r10
	mov	r1, r6
	cmp	r0, r6
	bhi	.L1217
	add	fp, fp, #1
	b	.L1208
.L1217:
	addw	r1, r1, #1060
	ldrh	r1, [r4, r1, lsl #1]
	cmp	r1, r5
	bne	.L1211
	mov	r1, r5
	ldr	r0, .L1226+20
	bl	printf
	ldr	r1, .L1226+24
	ldrb	r1, [r1]	@ zero_extendqisi2
	cbnz	r1, .L1212
	ldr	r1, .L1226+28
	ldrb	r1, [r1]	@ zero_extendqisi2
	cbz	r1, .L1213
.L1212:
	ldr	r1, .L1226+32
	ldr	r3, .L1226+36
	ldr	r1, [r1]
	ldr	r1, [r1, #156]
	cmp	r1, r3
	beq	.L1214
.L1213:
	ldrh	r0, [r7]
	lsl	r0, r5, r0
	bl	ftl_mask_bad_block
.L1214:
	ldr	r1, [r4, #2116]
.L1215:
	cmp	r6, r1
	bcc	.L1216
	subs	r1, r1, #1
	str	r1, [r4, #2116]
.L1211:
	add	r10, r10, #1
	b	.L1210
.L1216:
	addw	r0, r6, #1061
	adds	r3, r6, #1
	ldrh	ip, [r4, r0, lsl #1]
	addw	r0, r6, #1060
	uxth	r6, r3
	strh	ip, [r4, r0, lsl #1]	@ movhi
	b	.L1215
.L1227:
	.align	2
.L1226:
	.word	.LANCHOR71
	.word	.LANCHOR80
	.word	.LANCHOR76
	.word	.LANCHOR32
	.word	.LANCHOR75
	.word	.LC67
	.word	.LANCHOR124
	.word	.LANCHOR81
	.word	.LANCHOR110
	.word	1145785929
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
	ldr	r3, .L1249
	ldr	r6, [r3]
	lsls	r3, r0, #2
	adds	r7, r6, r3
	ldrb	r4, [r7, #2]	@ zero_extendqisi2
	lsls	r2, r4, #28
	lsr	r3, r4, #5
	str	r3, [sp, #4]
	bpl	.L1229
	ldr	r3, .L1249+4
	ldrh	fp, [r6, r0, lsl #2]
	ldr	r1, .L1249+8
	ldr	r3, [r3]
	ldr	r0, [r6, r0, lsl #2]
	ubfx	fp, fp, #0, #11
	ldrh	r8, [r1]
	ldrh	r2, [r3, #74]
	ldrh	r3, [r3, #72]
	ubfx	r10, r0, #11, #8
	mov	r1, r8
	add	r2, r2, fp
	uxth	r2, r2
	add	r3, r3, r10
	uxth	r3, r3
	mov	r0, r2
	str	r2, [sp, #8]
	str	r3, [sp, #12]
	bl	__aeabi_uidiv
	ldr	r3, [sp, #12]
	ldr	r1, .L1249+12
	ldr	r2, [sp, #8]
	ldrh	r1, [r1]
	uxtah	r0, r3, r0
	cmp	r0, r1
	ble	.L1230
	ldr	r3, .L1249+16
	ldr	r1, .L1249+20
	ldrh	r2, [r3]
	ldr	r3, .L1249+24
	ldrh	r1, [r1]
	adds	r2, r2, #7
	ldrh	r3, [r3]
	add	r3, r3, r1
	cmp	r2, r3
	blt	.L1231
.L1236:
	movs	r3, #2
	bfi	r4, r3, #3, #2
	b	.L1246
.L1231:
	ldr	r3, .L1249+28
	ldr	r1, .L1249+32
	ldrh	r2, [r3]
	ldr	r3, .L1249+36
	ldrh	r1, [r1]
	adds	r2, r2, #7
	ldrh	r3, [r3]
	add	r3, r3, r1
	ldr	r1, .L1249+40
	ldrh	r1, [r1]
	add	r3, r3, r1
	cmp	r2, r3
	blt	.L1236
.L1248:
	bfc	r4, #3, #2
.L1246:
	strb	r4, [r7, #2]
.L1232:
	ldrb	r3, [r7, #2]	@ zero_extendqisi2
	ands	r3, r3, #24
	bne	.L1237
	mul	r8, r8, r10
	ldrh	r3, [r6, r5, lsl #2]
	lsr	r10, r10, #3
	add	r8, r8, r8, lsl #1
	add	fp, fp, r8, asr #2
	bfi	r3, fp, #0, #11
	strh	r3, [r6, r5, lsl #2]	@ movhi
	ldr	r3, [r6, r5, lsl #2]
	bfi	r3, r10, #11, #8
	str	r3, [r6, r5, lsl #2]
.L1238:
	mov	r0, r5
	bl	zftl_remove_data_node
	ldr	r3, .L1249
	lsls	r2, r5, #2
	ldr	r3, [r3]
	add	r3, r3, r2
	ldrb	r2, [r3, #2]	@ zero_extendqisi2
	bfc	r2, #5, #3
	strb	r2, [r3, #2]
	movs	r2, #0
	ldr	r3, .L1249+44
	ldr	r3, [r3]
	strh	r2, [r3, r5, lsl #1]	@ movhi
	ldr	r3, [sp, #4]
	adds	r3, r3, #6
	and	r3, r3, #7
	cmp	r3, #4
	bhi	.L1241
	mov	r0, r5
	bl	gc_free_bad_sblk
.L1241:
	ldrb	r3, [r7, #2]	@ zero_extendqisi2
	lsls	r3, r3, #28
	bpl	.L1242
	ldr	r3, .L1249+48
	ldr	r3, [r3]
	ldrh	r2, [r3, #586]
	cmp	r2, r5
	bne	.L1242
	ldrh	r1, [r3, #590]
	movw	r2, #65535
	strh	r2, [r3, #586]	@ movhi
	cmp	r1, r2
	bne	.L1242
	strh	r5, [r3, #590]	@ movhi
	mov	r1, r5
	ldr	r0, .L1249+52
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	printf
.L1230:
	mla	r3, r3, r8, r2
	ldr	r2, .L1249+56
	ldrh	r2, [r2]
	cmp	r3, r2
	ble	.L1232
	ldr	r3, .L1249+28
	ldr	r1, .L1249+32
	ldrh	r2, [r3]
	ldr	r3, .L1249+36
	ldrh	r1, [r1]
	ldrh	r3, [r3]
	add	r3, r3, r1
	ldr	r1, .L1249+40
	ldrh	r1, [r1]
	add	r3, r3, r1
	adds	r1, r2, #7
	cmp	r1, r3
	bge	.L1248
	ldr	r1, .L1249+16
	ldr	ip, .L1249+20
	ldrh	r0, [r1]
	ldr	r1, .L1249+24
	ldrh	ip, [ip]
	adds	r0, r0, #7
	ldrh	r1, [r1]
	add	r1, r1, ip
	cmp	r0, r1
	bge	.L1236
	adds	r2, r2, #23
	cmp	r3, r2
	bgt	.L1236
	b	.L1248
.L1237:
	cmp	r3, #16
	bne	.L1238
	mov	r0, fp
	mov	r1, r8
	bl	__aeabi_idiv
	add	r0, r0, r0, lsl #1
	ldr	r3, [r6, r5, lsl #2]
	asr	fp, fp, #5
	add	r10, r10, r0, asr #2
	bfi	r3, r10, #11, #8
	str	r3, [r6, r5, lsl #2]
	bfi	r3, fp, #0, #11
.L1247:
	strh	r3, [r6, r5, lsl #2]	@ movhi
	b	.L1238
.L1229:
	tst	r4, #24
	bne	.L1238
	ldr	r3, .L1249+60
	ldrh	r3, [r3]
	cmp	r3, #0
	bne	.L1238
	ldr	r3, .L1249+20
	ldrh	r1, [r3]
	cmp	r1, #15
	bhi	.L1238
	ldr	r3, .L1249+36
	ldr	r2, .L1249+32
	ldrh	r3, [r3]
	ldrh	r2, [r2]
	add	r3, r3, r2
	ldr	r2, .L1249+40
	ldrh	r2, [r2]
	add	r3, r3, r2
	ldr	r2, .L1249+28
	ldrh	r2, [r2]
	adds	r2, r2, #16
	cmp	r3, r2
	ble	.L1238
	ldr	r3, .L1249+16
	ldrh	r2, [r3]
	ldr	r3, .L1249+24
	adds	r2, r2, #7
	ldrh	r3, [r3]
	add	r3, r3, r1
	cmp	r2, r3
	blt	.L1238
	movs	r3, #2
	bfi	r4, r3, #3, #2
	ldr	r3, .L1249+8
	strb	r4, [r7, #2]
	ldrh	r4, [r6, r0, lsl #2]
	ldrh	r1, [r3]
	ubfx	r4, r4, #0, #11
	mov	r0, r4
	asrs	r4, r4, #5
	bl	__aeabi_idiv
	ldr	r3, [r6, r5, lsl #2]
	add	r0, r0, r0, lsl #1
	ubfx	r2, r3, #11, #8
	add	r0, r2, r0, asr #2
	bfi	r3, r0, #11, #8
	str	r3, [r6, r5, lsl #2]
	bfi	r3, r4, #0, #11
	b	.L1247
.L1242:
	mov	r0, r5
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	zftl_insert_free_list
.L1250:
	.align	2
.L1249:
	.word	.LANCHOR7
	.word	.LANCHOR110
	.word	.LANCHOR8
	.word	.LANCHOR125
	.word	.LANCHOR101
	.word	.LANCHOR105
	.word	.LANCHOR93
	.word	.LANCHOR98
	.word	.LANCHOR103
	.word	.LANCHOR97
	.word	.LANCHOR99
	.word	.LANCHOR9
	.word	.LANCHOR10
	.word	.LC68
	.word	.LANCHOR126
	.word	.LANCHOR107
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
	ldr	r6, .L1288
.L1252:
	uxth	r2, r5
	ldr	r3, .L1288+4
	ldrh	r1, [r3, #52]
	cmp	r1, r2
	bhi	.L1266
	movs	r2, #0
	strh	r2, [r3, #52]	@ movhi
	pop	{r3, r4, r5, r6, r7, pc}
.L1266:
	uxth	r2, r5
	add	r3, r3, r2, lsl #1
	ldrh	r4, [r3, #54]
	ldr	r3, [r6]
	ldrh	r2, [r3, r4, lsl #1]
	cbz	r2, .L1253
	mov	r1, r4
	ldr	r0, .L1288+8
	bl	printf
.L1253:
	ldr	r3, [r6]
	movs	r2, #0
	strh	r2, [r3, r4, lsl #1]	@ movhi
	ldr	r3, .L1288+12
	ldr	r7, [r3]
	ldr	r3, .L1288+16
	ldr	r3, [r3]
	add	r7, r7, r4, lsl #2
	lsls	r3, r3, #23
	bpl	.L1254
	ldrb	r2, [r7, #2]	@ zero_extendqisi2
	mov	r1, r4
	ldr	r0, .L1288+20
	lsrs	r2, r2, #5
	bl	printf
.L1254:
	ldrb	r3, [r7, #2]	@ zero_extendqisi2
	and	r2, r3, #224
	cmp	r2, #224
	beq	.L1255
	tst	r3, #192
	bne	.L1256
.L1255:
	movw	r2, #1362
	ldr	r1, .L1288+24
	ldr	r0, .L1288+28
	bl	printf
.L1256:
	mov	r0, r4
	bl	ftl_free_sblk
	ldr	r3, .L1288+32
	ldr	r3, [r3]
	ldrh	r1, [r3, #124]
	cbz	r1, .L1257
	add	r0, r3, #392
	movs	r2, #0
.L1259:
	ldrh	r7, [r0], #2
	cmp	r4, r7
	bne	.L1258
	adds	r2, r2, #196
	movw	r0, #65535
	subs	r1, r1, #1
	strh	r0, [r3, r2, lsl #1]	@ movhi
	strh	r1, [r3, #124]	@ movhi
.L1257:
	ldrh	r1, [r3, #120]
	cbz	r1, .L1260
	add	r0, r3, #136
	movs	r2, #0
.L1262:
	ldrh	r7, [r0], #2
	cmp	r4, r7
	bne	.L1261
	adds	r2, r2, #68
	movw	r0, #65535
	subs	r1, r1, #1
	strh	r0, [r3, r2, lsl #1]	@ movhi
	strh	r1, [r3, #120]	@ movhi
.L1260:
	ldrh	r1, [r3, #122]
	cbz	r1, .L1263
	add	r0, r3, #264
	movs	r2, #0
.L1265:
	ldrh	r7, [r0], #2
	cmp	r4, r7
	bne	.L1264
	adds	r2, r2, #132
	movw	r0, #65535
	subs	r1, r1, #1
	strh	r0, [r3, r2, lsl #1]	@ movhi
	strh	r1, [r3, #122]	@ movhi
.L1263:
	adds	r5, r5, #1
	b	.L1252
.L1258:
	adds	r2, r2, #1
	cmp	r2, #64
	bne	.L1259
	b	.L1257
.L1261:
	adds	r2, r2, #1
	cmp	r2, #64
	bne	.L1262
	b	.L1260
.L1264:
	adds	r2, r2, #1
	cmp	r2, #64
	bne	.L1265
	b	.L1263
.L1289:
	.align	2
.L1288:
	.word	.LANCHOR9
	.word	.LANCHOR71
	.word	.LC69
	.word	.LANCHOR7
	.word	.LANCHOR14
	.word	.LC70
	.word	.LANCHOR127
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
	ldr	r4, .L1291
	ldr	r5, .L1291+4
	ldr	r6, .L1291+8
	ldr	r1, [r4]
	ldr	r0, [r5]
	ldr	r6, [r6]
	ldr	r3, .L1291+12
	ldrh	r2, [r1, #146]
	ldrh	r1, [r1, #148]
	ldrh	r3, [r3]
	str	r6, [sp, #28]
	ldr	r6, [r0, #528]
	str	r6, [sp, #24]
	ldr	r0, [r0, #524]
	str	r0, [sp, #20]
	ldr	r0, .L1291+16
	ldrh	r0, [r0]
	str	r0, [sp, #16]
	ldr	r0, .L1291+20
	ldrh	r0, [r0]
	str	r0, [sp, #12]
	ldr	r0, .L1291+24
	ldrh	r0, [r0]
	str	r0, [sp, #8]
	ldr	r0, .L1291+28
	ldrh	r0, [r0]
	str	r0, [sp, #4]
	ldr	r0, .L1291+32
	ldrh	r0, [r0]
	str	r0, [sp]
	ldr	r0, .L1291+36
	bl	printf
	ldr	r1, [r4]
	ldr	r3, .L1291+40
	ldr	r0, .L1291+44
	ldr	r2, [r1, #64]
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r2, [sp, #4]
	ldr	r2, [r1, #8]
	str	r2, [sp]
	ldr	r2, [r1, #28]
	ldr	r1, [r1, #20]
	bl	printf
	ldr	r1, [r4]
	ldr	r0, .L1291+48
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
	ldr	r0, .L1291+52
	ldr	r2, [r2, #84]
	bl	printf
	ldr	r0, .L1291+56
	ldr	r3, .L1291+60
	ldr	r2, .L1291+64
	ldrh	r0, [r0]
	ldr	r1, .L1291+68
	ldrh	r3, [r3]
	ldrh	r2, [r2]
	ldrh	r1, [r1]
	str	r0, [sp, #4]
	ldr	r0, .L1291+72
	ldrh	r0, [r0]
	str	r0, [sp]
	ldr	r0, .L1291+76
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
	ldr	r0, .L1291+80
	bl	printf
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, pc}
.L1292:
	.align	2
.L1291:
	.word	.LANCHOR110
	.word	.LANCHOR10
	.word	.LANCHOR128
	.word	.LANCHOR103
	.word	.LANCHOR93
	.word	.LANCHOR99
	.word	.LANCHOR97
	.word	.LANCHOR107
	.word	.LANCHOR105
	.word	.LC71
	.word	.LANCHOR129
	.word	.LC72
	.word	.LC73
	.word	.LC74
	.word	.LANCHOR87
	.word	.LANCHOR70
	.word	.LANCHOR102
	.word	.LANCHOR100
	.word	.LANCHOR94
	.word	.LC75
	.word	.LC76
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
	cbnz	r0, .L1294
	movw	r2, #803
	ldr	r1, .L1303
	ldr	r0, .L1303+4
	bl	printf
	bl	print_ftl_debug_info
	mov	r0, #-1
	pop	{r4, r5, r6, pc}
.L1297:
	mov	r1, r4
	ldr	r0, .L1303+8
	bl	buf_add_tail
	ldr	r3, .L1303+12
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
.L1294:
	ldr	r5, .L1303+16
	ldrb	r1, [r0, #40]	@ zero_extendqisi2
	ldrb	r2, [r5]	@ zero_extendqisi2
	cmp	r1, r2
	bls	.L1299
	movw	r2, #810
	ldr	r1, .L1303
	ldr	r0, .L1303+4
	bl	printf
.L1299:
	ldrb	r3, [r4, #40]	@ zero_extendqisi2
	ldr	r6, .L1303+20
	cbz	r3, .L1296
	ldrb	r2, [r5]	@ zero_extendqisi2
	cmp	r2, r3
	bcs	.L1297
.L1296:
	mov	r0, r4
	bl	zbuf_free
	ldrb	r0, [r6]	@ zero_extendqisi2
	pop	{r4, r5, r6, pc}
.L1304:
	.align	2
.L1303:
	.word	.LANCHOR130
	.word	.LC0
	.word	.LANCHOR66
	.word	.LANCHOR110
	.word	.LANCHOR131
	.word	.LANCHOR67
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
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	fp, #0
	ldr	r8, .L1321+36
	ldr	r10, .L1321+40
.L1306:
	ldrb	r6, [r8]	@ zero_extendqisi2
	cmp	r6, #255
	bne	.L1317
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1317:
	movs	r3, #48
	ldr	r5, .L1321
	muls	r3, r6, r3
	add	r7, r6, r6, lsl #1
	add	r7, r5, r7, lsl #4
	adds	r4, r5, r3
	ldrb	r3, [r5, r3]	@ zero_extendqisi2
	strb	r3, [r8]
	ldr	r3, [r4, #36]
	adds	r3, r3, #1
	bne	.L1307
	ldr	r3, .L1321+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L1308
	ldr	r3, .L1321+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1309
.L1308:
	ldr	r3, .L1321+12
	ldr	r3, [r3]
	ldr	r3, [r3, #156]
	cmp	r3, r10
	beq	.L1310
.L1309:
	ldr	r2, .L1321+16
	movs	r3, #48
	mla	r3, r3, r6, r5
	ldr	fp, .L1321+44
	ldrh	r1, [r2]
	ldr	r2, .L1321+20
	ldr	r3, [r3, #24]
	ldrb	r2, [r2]	@ zero_extendqisi2
	str	r3, [sp, #4]
	rsb	r2, r2, #24
	subs	r0, r2, r1
	movs	r2, #1
	lsls	r2, r2, r0
	lsr	r0, r3, r1
	ldr	r1, .L1321+24
	subs	r2, r2, #1
	ands	r0, r0, r2
	ldrb	r1, [r1]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	ldr	r2, [fp]
	movw	r1, #65535
	uxth	r4, r0
	ldr	r0, .L1321+28
	ldr	r3, [r2, #560]
	cmp	r3, r1
	ldr	r3, [sp, #4]
	it	eq
	streq	r4, [r2, #560]
	mov	r1, r4
	it	eq
	streq	r3, [r2, #564]
	movs	r2, #48
	mla	r5, r2, r6, r5
	ldr	r2, [r5, #20]
	bl	printf
	ldr	r3, [fp]
	ldr	r2, [r3, #556]
	adds	r2, r2, #1
	str	r2, [r3, #556]
	ldrh	r2, [r3, #16]
	cmp	r2, r4
	bne	.L1312
	movs	r2, #0
	strh	r2, [r3, #22]	@ movhi
.L1310:
	mov	r0, r7
	mov	fp, #1
	bl	ftl_write_buf
	b	.L1306
.L1312:
	ldrh	r2, [r3, #48]
	cmp	r2, r4
	itt	eq
	moveq	r2, #0
	strheq	r2, [r3, #54]	@ movhi
	b	.L1310
.L1307:
	cmp	fp, #0
	beq	.L1315
	ldr	r2, [r4, #24]
	ldr	r1, [r4, #20]
	ldr	r0, .L1321+32
	bl	printf
	mov	r0, r7
	bl	ftl_write_buf
	b	.L1306
.L1315:
	ldrh	r2, [r4, #32]
	ldr	r1, [r4, #28]
	ldr	r0, [r4, #20]
	bl	lpa_hash_update_ppa
	ldrb	r3, [r4, #2]	@ zero_extendqisi2
	lsls	r2, r3, #29
	bpl	.L1316
	bic	r3, r3, #2
	strb	r3, [r4, #2]
	b	.L1306
.L1316:
	mov	r0, r7
	bl	zbuf_free
	b	.L1306
.L1322:
	.align	2
.L1321:
	.word	.LANCHOR56
	.word	.LANCHOR124
	.word	.LANCHOR81
	.word	.LANCHOR110
	.word	.LANCHOR75
	.word	.LANCHOR32
	.word	.LANCHOR76
	.word	.LC77
	.word	.LC78
	.word	.LANCHOR65
	.word	1145785929
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
	cbnz	r0, .L1324
	movw	r2, #1143
	ldr	r1, .L1328
	ldr	r0, .L1328+4
	bl	printf
	pop	{r4, lr}
	b	print_ftl_debug_info
.L1324:
	ldr	r3, .L1328+8
	ldrb	r2, [r0, #40]	@ zero_extendqisi2
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r2, r3
	bls	.L1326
	movw	r2, #1150
	ldr	r1, .L1328
	ldr	r0, .L1328+4
	bl	printf
.L1326:
	mov	r1, r4
	ldr	r0, .L1328+12
	bl	buf_add_tail
	ldr	r2, .L1328+16
	ldrb	r3, [r2]	@ zero_extendqisi2
	adds	r3, r3, #1
	strb	r3, [r2]
	pop	{r4, pc}
.L1329:
	.align	2
.L1328:
	.word	.LANCHOR132
	.word	.LC0
	.word	.LANCHOR131
	.word	.LANCHOR133
	.word	.LANCHOR134
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
	uxth	r5, r0
	cmp	r0, #5
	mov	r7, r0
	mov	r1, r5
	mov	r0, #0
	ite	ne
	movne	r6, #0
	moveq	r6, #2
	bl	zftl_get_free_sblk
	movw	r3, #65535
	mov	r4, r0
	cmp	r0, r3
	beq	.L1332
	ldr	r3, .L1339
	ldr	r5, [r3]
	add	r5, r5, r0, lsl #2
	ldrb	r3, [r5, #2]	@ zero_extendqisi2
	tst	r3, #224
	beq	.L1333
	movw	r2, #939
	ldr	r1, .L1339+4
	ldr	r0, .L1339+8
	bl	printf
.L1333:
	ldrb	r3, [r5, #2]	@ zero_extendqisi2
	bfi	r3, r7, #5, #3
	uxtb	r3, r3
	ubfx	r2, r3, #3, #2
	orrs	r2, r2, r6
	bfi	r3, r2, #3, #2
	strb	r3, [r5, #2]
	uxtb	r3, r3
	and	r2, r3, #24
	cmp	r2, #24
	bne	.L1334
	cbnz	r6, .L1334
	movs	r2, #1
	bfi	r3, r2, #3, #2
	strb	r3, [r5, #2]
.L1334:
	mov	r0, r4
	pop	{r3, r4, r5, r6, r7, pc}
.L1332:
	bl	print_ftl_debug_info
	mov	r2, r7
	mov	r1, r4
	ldr	r0, .L1339+12
	bl	printf
	mov	r1, r5
	movs	r0, #0
	bl	zftl_get_free_sblk
	mov	r2, r7
	mov	r1, r0
	mov	r4, r0
	ldr	r0, .L1339+12
	bl	printf
	bl	dump_all_list_info
	movw	r2, #955
	ldr	r1, .L1339+4
	ldr	r0, .L1339+8
	bl	printf
	b	.L1334
.L1340:
	.align	2
.L1339:
	.word	.LANCHOR7
	.word	.LANCHOR135
	.word	.LC0
	.word	.LC79
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
	ldr	r2, .L1342
	movs	r3, #255
	movs	r0, #0
	strb	r3, [r2]
	ldr	r2, .L1342+4
	strb	r3, [r2]
	ldr	r2, .L1342+8
	strb	r3, [r2]
	ldr	r2, .L1342+12
	strb	r3, [r2]
	bx	lr
.L1343:
	.align	2
.L1342:
	.word	.LANCHOR60
	.word	.LANCHOR65
	.word	.LANCHOR63
	.word	.LANCHOR64
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
	ldr	r4, .L1353
	ldr	r0, .L1353+4
	ldrb	r1, [r4]	@ zero_extendqisi2
	bl	printf
	ldrb	r4, [r4]	@ zero_extendqisi2
	cmp	r4, #255
	beq	.L1344
	ldr	r5, .L1353+8
	add	r4, r4, r4, lsl #1
	ldr	r6, .L1353+12
	add	r4, r5, r4, lsl #4
.L1346:
	ldr	r3, [r4, #24]
	mov	r0, r6
	ldrb	r2, [r4, #42]	@ zero_extendqisi2
	ldrb	r1, [r4, #1]	@ zero_extendqisi2
	bl	printf
	ldrb	r4, [r4]	@ zero_extendqisi2
	cmp	r4, #255
	beq	.L1344
	add	r4, r4, r4, lsl #1
	add	r4, r5, r4, lsl #4
	b	.L1346
.L1344:
	pop	{r4, r5, r6, pc}
.L1354:
	.align	2
.L1353:
	.word	.LANCHOR60
	.word	.LC80
	.word	.LANCHOR56
	.word	.LC81
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
	ldr	r3, .L1374
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	ldrb	r6, [r3]	@ zero_extendqisi2
	cmp	r6, #255
	beq	.L1363
	ldr	r3, .L1374+4
	movs	r2, #1
	ldr	r10, .L1374+16
	mov	r8, #48
	ldrb	r3, [r3]	@ zero_extendqisi2
	rsb	ip, r3, #24
	lsl	r3, r2, r3
	asr	r4, r0, ip
	subs	r3, r3, #1
	uxth	r3, r3
	ands	r4, r4, r3
	str	r4, [sp]
	ldr	r4, .L1374+8
	ldrh	lr, [r4]
	sub	r4, ip, lr
	lsls	r2, r2, r4
	ldr	r4, .L1374+12
	subs	r2, r2, #1
	ldrb	r7, [r4]	@ zero_extendqisi2
	asr	r4, r0, lr
	uxth	r2, r2
	subs	r7, r7, #1
	uxth	r7, r7
	ands	r4, r4, r7
	and	r0, r4, r2
	str	r0, [sp, #4]
.L1362:
	mla	fp, r8, r6, r10
	ldr	r5, [fp, #24]
	lsr	r0, r5, ip
	ands	r0, r0, r3
	mov	r4, r0
	ldr	r0, [sp]
	cmp	r0, r4
	bne	.L1357
	lsr	r5, r5, lr
	ldr	r4, [sp, #4]
	ldrb	r0, [fp, #42]	@ zero_extendqisi2
	ands	r5, r5, r7
	ands	r5, r5, r2
	cmp	r4, r5
	bne	.L1358
	cmp	r1, #1
	bne	.L1355
.L1360:
	cmp	r0, #7
	beq	.L1357
	cmp	r0, #9
.L1371:
	bne	.L1355
.L1357:
	mul	r6, r8, r6
	ldr	r0, .L1374+16
	ldrb	r6, [r0, r6]	@ zero_extendqisi2
	cmp	r6, #255
	bne	.L1362
.L1363:
	movs	r0, #0
.L1355:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1358:
	cmp	r1, #3
	bhi	.L1357
	adr	r5, .L1359
	ldr	pc, [r5, r1, lsl #2]
	.p2align 2
.L1359:
	.word	.L1355+1
	.word	.L1360+1
	.word	.L1361+1
	.word	.L1355+1
	.p2align 1
.L1361:
	cmp	r0, #11
	b	.L1371
.L1375:
	.align	2
.L1374:
	.word	.LANCHOR60
	.word	.LANCHOR32
	.word	.LANCHOR75
	.word	.LANCHOR76
	.word	.LANCHOR56
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
	ldr	r5, .L1401
	movs	r4, #48
	mov	fp, #255
	ldr	r6, .L1401+4
	ldrb	r3, [r5]	@ zero_extendqisi2
	ldr	r1, .L1401+8
	ldr	r7, .L1401+12
	str	r3, [sp, #4]
	ldrb	r3, [r6]	@ zero_extendqisi2
	ldrb	r2, [r1]	@ zero_extendqisi2
	ldrb	r10, [r7]	@ zero_extendqisi2
	str	r3, [sp]
	ldr	r3, .L1401+16
.L1377:
	cmp	r2, #255
	beq	.L1378
	mul	r8, r4, r2
	mov	r0, r2
	add	lr, r3, r8
	ldrb	lr, [lr, #42]	@ zero_extendqisi2
	sub	lr, lr, #12
	cmp	lr, #1
	bls	.L1379
.L1378:
	cmp	ip, #0
	beq	.L1376
	strb	r2, [r1]
	b	.L1376
.L1379:
	mul	lr, r4, r0
	ldrb	r2, [r3, r8]	@ zero_extendqisi2
	add	ip, r3, lr
	strb	fp, [r3, lr]
	ldrb	lr, [ip, #43]	@ zero_extendqisi2
	cmp	lr, #1
	bne	.L1382
	ldrh	ip, [ip, #34]
	cmp	ip, #0
	bne	.L1390
	mov	ip, r10
	mov	lr, r7
.L1383:
	cmp	ip, #255
	bne	.L1388
	strb	r2, [r1]
	movs	r2, #48
	mla	r3, r2, r0, r3
	ldrb	r3, [r3, #1]	@ zero_extendqisi2
	strb	r3, [lr]
.L1376:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1382:
	cmp	lr, #0
	bne	.L1384
	ldr	ip, [ip, #20]
	cmp	ip, #-1
	beq	.L1384
	ldr	ip, [sp, #4]
	mov	lr, r5
	b	.L1383
.L1390:
	ldr	ip, [sp]
	mov	lr, r6
	b	.L1383
.L1388:
	mov	lr, ip
	mul	ip, r4, ip
	ldrb	ip, [r3, ip]	@ zero_extendqisi2
	cmp	ip, #255
	bne	.L1388
	mla	r0, r4, r0, r3
	mul	lr, r4, lr
	ldrb	r0, [r0, #1]	@ zero_extendqisi2
	strb	r0, [r3, lr]
.L1384:
	mov	ip, #1
	b	.L1377
.L1402:
	.align	2
.L1401:
	.word	.LANCHOR63
	.word	.LANCHOR64
	.word	.LANCHOR60
	.word	.LANCHOR65
	.word	.LANCHOR56
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
	push	{r0, r1, r4, r5, r6, r7, r8, lr}
	ldr	r5, .L1421
	ldr	r1, .L1421+4
	ldr	r2, [r5]
	ldrb	r1, [r1]	@ zero_extendqisi2
	ldrh	r3, [r2, #690]
	adds	r3, r3, #1
	uxth	r3, r3
	cmp	r1, r3
	strh	r3, [r2, #690]	@ movhi
	bls	.L1404
	add	r3, r3, #336
	ldrh	r2, [r2, r3, lsl #1]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L1405
.L1404:
	ldr	r7, .L1421+8
	ldr	r4, .L1421+12
.L1419:
	movw	r8, #65535
.L1406:
	movs	r0, #1
	bl	ftl_alloc_sblk
	cmp	r0, r8
	mov	r6, r0
	beq	.L1406
	movs	r1, #0
	bl	ftl_erase_sblk
	ldr	r1, [r5]
	mov	r0, r6
	add	r1, r1, #672
	bl	ftl_get_blk_list_in_sblk
	uxth	r0, r0
	cbnz	r0, .L1407
	mov	r1, r6
	mov	r0, r7
	bl	printf
	ldr	r3, [r4]
	add	r6, r3, r6, lsl #2
	ldrb	r3, [r6, #2]	@ zero_extendqisi2
	orr	r3, r3, #224
	strb	r3, [r6, #2]
	b	.L1419
.L1407:
	ldr	r3, [r5]
	movs	r1, #1
	ldr	r2, .L1421+16
	movs	r4, #0
	strh	r4, [r3, #690]	@ movhi
	add	r3, r3, #416
	str	r1, [r2]
	movw	r1, #65535
.L1409:
	ldrh	r0, [r3], #2
	uxth	r2, r4
	cmp	r0, r1
	beq	.L1408
	adds	r4, r4, #1
	cmp	r4, #128
	bne	.L1409
	mov	r2, #264
	ldr	r1, .L1421+20
	ldr	r0, .L1421+24
	bl	printf
	mov	r2, r4
.L1408:
	ldr	r3, [r5]
	adds	r2, r2, #208
	strh	r6, [r3, r2, lsl #1]	@ movhi
	ldrh	r2, [r3, #688]
	adds	r2, r2, #1
	strh	r2, [r3, #688]	@ movhi
.L1405:
	ldr	r2, [r5]
	ldrh	r3, [r2, #690]
	add	r3, r3, #336
	ldrh	r4, [r2, r3, lsl #1]
	movw	r2, #65533
	subs	r3, r4, #1
	uxth	r3, r3
	cmp	r3, r2
	bls	.L1411
	mov	r2, #270
	ldr	r1, .L1421+20
	ldr	r0, .L1421+24
	bl	printf
.L1411:
	ldr	r1, [r5]
	movs	r3, #0
	strh	r3, [r1, #696]	@ movhi
	ldr	r3, .L1421+28
	strh	r4, [r1, #692]	@ movhi
	ldrb	r2, [r3]	@ zero_extendqisi2
	ldr	r3, .L1421+32
	rsb	r2, r2, #24
	ldrh	r3, [r3]
	subs	r2, r2, r3
	asr	r3, r4, r2
	strh	r3, [r1, #694]	@ movhi
	ldr	r1, .L1421+36
	ldr	r1, [r1]
	lsls	r1, r1, #19
	bpl	.L1415
	movs	r1, #1
	uxth	r3, r3
	lsl	r2, r1, r2
	ldr	r0, .L1421+40
	str	r3, [sp]
	mov	r1, r4
	mov	r3, r4
	subs	r2, r2, #1
	bl	printf
.L1415:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L1422:
	.align	2
.L1421:
	.word	.LANCHOR110
	.word	.LANCHOR80
	.word	.LC82
	.word	.LANCHOR7
	.word	.LANCHOR136
	.word	.LANCHOR137
	.word	.LC0
	.word	.LANCHOR32
	.word	.LANCHOR75
	.word	.LANCHOR14
	.word	.LC83
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
	ldr	r2, .L1433
	movw	r0, #65535
	push	{r3, r4, r5, r6, r7, lr}
	movs	r3, #0
	mov	r1, r2
.L1425:
	ldrh	r5, [r2, r3, lsl #3]
	uxth	r4, r3
	cmp	r5, r0
	beq	.L1424
	adds	r3, r3, #1
	cmp	r3, #32
	bne	.L1425
	movs	r2, #0
	mov	r4, r3
	mov	r0, #32768
.L1427:
	add	r3, r1, r2, lsl #3
	uxth	r5, r2
	ldrh	r3, [r3, #2]
	lsls	r6, r3, #16
	bmi	.L1426
	cmp	r3, r0
	itt	cc
	movcc	r0, r3
	movcc	r4, r5
.L1426:
	adds	r2, r2, #1
	cmp	r2, #32
	bne	.L1427
	cmp	r4, #32
	bne	.L1424
	ldr	r3, .L1433+4
	mov	r2, #-1
	ldrb	r5, [r3]	@ zero_extendqisi2
	movs	r3, #0
.L1429:
	add	r0, r1, r3, lsl #3
	uxth	r6, r3
	ldrh	r0, [r0, #2]
	cmp	r0, r2
	bcs	.L1428
	ldrh	r7, [r1, r3, lsl #3]
	cmp	r7, r5
	itt	ne
	movne	r2, r0
	movne	r4, r6
.L1428:
	adds	r3, r3, #1
	cmp	r3, #32
	bne	.L1429
	cmp	r4, #32
	bne	.L1424
	movw	r2, #377
	ldr	r1, .L1433+8
	ldr	r0, .L1433+12
	bl	printf
.L1424:
	mov	r0, r4
	pop	{r3, r4, r5, r6, r7, pc}
.L1434:
	.align	2
.L1433:
	.word	.LANCHOR138
	.word	.LANCHOR139
	.word	.LANCHOR140
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
	ldr	r3, .L1436
	movs	r0, #0
	str	r0, [r3]
	ldr	r3, .L1436+4
	str	r0, [r3]
	ldr	r3, .L1436+8
	strb	r0, [r3]
	ldr	r3, .L1436+12
	str	r0, [r3]
	bx	lr
.L1437:
	.align	2
.L1436:
	.word	.LANCHOR141
	.word	.LANCHOR142
	.word	.LANCHOR143
	.word	.LANCHOR144
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
	push	{r3, r4, r5, lr}
	mov	r5, r0
	ldr	r3, .L1492
	mov	r0, #1024
	ldr	r3, [r3]
	ldrb	r1, [r3, #12]	@ zero_extendqisi2
	bl	__aeabi_idiv
	uxth	r4, r0
	cbnz	r5, .L1440
	ldr	r3, .L1492+4
.L1441:
	strh	r5, [r3, r5, lsl #1]	@ movhi
	adds	r5, r5, #1
	cmp	r5, #512
	bne	.L1441
.L1447:
	movs	r1, #255
	mov	r2, #2048
	ldr	r0, .L1492+8
	bl	ftl_memset
	ldr	r0, .L1492+4
	movs	r3, #0
	ldr	r1, .L1492+8
.L1442:
	ldrh	r2, [r0, r3, lsl #1]
	adds	r3, r3, #1
	strh	r2, [r1, r2, lsl #1]	@ movhi
	uxth	r2, r3
	cmp	r2, r4
	bcc	.L1442
	pop	{r3, r4, r5, pc}
.L1440:
	cmp	r5, #1
	bne	.L1443
	ldr	r1, .L1492+4
	movs	r3, #0
.L1446:
	cmp	r3, #3
	uxth	r2, r3
	bls	.L1444
	tst	r2, #1
	ite	ne
	movne	r0, #3
	moveq	r0, #2
	rsb	r2, r0, r2, lsl #1
	uxth	r2, r2
.L1444:
	strh	r2, [r1, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	cmp	r3, #512
	bne	.L1446
	b	.L1447
.L1443:
	cmp	r5, #2
	bne	.L1448
	ldr	r1, .L1492+4
	movs	r2, #0
.L1450:
	uxth	r3, r2
	cmp	r2, #1
	ittt	hi
	lslhi	r3, r3, #1
	addhi	r3, r3, #-1
	uxthhi	r3, r3
	strh	r3, [r1, r2, lsl #1]	@ movhi
	adds	r2, r2, #1
	cmp	r2, #512
	bne	.L1450
	b	.L1447
.L1448:
	cmp	r5, #3
	bne	.L1451
	ldr	r1, .L1492+4
	movs	r3, #0
.L1454:
	cmp	r3, #5
	uxth	r2, r3
	bls	.L1452
	tst	r2, #1
	ite	ne
	movne	r0, #5
	moveq	r0, #4
	rsb	r2, r0, r2, lsl #1
	uxth	r2, r2
.L1452:
	strh	r2, [r1, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	cmp	r3, #512
	bne	.L1454
	b	.L1447
.L1451:
	cmp	r5, #4
	mov	r3, #0
	bne	.L1455
	ldr	r2, .L1492+4
	strh	r3, [r2]	@ movhi
	movs	r3, #1
	strh	r3, [r2, #2]	@ movhi
	movs	r3, #2
	strh	r3, [r2, #4]	@ movhi
	movs	r3, #3
	strh	r3, [r2, #6]	@ movhi
	movs	r3, #5
	strh	r3, [r2, #10]	@ movhi
	movs	r3, #7
	strh	r3, [r2, #12]	@ movhi
	movs	r3, #8
	strh	r5, [r2, #8]	@ movhi
	strh	r3, [r2, #14]!	@ movhi
.L1457:
	tst	r3, #1
	ite	ne
	movne	r1, #7
	moveq	r1, #6
	rsb	r1, r1, r3, lsl #1
	adds	r3, r3, #1
	uxth	r3, r3
	strh	r1, [r2, #2]!	@ movhi
	cmp	r3, #512
	bne	.L1457
	b	.L1447
.L1455:
	cmp	r5, #5
	bne	.L1458
	ldr	r2, .L1492+4
.L1459:
	strh	r3, [r2, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	cmp	r3, #16
	bne	.L1459
	ldr	r2, .L1492+12
.L1460:
	strh	r3, [r2, #2]!	@ movhi
	adds	r3, r3, #2
	uxth	r3, r3
	cmp	r3, #1008
	bne	.L1460
	b	.L1447
.L1458:
	cmp	r5, #8
	bne	.L1461
	ldr	r2, .L1492+4
.L1462:
	strh	r3, [r3, r2]	@ movhi
	adds	r3, r3, #2
	cmp	r3, #1024
	bne	.L1462
	b	.L1447
.L1461:
	cmp	r5, #9
	bne	.L1463
	ldr	r2, .L1492+4
	movw	r1, #1021
	strh	r3, [r2]	@ movhi
	movs	r3, #1
	strh	r3, [r2, #2]	@ movhi
	mov	r3, r2
	movs	r2, #2
	strh	r2, [r3, #4]!	@ movhi
	movs	r2, #3
.L1464:
	strh	r2, [r3, #2]!	@ movhi
	adds	r2, r2, #2
	uxth	r2, r2
	cmp	r2, r1
	bne	.L1464
	b	.L1447
.L1463:
	cmp	r5, #10
	bne	.L1465
	ldr	r2, .L1492+4
.L1466:
	strh	r3, [r2, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	cmp	r3, #63
	bne	.L1466
	ldr	r2, .L1492+16
	movw	r1, #961
.L1467:
	strh	r3, [r2, #2]!	@ movhi
	adds	r3, r3, #2
	uxth	r3, r3
	cmp	r3, r1
	bne	.L1467
	b	.L1447
.L1465:
	cmp	r5, #11
	bne	.L1468
	ldr	r2, .L1492+4
	movs	r3, #0
.L1469:
	strh	r3, [r2, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	cmp	r3, #8
	bne	.L1469
	ldr	r1, .L1492+20
.L1471:
	tst	r3, #1
	ite	ne
	movne	r2, #7
	moveq	r2, #6
	rsb	r2, r2, r3, lsl #1
	adds	r3, r3, #1
	uxth	r3, r3
	strh	r2, [r1, #2]!	@ movhi
	cmp	r3, #512
	bne	.L1471
	b	.L1447
.L1468:
	cmp	r5, #13
	bne	.L1447
	ldr	r2, .L1492+24
	movs	r3, #0
.L1472:
	strh	r3, [r2, #2]!	@ movhi
	adds	r3, r3, #3
	uxth	r3, r3
	cmp	r3, #1536
	bne	.L1472
	b	.L1447
.L1493:
	.align	2
.L1492:
	.word	.LANCHOR16
	.word	.LANCHOR3
	.word	.LANCHOR145
	.word	.LANCHOR3+30
	.word	.LANCHOR3+124
	.word	.LANCHOR3+14
	.word	.LANCHOR3-2
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
	ldr	r3, .L1511
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L1495
	ldr	r1, .L1511+4
	ldr	r0, .L1511+8
	bl	printf
.L1495:
	ldr	r4, .L1511+12
	movs	r6, #0
	ldr	r5, .L1511+16
	ldr	r7, .L1511+20
	ldrh	r3, [r4, #26]
	ldrb	r1, [r4, #12]	@ zero_extendqisi2
	ldrh	r0, [r4, #10]
	strh	r3, [r7]	@ movhi
	strb	r6, [r5]
	bl	__aeabi_idiv
	ldr	r10, .L1511+48
	movs	r2, #8
	ldr	r3, .L1511+24
	mov	r1, r6
	mov	r8, r10
	strh	r0, [r3]	@ movhi
	ldr	r0, .L1511+28
	bl	ftl_memset
	movs	r2, #32
	mov	r1, r6
	ldr	r0, .L1511+32
	bl	ftl_memset
.L1497:
	ldr	r3, .L1511+36
	movs	r2, #2
	add	r1, r10, r6, lsl #3
	ldr	r0, .L1511+40
	strb	r2, [r6, r3]
	ldrb	r2, [r4]	@ zero_extendqisi2
	bl	flash_mem_cmp8
	cbnz	r0, .L1496
	ldrb	r3, [r5]	@ zero_extendqisi2
	ldr	r2, .L1511+32
	str	r0, [r2, r3, lsl #2]
	adds	r2, r3, #1
	strb	r2, [r5]
	uxtb	r0, r6
	ldr	r2, .L1511+28
	strb	r0, [r2, r3]
	bl	zftl_flash_enter_slc_mode
.L1496:
	adds	r6, r6, #1
	cmp	r6, #4
	bne	.L1497
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	cmp	r3, #2
	beq	.L1498
.L1502:
	ldrb	r2, [r4, #13]	@ zero_extendqisi2
	ldrb	r3, [r5]	@ zero_extendqisi2
	smulbb	r3, r3, r2
	ldrh	r2, [r4, #14]
	smulbb	r3, r3, r2
	ldr	r2, .L1511+44
	strh	r3, [r2]	@ movhi
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1498:
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
	ldr	r3, .L1511+28
.L1501:
	mov	r2, r10
	add	r1, r8, r7, lsl #3
	ldr	r0, .L1511+40
	str	r3, [sp, #4]
	bl	flash_mem_cmp8
	ldr	r3, [sp, #4]
	cbnz	r0, .L1499
	ldr	r1, [sp]
	ldrb	r2, [r5]	@ zero_extendqisi2
	ldr	r0, .L1511+32
	cmp	fp, #0
	it	eq
	moveq	r1, r6
	strb	r7, [r3, r2]
	str	r1, [r0, r2, lsl #2]
	adds	r1, r2, #1
	strb	r1, [r5]
.L1499:
	adds	r7, r7, #1
	cmp	r7, #4
	bne	.L1501
	b	.L1502
.L1512:
	.align	2
.L1511:
	.word	.LANCHOR14
	.word	.LANCHOR146
	.word	.LC1
	.word	.LANCHOR33
	.word	.LANCHOR18
	.word	.LANCHOR2
	.word	.LANCHOR147
	.word	.LANCHOR30
	.word	.LANCHOR148
	.word	.LANCHOR34
	.word	.LANCHOR33+1
	.word	.LANCHOR149
	.word	.LANCHOR48
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
	ldr	r0, .L1514
	bl	ftl_memset
	ldr	r3, .L1514+4
	movs	r1, #255
	ldr	r2, .L1514+8
	ldrh	r3, [r3]
	ldrb	r2, [r2]	@ zero_extendqisi2
	muls	r2, r3, r2
	ldr	r3, .L1514+12
	ldr	r0, [r3]
	lsls	r2, r2, #2
	pop	{r3, lr}
	b	ftl_memset
.L1515:
	.align	2
.L1514:
	.word	.LANCHOR116
	.word	.LANCHOR95
	.word	.LANCHOR80
	.word	.LANCHOR118
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
	ldr	r3, .L1527
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L1517
	movs	r3, #0
	movs	r2, #239
	ldr	r1, .L1527+4
	ldr	r0, .L1527+8
	bl	printf
.L1517:
	ldr	r6, .L1527+12
	mov	r2, #512
	ldr	r4, .L1527+16
	movs	r1, #255
	ldr	r0, .L1527+20
	bl	ftl_memset
	ldrh	r3, [r4]
	movs	r1, #255
	ldrb	r2, [r6]	@ zero_extendqisi2
	ldr	r5, .L1527+24
	muls	r2, r3, r2
	ldr	r0, [r5]
	lsls	r2, r2, #2
	bl	ftl_memset
	ldr	r3, .L1527+28
	movs	r2, #0
	ldrb	r6, [r6]	@ zero_extendqisi2
	ldr	ip, [r5]
	ldr	r7, [r3]
	ldr	r0, .L1527+20
.L1518:
	ldrh	r3, [r4]
	uxth	r5, r2
	mov	r1, r5
	muls	r3, r6, r3
	cmp	r5, r3, lsl #1
	blt	.L1520
	pop	{r3, r4, r5, r6, r7, pc}
.L1520:
	ldr	r3, [r7, r1, lsl #2]
	adds	r2, r2, #1
	cmp	r3, #-1
	itttt	ne
	uxtbne	r3, r3
	ldrhne	lr, [r0, r3, lsl #1]
	strhne	r5, [r0, r3, lsl #1]	@ movhi
	strhne	lr, [ip, r1, lsl #1]	@ movhi
	b	.L1518
.L1528:
	.align	2
.L1527:
	.word	.LANCHOR14
	.word	.LANCHOR150
	.word	.LC84
	.word	.LANCHOR80
	.word	.LANCHOR95
	.word	.LANCHOR116
	.word	.LANCHOR118
	.word	.LANCHOR117
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
	ldr	r1, .L1532
	movs	r2, #0
	ldr	r3, .L1532+4
	strb	r2, [r4, #10]
	ldrb	r0, [r1, #9]	@ zero_extendqisi2
	ldrh	r3, [r3]
	smulbb	r3, r3, r0
	uxth	r3, r3
	strb	r3, [r4, #4]
	lsrs	r3, r3, #8
	strb	r3, [r4, #5]
	ldr	r3, .L1532+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	strb	r3, [r4, #7]
	ldr	r3, .L1532+12
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
	ldr	r0, .L1532+16
	strb	r3, [r4, #9]
	ldr	r3, .L1532+20
	ldrb	r1, [r3]	@ zero_extendqisi2
	mov	r3, r2
.L1530:
	uxtb	r2, r3
	cmp	r1, r2
	bhi	.L1531
	pop	{r4, r5, r6, pc}
.L1531:
	ldrb	r2, [r3, r0]	@ zero_extendqisi2
	adds	r3, r3, #1
	ldrb	r6, [r4, #10]	@ zero_extendqisi2
	lsl	r2, r5, r2
	orrs	r2, r2, r6
	strb	r2, [r4, #10]
	b	.L1530
.L1533:
	.align	2
.L1532:
	.word	.LANCHOR33
	.word	.LANCHOR2
	.word	.LANCHOR50
	.word	.LANCHOR68
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
	@ args = 0, pretend = 0, frame = 32
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r0, .L1653
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #48
	ldr	r3, [r0]
	ldr	r3, [r3, #32]
	cmp	r3, #10240
	bls	.L1535
	bl	ftl_tmp_into_update
.L1535:
	ldr	r3, .L1653+4
	ldr	r3, [r3]
	ldr	r2, [r3, #568]
	ldr	r1, [r3, #12]
	add	r4, r2, #35840
	adds	r4, r4, #160
	cmp	r1, r4
	bcs	.L1536
	ldr	r5, [r0]
	ldr	r4, [r3, #572]
	ldr	r5, [r5, #36]
	add	r4, r4, #256
	cmp	r5, r4
	bcc	.L1590
.L1536:
	add	r2, r2, #860160
	add	r2, r2, #3840
	cmp	r1, r2
	bhi	.L1538
	ldr	r4, [r0]
	ldr	r2, [r3, #572]
	ldr	r4, [r4, #36]
	adds	r2, r2, #32
	cmp	r4, r2
	bls	.L1591
.L1538:
	ldr	r2, [r0]
	movw	r4, #65535
	ldr	r10, .L1653+12
	mov	fp, r4
	movs	r5, #0
	ldrh	r7, [r2, #134]
	ldr	r0, [r2, #36]
	str	r5, [sp, #24]
	str	r1, [r3, #568]
	str	r0, [r3, #572]
	str	r5, [sp, #40]
	str	r5, [sp, #44]
	str	r5, [sp, #36]
	str	r5, [sp, #32]
	str	r5, [sp, #20]
	str	r5, [sp, #28]
.L1540:
	ldr	r3, .L1653+8
	ldrh	r3, [r3]
	cmp	r3, r7
	bhi	.L1551
	ldr	r7, .L1653+4
	movs	r3, #0
	movs	r1, #255
	movs	r2, #128
	ldr	r0, [r7]
	strh	r3, [r0, #122]	@ movhi
	add	r0, r0, #264
	bl	ftl_memset
	ldr	r3, [r7]
	ldrh	r7, [r3, #586]
	ldr	r3, .L1653+12
	ldr	r8, [r3]
	ldr	r3, .L1653+16
	ldr	r3, [r3]
	add	r10, r8, r7, lsl #2
	lsls	r1, r3, #21
	bpl	.L1552
	ldr	r1, .L1653+20
	ldr	r3, [r8, r7, lsl #2]
	ldrh	r2, [r8, r7, lsl #2]
	ldr	r1, [r1]
	ubfx	r3, r3, #11, #8
	ldr	r0, .L1653+24
	ubfx	r2, r2, #0, #11
	ldrh	r1, [r1, r7, lsl #1]
	str	r1, [sp, #12]
	ldrb	r1, [r10, #3]	@ zero_extendqisi2
	str	r1, [sp, #8]
	ldrb	r1, [r10, #2]	@ zero_extendqisi2
	lsrs	r1, r1, #5
	str	r1, [sp, #4]
	ldrb	r1, [r10, #2]	@ zero_extendqisi2
	ubfx	r1, r1, #3, #2
	str	r1, [sp]
	mov	r1, r7
	bl	printf
.L1552:
	ldrb	r3, [r10, #2]	@ zero_extendqisi2
	and	r1, r3, #224
	cmp	r1, #32
	bne	.L1553
	ldr	r2, .L1653
	ldr	r2, [r2]
	ldrh	r2, [r2, #688]
	cmp	r2, #2
	ittt	hi
	ldrhi	r2, .L1653+28
	movhi	r0, #1
	strhi	r0, [r2]
.L1553:
	lsls	r2, r3, #28
	bpl	.L1554
	ldr	r2, .L1653
	ldr	r2, [r2]
	ldrh	r0, [r2, #96]
	ldr	r2, .L1653+32
	ldrh	ip, [r2]
	ldrh	r2, [r8, r7, lsl #2]
	ubfx	r2, r2, #0, #11
	add	r2, r2, ip, lsr #2
	cmp	r0, r2
	ble	.L1554
	and	r3, r3, #192
	ldr	r7, .L1653+4
	cmp	r3, #64
	bne	.L1555
	ldr	r3, [r7]
	movs	r2, #1
	movs	r1, #0
	ldrh	r0, [r3, #586]
	bl	gc_add_sblk
	ldr	r3, .L1653+36
	movs	r2, #1
	strh	r2, [r3, #2106]	@ movhi
.L1554:
	ldr	r3, .L1653+4
	ldr	r3, [r3]
	ldrh	r7, [r3, #584]
	ldr	r3, .L1653+12
	ldr	r8, [r3]
	ldr	r3, .L1653+16
	ldr	r3, [r3]
	add	r10, r8, r7, lsl #2
	lsls	r6, r3, #21
	bpl	.L1556
	ldr	r1, .L1653+20
	ldr	r3, [r8, r7, lsl #2]
	ldrh	r2, [r8, r7, lsl #2]
	ldr	r1, [r1]
	ubfx	r3, r3, #11, #8
	ldr	r0, .L1653+40
	ubfx	r2, r2, #0, #11
	ldrh	r1, [r1, r7, lsl #1]
	str	r1, [sp, #12]
	ldrb	r1, [r10, #3]	@ zero_extendqisi2
	str	r1, [sp, #8]
	ldrb	r1, [r10, #2]	@ zero_extendqisi2
	lsrs	r1, r1, #5
	str	r1, [sp, #4]
	ldrb	r1, [r10, #2]	@ zero_extendqisi2
	ubfx	r1, r1, #3, #2
	str	r1, [sp]
	mov	r1, r7
	bl	printf
.L1556:
	ldrb	r3, [r10, #2]	@ zero_extendqisi2
	lsls	r0, r3, #28
	bpl	.L1557
	ldr	r2, .L1653
	ldr	r2, [r2]
	ldrh	r1, [r2, #98]
	ldr	r2, .L1653+44
	ldrh	r0, [r2]
	ldr	r2, [r8, r7, lsl #2]
	ubfx	r2, r2, #11, #8
	add	r2, r2, r0, lsr #2
	cmp	r1, r2
	ble	.L1557
	and	r2, r3, #192
	cmp	r2, #64
	bne	.L1558
	ldr	r3, .L1653+4
	movs	r2, #1
	movs	r1, #0
	ldr	r3, [r3]
	ldrh	r0, [r3, #584]
	bl	gc_add_sblk
	ldr	r3, .L1653+36
	movs	r2, #1
	strh	r2, [r3, #2106]	@ movhi
.L1557:
	ldr	r3, .L1653+16
	ldr	r3, [r3]
	lsls	r1, r3, #21
	bpl	.L1559
	ldr	r3, .L1653+12
	ldr	r1, .L1653+20
	ldr	r2, [r3]
	ldr	r1, [r1]
	ldr	r3, [r2, r5, lsl #2]
	ldrh	r1, [r1, r5, lsl #1]
	add	r0, r2, r5, lsl #2
	ldrh	r2, [r2, r5, lsl #2]
	ubfx	r3, r3, #11, #8
	str	r1, [sp, #12]
	ldrb	r1, [r0, #3]	@ zero_extendqisi2
	ubfx	r2, r2, #0, #11
	str	r1, [sp, #8]
	ldrb	r1, [r0, #2]	@ zero_extendqisi2
	lsrs	r1, r1, #5
	str	r1, [sp, #4]
	ldrb	r1, [r0, #2]	@ zero_extendqisi2
	ldr	r0, .L1653+48
	ubfx	r1, r1, #3, #2
	str	r1, [sp]
	mov	r1, r5
	bl	printf
.L1559:
	ldr	r3, .L1653+16
	ldr	r3, [r3]
	lsls	r2, r3, #21
	bpl	.L1560
	ldr	r3, .L1653+12
	ldr	r1, [sp, #24]
	ldr	r5, [sp, #24]
	ldr	r2, [r3]
	ldr	r3, [sp, #24]
	add	r0, r2, r3, lsl #2
	ldr	r3, [r2, r3, lsl #2]
	ldrh	r2, [r2, r1, lsl #2]
	ldr	r1, .L1653+20
	ubfx	r3, r3, #11, #8
	ubfx	r2, r2, #0, #11
	ldr	r1, [r1]
	ldrh	r1, [r1, r5, lsl #1]
	str	r1, [sp, #12]
	ldrb	r1, [r0, #3]	@ zero_extendqisi2
	str	r1, [sp, #8]
	ldrb	r1, [r0, #2]	@ zero_extendqisi2
	lsrs	r1, r1, #5
	str	r1, [sp, #4]
	ldrb	r1, [r0, #2]	@ zero_extendqisi2
	ldr	r0, .L1653+52
	ubfx	r1, r1, #3, #2
	str	r1, [sp]
	mov	r1, r5
	bl	printf
.L1560:
	ldr	r6, .L1653
	ldrh	r3, [sp, #20]
	ldr	r1, [sp, #32]
	ldr	r5, [r6]
	ldr	r0, [sp, #40]
	strh	r3, [r5, #96]	@ movhi
	ldrh	r3, [sp, #28]
	strh	r4, [r5, #92]	@ movhi
	strh	fp, [r5, #94]	@ movhi
	strh	r3, [r5, #98]	@ movhi
	bl	__aeabi_uidiv
	ldr	r1, [sp, #36]
	mov	r7, r0
	strh	r0, [r5, #88]	@ movhi
	ldr	r0, [sp, #44]
	bl	__aeabi_uidiv
	strh	r0, [r5, #90]	@ movhi
	ldr	r5, .L1653+16
	ldr	r3, [r5]
	lsls	r3, r3, #21
	bpl	.L1561
	uxth	r0, r0
	uxth	r3, r7
	ldr	r2, [sp, #36]
	str	r0, [sp]
	ldr	r1, [sp, #32]
	ldr	r0, .L1653+56
	bl	printf
.L1561:
	ldr	r3, [r5]
	ldr	r5, .L1653+44
	tst	r3, #1024
	beq	.L1562
	ldrh	r3, [r5]
	mov	r2, fp
	mov	r1, r4
	ldr	r0, .L1653+60
	str	r3, [sp, #8]
	b	.L1654
.L1655:
	.align	2
.L1653:
	.word	.LANCHOR110
	.word	.LANCHOR10
	.word	.LANCHOR6
	.word	.LANCHOR7
	.word	.LANCHOR14
	.word	.LANCHOR9
	.word	.LC86
	.word	.LANCHOR151
	.word	.LANCHOR152
	.word	.LANCHOR71
	.word	.LC87
	.word	.LANCHOR153
	.word	.LC88
	.word	.LC89
	.word	.LC90
	.word	.LC91
.L1654:
	ldr	r3, .L1656
	ldrh	r3, [r3]
	str	r3, [sp, #4]
	ldr	r3, [sp, #28]
	str	r3, [sp]
	ldr	r3, [sp, #20]
	bl	printf
.L1562:
	ldr	r3, [sp, #28]
	sub	r3, r3, fp
	str	r3, [sp, #24]
	ldr	r2, [sp, #24]
	ldrh	r3, [r5]
	cmp	r2, r3
	bgt	.L1563
	ldr	r2, .L1656
	ldr	r3, [sp, #20]
	ldrh	r2, [r2]
	subs	r3, r3, r4
	cmp	r3, r2
	ble	.L1592
.L1563:
	ldr	r3, .L1656+4
	mov	r8, #0
	ldr	r3, [r3]
	ldrh	r5, [r3, #580]
	ldr	r3, [r6]
	mov	r6, r8
	ldrh	r10, [r3, #134]
.L1565:
	ldr	r3, .L1656+8
	ldrh	r3, [r3]
	cmp	r10, r3
	bcc	.L1575
.L1574:
	ldr	r3, .L1656+4
	ldr	r3, [r3]
	str	r5, [r3, #580]
.L1564:
	cmp	fp, #0
	beq	.L1577
	ldr	r3, .L1656+12
	ldr	r1, [r3]
	ldr	r3, .L1656+8
	ldrh	r2, [r1, #134]
	ldrh	r7, [r3]
	ldr	r3, .L1656+16
	ldr	r3, [r3]
	add	r3, r3, r2, lsl #2
.L1578:
	cmp	r2, r7
	bcc	.L1580
	ldrh	r3, [r1, #72]
	add	r3, r3, fp
	strh	r3, [r1, #72]	@ movhi
	ldrh	r3, [r1, #98]
	cmp	fp, r3
	itt	cc
	subcc	r3, r3, fp
	strhcc	r3, [r1, #98]	@ movhi
.L1577:
	cbz	r4, .L1583
	ldr	r3, .L1656+12
	ldr	r1, [r3]
	ldr	r3, .L1656+8
	ldrh	r2, [r1, #134]
	ldrh	ip, [r3]
	ldr	r3, .L1656+16
	ldr	r3, [r3]
	add	r3, r3, r2, lsl #2
.L1584:
	cmp	r2, ip
	bcc	.L1586
	ldrh	r3, [r1, #74]
	add	r3, r3, r4
	strh	r3, [r1, #74]	@ movhi
	ldrh	r3, [r1, #96]
	cmp	r4, r3
	itt	cc
	subcc	r4, r3, r4
	strhcc	r4, [r1, #96]	@ movhi
.L1583:
	movs	r1, #5
	movs	r0, #0
	bl	zftl_get_gc_node
	movw	r2, #65535
	cmp	r0, r2
	beq	.L1539
	ldr	r2, .L1656+20
	ldr	r1, [r2]
	ldr	r2, .L1656+24
	ldrh	r3, [r1, r0, lsl #1]
	ldrh	r2, [r2]
	cmp	r3, r2, lsr #1
	bhi	.L1539
	adds	r6, r6, #1
	movs	r2, #1
	movs	r1, #0
	bl	gc_add_sblk
.L1539:
	add	r0, r6, r8
.L1534:
	add	sp, sp, #48
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1551:
	ldr	r0, [r10]
	lsls	r1, r7, #2
	add	ip, r0, r1
	ldrb	r3, [ip, #2]	@ zero_extendqisi2
	and	r2, r3, #224
	cmp	r2, #224
	beq	.L1541
	ubfx	lr, r3, #3, #2
	tst	lr, #1
	beq	.L1542
	ldrh	r3, [r0, r1]
	ldr	r2, [r0, r1]
	ubfx	r3, r3, #0, #11
	ubfx	r2, r2, #11, #8
.L1543:
	ldr	r6, [sp, #32]
	cmp	r4, r3
	add	r8, r6, #1
	uxth	r6, r8
	str	r6, [sp, #32]
	ldr	r6, [sp, #40]
	add	r6, r6, r3
	str	r6, [sp, #40]
	bls	.L1589
	ldr	r4, .L1656+4
	ldr	r4, [r4]
	strh	r7, [r4, #586]	@ movhi
	mov	r4, r3
.L1589:
	ldr	r6, [sp, #20]
	movw	r8, #65535
	cmp	r6, r3
	itt	cc
	movcc	r5, r7
	strcc	r3, [sp, #20]
	cmp	r2, r8
	bne	.L1545
.L1547:
	cmp	r3, #9
	bls	.L1550
.L1541:
	adds	r7, r7, #1
	uxth	r7, r7
	b	.L1540
.L1542:
	tst	r3, #24
	bne	.L1544
	ldrh	r3, [r0, r1]
	movw	r2, #65535
	ubfx	r3, r3, #0, #11
	b	.L1543
.L1544:
	ldr	r3, [r0, r1]
	ubfx	r2, r3, #11, #8
	movw	r3, #65535
.L1545:
	ldr	r6, [sp, #36]
	cmp	fp, r2
	it	hi
	movhi	fp, r2
	add	r8, r6, #1
	uxth	r6, r8
	it	hi
	ldrhi	r8, .L1656+4
	str	r6, [sp, #36]
	ldr	r6, [sp, #44]
	it	hi
	ldrhi	r8, [r8]
	add	r6, r6, r2
	str	r6, [sp, #44]
	ldr	r6, [sp, #28]
	it	hi
	strhhi	r7, [r8, #584]	@ movhi
	cmp	r6, r2
	itt	cc
	strcc	r7, [sp, #24]
	strcc	r2, [sp, #28]
	cmp	r2, #9
	bhi	.L1547
.L1550:
	ldr	r3, .L1656+28
	ldr	r3, [r3]
	lsls	r6, r3, #23
	bpl	.L1541
	ldr	r3, [r0, r1]
	ldrh	r2, [r0, r1]
	ldr	r1, .L1656+20
	ubfx	r3, r3, #11, #8
	ldr	r0, .L1656+32
	ubfx	r2, r2, #0, #11
	ldr	r1, [r1]
	ldrh	r1, [r1, r7, lsl #1]
	str	r1, [sp, #12]
	ldrb	r1, [ip, #3]	@ zero_extendqisi2
	str	r1, [sp, #8]
	ldrb	r1, [ip, #2]	@ zero_extendqisi2
	str	lr, [sp]
	lsrs	r1, r1, #5
	str	r1, [sp, #4]
	mov	r1, r7
	bl	printf
	b	.L1541
.L1555:
	cmp	r1, #0
	bne	.L1554
	ldr	r3, [r7]
	movw	r2, #65535
	ldrh	r8, [r3, #590]
	cmp	r8, r2
	bne	.L1554
	ldrh	r0, [r3, #586]
	ldrh	r3, [r3, #588]
	cmp	r3, r0
	beq	.L1554
	bl	zftl_remove_free_node
	ldr	r3, [r7]
	ldrh	r2, [r3, #586]
	strh	r8, [r3, #586]	@ movhi
	strh	r2, [r3, #590]	@ movhi
	b	.L1554
.L1558:
	and	r3, r3, #248
	cmp	r3, #16
	bne	.L1557
	ldr	r8, .L1656+4
	movw	r2, #65535
	ldr	r3, [r8]
	ldrh	r7, [r3, #588]
	cmp	r7, r2
	bne	.L1557
	ldrh	r0, [r3, #584]
	ldrh	r3, [r3, #590]
	cmp	r3, r0
	beq	.L1557
	bl	zftl_remove_free_node
	ldr	r3, [r8]
	ldrh	r2, [r3, #584]
	strh	r7, [r3, #584]	@ movhi
	strh	r2, [r3, #588]	@ movhi
	b	.L1557
.L1657:
	.align	2
.L1656:
	.word	.LANCHOR152
	.word	.LANCHOR10
	.word	.LANCHOR6
	.word	.LANCHOR110
	.word	.LANCHOR7
	.word	.LANCHOR9
	.word	.LANCHOR95
	.word	.LANCHOR14
	.word	.LC85
.L1575:
	adds	r5, r5, #1
	uxth	r5, r5
	cmp	r3, r5
	it	ls
	movls	r5, #0
	ldr	r3, .L1658
	lsls	r7, r5, #2
	ldr	r3, [r3]
	adds	r2, r3, r7
	ldrb	r2, [r2, #2]	@ zero_extendqisi2
	tst	r2, #192
	beq	.L1567
	and	r0, r2, #224
	cmp	r0, #224
	beq	.L1567
	ubfx	r2, r2, #3, #2
	ands	r1, r2, #1
	beq	.L1568
	cmp	r0, #160
.L1651:
	bne	.L1570
	ldr	r2, .L1658+4
	ldr	r0, [sp, #24]
	ldrh	r2, [r2]
	cmp	r0, r2
	ble	.L1571
	ldr	r2, [r3, r7]
	ubfx	r2, r2, #11, #8
	cmp	r2, fp
	bls	.L1572
	cbz	r1, .L1571
	ldrh	r2, [r3, r7]
	ubfx	r2, r2, #0, #11
	cmp	r2, r4
	bgt	.L1571
.L1572:
	movs	r2, #1
	movs	r1, #0
	mov	r0, r5
	str	r3, [sp, #28]
	bl	gc_add_sblk
	ldr	r0, .L1658+8
	movs	r2, #1
	add	r6, r6, r2
	ldr	r3, [sp, #28]
	strh	r2, [r0, #2106]	@ movhi
	ldr	r2, .L1658+12
	ldr	r2, [r2]
	tst	r2, #1024
	beq	.L1571
	ldr	r2, .L1658+16
	ldr	r1, [r3, r7]
	ldr	r2, [r2]
	ubfx	r1, r1, #11, #8
	ldrh	ip, [r2, r5, lsl #1]
	ldr	r2, .L1658
	ldr	r2, [r2]
	add	r2, r2, r7
	ldrb	r2, [r2, #2]	@ zero_extendqisi2
	str	r1, [sp, #8]
	ldrh	r1, [r3, r7]
	lsrs	r2, r2, #5
	ubfx	r1, r1, #0, #11
	str	r1, [sp, #4]
	mov	r1, r5
	ldrh	r3, [r0, #52]
	ldr	r0, .L1658+20
	str	r3, [sp]
	mov	r3, ip
.L1652:
	bl	printf
.L1571:
	cmp	r6, #4
	bhi	.L1574
	cmp	r8, #4
	bhi	.L1574
.L1567:
	add	r10, r10, #1
	uxth	r10, r10
	b	.L1565
.L1568:
	cmp	r2, #2
	b	.L1651
.L1570:
	ldr	r0, .L1658+24
	ldr	r2, [sp, #20]
	ldrh	r0, [r0]
	subs	r2, r2, r4
	cmp	r2, r0
	ble	.L1571
	ldrh	r2, [r3, r7]
	add	r0, r4, #8
	ubfx	r2, r2, #0, #11
	cmp	r2, r0
	ble	.L1573
	cmp	r1, #0
	beq	.L1571
	ldr	r2, [r3, r7]
	add	r1, fp, #4
	ubfx	r2, r2, #11, #8
	cmp	r2, r1
	bgt	.L1571
.L1573:
	movs	r2, #1
	movs	r1, #0
	mov	r0, r5
	str	r3, [sp, #28]
	bl	gc_add_sblk
	ldr	r0, .L1658+8
	movs	r2, #1
	add	r8, r8, r2
	ldr	r3, [sp, #28]
	strh	r2, [r0, #2106]	@ movhi
	ldr	r2, .L1658+12
	ldr	r2, [r2]
	tst	r2, #1024
	beq	.L1571
	ldr	r2, .L1658+16
	ldr	r1, [r3, r7]
	ldr	r2, [r2]
	ubfx	r1, r1, #11, #8
	ldrh	ip, [r2, r5, lsl #1]
	ldr	r2, .L1658
	ldr	r2, [r2]
	add	r2, r2, r7
	ldrb	r2, [r2, #2]	@ zero_extendqisi2
	str	r1, [sp, #8]
	ldrh	r1, [r3, r7]
	lsrs	r2, r2, #5
	ubfx	r1, r1, #0, #11
	str	r1, [sp, #4]
	mov	r1, r5
	ldrh	r3, [r0, #52]
	ldr	r0, .L1658+28
	str	r3, [sp]
	mov	r3, ip
	b	.L1652
.L1592:
	mov	r8, #0
	mov	r6, r8
	b	.L1564
.L1580:
	ldr	r0, [r3]
	ubfx	r5, r0, #11, #8
	cmp	fp, r5
	bhi	.L1579
	ldrb	ip, [r3, #2]	@ zero_extendqisi2
	tst	ip, #24
	ittt	ne
	subne	r5, r5, fp
	bfine	r0, r5, #11, #8
	strne	r0, [r3]
.L1579:
	adds	r2, r2, #1
	adds	r3, r3, #4
	uxth	r2, r2
	b	.L1578
.L1586:
	ldrh	r0, [r3]
	ubfx	r5, r0, #0, #11
	cmp	r5, r4
	blt	.L1585
	ldrb	r7, [r3, #2]	@ zero_extendqisi2
	and	r7, r7, #24
	cmp	r7, #16
	ittt	ne
	subne	r5, r5, r4
	bfine	r0, r5, #0, #11
	strhne	r0, [r3]	@ movhi
.L1585:
	adds	r2, r2, #1
	adds	r3, r3, #4
	uxth	r2, r2
	b	.L1584
.L1591:
	mov	r8, #0
	mov	r6, r8
	b	.L1539
.L1590:
	movs	r0, #0
	b	.L1534
.L1659:
	.align	2
.L1658:
	.word	.LANCHOR7
	.word	.LANCHOR153
	.word	.LANCHOR71
	.word	.LANCHOR14
	.word	.LANCHOR9
	.word	.LC92
	.word	.LANCHOR152
	.word	.LC93
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
	ldr	r8, .L1692+84
	sub	sp, sp, #24
	movs	r1, #0
	movs	r4, #0
	ldr	fp, .L1692+88
	ldrh	r3, [r8]
	ldr	r6, .L1692
	ldr	r0, [fp]
	ldr	r10, .L1692+80
	muls	r2, r3, r2
	ldr	r7, .L1692+4
	bl	ftl_memset
	ldr	r3, .L1692+8
	movs	r2, #32
	ldr	r1, .L1692+12
	mov	r0, #32768
	strh	r4, [r10]	@ movhi
	str	r4, [r3]
	ldr	r3, .L1692+16
	ldrh	r1, [r1]
	strh	r4, [r7]	@ movhi
	str	r4, [r3]
	ldr	r3, .L1692+20
	str	r4, [r3]
	ldr	r3, .L1692+24
	str	r4, [r3]
	ldr	r3, .L1692+28
	str	r4, [r3]
	ldr	r3, .L1692+32
	str	r4, [r3]
	ldr	r3, .L1692+36
	strh	r2, [r3]	@ movhi
	ldr	r2, .L1692+40
	ldr	r3, .L1692+44
	strh	r4, [r2]	@ movhi
	ldr	r2, .L1692+48
	strh	r4, [r3]	@ movhi
	str	r3, [sp, #4]
	strh	r4, [r2]	@ movhi
	ldr	r2, .L1692+52
	strh	r4, [r2]	@ movhi
	ldrb	r2, [r6]	@ zero_extendqisi2
	muls	r1, r2, r1
	bl	__aeabi_idiv
	ldr	r2, .L1692+56
	sxth	r3, r0
	str	fp, [sp, #12]
	mov	fp, r10
	str	r3, [sp]
	ldr	r1, [r2]
	ldr	r3, [sp, #4]
	ldr	r10, .L1692+92
	ldrsh	r5, [r1, #134]
	str	r8, [sp, #8]
	mov	r8, r3
	strh	r4, [r1, #146]	@ movhi
	str	r2, [sp, #16]
	str	r6, [sp, #20]
.L1661:
	ldr	r3, [sp, #8]
	ldrh	r3, [r3]
	cmp	r5, r3
	blt	.L1678
	ldr	r3, [sp, #16]
	ldrh	r2, [r8]
	ldr	r3, [r3]
	strh	r2, [r3, #114]	@ movhi
	ldrh	r2, [r7]
	strh	r2, [r3, #118]	@ movhi
	ldrh	r2, [fp]
	strh	r2, [r3, #116]	@ movhi
	ldr	r2, .L1692+40
	ldrh	r2, [r2]
	strh	r2, [r3, #122]	@ movhi
	ldr	r2, .L1692+48
	ldrh	r2, [r2]
	strh	r2, [r3, #120]	@ movhi
	ldr	r2, .L1692+52
	ldrh	r2, [r2]
	strh	r2, [r3, #124]	@ movhi
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1678:
	ldr	r6, [r10]
	add	r6, r6, r5, lsl #2
	ldrb	r0, [r6, #3]	@ zero_extendqisi2
	cmp	r0, #0
	beq	.L1679
	ldr	r3, [sp, #20]
	ldrb	lr, [r3]	@ zero_extendqisi2
	ldr	r3, .L1692+56
	ldr	ip, [r3]
	ldr	r3, .L1692+12
	ldrh	r3, [r3]
	str	r3, [sp, #4]
	movs	r3, #0
	mov	r1, r3
.L1663:
	cmp	r3, lr
	blt	.L1666
	cmp	r1, #0
	beq	.L1667
	mov	r0, #32768
	bl	__aeabi_idiv
	adds	r1, r0, #1
	sxth	r1, r1
.L1662:
	ldr	r3, [sp, #12]
	lsls	r0, r5, #1
	adds	r2, r0, r5
	ldr	r3, [r3]
	add	ip, r3, r2, lsl #1
	strh	r1, [ip, #4]	@ movhi
	movw	r1, #65535
	strh	r1, [ip, #2]	@ movhi
	strh	r1, [r3, r2, lsl #1]	@ movhi
	ldrb	r3, [r6, #2]	@ zero_extendqisi2
	and	r3, r3, #224
	cmp	r3, #32
	beq	.L1668
	cmp	r3, #224
	beq	.L1668
	ldr	r2, .L1692+60
	ldr	r2, [r2]
	ldrh	r1, [r2, #16]
	cmp	r5, r1
	beq	.L1668
	ldrh	r1, [r2, #48]
	cmp	r5, r1
	beq	.L1668
	ldrh	r2, [r2, #80]
	cmp	r5, r2
	beq	.L1668
	cmp	r3, #64
	bne	.L1669
	ldr	r2, .L1692+40
	uxth	r1, r5
	ldr	r0, .L1692+28
.L1690:
	bl	_insert_data_list
.L1668:
	adds	r5, r5, #1
	sxth	r5, r5
	b	.L1661
.L1666:
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
	b	.L1663
.L1667:
	ldrb	r3, [r6, #2]	@ zero_extendqisi2
	movw	r2, #65535
	orr	r3, r3, #224
	strb	r3, [r6, #2]
	ldr	r3, .L1692+64
	ldr	r3, [r3]
	strh	r2, [r3, r5, lsl #1]	@ movhi
	b	.L1662
.L1679:
	ldr	r1, [sp]
	b	.L1662
.L1669:
	cmp	r3, #96
	bne	.L1670
	ldr	r2, .L1692+52
	uxth	r1, r5
	ldr	r0, .L1692+24
	b	.L1690
.L1670:
	cmp	r3, #160
	bne	.L1671
	ldr	r2, .L1692+48
	uxth	r1, r5
	ldr	r0, .L1692+32
	b	.L1690
.L1671:
	cmp	r3, #0
	bne	.L1668
	ldr	r3, .L1692+64
	ldr	r3, [r3]
	ldrh	r2, [r3, r0]
	cbz	r2, .L1672
	cmp	r4, #2
	bgt	.L1673
	mov	r1, r5
	ldr	r0, .L1692+68
	bl	printf
	ldrb	r3, [r6, #2]	@ zero_extendqisi2
	adds	r4, r4, #1
	movs	r1, #1
	uxth	r0, r5
	sxth	r4, r4
	lsls	r2, r3, #27
	ite	mi
	movmi	r2, #5
	movpl	r2, #2
	bfi	r3, r2, #5, #3
	movs	r2, #0
	strb	r3, [r6, #2]
	bl	gc_add_sblk
	b	.L1668
.L1673:
	movw	r2, #651
	ldr	r1, .L1692+72
	ldr	r0, .L1692+76
	bl	printf
.L1672:
	ldrb	r3, [r6, #2]	@ zero_extendqisi2
	uxth	r1, r5
	ands	r3, r3, #24
	bne	.L1676
	ldr	r2, .L1692+44
	ldr	r0, .L1692+8
.L1691:
	bl	_insert_free_list
	b	.L1668
.L1676:
	cmp	r3, #16
	ittee	eq
	ldreq	r2, .L1692+4
	ldreq	r0, .L1692+16
	ldrne	r2, .L1692+80
	ldrne	r0, .L1692+20
	b	.L1691
.L1693:
	.align	2
.L1692:
	.word	.LANCHOR80
	.word	.LANCHOR105
	.word	.LANCHOR104
	.word	.LANCHOR86
	.word	.LANCHOR106
	.word	.LANCHOR108
	.word	.LANCHOR89
	.word	.LANCHOR12
	.word	.LANCHOR88
	.word	.LANCHOR109
	.word	.LANCHOR97
	.word	.LANCHOR103
	.word	.LANCHOR93
	.word	.LANCHOR99
	.word	.LANCHOR110
	.word	.LANCHOR10
	.word	.LANCHOR9
	.word	.LC94
	.word	.LANCHOR154
	.word	.LC0
	.word	.LANCHOR107
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
	ldr	r8, .L1701+12
	mov	r6, r1
	movs	r7, #0
.L1695:
	movw	r10, #65535
.L1696:
	mov	r0, r6
	bl	ftl_alloc_sblk
	cmp	r0, r10
	mov	r5, r0
	beq	.L1696
	movs	r1, #0
	ldr	r10, .L1701+16
	bl	ftl_erase_sblk
	add	r1, r4, #16
	mov	r0, r5
	bl	ftl_get_blk_list_in_sblk
	ldr	r1, .L1701
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
	ldr	r1, .L1701+4
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
	cbnz	r3, .L1694
	mov	r1, r5
	ldr	r0, .L1701+8
	bl	printf
	ldr	r3, [r10]
	movw	r2, #65535
	strh	r2, [r3, r5, lsl #1]	@ movhi
	movs	r3, #7
	strb	r3, [r4, #4]
	b	.L1695
.L1694:
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L1702:
	.align	2
.L1701:
	.word	.LANCHOR80
	.word	.LANCHOR117
	.word	.LC82
	.word	.LANCHOR95
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
	@ args = 0, pretend = 0, frame = 272
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #280
	ldr	r5, .L1728
	ldrh	r2, [r5]
	cmp	r2, #128
	bls	.L1704
	movs	r2, #94
	ldr	r1, .L1728+4
	ldr	r0, .L1728+8
	bl	printf
.L1704:
	ldr	r4, .L1728+12
	movs	r2, #0
	ldrh	r5, [r5]
	mov	r3, r2
	movw	r6, #65535
	ldr	r1, [r4]
	ldrh	r0, [r1, #688]
	add	r1, r1, #416
.L1707:
	ldrh	r7, [r1], #2
	cmp	r7, r6
	itt	ne
	addne	r2, r2, #1
	uxthne	r2, r2
	cmp	r2, r0
	bcs	.L1706
	cmp	r2, r5
	bcs	.L1706
	adds	r3, r3, #1
	uxth	r3, r3
	cmp	r3, #128
	bne	.L1707
.L1706:
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
	ldr	r2, .L1728+16
	ldr	r7, [r4]
	ldrh	r8, [r2]
	ldr	r2, .L1728+20
	add	r10, r7, #704
	ldrh	r3, [r7, #698]
	ldrb	r2, [r2]	@ zero_extendqisi2
	rsb	r2, r2, #24
	sub	r2, r2, r8
	lsls	r5, r5, r2
	ldr	r2, .L1728+24
	subs	r5, r5, #1
	ldrb	r2, [r2]	@ zero_extendqisi2
.L1709:
	uxth	r1, r6
	cmp	r3, r1
	bhi	.L1712
	ldr	r3, .L1728+28
	movs	r5, #0
	ldr	r2, .L1728+32
	movw	r10, #65535
	mov	r8, r5
	ldrb	r6, [r3]	@ zero_extendqisi2
	ldrh	r2, [r2]
	str	r3, [sp, #12]
	smulbb	r6, r6, r2
	uxth	r6, r6
.L1718:
	ldr	r2, [r4]
	add	r7, r5, #208
	uxth	fp, r5
	ldrh	r3, [r2, r7, lsl #1]
	ldrh	r0, [r2, #692]
	str	r2, [sp, #16]
	str	r3, [sp, #20]
	ldr	r3, .L1728+24
	ldrb	r1, [r3]	@ zero_extendqisi2
	bl	__aeabi_idiv
	ldr	r3, [sp, #20]
	ldr	r2, [sp, #16]
	cmp	r0, r3
	bne	.L1713
	ldr	r1, [sp, #12]
	ldr	r0, .L1728+32
	ldrb	r1, [r1]	@ zero_extendqisi2
	ldrh	r0, [r0]
	smulbb	r1, r1, r0
	add	r0, sp, #24
	strh	r1, [r0, r5, lsl #1]	@ movhi
.L1713:
	add	r1, sp, #24
	ldrh	r1, [r1, r5, lsl #1]
	cmp	r1, r6
	bcs	.L1714
	cmp	r1, #0
	itt	ne
	movne	r8, fp
	movne	r6, r1
.L1714:
	ldrh	r0, [r2, #74]
	cmp	r0, #2
	bls	.L1715
	movw	r0, #65535
	cmp	r3, r0
	beq	.L1715
	ldr	r0, .L1728+36
	ldrh	r2, [r2, #92]
	ldr	r0, [r0]
	adds	r2, r2, #4
	ldrh	r0, [r0, r3, lsl #2]
	ubfx	r0, r0, #0, #11
	cmp	r0, r2
	bgt	.L1715
	mov	r10, fp
	str	r0, [sp]
	mov	r2, r1
	ldr	r0, .L1728+40
	mov	r1, r5
	bl	printf
.L1715:
	add	r3, sp, #24
	ldrh	r2, [r3, r5, lsl #1]
	cbnz	r2, .L1716
	ldr	r1, [r4]
	movw	r0, #65535
	ldrh	r3, [r1, r7, lsl #1]
	cmp	r3, r0
	beq	.L1716
	ldr	r0, .L1728+44
	ldr	r0, [r0]
	lsls	r0, r0, #19
	bpl	.L1717
	ldrh	r1, [r1, #688]
	ldr	r0, .L1728+48
	str	r1, [sp]
	mov	r1, r5
	bl	printf
.L1717:
	ldr	r3, [r4]
	ldrh	r0, [r3, r7, lsl #1]
	bl	ftl_free_sblk
	ldr	r3, [r4]
	movw	r2, #65535
	strh	r2, [r3, r7, lsl #1]	@ movhi
	ldrh	r2, [r3, #688]
	subs	r2, r2, #1
	strh	r2, [r3, #688]	@ movhi
.L1716:
	adds	r5, r5, #1
	ldr	r2, [sp, #8]
	uxth	r3, r5
	cmp	r3, r2
	bcc	.L1718
	movw	r0, #65535
	cmp	r10, r0
	ite	ne
	movne	r0, r10
	moveq	r0, r8
	add	sp, sp, #280
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1712:
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
.L1711:
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
	bhi	.L1711
	adds	r6, r6, #1
	b	.L1709
.L1729:
	.align	2
.L1728:
	.word	.LANCHOR155
	.word	.LANCHOR156
	.word	.LC0
	.word	.LANCHOR110
	.word	.LANCHOR75
	.word	.LANCHOR32
	.word	.LANCHOR76
	.word	.LANCHOR80
	.word	.LANCHOR95
	.word	.LANCHOR7
	.word	.LC95
	.word	.LANCHOR14
	.word	.LC96
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
	ldr	r3, .L1736
	push	{r4, lr}
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L1732
	ldr	r2, .L1736+4
	movs	r1, #119
	ldr	r0, .L1736+8
	bl	printf
.L1732:
	ldr	r4, .L1736+12
	mov	r2, #2048
	movs	r1, #0
	ldr	r0, [r4]
	bl	ftl_memset
	ldr	r0, [r4]
	movs	r2, #32
	ldr	r3, .L1736+16
	ldr	r1, .L1736+20
	adds	r0, r0, #80
	str	r3, [r0, #-80]
	mov	r3, #2032
	str	r3, [r0, #-72]
	movs	r3, #1
	strh	r3, [r0, #-64]	@ movhi
	bl	ftl_memcpy
	ldr	r0, [r4]
	movs	r2, #32
	ldr	r1, .L1736+24
	pop	{r4, lr}
	adds	r0, r0, #48
	b	ftl_memcpy
.L1737:
	.align	2
.L1736:
	.word	.LANCHOR14
	.word	.LANCHOR157
	.word	.LC97
	.word	.LANCHOR27
	.word	1398362953
	.word	.LANCHOR20
	.word	.LANCHOR33
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
.L1739:
	cmp	r3, r2
	bne	.L1740
	pop	{r4, pc}
.L1740:
	ldr	r4, [r1, r3, lsl #2]
	str	r4, [r0, r3, lsl #2]
	adds	r3, r3, #1
	b	.L1739
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
	ldr	r0, .L1743
	bx	lr
.L1744:
	.align	2
.L1743:
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
	ldr	r6, .L1765
	sub	sp, sp, #20
	mov	r4, r0
	str	r3, [sp, #12]
	ldr	r3, [r6]
	lsls	r0, r3, #19
	bpl	.L1747
	mov	r2, r4
	ldr	r1, .L1765+4
	ldr	r0, .L1765+8
	bl	printf
.L1747:
	ldr	r1, [r4, #352]
	movs	r3, #6
	ldr	r2, .L1765+12
	ldr	r5, .L1765+16
	ldr	r7, .L1765+20
	cmp	r1, r2
	ldr	r2, [r4, #128]
	strb	r3, [r5]
	itt	eq
	moveq	r3, #8
	strbeq	r3, [r5]
	ldr	r3, .L1765+24
	str	r4, [r7]
	cmp	r2, r3
	ldr	r2, .L1765+28
	itt	eq
	moveq	r3, #9
	strbeq	r3, [r5]
	ldrb	r3, [r5]	@ zero_extendqisi2
	cmp	r3, #9
	ldr	r3, .L1765+32
	bne	.L1750
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
	bpl	.L1752
	ldr	r1, [r4]
	ldr	r2, [r4, #8]
	ldr	r3, [r4, #80]
	ldr	r0, [r4, #84]
	ldr	r4, [r4, #88]
	stm	sp, {r0, r4}
.L1764:
	ldr	r0, .L1765+36
	bl	printf
.L1752:
	ldr	r3, .L1765+40
	movs	r2, #1
	strb	r2, [r3]
	movs	r3, #0
	ldr	r2, .L1765+44
	strh	r3, [r2]	@ movhi
	ldr	r2, .L1765+48
	strb	r3, [r2]
	ldr	r3, [r6]
	lsls	r3, r3, #19
	bpl	.L1746
	ldrb	r1, [r5]	@ zero_extendqisi2
	ldr	r0, .L1765+52
	bl	printf
.L1746:
	add	sp, sp, #20
	@ sp needed
	pop	{r4, r5, r6, r7, pc}
.L1750:
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
	ldr	r3, .L1765+56
	str	r0, [r3]
	ldr	r3, [r6]
	lsls	r2, r3, #19
	bpl	.L1752
	ldr	r0, [r7]
	ldr	r1, [r0]
	ldr	r2, [r0, #344]
	ldr	r3, [r0, #304]
	ldr	r4, [r0, #308]
	ldr	r0, [r0, #312]
	str	r4, [sp]
	str	r0, [sp, #4]
	b	.L1764
.L1766:
	.align	2
.L1765:
	.word	.LANCHOR14
	.word	.LANCHOR158
	.word	.LC98
	.word	1446522928
	.word	.LANCHOR28
	.word	.LANCHOR13
	.word	1446588464
	.word	1052675
	.word	.LANCHOR51
	.word	.LC99
	.word	.LANCHOR52
	.word	.LANCHOR54
	.word	.LANCHOR50
	.word	.LC100
	.word	.LANCHOR53
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
	ldr	r4, .L1770
	mov	r6, r5
	ldr	r8, .L1770+12
	mov	r7, r4
.L1768:
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
	bne	.L1768
	movs	r3, #255
	strb	r3, [r7, #1488]
	ldr	r3, .L1770+4
	strb	r6, [r3]
	ldr	r3, .L1770+8
	strb	r5, [r3]
	pop	{r4, r5, r6, r7, r8, pc}
.L1771:
	.align	2
.L1770:
	.word	.LANCHOR56
	.word	.LANCHOR57
	.word	.LANCHOR58
	.word	.LANCHOR131
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
	ldr	r3, .L1773
	movw	r2, #2132
	push	{r4, r5, r6, lr}
	movs	r4, #0
	ldr	r5, .L1773+4
	mov	r1, r4
	strb	r4, [r3]
	ldr	r3, .L1773+8
	mov	r0, r5
	strb	r4, [r3]
	ldr	r3, .L1773+12
	str	r4, [r3]
	ldr	r3, .L1773+16
	strh	r4, [r3]	@ movhi
	bl	ftl_memset
	movw	r3, #65535
	str	r4, [r5, #8]
	strh	r3, [r5]	@ movhi
	ldr	r3, .L1773+20
	ldrh	r3, [r3]
	lsrs	r2, r3, #1
	lsrs	r1, r3, #2
	strh	r2, [r5, #34]	@ movhi
	ldr	r2, .L1773+24
	strh	r1, [r5, #32]	@ movhi
	ldr	r5, .L1773+28
	strh	r4, [r2]	@ movhi
	ldr	r2, .L1773+32
	strh	r4, [r2]	@ movhi
	ldr	r2, .L1773+36
	strh	r4, [r2]	@ movhi
	ldr	r4, .L1773+40
	ldrb	r0, [r4]	@ zero_extendqisi2
	smulbb	r2, r0, r3
	uxth	r2, r2
	sub	r6, r2, #32
	strh	r6, [r5]	@ movhi
	ldr	r5, .L1773+44
	strh	r2, [r5]	@ movhi
	ldr	r2, .L1773+48
	ldr	r5, .L1773+52
	strh	r3, [r2]	@ movhi
	movs	r2, #4
	ldr	r3, .L1773+56
	strh	r2, [r3]	@ movhi
	ldr	r3, .L1773+60
	strh	r1, [r3]	@ movhi
	ldrh	r3, [r5]
	muls	r0, r3, r0
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L1773+64
	str	r0, [r3]
	ldrh	r3, [r5]
	ldrb	r0, [r4]	@ zero_extendqisi2
	muls	r0, r3, r0
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L1773+68
	str	r0, [r3]
	ldrh	r3, [r5]
	ldrb	r0, [r4]	@ zero_extendqisi2
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L1773+72
	str	r0, [r3]
	ldrh	r3, [r5]
	ldrb	r0, [r4]	@ zero_extendqisi2
	muls	r0, r3, r0
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L1773+76
	str	r0, [r3]
	ldrh	r3, [r5]
	ldrb	r0, [r4]	@ zero_extendqisi2
	muls	r0, r3, r0
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L1773+80
	ldr	r2, .L1773+84
	str	r0, [r3]
	ldr	r3, .L1773+88
	ldrh	r3, [r3]
	lsrs	r3, r3, #2
	strh	r3, [r2]	@ movhi
	pop	{r4, r5, r6, pc}
.L1774:
	.align	2
.L1773:
	.word	.LANCHOR85
	.word	.LANCHOR71
	.word	.LANCHOR159
	.word	.LANCHOR160
	.word	.LANCHOR96
	.word	.LANCHOR95
	.word	.LANCHOR90
	.word	.LANCHOR102
	.word	.LANCHOR91
	.word	.LANCHOR92
	.word	.LANCHOR80
	.word	.LANCHOR100
	.word	.LANCHOR94
	.word	.LANCHOR86
	.word	.LANCHOR161
	.word	.LANCHOR70
	.word	.LANCHOR162
	.word	.LANCHOR163
	.word	.LANCHOR83
	.word	.LANCHOR77
	.word	.LANCHOR164
	.word	.LANCHOR87
	.word	.LANCHOR98
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
	ldr	r3, .L1779
	add	r1, r1, r0
	push	{r4, lr}
.L1777:
	cmp	r0, r1
	bne	.L1778
	mov	r0, r3
	pop	{r4, pc}
.L1778:
	lsrs	r2, r3, #2
	ldrb	r4, [r0], #1	@ zero_extendqisi2
	add	r2, r2, r3, lsl #5
	add	r2, r2, r4
	eors	r3, r3, r2
	b	.L1777
.L1780:
	.align	2
.L1779:
	.word	1204201446
	.size	js_hash, .-js_hash
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
	ldr	r3, .L1787
	push	{r4, lr}
	mov	r4, r1
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #8
	bls	.L1782
	cmp	r0, #2
	bne	.L1783
	cbz	r2, .L1783
	ldr	r3, .L1787+4
	mov	r0, r2
	str	r3, [r1]
	mov	r1, #1024
	bl	js_hash
	str	r0, [r4, #4]
.L1782:
	movs	r0, #0
	pop	{r4, pc}
.L1783:
	movs	r3, #0
	str	r3, [r4]
	str	r3, [r4, #4]
	b	.L1782
.L1788:
	.align	2
.L1787:
	.word	.LANCHOR131
	.word	1212240712
	.size	ftl_debug_info_fill, .-ftl_debug_info_fill
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
	ldr	r3, .L1794
	ldr	r0, [r3]
	bx	lr
.L1795:
	.align	2
.L1794:
	.word	.LANCHOR68
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
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r6, #0
	ldr	r10, .L1805+12
	mov	r7, r1
	mov	r8, r2
	mov	fp, r3
	mov	r5, r6
	mov	r4, r6
	str	r0, [sp, #4]
.L1797:
	cmp	r4, fp
	bne	.L1803
	ldr	r1, .L1805
	ldr	r0, .L1805+4
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	printf
.L1803:
	cbnz	r5, .L1798
	mov	r3, r6
	mov	r2, r7
	ldr	r1, [sp, #4]
	ldr	r0, .L1805+8
	bl	printf
.L1798:
	cmp	r8, #4
	bne	.L1799
	ldr	r1, [r7, r4, lsl #2]
.L1804:
	mov	r0, r10
	adds	r5, r5, #1
	bl	printf
	cmp	r5, #15
	bls	.L1802
	movs	r5, #0
	ldr	r1, .L1805
	ldr	r0, .L1805+4
	bl	printf
.L1802:
	adds	r4, r4, #1
	add	r6, r6, r8
	b	.L1797
.L1799:
	cmp	r8, #2
	ite	eq
	ldrsheq	r1, [r7, r4, lsl #1]
	ldrbne	r1, [r7, r4]	@ zero_extendqisi2
	b	.L1804
.L1806:
	.align	2
.L1805:
	.word	.LC103
	.word	.LC104
	.word	.LC101
	.word	.LC102
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
	ldr	r3, .L1918
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
	bne	.L1808
	movs	r3, #167
	mov	r8, #7
	strb	r3, [fp, #128]
	movs	r2, #247
	ldr	r3, .L1918+4
	strb	r2, [r3, #17]
.L1912:
	mov	r10, #4
	b	.L1809
.L1808:
	cmp	r0, #3
	bne	.L1810
	add	r2, fp, #127
	movs	r3, #176
.L1811:
	strb	r3, [r2, #1]!
	adds	r3, r3, #1
	uxtb	r3, r3
	cmp	r3, #184
	bne	.L1811
.L1913:
	mov	r8, #8
	mov	r10, r8
.L1809:
	subs	r3, r4, #1
	cmp	r3, #1
	bhi	.L1817
	movs	r5, #0
.L1818:
	ldr	r3, .L1918+8
	ldrb	r2, [r3]	@ zero_extendqisi2
	uxtb	r3, r5
	cmp	r2, r3
	bhi	.L1823
.L1824:
	strb	r10, [fp, #113]
	strb	r8, [fp, #114]
	add	sp, sp, #56
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1810:
	cmp	r0, #4
	bne	.L1812
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
	b	.L1913
.L1812:
	cmp	r0, #5
	bne	.L1813
	movs	r3, #56
	mov	r8, #8
	strb	r3, [fp, #128]
	movs	r3, #57
	strb	r3, [fp, #129]
	movs	r3, #58
	strb	r3, [fp, #130]
	movs	r3, #59
	strb	r3, [fp, #131]
	b	.L1912
.L1813:
	cmp	r0, #6
	bne	.L1814
	movs	r3, #14
	mov	r8, #12
	strb	r3, [fp, #128]
	movs	r3, #15
	strb	r3, [fp, #129]
	movs	r3, #16
	strb	r3, [fp, #130]
	movs	r3, #17
	strb	r3, [fp, #131]
	b	.L1912
.L1814:
	cmp	r0, #7
	bne	.L1815
	add	r2, fp, #127
	movs	r3, #176
.L1816:
	strb	r3, [r2, #1]!
	adds	r3, r3, #1
	uxtb	r3, r3
	cmp	r3, #184
	bne	.L1816
	movs	r3, #212
	mov	r8, #12
	strb	r3, [fp, #136]
	movs	r3, #213
	strb	r3, [fp, #137]
	mov	r10, #10
	b	.L1809
.L1815:
	cmp	r0, #8
	mov	r3, #7
	bne	.L1871
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
	b	.L1809
.L1871:
	mov	r8, r3
	b	.L1912
.L1823:
	ldr	r2, .L1918+12
	movs	r1, #160
	ldr	r0, [sp]
	add	r7, r10, #-1
	add	r6, fp, #127
	ldrb	r3, [r2, r3]	@ zero_extendqisi2
	ldr	r2, .L1918+16
	uxtab	r7, r0, r7
	ldr	r4, [r2]
	mla	r1, r1, r3, fp
	add	r4, r4, r3, lsl #8
	adds	r1, r1, #144
	subs	r2, r1, #1
	addw	r3, r4, #2056
.L1819:
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
	bne	.L1819
	ldr	r7, .L1918+4
	mov	r0, r1
	movs	r2, #0
.L1820:
	movs	r3, #1
	adds	r6, r7, r2
.L1821:
	ldrb	r4, [r6, r3, lsl #2]	@ zero_extendqisi2
	ldrb	ip, [r0]	@ zero_extendqisi2
	add	r4, r4, ip
	strb	r4, [r0, r3, lsl #3]
	adds	r3, r3, #1
	cmp	r3, #7
	bne	.L1821
	adds	r2, r2, #1
	adds	r0, r0, #1
	cmp	r2, #4
	bne	.L1820
	movs	r3, #0
	adds	r5, r5, #1
	strb	r3, [r1, #16]
	strb	r3, [r1, #24]
	strb	r3, [r1, #32]
	strb	r3, [r1, #40]
	strb	r3, [r1, #48]
	strb	r3, [r1, #41]
	strb	r3, [r1, #49]
	b	.L1818
.L1817:
	subs	r3, r4, #3
	cmp	r3, #5
	bhi	.L1824
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
.L1917:
	str	r3, [sp, #20]
	ldr	r3, .L1918+8
	ldrb	r2, [r3]	@ zero_extendqisi2
	ldrb	r3, [sp, #20]	@ zero_extendqisi2
	cmp	r2, r3
	bls	.L1824
	ldr	r2, .L1918+12
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
	ldr	r3, .L1918+16
	ldr	r3, [r3]
	str	r3, [sp, #4]
	add	r5, r3, r2, lsl #8
	str	r6, [r5, #2056]
	bl	nandc_wait_flash_ready
	cmp	r4, #8
	bne	.L1826
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
.L1827:
	ldm	sp, {r2, r3}
	add	r3, r3, r2, lsl #8
	movs	r2, #48
	str	r2, [r3, #2056]
	bl	nandc_wait_flash_ready
	subs	r3, r4, #5
	cmp	r3, #1
	str	r3, [sp, #28]
	bls	.L1873
	cmp	r4, #8
	beq	.L1873
	cmp	r4, #7
	ite	ne
	movne	r2, #2
	moveq	r2, #32
.L1833:
	ldr	r3, .L1918+20
	subs	r2, r2, #1
	ldr	r5, [sp, #4]
	ldr	r6, [sp]
	ldr	r3, [r3]
	add	r7, r5, r6, lsl #8
	subs	r1, r3, #1
	uxtab	r2, r3, r2
	mov	r0, r1
.L1834:
	ldr	r5, [r7, #2048]
	strb	r5, [r0, #1]!
	cmp	r2, r0
	bne	.L1834
	cmp	r4, #8
	bne	.L1835
	movs	r2, #0
.L1837:
	ldrb	r0, [r3, r2, lsl #2]	@ zero_extendqisi2
	uxtb	r1, r2
	cmp	r0, #50
	beq	.L1836
	add	r0, r3, r2, lsl #2
	ldrb	r0, [r0, #1]	@ zero_extendqisi2
	cmp	r0, #5
	beq	.L1836
	adds	r2, r2, #1
	cmp	r2, #8
	bne	.L1837
.L1838:
	movs	r1, #0
	ldr	r0, .L1918+24
	bl	printf
.L1840:
	b	.L1840
.L1826:
	cmp	r4, #4
	mov	r3, #54
	str	r3, [r5, #2056]
	bne	.L1828
	movs	r3, #64
	str	r6, [r5, #2052]
	str	r3, [r5, #2048]
	movs	r3, #204
.L1914:
	str	r3, [r5, #2052]
	movs	r3, #77
	b	.L1915
.L1919:
	.align	2
.L1918:
	.word	.LANCHOR27
	.word	.LANCHOR165
	.word	.LANCHOR18
	.word	.LANCHOR30
	.word	.LANCHOR13
	.word	.LANCHOR166
	.word	.LC105
.L1828:
	subs	r3, r4, #5
	cmp	r3, #1
	bhi	.L1830
	ldrb	r3, [fp, #128]	@ zero_extendqisi2
	str	r3, [r5, #2052]
	movs	r3, #82
.L1915:
	str	r3, [r5, #2048]
.L1829:
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
	b	.L1827
.L1830:
	cmp	r4, #7
	bne	.L1829
	movs	r3, #174
	str	r3, [r5, #2052]
	movs	r3, #0
	str	r3, [r5, #2048]
	movs	r3, #176
	b	.L1914
.L1873:
	movs	r2, #16
	b	.L1833
.L1836:
	cmp	r1, #6
	bhi	.L1838
.L1839:
	ldr	r3, .L1920
	ldr	ip, [r3]
	mov	r3, ip
.L1849:
	ldr	r1, [sp, #48]
	sub	r2, r3, ip
	cmp	r1, r2
	bgt	.L1850
	ldr	r3, .L1920
	ldr	r1, [r3]
	ldr	r3, [sp, #24]
	adds	r2, r1, r3
	movs	r3, #8
.L1852:
	mov	r5, r2
	movs	r0, #0
.L1851:
	ldrh	r6, [r5]
	adds	r0, r0, #1
	mvns	r6, r6
	strh	r6, [r5], #2	@ movhi
	ldr	r6, [sp, #8]
	cmp	r6, r0
	bgt	.L1851
	ldr	r0, [sp, #44]
	subs	r3, r3, #1
	add	r2, r2, r0
	bne	.L1852
	mov	r6, r1
	str	r3, [sp, #16]
.L1853:
	movs	r0, #0
	mov	r2, r0
.L1857:
	movs	r3, #1
	mov	lr, r6
	lsl	r5, r3, r2
	movs	r3, #0
	str	r3, [sp, #12]
	str	r5, [sp, #32]
	movs	r5, #16
	str	r5, [sp, #36]
.L1855:
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
	bne	.L1855
	ldr	r3, [sp, #12]
	adds	r2, r2, #1
	cmp	r3, #8
	ittt	hi
	ldrhi	r3, [sp, #32]
	orrhi	r0, r0, r3
	uxthhi	r0, r0
	cmp	r2, #16
	bne	.L1857
	ldr	r3, [sp, #16]
	strh	r0, [r6], #2	@ movhi
	adds	r3, r3, #1
	str	r3, [sp, #16]
	ldr	r2, [sp, #16]
	ldr	r3, [sp, #8]
	cmp	r3, r2
	bgt	.L1853
	subs	r2, r1, #4
	add	r0, r1, #28
	movs	r3, #0
.L1860:
	ldr	r5, [r2, #4]!
	cbnz	r5, .L1859
	adds	r3, r3, #1
.L1859:
	cmp	r0, r2
	bne	.L1860
	cmp	r3, #7
	ble	.L1861
	ldr	r0, .L1920+4
	mov	r3, #1024
	movs	r2, #1
	bl	rknand_print_hex
	movs	r1, #0
	ldr	r0, .L1920+8
	bl	printf
.L1862:
	b	.L1862
.L1835:
	cmp	r4, #7
	bne	.L1841
	movs	r2, #0
.L1843:
	ldrb	r0, [r3, r2, lsl #2]	@ zero_extendqisi2
	uxtb	r1, r2
	cmp	r0, #12
	beq	.L1842
	add	r0, r3, r2, lsl #2
	ldrb	r0, [r0, #1]	@ zero_extendqisi2
	cmp	r0, #10
	beq	.L1842
	adds	r2, r2, #1
	cmp	r2, #8
	bne	.L1843
.L1844:
	movs	r1, #0
	ldr	r0, .L1920+8
	bl	printf
.L1845:
	b	.L1845
.L1842:
	cmp	r1, #6
	bls	.L1839
	b	.L1844
.L1841:
	cmp	r4, #6
	bne	.L1839
	adds	r3, r3, #7
.L1846:
	ldrb	r2, [r1, #1]!	@ zero_extendqisi2
	cmp	r2, #12
	beq	.L1839
	ldrb	r2, [r1, #8]	@ zero_extendqisi2
	cmp	r2, #4
	beq	.L1839
	cmp	r3, r1
	bne	.L1846
	movs	r1, #0
	ldr	r0, .L1920+8
	bl	printf
.L1848:
	b	.L1848
.L1850:
	ldr	r2, [r7, #2048]
	strb	r2, [r3], #1
	b	.L1849
.L1861:
	cmp	r4, #6
	beq	.L1875
	cmp	r4, #7
	beq	.L1876
	cmp	r4, #8
	ite	ne
	movne	r0, #8
	moveq	r0, #5
.L1863:
	add	r3, r10, #-1
	ldr	r1, [sp, #40]
	uxtb	r3, r3
	movs	r5, #0
	adds	r3, r3, #1
.L1864:
	mov	lr, r1
	mov	r2, ip
.L1865:
	ldrb	r6, [r2], #1	@ zero_extendqisi2
	strb	r6, [lr], #1
	sub	r6, r2, ip
	uxtb	r6, r6
	cmp	r10, r6
	bhi	.L1865
	adds	r5, r5, #1
	add	ip, ip, r3
	cmp	r8, r5
	add	r1, r1, r0
	bgt	.L1864
	ldm	sp, {r2, r3}
	movs	r6, #255
	add	r5, r3, r2, lsl #8
	str	r6, [r5, #2056]
	bl	nandc_wait_flash_ready
	ldr	r3, [sp, #28]
	cmp	r3, #1
	bhi	.L1867
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
.L1916:
	str	r3, [r5, #2056]
	bl	nandc_wait_flash_ready
	ldr	r3, [sp, #20]
	adds	r3, r3, #1
	b	.L1917
.L1875:
	movs	r0, #4
	b	.L1863
.L1876:
	movs	r0, #10
	b	.L1863
.L1867:
	cmp	r4, #8
	ite	eq
	moveq	r3, #190
	movne	r3, #56
	b	.L1916
.L1921:
	.align	2
.L1920:
	.word	.LANCHOR166
	.word	.LC106
	.word	.LC105
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
	ldr	r3, .L1924
	ldrb	r0, [r3, #19]	@ zero_extendqisi2
	subs	r3, r0, #1
	cmp	r3, #7
	bhi	.L1922
	b	hynix_get_read_retry_default
.L1922:
	bx	lr
.L1925:
	.align	2
.L1924:
	.word	.LANCHOR33
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
	ldr	r3, .L1961
	push	{r0, r1, r4, r5, r6, r7, r8, lr}
	movs	r1, #0
	ldr	r4, .L1961+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldr	r5, .L1961+8
	strb	r1, [r4]
	cmp	r3, #9
	ldr	r6, [r5]
	bne	.L1927
	ldr	r3, [r6, #16]
	str	r3, [sp]
	ldr	r3, [r6, #48]
	ubfx	r3, r3, #1, #1
	cmp	r3, #0
	bne	.L1932
	ldr	r7, .L1961+12
	mov	r4, r3
	ldr	r8, .L1961+32
.L1929:
	ldr	r3, [sp]
	lsls	r0, r3, #11
	bmi	.L1931
	ldr	r3, [r5]
	adds	r4, r4, #1
	ldr	r3, [r3, #16]
	str	r3, [sp]
	bics	r3, r4, #-16777216
	bne	.L1929
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
	b	.L1929
.L1930:
	ldr	r3, [sp]
	adds	r1, r1, #1
	ubfx	r3, r3, #22, #6
	cmp	r1, r3, lsl #12
	bne	.L1932
	ldr	r2, [r6, #64]
	ldr	r3, [sp]
	ldr	r0, .L1961+16
	ubfx	r2, r2, #16, #5
	ubfx	r3, r3, #22, #6
	bl	printf
	ldr	r3, [sp, #4]
	movs	r3, #1
	strb	r3, [r4]
.L1931:
	ldr	r3, .L1961+20
	movs	r2, #0
	str	r2, [r3, #20]
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L1932:
	ldr	r2, [r6, #64]
	ldr	r3, [sp]
	ubfx	r2, r2, #16, #6
	ubfx	r3, r3, #22, #6
	cmp	r2, r3
	bge	.L1931
	ldr	r3, [r6]
	str	r3, [sp, #4]
	ldr	r3, [sp, #4]
	lsls	r7, r3, #18
	bpl	.L1930
	ldr	r3, [sp, #4]
	lsls	r5, r3, #14
	bpl	.L1930
	ldr	r1, [sp, #4]
	ldr	r0, .L1961+24
	ubfx	r1, r1, #17, #1
.L1960:
	bl	printf
	b	.L1931
.L1927:
	ldr	r3, [r6, #8]
	str	r3, [sp]
	ldr	r4, [r6, #16]
	ubfx	r4, r4, #1, #1
	cbnz	r4, .L1937
	ldr	r7, .L1961+12
	ldr	r8, .L1961+32
.L1938:
	ldr	r3, [sp]
	lsls	r3, r3, #11
	bmi	.L1931
	ldr	r3, [r5]
	adds	r4, r4, #1
	ldr	r3, [r3, #8]
	str	r3, [sp]
	bics	r3, r4, #-16777216
	bne	.L1938
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
	b	.L1938
.L1937:
	ldr	r7, .L1961+16
	mov	r4, r1
	ldr	r8, .L1961+32
.L1939:
	ldr	r2, [r6, #28]
	ldr	r3, [sp]
	ubfx	r2, r2, #16, #5
	ubfx	r3, r3, #22, #6
	cmp	r2, r3
	bge	.L1931
	ldr	r3, [r5]
	ldr	r3, [r3]
	str	r3, [sp, #4]
	ldr	r3, [sp, #4]
	lsls	r1, r3, #18
	bpl	.L1940
	ldr	r3, [sp, #4]
	lsls	r2, r3, #14
	bpl	.L1940
	ldr	r1, [sp, #4]
	ldr	r0, .L1961+28
	b	.L1960
.L1940:
	adds	r4, r4, #1
	bics	r3, r4, #-16777216
	bne	.L1939
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
	b	.L1939
.L1962:
	.align	2
.L1961:
	.word	.LANCHOR28
	.word	.LANCHOR167
	.word	.LANCHOR13
	.word	.LC109
	.word	.LC108
	.word	.LANCHOR53
	.word	.LC107
	.word	.LC111
	.word	.LC110
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
	mov	r4, r1
	ldr	r5, [sp, #32]
	mov	r7, r2
	mov	r6, r3
	mov	r0, r4
	mov	r2, r6
	mov	r1, r7
	mov	r3, r5
	bl	nandc_xfer_start
	mov	r0, r4
	bl	nandc_xfer_done
	cmp	r4, #0
	bne	.L1982
	ldr	r3, .L2001
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #9
	bne	.L1965
	ldr	r3, .L2001+4
	lsrs	r7, r7, #2
	movs	r2, #1
	mov	r0, r4
	ldr	r1, [r3]
	mov	r8, r3
.L1966:
	cmp	r4, r7
	bcc	.L1970
	ldr	r4, [r1]
	cmp	r2, #0
	it	ne
	movne	r0, #512
	and	r3, r4, #139264
	cmp	r3, #139264
	bne	.L1972
	mov	r1, r4
	ldr	r0, .L2001+8
	bl	printf
	ldr	r3, [r8]
	mov	r0, #-1
	orr	r4, r4, #131072
	str	r4, [r3]
.L1972:
	lsls	r2, r4, #18
	bpl	.L1973
	ldr	r3, .L2001+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L1973
	mov	r1, r4
	ldr	r0, .L2001+16
	bl	printf
	ldr	r3, [r8]
	movs	r2, #1
	str	r2, [r3, #16]
.L2000:
	mov	r0, #-1
.L1964:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L1970:
	add	r3, r4, #84
	ldr	r3, [r1, r3, lsl #2]
	str	r3, [sp, #4]
	ldr	ip, [sp, #4]
	ldr	r3, [sp, #4]
	ubfx	r3, r3, #26, #1
	and	r3, r3, ip, lsr #10
	ands	r2, r2, r3
	ldr	r3, [sp, #4]
	lsls	r3, r3, #29
	bmi	.L1984
	ldr	r3, [sp, #4]
	lsls	r3, r3, #13
	bmi	.L1984
	ldr	r3, [sp, #4]
	ubfx	ip, r3, #3, #7
	ldr	r3, [sp, #4]
	ubfx	r3, r3, #19, #7
	cmp	ip, r3
	ldr	r3, [sp, #4]
	ite	gt
	ubfxgt	r3, r3, #3, #7
	ubfxle	r3, r3, #19, #7
	cmp	r0, r3
	it	cc
	movcc	r0, r3
.L1967:
	adds	r4, r4, #1
	b	.L1966
.L1984:
	mov	r0, #-1
	b	.L1967
.L1965:
	ldr	r3, .L2001+20
	lsrs	r0, r7, #1
	ldr	r8, .L2001+28
	mov	r1, r4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #25
	mov	r3, r5
	ite	cc
	movcc	lr, #64
	movcs	lr, #128
.L1975:
	cmp	r1, r0
	add	ip, lr, r4
	add	r3, r3, #4
	bcc	.L1976
	lsrs	r4, r7, #2
	ldr	r7, .L2001+4
	movs	r2, #0
	mov	r0, r2
	ldr	r1, [r7]
.L1977:
	cmp	r2, r4
	bcc	.L1981
	movs	r3, #0
	str	r3, [r1, #16]
	ldr	r4, [r1]
	and	r3, r4, #139264
	cmp	r3, #139264
	bne	.L1973
	mov	r1, r4
	ldr	r0, .L2001+24
	bl	printf
	ldr	r3, [r7]
	orr	r4, r4, #131072
	str	r4, [r3]
	b	.L2000
.L1976:
	ldr	r2, [r8]
	bic	r4, r4, #3
	adds	r1, r1, #1
	ldr	r2, [r2, r4]
	strb	r2, [r3, #-4]
	lsrs	r4, r2, #8
	strb	r4, [r3, #-3]
	lsrs	r4, r2, #16
	lsrs	r2, r2, #24
	strb	r4, [r3, #-2]
	mov	r4, ip
	strb	r2, [r3, #-1]
	b	.L1975
.L1981:
	add	r3, r2, #8
	ldr	r3, [r1, r3, lsl #2]
	str	r3, [sp, #4]
	ldr	r3, [sp, #4]
	lsls	r3, r3, #29
	bmi	.L1987
	ldr	r3, [sp, #4]
	lsls	r3, r3, #16
	bmi	.L1987
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
.L1978:
	adds	r2, r2, #1
	b	.L1977
.L1987:
	mov	r0, #-1
	b	.L1978
.L1973:
	adds	r3, r0, #1
	beq	.L1964
	ldr	r3, [r5]
	adds	r3, r3, #1
	bne	.L1964
	ldr	r3, [r5, #4]
	adds	r3, r3, #1
	bne	.L1964
	ldr	r3, [r6]
	adds	r3, r3, #1
	it	eq
	moveq	r0, #512
	b	.L1964
.L1982:
	movs	r0, #0
	b	.L1964
.L2002:
	.align	2
.L2001:
	.word	.LANCHOR28
	.word	.LANCHOR13
	.word	.LC112
	.word	.LANCHOR167
	.word	.LC113
	.word	.LANCHOR50
	.word	.LC114
	.word	.LANCHOR53
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
	mov	r7, r3
	ldr	r3, .L2018
	mov	r5, r0
	ubfx	r10, r1, #24, #2
	lsl	fp, r5, #8
	str	r2, [sp, #12]
	ldr	r8, [r3]
	ldr	r3, .L2018+4
	ldr	r6, .L2018+8
	ldrb	r4, [r3]	@ zero_extendqisi2
	rsb	r3, r4, #24
	movs	r4, #1
	lsls	r4, r4, r3
	subs	r4, r4, #1
	ands	r4, r4, r1
	bl	nandc_wait_flash_ready
	mov	r0, r5
	bl	nandc_cs
	cmp	r10, #0
	bne	.L2004
	mov	r0, r5
	bl	zftl_flash_enter_slc_mode
.L2005:
	ldr	r3, [r6]
	ldrb	r2, [r3, #7]	@ zero_extendqisi2
	cmp	r2, #1
	bne	.L2007
	ldrb	r2, [r3, #12]	@ zero_extendqisi2
	cmp	r2, #2
	ittt	eq
	addeq	r2, r8, fp
	moveq	r1, #38
	streq	r1, [r2, #2056]
.L2007:
	add	r6, r8, fp
	movs	r1, #0
	str	r1, [r6, #2056]
	str	r1, [r6, #2052]
	str	r1, [r6, #2052]
	uxtb	r1, r4
	str	r1, [r6, #2052]
	lsrs	r1, r4, #8
	str	r1, [r6, #2052]
	lsrs	r1, r4, #16
	str	r1, [r6, #2052]
	ldr	r1, .L2018+12
	ldrb	r1, [r1]	@ zero_extendqisi2
	cbz	r1, .L2008
	lsrs	r1, r4, #24
	str	r1, [r6, #2052]
.L2008:
	add	r1, r8, fp
	movs	r0, #48
	str	r0, [r1, #2056]
	ldrb	r3, [r3, #12]	@ zero_extendqisi2
	cmp	r3, #3
	bne	.L2009
	cmp	r10, #0
	beq	.L2009
	ldr	r3, .L2018+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L2009
	ldr	r3, .L2018+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L2009
	add	r4, r4, r4, lsl #1
	subs	r0, r4, #1
	add	r0, r0, r10
.L2017:
	bl	nandc_set_seed
	bl	nandc_wait_flash_ready
	add	r3, r8, fp
	movs	r1, #5
	str	r1, [r3, #2056]
	movs	r2, #224
	movs	r1, #0
	mov	r0, r5
	str	r1, [r6, #2052]
	str	r1, [r6, #2052]
	str	r2, [r3, #2056]
	ldr	r3, [sp, #12]
	ldrb	r2, [sp, #48]	@ zero_extendqisi2
	str	r7, [sp]
	bl	nandc_xfer
	bl	nandc_de_cs.constprop.33
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2004:
	ldr	r2, [r6]
	ldrb	r2, [r2, #12]	@ zero_extendqisi2
	cmp	r2, #3
	bne	.L2006
	ldr	r2, .L2018+16
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbnz	r2, .L2006
	ldr	r2, .L2018+20
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbnz	r2, .L2006
	add	r2, r8, fp
	str	r10, [r2, #2056]
	b	.L2005
.L2006:
	mov	r0, r5
	bl	zftl_flash_exit_slc_mode
	b	.L2005
.L2009:
	mov	r0, r4
	b	.L2017
.L2019:
	.align	2
.L2018:
	.word	.LANCHOR13
	.word	.LANCHOR32
	.word	.LANCHOR16
	.word	.LANCHOR31
	.word	.LANCHOR36
	.word	.LANCHOR37
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
	mov	r6, r0
	mov	fp, r1
	mov	r10, #0
	ldr	r3, .L2044
	str	r2, [sp, #16]
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	asrs	r3, r3, #2
	str	r3, [sp, #8]
	bl	nandc_wait_flash_ready
	mov	r0, r6
	bl	zftl_flash_enter_slc_mode
	mov	r0, r6
	bl	zftl_flash_exit_slc_mode
	ldr	r3, .L2044+4
	ldr	r5, [r3]
	add	r5, r5, r6, lsl #8
.L2021:
	mov	r8, #0
	mov	r4, #-1
.L2022:
	ldr	r3, .L2044+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r8, r3
	bcc	.L2027
.L2026:
	movs	r3, #239
	movs	r0, #200
	str	r3, [r5, #2056]
	movs	r3, #137
	str	r3, [r5, #2052]
	movs	r7, #0
	bl	timer_delay_ns
	ldr	r3, [sp, #8]
	str	r7, [r5, #2048]
	str	r7, [r5, #2048]
	cmp	r4, r3
	str	r7, [r5, #2048]
	str	r7, [r5, #2048]
	bcc	.L2028
	adds	r1, r4, #1
	mov	r3, r8
	it	ne
	movne	r4, #256
	mov	r2, fp
	str	r4, [sp]
	mov	r1, r8
	ldr	r0, .L2044+12
	bl	printf
	cmp	r10, #0
	bne	.L2030
	adds	r2, r4, #1
	bne	.L2031
	movs	r1, #3
	mov	r0, r6
	bl	mt_auto_read_calibration_config
	mov	r10, #1
	b	.L2021
.L2027:
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
	mov	r0, r6
	str	r3, [r5, #2048]
	str	r3, [r5, #2048]
	ldr	r3, [sp, #56]
	str	r3, [sp]
	ldr	r3, [sp, #20]
	bl	flash_read_page
	ldr	r3, .L2044+16
	mov	r7, r0
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L2023
	str	r0, [sp]
	mov	r3, r4
	mov	r2, fp
	mov	r1, r8
	ldr	r0, .L2044+20
	bl	printf
.L2023:
	adds	r0, r7, #1
	beq	.L2024
	ldr	r3, .L2044+24
	cmp	r4, #-1
	it	eq
	moveq	r4, r7
	ldr	r3, [r3]
	str	r3, [sp, #16]
	ldr	r3, .L2044+28
	ldr	r3, [r3]
	str	r3, [sp, #20]
	ldr	r3, [sp, #8]
	cmp	r7, r3
	bcc	.L2033
.L2024:
	ldr	r8, [sp, #12]
	b	.L2022
.L2033:
	mov	r4, r7
	b	.L2026
.L2030:
	mov	r1, r7
	mov	r0, r6
	bl	mt_auto_read_calibration_config
	adds	r3, r4, #1
	it	ne
	movne	r4, #256
.L2031:
	bl	nandc_wait_flash_ready
	mov	r0, r4
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2028:
	cmp	r10, #0
	beq	.L2031
	mov	r1, r7
	mov	r0, r6
	bl	mt_auto_read_calibration_config
	mov	r4, #256
	b	.L2031
.L2045:
	.align	2
.L2044:
	.word	.LANCHOR50
	.word	.LANCHOR13
	.word	.LANCHOR169
	.word	.LC116
	.word	.LANCHOR14
	.word	.LC115
	.word	.LANCHOR166
	.word	.LANCHOR168
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
	ldr	r3, .L2089
	ldr	fp, [r3]
	ldr	r3, .L2089+4
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
	bne	.L2048
	mov	r4, #-1
	movs	r5, #1
	str	r3, [sp, #20]
.L2055:
	ldr	r3, [sp, #20]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #36
	bne	.L2049
	movs	r2, #0
	mov	r1, r5
	mov	r0, r6
	bl	toshiba_tlc_set_rr_para
	add	r3, fp, r7, lsl #8
	movs	r2, #93
	str	r2, [r3, #2056]
.L2050:
	ldr	r3, [sp, #56]
	mov	r1, r8
	ldr	r2, [sp, #8]
	mov	r0, r7
	str	r3, [sp]
	ldr	r3, [sp, #12]
	bl	flash_read_page
	ldr	r3, .L2089+8
	mov	r10, r0
	ldr	r3, [r3]
	lsls	r1, r3, #27
	bpl	.L2051
	mov	r3, r0
	mov	r2, r8
	mov	r1, r5
	ldr	r0, .L2089+12
	bl	printf
.L2051:
	cmp	r10, #-1
	beq	.L2052
	ldr	r3, .L2089+16
	cmp	r4, #-1
	it	eq
	moveq	r4, r10
	ldr	r3, [r3]
	str	r3, [sp, #8]
	ldr	r3, .L2089+20
	ldr	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L2089+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r10, r3, asr #2
	bcc	.L2070
.L2052:
	ldr	r3, [sp, #16]
	adds	r5, r5, #1
	cmp	r3, r5
	bne	.L2055
.L2054:
	ldr	r3, .L2089+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #36
	bne	.L2056
	movs	r2, #0
.L2088:
	movs	r1, #0
	mov	r0, r6
	bl	toshiba_tlc_set_rr_para
	b	.L2057
.L2049:
	uxtb	r1, r5
	mov	r0, r6
	bl	toshiba_3d_set_slc_rr_para
	b	.L2050
.L2070:
	mov	r4, r10
	b	.L2054
.L2056:
	movs	r1, #0
	mov	r0, r6
	bl	toshiba_3d_set_slc_rr_para
.L2057:
	ldr	r3, .L2089+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #36
	bne	.L2066
	add	r7, fp, r7, lsl #8
	movs	r3, #85
	str	r3, [r7, #2056]
	movs	r3, #0
	str	r3, [r7, #2052]
	str	r3, [r7, #2048]
	movs	r3, #255
	str	r3, [r7, #2056]
.L2066:
	ldr	r3, .L2089+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r4, r3, asr #2
	bcc	.L2067
	adds	r3, r4, #1
	mov	r2, r8
	it	ne
	movne	r4, #256
	mov	r3, r5
	str	r4, [sp]
	mov	r1, r5
	ldr	r0, .L2089+28
	bl	printf
.L2067:
	bl	nandc_wait_flash_ready
	mov	r0, r4
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2048:
	mov	r4, #-1
	movs	r5, #1
	str	r3, [sp, #16]
.L2064:
	ldr	r3, [sp, #16]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #36
	bne	.L2058
	movs	r2, #1
	mov	r1, r5
	mov	r0, r6
	bl	toshiba_tlc_set_rr_para
	add	r3, fp, r7, lsl #8
	movs	r2, #93
.L2087:
	str	r2, [r3, #2056]
	mov	r1, r8
	ldr	r3, [sp, #56]
	mov	r0, r7
	ldr	r2, [sp, #8]
	str	r3, [sp]
	ldr	r3, [sp, #12]
	bl	flash_read_page
	ldr	r3, .L2089+8
	mov	r10, r0
	ldr	r3, [r3]
	lsls	r2, r3, #27
	bpl	.L2060
	mov	r3, r0
	mov	r2, r8
	mov	r1, r5
	ldr	r0, .L2089+32
	bl	printf
.L2060:
	cmp	r10, #-1
	beq	.L2061
	ldr	r3, .L2089+16
	cmp	r4, #-1
	it	eq
	moveq	r4, r10
	ldr	r3, [r3]
	str	r3, [sp, #8]
	ldr	r3, .L2089+20
	ldr	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L2089+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r10, r3, asr #2
	bcc	.L2071
.L2061:
	ldr	r3, [sp, #20]
	adds	r5, r5, #1
	cmp	r3, r5
	bne	.L2064
.L2063:
	ldr	r3, .L2089+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #36
	bne	.L2065
	movs	r2, #1
	b	.L2088
.L2058:
	uxtb	r1, r5
	mov	r0, r6
	bl	toshiba_3d_set_tlc_rr_para
	add	r3, fp, r7, lsl #8
	movs	r2, #38
	b	.L2087
.L2071:
	mov	r4, r10
	b	.L2063
.L2065:
	movs	r1, #0
	mov	r0, r6
	bl	toshiba_3d_set_tlc_rr_para
	b	.L2057
.L2090:
	.align	2
.L2089:
	.word	.LANCHOR13
	.word	.LANCHOR23
	.word	.LANCHOR14
	.word	.LC117
	.word	.LANCHOR166
	.word	.LANCHOR168
	.word	.LANCHOR50
	.word	.LC119
	.word	.LC118
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
	mov	r5, r0
	sub	sp, sp, #24
	add	r10, r5, #8
	str	r2, [sp, #12]
	str	r3, [sp, #16]
	str	r1, [sp, #8]
	bl	nandc_wait_flash_ready
	mov	r0, r5
	bl	zftl_flash_enter_slc_mode
	mov	r0, r5
	bl	zftl_flash_exit_slc_mode
	ldr	r3, .L2118
	ldr	r2, .L2118+4
	ldr	r7, [r3]
	ldrb	r3, [r2]	@ zero_extendqisi2
	str	r2, [sp, #20]
	subs	r3, r3, #67
	add	r10, r7, r10, lsl #8
	cmp	r3, #1
	bls	.L2109
	ldr	r3, .L2118+8
	ldrb	r6, [r3]	@ zero_extendqisi2
	cbz	r6, .L2093
	movs	r6, #1
	movs	r0, #1
	bl	nandc_set_if_mode
.L2093:
	add	r3, r7, r5, lsl #8
	movs	r2, #92
	str	r2, [r3, #2056]
	movs	r2, #197
	str	r2, [r3, #2056]
.L2092:
	mov	r8, #1
	mov	fp, #-1
.L2094:
	ldr	r3, .L2118+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	adds	r3, r3, #1
	cmp	r8, r3
	bcc	.L2103
	mov	r4, fp
.L2102:
	ldr	r3, .L2118+4
	movs	r1, #0
	mov	r0, r10
	ldrb	r3, [r3]	@ zero_extendqisi2
	subs	r3, r3, #67
	cmp	r3, #1
	bhi	.L2104
	bl	sandisk_set_rr_para
.L2105:
	add	r5, r7, r5, lsl #8
	movs	r3, #255
	str	r3, [r5, #2056]
	ldr	r3, .L2118+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r4, r3, asr #2
	bcc	.L2106
	adds	r3, r4, #1
	ldr	r2, [sp, #8]
	it	ne
	movne	r4, #256
	mov	r3, r8
	str	r4, [sp]
	mov	r1, r8
	ldr	r0, .L2118+20
	bl	printf
.L2106:
	bl	nandc_wait_flash_ready
	cbz	r6, .L2091
	movs	r0, #4
	bl	nandc_set_if_mode
.L2091:
	mov	r0, r4
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2109:
	movs	r6, #0
	b	.L2092
.L2103:
	ldr	r3, [sp, #20]
	mov	r0, r10
	uxtb	r1, r8
	ldrb	r3, [r3]	@ zero_extendqisi2
	subs	r3, r3, #67
	cmp	r3, #1
	bhi	.L2095
	bl	sandisk_set_rr_para
.L2096:
	ldr	r3, .L2118+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #34
	bne	.L2097
	ldr	r3, .L2118+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	subs	r3, r3, #3
	cmp	r8, r3
	ittt	eq
	addeq	r3, r7, r5, lsl #8
	moveq	r2, #179
	streq	r2, [r3, #2056]
.L2097:
	add	r3, r7, r5, lsl #8
	movs	r2, #38
	add	r1, sp, #8
	str	r2, [r3, #2056]
	movs	r2, #93
	str	r2, [r3, #2056]
	mov	r0, r5
	ldr	r3, [sp, #56]
	str	r3, [sp]
	ldm	r1, {r1, r2, r3}
	bl	flash_read_page
	adds	r2, r0, #1
	mov	r4, r0
	beq	.L2100
	ldr	r3, .L2118+24
	cmp	fp, #-1
	it	eq
	moveq	fp, r0
	ldr	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L2118+28
	ldr	r3, [r3]
	str	r3, [sp, #16]
	ldr	r3, .L2118+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r0, r3, asr #2
	bcc	.L2102
.L2100:
	add	r8, r8, #1
	b	.L2094
.L2095:
	bl	toshiba_set_rr_para
	b	.L2096
.L2104:
	bl	toshiba_set_rr_para
	b	.L2105
.L2119:
	.align	2
.L2118:
	.word	.LANCHOR13
	.word	.LANCHOR23
	.word	.LANCHOR21
	.word	.LANCHOR169
	.word	.LANCHOR50
	.word	.LC119
	.word	.LANCHOR166
	.word	.LANCHOR168
	.size	toshiba_read_retrial, .-toshiba_read_retrial
	.section	.text.ymtc_3d_read_retrial,"ax",%progbits
	.align	1
	.global	ymtc_3d_read_retrial
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ymtc_3d_read_retrial, %function
ymtc_3d_read_retrial:
	@ args = 4, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r7, r0
	mov	r8, r1
	mov	r10, r2
	mov	fp, r3
	mov	r4, #-1
	bl	nandc_wait_flash_ready
	mov	r0, r7
	movs	r5, #1
	bl	zftl_flash_enter_slc_mode
	mov	r0, r7
	bl	zftl_flash_exit_slc_mode
	ldr	r2, .L2144
	tst	r8, #50331648
	add	r3, r7, #8
	ldr	r6, [r2]
	add	r6, r6, r3, lsl #8
	bne	.L2130
.L2125:
	uxtb	r1, r5
	mov	r0, r6
	bl	ymtc_3d_set_slc_rr_para
	ldr	r3, [sp, #40]
	mov	r1, r8
	mov	r2, r10
	mov	r0, r7
	str	r3, [sp]
	mov	r3, fp
	bl	flash_read_page
	adds	r1, r0, #1
	beq	.L2122
	ldr	r3, .L2144+4
	cmp	r4, #-1
	it	eq
	moveq	r4, r0
	ldr	r10, [r3]
	ldr	r3, .L2144+8
	ldr	fp, [r3]
	ldr	r3, .L2144+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r0, r3, asr #2
	bcc	.L2133
.L2122:
	adds	r5, r5, #1
	cmp	r5, #10
	bne	.L2125
.L2124:
	movs	r1, #0
	mov	r0, r6
	bl	ymtc_3d_set_slc_rr_para
.L2126:
	ldr	r3, .L2144+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r4, r3, asr #2
	bcc	.L2131
	adds	r3, r4, #1
	mov	r2, r8
	it	ne
	movne	r4, #256
	mov	r3, r5
	str	r4, [sp]
	mov	r1, r5
	ldr	r0, .L2144+16
	bl	printf
.L2131:
	bl	nandc_wait_flash_ready
	mov	r0, r4
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2133:
	mov	r4, r0
	b	.L2124
.L2130:
	uxtb	r1, r5
	mov	r0, r6
	bl	ymtc_3d_set_tlc_rr_para
	ldr	r3, [sp, #40]
	mov	r2, r10
	mov	r1, r8
	mov	r0, r7
	str	r3, [sp]
	mov	r3, fp
	bl	flash_read_page
	adds	r2, r0, #1
	beq	.L2127
	ldr	r3, .L2144+4
	cmp	r4, #-1
	it	eq
	moveq	r4, r0
	ldr	r10, [r3]
	ldr	r3, .L2144+8
	ldr	fp, [r3]
	ldr	r3, .L2144+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r0, r3, asr #2
	bcc	.L2134
.L2127:
	adds	r5, r5, #1
	cmp	r5, #51
	bne	.L2130
.L2129:
	movs	r1, #0
	mov	r0, r6
	bl	ymtc_3d_set_tlc_rr_para
	b	.L2126
.L2134:
	mov	r4, r0
	b	.L2129
.L2145:
	.align	2
.L2144:
	.word	.LANCHOR13
	.word	.LANCHOR166
	.word	.LANCHOR168
	.word	.LANCHOR50
	.word	.LC120
	.size	ymtc_3d_read_retrial, .-ymtc_3d_read_retrial
	.section	.text.samsung_read_retrial,"ax",%progbits
	.align	1
	.global	samsung_read_retrial
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	samsung_read_retrial, %function
samsung_read_retrial:
	@ args = 4, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r7, r0
	sub	sp, sp, #24
	mov	r8, r1
	str	r3, [sp, #16]
	str	r2, [sp, #12]
	bl	nandc_wait_flash_ready
	mov	r0, r7
	bl	zftl_flash_enter_slc_mode
	mov	r0, r7
	bl	zftl_flash_exit_slc_mode
	ldr	r3, .L2179
	tst	r8, #50331648
	ldr	r3, [r3]
	str	r3, [sp, #8]
	bne	.L2147
	lsl	fp, r7, #8
	mov	r4, #-1
	movs	r5, #1
	add	r6, r3, fp
.L2152:
	movs	r3, #239
	str	r3, [r6, #2056]
	movs	r3, #141
	str	r3, [r6, #2052]
	ldr	r3, .L2179+4
	ldrsb	r3, [r5, r3]
	str	r3, [r6, #2048]
	movs	r3, #0
	str	r3, [r6, #2048]
	str	r3, [r6, #2048]
	str	r3, [r6, #2048]
	bl	nandc_wait_flash_ready
	ldr	r3, [sp, #56]
	mov	r1, r8
	ldr	r2, [sp, #12]
	mov	r0, r7
	str	r3, [sp]
	ldr	r3, [sp, #16]
	bl	flash_read_page
	ldr	r3, .L2179+8
	mov	r10, r0
	ldr	r3, [r3]
	lsls	r1, r3, #27
	bpl	.L2148
	mov	r3, r0
	mov	r2, r8
	mov	r1, r5
	ldr	r0, .L2179+12
	bl	printf
.L2148:
	cmp	r10, #-1
	beq	.L2149
	ldr	r3, .L2179+16
	cmp	r4, #-1
	it	eq
	moveq	r4, r10
	ldr	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L2179+20
	ldr	r3, [r3]
	str	r3, [sp, #16]
	ldr	r3, .L2179+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r10, r3, asr #2
	bcc	.L2161
.L2149:
	adds	r5, r5, #1
	cmp	r5, #26
	bne	.L2152
.L2151:
	ldr	r3, [sp, #8]
	add	r3, r3, fp
	mov	fp, r3
	movs	r3, #239
	str	r3, [fp, #2056]
	movs	r3, #141
.L2178:
	str	r3, [r6, #2052]
	movs	r3, #0
	str	r3, [r6, #2048]
	str	r3, [r6, #2048]
	str	r3, [r6, #2048]
	str	r3, [r6, #2048]
	bl	nandc_wait_flash_ready
	ldr	r3, .L2179+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r4, r3, asr #2
	bcc	.L2159
	adds	r3, r4, #1
	mov	r2, r8
	it	ne
	movne	r4, #256
	mov	r3, r5
	str	r4, [sp]
	mov	r1, r5
	ldr	r0, .L2179+28
	bl	printf
.L2159:
	bl	nandc_wait_flash_ready
	mov	r0, r4
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2161:
	mov	r4, r10
	b	.L2151
.L2147:
	ldr	r3, [sp, #8]
	mov	r4, #-1
	ldr	r10, .L2179+36
	movs	r5, #1
	add	r6, r3, r7, lsl #8
	addw	r3, r6, #2056
	str	r3, [sp, #20]
.L2158:
	ldr	r3, [sp, #20]
	mov	r2, r3
	movs	r3, #239
	str	r3, [r2]
	movs	r3, #137
	str	r3, [r6, #2052]
	ldrb	r3, [r10, #4]	@ zero_extendqisi2
	str	r3, [r6, #2048]
	ldrb	r3, [r10, #5]	@ zero_extendqisi2
	str	r3, [r6, #2048]
	ldrb	r3, [r10, #6]	@ zero_extendqisi2
	str	r3, [r6, #2048]
	ldrb	r3, [r10, #7]	@ zero_extendqisi2
	str	r3, [r6, #2048]
	bl	nandc_wait_flash_ready
	ldr	r3, [sp, #56]
	mov	r1, r8
	ldr	r2, [sp, #12]
	mov	r0, r7
	str	r3, [sp]
	ldr	r3, [sp, #16]
	bl	flash_read_page
	ldr	r3, .L2179+8
	mov	fp, r0
	ldr	r3, [r3]
	lsls	r2, r3, #27
	bpl	.L2154
	mov	r3, r0
	mov	r2, r8
	mov	r1, r5
	ldr	r0, .L2179+32
	bl	printf
.L2154:
	cmp	fp, #-1
	beq	.L2155
	ldr	r3, .L2179+16
	cmp	r4, #-1
	it	eq
	moveq	r4, fp
	ldr	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L2179+20
	ldr	r3, [r3]
	str	r3, [sp, #16]
	ldr	r3, .L2179+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	fp, r3, asr #2
	bcc	.L2162
.L2155:
	adds	r5, r5, #1
	add	r10, r10, #4
	cmp	r5, #26
	bne	.L2158
.L2157:
	ldr	r3, [sp, #8]
	add	r7, r3, r7, lsl #8
	movs	r3, #239
	str	r3, [r7, #2056]
	movs	r3, #137
	b	.L2178
.L2162:
	mov	r4, fp
	b	.L2157
.L2180:
	.align	2
.L2179:
	.word	.LANCHOR13
	.word	.LANCHOR170
	.word	.LANCHOR14
	.word	.LC121
	.word	.LANCHOR166
	.word	.LANCHOR168
	.word	.LANCHOR50
	.word	.LC123
	.word	.LC122
	.word	.LANCHOR171
	.size	samsung_read_retrial, .-samsung_read_retrial
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
	mov	r6, r0
	str	r3, [sp, #12]
	mov	r8, r1
	movs	r7, #0
	mov	r4, #-1
	ldr	r3, .L2195
	str	r2, [sp, #8]
	ldr	r3, [r3]
	add	r10, r3, r0
	ldrb	fp, [r3, #114]	@ zero_extendqisi2
	ldrb	r5, [r10, #120]	@ zero_extendqisi2
	bl	nandc_wait_flash_ready
	mov	r0, r6
	bl	zftl_flash_enter_slc_mode
	mov	r0, r6
	bl	zftl_flash_exit_slc_mode
.L2182:
	cmp	r7, fp
	bcc	.L2187
.L2186:
	ldr	r3, .L2195+4
	strb	r5, [r10, #120]
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r4, r3, asr #2
	bcc	.L2188
	adds	r3, r4, #1
	mov	r2, r8
	it	ne
	movne	r4, #256
	mov	r3, r7
	str	r4, [sp]
	mov	r1, r7
	ldr	r0, .L2195+8
	bl	printf
.L2188:
	bl	nandc_wait_flash_ready
	mov	r0, r4
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2187:
	adds	r5, r5, #1
	mov	r0, r6
	uxtb	r5, r5
	cmp	fp, r5
	it	ls
	movls	r5, #0
	mov	r1, r5
	bl	hynix_set_rr_para
	ldr	r3, [sp, #48]
	mov	r1, r8
	ldr	r2, [sp, #8]
	mov	r0, r6
	str	r3, [sp]
	ldr	r3, [sp, #12]
	bl	flash_read_page
	adds	r2, r0, #1
	beq	.L2184
	ldr	r3, .L2195+12
	cmp	r4, #-1
	it	eq
	moveq	r4, r0
	ldr	r3, [r3]
	str	r3, [sp, #8]
	ldr	r3, .L2195+16
	ldr	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L2195+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r0, r3, asr #2
	bcc	.L2190
.L2184:
	adds	r7, r7, #1
	b	.L2182
.L2190:
	mov	r4, r0
	b	.L2186
.L2196:
	.align	2
.L2195:
	.word	.LANCHOR27
	.word	.LANCHOR50
	.word	.LC124
	.word	.LANCHOR166
	.word	.LANCHOR168
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
.L2203:
	uxtb	r0, r7
	bl	nandc_set_ddr_para
	ldr	r3, [sp, #64]
	mov	r1, fp
	ldr	r2, [sp, #16]
	mov	r0, r8
	str	r3, [sp]
	ldr	r3, [sp, #20]
	bl	flash_read_page
	ldr	r3, .L2223
	mov	r10, r0
	ldr	r3, [r3]
	lsls	r2, r3, #27
	bpl	.L2198
	mov	r3, r0
	mov	r2, fp
	mov	r1, r7
	ldr	r0, .L2223+4
	bl	printf
.L2198:
	adds	r3, r6, #1
	cmp	r10, r3
	bhi	.L2199
	ldr	r3, .L2223+8
	ldr	r3, [r3]
	str	r3, [sp, #16]
	ldr	r3, .L2223+12
	ldr	r3, [r3]
	str	r3, [sp, #20]
	ldr	r3, .L2223+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r10, r3, lsr #2
	bcs	.L2209
	adds	r5, r5, #1
	cmp	r5, #7
	bls	.L2209
	subs	r4, r7, r5
	mov	r6, r10
	movs	r3, #0
	str	r3, [sp, #8]
.L2201:
	ldr	r3, [sp, #24]
	ldr	r2, [sp, #12]
	cmp	r5, r2
	it	cc
	movcc	r4, r3
.L2202:
	cmp	r4, #0
	beq	.L2204
	ldr	r3, .L2223+16
	ldrb	r2, [r3]	@ zero_extendqisi2
	ldr	r3, .L2223+20
	umull	r2, r3, r2, r3
	ubfx	r3, r3, #1, #8
	cmp	r3, r6
	bls	.L2204
	mov	r1, r4
	ldr	r0, .L2223+24
	bl	printf
	uxtb	r0, r4
.L2222:
	bl	nandc_set_ddr_para
	ldr	r3, [sp, #8]
	cmp	r3, #0
	beq	.L2197
	ldr	r4, .L2223+28
	ldrb	r3, [r4]	@ zero_extendqisi2
	lsls	r3, r3, #31
	bpl	.L2197
	mov	r1, r8
	mov	r2, fp
	ldr	r0, .L2223+32
	bl	printf
	mov	r0, r8
	bl	flash_reset
	movs	r0, #1
	bl	flash_set_interface_mode
	movs	r0, #1
	bl	nandc_set_if_mode
	ldr	r3, .L2223+36
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
	ldr	r0, .L2223+40
	bl	printf
	ldr	r3, .L2223+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r6, r3
	bhi	.L2211
	ldr	r2, .L2223+44
	ldr	r3, [r2]
	adds	r3, r3, #1
	cmp	r3, #100
	str	r3, [r2]
	bls	.L2207
	ldr	r3, .L2223+48
	movs	r2, #0
	strb	r2, [r3]
.L2197:
	mov	r0, r6
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2199:
	ldr	r3, [sp, #12]
	cmp	r5, r3
	bls	.L2210
	cmp	r5, #7
	sub	r3, r4, r5
	str	r3, [sp, #24]
	bhi	.L2202
	str	r5, [sp, #12]
.L2210:
	movs	r5, #0
	b	.L2200
.L2209:
	mov	r4, r7
	mov	r6, r10
	movs	r3, #0
	str	r3, [sp, #8]
.L2200:
	adds	r7, r7, #2
	cmp	r7, #50
	bne	.L2203
	b	.L2201
.L2204:
	ldrb	r0, [sp, #28]	@ zero_extendqisi2
	b	.L2222
.L2211:
	ldr	r6, [sp, #8]
.L2207:
	ldrb	r0, [r4]	@ zero_extendqisi2
	bl	flash_set_interface_mode
	ldrb	r0, [r4]	@ zero_extendqisi2
	bl	nandc_set_if_mode
	b	.L2197
.L2224:
	.align	2
.L2223:
	.word	.LANCHOR14
	.word	.LC125
	.word	.LANCHOR166
	.word	.LANCHOR168
	.word	.LANCHOR50
	.word	-1431655765
	.word	.LC126
	.word	.LANCHOR49
	.word	.LC127
	.word	.LANCHOR34
	.word	.LC128
	.word	.LANCHOR172
	.word	.LANCHOR21
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
	ldr	r3, .L2252
	mov	r7, r2
	mov	r5, r0
	mov	r4, r1
	ldr	r10, [sp, #48]
	ldrb	r2, [r3]	@ zero_extendqisi2
	mov	fp, r3
	cmp	r2, r0
	bhi	.L2226
	mov	r2, #428
	ldr	r1, .L2252+4
	ldr	r0, .L2252+8
	bl	printf
.L2226:
	ldr	r3, .L2252+12
	ldrb	r6, [r3, r5]	@ zero_extendqisi2
	ldrb	r3, [fp]	@ zero_extendqisi2
	cmp	r5, r3
	bcc	.L2227
	ldr	r2, .L2252+16
	ldr	r2, [r2]
	lsls	r0, r2, #25
	bmi	.L2228
.L2251:
	mov	r0, #-1
.L2225:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2228:
	str	r3, [sp]
	mov	r2, r5
	mov	r3, r4
	mov	r1, r6
	ldr	r0, .L2252+20
	bl	printf
	b	.L2251
.L2227:
	tst	r4, #50331648
	bne	.L2230
	ldr	r3, .L2252+24
	ldrb	r2, [r3]	@ zero_extendqisi2
	ldr	r3, .L2252+28
	cbz	r2, .L2231
	ldrb	r2, [r3]	@ zero_extendqisi2
	cbz	r2, .L2230
.L2231:
	ldr	r2, .L2252+32
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
	cbz	r3, .L2232
	add	r4, fp, r1, lsl #1
.L2230:
	mov	r1, r4
	str	r10, [sp]
	mov	r3, r8
	mov	r2, r7
	mov	r0, r6
	bl	flash_read_page
	adds	r1, r0, #1
	bne	.L2225
	ldr	r5, .L2252+36
	ldrb	fp, [r5]	@ zero_extendqisi2
	cmp	fp, #0
	bne	.L2233
.L2236:
	ldr	r3, .L2252+40
	ldr	fp, [r3]
	cmp	fp, #0
	bne	.L2234
.L2235:
	ldrb	r3, [r5]	@ zero_extendqisi2
	mov	r2, r4
	movs	r1, #0
	ldr	r0, .L2252+44
	str	r3, [sp]
	mov	r3, #-1
	bl	printf
	ldr	r3, .L2252+48
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L2251
	str	r10, [sp, #48]
	mov	r3, r8
	mov	r2, r7
	mov	r1, r4
	mov	r0, r6
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	flash_ddr_tuning_read
.L2232:
	ldr	r3, .L2252+52
	ldrh	r4, [r3, r1, lsl #1]
	add	r4, r4, fp
	b	.L2230
.L2233:
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
	beq	.L2236
	b	.L2225
.L2234:
	mov	r3, r8
	str	r10, [sp]
	mov	r2, r7
	mov	r1, r4
	mov	r0, r6
	blx	fp
	adds	r3, r0, #1
	beq	.L2235
	b	.L2225
.L2253:
	.align	2
.L2252:
	.word	.LANCHOR18
	.word	.LANCHOR173
	.word	.LC0
	.word	.LANCHOR30
	.word	.LANCHOR14
	.word	.LC129
	.word	.LANCHOR0
	.word	.LANCHOR1
	.word	.LANCHOR2
	.word	.LANCHOR52
	.word	.LANCHOR174
	.word	.LC130
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
	ldr	r1, .L2264
	mov	fp, r2
	mov	r10, r3
	str	r0, [sp, #12]
	ldrh	r4, [r1]
	ldr	r1, .L2264+4
	subs	r4, r4, #1
	ldrh	r6, [r1, #26]
	sxth	r4, r4
	ldr	r1, [sp, #48]
	mul	r6, r8, r6
	str	r1, [sp]
	adds	r1, r4, r6
	bl	flash_read_page_en
	cmp	r0, #512
	bne	.L2255
	movs	r7, #0
.L2256:
	cmp	r7, r4
	ble	.L2259
.L2255:
	ldr	r3, .L2264+8
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L2260
	ldr	r3, [r10]
	mov	r2, r4
	mov	r1, r8
	ldr	r0, .L2264+12
	bl	printf
.L2260:
	mov	r0, r4
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2259:
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
	b	.L2256
.L2265:
	.align	2
.L2264:
	.word	.LANCHOR147
	.word	.LANCHOR33
	.word	.LANCHOR14
	.word	.LC131
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
	ldr	r4, .L2267
	ldr	r5, .L2267+4
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
.L2268:
	.align	2
.L2267:
	.word	.LANCHOR32
	.word	.LANCHOR75
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
	ldr	r6, .L2275
	movs	r5, #1
	mov	r8, r1
	ldr	r4, .L2275+4
	ldr	fp, .L2275+8
	ldr	r10, .L2275+12
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
	bne	.L2270
	ldrb	r2, [r6]	@ zero_extendqisi2
	lsls	r2, r2, #31
	bpl	.L2270
	mov	r0, r5
	bl	flash_set_interface_mode
	mov	r0, r5
	bl	nandc_set_if_mode
	movs	r3, #0
	strb	r3, [r4]
.L2271:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2270:
	movs	r2, #1
	strb	r2, [r3]
	b	.L2271
.L2276:
	.align	2
.L2275:
	.word	.LANCHOR49
	.word	.LANCHOR21
	.word	.LANCHOR175
	.word	.LANCHOR176
	.size	flash_ddr_para_scan, .-flash_ddr_para_scan
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
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r5, r0
	str	r3, [sp, #12]
	mov	r7, r1
	mov	r10, r2
	ubfx	r8, r1, #24, #2
	ldr	r3, .L2292
	ldr	r6, [r3]
	add	r3, r0, #8
	add	fp, r6, r3, lsl #8
	ldr	r3, .L2292+4
	ldrb	r4, [r3]	@ zero_extendqisi2
	rsb	r3, r4, #24
	movs	r4, #1
	lsls	r4, r4, r3
	ldr	r3, .L2292+8
	subs	r4, r4, #1
	ldr	r3, [r3]
	ands	r4, r4, r1
	lsls	r3, r3, #27
	bpl	.L2278
	ldr	r3, [sp, #48]
	mov	r2, r8
	ldr	r0, .L2292+12
	bl	printf
.L2278:
	bl	nandc_wait_flash_ready
	mov	r0, r5
	bl	hynix_reconfig_rr_para
	mov	r0, r5
	bl	nandc_cs
	mov	r0, r5
	cmp	r8, #0
	bne	.L2279
	bl	zftl_flash_enter_slc_mode
.L2280:
	lsl	r8, r5, #8
	movs	r2, #128
	add	r3, r6, r8
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
	ldr	r2, .L2292+16
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbz	r2, .L2281
	lsrs	r2, r4, #24
	str	r2, [r3, #2052]
.L2281:
	mov	r0, r4
	add	r6, r6, r8
	bl	nandc_set_seed
	ldr	r3, .L2292+20
	movs	r1, #1
	mov	r0, r5
	ldrb	r2, [r3, #9]	@ zero_extendqisi2
	ldr	r3, [sp, #12]
	str	r3, [sp]
	mov	r3, r10
	bl	nandc_xfer
	movs	r3, #16
	str	r3, [r6, #2056]
	bl	nandc_wait_flash_ready
	mov	r0, fp
	bl	flash_read_status
	bl	nandc_de_cs.constprop.33
	ands	r0, r0, #4
	beq	.L2277
	mov	r2, r0
	mov	r1, r7
	ldr	r0, .L2292+24
	bl	printf
	mov	r0, #-1
.L2277:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2279:
	bl	zftl_flash_exit_slc_mode
	b	.L2280
.L2293:
	.align	2
.L2292:
	.word	.LANCHOR13
	.word	.LANCHOR32
	.word	.LANCHOR14
	.word	.LC132
	.word	.LANCHOR31
	.word	.LANCHOR33
	.word	.LC133
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
	ldr	r7, .L2304
	mov	r6, r0
	mov	r4, r1
	movs	r1, #165
	ldr	r5, .L2304+4
	ldr	r0, [r7]
	bl	ftl_memset
	movs	r2, #8
	movs	r1, #90
	ldr	r0, [r5]
	bl	ftl_memset
	ldr	r3, .L2304+8
	mov	r0, r6
	ldrh	r3, [r3]
	muls	r4, r3, r4
	mov	r1, r4
	bl	flash_erase_block
	adds	r0, r0, #1
	bne	.L2295
.L2297:
	mov	r5, #-1
.L2296:
	mov	r1, r4
	mov	r0, r6
	bl	flash_erase_block
	mov	r0, r5
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L2295:
	ldr	r8, .L2304+12
	mov	r1, r4
	mov	r0, r6
	ldrb	r3, [r8, #9]	@ zero_extendqisi2
	str	r3, [sp]
	ldr	r2, [r7]
	ldr	r3, [r5]
	bl	flash_prog_page
	adds	r0, r0, #1
	beq	.L2297
	ldrb	r3, [r8, #9]	@ zero_extendqisi2
	mov	r1, r4
	mov	r0, r6
	str	r3, [sp]
	ldr	r2, [r7]
	ldr	r3, [r5]
	bl	flash_read_page_en
	adds	r0, r0, #1
	beq	.L2297
	ldr	r3, [r7]
	ldr	r3, [r3]
	cmp	r3, #-1515870811
	bne	.L2297
	ldr	r3, [r5]
	ldr	r5, [r3]
	subs	r5, r5, #1515870810
	it	ne
	movne	r5, #-1
	b	.L2296
.L2305:
	.align	2
.L2304:
	.word	.LANCHOR166
	.word	.LANCHOR168
	.word	.LANCHOR2
	.word	.LANCHOR33
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
	ldr	r3, .L2313
	push	{r0, r1, r2, r4, r5, r6, r7, r8, r10, lr}
	mov	r6, r0
	mov	r7, r1
	mov	r4, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L2306
	ldr	r5, .L2313+4
	ldrb	r2, [r5, #19]	@ zero_extendqisi2
	subs	r3, r2, #5
	uxtb	r3, r3
	cmp	r3, #30
	bhi	.L2308
	ldr	r2, .L2313+8
	lsr	r3, r2, r3
	lsls	r3, r3, #31
	bmi	.L2310
.L2306:
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L2311:
	ldrh	r2, [r10, r4, lsl #1]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L2306
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
.L2312:
	ldrh	r3, [r5, #10]
	cmp	r3, r4
	bhi	.L2311
	b	.L2306
.L2308:
	cmp	r2, #68
	bne	.L2306
.L2310:
	ldr	r10, .L2313+12
	ldr	r8, .L2313+16
	b	.L2312
.L2314:
	.align	2
.L2313:
	.word	.LANCHOR19
	.word	.LANCHOR33
	.word	1073758215
	.word	.LANCHOR145
	.word	.LANCHOR166
	.size	id_block_prog_msb_ff_data, .-id_block_prog_msb_ff_data
	.section	.text.flash_start_one_pass_page_prog,"ax",%progbits
	.align	1
	.global	flash_start_one_pass_page_prog
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_start_one_pass_page_prog, %function
flash_start_one_pass_page_prog:
	@ args = 12, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r4, r5, r6, r7, r8, r10, lr}
	mov	r7, r3
	ldr	r3, .L2324
	mov	r10, r0
	mov	r0, r7
	mov	r8, r2
	ldr	r5, [sp, #40]
	lsls	r6, r7, #8
	ldr	r4, [r3]
	bl	nandc_cs
	cmp	r10, #0
	beq	.L2316
	adds	r3, r4, r6
	str	r10, [r3, #2056]
.L2316:
	adds	r3, r4, r6
	movs	r2, #128
	str	r2, [r3, #2056]
	movs	r2, #0
	str	r2, [r3, #2052]
	str	r2, [r3, #2052]
	uxtb	r2, r5
	str	r2, [r3, #2052]
	lsrs	r2, r5, #8
	str	r2, [r3, #2052]
	lsrs	r2, r5, #16
	str	r2, [r3, #2052]
	ldr	r2, .L2324+4
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbz	r2, .L2317
	lsrs	r2, r5, #24
	str	r2, [r3, #2052]
.L2317:
	mov	r0, r5
	add	r4, r4, r6
	bl	nandc_set_seed
	ldr	r3, .L2324+8
	movs	r1, #1
	mov	r0, r7
	ldrb	r2, [r3, #9]	@ zero_extendqisi2
	ldr	r3, [sp, #48]
	str	r3, [sp]
	ldr	r3, [sp, #44]
	bl	nandc_xfer
	str	r8, [r4, #2056]
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L2325:
	.align	2
.L2324:
	.word	.LANCHOR13
	.word	.LANCHOR31
	.word	.LANCHOR33
	.size	flash_start_one_pass_page_prog, .-flash_start_one_pass_page_prog
	.section	.text.flash_dual_page_prog,"ax",%progbits
	.align	1
	.global	flash_dual_page_prog
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_dual_page_prog, %function
flash_dual_page_prog:
	@ args = 12, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #24
	str	r2, [sp, #20]
	mov	fp, r3
	add	r3, r0, #8
	mov	r5, r0
	ldr	r2, .L2338
	mov	r6, r1
	ubfx	r8, r1, #24, #2
	ldr	r7, [r2]
	add	r7, r7, r3, lsl #8
	ldr	r3, .L2338+4
	ldrb	r4, [r3]	@ zero_extendqisi2
	rsb	r3, r4, #24
	movs	r4, #1
	lsls	r4, r4, r3
	ldr	r3, .L2338+8
	subs	r4, r4, #1
	ldr	r2, [r3]
	ands	r4, r4, r1
	mov	r10, r3
	tst	r2, #16
	beq	.L2327
	ldr	r3, [sp, #64]
	mov	r2, r8
	ldr	r0, .L2338+12
	bl	printf
.L2327:
	bl	nandc_wait_flash_ready
	mov	r0, r5
	bl	nandc_cs
	mov	r0, r5
	cmp	r8, #0
	bne	.L2328
	bl	zftl_flash_enter_slc_mode
.L2329:
	ldr	r3, [sp, #20]
	movs	r1, #0
	movs	r2, #16
	mov	r0, r1
	str	r4, [sp]
	adds	r4, r4, #1
	str	r3, [sp, #4]
	mov	r3, r5
	str	fp, [sp, #8]
	bl	flash_start_one_pass_page_prog
	bl	nandc_wait_flash_ready
	ldr	r3, [sp, #60]
	movs	r1, #0
	movs	r2, #16
	mov	r0, r1
	str	r4, [sp]
	str	r3, [sp, #8]
	ldr	r3, [sp, #56]
	str	r3, [sp, #4]
	mov	r3, r5
	bl	flash_start_one_pass_page_prog
	bl	nandc_wait_flash_ready
	mov	r0, r7
	bl	flash_read_status
	bl	nandc_de_cs.constprop.33
	ands	r0, r0, #4
	beq	.L2326
	ldr	r3, [r10]
	lsls	r3, r3, #19
	bpl	.L2331
	mov	r2, r0
	mov	r1, r6
	ldr	r0, .L2338+16
	bl	printf
.L2331:
	mov	r0, #-1
.L2326:
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2328:
	bl	zftl_flash_exit_slc_mode
	b	.L2329
.L2339:
	.align	2
.L2338:
	.word	.LANCHOR13
	.word	.LANCHOR32
	.word	.LANCHOR14
	.word	.LC132
	.word	.LC133
	.size	flash_dual_page_prog, .-flash_dual_page_prog
	.section	.text.ymtc_flash_tlc_page_prog,"ax",%progbits
	.align	1
	.global	ymtc_flash_tlc_page_prog
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ymtc_flash_tlc_page_prog, %function
ymtc_flash_tlc_page_prog:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r10, r2
	ldr	r2, .L2346
	mov	fp, r3
	add	r3, r0, #8
	movs	r6, #1
	mov	r5, r0
	mov	r8, r1
	ldr	r7, [r2]
	add	r7, r7, r3, lsl #8
	ldr	r3, .L2346+4
	ldrb	r4, [r3]	@ zero_extendqisi2
	rsb	r4, r4, #24
	lsl	r4, r6, r4
	subs	r4, r4, #1
	ands	r4, r4, r1
	bl	nandc_wait_flash_ready
	mov	r0, r5
	bl	nandc_cs
	mov	r0, r5
	bl	zftl_flash_exit_slc_mode
	mov	r3, r5
	movs	r2, #26
	mov	r1, r6
	stm	sp, {r4, r10, fp}
	movs	r0, #0
	bl	flash_start_one_pass_page_prog
	bl	nandc_wait_flash_ready
	adds	r3, r4, r6
	movs	r2, #26
	mov	r1, r6
	str	r3, [sp]
	movs	r0, #0
	mov	r3, r5
	str	fp, [sp, #8]
	adds	r4, r4, #2
	str	r10, [sp, #4]
	bl	flash_start_one_pass_page_prog
	bl	nandc_wait_flash_ready
	mov	r3, r5
	movs	r2, #16
	mov	r1, r6
	movs	r0, #0
	str	fp, [sp, #8]
	str	r10, [sp, #4]
	str	r4, [sp]
	bl	flash_start_one_pass_page_prog
	bl	nandc_wait_flash_ready
	mov	r0, r7
	bl	flash_read_status
	bl	nandc_de_cs.constprop.33
	ands	r0, r0, #4
	beq	.L2340
	ldr	r3, .L2346+8
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L2342
	mov	r2, r0
	mov	r1, r8
	ldr	r0, .L2346+12
	bl	printf
.L2342:
	mov	r0, #-1
.L2340:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2347:
	.align	2
.L2346:
	.word	.LANCHOR13
	.word	.LANCHOR32
	.word	.LANCHOR14
	.word	.LC134
	.size	ymtc_flash_tlc_page_prog, .-ymtc_flash_tlc_page_prog
	.section	.text.fw_flash_page_prog.constprop.30,"ax",%progbits
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	fw_flash_page_prog.constprop.30, %function
fw_flash_page_prog.constprop.30:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, lr}
	mov	r5, r1
	ldr	r8, .L2353+12
	sub	sp, sp, #20
	mov	r6, r2
	ldrb	r1, [r8, #9]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	ldr	r3, .L2353
	mov	r4, r0
	ldrb	r10, [r3]	@ zero_extendqisi2
	ldr	r3, .L2353+4
	ldrb	r0, [r3]	@ zero_extendqisi2
	bl	nandc_bch_sel
	ldrb	r3, [r8, #7]	@ zero_extendqisi2
	cmp	r3, #9
	bne	.L2349
	ldr	r3, .L2353+8
	ldrb	r7, [r3]	@ zero_extendqisi2
	cbnz	r7, .L2349
	ldrb	r3, [r8, #12]	@ zero_extendqisi2
	cmp	r3, #3
	bne	.L2350
	mov	r3, r6
	mov	r2, r5
	mov	r1, r4
	mov	r0, r7
	bl	ymtc_flash_tlc_page_prog
.L2352:
	mov	r4, r0
	mov	r0, r10
	bl	nandc_bch_sel
	mov	r0, r4
	add	sp, sp, #20
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L2350:
	ldr	r8, .L2353+16
	mov	r2, #16384
	movs	r1, #255
	ldr	r0, [r8]
	bl	ftl_memset
	ldr	r3, [r8]
	movs	r2, #4
	str	r2, [sp, #8]
	mov	r1, r4
	mov	r2, r5
	mov	r0, r7
	str	r3, [sp, #4]
	str	r3, [sp]
	mov	r3, r6
	bl	flash_dual_page_prog
	b	.L2352
.L2349:
	movs	r3, #4
	mov	r2, r5
	str	r3, [sp]
	mov	r1, r4
	mov	r3, r6
	movs	r0, #0
	bl	flash_prog_page
	b	.L2352
.L2354:
	.align	2
.L2353:
	.word	.LANCHOR50
	.word	.LANCHOR17
	.word	.LANCHOR19
	.word	.LANCHOR33
	.word	.LANCHOR166
	.size	fw_flash_page_prog.constprop.30, .-fw_flash_page_prog.constprop.30
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
	cmp	r1, #64
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r1
	sub	sp, sp, #152
	mov	r7, r2
	mov	r5, r3
	ldr	r6, .L2484
	bne	.L2356
	ldr	r3, [r2]
	ldr	r2, .L2484+4
	cmp	r3, r2
	beq	.L2357
	ldr	r2, .L2484+8
	cmp	r3, r2
	beq	.L2357
	add	r2, r2, #327680
	cmp	r3, r2
	bne	.L2356
.L2357:
	ldr	r8, .L2484+16
	movs	r2, #1
	strb	r2, [r6]
	ldr	r3, [r8]
	cbnz	r3, .L2358
	mov	r0, #262144
	bl	ftl_malloc
	str	r0, [r8]
.L2358:
	ldr	r3, .L2484+12
	movs	r2, #64
	str	r2, [r3]
.L2356:
	ldrb	r0, [r6]	@ zero_extendqisi2
	cmp	r0, #0
	beq	.L2355
	ldr	r3, .L2484+16
	ldr	r10, [r3]
	mov	r8, r3
	cmp	r10, #0
	beq	.L2483
	adds	r3, r4, r5
	cmp	r3, #63
	str	r3, [sp, #72]
	bls	.L2360
	cmp	r4, #576
	bcs	.L2361
	ldr	r10, .L2484+24
	ldr	r3, [r10]
	cbz	r3, .L2362
.L2365:
	ldr	r3, .L2484+20
	cmp	r4, #64
	mov	r2, #1
	ldr	r0, [r8]
	str	r2, [r3]
	bhi	.L2478
	rsb	r1, r4, #64
	subs	r2, r5, r1
	add	r1, r7, r1, lsl #9
	lsls	r2, r2, #9
.L2482:
	bl	ftl_memcpy
.L2366:
	ldr	r3, .L2484+12
	ldr	r3, [r3]
	cmp	r4, r3
	itt	ne
	movne	r3, #0
	strbne	r3, [r6]
	b	.L2423
.L2362:
	mov	r0, #262144
	bl	ftl_malloc
	str	r0, [r10]
	cmp	r0, #0
	bne	.L2365
	mov	r0, #-1
	b	.L2355
.L2478:
	rsb	r2, r4, #576
	sub	r3, r4, #64
	cmp	r2, r5
	mov	r1, r7
	it	cs
	movcs	r2, r5
	add	r0, r0, r3, lsl #9
	lsls	r2, r2, #9
	b	.L2482
.L2485:
	.align	2
.L2484:
	.word	.LANCHOR143
	.word	-52655045
	.word	1397640018
	.word	.LANCHOR177
	.word	.LANCHOR141
	.word	.LANCHOR142
	.word	.LANCHOR144
.L2360:
	cmp	r4, #576
	bcc	.L2366
.L2361:
	ldr	r3, .L2486
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L2366
	ldr	r3, [r10]
	ldr	r2, .L2486+4
	cmp	r3, r2
	beq	.L2367
	ldr	r2, .L2486+8
	cmp	r3, r2
	beq	.L2367
	add	r2, r2, #327680
	cmp	r3, r2
	bne	.L2368
.L2367:
	ldr	r7, .L2486+12
	ldrb	r3, [r7]	@ zero_extendqisi2
	str	r3, [sp, #24]
	ldr	r3, .L2486+16
	ldrb	r2, [r3]	@ zero_extendqisi2
	mov	r8, r3
	ldr	r3, [sp, #24]
	str	r2, [sp, #12]
	cmp	r3, #0
	beq	.L2369
	clz	fp, r2
	ldrh	r3, [sp, #24]
	lsr	fp, fp, #5
	str	r3, [sp, #36]
.L2370:
	ldr	r6, .L2486+20
	movs	r0, #0
	ldrb	r5, [r6, #9]	@ zero_extendqisi2
	ldrh	r4, [r6, #26]
	bl	zftl_flash_exit_slc_mode
	ldrh	r0, [r6, #10]
	ldrb	r3, [r8]	@ zero_extendqisi2
	ldrb	r1, [r6, #12]	@ zero_extendqisi2
	movw	r6, #4098
	strb	r3, [r7]
	lsls	r0, r0, #2
	ldr	r7, .L2486+24
	bl	__aeabi_idiv
	cmp	r0, #512
	mov	r3, r0
	it	ge
	movge	r3, #512
	add	r1, r10, #260096
	str	r3, [sp, #32]
	movw	r2, #65023
	movs	r3, #0
.L2376:
	ldr	r0, [r1, #-4]!
	cbnz	r0, .L2372
	cmp	r3, #0
	bne	.L2373
	str	r7, [r1, #2048]
.L2374:
	adds	r3, r3, #1
	subs	r2, r2, #1
	cmp	r3, r6
	it	hi
	movhi	r3, #0
	cmp	r2, #4096
	bne	.L2376
.L2372:
	ldr	r3, [sp, #32]
	ldr	r1, [r10, r2, lsl #2]
	ldr	r0, .L2486+28
	bl	printf
	mul	r3, r5, r4
	str	r3, [sp, #84]
	movs	r3, #0
	str	r3, [sp, #16]
	str	r3, [sp, #28]
.L2418:
	ldr	r3, .L2486+32
	mov	r2, #512
	movs	r1, #0
	ldr	r0, [r3]
	bl	ftl_memset
	ldr	r3, .L2486+36
	ldr	r2, [sp, #28]
	ldr	r3, [r3]
	add	r3, r3, r2
	ldrb	r3, [r3, #32]	@ zero_extendqisi2
	cmp	r3, #255
	beq	.L2377
	ldr	r2, [sp, #84]
	muls	r3, r2, r3
	str	r3, [sp, #8]
	cmp	fp, #0
	beq	.L2378
	ldr	r3, [sp, #28]
	ldr	r5, .L2486+12
	ldr	r4, .L2486+16
	bic	r3, r3, #2
	cmp	r3, #1
	beq	.L2379
	cmp	fp, #3
	bne	.L2380
.L2379:
	ldrb	r3, [sp, #36]	@ zero_extendqisi2
.L2480:
	strb	r3, [r5]
	strb	r3, [r4]
.L2378:
	ldr	r7, .L2486+20
	movs	r5, #0
	ldr	r3, .L2486+40
	ldr	r0, [sp, #8]
	ldrb	r6, [r7, #9]	@ zero_extendqisi2
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldrh	r4, [r7, #26]
	mov	r1, r6
	str	r3, [sp, #76]
	ldr	r3, .L2486+40
	muls	r4, r6, r4
	strb	r5, [r3]
	bl	__aeabi_uidiv
	mov	r1, r0
	mov	r0, r5
	bl	flash_erase_block
	mov	r1, r4
	ldr	r0, [sp, #8]
	bl	__aeabi_uidivmod
	ldrh	r0, [r7, #10]
	ldr	r3, [sp, #8]
	str	r1, [sp, #44]
	subs	r3, r3, r1
	lsls	r0, r0, #2
	ldrb	r1, [r7, #12]	@ zero_extendqisi2
	str	r3, [sp, #40]
	bl	__aeabi_idiv
	ldr	r3, [sp, #8]
	ldr	r2, [sp, #40]
	str	r0, [sp, #48]
	cmp	r3, r2
	bne	.L2433
	ldr	r3, .L2486+44
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #9
	bne	.L2433
	ldr	r3, .L2486+32
	mov	r2, #1024
	mov	r1, r5
	ldr	r4, [r3]
	mov	r0, r4
	bl	ftl_memset
	ldr	r2, .L2486+48
	movs	r3, #12
	str	r5, [r4, #12]
	strb	r5, [r4, #16]
	stm	r4, {r2, r3}
	ldr	r3, .L2486+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2382
	ldrb	r3, [r7, #29]	@ zero_extendqisi2
	strb	r3, [r4, #16]
.L2382:
	movs	r3, #4
	strb	r3, [r4, #17]
	ldr	r3, .L2486+20
	ldrb	r1, [r3, #12]	@ zero_extendqisi2
	ldrh	r0, [r3, #10]
	bl	__aeabi_idiv
	cmp	r6, #8
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
	str	r3, [sp, #20]
.L2381:
	mov	r8, r10
	movs	r7, #0
.L2384:
	ldr	r3, [sp, #48]
	cmp	r3, r7
	bhi	.L2395
	ldr	r3, .L2486+32
	movs	r4, #0
	ldr	r0, [sp, #8]
	movs	r6, #4
	ldr	r5, [r3]
	ldr	r3, .L2486+20
	ldrb	r2, [r3, #9]	@ zero_extendqisi2
	ldrh	r1, [r3, #26]
	ldr	r3, .L2486+40
	str	r2, [sp, #64]
	strb	r4, [r3]
	muls	r1, r2, r1
	bl	__aeabi_uidivmod
	ldr	r3, [sp, #8]
	str	r1, [sp, #44]
	str	r4, [sp, #56]
	subs	r3, r3, r1
	str	r3, [sp, #68]
	and	r3, r1, #3
	str	r3, [sp, #48]
	ldr	r3, [sp, #20]
	str	r3, [sp, #60]
.L2396:
	ldr	r3, [sp, #60]
	cmp	r4, r3
	bcc	.L2412
	ldr	r3, .L2486+40
	ldrb	r2, [sp, #76]	@ zero_extendqisi2
	strb	r2, [r3]
	cmp	fp, #0
	beq	.L2413
	movs	r0, #0
	bl	zftl_flash_exit_slc_mode
	ldr	r2, .L2486+12
	movs	r3, #0
	strb	r3, [r2]
	ldr	r2, .L2486+16
	strb	r3, [r2]
.L2413:
	ldr	r3, [sp, #20]
	movs	r4, #0
	lsls	r1, r3, #7
	ldr	r3, .L2486+32
	ldr	r0, [r3]
.L2414:
	cmp	r4, r1
	bne	.L2416
	ldr	r3, [sp, #16]
	adds	r3, r3, #1
	cmp	r3, #5
	str	r3, [sp, #16]
	bls	.L2377
	b	.L2425
.L2369:
	ldr	r3, [sp, #12]
	cmp	r3, #3
	beq	.L2429
	cmp	r3, #2
	bne	.L2430
	str	r3, [sp, #36]
	mov	fp, #3
	b	.L2370
.L2429:
	ldr	r3, [sp, #12]
	mov	fp, #2
	str	r3, [sp, #36]
	b	.L2370
.L2430:
	ldr	r3, [sp, #24]
	str	r3, [sp, #36]
	mov	fp, r3
	b	.L2370
.L2373:
	ldr	r0, [r10, r3, lsl #2]
	str	r0, [r1, #2048]
	b	.L2374
.L2380:
	movs	r0, #0
	bl	zftl_flash_exit_slc_mode
	movs	r3, #0
	b	.L2480
.L2433:
	ldr	r3, [sp, #32]
	mov	r4, r5
	str	r3, [sp, #20]
	b	.L2381
.L2487:
	.align	2
.L2486:
	.word	.LANCHOR142
	.word	-52655045
	.word	1397640018
	.word	.LANCHOR0
	.word	.LANCHOR19
	.word	.LANCHOR33
	.word	1330594389
	.word	.LC135
	.word	.LANCHOR144
	.word	.LANCHOR27
	.word	.LANCHOR52
	.word	.LANCHOR28
	.word	1179535694
.L2395:
	ldr	r3, [sp, #44]
	adds	r5, r3, r7
	ldr	r3, .L2488
	ubfx	r5, r5, #2, #16
	adds	r2, r5, #1
	ldrh	r0, [r3, r2, lsl #1]
	ldr	r3, .L2488+4
	ldrb	r1, [r3]	@ zero_extendqisi2
	cmp	r1, #0
	bne	.L2385
	mov	r2, r0
.L2386:
	ldr	r0, .L2488+8
	ldr	r3, .L2488
	ldrb	r0, [r0]	@ zero_extendqisi2
	cmp	r0, #9
	itt	ne
	addne	r2, r2, #-1
	lslne	r2, r2, #2
	str	r2, [sp, #88]
	movw	r2, #61424
	str	r2, [sp, #92]
	ldrh	r2, [r3, r5, lsl #1]
	cbnz	r1, .L2390
	mov	r5, r2
.L2391:
	mul	r0, r5, r6
	add	r2, sp, #88
	cbnz	r4, .L2392
	ldr	r3, [sp, #40]
	mov	r1, r8
	add	r0, r0, r3
	bl	fw_flash_page_prog.constprop.30
	ldr	r3, .L2488+4
	ldrb	r2, [r3]	@ zero_extendqisi2
	cbnz	r2, .L2393
	adds	r5, r5, #1
	mov	r1, r6
	uxth	r5, r5
	ldr	r0, [sp, #40]
	bl	__aeabi_uidiv
	mov	r2, r5
	mov	r1, r0
	mov	r0, r4
	bl	id_block_prog_msb_ff_data
.L2393:
	ldr	r3, [sp, #20]
	add	r8, r8, #2048
	add	r2, r3, #16
	cmp	r7, r2
	bcc	.L2394
	add	r2, r3, #20
	cmp	r7, r2
	bcs	.L2394
	add	r8, r10, #2048
.L2394:
	adds	r3, r7, #4
	movs	r4, #0
	uxth	r7, r3
	b	.L2384
.L2385:
	ldr	r0, .L2488+12
	ldrb	r0, [r0]	@ zero_extendqisi2
	cmp	r0, #0
	beq	.L2386
	lsls	r2, r2, #1
	b	.L2386
.L2390:
	ldr	r2, .L2488+12
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, #0
	beq	.L2391
	lsls	r5, r5, #1
	b	.L2391
.L2392:
	ldr	r3, [sp, #40]
	mov	r1, r4
	add	r0, r0, r3
	bl	fw_flash_page_prog.constprop.30
	b	.L2394
.L2412:
	ldr	r3, [sp, #48]
	mov	r1, r6
	subs	r3, r6, r3
	uxth	r3, r3
	str	r3, [sp, #52]
	ldr	r3, [sp, #44]
	adds	r0, r3, r4
	bl	__aeabi_uidiv
	ldr	r2, .L2488+4
	uxth	r0, r0
	ldr	r3, .L2488
	ldrb	r2, [r2]	@ zero_extendqisi2
	ldrh	r3, [r3, r0, lsl #1]
	cmp	r2, #0
	bne	.L2397
	mov	r0, r3
.L2398:
	ldr	r3, .L2488+16
	ldr	r2, [sp, #68]
	ldrb	r8, [r3]	@ zero_extendqisi2
	ldr	r3, [sp, #48]
	add	r3, r3, r2
	ldr	r2, .L2488+20
	ldrb	r1, [r2, #9]	@ zero_extendqisi2
	ldr	r2, [sp, #64]
	mla	r0, r0, r2, r3
	bl	__aeabi_uidiv
	ldr	r3, .L2488+24
	str	r0, [sp, #40]
	mov	r0, r8
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp, #80]
	bl	nandc_bch_sel
.L2399:
	str	r6, [sp]
	add	r3, sp, #88
	mov	r2, r5
	ldr	r1, [sp, #40]
	movs	r0, #0
	bl	flash_read_page
	adds	r0, r0, #1
	bne	.L2400
	ldr	r3, .L2488+28
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r7, r3
	cmp	r3, #0
	bne	.L2401
.L2404:
	ldr	r3, .L2488+32
	ldr	r3, [r3]
	mov	r7, r3
	cmp	r3, #0
	bne	.L2402
.L2403:
	ldr	r3, .L2488+36
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2406
	str	r6, [sp]
	add	r3, sp, #88
	mov	r2, r5
	ldr	r1, [sp, #40]
	movs	r0, #0
	bl	flash_ddr_tuning_read
	adds	r0, r0, #1
	bne	.L2400
.L2406:
	cmp	r8, #16
	bne	.L2407
	mov	r7, #-1
.L2408:
	ldr	r0, [sp, #80]
	bl	nandc_bch_sel
	ldr	r3, [sp, #56]
	cmp	r7, #0
	it	ne
	movne	r3, #-1
	ldr	r2, [sp, #68]
	str	r3, [sp, #56]
	ldr	r3, [sp, #8]
	cmp	r3, r2
	bne	.L2410
	cmp	r4, #0
	bne	.L2410
	ldr	r3, [sp, #56]
	cmp	r3, #0
	bne	.L2410
	ldr	r2, [r5]
	ldr	r3, .L2488+40
	cmp	r2, r3
	bne	.L2410
	ldr	r3, [sp, #60]
	ldr	r2, [sp, #52]
	ldrb	r6, [r5, #17]	@ zero_extendqisi2
	add	r3, r3, r2
	str	r3, [sp, #60]
.L2411:
	ldr	r3, [sp, #52]
	add	r3, r3, r4
	uxth	r4, r3
	b	.L2396
.L2397:
	ldr	r3, .L2488+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L2398
	lsls	r0, r0, #1
	b	.L2398
.L2401:
	ldr	r3, .L2488+28
	movs	r0, #0
	mov	r2, r5
	ldr	r1, [sp, #40]
	strb	r0, [r3]
	add	r3, sp, #88
	str	r6, [sp]
	bl	flash_read_page
	ldr	r3, .L2488+28
	adds	r0, r0, #1
	strb	r7, [r3]
	beq	.L2404
.L2400:
	movs	r7, #0
	b	.L2408
.L2402:
	str	r6, [sp]
	add	r3, sp, #88
	mov	r2, r5
	ldr	r1, [sp, #40]
	movs	r0, #0
	blx	r7
	adds	r0, r0, #1
	beq	.L2403
	b	.L2400
.L2407:
	movs	r0, #16
	mov	r8, #16
	bl	nandc_bch_sel
	b	.L2399
.L2410:
	ldr	r3, [sp, #52]
	add	r5, r5, r3, lsl #9
	movs	r3, #0
	str	r3, [sp, #48]
	b	.L2411
.L2416:
	ldr	r2, [r0, r4, lsl #2]
	ldr	r3, [r10, r4, lsl #2]
	cmp	r2, r3
	beq	.L2415
	mov	r2, #512
	movs	r1, #0
	bl	ftl_memset
	mov	r1, r4
	ldr	r0, .L2488+44
	bl	printf
	ldr	r1, [sp, #8]
	movs	r0, #0
	bl	flash_erase_block
.L2377:
	ldr	r3, [sp, #28]
	adds	r3, r3, #1
	cmp	r3, #4
	str	r3, [sp, #28]
	bne	.L2418
.L2425:
	movs	r0, #0
	bl	zftl_flash_exit_slc_mode
	ldr	r3, .L2488+48
	ldrb	r2, [sp, #24]	@ zero_extendqisi2
	strb	r2, [r3]
	cmp	fp, #0
	beq	.L2419
	ldr	r3, .L2488+4
	ldrb	r2, [sp, #12]	@ zero_extendqisi2
	strb	r2, [r3]
.L2419:
	ldr	r3, .L2488+52
	movs	r2, #2
	movs	r0, #0
	strb	r2, [r3]
	bl	zftl_flash_enter_slc_mode
	ldr	r3, [sp, #16]
	cbnz	r3, .L2368
	mov	r1, r3
	ldr	r0, .L2488+56
	bl	printf
.L2368:
	ldr	r5, .L2488+60
	movs	r4, #0
	ldr	r3, .L2488+64
	ldr	r0, [r5]
	str	r4, [r3]
	ldr	r3, .L2488+68
	strb	r4, [r3]
	cbz	r0, .L2421
	bl	free
	str	r4, [r5]
.L2421:
	ldr	r4, .L2488+72
	ldr	r0, [r4]
	cbz	r0, .L2423
	bl	free
	movs	r3, #0
	str	r3, [r4]
.L2423:
	ldr	r3, .L2488+76
	ldr	r2, [sp, #72]
	str	r2, [r3]
.L2483:
	movs	r0, #0
.L2355:
	add	sp, sp, #152
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2415:
	adds	r4, r4, #1
	b	.L2414
.L2489:
	.align	2
.L2488:
	.word	.LANCHOR3
	.word	.LANCHOR19
	.word	.LANCHOR28
	.word	.LANCHOR1
	.word	.LANCHOR17
	.word	.LANCHOR33
	.word	.LANCHOR50
	.word	.LANCHOR52
	.word	.LANCHOR174
	.word	.LANCHOR21
	.word	1179535694
	.word	.LC136
	.word	.LANCHOR0
	.word	.LANCHOR34
	.word	.LC137
	.word	.LANCHOR141
	.word	.LANCHOR142
	.word	.LANCHOR143
	.word	.LANCHOR144
	.word	.LANCHOR177
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
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r6, r3
	mov	r8, r2
	ldr	r3, [sp, #56]
	mov	r4, r0
	mov	r7, r1
	ldr	r2, .L2497
	str	r3, [sp, #12]
	ldr	r5, [sp, #48]
	ldrb	r3, [r2]	@ zero_extendqisi2
	mov	fp, r2
	ldr	r10, [sp, #52]
	cmp	r3, r6
	bhi	.L2491
	movw	r2, #859
	ldr	r1, .L2497+4
	ldr	r0, .L2497+8
	bl	printf
.L2491:
	ldrb	r3, [fp]	@ zero_extendqisi2
	cmp	r3, r6
	bls	.L2490
	ldr	r3, .L2497+12
	ldrb	r6, [r3, r6]	@ zero_extendqisi2
	ldr	r3, .L2497+16
	mov	r0, r6
	ldr	fp, [r3]
	bl	nandc_cs
	lsls	r3, r6, #8
	cbz	r4, .L2493
	add	r1, fp, r3
	str	r4, [r1, #2056]
.L2493:
	add	r4, fp, r3
	movs	r3, #128
	str	r7, [r4, #2056]
	str	r3, [r4, #2056]
	movs	r3, #0
	str	r3, [r4, #2052]
	str	r3, [r4, #2052]
	uxtb	r3, r5
	str	r3, [r4, #2052]
	lsrs	r3, r5, #8
	str	r3, [r4, #2052]
	lsrs	r3, r5, #16
	add	r5, r5, r5, lsl #1
	str	r3, [r4, #2052]
	subs	r0, r5, #1
	add	r0, r0, r7
	bl	nandc_set_seed
	ldr	r3, .L2497+20
	movs	r1, #1
	mov	r0, r6
	ldrb	r2, [r3, #9]	@ zero_extendqisi2
	ldr	r3, [sp, #12]
	str	r3, [sp]
	mov	r3, r10
	bl	nandc_xfer
	str	r8, [r4, #2056]
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	nandc_de_cs.constprop.33
.L2490:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2498:
	.align	2
.L2497:
	.word	.LANCHOR18
	.word	.LANCHOR178
	.word	.LC0
	.word	.LANCHOR30
	.word	.LANCHOR13
	.word	.LANCHOR33
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
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, lr}
	movs	r7, #1
	ldr	r3, .L2503
	mov	r6, r0
	mov	r8, r1
	ldr	r2, [r0]
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldr	r1, [r2, #24]
	rsb	r0, r3, #24
	lsl	r4, r7, r3
	ldr	r3, .L2503+4
	lsl	r5, r7, r0
	subs	r4, r4, #1
	subs	r5, r5, #1
	ldrb	r3, [r3]	@ zero_extendqisi2
	ands	r5, r5, r1
	lsrs	r1, r1, r0
	ands	r4, r4, r1
	uxtb	r4, r4
	cmp	r3, #0
	beq	.L2500
	mov	r0, r4
	bl	zftl_flash_exit_slc_mode
	ldr	r3, [r6]
	mov	r1, r7
	movs	r0, #0
	ldr	r2, [r3, #12]
	str	r2, [sp, #8]
	movs	r2, #26
	ldr	r3, [r3, #4]
	str	r5, [sp]
	str	r3, [sp, #4]
	mov	r3, r4
	bl	flash_start_one_pass_page_prog
	bl	nandc_wait_flash_ready
	ldr	r3, [r6, #4]
	mov	r1, r7
	movs	r0, #0
	ldr	r2, [r3, #12]
	str	r2, [sp, #8]
	movs	r2, #26
	ldr	r3, [r3, #4]
	str	r3, [sp, #4]
	adds	r3, r5, r7
	str	r3, [sp]
	mov	r3, r4
	bl	flash_start_one_pass_page_prog
	bl	nandc_wait_flash_ready
	ldr	r3, [r6, #8]
	adds	r5, r5, #2
	mov	r1, r7
	movs	r0, #0
	ldr	r2, [r3, #12]
	str	r2, [sp, #8]
	movs	r2, #16
	ldr	r3, [r3, #4]
	str	r5, [sp]
	str	r3, [sp, #4]
	mov	r3, r4
	bl	flash_start_one_pass_page_prog
.L2501:
	cmp	r8, #0
	beq	.L2499
	ldr	r1, [r6]
	movs	r3, #4
	ldr	r0, .L2503+8
	strb	r3, [r1, #42]
	movs	r3, #1
	strb	r3, [r1, #43]
	movs	r3, #255
	strb	r3, [r1]
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, lr}
	b	buf_add_tail
.L2500:
	ldr	r3, [r2, #12]
	mov	r1, r7
	ldrb	r0, [r2, #44]	@ zero_extendqisi2
	str	r3, [sp, #8]
	ldr	r3, [r2, #4]
	movs	r2, #26
	str	r5, [sp]
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
	b	.L2501
.L2499:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L2504:
	.align	2
.L2503:
	.word	.LANCHOR32
	.word	.LANCHOR37
	.word	.LANCHOR60
	.size	queue_tlc_prog_cmd, .-queue_tlc_prog_cmd
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
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, lr}
	movs	r7, #1
	ldr	r3, .L2508
	mov	r5, r0
	ldr	r2, [r0, #24]
	ldrb	r3, [r3]	@ zero_extendqisi2
	rsb	r1, r3, #24
	lsl	r4, r7, r3
	lsl	r6, r7, r1
	ldr	r3, .L2508+4
	subs	r6, r6, #1
	subs	r4, r4, #1
	ands	r6, r6, r2
	lsrs	r2, r2, r1
	ldrb	r8, [r3]	@ zero_extendqisi2
	ands	r4, r4, r2
	uxtb	r4, r4
	cmp	r8, #0
	beq	.L2506
	mov	r0, r4
	bl	zftl_flash_exit_slc_mode
	ldr	r3, [r5, #12]
	movs	r2, #26
	mov	r1, r7
	str	r6, [sp]
	movs	r0, #0
	str	r3, [sp, #8]
	ldr	r3, [r5, #4]
	str	r3, [sp, #4]
	mov	r3, r4
	bl	flash_start_one_pass_page_prog
	bl	nandc_wait_flash_ready
	ldr	r3, [r5, #12]
	movs	r2, #26
	mov	r1, r7
	movs	r0, #0
	str	r3, [sp, #8]
	ldr	r3, [r5, #4]
	str	r3, [sp, #4]
	adds	r3, r6, r7
	str	r3, [sp]
	mov	r3, r4
	bl	flash_start_one_pass_page_prog
	bl	nandc_wait_flash_ready
	ldr	r3, [r5, #12]
	adds	r6, r6, #2
	str	r6, [sp]
	movs	r2, #16
	mov	r1, r7
	movs	r0, #0
	str	r3, [sp, #8]
	ldr	r3, [r5, #4]
	str	r3, [sp, #4]
	mov	r3, r4
	bl	flash_start_one_pass_page_prog
.L2507:
	bl	nandc_wait_flash_ready
	movs	r1, #64
	ldr	r0, [r5, #24]
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, lr}
	b	flash_wait_device_ready
.L2506:
	ldr	r3, [r0, #12]
	mov	r1, r7
	movs	r2, #26
	str	r3, [sp, #8]
	ldr	r3, [r0, #4]
	mov	r0, r8
	str	r6, [sp]
	str	r3, [sp, #4]
	mov	r3, r4
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	r3, [r5, #12]
	movs	r2, #26
	movs	r1, #2
	mov	r0, r8
	str	r6, [sp]
	str	r3, [sp, #8]
	ldr	r3, [r5, #4]
	str	r3, [sp, #4]
	mov	r3, r4
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	r3, [r5, #12]
	movs	r2, #16
	str	r6, [sp]
	movs	r1, #3
	mov	r0, r8
	str	r3, [sp, #8]
	ldr	r3, [r5, #4]
	str	r3, [sp, #4]
	mov	r3, r4
	bl	flash_start_tlc_page_prog
	b	.L2507
.L2509:
	.align	2
.L2508:
	.word	.LANCHOR32
	.word	.LANCHOR37
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
	push	{r0, r1, r4, r5, r6, r7, r8, lr}
	mov	r5, r2
	ldr	r4, .L2513
	mov	r7, r0
	mov	r6, r1
	mov	r8, r3
	ldrb	r2, [r4]	@ zero_extendqisi2
	cmp	r2, r1
	bhi	.L2511
	mov	r2, #892
	ldr	r1, .L2513+4
	ldr	r0, .L2513+8
	bl	printf
.L2511:
	ldrb	r3, [r4]	@ zero_extendqisi2
	cmp	r3, r6
	bls	.L2510
	ldr	r3, .L2513+12
	ldrb	r6, [r3, r6]	@ zero_extendqisi2
	ldr	r3, .L2513+16
	mov	r0, r6
	ldr	r4, [r3]
	bl	nandc_cs
	movs	r3, #128
	mov	r0, r5
	add	r4, r4, r6, lsl #8
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
	ldr	r3, .L2513+20
	movs	r1, #1
	mov	r0, r6
	ldrb	r2, [r3, #9]	@ zero_extendqisi2
	ldr	r3, [sp, #32]
	str	r3, [sp]
	mov	r3, r8
	bl	nandc_xfer
	str	r7, [r4, #2056]
.L2510:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L2514:
	.align	2
.L2513:
	.word	.LANCHOR18
	.word	.LANCHOR179
	.word	.LC0
	.word	.LANCHOR30
	.word	.LANCHOR13
	.word	.LANCHOR33
	.size	flash_start_3d_mlc_page_prog, .-flash_start_3d_mlc_page_prog
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
	ldr	r3, .L2520
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
	ldr	r3, .L2520+4
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L2516
	ldr	r2, [r5, #24]
	mov	r1, r6
	ldr	r0, .L2520+8
	adds	r3, r2, #1
	bl	printf
.L2516:
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
	bl	nandc_de_cs.constprop.33
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, pc}
.L2521:
	.align	2
.L2520:
	.word	.LANCHOR32
	.word	.LANCHOR14
	.word	.LC138
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
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	fp, r2
	str	r3, [sp, #12]
	mov	r8, r1
	ldr	r3, .L2536
	ldr	r6, .L2536+4
	str	r0, [sp, #8]
	ldrb	r2, [r3]	@ zero_extendqisi2
	movs	r3, #1
	rsb	r4, r2, #24
	lsls	r3, r3, r2
	lsr	r2, r1, r4
	subs	r3, r3, #1
	ands	r3, r3, r2
	ldrb	r2, [r6]	@ zero_extendqisi2
	uxtb	r10, r3
	cmp	r2, r10
	bhi	.L2523
	movw	r2, #945
	ldr	r1, .L2536+8
	ldr	r0, .L2536+12
	bl	printf
.L2523:
	ldrb	r2, [r6]	@ zero_extendqisi2
	cmp	r2, r10
	bls	.L2522
	movs	r2, #1
	lsl	r4, r2, r4
	ldr	r2, .L2536+16
	subs	r4, r4, #1
	ldrb	r5, [r2, r10]	@ zero_extendqisi2
	and	r4, r4, r8
	ldr	r2, .L2536+20
	ldr	r7, [r2]
	bl	nandc_rdy_status
	cbnz	r0, .L2525
	ldrb	r2, [r6]	@ zero_extendqisi2
	cmp	r2, #1
	bne	.L2526
	bl	nandc_wait_flash_ready
.L2525:
	mov	r0, r5
	bl	hynix_reconfig_rr_para
	mov	r0, r5
	bl	nandc_cs
	tst	r8, #50331648
	bne	.L2527
	mov	r0, r4
	bl	slc_phy_page_address_calc
	ldr	r3, .L2536+24
	mov	r4, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2528
	mov	r0, r5
	bl	zftl_flash_enter_slc_mode
.L2528:
	lsls	r6, r5, #8
	movs	r2, #128
	adds	r3, r7, r6
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
	ldr	r2, .L2536+28
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbz	r2, .L2529
	lsrs	r2, r4, #24
	str	r2, [r3, #2052]
.L2529:
	mov	r0, r4
	add	r7, r7, r6
	bl	nandc_set_seed
	ldr	r3, .L2536+32
	movs	r1, #1
	mov	r0, r5
	ldrb	r2, [r3, #9]	@ zero_extendqisi2
	ldr	r3, [sp, #12]
	str	r3, [sp]
	mov	r3, fp
	bl	nandc_xfer
	ldr	r3, [sp, #8]
	str	r3, [r7, #2056]
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	nandc_de_cs.constprop.33
.L2526:
	movs	r2, #64
	mov	r1, r4
	mov	r0, r10
	bl	flash_wait_device_ready_raw
	b	.L2525
.L2527:
	mov	r0, r5
	bl	zftl_flash_exit_slc_mode
	b	.L2528
.L2522:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2537:
	.align	2
.L2536:
	.word	.LANCHOR32
	.word	.LANCHOR18
	.word	.LANCHOR180
	.word	.LC0
	.word	.LANCHOR30
	.word	.LANCHOR13
	.word	.LANCHOR0
	.word	.LANCHOR31
	.word	.LANCHOR33
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
	ldr	r3, .L2546
	ldr	r2, [r4, #24]
	ldrb	r0, [r3]	@ zero_extendqisi2
	cmp	r0, #255
	beq	.L2539
	ldr	r3, .L2546+4
	movs	r7, #48
	ldr	ip, .L2546+8
	ldrb	r1, [r3]	@ zero_extendqisi2
	movs	r3, #1
	mov	lr, ip
	rsb	r6, r1, #24
	lsls	r3, r3, r1
	asrs	r2, r2, r6
	subs	r3, r3, #1
	uxth	r3, r3
	ands	r2, r2, r3
.L2541:
	mla	r5, r7, r0, ip
	ldr	r1, [r5, #24]
	lsrs	r1, r1, r6
	ands	r1, r1, r3
	cmp	r2, r1
	bne	.L2540
	add	r1, r5, #42
	ldrb	r5, [r5, #42]	@ zero_extendqisi2
	cmp	r5, #7
	bne	.L2540
	movs	r3, #3
	strb	r3, [r1]
.L2539:
	movs	r3, #3
	mov	r1, r4
	strb	r3, [r4, #42]
	movs	r3, #1
	strb	r3, [r4, #43]
	movs	r3, #255
	strb	r3, [r4]
	ldr	r0, .L2546
	pop	{r3, r4, r5, r6, r7, lr}
	b	buf_add_tail
.L2540:
	muls	r0, r7, r0
	ldrb	r0, [lr, r0]	@ zero_extendqisi2
	cmp	r0, #255
	bne	.L2541
	b	.L2539
.L2547:
	.align	2
.L2546:
	.word	.LANCHOR60
	.word	.LANCHOR32
	.word	.LANCHOR56
	.size	queue_prog_cmd, .-queue_prog_cmd
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
	ldr	r3, .L2578
	push	{r0, r1, r2, r4, r5, r6, r7, r8, r10, lr}
	movs	r5, #1
	mov	r8, r2
	mov	r6, r0
	mov	r7, r1
	ldrb	r3, [r3]	@ zero_extendqisi2
	rsb	r4, r3, #24
	lsls	r5, r5, r3
	lsr	r3, r0, r4
	subs	r5, r5, #1
	ands	r5, r5, r3
	ldr	r3, .L2578+4
	uxtb	r5, r5
	ldrb	r2, [r3]	@ zero_extendqisi2
	mov	r10, r3
	cmp	r2, r5
	bhi	.L2549
	movw	r2, #1055
	ldr	r1, .L2578+8
	ldr	r0, .L2578+12
	bl	printf
.L2549:
	ldrb	r3, [r10]	@ zero_extendqisi2
	cmp	r3, r5
	bls	.L2560
	ldr	r3, .L2578+16
	movs	r0, #1
	lsl	r4, r0, r4
	ldrb	r10, [r3, r5]	@ zero_extendqisi2
	subs	r4, r4, #1
	ldr	r3, .L2578+20
	ands	r4, r4, r6
	ubfx	r6, r6, #24, #2
	mov	r0, r10
	ldr	r5, [r3]
	bl	nandc_cs
	cbnz	r6, .L2551
	mov	r0, r4
	bl	slc_phy_page_address_calc
	mov	r4, r0
.L2551:
	ldr	r3, .L2578+24
	uxtb	ip, r4
	lsrs	r0, r4, #8
	lsrs	r1, r4, #16
	ldrb	r3, [r3, #16]	@ zero_extendqisi2
	cmp	r3, #1
	lsl	r3, r10, #8
	bne	.L2552
	adds	r2, r5, r3
	mov	lr, #6
.L2577:
	str	lr, [r2, #2056]
	mov	lr, #0
	str	lr, [r2, #2052]
	str	lr, [r2, #2052]
	str	ip, [r2, #2052]
	str	r0, [r2, #2052]
	str	r1, [r2, #2052]
	ldr	r1, .L2578+28
	ldrb	r1, [r1]	@ zero_extendqisi2
	cbz	r1, .L2556
	lsrs	r1, r4, #24
	str	r1, [r2, #2052]
.L2556:
	add	r3, r3, r5
.L2573:
	movs	r2, #224
	str	r2, [r3, #2056]
	ldr	r3, .L2578+32
	ldr	r3, [r3]
	ldrb	r3, [r3, #12]	@ zero_extendqisi2
	cmp	r3, #3
	bne	.L2558
	cmp	r6, #0
	beq	.L2558
	ldr	r3, .L2578+36
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L2558
	ldr	r3, .L2578+40
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L2558
	add	r4, r4, r4, lsl #1
	subs	r6, r6, #1
	adds	r0, r4, r6
.L2574:
	bl	nandc_set_seed
	ldr	r3, .L2578+44
	movs	r1, #0
	mov	r0, r10
	ldrb	r2, [r3, #9]	@ zero_extendqisi2
	mov	r3, r7
	str	r8, [sp]
	bl	nandc_xfer
	bl	nandc_de_cs.constprop.33
.L2548:
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L2552:
	ldr	r2, .L2578+32
	ldr	r2, [r2]
	ldrb	r2, [r2, #12]	@ zero_extendqisi2
	cmp	r2, #3
	add	r2, r5, r3
	bne	.L2555
	mov	lr, #5
	b	.L2577
.L2555:
	mov	lr, #0
	str	lr, [r2, #2056]
	str	lr, [r2, #2052]
	str	lr, [r2, #2052]
	str	ip, [r2, #2052]
	str	r0, [r2, #2052]
	str	r1, [r2, #2052]
	ldr	r1, .L2578+28
	ldrb	r1, [r1]	@ zero_extendqisi2
	cbz	r1, .L2557
	lsrs	r1, r4, #24
	str	r1, [r2, #2052]
.L2557:
	movs	r1, #5
	add	r3, r3, r5
	str	r1, [r3, #2056]
	movs	r1, #0
	str	r1, [r2, #2052]
	str	r1, [r2, #2052]
	b	.L2573
.L2558:
	mov	r0, r4
	b	.L2574
.L2560:
	mov	r0, #-1
	b	.L2548
.L2579:
	.align	2
.L2578:
	.word	.LANCHOR32
	.word	.LANCHOR18
	.word	.LANCHOR181
	.word	.LC0
	.word	.LANCHOR30
	.word	.LANCHOR13
	.word	.LANCHOR20
	.word	.LANCHOR31
	.word	.LANCHOR16
	.word	.LANCHOR36
	.word	.LANCHOR37
	.word	.LANCHOR33
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
	mov	r10, r0
	ldr	r3, .L2611
	mov	r8, r1
	ubfx	r5, r0, #24, #2
	str	r2, [sp, #8]
	ldrb	r6, [r3]	@ zero_extendqisi2
	movs	r3, #1
	rsb	r2, r6, #24
	lsl	r4, r3, r2
	lsl	r6, r3, r6
	ldr	r3, .L2611+4
	lsr	r2, r0, r2
	subs	r6, r6, #1
	ands	r6, r6, r2
	subs	r4, r4, #1
	ldrb	r3, [r3]	@ zero_extendqisi2
	uxtb	r6, r6
	ands	r4, r4, r0
	cmp	r3, r6
	bhi	.L2581
	movw	r2, #1212
	ldr	r1, .L2611+8
	ldr	r0, .L2611+12
	bl	printf
.L2581:
	ldr	r3, .L2611+16
	ldrb	r7, [r3, r6]	@ zero_extendqisi2
	ldr	r3, .L2611+20
	mov	r0, r7
	ldr	fp, [r3]
	bl	nandc_cs
	cbnz	r5, .L2582
	mov	r0, r4
	bl	slc_phy_page_address_calc
	mov	r4, r0
.L2582:
	lsls	r2, r7, #8
	ldr	r6, .L2611+24
	movs	r1, #5
	add	r3, fp, r2
	str	r1, [r3, #2056]
	movs	r1, #0
	str	r1, [r3, #2052]
	str	r1, [r3, #2052]
	ldrb	r1, [r6, #12]	@ zero_extendqisi2
	cmp	r1, #3
	bne	.L2583
	uxtb	r1, r4
	str	r1, [r3, #2052]
	lsrs	r1, r4, #8
	str	r1, [r3, #2052]
	lsrs	r1, r4, #16
	str	r1, [r3, #2052]
.L2583:
	movs	r3, #224
	add	fp, fp, r2
	str	r3, [fp, #2056]
	ldr	r3, .L2611+28
	ldr	r3, [r3]
	ldrb	r3, [r3, #12]	@ zero_extendqisi2
	cmp	r3, #3
	bne	.L2584
	cmp	r5, #0
	beq	.L2584
	ldr	r3, .L2611+32
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L2584
	ldr	r3, .L2611+36
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L2584
	add	r3, r4, r4, lsl #1
	subs	r0, r5, #1
	add	r0, r0, r3
.L2610:
	bl	nandc_set_seed
	ldr	r3, [sp, #8]
	movs	r1, #0
	ldrb	r2, [r6, #9]	@ zero_extendqisi2
	mov	r0, r7
	str	r3, [sp]
	mov	r3, r8
	bl	nandc_xfer
	adds	r1, r0, #1
	bne	.L2586
	ldr	fp, .L2611+52
	ldrb	r3, [fp]	@ zero_extendqisi2
	str	r3, [sp, #12]
	cmp	r3, #0
	beq	.L2587
	movs	r3, #0
	mov	r2, r8
	strb	r3, [fp]
	orr	r1, r4, r5, lsl #24
	ldrb	r3, [r6, #9]	@ zero_extendqisi2
	mov	r0, r7
	str	r3, [sp]
	ldr	r3, [sp, #8]
	bl	flash_read_page
	ldrb	r3, [sp, #12]	@ zero_extendqisi2
	strb	r3, [fp]
	cbnz	r5, .L2588
.L2593:
	ldr	r3, .L2611+40
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2588
	ldr	r3, .L2611+44
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r0, r3, asr #2
	blt	.L2588
	ldrb	r3, [r6, #19]	@ zero_extendqisi2
	subs	r3, r3, #4
	cmp	r3, #4
	it	ls
	movls	r0, #256
.L2580:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2584:
	mov	r0, r4
	b	.L2610
.L2588:
	adds	r2, r0, #1
	bne	.L2580
.L2594:
	ldr	r3, .L2611+48
	ldr	fp, [r3]
	cmp	fp, #0
	bne	.L2590
.L2592:
	ldr	r3, .L2611+52
	mov	r2, r10
	movs	r1, #0
	ldr	r0, .L2611+56
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp]
	mov	r3, #-1
	bl	printf
	ldr	r3, .L2611+60
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L2591
	mov	r0, #-1
	b	.L2580
.L2590:
	ldrb	r3, [r6, #9]	@ zero_extendqisi2
	mov	r2, r8
	orr	r1, r4, r5, lsl #24
	mov	r0, r7
	str	r3, [sp]
	ldr	r3, [sp, #8]
	blx	fp
	adds	r3, r0, #1
	beq	.L2592
	b	.L2580
.L2591:
	ldrb	r3, [r6, #9]	@ zero_extendqisi2
	mov	r2, r8
	orr	r1, r4, r5, lsl #24
	mov	r0, r7
	str	r3, [sp]
	ldr	r3, [sp, #8]
	bl	flash_ddr_tuning_read
	b	.L2580
.L2587:
	cmp	r5, #0
	beq	.L2593
	b	.L2594
.L2586:
	cmp	r5, #0
	bne	.L2580
	b	.L2593
.L2612:
	.align	2
.L2611:
	.word	.LANCHOR32
	.word	.LANCHOR18
	.word	.LANCHOR182
	.word	.LC0
	.word	.LANCHOR30
	.word	.LANCHOR13
	.word	.LANCHOR33
	.word	.LANCHOR16
	.word	.LANCHOR36
	.word	.LANCHOR37
	.word	.LANCHOR0
	.word	.LANCHOR50
	.word	.LANCHOR174
	.word	.LANCHOR52
	.word	.LC139
	.word	.LANCHOR21
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
	ldr	r3, .L2712
	ldrb	r5, [r3]	@ zero_extendqisi2
	cmp	r5, #255
	bne	.L2614
.L2647:
	movs	r6, #0
	b	.L2613
.L2614:
	ldr	r4, .L2712+4
	movs	r3, #48
	mla	r3, r3, r5, r4
	ldrb	r2, [r3, #42]	@ zero_extendqisi2
	ldr	r6, [r3, #24]
	subs	r3, r2, #1
	cmp	r3, #10
	bhi	.L2647
	tbh	[pc, r3, lsl #1]
.L2617:
	.2byte	(.L2616-.L2617)/2
	.2byte	(.L2618-.L2617)/2
	.2byte	(.L2619-.L2617)/2
	.2byte	(.L2619-.L2617)/2
	.2byte	(.L2619-.L2617)/2
	.2byte	(.L2619-.L2617)/2
	.2byte	(.L2620-.L2617)/2
	.2byte	(.L2621-.L2617)/2
	.2byte	(.L2622-.L2617)/2
	.2byte	(.L2619-.L2617)/2
	.2byte	(.L2622-.L2617)/2
	.p2align 1
.L2616:
	movs	r1, #64
	mov	r0, r6
	bl	flash_wait_device_ready
	lsls	r0, r0, #25
	bpl	.L2647
	movs	r3, #48
	mla	r3, r3, r5, r4
	ldr	r2, [r3, #8]
	ldr	r1, [r3, #4]
	cbz	r2, .L2624
	ldrb	r0, [r3, #40]	@ zero_extendqisi2
	ldr	r3, .L2712+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r0, r3
	it	eq
	moveq	r1, r2
.L2624:
	movs	r3, #48
	mov	r0, r6
	mla	r4, r3, r5, r4
	ldr	r2, [r4, #12]
	bl	flash_complete_page_read
	str	r0, [r4, #36]
.L2711:
	movs	r3, #13
	strb	r3, [r4, #42]
	ldrb	r3, [r4, #2]	@ zero_extendqisi2
	orr	r3, r3, #8
	strb	r3, [r4, #2]
	b	.L2647
.L2618:
	movs	r1, #64
	mov	r0, r6
	bl	flash_wait_device_ready
	lsls	r1, r0, #25
	bpl	.L2647
	movs	r3, #48
	mul	r1, r3, r5
	ldrb	r6, [r4, r1]	@ zero_extendqisi2
	adds	r2, r4, r1
	ldr	fp, [r2, #4]
	mla	r3, r3, r6, r4
	ldr	r10, [r3, #4]
	ldr	r3, [r2, #8]
	cbz	r3, .L2625
	ldrb	r1, [r2, #40]	@ zero_extendqisi2
	ldr	r2, .L2712+8
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r1, r2
	it	eq
	moveq	fp, r3
.L2625:
	movs	r3, #48
	mla	r3, r3, r6, r4
	ldr	r2, [r3, #8]
	cbz	r2, .L2626
	ldrb	r1, [r3, #40]	@ zero_extendqisi2
	ldr	r3, .L2712+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r1, r3
	it	eq
	moveq	r10, r2
.L2626:
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
	beq	.L2627
	ldr	r3, [r7, #20]
	adds	r2, r3, #1
	beq	.L2628
	ldr	r2, [r7, #12]
	ldr	r2, [r2, #4]
	cmp	r3, r2
	beq	.L2628
.L2627:
	movs	r7, #48
	ldr	r3, .L2712+12
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
	ldr	r3, .L2712+8
	bic	r1, r1, ip
	uxtb	r0, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp]
	ldr	r3, [r7, #12]
	bl	flash_read_page_en
	ldr	r2, [r7, #20]
	mov	r8, r0
	adds	r3, r2, #1
	beq	.L2629
	ldr	r3, [r7, #12]
	ldr	r1, [r3, #4]
	cmp	r2, r1
	beq	.L2629
	ldr	r0, .L2712+16
	ldr	r0, [r0]
	lsls	r0, r0, #25
	bpl	.L2629
	str	r1, [sp]
	ldr	r1, [r7, #24]
	ldr	r3, [r3]
	ldr	r0, .L2712+20
	bl	printf
.L2629:
	movs	r3, #48
	mla	r3, r3, r5, r4
	ldr	r2, [r3, #20]
	adds	r0, r2, #1
	beq	.L2628
	ldr	r3, [r3, #12]
	ldr	r3, [r3, #4]
	cmp	r2, r3
	beq	.L2628
	mov	r2, #430
	ldr	r1, .L2712+24
	ldr	r0, .L2712+28
	bl	printf
.L2628:
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
	beq	.L2630
	mla	r3, r3, r6, r4
	ldr	r2, [r3, #20]
	adds	r1, r2, #1
	beq	.L2632
	ldr	r3, [r3, #12]
	ldr	r3, [r3, #4]
	cmp	r2, r3
	beq	.L2632
.L2630:
	ldr	r3, .L2712+12
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
	ldr	r3, .L2712+8
	bic	r1, r1, r7
	uxtb	r0, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp]
	ldr	r3, [r5, #12]
	bl	flash_read_page_en
	ldr	r2, [r5, #20]
	adds	r3, r2, #1
	beq	.L2634
	ldr	r3, [r5, #12]
	ldr	r1, [r3, #4]
	cmp	r2, r1
	beq	.L2634
	ldr	r0, .L2712+16
	ldr	r0, [r0]
	lsls	r7, r0, #25
	bpl	.L2634
	str	r1, [sp]
	ldr	r0, .L2712+20
	ldr	r3, [r3]
	ldr	r1, [r5, #24]
	bl	printf
.L2634:
	movs	r3, #48
	mla	r3, r3, r6, r4
	ldr	r2, [r3, #20]
	adds	r0, r2, #1
	beq	.L2632
	ldr	r3, [r3, #12]
	ldr	r3, [r3, #4]
	cmp	r2, r3
	beq	.L2632
	movw	r2, #449
	ldr	r1, .L2712+24
	ldr	r0, .L2712+28
	bl	printf
.L2632:
	movs	r3, #48
	mla	r4, r3, r6, r4
	str	r8, [r4, #36]
	b	.L2711
.L2619:
	movs	r1, #64
	mov	r0, r6
	bl	flash_wait_device_ready
	lsls	r1, r0, #25
	mov	r6, r0
	bpl	.L2647
	ands	r2, r0, #5
	mov	r3, #48
	beq	.L2635
	mla	r4, r3, r5, r4
	movs	r3, #12
	mov	r2, r0
	ldr	r0, .L2712+32
	strb	r3, [r4, #42]
	ldrb	r1, [r4, #1]	@ zero_extendqisi2
	str	r3, [sp]
	ldr	r3, [r4, #24]
	bl	printf
.L2710:
	mov	r3, #-1
	str	r3, [r4, #36]
	b	.L2613
.L2713:
	.align	2
.L2712:
	.word	.LANCHOR60
	.word	.LANCHOR56
	.word	.LANCHOR131
	.word	.LANCHOR32
	.word	.LANCHOR14
	.word	.LC140
	.word	.LANCHOR183
	.word	.LC0
	.word	.LC141
.L2635:
	mla	r6, r3, r5, r4
	movs	r3, #13
	strb	r3, [r6, #42]
	ldr	r3, .L2714
	str	r2, [r6, #36]
	ldr	r3, [r3]
	ldr	r2, [r3, #156]
	ldr	r3, .L2714+4
	cmp	r2, r3
	bne	.L2647
	ldrh	r3, [r6, #34]
	cmp	r3, #0
	bne	.L2647
	ldr	r3, .L2714+8
	movs	r0, #1
	ldr	r1, [r6, #24]
	ldr	r7, .L2714+12
	ldrb	r2, [r3]	@ zero_extendqisi2
	rsb	r3, r2, #24
	lsls	r0, r0, r2
	ldr	r2, .L2714+16
	subs	r0, r0, #1
	lsl	ip, r0, r3
	lsr	r3, r1, r3
	ands	r0, r0, r3
	ldr	r3, .L2714+20
	bic	r1, r1, ip
	uxtb	r0, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp]
	ldr	r3, [r7]
	ldr	r2, [r2]
	bl	flash_read_page_en
	adds	r2, r0, #1
	mov	r3, r0
	beq	.L2636
	ldr	r1, [r6, #12]
	ldr	r2, [r7]
	ldr	r1, [r1]
	ldr	r2, [r2]
	cmp	r1, r2
	beq	.L2647
.L2636:
	movs	r2, #48
	ldr	r0, .L2714+24
	mla	r4, r2, r5, r4
	ldr	r2, .L2714+28
	ldrb	r2, [r2]	@ zero_extendqisi2
	ldrb	r1, [r4, #1]	@ zero_extendqisi2
	str	r2, [sp]
	ldr	r2, [r4, #24]
	bl	printf
	mov	r3, #-1
	str	r3, [r4, #36]
	b	.L2647
.L2622:
	ldr	r7, .L2714+8
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
.L2638:
	ldrb	r8, [r2]	@ zero_extendqisi2
	cmp	r8, #255
	bne	.L2645
	mov	r6, #-1
	b	.L2613
.L2645:
	mla	lr, r7, r8, r4
	add	r2, r8, r8, lsl #1
	ldrb	fp, [lr, #42]	@ zero_extendqisi2
	add	r2, r4, r2, lsl #4
	cmp	fp, r0
	bne	.L2638
	ldr	lr, [lr, #24]
	lsr	lr, lr, r1
	and	lr, lr, r3
	cmp	ip, lr
	bne	.L2638
	mov	r0, r6
	movs	r1, #64
	bl	flash_wait_device_ready
	mov	r6, r0
	lsls	r0, r6, #25
	bmi	.L2640
.L2709:
	movs	r6, #0
	b	.L2641
.L2640:
	ands	r3, r6, #15
	mul	r7, r7, r5
	beq	.L2642
	add	r7, r7, r4
	mov	r10, #12
	ldrb	r1, [r7, #1]	@ zero_extendqisi2
	mov	r2, r6
	str	r10, [sp]
	ldr	r3, [r7, #24]
	ldr	r0, .L2714+32
	bl	printf
	mov	r3, #-1
	strb	r10, [r7, #42]
	str	r3, [r7, #36]
.L2641:
	movs	r3, #48
	mla	r5, r3, r5, r4
	mla	r8, r3, r8, r4
	ldrb	r2, [r5, #42]	@ zero_extendqisi2
	ldr	r3, [r5, #36]
	strb	r2, [r8, #42]
	str	r3, [r8, #36]
.L2613:
	mov	r0, r6
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2642:
	adds	r6, r4, r7
	movs	r2, #13
	str	r3, [r6, #36]
	ldr	r3, .L2714
	strb	r2, [r6, #42]
	ldr	r3, [r3]
	ldr	r2, [r3, #156]
	ldr	r3, .L2714+4
	cmp	r2, r3
	bne	.L2709
	ldrh	r3, [r6, #34]
	cmp	r3, #0
	bne	.L2709
	ldrb	r2, [r10]	@ zero_extendqisi2
	movs	r0, #1
	ldr	r1, [r6, #24]
	ldr	r7, .L2714+12
	rsb	r3, r2, #24
	lsls	r0, r0, r2
	ldr	r2, .L2714+16
	subs	r0, r0, #1
	lsl	ip, r0, r3
	lsr	r3, r1, r3
	ands	r0, r0, r3
	ldr	r3, .L2714+20
	bic	r1, r1, ip
	uxtb	r0, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp]
	ldr	r3, [r7]
	ldr	r2, [r2]
	bl	flash_read_page_en
	adds	r1, r0, #1
	mov	r3, r0
	beq	.L2644
	ldr	r1, [r6, #12]
	ldr	r2, [r7]
	ldr	r1, [r1]
	ldr	r2, [r2]
	cmp	r1, r2
	beq	.L2709
.L2644:
	ldr	r2, .L2714+28
	movs	r6, #48
	mla	r6, r6, r5, r4
	ldr	r0, .L2714+36
	ldrb	r2, [r2]	@ zero_extendqisi2
	ldrb	r1, [r6, #1]	@ zero_extendqisi2
	str	r2, [sp]
	ldr	r2, [r6, #24]
	bl	printf
	mov	r3, #-1
	str	r3, [r6, #36]
	b	.L2709
.L2620:
	mov	r0, r6
	movs	r1, #32
	bl	flash_wait_device_ready
	lsls	r2, r0, #26
	mov	r6, r0
	bpl	.L2647
	ands	r2, r0, #15
	mov	r3, #48
	mla	r4, r3, r5, r4
	beq	.L2646
	movs	r3, #12
	strb	r3, [r4, #42]
	b	.L2710
.L2646:
	movs	r3, #13
	str	r2, [r4, #36]
	strb	r3, [r4, #42]
	b	.L2647
.L2621:
	movs	r1, #64
	mov	r0, r6
	bl	flash_wait_device_ready
	lsls	r3, r0, #25
	bpl	.L2647
	movs	r3, #48
	mla	r4, r3, r5, r4
	movs	r3, #7
	str	r0, [r4, #36]
	strb	r3, [r4, #42]
	b	.L2647
.L2715:
	.align	2
.L2714:
	.word	.LANCHOR110
	.word	1145785929
	.word	.LANCHOR32
	.word	.LANCHOR175
	.word	.LANCHOR176
	.word	.LANCHOR131
	.word	.LC142
	.word	.LANCHOR52
	.word	.LC143
	.word	.LC144
	.size	queue_wait_first_req_completed, .-queue_wait_first_req_completed
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
	cbz	r3, .L2717
	ldr	r3, .L2746
	ldr	r3, [r3]
	lsls	r3, r3, #23
	bpl	.L2717
	mov	r2, r1
	ldr	r1, [r0, #24]
	ldr	r0, .L2746+4
	bl	printf
.L2717:
	ldr	fp, .L2746+40
	movs	r7, #0
.L2718:
	cbnz	r5, .L2729
.L2745:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2729:
	ldrb	r8, [r4]	@ zero_extendqisi2
	ldr	r6, [r4, #24]
.L2719:
	movs	r1, #1
	mov	r0, r6
	bl	queue_lun_state
	cbnz	r0, .L2720
	cmp	r5, #1
	beq	.L2721
	ldr	r3, .L2746+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2721
	ldr	r3, .L2746+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2722
.L2721:
	mov	r0, r4
	bl	queue_prog_cmd
.L2723:
	subs	r5, r5, #1
	beq	.L2745
	ldr	r4, .L2746+16
	add	r8, r8, r8, lsl #1
	add	r4, r4, r8, lsl #4
	b	.L2718
.L2720:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2719
.L2722:
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
	bne	.L2724
	mov	r2, #696
	ldr	r1, .L2746+20
	ldr	r0, .L2746+24
	bl	printf
.L2724:
	ldr	r2, .L2746+16
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
	bne	.L2725
	ldr	r3, .L2746+28
	ldrh	r0, [r3]
	ldr	r3, .L2746+32
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
	beq	.L2725
	cmp	lr, r2
	bne	.L2725
	cmp	r7, ip
	beq	.L2725
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
	ldr	r0, .L2746+36
	bl	buf_add_tail
	b	.L2723
.L2725:
	mov	r0, r4
	movs	r7, #0
	bl	queue_prog_cmd
	b	.L2723
.L2747:
	.align	2
.L2746:
	.word	.LANCHOR14
	.word	.LC145
	.word	.LANCHOR45
	.word	.LANCHOR37
	.word	.LANCHOR56
	.word	.LANCHOR184
	.word	.LC0
	.word	.LANCHOR75
	.word	.LANCHOR76
	.word	.LANCHOR60
	.word	.LANCHOR32
	.size	sblk_prog_page, .-sblk_prog_page
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
	ldr	r4, .L2751
.L2749:
	ldrb	r3, [r4]	@ zero_extendqisi2
	cmp	r3, #255
	bne	.L2750
	pop	{r4, pc}
.L2750:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2749
.L2752:
	.align	2
.L2751:
	.word	.LANCHOR60
	.size	sblk_wait_write_queue_completed, .-sblk_wait_write_queue_completed
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
	ldr	r4, .L2758
	ldr	r5, .L2758+4
	ldrb	r1, [r4]	@ zero_extendqisi2
	cbz	r1, .L2754
	ldrb	r0, [r5]	@ zero_extendqisi2
	ldr	r3, .L2758+8
	add	r0, r0, r0, lsl #1
	add	r0, r3, r0, lsl #4
	bl	sblk_prog_page
.L2754:
	movs	r3, #255
	strb	r3, [r5]
	movs	r3, #0
	strb	r3, [r4]
	bl	sblk_wait_write_queue_completed
	bl	ftl_write_completed
	movw	r0, #65535
	pop	{r3, r4, r5, lr}
	b	ftl_vpn_decrement
.L2759:
	.align	2
.L2758:
	.word	.LANCHOR129
	.word	.LANCHOR185
	.word	.LANCHOR56
	.size	ftl_flush, .-ftl_flush
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
	ldr	r3, .L2762
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
.L2763:
	.align	2
.L2762:
	.word	.LANCHOR32
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
.L2765:
	cbnz	r5, .L2775
.L2788:
	ldr	r4, .L2789
.L2776:
	cmp	r6, #0
	bne	.L2778
	mov	r0, r6
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2775:
	ldr	fp, [r4, #24]
	ldrb	r3, [r4]	@ zero_extendqisi2
	str	r3, [sp, #8]
.L2766:
	movs	r1, #0
	mov	r0, fp
	bl	queue_lun_state
	cbnz	r0, .L2767
	cmp	r5, #1
	beq	.L2772
	ldr	r3, .L2789+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L2769
.L2772:
	mov	r0, r4
	bl	queue_read_cmd
	b	.L2770
.L2767:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2766
.L2769:
	ldr	r3, .L2789+8
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
	bne	.L2771
	movw	r2, #781
	ldr	r1, .L2789+12
	ldr	r0, .L2789+16
	str	r3, [sp, #4]
	bl	printf
	ldr	r3, [sp, #4]
.L2771:
	ldrb	r2, [r4]	@ zero_extendqisi2
	movs	r0, #1
	ldr	r8, .L2789
	str	r2, [sp, #12]
	movs	r2, #48
	ldr	r1, [sp, #12]
	muls	r2, r1, r2
	add	r10, r8, r2
	str	r2, [sp, #4]
	ldr	r2, .L2789+8
	ldr	r1, [r10, #24]
	ldrb	ip, [r2]	@ zero_extendqisi2
	rsb	r2, ip, #24
	lsl	r0, r0, ip
	lsr	r2, r1, r2
	subs	r0, r0, #1
	ands	r2, r2, r0
	uxth	r2, r2
	cmp	r3, r2
	bne	.L2772
	ldr	r3, .L2789+20
	ldrh	r3, [r3]
	add	fp, fp, r3
	cmp	r1, fp
	bne	.L2772
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
	ldr	r0, .L2789+24
	strb	fp, [r4]
	str	r2, [sp, #20]
	str	r3, [sp, #16]
	bl	buf_add_tail
	ldr	r3, [sp, #16]
	ldr	r2, [sp, #20]
	ldr	r0, .L2789+24
	strb	r3, [r10, #43]
	ldr	r3, [sp, #4]
	strb	r2, [r10, #42]
	strb	fp, [r8, r3]
	ldr	r3, [sp, #12]
	add	r1, r3, r3, lsl #1
	add	r1, r8, r1, lsl #4
	bl	buf_add_tail
.L2770:
	subs	r5, r5, #1
	beq	.L2788
	ldr	r3, [sp, #8]
	add	r4, r3, r3, lsl #1
	ldr	r3, .L2789
	add	r4, r3, r4, lsl #4
	b	.L2765
.L2778:
	ldrb	r3, [r7, #42]	@ zero_extendqisi2
	cmp	r3, #13
	bne	.L2777
	ldrb	r3, [r7]	@ zero_extendqisi2
	subs	r6, r6, #1
	cmp	r3, #255
	itt	ne
	addne	r3, r3, r3, lsl #1
	addne	r7, r4, r3, lsl #4
.L2777:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2776
.L2790:
	.align	2
.L2789:
	.word	.LANCHOR56
	.word	.LANCHOR186
	.word	.LANCHOR32
	.word	.LANCHOR187
	.word	.LC0
	.word	.LANCHOR111
	.word	.LANCHOR60
	.size	sblk_read_page, .-sblk_read_page
	.section	.text.gc_check_data_one_wl,"ax",%progbits
	.align	1
	.global	gc_check_data_one_wl
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	gc_check_data_one_wl, %function
gc_check_data_one_wl:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #24
	ldr	r4, .L2824
	ldr	r3, .L2824+4
	ldr	r2, [r4, #8]
	ldr	r8, [r3]
	mov	fp, r3
	cbnz	r2, .L2792
	movs	r0, #1
	bl	buf_alloc
	str	r0, [r4, #8]
.L2792:
	ldr	r5, [r4, #8]
	cbnz	r5, .L2793
	movw	r2, #729
	ldr	r1, .L2824+8
	ldr	r0, .L2824+12
	bl	printf
.L2793:
	add	r10, r8, #96
	movs	r7, #0
.L2794:
	ldrb	r3, [r8, #89]	@ zero_extendqisi2
	cmp	r7, r3
	bge	.L2805
	movs	r6, #1
	b	.L2806
.L2804:
	ldr	r2, .L2824+16
	ldrh	r3, [r10]
	ldrh	r2, [r2]
	muls	r2, r3, r2
	ldr	r3, .L2824+20
	ldrb	r1, [r3]	@ zero_extendqisi2
	cmp	r1, #2
	beq	.L2795
	ldr	r3, .L2824+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L2796
.L2795:
	ldrh	r3, [r4, #12]
	subs	r3, r3, #1
	add	r3, r3, r2
	add	r3, r3, r6
	orr	r3, r3, r1, lsl #24
.L2823:
	movs	r1, #1
	str	r3, [r5, #24]
	mov	r0, r5
	bl	sblk_read_page
	ldr	r2, [r5, #36]
	ldr	r1, .L2824+28
	adds	r0, r2, #1
	beq	.L2800
	ldr	r3, [r1]
	ldrh	ip, [r4, #18]
	ldr	r0, [r5, #12]
	ldr	lr, [r3, ip, lsl #2]
	ldr	r3, [r0, #4]
	cmp	lr, r3
	bne	.L2800
	ldr	r3, .L2824+32
	ldr	r0, [r0, #8]
	ldr	r3, [r3]
	ldr	r3, [r3, ip, lsl #2]
	cmp	r3, r0
	beq	.L2801
.L2800:
	ldrh	r3, [r4, #18]
	ldr	r1, [r1]
	lsls	r0, r3, #2
	ldr	r3, [r1, r3, lsl #2]
	adds	r1, r3, #1
	beq	.L2801
	ldr	r1, .L2824+36
	ldr	r1, [r1]
	lsls	r1, r1, #21
	bpl	.L2802
	ldr	r1, [r5, #12]
	ldr	r4, [r1, #12]
	str	r4, [sp, #16]
	ldr	r4, [r1, #8]
	str	r4, [sp, #12]
	ldr	r4, [r1, #4]
	str	r4, [sp, #8]
	ldr	r1, [r1]
	str	r1, [sp, #4]
	ldr	r1, .L2824+32
	ldr	r1, [r1]
	ldr	r1, [r1, r0]
	ldr	r0, .L2824+40
	str	r1, [sp]
	ldr	r1, [r5, #24]
	bl	printf
.L2802:
	ldr	r3, .L2824+44
	movs	r0, #0
	ldrh	r2, [r8, #80]
	ldrb	r1, [r3]	@ zero_extendqisi2
	ldr	r3, .L2824+48
	ldr	r3, [r3]
	strh	r0, [r3, r2, lsl #1]	@ movhi
	ldr	r2, [fp]
	ldr	r3, [r2, #556]
	adds	r3, r3, #1
	str	r3, [r2, #556]
	ldr	r3, .L2824+52
	ldr	r3, [r3]
	ldr	r2, [r3, #156]
	ldr	r3, .L2824+56
	cmp	r2, r3
	bne	.L2809
	cbnz	r1, .L2809
	ldr	r3, .L2824+60
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L2809
	ldr	r0, [r5, #24]
	bl	ftl_mask_bad_block
.L2809:
	mov	r0, #-1
	b	.L2791
.L2796:
	cmp	r1, #3
	ldrh	r3, [r4, #12]
	bne	.L2798
	ldr	r1, .L2824+64
	ldrb	r1, [r1]	@ zero_extendqisi2
	cbz	r1, .L2799
	add	r3, r3, r3, lsl #1
	subs	r3, r3, #1
	add	r3, r3, r2
	add	r3, r3, r6
	orr	r3, r3, #50331648
	b	.L2823
.L2799:
	add	r3, r3, r2
	orr	r3, r3, r6, lsl #24
	b	.L2823
.L2798:
	add	r3, r3, r2
	b	.L2823
.L2801:
	ldrh	r3, [r4, #18]
	adds	r6, r6, #1
	adds	r3, r3, #1
	strh	r3, [r4, #18]	@ movhi
.L2806:
	ldrh	r3, [r4, #16]
	cmp	r6, r3
	ble	.L2804
	adds	r7, r7, #1
	add	r10, r10, #2
	b	.L2794
.L2805:
	ldrh	r3, [r4, #12]
	adds	r2, r3, #1
	strh	r2, [r4, #12]	@ movhi
	ldr	r2, .L2824+60
	ldrb	r0, [r2]	@ zero_extendqisi2
	cbz	r0, .L2791
	movs	r0, #0
	adds	r3, r3, #2
	strh	r3, [r4, #12]	@ movhi
.L2803:
.L2791:
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2825:
	.align	2
.L2824:
	.word	.LANCHOR71
	.word	.LANCHOR10
	.word	.LANCHOR188
	.word	.LC0
	.word	.LANCHOR111
	.word	.LANCHOR79
	.word	.LANCHOR36
	.word	.LANCHOR162
	.word	.LANCHOR163
	.word	.LANCHOR14
	.word	.LC146
	.word	.LANCHOR124
	.word	.LANCHOR9
	.word	.LANCHOR110
	.word	1145785929
	.word	.LANCHOR81
	.word	.LANCHOR37
	.size	gc_check_data_one_wl, .-gc_check_data_one_wl
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
.L2827:
	movs	r1, #1
	mov	r0, r6
	bl	queue_lun_state
	mov	r4, r0
	cbnz	r0, .L2828
	mov	r0, r5
	movs	r1, #1
	bl	queue_tlc_prog_cmd
	mov	r0, r4
	pop	{r4, r5, r6, pc}
.L2828:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2827
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
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, [r0]
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r5, r0
	mov	r6, r1
	sub	sp, sp, #24
	ldr	r4, [r3, #24]
	str	r2, [sp, #20]
.L2830:
	movs	r1, #1
	mov	r0, r4
	bl	queue_lun_state
	mov	r8, r0
	cmp	r0, #0
	bne	.L2831
	ldr	r3, [sp, #20]
	cmp	r3, #2
	bne	.L2832
	ldr	r3, .L2841
	ldr	ip, [r6]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L2833
	ldr	r3, .L2841+4
	mov	r10, #1
	ldr	r2, [r5]
	ldr	fp, [ip, #24]
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldr	r1, [r2, #24]
	rsb	r0, r3, #24
	lsl	r4, r10, r0
	subs	r4, r4, #1
	and	r7, r1, r4
	and	fp, r4, fp
	lsl	r4, r10, r3
	ldr	r3, .L2841+8
	lsrs	r1, r1, r0
	subs	r4, r4, #1
	ldrb	r3, [r3]	@ zero_extendqisi2
	ands	r4, r4, r1
	uxtb	r4, r4
	cmp	r3, #0
	beq	.L2834
	mov	r0, r4
	bl	zftl_flash_exit_slc_mode
	ldr	r3, [r5]
	mov	r1, r10
	mov	r0, r8
	ldr	r2, [r3, #12]
	str	r2, [sp, #8]
	movs	r2, #17
	ldr	r3, [r3, #4]
	str	r7, [sp]
	str	r3, [sp, #4]
	mov	r3, r4
	bl	flash_start_one_pass_page_prog
	bl	nandc_wait_flash_ready
	ldr	r3, [r6]
	mov	r1, r10
	mov	r0, r8
	ldr	r2, [r3, #12]
	str	r2, [sp, #8]
	movs	r2, #26
	ldr	r3, [r3, #4]
	str	fp, [sp]
	str	r3, [sp, #4]
	mov	r3, r4
	bl	flash_start_one_pass_page_prog
	bl	nandc_wait_flash_ready
	ldr	r3, [r5, #4]
	mov	r0, r8
	ldr	r1, [sp, #20]
	ldr	r2, [r3, #12]
	str	r2, [sp, #8]
	movs	r2, #17
	ldr	r3, [r3, #4]
	str	r3, [sp, #4]
	add	r3, r7, r10
	str	r3, [sp]
	mov	r3, r4
	bl	flash_start_one_pass_page_prog
	bl	nandc_wait_flash_ready
	ldr	r3, [r6, #4]
	mov	r0, r8
	ldr	r1, [sp, #20]
	adds	r7, r7, #2
	ldr	r2, [r3, #12]
	str	r2, [sp, #8]
	movs	r2, #26
	ldr	r3, [r3, #4]
	str	r3, [sp, #4]
	add	r3, fp, r10
	str	r3, [sp]
	mov	r3, r4
	bl	flash_start_one_pass_page_prog
	bl	nandc_wait_flash_ready
	ldr	r3, [r5, #8]
	movs	r1, #3
	mov	r0, r8
	ldr	r2, [r3, #12]
	str	r2, [sp, #8]
	movs	r2, #17
	ldr	r3, [r3, #4]
	str	r7, [sp]
	str	r3, [sp, #4]
	mov	r3, r4
	bl	flash_start_one_pass_page_prog
	bl	nandc_wait_flash_ready
	ldr	r3, [r6, #8]
	movs	r1, #3
	mov	r0, r8
	ldr	r2, [r3, #12]
	str	r2, [sp, #8]
	movs	r2, #16
	ldr	r3, [r3, #4]
	str	r3, [sp, #4]
	add	r3, fp, #2
	str	r3, [sp]
	mov	r3, r4
	bl	flash_start_one_pass_page_prog
.L2835:
	ldr	r1, [r5]
	movs	r3, #5
	ldr	r0, .L2841+12
	strb	r3, [r1, #42]
	movs	r3, #1
	strb	r3, [r1, #43]
	movs	r3, #255
	strb	r3, [r1]
	bl	buf_add_tail
.L2836:
	movs	r0, #0
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2831:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2830
.L2834:
	ldr	r3, [r2, #12]
	mov	r1, r10
	ldrb	r0, [r2, #44]	@ zero_extendqisi2
	str	r3, [sp, #8]
	ldr	r3, [r2, #4]
	movs	r2, #17
	str	r7, [sp]
	str	r3, [sp, #4]
	mov	r3, r4
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	r3, [r6]
	mov	r1, r10
	ldr	r2, [r5]
	ldrb	r0, [r2, #44]	@ zero_extendqisi2
	ldr	r2, [r3, #12]
	str	r2, [sp, #8]
	movs	r2, #26
	ldr	r3, [r3, #4]
	str	fp, [sp]
	str	r3, [sp, #4]
	mov	r3, r4
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldm	r5, {r2, r3}
	ldr	r1, [sp, #20]
	ldrb	r0, [r2, #44]	@ zero_extendqisi2
	ldr	r2, [r3, #12]
	str	r2, [sp, #8]
	movs	r2, #17
	ldr	r3, [r3, #4]
	str	r7, [sp]
	str	r3, [sp, #4]
	mov	r3, r4
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	r3, [r6, #4]
	ldr	r2, [r5]
	ldr	r1, [sp, #20]
	ldrb	r0, [r2, #44]	@ zero_extendqisi2
	ldr	r2, [r3, #12]
	str	r2, [sp, #8]
	movs	r2, #26
	ldr	r3, [r3, #4]
	str	fp, [sp]
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
	str	r7, [sp]
	str	r3, [sp, #4]
	mov	r3, r4
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	r3, [r6, #8]
	movs	r1, #3
	ldr	r2, [r5]
	ldrb	r0, [r2, #44]	@ zero_extendqisi2
	ldr	r2, [r3, #12]
	str	r2, [sp, #8]
	movs	r2, #16
	ldr	r3, [r3, #4]
	str	fp, [sp]
	str	r3, [sp, #4]
	mov	r3, r4
	bl	flash_start_tlc_page_prog
	b	.L2835
.L2833:
	ldr	r4, [ip, #24]
.L2837:
	movs	r1, #1
	mov	r0, r4
	bl	queue_lun_state
	mov	r7, r0
	cbnz	r0, .L2838
	movs	r1, #1
	mov	r0, r5
	bl	queue_tlc_prog_cmd
	mov	r1, r7
	mov	r0, r6
	bl	queue_tlc_prog_cmd
.L2839:
	movs	r1, #1
	mov	r0, r4
	bl	queue_lun_state
	cmp	r0, #0
	beq	.L2836
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2839
.L2838:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2837
.L2832:
	movs	r1, #1
	mov	r0, r5
	bl	queue_tlc_prog_cmd
	b	.L2836
.L2842:
	.align	2
.L2841:
	.word	.LANCHOR45
	.word	.LANCHOR32
	.word	.LANCHOR37
	.word	.LANCHOR60
	.size	sblk_xlc_prog_pages, .-sblk_xlc_prog_pages
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
	ldr	r10, .L2848
	add	r5, r0, #8
	ldr	fp, .L2848+4
.L2844:
	cbnz	r7, .L2847
	mov	r0, r7
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2847:
	ldr	r3, [r5, #-8]
	ldr	r4, [r3, #24]
.L2845:
	movs	r1, #1
	mov	r0, r4
	bl	queue_lun_state
	cmp	r0, #0
	bne	.L2846
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
	bl	nandc_de_cs.constprop.33
	ldr	r1, [r5, #-16]
	movs	r3, #4
	mov	r0, fp
	strb	r3, [r1, #42]
	movs	r3, #255
	strb	r8, [r1, #43]
	strb	r3, [r1]
	bl	buf_add_tail
	b	.L2844
.L2846:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2845
.L2849:
	.align	2
.L2848:
	.word	.LANCHOR32
	.word	.LANCHOR60
	.size	sblk_3d_mlc_prog_pages, .-sblk_3d_mlc_prog_pages
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
	ldr	r7, .L2885
	sub	sp, sp, #24
	mov	fp, r3
	mov	r6, r0
	ldrb	r3, [sp, #60]	@ zero_extendqisi2
	mov	r4, r1
	ldrb	r2, [r7]	@ zero_extendqisi2
	ubfx	r5, r1, #24, #2
	str	r3, [sp, #20]
	cmp	r2, r0
	bhi	.L2851
	movw	r2, #635
	ldr	r1, .L2885+4
	ldr	r0, .L2885+8
	bl	printf
.L2851:
	ldrb	r3, [r7]	@ zero_extendqisi2
	cmp	r3, r6
	bls	.L2862
	ldr	r3, .L2885+12
	ldrb	r3, [r3, r6]	@ zero_extendqisi2
	str	r3, [sp, #12]
	cmp	r5, #0
	bne	.L2864
	ldr	r3, .L2885+16
	ldr	r10, .L2885+64
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2854
	ldrb	r3, [r10]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L2864
.L2854:
	ldr	r3, .L2885+20
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
	beq	.L2855
	add	r5, r5, r1, lsl #1
.L2859:
	ldr	r3, .L2885+24
	ldr	r3, [r3]
	lsls	r1, r3, #27
	bpl	.L2856
	mov	r3, r5
	mov	r2, r4
	ldr	r1, [sp, #12]
	ldr	r0, .L2885+28
	bl	printf
.L2856:
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
	beq	.L2857
	ldr	r3, [sp, #56]
	mov	r1, r4
	ldr	r10, .L2885+44
	mov	r0, r6
	ldr	r2, .L2885+32
	str	r3, [sp]
	ldr	r3, [r10]
	ldr	r2, [r2]
	bl	flash_read_page_en
	adds	r2, r0, #1
	mov	r7, r0
	beq	.L2858
	cmp	r0, #512
	beq	.L2858
	ldr	r3, .L2885+32
	ldr	r2, [r8]
	ldr	r3, [r3]
	ldr	r3, [r3]
	cmp	r2, r3
	bne	.L2858
	ldr	r3, [r10]
	ldr	r2, [fp]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L2857
.L2858:
	movs	r3, #4
	mov	r1, r8
	mov	r2, r3
	ldr	r0, .L2885+36
	bl	rknand_print_hex
	movs	r3, #4
	mov	r1, fp
	mov	r2, r3
	ldr	r0, .L2885+40
	bl	rknand_print_hex
	ldr	r1, .L2885+44
	movs	r3, #4
	mov	r2, r3
	ldr	r0, .L2885+48
	ldr	r1, [r1]
	bl	rknand_print_hex
	ldr	r1, .L2885+32
	movs	r3, #4
	mov	r2, r3
	ldr	r0, .L2885+52
	ldr	r1, [r1]
	bl	rknand_print_hex
	cmp	r7, #512
	beq	.L2859
.L2861:
	mov	r1, r4
	ldr	r0, .L2885+56
	bl	printf
	movw	r2, #678
	ldr	r1, .L2885+4
	ldr	r0, .L2885+8
	bl	printf
.L2862:
	mov	r0, #-1
	b	.L2850
.L2855:
	ldr	r3, .L2885+60
	ldrh	r1, [r3, r1, lsl #1]
	add	r5, r5, r1
	b	.L2859
.L2864:
.L2853:
	mov	r5, r4
	b	.L2859
.L2857:
	ldr	r0, [sp, #16]
	adds	r3, r0, #1
	beq	.L2861
.L2850:
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2886:
	.align	2
.L2885:
	.word	.LANCHOR18
	.word	.LANCHOR189
	.word	.LC0
	.word	.LANCHOR30
	.word	.LANCHOR0
	.word	.LANCHOR2
	.word	.LANCHOR14
	.word	.LC147
	.word	.LANCHOR176
	.word	.LC148
	.word	.LC149
	.word	.LANCHOR175
	.word	.LC150
	.word	.LC151
	.word	.LC152
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
	ldr	r3, .L2914
	mov	r10, r0
	mov	r8, r5
	ldr	r2, [r3]
	str	r3, [sp, #12]
	str	r5, [r2]
	ldr	r2, .L2914+4
	str	r5, [r2]
.L2888:
	uxth	r3, r5
	str	r3, [sp, #8]
	ldr	r3, .L2914+8
	ldr	r2, [sp, #8]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r2
	bls	.L2898
	mov	fp, #0
	b	.L2899
.L2897:
	ldr	r3, .L2914+12
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L2889
	mov	r1, r10
	ldr	r0, .L2914+16
	bl	printf
.L2889:
	ldr	r3, .L2914+20
	ldrb	r4, [r3]	@ zero_extendqisi2
	ldr	r3, [sp, #8]
	smulbb	r4, r4, r10
	add	r4, r4, r6
	uxth	r4, r4
	cbnz	r3, .L2890
	ldr	r3, .L2914+24
	ldr	r3, [r3]
	ldrb	r3, [r3, #47]	@ zero_extendqisi2
	cmp	r3, r4
	bcs	.L2891
.L2890:
	uxtb	r6, r5
	mov	r1, r4
	mov	r0, r6
	bl	flash_check_bad_block
	cbnz	r0, .L2891
	ldr	r3, .L2914+28
	mov	r1, r8
	mov	r0, r6
	ldrh	r7, [r3]
	muls	r7, r4, r7
	mov	r2, r7
	bl	flash_erase_block_en
	cbz	r0, .L2892
	ldr	r3, .L2914+32
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #2
	bne	.L2913
	ldr	r3, .L2914+36
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2913
	mov	r2, r7
	movs	r1, #1
	mov	r0, r6
	bl	flash_erase_block_en
	cbnz	r0, .L2913
.L2896:
	ldr	r3, .L2914+32
	mov	r8, #1
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r7, r7, r3, lsl #24
.L2895:
	movs	r3, #1
	ldr	r2, [sp, #12]
	str	r3, [sp, #4]
	mov	r1, r7
	ldr	r3, .L2914+40
	mov	r0, r6
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp]
	ldr	r3, .L2914+4
	ldr	r2, [r2]
	bl	flash_prog_page_en
	cbz	r0, .L2891
.L2913:
	mov	r1, r4
	mov	r0, r6
	bl	flash_mask_bad_block
.L2891:
	add	fp, fp, #1
.L2899:
	ldr	r3, .L2914+20
	uxth	r6, fp
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r6
	bhi	.L2897
	adds	r5, r5, #1
	b	.L2888
.L2892:
	cmp	r8, #0
	beq	.L2895
	b	.L2896
.L2898:
	cmp	r8, #0
	beq	.L2900
	ldr	r3, .L2914+44
	movs	r2, #2
	ldr	r3, [r3]
	add	r10, r3, r10, lsl #2
	ldrb	r3, [r10, #2]	@ zero_extendqisi2
	bfi	r3, r2, #3, #2
	strb	r3, [r10, #2]
.L2900:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2915:
	.align	2
.L2914:
	.word	.LANCHOR190
	.word	.LANCHOR191
	.word	.LANCHOR112
	.word	.LANCHOR14
	.word	.LC153
	.word	.LANCHOR76
	.word	.LANCHOR27
	.word	.LANCHOR111
	.word	.LANCHOR79
	.word	.LANCHOR0
	.word	.LANCHOR131
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
	bne	.L2916
	ldr	r1, .L2918
	movw	r2, #2670
	ldr	r0, .L2918+4
	bl	printf
	mov	r1, r5
	ldr	r0, .L2918+8
	bl	printf
.L2916:
	mov	r0, r4
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, pc}
.L2919:
	.align	2
.L2918:
	.word	.LANCHOR192
	.word	.LC0
	.word	.LC152
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
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #32
	ldr	r5, .L2957
	movs	r1, #0
	str	r0, [sp, #16]
	ldrb	r2, [r5]	@ zero_extendqisi2
	ldr	r0, .L2957+4
	lsls	r2, r2, #1
	bl	ftl_memset
	ldr	r2, .L2957+8
	ldr	r3, [r2]
	str	r2, [sp, #20]
	ldrh	r1, [r3, #74]
	cbz	r1, .L2921
	movs	r2, #0
	strh	r2, [r3, #150]	@ movhi
.L2921:
	ldr	r4, .L2957+12
	mov	r8, #0
.L2931:
	ldr	r3, .L2957+12
	ldr	r6, .L2957+16
	ldr	r1, [sp, #16]
	ldrb	fp, [r3]	@ zero_extendqisi2
	ldrh	r3, [r6]
	ldr	r7, .L2957+20
	str	r3, [sp, #12]
	ldr	r3, .L2957+12
	ldr	r0, [r7]
	ldrh	r10, [r3, #2]
	ldr	r3, [sp, #20]
	ldr	r2, [r3]
	ldr	r3, [r2, #4]
	adds	r3, r3, #1
	str	r3, [r2, #4]
	ldr	r2, .L2957+4
	str	r3, [sp, #28]
	stm	r2, {r1, r3}
	ldrb	r1, [r5]	@ zero_extendqisi2
	str	r2, [sp, #24]
	lsls	r1, r1, #9
	bl	js_hash
	ldr	r2, [sp, #24]
	ldr	r3, [sp, #28]
	str	r0, [r2, #8]
	ldr	r2, .L2957+24
	ldr	r2, [r2]
	tst	r2, #4096
	beq	.L2922
	mov	r2, r10
	mov	r1, fp
	ldr	r0, .L2957+28
	bl	printf
.L2922:
	ldr	r3, .L2957+32
	ldrh	r0, [r4, #2]
	ldrh	r3, [r3]
	cmp	r3, r0
	bhi	.L2923
	ldr	r10, .L2957+48
	ldr	fp, .L2957+44
.L2927:
	ldrb	r3, [r4, #1]	@ zero_extendqisi2
	adds	r3, r3, #1
	uxtb	r3, r3
	cmp	r3, #7
	strb	r3, [r4, #1]
	bls	.L2924
	ldr	r2, [r10]
	movs	r3, #0
	adds	r2, r2, #40
.L2940:
	ldrb	r1, [r2], #1	@ zero_extendqisi2
	uxth	r8, r3
	cmp	r1, #128
	bls	.L2925
	cmp	r1, #255
	beq	.L2926
	movw	r2, #841
	mov	r1, fp
	ldr	r0, .L2957+36
	bl	printf
.L2925:
	strb	r8, [r4, #1]
	mov	r8, #1
.L2924:
	ldr	r3, [r10]
	ldrb	r2, [r4, #1]	@ zero_extendqisi2
	add	r3, r3, r2
	ldrb	r3, [r3, #40]	@ zero_extendqisi2
	cmp	r3, #255
	strb	r3, [r4]
	beq	.L2927
	ldrh	r10, [r6]
	movs	r0, #0
	mul	r10, r3, r10
	mov	r1, r10
	bl	flash_erase_block
	ldrb	r3, [r5]	@ zero_extendqisi2
	mov	r1, r10
	movs	r0, #0
	str	r3, [sp]
	ldr	r2, [r7]
	ldr	r3, .L2957+4
	bl	ftl_prog_page
	movs	r3, #1
	add	r10, r10, r3
	strh	r3, [r4, #2]	@ movhi
.L2928:
	ldrb	r3, [r5]	@ zero_extendqisi2
	mov	r1, r10
	movs	r0, #0
	str	r3, [sp]
	ldr	r2, [r7]
	ldr	r3, .L2957+4
	bl	ftl_prog_page
	ldrh	r3, [r4, #2]
	adds	r0, r0, #1
	add	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
	ldr	r3, .L2957+40
	beq	.L2929
	ldrb	r2, [r3]	@ zero_extendqisi2
	cbz	r2, .L2930
.L2929:
	movs	r2, #0
	strb	r2, [r3]
	b	.L2931
.L2923:
	ldr	r3, [sp, #12]
	mla	r10, fp, r3, r10
	cmp	r0, #0
	bne	.L2928
	mov	r1, r10
	bl	flash_erase_block
	b	.L2928
.L2930:
	cmp	r8, #0
	bne	.L2932
.L2939:
	ldrb	r3, [r4]	@ zero_extendqisi2
	cmp	r3, #255
	bne	.L2956
	movw	r2, #885
	ldr	r1, .L2957+44
	ldr	r0, .L2957+36
	bl	printf
.L2956:
	movs	r0, #0
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2932:
	ldrb	r5, [r4, #1]	@ zero_extendqisi2
	ldr	r6, .L2957+48
	ldr	r7, .L2957+44
	adds	r5, r5, #1
.L2935:
	cmp	r5, #7
	bhi	.L2939
	ldr	r3, [r6]
	add	r3, r3, r5
	ldrb	r8, [r3, #40]	@ zero_extendqisi2
	uxth	r3, r8
	cmp	r3, #128
	bls	.L2936
	cmp	r3, #255
	beq	.L2937
	mov	r2, #876
	mov	r1, r7
	ldr	r0, .L2957+36
	bl	printf
.L2936:
	ldr	r3, .L2957+16
	movs	r0, #0
	ldrh	r1, [r3]
	mul	r1, r8, r1
	bl	flash_erase_block
.L2937:
	adds	r5, r5, #1
	uxth	r5, r5
	b	.L2935
.L2926:
	adds	r3, r3, #1
	cmp	r3, #8
	bne	.L2940
	mov	r8, r3
	b	.L2925
.L2958:
	.align	2
.L2957:
	.word	.LANCHOR131
	.word	.LANCHOR193
	.word	.LANCHOR110
	.word	.LANCHOR194
	.word	.LANCHOR111
	.word	.LANCHOR195
	.word	.LANCHOR14
	.word	.LC154
	.word	.LANCHOR95
	.word	.LC0
	.word	.LANCHOR197
	.word	.LANCHOR196
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
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L2988
	ldr	r2, .L2988+4
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r4, #0
	strb	r4, [r3]
	movs	r3, #1
	sub	sp, sp, #24
	mov	r1, r4
	strb	r3, [r2]
	ldr	r7, .L2988+8
	ldr	r2, .L2988+12
	ldr	r5, .L2988+16
	ldr	r0, [r7]
	mov	fp, r7
	strb	r3, [r2]
	mov	r2, #16384
	ldr	r3, .L2988+20
	ldr	r6, .L2988+24
	str	r0, [r3]
	ldr	r3, .L2988+28
	ldrh	r3, [r3]
	add	r3, r0, r3, lsl #2
	str	r3, [r5]
	bl	ftl_memset
	ldr	r3, .L2988+32
	mov	r2, #16384
	mov	r1, r4
	ldr	r0, [r3]
	bl	ftl_memset
	ldr	r2, [r6]
	ldr	r3, .L2988+36
	ldrb	r2, [r2, #40]	@ zero_extendqisi2
	strb	r4, [r3, #1]
	strh	r4, [r3, #2]	@ movhi
	movs	r4, #7
	strb	r2, [r3]
	str	r3, [sp, #12]
.L2961:
	ldr	r3, [r6]
	sxth	r8, r4
	add	r3, r3, r4
	ldrb	r7, [r3, #40]	@ zero_extendqisi2
	cmp	r7, #255
	bne	.L2960
.L2965:
	adds	r4, r4, #-1
	bcs	.L2961
	mov	r8, #0
.L2962:
	ldr	r3, .L2988+40
	ldr	r3, [r3]
	lsls	r1, r3, #19
	bpl	.L2966
	ldr	r3, [r5]
	mov	r2, #4800
	mov	r1, r4
	ldr	r0, .L2988+44
	ldr	r3, [r3]
	bl	printf
.L2966:
	adds	r2, r4, #1
	bne	.L2967
	mov	r2, #16384
	movs	r1, #0
	ldr	r0, [fp]
	bl	ftl_memset
	ldr	r3, [r5]
	ldr	r2, .L2988+48
	str	r2, [r3]
	ldr	r2, .L2988+52
	str	r2, [r3, #12]
.L2959:
	mov	r0, r4
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2960:
	ldr	r3, .L2988+56
	movs	r0, #0
	ldrh	r3, [r3]
	muls	r7, r3, r7
	ldr	r3, .L2988+60
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r1, r7
	str	r3, [sp]
	ldr	r3, .L2988+64
	ldr	r2, [fp]
	bl	ftl_read_page
	cmp	r0, #-1
	mov	r10, r0
	bne	.L2963
	ldr	r3, .L2988+60
	adds	r1, r7, #1
	movs	r0, #0
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp]
	ldr	r3, .L2988+64
	ldr	r2, [fp]
	bl	ftl_read_page
	mov	r10, r0
.L2963:
	ldr	r3, .L2988+40
	ldr	r3, [r3]
	lsls	r0, r3, #19
	bpl	.L2964
	ldr	r3, [r5]
	mov	r2, r10
	mov	r1, r4
	ldr	r0, .L2988+68
	ldr	r3, [r3]
	str	r3, [sp]
	mov	r3, #744
	bl	printf
.L2964:
	cmp	r10, #-1
	beq	.L2965
	ldr	r3, [r5]
	ldr	r2, .L2988+48
	ldr	r3, [r3]
	cmp	r3, r2
	bne	.L2965
	mov	r4, r8
	b	.L2962
.L2967:
	ldr	r3, [r6]
	movs	r0, #0
	movs	r4, #0
	add	r3, r3, r8
	ldrb	r1, [r3, #40]	@ zero_extendqisi2
	ldr	r3, [sp, #12]
	strb	r1, [r3]
	strb	r8, [r3, #1]
	movs	r3, #4
	str	r3, [sp]
	ldr	r3, .L2988+64
	ldr	r2, [fp]
	bl	flash_get_last_written_page
	uxth	r6, r0
	ldr	r2, .L2988+56
	mov	r7, r0
	adds	r3, r6, #1
	uxth	r10, r3
	ldr	r3, [sp, #12]
	ldrh	r2, [r2]
	ldrb	r3, [r3]	@ zero_extendqisi2
	muls	r3, r2, r3
	str	r3, [sp, #16]
.L2969:
	subs	r3, r6, r4
	lsls	r3, r3, #16
	bmi	.L2973
	ldr	r3, [sp, #16]
	movs	r0, #0
	ldr	r8, .L2988+60
	adds	r1, r7, r3
	ldrb	r3, [r8]	@ zero_extendqisi2
	subs	r1, r1, r4
	str	r3, [sp]
	ldr	r3, .L2988+64
	ldr	r2, [fp]
	bl	ftl_read_page
	adds	r0, r0, #1
	beq	.L2970
	ldr	r3, .L2988+16
	ldr	r2, .L2988+48
	ldr	r3, [r3]
	ldr	r3, [r3]
	cmp	r3, r2
	bne	.L2970
	ldr	r3, .L2988+64
	ldr	r3, [r3, #8]
	cbnz	r3, .L2971
.L2973:
	ldr	r3, [sp, #12]
	strh	r10, [r3, #2]	@ movhi
	bl	ftl_tmp_into_update
	ldr	r2, [r5]
	movs	r0, #0
	ldr	r3, [r2, #64]
	adds	r3, r3, #1
	str	r3, [r2, #64]
	bl	ftl_info_flush
	movs	r0, #0
	bl	ftl_info_flush
	ldr	r3, .L2988+40
	ldr	r4, [r3]
	ands	r4, r4, #16384
	beq	.L2959
	ldr	r3, [r5]
	movs	r4, #0
	ldr	r0, .L2988+72
	ldr	r1, [r3, #156]
	bl	printf
	b	.L2959
.L2971:
	ldrb	r1, [r8]	@ zero_extendqisi2
	ldr	r0, [fp]
	str	r3, [sp, #20]
	lsls	r1, r1, #9
	bl	js_hash
	ldr	r3, [sp, #20]
	cmp	r3, r0
	beq	.L2973
	mov	r1, r3
	ldr	r0, .L2988+76
	bl	printf
.L2970:
	adds	r4, r4, #1
	b	.L2969
.L2989:
	.align	2
.L2988:
	.word	.LANCHOR198
	.word	.LANCHOR197
	.word	.LANCHOR195
	.word	.LANCHOR199
	.word	.LANCHOR110
	.word	.LANCHOR7
	.word	.LANCHOR27
	.word	.LANCHOR6
	.word	.LANCHOR200
	.word	.LANCHOR194
	.word	.LANCHOR14
	.word	.LC156
	.word	1229739078
	.word	393251
	.word	.LANCHOR111
	.word	.LANCHOR131
	.word	.LANCHOR193
	.word	.LC155
	.word	.LC158
	.word	.LC157
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
	ldr	r3, .L3006
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	ldr	r3, [r3]
	ldr	r2, [r3, #520]
	cbz	r2, .L2991
	movs	r2, #0
	str	r2, [r3, #520]
.L2991:
	ldr	r6, .L3006+4
	movs	r0, #0
	bl	ftl_total_vpn_update
	mov	r5, r6
.L2995:
	ldr	r3, [r6]
	ldr	r2, [r3, #56]
	adds	r2, r2, #1
	str	r2, [r3, #56]
	ldrh	r2, [r3, #140]
	ldr	r3, .L3006+8
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L2993
	bl	ftl_ext_alloc_new_blk
.L2993:
	ldr	r3, [r5]
	ldrh	r2, [r3, #130]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L2994
	movw	r2, #2203
	ldr	r1, .L3006+12
	ldr	r0, .L3006+16
	bl	printf
.L2994:
	ldr	r3, .L3006+20
	ldr	r2, [r5]
	ldr	fp, .L3006+40
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldrh	r1, [r2, #130]
	ldr	r8, .L3006+44
	rsb	r4, r3, #24
	ldr	r3, .L3006+24
	mov	r0, r8
	ldrh	r3, [r3]
	subs	r3, r4, r3
	movs	r4, #1
	asr	r7, r1, r3
	lsls	r4, r4, r3
	ldr	r3, .L3006+28
	subs	r4, r4, #1
	ands	r4, r4, r1
	ldrh	r1, [r3]
	sxth	r4, r4
	ldrh	r3, [r2, #140]
	ldrb	r2, [fp]	@ zero_extendqisi2
	mla	r4, r1, r4, r3
	lsls	r2, r2, #1
	movs	r1, #0
	bl	ftl_memset
	movs	r3, #0
	ldrb	fp, [fp]	@ zero_extendqisi2
	str	r3, [r8]
	ldr	r3, [r5]
	lsl	r1, fp, #9
	ldr	r3, [r3, #56]
	str	r3, [r8, #4]
	ldr	r3, .L3006+32
	ldr	r10, [r3]
	mov	r0, r10
	bl	js_hash
	mov	r3, r8
	str	r0, [r8, #8]
	mov	r2, r10
	str	fp, [sp]
	mov	r1, r4
	uxtb	r0, r7
	bl	ftl_prog_page
	ldr	r2, [r5]
	ldrh	r3, [r2, #140]
	adds	r3, r3, #1
	uxth	r3, r3
	cmp	r3, #1
	strh	r3, [r2, #140]	@ movhi
	beq	.L2995
	adds	r0, r0, #1
	ldr	r3, .L3006+36
	beq	.L2996
	ldrb	r0, [r3]	@ zero_extendqisi2
	cbz	r0, .L2997
.L2996:
.L2992:
	movs	r2, #0
	strb	r2, [r3]
	b	.L2995
.L2997:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3007:
	.align	2
.L3006:
	.word	.LANCHOR10
	.word	.LANCHOR110
	.word	.LANCHOR95
	.word	.LANCHOR201
	.word	.LC0
	.word	.LANCHOR32
	.word	.LANCHOR75
	.word	.LANCHOR111
	.word	.LANCHOR200
	.word	.LANCHOR199
	.word	.LANCHOR131
	.word	.LANCHOR193
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
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r2, #0
	ldr	r3, .L3030
	ldr	r5, .L3030+4
	strh	r2, [r3]	@ movhi
	ldr	r1, .L3030+8
	ldr	r3, [r5]
	ldrh	r4, [r1]
	ldrh	r2, [r3, #130]
	ldr	r3, .L3030+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	rsb	r3, r3, #24
	subs	r3, r3, r4
	movs	r4, #1
	lsls	r4, r4, r3
	asr	r7, r2, r3
	subs	r4, r4, #1
	uxtb	r8, r7
	ands	r4, r4, r2
	ldr	r2, .L3030+16
	movs	r3, #4
	mov	r1, r4
	str	r3, [sp]
	mov	r0, r8
	ldr	r3, .L3030+20
	ldr	r2, [r2]
	bl	flash_get_last_written_page
	ldr	r3, .L3030+24
	mov	r6, r0
	ldr	r3, [r3]
	lsls	r2, r3, #19
	bpl	.L3009
	ldr	r3, [r5]
	uxth	r7, r7
	movw	r2, #2248
	ldr	r1, .L3030+28
	ldrh	r3, [r3, #130]
	str	r7, [sp]
	str	r3, [sp, #4]
	mov	r3, r0
	ldr	r0, .L3030+32
	bl	printf
.L3009:
	movs	r7, #0
.L3010:
	uxth	r10, r6
	sub	r3, r10, r7
	lsls	r0, r3, #16
	bmi	.L3015
	ldr	r3, .L3030+36
	subs	r1, r6, r7
	ldr	fp, .L3030+60
	ldr	r2, .L3030+16
	ldrh	r0, [r3]
	ldrb	r3, [fp]	@ zero_extendqisi2
	mla	r1, r4, r0, r1
	str	r3, [sp]
	ldr	r3, .L3030+20
	ldr	r2, [r2]
	mov	r0, r8
	bl	flash_read_page_en
	adds	r3, r0, #1
	beq	.L3011
	cmp	r0, #512
	beq	.L3011
	ldr	r3, .L3030+40
	ldr	r2, .L3030+44
	ldr	r3, [r3]
	ldr	r3, [r3]
	cmp	r3, r2
	bne	.L3011
	ldr	r3, .L3030+20
	ldr	r3, [r3, #8]
	cmp	r3, #0
	bne	.L3012
.L3015:
	bl	zftl_sblk_list_init
	ldr	r2, [r5]
	ldrh	r3, [r2, #140]
	cmp	r3, r6
	bgt	.L3014
	add	r3, r10, #1
	strh	r3, [r2, #140]	@ movhi
	bl	ftl_ext_info_flush
.L3014:
	ldr	r3, .L3030+40
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
	ldr	r1, .L3030+24
	str	r2, [r3, #520]
	str	r2, [r3, #604]
	ldr	r1, [r1]
	str	r2, [r3, #608]
	lsls	r1, r1, #19
	bpl	.L3017
	str	r2, [sp]
	ldr	r1, .L3030+28
	ldr	r3, [r3, #12]
	ldr	r0, .L3030+48
	bl	printf
.L3017:
	ldr	r3, .L3030+52
	movw	r2, #65535
	movs	r0, #0
	strh	r2, [r3]	@ movhi
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3012:
	ldrb	r1, [fp]	@ zero_extendqisi2
	str	r3, [sp, #12]
	ldr	r3, .L3030+16
	lsls	r1, r1, #9
	ldr	r0, [r3]
	bl	js_hash
	ldr	r3, [sp, #12]
	cmp	r3, r0
	beq	.L3015
	mov	r1, r3
	ldr	r0, .L3030+56
	bl	printf
.L3011:
	adds	r7, r7, #1
	b	.L3010
.L3031:
	.align	2
.L3030:
	.word	.LANCHOR121
	.word	.LANCHOR110
	.word	.LANCHOR75
	.word	.LANCHOR32
	.word	.LANCHOR200
	.word	.LANCHOR193
	.word	.LANCHOR14
	.word	.LANCHOR202
	.word	.LC159
	.word	.LANCHOR111
	.word	.LANCHOR10
	.word	1162432070
	.word	.LC161
	.word	.LANCHOR73
	.word	.LC160
	.word	.LANCHOR131
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
	ldr	r3, .L3034
	movs	r1, #0
	ldr	r5, .L3034+4
	ldr	r0, [r3]
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
	bls	.L3033
	movw	r2, #2476
	ldr	r1, .L3034+8
	ldr	r0, .L3034+12
	bl	printf
.L3033:
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
	ldr	r3, .L3034+16
	ldr	r1, .L3034+20
	ldr	r2, [r5]
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldrh	r1, [r1]
	strh	r7, [r2, #692]	@ movhi
	rsb	r3, r3, #24
	strh	r6, [r2, #416]	@ movhi
	subs	r3, r3, r1
	asr	r3, r7, r3
	ldr	r7, .L3034+24
	strh	r3, [r2, #694]	@ movhi
	movs	r3, #1
	strh	r3, [r2, #688]	@ movhi
	ldr	r3, .L3034+28
	ldrh	r3, [r3]
	strh	r3, [r2, #698]	@ movhi
	ldr	r2, .L3034+32
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
.L3035:
	.align	2
.L3034:
	.word	.LANCHOR200
	.word	.LANCHOR110
	.word	.LANCHOR203
	.word	.LC0
	.word	.LANCHOR32
	.word	.LANCHOR75
	.word	.LANCHOR10
	.word	.LANCHOR204
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
	ldr	r6, .L3073
	sub	sp, sp, #40
	movs	r1, #0
	ldr	r0, .L3073+4
	bl	printf
.L3039:
	ldr	r3, [r6]
	add	r3, r3, r4
	ldrb	r5, [r3, #32]	@ zero_extendqisi2
	cmp	r5, #128
	ble	.L3037
	cmp	r5, #255
	beq	.L3038
	movw	r2, #2531
	ldr	r1, .L3073+8
	ldr	r0, .L3073+12
	bl	printf
.L3037:
	ldr	r3, .L3073+16
	movs	r0, #0
	ldrh	r1, [r3]
	muls	r1, r5, r1
	bl	flash_erase_block
.L3038:
	adds	r4, r4, #1
	cmp	r4, #16
	bne	.L3039
	bl	sblk_init
	bl	ftl_info_blk_init
	ldr	r3, .L3073+20
	mov	r2, #16384
	movs	r1, #0
	ldr	r0, [r3]
	bl	ftl_memset
	ldr	r2, .L3073+24
	movs	r0, #1
	ldr	r1, .L3073+28
	ldr	r3, [r2]
	ldrh	r1, [r1]
	str	r2, [sp, #24]
	add	r1, r3, r1, lsl #2
.L3040:
	cmp	r3, r1
	bne	.L3041
	ldr	r7, .L3073+32
	movs	r4, #0
	ldr	r2, .L3073+36
	ldr	r3, [r7]
	str	r2, [r3]
	strh	r4, [r3, #148]	@ movhi
.L3042:
	ldr	r3, .L3073+28
	uxth	r0, r4
	ldrh	r3, [r3]
	cmp	r3, r0
	bhi	.L3050
	ldr	r3, .L3073+40
	mov	fp, #15
	ldrb	r5, [r3]	@ zero_extendqisi2
	ldr	r3, .L3073
	mov	r1, r5
	ldr	r3, [r3]
	ldrb	r0, [r3, #47]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	ldr	r3, .L3073+24
	uxtb	r0, r0
	cmp	r5, #1
	uxth	lr, r5
	add	r4, r0, #1
	ldr	r10, [r3]
	it	eq
	moveq	r8, #1
	ldr	r3, .L3073+32
	it	ne
	movne	r8, #3
	movs	r2, #0
	ldr	r6, [r3]
	ldrh	r3, [r6, #148]
.L3053:
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
	bhi	.L3053
	smulbb	r0, r0, lr
	add	r3, r3, lr
	mov	r1, r5
	uxtah	r0, r0, r3
	strh	r0, [r6, #148]	@ movhi
	movs	r0, #16
	bl	__aeabi_idiv
	ldr	r3, .L3073+44
	add	r0, r0, r4
	uxth	r0, r0
	ldr	r3, [r3]
	strh	r0, [r6, #134]	@ movhi
	lsls	r3, r3, #19
	bpl	.L3054
	str	r0, [sp]
	mov	r3, r4
	movs	r2, #128
	movw	r1, #2590
	ldr	r0, .L3073+48
	bl	printf
.L3054:
	ldr	r0, [r7]
	movs	r2, #128
	movs	r1, #255
	movs	r5, #0
	adds	r0, r0, #160
	bl	ftl_memset
	ldr	r3, [sp, #24]
	ldr	r0, .L3073+52
	ldr	r1, [r7]
	ldr	r3, [r3]
	ldrh	r0, [r0]
	ldrh	fp, [r1, #134]
	str	r3, [sp, #24]
	ldr	r3, .L3073+56
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp, #28]
	ldr	r3, .L3073+40
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp, #12]
	ldr	r3, .L3073+60
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
.L3055:
	cmp	r4, fp
	bcc	.L3061
	ldr	r3, .L3073+28
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
.L3041:
	ldrb	r2, [r3, #2]	@ zero_extendqisi2
	adds	r3, r3, #4
	and	r2, r2, #31
	bfi	r2, r0, #3, #2
	strb	r2, [r3, #-2]
	b	.L3040
.L3050:
	ldr	r3, .L3073+64
	strh	r0, [r3]	@ movhi
	ldr	r3, .L3073+68
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L3043
	bl	ftl_test_block
.L3043:
	ldr	r3, .L3073+56
	uxth	r1, r4
	ldr	r0, .L3073+24
	movs	r6, #0
	mov	fp, r6
	mov	r8, r6
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldr	r5, [r0]
	str	r3, [sp, #16]
	ldr	r3, .L3073+40
	add	r5, r5, r1, lsl #2
	ldrb	r3, [r3]	@ zero_extendqisi2
	uxth	r2, r3
	str	r2, [sp, #20]
	mul	r2, r3, r1
	ldr	r1, .L3073+32
	ldr	r1, [r1]
	str	r1, [sp, #12]
.L3044:
	ldr	r0, [sp, #16]
	uxth	r1, fp
	cmp	r0, r1
	bhi	.L3062
	cmp	r8, #0
	bne	.L3049
	ldrb	r3, [r5, #2]	@ zero_extendqisi2
	orr	r3, r3, #224
	strb	r3, [r5, #2]
.L3049:
	adds	r4, r4, #1
	b	.L3042
.L3047:
	add	r1, r10, r2
	ldr	r0, [sp, #28]
	str	r3, [sp, #36]
	str	r2, [sp, #32]
	bl	flash_check_bad_block
	ldr	r2, [sp, #32]
	ldr	r3, [sp, #36]
	cbz	r0, .L3045
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
.L3046:
	add	r10, r10, #1
.L3048:
	sub	r1, r10, r6
	ldr	r0, [sp, #20]
	uxth	r1, r1
	cmp	r0, r1
	bhi	.L3047
	add	fp, fp, #1
	add	r6, r6, r3
	subs	r2, r2, r3
	b	.L3044
.L3045:
	add	r8, r8, #1
	uxth	r8, r8
	b	.L3046
.L3062:
	uxtb	r1, fp
	mov	r10, r6
	str	r1, [sp, #28]
	b	.L3048
.L3061:
	ldr	r3, [sp, #24]
	movs	r0, #0
	mov	lr, r0
	mov	ip, r0
	add	r8, r3, r4, lsl #2
	ldrb	r3, [r8, #2]	@ zero_extendqisi2
	orr	r3, r3, #224
	strb	r3, [r8, #2]
.L3056:
	ldr	r6, [sp, #28]
	uxth	r3, ip
	cmp	r3, r6
	bcc	.L3064
	adds	r4, r4, #1
	add	r2, r2, r7
	uxth	r4, r4
	uxth	r2, r2
	b	.L3055
.L3059:
	ldrb	r10, [r8, #3]	@ zero_extendqisi2
	add	r3, lr, r6
	asr	r10, r10, r3
	tst	r10, #1
	bne	.L3057
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
.L3057:
	adds	r6, r6, #1
.L3060:
	uxth	r3, r6
	cmp	r3, r7
	str	r3, [sp, #16]
	bcc	.L3059
	ldr	r3, [sp, #12]
	add	ip, ip, #1
	add	lr, lr, r3
	ldr	r3, [sp, #20]
	add	r0, r0, r3
	uxth	r0, r0
	b	.L3056
.L3064:
	movs	r6, #0
	b	.L3060
.L3074:
	.align	2
.L3073:
	.word	.LANCHOR27
	.word	.LC162
	.word	.LANCHOR205
	.word	.LC0
	.word	.LANCHOR111
	.word	.LANCHOR195
	.word	.LANCHOR7
	.word	.LANCHOR6
	.word	.LANCHOR110
	.word	1229739078
	.word	.LANCHOR76
	.word	.LANCHOR14
	.word	.LC163
	.word	.LANCHOR75
	.word	.LANCHOR112
	.word	.LANCHOR32
	.word	.LANCHOR69
	.word	.LANCHOR82
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
	ldr	r0, .L3081
	bl	printf
	bl	sblk_init
	bl	ftl_info_blk_init
	bl	ftl_ext_info_init
	ldr	r2, .L3081+4
	ldr	r3, .L3081+8
	ldrh	r7, [r2]
	ldr	r3, [r3]
	ldr	r2, .L3081+12
	ldrh	r1, [r3, #134]
	ldr	r0, [r2]
	movs	r2, #0
	mov	r5, r2
	mov	r6, r2
	add	r0, r0, r1, lsl #2
.L3076:
	cmp	r1, r7
	bcc	.L3080
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
.L3080:
	ldrb	r4, [r0, #2]	@ zero_extendqisi2
	bfc	r4, #5, #3
	strb	r4, [r0, #2]
	ands	r4, r4, #24
	bne	.L3077
	adds	r6, r6, #1
	uxth	r6, r6
.L3078:
	adds	r1, r1, #1
	uxth	r1, r1
	adds	r0, r0, #4
	b	.L3076
.L3077:
	cmp	r4, #16
	itete	eq
	addeq	r5, r5, #1
	addne	r2, r2, #1
	uxtheq	r5, r5
	uxthne	r2, r2
	b	.L3078
.L3082:
	.align	2
.L3081:
	.word	.LC164
	.word	.LANCHOR6
	.word	.LANCHOR110
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
	push	{r0, r1, r2, r4, r5, r6, r7, lr}
	ldr	r4, .L3084
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
.L3085:
	.align	2
.L3084:
	.word	.LANCHOR32
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
	bne	.L3089
	ldr	r3, .L3091
	ldrh	r7, [r0, #12]
	ldr	r5, [r3]
	bl	ftl_get_new_free_page
	adds	r3, r0, #1
	mov	r6, r0
	beq	.L3090
	ldrh	r0, [r4]
	add	r5, r5, r7, lsl #2
	ldr	r4, .L3091+4
	bl	ftl_vpn_decrement
	ldr	r3, .L3091+8
	mov	r0, r5
	ldr	r2, .L3091+12
	str	r3, [r4]
	ldr	r3, .L3091+16
	ldrb	r1, [r2]	@ zero_extendqisi2
	ldrh	r3, [r3]
	muls	r1, r3, r1
	lsls	r1, r1, #2
	bl	js_hash
	ldr	r3, .L3091+20
	movs	r2, #0
	str	r0, [r4, #4]
	mov	r1, r5
	str	r2, [r4, #8]
	mov	r0, r6
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r2, [r4, #12]
	str	r2, [r4, #16]
	cmp	r3, #8
	it	hi
	strhi	r2, [r4, #20]
	ldr	r2, .L3091+4
	bl	ftl_prog_ppa_page
.L3090:
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, pc}
.L3089:
	mov	r0, #-1
	pop	{r3, r4, r5, r6, r7, pc}
.L3092:
	.align	2
.L3091:
	.word	.LANCHOR117
	.word	.LANCHOR191
	.word	-178307901
	.word	.LANCHOR80
	.word	.LANCHOR95
	.word	.LANCHOR131
	.size	ftl_write_last_log_page, .-ftl_write_last_log_page
	.section	.text.pm_write_page,"ax",%progbits
	.align	1
	.global	pm_write_page
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	pm_write_page, %function
pm_write_page:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	ldr	r8, .L3106+28
	mov	r7, r1
	mov	r6, r8
.L3094:
	ldr	r3, [r8]
	ldr	r2, [r3, #48]
	ldrh	r1, [r3, #696]
	adds	r2, r2, #1
	str	r2, [r3, #48]
	ldr	r2, .L3106
	ldrh	r2, [r2]
	cmp	r1, r2
	bcs	.L3095
	ldrh	r2, [r3, #692]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L3096
.L3095:
	bl	pm_alloc_new_blk
	movs	r0, #0
	bl	ftl_info_flush
.L3096:
	ldr	r3, [r6]
	ldrh	r2, [r3, #692]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L3097
	movw	r2, #303
	ldr	r1, .L3106+4
	ldr	r0, .L3106+8
	bl	printf
.L3097:
	ldr	r3, [r6]
	movs	r1, #0
	ldr	r2, .L3106+12
	ldr	r10, .L3106+32
	ldrh	r5, [r3, #692]
	ldrh	r2, [r2]
	ldrh	r3, [r3, #696]
	ldr	r0, [r10]
	mla	r5, r2, r5, r3
	movs	r2, #64
	bl	ftl_memset
	ldr	r10, [r10]
	mov	r0, r7
	ldr	r3, [r6]
	str	r4, [r10]
	ldr	r2, [r3, #48]
	str	r3, [sp, #12]
	str	r2, [r10, #4]
	ldr	r2, .L3106+16
	ldrb	fp, [r2]	@ zero_extendqisi2
	lsl	r1, fp, #9
	bl	js_hash
	ldr	r3, [sp, #12]
	mov	r2, r7
	str	r0, [r10, #8]
	mov	r1, r5
	ldrb	r0, [r3, #694]	@ zero_extendqisi2
	mov	r3, r10
	str	fp, [sp]
	bl	ftl_prog_page
	ldr	r2, [r6]
	ldrh	r3, [r2, #696]
	adds	r3, r3, #1
	uxth	r3, r3
	cmp	r3, #1
	strh	r3, [r2, #696]	@ movhi
	ldr	r3, .L3106+20
	beq	.L3098
	ldrb	r1, [r3]	@ zero_extendqisi2
	cbz	r1, .L3099
.L3098:
	movs	r2, #0
	strb	r2, [r3]
	b	.L3094
.L3099:
	adds	r0, r0, #1
	bne	.L3101
	mov	r1, r5
	ldr	r0, .L3106+24
	bl	printf
	b	.L3094
.L3101:
	ldrh	r3, [r2, #698]
	movs	r0, #0
	cmp	r4, r3
	itt	cc
	addcc	r4, r4, #176
	strcc	r5, [r2, r4, lsl #2]
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3107:
	.align	2
.L3106:
	.word	.LANCHOR95
	.word	.LANCHOR206
	.word	.LC0
	.word	.LANCHOR111
	.word	.LANCHOR131
	.word	.LANCHOR208
	.word	.LC165
	.word	.LANCHOR110
	.word	.LANCHOR207
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
	ldr	r3, .L3147
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r5, r0
	sub	sp, sp, #104
	ldrh	r3, [r3]
	cmp	r3, r0
	bls	.L3108
	ldr	r3, .L3147+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L3110
	ldr	r3, .L3147+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L3108
.L3110:
	ldr	r3, .L3147+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L3108
	ldr	r7, .L3147+16
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
	ldreq	r3, .L3147+20
	movne	fp, #1
	ldrbeq	fp, [r3]	@ zero_extendqisi2
	bl	ftl_get_blk_list_in_sblk
	ldr	r3, .L3147+24
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
	ldr	r0, .L3147+28
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
.L3112:
	ldr	r3, .L3147+24
	uxth	r10, r6
	ldrh	r3, [r3]
	cmp	r3, r10
	bls	.L3121
	mov	r3, r10
	str	r10, [sp, #52]
	lsls	r3, r3, #1
	mov	r8, #0
	subs	r2, r3, #1
	add	r3, r3, r10
	subs	r3, r3, #1
	str	r2, [sp, #56]
	str	r3, [sp, #60]
	b	.L3124
.L3122:
	ldr	r3, [sp, #64]
	add	r2, sp, #104
	add	r3, r2, r3, lsl #1
	ldrh	r3, [r3, #-32]
	str	r3, [sp, #48]
	movw	r3, #65535
	ldr	r2, [sp, #48]
	cmp	r2, r3
	bne	.L3113
.L3120:
	adds	r7, r7, #1
	uxth	r7, r7
.L3114:
	cmp	fp, r7
	bcs	.L3122
	add	r8, r8, #1
.L3124:
	uxth	r3, r8
	str	r3, [sp, #44]
	ldr	r2, [sp, #44]
	ldrb	r3, [sp, #81]	@ zero_extendqisi2
	cmp	r3, r2
	bls	.L3123
	mov	r3, r2
	movs	r7, #1
	adds	r3, r3, #8
	str	r3, [sp, #64]
	b	.L3114
.L3113:
	ldr	r3, .L3147+32
	cmp	fp, #3
	ldr	r2, [sp, #48]
	ldrh	r3, [r3]
	mul	r3, r2, r3
	bne	.L3115
	ldr	r2, .L3147+36
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbz	r2, .L3116
	ldr	r2, [sp, #60]
.L3146:
	add	r3, r3, r2
	ldr	r2, .L3147+20
	add	r3, r3, r7
	ldrb	r2, [r2]	@ zero_extendqisi2
	orr	r3, r3, r2, lsl #24
	b	.L3117
.L3116:
	uxtah	r3, r3, r6
	orr	r3, r3, r7, lsl #24
.L3117:
	str	r3, [r4, #24]
	movs	r1, #1
	mov	r0, r4
	str	r3, [sp, #68]
	bl	sblk_read_page
	ldr	r3, [r4, #36]
	cmp	r3, #512
	str	r3, [sp, #40]
	ldr	r3, [sp, #68]
	beq	.L3119
	ldr	r2, [sp, #40]
	adds	r2, r2, #1
	bne	.L3120
.L3119:
	ldr	r1, [r4, #12]
	ldr	r2, [r4, #4]
	ldr	r0, [r1, #12]
	str	r0, [sp, #32]
	ldr	r0, [r1, #8]
	str	r0, [sp, #28]
	ldr	r0, [r1, #4]
	str	r0, [sp, #24]
	ldr	r1, [r1]
	ldr	r0, .L3147+40
	str	r1, [sp, #20]
	ldr	r1, [r2, #12]
	str	r1, [sp, #16]
	ldr	r1, [r2, #8]
	str	r1, [sp, #12]
	ldr	r1, [r2, #4]
	str	r1, [sp, #8]
	ldr	r2, [r2]
	ldr	r1, [sp, #48]
	str	r2, [sp, #4]
	ldr	r2, [sp, #40]
	str	r2, [sp]
	ldr	r2, [sp, #52]
	bl	printf
	ldr	r3, [sp, #40]
	cmp	r3, #512
	bne	.L3120
.L3121:
	uxth	r2, r6
	ldr	r6, .L3147+44
	ldr	r3, [sp, #44]
	mov	r1, r5
	str	r7, [sp]
	ldr	r0, .L3147+48
	bl	printf
	ldrb	r2, [r6]	@ zero_extendqisi2
	movs	r1, #0
	ldr	r0, [r4, #4]
	ldr	fp, .L3147+64
	lsls	r2, r2, #9
	bl	ftl_memset
	ldrb	r2, [r6]	@ zero_extendqisi2
	movs	r1, #0
	ldr	r0, [r4, #12]
	lsls	r2, r2, #1
	bl	ftl_memset
.L3125:
	ldr	r3, .L3147+24
	ldrh	r3, [r3]
	cmp	r3, r10
	bls	.L3131
	lsl	r3, r10, #1
	movs	r7, #0
	str	r3, [sp, #40]
	b	.L3132
.L3115:
	cmp	fp, #2
	bne	.L3118
	ldr	r2, [sp, #56]
	b	.L3146
.L3118:
	uxtah	r3, r3, r6
	b	.L3117
.L3123:
	adds	r6, r6, #1
	b	.L3112
.L3130:
	ldr	r3, [fp]
	uxth	r8, r7
	tst	r3, #4096
	beq	.L3126
	mov	r2, r8
	mov	r1, r10
	ldr	r0, .L3147+52
	bl	printf
.L3126:
	ldr	r2, .L3147+4
	ldr	r0, .L3147+32
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbz	r2, .L3127
	add	r3, sp, #104
	add	r3, r3, r8, lsl #1
	ldrh	r2, [r3, #-16]
	ldrh	r3, [r0]
	mov	r0, r4
	muls	r3, r2, r3
	orr	r3, r3, r10
	str	r3, [r4, #24]
	bl	sblk_3d_tlc_dump_prog
.L3128:
	adds	r7, r7, #1
.L3132:
	ldrb	r2, [sp, #81]	@ zero_extendqisi2
	uxth	r3, r7
	cmp	r2, r3
	bhi	.L3130
	add	r3, r10, #1
	uxth	r10, r3
	b	.L3125
.L3127:
	ldr	r1, .L3147+20
	add	r3, sp, #104
	add	r3, r3, r8, lsl #1
	ldrb	r1, [r1]	@ zero_extendqisi2
	cmp	r1, #2
	bne	.L3129
	ldrh	r2, [r3, #-16]
	ldrh	r3, [r0]
	mov	r0, r4
	muls	r3, r2, r3
	ldr	r2, [sp, #40]
	orrs	r3, r3, r2
	orr	r3, r3, #33554432
	str	r3, [r4, #24]
	bl	sblk_mlc_dump_prog
	b	.L3128
.L3129:
	ldrh	r3, [r3, #-16]
	ldrh	r1, [r0]
	movs	r0, #1
	muls	r1, r3, r1
	ldr	r3, .L3147+56
	ldrb	r3, [r3]	@ zero_extendqisi2
	orr	r1, r1, r10
	str	r1, [r4, #24]
	rsb	lr, r3, #24
	str	r2, [sp, #4]
	lsls	r0, r0, r3
	subs	r3, r0, #1
	lsr	r0, r1, lr
	lsl	ip, r3, lr
	ands	r0, r0, r3
	ldrb	r3, [r6]	@ zero_extendqisi2
	bic	r1, r1, ip
	uxtb	r0, r0
	str	r3, [sp]
	ldr	r3, [r4, #12]
	ldr	r2, [r4, #4]
	bl	flash_prog_page_en
	b	.L3128
.L3131:
	mov	r0, r4
	bl	zbuf_free
	mov	r1, r5
	ldr	r0, .L3147+60
	bl	printf
.L3108:
	add	sp, sp, #104
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3148:
	.align	2
.L3147:
	.word	.LANCHOR6
	.word	.LANCHOR84
	.word	.LANCHOR81
	.word	.LANCHOR36
	.word	.LANCHOR7
	.word	.LANCHOR79
	.word	.LANCHOR95
	.word	.LC166
	.word	.LANCHOR111
	.word	.LANCHOR37
	.word	.LC167
	.word	.LANCHOR131
	.word	.LC168
	.word	.LC169
	.word	.LANCHOR32
	.word	.LC170
	.word	.LANCHOR14
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
	ldr	r3, .L3161
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L3150
	ldr	r2, .L3161+4
	mov	r1, #364
	ldr	r0, .L3161+8
	bl	printf
.L3150:
	ldr	r5, .L3161+12
	movs	r2, #64
	ldr	r6, .L3161+16
	movs	r1, #0
	movs	r7, #0
	ldr	r0, [r5]
	bl	ftl_memset
	movs	r3, #16
	movs	r2, #4
	ldr	r1, [r6]
	ldr	r0, .L3161+20
	bl	rknand_print_hex
	ldr	r4, [r6]
	ldr	r1, [r4, #8]
	add	r0, r4, #16
	bl	js_hash
	str	r5, [sp, #8]
	ldr	r5, .L3161+24
	str	r0, [r4, #12]
	mov	r8, r5
.L3151:
	ldr	fp, .L3161+44
	ldrb	r10, [r5]	@ zero_extendqisi2
	ldrh	r4, [r5, #2]
	ldrh	r3, [fp]
	mov	r1, r10
	ldr	r0, .L3161+28
	mov	r2, r4
	str	r3, [sp, #12]
	bl	printf
	ldr	r2, .L3161+32
	ldrh	r0, [r5, #2]
	ldr	r3, [sp, #12]
	ldrh	r2, [r2]
	subs	r2, r2, #1
	cmp	r0, r2
	blt	.L3152
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
.L3160:
	bl	flash_erase_block
.L3153:
	ldr	r2, [r6]
	mov	r10, #1
	ldr	r3, [sp, #8]
	movs	r0, #0
	ldr	r1, [r2, #4]
	ldr	r3, [r3]
	str	r1, [r3]
	ldr	r1, .L3161+36
	str	r1, [r3, #4]
	movs	r1, #4
	stm	sp, {r1, r10}
	mov	r1, r4
	bl	flash_prog_page_en
	ldrh	r3, [r8, #2]
	adds	r0, r0, #1
	add	r3, r3, r10
	strh	r3, [r8, #2]	@ movhi
	bne	.L3154
	mov	r1, r4
	ldr	r0, .L3161+40
	bl	printf
	b	.L3151
.L3156:
	mov	r7, r10
	b	.L3151
.L3152:
	mla	r4, r10, r3, r4
	cmp	r0, #0
	bne	.L3153
	mov	r1, r4
	b	.L3160
.L3154:
	cmp	r7, #0
	beq	.L3156
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3162:
	.align	2
.L3161:
	.word	.LANCHOR14
	.word	.LANCHOR209
	.word	.LC97
	.word	.LANCHOR210
	.word	.LANCHOR27
	.word	.LC171
	.word	.LANCHOR211
	.word	.LC172
	.word	.LANCHOR147
	.word	1398362953
	.word	.LC173
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
	ldr	r3, .L3194
	ldr	r4, .L3194+4
	ldr	r3, [r3]
	tst	r3, #4096
	beq	.L3164
	ldr	r3, [r4]
	movs	r1, #49
	ldr	r2, .L3194+8
	ldr	r0, .L3194+12
	str	r3, [sp]
	mov	r3, #2048
	bl	printf
.L3164:
	ldr	r7, .L3194+16
	mov	r8, #4
.L3168:
	movs	r6, #0
.L3167:
	ldr	r10, .L3194+32
	mov	fp, #4
	ldr	r5, .L3194+20
	movs	r0, #0
	ldr	r2, [r4]
	ldrh	r1, [r10]
	ldr	r3, [r5]
	str	fp, [sp]
	mla	r1, r8, r1, r6
	bl	flash_read_page_en
	adds	r0, r0, #1
	beq	.L3165
	ldr	r2, [r4]
	ldr	r3, [r2]
	cmp	r3, r7
	beq	.L3166
.L3165:
	adds	r6, r6, #1
	cmp	r6, #4
	bne	.L3167
	add	r8, r8, #1
	cmp	r8, #16
	bne	.L3168
.L3193:
	mov	r0, #-1
.L3163:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3176:
	ldr	r3, [r4]
	ldr	r2, [r3]
	cmp	r2, r7
	bne	.L3177
	ldr	r8, [r3, #4]
.L3170:
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
	beq	.L3171
	ldr	r3, [r4]
	ldr	r2, [r3]
	cmp	r2, r7
	bne	.L3171
	ldr	r2, [r3, #4]
	cmp	r8, r2
	itttt	cc
	ldrbcc	r2, [r3, #37]	@ zero_extendqisi2
	ldrbcc	r3, [r3, #36]	@ zero_extendqisi2
	strbcc	r2, [r6]
	strbcc	r3, [r6, #1]
.L3171:
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
.L3172:
	sub	r0, fp, r6
	sxth	r3, r0
	cmp	r3, #0
	bge	.L3175
	adds	r2, r3, #1
	bne	.L3174
	ldr	r2, [r4]
	ldr	r0, .L3194+24
	str	r3, [sp, #12]
	ldr	r1, [r2]
	bl	printf
	b	.L3193
.L3175:
	str	r8, [sp]
	sub	r1, r10, r6
	ldr	r3, [r5]
	movs	r0, #0
	ldr	r2, [r4]
	bl	flash_read_page_en
	adds	r0, r0, #1
	beq	.L3173
	ldr	r3, [r4]
	ldr	r3, [r3]
	cmp	r3, r7
	beq	.L3174
.L3173:
	adds	r6, r6, #1
	b	.L3172
.L3174:
	cmp	r6, #1
	bls	.L3178
	bl	flash_info_flush
.L3178:
	movs	r0, #0
	b	.L3163
.L3166:
	ldrb	r1, [r2, #36]	@ zero_extendqisi2
	ldrh	r0, [r10]
	ldrb	r3, [r2, #37]	@ zero_extendqisi2
	ldr	r6, .L3194+28
	strb	r1, [r6]
	muls	r1, r0, r1
	strb	r3, [r6, #1]
	movs	r0, #0
	str	fp, [sp]
	ldr	r3, [r5]
	bl	flash_read_page_en
	adds	r0, r0, #1
	bne	.L3176
.L3177:
	mov	r8, #0
	b	.L3170
.L3195:
	.align	2
.L3194:
	.word	.LANCHOR14
	.word	.LANCHOR27
	.word	.LANCHOR212
	.word	.LC174
	.word	1398362953
	.word	.LANCHOR210
	.word	.LC175
	.word	.LANCHOR211
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
	ldr	r3, .L3289
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	mov	r8, r3
	ldr	r2, [r3]
	tst	r2, #4096
	beq	.L3197
	ldr	r2, .L3289+4
	movw	r1, #3429
	ldr	r0, .L3289+8
	bl	printf
.L3197:
	ldr	r3, .L3289+12
	movs	r6, #0
	mov	r0, r4
	ldr	r7, .L3289+16
	ldr	r5, .L3289+20
	str	r6, [r3]
	bl	nandc_init
	ldr	r3, .L3289+24
	movs	r2, #1
	ldr	r4, .L3289+28
	mov	r1, r6
	ldr	r0, .L3289+32
	strb	r2, [r3]
	movs	r3, #3
	movs	r2, #8
	strb	r3, [r7]
	str	r4, [r5]
	bl	ftl_memset
	movs	r2, #32
	mov	r1, r6
	ldr	r0, .L3289+36
	bl	ftl_memset
	str	r7, [sp]
	ldr	r7, .L3289+40
	mov	fp, r7
.L3203:
	lsl	r10, r6, #3
	uxtb	r0, r6
	add	r1, r7, r10
	bl	flash_read_id
	cbnz	r6, .L3198
	ldrb	r3, [r7]	@ zero_extendqisi2
	subs	r3, r3, #1
	uxtb	r3, r3
	cmp	r3, #253
	bls	.L3199
.L3201:
	mvn	fp, #1
.L3196:
	mov	r0, fp
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3199:
	ldrb	r3, [r7, #1]	@ zero_extendqisi2
	cmp	r3, #255
	beq	.L3201
.L3198:
	ldrb	r3, [fp, r10]	@ zero_extendqisi2
	adds	r6, r6, #1
	cmp	r3, #181
	itt	eq
	moveq	r3, #44
	strbeq	r3, [fp, r10]
	cmp	r6, #4
	bne	.L3203
	ldr	r7, .L3289+44
	movs	r6, #0
	ldr	r3, .L3289+40
.L3206:
	mov	r1, r3
	ldrb	r2, [r7, #-1]	@ zero_extendqisi2
	mov	r0, r7
	str	r3, [sp, #4]
	lsl	r10, r6, #5
	bl	flash_mem_cmp8
	ldr	r3, [sp, #4]
	cmp	r0, #0
	bne	.L3204
	ldr	r6, .L3289+48
	ldr	r3, .L3289+52
	add	r6, r6, r10
	ldrb	r2, [r6, #22]	@ zero_extendqisi2
	mov	r1, r3
.L3205:
	lsls	r7, r0, #5
	ldrb	r7, [r7, r3]	@ zero_extendqisi2
	cmp	r7, r2
	beq	.L3207
	adds	r0, r0, #1
	cmp	r0, #4
	bne	.L3205
.L3207:
	ldr	r7, .L3289+56
	add	r1, r1, r0, lsl #5
	movs	r2, #32
	ldr	r0, .L3289+60
	bl	ftl_memcpy
	movs	r2, #32
	mov	r1, r6
	ldr	r0, .L3289+28
	bl	ftl_memcpy
	ldrb	r3, [r7]	@ zero_extendqisi2
	cmp	r3, #8
	bhi	.L3208
	ldrb	r3, [r4, #20]	@ zero_extendqisi2
	cmp	r3, #60
	bls	.L3208
	movs	r3, #60
	strb	r3, [r4, #20]
.L3208:
	ldr	r3, [r8]
	lsls	r3, r3, #19
	bpl	.L3242
	ldr	r2, .L3289+4
	mov	r1, #3456
	ldr	r0, .L3289+8
	bl	printf
.L3242:
	ldr	r3, [r5]
	mov	r0, #16384
	ldr	r6, .L3289+64
	mov	r10, #0
	ldrh	r3, [r3, #10]
	cmp	r3, #1024
	ittt	cs
	ldrcs	r2, [sp]
	movcs	r3, #2
	strbcs	r3, [r2]
	bl	ftl_malloc
	ldr	r3, .L3289+68
	str	r0, [r3]
	mov	r0, #16384
	bl	ftl_malloc
	ldr	r3, .L3289+72
	str	r0, [r3]
	mov	r0, #2048
	bl	ftl_malloc
	str	r0, [r6]
	movs	r0, #64
	bl	ftl_malloc
	ldr	r3, .L3289+76
	str	r0, [r3]
	movs	r0, #64
	bl	ftl_malloc
	ldr	r3, .L3289+80
	str	r0, [r3]
	movs	r0, #64
	bl	ftl_malloc
	ldr	r3, .L3289+84
	str	r0, [r3]
	ldr	r3, .L3289+88
	strb	r10, [r3]
	bl	flash_die_info_init
	ldrb	r0, [r4, #18]	@ zero_extendqisi2
	bl	flash_lsb_page_tbl_build
	ldrb	r0, [r4, #20]	@ zero_extendqisi2
	bl	nandc_bch_sel
	ldr	r1, [r5]
	ldr	r0, .L3289+92
	ldrh	r3, [r1, #16]
	ubfx	r2, r3, #8, #3
	ubfx	r5, r3, #3, #1
	strb	r2, [r0]
	ldr	r2, .L3289+96
	strb	r5, [r2]
	ubfx	r5, r3, #4, #1
	ldr	r2, .L3289+100
	strb	r5, [r2]
	ubfx	r5, r3, #12, #1
	ldr	r2, .L3289+104
	strb	r5, [r2]
	ubfx	r5, r3, #13, #1
	ldr	r2, .L3289+108
	strb	r5, [r2]
	ubfx	r5, r3, #11, #1
	ldr	r2, .L3289+112
	strb	r5, [r2]
	ldrb	r2, [r1, #31]	@ zero_extendqisi2
	ldr	r5, .L3289+116
	ubfx	ip, r2, #1, #1
	strb	ip, [r5]
	ubfx	ip, r2, #2, #1
	ldr	r5, .L3289+120
	strb	ip, [r5]
	ubfx	ip, r3, #14, #1
	ldr	r5, .L3289+124
	lsrs	r3, r3, #15
	strb	ip, [r5]
	ldr	r5, .L3289+128
	strb	r3, [r5]
	ubfx	r5, r2, #3, #1
	ldrb	r3, [r1, #28]	@ zero_extendqisi2
	ubfx	r2, r2, #4, #1
	ldr	r1, .L3289+132
	strb	r3, [r1]
	ldr	r1, .L3289+136
	strb	r5, [r1]
	ldr	r1, .L3289+140
	ldr	r5, .L3289+144
	strb	r2, [r1]
	movs	r2, #60
	ldr	r1, .L3289+148
	str	r10, [r5]
	mov	r10, r0
	strb	r2, [r1]
	ldrb	r2, [r7]	@ zero_extendqisi2
	ldr	r7, .L3289+152
	cmp	r2, #9
	strb	r3, [r7]
	it	eq
	moveq	r0, #70
	ldrb	r3, [r4, #31]	@ zero_extendqisi2
	it	eq
	strbeq	r0, [r1]
	lsls	r3, r3, #31
	bpl	.L3211
	ldrb	r3, [r4, #29]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L3212
	movs	r3, #2
.L3282:
	strb	r3, [r7]
.L3211:
	cmp	r2, #8
	bne	.L3213
	ldrb	r3, [fp]	@ zero_extendqisi2
	cmp	r3, #44
	beq	.L3214
	cmp	r3, #137
	bne	.L3213
.L3214:
	ldrb	r3, [r4, #28]	@ zero_extendqisi2
	cmp	r3, #3
	itt	eq
	moveq	r3, #0
	strbeq	r3, [r7]
.L3213:
	ldrh	r1, [r4, #16]
	ldr	r2, .L3289+156
	ldrb	r3, [r4, #19]	@ zero_extendqisi2
	tst	r1, #64
	str	r2, [sp]
	strb	r3, [r2]
	beq	.L3216
	sub	r2, r3, #17
	cmp	r2, #2
	bls	.L3217
	cmp	r3, #21
	bne	.L3218
.L3217:
	ldr	r2, .L3289+160
	cmp	r3, #21
	ldr	r3, .L3289+164
	str	r2, [r5]
	beq	.L3286
	movs	r2, #15
.L3284:
	strb	r2, [r3]
.L3216:
	ldr	r3, [r8]
	lsls	r0, r3, #19
	bpl	.L3230
	ldr	r2, .L3289+4
	movw	r1, #3549
	ldr	r0, .L3289+8
	bl	printf
.L3230:
	ldr	r3, .L3289+168
	movs	r2, #0
	strb	r2, [r3]
	ldrb	r2, [r10]	@ zero_extendqisi2
	str	r3, [sp, #4]
	tst	r2, #1
	beq	.L3231
	ldrb	r3, [fp]	@ zero_extendqisi2
	cmp	r3, #155
	beq	.L3232
	movs	r0, #4
	bl	flash_set_interface_mode
	movs	r0, #4
	bl	nandc_set_if_mode
.L3232:
	movs	r0, #1
	bl	flash_set_interface_mode
	movs	r0, #1
.L3285:
	bl	nandc_set_if_mode
	bl	flash_info_blk_init
	cmp	r0, #-1
	mov	fp, r0
	bne	.L3234
	ldr	r3, [r6]
	movs	r2, #17
	movs	r0, #0
	strb	r2, [r3, #32]
	ldr	r3, .L3289+172
	strb	r0, [r3]
	bl	zftl_flash_exit_slc_mode
	b	.L3196
.L3204:
	adds	r6, r6, #1
	adds	r7, r7, #32
	cmp	r6, #49
	bne	.L3206
	b	.L3201
.L3212:
	movs	r3, #3
	b	.L3282
.L3290:
	.align	2
.L3289:
	.word	.LANCHOR14
	.word	.LANCHOR213
	.word	.LC97
	.word	.LANCHOR172
	.word	.LANCHOR32
	.word	.LANCHOR16
	.word	.LANCHOR18
	.word	.LANCHOR33
	.word	.LANCHOR30
	.word	.LANCHOR148
	.word	.LANCHOR48
	.word	.LANCHOR214+1
	.word	.LANCHOR214
	.word	.LANCHOR215
	.word	.LANCHOR28
	.word	.LANCHOR20
	.word	.LANCHOR27
	.word	.LANCHOR176
	.word	.LANCHOR166
	.word	.LANCHOR175
	.word	.LANCHOR168
	.word	.LANCHOR210
	.word	.LANCHOR216
	.word	.LANCHOR49
	.word	.LANCHOR186
	.word	.LANCHOR45
	.word	.LANCHOR84
	.word	.LANCHOR81
	.word	.LANCHOR36
	.word	.LANCHOR124
	.word	.LANCHOR217
	.word	.LANCHOR1
	.word	.LANCHOR82
	.word	.LANCHOR0
	.word	.LANCHOR31
	.word	.LANCHOR37
	.word	.LANCHOR174
	.word	.LANCHOR17
	.word	.LANCHOR19
	.word	.LANCHOR23
	.word	micron_read_retrial
	.word	.LANCHOR169
	.word	.LANCHOR21
	.word	.LANCHOR34
.L3218:
	cmp	r3, #33
	beq	.L3221
	sub	r2, r3, #65
	cmp	r2, #1
	bhi	.L3222
.L3221:
	ldr	r3, .L3291
	movs	r2, #4
	str	r3, [r5]
	ldr	r3, .L3291+4
	strb	r2, [r3]
.L3288:
	movs	r2, #7
.L3287:
	ldr	r3, .L3291+8
	b	.L3284
.L3222:
	sub	r2, r3, #67
	uxtb	r2, r2
	cmp	r2, #1
	bls	.L3223
	sub	r1, r3, #34
	cmp	r1, #1
	bhi	.L3224
.L3223:
	ldr	r1, .L3291
	cmp	r3, #35
	str	r1, [r5]
	ldr	r1, .L3291+8
	beq	.L3225
	cmp	r3, #68
	beq	.L3225
	movs	r3, #7
.L3283:
	cmp	r2, #1
	strb	r3, [r1]
	ldr	r3, .L3291+4
	bhi	.L3227
.L3286:
	movs	r2, #4
	b	.L3284
.L3225:
	movs	r3, #17
	b	.L3283
.L3227:
	movs	r2, #5
	b	.L3284
.L3224:
	sub	r2, r3, #36
	cmp	r2, #1
	bhi	.L3228
	ldr	r3, .L3291+12
	str	r3, [r5]
	b	.L3288
.L3228:
	cmp	r3, #50
	bne	.L3229
	ldr	r3, .L3291+16
	movs	r2, #25
	str	r3, [r5]
	b	.L3287
.L3229:
	cmp	r3, #81
	bne	.L3216
	ldr	r3, .L3291+20
	movs	r2, #7
	str	r3, [r5]
	ldr	r3, .L3291+8
	strb	r2, [r3]
	movs	r2, #0
	ldr	r3, .L3291+24
	b	.L3284
.L3231:
	movs	r0, #4
	b	.L3285
.L3234:
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	cmp	r3, #9
	bne	.L3235
	ldr	r3, [r6]
	ldrb	r3, [r3, #20]	@ zero_extendqisi2
	cmp	r3, #1
	itt	ne
	movne	r3, #0
	strbne	r3, [r7]
.L3235:
	ldr	r3, [sp]
	ldrb	r3, [r3]	@ zero_extendqisi2
	subs	r3, r3, #1
	cmp	r3, #7
	itt	ls
	ldrls	r3, .L3291+28
	strls	r3, [r5]
	ldrb	r3, [r10]	@ zero_extendqisi2
	lsls	r1, r3, #29
	bpl	.L3238
	ldr	r3, [r6]
	ldrb	r3, [r3, #19]	@ zero_extendqisi2
	cbz	r3, .L3238
	ldr	r2, .L3291+32
	movs	r0, #0
	ldr	r3, .L3291+36
	ldrh	r1, [r2]
	ldrb	r3, [r3]	@ zero_extendqisi2
	muls	r1, r3, r1
	bl	flash_ddr_para_scan
	ldr	r3, [sp, #4]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L3238
	ldr	r2, [r6]
	strb	r3, [r2, #19]
	bl	flash_info_flush
.L3238:
	ldr	r3, [r8]
	lsls	r2, r3, #19
	bpl	.L3240
	ldr	r2, .L3291+40
	movw	r1, #3647
	ldr	r0, .L3291+44
	bl	printf
.L3240:
	bl	nand_flash_print_info
	mov	fp, #0
	b	.L3196
.L3292:
	.align	2
.L3291:
	.word	toshiba_read_retrial
	.word	.LANCHOR26
	.word	.LANCHOR169
	.word	toshiba_3d_read_retrial
	.word	samsung_read_retrial
	.word	ymtc_3d_read_retrial
	.word	.LANCHOR51
	.word	hynix_read_retrial
	.word	.LANCHOR2
	.word	.LANCHOR211
	.word	.LANCHOR213
	.word	.LC97
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
.L3294:
	ldr	r3, .L3303
	ldrh	r2, [r3]
	uxth	r3, r6
	cmp	r2, r3
	bhi	.L3296
	ldr	r1, [sp, #44]
	movs	r3, #32
	ldr	r0, .L3303+4
	movs	r2, #4
	add	r1, r1, #704
	bl	rknand_print_hex
	mov	r0, r4
	bl	zbuf_free
	cbz	r5, .L3297
	movw	r2, #1611
	ldr	r1, .L3303+8
	ldr	r0, .L3303+12
	bl	printf
.L3297:
	mov	r0, r5
	add	sp, sp, #48
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3296:
	ldr	r3, .L3303+16
	uxth	r7, r6
	ldr	r2, [r4, #12]
	ldr	r1, [r4, #4]
	ldrh	r8, [r3]
	ldr	r3, .L3303+20
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
	ldr	r0, .L3303+24
	str	r3, [sp, #4]
	mov	r3, r8
	bl	printf
	cmp	r10, #-1
	beq	.L3298
	cmp	r10, #512
	it	eq
	moveq	r5, #1
.L3295:
	adds	r6, r6, #1
	b	.L3294
.L3298:
	movs	r5, #1
	b	.L3295
.L3304:
	.align	2
.L3303:
	.word	.LANCHOR95
	.word	.LC176
	.word	.LANCHOR218
	.word	.LC0
	.word	.LANCHOR111
	.word	.LANCHOR131
	.word	.LC167
	.size	ftl_sysblk_dump, .-ftl_sysblk_dump
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
	mov	r4, r0
	ldr	r5, .L3442
	sub	sp, sp, #224
	str	r1, [sp, #28]
	ldr	r3, [r5]
	lsls	r0, r3, #19
	bpl	.L3306
	ldrh	r1, [r4, #2]
	ldr	r0, .L3442+4
	bl	printf
.L3306:
	ldr	r3, [r5]
	lsls	r1, r3, #19
	bpl	.L3307
	ldrb	r1, [r4, #5]	@ zero_extendqisi2
	ldr	r0, .L3442+8
	bl	printf
.L3307:
	ldr	r3, [r5]
	lsls	r2, r3, #19
	bpl	.L3308
	ldrh	r1, [r4]
	ldr	r0, .L3442+12
	bl	printf
.L3308:
	ldr	r3, [r5]
	lsls	r3, r3, #19
	bpl	.L3309
	ldrh	r2, [r4, #18]
	ldrh	r1, [r4, #16]
	ldr	r0, .L3442+16
	bl	printf
.L3309:
	ldr	r3, [r5]
	lsls	r7, r3, #19
	bpl	.L3310
	ldrb	r1, [r4, #9]	@ zero_extendqisi2
	ldr	r0, .L3442+20
	bl	printf
.L3310:
	ldrh	r3, [r4, #10]
	ldrh	r2, [r4]
	strh	r3, [r4, #14]	@ movhi
	ldr	r3, .L3442+24
	ldrh	r3, [r3]
	cmp	r2, r3
	bcs	.L3305
	movs	r0, #1
	bl	buf_alloc
	ldr	r3, .L3442+28
	movs	r1, #255
	ldr	r2, [r0, #4]
	mov	r5, r0
	add	r0, sp, #32
	ldrb	r3, [r3]	@ zero_extendqisi2
	subs	r3, r3, #2
	add	r3, r2, r3, lsl #9
	movs	r2, #64
	str	r3, [sp, #24]
	bl	ftl_memset
	movs	r2, #64
	movs	r1, #255
	add	r0, sp, #96
	bl	ftl_memset
	movs	r2, #64
	movs	r1, #255
	add	r0, sp, #160
	bl	ftl_memset
	ldrh	r3, [r4, #2]
	ldrb	fp, [r4, #5]	@ zero_extendqisi2
	str	r3, [sp, #8]
	movs	r3, #2
	str	r3, [sp, #12]
	movs	r3, #0
	str	r3, [sp, #20]
.L3312:
	ldr	r3, .L3442+32
	ldr	r2, [sp, #8]
	ldrh	r3, [r3]
	cmp	r3, r2
	bhi	.L3327
.L3315:
	ldrh	r3, [sp, #8]
	ldr	r1, .L3442+32
	ldrh	r2, [r4, #6]
	strh	r3, [r4, #2]	@ movhi
	ldrh	r3, [r4, #10]
	ldrb	r0, [r4, #9]	@ zero_extendqisi2
	strb	fp, [r4, #5]
	add	r2, r2, r3
	ldrh	r3, [r1]
	str	r1, [sp, #8]
	muls	r3, r0, r3
	cmp	r2, r3
	beq	.L3328
	movw	r2, #1794
	ldr	r1, .L3442+36
	ldr	r0, .L3442+40
	bl	printf
.L3328:
	ldr	r3, .L3442+44
	movs	r6, #0
	ldrh	r0, [r4, #10]
	mov	r2, r6
	ldr	r7, [r3]
	str	r3, [sp, #16]
.L3329:
	cmp	r2, r0
	bcc	.L3331
	ldr	r2, [sp, #8]
	ldrb	r3, [r4, #9]	@ zero_extendqisi2
	ldr	r7, .L3442
	ldrh	r2, [r2]
	ldr	r8, .L3442+60
	smulbb	r3, r3, r2
	subs	r3, r3, r0
	add	r6, r6, r3
	ldr	r3, [r7]
	uxth	r6, r6
	tst	r3, #4096
	beq	.L3332
	ldrh	r1, [r4]
	mov	r2, r6
	ldr	r3, [r8]
	ldr	r0, .L3442+48
	ldrh	r3, [r3, r1, lsl #1]
	bl	printf
.L3332:
	ldr	r3, [r8]
	ldrh	r2, [r4]
	strh	r6, [r3, r2, lsl #1]	@ movhi
	ldr	r3, [r7]
	lsls	r7, r3, #17
	bpl	.L3333
	ldr	r3, [sp, #44]
	add	r1, sp, #32
	ldr	r0, .L3442+52
	str	r3, [sp]
	ldm	r1, {r1, r2, r3}
	bl	printf
.L3333:
	ldr	r6, .L3442+28
	movs	r7, #0
	ldr	r8, .L3442+56
	movs	r1, #0
	ldr	r0, [r5, #4]
	ldrb	r2, [r6]	@ zero_extendqisi2
	lsls	r2, r2, #9
	bl	ftl_memset
	str	r6, [sp, #24]
.L3334:
	ldrb	r3, [r8]	@ zero_extendqisi2
	ldr	r2, [sp, #12]
	muls	r3, r2, r3
	cmp	r7, r3
	bcc	.L3348
	ldr	r7, .L3442+28
	movs	r6, #0
.L3349:
	ldr	r3, .L3442+56
	ldr	r2, [sp, #12]
	ldrb	r3, [r3]	@ zero_extendqisi2
	muls	r3, r2, r3
	cmp	r6, r3
	bcc	.L3356
	mov	r0, r5
	bl	zbuf_free
	ldr	r3, [sp, #8]
	ldrh	r2, [r4, #12]
	ldrb	r1, [r4, #9]	@ zero_extendqisi2
	ldrh	r3, [r3]
	mla	r3, r1, r3, r2
	ldr	r2, [sp, #16]
	ldr	r2, [r2]
	add	r3, r3, #1073741824
	subs	r3, r3, #1
	ldr	r3, [r2, r3, lsl #2]
	adds	r3, r3, #1
	beq	.L3357
	movw	r2, #1909
	ldr	r1, .L3442+36
	ldr	r0, .L3442+40
	bl	printf
.L3357:
	ldrh	r3, [r4, #6]
	cmp	r3, #1
	bne	.L3305
	mov	r0, r4
	bl	ftl_write_last_log_page
.L3305:
	add	sp, sp, #224
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3327:
	ldrb	fp, [r4, #5]	@ zero_extendqisi2
.L3313:
	ldrb	r3, [r4, #9]	@ zero_extendqisi2
	cmp	r3, fp
	bhi	.L3326
	movs	r3, #0
	strb	r3, [r4, #5]
	ldr	r3, [sp, #8]
	adds	r3, r3, #1
	uxth	r3, r3
	str	r3, [sp, #8]
	b	.L3312
.L3443:
	.align	2
.L3442:
	.word	.LANCHOR14
	.word	.LC177
	.word	.LC178
	.word	.LC179
	.word	.LC180
	.word	.LC181
	.word	.LANCHOR6
	.word	.LANCHOR131
	.word	.LANCHOR95
	.word	.LANCHOR219
	.word	.LC0
	.word	.LANCHOR117
	.word	.LC184
	.word	.LC185
	.word	.LANCHOR80
	.word	.LANCHOR9
.L3326:
	add	r3, fp, #8
	ldrh	r7, [r4, r3, lsl #1]
	movw	r3, #65535
	cmp	r7, r3
	beq	.L3314
	ldr	r3, .L3444
	ldr	r2, [sp, #8]
	ldr	r6, .L3444+4
	ldrh	r3, [r3]
	ldr	r1, [r5, #4]
	mla	r3, r7, r3, r2
	ldr	r2, [r5, #12]
	str	r3, [sp, #16]
	ldr	r0, [sp, #16]
	ldrb	r3, [r6]	@ zero_extendqisi2
	bl	ftl_read_ppa_page
	cmp	r0, #512
	mov	r8, r0
	beq	.L3315
	cmp	r0, #-1
	beq	.L3316
	ldr	r3, [r5, #12]
	ldr	r2, [r3]
	adds	r2, r2, #1
	bne	.L3316
	ldr	r3, [r3, #4]
	adds	r3, r3, #1
	bne	.L3316
	ldr	r3, [r5, #4]
	ldr	r3, [r3]
	adds	r3, r3, #1
	beq	.L3315
.L3316:
	ldr	r3, .L3444+8
	movs	r2, #1
	ldr	r1, [sp, #8]
	strb	r2, [r3]
	ldrb	r3, [r4, #9]	@ zero_extendqisi2
	ldrh	r2, [r4, #10]
	mla	r3, r1, r3, fp
	cmp	r2, r3
	beq	.L3317
	movw	r2, #1686
	ldr	r1, .L3444+12
	ldr	r0, .L3444+16
	bl	printf
.L3317:
	ldrh	r3, [r4, #10]
	ldrh	r2, [r4, #6]
	add	r2, r2, r3
	ldr	r3, .L3444+20
	ldrh	r1, [r3]
	ldrb	r3, [r4, #9]	@ zero_extendqisi2
	muls	r3, r1, r3
	cmp	r2, r3
	beq	.L3318
	movw	r2, #1687
	ldr	r1, .L3444+12
	ldr	r0, .L3444+16
	bl	printf
.L3318:
	ldrb	r3, [r6]	@ zero_extendqisi2
	cmp	r3, #8
	bls	.L3319
	ldr	r10, [r5, #12]
	ldr	r2, .L3444+24
	ldr	r3, [r10]
	cmp	r3, r2
	beq	.L3319
	cmp	r8, #-1
	beq	.L3321
	ldr	r3, [r10, #4]
	adds	r3, r3, #1
	beq	.L3322
	ldr	r3, [r10, #16]
	add	r2, r2, #1392508928
	sub	r2, r2, #1957888
	subw	r2, r2, #2427
	cmp	r3, r2
	bne	.L3322
	mov	r1, #1024
	ldr	r0, [sp, #24]
	bl	js_hash
	ldr	r3, [r10, #20]
	cmp	r3, r0
	beq	.L3322
	str	r0, [sp, #4]
	mov	r1, r7
	ldr	r3, [sp, #16]
	ldr	r2, [sp, #8]
	str	r8, [sp]
	ldr	r0, .L3444+28
	bl	printf
	movs	r3, #16
	movs	r2, #4
	ldr	r1, [sp, #24]
	ldr	r0, .L3444+32
	bl	rknand_print_hex
	ldrb	r3, [r6]	@ zero_extendqisi2
	movs	r2, #4
	ldr	r1, [r5, #12]
	ldr	r0, .L3444+36
	lsrs	r3, r3, #1
	bl	rknand_print_hex
.L3321:
	ldrh	r3, [r4, #6]
	subs	r3, r3, #1
	strh	r3, [r4, #6]	@ movhi
	ldrh	r3, [r4, #10]
	adds	r3, r3, #1
	strh	r3, [r4, #10]	@ movhi
	movs	r3, #4
	str	r3, [sp, #12]
	movs	r3, #1
	str	r3, [sp, #20]
.L3314:
	add	r3, fp, #1
	uxth	fp, r3
	b	.L3313
.L3319:
	cmp	r8, #-1
	beq	.L3321
.L3322:
	ldr	r3, [r5, #12]
	ldr	r0, [r3, #4]
	adds	r6, r0, #1
	beq	.L3321
	ldr	r3, [r3]
	ldr	r2, .L3444+24
	cmp	r3, r2
	beq	.L3321
	bl	lpa_hash_get_ppa
	ldr	r3, [sp, #28]
	mov	r7, r0
	cmp	r3, #0
	beq	.L3324
	ldr	r10, [r5, #12]
	ldr	r3, [r10, #8]
	cmp	r0, r3
	beq	.L3324
	adds	r1, r0, #1
	beq	.L3324
	ldr	r3, .L3444+40
	movs	r6, #1
	ldr	r8, .L3444+60
	ldrh	r0, [r3]
	ldr	r3, .L3444+44
	ldrb	r1, [r8]	@ zero_extendqisi2
	ldrb	r3, [r3]	@ zero_extendqisi2
	rsb	r3, r3, #24
	subs	r3, r3, r0
	lsr	r0, r7, r0
	lsl	r3, r6, r3
	subs	r3, r3, #1
	ands	r0, r0, r3
	bl	__aeabi_uidiv
	ldr	r3, [sp, #28]
	uxth	r0, r0
	ldrh	r3, [r3]
	cmp	r3, r0
	bne	.L3324
	ldr	r3, [r10]
	mov	r0, r7
	ldr	r10, .L3444+64
	ldr	r1, [r5, #4]
	str	r3, [sp, #12]
	ldr	r3, .L3444+4
	mov	r2, r10
	ldrb	r3, [r3]	@ zero_extendqisi2
	bl	ftl_read_ppa_page
	ldr	r3, [r10]
	ldr	r2, [sp, #12]
	cmp	r2, r3
	bhi	.L3324
	ldr	r3, [r5, #12]
	ldr	r3, [r3, #8]
	adds	r2, r3, #1
	beq	.L3321
	ldr	r1, .L3444+44
	ldr	r2, .L3444+40
	ldrb	r0, [r1]	@ zero_extendqisi2
	ldrh	r2, [r2]
	ldrb	r1, [r8]	@ zero_extendqisi2
	rsb	r0, r0, #24
	subs	r0, r0, r2
	lsls	r6, r6, r0
	lsr	r0, r3, r2
	subs	r6, r6, #1
	ands	r0, r0, r6
	bl	__aeabi_uidiv
	uxth	r0, r0
	bl	ftl_vpn_decrement
	b	.L3321
.L3331:
	ldrh	r1, [r4, #12]
	add	r1, r1, r2
	adds	r2, r2, #1
	ldr	r3, [r7, r1, lsl #2]
	adds	r3, r3, #1
	itt	ne
	addne	r6, r6, #1
	uxthne	r6, r6
	b	.L3329
.L3348:
	add	fp, sp, #32
	ldr	r0, [fp, r7, lsl #2]
	adds	r6, r0, #1
	bne	.L3335
.L3341:
	ldr	r2, .L3444+48
	mov	r6, #-1
	ldr	r3, [r5, #12]
	ldr	r1, [r5, #4]
	ldr	r2, [r2]
	ldr	r2, [r2, #8]
	str	r6, [r3, #4]
	str	r6, [r3, #8]
	str	r2, [r3]
	movs	r2, #0
	str	r2, [r3, #12]
	str	r2, [r3, #16]
	str	r2, [r1]
	ldr	r1, .L3444+4
	ldrb	r1, [r1]	@ zero_extendqisi2
	cmp	r1, #8
	bhi	.L3336
.L3337:
	ldr	r3, [sp, #20]
	cmp	r3, #0
	beq	.L3343
	ldrh	r3, [r4, #6]
	cmp	r3, #1
	bls	.L3343
	ldr	fp, .L3444+56
.L3413:
	mov	r0, r4
	bl	ftl_get_new_free_page
	ldr	r3, [fp]
	mov	r10, r0
	lsls	r3, r3, #17
	bpl	.L3345
	ldrh	r2, [r4, #12]
	mov	r1, r0
	ldrh	r3, [r4, #10]
	ldr	r0, .L3444+52
	add	r3, r3, r2
	ldr	r2, [r5, #12]
	subs	r3, r3, #1
	ldr	r2, [r2, #4]
	bl	printf
.L3345:
	ldrb	r3, [r8]	@ zero_extendqisi2
	ldr	r1, [sp, #12]
	ldrh	r2, [r4, #6]
	muls	r3, r1, r3
	adds	r3, r3, #1
	subs	r3, r3, r7
	cmp	r2, r3
	bls	.L3343
	ldr	r3, .L3444+4
	mov	r0, r10
	ldr	r2, [r5, #12]
	ldr	r1, [r5, #4]
	ldrb	r3, [r3]	@ zero_extendqisi2
	bl	ftl_prog_ppa_page
	str	r0, [sp, #28]
	ldrh	r0, [r4]
	bl	ftl_vpn_decrement
	adds	r0, r6, #1
	beq	.L3346
	ldr	r3, [sp, #28]
	adds	r3, r3, #1
	beq	.L3346
	add	r3, sp, #96
	ldrh	r2, [r4, #12]
	str	r10, [r3, r7, lsl #2]
	ldrh	r3, [r4, #10]
	add	r3, r3, r2
	add	r2, sp, #160
	subs	r3, r3, #1
	str	r3, [r2, r7, lsl #2]
.L3343:
	adds	r7, r7, #1
	b	.L3334
.L3445:
	.align	2
.L3444:
	.word	.LANCHOR111
	.word	.LANCHOR131
	.word	.LANCHOR198
	.word	.LANCHOR219
	.word	.LC0
	.word	.LANCHOR95
	.word	-178307901
	.word	.LC182
	.word	.LC183
	.word	.LC150
	.word	.LANCHOR75
	.word	.LANCHOR32
	.word	.LANCHOR110
	.word	.LC187
	.word	.LANCHOR14
	.word	.LANCHOR76
	.word	.LANCHOR193
.L3335:
	ldr	r3, [sp, #24]
	ldr	r1, [r5, #4]
	ldr	r2, [r5, #12]
	ldrb	r3, [r3]	@ zero_extendqisi2
	bl	ftl_read_ppa_page
	ldr	r3, [r5, #12]
	mov	r6, r0
	ldr	r0, [r3, #4]
	bl	lpa_hash_get_ppa
	ldr	r3, .L3446
	mov	r10, r0
	ldr	r3, [r3]
	lsls	r1, r3, #17
	bpl	.L3338
	ldr	r3, [r5, #12]
	mov	r1, r0
	ldr	r2, [fp, r7, lsl #2]
	ldr	r0, .L3446+4
	ldr	r3, [r3, #4]
	bl	printf
.L3338:
	add	r3, sp, #32
	ldr	r1, .L3446+8
	ldr	r3, [r3, r7, lsl #2]
	movs	r2, #1
	ldrb	r1, [r1]	@ zero_extendqisi2
	cmp	r10, r3
	it	ne
	movne	r6, #-1
	ldr	r3, [r5, #12]
	cmp	r1, #8
	str	r2, [r3, #12]
	mov	r2, #0
	str	r2, [r3, #16]
	it	hi
	strhi	r2, [r3, #20]
	adds	r2, r6, #1
	str	r10, [r3, #8]
	bne	.L3337
	b	.L3341
.L3336:
	str	r2, [r3, #16]
	str	r2, [r3, #20]
	b	.L3337
.L3346:
	ldrh	r3, [r4, #6]
	cmp	r3, #1
	bls	.L3343
	adds	r1, r6, #1
	bne	.L3413
	b	.L3343
.L3356:
	add	r8, sp, #96
	ldr	r3, [r8, r6, lsl #2]
	adds	r3, r3, #1
	beq	.L3351
	add	r0, sp, #32
	ldr	r2, [r5, #12]
	ldrb	r3, [r7]	@ zero_extendqisi2
	ldr	r1, [r5, #4]
	ldr	r0, [r0, r6, lsl #2]
	bl	ftl_read_ppa_page
	adds	r2, r0, #1
	beq	.L3352
	cmp	r0, #256
	bne	.L3351
.L3352:
	ldr	r0, [r8, r6, lsl #2]
	ldr	r8, .L3446
	ldrb	r3, [r7]	@ zero_extendqisi2
	ldr	r2, [r5, #12]
	ldr	r1, [r5, #4]
	bl	ftl_read_ppa_page
	ldr	r3, [r8]
	mov	r10, r0
	lsls	r3, r3, #17
	bpl	.L3354
	ldr	r2, [r5, #12]
	add	r3, sp, #32
	mov	r1, r0
	ldr	r3, [r3, r6, lsl #2]
	ldr	r0, .L3446+12
	ldr	r2, [r2, #8]
	bl	printf
.L3354:
	cmp	r10, #-1
	beq	.L3351
	ldr	r1, [r5, #12]
	add	r3, sp, #32
	ldr	r2, [r3, r6, lsl #2]
	ldr	r3, [r1, #8]
	cmp	r2, r3
	bne	.L3351
	ldr	r3, [r8]
	add	r8, sp, #160
	tst	r3, #16384
	beq	.L3355
	ldr	r3, [r8, r6, lsl #2]
	ldr	r1, [r1, #4]
	ldr	r0, .L3446+16
	bl	printf
.L3355:
	ldr	r3, [r5, #12]
	ldrh	r2, [r8, r6, lsl #2]
	ldr	r1, [r3, #8]
	ldr	r0, [r3, #4]
	bl	lpa_hash_update_ppa
.L3351:
	adds	r6, r6, #1
	b	.L3349
.L3324:
	ldr	r0, [r5, #12]
	ldr	r3, .L3446+20
	ldr	r2, [r0, #4]
	ldr	r3, [r3]
	cmp	r2, r3
	bcs	.L3321
	ldr	r3, .L3446+24
	ldrb	r1, [r4, #9]	@ zero_extendqisi2
	ldrh	r2, [r4, #10]
	ldrh	r3, [r3]
	muls	r3, r1, r3
	subs	r3, r3, #1
	cmp	r2, r3
	bge	.L3321
	ldr	r3, .L3446+28
	ldr	r6, [r0]
	ldr	r3, [r3]
	ldr	r1, [r3, #8]
	cmp	r6, r1
	it	hi
	strhi	r6, [r3, #8]
	ldrh	r3, [r4, #12]
	ldr	r1, [r0, #8]
	ldr	r0, [r0, #4]
	add	r2, r2, r3
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
	b	.L3321
.L3447:
	.align	2
.L3446:
	.word	.LANCHOR14
	.word	.LC186
	.word	.LANCHOR131
	.word	.LC187
	.word	.LC188
	.word	.LANCHOR128
	.word	.LANCHOR95
	.word	.LANCHOR110
	.size	ftl_open_sblk_recovery, .-ftl_open_sblk_recovery
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
	ldr	r3, .L3449
	push	{r0, r1, r2, r4, r5, r6, r7, lr}
	ldr	r0, .L3449+4
	ldrb	r1, [r3]	@ zero_extendqisi2
	bl	printf
	ldr	r1, .L3449+8
	ldr	r5, .L3449+12
	ldr	r0, .L3449+16
	ldrh	r3, [r1, #2]
	ldrb	r2, [r1, #1]	@ zero_extendqisi2
	ldrb	r1, [r1]	@ zero_extendqisi2
	bl	printf
	ldr	r3, [r5]
	ldr	r4, .L3449+20
	ldr	r0, .L3449+24
	ldrh	r2, [r3, #140]
	ldrh	r1, [r3, #130]
	bl	printf
	ldr	r0, [r4]
	ldr	r7, .L3449+28
	ldrh	r6, [r0, #26]
	ldrb	r3, [r0, #21]	@ zero_extendqisi2
	ldrh	r2, [r0, #18]
	ldrh	r1, [r0, #16]
	str	r6, [sp, #4]
	ldrh	r0, [r0, #22]
	str	r0, [sp]
	ldr	r0, .L3449+32
	bl	printf
	ldr	r0, [r4]
	ldrh	r6, [r0, #58]
	ldrb	r3, [r0, #53]	@ zero_extendqisi2
	ldrh	r2, [r0, #50]
	ldrh	r1, [r0, #48]
	str	r6, [sp, #4]
	ldrh	r0, [r0, #54]
	ldr	r6, .L3449+36
	str	r0, [sp]
	ldr	r0, .L3449+40
	bl	printf
	ldr	r0, [r4]
	ldrh	r4, [r0, #90]
	ldrb	r3, [r0, #85]	@ zero_extendqisi2
	ldrh	r2, [r0, #82]
	ldrh	r1, [r0, #80]
	str	r4, [sp, #4]
	ldrh	r0, [r0, #86]
	ldr	r4, .L3449+44
	str	r0, [sp]
	ldr	r0, .L3449+48
	bl	printf
	ldrh	r2, [r6]
	ldrb	r3, [r4]	@ zero_extendqisi2
	ldr	r1, .L3449+52
	ldr	r0, .L3449+56
	muls	r3, r2, r3
	ldr	r1, [r1]
	movs	r2, #4
	lsls	r3, r3, #1
	bl	rknand_print_hex
	ldr	r1, .L3449+60
	movs	r2, #2
	ldrh	r3, [r7]
	ldr	r0, .L3449+64
	ldr	r1, [r1]
	bl	rknand_print_hex
	ldr	r1, [r5]
	movs	r2, #4
	ldr	r0, .L3449+68
	ldrh	r3, [r1, #698]
	add	r1, r1, #704
	bl	rknand_print_hex
	ldr	r1, .L3449+72
	movs	r2, #4
	ldrh	r3, [r7]
	ldr	r0, .L3449+76
	ldr	r1, [r1]
	bl	rknand_print_hex
	mov	r3, #256
	movs	r2, #2
	ldr	r1, .L3449+80
	ldr	r0, .L3449+84
	bl	rknand_print_hex
	ldrh	r2, [r6]
	ldrb	r3, [r4]	@ zero_extendqisi2
	ldr	r1, .L3449+88
	ldr	r0, .L3449+92
	muls	r3, r2, r3
	ldr	r1, [r1]
	movs	r2, #2
	lsls	r3, r3, #1
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, lr}
	b	rknand_print_hex
.L3450:
	.align	2
.L3449:
	.word	.LANCHOR58
	.word	.LC189
	.word	.LANCHOR194
	.word	.LANCHOR110
	.word	.LC190
	.word	.LANCHOR10
	.word	.LC191
	.word	.LANCHOR6
	.word	.LC192
	.word	.LANCHOR95
	.word	.LC193
	.word	.LANCHOR80
	.word	.LC194
	.word	.LANCHOR117
	.word	.LC195
	.word	.LANCHOR9
	.word	.LC196
	.word	.LC176
	.word	.LANCHOR7
	.word	.LC197
	.word	.LANCHOR116
	.word	.LC198
	.word	.LANCHOR118
	.word	.LC199
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
	ldr	r2, .L3458
	mov	r5, r0
	mov	r6, r1
	ldr	r3, .L3458+4
	ldrb	r4, [r2]	@ zero_extendqisi2
	ldrh	r3, [r3]
	rsb	r4, r4, #24
	subs	r0, r4, r3
	movs	r4, #1
	lsls	r4, r4, r0
	lsr	r0, r7, r3
	ldr	r3, .L3458+8
	subs	r4, r4, #1
	ands	r0, r0, r4
	ldrb	r1, [r3]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	ldr	r3, .L3458+12
	uxth	r0, r0
	ldr	r3, [r3]
	add	r0, r3, r0, lsl #2
	ldrb	r3, [r0, #2]	@ zero_extendqisi2
	lsrs	r3, r3, #5
	cmp	r3, #1
	beq	.L3452
	cmp	r3, #7
	bne	.L3454
.L3452:
	mov	r3, r7
	mov	r2, r6
	mov	r1, r5
	ldr	r0, .L3458+16
	bl	printf
	bl	dump_ftl_info
	mov	r0, #-1
	pop	{r3, r4, r5, r6, r7, pc}
.L3454:
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, pc}
.L3459:
	.align	2
.L3458:
	.word	.LANCHOR32
	.word	.LANCHOR75
	.word	.LANCHOR76
	.word	.LANCHOR7
	.word	.LC200
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
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r5, r0
	mov	r7, r1
	bls	.L3461
	movs	r2, #32
	ldr	r1, .L3484
	ldr	r0, .L3484+4
	bl	printf
.L3461:
	ldr	r6, .L3484+8
	ldr	r3, [r6]
	mov	r10, r6
	ldrh	r2, [r3, #698]
	cmp	r2, r5
	bcs	.L3462
	mov	r1, r5
	ldr	r0, .L3484+12
	bl	printf
	ldr	r3, .L3484+16
	movs	r4, #0
	movs	r1, #255
	ldr	r0, [r4, #4]
	ldrh	r2, [r3]
	bl	ftl_memset
	ldr	r3, [r6]
	ldrh	r3, [r3, #698]
	cmp	r3, r5
	bcc	.L3463
.L3482:
	movs	r0, #0
.L3460:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3463:
	movs	r2, #37
.L3483:
	ldr	r1, .L3484
	ldr	r0, .L3484+4
	bl	printf
	b	.L3482
.L3462:
	ldr	r6, .L3484+20
	add	r2, r5, #176
	ldr	r4, [r3, r2, lsl #2]
	movs	r3, #0
	strh	r5, [r6, r7, lsl #3]	@ movhi
	lsls	r7, r7, #3
	add	fp, r6, r7
	strh	r3, [fp, #2]	@ movhi
	cbnz	r4, .L3465
	mov	r2, r4
	mov	r1, r5
	ldr	r0, .L3484+24
	bl	printf
	ldr	r3, .L3484+16
	movs	r1, #255
	ldr	r0, [fp, #4]
	ldrh	r2, [r3]
	bl	ftl_memset
	b	.L3482
.L3465:
	ldr	r8, .L3484+32
	mov	r0, r4
	ldr	r3, .L3484+28
	ldr	r1, [fp, #4]
	ldr	r2, [r8]
	ldrb	r3, [r3]	@ zero_extendqisi2
	bl	ftl_read_ppa_page
	ldr	r2, [r8]
	mov	r3, r0
	ldr	r2, [r2]
	cmp	r2, r5
	bne	.L3466
	adds	r1, r0, #1
	beq	.L3466
	cmp	r0, #512
	beq	.L3466
.L3471:
	ldr	r3, .L3484+32
	ldr	r3, [r3]
	ldr	r3, [r3]
	cmp	r5, r3
	beq	.L3482
	movs	r2, #73
	b	.L3483
.L3466:
	mov	r1, r5
	str	r4, [sp]
	ldr	r0, .L3484+36
	add	r8, r6, r7
	bl	printf
	ldr	r1, [r10]
	movs	r2, #4
	ldr	r10, .L3484+28
	ldr	r0, .L3484+40
	ldrh	r3, [r1, #698]
	add	r1, r1, #704
	bl	rknand_print_hex
	ldrb	r3, [r10]	@ zero_extendqisi2
	movs	r2, #4
	ldr	fp, .L3484+32
	ldr	r1, [r8, #4]
	ldr	r0, .L3484+44
	lsls	r3, r3, #7
	bl	rknand_print_hex
	movs	r3, #16
	movs	r2, #4
	ldr	r1, [fp]
	ldr	r0, .L3484+48
	bl	rknand_print_hex
	ldrb	r3, [r10]	@ zero_extendqisi2
	mov	r0, r4
	ldr	r2, [fp]
	ldr	r1, [r8, #4]
	bl	ftl_read_ppa_page
	adds	r3, r0, #1
	beq	.L3469
	cmp	r0, #512
	bne	.L3470
.L3469:
	ldr	r3, .L3484+16
	add	r6, r6, r7
	movs	r1, #255
	ldr	r0, [r6, #4]
	ldrh	r2, [r3]
	bl	ftl_memset
.L3472:
	mov	r0, #-1
	b	.L3460
.L3470:
	ldr	r3, [fp]
	ldr	r3, [r3]
	cmp	r5, r3
	beq	.L3471
	b	.L3472
.L3485:
	.align	2
.L3484:
	.word	.LANCHOR220
	.word	.LC0
	.word	.LANCHOR110
	.word	.LC201
	.word	.LANCHOR221
	.word	.LANCHOR138
	.word	.LC202
	.word	.LANCHOR131
	.word	.LANCHOR207
	.word	.LC203
	.word	.LC204
	.word	.LC183
	.word	.LC205
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
	ldr	r4, .L3503
	ldr	r5, .L3503+4
	ldr	r3, [r4]
	ldr	r6, .L3503+8
	ldrh	r2, [r5]
	ldrh	r1, [r3, #688]
	subs	r2, r2, #1
	cmp	r1, r2
	bge	.L3487
	ldr	r3, [r6]
	cmp	r3, #0
	beq	.L3488
.L3487:
	bl	pm_free_sblk
	ldr	r2, [r4]
	ldrh	r3, [r5]
	ldrh	r1, [r2, #688]
	subs	r3, r3, #1
	cmp	r1, r3
	bge	.L3489
	ldr	r3, [r6]
	cmp	r3, #0
	beq	.L3488
.L3489:
	uxth	r0, r0
	movw	r5, #65535
	movs	r3, #0
	adds	r0, r0, #208
	str	r3, [r6]
	ldrh	r8, [r2, r0, lsl #1]
	cmp	r8, r5
	bne	.L3491
	movs	r2, #182
	ldr	r1, .L3503+12
	ldr	r0, .L3503+16
	bl	printf
	bl	pm_free_sblk
	ldr	r3, [r4]
	uxth	r0, r0
	adds	r0, r0, #208
	ldrh	r8, [r3, r0, lsl #1]
	cmp	r8, r5
	beq	.L3488
.L3491:
	ldr	r5, .L3503+20
	bl	pm_select_ram_region
	mov	r6, r0
	movw	r3, #65535
	ldrh	r0, [r5, r0, lsl #3]
	cmp	r0, r3
	beq	.L3492
	add	r7, r5, r6, lsl #3
	ldr	r1, [r7, #4]
	cbz	r1, .L3492
	ldrsh	r3, [r7, #2]
	cmp	r3, #0
	bge	.L3492
	bl	pm_write_page
	ldrh	r3, [r7, #2]
	ubfx	r3, r3, #0, #15
	strh	r3, [r7, #2]	@ movhi
.L3492:
	movs	r7, #0
.L3493:
	ldr	r1, [r4]
	uxth	fp, r7
	ldrh	r3, [r1, #698]
	cmp	r3, fp
	bhi	.L3496
	bl	pm_free_sblk
.L3488:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3496:
	ldr	r3, .L3503+24
	uxth	r10, r7
	mov	ip, #1
	ldrh	r0, [r3]
	ldr	r3, .L3503+28
	ldrb	r3, [r3]	@ zero_extendqisi2
	rsb	r3, r3, #24
	subs	r3, r3, r0
	lsl	r3, ip, r3
	add	ip, r10, #176
	ldr	r1, [r1, ip, lsl #2]
	subs	r3, r3, #1
	lsr	r0, r1, r0
	ldr	r1, .L3503+32
	ands	r0, r0, r3
	ldrb	r1, [r1]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	uxth	r0, r0
	cmp	r8, r0
	bne	.L3494
	mov	r1, r6
	mov	r0, fp
	bl	load_l2p_region
	cbnz	r0, .L3495
	add	r3, r5, r6, lsl #3
	mov	r0, r10
	ldr	r1, [r3, #4]
	bl	pm_write_page
.L3495:
	movw	r3, #65535
	strh	r3, [r5, r6, lsl #3]	@ movhi
.L3494:
	adds	r7, r7, #1
	b	.L3493
.L3504:
	.align	2
.L3503:
	.word	.LANCHOR110
	.word	.LANCHOR155
	.word	.LANCHOR151
	.word	.LANCHOR222
	.word	.LC0
	.word	.LANCHOR138
	.word	.LANCHOR75
	.word	.LANCHOR32
	.word	.LANCHOR76
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
	ldr	r3, .L3510
	push	{r4, lr}
	add	r4, r3, r0, lsl #3
	ldrh	r0, [r3, r0, lsl #3]
	ldr	r1, [r4, #4]
	bl	pm_write_page
	ldrh	r3, [r4, #2]
	ubfx	r3, r3, #0, #15
	strh	r3, [r4, #2]	@ movhi
	ldr	r4, .L3510+4
	ldr	r3, [r4]
	cbz	r3, .L3506
	bl	pm_gc
	movs	r3, #0
	str	r3, [r4]
.L3506:
	movs	r0, #0
	pop	{r4, pc}
.L3511:
	.align	2
.L3510:
	.word	.LANCHOR138
	.word	.LANCHOR136
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
	ldr	r5, .L3516
.L3514:
	add	r3, r5, r4, lsl #3
	uxth	r0, r4
	ldrsh	r3, [r3, #2]
	cmp	r3, #0
	bge	.L3513
	bl	pm_flush_id
.L3513:
	adds	r4, r4, #1
	cmp	r4, #32
	bne	.L3514
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L3517:
	.align	2
.L3516:
	.word	.LANCHOR138
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
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L3546
	movs	r2, #1
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r4, #0
	sub	sp, sp, #24
	mov	r8, r0
	movs	r0, #64
	str	r4, [r3]
	ldr	r3, .L3546+4
	ldr	r6, .L3546+8
	str	r4, [r3]
	ldr	r3, .L3546+12
	mov	r5, r6
	strb	r2, [r3]
	bl	ftl_malloc
	ldr	r3, .L3546+16
	mov	r10, r3
	str	r0, [r3]
.L3523:
	movw	r3, #65535
	adds	r7, r6, r4
	strh	r3, [r4, r6]	@ movhi
	movs	r3, #0
	strh	r3, [r7, #2]	@ movhi
	cmp	r8, #0
	beq	.L3522
	ldr	r3, .L3546+20
	ldrb	r0, [r3]	@ zero_extendqisi2
	lsls	r0, r0, #9
	bl	ftl_malloc
	str	r0, [r7, #4]
.L3522:
	adds	r4, r4, #8
	cmp	r4, #256
	bne	.L3523
	ldr	r4, .L3546+24
	ldr	fp, [r5, #4]
	ldr	r8, [r10]
	ldr	r3, [r4]
	mov	r2, fp
	ldrh	r1, [r3, #692]
	ldrb	r0, [r3, #694]	@ zero_extendqisi2
	movs	r3, #4
	str	r3, [sp]
	mov	r3, r8
	bl	flash_get_last_written_page
	ldr	r1, [r4]
	mov	r6, r0
	ldrh	r2, [r1, #696]
	cmp	r2, r0
	bgt	.L3524
	mov	r3, r0
	ldrh	r1, [r1, #692]
	ldr	r0, .L3546+28
	bl	printf
	ldr	r3, [r4]
	ldrsh	r7, [r3, #696]
.L3525:
	cmp	r7, r6
	ble	.L3528
	ldr	r3, .L3546+32
	movs	r2, #1
	add	r6, r6, r2
	strb	r2, [r3]
	ldr	r3, [r4]
	strh	r6, [r3, #696]	@ movhi
	bl	pm_free_sblk
.L3524:
	ldr	r3, .L3546+36
	movs	r1, #255
	ldr	r0, [r5, #4]
	ldrh	r2, [r3]
	bl	ftl_memset
	ldr	r1, [r5, #4]
	mov	r0, #-1
	bl	pm_write_page
	ldr	r3, .L3546+32
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L3529
	ldr	r1, [r5, #4]
	mov	r0, #-1
	bl	pm_write_page
	ldr	r1, [r5, #4]
	mov	r0, #-1
	bl	pm_write_page
	ldr	r1, [r5, #4]
	mov	r0, #-1
	bl	pm_write_page
.L3529:
	bl	pm_free_sblk
	bl	pm_gc
	movs	r0, #0
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3528:
	ldr	r3, [r4]
	ldr	r1, .L3546+40
	ldrh	r2, [r3, #692]
	ldrh	r1, [r1]
	ldrb	r0, [r3, #694]	@ zero_extendqisi2
	ldr	r3, .L3546+20
	mla	r2, r1, r2, r7
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r2, [sp, #12]
	mov	r2, fp
	str	r3, [sp]
	mov	r3, r8
	ldr	r1, [sp, #12]
	bl	flash_read_page_en
	ldr	r3, [r4]
	mov	r10, r0
	ldr	r0, .L3546+44
	ldr	r2, [r3, #48]
	adds	r2, r2, #1
	str	r2, [r3, #48]
	ldrh	r3, [r3, #694]
	ldr	r2, [sp, #12]
	ldr	r1, [r8]
	bl	printf
	cmp	r10, #-1
	beq	.L3526
	cmp	r10, #512
	beq	.L3526
	ldr	r2, [r4]
	ldr	r10, [r8]
	ldrh	r3, [r2, #698]
	cmp	r10, r3
	bcs	.L3526
	ldr	r3, [r8, #8]
	str	r3, [sp, #20]
	cbz	r3, .L3527
	ldr	r3, .L3546+20
	mov	r0, fp
	str	r2, [sp, #16]
	ldrb	r1, [r3]	@ zero_extendqisi2
	lsls	r1, r1, #9
	bl	js_hash
	ldr	r3, [sp, #20]
	ldr	r2, [sp, #16]
	cmp	r3, r0
	beq	.L3527
	mov	r1, r3
	ldr	r0, .L3546+48
	bl	printf
.L3526:
	adds	r7, r7, #1
	sxth	r7, r7
	b	.L3525
.L3527:
	ldr	r3, [sp, #12]
	add	r10, r10, #176
	str	r3, [r2, r10, lsl #2]
	b	.L3526
.L3547:
	.align	2
.L3546:
	.word	.LANCHOR151
	.word	.LANCHOR136
	.word	.LANCHOR138
	.word	.LANCHOR208
	.word	.LANCHOR207
	.word	.LANCHOR131
	.word	.LANCHOR110
	.word	.LC206
	.word	.LANCHOR198
	.word	.LANCHOR221
	.word	.LANCHOR111
	.word	.LC207
	.word	.LC208
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
	ldr	r3, .L3563
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	fp, r0
	str	r2, [sp, #4]
	mov	r6, r1
	ldr	r2, [r3]
	cmp	r0, r2
	bcc	.L3549
	mov	r1, r0
	ldr	r0, .L3563+4
	bl	printf
	ldr	r3, [sp, #4]
	mov	r0, #-1
	cbnz	r3, .L3548
	str	r0, [r6]
.L3548:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3549:
	ldr	r3, .L3563+8
	ldrb	r5, [r3]	@ zero_extendqisi2
	lsls	r1, r5, #7
	bl	__aeabi_uidiv
	ldr	r1, .L3563+12
	uxth	r7, r0
	mov	r10, r0
	movs	r2, #0
	mov	r8, r1
.L3555:
	add	r0, r1, r2, lsl #3
	uxth	r4, r2
	ldr	r0, [r0, #4]
	cmp	r0, #0
	beq	.L3551
	ldrh	r0, [r1, r2, lsl #3]
	cmp	r0, r7
	bne	.L3551
.L3552:
	lsls	r5, r5, #7
	ldr	r3, [sp, #4]
	lsls	r4, r4, #3
	smulbb	r5, r5, r7
	sub	r5, fp, r5
	uxth	r5, r5
	cbnz	r3, .L3553
	add	r2, r8, r4
	ldr	r1, .L3563+16
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
	ldr	r1, .L3563+20
	ldrb	r1, [r1]	@ zero_extendqisi2
	cmp	r2, r1
	bcc	.L3554
	mov	r2, #-1
	str	r2, [r6]
.L3554:
	add	r4, r4, r8
	movw	r2, #32767
	ldrh	r3, [r4, #2]
	ubfx	r1, r3, #0, #15
	cmp	r1, r2
	beq	.L3558
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
.L3558:
	movs	r0, #0
	b	.L3548
.L3553:
	add	r1, r8, r4
	ldr	r0, [r6]
	ldr	r2, [r1, #4]
	str	r0, [r2, r5, lsl #2]
	ldrh	r2, [r1, #2]
	mvn	r2, r2, lsl #17
	mvn	r2, r2, lsr #17
	strh	r2, [r1, #2]	@ movhi
	ldr	r2, .L3563+24
	strb	r10, [r2]
	b	.L3554
.L3551:
	adds	r2, r2, #1
	cmp	r2, #32
	bne	.L3555
	bl	pm_select_ram_region
	ldrh	r1, [r8, r0, lsl #3]
	movw	r2, #65535
	mov	r4, r0
	cmp	r1, r2
	beq	.L3556
	add	r2, r8, r0, lsl #3
	ldrsh	r2, [r2, #2]
	cmp	r2, #0
	bge	.L3556
	bl	pm_flush_id
.L3556:
	ldr	r2, .L3563+28
	mov	r1, r4
	mov	r0, r7
	strb	r4, [r2]
	bl	load_l2p_region
	b	.L3552
.L3564:
	.align	2
.L3563:
	.word	.LANCHOR128
	.word	.LC209
	.word	.LANCHOR131
	.word	.LANCHOR138
	.word	.LANCHOR32
	.word	.LANCHOR112
	.word	.LANCHOR139
	.word	.LANCHOR223
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
	@ args = 0, pretend = 0, frame = 40
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r5, #0
	ldr	r4, .L3675
	sub	sp, sp, #72
	ldr	r3, .L3675+4
	ldr	fp, [r4]
	strb	r5, [r3]
	ldr	r3, .L3675+8
	ldrh	r6, [fp, #80]
	strb	r5, [r3]
	movw	r3, #65535
	cmp	r6, r3
	beq	.L3566
	strh	r3, [fp, #130]	@ movhi
	movs	r0, #1
	bl	buf_alloc
	ldrb	r3, [fp, #89]	@ zero_extendqisi2
	mov	r7, r0
	ldr	r2, .L3675+12
	ldr	r5, .L3675+16
	add	r3, fp, r3, lsl #1
	ldrh	r2, [r2]
	ldrb	r1, [r5]	@ zero_extendqisi2
	ldrh	r3, [r3, #94]
	str	r5, [sp, #36]
	cmp	r1, #2
	mul	r2, r2, r3
	str	r2, [sp, #64]
	beq	.L3567
	ldr	r3, .L3675+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L3567
	ldr	r3, .L3675+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L3568
.L3567:
	ldr	r3, .L3675+28
	ldrh	r3, [r3]
	subs	r3, r3, #1
	add	r3, r3, r2
	orr	r3, r3, r1, lsl #24
.L3667:
	str	r3, [r7, #24]
.L3569:
	movs	r1, #1
	mov	r0, r7
	bl	sblk_read_page
	ldr	r3, [r7, #36]
	adds	r2, r3, #1
	beq	.L3570
	cmp	r3, #512
	beq	.L3570
	ldr	r2, [r7, #12]
	ldr	r3, .L3675+32
	ldr	r2, [r2]
	str	r3, [sp, #40]
	cmp	r2, r3
	beq	.L3571
.L3570:
	mov	r0, r7
	bl	zbuf_free
	ldr	r2, [r7, #12]
	ldr	r3, [r7, #4]
	ldr	r0, .L3675+36
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
	ldr	r2, [r7, #36]
	ldr	r3, [r3]
	ldr	r1, [r7, #24]
	bl	printf
.L3674:
	ldr	r3, .L3675+40
	ldrh	r1, [fp, #80]
	ldr	r2, [r3]
	movs	r3, #0
	strh	r3, [r2, r1, lsl #1]	@ movhi
	ldr	r2, [r4]
	mov	r4, r3
	ldrh	r1, [fp, #80]
	strh	r1, [r2, #130]	@ movhi
.L3572:
	ldr	r3, .L3675+40
	ldrh	r0, [fp, #80]
	ldr	r3, [r3]
	ldrh	r3, [r3, r0, lsl #1]
	cbnz	r3, .L3616
	bl	ftl_dump_write_open_sblk
.L3616:
	mov	r2, r4
	ldrh	r1, [fp, #80]
	movw	r5, #65535
	ldr	r0, .L3675+44
	ldr	r4, .L3675
	bl	printf
	strh	r5, [fp, #80]	@ movhi
	bl	pm_flush
	bl	ftl_ext_info_flush
	ldr	r3, [r4]
	ldrh	r3, [r3, #130]
	cmp	r3, r5
	beq	.L3617
	ldr	r2, .L3675+48
	ldrh	r2, [r2]
	cmp	r2, r3
	bhi	.L3618
	movw	r2, #517
	ldr	r1, .L3675+52
	ldr	r0, .L3675+56
	bl	printf
.L3618:
	ldr	r3, [r4]
	ldrh	r0, [r3, #130]
	bl	ftl_free_sblk
.L3617:
	ldr	r3, .L3675+60
	movs	r0, #0
	ldr	r2, [r3]
	movw	r3, #65535
	strh	r3, [r2, #126]	@ movhi
	ldr	r2, [r4]
	strh	r3, [r2, #130]	@ movhi
	bl	ftl_info_flush
.L3565:
	add	sp, sp, #72
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3568:
	cmp	r1, #3
	bne	.L3569
	ldr	r3, .L3675+64
	ldrh	r3, [r3]
	subs	r3, r3, #1
	add	r3, r3, r2
	orr	r3, r3, #50331648
	b	.L3667
.L3571:
	ldr	r3, .L3675+68
	ldr	r5, .L3675+28
	ldr	r6, .L3675+72
	ldrb	r2, [r3]	@ zero_extendqisi2
	str	r3, [sp, #44]
	ldr	r8, .L3675+88
	cmp	r2, #2
	bne	.L3573
	ldr	r3, [sp, #36]
	ldrb	r2, [r3]	@ zero_extendqisi2
	cmp	r2, #3
	bne	.L3573
	ldrh	r2, [r5]
	ldr	r10, .L3675+80
	ldr	r0, [r8]
	lsls	r1, r2, #2
	ldrb	r2, [r6]	@ zero_extendqisi2
	ldrh	ip, [r10]
	smulbb	r2, r2, r1
	ldr	r1, [r7, #4]
	sub	r2, r2, ip
	lsr	ip, ip, #2
	uxth	r2, r2
	add	r0, r0, ip, lsl #2
	bl	ftl_memcpy
	ldr	r2, .L3675+20
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbnz	r2, .L3574
	ldr	r2, .L3675+24
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbz	r2, .L3575
.L3574:
	ldr	r2, [r7, #24]
	subs	r2, r2, #1
.L3668:
	str	r2, [r7, #24]
	movs	r1, #1
	mov	r0, r7
	bl	sblk_read_page
	ldr	r2, [r7, #36]
	adds	r3, r2, #1
	beq	.L3577
	cmp	r2, #512
	beq	.L3577
	ldr	r2, [r7, #12]
	ldr	r3, [sp, #40]
	ldr	r2, [r2]
	cmp	r2, r3
	beq	.L3578
.L3577:
	mov	r0, r7
	bl	zbuf_free
	b	.L3674
.L3575:
	ldr	r1, .L3675+64
	ldr	r2, [sp, #64]
	ldrh	r1, [r1]
	subs	r2, r2, #1
	add	r2, r2, r1
	orr	r2, r2, #33554432
	b	.L3668
.L3578:
	ldrh	r2, [r10]
.L3669:
	ldr	r1, [r7, #4]
	ldr	r0, [r8]
	bl	ftl_memcpy
	ldrh	r3, [r5]
	ldrb	r2, [r6]	@ zero_extendqisi2
	ldr	r10, .L3675+92
	muls	r2, r3, r2
	ldr	r3, .L3675+76
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r2, asr #6
	lsl	r2, r2, #2
	bge	.L3580
	movs	r1, #0
	ldr	r0, [r10]
	bl	ftl_memset
	ldr	r3, [sp, #44]
	ldrb	r8, [r3]	@ zero_extendqisi2
	cmp	r8, #1
	bne	.L3621
	ldrh	r1, [r5]
	ldrb	r3, [r6]	@ zero_extendqisi2
	ldr	r2, .L3675+80
	ldr	r0, [r10]
	muls	r3, r1, r3
	ldrh	r4, [r2]
	ldr	r1, [r7, #4]
	lsls	r3, r3, #2
	subs	r4, r4, r3
	add	r1, r1, r3
	mov	r2, r4
	bl	ftl_memcpy
	str	r8, [sp, #44]
.L3581:
	ldr	r3, .L3675+64
	ldrh	r3, [r3]
	str	r3, [sp, #40]
	ldr	r3, [sp, #36]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #2
	str	r3, [sp, #36]
	bne	.L3582
	ldr	r3, .L3675+84
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L3583
.L3582:
	ldr	r3, .L3675+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L3584
.L3583:
	ldr	r3, [sp, #36]
	ldr	r2, [sp, #40]
	muls	r3, r2, r3
	str	r3, [sp, #40]
	movs	r3, #1
	str	r3, [sp, #36]
.L3584:
	movs	r5, #0
	str	r5, [sp, #48]
.L3585:
	ldr	r3, [sp, #40]
	cmp	r3, r5
	bls	.L3598
	add	r3, r5, r5, lsl #1
	mov	r10, #0
	subs	r3, r3, #1
	str	r3, [sp, #52]
	b	.L3599
.L3573:
	ldrh	r1, [r5]
	ldrb	r2, [r6]	@ zero_extendqisi2
	muls	r2, r1, r2
	lsls	r2, r2, #2
	b	.L3669
.L3580:
	ldr	r1, [r7, #4]
	ldr	r0, [r10]
	add	r1, r1, r2
	bl	ftl_memcpy
	movs	r3, #0
.L3670:
	str	r3, [sp, #44]
	movs	r4, #0
	b	.L3581
.L3621:
	movs	r3, #1
	b	.L3670
.L3676:
	.align	2
.L3675:
	.word	.LANCHOR10
	.word	.LANCHOR85
	.word	.LANCHOR159
	.word	.LANCHOR111
	.word	.LANCHOR79
	.word	.LANCHOR36
	.word	.LANCHOR37
	.word	.LANCHOR86
	.word	-178307901
	.word	.LC210
	.word	.LANCHOR9
	.word	.LC212
	.word	.LANCHOR6
	.word	.LANCHOR225
	.word	.LC0
	.word	.LANCHOR110
	.word	.LANCHOR95
	.word	.LANCHOR224
	.word	.LANCHOR80
	.word	.LANCHOR131
	.word	.LANCHOR221
	.word	.LANCHOR81
	.word	.LANCHOR162
	.word	.LANCHOR163
.L3594:
	ldr	r3, [sp, #56]
	ldr	r2, .L3677
	ldrh	r3, [r3, #96]
	ldrh	r2, [r2]
	muls	r3, r2, r3
	ldr	r2, .L3677+4
	ldrb	r1, [r2]	@ zero_extendqisi2
	str	r3, [sp, #64]
	cmp	r1, #2
	beq	.L3586
	ldr	r2, .L3677+8
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, #0
	beq	.L3587
.L3586:
	subs	r2, r5, #1
	add	r3, r3, r2
	add	r3, r3, r8
	orr	r3, r3, r1, lsl #24
.L3671:
	str	r3, [r7, #24]
	movs	r1, #1
	mov	r0, r7
	bl	sblk_read_page
	ldr	r3, [sp, #44]
	cbz	r3, .L3591
	ldr	r3, .L3677+12
	ldr	r3, [r3]
	ldr	r2, [r3, r6]
	cbnz	r2, .L3591
	ldr	r2, [r7, #12]
	ldr	r2, [r2, #8]
	str	r2, [r3, r6]
.L3591:
	ldr	r3, .L3677+16
	ldr	r2, [r7, #12]
	ldr	r3, [r3]
	ldr	r1, [r2, #4]
	ldr	r3, [r3, r6]
	cmp	r3, r1
	bne	.L3592
	ldr	r0, .L3677+12
	ldr	r0, [r0]
	ldr	ip, [r0, r6]
	ldr	r0, [r2, #8]
	cmp	ip, r0
	beq	.L3593
.L3592:
	ldr	r0, [r2, #12]
	str	r0, [sp, #16]
	ldr	r0, [r2, #8]
	str	r1, [sp, #8]
	str	r0, [sp, #12]
	ldr	r2, [r2]
	ldr	r0, .L3677+20
	str	r2, [sp, #4]
	ldr	r2, .L3677+12
	ldr	r2, [r2]
	ldr	r2, [r2, r6]
	str	r2, [sp]
	ldr	r2, [r7, #36]
	ldr	r1, [r7, #24]
	bl	printf
	ldr	r3, .L3677+16
	ldr	r3, [r3]
	ldr	r3, [r3, r6]
	adds	r3, r3, #1
	beq	.L3593
	mov	r0, r7
	bl	zbuf_free
	ldr	r3, .L3677+24
	movs	r1, #0
	ldrh	r2, [fp, #80]
	ldr	r3, [r3]
	strh	r1, [r3, r2, lsl #1]	@ movhi
	ldr	r3, .L3677+28
	ldrh	r2, [fp, #80]
	ldr	r3, [r3]
	strh	r2, [r3, #130]	@ movhi
	b	.L3572
.L3587:
	cmp	r1, #3
	bne	.L3589
	ldr	r2, .L3677+32
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbz	r2, .L3590
	ldr	r2, [sp, #52]
	add	r3, r3, r2
	add	r3, r3, r8
	orr	r3, r3, #50331648
	b	.L3671
.L3590:
	add	r3, r3, r5
	orr	r3, r3, r8, lsl #24
	b	.L3671
.L3589:
	add	r3, r3, r5
	b	.L3671
.L3593:
	ldr	r3, [sp, #48]
	add	r8, r8, #1
	adds	r6, r6, #4
	adds	r3, r3, #1
	str	r3, [sp, #48]
.L3596:
	ldr	r3, [sp, #36]
	cmp	r3, r8
	bcs	.L3594
	add	r10, r10, #1
.L3599:
	ldrb	r3, [fp, #89]	@ zero_extendqisi2
	cmp	r10, r3
	bge	.L3595
	ldr	r3, [sp, #48]
	mov	r8, #1
	lsls	r6, r3, #2
	add	r3, fp, r10, lsl #1
	str	r3, [sp, #56]
	b	.L3596
.L3595:
	ldr	r3, .L3677+36
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L3597
	adds	r5, r5, #1
.L3597:
	adds	r5, r5, #1
	b	.L3585
.L3598:
	mov	r0, r7
	movs	r4, #0
	bl	zbuf_free
	ldr	r3, .L3677+24
	mov	r10, r4
	ldr	r0, .L3677+40
	mov	r8, r4
	ldrh	r1, [fp, #80]
	ldr	r2, [r3]
	ldrh	r0, [r0]
	ldrb	r3, [fp, #89]	@ zero_extendqisi2
	smulbb	r3, r3, r0
	strh	r3, [r2, r1, lsl #1]	@ movhi
.L3600:
	ldr	r3, [sp, #40]
	cmp	r3, r10
	bls	.L3614
	add	r2, r10, r10, lsl #1
	movs	r7, #0
	subs	r3, r2, #1
	str	r3, [sp, #52]
	b	.L3615
.L3610:
	ldr	r3, .L3677+16
	ldr	r2, [r3]
	ldr	r3, [r2, r8, lsl #2]
	str	r3, [sp, #44]
	adds	r3, r3, #1
	beq	.L3601
	ldr	r3, .L3677+12
	ldr	r0, [sp, #44]
	ldr	r2, [r3]
	ldr	r3, [r2, r8, lsl #2]
	str	r3, [sp, #48]
	bl	lpa_hash_get_ppa
	str	r0, [sp, #68]
	adds	r0, r0, #1
	bne	.L3602
	movs	r2, #0
	add	r1, sp, #68
	ldr	r0, [sp, #44]
	bl	pm_log2phys
.L3602:
	ldr	r3, [sp, #56]
	ldr	r1, .L3677
	ldrh	r2, [r3, #96]
	ldrh	r1, [r1]
	muls	r1, r2, r1
	ldr	r2, .L3677+4
	ldrb	r0, [r2]	@ zero_extendqisi2
	cmp	r0, #2
	beq	.L3603
	ldr	r2, .L3677+8
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, #0
	beq	.L3604
.L3603:
	add	r2, r10, #-1
	add	r2, r2, r1
	add	r2, r2, r5
	orr	r2, r2, r0, lsl #24
.L3673:
	str	r2, [sp, #64]
.L3605:
	ldr	r2, .L3677+44
	ldr	r3, [sp, #48]
	ldrh	r1, [r2]
	ldr	r2, .L3677+48
	ldrb	r0, [r2]	@ zero_extendqisi2
	movs	r2, #1
	lsr	r6, r3, r1
	str	r2, [sp, #60]
	rsb	r0, r0, #24
	subs	r0, r0, r1
	ldr	r1, .L3677+52
	lsl	r0, r2, r0
	subs	r0, r0, #1
	ldrb	r1, [r1]	@ zero_extendqisi2
	ands	r0, r0, r6
	bl	__aeabi_uidiv
	ldr	r1, [sp, #68]
	mov	r6, r0
	ldr	r3, [sp, #48]
	ldr	r2, [sp, #60]
	cmp	r3, r1
	bne	.L3608
	add	r1, sp, #64
	ldr	r0, [sp, #44]
	bl	pm_log2phys
	uxth	r0, r6
	adds	r4, r4, #1
	bl	ftl_vpn_decrement
.L3609:
	ldr	r2, .L3677+56
	uxth	r6, r6
	add	r8, r8, #1
	ldr	r2, [r2]
	add	r2, r2, r6, lsl #2
	ldrb	r2, [r2, #2]	@ zero_extendqisi2
	ands	r2, r2, #224
	bne	.L3601
	ldr	r1, .L3677+24
	ldr	r1, [r1]
	ldrh	r0, [r1, r6, lsl #1]
	cbz	r0, .L3601
	strh	r2, [r1, r6, lsl #1]	@ movhi
.L3601:
	adds	r5, r5, #1
.L3612:
	ldr	r3, [sp, #36]
	cmp	r3, r5
	bcs	.L3610
	adds	r7, r7, #1
.L3615:
	ldrb	r2, [fp, #89]	@ zero_extendqisi2
	cmp	r7, r2
	bge	.L3611
	add	r3, fp, r7, lsl #1
	movs	r5, #1
	str	r3, [sp, #56]
	b	.L3612
.L3604:
	cmp	r0, #3
	bne	.L3606
	ldr	r2, .L3677+32
	lsls	r0, r5, #24
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbz	r2, .L3607
	ldr	r3, [sp, #52]
	adds	r2, r1, r3
	add	r2, r2, r5
.L3672:
	orrs	r2, r2, r0
	b	.L3673
.L3607:
	add	r2, r10, r1
	b	.L3672
.L3606:
	add	r1, r1, r10
	str	r1, [sp, #64]
	b	.L3605
.L3608:
	ldr	r2, [sp, #64]
	cmp	r1, r2
	it	eq
	addeq	r4, r4, #1
	b	.L3609
.L3611:
	ldr	r2, .L3677+36
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbz	r2, .L3613
	add	r10, r10, #1
.L3613:
	add	r10, r10, #1
	b	.L3600
.L3614:
	ldr	r3, .L3677+24
	ldrh	r2, [fp, #80]
	ldr	r3, [r3]
	strh	r4, [r3, r2, lsl #1]	@ movhi
	ldrh	r0, [fp, #80]
	bl	zftl_insert_data_list
	b	.L3572
.L3678:
	.align	2
.L3677:
	.word	.LANCHOR111
	.word	.LANCHOR79
	.word	.LANCHOR36
	.word	.LANCHOR163
	.word	.LANCHOR162
	.word	.LC211
	.word	.LANCHOR9
	.word	.LANCHOR10
	.word	.LANCHOR37
	.word	.LANCHOR81
	.word	.LANCHOR86
	.word	.LANCHOR75
	.word	.LANCHOR32
	.word	.LANCHOR76
	.word	.LANCHOR7
.L3566:
	ldrh	r3, [fp, #130]
	cmp	r3, r6
	beq	.L3565
	ldr	r7, .L3679
	ldr	r2, [r7]
	ldrh	r2, [r2, #126]
	cmp	r2, r3
	bne	.L3620
	bl	pm_flush
	ldr	r3, [r4]
	ldrh	r0, [r3, #130]
	bl	ftl_free_sblk
	ldr	r3, [r7]
	mov	r0, r5
	strh	r6, [r3, #126]	@ movhi
	bl	ftl_info_flush
.L3620:
	ldr	r3, [r4]
	movw	r2, #65535
	strh	r2, [r3, #130]	@ movhi
	b	.L3565
.L3680:
	.align	2
.L3679:
	.word	.LANCHOR110
	.size	gc_recovery, .-gc_recovery
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
	ldr	r3, .L3715
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #32
	ldr	r2, .L3715+4
	ldr	r4, [r3]
	ldrh	r2, [r2]
	ldr	r7, .L3715+8
	ldrb	r1, [r4, #89]	@ zero_extendqisi2
	str	r3, [sp, #20]
	muls	r2, r1, r2
	str	r2, [sp, #4]
	ldr	r2, [r7]
	tst	r2, #256
	beq	.L3682
	ldrh	r1, [r4, #80]
	ldr	r0, .L3715+12
	bl	printf
.L3682:
	ldr	r3, .L3715+16
	movs	r6, #0
	ldr	r0, [sp, #4]
	mov	r5, r6
	ldrh	r1, [r4, #80]
	ldr	r2, [r3]
	ldr	r3, .L3715+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	subs	r3, r0, r3
	strh	r3, [r2, r1, lsl #1]	@ movhi
.L3683:
	ldr	r3, [sp, #4]
	cmp	r5, r3
	bne	.L3692
	ldr	r3, [r7]
	ldr	r5, .L3715+16
	tst	r3, #256
	beq	.L3693
	ldr	r3, [sp, #20]
	ldrh	r0, [r4, #80]
	ldr	r2, [r5]
	ldr	r1, [r3]
	mov	r3, r6
	ldrh	r2, [r2, r0, lsl #1]
	ldrh	r1, [r1, #80]
	ldr	r0, .L3715+24
	bl	printf
.L3693:
	ldrh	r2, [r4, #80]
	ldr	r3, [r5]
	ldrh	r3, [r3, r2, lsl #1]
	cmp	r6, r3
	beq	.L3694
	movw	r2, #898
	ldr	r1, .L3715+28
	ldr	r0, .L3715+32
	bl	printf
.L3694:
	ldrh	r2, [r4, #80]
	ldr	r3, [r5]
	strh	r6, [r3, r2, lsl #1]	@ movhi
	ldrh	r0, [r4, #80]
	bl	zftl_insert_data_list
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3692:
	ldr	r3, .L3715+36
	lsl	r8, r5, #2
	ldr	r3, [r3]
	ldr	r10, [r3, r5, lsl #2]
	cmp	r10, #-1
	beq	.L3684
	ldr	r3, .L3715+40
	mov	r0, r10
	ldrb	r1, [r3]	@ zero_extendqisi2
	lsls	r1, r1, #7
	bl	__aeabi_uidiv
	uxth	r3, r0
	str	r3, [sp, #16]
	ldr	r3, [r7]
	lsls	r1, r3, #23
	bpl	.L3685
	mov	r3, r5
	mov	r2, r10
	ldr	r1, [sp, #16]
	ldr	r0, .L3715+44
	bl	printf
.L3685:
	ldr	fp, .L3715+36
	str	r5, [sp, #12]
.L3691:
	ldr	r3, [fp]
	ldr	r10, [r3, r8]
	cmp	r10, #-1
	beq	.L3686
	ldr	r3, .L3715+40
	mov	r0, r10
	ldrb	r1, [r3]	@ zero_extendqisi2
	lsls	r1, r1, #7
	bl	__aeabi_uidiv
	ldr	r3, [sp, #16]
	uxth	r0, r0
	cmp	r3, r0
	bne	.L3686
	ldr	r3, .L3715+48
	mov	r0, r10
	ldr	r3, [r3]
	ldr	r3, [r3, r8]
	str	r3, [sp, #8]
	bl	lpa_hash_get_ppa
	str	r0, [sp, #28]
	adds	r0, r0, #1
	bne	.L3687
	movs	r2, #0
	add	r1, sp, #28
	mov	r0, r10
	bl	pm_log2phys
.L3687:
	ldr	r3, [sp, #28]
	ldr	r2, [sp, #8]
	cmp	r2, r3
	bne	.L3688
	ldr	r3, .L3715+52
	add	r1, sp, #32
	movs	r2, #1
	mov	r0, r10
	adds	r6, r6, #1
	ldr	r3, [r3]
	ldr	r3, [r3, r8]
	str	r3, [r1, #-8]!
	bl	pm_log2phys
	ldr	r3, .L3715+56
	ldrh	r2, [r3]
	ldr	r3, .L3715+60
	ldrb	r3, [r3]	@ zero_extendqisi2
	rsb	r3, r3, #24
	subs	r0, r3, r2
	movs	r3, #1
	lsls	r3, r3, r0
	ldr	r0, [sp, #8]
	subs	r3, r3, #1
	lsrs	r0, r0, r2
	ldr	r2, .L3715+64
	ands	r0, r0, r3
	ldrb	r1, [r2]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	uxth	r0, r0
.L3714:
	bl	ftl_vpn_decrement
	ldr	r3, [fp]
	mov	r2, #-1
	str	r2, [r3, r8]
.L3686:
	ldr	r3, [sp, #12]
	add	r8, r8, #4
	adds	r3, r3, #1
	str	r3, [sp, #12]
	ldr	r2, [sp, #12]
	ldr	r3, [sp, #4]
	cmp	r3, r2
	bne	.L3691
.L3684:
	adds	r5, r5, #1
	b	.L3683
.L3688:
	ldr	r2, [r7]
	lsls	r2, r2, #23
	bpl	.L3690
	ldr	r2, [sp, #8]
	mov	r1, r10
	ldr	r0, .L3715+68
	bl	printf
.L3690:
	ldrh	r0, [r4, #80]
	b	.L3714
.L3716:
	.align	2
.L3715:
	.word	.LANCHOR10
	.word	.LANCHOR86
	.word	.LANCHOR14
	.word	.LC213
	.word	.LANCHOR9
	.word	.LANCHOR224
	.word	.LC216
	.word	.LANCHOR226
	.word	.LC0
	.word	.LANCHOR162
	.word	.LANCHOR131
	.word	.LC214
	.word	.LANCHOR163
	.word	.LANCHOR164
	.word	.LANCHOR75
	.word	.LANCHOR32
	.word	.LANCHOR76
	.word	.LC215
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
	ldr	r4, .L3746
	mov	r0, r1
	movw	r5, #65535
	ldr	r6, .L3746+4
	ldrb	r3, [r4, #4]	@ zero_extendqisi2
	ldrb	ip, [r6]	@ zero_extendqisi2
	add	r2, r4, r3, lsl #1
	ldrh	r7, [r2, #36]
	ldrh	r2, [r4, #2]
.L3718:
	cmp	r7, r5
	beq	.L3720
	cbz	r0, .L3721
	strh	r2, [r4, #2]	@ movhi
.L3721:
	cbz	r1, .L3722
	strb	r3, [r4, #4]
.L3722:
	ldr	r8, .L3746+24
	movs	r0, #1
	ldr	r10, .L3746+28
	mov	fp, #1
	bl	buf_alloc
	mov	r5, r0
.L3723:
	ldrb	r1, [r4, #6]	@ zero_extendqisi2
	cmp	fp, r1
	ble	.L3733
	mov	r0, r5
	bl	zbuf_free
	ldrb	r3, [r4, #4]	@ zero_extendqisi2
	ldrb	r2, [r6]	@ zero_extendqisi2
	adds	r3, r3, #1
	uxtb	r3, r3
	cmp	r2, r3
	strb	r3, [r4, #4]
	bne	.L3717
	ldrh	r3, [r4, #2]
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #4]
.L3717:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3720:
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
	b	.L3718
.L3733:
	ldrh	r3, [r8]
	cmp	r1, #2
	mul	r2, r7, r3
	bne	.L3724
	ldrh	r3, [r4, #2]
	add	r3, r2, r3, lsl #1
	subs	r3, r3, #1
.L3745:
	ldr	r2, .L3746+8
	add	r3, r3, fp
	ldrb	r2, [r2]	@ zero_extendqisi2
	orr	r3, r3, r2, lsl #24
.L3744:
	str	r3, [r5, #24]
	movs	r1, #1
	mov	r0, r5
	bl	sblk_read_page
	ldr	r3, [r5, #36]
	adds	r2, r3, #1
	beq	.L3730
	cmp	r3, #512
	beq	.L3730
	ldr	r3, [r5, #12]
	ldr	r3, [r3, #4]
	mov	r0, r3
	str	r3, [sp, #4]
	bl	lpa_hash_get_ppa
	str	r0, [sp, #12]
	adds	r0, r0, #1
	ldr	r3, [sp, #4]
	bne	.L3732
	ldr	r2, .L3746+12
	ldr	r2, [r2]
	cmp	r3, r2
	bcs	.L3732
	movs	r2, #0
	add	r1, sp, #12
	mov	r0, r3
	bl	pm_log2phys
.L3732:
	ldr	r2, [r5, #24]
	ldr	r3, [sp, #12]
	cmp	r2, r3
	bne	.L3730
	ldr	r1, .L3746+16
	ldrh	r3, [r4, #20]
	ldr	r1, [r1]
	str	r2, [r1, r3, lsl #2]
	adds	r3, r3, #1
	strh	r3, [r4, #20]	@ movhi
.L3730:
	ldrh	r3, [r4, #22]
	add	fp, fp, #1
	adds	r3, r3, #1
	strh	r3, [r4, #22]	@ movhi
	b	.L3723
.L3724:
	cmp	r1, #3
	bne	.L3726
	ldrb	r3, [r10]	@ zero_extendqisi2
	cbnz	r3, .L3727
	ldr	r3, .L3746+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L3728
.L3727:
	ldrh	r3, [r4, #2]
	add	r3, r3, r3, lsl #1
	subs	r3, r3, #1
	add	r3, r3, r2
	b	.L3745
.L3728:
	ldrh	r3, [r4, #2]
	add	r3, r3, r2
	orr	r3, r3, fp, lsl #24
	b	.L3744
.L3726:
	ldrh	r3, [r4, #2]
	add	r3, r3, r2
	b	.L3744
.L3747:
	.align	2
.L3746:
	.word	.LANCHOR71
	.word	.LANCHOR80
	.word	.LANCHOR79
	.word	.LANCHOR128
	.word	.LANCHOR77
	.word	.LANCHOR37
	.word	.LANCHOR111
	.word	.LANCHOR36
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
	@ args = 0, pretend = 0, frame = 32
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movw	r3, #65535
	ldr	r4, .L3813
	sub	sp, sp, #32
	ldrh	r2, [r4]
	cmp	r2, r3
	bne	.L3749
	mov	r2, #1504
	ldr	r1, .L3813+4
	ldr	r0, .L3813+8
	bl	printf
.L3749:
	ldrh	r1, [r4]
	movw	r3, #65535
	cmp	r1, r3
	beq	.L3781
	ldr	r3, .L3813+12
	ldr	r3, [r3]
	lsls	r0, r3, #23
	bpl	.L3751
	ldr	r3, .L3813+16
	ldr	r0, .L3813+20
	ldr	r3, [r3]
	ldrh	r2, [r3, r1, lsl #1]
	bl	printf
.L3751:
	ldr	r1, .L3813+24
	ldrh	r0, [r4]
	bl	ftl_get_blk_list_in_sblk
	uxtb	r0, r0
	strb	r0, [r4, #5]
	cbnz	r0, .L3752
	movw	r3, #65535
	strh	r3, [r4]	@ movhi
.L3748:
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3752:
	ldr	r5, .L3813+28
	ldrh	r3, [r4]
	ldr	r2, [r5]
	add	r2, r2, r3, lsl #2
	ldrb	r2, [r2, #2]	@ zero_extendqisi2
	and	r2, r2, #224
	cmp	r2, #32
	beq	.L3753
	cmp	r2, #224
	beq	.L3753
	cbz	r2, .L3754
	ldr	r2, .L3813+32
	ldr	r2, [r2]
	ldrh	r1, [r2, #16]
	cmp	r1, r3
	beq	.L3753
	ldrh	r1, [r2, #48]
	cmp	r1, r3
	beq	.L3753
	ldrh	r2, [r2, #80]
	cmp	r2, r3
	bne	.L3807
.L3753:
	movw	r3, #65535
	movs	r0, #0
	strh	r3, [r4]	@ movhi
	strh	r0, [r4, #20]	@ movhi
	b	.L3748
.L3754:
	ldr	r5, .L3813+16
	ldr	r1, [r5]
	ldrh	r3, [r1, r3, lsl #1]
	cbz	r3, .L3756
	movw	r2, #1529
	ldr	r1, .L3813+4
	ldr	r0, .L3813+8
	bl	printf
.L3756:
	ldrh	r2, [r4]
	movs	r1, #0
	ldr	r3, [r5]
	strh	r1, [r3, r2, lsl #1]	@ movhi
	b	.L3753
.L3807:
	add	r0, r4, r0, lsl #1
	movw	r3, #65535
	ldrh	r7, [r0, #34]
	cmp	r7, r3
	bne	.L3757
	movw	r2, #1539
	ldr	r1, .L3813+4
	ldr	r0, .L3813+8
	bl	printf
.L3757:
	ldrh	ip, [r4]
	ldr	r1, [r5]
	ldr	r6, .L3813+36
	ldr	r0, .L3813+40
	add	r1, r1, ip, lsl #2
	ldrh	r3, [r6]
	ldrh	r2, [r0]
	mov	r8, r6
	ldrb	r1, [r1, #2]	@ zero_extendqisi2
	subs	r3, r3, #1
	str	r0, [sp, #12]
	uxth	r3, r3
	and	r1, r1, #224
	muls	r2, r7, r2
	cmp	r1, #160
	bne	.L3782
	ldr	r1, .L3813+44
	ldrb	r1, [r1]	@ zero_extendqisi2
	cmp	r1, #2
	it	eq
	ldreq	r3, .L3813+48
	uxth	r10, r1
	orr	r2, r2, r1, lsl #24
	ldr	r1, .L3813+52
	it	eq
	ldrheq	r3, [r3]
	ldrb	r1, [r1]	@ zero_extendqisi2
	itt	eq
	addeq	r3, r3, #-1
	uxtheq	r3, r3
	cbnz	r1, .L3760
	ldr	r1, .L3813+56
	ldrb	r1, [r1]	@ zero_extendqisi2
	cbz	r1, .L3758
.L3760:
	ldr	r3, .L3813+48
	ldrh	r3, [r3]
	subs	r3, r3, #1
	uxth	r3, r3
.L3758:
	movs	r6, #0
	strb	r10, [r4, #6]
	orrs	r3, r3, r2
	movs	r0, #1
	str	r3, [sp, #4]
	strh	r6, [r4, #2]	@ movhi
	strb	r6, [r4, #4]
	strh	r6, [r4, #22]	@ movhi
	strh	r6, [r4, #24]	@ movhi
	bl	buf_alloc
	ldr	r3, [sp, #4]
	mov	r5, r0
	movs	r1, #1
	str	r3, [r0, #24]
	bl	sblk_read_page
	ldr	r3, [r5, #36]
	strh	r6, [r4, #20]	@ movhi
	adds	r1, r3, #1
	beq	.L3811
	cmp	r3, #512
	bne	.L3762
.L3811:
	mov	r0, r5
	bl	zbuf_free
.L3809:
	mov	r0, #-1
	b	.L3748
.L3782:
	mov	r10, #1
	b	.L3758
.L3762:
	ldr	r6, [r5, #12]
	ldr	r3, .L3813+60
	ldr	r2, [r6]
	str	r3, [sp, #16]
	cmp	r2, r3
	beq	.L3763
	movw	r2, #1577
.L3812:
	ldr	r1, .L3813+4
	ldr	r0, .L3813+8
	bl	printf
	b	.L3811
.L3763:
	ldr	r3, .L3813+64
	ldrh	r2, [r8]
	ldrb	r3, [r3]	@ zero_extendqisi2
	smulbb	r2, r2, r3
	smulbb	r2, r2, r10
	uxth	r2, r2
	str	r2, [sp, #8]
	ldr	r2, .L3813+68
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, #2
	bne	.L3764
	cmp	r10, #3
	bne	.L3764
	ldr	r2, .L3813+48
	ldr	fp, .L3813+84
	ldr	r10, .L3813+76
	ldrh	r6, [r2]
	ldrh	r0, [fp]
	ldr	r1, [r5, #4]
	lsls	r6, r6, #2
	smulbb	r6, r6, r3
	ldr	r3, [r10]
	subs	r6, r6, r0
	lsrs	r0, r0, #2
	uxth	r6, r6
	add	r0, r3, r0, lsl #2
	mov	r2, r6
	bl	ftl_memcpy
	ldr	r3, [r5, #12]
	ldr	r3, [r3, #4]
	str	r3, [sp, #20]
	cbz	r3, .L3765
	mov	r1, r6
	ldr	r0, [r5, #4]
	bl	js_hash
	ldr	r3, [sp, #20]
	cmp	r3, r0
	beq	.L3765
	mov	r0, r5
	bl	zbuf_free
	ldr	r1, [r5, #12]
	mov	r3, r6
.L3810:
	ldr	r2, [r5, #24]
	ldr	r1, [r1, #4]
	ldr	r0, .L3813+72
	bl	printf
	b	.L3809
.L3765:
	ldr	r3, .L3813+52
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L3766
	ldr	r3, .L3813+56
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L3767
.L3766:
	ldr	r3, [sp, #4]
	subs	r3, r3, #1
	str	r3, [r5, #24]
.L3768:
	movs	r1, #1
	mov	r0, r5
	bl	sblk_read_page
	ldr	r3, [r5, #36]
	adds	r2, r3, #1
	beq	.L3811
	cmp	r3, #512
	beq	.L3811
	ldr	r3, [r5, #12]
	ldr	r2, [sp, #16]
	ldr	r3, [r3]
	cmp	r3, r2
	beq	.L3771
	movw	r2, #1618
	b	.L3812
.L3767:
	ldr	r2, [sp, #12]
	ldrh	r3, [r8]
	ldrh	r2, [r2]
	subs	r3, r3, #1
	uxth	r3, r3
	muls	r7, r2, r7
	orr	r3, r3, #33554432
	orrs	r7, r7, r3
	str	r7, [r5, #24]
	b	.L3768
.L3771:
	ldrh	r2, [fp]
	ldr	r1, [r5, #4]
	ldr	r0, [r10]
.L3808:
	ldr	r7, .L3813+76
	mov	r8, #0
	bl	ftl_memcpy
	ldr	r10, .L3813+88
	ldr	r6, [r7]
	ldr	fp, .L3813+92
	subs	r6, r6, #4
.L3774:
	ldr	r3, [sp, #8]
	cmp	r8, r3
	blt	.L3779
	mov	r0, r5
	ldr	r5, .L3813+16
	bl	zbuf_free
	ldrh	r1, [r4]
	ldr	r3, [r5]
	ldrh	r2, [r3, r1, lsl #1]
	ldrh	r3, [r4, #20]
	cmp	r2, r3
	beq	.L3780
	ldr	r0, .L3813+80
	bl	printf
.L3780:
	ldr	r3, [r5]
	ldrh	r1, [r4, #20]
	ldrh	r2, [r4]
	strh	r1, [r3, r2, lsl #1]	@ movhi
	movs	r3, #0
	strh	r3, [r4, #24]	@ movhi
	ldrh	r0, [r4, #20]
	b	.L3748
.L3814:
	.align	2
.L3813:
	.word	.LANCHOR71
	.word	.LANCHOR227
	.word	.LC0
	.word	.LANCHOR14
	.word	.LANCHOR9
	.word	.LC217
	.word	.LANCHOR71+36
	.word	.LANCHOR7
	.word	.LANCHOR10
	.word	.LANCHOR95
	.word	.LANCHOR111
	.word	.LANCHOR79
	.word	.LANCHOR86
	.word	.LANCHOR36
	.word	.LANCHOR37
	.word	-178307901
	.word	.LANCHOR80
	.word	.LANCHOR224
	.word	.LC218
	.word	.LANCHOR77
	.word	.LC219
	.word	.LANCHOR221
	.word	.LANCHOR75
	.word	.LANCHOR32
.L3764:
	ldr	r3, [sp, #8]
	ldr	r8, [r5, #4]
	lsls	r7, r3, #2
	mov	r0, r8
	mov	r1, r7
	bl	js_hash
	ldr	r3, [r6, #4]
	cmp	r3, r0
	beq	.L3773
	mov	r0, r5
	bl	zbuf_free
	ldr	r1, [r5, #12]
	mov	r3, r7
	b	.L3810
.L3773:
	ldr	r3, .L3815
	mov	r2, r7
	mov	r1, r8
	ldr	r0, [r3]
	b	.L3808
.L3779:
	ldr	r0, [r6, #4]!
	adds	r3, r0, #1
	beq	.L3776
	bl	lpa_hash_get_ppa
	str	r0, [sp, #28]
	adds	r0, r0, #1
	bne	.L3777
	movs	r2, #0
	add	r1, sp, #28
	ldr	r0, [r6]
	bl	pm_log2phys
.L3777:
	ldrb	r3, [fp]	@ zero_extendqisi2
	ldr	r2, [sp, #28]
	ldrh	r1, [r10]
	rsb	r3, r3, #24
	str	r2, [sp, #4]
	subs	r0, r3, r1
	movs	r3, #1
	lsls	r3, r3, r0
	lsr	r0, r2, r1
	ldr	r1, .L3815+4
	subs	r3, r3, #1
	ands	r0, r0, r3
	ldrb	r1, [r1]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	ldrh	r3, [r4]
	ldr	r2, [sp, #4]
	cmp	r0, r3
	bne	.L3776
	ldrh	r3, [r4, #20]
	ldr	r1, [r7]
	str	r2, [r1, r3, lsl #2]
	adds	r3, r3, #1
	strh	r3, [r4, #20]	@ movhi
.L3776:
	add	r8, r8, #1
	b	.L3774
.L3781:
	movs	r0, #0
	b	.L3748
.L3816:
	.align	2
.L3815:
	.word	.LANCHOR77
	.word	.LANCHOR76
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
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	ldr	r4, .L3833
	ldr	r3, [r4]
	ldr	r2, [r3, #544]
	adds	r2, r2, #1
	beq	.L3818
	ldr	r8, .L3833+28
	movs	r6, #0
	ldr	r10, .L3833+32
.L3826:
	ldr	r3, [r4]
	movs	r2, #0
	add	r1, sp, #4
	uxth	r7, r6
	ldr	r0, [r3, #544]
	bl	pm_log2phys
	ldr	r3, [sp, #4]
	adds	r3, r3, #1
	beq	.L3819
	movs	r0, #1
	bl	buf_alloc
	ldr	r3, [sp, #4]
	mov	r5, r0
	movs	r1, #1
	str	r3, [r0, #24]
	bl	sblk_read_page
	ldr	r3, [r5, #36]
	cmp	r3, #256
	bne	.L3820
	ldr	r3, .L3833+4
	mov	fp, #1
	ldr	r2, [sp, #4]
	ldrh	r0, [r3]
	ldr	r3, .L3833+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	rsb	r3, r3, #24
	subs	r3, r3, r0
	lsr	r0, r2, r0
	lsl	r3, fp, r3
	ldr	r2, .L3833+12
	subs	r3, r3, #1
	ldrb	r1, [r2]	@ zero_extendqisi2
	ands	r0, r0, r3
	bl	__aeabi_uidiv
	movs	r2, #0
	mov	r1, fp
	uxth	r0, r0
	bl	gc_add_sblk
.L3820:
	ldr	r2, [r5, #12]
	ldr	r3, [r4]
	ldr	r2, [r2, #4]
	ldr	r3, [r3, #544]
	cmp	r2, r3
	beq	.L3821
	movw	r2, #2162
	mov	r1, r8
	mov	r0, r10
	bl	printf
.L3821:
	mov	r0, r5
	bl	zbuf_free
.L3819:
	ldr	r3, [r4]
	ldr	r1, .L3833+16
	ldr	r2, [r3, #544]
	ldr	r1, [r1]
	adds	r2, r2, #1
	cmp	r2, r1
	str	r2, [r3, #544]
	bcc	.L3822
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
.L3817:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3822:
	ldr	r3, [sp, #4]
	adds	r3, r3, #1
	bne	.L3817
	ldr	r3, .L3833+20
	adds	r6, r6, #1
	ldrh	r3, [r3]
	cmp	r7, r3, lsr #2
	bcc	.L3826
	b	.L3817
.L3818:
	ldr	r2, [r3, #536]
	ldr	r1, [r3, #12]
	ldr	r0, .L3833+24
	add	r2, r2, #12910592
	add	r2, r2, #49408
	cmp	r1, r2
	bhi	.L3828
	ldr	r4, [r0]
	ldr	r2, [r3, #540]
	ldr	r4, [r4, #44]
	add	r2, r2, #4992
	adds	r2, r2, #8
	cmp	r4, r2
	bls	.L3817
.L3828:
	ldr	r2, [r0]
	ldr	r2, [r2, #44]
	str	r1, [r3, #536]
	str	r2, [r3, #540]
	movs	r2, #0
	str	r2, [r3, #544]
	b	.L3817
.L3834:
	.align	2
.L3833:
	.word	.LANCHOR10
	.word	.LANCHOR75
	.word	.LANCHOR32
	.word	.LANCHOR76
	.word	.LANCHOR128
	.word	.LANCHOR221
	.word	.LANCHOR110
	.word	.LANCHOR228
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
	ldr	r4, .L3878
	sub	sp, sp, #128
	lsls	r2, r0, #2
	mov	r6, r0
	str	r3, [sp, #76]
	ldr	r3, [r4]
	str	r1, [sp, #68]
	ldr	r1, [r3, r0, lsl #2]
	adds	r2, r3, r2
	ldrb	r2, [r2, #2]	@ zero_extendqisi2
	ubfx	r1, r1, #11, #8
	str	r1, [sp, #4]
	mov	r1, r0
	ldrh	r3, [r3, r0, lsl #2]
	ldr	r0, .L3878+4
	ubfx	r3, r3, #0, #11
	str	r3, [sp]
	ubfx	r3, r2, #3, #2
	lsrs	r2, r2, #5
	bl	printf
	movw	r3, #65535
	cmp	r6, r3
	beq	.L3858
	ldr	r3, .L3878+8
	ldrh	r3, [r3]
	cmp	r3, r6
	bls	.L3858
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
	ldreq	r3, .L3878+12
	movne	fp, #1
	ldrbeq	fp, [r3]	@ zero_extendqisi2
	bl	ftl_get_blk_list_in_sblk
	ldr	r3, .L3878+16
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
	ldr	r0, .L3878+20
	lsrs	r2, r2, #5
	bl	printf
	movs	r0, #1
	bl	buf_alloc
	mov	r7, r0
	str	r5, [sp, #48]
	str	r5, [sp, #44]
.L3838:
	ldr	r3, .L3878+16
	ldrh	r2, [r3]
	uxth	r3, r5
	cmp	r2, r3
	bls	.L3855
	str	r3, [sp, #60]
	lsls	r3, r3, #1
	subs	r2, r3, #1
	str	r2, [sp, #80]
	ldr	r2, [sp, #60]
	add	r3, r3, r2
	subs	r3, r3, #1
	str	r3, [sp, #72]
	movs	r3, #0
	b	.L3877
.L3852:
	ldr	r3, [sp, #84]
	add	r2, sp, #128
	add	r3, r2, r3, lsl #1
	ldrh	r3, [r3, #-32]
	str	r3, [sp, #56]
	movw	r3, #65535
	ldr	r2, [sp, #56]
	cmp	r2, r3
	beq	.L3839
	ldr	r3, .L3878+24
	cmp	fp, #3
	ldrh	r4, [r3]
	mov	r3, r2
	mul	r3, r3, r4
	bne	.L3840
	ldr	r2, .L3878+28
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbz	r2, .L3841
	ldr	r2, [sp, #72]
.L3874:
	adds	r4, r3, r2
	ldr	r2, .L3878+12
	add	r3, r4, r8
	ldrb	r4, [r2]	@ zero_extendqisi2
	orr	r4, r3, r4, lsl #24
	b	.L3842
.L3841:
	ldr	r2, .L3878+32
	lsl	r4, r8, #24
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, #0
	beq	.L3843
	ldr	r2, [sp, #72]
	add	r3, r3, r2
	add	r3, r3, r8
.L3875:
	orrs	r4, r4, r3
.L3842:
	movs	r1, #1
	str	r4, [r7, #24]
	mov	r0, r7
	bl	sblk_read_page
	ldr	r2, [r7, #12]
	ldr	r3, [r7, #36]
	ldr	r0, .L3878+36
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
	beq	.L3860
	cmp	r3, #512
	ldr	r3, [sp, #44]
	it	eq
	moveq	r3, #1
.L3876:
	str	r3, [sp, #44]
	ldr	r3, .L3878
	ldr	r2, [sp, #76]
	ldr	r3, [r3]
	add	r3, r3, r2
	ldrb	r3, [r3, #2]	@ zero_extendqisi2
	and	r3, r3, #224
	cmp	r3, #224
	beq	.L3839
	cmp	r3, #32
	beq	.L3839
	ldr	r3, [r7, #12]
	ldr	r0, [r3, #4]
	bl	lpa_hash_get_ppa
	str	r0, [sp, #92]
	adds	r0, r0, #1
	bne	.L3846
	ldr	r3, [r7, #12]
	movs	r2, #0
	add	r1, sp, #92
	ldr	r0, [r3, #4]
	bl	pm_log2phys
.L3846:
	ldr	r3, [sp, #92]
	cmp	r4, r3
	bne	.L3847
	ldr	r3, [sp, #48]
	mov	r1, r4
	ldr	r2, [r7, #12]
	ldr	r0, .L3878+40
	adds	r3, r3, #1
	ldr	r2, [r2, #4]
	str	r3, [sp, #48]
	bl	printf
.L3847:
	ldr	r3, [sp, #68]
	cbz	r3, .L3849
	ldr	r2, [r3, r10, lsl #2]
	lsl	r4, r10, #2
	ldr	r3, [r7, #12]
	ldr	r3, [r3, #4]
	cmp	r3, r2
	beq	.L3850
	ldr	r3, .L3878+44
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L3850
	mov	r1, r10
	ldr	r0, .L3878+48
	bl	printf
.L3850:
	ldr	r3, [sp, #68]
	ldr	r2, [r7, #12]
	ldr	r3, [r3, r4]
	ldr	r2, [r2, #4]
	cmp	r2, r3
	beq	.L3849
	adds	r3, r3, #1
	beq	.L3849
	movw	r2, #1567
	ldr	r1, .L3878+52
	ldr	r0, .L3878+56
	bl	printf
.L3849:
	add	r10, r10, #1
.L3839:
	add	r8, r8, #1
	uxth	r8, r8
.L3854:
	cmp	fp, r8
	bcs	.L3852
	ldr	r3, [sp, #52]
	adds	r3, r3, #1
.L3877:
	str	r3, [sp, #52]
	ldrb	r2, [sp, #105]	@ zero_extendqisi2
	ldrh	r3, [sp, #52]
	cmp	r2, r3
	bls	.L3853
	adds	r3, r3, #8
	mov	r8, #1
	str	r3, [sp, #84]
	b	.L3854
.L3843:
	uxtah	r3, r3, r5
	b	.L3875
.L3840:
	cmp	fp, #2
	bne	.L3844
	ldr	r2, [sp, #80]
	b	.L3874
.L3844:
	uxtah	r4, r3, r5
	b	.L3842
.L3860:
	movs	r3, #1
	b	.L3876
.L3853:
	adds	r5, r5, #1
	b	.L3838
.L3855:
	mov	r0, r7
	bl	zbuf_free
	ldr	r3, .L3878+60
	mov	r1, r6
	ldr	r0, .L3878+64
	ldr	r2, [r3]
	ldr	r3, [sp, #48]
	ldrh	r2, [r2, r6, lsl #1]
	bl	printf
	ldr	r0, [sp, #44]
.L3835:
	add	sp, sp, #128
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3858:
	movs	r0, #0
	b	.L3835
.L3879:
	.align	2
.L3878:
	.word	.LANCHOR7
	.word	.LC220
	.word	.LANCHOR6
	.word	.LANCHOR79
	.word	.LANCHOR95
	.word	.LC221
	.word	.LANCHOR111
	.word	.LANCHOR36
	.word	.LANCHOR37
	.word	.LC167
	.word	.LC222
	.word	.LANCHOR14
	.word	.LC223
	.word	.LANCHOR229
	.word	.LC0
	.word	.LANCHOR9
	.word	.LC224
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
	ldr	r3, .L3929
	mov	r4, r0
	sub	sp, sp, #72
	mov	r6, r1
	mov	fp, r2
	ldr	r3, [r3]
	lsls	r0, r3, #19
	bpl	.L3881
	mov	r3, r2
	ldr	r0, .L3929+4
	mov	r2, r1
	mov	r1, r4
	bl	printf
.L3881:
	cmp	r4, #0
	bne	.L3882
	ldr	r3, .L3929+8
	mov	r4, #24576
	ldr	r3, [r3]
.L3883:
	cmp	r3, r6
	bls	.L3914
	cmp	r3, fp
	bcc	.L3914
	add	r2, r6, fp
	cmp	r3, r2
	bcc	.L3914
	adds	r3, r4, r6
	ldr	r6, .L3929+12
	str	r3, [sp, #28]
	ldr	r3, .L3929+16
	ldr	r0, [sp, #28]
	ldr	r2, [r3]
	ldr	r3, [r2, #24]
	add	r3, r3, fp
	str	r3, [r2, #24]
	ldr	r3, .L3929+20
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
.L3885:
	ldr	r3, [sp, #32]
	cbnz	r3, .L3910
	ldr	r0, [sp, #40]
.L3880:
	add	sp, sp, #72
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3882:
	cmp	r4, #3
	bhi	.L3914
	lsls	r4, r4, #13
	mov	r3, #8192
	b	.L3883
.L3910:
	ldr	r3, .L3929+20
	ldrb	r1, [r3]	@ zero_extendqisi2
	ldr	r3, [sp, #36]
	cmp	r4, r3
	uxth	r7, r1
	bne	.L3886
	ldr	r0, [sp, #28]
	bl	__aeabi_uidivmod
	uxth	r8, r1
	sub	r7, r7, r8
	uxth	r7, r7
	cmp	fp, r7
	bcs	.L3887
	uxth	r7, fp
.L3887:
	ldr	r2, .L3929+12
	movs	r3, #0
.L3890:
	ldr	r1, [r2, #20]
	cmp	r4, r1
	bne	.L3888
	ldrb	r1, [r2, #2]	@ zero_extendqisi2
	lsls	r1, r1, #28
	bpl	.L3888
	movs	r2, #48
	lsls	r7, r7, #9
	mov	r0, r5
	mla	r3, r2, r3, r6
	add	r5, r5, r7
	mov	r2, r7
	ldr	r1, [r3, #4]
	add	r1, r1, r8, lsl #9
	bl	ftl_memcpy
.L3889:
	ldr	r3, [sp, #32]
	adds	r4, r4, #1
	subs	r3, r3, #1
	str	r3, [sp, #32]
.L3896:
	ldr	r3, .L3929+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #2
	bls	.L3897
	ldr	r3, [sp, #32]
	cmp	r3, #0
	bne	.L3885
.L3897:
	ldr	r3, .L3929+28
	ldrb	r1, [r3]	@ zero_extendqisi2
	cmp	r1, #0
	beq	.L3885
	ldr	r3, .L3929+32
	ldrb	r0, [r3]	@ zero_extendqisi2
	add	r0, r0, r0, lsl #1
	add	r0, r6, r0, lsl #4
	bl	sblk_read_page
.L3899:
	ldr	r3, .L3929+28
	ldr	r8, .L3929+32
	ldrb	r2, [r3]	@ zero_extendqisi2
	cmp	r2, #0
	bne	.L3909
	movs	r1, #255
	strb	r2, [r3]
	strb	r1, [r8]
	b	.L3885
.L3886:
	ldr	r3, [sp, #48]
	mov	r8, #0
	cmp	r4, r3
	itttt	eq
	ldreq	r3, [sp, #28]
	addeq	r7, r3, fp
	mlseq	r1, r4, r1, r7
	uxtbeq	r7, r1
	b	.L3887
.L3888:
	adds	r3, r3, #1
	adds	r2, r2, #48
	cmp	r3, #32
	bne	.L3890
	mov	r0, r4
	bl	lpa_hash_get_ppa
	str	r0, [sp, #68]
	adds	r0, r0, #1
	bne	.L3891
	movs	r2, #0
	add	r1, sp, #68
	mov	r0, r4
	bl	pm_log2phys
.L3891:
	ldr	r3, [sp, #68]
	adds	r3, r3, #1
	bne	.L3892
	ldr	r8, .L3929+20
	movs	r7, #0
.L3893:
	ldrb	r3, [r8]	@ zero_extendqisi2
	cmp	r7, r3
	bcs	.L3889
	mla	r3, r3, r4, r7
	ldr	r2, [sp, #28]
	cmp	r2, r3
	bhi	.L3894
	ldr	r2, [sp, #44]
	cmp	r2, r3
	bls	.L3894
	mov	r0, r5
	add	r5, r5, #512
	mov	r2, #512
	movs	r1, #0
	bl	ftl_memset
.L3894:
	adds	r7, r7, #1
	b	.L3893
.L3892:
	movs	r0, #0
	bl	buf_alloc
	cmp	r0, #0
	beq	.L3896
	ldr	r2, .L3929+16
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
	b	.L3889
.L3930:
	.align	2
.L3929:
	.word	.LANCHOR14
	.word	.LC225
	.word	.LANCHOR68
	.word	.LANCHOR56
	.word	.LANCHOR110
	.word	.LANCHOR131
	.word	.LANCHOR58
	.word	.LANCHOR134
	.word	.LANCHOR133
.L3909:
	ldrb	r3, [r8]	@ zero_extendqisi2
	cmp	r3, #255
	bne	.L3900
	movw	r2, #1276
	ldr	r1, .L3931
	ldr	r0, .L3931+4
	bl	printf
.L3900:
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
	bne	.L3901
	ldr	r3, .L3931+8
	str	r8, [sp, #40]
	ldr	r2, [r3]
	ldr	r3, [r2, #552]
	adds	r3, r3, #1
	str	r3, [r2, #552]
.L3902:
	movs	r3, #48
	mla	r3, r3, r7, r6
	ldr	r2, [r3, #12]
	ldr	r3, [r3, #20]
	ldr	r1, [r2, #4]
	cmp	r1, r3
	bne	.L3903
	cmp	r8, #-1
	bne	.L3904
.L3903:
	ldr	r1, .L3931+8
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
	ldr	r0, .L3931+12
	str	r2, [sp, #4]
	ldr	r2, [r10, #24]
	str	r2, [sp]
	mov	r2, r8
	bl	printf
	ldr	r3, .L3931+16
	ldrh	r2, [r3]
	ldr	r3, .L3931+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	rsb	r3, r3, #24
	subs	r0, r3, r2
	movs	r3, #1
	lsls	r3, r3, r0
	ldr	r0, [r10, #24]
	subs	r3, r3, #1
	lsrs	r0, r0, r2
	ldr	r2, .L3931+24
	ands	r0, r0, r3
	ldrb	r1, [r2]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	movs	r1, #0
	uxth	r0, r0
	bl	ftl_sblk_dump
.L3904:
	movs	r3, #48
	mla	r3, r3, r7, r6
	ldr	r2, [r3, #12]
	ldr	r3, [r3, #20]
	ldr	r2, [r2, #4]
	cmp	r2, r3
	bne	.L3905
	cmp	r8, #-1
	bne	.L3906
.L3905:
	movw	r2, #1301
	ldr	r1, .L3931
	ldr	r0, .L3931+4
	bl	printf
.L3906:
	movs	r3, #48
	mla	r7, r3, r7, r6
	ldr	r3, .L3931+28
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldrb	r2, [r7, #40]	@ zero_extendqisi2
	cmp	r3, r2
	bls	.L3907
	ldrb	r1, [r7, #41]	@ zero_extendqisi2
	lsls	r2, r2, #9
	ldr	r3, [r7, #4]
	ldr	r0, [r7, #8]
	add	r1, r3, r1, lsl #9
	bl	ftl_memcpy
.L3908:
	ldr	r1, [sp, #52]
	ldr	r0, .L3931+32
	bl	buf_remove_buf
	ldr	r0, [sp, #52]
	bl	zbuf_free
	ldr	r2, .L3931+36
	ldrb	r3, [r2]	@ zero_extendqisi2
	subs	r3, r3, #1
	strb	r3, [r2]
	b	.L3899
.L3901:
	cmp	r8, #256
	bne	.L3902
	ldr	r1, .L3931+16
	ldr	r3, [r2, #24]
	str	r2, [sp, #60]
	movs	r2, #1
	ldrh	r0, [r1]
	ldr	r1, .L3931+20
	str	r3, [sp, #56]
	ldrb	ip, [r1]	@ zero_extendqisi2
	ldr	r1, .L3931+24
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
	ldr	r0, .L3931+40
	ldr	r2, [r2, #20]
	bl	printf
	movs	r2, #0
	movs	r1, #1
	uxth	r0, r10
	bl	gc_add_sblk
	b	.L3902
.L3907:
	ldrb	r3, [r7, #2]	@ zero_extendqisi2
	bic	r3, r3, #8
	strb	r3, [r7, #2]
	b	.L3908
.L3914:
	mov	r0, #-1
	b	.L3880
.L3932:
	.align	2
.L3931:
	.word	.LANCHOR230
	.word	.LC0
	.word	.LANCHOR10
	.word	.LC227
	.word	.LANCHOR75
	.word	.LANCHOR32
	.word	.LANCHOR76
	.word	.LANCHOR131
	.word	.LANCHOR63
	.word	.LANCHOR134
	.word	.LC226
	.size	zftl_read, .-zftl_read
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
	.section	.text.zftl_vendor_read,"ax",%progbits
	.align	1
	.global	zftl_vendor_read
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	zftl_vendor_read, %function
zftl_vendor_read:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	b	ftl_vendor_read
	.size	zftl_vendor_read, .-zftl_vendor_read
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
	ldr	r3, .L3968
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #24
	ldrb	r7, [r0, #9]	@ zero_extendqisi2
	mov	r6, r0
	ldrh	r3, [r3]
	ldr	r2, .L3968+4
	muls	r7, r3, r7
	ldr	r4, [r2]
	ldrh	r3, [r0, #12]
	str	r2, [sp, #4]
	add	r4, r4, r3, lsl #2
	add	r3, r7, #1073741824
	subs	r3, r3, #1
	ldr	r3, [r4, r3, lsl #2]
	adds	r3, r3, #1
	beq	.L3940
	movw	r2, #1990
	ldr	r1, .L3968+8
	ldr	r0, .L3968+12
	bl	printf
.L3940:
	movs	r5, #0
	subs	r4, r4, #4
	mov	r10, r5
.L3941:
	cmp	r10, r7
	bne	.L3947
	ldr	r3, .L3968+16
	ldr	r4, .L3968+20
	ldr	r3, [r3]
	tst	r3, #4096
	beq	.L3948
	ldrh	r1, [r6]
	mov	r2, r5
	ldr	r3, [r4]
	ldr	r0, .L3968+24
	ldrh	r3, [r3, r1, lsl #1]
	bl	printf
.L3948:
	ldrh	r2, [r6]
	ldr	r3, [r4]
	strh	r5, [r3, r2, lsl #1]	@ movhi
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3947:
	ldr	r8, [r4, #4]!
	cmp	r8, #-1
	beq	.L3942
	ldr	r3, .L3968+28
	mov	r0, r8
	ldrb	r1, [r3]	@ zero_extendqisi2
	lsls	r1, r1, #7
	bl	__aeabi_uidiv
	uxth	r3, r0
	str	r3, [sp]
	ldr	r3, .L3968+16
	ldr	r3, [r3]
	lsls	r2, r3, #19
	bpl	.L3943
	mov	r3, r10
	mov	r2, r8
	ldr	r1, [sp]
	ldr	r0, .L3968+32
	bl	printf
.L3943:
	mov	r8, r4
	mov	fp, r10
.L3946:
	ldr	r0, [r8]
	adds	r3, r0, #1
	beq	.L3944
	ldr	r3, .L3968+28
	ldrb	r1, [r3]	@ zero_extendqisi2
	lsls	r1, r1, #7
	bl	__aeabi_uidiv
	ldr	r3, [sp]
	uxth	r0, r0
	cmp	r3, r0
	bne	.L3944
	ldrb	r3, [r6, #9]	@ zero_extendqisi2
	mov	r0, fp
	mov	r1, r3
	str	r3, [sp, #12]
	bl	__aeabi_idivmod
	ldr	r3, .L3968+36
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
	ldr	r0, .L3968+40
	str	r2, [sp, #20]
	ldr	r1, [r8]
	bl	pm_ppa_update_check
	cbz	r0, .L3945
	ldr	r1, [sp, #4]
	mov	r3, r7
	movs	r2, #4
	ldr	r0, .L3968+44
	ldr	r1, [r1]
	bl	rknand_print_hex
.L3945:
	adds	r5, r5, #1
	movs	r2, #1
	uxth	r5, r5
	add	r1, sp, #20
	ldr	r0, [r8]
	bl	pm_log2phys
	mov	r3, #-1
	str	r3, [r8]
.L3944:
	add	fp, fp, #1
	add	r8, r8, #4
	cmp	r7, fp
	bne	.L3946
.L3942:
	add	r10, r10, #1
	b	.L3941
.L3969:
	.align	2
.L3968:
	.word	.LANCHOR95
	.word	.LANCHOR117
	.word	.LANCHOR231
	.word	.LC0
	.word	.LANCHOR14
	.word	.LANCHOR9
	.word	.LC231
	.word	.LANCHOR131
	.word	.LC228
	.word	.LANCHOR111
	.word	.LC229
	.word	.LC230
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
	beq	.L3971
	bl	zftl_insert_data_list
.L3971:
	ldr	r4, .L3975
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
	bne	.L3973
	movw	r5, #65535
	cmp	r6, r5
	beq	.L3973
	mov	r1, r6
	ldr	r0, .L3975+4
	bl	printf
	ldr	r3, [r4]
	ldr	r0, [r3, #564]
	bl	gc_mark_bad_ppa
	ldr	r3, [r4]
	mov	r2, #-1
	str	r5, [r3, #560]
	str	r2, [r3, #564]
.L3973:
	bl	ftl_ext_info_flush
	movs	r0, #0
	bl	ftl_info_flush
	bl	lpa_rebuild_hash
	movs	r0, #0
	pop	{r4, r5, r6, pc}
.L3976:
	.align	2
.L3975:
	.word	.LANCHOR10
	.word	.LC232
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
	ldr	r8, .L4040+32
.L3978:
	ldr	r1, .L4040
	ldrb	r3, [r1]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L3980
	ldr	r0, .L4040+4
	subs	r3, r3, #1
	strb	r3, [r1]
	ldrb	r2, [r0]	@ zero_extendqisi2
	str	r2, [sp, #12]
	add	r2, r2, r2, lsl #1
	ldr	r4, [sp, #12]
	add	r2, r8, r2, lsl #4
	str	r2, [sp, #20]
	movs	r2, #48
	muls	r2, r4, r2
	ldr	r4, .L4040+8
	ldr	r3, [r4]
	add	r5, r8, r2
	ldrb	r2, [r8, r2]	@ zero_extendqisi2
	strb	r2, [r0]
	ldr	r2, [r5, #20]
	cmp	r2, r3
	bcc	.L3982
	mov	r2, #604
	ldr	r1, .L4040+12
	ldr	r0, .L4040+16
	bl	printf
.L3982:
	ldr	r2, [sp, #12]
	movs	r3, #48
	mla	r3, r3, r2, r8
	ldr	r2, [r4]
	ldr	r7, [r3, #20]
	cmp	r7, r2
	bcc	.L3983
	ldr	r0, [sp, #20]
	bl	zbuf_free
	mov	r0, #-1
.L3977:
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3983:
	ldr	r2, [r3, #12]
	ldr	fp, [r3, #4]
	ldrb	r4, [r3, #41]	@ zero_extendqisi2
	ldrb	r3, [r3, #40]	@ zero_extendqisi2
	str	r2, [sp, #8]
	str	r3, [sp, #16]
	ldr	r3, .L4040+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L3985
	ldr	r3, .L4040+24
	ldrb	r5, [r3]	@ zero_extendqisi2
	add	r5, r5, r5, lsl #1
	add	r5, r8, r5, lsl #4
.L3986:
	ldrb	r3, [r5]	@ zero_extendqisi2
	cmp	r3, #255
	bne	.L3987
	ldr	r3, [r5, #20]
	cmp	r7, r3
	bne	.L3985
	ldr	r2, [sp, #16]
	lsls	r0, r4, #9
	ldr	r3, [r5, #4]
	add	r1, fp, r0
	lsls	r2, r2, #9
	add	r0, r0, r3
	bl	ftl_memcpy
	ldr	r3, .L4040+28
	movs	r0, #2
	ldr	r2, [r5, #4]
	ldr	r1, [r5, #12]
	ldrb	r3, [r3]	@ zero_extendqisi2
	adds	r1, r1, #16
	subs	r3, r3, #2
	add	r2, r2, r3, lsl #9
	bl	ftl_debug_info_fill
	ldr	r0, [sp, #20]
	bl	zbuf_free
	b	.L3978
.L3987:
	add	r3, r3, r3, lsl #1
	add	r5, r8, r3, lsl #4
	b	.L3986
.L3985:
	mov	r0, r7
	bl	lpa_hash_get_ppa
	str	r0, [sp, #28]
	adds	r0, r0, #1
	bne	.L3989
	movs	r2, #0
	add	r1, sp, #28
	mov	r0, r7
	bl	pm_log2phys
.L3989:
	ldr	r10, .L4040+36
	movs	r2, #0
	ldr	r3, .L4040+32
	mov	r5, r2
	ldr	r0, [sp, #28]
	ldr	r6, [r10]
	add	ip, r3, #1536
	adds	r6, r6, #16
.L3991:
	ldr	r1, [r3, #20]
	cmp	r7, r1
	bne	.L3990
	ldrb	r1, [r3, #2]	@ zero_extendqisi2
	tst	r1, #8
	beq	.L3990
	ldr	r5, [r3, #4]
	movs	r2, #1
	ldr	r0, [r3, #24]
	bic	r1, r1, #8
	strb	r1, [r3, #2]
.L3990:
	adds	r3, r3, #48
	cmp	r3, ip
	bne	.L3991
	cbz	r2, .L3992
	str	r0, [sp, #28]
.L3992:
	ldr	r3, .L4040+28
	ldr	r2, [sp, #16]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r2, r3
	bcs	.L4016
	cbz	r5, .L3994
	cbz	r4, .L3995
	lsls	r2, r4, #9
	mov	r1, r5
	mov	r0, fp
	bl	ftl_memcpy
	ldr	r3, .L4040+36
	ldr	r6, [r3]
	adds	r6, r6, #48
.L3995:
	ldr	r3, [sp, #16]
	add	r4, r4, r3
	ldr	r3, .L4040+28
	ldrb	r2, [r3]	@ zero_extendqisi2
	cmp	r4, r2
	bcc	.L3996
	ldr	r6, [r10]
	adds	r6, r6, #16
.L4016:
	mov	r10, #0
	b	.L3993
.L3996:
	lsls	r0, r4, #9
	subs	r2, r2, r4
	lsls	r2, r2, #9
	adds	r1, r5, r0
	add	r0, r0, fp
	bl	ftl_memcpy
	b	.L4016
.L4041:
	.align	2
.L4040:
	.word	.LANCHOR67
	.word	.LANCHOR66
	.word	.LANCHOR128
	.word	.LANCHOR232
	.word	.LC0
	.word	.LANCHOR129
	.word	.LANCHOR185
	.word	.LANCHOR131
	.word	.LANCHOR56
	.word	.LANCHOR10
.L3994:
	ldr	r3, [sp, #28]
	adds	r3, r3, #1
	beq	.L3997
	movs	r0, #1
	bl	buf_alloc
	ldr	r3, [sp, #28]
	mov	r5, r0
	str	r7, [r0, #20]
	movs	r1, #1
	str	r3, [r0, #24]
	bl	sblk_read_page
	ldr	r3, [r5, #12]
	ldr	r2, [r3, #12]
	ldr	r3, [r3, #4]
	add	r10, r2, #1
	cmp	r7, r3
	bne	.L3998
	ldr	r3, [r5, #36]
	adds	r3, r3, #1
	bne	.L3999
.L3998:
	ldr	r3, .L4042
	ldr	r0, .L4042+4
	ldr	r2, [r3]
	ldr	r3, [r2, #552]
	adds	r3, r3, #1
	str	r3, [r2, #552]
	ldr	r3, [r5, #36]
	ldrb	r1, [r5, #1]	@ zero_extendqisi2
	ldr	r2, [sp, #28]
	str	r3, [sp]
	mov	r3, r7
	bl	printf
	movs	r3, #4
	ldr	r1, [r5, #12]
	mov	r2, r3
	ldr	r0, .L4042+8
	bl	rknand_print_hex
.L3999:
	ldr	r3, [r5, #12]
	ldr	r3, [r3, #4]
	cmp	r7, r3
	bne	.L4000
	ldr	r3, [r5, #36]
	adds	r3, r3, #1
	bne	.L4001
.L4000:
	movw	r2, #691
	ldr	r1, .L4042+12
	ldr	r0, .L4042+16
	bl	printf
.L4001:
	cbz	r4, .L4002
	ldr	r3, [sp, #28]
	lsls	r2, r4, #9
	adds	r3, r3, #1
	beq	.L4003
	ldr	r1, [r5, #4]
	mov	r0, fp
	bl	ftl_memcpy
.L4004:
	ldr	r3, .L4042
	ldr	r6, [r3]
	adds	r6, r6, #48
.L4002:
	ldr	r3, [sp, #16]
	add	r4, r4, r3
	ldr	r3, .L4042+20
	ldrb	r2, [r3]	@ zero_extendqisi2
	cmp	r4, r2
	bcc	.L4005
	bls	.L4006
	ldr	r3, .L4042
	ldr	r6, [r3]
	adds	r6, r6, #16
.L4006:
	cbz	r5, .L3993
	ldrb	r3, [r5, #2]	@ zero_extendqisi2
	mov	r1, r5
	ldr	r0, .L4042+24
	bic	r3, r3, #8
	strb	r3, [r5, #2]
	bl	buf_remove_buf
	mov	r0, r5
	bl	zbuf_free
.L3993:
	ldrh	r3, [r6, #6]
	cbnz	r3, .L4008
	bl	ftl_flush
	mov	r0, r6
	bl	ftl_alloc_new_data_sblk
.L4008:
	mov	r0, r6
	movs	r5, #48
	bl	ftl_get_new_free_page
	ldr	r3, [sp, #12]
	str	r0, [sp, #16]
	movs	r0, #2
	muls	r5, r3, r5
	ldr	r3, [sp, #8]
	mov	r1, r3
	add	r4, r8, r5
	ldr	r2, [r4, #16]
	str	r10, [r3, #12]
	stm	r3, {r2, r7}
	movs	r7, #0
	ldr	r2, [sp, #28]
	str	r2, [r3, #8]
	ldr	r3, .L4042+20
	str	r7, [r1, #16]!
	ldrb	r2, [r3]	@ zero_extendqisi2
	subs	r2, r2, #2
	add	r2, fp, r2, lsl #9
	bl	ftl_debug_info_fill
	ldr	r3, [sp, #16]
	ldrh	r2, [r6, #12]
	ldr	r1, [sp, #20]
	str	r3, [r4, #24]
	ldr	r3, [sp, #28]
	ldr	r0, .L4042+28
	str	r3, [r4, #28]
	movs	r3, #255
	strb	r3, [r8, r5]
	ldrb	r3, [r4, #2]	@ zero_extendqisi2
	orr	r3, r3, #10
	strb	r3, [r4, #2]
	ldrh	r3, [r6, #10]
	add	r3, r3, r2
	subs	r3, r3, #1
	strh	r3, [r4, #32]	@ movhi
	bl	buf_add_tail
	ldr	r2, .L4042+32
	ldrb	r3, [r2]	@ zero_extendqisi2
	adds	r3, r3, #1
	uxtb	r3, r3
	strb	r3, [r2]
	cmp	r3, #2
	ldr	r2, .L4042+36
	str	r7, [r2]
	ldrh	r2, [r6, #6]
	bhi	.L4009
	cmp	r2, #1
	bne	.L3981
.L4009:
	ldr	r5, .L4042+28
	movs	r7, #48
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
.L4013:
	cmp	r1, r4
	bne	.L4014
	strb	r2, [r5]
	uxtb	r1, r1
	ldr	r2, .L4042+32
	add	r0, r0, r0, lsl #1
	subs	r3, r3, r1
	add	r0, r8, r0, lsl #4
	strb	r3, [r2]
	bl	sblk_prog_page
	ldrh	r3, [r6, #6]
	cmp	r3, #1
	bne	.L3981
	bl	sblk_wait_write_queue_completed
	bl	ftl_write_completed
	mov	r0, r6
	bl	ftl_write_last_log_page
	mov	r0, r6
	bl	ftl_alloc_new_data_sblk
.L3981:
	ldr	r3, .L4042+40
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L3978
.L3980:
	bl	ftl_write_completed
	movs	r0, #0
	b	.L3977
.L4005:
	ldr	r3, [sp, #28]
	subs	r2, r2, r4
	lsls	r2, r2, #9
	lsls	r0, r4, #9
	adds	r3, r3, #1
	beq	.L4007
	ldr	r1, [r5, #4]
	add	r1, r1, r0
	add	r0, r0, fp
	bl	ftl_memcpy
	b	.L4006
.L4007:
	movs	r1, #0
	add	r0, r0, fp
	bl	ftl_memset
	b	.L4006
.L4014:
	muls	r2, r7, r2
	adds	r1, r1, #1
	ldrb	r2, [r8, r2]	@ zero_extendqisi2
	b	.L4013
.L4015:
	lsls	r2, r4, #9
	mov	r10, r5
.L4003:
	movs	r1, #0
	mov	r0, fp
	bl	ftl_memset
	b	.L4004
.L3997:
	cmp	r4, #0
	bne	.L4015
	mov	r10, r4
	mov	r5, r4
	b	.L4002
.L4043:
	.align	2
.L4042:
	.word	.LANCHOR10
	.word	.LC233
	.word	.LC205
	.word	.LANCHOR232
	.word	.LC0
	.word	.LANCHOR131
	.word	.LANCHOR63
	.word	.LANCHOR185
	.word	.LANCHOR129
	.word	.LANCHOR233
	.word	.LANCHOR67
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
	@ args = 0, pretend = 0, frame = 72
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L4187
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #80
	ldrb	r0, [r3]	@ zero_extendqisi2
	cmp	r0, #0
	bne	.L4045
	bl	buf_alloc
	mov	r4, r0
	cmp	r0, #0
	beq	.L4044
	ldr	r5, .L4187+4
	ldrh	r2, [r5, #22]
	mov	r0, r2
	bl	gc_get_src_ppa_from_index
	movs	r1, #1
	adds	r2, r2, #1
	str	r0, [r4, #24]
	mov	r6, r0
	mov	r0, r4
	strh	r2, [r5, #22]	@ movhi
	bl	sblk_read_page
	ldr	r3, [r4, #36]
	adds	r0, r3, #1
	beq	.L4047
	cmp	r3, #512
	bne	.L4048
.L4047:
	mov	r2, #1032
	ldr	r1, .L4187+8
	ldr	r0, .L4187+12
	bl	printf
.L4048:
	ldr	r3, [r4, #12]
	ldr	r8, [r3, #4]
	mov	r0, r8
	bl	lpa_hash_get_ppa
	str	r0, [sp, #56]
	adds	r0, r0, #1
	bne	.L4049
	movs	r2, #0
	add	r1, sp, #56
	mov	r0, r8
	bl	pm_log2phys
.L4049:
	ldr	r7, [sp, #56]
	cmp	r6, r7
	bne	.L4050
	ldr	r0, .L4187+16
	movs	r3, #0
.L4053:
	adds	r2, r0, r3
	ldr	r1, [r2, #20]
	cmp	r8, r1
	bne	.L4051
	ldrb	r2, [r2, #2]	@ zero_extendqisi2
	lsls	r1, r2, #30
	bpl	.L4051
	mov	r0, r4
	bl	zbuf_free
	ldr	r3, .L4187+20
	ldr	r3, [r3]
	lsls	r2, r3, #23
	bpl	.L4044
	ldrh	r3, [r5, #22]
	mov	r2, r6
	mov	r1, r8
	ldr	r0, .L4187+24
	bl	printf
.L4044:
	add	sp, sp, #80
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L4051:
	adds	r3, r3, #48
	cmp	r3, #1536
	bne	.L4053
	ldr	r3, .L4187+28
	movs	r2, #0
	str	r8, [r4, #20]
	strb	r2, [r4, #41]
	ldrb	r3, [r3]	@ zero_extendqisi2
	strb	r3, [r4, #40]
	ldr	r3, [r4, #12]
	ldr	r1, [r3]
	str	r1, [r4, #16]
	str	r2, [r3, #16]
	ldr	r3, .L4187+20
	ldr	r3, [r3]
	lsls	r3, r3, #23
	bpl	.L4054
	mov	r0, r8
	bl	lpa_hash_get_ppa
	ldrh	r3, [r5, #22]
	mov	r2, r7
	str	r6, [sp]
	mov	r1, r8
	str	r3, [sp, #4]
	mov	r3, r0
	ldr	r0, .L4187+32
	bl	printf
.L4054:
	mov	r0, r4
	bl	ftl_gc_write_buf
	bl	ftl_write_commit
	ldr	r3, .L4187+36
	ldr	r2, [r3]
	ldr	r3, [r2, #60]
	adds	r3, r3, #1
	str	r3, [r2, #60]
	ldrh	r3, [r5, #24]
	adds	r3, r3, #1
	strh	r3, [r5, #24]	@ movhi
	b	.L4044
.L4050:
	ldr	r3, .L4187+20
	ldr	r3, [r3]
	lsls	r0, r3, #23
	bpl	.L4055
	mov	r0, r8
	bl	lpa_hash_get_ppa
	ldrh	r3, [r5, #22]
	mov	r2, r7
	str	r6, [sp]
	mov	r1, r8
	str	r3, [sp, #4]
	mov	r3, r0
	ldr	r0, .L4187+32
	bl	printf
.L4055:
	mov	r0, r4
	bl	zbuf_free
	b	.L4044
.L4045:
	ldr	r3, .L4187+40
	ldr	r3, [r3]
	ldrb	r6, [r3, #89]	@ zero_extendqisi2
	str	r3, [sp, #28]
	ldr	r3, .L4187+44
	uxth	r7, r6
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r7
	bhi	.L4113
	cmp	r7, #2
	mov	fp, r7
	it	cs
	movcs	fp, #2
.L4056:
	ldr	r3, .L4187+48
	ldr	r5, .L4187+4
	ldrb	r8, [r3]	@ zero_extendqisi2
	cmp	r8, #3
	bne	.L4057
	ldr	r3, .L4187+52
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L4058
	ldrh	r3, [r5, #2102]
	mov	r1, r6
	mov	r0, r3
	str	r3, [sp, #12]
	bl	__aeabi_idiv
	ldr	r3, .L4187+56
	uxth	r4, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L4059
	ldr	r3, .L4187+60
	ldrh	r3, [r3, r0, lsl #1]
	cmp	r3, #0
	ite	eq
	moveq	r3, #1
	movne	r3, #2
.L4179:
	str	r3, [sp, #16]
	smulbb	r7, r7, r4
	ldr	r3, [sp, #12]
	subs	r7, r3, r7
	uxth	r3, r7
	str	r3, [sp, #20]
.L4061:
	ldr	r3, [sp, #16]
	ldr	r10, .L4187+60
	mul	r3, fp, r3
	str	r3, [sp, #24]
	ldr	r3, .L4187+64
	ldrh	r1, [r3]
	ldr	r3, .L4187+68
	muls	r1, r6, r1
	ldrb	r3, [r3]	@ zero_extendqisi2
	movs	r6, #0
	subs	r1, r1, r3
	ldr	r3, .L4187+56
	ldrb	r8, [r3]	@ zero_extendqisi2
	ldr	r3, .L4187+72
	ldr	r7, [r3]
	ldrh	r3, [r5, #20]
	str	r3, [sp, #32]
	ldr	r3, .L4187+4
.L4065:
	ldr	r0, [sp, #24]
	uxth	ip, r6
	mov	r2, ip
	cmp	ip, r0
	bge	.L4121
	ldr	r0, [sp, #12]
	add	r2, r2, r0
	cmp	r2, r1
	blt	.L4066
	cmp	r8, #0
	beq	.L4121
	ldrh	r0, [r10, r4, lsl #1]
	cmp	r0, r4
	bcc	.L4067
.L4121:
	movs	r3, #1
	str	r3, [sp, #24]
	b	.L4063
.L4113:
	mov	fp, #1
	b	.L4056
.L4059:
	ldr	r3, .L4187+76
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L4115
	sub	r3, r4, #62
	cmp	r3, #2160
	bcs	.L4116
	mov	r1, r8
	mov	r0, r4
	bl	__aeabi_uidivmod
	uxth	r1, r1
	cmp	r1, #0
	ite	ne
	movne	r3, #1
	moveq	r3, #2
	b	.L4179
.L4115:
	movs	r3, #1
	b	.L4179
.L4116:
	movs	r3, #2
	b	.L4179
.L4058:
	ldr	r3, .L4187+80
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L4062
	ldrh	r3, [r5, #2102]
	add	r1, r6, r6, lsl #1
	mov	r0, r3
	str	r3, [sp, #12]
	bl	__aeabi_idiv
	uxth	r4, r0
	muls	r0, r6, r0
	ldr	r3, [sp, #12]
	ldr	r2, .L4187+84
	sub	r0, r0, r0, lsl #2
	add	r0, r0, r3
	smull	r2, r3, r0, r2
	sub	r0, r3, r0, asr #31
	uxth	r3, r0
	str	r3, [sp, #20]
	ldr	r3, .L4187+88
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L4118
	add	r4, r4, r4, lsl #1
	uxth	r4, r4
.L4118:
	str	r8, [sp, #16]
	b	.L4061
.L4188:
	.align	2
.L4187:
	.word	.LANCHOR85
	.word	.LANCHOR71
	.word	.LANCHOR234
	.word	.LC0
	.word	.LANCHOR56
	.word	.LANCHOR14
	.word	.LC234
	.word	.LANCHOR131
	.word	.LC235
	.word	.LANCHOR110
	.word	.LANCHOR10
	.word	.LANCHOR80
	.word	.LANCHOR79
	.word	.LANCHOR36
	.word	.LANCHOR124
	.word	.LANCHOR235
	.word	.LANCHOR86
	.word	.LANCHOR224
	.word	.LANCHOR163
	.word	.LANCHOR217
	.word	.LANCHOR84
	.word	1431655766
	.word	.LANCHOR37
.L4062:
	ldrh	r10, [r5, #2102]
	mov	r1, r6
	mov	r0, r10
	bl	__aeabi_idiv
	ldr	r3, .L4189
	smulbb	r7, r0, r7
	str	r8, [sp, #16]
	ldrh	r3, [r3, r0, lsl #1]
	sub	r10, r10, r7
	lsrs	r4, r3, #3
	and	r3, r3, #7
	str	r3, [sp, #24]
	uxth	r3, r10
	str	r3, [sp, #20]
	mla	r3, r6, r4, r3
	add	r3, r3, r3, lsl #1
	uxth	r3, r3
	str	r3, [sp, #12]
	ldr	r3, [sp, #24]
	cmp	r3, #1
	beq	.L4061
.L4063:
	ldr	r3, [sp, #16]
	ldrh	r2, [sp, #16]
	mul	r3, fp, r3
	str	r3, [sp, #40]
	lsl	r3, fp, #1
	uxth	r3, r3
	str	r3, [sp, #44]
	ldrh	r3, [sp, #44]
	smulbb	r3, r3, r2
	ldr	r2, [sp, #12]
	subs	r3, r2, r3
	uxth	r3, r3
	str	r3, [sp, #48]
	movs	r3, #0
.L4183:
	str	r3, [sp, #36]
	ldr	r2, [sp, #40]
	ldrh	r6, [sp, #36]
	cmp	r6, r2
	str	r6, [sp, #32]
	blt	.L4095
	ldr	r3, .L4189+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #3
	bne	.L4096
	ldr	r3, .L4189+8
	ldrb	r1, [r3]	@ zero_extendqisi2
	cmp	r1, #0
	beq	.L4097
	movs	r1, #0
	subs	r2, r2, #1
.L4098:
	uxth	r3, r1
	adds	r1, r1, #1
	cmp	r3, r2
	blt	.L4099
	add	r3, sp, #80
	add	r2, r3, r2, lsl #2
	ldr	r3, [r2, #-24]
.L4184:
	movs	r2, #255
	strb	r2, [r3]
	ldrh	r3, [sp, #16]
	ldr	r0, [sp, #56]
	smulbb	r1, fp, r3
	uxtb	r1, r1
	bl	sblk_prog_page
	b	.L4100
.L4057:
	ldr	r3, .L4189+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L4064
	ldrh	r3, [r5, #2102]
	mov	r1, r6
	mov	r0, r3
	str	r3, [sp, #12]
	bl	__aeabi_idiv
	uxth	r4, r0
	ldr	r3, [sp, #12]
	smulbb	r7, r7, r4
	subs	r7, r3, r7
	uxth	r3, r7
	str	r3, [sp, #20]
	movs	r3, #1
.L4180:
	str	r3, [sp, #16]
	b	.L4061
.L4064:
	ldrh	r3, [r5, #2102]
	mov	r1, r6
	mov	r0, r3
	str	r3, [sp, #12]
	bl	__aeabi_idiv
	uxth	r4, r0
	ldr	r3, [sp, #12]
	smulbb	r7, r7, r4
	subs	r7, r3, r7
	uxth	r3, r7
	str	r3, [sp, #20]
	movs	r3, #2
	b	.L4180
.L4067:
	tst	ip, #1
	beq	.L4121
.L4066:
	ldr	r0, [r7, r2, lsl #2]
	adds	r0, r0, #1
	bne	.L4069
	ldrh	r5, [r3, #22]
	ldr	r0, [sp, #32]
	cmp	r5, r0
	bcs	.L4044
	cmp	r8, #0
	beq	.L4070
	ldrh	r0, [r10, r4, lsl #1]
	cmp	r0, r4
	bcs	.L4070
	tst	ip, #1
	beq	.L4070
	ldr	r0, [r7, r0, lsl #2]
.L4181:
	str	r0, [r7, r2, lsl #2]
.L4069:
	adds	r6, r6, #1
	b	.L4065
.L4070:
	mov	r0, r5
	str	r3, [sp, #36]
	bl	gc_get_src_ppa_from_index
	ldr	r3, [sp, #36]
	adds	r5, r5, #1
	strh	r5, [r3, #22]	@ movhi
	b	.L4181
.L4095:
	ldr	r3, [sp, #12]
	ldr	r2, [sp, #32]
	adds	r7, r3, r2
	ldr	r3, .L4189+16
	ldr	r3, [r3]
	ldrb	r3, [r3, r7]	@ zero_extendqisi2
	cmp	r3, #255
	bne	.L4072
	movs	r0, #0
	bl	buf_alloc
	mov	r5, r0
	cbnz	r0, .L4073
	bl	sblk_wait_write_queue_completed
	bl	ftl_write_completed
	bl	gc_write_completed
	bl	gc_free_temp_buf
	mov	r0, r5
	bl	buf_alloc
	mov	r5, r0
	cmp	r0, #0
	beq	.L4044
.L4073:
	ldr	r3, .L4189+16
	ldrb	r2, [r5, #1]	@ zero_extendqisi2
	ldr	r3, [r3]
	strb	r2, [r3, r7]
	ldr	r2, .L4189+20
	ldrb	r3, [r2, #7]	@ zero_extendqisi2
	adds	r3, r3, #1
	strb	r3, [r2, #7]
	ldr	r3, [sp, #12]
	adds	r3, r6, r3
	strh	r3, [r5, #32]	@ movhi
	ldrb	r3, [sp, #24]	@ zero_extendqisi2
	strb	r3, [r5, #45]
	ldr	r3, .L4189+24
	ldrh	r2, [r3]
	ldr	r3, .L4189+28
	ldrb	r0, [r3]	@ zero_extendqisi2
	ldr	r3, [sp, #28]
	ldrb	r3, [r3, #89]	@ zero_extendqisi2
	muls	r3, r2, r3
	subs	r3, r3, r0
	cmp	r7, r3
	blt	.L4074
	ldr	r1, .L4189+32
	ldrb	r1, [r1]	@ zero_extendqisi2
	cbz	r1, .L4075
	ldr	r1, .L4189+36
	ldrh	r1, [r1, r4, lsl #1]
	cmp	r1, r4
	bcs	.L4075
	lsls	r1, r6, #31
	bmi	.L4074
.L4075:
	ldr	r1, .L4189+40
	cmp	r0, #2
	mov	ip, #-1
	ldr	r1, [r1]
	str	ip, [r1, r7, lsl #2]
	bne	.L4076
	cmp	r7, r3
	ldr	r10, .L4189+68
	bne	.L4077
	ldrh	r2, [r10]
	ldr	r0, [r5, #4]
	bl	ftl_memcpy
	ldr	r3, .L4189+44
	movs	r1, #0
	ldr	r0, [r5, #12]
	ldrb	r2, [r3]	@ zero_extendqisi2
	lsls	r2, r2, #1
	bl	ftl_memset
	ldr	r8, [r5, #12]
	ldr	r3, .L4189+48
	ldr	r0, [r5, #4]
	ldrh	r1, [r10]
	str	r3, [r8]
	bl	js_hash
	ldr	r3, .L4189+52
	str	r0, [r8, #4]
	ldr	r3, [r3]
	ldr	r3, [r3, #132]
	str	r3, [r8, #8]
	movs	r3, #0
	str	r3, [r8, #12]
.L4078:
	ldr	r3, [r5, #12]
	movs	r2, #0
	str	r2, [r3, #16]
.L4072:
	ldr	r3, .L4189+16
	add	r2, sp, #80
	ldr	r3, [r3]
	ldrb	r5, [r3, r7]	@ zero_extendqisi2
	str	r3, [sp, #52]
	ldr	r3, [sp, #32]
	add	r1, r2, r3, lsl #2
	ldr	r2, .L4189+56
	add	r3, r5, r5, lsl #1
	add	r3, r2, r3, lsl #4
	str	r3, [r1, #-24]
	movs	r1, #48
	mla	r1, r1, r5, r2
	ldrb	r3, [sp, #24]	@ zero_extendqisi2
	strb	r3, [r1, #45]
	movs	r3, #2
	strh	r3, [r1, #34]	@ movhi
	ldr	r3, .L4189+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #3
	bne	.L4086
	ldr	r3, .L4189+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L4087
	ldr	r3, .L4189+32
	and	r2, r6, #1
	add	r10, r2, r4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L4088
	ldr	r3, .L4189+36
	ldrh	r3, [r3, r4, lsl #1]
	cmp	r3, r4
	bcs	.L4088
	cmp	r2, #0
	it	ne
	movne	r10, r3
.L4088:
	ldr	r3, .L4189+56
	mov	r8, #48
	ldr	r1, [sp, #16]
	mov	r0, r6
	mla	r8, r8, r5, r3
	bl	__aeabi_uidiv
	ldr	r3, [sp, #20]
	ldr	r2, .L4189+60
	uxtah	r0, r3, r0
	ldr	r3, [sp, #28]
	ldrh	r2, [r2]
	add	r0, r3, r0, lsl #1
	ldrh	r3, [r0, #96]
	mla	r10, r2, r3, r10
	orr	r3, r10, #50331648
	str	r3, [r8, #24]
.L4093:
	ldr	r2, .L4189+56
	movs	r3, #48
	mla	r5, r3, r5, r2
	ldr	r3, .L4189+64
	ldr	r3, [r3]
	ldr	r1, [r5, #24]
	ldrh	r2, [r5, #32]
	str	r1, [r3, r2, lsl #2]
	b	.L4112
.L4190:
	.align	2
.L4189:
	.word	.LANCHOR236
	.word	.LANCHOR79
	.word	.LANCHOR36
	.word	.LANCHOR81
	.word	.LANCHOR83
	.word	.LANCHOR71
	.word	.LANCHOR86
	.word	.LANCHOR224
	.word	.LANCHOR124
	.word	.LANCHOR235
	.word	.LANCHOR162
	.word	.LANCHOR131
	.word	-178307901
	.word	.LANCHOR10
	.word	.LANCHOR56
	.word	.LANCHOR111
	.word	.LANCHOR164
	.word	.LANCHOR221
.L4077:
	ldr	r0, .L4191
	ldrh	r3, [r10]
	ldrb	r8, [r0]	@ zero_extendqisi2
	ldr	r0, [r5, #4]
	mul	r8, r2, r8
	rsb	r8, r3, r8, lsl #2
	lsrs	r3, r3, #2
	mov	r2, r8
	add	r1, r1, r3, lsl #2
	bl	ftl_memcpy
	ldr	r3, .L4191+4
	movs	r1, #0
	ldr	r0, [r5, #12]
	ldrb	r2, [r3]	@ zero_extendqisi2
	lsls	r2, r2, #1
	bl	ftl_memset
	ldr	r10, [r5, #12]
	mov	r1, r8
	ldr	r3, .L4191+8
	ldr	r0, [r5, #4]
	str	r3, [r10]
	bl	js_hash
	ldr	r3, .L4191+12
	str	r0, [r10, #4]
	ldr	r3, [r3]
	ldr	r3, [r3, #132]
	str	r3, [r10, #8]
	movs	r3, #1
	str	r3, [r10, #12]
	b	.L4078
.L4076:
	ldr	r10, .L4191
	ldr	r0, [r5, #4]
	ldrb	r8, [r10]	@ zero_extendqisi2
	mul	r2, r2, r8
	lsls	r2, r2, #2
	bl	ftl_memcpy
	ldr	r3, .L4191+16
	ldr	r1, .L4191+4
	ldrh	r2, [r3]
	ldrb	r3, [r10]	@ zero_extendqisi2
	ldrb	r1, [r1]	@ zero_extendqisi2
	muls	r3, r2, r3
	cmp	r1, r3, asr #6
	lsl	r2, r3, #2
	ldr	r1, .L4191+20
	it	lt
	ldrlt	r3, .L4191+24
	mov	r0, r2
	ldr	r1, [r1]
	itt	lt
	ldrhlt	r3, [r3]
	sublt	r2, r3, r2
	ldr	r3, [r5, #4]
	add	r0, r0, r3
	bl	ftl_memcpy
	ldr	r3, .L4191+4
	movs	r1, #0
	ldr	r0, [r5, #12]
	ldrb	r2, [r3]	@ zero_extendqisi2
	lsls	r2, r2, #1
	bl	ftl_memset
	ldr	r8, [r5, #12]
	ldr	r3, .L4191+8
	ldr	r2, .L4191
	ldr	r0, [r5, #4]
	str	r3, [r8]
	ldr	r3, .L4191+16
	ldrb	r1, [r2]	@ zero_extendqisi2
	ldrh	r3, [r3]
	muls	r1, r3, r1
	lsls	r1, r1, #2
	bl	js_hash
	ldr	r3, .L4191+12
	str	r0, [r8, #4]
	ldr	r3, [r3]
	ldr	r3, [r3, #132]
	str	r3, [r8, #8]
	b	.L4078
.L4074:
	ldr	r3, .L4191+20
	movs	r1, #1
	mov	r0, r5
	ldr	r3, [r3]
	ldr	r3, [r3, r7, lsl #2]
	str	r3, [r5, #24]
	bl	sblk_read_page
	ldr	r3, [r5, #36]
	adds	r1, r3, #1
	beq	.L4080
	cmp	r3, #512
	bne	.L4084
.L4080:
	ldr	r3, .L4191+28
	movs	r0, #1
	ldr	r2, [r5, #24]
	ldrh	r1, [r3]
	ldr	r3, .L4191+32
	ldrb	r3, [r3]	@ zero_extendqisi2
	lsrs	r2, r2, r1
	rsb	r3, r3, #24
	subs	r3, r3, r1
	ldr	r1, .L4191+36
	lsl	r3, r0, r3
	subs	r3, r3, #1
	ldrb	r1, [r1]	@ zero_extendqisi2
	and	r0, r3, r2
	bl	__aeabi_uidiv
	movs	r1, #0
	uxth	r0, r0
	bl	ftl_sblk_dump
	ldr	r3, [r5, #36]
	adds	r2, r3, #1
	beq	.L4082
	cmp	r3, #512
	bne	.L4084
.L4082:
	ldr	r3, [r5, #12]
	mov	r2, #-1
	str	r2, [r3, #4]
	ldr	r3, [r5, #36]
	cmp	r3, r2
	beq	.L4083
	cmp	r3, #512
	bne	.L4084
.L4083:
	movw	r2, #1223
	ldr	r1, .L4191+40
	ldr	r0, .L4191+44
	bl	printf
.L4084:
	ldr	r3, [r5, #12]
	ldr	r2, .L4191+48
	ldr	r1, [r3, #4]
	ldr	r2, [r2]
	cmp	r1, r2
	itt	cs
	movcs	r2, #-1
	strcs	r2, [r3, #4]
	ldr	r2, .L4191+52
	ldr	r1, [r3, #4]
	ldr	r2, [r2]
	str	r1, [r2, r7, lsl #2]
	ldr	r2, [r5, #24]
	str	r2, [r3, #8]
	b	.L4078
.L4087:
	ldr	r3, .L4191+56
	ldr	r2, .L4191+60
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L4090
	umull	r2, r3, r6, r2
	ldr	r2, [sp, #20]
	ldr	r0, [sp, #28]
	lsrs	r3, r3, #1
	uxtah	r2, r2, r3
	add	r3, r3, r3, lsl #1
	add	r2, r0, r2, lsl #1
	ldr	r0, .L4191+64
	subs	r3, r6, r3
	ldrh	r2, [r2, #96]
	ldrh	r0, [r0]
	mla	r2, r0, r2, r4
	uxtah	r3, r2, r3
.L4186:
	str	r3, [r1, #24]
	movs	r2, #48
	ldr	r3, .L4191+68
	mla	r5, r2, r5, r3
	ldr	r2, .L4191+60
	ldr	r3, .L4191+72
	ldr	r1, [r3]
	umull	r2, r3, r6, r2
	ldr	r2, [r5, #24]
	ldrh	r0, [r5, #32]
	lsrs	r3, r3, #1
	add	r3, r3, r3, lsl #1
	subs	r3, r6, r3
	lsls	r3, r3, #24
	add	r3, r3, #16777216
	orrs	r3, r3, r2
	str	r3, [r1, r0, lsl #2]
.L4112:
	ldr	r3, .L4191+76
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L4094
	ldr	r3, .L4191+80
	ldrh	r3, [r3, r4, lsl #1]
	cmp	r3, r4
	bcs	.L4094
	lsls	r3, r6, #31
	bpl	.L4094
	ldr	r2, [sp, #52]
	movs	r3, #255
	ldr	r1, [sp, #48]
	strb	r3, [r2, r7]
	add	r2, sp, #80
	ldr	r3, [sp, #32]
	add	r3, r2, r3, lsl #2
	ldrh	r2, [sp, #48]
	ldr	r3, [r3, #-24]
	strh	r2, [r3, #32]	@ movhi
	ldrb	r2, [r3, #1]	@ zero_extendqisi2
	ldr	r3, .L4191+84
	ldr	r3, [r3]
	strb	r2, [r3, r1]
	mov	r2, #-1
	ldr	r3, .L4191+20
	ldr	r3, [r3]
	str	r2, [r3, r7, lsl #2]
.L4094:
	ldr	r3, [sp, #36]
	adds	r3, r3, #1
	b	.L4183
.L4090:
	umull	r2, r3, r6, r2
	ldr	r2, [sp, #20]
	ubfx	r3, r3, #1, #16
	add	r3, r3, r2
	ldr	r2, [sp, #28]
	add	r3, r2, r3, lsl #1
	ldr	r2, .L4191+64
	ldrh	r3, [r3, #96]
	ldrh	r2, [r2]
	mla	r3, r2, r3, r4
	b	.L4186
.L4086:
	cmp	r3, #2
	bne	.L4093
	ldr	r3, .L4191+88
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L4092
	ldr	r2, [sp, #20]
	ldr	r3, [sp, #32]
	add	r3, r3, r2
	ldr	r2, [sp, #28]
	add	r3, r2, r3, lsl #1
	ldr	r2, .L4191+64
	ldrh	r3, [r3, #96]
	ldrh	r2, [r2]
	mla	r3, r2, r3, r4
.L4182:
	orr	r3, r3, #33554432
	str	r3, [r1, #24]
	b	.L4093
.L4092:
	ldr	r3, [sp, #20]
	ldr	r2, [sp, #28]
	add	r3, r3, r6, lsr #1
	add	r3, r2, r3, lsl #1
	ldr	r2, .L4191+64
	ldrh	r3, [r3, #96]
	ldrh	r2, [r2]
	mla	r3, r2, r3, r4
	and	r2, r6, #1
	add	r3, r3, r2
	b	.L4182
.L4099:
	add	r0, sp, #80
	add	r5, sp, #80
	add	r0, r0, r3, lsl #2
	add	r3, r5, r3, lsl #2
	ldr	r3, [r3, #-20]
	ldr	r0, [r0, #-24]
	ldrb	r3, [r3, #1]	@ zero_extendqisi2
	strb	r3, [r0]
	b	.L4098
.L4192:
	.align	2
.L4191:
	.word	.LANCHOR80
	.word	.LANCHOR131
	.word	-178307901
	.word	.LANCHOR10
	.word	.LANCHOR86
	.word	.LANCHOR163
	.word	.LANCHOR221
	.word	.LANCHOR75
	.word	.LANCHOR32
	.word	.LANCHOR76
	.word	.LANCHOR234
	.word	.LC0
	.word	.LANCHOR128
	.word	.LANCHOR162
	.word	.LANCHOR37
	.word	-1431655765
	.word	.LANCHOR111
	.word	.LANCHOR56
	.word	.LANCHOR164
	.word	.LANCHOR124
	.word	.LANCHOR235
	.word	.LANCHOR83
	.word	.LANCHOR81
.L4097:
	ldr	r3, .L4193
	ldrb	r2, [r3]	@ zero_extendqisi2
	ldr	r3, [sp, #56]
	cmp	r2, #0
	beq	.L4101
	strb	r1, [r3, #44]
.L4185:
	mov	r2, fp
	add	r1, sp, #68
	add	r0, sp, #56
	bl	sblk_xlc_prog_pages
.L4100:
	ldr	r3, .L4193
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L4109
	add	r3, fp, fp, lsl #1
	uxth	fp, r3
.L4110:
	ldr	r3, .L4193+4
	ldr	r2, [r3]
	ldr	r3, [r2, #52]
	add	r3, r3, fp
	str	r3, [r2, #52]
	ldr	r2, .L4193+8
	ldrh	r3, [r2, #2102]
	add	r3, r3, fp
	uxth	r3, r3
	strh	r3, [r2, #2102]	@ movhi
	ldr	r2, .L4193+12
	ldrh	r1, [r2]
	ldr	r2, [sp, #28]
	ldrb	r2, [r2, #89]	@ zero_extendqisi2
	muls	r2, r1, r2
	cmp	r3, r2
	itttt	ge
	ldrge	r3, .L4193+16
	movge	r2, #0
	ldrge	r3, [r3]
	strhge	r2, [r3, #86]	@ movhi
	bl	gc_write_completed
	b	.L4044
.L4101:
	ldr	r1, [sp, #24]
	cmp	r1, #1
	bne	.L4102
	movs	r2, #9
.L4104:
	strb	r2, [r3, #44]
	b	.L4185
.L4102:
	ldr	r1, [sp, #24]
	cmp	r1, #2
	it	eq
	moveq	r2, #13
	b	.L4104
.L4096:
	ldr	r3, .L4193+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L4105
	ldr	r3, .L4193+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L4106
.L4105:
	ldr	r2, [sp, #40]
	subs	r1, r2, #1
.L4107:
	uxth	r2, r3
	adds	r3, r3, #1
	cmp	r2, r1
	blt	.L4108
	add	r3, sp, #80
	add	r1, r3, r1, lsl #2
	ldr	r3, [r1, #-24]
	b	.L4184
.L4106:
	mov	r1, fp
	add	r0, sp, #56
	bl	sblk_3d_mlc_prog_pages
	b	.L4100
.L4108:
	add	r0, sp, #80
	add	r5, sp, #80
	add	r0, r0, r2, lsl #2
	add	r2, r5, r2, lsl #2
	ldr	r2, [r2, #-20]
	ldr	r0, [r0, #-24]
	ldrb	r2, [r2, #1]	@ zero_extendqisi2
	strb	r2, [r0]
	b	.L4107
.L4109:
	ldr	r3, .L4193+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L4123
	ldr	r3, .L4193+28
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L4110
	ldrh	r3, [sp, #16]
	ldr	r2, .L4193+32
	ldrb	r2, [r2]	@ zero_extendqisi2
	smulbb	r3, fp, r3
	uxth	r3, r3
	cbz	r2, .L4124
	ldr	r2, .L4193+36
	ldrh	r2, [r2, r4, lsl #1]
	cmp	r2, r4
	it	cs
	movcs	fp, r3
	b	.L4110
.L4123:
	ldr	fp, [sp, #44]
	b	.L4110
.L4124:
	mov	fp, r3
	b	.L4110
.L4194:
	.align	2
.L4193:
	.word	.LANCHOR84
	.word	.LANCHOR110
	.word	.LANCHOR71
	.word	.LANCHOR86
	.word	.LANCHOR10
	.word	.LANCHOR81
	.word	.LANCHOR82
	.word	.LANCHOR36
	.word	.LANCHOR124
	.word	.LANCHOR235
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
	ldr	r3, .L4392
	ldr	r2, .L4392+4
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #48
	ldr	r4, .L4392+8
	mov	r10, r2
	ldrh	r7, [r3]
	ldrh	r6, [r2]
	ldr	r1, .L4392+12
	ldrb	r3, [r4]	@ zero_extendqisi2
	add	r6, r6, r7
	str	r0, [sp, #32]
	ldr	r5, [r1]
	uxth	r6, r6
	mov	r8, r1
	cmp	r3, #6
	bhi	.L4310
	tbh	[pc, r3, lsl #1]
.L4198:
	.2byte	(.L4197-.L4198)/2
	.2byte	(.L4199-.L4198)/2
	.2byte	(.L4200-.L4198)/2
	.2byte	(.L4201-.L4198)/2
	.2byte	(.L4202-.L4198)/2
	.2byte	(.L4203-.L4198)/2
	.2byte	(.L4204-.L4198)/2
	.p2align 1
.L4203:
	ldr	r5, .L4392+16
	movs	r7, #0
.L4205:
	bl	gc_check_data_one_wl
	mov	r10, r0
	cmp	r0, #0
	beq	.L4306
	ldr	r3, [r8]
	movs	r6, #0
	strh	r6, [r5, #52]	@ movhi
	ldrh	r0, [r3, #80]
	bl	ftl_free_sblk
	ldr	r1, .L4392+20
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
	b	.L4389
.L4197:
	ldr	r3, .L4392+24
	ldr	r2, .L4392+28
	ldr	r1, .L4392+32
	ldrh	r3, [r3]
	str	r2, [sp, #36]
	ldrh	r1, [r1]
	add	r7, r7, r3
	ldrh	r3, [r2]
	uxth	r7, r7
	add	r3, r3, r1
	ldrh	r1, [r5, #80]
	uxth	r3, r3
	str	r3, [sp, #28]
	movw	r3, #65535
	cmp	r1, r3
	ldr	r3, [sp, #32]
	beq	.L4206
	cbnz	r3, .L4207
	ldr	r3, .L4392+36
	ldrh	r3, [r3]
	cmp	r6, r3, lsl #1
	blt	.L4207
.L4310:
	movs	r5, #16
	b	.L4195
.L4207:
	ldr	r10, .L4392+80
	movs	r1, #5
	ldr	fp, .L4392+76
	ldrh	r0, [r10]
	adds	r0, r0, #1
	uxth	r0, r0
	strh	r0, [r10]	@ movhi
	bl	zftl_get_gc_node
	movw	r3, #65535
	mov	ip, r10
	cmp	r0, r3
	beq	.L4208
	ldr	r1, .L4392+40
	ldr	lr, .L4392+72
	ldr	r2, .L4392+44
	ldr	r1, [r1]
	ldrh	lr, [lr]
	ldr	r3, [r2]
	mov	r10, r2
	ldrh	r1, [r1, r0, lsl #1]
	adds	r3, r3, #1
	cmp	lr, r1
	str	r3, [r2]
	bcs	.L4209
	ldr	r2, .L4392+48
	ldrh	r2, [r2]
	cmp	r3, r2, lsr #4
	bls	.L4208
	ldr	r3, .L4392+52
	ldrh	r3, [r3]
	cmp	r3, r1
	bls	.L4208
.L4209:
	ldrb	r2, [fp]	@ zero_extendqisi2
	movs	r1, #0
	bl	gc_add_sblk
	cbz	r0, .L4210
	movs	r3, #1
	strb	r3, [r4]
	movs	r3, #0
	str	r3, [r10]
	b	.L4310
.L4208:
	movs	r3, #0
	strh	r3, [ip]	@ movhi
.L4210:
	cmp	r7, #15
	bls	.L4312
	ldr	r3, .L4392+56
	ldrh	r2, [r3]
	ldr	r3, .L4392+60
	ldrh	r3, [r3]
	cmp	r2, r3
	bhi	.L4312
	ldr	r3, [sp, #28]
	cmp	r3, #0
	ite	eq
	moveq	r10, #2
	movne	r10, #1
.L4211:
	ldr	r3, .L4392+64
	ldr	r3, [r3]
	lsls	r3, r3, #23
	bpl	.L4212
	ldr	r3, [r8]
	ldrh	r1, [r5, #80]
	ldrb	r2, [fp]	@ zero_extendqisi2
	ldr	r0, .L4392+68
	str	r1, [sp, #16]
	ldrh	r1, [r3, #122]
	str	r1, [sp, #12]
	ldrh	r1, [r3, #120]
	str	r1, [sp, #8]
	movw	r1, #2662
	ldrh	r3, [r3, #124]
	str	r7, [sp]
	str	r3, [sp, #4]
	mov	r3, r6
	bl	printf
.L4212:
	movs	r2, #1
	mov	r1, r10
	ldrb	r0, [fp]	@ zero_extendqisi2
	bl	gc_search_src_blk
	cmp	r0, #0
	ble	.L4213
.L4214:
	movs	r3, #1
.L4390:
	strb	r3, [r4]
	b	.L4310
.L4312:
	mov	r10, #2
	b	.L4211
.L4213:
	movs	r2, #1
	movs	r1, #3
	ldrb	r0, [fp]	@ zero_extendqisi2
	bl	gc_search_src_blk
	cmp	r0, #0
	bgt	.L4214
	b	.L4310
.L4206:
	cmp	r3, #1
	bne	.L4216
	bl	gc_scan_static_data
	ldr	r3, [r8]
	ldr	fp, .L4392+76
	ldrh	r3, [r3, #122]
	cbz	r3, .L4217
.L4218:
	movs	r3, #1
	strb	r3, [fp]
	b	.L4390
.L4393:
	.align	2
.L4392:
	.word	.LANCHOR107
	.word	.LANCHOR103
	.word	.LANCHOR159
	.word	.LANCHOR10
	.word	.LANCHOR71
	.word	.LANCHOR110
	.word	.LANCHOR105
	.word	.LANCHOR97
	.word	.LANCHOR99
	.word	.LANCHOR87
	.word	.LANCHOR9
	.word	.LANCHOR160
	.word	.LANCHOR6
	.word	.LANCHOR100
	.word	.LANCHOR93
	.word	.LANCHOR101
	.word	.LANCHOR14
	.word	.LC236
	.word	.LANCHOR95
	.word	.LANCHOR85
	.word	.LANCHOR96
.L4217:
	bl	gc_static_wearleveling
	mov	r5, r0
	cmp	r0, #0
	bne	.L4218
	ldr	r10, .L4394+16
	cmp	r7, #0
	beq	.L4219
	ldr	r3, [sp, #28]
	ldr	r2, .L4394
	cmp	r6, r3
	bcs	.L4220
	ldrh	r3, [r2]
	cmp	r3, r6
	bhi	.L4221
.L4220:
	ldr	r3, [sp, #28]
	ldrh	r2, [r2]
	adds	r3, r6, r3
	cmp	r3, r2
	blt	.L4221
	ldr	r3, .L4394+4
	ldrh	r2, [r3]
	ldr	r3, .L4394+8
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L4219
.L4221:
	movs	r1, #1
	movs	r0, #16
	strb	r1, [fp]
	str	r1, [sp, #40]
	bl	zftl_get_gc_node.part.9
	movw	r2, #65535
	cmp	r0, r2
	beq	.L4222
	ldr	r2, .L4394+12
	ldr	r3, .L4394+16
	ldr	r2, [r2]
	ldrh	r3, [r3]
	ldrh	r2, [r2, r0, lsl #1]
	cmp	r2, r3
	bcs	.L4222
	cmp	r6, #2
	ldr	r1, [sp, #40]
	bls	.L4222
	ldr	r3, .L4394+20
	movs	r2, #0
	strb	r2, [fp]
	str	r2, [r3]
	bl	gc_add_sblk
	cmp	r0, #0
	bne	.L4214
.L4222:
	movs	r1, #3
	movs	r0, #0
	bl	zftl_get_gc_node
	movw	r2, #65535
	cmp	r0, r2
	beq	.L4223
	ldr	r2, .L4394+12
	ldr	r3, .L4394+16
	ldr	r2, [r2]
	ldrh	r3, [r3]
	ldrh	r2, [r2, r0, lsl #1]
	cmp	r2, r3
	bcs	.L4223
	cmp	r6, #2
	bls	.L4223
	ldr	r3, .L4394+20
	movs	r2, #0
	movs	r1, #1
	strb	r2, [fp]
	str	r2, [r3]
	bl	gc_add_sblk
	cmp	r0, #0
	bne	.L4214
.L4223:
	ldr	r2, .L4394+24
	ldrh	r3, [r10]
	ldr	r1, .L4394+28
	ldrh	fp, [r2]
	adds	r3, r3, #1
	ldr	r2, .L4394+20
	uxth	r3, r3
	cmp	r3, fp, lsr #5
	strh	r3, [r10]	@ movhi
	str	r2, [sp, #44]
	itt	hi
	movhi	r3, #4
	strhhi	r3, [r10]	@ movhi
	mov	r10, #0
	strh	r10, [r1]	@ movhi
	ldr	r1, .L4394+32
	ldr	r3, [r2]
	strh	r10, [r1]	@ movhi
	ldr	r1, .L4394+36
	adds	r3, r3, #1
	str	r3, [r2]
	strh	r10, [r1]	@ movhi
	ldr	r1, .L4394+40
	ldrh	r1, [r1]
	cmp	r3, r1, lsr #5
	ldr	r3, .L4394+44
	ldr	r1, .L4394+4
	bls	.L4225
	ldrh	r0, [r1]
	cmp	r0, r7
	bls	.L4225
	movs	r1, #5
	mov	r0, r10
	str	r3, [sp, #40]
	bl	zftl_get_gc_node
	movw	r1, #65535
	ldr	r3, [sp, #40]
	cmp	r0, r1
	ldr	r2, [sp, #44]
	bne	.L4226
.L4379:
	movs	r5, #16
.L4227:
	ldr	r3, [r8]
	movs	r1, #1
	ldr	fp, .L4394+44
	ldrh	r3, [r3, #124]
	strb	r1, [fp]
	mov	r8, fp
	cmp	r3, #0
	beq	.L4232
	movs	r3, #0
	strb	r1, [r4]
	strb	r3, [fp]
.L4195:
	mov	r0, r5
	add	sp, sp, #48
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L4226:
	ldr	r1, .L4394+12
	ldr	r1, [r1]
	ldrh	r1, [r1, r0, lsl #1]
	ldr	r0, .L4394+48
	ldrb	r0, [r0]	@ zero_extendqisi2
	mul	fp, fp, r0
	cmp	r1, fp
	bgt	.L4379
	str	r10, [r2]
	movs	r2, #4
.L4386:
	movs	r1, #2
.L4378:
	ldrb	r0, [r3]	@ zero_extendqisi2
	bl	gc_search_src_blk
	uxth	r0, r0
	cmp	r0, #0
	beq	.L4379
	b	.L4214
.L4225:
	ldr	r2, .L4394+8
	ldrh	r1, [r1]
	ldrh	r2, [r2]
	cmp	r1, r2
	bcc	.L4230
	movs	r2, #1
	b	.L4386
.L4230:
	ldr	r2, [sp, #36]
	ldrh	r2, [r2]
	cbnz	r2, .L4231
	ldr	r2, .L4394+52
	ldrh	r2, [r2]
	cmp	r2, #8
	bls	.L4227
.L4231:
	movs	r2, #4
	movs	r1, #1
	b	.L4378
.L4219:
	ldr	r3, .L4394+24
	ldrh	r2, [r3]
	ldrh	r3, [r10]
	cmp	r3, r2, lsr #5
	itt	cs
	movcs	r3, #4
	strhcs	r3, [r10]	@ movhi
	b	.L4379
.L4216:
	ldr	r3, .L4394+56
	ldrh	r3, [r3]
	cmp	r3, r6
	bcs	.L4379
	ldrh	r3, [r5, #124]
	cmp	r3, #0
	beq	.L4310
	b	.L4379
.L4232:
	ldr	r2, .L4394+56
	ldrh	r0, [r2]
	mov	r10, r2
	cmp	r6, r0
	bcs	.L4233
	cmp	r7, #0
	beq	.L4234
	cmp	r7, #16
	bls	.L4235
	ldr	r2, .L4394+4
	ldrh	r0, [r2]
	ldr	r2, .L4394+8
	ldrh	r2, [r2]
	cmp	r0, r2
	bhi	.L4235
	movs	r2, #4
	mov	r0, r1
	str	r3, [sp, #28]
	bl	gc_search_src_blk
	uxth	r0, r0
	ldr	r3, [sp, #28]
	cbnz	r0, .L4236
.L4382:
	movs	r2, #4
	movs	r1, #3
	ldrb	r0, [fp]	@ zero_extendqisi2
	b	.L4381
.L4236:
	mov	r0, r3
	movs	r1, #5
	bl	zftl_get_gc_node
	movw	r3, #65535
	cmp	r0, r3
	beq	.L4239
	ldr	r1, .L4394+12
	ldr	r6, .L4394+24
	ldr	r2, .L4394+20
	ldr	r1, [r1]
	ldrh	r6, [r6]
	ldr	r3, [r2]
	ldrh	r1, [r1, r0, lsl #1]
	adds	r3, r3, #1
	cmp	r6, r1
	str	r3, [r2]
	mov	r6, r2
	bcs	.L4240
	ldr	r2, .L4394+40
	ldrh	r2, [r2]
	cmp	r3, r2, lsr #4
	bls	.L4239
	ldr	r3, .L4394+60
	ldrh	r3, [r3]
	cmp	r3, r1
	bls	.L4239
.L4240:
	ldrb	r2, [r8]	@ zero_extendqisi2
	movs	r1, #0
	bl	gc_add_sblk
	ldr	r3, .L4394+64
	movs	r2, #1
	str	r2, [r3]
	movs	r3, #0
	str	r3, [r6]
.L4239:
	movs	r3, #1
	b	.L4385
.L4235:
	movs	r2, #1
	movs	r1, #2
	mov	r0, r2
	bl	gc_search_src_blk
	uxth	r0, r0
	cmp	r0, #0
	bne	.L4239
	ldrb	r0, [r8]	@ zero_extendqisi2
	movs	r2, #4
	movs	r1, #3
.L4381:
	bl	gc_search_src_blk
	uxth	r0, r0
.L4237:
	cmp	r0, #0
	bne	.L4239
	b	.L4195
.L4234:
	cmp	r6, #16
	strb	r7, [fp]
	bls	.L4242
	movs	r2, #4
	movs	r1, #3
	mov	r0, r7
	b	.L4381
.L4242:
	mov	r2, r1
	mov	r0, r7
	bl	gc_search_src_blk
	uxth	r0, r0
	cmp	r0, #0
	bne	.L4239
	b	.L4382
.L4233:
	ldr	r1, [sp, #32]
	cmp	r1, #1
	bne	.L4195
	cmp	r6, r0, lsl #1
	bge	.L4243
	ldr	r3, [sp, #28]
	cmp	r3, r7, lsr #1
	bcs	.L4244
	ldr	r3, .L4394+4
	ldrh	r1, [r3]
	ldr	r3, .L4394+8
	ldrh	r3, [r3]
	cmp	r1, r3
	bcs	.L4244
	ldr	r3, .L4394
	ldrh	r3, [r3]
	lsrs	r3, r3, #2
	strh	r3, [r2]	@ movhi
	b	.L4195
.L4395:
	.align	2
.L4394:
	.word	.LANCHOR98
	.word	.LANCHOR93
	.word	.LANCHOR101
	.word	.LANCHOR9
	.word	.LANCHOR161
	.word	.LANCHOR160
	.word	.LANCHOR95
	.word	.LANCHOR90
	.word	.LANCHOR91
	.word	.LANCHOR92
	.word	.LANCHOR6
	.word	.LANCHOR85
	.word	.LANCHOR80
	.word	.LANCHOR99
	.word	.LANCHOR87
	.word	.LANCHOR100
	.word	.LANCHOR122
.L4244:
	movs	r0, #8
	bl	zftl_get_gc_node.part.9
	movw	r2, #65535
	cmp	r0, r2
	beq	.L4245
	ldr	r2, .L4396
	ldr	r2, [r2]
	ldrh	r3, [r2, r0, lsl #1]
	cmp	r3, #3
	bhi	.L4245
	cbz	r6, .L4245
	movs	r2, #0
	movs	r1, #1
	strb	r2, [r8]
	bl	gc_add_sblk
	cmp	r0, #0
	bne	.L4239
.L4245:
	movs	r1, #5
	movs	r0, #0
	bl	zftl_get_gc_node
	movw	r3, #65535
	mov	fp, r0
	cmp	r0, r3
	bne	.L4246
.L4251:
	cmp	r7, #1
	bhi	.L4247
.L4248:
	ldr	r3, [sp, #28]
	cmp	r6, r3
	ldr	r6, .L4396+4
	bcs	.L4255
	movs	r7, #0
	movs	r0, #4
	strb	r7, [r8]
	bl	zftl_get_gc_node.part.9
	movw	r3, #65535
	cmp	r0, r3
	beq	.L4255
	ldr	r3, .L4396
	ldr	r3, [r3]
	ldrh	r2, [r3, r0, lsl #1]
	ldr	r3, .L4396+8
	ldrh	r1, [r3]
	ldr	r3, .L4396+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	muls	r3, r1, r3
	cmp	r2, r3, asr #1
	ble	.L4257
.L4255:
	ldrh	r3, [r6]
	lsrs	r3, r3, #2
	strh	r3, [r10]	@ movhi
	b	.L4195
.L4246:
	ldr	r2, .L4396+16
	ldr	r1, .L4396+20
	ldr	r3, [r2]
	ldrh	r1, [r1]
	adds	r3, r3, #1
	str	r3, [r2]
	cmp	r3, r1, lsr #4
	bls	.L4249
	ldr	r3, .L4396
	movs	r1, #0
	str	r1, [r2]
	ldr	r3, [r3]
	ldrh	r2, [r3, r0, lsl #1]
	ldr	r3, .L4396+24
	ldrh	r3, [r3]
	cmp	r2, r3
	bcs	.L4249
	movs	r3, #1
	mov	r2, r3
	strb	r3, [r8]
	str	r3, [sp, #32]
	bl	gc_add_sblk
	ldr	r3, [sp, #32]
	cbz	r0, .L4249
.L4385:
	strb	r3, [r4]
	b	.L4195
.L4249:
	ldr	r3, .L4396
	ldr	r3, [r3]
	ldrh	r2, [r3, fp, lsl #1]
	ldr	r3, .L4396+8
	ldrh	r3, [r3]
	cmp	r2, r3, lsr #1
	bhi	.L4250
	movs	r2, #0
	movs	r1, #1
	mov	r0, fp
	bl	gc_add_sblk
	b	.L4239
.L4250:
	ldr	r3, [sp, #36]
	ldr	r1, .L4396+28
	ldrh	r3, [r3]
	ldrh	r1, [r1]
	add	r3, r3, r1
	ldr	r1, .L4396+4
	ldrh	r1, [r1]
	cmp	r3, r1, lsl #1
	ble	.L4251
	ldr	r3, .L4396+24
	ldrh	r3, [r3]
	cmp	r3, r2
	bcc	.L4248
	b	.L4251
.L4247:
	cmp	r7, #16
	mov	r1, #1
	strb	r1, [r8]
	bls	.L4252
	ldr	r3, .L4396+32
	ldrh	r2, [r3]
	ldr	r3, .L4396+36
	ldrh	r3, [r3]
	cmp	r2, r3
	bhi	.L4252
	movs	r2, #4
	mov	r0, r1
.L4388:
	bl	gc_search_src_blk
	uxth	r0, r0
	cbnz	r0, .L4253
	movs	r2, #4
	movs	r1, #3
	ldrb	r0, [r8]	@ zero_extendqisi2
	bl	gc_search_src_blk
	uxth	r0, r0
.L4253:
	ldr	r3, [sp, #28]
	cmp	r6, r3, lsr #1
	ldr	r3, .L4396+4
	ldrh	r3, [r3]
	bls	.L4383
	lsrs	r3, r3, #2
.L4384:
	strh	r3, [r10]	@ movhi
	b	.L4237
.L4252:
	movs	r2, #1
	movs	r1, #2
	mov	r0, r2
	b	.L4388
.L4257:
	movs	r2, #4
	movs	r1, #3
	mov	r0, r7
	bl	gc_search_src_blk
	ldrh	r3, [r6]
	uxth	r0, r0
.L4383:
	lsrs	r3, r3, #1
	b	.L4384
.L4243:
	ldr	r1, .L4396+4
	mov	r5, r3
	ldrh	r1, [r1]
	lsrs	r1, r1, #2
	strh	r1, [r2]	@ movhi
	b	.L4195
.L4199:
	ldr	r5, .L4396+40
	movw	r3, #65535
	ldrh	r2, [r5]
	cmp	r2, r3
	bne	.L4258
	bl	gc_get_src_blk
	strh	r0, [r5]	@ movhi
.L4258:
	ldrh	r2, [r5]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L4259
	ldr	r1, .L4396+20
	ldrh	r1, [r1]
	cmp	r1, r2
	it	ls
	strhls	r3, [r5]	@ movhi
.L4259:
	ldrh	r6, [r5]
	movw	r3, #65535
	cmp	r6, r3
	beq	.L4391
	ldr	r3, .L4396+44
	ldrh	r1, [r5, #52]
	ldr	r3, [r3]
	add	r3, r3, r6, lsl #2
	cbz	r1, .L4261
	ldr	r0, .L4396+48
	movs	r2, #0
.L4262:
	uxth	r5, r2
	cmp	r1, r5
	bhi	.L4263
.L4261:
	ldrb	r3, [r3, #2]	@ zero_extendqisi2
	and	r2, r3, #224
	cmp	r2, #224
	beq	.L4264
	tst	r3, #192
	bne	.L4265
.L4264:
	ldr	r3, .L4396
	ldr	r3, [r3]
	ldrh	r3, [r3, r6, lsl #1]
	cbz	r3, .L4267
	movw	r2, #3153
	ldr	r1, .L4396+52
	ldr	r0, .L4396+56
	bl	printf
	b	.L4267
.L4263:
	ldrh	r5, [r0, #2]!
	adds	r2, r2, #1
	cmp	r5, r6
	bne	.L4262
.L4267:
	ldr	r3, .L4396+40
	movw	r2, #65535
	strh	r2, [r3]	@ movhi
	b	.L4310
.L4265:
	movs	r3, #2
	b	.L4390
.L4200:
	bl	gc_scan_src_blk
	adds	r0, r0, #1
	bne	.L4268
	movs	r3, #3
	b	.L4390
.L4268:
	ldr	r3, .L4396+40
	movw	r1, #65535
	ldrh	r2, [r3]
	mov	r5, r3
	cmp	r2, r1
	beq	.L4214
	ldrh	r1, [r3, #20]
	cbz	r1, .L4269
	movs	r2, #4
	strb	r2, [r4]
	movs	r2, #0
	strh	r2, [r3, #22]	@ movhi
	b	.L4310
.L4269:
	movs	r3, #1
	strb	r3, [r4]
	ldr	r4, .L4396
	ldr	r1, [r4]
	ldrh	r2, [r1, r2, lsl #1]
	cbz	r2, .L4270
	movw	r2, #3183
	ldr	r1, .L4396+52
	ldr	r0, .L4396+56
	bl	printf
.L4270:
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
	bhi	.L4271
	strh	r3, [r5, #26]	@ movhi
	b	.L4267
.L4271:
	strh	r4, [r5, #26]	@ movhi
	bl	ftl_flush
	bl	pm_flush
	bl	ftl_ext_info_flush
	mov	r0, r4
	bl	ftl_info_flush
	b	.L4267
.L4201:
	ldr	r7, .L4396+40
	mov	r5, r7
.L4355:
	bl	gc_scan_src_blk_one_page
	ldr	r3, .L4396+8
	ldrh	r2, [r7, #2]
	ldrh	r3, [r3]
	cmp	r2, r3
	bcs	.L4273
	cmp	r6, #7
	bls	.L4355
	b	.L4310
.L4397:
	.align	2
.L4396:
	.word	.LANCHOR9
	.word	.LANCHOR98
	.word	.LANCHOR95
	.word	.LANCHOR80
	.word	.LANCHOR160
	.word	.LANCHOR6
	.word	.LANCHOR100
	.word	.LANCHOR99
	.word	.LANCHOR93
	.word	.LANCHOR101
	.word	.LANCHOR71
	.word	.LANCHOR7
	.word	.LANCHOR71+52
	.word	.LANCHOR237
	.word	.LC0
.L4273:
	ldrh	r3, [r7, #20]
	ldrh	r1, [r7]
	cbz	r3, .L4274
	movs	r2, #4
	strb	r2, [r4]
	movs	r2, #0
	ldr	r4, .L4398
	strh	r2, [r7, #22]	@ movhi
	ldr	r2, [r4]
	ldrh	r2, [r2, r1, lsl #1]
	cmp	r3, r2
	beq	.L4275
	ldr	r0, .L4398+4
	ldr	r0, [r0]
	lsls	r0, r0, #21
	bpl	.L4275
	ldr	r0, .L4398+8
	bl	printf
.L4275:
	ldr	r3, [r4]
	ldrh	r2, [r5]
	ldrh	r2, [r3, r2, lsl #1]
	ldrh	r3, [r5, #20]
	cmp	r2, r3
	beq	.L4276
	movw	r2, #3226
	ldr	r1, .L4398+12
	ldr	r0, .L4398+16
	bl	printf
.L4276:
	ldrh	r1, [r5, #20]
	ldrh	r2, [r5]
	ldr	r3, [r4]
	strh	r1, [r3, r2, lsl #1]	@ movhi
	b	.L4310
.L4274:
	ldr	r3, .L4398+20
	ldr	r6, [r3]
	movs	r3, #1
	strb	r3, [r4]
	ldr	r3, .L4398+4
	add	r6, r6, r1, lsl #2
	ldr	r3, [r3]
	lsls	r7, r3, #23
	bpl	.L4277
	ldrb	r2, [r6, #2]	@ zero_extendqisi2
	ldr	r0, .L4398+24
	lsrs	r2, r2, #5
	bl	printf
.L4277:
	ldrb	r3, [r6, #2]	@ zero_extendqisi2
	and	r2, r3, #224
	cmp	r2, #224
	beq	.L4278
	tst	r3, #192
	bne	.L4279
.L4278:
	movw	r2, #3236
	ldr	r1, .L4398+12
	ldr	r0, .L4398+16
	bl	printf
.L4279:
	ldrh	r0, [r5]
	bl	ftl_free_sblk
	movw	r3, #65535
	strh	r3, [r5]	@ movhi
	ldrh	r3, [r5, #26]
	adds	r3, r3, #1
	uxth	r3, r3
	cmp	r3, #8
	bhi	.L4280
	strh	r3, [r5, #26]	@ movhi
	b	.L4310
.L4280:
	movs	r3, #0
	strh	r3, [r5, #26]	@ movhi
.L4389:
	bl	flt_sys_flush
	b	.L4310
.L4202:
	ldrh	r2, [r5, #80]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L4281
	ldr	r3, .L4398+28
	ldrb	r7, [r3]	@ zero_extendqisi2
	cmp	r7, #1
	bne	.L4281
	ldr	r6, .L4398+32
	bl	ftl_flush
	movs	r1, #5
	ldrh	r0, [r6, #2106]
	cbz	r0, .L4282
	mov	r0, r7
.L4282:
	bl	zftl_gc_get_free_sblk
	movw	r3, #65535
	mov	r4, r0
	cmp	r0, r3
	beq	.L4284
	ldr	r3, .L4398+20
	ldr	r7, [r3]
	add	r7, r7, r0, lsl #2
	ldrb	r3, [r7, #2]	@ zero_extendqisi2
	tst	r3, #224
	beq	.L4285
	movw	r2, #3270
	ldr	r1, .L4398+12
	ldr	r0, .L4398+16
	bl	printf
.L4285:
	ldrb	r3, [r7, #2]	@ zero_extendqisi2
	and	r3, r3, #15
	orr	r3, r3, #176
	strb	r3, [r7, #2]
.L4309:
	movs	r1, #1
	mov	r0, r4
	bl	ftl_erase_sblk
	movs	r3, #5
	add	r1, r5, #96
	strb	r3, [r5, #84]
	mov	r0, r4
	bl	ftl_get_blk_list_in_sblk
	ldr	r3, .L4398+36
	uxtb	r0, r0
	movs	r7, #0
	ldr	r10, .L4398+64
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
	ldr	r5, .L4398+40
	ldrb	r2, [r5]	@ zero_extendqisi2
	muls	r2, r3, r2
	ldr	r3, .L4398+44
	ldr	r0, [r3]
	lsls	r2, r2, #2
	bl	ftl_memset
	ldrh	r3, [r10]
	movs	r1, #255
	ldrb	r2, [r5]	@ zero_extendqisi2
	muls	r2, r3, r2
	ldr	r3, .L4398+48
	ldr	r0, [r3]
	lsls	r2, r2, #2
	bl	ftl_memset
	ldrh	r3, [r10]
	movs	r1, #255
	ldrb	r2, [r5]	@ zero_extendqisi2
	muls	r2, r3, r2
	ldr	r3, .L4398+52
	ldr	r0, [r3]
	bl	ftl_memset
	ldr	r3, [r8]
	movw	r2, #65535
	strh	r2, [r3, #128]	@ movhi
	strh	r2, [r3, #130]	@ movhi
	str	r4, [r3, #132]
	bl	pm_flush
	bl	ftl_ext_info_flush
	ldr	r3, .L4398+56
	mov	r0, r7
	strh	r7, [r6, #52]	@ movhi
	ldr	r3, [r3]
	strh	r4, [r3, #126]	@ movhi
	mov	r3, #-1
	strh	r7, [r6, #2102]	@ movhi
	strh	r7, [r6, #2104]	@ movhi
	strh	r7, [r6, #2108]	@ movhi
	str	r3, [r6, #2112]
	bl	ftl_info_flush
	b	.L4310
.L4281:
	ldr	r3, [sp, #32]
	ldr	r7, .L4398+28
	cmp	r3, #1
	ite	ne
	movne	fp, #1
	moveq	fp, #4
	cmp	r6, #15
	ldr	r6, .L4398+32
	it	ls
	addls	fp, fp, #4
.L4288:
	add	fp, fp, #-1
	uxtb	fp, fp
	cmp	fp, #255
	beq	.L4310
	bl	gc_do_copy_back
	ldrb	r3, [r7]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L4289
	ldr	r3, .L4398+60
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #3
	bhi	.L4290
	bl	ftl_write_commit
.L4290:
	ldrh	r2, [r6, #22]
	ldrh	r3, [r6, #20]
	cmp	r2, r3
	bcc	.L4288
	movs	r3, #1
	strb	r3, [r4]
	ldr	r4, .L4398
	bl	ftl_write_commit
	bl	ftl_flush
	ldrh	r1, [r6]
	ldr	r2, [r4]
	ldrh	r2, [r2, r1, lsl #1]
	cbz	r2, .L4292
	movw	r2, #3354
	ldr	r1, .L4398+12
	ldr	r0, .L4398+16
	bl	printf
.L4292:
	ldrh	r0, [r6]
	ldr	r3, [r4]
	ldrh	r3, [r3, r0, lsl #1]
	cbnz	r3, .L4293
	bl	ftl_free_sblk
	b	.L4267
.L4293:
	movs	r2, #1
	movs	r1, #0
	bl	gc_add_sblk
	b	.L4267
.L4399:
	.align	2
.L4398:
	.word	.LANCHOR9
	.word	.LANCHOR14
	.word	.LC237
	.word	.LANCHOR237
	.word	.LC0
	.word	.LANCHOR7
	.word	.LC238
	.word	.LANCHOR85
	.word	.LANCHOR71
	.word	.LANCHOR95
	.word	.LANCHOR80
	.word	.LANCHOR162
	.word	.LANCHOR163
	.word	.LANCHOR83
	.word	.LANCHOR110
	.word	.LANCHOR58
	.word	.LANCHOR86
.L4289:
	ldrh	r3, [r6, #2108]
	cmp	r3, #0
	beq	.L4294
	movs	r3, #0
	ldr	r7, .L4400
	strh	r3, [r6, #2108]	@ movhi
	bl	sblk_wait_write_queue_completed
	bl	gc_write_completed
	ldr	r0, [r6, #2112]
	adds	r5, r0, #1
	beq	.L4295
	ldr	r3, .L4400+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L4296
	ldr	r3, .L4400+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L4297
.L4296:
	ldr	r3, [r7]
	ldr	r2, [r3, #156]
	ldr	r3, .L4400+12
	cmp	r2, r3
	bne	.L4297
	ldr	r3, .L4400+16
	ldrh	r1, [r3]
	ldr	r3, .L4400+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	lsrs	r0, r0, r1
	rsb	r3, r3, #24
	subs	r2, r3, r1
	movs	r3, #1
	lsls	r3, r3, r2
	ldr	r2, .L4400+24
	subs	r3, r3, #1
	ldrb	r1, [r2]	@ zero_extendqisi2
	ands	r0, r0, r3
	bl	__aeabi_uidiv
	ldr	r3, .L4400+28
	ldr	r3, [r3]
	add	r5, r3, r0, lsl #2
	ldrb	r2, [r5, #2]	@ zero_extendqisi2
	lsls	r1, r2, #28
	bpl	.L4295
	ldr	ip, .L4400+60
	ldrh	r1, [r10]
	ldrh	ip, [ip]
	adds	r1, r1, #8
	cmp	r1, ip
	bge	.L4295
	ldr	r1, .L4400+32
	bfc	r2, #3, #2
	strb	r2, [r5, #2]
	ldr	r2, [r3, r0, lsl #2]
	ldrh	r1, [r1]
	ldrh	r5, [r3, r0, lsl #2]
	ubfx	r2, r2, #11, #8
	muls	r1, r2, r1
	ubfx	ip, r5, #0, #11
	lsrs	r2, r2, #3
	add	r1, r1, r1, lsl #1
	add	r1, ip, r1, asr #2
	bfi	r5, r1, #0, #11
	strh	r5, [r3, r0, lsl #2]	@ movhi
	ldr	r1, [r3, r0, lsl #2]
	bfi	r1, r2, #11, #8
	str	r1, [r3, r0, lsl #2]
.L4295:
	ldr	r3, [r8]
	movs	r5, #0
	str	r5, [r6, #2112]
	strh	r5, [r6, #52]	@ movhi
	ldrh	r0, [r3, #80]
	bl	ftl_free_sblk
	ldr	r0, [r6, #8]
	movw	r3, #65535
	ldr	r2, [r8]
	ldr	r1, [r7]
	strh	r3, [r2, #80]	@ movhi
	strh	r3, [r1, #126]	@ movhi
	strh	r3, [r2, #130]	@ movhi
	cbz	r0, .L4298
	bl	zbuf_free
.L4298:
	str	r5, [r6, #8]
	bl	flt_sys_flush
	movw	r2, #3413
	ldr	r1, .L4400+36
	ldr	r0, .L4400+40
	strb	r5, [r4]
	bl	printf
	b	.L4310
.L4297:
	bl	ftl_mask_bad_block
	b	.L4295
.L4294:
	ldrh	r3, [r5, #86]
	ldrh	r2, [r6, #22]
	cmp	r3, #1
	ldrh	r3, [r6, #20]
	bls	.L4299
	cmp	r2, r3
	bcc	.L4288
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
	b	.L4310
.L4299:
	cmp	r2, r3
	mov	r1, #5
	strb	r1, [r4]
	bcc	.L4300
	ldrh	r3, [r6, #52]
	adds	r2, r3, #1
	strh	r2, [r6, #52]	@ movhi
	add	r3, r6, r3, lsl #1
	ldrh	r2, [r6]
	strh	r2, [r3, #54]	@ movhi
	movw	r3, #65535
	strh	r3, [r6]	@ movhi
.L4300:
	bl	ftl_flush
	bl	sblk_wait_write_queue_completed
	bl	gc_write_completed
	ldr	r3, [r8]
	ldrh	r2, [r5, #80]
	strh	r2, [r3, #128]	@ movhi
	bl	pm_flush
	bl	ftl_ext_info_flush
	movs	r3, #0
	ldr	r2, .L4400+44
	strh	r3, [r6, #12]	@ movhi
	ldr	r3, .L4400+48
	ldrb	r2, [r2]	@ zero_extendqisi2
	ldrh	r3, [r3]
	strh	r3, [r6, #14]	@ movhi
	ldr	r3, .L4400+52
	ldrb	r3, [r3]	@ zero_extendqisi2
	strh	r3, [r6, #16]	@ movhi
	cbz	r2, .L4301
	ldr	r2, .L4400+56
	ldrh	r2, [r2]
	strh	r2, [r6, #14]	@ movhi
	movs	r2, #1
	strh	r2, [r6, #16]	@ movhi
.L4301:
	cmp	r3, #2
	bne	.L4303
	ldrh	r3, [r6, #14]
	lsls	r3, r3, #1
	strh	r3, [r6, #14]	@ movhi
	ldr	r3, .L4400+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L4303
	movs	r3, #1
	strh	r3, [r6, #16]	@ movhi
.L4303:
	movs	r3, #0
	strh	r3, [r6, #18]	@ movhi
	b	.L4310
.L4306:
	ldrh	r2, [r5, #12]
	ldrh	r3, [r5, #14]
	cmp	r2, r3
	bcc	.L4307
	movs	r3, #6
	ldr	r0, [r5, #8]
	strb	r3, [r4]
	bl	zbuf_free
	str	r10, [r5, #8]
	b	.L4310
.L4307:
	cmp	r6, #15
	bls	.L4205
	ldr	r3, [sp, #32]
	cmp	r3, #1
	bne	.L4310
	adds	r7, r7, #1
	uxtb	r7, r7
	cmp	r7, #4
	bls	.L4205
	b	.L4310
.L4204:
	bl	gc_update_l2p_map_new
	bl	gc_free_src_blk
	bl	ftl_flush
	movw	r6, #65535
	bl	pm_flush
	strh	r6, [r5, #80]	@ movhi
	bl	ftl_ext_info_flush
	ldr	r3, .L4400
	movs	r0, #0
	ldr	r3, [r3]
	strh	r6, [r3, #126]	@ movhi
	bl	ftl_info_flush
.L4391:
	movs	r3, #0
	b	.L4390
.L4284:
	movw	r2, #3277
	ldr	r1, .L4400+36
	ldr	r0, .L4400+40
	bl	printf
	b	.L4309
.L4401:
	.align	2
.L4400:
	.word	.LANCHOR110
	.word	.LANCHOR124
	.word	.LANCHOR81
	.word	1145785929
	.word	.LANCHOR75
	.word	.LANCHOR32
	.word	.LANCHOR76
	.word	.LANCHOR7
	.word	.LANCHOR8
	.word	.LANCHOR237
	.word	.LC0
	.word	.LANCHOR36
	.word	.LANCHOR95
	.word	.LANCHOR79
	.word	.LANCHOR86
	.word	.LANCHOR98
	.size	zftl_do_gc, .-zftl_do_gc
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
	ldr	r2, .L4481
	movs	r3, #255
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r5, #0
	ldr	r7, .L4481+4
	sub	sp, sp, #24
	strb	r3, [r2]
	ldr	r2, .L4481+8
	ldr	r1, .L4481+12
	ldr	r0, .L4481+16
	strb	r5, [r2]
	ldr	r2, .L4481+20
	ldr	r6, .L4481+24
	strb	r3, [r2]
	ldr	r2, .L4481+28
	strb	r5, [r2]
	ldr	r2, .L4481+32
	strb	r3, [r2]
	mov	r2, #-1
	ldr	r3, .L4481+36
	strb	r5, [r3]
	ldr	r3, .L4481+40
	str	r2, [r3]
	bl	printf
	ldrb	r8, [r7, #12]	@ zero_extendqisi2
	ldr	r3, .L4481+44
	ldrb	fp, [r7, #9]	@ zero_extendqisi2
	mov	r1, r8
	strb	r8, [r3]
	ldr	r3, .L4481+48
	strb	fp, [r3]
	ldrh	r3, [r7, #10]
	str	r3, [sp]
	ldr	r3, .L4481+52
	ldrh	r2, [sp]
	ldr	r0, [sp]
	strh	r2, [r3]	@ movhi
	bl	__aeabi_idiv
	ldr	r2, .L4481+56
	mov	r3, r0
	ldr	r1, .L4481+60
	ldrh	r10, [r7, #14]
	ldrb	r4, [r2]	@ zero_extendqisi2
	ldr	r2, .L4481+64
	strh	r0, [r6]	@ movhi
	ldr	r0, .L4481+68
	strb	r4, [r2]
	ldrb	r2, [r7, #13]	@ zero_extendqisi2
	str	r6, [sp, #8]
	str	r0, [sp, #12]
	strb	r2, [r1]
	smulbb	r4, r4, r2
	ldr	r2, .L4481+72
	strh	r10, [r2]	@ movhi
	lsl	r2, fp, #9
	uxtb	r4, r4
	uxth	r2, r2
	strb	r4, [r0]
	str	r2, [sp, #4]
	ldr	r2, .L4481+76
	ldrh	r1, [sp, #4]
	strh	r1, [r2]	@ movhi
	ldr	r2, .L4481+80
	ldrh	r1, [r2]
	ldr	r2, .L4481+84
	strh	r1, [r2]	@ movhi
	movs	r2, #1
.L4403:
	cmp	r1, r2
	uxth	r0, r5
	add	r5, r5, #1
	bcs	.L4404
	ldr	r1, .L4481+88
	subs	r2, r0, #1
	movs	r6, #0
	movs	r5, #1
	strh	r2, [r1]	@ movhi
	ldr	r2, [sp]
	mul	r2, r2, fp
	mul	r0, r2, r10
	lsrs	r7, r0, #21
.L4405:
	cmp	r7, r5
	uxth	r1, r6
	add	r6, r6, #1
	bcs	.L4406
	mov	r5, #1892352
	subs	r1, r1, #1
	mul	r6, r5, r4
	uxth	r1, r1
	ldr	r7, .L4481+92
	lsr	r10, r10, #4
	muls	r0, r4, r0
	str	r2, [sp, #20]
	str	r3, [sp, #16]
	lsl	r5, r6, r1
	ldr	r1, .L4481+96
	add	r6, r5, #24576
	str	r0, [r7]
	str	r5, [r1]
	mov	r0, r6
	ldr	r1, .L4481+100
	str	r6, [r1]
	mov	r1, fp
	bl	__aeabi_uidiv
	ldr	r3, [sp, #4]
	ldr	r1, .L4481+104
	ldr	fp, .L4481+172
	add	ip, r3, #-1
	str	r0, [r1]
	add	r0, ip, r0, lsl #2
	mov	r1, r3
	bl	__aeabi_uidiv
	ldr	r3, [sp, #16]
	strh	r0, [fp]	@ movhi
	uxth	r0, r0
	lsls	r0, r0, #4
	mul	r1, r4, r3
	bl	__aeabi_idiv
	ldr	r2, [sp, #20]
	ldr	r3, .L4481+108
	mul	r1, r4, r2
	strh	r0, [r3]	@ movhi
	mov	r0, r6
	mov	r6, fp
	subs	r1, r1, #1
	bl	__aeabi_uidiv
	ldr	r3, .L4481+112
	adds	r0, r0, #8
	cmp	r10, #79
	ldr	ip, .L4481+212
	it	ls
	movls	r2, #80
	ldr	lr, .L4481+132
	strh	r0, [r3]	@ movhi
	mov	r1, #48
	ldr	r3, .L4481+116
	ldr	r0, .L4481+120
	strh	r10, [r3]	@ movhi
	it	ls
	strhls	r2, [r3]	@ movhi
	mov	r3, #2000
	strh	r3, [ip]	@ movhi
	movs	r3, #50
	strh	r3, [r0]	@ movhi
	mov	r2, #256
	ldr	r3, .L4481+124
	cmp	r8, #2
	mov	r8, r0
	strh	r2, [r3]	@ movhi
	ldr	r2, .L4481+128
	strh	r1, [r2]	@ movhi
	mov	r1, #32
	strh	r1, [lr]	@ movhi
	mov	r10, r2
	mov	lr, ip
	beq	.L4408
	ldr	fp, .L4481+216
	ldrb	fp, [fp]	@ zero_extendqisi2
	cmp	fp, #0
	beq	.L4409
.L4408:
	movs	r2, #150
	movs	r1, #12
	strh	r2, [r8]	@ movhi
	movs	r2, #64
	strh	r2, [r10]	@ movhi
	ldr	r2, .L4481+132
	strh	r1, [r2]	@ movhi
	ldr	r1, .L4481+136
	ldrb	r1, [r1]	@ zero_extendqisi2
	cbnz	r1, .L4410
	movs	r1, #4
	strh	r1, [r2]	@ movhi
	mov	r2, #600
	strh	r2, [lr]	@ movhi
	movs	r2, #128
	strh	r2, [r3]	@ movhi
.L4410:
	ldr	r3, .L4481+140
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L4412
	movs	r3, #200
	strh	r3, [r8]	@ movhi
	mov	r3, #2000
	strh	r3, [lr]	@ movhi
.L4412:
	ldr	r3, .L4481+144
	movs	r2, #0
	str	r2, [r3]
	movs	r2, #1
	ldr	r3, .L4481+148
	strb	r2, [r3]
	ldr	r2, [sp]
	muls	r4, r2, r4
	ldr	r2, [sp, #4]
	cmp	r2, r4, lsl #2
	ldr	r4, .L4481+152
	itt	lt
	movlt	r2, #2
	strblt	r2, [r3]
	ldr	r3, [r4]
	lsls	r3, r3, #19
	bpl	.L4415
	mov	r1, r5
	ldr	r0, .L4481+156
	bl	printf
.L4415:
	ldr	r3, [r4]
	lsls	r5, r3, #19
	bpl	.L4416
	ldr	r1, [r7]
	ldr	r0, .L4481+160
	bl	printf
.L4416:
	ldr	r3, [r4]
	lsls	r0, r3, #19
	bpl	.L4417
	ldr	r3, .L4481+104
	ldr	r0, .L4481+164
	ldr	r1, [r3]
	bl	printf
.L4417:
	ldr	r3, [r4]
	lsls	r1, r3, #19
	bpl	.L4418
	ldr	r3, .L4481+100
	ldr	r0, .L4481+168
	ldr	r1, [r3]
	bl	printf
.L4418:
	ldr	r3, [r4]
	lsls	r2, r3, #19
	bpl	.L4419
	ldr	r3, .L4481+172
	ldr	r0, .L4481+176
	ldrh	r1, [r3]
	bl	printf
.L4419:
	ldr	r3, [r4]
	ldr	r8, .L4481+76
	tst	r3, #4096
	beq	.L4420
	ldrh	r1, [r8]
	ldr	r0, .L4481+180
	bl	printf
.L4420:
	ldr	r3, [r4]
	lsls	r3, r3, #19
	bpl	.L4421
	ldr	r3, .L4481+108
	ldr	r0, .L4481+184
	ldrh	r1, [r3]
	bl	printf
.L4421:
	ldr	r3, [r4]
	lsls	r7, r3, #19
	bpl	.L4422
	ldr	r3, .L4481+116
	ldr	r0, .L4481+188
	ldrh	r1, [r3]
	bl	printf
.L4422:
	ldr	r3, [r4]
	lsls	r5, r3, #19
	bpl	.L4423
	ldr	r3, .L4481+112
	ldr	r0, .L4481+192
	ldrh	r1, [r3]
	bl	printf
.L4423:
	bl	zbuf_init
	mov	r0, #16384
	ldr	r5, .L4481+196
	bl	ftl_malloc
	ldr	r3, .L4481+200
	ldr	r7, .L4481+72
	str	r0, [r3]
	mov	r0, #16384
	bl	ftl_malloc
	str	r0, [r5]
	mov	r0, #16384
	bl	ftl_malloc
	ldr	r3, .L4481+204
	str	r0, [r3]
	movs	r0, #6
	ldrh	r3, [r7]
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L4481+208
	ldr	r2, [sp, #12]
	b	.L4482
.L4483:
	.align	2
.L4481:
	.word	.LANCHOR66
	.word	.LANCHOR33
	.word	.LANCHOR67
	.word	.LC239
	.word	.LC104
	.word	.LANCHOR133
	.word	.LANCHOR95
	.word	.LANCHOR134
	.word	.LANCHOR185
	.word	.LANCHOR129
	.word	.LANCHOR238
	.word	.LANCHOR79
	.word	.LANCHOR131
	.word	.LANCHOR86
	.word	.LANCHOR18
	.word	.LANCHOR76
	.word	.LANCHOR112
	.word	.LANCHOR80
	.word	.LANCHOR6
	.word	.LANCHOR221
	.word	.LANCHOR2
	.word	.LANCHOR111
	.word	.LANCHOR75
	.word	.LANCHOR239
	.word	.LANCHOR68
	.word	.LANCHOR240
	.word	.LANCHOR128
	.word	.LANCHOR155
	.word	.LANCHOR101
	.word	.LANCHOR98
	.word	.LANCHOR125
	.word	.LANCHOR152
	.word	.LANCHOR153
	.word	.LANCHOR8
	.word	.LANCHOR0
	.word	.LANCHOR37
	.word	.LANCHOR122
	.word	.LANCHOR224
	.word	.LANCHOR14
	.word	.LC240
	.word	.LC241
	.word	.LC242
	.word	.LC243
	.word	.LANCHOR204
	.word	.LC244
	.word	.LC245
	.word	.LC246
	.word	.LC247
	.word	.LC248
	.word	.LANCHOR200
	.word	.LANCHOR195
	.word	.LANCHOR190
	.word	.LANCHOR4
	.word	.LANCHOR126
	.word	.LANCHOR84
.L4482:
	str	r0, [r3]
	ldr	r3, [sp, #8]
	ldrb	r0, [r2]	@ zero_extendqisi2
	ldrh	r3, [r3]
	muls	r0, r3, r0
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L4484
	ldr	r2, [r5]
	ldrh	r5, [r7]
	str	r0, [r3]
	ldr	r3, .L4484+4
	str	r2, [r3]
	ldr	r3, [sp, #8]
	ldrh	r1, [r3]
	ldr	r3, [sp, #12]
	ldrb	r0, [r3]	@ zero_extendqisi2
	muls	r0, r1, r0
	ldr	r1, .L4484+8
	add	r3, r2, r0, lsl #3
	str	r3, [r1]
	lsls	r1, r0, #1
	ldr	r0, [r4]
	add	r1, r1, r5, lsr #1
	ldr	r5, .L4484+12
	add	r1, r2, r1, lsl #2
	lsls	r0, r0, #19
	str	r1, [r5]
	bpl	.L4424
	ldr	r0, .L4484+16
	bl	printf
.L4424:
	ldr	r2, [sp, #8]
	ldr	r1, [sp, #12]
	ldrh	r3, [r7]
	ldrh	r2, [r2]
	ldrb	r7, [r1]	@ zero_extendqisi2
	muls	r7, r2, r7
	ldrh	r2, [r6]
	lsls	r6, r3, #2
	add	r7, r3, r7, lsl #2
	ldr	r3, [r4]
	add	r6, r6, r2, lsl #2
	lsls	r7, r7, #1
	lsls	r2, r3, #19
	add	r7, r7, #632
	add	r6, r6, #704
	bpl	.L4425
	ldrh	r3, [r8]
	mov	r2, r6
	mov	r1, r7
	ldr	r0, .L4484+20
	bl	printf
.L4425:
	ldrh	r3, [r8]
	cmp	r7, r3
	bhi	.L4426
	cmp	r6, r3
	bls	.L4427
.L4426:
.L4480:
	b	.L4480
.L4404:
	lsls	r2, r2, #1
	b	.L4403
.L4406:
	lsls	r5, r5, #1
	b	.L4405
.L4409:
	ldr	r3, .L4484+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L4412
	mov	r3, #1200
	strh	r1, [r0]	@ movhi
	strh	r3, [ip]	@ movhi
	strh	r1, [r2]	@ movhi
	b	.L4412
.L4427:
	bl	sblk_init
	bl	ftl_info_blk_init
	adds	r3, r0, #1
	beq	.L4402
	bl	ftl_ext_info_init
	bl	gc_init
	movs	r0, #1
	ldr	r4, .L4484+28
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
	ldr	r3, .L4484+32
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L4429
	ldr	r2, [r4]
	ldr	r3, [r2, #68]
	adds	r3, r3, #1
	str	r3, [r2, #68]
.L4429:
	bl	ftl_ext_info_flush
	movs	r0, #0
	bl	ftl_info_flush
	bl	print_ftl_debug_info
	ldr	r3, [r5]
	ldrh	r3, [r3, #124]
	cbnz	r3, .L4436
	ldr	r3, .L4484+36
	ldr	r2, .L4484+40
	ldrh	r3, [r3]
	ldrh	r2, [r2]
	add	r3, r3, r2
	cmp	r3, #7
	ble	.L4436
.L4432:
	movs	r0, #0
.L4402:
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L4436:
	ldr	r6, .L4484+36
	mov	r4, #16384
.L4433:
	movs	r1, #1
	movs	r0, #0
	bl	zftl_do_gc
	movs	r1, #1
	mov	r0, r1
	bl	zftl_do_gc
	ldr	r3, [r5]
	ldrh	r2, [r3, #124]
	cbnz	r2, .L4431
	ldrh	r2, [r3, #80]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L4431
	ldr	r2, .L4484+40
	ldrh	r3, [r6]
	ldrh	r2, [r2]
	add	r3, r3, r2
	cmp	r3, #7
	bgt	.L4432
.L4431:
	subs	r4, r4, #1
	bne	.L4433
	b	.L4432
.L4485:
	.align	2
.L4484:
	.word	.LANCHOR118
	.word	.LANCHOR117
	.word	.LANCHOR9
	.word	.LANCHOR10
	.word	.LC249
	.word	.LC250
	.word	.LANCHOR36
	.word	.LANCHOR110
	.word	.LANCHOR198
	.word	.LANCHOR103
	.word	.LANCHOR107
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
	cbnz	r0, .L4487
	bl	zftl_init
	mov	r4, r0
.L4487:
	bl	idb_init
	mov	r1, r4
	ldr	r0, .L4488
	bl	printf
	mov	r0, r4
	pop	{r4, pc}
.L4489:
	.align	2
.L4488:
	.word	.LC251
	.size	rk_ftl_init, .-rk_ftl_init
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
	ldr	r3, .L4519
	sub	sp, sp, #24
	mov	r4, r0
	mov	r6, r1
	mov	r5, r2
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L4491
	ldr	r3, [r8]
	str	r3, [sp]
	mov	r3, r2
	mov	r2, r1
	mov	r1, r0
	ldr	r0, .L4519+4
	bl	printf
.L4491:
	cmp	r4, #0
	bne	.L4492
	ldr	r3, .L4519+8
	mov	r4, #24576
	ldr	r3, [r3]
.L4493:
	cmp	r3, r6
	bls	.L4511
	cmp	r3, r5
	bcc	.L4511
	adds	r2, r6, r5
	cmp	r3, r2
	bcc	.L4511
	ldr	fp, .L4519+36
	add	r4, r4, r6
	mov	r0, r4
	ldrb	r6, [fp]	@ zero_extendqisi2
	mov	r1, r6
	bl	__aeabi_uidiv
	mov	r10, r0
	subs	r0, r5, #1
	mov	r1, r6
	add	r0, r0, r4
	bl	__aeabi_uidiv
	sub	r6, r0, r10
	mov	r7, r10
	adds	r6, r6, #1
	str	r0, [sp, #12]
	str	fp, [sp, #16]
.L4495:
	cbnz	r6, .L4503
	bl	ftl_write_commit
	bl	ftl_flush
	movs	r1, #1
	mov	r0, r6
	bl	zftl_do_gc
	ldr	r3, .L4519+12
	ldr	r5, .L4519+16
	ldr	r4, .L4519+20
	ldr	r3, [r3]
	ldrh	r3, [r3, #124]
	cbnz	r3, .L4504
	ldrh	r3, [r5]
	ldrh	r2, [r4]
	add	r3, r3, r2
	cmp	r3, #11
	bgt	.L4506
.L4504:
	movs	r1, #1
	movs	r0, #0
.L4518:
	bl	zftl_do_gc
.L4506:
	ldrh	r3, [r5]
	ldrh	r2, [r4]
	add	r3, r3, r2
	cmp	r3, #7
	ble	.L4507
	movs	r0, #0
.L4490:
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L4492:
	cmp	r4, #3
	bhi	.L4511
	lsls	r4, r4, #13
	mov	r3, #8192
	b	.L4493
.L4503:
	ldr	r3, .L4519+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L4496
	ldr	r3, .L4519+28
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #2
	bhi	.L4496
	bl	ftl_write_commit
.L4496:
	movs	r0, #0
	bl	buf_alloc
	mov	fp, r0
	cbnz	r0, .L4497
	bl	ftl_write_commit
	b	.L4495
.L4497:
	ldr	r3, [sp, #16]
	movs	r2, #0
	strb	r2, [r0, #41]
	cmp	r7, r10
	ldrb	r2, [r3]	@ zero_extendqisi2
	strb	r2, [r0, #40]
	bne	.L4499
	mov	r1, r2
	mov	r0, r4
	str	r2, [sp, #20]
	bl	__aeabi_uidivmod
	ldr	r2, [sp, #20]
	uxtb	r1, r1
	strb	r1, [fp, #41]
	subs	r1, r2, r1
	uxtb	r1, r1
	cmp	r5, r1
	ite	cs
	strbcs	r1, [fp, #40]
	strbcc	r5, [fp, #40]
.L4501:
	ldrb	ip, [fp, #41]	@ zero_extendqisi2
	mov	r1, r8
	ldrb	r2, [fp, #40]	@ zero_extendqisi2
	subs	r6, r6, #1
	ldr	r0, [fp, #4]
	lsls	r2, r2, #9
	add	r0, r0, ip, lsl #9
	bl	ftl_memcpy
	ldr	r2, .L4519+32
	str	r7, [fp, #20]
	adds	r7, r7, #1
	ldr	r1, [r2]
	ldr	r2, [r1, #8]
	adds	r0, r2, #1
	str	r0, [r1, #8]
	mov	r0, fp
	str	r2, [fp, #16]
	bl	ftl_write_buf
	ldrb	r3, [fp, #40]	@ zero_extendqisi2
	add	r8, r8, r3, lsl #9
	b	.L4495
.L4499:
	ldr	r3, [sp, #12]
	cmp	r7, r3
	itttt	eq
	smulbbeq	r2, r7, r2
	addeq	r1, r4, r5
	subeq	r2, r1, r2
	strbeq	r2, [r0, #40]
	b	.L4501
.L4507:
	movs	r1, #1
	movs	r0, #0
	bl	zftl_do_gc
	movs	r1, #1
	mov	r0, r1
	b	.L4518
.L4511:
	mov	r0, #-1
	b	.L4490
.L4520:
	.align	2
.L4519:
	.word	.LANCHOR14
	.word	.LC252
	.word	.LANCHOR68
	.word	.LANCHOR10
	.word	.LANCHOR103
	.word	.LANCHOR107
	.word	.LANCHOR67
	.word	.LANCHOR58
	.word	.LANCHOR110
	.word	.LANCHOR131
	.size	zftl_write, .-zftl_write
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
	cbnz	r0, .L4525
	mov	r3, r2
	mov	r2, r5
	bl	idb_write_data
.L4525:
	mov	r3, r5
	mov	r2, r4
	mov	r1, r7
	mov	r0, r6
	pop	{r4, r5, r6, r7, r8, lr}
	b	zftl_write
	.size	ftl_write, .-ftl_write
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
	.section	.text.zftl_vendor_write,"ax",%progbits
	.align	1
	.global	zftl_vendor_write
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	zftl_vendor_write, %function
zftl_vendor_write:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	b	ftl_vendor_write
	.size	zftl_vendor_write, .-zftl_vendor_write
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
	ldr	r3, .L4578
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r1
	sub	sp, sp, #32
	ldr	r3, [r3]
	cmp	r0, r3
	bcs	.L4551
	cmp	r1, r3
	bhi	.L4551
	adds	r2, r0, r1
	cmp	r3, r2
	bcc	.L4551
	ldr	r2, .L4578+4
	add	r7, r0, #24576
	ldr	r3, .L4578+8
	ldr	r0, [r2]
	ldr	r1, [r3]
	str	r3, [sp, #12]
	tst	r0, #4096
	str	r2, [sp, #16]
	add	r1, r1, r4
	str	r1, [r3]
	beq	.L4530
	movs	r3, #0
	mov	r2, r7
	str	r3, [sp]
	mov	r3, r4
	ldr	r0, .L4578+12
	bl	printf
.L4530:
	ldr	r8, .L4578+36
	ldr	r10, .L4578+40
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
	beq	.L4531
	subs	r6, r6, r1
	mov	r0, r5
	cmp	r6, r4
	it	cs
	movcs	r6, r4
	bl	lpa_hash_get_ppa
	str	r0, [sp, #24]
	adds	r0, r0, #1
	bne	.L4532
	movs	r2, #0
	add	r1, sp, #24
	mov	r0, r5
	bl	pm_log2phys
.L4532:
	ldr	r3, [sp, #24]
	adds	r3, r3, #1
	beq	.L4534
	movs	r0, #0
	bl	buf_alloc
	mov	r3, r0
	cbz	r0, .L4534
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
.L4534:
	uxth	r6, r6
	adds	r5, r5, #1
	subs	r4, r4, r6
.L4531:
	cbz	r4, .L4536
	bl	ftl_flush
.L4536:
	ldr	fp, .L4578+44
	mov	r3, #-1
	ldr	r6, .L4578+16
	str	r3, [sp, #28]
.L4537:
	ldrb	r3, [r10]	@ zero_extendqisi2
	cmp	r4, r3
	bcs	.L4542
	cmp	r4, #0
	beq	.L4544
	mov	r0, r5
	bl	lpa_hash_get_ppa
	str	r0, [sp, #24]
	adds	r0, r0, #1
	bne	.L4545
	movs	r2, #0
	add	r1, sp, #24
	mov	r0, r5
	bl	pm_log2phys
.L4545:
	ldr	r3, [sp, #24]
	adds	r3, r3, #1
	beq	.L4544
	movs	r0, #0
	bl	buf_alloc
	mov	r6, r0
	cbz	r0, .L4544
	movs	r3, #0
	str	r5, [r0, #20]
	strb	r3, [r0, #41]
	ldr	r3, [sp, #8]
	strb	r4, [r0, #40]
	str	r3, [r0, #16]
	ldrb	r3, [r10]	@ zero_extendqisi2
	cmp	r4, r3
	bcc	.L4547
	movw	r2, #1477
	ldr	r1, .L4578+20
	ldr	r0, .L4578+24
	bl	printf
.L4547:
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
.L4544:
	ldr	r3, [sp, #12]
	ldr	r1, [r3]
	cmp	r1, #8192
	bls	.L4552
	ldr	r3, [sp, #16]
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L4548
	movs	r3, #0
	mov	r2, r7
	str	r3, [sp]
	mov	r3, r4
	ldr	r0, .L4578+12
	bl	printf
.L4548:
	ldr	r3, [sp, #12]
	movs	r4, #0
	str	r4, [r3]
	bl	flt_sys_flush
	ldr	r3, .L4578+28
	movs	r2, #1
	str	r2, [r3]
.L4552:
	movs	r0, #0
	b	.L4528
.L4542:
	mov	r0, r5
	bl	lpa_hash_get_ppa
	str	r0, [sp, #24]
	adds	r0, r0, #1
	beq	.L4538
	movs	r0, #0
	bl	buf_alloc
	mov	r3, r0
	cbz	r0, .L4540
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
.L4577:
	ldr	r2, [r8]
	ldr	r3, [r2, #76]
	adds	r3, r3, #1
	str	r3, [r2, #76]
.L4540:
	ldrb	r3, [r10]	@ zero_extendqisi2
	adds	r5, r5, #1
	subs	r4, r4, r3
	b	.L4537
.L4538:
	movs	r2, #0
	add	r1, sp, #24
	mov	r0, r5
	bl	pm_log2phys
	ldr	r3, [sp, #24]
	adds	r3, r3, #1
	beq	.L4540
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
	ldr	r2, .L4578+32
	ands	r0, r0, r3
	ldrb	r1, [r2]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	uxth	r0, r0
	bl	ftl_vpn_decrement
	b	.L4577
.L4551:
	mov	r0, #-1
.L4528:
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L4579:
	.align	2
.L4578:
	.word	.LANCHOR68
	.word	.LANCHOR14
	.word	.LANCHOR241
	.word	.LC253
	.word	.LANCHOR32
	.word	.LANCHOR242
	.word	.LC0
	.word	.LANCHOR122
	.word	.LANCHOR76
	.word	.LANCHOR110
	.word	.LANCHOR131
	.word	.LANCHOR75
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
	ldr	r4, .L4585
	movs	r5, #0
	movw	r7, #65535
	ldr	r0, .L4585+4
	ldr	r1, [r4]
	ldr	r6, .L4585+8
	ldrh	r3, [r1, #698]
	add	r1, r1, #704
	bl	rknand_print_hex
	ldr	r1, [r4]
	movs	r2, #2
	ldrh	r3, [r6]
	ldr	r0, .L4585+12
	add	r1, r1, #416
	bl	rknand_print_hex
.L4582:
	ldrh	r2, [r6]
	uxth	r3, r5
	cmp	r2, r3
	bhi	.L4584
	pop	{r3, r4, r5, r6, r7, pc}
.L4584:
	ldr	r2, [r4]
	uxth	r3, r5
	adds	r3, r3, #208
	ldrh	r0, [r2, r3, lsl #1]
	cmp	r0, r7
	beq	.L4583
	movs	r1, #0
	bl	ftl_sblk_dump
.L4583:
	adds	r5, r5, #1
	b	.L4582
.L4586:
	.align	2
.L4585:
	.word	.LANCHOR110
	.word	.LC254
	.word	.LANCHOR155
	.word	.LC255
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
	.global	ftl_tmp_buffer
	.global	ftl_ext_info_data_buffer
	.global	ftl_info_data_buffer
	.global	ftl_tmp_spare
	.global	ftl_info_spare
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
	.global	gc_slc_mode_slc_vpn_th
	.global	gc_slc_mode_tlc_vpn_th
	.global	gc_tlc_mode_tlc_vpn_th
	.global	gc_tlc_mode_slc_vpn_th
	.global	gc_state
	.global	gc_mode
	.global	p_read_ahead_ext_buf
	.global	discard_sector_count
	.global	read_ahead_lpa
	.global	_ftl_gc_tag_page_num
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
	.global	g_flash_ymtc_3d_tlc_flag
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
	.global	g_flash_six_addr
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
	.set	.LANCHOR48,. + 0
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
	.set	.LANCHOR75,. + 0
	.type	_c_ftl_block_addr_log2, %object
	.size	_c_ftl_block_addr_log2, 2
_c_ftl_block_addr_log2:
	.space	2
	.section	.bss._c_ftl_block_align_addr,"aw",%nobits
	.align	1
	.set	.LANCHOR111,. + 0
	.type	_c_ftl_block_align_addr, %object
	.size	_c_ftl_block_align_addr, 2
_c_ftl_block_align_addr:
	.space	2
	.section	.bss._c_ftl_byte_pre_page,"aw",%nobits
	.align	1
	.set	.LANCHOR221,. + 0
	.type	_c_ftl_byte_pre_page, %object
	.size	_c_ftl_byte_pre_page, 2
_c_ftl_byte_pre_page:
	.space	2
	.section	.bss._c_ftl_cs_bits,"aw",%nobits
	.set	.LANCHOR32,. + 0
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
	.set	.LANCHOR112,. + 0
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
	.set	.LANCHOR79,. + 0
	.type	_c_ftl_nand_type, %object
	.size	_c_ftl_nand_type, 1
_c_ftl_nand_type:
	.space	1
	.section	.bss._c_ftl_page_pre_blk,"aw",%nobits
	.align	1
	.set	.LANCHOR86,. + 0
	.type	_c_ftl_page_pre_blk, %object
	.size	_c_ftl_page_pre_blk, 2
_c_ftl_page_pre_blk:
	.space	2
	.section	.bss._c_ftl_page_pre_slc_blk,"aw",%nobits
	.align	1
	.set	.LANCHOR95,. + 0
	.type	_c_ftl_page_pre_slc_blk, %object
	.size	_c_ftl_page_pre_slc_blk, 2
_c_ftl_page_pre_slc_blk:
	.space	2
	.section	.bss._c_ftl_planes_per_die,"aw",%nobits
	.set	.LANCHOR76,. + 0
	.type	_c_ftl_planes_per_die, %object
	.size	_c_ftl_planes_per_die, 1
_c_ftl_planes_per_die:
	.space	1
	.section	.bss._c_ftl_pm_page_num,"aw",%nobits
	.align	1
	.set	.LANCHOR204,. + 0
	.type	_c_ftl_pm_page_num, %object
	.size	_c_ftl_pm_page_num, 2
_c_ftl_pm_page_num:
	.space	2
	.section	.bss._c_ftl_sec_per_page,"aw",%nobits
	.set	.LANCHOR131,. + 0
	.type	_c_ftl_sec_per_page, %object
	.size	_c_ftl_sec_per_page, 1
_c_ftl_sec_per_page:
	.space	1
	.section	.bss._c_max_pm_sblk,"aw",%nobits
	.align	1
	.set	.LANCHOR155,. + 0
	.type	_c_max_pm_sblk, %object
	.size	_c_max_pm_sblk, 2
_c_max_pm_sblk:
	.space	2
	.section	.bss._c_mix_max_slc_ec_count,"aw",%nobits
	.align	1
	.set	.LANCHOR126,. + 0
	.type	_c_mix_max_slc_ec_count, %object
	.size	_c_mix_max_slc_ec_count, 2
_c_mix_max_slc_ec_count:
	.space	2
	.section	.bss._c_mix_max_xlc_ec_count,"aw",%nobits
	.align	1
	.set	.LANCHOR125,. + 0
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
	.set	.LANCHOR152,. + 0
	.type	_c_swl_slc_gc_th, %object
	.size	_c_swl_slc_gc_th, 2
_c_swl_slc_gc_th:
	.space	2
	.section	.bss._c_swl_xlc_gc_th,"aw",%nobits
	.align	1
	.set	.LANCHOR153,. + 0
	.type	_c_swl_xlc_gc_th, %object
	.size	_c_swl_xlc_gc_th, 2
_c_swl_xlc_gc_th:
	.space	2
	.section	.bss._c_totle_data_density,"aw",%nobits
	.align	2
	.set	.LANCHOR240,. + 0
	.type	_c_totle_data_density, %object
	.size	_c_totle_data_density, 4
_c_totle_data_density:
	.space	4
	.section	.bss._c_totle_log_page,"aw",%nobits
	.align	2
	.set	.LANCHOR128,. + 0
	.type	_c_totle_log_page, %object
	.size	_c_totle_log_page, 4
_c_totle_log_page:
	.space	4
	.section	.bss._c_totle_phy_density,"aw",%nobits
	.align	2
	.set	.LANCHOR239,. + 0
	.type	_c_totle_phy_density, %object
	.size	_c_totle_phy_density, 4
_c_totle_phy_density:
	.space	4
	.section	.bss._c_user_data_density,"aw",%nobits
	.align	2
	.set	.LANCHOR68,. + 0
	.type	_c_user_data_density, %object
	.size	_c_user_data_density, 4
_c_user_data_density:
	.space	4
	.section	.bss._ftl_gc_tag_page_num,"aw",%nobits
	.set	.LANCHOR224,. + 0
	.type	_ftl_gc_tag_page_num, %object
	.size	_ftl_gc_tag_page_num, 1
_ftl_gc_tag_page_num:
	.space	1
	.section	.bss._gc_after_discard_en,"aw",%nobits
	.align	2
	.set	.LANCHOR122,. + 0
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
	.section	.bss._max_xlc_super_block,"aw",%nobits
	.align	1
	.set	.LANCHOR101,. + 0
	.type	_max_xlc_super_block, %object
	.size	_max_xlc_super_block, 2
_max_xlc_super_block:
	.space	2
	.section	.bss._min_slc_super_block,"aw",%nobits
	.align	1
	.set	.LANCHOR98,. + 0
	.type	_min_slc_super_block, %object
	.size	_min_slc_super_block, 2
_min_slc_super_block:
	.space	2
	.section	.bss.discard_sector_count,"aw",%nobits
	.align	2
	.set	.LANCHOR241,. + 0
	.type	discard_sector_count, %object
	.size	discard_sector_count, 4
discard_sector_count:
	.space	4
	.section	.bss.fill_spare_size,"aw",%nobits
	.align	1
	.set	.LANCHOR54,. + 0
	.type	fill_spare_size, %object
	.size	fill_spare_size, 2
fill_spare_size:
	.space	2
	.section	.bss.flash_ddr_tuning_sdr_read_count,"aw",%nobits
	.align	2
	.set	.LANCHOR172,. + 0
	.type	flash_ddr_tuning_sdr_read_count, %object
	.size	flash_ddr_tuning_sdr_read_count, 4
flash_ddr_tuning_sdr_read_count:
	.space	4
	.section	.bss.flash_read_retry,"aw",%nobits
	.align	2
	.set	.LANCHOR174,. + 0
	.type	flash_read_retry, %object
	.size	flash_read_retry, 4
flash_read_retry:
	.space	4
	.section	.bss.free_buf_count,"aw",%nobits
	.set	.LANCHOR58,. + 0
	.type	free_buf_count, %object
	.size	free_buf_count, 1
free_buf_count:
	.space	1
	.section	.bss.free_mix_sblk,"aw",%nobits
	.align	1
	.set	.LANCHOR107,. + 0
	.type	free_mix_sblk, %object
	.size	free_mix_sblk, 2
free_mix_sblk:
	.space	2
	.section	.bss.free_slc_sblk,"aw",%nobits
	.align	1
	.set	.LANCHOR103,. + 0
	.type	free_slc_sblk, %object
	.size	free_slc_sblk, 2
free_slc_sblk:
	.space	2
	.section	.bss.free_xlc_sblk,"aw",%nobits
	.align	1
	.set	.LANCHOR105,. + 0
	.type	free_xlc_sblk, %object
	.size	free_xlc_sblk, 2
free_xlc_sblk:
	.space	2
	.section	.bss.ftl_ext_info_data_buffer,"aw",%nobits
	.align	2
	.set	.LANCHOR200,. + 0
	.type	ftl_ext_info_data_buffer, %object
	.size	ftl_ext_info_data_buffer, 4
ftl_ext_info_data_buffer:
	.space	4
	.section	.bss.ftl_ext_info_first_write,"aw",%nobits
	.set	.LANCHOR199,. + 0
	.type	ftl_ext_info_first_write, %object
	.size	ftl_ext_info_first_write, 1
ftl_ext_info_first_write:
	.space	1
	.section	.bss.ftl_flush_jiffies,"aw",%nobits
	.align	2
	.set	.LANCHOR233,. + 0
	.type	ftl_flush_jiffies, %object
	.size	ftl_flush_jiffies, 4
ftl_flush_jiffies:
	.space	4
	.section	.bss.ftl_info_data_buffer,"aw",%nobits
	.align	2
	.set	.LANCHOR195,. + 0
	.type	ftl_info_data_buffer, %object
	.size	ftl_info_data_buffer, 4
ftl_info_data_buffer:
	.space	4
	.section	.bss.ftl_info_spare,"aw",%nobits
	.align	6
	.set	.LANCHOR193,. + 0
	.type	ftl_info_spare, %object
	.size	ftl_info_spare, 256
ftl_info_spare:
	.space	256
	.section	.bss.ftl_low_format_cur_blk,"aw",%nobits
	.align	1
	.set	.LANCHOR69,. + 0
	.type	ftl_low_format_cur_blk, %object
	.size	ftl_low_format_cur_blk, 2
ftl_low_format_cur_blk:
	.space	2
	.section	.bss.ftl_power_lost_flag,"aw",%nobits
	.set	.LANCHOR198,. + 0
	.type	ftl_power_lost_flag, %object
	.size	ftl_power_lost_flag, 1
ftl_power_lost_flag:
	.space	1
	.section	.bss.ftl_sblk_lpa_tbl,"aw",%nobits
	.align	2
	.set	.LANCHOR117,. + 0
	.type	ftl_sblk_lpa_tbl, %object
	.size	ftl_sblk_lpa_tbl, 4
ftl_sblk_lpa_tbl:
	.space	4
	.section	.bss.ftl_sblk_update_list,"aw",%nobits
	.align	1
	.set	.LANCHOR74,. + 0
	.type	ftl_sblk_update_list, %object
	.size	ftl_sblk_update_list, 16
ftl_sblk_update_list:
	.space	16
	.section	.bss.ftl_sblk_update_list_offset,"aw",%nobits
	.align	1
	.set	.LANCHOR123,. + 0
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
	.set	.LANCHOR73,. + 0
	.type	ftl_sblk_vpn_update_id, %object
	.size	ftl_sblk_vpn_update_id, 2
ftl_sblk_vpn_update_id:
	.space	2
	.section	.bss.ftl_sys_info_first_write,"aw",%nobits
	.set	.LANCHOR197,. + 0
	.type	ftl_sys_info_first_write, %object
	.size	ftl_sys_info_first_write, 1
ftl_sys_info_first_write:
	.space	1
	.section	.bss.ftl_tmp_buffer,"aw",%nobits
	.align	2
	.set	.LANCHOR190,. + 0
	.type	ftl_tmp_buffer, %object
	.size	ftl_tmp_buffer, 4
ftl_tmp_buffer:
	.space	4
	.section	.bss.ftl_tmp_spare,"aw",%nobits
	.align	6
	.set	.LANCHOR191,. + 0
	.type	ftl_tmp_spare, %object
	.size	ftl_tmp_spare, 256
ftl_tmp_spare:
	.space	256
	.section	.bss.ftl_vpn_update_count,"aw",%nobits
	.align	1
	.set	.LANCHOR121,. + 0
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
	.set	.LANCHOR56,. + 0
	.type	g_buf, %object
	.size	g_buf, 1536
g_buf:
	.space	1536
	.section	.bss.g_die_addr,"aw",%nobits
	.align	2
	.set	.LANCHOR148,. + 0
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
	.set	.LANCHOR81,. + 0
	.type	g_flash_3d_mlc_flag, %object
	.size	g_flash_3d_mlc_flag, 1
g_flash_3d_mlc_flag:
	.space	1
	.section	.bss.g_flash_3d_tlc_flag,"aw",%nobits
	.set	.LANCHOR84,. + 0
	.type	g_flash_3d_tlc_flag, %object
	.size	g_flash_3d_tlc_flag, 1
g_flash_3d_tlc_flag:
	.space	1
	.section	.bss.g_flash_blk_info,"aw",%nobits
	.align	1
	.set	.LANCHOR211,. + 0
	.type	g_flash_blk_info, %object
	.size	g_flash_blk_info, 4
g_flash_blk_info:
	.space	4
	.section	.bss.g_flash_cur_mode,"aw",%nobits
	.set	.LANCHOR34,. + 0
	.type	g_flash_cur_mode, %object
	.size	g_flash_cur_mode, 4
g_flash_cur_mode:
	.space	4
	.section	.bss.g_flash_interface_mode,"aw",%nobits
	.set	.LANCHOR49,. + 0
	.type	g_flash_interface_mode, %object
	.size	g_flash_interface_mode, 1
g_flash_interface_mode:
	.space	1
	.section	.bss.g_flash_micron_3d_tlc_b05a,"aw",%nobits
	.set	.LANCHOR124,. + 0
	.type	g_flash_micron_3d_tlc_b05a, %object
	.size	g_flash_micron_3d_tlc_b05a, 1
g_flash_micron_3d_tlc_b05a:
	.space	1
	.section	.bss.g_flash_micron_3d_tlc_b16a,"aw",%nobits
	.set	.LANCHOR217,. + 0
	.type	g_flash_micron_3d_tlc_b16a, %object
	.size	g_flash_micron_3d_tlc_b16a, 1
g_flash_micron_3d_tlc_b16a:
	.space	1
	.section	.bss.g_flash_micron_3d_tlc_flag,"aw",%nobits
	.set	.LANCHOR36,. + 0
	.type	g_flash_micron_3d_tlc_flag, %object
	.size	g_flash_micron_3d_tlc_flag, 1
g_flash_micron_3d_tlc_flag:
	.space	1
	.section	.bss.g_flash_multi_page_prog_en,"aw",%nobits
	.set	.LANCHOR45,. + 0
	.type	g_flash_multi_page_prog_en, %object
	.size	g_flash_multi_page_prog_en, 1
g_flash_multi_page_prog_en:
	.space	1
	.section	.bss.g_flash_multi_page_read_en,"aw",%nobits
	.set	.LANCHOR186,. + 0
	.type	g_flash_multi_page_read_en, %object
	.size	g_flash_multi_page_read_en, 1
g_flash_multi_page_read_en:
	.space	1
	.section	.bss.g_flash_page_buffer,"aw",%nobits
	.align	2
	.set	.LANCHOR176,. + 0
	.type	g_flash_page_buffer, %object
	.size	g_flash_page_buffer, 4
g_flash_page_buffer:
	.space	4
	.section	.bss.g_flash_reversd_blks,"aw",%nobits
	.set	.LANCHOR216,. + 0
	.type	g_flash_reversd_blks, %object
	.size	g_flash_reversd_blks, 1
g_flash_reversd_blks:
	.space	1
	.section	.bss.g_flash_six_addr,"aw",%nobits
	.set	.LANCHOR31,. + 0
	.type	g_flash_six_addr, %object
	.size	g_flash_six_addr, 1
g_flash_six_addr:
	.space	1
	.section	.bss.g_flash_slc_mode,"aw",%nobits
	.set	.LANCHOR0,. + 0
	.type	g_flash_slc_mode, %object
	.size	g_flash_slc_mode, 1
g_flash_slc_mode:
	.space	1
	.section	.bss.g_flash_spare_buffer,"aw",%nobits
	.align	2
	.set	.LANCHOR175,. + 0
	.type	g_flash_spare_buffer, %object
	.size	g_flash_spare_buffer, 4
g_flash_spare_buffer:
	.space	4
	.section	.bss.g_flash_sys_spare_buffer,"aw",%nobits
	.align	2
	.set	.LANCHOR210,. + 0
	.type	g_flash_sys_spare_buffer, %object
	.size	g_flash_sys_spare_buffer, 4
g_flash_sys_spare_buffer:
	.space	4
	.section	.bss.g_flash_tmp_page_buffer,"aw",%nobits
	.align	2
	.set	.LANCHOR166,. + 0
	.type	g_flash_tmp_page_buffer, %object
	.size	g_flash_tmp_page_buffer, 4
g_flash_tmp_page_buffer:
	.space	4
	.section	.bss.g_flash_tmp_spare_buffer,"aw",%nobits
	.align	2
	.set	.LANCHOR168,. + 0
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
	.section	.bss.g_flash_ymtc_3d_tlc_flag,"aw",%nobits
	.set	.LANCHOR37,. + 0
	.type	g_flash_ymtc_3d_tlc_flag, %object
	.size	g_flash_ymtc_3d_tlc_flag, 1
g_flash_ymtc_3d_tlc_flag:
	.space	1
	.section	.bss.g_ftl_info_blk,"aw",%nobits
	.align	6
	.set	.LANCHOR194,. + 0
	.type	g_ftl_info_blk, %object
	.size	g_ftl_info_blk, 4
g_ftl_info_blk:
	.space	4
	.section	.bss.g_gc_info,"aw",%nobits
	.align	2
	.set	.LANCHOR71,. + 0
	.type	g_gc_info, %object
	.size	g_gc_info, 2132
g_gc_info:
	.space	2132
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
	.size	g_lsb_page_tbl, 1024
g_lsb_page_tbl:
	.space	1024
	.section	.bss.g_maxRegNum,"aw",%nobits
	.set	.LANCHOR26,. + 0
	.type	g_maxRegNum, %object
	.size	g_maxRegNum, 1
g_maxRegNum:
	.space	1
	.section	.bss.g_maxRetryCount,"aw",%nobits
	.set	.LANCHOR169,. + 0
	.type	g_maxRetryCount, %object
	.size	g_maxRetryCount, 1
g_maxRetryCount:
	.space	1
	.section	.bss.g_msb_page_tbl,"aw",%nobits
	.align	2
	.set	.LANCHOR145,. + 0
	.type	g_msb_page_tbl, %object
	.size	g_msb_page_tbl, 2048
g_msb_page_tbl:
	.space	2048
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
	.set	.LANCHOR50,. + 0
	.type	g_nandc_ecc_bits, %object
	.size	g_nandc_ecc_bits, 1
g_nandc_ecc_bits:
	.space	1
	.section	.bss.g_nandc_tran_timeout,"aw",%nobits
	.set	.LANCHOR167,. + 0
	.type	g_nandc_tran_timeout, %object
	.size	g_nandc_tran_timeout, 1
g_nandc_tran_timeout:
	.space	1
	.section	.bss.g_nandc_v6_master_info,"aw",%nobits
	.align	2
	.set	.LANCHOR53,. + 0
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
	.set	.LANCHOR82,. + 0
	.type	g_one_pass_program, %object
	.size	g_one_pass_program, 1
g_one_pass_program:
	.space	1
	.section	.bss.g_pm_spare,"aw",%nobits
	.align	2
	.set	.LANCHOR207,. + 0
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
	.set	.LANCHOR147,. + 0
	.type	g_slc_page_num, %object
	.size	g_slc_page_num, 2
g_slc_page_num:
	.space	2
	.section	.bss.g_totle_phy_block,"aw",%nobits
	.align	1
	.set	.LANCHOR149,. + 0
	.type	g_totle_phy_block, %object
	.size	g_totle_phy_block, 2
g_totle_phy_block:
	.space	2
	.section	.bss.gc_des_ppa_tbl,"aw",%nobits
	.align	2
	.set	.LANCHOR164,. + 0
	.type	gc_des_ppa_tbl, %object
	.size	gc_des_ppa_tbl, 4
gc_des_ppa_tbl:
	.space	4
	.section	.bss.gc_free_slc_sblk_th,"aw",%nobits
	.align	1
	.set	.LANCHOR87,. + 0
	.type	gc_free_slc_sblk_th, %object
	.size	gc_free_slc_sblk_th, 2
gc_free_slc_sblk_th:
	.space	2
	.section	.bss.gc_lpa_tbl,"aw",%nobits
	.align	2
	.set	.LANCHOR162,. + 0
	.type	gc_lpa_tbl, %object
	.size	gc_lpa_tbl, 4
gc_lpa_tbl:
	.space	4
	.section	.bss.gc_mode,"aw",%nobits
	.set	.LANCHOR85,. + 0
	.type	gc_mode, %object
	.size	gc_mode, 1
gc_mode:
	.space	1
	.section	.bss.gc_page_buf_id,"aw",%nobits
	.align	2
	.set	.LANCHOR83,. + 0
	.type	gc_page_buf_id, %object
	.size	gc_page_buf_id, 4
gc_page_buf_id:
	.space	4
	.section	.bss.gc_pre_ppa_tbl,"aw",%nobits
	.align	2
	.set	.LANCHOR163,. + 0
	.type	gc_pre_ppa_tbl, %object
	.size	gc_pre_ppa_tbl, 4
gc_pre_ppa_tbl:
	.space	4
	.section	.bss.gc_search_count,"aw",%nobits
	.align	2
	.set	.LANCHOR160,. + 0
	.type	gc_search_count, %object
	.size	gc_search_count, 4
gc_search_count:
	.space	4
	.section	.bss.gc_slc_cache_index,"aw",%nobits
	.align	1
	.set	.LANCHOR91,. + 0
	.type	gc_slc_cache_index, %object
	.size	gc_slc_cache_index, 2
gc_slc_cache_index:
	.space	2
	.section	.bss.gc_slc_data_index,"aw",%nobits
	.align	1
	.set	.LANCHOR90,. + 0
	.type	gc_slc_data_index, %object
	.size	gc_slc_data_index, 2
gc_slc_data_index:
	.space	2
	.section	.bss.gc_slc_mode_slc_vpn_th,"aw",%nobits
	.align	1
	.set	.LANCHOR161,. + 0
	.type	gc_slc_mode_slc_vpn_th, %object
	.size	gc_slc_mode_slc_vpn_th, 2
gc_slc_mode_slc_vpn_th:
	.space	2
	.section	.bss.gc_slc_mode_tlc_vpn_th,"aw",%nobits
	.align	1
	.set	.LANCHOR94,. + 0
	.type	gc_slc_mode_tlc_vpn_th, %object
	.size	gc_slc_mode_tlc_vpn_th, 2
gc_slc_mode_tlc_vpn_th:
	.space	2
	.section	.bss.gc_slc_mode_vpn_th,"aw",%nobits
	.align	1
	.set	.LANCHOR70,. + 0
	.type	gc_slc_mode_vpn_th, %object
	.size	gc_slc_mode_vpn_th, 2
gc_slc_mode_vpn_th:
	.space	2
	.section	.bss.gc_state,"aw",%nobits
	.set	.LANCHOR159,. + 0
	.type	gc_state, %object
	.size	gc_state, 1
gc_state:
	.space	1
	.section	.bss.gc_tlc_mode_slc_vpn_th,"aw",%nobits
	.align	1
	.set	.LANCHOR102,. + 0
	.type	gc_tlc_mode_slc_vpn_th, %object
	.size	gc_tlc_mode_slc_vpn_th, 2
gc_tlc_mode_slc_vpn_th:
	.space	2
	.section	.bss.gc_tlc_mode_tlc_vpn_th,"aw",%nobits
	.align	1
	.set	.LANCHOR100,. + 0
	.type	gc_tlc_mode_tlc_vpn_th, %object
	.size	gc_tlc_mode_tlc_vpn_th, 2
gc_tlc_mode_tlc_vpn_th:
	.space	2
	.section	.bss.gc_valid_page_ppa,"aw",%nobits
	.align	2
	.set	.LANCHOR77,. + 0
	.type	gc_valid_page_ppa, %object
	.size	gc_valid_page_ppa, 4
gc_valid_page_ppa:
	.space	4
	.section	.bss.gc_xlc_data_index,"aw",%nobits
	.align	1
	.set	.LANCHOR92,. + 0
	.type	gc_xlc_data_index, %object
	.size	gc_xlc_data_index, 2
gc_xlc_data_index:
	.space	2
	.section	.bss.gc_xlc_search_index,"aw",%nobits
	.align	1
	.set	.LANCHOR96,. + 0
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
	.set	.LANCHOR89,. + 0
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
	.set	.LANCHOR88,. + 0
	.type	gp_data_xlc_data_head, %object
	.size	gp_data_xlc_data_head, 4
gp_data_xlc_data_head:
	.space	4
	.section	.bss.gp_flash_check_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR144,. + 0
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
	.set	.LANCHOR108,. + 0
	.type	gp_free_mix_head, %object
	.size	gp_free_mix_head, 4
gp_free_mix_head:
	.space	4
	.section	.bss.gp_free_slc_head,"aw",%nobits
	.align	2
	.set	.LANCHOR104,. + 0
	.type	gp_free_slc_head, %object
	.size	gp_free_slc_head, 4
gp_free_slc_head:
	.space	4
	.section	.bss.gp_free_xlc_head,"aw",%nobits
	.align	2
	.set	.LANCHOR106,. + 0
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
	.set	.LANCHOR110,. + 0
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
	.set	.LANCHOR141,. + 0
	.type	idb_buf, %object
	.size	idb_buf, 4
idb_buf:
	.space	4
	.section	.bss.idb_last_lba,"aw",%nobits
	.align	2
	.set	.LANCHOR177,. + 0
	.type	idb_last_lba, %object
	.size	idb_last_lba, 4
idb_last_lba:
	.space	4
	.section	.bss.idb_need_write_back,"aw",%nobits
	.align	2
	.set	.LANCHOR142,. + 0
	.type	idb_need_write_back, %object
	.size	idb_need_write_back, 4
idb_need_write_back:
	.space	4
	.section	.bss.idb_write_enable,"aw",%nobits
	.set	.LANCHOR143,. + 0
	.type	idb_write_enable, %object
	.size	idb_write_enable, 1
idb_write_enable:
	.space	1
	.section	.bss.lpa_hash,"aw",%nobits
	.align	1
	.set	.LANCHOR116,. + 0
	.type	lpa_hash, %object
	.size	lpa_hash, 512
lpa_hash:
	.space	512
	.section	.bss.lpa_hash_index,"aw",%nobits
	.align	2
	.set	.LANCHOR118,. + 0
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
	.set	.LANCHOR51,. + 0
	.type	nandc_hw_seed, %object
	.size	nandc_hw_seed, 1
nandc_hw_seed:
	.space	1
	.section	.bss.nandc_randomizer_en,"aw",%nobits
	.set	.LANCHOR52,. + 0
	.type	nandc_randomizer_en, %object
	.size	nandc_randomizer_en, 1
nandc_randomizer_en:
	.space	1
	.section	.bss.p_free_buf_head,"aw",%nobits
	.set	.LANCHOR57,. + 0
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
	.set	.LANCHOR208,. + 0
	.type	pm_first_write, %object
	.size	pm_first_write, 1
pm_first_write:
	.space	1
	.section	.bss.pm_force_gc,"aw",%nobits
	.align	2
	.set	.LANCHOR151,. + 0
	.type	pm_force_gc, %object
	.size	pm_force_gc, 4
pm_force_gc:
	.space	4
	.section	.bss.pm_gc_enable,"aw",%nobits
	.align	2
	.set	.LANCHOR136,. + 0
	.type	pm_gc_enable, %object
	.size	pm_gc_enable, 4
pm_gc_enable:
	.space	4
	.section	.bss.pm_last_load_ram_id,"aw",%nobits
	.set	.LANCHOR223,. + 0
	.type	pm_last_load_ram_id, %object
	.size	pm_last_load_ram_id, 1
pm_last_load_ram_id:
	.space	1
	.section	.bss.pm_last_update_ram_id,"aw",%nobits
	.set	.LANCHOR139,. + 0
	.type	pm_last_update_ram_id, %object
	.size	pm_last_update_ram_id, 1
pm_last_update_ram_id:
	.space	1
	.section	.bss.pm_ram_info,"aw",%nobits
	.align	2
	.set	.LANCHOR138,. + 0
	.type	pm_ram_info, %object
	.size	pm_ram_info, 256
pm_ram_info:
	.space	256
	.section	.bss.read_ahead_lpa,"aw",%nobits
	.align	2
	.set	.LANCHOR238,. + 0
	.type	read_ahead_lpa, %object
	.size	read_ahead_lpa, 4
read_ahead_lpa:
	.space	4
	.section	.bss.read_buf_count,"aw",%nobits
	.set	.LANCHOR134,. + 0
	.type	read_buf_count, %object
	.size	read_buf_count, 1
read_buf_count:
	.space	1
	.section	.bss.read_buf_head,"aw",%nobits
	.set	.LANCHOR133,. + 0
	.type	read_buf_head, %object
	.size	read_buf_head, 1
read_buf_head:
	.space	1
	.section	.bss.sblk_gc_write_completed_queue_head,"aw",%nobits
	.set	.LANCHOR64,. + 0
	.type	sblk_gc_write_completed_queue_head, %object
	.size	sblk_gc_write_completed_queue_head, 1
sblk_gc_write_completed_queue_head:
	.space	1
	.section	.bss.sblk_queue_head,"aw",%nobits
	.set	.LANCHOR60,. + 0
	.type	sblk_queue_head, %object
	.size	sblk_queue_head, 1
sblk_queue_head:
	.space	1
	.section	.bss.sblk_read_completed_queue_head,"aw",%nobits
	.set	.LANCHOR63,. + 0
	.type	sblk_read_completed_queue_head, %object
	.size	sblk_read_completed_queue_head, 1
sblk_read_completed_queue_head:
	.space	1
	.section	.bss.sblk_write_completed_queue_head,"aw",%nobits
	.set	.LANCHOR65,. + 0
	.type	sblk_write_completed_queue_head, %object
	.size	sblk_write_completed_queue_head, 1
sblk_write_completed_queue_head:
	.space	1
	.section	.bss.slc_cache_sblk,"aw",%nobits
	.align	1
	.set	.LANCHOR99,. + 0
	.type	slc_cache_sblk, %object
	.size	slc_cache_sblk, 2
slc_cache_sblk:
	.space	2
	.section	.bss.slc_data_sblk,"aw",%nobits
	.align	1
	.set	.LANCHOR97,. + 0
	.type	slc_data_sblk, %object
	.size	slc_data_sblk, 2
slc_data_sblk:
	.space	2
	.section	.bss.write_buf_count,"aw",%nobits
	.set	.LANCHOR67,. + 0
	.type	write_buf_count, %object
	.size	write_buf_count, 1
write_buf_count:
	.space	1
	.section	.bss.write_buf_head,"aw",%nobits
	.set	.LANCHOR66,. + 0
	.type	write_buf_head, %object
	.size	write_buf_head, 1
write_buf_head:
	.space	1
	.section	.bss.write_commit_count,"aw",%nobits
	.set	.LANCHOR129,. + 0
	.type	write_commit_count, %object
	.size	write_commit_count, 1
write_commit_count:
	.space	1
	.section	.bss.write_commit_head,"aw",%nobits
	.set	.LANCHOR185,. + 0
	.type	write_commit_head, %object
	.size	write_commit_head, 1
write_commit_head:
	.space	1
	.section	.bss.xlc_data_sblk,"aw",%nobits
	.align	1
	.set	.LANCHOR93,. + 0
	.type	xlc_data_sblk, %object
	.size	xlc_data_sblk, 2
xlc_data_sblk:
	.space	2
	.section	.bss.zftl_print_list_count,"aw",%nobits
	.align	1
	.set	.LANCHOR109,. + 0
	.type	zftl_print_list_count, %object
	.size	zftl_print_list_count, 2
zftl_print_list_count:
	.space	2
	.section	.data.g_nand_para_info,"aw",%progbits
	.align	1
	.set	.LANCHOR33,. + 0
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
	.set	.LANCHOR165,. + 0
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
	.set	.LANCHOR215,. + 0
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
	.set	.LANCHOR41,. + 0
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
	.set	.LANCHOR40,. + 0
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
	.set	.LANCHOR235,. + 0
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
	.set	.LANCHOR236,. + 0
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
	.set	.LANCHOR214,. + 0
	.type	zftl_nand_flash_para_tbl, %object
	.size	zftl_nand_flash_para_tbl, 1568
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
	.byte	-104
	.byte	-34
	.byte	-108
	.byte	-109
	.byte	118
	.byte	-47
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
	.byte	1
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
	.byte	1
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
	.byte	1
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
	.byte	1
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
	.byte	1
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
	.byte	44
	.byte	-92
	.byte	100
	.byte	50
	.byte	-86
	.byte	4
	.byte	4
	.byte	1
	.byte	32
	.short	1024
	.byte	2
	.byte	1
	.short	2192
	.short	9671
	.byte	10
	.byte	19
	.byte	70
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.short	1024
	.byte	1
	.byte	-38
	.byte	-33
	.byte	0
	.byte	6
	.byte	-101
	.byte	-61
	.byte	72
	.byte	37
	.byte	16
	.byte	0
	.byte	9
	.byte	1
	.byte	32
	.short	1152
	.byte	3
	.byte	2
	.short	1006
	.short	-27169
	.byte	13
	.byte	81
	.byte	70
	.byte	32
	.byte	1
	.byte	0
	.byte	4
	.byte	0
	.short	2048
	.byte	1
	.byte	-38
	.byte	-33
	.byte	24
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
	.byte	3
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
	.byte	3
	.byte	0
	.short	512
	.byte	0
	.byte	-65
	.byte	-66
	.byte	1
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
	.byte	-120
	.byte	4
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
	.byte	1
	.byte	0
	.byte	24
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
	.byte	6
	.byte	-20
	.byte	-34
	.byte	-108
	.byte	-61
	.byte	-92
	.byte	-54
	.byte	0
	.byte	1
	.byte	32
	.short	792
	.byte	2
	.byte	1
	.short	688
	.short	1217
	.byte	11
	.byte	50
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	1
	.byte	0
	.short	1024
	.byte	1
	.byte	-38
	.byte	-33
	.byte	0
	.section	.rodata.__func__.10010,"a",%progbits
	.set	.LANCHOR47,. + 0
	.type	__func__.10010, %object
	.size	__func__.10010, 23
__func__.10010:
	.ascii	"flash_start_plane_read\000"
	.section	.rodata.__func__.10023,"a",%progbits
	.set	.LANCHOR182,. + 0
	.type	__func__.10023, %object
	.size	__func__.10023, 25
__func__.10023:
	.ascii	"flash_complete_page_read\000"
	.section	.rodata.__func__.10438,"a",%progbits
	.set	.LANCHOR146,. + 0
	.type	__func__.10438, %object
	.size	__func__.10438, 20
__func__.10438:
	.ascii	"flash_die_info_init\000"
	.section	.rodata.__func__.10448,"a",%progbits
	.set	.LANCHOR15,. + 0
	.type	__func__.10448, %object
	.size	__func__.10448, 22
__func__.10448:
	.ascii	"nand_flash_print_info\000"
	.section	.rodata.__func__.10493,"a",%progbits
	.set	.LANCHOR213,. + 0
	.type	__func__.10493, %object
	.size	__func__.10493, 16
__func__.10493:
	.ascii	"nand_flash_init\000"
	.section	.rodata.__func__.10516,"a",%progbits
	.set	.LANCHOR158,. + 0
	.type	__func__.10516, %object
	.size	__func__.10516, 11
__func__.10516:
	.ascii	"nandc_init\000"
	.section	.rodata.__func__.10685,"a",%progbits
	.set	.LANCHOR59,. + 0
	.type	__func__.10685, %object
	.size	__func__.10685, 13
__func__.10685:
	.ascii	"buf_add_tail\000"
	.section	.rodata.__func__.10698,"a",%progbits
	.set	.LANCHOR61,. + 0
	.type	__func__.10698, %object
	.size	__func__.10698, 10
__func__.10698:
	.ascii	"buf_alloc\000"
	.section	.rodata.__func__.10712,"a",%progbits
	.set	.LANCHOR62,. + 0
	.type	__func__.10712, %object
	.size	__func__.10712, 16
__func__.10712:
	.ascii	"buf_remove_free\000"
	.section	.rodata.__func__.10733,"a",%progbits
	.set	.LANCHOR212,. + 0
	.type	__func__.10733, %object
	.size	__func__.10733, 20
__func__.10733:
	.ascii	"flash_info_blk_init\000"
	.section	.rodata.__func__.10748,"a",%progbits
	.set	.LANCHOR157,. + 0
	.type	__func__.10748, %object
	.size	__func__.10748, 21
__func__.10748:
	.ascii	"flash_info_data_init\000"
	.section	.rodata.__func__.10770,"a",%progbits
	.set	.LANCHOR209,. + 0
	.type	__func__.10770, %object
	.size	__func__.10770, 17
__func__.10770:
	.ascii	"flash_info_flush\000"
	.section	.rodata.__func__.10846,"a",%progbits
	.set	.LANCHOR150,. + 0
	.type	__func__.10846, %object
	.size	__func__.10846, 17
__func__.10846:
	.ascii	"lpa_rebuild_hash\000"
	.section	.rodata.__func__.10896,"a",%progbits
	.set	.LANCHOR232,. + 0
	.type	__func__.10896, %object
	.size	__func__.10896, 17
__func__.10896:
	.ascii	"ftl_write_commit\000"
	.section	.rodata.__func__.10914,"a",%progbits
	.set	.LANCHOR130,. + 0
	.type	__func__.10914, %object
	.size	__func__.10914, 14
__func__.10914:
	.ascii	"ftl_write_buf\000"
	.section	.rodata.__func__.10959,"a",%progbits
	.set	.LANCHOR132,. + 0
	.type	__func__.10959, %object
	.size	__func__.10959, 18
__func__.10959:
	.ascii	"zftl_add_read_buf\000"
	.section	.rodata.__func__.10992,"a",%progbits
	.set	.LANCHOR230,. + 0
	.type	__func__.10992, %object
	.size	__func__.10992, 10
__func__.10992:
	.ascii	"zftl_read\000"
	.section	.rodata.__func__.11023,"a",%progbits
	.set	.LANCHOR242,. + 0
	.type	__func__.11023, %object
	.size	__func__.11023, 13
__func__.11023:
	.ascii	"_ftl_discard\000"
	.section	.rodata.__func__.11169,"a",%progbits
	.set	.LANCHOR225,. + 0
	.type	__func__.11169, %object
	.size	__func__.11169, 12
__func__.11169:
	.ascii	"gc_recovery\000"
	.section	.rodata.__func__.11179,"a",%progbits
	.set	.LANCHOR72,. + 0
	.type	__func__.11179, %object
	.size	__func__.11179, 12
__func__.11179:
	.ascii	"gc_add_sblk\000"
	.section	.rodata.__func__.11226,"a",%progbits
	.set	.LANCHOR188,. + 0
	.type	__func__.11226, %object
	.size	__func__.11226, 21
__func__.11226:
	.ascii	"gc_check_data_one_wl\000"
	.section	.rodata.__func__.11258,"a",%progbits
	.set	.LANCHOR226,. + 0
	.type	__func__.11258, %object
	.size	__func__.11258, 22
__func__.11258:
	.ascii	"gc_update_l2p_map_new\000"
	.section	.rodata.__func__.11271,"a",%progbits
	.set	.LANCHOR78,. + 0
	.type	__func__.11271, %object
	.size	__func__.11271, 19
__func__.11271:
	.ascii	"gc_write_completed\000"
	.section	.rodata.__func__.11301,"a",%progbits
	.set	.LANCHOR234,. + 0
	.type	__func__.11301, %object
	.size	__func__.11301, 16
__func__.11301:
	.ascii	"gc_do_copy_back\000"
	.section	.rodata.__func__.11328,"a",%progbits
	.set	.LANCHOR127,. + 0
	.type	__func__.11328, %object
	.size	__func__.11328, 16
__func__.11328:
	.ascii	"gc_free_src_blk\000"
	.section	.rodata.__func__.11372,"a",%progbits
	.set	.LANCHOR227,. + 0
	.type	__func__.11372, %object
	.size	__func__.11372, 16
__func__.11372:
	.ascii	"gc_scan_src_blk\000"
	.section	.rodata.__func__.11433,"a",%progbits
	.set	.LANCHOR228,. + 0
	.type	__func__.11433, %object
	.size	__func__.11433, 20
__func__.11433:
	.ascii	"gc_scan_static_data\000"
	.section	.rodata.__func__.11500,"a",%progbits
	.set	.LANCHOR237,. + 0
	.type	__func__.11500, %object
	.size	__func__.11500, 11
__func__.11500:
	.ascii	"zftl_do_gc\000"
	.section	.rodata.__func__.11595,"a",%progbits
	.set	.LANCHOR5,. + 0
	.type	__func__.11595, %object
	.size	__func__.11595, 18
__func__.11595:
	.ascii	"_list_remove_node\000"
	.section	.rodata.__func__.11620,"a",%progbits
	.set	.LANCHOR11,. + 0
	.type	__func__.11620, %object
	.size	__func__.11620, 23
__func__.11620:
	.ascii	"_list_update_data_list\000"
	.section	.rodata.__func__.11695,"a",%progbits
	.set	.LANCHOR154,. + 0
	.type	__func__.11695, %object
	.size	__func__.11695, 20
__func__.11695:
	.ascii	"zftl_sblk_list_init\000"
	.section	.rodata.__func__.11729,"a",%progbits
	.set	.LANCHOR196,. + 0
	.type	__func__.11729, %object
	.size	__func__.11729, 15
__func__.11729:
	.ascii	"ftl_info_flush\000"
	.section	.rodata.__func__.11761,"a",%progbits
	.set	.LANCHOR135,. + 0
	.type	__func__.11761, %object
	.size	__func__.11761, 15
__func__.11761:
	.ascii	"ftl_alloc_sblk\000"
	.section	.rodata.__func__.11803,"a",%progbits
	.set	.LANCHOR113,. + 0
	.type	__func__.11803, %object
	.size	__func__.11803, 18
__func__.11803:
	.ascii	"ftl_alloc_sys_blk\000"
	.section	.rodata.__func__.11813,"a",%progbits
	.set	.LANCHOR114,. + 0
	.type	__func__.11813, %object
	.size	__func__.11813, 17
__func__.11813:
	.ascii	"ftl_free_sys_blk\000"
	.section	.rodata.__func__.11848,"a",%progbits
	.set	.LANCHOR229,. + 0
	.type	__func__.11848, %object
	.size	__func__.11848, 14
__func__.11848:
	.ascii	"ftl_sblk_dump\000"
	.section	.rodata.__func__.11872,"a",%progbits
	.set	.LANCHOR218,. + 0
	.type	__func__.11872, %object
	.size	__func__.11872, 16
__func__.11872:
	.ascii	"ftl_sysblk_dump\000"
	.section	.rodata.__func__.11897,"a",%progbits
	.set	.LANCHOR219,. + 0
	.type	__func__.11897, %object
	.size	__func__.11897, 23
__func__.11897:
	.ascii	"ftl_open_sblk_recovery\000"
	.section	.rodata.__func__.11930,"a",%progbits
	.set	.LANCHOR115,. + 0
	.type	__func__.11930, %object
	.size	__func__.11930, 23
__func__.11930:
	.ascii	"ftl_get_ppa_from_index\000"
	.section	.rodata.__func__.11951,"a",%progbits
	.set	.LANCHOR231,. + 0
	.type	__func__.11951, %object
	.size	__func__.11951, 19
__func__.11951:
	.ascii	"ftl_update_l2p_map\000"
	.section	.rodata.__func__.11970,"a",%progbits
	.set	.LANCHOR119,. + 0
	.type	__func__.11970, %object
	.size	__func__.11970, 22
__func__.11970:
	.ascii	"ftl_get_new_free_page\000"
	.section	.rodata.__func__.11981,"a",%progbits
	.set	.LANCHOR120,. + 0
	.type	__func__.11981, %object
	.size	__func__.11981, 22
__func__.11981:
	.ascii	"ftl_ext_alloc_new_blk\000"
	.section	.rodata.__func__.12007,"a",%progbits
	.set	.LANCHOR201,. + 0
	.type	__func__.12007, %object
	.size	__func__.12007, 19
__func__.12007:
	.ascii	"ftl_ext_info_flush\000"
	.section	.rodata.__func__.12019,"a",%progbits
	.set	.LANCHOR202,. + 0
	.type	__func__.12019, %object
	.size	__func__.12019, 18
__func__.12019:
	.ascii	"ftl_ext_info_init\000"
	.section	.rodata.__func__.12058,"a",%progbits
	.set	.LANCHOR203,. + 0
	.type	__func__.12058, %object
	.size	__func__.12058, 25
__func__.12058:
	.ascii	"ftl_low_format_data_init\000"
	.section	.rodata.__func__.12073,"a",%progbits
	.set	.LANCHOR205,. + 0
	.type	__func__.12073, %object
	.size	__func__.12073, 15
__func__.12073:
	.ascii	"ftl_low_format\000"
	.section	.rodata.__func__.12121,"a",%progbits
	.set	.LANCHOR192,. + 0
	.type	__func__.12121, %object
	.size	__func__.12121, 14
__func__.12121:
	.ascii	"ftl_prog_page\000"
	.section	.rodata.__func__.12244,"a",%progbits
	.set	.LANCHOR183,. + 0
	.type	__func__.12244, %object
	.size	__func__.12244, 31
__func__.12244:
	.ascii	"queue_wait_first_req_completed\000"
	.section	.rodata.__func__.12298,"a",%progbits
	.set	.LANCHOR184,. + 0
	.type	__func__.12298, %object
	.size	__func__.12298, 15
__func__.12298:
	.ascii	"sblk_prog_page\000"
	.section	.rodata.__func__.12325,"a",%progbits
	.set	.LANCHOR187,. + 0
	.type	__func__.12325, %object
	.size	__func__.12325, 15
__func__.12325:
	.ascii	"sblk_read_page\000"
	.section	.rodata.__func__.12395,"a",%progbits
	.set	.LANCHOR220,. + 0
	.type	__func__.12395, %object
	.size	__func__.12395, 16
__func__.12395:
	.ascii	"load_l2p_region\000"
	.section	.rodata.__func__.12411,"a",%progbits
	.set	.LANCHOR156,. + 0
	.type	__func__.12411, %object
	.size	__func__.12411, 13
__func__.12411:
	.ascii	"pm_free_sblk\000"
	.section	.rodata.__func__.12435,"a",%progbits
	.set	.LANCHOR222,. + 0
	.type	__func__.12435, %object
	.size	__func__.12435, 6
__func__.12435:
	.ascii	"pm_gc\000"
	.section	.rodata.__func__.12451,"a",%progbits
	.set	.LANCHOR137,. + 0
	.type	__func__.12451, %object
	.size	__func__.12451, 17
__func__.12451:
	.ascii	"pm_alloc_new_blk\000"
	.section	.rodata.__func__.12461,"a",%progbits
	.set	.LANCHOR206,. + 0
	.type	__func__.12461, %object
	.size	__func__.12461, 14
__func__.12461:
	.ascii	"pm_write_page\000"
	.section	.rodata.__func__.12479,"a",%progbits
	.set	.LANCHOR140,. + 0
	.type	__func__.12479, %object
	.size	__func__.12479, 21
__func__.12479:
	.ascii	"pm_select_ram_region\000"
	.section	.rodata.__func__.9819,"a",%progbits
	.set	.LANCHOR173,. + 0
	.type	__func__.9819, %object
	.size	__func__.9819, 19
__func__.9819:
	.ascii	"flash_read_page_en\000"
	.section	.rodata.__func__.9880,"a",%progbits
	.set	.LANCHOR189,. + 0
	.type	__func__.9880, %object
	.size	__func__.9880, 19
__func__.9880:
	.ascii	"flash_prog_page_en\000"
	.section	.rodata.__func__.9896,"a",%progbits
	.set	.LANCHOR44,. + 0
	.type	__func__.9896, %object
	.size	__func__.9896, 26
__func__.9896:
	.ascii	"flash_erase_duplane_block\000"
	.section	.rodata.__func__.9907,"a",%progbits
	.set	.LANCHOR46,. + 0
	.type	__func__.9907, %object
	.size	__func__.9907, 21
__func__.9907:
	.ascii	"flash_erase_block_en\000"
	.section	.rodata.__func__.9921,"a",%progbits
	.set	.LANCHOR29,. + 0
	.type	__func__.9921, %object
	.size	__func__.9921, 28
__func__.9921:
	.ascii	"flash_wait_device_ready_raw\000"
	.section	.rodata.__func__.9945,"a",%progbits
	.set	.LANCHOR178,. + 0
	.type	__func__.9945, %object
	.size	__func__.9945, 26
__func__.9945:
	.ascii	"flash_start_tlc_page_prog\000"
	.section	.rodata.__func__.9956,"a",%progbits
	.set	.LANCHOR179,. + 0
	.type	__func__.9956, %object
	.size	__func__.9956, 29
__func__.9956:
	.ascii	"flash_start_3d_mlc_page_prog\000"
	.section	.rodata.__func__.9974,"a",%progbits
	.set	.LANCHOR180,. + 0
	.type	__func__.9974, %object
	.size	__func__.9974, 22
__func__.9974:
	.ascii	"flash_start_page_prog\000"
	.section	.rodata.__func__.9985,"a",%progbits
	.set	.LANCHOR35,. + 0
	.type	__func__.9985, %object
	.size	__func__.9985, 22
__func__.9985:
	.ascii	"flash_start_page_read\000"
	.section	.rodata.__func__.9998,"a",%progbits
	.set	.LANCHOR181,. + 0
	.type	__func__.9998, %object
	.size	__func__.9998, 31
__func__.9998:
	.ascii	"flash_complete_plane_page_read\000"
	.section	.rodata._list_remove_node.str1.1,"aMS",%progbits,1
.LC0:
	.ascii	"\012!!!!! error @ func:%s - line:%d\012\000"
	.section	.rodata.dump_buf_info.str1.1,"aMS",%progbits,1
.LC41:
	.ascii	"sblk_queue_head = %d\012\000"
.LC42:
	.ascii	"sblk_read_completed_queue_head = %d\012\000"
.LC43:
	.ascii	"sblk_gc_write_completed_queue_head = %d\012\000"
.LC44:
	.ascii	"sblk_write_completed_queue_head = %d\012\000"
.LC45:
	.ascii	"p_free_buf_head = %d\012\000"
.LC46:
	.ascii	"free_buf_count = %d\012\000"
.LC47:
	.ascii	"buf = %d, next=%d, flag=%d gc_write_flag=%d, lun_st"
	.ascii	"ate=%d, op_status = %d lpa=%x, ppa=%x\012\000"
	.section	.rodata.dump_ftl_info.str1.1,"aMS",%progbits,1
.LC189:
	.ascii	"free_buf_count: %d\012\000"
.LC190:
	.ascii	"g_ftl_info_blk blk:0x%x, index:0x%x, page:0x%x\012\000"
.LC191:
	.ascii	"ftl_ext_info_blk blk:0x%x, page:0x%x\012\000"
.LC192:
	.ascii	"ac_blk:0x%x, page:0x%x, index:0x%x, free:0x%x, page"
	.ascii	"_index:0x%x\012\000"
.LC193:
	.ascii	"tmp_blk:0x%x, page:0x%x, index:0x%x, free:0x%x, pag"
	.ascii	"e_index:0x%x\012\000"
.LC194:
	.ascii	"gc_blk:0x%x, page:0x%x, index:0x%x, free:0x%x, page"
	.ascii	"_index:0x%x\012\000"
.LC195:
	.ascii	"lpa:\000"
.LC196:
	.ascii	"vpn:\000"
.LC197:
	.ascii	"sblk:\000"
.LC198:
	.ascii	"lpa_hash:\000"
.LC199:
	.ascii	"lpa_hash_index:\000"
	.section	.rodata.dump_pm_blk.str1.1,"aMS",%progbits,1
.LC254:
	.ascii	"pm l2p:\000"
.LC255:
	.ascii	"pm blk:\000"
	.section	.rodata.dump_sblk_queue.str1.1,"aMS",%progbits,1
.LC80:
	.ascii	"dump_sblk_queue: %d\012\000"
.LC81:
	.ascii	"buf id= %d state = %d ppa = %x\012\000"
	.section	.rodata.flash_complete_page_read.str1.1,"aMS",%progbits,1
.LC139:
	.ascii	"flash_complete_page_read %x %x error_ecc %d %d\012\000"
	.section	.rodata.flash_ddr_tuning_read.str1.1,"aMS",%progbits,1
.LC125:
	.ascii	"%d flash_ddr_tuning_read %x ecc=%d\012\000"
.LC126:
	.ascii	"sync para %d\012\000"
.LC127:
	.ascii	"DDR mode Read error %x %x\012\000"
.LC128:
	.ascii	"SDR mode Read %x %x ecc:%x\012\000"
	.section	.rodata.flash_erase_all.str1.1,"aMS",%progbits,1
.LC35:
	.ascii	"erase done: %x\012\000"
	.section	.rodata.flash_erase_block_en.str1.1,"aMS",%progbits,1
.LC33:
	.ascii	"flash_erase_block %x %x %x\012\000"
.LC34:
	.ascii	"flash_erase_block %d block = %x status = %x\012\000"
	.section	.rodata.flash_erase_duplane_block.str1.1,"aMS",%progbits,1
.LC31:
	.ascii	"flash_erase_duplane_block %x %x %x\012\000"
.LC32:
	.ascii	"flash_erase_duplane_block pageadd = %x status = %x\012"
	.ascii	"\000"
	.section	.rodata.flash_get_last_written_page.str1.1,"aMS",%progbits,1
.LC131:
	.ascii	"flash_get_last_written_page: %x %x %x\012\000"
	.section	.rodata.flash_info_blk_init.str1.1,"aMS",%progbits,1
.LC174:
	.ascii	"...%d @ %s %d %p\012\000"
.LC175:
	.ascii	"no sys info %x\012\000"
	.section	.rodata.flash_info_data_init.str1.1,"aMS",%progbits,1
.LC97:
	.ascii	"...%d @ %s\012\000"
	.section	.rodata.flash_info_flush.str1.1,"aMS",%progbits,1
.LC171:
	.ascii	"finfo:\000"
.LC172:
	.ascii	"flash_info_flush id = %x, page = %x\012\000"
.LC173:
	.ascii	"sys_info_flush error:%x\012\000"
	.section	.rodata.flash_mask_bad_block.str1.1,"aMS",%progbits,1
.LC48:
	.ascii	"flash_mask_bad_block %d %d\012\000"
	.section	.rodata.flash_prog_page.str1.1,"aMS",%progbits,1
.LC132:
	.ascii	"flash_prog_page %x %x %x\012\000"
.LC133:
	.ascii	"flash_prog_page page_addr = %x status = %x\012\000"
	.section	.rodata.flash_prog_page_en.str1.1,"aMS",%progbits,1
.LC147:
	.ascii	"flash_prog_page_en:%x %x %x\012\000"
.LC148:
	.ascii	"w d:\000"
.LC149:
	.ascii	"w s:\000"
.LC150:
	.ascii	"spare\000"
.LC151:
	.ascii	"data\000"
.LC152:
	.ascii	"write error: %x\012\000"
	.section	.rodata.flash_read_id.str1.1,"aMS",%progbits,1
.LC38:
	.ascii	"No.%d FLASH ID:%x %x %x %x %x %x\012\000"
	.section	.rodata.flash_read_otp_data.str1.1,"aMS",%progbits,1
.LC39:
	.ascii	"otp:%x %x %x %x\012\000"
	.section	.rodata.flash_read_page_en.str1.1,"aMS",%progbits,1
.LC129:
	.ascii	"flash_read_page_en %x %x %x %x\012\000"
.LC130:
	.ascii	"flash_read_page_en %x %x error_ecc %d %d\012\000"
	.section	.rodata.flash_set_interface_mode.str1.1,"aMS",%progbits,1
.LC36:
	.ascii	"nand sdr mode %x\012\000"
.LC37:
	.ascii	"nand ddr mode %x\012\000"
	.section	.rodata.ftl_alloc_new_data_sblk.str1.1,"aMS",%progbits,1
.LC232:
	.ascii	"error gc_add_sblk: %x\012\000"
	.section	.rodata.ftl_alloc_sblk.str1.1,"aMS",%progbits,1
.LC79:
	.ascii	"alloc sblk %x %d\012\000"
	.section	.rodata.ftl_dump_write_open_sblk.str1.1,"aMS",%progbits,1
.LC166:
	.ascii	"ftl_sblk_dump_write = %x %d %d %d %d\012\000"
.LC167:
	.ascii	"blk= %x, page=%x, ppa = %x, status = %x, data:%x %x"
	.ascii	" %x %x, spare: %x %x %x %x\012\000"
.LC168:
	.ascii	"ftl_sblk_dump_write2 = %x %d %d %d\012\000"
.LC169:
	.ascii	"ftl_sblk_dump_write = %x %x\012\000"
.LC170:
	.ascii	"ftl_sblk_dump_write done = %x\012\000"
	.section	.rodata.ftl_ext_info_init.str1.1,"aMS",%progbits,1
.LC159:
	.ascii	"%s %d %d %x %x\012\000"
.LC160:
	.ascii	"ext info hash %x error\012\000"
.LC161:
	.ascii	"%s %x %x %x\012\000"
	.section	.rodata.ftl_free_sblk.str1.1,"aMS",%progbits,1
.LC68:
	.ascii	"swl_slc_free_mini_ec_blk sblk %x\012\000"
	.section	.rodata.ftl_info_blk_init.str1.1,"aMS",%progbits,1
.LC155:
	.ascii	"%d %x @%d %x\012\000"
.LC156:
	.ascii	"ftl_info_blk_init %d %d %x\012\000"
.LC157:
	.ascii	"ftl info hash %x error\012\000"
.LC158:
	.ascii	"ink flag: %x\012\000"
	.section	.rodata.ftl_info_flush.str1.1,"aMS",%progbits,1
.LC154:
	.ascii	"g_ftl_info_blk blk = %x, page = %x version = %d\012"
	.ascii	"\000"
	.section	.rodata.ftl_low_format.str1.1,"aMS",%progbits,1
.LC162:
	.ascii	"ftl_low_format %d\012\000"
.LC163:
	.ascii	"low format %d %d %d %d\012\000"
	.section	.rodata.ftl_mask_bad_block.str1.1,"aMS",%progbits,1
.LC66:
	.ascii	"mask bad block:cs %x %x block: %x %x\012\000"
	.section	.rodata.ftl_open_sblk_recovery.str1.1,"aMS",%progbits,1
.LC177:
	.ascii	"saved_active_page  = %x\012\000"
.LC178:
	.ascii	"saved_active_plane = %x\012\000"
.LC179:
	.ascii	"sblk = %x\012\000"
.LC180:
	.ascii	"phy_blk = %x %x\012\000"
.LC181:
	.ascii	"num_planes = %x\012\000"
.LC182:
	.ascii	"recovery blk=%x, page=%x, ppa = %x, status = %x, ha"
	.ascii	"sh:%x\012\000"
.LC183:
	.ascii	"data:\000"
.LC184:
	.ascii	"sblk = %x, vpn0 = %d, vpn1 = %d\012\000"
.LC185:
	.ascii	"dump_write_lpa = %x %x %x %x\012\000"
.LC186:
	.ascii	"dump write new ppa = %x, last ppa = %x lpa = %x\012"
	.ascii	"\000"
.LC187:
	.ascii	"dump write = %x %x %x\012\000"
.LC188:
	.ascii	"dump write hash update = %x %x %x\012\000"
	.section	.rodata.ftl_re_low_format.str1.1,"aMS",%progbits,1
.LC164:
	.ascii	"re low format %d\012\000"
	.section	.rodata.ftl_sblk_dump.str1.1,"aMS",%progbits,1
.LC220:
	.ascii	"ftl_sblk_dump = %x %d %d %d %d\012\000"
.LC221:
	.ascii	"ftl_sblk_dump = %x %x %x %x\012\000"
.LC222:
	.ascii	"page_addr = %x, lpa=%x vpn = %d\012\000"
.LC223:
	.ascii	"index= %x, lpa=%x\012\000"
.LC224:
	.ascii	"block = %x, vpn=%x check vpn = %x\012\000"
	.section	.rodata.ftl_sysblk_dump.str1.1,"aMS",%progbits,1
.LC176:
	.ascii	"l2p:\000"
	.section	.rodata.ftl_test_block.str1.1,"aMS",%progbits,1
.LC153:
	.ascii	"low format %d\012\000"
	.section	.rodata.ftl_update_l2p_map.str1.1,"aMS",%progbits,1
.LC228:
	.ascii	"ftl_update_l2p_map: %x %x %x\012\000"
.LC229:
	.ascii	"ftl_update_l2p_map\000"
.LC230:
	.ascii	"lpa_tbl:\000"
.LC231:
	.ascii	"sblk %x vpn: %d %d\012\000"
	.section	.rodata.ftl_vpn_decrement.str1.1,"aMS",%progbits,1
.LC65:
	.ascii	"ftl_vpn_decrement %x = %d, %d\012\000"
	.section	.rodata.ftl_write_commit.str1.1,"aMS",%progbits,1
.LC233:
	.ascii	"%d read error: ppa:%x, lpa:%x, status:%x\012\000"
	.section	.rodata.ftl_write_completed.str1.1,"aMS",%progbits,1
.LC77:
	.ascii	"ftl prog error =%x, lpa = %x, ppa= %x\012\000"
.LC78:
	.ascii	"ftl re prog: lpa = %x, ppa= %x\012\000"
	.section	.rodata.gc_add_sblk.str1.1,"aMS",%progbits,1
.LC49:
	.ascii	"gc_add_sblk = %d, %d, %d, %d, %d, %d, %d\012\000"
.LC50:
	.ascii	"gc_add_sblk = %d, %d, %d\012\000"
.LC51:
	.ascii	"gc_add_sblk = %d, %d, %d,last update:%d, %d\012\000"
.LC52:
	.ascii	"gc_add_sblk = %d, %d, %d, %d, %d, %d\012\000"
	.section	.rodata.gc_check_data_one_wl.str1.1,"aMS",%progbits,1
.LC146:
	.ascii	"err: ppa = %x, status = %x, %x %x spare: %x %x %x %"
	.ascii	"x\012\000"
	.section	.rodata.gc_do_copy_back.str1.1,"aMS",%progbits,1
.LC234:
	.ascii	"gc page in buf: lpa %x ppa = %x pageindex= %x\012\000"
.LC235:
	.ascii	"gc_do_copy_back: lpa %x des_ppa = %x %x gc_ppa= %x "
	.ascii	"page_index= %d\012\000"
	.section	.rodata.gc_free_bad_sblk.str1.1,"aMS",%progbits,1
.LC67:
	.ascii	"gc_free_bad_sblk 0x%x\012\000"
	.section	.rodata.gc_free_src_blk.str1.1,"aMS",%progbits,1
.LC69:
	.ascii	"gc_free_src_blk = %x, vpn = %d\012\000"
.LC70:
	.ascii	"gc_free_src_blk %x, %d\012\000"
	.section	.rodata.gc_free_temp_buf.str1.1,"aMS",%progbits,1
.LC55:
	.ascii	"%d gc_free_temp_buf buf id= %x\012\000"
	.section	.rodata.gc_mark_bad_ppa.str1.1,"aMS",%progbits,1
.LC53:
	.ascii	"gc_mark_bad_ppa %d %x %x\012\000"
	.section	.rodata.gc_recovery.str1.1,"aMS",%progbits,1
.LC210:
	.ascii	"ppa = %x, status = %x, data:%x %x %x %x, spare: %x "
	.ascii	"%x %x %x\012\000"
.LC211:
	.ascii	"ppa = %x, status = %x, %x %x spare: %x %x %x %x\012"
	.ascii	"\000"
.LC212:
	.ascii	"gc_recovery: %x vpn = %x\012\000"
	.section	.rodata.gc_scan_src_blk.str1.1,"aMS",%progbits,1
.LC217:
	.ascii	"gc_scan_src_blk = %x, vpn = %d\012\000"
.LC218:
	.ascii	"js hash error:%x %x %x\012\000"
.LC219:
	.ascii	"gc_scan_src_blk = %x, s vpn0 = %d, c vpn1 = %d\012\000"
	.section	.rodata.gc_search_src_blk.str1.1,"aMS",%progbits,1
.LC57:
	.ascii	"zftl_get_gc_node cache = %x index = %d vpn = %x\012"
	.ascii	"\000"
.LC58:
	.ascii	"gc_search_src_blk mode = %x, src mode = %x, count= "
	.ascii	"%d %d\012\000"
	.section	.rodata.gc_static_wearleveling.str1.1,"aMS",%progbits,1
.LC85:
	.ascii	"gc_static_wearleveling: min blk: %x,sec=%d,xec = %d"
	.ascii	" ,mode=%d, func=%x, bbt=%x vpn = %d\012\000"
.LC86:
	.ascii	"gc_static_wearleveling: min slc blk: %x,sec=%d,xec "
	.ascii	"= %d ,mode=%d, func=%x, bbt=%x vpn = %d\012\000"
.LC87:
	.ascii	"gc_static_wearleveling: min tlc blk: %x,sec=%d,xec "
	.ascii	"= %d ,mode=%d, func=%x, bbt=%x vpn = %d\012\000"
.LC88:
	.ascii	"gc_static_wearleveling: max slc blk: %x,sec=%d,xec "
	.ascii	"= %d ,mode=%d, func=%x, bbt=%x vpn = %d\012\000"
.LC89:
	.ascii	"gc_static_wearleveling: max xlc blk: %x,sec=%d,xec "
	.ascii	"= %d ,mode=%d, func=%x, bbt=%x vpn = %d\012\000"
.LC90:
	.ascii	"gc_static_wearleveling: slc blk: %x, tlc blk: %d av"
	.ascii	"g slc ec: %d, avg tlc ec: %d \012\000"
.LC91:
	.ascii	"gc_static_wearleveling: min slc ec: %x, min tlc ec:"
	.ascii	" %d max slc ec: %d, max tlc ec: %d; %d %d\012\000"
.LC92:
	.ascii	"swl add tlc gc = %x, %d, %d, %d, %d, %d\012\000"
.LC93:
	.ascii	"swl add slc gc  = %x, %d, %d, %d, %d, %d\012\000"
	.section	.rodata.gc_update_l2p_map_new.str1.1,"aMS",%progbits,1
.LC213:
	.ascii	"gc_update_l2p_map_new sblk %x\012\000"
.LC214:
	.ascii	"gc_update_l2p_map_new: %x %x %x\012\000"
.LC215:
	.ascii	"lpa: %x %x %x\012\000"
.LC216:
	.ascii	"gc_update_l2p_map_new: %x vpn = %x vpn1 = %x done\012"
	.ascii	"\000"
	.section	.rodata.gc_write_completed.str1.1,"aMS",%progbits,1
.LC54:
	.ascii	"status: %x, ppa: %x\012\000"
	.section	.rodata.hynix_get_read_retry_default.str1.1,"aMS",%progbits,1
.LC105:
	.ascii	"otp error! %d\000"
.LC106:
	.ascii	"rr\000"
	.section	.rodata.hynix_read_retrial.str1.1,"aMS",%progbits,1
.LC124:
	.ascii	"hynix RR %d row=%x, count %d, status=%d\012\000"
	.section	.rodata.idb_write_data.str1.1,"aMS",%progbits,1
.LC135:
	.ascii	"1 write_idblock fix data %x %x %x\012\000"
.LC136:
	.ascii	"write_idblock check fail! %x\012\000"
.LC137:
	.ascii	"write_idblock fail! %x\012\000"
	.section	.rodata.load_l2p_region.str1.1,"aMS",%progbits,1
.LC201:
	.ascii	"region_id = %d, pm_max_region = %d\012\000"
.LC202:
	.ascii	"load_l2p_region no ppa = %x , %x, all setting 0xff."
	.ascii	"...\012\000"
.LC203:
	.ascii	"load_l2p_region = %x,%x,%x, %x\012\000"
.LC204:
	.ascii	"pm_ppa:\000"
.LC205:
	.ascii	"spare:\000"
	.section	.rodata.lpa_rebuild_hash.str1.1,"aMS",%progbits,1
.LC84:
	.ascii	"%s %d %d\012\000"
	.section	.rodata.micron_read_retrial.str1.1,"aMS",%progbits,1
.LC115:
	.ascii	"MT %d row=%x,last status %d,status = %d\012\000"
.LC116:
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
	.ascii	"OptMode: %x\012\000"
.LC15:
	.ascii	"g_nand_max_die: %x\012\000"
.LC16:
	.ascii	"Cache read enable: %x\012\000"
.LC17:
	.ascii	"Cache random read enable: %x\012\000"
.LC18:
	.ascii	"Cache prog enable: %x\012\000"
.LC19:
	.ascii	"multi read enable: %x\012\000"
.LC20:
	.ascii	"multi prog enable: %x\012\000"
.LC21:
	.ascii	"interleave enable: %x\012\000"
.LC22:
	.ascii	"read retry enable: %x\012\000"
.LC23:
	.ascii	"randomizer enable: %x\012\000"
.LC24:
	.ascii	"SDR enable: %x\012\000"
.LC25:
	.ascii	"ONFI enable: %x\012\000"
.LC26:
	.ascii	"TOGGLE enable: %x\012\000"
.LC27:
	.ascii	"g_flash_slc_mode: %x %x\012\000"
.LC28:
	.ascii	"MultiPlaneProgCmd: %x %x\012\000"
.LC29:
	.ascii	"MultiPlaneReadCmd: %x %x\012\000"
.LC30:
	.ascii	"g_flash_toggle_mode_en: %x\012\000"
	.section	.rodata.nandc_init.str1.1,"aMS",%progbits,1
.LC98:
	.ascii	"...%s enter... %p\012\000"
.LC99:
	.ascii	"0:%x %x %x %x %x\012\000"
.LC100:
	.ascii	"g_nandc_ver...%d\012\000"
	.section	.rodata.nandc_xfer.str1.1,"aMS",%progbits,1
.LC112:
	.ascii	"dqs data abort %x\012\000"
.LC113:
	.ascii	"dqs data timeout %x\012\000"
.LC114:
	.ascii	"xfer error %x\012\000"
	.section	.rodata.nandc_xfer_done.str1.1,"aMS",%progbits,1
.LC107:
	.ascii	"flash_abort_clear = %d\012\000"
.LC108:
	.ascii	"%d mtrans_cnt = %d page_num = %d\012\000"
.LC109:
	.ascii	"%d flReg.d32=%x %x\012\000"
.LC110:
	.ascii	"nandc:\000"
.LC111:
	.ascii	"nandc_xfer_done read error %x\012\000"
	.section	.rodata.pm_alloc_new_blk.str1.1,"aMS",%progbits,1
.LC82:
	.ascii	"blk %x is bad block\012\000"
.LC83:
	.ascii	"pm_alloc_new_blk: %x %x %x %x\012\000"
	.section	.rodata.pm_free_sblk.str1.1,"aMS",%progbits,1
.LC95:
	.ascii	"GC PM block %x %x %x %d\012\000"
.LC96:
	.ascii	"ftl_free_no_use_map_blk %x %x %x %d\012\000"
	.section	.rodata.pm_init.str1.1,"aMS",%progbits,1
.LC206:
	.ascii	"pm_init posr %x %x %x\012\000"
.LC207:
	.ascii	"pm_init recovery %x %x %x\012\000"
.LC208:
	.ascii	"pm_init hash %x error\012\000"
	.section	.rodata.pm_log2phys.str1.1,"aMS",%progbits,1
.LC209:
	.ascii	"pm_log2phys  lpn = %d, max lpn = %d\012\000"
	.section	.rodata.pm_ppa_update_check.str1.1,"aMS",%progbits,1
.LC200:
	.ascii	"%s w error lpn = %x, max ppa = %d\012\000"
	.section	.rodata.pm_write_page.str1.1,"aMS",%progbits,1
.LC165:
	.ascii	"pm_write_page write error: %x\012\000"
	.section	.rodata.print_ftl_debug_info.str1.1,"aMS",%progbits,1
.LC71:
	.ascii	"bad blk = %x, %x free blk: s:%x,t:%x,m:%x, data blk"
	.ascii	":s:%x,%x,t%x vpn: s:%x t:%x, max_vpn: %x\012\000"
.LC72:
	.ascii	"totle w: %d MB,r: %d MB %d dv:0x%X,poc:%d\012\000"
.LC73:
	.ascii	"gc xlc page: %d,gc slc page: %d, tmp w: %d MB\012\000"
.LC74:
	.ascii	"slc ec: %d,%d,%d,%d,%d,tlc ec: %d,%d,%d,%d,%d\012\000"
.LC75:
	.ascii	"gc th: tlc_tlc: %d tlc_slc: %d slc_slc: %d slc_tlc:"
	.ascii	"%d free_th: %d\012\000"
.LC76:
	.ascii	"swl : %x %x %x %x %x %x\012\000"
	.section	.rodata.print_gc_debug_info.str1.1,"aMS",%progbits,1
.LC56:
	.ascii	"gc: b:%x,p:%x,i:%x; free buf=%d %d free slc th: %d\012"
	.ascii	"\000"
	.section	.rodata.print_list_info.str1.1,"aMS",%progbits,1
.LC63:
	.ascii	"list count:%p %d\012\000"
.LC64:
	.ascii	"%d: node:%x %x %x %x, %d %d %d %d %d\012\000"
	.section	.rodata.queue_wait_first_req_completed.str1.1,"aMS",%progbits,1
.LC140:
	.ascii	"read: %x %x %x %x\012\000"
.LC141:
	.ascii	"0set buf %d,status = %x, ppa = %x lun state = %d\012"
	.ascii	"\000"
.LC142:
	.ascii	"prog end %x %x error_ecc %d %d\012\000"
.LC143:
	.ascii	"1set buf %d,status = %x, ppa = %x lun state = %d\012"
	.ascii	"\000"
.LC144:
	.ascii	"dp prog end %x %x error_ecc %d %d\012\000"
	.section	.rodata.random_seed,"a",%progbits
	.align	1
	.set	.LANCHOR55,. + 0
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
.LC251:
	.ascii	"zftl_init %x\012\000"
	.section	.rodata.rknand_print_hex.str1.1,"aMS",%progbits,1
.LC101:
	.ascii	"%s %p + 0x%x:\000"
.LC102:
	.ascii	"%x \000"
.LC103:
	.ascii	"\000"
.LC104:
	.ascii	"%s\012\000"
	.section	.rodata.samsung_14nm_mlc_rr,"a",%progbits
	.set	.LANCHOR171,. + 0
	.type	samsung_14nm_mlc_rr, %object
	.size	samsung_14nm_mlc_rr, 104
samsung_14nm_mlc_rr:
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	-4
	.byte	3
	.byte	-4
	.byte	-6
	.byte	6
	.byte	0
	.byte	6
	.byte	-10
	.byte	-10
	.byte	4
	.byte	-10
	.byte	16
	.byte	12
	.byte	-4
	.byte	12
	.byte	8
	.byte	-16
	.byte	10
	.byte	-16
	.byte	24
	.byte	18
	.byte	-14
	.byte	18
	.byte	-4
	.byte	-22
	.byte	-16
	.byte	-22
	.byte	-8
	.byte	24
	.byte	-9
	.byte	24
	.byte	8
	.byte	-28
	.byte	-4
	.byte	-28
	.byte	16
	.byte	30
	.byte	10
	.byte	30
	.byte	10
	.byte	-34
	.byte	6
	.byte	-34
	.byte	0
	.byte	36
	.byte	-8
	.byte	36
	.byte	-8
	.byte	-40
	.byte	-2
	.byte	-40
	.byte	-20
	.byte	-46
	.byte	-4
	.byte	-46
	.byte	-30
	.byte	3
	.byte	0
	.byte	3
	.byte	-3
	.byte	-2
	.byte	-4
	.byte	-2
	.byte	-6
	.byte	-4
	.byte	-4
	.byte	-4
	.byte	-10
	.byte	-6
	.byte	-8
	.byte	-6
	.byte	-14
	.byte	-9
	.byte	-8
	.byte	-9
	.byte	-18
	.byte	-52
	.byte	22
	.byte	-52
	.byte	10
	.byte	42
	.byte	4
	.byte	42
	.byte	4
	.byte	48
	.byte	-9
	.byte	48
	.byte	4
	.byte	-58
	.byte	12
	.byte	-58
	.byte	0
	.byte	-64
	.byte	-24
	.byte	-64
	.byte	-6
	.byte	9
	.byte	18
	.byte	9
	.byte	8
	.section	.rodata.samsung_14nm_slc_rr,"a",%progbits
	.set	.LANCHOR170,. + 0
	.type	samsung_14nm_slc_rr, %object
	.size	samsung_14nm_slc_rr, 26
samsung_14nm_slc_rr:
	.byte	0
	.byte	10
	.byte	-10
	.byte	20
	.byte	-20
	.byte	30
	.byte	-30
	.byte	40
	.byte	-40
	.byte	50
	.byte	-50
	.byte	60
	.byte	-60
	.byte	-70
	.byte	-80
	.byte	-90
	.byte	-100
	.byte	-110
	.byte	-120
	.byte	-9
	.byte	70
	.byte	80
	.byte	90
	.byte	-125
	.byte	-115
	.byte	100
	.section	.rodata.samsung_read_retrial.str1.1,"aMS",%progbits,1
.LC121:
	.ascii	"samsung SRR %d row=%x, status=%d\012\000"
.LC122:
	.ascii	"samsung TRR %d row=%x, status=%d\012\000"
.LC123:
	.ascii	"samsung RR %d row=%x,count %d,status=%d\012\000"
	.section	.rodata.sandisk_prog_test_bad_block.str1.1,"aMS",%progbits,1
.LC40:
	.ascii	"bad block test:%x %x\012\000"
	.section	.rodata.sblk_mlc_dump_prog.str1.1,"aMS",%progbits,1
.LC138:
	.ascii	"sblk_mlc_dump_prog wl_addr= %x ppa = %x ppa = %x\012"
	.ascii	"\000"
	.section	.rodata.sblk_prog_page.str1.1,"aMS",%progbits,1
.LC145:
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
	.set	.LANCHOR39,. + 0
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
	.set	.LANCHOR38,. + 0
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
.LC117:
	.ascii	"toshiba SRR %d row=%x, status=%d\012\000"
.LC118:
	.ascii	"toshiba TRR %d row=%x, status=%d\012\000"
.LC119:
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
	.section	.rodata.ymtc_3D_slc_value,"a",%progbits
	.set	.LANCHOR43,. + 0
	.type	ymtc_3D_slc_value, %object
	.size	ymtc_3D_slc_value, 10
ymtc_3D_slc_value:
	.byte	0
	.byte	-8
	.byte	8
	.byte	-16
	.byte	-20
	.byte	24
	.byte	-26
	.byte	40
	.byte	-12
	.byte	56
	.section	.rodata.ymtc_3D_tlc_value,"a",%progbits
	.set	.LANCHOR42,. + 0
	.type	ymtc_3D_tlc_value, %object
	.size	ymtc_3D_tlc_value, 357
ymtc_3D_tlc_value:
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	-10
	.byte	-10
	.byte	-6
	.byte	-6
	.byte	-2
	.byte	2
	.byte	2
	.byte	-6
	.byte	-6
	.byte	-4
	.byte	-4
	.byte	-4
	.byte	-6
	.byte	-8
	.byte	6
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	-2
	.byte	-2
	.byte	-2
	.byte	-4
	.byte	-4
	.byte	-6
	.byte	-6
	.byte	-6
	.byte	-6
	.byte	-6
	.byte	-6
	.byte	-6
	.byte	-6
	.byte	-11
	.byte	-2
	.byte	2
	.byte	4
	.byte	4
	.byte	6
	.byte	6
	.byte	6
	.byte	-6
	.byte	-6
	.byte	-6
	.byte	-6
	.byte	-6
	.byte	-8
	.byte	-14
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
	.byte	-18
	.byte	-18
	.byte	-14
	.byte	-14
	.byte	-10
	.byte	-5
	.byte	-5
	.byte	-14
	.byte	-14
	.byte	-12
	.byte	-12
	.byte	-12
	.byte	-13
	.byte	-15
	.byte	-2
	.byte	-8
	.byte	-8
	.byte	-8
	.byte	-8
	.byte	-7
	.byte	-7
	.byte	-10
	.byte	-10
	.byte	-10
	.byte	-12
	.byte	-12
	.byte	-13
	.byte	-13
	.byte	-14
	.byte	-14
	.byte	-14
	.byte	-14
	.byte	-14
	.byte	-13
	.byte	-18
	.byte	-10
	.byte	-6
	.byte	-4
	.byte	-4
	.byte	-2
	.byte	-1
	.byte	-1
	.byte	-14
	.byte	-14
	.byte	-14
	.byte	-14
	.byte	-14
	.byte	-15
	.byte	-21
	.byte	-12
	.byte	-11
	.byte	-7
	.byte	-7
	.byte	-3
	.byte	1
	.byte	1
	.byte	-8
	.byte	-7
	.byte	-5
	.byte	-5
	.byte	-5
	.byte	-7
	.byte	-9
	.byte	4
	.byte	-1
	.byte	-1
	.byte	-1
	.byte	-1
	.byte	-1
	.byte	-1
	.byte	-4
	.byte	-3
	.byte	-3
	.byte	-5
	.byte	-5
	.byte	-7
	.byte	-7
	.byte	-8
	.byte	-7
	.byte	-7
	.byte	-7
	.byte	-7
	.byte	-7
	.byte	-12
	.byte	-4
	.byte	1
	.byte	3
	.byte	3
	.byte	5
	.byte	5
	.byte	5
	.byte	-8
	.byte	-7
	.byte	-7
	.byte	-7
	.byte	-7
	.byte	-9
	.byte	-15
	.byte	2
	.byte	-7
	.byte	-11
	.byte	-14
	.byte	-8
	.byte	-12
	.byte	-10
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
	.section	.rodata.ymtc_3d_read_retrial.str1.1,"aMS",%progbits,1
.LC120:
	.ascii	"YMTC RR %d row=%x,count %d,status=%d\012\000"
	.section	.rodata.ymtc_flash_tlc_page_prog.str1.1,"aMS",%progbits,1
.LC134:
	.ascii	"ymtc_flash_tlc_page_prog page_addr = %x status = %x"
	.ascii	"\012\000"
	.section	.rodata.zftl_discard.str1.1,"aMS",%progbits,1
.LC253:
	.ascii	"ftl_discard:(%x, %x, %x, %x)\012\000"
	.section	.rodata.zftl_do_gc.str1.1,"aMS",%progbits,1
.LC236:
	.ascii	"gc %d: %d %d %d %d %d %d %d\012\000"
.LC237:
	.ascii	"GC_STATE_SCAN_ALL_PAGE = %x, vpn0 = %d, vpn1 = %d\012"
	.ascii	"\000"
.LC238:
	.ascii	"gc free %x, %d\012\000"
	.section	.rodata.zftl_gc_get_free_sblk.str1.1,"aMS",%progbits,1
.LC59:
	.ascii	"swl_tlc_free_mini_ec_blk alloc sblk %x\012\000"
.LC60:
	.ascii	"zftl_get_free_sblk %x %d, %p %d %d\012\000"
.LC61:
	.ascii	"zftl_gc_get_free_sblk %x %x %x, %d %d %d\012\000"
	.section	.rodata.zftl_get_free_sblk.str1.1,"aMS",%progbits,1
.LC62:
	.ascii	"swl_slc_free_mini_ec_blk alloc sblk %x\012\000"
	.section	.rodata.zftl_init.str1.1,"aMS",%progbits,1
.LC239:
	.ascii	"FTL version: 6.0.23 20201130\000"
.LC240:
	.ascii	"_c_user_data_density := %d\012\000"
.LC241:
	.ascii	"_c_totle_phy_density := %d\012\000"
.LC242:
	.ascii	"_c_totle_log_page := %d\012\000"
.LC243:
	.ascii	"_c_totle_data_density := %d\012\000"
.LC244:
	.ascii	"_c_ftl_pm_page_num := %d\012\000"
.LC245:
	.ascii	"_c_ftl_byte_pre_page := %d\012\000"
.LC246:
	.ascii	"_c_max_pm_sblk := %d\012\000"
.LC247:
	.ascii	"_min_slc_super_block := %d\012\000"
.LC248:
	.ascii	"_max_xlc_super_block := %d\012\000"
.LC249:
	.ascii	"gp_ftl_ext_info %p %p %p\012\000"
.LC250:
	.ascii	"flash info size: %d %d %d\012\000"
	.section	.rodata.zftl_read.str1.1,"aMS",%progbits,1
.LC225:
	.ascii	"ftl_read %x %x %x\012\000"
.LC226:
	.ascii	"ftl_read refresh =%x, lpa = %x, ppa= %x\012\000"
.LC227:
	.ascii	"id=%d, status = %x, lpa = %x, ppa = %x spare = %x %"
	.ascii	"x %x %x\012\000"
	.section	.rodata.zftl_sblk_list_init.str1.1,"aMS",%progbits,1
.LC94:
	.ascii	"free blk vpn error: %x %x\012\000"
	.section	.rodata.zftl_write.str1.1,"aMS",%progbits,1
.LC252:
	.ascii	"ftlwrite %x %x %x %x\012\000"
	.hidden	free
