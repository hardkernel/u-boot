/*
 * Copyright (c) 2016-2017, Fuzhou Rockchip Electronics Co., Ltd
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * date: 2019-09-18
 */
	.arch armv8-a
	.file	"rk_zftl_arm_v8.S"
	.section	.text.flash_mem_cmp8,"ax",@progbits
	.align	2
	.type	flash_mem_cmp8, %function
flash_mem_cmp8:
	mov	x3, 0
.L2:
	mov	w4, w3
	cmp	w3, w2
	bcc	.L4
	mov	w0, 0
	ret
.L4:
	ldrb	w5, [x0, x3]
	add	x3, x3, 1
	add	x6, x1, x3
	ldrb	w6, [x6, -1]
	cmp	w6, w5
	beq	.L2
	add	w0, w4, 1
	ret
	.size	flash_mem_cmp8, .-flash_mem_cmp8
	.section	.text.slc_phy_page_address_calc,"ax",@progbits
	.align	2
	.type	slc_phy_page_address_calc, %function
slc_phy_page_address_calc:
	adrp	x1, .LANCHOR0
	adrp	x2, .LANCHOR1
	ldrb	w1, [x1, #:lo12:.LANCHOR0]
	cbz	w1, .L7
	ldrb	w1, [x2, #:lo12:.LANCHOR1]
	cbz	w1, .L8
.L7:
	adrp	x1, .LANCHOR2
	ldrb	w2, [x2, #:lo12:.LANCHOR1]
	ldrh	w3, [x1, #:lo12:.LANCHOR2]
	udiv	w1, w0, w3
	mul	w1, w1, w3
	sub	w0, w0, w1
	cbz	w2, .L9
	add	w0, w1, w0, lsl 1
	ret
.L9:
	adrp	x2, .LANCHOR3
	add	x2, x2, :lo12:.LANCHOR3
	ldrh	w0, [x2, w0, uxtw 1]
	add	w0, w0, w1
.L8:
	ret
	.size	slc_phy_page_address_calc, .-slc_phy_page_address_calc
	.section	.text._list_remove_node,"ax",@progbits
	.align	2
	.type	_list_remove_node, %function
_list_remove_node:
	stp	x29, x30, [sp, -64]!
	and	w1, w1, 65535
	mov	w3, 6
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR4
	stp	x19, x20, [sp, 16]
	umull	x20, w1, w3
	stp	x23, x24, [sp, 48]
	mov	w1, 65535
	ldr	x24, [x21, #:lo12:.LANCHOR4]
	add	x19, x24, x20
	ldrh	w4, [x24, x20]
	ldrh	w3, [x19, 2]
	cmp	w4, w1
	ldr	x1, [x0]
	bne	.L17
	cmp	w3, w4
	bne	.L17
	cmp	x19, x1
	bne	.L16
.L17:
	mov	x22, x0
	mov	x23, x2
	mov	w0, 65535
	cmp	w3, w0
	bne	.L19
	cmp	x19, x1
	beq	.L19
	adrp	x1, .LANCHOR5
	adrp	x0, .LC0
	mov	w2, 188
	add	x1, x1, :lo12:.LANCHOR5
	add	x0, x0, :lo12:.LC0
	bl	printf
.L19:
	ldr	x0, [x22]
	ldrh	w3, [x24, x20]
	cmp	x19, x0
	mov	w0, 65535
	bne	.L20
	cmp	w3, w0
	bne	.L21
	str	xzr, [x22]
.L22:
	mov	w0, -1
	strh	w0, [x24, x20]
	strh	w0, [x19, 2]
	ldrh	w0, [x23]
	sub	w0, w0, #1
	strh	w0, [x23]
.L16:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L21:
	ldr	x0, [x21, #:lo12:.LANCHOR4]
	mov	w1, 6
	umaddl	x3, w3, w1, x0
	mov	w0, -1
	str	x3, [x22]
	strh	w0, [x3, 2]
	b	.L22
.L20:
	cmp	w3, w0
	ldrh	w0, [x19, 2]
	bne	.L23
	cmp	w0, w3
	beq	.L22
	mov	w1, 6
	mov	w2, -1
	umull	x0, w0, w1
	ldr	x1, [x21, #:lo12:.LANCHOR4]
	strh	w2, [x1, x0]
	b	.L22
.L23:
	ldr	x1, [x21, #:lo12:.LANCHOR4]
	mov	w2, 6
	umaddl	x4, w3, w2, x1
	strh	w0, [x4, 2]
	ldrh	w0, [x19, 2]
	umull	x0, w0, w2
	strh	w3, [x1, x0]
	b	.L22
	.size	_list_remove_node, .-_list_remove_node
	.section	.text._list_pop_index_node,"ax",@progbits
	.align	2
	.type	_list_pop_index_node, %function
_list_pop_index_node:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	ldr	x20, [x0]
	cbz	x20, .L31
	adrp	x3, .LANCHOR4
	and	w1, w1, 65535
	mov	w4, 65535
	mov	w5, 6
	ldr	x19, [x3, #:lo12:.LANCHOR4]
.L27:
	cbnz	w1, .L28
.L30:
	sub	x19, x20, x19
	mov	x1, -6148914691236517206
	asr	x19, x19, 1
	movk	x1, 0xaaab, lsl 0
	mul	x19, x19, x1
	and	w19, w19, 65535
	mov	w1, w19
	bl	_list_remove_node
	mov	w0, -1
	strh	w0, [x20]
	strh	w0, [x20, 2]
	mov	w0, w19
.L25:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L28:
	ldrh	w3, [x20]
	cmp	w3, w4
	beq	.L30
	sub	w1, w1, #1
	umaddl	x20, w3, w5, x19
	and	w1, w1, 65535
	b	.L27
.L31:
	mov	w0, 65535
	b	.L25
	.size	_list_pop_index_node, .-_list_pop_index_node
	.section	.text._insert_free_list,"ax",@progbits
	.align	2
	.type	_insert_free_list, %function
_insert_free_list:
	adrp	x3, .LANCHOR6
	and	w1, w1, 65535
	ldrh	w3, [x3, #:lo12:.LANCHOR6]
	cmp	w3, w1
	bls	.L33
	ldrh	w3, [x2]
	mov	w8, 6
	ldr	x7, [x0]
	add	w3, w3, 1
	strh	w3, [x2]
	adrp	x2, .LANCHOR4
	umull	x12, w1, w8
	ldr	x5, [x2, #:lo12:.LANCHOR4]
	mov	w2, -1
	add	x6, x5, x12
	strh	w2, [x6, 2]
	strh	w2, [x5, x12]
	cbnz	x7, .L35
.L40:
	str	x6, [x0]
	ret
.L35:
	adrp	x2, .LANCHOR7
	adrp	x3, .LANCHOR8
	mov	w10, w8
	mov	w15, 65535
	ldr	x11, [x2, #:lo12:.LANCHOR7]
	ubfiz	x2, x1, 2, 16
	ldrh	w14, [x3, #:lo12:.LANCHOR8]
	mov	x3, -6148914691236517206
	movk	x3, 0xaaab, lsl 0
	ldr	w4, [x11, x2]
	ldrh	w2, [x11, x2]
	ubfx	x4, x4, 11, 8
	and	w2, w2, 2047
	madd	w4, w14, w4, w2
	sub	x2, x7, x5
	asr	x2, x2, 1
	and	w4, w4, 65535
	mul	x2, x2, x3
	mov	x3, x7
	and	w2, w2, 65535
.L38:
	ubfiz	x13, x2, 2, 16
	ldr	w8, [x11, x13]
	ldrh	w13, [x11, x13]
	ubfx	x8, x8, 11, 8
	and	w13, w13, 2047
	madd	w8, w14, w8, w13
	cmp	w4, w8, uxth
	bls	.L36
	ldrh	w8, [x3]
	cmp	w8, w15
	bne	.L37
	strh	w2, [x6, 2]
	strh	w1, [x3]
	ret
.L37:
	umaddl	x3, w8, w10, x5
	mov	w2, w8
	b	.L38
.L36:
	ldrh	w4, [x3, 2]
	cmp	x7, x3
	strh	w4, [x6, 2]
	strh	w2, [x5, x12]
	bne	.L39
	strh	w1, [x7, 2]
	b	.L40
.L39:
	ldrh	w0, [x3, 2]
	mov	w2, 6
	umull	x0, w0, w2
	strh	w1, [x5, x0]
	strh	w1, [x3, 2]
.L33:
	ret
	.size	_insert_free_list, .-_insert_free_list
	.section	.text._insert_data_list,"ax",@progbits
	.align	2
	.type	_insert_data_list, %function
_insert_data_list:
	adrp	x3, .LANCHOR6
	and	w1, w1, 65535
	ldrh	w4, [x3, #:lo12:.LANCHOR6]
	cmp	w4, w1
	bls	.L63
	mov	x5, x3
	ldrh	w3, [x2]
	mov	w13, 6
	ldr	x12, [x0]
	add	w3, w3, 1
	strh	w3, [x2]
	adrp	x2, .LANCHOR4
	umull	x13, w1, w13
	ldr	x10, [x2, #:lo12:.LANCHOR4]
	mov	w2, -1
	add	x11, x10, x13
	strh	w2, [x11, 2]
	strh	w2, [x10, x13]
	cbnz	x12, .L44
	str	x11, [x0]
	ret
.L44:
	stp	x29, x30, [sp, -32]!
	adrp	x2, .LANCHOR9
	uxtw	x3, w1
	adrp	x6, .LANCHOR8
	add	x29, sp, 0
	ldr	x15, [x2, #:lo12:.LANCHOR9]
	adrp	x2, .LANCHOR7
	ldrh	w4, [x11, 4]
	ldr	x14, [x2, #:lo12:.LANCHOR7]
	stp	x19, x20, [sp, 16]
	ldrh	w8, [x15, x3, lsl 1]
	lsl	x3, x3, 2
	ldrh	w16, [x6, #:lo12:.LANCHOR8]
	ldr	w2, [x14, x3]
	mul	w8, w8, w4
	ldrh	w3, [x14, x3]
	ubfx	x2, x2, 11, 8
	and	w3, w3, 2047
	cbz	w8, .L45
	madd	w2, w16, w2, w3
	add	w8, w8, w2, uxth
.L45:
	sub	x2, x12, x10
	mov	x3, -6148914691236517206
	asr	x2, x2, 1
	movk	x3, 0xaaab, lsl 0
	cmp	w4, 0
	ldrh	w19, [x5, #:lo12:.LANCHOR6]
	csinv	w8, w8, wzr, ne
	mov	x7, x12
	mul	x2, x2, x3
	mov	w4, 0
	mov	w20, 65535
	mov	w30, 6
	and	w2, w2, 65535
.L51:
	add	w4, w4, 1
	and	w4, w4, 65535
	cmp	w4, w19
	bhi	.L41
	cmp	w1, w2
	beq	.L41
	uxtw	x6, w2
	ldrh	w17, [x7, 4]
	ldrh	w3, [x15, x6, lsl 1]
	lsl	x6, x6, 2
	ldr	w5, [x14, x6]
	mul	w3, w3, w17
	ldrh	w6, [x14, x6]
	ubfx	x5, x5, 11, 8
	and	w6, w6, 2047
	cbz	w3, .L48
	madd	w5, w16, w5, w6
	add	w3, w3, w5, uxth
.L48:
	cbz	w17, .L49
	cmp	w8, w3
	bls	.L49
	ldrh	w3, [x7]
	cmp	w3, w20
	bne	.L50
	strh	w2, [x11, 2]
	strh	w1, [x7]
.L41:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L50:
	umaddl	x7, w3, w30, x10
	mov	w2, w3
	b	.L51
.L49:
	ldrh	w3, [x7, 2]
	cmp	x12, x7
	strh	w3, [x11, 2]
	strh	w2, [x10, x13]
	bne	.L52
	strh	w1, [x12, 2]
	str	x11, [x0]
	b	.L41
.L52:
	ldrh	w0, [x7, 2]
	mov	w2, 6
	umull	x0, w0, w2
	strh	w1, [x10, x0]
	strh	w1, [x7, 2]
	b	.L41
.L63:
	ret
	.size	_insert_data_list, .-_insert_data_list
	.section	.text._list_get_gc_head_node.isra.2,"ax",@progbits
	.align	2
	.type	_list_get_gc_head_node.isra.2, %function
_list_get_gc_head_node.isra.2:
	and	w1, w1, 65535
	cbz	x0, .L70
	adrp	x2, .LANCHOR4
	mov	w3, 65535
	mov	w4, 6
	ldr	x2, [x2, #:lo12:.LANCHOR4]
.L67:
	cbz	w1, .L68
	ldrh	w0, [x0]
	cmp	w0, w3
	bne	.L69
	ret
.L69:
	sub	w1, w1, #1
	umaddl	x0, w0, w4, x2
	and	w1, w1, 65535
	b	.L67
.L70:
	mov	w0, 65535
	ret
.L68:
	sub	x0, x0, x2
	mov	x1, -6148914691236517206
	asr	x0, x0, 1
	movk	x1, 0xaaab, lsl 0
	mul	x0, x0, x1
	and	w0, w0, 65535
	ret
	.size	_list_get_gc_head_node.isra.2, .-_list_get_gc_head_node.isra.2
	.section	.text._list_update_data_list,"ax",@progbits
	.align	2
	.type	_list_update_data_list, %function
_list_update_data_list:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w19, w1, 65535
	adrp	x1, .LANCHOR10
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	ldr	x1, [x1, #:lo12:.LANCHOR10]
	ldrh	w3, [x1, 16]
	str	x25, [sp, 64]
	cmp	w3, w19
	beq	.L72
	ldrh	w3, [x1, 48]
	cmp	w3, w19
	beq	.L72
	ldrh	w1, [x1, 80]
	cmp	w1, w19
	beq	.L72
	adrp	x1, .LANCHOR4
	mov	w22, 6
	ldr	x3, [x0]
	mov	x25, x1
	umull	x22, w19, w22
	ldr	x24, [x1, #:lo12:.LANCHOR4]
	add	x23, x24, x22
	cmp	x23, x3
	beq	.L72
	mov	x20, x0
	ldrh	w0, [x23, 2]
	mov	w1, 65535
	mov	x21, x2
	cmp	w0, w1
	bne	.L76
	ldrh	w1, [x24, x22]
	cmp	w1, w0
	bne	.L76
	adrp	x1, .LANCHOR11
	adrp	x0, .LC0
	mov	w2, 255
	add	x1, x1, :lo12:.LANCHOR11
	add	x0, x0, :lo12:.LC0
	bl	printf
.L76:
	ldrh	w1, [x23, 2]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L77
	ldrh	w0, [x24, x22]
	cmp	w0, w1
	beq	.L72
.L77:
	adrp	x0, .LANCHOR9
	ubfiz	x2, x19, 1, 16
	mov	x5, -6148914691236517206
	mov	w4, -1
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	movk	x5, 0xaaab, lsl 0
	ldrh	w3, [x0, x2]
	ldrh	w2, [x23, 4]
	cmp	w2, 0
	mul	w3, w3, w2
	mov	w2, 6
	umull	x1, w1, w2
	csel	w3, w3, w4, ne
	asr	x2, x1, 1
	mul	x2, x2, x5
	ldrh	w0, [x0, x2, lsl 1]
	ldr	x2, [x25, #:lo12:.LANCHOR4]
	add	x1, x2, x1
	ldrh	w1, [x1, 4]
	cmp	w1, 0
	mul	w0, w0, w1
	csel	w0, w0, w4, ne
	cmp	w3, w0
	bcs	.L72
	mov	x2, x21
	mov	w1, w19
	mov	x0, x20
	bl	_list_remove_node
	mov	x2, x21
	mov	w1, w19
	mov	x0, x20
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	b	_insert_data_list
.L72:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
	.size	_list_update_data_list, .-_list_update_data_list
	.section	.text.zftl_get_gc_node.part.9,"ax",@progbits
	.align	2
	.type	zftl_get_gc_node.part.9, %function
zftl_get_gc_node.part.9:
	mov	w1, w0
	adrp	x0, .LANCHOR12
	ldr	x0, [x0, #:lo12:.LANCHOR12]
	b	_list_get_gc_head_node.isra.2
	.size	zftl_get_gc_node.part.9, .-zftl_get_gc_node.part.9
	.section	.text.nandc_de_cs.constprop.30,"ax",@progbits
	.align	2
	.type	nandc_de_cs.constprop.30, %function
nandc_de_cs.constprop.30:
	adrp	x0, .LANCHOR13
	ldr	x1, [x0, #:lo12:.LANCHOR13]
	ldr	w0, [x1]
	and	w0, w0, -256
	and	w0, w0, -131073
	str	w0, [x1]
	ret
	.size	nandc_de_cs.constprop.30, .-nandc_de_cs.constprop.30
	.section	.text.nand_flash_print_info,"ax",@progbits
	.align	2
	.global	nand_flash_print_info
	.type	nand_flash_print_info, %function
nand_flash_print_info:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	str	x19, [sp, 16]
	adrp	x19, .LANCHOR14
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L86
	adrp	x1, .LANCHOR15
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR15
	add	x0, x0, :lo12:.LC1
	bl	printf
.L86:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L87
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrb	w6, [x0, 6]
	ldrb	w5, [x0, 5]
	ldrb	w4, [x0, 4]
	ldrb	w3, [x0, 3]
	ldrb	w2, [x0, 2]
	ldrb	w1, [x0, 1]
	adrp	x0, .LC2
	add	x0, x0, :lo12:.LC2
	bl	printf
.L87:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L88
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrb	w1, [x0, 8]
	adrp	x0, .LC3
	add	x0, x0, :lo12:.LC3
	bl	printf
.L88:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L89
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrb	w1, [x0, 9]
	adrp	x0, .LC4
	add	x0, x0, :lo12:.LC4
	bl	printf
.L89:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L90
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrh	w1, [x0, 10]
	adrp	x0, .LC5
	add	x0, x0, :lo12:.LC5
	bl	printf
.L90:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L91
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrb	w1, [x0, 12]
	adrp	x0, .LC6
	add	x0, x0, :lo12:.LC6
	bl	printf
.L91:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L92
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrb	w1, [x0, 13]
	adrp	x0, .LC7
	add	x0, x0, :lo12:.LC7
	bl	printf
.L92:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L93
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrh	w1, [x0, 14]
	adrp	x0, .LC8
	add	x0, x0, :lo12:.LC8
	bl	printf
.L93:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L94
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrb	w1, [x0, 23]
	adrp	x0, .LC9
	add	x0, x0, :lo12:.LC9
	bl	printf
.L94:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L95
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrb	w1, [x0, 18]
	adrp	x0, .LC10
	add	x0, x0, :lo12:.LC10
	bl	printf
.L95:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L96
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrb	w1, [x0, 19]
	adrp	x0, .LC11
	add	x0, x0, :lo12:.LC11
	bl	printf
.L96:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L97
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrb	w1, [x0, 20]
	adrp	x0, .LC12
	add	x0, x0, :lo12:.LC12
	bl	printf
.L97:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L98
	adrp	x0, .LANCHOR17
	ldrb	w1, [x0, #:lo12:.LANCHOR17]
	adrp	x0, .LC13
	add	x0, x0, :lo12:.LC13
	bl	printf
.L98:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L99
	adrp	x0, .LANCHOR0
	ldrb	w1, [x0, #:lo12:.LANCHOR0]
	adrp	x0, .LC14
	add	x0, x0, :lo12:.LC14
	bl	printf
.L99:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L100
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrb	w1, [x0, 22]
	adrp	x0, .LC15
	add	x0, x0, :lo12:.LC15
	bl	printf
.L100:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L101
	adrp	x0, .LANCHOR18
	ldrb	w1, [x0, #:lo12:.LANCHOR18]
	adrp	x0, .LC16
	add	x0, x0, :lo12:.LC16
	bl	printf
.L101:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L102
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrb	w1, [x0, 16]
	adrp	x0, .LC17
	add	x0, x0, :lo12:.LC17
	and	w1, w1, 1
	bl	printf
.L102:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L103
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrh	w1, [x0, 16]
	adrp	x0, .LC18
	add	x0, x0, :lo12:.LC18
	ubfx	x1, x1, 1, 1
	bl	printf
.L103:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L104
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrh	w1, [x0, 16]
	adrp	x0, .LC19
	add	x0, x0, :lo12:.LC19
	ubfx	x1, x1, 2, 1
	bl	printf
.L104:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L105
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrh	w1, [x0, 16]
	adrp	x0, .LC20
	add	x0, x0, :lo12:.LC20
	ubfx	x1, x1, 3, 1
	bl	printf
.L105:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L106
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrh	w1, [x0, 16]
	adrp	x0, .LC21
	add	x0, x0, :lo12:.LC21
	ubfx	x1, x1, 4, 1
	bl	printf
.L106:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L107
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrh	w1, [x0, 16]
	adrp	x0, .LC22
	add	x0, x0, :lo12:.LC22
	ubfx	x1, x1, 5, 1
	bl	printf
.L107:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L108
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrh	w1, [x0, 16]
	adrp	x0, .LC23
	add	x0, x0, :lo12:.LC23
	ubfx	x1, x1, 6, 1
	bl	printf
.L108:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L109
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrh	w1, [x0, 16]
	adrp	x0, .LC24
	add	x0, x0, :lo12:.LC24
	ubfx	x1, x1, 7, 1
	bl	printf
.L109:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L110
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrb	w1, [x0, 17]
	adrp	x0, .LC25
	add	x0, x0, :lo12:.LC25
	and	w1, w1, 1
	bl	printf
.L110:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L111
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrh	w1, [x0, 16]
	adrp	x0, .LC26
	add	x0, x0, :lo12:.LC26
	ubfx	x1, x1, 9, 1
	bl	printf
.L111:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L112
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrh	w1, [x0, 16]
	adrp	x0, .LC27
	add	x0, x0, :lo12:.LC27
	ubfx	x1, x1, 10, 1
	bl	printf
.L112:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L113
	adrp	x0, .LANCHOR19
	ldrb	w2, [x0, #:lo12:.LANCHOR19]
	adrp	x0, .LANCHOR0
	ldrb	w1, [x0, #:lo12:.LANCHOR0]
	adrp	x0, .LC28
	add	x0, x0, :lo12:.LC28
	bl	printf
.L113:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L114
	adrp	x0, .LANCHOR20
	add	x0, x0, :lo12:.LANCHOR20
	ldrb	w2, [x0, 11]
	ldrb	w1, [x0, 10]
	adrp	x0, .LC29
	add	x0, x0, :lo12:.LC29
	bl	printf
.L114:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L115
	adrp	x0, .LANCHOR20
	add	x0, x0, :lo12:.LANCHOR20
	ldrb	w2, [x0, 9]
	ldrb	w1, [x0, 8]
	adrp	x0, .LC30
	add	x0, x0, :lo12:.LC30
	bl	printf
.L115:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L85
	adrp	x0, .LANCHOR21
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ldrb	w1, [x0, #:lo12:.LANCHOR21]
	adrp	x0, .LC31
	add	x0, x0, :lo12:.LC31
	b	printf
.L85:
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	nand_flash_print_info, .-nand_flash_print_info
	.section	.text.timer_delay_ns,"ax",@progbits
	.align	2
	.global	timer_delay_ns
	.type	timer_delay_ns, %function
timer_delay_ns:
	sub	sp, sp, #16
	lsr	w0, w0, 4
	str	w0, [sp, 12]
.L209:
	ldr	w0, [sp, 12]
	sub	w1, w0, #1
	str	w1, [sp, 12]
	cbnz	w0, .L209
	add	sp, sp, 16
	ret
	.size	timer_delay_ns, .-timer_delay_ns
	.section	.text.flash_read_status,"ax",@progbits
	.align	2
	.global	flash_read_status
	.type	flash_read_status, %function
flash_read_status:
	stp	x29, x30, [sp, -16]!
	mov	x2, x0
	mov	w0, 112
	add	x29, sp, 0
	str	w0, [x2, 8]
	mov	w0, 120
	bl	timer_delay_ns
	ldr	w0, [x2]
	ldp	x29, x30, [sp], 16
	and	w0, w0, 255
	ret
	.size	flash_read_status, .-flash_read_status
	.section	.text.toshiba_set_rr_para,"ax",@progbits
	.align	2
	.global	toshiba_set_rr_para
	.type	toshiba_set_rr_para, %function
toshiba_set_rr_para:
	and	w11, w1, 255
	mov	x4, x0
	add	w2, w11, 1
	mov	w0, 5
	adrp	x6, .LANCHOR26
	add	x6, x6, :lo12:.LANCHOR26
	adrp	x3, .LANCHOR22
	add	x3, x3, :lo12:.LANCHOR22
	umull	x2, w2, w0
	adrp	x0, .LANCHOR23
	add	x7, x0, :lo12:.LANCHOR23
	mov	x5, x0
	ldrb	w0, [x6]
	add	x3, x3, x2
	add	x7, x7, x2
	adrp	x8, .LANCHOR24
	mov	x2, 0
	adrp	x10, .LANCHOR25
	add	x8, x8, :lo12:.LANCHOR24
	add	x10, x10, :lo12:.LANCHOR25
	cmp	w0, w2
	bhi	.L222
	ret
.L216:
	cmp	w0, 35
	bne	.L218
	ldrsb	w0, [x3, x2]
	b	.L223
.L218:
	ldrsb	w0, [x10, w11, sxtw]
	b	.L223
.L222:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
.L219:
	mov	w0, 85
	str	w0, [x4, 8]
	add	x0, x5, :lo12:.LANCHOR23
	ldrsb	w0, [x2, x0]
	str	w0, [x4, 4]
	mov	w0, 200
	bl	timer_delay_ns
	ldrb	w0, [x8]
	cmp	w0, 34
	bne	.L216
	ldrsb	w0, [x7, x2]
.L223:
	str	w0, [x4]
	add	x2, x2, 1
	ldrb	w0, [x6]
	cmp	w0, w2
	bhi	.L219
	ldp	x29, x30, [sp], 16
	ret
	.size	toshiba_set_rr_para, .-toshiba_set_rr_para
	.section	.text.hynix_set_rr_para,"ax",@progbits
	.align	2
	.type	hynix_set_rr_para, %function
hynix_set_rr_para:
	adrp	x2, .LANCHOR27
	and	w1, w1, 255
	and	w0, w0, 255
	ldr	x3, [x2, #:lo12:.LANCHOR27]
	adrp	x2, .LANCHOR13
	add	x6, x3, 128
	add	x4, x3, 112
	ldr	x2, [x2, #:lo12:.LANCHOR13]
	ldrb	w5, [x3, 113]
	ldrb	w3, [x3, 112]
	cmp	w3, 8
	mov	x3, 32
	umaddl	x1, w1, w5, x3
	beq	.L225
	mov	w3, 160
	umaddl	x1, w3, w0, x1
.L225:
	ubfiz	x0, x0, 8, 8
	mov	x3, 0
	add	x2, x2, x0
	mov	w0, 54
	add	x4, x4, x1
	cmp	w5, w3, uxtb
	str	w0, [x2, 2056]
	bhi	.L232
	mov	w0, 22
	str	w0, [x2, 2056]
	ret
.L232:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
.L228:
	ldrb	w0, [x6, x3]
	str	w0, [x2, 2052]
	mov	w0, 120
	bl	timer_delay_ns
	ldrsb	w0, [x4, x3]
	str	w0, [x2, 2048]
	add	x3, x3, 1
	cmp	w5, w3, uxtb
	bhi	.L228
	mov	w0, 22
	str	w0, [x2, 2056]
	ldp	x29, x30, [sp], 16
	ret
	.size	hynix_set_rr_para, .-hynix_set_rr_para
	.section	.text.hynix_reconfig_rr_para,"ax",@progbits
	.align	2
	.global	hynix_reconfig_rr_para
	.type	hynix_reconfig_rr_para, %function
hynix_reconfig_rr_para:
	adrp	x1, .LANCHOR24
	ldrb	w1, [x1, #:lo12:.LANCHOR24]
	sub	w1, w1, #1
	and	w1, w1, 255
	cmp	w1, 7
	bhi	.L239
	adrp	x8, .LANCHOR27
	and	w0, w0, 255
	sxtw	x7, w0
	ldr	x1, [x8, #:lo12:.LANCHOR27]
	add	x1, x1, x7
	ldrb	w1, [x1, 120]
	cbz	w1, .L239
	stp	x29, x30, [sp, -16]!
	mov	w1, 0
	add	x29, sp, 0
	bl	hynix_set_rr_para
	ldr	x0, [x8, #:lo12:.LANCHOR27]
	add	x0, x0, x7
	strb	wzr, [x0, 120]
	ldp	x29, x30, [sp], 16
	ret
.L239:
	ret
	.size	hynix_reconfig_rr_para, .-hynix_reconfig_rr_para
	.section	.text.nandc_set_ddr_para,"ax",@progbits
	.align	2
	.global	nandc_set_ddr_para
	.type	nandc_set_ddr_para, %function
nandc_set_ddr_para:
	adrp	x1, .LANCHOR28
	and	w0, w0, 255
	adrp	x2, .LANCHOR13
	ldrb	w1, [x1, #:lo12:.LANCHOR28]
	ldr	x2, [x2, #:lo12:.LANCHOR13]
	cmp	w1, 9
	lsl	w1, w0, 16
	lsl	w0, w0, 8
	orr	w1, w1, w0
	orr	w1, w1, 3
	bne	.L243
	str	w1, [x2, 80]
	ret
.L243:
	str	w1, [x2, 304]
	ret
	.size	nandc_set_ddr_para, .-nandc_set_ddr_para
	.section	.text.nandc_get_ddr_para,"ax",@progbits
	.align	2
	.global	nandc_get_ddr_para
	.type	nandc_get_ddr_para, %function
nandc_get_ddr_para:
	adrp	x0, .LANCHOR28
	ldrb	w0, [x0, #:lo12:.LANCHOR28]
	cmp	w0, 9
	adrp	x0, .LANCHOR13
	ldr	x0, [x0, #:lo12:.LANCHOR13]
	bne	.L246
	ldr	w0, [x0, 80]
.L248:
	ubfx	x0, x0, 8, 8
	ret
.L246:
	ldr	w0, [x0, 304]
	b	.L248
	.size	nandc_get_ddr_para, .-nandc_get_ddr_para
	.section	.text.nandc_set_if_mode,"ax",@progbits
	.align	2
	.global	nandc_set_if_mode
	.type	nandc_set_if_mode, %function
nandc_set_if_mode:
	adrp	x1, .LANCHOR13
	and	w0, w0, 255
	tst	w0, 6
	ldr	x2, [x1, #:lo12:.LANCHOR13]
	ldr	w1, [x2]
	beq	.L250
	tst	x0, 4
	orr	w1, w1, 24576
	adrp	x0, .LANCHOR28
	and	w1, w1, -32769
	orr	w1, w1, 196608
	ldrb	w0, [x0, #:lo12:.LANCHOR28]
	orr	w3, w1, 32768
	csel	w1, w3, w1, ne
	cmp	w0, 9
	mov	w0, 4099
	movk	w0, 0x10, lsl 16
	bne	.L252
	mov	w3, 8321
	str	w3, [x2, 8]
	str	w0, [x2, 80]
	mov	w0, 38
	str	w0, [x2, 84]
	mov	w0, 39
	str	w0, [x2, 84]
.L253:
	str	w1, [x2]
	ret
.L252:
	mov	w3, 8322
	str	w3, [x2, 344]
	str	w0, [x2, 304]
	mov	w0, 38
	str	w0, [x2, 308]
	mov	w0, 39
	str	w0, [x2, 308]
	b	.L253
.L250:
	and	w1, w1, -8193
	b	.L253
	.size	nandc_set_if_mode, .-nandc_set_if_mode
	.section	.text.nandc_cs,"ax",@progbits
	.align	2
	.global	nandc_cs
	.type	nandc_cs, %function
nandc_cs:
	adrp	x1, .LANCHOR13
	mov	w2, 1
	lsl	w0, w2, w0
	ldr	x3, [x1, #:lo12:.LANCHOR13]
	ldr	w1, [x3]
	bfi	w1, w0, 0, 8
	str	w1, [x3]
	ret
	.size	nandc_cs, .-nandc_cs
	.section	.text.flash_wait_device_ready_raw,"ax",@progbits
	.align	2
	.global	flash_wait_device_ready_raw
	.type	flash_wait_device_ready_raw, %function
flash_wait_device_ready_raw:
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	str	x21, [sp, 32]
	and	w21, w0, 255
	adrp	x0, .LANCHOR18
	stp	x19, x20, [sp, 16]
	mov	w19, w1
	mov	w20, w2
	ldrb	w0, [x0, #:lo12:.LANCHOR18]
	cmp	w0, w21
	bhi	.L258
	adrp	x1, .LANCHOR29
	adrp	x0, .LC0
	mov	w2, 691
	add	x1, x1, :lo12:.LANCHOR29
	add	x0, x0, :lo12:.LC0
	bl	printf
.L258:
	adrp	x0, .LANCHOR30
	add	x0, x0, :lo12:.LANCHOR30
	ldrb	w5, [x0, w21, sxtw]
	adrp	x0, .LANCHOR13
	ldr	x4, [x0, #:lo12:.LANCHOR13]
	mov	w0, w5
	bl	nandc_cs
	ubfiz	x2, x5, 8, 8
	lsr	w6, w19, 8
	lsr	w7, w19, 16
	and	w19, w19, 255
	add	x2, x4, x2
	mov	w4, 120
.L261:
	str	w4, [x2, 2056]
	mov	w0, 120
	str	w19, [x2, 2052]
	str	w6, [x2, 2052]
	str	w7, [x2, 2052]
	bl	timer_delay_ns
	ldr	w3, [x2, 2048]
	and	w3, w3, 255
	bics	wzr, w20, w3
	bne	.L261
	cmp	w3, 255
	beq	.L261
	bl	nandc_de_cs.constprop.30
	ldr	x21, [sp, 32]
	mov	w0, w3
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
	.size	flash_wait_device_ready_raw, .-flash_wait_device_ready_raw
	.section	.text.flash_wait_device_ready,"ax",@progbits
	.align	2
	.global	flash_wait_device_ready
	.type	flash_wait_device_ready, %function
flash_wait_device_ready:
	mov	w2, w1
	adrp	x1, .LANCHOR31
	mov	w5, 24
	mov	w4, 1
	ldrb	w6, [x1, #:lo12:.LANCHOR31]
	tst	x0, 50331648
	sub	w5, w5, w6
	lsl	w3, w4, w5
	sub	w3, w3, #1
	lsl	w4, w4, w6
	sub	w4, w4, #1
	asr	w5, w0, w5
	and	w4, w4, w5
	and	w1, w3, w0
	and	w4, w4, 255
	bne	.L265
	adrp	x0, .LANCHOR0
	adrp	x5, .LANCHOR1
	ldrb	w0, [x0, #:lo12:.LANCHOR0]
	cbz	w0, .L266
	ldrb	w0, [x5, #:lo12:.LANCHOR1]
	cbz	w0, .L265
.L266:
	adrp	x0, .LANCHOR2
	ldrh	w3, [x0, #:lo12:.LANCHOR2]
	udiv	w0, w1, w3
	mul	w0, w0, w3
	sub	w3, w1, w0
	ldrb	w1, [x5, #:lo12:.LANCHOR1]
	cbz	w1, .L267
	add	w1, w0, w3, lsl 1
.L265:
	mov	w0, w4
	b	flash_wait_device_ready_raw
.L267:
	adrp	x5, .LANCHOR3
	add	x5, x5, :lo12:.LANCHOR3
	ldrh	w3, [x5, w3, uxtw 1]
	add	w1, w3, w0
	b	.L265
	.size	flash_wait_device_ready, .-flash_wait_device_ready
	.section	.text.nandc_de_cs,"ax",@progbits
	.align	2
	.global	nandc_de_cs
	.type	nandc_de_cs, %function
nandc_de_cs:
	adrp	x0, .LANCHOR13
	ldr	x1, [x0, #:lo12:.LANCHOR13]
	ldr	w0, [x1]
	and	w0, w0, -256
	and	w0, w0, -131073
	str	w0, [x1]
	ret
	.size	nandc_de_cs, .-nandc_de_cs
	.section	.text.nandc_wait_flash_ready_no_delay,"ax",@progbits
	.align	2
	.global	nandc_wait_flash_ready_no_delay
	.type	nandc_wait_flash_ready_no_delay, %function
nandc_wait_flash_ready_no_delay:
	mov	w2, 34464
	stp	x29, x30, [sp, -32]!
	movk	w2, 0x1, lsl 16
	adrp	x3, .LANCHOR13
	add	x29, sp, 0
.L277:
	ldr	x0, [x3, #:lo12:.LANCHOR13]
	ldr	w0, [x0]
	str	w0, [x29, 24]
	ldr	w0, [x29, 24]
	tbnz	x0, 9, .L278
	mov	w0, 10
	bl	timer_delay_ns
	subs	w2, w2, #1
	bne	.L277
	mov	w0, -1
.L275:
	ldp	x29, x30, [sp], 32
	ret
.L278:
	mov	w0, 0
	b	.L275
	.size	nandc_wait_flash_ready_no_delay, .-nandc_wait_flash_ready_no_delay
	.section	.text.zftl_flash_enter_slc_mode,"ax",@progbits
	.align	2
	.global	zftl_flash_enter_slc_mode
	.type	zftl_flash_enter_slc_mode, %function
zftl_flash_enter_slc_mode:
	adrp	x1, .LANCHOR0
	ldrb	w1, [x1, #:lo12:.LANCHOR0]
	cbz	w1, .L281
	adrp	x2, .LANCHOR13
	and	x0, x0, 255
	cmp	w1, 1
	ldr	x4, [x2, #:lo12:.LANCHOR13]
	bne	.L284
.L304:
	adrp	x1, .LANCHOR32+29
	ldrb	w1, [x1, #:lo12:.LANCHOR32+29]
	cbz	w1, .L281
	add	x0, x0, 8
	add	x0, x4, x0, lsl 8
	str	w1, [x0, 8]
	ret
.L284:
	cmp	w1, 2
	bne	.L286
	adrp	x1, .LANCHOR33
	add	x1, x1, :lo12:.LANCHOR33
	ldrb	w2, [x1, x0]
	cbz	w2, .L281
	strb	wzr, [x1, x0]
	b	.L304
.L286:
	cmp	w1, 3
	bne	.L281
	adrp	x1, .LANCHOR33
	sxtw	x2, w0
	add	x1, x1, :lo12:.LANCHOR33
	ldrb	w3, [x1, x2]
	cbz	w3, .L281
	ubfiz	x0, x0, 8, 8
	stp	x29, x30, [sp, -16]!
	add	x4, x4, x0
	mov	w0, 239
	add	x29, sp, 0
	strb	wzr, [x1, x2]
	str	w0, [x4, 2056]
	mov	w0, 145
	str	w0, [x4, 2052]
	mov	w0, 50
	bl	timer_delay_ns
	str	wzr, [x4, 2048]
	mov	w0, 1
	str	w0, [x4, 2048]
	str	wzr, [x4, 2048]
	mov	w0, 150
	str	wzr, [x4, 2048]
	bl	timer_delay_ns
	bl	nandc_wait_flash_ready_no_delay
	mov	w0, 218
	str	w0, [x4, 2056]
	mov	w0, 150
	bl	timer_delay_ns
	ldp	x29, x30, [sp], 16
	b	nandc_wait_flash_ready_no_delay
.L281:
	ret
	.size	zftl_flash_enter_slc_mode, .-zftl_flash_enter_slc_mode
	.section	.text.zftl_flash_exit_slc_mode,"ax",@progbits
	.align	2
	.global	zftl_flash_exit_slc_mode
	.type	zftl_flash_exit_slc_mode, %function
zftl_flash_exit_slc_mode:
	adrp	x1, .LANCHOR0
	ldrb	w1, [x1, #:lo12:.LANCHOR0]
	cbz	w1, .L305
	adrp	x2, .LANCHOR13
	and	x0, x0, 255
	cmp	w1, 1
	ldr	x4, [x2, #:lo12:.LANCHOR13]
	bne	.L308
	adrp	x1, .LANCHOR32+30
	ldrb	w1, [x1, #:lo12:.LANCHOR32+30]
.L330:
	cbz	w1, .L305
	add	x0, x0, 8
	add	x0, x4, x0, lsl 8
	str	w1, [x0, 8]
	ret
.L308:
	cmp	w1, 2
	bne	.L310
	adrp	x2, .LANCHOR33
	add	x2, x2, :lo12:.LANCHOR33
	ldrb	w1, [x2, x0]
	cbnz	w1, .L305
	adrp	x1, .LANCHOR32
	add	x1, x1, :lo12:.LANCHOR32
	mov	w5, 4
	ldrb	w3, [x1, 12]
	ldrb	w1, [x1, 30]
	cmp	w3, 2
	csel	w3, w3, w5, eq
	strb	w3, [x2, x0]
	b	.L330
.L310:
	cmp	w1, 3
	bne	.L305
	adrp	x2, .LANCHOR33
	sxtw	x5, w0
	add	x2, x2, :lo12:.LANCHOR33
	ldrb	w1, [x2, x5]
	cbnz	w1, .L305
	adrp	x3, .LANCHOR32
	add	x3, x3, :lo12:.LANCHOR32
	stp	x29, x30, [sp, -16]!
	ubfiz	x0, x0, 8, 8
	add	x4, x4, x0
	mov	w6, 4
	add	x29, sp, 0
	ldrb	w1, [x3, 12]
	mov	w0, 239
	str	w0, [x4, 2056]
	mov	w0, 145
	cmp	w1, 2
	str	w0, [x4, 2052]
	csel	w1, w1, w6, eq
	mov	w0, 50
	strb	w1, [x2, x5]
	bl	timer_delay_ns
	ldrb	w0, [x3, 7]
	cmp	w0, 9
	mov	w0, 1
	bne	.L313
	str	w0, [x4, 2048]
.L314:
	str	w0, [x4, 2048]
	mov	w0, 150
	str	wzr, [x4, 2048]
	str	wzr, [x4, 2048]
	bl	timer_delay_ns
	bl	nandc_wait_flash_ready_no_delay
	mov	w0, 223
	str	w0, [x4, 2056]
	mov	w0, 150
	bl	timer_delay_ns
	ldp	x29, x30, [sp], 16
	b	nandc_wait_flash_ready_no_delay
.L313:
	ldrb	w1, [x2, x5]
	str	w1, [x4, 2048]
	b	.L314
.L305:
	ret
	.size	zftl_flash_exit_slc_mode, .-zftl_flash_exit_slc_mode
	.section	.text.flash_start_page_read,"ax",@progbits
	.align	2
	.global	flash_start_page_read
	.type	flash_start_page_read, %function
flash_start_page_read:
	stp	x29, x30, [sp, -64]!
	mov	w7, 24
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w20, w0, 255
	adrp	x0, .LANCHOR31
	stp	x21, x22, [sp, 32]
	mov	w19, 1
	mov	w21, w1
	ldrb	w0, [x0, #:lo12:.LANCHOR31]
	str	x23, [sp, 48]
	sub	w22, w7, w0
	lsl	w19, w19, w0
	sub	w19, w19, #1
	lsr	w0, w1, w22
	and	w19, w19, w0
	adrp	x0, .LANCHOR18
	and	w19, w19, 255
	mov	x23, x0
	ldrb	w1, [x0, #:lo12:.LANCHOR18]
	cmp	w1, w19
	bhi	.L332
	adrp	x1, .LANCHOR34
	adrp	x0, .LC0
	mov	w2, 866
	add	x1, x1, :lo12:.LANCHOR34
	add	x0, x0, :lo12:.LC0
	bl	printf
.L332:
	ldrb	w0, [x23, #:lo12:.LANCHOR18]
	cmp	w0, w19
	bls	.L331
	adrp	x0, .LANCHOR30
	add	x0, x0, :lo12:.LANCHOR30
	mov	w7, 1
	lsl	w7, w7, w22
	sub	w7, w7, #1
	ldrb	w10, [x0, w19, sxtw]
	adrp	x0, .LANCHOR13
	and	w7, w7, w21
	ubfx	x21, x21, 24, 2
	ldr	x8, [x0, #:lo12:.LANCHOR13]
	mov	w0, w10
	bl	nandc_cs
	cbnz	w21, .L334
	mov	w0, w7
	bl	slc_phy_page_address_calc
	mov	w7, w0
	adrp	x0, .LANCHOR0
	ldrb	w0, [x0, #:lo12:.LANCHOR0]
	cbz	w0, .L335
	mov	w0, w10
	bl	zftl_flash_enter_slc_mode
.L335:
	ubfiz	x0, x10, 8, 8
	ldr	x23, [sp, 48]
	add	x0, x8, x0
	and	w1, w7, 255
	ldp	x21, x22, [sp, 32]
	str	wzr, [x0, 2056]
	str	wzr, [x0, 2052]
	str	wzr, [x0, 2052]
	str	w1, [x0, 2052]
	lsr	w1, w7, 8
	str	w1, [x0, 2052]
	lsr	w7, w7, 16
	str	w7, [x0, 2052]
	str	w20, [x0, 2056]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 64
	b	nandc_de_cs.constprop.30
.L334:
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrb	w0, [x0, 12]
	cmp	w0, 3
	bne	.L336
	adrp	x0, .LANCHOR35
	ldrb	w0, [x0, #:lo12:.LANCHOR35]
	cbnz	w0, .L336
	sxtw	x0, w10
	add	x0, x0, 8
	add	x0, x8, x0, lsl 8
	str	w21, [x0, 8]
	b	.L335
.L336:
	mov	w0, w10
	bl	zftl_flash_exit_slc_mode
	b	.L335
.L331:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
	.size	flash_start_page_read, .-flash_start_page_read
	.section	.text.nandc_wait_flash_ready,"ax",@progbits
	.align	2
	.global	nandc_wait_flash_ready
	.type	nandc_wait_flash_ready, %function
nandc_wait_flash_ready:
	stp	x29, x30, [sp, -32]!
	mov	w0, 150
	add	x29, sp, 0
	bl	timer_delay_ns
	mov	w2, 34464
	adrp	x3, .LANCHOR13
	movk	w2, 0x1, lsl 16
.L343:
	ldr	x0, [x3, #:lo12:.LANCHOR13]
	ldr	w0, [x0]
	str	w0, [x29, 24]
	ldr	w0, [x29, 24]
	tbnz	x0, 9, .L344
	mov	w0, 10
	bl	timer_delay_ns
	subs	w2, w2, #1
	bne	.L343
	mov	w0, -1
.L341:
	ldp	x29, x30, [sp], 32
	ret
.L344:
	mov	w0, 0
	b	.L341
	.size	nandc_wait_flash_ready, .-nandc_wait_flash_ready
	.section	.text.sandisk_set_rr_para,"ax",@progbits
	.align	2
	.global	sandisk_set_rr_para
	.type	sandisk_set_rr_para, %function
sandisk_set_rr_para:
	stp	x29, x30, [sp, -16]!
	mov	x3, x0
	and	w2, w1, 255
	mov	w0, 239
	add	x29, sp, 0
	str	w0, [x3, 8]
	mov	w0, 17
	str	w0, [x3, 4]
	mov	w0, 200
	bl	timer_delay_ns
	add	w1, w2, 1
	adrp	x0, .LANCHOR26
	adrp	x2, .LANCHOR22
	add	x2, x2, :lo12:.LANCHOR22
	ldrb	w4, [x0, #:lo12:.LANCHOR26]
	adrp	x0, .LANCHOR24
	ldrb	w5, [x0, #:lo12:.LANCHOR24]
	mov	w0, 5
	umull	x1, w1, w0
	adrp	x0, .LANCHOR23
	add	x0, x0, :lo12:.LANCHOR23
	add	x2, x2, x1
	add	x1, x0, x1
	mov	x0, 0
.L348:
	cmp	w4, w0
	bhi	.L351
	ldp	x29, x30, [sp], 16
	b	nandc_wait_flash_ready
.L351:
	cmp	w5, 67
	bne	.L349
	ldrsb	w6, [x1, x0]
.L353:
	add	x0, x0, 1
	str	w6, [x3]
	b	.L348
.L349:
	ldrsb	w6, [x2, x0]
	b	.L353
	.size	sandisk_set_rr_para, .-sandisk_set_rr_para
	.section	.text.toshiba_3d_set_tlc_rr_para,"ax",@progbits
	.align	2
	.global	toshiba_3d_set_tlc_rr_para
	.type	toshiba_3d_set_tlc_rr_para, %function
toshiba_3d_set_tlc_rr_para:
	mov	x4, x0
	stp	x29, x30, [sp, -16]!
	and	x2, x1, 255
	mov	x1, 7
	add	x29, sp, 0
	mov	w6, 213
	str	w6, [x4, 8]
	str	wzr, [x4, 4]
	nop // between mem op and mult-accumulate
	madd	x1, x2, x1, x1
	mov	w0, -119
	str	w0, [x4, 4]
	adrp	x0, .LANCHOR36
	add	x0, x0, :lo12:.LANCHOR36
	add	x5, x0, x1
	ldrsb	w0, [x0, x1]
	str	w0, [x4]
	ldrsb	w0, [x5, 1]
	str	w0, [x4]
	ldrsb	w0, [x5, 2]
	str	w0, [x4]
	ldrsb	w0, [x5, 3]
	str	w0, [x4]
	bl	nandc_wait_flash_ready
	ldp	x29, x30, [sp], 16
	str	w6, [x4, 8]
	str	wzr, [x4, 4]
	mov	w0, -118
	str	w0, [x4, 4]
	ldrsb	w0, [x5, 4]
	str	w0, [x4]
	ldrsb	w0, [x5, 5]
	str	w0, [x4]
	ldrsb	w0, [x5, 6]
	str	w0, [x4]
	str	wzr, [x4]
	b	nandc_wait_flash_ready
	.size	toshiba_3d_set_tlc_rr_para, .-toshiba_3d_set_tlc_rr_para
	.section	.text.toshiba_3d_set_slc_rr_para,"ax",@progbits
	.align	2
	.global	toshiba_3d_set_slc_rr_para
	.type	toshiba_3d_set_slc_rr_para, %function
toshiba_3d_set_slc_rr_para:
	mov	w2, 213
	str	w2, [x0, 8]
	str	wzr, [x0, 4]
	mov	w2, -117
	str	w2, [x0, 4]
	adrp	x2, .LANCHOR37
	add	x2, x2, :lo12:.LANCHOR37
	add	x1, x2, x1, uxtb
	ldrsb	w1, [x1, 1]
	str	w1, [x0]
	str	wzr, [x0]
	str	wzr, [x0]
	str	wzr, [x0]
	b	nandc_wait_flash_ready
	.size	toshiba_3d_set_slc_rr_para, .-toshiba_3d_set_slc_rr_para
	.section	.text.toshiba_tlc_set_rr_para,"ax",@progbits
	.align	2
	.global	toshiba_tlc_set_rr_para
	.type	toshiba_tlc_set_rr_para, %function
toshiba_tlc_set_rr_para:
	mov	w6, 239
	uxtw	x1, w1
	cbz	w2, .L358
	stp	x29, x30, [sp, -16]!
	mov	x4, x0
	mov	x2, 7
	mov	w0, 18
	add	x29, sp, 0
	str	w6, [x4, 8]
	mul	x1, x1, x2
	str	w0, [x4, 4]
	adrp	x0, .LANCHOR38
	add	x0, x0, :lo12:.LANCHOR38
	add	x5, x0, x1
	ldrb	w0, [x0, x1]
	str	w0, [x4]
	ldrb	w0, [x5, 1]
	str	w0, [x4]
	ldrb	w0, [x5, 2]
	str	w0, [x4]
	ldrb	w0, [x5, 3]
	str	w0, [x4]
	bl	nandc_wait_flash_ready
	str	w6, [x4, 8]
	mov	w0, 19
	str	w0, [x4, 4]
	ldrb	w0, [x5, 4]
	str	w0, [x4]
	ldrb	w0, [x5, 5]
	str	w0, [x4]
	ldrb	w0, [x5, 6]
	str	w0, [x4]
	str	wzr, [x4]
	ldp	x29, x30, [sp], 16
.L361:
	b	nandc_wait_flash_ready
.L358:
	str	w6, [x0, 8]
	mov	w2, 20
	str	w2, [x0, 4]
	adrp	x2, .LANCHOR39
	add	x2, x2, :lo12:.LANCHOR39
	ldrb	w1, [x2, x1]
	str	w1, [x0]
	str	wzr, [x0]
	str	wzr, [x0]
	str	wzr, [x0]
	b	.L361
	.size	toshiba_tlc_set_rr_para, .-toshiba_tlc_set_rr_para
	.section	.text.flash_erase_duplane_block,"ax",@progbits
	.align	2
	.global	flash_erase_duplane_block
	.type	flash_erase_duplane_block, %function
flash_erase_duplane_block:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	and	w22, w0, 255
	adrp	x0, .LANCHOR18
	stp	x19, x20, [sp, 16]
	stp	x23, x24, [sp, 48]
	and	w24, w1, 255
	str	x25, [sp, 64]
	mov	w21, w2
	ldrb	w1, [x0, #:lo12:.LANCHOR18]
	mov	w20, w3
	mov	x19, x0
	cmp	w1, w22
	bhi	.L365
	adrp	x1, .LANCHOR40
	adrp	x0, .LC0
	mov	w2, 598
	add	x1, x1, :lo12:.LANCHOR40
	add	x0, x0, :lo12:.LC0
	bl	printf
.L365:
	ldrb	w0, [x19, #:lo12:.LANCHOR18]
	cmp	w0, w22
	bls	.L372
	adrp	x0, .LANCHOR30
	add	x0, x0, :lo12:.LANCHOR30
	ldrb	w22, [x0, w22, sxtw]
	adrp	x0, .LANCHOR13
	ldr	x25, [x0, #:lo12:.LANCHOR13]
	adrp	x0, .LANCHOR14
	and	x19, x22, 255
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	add	x23, x19, 8
	add	x23, x25, x23, lsl 8
	tbz	x0, 4, .L367
	adrp	x0, .LC32
	mov	w3, w20
	mov	w2, w21
	mov	w1, w22
	add	x0, x0, :lo12:.LC32
	bl	printf
.L367:
	bl	nandc_wait_flash_ready
	mov	w0, w22
	bl	nandc_cs
	mov	w0, w22
	cbnz	w24, .L368
	bl	zftl_flash_enter_slc_mode
.L369:
	add	x25, x25, x19, lsl 8
	mov	w0, 96
	str	w0, [x25, 2056]
	and	w0, w21, 255
	str	w0, [x25, 2052]
	lsr	w0, w21, 8
	str	w0, [x25, 2052]
	lsr	w0, w21, 16
	str	w0, [x25, 2052]
	adrp	x0, .LANCHOR41
	ldrb	w0, [x0, #:lo12:.LANCHOR41]
	cbnz	w0, .L373
	mov	w0, 208
	str	w0, [x25, 2056]
	mov	w19, 5
	bl	nandc_wait_flash_ready
	mov	x0, x23
	bl	flash_read_status
	and	w5, w0, w19
.L370:
	mov	w0, 96
	str	w0, [x25, 2056]
	and	w0, w20, 255
	str	w0, [x25, 2052]
	lsr	w0, w20, 8
	str	w0, [x25, 2052]
	lsr	w20, w20, 16
	str	w20, [x25, 2052]
	mov	w0, 208
	str	w0, [x25, 2056]
	mov	w19, 5
	bl	nandc_wait_flash_ready
	mov	x0, x23
	bl	flash_read_status
	mov	w2, w0
	bl	nandc_de_cs.constprop.30
	and	w19, w2, w19
	orr	w19, w19, w5
	cbz	w19, .L371
	adrp	x0, .LC33
	mov	w1, w21
	add	x0, x0, :lo12:.LC33
	bl	printf
.L371:
	mov	w0, w19
.L364:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L368:
	bl	zftl_flash_exit_slc_mode
	b	.L369
.L373:
	mov	w5, 0
	b	.L370
.L372:
	mov	w0, -1
	b	.L364
	.size	flash_erase_duplane_block, .-flash_erase_duplane_block
	.section	.text.flash_erase_block_en,"ax",@progbits
	.align	2
	.global	flash_erase_block_en
	.type	flash_erase_block_en, %function
flash_erase_block_en:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	and	w22, w0, 255
	adrp	x0, .LANCHOR31
	stp	x19, x20, [sp, 16]
	mov	w19, 24
	stp	x23, x24, [sp, 48]
	ldrb	w0, [x0, #:lo12:.LANCHOR31]
	and	w24, w1, 255
	stp	x25, x26, [sp, 64]
	mov	w23, w2
	sub	w0, w19, w0
	mov	w19, 1
	lsl	w19, w19, w0
	adrp	x0, .LANCHOR18
	sub	w19, w19, #1
	mov	x20, x0
	ldrb	w1, [x0, #:lo12:.LANCHOR18]
	and	w19, w19, w2
	cmp	w1, w22
	bhi	.L382
	adrp	x1, .LANCHOR42
	adrp	x0, .LC0
	mov	w2, 645
	add	x1, x1, :lo12:.LANCHOR42
	add	x0, x0, :lo12:.LC0
	bl	printf
.L382:
	ldrb	w0, [x20, #:lo12:.LANCHOR18]
	cmp	w0, w22
	bls	.L388
	adrp	x0, .LANCHOR30
	add	x0, x0, :lo12:.LANCHOR30
	ldrb	w21, [x0, w22, sxtw]
	adrp	x0, .LANCHOR13
	ldr	x26, [x0, #:lo12:.LANCHOR13]
	adrp	x0, .LANCHOR14
	and	x20, x21, 255
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	add	x25, x20, 8
	add	x25, x26, x25, lsl 8
	tbz	x0, 4, .L384
	adrp	x0, .LC34
	mov	w3, w24
	mov	w2, w23
	mov	w1, w21
	add	x0, x0, :lo12:.LC34
	bl	printf
.L384:
	bl	nandc_wait_flash_ready
	mov	w0, w21
	bl	nandc_cs
	mov	w0, w21
	cbnz	w24, .L385
	bl	zftl_flash_enter_slc_mode
.L386:
	add	x0, x26, x20, lsl 8
	mov	w1, 96
	str	w1, [x0, 2056]
	and	w1, w19, 255
	str	w1, [x0, 2052]
	lsr	w1, w19, 8
	str	w1, [x0, 2052]
	lsr	w19, w19, 16
	str	w19, [x0, 2052]
	mov	w1, 208
	str	w1, [x0, 2056]
	bl	nandc_wait_flash_ready
	mov	x0, x25
	bl	flash_read_status
	mov	w19, w0
	bl	nandc_de_cs.constprop.30
	mov	w0, 5
	ands	w19, w19, w0
	beq	.L387
	adrp	x0, .LANCHOR2
	mov	w3, w19
	mov	w1, w22
	ldrh	w2, [x0, #:lo12:.LANCHOR2]
	adrp	x0, .LC35
	add	x0, x0, :lo12:.LC35
	udiv	w2, w23, w2
	bl	printf
.L387:
	mov	w0, w19
.L381:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L385:
	bl	zftl_flash_exit_slc_mode
	b	.L386
.L388:
	mov	w0, -1
	b	.L381
	.size	flash_erase_block_en, .-flash_erase_block_en
	.section	.text.flash_erase_block,"ax",@progbits
	.align	2
	.global	flash_erase_block
	.type	flash_erase_block, %function
flash_erase_block:
	mov	w2, w1
	mov	w1, 0
	b	flash_erase_block_en
	.size	flash_erase_block, .-flash_erase_block
	.section	.text.flash_erase_all,"ax",@progbits
	.align	2
	.global	flash_erase_all
	.type	flash_erase_all, %function
flash_erase_all:
	stp	x29, x30, [sp, -80]!
	adrp	x0, .LANCHOR32
	add	x0, x0, :lo12:.LANCHOR32
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w19, 0
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR2
	stp	x21, x22, [sp, 32]
	add	x23, x23, :lo12:.LANCHOR2
	ldrh	w20, [x0, 14]
	adrp	x22, .LANCHOR18
	str	x25, [sp, 64]
	add	x22, x22, :lo12:.LANCHOR18
	adrp	x24, .LANCHOR30
	ldrb	w1, [x0, 13]
	mul	w20, w20, w1
	and	w20, w20, 65535
.L398:
	ldrb	w0, [x22]
	cmp	w0, w19
	bhi	.L401
	ldp	x19, x20, [sp, 16]
	mov	w1, 0
	ldp	x21, x22, [sp, 32]
	adrp	x0, .LC36
	ldp	x23, x24, [sp, 48]
	add	x0, x0, :lo12:.LC36
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	b	printf
.L401:
	add	x0, x24, :lo12:.LANCHOR30
	mov	w21, 0
	ldrb	w25, [x0, w19, sxtw]
.L399:
	cmp	w20, w21, uxth
	bhi	.L400
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L398
.L400:
	ldrh	w1, [x23]
	mov	w0, w25
	mul	w1, w1, w21
	add	w21, w21, 1
	bl	flash_erase_block
	b	.L399
	.size	flash_erase_all, .-flash_erase_all
	.section	.text.flash_start_plane_read,"ax",@progbits
	.align	2
	.global	flash_start_plane_read
	.type	flash_start_plane_read, %function
flash_start_plane_read:
	stp	x29, x30, [sp, -48]!
	adrp	x2, .LANCHOR31
	mov	w3, 24
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	ldrb	w20, [x2, #:lo12:.LANCHOR31]
	mov	w2, 1
	stp	x21, x22, [sp, 32]
	ubfx	x21, x0, 24, 2
	sub	w3, w3, w20
	lsl	w20, w2, w20
	sub	w20, w20, #1
	lsl	w19, w2, w3
	sub	w19, w19, #1
	and	w22, w19, w0
	lsr	w3, w0, w3
	adrp	x0, .LANCHOR18
	and	w20, w20, w3
	and	w20, w20, 255
	and	w19, w19, w1
	ldrb	w0, [x0, #:lo12:.LANCHOR18]
	cmp	w0, w20
	bhi	.L404
	adrp	x1, .LANCHOR43
	adrp	x0, .LC0
	mov	w2, 965
	add	x1, x1, :lo12:.LANCHOR43
	add	x0, x0, :lo12:.LC0
	bl	printf
.L404:
	adrp	x0, .LANCHOR30
	add	x0, x0, :lo12:.LANCHOR30
	ldrb	w7, [x0, w20, sxtw]
	adrp	x0, .LANCHOR13
	ldr	x10, [x0, #:lo12:.LANCHOR13]
	mov	w0, w7
	bl	nandc_cs
	adrp	x8, .LANCHOR16
	cbnz	w21, .L405
	mov	w0, w22
	bl	slc_phy_page_address_calc
	mov	w22, w0
	mov	w0, w19
	bl	slc_phy_page_address_calc
	mov	w19, w0
	adrp	x0, .LANCHOR0
	ldrb	w0, [x0, #:lo12:.LANCHOR0]
	cbz	w0, .L406
	mov	w0, w7
	bl	zftl_flash_enter_slc_mode
.L406:
	adrp	x0, .LANCHOR20
	and	x4, x7, 255
	add	x1, x0, :lo12:.LANCHOR20
	add	x4, x10, x4, lsl 8
	and	w3, w22, 255
	and	w6, w19, 255
	lsr	w5, w19, 8
	lsr	w19, w19, 16
	ldrb	w11, [x1, 8]
	ldrb	w2, [x1, 16]
	str	w11, [x4, 2056]
	cmp	w2, 1
	lsr	w2, w22, 8
	lsr	w22, w22, 16
	bne	.L408
	str	wzr, [x4, 2052]
	str	wzr, [x4, 2052]
	str	w3, [x4, 2052]
	str	w2, [x4, 2052]
	ldrb	w0, [x1, 9]
	str	w22, [x4, 2052]
	str	w0, [x4, 2056]
	bl	nandc_wait_flash_ready
	ldr	x0, [x8, #:lo12:.LANCHOR16]
	ldrb	w0, [x0, 12]
	cmp	w0, 3
	bne	.L409
	cbz	w21, .L409
	str	w21, [x4, 2056]
.L409:
	str	wzr, [x4, 2056]
	str	wzr, [x4, 2052]
	str	wzr, [x4, 2052]
.L422:
	ldp	x21, x22, [sp, 32]
	str	w6, [x4, 2052]
	str	w5, [x4, 2052]
	mov	w0, 48
	str	w19, [x4, 2052]
	str	w0, [x4, 2056]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	b	nandc_de_cs.constprop.30
.L405:
	ldr	x0, [x8, #:lo12:.LANCHOR16]
	ldrb	w0, [x0, 12]
	cmp	w0, 3
	bne	.L407
	adrp	x0, .LANCHOR35
	ldrb	w0, [x0, #:lo12:.LANCHOR35]
	cbnz	w0, .L407
	sxtw	x0, w7
	add	x0, x0, 8
	add	x0, x10, x0, lsl 8
	str	w21, [x0, 8]
	b	.L406
.L407:
	mov	w0, w7
	bl	zftl_flash_exit_slc_mode
	b	.L406
.L408:
	str	w3, [x4, 2052]
	ldr	x1, [x8, #:lo12:.LANCHOR16]
	str	w2, [x4, 2052]
	str	w22, [x4, 2052]
	ldrb	w1, [x1, 12]
	cmp	w1, 3
	bne	.L411
	cbz	w21, .L411
	str	w21, [x4, 2056]
.L411:
	add	x0, x0, :lo12:.LANCHOR20
	ldrb	w0, [x0, 9]
	str	w0, [x4, 2056]
	b	.L422
	.size	flash_start_plane_read, .-flash_start_plane_read
	.section	.text.flash_set_interface_mode,"ax",@progbits
	.align	2
	.global	flash_set_interface_mode
	.type	flash_set_interface_mode, %function
flash_set_interface_mode:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR44
	stp	x19, x20, [sp, 16]
	adrp	x21, .LANCHOR14
	stp	x23, x24, [sp, 48]
	adrp	x20, .LANCHOR45
	mov	w23, w0
	add	x22, x22, :lo12:.LANCHOR44
	add	x20, x20, :lo12:.LANCHOR45
	add	x21, x21, :lo12:.LANCHOR14
	str	x25, [sp, 64]
	mov	x25, 0
.L436:
	adrp	x0, .LANCHOR13
	ldr	x19, [x0, #:lo12:.LANCHOR13]
	lsl	x0, x25, 3
	ldrb	w24, [x0, x22]
	cmp	w24, 69
	beq	.L424
	add	w0, w24, 119
	cmp	w24, 44
	and	w1, w0, 255
	cset	w2, eq
	cmp	w1, 18
	bhi	.L437
	mov	x0, 32769
	movk	x0, 0x4, lsl 16
	lsr	x0, x0, x1
	mvn	x0, x0
.L425:
	and	w0, w0, 1
	eor	w0, w0, 1
	orr	w0, w2, w0
	cbz	w0, .L426
.L424:
	ldrb	w1, [x20]
	cmp	w23, 1
	bne	.L427
	tbz	x1, 0, .L426
	ldr	w0, [x21]
	tbz	x0, 12, .L428
	adrp	x0, .LC37
	add	x0, x0, :lo12:.LC37
	bl	printf
.L428:
	add	x0, x19, x25, lsl 8
	mov	w1, 239
	cmp	w24, 44
	str	w1, [x0, 2056]
	mov	w1, 137
	ccmp	w24, w1, 4, ne
	mov	w1, 1
	bne	.L429
	str	w1, [x0, 2052]
	mov	w1, 5
.L459:
	str	w1, [x0, 2048]
.L434:
	str	wzr, [x0, 2048]
	str	wzr, [x0, 2048]
	str	wzr, [x0, 2048]
.L426:
	add	x25, x25, 1
	cmp	x25, 4
	bne	.L436
	bl	nandc_wait_flash_ready
	ldr	x25, [sp, 64]
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L437:
	mov	x0, 1
	b	.L425
.L429:
	cmp	w24, 155
	bne	.L431
	str	w1, [x0, 2052]
	mov	w1, 3
	b	.L459
.L431:
	mov	w2, 128
	str	w2, [x0, 2052]
	b	.L459
.L427:
	tbz	x1, 2, .L426
	ldr	w0, [x21]
	tbz	x0, 12, .L432
	adrp	x0, .LC38
	add	x0, x0, :lo12:.LC38
	bl	printf
.L432:
	add	x0, x19, x25, lsl 8
	mov	w1, 239
	cmp	w24, 44
	str	w1, [x0, 2056]
	mov	w1, 137
	ccmp	w24, w1, 4, ne
	bne	.L433
	mov	w1, 1
	str	w1, [x0, 2052]
	mov	w1, 35
	b	.L459
.L433:
	cmp	w24, 155
	bne	.L435
	mov	w1, 1
	str	w1, [x0, 2052]
	mov	w1, 37
	b	.L459
.L435:
	mov	w1, 128
	str	w1, [x0, 2052]
	str	wzr, [x0, 2048]
	b	.L434
	.size	flash_set_interface_mode, .-flash_set_interface_mode
	.section	.text.mt_auto_read_calibration_config,"ax",@progbits
	.align	2
	.type	mt_auto_read_calibration_config, %function
mt_auto_read_calibration_config:
	mov	w5, w1
	and	w4, w0, 255
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
	bl	nandc_wait_flash_ready
	ubfiz	x4, x4, 8, 8
	adrp	x0, .LANCHOR13
	ldr	x2, [x0, #:lo12:.LANCHOR13]
	mov	w0, 239
	add	x2, x2, x4
	str	w0, [x2, 2056]
	mov	w0, 150
	str	w0, [x2, 2052]
	mov	w0, 200
	bl	timer_delay_ns
	str	w5, [x2, 2048]
	str	wzr, [x2, 2048]
	str	wzr, [x2, 2048]
	str	wzr, [x2, 2048]
	ldp	x29, x30, [sp], 16
	ret
	.size	mt_auto_read_calibration_config, .-mt_auto_read_calibration_config
	.section	.text.flash_reset,"ax",@progbits
	.align	2
	.global	flash_reset
	.type	flash_reset, %function
flash_reset:
	adrp	x1, .LANCHOR13
	ubfiz	x0, x0, 8, 8
	add	x0, x0, 2048
	ldr	x1, [x1, #:lo12:.LANCHOR13]
	add	x1, x1, x0
	mov	w0, 255
	str	w0, [x1, 8]
	b	nandc_wait_flash_ready
	.size	flash_reset, .-flash_reset
	.section	.text.flash_read_id,"ax",@progbits
	.align	2
	.global	flash_read_id
	.type	flash_read_id, %function
flash_read_id:
	and	w10, w0, 255
	stp	x29, x30, [sp, -16]!
	adrp	x0, .LANCHOR13
	mov	x8, x1
	add	x29, sp, 0
	ldr	x4, [x0, #:lo12:.LANCHOR13]
	mov	w0, w10
	bl	flash_reset
	mov	w0, w10
	bl	nandc_cs
	ubfiz	x2, x10, 8, 8
	add	x2, x4, x2
	mov	w0, 144
	str	w0, [x2, 2056]
	mov	w0, 200
	str	wzr, [x2, 2052]
	bl	timer_delay_ns
	ldr	w0, [x2, 2048]
	strb	w0, [x8]
	ldr	w0, [x2, 2048]
	strb	w0, [x8, 1]
	ldr	w0, [x2, 2048]
	strb	w0, [x8, 2]
	ldr	w0, [x2, 2048]
	strb	w0, [x8, 3]
	ldr	w0, [x2, 2048]
	strb	w0, [x8, 4]
	ldr	w0, [x2, 2048]
	strb	w0, [x8, 5]
	ldr	w0, [x2, 2048]
	strb	w0, [x8, 6]
	ldr	w0, [x2, 2048]
	strb	w0, [x8, 7]
	bl	nandc_de_cs.constprop.30
	ldrb	w2, [x8]
	sub	w0, w2, #1
	and	w0, w0, 255
	cmp	w0, 253
	bhi	.L463
	ldrb	w7, [x8, 5]
	add	w1, w10, 1
	ldrb	w6, [x8, 4]
	adrp	x0, .LC39
	ldrb	w5, [x8, 3]
	add	x0, x0, :lo12:.LC39
	ldrb	w4, [x8, 2]
	ldrb	w3, [x8, 1]
	ldp	x29, x30, [sp], 16
	b	printf
.L463:
	ldp	x29, x30, [sp], 16
	ret
	.size	flash_read_id, .-flash_read_id
	.section	.text.flash_read_spare,"ax",@progbits
	.align	2
	.global	flash_read_spare
	.type	flash_read_spare, %function
flash_read_spare:
	stp	x29, x30, [sp, -16]!
	mov	x5, x2
	adrp	x2, .LANCHOR32+9
	ubfiz	x0, x0, 8, 8
	add	x29, sp, 0
	ldrb	w3, [x2, #:lo12:.LANCHOR32+9]
	adrp	x2, .LANCHOR13
	ldr	x4, [x2, #:lo12:.LANCHOR13]
	lsl	w3, w3, 9
	add	x4, x4, x0
	and	w0, w1, 255
	str	wzr, [x4, 2056]
	str	w3, [x4, 2052]
	lsr	w3, w3, 8
	str	w3, [x4, 2052]
	str	w0, [x4, 2052]
	lsr	w0, w1, 8
	str	w0, [x4, 2052]
	lsr	w1, w1, 16
	str	w1, [x4, 2052]
	mov	w0, 48
	str	w0, [x4, 2056]
	bl	nandc_wait_flash_ready
	ldr	w0, [x4, 2048]
	ldp	x29, x30, [sp], 16
	strb	w0, [x5]
	ret
	.size	flash_read_spare, .-flash_read_spare
	.section	.text.flash_read_otp_data,"ax",@progbits
	.align	2
	.global	flash_read_otp_data
	.type	flash_read_otp_data, %function
flash_read_otp_data:
	stp	x29, x30, [sp, -48]!
	and	w4, w0, 255
	adrp	x0, .LANCHOR13
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w20, w1
	ldr	x19, [x0, #:lo12:.LANCHOR13]
	mov	w0, w4
	str	x21, [sp, 32]
	mov	x21, x2
	bl	nandc_cs
	ubfiz	x4, x4, 8, 8
	add	x19, x19, x4
	mov	w0, 239
	mov	w4, 144
	str	w0, [x19, 2056]
	mov	w0, 50
	str	w4, [x19, 2052]
	bl	timer_delay_ns
	mov	w0, 1
	str	w0, [x19, 2048]
	str	wzr, [x19, 2048]
	str	wzr, [x19, 2048]
	str	wzr, [x19, 2048]
	bl	nandc_wait_flash_ready
	mov	w0, 238
	str	w0, [x19, 2056]
	str	w4, [x19, 2052]
	mov	w1, w20
	adrp	x0, .LC40
	add	x0, x0, :lo12:.LC40
	ldr	w2, [x19, 2048]
	ldr	w3, [x19, 2048]
	ldr	w4, [x19, 2048]
	bl	printf
	bl	nandc_wait_flash_ready
	str	wzr, [x19, 2056]
	str	wzr, [x19, 2052]
	and	w0, w20, 255
	str	wzr, [x19, 2052]
	str	w0, [x19, 2052]
	lsr	w0, w20, 8
	str	w0, [x19, 2052]
	lsr	w20, w20, 16
	str	w20, [x19, 2052]
	mov	w0, 48
	str	w0, [x19, 2056]
	bl	nandc_wait_flash_ready
	mov	x0, 0
.L469:
	ldr	w1, [x19, 2048]
	strb	w1, [x21, x0]
	add	x0, x0, 1
	cmp	x0, 16384
	bne	.L469
	mov	w0, 239
	str	w0, [x19, 2056]
	mov	w0, 144
	str	w0, [x19, 2052]
	mov	w0, 50
	bl	timer_delay_ns
	ldr	x21, [sp, 32]
	str	wzr, [x19, 2048]
	str	wzr, [x19, 2048]
	str	wzr, [x19, 2048]
	str	wzr, [x19, 2048]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	b	nandc_de_cs.constprop.30
	.size	flash_read_otp_data, .-flash_read_otp_data
	.section	.text.sandisk_prog_test_bad_block,"ax",@progbits
	.align	2
	.global	sandisk_prog_test_bad_block
	.type	sandisk_prog_test_bad_block, %function
sandisk_prog_test_bad_block:
	stp	x29, x30, [sp, -32]!
	mov	w5, w1
	adrp	x1, .LANCHOR13
	and	x2, x0, 255
	add	x29, sp, 0
	ldr	x4, [x1, #:lo12:.LANCHOR13]
	adrp	x1, .LANCHOR32+29
	str	x19, [sp, 16]
	mov	x0, x2
	ldrb	w1, [x1, #:lo12:.LANCHOR32+29]
	add	x2, x2, 8
	add	x2, x4, x2, lsl 8
	cbz	w1, .L473
.L483:
	ubfiz	x0, x0, 8, 8
	str	w1, [x2, 8]
	add	x4, x4, x0
	mov	w0, 128
	str	w0, [x4, 2056]
	and	w0, w5, 255
	str	wzr, [x4, 2052]
	str	wzr, [x4, 2052]
	str	w0, [x4, 2052]
	lsr	w0, w5, 8
	str	w0, [x4, 2052]
	lsr	w0, w5, 16
	str	w0, [x4, 2052]
	mov	w0, 16
	str	w0, [x4, 2056]
	bl	nandc_wait_flash_ready
	mov	w0, 112
	str	w0, [x4, 2056]
	mov	w0, 80
	bl	timer_delay_ns
	ldr	w2, [x4, 2048]
	mov	w0, 5
	ands	w19, w2, w0
	beq	.L472
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L472
	adrp	x0, .LC41
	mov	w1, w5
	add	x0, x0, :lo12:.LC41
	bl	printf
.L472:
	mov	w0, w19
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L473:
	mov	w1, 162
	b	.L483
	.size	sandisk_prog_test_bad_block, .-sandisk_prog_test_bad_block
	.section	.text.nandc_rdy_status,"ax",@progbits
	.align	2
	.global	nandc_rdy_status
	.type	nandc_rdy_status, %function
nandc_rdy_status:
	adrp	x0, .LANCHOR13
	sub	sp, sp, #16
	ldr	x0, [x0, #:lo12:.LANCHOR13]
	ldr	w0, [x0]
	str	w0, [sp, 8]
	ldr	w0, [sp, 8]
	add	sp, sp, 16
	ubfx	x0, x0, 9, 1
	ret
	.size	nandc_rdy_status, .-nandc_rdy_status
	.section	.text.nandc_bch_sel,"ax",@progbits
	.align	2
	.global	nandc_bch_sel
	.type	nandc_bch_sel, %function
nandc_bch_sel:
	sub	sp, sp, #16
	str	wzr, [sp, 8]
	ldr	w1, [sp, 8]
	orr	w1, w1, 1
	str	w1, [sp, 8]
	adrp	x1, .LANCHOR46
	strb	w0, [x1, #:lo12:.LANCHOR46]
	adrp	x1, .LANCHOR28
	ldrb	w1, [x1, #:lo12:.LANCHOR28]
	cmp	w1, 9
	adrp	x1, .LANCHOR13
	bne	.L487
	ldr	x1, [x1, #:lo12:.LANCHOR13]
	cmp	w0, 70
	ldr	w2, [sp, 8]
	str	w2, [x1, 16]
	beq	.L493
	cmp	w0, 60
	beq	.L494
	cmp	w0, 40
	cset	w0, eq
	add	w0, w0, 1
.L488:
	str	wzr, [sp]
	ldr	w2, [sp]
	bfi	w2, w0, 25, 3
	str	w2, [sp]
	ldr	w0, [sp]
	orr	w0, w0, 1
	str	w0, [sp]
	ldr	w0, [sp]
	str	w0, [x1, 32]
.L486:
	add	sp, sp, 16
	ret
.L493:
	mov	w0, 0
	b	.L488
.L494:
	mov	w0, 3
	b	.L488
.L487:
	ldr	x2, [x1, #:lo12:.LANCHOR13]
	mov	w3, 16
	ldr	w1, [sp, 8]
	cmp	w0, w3
	str	w1, [x2, 8]
	str	wzr, [sp]
	ldr	w1, [sp]
	bfi	w1, w3, 8, 8
	str	w1, [sp]
	ldr	w1, [sp]
	and	w1, w1, -262145
	str	w1, [sp]
	bne	.L490
.L497:
	ldr	w0, [sp]
	and	w0, w0, -17
	b	.L498
.L490:
	cmp	w0, 24
	bne	.L492
	ldr	w0, [sp]
	orr	w0, w0, 16
.L498:
	str	w0, [sp]
	b	.L491
.L492:
	ldr	w1, [sp]
	cmp	w0, 40
	orr	w1, w1, 262144
	str	w1, [sp]
	ldr	w1, [sp]
	orr	w1, w1, 16
	str	w1, [sp]
	beq	.L497
.L491:
	ldr	w0, [sp]
	orr	w0, w0, 1
	str	w0, [sp]
	ldr	w0, [sp]
	str	w0, [x2, 12]
	b	.L486
	.size	nandc_bch_sel, .-nandc_bch_sel
	.section	.text.zftl_nandc_get_irq_status,"ax",@progbits
	.align	2
	.global	zftl_nandc_get_irq_status
	.type	zftl_nandc_get_irq_status, %function
zftl_nandc_get_irq_status:
	adrp	x1, .LANCHOR28
	ldrb	w1, [x1, #:lo12:.LANCHOR28]
	cmp	w1, 9
	bne	.L500
	ldr	w0, [x0, 296]
	ret
.L500:
	ldr	w0, [x0, 372]
	ret
	.size	zftl_nandc_get_irq_status, .-zftl_nandc_get_irq_status
	.section	.text.rk_nandc_flash_ready,"ax",@progbits
	.align	2
	.global	rk_nandc_flash_ready
	.type	rk_nandc_flash_ready, %function
rk_nandc_flash_ready:
	ret
	.size	rk_nandc_flash_ready, .-rk_nandc_flash_ready
	.section	.text.nandc_iqr_wait_flash_ready,"ax",@progbits
	.align	2
	.global	nandc_iqr_wait_flash_ready
	.type	nandc_iqr_wait_flash_ready, %function
nandc_iqr_wait_flash_ready:
	ret
	.size	nandc_iqr_wait_flash_ready, .-nandc_iqr_wait_flash_ready
	.section	.text.rk_nandc_flash_xfer_completed,"ax",@progbits
	.align	2
	.global	rk_nandc_flash_xfer_completed
	.type	rk_nandc_flash_xfer_completed, %function
rk_nandc_flash_xfer_completed:
	ret
	.size	rk_nandc_flash_xfer_completed, .-rk_nandc_flash_xfer_completed
	.section	.text.nandc_xfer_start,"ax",@progbits
	.align	2
	.global	nandc_xfer_start
	.type	nandc_xfer_start, %function
nandc_xfer_start:
	stp	x29, x30, [sp, -80]!
	and	w1, w1, 255
	adrp	x4, .LANCHOR49
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w20, w0, 255
	adrp	x0, .LANCHOR28
	str	x21, [sp, 32]
	and	w6, w20, 1
	adrp	x21, .LANCHOR13
	ldrb	w0, [x0, #:lo12:.LANCHOR28]
	cmp	w0, 9
	add	w0, w1, 1
	bne	.L506
	str	wzr, [x29, 56]
	mov	w5, 1
	ubfx	x0, x0, 1, 6
	ldr	w1, [x29, 56]
	bfi	w1, w6, 1, 1
	str	w1, [x29, 56]
	ldr	w1, [x29, 56]
	orr	w1, w1, 8
	str	w1, [x29, 56]
	ldr	w1, [x29, 56]
	bfi	w1, w5, 5, 2
	str	w1, [x29, 56]
	ldr	w1, [x29, 56]
	orr	w1, w1, 536870912
	str	w1, [x29, 56]
	ldr	w1, [x29, 56]
	orr	w1, w1, 1024
	str	w1, [x29, 56]
	ldr	w1, [x29, 56]
	and	w1, w1, -17
	str	w1, [x29, 56]
	ldr	w1, [x29, 56]
	bfi	w1, w0, 22, 6
	str	w1, [x29, 56]
	ldr	w0, [x29, 56]
	orr	w0, w0, 128
	str	w0, [x29, 56]
	adrp	x0, .LANCHOR47
	ldrb	w0, [x0, #:lo12:.LANCHOR47]
	cbz	w0, .L507
	adrp	x0, .LANCHOR48
	ldrb	w0, [x0, #:lo12:.LANCHOR48]
	cbz	w0, .L507
	ldr	w0, [x29, 56]
	orr	w0, w0, 512
	str	w0, [x29, 56]
.L507:
	ldr	w0, [x29, 56]
	add	x19, x4, :lo12:.LANCHOR49
	add	x1, x2, 63
	and	x1, x1, -64
	ubfx	x0, x0, 22, 6
	stp	x2, x3, [x19, 8]
	ubfiz	x0, x0, 10, 6
	stp	w2, w3, [x19, 24]
	add	x1, x1, x0
	and	x0, x2, -64
	bl	flush_dcache_range
	ldr	x0, [x19, 16]
	add	x1, x0, 63
	and	x0, x0, -64
	and	x1, x1, -64
	add	x1, x1, 64
	bl	flush_dcache_range
	mov	w0, 1
	str	w0, [x19, 32]
	ldr	x0, [x21, #:lo12:.LANCHOR13]
	mov	w2, 16
	ldr	w1, [x19, 24]
	cmp	w20, 0
	str	w1, [x0, 52]
	ldr	w1, [x19, 28]
	str	w1, [x0, 56]
	ldr	w1, [x0, 48]
	str	w1, [x29, 64]
	ldr	w1, [x29, 64]
	bfi	w1, w2, 9, 5
	str	w1, [x29, 64]
	mov	w2, 2
	ldr	w1, [x29, 64]
	orr	w1, w1, 448
	str	w1, [x29, 64]
	ldr	w1, [x29, 64]
	bfi	w1, w2, 3, 3
	str	w1, [x29, 64]
	cset	w2, eq
	ldr	w1, [x29, 64]
	orr	w1, w1, 4
	str	w1, [x29, 64]
	ldr	w1, [x29, 64]
	bfi	w1, w2, 1, 1
	str	w1, [x29, 64]
	ldr	w1, [x29, 64]
	orr	w1, w1, 1
	str	w1, [x29, 64]
	adrp	x1, .LANCHOR50
	ldrh	w2, [x1, #:lo12:.LANCHOR50]
	ldr	w1, [x29, 64]
	bfi	w1, w2, 16, 11
	str	w1, [x29, 64]
	ldr	w1, [x29, 64]
	str	w1, [x0, 48]
	ldr	w1, [x29, 56]
	str	w1, [x0, 16]
	ldr	w1, [x29, 56]
	orr	w1, w1, 4
	str	w1, [x29, 56]
	ldr	w1, [x29, 56]
	str	w1, [x0, 16]
.L505:
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 80
	ret
.L506:
	ldr	x5, [x21, #:lo12:.LANCHOR13]
	mov	w7, 16
	ubfx	x0, x0, 1, 6
	ldr	w5, [x5, 12]
	str	w5, [x29, 72]
	ldr	w5, [x29, 72]
	bfi	w5, w7, 8, 8
	str	w5, [x29, 72]
	ldr	w5, [x29, 72]
	and	w5, w5, -9
	str	w5, [x29, 72]
	ldr	w5, [x29, 72]
	and	w5, w5, -225
	str	w5, [x29, 72]
	str	wzr, [x29, 56]
	ldr	w5, [x29, 56]
	bfi	w5, w6, 1, 1
	str	w5, [x29, 56]
	mov	w6, 1
	ldr	w5, [x29, 56]
	orr	w5, w5, 8
	str	w5, [x29, 56]
	ldr	w5, [x29, 56]
	bfi	w5, w6, 5, 2
	str	w5, [x29, 56]
	ldr	w5, [x29, 56]
	orr	w5, w5, 536870912
	str	w5, [x29, 56]
	ldr	w5, [x29, 56]
	orr	w5, w5, 1024
	str	w5, [x29, 56]
	ldr	w5, [x29, 56]
	and	w5, w5, -17
	str	w5, [x29, 56]
	ldr	w5, [x29, 56]
	bfi	w5, w0, 22, 6
	str	w5, [x29, 56]
	cbz	w20, .L509
	adrp	x0, .LANCHOR46
	ubfx	x1, x1, 1, 7
	ldr	x8, [x4, #:lo12:.LANCHOR49]
	add	x1, x3, x1, lsl 2
	ldrb	w0, [x0, #:lo12:.LANCHOR46]
	mov	w5, 64
	cmp	w0, 25
	mov	w0, 128
	csel	w5, w5, w0, cc
	mov	w0, 0
.L511:
	add	w7, w5, w0
	cmp	x3, x1
	bne	.L512
.L513:
	add	x19, x4, :lo12:.LANCHOR49
	ldr	x0, [x4, #:lo12:.LANCHOR49]
	add	x1, x2, 63
	and	x1, x1, -64
	stp	x2, x0, [x19, 8]
	stp	w2, w0, [x19, 24]
	ldr	w0, [x29, 56]
	ubfx	x0, x0, 22, 6
	ubfiz	x0, x0, 10, 6
	add	x1, x1, x0
	and	x0, x2, -64
	bl	flush_dcache_range
	ldr	x0, [x19, 16]
	ldr	w1, [x29, 56]
	add	x2, x0, 63
	and	x0, x0, -64
	and	x2, x2, -64
	ubfx	x1, x1, 22, 6
	ubfiz	x1, x1, 7, 6
	add	x1, x2, x1
	bl	flush_dcache_range
	mov	w0, 1
	str	w0, [x19, 32]
	ldr	x0, [x21, #:lo12:.LANCHOR13]
	mov	w2, 16
	ldr	w1, [x19, 24]
	cmp	w20, 0
	str	w1, [x0, 20]
	ldr	w1, [x19, 28]
	str	w1, [x0, 24]
	str	wzr, [x29, 64]
	ldr	w1, [x29, 64]
	bfi	w1, w2, 9, 5
	str	w1, [x29, 64]
	mov	w2, 2
	ldr	w1, [x29, 64]
	orr	w1, w1, 448
	str	w1, [x29, 64]
	ldr	w1, [x29, 64]
	bfi	w1, w2, 3, 3
	str	w1, [x29, 64]
	cset	w2, eq
	ldr	w1, [x29, 64]
	orr	w1, w1, 4
	str	w1, [x29, 64]
	ldr	w1, [x29, 64]
	bfi	w1, w2, 1, 1
	str	w1, [x29, 64]
	ldr	w1, [x29, 64]
	orr	w1, w1, 1
	str	w1, [x29, 64]
	ldr	w1, [x29, 64]
	str	w1, [x0, 16]
	ldr	w1, [x29, 72]
	str	w1, [x0, 12]
	ldr	w1, [x29, 56]
	str	w1, [x0, 8]
	ldr	w1, [x29, 56]
	orr	w1, w1, 4
	str	w1, [x29, 56]
	ldr	w1, [x29, 56]
	str	w1, [x0, 8]
	b	.L505
.L512:
	ldrh	w10, [x3]
	and	x0, x0, 4294967292
	ldrh	w6, [x3, 2]
	add	x3, x3, 4
	orr	x6, x10, x6, lsl 16
	str	w6, [x8, x0]
	mov	w0, w7
	b	.L511
.L509:
	ldr	x0, [x4, #:lo12:.LANCHOR49]
	str	w6, [x0]
	b	.L513
	.size	nandc_xfer_start, .-nandc_xfer_start
	.section	.text.nandc_set_seed,"ax",@progbits
	.align	2
	.global	nandc_set_seed
	.type	nandc_set_seed, %function
nandc_set_seed:
	and	x0, x0, 127
	adrp	x1, .LANCHOR51
	add	x1, x1, :lo12:.LANCHOR51
	ldrh	w0, [x1, x0, lsl 1]
	adrp	x1, .LANCHOR48
	ldrb	w2, [x1, #:lo12:.LANCHOR48]
	orr	w1, w0, -1073741824
	cmp	w2, 0
	csel	w0, w1, w0, ne
	adrp	x1, .LANCHOR28
	ldrb	w1, [x1, #:lo12:.LANCHOR28]
	cmp	w1, 9
	adrp	x1, .LANCHOR13
	ldr	x1, [x1, #:lo12:.LANCHOR13]
	bne	.L524
	str	w0, [x1, 520]
	ret
.L524:
	str	w0, [x1, 336]
	ret
	.size	nandc_set_seed, .-nandc_set_seed
	.section	.text.zftl_flash_de_init,"ax",@progbits
	.align	2
	.global	zftl_flash_de_init
	.type	zftl_flash_de_init, %function
zftl_flash_de_init:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	str	x19, [sp, 16]
	bl	nandc_wait_flash_ready
	adrp	x0, .LANCHOR0
	ldrb	w0, [x0, #:lo12:.LANCHOR0]
	cbz	w0, .L529
	adrp	x0, .LANCHOR19
	ldrb	w0, [x0, #:lo12:.LANCHOR19]
	cbnz	w0, .L529
	adrp	x0, .LANCHOR28
	ldrb	w0, [x0, #:lo12:.LANCHOR28]
	cmp	w0, 9
	beq	.L529
	mov	w0, 0
	bl	zftl_flash_exit_slc_mode
.L529:
	adrp	x19, .LANCHOR21
	mov	w0, 0
	bl	hynix_reconfig_rr_para
	ldrb	w0, [x19, #:lo12:.LANCHOR21]
	cbz	w0, .L530
	adrp	x0, .LANCHOR45
	ldrb	w0, [x0, #:lo12:.LANCHOR45]
	tbz	x0, 0, .L530
	mov	w0, 1
	bl	flash_set_interface_mode
	mov	w0, 1
	bl	nandc_set_if_mode
	strb	wzr, [x19, #:lo12:.LANCHOR21]
.L530:
	adrp	x3, .LANCHOR48
	ldrb	w0, [x3, #:lo12:.LANCHOR48]
	cbz	w0, .L531
	mov	w0, 0
	strb	wzr, [x3, #:lo12:.LANCHOR48]
	bl	nandc_set_seed
	mov	w0, 1
	strb	w0, [x3, #:lo12:.LANCHOR48]
.L531:
	mov	w0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	zftl_flash_de_init, .-zftl_flash_de_init
	.section	.text.nandc_randomizer_enable,"ax",@progbits
	.align	2
	.global	nandc_randomizer_enable
	.type	nandc_randomizer_enable, %function
nandc_randomizer_enable:
	adrp	x1, .LANCHOR48
	strb	w0, [x1, #:lo12:.LANCHOR48]
	ret
	.size	nandc_randomizer_enable, .-nandc_randomizer_enable
	.section	.text.nandc_get_chip_if,"ax",@progbits
	.align	2
	.global	nandc_get_chip_if
	.type	nandc_get_chip_if, %function
nandc_get_chip_if:
	adrp	x1, .LANCHOR13
	ubfiz	x0, x0, 8, 8
	add	x0, x0, 2048
	ldr	x1, [x1, #:lo12:.LANCHOR13]
	add	x0, x1, x0
	ret
	.size	nandc_get_chip_if, .-nandc_get_chip_if
	.section	.text.buf_reinit,"ax",@progbits
	.align	2
	.global	buf_reinit
	.type	buf_reinit, %function
buf_reinit:
	adrp	x0, .LANCHOR52
	add	x1, x0, :lo12:.LANCHOR52
	mov	w2, 0
.L551:
	and	w3, w2, 255
	strb	wzr, [x1, 2]
	add	w4, w3, 1
	strb	w3, [x1, 1]
	strb	w4, [x1]
	add	w2, w2, 1
	str	xzr, [x1, 16]
	cmp	w2, 32
	add	x1, x1, 64
	bne	.L551
	add	x0, x0, :lo12:.LANCHOR52
	mov	w1, -1
	strb	w1, [x0, 1984]
	adrp	x0, .LANCHOR53
	strb	wzr, [x0, #:lo12:.LANCHOR53]
	adrp	x0, .LANCHOR54
	strb	w2, [x0, #:lo12:.LANCHOR54]
	ret
	.size	buf_reinit, .-buf_reinit
	.section	.text.buf_add_tail,"ax",@progbits
	.align	2
	.global	buf_add_tail
	.type	buf_add_tail, %function
buf_add_tail:
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	str	x21, [sp, 32]
	mov	w0, -1
	strb	w0, [x1]
	mov	x20, x1
	ldrb	w1, [x19]
	cmp	w1, 255
	bne	.L559
	ldrb	w0, [x20, 1]
	cmp	w0, 255
	bne	.L555
	adrp	x1, .LANCHOR55
	adrp	x0, .LC0
	mov	w2, 74
	add	x1, x1, :lo12:.LANCHOR55
	add	x0, x0, :lo12:.LC0
	bl	printf
.L555:
	ldrb	w0, [x20, 1]
	strb	w0, [x19]
.L553:
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L559:
	adrp	x0, .LANCHOR52
	add	x2, x0, :lo12:.LANCHOR52
	mov	x19, x0
.L560:
	sbfiz	x0, x1, 6, 32
	mov	w21, w1
	ldrb	w1, [x2, x0]
	cmp	w1, 255
	bne	.L560
	ldrb	w0, [x20, 1]
	cmp	w0, 255
	bne	.L557
	adrp	x1, .LANCHOR55
	adrp	x0, .LC0
	mov	w2, 81
	add	x1, x1, :lo12:.LANCHOR55
	add	x0, x0, :lo12:.LC0
	bl	printf
.L557:
	add	x0, x19, :lo12:.LANCHOR52
	sbfiz	x21, x21, 6, 32
	ldrb	w1, [x20, 1]
	strb	w1, [x0, x21]
	b	.L553
	.size	buf_add_tail, .-buf_add_tail
	.section	.text.queue_read_cmd,"ax",@progbits
	.align	2
	.type	queue_read_cmd, %function
queue_read_cmd:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	str	x19, [sp, 16]
	mov	x19, x0
	mov	w0, 48
	ldr	w1, [x19, 40]
	bl	flash_start_page_read
	strb	wzr, [x19, 59]
	mov	w0, 1
	strb	w0, [x19, 58]
	mov	w0, -1
	strb	w0, [x19]
	mov	x1, x19
	adrp	x0, .LANCHOR56
	ldr	x19, [sp, 16]
	add	x0, x0, :lo12:.LANCHOR56
	ldp	x29, x30, [sp], 32
	b	buf_add_tail
	.size	queue_read_cmd, .-queue_read_cmd
	.section	.text.zbuf_free,"ax",@progbits
	.align	2
	.global	zbuf_free
	.type	zbuf_free, %function
zbuf_free:
	ldrb	w1, [x0, 2]
	adrp	x2, .LANCHOR53
	and	w1, w1, 8
	strb	w1, [x0, 2]
	cbz	w1, .L565
	ldr	w1, [x0, 36]
	cmn	w1, #1
	beq	.L565
	stp	x29, x30, [sp, -16]!
	mov	x1, x0
	add	x0, x2, :lo12:.LANCHOR53
	add	x29, sp, 0
	bl	buf_add_tail
	adrp	x1, .LANCHOR54
	ldp	x29, x30, [sp], 16
	ldrb	w0, [x1, #:lo12:.LANCHOR54]
	add	w0, w0, 1
	strb	w0, [x1, #:lo12:.LANCHOR54]
	ret
.L565:
	ldrb	w1, [x2, #:lo12:.LANCHOR53]
	strb	w1, [x0]
	adrp	x1, .LANCHOR54
	ldrb	w0, [x0, 1]
	strb	w0, [x2, #:lo12:.LANCHOR53]
	ldrb	w0, [x1, #:lo12:.LANCHOR54]
	add	w0, w0, 1
	strb	w0, [x1, #:lo12:.LANCHOR54]
	ret
	.size	zbuf_free, .-zbuf_free
	.section	.text.buf_alloc,"ax",@progbits
	.align	2
	.global	buf_alloc
	.type	buf_alloc, %function
buf_alloc:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR54
	and	w20, w0, 255
	ldrb	w0, [x19, #:lo12:.LANCHOR54]
	cbz	w0, .L578
.L581:
	adrp	x2, .LANCHOR53
	adrp	x1, .LANCHOR52
	add	x0, x1, :lo12:.LANCHOR52
	ldrb	w3, [x2, #:lo12:.LANCHOR53]
	ubfiz	x4, x3, 6, 8
	add	x0, x0, x4
	mov	x4, x2
	cbz	w20, .L579
.L580:
	add	x1, x1, :lo12:.LANCHOR52
	sbfiz	x3, x3, 6, 32
	add	x2, x1, x3
	ldrb	w5, [x1, x3]
	strb	w5, [x4, #:lo12:.LANCHOR53]
	ldrb	w4, [x19, #:lo12:.LANCHOR54]
	strh	wzr, [x2, 50]
	sub	w4, w4, #1
	strb	w4, [x19, #:lo12:.LANCHOR54]
	mov	w4, 1
	strb	wzr, [x2, 56]
	strb	w4, [x2, 2]
	mov	w4, -1
	strb	wzr, [x2, 57]
	strb	w4, [x1, x3]
	mov	w1, -1
	str	xzr, [x2, 16]
	str	w1, [x2, 36]
	b	.L577
.L578:
	mov	w2, 121
	adrp	x1, .LANCHOR57
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR57
	add	x0, x0, :lo12:.LC0
	bl	printf
	ldrb	w0, [x19, #:lo12:.LANCHOR54]
	cbnz	w0, .L581
.L583:
	mov	x0, 0
.L577:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L579:
	ldrb	w2, [x19, #:lo12:.LANCHOR54]
	cmp	w2, 1
	bne	.L580
	b	.L583
	.size	buf_alloc, .-buf_alloc
	.section	.text.buf_remove_buf,"ax",@progbits
	.align	2
	.global	buf_remove_buf
	.type	buf_remove_buf, %function
buf_remove_buf:
	ldrb	w4, [x1, 1]
	ldrb	w2, [x0]
	cmp	w4, w2
	bne	.L591
	ldrb	w1, [x1]
	strb	w1, [x0]
.L595:
	mov	w0, 1
	ret
.L592:
	mov	w3, w2
	sbfiz	x2, x2, 6, 32
	ldrb	w2, [x0, x2]
	cmp	w4, w2
	bne	.L593
	sbfiz	x3, x3, 6, 32
	ldrb	w2, [x1]
	strb	w2, [x0, x3]
	mov	w0, -1
	strb	w0, [x1]
	b	.L595
.L591:
	adrp	x0, .LANCHOR52
	add	x0, x0, :lo12:.LANCHOR52
.L593:
	cmp	w2, 255
	bne	.L592
	mov	w0, 0
	ret
	.size	buf_remove_buf, .-buf_remove_buf
	.section	.text.buf_remove_free,"ax",@progbits
	.align	2
	.global	buf_remove_free
	.type	buf_remove_free, %function
buf_remove_free:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR54
	mov	x20, x0
	ldrb	w0, [x19, #:lo12:.LANCHOR54]
	cbnz	w0, .L597
	adrp	x1, .LANCHOR58
	adrp	x0, .LC0
	mov	w2, 172
	add	x1, x1, :lo12:.LANCHOR58
	add	x0, x0, :lo12:.LC0
	bl	printf
.L597:
	ldrb	w0, [x19, #:lo12:.LANCHOR54]
	cbz	w0, .L596
	mov	x1, x20
	adrp	x0, .LANCHOR53
	add	x0, x0, :lo12:.LANCHOR53
	bl	buf_remove_buf
	cmp	w0, 1
	bne	.L596
	ldrb	w0, [x19, #:lo12:.LANCHOR54]
	sub	w0, w0, #1
	strb	w0, [x19, #:lo12:.LANCHOR54]
	ldrb	w0, [x20, 2]
	orr	w0, w0, 1
	strb	w0, [x20, 2]
.L596:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	buf_remove_free, .-buf_remove_free
	.section	.text.flash_check_bad_block,"ax",@progbits
	.align	2
	.global	flash_check_bad_block
	.type	flash_check_bad_block, %function
flash_check_bad_block:
	adrp	x3, .LANCHOR32
	add	x3, x3, :lo12:.LANCHOR32
	and	w5, w0, 255
	lsr	w4, w1, 5
	and	w1, w1, 31
	ldrb	w0, [x3, 13]
	ldrh	w2, [x3, 14]
	mul	w2, w2, w0
	mov	x0, 912
	and	w2, w2, 65535
	add	w2, w2, 31
	asr	w2, w2, 5
	lsl	w2, w2, 2
	umaddl	x0, w2, w5, x0
	adrp	x2, .LANCHOR27
	ldr	x2, [x2, #:lo12:.LANCHOR27]
	add	x0, x0, x4, uxtw 2
	ldr	w0, [x2, x0]
	lsr	w0, w0, w1
	and	w0, w0, 1
	ret
	.size	flash_check_bad_block, .-flash_check_bad_block
	.section	.text.flash_mask_bad_block,"ax",@progbits
	.align	2
	.global	flash_mask_bad_block
	.type	flash_mask_bad_block, %function
flash_mask_bad_block:
	stp	x29, x30, [sp, -48]!
	mov	w2, w1
	add	x29, sp, 0
	str	x21, [sp, 32]
	and	w21, w0, 255
	adrp	x0, .LANCHOR32
	add	x0, x0, :lo12:.LANCHOR32
	stp	x19, x20, [sp, 16]
	mov	w20, w1
	ldrh	w19, [x0, 14]
	ldrb	w1, [x0, 13]
	adrp	x0, .LC42
	add	x0, x0, :lo12:.LC42
	mul	w19, w19, w1
	mov	w1, w21
	bl	printf
	and	w19, w19, 65535
	lsr	w0, w20, 5
	add	w1, w19, 31
	mov	x19, 912
	asr	w1, w1, 5
	and	w20, w20, 31
	lsl	w1, w1, 2
	umaddl	x1, w1, w21, x19
	ldr	x21, [sp, 32]
	add	x1, x1, x0, uxtw 2
	adrp	x0, .LANCHOR27
	ldr	x2, [x0, #:lo12:.LANCHOR27]
	mov	w0, 1
	lsl	w0, w0, w20
	ldr	w20, [x2, x1]
	orr	w20, w20, w0
	str	w20, [x2, x1]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
	.size	flash_mask_bad_block, .-flash_mask_bad_block
	.section	.text.ftl_gc_write_buf,"ax",@progbits
	.align	2
	.global	ftl_gc_write_buf
	.type	ftl_gc_write_buf, %function
ftl_gc_write_buf:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
	ldrb	w1, [x0, 2]
	orr	w1, w1, 2
	strb	w1, [x0, 2]
	mov	x1, x0
	adrp	x0, .LANCHOR59
	add	x0, x0, :lo12:.LANCHOR59
	bl	buf_add_tail
	adrp	x1, .LANCHOR60
	ldp	x29, x30, [sp], 16
	ldrb	w0, [x1, #:lo12:.LANCHOR60]
	add	w0, w0, 1
	and	w0, w0, 255
	strb	w0, [x1, #:lo12:.LANCHOR60]
	ret
	.size	ftl_gc_write_buf, .-ftl_gc_write_buf
	.section	.text.zftl_cache_flush,"ax",@progbits
	.align	2
	.global	zftl_cache_flush
	.type	zftl_cache_flush, %function
zftl_cache_flush:
	ret
	.size	zftl_cache_flush, .-zftl_cache_flush
	.section	.text.zftl_get_density,"ax",@progbits
	.align	2
	.global	zftl_get_density
	.type	zftl_get_density, %function
zftl_get_density:
	cbnz	w0, .L609
	adrp	x0, .LANCHOR61
	ldr	w0, [x0, #:lo12:.LANCHOR61]
	ret
.L609:
	cmp	w0, 4
	cset	w0, cc
	lsl	w0, w0, 13
	ret
	.size	zftl_get_density, .-zftl_get_density
	.section	.text.gc_hook,"ax",@progbits
	.align	2
	.global	gc_hook
	.type	gc_hook, %function
gc_hook:
	ret
	.size	gc_hook, .-gc_hook
	.section	.text.vpn_check,"ax",@progbits
	.align	2
	.global	vpn_check
	.type	vpn_check, %function
vpn_check:
	ret
	.size	vpn_check, .-vpn_check
	.section	.text.FtlGetCurEraseBlock,"ax",@progbits
	.align	2
	.global	FtlGetCurEraseBlock
	.type	FtlGetCurEraseBlock, %function
FtlGetCurEraseBlock:
	adrp	x0, .LANCHOR62
	ldrh	w0, [x0, #:lo12:.LANCHOR62]
	ret
	.size	FtlGetCurEraseBlock, .-FtlGetCurEraseBlock
	.section	.text.FtlGetAllBlockNum,"ax",@progbits
	.align	2
	.global	FtlGetAllBlockNum
	.type	FtlGetAllBlockNum, %function
FtlGetAllBlockNum:
	adrp	x0, .LANCHOR6
	ldrh	w0, [x0, #:lo12:.LANCHOR6]
	ret
	.size	FtlGetAllBlockNum, .-FtlGetAllBlockNum
	.section	.text.FtlLowFormat,"ax",@progbits
	.align	2
	.global	FtlLowFormat
	.type	FtlLowFormat, %function
FtlLowFormat:
	mov	w0, 0
	ret
	.size	FtlLowFormat, .-FtlLowFormat
	.section	.text.gc_add_sblk,"ax",@progbits
	.align	2
	.global	gc_add_sblk
	.type	gc_add_sblk, %function
gc_add_sblk:
	stp	x29, x30, [sp, -64]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR14
	stp	x19, x20, [sp, 16]
	and	w19, w0, 65535
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	and	w22, w1, 65535
	stp	x23, x24, [sp, 48]
	and	w23, w2, 65535
	tbz	x0, 8, .L618
	adrp	x1, .LANCHOR9
	uxtw	x0, w19
	mov	w3, w23
	ldr	x2, [x1, #:lo12:.LANCHOR9]
	adrp	x1, .LANCHOR7
	ldr	x1, [x1, #:lo12:.LANCHOR7]
	ldrh	w5, [x2, x0, lsl 1]
	mov	w2, w22
	add	x1, x1, x0, lsl 2
	adrp	x0, .LC43
	add	x0, x0, :lo12:.LC43
	ldrb	w4, [x1, 2]
	adrp	x1, .LANCHOR63
	ldrh	w7, [x1, #:lo12:.LANCHOR63]
	adrp	x1, .LANCHOR64+56
	ubfx	x4, x4, 5, 3
	ldrh	w6, [x1, #:lo12:.LANCHOR64+56]
	mov	w1, w19
	bl	printf
.L618:
	adrp	x0, .LANCHOR6
	mov	x20, x0
	ldrh	w1, [x0, #:lo12:.LANCHOR6]
	cmp	w1, w19
	bhi	.L619
	adrp	x1, .LANCHOR65
	adrp	x0, .LC0
	mov	w2, 454
	add	x1, x1, :lo12:.LANCHOR65
	add	x0, x0, :lo12:.LC0
	bl	printf
.L619:
	ldrh	w0, [x20, #:lo12:.LANCHOR6]
	cmp	w0, w19
	bhi	.L620
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	tbz	x0, 10, .L642
	adrp	x0, .LC44
	mov	w3, w23
	mov	w2, w22
	mov	w1, w19
	add	x0, x0, :lo12:.LC44
	bl	printf
.L642:
	mov	w0, 0
	b	.L617
.L620:
	adrp	x1, .LANCHOR9
	uxtw	x0, w19
	ldr	x1, [x1, #:lo12:.LANCHOR9]
	ldrh	w3, [x1, x0, lsl 1]
	adrp	x1, .LANCHOR7
	ldr	x1, [x1, #:lo12:.LANCHOR7]
	add	x0, x1, x0, lsl 2
	ldrb	w2, [x0, 2]
	tst	w2, 224
	bne	.L622
	cbz	w3, .L642
	mov	w2, 461
	adrp	x1, .LANCHOR65
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR65
	add	x0, x0, :lo12:.LC0
	bl	printf
	b	.L642
.L622:
	adrp	x0, .LANCHOR64
	add	x1, x0, :lo12:.LANCHOR64
	ldrh	w0, [x0, #:lo12:.LANCHOR64]
	cmp	w0, w19
	beq	.L642
	adrp	x24, .LANCHOR10
	ldr	x0, [x24, #:lo12:.LANCHOR10]
	ldrh	w4, [x0, 48]
	cmp	w4, w19
	beq	.L642
	ldrh	w4, [x0, 16]
	cmp	w4, w19
	beq	.L642
	ldrh	w4, [x0, 80]
	cmp	w4, w19
	beq	.L642
	ldrh	w5, [x1, 56]
	add	x1, x1, 58
	mov	w4, 0
.L623:
	cmp	w4, w5
	bcc	.L624
	cbnz	w22, .L628
	adrp	x1, .LANCHOR66
	ldrh	w6, [x1, #:lo12:.LANCHOR66]
	cmp	w19, w6
	beq	.L642
	adrp	x4, .LANCHOR67
	add	x4, x4, :lo12:.LANCHOR67
	mov	x1, 0
.L627:
	ldrh	w7, [x1, x4]
	cmp	w19, w7
	bne	.L626
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L642
	mov	w5, w6
	mov	w4, w19
	ubfx	x2, x2, 5, 3
	mov	w1, w19
	adrp	x0, .LC45
	add	x0, x0, :lo12:.LC45
	bl	printf
	b	.L642
.L624:
	ldrh	w6, [x1], 2
	cmp	w6, w19
	beq	.L642
	add	w4, w4, 1
	b	.L623
.L626:
	add	x1, x1, 2
	cmp	x1, 16
	bne	.L627
	ubfiz	x20, x23, 7, 16
	add	x20, x20, 136
	add	x20, x0, x20
.L629:
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L630
	adrp	x0, .LANCHOR63
	mov	w4, w3
	mov	w1, w19
	ubfx	x3, x2, 5, 3
	ldrh	w6, [x0, #:lo12:.LANCHOR63]
	mov	w2, w22
	adrp	x0, .LC46
	add	x0, x0, :lo12:.LC46
	bl	printf
.L630:
	mov	x0, x20
	add	x1, x20, 128
	mov	w2, 65535
.L633:
	ldrh	w3, [x0]
	cmp	w3, w2
	bne	.L631
	strh	w19, [x0]
	cbz	w22, .L632
	ldr	x1, [x24, #:lo12:.LANCHOR10]
	ldrh	w0, [x1, 124]
	add	w0, w0, 1
	strh	w0, [x1, 124]
.L652:
	mov	w0, 1
.L617:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L628:
	add	x20, x0, 392
	b	.L629
.L632:
	ldr	x0, [x24, #:lo12:.LANCHOR10]
	add	x23, x0, x23, uxth 1
	ldrh	w0, [x23, 120]
	add	w0, w0, 1
	strh	w0, [x23, 120]
	b	.L652
.L631:
	add	x0, x0, 2
	cmp	x1, x0
	bne	.L633
	b	.L652
	.size	gc_add_sblk, .-gc_add_sblk
	.section	.text.gc_mark_bad_ppa,"ax",@progbits
	.align	2
	.global	gc_mark_bad_ppa
	.type	gc_mark_bad_ppa, %function
gc_mark_bad_ppa:
	stp	x29, x30, [sp, -64]!
	adrp	x1, .LANCHOR68
	adrp	x3, .LANCHOR31
	add	x29, sp, 0
	ldrh	w1, [x1, #:lo12:.LANCHOR68]
	ldrb	w3, [x3, #:lo12:.LANCHOR31]
	stp	x19, x20, [sp, 16]
	mov	w19, 24
	sub	w19, w19, w3
	lsr	w2, w0, w1
	sub	w19, w19, w1
	adrp	x1, .LANCHOR69
	str	x23, [sp, 48]
	mov	w23, 1
	ldrb	w1, [x1, #:lo12:.LANCHOR69]
	lsl	w19, w23, w19
	sub	w19, w19, #1
	stp	x21, x22, [sp, 32]
	and	w19, w19, w2
	adrp	x20, .LANCHOR64
	add	x21, x20, :lo12:.LANCHOR64
	mov	w3, w0
	and	w22, w2, 65535
	adrp	x0, .LC47
	udiv	w19, w19, w1
	mov	w2, w22
	ldr	w1, [x21, 584]
	add	x0, x0, :lo12:.LC47
	and	w19, w19, 65535
	bl	printf
	mov	w1, w23
	mov	w2, 0
	mov	w0, w19
	bl	gc_add_sblk
	ldr	w0, [x21, 584]
	mov	w1, 0
.L654:
	cmp	w1, w0
	bcc	.L656
	cmp	w0, 5
	bhi	.L655
	add	x20, x20, :lo12:.LANCHOR64
	add	w1, w0, 1
	str	w1, [x20, 584]
	add	x20, x20, x0, uxtw 1
	strh	w22, [x20, 588]
.L655:
	mov	w0, 0
	ldr	x23, [sp, 48]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L656:
	add	x2, x21, x1, sxtw 1
	ldrh	w2, [x2, 588]
	cmp	w2, w22
	beq	.L655
	add	w1, w1, 1
	and	w1, w1, 65535
	b	.L654
	.size	gc_mark_bad_ppa, .-gc_mark_bad_ppa
	.section	.text.gc_get_src_ppa_from_index,"ax",@progbits
	.align	2
	.global	gc_get_src_ppa_from_index
	.type	gc_get_src_ppa_from_index, %function
gc_get_src_ppa_from_index:
	adrp	x1, .LANCHOR70
	ubfiz	x0, x0, 2, 16
	ldr	x1, [x1, #:lo12:.LANCHOR70]
	ldr	w0, [x1, x0]
	ret
	.size	gc_get_src_ppa_from_index, .-gc_get_src_ppa_from_index
	.section	.text.gc_write_completed,"ax",@progbits
	.align	2
	.global	gc_write_completed
	.type	gc_write_completed, %function
gc_write_completed:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR71
	stp	x21, x22, [sp, 32]
	adrp	x24, .LANCHOR52
	add	x23, x23, :lo12:.LANCHOR71
	add	x22, x24, :lo12:.LANCHOR52
	stp	x19, x20, [sp, 16]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
.L660:
	ldrb	w20, [x23]
	cmp	w20, 255
	bne	.L673
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L673:
	lsl	x1, x20, 6
	add	x0, x24, :lo12:.LANCHOR52
	add	x2, x0, x1
	ldrb	w0, [x0, x1]
	ldr	w1, [x2, 52]
	strb	w0, [x23]
	ldrh	w25, [x2, 48]
	cbz	w1, .L661
	ldr	w2, [x2, 40]
	adrp	x0, .LANCHOR64
	add	x0, x0, :lo12:.LANCHOR64
	mov	w3, 1
	str	w2, [x0, 580]
	strh	w3, [x0, 576]
	adrp	x0, .LC48
	add	x0, x0, :lo12:.LC48
	bl	printf
	adrp	x1, .LANCHOR72
	adrp	x0, .LC0
	mov	w2, 804
	add	x1, x1, :lo12:.LANCHOR72
	add	x0, x0, :lo12:.LC0
	bl	printf
.L661:
	adrp	x27, .LANCHOR73
	ldrb	w0, [x27, #:lo12:.LANCHOR73]
	cmp	w0, 3
	bne	.L662
	adrp	x0, .LANCHOR35
	ldrb	w0, [x0, #:lo12:.LANCHOR35]
	cbnz	w0, .L662
	adrp	x0, .LANCHOR10
	ldr	x0, [x0, #:lo12:.LANCHOR10]
	ldrb	w19, [x0, 89]
	add	w19, w19, w19, lsl 1
	and	w19, w19, 1023
.L663:
	adrp	x0, .LANCHOR14
	adrp	x28, .LANCHOR76
	and	x21, x25, 65535
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L664
	ldr	x1, [x28, #:lo12:.LANCHOR76]
	add	x0, x22, x20, lsl 6
	ldrh	w3, [x0, 48]
	ldrb	w4, [x1, x21]
	mov	w1, w25
	ldrb	w2, [x0, 1]
	adrp	x0, .LC49
	add	x0, x0, :lo12:.LC49
	bl	printf
.L664:
	ldr	x1, [x28, #:lo12:.LANCHOR76]
	add	x0, x22, x20, lsl 6
	mov	x26, x21
	ldrb	w0, [x0, 1]
	ldrb	w1, [x1, x21]
	cmp	w1, w0
	beq	.L665
	adrp	x1, .LANCHOR72
	adrp	x0, .LC0
	mov	w2, 813
	add	x1, x1, :lo12:.LANCHOR72
	add	x0, x0, :lo12:.LC0
	bl	printf
.L665:
	add	x20, x22, x20, lsl 6
	ldrb	w0, [x20, 61]
	cmp	w0, 3
	beq	.L666
	ldrb	w0, [x27, #:lo12:.LANCHOR73]
	cmp	w0, 3
	bne	.L666
	adrp	x0, .LANCHOR77
	ldrb	w0, [x0, #:lo12:.LANCHOR77]
	cbnz	w0, .L666
	adrp	x0, .LANCHOR35
	ldrb	w0, [x0, #:lo12:.LANCHOR35]
	cbnz	w0, .L666
	adrp	x0, .LANCHOR74
	ldrb	w0, [x0, #:lo12:.LANCHOR74]
	cbz	w0, .L667
	adrp	x0, .LANCHOR75
	ldrb	w0, [x0, #:lo12:.LANCHOR75]
	cbnz	w0, .L666
.L667:
	ldr	x1, [x28, #:lo12:.LANCHOR76]
	mov	x0, 0
	add	x21, x1, x21
.L668:
	cmp	w19, w0, uxth
	bls	.L660
	ldrb	w1, [x21, x0]
	add	x0, x0, 1
	add	x1, x22, x1, lsl 6
	strb	wzr, [x1, 61]
	b	.L668
.L662:
	adrp	x0, .LANCHOR74
	ldrb	w0, [x0, #:lo12:.LANCHOR74]
	cbz	w0, .L674
	adrp	x0, .LANCHOR75
	ldrb	w0, [x0, #:lo12:.LANCHOR75]
	cmp	w0, 0
	cset	w19, ne
	add	w19, w19, 1
	b	.L663
.L674:
	mov	w19, 1
	b	.L663
.L666:
	adrp	x20, .LANCHOR64
	add	x20, x20, :lo12:.LANCHOR64
	add	x19, x21, x19, uxth
	mov	w21, -1
	strh	w25, [x20, 572]
.L669:
	cmp	x19, x26
	beq	.L660
	ldr	x1, [x28, #:lo12:.LANCHOR76]
	ldrb	w0, [x1, x26]
	strb	w21, [x1, x26]
	add	x26, x26, 1
	sbfiz	x1, x0, 6, 32
	ubfiz	x0, x0, 6, 8
	add	x1, x22, x1
	add	x0, x22, x0
	strb	wzr, [x1, 61]
	bl	zbuf_free
	ldrb	w0, [x20, 7]
	sub	w0, w0, #1
	strb	w0, [x20, 7]
	b	.L669
	.size	gc_write_completed, .-gc_write_completed
	.section	.text.gc_get_src_blk,"ax",@progbits
	.align	2
	.global	gc_get_src_blk
	.type	gc_get_src_blk, %function
gc_get_src_blk:
	adrp	x0, .LANCHOR10
	ldr	x2, [x0, #:lo12:.LANCHOR10]
	adrp	x0, .LANCHOR78
	ldrb	w3, [x0, #:lo12:.LANCHOR78]
	ldrh	w0, [x2, 124]
	cbz	w0, .L690
	add	x1, x2, 392
	mov	w4, 1
.L691:
	add	x5, x1, 128
	mov	w6, 65535
.L695:
	ldrh	w0, [x1]
	cmp	w0, w6
	beq	.L693
	mov	w5, -1
	strh	w5, [x1]
	cbz	w4, .L694
	ldrh	w1, [x2, 124]
	sub	w1, w1, #1
	strh	w1, [x2, 124]
	ret
.L690:
	add	x0, x2, x3, sxtw 1
	ldrh	w0, [x0, 120]
	cbz	w0, .L696
	ubfiz	x1, x3, 7, 8
	mov	w4, 0
	add	x1, x1, 136
	add	x1, x2, x1
	b	.L691
.L694:
	add	x2, x2, x3, uxtb 1
	ldrh	w1, [x2, 120]
	sub	w1, w1, #1
	strh	w1, [x2, 120]
	ret
.L693:
	add	x1, x1, 2
	cmp	x1, x5
	bne	.L695
	ret
.L696:
	mov	w0, 65535
	ret
	.size	gc_get_src_blk, .-gc_get_src_blk
	.section	.text.gc_free_temp_buf,"ax",@progbits
	.align	2
	.global	gc_free_temp_buf
	.type	gc_free_temp_buf, %function
gc_free_temp_buf:
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR64
	add	x0, x20, :lo12:.LANCHOR64
	stp	x21, x22, [sp, 32]
	ldrb	w1, [x0, 7]
	cbz	w1, .L705
	adrp	x1, .LANCHOR54
	ldrb	w1, [x1, #:lo12:.LANCHOR54]
	cmp	w1, 1
	bhi	.L705
	ldrh	w19, [x0, 572]
	adrp	x2, .LANCHOR80
	adrp	x0, .LANCHOR79
	adrp	x21, .LANCHOR76
	ldrb	w2, [x2, #:lo12:.LANCHOR80]
	add	w1, w19, 24
	ldrh	w0, [x0, #:lo12:.LANCHOR79]
	ldr	x4, [x21, #:lo12:.LANCHOR76]
	mul	w0, w0, w2
	cmp	w0, w1
	csel	w1, w0, w1, ls
	adrp	x0, .LANCHOR52
	add	x0, x0, :lo12:.LANCHOR52
.L700:
	cmp	w19, w1
	bcc	.L703
.L705:
	mov	w0, 0
	b	.L698
.L703:
	uxtw	x22, w19
	ldrb	w2, [x4, x22]
	cmp	w2, 255
	beq	.L701
	sbfiz	x3, x2, 6, 32
	add	x3, x0, x3
	ldrb	w3, [x3, 61]
	cbnz	w3, .L701
	ubfiz	x2, x2, 6, 8
	add	x0, x0, x2
	bl	zbuf_free
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L702
	ldr	x0, [x21, #:lo12:.LANCHOR76]
	mov	w1, w19
	ldrb	w2, [x0, x22]
	adrp	x0, .LC50
	add	x0, x0, :lo12:.LC50
	bl	printf
.L702:
	ldr	x0, [x21, #:lo12:.LANCHOR76]
	add	x20, x20, :lo12:.LANCHOR64
	mov	w1, -1
	strb	w1, [x0, x22]
	ldrb	w0, [x20, 7]
	sub	w0, w0, #1
	strb	w0, [x20, 7]
	mov	w0, 1
.L698:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L701:
	add	w19, w19, 1
	b	.L700
	.size	gc_free_temp_buf, .-gc_free_temp_buf
	.section	.text.print_gc_debug_info,"ax",@progbits
	.align	2
	.global	print_gc_debug_info
	.type	print_gc_debug_info, %function
print_gc_debug_info:
	adrp	x2, .LANCHOR81
	adrp	x1, .LANCHOR64
	add	x0, x1, :lo12:.LANCHOR64
	ldrh	w6, [x2, #:lo12:.LANCHOR81]
	adrp	x2, .LANCHOR54
	ldrh	w1, [x1, #:lo12:.LANCHOR64]
	ldrb	w5, [x0, 7]
	ldrb	w4, [x2, #:lo12:.LANCHOR54]
	ldrh	w3, [x0, 570]
	ldrh	w2, [x0, 2]
	adrp	x0, .LC51
	add	x0, x0, :lo12:.LC51
	b	printf
	.size	print_gc_debug_info, .-print_gc_debug_info
	.section	.text.zftl_get_gc_node,"ax",@progbits
	.align	2
	.global	zftl_get_gc_node
	.type	zftl_get_gc_node, %function
zftl_get_gc_node:
	and	w1, w1, 65535
	and	w0, w0, 65535
	cmp	w1, 5
	bne	.L715
	mov	w1, w0
	adrp	x0, .LANCHOR82
	ldr	x0, [x0, #:lo12:.LANCHOR82]
.L717:
	b	_list_get_gc_head_node.isra.2
.L715:
	cmp	w1, 2
	bne	.L716
	b	zftl_get_gc_node.part.9
.L716:
	mov	w1, w0
	adrp	x0, .LANCHOR83
	ldr	x0, [x0, #:lo12:.LANCHOR83]
	b	.L717
	.size	zftl_get_gc_node, .-zftl_get_gc_node
	.section	.text.gc_search_src_blk,"ax",@progbits
	.align	2
	.global	gc_search_src_blk
	.type	gc_search_src_blk, %function
gc_search_src_blk:
	stp	x29, x30, [sp, -128]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	and	w21, w0, 255
	and	w0, w1, 255
	stp	x19, x20, [sp, 16]
	str	w0, [x29, 112]
	adrp	x0, .LANCHOR10
	stp	x23, x24, [sp, 48]
	ldr	x0, [x0, #:lo12:.LANCHOR10]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	add	x0, x0, x21, sxtw 1
	ldrh	w19, [x0, 120]
	cbz	w19, .L719
	mov	w0, w19
.L718:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L719:
	and	w20, w2, 255
	cbnz	w21, .L721
	adrp	x24, .LANCHOR84
	adrp	x26, .LANCHOR14
	adrp	x27, .LC52
	and	w22, w20, 65535
	add	x26, x26, :lo12:.LANCHOR14
	add	x27, x27, :lo12:.LC52
	strh	wzr, [x24, #:lo12:.LANCHOR84]
	mov	w23, 0
	mov	w25, 0
.L722:
	cmp	w25, w22
	bcs	.L727
	ldrh	w6, [x24, #:lo12:.LANCHOR84]
	add	x7, x24, :lo12:.LANCHOR84
	mov	w1, 3
	mov	w0, w6
	bl	zftl_get_gc_node
	add	w2, w6, 1
	and	w2, w2, 65535
	strh	w2, [x24, #:lo12:.LANCHOR84]
	and	w1, w0, 65535
	mov	w0, 65535
	mov	w28, w1
	cmp	w1, w0
	beq	.L723
	ldr	w0, [x26]
	adrp	x6, .LANCHOR9
	uxtw	x4, w1
	tbz	x0, 8, .L724
	ldr	x0, [x6, #:lo12:.LANCHOR9]
	stp	x6, x4, [x29, 96]
	ldrh	w3, [x0, x4, lsl 1]
	mov	x0, x27
	bl	printf
	ldp	x6, x4, [x29, 96]
.L724:
	ldr	x0, [x6, #:lo12:.LANCHOR9]
	ldrh	w1, [x0, x4, lsl 1]
	adrp	x0, .LANCHOR63
	ldrh	w0, [x0, #:lo12:.LANCHOR63]
	cmp	w1, w0
	bcs	.L725
	mov	w2, 0
	mov	w1, 0
	mov	w0, w28
	bl	gc_add_sblk
	cbz	w0, .L726
	add	w5, w23, 1
	and	w23, w5, 65535
	cmp	w22, w23
	bcs	.L726
.L727:
	ldr	x0, [x29, 112]
	tbz	x0, 1, .L729
	adrp	x25, .LANCHOR86
	adrp	x24, .LANCHOR85
	add	x27, x25, :lo12:.LANCHOR86
	add	x24, x24, :lo12:.LANCHOR85
	mov	w28, 0
	mov	w26, 65535
.L730:
	cmp	w28, w22
	beq	.L734
	ldrh	w6, [x24]
	mov	w1, 5
	mov	w0, w6
	bl	zftl_get_gc_node
	add	w6, w6, 1
	strh	w6, [x24]
	and	w1, w0, 65535
	cmp	w1, w26
	beq	.L731
	adrp	x2, .LANCHOR9
	ubfiz	x1, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR9]
	ldrh	w2, [x2, x1]
	ldrh	w1, [x27]
	cmp	w2, w1
	bcs	.L731
	mov	w2, 0
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L733
	add	w5, w23, 1
	and	w23, w5, 65535
	cmp	w22, w23
	bcs	.L733
.L734:
	cmp	w23, w22
	adrp	x0, .LANCHOR87
	bcs	.L736
	ldrh	w1, [x0, #:lo12:.LANCHOR87]
	adrp	x3, .LANCHOR80
	adrp	x0, .LANCHOR79
	ldrh	w2, [x25, #:lo12:.LANCHOR86]
	ldrb	w3, [x3, #:lo12:.LANCHOR80]
	ldrh	w0, [x0, #:lo12:.LANCHOR79]
	mul	w0, w0, w3
	sub	w0, w0, w1, lsr 2
	cmp	w2, w0
	bge	.L729
	add	w1, w2, w1, lsr 3
	strh	w1, [x25, #:lo12:.LANCHOR86]
.L729:
	ldr	x0, [x29, 112]
	tbz	x0, 0, .L737
	cmp	w23, w22
	bcs	.L737
	adrp	x24, .LANCHOR88
	add	x24, x24, :lo12:.LANCHOR88
	mov	w25, 65535
.L742:
	ldrh	w6, [x24]
	mov	w0, w6
	bl	zftl_get_gc_node.part.9
	add	w6, w6, 1
	strh	w6, [x24]
	cmp	w25, w0, uxth
	beq	.L738
	mov	w2, 0
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L739
	add	w5, w23, 1
	and	w23, w5, 65535
	cmp	w22, w23
	bhi	.L739
.L740:
	adrp	x0, .LANCHOR87
	adrp	x1, .LANCHOR63
	ldrh	w0, [x0, #:lo12:.LANCHOR87]
	ldrh	w2, [x1, #:lo12:.LANCHOR63]
	cmp	w2, w0, lsr 1
	bls	.L737
	sub	w0, w2, w0, lsr 3
	b	.L817
.L725:
	strh	wzr, [x24, #:lo12:.LANCHOR84]
	b	.L727
.L723:
	strh	wzr, [x7]
	b	.L727
.L726:
	add	w25, w25, 1
	and	w25, w25, 65535
	b	.L722
.L731:
	strh	wzr, [x24]
	b	.L734
.L733:
	add	w28, w28, 1
	and	w28, w28, 65535
	b	.L730
.L736:
	ldrh	w1, [x25, #:lo12:.LANCHOR86]
	ldrh	w0, [x0, #:lo12:.LANCHOR87]
	cmp	w1, w0
	bls	.L729
	sub	w0, w1, w0, lsr 3
	strh	w0, [x25, #:lo12:.LANCHOR86]
	b	.L729
.L738:
	strh	wzr, [x24]
.L741:
	cmp	w23, w22
	bcs	.L740
	adrp	x1, .LANCHOR63
	adrp	x0, .LANCHOR87
	ldrh	w2, [x1, #:lo12:.LANCHOR63]
	ldrh	w0, [x0, #:lo12:.LANCHOR87]
	cmp	w2, w0
	bcs	.L737
	add	w0, w2, w0, lsr 3
.L817:
	strh	w0, [x1, #:lo12:.LANCHOR63]
.L737:
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L764
	ldr	w2, [x29, 112]
	adrp	x0, .LC53
	mov	w4, w20
	mov	w3, w23
	mov	w1, w21
	add	x0, x0, :lo12:.LC53
	bl	printf
.L764:
	mov	w0, w23
	b	.L718
.L739:
	add	w19, w19, 1
	and	w19, w19, 65535
	cmp	w22, w19
	bne	.L742
	b	.L741
.L721:
	adrp	x0, .LANCHOR64+574
	strh	wzr, [x0, #:lo12:.LANCHOR64+574]
	adrp	x0, .LANCHOR89
	strh	wzr, [x0, #:lo12:.LANCHOR89]
	ldr	w0, [x29, 112]
	and	w0, w0, 1
	str	w0, [x29, 104]
	ldr	x0, [x29, 112]
	tbz	x0, 0, .L767
	adrp	x1, .LANCHOR91
	adrp	x25, .LANCHOR90
	str	x1, [x29, 96]
	adrp	x26, .LANCHOR92
	ldrh	w0, [x25, #:lo12:.LANCHOR90]
	ldrh	w2, [x1, #:lo12:.LANCHOR91]
	cmp	w0, w2, lsr 2
	bcc	.L744
	ldrh	w1, [x26, #:lo12:.LANCHOR92]
	cmp	w1, w0
	bls	.L768
.L744:
	ldrh	w0, [x26, #:lo12:.LANCHOR92]
	adrp	x22, .LANCHOR88
	lsr	w0, w0, 2
	strh	w0, [x22, #:lo12:.LANCHOR88]
	mov	w0, 0
	bl	zftl_get_gc_node.part.9
	and	w1, w0, 65535
	mov	w2, 65535
	cmp	w1, w2
	beq	.L770
	adrp	x2, .LANCHOR9
	ubfiz	x1, x1, 1, 16
	ldr	x3, [x2, #:lo12:.LANCHOR9]
	adrp	x2, .LANCHOR87
	ldrh	w2, [x2, #:lo12:.LANCHOR87]
	ldrh	w1, [x3, x1]
	cmp	w1, w2, lsr 2
	bcs	.L770
	strh	wzr, [x22, #:lo12:.LANCHOR88]
	mov	w2, w21
	mov	w1, 0
	bl	gc_add_sblk
	cmp	w0, 0
	cset	w23, ne
.L746:
	add	x22, x22, :lo12:.LANCHOR88
	and	w28, w20, 65535
	mov	w24, 64
	mov	w27, 65535
.L748:
	ldrh	w6, [x22]
	mov	w0, w6
	bl	zftl_get_gc_node.part.9
	add	w6, w6, 1
	strh	w6, [x22]
	cmp	w27, w0, uxth
	beq	.L745
	mov	w2, w21
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L747
	add	w5, w23, 1
	and	w23, w5, 65535
	cmp	w23, w28
	bcs	.L745
.L747:
	sub	w24, w24, #1
	ands	w24, w24, 65535
	bne	.L748
.L745:
	ldr	x0, [x29, 96]
	ldrh	w1, [x25, #:lo12:.LANCHOR90]
	ldrh	w0, [x0, #:lo12:.LANCHOR91]
	cmp	w1, w0, lsr 3
	bhi	.L765
	ldrh	w0, [x26, #:lo12:.LANCHOR92]
	add	w0, w0, 8
	cmp	w1, w0
	ble	.L743
.L765:
	adrp	x24, .LANCHOR84
	and	w26, w20, 65535
	mov	w22, 64
	mov	w25, 65535
	strh	wzr, [x24, #:lo12:.LANCHOR84]
	add	x24, x24, :lo12:.LANCHOR84
.L750:
	ldrh	w6, [x24]
	mov	w1, 3
	mov	w0, w6
	bl	zftl_get_gc_node
	add	w6, w6, 1
	strh	w6, [x24]
	cmp	w25, w0, uxth
	beq	.L743
	mov	w2, w21
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L749
	add	w5, w23, 1
	and	w23, w5, 65535
	cmp	w23, w26
	bcs	.L743
.L749:
	sub	w22, w22, #1
	ands	w22, w22, 65535
	bne	.L750
.L743:
	ldr	x0, [x29, 112]
	tbz	x0, 1, .L751
	adrp	x24, .LANCHOR85
	adrp	x28, .LANCHOR93
	adrp	x25, .LANCHOR80
	add	x26, x24, :lo12:.LANCHOR85
	add	x27, x28, :lo12:.LANCHOR93
	add	x25, x25, :lo12:.LANCHOR80
	strh	wzr, [x24, #:lo12:.LANCHOR85]
	mov	w22, 64
.L756:
	ldrh	w6, [x26]
	mov	w1, 5
	mov	w0, w6
	bl	zftl_get_gc_node
	add	w6, w6, 1
	strh	w6, [x26]
	and	w1, w0, 65535
	mov	w2, 65535
	cmp	w1, w2
	beq	.L752
	cmp	w20, 1
	bne	.L753
	adrp	x3, .LANCHOR79
	ldrb	w2, [x25]
	ldrh	w3, [x3, #:lo12:.LANCHOR79]
	mul	w3, w2, w3
	adrp	x2, .LANCHOR87
	ldrh	w2, [x2, #:lo12:.LANCHOR87]
	sub	w2, w3, w2, lsr 3
	strh	w2, [x27]
.L753:
	adrp	x2, .LANCHOR9
	ubfiz	x1, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR9]
	ldrh	w2, [x2, x1]
	ldrh	w1, [x27]
	cmp	w2, w1
	bcs	.L754
	mov	w2, w21
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L755
	add	w5, w23, 1
	add	w19, w19, 1
	and	w23, w5, 65535
	and	w19, w19, 65535
	cmp	w23, w20
	bcc	.L755
.L752:
	cmp	w23, w20
	adrp	x0, .LANCHOR87
	adrp	x3, .LANCHOR80
	bcc	.L757
	cbnz	w19, .L758
	adrp	x1, .LANCHOR94
	ldrh	w2, [x1, #:lo12:.LANCHOR94]
	adrp	x1, .LANCHOR95
	ldrh	w1, [x1, #:lo12:.LANCHOR95]
	cmp	w2, w1
	bls	.L758
.L757:
	ldrh	w2, [x0, #:lo12:.LANCHOR87]
	adrp	x0, .LANCHOR79
	ldrb	w3, [x3, #:lo12:.LANCHOR80]
	ldrh	w0, [x0, #:lo12:.LANCHOR79]
	ldrh	w1, [x28, #:lo12:.LANCHOR93]
	lsr	w2, w2, 3
	mul	w0, w0, w3
	sub	w0, w0, w2
	cmp	w1, w0
	bge	.L751
	add	w1, w1, w2
	strh	w1, [x28, #:lo12:.LANCHOR93]
.L751:
	ldr	w0, [x29, 104]
	cbz	w0, .L737
	adrp	x25, .LANCHOR84
	adrp	x22, .LANCHOR96
	adrp	x26, .LANCHOR91
	adrp	x27, .LANCHOR90
	add	x28, x22, :lo12:.LANCHOR96
	add	x26, x26, :lo12:.LANCHOR91
	add	x27, x27, :lo12:.LANCHOR90
	strh	wzr, [x25, #:lo12:.LANCHOR84]
	mov	w24, 64
.L762:
	ldrh	w6, [x25, #:lo12:.LANCHOR84]
	mov	w1, 3
	mov	w0, w6
	bl	zftl_get_gc_node
	add	w6, w6, 1
	strh	w6, [x25, #:lo12:.LANCHOR84]
	and	w1, w0, 65535
	mov	w2, 65535
	cmp	w1, w2
	beq	.L759
	adrp	x2, .LANCHOR9
	ubfiz	x1, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR9]
	ldrh	w1, [x2, x1]
	ldrh	w2, [x28]
	cmp	w2, w1
	bls	.L760
	cmp	w1, 2
	bls	.L760
	ldrh	w2, [x26]
	ldrh	w1, [x27]
	cmp	w1, w2, lsr 1
	bls	.L759
.L760:
	mov	w2, w21
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L761
	add	w5, w23, 1
	and	w23, w5, 65535
	cmp	w23, w20
	bcs	.L759
.L761:
	sub	w24, w24, #1
	ands	w24, w24, 65535
	bne	.L762
.L759:
	cmp	w23, w20
	adrp	x0, .LANCHOR87
	bcs	.L763
	ldrh	w0, [x0, #:lo12:.LANCHOR87]
	ldrh	w1, [x22, #:lo12:.LANCHOR96]
	cmp	w1, w0, lsr 1
	bls	.L737
	sub	w0, w1, w0, lsr 3
	strh	w0, [x22, #:lo12:.LANCHOR96]
	b	.L737
.L770:
	mov	w23, 0
	b	.L746
.L767:
	mov	w23, 0
	b	.L743
.L754:
	strh	wzr, [x24, #:lo12:.LANCHOR85]
	b	.L752
.L755:
	sub	w22, w22, #1
	ands	w22, w22, 65535
	bne	.L756
	b	.L752
.L758:
	ldrh	w0, [x0, #:lo12:.LANCHOR87]
	ldrb	w1, [x3, #:lo12:.LANCHOR80]
	ldrh	w2, [x28, #:lo12:.LANCHOR93]
	mul	w1, w1, w0
	cmp	w2, w1
	ble	.L751
	sub	w0, w2, w0, lsr 3
	strh	w0, [x28, #:lo12:.LANCHOR93]
	b	.L751
.L763:
	ldrh	w1, [x0, #:lo12:.LANCHOR87]
	adrp	x0, .LANCHOR80
	ldrh	w2, [x22, #:lo12:.LANCHOR96]
	ldrb	w0, [x0, #:lo12:.LANCHOR80]
	mul	w0, w0, w1
	sub	w0, w0, #32
	cmp	w2, w0
	bge	.L737
	add	w1, w2, w1, lsr 3
	strh	w1, [x22, #:lo12:.LANCHOR96]
	b	.L737
.L768:
	mov	w23, 0
	b	.L745
	.size	gc_search_src_blk, .-gc_search_src_blk
	.section	.text.zftl_insert_free_list,"ax",@progbits
	.align	2
	.global	zftl_insert_free_list
	.type	zftl_insert_free_list, %function
zftl_insert_free_list:
	and	w1, w0, 65535
	adrp	x0, .LANCHOR7
	ldr	x0, [x0, #:lo12:.LANCHOR7]
	add	x0, x0, x1, uxth 2
	ldrb	w0, [x0, 2]
	ands	w0, w0, 24
	bne	.L819
	adrp	x2, .LANCHOR97
	adrp	x0, .LANCHOR98
	add	x2, x2, :lo12:.LANCHOR97
	add	x0, x0, :lo12:.LANCHOR98
.L821:
	b	_insert_free_list
.L819:
	cmp	w0, 16
	bne	.L820
	adrp	x2, .LANCHOR99
	adrp	x0, .LANCHOR100
	add	x2, x2, :lo12:.LANCHOR99
	add	x0, x0, :lo12:.LANCHOR100
	b	.L821
.L820:
	adrp	x2, .LANCHOR101
	adrp	x0, .LANCHOR102
	add	x2, x2, :lo12:.LANCHOR101
	add	x0, x0, :lo12:.LANCHOR102
	b	.L821
	.size	zftl_insert_free_list, .-zftl_insert_free_list
	.section	.text.zftl_insert_data_list,"ax",@progbits
	.align	2
	.global	zftl_insert_data_list
	.type	zftl_insert_data_list, %function
zftl_insert_data_list:
	and	w1, w0, 65535
	adrp	x0, .LANCHOR7
	ldr	x0, [x0, #:lo12:.LANCHOR7]
	add	x0, x0, x1, uxth 2
	ldrb	w2, [x0, 2]
	and	w2, w2, 224
	cmp	w2, 64
	bne	.L823
	adrp	x2, .LANCHOR92
	adrp	x0, .LANCHOR12
	add	x2, x2, :lo12:.LANCHOR92
	add	x0, x0, :lo12:.LANCHOR12
.L826:
	b	_insert_data_list
.L823:
	cmp	w2, 96
	bne	.L824
	adrp	x2, .LANCHOR90
	adrp	x0, .LANCHOR83
	add	x2, x2, :lo12:.LANCHOR90
	add	x0, x0, :lo12:.LANCHOR83
	b	.L826
.L824:
	cmp	w2, 160
	bne	.L822
	adrp	x2, .LANCHOR94
	adrp	x0, .LANCHOR82
	add	x2, x2, :lo12:.LANCHOR94
	add	x0, x0, :lo12:.LANCHOR82
	b	.L826
.L822:
	ret
	.size	zftl_insert_data_list, .-zftl_insert_data_list
	.section	.text.zftl_gc_get_free_sblk,"ax",@progbits
	.align	2
	.global	zftl_gc_get_free_sblk
	.type	zftl_gc_get_free_sblk, %function
zftl_gc_get_free_sblk:
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR10
	stp	x21, x22, [sp, 32]
	and	w21, w0, 65535
	ldr	x0, [x20, #:lo12:.LANCHOR10]
	and	w22, w1, 65535
	ldrh	w19, [x0, 588]
	mov	w0, 65535
	cmp	w19, w0
	beq	.L828
	cbnz	w21, .L828
	mov	w1, w19
	adrp	x0, .LC54
	add	x0, x0, :lo12:.LC54
	bl	printf
	ldr	x0, [x20, #:lo12:.LANCHOR10]
	mov	w1, -1
	strh	w1, [x0, 588]
.L829:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L828:
	adrp	x2, .LANCHOR99
	adrp	x20, .LANCHOR101
	ldrh	w0, [x2, #:lo12:.LANCHOR99]
	ldrh	w1, [x20, #:lo12:.LANCHOR101]
	cmp	w0, w1
	bls	.L830
	lsr	w1, w0, 3
	cmp	w21, 0
	adrp	x0, .LANCHOR100
	csel	w1, w1, wzr, ne
	add	x2, x2, :lo12:.LANCHOR99
	add	x0, x0, :lo12:.LANCHOR100
.L844:
	bl	_list_pop_index_node
	and	w19, w0, 65535
	mov	w0, 65535
	cmp	w19, w0
	bne	.L835
	adrp	x0, .LANCHOR97
	ldrh	w5, [x20, #:lo12:.LANCHOR101]
	mov	w2, w22
	mov	w1, w19
	ldrh	w4, [x0, #:lo12:.LANCHOR97]
	adrp	x0, .LANCHOR98
	ldr	x3, [x0, #:lo12:.LANCHOR98]
	adrp	x0, .LC55
	add	x0, x0, :lo12:.LC55
	bl	printf
.L835:
	cbz	w21, .L829
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L829
	adrp	x4, .LANCHOR9
	adrp	x1, .LANCHOR7
	uxtw	x3, w19
	ldr	x1, [x1, #:lo12:.LANCHOR7]
	lsl	x0, x3, 2
	ldr	x6, [x4, #:lo12:.LANCHOR9]
	add	x2, x1, x0
	ldr	w4, [x1, x0]
	ldrh	w6, [x6, x3, lsl 1]
	ldrb	w2, [x2, 2]
	ldrh	w5, [x1, x0]
	ubfx	x4, x4, 11, 8
	mov	w1, w19
	adrp	x0, .LC56
	ubfx	x3, x2, 3, 2
	and	w5, w5, 2047
	ubfx	x2, x2, 5, 3
	add	x0, x0, :lo12:.LC56
	bl	printf
	b	.L829
.L830:
	cbnz	w21, .L833
	lsr	w1, w1, 2
.L834:
	adrp	x0, .LANCHOR102
	add	x2, x20, :lo12:.LANCHOR101
	add	x0, x0, :lo12:.LANCHOR102
	b	.L844
.L833:
	mov	w1, 7
	mul	w1, w0, w1
	lsr	w1, w1, 3
	b	.L834
	.size	zftl_gc_get_free_sblk, .-zftl_gc_get_free_sblk
	.section	.text.zftl_get_free_sblk,"ax",@progbits
	.align	2
	.global	zftl_get_free_sblk
	.type	zftl_get_free_sblk, %function
zftl_get_free_sblk:
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w20, w1, 65535
	str	x21, [sp, 32]
	cmp	w20, 5
	bne	.L846
	adrp	x2, .LANCHOR99
	adrp	x0, .LANCHOR101
	ldrh	w3, [x2, #:lo12:.LANCHOR99]
	ldrh	w1, [x0, #:lo12:.LANCHOR101]
	cmp	w3, w1
	bcc	.L847
	adrp	x4, .LANCHOR97
	ldrh	w4, [x4, #:lo12:.LANCHOR97]
	cmp	w4, w3
	bls	.L848
	cbz	w1, .L848
.L847:
	add	x2, x0, :lo12:.LANCHOR101
	lsr	w1, w1, 1
.L867:
	adrp	x0, .LANCHOR102
	add	x0, x0, :lo12:.LANCHOR102
	b	.L866
.L848:
	adrp	x0, .LANCHOR100
	add	x2, x2, :lo12:.LANCHOR99
	add	x0, x0, :lo12:.LANCHOR100
	mov	w1, 0
.L866:
	bl	_list_pop_index_node
	and	w19, w0, 65535
	mov	w0, 65535
	cmp	w19, w0
	bne	.L851
	adrp	x0, .LANCHOR101
	mov	w2, w20
	mov	w1, w19
	ldrh	w5, [x0, #:lo12:.LANCHOR101]
	adrp	x0, .LANCHOR97
	ldrh	w4, [x0, #:lo12:.LANCHOR97]
	adrp	x0, .LANCHOR98
	ldr	x3, [x0, #:lo12:.LANCHOR98]
	adrp	x0, .LC55
	add	x0, x0, :lo12:.LC55
	bl	printf
	b	.L851
.L846:
	adrp	x21, .LANCHOR10
	and	w0, w0, 65535
	ldr	x1, [x21, #:lo12:.LANCHOR10]
	ldrh	w19, [x1, 590]
	mov	w1, 65535
	cmp	w19, w1
	beq	.L850
	cmp	w20, 1
	beq	.L850
	mov	w1, w19
	adrp	x0, .LC57
	add	x0, x0, :lo12:.LC57
	bl	printf
	ldr	x0, [x21, #:lo12:.LANCHOR10]
	mov	w1, -1
	strh	w1, [x0, 590]
.L851:
	mov	w0, w19
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L850:
	adrp	x2, .LANCHOR97
	adrp	x4, .LANCHOR101
	ldrh	w1, [x2, #:lo12:.LANCHOR97]
	ldrh	w3, [x4, #:lo12:.LANCHOR101]
	cmp	w1, w3
	bcc	.L852
	adrp	x5, .LANCHOR99
	ldrh	w5, [x5, #:lo12:.LANCHOR99]
	cmp	w5, w1
	bls	.L853
	cbz	w3, .L853
.L852:
	cmp	w20, 1
	lsr	w3, w3, 1
	csel	w0, w3, w0, eq
	add	x2, x4, :lo12:.LANCHOR101
	mov	w1, w0
	b	.L867
.L853:
	lsr	w1, w1, 1
	cmp	w20, 1
	csel	w0, w1, w0, eq
	add	x2, x2, :lo12:.LANCHOR97
	mov	w1, w0
	adrp	x0, .LANCHOR98
	add	x0, x0, :lo12:.LANCHOR98
	b	.L866
	.size	zftl_get_free_sblk, .-zftl_get_free_sblk
	.section	.text.zftl_remove_data_node,"ax",@progbits
	.align	2
	.global	zftl_remove_data_node
	.type	zftl_remove_data_node, %function
zftl_remove_data_node:
	and	w1, w0, 65535
	adrp	x0, .LANCHOR7
	ldr	x0, [x0, #:lo12:.LANCHOR7]
	add	x0, x0, x1, uxth 2
	ldrb	w2, [x0, 2]
	and	w2, w2, 224
	cmp	w2, 64
	bne	.L869
	adrp	x2, .LANCHOR92
	adrp	x0, .LANCHOR12
	add	x2, x2, :lo12:.LANCHOR92
	add	x0, x0, :lo12:.LANCHOR12
.L872:
	b	_list_remove_node
.L869:
	cmp	w2, 96
	bne	.L870
	adrp	x2, .LANCHOR90
	adrp	x0, .LANCHOR83
	add	x2, x2, :lo12:.LANCHOR90
	add	x0, x0, :lo12:.LANCHOR83
	b	.L872
.L870:
	cmp	w2, 160
	bne	.L868
	adrp	x2, .LANCHOR94
	adrp	x0, .LANCHOR82
	add	x2, x2, :lo12:.LANCHOR94
	add	x0, x0, :lo12:.LANCHOR82
	b	.L872
.L868:
	ret
	.size	zftl_remove_data_node, .-zftl_remove_data_node
	.section	.text.zftl_remove_free_node,"ax",@progbits
	.align	2
	.global	zftl_remove_free_node
	.type	zftl_remove_free_node, %function
zftl_remove_free_node:
	and	w1, w0, 65535
	adrp	x0, .LANCHOR7
	ldr	x0, [x0, #:lo12:.LANCHOR7]
	add	x0, x0, x1, uxth 2
	ldrb	w0, [x0, 2]
	ands	w0, w0, 24
	bne	.L874
	adrp	x2, .LANCHOR97
	adrp	x0, .LANCHOR98
	add	x2, x2, :lo12:.LANCHOR97
	add	x0, x0, :lo12:.LANCHOR98
.L876:
	b	_list_remove_node
.L874:
	cmp	w0, 16
	bne	.L875
	adrp	x2, .LANCHOR99
	adrp	x0, .LANCHOR100
	add	x2, x2, :lo12:.LANCHOR99
	add	x0, x0, :lo12:.LANCHOR100
	b	.L876
.L875:
	adrp	x2, .LANCHOR101
	adrp	x0, .LANCHOR102
	add	x2, x2, :lo12:.LANCHOR101
	add	x0, x0, :lo12:.LANCHOR102
	b	.L876
	.size	zftl_remove_free_node, .-zftl_remove_free_node
	.section	.text.zftl_list_update_data_list,"ax",@progbits
	.align	2
	.global	zftl_list_update_data_list
	.type	zftl_list_update_data_list, %function
zftl_list_update_data_list:
	and	w1, w0, 65535
	adrp	x0, .LANCHOR7
	ldr	x0, [x0, #:lo12:.LANCHOR7]
	add	x0, x0, x1, uxth 2
	ldrb	w2, [x0, 2]
	and	w2, w2, 224
	cmp	w2, 64
	bne	.L878
	adrp	x2, .LANCHOR92
	adrp	x0, .LANCHOR12
	add	x2, x2, :lo12:.LANCHOR92
	add	x0, x0, :lo12:.LANCHOR12
.L881:
	b	_list_update_data_list
.L878:
	cmp	w2, 96
	bne	.L879
	adrp	x2, .LANCHOR90
	adrp	x0, .LANCHOR83
	add	x2, x2, :lo12:.LANCHOR90
	add	x0, x0, :lo12:.LANCHOR83
	b	.L881
.L879:
	cmp	w2, 160
	bne	.L877
	adrp	x2, .LANCHOR94
	adrp	x0, .LANCHOR82
	add	x2, x2, :lo12:.LANCHOR94
	add	x0, x0, :lo12:.LANCHOR82
	b	.L881
.L877:
	ret
	.size	zftl_list_update_data_list, .-zftl_list_update_data_list
	.section	.text.print_list_info,"ax",@progbits
	.align	2
	.global	print_list_info
	.type	print_list_info, %function
print_list_info:
	sub	sp, sp, #96
	stp	x29, x30, [sp, 32]
	add	x29, sp, 32
	ldrh	w2, [x1]
	ldr	x1, [x0]
	stp	x19, x20, [sp, 48]
	mov	x19, x0
	stp	x21, x22, [sp, 64]
	adrp	x0, .LC58
	stp	x23, x24, [sp, 80]
	add	x0, x0, :lo12:.LC58
	bl	printf
	ldr	x19, [x19]
	cbz	x19, .L882
	mov	x24, -6148914691236517206
	adrp	x22, .LC59
	adrp	x21, .LANCHOR103
	add	x22, x22, :lo12:.LC59
	add	x21, x21, :lo12:.LANCHOR103
	mov	w20, 0
	adrp	x23, .LANCHOR4
	movk	x24, 0xaaab, lsl 0
.L886:
	ldr	x2, [x23, #:lo12:.LANCHOR4]
	adrp	x1, .LANCHOR7
	adrp	x8, .LANCHOR9
	ldrh	w5, [x19, 4]
	sub	x2, x19, x2
	ldr	x1, [x1, #:lo12:.LANCHOR7]
	asr	x2, x2, 1
	ldr	x8, [x8, #:lo12:.LANCHOR9]
	ldrh	w4, [x19, 2]
	mul	x2, x2, x24
	and	x7, x2, 65535
	and	w2, w2, 65535
	lsl	x0, x7, 2
	add	x3, x1, x0
	ldrh	w7, [x8, x7, lsl 1]
	ldrb	w6, [x3, 2]
	ldrh	w3, [x19]
	str	w7, [sp, 16]
	ldrh	w7, [x1, x0]
	and	w7, w7, 2047
	str	w7, [sp, 8]
	ubfx	x7, x6, 3, 2
	ubfx	x6, x6, 5, 3
	ldr	w0, [x1, x0]
	mov	w1, w20
	ubfx	x0, x0, 11, 8
	str	w0, [sp]
	mov	x0, x22
	bl	printf
	ldrh	w19, [x19]
	mov	w0, 65535
	cmp	w19, w0
	beq	.L882
	ldr	x0, [x23, #:lo12:.LANCHOR4]
	mov	w1, 6
	add	w20, w20, 1
	and	w20, w20, 65535
	umaddl	x19, w19, w1, x0
	ldrh	w0, [x21]
	cmp	w0, w20
	bcs	.L886
.L882:
	ldp	x19, x20, [sp, 48]
	ldp	x21, x22, [sp, 64]
	ldp	x23, x24, [sp, 80]
	ldp	x29, x30, [sp, 32]
	add	sp, sp, 96
	ret
	.size	print_list_info, .-print_list_info
	.section	.text.dump_all_list_info,"ax",@progbits
	.align	2
	.global	dump_all_list_info
	.type	dump_all_list_info, %function
dump_all_list_info:
	stp	x29, x30, [sp, -16]!
	adrp	x1, .LANCHOR97
	adrp	x0, .LANCHOR98
	add	x1, x1, :lo12:.LANCHOR97
	add	x29, sp, 0
	add	x0, x0, :lo12:.LANCHOR98
	bl	print_list_info
	adrp	x1, .LANCHOR99
	adrp	x0, .LANCHOR100
	add	x1, x1, :lo12:.LANCHOR99
	add	x0, x0, :lo12:.LANCHOR100
	bl	print_list_info
	adrp	x1, .LANCHOR101
	adrp	x0, .LANCHOR102
	add	x1, x1, :lo12:.LANCHOR101
	add	x0, x0, :lo12:.LANCHOR102
	bl	print_list_info
	adrp	x1, .LANCHOR92
	adrp	x0, .LANCHOR12
	add	x1, x1, :lo12:.LANCHOR92
	add	x0, x0, :lo12:.LANCHOR12
	bl	print_list_info
	adrp	x1, .LANCHOR90
	adrp	x0, .LANCHOR83
	add	x1, x1, :lo12:.LANCHOR90
	add	x0, x0, :lo12:.LANCHOR83
	bl	print_list_info
	ldp	x29, x30, [sp], 16
	adrp	x1, .LANCHOR94
	adrp	x0, .LANCHOR82
	add	x1, x1, :lo12:.LANCHOR94
	add	x0, x0, :lo12:.LANCHOR82
	b	print_list_info
	.size	dump_all_list_info, .-dump_all_list_info
	.section	.text.ftl_tmp_into_update,"ax",@progbits
	.align	2
	.global	ftl_tmp_into_update
	.type	ftl_tmp_into_update, %function
ftl_tmp_into_update:
	adrp	x0, .LANCHOR104
	ldr	x0, [x0, #:lo12:.LANCHOR104]
	ldr	w1, [x0, 16]
	cmp	w1, 2048
	bls	.L891
	ldr	w2, [x0, 20]
	add	w2, w2, w1, lsr 11
	and	w1, w1, 2047
	stp	w1, w2, [x0, 16]
.L891:
	ldr	w1, [x0, 24]
	cmp	w1, 2048
	bls	.L892
	ldr	w2, [x0, 28]
	add	w2, w2, w1, lsr 11
	and	w1, w1, 2047
	stp	w1, w2, [x0, 24]
.L892:
	ldr	w1, [x0, 32]
	cmp	w1, 1024
	bls	.L893
	ldr	w2, [x0, 36]
	add	w2, w2, w1, lsr 10
	and	w1, w1, 1023
	stp	w1, w2, [x0, 32]
.L893:
	ldr	w1, [x0, 40]
	cmp	w1, 1024
	bls	.L890
	ldr	w2, [x0, 44]
	add	w2, w2, w1, lsr 10
	and	w1, w1, 1023
	stp	w1, w2, [x0, 40]
.L890:
	ret
	.size	ftl_tmp_into_update, .-ftl_tmp_into_update
	.section	.text.ftl_get_blk_list_in_sblk,"ax",@progbits
	.align	2
	.global	ftl_get_blk_list_in_sblk
	.type	ftl_get_blk_list_in_sblk, %function
ftl_get_blk_list_in_sblk:
	adrp	x2, .LANCHOR7
	and	w0, w0, 65535
	mov	w7, 24
	adrp	x8, .LANCHOR68
	ldr	x2, [x2, #:lo12:.LANCHOR7]
	add	x8, x8, :lo12:.LANCHOR68
	mov	w3, 0
	add	x2, x2, x0, uxth 2
	ldrb	w13, [x2, 3]
	adrp	x2, .LANCHOR80
	ldrb	w11, [x2, #:lo12:.LANCHOR80]
	adrp	x2, .LANCHOR69
	ldrb	w6, [x2, #:lo12:.LANCHOR69]
	adrp	x2, .LANCHOR31
	ldrb	w2, [x2, #:lo12:.LANCHOR31]
	sub	w7, w7, w2
	and	w2, w6, 65535
	mul	w0, w0, w2
	sub	w2, w2, #1
	sxth	w5, w2
	and	w4, w0, 65535
	mov	w0, 0
.L896:
	cmp	w3, w11
	blt	.L900
	sxtw	x2, w0
	mov	w3, -1
.L901:
	cmp	w11, w2
	bgt	.L902
	ret
.L900:
	asr	w2, w13, w3
	tbnz	x2, 0, .L897
	sdiv	w2, w3, w6
	ldrh	w10, [x8]
	sbfiz	x12, x0, 1, 32
	cmp	w6, 1
	sub	w10, w7, w10
	lsl	w2, w2, w10
	add	w2, w4, w2
	and	w2, w2, 65535
	bhi	.L898
.L903:
	add	w0, w0, 1
	strh	w2, [x1, x12]
.L897:
	add	w3, w3, 1
	b	.L896
.L898:
	and	w10, w5, w3
	add	w2, w2, w10
	b	.L903
.L902:
	strh	w3, [x1, x2, lsl 1]
	add	x2, x2, 1
	b	.L901
	.size	ftl_get_blk_list_in_sblk, .-ftl_get_blk_list_in_sblk
	.section	.text.ftl_erase_phy_blk,"ax",@progbits
	.align	2
	.global	ftl_erase_phy_blk
	.type	ftl_erase_phy_blk, %function
ftl_erase_phy_blk:
	stp	x29, x30, [sp, -48]!
	and	w0, w0, 65535
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	mov	w21, w1
	adrp	x1, .LANCHOR31
	stp	x19, x20, [sp, 16]
	adrp	x22, .LANCHOR105
	ldrb	w19, [x1, #:lo12:.LANCHOR31]
	mov	w1, 24
	sub	w19, w1, w19
	adrp	x1, .LANCHOR68
	ldrh	w1, [x1, #:lo12:.LANCHOR68]
	sub	w1, w19, w1
	mov	w19, 1
	lsl	w19, w19, w1
	sub	w19, w19, #1
	and	w19, w19, w0
	asr	w20, w0, w1
	adrp	x0, .LANCHOR74
	sxth	w19, w19
	ldrb	w0, [x0, #:lo12:.LANCHOR74]
	cbz	w0, .L905
	adrp	x0, .LANCHOR75
	ldrb	w0, [x0, #:lo12:.LANCHOR75]
	cbnz	w0, .L905
	ldrh	w2, [x22, #:lo12:.LANCHOR105]
	cmp	w21, 0
	cset	w1, eq
	mov	w0, w20
	mul	w2, w2, w19
	bl	flash_erase_block_en
.L905:
	ldrh	w2, [x22, #:lo12:.LANCHOR105]
	mov	w1, w21
	mov	w0, w20
	ldp	x21, x22, [sp, 32]
	mul	w2, w2, w19
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	b	flash_erase_block_en
	.size	ftl_erase_phy_blk, .-ftl_erase_phy_blk
	.section	.text.ftl_erase_sblk,"ax",@progbits
	.align	2
	.global	ftl_erase_sblk
	.type	ftl_erase_sblk, %function
ftl_erase_sblk:
	stp	x29, x30, [sp, -176]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR7
	stp	x25, x26, [sp, 64]
	and	w26, w0, 65535
	ldr	x0, [x23, #:lo12:.LANCHOR7]
	adrp	x25, .LANCHOR106
	stp	x21, x22, [sp, 32]
	ubfiz	x22, x26, 2, 16
	add	x0, x0, x22
	stp	x27, x28, [sp, 80]
	stp	x19, x20, [sp, 16]
	adrp	x24, .LANCHOR69
	mov	w20, w1
	add	x25, x25, :lo12:.LANCHOR106
	ldrb	w28, [x0, 3]
	add	x24, x24, :lo12:.LANCHOR69
	add	x27, x29, 112
	mov	w19, 0
.L911:
	ldrb	w0, [x25]
	cmp	w19, w0
	bge	.L922
	ldrb	w1, [x24]
	adrp	x0, .LANCHOR105
	mov	w21, 0
	ldrh	w3, [x0, #:lo12:.LANCHOR105]
	sub	w4, w1, #1
	mov	w0, 0
	mul	w6, w19, w1
	mul	w5, w26, w1
	b	.L923
.L913:
	add	w2, w0, w6
	asr	w2, w28, w2
	tbnz	x2, 0, .L912
	and	w2, w0, w4
	add	w2, w2, w5
	mul	w2, w2, w3
	str	w2, [x27, w21, sxtw 2]
	add	w21, w21, 1
.L912:
	add	w0, w0, 1
.L923:
	cmp	w0, w1
	blt	.L913
	cmp	w1, 4
	bne	.L914
	mov	x3, 0
.L915:
	cmp	w21, w3
	bgt	.L916
.L917:
	add	w19, w19, 1
	b	.L911
.L916:
	ldr	w2, [x27, x3, lsl 2]
	mov	w1, w20
	str	x3, [x29, 104]
	mov	w0, w19
	bl	flash_erase_block_en
	ldr	x3, [x29, 104]
	add	x3, x3, 1
	b	.L915
.L914:
	cmp	w21, 2
	bne	.L918
	adrp	x0, .LANCHOR74
	ldrb	w0, [x0, #:lo12:.LANCHOR74]
	cbz	w0, .L919
	adrp	x0, .LANCHOR75
	ldrb	w0, [x0, #:lo12:.LANCHOR75]
	cbnz	w0, .L919
	ldp	w2, w3, [x29, 112]
	cmp	w20, 0
	cset	w1, eq
	mov	w0, w19
	bl	flash_erase_duplane_block
.L919:
	ldp	w2, w3, [x29, 112]
	mov	w1, w20
	mov	w0, w19
	bl	flash_erase_duplane_block
	b	.L917
.L918:
	cmp	w21, 1
	bne	.L917
	adrp	x0, .LANCHOR74
	ldrb	w0, [x0, #:lo12:.LANCHOR74]
	cbz	w0, .L921
	adrp	x0, .LANCHOR75
	ldrb	w0, [x0, #:lo12:.LANCHOR75]
	cbnz	w0, .L921
	ldr	w2, [x29, 112]
	cmp	w20, 0
	cset	w1, eq
	mov	w0, w19
	bl	flash_erase_block_en
.L921:
	ldr	w2, [x29, 112]
	mov	w1, w20
	mov	w0, w19
	bl	flash_erase_block_en
	b	.L917
.L922:
	adrp	x2, .LANCHOR104
	ldr	x3, [x23, #:lo12:.LANCHOR7]
	cbnz	w20, .L924
	ldrh	w1, [x3, x22]
	add	w0, w1, 1
	and	w0, w0, 2047
	bfi	w1, w0, 0, 11
	strh	w1, [x3, x22]
	ldr	x1, [x2, #:lo12:.LANCHOR104]
	ldr	w2, [x1, 84]
	add	w2, w2, 1
	str	w2, [x1, 84]
	ldrh	w2, [x1, 96]
	cmp	w2, w0
	bge	.L926
	strh	w0, [x1, 96]
.L926:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L924:
	ldr	w1, [x3, x22]
	ubfx	x0, x1, 11, 8
	add	w0, w0, 1
	and	w0, w0, 255
	bfi	w1, w0, 11, 8
	str	w1, [x3, x22]
	and	w0, w0, 65535
	ldr	x1, [x2, #:lo12:.LANCHOR104]
	ldr	w2, [x1, 80]
	add	w2, w2, 1
	str	w2, [x1, 80]
	ldrh	w2, [x1, 98]
	cmp	w2, w0
	bcs	.L926
	strh	w0, [x1, 98]
	b	.L926
	.size	ftl_erase_sblk, .-ftl_erase_sblk
	.section	.text.ftl_alloc_sys_blk,"ax",@progbits
	.align	2
	.global	ftl_alloc_sys_blk
	.type	ftl_alloc_sys_blk, %function
ftl_alloc_sys_blk:
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR104
	add	x29, sp, 0
	ldr	x1, [x0, #:lo12:.LANCHOR104]
	ldrh	w2, [x1, 136]
	str	x19, [sp, 16]
	mov	x19, x0
	cmp	w2, 63
	bls	.L936
	strh	wzr, [x1, 136]
.L936:
	ldrh	w0, [x1, 112]
	cbnz	w0, .L937
	adrp	x1, .LANCHOR107
	adrp	x0, .LC0
	mov	w2, 1140
	add	x1, x1, :lo12:.LANCHOR107
	add	x0, x0, :lo12:.LC0
	bl	printf
.L937:
	ldr	x1, [x19, #:lo12:.LANCHOR104]
	mov	w5, 65535
.L940:
	ldrh	w2, [x1, 136]
.L938:
	mov	w3, w2
	cmp	w2, 63
	ble	.L939
	strh	wzr, [x1, 136]
	b	.L940
.L939:
	add	x4, x2, 1
	add	x0, x1, x4, lsl 1
	ldrh	w0, [x0, 158]
	cmp	w0, w5
	bne	.L943
	mov	x2, x4
	b	.L938
.L943:
	add	x3, x1, x3, sxtw 1
	mov	w4, -1
	ldr	x19, [sp, 16]
	strh	w4, [x3, 160]
	strh	w2, [x1, 136]
	ldrh	w2, [x1, 112]
	sub	w2, w2, #1
	strh	w2, [x1, 112]
	ldp	x29, x30, [sp], 32
	ret
	.size	ftl_alloc_sys_blk, .-ftl_alloc_sys_blk
	.section	.text.ftl_free_sys_blk,"ax",@progbits
	.align	2
	.global	ftl_free_sys_blk
	.type	ftl_free_sys_blk, %function
ftl_free_sys_blk:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w20, w0, 65535
	adrp	x0, .LANCHOR104
	mov	x19, x0
	ldr	x1, [x0, #:lo12:.LANCHOR104]
	ldrh	w2, [x1, 138]
	cmp	w2, 63
	bls	.L946
	strh	wzr, [x1, 138]
.L946:
	ldrh	w0, [x1, 112]
	cmp	w0, 63
	bls	.L947
	adrp	x1, .LANCHOR108
	adrp	x0, .LC0
	mov	w2, 1164
	add	x1, x1, :lo12:.LANCHOR108
	add	x0, x0, :lo12:.LC0
	bl	printf
.L947:
	ldr	x0, [x19, #:lo12:.LANCHOR104]
	mov	w4, 65535
.L950:
	ldrh	w1, [x0, 138]
.L948:
	mov	w2, w1
	cmp	w1, 63
	ble	.L949
	strh	wzr, [x0, 138]
	b	.L950
.L949:
	add	x3, x1, 1
	add	x5, x0, x3, lsl 1
	ldrh	w5, [x5, 158]
	cmp	w5, w4
	bne	.L951
	add	x2, x0, x2, sxtw 1
	strh	w20, [x2, 160]
	strh	w1, [x0, 138]
	ldrh	w1, [x0, 112]
	ldp	x19, x20, [sp, 16]
	add	w1, w1, 1
	strh	w1, [x0, 112]
	ldp	x29, x30, [sp], 32
	ret
.L951:
	mov	x1, x3
	b	.L948
	.size	ftl_free_sys_blk, .-ftl_free_sys_blk
	.section	.text.ftl_info_data_recovery,"ax",@progbits
	.align	2
	.global	ftl_info_data_recovery
	.type	ftl_info_data_recovery, %function
ftl_info_data_recovery:
	ldrh	w2, [x0]
	mov	w1, 65535
	cmp	w2, w1
	beq	.L964
	stp	x29, x30, [sp, -48]!
	adrp	x1, .LANCHOR7
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	ubfiz	x19, x2, 2, 16
	ldr	x20, [x1, #:lo12:.LANCHOR7]
	str	x21, [sp, 32]
	add	x21, x20, x19
	ldrb	w1, [x21, 2]
	tst	w1, 224
	bne	.L954
	ldrb	w0, [x0, 4]
	bfi	w1, w0, 5, 3
	strb	w1, [x21, 2]
	mov	w0, w2
	bl	zftl_remove_free_node
	ldrb	w0, [x21, 2]
	adrp	x1, .LANCHOR104
	ldr	x3, [x1, #:lo12:.LANCHOR104]
	tbz	x0, 3, .L958
	ldrh	w2, [x3, 116]
	sub	w2, w2, #1
	strh	w2, [x3, 116]
.L959:
	and	w0, w0, 224
	cmp	w0, 160
	bne	.L961
	ldr	w0, [x20, x19]
	ldr	x1, [x1, #:lo12:.LANCHOR104]
	ubfx	x2, x0, 11, 8
	add	w2, w2, 1
	bfi	w0, w2, 11, 8
	str	w0, [x20, x19]
	ldrh	w0, [x1, 120]
	sub	w0, w0, #1
	strh	w0, [x1, 120]
.L954:
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L958:
	tst	w0, 24
	bne	.L960
	ldrh	w2, [x3, 114]
	sub	w2, w2, #1
	strh	w2, [x3, 114]
	b	.L959
.L960:
	ldrh	w2, [x3, 118]
	sub	w2, w2, #1
	strh	w2, [x3, 118]
	b	.L959
.L961:
	ldrh	w2, [x20, x19]
	cmp	w0, 64
	add	w3, w2, 1
	bfi	w2, w3, 0, 11
	strh	w2, [x20, x19]
	bne	.L962
	ldr	x1, [x1, #:lo12:.LANCHOR104]
	ldrh	w0, [x1, 122]
	sub	w0, w0, #1
	strh	w0, [x1, 122]
	b	.L954
.L962:
	cmp	w0, 96
	bne	.L954
	ldr	x1, [x1, #:lo12:.LANCHOR104]
	ldrh	w0, [x1, 124]
	sub	w0, w0, #1
	strh	w0, [x1, 124]
	b	.L954
.L964:
	ret
	.size	ftl_info_data_recovery, .-ftl_info_data_recovery
	.section	.text.ftl_get_ppa_from_index,"ax",@progbits
	.align	2
	.global	ftl_get_ppa_from_index
	.type	ftl_get_ppa_from_index, %function
ftl_get_ppa_from_index:
	stp	x29, x30, [sp, -32]!
	adrp	x1, .LANCHOR10
	adrp	x3, .LANCHOR80
	and	w0, w0, 65535
	add	x29, sp, 0
	ldr	x2, [x1, #:lo12:.LANCHOR10]
	adrp	x1, .LANCHOR87
	ldrb	w3, [x3, #:lo12:.LANCHOR80]
	ldrh	w1, [x1, #:lo12:.LANCHOR87]
	stp	x19, x20, [sp, 16]
	mul	w1, w1, w3
	cmp	w0, w1
	bge	.L968
	add	x2, x2, 16
.L969:
	ldrb	w1, [x2, 9]
	sdiv	w19, w0, w1
	msub	w0, w19, w1, w0
	add	x0, x2, x0, uxth 1
	ldrh	w20, [x0, 16]
	mov	w0, 65535
	cmp	w20, w0
	bne	.L970
	adrp	x1, .LANCHOR109
	adrp	x0, .LC0
	mov	w2, 1686
	add	x1, x1, :lo12:.LANCHOR109
	add	x0, x0, :lo12:.LC0
	bl	printf
.L970:
	adrp	x0, .LANCHOR105
	ldrh	w0, [x0, #:lo12:.LANCHOR105]
	madd	w0, w0, w20, w19
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L968:
	sub	w0, w0, w1
	add	x2, x2, 48
	and	w0, w0, 65535
	b	.L969
	.size	ftl_get_ppa_from_index, .-ftl_get_ppa_from_index
	.section	.text.lpa_hash_get_ppa,"ax",@progbits
	.align	2
	.global	lpa_hash_get_ppa
	.type	lpa_hash_get_ppa, %function
lpa_hash_get_ppa:
	and	x2, x0, 255
	adrp	x1, .LANCHOR110
	add	x1, x1, :lo12:.LANCHOR110
	mov	w3, 65535
	ldrh	w1, [x1, x2, lsl 1]
	adrp	x2, .LANCHOR111
	ldr	x4, [x2, #:lo12:.LANCHOR111]
	adrp	x2, .LANCHOR112
	ldr	x5, [x2, #:lo12:.LANCHOR112]
.L973:
	cmp	w1, w3
	bne	.L975
	mov	w0, -1
	ret
.L975:
	uxtw	x2, w1
	ldr	w6, [x4, x2, lsl 2]
	cmp	w0, w6
	bne	.L974
	mov	w0, w1
	b	ftl_get_ppa_from_index
.L974:
	ldrh	w1, [x5, x2, lsl 1]
	b	.L973
	.size	lpa_hash_get_ppa, .-lpa_hash_get_ppa
	.section	.text.ftl_get_new_free_page,"ax",@progbits
	.align	2
	.global	ftl_get_new_free_page
	.type	ftl_get_new_free_page, %function
ftl_get_new_free_page:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	ldrh	w1, [x0]
	str	x19, [sp, 16]
	mov	x19, x0
	mov	w0, 65535
	cmp	w1, w0
	bne	.L977
	adrp	x1, .LANCHOR113
	adrp	x0, .LC0
	mov	w2, 1809
	add	x1, x1, :lo12:.LANCHOR113
	add	x0, x0, :lo12:.LC0
	bl	printf
.L977:
	adrp	x0, .LANCHOR87
	ldrh	w1, [x19, 2]
	ldrh	w0, [x0, #:lo12:.LANCHOR87]
	cmp	w1, w0
	bne	.L978
	adrp	x1, .LANCHOR113
	adrp	x0, .LC0
	mov	w2, 1810
	add	x1, x1, :lo12:.LANCHOR113
	add	x0, x0, :lo12:.LC0
	bl	printf
.L978:
	ldrh	w0, [x19, 6]
	cbnz	w0, .L979
	adrp	x1, .LANCHOR113
	adrp	x0, .LC0
	mov	w2, 1811
	add	x1, x1, :lo12:.LANCHOR113
	add	x0, x0, :lo12:.LC0
	bl	printf
.L979:
	ldrb	w0, [x19, 5]
	mov	w2, 65535
	add	x0, x0, 8
	ldrh	w3, [x19, x0, lsl 1]
	adrp	x0, .LANCHOR80
	ldrb	w4, [x0, #:lo12:.LANCHOR80]
.L980:
	cmp	w3, w2
	ldrb	w1, [x19, 5]
	beq	.L982
	adrp	x0, .LANCHOR105
	add	w1, w1, 1
	and	w1, w1, 255
	ldrh	w2, [x19, 2]
	ldrh	w0, [x0, #:lo12:.LANCHOR105]
	cmp	w4, w1
	strb	w1, [x19, 5]
	mul	w0, w0, w3
	ldrh	w3, [x19, 6]
	sub	w3, w3, #1
	strh	w3, [x19, 6]
	ldrh	w3, [x19, 10]
	orr	w0, w0, w2
	add	w3, w3, 1
	strh	w3, [x19, 10]
	bne	.L976
	add	w2, w2, 1
	strb	wzr, [x19, 5]
	strh	w2, [x19, 2]
.L976:
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L982:
	add	w1, w1, 1
	and	w1, w1, 255
	strb	w1, [x19, 5]
	cmp	w1, w4
	bne	.L981
	ldrh	w0, [x19, 2]
	strb	wzr, [x19, 5]
	add	w0, w0, 1
	strh	w0, [x19, 2]
.L981:
	ldrb	w0, [x19, 5]
	add	x0, x0, 8
	ldrh	w3, [x19, x0, lsl 1]
	b	.L980
	.size	ftl_get_new_free_page, .-ftl_get_new_free_page
	.section	.text.ftl_ext_alloc_new_blk,"ax",@progbits
	.align	2
	.global	ftl_ext_alloc_new_blk
	.type	ftl_ext_alloc_new_blk, %function
ftl_ext_alloc_new_blk:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	bl	ftl_alloc_sys_blk
	and	w0, w0, 65535
	mov	w1, 65533
	mov	w19, w0
	sub	w0, w0, #1
	cmp	w1, w0, uxth
	bcs	.L986
	adrp	x1, .LANCHOR114
	adrp	x0, .LC0
	mov	w2, 1842
	add	x1, x1, :lo12:.LANCHOR114
	add	x0, x0, :lo12:.LC0
	bl	printf
.L986:
	adrp	x20, .LANCHOR104
	mov	w1, 0
	mov	w0, w19
	bl	ftl_erase_phy_blk
	ldr	x0, [x20, #:lo12:.LANCHOR104]
	ldrh	w0, [x0, 130]
	bl	ftl_free_sys_blk
	ldr	x0, [x20, #:lo12:.LANCHOR104]
	strh	w19, [x0, 130]
	strh	wzr, [x0, 140]
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	ftl_ext_alloc_new_blk, .-ftl_ext_alloc_new_blk
	.section	.text.ftl_total_vpn_update,"ax",@progbits
	.align	2
	.global	ftl_total_vpn_update
	.type	ftl_total_vpn_update, %function
ftl_total_vpn_update:
	adrp	x2, .LANCHOR115
	mov	x3, x2
	ldrh	w1, [x2, #:lo12:.LANCHOR115]
	cmp	w1, 4
	bhi	.L989
	cbnz	w0, .L989
	add	w1, w1, 1
	strh	w1, [x2, #:lo12:.LANCHOR115]
	ret
.L989:
	adrp	x0, .LANCHOR6
	strh	wzr, [x3, #:lo12:.LANCHOR115]
	mov	x1, 0
	mov	w2, 0
	ldrh	w5, [x0, #:lo12:.LANCHOR6]
	adrp	x0, .LANCHOR9
	mov	w8, 65535
	ldr	x6, [x0, #:lo12:.LANCHOR9]
	adrp	x0, .LANCHOR7
	ldr	x7, [x0, #:lo12:.LANCHOR7]
	mov	w0, 0
.L991:
	cmp	w5, w1, uxth
	bhi	.L994
	adrp	x1, .LANCHOR10
	ldr	x1, [x1, #:lo12:.LANCHOR10]
	str	w2, [x1, 524]
	adrp	x2, .LANCHOR104
	str	w0, [x1, 528]
	ldr	x2, [x2, #:lo12:.LANCHOR104]
	ldrh	w2, [x2, 120]
	cbz	w2, .L988
	udiv	w0, w0, w2
	str	w0, [x1, 532]
.L988:
	ret
.L994:
	ldrh	w3, [x6, x1, lsl 1]
	cmp	w3, w8
	beq	.L992
	add	x4, x7, x1, lsl 2
	ldrb	w4, [x4, 2]
	and	w4, w4, 224
	cmp	w4, 160
	bne	.L993
	add	w0, w0, w3
.L992:
	add	x1, x1, 1
	b	.L991
.L993:
	add	w2, w2, w3
	b	.L992
	.size	ftl_total_vpn_update, .-ftl_total_vpn_update
	.section	.text.ftl_debug_info_fill,"ax",@progbits
	.align	2
	.global	ftl_debug_info_fill
	.type	ftl_debug_info_fill, %function
ftl_debug_info_fill:
	mov	w0, 0
	ret
	.size	ftl_debug_info_fill, .-ftl_debug_info_fill
	.section	.text.ftl_vpn_update,"ax",@progbits
	.align	2
	.global	ftl_vpn_update
	.type	ftl_vpn_update, %function
ftl_vpn_update:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	str	x19, [sp, 16]
	and	w19, w0, 65535
	mov	w0, w19
	bl	zftl_list_update_data_list
	adrp	x0, .LANCHOR9
	ubfiz	x19, x19, 1, 16
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrh	w0, [x0, x19]
	cbnz	w0, .L1002
	adrp	x1, .LANCHOR116
	mov	w0, 1
	str	w0, [x1, #:lo12:.LANCHOR116]
.L1000:
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L1002:
	mov	w0, 0
	b	.L1000
	.size	ftl_vpn_update, .-ftl_vpn_update
	.section	.text.ftl_vpn_decrement,"ax",@progbits
	.align	2
	.global	ftl_vpn_decrement
	.type	ftl_vpn_decrement, %function
ftl_vpn_decrement:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w19, w0, 65535
	mov	w0, 65535
	cmp	w19, w0
	beq	.L1005
	adrp	x0, .LANCHOR9
	uxtw	x1, w19
	lsl	x2, x1, 1
	ldr	x3, [x0, #:lo12:.LANCHOR9]
	ldrh	w0, [x3, x2]
	cbnz	w0, .L1006
	adrp	x0, .LANCHOR7
	mov	w2, 0
	ldr	x0, [x0, #:lo12:.LANCHOR7]
	add	x1, x0, x1, lsl 2
	adrp	x0, .LC60
	add	x0, x0, :lo12:.LC60
	ldrb	w3, [x1, 2]
	mov	w1, w19
	ubfx	x3, x3, 5, 3
	bl	printf
.L1011:
	mov	w0, 0
	b	.L1004
.L1006:
	sub	w0, w0, #1
	strh	w0, [x3, x2]
.L1005:
	adrp	x20, .LANCHOR66
	ldrh	w0, [x20, #:lo12:.LANCHOR66]
	cmp	w19, w0
	beq	.L1011
	mov	w1, 65535
	cmp	w0, w1
	bne	.L1008
	strh	w19, [x20, #:lo12:.LANCHOR66]
	b	.L1011
.L1008:
	bl	ftl_vpn_update
	cmp	w0, 0
	adrp	x1, .LANCHOR117
	cset	w0, ne
	ldrh	w3, [x20, #:lo12:.LANCHOR66]
	ldrh	w2, [x1, #:lo12:.LANCHOR117]
	strh	w19, [x20, #:lo12:.LANCHOR66]
	add	w2, w2, 1
	and	w2, w2, 65535
	cmp	w2, 7
	csel	w2, w2, wzr, ls
	strh	w2, [x1, #:lo12:.LANCHOR117]
	and	x2, x2, 65535
	adrp	x1, .LANCHOR67
	add	x1, x1, :lo12:.LANCHOR67
	strh	w3, [x1, x2, lsl 1]
.L1004:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	ftl_vpn_decrement, .-ftl_vpn_decrement
	.section	.text.lpa_hash_update_ppa,"ax",@progbits
	.align	2
	.global	lpa_hash_update_ppa
	.type	lpa_hash_update_ppa, %function
lpa_hash_update_ppa:
	adrp	x3, .LANCHOR110
	and	x5, x0, 255
	add	x4, x3, :lo12:.LANCHOR110
	mov	w7, 65535
	and	w2, w2, 65535
	mov	w12, w7
	ldrh	w6, [x4, x5, lsl 1]
	adrp	x4, .LANCHOR111
	ldr	x8, [x4, #:lo12:.LANCHOR111]
	adrp	x4, .LANCHOR112
	ldr	x4, [x4, #:lo12:.LANCHOR112]
.L1014:
	cmp	w6, w12
	beq	.L1018
	uxtw	x11, w6
	lsl	x10, x11, 2
	add	x13, x8, x10
	ldr	w10, [x8, x10]
	cmp	w0, w10
	lsl	x10, x11, 1
	bne	.L1015
	mov	w6, -1
	str	w6, [x13]
	cmp	w7, w12
	bne	.L1016
	add	x6, x3, :lo12:.LANCHOR110
	ldrh	w7, [x4, x10]
	strh	w7, [x6, x5, lsl 1]
.L1017:
	mov	w6, -1
	strh	w6, [x4, x11, lsl 1]
.L1018:
	uxtw	x6, w2
	add	x3, x3, :lo12:.LANCHOR110
	cmn	w1, #1
	str	w0, [x8, x6, lsl 2]
	ldrh	w0, [x3, x5, lsl 1]
	strh	w2, [x3, x5, lsl 1]
	strh	w0, [x4, x6, lsl 1]
	beq	.L1025
	stp	x29, x30, [sp, -16]!
	adrp	x0, .LANCHOR68
	add	x29, sp, 0
	ldrh	w3, [x0, #:lo12:.LANCHOR68]
	adrp	x0, .LANCHOR31
	ldrb	w2, [x0, #:lo12:.LANCHOR31]
	mov	w0, 24
	lsr	w1, w1, w3
	sub	w0, w0, w2
	sub	w2, w0, w3
	mov	w0, 1
	lsl	w0, w0, w2
	sub	w0, w0, #1
	and	w1, w0, w1
	adrp	x0, .LANCHOR69
	ldrb	w0, [x0, #:lo12:.LANCHOR69]
	udiv	w0, w1, w0
	bl	ftl_vpn_decrement
	mov	w0, -1
	ldp	x29, x30, [sp], 16
	ret
.L1016:
	ldrh	w6, [x4, x10]
	strh	w6, [x4, w7, uxtw 1]
	b	.L1017
.L1015:
	mov	w7, w6
	ldrh	w6, [x4, x10]
	b	.L1014
.L1025:
	mov	w0, -1
	ret
	.size	lpa_hash_update_ppa, .-lpa_hash_update_ppa
	.section	.text.ftl_mask_bad_block,"ax",@progbits
	.align	2
	.global	ftl_mask_bad_block
	.type	ftl_mask_bad_block, %function
ftl_mask_bad_block:
	stp	x29, x30, [sp, -32]!
	adrp	x1, .LANCHOR31
	mov	w6, 24
	mov	w4, 1
	add	x29, sp, 0
	ldrb	w1, [x1, #:lo12:.LANCHOR31]
	stp	x19, x20, [sp, 16]
	sub	w6, w6, w1
	lsl	w1, w4, w1
	sub	w1, w1, #1
	lsr	w2, w0, w6
	and	w1, w1, w2
	adrp	x2, .LANCHOR69
	and	w1, w1, 255
	ldrb	w5, [x2, #:lo12:.LANCHOR69]
	cmp	w5, 1
	mul	w2, w1, w5
	and	w19, w2, 255
	adrp	x2, .LANCHOR68
	ldrh	w3, [x2, #:lo12:.LANCHOR68]
	lsr	w0, w0, w3
	sub	w3, w6, w3
	lsl	w3, w4, w3
	sub	w3, w3, #1
	and	w3, w3, w0
	and	w4, w3, 65535
	udiv	w3, w3, w5
	and	w20, w3, 65535
	bls	.L1029
	sub	w2, w5, #1
	and	w2, w2, w4
	add	w2, w19, w2
	and	w19, w2, 255
.L1029:
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 14, .L1030
	adrp	x0, .LC61
	and	w3, w3, 65535
	mov	w2, w19
	add	x0, x0, :lo12:.LC61
	bl	printf
.L1030:
	adrp	x0, .LANCHOR6
	ldrh	w0, [x0, #:lo12:.LANCHOR6]
	cmp	w0, w20
	bls	.L1028
	adrp	x0, .LANCHOR7
	mov	w2, 1
	lsl	w2, w2, w19
	ldr	x0, [x0, #:lo12:.LANCHOR7]
	add	x20, x0, x20, uxth 2
	ldrb	w19, [x20, 3]
	orr	w2, w2, w19
	strb	w2, [x20, 3]
.L1028:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	ftl_mask_bad_block, .-ftl_mask_bad_block
	.section	.text.gc_free_bad_sblk,"ax",@progbits
	.align	2
	.global	gc_free_bad_sblk
	.type	gc_free_bad_sblk, %function
gc_free_bad_sblk:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	adrp	x24, .LANCHOR64
	stp	x27, x28, [sp, 80]
	and	w27, w0, 65535
	add	x0, x24, :lo12:.LANCHOR64
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	ldr	w0, [x0, 584]
	cbz	w0, .L1047
	adrp	x25, .LANCHOR80
	adrp	x26, .LANCHOR68
	add	x25, x25, :lo12:.LANCHOR80
	add	x22, x26, :lo12:.LANCHOR68
	mov	w23, 0
.L1038:
	ldrb	w0, [x25]
	cmp	w0, w23
	bhi	.L1045
.L1047:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L1045:
	adrp	x0, .LANCHOR69
	adrp	x1, .LANCHOR31
	ldrb	w2, [x0, #:lo12:.LANCHOR69]
	ldrb	w3, [x1, #:lo12:.LANCHOR31]
	mov	w1, 24
	and	w0, w2, 65535
	cmp	w2, 1
	sub	w1, w1, w3
	ldrh	w3, [x26, #:lo12:.LANCHOR68]
	sdiv	w19, w23, w2
	sub	w1, w1, w3
	lsl	w19, w19, w1
	madd	w19, w27, w0, w19
	and	w19, w19, 65535
	bls	.L1039
	sub	w0, w0, #1
	and	w0, w0, w23
	add	w19, w19, w0
	and	w19, w19, 65535
.L1039:
	adrp	x28, .LC62
	add	x21, x24, :lo12:.LANCHOR64
	add	x28, x28, :lo12:.LC62
	mov	w20, 0
.L1040:
	ldr	w0, [x21, 584]
	cmp	w20, w0
	bcc	.L1044
	add	w23, w23, 1
	and	w23, w23, 65535
	b	.L1038
.L1044:
	add	x0, x21, x20, sxtw 1
	ldrh	w0, [x0, 588]
	cmp	w0, w19
	bne	.L1041
	mov	w1, w19
	mov	x0, x28
	bl	printf
	ldrh	w0, [x22]
	lsl	w0, w19, w0
	bl	ftl_mask_bad_block
	ldr	w1, [x21, 584]
	mov	w0, w20
.L1042:
	cmp	w0, w1
	bcc	.L1043
	sub	w1, w1, #1
	str	w1, [x21, 584]
.L1041:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L1040
.L1043:
	add	w2, w0, 1
	add	x0, x21, x0, sxtw 1
	add	x3, x21, x2, sxtw 1
	ldrh	w3, [x3, 588]
	strh	w3, [x0, 588]
	and	w0, w2, 65535
	b	.L1042
	.size	gc_free_bad_sblk, .-gc_free_bad_sblk
	.section	.text.ftl_free_sblk,"ax",@progbits
	.align	2
	.global	ftl_free_sblk
	.type	ftl_free_sblk, %function
ftl_free_sblk:
	stp	x29, x30, [sp, -64]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR7
	and	x24, x0, 65535
	stp	x19, x20, [sp, 16]
	ldr	x4, [x23, #:lo12:.LANCHOR7]
	lsl	x19, x24, 2
	stp	x21, x22, [sp, 32]
	mov	x21, x24
	add	x20, x4, x19
	ldrb	w0, [x20, 2]
	ubfx	x22, x0, 5, 3
	tbz	x0, 3, .L1053
	adrp	x1, .LANCHOR104
	ldrh	w2, [x4, x19]
	adrp	x8, .LANCHOR118
	ldr	x7, [x1, #:lo12:.LANCHOR104]
	and	w5, w2, 2047
	ldr	w2, [x4, x19]
	ldrh	w8, [x8, #:lo12:.LANCHOR118]
	ldrh	w3, [x7, 74]
	ubfx	x1, x2, 11, 8
	adrp	x2, .LANCHOR8
	add	w3, w5, w3
	ldrh	w2, [x2, #:lo12:.LANCHOR8]
	and	w6, w3, 65535
	ldrh	w3, [x7, 72]
	add	w3, w1, w3
	udiv	w7, w6, w2
	and	w3, w3, 65535
	add	w7, w7, w3
	cmp	w7, w8
	ble	.L1054
	adrp	x3, .LANCHOR95
	adrp	x7, .LANCHOR99
	ldrh	w6, [x3, #:lo12:.LANCHOR95]
	adrp	x3, .LANCHOR94
	ldrh	w7, [x7, #:lo12:.LANCHOR99]
	ldrh	w3, [x3, #:lo12:.LANCHOR94]
	add	w6, w6, 7
	add	w3, w3, w7
	cmp	w6, w3
	blt	.L1055
.L1060:
	mov	w3, 2
	bfi	w0, w3, 3, 2
	b	.L1069
.L1055:
	adrp	x3, .LANCHOR119
	adrp	x7, .LANCHOR97
	ldrh	w6, [x3, #:lo12:.LANCHOR119]
	adrp	x3, .LANCHOR92
	ldrh	w7, [x7, #:lo12:.LANCHOR97]
	ldrh	w3, [x3, #:lo12:.LANCHOR92]
	add	w6, w6, 7
	add	w3, w3, w7
	adrp	x7, .LANCHOR90
	ldrh	w7, [x7, #:lo12:.LANCHOR90]
	add	w3, w3, w7
	cmp	w6, w3
	blt	.L1060
.L1070:
	and	w0, w0, -25
.L1069:
	strb	w0, [x20, 2]
.L1056:
	ldrb	w0, [x20, 2]
	ands	w0, w0, 24
	bne	.L1061
	mul	w0, w1, w2
	ldrh	w2, [x4, x19]
	add	w0, w0, w0, lsl 1
	add	w0, w5, w0, lsr 2
	bfi	w2, w0, 0, 11
	strh	w2, [x4, x19]
	lsr	w2, w1, 3
	ldr	w0, [x4, x19]
	bfi	w0, w2, 11, 8
	str	w0, [x4, x19]
.L1053:
	mov	w0, w21
	bl	zftl_remove_data_node
	ldr	x0, [x23, #:lo12:.LANCHOR7]
	add	w22, w22, 6
	and	w22, w22, 7
	add	x19, x0, x19
	cmp	w22, 4
	ldrb	w0, [x19, 2]
	and	w0, w0, 31
	strb	w0, [x19, 2]
	adrp	x0, .LANCHOR9
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	strh	wzr, [x0, x24, lsl 1]
	bhi	.L1063
	mov	w0, w21
	bl	gc_free_bad_sblk
.L1063:
	ldrb	w0, [x20, 2]
	tbz	x0, 3, .L1064
	adrp	x0, .LANCHOR10
	ldr	x0, [x0, #:lo12:.LANCHOR10]
	ldrh	w1, [x0, 586]
	cmp	w1, w21
	bne	.L1064
	mov	w1, -1
	ldrh	w2, [x0, 590]
	strh	w1, [x0, 586]
	mov	w1, 65535
	cmp	w2, w1
	bne	.L1064
	strh	w21, [x0, 590]
	mov	w1, w21
	ldp	x19, x20, [sp, 16]
	adrp	x0, .LC63
	ldp	x21, x22, [sp, 32]
	add	x0, x0, :lo12:.LC63
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	b	printf
.L1054:
	madd	w3, w2, w3, w6
	adrp	x6, .LANCHOR120
	ldrh	w6, [x6, #:lo12:.LANCHOR120]
	cmp	w3, w6
	ble	.L1056
	adrp	x3, .LANCHOR119
	adrp	x7, .LANCHOR97
	ldrh	w6, [x3, #:lo12:.LANCHOR119]
	adrp	x3, .LANCHOR92
	ldrh	w7, [x7, #:lo12:.LANCHOR97]
	ldrh	w3, [x3, #:lo12:.LANCHOR92]
	add	w3, w3, w7
	adrp	x7, .LANCHOR90
	ldrh	w7, [x7, #:lo12:.LANCHOR90]
	add	w3, w3, w7
	add	w7, w6, 7
	cmp	w7, w3
	bge	.L1070
	adrp	x7, .LANCHOR95
	adrp	x10, .LANCHOR99
	ldrh	w8, [x7, #:lo12:.LANCHOR95]
	adrp	x7, .LANCHOR94
	ldrh	w10, [x10, #:lo12:.LANCHOR99]
	ldrh	w7, [x7, #:lo12:.LANCHOR94]
	add	w8, w8, 7
	add	w7, w7, w10
	cmp	w8, w7
	bge	.L1060
	add	w6, w6, 23
	cmp	w3, w6
	bgt	.L1060
	b	.L1070
.L1061:
	cmp	w0, 16
	bne	.L1053
	sdiv	w2, w5, w2
	ldr	w0, [x4, x19]
	add	w2, w2, w2, lsl 1
	add	w2, w1, w2, lsr 2
	bfi	w0, w2, 11, 8
	asr	w2, w5, 5
	str	w0, [x4, x19]
	bfi	w0, w2, 0, 11
	strh	w0, [x4, x19]
	b	.L1053
.L1064:
	mov	w0, w21
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	b	zftl_insert_free_list
	.size	ftl_free_sblk, .-ftl_free_sblk
	.section	.text.gc_free_src_blk,"ax",@progbits
	.align	2
	.global	gc_free_src_blk
	.type	gc_free_src_blk, %function
gc_free_src_blk:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR64
	stp	x23, x24, [sp, 48]
	adrp	x22, .LC64
	adrp	x23, .LANCHOR9
	add	x21, x21, :lo12:.LANCHOR64
	mov	x24, x23
	add	x22, x22, :lo12:.LC64
	stp	x19, x20, [sp, 16]
	mov	w20, 0
	stp	x25, x26, [sp, 64]
.L1072:
	ldrh	w0, [x21, 56]
	cmp	w0, w20
	bhi	.L1086
	strh	wzr, [x21, 56]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L1086:
	add	x0, x21, x20, sxtw 1
	ldrh	w25, [x0, 58]
	ldr	x0, [x23, #:lo12:.LANCHOR9]
	mov	x19, x25
	lsl	x26, x25, 1
	ldrh	w2, [x0, x26]
	cbz	w2, .L1073
	mov	w1, w25
	mov	x0, x22
	bl	printf
.L1073:
	ldr	x0, [x24, #:lo12:.LANCHOR9]
	strh	wzr, [x0, x26]
	adrp	x0, .LANCHOR7
	ldr	x0, [x0, #:lo12:.LANCHOR7]
	add	x25, x0, x25, lsl 2
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L1074
	ldrb	w2, [x25, 2]
	adrp	x0, .LC65
	mov	w1, w19
	add	x0, x0, :lo12:.LC65
	ubfx	x2, x2, 5, 3
	bl	printf
.L1074:
	ldrb	w0, [x25, 2]
	and	w1, w0, 224
	cmp	w1, 224
	beq	.L1075
	tst	w0, 192
	bne	.L1076
.L1075:
	adrp	x1, .LANCHOR121
	adrp	x0, .LC0
	mov	w2, 1114
	add	x1, x1, :lo12:.LANCHOR121
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1076:
	mov	w0, w19
	bl	ftl_free_sblk
	adrp	x0, .LANCHOR10
	ldr	x0, [x0, #:lo12:.LANCHOR10]
	ldrh	w2, [x0, 124]
	cbz	w2, .L1077
	add	x3, x0, 392
	mov	w1, 0
.L1079:
	ldrh	w4, [x3]
	cmp	w4, w19
	bne	.L1078
	add	x1, x0, x1, sxtw 1
	mov	w3, -1
	sub	w2, w2, #1
	strh	w3, [x1, 392]
	strh	w2, [x0, 124]
.L1077:
	ldrh	w2, [x0, 120]
	cbz	w2, .L1080
	add	x3, x0, 136
	mov	w1, 0
.L1082:
	ldrh	w4, [x3]
	cmp	w4, w19
	bne	.L1081
	add	x1, x0, x1, sxtw 1
	mov	w3, -1
	sub	w2, w2, #1
	strh	w3, [x1, 136]
	strh	w2, [x0, 120]
.L1080:
	ldrh	w2, [x0, 122]
	cbz	w2, .L1083
	add	x3, x0, 264
	mov	w1, 0
.L1085:
	ldrh	w4, [x3]
	cmp	w4, w19
	bne	.L1084
	add	x1, x0, x1, sxtw 1
	mov	w3, -1
	sub	w2, w2, #1
	strh	w3, [x1, 264]
	strh	w2, [x0, 122]
.L1083:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L1072
.L1078:
	add	w1, w1, 1
	add	x3, x3, 2
	cmp	w1, 64
	bne	.L1079
	b	.L1077
.L1081:
	add	w1, w1, 1
	add	x3, x3, 2
	cmp	w1, 64
	bne	.L1082
	b	.L1080
.L1084:
	add	w1, w1, 1
	add	x3, x3, 2
	cmp	w1, 64
	bne	.L1085
	b	.L1083
	.size	gc_free_src_blk, .-gc_free_src_blk
	.section	.text.print_ftl_debug_info,"ax",@progbits
	.align	2
	.global	print_ftl_debug_info
	.type	print_ftl_debug_info, %function
print_ftl_debug_info:
	sub	sp, sp, #64
	adrp	x2, .LANCHOR90
	adrp	x8, .LANCHOR122
	stp	x29, x30, [sp, 32]
	add	x29, sp, 32
	ldrh	w7, [x2, #:lo12:.LANCHOR90]
	adrp	x2, .LANCHOR92
	stp	x19, x20, [sp, 48]
	adrp	x19, .LANCHOR104
	adrp	x20, .LANCHOR10
	ldrh	w6, [x2, #:lo12:.LANCHOR92]
	adrp	x2, .LANCHOR101
	ldr	x1, [x19, #:lo12:.LANCHOR104]
	ldrh	w5, [x2, #:lo12:.LANCHOR101]
	adrp	x2, .LANCHOR99
	ldr	x0, [x20, #:lo12:.LANCHOR10]
	ldrh	w4, [x2, #:lo12:.LANCHOR99]
	adrp	x2, .LANCHOR97
	ldr	w8, [x8, #:lo12:.LANCHOR122]
	ldrh	w3, [x2, #:lo12:.LANCHOR97]
	ldrh	w2, [x1, 146]
	ldrh	w1, [x1, 148]
	str	w8, [sp, 24]
	ldr	w8, [x0, 528]
	str	w8, [sp, 16]
	ldr	w0, [x0, 524]
	str	w0, [sp, 8]
	adrp	x0, .LANCHOR94
	ldrh	w0, [x0, #:lo12:.LANCHOR94]
	str	w0, [sp]
	adrp	x0, .LC66
	add	x0, x0, :lo12:.LC66
	bl	printf
	ldr	x0, [x19, #:lo12:.LANCHOR104]
	adrp	x1, .LANCHOR123
	ldrb	w3, [x1, #:lo12:.LANCHOR123]
	ldr	w4, [x0, 8]
	ldr	w5, [x0, 64]
	ldr	w1, [x0, 20]
	ldr	w2, [x0, 28]
	adrp	x0, .LC67
	add	x0, x0, :lo12:.LC67
	bl	printf
	ldr	x0, [x19, #:lo12:.LANCHOR104]
	ldr	w1, [x0, 52]
	ldr	w2, [x0, 60]
	ldr	w3, [x0, 16]
	adrp	x0, .LC68
	add	x0, x0, :lo12:.LC68
	lsr	w3, w3, 11
	bl	printf
	ldr	x0, [x19, #:lo12:.LANCHOR104]
	ldrh	w2, [x0, 98]
	ldrh	w6, [x0, 72]
	ldrh	w5, [x0, 96]
	ldrh	w4, [x0, 92]
	ldrh	w3, [x0, 88]
	ldrh	w1, [x0, 74]
	str	w2, [sp, 16]
	ldrh	w2, [x0, 94]
	str	w2, [sp, 8]
	ldrh	w2, [x0, 90]
	str	w2, [sp]
	ldp	w7, w2, [x0, 80]
	adrp	x0, .LC69
	add	x0, x0, :lo12:.LC69
	bl	printf
	adrp	x0, .LANCHOR81
	ldrh	w5, [x0, #:lo12:.LANCHOR81]
	adrp	x0, .LANCHOR86
	ldrh	w4, [x0, #:lo12:.LANCHOR86]
	adrp	x0, .LANCHOR63
	ldrh	w3, [x0, #:lo12:.LANCHOR63]
	adrp	x0, .LANCHOR96
	ldrh	w2, [x0, #:lo12:.LANCHOR96]
	adrp	x0, .LANCHOR93
	ldrh	w1, [x0, #:lo12:.LANCHOR93]
	adrp	x0, .LC70
	add	x0, x0, :lo12:.LC70
	bl	printf
	ldr	x0, [x20, #:lo12:.LANCHOR10]
	ldr	x1, [x19, #:lo12:.LANCHOR104]
	ldp	x29, x30, [sp, 32]
	ldrh	w4, [x0, 590]
	ldrh	w6, [x1, 150]
	ldrh	w3, [x0, 588]
	ldrh	w2, [x0, 586]
	ldp	x19, x20, [sp, 48]
	add	sp, sp, 64
	ldr	w5, [x1, 156]
	ldrh	w1, [x0, 584]
	adrp	x0, .LC71
	add	x0, x0, :lo12:.LC71
	b	printf
	.size	print_ftl_debug_info, .-print_ftl_debug_info
	.section	.text.ftl_write_buf,"ax",@progbits
	.align	2
	.global	ftl_write_buf
	.type	ftl_write_buf, %function
ftl_write_buf:
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	str	x21, [sp, 32]
	cbnz	x0, .L1112
	adrp	x1, .LANCHOR124
	add	x1, x1, :lo12:.LANCHOR124
	mov	w2, 676
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	printf
	bl	print_ftl_debug_info
	mov	w0, -1
.L1111:
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L1115:
	mov	x1, x19
	adrp	x0, .LANCHOR59
	add	x0, x0, :lo12:.LANCHOR59
	bl	buf_add_tail
	adrp	x1, .LANCHOR104
	ldrb	w3, [x19, 56]
	ldrb	w0, [x21, #:lo12:.LANCHOR60]
	ldr	x1, [x1, #:lo12:.LANCHOR104]
	add	w0, w0, 1
	and	w0, w0, 255
	strb	w0, [x21, #:lo12:.LANCHOR60]
	ldr	w2, [x1, 16]
	add	w2, w2, w3
	str	w2, [x1, 16]
	ldr	w2, [x1, 32]
	add	w2, w2, 1
	str	w2, [x1, 32]
	b	.L1111
.L1112:
	mov	x19, x0
	adrp	x0, .LANCHOR125
	mov	x20, x0
	ldrb	w1, [x0, #:lo12:.LANCHOR125]
	ldrb	w2, [x19, 56]
	cmp	w2, w1
	bls	.L1117
	adrp	x1, .LANCHOR124
	adrp	x0, .LC0
	mov	w2, 681
	add	x1, x1, :lo12:.LANCHOR124
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1117:
	ldrb	w0, [x19, 56]
	adrp	x21, .LANCHOR60
	cbz	w0, .L1114
	ldrb	w1, [x20, #:lo12:.LANCHOR125]
	cmp	w1, w0
	bcs	.L1115
.L1114:
	mov	x0, x19
	bl	zbuf_free
	ldrb	w0, [x21, #:lo12:.LANCHOR60]
	b	.L1111
	.size	ftl_write_buf, .-ftl_write_buf
	.section	.text.ftl_write_completed,"ax",@progbits
	.align	2
	.global	ftl_write_completed
	.type	ftl_write_completed, %function
ftl_write_completed:
	stp	x29, x30, [sp, -64]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR52
	add	x19, x19, :lo12:.LANCHOR52
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR126
	mov	x22, x19
	add	x21, x21, :lo12:.LANCHOR126
	stp	x23, x24, [sp, 48]
	mov	w24, 0
.L1123:
	ldrb	w0, [x21]
	cmp	w0, 255
	bne	.L1131
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L1131:
	lsl	x1, x0, 6
	ubfiz	x20, x0, 6, 8
	add	x23, x19, x1
	add	x20, x19, x20
	ldrb	w1, [x19, x1]
	strb	w1, [x21]
	ldr	w1, [x23, 52]
	cmn	w1, #1
	bne	.L1124
	adrp	x1, .LANCHOR68
	mov	w2, 24
	ldr	w3, [x23, 40]
	mov	w5, 65535
	ldrh	w4, [x1, #:lo12:.LANCHOR68]
	adrp	x1, .LANCHOR31
	ldrb	w1, [x1, #:lo12:.LANCHOR31]
	sub	w1, w2, w1
	sub	w2, w1, w4
	mov	w1, 1
	lsr	w4, w3, w4
	lsl	w1, w1, w2
	adrp	x2, .LANCHOR69
	sub	w1, w1, #1
	ldrb	w2, [x2, #:lo12:.LANCHOR69]
	and	w1, w1, w4
	udiv	w1, w1, w2
	adrp	x2, .LANCHOR10
	mov	x23, x2
	ldr	x4, [x2, #:lo12:.LANCHOR10]
	and	w24, w1, 65535
	and	w1, w1, w5
	ldr	w6, [x4, 560]
	cmp	w6, w5
	bne	.L1125
	str	w1, [x4, 560]
	str	w3, [x4, 564]
.L1125:
	add	x0, x22, x0, lsl 6
	ldr	w2, [x0, 36]
	adrp	x0, .LC72
	add	x0, x0, :lo12:.LC72
	bl	printf
	ldr	x0, [x23, #:lo12:.LANCHOR10]
	ldr	w1, [x0, 556]
	add	w1, w1, 1
	str	w1, [x0, 556]
	ldrh	w1, [x0, 16]
	cmp	w1, w24
	bne	.L1126
	strh	wzr, [x0, 22]
.L1127:
	mov	x0, x20
	mov	w24, 1
	bl	ftl_write_buf
	b	.L1123
.L1126:
	ldrh	w1, [x0, 48]
	cmp	w1, w24
	bne	.L1127
	strh	wzr, [x0, 54]
	b	.L1127
.L1124:
	cbz	w24, .L1129
	ldp	w1, w2, [x23, 36]
	adrp	x0, .LC73
	add	x0, x0, :lo12:.LC73
	bl	printf
	mov	x0, x20
	bl	ftl_write_buf
	b	.L1123
.L1129:
	ldrh	w2, [x23, 48]
	ldr	w0, [x23, 36]
	ldr	w1, [x23, 44]
	bl	lpa_hash_update_ppa
	ldrb	w0, [x23, 2]
	tbz	x0, 2, .L1130
	and	w0, w0, -3
	strb	w0, [x23, 2]
	b	.L1123
.L1130:
	mov	x0, x20
	bl	zbuf_free
	b	.L1123
	.size	ftl_write_completed, .-ftl_write_completed
	.section	.text.zftl_add_read_buf,"ax",@progbits
	.align	2
	.global	zftl_add_read_buf
	.type	zftl_add_read_buf, %function
zftl_add_read_buf:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	str	x19, [sp, 16]
	cbnz	x0, .L1134
	mov	w2, 972
	adrp	x1, .LANCHOR127
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR127
	add	x0, x0, :lo12:.LC0
	bl	printf
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	b	print_ftl_debug_info
.L1134:
	ldrb	w1, [x0, 56]
	mov	x19, x0
	adrp	x0, .LANCHOR125
	ldrb	w0, [x0, #:lo12:.LANCHOR125]
	cmp	w1, w0
	bls	.L1136
	adrp	x1, .LANCHOR127
	adrp	x0, .LC0
	mov	w2, 977
	add	x1, x1, :lo12:.LANCHOR127
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1136:
	mov	x1, x19
	adrp	x0, .LANCHOR128
	add	x0, x0, :lo12:.LANCHOR128
	bl	buf_add_tail
	adrp	x1, .LANCHOR129
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ldrb	w0, [x1, #:lo12:.LANCHOR129]
	add	w0, w0, 1
	strb	w0, [x1, #:lo12:.LANCHOR129]
	ret
	.size	zftl_add_read_buf, .-zftl_add_read_buf
	.section	.text.ftl_alloc_sblk,"ax",@progbits
	.align	2
	.global	ftl_alloc_sblk
	.type	ftl_alloc_sblk, %function
ftl_alloc_sblk:
	stp	x29, x30, [sp, -64]!
	cmp	w0, 5
	add	x29, sp, 0
	str	x23, [sp, 48]
	and	w23, w0, 65535
	stp	x19, x20, [sp, 16]
	mov	w1, w23
	stp	x21, x22, [sp, 32]
	mov	w20, w0
	cset	w22, eq
	mov	w0, 0
	bl	zftl_get_free_sblk
	and	w19, w0, 65535
	mov	w0, 65535
	cmp	w19, w0
	beq	.L1141
	adrp	x0, .LANCHOR7
	lsl	w22, w22, 1
	ldr	x21, [x0, #:lo12:.LANCHOR7]
	add	x21, x21, x19, uxth 2
	ldrb	w0, [x21, 2]
	tst	w0, 224
	beq	.L1142
	adrp	x1, .LANCHOR130
	adrp	x0, .LC0
	mov	w2, 836
	add	x1, x1, :lo12:.LANCHOR130
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1142:
	ldrb	w0, [x21, 2]
	bfi	w0, w20, 5, 3
	ubfx	x1, x0, 3, 2
	orr	w22, w22, w1
	bfi	w0, w22, 3, 2
	strb	w0, [x21, 2]
.L1143:
	mov	w0, w19
	ldr	x23, [sp, 48]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L1141:
	bl	print_ftl_debug_info
	adrp	x21, .LC74
	mov	w2, w20
	add	x21, x21, :lo12:.LC74
	mov	w1, w19
	mov	x0, x21
	bl	printf
	mov	w1, w23
	mov	w0, 0
	bl	zftl_get_free_sblk
	and	w19, w0, 65535
	mov	w2, w20
	mov	w1, w19
	mov	x0, x21
	bl	printf
	bl	dump_all_list_info
	mov	w2, 846
	adrp	x1, .LANCHOR130
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR130
	add	x0, x0, :lo12:.LC0
	bl	printf
	b	.L1143
	.size	ftl_alloc_sblk, .-ftl_alloc_sblk
	.section	.text.sblk_init,"ax",@progbits
	.align	2
	.global	sblk_init
	.type	sblk_init, %function
sblk_init:
	adrp	x1, .LANCHOR56
	mov	w0, -1
	strb	w0, [x1, #:lo12:.LANCHOR56]
	adrp	x1, .LANCHOR126
	strb	w0, [x1, #:lo12:.LANCHOR126]
	adrp	x1, .LANCHOR131
	strb	w0, [x1, #:lo12:.LANCHOR131]
	adrp	x1, .LANCHOR71
	strb	w0, [x1, #:lo12:.LANCHOR71]
	mov	w0, 0
	ret
	.size	sblk_init, .-sblk_init
	.section	.text.dump_sblk_queue,"ax",@progbits
	.align	2
	.global	dump_sblk_queue
	.type	dump_sblk_queue, %function
dump_sblk_queue:
	stp	x29, x30, [sp, -48]!
	adrp	x0, .LC75
	add	x0, x0, :lo12:.LC75
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR56
	str	x21, [sp, 32]
	ldrb	w1, [x19, #:lo12:.LANCHOR56]
	bl	printf
	ldrb	w19, [x19, #:lo12:.LANCHOR56]
	cmp	w19, 255
	beq	.L1150
	adrp	x1, .LANCHOR52
	ubfiz	x19, x19, 6, 8
	add	x1, x1, :lo12:.LANCHOR52
	adrp	x21, .LC76
	add	x19, x1, x19
	add	x21, x21, :lo12:.LC76
	mov	x20, x1
.L1152:
	ldrb	w2, [x19, 58]
	mov	x0, x21
	ldrb	w1, [x19, 1]
	ldr	w3, [x19, 40]
	bl	printf
	ldrb	w19, [x19]
	cmp	w19, 255
	beq	.L1150
	ubfiz	x19, x19, 6, 8
	add	x19, x20, x19
	b	.L1152
.L1150:
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
	.size	dump_sblk_queue, .-dump_sblk_queue
	.section	.text.queue_lun_state,"ax",@progbits
	.align	2
	.global	queue_lun_state
	.type	queue_lun_state, %function
queue_lun_state:
	adrp	x2, .LANCHOR56
	ldrb	w2, [x2, #:lo12:.LANCHOR56]
	cmp	w2, 255
	beq	.L1168
	adrp	x3, .LANCHOR31
	mov	w8, 24
	adrp	x10, .LANCHOR52
	add	x10, x10, :lo12:.LANCHOR52
	ldrb	w4, [x3, #:lo12:.LANCHOR31]
	mov	w3, 1
	adrp	x13, .L1164
	mov	x15, x10
	sub	w8, w8, w4
	add	x13, x13, :lo12:.L1164
	lsl	w4, w3, w4
	sub	w4, w4, #1
	and	w6, w4, 65535
	adrp	x4, .LANCHOR68
	asr	w11, w0, w8
	and	w11, w11, w6
	ldrh	w12, [x4, #:lo12:.LANCHOR68]
	sub	w4, w8, w12
	lsl	w3, w3, w4
	sub	w3, w3, #1
	and	w7, w3, 65535
	adrp	x3, .LANCHOR69
	ldrb	w5, [x3, #:lo12:.LANCHOR69]
	asr	w3, w0, w12
	sub	w5, w5, #1
	and	w5, w5, 65535
	and	w3, w3, w5
	and	w3, w3, w7
.L1167:
	add	x14, x10, x2, lsl 6
	ldr	w4, [x14, 40]
	lsr	w0, w4, w8
	and	w0, w6, w0
	cmp	w11, w0
	bne	.L1162
	lsr	w4, w4, w12
	and	w4, w5, w4
	and	w4, w7, w4
	ldrb	w0, [x14, 58]
	cmp	w3, w4
	bne	.L1163
	cmp	w1, 1
	bne	.L1160
	cmp	w0, 7
	ccmp	w0, 9, 4, ne
	beq	.L1162
	ret
.L1163:
	cmp	w1, 3
	bhi	.L1162
	ldrb	w4, [x13,w1,uxtw]
	adr	x14, .Lrtx1164
	add	x4, x14, w4, sxtb #2
	br	x4
.Lrtx1164:
	.section	.rodata.queue_lun_state,"a",@progbits
	.align	0
	.align	2
.L1164:
	.byte	(.L1160 - .Lrtx1164) / 4
	.byte	(.L1165 - .Lrtx1164) / 4
	.byte	(.L1166 - .Lrtx1164) / 4
	.byte	(.L1160 - .Lrtx1164) / 4
	.section	.text.queue_lun_state
.L1165:
	cmp	w0, 7
	ccmp	w0, 9, 4, ne
	beq	.L1162
	ret
.L1166:
	cmp	w0, 11
	bne	.L1160
.L1162:
	lsl	x2, x2, 6
	ldrb	w2, [x15, x2]
	cmp	w2, 255
	bne	.L1167
.L1168:
	mov	w0, 0
.L1160:
	ret
	.size	queue_lun_state, .-queue_lun_state
	.section	.text.queue_remove_completed_req,"ax",@progbits
	.align	2
	.global	queue_remove_completed_req
	.type	queue_remove_completed_req, %function
queue_remove_completed_req:
	adrp	x4, .LANCHOR126
	adrp	x8, .LANCHOR71
	adrp	x1, .LANCHOR56
	adrp	x7, .LANCHOR131
	adrp	x3, .LANCHOR52
	ldrb	w14, [x4, #:lo12:.LANCHOR126]
	add	x5, x3, :lo12:.LANCHOR52
	ldrb	w2, [x1, #:lo12:.LANCHOR56]
	ldrb	w12, [x8, #:lo12:.LANCHOR71]
	mov	x11, x5
	ldrb	w13, [x7, #:lo12:.LANCHOR131]
	add	x16, x8, :lo12:.LANCHOR71
	add	x7, x7, :lo12:.LANCHOR131
	add	x10, x4, :lo12:.LANCHOR126
	mov	w6, 0
	mov	w15, -1
.L1171:
	cmp	w2, 255
	beq	.L1172
	sbfiz	x8, x2, 6, 32
	sxtw	x0, w2
	add	x4, x5, x8
	ldrb	w4, [x4, 58]
	sub	w4, w4, #12
	and	w4, w4, 255
	cmp	w4, 1
	bls	.L1173
	cbz	w6, .L1170
	strb	w2, [x1, #:lo12:.LANCHOR56]
	ret
.L1173:
	lsl	x6, x0, 6
	ldrb	w2, [x5, x8]
	add	x4, x5, x6
	strb	w15, [x5, x6]
	ldrb	w6, [x4, 59]
	cmp	w6, 1
	bne	.L1176
	ldrh	w4, [x4, 50]
	cbnz	w4, .L1184
	mov	w4, w14
	mov	x6, x10
.L1177:
	cmp	w4, 255
	bne	.L1182
	add	x3, x3, :lo12:.LANCHOR52
	strb	w2, [x1, #:lo12:.LANCHOR56]
	add	x0, x3, x0, lsl 6
	ldrb	w0, [x0, 1]
	strb	w0, [x6]
	ret
.L1176:
	cbnz	w6, .L1178
	ldr	w4, [x4, 36]
	cmn	w4, #1
	beq	.L1178
	mov	w4, w13
	mov	x6, x7
	b	.L1177
.L1184:
	mov	w4, w12
	mov	x6, x16
	b	.L1177
.L1182:
	mov	w6, w4
	sbfiz	x4, x4, 6, 32
	ldrb	w4, [x11, x4]
	cmp	w4, 255
	bne	.L1182
	add	x0, x11, x0, lsl 6
	sbfiz	x6, x6, 6, 32
	ldrb	w0, [x0, 1]
	strb	w0, [x11, x6]
.L1178:
	mov	w6, 1
	b	.L1171
.L1172:
	cbz	w6, .L1170
	mov	w0, -1
	strb	w0, [x1, #:lo12:.LANCHOR56]
.L1170:
	ret
	.size	queue_remove_completed_req, .-queue_remove_completed_req
	.section	.text.pm_alloc_new_blk,"ax",@progbits
	.align	2
	.global	pm_alloc_new_blk
	.type	pm_alloc_new_blk, %function
pm_alloc_new_blk:
	stp	x29, x30, [sp, -64]!
	adrp	x2, .LANCHOR80
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR104
	stp	x21, x22, [sp, 32]
	ldr	x1, [x20, #:lo12:.LANCHOR104]
	ldrb	w2, [x2, #:lo12:.LANCHOR80]
	ldrh	w0, [x1, 690]
	str	x23, [sp, 48]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x1, 690]
	cmp	w2, w0
	bls	.L1195
	add	x0, x1, x0, sxtw 1
	ldrh	w1, [x0, 672]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L1196
.L1195:
	adrp	x19, .LC77
	add	x19, x19, :lo12:.LC77
	adrp	x23, .LANCHOR7
.L1208:
	mov	w0, 1
	bl	ftl_alloc_sblk
	mov	w1, 0
	and	w21, w0, 65535
	bl	ftl_erase_sblk
	add	x14, x20, :lo12:.LANCHOR104
	ldr	x1, [x20, #:lo12:.LANCHOR104]
	mov	w0, w21
	add	x1, x1, 672
	bl	ftl_get_blk_list_in_sblk
	tst	w0, 65535
	bne	.L1197
	mov	w1, w21
	mov	x0, x19
	bl	printf
	ldr	x1, [x23, #:lo12:.LANCHOR7]
	add	x1, x1, x21, uxth 2
	ldrb	w0, [x1, 2]
	orr	w0, w0, -32
	strb	w0, [x1, 2]
	b	.L1208
.L1197:
	ldr	x0, [x14]
	adrp	x1, .LANCHOR132
	mov	w2, 1
	mov	w19, 0
	add	x0, x0, 416
	str	w2, [x1, #:lo12:.LANCHOR132]
	mov	w1, 65535
	strh	wzr, [x0, 274]
.L1199:
	ldrh	w2, [x0]
	cmp	w2, w1
	beq	.L1198
	add	w19, w19, 1
	add	x0, x0, 2
	and	w19, w19, 65535
	cmp	w19, 128
	bne	.L1199
	adrp	x1, .LANCHOR133
	adrp	x0, .LC0
	mov	w2, 227
	add	x1, x1, :lo12:.LANCHOR133
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1198:
	ldr	x0, [x20, #:lo12:.LANCHOR104]
	add	x19, x0, x19, sxtw 1
	ldrh	w1, [x0, 688]
	strh	w21, [x19, 416]
	add	w1, w1, 1
	strh	w1, [x0, 688]
.L1196:
	ldr	x1, [x20, #:lo12:.LANCHOR104]
	ldrh	w0, [x1, 690]
	add	x0, x0, 336
	ldrh	w19, [x1, x0, lsl 1]
	mov	w0, 65533
	sub	w1, w19, #1
	cmp	w0, w1, uxth
	bcs	.L1201
	adrp	x1, .LANCHOR133
	adrp	x0, .LC0
	mov	w2, 232
	add	x1, x1, :lo12:.LANCHOR133
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1201:
	adrp	x1, .LANCHOR31
	mov	w2, 24
	ldr	x0, [x20, #:lo12:.LANCHOR104]
	ldrb	w1, [x1, #:lo12:.LANCHOR31]
	sub	w2, w2, w1
	adrp	x1, .LANCHOR68
	strh	wzr, [x0, 696]
	ldrh	w1, [x1, #:lo12:.LANCHOR68]
	strh	w19, [x0, 692]
	sub	w2, w2, w1
	asr	w4, w19, w2
	strh	w4, [x0, 694]
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L1204
	mov	w0, 1
	and	w4, w4, 65535
	lsl	w2, w0, w2
	mov	w3, w19
	adrp	x0, .LC78
	sub	w2, w2, #1
	mov	w1, w19
	add	x0, x0, :lo12:.LC78
	bl	printf
.L1204:
	mov	w0, 0
	ldr	x23, [sp, 48]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
	.size	pm_alloc_new_blk, .-pm_alloc_new_blk
	.section	.text.pm_select_ram_region,"ax",@progbits
	.align	2
	.global	pm_select_ram_region
	.type	pm_select_ram_region, %function
pm_select_ram_region:
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR134
	add	x0, x0, :lo12:.LANCHOR134
	mov	x1, 0
	add	x29, sp, 0
	mov	w2, 65535
	str	x19, [sp, 16]
.L1213:
	lsl	x3, x1, 4
	and	w19, w1, 65535
	ldrh	w3, [x3, x0]
	cmp	w3, w2
	beq	.L1212
	add	x1, x1, 1
	cmp	x1, 32
	bne	.L1213
	add	x0, x0, 2
	mov	w19, w1
	mov	x2, x0
	mov	w4, 32768
	mov	w1, 0
.L1215:
	ldrh	w3, [x2]
	tbnz	x3, 15, .L1214
	cmp	w3, w4
	bcs	.L1214
	mov	w4, w3
	mov	w19, w1
.L1214:
	add	w1, w1, 1
	add	x2, x2, 16
	and	w1, w1, 65535
	cmp	w1, 32
	bne	.L1215
	cmp	w19, 32
	bne	.L1212
	adrp	x1, .LANCHOR135
	mov	w2, -1
	ldrb	w3, [x1, #:lo12:.LANCHOR135]
	mov	w1, 0
.L1217:
	ldrh	w5, [x0]
	cmp	w5, w2
	bcs	.L1216
	ldrh	w4, [x0, -2]
	cmp	w4, w3
	csel	w2, w2, w5, eq
	csel	w19, w19, w1, eq
.L1216:
	add	w1, w1, 1
	add	x0, x0, 16
	and	w1, w1, 65535
	cmp	w1, 32
	bne	.L1217
	cmp	w19, 32
	bne	.L1212
	adrp	x1, .LANCHOR136
	adrp	x0, .LC0
	mov	w2, 331
	add	x1, x1, :lo12:.LANCHOR136
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1212:
	mov	w0, w19
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	pm_select_ram_region, .-pm_select_ram_region
	.section	.text.idb_init,"ax",@progbits
	.align	2
	.global	idb_init
	.type	idb_init, %function
idb_init:
	adrp	x0, .LANCHOR137
	str	xzr, [x0, #:lo12:.LANCHOR137]
	adrp	x0, .LANCHOR138
	str	wzr, [x0, #:lo12:.LANCHOR138]
	adrp	x0, .LANCHOR139
	str	xzr, [x0, #:lo12:.LANCHOR139]
	mov	w0, 0
	ret
	.size	idb_init, .-idb_init
	.section	.text.ftl_memset,"ax",@progbits
	.align	2
	.global	ftl_memset
	.type	ftl_memset, %function
ftl_memset:
	uxtw	x2, w2
	b	memset
	.size	ftl_memset, .-ftl_memset
	.section	.text.flash_lsb_page_tbl_build,"ax",@progbits
	.align	2
	.global	flash_lsb_page_tbl_build
	.type	flash_lsb_page_tbl_build, %function
flash_lsb_page_tbl_build:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR3
	cbnz	w0, .L1225
	add	x1, x19, :lo12:.LANCHOR3
	mov	x0, 0
.L1226:
	strh	w0, [x1, x0, lsl 1]
	add	x0, x0, 1
	cmp	x0, 256
	bne	.L1226
.L1232:
	adrp	x20, .LANCHOR140
	add	x20, x20, :lo12:.LANCHOR140
	mov	w2, 1024
	mov	w1, 255
	mov	x0, x20
	add	x19, x19, :lo12:.LANCHOR3
	bl	ftl_memset
	mov	x0, 0
.L1227:
	ldrh	w1, [x0, x19]
	add	x0, x0, 2
	cmp	x0, 512
	strh	w1, [x20, w1, sxtw 1]
	bne	.L1227
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L1225:
	cmp	w0, 1
	bne	.L1228
	add	x3, x19, :lo12:.LANCHOR3
	mov	x1, 0
.L1231:
	and	w0, w1, 65535
	cmp	x1, 3
	bls	.L1229
	ubfiz	w2, w0, 1, 15
	and	w0, w0, 1
	add	w0, w0, 2
	sub	w0, w2, w0
	and	w0, w0, 65535
.L1229:
	strh	w0, [x3, x1, lsl 1]
	add	x1, x1, 1
	cmp	x1, 256
	bne	.L1231
	b	.L1232
.L1228:
	cmp	w0, 2
	bne	.L1233
	add	x3, x19, :lo12:.LANCHOR3
	mov	w1, 65535
	mov	x0, 0
.L1235:
	cmp	x0, 2
	and	w2, w0, 65535
	csel	w2, w2, w1, cc
	strh	w2, [x3, x0, lsl 1]
	add	w1, w1, 2
	add	x0, x0, 1
	and	w1, w1, 65535
	cmp	x0, 256
	bne	.L1235
	b	.L1232
.L1233:
	cmp	w0, 3
	bne	.L1236
	add	x3, x19, :lo12:.LANCHOR3
	mov	x1, 0
.L1239:
	and	w0, w1, 65535
	cmp	x1, 5
	bls	.L1237
	ubfiz	w2, w0, 1, 15
	and	w0, w0, 1
	add	w0, w0, 4
	sub	w0, w2, w0
	and	w0, w0, 65535
.L1237:
	strh	w0, [x3, x1, lsl 1]
	add	x1, x1, 1
	cmp	x1, 256
	bne	.L1239
	b	.L1232
.L1236:
	cmp	w0, 4
	bne	.L1240
	add	x1, x19, :lo12:.LANCHOR3
	mov	w2, 1
	add	x1, x1, 16
	strh	wzr, [x19, #:lo12:.LANCHOR3]
	strh	w0, [x1, -8]
	mov	w0, 5
	strh	w2, [x1, -14]
	mov	w2, 2
	strh	w0, [x1, -6]
	mov	w0, 7
	strh	w2, [x1, -12]
	mov	w2, 3
	strh	w0, [x1, -4]
	mov	w0, 8
	strh	w2, [x1, -10]
	strh	w0, [x1, -2]
	mov	w0, 8
.L1242:
	and	w3, w0, 1
	ubfiz	w2, w0, 1, 15
	add	w3, w3, 6
	add	w0, w0, 1
	sub	w2, w2, w3
	strh	w2, [x1], 2
	and	w0, w0, 65535
	cmp	w0, 256
	bne	.L1242
	b	.L1232
.L1240:
	cmp	w0, 5
	bne	.L1243
	add	x1, x19, :lo12:.LANCHOR3
	mov	x0, 0
.L1244:
	strh	w0, [x1, x0, lsl 1]
	add	x0, x0, 1
	cmp	x0, 16
	bne	.L1244
	add	x1, x1, 32
.L1245:
	strh	w0, [x1], 2
	add	w0, w0, 2
	and	w0, w0, 65535
	cmp	w0, 496
	bne	.L1245
	b	.L1232
.L1243:
	cmp	w0, 8
	bne	.L1246
	add	x1, x19, :lo12:.LANCHOR3
	mov	x0, 0
.L1247:
	strh	w0, [x0, x1]
	add	x0, x0, 2
	cmp	x0, 512
	bne	.L1247
	b	.L1232
.L1246:
	cmp	w0, 9
	bne	.L1232
	add	x0, x19, :lo12:.LANCHOR3
	mov	w1, 1
	add	x0, x0, 6
	strh	wzr, [x19, #:lo12:.LANCHOR3]
	strh	w1, [x0, -4]
	mov	w1, 2
	strh	w1, [x0, -2]
	mov	w1, 3
.L1248:
	strh	w1, [x0], 2
	add	w1, w1, 2
	and	w1, w1, 65535
	cmp	w1, 509
	bne	.L1248
	b	.L1232
	.size	flash_lsb_page_tbl_build, .-flash_lsb_page_tbl_build
	.section	.text.flash_die_info_init,"ax",@progbits
	.align	2
	.global	flash_die_info_init
	.type	flash_die_info_init, %function
flash_die_info_init:
	stp	x29, x30, [sp, -64]!
	adrp	x0, .LANCHOR14
	add	x29, sp, 0
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	tbz	x0, 12, .L1265
	adrp	x1, .LANCHOR141
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR141
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1265:
	adrp	x22, .LANCHOR32
	add	x19, x22, :lo12:.LANCHOR32
	adrp	x23, .LANCHOR2
	adrp	x24, .LANCHOR18
	adrp	x21, .LANCHOR30
	mov	w2, 8
	ldrh	w0, [x19, 26]
	adrp	x20, .LANCHOR143
	ldrb	w1, [x19, 12]
	strh	w0, [x23, #:lo12:.LANCHOR2]
	ldrh	w0, [x19, 10]
	strb	wzr, [x24, #:lo12:.LANCHOR18]
	sdiv	w0, w0, w1
	adrp	x1, .LANCHOR142
	strh	w0, [x1, #:lo12:.LANCHOR142]
	mov	w1, 0
	add	x0, x21, :lo12:.LANCHOR30
	bl	ftl_memset
	add	x0, x20, :lo12:.LANCHOR143
	mov	w2, 32
	mov	w1, 0
	bl	ftl_memset
	mov	x15, x21
	mov	x11, x20
	adrp	x12, .LANCHOR33
	adrp	x14, .LANCHOR44
	mov	x7, x22
	add	x12, x12, :lo12:.LANCHOR33
	add	x20, x14, :lo12:.LANCHOR44
	add	x21, x19, 1
	mov	x10, 0
.L1267:
	ldrb	w2, [x19]
	mov	w0, 2
	strb	w0, [x10, x12]
	add	x1, x20, x10, lsl 3
	mov	x0, x21
	bl	flash_mem_cmp8
	cbnz	w0, .L1266
	ldrb	w2, [x24, #:lo12:.LANCHOR18]
	add	x1, x11, :lo12:.LANCHOR143
	add	w0, w2, 1
	strb	w0, [x24, #:lo12:.LANCHOR18]
	and	w0, w10, 255
	str	wzr, [x1, x2, lsl 2]
	add	x1, x15, :lo12:.LANCHOR30
	strb	w0, [x1, x2]
	bl	zftl_flash_enter_slc_mode
.L1266:
	add	x10, x10, 1
	cmp	x10, 4
	bne	.L1267
	add	x0, x7, :lo12:.LANCHOR32
	ldrb	w1, [x0, 8]
	cmp	w1, 2
	beq	.L1268
.L1272:
	add	x7, x7, :lo12:.LANCHOR32
	ldrb	w0, [x24, #:lo12:.LANCHOR18]
	ldp	x19, x20, [sp, 16]
	ldrb	w1, [x7, 13]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	mul	w0, w0, w1
	ldrh	w1, [x7, 14]
	ldp	x29, x30, [sp], 64
	mul	w0, w0, w1
	adrp	x1, .LANCHOR144
	strh	w0, [x1, #:lo12:.LANCHOR144]
	ret
.L1268:
	ldrh	w1, [x23, #:lo12:.LANCHOR2]
	add	x14, x14, :lo12:.LANCHOR44
	ldrb	w12, [x0, 13]
	add	x10, x0, 1
	ldrb	w20, [x7, #:lo12:.LANCHOR32]
	add	x19, x24, :lo12:.LANCHOR18
	ldrb	w21, [x0, 23]
	add	x11, x11, :lo12:.LANCHOR143
	add	x15, x15, :lo12:.LANCHOR30
	mov	x13, 0
	mul	w12, w12, w1
	ldrh	w1, [x0, 14]
	and	w1, w1, 65280
	mul	w12, w12, w1
	lsl	w22, w12, 1
.L1271:
	mov	w2, w20
	add	x1, x14, x13, lsl 3
	mov	x0, x10
	bl	flash_mem_cmp8
	cbnz	w0, .L1269
	ldrb	w1, [x19]
	cmp	w21, 0
	csel	w2, w12, w22, eq
	add	w0, w1, 1
	strb	w0, [x19]
	str	w2, [x11, x1, lsl 2]
	strb	w13, [x15, x1]
.L1269:
	add	x13, x13, 1
	cmp	x13, 4
	bne	.L1271
	b	.L1272
	.size	flash_die_info_init, .-flash_die_info_init
	.section	.text.lpa_hash_init,"ax",@progbits
	.align	2
	.global	lpa_hash_init
	.type	lpa_hash_init, %function
lpa_hash_init:
	stp	x29, x30, [sp, -16]!
	mov	w2, 512
	mov	w1, 255
	adrp	x0, .LANCHOR110
	add	x29, sp, 0
	add	x0, x0, :lo12:.LANCHOR110
	bl	ftl_memset
	adrp	x0, .LANCHOR87
	mov	w1, 255
	ldp	x29, x30, [sp], 16
	ldrh	w2, [x0, #:lo12:.LANCHOR87]
	adrp	x0, .LANCHOR80
	ldrb	w0, [x0, #:lo12:.LANCHOR80]
	mul	w2, w2, w0
	adrp	x0, .LANCHOR112
	ldr	x0, [x0, #:lo12:.LANCHOR112]
	lsl	w2, w2, 2
	b	ftl_memset
	.size	lpa_hash_init, .-lpa_hash_init
	.section	.text.lpa_rebuild_hash,"ax",@progbits
	.align	2
	.global	lpa_rebuild_hash
	.type	lpa_rebuild_hash, %function
lpa_rebuild_hash:
	stp	x29, x30, [sp, -48]!
	adrp	x0, .LANCHOR14
	add	x29, sp, 0
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	tbz	x0, 12, .L1285
	adrp	x1, .LANCHOR145
	adrp	x0, .LC79
	mov	w3, 0
	mov	w2, 225
	add	x1, x1, :lo12:.LANCHOR145
	add	x0, x0, :lo12:.LC79
	bl	printf
.L1285:
	adrp	x20, .LANCHOR87
	adrp	x22, .LANCHOR80
	adrp	x19, .LANCHOR110
	add	x19, x19, :lo12:.LANCHOR110
	mov	w2, 512
	mov	w1, 255
	mov	x0, x19
	bl	ftl_memset
	ldrh	w2, [x20, #:lo12:.LANCHOR87]
	adrp	x21, .LANCHOR112
	ldrb	w0, [x22, #:lo12:.LANCHOR80]
	mov	w1, 255
	add	x20, x20, :lo12:.LANCHOR87
	mul	w2, w2, w0
	ldr	x0, [x21, #:lo12:.LANCHOR112]
	lsl	w2, w2, 2
	bl	ftl_memset
	adrp	x0, .LANCHOR111
	ldrb	w3, [x22, #:lo12:.LANCHOR80]
	ldr	x5, [x21, #:lo12:.LANCHOR112]
	mov	w1, 0
	ldr	x4, [x0, #:lo12:.LANCHOR111]
.L1286:
	ldrh	w0, [x20]
	mul	w0, w0, w3
	cmp	w1, w0, lsl 1
	blt	.L1288
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L1288:
	uxtw	x2, w1
	ldr	w0, [x4, x2, lsl 2]
	cmn	w0, #1
	beq	.L1287
	and	x0, x0, 255
	ldrh	w6, [x19, x0, lsl 1]
	strh	w1, [x19, x0, lsl 1]
	strh	w6, [x5, x2, lsl 1]
.L1287:
	add	w1, w1, 1
	and	w1, w1, 65535
	b	.L1286
	.size	lpa_rebuild_hash, .-lpa_rebuild_hash
	.section	.text.zftl_read_flash_info,"ax",@progbits
	.align	2
	.global	zftl_read_flash_info
	.type	zftl_read_flash_info, %function
zftl_read_flash_info:
	stp	x29, x30, [sp, -32]!
	mov	w2, 11
	mov	w1, 0
	add	x29, sp, 0
	str	x19, [sp, 16]
	mov	x19, x0
	bl	ftl_memset
	adrp	x1, .LANCHOR32
	add	x1, x1, :lo12:.LANCHOR32
	adrp	x0, .LANCHOR2
	adrp	x3, .LANCHOR61
	strb	wzr, [x19, 10]
	mov	w4, 1
	ldrb	w2, [x1, 9]
	ldrh	w0, [x0, #:lo12:.LANCHOR2]
	mul	w0, w2, w0
	strb	w0, [x19, 4]
	ubfx	x0, x0, 8, 8
	strb	w0, [x19, 5]
	adrp	x0, .LANCHOR46
	ldrb	w0, [x0, #:lo12:.LANCHOR46]
	strb	w0, [x19, 7]
	add	x0, x3, :lo12:.LANCHOR61
	ldrb	w3, [x3, #:lo12:.LANCHOR61]
	strb	w3, [x19]
	ldrb	w3, [x0, 1]
	strb	w3, [x19, 1]
	ldrb	w3, [x0, 2]
	ldrb	w0, [x0, 3]
	strb	w3, [x19, 2]
	strb	w0, [x19, 3]
	mov	w0, 32
	strb	w2, [x19, 6]
	adrp	x2, .LANCHOR30
	strb	w0, [x19, 8]
	add	x2, x2, :lo12:.LANCHOR30
	ldrb	w0, [x1, 7]
	mov	x1, 0
	strb	w0, [x19, 9]
	adrp	x0, .LANCHOR18
	ldrb	w3, [x0, #:lo12:.LANCHOR18]
.L1297:
	cmp	w3, w1, uxtb
	bhi	.L1298
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L1298:
	ldrb	w0, [x1, x2]
	add	x1, x1, 1
	ldrb	w5, [x19, 10]
	lsl	w0, w4, w0
	orr	w0, w0, w5
	strb	w0, [x19, 10]
	b	.L1297
	.size	zftl_read_flash_info, .-zftl_read_flash_info
	.section	.text.gc_static_wearleveling,"ax",@progbits
	.align	2
	.global	gc_static_wearleveling
	.type	gc_static_wearleveling, %function
gc_static_wearleveling:
	stp	x29, x30, [sp, -160]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR104
	stp	x19, x20, [sp, 16]
	ldr	x0, [x23, #:lo12:.LANCHOR104]
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	ldr	w1, [x0, 32]
	mov	w0, 10240
	cmp	w1, w0
	bls	.L1301
	bl	ftl_tmp_into_update
.L1301:
	adrp	x19, .LANCHOR10
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	ldr	w1, [x0, 568]
	ldr	w2, [x0, 12]
	add	w1, w1, 860160
	add	w1, w1, 3840
	cmp	w2, w1
	bhi	.L1302
	ldr	x3, [x23, #:lo12:.LANCHOR104]
	ldr	w1, [x0, 572]
	add	w1, w1, 32
	ldr	w3, [x3, 36]
	cmp	w3, w1
	bls	.L1352
.L1302:
	ldr	x1, [x23, #:lo12:.LANCHOR104]
	mov	w20, 65535
	adrp	x8, .LANCHOR14
	mov	w21, w20
	add	x8, x8, :lo12:.LANCHOR14
	mov	w28, 0
	mov	w27, 0
	mov	w22, 0
	ldr	w3, [x1, 36]
	adrp	x24, .LANCHOR7
	ldrh	w25, [x1, 134]
	str	w2, [x0, 568]
	str	w3, [x0, 572]
	adrp	x0, .LANCHOR6
	add	x10, x0, :lo12:.LANCHOR6
	str	wzr, [x29, 128]
	str	wzr, [x29, 136]
	stp	wzr, wzr, [x29, 148]
	str	wzr, [x29, 156]
.L1304:
	ldrh	w0, [x10]
	cmp	w0, w25
	bhi	.L1313
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	mov	w2, 128
	mov	w1, 255
	adrp	x25, .LANCHOR14
	add	x0, x0, 264
	strh	wzr, [x0, -142]
	bl	ftl_memset
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	ldr	w3, [x25, #:lo12:.LANCHOR14]
	ldr	x2, [x24, #:lo12:.LANCHOR7]
	ldrh	w5, [x0, 586]
	mov	x1, x5
	lsl	x0, x5, 2
	add	x26, x2, x0
	tbz	x3, 10, .L1314
	adrp	x3, .LANCHOR9
	ldrb	w4, [x26, 2]
	ldr	x6, [x3, #:lo12:.LANCHOR9]
	ldr	w3, [x2, x0]
	ldrh	w2, [x2, x0]
	adrp	x0, .LC81
	add	x0, x0, :lo12:.LC81
	ldrh	w7, [x6, x5, lsl 1]
	ubfx	x3, x3, 11, 8
	ldrb	w6, [x26, 3]
	ubfx	x5, x4, 5, 3
	and	w2, w2, 2047
	ubfx	x4, x4, 3, 2
	bl	printf
.L1314:
	ldrb	w0, [x26, 2]
	and	w1, w0, 224
	cmp	w1, 32
	bne	.L1315
	ldr	x2, [x23, #:lo12:.LANCHOR104]
	ldrh	w2, [x2, 688]
	cmp	w2, 2
	bls	.L1315
	adrp	x2, .LANCHOR146
	mov	w3, 1
	str	w3, [x2, #:lo12:.LANCHOR146]
.L1315:
	ldrb	w2, [x26, 2]
	tbz	x2, 3, .L1316
	and	w0, w0, 192
	cmp	w0, 64
	bne	.L1317
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	mov	w1, 0
	mov	w2, 1
	ldrh	w0, [x0, 586]
	bl	gc_add_sblk
	adrp	x0, .LANCHOR64+574
	mov	w1, 1
	strh	w1, [x0, #:lo12:.LANCHOR64+574]
.L1316:
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	ldr	w3, [x25, #:lo12:.LANCHOR14]
	ldr	x2, [x24, #:lo12:.LANCHOR7]
	ldrh	w5, [x0, 584]
	mov	x1, x5
	lsl	x0, x5, 2
	add	x26, x2, x0
	tbz	x3, 10, .L1318
	adrp	x3, .LANCHOR9
	ldrb	w4, [x26, 2]
	ldr	x6, [x3, #:lo12:.LANCHOR9]
	ldr	w3, [x2, x0]
	ldrh	w2, [x2, x0]
	adrp	x0, .LC82
	add	x0, x0, :lo12:.LC82
	ldrh	w7, [x6, x5, lsl 1]
	ubfx	x3, x3, 11, 8
	ldrb	w6, [x26, 3]
	ubfx	x5, x4, 5, 3
	and	w2, w2, 2047
	ubfx	x4, x4, 3, 2
	bl	printf
.L1318:
	ldrb	w0, [x26, 2]
	tbz	x0, 3, .L1319
	ldrb	w0, [x26, 2]
	and	w1, w0, 192
	cmp	w1, 64
	bne	.L1320
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	mov	w1, 0
	mov	w2, 1
	ldrh	w0, [x0, 584]
	bl	gc_add_sblk
	adrp	x0, .LANCHOR64+574
	mov	w1, 1
	strh	w1, [x0, #:lo12:.LANCHOR64+574]
.L1319:
	ldr	w0, [x25, #:lo12:.LANCHOR14]
	tbz	x0, 10, .L1321
	ldr	w6, [x29, 128]
	adrp	x2, .LANCHOR9
	ldr	x1, [x24, #:lo12:.LANCHOR7]
	ldr	x7, [x2, #:lo12:.LANCHOR9]
	lsl	x0, x6, 2
	add	x5, x1, x0
	ldr	w3, [x1, x0]
	ldrh	w2, [x1, x0]
	adrp	x0, .LC83
	ldrh	w7, [x7, x6, lsl 1]
	add	x0, x0, :lo12:.LC83
	ldrb	w6, [x5, 3]
	ubfx	x3, x3, 11, 8
	ldr	w1, [x29, 128]
	and	w2, w2, 2047
	ldrb	w4, [x5, 2]
	ubfx	x5, x4, 5, 3
	ubfx	x4, x4, 3, 2
	bl	printf
.L1321:
	ldr	w0, [x25, #:lo12:.LANCHOR14]
	tbz	x0, 10, .L1322
	ldr	w6, [x29, 136]
	adrp	x2, .LANCHOR9
	ldr	x1, [x24, #:lo12:.LANCHOR7]
	ldr	x7, [x2, #:lo12:.LANCHOR9]
	lsl	x0, x6, 2
	add	x5, x1, x0
	ldr	w3, [x1, x0]
	ldrh	w2, [x1, x0]
	adrp	x0, .LC84
	ldrh	w7, [x7, x6, lsl 1]
	add	x0, x0, :lo12:.LC84
	ldrb	w6, [x5, 3]
	ubfx	x3, x3, 11, 8
	ldr	w1, [x29, 136]
	and	w2, w2, 2047
	ldrb	w4, [x5, 2]
	ubfx	x5, x4, 5, 3
	ubfx	x4, x4, 3, 2
	bl	printf
.L1322:
	ldr	x0, [x23, #:lo12:.LANCHOR104]
	ldrh	w1, [x29, 156]
	strh	w1, [x0, 96]
	ldr	w1, [x29, 148]
	strh	w22, [x0, 98]
	strh	w20, [x0, 92]
	strh	w21, [x0, 94]
	udiv	w3, w1, w27
	ldr	w1, [x29, 152]
	udiv	w4, w1, w28
	strh	w3, [x0, 88]
	strh	w4, [x0, 90]
	ldr	w0, [x25, #:lo12:.LANCHOR14]
	tbz	x0, 10, .L1323
	adrp	x0, .LC85
	and	w4, w4, 65535
	and	w3, w3, 65535
	mov	w2, w28
	mov	w1, w27
	add	x0, x0, :lo12:.LC85
	bl	printf
.L1323:
	ldr	w0, [x25, #:lo12:.LANCHOR14]
	tbz	x0, 10, .L1324
	adrp	x0, .LANCHOR147
	ldr	w3, [x29, 156]
	mov	w4, w22
	mov	w2, w21
	ldrh	w6, [x0, #:lo12:.LANCHOR147]
	adrp	x0, .LANCHOR148
	mov	w1, w20
	ldrh	w5, [x0, #:lo12:.LANCHOR148]
	adrp	x0, .LC86
	add	x0, x0, :lo12:.LC86
	bl	printf
.L1324:
	sub	w0, w22, w21
	str	w0, [x29, 148]
	adrp	x0, .LANCHOR147
	ldr	w1, [x29, 148]
	ldrh	w0, [x0, #:lo12:.LANCHOR147]
	cmp	w1, w0
	bgt	.L1325
	adrp	x1, .LANCHOR148
	ldr	w0, [x29, 156]
	ldrh	w1, [x1, #:lo12:.LANCHOR148]
	sub	w0, w0, w20
	cmp	w0, w1
	ble	.L1353
.L1325:
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	adrp	x28, .LANCHOR64
	add	x28, x28, :lo12:.LANCHOR64
	mov	w27, 0
	mov	w22, 0
	ldrh	w26, [x0, 580]
	ldr	x0, [x23, #:lo12:.LANCHOR104]
	ldrh	w0, [x0, 134]
	str	w0, [x29, 152]
	adrp	x0, .LANCHOR6
	add	x0, x0, :lo12:.LANCHOR6
	str	x0, [x29, 136]
	adrp	x0, .LANCHOR148
	add	x0, x0, :lo12:.LANCHOR148
	str	x0, [x29, 128]
.L1327:
	ldr	x0, [x29, 136]
	ldr	w1, [x29, 152]
	ldrh	w0, [x0]
	cmp	w1, w0
	bcc	.L1337
.L1336:
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	str	w26, [x0, 580]
.L1326:
	cbz	w21, .L1339
	ldr	x2, [x23, #:lo12:.LANCHOR104]
	adrp	x0, .LANCHOR6
	ldrh	w5, [x0, #:lo12:.LANCHOR6]
	ldr	x0, [x24, #:lo12:.LANCHOR7]
	ldrh	w1, [x2, 134]
	add	x0, x0, x1, uxth 2
.L1340:
	cmp	w1, w5
	bcc	.L1342
	ldrh	w0, [x2, 72]
	add	w0, w21, w0
	strh	w0, [x2, 72]
	ldrh	w0, [x2, 98]
	cmp	w21, w0
	bcs	.L1339
	sub	w21, w0, w21
	strh	w21, [x2, 98]
.L1339:
	cbz	w20, .L1345
	ldr	x2, [x23, #:lo12:.LANCHOR104]
	adrp	x0, .LANCHOR6
	ldrh	w6, [x0, #:lo12:.LANCHOR6]
	ldr	x0, [x24, #:lo12:.LANCHOR7]
	ldrh	w1, [x2, 134]
	add	x0, x0, x1, uxth 2
.L1346:
	cmp	w1, w6
	bcc	.L1348
	ldrh	w0, [x2, 74]
	add	w0, w20, w0
	strh	w0, [x2, 74]
	ldrh	w0, [x2, 96]
	cmp	w20, w0
	bcs	.L1345
	sub	w20, w0, w20
	strh	w20, [x2, 96]
.L1345:
	mov	w1, 5
	mov	w0, 0
	bl	zftl_get_gc_node
	and	w1, w0, 65535
	mov	w2, 65535
	cmp	w1, w2
	beq	.L1303
	adrp	x2, .LANCHOR9
	ubfiz	x1, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR9]
	ldrh	w2, [x2, x1]
	adrp	x1, .LANCHOR87
	ldrh	w1, [x1, #:lo12:.LANCHOR87]
	cmp	w2, w1
	bhi	.L1303
	add	w22, w22, 1
	mov	w2, 1
	mov	w1, 0
	bl	gc_add_sblk
.L1303:
	add	w0, w22, w27
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 160
	ret
.L1313:
	uxtw	x7, w25
	ldr	x6, [x24, #:lo12:.LANCHOR7]
	lsl	x2, x7, 2
	add	x11, x6, x2
	ldrb	w0, [x11, 2]
	and	w1, w0, 224
	cmp	w1, 224
	beq	.L1305
	ubfx	x4, x0, 3, 2
	tbz	x4, 0, .L1306
	ldr	w0, [x6, x2]
	ldrh	w1, [x6, x2]
	ubfx	x0, x0, 11, 8
	and	w1, w1, 2047
.L1307:
	ldr	w3, [x29, 148]
	add	w27, w27, 1
	and	w27, w27, 65535
	cmp	w20, w1
	add	w3, w3, w1
	str	w3, [x29, 148]
	bls	.L1351
	ldr	x3, [x19, #:lo12:.LANCHOR10]
	mov	w20, w1
	strh	w25, [x3, 586]
.L1351:
	ldr	w3, [x29, 156]
	cmp	w3, w1
	bcs	.L1310
	str	w25, [x29, 128]
	str	w1, [x29, 156]
.L1310:
	mov	w3, 65535
	cmp	w0, w3
	bne	.L1309
.L1311:
	cmp	w0, 9
	ccmp	w1, 9, 0, hi
	bhi	.L1305
	ldr	w0, [x8]
	tbz	x0, 8, .L1305
	adrp	x0, .LANCHOR9
	ldr	w3, [x6, x2]
	ldrh	w2, [x6, x2]
	mov	w1, w25
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrb	w6, [x11, 3]
	ubfx	x3, x3, 11, 8
	ldrb	w5, [x11, 2]
	and	w2, w2, 2047
	stp	x8, x10, [x29, 112]
	ldrh	w7, [x0, x7, lsl 1]
	adrp	x0, .LC80
	ubfx	x5, x5, 5, 3
	add	x0, x0, :lo12:.LC80
	bl	printf
	ldp	x8, x10, [x29, 112]
.L1305:
	add	w25, w25, 1
	and	w25, w25, 65535
	b	.L1304
.L1306:
	tst	w0, 24
	bne	.L1308
	ldrh	w1, [x6, x2]
	mov	w0, 65535
	and	w1, w1, 2047
	b	.L1307
.L1308:
	ldr	w0, [x6, x2]
	mov	w1, 65535
	ubfx	x0, x0, 11, 8
.L1309:
	ldr	w3, [x29, 152]
	add	w28, w28, 1
	and	w28, w28, 65535
	cmp	w21, w0
	add	w3, w3, w0
	str	w3, [x29, 152]
	bls	.L1312
	ldr	x3, [x19, #:lo12:.LANCHOR10]
	mov	w21, w0
	strh	w25, [x3, 584]
.L1312:
	cmp	w22, w0
	bcs	.L1311
	mov	w22, w0
	str	w25, [x29, 136]
	b	.L1311
.L1317:
	cbnz	w1, .L1316
	ldr	x1, [x19, #:lo12:.LANCHOR10]
	mov	w0, 65535
	ldrh	w2, [x1, 590]
	cmp	w2, w0
	bne	.L1316
	ldrh	w0, [x1, 586]
	ldrh	w1, [x1, 588]
	cmp	w1, w0
	beq	.L1316
	bl	zftl_remove_free_node
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	ldrh	w1, [x0, 586]
	strh	w1, [x0, 590]
	mov	w1, -1
	strh	w1, [x0, 586]
	b	.L1316
.L1320:
	and	w0, w0, 248
	cmp	w0, 16
	bne	.L1319
	ldr	x1, [x19, #:lo12:.LANCHOR10]
	mov	w0, 65535
	ldrh	w2, [x1, 588]
	cmp	w2, w0
	bne	.L1319
	ldrh	w0, [x1, 584]
	ldrh	w1, [x1, 590]
	cmp	w1, w0
	beq	.L1319
	bl	zftl_remove_free_node
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	ldrh	w1, [x0, 584]
	strh	w1, [x0, 588]
	mov	w1, -1
	strh	w1, [x0, 584]
	b	.L1319
.L1337:
	add	w7, w26, 1
	ldr	x4, [x24, #:lo12:.LANCHOR7]
	and	w26, w7, 65535
	cmp	w0, w26
	csel	w26, w26, wzr, hi
	uxtw	x8, w26
	lsl	x3, x8, 2
	add	x0, x4, x3
	ldrb	w0, [x0, 2]
	tst	w0, 192
	beq	.L1329
	and	w2, w0, 224
	cmp	w2, 224
	beq	.L1329
	ubfx	x0, x0, 3, 2
	and	w1, w0, 1
	tbz	x0, 0, .L1330
	cmp	w2, 160
.L1417:
	bne	.L1332
	adrp	x0, .LANCHOR147
	ldr	w2, [x29, 148]
	ldrh	w0, [x0, #:lo12:.LANCHOR147]
	cmp	w2, w0
	ble	.L1333
	ldr	w0, [x4, x3]
	ubfx	x0, x0, 11, 8
	cmp	w0, w21
	bls	.L1334
	cbz	w1, .L1333
	ldrh	w0, [x4, x3]
	and	w0, w0, 2047
	cmp	w0, w20
	bgt	.L1333
.L1334:
	stp	x4, x8, [x29, 104]
	mov	w2, 1
	str	x3, [x29, 120]
	mov	w1, 0
	mov	w0, w26
	bl	gc_add_sblk
	mov	w0, 1
	strh	w0, [x28, 574]
	ldr	w0, [x25, #:lo12:.LANCHOR14]
	add	w22, w22, 1
	ldp	x4, x8, [x29, 104]
	ldr	x3, [x29, 120]
	tbz	x0, 10, .L1333
	adrp	x0, .LANCHOR9
	ldr	w6, [x4, x3]
	ldrh	w5, [x4, x3]
	ldr	x1, [x0, #:lo12:.LANCHOR9]
	ldr	x0, [x24, #:lo12:.LANCHOR7]
	ubfx	x6, x6, 11, 8
	ldrh	w4, [x28, 56]
	and	w5, w5, 2047
	add	x3, x0, x3
	adrp	x0, .LC87
	add	x0, x0, :lo12:.LC87
	ldrb	w2, [x3, 2]
	ldrh	w3, [x1, x8, lsl 1]
	mov	w1, w26
	ubfx	x2, x2, 5, 3
.L1418:
	bl	printf
.L1333:
	cmp	w22, 4
	ccmp	w27, 4, 2, ls
	bhi	.L1336
.L1329:
	ldr	w0, [x29, 152]
	add	w0, w0, 1
	and	w0, w0, 65535
	str	w0, [x29, 152]
	b	.L1327
.L1330:
	cmp	w0, 2
	b	.L1417
.L1332:
	ldr	x2, [x29, 128]
	ldr	w0, [x29, 156]
	sub	w0, w0, w20
	ldrh	w2, [x2]
	cmp	w0, w2
	ble	.L1333
	ldrh	w0, [x4, x3]
	add	w2, w20, 8
	and	w0, w0, 2047
	cmp	w0, w2
	ble	.L1335
	cbz	w1, .L1333
	ldr	w0, [x4, x3]
	add	w1, w21, 4
	ubfx	x0, x0, 11, 8
	cmp	w0, w1
	bgt	.L1333
.L1335:
	stp	x4, x8, [x29, 104]
	mov	w2, 1
	str	x3, [x29, 120]
	mov	w1, 0
	mov	w0, w26
	bl	gc_add_sblk
	mov	w0, 1
	strh	w0, [x28, 574]
	ldr	w0, [x25, #:lo12:.LANCHOR14]
	add	w27, w27, 1
	ldp	x4, x8, [x29, 104]
	ldr	x3, [x29, 120]
	tbz	x0, 10, .L1333
	adrp	x0, .LANCHOR9
	ldr	w6, [x4, x3]
	ldrh	w5, [x4, x3]
	ldr	x1, [x0, #:lo12:.LANCHOR9]
	ldr	x0, [x24, #:lo12:.LANCHOR7]
	ubfx	x6, x6, 11, 8
	and	w5, w5, 2047
	ldrh	w4, [x28, 56]
	add	x3, x0, x3
	adrp	x0, .LC88
	add	x0, x0, :lo12:.LC88
	ldrb	w2, [x3, 2]
	ldrh	w3, [x1, x8, lsl 1]
	mov	w1, w26
	ubfx	x2, x2, 5, 3
	b	.L1418
.L1353:
	mov	w27, 0
	mov	w22, 0
	b	.L1326
.L1342:
	ldr	w3, [x0]
	ubfx	x4, x3, 11, 8
	cmp	w21, w4
	bhi	.L1341
	ldrb	w6, [x0, 2]
	tst	w6, 24
	beq	.L1341
	sub	w4, w4, w21
	bfi	w3, w4, 11, 8
	str	w3, [x0]
.L1341:
	add	w1, w1, 1
	add	x0, x0, 4
	and	w1, w1, 65535
	b	.L1340
.L1348:
	ldrh	w3, [x0]
	and	w4, w3, 2047
	cmp	w4, w20
	blt	.L1347
	ldrb	w5, [x0, 2]
	and	w5, w5, 24
	cmp	w5, 16
	beq	.L1347
	sub	w4, w4, w20
	bfi	w3, w4, 0, 11
	strh	w3, [x0]
.L1347:
	add	w1, w1, 1
	add	x0, x0, 4
	and	w1, w1, 65535
	b	.L1346
.L1352:
	mov	w27, 0
	mov	w22, 0
	b	.L1303
	.size	gc_static_wearleveling, .-gc_static_wearleveling
	.section	.text.zftl_sblk_list_init,"ax",@progbits
	.align	2
	.global	zftl_sblk_list_init
	.type	zftl_sblk_list_init, %function
zftl_sblk_list_init:
	stp	x29, x30, [sp, -192]!
	mov	w0, 6
	mov	w1, 0
	add	x29, sp, 0
	stp	x27, x28, [sp, 80]
	adrp	x27, .LANCHOR6
	adrp	x28, .LANCHOR4
	stp	x19, x20, [sp, 16]
	ldrh	w2, [x27, #:lo12:.LANCHOR6]
	adrp	x20, .LANCHOR94
	stp	x21, x22, [sp, 32]
	adrp	x19, .LANCHOR90
	stp	x23, x24, [sp, 48]
	adrp	x22, .LANCHOR101
	stp	x25, x26, [sp, 64]
	adrp	x25, .LANCHOR104
	mul	w2, w2, w0
	ldr	x0, [x28, #:lo12:.LANCHOR4]
	adrp	x24, .LANCHOR97
	adrp	x23, .LANCHOR99
	adrp	x21, .LANCHOR92
	bl	ftl_memset
	str	x28, [x29, 168]
	adrp	x0, .LANCHOR103
	adrp	x2, .LANCHOR80
	adrp	x3, .LANCHOR79
	mov	w1, 16
	strh	w1, [x0, #:lo12:.LANCHOR103]
	adrp	x10, .LANCHOR98
	ldrb	w0, [x2, #:lo12:.LANCHOR80]
	adrp	x8, .LANCHOR100
	ldrh	w1, [x3, #:lo12:.LANCHOR79]
	adrp	x7, .LANCHOR102
	adrp	x6, .LANCHOR83
	adrp	x5, .LANCHOR12
	adrp	x4, .LANCHOR82
	str	xzr, [x10, #:lo12:.LANCHOR98]
	str	xzr, [x8, #:lo12:.LANCHOR100]
	adrp	x28, .LANCHOR7
	mul	w1, w0, w1
	mov	w0, 32768
	str	xzr, [x7, #:lo12:.LANCHOR102]
	str	xzr, [x6, #:lo12:.LANCHOR83]
	str	xzr, [x5, #:lo12:.LANCHOR12]
	sdiv	w0, w0, w1
	str	xzr, [x4, #:lo12:.LANCHOR82]
	strh	wzr, [x24, #:lo12:.LANCHOR97]
	strh	wzr, [x23, #:lo12:.LANCHOR99]
	strh	wzr, [x22, #:lo12:.LANCHOR101]
	sxth	w0, w0
	str	w0, [x29, 188]
	ldr	x0, [x25, #:lo12:.LANCHOR104]
	strh	wzr, [x21, #:lo12:.LANCHOR92]
	strh	wzr, [x20, #:lo12:.LANCHOR94]
	strh	wzr, [x19, #:lo12:.LANCHOR90]
	strh	wzr, [x0, 146]
	ldrsh	w26, [x0, 134]
	add	x0, x27, :lo12:.LANCHOR6
	adrp	x27, .LC89
	add	x27, x27, :lo12:.LC89
	stp	x3, x2, [x29, 104]
	stp	x4, x5, [x29, 120]
	stp	x6, x7, [x29, 136]
	stp	x8, x10, [x29, 152]
	str	x0, [x29, 176]
.L1420:
	ldr	x0, [x29, 176]
	ldrh	w0, [x0]
	cmp	w26, w0
	blt	.L1436
	ldr	x0, [x25, #:lo12:.LANCHOR104]
	ldrh	w1, [x24, #:lo12:.LANCHOR97]
	ldp	x25, x26, [sp, 64]
	strh	w1, [x0, 114]
	ldrh	w1, [x23, #:lo12:.LANCHOR99]
	strh	w1, [x0, 118]
	ldrh	w1, [x22, #:lo12:.LANCHOR101]
	strh	w1, [x0, 116]
	ldrh	w1, [x21, #:lo12:.LANCHOR92]
	strh	w1, [x0, 122]
	ldrh	w1, [x20, #:lo12:.LANCHOR94]
	strh	w1, [x0, 120]
	ldrh	w1, [x19, #:lo12:.LANCHOR90]
	strh	w1, [x0, 124]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 192
	ret
.L1436:
	ldr	x4, [x28, #:lo12:.LANCHOR7]
	sxtw	x2, w26
	add	x4, x4, x2, lsl 2
	ldrb	w6, [x4, 3]
	cbz	w6, .L1437
	ldr	x0, [x29, 112]
	mov	w1, 0
	ldr	x7, [x25, #:lo12:.LANCHOR104]
	ldrb	w8, [x0, #:lo12:.LANCHOR80]
	ldr	x0, [x29, 104]
	ldrh	w10, [x0, #:lo12:.LANCHOR79]
	mov	w0, 0
.L1422:
	cmp	w1, w8
	blt	.L1425
	cbz	w0, .L1426
	mov	w1, 32768
	sdiv	w0, w1, w0
	add	w0, w0, 1
	sxth	w0, w0
.L1421:
	ldr	x3, [x29, 168]
	mov	w1, 6
	smull	x1, w26, w1
	ldr	x5, [x3, #:lo12:.LANCHOR4]
	add	x6, x5, x1
	strh	w0, [x6, 4]
	mov	w0, -1
	strh	w0, [x6, 2]
	strh	w0, [x5, x1]
	mov	w5, 224
	ldrb	w1, [x4, 2]
	and	w0, w1, 224
	cmp	w0, 32
	ccmp	w0, w5, 4, ne
	beq	.L1427
	adrp	x5, .LANCHOR10
	ldr	x5, [x5, #:lo12:.LANCHOR10]
	ldrh	w6, [x5, 16]
	cmp	w26, w6
	beq	.L1427
	ldrh	w6, [x5, 48]
	cmp	w26, w6
	beq	.L1427
	ldrh	w5, [x5, 80]
	cmp	w26, w5
	beq	.L1427
	cmp	w0, 64
	bne	.L1428
	ldr	x0, [x29, 128]
	add	x2, x21, :lo12:.LANCHOR92
	mov	w1, w26
	add	x0, x0, :lo12:.LANCHOR12
.L1440:
	bl	_insert_data_list
.L1427:
	add	w3, w26, 1
	sxth	w26, w3
	b	.L1420
.L1425:
	asr	w5, w6, w1
	tbnz	x5, 0, .L1423
	add	w0, w10, w0
	sxth	w0, w0
.L1424:
	add	w1, w1, 1
	b	.L1422
.L1423:
	ldrh	w5, [x7, 146]
	add	w5, w5, 1
	strh	w5, [x7, 146]
	b	.L1424
.L1426:
	ldrb	w1, [x4, 2]
	mov	w5, -1
	orr	w1, w1, -32
	strb	w1, [x4, 2]
	adrp	x1, .LANCHOR9
	ldr	x1, [x1, #:lo12:.LANCHOR9]
	strh	w5, [x1, x2, lsl 1]
	b	.L1421
.L1437:
	ldr	w0, [x29, 188]
	b	.L1421
.L1428:
	cmp	w0, 96
	bne	.L1429
	ldr	x0, [x29, 136]
	add	x2, x19, :lo12:.LANCHOR90
	mov	w1, w26
	add	x0, x0, :lo12:.LANCHOR83
	b	.L1440
.L1429:
	cmp	w0, 160
	bne	.L1430
	ldr	x0, [x29, 120]
	add	x2, x20, :lo12:.LANCHOR94
	mov	w1, w26
	add	x0, x0, :lo12:.LANCHOR82
	b	.L1440
.L1430:
	cbnz	w0, .L1427
	adrp	x0, .LANCHOR9
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrh	w2, [x0, x2, lsl 1]
	cbz	w2, .L1431
	str	x4, [x29, 96]
	mov	w1, w26
	mov	x0, x27
	bl	printf
	ldr	x4, [x29, 96]
	ldrb	w0, [x4, 2]
	tbz	x0, 4, .L1432
	mov	w1, 5
.L1439:
	bfi	w0, w1, 5, 3
	strb	w0, [x4, 2]
	mov	w2, 0
	mov	w1, 1
	mov	w0, w26
	bl	gc_add_sblk
	b	.L1427
.L1432:
	mov	w1, 2
	b	.L1439
.L1431:
	ands	w1, w1, 24
	bne	.L1434
	ldr	x0, [x29, 160]
	add	x2, x24, :lo12:.LANCHOR97
	mov	w1, w26
	add	x0, x0, :lo12:.LANCHOR98
.L1441:
	bl	_insert_free_list
	b	.L1427
.L1434:
	cmp	w1, 16
	bne	.L1435
	ldr	x0, [x29, 152]
	add	x2, x23, :lo12:.LANCHOR99
	mov	w1, w26
	add	x0, x0, :lo12:.LANCHOR100
	b	.L1441
.L1435:
	ldr	x0, [x29, 144]
	add	x2, x22, :lo12:.LANCHOR101
	mov	w1, w26
	add	x0, x0, :lo12:.LANCHOR102
	b	.L1441
	.size	zftl_sblk_list_init, .-zftl_sblk_list_init
	.section	.text.pm_free_sblk,"ax",@progbits
	.align	2
	.global	pm_free_sblk
	.type	pm_free_sblk, %function
pm_free_sblk:
	stp	x29, x30, [sp, -384]!
	adrp	x0, .LANCHOR149
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	ldrh	w1, [x0, #:lo12:.LANCHOR149]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	cmp	w1, 128
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	bls	.L1443
	adrp	x1, .LANCHOR150
	adrp	x0, .LC0
	mov	w2, 84
	add	x1, x1, :lo12:.LANCHOR150
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1443:
	adrp	x5, .LANCHOR104
	mov	x26, x5
	ldrh	w3, [x19, #:lo12:.LANCHOR149]
	mov	w1, 0
	ldr	x0, [x5, #:lo12:.LANCHOR104]
	mov	w19, 0
	mov	w4, 65535
	add	x0, x0, 416
	ldrh	w2, [x0, 272]
.L1446:
	ldrh	w6, [x0]
	cmp	w6, w4
	beq	.L1444
	add	w1, w1, 1
	and	w1, w1, 65535
.L1444:
	cmp	w1, w2
	bcs	.L1445
	cmp	w1, w3
	bcs	.L1445
	add	w19, w19, 1
	add	x0, x0, 2
	and	w19, w19, 65535
	cmp	w19, 128
	bne	.L1446
.L1445:
	add	w19, w19, 1
	mov	w0, 128
	and	w19, w19, 65535
	add	x22, x29, 128
	cmp	w19, 129
	mov	w2, 256
	csel	w19, w19, w0, ne
	mov	w1, 0
	mov	x0, x22
	adrp	x23, .LANCHOR69
	bl	ftl_memset
	adrp	x0, .LANCHOR68
	ldr	x6, [x26, #:lo12:.LANCHOR104]
	mov	w2, 24
	ldrb	w11, [x23, #:lo12:.LANCHOR69]
	ldrh	w10, [x0, #:lo12:.LANCHOR68]
	adrp	x0, .LANCHOR31
	add	x4, x6, 704
	ldrb	w0, [x0, #:lo12:.LANCHOR31]
	ldrh	w1, [x6, 698]
	sub	w2, w2, w0
	sub	w0, w2, w10
	add	x1, x1, 176
	mov	w2, 1
	add	x1, x6, x1, lsl 2
	lsl	w2, w2, w0
	sub	w2, w2, #1
.L1448:
	cmp	x1, x4
	bne	.L1451
	adrp	x24, .LANCHOR80
	adrp	x25, .LANCHOR87
	adrp	x27, .LC90
	adrp	x28, .LANCHOR14
	ldrb	w21, [x24, #:lo12:.LANCHOR80]
	add	x23, x23, :lo12:.LANCHOR69
	ldrh	w0, [x25, #:lo12:.LANCHOR87]
	add	x27, x27, :lo12:.LC90
	add	x28, x28, :lo12:.LANCHOR14
	mov	x20, 0
	mov	w7, 65535
	str	wzr, [x29, 124]
	mul	w21, w21, w0
	and	w21, w21, 65535
.L1457:
	ldr	x0, [x26, #:lo12:.LANCHOR104]
	and	w6, w20, 65535
	ldrb	w2, [x23]
	mov	w8, w20
	add	x1, x0, x20, sxtw 1
	ldrh	w3, [x1, 416]
	ldrh	w1, [x0, 692]
	sdiv	w1, w1, w2
	cmp	w1, w3
	bne	.L1452
	ldrb	w1, [x24, #:lo12:.LANCHOR80]
	ldrh	w2, [x25, #:lo12:.LANCHOR87]
	mul	w1, w1, w2
	strh	w1, [x22, x20, lsl 1]
.L1452:
	ldrh	w2, [x22, x20, lsl 1]
	cmp	w2, w21
	bcs	.L1453
	cmp	w2, 0
	ldr	w1, [x29, 124]
	csel	w21, w21, w2, eq
	csel	w1, w1, w6, eq
	str	w1, [x29, 124]
.L1453:
	ldrh	w1, [x0, 74]
	cmp	w1, 2
	bls	.L1454
	mov	w1, 65535
	cmp	w3, w1
	beq	.L1454
	adrp	x4, .LANCHOR7
	ubfiz	x1, x3, 2, 16
	ldrh	w0, [x0, 92]
	ldr	x4, [x4, #:lo12:.LANCHOR7]
	add	w0, w0, 4
	ldrh	w4, [x4, x1]
	and	w4, w4, 2047
	cmp	w4, w0
	bgt	.L1454
	mov	w1, w8
	str	w6, [x29, 104]
	str	w8, [x29, 112]
	mov	x0, x27
	bl	printf
	ldr	w6, [x29, 104]
	ldr	w8, [x29, 112]
	mov	w7, w6
.L1454:
	ldrh	w0, [x22, x20, lsl 1]
	cbnz	w0, .L1455
	ldr	x0, [x26, #:lo12:.LANCHOR104]
	sxtw	x6, w8
	add	x1, x6, 208
	ldrh	w3, [x0, x1, lsl 1]
	mov	w1, 65535
	cmp	w3, w1
	beq	.L1455
	ldr	w1, [x28]
	tbz	x1, 12, .L1456
	ldrh	w4, [x0, 688]
	mov	w2, 0
	str	x6, [x29, 104]
	mov	w1, w8
	str	w7, [x29, 112]
	adrp	x0, .LC91
	add	x0, x0, :lo12:.LC91
	bl	printf
	ldr	w7, [x29, 112]
	ldr	x6, [x29, 104]
.L1456:
	ldr	x0, [x26, #:lo12:.LANCHOR104]
	add	x6, x6, 208
	str	w7, [x29, 104]
	str	x6, [x29, 112]
	ldrh	w0, [x0, x6, lsl 1]
	bl	ftl_free_sblk
	ldr	x0, [x26, #:lo12:.LANCHOR104]
	mov	w1, -1
	ldr	x6, [x29, 112]
	ldr	w7, [x29, 104]
	strh	w1, [x0, x6, lsl 1]
	ldrh	w1, [x0, 688]
	sub	w1, w1, #1
	strh	w1, [x0, 688]
.L1455:
	add	x20, x20, 1
	cmp	w19, w20, uxth
	bhi	.L1457
	mov	w0, 65535
	cmp	w7, w0
	ldr	w0, [x29, 124]
	ldp	x19, x20, [sp, 16]
	csel	w0, w0, w7, eq
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 384
	ret
.L1451:
	ldr	w0, [x4]
	add	x7, x6, 416
	mov	x3, 0
	lsr	w0, w0, w10
	and	w0, w0, w2
	udiv	w0, w0, w11
	and	w0, w0, 65535
.L1450:
	ldrh	w8, [x7]
	cmp	w8, w0
	bne	.L1449
	ldrh	w8, [x22, x3, lsl 1]
	add	w8, w8, 1
	strh	w8, [x22, x3, lsl 1]
.L1449:
	add	x3, x3, 1
	add	x7, x7, 2
	cmp	w19, w3, uxth
	bhi	.L1450
	add	x4, x4, 4
	b	.L1448
	.size	pm_free_sblk, .-pm_free_sblk
	.section	.text.ftl_memcpy,"ax",@progbits
	.align	2
	.global	ftl_memcpy
	.type	ftl_memcpy, %function
ftl_memcpy:
	uxtw	x2, w2
	b	memcpy
	.size	ftl_memcpy, .-ftl_memcpy
	.section	.text.flash_info_data_init,"ax",@progbits
	.align	2
	.global	flash_info_data_init
	.type	flash_info_data_init, %function
flash_info_data_init:
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR14
	add	x29, sp, 0
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	str	x19, [sp, 16]
	tbz	x0, 12, .L1470
	adrp	x2, .LANCHOR151
	adrp	x0, .LC92
	add	x2, x2, :lo12:.LANCHOR151
	mov	w1, 105
	add	x0, x0, :lo12:.LC92
	bl	printf
.L1470:
	adrp	x19, .LANCHOR27
	mov	w2, 2048
	mov	w1, 0
	ldr	x0, [x19, #:lo12:.LANCHOR27]
	bl	ftl_memset
	ldr	x0, [x19, #:lo12:.LANCHOR27]
	mov	w1, 21321
	movk	w1, 0x5359, lsl 16
	mov	w2, 32
	add	x0, x0, 80
	str	w1, [x0, -80]
	mov	w1, 2032
	str	w1, [x0, -72]
	mov	w1, 1
	strh	w1, [x0, -64]
	adrp	x1, .LANCHOR20
	add	x1, x1, :lo12:.LANCHOR20
	bl	ftl_memcpy
	ldr	x0, [x19, #:lo12:.LANCHOR27]
	mov	w2, 32
	ldr	x19, [sp, 16]
	adrp	x1, .LANCHOR32
	ldp	x29, x30, [sp], 32
	add	x1, x1, :lo12:.LANCHOR32
	add	x0, x0, 48
	b	ftl_memcpy
	.size	flash_info_data_init, .-flash_info_data_init
	.section	.text.ftl_memcpy32,"ax",@progbits
	.align	2
	.global	ftl_memcpy32
	.type	ftl_memcpy32, %function
ftl_memcpy32:
	mov	x3, 0
.L1476:
	cmp	w2, w3
	bhi	.L1477
	ret
.L1477:
	ldr	w4, [x1, x3, lsl 2]
	str	w4, [x0, x3, lsl 2]
	add	x3, x3, 1
	b	.L1476
	.size	ftl_memcpy32, .-ftl_memcpy32
	.section	.text.ftl_memcmp,"ax",@progbits
	.align	2
	.global	ftl_memcmp
	.type	ftl_memcmp, %function
ftl_memcmp:
	uxtw	x2, w2
	b	memcmp
	.size	ftl_memcmp, .-ftl_memcmp
	.section	.text.rknand_get_clk_rate,"ax",@progbits
	.align	2
	.global	rknand_get_clk_rate
	.type	rknand_get_clk_rate, %function
rknand_get_clk_rate:
	mov	w0, 19712
	movk	w0, 0x8d2, lsl 16
	ret
	.size	rknand_get_clk_rate, .-rknand_get_clk_rate
	.section	.text.ftl_malloc,"ax",@progbits
	.align	2
	.global	ftl_malloc
	.type	ftl_malloc, %function
ftl_malloc:
	mov	w1, 0
	sxtw	x0, w0
	b	kmalloc
	.size	ftl_malloc, .-ftl_malloc
	.section	.text.nandc_init,"ax",@progbits
	.align	2
	.global	nandc_init
	.type	nandc_init, %function
nandc_init:
	stp	x29, x30, [sp, -64]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR14
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	str	wzr, [x29, 56]
	tbz	x0, 12, .L1482
	adrp	x1, .LANCHOR152
	adrp	x0, .LC93
	mov	x2, x19
	add	x1, x1, :lo12:.LANCHOR152
	add	x0, x0, :lo12:.LC93
	bl	printf
.L1482:
	adrp	x20, .LANCHOR28
	mov	w0, 6
	ldr	w2, [x19, 352]
	mov	w1, 12336
	strb	w0, [x20, #:lo12:.LANCHOR28]
	adrp	x0, .LANCHOR13
	movk	w1, 0x5638, lsl 16
	mov	x22, x0
	str	x19, [x0, #:lo12:.LANCHOR13]
	cmp	w2, w1
	bne	.L1483
	mov	w0, 8
	strb	w0, [x20, #:lo12:.LANCHOR28]
.L1483:
	ldr	w1, [x19, 128]
	mov	w0, 12336
	movk	w0, 0x5639, lsl 16
	cmp	w1, w0
	bne	.L1484
	mov	w0, 9
	strb	w0, [x20, #:lo12:.LANCHOR28]
.L1484:
	ldrb	w0, [x20, #:lo12:.LANCHOR28]
	cmp	w0, 9
	adrp	x0, .LANCHOR47
	bne	.L1485
	mov	w1, 1
	strb	w1, [x0, #:lo12:.LANCHOR47]
	ldr	w0, [x29, 56]
	mov	w1, 2
	orr	w0, w0, 256
	str	w0, [x29, 56]
	ldr	w0, [x29, 56]
	bfi	w0, w1, 18, 3
	str	w0, [x29, 56]
	ldr	w0, [x29, 56]
	str	w0, [x19]
	str	wzr, [x19, 520]
	mov	w0, 4161
	str	w0, [x19, 4]
	mov	w0, 8321
	str	w0, [x19, 8]
	mov	w0, 4099
	movk	w0, 0x10, lsl 16
	str	w0, [x19, 80]
	mov	w0, 38
	str	w0, [x19, 84]
	mov	w0, 39
	str	w0, [x19, 84]
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L1487
	ldr	w1, [x19]
	ldr	w2, [x19, 8]
	ldr	w3, [x19, 80]
	ldr	w4, [x19, 84]
	ldr	w5, [x19, 88]
.L1500:
	adrp	x0, .LC94
	add	x0, x0, :lo12:.LC94
	bl	printf
.L1487:
	adrp	x0, .LANCHOR48
	mov	w1, 1
	strb	w1, [x0, #:lo12:.LANCHOR48]
	adrp	x0, .LANCHOR50
	strh	wzr, [x0, #:lo12:.LANCHOR50]
	adrp	x0, .LANCHOR46
	strb	wzr, [x0, #:lo12:.LANCHOR46]
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L1481
	ldrb	w1, [x20, #:lo12:.LANCHOR28]
	adrp	x0, .LC95
	add	x0, x0, :lo12:.LC95
	bl	printf
.L1481:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L1485:
	strb	wzr, [x0, #:lo12:.LANCHOR47]
	mov	w1, 1
	ldr	w0, [x29, 56]
	orr	w0, w0, 256
	str	w0, [x29, 56]
	ldr	w0, [x29, 56]
	bfi	w0, w1, 24, 3
	str	w0, [x29, 56]
	ldr	w0, [x29, 56]
	str	w0, [x19]
	str	wzr, [x19, 336]
	mov	w0, 4193
	str	w0, [x19, 4]
	mov	w0, 8321
	str	w0, [x19, 344]
	mov	w0, 4099
	movk	w0, 0x10, lsl 16
	str	w0, [x19, 304]
	mov	w0, 38
	str	w0, [x19, 308]
	mov	w0, 39
	str	w0, [x19, 308]
	mov	w0, 2048
	bl	ftl_malloc
	adrp	x1, .LANCHOR49
	str	x0, [x1, #:lo12:.LANCHOR49]
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L1487
	ldr	x0, [x22, #:lo12:.LANCHOR13]
	ldr	w1, [x0]
	ldr	w2, [x0, 344]
	ldr	w3, [x0, 304]
	ldr	w4, [x0, 308]
	ldr	w5, [x0, 312]
	b	.L1500
	.size	nandc_init, .-nandc_init
	.section	.text.zbuf_init,"ax",@progbits
	.align	2
	.global	zbuf_init
	.type	zbuf_init, %function
zbuf_init:
	stp	x29, x30, [sp, -48]!
	adrp	x0, .LANCHOR52
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	add	x19, x0, :lo12:.LANCHOR52
	stp	x21, x22, [sp, 32]
	mov	x20, x0
	adrp	x22, .LANCHOR125
	add	x22, x22, :lo12:.LANCHOR125
	mov	w21, 0
.L1502:
	and	w0, w21, 255
	strb	w0, [x19, 1]
	add	w1, w0, 1
	ldrb	w0, [x22]
	strb	w1, [x19]
	add	w21, w21, 1
	strb	wzr, [x19, 2]
	add	x19, x19, 64
	str	xzr, [x19, -48]
	lsl	w0, w0, 9
	bl	ftl_malloc
	str	x0, [x19, -56]
	mov	w0, 64
	bl	ftl_malloc
	str	x0, [x19, -40]
	cmp	w21, 32
	bne	.L1502
	add	x0, x20, :lo12:.LANCHOR52
	mov	w1, -1
	strb	w1, [x0, 1984]
	adrp	x0, .LANCHOR53
	strb	wzr, [x0, #:lo12:.LANCHOR53]
	adrp	x0, .LANCHOR54
	ldp	x19, x20, [sp, 16]
	strb	w21, [x0, #:lo12:.LANCHOR54]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
	.size	zbuf_init, .-zbuf_init
	.section	.text.gc_init,"ax",@progbits
	.align	2
	.global	gc_init
	.type	gc_init, %function
gc_init:
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR78
	mov	w2, 600
	mov	w1, 0
	add	x29, sp, 0
	strb	wzr, [x0, #:lo12:.LANCHOR78]
	adrp	x0, .LANCHOR153
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR64
	strb	wzr, [x0, #:lo12:.LANCHOR153]
	adrp	x0, .LANCHOR154
	add	x19, x20, :lo12:.LANCHOR64
	str	wzr, [x0, #:lo12:.LANCHOR154]
	adrp	x0, .LANCHOR89
	strh	wzr, [x0, #:lo12:.LANCHOR89]
	mov	x0, x19
	bl	ftl_memset
	str	xzr, [x19, 8]
	mov	w0, -1
	strh	w0, [x20, #:lo12:.LANCHOR64]
	adrp	x0, .LANCHOR87
	adrp	x4, .LANCHOR96
	adrp	x20, .LANCHOR79
	ldrh	w1, [x0, #:lo12:.LANCHOR87]
	lsr	w2, w1, 1
	lsr	w0, w1, 2
	strh	w2, [x19, 38]
	adrp	x2, .LANCHOR88
	strh	w0, [x19, 36]
	adrp	x19, .LANCHOR80
	strh	wzr, [x2, #:lo12:.LANCHOR88]
	adrp	x2, .LANCHOR84
	ldrb	w3, [x19, #:lo12:.LANCHOR80]
	strh	wzr, [x2, #:lo12:.LANCHOR84]
	adrp	x2, .LANCHOR85
	strh	wzr, [x2, #:lo12:.LANCHOR85]
	mul	w2, w1, w3
	and	w2, w2, 65535
	sub	w5, w2, #32
	strh	w5, [x4, #:lo12:.LANCHOR96]
	adrp	x4, .LANCHOR93
	strh	w2, [x4, #:lo12:.LANCHOR93]
	adrp	x2, .LANCHOR86
	strh	w1, [x2, #:lo12:.LANCHOR86]
	adrp	x1, .LANCHOR63
	strh	w0, [x1, #:lo12:.LANCHOR63]
	ldrh	w0, [x20, #:lo12:.LANCHOR79]
	mul	w0, w0, w3
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR155
	str	x0, [x1, #:lo12:.LANCHOR155]
	ldrb	w1, [x19, #:lo12:.LANCHOR80]
	ldrh	w0, [x20, #:lo12:.LANCHOR79]
	mul	w0, w0, w1
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR156
	str	x0, [x1, #:lo12:.LANCHOR156]
	ldrh	w1, [x20, #:lo12:.LANCHOR79]
	ldrb	w0, [x19, #:lo12:.LANCHOR80]
	mul	w0, w1, w0
	bl	ftl_malloc
	adrp	x1, .LANCHOR76
	str	x0, [x1, #:lo12:.LANCHOR76]
	ldrb	w1, [x19, #:lo12:.LANCHOR80]
	ldrh	w0, [x20, #:lo12:.LANCHOR79]
	mul	w0, w0, w1
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR70
	str	x0, [x1, #:lo12:.LANCHOR70]
	ldrb	w1, [x19, #:lo12:.LANCHOR80]
	ldrh	w0, [x20, #:lo12:.LANCHOR79]
	mul	w0, w0, w1
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR157
	ldp	x19, x20, [sp, 16]
	str	x0, [x1, #:lo12:.LANCHOR157]
	adrp	x0, .LANCHOR91
	adrp	x1, .LANCHOR81
	ldp	x29, x30, [sp], 32
	ldrh	w0, [x0, #:lo12:.LANCHOR91]
	lsr	w0, w0, 2
	strh	w0, [x1, #:lo12:.LANCHOR81]
	ret
	.size	gc_init, .-gc_init
	.section	.text.ftl_free,"ax",@progbits
	.align	2
	.global	ftl_free
	.type	ftl_free, %function
ftl_free:
	b	free
	.size	ftl_free, .-ftl_free
	.section	.text.js_hash,"ax",@progbits
	.align	2
	.global	js_hash
	.type	js_hash, %function
js_hash:
	mov	x4, x0
	mov	w0, 42982
	mov	x3, 0
	movk	w0, 0x47c6, lsl 16
.L1509:
	cmp	w1, w3
	bhi	.L1510
	ret
.L1510:
	lsr	w2, w0, 2
	ldrb	w5, [x4, x3]
	add	w2, w2, w0, lsl 5
	add	x3, x3, 1
	add	w2, w2, w5
	eor	w0, w0, w2
	b	.L1509
	.size	js_hash, .-js_hash
	.section	.text.timer_get_time,"ax",@progbits
	.align	2
	.global	timer_get_time
	.type	timer_get_time, %function
timer_get_time:
	mov	w0, 0
	ret
	.size	timer_get_time, .-timer_get_time
	.section	.text.FlashCs123Init,"ax",@progbits
	.align	2
	.global	FlashCs123Init
	.type	FlashCs123Init, %function
FlashCs123Init:
	ret
	.size	FlashCs123Init, .-FlashCs123Init
	.section	.text.rk_nand_de_init,"ax",@progbits
	.align	2
	.global	rk_nand_de_init
	.type	rk_nand_de_init, %function
rk_nand_de_init:
	b	zftl_flash_de_init
	.size	rk_nand_de_init, .-rk_nand_de_init
	.section	.text.ftl_get_density,"ax",@progbits
	.align	2
	.global	ftl_get_density
	.type	ftl_get_density, %function
ftl_get_density:
	and	w0, w0, 255
	b	zftl_get_density
	.size	ftl_get_density, .-ftl_get_density
	.section	.text.ftl_get_capacity,"ax",@progbits
	.align	2
	.global	ftl_get_capacity
	.type	ftl_get_capacity, %function
ftl_get_capacity:
	adrp	x0, .LANCHOR61
	ldr	w0, [x0, #:lo12:.LANCHOR61]
	ret
	.size	ftl_get_capacity, .-ftl_get_capacity
	.section	.text.rknand_print_hex,"ax",@progbits
	.align	2
	.global	rknand_print_hex
	.type	rknand_print_hex, %function
rknand_print_hex:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x21, .LC97
	stp	x23, x24, [sp, 48]
	mov	x22, x1
	stp	x25, x26, [sp, 64]
	adrp	x23, .LC96
	mov	x26, x0
	mov	w24, w2
	uxtw	x25, w3
	add	x23, x23, :lo12:.LC96
	add	x21, x21, :lo12:.LC97
	stp	x19, x20, [sp, 16]
	str	x27, [sp, 80]
	mov	x19, 0
	mov	w20, 0
	adrp	x27, .LC98
.L1517:
	cmp	x25, x19
	bne	.L1523
	ldp	x19, x20, [sp, 16]
	adrp	x1, .LC98
	ldp	x21, x22, [sp, 32]
	add	x1, x1, :lo12:.LC98
	ldp	x23, x24, [sp, 48]
	adrp	x0, .LC99
	ldp	x25, x26, [sp, 64]
	add	x0, x0, :lo12:.LC99
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 96
	b	printf
.L1523:
	cbnz	w20, .L1518
	mov	w2, w19
	mov	x1, x26
	mov	x0, x23
	bl	printf
.L1518:
	cmp	w24, 4
	bne	.L1519
	ldr	w1, [x22, x19, lsl 2]
.L1525:
	mov	x0, x21
	add	w20, w20, 1
	bl	printf
	cmp	w20, 15
	bls	.L1522
	mov	w20, 0
	add	x1, x27, :lo12:.LC98
	adrp	x0, .LC99
	add	x0, x0, :lo12:.LC99
	bl	printf
.L1522:
	add	x19, x19, 1
	b	.L1517
.L1519:
	cmp	w24, 2
	bne	.L1521
	ldrsh	w1, [x22, x19, lsl 1]
	b	.L1525
.L1521:
	ldrb	w1, [x22, x19]
	b	.L1525
	.size	rknand_print_hex, .-rknand_print_hex
	.section	.text.hynix_get_read_retry_default,"ax",@progbits
	.align	2
	.global	hynix_get_read_retry_default
	.type	hynix_get_read_retry_default, %function
hynix_get_read_retry_default:
	stp	x29, x30, [sp, -96]!
	mov	w8, w0
	adrp	x0, .LANCHOR27
	mov	w2, -83
	add	x29, sp, 0
	ldr	x7, [x0, #:lo12:.LANCHOR27]
	mov	w0, -84
	stp	x19, x20, [sp, 16]
	mov	w1, -82
	stp	x21, x22, [sp, 32]
	add	x6, x7, 128
	stp	x23, x24, [sp, 48]
	add	x12, x7, 112
	stp	x25, x26, [sp, 64]
	cmp	w8, 2
	str	x27, [sp, 80]
	strb	w0, [x7, 128]
	mov	w0, -81
	strb	w8, [x7, 112]
	strb	w2, [x7, 129]
	strb	w1, [x7, 130]
	strb	w0, [x7, 131]
	bne	.L1527
	mov	w0, -89
	strb	w0, [x12, 16]
	adrp	x0, .LANCHOR158+17
	mov	w1, -9
	strb	w1, [x0, #:lo12:.LANCHOR158+17]
.L1591:
	mov	w23, 7
	b	.L1634
.L1527:
	cmp	w8, 3
	bne	.L1529
	mov	x10, 0
.L1530:
	sub	w0, w10, #80
	strb	w0, [x6, x10]
	add	x10, x10, 1
	cmp	x10, 8
	bne	.L1530
	mov	w23, w10
.L1528:
	sub	w0, w8, #1
	cmp	w0, 1
	bhi	.L1536
	adrp	x7, .LANCHOR18
	adrp	x8, .LANCHOR30
	add	x7, x7, :lo12:.LANCHOR18
	add	x8, x8, :lo12:.LANCHOR30
	mov	w5, 0
	mov	w11, 55
.L1537:
	ldrb	w0, [x7]
	cmp	w0, w5
	bhi	.L1543
.L1544:
	strb	w10, [x12, 1]
	strb	w23, [x12, 2]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L1529:
	cmp	w8, 4
	bne	.L1531
	mov	w3, -52
	strb	w3, [x7, 128]
	mov	w3, -65
	strb	w3, [x7, 129]
	mov	w3, -86
	strb	w3, [x7, 130]
	mov	w3, -85
	mov	w23, 8
	strb	w3, [x7, 131]
	mov	w10, w23
	mov	w3, -51
	strb	w2, [x7, 133]
	strb	w3, [x7, 132]
	strb	w1, [x7, 134]
	strb	w0, [x7, 135]
	b	.L1528
.L1531:
	cmp	w8, 5
	bne	.L1532
	mov	w0, 56
	strb	w0, [x7, 128]
	mov	w0, 57
	strb	w0, [x7, 129]
	mov	w0, 58
	mov	w23, 8
	strb	w0, [x7, 130]
	mov	w0, 59
	strb	w0, [x7, 131]
.L1634:
	mov	w10, 4
	b	.L1528
.L1532:
	cmp	w8, 6
	bne	.L1533
	mov	w0, 14
	strb	w0, [x7, 128]
	mov	w0, 15
	strb	w0, [x7, 129]
	mov	w0, 16
	mov	w23, 12
	strb	w0, [x7, 130]
	mov	w0, 17
	strb	w0, [x7, 131]
	b	.L1634
.L1533:
	cmp	w8, 7
	bne	.L1534
	mov	x0, 0
.L1535:
	sub	w1, w0, #80
	strb	w1, [x6, x0]
	add	x0, x0, 1
	cmp	x0, 8
	bne	.L1535
	mov	w0, -44
	mov	w23, 12
	strb	w0, [x7, 136]
	mov	w10, 10
	mov	w0, -43
	strb	w0, [x7, 137]
	b	.L1528
.L1534:
	cmp	w8, 8
	bne	.L1591
	mov	w0, 6
	strb	w0, [x7, 128]
	mov	w0, 7
	strb	w0, [x7, 129]
	mov	w0, 9
	strb	w8, [x7, 130]
	strb	w0, [x7, 131]
	mov	w23, 50
	mov	w0, 10
	mov	w10, 5
	strb	w0, [x7, 132]
	b	.L1528
.L1543:
	ldrb	w0, [x8, w5, sxtw]
	mov	x1, 32
	mov	w2, 160
	mov	x3, 0
	umaddl	x2, w2, w0, x1
	adrp	x1, .LANCHOR13
	ubfiz	x0, x0, 8, 8
	ldr	x4, [x1, #:lo12:.LANCHOR13]
	add	x2, x12, x2
	add	x4, x4, x0
.L1538:
	str	w11, [x4, 2056]
	ldrb	w0, [x6, x3]
	str	w0, [x4, 2052]
	mov	w0, 80
	bl	timer_delay_ns
	ldr	w0, [x4, 2048]
	strb	w0, [x2, x3]
	add	x3, x3, 1
	cmp	w10, w3, uxtb
	bhi	.L1538
	adrp	x3, .LANCHOR158
	add	x3, x3, :lo12:.LANCHOR158
	mov	x0, 0
.L1541:
	add	x14, x2, x0
	add	x13, x3, x0
	mov	x1, 1
.L1540:
	lsl	x4, x1, 2
	lsl	x15, x1, 3
	ldrb	w16, [x2, x0]
	add	x1, x1, 1
	cmp	x1, 7
	ldrb	w4, [x13, x4]
	add	w4, w4, w16
	strb	w4, [x14, x15]
	bne	.L1540
	add	x0, x0, 1
	cmp	x0, 4
	bne	.L1541
	add	w5, w5, 1
	strb	wzr, [x2, 16]
	strb	wzr, [x2, 24]
	and	w5, w5, 255
	strb	wzr, [x2, 32]
	strb	wzr, [x2, 40]
	strb	wzr, [x2, 48]
	strb	wzr, [x2, 41]
	strb	wzr, [x2, 49]
	b	.L1537
.L1536:
	sub	w0, w8, #3
	cmp	w0, 5
	bhi	.L1544
	mul	w15, w23, w10
	sub	w13, w10, #1
	and	x13, x13, 255
	adrp	x19, .LANCHOR18
	sub	w20, w8, #5
	add	x19, x19, :lo12:.LANCHOR18
	asr	w14, w15, 1
	add	x13, x13, 1
	lsl	w15, w15, 4
	lsl	w22, w14, 1
	sbfiz	x21, x14, 1, 32
	mov	w11, 0
.L1545:
	ldrb	w0, [x19]
	cmp	w0, w11
	bls	.L1544
	adrp	x0, .LANCHOR30
	add	x0, x0, :lo12:.LANCHOR30
	ldrb	w24, [x0, w11, sxtw]
	mov	w0, w24
	bl	zftl_flash_exit_slc_mode
	adrp	x0, .LANCHOR13
	mov	x5, 32
	mov	w1, 160
	mov	w6, 255
	ldr	x4, [x0, #:lo12:.LANCHOR13]
	nop // between mem op and mult-accumulate
	umaddl	x1, w1, w24, x5
	ubfiz	x24, x24, 8, 8
	add	x4, x4, x24
	add	x5, x12, x1
	str	w6, [x4, 2056]
	bl	nandc_wait_flash_ready
	cmp	w8, 8
	bne	.L1546
	mov	w0, 120
	str	w0, [x4, 2056]
	str	wzr, [x4, 2052]
	mov	w0, 23
	str	wzr, [x4, 2052]
	mov	w1, 25
	str	wzr, [x4, 2052]
	add	x5, x7, 144
	str	w0, [x4, 2056]
	mov	w0, 4
	str	w0, [x4, 2056]
	str	w1, [x4, 2056]
	mov	w1, 218
	str	w1, [x4, 2056]
	mov	w1, 21
	str	wzr, [x4, 2056]
	str	wzr, [x4, 2052]
	str	wzr, [x4, 2052]
	str	w1, [x4, 2052]
.L1637:
	str	w0, [x4, 2052]
	mov	w0, 48
	str	wzr, [x4, 2052]
	str	w0, [x4, 2056]
	bl	nandc_wait_flash_ready
	cmp	w20, 1
	ccmp	w8, 8, 4, hi
	beq	.L1592
	cmp	w8, 7
	mov	w0, 32
	mov	w1, 2
	csel	w1, w1, w0, ne
.L1553:
	adrp	x6, .LANCHOR159
	mov	x2, 0
	ldr	x0, [x6, #:lo12:.LANCHOR159]
.L1554:
	ldr	w3, [x4, 2048]
	strb	w3, [x0, x2]
	add	x2, x2, 1
	cmp	w1, w2, uxtb
	bhi	.L1554
	cmp	w8, 8
	bne	.L1555
	mov	w1, 0
.L1557:
	ldrb	w2, [x0]
	cmp	w2, 50
	beq	.L1556
	ldrb	w2, [x0, 1]
	cmp	w2, 5
	beq	.L1556
	add	w1, w1, 1
	add	x0, x0, 4
	and	w1, w1, 255
	cmp	w1, 8
	bne	.L1557
.L1558:
	adrp	x0, .LC100
	mov	w1, 0
	add	x0, x0, :lo12:.LC100
	bl	printf
.L1560:
	b	.L1560
.L1546:
	mov	w0, 54
	str	w0, [x4, 2056]
	cmp	w8, 4
	bne	.L1548
	mov	w0, 64
	str	w6, [x4, 2052]
	str	w0, [x4, 2048]
	mov	w0, 204
.L1635:
	str	w0, [x4, 2052]
	mov	w0, 77
	b	.L1636
.L1548:
	cmp	w20, 1
	bhi	.L1550
	ldrb	w0, [x7, 128]
	str	w0, [x4, 2052]
	mov	w0, 82
.L1636:
	str	w0, [x4, 2048]
.L1549:
	mov	w0, 22
	str	w0, [x4, 2056]
	mov	w0, 23
	str	w0, [x4, 2056]
	mov	w0, 4
	str	w0, [x4, 2056]
	mov	w0, 25
	str	w0, [x4, 2056]
	str	wzr, [x4, 2056]
	cmp	w8, 6
	str	wzr, [x4, 2052]
	str	wzr, [x4, 2052]
	bne	.L1551
	mov	w0, 31
	str	w0, [x4, 2052]
.L1552:
	mov	w0, 2
	b	.L1637
.L1550:
	cmp	w8, 7
	bne	.L1549
	mov	w0, 174
	str	w0, [x4, 2052]
	str	wzr, [x4, 2048]
	mov	w0, 176
	b	.L1635
.L1551:
	str	wzr, [x4, 2052]
	b	.L1552
.L1592:
	mov	w1, 16
	b	.L1553
.L1556:
	cmp	w1, 6
	bhi	.L1558
.L1559:
	ldr	x3, [x6, #:lo12:.LANCHOR159]
	mov	x0, 0
.L1569:
	cmp	w15, w0
	bgt	.L1570
	ldr	x1, [x6, #:lo12:.LANCHOR159]
	mov	w6, 8
	add	x2, x1, x21
.L1572:
	mov	x0, 0
.L1571:
	ldrh	w16, [x2, x0, lsl 1]
	mvn	w16, w16
	strh	w16, [x2, x0, lsl 1]
	add	x0, x0, 1
	cmp	w14, w0
	bgt	.L1571
	add	x2, x2, x22, uxtw 1
	subs	w6, w6, #1
	bne	.L1572
	mov	x6, x1
	mov	w16, 0
	mov	w26, 1
.L1573:
	mov	w0, 0
	mov	w2, 0
.L1577:
	mov	x30, x6
	lsl	w25, w26, w2
	mov	w24, 16
	mov	w17, 0
.L1575:
	ldrh	w27, [x30]
	add	x30, x30, x21
	bics	wzr, w25, w27
	cinc	w17, w17, eq
	subs	w24, w24, #1
	bne	.L1575
	cmp	w17, 8
	bls	.L1576
	orr	w0, w0, w25
	and	w0, w0, 65535
.L1576:
	add	w2, w2, 1
	cmp	w2, 16
	bne	.L1577
	strh	w0, [x6], 2
	add	w16, w16, 1
	cmp	w14, w16
	bgt	.L1573
	mov	x0, 0
	mov	w2, 0
.L1580:
	ldr	w6, [x1, x0]
	add	x0, x0, 4
	cmp	w6, 0
	cinc	w2, w2, eq
	cmp	x0, 32
	bne	.L1580
	cmp	w2, 7
	ble	.L1581
	mov	w3, 1024
	mov	w2, 1
	adrp	x0, .LC101
	add	x0, x0, :lo12:.LC101
	bl	rknand_print_hex
	adrp	x0, .LC100
	mov	w1, 0
	add	x0, x0, :lo12:.LC100
	bl	printf
.L1582:
	b	.L1582
.L1555:
	cmp	w8, 7
	bne	.L1561
	mov	w1, 0
.L1563:
	ldrb	w2, [x0]
	cmp	w2, 12
	beq	.L1562
	ldrb	w2, [x0, 1]
	cmp	w2, 10
	beq	.L1562
	add	w1, w1, 1
	add	x0, x0, 4
	and	w1, w1, 255
	cmp	w1, 8
	bne	.L1563
.L1564:
	adrp	x0, .LC100
	mov	w1, 0
	add	x0, x0, :lo12:.LC100
	bl	printf
.L1565:
	b	.L1565
.L1562:
	cmp	w1, 6
	bls	.L1559
	b	.L1564
.L1561:
	cmp	w8, 6
	bne	.L1559
	mov	x1, 0
.L1566:
	ldrb	w2, [x0, x1]
	cmp	w2, 12
	beq	.L1559
	add	x2, x0, x1
	ldrb	w2, [x2, 8]
	cmp	w2, 4
	beq	.L1559
	add	x1, x1, 1
	cmp	x1, 8
	bne	.L1566
	adrp	x0, .LC100
	mov	w1, 0
	add	x0, x0, :lo12:.LC100
	bl	printf
.L1568:
	b	.L1568
.L1570:
	ldr	w1, [x4, 2048]
	strb	w1, [x3, x0]
	add	x0, x0, 1
	b	.L1569
.L1581:
	cmp	w8, 6
	beq	.L1594
	cmp	w8, 7
	beq	.L1595
	cmp	w8, 8
	mov	x1, 5
	mov	x0, 8
	csel	x0, x0, x1, ne
.L1583:
	mov	x1, x5
	mov	w5, 0
.L1584:
	mov	x2, 0
.L1585:
	ldrb	w6, [x3, x2]
	strb	w6, [x1, x2]
	add	x2, x2, 1
	cmp	w10, w2, uxtb
	bhi	.L1585
	add	w5, w5, 1
	add	x3, x3, x13
	add	x1, x1, x0
	cmp	w23, w5
	bgt	.L1584
	mov	w5, 255
	str	w5, [x4, 2056]
	bl	nandc_wait_flash_ready
	cmp	w20, 1
	bhi	.L1587
	mov	w0, 54
	str	w0, [x4, 2056]
	ldrb	w0, [x7, 128]
	str	w0, [x4, 2052]
	str	wzr, [x4, 2048]
	mov	w0, 22
	str	w0, [x4, 2056]
	mov	w0, 48
	str	wzr, [x4, 2056]
	str	wzr, [x4, 2052]
	str	wzr, [x4, 2052]
	str	w5, [x4, 2052]
	str	w5, [x4, 2052]
	str	w5, [x4, 2052]
.L1638:
	str	w0, [x4, 2056]
	bl	nandc_wait_flash_ready
	add	w11, w11, 1
	and	w11, w11, 255
	b	.L1545
.L1594:
	mov	x0, 4
	b	.L1583
.L1595:
	mov	x0, 10
	b	.L1583
.L1587:
	cmp	w8, 8
	bne	.L1589
	mov	w0, 190
	b	.L1638
.L1589:
	mov	w0, 56
	b	.L1638
	.size	hynix_get_read_retry_default, .-hynix_get_read_retry_default
	.section	.text.flash_get_read_retry_tbl,"ax",@progbits
	.align	2
	.global	flash_get_read_retry_tbl
	.type	flash_get_read_retry_tbl, %function
flash_get_read_retry_tbl:
	adrp	x0, .LANCHOR32+19
	ldrb	w0, [x0, #:lo12:.LANCHOR32+19]
	sub	w1, w0, #1
	and	w1, w1, 255
	cmp	w1, 7
	bhi	.L1639
	b	hynix_get_read_retry_default
.L1639:
	ret
	.size	flash_get_read_retry_tbl, .-flash_get_read_retry_tbl
	.section	.text.nandc_xfer_done,"ax",@progbits
	.align	2
	.global	nandc_xfer_done
	.type	nandc_xfer_done, %function
nandc_xfer_done:
	stp	x29, x30, [sp, -80]!
	adrp	x0, .LANCHOR160
	adrp	x1, .LANCHOR28
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR13
	ldrb	w1, [x1, #:lo12:.LANCHOR28]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	cmp	w1, 9
	strb	wzr, [x0, #:lo12:.LANCHOR160]
	bne	.L1642
	ldr	x20, [x19, #:lo12:.LANCHOR13]
	mov	x24, x0
	mov	w21, 0
	ldr	w0, [x20, 16]
	str	w0, [x29, 64]
	ldr	w0, [x20, 48]
	tbnz	x0, 1, .L1643
	adrp	x22, .LC105
	adrp	x23, .LC104
	add	x22, x22, :lo12:.LC105
	add	x23, x23, :lo12:.LC104
.L1644:
	ldr	w0, [x29, 64]
	tbnz	x0, 20, .L1647
	ldr	x0, [x19, #:lo12:.LANCHOR13]
	add	w21, w21, 1
	tst	x21, 16777215
	ldr	w0, [x0, 16]
	str	w0, [x29, 64]
	bne	.L1644
	ldr	w2, [x29, 64]
	mov	w1, w21
	ldr	w3, [x20, 64]
	mov	x0, x22
	ubfx	x3, x3, 16, 6
	bl	printf
	ldr	x1, [x19, #:lo12:.LANCHOR13]
	mov	w3, 64
	mov	w2, 4
	mov	x0, x23
	bl	rknand_print_hex
	b	.L1644
.L1643:
	adrp	x22, .LC103
	adrp	x23, .LC104
	add	x22, x22, :lo12:.LC103
	add	x23, x23, :lo12:.LC104
.L1645:
	ldr	w1, [x20, 64]
	ldr	w0, [x29, 64]
	ubfx	x1, x1, 16, 6
	ubfx	x0, x0, 22, 6
	cmp	w1, w0
	bge	.L1647
	ldr	x0, [x19, #:lo12:.LANCHOR13]
	ldr	w0, [x0]
	str	w0, [x29, 72]
	ldr	w0, [x29, 72]
	tbz	x0, 13, .L1646
	ldr	w0, [x29, 72]
	tbz	x0, 17, .L1646
	ldr	w1, [x29, 72]
	adrp	x0, .LC102
	add	x0, x0, :lo12:.LC102
	ubfx	x1, x1, 17, 1
.L1679:
	bl	printf
	b	.L1647
.L1646:
	ldr	w0, [x29, 64]
	add	w21, w21, 1
	ubfx	x0, x0, 22, 6
	cmp	w21, w0, lsl 12
	bne	.L1645
	ldr	w2, [x20, 64]
	mov	w1, w21
	ldr	w3, [x29, 64]
	mov	x0, x22
	ubfx	x2, x2, 16, 5
	ubfx	x3, x3, 22, 6
	bl	printf
	ldr	x1, [x19, #:lo12:.LANCHOR13]
	mov	x0, x23
	mov	w3, 64
	mov	w2, 4
	bl	rknand_print_hex
	ldr	w0, [x29, 72]
	tbz	x0, 13, .L1645
	mov	w0, 1
	strb	w0, [x24, #:lo12:.LANCHOR160]
.L1647:
	adrp	x0, .LANCHOR49+32
	ldp	x19, x20, [sp, 16]
	str	wzr, [x0, #:lo12:.LANCHOR49+32]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L1642:
	ldr	x20, [x19, #:lo12:.LANCHOR13]
	mov	w21, 0
	ldr	w0, [x20, 8]
	str	w0, [x29, 64]
	ldr	w0, [x20, 16]
	tbnz	x0, 1, .L1653
	adrp	x22, .LC105
	adrp	x23, .LC104
	add	x22, x22, :lo12:.LC105
	add	x23, x23, :lo12:.LC104
.L1654:
	ldr	w0, [x29, 64]
	tbnz	x0, 20, .L1647
	ldr	x0, [x19, #:lo12:.LANCHOR13]
	add	w21, w21, 1
	tst	x21, 16777215
	ldr	w0, [x0, 8]
	str	w0, [x29, 64]
	bne	.L1654
	ldr	w2, [x29, 64]
	mov	w1, w21
	ldr	w3, [x20, 28]
	mov	x0, x22
	ubfx	x3, x3, 16, 5
	bl	printf
	ldr	x1, [x19, #:lo12:.LANCHOR13]
	mov	w3, 64
	mov	w2, 4
	mov	x0, x23
	bl	rknand_print_hex
	b	.L1654
.L1653:
	adrp	x22, .LC103
	adrp	x23, .LC104
	add	x22, x22, :lo12:.LC103
	add	x23, x23, :lo12:.LC104
.L1655:
	ldr	w1, [x20, 28]
	ldr	w0, [x29, 64]
	ubfx	x1, x1, 16, 5
	ubfx	x0, x0, 22, 6
	cmp	w1, w0
	bge	.L1647
	ldr	x0, [x19, #:lo12:.LANCHOR13]
	ldr	w0, [x0]
	str	w0, [x29, 72]
	ldr	w0, [x29, 72]
	tbz	x0, 13, .L1656
	ldr	w0, [x29, 72]
	tbz	x0, 17, .L1656
	adrp	x0, .LC106
	ldr	w1, [x29, 72]
	add	x0, x0, :lo12:.LC106
	b	.L1679
.L1656:
	add	w21, w21, 1
	tst	x21, 16777215
	bne	.L1655
	ldr	w2, [x20, 28]
	mov	w1, w21
	ldr	w3, [x29, 64]
	mov	x0, x22
	ubfx	x2, x2, 16, 5
	ubfx	x3, x3, 22, 6
	bl	printf
	ldr	x1, [x19, #:lo12:.LANCHOR13]
	mov	w3, 64
	mov	w2, 4
	mov	x0, x23
	bl	rknand_print_hex
	b	.L1655
	.size	nandc_xfer_done, .-nandc_xfer_done
	.section	.text.nandc_xfer,"ax",@progbits
	.align	2
	.global	nandc_xfer
	.type	nandc_xfer, %function
nandc_xfer:
	stp	x29, x30, [sp, -64]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w19, w2, 255
	stp	x21, x22, [sp, 32]
	mov	x20, x3
	and	w22, w1, 255
	mov	x3, x4
	mov	x2, x20
	mov	w1, w19
	mov	w0, w22
	mov	x21, x4
	bl	nandc_xfer_start
	bl	nandc_xfer_done
	cbnz	w22, .L1699
	adrp	x0, .LANCHOR28
	ldrb	w0, [x0, #:lo12:.LANCHOR28]
	cmp	w0, 9
	bne	.L1682
	adrp	x22, .LANCHOR13
	lsr	w19, w19, 2
	mov	w3, 1
	mov	w2, 0
	ldr	x5, [x22, #:lo12:.LANCHOR13]
	mov	w0, 0
.L1683:
	cmp	w2, w19
	bcc	.L1687
	ldr	w19, [x5]
	cmp	w3, 0
	mov	w1, 512
	csel	w0, w0, w1, eq
	mov	w1, 8192
	movk	w1, 0x2, lsl 16
	and	w1, w19, w1
	cmp	w1, 139264
	bne	.L1689
	mov	w1, w19
	adrp	x0, .LC107
	add	x0, x0, :lo12:.LC107
	bl	printf
	ldr	x0, [x22, #:lo12:.LANCHOR13]
	orr	w19, w19, 131072
	str	w19, [x0]
	mov	w0, -1
.L1689:
	tbz	x19, 13, .L1690
	adrp	x1, .LANCHOR160
	ldrb	w1, [x1, #:lo12:.LANCHOR160]
	cbz	w1, .L1690
	mov	w1, w19
	adrp	x0, .LC108
	add	x0, x0, :lo12:.LC108
	bl	printf
	ldr	x0, [x22, #:lo12:.LANCHOR13]
	mov	w1, 1
	str	w1, [x0, 16]
.L1718:
	mov	w0, -1
.L1681:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L1687:
	uxtw	x1, w2
	add	x1, x1, 84
	ldr	w1, [x5, x1, lsl 2]
	str	w1, [x29, 56]
	ldr	w1, [x29, 56]
	ldr	w4, [x29, 56]
	ubfx	x4, x4, 26, 1
	and	w1, w4, w1, lsr 10
	and	w3, w3, w1
	ldr	w1, [x29, 56]
	tbnz	x1, 2, .L1701
	ldr	w1, [x29, 56]
	tbnz	x1, 18, .L1701
	ldr	w4, [x29, 56]
	ldr	w1, [x29, 56]
	ubfx	x4, x4, 3, 7
	ubfx	x1, x1, 19, 7
	cmp	w4, w1
	ldr	w1, [x29, 56]
	ble	.L1685
	ubfx	x1, x1, 3, 7
.L1686:
	cmp	w0, w1
	csel	w0, w0, w1, cs
.L1684:
	add	w2, w2, 1
	b	.L1683
.L1685:
	ubfx	x1, x1, 19, 7
	b	.L1686
.L1701:
	mov	w0, -1
	b	.L1684
.L1682:
	adrp	x0, .LANCHOR46
	lsr	w4, w19, 1
	mov	w3, 64
	mov	w1, 1
	ldrb	w0, [x0, #:lo12:.LANCHOR46]
	mov	w2, 0
	adrp	x6, .LANCHOR49
	cmp	w0, 25
	mov	w0, 128
	csel	w3, w3, w0, cc
	mov	w0, 0
.L1692:
	add	w5, w3, w0
	cmp	w2, w4
	bcc	.L1693
	adrp	x22, .LANCHOR13
	lsr	w19, w19, 2
	mov	w3, 0
	mov	w0, 0
	ldr	x4, [x22, #:lo12:.LANCHOR13]
.L1694:
	cmp	w3, w19
	bcc	.L1698
	str	wzr, [x4, 16]
	mov	w1, 8192
	movk	w1, 0x2, lsl 16
	ldr	w19, [x4]
	and	w1, w19, w1
	cmp	w1, 139264
	bne	.L1690
	mov	w1, w19
	adrp	x0, .LC109
	add	x0, x0, :lo12:.LC109
	bl	printf
	ldr	x0, [x22, #:lo12:.LANCHOR13]
	orr	w19, w19, 131072
	str	w19, [x0]
	b	.L1718
.L1693:
	ldr	x7, [x6, #:lo12:.LANCHOR49]
	and	x0, x0, 4294967292
	ldr	w0, [x7, x0]
	lsl	w7, w2, 2
	add	w2, w2, 1
	strb	w0, [x21, x7]
	lsr	w7, w0, 8
	strb	w7, [x21, w1, uxtw]
	add	w7, w1, 1
	lsr	w8, w0, 16
	lsr	w0, w0, 24
	strb	w8, [x21, x7]
	add	w7, w1, 2
	add	w1, w1, 4
	strb	w0, [x21, x7]
	mov	w0, w5
	b	.L1692
.L1698:
	uxtw	x1, w3
	add	x1, x1, 8
	ldr	w1, [x4, x1, lsl 2]
	str	w1, [x29, 56]
	ldr	w1, [x29, 56]
	tbnz	x1, 2, .L1704
	ldr	w1, [x29, 56]
	tbnz	x1, 15, .L1704
	ldr	w2, [x29, 56]
	ubfx	x6, x2, 3, 5
	ldr	w2, [x29, 56]
	ldr	w1, [x29, 56]
	ubfx	x2, x2, 27, 1
	ubfx	x5, x1, 16, 5
	ldr	w1, [x29, 56]
	orr	w2, w6, w2, lsl 5
	ubfx	x1, x1, 29, 1
	orr	w1, w5, w1, lsl 5
	cmp	w2, w1
	ldr	w1, [x29, 56]
	bls	.L1696
	ubfx	x2, x1, 3, 5
	ldr	w1, [x29, 56]
	ubfx	x1, x1, 27, 1
.L1717:
	orr	w1, w2, w1, lsl 5
	cmp	w0, w1
	csel	w0, w0, w1, cs
.L1695:
	add	w3, w3, 1
	b	.L1694
.L1696:
	ubfx	x2, x1, 16, 5
	ldr	w1, [x29, 56]
	ubfx	x1, x1, 29, 1
	b	.L1717
.L1704:
	mov	w0, -1
	b	.L1695
.L1690:
	cmn	w0, #1
	beq	.L1681
	ldr	w1, [x21]
	cmn	w1, #1
	bne	.L1681
	ldr	w1, [x21, 4]
	cmn	w1, #1
	bne	.L1681
	ldr	w1, [x20]
	cmn	w1, #1
	mov	w1, 512
	csel	w0, w0, w1, ne
	b	.L1681
.L1699:
	mov	w0, 0
	b	.L1681
	.size	nandc_xfer, .-nandc_xfer
	.section	.text.flash_read_page,"ax",@progbits
	.align	2
	.global	flash_read_page
	.type	flash_read_page, %function
flash_read_page:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	and	w21, w0, 255
	adrp	x0, .LANCHOR13
	stp	x19, x20, [sp, 16]
	mov	w19, 24
	stp	x23, x24, [sp, 48]
	ldr	x20, [x0, #:lo12:.LANCHOR13]
	adrp	x0, .LANCHOR31
	str	x25, [sp, 64]
	mov	x24, x2
	ldrb	w0, [x0, #:lo12:.LANCHOR31]
	mov	w23, w4
	ubfx	x22, x1, 24, 2
	mov	x25, x3
	sub	w0, w19, w0
	mov	w19, 1
	lsl	w19, w19, w0
	adrp	x0, .LANCHOR14
	sub	w19, w19, #1
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	and	w19, w19, w1
	tbz	x0, 4, .L1720
	mov	w3, w1
	adrp	x0, .LC110
	mov	w2, w22
	mov	w1, w21
	add	x0, x0, :lo12:.LC110
	bl	printf
.L1720:
	bl	nandc_wait_flash_ready
	mov	w0, w21
	bl	nandc_cs
	adrp	x7, .LANCHOR16
	cbnz	w22, .L1721
	mov	w0, w21
	bl	zftl_flash_enter_slc_mode
.L1722:
	ubfiz	x4, x21, 8, 8
	and	w0, w19, 255
	add	x4, x20, x4
	str	wzr, [x4, 2056]
	str	wzr, [x4, 2052]
	str	wzr, [x4, 2052]
	str	w0, [x4, 2052]
	lsr	w0, w19, 8
	str	w0, [x4, 2052]
	lsr	w0, w19, 16
	str	w0, [x4, 2052]
	mov	w0, 48
	str	w0, [x4, 2056]
	ldr	x0, [x7, #:lo12:.LANCHOR16]
	ldrb	w0, [x0, 12]
	cmp	w0, 3
	bne	.L1724
	cbz	w22, .L1724
	adrp	x0, .LANCHOR35
	ldrb	w0, [x0, #:lo12:.LANCHOR35]
	cbnz	w0, .L1724
	add	w19, w19, w19, lsl 1
	sub	w0, w19, #1
	add	w0, w0, w22
.L1733:
	bl	nandc_set_seed
	bl	nandc_wait_flash_ready
	mov	w0, 5
	str	w0, [x4, 2056]
	str	wzr, [x4, 2052]
	mov	w0, 224
	str	wzr, [x4, 2052]
	mov	w2, w23
	str	w0, [x4, 2056]
	mov	x3, x24
	mov	x4, x25
	mov	w1, 0
	mov	w0, w21
	bl	nandc_xfer
	mov	w2, w0
	bl	nandc_de_cs.constprop.30
	ldr	x25, [sp, 64]
	mov	w0, w2
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L1721:
	ldr	x0, [x7, #:lo12:.LANCHOR16]
	ldrb	w0, [x0, 12]
	cmp	w0, 3
	bne	.L1723
	adrp	x0, .LANCHOR35
	ldrb	w0, [x0, #:lo12:.LANCHOR35]
	cbnz	w0, .L1723
	sxtw	x0, w21
	add	x0, x0, 8
	add	x0, x20, x0, lsl 8
	str	w22, [x0, 8]
	b	.L1722
.L1723:
	mov	w0, w21
	bl	zftl_flash_exit_slc_mode
	b	.L1722
.L1724:
	mov	w0, w19
	b	.L1733
	.size	flash_read_page, .-flash_read_page
	.section	.text.micron_read_retrial,"ax",@progbits
	.align	2
	.global	micron_read_retrial
	.type	micron_read_retrial, %function
micron_read_retrial:
	stp	x29, x30, [sp, -128]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w20, w0, 255
	adrp	x0, .LANCHOR46
	stp	x25, x26, [sp, 64]
	stp	x21, x22, [sp, 32]
	mov	x26, x3
	stp	x23, x24, [sp, 48]
	mov	w23, w1
	ldrb	w19, [x0, #:lo12:.LANCHOR46]
	mov	w22, 0
	stp	x27, x28, [sp, 80]
	str	w4, [x29, 116]
	str	x2, [x29, 120]
	bl	nandc_wait_flash_ready
	adrp	x0, .LANCHOR13
	add	w19, w19, w19, lsl 1
	asr	w19, w19, 2
	ldr	x6, [x0, #:lo12:.LANCHOR13]
	adrp	x0, .LANCHOR162
	add	x0, x0, :lo12:.LANCHOR162
	str	x0, [x29, 104]
	ubfiz	x0, x20, 8, 8
	add	x25, x6, x0
.L1735:
	adrp	x24, .LANCHOR14
	add	x24, x24, :lo12:.LANCHOR14
	mov	w21, 0
	mov	w28, -1
.L1736:
	ldr	x0, [x29, 104]
	ldrb	w0, [x0]
	cmp	w21, w0
	bcc	.L1741
.L1740:
	mov	w0, 239
	str	w0, [x25, 2056]
	mov	w0, 137
	str	w0, [x25, 2052]
	mov	w0, 200
	bl	timer_delay_ns
	str	wzr, [x25, 2048]
	str	wzr, [x25, 2048]
	cmp	w28, w19
	str	wzr, [x25, 2048]
	str	wzr, [x25, 2048]
	bcc	.L1742
	cmn	w28, #1
	mov	w0, 256
	csel	w28, w28, w0, eq
.L1742:
	cmn	w28, #1
	cset	w24, eq
	cmp	w28, 256
	cset	w0, eq
	orr	w0, w24, w0
	cbz	w0, .L1743
	mov	w4, w28
	mov	w3, w21
	mov	w2, w23
	mov	w1, w21
	adrp	x0, .LC112
	add	x0, x0, :lo12:.LC112
	bl	printf
	eor	w0, w22, 1
	tst	w24, w0
	beq	.L1744
	mov	w1, 3
	mov	w0, w20
	mov	w22, 1
	bl	mt_auto_read_calibration_config
	b	.L1735
.L1741:
	mov	w0, 239
	str	w0, [x25, 2056]
	mov	w0, 137
	str	w0, [x25, 2052]
	add	w27, w21, 1
	mov	w0, 200
	bl	timer_delay_ns
	str	w27, [x25, 2048]
	str	wzr, [x25, 2048]
	mov	x3, x26
	ldr	w4, [x29, 116]
	mov	w1, w23
	ldr	x2, [x29, 120]
	mov	w0, w20
	str	wzr, [x25, 2048]
	str	wzr, [x25, 2048]
	bl	flash_read_page
	mov	w7, w0
	ldr	w0, [x24]
	tbz	x0, 12, .L1737
	mov	w4, w7
	str	w7, [x29, 112]
	mov	w3, w28
	mov	w2, w23
	mov	w1, w21
	adrp	x0, .LC111
	add	x0, x0, :lo12:.LC111
	bl	printf
	ldr	w7, [x29, 112]
.L1737:
	cmn	w7, #1
	beq	.L1738
	adrp	x0, .LANCHOR159
	cmn	w28, #1
	csel	w28, w28, w7, ne
	cmp	w7, w19
	ldr	x0, [x0, #:lo12:.LANCHOR159]
	str	x0, [x29, 120]
	adrp	x0, .LANCHOR161
	ldr	x26, [x0, #:lo12:.LANCHOR161]
	bcc	.L1747
.L1738:
	mov	w21, w27
	b	.L1736
.L1747:
	mov	w28, w7
	b	.L1740
.L1744:
	cbz	w22, .L1745
	mov	w0, w20
	mov	w1, 0
	bl	mt_auto_read_calibration_config
	cmn	w28, #1
	mov	w0, 256
	csel	w28, w28, w0, eq
.L1745:
	bl	nandc_wait_flash_ready
	mov	w0, w28
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L1743:
	cbz	w22, .L1745
	mov	w1, 0
	mov	w0, w20
	mov	w28, 256
	bl	mt_auto_read_calibration_config
	b	.L1745
	.size	micron_read_retrial, .-micron_read_retrial
	.section	.text.toshiba_3d_read_retrial,"ax",@progbits
	.align	2
	.global	toshiba_3d_read_retrial
	.type	toshiba_3d_read_retrial, %function
toshiba_3d_read_retrial:
	stp	x29, x30, [sp, -144]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	mov	w23, w1
	stp	x27, x28, [sp, 80]
	mov	w28, w4
	ubfx	x4, x23, 24, 2
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	and	w24, w0, 255
	stp	x25, x26, [sp, 64]
	mov	x27, x3
	mov	x26, x2
	bl	nandc_wait_flash_ready
	adrp	x0, .LANCHOR13
	adrp	x22, .LANCHOR24
	mov	w1, 46
	mov	w2, 56
	ldr	x25, [x0, #:lo12:.LANCHOR13]
	and	x0, x24, 255
	add	x21, x0, 8
	str	x0, [x29, 128]
	ldrb	w0, [x22, #:lo12:.LANCHOR24]
	mov	w19, -1
	add	x21, x25, x21, lsl 8
	mov	w20, 1
	cmp	w0, 36
	mov	w0, 26
	csel	w1, w2, w1, ne
	str	w1, [x29, 120]
	mov	w1, 10
	csel	w0, w1, w0, ne
	str	w0, [x29, 136]
	add	x0, x22, :lo12:.LANCHOR24
	cbnz	w4, .L1765
	str	x0, [x29, 120]
	sxtw	x0, w24
	add	x0, x0, 8
	add	x0, x25, x0, lsl 8
	str	x0, [x29, 112]
.L1772:
	ldr	x0, [x29, 120]
	ldrb	w0, [x0]
	cmp	w0, 36
	bne	.L1766
	mov	w1, w20
	mov	x0, x21
	mov	w2, 0
	bl	toshiba_tlc_set_rr_para
	ldr	x1, [x29, 112]
	mov	w0, 93
	str	w0, [x1, 8]
.L1767:
	mov	w4, w28
	mov	x3, x27
	mov	x2, x26
	mov	w1, w23
	mov	w0, w24
	bl	flash_read_page
	mov	w4, w0
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 4, .L1768
	mov	w3, w4
	str	w4, [x29, 108]
	mov	w2, w23
	mov	w1, w20
	adrp	x0, .LC113
	add	x0, x0, :lo12:.LC113
	bl	printf
	ldr	w4, [x29, 108]
.L1768:
	cmn	w4, #1
	beq	.L1769
	adrp	x0, .LANCHOR159
	cmn	w19, #1
	csel	w19, w19, w4, ne
	ldr	x26, [x0, #:lo12:.LANCHOR159]
	adrp	x0, .LANCHOR161
	ldr	x27, [x0, #:lo12:.LANCHOR161]
	adrp	x0, .LANCHOR46
	ldrb	w0, [x0, #:lo12:.LANCHOR46]
	add	w0, w0, w0, lsl 1
	cmp	w4, w0, lsr 2
	bcc	.L1787
.L1769:
	ldr	w0, [x29, 136]
	add	w20, w20, 1
	cmp	w0, w20
	bne	.L1772
.L1771:
	ldrb	w0, [x22, #:lo12:.LANCHOR24]
	cmp	w0, 36
	bne	.L1773
	mov	w2, 0
.L1810:
	mov	w1, 0
	mov	x0, x21
	bl	toshiba_tlc_set_rr_para
	b	.L1774
.L1766:
	mov	w1, w20
	mov	x0, x21
	bl	toshiba_3d_set_slc_rr_para
	b	.L1767
.L1787:
	mov	w19, w4
	b	.L1771
.L1773:
	mov	w1, 0
	mov	x0, x21
	bl	toshiba_3d_set_slc_rr_para
.L1774:
	ldrb	w0, [x22, #:lo12:.LANCHOR24]
	cmp	w0, 36
	bne	.L1783
	ldr	x0, [x29, 128]
	add	x25, x25, x0, lsl 8
	mov	w0, 85
	str	w0, [x25, 2056]
	mov	w0, 255
	str	wzr, [x25, 2052]
	str	wzr, [x25, 2048]
	str	w0, [x25, 2056]
.L1783:
	adrp	x0, .LANCHOR46
	ldrb	w0, [x0, #:lo12:.LANCHOR46]
	add	w0, w0, w0, lsl 1
	cmp	w19, w0, lsr 2
	bcc	.L1784
	cmn	w19, #1
	mov	w0, 256
	csel	w19, w19, w0, eq
.L1784:
	cmp	w19, 256
	ccmn	w19, #1, 4, ne
	bne	.L1785
	adrp	x0, .LC115
	mov	w4, w19
	mov	w3, w20
	mov	w2, w23
	mov	w1, w20
	add	x0, x0, :lo12:.LC115
	bl	printf
.L1785:
	bl	nandc_wait_flash_ready
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	ret
.L1765:
	str	x0, [x29, 112]
	sxtw	x0, w24
	add	x0, x0, 8
	add	x0, x25, x0, lsl 8
	str	x0, [x29, 136]
.L1781:
	ldr	x0, [x29, 112]
	ldrb	w0, [x0]
	cmp	w0, 36
	bne	.L1775
	mov	x0, x21
	mov	w2, 1
	mov	w1, w20
	bl	toshiba_tlc_set_rr_para
	mov	w0, 93
.L1809:
	ldr	x1, [x29, 136]
	mov	w4, w28
	mov	x3, x27
	mov	x2, x26
	str	w0, [x1, 8]
	mov	w1, w23
	mov	w0, w24
	bl	flash_read_page
	mov	w4, w0
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 4, .L1777
	mov	w3, w4
	str	w4, [x29, 108]
	mov	w2, w23
	mov	w1, w20
	adrp	x0, .LC114
	add	x0, x0, :lo12:.LC114
	bl	printf
	ldr	w4, [x29, 108]
.L1777:
	cmn	w4, #1
	beq	.L1778
	adrp	x0, .LANCHOR159
	cmn	w19, #1
	csel	w19, w19, w4, ne
	ldr	x26, [x0, #:lo12:.LANCHOR159]
	adrp	x0, .LANCHOR161
	ldr	x27, [x0, #:lo12:.LANCHOR161]
	adrp	x0, .LANCHOR46
	ldrb	w0, [x0, #:lo12:.LANCHOR46]
	add	w0, w0, w0, lsl 1
	cmp	w4, w0, lsr 2
	bcc	.L1788
.L1778:
	ldr	w0, [x29, 120]
	add	w20, w20, 1
	cmp	w0, w20
	bne	.L1781
.L1780:
	ldrb	w0, [x22, #:lo12:.LANCHOR24]
	cmp	w0, 36
	bne	.L1782
	mov	w2, 1
	b	.L1810
.L1775:
	mov	x0, x21
	mov	w1, w20
	bl	toshiba_3d_set_tlc_rr_para
	mov	w0, 38
	b	.L1809
.L1788:
	mov	w19, w4
	b	.L1780
.L1782:
	mov	w1, 0
	mov	x0, x21
	bl	toshiba_3d_set_tlc_rr_para
	b	.L1774
	.size	toshiba_3d_read_retrial, .-toshiba_3d_read_retrial
	.section	.text.toshiba_read_retrial,"ax",@progbits
	.align	2
	.global	toshiba_read_retrial
	.type	toshiba_read_retrial, %function
toshiba_read_retrial:
	stp	x29, x30, [sp, -128]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	mov	w25, w1
	stp	x19, x20, [sp, 16]
	mov	x26, x2
	stp	x27, x28, [sp, 80]
	and	w19, w0, 255
	stp	x23, x24, [sp, 48]
	mov	x27, x3
	str	w4, [x29, 116]
	bl	nandc_wait_flash_ready
	adrp	x0, .LANCHOR13
	adrp	x1, .LANCHOR24
	str	x1, [x29, 120]
	ldr	x22, [x0, #:lo12:.LANCHOR13]
	and	x0, x19, 255
	add	x21, x0, 8
	str	x0, [x29, 104]
	ldrb	w0, [x1, #:lo12:.LANCHOR24]
	add	x21, x22, x21, lsl 8
	sub	w0, w0, #67
	and	w0, w0, 255
	cmp	w0, 1
	bls	.L1829
	adrp	x0, .LANCHOR21
	ldrb	w0, [x0, #:lo12:.LANCHOR21]
	cbz	w0, .L1830
	mov	w23, 1
	mov	w0, 1
	bl	nandc_set_if_mode
.L1813:
	and	x0, x19, 255
	mov	w1, 92
	add	x0, x22, x0, lsl 8
	str	w1, [x0, 2056]
	mov	w1, 197
	str	w1, [x0, 2056]
.L1812:
	sxtw	x0, w19
	mov	w20, 1
	add	x0, x0, 8
	mov	w24, -1
	add	x0, x22, x0, lsl 8
	str	x0, [x29, 96]
.L1814:
	adrp	x0, .LANCHOR162
	ldrb	w0, [x0, #:lo12:.LANCHOR162]
	add	w0, w0, 1
	cmp	w20, w0
	bcc	.L1823
	mov	w28, w24
.L1822:
	ldr	x0, [x29, 120]
	mov	w1, 0
	ldrb	w0, [x0, #:lo12:.LANCHOR24]
	sub	w0, w0, #67
	and	w0, w0, 255
	cmp	w0, 1
	mov	x0, x21
	bhi	.L1824
	bl	sandisk_set_rr_para
.L1825:
	sxtw	x19, w19
	mov	w0, 255
	add	x19, x19, 8
	add	x22, x22, x19, lsl 8
	str	w0, [x22, 8]
	adrp	x0, .LANCHOR46
	ldrb	w0, [x0, #:lo12:.LANCHOR46]
	add	w0, w0, w0, lsl 1
	cmp	w28, w0, lsr 2
	bcc	.L1826
	cmn	w28, #1
	mov	w0, 256
	csel	w28, w28, w0, eq
.L1826:
	cmp	w28, 256
	ccmn	w28, #1, 4, ne
	bne	.L1827
	adrp	x0, .LC115
	mov	w4, w28
	mov	w3, w20
	mov	w2, w25
	mov	w1, w20
	add	x0, x0, :lo12:.LC115
	bl	printf
.L1827:
	bl	nandc_wait_flash_ready
	cbz	w23, .L1811
	mov	w0, 4
	bl	nandc_set_if_mode
.L1811:
	mov	w0, w28
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L1830:
	mov	w23, 0
	b	.L1813
.L1829:
	mov	w23, 0
	b	.L1812
.L1823:
	ldr	x0, [x29, 120]
	mov	w1, w20
	ldrb	w0, [x0, #:lo12:.LANCHOR24]
	sub	w0, w0, #67
	and	w0, w0, 255
	cmp	w0, 1
	mov	x0, x21
	bhi	.L1815
	bl	sandisk_set_rr_para
.L1816:
	ldr	x0, [x29, 120]
	ldrb	w0, [x0, #:lo12:.LANCHOR24]
	cmp	w0, 34
	bne	.L1817
	adrp	x0, .LANCHOR162
	ldrb	w0, [x0, #:lo12:.LANCHOR162]
	sub	w0, w0, #3
	cmp	w20, w0
	bne	.L1817
	ldr	x1, [x29, 96]
	mov	w0, 179
	str	w0, [x1, 8]
.L1817:
	ldr	x0, [x29, 104]
	mov	w1, 38
	ldr	w4, [x29, 116]
	mov	x3, x27
	mov	x2, x26
	add	x0, x22, x0, lsl 8
	str	w1, [x0, 2056]
	mov	w1, 93
	str	w1, [x0, 2056]
	mov	w1, w25
	mov	w0, w19
	bl	flash_read_page
	mov	w28, w0
	cmn	w0, #1
	beq	.L1820
	cmn	w24, #1
	csel	w24, w24, w0, ne
	adrp	x0, .LANCHOR159
	ldr	x26, [x0, #:lo12:.LANCHOR159]
	adrp	x0, .LANCHOR161
	ldr	x27, [x0, #:lo12:.LANCHOR161]
	adrp	x0, .LANCHOR46
	ldrb	w0, [x0, #:lo12:.LANCHOR46]
	add	w0, w0, w0, lsl 1
	cmp	w28, w0, lsr 2
	bcc	.L1822
.L1820:
	add	w20, w20, 1
	b	.L1814
.L1815:
	bl	toshiba_set_rr_para
	b	.L1816
.L1824:
	bl	toshiba_set_rr_para
	b	.L1825
	.size	toshiba_read_retrial, .-toshiba_read_retrial
	.section	.text.hynix_read_retrial,"ax",@progbits
	.align	2
	.global	hynix_read_retrial
	.type	hynix_read_retrial, %function
hynix_read_retrial:
	stp	x29, x30, [sp, -128]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	and	x23, x0, 255
	adrp	x0, .LANCHOR27
	stp	x27, x28, [sp, 80]
	stp	x21, x22, [sp, 32]
	mov	w27, w4
	ldr	x28, [x0, #:lo12:.LANCHOR27]
	mov	w22, w1
	stp	x25, x26, [sp, 64]
	mov	x25, x2
	add	x28, x28, 112
	stp	x19, x20, [sp, 16]
	add	x0, x28, x23
	mov	x26, x3
	mov	x21, x23
	mov	w19, -1
	ldrb	w24, [x28, 2]
	ldrb	w20, [x0, 8]
	bl	nandc_wait_flash_ready
	adrp	x6, .LANCHOR46
	add	x6, x6, :lo12:.LANCHOR46
	mov	w5, 0
	adrp	x7, .LANCHOR159
	adrp	x8, .LANCHOR161
.L1844:
	cmp	w5, w24
	bcc	.L1849
.L1848:
	adrp	x0, .LANCHOR46
	add	x23, x28, x23
	ldrb	w0, [x0, #:lo12:.LANCHOR46]
	strb	w20, [x23, 8]
	add	w0, w0, w0, lsl 1
	cmp	w19, w0, lsr 2
	bcc	.L1850
	cmn	w19, #1
	mov	w0, 256
	csel	w19, w19, w0, eq
.L1850:
	cmp	w19, 256
	ccmn	w19, #1, 4, ne
	bne	.L1851
	adrp	x0, .LC116
	mov	w4, w19
	mov	w3, w5
	mov	w2, w22
	mov	w1, w5
	add	x0, x0, :lo12:.LC116
	bl	printf
.L1851:
	bl	nandc_wait_flash_ready
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L1849:
	add	w20, w20, 1
	stp	x6, x8, [x29, 96]
	and	w20, w20, 255
	str	x7, [x29, 112]
	cmp	w24, w20
	str	w5, [x29, 124]
	csel	w20, w20, wzr, hi
	mov	w0, w21
	mov	w1, w20
	bl	hynix_set_rr_para
	mov	w4, w27
	mov	x3, x26
	mov	x2, x25
	mov	w1, w22
	mov	w0, w21
	bl	flash_read_page
	ldr	w5, [x29, 124]
	cmn	w0, #1
	ldp	x6, x8, [x29, 96]
	ldr	x7, [x29, 112]
	beq	.L1846
	ldrb	w1, [x6]
	cmn	w19, #1
	csel	w19, w19, w0, ne
	ldr	x25, [x7, #:lo12:.LANCHOR159]
	ldr	x26, [x8, #:lo12:.LANCHOR161]
	add	w1, w1, w1, lsl 1
	cmp	w0, w1, lsr 2
	bcc	.L1852
.L1846:
	add	w5, w5, 1
	b	.L1844
.L1852:
	mov	w19, w0
	b	.L1848
	.size	hynix_read_retrial, .-hynix_read_retrial
	.section	.text.flash_ddr_tuning_read,"ax",@progbits
	.align	2
	.global	flash_ddr_tuning_read
	.type	flash_ddr_tuning_read, %function
flash_ddr_tuning_read:
	stp	x29, x30, [sp, -144]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w20, w0, 255
	stp	x21, x22, [sp, 32]
	mov	w22, w1
	stp	x23, x24, [sp, 48]
	mov	x23, x2
	stp	x25, x26, [sp, 64]
	mov	x24, x3
	stp	x27, x28, [sp, 80]
	adrp	x25, .LANCHOR46
	str	w4, [x29, 136]
	bl	nandc_get_ddr_para
	add	x25, x25, :lo12:.LANCHOR46
	str	w0, [x29, 132]
	adrp	x0, .LANCHOR14
	add	x0, x0, :lo12:.LANCHOR14
	mov	w28, 0
	str	x0, [x29, 120]
	mov	w26, 0
	adrp	x0, .LC117
	mov	w27, 0
	add	x0, x0, :lo12:.LC117
	mov	w19, 1024
	mov	w21, -1
	mov	w7, 6
	str	wzr, [x29, 140]
	str	x0, [x29, 112]
.L1868:
	mov	w0, w7
	str	w7, [x29, 128]
	bl	nandc_set_ddr_para
	ldr	w4, [x29, 136]
	mov	x3, x24
	mov	x2, x23
	mov	w1, w22
	mov	w0, w20
	bl	flash_read_page
	mov	w4, w0
	ldr	x0, [x29, 120]
	ldr	w7, [x29, 128]
	ldr	w0, [x0]
	tbz	x0, 4, .L1863
	ldr	x0, [x29, 112]
	mov	w3, w4
	mov	w1, w7
	str	w4, [x29, 108]
	str	w7, [x29, 128]
	mov	w2, w22
	bl	printf
	ldr	w4, [x29, 108]
	ldr	w7, [x29, 128]
.L1863:
	add	w0, w19, 1
	cmp	w4, w0
	bhi	.L1864
	adrp	x0, .LANCHOR159
	ldr	x23, [x0, #:lo12:.LANCHOR159]
	adrp	x0, .LANCHOR161
	ldr	x24, [x0, #:lo12:.LANCHOR161]
	ldrb	w0, [x25]
	cmp	w4, w0, lsr 2
	bcs	.L1874
	add	w27, w27, 1
	cmp	w27, 7
	bls	.L1874
	sub	w28, w7, w27
	mov	w19, w4
	mov	w21, 0
.L1866:
	ldr	w0, [x29, 140]
	cmp	w27, w26
	csel	w28, w28, w0, cs
.L1867:
	cbz	w28, .L1869
	adrp	x0, .LANCHOR46
	mov	w1, 3
	ldrb	w0, [x0, #:lo12:.LANCHOR46]
	udiv	w0, w0, w1
	cmp	w0, w19
	bls	.L1869
	mov	w1, w28
	adrp	x0, .LC118
	add	x0, x0, :lo12:.LC118
	bl	printf
	mov	w0, w28
.L1885:
	bl	nandc_set_ddr_para
	cbz	w21, .L1862
	mov	w2, w22
	mov	w1, w20
	adrp	x0, .LC119
	add	x0, x0, :lo12:.LC119
	bl	printf
	mov	w0, w20
	bl	flash_reset
	mov	w0, 1
	bl	flash_set_interface_mode
	mov	w0, 1
	bl	nandc_set_if_mode
	adrp	x0, .LANCHOR33
	add	x0, x0, :lo12:.LANCHOR33
	mov	w1, 2
	strb	w1, [x0, w20, sxtw]
	mov	w0, w20
	bl	zftl_flash_enter_slc_mode
	ldr	w4, [x29, 136]
	mov	x3, x24
	mov	x2, x23
	mov	w1, w22
	mov	w0, w20
	bl	flash_read_page
	mov	w19, w0
	mov	w3, w0
	mov	w2, w22
	mov	w1, w20
	adrp	x0, .LC120
	add	x0, x0, :lo12:.LC120
	bl	printf
	adrp	x0, .LANCHOR46
	ldrb	w0, [x0, #:lo12:.LANCHOR46]
	cmp	w19, w0
	bhi	.L1876
	adrp	x1, .LANCHOR163
	ldr	w0, [x1, #:lo12:.LANCHOR163]
	add	w0, w0, 1
	str	w0, [x1, #:lo12:.LANCHOR163]
	cmp	w0, 100
	bls	.L1872
	adrp	x0, .LANCHOR21
	strb	wzr, [x0, #:lo12:.LANCHOR21]
.L1862:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	ret
.L1864:
	cmp	w27, w26
	bls	.L1875
	sub	w0, w28, w27
	str	w0, [x29, 140]
	cmp	w27, 7
	bhi	.L1867
	mov	w26, w27
.L1875:
	mov	w27, 0
	b	.L1865
.L1874:
	mov	w28, w7
	mov	w19, w4
	mov	w21, 0
.L1865:
	add	w7, w7, 2
	cmp	w7, 50
	bne	.L1868
	b	.L1866
.L1869:
	ldrb	w0, [x29, 132]
	b	.L1885
.L1876:
	mov	w19, w21
.L1872:
	adrp	x20, .LANCHOR45
	ldrb	w0, [x20, #:lo12:.LANCHOR45]
	bl	flash_set_interface_mode
	ldrb	w0, [x20, #:lo12:.LANCHOR45]
	bl	nandc_set_if_mode
	b	.L1862
	.size	flash_ddr_tuning_read, .-flash_ddr_tuning_read
	.section	.text.flash_read_page_en,"ax",@progbits
	.align	2
	.global	flash_read_page_en
	.type	flash_read_page_en, %function
flash_read_page_en:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w20, w0, 255
	adrp	x0, .LANCHOR18
	stp	x23, x24, [sp, 48]
	stp	x21, x22, [sp, 32]
	mov	w19, w1
	str	x25, [sp, 64]
	mov	x22, x2
	ldrb	w1, [x0, #:lo12:.LANCHOR18]
	mov	x23, x3
	mov	w24, w4
	mov	x25, x0
	cmp	w1, w20
	bhi	.L1887
	adrp	x1, .LANCHOR164
	adrp	x0, .LC0
	mov	w2, 404
	add	x1, x1, :lo12:.LANCHOR164
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1887:
	adrp	x0, .LANCHOR30
	add	x0, x0, :lo12:.LANCHOR30
	ldrb	w21, [x0, w20, sxtw]
	ldrb	w0, [x25, #:lo12:.LANCHOR18]
	cmp	w0, w20
	bcs	.L1888
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbnz	x0, 6, .L1889
.L1913:
	mov	w0, -1
.L1886:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L1889:
	mov	w3, w19
	mov	w2, w20
	mov	w1, w21
	adrp	x0, .LC121
	add	x0, x0, :lo12:.LC121
	bl	printf
	b	.L1913
.L1888:
	tst	x19, 50331648
	bne	.L1891
	adrp	x0, .LANCHOR0
	adrp	x1, .LANCHOR1
	ldrb	w0, [x0, #:lo12:.LANCHOR0]
	cbz	w0, .L1892
	ldrb	w0, [x1, #:lo12:.LANCHOR1]
	cbz	w0, .L1891
.L1892:
	adrp	x0, .LANCHOR2
	ldrb	w1, [x1, #:lo12:.LANCHOR1]
	ldrh	w2, [x0, #:lo12:.LANCHOR2]
	udiv	w0, w19, w2
	mul	w0, w0, w2
	sub	w19, w19, w0
	cbz	w1, .L1893
	add	w19, w0, w19, lsl 1
.L1891:
	mov	w4, w24
	mov	x3, x23
	mov	x2, x22
	mov	w1, w19
	mov	w0, w21
	bl	flash_read_page
	cmn	w0, #1
	bne	.L1886
	adrp	x20, .LANCHOR48
	ldrb	w25, [x20, #:lo12:.LANCHOR48]
	cbnz	w25, .L1894
.L1897:
	adrp	x0, .LANCHOR165
	ldr	x5, [x0, #:lo12:.LANCHOR165]
	cbnz	x5, .L1895
.L1896:
	ldrb	w4, [x20, #:lo12:.LANCHOR48]
	mov	w3, -1
	mov	w2, w19
	mov	w1, 0
	adrp	x0, .LC122
	add	x0, x0, :lo12:.LC122
	bl	printf
	adrp	x0, .LANCHOR21
	ldrb	w0, [x0, #:lo12:.LANCHOR21]
	cbz	w0, .L1913
	mov	w4, w24
	mov	x3, x23
	mov	x2, x22
	mov	w1, w19
	mov	w0, w21
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	b	flash_ddr_tuning_read
.L1893:
	adrp	x1, .LANCHOR3
	add	x1, x1, :lo12:.LANCHOR3
	ldrh	w19, [x1, w19, uxtw 1]
	add	w19, w19, w0
	b	.L1891
.L1894:
	strb	wzr, [x20, #:lo12:.LANCHOR48]
	mov	w4, w24
	mov	x3, x23
	mov	x2, x22
	mov	w1, w19
	mov	w0, w21
	bl	flash_read_page
	strb	w25, [x20, #:lo12:.LANCHOR48]
	cmn	w0, #1
	beq	.L1897
	b	.L1886
.L1895:
	mov	w4, w24
	mov	x3, x23
	mov	x2, x22
	mov	w1, w19
	mov	w0, w21
	blr	x5
	cmn	w0, #1
	beq	.L1896
	b	.L1886
	.size	flash_read_page_en, .-flash_read_page_en
	.section	.text.flash_get_last_written_page,"ax",@progbits
	.align	2
	.global	flash_get_last_written_page
	.type	flash_get_last_written_page, %function
flash_get_last_written_page:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	and	w23, w0, 255
	adrp	x0, .LANCHOR142
	stp	x19, x20, [sp, 16]
	stp	x25, x26, [sp, 64]
	mov	x24, x2
	ldrh	w19, [x0, #:lo12:.LANCHOR142]
	adrp	x0, .LANCHOR32+26
	stp	x21, x22, [sp, 32]
	and	w21, w1, 65535
	ldrh	w26, [x0, #:lo12:.LANCHOR32+26]
	sub	w19, w19, #1
	sxth	w19, w19
	stp	x27, x28, [sp, 80]
	mov	x22, x3
	mov	w25, w4
	mov	w0, w23
	mul	w26, w26, w21
	add	w1, w19, w26
	bl	flash_read_page_en
	cmp	w0, 512
	bne	.L1915
	mov	w27, 0
	mov	w28, 2
.L1916:
	cmp	w27, w19
	ble	.L1919
.L1915:
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L1920
	ldr	w3, [x22]
	adrp	x0, .LC123
	mov	w2, w19
	mov	w1, w21
	add	x0, x0, :lo12:.LC123
	bl	printf
.L1920:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L1919:
	add	w20, w27, w19
	mov	w4, w25
	mov	x3, x22
	mov	x2, x24
	mov	w0, w23
	sdiv	w20, w20, w28
	add	w1, w26, w20, sxth
	bl	flash_read_page_en
	cmp	w0, 512
	bne	.L1917
	sub	w19, w20, #1
	sxth	w19, w19
	b	.L1916
.L1917:
	add	w20, w20, 1
	sxth	w27, w20
	b	.L1916
	.size	flash_get_last_written_page, .-flash_get_last_written_page
	.section	.text.flash_get_last_written_page_ext,"ax",@progbits
	.align	2
	.global	flash_get_last_written_page_ext
	.type	flash_get_last_written_page_ext, %function
flash_get_last_written_page_ext:
	adrp	x4, .LANCHOR31
	mov	w5, 24
	and	w0, w0, 65535
	mov	w6, 1
	ldrb	w4, [x4, #:lo12:.LANCHOR31]
	sub	w5, w5, w4
	adrp	x4, .LANCHOR68
	ldrh	w4, [x4, #:lo12:.LANCHOR68]
	sub	w5, w5, w4
	mov	w4, w3
	mov	x3, x2
	mov	x2, x1
	lsl	w6, w6, w5
	sub	w6, w6, #1
	and	w1, w6, w0
	asr	w0, w0, w5
	b	flash_get_last_written_page
	.size	flash_get_last_written_page_ext, .-flash_get_last_written_page_ext
	.section	.text.flash_ddr_para_scan,"ax",@progbits
	.align	2
	.global	flash_ddr_para_scan
	.type	flash_ddr_para_scan, %function
flash_ddr_para_scan:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR45
	stp	x21, x22, [sp, 32]
	and	w22, w0, 255
	ldrb	w0, [x20, #:lo12:.LANCHOR45]
	adrp	x19, .LANCHOR21
	stp	x23, x24, [sp, 48]
	mov	w21, 1
	mov	w23, w1
	str	x25, [sp, 64]
	strb	w21, [x19, #:lo12:.LANCHOR21]
	adrp	x24, .LANCHOR167
	bl	flash_set_interface_mode
	adrp	x25, .LANCHOR166
	ldrb	w0, [x20, #:lo12:.LANCHOR45]
	bl	nandc_set_if_mode
	ldr	x3, [x25, #:lo12:.LANCHOR166]
	mov	w4, 4
	ldr	x2, [x24, #:lo12:.LANCHOR167]
	mov	w1, w23
	mov	w0, w22
	bl	flash_ddr_tuning_read
	ldr	x3, [x25, #:lo12:.LANCHOR166]
	mov	w4, 4
	ldr	x2, [x24, #:lo12:.LANCHOR167]
	mov	w1, w23
	mov	w0, w22
	bl	flash_read_page
	cmn	w0, #1
	mov	x0, x19
	bne	.L1927
	ldrb	w1, [x20, #:lo12:.LANCHOR45]
	tbz	x1, 0, .L1927
	mov	w0, 1
	bl	flash_set_interface_mode
	mov	w0, w21
	bl	nandc_set_if_mode
	strb	wzr, [x19, #:lo12:.LANCHOR21]
.L1928:
	mov	w0, 0
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L1927:
	mov	w1, 1
	strb	w1, [x0, #:lo12:.LANCHOR21]
	b	.L1928
	.size	flash_ddr_para_scan, .-flash_ddr_para_scan
	.section	.text.flash_complete_plane_page_read,"ax",@progbits
	.align	2
	.global	flash_complete_plane_page_read
	.type	flash_complete_plane_page_read, %function
flash_complete_plane_page_read:
	stp	x29, x30, [sp, -64]!
	mov	w4, 24
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	mov	w24, w0
	adrp	x0, .LANCHOR31
	stp	x21, x22, [sp, 32]
	stp	x19, x20, [sp, 16]
	mov	w19, 1
	ldrb	w0, [x0, #:lo12:.LANCHOR31]
	mov	x20, x1
	mov	x21, x2
	sub	w22, w4, w0
	lsl	w19, w19, w0
	sub	w19, w19, #1
	lsr	w0, w24, w22
	and	w19, w19, w0
	adrp	x0, .LANCHOR18
	and	w19, w19, 255
	mov	x23, x0
	ldrb	w1, [x0, #:lo12:.LANCHOR18]
	cmp	w1, w19
	bhi	.L1934
	adrp	x1, .LANCHOR168
	adrp	x0, .LC0
	mov	w2, 909
	add	x1, x1, :lo12:.LANCHOR168
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1934:
	ldrb	w0, [x23, #:lo12:.LANCHOR18]
	cmp	w0, w19
	bls	.L1942
	adrp	x2, .LANCHOR30
	add	x2, x2, :lo12:.LANCHOR30
	adrp	x0, .LANCHOR13
	mov	w4, 1
	lsl	w4, w4, w22
	sub	w4, w4, #1
	ldrb	w7, [x2, w19, sxtw]
	and	w4, w4, w24
	ldr	x6, [x0, #:lo12:.LANCHOR13]
	ubfx	x24, x24, 24, 2
	mov	w0, w7
	bl	nandc_cs
	cbnz	w24, .L1936
	mov	w0, w4
	bl	slc_phy_page_address_calc
	mov	w4, w0
.L1936:
	adrp	x0, .LANCHOR20+16
	and	x1, x7, 255
	and	w5, w4, 255
	lsr	w3, w4, 8
	ldrb	w0, [x0, #:lo12:.LANCHOR20+16]
	lsr	w2, w4, 16
	cmp	w0, 1
	adrp	x0, .LANCHOR16
	bne	.L1937
	add	x1, x6, x1, lsl 8
	mov	w6, 6
.L1949:
	str	w6, [x1, 2056]
	str	wzr, [x1, 2052]
	str	wzr, [x1, 2052]
	str	w5, [x1, 2052]
	str	w3, [x1, 2052]
	str	w2, [x1, 2052]
.L1947:
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	mov	w2, 224
	str	w2, [x1, 2056]
	ldrb	w0, [x0, 12]
	cmp	w0, 3
	bne	.L1940
	cbz	w24, .L1940
	adrp	x0, .LANCHOR35
	ldrb	w0, [x0, #:lo12:.LANCHOR35]
	cbnz	w0, .L1940
	add	w4, w4, w4, lsl 1
	sub	w0, w24, #1
	add	w0, w4, w0
.L1948:
	bl	nandc_set_seed
	adrp	x0, .LANCHOR32+9
	mov	x4, x21
	mov	x3, x20
	mov	w1, 0
	ldrb	w2, [x0, #:lo12:.LANCHOR32+9]
	mov	w0, w7
	bl	nandc_xfer
	mov	w2, w0
	bl	nandc_de_cs.constprop.30
	mov	w0, w2
.L1933:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L1937:
	ldr	x8, [x0, #:lo12:.LANCHOR16]
	add	x1, x6, x1, lsl 8
	ldrb	w8, [x8, 12]
	cmp	w8, 3
	bne	.L1939
	mov	w6, 5
	b	.L1949
.L1939:
	str	wzr, [x1, 2056]
	str	wzr, [x1, 2052]
	str	wzr, [x1, 2052]
	str	w5, [x1, 2052]
	str	w3, [x1, 2052]
	str	w2, [x1, 2052]
	mov	w2, 5
	str	w2, [x1, 2056]
	str	wzr, [x1, 2052]
	str	wzr, [x1, 2052]
	b	.L1947
.L1940:
	mov	w0, w4
	b	.L1948
.L1942:
	mov	w0, -1
	b	.L1933
	.size	flash_complete_plane_page_read, .-flash_complete_plane_page_read
	.section	.text.flash_complete_page_read,"ax",@progbits
	.align	2
	.global	flash_complete_page_read
	.type	flash_complete_page_read, %function
flash_complete_page_read:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	mov	w21, w0
	adrp	x0, .LANCHOR31
	stp	x19, x20, [sp, 16]
	mov	x22, x1
	mov	w1, 24
	ldrb	w20, [x0, #:lo12:.LANCHOR31]
	mov	w0, 1
	stp	x23, x24, [sp, 48]
	mov	x23, x2
	sub	w1, w1, w20
	stp	x25, x26, [sp, 64]
	lsl	w20, w0, w20
	sub	w20, w20, #1
	lsl	w19, w0, w1
	adrp	x0, .LANCHOR18
	lsr	w1, w21, w1
	stp	x27, x28, [sp, 80]
	and	w20, w20, w1
	ldrb	w0, [x0, #:lo12:.LANCHOR18]
	sub	w19, w19, #1
	and	w20, w20, 255
	and	w19, w19, w21
	ubfx	x24, x21, 24, 2
	cmp	w0, w20
	bhi	.L1951
	adrp	x1, .LANCHOR169
	adrp	x0, .LC0
	mov	w2, 1033
	add	x1, x1, :lo12:.LANCHOR169
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1951:
	adrp	x0, .LANCHOR30
	add	x0, x0, :lo12:.LANCHOR30
	ldrb	w25, [x0, w20, sxtw]
	adrp	x0, .LANCHOR13
	ldr	x4, [x0, #:lo12:.LANCHOR13]
	mov	w0, w25
	bl	nandc_cs
	cbnz	w24, .L1952
	mov	w0, w19
	bl	slc_phy_page_address_calc
	mov	w19, w0
.L1952:
	ubfiz	x0, x25, 8, 8
	mov	w1, 5
	add	x0, x4, x0
	str	w1, [x0, 2056]
	and	w1, w19, 255
	str	wzr, [x0, 2052]
	str	wzr, [x0, 2052]
	str	w1, [x0, 2052]
	lsr	w1, w19, 8
	str	w1, [x0, 2052]
	lsr	w1, w19, 16
	str	w1, [x0, 2052]
	mov	w1, 224
	str	w1, [x0, 2056]
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrb	w0, [x0, 12]
	cmp	w0, 3
	bne	.L1953
	cbz	w24, .L1953
	adrp	x0, .LANCHOR35
	ldrb	w0, [x0, #:lo12:.LANCHOR35]
	cbnz	w0, .L1953
	sub	w0, w24, #1
	add	w1, w19, w19, lsl 1
	add	w0, w0, w1
.L1980:
	adrp	x20, .LANCHOR32
	add	x28, x20, :lo12:.LANCHOR32
	bl	nandc_set_seed
	mov	x4, x23
	mov	x3, x22
	ldrb	w2, [x28, 9]
	mov	w1, 0
	mov	w0, w25
	bl	nandc_xfer
	cmn	w0, #1
	bne	.L1955
	adrp	x26, .LANCHOR48
	ldrb	w27, [x26, #:lo12:.LANCHOR48]
	cbz	w27, .L1956
	ldrb	w4, [x28, 9]
	mov	x3, x23
	strb	wzr, [x26, #:lo12:.LANCHOR48]
	mov	x2, x22
	orr	w1, w19, w24, lsl 24
	mov	w0, w25
	bl	flash_read_page
	strb	w27, [x26, #:lo12:.LANCHOR48]
	cbnz	w24, .L1957
.L1962:
	adrp	x1, .LANCHOR0
	ldrb	w1, [x1, #:lo12:.LANCHOR0]
	cbz	w1, .L1957
	adrp	x1, .LANCHOR46
	ldrb	w1, [x1, #:lo12:.LANCHOR46]
	add	w1, w1, w1, lsl 1
	cmp	w0, w1, lsr 2
	blt	.L1957
	add	x20, x20, :lo12:.LANCHOR32
	ldrb	w1, [x20, 19]
	sub	w1, w1, #4
	and	w1, w1, 255
	cmp	w1, 4
	mov	w1, 256
	csel	w0, w0, w1, hi
.L1950:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L1953:
	mov	w0, w19
	b	.L1980
.L1957:
	cmn	w0, #1
	bne	.L1950
.L1963:
	adrp	x0, .LANCHOR165
	ldr	x5, [x0, #:lo12:.LANCHOR165]
	cbnz	x5, .L1959
.L1961:
	adrp	x0, .LANCHOR48
	mov	w3, -1
	mov	w2, w21
	mov	w1, 0
	ldrb	w4, [x0, #:lo12:.LANCHOR48]
	adrp	x0, .LC124
	add	x0, x0, :lo12:.LC124
	bl	printf
	adrp	x0, .LANCHOR21
	ldrb	w0, [x0, #:lo12:.LANCHOR21]
	cbnz	w0, .L1960
	mov	w0, -1
	b	.L1950
.L1959:
	add	x0, x20, :lo12:.LANCHOR32
	mov	x3, x23
	mov	x2, x22
	orr	w1, w19, w24, lsl 24
	ldrb	w4, [x0, 9]
	mov	w0, w25
	blr	x5
	cmn	w0, #1
	beq	.L1961
	b	.L1950
.L1960:
	add	x20, x20, :lo12:.LANCHOR32
	orr	w1, w19, w24, lsl 24
	mov	x3, x23
	mov	x2, x22
	mov	w0, w25
	ldrb	w4, [x20, 9]
	ldp	x21, x22, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	b	flash_ddr_tuning_read
.L1955:
	cbz	w24, .L1962
	b	.L1950
.L1956:
	cbnz	w24, .L1963
	b	.L1962
	.size	flash_complete_page_read, .-flash_complete_page_read
	.section	.text.queue_wait_first_req_completed,"ax",@progbits
	.align	2
	.type	queue_wait_first_req_completed, %function
queue_wait_first_req_completed:
	stp	x29, x30, [sp, -96]!
	adrp	x0, .LANCHOR56
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	ldrb	w0, [x0, #:lo12:.LANCHOR56]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	cmp	w0, 255
	stp	x25, x26, [sp, 64]
	str	x27, [sp, 80]
	bne	.L1982
.L2015:
	mov	w21, 0
	b	.L1981
.L1982:
	adrp	x19, .LANCHOR52
	sxtw	x20, w0
	add	x1, x19, :lo12:.LANCHOR52
	add	x1, x1, x20, lsl 6
	ldrb	w2, [x1, 58]
	ldr	w21, [x1, 40]
	sub	w3, w2, #1
	cmp	w3, 10
	bhi	.L2015
	adrp	x1, .L1985
	add	x1, x1, :lo12:.L1985
	ldrh	w1, [x1,w3,uxtw #1]
	adr	x3, .Lrtx1985
	add	x1, x3, w1, sxth #2
	br	x1
.Lrtx1985:
	.section	.rodata.queue_wait_first_req_completed,"a",@progbits
	.align	0
	.align	2
.L1985:
	.2byte	(.L1984 - .Lrtx1985) / 4
	.2byte	(.L1986 - .Lrtx1985) / 4
	.2byte	(.L1987 - .Lrtx1985) / 4
	.2byte	(.L1987 - .Lrtx1985) / 4
	.2byte	(.L1987 - .Lrtx1985) / 4
	.2byte	(.L1987 - .Lrtx1985) / 4
	.2byte	(.L1988 - .Lrtx1985) / 4
	.2byte	(.L1989 - .Lrtx1985) / 4
	.2byte	(.L1990 - .Lrtx1985) / 4
	.2byte	(.L1987 - .Lrtx1985) / 4
	.2byte	(.L1990 - .Lrtx1985) / 4
	.section	.text.queue_wait_first_req_completed
.L1984:
	mov	w1, 64
	mov	w0, w21
	bl	flash_wait_device_ready
	tbz	x0, 6, .L2015
	add	x0, x19, :lo12:.LANCHOR52
	add	x0, x0, x20, lsl 6
	ldp	x1, x2, [x0, 8]
	cbz	x2, .L1992
	ldrb	w3, [x0, 56]
	adrp	x0, .LANCHOR125
	ldrb	w0, [x0, #:lo12:.LANCHOR125]
	cmp	w3, w0
	csel	x1, x1, x2, ne
.L1992:
	add	x19, x19, :lo12:.LANCHOR52
	mov	w0, w21
	add	x20, x19, x20, lsl 6
	ldr	x2, [x20, 24]
	bl	flash_complete_page_read
	str	w0, [x20, 52]
	mov	w0, 13
	strb	w0, [x20, 58]
	ldrb	w0, [x20, 2]
	orr	w0, w0, 8
	strb	w0, [x20, 2]
	b	.L2015
.L1986:
	mov	w1, 64
	mov	w0, w21
	bl	flash_wait_device_ready
	tbz	x0, 6, .L2015
	add	x0, x19, :lo12:.LANCHOR52
	lsl	x2, x20, 6
	add	x1, x0, x2
	ldrb	w21, [x0, x2]
	add	x0, x0, x21, lsl 6
	ldr	x24, [x0, 8]
	ldp	x26, x0, [x1, 8]
	cbz	x0, .L1993
	ldrb	w2, [x1, 56]
	adrp	x1, .LANCHOR125
	ldrb	w1, [x1, #:lo12:.LANCHOR125]
	cmp	w2, w1
	csel	x26, x26, x0, ne
.L1993:
	add	x0, x19, :lo12:.LANCHOR52
	add	x0, x0, x21, lsl 6
	ldr	x1, [x0, 16]
	cbz	x1, .L1994
	ldrb	w2, [x0, 56]
	adrp	x0, .LANCHOR125
	ldrb	w0, [x0, #:lo12:.LANCHOR125]
	cmp	w2, w0
	csel	x24, x24, x1, ne
.L1994:
	add	x22, x19, :lo12:.LANCHOR52
	mov	x1, x26
	add	x27, x22, x20, lsl 6
	add	x22, x22, x21, lsl 6
	ldr	x2, [x27, 24]
	ldr	w0, [x27, 40]
	bl	flash_complete_plane_page_read
	mov	w23, w0
	ldr	x2, [x22, 24]
	mov	x1, x24
	ldr	w0, [x22, 40]
	bl	flash_complete_plane_page_read
	mov	w25, w0
	cmn	w23, #1
	beq	.L1995
	ldr	w0, [x27, 36]
	cmn	w0, #1
	beq	.L1996
	ldr	x1, [x27, 24]
	ldr	w1, [x1, 4]
	cmp	w0, w1
	beq	.L1996
.L1995:
	adrp	x0, .LANCHOR31
	add	x22, x19, :lo12:.LANCHOR52
	add	x22, x22, x20, lsl 6
	mov	w5, 1
	ldrb	w2, [x0, #:lo12:.LANCHOR31]
	mov	w0, 24
	sub	w0, w0, w2
	ldr	x3, [x22, 24]
	lsl	w5, w5, w2
	adrp	x2, .LANCHOR125
	sub	w5, w5, #1
	ldr	w1, [x22, 40]
	ldrb	w4, [x2, #:lo12:.LANCHOR125]
	mov	x2, x26
	lsl	w6, w5, w0
	lsr	w0, w1, w0
	bic	w1, w1, w6
	and	w0, w0, w5
	bl	flash_read_page_en
	mov	w23, w0
	ldr	w2, [x22, 36]
	cmn	w2, #1
	beq	.L1997
	ldr	x0, [x22, 24]
	ldr	w4, [x0, 4]
	cmp	w2, w4
	beq	.L1997
	adrp	x1, .LANCHOR14
	ldr	w1, [x1, #:lo12:.LANCHOR14]
	tbz	x1, 6, .L1997
	ldr	w3, [x0]
	adrp	x0, .LC125
	ldr	w1, [x22, 40]
	add	x0, x0, :lo12:.LC125
	bl	printf
.L1997:
	add	x0, x19, :lo12:.LANCHOR52
	add	x0, x0, x20, lsl 6
	ldr	w1, [x0, 36]
	cmn	w1, #1
	beq	.L1996
	ldr	x0, [x0, 24]
	ldr	w0, [x0, 4]
	cmp	w1, w0
	beq	.L1996
	adrp	x1, .LANCHOR170
	adrp	x0, .LC0
	mov	w2, 360
	add	x1, x1, :lo12:.LANCHOR170
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1996:
	add	x0, x19, :lo12:.LANCHOR52
	mov	w1, 13
	add	x20, x0, x20, lsl 6
	cmn	w25, #1
	strb	w1, [x20, 58]
	ldrb	w1, [x20, 2]
	str	w23, [x20, 52]
	orr	w1, w1, 8
	strb	w1, [x20, 2]
	beq	.L1998
	add	x0, x0, x21, lsl 6
	ldr	w1, [x0, 36]
	cmn	w1, #1
	beq	.L2000
	ldr	x0, [x0, 24]
	ldr	w0, [x0, 4]
	cmp	w1, w0
	beq	.L2000
.L1998:
	adrp	x0, .LANCHOR31
	add	x20, x19, :lo12:.LANCHOR52
	add	x20, x20, x21, lsl 6
	mov	w5, 1
	ldrb	w2, [x0, #:lo12:.LANCHOR31]
	mov	w0, 24
	sub	w0, w0, w2
	ldr	x3, [x20, 24]
	lsl	w5, w5, w2
	adrp	x2, .LANCHOR125
	sub	w5, w5, #1
	ldr	w1, [x20, 40]
	ldrb	w4, [x2, #:lo12:.LANCHOR125]
	mov	x2, x24
	lsl	w6, w5, w0
	lsr	w0, w1, w0
	bic	w1, w1, w6
	and	w0, w0, w5
	bl	flash_read_page_en
	ldr	w2, [x20, 36]
	cmn	w2, #1
	beq	.L2002
	ldr	x0, [x20, 24]
	ldr	w4, [x0, 4]
	cmp	w2, w4
	beq	.L2002
	adrp	x1, .LANCHOR14
	ldr	w1, [x1, #:lo12:.LANCHOR14]
	tbz	x1, 6, .L2002
	ldr	w3, [x0]
	adrp	x0, .LC125
	ldr	w1, [x20, 40]
	add	x0, x0, :lo12:.LC125
	bl	printf
.L2002:
	add	x0, x19, :lo12:.LANCHOR52
	add	x0, x0, x21, lsl 6
	ldr	w1, [x0, 36]
	cmn	w1, #1
	beq	.L2000
	ldr	x0, [x0, 24]
	ldr	w0, [x0, 4]
	cmp	w1, w0
	beq	.L2000
	adrp	x1, .LANCHOR170
	adrp	x0, .LC0
	mov	w2, 375
	add	x1, x1, :lo12:.LANCHOR170
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2000:
	add	x19, x19, :lo12:.LANCHOR52
	mov	w0, 13
	add	x21, x19, x21, lsl 6
	strb	w0, [x21, 58]
	ldrb	w0, [x21, 2]
	str	w23, [x21, 52]
	orr	w0, w0, 8
	strb	w0, [x21, 2]
	b	.L2015
.L1987:
	mov	w0, w21
	mov	w1, 64
	bl	flash_wait_device_ready
	mov	w21, w0
	tbz	x21, 6, .L2015
	mov	w0, 5
	tst	w21, w0
	beq	.L2003
	add	x19, x19, :lo12:.LANCHOR52
	mov	w0, 12
	add	x20, x19, x20, lsl 6
	mov	w4, 12
	mov	w2, w21
	ldrb	w1, [x20, 1]
	ldr	w3, [x20, 40]
	strb	w0, [x20, 58]
	adrp	x0, .LC126
	add	x0, x0, :lo12:.LC126
	bl	printf
.L2079:
	mov	w0, -1
	str	w0, [x20, 52]
	b	.L1981
.L2003:
	add	x21, x19, :lo12:.LANCHOR52
	mov	w0, 13
	add	x21, x21, x20, lsl 6
	strb	w0, [x21, 58]
	adrp	x0, .LANCHOR104
	ldr	x0, [x0, #:lo12:.LANCHOR104]
	ldr	w1, [x0, 156]
	mov	w0, 20041
	str	wzr, [x21, 52]
	movk	w0, 0x444b, lsl 16
	cmp	w1, w0
	bne	.L2015
	ldrh	w0, [x21, 50]
	cbnz	w0, .L2015
	adrp	x0, .LANCHOR31
	mov	w5, 1
	adrp	x22, .LANCHOR166
	ldr	w1, [x21, 40]
	ldrb	w2, [x0, #:lo12:.LANCHOR31]
	mov	w0, 24
	ldr	x3, [x22, #:lo12:.LANCHOR166]
	sub	w0, w0, w2
	lsl	w5, w5, w2
	adrp	x2, .LANCHOR125
	sub	w5, w5, #1
	ldrb	w4, [x2, #:lo12:.LANCHOR125]
	adrp	x2, .LANCHOR167
	lsl	w6, w5, w0
	ldr	x2, [x2, #:lo12:.LANCHOR167]
	lsr	w0, w1, w0
	bic	w1, w1, w6
	and	w0, w0, w5
	bl	flash_read_page_en
	cmn	w0, #1
	beq	.L2004
	ldr	x1, [x22, #:lo12:.LANCHOR166]
	ldr	x2, [x21, 24]
	ldr	w1, [x1]
	ldr	w2, [x2]
	cmp	w2, w1
	beq	.L2015
.L2004:
	add	x19, x19, :lo12:.LANCHOR52
	adrp	x1, .LANCHOR48
	add	x20, x19, x20, lsl 6
	mov	w3, w0
	ldrb	w4, [x1, #:lo12:.LANCHOR48]
	adrp	x0, .LC127
	add	x0, x0, :lo12:.LC127
	ldrb	w1, [x20, 1]
	ldr	w2, [x20, 40]
	bl	printf
	mov	w0, -1
	str	w0, [x20, 52]
	b	.L2015
.L1990:
	cmp	w2, 11
	mov	w1, 3
	mov	w5, 10
	csel	w5, w5, w1, eq
	adrp	x1, .LANCHOR31
	mov	w4, 24
	mov	w2, 1
	add	x22, x19, :lo12:.LANCHOR52
	ldrb	w3, [x1, #:lo12:.LANCHOR31]
	ubfiz	x0, x0, 6, 8
	add	x0, x22, x0
	mov	x24, x1
	sub	w4, w4, w3
	lsl	w2, w2, w3
	sub	w2, w2, #1
	lsr	w3, w21, w4
	and	w3, w3, w2
	and	w3, w3, 65535
.L2006:
	ldrb	w1, [x0]
	cmp	w1, 255
	bne	.L2013
	mov	w21, -1
	b	.L1981
.L2013:
	sxtw	x23, w1
	ubfiz	x0, x1, 6, 8
	add	x1, x22, x23, lsl 6
	add	x0, x22, x0
	ldrb	w6, [x1, 58]
	cmp	w6, w5
	bne	.L2006
	ldr	w1, [x1, 40]
	lsr	w1, w1, w4
	and	w1, w1, w2
	cmp	w3, w1
	bne	.L2006
	mov	w0, w21
	mov	w1, 64
	bl	flash_wait_device_ready
	mov	w21, w0
	tbnz	x21, 6, .L2008
.L2078:
	mov	w21, 0
	b	.L2009
.L2008:
	tst	x21, 15
	beq	.L2010
	add	x22, x22, x20, lsl 6
	mov	w2, w0
	mov	w4, 12
	adrp	x0, .LC128
	add	x0, x0, :lo12:.LC128
	ldrb	w1, [x22, 1]
	ldr	w3, [x22, 40]
	bl	printf
	mov	w0, 12
	strb	w0, [x22, 58]
	mov	w0, -1
	str	w0, [x22, 52]
.L2009:
	add	x1, x19, :lo12:.LANCHOR52
	add	x20, x1, x20, lsl 6
	add	x1, x1, x23, lsl 6
	ldrb	w0, [x20, 58]
	strb	w0, [x1, 58]
	ldr	w0, [x20, 52]
	str	w0, [x1, 52]
.L1981:
	mov	w0, w21
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L2010:
	add	x21, x22, x20, lsl 6
	mov	w0, 13
	strb	w0, [x21, 58]
	adrp	x0, .LANCHOR104
	ldr	x0, [x0, #:lo12:.LANCHOR104]
	ldr	w1, [x0, 156]
	mov	w0, 20041
	str	wzr, [x21, 52]
	movk	w0, 0x444b, lsl 16
	cmp	w1, w0
	bne	.L2078
	ldrh	w0, [x21, 50]
	cbnz	w0, .L2078
	ldrb	w2, [x24, #:lo12:.LANCHOR31]
	mov	w5, 1
	mov	w0, 24
	adrp	x22, .LANCHOR166
	sub	w0, w0, w2
	ldr	w1, [x21, 40]
	lsl	w5, w5, w2
	adrp	x2, .LANCHOR125
	sub	w5, w5, #1
	ldr	x3, [x22, #:lo12:.LANCHOR166]
	ldrb	w4, [x2, #:lo12:.LANCHOR125]
	adrp	x2, .LANCHOR167
	lsl	w6, w5, w0
	ldr	x2, [x2, #:lo12:.LANCHOR167]
	lsr	w0, w1, w0
	bic	w1, w1, w6
	and	w0, w0, w5
	bl	flash_read_page_en
	cmn	w0, #1
	beq	.L2012
	ldr	x1, [x22, #:lo12:.LANCHOR166]
	ldr	x2, [x21, 24]
	ldr	w1, [x1]
	ldr	w2, [x2]
	cmp	w2, w1
	beq	.L2078
.L2012:
	add	x21, x19, :lo12:.LANCHOR52
	adrp	x1, .LANCHOR48
	add	x21, x21, x20, lsl 6
	mov	w3, w0
	ldrb	w4, [x1, #:lo12:.LANCHOR48]
	adrp	x0, .LC129
	add	x0, x0, :lo12:.LC129
	ldrb	w1, [x21, 1]
	ldr	w2, [x21, 40]
	bl	printf
	mov	w0, -1
	str	w0, [x21, 52]
	b	.L2078
.L1988:
	mov	w0, w21
	mov	w1, 32
	bl	flash_wait_device_ready
	mov	w21, w0
	tbz	x21, 5, .L2015
	add	x19, x19, :lo12:.LANCHOR52
	tst	x21, 15
	add	x20, x19, x20, lsl 6
	beq	.L2014
	mov	w0, 12
	strb	w0, [x20, 58]
	b	.L2079
.L2014:
	mov	w0, 13
	str	wzr, [x20, 52]
	strb	w0, [x20, 58]
	b	.L2015
.L1989:
	mov	w1, 64
	mov	w0, w21
	bl	flash_wait_device_ready
	tbz	x0, 6, .L2015
	add	x19, x19, :lo12:.LANCHOR52
	add	x19, x19, x20, lsl 6
	str	w0, [x19, 52]
	mov	w0, 7
	strb	w0, [x19, 58]
	b	.L2015
	.size	queue_wait_first_req_completed, .-queue_wait_first_req_completed
	.section	.text.sblk_wait_write_queue_completed,"ax",@progbits
	.align	2
	.global	sblk_wait_write_queue_completed
	.type	sblk_wait_write_queue_completed, %function
sblk_wait_write_queue_completed:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	str	x19, [sp, 16]
	adrp	x19, .LANCHOR56
	add	x19, x19, :lo12:.LANCHOR56
.L2081:
	ldrb	w0, [x19]
	cmp	w0, 255
	bne	.L2082
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L2082:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2081
	.size	sblk_wait_write_queue_completed, .-sblk_wait_write_queue_completed
	.section	.text.ftl_read_page,"ax",@progbits
	.align	2
	.global	ftl_read_page
	.type	ftl_read_page, %function
ftl_read_page:
	stp	x29, x30, [sp, -64]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w19, w0, 255
	stp	x21, x22, [sp, 32]
	mov	w20, w1
	mov	x21, x2
	mov	x22, x3
	str	x23, [sp, 48]
	mov	w23, w4
	bl	sblk_wait_write_queue_completed
	mov	w4, w23
	mov	x3, x22
	mov	x2, x21
	mov	w1, w20
	mov	w0, w19
	ldr	x23, [sp, 48]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	b	flash_read_page_en
	.size	ftl_read_page, .-ftl_read_page
	.section	.text.ftl_read_ppa_page,"ax",@progbits
	.align	2
	.global	ftl_read_ppa_page
	.type	ftl_read_ppa_page, %function
ftl_read_ppa_page:
	stp	x29, x30, [sp, -64]!
	mov	w5, 1
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w20, w0
	adrp	x0, .LANCHOR31
	mov	w19, 24
	stp	x21, x22, [sp, 32]
	mov	x21, x1
	ldrb	w0, [x0, #:lo12:.LANCHOR31]
	mov	x22, x2
	str	x23, [sp, 48]
	mov	w23, w3
	sub	w19, w19, w0
	lsl	w5, w5, w0
	sub	w5, w5, #1
	lsr	w19, w20, w19
	and	w19, w19, w5
	and	w19, w19, 255
	bl	sblk_wait_write_queue_completed
	mov	w4, w23
	mov	x3, x22
	mov	x2, x21
	mov	w1, w20
	mov	w0, w19
	ldr	x23, [sp, 48]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	b	flash_read_page_en
	.size	ftl_read_ppa_page, .-ftl_read_ppa_page
	.section	.text.sblk_read_page,"ax",@progbits
	.align	2
	.global	sblk_read_page
	.type	sblk_read_page, %function
sblk_read_page:
	stp	x29, x30, [sp, -128]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	and	w22, w1, 255
	stp	x27, x28, [sp, 80]
	mov	w21, w22
	stp	x19, x20, [sp, 16]
	adrp	x27, .LANCHOR31
	stp	x23, x24, [sp, 48]
	mov	x19, x0
	stp	x25, x26, [sp, 64]
	mov	x23, x0
	adrp	x25, .LANCHOR171
	add	x28, x27, :lo12:.LANCHOR31
	add	x25, x25, :lo12:.LANCHOR171
.L2089:
	cbnz	w21, .L2099
.L2112:
	adrp	x19, .LANCHOR52
	add	x19, x19, :lo12:.LANCHOR52
.L2100:
	cbnz	w22, .L2102
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L2099:
	ldrb	w24, [x19]
	ldr	w26, [x19, 40]
.L2090:
	mov	w1, 0
	mov	w0, w26
	bl	queue_lun_state
	cbnz	w0, .L2091
	cmp	w21, 1
	beq	.L2096
	ldrb	w0, [x25]
	cbnz	w0, .L2093
.L2096:
	mov	x0, x19
	bl	queue_read_cmd
	b	.L2094
.L2091:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2090
.L2093:
	ldrb	w1, [x27, #:lo12:.LANCHOR31]
	mov	w20, 24
	mov	w0, 1
	sub	w20, w20, w1
	lsl	w0, w0, w1
	sub	w0, w0, #1
	lsr	w20, w26, w20
	and	w20, w20, w0
	ldrb	w0, [x19]
	and	w20, w20, 65535
	cmp	w0, 255
	bne	.L2095
	adrp	x1, .LANCHOR172
	adrp	x0, .LC0
	mov	w2, 661
	add	x1, x1, :lo12:.LANCHOR172
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2095:
	ldrb	w4, [x19]
	adrp	x2, .LANCHOR52
	add	x2, x2, :lo12:.LANCHOR52
	ldrb	w7, [x28]
	mov	w0, 24
	mov	w3, 1
	sbfiz	x5, x4, 6, 32
	sub	w0, w0, w7
	add	x6, x2, x5
	lsl	w3, w3, w7
	sub	w3, w3, #1
	ldr	w1, [x6, 40]
	lsr	w0, w1, w0
	and	w0, w0, w3
	cmp	w20, w0, uxth
	bne	.L2096
	adrp	x0, .LANCHOR105
	ldrh	w0, [x0, #:lo12:.LANCHOR105]
	add	w26, w0, w26
	cmp	w1, w26
	bne	.L2096
	ldr	w0, [x19, 40]
	mov	w26, -1
	ldrb	w24, [x2, x5]
	adrp	x20, .LANCHOR56
	stp	x6, x5, [x29, 96]
	add	x20, x20, :lo12:.LANCHOR56
	str	x2, [x29, 112]
	sub	w21, w21, #1
	str	w4, [x29, 120]
	bl	flash_start_plane_read
	mov	w3, 2
	strb	wzr, [x19, 59]
	strb	w3, [x19, 58]
	mov	x1, x19
	strb	w26, [x19]
	mov	x0, x20
	str	w3, [x29, 124]
	bl	buf_add_tail
	ldp	x6, x5, [x29, 96]
	strb	wzr, [x6, 59]
	ldr	x2, [x29, 112]
	mov	x0, x20
	ldp	w4, w3, [x29, 120]
	strb	w3, [x6, 58]
	strb	w26, [x2, x5]
	ubfiz	x1, x4, 6, 8
	add	x1, x2, x1
	bl	buf_add_tail
.L2094:
	subs	w21, w21, #1
	beq	.L2112
	ubfiz	x24, x24, 6, 8
	adrp	x19, .LANCHOR52
	add	x19, x19, :lo12:.LANCHOR52
	add	x19, x19, x24
	b	.L2089
.L2102:
	ldrb	w0, [x23, 58]
	cmp	w0, 13
	bne	.L2101
	ldrb	w0, [x23]
	sub	w22, w22, #1
	cmp	w0, 255
	beq	.L2101
	ubfiz	x23, x0, 6, 8
	add	x23, x19, x23
.L2101:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2100
	.size	sblk_read_page, .-sblk_read_page
	.section	.text.flash_prog_page,"ax",@progbits
	.align	2
	.global	flash_prog_page
	.type	flash_prog_page, %function
flash_prog_page:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	and	w21, w0, 255
	adrp	x0, .LANCHOR13
	stp	x25, x26, [sp, 64]
	stp	x19, x20, [sp, 16]
	mov	w20, 24
	ldr	x26, [x0, #:lo12:.LANCHOR13]
	adrp	x0, .LANCHOR31
	stp	x23, x24, [sp, 48]
	mov	w22, w1
	ldrb	w0, [x0, #:lo12:.LANCHOR31]
	and	x19, x21, 255
	str	x27, [sp, 80]
	add	x23, x19, 8
	sub	w0, w20, w0
	mov	w20, 1
	mov	x24, x2
	mov	x25, x3
	lsl	w20, w20, w0
	adrp	x0, .LANCHOR14
	sub	w20, w20, #1
	add	x23, x26, x23, lsl 8
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	and	w20, w20, w1
	ubfx	x27, x22, 24, 2
	tbz	x0, 4, .L2115
	adrp	x0, .LC130
	mov	w3, w4
	mov	w2, w27
	add	x0, x0, :lo12:.LC130
	bl	printf
.L2115:
	bl	nandc_wait_flash_ready
	mov	w0, w21
	bl	hynix_reconfig_rr_para
	mov	w0, w21
	bl	nandc_cs
	mov	w0, w21
	cbnz	w27, .L2116
	bl	zftl_flash_enter_slc_mode
.L2117:
	add	x19, x26, x19, lsl 8
	mov	w0, 128
	str	w0, [x19, 2056]
	and	w0, w20, 255
	str	wzr, [x19, 2052]
	str	wzr, [x19, 2052]
	str	w0, [x19, 2052]
	lsr	w0, w20, 8
	str	w0, [x19, 2052]
	lsr	w0, w20, 16
	str	w0, [x19, 2052]
	mov	w0, w20
	bl	nandc_set_seed
	adrp	x0, .LANCHOR32+9
	mov	x3, x25
	mov	x2, x24
	ldrb	w1, [x0, #:lo12:.LANCHOR32+9]
	mov	w0, 1
	bl	nandc_xfer_start
	bl	nandc_xfer_done
	mov	x0, 200
	bl	udelay
	mov	w0, 16
	str	w0, [x19, 2056]
	bl	nandc_wait_flash_ready
	mov	x0, x23
	bl	flash_read_status
	mov	w2, w0
	bl	nandc_de_cs.constprop.30
	and	w19, w2, 4
	tbz	x2, 2, .L2114
	adrp	x0, .LC131
	mov	w2, w19
	mov	w1, w22
	add	x0, x0, :lo12:.LC131
	bl	printf
.L2114:
	mov	w0, w19
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L2116:
	bl	zftl_flash_exit_slc_mode
	b	.L2117
	.size	flash_prog_page, .-flash_prog_page
	.section	.text.flash_test_blk,"ax",@progbits
	.align	2
	.global	flash_test_blk
	.type	flash_test_blk, %function
flash_test_blk:
	stp	x29, x30, [sp, -64]!
	mov	w2, 32
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR159
	stp	x19, x20, [sp, 16]
	and	w20, w0, 255
	ldr	x0, [x22, #:lo12:.LANCHOR159]
	adrp	x21, .LANCHOR161
	and	w19, w1, 65535
	str	x23, [sp, 48]
	mov	w1, 165
	bl	ftl_memset
	ldr	x0, [x21, #:lo12:.LANCHOR161]
	mov	w2, 8
	mov	w1, 90
	bl	ftl_memset
	adrp	x0, .LANCHOR2
	ldrh	w0, [x0, #:lo12:.LANCHOR2]
	mul	w19, w0, w19
	mov	w0, w20
	mov	w1, w19
	bl	flash_erase_block
	cmn	w0, #1
	bne	.L2127
.L2129:
	mov	w21, -1
.L2128:
	mov	w1, w19
	mov	w0, w20
	bl	flash_erase_block
	ldr	x23, [sp, 48]
	mov	w0, w21
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L2127:
	adrp	x23, .LANCHOR32
	add	x23, x23, :lo12:.LANCHOR32
	ldr	x3, [x21, #:lo12:.LANCHOR161]
	mov	w1, w19
	ldr	x2, [x22, #:lo12:.LANCHOR159]
	mov	w0, w20
	ldrb	w4, [x23, 9]
	bl	flash_prog_page
	cmn	w0, #1
	beq	.L2129
	ldrb	w4, [x23, 9]
	mov	w1, w19
	ldr	x3, [x21, #:lo12:.LANCHOR161]
	mov	w0, w20
	ldr	x2, [x22, #:lo12:.LANCHOR159]
	bl	flash_read_page
	cmn	w0, #1
	beq	.L2129
	ldr	x0, [x22, #:lo12:.LANCHOR159]
	ldr	w1, [x0]
	mov	w0, 42405
	movk	w0, 0xa5a5, lsl 16
	cmp	w1, w0
	bne	.L2129
	ldr	x0, [x21, #:lo12:.LANCHOR161]
	ldr	w1, [x0]
	mov	w0, 23130
	movk	w0, 0x5a5a, lsl 16
	cmp	w1, w0
	csetm	w21, ne
	b	.L2128
	.size	flash_test_blk, .-flash_test_blk
	.section	.text.id_block_prog_msb_ff_data,"ax",@progbits
	.align	2
	.global	id_block_prog_msb_ff_data
	.type	id_block_prog_msb_ff_data, %function
id_block_prog_msb_ff_data:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	and	w22, w0, 255
	adrp	x0, .LANCHOR19
	stp	x19, x20, [sp, 16]
	stp	x23, x24, [sp, 48]
	ldrb	w0, [x0, #:lo12:.LANCHOR19]
	str	x25, [sp, 64]
	cbnz	w0, .L2137
	adrp	x20, .LANCHOR32
	add	x20, x20, :lo12:.LANCHOR32
	ldrb	w0, [x20, 19]
	sub	w0, w0, #5
	and	w3, w0, 255
	cmp	w3, 63
	bhi	.L2137
	and	w19, w2, 65535
	mov	x2, 16391
	movk	x2, 0x4000, lsl 16
	movk	x2, 0x8000, lsl 48
	lsr	x0, x2, x3
	tbz	x0, 0, .L2137
	adrp	x21, .LANCHOR140
	mov	w23, w1
	add	x21, x21, :lo12:.LANCHOR140
	mov	w25, 65535
	adrp	x24, .LANCHOR159
.L2139:
	ldrh	w0, [x20, 10]
	cmp	w0, w19
	bhi	.L2140
.L2137:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L2140:
	ldrh	w0, [x21, w19, sxtw 1]
	cmp	w0, w25
	bne	.L2137
	ldr	x0, [x24, #:lo12:.LANCHOR159]
	mov	w2, 16384
	mov	w1, 255
	bl	ftl_memset
	ldr	x3, [x24, #:lo12:.LANCHOR159]
	add	w1, w19, w23
	ldrb	w4, [x20, 9]
	add	w19, w19, 1
	mov	x2, x3
	mov	w0, w22
	and	w19, w19, 65535
	bl	flash_prog_page
	b	.L2139
	.size	id_block_prog_msb_ff_data, .-id_block_prog_msb_ff_data
	.section	.text.flash_dual_page_prog,"ax",@progbits
	.align	2
	.global	flash_dual_page_prog
	.type	flash_dual_page_prog, %function
flash_dual_page_prog:
	stp	x29, x30, [sp, -112]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	and	w21, w0, 255
	adrp	x0, .LANCHOR13
	stp	x23, x24, [sp, 48]
	stp	x19, x20, [sp, 16]
	and	x19, x21, 255
	ldr	x23, [x0, #:lo12:.LANCHOR13]
	add	x0, x19, 8
	mov	w20, 24
	stp	x27, x28, [sp, 80]
	mov	x27, x2
	stp	x25, x26, [sp, 64]
	add	x0, x23, x0, lsl 8
	str	x0, [x29, 104]
	adrp	x0, .LANCHOR31
	mov	w22, w1
	mov	x28, x3
	mov	x25, x4
	ldrb	w0, [x0, #:lo12:.LANCHOR31]
	mov	x26, x5
	ubfx	x24, x22, 24, 2
	sub	w0, w20, w0
	mov	w20, 1
	lsl	w20, w20, w0
	adrp	x0, .LANCHOR14
	str	x0, [x29, 96]
	sub	w20, w20, #1
	ldr	w2, [x0, #:lo12:.LANCHOR14]
	and	w20, w20, w1
	tbz	x2, 4, .L2143
	adrp	x0, .LC130
	mov	w3, w6
	mov	w2, w24
	add	x0, x0, :lo12:.LC130
	bl	printf
.L2143:
	bl	nandc_wait_flash_ready
	mov	w0, w21
	bl	nandc_cs
	mov	w0, w21
	cbnz	w24, .L2144
	bl	zftl_flash_enter_slc_mode
.L2145:
	add	x19, x23, x19, lsl 8
	mov	w24, 128
	and	w0, w20, 255
	adrp	x21, .LANCHOR32
	add	x21, x21, :lo12:.LANCHOR32
	mov	w23, 16
	str	w24, [x19, 2056]
	str	wzr, [x19, 2052]
	str	wzr, [x19, 2052]
	str	w0, [x19, 2052]
	lsr	w0, w20, 8
	str	w0, [x19, 2052]
	lsr	w0, w20, 16
	str	w0, [x19, 2052]
	mov	w0, w20
	bl	nandc_set_seed
	ldrb	w1, [x21, 9]
	mov	x3, x28
	mov	x2, x27
	mov	w0, 1
	bl	nandc_xfer_start
	bl	nandc_xfer_done
	str	w23, [x19, 2056]
	bl	nandc_wait_flash_ready
	str	w24, [x19, 2056]
	str	wzr, [x19, 2052]
	add	w0, w20, 1
	str	wzr, [x19, 2052]
	and	w1, w0, 255
	str	w1, [x19, 2052]
	lsr	w1, w0, 8
	str	w1, [x19, 2052]
	lsr	w1, w0, 16
	str	w1, [x19, 2052]
	bl	nandc_set_seed
	ldrb	w1, [x21, 9]
	mov	x3, x26
	mov	x2, x25
	mov	w0, 1
	bl	nandc_xfer_start
	bl	nandc_xfer_done
	str	w23, [x19, 2056]
	bl	nandc_wait_flash_ready
	ldr	x0, [x29, 104]
	bl	flash_read_status
	mov	w2, w0
	bl	nandc_de_cs.constprop.30
	and	w19, w2, 4
	tbz	x2, 2, .L2142
	ldr	x0, [x29, 96]
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2142
	adrp	x0, .LC131
	mov	w2, w19
	mov	w1, w22
	add	x0, x0, :lo12:.LC131
	bl	printf
.L2142:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L2144:
	bl	zftl_flash_exit_slc_mode
	b	.L2145
	.size	flash_dual_page_prog, .-flash_dual_page_prog
	.section	.text.fw_flash_page_prog.constprop.27,"ax",@progbits
	.align	2
	.type	fw_flash_page_prog.constprop.27, %function
fw_flash_page_prog.constprop.27:
	stp	x29, x30, [sp, -64]!
	adrp	x4, .LANCHOR32
	add	x4, x4, :lo12:.LANCHOR32
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x20, x1
	stp	x21, x22, [sp, 32]
	mov	x21, x2
	str	x23, [sp, 48]
	ldrb	w19, [x4, 9]
	udiv	w19, w0, w19
	adrp	x0, .LANCHOR46
	ldrb	w23, [x0, #:lo12:.LANCHOR46]
	adrp	x0, .LANCHOR17
	ldrb	w0, [x0, #:lo12:.LANCHOR17]
	bl	nandc_bch_sel
	ldrb	w0, [x4, 7]
	cmp	w0, 9
	bne	.L2158
	adrp	x22, .LANCHOR159
	mov	w2, 16384
	mov	w1, 255
	ldr	x0, [x22, #:lo12:.LANCHOR159]
	bl	ftl_memset
	ldr	x5, [x22, #:lo12:.LANCHOR159]
	mov	w6, 4
	mov	x3, x21
	mov	x2, x20
	mov	x4, x5
	mov	w1, w19
	mov	w0, 0
	bl	flash_dual_page_prog
.L2161:
	mov	w4, w0
	mov	w0, w23
	bl	nandc_bch_sel
	ldr	x23, [sp, 48]
	mov	w0, w4
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L2158:
	mov	w4, 4
	mov	x3, x21
	mov	x2, x20
	mov	w1, w19
	mov	w0, 0
	bl	flash_prog_page
	b	.L2161
	.size	fw_flash_page_prog.constprop.27, .-fw_flash_page_prog.constprop.27
	.section	.text.idb_write_data,"ax",@progbits
	.align	2
	.global	idb_write_data
	.type	idb_write_data, %function
idb_write_data:
	stp	x29, x30, [sp, -272]!
	add	w0, w1, w3
	cmp	w0, 63
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w19, w1
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR137
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	ldr	x21, [x23, #:lo12:.LANCHOR137]
	bls	.L2163
	cmp	w1, 575
	bhi	.L2164
	mov	x22, x2
	mov	w20, w3
	cbnz	x21, .L2165
	mov	w0, 262144
	bl	ftl_malloc
	str	x0, [x23, #:lo12:.LANCHOR137]
	cbnz	x0, .L2166
.L2171:
	mov	w0, -1
.L2162:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 272
	ret
.L2166:
	mov	w2, 262144
	mov	w1, 0
	bl	ftl_memset
.L2165:
	adrp	x21, .LANCHOR139
	ldr	x0, [x21, #:lo12:.LANCHOR139]
	cbz	x0, .L2168
.L2172:
	adrp	x1, .LANCHOR138
	mov	w2, 1
	ldr	x0, [x23, #:lo12:.LANCHOR137]
	cmp	w19, 64
	str	w2, [x1, #:lo12:.LANCHOR138]
	bhi	.L2274
	mov	w1, 64
	sub	w19, w1, w19
	sub	w2, w20, w19
	ubfiz	x19, x19, 9, 25
	lsl	w2, w2, 9
	add	x1, x22, x19
.L2281:
	bl	ftl_memcpy
.L2280:
	mov	w0, 0
	b	.L2162
.L2168:
	mov	w0, 262144
	bl	ftl_malloc
	str	x0, [x21, #:lo12:.LANCHOR139]
	cbnz	x0, .L2172
	b	.L2171
.L2274:
	mov	w2, 576
	sub	w2, w2, w19
	cmp	w20, w2
	sub	w19, w19, #64
	csel	w2, w20, w2, ls
	ubfiz	x19, x19, 9, 25
	lsl	w2, w2, 9
	mov	x1, x22
	add	x0, x0, x19
	b	.L2281
.L2163:
	cmp	w1, 575
	bls	.L2280
.L2164:
	adrp	x0, .LANCHOR138
	ldr	w0, [x0, #:lo12:.LANCHOR138]
	cbz	w0, .L2280
	adrp	x2, .LANCHOR32
	add	x0, x2, :lo12:.LANCHOR32
	str	x2, [x29, 144]
	ldrb	w22, [x0, 9]
	ldrh	w19, [x0, 26]
	adrp	x0, .LANCHOR0
	mov	x7, x0
	ldrb	w1, [x0, #:lo12:.LANCHOR0]
	str	w1, [x29, 180]
	adrp	x1, .LANCHOR19
	mov	x8, x1
	ldr	w0, [x29, 180]
	ldrb	w3, [x1, #:lo12:.LANCHOR19]
	str	w3, [x29, 192]
	cbz	w0, .L2174
	ldrh	w0, [x29, 180]
	str	w0, [x29, 168]
	uxtw	x0, w3
	cmp	w0, 0
	cset	w0, eq
.L2277:
	str	w0, [x29, 188]
	mov	w0, 0
	bl	zftl_flash_exit_slc_mode
	ldrb	w0, [x8, #:lo12:.LANCHOR19]
	strb	w0, [x7, #:lo12:.LANCHOR0]
	mov	w0, 35899
	ldr	w1, [x21]
	movk	w0, 0xfcdc, lsl 16
	cmp	w1, w0
	bne	.L2177
	ldr	x0, [x29, 144]
	add	x1, x21, 258048
	add	x1, x1, 2044
	mov	w2, 65023
	add	x0, x0, :lo12:.LANCHOR32
	mov	w3, 4097
	ldrh	w20, [x0, 10]
	ldrb	w0, [x0, 12]
	lsl	w20, w20, 2
	sdiv	w20, w20, w0
	mov	w0, 512
	cmp	w20, 512
	csel	w20, w20, w0, lt
	mov	w0, 0
.L2181:
	ldr	w4, [x1]
	cbnz	w4, .L2179
	ldr	w4, [x21, w0, uxtw 2]
	add	w0, w0, 1
	str	w4, [x1, 2048]
	cmp	w0, w3
	sub	w2, w2, #1
	csel	w0, w0, wzr, cc
	sub	x1, x1, #4
	cmp	w2, 4096
	bne	.L2181
.L2179:
	ldr	w1, [x21, w2, uxtw 2]
	mul	w19, w19, w22
	mov	w3, w20
	adrp	x0, .LC132
	add	x0, x0, :lo12:.LC132
	bl	printf
	str	wzr, [x29, 184]
	and	w0, w19, 65535
	str	wzr, [x29, 196]
	str	w0, [x29, 132]
	adrp	x0, .LANCHOR48
	add	x0, x0, :lo12:.LANCHOR48
	str	x0, [x29, 200]
.L2219:
	adrp	x23, .LANCHOR139
	mov	w1, 0
	mov	w2, 512
	ldr	x0, [x23, #:lo12:.LANCHOR139]
	bl	ftl_memset
	adrp	x0, .LANCHOR27
	ldr	w1, [x29, 196]
	ldr	x0, [x0, #:lo12:.LANCHOR27]
	add	x0, x0, x1, uxtw
	ldrb	w19, [x0, 32]
	cmp	w19, 255
	beq	.L2182
	ldr	w0, [x29, 132]
	mul	w19, w19, w0
	ldr	w0, [x29, 188]
	cbz	w0, .L2183
	and	w0, w1, -3
	adrp	x8, .LANCHOR0
	cmp	w0, 1
	adrp	x7, .LANCHOR19
	bne	.L2184
	ldrb	w0, [x29, 168]
	strb	w0, [x8, #:lo12:.LANCHOR0]
	strb	w0, [x7, #:lo12:.LANCHOR19]
.L2183:
	ldr	x0, [x29, 144]
	add	x27, x0, :lo12:.LANCHOR32
	ldr	x0, [x29, 200]
	ldrb	w24, [x27, 9]
	ldrh	w25, [x27, 26]
	ldrb	w0, [x0]
	str	w0, [x29, 128]
	udiv	w1, w19, w24
	ldr	x0, [x29, 200]
	mul	w25, w24, w25
	and	w22, w25, 65535
	strb	wzr, [x0]
	mov	w0, 0
	bl	flash_erase_block
	udiv	w25, w19, w22
	ldrb	w1, [x27, 12]
	msub	w0, w25, w22, w19
	str	w0, [x29, 176]
	sub	w26, w19, w0
	ldrh	w0, [x27, 10]
	cmp	w19, w26
	lsl	w0, w0, 2
	sdiv	w0, w0, w1
	str	w0, [x29, 172]
	bne	.L2227
	adrp	x0, .LANCHOR28
	ldrb	w0, [x0, #:lo12:.LANCHOR28]
	cmp	w0, 9
	bne	.L2227
	ldr	x28, [x23, #:lo12:.LANCHOR139]
	mov	w2, 1024
	mov	w1, 0
	mov	x0, x28
	bl	ftl_memset
	mov	w0, 18766
	movk	w0, 0x464e, lsl 16
	str	w0, [x28]
	mov	w0, 12
	str	w0, [x28, 4]
	adrp	x0, .LANCHOR19
	strb	wzr, [x28, 16]
	str	wzr, [x28, 12]
	ldrb	w0, [x0, #:lo12:.LANCHOR19]
	cbz	w0, .L2186
	ldrb	w0, [x27, 29]
	strb	w0, [x28, 16]
.L2186:
	mov	w0, 4
	strb	w0, [x28, 17]
	adrp	x0, .LANCHOR32
	add	x0, x0, :lo12:.LANCHOR32
	cmp	w24, 8
	strb	wzr, [x28, 20]
	strh	wzr, [x28, 22]
	sub	w22, w20, #4
	ldrh	w1, [x0, 10]
	ldrb	w0, [x0, 12]
	sdiv	w0, w1, w0
	mov	w1, 16
	strh	w0, [x28, 18]
	mov	w0, 70
	csel	w0, w0, w1, hi
	strb	w0, [x28, 21]
	mov	w1, 12
	add	x0, x28, 12
	bl	js_hash
	str	w0, [x28, 8]
.L2185:
	adrp	x0, .LANCHOR19
	mov	x25, x21
	add	x0, x0, :lo12:.LANCHOR19
	mov	w27, 0
	str	x0, [x29, 160]
	adrp	x0, .LANCHOR3
	add	x0, x0, :lo12:.LANCHOR3
	str	x0, [x29, 152]
.L2188:
	ldr	w0, [x29, 172]
	cmp	w0, w27
	bhi	.L2199
	ldr	x0, [x29, 144]
	mov	w25, 4
	ldr	x24, [x23, #:lo12:.LANCHOR139]
	mov	w26, 0
	add	x0, x0, :lo12:.LANCHOR32
	str	w22, [x29, 152]
	str	wzr, [x29, 160]
	ldrb	w1, [x0, 9]
	ldrh	w0, [x0, 26]
	str	w1, [x29, 140]
	mul	w0, w1, w0
	adrp	x1, .LANCHOR48
	and	w0, w0, 65535
	strb	wzr, [x1, #:lo12:.LANCHOR48]
	udiv	w1, w19, w0
	msub	w0, w1, w0, w19
	str	w0, [x29, 176]
	sub	w0, w19, w0
	str	w0, [x29, 136]
	ldr	w0, [x29, 176]
	and	w0, w0, 3
	str	w0, [x29, 172]
	adrp	x0, .LANCHOR3
	add	x0, x0, :lo12:.LANCHOR3
	str	x0, [x29, 104]
.L2200:
	ldr	w0, [x29, 152]
	cmp	w26, w0
	bcc	.L2214
	ldr	x0, [x29, 200]
	ldrb	w1, [x29, 128]
	strb	w1, [x0]
	ldr	w0, [x29, 188]
	cbz	w0, .L2215
	mov	w0, 0
	bl	zftl_flash_exit_slc_mode
	adrp	x0, .LANCHOR0
	strb	wzr, [x0, #:lo12:.LANCHOR0]
	adrp	x0, .LANCHOR19
	strb	wzr, [x0, #:lo12:.LANCHOR19]
.L2215:
	adrp	x0, .LANCHOR139
	lsl	w22, w22, 7
	mov	x1, 0
	ldr	x0, [x0, #:lo12:.LANCHOR139]
.L2216:
	mov	w23, w1
	cmp	w1, w22
	bcc	.L2217
	ldr	w0, [x29, 184]
	add	w0, w0, 1
	str	w0, [x29, 184]
	cmp	w0, 5
	bls	.L2182
	b	.L2223
.L2174:
	ldr	w0, [x29, 192]
	cmp	w0, 3
	mov	w0, 3
	csel	w0, wzr, w0, ne
	str	w0, [x29, 168]
	ldr	w0, [x29, 192]
	cmp	w0, 3
	mov	w0, 2
	csel	w0, wzr, w0, ne
	b	.L2277
.L2184:
	mov	w0, 0
	bl	zftl_flash_exit_slc_mode
	strb	wzr, [x8, #:lo12:.LANCHOR0]
	strb	wzr, [x7, #:lo12:.LANCHOR19]
	b	.L2183
.L2227:
	mov	w22, w20
	mov	x28, 0
	b	.L2185
.L2199:
	ldr	x2, [x29, 160]
	ldr	w0, [x29, 176]
	add	w4, w0, w27
	adrp	x0, .LANCHOR3
	lsr	w4, w4, 2
	ldrb	w2, [x2]
	add	w1, w4, 1
	add	x0, x0, :lo12:.LANCHOR3
	ldrh	w0, [x0, w1, sxtw 1]
	cbz	w2, .L2190
	adrp	x0, .LANCHOR1
	ldrb	w7, [x0, #:lo12:.LANCHOR1]
	lsl	w0, w1, 1
	cmp	w7, 0
	csel	w0, w0, w1, ne
.L2190:
	adrp	x1, .LANCHOR28
	ldrb	w1, [x1, #:lo12:.LANCHOR28]
	cmp	w1, 9
	bne	.L2192
.L2278:
	str	w0, [x29, 208]
	mov	w0, 61424
	str	w0, [x29, 212]
	ldr	x0, [x29, 152]
	ldrh	w0, [x0, w4, sxtw 1]
	cbnz	w2, .L2194
	mov	w4, w0
.L2195:
	mul	w0, w24, w4
	cbnz	x28, .L2196
	str	w4, [x29, 140]
	add	x2, x29, 208
	mov	x1, x25
	add	w0, w0, w26
	bl	fw_flash_page_prog.constprop.27
	adrp	x0, .LANCHOR19
	ldr	w4, [x29, 140]
	ldrb	w0, [x0, #:lo12:.LANCHOR19]
	cbnz	w0, .L2197
	udiv	w1, w26, w24
	add	w2, w4, 1
	bl	id_block_prog_msb_ff_data
.L2197:
	add	w0, w22, 16
	add	x25, x25, 2048
	cmp	w27, w0
	bcc	.L2198
	add	w1, w22, 20
	add	x0, x21, 2048
	cmp	w27, w1
	csel	x25, x0, x25, cc
.L2198:
	add	w5, w27, 4
	mov	x28, 0
	and	w27, w5, 65535
	b	.L2188
.L2192:
	sub	w0, w0, #1
	lsl	w0, w0, 2
	b	.L2278
.L2194:
	adrp	x0, .LANCHOR1
	ldrb	w1, [x0, #:lo12:.LANCHOR1]
	lsl	w0, w4, 1
	cmp	w1, 0
	csel	w4, w0, w4, ne
	b	.L2195
.L2196:
	add	x2, x29, 208
	mov	x1, x28
	add	w0, w0, w26
	bl	fw_flash_page_prog.constprop.27
	b	.L2198
.L2214:
	ldr	w0, [x29, 172]
	adrp	x1, .LANCHOR19
	sub	w28, w25, w0
	ldr	w0, [x29, 176]
	ldrb	w1, [x1, #:lo12:.LANCHOR19]
	and	w28, w28, 65535
	add	w23, w0, w26
	ldr	x0, [x29, 104]
	udiv	w23, w23, w25
	and	w23, w23, 65535
	ldrh	w0, [x0, w23, sxtw 1]
	cbnz	w1, .L2201
	mov	w23, w0
.L2202:
	adrp	x0, .LANCHOR17
	ldr	w1, [x29, 136]
	ldrb	w27, [x0, #:lo12:.LANCHOR17]
	ldr	w0, [x29, 172]
	add	w0, w0, w1
	ldr	w1, [x29, 140]
	madd	w23, w1, w23, w0
	adrp	x0, .LANCHOR32+9
	ldrb	w0, [x0, #:lo12:.LANCHOR32+9]
	udiv	w23, w23, w0
	adrp	x0, .LANCHOR46
	ldrb	w0, [x0, #:lo12:.LANCHOR46]
	str	w0, [x29, 124]
	mov	w0, w27
	bl	nandc_bch_sel
	adrp	x0, .LANCHOR21
	add	x0, x0, :lo12:.LANCHOR21
	str	x0, [x29, 112]
.L2203:
	mov	w4, w25
	add	x3, x29, 208
	mov	x2, x24
	mov	w1, w23
	mov	w0, 0
	bl	flash_read_page
	mov	w5, w0
	cmn	w0, #1
	bne	.L2204
	ldr	x0, [x29, 200]
	ldrb	w6, [x0]
	cbnz	w6, .L2205
.L2208:
	adrp	x0, .LANCHOR165
	ldr	x6, [x0, #:lo12:.LANCHOR165]
	cbnz	x6, .L2206
.L2207:
	ldr	x0, [x29, 112]
	ldrb	w0, [x0]
	cbz	w0, .L2204
	mov	w4, w25
	add	x3, x29, 208
	mov	x2, x24
	mov	w1, w23
	mov	w0, 0
	bl	flash_ddr_tuning_read
	b	.L2279
.L2201:
	adrp	x0, .LANCHOR1
	ldrb	w1, [x0, #:lo12:.LANCHOR1]
	lsl	w0, w23, 1
	cmp	w1, 0
	csel	w23, w0, w23, ne
	b	.L2202
.L2205:
	ldr	x0, [x29, 200]
	mov	w1, w23
	str	w6, [x29, 100]
	mov	w4, w25
	str	w5, [x29, 120]
	add	x3, x29, 208
	mov	x2, x24
	strb	wzr, [x0]
	mov	w0, 0
	bl	flash_read_page
	cmn	w0, #1
	ldr	x1, [x29, 200]
	ldr	w6, [x29, 100]
	ldr	w5, [x29, 120]
	strb	w6, [x1]
	beq	.L2208
.L2279:
	mov	w5, w0
.L2204:
	cmn	w5, #1
	cset	w4, eq
	cmp	w27, 16
	cset	w0, ne
	tst	w4, w0
	beq	.L2210
	mov	w0, 16
	mov	w27, 16
	bl	nandc_bch_sel
	b	.L2203
.L2206:
	str	w5, [x29, 120]
	mov	w4, w25
	add	x3, x29, 208
	mov	x2, x24
	mov	w1, w23
	mov	w0, 0
	blr	x6
	cmn	w0, #1
	ldr	w5, [x29, 120]
	beq	.L2207
	b	.L2279
.L2210:
	ldr	w0, [x29, 124]
	bl	nandc_bch_sel
	cmp	w4, 0
	ldr	w0, [x29, 160]
	csinv	w0, w0, wzr, eq
	str	w0, [x29, 160]
	ldr	w0, [x29, 136]
	cmp	w26, 0
	ccmp	w19, w0, 0, eq
	bne	.L2212
	ldr	w0, [x29, 160]
	cbnz	w0, .L2212
	ldr	w1, [x24]
	mov	w0, 18766
	movk	w0, 0x464e, lsl 16
	cmp	w1, w0
	bne	.L2212
	ldr	w0, [x29, 152]
	ldrb	w25, [x24, 17]
	add	w0, w0, w28
	str	w0, [x29, 152]
.L2213:
	add	w26, w28, w26
	and	w26, w26, 65535
	b	.L2200
.L2212:
	ubfiz	x0, x28, 9, 16
	str	wzr, [x29, 172]
	add	x24, x24, x0
	b	.L2213
.L2217:
	ldr	w3, [x0, x1, lsl 2]
	add	x1, x1, 1
	add	x2, x21, x1, lsl 2
	ldr	w2, [x2, -4]
	cmp	w3, w2
	beq	.L2216
	mov	w2, 512
	mov	w1, 0
	bl	ftl_memset
	mov	w1, w23
	adrp	x0, .LC133
	add	x0, x0, :lo12:.LC133
	bl	printf
	mov	w1, w19
	mov	w0, 0
	bl	flash_erase_block
.L2182:
	ldr	w0, [x29, 196]
	add	w0, w0, 1
	str	w0, [x29, 196]
	cmp	w0, 4
	bne	.L2219
.L2223:
	mov	w0, 0
	bl	zftl_flash_exit_slc_mode
	adrp	x0, .LANCHOR0
	ldrb	w1, [x29, 180]
	strb	w1, [x0, #:lo12:.LANCHOR0]
	ldr	w0, [x29, 188]
	cbz	w0, .L2220
	adrp	x0, .LANCHOR19
	ldrb	w1, [x29, 192]
	strb	w1, [x0, #:lo12:.LANCHOR19]
.L2220:
	mov	w1, 2
	adrp	x0, .LANCHOR33
	strb	w1, [x0, #:lo12:.LANCHOR33]
	mov	w0, 0
	bl	zftl_flash_enter_slc_mode
	ldr	w0, [x29, 184]
	cbnz	w0, .L2177
	adrp	x0, .LC134
	mov	w1, 0
	add	x0, x0, :lo12:.LC134
	bl	printf
.L2177:
	adrp	x0, .LANCHOR138
	adrp	x19, .LANCHOR137
	str	wzr, [x0, #:lo12:.LANCHOR138]
	ldr	x0, [x19, #:lo12:.LANCHOR137]
	cbz	x0, .L2222
	bl	free
	str	xzr, [x19, #:lo12:.LANCHOR137]
.L2222:
	adrp	x19, .LANCHOR139
	ldr	x0, [x19, #:lo12:.LANCHOR139]
	cbz	x0, .L2280
	bl	free
	str	xzr, [x19, #:lo12:.LANCHOR139]
	b	.L2280
	.size	idb_write_data, .-idb_write_data
	.section	.text.flash_start_tlc_page_prog,"ax",@progbits
	.align	2
	.global	flash_start_tlc_page_prog
	.type	flash_start_tlc_page_prog, %function
flash_start_tlc_page_prog:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x25, x26, [sp, 64]
	and	w25, w0, 255
	adrp	x0, .LANCHOR18
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	and	w21, w1, 255
	stp	x23, x24, [sp, 48]
	and	w26, w3, 255
	ldrb	w1, [x0, #:lo12:.LANCHOR18]
	and	w22, w2, 255
	mov	w20, w4
	mov	x23, x5
	mov	x24, x6
	cmp	w1, w26
	mov	x19, x0
	bhi	.L2283
	adrp	x1, .LANCHOR173
	adrp	x0, .LC0
	mov	w2, 740
	add	x1, x1, :lo12:.LANCHOR173
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2283:
	ldrb	w0, [x19, #:lo12:.LANCHOR18]
	cmp	w0, w26
	bls	.L2282
	adrp	x0, .LANCHOR30
	add	x0, x0, :lo12:.LANCHOR30
	ldrb	w4, [x0, w26, sxtw]
	adrp	x0, .LANCHOR13
	ldr	x19, [x0, #:lo12:.LANCHOR13]
	mov	w0, w4
	bl	nandc_cs
	cbz	w25, .L2285
	sxtw	x0, w4
	add	x0, x0, 8
	add	x0, x19, x0, lsl 8
	str	w25, [x0, 8]
.L2285:
	ubfiz	x4, x4, 8, 8
	mov	w0, 128
	add	x19, x19, x4
	str	w21, [x19, 2056]
	str	w0, [x19, 2056]
	and	w0, w20, 255
	str	wzr, [x19, 2052]
	str	wzr, [x19, 2052]
	str	w0, [x19, 2052]
	lsr	w0, w20, 8
	str	w0, [x19, 2052]
	lsr	w0, w20, 16
	add	w20, w20, w20, lsl 1
	str	w0, [x19, 2052]
	sub	w0, w20, #1
	add	w0, w0, w21
	bl	nandc_set_seed
	adrp	x0, .LANCHOR32+9
	mov	x3, x24
	mov	x2, x23
	ldrb	w1, [x0, #:lo12:.LANCHOR32+9]
	mov	w0, 1
	bl	nandc_xfer_start
	bl	nandc_xfer_done
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	str	w22, [x19, 2056]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 80
	b	nandc_de_cs.constprop.30
.L2282:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
	.size	flash_start_tlc_page_prog, .-flash_start_tlc_page_prog
	.section	.text.queue_tlc_prog_cmd,"ax",@progbits
	.align	2
	.type	queue_tlc_prog_cmd, %function
queue_tlc_prog_cmd:
	stp	x29, x30, [sp, -48]!
	mov	w2, 24
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	mov	x21, x0
	adrp	x0, .LANCHOR31
	mov	w22, 1
	stp	x19, x20, [sp, 16]
	ldr	x7, [x21]
	ldrb	w0, [x0, #:lo12:.LANCHOR31]
	sub	w2, w2, w0
	ldr	w1, [x7, 40]
	lsl	w19, w22, w0
	lsl	w20, w22, w2
	sub	w19, w19, #1
	sub	w20, w20, #1
	ldr	x5, [x7, 8]
	and	w20, w20, w1
	lsr	w1, w1, w2
	and	w19, w19, w1
	ldr	x6, [x7, 24]
	and	w19, w19, 255
	ldrb	w0, [x7, 60]
	mov	w4, w20
	mov	w3, w19
	mov	w1, w22
	mov	w2, 26
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldp	x7, x0, [x21]
	mov	w4, w20
	mov	w3, w19
	mov	w2, 26
	mov	w1, 2
	ldr	x5, [x0, 8]
	ldr	x6, [x0, 24]
	ldrb	w0, [x7, 60]
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	x0, [x21, 16]
	mov	w4, w20
	ldr	x7, [x21]
	mov	w3, w19
	mov	w2, 16
	mov	w1, 3
	ldr	x5, [x0, 8]
	ldr	x6, [x0, 24]
	ldrb	w0, [x7, 60]
	bl	flash_start_tlc_page_prog
	ldr	x1, [x21]
	mov	w0, 4
	strb	w22, [x1, 59]
	strb	w0, [x1, 58]
	mov	w0, -1
	strb	w0, [x1]
	adrp	x0, .LANCHOR56
	add	x0, x0, :lo12:.LANCHOR56
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	b	buf_add_tail
	.size	queue_tlc_prog_cmd, .-queue_tlc_prog_cmd
	.section	.text.sblk_tlc_prog_one_page,"ax",@progbits
	.align	2
	.global	sblk_tlc_prog_one_page
	.type	sblk_tlc_prog_one_page, %function
sblk_tlc_prog_one_page:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	ldr	x0, [x0]
	ldr	w20, [x0, 40]
.L2293:
	mov	w1, 1
	mov	w0, w20
	bl	queue_lun_state
	cbnz	w0, .L2294
	mov	x0, x19
	bl	queue_tlc_prog_cmd
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L2294:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2293
	.size	sblk_tlc_prog_one_page, .-sblk_tlc_prog_one_page
	.section	.text.sblk_xlc_prog_pages,"ax",@progbits
	.align	2
	.global	sblk_xlc_prog_pages
	.type	sblk_xlc_prog_pages, %function
sblk_xlc_prog_pages:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x20, x0
	ldr	x0, [x0]
	stp	x23, x24, [sp, 48]
	mov	x23, x1
	mov	w24, w2
	stp	x21, x22, [sp, 32]
	ldr	w19, [x0, 40]
	str	x25, [sp, 64]
.L2297:
	mov	w1, 1
	mov	w0, w19
	bl	queue_lun_state
	cbnz	w0, .L2298
	cmp	w24, 2
	bne	.L2299
	ldr	x7, [x20]
	adrp	x0, .LANCHOR31
	ldr	x3, [x23]
	mov	w2, 24
	ldrb	w0, [x0, #:lo12:.LANCHOR31]
	mov	w22, 1
	ldr	w1, [x7, 40]
	sub	w2, w2, w0
	lsl	w19, w22, w0
	sub	w19, w19, #1
	lsl	w21, w22, w2
	sub	w21, w21, #1
	and	w25, w1, w21
	ldr	w3, [x3, 40]
	lsr	w1, w1, w2
	and	w19, w19, w1
	and	w19, w19, 255
	ldr	x5, [x7, 8]
	ldr	x6, [x7, 24]
	and	w21, w21, w3
	ldrb	w0, [x7, 60]
	mov	w4, w25
	mov	w1, w22
	mov	w3, w19
	mov	w2, 17
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	x7, [x20]
	mov	w4, w21
	ldr	x0, [x23]
	mov	w3, w19
	mov	w1, w22
	mov	w2, 26
	ldr	x5, [x0, 8]
	ldr	x6, [x0, 24]
	ldrb	w0, [x7, 60]
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldp	x7, x0, [x20]
	mov	w4, w25
	mov	w3, w19
	mov	w1, w24
	mov	w2, 17
	ldr	x5, [x0, 8]
	ldr	x6, [x0, 24]
	ldrb	w0, [x7, 60]
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	x7, [x20]
	mov	w4, w21
	ldr	x0, [x23, 8]
	mov	w3, w19
	mov	w1, w24
	mov	w2, 26
	ldr	x5, [x0, 8]
	ldr	x6, [x0, 24]
	ldrb	w0, [x7, 60]
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	x7, [x20]
	mov	w4, w25
	ldr	x0, [x20, 16]
	mov	w3, w19
	mov	w2, 17
	mov	w1, 3
	ldr	x5, [x0, 8]
	ldr	x6, [x0, 24]
	ldrb	w0, [x7, 60]
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	x0, [x23, 16]
	mov	w1, 3
	ldr	x7, [x20]
	mov	w4, w21
	mov	w3, w19
	mov	w2, 16
	ldr	x5, [x0, 8]
	ldr	x6, [x0, 24]
	ldrb	w0, [x7, 60]
	bl	flash_start_tlc_page_prog
	ldr	x1, [x20]
	mov	w0, 5
	strb	w22, [x1, 59]
	strb	w0, [x1, 58]
	mov	w0, -1
	strb	w0, [x1]
	adrp	x0, .LANCHOR56
	add	x0, x0, :lo12:.LANCHOR56
	bl	buf_add_tail
.L2300:
	mov	w0, 0
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L2298:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2297
.L2299:
	mov	x0, x20
	bl	queue_tlc_prog_cmd
	b	.L2300
	.size	sblk_xlc_prog_pages, .-sblk_xlc_prog_pages
	.section	.text.sblk_3d_tlc_dump_prog,"ax",@progbits
	.align	2
	.global	sblk_3d_tlc_dump_prog
	.type	sblk_3d_tlc_dump_prog, %function
sblk_3d_tlc_dump_prog:
	stp	x29, x30, [sp, -48]!
	mov	w1, 24
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x20, x0
	adrp	x0, .LANCHOR31
	stp	x21, x22, [sp, 32]
	mov	w22, 1
	ldrb	w0, [x0, #:lo12:.LANCHOR31]
	ldr	w3, [x20, 40]
	sub	w1, w1, w0
	lsl	w19, w22, w0
	sub	w19, w19, #1
	lsl	w21, w22, w1
	sub	w21, w21, #1
	and	w21, w21, w3
	lsr	w1, w3, w1
	mov	w2, w3
	and	w19, w19, w1
	adrp	x0, .LC135
	mov	w1, w21
	add	x0, x0, :lo12:.LC135
	bl	printf
	and	w19, w19, 255
	ldr	x5, [x20, 8]
	ldr	x6, [x20, 24]
	mov	w4, w21
	mov	w3, w19
	mov	w1, w22
	mov	w2, 26
	mov	w0, 0
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	x5, [x20, 8]
	mov	w4, w21
	ldr	x6, [x20, 24]
	mov	w3, w19
	mov	w2, 26
	mov	w1, 2
	mov	w0, 0
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	x5, [x20, 8]
	mov	w4, w21
	ldr	x6, [x20, 24]
	mov	w3, w19
	mov	w2, 16
	mov	w1, 3
	mov	w0, 0
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	w0, [x20, 40]
	mov	w1, 64
	ldp	x21, x22, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	b	flash_wait_device_ready
	.size	sblk_3d_tlc_dump_prog, .-sblk_3d_tlc_dump_prog
	.section	.text.flash_start_3d_mlc_page_prog,"ax",@progbits
	.align	2
	.global	flash_start_3d_mlc_page_prog
	.type	flash_start_3d_mlc_page_prog, %function
flash_start_3d_mlc_page_prog:
	stp	x29, x30, [sp, -64]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	and	w21, w0, 255
	adrp	x0, .LANCHOR18
	stp	x19, x20, [sp, 16]
	stp	x23, x24, [sp, 48]
	and	w24, w1, 255
	ldrb	w1, [x0, #:lo12:.LANCHOR18]
	mov	w20, w2
	mov	x22, x3
	mov	x23, x4
	cmp	w1, w24
	mov	x19, x0
	bhi	.L2305
	adrp	x1, .LANCHOR174
	adrp	x0, .LC0
	mov	w2, 772
	add	x1, x1, :lo12:.LANCHOR174
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2305:
	ldrb	w0, [x19, #:lo12:.LANCHOR18]
	cmp	w0, w24
	bls	.L2304
	adrp	x0, .LANCHOR30
	add	x0, x0, :lo12:.LANCHOR30
	ldrb	w4, [x0, w24, sxtw]
	adrp	x0, .LANCHOR13
	ldr	x19, [x0, #:lo12:.LANCHOR13]
	mov	w0, w4
	bl	nandc_cs
	ubfiz	x4, x4, 8, 8
	add	x19, x19, x4
	mov	w0, 128
	str	w0, [x19, 2056]
	and	w0, w20, 255
	str	wzr, [x19, 2052]
	str	wzr, [x19, 2052]
	str	w0, [x19, 2052]
	lsr	w0, w20, 8
	str	w0, [x19, 2052]
	lsr	w0, w20, 16
	str	w0, [x19, 2052]
	mov	w0, w20
	bl	nandc_set_seed
	adrp	x0, .LANCHOR32+9
	mov	x3, x23
	mov	x2, x22
	ldrb	w1, [x0, #:lo12:.LANCHOR32+9]
	mov	w0, 1
	bl	nandc_xfer_start
	bl	nandc_xfer_done
	str	w21, [x19, 2056]
.L2304:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
	.size	flash_start_3d_mlc_page_prog, .-flash_start_3d_mlc_page_prog
	.section	.text.sblk_3d_mlc_prog_pages,"ax",@progbits
	.align	2
	.global	sblk_3d_mlc_prog_pages
	.type	sblk_3d_mlc_prog_pages, %function
sblk_3d_mlc_prog_pages:
	stp	x29, x30, [sp, -80]!
	ubfiz	x1, x1, 4, 32
	add	x1, x1, 8
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	add	x21, x0, x1
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR31
	adrp	x24, .LANCHOR56
	str	x25, [sp, 64]
	add	x23, x23, :lo12:.LANCHOR31
	add	x24, x24, :lo12:.LANCHOR56
	add	x25, x0, 8
	stp	x19, x20, [sp, 16]
	mov	w22, 1
.L2309:
	cmp	x21, x25
	bne	.L2312
	mov	w0, 0
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L2312:
	ldr	x0, [x25, -8]
	ldr	w19, [x0, 40]
.L2310:
	mov	w1, 1
	mov	w0, w19
	bl	queue_lun_state
	cbnz	w0, .L2311
	ldr	x0, [x25, -8]
	mov	w2, 24
	ldrb	w1, [x23]
	add	x25, x25, 16
	sub	w2, w2, w1
	ldr	w0, [x0, 40]
	lsl	w19, w22, w1
	lsl	w20, w22, w2
	sub	w19, w19, #1
	sub	w20, w20, #1
	and	w20, w20, w0
	lsr	w0, w0, w2
	and	w19, w19, w0
	and	w19, w19, 255
	mov	w0, w19
	bl	zftl_flash_exit_slc_mode
	ldr	x0, [x25, -24]
	mov	w2, w20
	mov	w1, w19
	ldr	x3, [x0, 8]
	ldr	x4, [x0, 24]
	mov	w0, 16
	bl	flash_start_3d_mlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	x0, [x25, -16]
	add	w2, w20, 1
	mov	w1, w19
	ldr	x3, [x0, 8]
	ldr	x4, [x0, 24]
	mov	w0, 16
	bl	flash_start_3d_mlc_page_prog
	bl	nandc_de_cs.constprop.30
	ldr	x1, [x25, -24]
	mov	w0, 4
	strb	w22, [x1, 59]
	strb	w0, [x1, 58]
	mov	w0, -1
	strb	w0, [x1]
	mov	x0, x24
	bl	buf_add_tail
	b	.L2309
.L2311:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2310
	.size	sblk_3d_mlc_prog_pages, .-sblk_3d_mlc_prog_pages
	.section	.text.sblk_mlc_dump_prog,"ax",@progbits
	.align	2
	.global	sblk_mlc_dump_prog
	.type	sblk_mlc_dump_prog, %function
sblk_mlc_dump_prog:
	stp	x29, x30, [sp, -48]!
	mov	w2, 24
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x20, x0
	adrp	x0, .LANCHOR31
	ldrb	w19, [x0, #:lo12:.LANCHOR31]
	mov	w0, 1
	ldr	w1, [x20, 40]
	sub	w2, w2, w19
	str	x21, [sp, 32]
	lsl	w19, w0, w19
	sub	w19, w19, #1
	lsl	w21, w0, w2
	sub	w21, w21, #1
	and	w21, w21, w1
	lsr	w1, w1, w2
	and	w19, w19, w1
	and	w19, w19, 255
	mov	w0, w19
	bl	zftl_flash_exit_slc_mode
	ldr	w2, [x20, 40]
	mov	w1, w21
	adrp	x0, .LC136
	add	x0, x0, :lo12:.LC136
	add	w3, w2, 1
	bl	printf
	ldr	x3, [x20, 8]
	mov	w2, w21
	ldr	x4, [x20, 24]
	mov	w1, w19
	mov	w0, 16
	bl	flash_start_3d_mlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	x3, [x20, 8]
	add	w2, w21, 1
	ldr	x4, [x20, 24]
	mov	w1, w19
	mov	w0, 16
	bl	flash_start_3d_mlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	w0, [x20, 40]
	mov	w1, 64
	bl	flash_wait_device_ready
	mov	w2, w0
	bl	nandc_de_cs.constprop.30
	ldr	x21, [sp, 32]
	mov	w0, w2
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
	.size	sblk_mlc_dump_prog, .-sblk_mlc_dump_prog
	.section	.text.flash_start_page_prog,"ax",@progbits
	.align	2
	.global	flash_start_page_prog
	.type	flash_start_page_prog, %function
flash_start_page_prog:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	and	w21, w0, 255
	adrp	x0, .LANCHOR31
	stp	x19, x20, [sp, 16]
	stp	x25, x26, [sp, 64]
	mov	w19, 24
	ldrb	w0, [x0, #:lo12:.LANCHOR31]
	mov	w20, 1
	str	x27, [sp, 80]
	adrp	x27, .LANCHOR18
	sub	w25, w19, w0
	stp	x23, x24, [sp, 48]
	lsl	w20, w20, w0
	sub	w20, w20, #1
	lsr	w0, w1, w25
	and	w20, w20, w0
	ldrb	w0, [x27, #:lo12:.LANCHOR18]
	and	w20, w20, 255
	mov	w24, w1
	mov	x22, x2
	mov	x23, x3
	cmp	w0, w20
	bhi	.L2317
	adrp	x1, .LANCHOR175
	adrp	x0, .LC0
	mov	w2, 821
	add	x1, x1, :lo12:.LANCHOR175
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2317:
	ldrb	w0, [x27, #:lo12:.LANCHOR18]
	cmp	w0, w20
	bls	.L2316
	adrp	x0, .LANCHOR30
	add	x0, x0, :lo12:.LANCHOR30
	mov	w19, 1
	lsl	w19, w19, w25
	sub	w19, w19, #1
	ldrb	w26, [x0, w20, sxtw]
	adrp	x0, .LANCHOR13
	and	w19, w19, w24
	ldr	x25, [x0, #:lo12:.LANCHOR13]
	bl	nandc_rdy_status
	cbnz	w0, .L2319
	ldrb	w0, [x27, #:lo12:.LANCHOR18]
	cmp	w0, 1
	bne	.L2320
	bl	nandc_wait_flash_ready
.L2319:
	mov	w0, w26
	bl	hynix_reconfig_rr_para
	mov	w0, w26
	bl	nandc_cs
	tst	x24, 50331648
	bne	.L2321
	mov	w0, w19
	bl	slc_phy_page_address_calc
	mov	w19, w0
	adrp	x0, .LANCHOR0
	ldrb	w0, [x0, #:lo12:.LANCHOR0]
	cbz	w0, .L2322
	mov	w0, w26
	bl	zftl_flash_enter_slc_mode
.L2322:
	ubfiz	x20, x26, 8, 8
	mov	w0, 128
	add	x20, x25, x20
	str	w0, [x20, 2056]
	and	w0, w19, 255
	str	wzr, [x20, 2052]
	str	wzr, [x20, 2052]
	str	w0, [x20, 2052]
	lsr	w0, w19, 8
	str	w0, [x20, 2052]
	lsr	w0, w19, 16
	str	w0, [x20, 2052]
	mov	w0, w19
	bl	nandc_set_seed
	adrp	x0, .LANCHOR32+9
	mov	x3, x23
	mov	x2, x22
	ldrb	w1, [x0, #:lo12:.LANCHOR32+9]
	mov	w0, 1
	bl	nandc_xfer_start
	bl	nandc_xfer_done
	mov	x0, 200
	bl	udelay
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	str	w21, [x20, 2056]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 96
	b	nandc_de_cs.constprop.30
.L2320:
	mov	w2, 64
	mov	w1, w19
	mov	w0, w20
	bl	flash_wait_device_ready_raw
	b	.L2319
.L2321:
	mov	w0, w26
	bl	zftl_flash_exit_slc_mode
	b	.L2322
.L2316:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
	.size	flash_start_page_prog, .-flash_start_page_prog
	.section	.text.queue_prog_cmd,"ax",@progbits
	.align	2
	.type	queue_prog_cmd, %function
queue_prog_cmd:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	ldr	w1, [x0, 40]
	ldr	x3, [x0, 24]
	ldr	x2, [x0, 8]
	str	x19, [sp, 16]
	mov	x19, x0
	mov	w0, 16
	bl	flash_start_page_prog
	adrp	x0, .LANCHOR56
	ldr	w3, [x19, 40]
	ldrb	w1, [x0, #:lo12:.LANCHOR56]
	cmp	w1, 255
	beq	.L2328
	adrp	x2, .LANCHOR31
	mov	w5, 24
	adrp	x6, .LANCHOR52
	add	x6, x6, :lo12:.LANCHOR52
	ldrb	w4, [x2, #:lo12:.LANCHOR31]
	mov	w2, 1
	mov	x8, x6
	sub	w5, w5, w4
	lsl	w2, w2, w4
	sub	w2, w2, #1
	and	w2, w2, 65535
	asr	w3, w3, w5
	and	w3, w3, w2
.L2330:
	add	x7, x6, x1, lsl 6
	ldr	w4, [x7, 40]
	lsr	w4, w4, w5
	and	w4, w2, w4
	cmp	w3, w4
	bne	.L2329
	ldrb	w4, [x7, 58]
	cmp	w4, 7
	bne	.L2329
	mov	w1, 3
	strb	w1, [x7, 58]
.L2328:
	mov	w1, 3
	strb	w1, [x19, 58]
	mov	w1, 1
	strb	w1, [x19, 59]
	mov	w1, -1
	strb	w1, [x19]
	mov	x1, x19
	add	x0, x0, :lo12:.LANCHOR56
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	b	buf_add_tail
.L2329:
	lsl	x1, x1, 6
	ldrb	w1, [x8, x1]
	cmp	w1, 255
	bne	.L2330
	b	.L2328
	.size	queue_prog_cmd, .-queue_prog_cmd
	.section	.text.sblk_prog_page,"ax",@progbits
	.align	2
	.global	sblk_prog_page
	.type	sblk_prog_page, %function
sblk_prog_page:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	ldrh	w0, [x0, 50]
	and	w20, w1, 255
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	cbz	w0, .L2337
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L2337
	ldr	w1, [x19, 40]
	adrp	x0, .LC137
	mov	w2, w20
	add	x0, x0, :lo12:.LC137
	bl	printf
.L2337:
	adrp	x23, .LANCHOR41
	adrp	x25, .LANCHOR31
	add	x23, x23, :lo12:.LANCHOR41
	add	x26, x25, :lo12:.LANCHOR31
	mov	w21, 0
.L2338:
	cbnz	w20, .L2349
.L2362:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L2349:
	ldrb	w24, [x19]
	ldr	w22, [x19, 40]
.L2339:
	mov	w1, 1
	mov	w0, w22
	bl	queue_lun_state
	cbnz	w0, .L2340
	cmp	w20, 1
	beq	.L2341
	ldrb	w0, [x23]
	cbnz	w0, .L2342
.L2341:
	mov	x0, x19
	bl	queue_prog_cmd
.L2343:
	subs	w20, w20, #1
	beq	.L2362
	ubfiz	x24, x24, 6, 8
	adrp	x19, .LANCHOR52
	add	x19, x19, :lo12:.LANCHOR52
	add	x19, x19, x24
	b	.L2338
.L2340:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2339
.L2342:
	ldrb	w1, [x25, #:lo12:.LANCHOR31]
	mov	w27, 24
	mov	w0, 1
	sub	w27, w27, w1
	lsl	w0, w0, w1
	sub	w0, w0, #1
	lsr	w27, w22, w27
	and	w27, w27, w0
	ldrb	w0, [x19]
	and	w27, w27, 65535
	cmp	w0, 255
	bne	.L2344
	adrp	x1, .LANCHOR176
	adrp	x0, .LC0
	mov	w2, 583
	add	x1, x1, :lo12:.LANCHOR176
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2344:
	ldrb	w0, [x19]
	adrp	x1, .LANCHOR52
	add	x1, x1, :lo12:.LANCHOR52
	mov	w3, 24
	mov	w28, 1
	add	x0, x1, x0, lsl 6
	ldr	w4, [x0, 40]
	ldrb	w0, [x26]
	sub	w3, w3, w0
	lsl	w0, w28, w0
	sub	w0, w0, #1
	lsr	w1, w4, w3
	and	w0, w0, w1
	cmp	w27, w0, uxth
	bne	.L2345
	adrp	x0, .LANCHOR68
	ldrh	w2, [x0, #:lo12:.LANCHOR68]
	adrp	x0, .LANCHOR69
	ldrb	w1, [x0, #:lo12:.LANCHOR69]
	sub	w0, w3, w2
	lsr	w5, w22, w2
	sub	w3, w1, #1
	lsl	w0, w28, w0
	sub	w0, w0, #1
	lsl	w1, w28, w2
	and	w0, w0, w3
	sub	w1, w1, #1
	and	w0, w0, 65535
	and	w1, w1, 65535
	and	w5, w0, w5
	lsr	w2, w4, w2
	and	w0, w0, w2
	and	w22, w1, w22
	cmp	w5, w0
	and	w1, w1, w4
	ccmp	w22, w1, 0, ne
	bne	.L2345
	cmp	w21, w3
	beq	.L2345
	ldr	w1, [x19, 40]
	mov	w0, 17
	ldr	x2, [x19, 8]
	add	w21, w21, w28
	ldr	x3, [x19, 24]
	bl	flash_start_page_prog
	strb	w28, [x19, 59]
	mov	w0, 9
	strb	w0, [x19, 58]
	mov	w0, -1
	strb	w0, [x19]
	mov	x1, x19
	adrp	x0, .LANCHOR56
	add	x0, x0, :lo12:.LANCHOR56
	bl	buf_add_tail
	b	.L2343
.L2345:
	mov	x0, x19
	mov	w21, 0
	bl	queue_prog_cmd
	b	.L2343
	.size	sblk_prog_page, .-sblk_prog_page
	.section	.text.ftl_flush,"ax",@progbits
	.align	2
	.global	ftl_flush
	.type	ftl_flush, %function
ftl_flush:
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR123
	add	x29, sp, 0
	ldrb	w1, [x0, #:lo12:.LANCHOR123]
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	adrp	x20, .LANCHOR177
	cbz	w1, .L2365
	ldrb	w2, [x20, #:lo12:.LANCHOR177]
	adrp	x0, .LANCHOR52
	add	x0, x0, :lo12:.LANCHOR52
	add	x0, x0, x2, lsl 6
	bl	sblk_prog_page
.L2365:
	mov	w0, -1
	strb	wzr, [x19, #:lo12:.LANCHOR123]
	strb	w0, [x20, #:lo12:.LANCHOR177]
	bl	sblk_wait_write_queue_completed
	bl	ftl_write_completed
	ldp	x19, x20, [sp, 16]
	mov	w0, -1
	ldp	x29, x30, [sp], 32
	b	ftl_vpn_decrement
	.size	ftl_flush, .-ftl_flush
	.section	.text.flash_prog_page_en,"ax",@progbits
	.align	2
	.global	flash_prog_page_en
	.type	flash_prog_page_en, %function
flash_prog_page_en:
	stp	x29, x30, [sp, -128]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	and	w21, w0, 255
	and	w0, w5, 255
	stp	x19, x20, [sp, 16]
	str	w0, [x29, 124]
	adrp	x0, .LANCHOR18
	stp	x23, x24, [sp, 48]
	mov	w20, w1
	stp	x27, x28, [sp, 80]
	mov	x23, x2
	ldrb	w1, [x0, #:lo12:.LANCHOR18]
	mov	x22, x3
	stp	x25, x26, [sp, 64]
	mov	w28, w4
	ubfx	x24, x20, 24, 2
	cmp	w1, w21
	mov	x19, x0
	bhi	.L2371
	adrp	x1, .LANCHOR178
	adrp	x0, .LC0
	mov	w2, 554
	add	x1, x1, :lo12:.LANCHOR178
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2371:
	ldrb	w0, [x19, #:lo12:.LANCHOR18]
	cmp	w0, w21
	bls	.L2382
	adrp	x0, .LANCHOR30
	add	x0, x0, :lo12:.LANCHOR30
	ldrb	w27, [x0, w21, sxtw]
	cbnz	w24, .L2384
	adrp	x0, .LANCHOR0
	ldrb	w1, [x0, #:lo12:.LANCHOR0]
	adrp	x0, .LANCHOR1
	cbz	w1, .L2374
	ldrb	w1, [x0, #:lo12:.LANCHOR1]
	cbz	w1, .L2384
.L2374:
	adrp	x1, .LANCHOR2
	ldrb	w0, [x0, #:lo12:.LANCHOR1]
	ldrh	w1, [x1, #:lo12:.LANCHOR2]
	udiv	w19, w20, w1
	mul	w19, w19, w1
	sub	w1, w20, w19
	cbz	w0, .L2375
	add	w19, w19, w1, lsl 1
.L2373:
	adrp	x24, .LANCHOR14
	adrp	x25, .LC138
	add	x24, x24, :lo12:.LANCHOR14
	add	x25, x25, :lo12:.LC138
	adrp	x26, .LANCHOR166
.L2379:
	ldr	w0, [x24]
	tbz	x0, 4, .L2376
	mov	w3, w19
	mov	w2, w20
	mov	w1, w27
	mov	x0, x25
	bl	printf
.L2376:
	mov	w4, w28
	mov	x3, x22
	mov	x2, x23
	mov	w1, w19
	mov	w0, w27
	bl	flash_prog_page
	mov	w5, w0
	ldr	w0, [x29, 124]
	cbz	w0, .L2377
	adrp	x6, .LANCHOR167
	ldr	x3, [x26, #:lo12:.LANCHOR166]
	mov	w4, w28
	str	x6, [x29, 112]
	ldr	x2, [x6, #:lo12:.LANCHOR167]
	mov	w1, w20
	mov	w0, w21
	str	w5, [x29, 104]
	bl	flash_read_page_en
	cmp	w0, 512
	ldr	x6, [x29, 112]
	mov	w4, w0
	ccmn	w0, #1, 4, ne
	mov	x7, x6
	beq	.L2378
	ldr	x0, [x6, #:lo12:.LANCHOR167]
	ldr	w1, [x23]
	ldr	w5, [x29, 104]
	ldr	w0, [x0]
	cmp	w1, w0
	bne	.L2378
	ldr	x0, [x26, #:lo12:.LANCHOR166]
	ldr	w1, [x22]
	ldr	w0, [x0]
	cmp	w1, w0
	beq	.L2377
.L2378:
	str	w4, [x29, 112]
	mov	w3, 4
	str	x7, [x29, 104]
	mov	w2, w3
	mov	x1, x23
	adrp	x0, .LC139
	add	x0, x0, :lo12:.LC139
	bl	rknand_print_hex
	mov	w3, 4
	mov	x1, x22
	mov	w2, w3
	adrp	x0, .LC140
	add	x0, x0, :lo12:.LC140
	bl	rknand_print_hex
	adrp	x0, .LANCHOR166
	mov	w3, 4
	mov	w2, w3
	ldr	x1, [x0, #:lo12:.LANCHOR166]
	adrp	x0, .LC141
	add	x0, x0, :lo12:.LC141
	bl	rknand_print_hex
	ldr	x7, [x29, 104]
	mov	w3, 4
	adrp	x0, .LC142
	mov	w2, w3
	add	x0, x0, :lo12:.LC142
	ldr	x1, [x7, #:lo12:.LANCHOR167]
	bl	rknand_print_hex
	ldr	w4, [x29, 112]
	cmp	w4, 512
	beq	.L2379
.L2381:
	mov	w1, w20
	adrp	x0, .LC143
	add	x0, x0, :lo12:.LC143
	bl	printf
	adrp	x1, .LANCHOR178
	adrp	x0, .LC0
	mov	w2, 587
	add	x1, x1, :lo12:.LANCHOR178
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2382:
	mov	w0, -1
	b	.L2370
.L2375:
	adrp	x0, .LANCHOR3
	add	x0, x0, :lo12:.LANCHOR3
	ldrh	w0, [x0, w1, uxtw 1]
	add	w19, w0, w19
	b	.L2373
.L2384:
	mov	w19, w20
	b	.L2373
.L2377:
	mov	w0, w5
	cmn	w5, #1
	beq	.L2381
.L2370:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
	.size	flash_prog_page_en, .-flash_prog_page_en
	.section	.text.ftl_test_block,"ax",@progbits
	.align	2
	.global	ftl_test_block
	.type	ftl_test_block, %function
ftl_test_block:
	stp	x29, x30, [sp, -128]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	adrp	x24, ftl_tmp_buffer
	stp	x25, x26, [sp, 64]
	adrp	x25, .LANCHOR179
	stp	x21, x22, [sp, 32]
	adrp	x26, .LANCHOR106
	and	w21, w0, 65535
	add	x0, x26, :lo12:.LANCHOR106
	stp	x19, x20, [sp, 16]
	mov	w23, 0
	stp	x27, x28, [sp, 80]
	mov	w20, 0
	adrp	x27, .LANCHOR69
	str	x0, [x29, 112]
	str	wzr, [x24, #:lo12:ftl_tmp_buffer]
	add	x0, x27, :lo12:.LANCHOR69
	str	wzr, [x25, #:lo12:.LANCHOR179]
	str	x0, [x29, 96]
.L2401:
	ldr	x0, [x29, 112]
	ldrb	w0, [x0]
	cmp	w0, w20
	bls	.L2411
	add	x0, x27, :lo12:.LANCHOR69
	mov	w22, 0
	str	x0, [x29, 120]
	adrp	x0, .LANCHOR14
	add	x0, x0, :lo12:.LANCHOR14
	str	x0, [x29, 104]
	b	.L2412
.L2410:
	ldr	x0, [x29, 104]
	ldr	w0, [x0]
	tbz	x0, 12, .L2402
	adrp	x0, .LC144
	mov	w1, w21
	add	x0, x0, :lo12:.LC144
	bl	printf
.L2402:
	ldr	x0, [x29, 96]
	ldrb	w19, [x0]
	madd	w19, w21, w19, w22
	and	w19, w19, 65535
	cbnz	w20, .L2403
	adrp	x0, .LANCHOR27
	ldr	x0, [x0, #:lo12:.LANCHOR27]
	ldrb	w0, [x0, 47]
	cmp	w0, w19
	bcs	.L2404
.L2403:
	and	w28, w20, 255
	mov	w1, w19
	mov	w0, w28
	bl	flash_check_bad_block
	cbnz	w0, .L2404
	adrp	x0, .LANCHOR105
	mov	w1, w23
	ldrh	w7, [x0, #:lo12:.LANCHOR105]
	mov	w0, w28
	mul	w26, w7, w19
	mov	w2, w26
	bl	flash_erase_block_en
	cbz	w0, .L2405
	adrp	x0, .LANCHOR73
	ldrb	w0, [x0, #:lo12:.LANCHOR73]
	cmp	w0, 2
	bne	.L2427
	adrp	x0, .LANCHOR0
	ldrb	w0, [x0, #:lo12:.LANCHOR0]
	cbz	w0, .L2427
	mov	w2, w26
	mov	w1, 1
	mov	w0, w28
	bl	flash_erase_block_en
	cbnz	w0, .L2427
.L2409:
	adrp	x0, .LANCHOR73
	mov	w23, 1
	ldrb	w0, [x0, #:lo12:.LANCHOR73]
	add	w26, w26, w0, lsl 24
.L2408:
	adrp	x0, .LANCHOR125
	mov	w5, 1
	add	x3, x25, :lo12:.LANCHOR179
	add	x2, x24, :lo12:ftl_tmp_buffer
	ldrb	w4, [x0, #:lo12:.LANCHOR125]
	mov	w1, w26
	mov	w0, w28
	bl	flash_prog_page_en
	cbz	w0, .L2404
.L2427:
	mov	w1, w19
	mov	w0, w28
	bl	flash_mask_bad_block
.L2404:
	add	w22, w22, 1
	and	w22, w22, 65535
.L2412:
	ldr	x0, [x29, 120]
	ldrb	w0, [x0]
	cmp	w0, w22
	bhi	.L2410
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L2401
.L2405:
	cbz	w23, .L2408
	b	.L2409
.L2411:
	cbz	w23, .L2413
	adrp	x0, .LANCHOR7
	mov	w1, 2
	ldr	x0, [x0, #:lo12:.LANCHOR7]
	add	x21, x0, x21, uxth 2
	ldrb	w0, [x21, 2]
	bfi	w0, w1, 3, 2
	strb	w0, [x21, 2]
.L2413:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
	.size	ftl_test_block, .-ftl_test_block
	.section	.text.ftl_prog_page,"ax",@progbits
	.align	2
	.global	ftl_prog_page
	.type	ftl_prog_page, %function
ftl_prog_page:
	stp	x29, x30, [sp, -64]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w19, w0, 255
	stp	x21, x22, [sp, 32]
	mov	w20, w1
	mov	x21, x2
	mov	x22, x3
	str	x23, [sp, 48]
	mov	w23, w4
	bl	sblk_wait_write_queue_completed
	mov	w0, w19
	mov	w5, 1
	mov	w4, w23
	mov	x3, x22
	mov	x2, x21
	mov	w1, w20
	bl	flash_prog_page_en
	mov	w19, w0
	cmn	w0, #1
	bne	.L2428
	mov	w2, 2324
	adrp	x1, .LANCHOR180
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR180
	add	x0, x0, :lo12:.LC0
	bl	printf
	adrp	x0, .LC143
	mov	w1, w20
	add	x0, x0, :lo12:.LC143
	bl	printf
.L2428:
	mov	w0, w19
	ldr	x23, [sp, 48]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
	.size	ftl_prog_page, .-ftl_prog_page
	.section	.text.ftl_info_flush,"ax",@progbits
	.align	2
	.global	ftl_info_flush
	.type	ftl_info_flush, %function
ftl_info_flush:
	stp	x29, x30, [sp, -128]!
	mov	w1, 0
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR125
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR104
	ldrb	w2, [x20, #:lo12:.LANCHOR125]
	adrp	x19, .LANCHOR181
	stp	x27, x28, [sp, 80]
	mov	w27, w0
	stp	x23, x24, [sp, 48]
	add	x0, x19, :lo12:.LANCHOR181
	stp	x25, x26, [sp, 64]
	lsl	w2, w2, 1
	bl	ftl_memset
	ldr	x0, [x22, #:lo12:.LANCHOR104]
	ldrh	w1, [x0, 74]
	cbz	w1, .L2432
	strh	wzr, [x0, 150]
.L2432:
	adrp	x21, .LANCHOR182
	adrp	x23, .LANCHOR105
	add	x25, x21, :lo12:.LANCHOR182
	add	x28, x23, :lo12:.LANCHOR105
	mov	w24, 0
.L2445:
	add	x0, x21, :lo12:.LANCHOR182
	ldrb	w7, [x21, #:lo12:.LANCHOR182]
	ldrh	w5, [x23, #:lo12:.LANCHOR105]
	ldrh	w4, [x0, 2]
	ldr	x0, [x22, #:lo12:.LANCHOR104]
	ldr	w3, [x0, 4]
	add	w3, w3, 1
	str	w3, [x0, 4]
	add	x0, x19, :lo12:.LANCHOR181
	str	w27, [x19, #:lo12:.LANCHOR181]
	str	w3, [x0, 4]
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2433
	mov	w2, w4
	mov	w1, w7
	stp	w5, w4, [x29, 108]
	adrp	x0, .LC145
	str	w7, [x29, 120]
	add	x0, x0, :lo12:.LC145
	bl	printf
	ldp	w5, w4, [x29, 108]
	ldr	w7, [x29, 120]
.L2433:
	adrp	x1, .LANCHOR87
	ldrh	w0, [x25, 2]
	ldrh	w1, [x1, #:lo12:.LANCHOR87]
	cmp	w1, w0
	bhi	.L2434
	adrp	x3, .LANCHOR183
	adrp	x4, .LC0
	add	x3, x3, :lo12:.LANCHOR183
	add	x4, x4, :lo12:.LC0
.L2441:
	ldrb	w0, [x25, 1]
	adrp	x26, .LANCHOR27
	add	w0, w0, 1
	and	w0, w0, 255
	strb	w0, [x25, 1]
	cmp	w0, 7
	bls	.L2435
	mov	x0, 0
.L2440:
	ldr	x2, [x26, #:lo12:.LANCHOR27]
	add	w1, w0, 8
	and	w24, w0, 65535
	add	x1, x2, x1, sxtw
	ldrb	w2, [x1, 32]
	add	w1, w2, 127
	and	w1, w1, 255
	cmp	w1, 125
	bhi	.L2436
	mov	x1, x3
	mov	x0, x4
	stp	x3, x4, [x29, 112]
	mov	w2, 751
	bl	printf
	ldp	x3, x4, [x29, 112]
.L2439:
	strb	w24, [x25, 1]
	mov	w24, 1
.L2435:
	ldr	x0, [x26, #:lo12:.LANCHOR27]
	ldrb	w1, [x25, 1]
	add	x0, x0, x1
	ldrb	w0, [x0, 40]
	strb	w0, [x25]
	cmp	w0, 255
	beq	.L2441
	ldrh	w5, [x28]
	mul	w26, w5, w0
	mov	w0, 0
	mov	w1, w26
	bl	flash_erase_block
	ldrb	w4, [x20, #:lo12:.LANCHOR125]
	add	x3, x19, :lo12:.LANCHOR181
	adrp	x2, ftl_info_data_buffer
	mov	w1, w26
	add	x2, x2, :lo12:ftl_info_data_buffer
	mov	w0, 0
	bl	ftl_prog_page
	add	w5, w26, 1
	mov	w0, 1
	strh	w0, [x25, 2]
.L2442:
	ldrb	w4, [x20, #:lo12:.LANCHOR125]
	mov	w1, w5
	add	x3, x19, :lo12:.LANCHOR181
	adrp	x2, ftl_info_data_buffer
	mov	w0, 0
	add	x2, x2, :lo12:ftl_info_data_buffer
	bl	ftl_prog_page
	cmn	w0, #1
	ldrh	w1, [x25, 2]
	adrp	x0, .LANCHOR184
	add	w1, w1, 1
	strh	w1, [x25, 2]
	beq	.L2443
	ldrb	w1, [x0, #:lo12:.LANCHOR184]
	cbz	w1, .L2444
.L2443:
	strb	wzr, [x0, #:lo12:.LANCHOR184]
	b	.L2445
.L2436:
	cmp	w2, 255
	bne	.L2439
	add	x0, x0, 1
	cmp	x0, 8
	bne	.L2440
	mov	w24, w0
	b	.L2439
.L2434:
	madd	w5, w5, w7, w4
	cbnz	w0, .L2442
	mov	w1, w5
	str	w5, [x29, 120]
	bl	flash_erase_block
	ldr	w5, [x29, 120]
	b	.L2442
.L2444:
	cbnz	w24, .L2446
.L2454:
	adrp	x0, .LANCHOR182
	ldrb	w0, [x0, #:lo12:.LANCHOR182]
	cmp	w0, 255
	bne	.L2448
	adrp	x1, .LANCHOR183
	adrp	x0, .LC0
	mov	w2, 787
	add	x1, x1, :lo12:.LANCHOR183
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2448:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L2446:
	ldrb	w19, [x25, 1]
	adrp	x20, .LANCHOR183
	adrp	x21, .LC0
	add	x20, x20, :lo12:.LANCHOR183
	add	w19, w19, 1
	add	x21, x21, :lo12:.LC0
	adrp	x22, .LANCHOR27
.L2449:
	cmp	w19, 7
	bhi	.L2454
	ldr	x1, [x22, #:lo12:.LANCHOR27]
	add	w0, w19, 8
	add	x0, x1, x0, sxtw
	ldrb	w23, [x0, 32]
	add	w0, w23, 127
	and	w0, w0, 255
	cmp	w0, 125
	bhi	.L2450
	mov	w2, 780
	mov	x1, x20
	mov	x0, x21
	bl	printf
.L2451:
	adrp	x0, .LANCHOR105
	ldrh	w1, [x0, #:lo12:.LANCHOR105]
	mov	w0, 0
	mul	w1, w1, w23
	bl	flash_erase_block
	b	.L2452
.L2450:
	cmp	w23, 255
	bne	.L2451
.L2452:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L2449
	.size	ftl_info_flush, .-ftl_info_flush
	.section	.text.ftl_info_blk_init,"ax",@progbits
	.align	2
	.global	ftl_info_blk_init
	.type	ftl_info_blk_init, %function
ftl_info_blk_init:
	stp	x29, x30, [sp, -128]!
	adrp	x0, .LANCHOR185
	adrp	x1, .LANCHOR184
	mov	w2, 16384
	add	x29, sp, 0
	strb	wzr, [x0, #:lo12:.LANCHOR185]
	mov	w0, 1
	strb	w0, [x1, #:lo12:.LANCHOR184]
	adrp	x1, .LANCHOR186
	stp	x19, x20, [sp, 16]
	adrp	x20, ftl_info_data_buffer
	strb	w0, [x1, #:lo12:.LANCHOR186]
	adrp	x1, .LANCHOR7
	add	x0, x20, :lo12:ftl_info_data_buffer
	stp	x21, x22, [sp, 32]
	str	x0, [x1, #:lo12:.LANCHOR7]
	adrp	x1, .LANCHOR6
	adrp	x21, .LANCHOR104
	stp	x23, x24, [sp, 48]
	ldrh	w1, [x1, #:lo12:.LANCHOR6]
	adrp	x24, .LANCHOR27
	stp	x25, x26, [sp, 64]
	adrp	x22, .LANCHOR182
	stp	x27, x28, [sp, 80]
	adrp	x26, .LANCHOR105
	add	x1, x0, x1, lsl 2
	str	x1, [x21, #:lo12:.LANCHOR104]
	mov	w1, 0
	bl	ftl_memset
	mov	w1, 0
	mov	w2, 16384
	adrp	x0, ftl_ext_info_data_buffer
	add	x0, x0, :lo12:ftl_ext_info_data_buffer
	bl	ftl_memset
	adrp	x23, .LANCHOR125
	ldr	x1, [x24, #:lo12:.LANCHOR27]
	add	x0, x22, :lo12:.LANCHOR182
	mov	w27, 21574
	add	x26, x26, :lo12:.LANCHOR105
	add	x23, x23, :lo12:.LANCHOR125
	mov	x19, 7
	strb	wzr, [x0, 1]
	movk	w27, 0x494c, lsl 16
	ldrb	w1, [x1, 40]
	strb	w1, [x22, #:lo12:.LANCHOR182]
	strh	wzr, [x0, 2]
.L2473:
	ldr	x1, [x24, #:lo12:.LANCHOR27]
	add	w0, w19, 8
	sxth	w25, w19
	mov	w28, w19
	add	x0, x1, x0, sxtw
	ldrb	w0, [x0, 32]
	cmp	w0, 255
	bne	.L2472
.L2477:
	sub	x19, x19, #1
	cmn	x19, #1
	bne	.L2473
	mov	w25, 0
.L2474:
	adrp	x23, .LANCHOR14
	ldr	w0, [x23, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2478
	ldr	x0, [x21, #:lo12:.LANCHOR104]
	mov	w2, 4800
	mov	w1, w19
	ldr	w3, [x0]
	adrp	x0, .LC147
	add	x0, x0, :lo12:.LC147
	bl	printf
.L2478:
	cmn	w19, #1
	bne	.L2479
	mov	w1, 0
	mov	w2, 16384
	add	x0, x20, :lo12:ftl_info_data_buffer
	bl	ftl_memset
	ldr	x0, [x21, #:lo12:.LANCHOR104]
	mov	w1, 21574
	movk	w1, 0x494c, lsl 16
	str	w1, [x0]
	mov	w1, 24
	movk	w1, 0x6, lsl 16
	str	w1, [x0, 12]
	mov	w0, w19
.L2471:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L2472:
	ldrh	w6, [x26]
	add	x8, x20, :lo12:ftl_info_data_buffer
	ldrb	w4, [x23]
	adrp	x7, .LANCHOR181
	add	x7, x7, :lo12:.LANCHOR181
	mov	x2, x8
	mov	x3, x7
	stp	x7, x8, [x29, 104]
	mul	w6, w6, w0
	mov	w0, 0
	str	w6, [x29, 124]
	mov	w1, w6
	bl	ftl_read_page
	mov	w5, w0
	cmn	w0, #1
	ldr	w6, [x29, 124]
	ldp	x7, x8, [x29, 104]
	bne	.L2475
	ldrb	w4, [x23]
	mov	x3, x7
	mov	x2, x8
	add	w1, w6, 1
	mov	w0, 0
	bl	ftl_read_page
	mov	w5, w0
.L2475:
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2476
	ldr	x0, [x21, #:lo12:.LANCHOR104]
	mov	w2, w5
	str	w5, [x29, 124]
	mov	w3, 672
	mov	w1, w28
	ldr	w4, [x0]
	adrp	x0, .LC146
	add	x0, x0, :lo12:.LC146
	bl	printf
	ldr	w5, [x29, 124]
.L2476:
	cmn	w5, #1
	beq	.L2477
	ldr	x0, [x21, #:lo12:.LANCHOR104]
	ldr	w0, [x0]
	cmp	w0, w27
	bne	.L2477
	mov	w19, w25
	b	.L2474
.L2479:
	ldr	x1, [x24, #:lo12:.LANCHOR27]
	add	w0, w25, 8
	add	x20, x20, :lo12:ftl_info_data_buffer
	mov	w4, 4
	mov	x2, x20
	adrp	x27, .LANCHOR125
	add	x0, x1, x0, sxtw
	mov	w28, 21574
	add	x27, x27, :lo12:.LANCHOR125
	movk	w28, 0x494c, lsl 16
	ldrb	w1, [x0, 32]
	add	x0, x22, :lo12:.LANCHOR182
	strb	w1, [x22, #:lo12:.LANCHOR182]
	strb	w25, [x0, 1]
	adrp	x25, .LANCHOR181
	add	x25, x25, :lo12:.LANCHOR181
	mov	w0, 0
	mov	x3, x25
	bl	flash_get_last_written_page
	sxth	w24, w0
	add	w0, w0, 1
	and	w19, w0, 65535
	adrp	x0, .LANCHOR105
	ldrb	w26, [x22, #:lo12:.LANCHOR182]
	ldrh	w0, [x0, #:lo12:.LANCHOR105]
	madd	w26, w26, w0, w24
.L2481:
	tbnz	w24, #31, .L2485
	ldrb	w4, [x27]
	mov	x3, x25
	mov	x2, x20
	mov	w1, w26
	mov	w0, 0
	bl	ftl_read_page
	cmn	w0, #1
	beq	.L2482
	ldr	x0, [x21, #:lo12:.LANCHOR104]
	ldr	w0, [x0]
	cmp	w0, w28
	bne	.L2482
.L2485:
	add	x22, x22, :lo12:.LANCHOR182
	strh	w19, [x22, 2]
	bl	ftl_tmp_into_update
	ldr	x1, [x21, #:lo12:.LANCHOR104]
	ldr	w0, [x1, 64]
	add	w0, w0, 1
	str	w0, [x1, 64]
	mov	w0, 0
	bl	ftl_info_flush
	mov	w0, 0
	bl	ftl_info_flush
	ldr	w0, [x23, #:lo12:.LANCHOR14]
	tbnz	x0, 14, .L2483
.L2500:
	mov	w0, 0
	b	.L2471
.L2482:
	sub	w24, w24, #1
	sub	w26, w26, #1
	sxth	w24, w24
	b	.L2481
.L2483:
	ldr	x0, [x21, #:lo12:.LANCHOR104]
	ldr	w1, [x0, 156]
	adrp	x0, .LC148
	add	x0, x0, :lo12:.LC148
	bl	printf
	b	.L2500
	.size	ftl_info_blk_init, .-ftl_info_blk_init
	.section	.text.ftl_ext_info_flush,"ax",@progbits
	.align	2
	.global	ftl_ext_info_flush
	.type	ftl_ext_info_flush, %function
ftl_ext_info_flush:
	stp	x29, x30, [sp, -96]!
	adrp	x0, .LANCHOR10
	add	x29, sp, 0
	ldr	x0, [x0, #:lo12:.LANCHOR10]
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	ldr	w1, [x0, 520]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	cbz	w1, .L2502
	str	wzr, [x0, 520]
.L2502:
	adrp	x20, .LANCHOR87
	adrp	x22, .LANCHOR187
	adrp	x21, .LANCHOR31
	add	x20, x20, :lo12:.LANCHOR87
	add	x22, x22, :lo12:.LANCHOR187
	add	x21, x21, :lo12:.LANCHOR31
	mov	w0, 0
	bl	ftl_total_vpn_update
.L2503:
	adrp	x23, .LANCHOR104
	mov	x24, x23
.L2506:
	ldr	x0, [x23, #:lo12:.LANCHOR104]
	ldr	w1, [x0, 56]
	add	w1, w1, 1
	str	w1, [x0, 56]
	ldrh	w1, [x0, 140]
	ldrh	w0, [x20]
	cmp	w1, w0
	bcc	.L2504
	bl	ftl_ext_alloc_new_blk
.L2504:
	ldr	x0, [x24, #:lo12:.LANCHOR104]
	ldrh	w1, [x0, 130]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L2505
	adrp	x0, .LC0
	mov	w2, 1912
	mov	x1, x22
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2505:
	ldrb	w19, [x21]
	mov	w0, 24
	ldr	x1, [x24, #:lo12:.LANCHOR104]
	adrp	x26, .LANCHOR125
	sub	w19, w0, w19
	adrp	x0, .LANCHOR68
	adrp	x27, .LANCHOR181
	add	x25, x27, :lo12:.LANCHOR181
	ldrh	w0, [x0, #:lo12:.LANCHOR68]
	ldrh	w2, [x1, 130]
	sub	w0, w19, w0
	mov	w19, 1
	asr	w28, w2, w0
	lsl	w19, w19, w0
	adrp	x0, .LANCHOR105
	sub	w19, w19, #1
	and	w19, w19, w2
	ldrh	w2, [x0, #:lo12:.LANCHOR105]
	ldrh	w0, [x1, 140]
	sxth	w19, w19
	mov	w1, 0
	madd	w19, w19, w2, w0
	ldrb	w2, [x26, #:lo12:.LANCHOR125]
	mov	x0, x25
	lsl	w2, w2, 1
	bl	ftl_memset
	ldr	x0, [x24, #:lo12:.LANCHOR104]
	mov	w1, w19
	ldrb	w4, [x26, #:lo12:.LANCHOR125]
	mov	x3, x25
	str	wzr, [x27, #:lo12:.LANCHOR181]
	adrp	x2, ftl_ext_info_data_buffer
	add	x2, x2, :lo12:ftl_ext_info_data_buffer
	ldr	w0, [x0, 56]
	str	w0, [x25, 4]
	mov	w0, w28
	bl	ftl_prog_page
	ldr	x2, [x24, #:lo12:.LANCHOR104]
	ldrh	w1, [x2, 140]
	add	w1, w1, 1
	and	w1, w1, 65535
	strh	w1, [x2, 140]
	cmp	w1, 1
	beq	.L2506
	cmn	w0, #1
	adrp	x0, .LANCHOR186
	beq	.L2507
	ldrb	w1, [x0, #:lo12:.LANCHOR186]
	cbz	w1, .L2508
.L2507:
	strb	wzr, [x0, #:lo12:.LANCHOR186]
	b	.L2503
.L2508:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
	.size	ftl_ext_info_flush, .-ftl_ext_info_flush
	.section	.text.ftl_ext_info_init,"ax",@progbits
	.align	2
	.global	ftl_ext_info_init
	.type	ftl_ext_info_init, %function
ftl_ext_info_init:
	stp	x29, x30, [sp, -112]!
	adrp	x0, .LANCHOR115
	adrp	x2, .LANCHOR68
	mov	w4, 4
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR104
	strh	wzr, [x0, #:lo12:.LANCHOR115]
	ldr	x0, [x20, #:lo12:.LANCHOR104]
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR14
	stp	x27, x28, [sp, 80]
	stp	x25, x26, [sp, 64]
	adrp	x25, .LANCHOR181
	ldrh	w1, [x0, 130]
	adrp	x0, .LANCHOR31
	stp	x23, x24, [sp, 48]
	adrp	x26, ftl_ext_info_data_buffer
	ldrb	w19, [x0, #:lo12:.LANCHOR31]
	mov	w0, 24
	add	x3, x25, :lo12:.LANCHOR181
	sub	w0, w0, w19
	ldrh	w19, [x2, #:lo12:.LANCHOR68]
	add	x2, x26, :lo12:ftl_ext_info_data_buffer
	sub	w0, w0, w19
	mov	w19, 1
	lsl	w19, w19, w0
	sub	w19, w19, #1
	asr	w22, w1, w0
	and	w19, w19, w1
	and	w28, w22, 255
	mov	w1, w19
	mov	w0, w28
	bl	flash_get_last_written_page
	sxth	w23, w0
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2519
	ldr	x0, [x20, #:lo12:.LANCHOR104]
	adrp	x1, .LANCHOR188
	and	w4, w22, 65535
	mov	w3, w23
	mov	w2, 1956
	add	x1, x1, :lo12:.LANCHOR188
	ldrh	w5, [x0, 130]
	adrp	x0, .LC149
	add	x0, x0, :lo12:.LC149
	bl	printf
.L2519:
	adrp	x27, .LANCHOR125
	adrp	x5, .LANCHOR105
	mov	w6, 20038
	add	x27, x27, :lo12:.LANCHOR125
	add	x5, x5, :lo12:.LANCHOR105
	mov	w24, 0
	movk	w6, 0x4549, lsl 16
.L2520:
	and	w22, w23, 65535
	sub	w0, w22, w24
	tbnz	x0, 15, .L2525
	ldrh	w0, [x5]
	sub	w1, w23, w24
	ldrb	w4, [x27]
	add	x3, x25, :lo12:.LANCHOR181
	str	w6, [x29, 100]
	add	x2, x26, :lo12:ftl_ext_info_data_buffer
	str	x5, [x29, 104]
	madd	w1, w0, w19, w1
	mov	w0, w28
	bl	flash_read_page_en
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	ldr	w6, [x29, 100]
	ldr	x5, [x29, 104]
	beq	.L2521
	adrp	x0, .LANCHOR10
	ldr	x0, [x0, #:lo12:.LANCHOR10]
	ldr	w0, [x0]
	cmp	w0, w6
	bne	.L2521
.L2525:
	bl	zftl_sblk_list_init
	ldr	x0, [x20, #:lo12:.LANCHOR104]
	ldrh	w1, [x0, 140]
	cmp	w1, w23
	bgt	.L2523
	add	w22, w22, 1
	strh	w22, [x0, 140]
	bl	ftl_ext_info_flush
.L2523:
	adrp	x0, .LANCHOR10
	mov	w1, -1
	ldr	x0, [x0, #:lo12:.LANCHOR10]
	strh	w1, [x0, 584]
	strh	w1, [x0, 586]
	strh	w1, [x0, 588]
	strh	w1, [x0, 590]
	mov	w1, 65535
	str	w1, [x0, 560]
	mov	w1, -1
	str	w1, [x0, 564]
	ldr	w1, [x21, #:lo12:.LANCHOR14]
	str	wzr, [x0, 520]
	str	wzr, [x0, 604]
	str	wzr, [x0, 608]
	tbz	x1, 12, .L2526
	ldr	w3, [x0, 12]
	adrp	x1, .LANCHOR188
	adrp	x0, .LC150
	mov	w4, 0
	mov	w2, 0
	add	x1, x1, :lo12:.LANCHOR188
	add	x0, x0, :lo12:.LC150
	bl	printf
.L2526:
	adrp	x0, .LANCHOR66
	mov	w1, -1
	ldp	x19, x20, [sp, 16]
	strh	w1, [x0, #:lo12:.LANCHOR66]
	ldp	x21, x22, [sp, 32]
	mov	w0, 0
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L2521:
	add	w24, w24, 1
	b	.L2520
	.size	ftl_ext_info_init, .-ftl_ext_info_init
	.section	.text.ftl_prog_ppa_page,"ax",@progbits
	.align	2
	.global	ftl_prog_ppa_page
	.type	ftl_prog_ppa_page, %function
ftl_prog_ppa_page:
	adrp	x4, .LANCHOR31
	mov	w5, 1
	ldrb	w6, [x4, #:lo12:.LANCHOR31]
	mov	w4, 24
	sub	w4, w4, w6
	lsl	w7, w5, w4
	sub	w7, w7, #1
	lsl	w5, w5, w6
	sub	w6, w5, #1
	lsr	w5, w0, w4
	mov	w4, w3
	mov	x3, x2
	mov	x2, x1
	and	w1, w7, w0
	and	w0, w6, w5
	b	ftl_prog_page
	.size	ftl_prog_ppa_page, .-ftl_prog_ppa_page
	.section	.text.ftl_write_last_log_page,"ax",@progbits
	.align	2
	.global	ftl_write_last_log_page
	.type	ftl_write_last_log_page, %function
ftl_write_last_log_page:
	ldrh	w1, [x0, 6]
	cmp	w1, 1
	bne	.L2540
	stp	x29, x30, [sp, -48]!
	adrp	x1, .LANCHOR111
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	stp	x21, x22, [sp, 32]
	ldr	x20, [x1, #:lo12:.LANCHOR111]
	ldrh	w22, [x0, 12]
	bl	ftl_get_new_free_page
	mov	w21, w0
	cmn	w0, #1
	beq	.L2541
	ldrh	w0, [x19]
	add	x20, x20, x22, uxth 2
	bl	ftl_vpn_decrement
	adrp	x0, .LANCHOR179
	mov	w1, 15555
	add	x6, x0, :lo12:.LANCHOR179
	movk	w1, 0xf55f, lsl 16
	str	w1, [x0, #:lo12:.LANCHOR179]
	adrp	x0, .LANCHOR87
	ldrh	w1, [x0, #:lo12:.LANCHOR87]
	adrp	x0, .LANCHOR80
	ldrb	w0, [x0, #:lo12:.LANCHOR80]
	mul	w1, w1, w0
	mov	x0, x20
	lsl	w1, w1, 2
	bl	js_hash
	stp	w0, wzr, [x6, 4]
	adrp	x0, .LANCHOR125
	mov	x2, x6
	mov	x1, x20
	ldrb	w3, [x0, #:lo12:.LANCHOR125]
	mov	w0, w21
	str	wzr, [x6, 12]
	bl	ftl_prog_ppa_page
.L2541:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L2540:
	mov	w0, -1
	ret
	.size	ftl_write_last_log_page, .-ftl_write_last_log_page
	.section	.text.ftl_open_sblk_recovery,"ax",@progbits
	.align	2
	.global	ftl_open_sblk_recovery
	.type	ftl_open_sblk_recovery, %function
ftl_open_sblk_recovery:
	stp	x29, x30, [sp, -368]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR14
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	str	x1, [x29, 144]
	tbz	x0, 12, .L2547
	ldrh	w1, [x19, 2]
	adrp	x0, .LC151
	add	x0, x0, :lo12:.LC151
	bl	printf
.L2547:
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2548
	ldrb	w1, [x19, 5]
	adrp	x0, .LC152
	add	x0, x0, :lo12:.LC152
	bl	printf
.L2548:
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2549
	ldrh	w1, [x19]
	adrp	x0, .LC153
	add	x0, x0, :lo12:.LC153
	bl	printf
.L2549:
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2550
	ldrh	w2, [x19, 18]
	adrp	x0, .LC154
	ldrh	w1, [x19, 16]
	add	x0, x0, :lo12:.LC154
	bl	printf
.L2550:
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2551
	ldrb	w1, [x19, 9]
	adrp	x0, .LC155
	add	x0, x0, :lo12:.LC155
	bl	printf
.L2551:
	ldrh	w0, [x19, 10]
	strh	w0, [x19, 14]
	adrp	x0, .LANCHOR6
	ldrh	w1, [x19]
	ldrh	w0, [x0, #:lo12:.LANCHOR6]
	cmp	w1, w0
	bcs	.L2546
	mov	w0, 1
	add	x23, x29, 176
	bl	buf_alloc
	add	x26, x29, 240
	mov	w2, 64
	mov	w1, 255
	mov	x20, x0
	mov	x0, x23
	bl	ftl_memset
	add	x27, x29, 304
	mov	w2, 64
	mov	w1, 255
	mov	x0, x26
	bl	ftl_memset
	mov	w2, 64
	mov	w1, 255
	mov	x0, x27
	bl	ftl_memset
	ldrb	w22, [x19, 5]
	mov	w0, 2
	ldrh	w24, [x19, 2]
	adrp	x25, .LANCHOR87
	str	w0, [x29, 168]
	adrp	x0, .LANCHOR125
	str	wzr, [x29, 160]
	add	x0, x0, :lo12:.LANCHOR125
	str	x0, [x29, 128]
.L2553:
	ldrh	w0, [x25, #:lo12:.LANCHOR87]
	cmp	w0, w24
	bhi	.L2566
.L2556:
	ldrh	w0, [x19, 10]
	ldrh	w1, [x19, 6]
	ldrh	w2, [x25, #:lo12:.LANCHOR87]
	add	w1, w1, w0
	ldrb	w0, [x19, 9]
	strh	w24, [x19, 2]
	strb	w22, [x19, 5]
	mul	w0, w0, w2
	cmp	w1, w0
	beq	.L2567
	adrp	x1, .LANCHOR189
	adrp	x0, .LC0
	mov	w2, 1569
	add	x1, x1, :lo12:.LANCHOR189
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2567:
	adrp	x2, .LANCHOR111
	ldrh	w3, [x19, 10]
	mov	w0, 0
	mov	w1, 0
	ldr	x4, [x2, #:lo12:.LANCHOR111]
	str	x2, [x29, 136]
.L2568:
	cmp	w1, w3
	bcc	.L2570
	ldrb	w22, [x19, 9]
	adrp	x24, .LANCHOR9
	ldrh	w1, [x25, #:lo12:.LANCHOR87]
	madd	w22, w22, w1, w0
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	sub	w22, w22, w3
	and	w22, w22, 65535
	tbz	x0, 12, .L2571
	ldrh	w1, [x19]
	ldr	x2, [x24, #:lo12:.LANCHOR9]
	ubfiz	x0, x1, 1, 16
	ldrh	w3, [x2, x0]
	adrp	x0, .LC156
	mov	w2, w22
	add	x0, x0, :lo12:.LC156
	bl	printf
.L2571:
	ldr	x0, [x24, #:lo12:.LANCHOR9]
	ldrh	w1, [x19]
	strh	w22, [x0, x1, lsl 1]
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	tbz	x0, 14, .L2572
	ldp	w1, w2, [x29, 176]
	adrp	x0, .LC157
	ldp	w3, w4, [x29, 184]
	add	x0, x0, :lo12:.LC157
	bl	printf
.L2572:
	adrp	x24, .LANCHOR125
	ldr	x0, [x20, 8]
	mov	w1, 0
	mov	x28, 0
	ldrb	w2, [x24, #:lo12:.LANCHOR125]
	lsl	w2, w2, 9
	bl	ftl_memset
	adrp	x0, .LC159
	add	x0, x0, :lo12:.LC159
	str	x0, [x29, 120]
	adrp	x0, .LANCHOR80
	add	x0, x0, :lo12:.LANCHOR80
	str	x0, [x29, 112]
.L2573:
	adrp	x0, .LANCHOR80
	ldr	w2, [x29, 168]
	add	x1, x0, :lo12:.LANCHOR80
	str	w28, [x29, 152]
	ldrb	w0, [x0, #:lo12:.LANCHOR80]
	mul	w0, w0, w2
	cmp	w28, w0
	bcc	.L2585
	adrp	x0, .LC160
	add	x0, x0, :lo12:.LC160
	stp	x0, x1, [x29, 152]
	adrp	x0, .LC159
	add	x28, x0, :lo12:.LC159
	mov	x22, 0
.L2586:
	ldr	x0, [x29, 160]
	ldr	w1, [x29, 168]
	ldrb	w0, [x0]
	mul	w0, w0, w1
	cmp	w0, w22
	bhi	.L2592
	mov	x0, x20
	bl	zbuf_free
	ldrh	w1, [x19, 12]
	ldrh	w0, [x25, #:lo12:.LANCHOR87]
	ldrb	w2, [x19, 9]
	madd	w0, w0, w2, w1
	mov	x1, -4
	add	x0, x1, x0, sxtw 2
	ldr	x1, [x29, 136]
	ldr	x1, [x1, #:lo12:.LANCHOR111]
	ldr	w0, [x1, x0]
	cmn	w0, #1
	beq	.L2593
	adrp	x1, .LANCHOR189
	adrp	x0, .LC0
	mov	w2, 1660
	add	x1, x1, :lo12:.LANCHOR189
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2593:
	ldrh	w0, [x19, 6]
	cmp	w0, 1
	bne	.L2546
	mov	x0, x19
	bl	ftl_write_last_log_page
.L2546:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 368
	ret
.L2566:
	ldrb	w22, [x19, 5]
	adrp	x0, .LANCHOR105
	add	x0, x0, :lo12:.LANCHOR105
	str	x0, [x29, 136]
.L2554:
	ldrb	w0, [x19, 9]
	cmp	w0, w22
	bhi	.L2565
	add	w24, w24, 1
	strb	wzr, [x19, 5]
	and	w24, w24, 65535
	b	.L2553
.L2565:
	add	x0, x19, x22, sxtw 1
	mov	w1, 65535
	ldrh	w0, [x0, 16]
	cmp	w0, w1
	beq	.L2555
	ldr	x1, [x29, 136]
	ldr	x2, [x20, 24]
	ldrh	w1, [x1]
	madd	w0, w1, w0, w24
	ldr	x1, [x20, 8]
	str	w0, [x29, 152]
	adrp	x0, .LANCHOR125
	ldrb	w3, [x0, #:lo12:.LANCHOR125]
	ldr	w0, [x29, 152]
	bl	ftl_read_ppa_page
	mov	w28, w0
	cmp	w0, 512
	beq	.L2556
	cmn	w0, #1
	beq	.L2557
	ldr	x0, [x20, 24]
	ldr	w1, [x0]
	cmn	w1, #1
	bne	.L2557
	ldr	w0, [x0, 4]
	cmn	w0, #1
	bne	.L2557
	ldr	x0, [x20, 8]
	ldr	w0, [x0]
	cmn	w0, #1
	beq	.L2556
.L2557:
	adrp	x0, .LANCHOR185
	mov	w1, 1
	strb	w1, [x0, #:lo12:.LANCHOR185]
	ldrb	w0, [x19, 9]
	ldrh	w1, [x19, 10]
	madd	w0, w0, w24, w22
	cmp	w1, w0
	beq	.L2558
	adrp	x1, .LANCHOR189
	adrp	x0, .LC0
	mov	w2, 1488
	add	x1, x1, :lo12:.LANCHOR189
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2558:
	ldrh	w0, [x19, 10]
	ldrh	w1, [x19, 6]
	ldrb	w2, [x19, 9]
	add	w1, w1, w0
	ldrh	w0, [x25, #:lo12:.LANCHOR87]
	mul	w0, w0, w2
	cmp	w1, w0
	beq	.L2559
	adrp	x1, .LANCHOR189
	adrp	x0, .LC0
	mov	w2, 1489
	add	x1, x1, :lo12:.LANCHOR189
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2559:
	cmn	w28, #1
	beq	.L2561
	ldr	x0, [x20, 24]
	ldr	w0, [x0, 4]
	cmn	w0, #1
	beq	.L2561
	bl	lpa_hash_get_ppa
	ldr	x1, [x29, 144]
	cbz	x1, .L2563
	ldr	x3, [x20, 24]
	ldr	w1, [x3, 8]
	cmp	w0, w1
	beq	.L2563
	cmn	w0, #1
	beq	.L2563
	adrp	x5, .LANCHOR31
	adrp	x6, .LANCHOR68
	mov	w4, 24
	mov	w28, 1
	ldrb	w1, [x5, #:lo12:.LANCHOR31]
	ldrh	w7, [x6, #:lo12:.LANCHOR68]
	sub	w1, w4, w1
	sub	w1, w1, w7
	lsr	w2, w0, w7
	adrp	x7, .LANCHOR69
	lsl	w1, w28, w1
	sub	w1, w1, #1
	and	w1, w1, w2
	ldrb	w2, [x7, #:lo12:.LANCHOR69]
	udiv	w1, w1, w2
	ldr	x2, [x29, 144]
	ldrh	w2, [x2]
	cmp	w2, w1, uxth
	bne	.L2563
	ldr	x1, [x29, 128]
	adrp	x8, .LANCHOR181
	ldr	w10, [x3]
	add	x2, x8, :lo12:.LANCHOR181
	str	w10, [x29, 160]
	str	x8, [x29, 168]
	ldrb	w3, [x1]
	ldr	x1, [x20, 8]
	str	x7, [x29, 96]
	str	w4, [x29, 108]
	stp	x5, x6, [x29, 112]
	bl	ftl_read_ppa_page
	ldr	x8, [x29, 168]
	ldr	w10, [x29, 160]
	ldr	w0, [x8, #:lo12:.LANCHOR181]
	cmp	w10, w0
	bhi	.L2563
	ldr	x0, [x20, 24]
	ldr	w3, [x0, 8]
	cmn	w3, #1
	beq	.L2561
	ldp	x5, x6, [x29, 112]
	ldr	w4, [x29, 108]
	ldr	x7, [x29, 96]
	ldrb	w2, [x5, #:lo12:.LANCHOR31]
	ldrh	w1, [x6, #:lo12:.LANCHOR68]
	sub	w4, w4, w2
	sub	w4, w4, w1
	lsr	w0, w3, w1
	lsl	w28, w28, w4
	sub	w28, w28, #1
	and	w28, w28, w0
	ldrb	w0, [x7, #:lo12:.LANCHOR69]
	udiv	w0, w28, w0
	bl	ftl_vpn_decrement
.L2561:
	ldrh	w0, [x19, 6]
	sub	w0, w0, #1
	strh	w0, [x19, 6]
	ldrh	w0, [x19, 10]
	add	w0, w0, 1
	strh	w0, [x19, 10]
	mov	w0, 4
	str	w0, [x29, 168]
	mov	w0, 1
	str	w0, [x29, 160]
.L2555:
	add	w22, w22, 1
	and	w22, w22, 65535
	b	.L2554
.L2570:
	ldrh	w2, [x19, 12]
	add	w2, w2, w1
	ldr	w2, [x4, x2, lsl 2]
	cmn	w2, #1
	beq	.L2569
	add	w22, w0, 1
	and	w0, w22, 65535
.L2569:
	add	w1, w1, 1
	b	.L2568
.L2585:
	ldr	w0, [x23, x28, lsl 2]
	cmn	w0, #1
	bne	.L2574
.L2578:
	adrp	x1, .LANCHOR104
	ldr	x0, [x20, 24]
	mov	w22, -1
	ldr	x1, [x1, #:lo12:.LANCHOR104]
	ldr	w1, [x1, 8]
	stp	w1, w22, [x0]
	stp	w22, wzr, [x0, 8]
	ldr	x0, [x20, 8]
	str	wzr, [x0]
.L2575:
	ldr	w0, [x29, 160]
	cbz	w0, .L2580
	ldrh	w0, [x19, 6]
	cmp	w0, 1
	bls	.L2580
	add	x0, x21, :lo12:.LANCHOR14
	str	x0, [x29, 144]
	add	x0, x24, :lo12:.LANCHOR125
	str	x0, [x29, 128]
.L2641:
	mov	x0, x19
	bl	ftl_get_new_free_page
	mov	w5, w0
	ldr	x0, [x29, 144]
	ldr	w0, [x0]
	tbz	x0, 14, .L2582
	ldrh	w0, [x19, 12]
	mov	w1, w5
	ldrh	w3, [x19, 10]
	str	w5, [x29, 108]
	add	w3, w3, w0
	ldr	x0, [x20, 24]
	sub	w3, w3, #1
	ldr	w2, [x0, 4]
	ldr	x0, [x29, 120]
	bl	printf
	ldr	w5, [x29, 108]
.L2582:
	ldr	x0, [x29, 112]
	ldr	w2, [x29, 168]
	ldrh	w1, [x19, 6]
	ldrb	w0, [x0]
	mul	w0, w0, w2
	ldr	w2, [x29, 152]
	add	w0, w0, 1
	sub	w0, w0, w2
	cmp	w1, w0
	bls	.L2580
	ldr	x0, [x29, 128]
	ldr	x1, [x20, 8]
	ldr	x2, [x20, 24]
	str	w5, [x29, 96]
	ldrb	w3, [x0]
	mov	w0, w5
	bl	ftl_prog_ppa_page
	mov	w1, w0
	ldrh	w0, [x19]
	str	w1, [x29, 108]
	bl	ftl_vpn_decrement
	ldr	w1, [x29, 108]
	cmn	w22, #1
	ldr	w5, [x29, 96]
	ccmn	w1, #1, 4, ne
	beq	.L2583
	ldrh	w0, [x19, 10]
	ldrh	w1, [x19, 12]
	str	w5, [x26, x28, lsl 2]
	add	w0, w0, w1
	sub	w0, w0, #1
	str	w0, [x27, x28, lsl 2]
.L2580:
	add	x28, x28, 1
	b	.L2573
.L2574:
	ldrb	w3, [x24, #:lo12:.LANCHOR125]
	ldr	x1, [x20, 8]
	ldr	x2, [x20, 24]
	bl	ftl_read_ppa_page
	mov	w22, w0
	ldr	x0, [x20, 24]
	ldr	w0, [x0, 4]
	bl	lpa_hash_get_ppa
	mov	w5, w0
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	tbz	x0, 14, .L2576
	ldr	x0, [x20, 24]
	mov	w1, w5
	ldr	w2, [x23, x28, lsl 2]
	str	w5, [x29, 144]
	ldr	w3, [x0, 4]
	adrp	x0, .LC158
	add	x0, x0, :lo12:.LC158
	bl	printf
	ldr	w5, [x29, 144]
.L2576:
	ldr	w0, [x23, x28, lsl 2]
	mov	w1, 1
	cmp	w5, w0
	ldr	x0, [x20, 24]
	csinv	w22, w22, wzr, eq
	cmn	w22, #1
	stp	w5, w1, [x0, 8]
	bne	.L2575
	b	.L2578
.L2583:
	ldrh	w0, [x19, 6]
	cmp	w0, 1
	bls	.L2580
	cmn	w22, #1
	bne	.L2641
	b	.L2580
.L2592:
	ldr	w0, [x26, x22, lsl 2]
	cmn	w0, #1
	beq	.L2588
	ldrb	w3, [x24, #:lo12:.LANCHOR125]
	ldr	w0, [x23, x22, lsl 2]
	ldr	x1, [x20, 8]
	ldr	x2, [x20, 24]
	bl	ftl_read_ppa_page
	cmp	w0, 256
	ccmn	w0, #1, 4, ne
	bne	.L2588
	ldrb	w3, [x24, #:lo12:.LANCHOR125]
	ldr	w0, [x26, x22, lsl 2]
	ldr	x1, [x20, 8]
	ldr	x2, [x20, 24]
	bl	ftl_read_ppa_page
	mov	w5, w0
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	tbz	x0, 14, .L2590
	ldr	x0, [x20, 24]
	mov	w1, w5
	ldr	w3, [x23, x22, lsl 2]
	str	w5, [x29, 144]
	ldr	w2, [x0, 8]
	mov	x0, x28
	bl	printf
	ldr	w5, [x29, 144]
.L2590:
	cmn	w5, #1
	beq	.L2588
	ldr	x0, [x20, 24]
	ldr	w2, [x23, x22, lsl 2]
	ldr	w1, [x0, 8]
	cmp	w2, w1
	bne	.L2588
	ldr	w1, [x21, #:lo12:.LANCHOR14]
	tbz	x1, 14, .L2591
	ldr	w1, [x0, 4]
	ldr	w3, [x27, x22, lsl 2]
	ldr	x0, [x29, 152]
	bl	printf
.L2591:
	ldr	x0, [x20, 24]
	lsl	x1, x22, 2
	ldrh	w2, [x27, x1]
	ldr	w1, [x0, 8]
	ldr	w0, [x0, 4]
	bl	lpa_hash_update_ppa
.L2588:
	add	x22, x22, 1
	b	.L2586
.L2563:
	ldr	x3, [x20, 24]
	adrp	x0, .LANCHOR122
	ldr	w0, [x0, #:lo12:.LANCHOR122]
	ldr	w1, [x3, 4]
	cmp	w1, w0
	bcs	.L2561
	ldrb	w0, [x19, 9]
	ldrh	w1, [x25, #:lo12:.LANCHOR87]
	ldrh	w2, [x19, 10]
	mul	w0, w0, w1
	sub	w0, w0, #1
	cmp	w2, w0
	bge	.L2561
	adrp	x0, .LANCHOR104
	ldr	w1, [x3]
	ldr	x0, [x0, #:lo12:.LANCHOR104]
	ldr	w4, [x0, 8]
	cmp	w1, w4
	bls	.L2564
	str	w1, [x0, 8]
.L2564:
	ldrh	w0, [x19, 12]
	add	w2, w2, w0
	ldp	w0, w1, [x3, 4]
	bl	lpa_hash_update_ppa
	ldr	w0, [x29, 180]
	str	w0, [x29, 176]
	ldr	w0, [x29, 184]
	str	w0, [x29, 180]
	ldr	w0, [x29, 188]
	str	w0, [x29, 184]
	ldr	w0, [x29, 152]
	str	w0, [x29, 188]
	b	.L2561
	.size	ftl_open_sblk_recovery, .-ftl_open_sblk_recovery
	.section	.text.pm_write_page,"ax",@progbits
	.align	2
	.global	pm_write_page
	.type	pm_write_page, %function
pm_write_page:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w19, w0
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR87
	stp	x23, x24, [sp, 48]
	adrp	x22, .LANCHOR105
	stp	x25, x26, [sp, 64]
	adrp	x23, .LANCHOR104
	mov	x25, x1
	add	x21, x21, :lo12:.LANCHOR87
	mov	x20, x23
	add	x22, x22, :lo12:.LANCHOR105
	mov	w24, 65535
	str	x27, [sp, 80]
.L2668:
	ldr	x0, [x23, #:lo12:.LANCHOR104]
	ldr	w1, [x0, 48]
	ldrh	w2, [x0, 696]
	add	w1, w1, 1
	str	w1, [x0, 48]
	ldrh	w1, [x21]
	cmp	w2, w1
	bcs	.L2669
	ldrh	w0, [x0, 692]
	cmp	w0, w24
	bne	.L2670
.L2669:
	bl	pm_alloc_new_blk
	mov	w0, 0
	bl	ftl_info_flush
.L2670:
	ldr	x0, [x20, #:lo12:.LANCHOR104]
	ldrh	w0, [x0, 692]
	cmp	w0, w24
	bne	.L2671
	adrp	x1, .LANCHOR190
	adrp	x0, .LC0
	mov	w2, 263
	add	x1, x1, :lo12:.LANCHOR190
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2671:
	ldr	x0, [x20, #:lo12:.LANCHOR104]
	adrp	x27, .LANCHOR191
	ldrh	w1, [x22]
	mov	w2, 64
	ldrh	w26, [x0, 692]
	ldrh	w0, [x0, 696]
	madd	w26, w26, w1, w0
	ldr	x0, [x27, #:lo12:.LANCHOR191]
	mov	w1, 0
	bl	ftl_memset
	ldr	x3, [x27, #:lo12:.LANCHOR191]
	mov	x2, x25
	ldr	x0, [x20, #:lo12:.LANCHOR104]
	str	w19, [x3]
	ldr	w1, [x0, 48]
	ldrb	w0, [x0, 694]
	str	w1, [x3, 4]
	adrp	x1, .LANCHOR125
	ldrb	w4, [x1, #:lo12:.LANCHOR125]
	mov	w1, w26
	bl	ftl_prog_page
	ldr	x2, [x20, #:lo12:.LANCHOR104]
	ldrh	w1, [x2, 696]
	add	w1, w1, 1
	and	w1, w1, 65535
	strh	w1, [x2, 696]
	cmp	w1, 1
	adrp	x1, .LANCHOR192
	beq	.L2672
	ldrb	w3, [x1, #:lo12:.LANCHOR192]
	cbz	w3, .L2673
.L2672:
	strb	wzr, [x1, #:lo12:.LANCHOR192]
	b	.L2668
.L2673:
	cmn	w0, #1
	bne	.L2675
	mov	w1, w26
	adrp	x0, .LC161
	add	x0, x0, :lo12:.LC161
	bl	printf
	b	.L2668
.L2675:
	ldrh	w0, [x2, 698]
	cmp	w19, w0
	bcs	.L2676
	add	x19, x2, x19, uxtw 2
	str	w26, [x19, 704]
.L2676:
	mov	w0, 0
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
	.size	pm_write_page, .-pm_write_page
	.section	.text.ftl_dump_write_open_sblk,"ax",@progbits
	.align	2
	.global	ftl_dump_write_open_sblk
	.type	ftl_dump_write_open_sblk, %function
ftl_dump_write_open_sblk:
	sub	sp, sp, #224
	stp	x29, x30, [sp, 48]
	add	x29, sp, 48
	stp	x19, x20, [sp, 64]
	and	w20, w0, 65535
	adrp	x0, .LANCHOR6
	stp	x21, x22, [sp, 80]
	stp	x23, x24, [sp, 96]
	ldrh	w0, [x0, #:lo12:.LANCHOR6]
	stp	x25, x26, [sp, 112]
	stp	x27, x28, [sp, 128]
	cmp	w0, w20
	bls	.L2681
	adrp	x25, .LANCHOR77
	str	x25, [x29, 136]
	ldrb	w0, [x25, #:lo12:.LANCHOR77]
	cbnz	w0, .L2683
	adrp	x0, .LANCHOR74
	ldrb	w0, [x0, #:lo12:.LANCHOR74]
	cbz	w0, .L2681
.L2683:
	adrp	x0, .LANCHOR7
	ubfiz	x14, x20, 2, 16
	mov	x15, x0
	ldr	x1, [x0, #:lo12:.LANCHOR7]
	add	x1, x1, x14
	ldrb	w1, [x1, 2]
	and	w1, w1, 224
	cmp	w1, 160
	bne	.L2703
	adrp	x0, .LANCHOR73
	ldrb	w10, [x0, #:lo12:.LANCHOR73]
.L2684:
	add	x22, x29, 176
	adrp	x23, .LANCHOR87
	str	w10, [x29, 128]
	mov	w0, w20
	mov	w24, 0
	mov	w25, 0
	strh	w20, [x22, -32]!
	mov	w27, 0
	add	x1, x22, 16
	bl	ftl_get_blk_list_in_sblk
	ldrh	w1, [x23, #:lo12:.LANCHOR87]
	and	w0, w0, 255
	strb	w0, [x29, 153]
	strb	wzr, [x29, 149]
	strh	wzr, [x29, 146]
	mul	w0, w0, w1
	strh	wzr, [x29, 154]
	strh	w0, [x29, 150]
	ldr	x0, [x15, #:lo12:.LANCHOR7]
	add	x1, x0, x14
	ldr	w5, [x0, x14]
	ldrb	w2, [x1, 2]
	mov	w1, w20
	ldrh	w4, [x0, x14]
	adrp	x0, .LC162
	ubfx	x5, x5, 11, 8
	add	x0, x0, :lo12:.LC162
	ubfx	x3, x2, 3, 2
	and	w4, w4, 2047
	ubfx	x2, x2, 5, 3
	bl	printf
	mov	w0, 1
	bl	buf_alloc
	mov	x19, x0
	ldr	w10, [x29, 128]
	adrp	x12, .LANCHOR105
	add	x14, x23, :lo12:.LANCHOR87
	add	x12, x12, :lo12:.LANCHOR105
.L2685:
	ldrh	w0, [x14]
	cmp	w0, w25
	bls	.L2691
	lsl	w11, w25, 1
	adrp	x26, .LC163
	sub	w11, w11, #1
	mov	w27, 0
	add	x26, x26, :lo12:.LC163
	b	.L2695
.L2703:
	mov	w10, 1
	b	.L2684
.L2693:
	ldrh	w13, [x22, x28]
	mov	w0, 65535
	cmp	w13, w0
	bne	.L2686
.L2692:
	add	w24, w24, 1
	and	w24, w24, 65535
.L2687:
	cmp	w10, w24
	bcs	.L2693
	add	w27, w27, 1
	and	w27, w27, 65535
.L2695:
	ldrb	w0, [x29, 153]
	cmp	w0, w27
	bls	.L2694
	sxtw	x28, w27
	mov	w24, 1
	add	x28, x28, 8
	lsl	x28, x28, 1
	b	.L2687
.L2686:
	ldrh	w21, [x12]
	cmp	w10, 3
	mul	w21, w21, w13
	bne	.L2688
	add	w21, w25, w21
	orr	w21, w21, w24, lsl 24
.L2689:
	str	w21, [x19, 40]
	mov	w1, 1
	stp	x12, x14, [x29, 96]
	mov	x0, x19
	stp	w11, w10, [x29, 116]
	str	w13, [x29, 124]
	bl	sblk_read_page
	ldr	x1, [x19, 24]
	mov	w3, w21
	ldr	x0, [x19, 8]
	ldr	w15, [x19, 52]
	ldr	w13, [x29, 124]
	ldr	w2, [x1, 12]
	mov	w4, w15
	str	w2, [sp, 32]
	str	w15, [x29, 128]
	ldr	w2, [x1, 8]
	str	w2, [sp, 24]
	ldr	w2, [x1, 4]
	str	w2, [sp, 16]
	mov	w2, w25
	ldr	w1, [x1]
	str	w1, [sp, 8]
	ldr	w1, [x0, 12]
	str	w1, [sp]
	mov	w1, w13
	ldp	w5, w6, [x0]
	ldr	w7, [x0, 8]
	mov	x0, x26
	bl	printf
	ldr	w15, [x29, 128]
	ldp	w11, w10, [x29, 116]
	cmp	w15, 512
	ldp	x12, x14, [x29, 96]
	bne	.L2692
.L2691:
	mov	w4, w24
	mov	w3, w27
	mov	w2, w25
	mov	w1, w20
	adrp	x24, .LANCHOR125
	adrp	x0, .LC164
	add	x0, x0, :lo12:.LC164
	bl	printf
	ldr	x0, [x19, 8]
	mov	w1, 0
	ldrb	w2, [x24, #:lo12:.LANCHOR125]
	adrp	x26, .LC165
	adrp	x27, .LANCHOR73
	add	x26, x26, :lo12:.LC165
	add	x27, x27, :lo12:.LANCHOR73
	lsl	w2, w2, 9
	bl	ftl_memset
	ldr	x0, [x19, 24]
	mov	w1, 0
	ldrb	w2, [x24, #:lo12:.LANCHOR125]
	lsl	w2, w2, 1
	bl	ftl_memset
.L2696:
	ldrh	w0, [x23, #:lo12:.LANCHOR87]
	cmp	w0, w25
	bls	.L2701
	ldr	x0, [x29, 136]
	lsl	w28, w25, 1
	mov	w21, 0
	add	x0, x0, :lo12:.LANCHOR77
	str	x0, [x29, 128]
	b	.L2702
.L2688:
	cmp	w10, 2
	bne	.L2690
	adrp	x0, .LANCHOR73
	add	w21, w21, w11
	add	w21, w21, w24
	ldrb	w3, [x0, #:lo12:.LANCHOR73]
	orr	w21, w21, w3, lsl 24
	b	.L2689
.L2690:
	add	w21, w25, w21
	b	.L2689
.L2694:
	add	w8, w25, 1
	and	w25, w8, 65535
	b	.L2685
.L2700:
	mov	w2, w21
	mov	w1, w25
	mov	x0, x26
	bl	printf
	ldr	x0, [x29, 128]
	adrp	x2, .LANCHOR105
	ldrb	w1, [x0]
	sxtw	x0, w21
	cbz	w1, .L2697
	add	x0, x0, 8
	ldrh	w1, [x2, #:lo12:.LANCHOR105]
	ldrh	w0, [x22, x0, lsl 1]
	mul	w0, w0, w1
	orr	w0, w0, w25
	str	w0, [x19, 40]
	mov	x0, x19
	bl	sblk_3d_tlc_dump_prog
.L2698:
	add	w21, w21, 1
	and	w21, w21, 65535
.L2702:
	ldrb	w0, [x29, 153]
	cmp	w0, w21
	bhi	.L2700
	add	w8, w25, 1
	and	w25, w8, 65535
	b	.L2696
.L2697:
	ldrb	w1, [x27]
	add	x0, x0, 8
	cmp	w1, 2
	bne	.L2699
	ldrh	w0, [x22, x0, lsl 1]
	ldrh	w1, [x2, #:lo12:.LANCHOR105]
	mul	w0, w0, w1
	orr	w0, w0, w28
	orr	w0, w0, 33554432
	str	w0, [x19, 40]
	mov	x0, x19
	bl	sblk_mlc_dump_prog
	b	.L2698
.L2699:
	ldrh	w1, [x22, x0, lsl 1]
	mov	w6, 1
	ldrh	w0, [x2, #:lo12:.LANCHOR105]
	mov	w5, 0
	ldrb	w4, [x24, #:lo12:.LANCHOR125]
	ldr	x3, [x19, 24]
	mul	w1, w1, w0
	adrp	x0, .LANCHOR31
	ldrb	w2, [x0, #:lo12:.LANCHOR31]
	mov	w0, 24
	orr	w1, w1, w25
	str	w1, [x19, 40]
	sub	w0, w0, w2
	lsl	w6, w6, w2
	ldr	x2, [x19, 8]
	sub	w6, w6, #1
	lsl	w7, w6, w0
	lsr	w0, w1, w0
	bic	w1, w1, w7
	and	w0, w0, w6
	bl	flash_prog_page_en
	b	.L2698
.L2701:
	mov	x0, x19
	bl	zbuf_free
	adrp	x0, .LC166
	mov	w1, w20
	add	x0, x0, :lo12:.LC166
	bl	printf
.L2681:
	ldp	x19, x20, [sp, 64]
	ldp	x21, x22, [sp, 80]
	ldp	x23, x24, [sp, 96]
	ldp	x25, x26, [sp, 112]
	ldp	x27, x28, [sp, 128]
	ldp	x29, x30, [sp, 48]
	add	sp, sp, 224
	ret
	.size	ftl_dump_write_open_sblk, .-ftl_dump_write_open_sblk
	.section	.text.ftl_ink_check_sblk,"ax",@progbits
	.align	2
	.global	ftl_ink_check_sblk
	.type	ftl_ink_check_sblk, %function
ftl_ink_check_sblk:
	stp	x29, x30, [sp, -144]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	adrp	x24, .LANCHOR7
	stp	x19, x20, [sp, 16]
	and	w19, w0, 65535
	ldr	x0, [x24, #:lo12:.LANCHOR7]
	ubfiz	x23, x19, 2, 16
	stp	x21, x22, [sp, 32]
	mov	w1, w19
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	ldr	w3, [x0, x23]
	ldrh	w2, [x0, x23]
	adrp	x0, .LC167
	add	x0, x0, :lo12:.LC167
	ubfx	x3, x3, 11, 8
	and	w2, w2, 2047
	bl	printf
	mov	w0, 65535
	cmp	w19, w0
	beq	.L2711
	adrp	x0, .LANCHOR6
	ldrh	w0, [x0, #:lo12:.LANCHOR6]
	cmp	w0, w19
	bls	.L2711
	add	x21, x29, 144
	mov	w1, 0
	mov	w0, w19
	bl	ftl_erase_sblk
	mov	w0, w19
	adrp	x27, .LANCHOR125
	strh	w19, [x21, -32]!
	add	x1, x21, 16
	bl	ftl_get_blk_list_in_sblk
	strb	w0, [x29, 121]
	mov	w0, 1
	bl	buf_alloc
	mov	x20, x0
	ldr	x0, [x24, #:lo12:.LANCHOR7]
	ldrb	w2, [x27, #:lo12:.LANCHOR125]
	ldrh	w0, [x0, x23]
	lsl	w2, w2, 9
	and	w0, w0, 2047
	cmp	w0, 1
	bgt	.L2713
	mov	w1, 85
.L2729:
	ldr	x0, [x20, 8]
	adrp	x28, .LANCHOR105
	add	x28, x28, :lo12:.LANCHOR105
	mov	w26, 0
	bl	ftl_memset
	bl	sblk_wait_write_queue_completed
	mov	w7, 65280
	movk	w7, 0x55aa, lsl 16
.L2715:
	adrp	x25, .LANCHOR87
	ldrh	w0, [x25, #:lo12:.LANCHOR87]
	cmp	w0, w26
	bls	.L2718
	adrp	x25, .LANCHOR31
	mov	w22, 0
	add	x25, x25, :lo12:.LANCHOR31
	b	.L2719
.L2713:
	mov	w1, 170
	b	.L2729
.L2717:
	add	x0, x21, x22, sxtw 1
	mov	w1, 65535
	ldrh	w0, [x0, 16]
	cmp	w0, w1
	beq	.L2716
	ldrh	w1, [x28]
	mov	w6, 1
	ldr	x2, [x20, 8]
	mov	w5, 0
	ldr	x3, [x20, 24]
	str	w7, [x29, 108]
	madd	w1, w1, w0, w26
	mov	w0, 24
	stp	w1, w7, [x2]
	str	wzr, [x3]
	ldrb	w4, [x25]
	sub	w0, w0, w4
	lsl	w6, w6, w4
	ldrb	w4, [x27, #:lo12:.LANCHOR125]
	sub	w6, w6, #1
	lsl	w8, w6, w0
	lsr	w0, w1, w0
	bic	w1, w1, w8
	and	w0, w0, w6
	bl	flash_prog_page_en
	ldr	w7, [x29, 108]
.L2716:
	add	w22, w22, 1
	and	w22, w22, 65535
.L2719:
	ldrb	w0, [x29, 121]
	cmp	w0, w22
	bhi	.L2717
	add	w26, w26, 1
	and	w26, w26, 65535
	b	.L2715
.L2718:
	adrp	x26, .LANCHOR105
	add	x26, x26, :lo12:.LANCHOR105
	mov	w28, 0
.L2720:
	ldrh	w0, [x25, #:lo12:.LANCHOR87]
	cmp	w0, w28
	bls	.L2725
	mov	w27, 0
	b	.L2726
.L2724:
	sxtw	x22, w27
	mov	w1, 65535
	add	x22, x22, 8
	lsl	x22, x22, 1
	ldrh	w0, [x21, x22]
	cmp	w0, w1
	beq	.L2722
	ldrh	w4, [x26]
	mov	w1, 1
	madd	w4, w4, w0, w28
	mov	x0, x20
	str	w4, [x20, 40]
	str	w4, [x29, 108]
	bl	sblk_read_page
	ldr	x0, [x20, 8]
	ldr	w4, [x29, 108]
	ldr	w0, [x0]
	cmp	w4, w0
	beq	.L2722
	mov	w0, w4
	bl	ftl_mask_bad_block
	mov	w0, -1
	strh	w0, [x21, x22]
.L2722:
	add	w2, w27, 1
	and	w27, w2, 65535
.L2726:
	ldrb	w0, [x29, 121]
	cmp	w0, w27
	bhi	.L2724
	add	w3, w28, 1
	and	w28, w3, 65535
	b	.L2720
.L2725:
	mov	x0, x20
	bl	zbuf_free
	ldr	x0, [x24, #:lo12:.LANCHOR7]
	mov	w1, w19
	ldr	w3, [x0, x23]
	ldrh	w2, [x0, x23]
	adrp	x0, .LC168
	add	x0, x0, :lo12:.LC168
	ubfx	x3, x3, 11, 8
	and	w2, w2, 2047
	bl	printf
.L2711:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	ret
	.size	ftl_ink_check_sblk, .-ftl_ink_check_sblk
	.section	.text.ftl_open_sblk_init,"ax",@progbits
	.align	2
	.global	ftl_open_sblk_init
	.type	ftl_open_sblk_init, %function
ftl_open_sblk_init:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR80
	stp	x23, x24, [sp, 48]
	adrp	x22, .LC77
	stp	x19, x20, [sp, 16]
	adrp	x24, .LANCHOR87
	mov	x19, x0
	mov	w23, w1
	add	x24, x24, :lo12:.LANCHOR87
	add	x21, x21, :lo12:.LANCHOR80
	add	x22, x22, :lo12:.LC77
	stp	x25, x26, [sp, 64]
.L2731:
.L2735:
	mov	w0, w23
	bl	ftl_alloc_sblk
	adrp	x1, .LANCHOR104
	and	w25, w0, 65535
	mov	w26, w25
	uxtw	x20, w25
	ldr	x1, [x1, #:lo12:.LANCHOR104]
	ldrh	w1, [x1, 150]
	cbz	w1, .L2732
	adrp	x2, .LANCHOR7
	lsl	x1, x20, 2
	ldr	x2, [x2, #:lo12:.LANCHOR7]
	ldrh	w1, [x2, x1]
	and	w1, w1, 2047
	cmp	w1, 2
	bgt	.L2732
	bl	ftl_ink_check_sblk
.L2732:
	mov	w1, 0
	mov	w0, w26
	bl	ftl_erase_sblk
	add	x1, x19, 16
	mov	w0, w26
	bl	ftl_get_blk_list_in_sblk
	and	w0, w0, 255
	ldrh	w1, [x24]
	cmp	w23, 2
	strb	w0, [x19, 9]
	strh	w26, [x19]
	strh	wzr, [x19, 2]
	mul	w0, w1, w0
	strb	wzr, [x19, 5]
	strh	w0, [x19, 6]
	strh	wzr, [x19, 10]
	strb	w23, [x19, 4]
	beq	.L2736
	ldrb	w0, [x21]
	mul	w0, w1, w0
	and	w0, w0, 65535
.L2733:
	ldrb	w2, [x21]
	adrp	x26, .LANCHOR9
	strh	w0, [x19, 12]
	lsl	x20, x20, 1
	mul	w2, w2, w1
	adrp	x1, .LANCHOR111
	ldr	x3, [x1, #:lo12:.LANCHOR111]
	mov	w1, 255
	lsl	w2, w2, 2
	add	x0, x3, x0, uxth 2
	bl	ftl_memset
	ldr	x0, [x26, #:lo12:.LANCHOR9]
	ldrh	w1, [x19, 6]
	strh	w1, [x0, x20]
	ldrb	w0, [x19, 9]
	cbnz	w0, .L2730
	mov	w1, w25
	mov	x0, x22
	bl	printf
	ldr	x0, [x26, #:lo12:.LANCHOR9]
	mov	w1, -1
	strh	w1, [x0, x20]
	mov	w0, 7
	strb	w0, [x19, 4]
	b	.L2735
.L2736:
	mov	w0, 0
	b	.L2733
.L2730:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
	.size	ftl_open_sblk_init, .-ftl_open_sblk_init
	.section	.text.ftl_low_format_data_init,"ax",@progbits
	.align	2
	.global	ftl_low_format_data_init
	.type	ftl_low_format_data_init, %function
ftl_low_format_data_init:
	stp	x29, x30, [sp, -48]!
	mov	w2, 16384
	mov	w1, 0
	adrp	x0, ftl_ext_info_data_buffer
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	add	x0, x0, :lo12:ftl_ext_info_data_buffer
	str	x21, [sp, 32]
	bl	ftl_memset
	bl	zftl_sblk_list_init
	adrp	x19, .LANCHOR104
	mov	w0, 1
	bl	ftl_alloc_sblk
	mov	w1, 0
	mov	w21, w0
	bl	ftl_erase_sblk
	ldr	x1, [x19, #:lo12:.LANCHOR104]
	mov	w0, w21
	add	x1, x1, 672
	bl	ftl_get_blk_list_in_sblk
	ldr	x0, [x19, #:lo12:.LANCHOR104]
	ldrh	w20, [x0, 672]
	strh	wzr, [x0, 690]
	mov	w0, 65533
	sub	w1, w20, #1
	cmp	w0, w1, uxth
	bcs	.L2742
	adrp	x1, .LANCHOR193
	adrp	x0, .LC0
	mov	w2, 2146
	add	x1, x1, :lo12:.LANCHOR193
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2742:
	ldr	x0, [x19, #:lo12:.LANCHOR104]
	mov	w2, 256
	mov	w1, 255
	add	x0, x0, 416
	strh	wzr, [x0, 280]
	bl	ftl_memset
	ldr	x0, [x19, #:lo12:.LANCHOR104]
	mov	w2, 4096
	mov	w1, 0
	add	x0, x0, 704
	bl	ftl_memset
	adrp	x0, .LANCHOR31
	ldr	x1, [x19, #:lo12:.LANCHOR104]
	ldrb	w2, [x0, #:lo12:.LANCHOR31]
	mov	w0, 24
	sub	w0, w0, w2
	adrp	x2, .LANCHOR68
	strh	w21, [x1, 416]
	adrp	x21, .LANCHOR10
	ldrh	w2, [x2, #:lo12:.LANCHOR68]
	strh	w20, [x1, 692]
	sub	w0, w0, w2
	asr	w0, w20, w0
	strh	w0, [x1, 694]
	mov	w0, 1
	strh	w0, [x1, 688]
	adrp	x0, .LANCHOR194
	ldrh	w0, [x0, #:lo12:.LANCHOR194]
	strh	w0, [x1, 698]
	mov	w1, 20038
	ldr	x0, [x21, #:lo12:.LANCHOR10]
	movk	w1, 0x4549, lsl 16
	str	w1, [x0]
	bl	ftl_alloc_sys_blk
	mov	w20, w0
	mov	w1, 0
	bl	ftl_erase_phy_blk
	ldr	x0, [x19, #:lo12:.LANCHOR104]
	mov	w1, 2
	strh	w20, [x0, 130]
	mov	w20, -1
	strh	wzr, [x0, 140]
	ldr	x0, [x21, #:lo12:.LANCHOR10]
	add	x0, x0, 16
	strh	w20, [x0, 568]
	strh	w20, [x0, 570]
	strh	w20, [x0, 572]
	strh	w20, [x0, 574]
	bl	ftl_open_sblk_init
	ldr	x0, [x21, #:lo12:.LANCHOR10]
	mov	w1, 3
	add	x0, x0, 48
	bl	ftl_open_sblk_init
	ldr	x1, [x19, #:lo12:.LANCHOR104]
	ldr	x0, [x21, #:lo12:.LANCHOR10]
	add	x0, x0, 136
	ldrh	w2, [x1, 134]
	strh	w2, [x0, -10]
	strh	w20, [x0, -56]
	mov	w2, -1
	strh	w20, [x0, -6]
	str	w2, [x0, 408]
	strh	wzr, [x0, -12]
	strh	wzr, [x0, -16]
	strh	wzr, [x0, -14]
	strh	w2, [x1, 126]
	mov	w2, 256
	str	wzr, [x0, 384]
	mov	w1, 255
	str	wzr, [x0, 388]
	str	wzr, [x0, 392]
	bl	ftl_memset
	mov	w2, 128
	mov	w1, 255
	ldr	x0, [x21, #:lo12:.LANCHOR10]
	add	x0, x0, 392
	bl	ftl_memset
	bl	ftl_ext_info_flush
	mov	w0, 0
	bl	ftl_info_flush
	bl	ftl_info_blk_init
	ldr	x21, [sp, 32]
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
	.size	ftl_low_format_data_init, .-ftl_low_format_data_init
	.section	.text.ftl_low_format,"ax",@progbits
	.align	2
	.global	ftl_low_format
	.type	ftl_low_format, %function
ftl_low_format:
	stp	x29, x30, [sp, -80]!
	mov	w1, 0
	adrp	x0, .LC169
	add	x0, x0, :lo12:.LC169
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR195
	stp	x21, x22, [sp, 32]
	add	x20, x20, :lo12:.LANCHOR195
	stp	x25, x26, [sp, 64]
	adrp	x22, .LANCHOR27
	mov	x25, x22
	stp	x23, x24, [sp, 48]
	mov	w19, 8
	adrp	x23, .LC0
	bl	printf
.L2747:
	ldr	x0, [x22, #:lo12:.LANCHOR27]
	add	x0, x0, x19, sxtw
	ldrb	w21, [x0, 32]
	add	w0, w21, 127
	and	w0, w0, 255
	cmp	w0, 125
	bhi	.L2745
	mov	w2, 2200
	mov	x1, x20
	add	x0, x23, :lo12:.LC0
	bl	printf
.L2745:
	cmp	w21, 255
	beq	.L2746
	adrp	x0, .LANCHOR105
	ldrh	w1, [x0, #:lo12:.LANCHOR105]
	mov	w0, 0
	mul	w1, w1, w21
	bl	flash_erase_block
.L2746:
	add	w19, w19, 1
	cmp	w19, 16
	bne	.L2747
	bl	sblk_init
	adrp	x22, .LANCHOR7
	bl	ftl_info_blk_init
	adrp	x19, .LANCHOR6
	mov	w2, 16384
	mov	w1, 0
	adrp	x0, ftl_info_data_buffer
	add	x0, x0, :lo12:ftl_info_data_buffer
	bl	ftl_memset
	ldr	x0, [x22, #:lo12:.LANCHOR7]
	mov	w3, 1
	ldrh	w2, [x19, #:lo12:.LANCHOR6]
	add	x2, x0, x2, lsl 2
.L2748:
	cmp	x0, x2
	bne	.L2749
	adrp	x21, .LANCHOR104
	mov	w1, 21574
	adrp	x24, .LANCHOR62
	add	x24, x24, :lo12:.LANCHOR62
	ldr	x0, [x21, #:lo12:.LANCHOR104]
	movk	w1, 0x494c, lsl 16
	mov	w20, 0
	mov	w26, 1
	strh	wzr, [x0, 148]
	str	w1, [x0]
.L2750:
	ldrh	w0, [x19, #:lo12:.LANCHOR6]
	adrp	x23, .LANCHOR69
	cmp	w0, w20
	bhi	.L2759
	ldr	x0, [x25, #:lo12:.LANCHOR27]
	mov	w4, 3
	ldrb	w2, [x23, #:lo12:.LANCHOR69]
	mov	w10, 15
	ldr	x6, [x21, #:lo12:.LANCHOR104]
	cmp	w2, 1
	ldr	x1, [x22, #:lo12:.LANCHOR7]
	ldrb	w0, [x0, 47]
	csinc	w4, w4, wzr, ne
	and	w4, w4, 255
	and	w8, w2, 65535
	ldrh	w3, [x6, 148]
	udiv	w0, w0, w2
	and	w5, w0, 65535
	ubfiz	x0, x0, 2, 8
	add	x0, x0, 4
	add	w20, w5, 1
	add	x0, x1, x0
.L2762:
	cmp	w2, 4
	add	x1, x1, 4
	csel	w7, w10, w4, eq
	strb	w7, [x1, -1]
	ldrb	w7, [x1, -2]
	orr	w7, w7, -32
	strb	w7, [x1, -2]
	cmp	x1, x0
	bne	.L2762
	mul	w5, w5, w8
	mov	w4, 16
	add	w0, w8, w3
	sdiv	w4, w4, w2
	add	w0, w5, w0, uxth
	strh	w0, [x6, 148]
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	add	w4, w20, w4
	and	w4, w4, 65535
	strh	w4, [x6, 134]
	tbz	x0, 12, .L2763
	adrp	x0, .LC170
	mov	w3, w20
	mov	w2, 128
	mov	w1, 2247
	add	x0, x0, :lo12:.LC170
	bl	printf
.L2763:
	ldr	x0, [x21, #:lo12:.LANCHOR104]
	mov	w2, 128
	mov	w1, 255
	add	x0, x0, 160
	bl	ftl_memset
	adrp	x0, .LANCHOR106
	ldrb	w10, [x23, #:lo12:.LANCHOR69]
	adrp	x3, .LANCHOR68
	ldr	x2, [x21, #:lo12:.LANCHOR104]
	ldrb	w16, [x0, #:lo12:.LANCHOR106]
	adrp	x0, .LANCHOR31
	and	w11, w10, 65535
	ldr	x15, [x22, #:lo12:.LANCHOR7]
	ldrb	w4, [x0, #:lo12:.LANCHOR31]
	mov	w0, 24
	ldrh	w8, [x2, 134]
	sub	w0, w0, w4
	ldrh	w4, [x3, #:lo12:.LANCHOR68]
	mul	w1, w20, w11
	mov	w3, 0
	sub	w0, w0, w4
	mov	w4, 1
	and	w1, w1, 65535
	lsl	w4, w4, w0
	and	w4, w4, 65535
.L2764:
	cmp	w20, w8
	bcc	.L2770
	ldrh	w0, [x19, #:lo12:.LANCHOR6]
	strh	w3, [x2, 112]
	sub	w0, w0, w8
	strh	wzr, [x2, 114]
	strh	w0, [x2, 116]
	strh	wzr, [x2, 118]
	strh	w8, [x2, 132]
	bl	ftl_low_format_data_init
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L2749:
	ldrb	w1, [x0, 2]
	add	x0, x0, 4
	and	w1, w1, 31
	bfi	w1, w3, 3, 2
	strb	w1, [x0, -2]
	b	.L2748
.L2759:
	adrp	x0, .LANCHOR75
	strh	w20, [x24]
	ldrb	w0, [x0, #:lo12:.LANCHOR75]
	cbnz	w0, .L2751
	mov	w0, w20
	bl	ftl_test_block
.L2751:
	ldrb	w11, [x23, #:lo12:.LANCHOR69]
	adrp	x0, .LANCHOR106
	ldr	x6, [x22, #:lo12:.LANCHOR7]
	mov	w7, 0
	ldrb	w14, [x0, #:lo12:.LANCHOR106]
	mov	w10, 0
	ldr	x13, [x21, #:lo12:.LANCHOR104]
	mov	w8, 0
	mul	w12, w20, w11
	add	x6, x6, x20, uxth 2
.L2752:
	cmp	w8, w14
	bcs	.L2756
	add	w15, w11, w7
	b	.L2757
.L2755:
	add	w1, w7, w12
	mov	w0, w8
	bl	flash_check_bad_block
	cbz	w0, .L2753
	ldrb	w1, [x6, 3]
	lsl	w0, w26, w7
	orr	w0, w0, w1
	strb	w0, [x6, 3]
	ldrh	w0, [x13, 148]
	add	w0, w0, 1
	strh	w0, [x13, 148]
.L2754:
	add	w7, w7, 1
.L2757:
	cmp	w7, w15
	bne	.L2755
	add	w8, w8, 1
	sub	w12, w12, w11
	and	w8, w8, 65535
	b	.L2752
.L2753:
	add	w10, w10, 1
	and	w10, w10, 65535
	b	.L2754
.L2756:
	cbnz	w10, .L2758
	ldrb	w0, [x6, 2]
	orr	w0, w0, -32
	strb	w0, [x6, 2]
.L2758:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L2750
.L2770:
	add	x13, x15, x20, uxth 2
	mov	w6, 0
	mov	w12, 0
	mov	w5, 0
	ldrb	w0, [x13, 2]
	orr	w0, w0, -32
	strb	w0, [x13, 2]
.L2765:
	cmp	w5, w16
	bcc	.L2772
	add	w20, w20, 1
	add	w1, w1, w11
	and	w20, w20, 65535
	and	w1, w1, 65535
	b	.L2764
.L2768:
	ldrb	w14, [x13, 3]
	add	w17, w12, w7
	asr	w14, w14, w17
	tbnz	x14, 0, .L2766
	cmp	w10, 1
	bls	.L2771
	and	w0, w0, 1
	add	w0, w1, w0
	and	w0, w0, 65535
.L2767:
	add	x14, x2, x3, sxtw 1
	add	w3, w3, 1
	and	w3, w3, 65535
	add	w0, w0, w6
	strh	w0, [x14, 160]
.L2766:
	add	x7, x7, 1
.L2769:
	and	w0, w7, 65535
	cmp	w0, w11
	bcc	.L2768
	add	w5, w5, 1
	add	w6, w4, w6
	and	w5, w5, 65535
	add	w12, w12, w10
	and	w6, w6, 65535
	b	.L2765
.L2771:
	mov	w0, w1
	b	.L2767
.L2772:
	mov	x7, 0
	b	.L2769
	.size	ftl_low_format, .-ftl_low_format
	.section	.text.ftl_re_low_format,"ax",@progbits
	.align	2
	.global	ftl_re_low_format
	.type	ftl_re_low_format, %function
ftl_re_low_format:
	stp	x29, x30, [sp, -16]!
	mov	w1, 1
	adrp	x0, .LC171
	add	x0, x0, :lo12:.LC171
	add	x29, sp, 0
	bl	printf
	bl	sblk_init
	bl	ftl_info_blk_init
	bl	ftl_ext_info_init
	adrp	x0, .LANCHOR104
	adrp	x2, .LANCHOR6
	mov	w3, 0
	mov	w4, 0
	ldr	x0, [x0, #:lo12:.LANCHOR104]
	mov	w5, 0
	ldrh	w7, [x2, #:lo12:.LANCHOR6]
	adrp	x2, .LANCHOR7
	ldr	x2, [x2, #:lo12:.LANCHOR7]
	ldrh	w1, [x0, 134]
	add	x2, x2, x1, uxth 2
.L2783:
	cmp	w1, w7
	bcc	.L2787
	strh	w5, [x0, 114]
	strh	w4, [x0, 118]
	strh	w3, [x0, 116]
	strh	wzr, [x0, 122]
	strh	wzr, [x0, 120]
	strh	wzr, [x0, 124]
	bl	ftl_low_format_data_init
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
.L2787:
	ldrb	w6, [x2, 2]
	and	w8, w6, 31
	strb	w8, [x2, 2]
	ands	w6, w6, 24
	bne	.L2784
	add	w5, w5, 1
	and	w5, w5, 65535
.L2785:
	add	w1, w1, 1
	add	x2, x2, 4
	and	w1, w1, 65535
	b	.L2783
.L2784:
	cmp	w6, 16
	bne	.L2786
	add	w4, w4, 1
	and	w4, w4, 65535
	b	.L2785
.L2786:
	add	w3, w3, 1
	and	w3, w3, 65535
	b	.L2785
	.size	ftl_re_low_format, .-ftl_re_low_format
	.section	.text.flash_info_flush,"ax",@progbits
	.align	2
	.global	flash_info_flush
	.type	flash_info_flush, %function
flash_info_flush:
	stp	x29, x30, [sp, -112]!
	adrp	x0, .LANCHOR14
	add	x29, sp, 0
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	tbz	x0, 12, .L2790
	adrp	x2, .LANCHOR196
	adrp	x0, .LC92
	add	x2, x2, :lo12:.LANCHOR196
	mov	w1, 324
	add	x0, x0, :lo12:.LC92
	bl	printf
.L2790:
	adrp	x23, .LANCHOR197
	adrp	x20, .LANCHOR27
	mov	w2, 64
	mov	w1, 0
	ldr	x0, [x23, #:lo12:.LANCHOR197]
	adrp	x21, .LANCHOR198
	adrp	x22, .LANCHOR2
	adrp	x24, .LC173
	adrp	x25, .LANCHOR142
	add	x22, x22, :lo12:.LANCHOR2
	add	x24, x24, :lo12:.LC173
	add	x25, x25, :lo12:.LANCHOR142
	bl	ftl_memset
	add	x27, x21, :lo12:.LANCHOR198
	ldr	x1, [x20, #:lo12:.LANCHOR27]
	mov	w3, 16
	mov	w2, 4
	adrp	x0, .LC172
	add	x0, x0, :lo12:.LC172
	mov	w26, 0
	bl	rknand_print_hex
	ldr	x6, [x20, #:lo12:.LANCHOR27]
	add	x0, x6, 16
	ldr	w1, [x6, 8]
	bl	js_hash
	str	w0, [x6, 12]
.L2791:
	add	x28, x21, :lo12:.LANCHOR198
	ldrb	w4, [x21, #:lo12:.LANCHOR198]
	ldrh	w19, [x22]
	mov	x0, x24
	mov	w1, w4
	ldrh	w3, [x28, 2]
	stp	w3, w4, [x29, 104]
	mov	w2, w3
	bl	printf
	ldrh	w0, [x25]
	ldrh	w1, [x28, 2]
	sub	w0, w0, #1
	cmp	w1, w0
	ldp	w3, w4, [x29, 104]
	blt	.L2792
	ldr	x6, [x20, #:lo12:.LANCHOR27]
	ldrb	w7, [x28, 1]
	strh	wzr, [x28, 2]
	ldr	w0, [x6, 4]
	ldrh	w1, [x6, 16]
	add	w0, w0, 1
	str	w0, [x6, 4]
	ldrb	w0, [x21, #:lo12:.LANCHOR198]
	add	w1, w1, 1
	strb	w0, [x28, 1]
	mov	x0, x6
	strb	w7, [x21, #:lo12:.LANCHOR198]
	strh	w1, [x0, 16]!
	ldr	w1, [x6, 8]
	bl	js_hash
	ldrh	w19, [x22]
	str	w0, [x6, 12]
	mul	w19, w19, w7
.L2801:
	mov	w1, w19
	mov	w0, 0
	bl	flash_erase_block
	b	.L2793
.L2796:
	mov	w26, 1
	b	.L2791
.L2792:
	madd	w19, w19, w4, w3
	cbz	w1, .L2801
.L2793:
	ldr	x2, [x20, #:lo12:.LANCHOR27]
	mov	w1, w19
	ldr	x3, [x23, #:lo12:.LANCHOR197]
	mov	w5, 1
	mov	w4, 4
	ldr	w0, [x2, 4]
	str	w0, [x3]
	mov	w0, 21321
	movk	w0, 0x5359, lsl 16
	str	w0, [x3, 4]
	mov	w0, 0
	bl	flash_prog_page_en
	cmn	w0, #1
	ldrh	w1, [x27, 2]
	add	w1, w1, 1
	strh	w1, [x27, 2]
	bne	.L2794
	mov	w1, w19
	adrp	x0, .LC174
	add	x0, x0, :lo12:.LC174
	bl	printf
	b	.L2791
.L2794:
	cbz	w26, .L2796
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
	.size	flash_info_flush, .-flash_info_flush
	.section	.text.flash_info_blk_init,"ax",@progbits
	.align	2
	.global	flash_info_blk_init
	.type	flash_info_blk_init, %function
flash_info_blk_init:
	stp	x29, x30, [sp, -96]!
	adrp	x0, .LANCHOR14
	add	x29, sp, 0
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR27
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	str	x27, [sp, 80]
	tbz	x0, 12, .L2803
	ldr	x4, [x20, #:lo12:.LANCHOR27]
	adrp	x2, .LANCHOR199
	adrp	x0, .LC175
	mov	w3, 2048
	add	x2, x2, :lo12:.LANCHOR199
	mov	w1, 50
	add	x0, x0, :lo12:.LC175
	bl	printf
.L2803:
	adrp	x21, .LANCHOR197
	adrp	x24, .LANCHOR2
	mov	w22, 21321
	add	x26, x24, :lo12:.LANCHOR2
	mov	x23, x21
	mov	w19, 4
	movk	w22, 0x5359, lsl 16
.L2806:
	ldrh	w1, [x26]
	mov	w4, 4
	ldr	x3, [x21, #:lo12:.LANCHOR197]
	mov	w0, 0
	ldr	x2, [x20, #:lo12:.LANCHOR27]
	add	x27, x21, :lo12:.LANCHOR197
	add	x25, x20, :lo12:.LANCHOR27
	mul	w1, w1, w19
	bl	flash_read_page_en
	cmn	w0, #1
	beq	.L2804
	ldr	x2, [x20, #:lo12:.LANCHOR27]
	ldr	w0, [x2]
	cmp	w0, w22
	beq	.L2805
.L2804:
	add	w19, w19, 1
	cmp	w19, 16
	bne	.L2806
.L2831:
	mov	w0, -1
.L2802:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L2814:
	ldr	x0, [x25]
	ldr	w1, [x0]
	cmp	w1, w22
	bne	.L2815
	ldr	w21, [x0, 4]
.L2808:
	add	x22, x19, :lo12:.LANCHOR198
	ldrh	w0, [x24, #:lo12:.LANCHOR2]
	ldr	x3, [x23, #:lo12:.LANCHOR197]
	mov	w4, 4
	ldr	x2, [x20, #:lo12:.LANCHOR27]
	ldrb	w1, [x22, 1]
	mul	w1, w1, w0
	mov	w0, 0
	bl	flash_read_page_en
	cmn	w0, #1
	beq	.L2809
	ldr	x0, [x20, #:lo12:.LANCHOR27]
	mov	w1, 21321
	movk	w1, 0x5359, lsl 16
	ldr	w2, [x0]
	cmp	w2, w1
	bne	.L2809
	ldr	w1, [x0, 4]
	cmp	w21, w1
	bcs	.L2809
	ldrb	w1, [x0, 37]
	ldrb	w0, [x0, 36]
	strb	w1, [x19, #:lo12:.LANCHOR198]
	strb	w0, [x22, 1]
.L2809:
	ldrb	w1, [x19, #:lo12:.LANCHOR198]
	add	x21, x19, :lo12:.LANCHOR198
	ldr	x3, [x23, #:lo12:.LANCHOR197]
	mov	w4, 4
	ldr	x2, [x20, #:lo12:.LANCHOR27]
	mov	w0, 0
	bl	flash_get_last_written_page
	and	w25, w0, 65535
	add	w1, w25, 1
	ldrb	w22, [x19, #:lo12:.LANCHOR198]
	strh	w1, [x21, 2]
	mov	w21, 0
	ldrh	w1, [x24, #:lo12:.LANCHOR2]
	mov	w24, 21321
	movk	w24, 0x5359, lsl 16
	mul	w22, w22, w1
	add	w22, w22, w0, sxth
.L2810:
	sub	w0, w25, w21
	sxth	w19, w0
	tbz	w19, #31, .L2813
	cmn	w19, #1
	bne	.L2812
	ldr	x0, [x20, #:lo12:.LANCHOR27]
	ldr	w1, [x0]
	adrp	x0, .LC176
	add	x0, x0, :lo12:.LC176
	bl	printf
	b	.L2831
.L2813:
	ldr	x3, [x23, #:lo12:.LANCHOR197]
	mov	w4, 4
	ldr	x2, [x20, #:lo12:.LANCHOR27]
	sub	w1, w22, w21
	mov	w0, 0
	bl	flash_read_page_en
	cmn	w0, #1
	beq	.L2811
	ldr	x0, [x20, #:lo12:.LANCHOR27]
	ldr	w0, [x0]
	cmp	w0, w24
	beq	.L2812
.L2811:
	add	w21, w21, 1
	b	.L2810
.L2812:
	cmp	w21, 1
	bls	.L2816
	bl	flash_info_flush
.L2816:
	mov	w0, 0
	b	.L2802
.L2805:
	adrp	x19, .LANCHOR198
	add	x1, x19, :lo12:.LANCHOR198
	ldrb	w3, [x2, 37]
	mov	w4, 4
	ldrb	w0, [x2, 36]
	strb	w3, [x1, 1]
	ldrh	w1, [x26]
	ldr	x3, [x27]
	strb	w0, [x19, #:lo12:.LANCHOR198]
	mul	w1, w1, w0
	mov	w0, 0
	bl	flash_read_page_en
	cmn	w0, #1
	bne	.L2814
.L2815:
	mov	w21, 0
	b	.L2808
	.size	flash_info_blk_init, .-flash_info_blk_init
	.section	.text.nand_flash_init,"ax",@progbits
	.align	2
	.global	nand_flash_init
	.type	nand_flash_init, %function
nand_flash_init:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR14
	mov	x19, x0
	stp	x21, x22, [sp, 32]
	ldr	w0, [x20, #:lo12:.LANCHOR14]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	str	x27, [sp, 80]
	tbz	x0, 12, .L2833
	adrp	x2, .LANCHOR200
	adrp	x0, .LC92
	add	x2, x2, :lo12:.LANCHOR200
	mov	w1, 2578
	add	x0, x0, :lo12:.LC92
	bl	printf
.L2833:
	adrp	x0, .LANCHOR163
	adrp	x23, .LANCHOR16
	adrp	x22, .LANCHOR44
	add	x25, x22, :lo12:.LANCHOR44
	str	wzr, [x0, #:lo12:.LANCHOR163]
	mov	x0, x19
	bl	nandc_init
	adrp	x19, .LANCHOR32
	add	x0, x19, :lo12:.LANCHOR32
	str	x0, [x23, #:lo12:.LANCHOR16]
	adrp	x0, .LANCHOR18
	adrp	x24, .LANCHOR31
	mov	x26, x25
	mov	w1, 1
	mov	w21, 0
	strb	w1, [x0, #:lo12:.LANCHOR18]
	mov	w27, 44
	mov	w0, 3
	mov	w2, 8
	strb	w0, [x24, #:lo12:.LANCHOR31]
	mov	w1, 0
	adrp	x0, .LANCHOR30
	add	x0, x0, :lo12:.LANCHOR30
	bl	ftl_memset
	mov	w2, 32
	mov	w1, 0
	adrp	x0, .LANCHOR143
	add	x0, x0, :lo12:.LANCHOR143
	bl	ftl_memset
.L2839:
	mov	x1, x25
	mov	w0, w21
	bl	flash_read_id
	cbnz	w21, .L2834
	ldrb	w0, [x26]
	sub	w0, w0, #1
	and	w0, w0, 255
	cmp	w0, 253
	bls	.L2835
.L2837:
	mov	w19, -2
.L2832:
	mov	w0, w19
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L2835:
	ldrb	w0, [x26, 1]
	cmp	w0, 255
	beq	.L2837
.L2834:
	ldrb	w0, [x25]
	cmp	w0, 181
	bne	.L2838
	strb	w27, [x25]
.L2838:
	add	w21, w21, 1
	add	x25, x25, 8
	and	w21, w21, 255
	cmp	w21, 4
	bne	.L2839
	adrp	x0, .LANCHOR201
	add	x8, x0, :lo12:.LANCHOR201
	add	x8, x8, 1
	mov	x7, x0
	add	x12, x22, :lo12:.LANCHOR44
	mov	x10, 0
.L2842:
	ldrb	w2, [x8, -1]
	mov	w11, w10
	lsl	x25, x10, 5
	mov	x1, x12
	mov	x0, x8
	bl	flash_mem_cmp8
	cbnz	w0, .L2840
	add	x0, x7, :lo12:.LANCHOR201
	ubfiz	x11, x11, 5, 32
	add	x25, x0, x25
	add	x0, x0, x11
	adrp	x1, .LANCHOR202
	add	x4, x1, :lo12:.LANCHOR202
	ldrb	w3, [x0, 22]
	mov	x0, 0
.L2841:
	lsl	x5, x0, 5
	mov	w2, w0
	ldrb	w5, [x5, x4]
	cmp	w5, w3
	beq	.L2843
	add	x0, x0, 1
	cmp	x0, 4
	bne	.L2841
	mov	w2, w0
.L2843:
	ubfiz	x0, x2, 5, 32
	add	x1, x1, :lo12:.LANCHOR202
	add	x1, x1, x0
	mov	w2, 32
	adrp	x0, .LANCHOR20
	add	x0, x0, :lo12:.LANCHOR20
	bl	ftl_memcpy
	add	x21, x19, :lo12:.LANCHOR32
	mov	x1, x25
	adrp	x25, .LANCHOR28
	mov	w2, 32
	mov	x0, x21
	bl	ftl_memcpy
	ldrb	w0, [x25, #:lo12:.LANCHOR28]
	cmp	w0, 8
	bhi	.L2844
	ldrb	w0, [x21, 20]
	cmp	w0, 60
	bls	.L2844
	mov	w0, 60
	strb	w0, [x21, 20]
.L2844:
	ldr	w0, [x20, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2871
	adrp	x2, .LANCHOR200
	adrp	x0, .LC92
	add	x2, x2, :lo12:.LANCHOR200
	mov	w1, 2600
	add	x0, x0, :lo12:.LC92
	bl	printf
.L2871:
	ldr	x0, [x23, #:lo12:.LANCHOR16]
	ldrh	w0, [x0, 10]
	cmp	w0, 2304
	bne	.L2845
	mov	w0, 2
	strb	w0, [x24, #:lo12:.LANCHOR31]
.L2845:
	mov	w0, 16384
	bl	ftl_malloc
	adrp	x1, .LANCHOR167
	adrp	x26, .LANCHOR27
	add	x21, x19, :lo12:.LANCHOR32
	adrp	x24, .LANCHOR45
	str	x0, [x1, #:lo12:.LANCHOR167]
	mov	w0, 16384
	bl	ftl_malloc
	adrp	x1, .LANCHOR159
	str	x0, [x1, #:lo12:.LANCHOR159]
	mov	w0, 2048
	bl	ftl_malloc
	str	x0, [x26, #:lo12:.LANCHOR27]
	mov	w0, 64
	bl	ftl_malloc
	adrp	x1, .LANCHOR166
	str	x0, [x1, #:lo12:.LANCHOR166]
	mov	w0, 64
	bl	ftl_malloc
	adrp	x1, .LANCHOR161
	str	x0, [x1, #:lo12:.LANCHOR161]
	mov	w0, 64
	bl	ftl_malloc
	adrp	x1, .LANCHOR197
	str	x0, [x1, #:lo12:.LANCHOR197]
	adrp	x0, .LANCHOR203
	strb	wzr, [x0, #:lo12:.LANCHOR203]
	bl	flash_die_info_init
	ldrb	w0, [x21, 18]
	bl	flash_lsb_page_tbl_build
	ldrb	w0, [x21, 20]
	adrp	x21, .LANCHOR165
	bl	nandc_bch_sel
	str	xzr, [x21, #:lo12:.LANCHOR165]
	ldr	x2, [x23, #:lo12:.LANCHOR16]
	ldrh	w0, [x2, 16]
	ubfx	x1, x0, 8, 3
	strb	w1, [x24, #:lo12:.LANCHOR45]
	adrp	x1, .LANCHOR171
	ubfx	x3, x0, 3, 1
	strb	w3, [x1, #:lo12:.LANCHOR171]
	adrp	x1, .LANCHOR41
	ubfx	x3, x0, 4, 1
	strb	w3, [x1, #:lo12:.LANCHOR41]
	adrp	x1, .LANCHOR77
	ubfx	x3, x0, 12, 1
	strb	w3, [x1, #:lo12:.LANCHOR77]
	adrp	x1, .LANCHOR74
	ubfx	x3, x0, 13, 1
	strb	w3, [x1, #:lo12:.LANCHOR74]
	adrp	x1, .LANCHOR35
	ubfx	x3, x0, 11, 1
	strb	w3, [x1, #:lo12:.LANCHOR35]
	adrp	x3, .LANCHOR204
	ldrb	w1, [x2, 31]
	ldrb	w2, [x2, 28]
	ubfx	x4, x1, 1, 1
	strb	w4, [x3, #:lo12:.LANCHOR204]
	adrp	x3, .LANCHOR205
	ubfx	x1, x1, 2, 1
	strb	w1, [x3, #:lo12:.LANCHOR205]
	adrp	x1, .LANCHOR1
	ubfx	x3, x0, 14, 1
	lsr	w0, w0, 15
	strb	w3, [x1, #:lo12:.LANCHOR1]
	adrp	x1, .LANCHOR75
	strb	w0, [x1, #:lo12:.LANCHOR75]
	adrp	x0, .LANCHOR0
	mov	w1, 60
	strb	w2, [x0, #:lo12:.LANCHOR0]
	adrp	x0, .LANCHOR17
	strb	w1, [x0, #:lo12:.LANCHOR17]
	ldrb	w1, [x25, #:lo12:.LANCHOR28]
	cmp	w1, 9
	bne	.L2846
	mov	w3, 70
	strb	w3, [x0, #:lo12:.LANCHOR17]
.L2846:
	adrp	x0, .LANCHOR19
	strb	w2, [x0, #:lo12:.LANCHOR19]
	add	x2, x19, :lo12:.LANCHOR32
	ldrb	w2, [x2, 7]
	cmp	w2, 9
	bne	.L2847
	strb	wzr, [x0, #:lo12:.LANCHOR19]
.L2847:
	add	x2, x19, :lo12:.LANCHOR32
	ldrb	w2, [x2, 31]
	tbz	x2, 0, .L2848
	mov	w2, 3
	strb	w2, [x0, #:lo12:.LANCHOR19]
.L2848:
	cmp	w1, 8
	bne	.L2849
	ldrb	w1, [x22, #:lo12:.LANCHOR44]
	mov	w2, 137
	cmp	w1, 44
	ccmp	w1, w2, 4, ne
	bne	.L2849
	add	x1, x19, :lo12:.LANCHOR32
	ldrb	w1, [x1, 28]
	cmp	w1, 3
	bne	.L2849
	strb	wzr, [x0, #:lo12:.LANCHOR19]
.L2849:
	add	x19, x19, :lo12:.LANCHOR32
	adrp	x25, .LANCHOR24
	ldrh	w1, [x19, 16]
	ldrb	w0, [x19, 19]
	strb	w0, [x25, #:lo12:.LANCHOR24]
	tbz	x1, 6, .L2851
	sub	w1, w0, #17
	and	w1, w1, 255
	cmp	w1, 2
	ccmp	w0, 21, 4, hi
	bne	.L2852
	adrp	x1, micron_read_retrial
	add	x1, x1, :lo12:micron_read_retrial
	str	x1, [x21, #:lo12:.LANCHOR165]
	cmp	w0, 21
	adrp	x0, .LANCHOR162
	beq	.L2853
	mov	w1, 15
.L2901:
	strb	w1, [x0, #:lo12:.LANCHOR162]
	b	.L2851
.L2840:
	add	x10, x10, 1
	add	x8, x8, 32
	cmp	x10, 44
	bne	.L2842
	b	.L2837
.L2853:
	mov	w1, 4
	b	.L2901
.L2852:
	sub	w1, w0, #65
	cmp	w0, 33
	and	w1, w1, 255
	ccmp	w1, 1, 0, ne
	bhi	.L2855
	adrp	x0, toshiba_read_retrial
	add	x0, x0, :lo12:toshiba_read_retrial
	str	x0, [x21, #:lo12:.LANCHOR165]
	adrp	x0, .LANCHOR26
	mov	w1, 4
	strb	w1, [x0, #:lo12:.LANCHOR26]
.L2903:
	mov	w1, 7
	adrp	x0, .LANCHOR162
	b	.L2901
.L2855:
	sub	w2, w0, #34
	sub	w1, w0, #67
	and	w2, w2, 255
	and	w1, w1, 255
	cmp	w2, 1
	ccmp	w1, 1, 0, hi
	bhi	.L2856
	adrp	x2, toshiba_read_retrial
	add	x2, x2, :lo12:toshiba_read_retrial
	str	x2, [x21, #:lo12:.LANCHOR165]
	cmp	w0, 35
	mov	w2, 68
	ccmp	w0, w2, 4, ne
	adrp	x0, .LANCHOR162
	beq	.L2857
	mov	w2, 7
.L2900:
	strb	w2, [x0, #:lo12:.LANCHOR162]
	cmp	w1, 1
	adrp	x0, .LANCHOR26
	bhi	.L2859
	mov	w1, 4
.L2902:
	strb	w1, [x0, #:lo12:.LANCHOR26]
.L2851:
	ldr	w0, [x20, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2860
	adrp	x2, .LANCHOR200
	adrp	x0, .LC92
	add	x2, x2, :lo12:.LANCHOR200
	mov	w1, 2671
	add	x0, x0, :lo12:.LC92
	bl	printf
.L2860:
	adrp	x22, .LANCHOR21
	ldrb	w0, [x24, #:lo12:.LANCHOR45]
	strb	wzr, [x22, #:lo12:.LANCHOR21]
	tbz	x0, 0, .L2861
	mov	w0, 4
	bl	nandc_set_if_mode
	mov	w0, 1
	bl	flash_set_interface_mode
	mov	w0, 1
.L2904:
	bl	nandc_set_if_mode
	bl	flash_info_blk_init
	mov	w19, w0
	cmn	w0, #1
	bne	.L2863
	ldr	w0, [x20, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2864
	adrp	x2, .LANCHOR200
	adrp	x0, .LC92
	add	x2, x2, :lo12:.LANCHOR200
	mov	w1, 2688
	add	x0, x0, :lo12:.LC92
	bl	printf
.L2864:
	ldr	x0, [x26, #:lo12:.LANCHOR27]
	mov	w1, 17
	strb	w1, [x0, 32]
	adrp	x0, .LANCHOR33
	strb	wzr, [x0, #:lo12:.LANCHOR33]
	mov	w0, 0
	bl	zftl_flash_exit_slc_mode
	b	.L2832
.L2857:
	mov	w2, 17
	b	.L2900
.L2859:
	mov	w1, 5
	b	.L2902
.L2856:
	sub	w0, w0, #36
	and	w0, w0, 255
	cmp	w0, 1
	bhi	.L2851
	adrp	x0, toshiba_3d_read_retrial
	add	x0, x0, :lo12:toshiba_3d_read_retrial
	str	x0, [x21, #:lo12:.LANCHOR165]
	b	.L2903
.L2861:
	mov	w0, 4
	b	.L2904
.L2863:
	ldrb	w0, [x25, #:lo12:.LANCHOR24]
	sub	w0, w0, #1
	and	w0, w0, 255
	cmp	w0, 7
	bhi	.L2865
	adrp	x0, hynix_read_retrial
	add	x0, x0, :lo12:hynix_read_retrial
	str	x0, [x21, #:lo12:.LANCHOR165]
.L2865:
	ldrb	w0, [x24, #:lo12:.LANCHOR45]
	tbz	x0, 2, .L2867
	ldr	x0, [x26, #:lo12:.LANCHOR27]
	ldrb	w0, [x0, 19]
	cbz	w0, .L2867
	adrp	x0, .LANCHOR198
	ldrb	w1, [x0, #:lo12:.LANCHOR198]
	adrp	x0, .LANCHOR2
	ldrh	w0, [x0, #:lo12:.LANCHOR2]
	mul	w1, w1, w0
	mov	w0, 0
	bl	flash_ddr_para_scan
	ldrb	w0, [x22, #:lo12:.LANCHOR21]
	cbnz	w0, .L2867
	ldr	x0, [x26, #:lo12:.LANCHOR27]
	strb	wzr, [x0, 19]
	bl	flash_info_flush
.L2867:
	ldr	w0, [x20, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2869
	adrp	x2, .LANCHOR200
	adrp	x0, .LC92
	add	x2, x2, :lo12:.LANCHOR200
	mov	w1, 2740
	add	x0, x0, :lo12:.LC92
	bl	printf
.L2869:
	bl	nand_flash_print_info
	mov	w19, 0
	b	.L2832
	.size	nand_flash_init, .-nand_flash_init
	.section	.text.ftl_sysblk_dump,"ax",@progbits
	.align	2
	.global	ftl_sysblk_dump
	.type	ftl_sysblk_dump, %function
ftl_sysblk_dump:
	sub	sp, sp, #144
	stp	x29, x30, [sp, 48]
	add	x29, sp, 48
	stp	x19, x20, [sp, 64]
	mov	w20, 0
	stp	x23, x24, [sp, 96]
	and	w23, w0, 65535
	stp	x25, x26, [sp, 112]
	mov	w0, 1
	stp	x27, x28, [sp, 128]
	adrp	x25, .LANCHOR87
	stp	x21, x22, [sp, 80]
	bl	buf_alloc
	ldr	x28, [x0, 8]
	adrp	x26, .LANCHOR105
	adrp	x27, .LANCHOR125
	mov	x24, x0
	add	x25, x25, :lo12:.LANCHOR87
	add	x26, x26, :lo12:.LANCHOR105
	add	x27, x27, :lo12:.LANCHOR125
	mov	w19, 0
.L2906:
	ldrh	w0, [x25]
	cmp	w0, w19
	bhi	.L2908
	add	x1, x28, 704
	mov	w3, 32
	mov	w2, 4
	adrp	x0, .LC177
	add	x0, x0, :lo12:.LC177
	bl	rknand_print_hex
	mov	x0, x24
	bl	zbuf_free
	cbz	w20, .L2909
	adrp	x1, .LANCHOR206
	adrp	x0, .LC0
	mov	w2, 1422
	add	x1, x1, :lo12:.LANCHOR206
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2909:
	mov	w0, w20
	ldp	x19, x20, [sp, 64]
	ldp	x21, x22, [sp, 80]
	ldp	x23, x24, [sp, 96]
	ldp	x25, x26, [sp, 112]
	ldp	x27, x28, [sp, 128]
	ldp	x29, x30, [sp, 48]
	add	sp, sp, 144
	ret
.L2908:
	ldrh	w21, [x26]
	ldrb	w3, [x27]
	ldr	x1, [x24, 8]
	ldr	x2, [x24, 24]
	madd	w21, w21, w23, w19
	mov	w0, w21
	bl	ftl_read_ppa_page
	mov	w22, w0
	ldr	x1, [x24, 24]
	mov	w4, w0
	ldr	x0, [x24, 8]
	mov	w3, w21
	ldr	w2, [x1, 12]
	str	w2, [sp, 32]
	ldr	w2, [x1, 8]
	str	w2, [sp, 24]
	ldr	w2, [x1, 4]
	str	w2, [sp, 16]
	mov	w2, w19
	add	w19, w19, 1
	ldr	w1, [x1]
	and	w19, w19, 65535
	str	w1, [sp, 8]
	ldr	w1, [x0, 12]
	str	w1, [sp]
	mov	w1, w23
	ldp	w5, w6, [x0]
	ldr	w7, [x0, 8]
	adrp	x0, .LC163
	add	x0, x0, :lo12:.LC163
	bl	printf
	cmp	w22, 512
	ccmn	w22, #1, 4, ne
	csinc	w20, w20, wzr, ne
	b	.L2906
	.size	ftl_sysblk_dump, .-ftl_sysblk_dump
	.section	.text.dump_ftl_info,"ax",@progbits
	.align	2
	.global	dump_ftl_info
	.type	dump_ftl_info, %function
dump_ftl_info:
	stp	x29, x30, [sp, -48]!
	adrp	x0, .LANCHOR54
	add	x29, sp, 0
	ldrb	w1, [x0, #:lo12:.LANCHOR54]
	adrp	x0, .LC178
	stp	x19, x20, [sp, 16]
	add	x0, x0, :lo12:.LC178
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR104
	adrp	x19, .LANCHOR10
	adrp	x20, .LANCHOR87
	bl	printf
	adrp	x21, .LANCHOR6
	adrp	x0, .LANCHOR182
	add	x1, x0, :lo12:.LANCHOR182
	ldrh	w3, [x1, 2]
	ldrb	w2, [x1, 1]
	ldrb	w1, [x0, #:lo12:.LANCHOR182]
	adrp	x0, .LC179
	add	x0, x0, :lo12:.LC179
	bl	printf
	ldr	x0, [x22, #:lo12:.LANCHOR104]
	ldrh	w2, [x0, 140]
	ldrh	w1, [x0, 130]
	adrp	x0, .LC180
	add	x0, x0, :lo12:.LC180
	bl	printf
	ldr	x1, [x19, #:lo12:.LANCHOR10]
	adrp	x0, .LC181
	add	x0, x0, :lo12:.LC181
	ldrh	w5, [x1, 26]
	ldrh	w4, [x1, 22]
	ldrb	w3, [x1, 21]
	ldrh	w2, [x1, 18]
	ldrh	w1, [x1, 16]
	bl	printf
	ldr	x1, [x19, #:lo12:.LANCHOR10]
	adrp	x0, .LC182
	add	x0, x0, :lo12:.LC182
	ldrh	w5, [x1, 58]
	ldrh	w4, [x1, 54]
	ldrb	w3, [x1, 53]
	ldrh	w2, [x1, 50]
	ldrh	w1, [x1, 48]
	bl	printf
	ldr	x1, [x19, #:lo12:.LANCHOR10]
	adrp	x19, .LANCHOR80
	adrp	x0, .LC183
	add	x0, x0, :lo12:.LC183
	ldrh	w5, [x1, 90]
	ldrh	w4, [x1, 86]
	ldrb	w3, [x1, 85]
	ldrh	w2, [x1, 82]
	ldrh	w1, [x1, 80]
	bl	printf
	ldrb	w0, [x19, #:lo12:.LANCHOR80]
	mov	w2, 4
	ldrh	w3, [x20, #:lo12:.LANCHOR87]
	mul	w3, w3, w0
	adrp	x0, .LANCHOR111
	ldr	x1, [x0, #:lo12:.LANCHOR111]
	adrp	x0, .LC184
	lsl	w3, w3, 1
	add	x0, x0, :lo12:.LC184
	bl	rknand_print_hex
	adrp	x0, .LANCHOR9
	ldrh	w3, [x21, #:lo12:.LANCHOR6]
	mov	w2, 2
	ldr	x1, [x0, #:lo12:.LANCHOR9]
	adrp	x0, .LC185
	add	x0, x0, :lo12:.LC185
	bl	rknand_print_hex
	ldr	x1, [x22, #:lo12:.LANCHOR104]
	mov	w2, 4
	adrp	x0, .LC177
	add	x0, x0, :lo12:.LC177
	add	x1, x1, 704
	ldrh	w3, [x1, -6]
	bl	rknand_print_hex
	adrp	x0, .LANCHOR7
	ldrh	w3, [x21, #:lo12:.LANCHOR6]
	mov	w2, 4
	ldr	x1, [x0, #:lo12:.LANCHOR7]
	adrp	x0, .LC186
	add	x0, x0, :lo12:.LC186
	bl	rknand_print_hex
	mov	w3, 256
	mov	w2, 2
	adrp	x1, .LANCHOR110
	adrp	x0, .LC187
	add	x1, x1, :lo12:.LANCHOR110
	add	x0, x0, :lo12:.LC187
	bl	rknand_print_hex
	ldrb	w0, [x19, #:lo12:.LANCHOR80]
	mov	w2, 2
	ldrh	w3, [x20, #:lo12:.LANCHOR87]
	ldp	x21, x22, [sp, 32]
	ldp	x19, x20, [sp, 16]
	mul	w3, w3, w0
	adrp	x0, .LANCHOR112
	ldp	x29, x30, [sp], 48
	lsl	w3, w3, 1
	ldr	x1, [x0, #:lo12:.LANCHOR112]
	adrp	x0, .LC188
	add	x0, x0, :lo12:.LC188
	b	rknand_print_hex
	.size	dump_ftl_info, .-dump_ftl_info
	.section	.text.pm_ppa_update_check,"ax",@progbits
	.align	2
	.global	pm_ppa_update_check
	.type	pm_ppa_update_check, %function
pm_ppa_update_check:
	adrp	x4, .LANCHOR31
	adrp	x3, .LANCHOR68
	mov	w5, 24
	ldrb	w4, [x4, #:lo12:.LANCHOR31]
	ldrh	w3, [x3, #:lo12:.LANCHOR68]
	sub	w4, w5, w4
	sub	w5, w4, w3
	mov	w4, 1
	lsr	w3, w2, w3
	lsl	w4, w4, w5
	sub	w4, w4, #1
	and	w4, w4, w3
	adrp	x3, .LANCHOR69
	ldrb	w3, [x3, #:lo12:.LANCHOR69]
	udiv	w4, w4, w3
	adrp	x3, .LANCHOR7
	ldr	x3, [x3, #:lo12:.LANCHOR7]
	add	x4, x3, x4, uxth 2
	ldrb	w3, [x4, 2]
	ubfx	x3, x3, 5, 3
	cmp	w3, 1
	ccmp	w3, 7, 4, ne
	bne	.L2920
	mov	w3, w2
	mov	w2, w1
	mov	x1, x0
	stp	x29, x30, [sp, -16]!
	adrp	x0, .LC189
	add	x0, x0, :lo12:.LC189
	add	x29, sp, 0
	bl	printf
	bl	dump_ftl_info
	mov	w0, -1
	ldp	x29, x30, [sp], 16
	ret
.L2920:
	mov	w0, 0
	ret
	.size	pm_ppa_update_check, .-pm_ppa_update_check
	.section	.text.load_l2p_region,"ax",@progbits
	.align	2
	.type	load_l2p_region, %function
load_l2p_region:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w19, w0, 65535
	stp	x21, x22, [sp, 32]
	and	x21, x1, 65535
	stp	x23, x24, [sp, 48]
	cmp	w21, 31
	stp	x25, x26, [sp, 64]
	bls	.L2926
	adrp	x1, .LANCHOR207
	adrp	x0, .LC0
	mov	w2, 32
	add	x1, x1, :lo12:.LANCHOR207
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2926:
	adrp	x20, .LANCHOR104
	mov	x25, x20
	ldr	x0, [x20, #:lo12:.LANCHOR104]
	ldrh	w2, [x0, 698]
	cmp	w2, w19
	bcs	.L2927
	mov	w1, w19
	adrp	x0, .LC190
	add	x0, x0, :lo12:.LC190
	bl	printf
	adrp	x0, .LANCHOR208
	mov	w1, 255
	ldrh	w2, [x0, #:lo12:.LANCHOR208]
	mov	x0, 0
	ldr	x0, [x0, 8]
	bl	ftl_memset
	ldr	x0, [x20, #:lo12:.LANCHOR104]
	ldrh	w0, [x0, 698]
	cmp	w0, w19
	bcc	.L2928
.L2938:
	mov	w0, 0
.L2925:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L2928:
	mov	w2, 36
.L2939:
	adrp	x1, .LANCHOR207
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR207
	add	x0, x0, :lo12:.LC0
	bl	printf
	b	.L2938
.L2927:
	add	x0, x0, x19, sxtw 2
	adrp	x22, .LANCHOR134
	add	x1, x22, :lo12:.LANCHOR134
	ldr	w23, [x0, 704]
	lsl	x0, x21, 4
	add	x26, x1, x0
	strh	w19, [x1, x0]
	strh	wzr, [x26, 2]
	cbnz	w23, .L2930
	mov	w1, w19
	mov	w2, 0
	adrp	x0, .LC191
	add	x0, x0, :lo12:.LC191
	bl	printf
	adrp	x0, .LANCHOR208
	mov	w1, 255
	ldrh	w2, [x0, #:lo12:.LANCHOR208]
	ldr	x0, [x26, 8]
	bl	ftl_memset
	b	.L2938
.L2930:
	adrp	x20, .LANCHOR191
	adrp	x24, .LANCHOR125
	ldr	x1, [x26, 8]
	mov	w0, w23
	ldr	x2, [x20, #:lo12:.LANCHOR191]
	ldrb	w3, [x24, #:lo12:.LANCHOR125]
	bl	ftl_read_ppa_page
	ldr	x1, [x20, #:lo12:.LANCHOR191]
	ldr	w2, [x1]
	cmp	w2, w19
	bne	.L2931
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	beq	.L2931
.L2934:
	ldr	x0, [x20, #:lo12:.LANCHOR191]
	ldr	w0, [x0]
	cmp	w19, w0
	beq	.L2938
	mov	w2, 63
	b	.L2939
.L2931:
	mov	w4, w23
	mov	w3, w0
	mov	w1, w19
	adrp	x0, .LC192
	add	x0, x0, :lo12:.LC192
	bl	printf
	ldr	x1, [x25, #:lo12:.LANCHOR104]
	add	x22, x22, :lo12:.LANCHOR134
	add	x21, x22, x21, lsl 4
	mov	w2, 4
	add	x1, x1, 704
	adrp	x0, .LC193
	add	x0, x0, :lo12:.LC193
	ldrh	w3, [x1, -6]
	bl	rknand_print_hex
	ldr	x1, [x21, 8]
	mov	w2, 4
	ldrb	w3, [x24, #:lo12:.LANCHOR125]
	adrp	x0, .LC194
	add	x0, x0, :lo12:.LC194
	lsl	w3, w3, 7
	bl	rknand_print_hex
	ldr	x1, [x20, #:lo12:.LANCHOR191]
	mov	w3, 16
	mov	w2, 4
	adrp	x0, .LC195
	add	x0, x0, :lo12:.LC195
	bl	rknand_print_hex
	ldr	x1, [x21, 8]
	mov	w0, w23
	ldrb	w3, [x24, #:lo12:.LANCHOR125]
	ldr	x2, [x20, #:lo12:.LANCHOR191]
	bl	ftl_read_ppa_page
	ldr	x1, [x20, #:lo12:.LANCHOR191]
	ldr	w1, [x1]
	cmp	w19, w1
	bne	.L2936
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	bne	.L2934
.L2936:
	mov	w0, -1
	b	.L2925
	.size	load_l2p_region, .-load_l2p_region
	.section	.text.pm_gc,"ax",@progbits
	.align	2
	.global	pm_gc
	.type	pm_gc, %function
pm_gc:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR104
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR146
	ldr	x0, [x19, #:lo12:.LANCHOR104]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	ldrh	w2, [x0, 688]
	adrp	x0, .LANCHOR149
	str	x27, [sp, 80]
	mov	x20, x0
	ldrh	w1, [x0, #:lo12:.LANCHOR149]
	sub	w1, w1, #1
	cmp	w2, w1
	bge	.L2941
	ldr	w0, [x21, #:lo12:.LANCHOR146]
	cbz	w0, .L2942
.L2941:
	bl	pm_free_sblk
	ldr	x2, [x19, #:lo12:.LANCHOR104]
	ldrh	w1, [x20, #:lo12:.LANCHOR149]
	sub	w1, w1, #1
	ldrh	w3, [x2, 688]
	cmp	w3, w1
	bge	.L2943
	ldr	w1, [x21, #:lo12:.LANCHOR146]
	cbz	w1, .L2942
.L2943:
	add	x0, x2, x0, uxth 1
	str	wzr, [x21, #:lo12:.LANCHOR146]
	mov	w20, 65535
	ldrh	w21, [x0, 416]
	cmp	w21, w20
	bne	.L2945
	adrp	x1, .LANCHOR209
	add	x1, x1, :lo12:.LANCHOR209
	mov	w2, 162
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	printf
	bl	pm_free_sblk
	ldr	x1, [x19, #:lo12:.LANCHOR104]
	add	x0, x1, x0, uxth 1
	ldrh	w21, [x0, 416]
	cmp	w21, w20
	beq	.L2942
.L2945:
	bl	pm_select_ram_region
	and	x22, x0, 65535
	lsl	x0, x22, 4
	adrp	x20, .LANCHOR134
	add	x1, x20, :lo12:.LANCHOR134
	mov	x25, x22
	add	x23, x1, x0
	ldrh	w0, [x1, x0]
	mov	w1, 65535
	cmp	w0, w1
	beq	.L2946
	ldr	x1, [x23, 8]
	cbz	x1, .L2946
	ldrsh	w2, [x23, 2]
	tbz	w2, #31, .L2946
	bl	pm_write_page
	ldrh	w0, [x23, 2]
	and	w0, w0, 32767
	strh	w0, [x23, 2]
.L2946:
	adrp	x23, .LANCHOR68
	adrp	x24, .LANCHOR31
	add	x23, x23, :lo12:.LANCHOR68
	add	x24, x24, :lo12:.LANCHOR31
	mov	w27, 0
	mov	w26, 24
.L2947:
	ldr	x2, [x19, #:lo12:.LANCHOR104]
	ldrh	w0, [x2, 698]
	cmp	w0, w27
	bhi	.L2950
	bl	pm_free_sblk
.L2942:
	mov	w0, 0
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L2950:
	ldrb	w0, [x24]
	add	x2, x2, x27, sxtw 2
	ldrh	w3, [x23]
	sub	w0, w26, w0
	sub	w1, w0, w3
	mov	w0, 1
	lsl	w0, w0, w1
	ldr	w1, [x2, 704]
	sub	w0, w0, #1
	lsr	w1, w1, w3
	and	w0, w0, w1
	adrp	x1, .LANCHOR69
	ldrb	w1, [x1, #:lo12:.LANCHOR69]
	udiv	w0, w0, w1
	cmp	w21, w0, uxth
	bne	.L2948
	mov	w1, w25
	mov	w0, w27
	bl	load_l2p_region
	cbnz	w0, .L2949
	add	x0, x20, :lo12:.LANCHOR134
	add	x0, x0, x22, lsl 4
	ldr	x1, [x0, 8]
	mov	w0, w27
	bl	pm_write_page
.L2949:
	add	x1, x20, :lo12:.LANCHOR134
	lsl	x0, x22, 4
	mov	w2, -1
	strh	w2, [x1, x0]
.L2948:
	add	w27, w27, 1
	and	w27, w27, 65535
	b	.L2947
	.size	pm_gc, .-pm_gc
	.section	.text.pm_flush_id,"ax",@progbits
	.align	2
	.global	pm_flush_id
	.type	pm_flush_id, %function
pm_flush_id:
	stp	x29, x30, [sp, -32]!
	ubfiz	x0, x0, 4, 16
	adrp	x2, .LANCHOR134
	add	x2, x2, :lo12:.LANCHOR134
	add	x29, sp, 0
	str	x19, [sp, 16]
	add	x19, x2, x0
	ldrh	w0, [x2, x0]
	ldr	x1, [x19, 8]
	bl	pm_write_page
	ldrh	w0, [x19, 2]
	and	w0, w0, 32767
	strh	w0, [x19, 2]
	adrp	x19, .LANCHOR132
	ldr	w0, [x19, #:lo12:.LANCHOR132]
	cbz	w0, .L2959
	bl	pm_gc
	str	wzr, [x19, #:lo12:.LANCHOR132]
.L2959:
	mov	w0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	pm_flush_id, .-pm_flush_id
	.section	.text.pm_flush,"ax",@progbits
	.align	2
	.global	pm_flush
	.type	pm_flush, %function
pm_flush:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR134
	add	x19, x19, :lo12:.LANCHOR134
	mov	w20, 0
	add	x19, x19, 2
.L2966:
	ldrsh	w0, [x19]
	tbz	w0, #31, .L2965
	mov	w0, w20
	bl	pm_flush_id
.L2965:
	add	w20, w20, 1
	add	x19, x19, 16
	and	w20, w20, 65535
	cmp	w20, 32
	bne	.L2966
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	pm_flush, .-pm_flush
	.section	.text.flt_sys_flush,"ax",@progbits
	.align	2
	.global	flt_sys_flush
	.type	flt_sys_flush, %function
flt_sys_flush:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
	bl	ftl_flush
	bl	pm_flush
	bl	ftl_ext_info_flush
	ldp	x29, x30, [sp], 16
	mov	w0, 0
	b	ftl_info_flush
	.size	flt_sys_flush, .-flt_sys_flush
	.section	.text.rk_ftl_de_init,"ax",@progbits
	.align	2
	.global	rk_ftl_de_init
	.type	rk_ftl_de_init, %function
rk_ftl_de_init:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
	bl	zftl_flash_de_init
	bl	flt_sys_flush
	ldp	x29, x30, [sp], 16
	b	zftl_flash_de_init
	.size	rk_ftl_de_init, .-rk_ftl_de_init
	.section	.text.zftl_deinit,"ax",@progbits
	.align	2
	.global	zftl_deinit
	.type	zftl_deinit, %function
zftl_deinit:
	b	rk_ftl_de_init
	.size	zftl_deinit, .-zftl_deinit
	.section	.text.pm_init,"ax",@progbits
	.align	2
	.global	pm_init
	.type	pm_init, %function
pm_init:
	stp	x29, x30, [sp, -112]!
	mov	w1, 1
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	mov	w24, w0
	adrp	x0, .LANCHOR146
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	adrp	x19, .LANCHOR134
	str	wzr, [x0, #:lo12:.LANCHOR146]
	adrp	x0, .LANCHOR132
	stp	x25, x26, [sp, 64]
	add	x21, x19, :lo12:.LANCHOR134
	str	wzr, [x0, #:lo12:.LANCHOR132]
	adrp	x0, .LANCHOR192
	stp	x27, x28, [sp, 80]
	mov	x20, x19
	strb	w1, [x0, #:lo12:.LANCHOR192]
	mov	w0, 64
	bl	ftl_malloc
	adrp	x19, .LANCHOR125
	adrp	x1, .LANCHOR191
	add	x23, x21, 512
	mov	x22, x1
	add	x19, x19, :lo12:.LANCHOR125
	str	x0, [x1, #:lo12:.LANCHOR191]
	mov	w25, -1
.L2976:
	strh	w25, [x21]
	strh	wzr, [x21, 2]
	cbz	w24, .L2975
	ldrb	w0, [x19]
	lsl	w0, w0, 9
	bl	ftl_malloc
	str	x0, [x21, 8]
.L2975:
	add	x21, x21, 16
	cmp	x21, x23
	bne	.L2976
	add	x0, x20, :lo12:.LANCHOR134
	adrp	x19, .LANCHOR104
	ldr	x24, [x22, #:lo12:.LANCHOR191]
	mov	w4, 4
	ldr	x25, [x0, 8]
	mov	x3, x24
	ldr	x0, [x19, #:lo12:.LANCHOR104]
	mov	x2, x25
	ldrh	w1, [x0, 692]
	ldrb	w0, [x0, 694]
	bl	flash_get_last_written_page
	sxth	w26, w0
	ldr	x0, [x19, #:lo12:.LANCHOR104]
	mov	w23, w26
	ldrh	w2, [x0, 696]
	cmp	w2, w26
	bgt	.L2977
	ldrh	w1, [x0, 692]
	mov	w3, w26
	adrp	x0, .LC196
	add	x0, x0, :lo12:.LC196
	adrp	x27, .LANCHOR105
	adrp	x28, .LANCHOR125
	add	x27, x27, :lo12:.LANCHOR105
	add	x28, x28, :lo12:.LANCHOR125
	bl	printf
	ldr	x0, [x19, #:lo12:.LANCHOR104]
	ldrsh	w21, [x0, 696]
.L2978:
	cmp	w21, w26
	ble	.L2980
	adrp	x0, .LANCHOR185
	mov	w1, 1
	add	w23, w23, 1
	strb	w1, [x0, #:lo12:.LANCHOR185]
	ldr	x0, [x19, #:lo12:.LANCHOR104]
	strh	w23, [x0, 696]
	bl	pm_free_sblk
.L2977:
	add	x20, x20, :lo12:.LANCHOR134
	adrp	x0, .LANCHOR208
	mov	w1, 255
	ldrh	w2, [x0, #:lo12:.LANCHOR208]
	ldr	x0, [x20, 8]
	bl	ftl_memset
	ldr	x1, [x20, 8]
	mov	w0, -1
	bl	pm_write_page
	adrp	x0, .LANCHOR185
	ldrb	w0, [x0, #:lo12:.LANCHOR185]
	cbz	w0, .L2981
	ldr	x1, [x20, 8]
	mov	w0, -1
	bl	pm_write_page
	ldr	x1, [x20, 8]
	mov	w0, -1
	bl	pm_write_page
	ldr	x1, [x20, 8]
	mov	w0, -1
	bl	pm_write_page
.L2981:
	bl	pm_free_sblk
	bl	pm_gc
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L2980:
	ldr	x0, [x19, #:lo12:.LANCHOR104]
	mov	x3, x24
	ldrh	w1, [x27]
	mov	x2, x25
	ldrb	w4, [x28]
	ldrh	w22, [x0, 692]
	ldrb	w0, [x0, 694]
	madd	w22, w22, w1, w21
	mov	w1, w22
	bl	flash_read_page_en
	mov	w4, w0
	ldr	x0, [x19, #:lo12:.LANCHOR104]
	str	w4, [x29, 108]
	mov	w2, w22
	ldr	w1, [x0, 48]
	ldrh	w3, [x0, 694]
	add	w1, w1, 1
	str	w1, [x0, 48]
	adrp	x0, .LC197
	add	x0, x0, :lo12:.LC197
	ldr	w1, [x24]
	bl	printf
	ldr	w4, [x29, 108]
	cmp	w4, 512
	ccmn	w4, #1, 4, ne
	beq	.L2979
	ldr	x1, [x19, #:lo12:.LANCHOR104]
	ldr	w0, [x24]
	ldrh	w2, [x1, 698]
	cmp	w0, w2
	bcs	.L2979
	add	x0, x1, x0, uxtw 2
	str	w22, [x0, 704]
.L2979:
	add	w21, w21, 1
	sxth	w21, w21
	b	.L2978
	.size	pm_init, .-pm_init
	.section	.text.pm_log2phys,"ax",@progbits
	.align	2
	.global	pm_log2phys
	.type	pm_log2phys, %function
pm_log2phys:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x25, x26, [sp, 64]
	mov	w25, w0
	adrp	x0, .LANCHOR122
	stp	x23, x24, [sp, 48]
	stp	x19, x20, [sp, 16]
	mov	w24, w2
	stp	x21, x22, [sp, 32]
	mov	x23, x1
	ldr	w2, [x0, #:lo12:.LANCHOR122]
	str	x27, [sp, 80]
	cmp	w25, w2
	bcc	.L2994
	mov	w1, w25
	adrp	x0, .LC198
	add	x0, x0, :lo12:.LC198
	bl	printf
	mov	w0, -1
	cbnz	w24, .L2993
	str	w0, [x23]
.L2993:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L2994:
	adrp	x0, .LANCHOR125
	adrp	x21, .LANCHOR134
	mov	x19, 0
	ldrb	w20, [x0, #:lo12:.LANCHOR125]
	add	x0, x21, :lo12:.LANCHOR134
	add	x0, x0, 8
	lsl	w22, w20, 7
	udiv	w22, w25, w22
	and	w26, w22, 65535
.L3000:
	ldr	x1, [x0]
	cbz	x1, .L2996
	ldrh	w1, [x0, -8]
	cmp	w1, w26
	bne	.L2996
.L2997:
	ubfiz	w20, w20, 7, 9
	msub	w25, w26, w20, w25
	and	x25, x25, 65535
	cbnz	w24, .L2998
	add	x0, x21, :lo12:.LANCHOR134
	adrp	x1, .LANCHOR31
	add	x0, x0, x19, lsl 4
	mov	w2, 24
	ldr	x0, [x0, 8]
	ldr	w0, [x0, x25, lsl 2]
	str	w0, [x23]
	ldrb	w3, [x1, #:lo12:.LANCHOR31]
	mov	w1, 1
	sub	w2, w2, w3
	lsl	w1, w1, w3
	sub	w1, w1, #1
	lsr	w0, w0, w2
	and	w0, w0, w1
	adrp	x1, .LANCHOR106
	ldrb	w1, [x1, #:lo12:.LANCHOR106]
	cmp	w0, w1
	bcc	.L2999
	mov	w0, -1
	str	w0, [x23]
.L2999:
	add	x21, x21, :lo12:.LANCHOR134
	add	x19, x21, x19, lsl 4
	ldrh	w0, [x19, 2]
	mvn	x1, x0
	tst	x1, 32767
	beq	.L3003
	add	w0, w0, 1
	strh	w0, [x19, 2]
.L3003:
	mov	w0, 0
	b	.L2993
.L2998:
	add	x0, x21, :lo12:.LANCHOR134
	ldr	w2, [x23]
	add	x0, x0, x19, lsl 4
	ldr	x1, [x0, 8]
	str	w2, [x1, x25, lsl 2]
	ldrh	w1, [x0, 2]
	orr	w1, w1, -32768
	strh	w1, [x0, 2]
	adrp	x0, .LANCHOR135
	strb	w22, [x0, #:lo12:.LANCHOR135]
	b	.L2999
.L2996:
	add	w19, w19, 1
	add	x0, x0, 16
	and	x19, x19, 65535
	cmp	w19, 32
	bne	.L3000
	bl	pm_select_ram_region
	and	x19, x0, 65535
	sbfiz	x1, x19, 4, 32
	add	x2, x21, :lo12:.LANCHOR134
	add	x3, x2, x1
	mov	w27, w0
	ldrh	w2, [x2, x1]
	mov	w1, 65535
	cmp	w2, w1
	beq	.L3001
	ldrsh	w1, [x3, 2]
	tbz	w1, #31, .L3001
	bl	pm_flush_id
.L3001:
	adrp	x0, .LANCHOR210
	mov	w1, w27
	strb	w19, [x0, #:lo12:.LANCHOR210]
	mov	w0, w26
	bl	load_l2p_region
	b	.L2997
	.size	pm_log2phys, .-pm_log2phys
	.section	.text.gc_recovery,"ax",@progbits
	.align	2
	.global	gc_recovery
	.type	gc_recovery, %function
gc_recovery:
	sub	sp, sp, #240
	adrp	x0, .LANCHOR10
	adrp	x1, .LANCHOR78
	mov	w2, 65535
	stp	x29, x30, [sp, 32]
	add	x29, sp, 32
	stp	x19, x20, [sp, 48]
	ldr	x20, [x0, #:lo12:.LANCHOR10]
	strb	wzr, [x1, #:lo12:.LANCHOR78]
	adrp	x1, .LANCHOR153
	stp	x27, x28, [sp, 112]
	mov	x27, x0
	strb	wzr, [x1, #:lo12:.LANCHOR153]
	add	x1, x20, 80
	stp	x21, x22, [sp, 64]
	str	x1, [x29, 168]
	stp	x23, x24, [sp, 80]
	ldrh	w1, [x20, 80]
	stp	x25, x26, [sp, 96]
	cmp	w1, w2
	beq	.L3010
	mov	w0, -1
	strh	w0, [x20, 130]
	mov	w0, 1
	bl	buf_alloc
	mov	x28, x0
	ldrb	w0, [x20, 89]
	add	x1, x20, 80
	adrp	x3, .LANCHOR105
	str	x3, [x29, 144]
	sub	w0, w0, #1
	add	x0, x1, x0, sxtw 1
	ldrh	w1, [x3, #:lo12:.LANCHOR105]
	ldrh	w0, [x0, 16]
	mul	w1, w0, w1
	adrp	x0, .LANCHOR73
	str	w1, [x29, 200]
	ldrb	w2, [x0, #:lo12:.LANCHOR73]
	str	x0, [x29, 160]
	cmp	w2, 2
	beq	.L3011
	adrp	x0, .LANCHOR35
	ldrb	w0, [x0, #:lo12:.LANCHOR35]
	cbz	w0, .L3012
.L3011:
	adrp	x0, .LANCHOR79
	ldrh	w0, [x0, #:lo12:.LANCHOR79]
	sub	w0, w0, #1
	add	w0, w0, w1
	orr	w2, w0, w2, lsl 24
	str	w2, [x28, 40]
.L3013:
	mov	w1, 1
	mov	x0, x28
	bl	sblk_read_page
	ldr	w0, [x28, 52]
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	beq	.L3014
	ldr	x0, [x28, 24]
	ldr	w1, [x0]
	mov	w0, 15555
	movk	w0, 0xf55f, lsl 16
	cmp	w1, w0
	beq	.L3015
.L3014:
	mov	x0, x28
	bl	zbuf_free
	ldr	x1, [x28, 24]
	mov	w26, 0
	ldr	x0, [x28, 8]
	ldr	w2, [x1, 12]
	str	w2, [sp, 16]
	ldr	w2, [x1, 8]
	str	w2, [sp, 8]
	ldr	w2, [x1, 4]
	str	w2, [sp]
	ldp	w3, w4, [x0]
	ldp	w5, w6, [x0, 8]
	adrp	x0, .LC199
	ldr	w7, [x1]
	add	x0, x0, :lo12:.LC199
	ldr	w1, [x28, 40]
	ldr	w2, [x28, 52]
	bl	printf
	adrp	x0, .LANCHOR9
	ldrh	w1, [x20, 80]
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	strh	wzr, [x0, x1, lsl 1]
	ldr	x0, [x27, #:lo12:.LANCHOR10]
	ldrh	w1, [x20, 80]
	strh	w1, [x0, 130]
.L3016:
	ldrh	w0, [x20, 80]
	adrp	x2, .LANCHOR9
	ldr	x2, [x2, #:lo12:.LANCHOR9]
	ubfiz	x1, x0, 1, 16
	ldrh	w1, [x2, x1]
	cbnz	w1, .L3051
	bl	ftl_dump_write_open_sblk
.L3051:
	ldrh	w1, [x20, 80]
	mov	w2, w26
	adrp	x0, .LC201
	add	x0, x0, :lo12:.LC201
	bl	printf
	mov	w0, -1
	strh	w0, [x20, 80]
	bl	pm_flush
	bl	ftl_ext_info_flush
	ldr	x0, [x27, #:lo12:.LANCHOR10]
	mov	w1, 65535
	ldrh	w0, [x0, 130]
	cmp	w0, w1
	beq	.L3052
	bl	ftl_free_sblk
.L3052:
	adrp	x0, .LANCHOR104
	ldr	x1, [x0, #:lo12:.LANCHOR104]
	mov	w0, -1
	strh	w0, [x1, 126]
	ldr	x1, [x27, #:lo12:.LANCHOR10]
	strh	w0, [x1, 130]
	mov	w0, 0
	bl	ftl_info_flush
.L3009:
	ldp	x19, x20, [sp, 48]
	ldp	x21, x22, [sp, 64]
	ldp	x23, x24, [sp, 80]
	ldp	x25, x26, [sp, 96]
	ldp	x27, x28, [sp, 112]
	ldp	x29, x30, [sp, 32]
	add	sp, sp, 240
	ret
.L3012:
	cmp	w2, 3
	bne	.L3013
	adrp	x0, .LANCHOR87
	ldrh	w0, [x0, #:lo12:.LANCHOR87]
	sub	w0, w0, #1
	add	w0, w0, w1
	orr	w0, w0, 50331648
	str	w0, [x28, 40]
	b	.L3013
.L3015:
	adrp	x22, .LANCHOR79
	adrp	x19, .LANCHOR80
	adrp	x23, .LANCHOR155
	ldr	x1, [x28, 8]
	ldrb	w0, [x19, #:lo12:.LANCHOR80]
	adrp	x25, .LANCHOR156
	ldrh	w2, [x22, #:lo12:.LANCHOR79]
	mul	w2, w2, w0
	ldr	x0, [x23, #:lo12:.LANCHOR155]
	lsl	w2, w2, 2
	bl	ftl_memcpy
	str	x22, [x29, 152]
	ldrb	w1, [x19, #:lo12:.LANCHOR80]
	ldrh	w0, [x22, #:lo12:.LANCHOR79]
	mul	w0, w0, w1
	adrp	x1, .LANCHOR125
	ldrb	w1, [x1, #:lo12:.LANCHOR125]
	lsl	w2, w0, 2
	cmp	w1, w0, lsr 6
	bge	.L3017
	lsl	w1, w1, 7
	sub	w0, w1, w0
	mov	w1, 0
	lsl	w26, w0, 2
	ldr	x0, [x25, #:lo12:.LANCHOR156]
	bl	ftl_memset
	ldr	x0, [x29, 152]
	mov	w2, w26
	ldrb	w1, [x19, #:lo12:.LANCHOR80]
	ldrh	w0, [x0, #:lo12:.LANCHOR79]
	mul	w0, w0, w1
	ldr	x1, [x28, 8]
	add	x1, x1, x0, sxtw 2
	ldr	x0, [x25, #:lo12:.LANCHOR156]
	bl	ftl_memcpy
	mov	w0, 1
	str	w0, [x29, 180]
.L3018:
	adrp	x0, .LANCHOR87
	ldrh	w0, [x0, #:lo12:.LANCHOR87]
	str	w0, [x29, 184]
	ldr	x0, [x29, 160]
	ldrb	w0, [x0, #:lo12:.LANCHOR73]
	str	w0, [x29, 188]
	cmp	w0, 2
	bne	.L3019
	adrp	x0, .LANCHOR74
	ldrb	w0, [x0, #:lo12:.LANCHOR74]
	cbz	w0, .L3020
.L3019:
	adrp	x0, .LANCHOR35
	ldrb	w0, [x0, #:lo12:.LANCHOR35]
	cbz	w0, .L3021
.L3020:
	ldp	w0, w1, [x29, 184]
	mul	w0, w0, w1
	str	w0, [x29, 184]
	mov	w0, 1
	str	w0, [x29, 188]
.L3021:
	adrp	x24, .LC200
	mov	w22, 0
	add	x0, x24, :lo12:.LC200
	mov	w19, 0
	str	x0, [x29, 104]
.L3022:
	sub	w0, w22, #1
	str	w0, [x29, 136]
	ldr	w0, [x29, 184]
	cmp	w0, w22
	bls	.L3034
	adrp	x0, .LANCHOR35
	mov	x21, 0
	add	x0, x0, :lo12:.LANCHOR35
	str	x0, [x29, 112]
	b	.L3035
.L3017:
	ldr	x1, [x28, 8]
	mov	w26, 0
	add	x1, x1, x0, sxtw 2
	ldr	x0, [x25, #:lo12:.LANCHOR156]
	bl	ftl_memcpy
	str	wzr, [x29, 180]
	b	.L3018
.L3030:
	ldp	x1, x0, [x29, 120]
	ldrh	w0, [x0, 96]
	ldrh	w1, [x1]
	mul	w0, w0, w1
	ldr	x1, [x29, 160]
	str	w0, [x29, 200]
	ldrb	w1, [x1, #:lo12:.LANCHOR73]
	cmp	w1, 2
	beq	.L3023
	ldr	x2, [x29, 112]
	ldrb	w2, [x2]
	cbz	w2, .L3024
.L3023:
	ldr	w2, [x29, 136]
	add	w0, w2, w0
	add	w0, w0, w24
	orr	w0, w0, w1, lsl 24
.L3026:
	str	w0, [x28, 40]
	mov	w1, 1
	str	x8, [x29, 96]
	mov	x0, x28
	bl	sblk_read_page
	ldr	w1, [x29, 180]
	ldr	x0, [x28, 24]
	ldr	x8, [x29, 96]
	cbz	w1, .L3027
	ldr	x1, [x25, #:lo12:.LANCHOR156]
	ldr	w2, [x1, x8]
	cbnz	w2, .L3027
	ldr	w2, [x0, 8]
	str	w2, [x1, x8]
.L3027:
	ldr	x1, [x23, #:lo12:.LANCHOR155]
	ldr	w6, [x0, 4]
	ldr	w3, [x1, x8]
	cmp	w3, w6
	bne	.L3028
	ldr	x1, [x25, #:lo12:.LANCHOR156]
	ldr	w2, [x1, x8]
	ldr	w1, [x0, 8]
	cmp	w2, w1
	beq	.L3029
.L3028:
	ldr	x1, [x25, #:lo12:.LANCHOR156]
	ldr	w2, [x0, 12]
	str	w2, [sp]
	str	x8, [x29, 96]
	ldr	w4, [x1, x8]
	ldr	w5, [x0]
	ldr	w7, [x0, 8]
	ldr	w1, [x28, 40]
	ldr	w2, [x28, 52]
	ldr	x0, [x29, 104]
	bl	printf
	ldr	x0, [x23, #:lo12:.LANCHOR155]
	ldr	x8, [x29, 96]
	ldr	w0, [x0, x8]
	cmn	w0, #1
	beq	.L3029
	mov	x0, x28
	bl	zbuf_free
	adrp	x0, .LANCHOR9
	ldrh	w1, [x20, 80]
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	strh	wzr, [x0, x1, lsl 1]
	ldr	x0, [x27, #:lo12:.LANCHOR10]
	ldrh	w1, [x20, 80]
	strh	w1, [x0, 130]
	b	.L3016
.L3024:
	cmp	w1, 3
	add	w0, w22, w0
	bne	.L3026
	orr	w0, w0, w24, lsl 24
	b	.L3026
.L3029:
	add	w19, w19, 1
	add	w24, w24, 1
	add	x8, x8, 4
.L3032:
	ldr	w0, [x29, 188]
	cmp	w0, w24
	bcs	.L3030
	add	x21, x21, 1
.L3035:
	ldr	x0, [x29, 168]
	ldrb	w0, [x0, 9]
	cmp	w0, w21
	ble	.L3031
	add	x0, x20, x21, lsl 1
	str	x0, [x29, 128]
	ldr	x0, [x29, 144]
	sbfiz	x8, x19, 2, 32
	mov	w24, 1
	add	x0, x0, :lo12:.LANCHOR105
	str	x0, [x29, 120]
	b	.L3032
.L3031:
	adrp	x0, .LANCHOR74
	ldrb	w0, [x0, #:lo12:.LANCHOR74]
	cmp	w0, 0
	cinc	w22, w22, ne
	add	w22, w22, 1
	b	.L3022
.L3034:
	mov	x0, x28
	bl	zbuf_free
	ldr	x3, [x29, 152]
	adrp	x21, .LANCHOR9
	ldr	x0, [x29, 168]
	adrp	x24, .LANCHOR68
	ldrh	w2, [x20, 80]
	mov	w26, 0
	ldr	x1, [x21, #:lo12:.LANCHOR9]
	mov	w28, 0
	ldrh	w3, [x3, #:lo12:.LANCHOR79]
	ldrb	w0, [x0, 9]
	str	x21, [x29, 136]
	str	wzr, [x29, 180]
	mul	w0, w0, w3
	strh	w0, [x1, x2, lsl 1]
	add	x0, x24, :lo12:.LANCHOR68
	str	x0, [x29, 104]
.L3036:
	sub	w0, w28, #1
	str	w0, [x29, 128]
	ldr	w0, [x29, 184]
	cmp	w0, w28
	bls	.L3049
	mov	x22, 0
	b	.L3050
.L3045:
	ldr	w0, [x29, 180]
	ldr	x1, [x23, #:lo12:.LANCHOR155]
	sbfiz	x0, x0, 2, 32
	ldr	w21, [x1, x0]
	cmn	w21, #1
	beq	.L3037
	ldr	x1, [x25, #:lo12:.LANCHOR156]
	ldr	w0, [x1, x0]
	str	w0, [x29, 152]
	mov	w0, w21
	bl	lpa_hash_get_ppa
	str	w0, [x29, 204]
	cmn	w0, #1
	bne	.L3038
	mov	w2, 0
	add	x1, x29, 204
	mov	w0, w21
	bl	pm_log2phys
.L3038:
	ldr	x0, [x29, 120]
	ldr	x1, [x29, 144]
	ldrh	w0, [x0, 96]
	ldrh	w1, [x1, #:lo12:.LANCHOR105]
	mul	w0, w0, w1
	ldr	x1, [x29, 160]
	ldrb	w1, [x1, #:lo12:.LANCHOR73]
	cmp	w1, 2
	beq	.L3039
	adrp	x2, .LANCHOR35
	ldrb	w2, [x2, #:lo12:.LANCHOR35]
	cbz	w2, .L3040
.L3039:
	ldr	w2, [x29, 128]
	add	w0, w0, w2
	add	w0, w0, w24
	orr	w0, w0, w1, lsl 24
.L3042:
	ldr	x1, [x29, 112]
	mov	w19, 24
	str	w0, [x29, 200]
	mov	w2, 1
	ldr	x0, [x29, 104]
	ldrb	w1, [x1]
	ldrh	w0, [x0]
	sub	w19, w19, w1
	ldr	w1, [x29, 152]
	sub	w19, w19, w0
	lsr	w0, w1, w0
	lsl	w19, w2, w19
	sub	w19, w19, #1
	and	w19, w19, w0
	adrp	x0, .LANCHOR69
	ldrb	w0, [x0, #:lo12:.LANCHOR69]
	udiv	w19, w19, w0
	ldr	w0, [x29, 204]
	cmp	w1, w0
	and	x19, x19, 65535
	bne	.L3043
	add	x1, x29, 200
	mov	w0, w21
	bl	pm_log2phys
	add	w26, w26, 1
	mov	w0, w19
	bl	ftl_vpn_decrement
.L3044:
	ldr	w0, [x29, 180]
	add	w0, w0, 1
	str	w0, [x29, 180]
	adrp	x0, .LANCHOR7
	ldr	x0, [x0, #:lo12:.LANCHOR7]
	add	x0, x0, x19, lsl 2
	ldrb	w0, [x0, 2]
	tst	w0, 224
	bne	.L3037
	ldr	x0, [x29, 136]
	lsl	x19, x19, 1
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrh	w1, [x0, x19]
	cbz	w1, .L3037
	strh	wzr, [x0, x19]
.L3037:
	add	w24, w24, 1
.L3047:
	ldr	w0, [x29, 188]
	cmp	w0, w24
	bcs	.L3045
	add	x22, x22, 1
.L3050:
	ldr	x0, [x29, 168]
	ldrb	w0, [x0, 9]
	cmp	w0, w22
	ble	.L3046
	add	x0, x20, x22, lsl 1
	mov	w24, 1
	str	x0, [x29, 120]
	adrp	x0, .LANCHOR31
	add	x0, x0, :lo12:.LANCHOR31
	str	x0, [x29, 112]
	b	.L3047
.L3040:
	cmp	w1, 3
	add	w0, w28, w0
	bne	.L3042
	orr	w0, w0, w24, lsl 24
	b	.L3042
.L3043:
	ldr	w1, [x29, 200]
	cmp	w0, w1
	cinc	w26, w26, eq
	b	.L3044
.L3046:
	adrp	x0, .LANCHOR74
	ldrb	w0, [x0, #:lo12:.LANCHOR74]
	cmp	w0, 0
	cinc	w28, w28, ne
	add	w28, w28, 1
	b	.L3036
.L3049:
	ldr	x0, [x29, 136]
	ldrh	w1, [x20, 80]
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	strh	w26, [x0, x1, lsl 1]
	ldrh	w0, [x20, 80]
	bl	zftl_insert_data_list
	b	.L3016
.L3010:
	ldrh	w0, [x20, 130]
	cmp	w0, w1
	beq	.L3009
	adrp	x19, .LANCHOR104
	ldr	x1, [x19, #:lo12:.LANCHOR104]
	ldrh	w1, [x1, 126]
	cmp	w1, w0
	bne	.L3054
	bl	pm_flush
	ldr	x0, [x27, #:lo12:.LANCHOR10]
	ldrh	w0, [x0, 130]
	bl	ftl_free_sblk
	ldr	x0, [x19, #:lo12:.LANCHOR104]
	mov	w1, -1
	strh	w1, [x0, 126]
	mov	w0, 0
	bl	ftl_info_flush
.L3054:
	ldr	x0, [x27, #:lo12:.LANCHOR10]
	mov	w1, -1
	strh	w1, [x0, 130]
	b	.L3009
	.size	gc_recovery, .-gc_recovery
	.section	.text.zftl_init,"ax",@progbits
	.align	2
	.global	zftl_init
	.type	zftl_init, %function
zftl_init:
	stp	x29, x30, [sp, -112]!
	adrp	x1, .LANCHOR59
	mov	w0, -1
	add	x29, sp, 0
	strb	w0, [x1, #:lo12:.LANCHOR59]
	adrp	x1, .LANCHOR60
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR87
	strb	wzr, [x1, #:lo12:.LANCHOR60]
	adrp	x1, .LANCHOR128
	stp	x19, x20, [sp, 16]
	adrp	x21, .LANCHOR80
	strb	w0, [x1, #:lo12:.LANCHOR128]
	adrp	x1, .LANCHOR129
	stp	x23, x24, [sp, 48]
	adrp	x20, .LANCHOR208
	strb	wzr, [x1, #:lo12:.LANCHOR129]
	adrp	x1, .LANCHOR177
	stp	x25, x26, [sp, 64]
	adrp	x23, .LANCHOR6
	strb	w0, [x1, #:lo12:.LANCHOR177]
	adrp	x0, .LANCHOR123
	mov	w1, -1
	stp	x27, x28, [sp, 80]
	strb	wzr, [x0, #:lo12:.LANCHOR123]
	adrp	x0, .LANCHOR211
	str	w1, [x0, #:lo12:.LANCHOR211]
	adrp	x1, .LC202
	adrp	x0, .LC99
	add	x1, x1, :lo12:.LC202
	add	x0, x0, :lo12:.LC99
	bl	printf
	adrp	x1, .LANCHOR32
	add	x1, x1, :lo12:.LANCHOR32
	adrp	x0, .LANCHOR73
	adrp	x2, .LANCHOR125
	adrp	x3, .LANCHOR79
	adrp	x4, .LANCHOR69
	ldrb	w5, [x1, 12]
	strb	w5, [x0, #:lo12:.LANCHOR73]
	ldrb	w0, [x1, 9]
	strb	w0, [x2, #:lo12:.LANCHOR125]
	ldrh	w2, [x1, 10]
	strh	w2, [x3, #:lo12:.LANCHOR79]
	adrp	x3, .LANCHOR18
	ldrh	w7, [x1, 14]
	ubfiz	w10, w0, 9, 7
	ldrb	w6, [x3, #:lo12:.LANCHOR18]
	adrp	x3, .LANCHOR106
	sdiv	w8, w2, w5
	strh	w7, [x23, #:lo12:.LANCHOR6]
	strb	w6, [x3, #:lo12:.LANCHOR106]
	ldrb	w3, [x1, 13]
	adrp	x1, .LANCHOR2
	strb	w3, [x4, #:lo12:.LANCHOR69]
	ldrh	w4, [x1, #:lo12:.LANCHOR2]
	adrp	x1, .LANCHOR105
	strh	w8, [x22, #:lo12:.LANCHOR87]
	mul	w6, w6, w3
	strh	w4, [x1, #:lo12:.LANCHOR105]
	strh	w10, [x20, #:lo12:.LANCHOR208]
	mov	w3, 1
	and	w6, w6, 255
	mov	w1, 0
	strb	w6, [x21, #:lo12:.LANCHOR80]
.L3088:
	cmp	w4, w3
	bcs	.L3089
	mul	w2, w0, w2
	adrp	x3, .LANCHOR68
	sub	w1, w1, #1
	mov	w4, 0
	strh	w1, [x3, #:lo12:.LANCHOR68]
	mov	w1, 1
	mul	w3, w2, w7
	lsr	w11, w3, 21
.L3090:
	cmp	w11, w1
	bcs	.L3091
	mov	w1, 57344
	sub	w4, w4, #1
	movk	w1, 0x1c, lsl 16
	mul	w3, w3, w6
	adrp	x28, .LANCHOR122
	sub	w11, w10, #1
	mul	w1, w6, w1
	adrp	x24, .LANCHOR194
	mul	w8, w8, w6
	adrp	x27, .LANCHOR213
	mul	w2, w2, w6
	adrp	x26, .LANCHOR149
	lsl	w1, w1, w4
	adrp	x4, .LANCHOR61
	sub	w2, w2, #1
	adrp	x25, .LANCHOR91
	str	w1, [x4, #:lo12:.LANCHOR61]
	adrp	x4, .LANCHOR212
	str	w3, [x4, #:lo12:.LANCHOR212]
	add	w3, w1, 24576
	str	w3, [x27, #:lo12:.LANCHOR213]
	udiv	w0, w3, w0
	udiv	w3, w3, w2
	adrp	x2, .LANCHOR119
	str	w0, [x28, #:lo12:.LANCHOR122]
	add	w0, w11, w0, lsl 2
	add	w3, w3, 8
	udiv	w0, w0, w10
	strh	w0, [x24, #:lo12:.LANCHOR194]
	ubfiz	w0, w0, 4, 16
	sdiv	w0, w0, w8
	adrp	x8, .LANCHOR95
	str	x8, [x29, 104]
	strh	w3, [x8, #:lo12:.LANCHOR95]
	strh	w0, [x26, #:lo12:.LANCHOR149]
	add	w0, w7, w7, lsl 1
	asr	w0, w0, 2
	strh	w0, [x2, #:lo12:.LANCHOR119]
	lsr	w0, w7, 4
	strh	w0, [x25, #:lo12:.LANCHOR91]
	cmp	w0, 79
	bhi	.L3092
	mov	w0, 80
	strh	w0, [x25, #:lo12:.LANCHOR91]
.L3092:
	adrp	x7, .LANCHOR120
	mov	w0, 2000
	adrp	x6, .LANCHOR118
	adrp	x8, .LANCHOR148
	strh	w0, [x7, #:lo12:.LANCHOR120]
	mov	w0, 50
	adrp	x2, .LANCHOR147
	strh	w0, [x6, #:lo12:.LANCHOR118]
	mov	w0, 256
	strh	w0, [x8, #:lo12:.LANCHOR148]
	mov	w0, 48
	strh	w0, [x2, #:lo12:.LANCHOR147]
	adrp	x0, .LANCHOR8
	mov	w3, 32
	cmp	w5, 2
	mov	x11, x6
	strh	w3, [x0, #:lo12:.LANCHOR8]
	mov	x5, x7
	mov	x10, x2
	beq	.L3093
	adrp	x12, .LANCHOR77
	ldrb	w12, [x12, #:lo12:.LANCHOR77]
	cbz	w12, .L3094
.L3093:
	mov	w2, 150
	strh	w2, [x11, #:lo12:.LANCHOR118]
	mov	w2, 64
	strh	w2, [x10, #:lo12:.LANCHOR147]
	mov	w2, 12
	strh	w2, [x0, #:lo12:.LANCHOR8]
	adrp	x2, .LANCHOR0
	ldrb	w2, [x2, #:lo12:.LANCHOR0]
	cbnz	w2, .L3096
	mov	w2, 4
	strh	w2, [x0, #:lo12:.LANCHOR8]
	mov	w0, 600
	strh	w0, [x5, #:lo12:.LANCHOR120]
	mov	w0, 128
	strh	w0, [x8, #:lo12:.LANCHOR148]
.L3096:
	adrp	x19, .LANCHOR14
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L3098
	str	x4, [x29, 96]
	adrp	x0, .LC203
	add	x0, x0, :lo12:.LC203
	bl	printf
	ldr	x4, [x29, 96]
.L3098:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L3099
	ldr	w1, [x4, #:lo12:.LANCHOR212]
	adrp	x0, .LC204
	add	x0, x0, :lo12:.LC204
	bl	printf
.L3099:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L3100
	ldr	w1, [x28, #:lo12:.LANCHOR122]
	adrp	x0, .LC205
	add	x0, x0, :lo12:.LC205
	bl	printf
.L3100:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L3101
	ldr	w1, [x27, #:lo12:.LANCHOR213]
	adrp	x0, .LC206
	add	x0, x0, :lo12:.LC206
	bl	printf
.L3101:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L3102
	ldrh	w1, [x24, #:lo12:.LANCHOR194]
	adrp	x0, .LC207
	add	x0, x0, :lo12:.LC207
	bl	printf
.L3102:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L3103
	ldrh	w1, [x20, #:lo12:.LANCHOR208]
	adrp	x0, .LC208
	add	x0, x0, :lo12:.LC208
	bl	printf
.L3103:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L3104
	ldrh	w1, [x26, #:lo12:.LANCHOR149]
	adrp	x0, .LC209
	add	x0, x0, :lo12:.LC209
	bl	printf
.L3104:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L3105
	ldrh	w1, [x25, #:lo12:.LANCHOR91]
	adrp	x0, .LC210
	add	x0, x0, :lo12:.LC210
	bl	printf
.L3105:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L3106
	ldr	x0, [x29, 104]
	ldrh	w1, [x0, #:lo12:.LANCHOR95]
	adrp	x0, .LC211
	add	x0, x0, :lo12:.LC211
	bl	printf
.L3106:
	bl	zbuf_init
	adrp	x25, .LANCHOR10
	ldrh	w1, [x23, #:lo12:.LANCHOR6]
	mov	w0, 6
	mul	w0, w1, w0
	bl	ftl_malloc
	adrp	x1, .LANCHOR4
	str	x0, [x1, #:lo12:.LANCHOR4]
	ldrb	w1, [x21, #:lo12:.LANCHOR80]
	ldrh	w0, [x22, #:lo12:.LANCHOR87]
	mul	w0, w0, w1
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR112
	adrp	x2, ftl_ext_info_data_buffer
	add	x2, x2, :lo12:ftl_ext_info_data_buffer
	str	x0, [x1, #:lo12:.LANCHOR112]
	adrp	x0, .LANCHOR111
	ldrh	w1, [x22, #:lo12:.LANCHOR87]
	str	x2, [x0, #:lo12:.LANCHOR111]
	ldrb	w0, [x21, #:lo12:.LANCHOR80]
	mul	w1, w1, w0
	lsl	w0, w1, 1
	adrp	x1, .LANCHOR9
	add	x3, x2, x0, sxtw 2
	str	x3, [x1, #:lo12:.LANCHOR9]
	ldrh	w1, [x23, #:lo12:.LANCHOR6]
	add	w1, w0, w1, lsr 1
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	add	x1, x2, x1, sxtw 2
	str	x1, [x25, #:lo12:.LANCHOR10]
	tbz	x0, 12, .L3107
	adrp	x0, .LC212
	add	x0, x0, :lo12:.LC212
	bl	printf
.L3107:
	ldrh	w0, [x22, #:lo12:.LANCHOR87]
	ldrb	w21, [x21, #:lo12:.LANCHOR80]
	ldrh	w1, [x23, #:lo12:.LANCHOR6]
	ldrh	w22, [x24, #:lo12:.LANCHOR194]
	mul	w21, w0, w21
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	add	w21, w1, w21, lsl 2
	lsl	w1, w1, 2
	lsl	w21, w21, 1
	add	w22, w1, w22, lsl 2
	add	w21, w21, 632
	add	w22, w22, 704
	tbz	x0, 12, .L3108
	ldrh	w3, [x20, #:lo12:.LANCHOR208]
	adrp	x0, .LC213
	mov	w2, w22
	mov	w1, w21
	add	x0, x0, :lo12:.LC213
	bl	printf
.L3108:
	ldrh	w0, [x20, #:lo12:.LANCHOR208]
	cmp	w21, w0
	bhi	.L3109
	cmp	w22, w0
	bls	.L3110
.L3109:
.L3156:
	b	.L3156
.L3089:
	add	w1, w1, 1
	lsl	w3, w3, 1
	and	w1, w1, 65535
	b	.L3088
.L3091:
	add	w4, w4, 1
	lsl	w1, w1, 1
	and	w4, w4, 65535
	b	.L3090
.L3094:
	adrp	x0, .LANCHOR35
	ldrb	w0, [x0, #:lo12:.LANCHOR35]
	cbz	w0, .L3096
	mov	w0, 1200
	strh	w3, [x6, #:lo12:.LANCHOR118]
	strh	w0, [x7, #:lo12:.LANCHOR120]
	strh	w3, [x2, #:lo12:.LANCHOR147]
	b	.L3096
.L3110:
	bl	sblk_init
	bl	ftl_info_blk_init
	cmn	w0, #1
	beq	.L3087
	bl	ftl_ext_info_init
	adrp	x19, .LANCHOR104
	bl	gc_init
	mov	w0, 1
	bl	pm_init
	bl	lpa_rebuild_hash
	ldr	x0, [x25, #:lo12:.LANCHOR10]
	mov	x1, 0
	add	x0, x0, 16
	bl	ftl_open_sblk_recovery
	ldr	x0, [x25, #:lo12:.LANCHOR10]
	add	x1, x0, 16
	add	x0, x0, 48
	bl	ftl_open_sblk_recovery
	ldr	x1, [x19, #:lo12:.LANCHOR104]
	ldr	w0, [x1, 8]
	add	w0, w0, 16
	str	w0, [x1, 8]
	ldr	x0, [x25, #:lo12:.LANCHOR10]
	add	x0, x0, 16
	bl	ftl_info_data_recovery
	ldr	x0, [x25, #:lo12:.LANCHOR10]
	add	x0, x0, 48
	bl	ftl_info_data_recovery
	ldr	x0, [x25, #:lo12:.LANCHOR10]
	add	x0, x0, 80
	bl	ftl_info_data_recovery
	bl	gc_recovery
	bl	pm_flush
	mov	w0, 1
	bl	ftl_total_vpn_update
	adrp	x0, .LANCHOR185
	ldrb	w0, [x0, #:lo12:.LANCHOR185]
	cbz	w0, .L3112
	ldr	x1, [x19, #:lo12:.LANCHOR104]
	ldr	w0, [x1, 68]
	add	w0, w0, 1
	str	w0, [x1, 68]
.L3112:
	bl	ftl_ext_info_flush
	mov	w0, 0
	bl	ftl_info_flush
	bl	print_ftl_debug_info
	mov	w0, 0
.L3087:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
	.size	zftl_init, .-zftl_init
	.section	.text.rk_ftl_init,"ax",@progbits
	.align	2
	.global	rk_ftl_init
	.type	rk_ftl_init, %function
rk_ftl_init:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	str	x19, [sp, 16]
	bl	nand_flash_init
	cbnz	w0, .L3160
	bl	zftl_init
.L3160:
	mov	w19, w0
	bl	idb_init
	mov	w1, w19
	adrp	x0, .LC214
	add	x0, x0, :lo12:.LC214
	bl	printf
	mov	w0, w19
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	rk_ftl_init, .-rk_ftl_init
	.section	.text.gc_update_l2p_map_new,"ax",@progbits
	.align	2
	.global	gc_update_l2p_map_new
	.type	gc_update_l2p_map_new, %function
gc_update_l2p_map_new:
	stp	x29, x30, [sp, -176]!
	adrp	x0, .LANCHOR10
	adrp	x1, .LANCHOR79
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	ldr	x21, [x0, #:lo12:.LANCHOR10]
	stp	x25, x26, [sp, 64]
	ldrh	w26, [x1, #:lo12:.LANCHOR79]
	add	x1, x21, 80
	stp	x23, x24, [sp, 48]
	adrp	x24, .LANCHOR14
	stp	x19, x20, [sp, 16]
	stp	x27, x28, [sp, 80]
	stp	x0, x1, [x29, 128]
	ldrb	w1, [x1, 9]
	mul	w26, w26, w1
	ldr	w1, [x24, #:lo12:.LANCHOR14]
	tbz	x1, 8, .L3163
	ldrh	w1, [x21, 80]
	adrp	x0, .LC215
	add	x0, x0, :lo12:.LC215
	bl	printf
.L3163:
	adrp	x23, .LANCHOR9
	ldrh	w1, [x21, 80]
	sub	w2, w26, #1
	mov	x22, 0
	ldr	x0, [x23, #:lo12:.LANCHOR9]
	mov	w25, 0
	strh	w2, [x0, x1, lsl 1]
	adrp	x0, .LANCHOR125
	add	x0, x0, :lo12:.LANCHOR125
	str	x0, [x29, 104]
.L3164:
	mov	w28, w22
	cmp	w26, w22
	bhi	.L3174
	ldr	w0, [x24, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L3175
	ldr	x0, [x29, 128]
	mov	w3, w25
	ldr	x1, [x23, #:lo12:.LANCHOR9]
	ldrh	w2, [x21, 80]
	ldr	x0, [x0, #:lo12:.LANCHOR10]
	ldrh	w2, [x1, x2, lsl 1]
	ldrh	w1, [x0, 80]
	adrp	x0, .LC218
	add	x0, x0, :lo12:.LC218
	bl	printf
.L3175:
	ldrh	w1, [x21, 80]
	ldr	x0, [x23, #:lo12:.LANCHOR9]
	ldrh	w0, [x0, x1, lsl 1]
	cmp	w25, w0
	beq	.L3176
	adrp	x1, .LANCHOR214
	adrp	x0, .LC0
	mov	w2, 748
	add	x1, x1, :lo12:.LANCHOR214
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3176:
	ldrh	w1, [x21, 80]
	ldr	x0, [x23, #:lo12:.LANCHOR9]
	strh	w25, [x0, x1, lsl 1]
	ldrh	w0, [x21, 80]
	bl	zftl_insert_data_list
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L3174:
	adrp	x27, .LANCHOR155
	lsl	x19, x22, 2
	ldr	x0, [x27, #:lo12:.LANCHOR155]
	ldr	w2, [x0, x19]
	cmn	w2, #1
	beq	.L3165
	adrp	x0, .LANCHOR125
	ldrb	w20, [x0, #:lo12:.LANCHOR125]
	lsl	w20, w20, 7
	udiv	w20, w2, w20
	and	w0, w20, 65535
	str	w0, [x29, 156]
	ldr	w0, [x24, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L3166
	ldr	w1, [x29, 156]
	adrp	x0, .LC216
	mov	w3, w22
	add	x0, x0, :lo12:.LC216
	bl	printf
.L3166:
	sub	w28, w26, w28
	add	x28, x28, x22
	lsl	x0, x28, 2
	str	x0, [x29, 144]
	adrp	x0, .LC217
	add	x0, x0, :lo12:.LC217
	str	x0, [x29, 120]
	adrp	x0, .LANCHOR68
	add	x0, x0, :lo12:.LANCHOR68
	str	x0, [x29, 112]
.L3167:
	ldr	x0, [x29, 144]
	cmp	x0, x19
	bne	.L3173
.L3165:
	add	x22, x22, 1
	b	.L3164
.L3173:
	ldr	x0, [x27, #:lo12:.LANCHOR155]
	ldr	w20, [x0, x19]
	cmn	w20, #1
	beq	.L3168
	ldr	x0, [x29, 104]
	ldr	w1, [x29, 156]
	ldrb	w0, [x0]
	lsl	w0, w0, 7
	udiv	w0, w20, w0
	cmp	w1, w0, uxth
	bne	.L3168
	adrp	x0, .LANCHOR156
	ldr	x0, [x0, #:lo12:.LANCHOR156]
	ldr	w28, [x0, x19]
	mov	w0, w20
	bl	lpa_hash_get_ppa
	str	w0, [x29, 172]
	cmn	w0, #1
	bne	.L3169
	mov	w2, 0
	add	x1, x29, 172
	mov	w0, w20
	bl	pm_log2phys
.L3169:
	ldr	w3, [x29, 172]
	cmp	w28, w3
	bne	.L3170
	adrp	x0, .LANCHOR157
	mov	w2, 1
	add	x1, x29, 168
	add	w25, w25, 1
	ldr	x0, [x0, #:lo12:.LANCHOR157]
	ldr	w0, [x0, x19]
	str	w0, [x29, 168]
	mov	w0, w20
	bl	pm_log2phys
	ldr	x0, [x29, 112]
	ldrh	w2, [x0]
	adrp	x0, .LANCHOR31
	ldrb	w1, [x0, #:lo12:.LANCHOR31]
	mov	w0, 24
	lsr	w28, w28, w2
	sub	w0, w0, w1
	sub	w1, w0, w2
	mov	w0, 1
	lsl	w0, w0, w1
	sub	w0, w0, #1
	and	w28, w0, w28
	adrp	x0, .LANCHOR69
	ldrb	w0, [x0, #:lo12:.LANCHOR69]
	udiv	w0, w28, w0
.L3196:
	bl	ftl_vpn_decrement
	ldr	x0, [x27, #:lo12:.LANCHOR155]
	mov	w1, -1
	str	w1, [x0, x19]
.L3168:
	add	x19, x19, 4
	b	.L3167
.L3170:
	ldr	w0, [x24, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L3172
	ldr	x0, [x29, 120]
	mov	w2, w28
	mov	w1, w20
	bl	printf
.L3172:
	ldr	x0, [x29, 136]
	ldrh	w0, [x0]
	b	.L3196
	.size	gc_update_l2p_map_new, .-gc_update_l2p_map_new
	.section	.text.gc_scan_src_blk_one_page,"ax",@progbits
	.align	2
	.global	gc_scan_src_blk_one_page
	.type	gc_scan_src_blk_one_page, %function
gc_scan_src_blk_one_page:
	stp	x29, x30, [sp, -96]!
	mov	w3, 0
	mov	w4, 0
	mov	w5, 65535
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR64
	add	x1, x19, :lo12:.LANCHOR64
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	adrp	x22, .LANCHOR80
	stp	x25, x26, [sp, 64]
	ldrb	w6, [x22, #:lo12:.LANCHOR80]
	ldrb	w0, [x1, 4]
	add	x2, x1, x0, sxtw 1
	ldrh	w23, [x2, 40]
	ldrh	w2, [x1, 2]
.L3198:
	cmp	w23, w5
	beq	.L3200
	cbz	w4, .L3201
	add	x1, x19, :lo12:.LANCHOR64
	strh	w2, [x1, 2]
.L3201:
	cbz	w3, .L3202
	add	x1, x19, :lo12:.LANCHOR64
	strb	w0, [x1, 4]
.L3202:
	mov	w0, 1
	adrp	x24, .LANCHOR105
	bl	buf_alloc
	adrp	x25, .LANCHOR73
	mov	x21, x0
	add	x24, x24, :lo12:.LANCHOR105
	add	x25, x25, :lo12:.LANCHOR73
	mov	w26, 1
.L3203:
	add	x20, x19, :lo12:.LANCHOR64
	ldrb	w1, [x20, 6]
	cmp	w26, w1
	ble	.L3212
	mov	x0, x21
	bl	zbuf_free
	ldrb	w0, [x20, 4]
	ldrb	w1, [x22, #:lo12:.LANCHOR80]
	add	w0, w0, 1
	and	w0, w0, 255
	strb	w0, [x20, 4]
	cmp	w1, w0
	bne	.L3197
	ldrh	w0, [x20, 2]
	strb	wzr, [x20, 4]
	add	w0, w0, 1
	strh	w0, [x20, 2]
.L3197:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L3200:
	add	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, w6
	bne	.L3199
	add	w2, w2, 1
	mov	w0, 0
	and	w2, w2, 65535
	mov	w4, 1
.L3199:
	add	x3, x1, x0, sxtw 1
	ldrh	w23, [x3, 40]
	mov	w3, 1
	b	.L3198
.L3212:
	ldrh	w0, [x24]
	cmp	w1, 2
	mul	w0, w0, w23
	beq	.L3204
	cmp	w1, 3
	bne	.L3205
	adrp	x1, .LANCHOR35
	ldrb	w1, [x1, #:lo12:.LANCHOR35]
	cbz	w1, .L3206
.L3204:
	add	x1, x19, :lo12:.LANCHOR64
	add	w0, w26, w0
	ldrh	w1, [x1, 2]
	lsl	w1, w1, 1
	sub	w1, w1, #1
	add	w0, w1, w0
	ldrb	w1, [x25]
	orr	w0, w0, w1, lsl 24
.L3224:
	str	w0, [x21, 40]
	mov	w1, 1
	mov	x0, x21
	bl	sblk_read_page
	ldr	w0, [x21, 52]
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	beq	.L3209
	ldr	x0, [x21, 24]
	ldr	w20, [x0, 4]
	mov	w0, w20
	bl	lpa_hash_get_ppa
	str	w0, [x29, 92]
	cmn	w0, #1
	bne	.L3210
	adrp	x0, .LANCHOR122
	ldr	w0, [x0, #:lo12:.LANCHOR122]
	cmp	w20, w0
	bcs	.L3210
	mov	w2, 0
	add	x1, x29, 92
	mov	w0, w20
	bl	pm_log2phys
.L3210:
	ldr	w2, [x21, 40]
	ldr	w0, [x29, 92]
	cmp	w2, w0
	bne	.L3209
	add	x1, x19, :lo12:.LANCHOR64
	adrp	x4, .LANCHOR70
	ldr	x4, [x4, #:lo12:.LANCHOR70]
	ldrh	w0, [x1, 24]
	ubfiz	x3, x0, 2, 16
	add	w0, w0, 1
	str	w2, [x4, x3]
	strh	w0, [x1, 24]
.L3209:
	add	x1, x19, :lo12:.LANCHOR64
	add	w26, w26, 1
	ldrh	w0, [x1, 26]
	add	w0, w0, 1
	strh	w0, [x1, 26]
	b	.L3203
.L3206:
	ldrh	w1, [x20, 2]
	add	w0, w1, w0
	orr	w0, w0, w26, lsl 24
	b	.L3224
.L3205:
	ldrh	w1, [x20, 2]
	add	w0, w1, w0
	b	.L3224
	.size	gc_scan_src_blk_one_page, .-gc_scan_src_blk_one_page
	.section	.text.gc_scan_src_blk,"ax",@progbits
	.align	2
	.global	gc_scan_src_blk
	.type	gc_scan_src_blk, %function
gc_scan_src_blk:
	stp	x29, x30, [sp, -96]!
	mov	w0, 65535
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR64
	stp	x21, x22, [sp, 32]
	ldrh	w1, [x19, #:lo12:.LANCHOR64]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	cmp	w1, w0
	bne	.L3226
	adrp	x1, .LANCHOR215
	adrp	x0, .LC0
	mov	w2, 1235
	add	x1, x1, :lo12:.LANCHOR215
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3226:
	ldrh	w1, [x19, #:lo12:.LANCHOR64]
	mov	w0, 65535
	cmp	w1, w0
	beq	.L3246
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L3228
	adrp	x2, .LANCHOR9
	ubfiz	x0, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR9]
	ldrh	w2, [x2, x0]
	adrp	x0, .LC219
	add	x0, x0, :lo12:.LC219
	bl	printf
.L3228:
	ldrh	w0, [x19, #:lo12:.LANCHOR64]
	add	x14, x19, :lo12:.LANCHOR64
	add	x1, x14, 40
	bl	ftl_get_blk_list_in_sblk
	and	w1, w0, 255
	strb	w1, [x14, 5]
	cbnz	w1, .L3229
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR64]
.L3246:
	mov	w0, 0
	b	.L3225
.L3229:
	adrp	x4, .LANCHOR7
	ldrh	w3, [x19, #:lo12:.LANCHOR64]
	mov	x22, x4
	ldr	x1, [x4, #:lo12:.LANCHOR7]
	mov	x2, x3
	add	x1, x1, x3, lsl 2
	ldrb	w1, [x1, 2]
	and	w1, w1, 224
	cmp	w1, 32
	beq	.L3230
	cmp	w1, 224
	beq	.L3230
	cbz	w1, .L3231
	adrp	x1, .LANCHOR10
	ldr	x1, [x1, #:lo12:.LANCHOR10]
	ldrh	w3, [x1, 16]
	cmp	w3, w2
	beq	.L3230
	ldrh	w3, [x1, 48]
	cmp	w3, w2
	beq	.L3230
	ldrh	w1, [x1, 80]
	cmp	w1, w2
	bne	.L3263
.L3230:
	add	x0, x19, :lo12:.LANCHOR64
	mov	w1, -1
	strh	w1, [x19, #:lo12:.LANCHOR64]
	strh	wzr, [x0, 24]
	b	.L3246
.L3231:
	adrp	x0, .LANCHOR9
	mov	x20, x0
	ldr	x1, [x0, #:lo12:.LANCHOR9]
	ldrh	w1, [x1, x3, lsl 1]
	cbz	w1, .L3233
	adrp	x1, .LANCHOR215
	adrp	x0, .LC0
	mov	w2, 1255
	add	x1, x1, :lo12:.LANCHOR215
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3233:
	ldrh	w1, [x19, #:lo12:.LANCHOR64]
	ldr	x0, [x20, #:lo12:.LANCHOR9]
	strh	wzr, [x0, x1, lsl 1]
	b	.L3230
.L3263:
	and	w0, w0, 255
	sub	w0, w0, #1
	add	x0, x14, x0, sxtw 1
	ldrh	w21, [x0, 40]
	mov	w0, 65535
	cmp	w21, w0
	bne	.L3234
	adrp	x1, .LANCHOR215
	adrp	x0, .LC0
	mov	w2, 1263
	add	x1, x1, :lo12:.LANCHOR215
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3234:
	adrp	x1, .LANCHOR105
	ldr	x3, [x22, #:lo12:.LANCHOR7]
	adrp	x2, .LANCHOR87
	mov	x24, x2
	ldrh	w20, [x1, #:lo12:.LANCHOR105]
	ldrh	w1, [x19, #:lo12:.LANCHOR64]
	ldrh	w0, [x2, #:lo12:.LANCHOR87]
	add	x1, x3, x1, lsl 2
	sub	w0, w0, #1
	mul	w20, w20, w21
	and	w0, w0, 65535
	adrp	x21, .LANCHOR79
	ldrb	w1, [x1, 2]
	and	w1, w1, 224
	cmp	w1, 160
	bne	.L3247
	adrp	x1, .LANCHOR73
	ldrb	w1, [x1, #:lo12:.LANCHOR73]
	and	w23, w1, 65535
	cmp	w1, 2
	orr	w20, w20, w1, lsl 24
	bne	.L3236
	ldrh	w0, [x21, #:lo12:.LANCHOR79]
	sub	w0, w0, #1
	and	w0, w0, 65535
.L3236:
	adrp	x1, .LANCHOR35
	ldrb	w1, [x1, #:lo12:.LANCHOR35]
	cbz	w1, .L3235
	ldrh	w0, [x21, #:lo12:.LANCHOR79]
	sub	w0, w0, #1
	and	w0, w0, 65535
.L3235:
	add	x22, x19, :lo12:.LANCHOR64
	orr	w20, w0, w20
	mov	w0, 1
	strb	w23, [x22, 6]
	strh	wzr, [x22, 2]
	strb	wzr, [x22, 4]
	strh	wzr, [x22, 26]
	strh	wzr, [x22, 28]
	bl	buf_alloc
	str	w20, [x0, 40]
	adrp	x20, .LANCHOR80
	mov	x25, x0
	mov	w1, 1
	bl	sblk_read_page
	ldrh	w2, [x21, #:lo12:.LANCHOR79]
	adrp	x21, .LANCHOR70
	ldrb	w0, [x20, #:lo12:.LANCHOR80]
	mov	w1, 255
	mul	w2, w2, w0
	ldr	x0, [x21, #:lo12:.LANCHOR70]
	lsl	w2, w2, 2
	bl	ftl_memset
	strh	wzr, [x22, 24]
	ldr	w0, [x25, 52]
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	bne	.L3237
.L3265:
	mov	x0, x25
	bl	zbuf_free
	mov	w0, -1
.L3225:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L3247:
	mov	w23, 1
	b	.L3235
.L3237:
	ldr	x0, [x25, 24]
	ldr	w1, [x0]
	mov	w0, 15555
	movk	w0, 0xf55f, lsl 16
	cmp	w1, w0
	beq	.L3238
	mov	w2, 1298
	adrp	x1, .LANCHOR215
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR215
	add	x0, x0, :lo12:.LC0
	bl	printf
	b	.L3265
.L3238:
	ldrh	w0, [x24, #:lo12:.LANCHOR87]
	adrp	x22, .LANCHOR68
	ldrb	w20, [x20, #:lo12:.LANCHOR80]
	add	x22, x22, :lo12:.LANCHOR68
	ldr	x24, [x25, 8]
	mov	x26, 0
	mul	w20, w20, w0
	mul	w20, w23, w20
	adrp	x23, .LANCHOR31
	add	x23, x23, :lo12:.LANCHOR31
	and	w20, w20, 65535
.L3239:
	cmp	w20, w26
	bgt	.L3244
	mov	x0, x25
	bl	zbuf_free
	adrp	x0, .LANCHOR9
	ldrh	w1, [x19, #:lo12:.LANCHOR64]
	add	x3, x19, :lo12:.LANCHOR64
	mov	x20, x0
	ldr	x4, [x0, #:lo12:.LANCHOR9]
	ubfiz	x2, x1, 1, 16
	ldrh	w3, [x3, 24]
	ldrh	w2, [x4, x2]
	cmp	w2, w3
	beq	.L3245
	adrp	x0, .LC220
	add	x0, x0, :lo12:.LC220
	bl	printf
.L3245:
	add	x0, x19, :lo12:.LANCHOR64
	ldrh	w2, [x19, #:lo12:.LANCHOR64]
	ldr	x1, [x20, #:lo12:.LANCHOR9]
	ldrh	w3, [x0, 24]
	strh	w3, [x1, x2, lsl 1]
	strh	wzr, [x0, 28]
	ldrh	w0, [x0, 24]
	b	.L3225
.L3244:
	ldr	w0, [x24, x26, lsl 2]
	cmn	w0, #1
	beq	.L3241
	bl	lpa_hash_get_ppa
	str	w0, [x29, 92]
	cmn	w0, #1
	bne	.L3242
	ldr	w0, [x24, x26, lsl 2]
	mov	w2, 0
	add	x1, x29, 92
	bl	pm_log2phys
.L3242:
	ldrb	w0, [x23]
	mov	w1, 24
	ldrh	w2, [x22]
	sub	w0, w1, w0
	ldr	w3, [x29, 92]
	sub	w1, w0, w2
	mov	w0, 1
	lsl	w0, w0, w1
	adrp	x1, .LANCHOR69
	sub	w0, w0, #1
	lsr	w2, w3, w2
	ldrb	w1, [x1, #:lo12:.LANCHOR69]
	and	w0, w0, w2
	ldrh	w2, [x19, #:lo12:.LANCHOR64]
	udiv	w0, w0, w1
	add	x1, x19, :lo12:.LANCHOR64
	cmp	w0, w2
	bne	.L3241
	ldrh	w0, [x1, 24]
	ldr	x4, [x21, #:lo12:.LANCHOR70]
	ubfiz	x2, x0, 2, 16
	add	w0, w0, 1
	str	w3, [x4, x2]
	strh	w0, [x1, 24]
.L3241:
	add	x26, x26, 1
	b	.L3239
	.size	gc_scan_src_blk, .-gc_scan_src_blk
	.section	.text.gc_scan_static_data,"ax",@progbits
	.align	2
	.global	gc_scan_static_data
	.type	gc_scan_static_data, %function
gc_scan_static_data:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR10
	stp	x21, x22, [sp, 32]
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	ldr	w1, [x0, 544]
	str	x23, [sp, 48]
	cmn	w1, #1
	beq	.L3267
	adrp	x21, .LANCHOR216
	adrp	x22, .LC0
	add	x21, x21, :lo12:.LANCHOR216
	add	x22, x22, :lo12:.LC0
	mov	w20, 11
.L3275:
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	mov	w2, 0
	add	x1, x29, 76
	ldr	w0, [x0, 544]
	bl	pm_log2phys
	ldr	w0, [x29, 76]
	cmn	w0, #1
	beq	.L3268
	mov	w0, 1
	bl	buf_alloc
	ldr	w1, [x29, 76]
	mov	x23, x0
	str	w1, [x0, 40]
	mov	w1, 1
	bl	sblk_read_page
	ldr	w0, [x23, 52]
	cmp	w0, 256
	bne	.L3269
	adrp	x0, .LANCHOR68
	ldr	w2, [x29, 76]
	ldrh	w3, [x0, #:lo12:.LANCHOR68]
	adrp	x0, .LANCHOR31
	ldrb	w1, [x0, #:lo12:.LANCHOR31]
	mov	w0, 24
	lsr	w2, w2, w3
	sub	w0, w0, w1
	mov	w1, 1
	sub	w0, w0, w3
	lsl	w0, w1, w0
	sub	w0, w0, #1
	and	w0, w0, w2
	adrp	x2, .LANCHOR69
	ldrb	w3, [x2, #:lo12:.LANCHOR69]
	mov	w2, 0
	udiv	w0, w0, w3
	bl	gc_add_sblk
.L3269:
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	ldr	x1, [x23, 24]
	ldr	w0, [x0, 544]
	ldr	w1, [x1, 4]
	cmp	w1, w0
	beq	.L3270
	mov	w2, 1737
	mov	x1, x21
	mov	x0, x22
	bl	printf
.L3270:
	mov	x0, x23
	bl	zbuf_free
.L3268:
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	adrp	x2, .LANCHOR122
	ldr	w2, [x2, #:lo12:.LANCHOR122]
	ldr	w1, [x0, 544]
	add	w1, w1, 1
	str	w1, [x0, 544]
	cmp	w1, w2
	bcc	.L3271
	mov	w1, -1
	str	w1, [x0, 544]
	ldr	w1, [x0, 548]
	add	w1, w1, 1
	str	w1, [x0, 548]
	bl	ftl_flush
	bl	pm_flush
	bl	ftl_ext_info_flush
	mov	w0, 0
	bl	ftl_info_flush
.L3266:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L3271:
	ldr	w0, [x29, 76]
	cmn	w0, #1
	bne	.L3266
	sub	w20, w20, #1
	ands	w20, w20, 65535
	bne	.L3275
	b	.L3266
.L3267:
	ldr	w1, [x0, 536]
	adrp	x3, .LANCHOR104
	ldr	w2, [x0, 12]
	add	w1, w1, 12959744
	add	w1, w1, 256
	cmp	w2, w1
	bhi	.L3277
	ldr	x4, [x3, #:lo12:.LANCHOR104]
	mov	w5, 5000
	ldr	w1, [x0, 540]
	add	w1, w1, w5
	ldr	w4, [x4, 44]
	cmp	w4, w1
	bls	.L3266
.L3277:
	ldr	x1, [x3, #:lo12:.LANCHOR104]
	ldr	w1, [x1, 44]
	str	w1, [x0, 540]
	str	w2, [x0, 536]
	str	wzr, [x0, 544]
	b	.L3266
	.size	gc_scan_static_data, .-gc_scan_static_data
	.section	.text.ftl_sblk_dump,"ax",@progbits
	.align	2
	.global	ftl_sblk_dump
	.type	ftl_sblk_dump, %function
ftl_sblk_dump:
	sub	sp, sp, #288
	and	x0, x0, 65535
	stp	x29, x30, [sp, 48]
	add	x29, sp, 48
	stp	x23, x24, [sp, 96]
	adrp	x24, .LANCHOR7
	lsl	x23, x0, 2
	stp	x19, x20, [sp, 64]
	str	x0, [x29, 144]
	mov	x20, x0
	ldr	x0, [x24, #:lo12:.LANCHOR7]
	str	x1, [x29, 160]
	add	x1, x0, x23
	stp	x21, x22, [sp, 80]
	stp	x25, x26, [sp, 112]
	ldr	w5, [x0, x23]
	ldrb	w2, [x1, 2]
	mov	w1, w20
	ldrh	w4, [x0, x23]
	adrp	x0, .LC221
	stp	x27, x28, [sp, 128]
	ubfx	x5, x5, 11, 8
	ubfx	x3, x2, 3, 2
	and	w4, w4, 2047
	ubfx	x2, x2, 5, 3
	add	x0, x0, :lo12:.LC221
	bl	printf
	mov	w0, 65535
	cmp	w20, w0
	beq	.L3305
	adrp	x0, .LANCHOR6
	ldrh	w0, [x0, #:lo12:.LANCHOR6]
	cmp	w0, w20
	bls	.L3305
	ldr	x0, [x24, #:lo12:.LANCHOR7]
	add	x0, x0, x23
	ldrb	w0, [x0, 2]
	and	w0, w0, 224
	cmp	w0, 160
	bne	.L3306
	adrp	x0, .LANCHOR73
	ldrb	w25, [x0, #:lo12:.LANCHOR73]
.L3285:
	add	x28, x29, 240
	adrp	x21, .LANCHOR87
	mov	w0, w20
	mov	w19, 0
	strh	w20, [x28, -32]!
	add	x1, x28, 16
	bl	ftl_get_blk_list_in_sblk
	ldrh	w2, [x21, #:lo12:.LANCHOR87]
	and	w1, w0, 255
	strb	w1, [x29, 217]
	and	w4, w0, 255
	strb	wzr, [x29, 213]
	mov	w3, w25
	strh	wzr, [x29, 210]
	adrp	x0, .LC222
	mul	w1, w1, w2
	strh	wzr, [x29, 218]
	strh	w1, [x29, 214]
	add	x0, x0, :lo12:.LC222
	ldr	x1, [x24, #:lo12:.LANCHOR7]
	add	x1, x1, x23
	ldrb	w2, [x1, 2]
	mov	w1, w20
	ubfx	x2, x2, 5, 3
	bl	printf
	mov	w0, 1
	bl	buf_alloc
	str	x21, [x29, 136]
	mov	x26, x0
	stp	wzr, wzr, [x29, 168]
	adrp	x0, .LANCHOR105
	str	wzr, [x29, 176]
	add	x0, x0, :lo12:.LANCHOR105
	str	x0, [x29, 112]
.L3286:
	ldr	x0, [x29, 136]
	ldrh	w0, [x0, #:lo12:.LANCHOR87]
	cmp	w0, w19
	bls	.L3302
	lsl	w0, w19, 1
	mov	w22, 0
	sub	w1, w0, #1
	add	w0, w0, w19
	sub	w0, w0, #1
	stp	w0, w1, [x29, 152]
	adrp	x0, .LC163
	add	x0, x0, :lo12:.LC163
	str	x0, [x29, 120]
	b	.L3303
.L3306:
	mov	w25, 1
	b	.L3285
.L3299:
	ldr	x0, [x29, 128]
	ldrh	w11, [x28, x0]
	mov	w0, 65535
	cmp	w11, w0
	beq	.L3287
	ldr	x0, [x29, 112]
	cmp	w25, 3
	ldrh	w8, [x0]
	mul	w8, w8, w11
	add	w0, w21, w8
	bne	.L3288
	adrp	x1, .LANCHOR35
	ldrb	w1, [x1, #:lo12:.LANCHOR35]
	cbz	w1, .L3289
	adrp	x1, .LANCHOR73
	ldrb	w8, [x1, #:lo12:.LANCHOR73]
	ldr	w1, [x29, 152]
.L3315:
	add	w0, w0, w1
	orr	w27, w0, w8, lsl 24
	b	.L3290
.L3289:
	add	w8, w19, w8
	orr	w27, w8, w21, lsl 24
.L3290:
	str	w27, [x26, 40]
	mov	w1, 1
	str	w11, [x29, 100]
	mov	x0, x26
	bl	sblk_read_page
	ldr	x1, [x26, 24]
	mov	w3, w27
	ldr	x0, [x26, 8]
	ldr	w12, [x26, 52]
	ldr	w11, [x29, 100]
	ldr	w2, [x1, 12]
	mov	w4, w12
	str	w2, [sp, 32]
	str	w12, [x29, 104]
	ldr	w2, [x1, 8]
	str	w2, [sp, 24]
	ldr	w2, [x1, 4]
	str	w2, [sp, 16]
	mov	w2, w19
	ldr	w1, [x1]
	str	w1, [sp, 8]
	ldr	w1, [x0, 12]
	str	w1, [sp]
	mov	w1, w11
	ldp	w5, w6, [x0]
	ldr	w7, [x0, 8]
	ldr	x0, [x29, 120]
	bl	printf
	ldr	w12, [x29, 104]
	mov	w1, 32
	ldr	w0, [x29, 168]
	cmp	w12, 512
	ccmn	w12, #1, 4, ne
	csinc	w0, w0, wzr, ne
	str	w0, [x29, 168]
	ldr	x0, [x24, #:lo12:.LANCHOR7]
	add	x0, x0, x23
	ldrb	w0, [x0, 2]
	and	w0, w0, 224
	cmp	w0, 224
	ccmp	w0, w1, 4, ne
	beq	.L3287
	ldr	x0, [x26, 24]
	ldr	w0, [x0, 4]
	bl	lpa_hash_get_ppa
	str	w0, [x29, 204]
	cmn	w0, #1
	bne	.L3293
	ldr	x0, [x26, 24]
	mov	w2, 0
	add	x1, x29, 204
	ldr	w0, [x0, 4]
	bl	pm_log2phys
.L3293:
	ldr	w0, [x29, 204]
	cmp	w27, w0
	bne	.L3294
	ldr	w0, [x29, 172]
	mov	w1, w27
	add	w0, w0, 1
	str	w0, [x29, 172]
	ldr	x0, [x26, 24]
	ldr	w3, [x29, 172]
	ldr	w2, [x0, 4]
	adrp	x0, .LC223
	add	x0, x0, :lo12:.LC223
	bl	printf
.L3294:
	ldr	x0, [x29, 160]
	cbz	x0, .L3296
	ldr	x0, [x29, 176]
	ubfiz	x3, x0, 2, 32
	ldr	x0, [x29, 160]
	ldr	w2, [x0, x3]
	ldr	x0, [x26, 24]
	ldr	w0, [x0, 4]
	cmp	w0, w2
	beq	.L3297
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L3297
	ldr	w1, [x29, 176]
	adrp	x0, .LC224
	str	x3, [x29, 104]
	add	x0, x0, :lo12:.LC224
	bl	printf
	ldr	x3, [x29, 104]
.L3297:
	ldr	x1, [x26, 24]
	ldr	x0, [x29, 160]
	ldr	w1, [x1, 4]
	ldr	w0, [x0, x3]
	cmp	w1, w0
	beq	.L3296
	cmn	w0, #1
	beq	.L3296
	adrp	x1, .LANCHOR217
	adrp	x0, .LC0
	mov	w2, 1383
	add	x1, x1, :lo12:.LANCHOR217
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3296:
	ldr	w0, [x29, 176]
	add	w0, w0, 1
	str	w0, [x29, 176]
.L3287:
	add	w21, w21, 1
	and	w21, w21, 65535
.L3301:
	cmp	w25, w21
	bcs	.L3299
	add	w22, w22, 1
	and	w22, w22, 65535
.L3303:
	ldrb	w0, [x29, 217]
	cmp	w0, w22
	bls	.L3300
	sxtw	x0, w22
	mov	w21, 1
	add	x0, x0, 8
	lsl	x0, x0, 1
	str	x0, [x29, 128]
	b	.L3301
.L3288:
	cmp	w25, 2
	bne	.L3291
	adrp	x1, .LANCHOR73
	ldrb	w8, [x1, #:lo12:.LANCHOR73]
	ldr	w1, [x29, 156]
	b	.L3315
.L3291:
	add	w27, w19, w8
	b	.L3290
.L3300:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L3286
.L3302:
	mov	x0, x26
	bl	zbuf_free
	adrp	x0, .LANCHOR9
	ldr	x1, [x29, 144]
	ldr	w3, [x29, 172]
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrh	w2, [x0, x1, lsl 1]
	mov	w1, w20
	adrp	x0, .LC225
	add	x0, x0, :lo12:.LC225
	bl	printf
	ldr	w0, [x29, 168]
.L3283:
	ldp	x19, x20, [sp, 64]
	ldp	x21, x22, [sp, 80]
	ldp	x23, x24, [sp, 96]
	ldp	x25, x26, [sp, 112]
	ldp	x27, x28, [sp, 128]
	ldp	x29, x30, [sp, 48]
	add	sp, sp, 288
	ret
.L3305:
	mov	w0, 0
	b	.L3283
	.size	ftl_sblk_dump, .-ftl_sblk_dump
	.section	.text.zftl_read,"ax",@progbits
	.align	2
	.global	zftl_read
	.type	zftl_read, %function
zftl_read:
	sub	sp, sp, #208
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	stp	x19, x20, [sp, 32]
	mov	w19, w0
	adrp	x0, .LANCHOR14
	stp	x21, x22, [sp, 48]
	stp	x25, x26, [sp, 80]
	mov	w20, w1
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	mov	w25, w2
	stp	x23, x24, [sp, 64]
	mov	x22, x3
	stp	x27, x28, [sp, 96]
	tbz	x0, 12, .L3317
	mov	w3, w2
	adrp	x0, .LC226
	mov	w2, w1
	add	x0, x0, :lo12:.LC226
	mov	w1, w19
	bl	printf
.L3317:
	cbnz	w19, .L3318
	adrp	x0, .LANCHOR61
	mov	w19, 24576
	ldr	w0, [x0, #:lo12:.LANCHOR61]
.L3319:
	add	w1, w20, w25
	cmp	w0, w1
	bcc	.L3348
	adrp	x1, .LANCHOR104
	adrp	x26, .LANCHOR125
	add	w19, w19, w20
	str	x1, [x29, 120]
	ldr	x2, [x1, #:lo12:.LANCHOR104]
	str	x26, [x29, 168]
	ldr	w0, [x2, 24]
	add	w0, w0, w25
	str	w0, [x2, 24]
	ldrb	w0, [x26, #:lo12:.LANCHOR125]
	add	w2, w25, w19
	stp	w2, wzr, [x29, 160]
	sub	w2, w2, #1
	udiv	w27, w19, w0
	udiv	w0, w2, w0
	mov	w20, w27
	sub	w24, w0, w27
	str	w0, [x29, 156]
	add	w24, w24, 1
	adrp	x0, .LANCHOR129
	add	x28, x0, :lo12:.LANCHOR129
.L3321:
	cbnz	w24, .L3346
	ldr	w0, [x29, 164]
.L3316:
	ldp	x19, x20, [sp, 32]
	ldp	x21, x22, [sp, 48]
	ldp	x23, x24, [sp, 64]
	ldp	x25, x26, [sp, 80]
	ldp	x27, x28, [sp, 96]
	ldp	x29, x30, [sp, 16]
	add	sp, sp, 208
	ret
.L3318:
	cmp	w19, 3
	bhi	.L3348
	lsl	w19, w19, 13
	mov	w0, 8192
	b	.L3319
.L3346:
	ldr	x0, [x29, 168]
	cmp	w20, w27
	ldrb	w1, [x0, #:lo12:.LANCHOR125]
	ldr	w0, [x29, 156]
	and	w23, w1, 65535
	ccmp	w20, w0, 4, ne
	bne	.L3349
	cmp	w20, w27
	bne	.L3323
	udiv	w3, w19, w1
	and	w0, w25, 65535
	msub	w1, w3, w1, w19
	and	w26, w1, 65535
	sub	w23, w23, w26
	and	w23, w23, 65535
	cmp	w25, w23
	csel	w23, w0, w23, cc
.L3322:
	adrp	x21, .LANCHOR52
	add	x1, x21, :lo12:.LANCHOR52
	add	x1, x1, 2
	mov	w0, 0
.L3326:
	ldr	w2, [x1, 34]
	cmp	w20, w2
	bne	.L3324
	ldrb	w2, [x1]
	tbz	x2, 3, .L3324
	add	x1, x21, :lo12:.LANCHOR52
	ubfiz	x0, x0, 6, 32
	add	x0, x1, x0
	lsl	w2, w23, 9
	ubfiz	x23, x23, 9, 16
	ubfiz	x26, x26, 9, 16
	ldr	x1, [x0, 8]
	mov	x0, x22
	add	x22, x22, x23
	add	x1, x1, x26
	bl	ftl_memcpy
.L3325:
	add	w20, w20, 1
	sub	w24, w24, #1
.L3332:
	adrp	x0, .LANCHOR54
	ldrb	w0, [x0, #:lo12:.LANCHOR54]
	cmp	w0, 2
	bls	.L3333
	cbnz	w24, .L3321
.L3333:
	adrp	x0, .LANCHOR129
	ldrb	w1, [x0, #:lo12:.LANCHOR129]
	cbz	w1, .L3321
	adrp	x23, .LANCHOR128
	add	x0, x21, :lo12:.LANCHOR52
	ldrb	w2, [x23, #:lo12:.LANCHOR128]
	add	x0, x0, x2, lsl 6
	bl	sblk_read_page
	adrp	x0, .LANCHOR218
	add	x0, x0, :lo12:.LANCHOR218
	str	x0, [x29, 136]
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	str	x0, [x29, 128]
.L3335:
	ldrb	w0, [x28]
	cbnz	w0, .L3345
	mov	w0, -1
	strb	wzr, [x28]
	strb	w0, [x23, #:lo12:.LANCHOR128]
	b	.L3321
.L3323:
	ldr	w0, [x29, 160]
	msub	w23, w1, w20, w0
	and	w23, w23, 255
.L3349:
	mov	w26, 0
	b	.L3322
.L3324:
	add	w0, w0, 1
	add	x1, x1, 64
	cmp	w0, 32
	bne	.L3326
	mov	w0, w20
	bl	lpa_hash_get_ppa
	str	w0, [x29, 188]
	cmn	w0, #1
	bne	.L3327
	mov	w2, 0
	add	x1, x29, 188
	mov	w0, w20
	bl	pm_log2phys
.L3327:
	ldr	w0, [x29, 188]
	cmn	w0, #1
	bne	.L3328
	ldr	x0, [x29, 168]
	mov	w23, 0
	add	x26, x0, :lo12:.LANCHOR125
.L3329:
	ldrb	w0, [x26]
	cmp	w23, w0
	bcs	.L3325
	madd	w0, w20, w0, w23
	cmp	w19, w0
	bhi	.L3330
	ldr	w1, [x29, 160]
	cmp	w1, w0
	bls	.L3330
	mov	x0, x22
	add	x22, x22, 512
	mov	w2, 512
	mov	w1, 0
	bl	ftl_memset
.L3330:
	add	w23, w23, 1
	b	.L3329
.L3328:
	mov	w0, 0
	bl	buf_alloc
	cbz	x0, .L3332
	ldr	x2, [x29, 120]
	ldr	x4, [x2, #:lo12:.LANCHOR104]
	ldr	w2, [x4, 40]
	add	w2, w2, 1
	str	w2, [x4, 40]
	ldr	w2, [x29, 188]
	strb	w23, [x0, 56]
	ubfiz	x23, x23, 9, 16
	str	x22, [x0, 16]
	add	x22, x22, x23
	strb	w26, [x0, 57]
	stp	w20, w2, [x0, 36]
	str	w2, [x0, 44]
	bl	zftl_add_read_buf
	b	.L3325
.L3345:
	ldrb	w0, [x23, #:lo12:.LANCHOR128]
	cmp	w0, 255
	bne	.L3336
	ldp	x0, x1, [x29, 128]
	mov	w2, 1088
	bl	printf
.L3336:
	ldrb	w26, [x23, #:lo12:.LANCHOR128]
	add	x0, x21, :lo12:.LANCHOR52
	ubfiz	x1, x26, 6, 8
	lsl	x2, x26, 6
	add	x1, x0, x1
	str	x1, [x29, 144]
	add	x1, x0, x2
	ldrb	w0, [x0, x2]
	strb	w0, [x23, #:lo12:.LANCHOR128]
	ldr	w10, [x1, 52]
	cmn	w10, #1
	bne	.L3337
	adrp	x0, .LANCHOR10
	str	w10, [x29, 164]
	ldr	x1, [x0, #:lo12:.LANCHOR10]
	ldr	w0, [x1, 552]
	add	w0, w0, 1
	str	w0, [x1, 552]
.L3338:
	add	x1, x21, :lo12:.LANCHOR52
	add	x1, x1, x26, lsl 6
	ldr	x0, [x1, 24]
	ldr	w3, [x1, 36]
	ldr	w1, [x0, 4]
	cmp	w1, w3
	bne	.L3339
	cmn	w10, #1
	bne	.L3340
.L3339:
	adrp	x1, .LANCHOR10
	add	x11, x21, :lo12:.LANCHOR52
	add	x11, x11, x26, lsl 6
	str	w10, [x29, 152]
	ldr	x2, [x1, #:lo12:.LANCHOR10]
	str	x11, [x29, 112]
	ldr	w1, [x2, 552]
	add	w1, w1, 1
	str	w1, [x2, 552]
	ldrb	w1, [x11, 1]
	ldr	w2, [x0, 12]
	str	w2, [sp]
	mov	w2, w10
	ldp	w5, w6, [x0]
	ldr	w7, [x0, 8]
	adrp	x0, .LC228
	ldr	w4, [x11, 40]
	add	x0, x0, :lo12:.LC228
	bl	printf
	adrp	x0, .LANCHOR68
	ldr	x11, [x29, 112]
	ldrh	w2, [x0, #:lo12:.LANCHOR68]
	adrp	x0, .LANCHOR31
	ldrb	w1, [x0, #:lo12:.LANCHOR31]
	mov	w0, 24
	sub	w0, w0, w1
	sub	w1, w0, w2
	mov	w0, 1
	lsl	w0, w0, w1
	ldr	w1, [x11, 40]
	sub	w0, w0, #1
	lsr	w1, w1, w2
	and	w0, w0, w1
	adrp	x1, .LANCHOR69
	ldrb	w2, [x1, #:lo12:.LANCHOR69]
	mov	x1, 0
	udiv	w0, w0, w2
	bl	ftl_sblk_dump
	ldr	w10, [x29, 152]
.L3340:
	add	x0, x21, :lo12:.LANCHOR52
	add	x0, x0, x26, lsl 6
	ldr	x1, [x0, 24]
	ldr	w0, [x0, 36]
	ldr	w1, [x1, 4]
	cmp	w1, w0
	bne	.L3341
	cmn	w10, #1
	bne	.L3342
.L3341:
	ldp	x0, x1, [x29, 128]
	mov	w2, 1109
	bl	printf
.L3342:
	add	x0, x21, :lo12:.LANCHOR52
	add	x8, x0, x26, lsl 6
	ldr	x0, [x29, 168]
	ldrb	w2, [x8, 56]
	ldrb	w0, [x0, #:lo12:.LANCHOR125]
	cmp	w0, w2
	bls	.L3343
	ldrb	w0, [x8, 57]
	lsl	w2, w2, 9
	ldr	x1, [x8, 8]
	ubfiz	x0, x0, 9, 8
	add	x1, x1, x0
	ldr	x0, [x8, 16]
	bl	ftl_memcpy
.L3344:
	ldr	x1, [x29, 144]
	adrp	x0, .LANCHOR131
	add	x0, x0, :lo12:.LANCHOR131
	bl	buf_remove_buf
	ldr	x0, [x29, 144]
	bl	zbuf_free
	ldrb	w0, [x28]
	sub	w0, w0, #1
	strb	w0, [x28]
	b	.L3335
.L3337:
	cmp	w10, 256
	bne	.L3338
	adrp	x2, .LANCHOR31
	adrp	x0, .LANCHOR68
	mov	w4, 24
	mov	w5, 1
	ldrb	w2, [x2, #:lo12:.LANCHOR31]
	ldrh	w0, [x0, #:lo12:.LANCHOR68]
	sub	w4, w4, w2
	stp	w10, w5, [x29, 108]
	ldp	w2, w3, [x1, 36]
	sub	w4, w4, w0
	lsl	w4, w5, w4
	sub	w4, w4, #1
	lsr	w0, w3, w0
	and	w4, w4, w0
	adrp	x0, .LANCHOR69
	ldrb	w0, [x0, #:lo12:.LANCHOR69]
	udiv	w4, w4, w0
	adrp	x0, .LC227
	add	x0, x0, :lo12:.LC227
	and	w1, w4, 65535
	str	w4, [x29, 152]
	bl	printf
	ldr	w5, [x29, 112]
	mov	w2, 0
	ldr	w4, [x29, 152]
	mov	w1, w5
	mov	w0, w4
	bl	gc_add_sblk
	ldr	w10, [x29, 108]
	b	.L3338
.L3343:
	ldrb	w0, [x8, 2]
	and	w0, w0, -9
	strb	w0, [x8, 2]
	b	.L3344
.L3348:
	mov	w0, -1
	b	.L3316
	.size	zftl_read, .-zftl_read
	.section	.text.ftl_vendor_read,"ax",@progbits
	.align	2
	.global	ftl_vendor_read
	.type	ftl_vendor_read, %function
ftl_vendor_read:
	mov	x3, x2
	mov	w2, w1
	add	w1, w0, 512
	mov	w0, 2
	b	zftl_read
	.size	ftl_vendor_read, .-ftl_vendor_read
	.section	.text.zftl_sys_read,"ax",@progbits
	.align	2
	.global	zftl_sys_read
	.type	zftl_sys_read, %function
zftl_sys_read:
	mov	x3, x2
	mov	w2, w1
	mov	w1, w0
	mov	w0, 2
	b	zftl_read
	.size	zftl_sys_read, .-zftl_sys_read
	.section	.text.StorageSysDataLoad,"ax",@progbits
	.align	2
	.global	StorageSysDataLoad
	.type	StorageSysDataLoad, %function
StorageSysDataLoad:
	stp	x29, x30, [sp, -32]!
	mov	w2, 512
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x1
	mov	w20, w0
	mov	w1, 0
	mov	x0, x19
	bl	ftl_memset
	mov	x3, x19
	mov	w1, w20
	ldp	x19, x20, [sp, 16]
	mov	w2, 1
	ldp	x29, x30, [sp], 32
	mov	w0, 2
	b	zftl_read
	.size	StorageSysDataLoad, .-StorageSysDataLoad
	.section	.text.FlashBootVendorRead,"ax",@progbits
	.align	2
	.global	FlashBootVendorRead
	.type	FlashBootVendorRead, %function
FlashBootVendorRead:
	mov	x3, x2
	mov	w2, w1
	add	w1, w0, 512
	mov	w0, 2
	b	zftl_read
	.size	FlashBootVendorRead, .-FlashBootVendorRead
	.section	.text.ftl_read,"ax",@progbits
	.align	2
	.global	ftl_read
	.type	ftl_read, %function
ftl_read:
	and	w0, w0, 255
	b	zftl_read
	.size	ftl_read, .-ftl_read
	.section	.text.gc_check_data_one_wl,"ax",@progbits
	.align	2
	.global	gc_check_data_one_wl
	.type	gc_check_data_one_wl, %function
gc_check_data_one_wl:
	sub	sp, sp, #128
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	stp	x19, x20, [sp, 32]
	adrp	x20, .LANCHOR64
	add	x19, x20, :lo12:.LANCHOR64
	stp	x21, x22, [sp, 48]
	stp	x23, x24, [sp, 64]
	adrp	x22, .LANCHOR10
	stp	x25, x26, [sp, 80]
	ldr	x0, [x19, 8]
	stp	x27, x28, [sp, 96]
	ldr	x23, [x22, #:lo12:.LANCHOR10]
	cbnz	x0, .L3371
	mov	w0, 1
	bl	buf_alloc
	str	x0, [x19, 8]
.L3371:
	add	x0, x20, :lo12:.LANCHOR64
	ldr	x19, [x0, 8]
	cbnz	x19, .L3372
	adrp	x1, .LANCHOR219
	adrp	x0, .LC0
	mov	w2, 612
	add	x1, x1, :lo12:.LANCHOR219
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3372:
	adrp	x4, .LANCHOR105
	add	x28, x23, 96
	add	x27, x23, 80
	add	x4, x4, :lo12:.LANCHOR105
	mov	w26, 0
.L3373:
	ldrb	w0, [x27, 9]
	cmp	w26, w0
	bge	.L3383
	adrp	x25, .LANCHOR73
	mov	w24, 1
	add	x21, x20, :lo12:.LANCHOR64
	add	x25, x25, :lo12:.LANCHOR73
	b	.L3384
.L3382:
	ldrh	w0, [x28]
	ldrh	w1, [x4]
	ldrb	w2, [x25]
	cmp	w2, 2
	mul	w1, w0, w1
	beq	.L3374
	adrp	x0, .LANCHOR35
	ldrb	w0, [x0, #:lo12:.LANCHOR35]
	cbz	w0, .L3375
.L3374:
	ldrh	w0, [x21, 16]
	sub	w3, w0, #1
	add	w0, w24, w1
	add	w0, w3, w0
	orr	w2, w0, w2, lsl 24
	str	w2, [x19, 40]
.L3376:
	mov	w1, 1
	str	x4, [x29, 104]
	mov	x0, x19
	bl	sblk_read_page
	ldr	w0, [x19, 52]
	adrp	x1, .LANCHOR155
	ldr	x4, [x29, 104]
	cmn	w0, #1
	beq	.L3378
	ldrh	w0, [x21, 22]
	ldr	x3, [x1, #:lo12:.LANCHOR155]
	ldr	x2, [x19, 24]
	lsl	x0, x0, 2
	ldr	w5, [x3, x0]
	ldr	w3, [x2, 4]
	cmp	w5, w3
	bne	.L3378
	adrp	x3, .LANCHOR156
	ldr	x3, [x3, #:lo12:.LANCHOR156]
	ldr	w3, [x3, x0]
	ldr	w0, [x2, 8]
	cmp	w3, w0
	beq	.L3379
.L3378:
	add	x5, x1, :lo12:.LANCHOR155
	ldrh	w0, [x21, 22]
	ldr	x1, [x1, #:lo12:.LANCHOR155]
	ldr	w0, [x1, x0, lsl 2]
	cmn	w0, #1
	beq	.L3379
	adrp	x20, .LANCHOR79
	ldrb	w3, [x27, 9]
	str	x5, [x29, 104]
	mov	w2, 4
	ldrh	w0, [x20, #:lo12:.LANCHOR79]
	mul	w3, w3, w0
	adrp	x0, .LC229
	add	x0, x0, :lo12:.LC229
	bl	rknand_print_hex
	ldrh	w0, [x20, #:lo12:.LANCHOR79]
	adrp	x20, .LANCHOR156
	ldrb	w3, [x27, 9]
	mov	w2, 4
	ldr	x1, [x20, #:lo12:.LANCHOR156]
	mul	w3, w3, w0
	adrp	x0, .LC230
	add	x0, x0, :lo12:.LC230
	bl	rknand_print_hex
	adrp	x0, .LANCHOR14
	ldr	x5, [x29, 104]
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 10, .L3380
	ldr	x1, [x19, 24]
	ldrh	w0, [x21, 22]
	ldr	x2, [x5]
	ldr	x3, [x20, #:lo12:.LANCHOR156]
	lsl	x0, x0, 2
	ldr	w4, [x1, 12]
	str	w4, [sp]
	ldr	w4, [x3, x0]
	ldp	w5, w6, [x1]
	ldr	w3, [x2, x0]
	adrp	x0, .LC231
	ldr	w7, [x1, 8]
	add	x0, x0, :lo12:.LC231
	ldr	w1, [x19, 40]
	ldr	w2, [x19, 52]
	bl	printf
.L3380:
	ldr	x0, [x22, #:lo12:.LANCHOR10]
	mov	x1, 0
	ldrh	w0, [x0, 80]
	bl	ftl_sblk_dump
	adrp	x0, .LANCHOR9
	ldrh	w1, [x23, 80]
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	strh	wzr, [x0, x1, lsl 1]
	ldr	x1, [x22, #:lo12:.LANCHOR10]
	ldr	w0, [x1, 556]
	add	w0, w0, 1
	str	w0, [x1, 556]
	adrp	x0, .LANCHOR104
	ldr	x0, [x0, #:lo12:.LANCHOR104]
	ldr	w1, [x0, 156]
	mov	w0, 20041
	movk	w0, 0x444b, lsl 16
	cmp	w1, w0
	bne	.L3385
	ldr	w0, [x19, 40]
	bl	ftl_mask_bad_block
.L3385:
	mov	w0, -1
.L3370:
	ldp	x19, x20, [sp, 32]
	ldp	x21, x22, [sp, 48]
	ldp	x23, x24, [sp, 64]
	ldp	x25, x26, [sp, 80]
	ldp	x27, x28, [sp, 96]
	ldp	x29, x30, [sp, 16]
	add	sp, sp, 128
	ret
.L3375:
	ldrh	w0, [x21, 16]
	cmp	w2, 3
	add	w0, w0, w1
	bne	.L3377
	orr	w0, w0, w24, lsl 24
.L3377:
	str	w0, [x19, 40]
	b	.L3376
.L3379:
	ldrh	w0, [x21, 22]
	add	w24, w24, 1
	add	w0, w0, 1
	strh	w0, [x21, 22]
.L3384:
	ldrh	w0, [x21, 20]
	cmp	w24, w0
	ble	.L3382
	add	w26, w26, 1
	add	x28, x28, 2
	b	.L3373
.L3383:
	add	x20, x20, :lo12:.LANCHOR64
	ldrh	w0, [x20, 16]
	add	w1, w0, 1
	strh	w1, [x20, 16]
	adrp	x1, .LANCHOR74
	ldrb	w1, [x1, #:lo12:.LANCHOR74]
	cbz	w1, .L3386
	add	w0, w0, 2
	strh	w0, [x20, 16]
.L3386:
.L3381:
	mov	w0, 0
	b	.L3370
	.size	gc_check_data_one_wl, .-gc_check_data_one_wl
	.section	.text.ftl_update_l2p_map,"ax",@progbits
	.align	2
	.global	ftl_update_l2p_map
	.type	ftl_update_l2p_map, %function
ftl_update_l2p_map:
	stp	x29, x30, [sp, -128]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	mov	x22, x0
	stp	x19, x20, [sp, 16]
	adrp	x0, .LANCHOR87
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	ldrh	w23, [x0, #:lo12:.LANCHOR87]
	ldrb	w0, [x22, 9]
	ldrh	w19, [x22, 12]
	mul	w23, w23, w0
	adrp	x0, .LANCHOR111
	str	x0, [x29, 104]
	ldr	x1, [x0, #:lo12:.LANCHOR111]
	add	x19, x1, x19, lsl 2
	add	x1, x19, x23, sxtw 2
	ldr	w1, [x1, -4]
	cmn	w1, #1
	beq	.L3401
	adrp	x1, .LANCHOR220
	adrp	x0, .LC0
	mov	w2, 1733
	add	x1, x1, :lo12:.LANCHOR220
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3401:
	adrp	x27, .LANCHOR125
	mov	x24, 0
	add	x0, x27, :lo12:.LANCHOR125
	mov	w21, 0
	str	x0, [x29, 96]
.L3402:
	cmp	w24, w23
	blt	.L3408
	adrp	x0, .LANCHOR14
	adrp	x19, .LANCHOR9
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L3409
	ldrh	w1, [x22]
	ldr	x2, [x19, #:lo12:.LANCHOR9]
	ubfiz	x0, x1, 1, 16
	ldrh	w3, [x2, x0]
	adrp	x0, .LC235
	mov	w2, w21
	add	x0, x0, :lo12:.LC235
	bl	printf
.L3409:
	ldrh	w1, [x22]
	ldr	x0, [x19, #:lo12:.LANCHOR9]
	ldp	x23, x24, [sp, 48]
	ldp	x19, x20, [sp, 16]
	strh	w21, [x0, x1, lsl 1]
	ldp	x25, x26, [sp, 64]
	ldp	x21, x22, [sp, 32]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L3408:
	ldr	w2, [x19, x24, lsl 2]
	cmn	w2, #1
	beq	.L3403
	ldrb	w20, [x27, #:lo12:.LANCHOR125]
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	lsl	w20, w20, 7
	udiv	w20, w2, w20
	and	w20, w20, 65535
	tbz	x0, 12, .L3404
	adrp	x0, .LC232
	mov	w3, w24
	mov	w1, w20
	add	x0, x0, :lo12:.LC232
	bl	printf
.L3404:
	adrp	x25, .LANCHOR105
	adrp	x26, .LC233
	mov	x28, x24
	add	x25, x25, :lo12:.LANCHOR105
	add	x26, x26, :lo12:.LC233
.L3407:
	ldr	w1, [x19, x28, lsl 2]
	cmn	w1, #1
	beq	.L3405
	ldr	x0, [x29, 96]
	ldrb	w2, [x0]
	lsl	w2, w2, 7
	udiv	w1, w1, w2
	cmp	w20, w1, uxth
	bne	.L3405
	ldrb	w0, [x22, 9]
	sdiv	w1, w28, w0
	msub	w0, w1, w0, w28
	add	x0, x22, x0, sxtw 1
	ldrh	w2, [x0, 16]
	ldrh	w0, [x25]
	madd	w2, w2, w0, w1
	mov	x0, x26
	str	w2, [x29, 124]
	ldr	w1, [x19, x28, lsl 2]
	bl	pm_ppa_update_check
	cbz	w0, .L3406
	ldr	x0, [x29, 104]
	mov	w3, w23
	mov	w2, 4
	ldr	x1, [x0, #:lo12:.LANCHOR111]
	adrp	x0, .LC234
	add	x0, x0, :lo12:.LC234
	bl	rknand_print_hex
.L3406:
	ldr	w0, [x19, x28, lsl 2]
	add	w21, w21, 1
	mov	w2, 1
	add	x1, x29, 124
	and	w21, w21, 65535
	bl	pm_log2phys
	mov	w0, -1
	str	w0, [x19, x28, lsl 2]
.L3405:
	add	x28, x28, 1
	cmp	w23, w28
	bgt	.L3407
.L3403:
	add	x24, x24, 1
	b	.L3402
	.size	ftl_update_l2p_map, .-ftl_update_l2p_map
	.section	.text.ftl_alloc_new_data_sblk,"ax",@progbits
	.align	2
	.global	ftl_alloc_new_data_sblk
	.type	ftl_alloc_new_data_sblk, %function
ftl_alloc_new_data_sblk:
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x20, x0
	str	x21, [sp, 32]
	ldrh	w21, [x0]
	bl	ftl_update_l2p_map
	bl	pm_flush
	ldrh	w0, [x20]
	mov	w1, 65535
	cmp	w0, w1
	beq	.L3431
	bl	zftl_insert_data_list
.L3431:
	adrp	x19, .LANCHOR10
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	add	x0, x0, 16
	cmp	x20, x0
	mov	x0, x20
	cset	w1, ne
	add	w1, w1, 2
	bl	ftl_open_sblk_init
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	ldr	w0, [x0, 560]
	cmp	w0, w21
	bne	.L3433
	mov	w20, 65535
	cmp	w21, w20
	beq	.L3433
	mov	w1, w21
	adrp	x0, .LC236
	add	x0, x0, :lo12:.LC236
	bl	printf
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	ldr	w0, [x0, 564]
	bl	gc_mark_bad_ppa
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	mov	w1, -1
	str	w20, [x0, 560]
	str	w1, [x0, 564]
.L3433:
	bl	ftl_ext_info_flush
	mov	w0, 0
	bl	ftl_info_flush
	bl	lpa_rebuild_hash
	ldr	x21, [sp, 32]
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
	.size	ftl_alloc_new_data_sblk, .-ftl_alloc_new_data_sblk
	.section	.text.ftl_write_commit,"ax",@progbits
	.align	2
	.global	ftl_write_commit
	.type	ftl_write_commit, %function
ftl_write_commit:
	stp	x29, x30, [sp, -144]!
	adrp	x0, .LANCHOR52
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	add	x23, x0, :lo12:.LANCHOR52
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
.L3437:
	adrp	x2, .LANCHOR60
	ldrb	w1, [x2, #:lo12:.LANCHOR60]
	cbz	w1, .L3439
	adrp	x3, .LANCHOR59
	adrp	x0, .LANCHOR52
	add	x0, x0, :lo12:.LANCHOR52
	sub	w1, w1, #1
	ldrb	w4, [x3, #:lo12:.LANCHOR59]
	strb	w1, [x2, #:lo12:.LANCHOR60]
	ubfiz	x27, x4, 6, 8
	add	x5, x0, x27
	stp	x4, x5, [x29, 112]
	lsl	x4, x4, 6
	add	x5, x0, x4
	ldrb	w0, [x0, x4]
	strb	w0, [x3, #:lo12:.LANCHOR59]
	adrp	x0, .LANCHOR122
	ldr	w2, [x5, 36]
	mov	x19, x0
	ldr	w1, [x0, #:lo12:.LANCHOR122]
	cmp	w2, w1
	bcc	.L3441
	adrp	x1, .LANCHOR221
	adrp	x0, .LC0
	mov	w2, 510
	add	x1, x1, :lo12:.LANCHOR221
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3441:
	ldr	x0, [x29, 112]
	ldr	w1, [x19, #:lo12:.LANCHOR122]
	add	x0, x23, x0, lsl 6
	ldr	w22, [x0, 36]
	cmp	w22, w1
	bcc	.L3442
	ldr	x0, [x29, 120]
	bl	zbuf_free
	mov	w0, -1
.L3436:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	ret
.L3442:
	ldrb	w21, [x0, 57]
	ldrb	w20, [x0, 56]
	ldr	x26, [x0, 8]
	ldr	x28, [x0, 24]
	adrp	x0, .LANCHOR123
	str	x0, [x29, 104]
	ldrb	w1, [x0, #:lo12:.LANCHOR123]
	cbz	w1, .L3444
	adrp	x0, .LANCHOR177
	ldrb	w1, [x0, #:lo12:.LANCHOR177]
	add	x1, x23, x1, lsl 6
.L3445:
	ldrb	w0, [x1]
	cmp	w0, 255
	bne	.L3446
	ldr	w0, [x1, 36]
	cmp	w22, w0
	bne	.L3444
	ldr	x0, [x1, 8]
	ubfiz	x21, x21, 9, 8
	lsl	w2, w20, 9
	add	x1, x26, x21
	add	x0, x0, x21
	bl	ftl_memcpy
	ldr	x0, [x29, 120]
	bl	zbuf_free
	b	.L3437
.L3446:
	ubfiz	x1, x0, 6, 8
	add	x1, x23, x1
	b	.L3445
.L3444:
	mov	w0, w22
	bl	lpa_hash_get_ppa
	str	w0, [x29, 140]
	cmn	w0, #1
	bne	.L3448
	mov	w2, 0
	add	x1, x29, 140
	mov	w0, w22
	bl	pm_log2phys
.L3448:
	adrp	x25, .LANCHOR10
	add	x1, x23, 2
	mov	w0, 0
	ldr	x19, [x25, #:lo12:.LANCHOR10]
	add	x19, x19, 16
.L3451:
	ldr	w2, [x1, 34]
	cmp	w22, w2
	bne	.L3449
	ldrb	w2, [x1]
	tbz	x2, 3, .L3449
	ubfiz	x0, x0, 6, 32
	and	w2, w2, -9
	add	x0, x23, x0
	strb	w2, [x0, 2]
	ldr	x24, [x0, 8]
	ldr	w0, [x0, 40]
	str	w0, [x29, 140]
.L3450:
	adrp	x0, .LANCHOR125
	str	x0, [x29, 96]
	ldrb	w1, [x0, #:lo12:.LANCHOR125]
	cmp	w20, w1
	bcs	.L3475
	add	w20, w21, w20
	cbz	x24, .L3453
	cbz	w21, .L3454
	lsl	w2, w21, 9
	mov	x1, x24
	mov	x0, x26
	bl	ftl_memcpy
	ldr	x19, [x25, #:lo12:.LANCHOR10]
	add	x19, x19, 48
.L3454:
	ldr	x0, [x29, 96]
	ldrb	w2, [x0, #:lo12:.LANCHOR125]
	cmp	w20, w2
	bcc	.L3455
	ldr	x19, [x25, #:lo12:.LANCHOR10]
	add	x19, x19, 16
.L3475:
	mov	w24, 0
	b	.L3452
.L3449:
	add	w0, w0, 1
	add	x1, x1, 64
	cmp	w0, 32
	bne	.L3451
	mov	x24, 0
	b	.L3450
.L3455:
	ubfiz	x0, x20, 9, 9
	sub	w2, w2, w20
	add	x1, x24, x0
	lsl	w2, w2, 9
	add	x0, x26, x0
	bl	ftl_memcpy
	b	.L3475
.L3453:
	ldr	w0, [x29, 140]
	cmn	w0, #1
	beq	.L3456
	mov	w0, 1
	bl	buf_alloc
	ldr	w1, [x29, 140]
	mov	x27, x0
	stp	w22, w1, [x0, 36]
	mov	w1, 1
	bl	sblk_read_page
	ldr	x0, [x27, 24]
	ldr	w24, [x0, 12]
	ldr	w0, [x0, 4]
	add	w24, w24, 1
	cmp	w22, w0
	bne	.L3457
	ldr	w0, [x27, 52]
	cmn	w0, #1
	bne	.L3458
.L3457:
	ldr	x1, [x25, #:lo12:.LANCHOR10]
	mov	w3, w22
	ldr	w4, [x27, 52]
	ldr	w2, [x29, 140]
	ldr	w0, [x1, 552]
	add	w0, w0, 1
	str	w0, [x1, 552]
	adrp	x0, .LC237
	add	x0, x0, :lo12:.LC237
	ldrb	w1, [x27, 1]
	bl	printf
	ldr	x1, [x27, 24]
	mov	w3, 4
	adrp	x0, .LC195
	mov	w2, w3
	add	x0, x0, :lo12:.LC195
	bl	rknand_print_hex
.L3458:
	ldr	x0, [x27, 24]
	ldr	w0, [x0, 4]
	cmp	w22, w0
	bne	.L3459
	ldr	w0, [x27, 52]
	cmn	w0, #1
	bne	.L3460
.L3459:
	adrp	x1, .LANCHOR221
	adrp	x0, .LC0
	mov	w2, 581
	add	x1, x1, :lo12:.LANCHOR221
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3460:
	cbz	w21, .L3461
	ldr	w0, [x29, 140]
	lsl	w2, w21, 9
	cmn	w0, #1
	beq	.L3462
	ldr	x1, [x27, 8]
	mov	x0, x26
	bl	ftl_memcpy
.L3463:
	ldr	x19, [x25, #:lo12:.LANCHOR10]
	add	x19, x19, 48
.L3461:
	ldr	x0, [x29, 96]
	ldrb	w2, [x0, #:lo12:.LANCHOR125]
	cmp	w20, w2
	bcc	.L3464
	bls	.L3465
	ldr	x19, [x25, #:lo12:.LANCHOR10]
	add	x19, x19, 16
.L3465:
	cbz	x27, .L3452
	ldrb	w0, [x27, 2]
	mov	x1, x27
	and	w0, w0, -9
	strb	w0, [x27, 2]
	adrp	x0, .LANCHOR131
	add	x0, x0, :lo12:.LANCHOR131
	bl	buf_remove_buf
	mov	x0, x27
	bl	zbuf_free
.L3452:
	ldrh	w0, [x19, 6]
	cbnz	w0, .L3467
	bl	ftl_flush
	mov	x0, x19
	bl	ftl_alloc_new_data_sblk
.L3467:
	mov	x0, x19
	bl	ftl_get_new_free_page
	ldr	x1, [x29, 112]
	adrp	x20, .LANCHOR177
	lsl	x2, x1, 6
	add	x1, x23, x2
	ldr	w3, [x1, 32]
	stp	w3, w22, [x28]
	str	w24, [x28, 12]
	ldr	w3, [x29, 140]
	str	w3, [x28, 8]
	stp	w0, w3, [x1, 40]
	mov	w0, -1
	strb	w0, [x23, x2]
	mov	w2, 10
	ldrb	w0, [x1, 2]
	orr	w0, w0, w2
	ldrh	w2, [x19, 12]
	strb	w0, [x1, 2]
	ldrh	w0, [x19, 10]
	add	w0, w0, w2
	sub	w0, w0, #1
	strh	w0, [x1, 48]
	ldr	x1, [x29, 120]
	add	x0, x20, :lo12:.LANCHOR177
	bl	buf_add_tail
	ldr	x0, [x29, 104]
	ldrb	w2, [x0, #:lo12:.LANCHOR123]
	add	w2, w2, 1
	and	w2, w2, 255
	strb	w2, [x0, #:lo12:.LANCHOR123]
	adrp	x0, .LANCHOR222
	cmp	w2, 2
	str	wzr, [x0, #:lo12:.LANCHOR222]
	ldrh	w0, [x19, 6]
	bhi	.L3468
	cmp	w0, 1
	bne	.L3440
.L3468:
	ldrb	w1, [x19, 5]
	cmp	w1, 0
	mov	w1, 0
	cset	w4, ne
	cmp	w0, 1
	ldrb	w0, [x20, #:lo12:.LANCHOR177]
	csinc	w4, w2, w4, eq
	mov	w3, w0
.L3472:
	cmp	w1, w4
	bne	.L3473
	strb	w3, [x20, #:lo12:.LANCHOR177]
	and	w1, w1, 255
	ldr	x3, [x29, 104]
	sub	w2, w2, w1
	ubfiz	x0, x0, 6, 8
	add	x0, x23, x0
	strb	w2, [x3, #:lo12:.LANCHOR123]
	bl	sblk_prog_page
	ldrh	w0, [x19, 6]
	cmp	w0, 1
	bne	.L3440
	bl	sblk_wait_write_queue_completed
	bl	ftl_write_completed
	mov	x0, x19
	bl	ftl_write_last_log_page
	mov	x0, x19
	bl	ftl_alloc_new_data_sblk
.L3440:
	adrp	x0, .LANCHOR60
	ldrb	w0, [x0, #:lo12:.LANCHOR60]
	cbnz	w0, .L3437
.L3439:
	bl	ftl_write_completed
	mov	w0, 0
	b	.L3436
.L3464:
	ldr	w0, [x29, 140]
	sub	w2, w2, w20
	lsl	w2, w2, 9
	cmn	w0, #1
	ubfiz	x0, x20, 7, 9
	beq	.L3466
	ldr	x1, [x27, 8]
	lsl	x0, x0, 2
	add	x1, x1, x0
	add	x0, x26, x0
	bl	ftl_memcpy
	b	.L3465
.L3466:
	mov	w1, 0
	add	x0, x26, x0, lsl 2
	bl	ftl_memset
	b	.L3465
.L3473:
	ubfiz	x3, x3, 6, 8
	add	w1, w1, 1
	ldrb	w3, [x23, x3]
	b	.L3472
.L3474:
	lsl	w2, w21, 9
	mov	x27, 0
	mov	w24, 0
.L3462:
	mov	w1, 0
	mov	x0, x26
	bl	ftl_memset
	b	.L3463
.L3456:
	cbnz	w21, .L3474
	mov	w24, 0
	mov	x27, 0
	b	.L3461
	.size	ftl_write_commit, .-ftl_write_commit
	.section	.text.gc_do_copy_back,"ax",@progbits
	.align	2
	.global	gc_do_copy_back
	.type	gc_do_copy_back, %function
gc_do_copy_back:
	sub	sp, sp, #240
	adrp	x0, .LANCHOR78
	stp	x29, x30, [sp, 32]
	add	x29, sp, 32
	ldrb	w0, [x0, #:lo12:.LANCHOR78]
	stp	x19, x20, [sp, 48]
	stp	x21, x22, [sp, 64]
	stp	x23, x24, [sp, 80]
	stp	x25, x26, [sp, 96]
	stp	x27, x28, [sp, 112]
	cbnz	w0, .L3498
	bl	buf_alloc
	mov	x19, x0
	cbz	x0, .L3497
	adrp	x21, .LANCHOR64
	add	x3, x21, :lo12:.LANCHOR64
	ldrh	w2, [x3, 26]
	mov	w0, w2
	bl	gc_get_src_ppa_from_index
	add	w2, w2, 1
	mov	w22, w0
	str	w22, [x19, 40]
	strh	w2, [x3, 26]
	mov	w1, 1
	mov	x0, x19
	bl	sblk_read_page
	ldr	w0, [x19, 52]
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	bne	.L3500
	adrp	x1, .LANCHOR223
	adrp	x0, .LC0
	mov	w2, 863
	add	x1, x1, :lo12:.LANCHOR223
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3500:
	ldr	x0, [x19, 24]
	ldr	w20, [x0, 4]
	mov	w0, w20
	bl	lpa_hash_get_ppa
	str	w0, [x29, 160]
	cmn	w0, #1
	bne	.L3501
	mov	w2, 0
	add	x1, x29, 160
	mov	w0, w20
	bl	pm_log2phys
.L3501:
	ldr	w23, [x29, 160]
	cmp	w22, w23
	bne	.L3502
	adrp	x0, .LANCHOR52
	add	x0, x0, :lo12:.LANCHOR52
	add	x1, x0, 2
	add	x0, x0, 2050
.L3505:
	ldr	w2, [x1, 34]
	cmp	w20, w2
	bne	.L3503
	ldrb	w2, [x1]
	tbz	x2, 1, .L3503
	mov	x0, x19
	bl	zbuf_free
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L3497
	add	x21, x21, :lo12:.LANCHOR64
	adrp	x0, .LC238
	mov	w2, w22
	mov	w1, w20
	add	x0, x0, :lo12:.LC238
	ldrh	w3, [x21, 26]
	bl	printf
.L3497:
	ldp	x19, x20, [sp, 48]
	ldp	x21, x22, [sp, 64]
	ldp	x23, x24, [sp, 80]
	ldp	x25, x26, [sp, 96]
	ldp	x27, x28, [sp, 112]
	ldp	x29, x30, [sp, 32]
	add	sp, sp, 240
	ret
.L3503:
	add	x1, x1, 64
	cmp	x1, x0
	bne	.L3505
	adrp	x0, .LANCHOR125
	mov	w1, 10
	strb	wzr, [x19, 57]
	ldrb	w0, [x0, #:lo12:.LANCHOR125]
	strb	w0, [x19, 56]
	ldrb	w0, [x19, 2]
	str	w20, [x19, 36]
	orr	w0, w0, w1
	strb	w0, [x19, 2]
	ldr	x0, [x19, 24]
	ldr	w0, [x0]
	str	w0, [x19, 32]
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L3506
	mov	w0, w20
	bl	lpa_hash_get_ppa
	add	x1, x21, :lo12:.LANCHOR64
	mov	w3, w0
	mov	w4, w22
	adrp	x0, .LC239
	mov	w2, w23
	add	x0, x0, :lo12:.LC239
	ldrh	w5, [x1, 26]
	mov	w1, w20
	bl	printf
.L3506:
	mov	x0, x19
	bl	ftl_gc_write_buf
	bl	ftl_write_commit
	add	x21, x21, :lo12:.LANCHOR64
	adrp	x0, .LANCHOR104
	ldr	x1, [x0, #:lo12:.LANCHOR104]
	ldr	w0, [x1, 60]
	add	w0, w0, 1
	str	w0, [x1, 60]
	ldrh	w0, [x21, 28]
	add	w0, w0, 1
	strh	w0, [x21, 28]
	b	.L3497
.L3502:
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L3507
	add	x21, x21, :lo12:.LANCHOR64
	mov	w0, w20
	bl	lpa_hash_get_ppa
	mov	w3, w0
	mov	w4, w22
	adrp	x0, .LC239
	ldrh	w5, [x21, 26]
	mov	w2, w23
	mov	w1, w20
	add	x0, x0, :lo12:.LC239
	bl	printf
.L3507:
	mov	x0, x19
	bl	zbuf_free
	b	.L3497
.L3498:
	adrp	x1, .LANCHOR10
	adrp	x0, .LANCHOR73
	stp	x0, x1, [x29, 128]
	adrp	x24, .LANCHOR64
	ldr	x22, [x1, #:lo12:.LANCHOR10]
	ldrb	w19, [x0, #:lo12:.LANCHOR73]
	add	x22, x22, 80
	cmp	w19, 3
	bne	.L3508
	adrp	x0, .LANCHOR35
	ldrb	w0, [x0, #:lo12:.LANCHOR35]
	cbz	w0, .L3509
	add	x0, x24, :lo12:.LANCHOR64
	ldrb	w20, [x22, 9]
	ldrh	w21, [x0, 570]
	adrp	x0, .LANCHOR204
	ldrb	w0, [x0, #:lo12:.LANCHOR204]
	sdiv	w1, w21, w20
	and	w27, w1, 65535
	cbz	w0, .L3510
	adrp	x0, .LANCHOR224
	add	x0, x0, :lo12:.LANCHOR224
	ldrh	w0, [x0, w1, sxtw 1]
	cmp	w0, 0
	cset	w19, ne
.L3633:
	add	w19, w19, 1
.L3511:
	msub	w20, w27, w20, w21
.L3634:
	and	w20, w20, 65535
.L3512:
	adrp	x0, .LANCHOR79
	ldrb	w1, [x22, 9]
	add	x6, x24, :lo12:.LANCHOR64
	adrp	x11, .LANCHOR224
	ldrh	w0, [x0, #:lo12:.LANCHOR79]
	add	x11, x11, :lo12:.LANCHOR224
	sxtw	x14, w27
	mov	w3, 0
	mul	w13, w19, w1
	ldrh	w15, [x6, 24]
	mul	w0, w0, w1
	sub	w5, w0, #1
	adrp	x0, .LANCHOR204
	ldrb	w12, [x0, #:lo12:.LANCHOR204]
	adrp	x0, .LANCHOR156
	ldr	x7, [x0, #:lo12:.LANCHOR156]
.L3516:
	cmp	w3, w13
	blt	.L3520
.L3566:
	mov	w23, 1
	b	.L3514
.L3510:
	adrp	x0, .LANCHOR205
	ldrb	w0, [x0, #:lo12:.LANCHOR205]
	cbz	w0, .L3560
	sub	w0, w27, #62
	and	w0, w0, 65535
	cmp	w0, 2159
	bhi	.L3561
	udiv	w19, w27, w19
	add	w19, w19, w19, lsl 1
	sub	w19, w27, w19
	and	w19, w19, 65535
	cmp	w19, 0
	cset	w19, eq
	b	.L3633
.L3560:
	mov	w19, 1
	b	.L3511
.L3561:
	mov	w19, 2
	b	.L3511
.L3509:
	adrp	x0, .LANCHOR77
	ldrb	w0, [x0, #:lo12:.LANCHOR77]
	cbz	w0, .L3513
	add	x0, x24, :lo12:.LANCHOR64
	ldrb	w20, [x22, 9]
	ldrh	w21, [x0, 570]
	add	w8, w20, w20, lsl 1
	sub	w20, w20, w20, lsl 2
	sdiv	w27, w21, w8
	madd	w20, w27, w20, w21
	b	.L3634
.L3513:
	add	x0, x24, :lo12:.LANCHOR64
	ldrb	w21, [x22, 9]
	ldrh	w1, [x0, 570]
	adrp	x0, .LANCHOR225
	add	x0, x0, :lo12:.LANCHOR225
	sdiv	w20, w1, w21
	ldrh	w23, [x0, w20, sxtw 1]
	msub	w20, w20, w21, w1
	and	w20, w20, 65535
	lsr	w27, w23, 3
	and	w23, w23, 7
	cmp	w23, 1
	madd	w21, w27, w21, w20
	add	w21, w21, w21, lsl 1
	and	w21, w21, 65535
	beq	.L3512
.L3514:
	adrp	x0, .LANCHOR14
	str	x0, [x29, 112]
	ldr	w1, [x0, #:lo12:.LANCHOR14]
	tbz	x1, 8, .L3521
	adrp	x0, .LANCHOR156
	ubfiz	x1, x21, 2, 16
	mov	w7, w21
	ldr	x2, [x0, #:lo12:.LANCHOR156]
	add	x0, x24, :lo12:.LANCHOR64
	add	x3, x2, x1
	ldrh	w4, [x0, 570]
	adrp	x0, .LANCHOR224
	add	x0, x0, :lo12:.LANCHOR224
	ldrh	w0, [x0, w27, sxtw 1]
	str	w0, [sp]
	adrp	x0, .LC240
	add	x0, x0, :lo12:.LC240
	ldr	w5, [x2, x1]
	mov	w2, w23
	ldr	w6, [x3, 4]
	mov	w1, w27
	mov	w3, w20
	bl	printf
.L3521:
	adrp	x0, .LANCHOR79
	str	wzr, [x29, 152]
	add	x0, x0, :lo12:.LANCHOR79
	str	x0, [x29, 120]
.L3522:
	ldrb	w2, [x22, 9]
	ldr	w0, [x29, 152]
	ldrh	w25, [x29, 152]
	and	w0, w0, 65535
	str	w0, [x29, 156]
	mul	w1, w19, w2
	cmp	w0, w1
	blt	.L3540
	ldr	x0, [x29, 128]
	ldrb	w0, [x0, #:lo12:.LANCHOR73]
	cmp	w0, 3
	add	x0, x29, 160
	bne	.L3541
	adrp	x3, .LANCHOR35
	ldrb	w3, [x3, #:lo12:.LANCHOR35]
	cbz	w3, .L3542
	sub	w3, w1, #1
	mov	w2, 0
.L3543:
	cmp	w2, w3
	blt	.L3544
.L3639:
	ldr	x0, [x0, w3, sxtw 3]
	mov	w2, -1
	strb	w2, [x0]
	ldr	x0, [x29, 160]
	bl	sblk_prog_page
	b	.L3545
.L3508:
	adrp	x0, .LANCHOR74
	ldrb	w0, [x0, #:lo12:.LANCHOR74]
	cbnz	w0, .L3515
	add	x0, x24, :lo12:.LANCHOR64
	ldrb	w20, [x22, 9]
	mov	w19, 1
	ldrh	w21, [x0, 570]
	sdiv	w27, w21, w20
	msub	w20, w27, w20, w21
	and	w20, w20, 65535
	b	.L3512
.L3515:
	add	x0, x24, :lo12:.LANCHOR64
	ldrb	w20, [x22, 9]
	mov	w19, 2
	ldrh	w21, [x0, 570]
	sdiv	w27, w21, w20
	msub	w20, w27, w20, w21
	and	w20, w20, 65535
	b	.L3512
.L3520:
	add	w2, w21, w3
	cmp	w2, w5
	bne	.L3517
	cbz	w12, .L3566
	ldrh	w0, [x11, x14, lsl 1]
	cmp	w0, w27
	bcs	.L3566
	tbz	x3, 0, .L3566
.L3517:
	sbfiz	x2, x2, 2, 32
	ldr	w0, [x7, x2]
	cmn	w0, #1
	bne	.L3518
	ldrh	w4, [x6, 26]
	cmp	w4, w15
	bcs	.L3497
	cbz	w12, .L3519
	ldrh	w0, [x11, x14, lsl 1]
	cmp	w0, w27
	bcs	.L3519
	tbz	x3, 0, .L3519
	ubfiz	x0, x0, 2, 16
	ldr	w0, [x7, x0]
.L3635:
	str	w0, [x7, x2]
.L3518:
	add	w3, w3, 1
	and	w3, w3, 65535
	b	.L3516
.L3519:
	mov	w0, w4
	bl	gc_get_src_ppa_from_index
	add	w4, w4, 1
	strh	w4, [x6, 26]
	b	.L3635
.L3540:
	ldr	w0, [x29, 156]
	add	w28, w21, w0
	sxtw	x0, w28
	str	x0, [x29, 144]
	adrp	x0, .LANCHOR76
	sxtw	x1, w28
	ldr	x0, [x0, #:lo12:.LANCHOR76]
	ldrb	w0, [x0, x1]
	cmp	w0, 255
	bne	.L3523
	mov	w0, 0
	bl	buf_alloc
	mov	x26, x0
	cbnz	x0, .L3524
	bl	sblk_wait_write_queue_completed
	bl	ftl_write_completed
	bl	gc_write_completed
	bl	gc_free_temp_buf
	mov	w0, 0
	bl	buf_alloc
	mov	x26, x0
	cbz	x0, .L3497
.L3524:
	adrp	x0, .LANCHOR76
	sxtw	x2, w28
	ldrb	w1, [x26, 1]
	adrp	x3, .LANCHOR156
	ldr	x0, [x0, #:lo12:.LANCHOR76]
	strb	w1, [x0, x2]
	add	x1, x24, :lo12:.LANCHOR64
	strb	w23, [x26, 61]
	ldrb	w0, [x1, 7]
	add	w0, w0, 1
	strb	w0, [x1, 7]
	add	w0, w25, w21
	strh	w0, [x26, 48]
	adrp	x0, .LANCHOR79
	ldrh	w4, [x0, #:lo12:.LANCHOR79]
	ldrb	w0, [x22, 9]
	mul	w0, w0, w4
	sub	w0, w0, #1
	cmp	w28, w0
	bne	.L3525
	adrp	x0, .LANCHOR204
	ldrb	w0, [x0, #:lo12:.LANCHOR204]
	cbz	w0, .L3526
	adrp	x0, .LANCHOR224
	add	x0, x0, :lo12:.LANCHOR224
	ldrh	w0, [x0, w27, sxtw 1]
	cmp	w0, w27
	bcs	.L3526
	tbnz	x25, 0, .L3525
.L3526:
	adrp	x0, .LANCHOR155
	ldr	x2, [x29, 144]
	adrp	x5, .LANCHOR80
	stp	x3, x5, [x29, 96]
	ldr	x1, [x0, #:lo12:.LANCHOR155]
	mov	w0, -1
	adrp	x28, .LANCHOR125
	str	w0, [x1, x2, lsl 2]
	ldr	x0, [x26, 8]
	ldrb	w2, [x5, #:lo12:.LANCHOR80]
	mul	w2, w2, w4
	lsl	w2, w2, 2
	bl	ftl_memcpy
	ldp	x3, x5, [x29, 96]
	ldr	x0, [x29, 120]
	ldrb	w1, [x5, #:lo12:.LANCHOR80]
	ldrh	w0, [x0]
	mul	w0, w0, w1
	adrp	x1, .LANCHOR205
	ldrb	w1, [x1, #:lo12:.LANCHOR205]
	lsl	w2, w0, 2
	cbz	w1, .L3527
	ldrb	w1, [x28, #:lo12:.LANCHOR125]
	lsl	w1, w1, 9
	sub	w2, w1, w2
.L3527:
	ldr	x1, [x3, #:lo12:.LANCHOR156]
	ldr	x4, [x26, 8]
	str	x5, [x29, 104]
	add	x0, x4, x0, sxtw 2
	bl	ftl_memcpy
	ldr	x0, [x26, 24]
	mov	w1, 0
	ldrb	w2, [x28, #:lo12:.LANCHOR125]
	lsl	w2, w2, 1
	bl	ftl_memset
	ldr	x6, [x26, 24]
	mov	w0, 15555
	movk	w0, 0xf55f, lsl 16
	ldr	x5, [x29, 104]
	str	w0, [x6]
	ldr	x0, [x29, 120]
	ldrh	w1, [x0]
	ldrb	w0, [x5, #:lo12:.LANCHOR80]
	mul	w1, w1, w0
	ldr	x0, [x26, 8]
	lsl	w1, w1, 2
	bl	js_hash
	str	w0, [x6, 4]
	ldr	x0, [x29, 136]
	ldr	x0, [x0, #:lo12:.LANCHOR10]
	ldr	w0, [x0, 132]
	str	w0, [x6, 8]
.L3523:
	adrp	x0, .LANCHOR76
	ldr	w2, [x29, 156]
	add	x28, x29, 160
	adrp	x1, .LANCHOR52
	ldr	x3, [x0, #:lo12:.LANCHOR76]
	add	x5, x1, :lo12:.LANCHOR52
	ldr	x0, [x29, 144]
	ldrb	w0, [x3, x0]
	ubfiz	x4, x0, 6, 8
	add	x4, x5, x4
	str	x4, [x28, w2, sxtw 3]
	sxtw	x2, w0
	mov	w0, 2
	add	x5, x5, x2, lsl 6
	strh	w0, [x5, 50]
	ldr	x0, [x29, 128]
	strb	w23, [x5, 61]
	ldrb	w0, [x0, #:lo12:.LANCHOR73]
	cmp	w0, 3
	bne	.L3531
	adrp	x4, .LANCHOR35
	ldrb	w4, [x4, #:lo12:.LANCHOR35]
	cbz	w4, .L3532
	adrp	x0, .LANCHOR204
	and	w5, w25, 1
	add	w6, w5, w27
	ldrb	w0, [x0, #:lo12:.LANCHOR204]
	cbz	w0, .L3533
	adrp	x4, .LANCHOR224
	add	x4, x4, :lo12:.LANCHOR224
	ldrh	w4, [x4, w27, sxtw 1]
	cmp	w4, w27
	bcs	.L3533
	cmp	w5, 0
	csel	w6, w6, w4, eq
.L3533:
	udiv	w4, w25, w19
	add	x5, x1, :lo12:.LANCHOR52
	add	x5, x5, x2, lsl 6
	add	w4, w4, w20
	add	x4, x22, x4, sxtw 1
	ldrh	w0, [x4, 16]
	adrp	x4, .LANCHOR105
	ldrh	w4, [x4, #:lo12:.LANCHOR105]
	madd	w0, w0, w4, w6
	orr	w0, w0, 50331648
.L3636:
	str	w0, [x5, 40]
.L3537:
	add	x0, x1, :lo12:.LANCHOR52
	add	x0, x0, x2, lsl 6
	ldrh	w4, [x0, 48]
	ldr	w5, [x0, 40]
	adrp	x0, .LANCHOR157
	ldr	x0, [x0, #:lo12:.LANCHOR157]
	str	w5, [x0, x4, lsl 2]
	b	.L3535
.L3525:
	ldr	x0, [x29, 144]
	mov	w1, 1
	lsl	x28, x0, 2
	ldr	x0, [x3, #:lo12:.LANCHOR156]
	ldr	w0, [x0, x28]
	str	w0, [x26, 40]
	mov	x0, x26
	bl	sblk_read_page
	ldr	w0, [x26, 52]
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	bne	.L3529
	adrp	x0, .LANCHOR68
	ldrh	w2, [x0, #:lo12:.LANCHOR68]
	adrp	x0, .LANCHOR31
	ldrb	w1, [x0, #:lo12:.LANCHOR31]
	mov	w0, 24
	sub	w0, w0, w1
	sub	w1, w0, w2
	mov	w0, 1
	lsl	w0, w0, w1
	ldr	w1, [x26, 40]
	sub	w0, w0, #1
	lsr	w1, w1, w2
	and	w0, w0, w1
	adrp	x1, .LANCHOR69
	ldrb	w2, [x1, #:lo12:.LANCHOR69]
	mov	x1, 0
	udiv	w0, w0, w2
	bl	ftl_sblk_dump
	ldr	w0, [x26, 52]
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	bne	.L3529
	ldr	x0, [x26, 24]
	mov	w1, -1
	str	w1, [x0, 4]
	ldr	w0, [x26, 52]
	cmp	w0, 512
	ccmp	w0, w1, 4, ne
	bne	.L3529
	adrp	x1, .LANCHOR223
	adrp	x0, .LC0
	mov	w2, 1002
	add	x1, x1, :lo12:.LANCHOR223
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3529:
	ldr	x0, [x26, 24]
	adrp	x1, .LANCHOR122
	ldr	w1, [x1, #:lo12:.LANCHOR122]
	ldr	w2, [x0, 4]
	cmp	w2, w1
	bcc	.L3530
	mov	w1, -1
	str	w1, [x0, 4]
.L3530:
	adrp	x1, .LANCHOR155
	ldr	w2, [x0, 4]
	ldr	x1, [x1, #:lo12:.LANCHOR155]
	str	w2, [x1, x28]
	ldr	w1, [x26, 40]
	str	w1, [x0, 8]
	b	.L3523
.L3532:
	udiv	w0, w25, w0
	adrp	x6, .LANCHOR105
	ldrh	w6, [x6, #:lo12:.LANCHOR105]
	add	w4, w0, w20
	add	w0, w0, w0, lsl 1
	add	x4, x22, x4, sxtw 1
	sub	w0, w25, w0
	and	w0, w0, 65535
	add	w0, w0, 1
	ldrh	w4, [x4, 16]
	mul	w4, w4, w6
	ldrh	w6, [x5, 48]
	orr	w4, w4, w27
	str	w4, [x5, 40]
	adrp	x5, .LANCHOR157
	orr	w0, w4, w0, lsl 24
	ldr	x5, [x5, #:lo12:.LANCHOR157]
	str	w0, [x5, x6, lsl 2]
.L3535:
	ldr	x0, [x29, 112]
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L3538
	add	x0, x1, :lo12:.LANCHOR52
	ldr	x1, [x29, 144]
	add	x0, x0, x2, lsl 6
	mov	w2, w23
	ldrb	w4, [x3, x1]
	add	x1, x24, :lo12:.LANCHOR64
	ldrb	w7, [x0, 1]
	ldrh	w6, [x0, 48]
	ldrb	w3, [x1, 6]
	ldr	x1, [x26, 24]
	ldr	w1, [x1]
	str	w1, [sp, 16]
	ldr	x1, [x0, 24]
	ldr	w1, [x1, 4]
	str	w1, [sp, 8]
	mov	w1, 3
	udiv	w1, w25, w1
	add	w1, w1, w20
	str	w1, [sp]
	ldr	w1, [x29, 156]
	ldr	w5, [x0, 40]
	adrp	x0, .LC241
	add	x0, x0, :lo12:.LC241
	bl	printf
.L3538:
	adrp	x0, .LANCHOR204
	ldrb	w0, [x0, #:lo12:.LANCHOR204]
	cbz	w0, .L3539
	adrp	x0, .LANCHOR224
	add	x0, x0, :lo12:.LANCHOR224
	ldrh	w0, [x0, w27, sxtw 1]
	cmp	w0, w27
	bcs	.L3539
	tbz	x25, 0, .L3539
	adrp	x0, .LANCHOR76
	ldr	x2, [x29, 144]
	mov	w1, -1
	ldr	x0, [x0, #:lo12:.LANCHOR76]
	strb	w1, [x0, x2]
	ldr	w0, [x29, 156]
	ldr	x1, [x28, w0, sxtw 3]
	ldrb	w0, [x22, 9]
	ubfiz	w0, w0, 1, 15
	ldrb	w2, [x1, 1]
	msub	w0, w19, w0, w21
	and	w0, w0, 65535
	strh	w0, [x1, 48]
	adrp	x1, .LANCHOR76
	and	x0, x0, 65535
	ldr	x1, [x1, #:lo12:.LANCHOR76]
	strb	w2, [x1, x0]
	adrp	x0, .LANCHOR156
	ldr	x2, [x29, 144]
	mov	w1, -1
	ldr	x0, [x0, #:lo12:.LANCHOR156]
	str	w1, [x0, x2, lsl 2]
.L3539:
	ldr	w0, [x29, 152]
	add	w0, w0, 1
	str	w0, [x29, 152]
	b	.L3522
.L3531:
	cmp	w0, 2
	bne	.L3537
	adrp	x0, .LANCHOR74
	adrp	x4, .LANCHOR105
	ldrb	w0, [x0, #:lo12:.LANCHOR74]
	cbnz	w0, .L3536
	ldr	w0, [x29, 156]
	ldrh	w4, [x4, #:lo12:.LANCHOR105]
	add	w0, w20, w0
	add	x0, x22, x0, sxtw 1
	ldrh	w0, [x0, 16]
	madd	w0, w0, w4, w27
.L3637:
	orr	w0, w0, 33554432
	b	.L3636
.L3536:
	add	w0, w20, w25, lsr 1
	ldrh	w4, [x4, #:lo12:.LANCHOR105]
	add	x0, x22, x0, sxtw 1
	ldrh	w0, [x0, 16]
	madd	w0, w0, w4, w27
	and	w4, w25, 1
	add	w0, w0, w4
	b	.L3637
.L3544:
	ldr	x4, [x0, w2, sxtw 3]
	add	w2, w2, 1
	ldr	x5, [x0, w2, sxtw 3]
	and	w2, w2, 65535
	ldrb	w5, [x5, 1]
	strb	w5, [x4]
	b	.L3543
.L3542:
	adrp	x1, .LANCHOR77
	ldrb	w3, [x1, #:lo12:.LANCHOR77]
	ldr	x1, [x29, 160]
	cbz	w3, .L3546
.L3549:
	strb	wzr, [x1, 60]
	b	.L3548
.L3546:
	cmp	w23, 1
	bne	.L3547
	mov	w3, 9
.L3638:
	strb	w3, [x1, 60]
.L3548:
	add	x1, x0, 24
	bl	sblk_xlc_prog_pages
.L3545:
	adrp	x0, .LANCHOR77
	ldrb	w0, [x0, #:lo12:.LANCHOR77]
	cbz	w0, .L3554
	ldrb	w19, [x22, 9]
	add	w19, w19, w19, lsl 1
	and	w19, w19, 1023
.L3555:
	adrp	x0, .LANCHOR104
	add	x24, x24, :lo12:.LANCHOR64
	ldr	x1, [x0, #:lo12:.LANCHOR104]
	ldr	w0, [x1, 52]
	add	w0, w0, w19
	str	w0, [x1, 52]
	ldrh	w0, [x24, 570]
	add	w19, w19, w0
	adrp	x0, .LANCHOR79
	and	w19, w19, 65535
	strh	w19, [x24, 570]
	ldrh	w0, [x0, #:lo12:.LANCHOR79]
	ldrb	w1, [x22, 9]
	mul	w0, w0, w1
	cmp	w19, w0
	blt	.L3558
	ldr	x0, [x29, 136]
	ldr	x0, [x0, #:lo12:.LANCHOR10]
	strh	wzr, [x0, 86]
.L3558:
	bl	gc_write_completed
	b	.L3497
.L3547:
	cmp	w23, 2
	bne	.L3549
	mov	w3, 13
	b	.L3638
.L3541:
	adrp	x3, .LANCHOR74
	ldrb	w3, [x3, #:lo12:.LANCHOR74]
	cbz	w3, .L3567
	adrp	x3, .LANCHOR75
	ldrb	w3, [x3, #:lo12:.LANCHOR75]
	cbnz	w3, .L3551
.L3567:
	sub	w3, w1, #1
	mov	w2, 0
.L3552:
	cmp	w2, w3
	bge	.L3639
	ldr	x4, [x0, w2, sxtw 3]
	add	w2, w2, 1
	ldr	x5, [x0, w2, sxtw 3]
	and	w2, w2, 65535
	ldrb	w5, [x5, 1]
	strb	w5, [x4]
	b	.L3552
.L3551:
	mov	w1, w2
	bl	sblk_3d_mlc_prog_pages
	b	.L3545
.L3554:
	adrp	x0, .LANCHOR74
	ldrb	w0, [x0, #:lo12:.LANCHOR74]
	cbz	w0, .L3556
	ldrb	w19, [x22, 9]
	ubfiz	w19, w19, 1, 8
	b	.L3555
.L3556:
	adrp	x0, .LANCHOR35
	ldrb	w0, [x0, #:lo12:.LANCHOR35]
	cbz	w0, .L3557
	adrp	x0, .LANCHOR204
	ldrb	w1, [x22, 9]
	ldrb	w0, [x0, #:lo12:.LANCHOR204]
	mul	w19, w1, w19
	cbz	w0, .L3555
	adrp	x0, .LANCHOR224
	add	x0, x0, :lo12:.LANCHOR224
	ldrh	w0, [x0, w27, sxtw 1]
	cmp	w0, w27
	csel	w19, w19, w1, cs
	b	.L3555
.L3557:
	ldrb	w19, [x22, 9]
	b	.L3555
	.size	gc_do_copy_back, .-gc_do_copy_back
	.section	.text.zftl_do_gc,"ax",@progbits
	.align	2
	.global	zftl_do_gc
	.type	zftl_do_gc, %function
zftl_do_gc:
	sub	sp, sp, #128
	adrp	x1, .LANCHOR101
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	stp	x19, x20, [sp, 32]
	adrp	x19, .LANCHOR153
	stp	x21, x22, [sp, 48]
	ldrh	w22, [x1, #:lo12:.LANCHOR101]
	adrp	x1, .LANCHOR97
	stp	x23, x24, [sp, 64]
	adrp	x23, .LANCHOR10
	ldrh	w21, [x1, #:lo12:.LANCHOR97]
	stp	x25, x26, [sp, 80]
	ldrb	w1, [x19, #:lo12:.LANCHOR153]
	add	w21, w22, w21
	stp	x27, x28, [sp, 96]
	ldr	x20, [x23, #:lo12:.LANCHOR10]
	cmp	w1, 6
	bhi	.L3750
	mov	w25, w0
	and	w21, w21, 65535
	adrp	x0, .L3643
	add	x0, x0, :lo12:.L3643
	ldrh	w0, [x0,w1,uxtw #1]
	adr	x1, .Lrtx3643
	add	x0, x1, w0, sxth #2
	br	x0
.Lrtx3643:
	.section	.rodata.zftl_do_gc,"a",@progbits
	.align	0
	.align	2
.L3643:
	.2byte	(.L3642 - .Lrtx3643) / 4
	.2byte	(.L3644 - .Lrtx3643) / 4
	.2byte	(.L3645 - .Lrtx3643) / 4
	.2byte	(.L3646 - .Lrtx3643) / 4
	.2byte	(.L3647 - .Lrtx3643) / 4
	.2byte	(.L3648 - .Lrtx3643) / 4
	.2byte	(.L3649 - .Lrtx3643) / 4
	.section	.text.zftl_do_gc
.L3648:
	adrp	x20, .LANCHOR64
	add	x24, x20, :lo12:.LANCHOR64
	mov	w22, 0
.L3650:
	bl	gc_check_data_one_wl
	cbz	w0, .L3746
	ldr	x0, [x23, #:lo12:.LANCHOR10]
	add	x20, x20, :lo12:.LANCHOR64
	strh	wzr, [x20, 56]
	ldrh	w0, [x0, 80]
	bl	ftl_free_sblk
	adrp	x2, .LANCHOR104
	ldr	x1, [x23, #:lo12:.LANCHOR10]
	mov	w0, -1
	ldr	x2, [x2, #:lo12:.LANCHOR104]
	strh	w0, [x1, 80]
	strh	w0, [x2, 126]
	strh	w0, [x1, 130]
	ldr	x0, [x20, 8]
	bl	zbuf_free
	strb	wzr, [x19, #:lo12:.LANCHOR153]
	str	xzr, [x20, 8]
	b	.L3820
.L3642:
	adrp	x0, .LANCHOR99
	adrp	x27, .LANCHOR92
	ldrh	w2, [x20, 80]
	ldrh	w0, [x0, #:lo12:.LANCHOR99]
	ldrh	w24, [x27, #:lo12:.LANCHOR92]
	add	w22, w22, w0
	adrp	x0, .LANCHOR90
	str	x0, [x29, 104]
	and	w22, w22, 65535
	ldrh	w1, [x0, #:lo12:.LANCHOR90]
	add	w24, w24, w1
	mov	w1, 65535
	and	w24, w24, 65535
	cmp	w2, w1
	beq	.L3651
	cbnz	w25, .L3652
	adrp	x0, .LANCHOR81
	ldrh	w0, [x0, #:lo12:.LANCHOR81]
	cmp	w21, w0, lsl 1
	blt	.L3652
.L3750:
	mov	w20, 16
	b	.L3640
.L3652:
	adrp	x5, .LANCHOR89
	mov	w1, 5
	adrp	x25, .LANCHOR78
	ldrh	w0, [x5, #:lo12:.LANCHOR89]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x5, #:lo12:.LANCHOR89]
	bl	zftl_get_gc_node
	and	w3, w0, 65535
	mov	w1, 65535
	cmp	w3, w1
	beq	.L3653
	adrp	x4, .LANCHOR9
	ubfiz	x3, x3, 1, 16
	adrp	x1, .LANCHOR154
	mov	x26, x1
	ldr	x4, [x4, #:lo12:.LANCHOR9]
	ldr	w2, [x1, #:lo12:.LANCHOR154]
	add	w2, w2, 1
	str	w2, [x1, #:lo12:.LANCHOR154]
	ldrh	w3, [x4, x3]
	adrp	x4, .LANCHOR87
	ldrh	w4, [x4, #:lo12:.LANCHOR87]
	cmp	w4, w3
	bcs	.L3654
	adrp	x1, .LANCHOR6
	ldrh	w1, [x1, #:lo12:.LANCHOR6]
	cmp	w2, w1, lsr 4
	bls	.L3653
	adrp	x1, .LANCHOR93
	ldrh	w1, [x1, #:lo12:.LANCHOR93]
	cmp	w1, w3
	bls	.L3653
.L3654:
	ldrb	w2, [x25, #:lo12:.LANCHOR78]
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L3655
	mov	w0, 1
	str	wzr, [x26, #:lo12:.LANCHOR154]
	strb	w0, [x19, #:lo12:.LANCHOR153]
	b	.L3750
.L3653:
	strh	wzr, [x5, #:lo12:.LANCHOR89]
.L3655:
	cmp	w22, 15
	bls	.L3752
	adrp	x0, .LANCHOR94
	ldrh	w1, [x0, #:lo12:.LANCHOR94]
	adrp	x0, .LANCHOR95
	ldrh	w0, [x0, #:lo12:.LANCHOR95]
	cmp	w1, w0
	bhi	.L3752
	cmp	w24, 0
	cset	w24, eq
	add	w24, w24, 1
.L3656:
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L3657
	ldr	x0, [x23, #:lo12:.LANCHOR10]
	mov	w4, w22
	ldrb	w2, [x25, #:lo12:.LANCHOR78]
	mov	w3, w21
	mov	w1, 2170
	ldrh	w7, [x0, 122]
	ldrh	w6, [x0, 120]
	ldrh	w5, [x0, 124]
	ldrh	w0, [x20, 80]
	str	w0, [sp]
	adrp	x0, .LC242
	add	x0, x0, :lo12:.LC242
	bl	printf
.L3657:
	ldrb	w0, [x25, #:lo12:.LANCHOR78]
	mov	w2, 1
	mov	w1, w24
	bl	gc_search_src_blk
	cmp	w0, 0
	ble	.L3658
.L3659:
	mov	w0, 1
.L3822:
	strb	w0, [x19, #:lo12:.LANCHOR153]
	b	.L3750
.L3752:
	mov	w24, 2
	b	.L3656
.L3658:
	ldrb	w0, [x25, #:lo12:.LANCHOR78]
	mov	w2, 1
	mov	w1, 3
	bl	gc_search_src_blk
	cmp	w0, 0
	bgt	.L3659
	b	.L3750
.L3651:
	adrp	x28, .LANCHOR14
	ldr	w0, [x28, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L3661
	adrp	x0, .LANCHOR78
	ldrh	w7, [x20, 122]
	ldrh	w6, [x20, 120]
	mov	w4, w22
	ldrh	w5, [x20, 124]
	mov	w3, w21
	ldrb	w2, [x0, #:lo12:.LANCHOR78]
	mov	w1, 2182
	str	w25, [sp]
	adrp	x0, .LC242
	add	x0, x0, :lo12:.LC242
	bl	printf
.L3661:
	cmp	w25, 1
	bne	.L3662
	bl	gc_scan_static_data
	adrp	x26, .LANCHOR78
	ldr	x0, [x23, #:lo12:.LANCHOR10]
	ldrh	w0, [x0, 122]
	cbz	w0, .L3663
.L3664:
	mov	w0, 1
	strb	w0, [x26, #:lo12:.LANCHOR78]
	b	.L3822
.L3663:
	bl	gc_static_wearleveling
	mov	w20, w0
	cbnz	w0, .L3664
	cbnz	w22, .L3665
.L3669:
	mov	w20, 16
.L3666:
	ldr	x0, [x23, #:lo12:.LANCHOR10]
	adrp	x3, .LANCHOR78
	mov	w1, 1
	mov	x23, x3
	strb	w1, [x3, #:lo12:.LANCHOR78]
	ldrh	w5, [x0, 124]
	cbz	w5, .L3674
	strb	w1, [x19, #:lo12:.LANCHOR153]
	ldr	w1, [x28, #:lo12:.LANCHOR14]
	strb	wzr, [x3, #:lo12:.LANCHOR78]
	tbz	x1, 8, .L3640
	ldrh	w7, [x0, 122]
	mov	w4, w22
	ldrh	w6, [x0, 120]
	mov	w3, w21
	adrp	x0, .LC243
	mov	w2, 0
	mov	w1, 2272
	add	x0, x0, :lo12:.LC243
	bl	printf
.L3640:
	mov	w0, w20
	ldp	x19, x20, [sp, 32]
	ldp	x21, x22, [sp, 48]
	ldp	x23, x24, [sp, 64]
	ldp	x25, x26, [sp, 80]
	ldp	x27, x28, [sp, 96]
	ldp	x29, x30, [sp, 16]
	add	sp, sp, 128
	ret
.L3665:
	cmp	w21, w24
	adrp	x1, .LANCHOR94
	adrp	x2, .LANCHOR91
	bcs	.L3667
	ldrh	w0, [x2, #:lo12:.LANCHOR91]
	cmp	w0, w21
	bhi	.L3668
.L3667:
	ldrh	w2, [x2, #:lo12:.LANCHOR91]
	add	w0, w21, w24
	cmp	w0, w2
	blt	.L3668
	adrp	x0, .LANCHOR95
	ldrh	w2, [x1, #:lo12:.LANCHOR94]
	ldrh	w0, [x0, #:lo12:.LANCHOR95]
	cmp	w2, w0
	bcc	.L3669
.L3668:
	adrp	x5, .LANCHOR154
	adrp	x2, .LANCHOR6
	mov	w6, 1
	strb	w6, [x26, #:lo12:.LANCHOR78]
	ldr	w0, [x5, #:lo12:.LANCHOR154]
	ldrh	w2, [x2, #:lo12:.LANCHOR6]
	add	w0, w0, 1
	str	w0, [x5, #:lo12:.LANCHOR154]
	cmp	w0, w2, lsr 5
	bls	.L3670
	ldrh	w0, [x1, #:lo12:.LANCHOR94]
	cmp	w0, w22
	bls	.L3670
	mov	w1, 5
	mov	w0, 0
	bl	zftl_get_gc_node
	and	w0, w0, 65535
	mov	w1, 65535
	cmp	w0, w1
	beq	.L3669
	adrp	x1, .LANCHOR9
	ubfiz	x0, x0, 1, 16
	adrp	x2, .LANCHOR80
	ldr	x1, [x1, #:lo12:.LANCHOR9]
	ldrb	w2, [x2, #:lo12:.LANCHOR80]
	ldrh	w1, [x1, x0]
	adrp	x0, .LANCHOR87
	ldrh	w0, [x0, #:lo12:.LANCHOR87]
	mul	w0, w0, w2
	cmp	w1, w0
	bgt	.L3669
	mov	w0, w6
	str	wzr, [x5, #:lo12:.LANCHOR154]
	mov	w2, 4
	mov	w1, 2
.L3810:
	bl	gc_search_src_blk
	and	w0, w0, 65535
	cbz	w0, .L3669
	b	.L3659
.L3670:
	adrp	x0, .LANCHOR95
	ldrh	w1, [x1, #:lo12:.LANCHOR94]
	ldrh	w0, [x0, #:lo12:.LANCHOR95]
	cmp	w1, w0
	bcc	.L3672
	mov	w2, 1
	mov	w1, 2
	mov	w0, w2
	b	.L3810
.L3672:
	ldrh	w0, [x27, #:lo12:.LANCHOR92]
	cbnz	w0, .L3673
	ldr	x0, [x29, 104]
	ldrh	w0, [x0, #:lo12:.LANCHOR90]
	cmp	w0, 8
	bls	.L3666
.L3673:
	mov	w1, 1
	mov	w2, 4
	mov	w0, w1
	b	.L3810
.L3662:
	adrp	x0, .LANCHOR81
	ldrh	w0, [x0, #:lo12:.LANCHOR81]
	cmp	w0, w21
	bcc	.L3750
	b	.L3669
.L3674:
	adrp	x2, .LANCHOR81
	mov	x26, x2
	ldrh	w4, [x2, #:lo12:.LANCHOR81]
	cmp	w21, w4
	bcs	.L3675
	cbz	w22, .L3676
	cmp	w22, 16
	bls	.L3677
	adrp	x0, .LANCHOR94
	ldrh	w2, [x0, #:lo12:.LANCHOR94]
	adrp	x0, .LANCHOR95
	ldrh	w0, [x0, #:lo12:.LANCHOR95]
	cmp	w2, w0
	bhi	.L3677
	str	x3, [x29, 104]
	mov	w2, 4
	mov	w0, w1
	bl	gc_search_src_blk
	ldr	x3, [x29, 104]
	tst	w0, 65535
	bne	.L3678
	ldrb	w0, [x3, #:lo12:.LANCHOR78]
	mov	w2, 4
	mov	w1, 3
.L3812:
	bl	gc_search_src_blk
	and	w0, w0, 65535
.L3679:
	cbnz	w0, .L3681
	b	.L3640
.L3678:
	mov	w1, 5
	mov	w0, 0
	bl	zftl_get_gc_node
	and	w3, w0, 65535
	mov	w1, 65535
	cmp	w3, w1
	beq	.L3681
	adrp	x4, .LANCHOR9
	ubfiz	x3, x3, 1, 16
	adrp	x1, .LANCHOR154
	mov	x21, x1
	ldr	x4, [x4, #:lo12:.LANCHOR9]
	ldr	w2, [x1, #:lo12:.LANCHOR154]
	add	w2, w2, 1
	str	w2, [x1, #:lo12:.LANCHOR154]
	ldrh	w3, [x4, x3]
	adrp	x4, .LANCHOR87
	ldrh	w4, [x4, #:lo12:.LANCHOR87]
	cmp	w4, w3
	bcs	.L3682
	adrp	x1, .LANCHOR6
	ldrh	w1, [x1, #:lo12:.LANCHOR6]
	cmp	w2, w1, lsr 4
	bls	.L3681
	adrp	x1, .LANCHOR93
	ldrh	w1, [x1, #:lo12:.LANCHOR93]
	cmp	w1, w3
	bls	.L3681
.L3682:
	ldrb	w2, [x23, #:lo12:.LANCHOR78]
	mov	w1, 0
	bl	gc_add_sblk
	str	wzr, [x21, #:lo12:.LANCHOR154]
	adrp	x0, .LANCHOR116
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR116]
.L3681:
	mov	w0, 1
	strb	w0, [x19, #:lo12:.LANCHOR153]
	b	.L3640
.L3677:
	mov	w2, 1
	mov	w0, w2
	mov	w1, 2
.L3819:
	bl	gc_search_src_blk
	tst	w0, 65535
	bne	.L3681
	mov	w2, 2
.L3815:
	mov	w1, 3
	ldrb	w0, [x23, #:lo12:.LANCHOR78]
	b	.L3812
.L3676:
	ldr	w1, [x28, #:lo12:.LANCHOR14]
	strb	wzr, [x3, #:lo12:.LANCHOR78]
	tbz	x1, 8, .L3684
	ldrh	w7, [x0, 122]
	mov	w5, 0
	ldrh	w6, [x0, 120]
	mov	w4, 0
	adrp	x0, .LC243
	mov	w3, w21
	mov	w2, 0
	mov	w1, 2302
	add	x0, x0, :lo12:.LC243
	bl	printf
.L3684:
	cmp	w21, 16
	bls	.L3685
	mov	w2, 4
	b	.L3815
.L3685:
	mov	w2, 1
	ldrb	w0, [x23, #:lo12:.LANCHOR78]
	mov	w1, w2
	b	.L3819
.L3675:
	cmp	w25, 1
	bne	.L3640
	cmp	w21, w4, lsl 1
	bge	.L3686
	cmp	w24, w22, lsr 1
	bcs	.L3687
	adrp	x0, .LANCHOR94
	ldrh	w1, [x0, #:lo12:.LANCHOR94]
	adrp	x0, .LANCHOR95
	ldrh	w0, [x0, #:lo12:.LANCHOR95]
	cmp	w1, w0
	bcs	.L3687
	adrp	x0, .LANCHOR91
	ldrh	w0, [x0, #:lo12:.LANCHOR91]
	lsr	w0, w0, 2
	strh	w0, [x2, #:lo12:.LANCHOR81]
	b	.L3640
.L3687:
	mov	w1, 5
	mov	w0, 0
	bl	zftl_get_gc_node
	and	w25, w0, 65535
	mov	w1, 65535
	mov	w28, w25
	cmp	w25, w1
	bne	.L3688
.L3693:
	cmp	w22, 1
	bhi	.L3689
.L3690:
	cmp	w21, w24
	adrp	x21, .LANCHOR91
	bcs	.L3697
	strb	wzr, [x23, #:lo12:.LANCHOR78]
	mov	w0, 4
	bl	zftl_get_gc_node.part.9
	and	w0, w0, 65535
	mov	w1, 65535
	cmp	w0, w1
	beq	.L3697
	adrp	x1, .LANCHOR9
	ubfiz	x0, x0, 1, 16
	adrp	x2, .LANCHOR80
	ldr	x1, [x1, #:lo12:.LANCHOR9]
	ldrb	w2, [x2, #:lo12:.LANCHOR80]
	ldrh	w1, [x1, x0]
	adrp	x0, .LANCHOR87
	ldrh	w0, [x0, #:lo12:.LANCHOR87]
	mul	w0, w0, w2
	cmp	w1, w0, lsr 1
	ble	.L3699
.L3697:
	ldrh	w0, [x21, #:lo12:.LANCHOR91]
	lsr	w0, w0, 2
	strh	w0, [x26, #:lo12:.LANCHOR81]
	b	.L3640
.L3688:
	adrp	x2, .LANCHOR154
	adrp	x3, .LANCHOR6
	uxtw	x25, w25
	ldr	w1, [x2, #:lo12:.LANCHOR154]
	ldrh	w3, [x3, #:lo12:.LANCHOR6]
	add	w1, w1, 1
	str	w1, [x2, #:lo12:.LANCHOR154]
	cmp	w1, w3, lsr 4
	adrp	x3, .LANCHOR9
	bls	.L3691
	ldr	x1, [x3, #:lo12:.LANCHOR9]
	str	wzr, [x2, #:lo12:.LANCHOR154]
	ldrh	w2, [x1, x25, lsl 1]
	adrp	x1, .LANCHOR93
	ldrh	w1, [x1, #:lo12:.LANCHOR93]
	cmp	w2, w1
	bcs	.L3691
	str	x3, [x29, 96]
	mov	w2, 1
	mov	w1, 0
	bl	gc_add_sblk
	ldr	x3, [x29, 96]
	cbnz	w0, .L3681
.L3691:
	ldr	x0, [x3, #:lo12:.LANCHOR9]
	ldrh	w1, [x0, x25, lsl 1]
	adrp	x0, .LANCHOR87
	ldrh	w0, [x0, #:lo12:.LANCHOR87]
	cmp	w1, w0, lsr 1
	bhi	.L3692
	mov	w2, 0
	mov	w1, 1
	mov	w0, w28
	bl	gc_add_sblk
	b	.L3681
.L3692:
	ldr	x2, [x29, 104]
	ldrh	w0, [x27, #:lo12:.LANCHOR92]
	ldrh	w2, [x2, #:lo12:.LANCHOR90]
	add	w0, w0, w2
	adrp	x2, .LANCHOR91
	ldrh	w2, [x2, #:lo12:.LANCHOR91]
	cmp	w0, w2, lsl 1
	ble	.L3693
	adrp	x0, .LANCHOR93
	ldrh	w0, [x0, #:lo12:.LANCHOR93]
	cmp	w0, w1
	bcc	.L3690
	b	.L3693
.L3689:
	mov	w1, 1
	strb	w1, [x23, #:lo12:.LANCHOR78]
	cmp	w22, 16
	bls	.L3694
	adrp	x0, .LANCHOR94
	ldrh	w2, [x0, #:lo12:.LANCHOR94]
	adrp	x0, .LANCHOR95
	ldrh	w0, [x0, #:lo12:.LANCHOR95]
	cmp	w2, w0
	bhi	.L3694
	mov	w2, 4
	mov	w0, w1
	bl	gc_search_src_blk
	ands	w0, w0, 65535
	bne	.L3695
	mov	w2, 4
.L3811:
	ldrb	w0, [x23, #:lo12:.LANCHOR78]
	mov	w1, 3
	bl	gc_search_src_blk
	and	w0, w0, 65535
.L3695:
	adrp	x1, .LANCHOR91
	cmp	w21, w24, lsr 1
	ldrh	w1, [x1, #:lo12:.LANCHOR91]
	bls	.L3813
	lsr	w1, w1, 2
.L3814:
	strh	w1, [x26, #:lo12:.LANCHOR81]
	b	.L3679
.L3694:
	mov	w2, 1
	mov	w1, 2
	mov	w0, w2
	bl	gc_search_src_blk
	ands	w0, w0, 65535
	bne	.L3695
	mov	w2, 2
	b	.L3811
.L3699:
	mov	w1, 3
	mov	w2, 4
	mov	w0, 0
	bl	gc_search_src_blk
	ldrh	w1, [x21, #:lo12:.LANCHOR91]
	and	w0, w0, 65535
.L3813:
	lsr	w1, w1, 1
	b	.L3814
.L3686:
	adrp	x0, .LANCHOR91
	mov	w20, 0
	ldrh	w0, [x0, #:lo12:.LANCHOR91]
	lsr	w0, w0, 2
	strh	w0, [x2, #:lo12:.LANCHOR81]
	b	.L3640
.L3644:
	adrp	x7, .LANCHOR64
	mov	w0, 65535
	ldrh	w1, [x7, #:lo12:.LANCHOR64]
	cmp	w1, w0
	bne	.L3700
	bl	gc_get_src_blk
	strh	w0, [x7, #:lo12:.LANCHOR64]
.L3700:
	ldrh	w0, [x7, #:lo12:.LANCHOR64]
	mov	w1, 65535
	cmp	w0, w1
	beq	.L3701
	adrp	x1, .LANCHOR6
	ldrh	w1, [x1, #:lo12:.LANCHOR6]
	cmp	w1, w0
	bhi	.L3701
	mov	w0, -1
	strh	w0, [x7, #:lo12:.LANCHOR64]
.L3701:
	ldrh	w3, [x7, #:lo12:.LANCHOR64]
	mov	w0, 65535
	add	x1, x7, :lo12:.LANCHOR64
	cmp	w3, w0
	beq	.L3821
	adrp	x0, .LANCHOR7
	ldrh	w5, [x1, 56]
	uxtw	x4, w3
	ldr	x2, [x0, #:lo12:.LANCHOR7]
	add	x2, x2, x4, lsl 2
	cbz	w5, .L3703
	add	x1, x1, 58
	mov	w0, 0
.L3705:
	ldrh	w6, [x1], 2
	cmp	w6, w3
	bne	.L3704
.L3709:
	adrp	x0, .LANCHOR64
	mov	w1, -1
	strh	w1, [x0, #:lo12:.LANCHOR64]
	b	.L3750
.L3704:
	add	w0, w0, 1
	and	w0, w0, 65535
	cmp	w5, w0
	bne	.L3705
.L3703:
	ldrb	w0, [x2, 2]
	and	w1, w0, 224
	cmp	w1, 224
	beq	.L3706
	tst	w0, 192
	bne	.L3707
.L3706:
	adrp	x0, .LANCHOR9
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrh	w0, [x0, x4, lsl 1]
	cbz	w0, .L3709
	mov	w2, 2537
	adrp	x1, .LANCHOR226
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR226
	add	x0, x0, :lo12:.LC0
	bl	printf
	b	.L3709
.L3707:
	mov	w0, 2
	b	.L3822
.L3645:
	bl	gc_scan_src_blk
	cmn	w0, #1
	bne	.L3710
	mov	w0, 3
	b	.L3822
.L3710:
	adrp	x20, .LANCHOR64
	mov	w2, 65535
	add	x0, x20, :lo12:.LANCHOR64
	ldrh	w1, [x20, #:lo12:.LANCHOR64]
	cmp	w1, w2
	beq	.L3659
	ldrh	w2, [x0, 24]
	cbz	w2, .L3711
	mov	w1, 4
	strh	wzr, [x0, 26]
	strb	w1, [x19, #:lo12:.LANCHOR153]
	b	.L3750
.L3711:
	mov	w0, 1
	strb	w0, [x19, #:lo12:.LANCHOR153]
	adrp	x0, .LANCHOR9
	ubfiz	x1, x1, 1, 16
	mov	x19, x0
	ldr	x2, [x0, #:lo12:.LANCHOR9]
	ldrh	w1, [x2, x1]
	cbz	w1, .L3712
	adrp	x1, .LANCHOR226
	adrp	x0, .LC0
	mov	w2, 2565
	add	x1, x1, :lo12:.LANCHOR226
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3712:
	ldrh	w0, [x20, #:lo12:.LANCHOR64]
	add	x21, x20, :lo12:.LANCHOR64
	bl	ftl_free_sblk
	ldr	x0, [x19, #:lo12:.LANCHOR9]
	ldrh	w1, [x20, #:lo12:.LANCHOR64]
	strh	wzr, [x0, x1, lsl 1]
	ldrh	w0, [x21, 30]
	add	w0, w0, 1
	and	w0, w0, 65535
	cmp	w0, 8
	bhi	.L3713
	strh	w0, [x21, 30]
	b	.L3709
.L3713:
	strh	wzr, [x21, 30]
	bl	ftl_flush
	bl	pm_flush
	bl	ftl_ext_info_flush
	mov	w0, 0
	bl	ftl_info_flush
	b	.L3709
.L3646:
	adrp	x20, .LANCHOR64
	adrp	x23, .LANCHOR87
	add	x22, x20, :lo12:.LANCHOR64
	add	x23, x23, :lo12:.LANCHOR87
.L3789:
	bl	gc_scan_src_blk_one_page
	ldrh	w1, [x22, 2]
	ldrh	w0, [x23]
	cmp	w1, w0
	bcs	.L3715
	cmp	w21, 7
	bls	.L3789
	b	.L3750
.L3715:
	ldrh	w3, [x22, 24]
	adrp	x0, .LANCHOR14
	cbz	w3, .L3716
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	mov	w1, 4
	strh	wzr, [x22, 26]
	strb	w1, [x19, #:lo12:.LANCHOR153]
	adrp	x19, .LANCHOR9
	tbz	x0, 8, .L3717
	ldrh	w1, [x22]
	ldr	x2, [x19, #:lo12:.LANCHOR9]
	ubfiz	x0, x1, 1, 16
	ldrh	w2, [x2, x0]
	adrp	x0, .LC244
	add	x0, x0, :lo12:.LC244
	bl	printf
.L3717:
	ldrh	w2, [x20, #:lo12:.LANCHOR64]
	add	x0, x20, :lo12:.LANCHOR64
	ldr	x1, [x19, #:lo12:.LANCHOR9]
	ldrh	w0, [x0, 24]
	ldrh	w1, [x1, x2, lsl 1]
	cmp	w1, w0
	beq	.L3718
	adrp	x1, .LANCHOR226
	adrp	x0, .LC0
	mov	w2, 2599
	add	x1, x1, :lo12:.LANCHOR226
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3718:
	add	x0, x20, :lo12:.LANCHOR64
	ldrh	w1, [x20, #:lo12:.LANCHOR64]
	ldrh	w2, [x0, 24]
	ldr	x0, [x19, #:lo12:.LANCHOR9]
	strh	w2, [x0, x1, lsl 1]
	b	.L3750
.L3716:
	adrp	x2, .LANCHOR7
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	ldrh	w1, [x22]
	ldr	x21, [x2, #:lo12:.LANCHOR7]
	mov	w2, 1
	strb	w2, [x19, #:lo12:.LANCHOR153]
	add	x21, x21, x1, uxth 2
	tbz	x0, 8, .L3719
	ldrb	w2, [x21, 2]
	adrp	x0, .LC245
	add	x0, x0, :lo12:.LC245
	ubfx	x2, x2, 5, 3
	bl	printf
.L3719:
	ldrb	w0, [x21, 2]
	and	w1, w0, 224
	cmp	w1, 224
	beq	.L3720
	tst	w0, 192
	bne	.L3721
.L3720:
	adrp	x1, .LANCHOR226
	adrp	x0, .LC0
	mov	w2, 2609
	add	x1, x1, :lo12:.LANCHOR226
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3721:
	ldrh	w0, [x20, #:lo12:.LANCHOR64]
	add	x19, x20, :lo12:.LANCHOR64
	bl	ftl_free_sblk
	mov	w0, -1
	strh	w0, [x20, #:lo12:.LANCHOR64]
	ldrh	w0, [x19, 30]
	add	w0, w0, 1
	and	w0, w0, 65535
	cmp	w0, 8
	bhi	.L3722
	strh	w0, [x19, 30]
	b	.L3750
.L3722:
	strh	wzr, [x19, 30]
.L3820:
	bl	flt_sys_flush
	b	.L3750
.L3647:
	ldrh	w1, [x20, 80]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L3723
	adrp	x0, .LANCHOR78
	ldrb	w22, [x0, #:lo12:.LANCHOR78]
	cmp	w22, 1
	bne	.L3723
	bl	ftl_flush
	adrp	x0, .LANCHOR64
	add	x1, x0, :lo12:.LANCHOR64
	mov	x21, x0
	ldrh	w1, [x1, 574]
	cbz	w1, .L3724
	mov	w0, w22
	mov	w1, 5
.L3817:
	bl	zftl_gc_get_free_sblk
	and	w19, w0, 65535
	mov	w0, 65535
	cmp	w19, w0
	beq	.L3726
	adrp	x0, .LANCHOR7
	ldr	x22, [x0, #:lo12:.LANCHOR7]
	add	x22, x22, x19, uxth 2
	ldrb	w0, [x22, 2]
	tst	w0, 224
	beq	.L3727
	adrp	x1, .LANCHOR226
	adrp	x0, .LC0
	mov	w2, 2638
	add	x1, x1, :lo12:.LANCHOR226
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3727:
	ldrb	w0, [x22, 2]
	mov	w1, 5
	bfi	w0, w1, 5, 3
	orr	w0, w0, 16
	strb	w0, [x22, 2]
.L3749:
	mov	w1, 1
	mov	w0, w19
	bl	ftl_erase_sblk
	adrp	x22, .LANCHOR79
	mov	w0, 5
	strb	w0, [x20, 84]
	add	x1, x20, 96
	mov	w0, w19
	bl	ftl_get_blk_list_in_sblk
	and	w0, w0, 255
	adrp	x1, .LANCHOR87
	strb	w0, [x20, 89]
	strh	w19, [x20, 80]
	ldrh	w1, [x1, #:lo12:.LANCHOR87]
	strh	wzr, [x20, 82]
	strb	wzr, [x20, 85]
	strh	wzr, [x20, 90]
	mul	w0, w0, w1
	ldrh	w2, [x22, #:lo12:.LANCHOR79]
	strh	w0, [x20, 86]
	adrp	x20, .LANCHOR80
	mov	w1, 255
	ldrb	w0, [x20, #:lo12:.LANCHOR80]
	mul	w2, w2, w0
	adrp	x0, .LANCHOR155
	ldr	x0, [x0, #:lo12:.LANCHOR155]
	lsl	w2, w2, 2
	bl	ftl_memset
	ldrb	w0, [x20, #:lo12:.LANCHOR80]
	mov	w1, 255
	ldrh	w2, [x22, #:lo12:.LANCHOR79]
	mul	w2, w2, w0
	adrp	x0, .LANCHOR156
	ldr	x0, [x0, #:lo12:.LANCHOR156]
	lsl	w2, w2, 2
	bl	ftl_memset
	ldrb	w0, [x20, #:lo12:.LANCHOR80]
	mov	w1, 255
	ldrh	w2, [x22, #:lo12:.LANCHOR79]
	mul	w2, w2, w0
	adrp	x0, .LANCHOR76
	ldr	x0, [x0, #:lo12:.LANCHOR76]
	bl	ftl_memset
	ldr	x0, [x23, #:lo12:.LANCHOR10]
	mov	w1, -1
	str	w19, [x0, 132]
	strh	w1, [x0, 128]
	strh	w1, [x0, 130]
	bl	pm_flush
	bl	ftl_ext_info_flush
	adrp	x0, .LANCHOR104
	mov	w1, -1
	ldr	x0, [x0, #:lo12:.LANCHOR104]
	strh	w19, [x0, 126]
	add	x0, x21, :lo12:.LANCHOR64
	str	w1, [x0, 580]
	strh	wzr, [x0, 570]
	strh	wzr, [x0, 56]
	strh	wzr, [x0, 572]
	strh	wzr, [x0, 576]
	mov	w0, 0
	bl	ftl_info_flush
	b	.L3750
.L3724:
	mov	w1, 5
	mov	w0, 0
	b	.L3817
.L3723:
	cmp	w25, 1
	mov	w22, 4
	csinc	w22, w22, wzr, eq
	cmp	w21, 15
	mov	w0, w22
	add	w22, w22, 4
	adrp	x25, .LANCHOR78
	adrp	x24, .LANCHOR64
	csel	w22, w22, w0, ls
	add	x25, x25, :lo12:.LANCHOR78
	add	x21, x24, :lo12:.LANCHOR64
	add	x26, x20, 80
.L3730:
	sub	w22, w22, #1
	and	w22, w22, 255
	cmp	w22, 255
	beq	.L3750
	bl	gc_do_copy_back
	ldrb	w0, [x25]
	cbnz	w0, .L3731
	adrp	x0, .LANCHOR54
	ldrb	w0, [x0, #:lo12:.LANCHOR54]
	cmp	w0, 3
	bhi	.L3732
	bl	ftl_write_commit
.L3732:
	ldrh	w1, [x21, 26]
	ldrh	w0, [x21, 24]
	cmp	w1, w0
	bcc	.L3730
	mov	w0, 1
	strb	w0, [x19, #:lo12:.LANCHOR153]
	bl	ftl_write_commit
	bl	ftl_flush
	adrp	x0, .LANCHOR9
	ldrh	w2, [x21]
	mov	x19, x0
	ldr	x1, [x0, #:lo12:.LANCHOR9]
	ldrh	w1, [x1, x2, lsl 1]
	cbz	w1, .L3734
	adrp	x1, .LANCHOR226
	adrp	x0, .LC0
	mov	w2, 2713
	add	x1, x1, :lo12:.LANCHOR226
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3734:
	ldrh	w0, [x24, #:lo12:.LANCHOR64]
	ldr	x2, [x19, #:lo12:.LANCHOR9]
	ubfiz	x1, x0, 1, 16
	ldrh	w1, [x2, x1]
	cbnz	w1, .L3735
	bl	ftl_free_sblk
	b	.L3709
.L3735:
	mov	w2, 1
	mov	w1, 0
	bl	gc_add_sblk
	b	.L3709
.L3731:
	ldrh	w0, [x21, 576]
	cbz	w0, .L3736
	strh	wzr, [x21, 576]
	bl	sblk_wait_write_queue_completed
	bl	gc_write_completed
	ldr	w0, [x21, 580]
	cmn	w0, #1
	beq	.L3737
	bl	ftl_mask_bad_block
.L3737:
	ldr	x0, [x23, #:lo12:.LANCHOR10]
	add	x20, x24, :lo12:.LANCHOR64
	strh	wzr, [x20, 56]
	ldrh	w0, [x0, 80]
	str	wzr, [x20, 580]
	bl	ftl_free_sblk
	adrp	x2, .LANCHOR104
	ldr	x1, [x23, #:lo12:.LANCHOR10]
	mov	w0, -1
	ldr	x2, [x2, #:lo12:.LANCHOR104]
	strh	w0, [x1, 80]
	strh	w0, [x2, 126]
	strh	w0, [x1, 130]
	ldr	x0, [x20, 8]
	cbz	x0, .L3738
	bl	zbuf_free
.L3738:
	add	x24, x24, :lo12:.LANCHOR64
	str	xzr, [x24, 8]
	bl	flt_sys_flush
	mov	w2, 2751
	strb	wzr, [x19, #:lo12:.LANCHOR153]
	adrp	x1, .LANCHOR226
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR226
	add	x0, x0, :lo12:.LC0
	bl	printf
	b	.L3750
.L3736:
	ldrh	w0, [x26, 6]
	ldrh	w1, [x21, 26]
	cmp	w0, 1
	ldrh	w0, [x21, 24]
	bls	.L3739
	cmp	w1, w0
	bcc	.L3730
	mov	w0, 1
	strb	w0, [x19, #:lo12:.LANCHOR153]
	ldrh	w0, [x21, 56]
	add	w1, w0, 1
	strh	w1, [x21, 56]
	add	x0, x21, x0, sxtw 1
	ldrh	w1, [x21]
	strh	w1, [x0, 58]
	mov	w0, -1
	strh	w0, [x21]
	b	.L3750
.L3739:
	mov	w2, 5
	strb	w2, [x19, #:lo12:.LANCHOR153]
	cmp	w1, w0
	bcc	.L3740
	ldrh	w0, [x21, 56]
	add	w1, w0, 1
	strh	w1, [x21, 56]
	add	x0, x21, x0, sxtw 1
	ldrh	w1, [x21]
	strh	w1, [x0, 58]
	mov	w0, -1
	strh	w0, [x21]
.L3740:
	bl	ftl_flush
	bl	sblk_wait_write_queue_completed
	bl	gc_write_completed
	ldr	x0, [x23, #:lo12:.LANCHOR10]
	ldrh	w1, [x20, 80]
	strh	w1, [x0, 128]
	bl	pm_flush
	bl	ftl_ext_info_flush
	adrp	x1, .LANCHOR87
	add	x0, x24, :lo12:.LANCHOR64
	adrp	x2, .LANCHOR35
	ldrh	w1, [x1, #:lo12:.LANCHOR87]
	strh	w1, [x0, 18]
	adrp	x1, .LANCHOR73
	ldrb	w2, [x2, #:lo12:.LANCHOR35]
	strh	wzr, [x0, 16]
	ldrb	w1, [x1, #:lo12:.LANCHOR73]
	strh	w1, [x0, 20]
	cbz	w2, .L3741
	adrp	x2, .LANCHOR79
	ldrh	w2, [x2, #:lo12:.LANCHOR79]
	strh	w2, [x0, 18]
	mov	w2, 1
	strh	w2, [x0, 20]
.L3741:
	cmp	w1, 2
	bne	.L3743
	add	x0, x24, :lo12:.LANCHOR64
	ldrh	w1, [x0, 18]
	ubfiz	w1, w1, 1, 15
	strh	w1, [x0, 18]
	adrp	x1, .LANCHOR74
	ldrb	w1, [x1, #:lo12:.LANCHOR74]
	cbnz	w1, .L3743
	mov	w1, 1
	strh	w1, [x0, 20]
.L3743:
	add	x24, x24, :lo12:.LANCHOR64
	strh	wzr, [x24, 22]
	b	.L3750
.L3746:
	ldrh	w1, [x24, 16]
	ldrh	w0, [x24, 18]
	cmp	w1, w0
	bcc	.L3747
	mov	w0, 6
	strb	w0, [x19, #:lo12:.LANCHOR153]
	ldr	x0, [x24, 8]
	bl	zbuf_free
	str	xzr, [x24, 8]
	b	.L3750
.L3747:
	cmp	w21, 15
	bls	.L3650
	cmp	w25, 1
	bne	.L3750
	add	w22, w22, 1
	and	w22, w22, 255
	cmp	w22, 4
	bls	.L3650
	b	.L3750
.L3649:
	bl	gc_update_l2p_map_new
	mov	w21, -1
	bl	gc_free_src_blk
	bl	ftl_flush
	bl	pm_flush
	strh	w21, [x20, 80]
	bl	ftl_ext_info_flush
	adrp	x0, .LANCHOR104
	ldr	x0, [x0, #:lo12:.LANCHOR104]
	strh	w21, [x0, 126]
	mov	w0, 0
	bl	ftl_info_flush
.L3821:
	strb	wzr, [x19, #:lo12:.LANCHOR153]
	b	.L3750
.L3726:
	mov	w2, 2644
	adrp	x1, .LANCHOR226
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR226
	add	x0, x0, :lo12:.LC0
	bl	printf
	b	.L3749
	.size	zftl_do_gc, .-zftl_do_gc
	.section	.text.zftl_write,"ax",@progbits
	.align	2
	.global	zftl_write
	.type	zftl_write, %function
zftl_write:
	stp	x29, x30, [sp, -112]!
	add	x29, sp, 0
	stp	x27, x28, [sp, 80]
	mov	w27, w0
	adrp	x0, .LANCHOR14
	stp	x19, x20, [sp, 16]
	stp	x23, x24, [sp, 48]
	mov	w19, w1
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	mov	w20, w2
	stp	x21, x22, [sp, 32]
	mov	x23, x3
	stp	x25, x26, [sp, 64]
	tbz	x0, 12, .L3824
	ldr	w4, [x23]
	mov	w3, w2
	adrp	x0, .LC246
	mov	w2, w1
	add	x0, x0, :lo12:.LC246
	mov	w1, w27
	bl	printf
.L3824:
	cbnz	w27, .L3825
	adrp	x0, .LANCHOR61
	mov	w27, 24576
	ldr	w0, [x0, #:lo12:.LANCHOR61]
.L3826:
	add	w1, w19, w20
	cmp	w0, w1
	bcc	.L3840
	adrp	x24, .LANCHOR125
	add	w27, w27, w19
	sub	w19, w20, #1
	adrp	x25, .LANCHOR104
	ldrb	w0, [x24, #:lo12:.LANCHOR125]
	add	w19, w19, w27
	add	x24, x24, :lo12:.LANCHOR125
	udiv	w22, w27, w0
	udiv	w19, w19, w0
	add	w0, w27, w20
	str	w0, [x29, 108]
	mov	w26, w22
	sub	w21, w19, w22
	add	w21, w21, 1
.L3828:
	cbnz	w21, .L3836
	adrp	x20, .LANCHOR97
	adrp	x19, .LANCHOR101
	add	x20, x20, :lo12:.LANCHOR97
	add	x19, x19, :lo12:.LANCHOR101
	bl	ftl_write_commit
	bl	ftl_flush
	mov	w1, 1
	mov	w0, 0
	bl	zftl_do_gc
.L3837:
	ldrh	w0, [x20]
	ldrh	w1, [x19]
	add	w0, w0, w1
	cmp	w0, 7
	ble	.L3838
	mov	w0, 0
.L3823:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L3825:
	cmp	w27, 3
	bhi	.L3840
	lsl	w27, w27, 13
	mov	w0, 8192
	b	.L3826
.L3836:
	mov	w0, 0
	bl	buf_alloc
	mov	x28, x0
	cbnz	x0, .L3829
	bl	ftl_write_commit
	b	.L3828
.L3829:
	ldrb	w3, [x24]
	cmp	w26, w22
	strb	wzr, [x0, 57]
	ccmp	w26, w19, 4, ne
	strb	w3, [x0, 56]
	bne	.L3832
	cmp	w26, w22
	bne	.L3833
	udiv	w0, w27, w3
	msub	w0, w0, w3, w27
	and	w0, w0, 255
	strb	w0, [x28, 57]
	sub	w3, w3, w0
	and	w3, w3, 255
	cmp	w20, w3
	csel	w3, w20, w3, cc
.L3845:
	strb	w3, [x28, 56]
.L3832:
	ldr	x3, [x28, 8]
	mov	x1, x23
	ldrb	w0, [x28, 57]
	sub	w21, w21, #1
	ldrb	w2, [x28, 56]
	ubfiz	x0, x0, 9, 8
	lsl	w2, w2, 9
	add	x0, x3, x0
	bl	ftl_memcpy
	ldr	x1, [x25, #:lo12:.LANCHOR104]
	ldr	w0, [x1, 8]
	str	w26, [x28, 36]
	add	w26, w26, 1
	add	w2, w0, 1
	str	w2, [x1, 8]
	str	w0, [x28, 32]
	mov	x0, x28
	bl	ftl_write_buf
	ldrb	w0, [x28, 56]
	ubfiz	x0, x0, 9, 8
	add	x23, x23, x0
	b	.L3828
.L3833:
	ldr	w0, [x29, 108]
	msub	w3, w3, w26, w0
	b	.L3845
.L3838:
	mov	w1, 1
	mov	w0, 0
	bl	zftl_do_gc
	b	.L3837
.L3840:
	mov	w0, -1
	b	.L3823
	.size	zftl_write, .-zftl_write
	.section	.text.ftl_vendor_write,"ax",@progbits
	.align	2
	.global	ftl_vendor_write
	.type	ftl_vendor_write, %function
ftl_vendor_write:
	mov	x3, x2
	mov	w2, w1
	add	w1, w0, 512
	mov	w0, 2
	b	zftl_write
	.size	ftl_vendor_write, .-ftl_vendor_write
	.section	.text.zftl_sys_write,"ax",@progbits
	.align	2
	.global	zftl_sys_write
	.type	zftl_sys_write, %function
zftl_sys_write:
	mov	x3, x2
	mov	w2, w1
	mov	w1, w0
	mov	w0, 2
	b	zftl_write
	.size	zftl_sys_write, .-zftl_sys_write
	.section	.text.StorageSysDataStore,"ax",@progbits
	.align	2
	.global	StorageSysDataStore
	.type	StorageSysDataStore, %function
StorageSysDataStore:
	mov	x3, x1
	mov	w2, 1
	mov	w1, w0
	mov	w0, 2
	b	zftl_write
	.size	StorageSysDataStore, .-StorageSysDataStore
	.section	.text.FlashBootVendorWrite,"ax",@progbits
	.align	2
	.global	FlashBootVendorWrite
	.type	FlashBootVendorWrite, %function
FlashBootVendorWrite:
	mov	x3, x2
	mov	w2, w1
	add	w1, w0, 512
	mov	w0, 2
	b	zftl_write
	.size	FlashBootVendorWrite, .-FlashBootVendorWrite
	.section	.text.ftl_write,"ax",@progbits
	.align	2
	.global	ftl_write
	.type	ftl_write, %function
ftl_write:
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w19, w2
	stp	x21, x22, [sp, 32]
	mov	x20, x3
	mov	w22, w1
	ands	w21, w0, 255
	bne	.L3851
	mov	w3, w2
	mov	w0, 0
	mov	x2, x20
	bl	idb_write_data
.L3851:
	mov	x3, x20
	mov	w2, w19
	mov	w1, w22
	mov	w0, w21
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	b	zftl_write
	.size	ftl_write, .-ftl_write
	.section	.text.zftl_discard,"ax",@progbits
	.align	2
	.global	zftl_discard
	.type	zftl_discard, %function
zftl_discard:
	stp	x29, x30, [sp, -128]!
	adrp	x2, .LANCHOR61
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w19, w1
	ldr	w2, [x2, #:lo12:.LANCHOR61]
	add	w1, w0, w1
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	cmp	w2, w1
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	bcc	.L3874
	adrp	x24, .LANCHOR227
	add	w22, w0, 24576
	adrp	x0, .LANCHOR14
	str	x0, [x29, 104]
	ldr	w1, [x24, #:lo12:.LANCHOR227]
	ldr	w2, [x0, #:lo12:.LANCHOR14]
	add	w1, w19, w1
	str	w1, [x24, #:lo12:.LANCHOR227]
	tbz	x2, 12, .L3855
	adrp	x0, .LC247
	mov	w4, 0
	mov	w3, w19
	mov	w2, w22
	add	x0, x0, :lo12:.LC247
	bl	printf
.L3855:
	adrp	x23, .LANCHOR104
	adrp	x26, .LANCHOR125
	ldr	x0, [x23, #:lo12:.LANCHOR104]
	ldr	w27, [x0, 8]
	add	w1, w27, 1
	str	w1, [x0, 8]
	bl	ftl_write_commit
	bl	ftl_flush
	ldrb	w21, [x26, #:lo12:.LANCHOR125]
	udiv	w20, w22, w21
	msub	w25, w20, w21, w22
	cbz	w25, .L3856
	sub	w21, w21, w25
	mov	w0, w20
	cmp	w21, w19
	csel	w21, w21, w19, ls
	bl	lpa_hash_get_ppa
	str	w0, [x29, 120]
	cmn	w0, #1
	bne	.L3857
	mov	w2, 0
	add	x1, x29, 120
	mov	w0, w20
	bl	pm_log2phys
.L3857:
	ldr	w0, [x29, 120]
	and	w28, w21, 65535
	cmn	w0, #1
	beq	.L3859
	mov	w0, 0
	bl	buf_alloc
	mov	x3, x0
	cbz	x0, .L3859
	strb	w25, [x0, 57]
	ubfiz	x25, x25, 9, 25
	strb	w21, [x0, 56]
	mov	w1, 0
	ldr	x0, [x0, 8]
	lsl	w2, w28, 9
	stp	w27, w20, [x3, 32]
	str	x3, [x29, 96]
	add	x0, x0, x25
	bl	ftl_memset
	ldr	x3, [x29, 96]
	mov	x0, x3
	bl	ftl_write_buf
	bl	ftl_write_commit
	ldr	x1, [x23, #:lo12:.LANCHOR104]
	ldr	w0, [x1, 76]
	add	w0, w0, 1
	str	w0, [x1, 76]
.L3859:
	add	w20, w20, 1
	sub	w19, w19, w28
.L3856:
	cbz	w19, .L3861
	bl	ftl_flush
.L3861:
	adrp	x25, .LANCHOR68
	add	x21, x26, :lo12:.LANCHOR125
	add	x25, x25, :lo12:.LANCHOR68
	mov	w0, -1
	str	w0, [x29, 124]
.L3862:
	ldrb	w0, [x21]
	cmp	w19, w0
	bcs	.L3867
	cbz	w19, .L3869
	mov	w0, w20
	bl	lpa_hash_get_ppa
	str	w0, [x29, 120]
	cmn	w0, #1
	bne	.L3870
	mov	w2, 0
	add	x1, x29, 120
	mov	w0, w20
	bl	pm_log2phys
.L3870:
	ldr	w0, [x29, 120]
	cmn	w0, #1
	beq	.L3869
	mov	w0, 0
	bl	buf_alloc
	mov	x21, x0
	cbz	x0, .L3869
	strb	wzr, [x0, 57]
	strb	w19, [x0, 56]
	stp	w27, w20, [x21, 32]
	ldrb	w0, [x26, #:lo12:.LANCHOR125]
	cmp	w19, w0
	bcc	.L3872
	adrp	x1, .LANCHOR228
	adrp	x0, .LC0
	mov	w2, 1259
	add	x1, x1, :lo12:.LANCHOR228
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3872:
	ldr	x0, [x21, 8]
	lsl	w2, w19, 9
	mov	w1, 0
	bl	ftl_memset
	mov	x0, x21
	bl	ftl_write_buf
	bl	ftl_write_commit
	ldr	x1, [x23, #:lo12:.LANCHOR104]
	ldr	w0, [x1, 76]
	add	w0, w0, 1
	str	w0, [x1, 76]
.L3869:
	ldr	w1, [x24, #:lo12:.LANCHOR227]
	cmp	w1, 8192
	bls	.L3875
	ldr	x0, [x29, 104]
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L3873
	adrp	x0, .LC247
	mov	w4, 0
	mov	w3, w19
	mov	w2, w22
	add	x0, x0, :lo12:.LC247
	bl	printf
.L3873:
	str	wzr, [x24, #:lo12:.LANCHOR227]
	bl	flt_sys_flush
	adrp	x0, .LANCHOR116
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR116]
.L3875:
	mov	w0, 0
	b	.L3853
.L3867:
	mov	w0, w20
	bl	lpa_hash_get_ppa
	str	w0, [x29, 120]
	cmn	w0, #1
	beq	.L3863
	mov	w0, 0
	bl	buf_alloc
	mov	x28, x0
	cbz	x0, .L3865
	ldrb	w2, [x21]
	mov	w1, 0
	strb	w2, [x0, 56]
	strb	wzr, [x0, 57]
	ldr	x0, [x0, 8]
	lsl	w2, w2, 9
	stp	w27, w20, [x28, 32]
	bl	ftl_memset
	mov	x0, x28
	bl	ftl_write_buf
	bl	ftl_write_commit
.L3901:
	ldr	x1, [x23, #:lo12:.LANCHOR104]
	ldr	w0, [x1, 76]
	add	w0, w0, 1
	str	w0, [x1, 76]
.L3865:
	ldrb	w0, [x21]
	add	w20, w20, 1
	sub	w19, w19, w0
	b	.L3862
.L3863:
	mov	w2, 0
	add	x1, x29, 120
	mov	w0, w20
	bl	pm_log2phys
	ldr	w0, [x29, 120]
	cmn	w0, #1
	beq	.L3865
	add	x1, x29, 124
	mov	w2, 1
	mov	w0, w20
	bl	pm_log2phys
	adrp	x0, .LANCHOR31
	ldrh	w2, [x25]
	ldrb	w1, [x0, #:lo12:.LANCHOR31]
	mov	w0, 24
	sub	w0, w0, w1
	sub	w1, w0, w2
	mov	w0, 1
	lsl	w0, w0, w1
	ldr	w1, [x29, 120]
	sub	w0, w0, #1
	lsr	w1, w1, w2
	and	w0, w0, w1
	adrp	x1, .LANCHOR69
	ldrb	w1, [x1, #:lo12:.LANCHOR69]
	udiv	w0, w0, w1
	bl	ftl_vpn_decrement
	b	.L3901
.L3874:
	mov	w0, -1
.L3853:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
	.size	zftl_discard, .-zftl_discard
	.section	.text.ftl_discard,"ax",@progbits
	.align	2
	.global	ftl_discard
	.type	ftl_discard, %function
ftl_discard:
	mov	w0, w1
	mov	w1, w2
	b	zftl_discard
	.size	ftl_discard, .-ftl_discard
	.section	.text.dump_pm_blk,"ax",@progbits
	.align	2
	.global	dump_pm_blk
	.type	dump_pm_blk, %function
dump_pm_blk:
	stp	x29, x30, [sp, -48]!
	mov	w2, 4
	adrp	x0, .LC248
	add	x0, x0, :lo12:.LC248
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR104
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR149
	ldr	x1, [x20, #:lo12:.LANCHOR104]
	mov	w19, 0
	mov	w22, 65535
	add	x1, x1, 704
	ldrh	w3, [x1, -6]
	bl	rknand_print_hex
	ldrh	w3, [x21, #:lo12:.LANCHOR149]
	add	x21, x21, :lo12:.LANCHOR149
	ldr	x1, [x20, #:lo12:.LANCHOR104]
	mov	w2, 2
	adrp	x0, .LC249
	add	x0, x0, :lo12:.LC249
	add	x1, x1, 416
	bl	rknand_print_hex
.L3904:
	ldrh	w0, [x21]
	cmp	w0, w19
	bhi	.L3906
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L3906:
	ldr	x0, [x20, #:lo12:.LANCHOR104]
	add	x0, x0, x19, sxtw 1
	ldrh	w0, [x0, 416]
	cmp	w0, w22
	beq	.L3905
	mov	x1, 0
	bl	ftl_sblk_dump
.L3905:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L3904
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
	.section	.bss.IDByte,"aw",@nobits
	.align	2
	.set	.LANCHOR44,. + 0
	.type	IDByte, %object
	.size	IDByte, 32
IDByte:
	.zero	32
	.section	.bss._c_ftl_blk_pre_plane,"aw",@nobits
	.align	1
	.set	.LANCHOR6,. + 0
	.type	_c_ftl_blk_pre_plane, %object
	.size	_c_ftl_blk_pre_plane, 2
_c_ftl_blk_pre_plane:
	.zero	2
	.section	.bss._c_ftl_block_addr_log2,"aw",@nobits
	.align	1
	.set	.LANCHOR68,. + 0
	.type	_c_ftl_block_addr_log2, %object
	.size	_c_ftl_block_addr_log2, 2
_c_ftl_block_addr_log2:
	.zero	2
	.section	.bss._c_ftl_block_align_addr,"aw",@nobits
	.align	1
	.set	.LANCHOR105,. + 0
	.type	_c_ftl_block_align_addr, %object
	.size	_c_ftl_block_align_addr, 2
_c_ftl_block_align_addr:
	.zero	2
	.section	.bss._c_ftl_byte_pre_page,"aw",@nobits
	.align	1
	.set	.LANCHOR208,. + 0
	.type	_c_ftl_byte_pre_page, %object
	.size	_c_ftl_byte_pre_page, 2
_c_ftl_byte_pre_page:
	.zero	2
	.section	.bss._c_ftl_cs_bits,"aw",@nobits
	.set	.LANCHOR31,. + 0
	.type	_c_ftl_cs_bits, %object
	.size	_c_ftl_cs_bits, 1
_c_ftl_cs_bits:
	.zero	1
	.section	.bss._c_ftl_nand_blks_per_die,"aw",@nobits
	.align	1
	.type	_c_ftl_nand_blks_per_die, %object
	.size	_c_ftl_nand_blks_per_die, 2
_c_ftl_nand_blks_per_die:
	.zero	2
	.section	.bss._c_ftl_nand_die_num,"aw",@nobits
	.set	.LANCHOR106,. + 0
	.type	_c_ftl_nand_die_num, %object
	.size	_c_ftl_nand_die_num, 1
_c_ftl_nand_die_num:
	.zero	1
	.section	.bss._c_ftl_nand_planes_num,"aw",@nobits
	.set	.LANCHOR80,. + 0
	.type	_c_ftl_nand_planes_num, %object
	.size	_c_ftl_nand_planes_num, 1
_c_ftl_nand_planes_num:
	.zero	1
	.section	.bss._c_ftl_nand_type,"aw",@nobits
	.set	.LANCHOR73,. + 0
	.type	_c_ftl_nand_type, %object
	.size	_c_ftl_nand_type, 1
_c_ftl_nand_type:
	.zero	1
	.section	.bss._c_ftl_page_pre_blk,"aw",@nobits
	.align	1
	.set	.LANCHOR79,. + 0
	.type	_c_ftl_page_pre_blk, %object
	.size	_c_ftl_page_pre_blk, 2
_c_ftl_page_pre_blk:
	.zero	2
	.section	.bss._c_ftl_page_pre_slc_blk,"aw",@nobits
	.align	1
	.set	.LANCHOR87,. + 0
	.type	_c_ftl_page_pre_slc_blk, %object
	.size	_c_ftl_page_pre_slc_blk, 2
_c_ftl_page_pre_slc_blk:
	.zero	2
	.section	.bss._c_ftl_planes_per_die,"aw",@nobits
	.set	.LANCHOR69,. + 0
	.type	_c_ftl_planes_per_die, %object
	.size	_c_ftl_planes_per_die, 1
_c_ftl_planes_per_die:
	.zero	1
	.section	.bss._c_ftl_pm_page_num,"aw",@nobits
	.align	1
	.set	.LANCHOR194,. + 0
	.type	_c_ftl_pm_page_num, %object
	.size	_c_ftl_pm_page_num, 2
_c_ftl_pm_page_num:
	.zero	2
	.section	.bss._c_ftl_sec_per_page,"aw",@nobits
	.set	.LANCHOR125,. + 0
	.type	_c_ftl_sec_per_page, %object
	.size	_c_ftl_sec_per_page, 1
_c_ftl_sec_per_page:
	.zero	1
	.section	.bss._c_max_pm_sblk,"aw",@nobits
	.align	1
	.set	.LANCHOR149,. + 0
	.type	_c_max_pm_sblk, %object
	.size	_c_max_pm_sblk, 2
_c_max_pm_sblk:
	.zero	2
	.section	.bss._c_mix_max_slc_ec_count,"aw",@nobits
	.align	1
	.set	.LANCHOR120,. + 0
	.type	_c_mix_max_slc_ec_count, %object
	.size	_c_mix_max_slc_ec_count, 2
_c_mix_max_slc_ec_count:
	.zero	2
	.section	.bss._c_mix_max_xlc_ec_count,"aw",@nobits
	.align	1
	.set	.LANCHOR118,. + 0
	.type	_c_mix_max_xlc_ec_count, %object
	.size	_c_mix_max_xlc_ec_count, 2
_c_mix_max_xlc_ec_count:
	.zero	2
	.section	.bss._c_slc_to_xlc_ec_ratio,"aw",@nobits
	.align	1
	.set	.LANCHOR8,. + 0
	.type	_c_slc_to_xlc_ec_ratio, %object
	.size	_c_slc_to_xlc_ec_ratio, 2
_c_slc_to_xlc_ec_ratio:
	.zero	2
	.section	.bss._c_swl_slc_gc_th,"aw",@nobits
	.align	1
	.set	.LANCHOR148,. + 0
	.type	_c_swl_slc_gc_th, %object
	.size	_c_swl_slc_gc_th, 2
_c_swl_slc_gc_th:
	.zero	2
	.section	.bss._c_swl_xlc_gc_th,"aw",@nobits
	.align	1
	.set	.LANCHOR147,. + 0
	.type	_c_swl_xlc_gc_th, %object
	.size	_c_swl_xlc_gc_th, 2
_c_swl_xlc_gc_th:
	.zero	2
	.section	.bss._c_totle_data_density,"aw",@nobits
	.align	2
	.set	.LANCHOR213,. + 0
	.type	_c_totle_data_density, %object
	.size	_c_totle_data_density, 4
_c_totle_data_density:
	.zero	4
	.section	.bss._c_totle_log_page,"aw",@nobits
	.align	2
	.set	.LANCHOR122,. + 0
	.type	_c_totle_log_page, %object
	.size	_c_totle_log_page, 4
_c_totle_log_page:
	.zero	4
	.section	.bss._c_totle_phy_density,"aw",@nobits
	.align	2
	.set	.LANCHOR212,. + 0
	.type	_c_totle_phy_density, %object
	.size	_c_totle_phy_density, 4
_c_totle_phy_density:
	.zero	4
	.section	.bss._c_user_data_density,"aw",@nobits
	.align	2
	.set	.LANCHOR61,. + 0
	.type	_c_user_data_density, %object
	.size	_c_user_data_density, 4
_c_user_data_density:
	.zero	4
	.section	.bss._gc_after_discard_en,"aw",@nobits
	.align	2
	.set	.LANCHOR116,. + 0
	.type	_gc_after_discard_en, %object
	.size	_gc_after_discard_en, 4
_gc_after_discard_en:
	.zero	4
	.section	.bss._last_read_time,"aw",@nobits
	.align	2
	.type	_last_read_time, %object
	.size	_last_read_time, 4
_last_read_time:
	.zero	4
	.section	.bss._last_write_time,"aw",@nobits
	.align	2
	.type	_last_write_time, %object
	.size	_last_write_time, 4
_last_write_time:
	.zero	4
	.section	.bss._max_slc_super_block,"aw",@nobits
	.align	1
	.set	.LANCHOR119,. + 0
	.type	_max_slc_super_block, %object
	.size	_max_slc_super_block, 2
_max_slc_super_block:
	.zero	2
	.section	.bss._max_xlc_super_block,"aw",@nobits
	.align	1
	.set	.LANCHOR95,. + 0
	.type	_max_xlc_super_block, %object
	.size	_max_xlc_super_block, 2
_max_xlc_super_block:
	.zero	2
	.section	.bss._min_slc_super_block,"aw",@nobits
	.align	1
	.set	.LANCHOR91,. + 0
	.type	_min_slc_super_block, %object
	.size	_min_slc_super_block, 2
_min_slc_super_block:
	.zero	2
	.section	.bss.discard_sector_count,"aw",@nobits
	.align	2
	.set	.LANCHOR227,. + 0
	.type	discard_sector_count, %object
	.size	discard_sector_count, 4
discard_sector_count:
	.zero	4
	.section	.bss.fill_spare_size,"aw",@nobits
	.align	1
	.set	.LANCHOR50,. + 0
	.type	fill_spare_size, %object
	.size	fill_spare_size, 2
fill_spare_size:
	.zero	2
	.section	.bss.flash_ddr_tuning_sdr_read_count,"aw",@nobits
	.align	2
	.set	.LANCHOR163,. + 0
	.type	flash_ddr_tuning_sdr_read_count, %object
	.size	flash_ddr_tuning_sdr_read_count, 4
flash_ddr_tuning_sdr_read_count:
	.zero	4
	.section	.bss.flash_read_retry,"aw",@nobits
	.align	3
	.set	.LANCHOR165,. + 0
	.type	flash_read_retry, %object
	.size	flash_read_retry, 8
flash_read_retry:
	.zero	8
	.section	.bss.free_buf_count,"aw",@nobits
	.set	.LANCHOR54,. + 0
	.type	free_buf_count, %object
	.size	free_buf_count, 1
free_buf_count:
	.zero	1
	.section	.bss.free_mix_sblk,"aw",@nobits
	.align	1
	.set	.LANCHOR101,. + 0
	.type	free_mix_sblk, %object
	.size	free_mix_sblk, 2
free_mix_sblk:
	.zero	2
	.section	.bss.free_slc_sblk,"aw",@nobits
	.align	1
	.set	.LANCHOR97,. + 0
	.type	free_slc_sblk, %object
	.size	free_slc_sblk, 2
free_slc_sblk:
	.zero	2
	.section	.bss.free_xlc_sblk,"aw",@nobits
	.align	1
	.set	.LANCHOR99,. + 0
	.type	free_xlc_sblk, %object
	.size	free_xlc_sblk, 2
free_xlc_sblk:
	.zero	2
	.section	.bss.ftl_ext_info_data_buffer,"aw",@nobits
	.align	6
	.type	ftl_ext_info_data_buffer, %object
	.size	ftl_ext_info_data_buffer, 16384
ftl_ext_info_data_buffer:
	.zero	16384
	.section	.bss.ftl_ext_info_first_write,"aw",@nobits
	.set	.LANCHOR186,. + 0
	.type	ftl_ext_info_first_write, %object
	.size	ftl_ext_info_first_write, 1
ftl_ext_info_first_write:
	.zero	1
	.section	.bss.ftl_flush_jiffies,"aw",@nobits
	.align	2
	.set	.LANCHOR222,. + 0
	.type	ftl_flush_jiffies, %object
	.size	ftl_flush_jiffies, 4
ftl_flush_jiffies:
	.zero	4
	.section	.bss.ftl_info_data_buffer,"aw",@nobits
	.align	6
	.type	ftl_info_data_buffer, %object
	.size	ftl_info_data_buffer, 16384
ftl_info_data_buffer:
	.zero	16384
	.section	.bss.ftl_info_spare,"aw",@nobits
	.align	6
	.set	.LANCHOR181,. + 0
	.type	ftl_info_spare, %object
	.size	ftl_info_spare, 256
ftl_info_spare:
	.zero	256
	.section	.bss.ftl_low_format_cur_blk,"aw",@nobits
	.align	1
	.set	.LANCHOR62,. + 0
	.type	ftl_low_format_cur_blk, %object
	.size	ftl_low_format_cur_blk, 2
ftl_low_format_cur_blk:
	.zero	2
	.section	.bss.ftl_power_lost_flag,"aw",@nobits
	.set	.LANCHOR185,. + 0
	.type	ftl_power_lost_flag, %object
	.size	ftl_power_lost_flag, 1
ftl_power_lost_flag:
	.zero	1
	.section	.bss.ftl_sblk_lpa_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR111,. + 0
	.type	ftl_sblk_lpa_tbl, %object
	.size	ftl_sblk_lpa_tbl, 8
ftl_sblk_lpa_tbl:
	.zero	8
	.section	.bss.ftl_sblk_update_list,"aw",@nobits
	.align	3
	.set	.LANCHOR67,. + 0
	.type	ftl_sblk_update_list, %object
	.size	ftl_sblk_update_list, 16
ftl_sblk_update_list:
	.zero	16
	.section	.bss.ftl_sblk_update_list_offset,"aw",@nobits
	.align	1
	.set	.LANCHOR117,. + 0
	.type	ftl_sblk_update_list_offset, %object
	.size	ftl_sblk_update_list_offset, 2
ftl_sblk_update_list_offset:
	.zero	2
	.section	.bss.ftl_sblk_vpn,"aw",@nobits
	.align	3
	.set	.LANCHOR9,. + 0
	.type	ftl_sblk_vpn, %object
	.size	ftl_sblk_vpn, 8
ftl_sblk_vpn:
	.zero	8
	.section	.bss.ftl_sblk_vpn_update_id,"aw",@nobits
	.align	1
	.set	.LANCHOR66,. + 0
	.type	ftl_sblk_vpn_update_id, %object
	.size	ftl_sblk_vpn_update_id, 2
ftl_sblk_vpn_update_id:
	.zero	2
	.section	.bss.ftl_sys_info_first_write,"aw",@nobits
	.set	.LANCHOR184,. + 0
	.type	ftl_sys_info_first_write, %object
	.size	ftl_sys_info_first_write, 1
ftl_sys_info_first_write:
	.zero	1
	.section	.bss.ftl_tmp_buffer,"aw",@nobits
	.align	6
	.type	ftl_tmp_buffer, %object
	.size	ftl_tmp_buffer, 16384
ftl_tmp_buffer:
	.zero	16384
	.section	.bss.ftl_tmp_spare,"aw",@nobits
	.align	6
	.set	.LANCHOR179,. + 0
	.type	ftl_tmp_spare, %object
	.size	ftl_tmp_spare, 256
ftl_tmp_spare:
	.zero	256
	.section	.bss.ftl_vpn_update_count,"aw",@nobits
	.align	1
	.set	.LANCHOR115,. + 0
	.type	ftl_vpn_update_count, %object
	.size	ftl_vpn_update_count, 2
ftl_vpn_update_count:
	.zero	2
	.section	.bss.g_block_align_addr,"aw",@nobits
	.align	1
	.set	.LANCHOR2,. + 0
	.type	g_block_align_addr, %object
	.size	g_block_align_addr, 2
g_block_align_addr:
	.zero	2
	.section	.bss.g_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR52,. + 0
	.type	g_buf, %object
	.size	g_buf, 2048
g_buf:
	.zero	2048
	.section	.bss.g_die_addr,"aw",@nobits
	.align	2
	.set	.LANCHOR143,. + 0
	.type	g_die_addr, %object
	.size	g_die_addr, 32
g_die_addr:
	.zero	32
	.section	.bss.g_die_cs_idx,"aw",@nobits
	.align	2
	.set	.LANCHOR30,. + 0
	.type	g_die_cs_idx, %object
	.size	g_die_cs_idx, 8
g_die_cs_idx:
	.zero	8
	.section	.bss.g_flash_3d_mlc_flag,"aw",@nobits
	.set	.LANCHOR74,. + 0
	.type	g_flash_3d_mlc_flag, %object
	.size	g_flash_3d_mlc_flag, 1
g_flash_3d_mlc_flag:
	.zero	1
	.section	.bss.g_flash_3d_tlc_flag,"aw",@nobits
	.set	.LANCHOR77,. + 0
	.type	g_flash_3d_tlc_flag, %object
	.size	g_flash_3d_tlc_flag, 1
g_flash_3d_tlc_flag:
	.zero	1
	.section	.bss.g_flash_blk_info,"aw",@nobits
	.align	3
	.set	.LANCHOR198,. + 0
	.type	g_flash_blk_info, %object
	.size	g_flash_blk_info, 4
g_flash_blk_info:
	.zero	4
	.section	.bss.g_flash_cur_mode,"aw",@nobits
	.align	3
	.set	.LANCHOR33,. + 0
	.type	g_flash_cur_mode, %object
	.size	g_flash_cur_mode, 4
g_flash_cur_mode:
	.zero	4
	.section	.bss.g_flash_interface_mode,"aw",@nobits
	.set	.LANCHOR45,. + 0
	.type	g_flash_interface_mode, %object
	.size	g_flash_interface_mode, 1
g_flash_interface_mode:
	.zero	1
	.section	.bss.g_flash_micron_3d_tlc_b05a,"aw",@nobits
	.set	.LANCHOR204,. + 0
	.type	g_flash_micron_3d_tlc_b05a, %object
	.size	g_flash_micron_3d_tlc_b05a, 1
g_flash_micron_3d_tlc_b05a:
	.zero	1
	.section	.bss.g_flash_micron_3d_tlc_b16a,"aw",@nobits
	.set	.LANCHOR205,. + 0
	.type	g_flash_micron_3d_tlc_b16a, %object
	.size	g_flash_micron_3d_tlc_b16a, 1
g_flash_micron_3d_tlc_b16a:
	.zero	1
	.section	.bss.g_flash_micron_3d_tlc_flag,"aw",@nobits
	.set	.LANCHOR35,. + 0
	.type	g_flash_micron_3d_tlc_flag, %object
	.size	g_flash_micron_3d_tlc_flag, 1
g_flash_micron_3d_tlc_flag:
	.zero	1
	.section	.bss.g_flash_multi_page_prog_en,"aw",@nobits
	.set	.LANCHOR41,. + 0
	.type	g_flash_multi_page_prog_en, %object
	.size	g_flash_multi_page_prog_en, 1
g_flash_multi_page_prog_en:
	.zero	1
	.section	.bss.g_flash_multi_page_read_en,"aw",@nobits
	.set	.LANCHOR171,. + 0
	.type	g_flash_multi_page_read_en, %object
	.size	g_flash_multi_page_read_en, 1
g_flash_multi_page_read_en:
	.zero	1
	.section	.bss.g_flash_page_buffer,"aw",@nobits
	.align	3
	.set	.LANCHOR167,. + 0
	.type	g_flash_page_buffer, %object
	.size	g_flash_page_buffer, 8
g_flash_page_buffer:
	.zero	8
	.section	.bss.g_flash_reversd_blks,"aw",@nobits
	.set	.LANCHOR203,. + 0
	.type	g_flash_reversd_blks, %object
	.size	g_flash_reversd_blks, 1
g_flash_reversd_blks:
	.zero	1
	.section	.bss.g_flash_slc_mode,"aw",@nobits
	.set	.LANCHOR0,. + 0
	.type	g_flash_slc_mode, %object
	.size	g_flash_slc_mode, 1
g_flash_slc_mode:
	.zero	1
	.section	.bss.g_flash_spare_buffer,"aw",@nobits
	.align	3
	.set	.LANCHOR166,. + 0
	.type	g_flash_spare_buffer, %object
	.size	g_flash_spare_buffer, 8
g_flash_spare_buffer:
	.zero	8
	.section	.bss.g_flash_sys_spare_buffer,"aw",@nobits
	.align	3
	.set	.LANCHOR197,. + 0
	.type	g_flash_sys_spare_buffer, %object
	.size	g_flash_sys_spare_buffer, 8
g_flash_sys_spare_buffer:
	.zero	8
	.section	.bss.g_flash_tmp_page_buffer,"aw",@nobits
	.align	3
	.set	.LANCHOR159,. + 0
	.type	g_flash_tmp_page_buffer, %object
	.size	g_flash_tmp_page_buffer, 8
g_flash_tmp_page_buffer:
	.zero	8
	.section	.bss.g_flash_tmp_spare_buffer,"aw",@nobits
	.align	3
	.set	.LANCHOR161,. + 0
	.type	g_flash_tmp_spare_buffer, %object
	.size	g_flash_tmp_spare_buffer, 8
g_flash_tmp_spare_buffer:
	.zero	8
	.section	.bss.g_flash_toggle_mode_en,"aw",@nobits
	.set	.LANCHOR21,. + 0
	.type	g_flash_toggle_mode_en, %object
	.size	g_flash_toggle_mode_en, 1
g_flash_toggle_mode_en:
	.zero	1
	.section	.bss.g_ftl_info_blk,"aw",@nobits
	.align	6
	.set	.LANCHOR182,. + 0
	.type	g_ftl_info_blk, %object
	.size	g_ftl_info_blk, 4
g_ftl_info_blk:
	.zero	4
	.section	.bss.g_gc_info,"aw",@nobits
	.align	3
	.set	.LANCHOR64,. + 0
	.type	g_gc_info, %object
	.size	g_gc_info, 600
g_gc_info:
	.zero	600
	.section	.bss.g_idb_ecc_bits,"aw",@nobits
	.set	.LANCHOR17,. + 0
	.type	g_idb_ecc_bits, %object
	.size	g_idb_ecc_bits, 1
g_idb_ecc_bits:
	.zero	1
	.section	.bss.g_idb_slc_mode_enable,"aw",@nobits
	.set	.LANCHOR19,. + 0
	.type	g_idb_slc_mode_enable, %object
	.size	g_idb_slc_mode_enable, 1
g_idb_slc_mode_enable:
	.zero	1
	.section	.bss.g_lsb_page_tbl,"aw",@nobits
	.align	2
	.set	.LANCHOR3,. + 0
	.type	g_lsb_page_tbl, %object
	.size	g_lsb_page_tbl, 512
g_lsb_page_tbl:
	.zero	512
	.section	.bss.g_maxRegNum,"aw",@nobits
	.set	.LANCHOR26,. + 0
	.type	g_maxRegNum, %object
	.size	g_maxRegNum, 1
g_maxRegNum:
	.zero	1
	.section	.bss.g_maxRetryCount,"aw",@nobits
	.set	.LANCHOR162,. + 0
	.type	g_maxRetryCount, %object
	.size	g_maxRetryCount, 1
g_maxRetryCount:
	.zero	1
	.section	.bss.g_msb_page_tbl,"aw",@nobits
	.align	2
	.set	.LANCHOR140,. + 0
	.type	g_msb_page_tbl, %object
	.size	g_msb_page_tbl, 1024
g_msb_page_tbl:
	.zero	1024
	.section	.bss.g_nand_max_die,"aw",@nobits
	.set	.LANCHOR18,. + 0
	.type	g_nand_max_die, %object
	.size	g_nand_max_die, 1
g_nand_max_die:
	.zero	1
	.section	.bss.g_nand_opt_para,"aw",@nobits
	.align	3
	.set	.LANCHOR20,. + 0
	.type	g_nand_opt_para, %object
	.size	g_nand_opt_para, 32
g_nand_opt_para:
	.zero	32
	.section	.bss.g_nandc_ecc_bits,"aw",@nobits
	.set	.LANCHOR46,. + 0
	.type	g_nandc_ecc_bits, %object
	.size	g_nandc_ecc_bits, 1
g_nandc_ecc_bits:
	.zero	1
	.section	.bss.g_nandc_tran_timeout,"aw",@nobits
	.set	.LANCHOR160,. + 0
	.type	g_nandc_tran_timeout, %object
	.size	g_nandc_tran_timeout, 1
g_nandc_tran_timeout:
	.zero	1
	.section	.bss.g_nandc_v6_master_info,"aw",@nobits
	.align	3
	.set	.LANCHOR49,. + 0
	.type	g_nandc_v6_master_info, %object
	.size	g_nandc_v6_master_info, 40
g_nandc_v6_master_info:
	.zero	40
	.section	.bss.g_nandc_ver,"aw",@nobits
	.set	.LANCHOR28,. + 0
	.type	g_nandc_ver, %object
	.size	g_nandc_ver, 1
g_nandc_ver:
	.zero	1
	.section	.bss.g_one_pass_program,"aw",@nobits
	.set	.LANCHOR75,. + 0
	.type	g_one_pass_program, %object
	.size	g_one_pass_program, 1
g_one_pass_program:
	.zero	1
	.section	.bss.g_pm_spare,"aw",@nobits
	.align	3
	.set	.LANCHOR191,. + 0
	.type	g_pm_spare, %object
	.size	g_pm_spare, 8
g_pm_spare:
	.zero	8
	.section	.bss.g_retryMode,"aw",@nobits
	.set	.LANCHOR24,. + 0
	.type	g_retryMode, %object
	.size	g_retryMode, 1
g_retryMode:
	.zero	1
	.section	.bss.g_slc_mode_addr2,"aw",@nobits
	.set	.LANCHOR1,. + 0
	.type	g_slc_mode_addr2, %object
	.size	g_slc_mode_addr2, 1
g_slc_mode_addr2:
	.zero	1
	.section	.bss.g_slc_mode_enable,"aw",@nobits
	.type	g_slc_mode_enable, %object
	.size	g_slc_mode_enable, 1
g_slc_mode_enable:
	.zero	1
	.section	.bss.g_slc_page_num,"aw",@nobits
	.align	1
	.set	.LANCHOR142,. + 0
	.type	g_slc_page_num, %object
	.size	g_slc_page_num, 2
g_slc_page_num:
	.zero	2
	.section	.bss.g_totle_phy_block,"aw",@nobits
	.align	1
	.set	.LANCHOR144,. + 0
	.type	g_totle_phy_block, %object
	.size	g_totle_phy_block, 2
g_totle_phy_block:
	.zero	2
	.section	.bss.gc_des_ppa_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR157,. + 0
	.type	gc_des_ppa_tbl, %object
	.size	gc_des_ppa_tbl, 8
gc_des_ppa_tbl:
	.zero	8
	.section	.bss.gc_free_slc_sblk_th,"aw",@nobits
	.align	1
	.set	.LANCHOR81,. + 0
	.type	gc_free_slc_sblk_th, %object
	.size	gc_free_slc_sblk_th, 2
gc_free_slc_sblk_th:
	.zero	2
	.section	.bss.gc_lpa_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR155,. + 0
	.type	gc_lpa_tbl, %object
	.size	gc_lpa_tbl, 8
gc_lpa_tbl:
	.zero	8
	.section	.bss.gc_mode,"aw",@nobits
	.set	.LANCHOR78,. + 0
	.type	gc_mode, %object
	.size	gc_mode, 1
gc_mode:
	.zero	1
	.section	.bss.gc_page_buf_id,"aw",@nobits
	.align	3
	.set	.LANCHOR76,. + 0
	.type	gc_page_buf_id, %object
	.size	gc_page_buf_id, 8
gc_page_buf_id:
	.zero	8
	.section	.bss.gc_pre_ppa_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR156,. + 0
	.type	gc_pre_ppa_tbl, %object
	.size	gc_pre_ppa_tbl, 8
gc_pre_ppa_tbl:
	.zero	8
	.section	.bss.gc_search_count,"aw",@nobits
	.align	2
	.set	.LANCHOR154,. + 0
	.type	gc_search_count, %object
	.size	gc_search_count, 4
gc_search_count:
	.zero	4
	.section	.bss.gc_slc_cache_index,"aw",@nobits
	.align	1
	.set	.LANCHOR84,. + 0
	.type	gc_slc_cache_index, %object
	.size	gc_slc_cache_index, 2
gc_slc_cache_index:
	.zero	2
	.section	.bss.gc_slc_data_index,"aw",@nobits
	.align	1
	.set	.LANCHOR88,. + 0
	.type	gc_slc_data_index, %object
	.size	gc_slc_data_index, 2
gc_slc_data_index:
	.zero	2
	.section	.bss.gc_slc_mode_tlc_vpn_th,"aw",@nobits
	.align	1
	.set	.LANCHOR86,. + 0
	.type	gc_slc_mode_tlc_vpn_th, %object
	.size	gc_slc_mode_tlc_vpn_th, 2
gc_slc_mode_tlc_vpn_th:
	.zero	2
	.section	.bss.gc_slc_mode_vpn_th,"aw",@nobits
	.align	1
	.set	.LANCHOR63,. + 0
	.type	gc_slc_mode_vpn_th, %object
	.size	gc_slc_mode_vpn_th, 2
gc_slc_mode_vpn_th:
	.zero	2
	.section	.bss.gc_state,"aw",@nobits
	.set	.LANCHOR153,. + 0
	.type	gc_state, %object
	.size	gc_state, 1
gc_state:
	.zero	1
	.section	.bss.gc_tlc_mode_slc_vpn_th,"aw",@nobits
	.align	1
	.set	.LANCHOR96,. + 0
	.type	gc_tlc_mode_slc_vpn_th, %object
	.size	gc_tlc_mode_slc_vpn_th, 2
gc_tlc_mode_slc_vpn_th:
	.zero	2
	.section	.bss.gc_tlc_mode_tlc_vpn_th,"aw",@nobits
	.align	1
	.set	.LANCHOR93,. + 0
	.type	gc_tlc_mode_tlc_vpn_th, %object
	.size	gc_tlc_mode_tlc_vpn_th, 2
gc_tlc_mode_tlc_vpn_th:
	.zero	2
	.section	.bss.gc_valid_page_ppa,"aw",@nobits
	.align	3
	.set	.LANCHOR70,. + 0
	.type	gc_valid_page_ppa, %object
	.size	gc_valid_page_ppa, 8
gc_valid_page_ppa:
	.zero	8
	.section	.bss.gc_xlc_data_index,"aw",@nobits
	.align	1
	.set	.LANCHOR85,. + 0
	.type	gc_xlc_data_index, %object
	.size	gc_xlc_data_index, 2
gc_xlc_data_index:
	.zero	2
	.section	.bss.gc_xlc_search_index,"aw",@nobits
	.align	1
	.set	.LANCHOR89,. + 0
	.type	gc_xlc_search_index, %object
	.size	gc_xlc_search_index, 2
gc_xlc_search_index:
	.zero	2
	.section	.bss.gp_blk_info,"aw",@nobits
	.align	3
	.set	.LANCHOR7,. + 0
	.type	gp_blk_info, %object
	.size	gp_blk_info, 8
gp_blk_info:
	.zero	8
	.section	.bss.gp_data_slc_cache_head,"aw",@nobits
	.align	3
	.set	.LANCHOR83,. + 0
	.type	gp_data_slc_cache_head, %object
	.size	gp_data_slc_cache_head, 8
gp_data_slc_cache_head:
	.zero	8
	.section	.bss.gp_data_slc_data_head,"aw",@nobits
	.align	3
	.set	.LANCHOR12,. + 0
	.type	gp_data_slc_data_head, %object
	.size	gp_data_slc_data_head, 8
gp_data_slc_data_head:
	.zero	8
	.section	.bss.gp_data_xlc_data_head,"aw",@nobits
	.align	3
	.set	.LANCHOR82,. + 0
	.type	gp_data_xlc_data_head, %object
	.size	gp_data_xlc_data_head, 8
gp_data_xlc_data_head:
	.zero	8
	.section	.bss.gp_flash_check_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR139,. + 0
	.type	gp_flash_check_buf, %object
	.size	gp_flash_check_buf, 8
gp_flash_check_buf:
	.zero	8
	.section	.bss.gp_flash_info,"aw",@nobits
	.align	3
	.set	.LANCHOR27,. + 0
	.type	gp_flash_info, %object
	.size	gp_flash_info, 8
gp_flash_info:
	.zero	8
	.section	.bss.gp_free_mix_head,"aw",@nobits
	.align	3
	.set	.LANCHOR102,. + 0
	.type	gp_free_mix_head, %object
	.size	gp_free_mix_head, 8
gp_free_mix_head:
	.zero	8
	.section	.bss.gp_free_slc_head,"aw",@nobits
	.align	3
	.set	.LANCHOR98,. + 0
	.type	gp_free_slc_head, %object
	.size	gp_free_slc_head, 8
gp_free_slc_head:
	.zero	8
	.section	.bss.gp_free_xlc_head,"aw",@nobits
	.align	3
	.set	.LANCHOR100,. + 0
	.type	gp_free_xlc_head, %object
	.size	gp_free_xlc_head, 8
gp_free_xlc_head:
	.zero	8
	.section	.bss.gp_ftl_ext_info,"aw",@nobits
	.align	3
	.set	.LANCHOR10,. + 0
	.type	gp_ftl_ext_info, %object
	.size	gp_ftl_ext_info, 8
gp_ftl_ext_info:
	.zero	8
	.section	.bss.gp_ftl_info,"aw",@nobits
	.align	3
	.set	.LANCHOR104,. + 0
	.type	gp_ftl_info, %object
	.size	gp_ftl_info, 8
gp_ftl_info:
	.zero	8
	.section	.bss.gp_nand_para_info,"aw",@nobits
	.align	3
	.set	.LANCHOR16,. + 0
	.type	gp_nand_para_info, %object
	.size	gp_nand_para_info, 8
gp_nand_para_info:
	.zero	8
	.section	.bss.gp_nandc,"aw",@nobits
	.align	3
	.set	.LANCHOR13,. + 0
	.type	gp_nandc, %object
	.size	gp_nandc, 8
gp_nandc:
	.zero	8
	.section	.bss.gp_sblk_list_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR4,. + 0
	.type	gp_sblk_list_tbl, %object
	.size	gp_sblk_list_tbl, 8
gp_sblk_list_tbl:
	.zero	8
	.section	.bss.idb_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR137,. + 0
	.type	idb_buf, %object
	.size	idb_buf, 8
idb_buf:
	.zero	8
	.section	.bss.idb_need_write_back,"aw",@nobits
	.align	2
	.set	.LANCHOR138,. + 0
	.type	idb_need_write_back, %object
	.size	idb_need_write_back, 4
idb_need_write_back:
	.zero	4
	.section	.bss.lpa_hash,"aw",@nobits
	.align	3
	.set	.LANCHOR110,. + 0
	.type	lpa_hash, %object
	.size	lpa_hash, 512
lpa_hash:
	.zero	512
	.section	.bss.lpa_hash_index,"aw",@nobits
	.align	3
	.set	.LANCHOR112,. + 0
	.type	lpa_hash_index, %object
	.size	lpa_hash_index, 8
lpa_hash_index:
	.zero	8
	.section	.bss.nandc_ecc_sts,"aw",@nobits
	.align	3
	.type	nandc_ecc_sts, %object
	.size	nandc_ecc_sts, 16
nandc_ecc_sts:
	.zero	16
	.section	.bss.nandc_hw_seed,"aw",@nobits
	.set	.LANCHOR47,. + 0
	.type	nandc_hw_seed, %object
	.size	nandc_hw_seed, 1
nandc_hw_seed:
	.zero	1
	.section	.bss.nandc_randomizer_en,"aw",@nobits
	.set	.LANCHOR48,. + 0
	.type	nandc_randomizer_en, %object
	.size	nandc_randomizer_en, 1
nandc_randomizer_en:
	.zero	1
	.section	.bss.p_free_buf_head,"aw",@nobits
	.set	.LANCHOR53,. + 0
	.type	p_free_buf_head, %object
	.size	p_free_buf_head, 1
p_free_buf_head:
	.zero	1
	.section	.bss.p_read_ahead_ext_buf,"aw",@nobits
	.align	3
	.type	p_read_ahead_ext_buf, %object
	.size	p_read_ahead_ext_buf, 8
p_read_ahead_ext_buf:
	.zero	8
	.section	.bss.pm_first_write,"aw",@nobits
	.set	.LANCHOR192,. + 0
	.type	pm_first_write, %object
	.size	pm_first_write, 1
pm_first_write:
	.zero	1
	.section	.bss.pm_force_gc,"aw",@nobits
	.align	2
	.set	.LANCHOR146,. + 0
	.type	pm_force_gc, %object
	.size	pm_force_gc, 4
pm_force_gc:
	.zero	4
	.section	.bss.pm_gc_enable,"aw",@nobits
	.align	2
	.set	.LANCHOR132,. + 0
	.type	pm_gc_enable, %object
	.size	pm_gc_enable, 4
pm_gc_enable:
	.zero	4
	.section	.bss.pm_last_load_ram_id,"aw",@nobits
	.set	.LANCHOR210,. + 0
	.type	pm_last_load_ram_id, %object
	.size	pm_last_load_ram_id, 1
pm_last_load_ram_id:
	.zero	1
	.section	.bss.pm_last_update_ram_id,"aw",@nobits
	.set	.LANCHOR135,. + 0
	.type	pm_last_update_ram_id, %object
	.size	pm_last_update_ram_id, 1
pm_last_update_ram_id:
	.zero	1
	.section	.bss.pm_ram_info,"aw",@nobits
	.align	3
	.set	.LANCHOR134,. + 0
	.type	pm_ram_info, %object
	.size	pm_ram_info, 512
pm_ram_info:
	.zero	512
	.section	.bss.read_ahead_lpa,"aw",@nobits
	.align	2
	.set	.LANCHOR211,. + 0
	.type	read_ahead_lpa, %object
	.size	read_ahead_lpa, 4
read_ahead_lpa:
	.zero	4
	.section	.bss.read_buf_count,"aw",@nobits
	.set	.LANCHOR129,. + 0
	.type	read_buf_count, %object
	.size	read_buf_count, 1
read_buf_count:
	.zero	1
	.section	.bss.read_buf_head,"aw",@nobits
	.set	.LANCHOR128,. + 0
	.type	read_buf_head, %object
	.size	read_buf_head, 1
read_buf_head:
	.zero	1
	.section	.bss.sblk_gc_write_completed_queue_head,"aw",@nobits
	.set	.LANCHOR71,. + 0
	.type	sblk_gc_write_completed_queue_head, %object
	.size	sblk_gc_write_completed_queue_head, 1
sblk_gc_write_completed_queue_head:
	.zero	1
	.section	.bss.sblk_queue_head,"aw",@nobits
	.set	.LANCHOR56,. + 0
	.type	sblk_queue_head, %object
	.size	sblk_queue_head, 1
sblk_queue_head:
	.zero	1
	.section	.bss.sblk_read_completed_queue_head,"aw",@nobits
	.set	.LANCHOR131,. + 0
	.type	sblk_read_completed_queue_head, %object
	.size	sblk_read_completed_queue_head, 1
sblk_read_completed_queue_head:
	.zero	1
	.section	.bss.sblk_write_completed_queue_head,"aw",@nobits
	.set	.LANCHOR126,. + 0
	.type	sblk_write_completed_queue_head, %object
	.size	sblk_write_completed_queue_head, 1
sblk_write_completed_queue_head:
	.zero	1
	.section	.bss.slc_cache_sblk,"aw",@nobits
	.align	1
	.set	.LANCHOR90,. + 0
	.type	slc_cache_sblk, %object
	.size	slc_cache_sblk, 2
slc_cache_sblk:
	.zero	2
	.section	.bss.slc_data_sblk,"aw",@nobits
	.align	1
	.set	.LANCHOR92,. + 0
	.type	slc_data_sblk, %object
	.size	slc_data_sblk, 2
slc_data_sblk:
	.zero	2
	.section	.bss.write_buf_count,"aw",@nobits
	.set	.LANCHOR60,. + 0
	.type	write_buf_count, %object
	.size	write_buf_count, 1
write_buf_count:
	.zero	1
	.section	.bss.write_buf_head,"aw",@nobits
	.set	.LANCHOR59,. + 0
	.type	write_buf_head, %object
	.size	write_buf_head, 1
write_buf_head:
	.zero	1
	.section	.bss.write_commit_count,"aw",@nobits
	.set	.LANCHOR123,. + 0
	.type	write_commit_count, %object
	.size	write_commit_count, 1
write_commit_count:
	.zero	1
	.section	.bss.write_commit_head,"aw",@nobits
	.set	.LANCHOR177,. + 0
	.type	write_commit_head, %object
	.size	write_commit_head, 1
write_commit_head:
	.zero	1
	.section	.bss.xlc_data_sblk,"aw",@nobits
	.align	1
	.set	.LANCHOR94,. + 0
	.type	xlc_data_sblk, %object
	.size	xlc_data_sblk, 2
xlc_data_sblk:
	.zero	2
	.section	.bss.zftl_print_list_count,"aw",@nobits
	.align	1
	.set	.LANCHOR103,. + 0
	.type	zftl_print_list_count, %object
	.size	zftl_print_list_count, 2
zftl_print_list_count:
	.zero	2
	.section	.data.g_nand_para_info,"aw",@progbits
	.align	3
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
	.hword	768
	.byte	3
	.byte	2
	.hword	758
	.hword	5593
	.byte	0
	.byte	37
	.byte	60
	.byte	32
	.byte	2
	.byte	1
	.byte	4
	.byte	0
	.hword	256
	.byte	1
	.byte	-94
	.byte	0
	.byte	0
	.section	.data.hy_f26_ref_value,"aw",@progbits
	.align	3
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
	.section	.data.nand_opt_para,"aw",@progbits
	.align	3
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
	.zero	14
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
	.zero	14
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
	.zero	14
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
	.zero	14
	.section	.data.sd15_slc_rr,"aw",@progbits
	.align	3
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
	.section	.data.sd15_tlc_rr,"aw",@progbits
	.align	3
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
	.section	.data.tlc_b05a_prog_tbl,"aw",@progbits
	.align	3
	.set	.LANCHOR224,. + 0
	.type	tlc_b05a_prog_tbl, %object
	.size	tlc_b05a_prog_tbl, 1536
tlc_b05a_prog_tbl:
	.hword	0
	.hword	0
	.hword	0
	.hword	0
	.hword	0
	.hword	0
	.hword	0
	.hword	0
	.hword	9
	.hword	0
	.hword	11
	.hword	0
	.hword	13
	.hword	0
	.hword	15
	.hword	0
	.hword	17
	.hword	0
	.hword	19
	.hword	0
	.hword	21
	.hword	0
	.hword	23
	.hword	0
	.hword	25
	.hword	0
	.hword	27
	.hword	0
	.hword	29
	.hword	0
	.hword	31
	.hword	0
	.hword	33
	.hword	0
	.hword	35
	.hword	0
	.hword	37
	.hword	0
	.hword	39
	.hword	0
	.hword	41
	.hword	0
	.hword	43
	.hword	0
	.hword	45
	.hword	0
	.hword	47
	.hword	0
	.hword	49
	.hword	0
	.hword	51
	.hword	0
	.hword	53
	.hword	0
	.hword	55
	.hword	0
	.hword	25
	.hword	58
	.hword	0
	.hword	27
	.hword	61
	.hword	0
	.hword	29
	.hword	64
	.hword	0
	.hword	31
	.hword	67
	.hword	0
	.hword	33
	.hword	70
	.hword	0
	.hword	35
	.hword	73
	.hword	0
	.hword	37
	.hword	76
	.hword	0
	.hword	39
	.hword	79
	.hword	0
	.hword	41
	.hword	82
	.hword	0
	.hword	43
	.hword	85
	.hword	0
	.hword	45
	.hword	88
	.hword	0
	.hword	47
	.hword	91
	.hword	0
	.hword	49
	.hword	94
	.hword	0
	.hword	51
	.hword	97
	.hword	0
	.hword	53
	.hword	100
	.hword	0
	.hword	55
	.hword	103
	.hword	0
	.hword	58
	.hword	106
	.hword	0
	.hword	61
	.hword	109
	.hword	0
	.hword	64
	.hword	112
	.hword	0
	.hword	67
	.hword	115
	.hword	0
	.hword	70
	.hword	118
	.hword	0
	.hword	73
	.hword	121
	.hword	0
	.hword	76
	.hword	124
	.hword	0
	.hword	79
	.hword	127
	.hword	0
	.hword	82
	.hword	130
	.hword	0
	.hword	85
	.hword	133
	.hword	0
	.hword	88
	.hword	136
	.hword	0
	.hword	91
	.hword	139
	.hword	0
	.hword	94
	.hword	142
	.hword	0
	.hword	97
	.hword	145
	.hword	0
	.hword	100
	.hword	148
	.hword	0
	.hword	103
	.hword	151
	.hword	0
	.hword	106
	.hword	154
	.hword	0
	.hword	109
	.hword	157
	.hword	0
	.hword	112
	.hword	160
	.hword	0
	.hword	115
	.hword	163
	.hword	0
	.hword	118
	.hword	166
	.hword	0
	.hword	121
	.hword	169
	.hword	0
	.hword	124
	.hword	172
	.hword	0
	.hword	127
	.hword	175
	.hword	0
	.hword	130
	.hword	178
	.hword	0
	.hword	133
	.hword	181
	.hword	0
	.hword	136
	.hword	184
	.hword	0
	.hword	139
	.hword	187
	.hword	0
	.hword	142
	.hword	190
	.hword	0
	.hword	145
	.hword	193
	.hword	0
	.hword	148
	.hword	196
	.hword	0
	.hword	151
	.hword	199
	.hword	0
	.hword	154
	.hword	202
	.hword	0
	.hword	157
	.hword	205
	.hword	0
	.hword	160
	.hword	208
	.hword	0
	.hword	163
	.hword	211
	.hword	0
	.hword	166
	.hword	214
	.hword	0
	.hword	169
	.hword	217
	.hword	0
	.hword	172
	.hword	220
	.hword	0
	.hword	175
	.hword	223
	.hword	0
	.hword	178
	.hword	226
	.hword	0
	.hword	181
	.hword	229
	.hword	0
	.hword	184
	.hword	232
	.hword	0
	.hword	187
	.hword	235
	.hword	0
	.hword	190
	.hword	238
	.hword	0
	.hword	193
	.hword	241
	.hword	0
	.hword	196
	.hword	244
	.hword	0
	.hword	199
	.hword	247
	.hword	0
	.hword	202
	.hword	250
	.hword	0
	.hword	205
	.hword	253
	.hword	0
	.hword	208
	.hword	256
	.hword	0
	.hword	211
	.hword	259
	.hword	0
	.hword	214
	.hword	262
	.hword	0
	.hword	217
	.hword	265
	.hword	0
	.hword	220
	.hword	268
	.hword	0
	.hword	223
	.hword	271
	.hword	0
	.hword	226
	.hword	274
	.hword	0
	.hword	229
	.hword	277
	.hword	0
	.hword	232
	.hword	280
	.hword	0
	.hword	235
	.hword	283
	.hword	0
	.hword	238
	.hword	286
	.hword	0
	.hword	241
	.hword	289
	.hword	0
	.hword	244
	.hword	292
	.hword	0
	.hword	247
	.hword	295
	.hword	0
	.hword	250
	.hword	298
	.hword	0
	.hword	253
	.hword	301
	.hword	0
	.hword	256
	.hword	304
	.hword	0
	.hword	259
	.hword	307
	.hword	0
	.hword	262
	.hword	310
	.hword	0
	.hword	265
	.hword	313
	.hword	0
	.hword	268
	.hword	316
	.hword	0
	.hword	271
	.hword	319
	.hword	0
	.hword	274
	.hword	322
	.hword	0
	.hword	277
	.hword	325
	.hword	0
	.hword	280
	.hword	328
	.hword	0
	.hword	283
	.hword	331
	.hword	0
	.hword	286
	.hword	334
	.hword	0
	.hword	289
	.hword	337
	.hword	0
	.hword	292
	.hword	340
	.hword	0
	.hword	295
	.hword	343
	.hword	0
	.hword	298
	.hword	346
	.hword	0
	.hword	301
	.hword	349
	.hword	0
	.hword	304
	.hword	352
	.hword	0
	.hword	307
	.hword	355
	.hword	0
	.hword	310
	.hword	358
	.hword	0
	.hword	313
	.hword	361
	.hword	0
	.hword	316
	.hword	364
	.hword	0
	.hword	319
	.hword	367
	.hword	0
	.hword	322
	.hword	370
	.hword	0
	.hword	325
	.hword	373
	.hword	0
	.hword	328
	.hword	376
	.hword	0
	.hword	331
	.hword	379
	.hword	0
	.hword	334
	.hword	382
	.hword	0
	.hword	337
	.hword	385
	.hword	0
	.hword	340
	.hword	388
	.hword	0
	.hword	343
	.hword	391
	.hword	0
	.hword	346
	.hword	394
	.hword	0
	.hword	349
	.hword	397
	.hword	0
	.hword	352
	.hword	400
	.hword	0
	.hword	355
	.hword	403
	.hword	0
	.hword	358
	.hword	406
	.hword	0
	.hword	361
	.hword	409
	.hword	0
	.hword	364
	.hword	412
	.hword	0
	.hword	367
	.hword	415
	.hword	0
	.hword	370
	.hword	418
	.hword	0
	.hword	373
	.hword	421
	.hword	0
	.hword	376
	.hword	424
	.hword	0
	.hword	379
	.hword	427
	.hword	0
	.hword	382
	.hword	430
	.hword	0
	.hword	385
	.hword	433
	.hword	0
	.hword	388
	.hword	436
	.hword	0
	.hword	391
	.hword	439
	.hword	0
	.hword	394
	.hword	442
	.hword	0
	.hword	397
	.hword	445
	.hword	0
	.hword	400
	.hword	448
	.hword	0
	.hword	403
	.hword	451
	.hword	0
	.hword	406
	.hword	454
	.hword	0
	.hword	409
	.hword	457
	.hword	0
	.hword	412
	.hword	460
	.hword	0
	.hword	415
	.hword	463
	.hword	0
	.hword	418
	.hword	466
	.hword	0
	.hword	421
	.hword	469
	.hword	0
	.hword	424
	.hword	472
	.hword	0
	.hword	427
	.hword	475
	.hword	0
	.hword	430
	.hword	478
	.hword	0
	.hword	433
	.hword	481
	.hword	0
	.hword	436
	.hword	484
	.hword	0
	.hword	439
	.hword	487
	.hword	0
	.hword	442
	.hword	490
	.hword	0
	.hword	445
	.hword	493
	.hword	0
	.hword	448
	.hword	496
	.hword	0
	.hword	451
	.hword	499
	.hword	0
	.hword	454
	.hword	502
	.hword	0
	.hword	457
	.hword	505
	.hword	0
	.hword	460
	.hword	508
	.hword	0
	.hword	463
	.hword	511
	.hword	0
	.hword	466
	.hword	514
	.hword	0
	.hword	469
	.hword	517
	.hword	0
	.hword	472
	.hword	520
	.hword	0
	.hword	475
	.hword	523
	.hword	0
	.hword	478
	.hword	526
	.hword	0
	.hword	481
	.hword	529
	.hword	0
	.hword	484
	.hword	532
	.hword	0
	.hword	487
	.hword	535
	.hword	0
	.hword	490
	.hword	538
	.hword	0
	.hword	493
	.hword	541
	.hword	0
	.hword	496
	.hword	544
	.hword	0
	.hword	499
	.hword	547
	.hword	0
	.hword	502
	.hword	550
	.hword	0
	.hword	505
	.hword	553
	.hword	0
	.hword	508
	.hword	556
	.hword	0
	.hword	511
	.hword	559
	.hword	0
	.hword	514
	.hword	562
	.hword	0
	.hword	517
	.hword	565
	.hword	0
	.hword	520
	.hword	568
	.hword	0
	.hword	523
	.hword	571
	.hword	0
	.hword	526
	.hword	574
	.hword	0
	.hword	529
	.hword	577
	.hword	0
	.hword	532
	.hword	580
	.hword	0
	.hword	535
	.hword	583
	.hword	0
	.hword	538
	.hword	586
	.hword	0
	.hword	541
	.hword	589
	.hword	0
	.hword	544
	.hword	592
	.hword	0
	.hword	547
	.hword	595
	.hword	0
	.hword	550
	.hword	598
	.hword	0
	.hword	553
	.hword	601
	.hword	0
	.hword	556
	.hword	604
	.hword	0
	.hword	559
	.hword	607
	.hword	0
	.hword	562
	.hword	610
	.hword	0
	.hword	565
	.hword	613
	.hword	0
	.hword	568
	.hword	616
	.hword	0
	.hword	571
	.hword	619
	.hword	0
	.hword	574
	.hword	622
	.hword	0
	.hword	577
	.hword	625
	.hword	0
	.hword	580
	.hword	628
	.hword	0
	.hword	583
	.hword	631
	.hword	0
	.hword	586
	.hword	634
	.hword	0
	.hword	589
	.hword	637
	.hword	0
	.hword	592
	.hword	640
	.hword	0
	.hword	595
	.hword	643
	.hword	0
	.hword	598
	.hword	646
	.hword	0
	.hword	601
	.hword	649
	.hword	0
	.hword	604
	.hword	652
	.hword	0
	.hword	607
	.hword	655
	.hword	0
	.hword	610
	.hword	658
	.hword	0
	.hword	613
	.hword	661
	.hword	0
	.hword	616
	.hword	664
	.hword	0
	.hword	619
	.hword	667
	.hword	0
	.hword	622
	.hword	670
	.hword	0
	.hword	625
	.hword	673
	.hword	0
	.hword	628
	.hword	676
	.hword	0
	.hword	631
	.hword	679
	.hword	0
	.hword	634
	.hword	682
	.hword	0
	.hword	637
	.hword	685
	.hword	0
	.hword	640
	.hword	688
	.hword	0
	.hword	643
	.hword	691
	.hword	0
	.hword	646
	.hword	694
	.hword	0
	.hword	649
	.hword	697
	.hword	0
	.hword	652
	.hword	700
	.hword	0
	.hword	655
	.hword	703
	.hword	0
	.hword	658
	.hword	706
	.hword	0
	.hword	661
	.hword	709
	.hword	0
	.hword	664
	.hword	712
	.hword	0
	.hword	667
	.hword	715
	.hword	0
	.hword	670
	.hword	718
	.hword	0
	.hword	673
	.hword	721
	.hword	0
	.hword	676
	.hword	724
	.hword	0
	.hword	679
	.hword	727
	.hword	0
	.hword	682
	.hword	730
	.hword	0
	.hword	685
	.hword	733
	.hword	0
	.hword	688
	.hword	736
	.hword	0
	.hword	691
	.hword	739
	.hword	0
	.hword	694
	.hword	742
	.hword	0
	.hword	697
	.hword	745
	.hword	0
	.hword	700
	.hword	748
	.hword	0
	.hword	703
	.hword	751
	.hword	0
	.hword	706
	.hword	0
	.hword	709
	.hword	0
	.hword	712
	.hword	0
	.hword	715
	.hword	0
	.hword	718
	.hword	0
	.hword	721
	.hword	0
	.hword	724
	.hword	0
	.hword	727
	.hword	0
	.section	.data.tlc_prog_order,"aw",@progbits
	.align	3
	.set	.LANCHOR225,. + 0
	.type	tlc_prog_order, %object
	.size	tlc_prog_order, 768
tlc_prog_order:
	.hword	1
	.hword	9
	.hword	2
	.hword	17
	.hword	10
	.hword	3
	.hword	25
	.hword	18
	.hword	11
	.hword	33
	.hword	26
	.hword	19
	.hword	41
	.hword	34
	.hword	27
	.hword	49
	.hword	42
	.hword	35
	.hword	57
	.hword	50
	.hword	43
	.hword	65
	.hword	58
	.hword	51
	.hword	73
	.hword	66
	.hword	59
	.hword	81
	.hword	74
	.hword	67
	.hword	89
	.hword	82
	.hword	75
	.hword	97
	.hword	90
	.hword	83
	.hword	105
	.hword	98
	.hword	91
	.hword	113
	.hword	106
	.hword	99
	.hword	121
	.hword	114
	.hword	107
	.hword	129
	.hword	122
	.hword	115
	.hword	137
	.hword	130
	.hword	123
	.hword	145
	.hword	138
	.hword	131
	.hword	153
	.hword	146
	.hword	139
	.hword	161
	.hword	154
	.hword	147
	.hword	169
	.hword	162
	.hword	155
	.hword	177
	.hword	170
	.hword	163
	.hword	185
	.hword	178
	.hword	171
	.hword	193
	.hword	186
	.hword	179
	.hword	201
	.hword	194
	.hword	187
	.hword	209
	.hword	202
	.hword	195
	.hword	217
	.hword	210
	.hword	203
	.hword	225
	.hword	218
	.hword	211
	.hword	233
	.hword	226
	.hword	219
	.hword	241
	.hword	234
	.hword	227
	.hword	249
	.hword	242
	.hword	235
	.hword	257
	.hword	250
	.hword	243
	.hword	265
	.hword	258
	.hword	251
	.hword	273
	.hword	266
	.hword	259
	.hword	281
	.hword	274
	.hword	267
	.hword	289
	.hword	282
	.hword	275
	.hword	297
	.hword	290
	.hword	283
	.hword	305
	.hword	298
	.hword	291
	.hword	313
	.hword	306
	.hword	299
	.hword	321
	.hword	314
	.hword	307
	.hword	329
	.hword	322
	.hword	315
	.hword	337
	.hword	330
	.hword	323
	.hword	345
	.hword	338
	.hword	331
	.hword	353
	.hword	346
	.hword	339
	.hword	361
	.hword	354
	.hword	347
	.hword	369
	.hword	362
	.hword	355
	.hword	377
	.hword	370
	.hword	363
	.hword	385
	.hword	378
	.hword	371
	.hword	393
	.hword	386
	.hword	379
	.hword	401
	.hword	394
	.hword	387
	.hword	409
	.hword	402
	.hword	395
	.hword	417
	.hword	410
	.hword	403
	.hword	425
	.hword	418
	.hword	411
	.hword	433
	.hword	426
	.hword	419
	.hword	441
	.hword	434
	.hword	427
	.hword	449
	.hword	442
	.hword	435
	.hword	457
	.hword	450
	.hword	443
	.hword	465
	.hword	458
	.hword	451
	.hword	473
	.hword	466
	.hword	459
	.hword	481
	.hword	474
	.hword	467
	.hword	489
	.hword	482
	.hword	475
	.hword	497
	.hword	490
	.hword	483
	.hword	505
	.hword	498
	.hword	491
	.hword	513
	.hword	506
	.hword	499
	.hword	521
	.hword	514
	.hword	507
	.hword	529
	.hword	522
	.hword	515
	.hword	537
	.hword	530
	.hword	523
	.hword	545
	.hword	538
	.hword	531
	.hword	553
	.hword	546
	.hword	539
	.hword	561
	.hword	554
	.hword	547
	.hword	569
	.hword	562
	.hword	555
	.hword	577
	.hword	570
	.hword	563
	.hword	585
	.hword	578
	.hword	571
	.hword	593
	.hword	586
	.hword	579
	.hword	601
	.hword	594
	.hword	587
	.hword	609
	.hword	602
	.hword	595
	.hword	617
	.hword	610
	.hword	603
	.hword	625
	.hword	618
	.hword	611
	.hword	633
	.hword	626
	.hword	619
	.hword	641
	.hword	634
	.hword	627
	.hword	649
	.hword	642
	.hword	635
	.hword	657
	.hword	650
	.hword	643
	.hword	665
	.hword	658
	.hword	651
	.hword	673
	.hword	666
	.hword	659
	.hword	681
	.hword	674
	.hword	667
	.hword	689
	.hword	682
	.hword	675
	.hword	697
	.hword	690
	.hword	683
	.hword	705
	.hword	698
	.hword	691
	.hword	713
	.hword	706
	.hword	699
	.hword	721
	.hword	714
	.hword	707
	.hword	729
	.hword	722
	.hword	715
	.hword	737
	.hword	730
	.hword	723
	.hword	745
	.hword	738
	.hword	731
	.hword	753
	.hword	746
	.hword	739
	.hword	761
	.hword	754
	.hword	747
	.hword	769
	.hword	762
	.hword	755
	.hword	777
	.hword	770
	.hword	763
	.hword	785
	.hword	778
	.hword	771
	.hword	793
	.hword	786
	.hword	779
	.hword	801
	.hword	794
	.hword	787
	.hword	809
	.hword	802
	.hword	795
	.hword	817
	.hword	810
	.hword	803
	.hword	825
	.hword	818
	.hword	811
	.hword	833
	.hword	826
	.hword	819
	.hword	841
	.hword	834
	.hword	827
	.hword	849
	.hword	842
	.hword	835
	.hword	857
	.hword	850
	.hword	843
	.hword	865
	.hword	858
	.hword	851
	.hword	873
	.hword	866
	.hword	859
	.hword	881
	.hword	874
	.hword	867
	.hword	889
	.hword	882
	.hword	875
	.hword	897
	.hword	890
	.hword	883
	.hword	905
	.hword	898
	.hword	891
	.hword	913
	.hword	906
	.hword	899
	.hword	921
	.hword	914
	.hword	907
	.hword	929
	.hword	922
	.hword	915
	.hword	937
	.hword	930
	.hword	923
	.hword	945
	.hword	938
	.hword	931
	.hword	953
	.hword	946
	.hword	939
	.hword	961
	.hword	954
	.hword	947
	.hword	969
	.hword	962
	.hword	955
	.hword	977
	.hword	970
	.hword	963
	.hword	985
	.hword	978
	.hword	971
	.hword	993
	.hword	986
	.hword	979
	.hword	1001
	.hword	994
	.hword	987
	.hword	1009
	.hword	1002
	.hword	995
	.hword	1017
	.hword	1010
	.hword	1003
	.hword	1018
	.hword	1011
	.hword	1019
	.section	.data.zftl_debug,"aw",@progbits
	.align	2
	.set	.LANCHOR14,. + 0
	.type	zftl_debug, %object
	.size	zftl_debug, 4
zftl_debug:
	.word	17476
	.section	.data.zftl_nand_flash_para_tbl,"aw",@progbits
	.align	3
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
	.hword	768
	.byte	3
	.byte	2
	.hword	758
	.hword	5593
	.byte	0
	.byte	37
	.byte	60
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.hword	256
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
	.hword	768
	.byte	3
	.byte	2
	.hword	1478
	.hword	5593
	.byte	0
	.byte	37
	.byte	60
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.hword	256
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
	.hword	384
	.byte	3
	.byte	2
	.hword	1446
	.hword	1497
	.byte	0
	.byte	36
	.byte	60
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.hword	256
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
	.hword	256
	.byte	2
	.byte	2
	.hword	1074
	.hword	17881
	.byte	2
	.byte	35
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.hword	256
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
	.hword	256
	.byte	2
	.byte	1
	.hword	2092
	.hword	17857
	.byte	2
	.byte	33
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	1
	.byte	0
	.hword	256
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
	.hword	256
	.byte	2
	.byte	2
	.hword	2106
	.hword	17881
	.byte	2
	.byte	35
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.hword	256
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
	.hword	256
	.byte	2
	.byte	1
	.hword	1056
	.hword	17857
	.byte	2
	.byte	35
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.hword	256
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
	.hword	256
	.byte	2
	.byte	1
	.hword	1060
	.hword	17857
	.byte	2
	.byte	34
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.hword	256
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
	.hword	256
	.byte	2
	.byte	2
	.hword	1066
	.hword	17881
	.byte	2
	.byte	34
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	1
	.byte	0
	.hword	256
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
	.hword	256
	.byte	2
	.byte	1
	.hword	1060
	.hword	17857
	.byte	2
	.byte	33
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	1
	.byte	0
	.hword	256
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
	.hword	256
	.byte	2
	.byte	2
	.hword	1058
	.hword	17881
	.byte	2
	.byte	33
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	1
	.byte	0
	.hword	256
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
	.hword	256
	.byte	2
	.byte	2
	.hword	2106
	.hword	17881
	.byte	2
	.byte	68
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.hword	256
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
	.hword	256
	.byte	2
	.byte	2
	.hword	1074
	.hword	17881
	.byte	2
	.byte	68
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.hword	256
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
	.hword	256
	.byte	2
	.byte	2
	.hword	1058
	.hword	17881
	.byte	2
	.byte	66
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.hword	256
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
	.hword	256
	.byte	2
	.byte	2
	.hword	1066
	.hword	17881
	.byte	2
	.byte	67
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	1
	.byte	0
	.hword	256
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
	.hword	256
	.byte	2
	.byte	1
	.hword	1060
	.hword	17857
	.byte	2
	.byte	66
	.byte	40
	.byte	32
	.byte	2
	.byte	1
	.byte	1
	.byte	0
	.hword	256
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
	.hword	512
	.byte	2
	.byte	1
	.hword	1048
	.hword	9671
	.byte	5
	.byte	19
	.byte	70
	.byte	32
	.byte	1
	.byte	0
	.byte	4
	.byte	0
	.hword	512
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
	.hword	512
	.byte	2
	.byte	2
	.hword	700
	.hword	479
	.byte	4
	.byte	18
	.byte	60
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.hword	512
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
	.hword	256
	.byte	2
	.byte	2
	.hword	1064
	.hword	479
	.byte	3
	.byte	17
	.byte	40
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.hword	256
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
	.hword	512
	.byte	2
	.byte	2
	.hword	1024
	.hword	479
	.byte	4
	.byte	18
	.byte	60
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.hword	512
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
	.hword	512
	.byte	2
	.byte	1
	.hword	1024
	.hword	455
	.byte	4
	.byte	18
	.byte	60
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.hword	512
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
	.hword	256
	.byte	2
	.byte	4
	.hword	1024
	.hword	449
	.byte	3
	.byte	17
	.byte	40
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.hword	256
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
	.hword	512
	.byte	2
	.byte	2
	.hword	1024
	.hword	479
	.byte	3
	.byte	17
	.byte	40
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.hword	512
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
	.hword	512
	.byte	2
	.byte	1
	.hword	2184
	.hword	9671
	.byte	5
	.byte	19
	.byte	70
	.byte	32
	.byte	1
	.byte	0
	.byte	4
	.byte	0
	.hword	512
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
	.hword	512
	.byte	2
	.byte	1
	.hword	1044
	.hword	471
	.byte	3
	.byte	17
	.byte	40
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.hword	512
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
	.hword	512
	.byte	2
	.byte	1
	.hword	2184
	.hword	9671
	.byte	5
	.byte	19
	.byte	70
	.byte	32
	.byte	1
	.byte	0
	.byte	4
	.byte	0
	.hword	512
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
	.hword	512
	.byte	2
	.byte	1
	.hword	2184
	.hword	9671
	.byte	5
	.byte	19
	.byte	70
	.byte	32
	.byte	1
	.byte	0
	.byte	4
	.byte	0
	.hword	512
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
	.hword	512
	.byte	2
	.byte	1
	.hword	2184
	.hword	9671
	.byte	5
	.byte	19
	.byte	70
	.byte	32
	.byte	1
	.byte	0
	.byte	4
	.byte	0
	.hword	512
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
	.hword	256
	.byte	2
	.byte	1
	.hword	2144
	.hword	-23097
	.byte	8
	.byte	21
	.byte	70
	.byte	32
	.byte	1
	.byte	0
	.byte	8
	.byte	0
	.hword	256
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
	.hword	512
	.byte	2
	.byte	2
	.hword	1024
	.hword	479
	.byte	3
	.byte	17
	.byte	40
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.hword	512
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
	.hword	768
	.byte	3
	.byte	1
	.hword	1440
	.hword	3527
	.byte	0
	.byte	19
	.byte	70
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.hword	1024
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
	.hword	2304
	.byte	3
	.byte	1
	.hword	1008
	.hword	3521
	.byte	0
	.byte	19
	.byte	70
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.hword	4096
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
	.hword	256
	.byte	2
	.byte	2
	.hword	1056
	.hword	455
	.byte	2
	.byte	6
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.hword	256
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
	.hword	256
	.byte	2
	.byte	2
	.hword	1066
	.hword	473
	.byte	1
	.byte	7
	.byte	40
	.byte	32
	.byte	4
	.byte	1
	.byte	3
	.byte	0
	.hword	256
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
	.hword	256
	.byte	2
	.byte	2
	.hword	1060
	.hword	473
	.byte	2
	.byte	5
	.byte	40
	.byte	32
	.byte	4
	.byte	1
	.byte	3
	.byte	0
	.hword	256
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
	.hword	256
	.byte	2
	.byte	2
	.hword	1046
	.hword	473
	.byte	1
	.byte	3
	.byte	40
	.byte	32
	.byte	4
	.byte	1
	.byte	3
	.byte	0
	.hword	256
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
	.hword	256
	.byte	2
	.byte	2
	.hword	2092
	.hword	473
	.byte	2
	.byte	5
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	3
	.byte	0
	.hword	256
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
	.hword	256
	.byte	2
	.byte	2
	.hword	1056
	.hword	473
	.byte	2
	.byte	5
	.byte	40
	.byte	32
	.byte	4
	.byte	1
	.byte	3
	.byte	0
	.hword	256
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
	.hword	388
	.byte	2
	.byte	2
	.hword	1362
	.hword	473
	.byte	9
	.byte	8
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.hword	512
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
	.hword	512
	.byte	2
	.byte	1
	.hword	1024
	.hword	455
	.byte	4
	.byte	17
	.byte	40
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.hword	512
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
	.hword	512
	.byte	2
	.byte	2
	.hword	1024
	.hword	455
	.byte	4
	.byte	17
	.byte	40
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.hword	512
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
	.hword	256
	.byte	2
	.byte	4
	.hword	1024
	.hword	449
	.byte	3
	.byte	17
	.byte	40
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.hword	256
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
	.hword	256
	.byte	2
	.byte	4
	.hword	1024
	.hword	449
	.byte	3
	.byte	17
	.byte	40
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.hword	256
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
	.hword	2304
	.byte	3
	.byte	1
	.hword	1008
	.hword	3521
	.byte	0
	.byte	19
	.byte	70
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.hword	4096
	.byte	3
	.byte	0
	.byte	0
	.byte	4
	.section	.rodata.__func__.10032,"a",@progbits
	.align	3
	.set	.LANCHOR216,. + 0
	.type	__func__.10032, %object
	.size	__func__.10032, 20
__func__.10032:
	.string	"gc_scan_static_data"
	.section	.rodata.__func__.10099,"a",@progbits
	.align	3
	.set	.LANCHOR226,. + 0
	.type	__func__.10099, %object
	.size	__func__.10099, 11
__func__.10099:
	.string	"zftl_do_gc"
	.section	.rodata.__func__.10192,"a",@progbits
	.align	3
	.set	.LANCHOR5,. + 0
	.type	__func__.10192, %object
	.size	__func__.10192, 18
__func__.10192:
	.string	"_list_remove_node"
	.section	.rodata.__func__.10217,"a",@progbits
	.align	3
	.set	.LANCHOR11,. + 0
	.type	__func__.10217, %object
	.size	__func__.10217, 23
__func__.10217:
	.string	"_list_update_data_list"
	.section	.rodata.__func__.10325,"a",@progbits
	.align	3
	.set	.LANCHOR183,. + 0
	.type	__func__.10325, %object
	.size	__func__.10325, 15
__func__.10325:
	.string	"ftl_info_flush"
	.section	.rodata.__func__.10357,"a",@progbits
	.align	3
	.set	.LANCHOR130,. + 0
	.type	__func__.10357, %object
	.size	__func__.10357, 15
__func__.10357:
	.string	"ftl_alloc_sblk"
	.section	.rodata.__func__.10399,"a",@progbits
	.align	3
	.set	.LANCHOR107,. + 0
	.type	__func__.10399, %object
	.size	__func__.10399, 18
__func__.10399:
	.string	"ftl_alloc_sys_blk"
	.section	.rodata.__func__.10409,"a",@progbits
	.align	3
	.set	.LANCHOR108,. + 0
	.type	__func__.10409, %object
	.size	__func__.10409, 17
__func__.10409:
	.string	"ftl_free_sys_blk"
	.section	.rodata.__func__.10467,"a",@progbits
	.align	3
	.set	.LANCHOR217,. + 0
	.type	__func__.10467, %object
	.size	__func__.10467, 14
__func__.10467:
	.string	"ftl_sblk_dump"
	.section	.rodata.__func__.10491,"a",@progbits
	.align	3
	.set	.LANCHOR206,. + 0
	.type	__func__.10491, %object
	.size	__func__.10491, 16
__func__.10491:
	.string	"ftl_sysblk_dump"
	.section	.rodata.__func__.10515,"a",@progbits
	.align	3
	.set	.LANCHOR189,. + 0
	.type	__func__.10515, %object
	.size	__func__.10515, 23
__func__.10515:
	.string	"ftl_open_sblk_recovery"
	.section	.rodata.__func__.10548,"a",@progbits
	.align	3
	.set	.LANCHOR109,. + 0
	.type	__func__.10548, %object
	.size	__func__.10548, 23
__func__.10548:
	.string	"ftl_get_ppa_from_index"
	.section	.rodata.__func__.10569,"a",@progbits
	.align	3
	.set	.LANCHOR220,. + 0
	.type	__func__.10569, %object
	.size	__func__.10569, 19
__func__.10569:
	.string	"ftl_update_l2p_map"
	.section	.rodata.__func__.10588,"a",@progbits
	.align	3
	.set	.LANCHOR113,. + 0
	.type	__func__.10588, %object
	.size	__func__.10588, 22
__func__.10588:
	.string	"ftl_get_new_free_page"
	.section	.rodata.__func__.10599,"a",@progbits
	.align	3
	.set	.LANCHOR114,. + 0
	.type	__func__.10599, %object
	.size	__func__.10599, 22
__func__.10599:
	.string	"ftl_ext_alloc_new_blk"
	.section	.rodata.__func__.10624,"a",@progbits
	.align	3
	.set	.LANCHOR187,. + 0
	.type	__func__.10624, %object
	.size	__func__.10624, 19
__func__.10624:
	.string	"ftl_ext_info_flush"
	.section	.rodata.__func__.10636,"a",@progbits
	.align	3
	.set	.LANCHOR188,. + 0
	.type	__func__.10636, %object
	.size	__func__.10636, 18
__func__.10636:
	.string	"ftl_ext_info_init"
	.section	.rodata.__func__.10675,"a",@progbits
	.align	3
	.set	.LANCHOR193,. + 0
	.type	__func__.10675, %object
	.size	__func__.10675, 25
__func__.10675:
	.string	"ftl_low_format_data_init"
	.section	.rodata.__func__.10690,"a",@progbits
	.align	3
	.set	.LANCHOR195,. + 0
	.type	__func__.10690, %object
	.size	__func__.10690, 15
__func__.10690:
	.string	"ftl_low_format"
	.section	.rodata.__func__.10738,"a",@progbits
	.align	3
	.set	.LANCHOR180,. + 0
	.type	__func__.10738, %object
	.size	__func__.10738, 14
__func__.10738:
	.string	"ftl_prog_page"
	.section	.rodata.__func__.10860,"a",@progbits
	.align	3
	.set	.LANCHOR170,. + 0
	.type	__func__.10860, %object
	.size	__func__.10860, 31
__func__.10860:
	.string	"queue_wait_first_req_completed"
	.section	.rodata.__func__.10914,"a",@progbits
	.align	3
	.set	.LANCHOR176,. + 0
	.type	__func__.10914, %object
	.size	__func__.10914, 15
__func__.10914:
	.string	"sblk_prog_page"
	.section	.rodata.__func__.10941,"a",@progbits
	.align	3
	.set	.LANCHOR172,. + 0
	.type	__func__.10941, %object
	.size	__func__.10941, 15
__func__.10941:
	.string	"sblk_read_page"
	.section	.rodata.__func__.11005,"a",@progbits
	.align	3
	.set	.LANCHOR207,. + 0
	.type	__func__.11005, %object
	.size	__func__.11005, 16
__func__.11005:
	.string	"load_l2p_region"
	.section	.rodata.__func__.11021,"a",@progbits
	.align	3
	.set	.LANCHOR150,. + 0
	.type	__func__.11021, %object
	.size	__func__.11021, 13
__func__.11021:
	.string	"pm_free_sblk"
	.section	.rodata.__func__.11045,"a",@progbits
	.align	3
	.set	.LANCHOR209,. + 0
	.type	__func__.11045, %object
	.size	__func__.11045, 6
__func__.11045:
	.string	"pm_gc"
	.section	.rodata.__func__.11061,"a",@progbits
	.align	3
	.set	.LANCHOR133,. + 0
	.type	__func__.11061, %object
	.size	__func__.11061, 17
__func__.11061:
	.string	"pm_alloc_new_blk"
	.section	.rodata.__func__.11071,"a",@progbits
	.align	3
	.set	.LANCHOR190,. + 0
	.type	__func__.11071, %object
	.size	__func__.11071, 14
__func__.11071:
	.string	"pm_write_page"
	.section	.rodata.__func__.11089,"a",@progbits
	.align	3
	.set	.LANCHOR136,. + 0
	.type	__func__.11089, %object
	.size	__func__.11089, 21
__func__.11089:
	.string	"pm_select_ram_region"
	.section	.rodata.__func__.8537,"a",@progbits
	.align	3
	.set	.LANCHOR164,. + 0
	.type	__func__.8537, %object
	.size	__func__.8537, 19
__func__.8537:
	.string	"flash_read_page_en"
	.section	.rodata.__func__.8579,"a",@progbits
	.align	3
	.set	.LANCHOR178,. + 0
	.type	__func__.8579, %object
	.size	__func__.8579, 19
__func__.8579:
	.string	"flash_prog_page_en"
	.section	.rodata.__func__.8595,"a",@progbits
	.align	3
	.set	.LANCHOR40,. + 0
	.type	__func__.8595, %object
	.size	__func__.8595, 26
__func__.8595:
	.string	"flash_erase_duplane_block"
	.section	.rodata.__func__.8606,"a",@progbits
	.align	3
	.set	.LANCHOR42,. + 0
	.type	__func__.8606, %object
	.size	__func__.8606, 21
__func__.8606:
	.string	"flash_erase_block_en"
	.section	.rodata.__func__.8620,"a",@progbits
	.align	3
	.set	.LANCHOR29,. + 0
	.type	__func__.8620, %object
	.size	__func__.8620, 28
__func__.8620:
	.string	"flash_wait_device_ready_raw"
	.section	.rodata.__func__.8644,"a",@progbits
	.align	3
	.set	.LANCHOR173,. + 0
	.type	__func__.8644, %object
	.size	__func__.8644, 26
__func__.8644:
	.string	"flash_start_tlc_page_prog"
	.section	.rodata.__func__.8655,"a",@progbits
	.align	3
	.set	.LANCHOR174,. + 0
	.type	__func__.8655, %object
	.size	__func__.8655, 29
__func__.8655:
	.string	"flash_start_3d_mlc_page_prog"
	.section	.rodata.__func__.8673,"a",@progbits
	.align	3
	.set	.LANCHOR175,. + 0
	.type	__func__.8673, %object
	.size	__func__.8673, 22
__func__.8673:
	.string	"flash_start_page_prog"
	.section	.rodata.__func__.8684,"a",@progbits
	.align	3
	.set	.LANCHOR34,. + 0
	.type	__func__.8684, %object
	.size	__func__.8684, 22
__func__.8684:
	.string	"flash_start_page_read"
	.section	.rodata.__func__.8697,"a",@progbits
	.align	3
	.set	.LANCHOR168,. + 0
	.type	__func__.8697, %object
	.size	__func__.8697, 31
__func__.8697:
	.string	"flash_complete_plane_page_read"
	.section	.rodata.__func__.8709,"a",@progbits
	.align	3
	.set	.LANCHOR43,. + 0
	.type	__func__.8709, %object
	.size	__func__.8709, 23
__func__.8709:
	.string	"flash_start_plane_read"
	.section	.rodata.__func__.8722,"a",@progbits
	.align	3
	.set	.LANCHOR169,. + 0
	.type	__func__.8722, %object
	.size	__func__.8722, 25
__func__.8722:
	.string	"flash_complete_page_read"
	.section	.rodata.__func__.9061,"a",@progbits
	.align	3
	.set	.LANCHOR141,. + 0
	.type	__func__.9061, %object
	.size	__func__.9061, 20
__func__.9061:
	.string	"flash_die_info_init"
	.section	.rodata.__func__.9071,"a",@progbits
	.align	3
	.set	.LANCHOR15,. + 0
	.type	__func__.9071, %object
	.size	__func__.9071, 22
__func__.9071:
	.string	"nand_flash_print_info"
	.section	.rodata.__func__.9116,"a",@progbits
	.align	3
	.set	.LANCHOR200,. + 0
	.type	__func__.9116, %object
	.size	__func__.9116, 16
__func__.9116:
	.string	"nand_flash_init"
	.section	.rodata.__func__.9139,"a",@progbits
	.align	3
	.set	.LANCHOR152,. + 0
	.type	__func__.9139, %object
	.size	__func__.9139, 11
__func__.9139:
	.string	"nandc_init"
	.section	.rodata.__func__.9308,"a",@progbits
	.align	3
	.set	.LANCHOR55,. + 0
	.type	__func__.9308, %object
	.size	__func__.9308, 13
__func__.9308:
	.string	"buf_add_tail"
	.section	.rodata.__func__.9321,"a",@progbits
	.align	3
	.set	.LANCHOR57,. + 0
	.type	__func__.9321, %object
	.size	__func__.9321, 10
__func__.9321:
	.string	"buf_alloc"
	.section	.rodata.__func__.9335,"a",@progbits
	.align	3
	.set	.LANCHOR58,. + 0
	.type	__func__.9335, %object
	.size	__func__.9335, 16
__func__.9335:
	.string	"buf_remove_free"
	.section	.rodata.__func__.9348,"a",@progbits
	.align	3
	.set	.LANCHOR199,. + 0
	.type	__func__.9348, %object
	.size	__func__.9348, 20
__func__.9348:
	.string	"flash_info_blk_init"
	.section	.rodata.__func__.9359,"a",@progbits
	.align	3
	.set	.LANCHOR151,. + 0
	.type	__func__.9359, %object
	.size	__func__.9359, 21
__func__.9359:
	.string	"flash_info_data_init"
	.section	.rodata.__func__.9381,"a",@progbits
	.align	3
	.set	.LANCHOR196,. + 0
	.type	__func__.9381, %object
	.size	__func__.9381, 17
__func__.9381:
	.string	"flash_info_flush"
	.section	.rodata.__func__.9457,"a",@progbits
	.align	3
	.set	.LANCHOR145,. + 0
	.type	__func__.9457, %object
	.size	__func__.9457, 17
__func__.9457:
	.string	"lpa_rebuild_hash"
	.section	.rodata.__func__.9504,"a",@progbits
	.align	3
	.set	.LANCHOR221,. + 0
	.type	__func__.9504, %object
	.size	__func__.9504, 17
__func__.9504:
	.string	"ftl_write_commit"
	.section	.rodata.__func__.9522,"a",@progbits
	.align	3
	.set	.LANCHOR124,. + 0
	.type	__func__.9522, %object
	.size	__func__.9522, 14
__func__.9522:
	.string	"ftl_write_buf"
	.section	.rodata.__func__.9567,"a",@progbits
	.align	3
	.set	.LANCHOR127,. + 0
	.type	__func__.9567, %object
	.size	__func__.9567, 18
__func__.9567:
	.string	"zftl_add_read_buf"
	.section	.rodata.__func__.9600,"a",@progbits
	.align	3
	.set	.LANCHOR218,. + 0
	.type	__func__.9600, %object
	.size	__func__.9600, 10
__func__.9600:
	.string	"zftl_read"
	.section	.rodata.__func__.9631,"a",@progbits
	.align	3
	.set	.LANCHOR228,. + 0
	.type	__func__.9631, %object
	.size	__func__.9631, 13
__func__.9631:
	.string	"_ftl_discard"
	.section	.rodata.__func__.9780,"a",@progbits
	.align	3
	.set	.LANCHOR65,. + 0
	.type	__func__.9780, %object
	.size	__func__.9780, 12
__func__.9780:
	.string	"gc_add_sblk"
	.section	.rodata.__func__.9827,"a",@progbits
	.align	3
	.set	.LANCHOR219,. + 0
	.type	__func__.9827, %object
	.size	__func__.9827, 21
__func__.9827:
	.string	"gc_check_data_one_wl"
	.section	.rodata.__func__.9861,"a",@progbits
	.align	3
	.set	.LANCHOR214,. + 0
	.type	__func__.9861, %object
	.size	__func__.9861, 22
__func__.9861:
	.string	"gc_update_l2p_map_new"
	.section	.rodata.__func__.9874,"a",@progbits
	.align	3
	.set	.LANCHOR72,. + 0
	.type	__func__.9874, %object
	.size	__func__.9874, 19
__func__.9874:
	.string	"gc_write_completed"
	.section	.rodata.__func__.9903,"a",@progbits
	.align	3
	.set	.LANCHOR223,. + 0
	.type	__func__.9903, %object
	.size	__func__.9903, 16
__func__.9903:
	.string	"gc_do_copy_back"
	.section	.rodata.__func__.9930,"a",@progbits
	.align	3
	.set	.LANCHOR121,. + 0
	.type	__func__.9930, %object
	.size	__func__.9930, 16
__func__.9930:
	.string	"gc_free_src_blk"
	.section	.rodata.__func__.9974,"a",@progbits
	.align	3
	.set	.LANCHOR215,. + 0
	.type	__func__.9974, %object
	.size	__func__.9974, 16
__func__.9974:
	.string	"gc_scan_src_blk"
	.section	.rodata._list_remove_node.str1.1,"aMS",@progbits,1
.LC0:
	.string	"\n!!!!! error @ func:%s - line:%d\n"
	.section	.rodata.dump_ftl_info.str1.1,"aMS",@progbits,1
.LC178:
	.string	"free_buf_count: %d\n"
.LC179:
	.string	"g_ftl_info_blk blk:0x%x, index:0x%x, page:0x%x\n"
.LC180:
	.string	"ftl_ext_info_blk blk:0x%x, page:0x%x\n"
.LC181:
	.string	"ac_blk:0x%x, page:0x%x, index:0x%x, free:0x%x, page_index:0x%x\n"
.LC182:
	.string	"tmp_blk:0x%x, page:0x%x, index:0x%x, free:0x%x, page_index:0x%x\n"
.LC183:
	.string	"gc_blk:0x%x, page:0x%x, index:0x%x, free:0x%x, page_index:0x%x\n"
.LC184:
	.string	"lpa:"
.LC185:
	.string	"vpn:"
.LC186:
	.string	"sblk:"
.LC187:
	.string	"lpa_hash:"
.LC188:
	.string	"lpa_hash_index:"
	.section	.rodata.dump_pm_blk.str1.1,"aMS",@progbits,1
.LC248:
	.string	"pm l2p:"
.LC249:
	.string	"pm blk:"
	.section	.rodata.dump_sblk_queue.str1.1,"aMS",@progbits,1
.LC75:
	.string	"dump_sblk_queue: %d\n"
.LC76:
	.string	"buf id= %d state = %d ppa = %x\n"
	.section	.rodata.flash_complete_page_read.str1.1,"aMS",@progbits,1
.LC124:
	.string	"flash_complete_page_read %x %x error_ecc %d %d\n"
	.section	.rodata.flash_ddr_tuning_read.str1.1,"aMS",@progbits,1
.LC117:
	.string	"%d flash_ddr_tuning_read %x ecc=%d\n"
.LC118:
	.string	"sync para %d\n"
.LC119:
	.string	"DDR mode Read error %x %x\n"
.LC120:
	.string	"SDR mode Read %x %x ecc:%x\n"
	.section	.rodata.flash_erase_all.str1.1,"aMS",@progbits,1
.LC36:
	.string	"erase done: %x\n"
	.section	.rodata.flash_erase_block_en.str1.1,"aMS",@progbits,1
.LC34:
	.string	"flash_erase_block %x %x %x\n"
.LC35:
	.string	"flash_erase_block %d block = %x status = %x\n"
	.section	.rodata.flash_erase_duplane_block.str1.1,"aMS",@progbits,1
.LC32:
	.string	"flash_erase_duplane_block %x %x %x\n"
.LC33:
	.string	"flash_erase_duplane_block pageadd = %x status = %x\n"
	.section	.rodata.flash_get_last_written_page.str1.1,"aMS",@progbits,1
.LC123:
	.string	"flash_get_last_written_page: %x %x %x\n"
	.section	.rodata.flash_info_blk_init.str1.1,"aMS",@progbits,1
.LC175:
	.string	"...%d @ %s %d %p\n"
.LC176:
	.string	"no sys info %x\n"
	.section	.rodata.flash_info_data_init.str1.1,"aMS",@progbits,1
.LC92:
	.string	"...%d @ %s\n"
	.section	.rodata.flash_info_flush.str1.1,"aMS",@progbits,1
.LC172:
	.string	"finfo:"
.LC173:
	.string	"flash_info_flush id = %x, page = %x\n"
.LC174:
	.string	"sys_info_flush error:%x\n"
	.section	.rodata.flash_mask_bad_block.str1.1,"aMS",@progbits,1
.LC42:
	.string	"flash_mask_bad_block %d %d\n"
	.section	.rodata.flash_prog_page.str1.1,"aMS",@progbits,1
.LC130:
	.string	"flash_prog_page %x %x %x\n"
.LC131:
	.string	"flash_prog_page page_addr = %x status = %x\n"
	.section	.rodata.flash_prog_page_en.str1.1,"aMS",@progbits,1
.LC138:
	.string	"flash_prog_page_en:%x %x %x\n"
.LC139:
	.string	"w d:"
.LC140:
	.string	"w s:"
.LC141:
	.string	"spare"
.LC142:
	.string	"data"
.LC143:
	.string	"write error: %x\n"
	.section	.rodata.flash_read_id.str1.1,"aMS",@progbits,1
.LC39:
	.string	"No.%d FLASH ID:%x %x %x %x %x %x\n"
	.section	.rodata.flash_read_otp_data.str1.1,"aMS",@progbits,1
.LC40:
	.string	"otp:%x %x %x %x\n"
	.section	.rodata.flash_read_page.str1.1,"aMS",@progbits,1
.LC110:
	.string	"flash_read_page %x %x %x\n"
	.section	.rodata.flash_read_page_en.str1.1,"aMS",@progbits,1
.LC121:
	.string	"flash_read_page_en %x %x %x\n"
.LC122:
	.string	"flash_read_page_en %x %x error_ecc %d %d\n"
	.section	.rodata.flash_set_interface_mode.str1.1,"aMS",@progbits,1
.LC37:
	.string	"nand sdr mode %x\n"
.LC38:
	.string	"nand ddr mode %x\n"
	.section	.rodata.ftl_alloc_new_data_sblk.str1.1,"aMS",@progbits,1
.LC236:
	.string	"error gc_add_sblk: %x\n"
	.section	.rodata.ftl_alloc_sblk.str1.1,"aMS",@progbits,1
.LC74:
	.string	"alloc sblk %x %d\n"
	.section	.rodata.ftl_dump_write_open_sblk.str1.1,"aMS",@progbits,1
.LC162:
	.string	"ftl_sblk_dump_write = %x %d %d %d %d\n"
.LC163:
	.string	"blk= %x, page=%x, ppa = %x, status = %x, data:%x %x %x %x, spare: %x %x %x %x\n"
.LC164:
	.string	"ftl_sblk_dump_write2 = %x %d %d %d\n"
.LC165:
	.string	"ftl_sblk_dump_write = %x %x\n"
.LC166:
	.string	"ftl_sblk_dump_write done = %x\n"
	.section	.rodata.ftl_ext_info_init.str1.1,"aMS",@progbits,1
.LC149:
	.string	"%s %d %d %x %x\n"
.LC150:
	.string	"%s %x %x %x\n"
	.section	.rodata.ftl_free_sblk.str1.1,"aMS",@progbits,1
.LC63:
	.string	"swl_slc_free_mini_ec_blk sblk %x\n"
	.section	.rodata.ftl_info_blk_init.str1.1,"aMS",@progbits,1
.LC146:
	.string	"%d %x @%d %x\n"
.LC147:
	.string	"ftl_info_blk_init %d %d %x\n"
.LC148:
	.string	"ink flag: %x\n"
	.section	.rodata.ftl_info_flush.str1.1,"aMS",@progbits,1
.LC145:
	.string	"g_ftl_info_blk blk = %x, page = %x version = %d\n"
	.section	.rodata.ftl_ink_check_sblk.str1.1,"aMS",@progbits,1
.LC167:
	.string	"ftl_ink_check_sblk = %x %d %d\n"
.LC168:
	.string	"ftl_ink_check_sblk = %x %d %d end\n"
	.section	.rodata.ftl_low_format.str1.1,"aMS",@progbits,1
.LC169:
	.string	"ftl_low_format %d\n"
.LC170:
	.string	"low format %d %d %d %d\n"
	.section	.rodata.ftl_mask_bad_block.str1.1,"aMS",@progbits,1
.LC61:
	.string	"mask bad block:cs %x %x block: %x %x\n"
	.section	.rodata.ftl_open_sblk_recovery.str1.1,"aMS",@progbits,1
.LC151:
	.string	"saved_active_page  = %x\n"
.LC152:
	.string	"saved_active_plane = %x\n"
.LC153:
	.string	"sblk = %x\n"
.LC154:
	.string	"phy_blk = %x %x\n"
.LC155:
	.string	"num_planes = %x\n"
.LC156:
	.string	"sblk = %x, vpn0 = %d, vpn1 = %d\n"
.LC157:
	.string	"dump_write_lpa = %x %x %x %x\n"
.LC158:
	.string	"dump write new ppa = %x, last ppa = %x lpa = %x\n"
.LC159:
	.string	"dump write = %x %x %x\n"
.LC160:
	.string	"dump write hash update = %x %x %x\n"
	.section	.rodata.ftl_re_low_format.str1.1,"aMS",@progbits,1
.LC171:
	.string	"re low format %d\n"
	.section	.rodata.ftl_sblk_dump.str1.1,"aMS",@progbits,1
.LC221:
	.string	"ftl_sblk_dump = %x %d %d %d %d\n"
.LC222:
	.string	"ftl_sblk_dump = %x %x %x %x\n"
.LC223:
	.string	"page_addr = %x, lpa=%x vpn = %d\n"
.LC224:
	.string	"index= %x, lpa=%x\n"
.LC225:
	.string	"block = %x, vpn=%x check vpn = %d\n"
	.section	.rodata.ftl_sysblk_dump.str1.1,"aMS",@progbits,1
.LC177:
	.string	"l2p:"
	.section	.rodata.ftl_test_block.str1.1,"aMS",@progbits,1
.LC144:
	.string	"low format %d\n"
	.section	.rodata.ftl_update_l2p_map.str1.1,"aMS",@progbits,1
.LC232:
	.string	"ftl_update_l2p_map: %x %x %x\n"
.LC233:
	.string	"ftl_update_l2p_map"
.LC234:
	.string	"lpa_tbl:"
.LC235:
	.string	"sblk %x vpn: %d %d\n"
	.section	.rodata.ftl_vpn_decrement.str1.1,"aMS",@progbits,1
.LC60:
	.string	"ftl_vpn_decrement %x = %d, %d\n"
	.section	.rodata.ftl_write_commit.str1.1,"aMS",@progbits,1
.LC237:
	.string	"%d read error: ppa:%x, lpa:%x, status:%x\n"
	.section	.rodata.ftl_write_completed.str1.1,"aMS",@progbits,1
.LC72:
	.string	"ftl prog error =%x, lpa = %x, ppa= %x\n"
.LC73:
	.string	"ftl re prog: lpa = %x, ppa= %x\n"
	.section	.rodata.gc_add_sblk.str1.1,"aMS",@progbits,1
.LC43:
	.string	"gc_add_sblk = %d, %d, %d, %d, %d, %d, %d\n"
.LC44:
	.string	"gc_add_sblk = %d, %d, %d\n"
.LC45:
	.string	"gc_add_sblk = %d, %d, %d,last update:%d, %d\n"
.LC46:
	.string	"gc_add_sblk = %d, %d, %d, %d, %d, %d\n"
	.section	.rodata.gc_check_data_one_wl.str1.1,"aMS",@progbits,1
.LC229:
	.string	"gc_lpa:"
.LC230:
	.string	"gc_ppa:"
.LC231:
	.string	"err: ppa = %x, status = %x, %x %x spare: %x %x %x %x\n"
	.section	.rodata.gc_do_copy_back.str1.1,"aMS",@progbits,1
.LC238:
	.string	"gc page in buf: lpa %x ppa = %x pageindex= %x\n"
.LC239:
	.string	"gc_do_copy_back: lpa %x des_ppa = %x %x gc_ppa= %x page_index= %d\n"
.LC240:
	.string	"gc_do_copy_back: %x %x %x %x gc_ppa:%x %x %x %d\n"
.LC241:
	.string	"%d prog_step: %x %x buf id= %x ppa = %x hash=%d id = %x plane = %x lpa=%x %x\n"
	.section	.rodata.gc_free_bad_sblk.str1.1,"aMS",@progbits,1
.LC62:
	.string	"gc_free_bad_sblk 0x%x\n"
	.section	.rodata.gc_free_src_blk.str1.1,"aMS",@progbits,1
.LC64:
	.string	"gc_free_src_blk = %x, vpn = %d\n"
.LC65:
	.string	"gc_free_src_blk %x, %d\n"
	.section	.rodata.gc_free_temp_buf.str1.1,"aMS",@progbits,1
.LC50:
	.string	"%d gc_free_temp_buf buf id= %x\n"
	.section	.rodata.gc_mark_bad_ppa.str1.1,"aMS",@progbits,1
.LC47:
	.string	"gc_mark_bad_ppa %d %x %x\n"
	.section	.rodata.gc_recovery.str1.1,"aMS",@progbits,1
.LC199:
	.string	"ppa = %x, status = %x, data:%x %x %x %x, spare: %x %x %x %x\n"
.LC200:
	.string	"ppa = %x, status = %x, %x %x spare: %x %x %x %x\n"
.LC201:
	.string	"gc_recovery: %x vpn = %x\n"
	.section	.rodata.gc_scan_src_blk.str1.1,"aMS",@progbits,1
.LC219:
	.string	"gc_scan_src_blk = %x, vpn = %d\n"
.LC220:
	.string	"gc_scan_src_blk = %x, s vpn0 = %d, c vpn1 = %d\n"
	.section	.rodata.gc_search_src_blk.str1.1,"aMS",@progbits,1
.LC52:
	.string	"zftl_get_gc_node cache = %x index = %d vpn = %x\n"
.LC53:
	.string	"gc_search_src_blk mode = %x, src mode = %x, count= %d %d\n"
	.section	.rodata.gc_static_wearleveling.str1.1,"aMS",@progbits,1
.LC80:
	.string	"gc_static_wearleveling: min blk: %x,sec=%d,xec = %d ,mode=%d, func=%x, bbt=%x vpn = %d\n"
.LC81:
	.string	"gc_static_wearleveling: min slc blk: %x,sec=%d,xec = %d ,mode=%d, func=%x, bbt=%x vpn = %d\n"
.LC82:
	.string	"gc_static_wearleveling: min tlc blk: %x,sec=%d,xec = %d ,mode=%d, func=%x, bbt=%x vpn = %d\n"
.LC83:
	.string	"gc_static_wearleveling: max slc blk: %x,sec=%d,xec = %d ,mode=%d, func=%x, bbt=%x vpn = %d\n"
.LC84:
	.string	"gc_static_wearleveling: max xlc blk: %x,sec=%d,xec = %d ,mode=%d, func=%x, bbt=%x vpn = %d\n"
.LC85:
	.string	"gc_static_wearleveling: slc blk: %x, tlc blk: %d avg slc ec: %d, avg tlc ec: %d \n"
.LC86:
	.string	"gc_static_wearleveling: min slc ec: %x, min tlc ec: %d max slc ec: %d, max tlc ec: %d; %d %d\n"
.LC87:
	.string	"swl add tlc gc = %x, %d, %d, %d, %d, %d\n"
.LC88:
	.string	"swl add slc gc  = %x, %d, %d, %d, %d, %d\n"
	.section	.rodata.gc_update_l2p_map_new.str1.1,"aMS",@progbits,1
.LC215:
	.string	"gc_update_l2p_map_new sblk %x\n"
.LC216:
	.string	"gc_update_l2p_map_new: %x %x %x\n"
.LC217:
	.string	"lpa: %x %x %x\n"
.LC218:
	.string	"gc_update_l2p_map_new: %x vpn = %x vpn1 = %x done\n"
	.section	.rodata.gc_write_completed.str1.1,"aMS",@progbits,1
.LC48:
	.string	"status: %x, ppa: %x\n"
.LC49:
	.string	"gc_write_completed: %x  %x  %d %x\n"
	.section	.rodata.hynix_get_read_retry_default.str1.1,"aMS",@progbits,1
.LC100:
	.string	"otp error! %d"
.LC101:
	.string	"rr"
	.section	.rodata.hynix_read_retrial.str1.1,"aMS",@progbits,1
.LC116:
	.string	"hynix RR %d row=%x, count %d, status=%d\n"
	.section	.rodata.idb_write_data.str1.1,"aMS",@progbits,1
.LC132:
	.string	"1 write_idblock fix data %x %x %x\n"
.LC133:
	.string	"write_idblock check fail! %x\n"
.LC134:
	.string	"write_idblock fail! %x\n"
	.section	.rodata.load_l2p_region.str1.1,"aMS",@progbits,1
.LC190:
	.string	"region_id = %d, pm_max_region = %d\n"
.LC191:
	.string	"load_l2p_region no ppa = %x , %x, all setting 0xff....\n"
.LC192:
	.string	"load_l2p_region = %x,%x,%x, %x\n"
.LC193:
	.string	"pm_ppa:"
.LC194:
	.string	"data:"
.LC195:
	.string	"spare:"
	.section	.rodata.lpa_rebuild_hash.str1.1,"aMS",@progbits,1
.LC79:
	.string	"%s %d %d\n"
	.section	.rodata.micron_read_retrial.str1.1,"aMS",@progbits,1
.LC111:
	.string	"MT %d row=%x,last status %d,status = %d\n"
.LC112:
	.string	"MT RR %d row=%x,count %d,status=%d\n"
	.section	.rodata.nand_flash_print_info.str1.1,"aMS",@progbits,1
.LC1:
	.string	"...%s enter...\n"
.LC2:
	.string	"No.0 FLASH ID: %x %x %x %x %x %x\n"
.LC3:
	.string	"DiePerChip: %x\n"
.LC4:
	.string	"SectPerPage: %x\n"
.LC5:
	.string	"PagePerBlk: %x\n"
.LC6:
	.string	"Cell: %x\n"
.LC7:
	.string	"PlanePerDie: %x\n"
.LC8:
	.string	"BlkPerPlane: %x\n"
.LC9:
	.string	"die gap: %x\n"
.LC10:
	.string	"lsbMode: %x\n"
.LC11:
	.string	"ReadRetryMode: %x\n"
.LC12:
	.string	"ecc: %x\n"
.LC13:
	.string	"idb ecc: %x\n"
.LC14:
	.string	"g_flash_slc_mode: %x\n"
.LC15:
	.string	"OptMode: %x\n"
.LC16:
	.string	"g_nand_max_die: %x\n"
.LC17:
	.string	"Cache read enable: %x\n"
.LC18:
	.string	"Cache random read enable: %x\n"
.LC19:
	.string	"Cache prog enable: %x\n"
.LC20:
	.string	"multi read enable: %x\n"
.LC21:
	.string	"multi prog enable: %x\n"
.LC22:
	.string	"interleave enable: %x\n"
.LC23:
	.string	"read retry enable: %x\n"
.LC24:
	.string	"randomizer enable: %x\n"
.LC25:
	.string	"SDR enable: %x\n"
.LC26:
	.string	"ONFI enable: %x\n"
.LC27:
	.string	"TOGGLE enable: %x\n"
.LC28:
	.string	"g_flash_slc_mode: %x %x\n"
.LC29:
	.string	"MultiPlaneProgCmd: %x %x\n"
.LC30:
	.string	"MultiPlaneReadCmd: %x %x\n"
.LC31:
	.string	"g_flash_toggle_mode_en: %x\n"
	.section	.rodata.nandc_init.str1.1,"aMS",@progbits,1
.LC93:
	.string	"...%s enter... %p\n"
.LC94:
	.string	"0:%x %x %x %x %x\n"
.LC95:
	.string	"g_nandc_ver...%d\n"
	.section	.rodata.nandc_xfer.str1.1,"aMS",@progbits,1
.LC107:
	.string	"dqs data abort %x\n"
.LC108:
	.string	"dqs data timeout %x\n"
.LC109:
	.string	"xfer error %x\n"
	.section	.rodata.nandc_xfer_done.str1.1,"aMS",@progbits,1
.LC102:
	.string	"flash_abort_clear = %d\n"
.LC103:
	.string	"%d mtrans_cnt = %d page_num = %d\n"
.LC104:
	.string	"nandc:"
.LC105:
	.string	"%d flReg.d32=%x %x\n"
.LC106:
	.string	"nandc_xfer_done read error %x\n"
	.section	.rodata.pm_alloc_new_blk.str1.1,"aMS",@progbits,1
.LC77:
	.string	"blk %x is bad block\n"
.LC78:
	.string	"pm_alloc_new_blk: %x %x %x %x\n"
	.section	.rodata.pm_free_sblk.str1.1,"aMS",@progbits,1
.LC90:
	.string	"GC PM block %x %x %x %d\n"
.LC91:
	.string	"ftl_free_no_use_map_blk %x %x %x %d\n"
	.section	.rodata.pm_init.str1.1,"aMS",@progbits,1
.LC196:
	.string	"pm_init posr %x %x %x\n"
.LC197:
	.string	"pm_init recovery %x %x %x\n"
	.section	.rodata.pm_log2phys.str1.1,"aMS",@progbits,1
.LC198:
	.string	"pm_log2phys  lpn = %d, max lpn = %d\n"
	.section	.rodata.pm_ppa_update_check.str1.1,"aMS",@progbits,1
.LC189:
	.string	"%s w error lpn = %x, max ppa = %d\n"
	.section	.rodata.pm_write_page.str1.1,"aMS",@progbits,1
.LC161:
	.string	"pm_write_page write error: %x\n"
	.section	.rodata.print_ftl_debug_info.str1.1,"aMS",@progbits,1
.LC66:
	.string	"bad blk = %x, %x free blk: s:%x,t:%x,m:%x, data blk:s:%x,%x,t%x vpn: s:%x t:%x, max_vpn: %x\n"
.LC67:
	.string	"totle w: %d MB,r: %d MB %d dv:0x%X,poc:%d\n"
.LC68:
	.string	"gc xlc page: %d,gc slc page: %d, tmp w: %d MB\n"
.LC69:
	.string	"slc ec: %d,%d,%d,%d,%d,tlc ec: %d,%d,%d,%d,%d\n"
.LC70:
	.string	"gc th: tlc_tlc: %d tlc_slc: %d slc_slc: %d slc_tlc:%d free_th: %d\n"
.LC71:
	.string	"swl : %x %x %x %x %x %x\n"
	.section	.rodata.print_gc_debug_info.str1.1,"aMS",@progbits,1
.LC51:
	.string	"gc: b:%x,p:%x,i:%x; free buf=%d %d free slc th: %d\n"
	.section	.rodata.print_list_info.str1.1,"aMS",@progbits,1
.LC58:
	.string	"list count:%p %d\n"
.LC59:
	.string	"%d: node:%x %x %x %x, %d %d %d %d %d\n"
	.section	.rodata.queue_wait_first_req_completed.str1.1,"aMS",@progbits,1
.LC125:
	.string	"read: %x %x %x %x\n"
.LC126:
	.string	"0set buf %d,status = %x, ppa = %x lun state = %d\n"
.LC127:
	.string	"prog end %x %x error_ecc %d %d\n"
.LC128:
	.string	"1set buf %d,status = %x, ppa = %x lun state = %d\n"
.LC129:
	.string	"dp prog end %x %x error_ecc %d %d\n"
	.section	.rodata.random_seed,"a",@progbits
	.align	3
	.set	.LANCHOR51,. + 0
	.type	random_seed, %object
	.size	random_seed, 256
random_seed:
	.hword	22378
	.hword	1512
	.hword	25245
	.hword	17827
	.hword	25756
	.hword	19440
	.hword	9026
	.hword	10030
	.hword	29528
	.hword	20467
	.hword	29676
	.hword	24432
	.hword	31328
	.hword	6872
	.hword	13426
	.hword	13842
	.hword	8783
	.hword	1108
	.hword	782
	.hword	28837
	.hword	30729
	.hword	9505
	.hword	18676
	.hword	23085
	.hword	18730
	.hword	1085
	.hword	32609
	.hword	14697
	.hword	20858
	.hword	15170
	.hword	30365
	.hword	1607
	.hword	32298
	.hword	4995
	.hword	18905
	.hword	1976
	.hword	9592
	.hword	20204
	.hword	17443
	.hword	13615
	.hword	23330
	.hword	29369
	.hword	13947
	.hword	9398
	.hword	32398
	.hword	8984
	.hword	27600
	.hword	21785
	.hword	6019
	.hword	6311
	.hword	31598
	.hword	30210
	.hword	19327
	.hword	13896
	.hword	11347
	.hword	27545
	.hword	3107
	.hword	26575
	.hword	32270
	.hword	19852
	.hword	20601
	.hword	8349
	.hword	9290
	.hword	29819
	.hword	13579
	.hword	3661
	.hword	28676
	.hword	27331
	.hword	32574
	.hword	8693
	.hword	31253
	.hword	9081
	.hword	5399
	.hword	6842
	.hword	20087
	.hword	5537
	.hword	1274
	.hword	11617
	.hword	9530
	.hword	4866
	.hword	8035
	.hword	23219
	.hword	1178
	.hword	23272
	.hword	7383
	.hword	18944
	.hword	12488
	.hword	12871
	.hword	29340
	.hword	20532
	.hword	11022
	.hword	22514
	.hword	228
	.hword	22363
	.hword	24978
	.hword	14584
	.hword	12138
	.hword	3092
	.hword	17916
	.hword	16863
	.hword	14554
	.hword	31457
	.hword	29474
	.hword	25311
	.hword	24121
	.hword	3684
	.hword	28037
	.hword	22865
	.hword	22839
	.hword	25217
	.hword	13217
	.hword	27186
	.hword	14938
	.hword	11180
	.hword	29754
	.hword	24180
	.hword	15150
	.hword	32455
	.hword	20434
	.hword	23848
	.hword	29983
	.hword	16120
	.hword	14769
	.hword	20041
	.hword	29803
	.hword	28406
	.hword	17598
	.hword	28087
	.section	.rodata.rk_ftl_init.str1.1,"aMS",@progbits,1
.LC214:
	.string	"zftl_init %x\n"
	.section	.rodata.rknand_print_hex.str1.1,"aMS",@progbits,1
.LC96:
	.string	"%s 0x%x:"
.LC97:
	.string	"%x "
.LC98:
	.string	""
.LC99:
	.string	"%s\n"
	.section	.rodata.sandisk_prog_test_bad_block.str1.1,"aMS",@progbits,1
.LC41:
	.string	"bad block test:%x %x\n"
	.section	.rodata.sblk_3d_tlc_dump_prog.str1.1,"aMS",@progbits,1
.LC135:
	.string	"sblk_3d_tlc_dump_prog wl_addr= %x ppa = %x ppa = %x\n"
	.section	.rodata.sblk_mlc_dump_prog.str1.1,"aMS",@progbits,1
.LC136:
	.string	"sblk_mlc_dump_prog wl_addr= %x ppa = %x ppa = %x\n"
	.section	.rodata.sblk_prog_page.str1.1,"aMS",@progbits,1
.LC137:
	.string	"sblk_prog_page ppa = %x, count = %d\n"
	.section	.rodata.toshiba_15ref_value,"a",@progbits
	.align	3
	.set	.LANCHOR22,. + 0
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
	.section	.rodata.toshiba_3D_slc_value,"a",@progbits
	.align	3
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
	.section	.rodata.toshiba_3D_tlc_value,"a",@progbits
	.align	3
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
	.section	.rodata.toshiba_3d_read_retrial.str1.1,"aMS",@progbits,1
.LC113:
	.string	"toshiba SRR %d row=%x, status=%d\n"
.LC114:
	.string	"toshiba TRR %d row=%x, status=%d\n"
.LC115:
	.string	"toshiba RR %d row=%x,count %d,status=%d\n"
	.section	.rodata.toshiba_A19ref_value,"a",@progbits
	.align	3
	.set	.LANCHOR23,. + 0
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
	.section	.rodata.toshiba_ref_value,"a",@progbits
	.align	3
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
	.section	.rodata.zftl_discard.str1.1,"aMS",@progbits,1
.LC247:
	.string	"ftl_discard:(%x, %x, %x, %x)\n"
	.section	.rodata.zftl_do_gc.str1.1,"aMS",@progbits,1
.LC242:
	.string	"gc %d: %d %d %d %d %d %d %d\n"
.LC243:
	.string	"gc %d: %d %d %d %d %d %d\n"
.LC244:
	.string	"GC_STATE_SCAN_ALL_PAGE = %x, vpn0 = %d, vpn1 = %d\n"
.LC245:
	.string	"gc free %x, %d\n"
	.section	.rodata.zftl_gc_get_free_sblk.str1.1,"aMS",@progbits,1
.LC54:
	.string	"swl_tlc_free_mini_ec_blk alloc sblk %x\n"
.LC55:
	.string	"zftl_get_free_sblk %x %d, %p %d %d\n"
.LC56:
	.string	"zftl_gc_get_free_sblk %x %x %x, %d %d %d\n"
	.section	.rodata.zftl_get_free_sblk.str1.1,"aMS",@progbits,1
.LC57:
	.string	"swl_slc_free_mini_ec_blk alloc sblk %x\n"
	.section	.rodata.zftl_init.str1.1,"aMS",@progbits,1
.LC202:
	.string	"FTL version: 6.0.18 20190918"
.LC203:
	.string	"_c_user_data_density := %d\n"
.LC204:
	.string	"_c_totle_phy_density := %d\n"
.LC205:
	.string	"_c_totle_log_page := %d\n"
.LC206:
	.string	"_c_totle_data_density := %d\n"
.LC207:
	.string	"_c_ftl_pm_page_num := %d\n"
.LC208:
	.string	"_c_ftl_byte_pre_page := %d\n"
.LC209:
	.string	"_c_max_pm_sblk := %d\n"
.LC210:
	.string	"_min_slc_super_block := %d\n"
.LC211:
	.string	"_max_xlc_super_block := %d\n"
.LC212:
	.string	"gp_ftl_ext_info %p %p %p\n"
.LC213:
	.string	"flash info size: %d %d %d\n"
	.section	.rodata.zftl_read.str1.1,"aMS",@progbits,1
.LC226:
	.string	"ftl_read %x %x %x\n"
.LC227:
	.string	"ftl_read refresh =%x, lpa = %x, ppa= %x\n"
.LC228:
	.string	"id=%d, status = %x, lpa = %x, ppa = %x spare = %x %x %x %x\n"
	.section	.rodata.zftl_sblk_list_init.str1.1,"aMS",@progbits,1
.LC89:
	.string	"free blk vpn error: %x %x\n"
	.section	.rodata.zftl_write.str1.1,"aMS",@progbits,1
.LC246:
	.string	"ftlwrite %x %x %x %x\n"
	.hidden	free
