/*
 * Copyright (c) 2016-2017, Fuzhou Rockchip Electronics Co., Ltd
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * date: 2020-04-17
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
	.section	.text.nandc_de_cs.constprop.31,"ax",@progbits
	.align	2
	.type	nandc_de_cs.constprop.31, %function
nandc_de_cs.constprop.31:
	adrp	x0, .LANCHOR13
	ldr	x1, [x0, #:lo12:.LANCHOR13]
	ldr	w0, [x1]
	and	w0, w0, -256
	and	w0, w0, -131073
	str	w0, [x1]
	ret
	.size	nandc_de_cs.constprop.31, .-nandc_de_cs.constprop.31
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
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrb	w1, [x0, 22]
	adrp	x0, .LC14
	add	x0, x0, :lo12:.LC14
	bl	printf
.L99:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L100
	adrp	x0, .LANCHOR18
	ldrb	w1, [x0, #:lo12:.LANCHOR18]
	adrp	x0, .LC15
	add	x0, x0, :lo12:.LC15
	bl	printf
.L100:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L101
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrb	w1, [x0, 16]
	adrp	x0, .LC16
	add	x0, x0, :lo12:.LC16
	and	w1, w1, 1
	bl	printf
.L101:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L102
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrh	w1, [x0, 16]
	adrp	x0, .LC17
	add	x0, x0, :lo12:.LC17
	ubfx	x1, x1, 1, 1
	bl	printf
.L102:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L103
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrh	w1, [x0, 16]
	adrp	x0, .LC18
	add	x0, x0, :lo12:.LC18
	ubfx	x1, x1, 2, 1
	bl	printf
.L103:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L104
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrh	w1, [x0, 16]
	adrp	x0, .LC19
	add	x0, x0, :lo12:.LC19
	ubfx	x1, x1, 3, 1
	bl	printf
.L104:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L105
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrh	w1, [x0, 16]
	adrp	x0, .LC20
	add	x0, x0, :lo12:.LC20
	ubfx	x1, x1, 4, 1
	bl	printf
.L105:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L106
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrh	w1, [x0, 16]
	adrp	x0, .LC21
	add	x0, x0, :lo12:.LC21
	ubfx	x1, x1, 5, 1
	bl	printf
.L106:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L107
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrh	w1, [x0, 16]
	adrp	x0, .LC22
	add	x0, x0, :lo12:.LC22
	ubfx	x1, x1, 6, 1
	bl	printf
.L107:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L108
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrh	w1, [x0, 16]
	adrp	x0, .LC23
	add	x0, x0, :lo12:.LC23
	ubfx	x1, x1, 7, 1
	bl	printf
.L108:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L109
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrb	w1, [x0, 17]
	adrp	x0, .LC24
	add	x0, x0, :lo12:.LC24
	and	w1, w1, 1
	bl	printf
.L109:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L110
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrh	w1, [x0, 16]
	adrp	x0, .LC25
	add	x0, x0, :lo12:.LC25
	ubfx	x1, x1, 9, 1
	bl	printf
.L110:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L111
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrh	w1, [x0, 16]
	adrp	x0, .LC26
	add	x0, x0, :lo12:.LC26
	ubfx	x1, x1, 10, 1
	bl	printf
.L111:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L112
	adrp	x0, .LANCHOR19
	ldrb	w2, [x0, #:lo12:.LANCHOR19]
	adrp	x0, .LANCHOR0
	ldrb	w1, [x0, #:lo12:.LANCHOR0]
	adrp	x0, .LC27
	add	x0, x0, :lo12:.LC27
	bl	printf
.L112:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L113
	adrp	x0, .LANCHOR20
	add	x0, x0, :lo12:.LANCHOR20
	ldrb	w2, [x0, 11]
	ldrb	w1, [x0, 10]
	adrp	x0, .LC28
	add	x0, x0, :lo12:.LC28
	bl	printf
.L113:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L114
	adrp	x0, .LANCHOR20
	add	x0, x0, :lo12:.LANCHOR20
	ldrb	w2, [x0, 9]
	ldrb	w1, [x0, 8]
	adrp	x0, .LC29
	add	x0, x0, :lo12:.LC29
	bl	printf
.L114:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L85
	adrp	x0, .LANCHOR21
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ldrb	w1, [x0, #:lo12:.LANCHOR21]
	adrp	x0, .LC30
	add	x0, x0, :lo12:.LC30
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
.L205:
	ldr	w0, [sp, 12]
	sub	w1, w0, #1
	str	w1, [sp, 12]
	cbnz	w0, .L205
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
	bhi	.L218
	ret
.L212:
	cmp	w0, 35
	bne	.L214
	ldrsb	w0, [x3, x2]
	b	.L219
.L214:
	ldrsb	w0, [x10, w11, sxtw]
	b	.L219
.L218:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
.L215:
	mov	w0, 85
	str	w0, [x4, 8]
	add	x0, x5, :lo12:.LANCHOR23
	ldrsb	w0, [x2, x0]
	str	w0, [x4, 4]
	mov	w0, 200
	bl	timer_delay_ns
	ldrb	w0, [x8]
	cmp	w0, 34
	bne	.L212
	ldrsb	w0, [x7, x2]
.L219:
	str	w0, [x4]
	add	x2, x2, 1
	ldrb	w0, [x6]
	cmp	w0, w2
	bhi	.L215
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
	beq	.L221
	mov	w3, 160
	umaddl	x1, w3, w0, x1
.L221:
	ubfiz	x0, x0, 8, 8
	mov	x3, 0
	add	x2, x2, x0
	mov	w0, 54
	add	x4, x4, x1
	cmp	w5, w3, uxtb
	str	w0, [x2, 2056]
	bhi	.L228
	mov	w0, 22
	str	w0, [x2, 2056]
	ret
.L228:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
.L224:
	ldrb	w0, [x6, x3]
	str	w0, [x2, 2052]
	mov	w0, 120
	bl	timer_delay_ns
	ldrsb	w0, [x4, x3]
	str	w0, [x2, 2048]
	add	x3, x3, 1
	cmp	w5, w3, uxtb
	bhi	.L224
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
	bhi	.L235
	adrp	x8, .LANCHOR27
	and	w0, w0, 255
	sxtw	x7, w0
	ldr	x1, [x8, #:lo12:.LANCHOR27]
	add	x1, x1, x7
	ldrb	w1, [x1, 120]
	cbz	w1, .L235
	stp	x29, x30, [sp, -16]!
	mov	w1, 0
	add	x29, sp, 0
	bl	hynix_set_rr_para
	ldr	x0, [x8, #:lo12:.LANCHOR27]
	add	x0, x0, x7
	strb	wzr, [x0, 120]
	ldp	x29, x30, [sp], 16
	ret
.L235:
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
	bne	.L239
	str	w1, [x2, 80]
	ret
.L239:
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
	bne	.L242
	ldr	w0, [x0, 80]
.L244:
	ubfx	x0, x0, 8, 8
	ret
.L242:
	ldr	w0, [x0, 304]
	b	.L244
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
	beq	.L246
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
	bne	.L248
	mov	w3, 8321
	str	w3, [x2, 8]
	str	w0, [x2, 80]
	mov	w0, 38
	str	w0, [x2, 84]
	mov	w0, 39
	str	w0, [x2, 84]
.L249:
	str	w1, [x2]
	ret
.L248:
	mov	w3, 8322
	str	w3, [x2, 344]
	str	w0, [x2, 304]
	mov	w0, 38
	str	w0, [x2, 308]
	mov	w0, 39
	str	w0, [x2, 308]
	b	.L249
.L246:
	and	w1, w1, -8193
	b	.L249
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
	bhi	.L254
	adrp	x1, .LANCHOR29
	adrp	x0, .LC0
	mov	w2, 704
	add	x1, x1, :lo12:.LANCHOR29
	add	x0, x0, :lo12:.LC0
	bl	printf
.L254:
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
.L257:
	str	w4, [x2, 2056]
	mov	w0, 120
	str	w19, [x2, 2052]
	str	w6, [x2, 2052]
	str	w7, [x2, 2052]
	bl	timer_delay_ns
	ldr	w3, [x2, 2048]
	and	w3, w3, 255
	bics	wzr, w20, w3
	bne	.L257
	cmp	w3, 255
	beq	.L257
	bl	nandc_de_cs.constprop.31
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
	bne	.L261
	adrp	x0, .LANCHOR0
	adrp	x5, .LANCHOR1
	ldrb	w0, [x0, #:lo12:.LANCHOR0]
	cbz	w0, .L262
	ldrb	w0, [x5, #:lo12:.LANCHOR1]
	cbz	w0, .L261
.L262:
	adrp	x0, .LANCHOR2
	ldrh	w3, [x0, #:lo12:.LANCHOR2]
	udiv	w0, w1, w3
	mul	w0, w0, w3
	sub	w3, w1, w0
	ldrb	w1, [x5, #:lo12:.LANCHOR1]
	cbz	w1, .L263
	add	w1, w0, w3, lsl 1
.L261:
	mov	w0, w4
	b	flash_wait_device_ready_raw
.L263:
	adrp	x5, .LANCHOR3
	add	x5, x5, :lo12:.LANCHOR3
	ldrh	w3, [x5, w3, uxtw 1]
	add	w1, w3, w0
	b	.L261
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
.L273:
	ldr	x0, [x3, #:lo12:.LANCHOR13]
	ldr	w0, [x0]
	str	w0, [x29, 24]
	ldr	w0, [x29, 24]
	tbnz	x0, 9, .L274
	mov	w0, 10
	bl	timer_delay_ns
	subs	w2, w2, #1
	bne	.L273
	mov	w0, -1
.L271:
	ldp	x29, x30, [sp], 32
	ret
.L274:
	mov	w0, 0
	b	.L271
	.size	nandc_wait_flash_ready_no_delay, .-nandc_wait_flash_ready_no_delay
	.section	.text.zftl_flash_enter_slc_mode,"ax",@progbits
	.align	2
	.global	zftl_flash_enter_slc_mode
	.type	zftl_flash_enter_slc_mode, %function
zftl_flash_enter_slc_mode:
	and	x4, x0, 255
	adrp	x0, .LANCHOR0
	ldrb	w0, [x0, #:lo12:.LANCHOR0]
	cbz	w0, .L296
	adrp	x1, .LANCHOR13
	cmp	w0, 1
	ldr	x5, [x1, #:lo12:.LANCHOR13]
	bne	.L280
	adrp	x0, .LANCHOR32+29
	ldrb	w0, [x0, #:lo12:.LANCHOR32+29]
	cbz	w0, .L296
	add	x4, x4, 8
	add	x4, x5, x4, lsl 8
	str	w0, [x4, 8]
	ret
.L280:
	stp	x29, x30, [sp, -16]!
	cmp	w0, 2
	add	x29, sp, 0
	bne	.L282
	adrp	x0, .LANCHOR33
	add	x0, x0, :lo12:.LANCHOR33
	ldrb	w1, [x0, x4]
	cbz	w1, .L277
	adrp	x6, .LANCHOR32
	add	x6, x6, :lo12:.LANCHOR32
	strb	wzr, [x0, x4]
	ldrb	w0, [x6, 29]
	cbz	w0, .L277
	bl	nandc_wait_flash_ready_no_delay
	add	x4, x4, 8
	add	x4, x5, x4, lsl 8
	ldrb	w0, [x6, 29]
	str	w0, [x4, 8]
.L277:
	ldp	x29, x30, [sp], 16
	ret
.L282:
	cmp	w0, 3
	bne	.L277
	adrp	x6, .LANCHOR33
	sxtw	x7, w4
	add	x6, x6, :lo12:.LANCHOR33
	ldrb	w0, [x6, x7]
	cbz	w0, .L277
	bl	nandc_wait_flash_ready_no_delay
	ubfiz	x4, x4, 8, 8
	add	x4, x5, x4
	mov	w0, 239
	strb	wzr, [x6, x7]
	str	w0, [x4, 2056]
	mov	w0, 145
	str	w0, [x4, 2052]
	mov	w0, 100
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
	b	.L277
.L296:
	ret
	.size	zftl_flash_enter_slc_mode, .-zftl_flash_enter_slc_mode
	.section	.text.zftl_flash_exit_slc_mode,"ax",@progbits
	.align	2
	.global	zftl_flash_exit_slc_mode
	.type	zftl_flash_exit_slc_mode, %function
zftl_flash_exit_slc_mode:
	and	x4, x0, 255
	adrp	x0, .LANCHOR0
	ldrb	w0, [x0, #:lo12:.LANCHOR0]
	cbz	w0, .L319
	adrp	x1, .LANCHOR13
	cmp	w0, 1
	ldr	x5, [x1, #:lo12:.LANCHOR13]
	bne	.L301
	adrp	x0, .LANCHOR32+30
	ldrb	w0, [x0, #:lo12:.LANCHOR32+30]
	cbz	w0, .L319
	add	x4, x4, 8
	add	x4, x5, x4, lsl 8
	str	w0, [x4, 8]
	ret
.L301:
	stp	x29, x30, [sp, -16]!
	cmp	w0, 2
	add	x29, sp, 0
	bne	.L303
	adrp	x0, .LANCHOR33
	add	x0, x0, :lo12:.LANCHOR33
	ldrb	w1, [x0, x4]
	cbnz	w1, .L298
	adrp	x6, .LANCHOR32
	add	x6, x6, :lo12:.LANCHOR32
	mov	w2, 4
	ldrb	w1, [x6, 12]
	cmp	w1, 2
	csel	w1, w1, w2, eq
	strb	w1, [x0, x4]
	ldrb	w0, [x6, 30]
	cbz	w0, .L298
	bl	nandc_wait_flash_ready_no_delay
	add	x4, x4, 8
	add	x4, x5, x4, lsl 8
	ldrb	w0, [x6, 30]
	str	w0, [x4, 8]
.L298:
	ldp	x29, x30, [sp], 16
	ret
.L303:
	cmp	w0, 3
	bne	.L298
	adrp	x6, .LANCHOR33
	sxtw	x7, w4
	add	x6, x6, :lo12:.LANCHOR33
	ldrb	w0, [x6, x7]
	cbnz	w0, .L298
	bl	nandc_wait_flash_ready_no_delay
	ubfiz	x4, x4, 8, 8
	adrp	x2, .LANCHOR32
	add	x2, x2, :lo12:.LANCHOR32
	add	x4, x5, x4
	mov	w1, 4
	ldrb	w0, [x2, 12]
	cmp	w0, 2
	csel	w0, w0, w1, eq
	strb	w0, [x6, x7]
	mov	w0, 239
	str	w0, [x4, 2056]
	mov	w0, 145
	str	w0, [x4, 2052]
	mov	w0, 100
	bl	timer_delay_ns
	ldrb	w0, [x2, 7]
	cmp	w0, 9
	mov	w0, 1
	bne	.L306
	str	w0, [x4, 2048]
.L307:
	str	w0, [x4, 2048]
	mov	w0, 150
	str	wzr, [x4, 2048]
	str	wzr, [x4, 2048]
	bl	timer_delay_ns
	bl	nandc_wait_flash_ready_no_delay
	mov	w0, 223
	str	w0, [x4, 2056]
	b	.L298
.L306:
	ldrb	w1, [x6, x7]
	str	w1, [x4, 2048]
	b	.L307
.L319:
	ret
	.size	zftl_flash_exit_slc_mode, .-zftl_flash_exit_slc_mode
	.section	.text.flash_start_page_read,"ax",@progbits
	.align	2
	.global	flash_start_page_read
	.type	flash_start_page_read, %function
flash_start_page_read:
	stp	x29, x30, [sp, -64]!
	mov	w8, 24
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w20, w0, 255
	adrp	x0, .LANCHOR31
	stp	x21, x22, [sp, 32]
	mov	w19, 1
	mov	w21, w1
	ldrb	w0, [x0, #:lo12:.LANCHOR31]
	str	x23, [sp, 48]
	sub	w22, w8, w0
	lsl	w19, w19, w0
	sub	w19, w19, #1
	lsr	w0, w1, w22
	and	w19, w19, w0
	adrp	x0, .LANCHOR18
	and	w19, w19, 255
	mov	x23, x0
	ldrb	w1, [x0, #:lo12:.LANCHOR18]
	cmp	w1, w19
	bhi	.L322
	adrp	x1, .LANCHOR34
	adrp	x0, .LC0
	mov	w2, 882
	add	x1, x1, :lo12:.LANCHOR34
	add	x0, x0, :lo12:.LC0
	bl	printf
.L322:
	ldrb	w0, [x23, #:lo12:.LANCHOR18]
	cmp	w0, w19
	bls	.L321
	adrp	x0, .LANCHOR30
	add	x0, x0, :lo12:.LANCHOR30
	mov	w8, 1
	lsl	w8, w8, w22
	sub	w8, w8, #1
	ldrb	w11, [x0, w19, sxtw]
	adrp	x0, .LANCHOR13
	and	w8, w8, w21
	ubfx	x21, x21, 24, 2
	ldr	x10, [x0, #:lo12:.LANCHOR13]
	mov	w0, w11
	bl	nandc_cs
	cbnz	w21, .L324
	mov	w0, w8
	bl	slc_phy_page_address_calc
	mov	w8, w0
	adrp	x0, .LANCHOR0
	ldrb	w0, [x0, #:lo12:.LANCHOR0]
	cbz	w0, .L325
	mov	w0, w11
	bl	zftl_flash_enter_slc_mode
.L325:
	ubfiz	x0, x11, 8, 8
	ldr	x23, [sp, 48]
	add	x0, x10, x0
	and	w1, w8, 255
	ldp	x21, x22, [sp, 32]
	str	wzr, [x0, 2056]
	str	wzr, [x0, 2052]
	str	wzr, [x0, 2052]
	str	w1, [x0, 2052]
	lsr	w1, w8, 8
	str	w1, [x0, 2052]
	lsr	w8, w8, 16
	str	w8, [x0, 2052]
	str	w20, [x0, 2056]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 64
	b	nandc_de_cs.constprop.31
.L324:
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrb	w0, [x0, 12]
	cmp	w0, 3
	bne	.L326
	adrp	x0, .LANCHOR35
	ldrb	w0, [x0, #:lo12:.LANCHOR35]
	cbnz	w0, .L326
	sxtw	x0, w11
	add	x0, x0, 8
	add	x0, x10, x0, lsl 8
	str	w21, [x0, 8]
	b	.L325
.L326:
	mov	w0, w11
	bl	zftl_flash_exit_slc_mode
	b	.L325
.L321:
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
.L333:
	ldr	x0, [x3, #:lo12:.LANCHOR13]
	ldr	w0, [x0]
	str	w0, [x29, 24]
	ldr	w0, [x29, 24]
	tbnz	x0, 9, .L334
	mov	w0, 10
	bl	timer_delay_ns
	subs	w2, w2, #1
	bne	.L333
	mov	w0, -1
.L331:
	ldp	x29, x30, [sp], 32
	ret
.L334:
	mov	w0, 0
	b	.L331
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
.L338:
	cmp	w4, w0
	bhi	.L341
	ldp	x29, x30, [sp], 16
	b	nandc_wait_flash_ready
.L341:
	cmp	w5, 67
	bne	.L339
	ldrsb	w6, [x1, x0]
.L343:
	add	x0, x0, 1
	str	w6, [x3]
	b	.L338
.L339:
	ldrsb	w6, [x2, x0]
	b	.L343
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
	cbz	w2, .L348
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
.L351:
	b	nandc_wait_flash_ready
.L348:
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
	b	.L351
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
	bhi	.L355
	adrp	x1, .LANCHOR40
	adrp	x0, .LC0
	mov	w2, 608
	add	x1, x1, :lo12:.LANCHOR40
	add	x0, x0, :lo12:.LC0
	bl	printf
.L355:
	ldrb	w0, [x19, #:lo12:.LANCHOR18]
	cmp	w0, w22
	bls	.L362
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
	tbz	x0, 4, .L357
	adrp	x0, .LC31
	mov	w3, w20
	mov	w2, w21
	mov	w1, w22
	add	x0, x0, :lo12:.LC31
	bl	printf
.L357:
	bl	nandc_wait_flash_ready
	mov	w0, w22
	bl	nandc_cs
	mov	w0, w22
	cbnz	w24, .L358
	bl	zftl_flash_enter_slc_mode
.L359:
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
	cbnz	w0, .L363
	mov	w0, 208
	str	w0, [x25, 2056]
	mov	w19, 5
	bl	nandc_wait_flash_ready
	mov	x0, x23
	bl	flash_read_status
	and	w5, w0, w19
.L360:
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
	bl	nandc_de_cs.constprop.31
	and	w19, w2, w19
	orr	w19, w19, w5
	cbz	w19, .L361
	adrp	x0, .LC32
	mov	w1, w21
	add	x0, x0, :lo12:.LC32
	bl	printf
.L361:
	mov	w0, w19
.L354:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L358:
	bl	zftl_flash_exit_slc_mode
	b	.L359
.L363:
	mov	w5, 0
	b	.L360
.L362:
	mov	w0, -1
	b	.L354
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
	bhi	.L372
	adrp	x1, .LANCHOR42
	adrp	x0, .LC0
	mov	w2, 657
	add	x1, x1, :lo12:.LANCHOR42
	add	x0, x0, :lo12:.LC0
	bl	printf
.L372:
	ldrb	w0, [x20, #:lo12:.LANCHOR18]
	cmp	w0, w22
	bls	.L378
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
	tbz	x0, 4, .L374
	adrp	x0, .LC33
	mov	w3, w24
	mov	w2, w23
	mov	w1, w21
	add	x0, x0, :lo12:.LC33
	bl	printf
.L374:
	bl	nandc_wait_flash_ready
	mov	w0, w21
	bl	nandc_cs
	mov	w0, w21
	cbnz	w24, .L375
	bl	zftl_flash_enter_slc_mode
.L376:
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
	mov	w3, w0
	bl	nandc_de_cs.constprop.31
	mov	w0, 5
	ands	w3, w3, w0
	beq	.L377
	adrp	x0, .LANCHOR2
	mov	w1, w22
	ldrh	w2, [x0, #:lo12:.LANCHOR2]
	adrp	x0, .LC34
	add	x0, x0, :lo12:.LC34
	udiv	w2, w23, w2
	bl	printf
	mov	w3, -1
.L377:
	mov	w0, w3
.L371:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L375:
	bl	zftl_flash_exit_slc_mode
	b	.L376
.L378:
	mov	w0, -1
	b	.L371
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
.L388:
	ldrb	w0, [x22]
	cmp	w0, w19
	bhi	.L391
	ldp	x19, x20, [sp, 16]
	mov	w1, 0
	ldp	x21, x22, [sp, 32]
	adrp	x0, .LC35
	ldp	x23, x24, [sp, 48]
	add	x0, x0, :lo12:.LC35
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	b	printf
.L391:
	add	x0, x24, :lo12:.LANCHOR30
	mov	w21, 0
	ldrb	w25, [x0, w19, sxtw]
.L389:
	cmp	w20, w21, uxth
	bhi	.L390
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L388
.L390:
	ldrh	w1, [x23]
	mov	w0, w25
	mul	w1, w1, w21
	add	w21, w21, 1
	bl	flash_erase_block
	b	.L389
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
	bhi	.L394
	adrp	x1, .LANCHOR43
	adrp	x0, .LC0
	mov	w2, 981
	add	x1, x1, :lo12:.LANCHOR43
	add	x0, x0, :lo12:.LC0
	bl	printf
.L394:
	adrp	x0, .LANCHOR30
	add	x0, x0, :lo12:.LANCHOR30
	ldrb	w8, [x0, w20, sxtw]
	adrp	x0, .LANCHOR13
	ldr	x11, [x0, #:lo12:.LANCHOR13]
	mov	w0, w8
	bl	nandc_cs
	adrp	x10, .LANCHOR16
	cbnz	w21, .L395
	mov	w0, w22
	bl	slc_phy_page_address_calc
	mov	w22, w0
	mov	w0, w19
	bl	slc_phy_page_address_calc
	mov	w19, w0
	adrp	x0, .LANCHOR0
	ldrb	w0, [x0, #:lo12:.LANCHOR0]
	cbz	w0, .L396
	mov	w0, w8
	bl	zftl_flash_enter_slc_mode
.L396:
	adrp	x0, .LANCHOR20
	and	x4, x8, 255
	add	x1, x0, :lo12:.LANCHOR20
	add	x4, x11, x4, lsl 8
	and	w3, w22, 255
	and	w6, w19, 255
	lsr	w5, w19, 8
	lsr	w19, w19, 16
	ldrb	w7, [x1, 8]
	ldrb	w2, [x1, 16]
	str	w7, [x4, 2056]
	cmp	w2, 1
	lsr	w2, w22, 8
	lsr	w22, w22, 16
	bne	.L398
	str	wzr, [x4, 2052]
	str	wzr, [x4, 2052]
	str	w3, [x4, 2052]
	str	w2, [x4, 2052]
	ldrb	w0, [x1, 9]
	str	w22, [x4, 2052]
	str	w0, [x4, 2056]
	bl	nandc_wait_flash_ready
	ldr	x0, [x10, #:lo12:.LANCHOR16]
	ldrb	w0, [x0, 12]
	cmp	w0, 3
	bne	.L399
	cbz	w21, .L399
	str	w21, [x4, 2056]
.L399:
	str	wzr, [x4, 2056]
	str	wzr, [x4, 2052]
	str	wzr, [x4, 2052]
.L412:
	ldp	x21, x22, [sp, 32]
	str	w6, [x4, 2052]
	str	w5, [x4, 2052]
	mov	w0, 48
	str	w19, [x4, 2052]
	str	w0, [x4, 2056]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	b	nandc_de_cs.constprop.31
.L395:
	ldr	x0, [x10, #:lo12:.LANCHOR16]
	ldrb	w0, [x0, 12]
	cmp	w0, 3
	bne	.L397
	adrp	x0, .LANCHOR35
	ldrb	w0, [x0, #:lo12:.LANCHOR35]
	cbnz	w0, .L397
	sxtw	x0, w8
	add	x0, x0, 8
	add	x0, x11, x0, lsl 8
	str	w21, [x0, 8]
	b	.L396
.L397:
	mov	w0, w8
	bl	zftl_flash_exit_slc_mode
	b	.L396
.L398:
	str	w3, [x4, 2052]
	ldr	x1, [x10, #:lo12:.LANCHOR16]
	str	w2, [x4, 2052]
	str	w22, [x4, 2052]
	ldrb	w1, [x1, 12]
	cmp	w1, 3
	bne	.L401
	cbz	w21, .L401
	str	w21, [x4, 2056]
.L401:
	add	x0, x0, :lo12:.LANCHOR20
	ldrb	w0, [x0, 9]
	str	w0, [x4, 2056]
	b	.L412
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
.L426:
	adrp	x0, .LANCHOR13
	ldr	x19, [x0, #:lo12:.LANCHOR13]
	lsl	x0, x25, 3
	ldrb	w24, [x0, x22]
	cmp	w24, 69
	beq	.L414
	add	w0, w24, 119
	cmp	w24, 44
	and	w1, w0, 255
	cset	w2, eq
	cmp	w1, 18
	bhi	.L427
	mov	x0, 32769
	movk	x0, 0x4, lsl 16
	lsr	x0, x0, x1
	mvn	x0, x0
.L415:
	and	w0, w0, 1
	eor	w0, w0, 1
	orr	w0, w2, w0
	cbz	w0, .L416
.L414:
	ldrb	w1, [x20]
	cmp	w23, 1
	bne	.L417
	tbz	x1, 0, .L416
	ldr	w0, [x21]
	tbz	x0, 12, .L418
	adrp	x0, .LC36
	add	x0, x0, :lo12:.LC36
	bl	printf
.L418:
	add	x0, x19, x25, lsl 8
	mov	w1, 239
	cmp	w24, 44
	str	w1, [x0, 2056]
	mov	w1, 137
	ccmp	w24, w1, 4, ne
	mov	w1, 1
	bne	.L419
	str	w1, [x0, 2052]
	mov	w1, 5
.L449:
	str	w1, [x0, 2048]
.L424:
	str	wzr, [x0, 2048]
	str	wzr, [x0, 2048]
	str	wzr, [x0, 2048]
.L416:
	add	x25, x25, 1
	cmp	x25, 4
	bne	.L426
	bl	nandc_wait_flash_ready
	ldr	x25, [sp, 64]
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L427:
	mov	x0, 1
	b	.L415
.L419:
	cmp	w24, 155
	bne	.L421
	str	w1, [x0, 2052]
	mov	w1, 3
	b	.L449
.L421:
	mov	w2, 128
	str	w2, [x0, 2052]
	b	.L449
.L417:
	tbz	x1, 2, .L416
	ldr	w0, [x21]
	tbz	x0, 12, .L422
	adrp	x0, .LC37
	add	x0, x0, :lo12:.LC37
	bl	printf
.L422:
	add	x0, x19, x25, lsl 8
	mov	w1, 239
	cmp	w24, 44
	str	w1, [x0, 2056]
	mov	w1, 137
	ccmp	w24, w1, 4, ne
	bne	.L423
	mov	w1, 1
	str	w1, [x0, 2052]
	mov	w1, 35
	b	.L449
.L423:
	cmp	w24, 155
	bne	.L425
	mov	w1, 1
	str	w1, [x0, 2052]
	mov	w1, 37
	b	.L449
.L425:
	mov	w1, 128
	str	w1, [x0, 2052]
	str	wzr, [x0, 2048]
	b	.L424
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
	bl	nandc_de_cs.constprop.31
	ldrb	w2, [x8]
	sub	w0, w2, #1
	and	w0, w0, 255
	cmp	w0, 253
	bhi	.L453
	ldrb	w7, [x8, 5]
	add	w1, w10, 1
	ldrb	w6, [x8, 4]
	adrp	x0, .LC38
	ldrb	w5, [x8, 3]
	add	x0, x0, :lo12:.LC38
	ldrb	w4, [x8, 2]
	ldrb	w3, [x8, 1]
	ldp	x29, x30, [sp], 16
	b	printf
.L453:
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
	adrp	x0, .LC39
	add	x0, x0, :lo12:.LC39
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
.L459:
	ldr	w1, [x19, 2048]
	strb	w1, [x21, x0]
	add	x0, x0, 1
	cmp	x0, 16384
	bne	.L459
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
	b	nandc_de_cs.constprop.31
	.size	flash_read_otp_data, .-flash_read_otp_data
	.section	.text.sandisk_prog_test_bad_block,"ax",@progbits
	.align	2
	.global	sandisk_prog_test_bad_block
	.type	sandisk_prog_test_bad_block, %function
sandisk_prog_test_bad_block:
	stp	x29, x30, [sp, -48]!
	mov	w4, w1
	adrp	x1, .LANCHOR13
	and	x2, x0, 255
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR32
	ldr	x19, [x1, #:lo12:.LANCHOR13]
	add	x1, x20, :lo12:.LANCHOR32
	str	x21, [sp, 32]
	mov	x0, x2
	add	x2, x2, 8
	ldrb	w1, [x1, 29]
	add	x2, x19, x2, lsl 8
	cbz	w1, .L463
.L477:
	ubfiz	x0, x0, 8, 8
	str	w1, [x2, 8]
	add	x19, x19, x0
	mov	w0, 128
	str	w0, [x19, 2056]
	and	w0, w4, 255
	str	wzr, [x19, 2052]
	str	wzr, [x19, 2052]
	str	w0, [x19, 2052]
	lsr	w0, w4, 8
	str	w0, [x19, 2052]
	lsr	w0, w4, 16
	str	w0, [x19, 2052]
	mov	w0, 16
	str	w0, [x19, 2056]
	bl	nandc_wait_flash_ready
	mov	w0, 112
	str	w0, [x19, 2056]
	mov	w0, 80
	bl	timer_delay_ns
	ldr	w2, [x19, 2048]
	mov	w0, 5
	ands	w21, w2, w0
	beq	.L465
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L465
	adrp	x0, .LC40
	mov	w1, w4
	add	x0, x0, :lo12:.LC40
	bl	printf
.L465:
	add	x20, x20, :lo12:.LANCHOR32
	ldrb	w0, [x20, 30]
	cbz	w0, .L462
	str	w0, [x19, 2056]
.L462:
	mov	w0, w21
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L463:
	mov	w1, 162
	b	.L477
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
	bne	.L481
	ldr	x1, [x1, #:lo12:.LANCHOR13]
	cmp	w0, 70
	ldr	w2, [sp, 8]
	str	w2, [x1, 16]
	beq	.L487
	cmp	w0, 60
	beq	.L488
	cmp	w0, 40
	cset	w0, eq
	add	w0, w0, 1
.L482:
	str	wzr, [sp]
	ldr	w2, [sp]
	bfi	w2, w0, 25, 3
	str	w2, [sp]
	ldr	w0, [sp]
	orr	w0, w0, 1
	str	w0, [sp]
	ldr	w0, [sp]
	str	w0, [x1, 32]
.L480:
	add	sp, sp, 16
	ret
.L487:
	mov	w0, 0
	b	.L482
.L488:
	mov	w0, 3
	b	.L482
.L481:
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
	bne	.L484
.L491:
	ldr	w0, [sp]
	and	w0, w0, -17
	b	.L492
.L484:
	cmp	w0, 24
	bne	.L486
	ldr	w0, [sp]
	orr	w0, w0, 16
.L492:
	str	w0, [sp]
	b	.L485
.L486:
	ldr	w1, [sp]
	cmp	w0, 40
	orr	w1, w1, 262144
	str	w1, [sp]
	ldr	w1, [sp]
	orr	w1, w1, 16
	str	w1, [sp]
	beq	.L491
.L485:
	ldr	w0, [sp]
	orr	w0, w0, 1
	str	w0, [sp]
	ldr	w0, [sp]
	str	w0, [x2, 12]
	b	.L480
	.size	nandc_bch_sel, .-nandc_bch_sel
	.section	.text.zftl_nandc_get_irq_status,"ax",@progbits
	.align	2
	.global	zftl_nandc_get_irq_status
	.type	zftl_nandc_get_irq_status, %function
zftl_nandc_get_irq_status:
	adrp	x1, .LANCHOR28
	ldrb	w1, [x1, #:lo12:.LANCHOR28]
	cmp	w1, 9
	bne	.L494
	ldr	w0, [x0, 296]
	ret
.L494:
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
	bne	.L500
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
	cbz	w0, .L501
	adrp	x0, .LANCHOR48
	ldrb	w0, [x0, #:lo12:.LANCHOR48]
	cbz	w0, .L501
	ldr	w0, [x29, 56]
	orr	w0, w0, 512
	str	w0, [x29, 56]
.L501:
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
.L499:
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 80
	ret
.L500:
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
	cbz	w20, .L503
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
.L505:
	add	w7, w5, w0
	cmp	x3, x1
	bne	.L506
.L507:
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
	b	.L499
.L506:
	ldrh	w10, [x3]
	and	x0, x0, 4294967292
	ldrh	w6, [x3, 2]
	add	x3, x3, 4
	orr	x6, x10, x6, lsl 16
	str	w6, [x8, x0]
	mov	w0, w7
	b	.L505
.L503:
	ldr	x0, [x4, #:lo12:.LANCHOR49]
	str	w6, [x0]
	b	.L507
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
	bne	.L518
	str	w0, [x1, 520]
	ret
.L518:
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
	cbz	w0, .L523
	adrp	x0, .LANCHOR19
	ldrb	w0, [x0, #:lo12:.LANCHOR19]
	cbnz	w0, .L523
	adrp	x0, .LANCHOR28
	ldrb	w0, [x0, #:lo12:.LANCHOR28]
	cmp	w0, 9
	beq	.L523
	mov	w0, 0
	bl	zftl_flash_exit_slc_mode
.L523:
	adrp	x19, .LANCHOR21
	mov	w0, 0
	bl	hynix_reconfig_rr_para
	ldrb	w0, [x19, #:lo12:.LANCHOR21]
	cbz	w0, .L524
	adrp	x0, .LANCHOR45
	ldrb	w0, [x0, #:lo12:.LANCHOR45]
	tbz	x0, 0, .L524
	mov	w0, 1
	bl	flash_set_interface_mode
	mov	w0, 1
	bl	nandc_set_if_mode
	strb	wzr, [x19, #:lo12:.LANCHOR21]
.L524:
	adrp	x3, .LANCHOR48
	ldrb	w0, [x3, #:lo12:.LANCHOR48]
	cbz	w0, .L525
	mov	w0, 0
	strb	wzr, [x3, #:lo12:.LANCHOR48]
	bl	nandc_set_seed
	mov	w0, 1
	strb	w0, [x3, #:lo12:.LANCHOR48]
.L525:
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
.L545:
	and	w3, w2, 255
	strb	wzr, [x1, 2]
	add	w4, w3, 1
	strb	w3, [x1, 1]
	strb	w4, [x1]
	add	w2, w2, 1
	str	xzr, [x1, 16]
	cmp	w2, 32
	add	x1, x1, 64
	bne	.L545
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
	bne	.L553
	ldrb	w0, [x20, 1]
	cmp	w0, 255
	bne	.L549
	adrp	x1, .LANCHOR55
	adrp	x0, .LC0
	mov	w2, 74
	add	x1, x1, :lo12:.LANCHOR55
	add	x0, x0, :lo12:.LC0
	bl	printf
.L549:
	ldrb	w0, [x20, 1]
	strb	w0, [x19]
.L547:
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L553:
	adrp	x0, .LANCHOR52
	add	x2, x0, :lo12:.LANCHOR52
	mov	x19, x0
.L554:
	sbfiz	x0, x1, 6, 32
	mov	w21, w1
	ldrb	w1, [x2, x0]
	cmp	w1, 255
	bne	.L554
	ldrb	w0, [x20, 1]
	cmp	w0, 255
	bne	.L551
	adrp	x1, .LANCHOR55
	adrp	x0, .LC0
	mov	w2, 81
	add	x1, x1, :lo12:.LANCHOR55
	add	x0, x0, :lo12:.LC0
	bl	printf
.L551:
	add	x0, x19, :lo12:.LANCHOR52
	sbfiz	x21, x21, 6, 32
	ldrb	w1, [x20, 1]
	strb	w1, [x0, x21]
	b	.L547
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
	cbz	w1, .L559
	ldr	w1, [x0, 36]
	cmn	w1, #1
	beq	.L559
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
.L559:
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
	cbz	w0, .L572
.L575:
	adrp	x2, .LANCHOR53
	adrp	x1, .LANCHOR52
	add	x0, x1, :lo12:.LANCHOR52
	ldrb	w3, [x2, #:lo12:.LANCHOR53]
	ubfiz	x4, x3, 6, 8
	add	x0, x0, x4
	mov	x4, x2
	cbz	w20, .L573
.L574:
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
	b	.L571
.L572:
	mov	w2, 121
	adrp	x1, .LANCHOR57
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR57
	add	x0, x0, :lo12:.LC0
	bl	printf
	ldrb	w0, [x19, #:lo12:.LANCHOR54]
	cbnz	w0, .L575
.L577:
	mov	x0, 0
.L571:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L573:
	ldrb	w2, [x19, #:lo12:.LANCHOR54]
	cmp	w2, 1
	bne	.L574
	b	.L577
	.size	buf_alloc, .-buf_alloc
	.section	.text.buf_remove_buf,"ax",@progbits
	.align	2
	.global	buf_remove_buf
	.type	buf_remove_buf, %function
buf_remove_buf:
	ldrb	w4, [x1, 1]
	ldrb	w2, [x0]
	cmp	w4, w2
	bne	.L585
	ldrb	w1, [x1]
	strb	w1, [x0]
.L589:
	mov	w0, 1
	ret
.L586:
	mov	w3, w2
	sbfiz	x2, x2, 6, 32
	ldrb	w2, [x0, x2]
	cmp	w4, w2
	bne	.L587
	sbfiz	x3, x3, 6, 32
	ldrb	w2, [x1]
	strb	w2, [x0, x3]
	mov	w0, -1
	strb	w0, [x1]
	b	.L589
.L585:
	adrp	x0, .LANCHOR52
	add	x0, x0, :lo12:.LANCHOR52
.L587:
	cmp	w2, 255
	bne	.L586
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
	cbnz	w0, .L591
	adrp	x1, .LANCHOR58
	adrp	x0, .LC0
	mov	w2, 172
	add	x1, x1, :lo12:.LANCHOR58
	add	x0, x0, :lo12:.LC0
	bl	printf
.L591:
	ldrb	w0, [x19, #:lo12:.LANCHOR54]
	cbz	w0, .L590
	mov	x1, x20
	adrp	x0, .LANCHOR53
	add	x0, x0, :lo12:.LANCHOR53
	bl	buf_remove_buf
	cmp	w0, 1
	bne	.L590
	ldrb	w0, [x19, #:lo12:.LANCHOR54]
	sub	w0, w0, #1
	strb	w0, [x19, #:lo12:.LANCHOR54]
	ldrb	w0, [x20, 2]
	orr	w0, w0, 1
	strb	w0, [x20, 2]
.L590:
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
	adrp	x0, .LC41
	add	x0, x0, :lo12:.LC41
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
	cbnz	w0, .L603
	adrp	x0, .LANCHOR61
	ldr	w0, [x0, #:lo12:.LANCHOR61]
	ret
.L603:
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
	.section	.text.ftl_scan_all_data,"ax",@progbits
	.align	2
	.global	ftl_scan_all_data
	.type	ftl_scan_all_data, %function
ftl_scan_all_data:
	ret
	.size	ftl_scan_all_data, .-ftl_scan_all_data
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
	tbz	x0, 8, .L613
	adrp	x1, .LANCHOR9
	uxtw	x0, w19
	mov	w3, w23
	ldr	x2, [x1, #:lo12:.LANCHOR9]
	adrp	x1, .LANCHOR7
	ldr	x1, [x1, #:lo12:.LANCHOR7]
	ldrh	w5, [x2, x0, lsl 1]
	mov	w2, w22
	add	x1, x1, x0, lsl 2
	adrp	x0, .LC42
	add	x0, x0, :lo12:.LC42
	ldrb	w4, [x1, 2]
	adrp	x1, .LANCHOR63
	ldrh	w7, [x1, #:lo12:.LANCHOR63]
	adrp	x1, .LANCHOR64+56
	ubfx	x4, x4, 5, 3
	ldrh	w6, [x1, #:lo12:.LANCHOR64+56]
	mov	w1, w19
	bl	printf
.L613:
	adrp	x0, .LANCHOR6
	mov	x20, x0
	ldrh	w1, [x0, #:lo12:.LANCHOR6]
	cmp	w1, w19
	bhi	.L614
	adrp	x1, .LANCHOR65
	adrp	x0, .LC0
	mov	w2, 454
	add	x1, x1, :lo12:.LANCHOR65
	add	x0, x0, :lo12:.LC0
	bl	printf
.L614:
	ldrh	w0, [x20, #:lo12:.LANCHOR6]
	cmp	w0, w19
	bhi	.L615
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	tbz	x0, 10, .L637
	adrp	x0, .LC43
	mov	w3, w23
	mov	w2, w22
	mov	w1, w19
	add	x0, x0, :lo12:.LC43
	bl	printf
.L637:
	mov	w0, 0
	b	.L612
.L615:
	adrp	x1, .LANCHOR9
	uxtw	x0, w19
	ldr	x1, [x1, #:lo12:.LANCHOR9]
	ldrh	w3, [x1, x0, lsl 1]
	adrp	x1, .LANCHOR7
	ldr	x1, [x1, #:lo12:.LANCHOR7]
	add	x0, x1, x0, lsl 2
	ldrb	w2, [x0, 2]
	tst	w2, 224
	bne	.L617
	cbz	w3, .L637
	mov	w2, 461
	adrp	x1, .LANCHOR65
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR65
	add	x0, x0, :lo12:.LC0
	bl	printf
	b	.L637
.L617:
	adrp	x0, .LANCHOR64
	add	x1, x0, :lo12:.LANCHOR64
	ldrh	w0, [x0, #:lo12:.LANCHOR64]
	cmp	w0, w19
	beq	.L637
	adrp	x24, .LANCHOR10
	ldr	x0, [x24, #:lo12:.LANCHOR10]
	ldrh	w4, [x0, 48]
	cmp	w4, w19
	beq	.L637
	ldrh	w4, [x0, 16]
	cmp	w4, w19
	beq	.L637
	ldrh	w4, [x0, 80]
	cmp	w4, w19
	beq	.L637
	ldrh	w5, [x1, 56]
	add	x1, x1, 58
	mov	w4, 0
.L618:
	cmp	w4, w5
	bcc	.L619
	cbnz	w22, .L623
	adrp	x1, .LANCHOR66
	ldrh	w6, [x1, #:lo12:.LANCHOR66]
	cmp	w19, w6
	beq	.L637
	adrp	x4, .LANCHOR67
	add	x4, x4, :lo12:.LANCHOR67
	mov	x1, 0
.L622:
	ldrh	w7, [x1, x4]
	cmp	w19, w7
	bne	.L621
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L637
	mov	w5, w6
	mov	w4, w19
	ubfx	x2, x2, 5, 3
	mov	w1, w19
	adrp	x0, .LC44
	add	x0, x0, :lo12:.LC44
	bl	printf
	b	.L637
.L619:
	ldrh	w6, [x1], 2
	cmp	w6, w19
	beq	.L637
	add	w4, w4, 1
	b	.L618
.L621:
	add	x1, x1, 2
	cmp	x1, 16
	bne	.L622
	ubfiz	x20, x23, 7, 16
	add	x20, x20, 136
	add	x20, x0, x20
.L624:
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L625
	adrp	x0, .LANCHOR63
	mov	w4, w3
	mov	w1, w19
	ubfx	x3, x2, 5, 3
	ldrh	w6, [x0, #:lo12:.LANCHOR63]
	mov	w2, w22
	adrp	x0, .LC45
	add	x0, x0, :lo12:.LC45
	bl	printf
.L625:
	mov	x0, x20
	add	x1, x20, 128
	mov	w2, 65535
.L628:
	ldrh	w3, [x0]
	cmp	w3, w2
	bne	.L626
	strh	w19, [x0]
	cbz	w22, .L627
	ldr	x1, [x24, #:lo12:.LANCHOR10]
	ldrh	w0, [x1, 124]
	add	w0, w0, 1
	strh	w0, [x1, 124]
.L647:
	mov	w0, 1
.L612:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L623:
	add	x20, x0, 392
	b	.L624
.L627:
	ldr	x0, [x24, #:lo12:.LANCHOR10]
	add	x23, x0, x23, uxth 1
	ldrh	w0, [x23, 120]
	add	w0, w0, 1
	strh	w0, [x23, 120]
	b	.L647
.L626:
	add	x0, x0, 2
	cmp	x1, x0
	bne	.L628
	b	.L647
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
	adrp	x0, .LC46
	udiv	w19, w19, w1
	mov	w2, w22
	ldr	w1, [x21, 584]
	add	x0, x0, :lo12:.LC46
	and	w19, w19, 65535
	bl	printf
	mov	w1, w23
	mov	w2, 0
	mov	w0, w19
	bl	gc_add_sblk
	ldr	w0, [x21, 584]
	mov	w1, 0
.L649:
	cmp	w1, w0
	bcc	.L651
	cmp	w0, 5
	bhi	.L650
	add	x20, x20, :lo12:.LANCHOR64
	add	w1, w0, 1
	str	w1, [x20, 584]
	add	x20, x20, x0, uxtw 1
	strh	w22, [x20, 588]
.L650:
	mov	w0, 0
	ldr	x23, [sp, 48]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L651:
	add	x2, x21, x1, sxtw 1
	ldrh	w2, [x2, 588]
	cmp	w2, w22
	beq	.L650
	add	w1, w1, 1
	and	w1, w1, 65535
	b	.L649
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
.L655:
	ldrb	w20, [x23]
	cmp	w20, 255
	bne	.L668
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L668:
	lsl	x1, x20, 6
	add	x0, x24, :lo12:.LANCHOR52
	add	x2, x0, x1
	ldrb	w0, [x0, x1]
	ldr	w1, [x2, 52]
	strb	w0, [x23]
	ldrh	w25, [x2, 48]
	cbz	w1, .L656
	ldr	w2, [x2, 40]
	adrp	x0, .LANCHOR64
	add	x0, x0, :lo12:.LANCHOR64
	mov	w3, 1
	str	w2, [x0, 580]
	strh	w3, [x0, 576]
	adrp	x0, .LC47
	add	x0, x0, :lo12:.LC47
	bl	printf
	adrp	x1, .LANCHOR72
	adrp	x0, .LC0
	mov	w2, 809
	add	x1, x1, :lo12:.LANCHOR72
	add	x0, x0, :lo12:.LC0
	bl	printf
.L656:
	adrp	x27, .LANCHOR73
	ldrb	w0, [x27, #:lo12:.LANCHOR73]
	cmp	w0, 3
	bne	.L657
	adrp	x0, .LANCHOR35
	ldrb	w0, [x0, #:lo12:.LANCHOR35]
	cbnz	w0, .L657
	adrp	x0, .LANCHOR10
	ldr	x0, [x0, #:lo12:.LANCHOR10]
	ldrb	w19, [x0, 89]
	add	w19, w19, w19, lsl 1
	and	w19, w19, 1023
.L658:
	adrp	x0, .LANCHOR14
	adrp	x28, .LANCHOR76
	and	x21, x25, 65535
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L659
	ldr	x1, [x28, #:lo12:.LANCHOR76]
	add	x0, x22, x20, lsl 6
	ldrh	w3, [x0, 48]
	ldrb	w4, [x1, x21]
	mov	w1, w25
	ldrb	w2, [x0, 1]
	adrp	x0, .LC48
	add	x0, x0, :lo12:.LC48
	bl	printf
.L659:
	ldr	x1, [x28, #:lo12:.LANCHOR76]
	add	x0, x22, x20, lsl 6
	mov	x26, x21
	ldrb	w0, [x0, 1]
	ldrb	w1, [x1, x21]
	cmp	w1, w0
	beq	.L660
	adrp	x1, .LANCHOR72
	adrp	x0, .LC0
	mov	w2, 818
	add	x1, x1, :lo12:.LANCHOR72
	add	x0, x0, :lo12:.LC0
	bl	printf
.L660:
	add	x20, x22, x20, lsl 6
	ldrb	w0, [x20, 61]
	cmp	w0, 3
	beq	.L661
	ldrb	w0, [x27, #:lo12:.LANCHOR73]
	cmp	w0, 3
	bne	.L661
	adrp	x0, .LANCHOR77
	ldrb	w0, [x0, #:lo12:.LANCHOR77]
	cbnz	w0, .L661
	adrp	x0, .LANCHOR35
	ldrb	w0, [x0, #:lo12:.LANCHOR35]
	cbnz	w0, .L661
	adrp	x0, .LANCHOR74
	ldrb	w0, [x0, #:lo12:.LANCHOR74]
	cbz	w0, .L662
	adrp	x0, .LANCHOR75
	ldrb	w0, [x0, #:lo12:.LANCHOR75]
	cbnz	w0, .L661
.L662:
	ldr	x1, [x28, #:lo12:.LANCHOR76]
	mov	x0, 0
	add	x21, x1, x21
.L663:
	cmp	w19, w0, uxth
	bls	.L655
	ldrb	w1, [x21, x0]
	add	x0, x0, 1
	add	x1, x22, x1, lsl 6
	strb	wzr, [x1, 61]
	b	.L663
.L657:
	adrp	x0, .LANCHOR74
	ldrb	w0, [x0, #:lo12:.LANCHOR74]
	cbz	w0, .L669
	adrp	x0, .LANCHOR75
	ldrb	w0, [x0, #:lo12:.LANCHOR75]
	cmp	w0, 0
	cset	w19, ne
	add	w19, w19, 1
	b	.L658
.L669:
	mov	w19, 1
	b	.L658
.L661:
	adrp	x20, .LANCHOR64
	add	x20, x20, :lo12:.LANCHOR64
	add	x19, x21, x19, uxth
	mov	w21, -1
	strh	w25, [x20, 572]
.L664:
	cmp	x19, x26
	beq	.L655
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
	b	.L664
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
	cbz	w0, .L685
	add	x1, x2, 392
	mov	w4, 1
.L686:
	add	x5, x1, 128
	mov	w6, 65535
.L690:
	ldrh	w0, [x1]
	cmp	w0, w6
	beq	.L688
	mov	w5, -1
	strh	w5, [x1]
	cbz	w4, .L689
	ldrh	w1, [x2, 124]
	sub	w1, w1, #1
	strh	w1, [x2, 124]
	ret
.L685:
	add	x0, x2, x3, sxtw 1
	ldrh	w0, [x0, 120]
	cbz	w0, .L691
	ubfiz	x1, x3, 7, 8
	mov	w4, 0
	add	x1, x1, 136
	add	x1, x2, x1
	b	.L686
.L689:
	add	x2, x2, x3, uxtb 1
	ldrh	w1, [x2, 120]
	sub	w1, w1, #1
	strh	w1, [x2, 120]
	ret
.L688:
	add	x1, x1, 2
	cmp	x1, x5
	bne	.L690
	ret
.L691:
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
	cbz	w1, .L700
	adrp	x1, .LANCHOR54
	ldrb	w1, [x1, #:lo12:.LANCHOR54]
	cmp	w1, 1
	bhi	.L700
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
.L695:
	cmp	w19, w1
	bcc	.L698
.L700:
	mov	w0, 0
	b	.L693
.L698:
	uxtw	x22, w19
	ldrb	w2, [x4, x22]
	cmp	w2, 255
	beq	.L696
	sbfiz	x3, x2, 6, 32
	add	x3, x0, x3
	ldrb	w3, [x3, 61]
	cbnz	w3, .L696
	ubfiz	x2, x2, 6, 8
	add	x0, x0, x2
	bl	zbuf_free
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L697
	ldr	x0, [x21, #:lo12:.LANCHOR76]
	mov	w1, w19
	ldrb	w2, [x0, x22]
	adrp	x0, .LC49
	add	x0, x0, :lo12:.LC49
	bl	printf
.L697:
	ldr	x0, [x21, #:lo12:.LANCHOR76]
	add	x20, x20, :lo12:.LANCHOR64
	mov	w1, -1
	strb	w1, [x0, x22]
	ldrb	w0, [x20, 7]
	sub	w0, w0, #1
	strb	w0, [x20, 7]
	mov	w0, 1
.L693:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L696:
	add	w19, w19, 1
	b	.L695
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
	adrp	x0, .LC50
	add	x0, x0, :lo12:.LC50
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
	bne	.L710
	mov	w1, w0
	adrp	x0, .LANCHOR82
	ldr	x0, [x0, #:lo12:.LANCHOR82]
.L712:
	b	_list_get_gc_head_node.isra.2
.L710:
	cmp	w1, 2
	bne	.L711
	b	zftl_get_gc_node.part.9
.L711:
	mov	w1, w0
	adrp	x0, .LANCHOR83
	ldr	x0, [x0, #:lo12:.LANCHOR83]
	b	.L712
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
	cbz	w19, .L714
	mov	w0, w19
.L713:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L714:
	and	w20, w2, 255
	cbnz	w21, .L716
	adrp	x24, .LANCHOR84
	adrp	x26, .LANCHOR14
	adrp	x27, .LC51
	and	w22, w20, 65535
	add	x26, x26, :lo12:.LANCHOR14
	add	x27, x27, :lo12:.LC51
	strh	wzr, [x24, #:lo12:.LANCHOR84]
	mov	w23, 0
	mov	w25, 0
.L717:
	cmp	w25, w22
	bcs	.L722
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
	beq	.L718
	ldr	w0, [x26]
	adrp	x6, .LANCHOR9
	uxtw	x4, w1
	tbz	x0, 8, .L719
	ldr	x0, [x6, #:lo12:.LANCHOR9]
	stp	x6, x4, [x29, 96]
	ldrh	w3, [x0, x4, lsl 1]
	mov	x0, x27
	bl	printf
	ldp	x6, x4, [x29, 96]
.L719:
	ldr	x0, [x6, #:lo12:.LANCHOR9]
	ldrh	w1, [x0, x4, lsl 1]
	adrp	x0, .LANCHOR63
	ldrh	w0, [x0, #:lo12:.LANCHOR63]
	cmp	w1, w0
	bcs	.L720
	mov	w2, 0
	mov	w1, 0
	mov	w0, w28
	bl	gc_add_sblk
	cbz	w0, .L721
	add	w5, w23, 1
	and	w23, w5, 65535
	cmp	w22, w23
	bcs	.L721
.L722:
	ldr	x0, [x29, 112]
	tbz	x0, 1, .L724
	adrp	x25, .LANCHOR86
	adrp	x24, .LANCHOR85
	add	x27, x25, :lo12:.LANCHOR86
	add	x24, x24, :lo12:.LANCHOR85
	mov	w28, 0
	mov	w26, 65535
.L725:
	cmp	w28, w22
	beq	.L729
	ldrh	w6, [x24]
	mov	w1, 5
	mov	w0, w6
	bl	zftl_get_gc_node
	add	w6, w6, 1
	strh	w6, [x24]
	and	w1, w0, 65535
	cmp	w1, w26
	beq	.L726
	adrp	x2, .LANCHOR9
	ubfiz	x1, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR9]
	ldrh	w2, [x2, x1]
	ldrh	w1, [x27]
	cmp	w2, w1
	bcs	.L726
	mov	w2, 0
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L728
	add	w5, w23, 1
	and	w23, w5, 65535
	cmp	w22, w23
	bcs	.L728
.L729:
	cmp	w23, w22
	adrp	x0, .LANCHOR87
	bcs	.L731
	ldrh	w1, [x0, #:lo12:.LANCHOR87]
	adrp	x3, .LANCHOR80
	adrp	x0, .LANCHOR79
	ldrh	w2, [x25, #:lo12:.LANCHOR86]
	ldrb	w3, [x3, #:lo12:.LANCHOR80]
	ldrh	w0, [x0, #:lo12:.LANCHOR79]
	mul	w0, w0, w3
	sub	w0, w0, w1, lsr 2
	cmp	w2, w0
	bge	.L724
	add	w1, w2, w1, lsr 3
	strh	w1, [x25, #:lo12:.LANCHOR86]
.L724:
	ldr	x0, [x29, 112]
	tbz	x0, 0, .L732
	cmp	w23, w22
	bcs	.L732
	adrp	x24, .LANCHOR88
	add	x24, x24, :lo12:.LANCHOR88
	mov	w25, 65535
.L737:
	ldrh	w6, [x24]
	mov	w0, w6
	bl	zftl_get_gc_node.part.9
	add	w6, w6, 1
	strh	w6, [x24]
	cmp	w25, w0, uxth
	beq	.L733
	mov	w2, 0
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L734
	add	w5, w23, 1
	and	w23, w5, 65535
	cmp	w22, w23
	bhi	.L734
.L735:
	adrp	x0, .LANCHOR87
	adrp	x1, .LANCHOR63
	ldrh	w0, [x0, #:lo12:.LANCHOR87]
	ldrh	w2, [x1, #:lo12:.LANCHOR63]
	cmp	w2, w0, lsr 1
	bls	.L732
	sub	w0, w2, w0, lsr 3
	b	.L812
.L720:
	strh	wzr, [x24, #:lo12:.LANCHOR84]
	b	.L722
.L718:
	strh	wzr, [x7]
	b	.L722
.L721:
	add	w25, w25, 1
	and	w25, w25, 65535
	b	.L717
.L726:
	strh	wzr, [x24]
	b	.L729
.L728:
	add	w28, w28, 1
	and	w28, w28, 65535
	b	.L725
.L731:
	ldrh	w1, [x25, #:lo12:.LANCHOR86]
	ldrh	w0, [x0, #:lo12:.LANCHOR87]
	cmp	w1, w0
	bls	.L724
	sub	w0, w1, w0, lsr 3
	strh	w0, [x25, #:lo12:.LANCHOR86]
	b	.L724
.L733:
	strh	wzr, [x24]
.L736:
	cmp	w23, w22
	bcs	.L735
	adrp	x1, .LANCHOR63
	adrp	x0, .LANCHOR87
	ldrh	w2, [x1, #:lo12:.LANCHOR63]
	ldrh	w0, [x0, #:lo12:.LANCHOR87]
	cmp	w2, w0
	bcs	.L732
	add	w0, w2, w0, lsr 3
.L812:
	strh	w0, [x1, #:lo12:.LANCHOR63]
.L732:
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L759
	ldr	w2, [x29, 112]
	adrp	x0, .LC52
	mov	w4, w20
	mov	w3, w23
	mov	w1, w21
	add	x0, x0, :lo12:.LC52
	bl	printf
.L759:
	mov	w0, w23
	b	.L713
.L734:
	add	w19, w19, 1
	and	w19, w19, 65535
	cmp	w22, w19
	bne	.L737
	b	.L736
.L716:
	adrp	x0, .LANCHOR64+574
	strh	wzr, [x0, #:lo12:.LANCHOR64+574]
	adrp	x0, .LANCHOR89
	strh	wzr, [x0, #:lo12:.LANCHOR89]
	ldr	w0, [x29, 112]
	and	w0, w0, 1
	str	w0, [x29, 104]
	ldr	x0, [x29, 112]
	tbz	x0, 0, .L762
	adrp	x1, .LANCHOR91
	adrp	x25, .LANCHOR90
	str	x1, [x29, 96]
	adrp	x26, .LANCHOR92
	ldrh	w0, [x25, #:lo12:.LANCHOR90]
	ldrh	w2, [x1, #:lo12:.LANCHOR91]
	cmp	w0, w2, lsr 2
	bcc	.L739
	ldrh	w1, [x26, #:lo12:.LANCHOR92]
	cmp	w1, w0
	bls	.L763
.L739:
	ldrh	w0, [x26, #:lo12:.LANCHOR92]
	adrp	x22, .LANCHOR88
	lsr	w0, w0, 2
	strh	w0, [x22, #:lo12:.LANCHOR88]
	mov	w0, 0
	bl	zftl_get_gc_node.part.9
	and	w1, w0, 65535
	mov	w2, 65535
	cmp	w1, w2
	beq	.L765
	adrp	x2, .LANCHOR9
	ubfiz	x1, x1, 1, 16
	ldr	x3, [x2, #:lo12:.LANCHOR9]
	adrp	x2, .LANCHOR87
	ldrh	w2, [x2, #:lo12:.LANCHOR87]
	ldrh	w1, [x3, x1]
	cmp	w1, w2, lsr 2
	bcs	.L765
	strh	wzr, [x22, #:lo12:.LANCHOR88]
	mov	w2, w21
	mov	w1, 0
	bl	gc_add_sblk
	cmp	w0, 0
	cset	w23, ne
.L741:
	add	x22, x22, :lo12:.LANCHOR88
	and	w28, w20, 65535
	mov	w24, 64
	mov	w27, 65535
.L743:
	ldrh	w6, [x22]
	mov	w0, w6
	bl	zftl_get_gc_node.part.9
	add	w6, w6, 1
	strh	w6, [x22]
	cmp	w27, w0, uxth
	beq	.L740
	mov	w2, w21
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L742
	add	w5, w23, 1
	and	w23, w5, 65535
	cmp	w23, w28
	bcs	.L740
.L742:
	sub	w24, w24, #1
	ands	w24, w24, 65535
	bne	.L743
.L740:
	ldr	x0, [x29, 96]
	ldrh	w1, [x25, #:lo12:.LANCHOR90]
	ldrh	w0, [x0, #:lo12:.LANCHOR91]
	cmp	w1, w0, lsr 3
	bhi	.L760
	ldrh	w0, [x26, #:lo12:.LANCHOR92]
	add	w0, w0, 8
	cmp	w1, w0
	ble	.L738
.L760:
	adrp	x24, .LANCHOR84
	and	w26, w20, 65535
	mov	w22, 64
	mov	w25, 65535
	strh	wzr, [x24, #:lo12:.LANCHOR84]
	add	x24, x24, :lo12:.LANCHOR84
.L745:
	ldrh	w6, [x24]
	mov	w1, 3
	mov	w0, w6
	bl	zftl_get_gc_node
	add	w6, w6, 1
	strh	w6, [x24]
	cmp	w25, w0, uxth
	beq	.L738
	mov	w2, w21
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L744
	add	w5, w23, 1
	and	w23, w5, 65535
	cmp	w23, w26
	bcs	.L738
.L744:
	sub	w22, w22, #1
	ands	w22, w22, 65535
	bne	.L745
.L738:
	ldr	x0, [x29, 112]
	tbz	x0, 1, .L746
	adrp	x24, .LANCHOR85
	adrp	x28, .LANCHOR93
	adrp	x25, .LANCHOR80
	add	x26, x24, :lo12:.LANCHOR85
	add	x27, x28, :lo12:.LANCHOR93
	add	x25, x25, :lo12:.LANCHOR80
	strh	wzr, [x24, #:lo12:.LANCHOR85]
	mov	w22, 64
.L751:
	ldrh	w6, [x26]
	mov	w1, 5
	mov	w0, w6
	bl	zftl_get_gc_node
	add	w6, w6, 1
	strh	w6, [x26]
	and	w1, w0, 65535
	mov	w2, 65535
	cmp	w1, w2
	beq	.L747
	cmp	w20, 1
	bne	.L748
	adrp	x3, .LANCHOR79
	ldrb	w2, [x25]
	ldrh	w3, [x3, #:lo12:.LANCHOR79]
	mul	w3, w2, w3
	adrp	x2, .LANCHOR87
	ldrh	w2, [x2, #:lo12:.LANCHOR87]
	sub	w2, w3, w2, lsr 3
	strh	w2, [x27]
.L748:
	adrp	x2, .LANCHOR9
	ubfiz	x1, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR9]
	ldrh	w2, [x2, x1]
	ldrh	w1, [x27]
	cmp	w2, w1
	bcs	.L749
	mov	w2, w21
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L750
	add	w5, w23, 1
	add	w19, w19, 1
	and	w23, w5, 65535
	and	w19, w19, 65535
	cmp	w23, w20
	bcc	.L750
.L747:
	cmp	w23, w20
	adrp	x0, .LANCHOR87
	adrp	x3, .LANCHOR80
	bcc	.L752
	cbnz	w19, .L753
	adrp	x1, .LANCHOR94
	ldrh	w2, [x1, #:lo12:.LANCHOR94]
	adrp	x1, .LANCHOR95
	ldrh	w1, [x1, #:lo12:.LANCHOR95]
	cmp	w2, w1
	bls	.L753
.L752:
	ldrh	w2, [x0, #:lo12:.LANCHOR87]
	adrp	x0, .LANCHOR79
	ldrb	w3, [x3, #:lo12:.LANCHOR80]
	ldrh	w0, [x0, #:lo12:.LANCHOR79]
	ldrh	w1, [x28, #:lo12:.LANCHOR93]
	lsr	w2, w2, 3
	mul	w0, w0, w3
	sub	w0, w0, w2
	cmp	w1, w0
	bge	.L746
	add	w1, w1, w2
	strh	w1, [x28, #:lo12:.LANCHOR93]
.L746:
	ldr	w0, [x29, 104]
	cbz	w0, .L732
	adrp	x25, .LANCHOR84
	adrp	x22, .LANCHOR96
	adrp	x26, .LANCHOR91
	adrp	x27, .LANCHOR90
	add	x28, x22, :lo12:.LANCHOR96
	add	x26, x26, :lo12:.LANCHOR91
	add	x27, x27, :lo12:.LANCHOR90
	strh	wzr, [x25, #:lo12:.LANCHOR84]
	mov	w24, 64
.L757:
	ldrh	w6, [x25, #:lo12:.LANCHOR84]
	mov	w1, 3
	mov	w0, w6
	bl	zftl_get_gc_node
	add	w6, w6, 1
	strh	w6, [x25, #:lo12:.LANCHOR84]
	and	w1, w0, 65535
	mov	w2, 65535
	cmp	w1, w2
	beq	.L754
	adrp	x2, .LANCHOR9
	ubfiz	x1, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR9]
	ldrh	w1, [x2, x1]
	ldrh	w2, [x28]
	cmp	w2, w1
	bls	.L755
	cmp	w1, 2
	bls	.L755
	ldrh	w2, [x26]
	ldrh	w1, [x27]
	cmp	w1, w2, lsr 1
	bls	.L754
.L755:
	mov	w2, w21
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L756
	add	w5, w23, 1
	and	w23, w5, 65535
	cmp	w23, w20
	bcs	.L754
.L756:
	sub	w24, w24, #1
	ands	w24, w24, 65535
	bne	.L757
.L754:
	cmp	w23, w20
	adrp	x0, .LANCHOR87
	bcs	.L758
	ldrh	w0, [x0, #:lo12:.LANCHOR87]
	ldrh	w1, [x22, #:lo12:.LANCHOR96]
	cmp	w1, w0, lsr 1
	bls	.L732
	sub	w0, w1, w0, lsr 3
	strh	w0, [x22, #:lo12:.LANCHOR96]
	b	.L732
.L765:
	mov	w23, 0
	b	.L741
.L762:
	mov	w23, 0
	b	.L738
.L749:
	strh	wzr, [x24, #:lo12:.LANCHOR85]
	b	.L747
.L750:
	sub	w22, w22, #1
	ands	w22, w22, 65535
	bne	.L751
	b	.L747
.L753:
	ldrh	w0, [x0, #:lo12:.LANCHOR87]
	ldrb	w1, [x3, #:lo12:.LANCHOR80]
	ldrh	w2, [x28, #:lo12:.LANCHOR93]
	mul	w1, w1, w0
	cmp	w2, w1
	ble	.L746
	sub	w0, w2, w0, lsr 3
	strh	w0, [x28, #:lo12:.LANCHOR93]
	b	.L746
.L758:
	ldrh	w1, [x0, #:lo12:.LANCHOR87]
	adrp	x0, .LANCHOR80
	ldrh	w2, [x22, #:lo12:.LANCHOR96]
	ldrb	w0, [x0, #:lo12:.LANCHOR80]
	mul	w0, w0, w1
	sub	w0, w0, #32
	cmp	w2, w0
	bge	.L732
	add	w1, w2, w1, lsr 3
	strh	w1, [x22, #:lo12:.LANCHOR96]
	b	.L732
.L763:
	mov	w23, 0
	b	.L740
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
	bne	.L814
	adrp	x2, .LANCHOR97
	adrp	x0, .LANCHOR98
	add	x2, x2, :lo12:.LANCHOR97
	add	x0, x0, :lo12:.LANCHOR98
.L816:
	b	_insert_free_list
.L814:
	cmp	w0, 16
	bne	.L815
	adrp	x2, .LANCHOR99
	adrp	x0, .LANCHOR100
	add	x2, x2, :lo12:.LANCHOR99
	add	x0, x0, :lo12:.LANCHOR100
	b	.L816
.L815:
	adrp	x2, .LANCHOR101
	adrp	x0, .LANCHOR102
	add	x2, x2, :lo12:.LANCHOR101
	add	x0, x0, :lo12:.LANCHOR102
	b	.L816
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
	bne	.L818
	adrp	x2, .LANCHOR92
	adrp	x0, .LANCHOR12
	add	x2, x2, :lo12:.LANCHOR92
	add	x0, x0, :lo12:.LANCHOR12
.L821:
	b	_insert_data_list
.L818:
	cmp	w2, 96
	bne	.L819
	adrp	x2, .LANCHOR90
	adrp	x0, .LANCHOR83
	add	x2, x2, :lo12:.LANCHOR90
	add	x0, x0, :lo12:.LANCHOR83
	b	.L821
.L819:
	cmp	w2, 160
	bne	.L817
	adrp	x2, .LANCHOR94
	adrp	x0, .LANCHOR82
	add	x2, x2, :lo12:.LANCHOR94
	add	x0, x0, :lo12:.LANCHOR82
	b	.L821
.L817:
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
	beq	.L823
	cbnz	w21, .L823
	mov	w1, w19
	adrp	x0, .LC53
	add	x0, x0, :lo12:.LC53
	bl	printf
	ldr	x0, [x20, #:lo12:.LANCHOR10]
	mov	w1, -1
	strh	w1, [x0, 588]
.L824:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L823:
	adrp	x2, .LANCHOR99
	adrp	x20, .LANCHOR101
	ldrh	w0, [x2, #:lo12:.LANCHOR99]
	ldrh	w1, [x20, #:lo12:.LANCHOR101]
	cmp	w0, w1
	bls	.L825
	lsr	w1, w0, 3
	cmp	w21, 0
	adrp	x0, .LANCHOR100
	csel	w1, w1, wzr, ne
	add	x2, x2, :lo12:.LANCHOR99
	add	x0, x0, :lo12:.LANCHOR100
.L839:
	bl	_list_pop_index_node
	and	w19, w0, 65535
	mov	w0, 65535
	cmp	w19, w0
	bne	.L830
	adrp	x0, .LANCHOR97
	ldrh	w5, [x20, #:lo12:.LANCHOR101]
	mov	w2, w22
	mov	w1, w19
	ldrh	w4, [x0, #:lo12:.LANCHOR97]
	adrp	x0, .LANCHOR98
	ldr	x3, [x0, #:lo12:.LANCHOR98]
	adrp	x0, .LC54
	add	x0, x0, :lo12:.LC54
	bl	printf
.L830:
	cbz	w21, .L824
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L824
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
	adrp	x0, .LC55
	ubfx	x3, x2, 3, 2
	and	w5, w5, 2047
	ubfx	x2, x2, 5, 3
	add	x0, x0, :lo12:.LC55
	bl	printf
	b	.L824
.L825:
	cbnz	w21, .L828
	lsr	w1, w1, 2
.L829:
	adrp	x0, .LANCHOR102
	add	x2, x20, :lo12:.LANCHOR101
	add	x0, x0, :lo12:.LANCHOR102
	b	.L839
.L828:
	mov	w1, 7
	mul	w1, w0, w1
	lsr	w1, w1, 3
	b	.L829
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
	bne	.L841
	adrp	x2, .LANCHOR99
	adrp	x0, .LANCHOR101
	ldrh	w3, [x2, #:lo12:.LANCHOR99]
	ldrh	w1, [x0, #:lo12:.LANCHOR101]
	cmp	w3, w1
	bcc	.L842
	adrp	x4, .LANCHOR97
	ldrh	w4, [x4, #:lo12:.LANCHOR97]
	cmp	w4, w3
	bls	.L843
	cbz	w1, .L843
.L842:
	add	x2, x0, :lo12:.LANCHOR101
	lsr	w1, w1, 1
.L862:
	adrp	x0, .LANCHOR102
	add	x0, x0, :lo12:.LANCHOR102
	b	.L861
.L843:
	adrp	x0, .LANCHOR100
	add	x2, x2, :lo12:.LANCHOR99
	add	x0, x0, :lo12:.LANCHOR100
	mov	w1, 0
.L861:
	bl	_list_pop_index_node
	and	w19, w0, 65535
	mov	w0, 65535
	cmp	w19, w0
	bne	.L846
	adrp	x0, .LANCHOR101
	mov	w2, w20
	mov	w1, w19
	ldrh	w5, [x0, #:lo12:.LANCHOR101]
	adrp	x0, .LANCHOR97
	ldrh	w4, [x0, #:lo12:.LANCHOR97]
	adrp	x0, .LANCHOR98
	ldr	x3, [x0, #:lo12:.LANCHOR98]
	adrp	x0, .LC54
	add	x0, x0, :lo12:.LC54
	bl	printf
	b	.L846
.L841:
	adrp	x21, .LANCHOR10
	and	w0, w0, 65535
	ldr	x1, [x21, #:lo12:.LANCHOR10]
	ldrh	w19, [x1, 590]
	mov	w1, 65535
	cmp	w19, w1
	beq	.L845
	cmp	w20, 1
	beq	.L845
	mov	w1, w19
	adrp	x0, .LC56
	add	x0, x0, :lo12:.LC56
	bl	printf
	ldr	x0, [x21, #:lo12:.LANCHOR10]
	mov	w1, -1
	strh	w1, [x0, 590]
.L846:
	mov	w0, w19
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L845:
	adrp	x2, .LANCHOR97
	adrp	x4, .LANCHOR101
	ldrh	w1, [x2, #:lo12:.LANCHOR97]
	ldrh	w3, [x4, #:lo12:.LANCHOR101]
	cmp	w1, w3
	bcc	.L847
	adrp	x5, .LANCHOR99
	ldrh	w5, [x5, #:lo12:.LANCHOR99]
	cmp	w5, w1
	bls	.L848
	cbz	w3, .L848
.L847:
	cmp	w20, 1
	lsr	w3, w3, 1
	csel	w0, w3, w0, eq
	add	x2, x4, :lo12:.LANCHOR101
	mov	w1, w0
	b	.L862
.L848:
	lsr	w1, w1, 1
	cmp	w20, 1
	csel	w0, w1, w0, eq
	add	x2, x2, :lo12:.LANCHOR97
	mov	w1, w0
	adrp	x0, .LANCHOR98
	add	x0, x0, :lo12:.LANCHOR98
	b	.L861
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
	bne	.L864
	adrp	x2, .LANCHOR92
	adrp	x0, .LANCHOR12
	add	x2, x2, :lo12:.LANCHOR92
	add	x0, x0, :lo12:.LANCHOR12
.L867:
	b	_list_remove_node
.L864:
	cmp	w2, 96
	bne	.L865
	adrp	x2, .LANCHOR90
	adrp	x0, .LANCHOR83
	add	x2, x2, :lo12:.LANCHOR90
	add	x0, x0, :lo12:.LANCHOR83
	b	.L867
.L865:
	cmp	w2, 160
	bne	.L863
	adrp	x2, .LANCHOR94
	adrp	x0, .LANCHOR82
	add	x2, x2, :lo12:.LANCHOR94
	add	x0, x0, :lo12:.LANCHOR82
	b	.L867
.L863:
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
	bne	.L869
	adrp	x2, .LANCHOR97
	adrp	x0, .LANCHOR98
	add	x2, x2, :lo12:.LANCHOR97
	add	x0, x0, :lo12:.LANCHOR98
.L871:
	b	_list_remove_node
.L869:
	cmp	w0, 16
	bne	.L870
	adrp	x2, .LANCHOR99
	adrp	x0, .LANCHOR100
	add	x2, x2, :lo12:.LANCHOR99
	add	x0, x0, :lo12:.LANCHOR100
	b	.L871
.L870:
	adrp	x2, .LANCHOR101
	adrp	x0, .LANCHOR102
	add	x2, x2, :lo12:.LANCHOR101
	add	x0, x0, :lo12:.LANCHOR102
	b	.L871
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
	bne	.L873
	adrp	x2, .LANCHOR92
	adrp	x0, .LANCHOR12
	add	x2, x2, :lo12:.LANCHOR92
	add	x0, x0, :lo12:.LANCHOR12
.L876:
	b	_list_update_data_list
.L873:
	cmp	w2, 96
	bne	.L874
	adrp	x2, .LANCHOR90
	adrp	x0, .LANCHOR83
	add	x2, x2, :lo12:.LANCHOR90
	add	x0, x0, :lo12:.LANCHOR83
	b	.L876
.L874:
	cmp	w2, 160
	bne	.L872
	adrp	x2, .LANCHOR94
	adrp	x0, .LANCHOR82
	add	x2, x2, :lo12:.LANCHOR94
	add	x0, x0, :lo12:.LANCHOR82
	b	.L876
.L872:
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
	adrp	x0, .LC57
	stp	x23, x24, [sp, 80]
	add	x0, x0, :lo12:.LC57
	bl	printf
	ldr	x19, [x19]
	cbz	x19, .L877
	mov	x24, -6148914691236517206
	adrp	x22, .LC58
	adrp	x21, .LANCHOR103
	add	x22, x22, :lo12:.LC58
	add	x21, x21, :lo12:.LANCHOR103
	mov	w20, 0
	adrp	x23, .LANCHOR4
	movk	x24, 0xaaab, lsl 0
.L881:
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
	beq	.L877
	ldr	x0, [x23, #:lo12:.LANCHOR4]
	mov	w1, 6
	add	w20, w20, 1
	and	w20, w20, 65535
	umaddl	x19, w19, w1, x0
	ldrh	w0, [x21]
	cmp	w0, w20
	bcs	.L881
.L877:
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
	bls	.L886
	ldr	w2, [x0, 20]
	add	w2, w2, w1, lsr 11
	and	w1, w1, 2047
	stp	w1, w2, [x0, 16]
.L886:
	ldr	w1, [x0, 24]
	cmp	w1, 2048
	bls	.L887
	ldr	w2, [x0, 28]
	add	w2, w2, w1, lsr 11
	and	w1, w1, 2047
	stp	w1, w2, [x0, 24]
.L887:
	ldr	w1, [x0, 32]
	cmp	w1, 1024
	bls	.L888
	ldr	w2, [x0, 36]
	add	w2, w2, w1, lsr 10
	and	w1, w1, 1023
	stp	w1, w2, [x0, 32]
.L888:
	ldr	w1, [x0, 40]
	cmp	w1, 1024
	bls	.L885
	ldr	w2, [x0, 44]
	add	w2, w2, w1, lsr 10
	and	w1, w1, 1023
	stp	w1, w2, [x0, 40]
.L885:
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
.L891:
	cmp	w3, w11
	blt	.L895
	sxtw	x2, w0
	mov	w3, -1
.L896:
	cmp	w11, w2
	bgt	.L897
	ret
.L895:
	asr	w2, w13, w3
	tbnz	x2, 0, .L892
	sdiv	w2, w3, w6
	ldrh	w10, [x8]
	sbfiz	x12, x0, 1, 32
	cmp	w6, 1
	sub	w10, w7, w10
	lsl	w2, w2, w10
	add	w2, w4, w2
	and	w2, w2, 65535
	bhi	.L893
.L898:
	add	w0, w0, 1
	strh	w2, [x1, x12]
.L892:
	add	w3, w3, 1
	b	.L891
.L893:
	and	w10, w5, w3
	add	w2, w2, w10
	b	.L898
.L897:
	strh	w3, [x1, x2, lsl 1]
	add	x2, x2, 1
	b	.L896
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
	cbz	w0, .L900
	adrp	x0, .LANCHOR75
	ldrb	w0, [x0, #:lo12:.LANCHOR75]
	cbnz	w0, .L900
	ldrh	w2, [x22, #:lo12:.LANCHOR105]
	cmp	w21, 0
	cset	w1, eq
	mov	w0, w20
	mul	w2, w2, w19
	bl	flash_erase_block_en
.L900:
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
.L906:
	ldrb	w0, [x25]
	cmp	w19, w0
	bge	.L917
	ldrb	w1, [x24]
	adrp	x0, .LANCHOR105
	mov	w21, 0
	ldrh	w3, [x0, #:lo12:.LANCHOR105]
	sub	w4, w1, #1
	mov	w0, 0
	mul	w6, w19, w1
	mul	w5, w26, w1
	b	.L918
.L908:
	add	w2, w0, w6
	asr	w2, w28, w2
	tbnz	x2, 0, .L907
	and	w2, w0, w4
	add	w2, w2, w5
	mul	w2, w2, w3
	str	w2, [x27, w21, sxtw 2]
	add	w21, w21, 1
.L907:
	add	w0, w0, 1
.L918:
	cmp	w0, w1
	blt	.L908
	cmp	w1, 4
	bne	.L909
	mov	x3, 0
.L910:
	cmp	w21, w3
	bgt	.L911
.L912:
	add	w19, w19, 1
	b	.L906
.L911:
	ldr	w2, [x27, x3, lsl 2]
	mov	w1, w20
	str	x3, [x29, 104]
	mov	w0, w19
	bl	flash_erase_block_en
	ldr	x3, [x29, 104]
	add	x3, x3, 1
	b	.L910
.L909:
	cmp	w21, 2
	bne	.L913
	adrp	x0, .LANCHOR74
	ldrb	w0, [x0, #:lo12:.LANCHOR74]
	cbz	w0, .L914
	adrp	x0, .LANCHOR75
	ldrb	w0, [x0, #:lo12:.LANCHOR75]
	cbnz	w0, .L914
	ldp	w2, w3, [x29, 112]
	cmp	w20, 0
	cset	w1, eq
	mov	w0, w19
	bl	flash_erase_duplane_block
.L914:
	ldp	w2, w3, [x29, 112]
	mov	w1, w20
	mov	w0, w19
	bl	flash_erase_duplane_block
	b	.L912
.L913:
	cmp	w21, 1
	bne	.L912
	adrp	x0, .LANCHOR74
	ldrb	w0, [x0, #:lo12:.LANCHOR74]
	cbz	w0, .L916
	adrp	x0, .LANCHOR75
	ldrb	w0, [x0, #:lo12:.LANCHOR75]
	cbnz	w0, .L916
	ldr	w2, [x29, 112]
	cmp	w20, 0
	cset	w1, eq
	mov	w0, w19
	bl	flash_erase_block_en
.L916:
	ldr	w2, [x29, 112]
	mov	w1, w20
	mov	w0, w19
	bl	flash_erase_block_en
	b	.L912
.L917:
	adrp	x2, .LANCHOR104
	ldr	x3, [x23, #:lo12:.LANCHOR7]
	cbnz	w20, .L919
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
	bge	.L921
	strh	w0, [x1, 96]
.L921:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L919:
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
	bcs	.L921
	strh	w0, [x1, 98]
	b	.L921
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
	bls	.L931
	strh	wzr, [x1, 136]
.L931:
	ldrh	w0, [x1, 112]
	cbnz	w0, .L932
	adrp	x1, .LANCHOR107
	adrp	x0, .LC0
	mov	w2, 1150
	add	x1, x1, :lo12:.LANCHOR107
	add	x0, x0, :lo12:.LC0
	bl	printf
.L932:
	ldr	x1, [x19, #:lo12:.LANCHOR104]
	mov	w5, 65535
.L935:
	ldrh	w2, [x1, 136]
.L933:
	mov	w3, w2
	cmp	w2, 63
	ble	.L934
	strh	wzr, [x1, 136]
	b	.L935
.L934:
	add	x4, x2, 1
	add	x0, x1, x4, lsl 1
	ldrh	w0, [x0, 158]
	cmp	w0, w5
	bne	.L938
	mov	x2, x4
	b	.L933
.L938:
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
	bls	.L941
	strh	wzr, [x1, 138]
.L941:
	ldrh	w0, [x1, 112]
	cmp	w0, 63
	bls	.L942
	adrp	x1, .LANCHOR108
	adrp	x0, .LC0
	mov	w2, 1174
	add	x1, x1, :lo12:.LANCHOR108
	add	x0, x0, :lo12:.LC0
	bl	printf
.L942:
	ldr	x0, [x19, #:lo12:.LANCHOR104]
	mov	w4, 65535
.L945:
	ldrh	w1, [x0, 138]
.L943:
	mov	w2, w1
	cmp	w1, 63
	ble	.L944
	strh	wzr, [x0, 138]
	b	.L945
.L944:
	add	x3, x1, 1
	add	x5, x0, x3, lsl 1
	ldrh	w5, [x5, 158]
	cmp	w5, w4
	bne	.L946
	add	x2, x0, x2, sxtw 1
	strh	w20, [x2, 160]
	strh	w1, [x0, 138]
	ldrh	w1, [x0, 112]
	ldp	x19, x20, [sp, 16]
	add	w1, w1, 1
	strh	w1, [x0, 112]
	ldp	x29, x30, [sp], 32
	ret
.L946:
	mov	x1, x3
	b	.L943
	.size	ftl_free_sys_blk, .-ftl_free_sys_blk
	.section	.text.ftl_info_data_recovery,"ax",@progbits
	.align	2
	.global	ftl_info_data_recovery
	.type	ftl_info_data_recovery, %function
ftl_info_data_recovery:
	ldrh	w2, [x0]
	mov	w1, 65535
	cmp	w2, w1
	beq	.L959
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
	bne	.L949
	ldrb	w0, [x0, 4]
	bfi	w1, w0, 5, 3
	strb	w1, [x21, 2]
	mov	w0, w2
	bl	zftl_remove_free_node
	ldrb	w0, [x21, 2]
	adrp	x1, .LANCHOR104
	ldr	x3, [x1, #:lo12:.LANCHOR104]
	tbz	x0, 3, .L953
	ldrh	w2, [x3, 116]
	sub	w2, w2, #1
	strh	w2, [x3, 116]
.L954:
	and	w0, w0, 224
	cmp	w0, 160
	bne	.L956
	ldr	w0, [x20, x19]
	ldr	x1, [x1, #:lo12:.LANCHOR104]
	ubfx	x2, x0, 11, 8
	add	w2, w2, 1
	bfi	w0, w2, 11, 8
	str	w0, [x20, x19]
	ldrh	w0, [x1, 120]
	sub	w0, w0, #1
	strh	w0, [x1, 120]
.L949:
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L953:
	tst	w0, 24
	bne	.L955
	ldrh	w2, [x3, 114]
	sub	w2, w2, #1
	strh	w2, [x3, 114]
	b	.L954
.L955:
	ldrh	w2, [x3, 118]
	sub	w2, w2, #1
	strh	w2, [x3, 118]
	b	.L954
.L956:
	ldrh	w2, [x20, x19]
	cmp	w0, 64
	add	w3, w2, 1
	bfi	w2, w3, 0, 11
	strh	w2, [x20, x19]
	bne	.L957
	ldr	x1, [x1, #:lo12:.LANCHOR104]
	ldrh	w0, [x1, 122]
	sub	w0, w0, #1
	strh	w0, [x1, 122]
	b	.L949
.L957:
	cmp	w0, 96
	bne	.L949
	ldr	x1, [x1, #:lo12:.LANCHOR104]
	ldrh	w0, [x1, 124]
	sub	w0, w0, #1
	strh	w0, [x1, 124]
	b	.L949
.L959:
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
	bge	.L963
	add	x2, x2, 16
.L964:
	ldrb	w1, [x2, 9]
	sdiv	w19, w0, w1
	msub	w0, w19, w1, w0
	add	x0, x2, x0, uxth 1
	ldrh	w20, [x0, 16]
	mov	w0, 65535
	cmp	w20, w0
	bne	.L965
	adrp	x1, .LANCHOR109
	adrp	x0, .LC0
	mov	w2, 1696
	add	x1, x1, :lo12:.LANCHOR109
	add	x0, x0, :lo12:.LC0
	bl	printf
.L965:
	adrp	x0, .LANCHOR105
	ldrh	w0, [x0, #:lo12:.LANCHOR105]
	madd	w0, w0, w20, w19
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L963:
	sub	w0, w0, w1
	add	x2, x2, 48
	and	w0, w0, 65535
	b	.L964
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
.L968:
	cmp	w1, w3
	bne	.L970
	mov	w0, -1
	ret
.L970:
	uxtw	x2, w1
	ldr	w6, [x4, x2, lsl 2]
	cmp	w0, w6
	bne	.L969
	mov	w0, w1
	b	ftl_get_ppa_from_index
.L969:
	ldrh	w1, [x5, x2, lsl 1]
	b	.L968
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
	bne	.L972
	adrp	x1, .LANCHOR113
	adrp	x0, .LC0
	mov	w2, 1819
	add	x1, x1, :lo12:.LANCHOR113
	add	x0, x0, :lo12:.LC0
	bl	printf
.L972:
	adrp	x0, .LANCHOR87
	ldrh	w1, [x19, 2]
	ldrh	w0, [x0, #:lo12:.LANCHOR87]
	cmp	w1, w0
	bne	.L973
	adrp	x1, .LANCHOR113
	adrp	x0, .LC0
	mov	w2, 1820
	add	x1, x1, :lo12:.LANCHOR113
	add	x0, x0, :lo12:.LC0
	bl	printf
.L973:
	ldrh	w0, [x19, 6]
	cbnz	w0, .L974
	adrp	x1, .LANCHOR113
	adrp	x0, .LC0
	mov	w2, 1821
	add	x1, x1, :lo12:.LANCHOR113
	add	x0, x0, :lo12:.LC0
	bl	printf
.L974:
	ldrb	w0, [x19, 5]
	mov	w2, 65535
	add	x0, x0, 8
	ldrh	w3, [x19, x0, lsl 1]
	adrp	x0, .LANCHOR80
	ldrb	w4, [x0, #:lo12:.LANCHOR80]
.L975:
	cmp	w3, w2
	ldrb	w1, [x19, 5]
	beq	.L977
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
	bne	.L971
	add	w2, w2, 1
	strb	wzr, [x19, 5]
	strh	w2, [x19, 2]
.L971:
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L977:
	add	w1, w1, 1
	and	w1, w1, 255
	strb	w1, [x19, 5]
	cmp	w1, w4
	bne	.L976
	ldrh	w0, [x19, 2]
	strb	wzr, [x19, 5]
	add	w0, w0, 1
	strh	w0, [x19, 2]
.L976:
	ldrb	w0, [x19, 5]
	add	x0, x0, 8
	ldrh	w3, [x19, x0, lsl 1]
	b	.L975
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
	bcs	.L981
	adrp	x1, .LANCHOR114
	adrp	x0, .LC0
	mov	w2, 1852
	add	x1, x1, :lo12:.LANCHOR114
	add	x0, x0, :lo12:.LC0
	bl	printf
.L981:
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
	bhi	.L984
	cbnz	w0, .L984
	add	w1, w1, 1
	strh	w1, [x2, #:lo12:.LANCHOR115]
	ret
.L984:
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
.L986:
	cmp	w5, w1, uxth
	bhi	.L989
	adrp	x1, .LANCHOR10
	ldr	x1, [x1, #:lo12:.LANCHOR10]
	str	w2, [x1, 524]
	adrp	x2, .LANCHOR104
	str	w0, [x1, 528]
	ldr	x2, [x2, #:lo12:.LANCHOR104]
	ldrh	w2, [x2, 120]
	cbz	w2, .L983
	udiv	w0, w0, w2
	str	w0, [x1, 532]
.L983:
	ret
.L989:
	ldrh	w3, [x6, x1, lsl 1]
	cmp	w3, w8
	beq	.L987
	add	x4, x7, x1, lsl 2
	ldrb	w4, [x4, 2]
	and	w4, w4, 224
	cmp	w4, 160
	bne	.L988
	add	w0, w0, w3
.L987:
	add	x1, x1, 1
	b	.L986
.L988:
	add	w2, w2, w3
	b	.L987
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
	cbnz	w0, .L997
	adrp	x1, .LANCHOR116
	mov	w0, 1
	str	w0, [x1, #:lo12:.LANCHOR116]
.L995:
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L997:
	mov	w0, 0
	b	.L995
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
	beq	.L1000
	adrp	x0, .LANCHOR9
	uxtw	x1, w19
	lsl	x2, x1, 1
	ldr	x3, [x0, #:lo12:.LANCHOR9]
	ldrh	w0, [x3, x2]
	cbnz	w0, .L1001
	adrp	x0, .LANCHOR7
	mov	w2, 0
	ldr	x0, [x0, #:lo12:.LANCHOR7]
	add	x1, x0, x1, lsl 2
	adrp	x0, .LC59
	add	x0, x0, :lo12:.LC59
	ldrb	w3, [x1, 2]
	mov	w1, w19
	ubfx	x3, x3, 5, 3
	bl	printf
.L1006:
	mov	w0, 0
	b	.L999
.L1001:
	sub	w0, w0, #1
	strh	w0, [x3, x2]
.L1000:
	adrp	x20, .LANCHOR66
	ldrh	w0, [x20, #:lo12:.LANCHOR66]
	cmp	w19, w0
	beq	.L1006
	mov	w1, 65535
	cmp	w0, w1
	bne	.L1003
	strh	w19, [x20, #:lo12:.LANCHOR66]
	b	.L1006
.L1003:
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
.L999:
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
.L1009:
	cmp	w6, w12
	beq	.L1013
	uxtw	x11, w6
	lsl	x10, x11, 2
	add	x13, x8, x10
	ldr	w10, [x8, x10]
	cmp	w0, w10
	lsl	x10, x11, 1
	bne	.L1010
	mov	w6, -1
	str	w6, [x13]
	cmp	w7, w12
	bne	.L1011
	add	x6, x3, :lo12:.LANCHOR110
	ldrh	w7, [x4, x10]
	strh	w7, [x6, x5, lsl 1]
.L1012:
	mov	w6, -1
	strh	w6, [x4, x11, lsl 1]
.L1013:
	uxtw	x6, w2
	add	x3, x3, :lo12:.LANCHOR110
	cmn	w1, #1
	str	w0, [x8, x6, lsl 2]
	ldrh	w0, [x3, x5, lsl 1]
	strh	w2, [x3, x5, lsl 1]
	strh	w0, [x4, x6, lsl 1]
	beq	.L1020
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
.L1011:
	ldrh	w6, [x4, x10]
	strh	w6, [x4, w7, uxtw 1]
	b	.L1012
.L1010:
	mov	w7, w6
	ldrh	w6, [x4, x10]
	b	.L1009
.L1020:
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
	bls	.L1024
	sub	w2, w5, #1
	and	w2, w2, w4
	add	w2, w19, w2
	and	w19, w2, 255
.L1024:
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 14, .L1025
	adrp	x0, .LC60
	and	w3, w3, 65535
	mov	w2, w19
	add	x0, x0, :lo12:.LC60
	bl	printf
.L1025:
	adrp	x0, .LANCHOR6
	ldrh	w0, [x0, #:lo12:.LANCHOR6]
	cmp	w0, w20
	bls	.L1023
	adrp	x0, .LANCHOR7
	mov	w2, 1
	lsl	w2, w2, w19
	ldr	x0, [x0, #:lo12:.LANCHOR7]
	add	x20, x0, x20, uxth 2
	ldrb	w19, [x20, 3]
	orr	w2, w2, w19
	strb	w2, [x20, 3]
.L1023:
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
	and	w23, w0, 65535
	str	x27, [sp, 80]
	adrp	x27, .LANCHOR64
	add	x0, x27, :lo12:.LANCHOR64
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	ldr	w0, [x0, 584]
	cbz	w0, .L1045
	adrp	x22, .LC61
	mov	w24, 20041
	add	x22, x22, :lo12:.LC61
	mov	w26, 0
	movk	w24, 0x444b, lsl 16
.L1033:
	adrp	x0, .LANCHOR80
	ldrb	w0, [x0, #:lo12:.LANCHOR80]
	cmp	w0, w26
	bhi	.L1042
.L1045:
	mov	w0, 0
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L1042:
	adrp	x0, .LANCHOR69
	adrp	x1, .LANCHOR31
	adrp	x21, .LANCHOR68
	ldrb	w2, [x0, #:lo12:.LANCHOR69]
	ldrb	w3, [x1, #:lo12:.LANCHOR31]
	mov	w1, 24
	and	w0, w2, 65535
	cmp	w2, 1
	sub	w1, w1, w3
	ldrh	w3, [x21, #:lo12:.LANCHOR68]
	sdiv	w19, w26, w2
	sub	w1, w1, w3
	lsl	w19, w19, w1
	madd	w19, w23, w0, w19
	and	w19, w19, 65535
	bls	.L1034
	sub	w0, w0, #1
	and	w0, w0, w26
	add	w19, w19, w0
	and	w19, w19, 65535
.L1034:
	adrp	x25, .LANCHOR118
	add	x25, x25, :lo12:.LANCHOR118
	mov	w20, 0
.L1035:
	add	x0, x27, :lo12:.LANCHOR64
	ldr	w1, [x0, 584]
	cmp	w20, w1
	bcc	.L1041
	add	w26, w26, 1
	and	w26, w26, 65535
	b	.L1033
.L1041:
	add	x0, x0, x20, sxtw 1
	ldrh	w0, [x0, 588]
	cmp	w0, w19
	bne	.L1036
	mov	w1, w19
	mov	x0, x22
	bl	printf
	ldrb	w0, [x25]
	cbz	w0, .L1037
	adrp	x0, .LANCHOR104
	ldr	x0, [x0, #:lo12:.LANCHOR104]
	ldr	w0, [x0, 156]
	cmp	w0, w24
	beq	.L1038
.L1037:
	ldrh	w0, [x21, #:lo12:.LANCHOR68]
	lsl	w0, w19, w0
	bl	ftl_mask_bad_block
.L1038:
	add	x1, x27, :lo12:.LANCHOR64
	mov	w0, w20
	ldr	w2, [x1, 584]
.L1039:
	cmp	w0, w2
	bcc	.L1040
	add	x0, x27, :lo12:.LANCHOR64
	sub	w2, w2, #1
	str	w2, [x0, 584]
.L1036:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L1035
.L1040:
	add	w3, w0, 1
	add	x0, x1, x0, sxtw 1
	add	x4, x1, x3, sxtw 1
	ldrh	w4, [x4, 588]
	strh	w4, [x0, 588]
	and	w0, w3, 65535
	b	.L1039
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
	adrp	x8, .LANCHOR119
	ldr	x7, [x1, #:lo12:.LANCHOR104]
	and	w5, w2, 2047
	ldr	w2, [x4, x19]
	ldrh	w8, [x8, #:lo12:.LANCHOR119]
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
	adrp	x3, .LANCHOR120
	adrp	x7, .LANCHOR97
	ldrh	w6, [x3, #:lo12:.LANCHOR120]
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
	adrp	x0, .LC62
	ldp	x21, x22, [sp, 32]
	add	x0, x0, :lo12:.LC62
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	b	printf
.L1054:
	madd	w3, w2, w3, w6
	adrp	x6, .LANCHOR121
	ldrh	w6, [x6, #:lo12:.LANCHOR121]
	cmp	w3, w6
	ble	.L1056
	adrp	x3, .LANCHOR120
	adrp	x7, .LANCHOR97
	ldrh	w6, [x3, #:lo12:.LANCHOR120]
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
	adrp	x22, .LC63
	adrp	x23, .LANCHOR9
	add	x21, x21, :lo12:.LANCHOR64
	mov	x24, x23
	add	x22, x22, :lo12:.LC63
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
	adrp	x0, .LC64
	mov	w1, w19
	add	x0, x0, :lo12:.LC64
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
	adrp	x1, .LANCHOR122
	adrp	x0, .LC0
	mov	w2, 1119
	add	x1, x1, :lo12:.LANCHOR122
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
	adrp	x8, .LANCHOR123
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
	ldr	w8, [x8, #:lo12:.LANCHOR123]
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
	adrp	x0, .LC65
	add	x0, x0, :lo12:.LC65
	bl	printf
	ldr	x0, [x19, #:lo12:.LANCHOR104]
	adrp	x1, .LANCHOR124
	ldrb	w3, [x1, #:lo12:.LANCHOR124]
	ldr	w4, [x0, 8]
	ldr	w5, [x0, 64]
	ldr	w1, [x0, 20]
	ldr	w2, [x0, 28]
	adrp	x0, .LC66
	add	x0, x0, :lo12:.LC66
	bl	printf
	ldr	x0, [x19, #:lo12:.LANCHOR104]
	ldr	w1, [x0, 52]
	ldr	w2, [x0, 60]
	ldr	w3, [x0, 16]
	adrp	x0, .LC67
	add	x0, x0, :lo12:.LC67
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
	adrp	x0, .LC68
	add	x0, x0, :lo12:.LC68
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
	adrp	x0, .LC69
	add	x0, x0, :lo12:.LC69
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
	adrp	x0, .LC70
	add	x0, x0, :lo12:.LC70
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
	adrp	x1, .LANCHOR125
	add	x1, x1, :lo12:.LANCHOR125
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
	adrp	x0, .LANCHOR126
	mov	x20, x0
	ldrb	w1, [x0, #:lo12:.LANCHOR126]
	ldrb	w2, [x19, 56]
	cmp	w2, w1
	bls	.L1117
	adrp	x1, .LANCHOR125
	adrp	x0, .LC0
	mov	w2, 681
	add	x1, x1, :lo12:.LANCHOR125
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1117:
	ldrb	w0, [x19, 56]
	adrp	x21, .LANCHOR60
	cbz	w0, .L1114
	ldrb	w1, [x20, #:lo12:.LANCHOR126]
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
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR52
	stp	x19, x20, [sp, 16]
	add	x22, x21, :lo12:.LANCHOR52
	stp	x23, x24, [sp, 48]
	adrp	x20, .LANCHOR127
	mov	w23, 20041
	add	x20, x20, :lo12:.LANCHOR127
	str	x25, [sp, 64]
	movk	w23, 0x444b, lsl 16
	mov	w25, 0
.L1123:
	ldrb	w0, [x20]
	cmp	w0, 255
	bne	.L1133
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L1133:
	add	x1, x21, :lo12:.LANCHOR52
	lsl	x2, x0, 6
	add	x24, x1, x2
	ubfiz	x19, x0, 6, 8
	add	x19, x1, x19
	ldrb	w1, [x1, x2]
	strb	w1, [x20]
	ldr	w1, [x24, 52]
	cmn	w1, #1
	bne	.L1124
	adrp	x1, .LANCHOR118
	ldrb	w1, [x1, #:lo12:.LANCHOR118]
	cbz	w1, .L1125
	adrp	x1, .LANCHOR104
	ldr	x1, [x1, #:lo12:.LANCHOR104]
	ldr	w1, [x1, 156]
	cmp	w1, w23
	beq	.L1126
.L1125:
	add	x1, x22, x0, lsl 6
	mov	w2, 24
	mov	w5, 65535
	ldr	w3, [x1, 40]
	adrp	x1, .LANCHOR68
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
	mov	x24, x2
	ldr	x4, [x2, #:lo12:.LANCHOR10]
	and	w25, w1, 65535
	and	w1, w1, w5
	ldr	w6, [x4, 560]
	cmp	w6, w5
	bne	.L1127
	str	w1, [x4, 560]
	str	w3, [x4, 564]
.L1127:
	add	x0, x22, x0, lsl 6
	ldr	w2, [x0, 36]
	adrp	x0, .LC71
	add	x0, x0, :lo12:.LC71
	bl	printf
	ldr	x0, [x24, #:lo12:.LANCHOR10]
	ldr	w1, [x0, 556]
	add	w1, w1, 1
	str	w1, [x0, 556]
	ldrh	w1, [x0, 16]
	cmp	w1, w25
	bne	.L1128
	strh	wzr, [x0, 22]
.L1126:
	mov	x0, x19
	mov	w25, 1
	bl	ftl_write_buf
	b	.L1123
.L1128:
	ldrh	w1, [x0, 48]
	cmp	w1, w25
	bne	.L1126
	strh	wzr, [x0, 54]
	b	.L1126
.L1124:
	cbz	w25, .L1131
	ldp	w1, w2, [x24, 36]
	adrp	x0, .LC72
	add	x0, x0, :lo12:.LC72
	bl	printf
	mov	x0, x19
	bl	ftl_write_buf
	b	.L1123
.L1131:
	ldrh	w2, [x24, 48]
	ldr	w0, [x24, 36]
	ldr	w1, [x24, 44]
	bl	lpa_hash_update_ppa
	ldrb	w0, [x24, 2]
	tbz	x0, 2, .L1132
	and	w0, w0, -3
	strb	w0, [x24, 2]
	b	.L1123
.L1132:
	mov	x0, x19
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
	cbnz	x0, .L1139
	mov	w2, 974
	adrp	x1, .LANCHOR128
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR128
	add	x0, x0, :lo12:.LC0
	bl	printf
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	b	print_ftl_debug_info
.L1139:
	ldrb	w1, [x0, 56]
	mov	x19, x0
	adrp	x0, .LANCHOR126
	ldrb	w0, [x0, #:lo12:.LANCHOR126]
	cmp	w1, w0
	bls	.L1141
	adrp	x1, .LANCHOR128
	adrp	x0, .LC0
	mov	w2, 979
	add	x1, x1, :lo12:.LANCHOR128
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1141:
	mov	x1, x19
	adrp	x0, .LANCHOR129
	add	x0, x0, :lo12:.LANCHOR129
	bl	buf_add_tail
	adrp	x1, .LANCHOR130
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ldrb	w0, [x1, #:lo12:.LANCHOR130]
	add	w0, w0, 1
	strb	w0, [x1, #:lo12:.LANCHOR130]
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
	beq	.L1146
	adrp	x0, .LANCHOR7
	lsl	w22, w22, 1
	ldr	x21, [x0, #:lo12:.LANCHOR7]
	add	x21, x21, x19, uxth 2
	ldrb	w0, [x21, 2]
	tst	w0, 224
	beq	.L1147
	adrp	x1, .LANCHOR131
	adrp	x0, .LC0
	mov	w2, 846
	add	x1, x1, :lo12:.LANCHOR131
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1147:
	ldrb	w0, [x21, 2]
	bfi	w0, w20, 5, 3
	ubfx	x1, x0, 3, 2
	orr	w22, w22, w1
	bfi	w0, w22, 3, 2
	strb	w0, [x21, 2]
.L1148:
	mov	w0, w19
	ldr	x23, [sp, 48]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L1146:
	bl	print_ftl_debug_info
	adrp	x21, .LC73
	mov	w2, w20
	add	x21, x21, :lo12:.LC73
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
	mov	w2, 856
	adrp	x1, .LANCHOR131
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR131
	add	x0, x0, :lo12:.LC0
	bl	printf
	b	.L1148
	.size	ftl_alloc_sblk, .-ftl_alloc_sblk
	.section	.text.sblk_init,"ax",@progbits
	.align	2
	.global	sblk_init
	.type	sblk_init, %function
sblk_init:
	adrp	x1, .LANCHOR56
	mov	w0, -1
	strb	w0, [x1, #:lo12:.LANCHOR56]
	adrp	x1, .LANCHOR127
	strb	w0, [x1, #:lo12:.LANCHOR127]
	adrp	x1, .LANCHOR132
	strb	w0, [x1, #:lo12:.LANCHOR132]
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
	adrp	x0, .LC74
	add	x0, x0, :lo12:.LC74
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR56
	str	x21, [sp, 32]
	ldrb	w1, [x19, #:lo12:.LANCHOR56]
	bl	printf
	ldrb	w19, [x19, #:lo12:.LANCHOR56]
	cmp	w19, 255
	beq	.L1155
	adrp	x1, .LANCHOR52
	ubfiz	x19, x19, 6, 8
	add	x1, x1, :lo12:.LANCHOR52
	adrp	x21, .LC75
	add	x19, x1, x19
	add	x21, x21, :lo12:.LC75
	mov	x20, x1
.L1157:
	ldrb	w2, [x19, 58]
	mov	x0, x21
	ldrb	w1, [x19, 1]
	ldr	w3, [x19, 40]
	bl	printf
	ldrb	w19, [x19]
	cmp	w19, 255
	beq	.L1155
	ubfiz	x19, x19, 6, 8
	add	x19, x20, x19
	b	.L1157
.L1155:
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
	beq	.L1173
	adrp	x3, .LANCHOR31
	mov	w8, 24
	adrp	x10, .LANCHOR52
	add	x10, x10, :lo12:.LANCHOR52
	ldrb	w4, [x3, #:lo12:.LANCHOR31]
	mov	w3, 1
	adrp	x13, .L1169
	mov	x15, x10
	sub	w8, w8, w4
	add	x13, x13, :lo12:.L1169
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
.L1172:
	add	x14, x10, x2, lsl 6
	ldr	w4, [x14, 40]
	lsr	w0, w4, w8
	and	w0, w6, w0
	cmp	w11, w0
	bne	.L1167
	lsr	w4, w4, w12
	and	w4, w5, w4
	and	w4, w7, w4
	ldrb	w0, [x14, 58]
	cmp	w3, w4
	bne	.L1168
	cmp	w1, 1
	bne	.L1165
	cmp	w0, 7
	ccmp	w0, 9, 4, ne
	beq	.L1167
	ret
.L1168:
	cmp	w1, 3
	bhi	.L1167
	ldrb	w4, [x13,w1,uxtw]
	adr	x14, .Lrtx1169
	add	x4, x14, w4, sxtb #2
	br	x4
.Lrtx1169:
	.section	.rodata.queue_lun_state,"a",@progbits
	.align	0
	.align	2
.L1169:
	.byte	(.L1165 - .Lrtx1169) / 4
	.byte	(.L1170 - .Lrtx1169) / 4
	.byte	(.L1171 - .Lrtx1169) / 4
	.byte	(.L1165 - .Lrtx1169) / 4
	.section	.text.queue_lun_state
.L1170:
	cmp	w0, 7
	ccmp	w0, 9, 4, ne
	beq	.L1167
	ret
.L1171:
	cmp	w0, 11
	bne	.L1165
.L1167:
	lsl	x2, x2, 6
	ldrb	w2, [x15, x2]
	cmp	w2, 255
	bne	.L1172
.L1173:
	mov	w0, 0
.L1165:
	ret
	.size	queue_lun_state, .-queue_lun_state
	.section	.text.queue_remove_completed_req,"ax",@progbits
	.align	2
	.global	queue_remove_completed_req
	.type	queue_remove_completed_req, %function
queue_remove_completed_req:
	adrp	x4, .LANCHOR127
	adrp	x8, .LANCHOR71
	adrp	x1, .LANCHOR56
	adrp	x7, .LANCHOR132
	adrp	x3, .LANCHOR52
	ldrb	w14, [x4, #:lo12:.LANCHOR127]
	add	x5, x3, :lo12:.LANCHOR52
	ldrb	w2, [x1, #:lo12:.LANCHOR56]
	ldrb	w12, [x8, #:lo12:.LANCHOR71]
	mov	x11, x5
	ldrb	w13, [x7, #:lo12:.LANCHOR132]
	add	x16, x8, :lo12:.LANCHOR71
	add	x7, x7, :lo12:.LANCHOR132
	add	x10, x4, :lo12:.LANCHOR127
	mov	w6, 0
	mov	w15, -1
.L1176:
	cmp	w2, 255
	beq	.L1177
	sbfiz	x8, x2, 6, 32
	sxtw	x0, w2
	add	x4, x5, x8
	ldrb	w4, [x4, 58]
	sub	w4, w4, #12
	and	w4, w4, 255
	cmp	w4, 1
	bls	.L1178
	cbz	w6, .L1175
	strb	w2, [x1, #:lo12:.LANCHOR56]
	ret
.L1178:
	lsl	x6, x0, 6
	ldrb	w2, [x5, x8]
	add	x4, x5, x6
	strb	w15, [x5, x6]
	ldrb	w6, [x4, 59]
	cmp	w6, 1
	bne	.L1181
	ldrh	w4, [x4, 50]
	cbnz	w4, .L1189
	mov	w4, w14
	mov	x6, x10
.L1182:
	cmp	w4, 255
	bne	.L1187
	add	x3, x3, :lo12:.LANCHOR52
	strb	w2, [x1, #:lo12:.LANCHOR56]
	add	x0, x3, x0, lsl 6
	ldrb	w0, [x0, 1]
	strb	w0, [x6]
	ret
.L1181:
	cbnz	w6, .L1183
	ldr	w4, [x4, 36]
	cmn	w4, #1
	beq	.L1183
	mov	w4, w13
	mov	x6, x7
	b	.L1182
.L1189:
	mov	w4, w12
	mov	x6, x16
	b	.L1182
.L1187:
	mov	w6, w4
	sbfiz	x4, x4, 6, 32
	ldrb	w4, [x11, x4]
	cmp	w4, 255
	bne	.L1187
	add	x0, x11, x0, lsl 6
	sbfiz	x6, x6, 6, 32
	ldrb	w0, [x0, 1]
	strb	w0, [x11, x6]
.L1183:
	mov	w6, 1
	b	.L1176
.L1177:
	cbz	w6, .L1175
	mov	w0, -1
	strb	w0, [x1, #:lo12:.LANCHOR56]
.L1175:
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
	bls	.L1200
	add	x0, x1, x0, sxtw 1
	ldrh	w1, [x0, 672]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L1201
.L1200:
	adrp	x19, .LC76
	add	x19, x19, :lo12:.LC76
	adrp	x23, .LANCHOR7
.L1213:
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
	bne	.L1202
	mov	w1, w21
	mov	x0, x19
	bl	printf
	ldr	x1, [x23, #:lo12:.LANCHOR7]
	add	x1, x1, x21, uxth 2
	ldrb	w0, [x1, 2]
	orr	w0, w0, -32
	strb	w0, [x1, 2]
	b	.L1213
.L1202:
	ldr	x0, [x14]
	adrp	x1, .LANCHOR133
	mov	w2, 1
	mov	w19, 0
	add	x0, x0, 416
	str	w2, [x1, #:lo12:.LANCHOR133]
	mov	w1, 65535
	strh	wzr, [x0, 274]
.L1204:
	ldrh	w2, [x0]
	cmp	w2, w1
	beq	.L1203
	add	w19, w19, 1
	add	x0, x0, 2
	and	w19, w19, 65535
	cmp	w19, 128
	bne	.L1204
	adrp	x1, .LANCHOR134
	adrp	x0, .LC0
	mov	w2, 231
	add	x1, x1, :lo12:.LANCHOR134
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1203:
	ldr	x0, [x20, #:lo12:.LANCHOR104]
	add	x19, x0, x19, sxtw 1
	ldrh	w1, [x0, 688]
	strh	w21, [x19, 416]
	add	w1, w1, 1
	strh	w1, [x0, 688]
.L1201:
	ldr	x1, [x20, #:lo12:.LANCHOR104]
	ldrh	w0, [x1, 690]
	add	x0, x0, 336
	ldrh	w19, [x1, x0, lsl 1]
	mov	w0, 65533
	sub	w1, w19, #1
	cmp	w0, w1, uxth
	bcs	.L1206
	adrp	x1, .LANCHOR134
	adrp	x0, .LC0
	mov	w2, 236
	add	x1, x1, :lo12:.LANCHOR134
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1206:
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
	tbz	x0, 12, .L1209
	mov	w0, 1
	and	w4, w4, 65535
	lsl	w2, w0, w2
	mov	w3, w19
	adrp	x0, .LC77
	sub	w2, w2, #1
	mov	w1, w19
	add	x0, x0, :lo12:.LC77
	bl	printf
.L1209:
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
	adrp	x0, .LANCHOR135
	add	x0, x0, :lo12:.LANCHOR135
	mov	x1, 0
	add	x29, sp, 0
	mov	w2, 65535
	str	x19, [sp, 16]
.L1218:
	lsl	x3, x1, 4
	and	w19, w1, 65535
	ldrh	w3, [x3, x0]
	cmp	w3, w2
	beq	.L1217
	add	x1, x1, 1
	cmp	x1, 32
	bne	.L1218
	add	x0, x0, 2
	mov	w19, w1
	mov	x2, x0
	mov	w4, 32768
	mov	w1, 0
.L1220:
	ldrh	w3, [x2]
	tbnz	x3, 15, .L1219
	cmp	w3, w4
	bcs	.L1219
	mov	w4, w3
	mov	w19, w1
.L1219:
	add	w1, w1, 1
	add	x2, x2, 16
	and	w1, w1, 65535
	cmp	w1, 32
	bne	.L1220
	cmp	w19, 32
	bne	.L1217
	adrp	x1, .LANCHOR136
	mov	w2, -1
	ldrb	w3, [x1, #:lo12:.LANCHOR136]
	mov	w1, 0
.L1222:
	ldrh	w5, [x0]
	cmp	w5, w2
	bcs	.L1221
	ldrh	w4, [x0, -2]
	cmp	w4, w3
	csel	w2, w2, w5, eq
	csel	w19, w19, w1, eq
.L1221:
	add	w1, w1, 1
	add	x0, x0, 16
	and	w1, w1, 65535
	cmp	w1, 32
	bne	.L1222
	cmp	w19, 32
	bne	.L1217
	adrp	x1, .LANCHOR137
	adrp	x0, .LC0
	mov	w2, 335
	add	x1, x1, :lo12:.LANCHOR137
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1217:
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
	adrp	x0, .LANCHOR138
	str	xzr, [x0, #:lo12:.LANCHOR138]
	adrp	x0, .LANCHOR139
	str	wzr, [x0, #:lo12:.LANCHOR139]
	adrp	x0, .LANCHOR140
	strb	wzr, [x0, #:lo12:.LANCHOR140]
	adrp	x0, .LANCHOR141
	str	xzr, [x0, #:lo12:.LANCHOR141]
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
	cbnz	w0, .L1230
	add	x1, x19, :lo12:.LANCHOR3
	mov	x0, 0
.L1231:
	strh	w0, [x1, x0, lsl 1]
	add	x0, x0, 1
	cmp	x0, 256
	bne	.L1231
.L1237:
	adrp	x20, .LANCHOR142
	add	x20, x20, :lo12:.LANCHOR142
	mov	w2, 1024
	mov	w1, 255
	mov	x0, x20
	add	x19, x19, :lo12:.LANCHOR3
	bl	ftl_memset
	mov	x0, 0
.L1232:
	ldrh	w1, [x0, x19]
	add	x0, x0, 2
	cmp	x0, 512
	strh	w1, [x20, w1, sxtw 1]
	bne	.L1232
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L1230:
	cmp	w0, 1
	bne	.L1233
	add	x3, x19, :lo12:.LANCHOR3
	mov	x1, 0
.L1236:
	and	w0, w1, 65535
	cmp	x1, 3
	bls	.L1234
	ubfiz	w2, w0, 1, 15
	and	w0, w0, 1
	add	w0, w0, 2
	sub	w0, w2, w0
	and	w0, w0, 65535
.L1234:
	strh	w0, [x3, x1, lsl 1]
	add	x1, x1, 1
	cmp	x1, 256
	bne	.L1236
	b	.L1237
.L1233:
	cmp	w0, 2
	bne	.L1238
	add	x3, x19, :lo12:.LANCHOR3
	mov	w1, 65535
	mov	x0, 0
.L1240:
	cmp	x0, 2
	and	w2, w0, 65535
	csel	w2, w2, w1, cc
	strh	w2, [x3, x0, lsl 1]
	add	w1, w1, 2
	add	x0, x0, 1
	and	w1, w1, 65535
	cmp	x0, 256
	bne	.L1240
	b	.L1237
.L1238:
	cmp	w0, 3
	bne	.L1241
	add	x3, x19, :lo12:.LANCHOR3
	mov	x1, 0
.L1244:
	and	w0, w1, 65535
	cmp	x1, 5
	bls	.L1242
	ubfiz	w2, w0, 1, 15
	and	w0, w0, 1
	add	w0, w0, 4
	sub	w0, w2, w0
	and	w0, w0, 65535
.L1242:
	strh	w0, [x3, x1, lsl 1]
	add	x1, x1, 1
	cmp	x1, 256
	bne	.L1244
	b	.L1237
.L1241:
	cmp	w0, 4
	bne	.L1245
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
.L1247:
	and	w3, w0, 1
	ubfiz	w2, w0, 1, 15
	add	w3, w3, 6
	add	w0, w0, 1
	sub	w2, w2, w3
	strh	w2, [x1], 2
	and	w0, w0, 65535
	cmp	w0, 256
	bne	.L1247
	b	.L1237
.L1245:
	cmp	w0, 5
	bne	.L1248
	add	x1, x19, :lo12:.LANCHOR3
	mov	x0, 0
.L1249:
	strh	w0, [x1, x0, lsl 1]
	add	x0, x0, 1
	cmp	x0, 16
	bne	.L1249
	add	x1, x1, 32
.L1250:
	strh	w0, [x1], 2
	add	w0, w0, 2
	and	w0, w0, 65535
	cmp	w0, 496
	bne	.L1250
	b	.L1237
.L1248:
	cmp	w0, 8
	bne	.L1251
	add	x1, x19, :lo12:.LANCHOR3
	mov	x0, 0
.L1252:
	strh	w0, [x0, x1]
	add	x0, x0, 2
	cmp	x0, 512
	bne	.L1252
	b	.L1237
.L1251:
	cmp	w0, 9
	bne	.L1253
	add	x0, x19, :lo12:.LANCHOR3
	mov	w1, 1
	add	x0, x0, 6
	strh	wzr, [x19, #:lo12:.LANCHOR3]
	strh	w1, [x0, -4]
	mov	w1, 2
	strh	w1, [x0, -2]
	mov	w1, 3
.L1254:
	strh	w1, [x0], 2
	add	w1, w1, 2
	and	w1, w1, 65535
	cmp	w1, 509
	bne	.L1254
	b	.L1237
.L1253:
	cmp	w0, 10
	bne	.L1237
	add	x1, x19, :lo12:.LANCHOR3
	mov	x0, 0
.L1255:
	strh	w0, [x1, x0, lsl 1]
	add	x0, x0, 1
	cmp	x0, 63
	bne	.L1255
	add	x1, x1, 126
.L1256:
	strh	w0, [x1], 2
	add	w0, w0, 2
	and	w0, w0, 65535
	cmp	w0, 449
	bne	.L1256
	b	.L1237
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
	tbz	x0, 12, .L1275
	adrp	x1, .LANCHOR143
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR143
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1275:
	adrp	x22, .LANCHOR32
	add	x19, x22, :lo12:.LANCHOR32
	adrp	x23, .LANCHOR2
	adrp	x24, .LANCHOR18
	adrp	x21, .LANCHOR30
	mov	w2, 8
	ldrh	w0, [x19, 26]
	adrp	x20, .LANCHOR145
	ldrb	w1, [x19, 12]
	strh	w0, [x23, #:lo12:.LANCHOR2]
	ldrh	w0, [x19, 10]
	strb	wzr, [x24, #:lo12:.LANCHOR18]
	sdiv	w0, w0, w1
	adrp	x1, .LANCHOR144
	strh	w0, [x1, #:lo12:.LANCHOR144]
	mov	w1, 0
	add	x0, x21, :lo12:.LANCHOR30
	bl	ftl_memset
	add	x0, x20, :lo12:.LANCHOR145
	mov	w2, 32
	mov	w1, 0
	bl	ftl_memset
	mov	x8, x22
	mov	x15, x21
	mov	x11, x20
	adrp	x14, .LANCHOR44
	adrp	x20, .LANCHOR33
	add	x21, x14, :lo12:.LANCHOR44
	add	x20, x20, :lo12:.LANCHOR33
	add	x22, x19, 1
	mov	x12, 0
.L1277:
	ldrb	w2, [x19]
	mov	w0, 2
	strb	w0, [x12, x20]
	add	x1, x21, x12, lsl 3
	mov	x0, x22
	bl	flash_mem_cmp8
	cbnz	w0, .L1276
	ldrb	w2, [x24, #:lo12:.LANCHOR18]
	add	x1, x11, :lo12:.LANCHOR145
	add	w0, w2, 1
	strb	w0, [x24, #:lo12:.LANCHOR18]
	and	w0, w12, 255
	str	wzr, [x1, x2, lsl 2]
	add	x1, x15, :lo12:.LANCHOR30
	strb	w0, [x1, x2]
	bl	zftl_flash_enter_slc_mode
.L1276:
	add	x12, x12, 1
	cmp	x12, 4
	bne	.L1277
	add	x0, x8, :lo12:.LANCHOR32
	ldrb	w1, [x0, 8]
	cmp	w1, 2
	beq	.L1278
.L1282:
	add	x8, x8, :lo12:.LANCHOR32
	ldrb	w0, [x24, #:lo12:.LANCHOR18]
	ldp	x19, x20, [sp, 16]
	ldrb	w1, [x8, 13]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	mul	w0, w0, w1
	ldrh	w1, [x8, 14]
	ldp	x29, x30, [sp], 64
	mul	w0, w0, w1
	adrp	x1, .LANCHOR146
	strh	w0, [x1, #:lo12:.LANCHOR146]
	ret
.L1278:
	ldrh	w1, [x23, #:lo12:.LANCHOR2]
	add	x14, x14, :lo12:.LANCHOR44
	ldrb	w12, [x0, 13]
	add	x7, x0, 1
	ldrb	w20, [x8, #:lo12:.LANCHOR32]
	add	x19, x24, :lo12:.LANCHOR18
	ldrb	w21, [x0, 23]
	add	x11, x11, :lo12:.LANCHOR145
	add	x15, x15, :lo12:.LANCHOR30
	mov	x13, 0
	mul	w12, w12, w1
	ldrh	w1, [x0, 14]
	and	w1, w1, 65280
	mul	w12, w12, w1
	lsl	w22, w12, 1
.L1281:
	mov	w2, w20
	add	x1, x14, x13, lsl 3
	mov	x0, x7
	bl	flash_mem_cmp8
	cbnz	w0, .L1279
	ldrb	w1, [x19]
	cmp	w21, 0
	csel	w2, w12, w22, eq
	add	w0, w1, 1
	strb	w0, [x19]
	str	w2, [x11, x1, lsl 2]
	strb	w13, [x15, x1]
.L1279:
	add	x13, x13, 1
	cmp	x13, 4
	bne	.L1281
	b	.L1282
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
	tbz	x0, 12, .L1295
	adrp	x1, .LANCHOR147
	adrp	x0, .LC78
	mov	w3, 0
	mov	w2, 225
	add	x1, x1, :lo12:.LANCHOR147
	add	x0, x0, :lo12:.LC78
	bl	printf
.L1295:
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
.L1296:
	ldrh	w0, [x20]
	mul	w0, w0, w3
	cmp	w1, w0, lsl 1
	blt	.L1298
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L1298:
	uxtw	x2, w1
	ldr	w0, [x4, x2, lsl 2]
	cmn	w0, #1
	beq	.L1297
	and	x0, x0, 255
	ldrh	w6, [x19, x0, lsl 1]
	strh	w1, [x19, x0, lsl 1]
	strh	w6, [x5, x2, lsl 1]
.L1297:
	add	w1, w1, 1
	and	w1, w1, 65535
	b	.L1296
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
.L1307:
	cmp	w3, w1, uxtb
	bhi	.L1308
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L1308:
	ldrb	w0, [x1, x2]
	add	x1, x1, 1
	ldrb	w5, [x19, 10]
	lsl	w0, w4, w0
	orr	w0, w0, w5
	strb	w0, [x19, 10]
	b	.L1307
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
	bls	.L1311
	bl	ftl_tmp_into_update
.L1311:
	adrp	x19, .LANCHOR10
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	ldr	w1, [x0, 568]
	ldr	w2, [x0, 12]
	add	w1, w1, 860160
	add	w1, w1, 3840
	cmp	w2, w1
	bhi	.L1312
	ldr	x3, [x23, #:lo12:.LANCHOR104]
	ldr	w1, [x0, 572]
	add	w1, w1, 32
	ldr	w3, [x3, 36]
	cmp	w3, w1
	bls	.L1362
.L1312:
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
.L1314:
	ldrh	w0, [x10]
	cmp	w0, w25
	bhi	.L1323
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
	tbz	x3, 10, .L1324
	adrp	x3, .LANCHOR9
	ldrb	w4, [x26, 2]
	ldr	x6, [x3, #:lo12:.LANCHOR9]
	ldr	w3, [x2, x0]
	ldrh	w2, [x2, x0]
	adrp	x0, .LC80
	add	x0, x0, :lo12:.LC80
	ldrh	w7, [x6, x5, lsl 1]
	ubfx	x3, x3, 11, 8
	ldrb	w6, [x26, 3]
	ubfx	x5, x4, 5, 3
	and	w2, w2, 2047
	ubfx	x4, x4, 3, 2
	bl	printf
.L1324:
	ldrb	w0, [x26, 2]
	and	w1, w0, 224
	cmp	w1, 32
	bne	.L1325
	ldr	x2, [x23, #:lo12:.LANCHOR104]
	ldrh	w2, [x2, 688]
	cmp	w2, 2
	bls	.L1325
	adrp	x2, .LANCHOR148
	mov	w3, 1
	str	w3, [x2, #:lo12:.LANCHOR148]
.L1325:
	ldrb	w2, [x26, 2]
	tbz	x2, 3, .L1326
	and	w0, w0, 192
	cmp	w0, 64
	bne	.L1327
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	mov	w1, 0
	mov	w2, 1
	ldrh	w0, [x0, 586]
	bl	gc_add_sblk
	adrp	x0, .LANCHOR64+574
	mov	w1, 1
	strh	w1, [x0, #:lo12:.LANCHOR64+574]
.L1326:
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	ldr	w3, [x25, #:lo12:.LANCHOR14]
	ldr	x2, [x24, #:lo12:.LANCHOR7]
	ldrh	w5, [x0, 584]
	mov	x1, x5
	lsl	x0, x5, 2
	add	x26, x2, x0
	tbz	x3, 10, .L1328
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
.L1328:
	ldrb	w0, [x26, 2]
	tbz	x0, 3, .L1329
	ldrb	w0, [x26, 2]
	and	w1, w0, 192
	cmp	w1, 64
	bne	.L1330
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	mov	w1, 0
	mov	w2, 1
	ldrh	w0, [x0, 584]
	bl	gc_add_sblk
	adrp	x0, .LANCHOR64+574
	mov	w1, 1
	strh	w1, [x0, #:lo12:.LANCHOR64+574]
.L1329:
	ldr	w0, [x25, #:lo12:.LANCHOR14]
	tbz	x0, 10, .L1331
	ldr	w6, [x29, 128]
	adrp	x2, .LANCHOR9
	ldr	x1, [x24, #:lo12:.LANCHOR7]
	ldr	x7, [x2, #:lo12:.LANCHOR9]
	lsl	x0, x6, 2
	add	x5, x1, x0
	ldr	w3, [x1, x0]
	ldrh	w2, [x1, x0]
	adrp	x0, .LC82
	ldrh	w7, [x7, x6, lsl 1]
	add	x0, x0, :lo12:.LC82
	ldrb	w6, [x5, 3]
	ubfx	x3, x3, 11, 8
	ldr	w1, [x29, 128]
	and	w2, w2, 2047
	ldrb	w4, [x5, 2]
	ubfx	x5, x4, 5, 3
	ubfx	x4, x4, 3, 2
	bl	printf
.L1331:
	ldr	w0, [x25, #:lo12:.LANCHOR14]
	tbz	x0, 10, .L1332
	ldr	w6, [x29, 136]
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
	ldr	w1, [x29, 136]
	and	w2, w2, 2047
	ldrb	w4, [x5, 2]
	ubfx	x5, x4, 5, 3
	ubfx	x4, x4, 3, 2
	bl	printf
.L1332:
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
	tbz	x0, 10, .L1333
	adrp	x0, .LC84
	and	w4, w4, 65535
	and	w3, w3, 65535
	mov	w2, w28
	mov	w1, w27
	add	x0, x0, :lo12:.LC84
	bl	printf
.L1333:
	ldr	w0, [x25, #:lo12:.LANCHOR14]
	tbz	x0, 10, .L1334
	adrp	x0, .LANCHOR149
	ldr	w3, [x29, 156]
	mov	w4, w22
	mov	w2, w21
	ldrh	w6, [x0, #:lo12:.LANCHOR149]
	adrp	x0, .LANCHOR150
	mov	w1, w20
	ldrh	w5, [x0, #:lo12:.LANCHOR150]
	adrp	x0, .LC85
	add	x0, x0, :lo12:.LC85
	bl	printf
.L1334:
	sub	w0, w22, w21
	str	w0, [x29, 148]
	adrp	x0, .LANCHOR149
	ldr	w1, [x29, 148]
	ldrh	w0, [x0, #:lo12:.LANCHOR149]
	cmp	w1, w0
	bgt	.L1335
	adrp	x1, .LANCHOR150
	ldr	w0, [x29, 156]
	ldrh	w1, [x1, #:lo12:.LANCHOR150]
	sub	w0, w0, w20
	cmp	w0, w1
	ble	.L1363
.L1335:
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
	adrp	x0, .LANCHOR150
	add	x0, x0, :lo12:.LANCHOR150
	str	x0, [x29, 128]
.L1337:
	ldr	x0, [x29, 136]
	ldr	w1, [x29, 152]
	ldrh	w0, [x0]
	cmp	w1, w0
	bcc	.L1347
.L1346:
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	str	w26, [x0, 580]
.L1336:
	cbz	w21, .L1349
	ldr	x2, [x23, #:lo12:.LANCHOR104]
	adrp	x0, .LANCHOR6
	ldrh	w5, [x0, #:lo12:.LANCHOR6]
	ldr	x0, [x24, #:lo12:.LANCHOR7]
	ldrh	w1, [x2, 134]
	add	x0, x0, x1, uxth 2
.L1350:
	cmp	w1, w5
	bcc	.L1352
	ldrh	w0, [x2, 72]
	add	w0, w21, w0
	strh	w0, [x2, 72]
	ldrh	w0, [x2, 98]
	cmp	w21, w0
	bcs	.L1349
	sub	w21, w0, w21
	strh	w21, [x2, 98]
.L1349:
	cbz	w20, .L1355
	ldr	x2, [x23, #:lo12:.LANCHOR104]
	adrp	x0, .LANCHOR6
	ldrh	w6, [x0, #:lo12:.LANCHOR6]
	ldr	x0, [x24, #:lo12:.LANCHOR7]
	ldrh	w1, [x2, 134]
	add	x0, x0, x1, uxth 2
.L1356:
	cmp	w1, w6
	bcc	.L1358
	ldrh	w0, [x2, 74]
	add	w0, w20, w0
	strh	w0, [x2, 74]
	ldrh	w0, [x2, 96]
	cmp	w20, w0
	bcs	.L1355
	sub	w20, w0, w20
	strh	w20, [x2, 96]
.L1355:
	mov	w1, 5
	mov	w0, 0
	bl	zftl_get_gc_node
	and	w1, w0, 65535
	mov	w2, 65535
	cmp	w1, w2
	beq	.L1313
	adrp	x2, .LANCHOR9
	ubfiz	x1, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR9]
	ldrh	w2, [x2, x1]
	adrp	x1, .LANCHOR87
	ldrh	w1, [x1, #:lo12:.LANCHOR87]
	cmp	w2, w1
	bhi	.L1313
	add	w22, w22, 1
	mov	w2, 1
	mov	w1, 0
	bl	gc_add_sblk
.L1313:
	add	w0, w22, w27
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 160
	ret
.L1323:
	uxtw	x7, w25
	ldr	x6, [x24, #:lo12:.LANCHOR7]
	lsl	x2, x7, 2
	add	x11, x6, x2
	ldrb	w0, [x11, 2]
	and	w1, w0, 224
	cmp	w1, 224
	beq	.L1315
	ubfx	x4, x0, 3, 2
	tbz	x4, 0, .L1316
	ldr	w0, [x6, x2]
	ldrh	w1, [x6, x2]
	ubfx	x0, x0, 11, 8
	and	w1, w1, 2047
.L1317:
	ldr	w3, [x29, 148]
	add	w27, w27, 1
	and	w27, w27, 65535
	cmp	w20, w1
	add	w3, w3, w1
	str	w3, [x29, 148]
	bls	.L1361
	ldr	x3, [x19, #:lo12:.LANCHOR10]
	mov	w20, w1
	strh	w25, [x3, 586]
.L1361:
	ldr	w3, [x29, 156]
	cmp	w3, w1
	bcs	.L1320
	str	w25, [x29, 128]
	str	w1, [x29, 156]
.L1320:
	mov	w3, 65535
	cmp	w0, w3
	bne	.L1319
.L1321:
	cmp	w0, 9
	ccmp	w1, 9, 0, hi
	bhi	.L1315
	ldr	w0, [x8]
	tbz	x0, 8, .L1315
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
	adrp	x0, .LC79
	ubfx	x5, x5, 5, 3
	add	x0, x0, :lo12:.LC79
	bl	printf
	ldp	x8, x10, [x29, 112]
.L1315:
	add	w25, w25, 1
	and	w25, w25, 65535
	b	.L1314
.L1316:
	tst	w0, 24
	bne	.L1318
	ldrh	w1, [x6, x2]
	mov	w0, 65535
	and	w1, w1, 2047
	b	.L1317
.L1318:
	ldr	w0, [x6, x2]
	mov	w1, 65535
	ubfx	x0, x0, 11, 8
.L1319:
	ldr	w3, [x29, 152]
	add	w28, w28, 1
	and	w28, w28, 65535
	cmp	w21, w0
	add	w3, w3, w0
	str	w3, [x29, 152]
	bls	.L1322
	ldr	x3, [x19, #:lo12:.LANCHOR10]
	mov	w21, w0
	strh	w25, [x3, 584]
.L1322:
	cmp	w22, w0
	bcs	.L1321
	mov	w22, w0
	str	w25, [x29, 136]
	b	.L1321
.L1327:
	cbnz	w1, .L1326
	ldr	x1, [x19, #:lo12:.LANCHOR10]
	mov	w0, 65535
	ldrh	w2, [x1, 590]
	cmp	w2, w0
	bne	.L1326
	ldrh	w0, [x1, 586]
	ldrh	w1, [x1, 588]
	cmp	w1, w0
	beq	.L1326
	bl	zftl_remove_free_node
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	ldrh	w1, [x0, 586]
	strh	w1, [x0, 590]
	mov	w1, -1
	strh	w1, [x0, 586]
	b	.L1326
.L1330:
	and	w0, w0, 248
	cmp	w0, 16
	bne	.L1329
	ldr	x1, [x19, #:lo12:.LANCHOR10]
	mov	w0, 65535
	ldrh	w2, [x1, 588]
	cmp	w2, w0
	bne	.L1329
	ldrh	w0, [x1, 584]
	ldrh	w1, [x1, 590]
	cmp	w1, w0
	beq	.L1329
	bl	zftl_remove_free_node
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	ldrh	w1, [x0, 584]
	strh	w1, [x0, 588]
	mov	w1, -1
	strh	w1, [x0, 584]
	b	.L1329
.L1347:
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
	beq	.L1339
	and	w2, w0, 224
	cmp	w2, 224
	beq	.L1339
	ubfx	x0, x0, 3, 2
	and	w1, w0, 1
	tbz	x0, 0, .L1340
	cmp	w2, 160
.L1427:
	bne	.L1342
	adrp	x0, .LANCHOR149
	ldr	w2, [x29, 148]
	ldrh	w0, [x0, #:lo12:.LANCHOR149]
	cmp	w2, w0
	ble	.L1343
	ldr	w0, [x4, x3]
	ubfx	x0, x0, 11, 8
	cmp	w0, w21
	bls	.L1344
	cbz	w1, .L1343
	ldrh	w0, [x4, x3]
	and	w0, w0, 2047
	cmp	w0, w20
	bgt	.L1343
.L1344:
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
	tbz	x0, 10, .L1343
	adrp	x0, .LANCHOR9
	ldr	w6, [x4, x3]
	ldrh	w5, [x4, x3]
	ldr	x1, [x0, #:lo12:.LANCHOR9]
	ldr	x0, [x24, #:lo12:.LANCHOR7]
	ubfx	x6, x6, 11, 8
	ldrh	w4, [x28, 56]
	and	w5, w5, 2047
	add	x3, x0, x3
	adrp	x0, .LC86
	add	x0, x0, :lo12:.LC86
	ldrb	w2, [x3, 2]
	ldrh	w3, [x1, x8, lsl 1]
	mov	w1, w26
	ubfx	x2, x2, 5, 3
.L1428:
	bl	printf
.L1343:
	cmp	w22, 4
	ccmp	w27, 4, 2, ls
	bhi	.L1346
.L1339:
	ldr	w0, [x29, 152]
	add	w0, w0, 1
	and	w0, w0, 65535
	str	w0, [x29, 152]
	b	.L1337
.L1340:
	cmp	w0, 2
	b	.L1427
.L1342:
	ldr	x2, [x29, 128]
	ldr	w0, [x29, 156]
	sub	w0, w0, w20
	ldrh	w2, [x2]
	cmp	w0, w2
	ble	.L1343
	ldrh	w0, [x4, x3]
	add	w2, w20, 8
	and	w0, w0, 2047
	cmp	w0, w2
	ble	.L1345
	cbz	w1, .L1343
	ldr	w0, [x4, x3]
	add	w1, w21, 4
	ubfx	x0, x0, 11, 8
	cmp	w0, w1
	bgt	.L1343
.L1345:
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
	tbz	x0, 10, .L1343
	adrp	x0, .LANCHOR9
	ldr	w6, [x4, x3]
	ldrh	w5, [x4, x3]
	ldr	x1, [x0, #:lo12:.LANCHOR9]
	ldr	x0, [x24, #:lo12:.LANCHOR7]
	ubfx	x6, x6, 11, 8
	and	w5, w5, 2047
	ldrh	w4, [x28, 56]
	add	x3, x0, x3
	adrp	x0, .LC87
	add	x0, x0, :lo12:.LC87
	ldrb	w2, [x3, 2]
	ldrh	w3, [x1, x8, lsl 1]
	mov	w1, w26
	ubfx	x2, x2, 5, 3
	b	.L1428
.L1363:
	mov	w27, 0
	mov	w22, 0
	b	.L1336
.L1352:
	ldr	w3, [x0]
	ubfx	x4, x3, 11, 8
	cmp	w21, w4
	bhi	.L1351
	ldrb	w6, [x0, 2]
	tst	w6, 24
	beq	.L1351
	sub	w4, w4, w21
	bfi	w3, w4, 11, 8
	str	w3, [x0]
.L1351:
	add	w1, w1, 1
	add	x0, x0, 4
	and	w1, w1, 65535
	b	.L1350
.L1358:
	ldrh	w3, [x0]
	and	w4, w3, 2047
	cmp	w4, w20
	blt	.L1357
	ldrb	w5, [x0, 2]
	and	w5, w5, 24
	cmp	w5, 16
	beq	.L1357
	sub	w4, w4, w20
	bfi	w3, w4, 0, 11
	strh	w3, [x0]
.L1357:
	add	w1, w1, 1
	add	x0, x0, 4
	and	w1, w1, 65535
	b	.L1356
.L1362:
	mov	w27, 0
	mov	w22, 0
	b	.L1313
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
	adrp	x27, .LC88
	add	x27, x27, :lo12:.LC88
	stp	x3, x2, [x29, 104]
	stp	x4, x5, [x29, 120]
	stp	x6, x7, [x29, 136]
	stp	x8, x10, [x29, 152]
	str	x0, [x29, 176]
.L1430:
	ldr	x0, [x29, 176]
	ldrh	w0, [x0]
	cmp	w26, w0
	blt	.L1446
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
.L1446:
	ldr	x4, [x28, #:lo12:.LANCHOR7]
	sxtw	x2, w26
	add	x4, x4, x2, lsl 2
	ldrb	w6, [x4, 3]
	cbz	w6, .L1447
	ldr	x0, [x29, 112]
	mov	w1, 0
	ldr	x7, [x25, #:lo12:.LANCHOR104]
	ldrb	w8, [x0, #:lo12:.LANCHOR80]
	ldr	x0, [x29, 104]
	ldrh	w10, [x0, #:lo12:.LANCHOR79]
	mov	w0, 0
.L1432:
	cmp	w1, w8
	blt	.L1435
	cbz	w0, .L1436
	mov	w1, 32768
	sdiv	w0, w1, w0
	add	w0, w0, 1
	sxth	w0, w0
.L1431:
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
	beq	.L1437
	adrp	x5, .LANCHOR10
	ldr	x5, [x5, #:lo12:.LANCHOR10]
	ldrh	w6, [x5, 16]
	cmp	w26, w6
	beq	.L1437
	ldrh	w6, [x5, 48]
	cmp	w26, w6
	beq	.L1437
	ldrh	w5, [x5, 80]
	cmp	w26, w5
	beq	.L1437
	cmp	w0, 64
	bne	.L1438
	ldr	x0, [x29, 128]
	add	x2, x21, :lo12:.LANCHOR92
	mov	w1, w26
	add	x0, x0, :lo12:.LANCHOR12
.L1450:
	bl	_insert_data_list
.L1437:
	add	w3, w26, 1
	sxth	w26, w3
	b	.L1430
.L1435:
	asr	w5, w6, w1
	tbnz	x5, 0, .L1433
	add	w0, w10, w0
	sxth	w0, w0
.L1434:
	add	w1, w1, 1
	b	.L1432
.L1433:
	ldrh	w5, [x7, 146]
	add	w5, w5, 1
	strh	w5, [x7, 146]
	b	.L1434
.L1436:
	ldrb	w1, [x4, 2]
	mov	w5, -1
	orr	w1, w1, -32
	strb	w1, [x4, 2]
	adrp	x1, .LANCHOR9
	ldr	x1, [x1, #:lo12:.LANCHOR9]
	strh	w5, [x1, x2, lsl 1]
	b	.L1431
.L1447:
	ldr	w0, [x29, 188]
	b	.L1431
.L1438:
	cmp	w0, 96
	bne	.L1439
	ldr	x0, [x29, 136]
	add	x2, x19, :lo12:.LANCHOR90
	mov	w1, w26
	add	x0, x0, :lo12:.LANCHOR83
	b	.L1450
.L1439:
	cmp	w0, 160
	bne	.L1440
	ldr	x0, [x29, 120]
	add	x2, x20, :lo12:.LANCHOR94
	mov	w1, w26
	add	x0, x0, :lo12:.LANCHOR82
	b	.L1450
.L1440:
	cbnz	w0, .L1437
	adrp	x0, .LANCHOR9
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrh	w2, [x0, x2, lsl 1]
	cbz	w2, .L1441
	str	x4, [x29, 96]
	mov	w1, w26
	mov	x0, x27
	bl	printf
	ldr	x4, [x29, 96]
	ldrb	w0, [x4, 2]
	tbz	x0, 4, .L1442
	mov	w1, 5
.L1449:
	bfi	w0, w1, 5, 3
	strb	w0, [x4, 2]
	mov	w2, 0
	mov	w1, 1
	mov	w0, w26
	bl	gc_add_sblk
	b	.L1437
.L1442:
	mov	w1, 2
	b	.L1449
.L1441:
	ands	w1, w1, 24
	bne	.L1444
	ldr	x0, [x29, 160]
	add	x2, x24, :lo12:.LANCHOR97
	mov	w1, w26
	add	x0, x0, :lo12:.LANCHOR98
.L1451:
	bl	_insert_free_list
	b	.L1437
.L1444:
	cmp	w1, 16
	bne	.L1445
	ldr	x0, [x29, 152]
	add	x2, x23, :lo12:.LANCHOR99
	mov	w1, w26
	add	x0, x0, :lo12:.LANCHOR100
	b	.L1451
.L1445:
	ldr	x0, [x29, 144]
	add	x2, x22, :lo12:.LANCHOR101
	mov	w1, w26
	add	x0, x0, :lo12:.LANCHOR102
	b	.L1451
	.size	zftl_sblk_list_init, .-zftl_sblk_list_init
	.section	.text.ftl_open_sblk_init,"ax",@progbits
	.align	2
	.global	ftl_open_sblk_init
	.type	ftl_open_sblk_init, %function
ftl_open_sblk_init:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR80
	stp	x21, x22, [sp, 32]
	mov	x19, x0
	stp	x23, x24, [sp, 48]
	adrp	x21, .LC76
	adrp	x23, .LANCHOR87
	mov	w22, w1
	add	x23, x23, :lo12:.LANCHOR87
	add	x20, x20, :lo12:.LANCHOR80
	add	x21, x21, :lo12:.LC76
	stp	x25, x26, [sp, 64]
.L1453:
.L1456:
	mov	w0, w22
	bl	ftl_alloc_sblk
	mov	w1, 0
	and	w24, w0, 65535
	bl	ftl_erase_sblk
	add	x1, x19, 16
	mov	w0, w24
	bl	ftl_get_blk_list_in_sblk
	and	w0, w0, 255
	ldrh	w1, [x23]
	cmp	w22, 2
	strb	w0, [x19, 9]
	strh	w24, [x19]
	strh	wzr, [x19, 2]
	mul	w0, w1, w0
	strb	wzr, [x19, 5]
	strh	w0, [x19, 6]
	strh	wzr, [x19, 10]
	strb	w22, [x19, 4]
	beq	.L1457
	ldrb	w0, [x20]
	mul	w0, w1, w0
	and	w0, w0, 65535
.L1454:
	ldrb	w2, [x20]
	adrp	x26, .LANCHOR9
	strh	w0, [x19, 12]
	ubfiz	x25, x24, 1, 16
	mul	w2, w2, w1
	adrp	x1, .LANCHOR111
	ldr	x3, [x1, #:lo12:.LANCHOR111]
	mov	w1, 255
	lsl	w2, w2, 2
	add	x0, x3, x0, uxth 2
	bl	ftl_memset
	ldr	x0, [x26, #:lo12:.LANCHOR9]
	ldrh	w1, [x19, 6]
	strh	w1, [x0, x25]
	ldrb	w0, [x19, 9]
	cbnz	w0, .L1452
	mov	w1, w24
	mov	x0, x21
	bl	printf
	ldr	x0, [x26, #:lo12:.LANCHOR9]
	mov	w1, -1
	strh	w1, [x0, x25]
	mov	w0, 7
	strb	w0, [x19, 4]
	b	.L1456
.L1457:
	mov	w0, 0
	b	.L1454
.L1452:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
	.size	ftl_open_sblk_init, .-ftl_open_sblk_init
	.section	.text.pm_free_sblk,"ax",@progbits
	.align	2
	.global	pm_free_sblk
	.type	pm_free_sblk, %function
pm_free_sblk:
	stp	x29, x30, [sp, -384]!
	adrp	x0, .LANCHOR151
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	ldrh	w1, [x0, #:lo12:.LANCHOR151]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	cmp	w1, 128
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	bls	.L1460
	adrp	x1, .LANCHOR152
	adrp	x0, .LC0
	mov	w2, 88
	add	x1, x1, :lo12:.LANCHOR152
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1460:
	adrp	x5, .LANCHOR104
	mov	x26, x5
	ldrh	w3, [x19, #:lo12:.LANCHOR151]
	mov	w1, 0
	ldr	x0, [x5, #:lo12:.LANCHOR104]
	mov	w19, 0
	mov	w4, 65535
	add	x0, x0, 416
	ldrh	w2, [x0, 272]
.L1463:
	ldrh	w6, [x0]
	cmp	w6, w4
	beq	.L1461
	add	w1, w1, 1
	and	w1, w1, 65535
.L1461:
	cmp	w1, w2
	bcs	.L1462
	cmp	w1, w3
	bcs	.L1462
	add	w19, w19, 1
	add	x0, x0, 2
	and	w19, w19, 65535
	cmp	w19, 128
	bne	.L1463
.L1462:
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
.L1465:
	cmp	x1, x4
	bne	.L1468
	adrp	x24, .LANCHOR80
	adrp	x25, .LANCHOR87
	adrp	x27, .LC89
	adrp	x28, .LANCHOR14
	ldrb	w21, [x24, #:lo12:.LANCHOR80]
	add	x23, x23, :lo12:.LANCHOR69
	ldrh	w0, [x25, #:lo12:.LANCHOR87]
	add	x27, x27, :lo12:.LC89
	add	x28, x28, :lo12:.LANCHOR14
	mov	x20, 0
	mov	w7, 65535
	str	wzr, [x29, 124]
	mul	w21, w21, w0
	and	w21, w21, 65535
.L1474:
	ldr	x0, [x26, #:lo12:.LANCHOR104]
	and	w6, w20, 65535
	ldrb	w2, [x23]
	mov	w8, w20
	add	x1, x0, x20, sxtw 1
	ldrh	w3, [x1, 416]
	ldrh	w1, [x0, 692]
	sdiv	w1, w1, w2
	cmp	w1, w3
	bne	.L1469
	ldrb	w1, [x24, #:lo12:.LANCHOR80]
	ldrh	w2, [x25, #:lo12:.LANCHOR87]
	mul	w1, w1, w2
	strh	w1, [x22, x20, lsl 1]
.L1469:
	ldrh	w2, [x22, x20, lsl 1]
	cmp	w2, w21
	bcs	.L1470
	cmp	w2, 0
	ldr	w1, [x29, 124]
	csel	w21, w21, w2, eq
	csel	w1, w1, w6, eq
	str	w1, [x29, 124]
.L1470:
	ldrh	w1, [x0, 74]
	cmp	w1, 2
	bls	.L1471
	mov	w1, 65535
	cmp	w3, w1
	beq	.L1471
	adrp	x4, .LANCHOR7
	ubfiz	x1, x3, 2, 16
	ldrh	w0, [x0, 92]
	ldr	x4, [x4, #:lo12:.LANCHOR7]
	add	w0, w0, 4
	ldrh	w4, [x4, x1]
	and	w4, w4, 2047
	cmp	w4, w0
	bgt	.L1471
	mov	w1, w8
	str	w6, [x29, 104]
	str	w8, [x29, 112]
	mov	x0, x27
	bl	printf
	ldr	w6, [x29, 104]
	ldr	w8, [x29, 112]
	mov	w7, w6
.L1471:
	ldrh	w0, [x22, x20, lsl 1]
	cbnz	w0, .L1472
	ldr	x0, [x26, #:lo12:.LANCHOR104]
	sxtw	x6, w8
	add	x1, x6, 208
	ldrh	w3, [x0, x1, lsl 1]
	mov	w1, 65535
	cmp	w3, w1
	beq	.L1472
	ldr	w1, [x28]
	tbz	x1, 12, .L1473
	ldrh	w4, [x0, 688]
	mov	w2, 0
	str	x6, [x29, 104]
	mov	w1, w8
	str	w7, [x29, 112]
	adrp	x0, .LC90
	add	x0, x0, :lo12:.LC90
	bl	printf
	ldr	w7, [x29, 112]
	ldr	x6, [x29, 104]
.L1473:
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
.L1472:
	add	x20, x20, 1
	cmp	w19, w20, uxth
	bhi	.L1474
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
.L1468:
	ldr	w0, [x4]
	add	x7, x6, 416
	mov	x3, 0
	lsr	w0, w0, w10
	and	w0, w0, w2
	udiv	w0, w0, w11
	and	w0, w0, 65535
.L1467:
	ldrh	w8, [x7]
	cmp	w8, w0
	bne	.L1466
	ldrh	w8, [x22, x3, lsl 1]
	add	w8, w8, 1
	strh	w8, [x22, x3, lsl 1]
.L1466:
	add	x3, x3, 1
	add	x7, x7, 2
	cmp	w19, w3, uxth
	bhi	.L1467
	add	x4, x4, 4
	b	.L1465
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
	tbz	x0, 12, .L1487
	adrp	x2, .LANCHOR153
	adrp	x0, .LC91
	add	x2, x2, :lo12:.LANCHOR153
	mov	w1, 105
	add	x0, x0, :lo12:.LC91
	bl	printf
.L1487:
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
.L1493:
	cmp	w2, w3
	bhi	.L1494
	ret
.L1494:
	ldr	w4, [x1, x3, lsl 2]
	str	w4, [x0, x3, lsl 2]
	add	x3, x3, 1
	b	.L1493
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
	tbz	x0, 12, .L1499
	adrp	x1, .LANCHOR154
	adrp	x0, .LC92
	mov	x2, x19
	add	x1, x1, :lo12:.LANCHOR154
	add	x0, x0, :lo12:.LC92
	bl	printf
.L1499:
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
	bne	.L1500
	mov	w0, 8
	strb	w0, [x20, #:lo12:.LANCHOR28]
.L1500:
	ldr	w1, [x19, 128]
	mov	w0, 12336
	movk	w0, 0x5639, lsl 16
	cmp	w1, w0
	bne	.L1501
	mov	w0, 9
	strb	w0, [x20, #:lo12:.LANCHOR28]
.L1501:
	ldrb	w0, [x20, #:lo12:.LANCHOR28]
	cmp	w0, 9
	adrp	x0, .LANCHOR47
	bne	.L1502
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
	tbz	x0, 12, .L1504
	ldr	w1, [x19]
	ldr	w2, [x19, 8]
	ldr	w3, [x19, 80]
	ldr	w4, [x19, 84]
	ldr	w5, [x19, 88]
.L1517:
	adrp	x0, .LC93
	add	x0, x0, :lo12:.LC93
	bl	printf
.L1504:
	adrp	x0, .LANCHOR48
	mov	w1, 1
	strb	w1, [x0, #:lo12:.LANCHOR48]
	adrp	x0, .LANCHOR50
	strh	wzr, [x0, #:lo12:.LANCHOR50]
	adrp	x0, .LANCHOR46
	strb	wzr, [x0, #:lo12:.LANCHOR46]
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L1498
	ldrb	w1, [x20, #:lo12:.LANCHOR28]
	adrp	x0, .LC94
	add	x0, x0, :lo12:.LC94
	bl	printf
.L1498:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L1502:
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
	tbz	x0, 12, .L1504
	ldr	x0, [x22, #:lo12:.LANCHOR13]
	ldr	w1, [x0]
	ldr	w2, [x0, 344]
	ldr	w3, [x0, 304]
	ldr	w4, [x0, 308]
	ldr	w5, [x0, 312]
	b	.L1517
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
	adrp	x22, .LANCHOR126
	add	x22, x22, :lo12:.LANCHOR126
	mov	w21, 0
.L1519:
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
	bne	.L1519
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
	adrp	x0, .LANCHOR155
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR64
	strb	wzr, [x0, #:lo12:.LANCHOR155]
	adrp	x0, .LANCHOR156
	add	x19, x20, :lo12:.LANCHOR64
	str	wzr, [x0, #:lo12:.LANCHOR156]
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
	adrp	x1, .LANCHOR157
	str	x0, [x1, #:lo12:.LANCHOR157]
	ldrb	w1, [x19, #:lo12:.LANCHOR80]
	ldrh	w0, [x20, #:lo12:.LANCHOR79]
	mul	w0, w0, w1
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR158
	str	x0, [x1, #:lo12:.LANCHOR158]
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
	adrp	x1, .LANCHOR159
	ldp	x19, x20, [sp, 16]
	str	x0, [x1, #:lo12:.LANCHOR159]
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
.L1526:
	cmp	w1, w3
	bhi	.L1527
	ret
.L1527:
	lsr	w2, w0, 2
	ldrb	w5, [x4, x3]
	add	w2, w2, w0, lsl 5
	add	x3, x3, 1
	add	w2, w2, w5
	eor	w0, w0, w2
	b	.L1526
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
	adrp	x21, .LC96
	stp	x23, x24, [sp, 48]
	mov	x22, x1
	stp	x25, x26, [sp, 64]
	adrp	x23, .LC95
	mov	x26, x0
	mov	w24, w2
	uxtw	x25, w3
	add	x23, x23, :lo12:.LC95
	add	x21, x21, :lo12:.LC96
	stp	x19, x20, [sp, 16]
	str	x27, [sp, 80]
	mov	x19, 0
	mov	w20, 0
	adrp	x27, .LC97
.L1534:
	cmp	x25, x19
	bne	.L1540
	ldp	x19, x20, [sp, 16]
	adrp	x1, .LC97
	ldp	x21, x22, [sp, 32]
	add	x1, x1, :lo12:.LC97
	ldp	x23, x24, [sp, 48]
	adrp	x0, .LC98
	ldp	x25, x26, [sp, 64]
	add	x0, x0, :lo12:.LC98
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 96
	b	printf
.L1540:
	cbnz	w20, .L1535
	mov	w2, w19
	mov	x1, x26
	mov	x0, x23
	bl	printf
.L1535:
	cmp	w24, 4
	bne	.L1536
	ldr	w1, [x22, x19, lsl 2]
.L1542:
	mov	x0, x21
	add	w20, w20, 1
	bl	printf
	cmp	w20, 15
	bls	.L1539
	mov	w20, 0
	add	x1, x27, :lo12:.LC97
	adrp	x0, .LC98
	add	x0, x0, :lo12:.LC98
	bl	printf
.L1539:
	add	x19, x19, 1
	b	.L1534
.L1536:
	cmp	w24, 2
	bne	.L1538
	ldrsh	w1, [x22, x19, lsl 1]
	b	.L1542
.L1538:
	ldrb	w1, [x22, x19]
	b	.L1542
	.size	rknand_print_hex, .-rknand_print_hex
	.section	.text.hynix_get_read_retry_default,"ax",@progbits
	.align	2
	.global	hynix_get_read_retry_default
	.type	hynix_get_read_retry_default, %function
hynix_get_read_retry_default:
	stp	x29, x30, [sp, -96]!
	mov	w10, w0
	adrp	x0, .LANCHOR27
	mov	w2, -83
	add	x29, sp, 0
	ldr	x8, [x0, #:lo12:.LANCHOR27]
	mov	w0, -84
	stp	x19, x20, [sp, 16]
	mov	w1, -82
	stp	x21, x22, [sp, 32]
	add	x6, x8, 128
	stp	x23, x24, [sp, 48]
	add	x13, x8, 112
	stp	x25, x26, [sp, 64]
	cmp	w10, 2
	str	x27, [sp, 80]
	strb	w0, [x8, 128]
	mov	w0, -81
	strb	w10, [x8, 112]
	strb	w2, [x8, 129]
	strb	w1, [x8, 130]
	strb	w0, [x8, 131]
	bne	.L1544
	mov	w0, -89
	strb	w0, [x13, 16]
	adrp	x0, .LANCHOR160+17
	mov	w1, -9
	strb	w1, [x0, #:lo12:.LANCHOR160+17]
.L1608:
	mov	w24, 7
	b	.L1651
.L1544:
	cmp	w10, 3
	bne	.L1546
	mov	x11, 0
.L1547:
	sub	w0, w11, #80
	strb	w0, [x6, x11]
	add	x11, x11, 1
	cmp	x11, 8
	bne	.L1547
	mov	w24, w11
.L1545:
	sub	w0, w10, #1
	cmp	w0, 1
	bhi	.L1553
	adrp	x7, .LANCHOR18
	adrp	x8, .LANCHOR30
	add	x7, x7, :lo12:.LANCHOR18
	add	x8, x8, :lo12:.LANCHOR30
	mov	w5, 0
	mov	w10, 55
.L1554:
	ldrb	w0, [x7]
	cmp	w0, w5
	bhi	.L1560
.L1561:
	strb	w11, [x13, 1]
	strb	w24, [x13, 2]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L1546:
	cmp	w10, 4
	bne	.L1548
	mov	w3, -52
	strb	w3, [x8, 128]
	mov	w3, -65
	strb	w3, [x8, 129]
	mov	w3, -86
	strb	w3, [x8, 130]
	mov	w3, -85
	mov	w24, 8
	strb	w3, [x8, 131]
	mov	w11, w24
	mov	w3, -51
	strb	w2, [x8, 133]
	strb	w3, [x8, 132]
	strb	w1, [x8, 134]
	strb	w0, [x8, 135]
	b	.L1545
.L1548:
	cmp	w10, 5
	bne	.L1549
	mov	w0, 56
	strb	w0, [x8, 128]
	mov	w0, 57
	strb	w0, [x8, 129]
	mov	w0, 58
	mov	w24, 8
	strb	w0, [x8, 130]
	mov	w0, 59
	strb	w0, [x8, 131]
.L1651:
	mov	w11, 4
	b	.L1545
.L1549:
	cmp	w10, 6
	bne	.L1550
	mov	w0, 14
	strb	w0, [x8, 128]
	mov	w0, 15
	strb	w0, [x8, 129]
	mov	w0, 16
	mov	w24, 12
	strb	w0, [x8, 130]
	mov	w0, 17
	strb	w0, [x8, 131]
	b	.L1651
.L1550:
	cmp	w10, 7
	bne	.L1551
	mov	x0, 0
.L1552:
	sub	w1, w0, #80
	strb	w1, [x6, x0]
	add	x0, x0, 1
	cmp	x0, 8
	bne	.L1552
	mov	w0, -44
	mov	w24, 12
	strb	w0, [x8, 136]
	mov	w11, 10
	mov	w0, -43
	strb	w0, [x8, 137]
	b	.L1545
.L1551:
	cmp	w10, 8
	bne	.L1608
	mov	w0, 6
	strb	w0, [x8, 128]
	mov	w0, 7
	strb	w0, [x8, 129]
	mov	w0, 9
	strb	w10, [x8, 130]
	strb	w0, [x8, 131]
	mov	w24, 50
	mov	w0, 10
	mov	w11, 5
	strb	w0, [x8, 132]
	b	.L1545
.L1560:
	ldrb	w0, [x8, w5, sxtw]
	mov	x1, 32
	mov	w2, 160
	mov	x3, 0
	umaddl	x2, w2, w0, x1
	adrp	x1, .LANCHOR13
	ubfiz	x0, x0, 8, 8
	ldr	x4, [x1, #:lo12:.LANCHOR13]
	add	x2, x13, x2
	add	x4, x4, x0
.L1555:
	str	w10, [x4, 2056]
	ldrb	w0, [x6, x3]
	str	w0, [x4, 2052]
	mov	w0, 80
	bl	timer_delay_ns
	ldr	w0, [x4, 2048]
	strb	w0, [x2, x3]
	add	x3, x3, 1
	cmp	w11, w3, uxtb
	bhi	.L1555
	adrp	x3, .LANCHOR160
	add	x3, x3, :lo12:.LANCHOR160
	mov	x0, 0
.L1558:
	add	x14, x2, x0
	add	x12, x3, x0
	mov	x1, 1
.L1557:
	lsl	x4, x1, 2
	lsl	x15, x1, 3
	ldrb	w16, [x2, x0]
	add	x1, x1, 1
	cmp	x1, 7
	ldrb	w4, [x12, x4]
	add	w4, w4, w16
	strb	w4, [x14, x15]
	bne	.L1557
	add	x0, x0, 1
	cmp	x0, 4
	bne	.L1558
	add	w5, w5, 1
	strb	wzr, [x2, 16]
	strb	wzr, [x2, 24]
	and	w5, w5, 255
	strb	wzr, [x2, 32]
	strb	wzr, [x2, 40]
	strb	wzr, [x2, 48]
	strb	wzr, [x2, 41]
	strb	wzr, [x2, 49]
	b	.L1554
.L1553:
	sub	w0, w10, #3
	cmp	w0, 5
	bhi	.L1561
	mul	w19, w24, w11
	sub	w14, w11, #1
	and	x14, x14, 255
	adrp	x20, .LANCHOR18
	sub	w21, w10, #5
	add	x20, x20, :lo12:.LANCHOR18
	asr	w15, w19, 1
	add	x14, x14, 1
	lsl	w19, w19, 4
	lsl	w23, w15, 1
	sbfiz	x22, x15, 1, 32
	mov	w12, 0
.L1562:
	ldrb	w0, [x20]
	cmp	w0, w12
	bls	.L1561
	adrp	x0, .LANCHOR30
	add	x0, x0, :lo12:.LANCHOR30
	ldrb	w25, [x0, w12, sxtw]
	mov	w0, w25
	bl	zftl_flash_exit_slc_mode
	adrp	x0, .LANCHOR13
	mov	x5, 32
	mov	w1, 160
	mov	w6, 255
	ldr	x4, [x0, #:lo12:.LANCHOR13]
	nop // between mem op and mult-accumulate
	umaddl	x1, w1, w25, x5
	ubfiz	x25, x25, 8, 8
	add	x4, x4, x25
	add	x5, x13, x1
	str	w6, [x4, 2056]
	bl	nandc_wait_flash_ready
	cmp	w10, 8
	bne	.L1563
	mov	w0, 120
	str	w0, [x4, 2056]
	str	wzr, [x4, 2052]
	mov	w0, 23
	str	wzr, [x4, 2052]
	mov	w1, 25
	str	wzr, [x4, 2052]
	add	x5, x8, 144
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
.L1654:
	str	w0, [x4, 2052]
	mov	w0, 48
	str	wzr, [x4, 2052]
	str	w0, [x4, 2056]
	bl	nandc_wait_flash_ready
	cmp	w21, 1
	ccmp	w10, 8, 4, hi
	beq	.L1609
	cmp	w10, 7
	mov	w0, 32
	mov	w1, 2
	csel	w1, w1, w0, ne
.L1570:
	adrp	x6, .LANCHOR161
	mov	x2, 0
	ldr	x0, [x6, #:lo12:.LANCHOR161]
.L1571:
	ldr	w3, [x4, 2048]
	strb	w3, [x0, x2]
	add	x2, x2, 1
	cmp	w1, w2, uxtb
	bhi	.L1571
	cmp	w10, 8
	bne	.L1572
	mov	w1, 0
.L1574:
	ldrb	w2, [x0]
	cmp	w2, 50
	beq	.L1573
	ldrb	w2, [x0, 1]
	cmp	w2, 5
	beq	.L1573
	add	w1, w1, 1
	add	x0, x0, 4
	and	w1, w1, 255
	cmp	w1, 8
	bne	.L1574
.L1575:
	adrp	x0, .LC99
	mov	w1, 0
	add	x0, x0, :lo12:.LC99
	bl	printf
.L1577:
	b	.L1577
.L1563:
	mov	w0, 54
	str	w0, [x4, 2056]
	cmp	w10, 4
	bne	.L1565
	mov	w0, 64
	str	w6, [x4, 2052]
	str	w0, [x4, 2048]
	mov	w0, 204
.L1652:
	str	w0, [x4, 2052]
	mov	w0, 77
	b	.L1653
.L1565:
	cmp	w21, 1
	bhi	.L1567
	ldrb	w0, [x8, 128]
	str	w0, [x4, 2052]
	mov	w0, 82
.L1653:
	str	w0, [x4, 2048]
.L1566:
	mov	w0, 22
	str	w0, [x4, 2056]
	mov	w0, 23
	str	w0, [x4, 2056]
	mov	w0, 4
	str	w0, [x4, 2056]
	mov	w0, 25
	str	w0, [x4, 2056]
	str	wzr, [x4, 2056]
	cmp	w10, 6
	str	wzr, [x4, 2052]
	str	wzr, [x4, 2052]
	bne	.L1568
	mov	w0, 31
	str	w0, [x4, 2052]
.L1569:
	mov	w0, 2
	b	.L1654
.L1567:
	cmp	w10, 7
	bne	.L1566
	mov	w0, 174
	str	w0, [x4, 2052]
	str	wzr, [x4, 2048]
	mov	w0, 176
	b	.L1652
.L1568:
	str	wzr, [x4, 2052]
	b	.L1569
.L1609:
	mov	w1, 16
	b	.L1570
.L1573:
	cmp	w1, 6
	bhi	.L1575
.L1576:
	ldr	x3, [x6, #:lo12:.LANCHOR161]
	mov	x0, 0
.L1586:
	cmp	w19, w0
	bgt	.L1587
	ldr	x1, [x6, #:lo12:.LANCHOR161]
	mov	w6, 8
	add	x2, x1, x22
.L1589:
	mov	x0, 0
.L1588:
	ldrh	w7, [x2, x0, lsl 1]
	mvn	w7, w7
	strh	w7, [x2, x0, lsl 1]
	add	x0, x0, 1
	cmp	w15, w0
	bgt	.L1588
	add	x2, x2, x23, uxtw 1
	subs	w6, w6, #1
	bne	.L1589
	mov	x6, x1
	mov	w7, 0
	mov	w26, 1
.L1590:
	mov	w0, 0
	mov	w2, 0
.L1594:
	mov	x25, x6
	lsl	w30, w26, w2
	mov	w17, 16
	mov	w16, 0
.L1592:
	ldrh	w27, [x25]
	add	x25, x25, x22
	bics	wzr, w30, w27
	cinc	w16, w16, eq
	subs	w17, w17, #1
	bne	.L1592
	cmp	w16, 8
	bls	.L1593
	orr	w0, w0, w30
	and	w0, w0, 65535
.L1593:
	add	w2, w2, 1
	cmp	w2, 16
	bne	.L1594
	strh	w0, [x6], 2
	add	w7, w7, 1
	cmp	w15, w7
	bgt	.L1590
	mov	x0, 0
	mov	w2, 0
.L1597:
	ldr	w6, [x1, x0]
	add	x0, x0, 4
	cmp	w6, 0
	cinc	w2, w2, eq
	cmp	x0, 32
	bne	.L1597
	cmp	w2, 7
	ble	.L1598
	mov	w3, 1024
	mov	w2, 1
	adrp	x0, .LC100
	add	x0, x0, :lo12:.LC100
	bl	rknand_print_hex
	adrp	x0, .LC99
	mov	w1, 0
	add	x0, x0, :lo12:.LC99
	bl	printf
.L1599:
	b	.L1599
.L1572:
	cmp	w10, 7
	bne	.L1578
	mov	w1, 0
.L1580:
	ldrb	w2, [x0]
	cmp	w2, 12
	beq	.L1579
	ldrb	w2, [x0, 1]
	cmp	w2, 10
	beq	.L1579
	add	w1, w1, 1
	add	x0, x0, 4
	and	w1, w1, 255
	cmp	w1, 8
	bne	.L1580
.L1581:
	adrp	x0, .LC99
	mov	w1, 0
	add	x0, x0, :lo12:.LC99
	bl	printf
.L1582:
	b	.L1582
.L1579:
	cmp	w1, 6
	bls	.L1576
	b	.L1581
.L1578:
	cmp	w10, 6
	bne	.L1576
	mov	x1, 0
.L1583:
	ldrb	w2, [x0, x1]
	cmp	w2, 12
	beq	.L1576
	add	x2, x0, x1
	ldrb	w2, [x2, 8]
	cmp	w2, 4
	beq	.L1576
	add	x1, x1, 1
	cmp	x1, 8
	bne	.L1583
	adrp	x0, .LC99
	mov	w1, 0
	add	x0, x0, :lo12:.LC99
	bl	printf
.L1585:
	b	.L1585
.L1587:
	ldr	w1, [x4, 2048]
	strb	w1, [x3, x0]
	add	x0, x0, 1
	b	.L1586
.L1598:
	cmp	w10, 6
	beq	.L1611
	cmp	w10, 7
	beq	.L1612
	cmp	w10, 8
	mov	x1, 5
	mov	x0, 8
	csel	x0, x0, x1, ne
.L1600:
	mov	x1, x5
	mov	w5, 0
.L1601:
	mov	x2, 0
.L1602:
	ldrb	w6, [x3, x2]
	strb	w6, [x1, x2]
	add	x2, x2, 1
	cmp	w11, w2, uxtb
	bhi	.L1602
	add	w5, w5, 1
	add	x3, x3, x14
	add	x1, x1, x0
	cmp	w24, w5
	bgt	.L1601
	mov	w5, 255
	str	w5, [x4, 2056]
	bl	nandc_wait_flash_ready
	cmp	w21, 1
	bhi	.L1604
	mov	w0, 54
	str	w0, [x4, 2056]
	ldrb	w0, [x8, 128]
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
.L1655:
	str	w0, [x4, 2056]
	bl	nandc_wait_flash_ready
	add	w12, w12, 1
	and	w12, w12, 255
	b	.L1562
.L1611:
	mov	x0, 4
	b	.L1600
.L1612:
	mov	x0, 10
	b	.L1600
.L1604:
	cmp	w10, 8
	bne	.L1606
	mov	w0, 190
	b	.L1655
.L1606:
	mov	w0, 56
	b	.L1655
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
	bhi	.L1656
	b	hynix_get_read_retry_default
.L1656:
	ret
	.size	flash_get_read_retry_tbl, .-flash_get_read_retry_tbl
	.section	.text.nandc_xfer_done,"ax",@progbits
	.align	2
	.global	nandc_xfer_done
	.type	nandc_xfer_done, %function
nandc_xfer_done:
	stp	x29, x30, [sp, -80]!
	adrp	x0, .LANCHOR162
	adrp	x1, .LANCHOR28
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR13
	ldrb	w1, [x1, #:lo12:.LANCHOR28]
	stp	x21, x22, [sp, 32]
	strb	wzr, [x0, #:lo12:.LANCHOR162]
	cmp	w1, 9
	str	x23, [sp, 48]
	bne	.L1659
	ldr	x20, [x19, #:lo12:.LANCHOR13]
	mov	x21, x0
	ldr	w0, [x20, 16]
	str	w0, [x29, 64]
	ldr	w0, [x20, 48]
	tbnz	x0, 1, .L1660
	adrp	x22, .LC104
	adrp	x23, .LC103
	add	x22, x22, :lo12:.LC104
	add	x23, x23, :lo12:.LC103
	mov	w21, 0
.L1661:
	ldr	w0, [x29, 64]
	tbnz	x0, 20, .L1663
	ldr	x0, [x19, #:lo12:.LANCHOR13]
	add	w21, w21, 1
	tst	x21, 16777215
	ldr	w0, [x0, 16]
	str	w0, [x29, 64]
	bne	.L1661
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
	b	.L1661
.L1662:
	ldr	w0, [x29, 64]
	add	w1, w1, 1
	ubfx	x0, x0, 22, 6
	cmp	w1, w0, lsl 12
	bne	.L1664
	ldr	w2, [x20, 64]
	adrp	x0, .LC102
	ldr	w3, [x29, 64]
	add	x0, x0, :lo12:.LC102
	ubfx	x2, x2, 16, 5
	ubfx	x3, x3, 22, 6
	bl	printf
	ldr	x1, [x19, #:lo12:.LANCHOR13]
	mov	w3, 64
	mov	w2, 4
	adrp	x0, .LC103
	add	x0, x0, :lo12:.LC103
	bl	rknand_print_hex
	ldr	w0, [x29, 72]
	mov	w0, 1
	strb	w0, [x21, #:lo12:.LANCHOR162]
.L1663:
	adrp	x0, .LANCHOR49+32
	ldr	x23, [sp, 48]
	ldp	x19, x20, [sp, 16]
	str	wzr, [x0, #:lo12:.LANCHOR49+32]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 80
	ret
.L1660:
	mov	w1, 0
.L1664:
	ldr	w2, [x20, 64]
	ldr	w0, [x29, 64]
	ubfx	x2, x2, 16, 6
	ubfx	x0, x0, 22, 6
	cmp	w2, w0
	bge	.L1663
	ldr	w0, [x20]
	str	w0, [x29, 72]
	ldr	w0, [x29, 72]
	tbz	x0, 13, .L1662
	ldr	w0, [x29, 72]
	tbz	x0, 17, .L1662
	ldr	w1, [x29, 72]
	adrp	x0, .LC101
	add	x0, x0, :lo12:.LC101
	ubfx	x1, x1, 17, 1
.L1693:
	bl	printf
	b	.L1663
.L1659:
	ldr	x20, [x19, #:lo12:.LANCHOR13]
	mov	w21, 0
	ldr	w0, [x20, 8]
	str	w0, [x29, 64]
	ldr	w0, [x20, 16]
	tbnz	x0, 1, .L1669
	adrp	x22, .LC104
	adrp	x23, .LC103
	add	x22, x22, :lo12:.LC104
	add	x23, x23, :lo12:.LC103
.L1670:
	ldr	w0, [x29, 64]
	tbnz	x0, 20, .L1663
	ldr	x0, [x19, #:lo12:.LANCHOR13]
	add	w21, w21, 1
	tst	x21, 16777215
	ldr	w0, [x0, 8]
	str	w0, [x29, 64]
	bne	.L1670
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
	b	.L1670
.L1669:
	adrp	x22, .LC102
	adrp	x23, .LC103
	add	x22, x22, :lo12:.LC102
	add	x23, x23, :lo12:.LC103
.L1671:
	ldr	w1, [x20, 28]
	ldr	w0, [x29, 64]
	ubfx	x1, x1, 16, 5
	ubfx	x0, x0, 22, 6
	cmp	w1, w0
	bge	.L1663
	ldr	x0, [x19, #:lo12:.LANCHOR13]
	ldr	w0, [x0]
	str	w0, [x29, 72]
	ldr	w0, [x29, 72]
	tbz	x0, 13, .L1672
	ldr	w0, [x29, 72]
	tbz	x0, 17, .L1672
	adrp	x0, .LC105
	ldr	w1, [x29, 72]
	add	x0, x0, :lo12:.LC105
	b	.L1693
.L1672:
	add	w21, w21, 1
	tst	x21, 16777215
	bne	.L1671
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
	b	.L1671
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
	mov	x20, x3
	stp	x21, x22, [sp, 32]
	mov	x3, x4
	and	w22, w1, 255
	mov	x2, x20
	mov	w1, w19
	mov	w0, w22
	mov	x21, x4
	bl	nandc_xfer_start
	mov	w0, w22
	bl	nandc_xfer_done
	cbnz	w22, .L1713
	adrp	x0, .LANCHOR28
	ldrb	w0, [x0, #:lo12:.LANCHOR28]
	cmp	w0, 9
	bne	.L1696
	adrp	x22, .LANCHOR13
	lsr	w19, w19, 2
	mov	w3, 1
	mov	w2, 0
	ldr	x5, [x22, #:lo12:.LANCHOR13]
	mov	w0, 0
.L1697:
	cmp	w2, w19
	bcc	.L1701
	ldr	w19, [x5]
	cmp	w3, 0
	mov	w1, 512
	csel	w0, w0, w1, eq
	mov	w1, 8192
	movk	w1, 0x2, lsl 16
	and	w1, w19, w1
	cmp	w1, 139264
	bne	.L1703
	mov	w1, w19
	adrp	x0, .LC106
	add	x0, x0, :lo12:.LC106
	bl	printf
	ldr	x0, [x22, #:lo12:.LANCHOR13]
	orr	w19, w19, 131072
	str	w19, [x0]
	mov	w0, -1
.L1703:
	tbz	x19, 13, .L1704
	adrp	x1, .LANCHOR162
	ldrb	w1, [x1, #:lo12:.LANCHOR162]
	cbz	w1, .L1704
	mov	w1, w19
	adrp	x0, .LC107
	add	x0, x0, :lo12:.LC107
	bl	printf
	ldr	x0, [x22, #:lo12:.LANCHOR13]
	mov	w1, 1
	str	w1, [x0, 16]
.L1732:
	mov	w0, -1
.L1695:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L1701:
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
	tbnz	x1, 2, .L1715
	ldr	w1, [x29, 56]
	tbnz	x1, 18, .L1715
	ldr	w4, [x29, 56]
	ldr	w1, [x29, 56]
	ubfx	x4, x4, 3, 7
	ubfx	x1, x1, 19, 7
	cmp	w4, w1
	ldr	w1, [x29, 56]
	ble	.L1699
	ubfx	x1, x1, 3, 7
.L1700:
	cmp	w0, w1
	csel	w0, w0, w1, cs
.L1698:
	add	w2, w2, 1
	b	.L1697
.L1699:
	ubfx	x1, x1, 19, 7
	b	.L1700
.L1715:
	mov	w0, -1
	b	.L1698
.L1696:
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
.L1706:
	add	w5, w3, w0
	cmp	w2, w4
	bcc	.L1707
	adrp	x22, .LANCHOR13
	lsr	w19, w19, 2
	mov	w3, 0
	mov	w0, 0
	ldr	x4, [x22, #:lo12:.LANCHOR13]
.L1708:
	cmp	w3, w19
	bcc	.L1712
	str	wzr, [x4, 16]
	mov	w1, 8192
	movk	w1, 0x2, lsl 16
	ldr	w19, [x4]
	and	w1, w19, w1
	cmp	w1, 139264
	bne	.L1704
	mov	w1, w19
	adrp	x0, .LC108
	add	x0, x0, :lo12:.LC108
	bl	printf
	ldr	x0, [x22, #:lo12:.LANCHOR13]
	orr	w19, w19, 131072
	str	w19, [x0]
	b	.L1732
.L1707:
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
	b	.L1706
.L1712:
	uxtw	x1, w3
	add	x1, x1, 8
	ldr	w1, [x4, x1, lsl 2]
	str	w1, [x29, 56]
	ldr	w1, [x29, 56]
	tbnz	x1, 2, .L1718
	ldr	w1, [x29, 56]
	tbnz	x1, 15, .L1718
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
	bls	.L1710
	ubfx	x2, x1, 3, 5
	ldr	w1, [x29, 56]
	ubfx	x1, x1, 27, 1
.L1731:
	orr	w1, w2, w1, lsl 5
	cmp	w0, w1
	csel	w0, w0, w1, cs
.L1709:
	add	w3, w3, 1
	b	.L1708
.L1710:
	ubfx	x2, x1, 16, 5
	ldr	w1, [x29, 56]
	ubfx	x1, x1, 29, 1
	b	.L1731
.L1718:
	mov	w0, -1
	b	.L1709
.L1704:
	cmn	w0, #1
	beq	.L1695
	ldr	w1, [x21]
	cmn	w1, #1
	bne	.L1695
	ldr	w1, [x21, 4]
	cmn	w1, #1
	bne	.L1695
	ldr	w1, [x20]
	cmn	w1, #1
	mov	w1, 512
	csel	w0, w0, w1, ne
	b	.L1695
.L1713:
	mov	w0, 0
	b	.L1695
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
	tbz	x0, 4, .L1734
	mov	w3, w1
	adrp	x0, .LC109
	mov	w2, w22
	mov	w1, w21
	add	x0, x0, :lo12:.LC109
	bl	printf
.L1734:
	bl	nandc_wait_flash_ready
	mov	w0, w21
	bl	nandc_cs
	adrp	x8, .LANCHOR16
	cbnz	w22, .L1735
	mov	w0, w21
	bl	zftl_flash_enter_slc_mode
.L1736:
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
	ldr	x0, [x8, #:lo12:.LANCHOR16]
	ldrb	w0, [x0, 12]
	cmp	w0, 3
	bne	.L1738
	cbz	w22, .L1738
	adrp	x0, .LANCHOR35
	ldrb	w0, [x0, #:lo12:.LANCHOR35]
	cbnz	w0, .L1738
	add	w19, w19, w19, lsl 1
	sub	w0, w19, #1
	add	w0, w0, w22
.L1747:
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
	bl	nandc_de_cs.constprop.31
	ldr	x25, [sp, 64]
	mov	w0, w2
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L1735:
	ldr	x0, [x8, #:lo12:.LANCHOR16]
	ldrb	w0, [x0, 12]
	cmp	w0, 3
	bne	.L1737
	adrp	x0, .LANCHOR35
	ldrb	w0, [x0, #:lo12:.LANCHOR35]
	cbnz	w0, .L1737
	sxtw	x0, w21
	add	x0, x0, 8
	add	x0, x20, x0, lsl 8
	str	w22, [x0, 8]
	b	.L1736
.L1737:
	mov	w0, w21
	bl	zftl_flash_exit_slc_mode
	b	.L1736
.L1738:
	mov	w0, w19
	b	.L1747
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
	adrp	x0, .LANCHOR164
	add	x0, x0, :lo12:.LANCHOR164
	str	x0, [x29, 104]
	ubfiz	x0, x20, 8, 8
	add	x25, x6, x0
.L1749:
	adrp	x24, .LANCHOR14
	add	x24, x24, :lo12:.LANCHOR14
	mov	w21, 0
	mov	w28, -1
.L1750:
	ldr	x0, [x29, 104]
	ldrb	w0, [x0]
	cmp	w21, w0
	bcc	.L1755
.L1754:
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
	bcc	.L1756
	cmn	w28, #1
	mov	w0, 256
	csel	w28, w28, w0, eq
.L1756:
	cmn	w28, #1
	cset	w24, eq
	cmp	w28, 256
	cset	w0, eq
	orr	w0, w24, w0
	cbz	w0, .L1757
	mov	w4, w28
	mov	w3, w21
	mov	w2, w23
	mov	w1, w21
	adrp	x0, .LC111
	add	x0, x0, :lo12:.LC111
	bl	printf
	eor	w0, w22, 1
	tst	w24, w0
	beq	.L1758
	mov	w1, 3
	mov	w0, w20
	mov	w22, 1
	bl	mt_auto_read_calibration_config
	b	.L1749
.L1755:
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
	tbz	x0, 12, .L1751
	mov	w4, w7
	str	w7, [x29, 112]
	mov	w3, w28
	mov	w2, w23
	mov	w1, w21
	adrp	x0, .LC110
	add	x0, x0, :lo12:.LC110
	bl	printf
	ldr	w7, [x29, 112]
.L1751:
	cmn	w7, #1
	beq	.L1752
	adrp	x0, .LANCHOR161
	cmn	w28, #1
	csel	w28, w28, w7, ne
	cmp	w7, w19
	ldr	x0, [x0, #:lo12:.LANCHOR161]
	str	x0, [x29, 120]
	adrp	x0, .LANCHOR163
	ldr	x26, [x0, #:lo12:.LANCHOR163]
	bcc	.L1761
.L1752:
	mov	w21, w27
	b	.L1750
.L1761:
	mov	w28, w7
	b	.L1754
.L1758:
	cbz	w22, .L1759
	mov	w0, w20
	mov	w1, 0
	bl	mt_auto_read_calibration_config
	cmn	w28, #1
	mov	w0, 256
	csel	w28, w28, w0, eq
.L1759:
	bl	nandc_wait_flash_ready
	mov	w0, w28
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L1757:
	cbz	w22, .L1759
	mov	w1, 0
	mov	w0, w20
	mov	w28, 256
	bl	mt_auto_read_calibration_config
	b	.L1759
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
	cbnz	w4, .L1779
	str	x0, [x29, 120]
	sxtw	x0, w24
	add	x0, x0, 8
	add	x0, x25, x0, lsl 8
	str	x0, [x29, 112]
.L1786:
	ldr	x0, [x29, 120]
	ldrb	w0, [x0]
	cmp	w0, 36
	bne	.L1780
	mov	w1, w20
	mov	x0, x21
	mov	w2, 0
	bl	toshiba_tlc_set_rr_para
	ldr	x1, [x29, 112]
	mov	w0, 93
	str	w0, [x1, 8]
.L1781:
	mov	w4, w28
	mov	x3, x27
	mov	x2, x26
	mov	w1, w23
	mov	w0, w24
	bl	flash_read_page
	mov	w4, w0
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 4, .L1782
	mov	w3, w4
	str	w4, [x29, 108]
	mov	w2, w23
	mov	w1, w20
	adrp	x0, .LC112
	add	x0, x0, :lo12:.LC112
	bl	printf
	ldr	w4, [x29, 108]
.L1782:
	cmn	w4, #1
	beq	.L1783
	adrp	x0, .LANCHOR161
	cmn	w19, #1
	csel	w19, w19, w4, ne
	ldr	x26, [x0, #:lo12:.LANCHOR161]
	adrp	x0, .LANCHOR163
	ldr	x27, [x0, #:lo12:.LANCHOR163]
	adrp	x0, .LANCHOR46
	ldrb	w0, [x0, #:lo12:.LANCHOR46]
	add	w0, w0, w0, lsl 1
	cmp	w4, w0, lsr 2
	bcc	.L1801
.L1783:
	ldr	w0, [x29, 136]
	add	w20, w20, 1
	cmp	w0, w20
	bne	.L1786
.L1785:
	ldrb	w0, [x22, #:lo12:.LANCHOR24]
	cmp	w0, 36
	bne	.L1787
	mov	w2, 0
.L1824:
	mov	w1, 0
	mov	x0, x21
	bl	toshiba_tlc_set_rr_para
	b	.L1788
.L1780:
	mov	w1, w20
	mov	x0, x21
	bl	toshiba_3d_set_slc_rr_para
	b	.L1781
.L1801:
	mov	w19, w4
	b	.L1785
.L1787:
	mov	w1, 0
	mov	x0, x21
	bl	toshiba_3d_set_slc_rr_para
.L1788:
	ldrb	w0, [x22, #:lo12:.LANCHOR24]
	cmp	w0, 36
	bne	.L1797
	ldr	x0, [x29, 128]
	add	x25, x25, x0, lsl 8
	mov	w0, 85
	str	w0, [x25, 2056]
	mov	w0, 255
	str	wzr, [x25, 2052]
	str	wzr, [x25, 2048]
	str	w0, [x25, 2056]
.L1797:
	adrp	x0, .LANCHOR46
	ldrb	w0, [x0, #:lo12:.LANCHOR46]
	add	w0, w0, w0, lsl 1
	cmp	w19, w0, lsr 2
	bcc	.L1798
	cmn	w19, #1
	mov	w0, 256
	csel	w19, w19, w0, eq
.L1798:
	cmp	w19, 256
	ccmn	w19, #1, 4, ne
	bne	.L1799
	adrp	x0, .LC114
	mov	w4, w19
	mov	w3, w20
	mov	w2, w23
	mov	w1, w20
	add	x0, x0, :lo12:.LC114
	bl	printf
.L1799:
	bl	nandc_wait_flash_ready
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	ret
.L1779:
	str	x0, [x29, 112]
	sxtw	x0, w24
	add	x0, x0, 8
	add	x0, x25, x0, lsl 8
	str	x0, [x29, 136]
.L1795:
	ldr	x0, [x29, 112]
	ldrb	w0, [x0]
	cmp	w0, 36
	bne	.L1789
	mov	x0, x21
	mov	w2, 1
	mov	w1, w20
	bl	toshiba_tlc_set_rr_para
	mov	w0, 93
.L1823:
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
	tbz	x0, 4, .L1791
	mov	w3, w4
	str	w4, [x29, 108]
	mov	w2, w23
	mov	w1, w20
	adrp	x0, .LC113
	add	x0, x0, :lo12:.LC113
	bl	printf
	ldr	w4, [x29, 108]
.L1791:
	cmn	w4, #1
	beq	.L1792
	adrp	x0, .LANCHOR161
	cmn	w19, #1
	csel	w19, w19, w4, ne
	ldr	x26, [x0, #:lo12:.LANCHOR161]
	adrp	x0, .LANCHOR163
	ldr	x27, [x0, #:lo12:.LANCHOR163]
	adrp	x0, .LANCHOR46
	ldrb	w0, [x0, #:lo12:.LANCHOR46]
	add	w0, w0, w0, lsl 1
	cmp	w4, w0, lsr 2
	bcc	.L1802
.L1792:
	ldr	w0, [x29, 120]
	add	w20, w20, 1
	cmp	w0, w20
	bne	.L1795
.L1794:
	ldrb	w0, [x22, #:lo12:.LANCHOR24]
	cmp	w0, 36
	bne	.L1796
	mov	w2, 1
	b	.L1824
.L1789:
	mov	x0, x21
	mov	w1, w20
	bl	toshiba_3d_set_tlc_rr_para
	mov	w0, 38
	b	.L1823
.L1802:
	mov	w19, w4
	b	.L1794
.L1796:
	mov	w1, 0
	mov	x0, x21
	bl	toshiba_3d_set_tlc_rr_para
	b	.L1788
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
	bls	.L1843
	adrp	x0, .LANCHOR21
	ldrb	w0, [x0, #:lo12:.LANCHOR21]
	cbz	w0, .L1844
	mov	w23, 1
	mov	w0, 1
	bl	nandc_set_if_mode
.L1827:
	and	x0, x19, 255
	mov	w1, 92
	add	x0, x22, x0, lsl 8
	str	w1, [x0, 2056]
	mov	w1, 197
	str	w1, [x0, 2056]
.L1826:
	sxtw	x0, w19
	mov	w20, 1
	add	x0, x0, 8
	mov	w24, -1
	add	x0, x22, x0, lsl 8
	str	x0, [x29, 96]
.L1828:
	adrp	x0, .LANCHOR164
	ldrb	w0, [x0, #:lo12:.LANCHOR164]
	add	w0, w0, 1
	cmp	w20, w0
	bcc	.L1837
	mov	w28, w24
.L1836:
	ldr	x0, [x29, 120]
	mov	w1, 0
	ldrb	w0, [x0, #:lo12:.LANCHOR24]
	sub	w0, w0, #67
	and	w0, w0, 255
	cmp	w0, 1
	mov	x0, x21
	bhi	.L1838
	bl	sandisk_set_rr_para
.L1839:
	sxtw	x19, w19
	mov	w0, 255
	add	x19, x19, 8
	add	x22, x22, x19, lsl 8
	str	w0, [x22, 8]
	adrp	x0, .LANCHOR46
	ldrb	w0, [x0, #:lo12:.LANCHOR46]
	add	w0, w0, w0, lsl 1
	cmp	w28, w0, lsr 2
	bcc	.L1840
	cmn	w28, #1
	mov	w0, 256
	csel	w28, w28, w0, eq
.L1840:
	cmp	w28, 256
	ccmn	w28, #1, 4, ne
	bne	.L1841
	adrp	x0, .LC114
	mov	w4, w28
	mov	w3, w20
	mov	w2, w25
	mov	w1, w20
	add	x0, x0, :lo12:.LC114
	bl	printf
.L1841:
	bl	nandc_wait_flash_ready
	cbz	w23, .L1825
	mov	w0, 4
	bl	nandc_set_if_mode
.L1825:
	mov	w0, w28
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L1844:
	mov	w23, 0
	b	.L1827
.L1843:
	mov	w23, 0
	b	.L1826
.L1837:
	ldr	x0, [x29, 120]
	mov	w1, w20
	ldrb	w0, [x0, #:lo12:.LANCHOR24]
	sub	w0, w0, #67
	and	w0, w0, 255
	cmp	w0, 1
	mov	x0, x21
	bhi	.L1829
	bl	sandisk_set_rr_para
.L1830:
	ldr	x0, [x29, 120]
	ldrb	w0, [x0, #:lo12:.LANCHOR24]
	cmp	w0, 34
	bne	.L1831
	adrp	x0, .LANCHOR164
	ldrb	w0, [x0, #:lo12:.LANCHOR164]
	sub	w0, w0, #3
	cmp	w20, w0
	bne	.L1831
	ldr	x1, [x29, 96]
	mov	w0, 179
	str	w0, [x1, 8]
.L1831:
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
	beq	.L1834
	cmn	w24, #1
	csel	w24, w24, w0, ne
	adrp	x0, .LANCHOR161
	ldr	x26, [x0, #:lo12:.LANCHOR161]
	adrp	x0, .LANCHOR163
	ldr	x27, [x0, #:lo12:.LANCHOR163]
	adrp	x0, .LANCHOR46
	ldrb	w0, [x0, #:lo12:.LANCHOR46]
	add	w0, w0, w0, lsl 1
	cmp	w28, w0, lsr 2
	bcc	.L1836
.L1834:
	add	w20, w20, 1
	b	.L1828
.L1829:
	bl	toshiba_set_rr_para
	b	.L1830
.L1838:
	bl	toshiba_set_rr_para
	b	.L1839
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
	adrp	x7, .LANCHOR161
	adrp	x8, .LANCHOR163
.L1858:
	cmp	w5, w24
	bcc	.L1863
.L1862:
	adrp	x0, .LANCHOR46
	add	x23, x28, x23
	ldrb	w0, [x0, #:lo12:.LANCHOR46]
	strb	w20, [x23, 8]
	add	w0, w0, w0, lsl 1
	cmp	w19, w0, lsr 2
	bcc	.L1864
	cmn	w19, #1
	mov	w0, 256
	csel	w19, w19, w0, eq
.L1864:
	cmp	w19, 256
	ccmn	w19, #1, 4, ne
	bne	.L1865
	adrp	x0, .LC115
	mov	w4, w19
	mov	w3, w5
	mov	w2, w22
	mov	w1, w5
	add	x0, x0, :lo12:.LC115
	bl	printf
.L1865:
	bl	nandc_wait_flash_ready
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L1863:
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
	beq	.L1860
	ldrb	w1, [x6]
	cmn	w19, #1
	csel	w19, w19, w0, ne
	ldr	x25, [x7, #:lo12:.LANCHOR161]
	ldr	x26, [x8, #:lo12:.LANCHOR163]
	add	w1, w1, w1, lsl 1
	cmp	w0, w1, lsr 2
	bcc	.L1866
.L1860:
	add	w5, w5, 1
	b	.L1858
.L1866:
	mov	w19, w0
	b	.L1862
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
	adrp	x0, .LC116
	mov	w27, 0
	add	x0, x0, :lo12:.LC116
	mov	w19, 1024
	mov	w21, -1
	mov	w7, 6
	str	wzr, [x29, 140]
	str	x0, [x29, 112]
.L1882:
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
	tbz	x0, 4, .L1877
	ldr	x0, [x29, 112]
	mov	w3, w4
	mov	w1, w7
	str	w4, [x29, 108]
	str	w7, [x29, 128]
	mov	w2, w22
	bl	printf
	ldr	w4, [x29, 108]
	ldr	w7, [x29, 128]
.L1877:
	add	w0, w19, 1
	cmp	w4, w0
	bhi	.L1878
	adrp	x0, .LANCHOR161
	ldr	x23, [x0, #:lo12:.LANCHOR161]
	adrp	x0, .LANCHOR163
	ldr	x24, [x0, #:lo12:.LANCHOR163]
	ldrb	w0, [x25]
	cmp	w4, w0, lsr 2
	bcs	.L1888
	add	w27, w27, 1
	cmp	w27, 7
	bls	.L1888
	sub	w28, w7, w27
	mov	w19, w4
	mov	w21, 0
.L1880:
	ldr	w0, [x29, 140]
	cmp	w27, w26
	csel	w28, w28, w0, cs
.L1881:
	cbz	w28, .L1883
	adrp	x0, .LANCHOR46
	mov	w1, 3
	ldrb	w0, [x0, #:lo12:.LANCHOR46]
	udiv	w0, w0, w1
	cmp	w0, w19
	bls	.L1883
	mov	w1, w28
	adrp	x0, .LC117
	add	x0, x0, :lo12:.LC117
	bl	printf
	mov	w0, w28
.L1899:
	bl	nandc_set_ddr_para
	cbz	w21, .L1876
	mov	w2, w22
	mov	w1, w20
	adrp	x0, .LC118
	add	x0, x0, :lo12:.LC118
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
	adrp	x0, .LC119
	add	x0, x0, :lo12:.LC119
	bl	printf
	adrp	x0, .LANCHOR46
	ldrb	w0, [x0, #:lo12:.LANCHOR46]
	cmp	w19, w0
	bhi	.L1890
	adrp	x1, .LANCHOR165
	ldr	w0, [x1, #:lo12:.LANCHOR165]
	add	w0, w0, 1
	str	w0, [x1, #:lo12:.LANCHOR165]
	cmp	w0, 100
	bls	.L1886
	adrp	x0, .LANCHOR21
	strb	wzr, [x0, #:lo12:.LANCHOR21]
.L1876:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	ret
.L1878:
	cmp	w27, w26
	bls	.L1889
	sub	w0, w28, w27
	str	w0, [x29, 140]
	cmp	w27, 7
	bhi	.L1881
	mov	w26, w27
.L1889:
	mov	w27, 0
	b	.L1879
.L1888:
	mov	w28, w7
	mov	w19, w4
	mov	w21, 0
.L1879:
	add	w7, w7, 2
	cmp	w7, 50
	bne	.L1882
	b	.L1880
.L1883:
	ldrb	w0, [x29, 132]
	b	.L1899
.L1890:
	mov	w19, w21
.L1886:
	adrp	x20, .LANCHOR45
	ldrb	w0, [x20, #:lo12:.LANCHOR45]
	bl	flash_set_interface_mode
	ldrb	w0, [x20, #:lo12:.LANCHOR45]
	bl	nandc_set_if_mode
	b	.L1876
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
	bhi	.L1901
	adrp	x1, .LANCHOR166
	adrp	x0, .LC0
	mov	w2, 409
	add	x1, x1, :lo12:.LANCHOR166
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1901:
	adrp	x0, .LANCHOR30
	add	x0, x0, :lo12:.LANCHOR30
	ldrb	w4, [x25, #:lo12:.LANCHOR18]
	ldrb	w21, [x0, w20, sxtw]
	cmp	w20, w4
	bcc	.L1902
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbnz	x0, 6, .L1903
.L1927:
	mov	w0, -1
.L1900:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L1903:
	mov	w3, w19
	mov	w2, w20
	mov	w1, w21
	adrp	x0, .LC120
	add	x0, x0, :lo12:.LC120
	bl	printf
	b	.L1927
.L1902:
	tst	x19, 50331648
	bne	.L1905
	adrp	x0, .LANCHOR0
	adrp	x1, .LANCHOR1
	ldrb	w0, [x0, #:lo12:.LANCHOR0]
	cbz	w0, .L1906
	ldrb	w0, [x1, #:lo12:.LANCHOR1]
	cbz	w0, .L1905
.L1906:
	adrp	x0, .LANCHOR2
	ldrb	w1, [x1, #:lo12:.LANCHOR1]
	ldrh	w2, [x0, #:lo12:.LANCHOR2]
	udiv	w0, w19, w2
	mul	w0, w0, w2
	sub	w19, w19, w0
	cbz	w1, .L1907
	add	w19, w0, w19, lsl 1
.L1905:
	mov	w4, w24
	mov	x3, x23
	mov	x2, x22
	mov	w1, w19
	mov	w0, w21
	bl	flash_read_page
	cmn	w0, #1
	bne	.L1900
	adrp	x20, .LANCHOR48
	ldrb	w25, [x20, #:lo12:.LANCHOR48]
	cbnz	w25, .L1908
.L1911:
	adrp	x0, .LANCHOR167
	ldr	x5, [x0, #:lo12:.LANCHOR167]
	cbnz	x5, .L1909
.L1910:
	ldrb	w4, [x20, #:lo12:.LANCHOR48]
	mov	w3, -1
	mov	w2, w19
	mov	w1, 0
	adrp	x0, .LC121
	add	x0, x0, :lo12:.LC121
	bl	printf
	adrp	x0, .LANCHOR21
	ldrb	w0, [x0, #:lo12:.LANCHOR21]
	cbz	w0, .L1927
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
.L1907:
	adrp	x1, .LANCHOR3
	add	x1, x1, :lo12:.LANCHOR3
	ldrh	w19, [x1, w19, uxtw 1]
	add	w19, w19, w0
	b	.L1905
.L1908:
	strb	wzr, [x20, #:lo12:.LANCHOR48]
	mov	w4, w24
	mov	x3, x23
	mov	x2, x22
	mov	w1, w19
	mov	w0, w21
	bl	flash_read_page
	strb	w25, [x20, #:lo12:.LANCHOR48]
	cmn	w0, #1
	beq	.L1911
	b	.L1900
.L1909:
	mov	w4, w24
	mov	x3, x23
	mov	x2, x22
	mov	w1, w19
	mov	w0, w21
	blr	x5
	cmn	w0, #1
	beq	.L1910
	b	.L1900
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
	adrp	x0, .LANCHOR144
	stp	x19, x20, [sp, 16]
	stp	x25, x26, [sp, 64]
	mov	x24, x2
	ldrh	w19, [x0, #:lo12:.LANCHOR144]
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
	bne	.L1929
	mov	w27, 0
	mov	w28, 2
.L1930:
	cmp	w27, w19
	ble	.L1933
.L1929:
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L1934
	ldr	w3, [x22]
	adrp	x0, .LC122
	mov	w2, w19
	mov	w1, w21
	add	x0, x0, :lo12:.LC122
	bl	printf
.L1934:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L1933:
	add	w20, w27, w19
	mov	w4, w25
	mov	x3, x22
	mov	x2, x24
	mov	w0, w23
	sdiv	w20, w20, w28
	add	w1, w26, w20, sxth
	bl	flash_read_page_en
	cmp	w0, 512
	bne	.L1931
	sub	w19, w20, #1
	sxth	w19, w19
	b	.L1930
.L1931:
	add	w20, w20, 1
	sxth	w27, w20
	b	.L1930
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
	adrp	x24, .LANCHOR169
	bl	flash_set_interface_mode
	adrp	x25, .LANCHOR168
	ldrb	w0, [x20, #:lo12:.LANCHOR45]
	bl	nandc_set_if_mode
	ldr	x3, [x25, #:lo12:.LANCHOR168]
	mov	w4, 4
	ldr	x2, [x24, #:lo12:.LANCHOR169]
	mov	w1, w23
	mov	w0, w22
	bl	flash_ddr_tuning_read
	ldr	x3, [x25, #:lo12:.LANCHOR168]
	mov	w4, 4
	ldr	x2, [x24, #:lo12:.LANCHOR169]
	mov	w1, w23
	mov	w0, w22
	bl	flash_read_page
	cmn	w0, #1
	mov	x0, x19
	bne	.L1941
	ldrb	w1, [x20, #:lo12:.LANCHOR45]
	tbz	x1, 0, .L1941
	mov	w0, 1
	bl	flash_set_interface_mode
	mov	w0, w21
	bl	nandc_set_if_mode
	strb	wzr, [x19, #:lo12:.LANCHOR21]
.L1942:
	mov	w0, 0
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L1941:
	mov	w1, 1
	strb	w1, [x0, #:lo12:.LANCHOR21]
	b	.L1942
	.size	flash_ddr_para_scan, .-flash_ddr_para_scan
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
	tbz	x0, 4, .L1948
	adrp	x0, .LC123
	mov	w3, w4
	mov	w2, w27
	add	x0, x0, :lo12:.LC123
	bl	printf
.L1948:
	bl	nandc_wait_flash_ready
	mov	w0, w21
	bl	hynix_reconfig_rr_para
	mov	w0, w21
	bl	nandc_cs
	mov	w0, w21
	cbnz	w27, .L1949
	bl	zftl_flash_enter_slc_mode
.L1950:
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
	mov	x4, x25
	mov	x3, x24
	mov	w1, 1
	ldrb	w2, [x0, #:lo12:.LANCHOR32+9]
	mov	w0, w21
	bl	nandc_xfer
	mov	w0, 16
	str	w0, [x19, 2056]
	bl	nandc_wait_flash_ready
	mov	x0, x23
	bl	flash_read_status
	mov	w3, w0
	bl	nandc_de_cs.constprop.31
	and	w2, w3, 4
	tbz	x3, 2, .L1947
	mov	w1, w22
	adrp	x0, .LC124
	add	x0, x0, :lo12:.LC124
	bl	printf
	mov	w2, -1
.L1947:
	mov	w0, w2
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L1949:
	bl	zftl_flash_exit_slc_mode
	b	.L1950
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
	adrp	x22, .LANCHOR161
	stp	x19, x20, [sp, 16]
	and	w20, w0, 255
	ldr	x0, [x22, #:lo12:.LANCHOR161]
	adrp	x21, .LANCHOR163
	and	w19, w1, 65535
	str	x23, [sp, 48]
	mov	w1, 165
	bl	ftl_memset
	ldr	x0, [x21, #:lo12:.LANCHOR163]
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
	bne	.L1960
.L1962:
	mov	w21, -1
.L1961:
	mov	w1, w19
	mov	w0, w20
	bl	flash_erase_block
	ldr	x23, [sp, 48]
	mov	w0, w21
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L1960:
	adrp	x23, .LANCHOR32
	add	x23, x23, :lo12:.LANCHOR32
	ldr	x3, [x21, #:lo12:.LANCHOR163]
	mov	w1, w19
	ldr	x2, [x22, #:lo12:.LANCHOR161]
	mov	w0, w20
	ldrb	w4, [x23, 9]
	bl	flash_prog_page
	cmn	w0, #1
	beq	.L1962
	ldrb	w4, [x23, 9]
	mov	w1, w19
	ldr	x3, [x21, #:lo12:.LANCHOR163]
	mov	w0, w20
	ldr	x2, [x22, #:lo12:.LANCHOR161]
	bl	flash_read_page_en
	cmn	w0, #1
	beq	.L1962
	ldr	x0, [x22, #:lo12:.LANCHOR161]
	ldr	w1, [x0]
	mov	w0, 42405
	movk	w0, 0xa5a5, lsl 16
	cmp	w1, w0
	bne	.L1962
	ldr	x0, [x21, #:lo12:.LANCHOR163]
	ldr	w1, [x0]
	mov	w0, 23130
	movk	w0, 0x5a5a, lsl 16
	cmp	w1, w0
	csetm	w21, ne
	b	.L1961
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
	cbnz	w0, .L1970
	adrp	x20, .LANCHOR32
	add	x20, x20, :lo12:.LANCHOR32
	ldrb	w0, [x20, 19]
	sub	w0, w0, #5
	and	w3, w0, 255
	cmp	w3, 63
	bhi	.L1970
	and	w19, w2, 65535
	mov	x2, 16391
	movk	x2, 0x4000, lsl 16
	movk	x2, 0x8000, lsl 48
	lsr	x0, x2, x3
	tbz	x0, 0, .L1970
	adrp	x21, .LANCHOR142
	mov	w23, w1
	add	x21, x21, :lo12:.LANCHOR142
	mov	w25, 65535
	adrp	x24, .LANCHOR161
.L1972:
	ldrh	w0, [x20, 10]
	cmp	w0, w19
	bhi	.L1973
.L1970:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L1973:
	ldrh	w0, [x21, w19, sxtw 1]
	cmp	w0, w25
	bne	.L1970
	ldr	x0, [x24, #:lo12:.LANCHOR161]
	mov	w2, 16384
	mov	w1, 255
	bl	ftl_memset
	ldr	x3, [x24, #:lo12:.LANCHOR161]
	add	w1, w19, w23
	ldrb	w4, [x20, 9]
	add	w19, w19, 1
	mov	x2, x3
	mov	w0, w22
	and	w19, w19, 65535
	bl	flash_prog_page
	b	.L1972
	.size	id_block_prog_msb_ff_data, .-id_block_prog_msb_ff_data
	.section	.text.flash_dual_page_prog,"ax",@progbits
	.align	2
	.global	flash_dual_page_prog
	.type	flash_dual_page_prog, %function
flash_dual_page_prog:
	stp	x29, x30, [sp, -128]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	and	w21, w0, 255
	adrp	x0, .LANCHOR13
	stp	x19, x20, [sp, 16]
	stp	x23, x24, [sp, 48]
	and	x23, x21, 255
	ldr	x19, [x0, #:lo12:.LANCHOR13]
	add	x0, x23, 8
	mov	w20, 24
	stp	x27, x28, [sp, 80]
	mov	x27, x2
	stp	x25, x26, [sp, 64]
	add	x0, x19, x0, lsl 8
	str	x0, [x29, 120]
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
	str	x0, [x29, 112]
	sub	w20, w20, #1
	ldr	w2, [x0, #:lo12:.LANCHOR14]
	and	w20, w20, w1
	tbz	x2, 4, .L1976
	adrp	x0, .LC123
	mov	w3, w6
	mov	w2, w24
	add	x0, x0, :lo12:.LC123
	bl	printf
.L1976:
	bl	nandc_wait_flash_ready
	mov	w0, w21
	bl	nandc_cs
	mov	w0, w21
	cbnz	w24, .L1977
	bl	zftl_flash_enter_slc_mode
.L1978:
	add	x19, x19, x23, lsl 8
	mov	w5, 128
	and	w0, w20, 255
	adrp	x23, .LANCHOR32
	add	x23, x23, :lo12:.LANCHOR32
	str	w5, [x29, 108]
	str	w5, [x19, 2056]
	mov	w24, 16
	str	wzr, [x19, 2052]
	str	wzr, [x19, 2052]
	str	w0, [x19, 2052]
	lsr	w0, w20, 8
	str	w0, [x19, 2052]
	lsr	w0, w20, 16
	str	w0, [x19, 2052]
	mov	w0, w20
	bl	nandc_set_seed
	ldrb	w2, [x23, 9]
	mov	x4, x28
	mov	x3, x27
	mov	w1, 1
	mov	w0, w21
	bl	nandc_xfer
	str	w24, [x19, 2056]
	bl	nandc_wait_flash_ready
	ldr	w5, [x29, 108]
	add	w0, w20, 1
	str	w5, [x19, 2056]
	and	w1, w0, 255
	str	wzr, [x19, 2052]
	str	wzr, [x19, 2052]
	str	w1, [x19, 2052]
	lsr	w1, w0, 8
	str	w1, [x19, 2052]
	lsr	w1, w0, 16
	str	w1, [x19, 2052]
	bl	nandc_set_seed
	ldrb	w2, [x23, 9]
	mov	x4, x26
	mov	x3, x25
	mov	w1, 1
	mov	w0, w21
	bl	nandc_xfer
	str	w24, [x19, 2056]
	bl	nandc_wait_flash_ready
	ldr	x0, [x29, 120]
	bl	flash_read_status
	mov	w3, w0
	bl	nandc_de_cs.constprop.31
	and	w2, w3, 4
	tbz	x3, 2, .L1975
	ldr	x0, [x29, 112]
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L1980
	adrp	x0, .LC124
	mov	w1, w22
	add	x0, x0, :lo12:.LC124
	bl	printf
.L1980:
	mov	w2, -1
.L1975:
	ldp	x19, x20, [sp, 16]
	mov	w0, w2
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L1977:
	bl	zftl_flash_exit_slc_mode
	b	.L1978
	.size	flash_dual_page_prog, .-flash_dual_page_prog
	.section	.text.fw_flash_page_prog.constprop.28,"ax",@progbits
	.align	2
	.type	fw_flash_page_prog.constprop.28, %function
fw_flash_page_prog.constprop.28:
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
	bne	.L1989
	adrp	x22, .LANCHOR161
	mov	w2, 16384
	mov	w1, 255
	ldr	x0, [x22, #:lo12:.LANCHOR161]
	bl	ftl_memset
	ldr	x5, [x22, #:lo12:.LANCHOR161]
	mov	w6, 4
	mov	x3, x21
	mov	x2, x20
	mov	x4, x5
	mov	w1, w19
	mov	w0, 0
	bl	flash_dual_page_prog
.L1992:
	mov	w4, w0
	mov	w0, w23
	bl	nandc_bch_sel
	ldr	x23, [sp, 48]
	mov	w0, w4
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L1989:
	mov	w4, 4
	mov	x3, x21
	mov	x2, x20
	mov	w1, w19
	mov	w0, 0
	bl	flash_prog_page
	b	.L1992
	.size	fw_flash_page_prog.constprop.28, .-fw_flash_page_prog.constprop.28
	.section	.text.idb_write_data,"ax",@progbits
	.align	2
	.global	idb_write_data
	.type	idb_write_data, %function
idb_write_data:
	stp	x29, x30, [sp, -272]!
	cmp	w1, 64
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w19, w1
	stp	x21, x22, [sp, 32]
	mov	w20, w3
	stp	x23, x24, [sp, 48]
	adrp	x22, .LANCHOR140
	stp	x25, x26, [sp, 64]
	mov	x24, x2
	stp	x27, x28, [sp, 80]
	bne	.L1994
	ldr	w1, [x2]
	mov	w0, 35899
	movk	w0, 0xfcdc, lsl 16
	cmp	w1, w0
	bne	.L1994
	adrp	x21, .LANCHOR138
	mov	w1, 1
	strb	w1, [x22, #:lo12:.LANCHOR140]
	ldr	x0, [x21, #:lo12:.LANCHOR138]
	cbnz	x0, .L1995
	mov	w0, 262144
	bl	ftl_malloc
	str	x0, [x21, #:lo12:.LANCHOR138]
.L1995:
	adrp	x0, .LANCHOR170
	mov	w1, 64
	str	w1, [x0, #:lo12:.LANCHOR170]
.L1994:
	ldrb	w0, [x22, #:lo12:.LANCHOR140]
	cbz	w0, .L2061
	adrp	x0, .LANCHOR138
	mov	x23, x0
	ldr	x21, [x0, #:lo12:.LANCHOR138]
	cbz	x21, .L2061
	add	w0, w19, w20
	str	w0, [x29, 144]
	cmp	w0, 63
	bls	.L1997
	cmp	w19, 575
	bhi	.L1998
	adrp	x21, .LANCHOR141
	ldr	x0, [x21, #:lo12:.LANCHOR141]
	cbz	x0, .L1999
.L2002:
	adrp	x1, .LANCHOR139
	mov	w2, 1
	ldr	x0, [x23, #:lo12:.LANCHOR138]
	cmp	w19, 64
	str	w2, [x1, #:lo12:.LANCHOR139]
	bhi	.L2111
	mov	w4, 64
	sub	w4, w4, w19
	sub	w2, w20, w4
	ubfiz	x4, x4, 9, 25
	lsl	w2, w2, 9
	add	x1, x24, x4
.L2117:
	bl	ftl_memcpy
.L2003:
	adrp	x0, .LANCHOR170
	ldr	w0, [x0, #:lo12:.LANCHOR170]
	cmp	w19, w0
	beq	.L2057
	strb	wzr, [x22, #:lo12:.LANCHOR140]
	b	.L2057
.L1999:
	mov	w0, 262144
	bl	ftl_malloc
	str	x0, [x21, #:lo12:.LANCHOR141]
	cbnz	x0, .L2002
	mov	w0, -1
	b	.L1993
.L2111:
	mov	w2, 576
	sub	w2, w2, w19
	cmp	w20, w2
	sub	w3, w19, #64
	csel	w2, w20, w2, ls
	ubfiz	x3, x3, 9, 25
	lsl	w2, w2, 9
	mov	x1, x24
	add	x0, x0, x3
	b	.L2117
.L1997:
	cmp	w19, 575
	bls	.L2003
.L1998:
	adrp	x0, .LANCHOR139
	ldr	w0, [x0, #:lo12:.LANCHOR139]
	cbz	w0, .L2003
	ldr	w1, [x21]
	mov	w0, 35899
	movk	w0, 0xfcdc, lsl 16
	cmp	w1, w0
	bne	.L2005
	adrp	x0, .LANCHOR0
	mov	x10, x0
	ldrb	w1, [x0, #:lo12:.LANCHOR0]
	str	w1, [x29, 176]
	adrp	x1, .LANCHOR19
	mov	x11, x1
	ldr	w0, [x29, 176]
	ldrb	w2, [x1, #:lo12:.LANCHOR19]
	str	w2, [x29, 204]
	cbz	w0, .L2006
	ldrh	w0, [x29, 176]
	str	w0, [x29, 172]
	uxtw	x0, w2
	cmp	w0, 0
	cset	w0, eq
.L2114:
	adrp	x12, .LANCHOR32
	add	x8, x12, :lo12:.LANCHOR32
	str	w0, [x29, 200]
	mov	w0, 0
	ldrb	w22, [x8, 9]
	ldrh	w19, [x8, 26]
	bl	zftl_flash_exit_slc_mode
	ldrh	w20, [x8, 10]
	add	x1, x21, 258048
	ldrb	w0, [x11, #:lo12:.LANCHOR19]
	mov	w4, 16981
	strb	w0, [x10, #:lo12:.LANCHOR0]
	add	x1, x1, 2044
	ldrb	w0, [x8, 12]
	lsl	w20, w20, 2
	mov	w2, 65023
	movk	w4, 0x4f4f, lsl 16
	mov	w3, 4098
	str	x12, [x29, 120]
	sdiv	w20, w20, w0
	mov	w0, 512
	cmp	w20, 512
	csel	w20, w20, w0, lt
	mov	w0, 0
.L2013:
	ldr	w5, [x1]
	cbnz	w5, .L2009
	cbnz	w0, .L2010
	str	w4, [x1, 2048]
.L2011:
	add	w0, w0, 1
	sub	w2, w2, #1
	cmp	w0, w3
	sub	x1, x1, #4
	csel	w0, w0, wzr, ls
	cmp	w2, 4096
	bne	.L2013
.L2009:
	ldr	w1, [x21, w2, uxtw 2]
	mul	w19, w19, w22
	mov	w3, w20
	adrp	x0, .LC125
	add	x0, x0, :lo12:.LC125
	bl	printf
	str	wzr, [x29, 180]
	and	w0, w19, 65535
	str	wzr, [x29, 192]
	str	w0, [x29, 140]
	adrp	x0, .LANCHOR48
	add	x0, x0, :lo12:.LANCHOR48
	str	x0, [x29, 184]
.L2052:
	adrp	x23, .LANCHOR141
	mov	w1, 0
	mov	w2, 512
	ldr	x0, [x23, #:lo12:.LANCHOR141]
	bl	ftl_memset
	str	x23, [x29, 160]
	adrp	x0, .LANCHOR27
	ldr	w1, [x29, 192]
	ldr	x0, [x0, #:lo12:.LANCHOR27]
	add	x0, x0, x1, uxtw
	ldrb	w19, [x0, 32]
	cmp	w19, 255
	beq	.L2014
	ldr	w0, [x29, 140]
	mul	w19, w19, w0
	ldr	w0, [x29, 200]
	cbz	w0, .L2015
	and	w0, w1, -3
	adrp	x10, .LANCHOR0
	cmp	w0, 1
	adrp	x8, .LANCHOR19
	beq	.L2016
	ldr	w0, [x29, 200]
	cmp	w0, 3
	bne	.L2017
.L2016:
	ldrb	w0, [x29, 172]
	strb	w0, [x10, #:lo12:.LANCHOR0]
	strb	w0, [x8, #:lo12:.LANCHOR19]
.L2015:
	ldr	x0, [x29, 120]
	add	x27, x0, :lo12:.LANCHOR32
	ldr	x0, [x29, 184]
	ldrb	w24, [x27, 9]
	ldrh	w25, [x27, 26]
	ldrb	w0, [x0]
	str	w0, [x29, 136]
	udiv	w1, w19, w24
	ldr	x0, [x29, 184]
	mul	w25, w24, w25
	and	w22, w25, 65535
	strb	wzr, [x0]
	mov	w0, 0
	bl	flash_erase_block
	udiv	w25, w19, w22
	ldrb	w1, [x27, 12]
	msub	w0, w25, w22, w19
	str	w0, [x29, 168]
	sub	w26, w19, w0
	ldrh	w0, [x27, 10]
	cmp	w19, w26
	lsl	w0, w0, 2
	sdiv	w0, w0, w1
	str	w0, [x29, 156]
	bne	.L2067
	adrp	x0, .LANCHOR28
	ldrb	w0, [x0, #:lo12:.LANCHOR28]
	cmp	w0, 9
	bne	.L2067
	ldr	x0, [x29, 160]
	mov	w2, 1024
	mov	w1, 0
	ldr	x25, [x0, #:lo12:.LANCHOR141]
	mov	x0, x25
	bl	ftl_memset
	mov	w0, 18766
	movk	w0, 0x464e, lsl 16
	str	w0, [x25]
	mov	w0, 12
	str	w0, [x25, 4]
	adrp	x0, .LANCHOR19
	strb	wzr, [x25, 16]
	str	wzr, [x25, 12]
	ldrb	w0, [x0, #:lo12:.LANCHOR19]
	cbz	w0, .L2019
	ldrb	w0, [x27, 29]
	strb	w0, [x25, 16]
.L2019:
	mov	w0, 4
	strb	w0, [x25, 17]
	adrp	x0, .LANCHOR32
	add	x1, x0, :lo12:.LANCHOR32
	cmp	w24, 8
	strb	wzr, [x25, 20]
	strh	wzr, [x25, 22]
	ldrh	w0, [x1, 10]
	ldrb	w1, [x1, 12]
	sdiv	w0, w0, w1
	mov	w1, 16
	strh	w0, [x25, 18]
	mov	w0, 70
	csel	w0, w0, w1, hi
	strb	w0, [x25, 21]
	mov	w1, 12
	add	x0, x25, 12
	bl	js_hash
	str	w0, [x25, 8]
	sub	w0, w20, #4
	str	w0, [x29, 196]
.L2018:
	adrp	x27, .LANCHOR3
	adrp	x28, .LANCHOR19
	mov	x23, x21
	add	x27, x27, :lo12:.LANCHOR3
	add	x28, x28, :lo12:.LANCHOR19
	mov	w22, 0
.L2021:
	ldr	w0, [x29, 156]
	cmp	w0, w22
	bhi	.L2032
	ldr	x0, [x29, 160]
	mov	w24, 4
	mov	w25, 0
	mov	w28, 0
	ldr	x23, [x0, #:lo12:.LANCHOR141]
	adrp	x0, .LANCHOR32
	add	x22, x0, :lo12:.LANCHOR32
	ldrb	w0, [x22, 9]
	str	w0, [x29, 152]
	ldrh	w0, [x22, 26]
	ldr	w1, [x29, 152]
	mul	w0, w1, w0
	adrp	x1, .LANCHOR48
	and	w0, w0, 65535
	strb	wzr, [x1, #:lo12:.LANCHOR48]
	udiv	w1, w19, w0
	msub	w0, w1, w0, w19
	str	w0, [x29, 168]
	sub	w0, w19, w0
	str	w0, [x29, 148]
	ldr	w0, [x29, 168]
	and	w0, w0, 3
	str	w0, [x29, 160]
	ldr	w0, [x29, 196]
	str	w0, [x29, 156]
	adrp	x0, .LANCHOR3
	add	x0, x0, :lo12:.LANCHOR3
	str	x0, [x29, 104]
.L2033:
	ldr	w0, [x29, 156]
	cmp	w25, w0
	bcc	.L2047
	ldr	x0, [x29, 184]
	ldrb	w1, [x29, 136]
	strb	w1, [x0]
	ldr	w0, [x29, 200]
	cbz	w0, .L2048
	mov	w0, 0
	bl	zftl_flash_exit_slc_mode
	adrp	x0, .LANCHOR0
	strb	wzr, [x0, #:lo12:.LANCHOR0]
	adrp	x0, .LANCHOR19
	strb	wzr, [x0, #:lo12:.LANCHOR19]
.L2048:
	ldr	w0, [x29, 196]
	mov	x2, 0
	lsl	w1, w0, 7
	adrp	x0, .LANCHOR141
	ldr	x0, [x0, #:lo12:.LANCHOR141]
.L2049:
	mov	w22, w2
	cmp	w2, w1
	bcc	.L2050
	ldr	w0, [x29, 180]
	add	w0, w0, 1
	str	w0, [x29, 180]
	cmp	w0, 5
	bls	.L2014
	b	.L2059
.L2006:
	ldr	w0, [x29, 204]
	cmp	w0, 3
	beq	.L2063
	cmp	w0, 2
	mov	w0, 2
	csel	w0, wzr, w0, ne
	str	w0, [x29, 172]
	ldr	w0, [x29, 204]
	cmp	w0, 2
	mov	w0, 3
	csel	w0, wzr, w0, ne
	b	.L2114
.L2063:
	ldr	w0, [x29, 204]
	str	w0, [x29, 172]
	mov	w0, 2
	b	.L2114
.L2010:
	ldr	w5, [x21, w0, uxtw 2]
	str	w5, [x1, 2048]
	b	.L2011
.L2017:
	mov	w0, 0
	bl	zftl_flash_exit_slc_mode
	strb	wzr, [x10, #:lo12:.LANCHOR0]
	strb	wzr, [x8, #:lo12:.LANCHOR19]
	b	.L2015
.L2067:
	mov	x25, 0
	str	w20, [x29, 196]
	b	.L2018
.L2032:
	ldr	w0, [x29, 168]
	ldrb	w2, [x28]
	add	w4, w0, w22
	lsr	w4, w4, 2
	add	w1, w4, 1
	ldrh	w0, [x27, w1, sxtw 1]
	cbz	w2, .L2023
	adrp	x0, .LANCHOR1
	ldrb	w7, [x0, #:lo12:.LANCHOR1]
	lsl	w0, w1, 1
	cmp	w7, 0
	csel	w0, w0, w1, ne
.L2023:
	adrp	x1, .LANCHOR28
	ldrb	w1, [x1, #:lo12:.LANCHOR28]
	cmp	w1, 9
	bne	.L2025
.L2115:
	str	w0, [x29, 208]
	mov	w0, 61424
	str	w0, [x29, 212]
	ldrh	w0, [x27, w4, sxtw 1]
	cbnz	w2, .L2027
	mov	w4, w0
.L2028:
	mul	w0, w24, w4
	cbnz	x25, .L2029
	str	w4, [x29, 152]
	add	x2, x29, 208
	mov	x1, x23
	add	w0, w0, w26
	bl	fw_flash_page_prog.constprop.28
	ldrb	w0, [x28]
	ldr	w4, [x29, 152]
	cbnz	w0, .L2030
	udiv	w1, w26, w24
	add	w2, w4, 1
	bl	id_block_prog_msb_ff_data
.L2030:
	ldr	w0, [x29, 196]
	add	x23, x23, 2048
	add	w0, w0, 16
	cmp	w22, w0
	bcc	.L2031
	ldr	w0, [x29, 196]
	add	w1, w0, 20
	add	x0, x21, 2048
	cmp	w22, w1
	csel	x23, x0, x23, cc
.L2031:
	add	w5, w22, 4
	mov	x25, 0
	and	w22, w5, 65535
	b	.L2021
.L2025:
	sub	w0, w0, #1
	lsl	w0, w0, 2
	b	.L2115
.L2027:
	adrp	x0, .LANCHOR1
	ldrb	w1, [x0, #:lo12:.LANCHOR1]
	lsl	w0, w4, 1
	cmp	w1, 0
	csel	w4, w0, w4, ne
	b	.L2028
.L2029:
	add	x2, x29, 208
	mov	x1, x25
	add	w0, w0, w26
	bl	fw_flash_page_prog.constprop.28
	b	.L2031
.L2047:
	ldr	w0, [x29, 160]
	adrp	x1, .LANCHOR19
	sub	w27, w24, w0
	ldr	w0, [x29, 168]
	ldrb	w1, [x1, #:lo12:.LANCHOR19]
	and	w27, w27, 65535
	add	w22, w0, w25
	ldr	x0, [x29, 104]
	udiv	w22, w22, w24
	and	w22, w22, 65535
	ldrh	w0, [x0, w22, sxtw 1]
	cbnz	w1, .L2034
	mov	w22, w0
.L2035:
	adrp	x0, .LANCHOR17
	ldr	w1, [x29, 148]
	ldrb	w26, [x0, #:lo12:.LANCHOR17]
	ldr	w0, [x29, 160]
	add	w0, w0, w1
	ldr	w1, [x29, 152]
	madd	w22, w1, w22, w0
	adrp	x0, .LANCHOR32+9
	ldrb	w0, [x0, #:lo12:.LANCHOR32+9]
	udiv	w22, w22, w0
	adrp	x0, .LANCHOR46
	ldrb	w0, [x0, #:lo12:.LANCHOR46]
	str	w0, [x29, 132]
	mov	w0, w26
	bl	nandc_bch_sel
	adrp	x0, .LANCHOR21
	add	x0, x0, :lo12:.LANCHOR21
	str	x0, [x29, 112]
.L2036:
	mov	w4, w24
	add	x3, x29, 208
	mov	x2, x23
	mov	w1, w22
	mov	w0, 0
	bl	flash_read_page
	mov	w5, w0
	cmn	w0, #1
	bne	.L2037
	ldr	x0, [x29, 184]
	ldrb	w6, [x0]
	cbnz	w6, .L2038
.L2041:
	adrp	x0, .LANCHOR167
	ldr	x6, [x0, #:lo12:.LANCHOR167]
	cbnz	x6, .L2039
.L2040:
	ldr	x0, [x29, 112]
	ldrb	w0, [x0]
	cbz	w0, .L2037
	mov	w4, w24
	add	x3, x29, 208
	mov	x2, x23
	mov	w1, w22
	mov	w0, 0
	bl	flash_ddr_tuning_read
	b	.L2116
.L2034:
	adrp	x0, .LANCHOR1
	ldrb	w1, [x0, #:lo12:.LANCHOR1]
	lsl	w0, w22, 1
	cmp	w1, 0
	csel	w22, w0, w22, ne
	b	.L2035
.L2038:
	ldr	x0, [x29, 184]
	mov	w1, w22
	str	w6, [x29, 100]
	mov	w4, w24
	str	w5, [x29, 128]
	add	x3, x29, 208
	mov	x2, x23
	strb	wzr, [x0]
	mov	w0, 0
	bl	flash_read_page
	cmn	w0, #1
	ldr	x1, [x29, 184]
	ldr	w6, [x29, 100]
	ldr	w5, [x29, 128]
	strb	w6, [x1]
	beq	.L2041
.L2116:
	mov	w5, w0
.L2037:
	cmn	w5, #1
	cset	w4, eq
	cmp	w26, 16
	cset	w0, ne
	tst	w4, w0
	beq	.L2043
	mov	w0, 16
	mov	w26, 16
	bl	nandc_bch_sel
	b	.L2036
.L2039:
	str	w5, [x29, 128]
	mov	w4, w24
	add	x3, x29, 208
	mov	x2, x23
	mov	w1, w22
	mov	w0, 0
	blr	x6
	cmn	w0, #1
	ldr	w5, [x29, 128]
	beq	.L2040
	b	.L2116
.L2043:
	ldr	w0, [x29, 132]
	bl	nandc_bch_sel
	cmp	w4, 0
	ldr	w0, [x29, 148]
	csinv	w28, w28, wzr, eq
	cmp	w25, 0
	ccmp	w19, w0, 0, eq
	bne	.L2045
	cbnz	w28, .L2045
	ldr	w1, [x23]
	mov	w0, 18766
	movk	w0, 0x464e, lsl 16
	cmp	w1, w0
	bne	.L2045
	ldr	w0, [x29, 156]
	ldrb	w24, [x23, 17]
	add	w0, w0, w27
	str	w0, [x29, 156]
.L2046:
	add	w25, w27, w25
	and	w25, w25, 65535
	b	.L2033
.L2045:
	ubfiz	x0, x27, 9, 16
	str	wzr, [x29, 160]
	add	x23, x23, x0
	b	.L2046
.L2050:
	ldr	w4, [x0, x2, lsl 2]
	add	x2, x2, 1
	add	x3, x21, x2, lsl 2
	ldr	w3, [x3, -4]
	cmp	w4, w3
	beq	.L2049
	mov	w2, 512
	mov	w1, 0
	bl	ftl_memset
	mov	w1, w22
	adrp	x0, .LC126
	add	x0, x0, :lo12:.LC126
	bl	printf
	mov	w1, w19
	mov	w0, 0
	bl	flash_erase_block
.L2014:
	ldr	w0, [x29, 192]
	add	w0, w0, 1
	str	w0, [x29, 192]
	cmp	w0, 4
	bne	.L2052
.L2059:
	mov	w0, 0
	bl	zftl_flash_exit_slc_mode
	adrp	x0, .LANCHOR0
	ldrb	w1, [x29, 176]
	strb	w1, [x0, #:lo12:.LANCHOR0]
	ldr	w0, [x29, 200]
	cbz	w0, .L2053
	adrp	x0, .LANCHOR19
	ldrb	w1, [x29, 204]
	strb	w1, [x0, #:lo12:.LANCHOR19]
.L2053:
	mov	w1, 2
	adrp	x0, .LANCHOR33
	strb	w1, [x0, #:lo12:.LANCHOR33]
	mov	w0, 0
	bl	zftl_flash_enter_slc_mode
	ldr	w0, [x29, 180]
	cbnz	w0, .L2005
	adrp	x0, .LC127
	mov	w1, 0
	add	x0, x0, :lo12:.LC127
	bl	printf
.L2005:
	adrp	x0, .LANCHOR139
	adrp	x19, .LANCHOR138
	str	wzr, [x0, #:lo12:.LANCHOR139]
	adrp	x0, .LANCHOR140
	strb	wzr, [x0, #:lo12:.LANCHOR140]
	ldr	x0, [x19, #:lo12:.LANCHOR138]
	cbz	x0, .L2055
	bl	free
	str	xzr, [x19, #:lo12:.LANCHOR138]
.L2055:
	adrp	x19, .LANCHOR141
	ldr	x0, [x19, #:lo12:.LANCHOR141]
	cbz	x0, .L2057
	bl	free
	str	xzr, [x19, #:lo12:.LANCHOR141]
.L2057:
	adrp	x0, .LANCHOR170
	ldr	w1, [x29, 144]
	str	w1, [x0, #:lo12:.LANCHOR170]
.L2061:
	mov	w0, 0
.L1993:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 272
	ret
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
	bhi	.L2119
	adrp	x1, .LANCHOR171
	adrp	x0, .LC0
	mov	w2, 753
	add	x1, x1, :lo12:.LANCHOR171
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2119:
	ldrb	w0, [x19, #:lo12:.LANCHOR18]
	cmp	w0, w26
	bls	.L2118
	adrp	x0, .LANCHOR30
	add	x0, x0, :lo12:.LANCHOR30
	ldrb	w5, [x0, w26, sxtw]
	adrp	x0, .LANCHOR13
	ldr	x19, [x0, #:lo12:.LANCHOR13]
	mov	w0, w5
	bl	nandc_cs
	cbz	w25, .L2121
	sxtw	x0, w5
	add	x0, x0, 8
	add	x0, x19, x0, lsl 8
	str	w25, [x0, 8]
.L2121:
	ubfiz	x0, x5, 8, 8
	add	x19, x19, x0
	mov	w0, 128
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
	mov	x4, x24
	mov	x3, x23
	mov	w1, 1
	ldrb	w2, [x0, #:lo12:.LANCHOR32+9]
	mov	w0, w5
	bl	nandc_xfer
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	str	w22, [x19, 2056]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 80
	b	nandc_de_cs.constprop.31
.L2118:
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
	adrp	x0, .LC128
	mov	w1, w21
	add	x0, x0, :lo12:.LC128
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
	bhi	.L2131
	adrp	x1, .LANCHOR172
	adrp	x0, .LC0
	mov	w2, 785
	add	x1, x1, :lo12:.LANCHOR172
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2131:
	ldrb	w0, [x19, #:lo12:.LANCHOR18]
	cmp	w0, w24
	bls	.L2130
	adrp	x0, .LANCHOR30
	add	x0, x0, :lo12:.LANCHOR30
	ldrb	w5, [x0, w24, sxtw]
	adrp	x0, .LANCHOR13
	ldr	x19, [x0, #:lo12:.LANCHOR13]
	mov	w0, w5
	bl	nandc_cs
	ubfiz	x0, x5, 8, 8
	add	x19, x19, x0
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
	mov	x4, x23
	mov	x3, x22
	mov	w1, 1
	ldrb	w2, [x0, #:lo12:.LANCHOR32+9]
	mov	w0, w5
	bl	nandc_xfer
	str	w21, [x19, 2056]
.L2130:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
	.size	flash_start_3d_mlc_page_prog, .-flash_start_3d_mlc_page_prog
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
	adrp	x0, .LC129
	add	x0, x0, :lo12:.LC129
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
	bl	nandc_de_cs.constprop.31
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
	bhi	.L2137
	adrp	x1, .LANCHOR173
	adrp	x0, .LC0
	mov	w2, 836
	add	x1, x1, :lo12:.LANCHOR173
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2137:
	ldrb	w0, [x27, #:lo12:.LANCHOR18]
	cmp	w0, w20
	bls	.L2136
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
	cbnz	w0, .L2139
	ldrb	w0, [x27, #:lo12:.LANCHOR18]
	cmp	w0, 1
	bne	.L2140
	bl	nandc_wait_flash_ready
.L2139:
	mov	w0, w26
	bl	hynix_reconfig_rr_para
	mov	w0, w26
	bl	nandc_cs
	tst	x24, 50331648
	bne	.L2141
	mov	w0, w19
	bl	slc_phy_page_address_calc
	mov	w19, w0
	adrp	x0, .LANCHOR0
	ldrb	w0, [x0, #:lo12:.LANCHOR0]
	cbz	w0, .L2142
	mov	w0, w26
	bl	zftl_flash_enter_slc_mode
.L2142:
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
	mov	x4, x23
	mov	x3, x22
	mov	w1, 1
	ldrb	w2, [x0, #:lo12:.LANCHOR32+9]
	mov	w0, w26
	bl	nandc_xfer
	ldr	x27, [sp, 80]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	str	w21, [x20, 2056]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 96
	b	nandc_de_cs.constprop.31
.L2140:
	mov	w2, 64
	mov	w1, w19
	mov	w0, w20
	bl	flash_wait_device_ready_raw
	b	.L2139
.L2141:
	mov	w0, w26
	bl	zftl_flash_exit_slc_mode
	b	.L2142
.L2136:
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
	beq	.L2148
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
.L2150:
	add	x7, x6, x1, lsl 6
	ldr	w4, [x7, 40]
	lsr	w4, w4, w5
	and	w4, w2, w4
	cmp	w3, w4
	bne	.L2149
	ldrb	w4, [x7, 58]
	cmp	w4, 7
	bne	.L2149
	mov	w1, 3
	strb	w1, [x7, 58]
.L2148:
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
.L2149:
	lsl	x1, x1, 6
	ldrb	w1, [x8, x1]
	cmp	w1, 255
	bne	.L2150
	b	.L2148
	.size	queue_prog_cmd, .-queue_prog_cmd
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
	bhi	.L2157
	adrp	x1, .LANCHOR174
	adrp	x0, .LC0
	mov	w2, 925
	add	x1, x1, :lo12:.LANCHOR174
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2157:
	ldrb	w0, [x23, #:lo12:.LANCHOR18]
	cmp	w0, w19
	bls	.L2165
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
	cbnz	w24, .L2159
	mov	w0, w4
	bl	slc_phy_page_address_calc
	mov	w4, w0
.L2159:
	adrp	x0, .LANCHOR20+16
	and	x1, x7, 255
	and	w5, w4, 255
	lsr	w3, w4, 8
	ldrb	w0, [x0, #:lo12:.LANCHOR20+16]
	lsr	w2, w4, 16
	cmp	w0, 1
	adrp	x0, .LANCHOR16
	bne	.L2160
	add	x1, x6, x1, lsl 8
	mov	w6, 6
.L2172:
	str	w6, [x1, 2056]
	str	wzr, [x1, 2052]
	str	wzr, [x1, 2052]
	str	w5, [x1, 2052]
	str	w3, [x1, 2052]
	str	w2, [x1, 2052]
.L2170:
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	mov	w2, 224
	str	w2, [x1, 2056]
	ldrb	w0, [x0, 12]
	cmp	w0, 3
	bne	.L2163
	cbz	w24, .L2163
	adrp	x0, .LANCHOR35
	ldrb	w0, [x0, #:lo12:.LANCHOR35]
	cbnz	w0, .L2163
	add	w4, w4, w4, lsl 1
	sub	w0, w24, #1
	add	w0, w4, w0
.L2171:
	bl	nandc_set_seed
	adrp	x0, .LANCHOR32+9
	mov	x4, x21
	mov	x3, x20
	mov	w1, 0
	ldrb	w2, [x0, #:lo12:.LANCHOR32+9]
	mov	w0, w7
	bl	nandc_xfer
	mov	w2, w0
	bl	nandc_de_cs.constprop.31
	mov	w0, w2
.L2156:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L2160:
	ldr	x8, [x0, #:lo12:.LANCHOR16]
	add	x1, x6, x1, lsl 8
	ldrb	w8, [x8, 12]
	cmp	w8, 3
	bne	.L2162
	mov	w6, 5
	b	.L2172
.L2162:
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
	b	.L2170
.L2163:
	mov	w0, w4
	b	.L2171
.L2165:
	mov	w0, -1
	b	.L2156
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
	bhi	.L2174
	adrp	x1, .LANCHOR175
	adrp	x0, .LC0
	mov	w2, 1049
	add	x1, x1, :lo12:.LANCHOR175
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2174:
	adrp	x0, .LANCHOR30
	add	x0, x0, :lo12:.LANCHOR30
	ldrb	w25, [x0, w20, sxtw]
	adrp	x0, .LANCHOR13
	ldr	x4, [x0, #:lo12:.LANCHOR13]
	mov	w0, w25
	bl	nandc_cs
	cbnz	w24, .L2175
	mov	w0, w19
	bl	slc_phy_page_address_calc
	mov	w19, w0
.L2175:
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
	bne	.L2176
	cbz	w24, .L2176
	adrp	x0, .LANCHOR35
	ldrb	w0, [x0, #:lo12:.LANCHOR35]
	cbnz	w0, .L2176
	sub	w0, w24, #1
	add	w1, w19, w19, lsl 1
	add	w0, w0, w1
.L2203:
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
	bne	.L2178
	adrp	x26, .LANCHOR48
	ldrb	w27, [x26, #:lo12:.LANCHOR48]
	cbz	w27, .L2179
	ldrb	w4, [x28, 9]
	mov	x3, x23
	strb	wzr, [x26, #:lo12:.LANCHOR48]
	mov	x2, x22
	orr	w1, w19, w24, lsl 24
	mov	w0, w25
	bl	flash_read_page
	strb	w27, [x26, #:lo12:.LANCHOR48]
	cbnz	w24, .L2180
.L2185:
	adrp	x1, .LANCHOR0
	ldrb	w1, [x1, #:lo12:.LANCHOR0]
	cbz	w1, .L2180
	adrp	x1, .LANCHOR46
	ldrb	w1, [x1, #:lo12:.LANCHOR46]
	add	w1, w1, w1, lsl 1
	cmp	w0, w1, lsr 2
	blt	.L2180
	add	x20, x20, :lo12:.LANCHOR32
	ldrb	w1, [x20, 19]
	sub	w1, w1, #4
	and	w1, w1, 255
	cmp	w1, 4
	mov	w1, 256
	csel	w0, w0, w1, hi
.L2173:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L2176:
	mov	w0, w19
	b	.L2203
.L2180:
	cmn	w0, #1
	bne	.L2173
.L2186:
	adrp	x0, .LANCHOR167
	ldr	x5, [x0, #:lo12:.LANCHOR167]
	cbnz	x5, .L2182
.L2184:
	adrp	x0, .LANCHOR48
	mov	w3, -1
	mov	w2, w21
	mov	w1, 0
	ldrb	w4, [x0, #:lo12:.LANCHOR48]
	adrp	x0, .LC130
	add	x0, x0, :lo12:.LC130
	bl	printf
	adrp	x0, .LANCHOR21
	ldrb	w0, [x0, #:lo12:.LANCHOR21]
	cbnz	w0, .L2183
	mov	w0, -1
	b	.L2173
.L2182:
	add	x0, x20, :lo12:.LANCHOR32
	mov	x3, x23
	mov	x2, x22
	orr	w1, w19, w24, lsl 24
	ldrb	w4, [x0, 9]
	mov	w0, w25
	blr	x5
	cmn	w0, #1
	beq	.L2184
	b	.L2173
.L2183:
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
.L2178:
	cbz	w24, .L2185
	b	.L2173
.L2179:
	cbnz	w24, .L2186
	b	.L2185
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
	bne	.L2205
.L2238:
	mov	w21, 0
	b	.L2204
.L2205:
	adrp	x19, .LANCHOR52
	sxtw	x20, w0
	add	x1, x19, :lo12:.LANCHOR52
	add	x1, x1, x20, lsl 6
	ldrb	w2, [x1, 58]
	ldr	w21, [x1, 40]
	sub	w3, w2, #1
	cmp	w3, 10
	bhi	.L2238
	adrp	x1, .L2208
	add	x1, x1, :lo12:.L2208
	ldrh	w1, [x1,w3,uxtw #1]
	adr	x3, .Lrtx2208
	add	x1, x3, w1, sxth #2
	br	x1
.Lrtx2208:
	.section	.rodata.queue_wait_first_req_completed,"a",@progbits
	.align	0
	.align	2
.L2208:
	.2byte	(.L2207 - .Lrtx2208) / 4
	.2byte	(.L2209 - .Lrtx2208) / 4
	.2byte	(.L2210 - .Lrtx2208) / 4
	.2byte	(.L2210 - .Lrtx2208) / 4
	.2byte	(.L2210 - .Lrtx2208) / 4
	.2byte	(.L2210 - .Lrtx2208) / 4
	.2byte	(.L2211 - .Lrtx2208) / 4
	.2byte	(.L2212 - .Lrtx2208) / 4
	.2byte	(.L2213 - .Lrtx2208) / 4
	.2byte	(.L2210 - .Lrtx2208) / 4
	.2byte	(.L2213 - .Lrtx2208) / 4
	.section	.text.queue_wait_first_req_completed
.L2207:
	mov	w1, 64
	mov	w0, w21
	bl	flash_wait_device_ready
	tbz	x0, 6, .L2238
	add	x0, x19, :lo12:.LANCHOR52
	add	x0, x0, x20, lsl 6
	ldp	x1, x2, [x0, 8]
	cbz	x2, .L2215
	ldrb	w3, [x0, 56]
	adrp	x0, .LANCHOR126
	ldrb	w0, [x0, #:lo12:.LANCHOR126]
	cmp	w3, w0
	csel	x1, x1, x2, ne
.L2215:
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
	b	.L2238
.L2209:
	mov	w1, 64
	mov	w0, w21
	bl	flash_wait_device_ready
	tbz	x0, 6, .L2238
	add	x0, x19, :lo12:.LANCHOR52
	lsl	x2, x20, 6
	add	x1, x0, x2
	ldrb	w21, [x0, x2]
	add	x0, x0, x21, lsl 6
	ldr	x24, [x0, 8]
	ldp	x26, x0, [x1, 8]
	cbz	x0, .L2216
	ldrb	w2, [x1, 56]
	adrp	x1, .LANCHOR126
	ldrb	w1, [x1, #:lo12:.LANCHOR126]
	cmp	w2, w1
	csel	x26, x26, x0, ne
.L2216:
	add	x0, x19, :lo12:.LANCHOR52
	add	x0, x0, x21, lsl 6
	ldr	x1, [x0, 16]
	cbz	x1, .L2217
	ldrb	w2, [x0, 56]
	adrp	x0, .LANCHOR126
	ldrb	w0, [x0, #:lo12:.LANCHOR126]
	cmp	w2, w0
	csel	x24, x24, x1, ne
.L2217:
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
	beq	.L2218
	ldr	w0, [x27, 36]
	cmn	w0, #1
	beq	.L2219
	ldr	x1, [x27, 24]
	ldr	w1, [x1, 4]
	cmp	w0, w1
	beq	.L2219
.L2218:
	adrp	x0, .LANCHOR31
	add	x22, x19, :lo12:.LANCHOR52
	add	x22, x22, x20, lsl 6
	mov	w5, 1
	ldrb	w2, [x0, #:lo12:.LANCHOR31]
	mov	w0, 24
	sub	w0, w0, w2
	ldr	x3, [x22, 24]
	lsl	w5, w5, w2
	adrp	x2, .LANCHOR126
	sub	w5, w5, #1
	ldr	w1, [x22, 40]
	ldrb	w4, [x2, #:lo12:.LANCHOR126]
	mov	x2, x26
	lsl	w6, w5, w0
	lsr	w0, w1, w0
	bic	w1, w1, w6
	and	w0, w0, w5
	bl	flash_read_page_en
	mov	w23, w0
	ldr	w2, [x22, 36]
	cmn	w2, #1
	beq	.L2220
	ldr	x0, [x22, 24]
	ldr	w4, [x0, 4]
	cmp	w2, w4
	beq	.L2220
	adrp	x1, .LANCHOR14
	ldr	w1, [x1, #:lo12:.LANCHOR14]
	tbz	x1, 6, .L2220
	ldr	w3, [x0]
	adrp	x0, .LC131
	ldr	w1, [x22, 40]
	add	x0, x0, :lo12:.LC131
	bl	printf
.L2220:
	add	x0, x19, :lo12:.LANCHOR52
	add	x0, x0, x20, lsl 6
	ldr	w1, [x0, 36]
	cmn	w1, #1
	beq	.L2219
	ldr	x0, [x0, 24]
	ldr	w0, [x0, 4]
	cmp	w1, w0
	beq	.L2219
	adrp	x1, .LANCHOR176
	adrp	x0, .LC0
	mov	w2, 360
	add	x1, x1, :lo12:.LANCHOR176
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2219:
	add	x0, x19, :lo12:.LANCHOR52
	mov	w1, 13
	add	x20, x0, x20, lsl 6
	cmn	w25, #1
	strb	w1, [x20, 58]
	ldrb	w1, [x20, 2]
	str	w23, [x20, 52]
	orr	w1, w1, 8
	strb	w1, [x20, 2]
	beq	.L2221
	add	x0, x0, x21, lsl 6
	ldr	w1, [x0, 36]
	cmn	w1, #1
	beq	.L2223
	ldr	x0, [x0, 24]
	ldr	w0, [x0, 4]
	cmp	w1, w0
	beq	.L2223
.L2221:
	adrp	x0, .LANCHOR31
	add	x20, x19, :lo12:.LANCHOR52
	add	x20, x20, x21, lsl 6
	mov	w5, 1
	ldrb	w2, [x0, #:lo12:.LANCHOR31]
	mov	w0, 24
	sub	w0, w0, w2
	ldr	x3, [x20, 24]
	lsl	w5, w5, w2
	adrp	x2, .LANCHOR126
	sub	w5, w5, #1
	ldr	w1, [x20, 40]
	ldrb	w4, [x2, #:lo12:.LANCHOR126]
	mov	x2, x24
	lsl	w6, w5, w0
	lsr	w0, w1, w0
	bic	w1, w1, w6
	and	w0, w0, w5
	bl	flash_read_page_en
	ldr	w2, [x20, 36]
	cmn	w2, #1
	beq	.L2225
	ldr	x0, [x20, 24]
	ldr	w4, [x0, 4]
	cmp	w2, w4
	beq	.L2225
	adrp	x1, .LANCHOR14
	ldr	w1, [x1, #:lo12:.LANCHOR14]
	tbz	x1, 6, .L2225
	ldr	w3, [x0]
	adrp	x0, .LC131
	ldr	w1, [x20, 40]
	add	x0, x0, :lo12:.LC131
	bl	printf
.L2225:
	add	x0, x19, :lo12:.LANCHOR52
	add	x0, x0, x21, lsl 6
	ldr	w1, [x0, 36]
	cmn	w1, #1
	beq	.L2223
	ldr	x0, [x0, 24]
	ldr	w0, [x0, 4]
	cmp	w1, w0
	beq	.L2223
	adrp	x1, .LANCHOR176
	adrp	x0, .LC0
	mov	w2, 375
	add	x1, x1, :lo12:.LANCHOR176
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2223:
	add	x19, x19, :lo12:.LANCHOR52
	mov	w0, 13
	add	x21, x19, x21, lsl 6
	strb	w0, [x21, 58]
	ldrb	w0, [x21, 2]
	str	w23, [x21, 52]
	orr	w0, w0, 8
	strb	w0, [x21, 2]
	b	.L2238
.L2210:
	mov	w0, w21
	mov	w1, 64
	bl	flash_wait_device_ready
	mov	w21, w0
	tbz	x21, 6, .L2238
	mov	w0, 5
	tst	w21, w0
	beq	.L2226
	add	x19, x19, :lo12:.LANCHOR52
	mov	w0, 12
	add	x20, x19, x20, lsl 6
	mov	w4, 12
	mov	w2, w21
	ldrb	w1, [x20, 1]
	ldr	w3, [x20, 40]
	strb	w0, [x20, 58]
	adrp	x0, .LC132
	add	x0, x0, :lo12:.LC132
	bl	printf
.L2302:
	mov	w0, -1
	str	w0, [x20, 52]
	b	.L2204
.L2226:
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
	bne	.L2238
	ldrh	w0, [x21, 50]
	cbnz	w0, .L2238
	adrp	x0, .LANCHOR31
	mov	w5, 1
	adrp	x22, .LANCHOR168
	ldr	w1, [x21, 40]
	ldrb	w2, [x0, #:lo12:.LANCHOR31]
	mov	w0, 24
	ldr	x3, [x22, #:lo12:.LANCHOR168]
	sub	w0, w0, w2
	lsl	w5, w5, w2
	adrp	x2, .LANCHOR126
	sub	w5, w5, #1
	ldrb	w4, [x2, #:lo12:.LANCHOR126]
	adrp	x2, .LANCHOR169
	lsl	w6, w5, w0
	ldr	x2, [x2, #:lo12:.LANCHOR169]
	lsr	w0, w1, w0
	bic	w1, w1, w6
	and	w0, w0, w5
	bl	flash_read_page_en
	cmn	w0, #1
	beq	.L2227
	ldr	x1, [x22, #:lo12:.LANCHOR168]
	ldr	x2, [x21, 24]
	ldr	w1, [x1]
	ldr	w2, [x2]
	cmp	w2, w1
	beq	.L2238
.L2227:
	add	x19, x19, :lo12:.LANCHOR52
	adrp	x1, .LANCHOR48
	add	x20, x19, x20, lsl 6
	mov	w3, w0
	ldrb	w4, [x1, #:lo12:.LANCHOR48]
	adrp	x0, .LC133
	add	x0, x0, :lo12:.LC133
	ldrb	w1, [x20, 1]
	ldr	w2, [x20, 40]
	bl	printf
	mov	w0, -1
	str	w0, [x20, 52]
	b	.L2238
.L2213:
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
.L2229:
	ldrb	w1, [x0]
	cmp	w1, 255
	bne	.L2236
	mov	w21, -1
	b	.L2204
.L2236:
	sxtw	x23, w1
	ubfiz	x0, x1, 6, 8
	add	x1, x22, x23, lsl 6
	add	x0, x22, x0
	ldrb	w6, [x1, 58]
	cmp	w6, w5
	bne	.L2229
	ldr	w1, [x1, 40]
	lsr	w1, w1, w4
	and	w1, w1, w2
	cmp	w3, w1
	bne	.L2229
	mov	w0, w21
	mov	w1, 64
	bl	flash_wait_device_ready
	mov	w21, w0
	tbnz	x21, 6, .L2231
.L2301:
	mov	w21, 0
	b	.L2232
.L2231:
	tst	x21, 15
	beq	.L2233
	add	x22, x22, x20, lsl 6
	mov	w2, w0
	mov	w4, 12
	adrp	x0, .LC134
	add	x0, x0, :lo12:.LC134
	ldrb	w1, [x22, 1]
	ldr	w3, [x22, 40]
	bl	printf
	mov	w0, 12
	strb	w0, [x22, 58]
	mov	w0, -1
	str	w0, [x22, 52]
.L2232:
	add	x1, x19, :lo12:.LANCHOR52
	add	x20, x1, x20, lsl 6
	add	x1, x1, x23, lsl 6
	ldrb	w0, [x20, 58]
	strb	w0, [x1, 58]
	ldr	w0, [x20, 52]
	str	w0, [x1, 52]
.L2204:
	mov	w0, w21
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L2233:
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
	bne	.L2301
	ldrh	w0, [x21, 50]
	cbnz	w0, .L2301
	ldrb	w2, [x24, #:lo12:.LANCHOR31]
	mov	w5, 1
	mov	w0, 24
	adrp	x22, .LANCHOR168
	sub	w0, w0, w2
	ldr	w1, [x21, 40]
	lsl	w5, w5, w2
	adrp	x2, .LANCHOR126
	sub	w5, w5, #1
	ldr	x3, [x22, #:lo12:.LANCHOR168]
	ldrb	w4, [x2, #:lo12:.LANCHOR126]
	adrp	x2, .LANCHOR169
	lsl	w6, w5, w0
	ldr	x2, [x2, #:lo12:.LANCHOR169]
	lsr	w0, w1, w0
	bic	w1, w1, w6
	and	w0, w0, w5
	bl	flash_read_page_en
	cmn	w0, #1
	beq	.L2235
	ldr	x1, [x22, #:lo12:.LANCHOR168]
	ldr	x2, [x21, 24]
	ldr	w1, [x1]
	ldr	w2, [x2]
	cmp	w2, w1
	beq	.L2301
.L2235:
	add	x21, x19, :lo12:.LANCHOR52
	adrp	x1, .LANCHOR48
	add	x21, x21, x20, lsl 6
	mov	w3, w0
	ldrb	w4, [x1, #:lo12:.LANCHOR48]
	adrp	x0, .LC135
	add	x0, x0, :lo12:.LC135
	ldrb	w1, [x21, 1]
	ldr	w2, [x21, 40]
	bl	printf
	mov	w0, -1
	str	w0, [x21, 52]
	b	.L2301
.L2211:
	mov	w0, w21
	mov	w1, 32
	bl	flash_wait_device_ready
	mov	w21, w0
	tbz	x21, 5, .L2238
	add	x19, x19, :lo12:.LANCHOR52
	tst	x21, 15
	add	x20, x19, x20, lsl 6
	beq	.L2237
	mov	w0, 12
	strb	w0, [x20, 58]
	b	.L2302
.L2237:
	mov	w0, 13
	str	wzr, [x20, 52]
	strb	w0, [x20, 58]
	b	.L2238
.L2212:
	mov	w1, 64
	mov	w0, w21
	bl	flash_wait_device_ready
	tbz	x0, 6, .L2238
	add	x19, x19, :lo12:.LANCHOR52
	add	x19, x19, x20, lsl 6
	str	w0, [x19, 52]
	mov	w0, 7
	strb	w0, [x19, 58]
	b	.L2238
	.size	queue_wait_first_req_completed, .-queue_wait_first_req_completed
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
	cbz	w0, .L2304
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L2304
	ldr	w1, [x19, 40]
	adrp	x0, .LC136
	mov	w2, w20
	add	x0, x0, :lo12:.LC136
	bl	printf
.L2304:
	adrp	x23, .LANCHOR41
	adrp	x25, .LANCHOR31
	add	x23, x23, :lo12:.LANCHOR41
	add	x26, x25, :lo12:.LANCHOR31
	mov	w21, 0
.L2305:
	cbnz	w20, .L2316
.L2329:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L2316:
	ldrb	w24, [x19]
	ldr	w22, [x19, 40]
.L2306:
	mov	w1, 1
	mov	w0, w22
	bl	queue_lun_state
	cbnz	w0, .L2307
	cmp	w20, 1
	beq	.L2308
	ldrb	w0, [x23]
	cbnz	w0, .L2309
.L2308:
	mov	x0, x19
	bl	queue_prog_cmd
.L2310:
	subs	w20, w20, #1
	beq	.L2329
	ubfiz	x24, x24, 6, 8
	adrp	x19, .LANCHOR52
	add	x19, x19, :lo12:.LANCHOR52
	add	x19, x19, x24
	b	.L2305
.L2307:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2306
.L2309:
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
	bne	.L2311
	adrp	x1, .LANCHOR177
	adrp	x0, .LC0
	mov	w2, 582
	add	x1, x1, :lo12:.LANCHOR177
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2311:
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
	bne	.L2312
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
	bne	.L2312
	cmp	w21, w3
	beq	.L2312
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
	b	.L2310
.L2312:
	mov	x0, x19
	mov	w21, 0
	bl	queue_prog_cmd
	b	.L2310
	.size	sblk_prog_page, .-sblk_prog_page
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
.L2332:
	ldrb	w0, [x19]
	cmp	w0, 255
	bne	.L2333
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L2333:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2332
	.size	sblk_wait_write_queue_completed, .-sblk_wait_write_queue_completed
	.section	.text.ftl_flush,"ax",@progbits
	.align	2
	.global	ftl_flush
	.type	ftl_flush, %function
ftl_flush:
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR124
	add	x29, sp, 0
	ldrb	w1, [x0, #:lo12:.LANCHOR124]
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	adrp	x20, .LANCHOR178
	cbz	w1, .L2336
	ldrb	w2, [x20, #:lo12:.LANCHOR178]
	adrp	x0, .LANCHOR52
	add	x0, x0, :lo12:.LANCHOR52
	add	x0, x0, x2, lsl 6
	bl	sblk_prog_page
.L2336:
	mov	w0, -1
	strb	wzr, [x19, #:lo12:.LANCHOR124]
	strb	w0, [x20, #:lo12:.LANCHOR178]
	bl	sblk_wait_write_queue_completed
	bl	ftl_write_completed
	ldp	x19, x20, [sp, 16]
	mov	w0, -1
	ldp	x29, x30, [sp], 32
	b	ftl_vpn_decrement
	.size	ftl_flush, .-ftl_flush
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
	adrp	x25, .LANCHOR179
	add	x28, x27, :lo12:.LANCHOR31
	add	x25, x25, :lo12:.LANCHOR179
.L2346:
	cbnz	w21, .L2356
.L2369:
	adrp	x19, .LANCHOR52
	add	x19, x19, :lo12:.LANCHOR52
.L2357:
	cbnz	w22, .L2359
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L2356:
	ldrb	w24, [x19]
	ldr	w26, [x19, 40]
.L2347:
	mov	w1, 0
	mov	w0, w26
	bl	queue_lun_state
	cbnz	w0, .L2348
	cmp	w21, 1
	beq	.L2353
	ldrb	w0, [x25]
	cbnz	w0, .L2350
.L2353:
	mov	x0, x19
	bl	queue_read_cmd
	b	.L2351
.L2348:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2347
.L2350:
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
	bne	.L2352
	adrp	x1, .LANCHOR180
	adrp	x0, .LC0
	mov	w2, 660
	add	x1, x1, :lo12:.LANCHOR180
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2352:
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
	bne	.L2353
	adrp	x0, .LANCHOR105
	ldrh	w0, [x0, #:lo12:.LANCHOR105]
	add	w26, w0, w26
	cmp	w1, w26
	bne	.L2353
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
.L2351:
	subs	w21, w21, #1
	beq	.L2369
	ubfiz	x24, x24, 6, 8
	adrp	x19, .LANCHOR52
	add	x19, x19, :lo12:.LANCHOR52
	add	x19, x19, x24
	b	.L2346
.L2359:
	ldrb	w0, [x23, 58]
	cmp	w0, 13
	bne	.L2358
	ldrb	w0, [x23]
	sub	w22, w22, #1
	cmp	w0, 255
	beq	.L2358
	ubfiz	x23, x0, 6, 8
	add	x23, x19, x23
.L2358:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2357
	.size	sblk_read_page, .-sblk_read_page
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
.L2372:
	mov	w1, 1
	mov	w0, w20
	bl	queue_lun_state
	cbnz	w0, .L2373
	mov	x0, x19
	bl	queue_tlc_prog_cmd
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L2373:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2372
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
.L2376:
	mov	w1, 1
	mov	w0, w19
	bl	queue_lun_state
	cbnz	w0, .L2377
	cmp	w24, 2
	bne	.L2378
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
.L2379:
	mov	w0, 0
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L2377:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2376
.L2378:
	mov	x0, x20
	bl	queue_tlc_prog_cmd
	b	.L2379
	.size	sblk_xlc_prog_pages, .-sblk_xlc_prog_pages
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
.L2382:
	cmp	x21, x25
	bne	.L2385
	mov	w0, 0
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L2385:
	ldr	x0, [x25, -8]
	ldr	w19, [x0, 40]
.L2383:
	mov	w1, 1
	mov	w0, w19
	bl	queue_lun_state
	cbnz	w0, .L2384
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
	bl	nandc_de_cs.constprop.31
	ldr	x1, [x25, -24]
	mov	w0, 4
	strb	w22, [x1, 59]
	strb	w0, [x1, 58]
	mov	w0, -1
	strb	w0, [x1]
	mov	x0, x24
	bl	buf_add_tail
	b	.L2382
.L2384:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2383
	.size	sblk_3d_mlc_prog_pages, .-sblk_3d_mlc_prog_pages
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
	bhi	.L2388
	adrp	x1, .LANCHOR181
	adrp	x0, .LC0
	mov	w2, 564
	add	x1, x1, :lo12:.LANCHOR181
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2388:
	ldrb	w0, [x19, #:lo12:.LANCHOR18]
	cmp	w0, w21
	bls	.L2399
	adrp	x0, .LANCHOR30
	add	x0, x0, :lo12:.LANCHOR30
	ldrb	w27, [x0, w21, sxtw]
	cbnz	w24, .L2401
	adrp	x0, .LANCHOR0
	ldrb	w1, [x0, #:lo12:.LANCHOR0]
	adrp	x0, .LANCHOR1
	cbz	w1, .L2391
	ldrb	w1, [x0, #:lo12:.LANCHOR1]
	cbz	w1, .L2401
.L2391:
	adrp	x1, .LANCHOR2
	ldrb	w0, [x0, #:lo12:.LANCHOR1]
	ldrh	w1, [x1, #:lo12:.LANCHOR2]
	udiv	w19, w20, w1
	mul	w19, w19, w1
	sub	w1, w20, w19
	cbz	w0, .L2392
	add	w19, w19, w1, lsl 1
.L2390:
	adrp	x24, .LANCHOR14
	adrp	x25, .LC137
	add	x24, x24, :lo12:.LANCHOR14
	add	x25, x25, :lo12:.LC137
	adrp	x26, .LANCHOR168
.L2396:
	ldr	w0, [x24]
	tbz	x0, 4, .L2393
	mov	w3, w19
	mov	w2, w20
	mov	w1, w27
	mov	x0, x25
	bl	printf
.L2393:
	mov	w4, w28
	mov	x3, x22
	mov	x2, x23
	mov	w1, w19
	mov	w0, w27
	bl	flash_prog_page
	mov	w5, w0
	ldr	w0, [x29, 124]
	cbz	w0, .L2394
	adrp	x6, .LANCHOR169
	ldr	x3, [x26, #:lo12:.LANCHOR168]
	mov	w4, w28
	str	x6, [x29, 112]
	ldr	x2, [x6, #:lo12:.LANCHOR169]
	mov	w1, w20
	mov	w0, w21
	str	w5, [x29, 104]
	bl	flash_read_page_en
	cmp	w0, 512
	ldr	x6, [x29, 112]
	mov	w4, w0
	ccmn	w0, #1, 4, ne
	mov	x7, x6
	beq	.L2395
	ldr	x0, [x6, #:lo12:.LANCHOR169]
	ldr	w1, [x23]
	ldr	w5, [x29, 104]
	ldr	w0, [x0]
	cmp	w1, w0
	bne	.L2395
	ldr	x0, [x26, #:lo12:.LANCHOR168]
	ldr	w1, [x22]
	ldr	w0, [x0]
	cmp	w1, w0
	beq	.L2394
.L2395:
	str	w4, [x29, 112]
	mov	w3, 4
	str	x7, [x29, 104]
	mov	w2, w3
	mov	x1, x23
	adrp	x0, .LC138
	add	x0, x0, :lo12:.LC138
	bl	rknand_print_hex
	mov	w3, 4
	mov	x1, x22
	mov	w2, w3
	adrp	x0, .LC139
	add	x0, x0, :lo12:.LC139
	bl	rknand_print_hex
	adrp	x0, .LANCHOR168
	mov	w3, 4
	mov	w2, w3
	ldr	x1, [x0, #:lo12:.LANCHOR168]
	adrp	x0, .LC140
	add	x0, x0, :lo12:.LC140
	bl	rknand_print_hex
	ldr	x7, [x29, 104]
	mov	w3, 4
	adrp	x0, .LC141
	mov	w2, w3
	add	x0, x0, :lo12:.LC141
	ldr	x1, [x7, #:lo12:.LANCHOR169]
	bl	rknand_print_hex
	ldr	w4, [x29, 112]
	cmp	w4, 512
	beq	.L2396
.L2398:
	mov	w1, w20
	adrp	x0, .LC142
	add	x0, x0, :lo12:.LC142
	bl	printf
	adrp	x1, .LANCHOR181
	adrp	x0, .LC0
	mov	w2, 597
	add	x1, x1, :lo12:.LANCHOR181
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2399:
	mov	w0, -1
	b	.L2387
.L2392:
	adrp	x0, .LANCHOR3
	add	x0, x0, :lo12:.LANCHOR3
	ldrh	w0, [x0, w1, uxtw 1]
	add	w19, w0, w19
	b	.L2390
.L2401:
	mov	w19, w20
	b	.L2390
.L2394:
	mov	w0, w5
	cmn	w5, #1
	beq	.L2398
.L2387:
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
	adrp	x25, .LANCHOR182
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
	str	wzr, [x25, #:lo12:.LANCHOR182]
	str	x0, [x29, 96]
.L2418:
	ldr	x0, [x29, 112]
	ldrb	w0, [x0]
	cmp	w0, w20
	bls	.L2428
	add	x0, x27, :lo12:.LANCHOR69
	mov	w22, 0
	str	x0, [x29, 120]
	adrp	x0, .LANCHOR14
	add	x0, x0, :lo12:.LANCHOR14
	str	x0, [x29, 104]
	b	.L2429
.L2427:
	ldr	x0, [x29, 104]
	ldr	w0, [x0]
	tbz	x0, 12, .L2419
	adrp	x0, .LC143
	mov	w1, w21
	add	x0, x0, :lo12:.LC143
	bl	printf
.L2419:
	ldr	x0, [x29, 96]
	ldrb	w19, [x0]
	madd	w19, w21, w19, w22
	and	w19, w19, 65535
	cbnz	w20, .L2420
	adrp	x0, .LANCHOR27
	ldr	x0, [x0, #:lo12:.LANCHOR27]
	ldrb	w0, [x0, 47]
	cmp	w0, w19
	bcs	.L2421
.L2420:
	and	w28, w20, 255
	mov	w1, w19
	mov	w0, w28
	bl	flash_check_bad_block
	cbnz	w0, .L2421
	adrp	x0, .LANCHOR105
	mov	w1, w23
	ldrh	w7, [x0, #:lo12:.LANCHOR105]
	mov	w0, w28
	mul	w26, w7, w19
	mov	w2, w26
	bl	flash_erase_block_en
	cbz	w0, .L2422
	adrp	x0, .LANCHOR73
	ldrb	w0, [x0, #:lo12:.LANCHOR73]
	cmp	w0, 2
	bne	.L2444
	adrp	x0, .LANCHOR0
	ldrb	w0, [x0, #:lo12:.LANCHOR0]
	cbz	w0, .L2444
	mov	w2, w26
	mov	w1, 1
	mov	w0, w28
	bl	flash_erase_block_en
	cbnz	w0, .L2444
.L2426:
	adrp	x0, .LANCHOR73
	mov	w23, 1
	ldrb	w0, [x0, #:lo12:.LANCHOR73]
	add	w26, w26, w0, lsl 24
.L2425:
	adrp	x0, .LANCHOR126
	mov	w5, 1
	add	x3, x25, :lo12:.LANCHOR182
	add	x2, x24, :lo12:ftl_tmp_buffer
	ldrb	w4, [x0, #:lo12:.LANCHOR126]
	mov	w1, w26
	mov	w0, w28
	bl	flash_prog_page_en
	cbz	w0, .L2421
.L2444:
	mov	w1, w19
	mov	w0, w28
	bl	flash_mask_bad_block
.L2421:
	add	w22, w22, 1
	and	w22, w22, 65535
.L2429:
	ldr	x0, [x29, 120]
	ldrb	w0, [x0]
	cmp	w0, w22
	bhi	.L2427
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L2418
.L2422:
	cbz	w23, .L2425
	b	.L2426
.L2428:
	cbz	w23, .L2430
	adrp	x0, .LANCHOR7
	mov	w1, 2
	ldr	x0, [x0, #:lo12:.LANCHOR7]
	add	x21, x0, x21, uxth 2
	ldrb	w0, [x21, 2]
	bfi	w0, w1, 3, 2
	strb	w0, [x21, 2]
.L2430:
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
	bne	.L2445
	mov	w2, 2350
	adrp	x1, .LANCHOR183
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR183
	add	x0, x0, :lo12:.LC0
	bl	printf
	adrp	x0, .LC142
	mov	w1, w20
	add	x0, x0, :lo12:.LC142
	bl	printf
.L2445:
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
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR126
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR184
	ldrb	w2, [x21, #:lo12:.LANCHOR126]
	stp	x25, x26, [sp, 64]
	adrp	x25, .LANCHOR104
	str	w0, [x29, 116]
	add	x0, x20, :lo12:.LANCHOR184
	stp	x23, x24, [sp, 48]
	lsl	w2, w2, 1
	stp	x27, x28, [sp, 80]
	bl	ftl_memset
	adrp	x0, .LANCHOR74
	ldrb	w0, [x0, #:lo12:.LANCHOR74]
	cbz	w0, .L2449
	ldr	x0, [x25, #:lo12:.LANCHOR104]
	strh	wzr, [x0, 150]
	str	wzr, [x0, 156]
.L2449:
	ldr	x0, [x25, #:lo12:.LANCHOR104]
	ldrh	w1, [x0, 74]
	cbz	w1, .L2450
	strh	wzr, [x0, 150]
.L2450:
	adrp	x23, .LANCHOR185
	add	x19, x23, :lo12:.LANCHOR185
	adrp	x24, .LANCHOR105
	mov	w26, 0
	add	x0, x24, :lo12:.LANCHOR105
	str	x0, [x29, 104]
.L2463:
	add	x0, x23, :lo12:.LANCHOR185
	ldrh	w1, [x24, #:lo12:.LANCHOR105]
	add	x7, x20, :lo12:.LANCHOR184
	str	w1, [x29, 120]
	ldrb	w1, [x21, #:lo12:.LANCHOR126]
	adrp	x22, ftl_info_data_buffer
	ldrh	w27, [x0, 2]
	ldr	x0, [x25, #:lo12:.LANCHOR104]
	lsl	w1, w1, 9
	ldrb	w28, [x23, #:lo12:.LANCHOR185]
	ldr	w6, [x0, 4]
	add	w6, w6, 1
	str	w6, [x0, 4]
	ldr	w0, [x29, 116]
	str	w0, [x20, #:lo12:.LANCHOR184]
	add	x0, x22, :lo12:ftl_info_data_buffer
	str	w6, [x7, 4]
	bl	js_hash
	str	w0, [x7, 8]
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2451
	adrp	x0, .LC144
	mov	w3, w6
	mov	w2, w27
	mov	w1, w28
	add	x0, x0, :lo12:.LC144
	bl	printf
.L2451:
	adrp	x1, .LANCHOR87
	ldrh	w0, [x19, 2]
	ldrh	w1, [x1, #:lo12:.LANCHOR87]
	cmp	w1, w0
	bhi	.L2452
	adrp	x27, .LANCHOR186
	adrp	x3, .LC0
	add	x27, x27, :lo12:.LANCHOR186
	add	x3, x3, :lo12:.LC0
.L2459:
	ldrb	w0, [x19, 1]
	adrp	x28, .LANCHOR27
	add	w0, w0, 1
	and	w0, w0, 255
	strb	w0, [x19, 1]
	cmp	w0, 7
	bls	.L2453
	mov	x0, 0
.L2458:
	ldr	x2, [x28, #:lo12:.LANCHOR27]
	add	w1, w0, 8
	and	w26, w0, 65535
	add	x1, x2, x1, sxtw
	ldrb	w2, [x1, 32]
	add	w1, w2, 127
	and	w1, w1, 255
	cmp	w1, 125
	bhi	.L2454
	mov	x0, x3
	str	x3, [x29, 120]
	mov	w2, 761
	mov	x1, x27
	bl	printf
	ldr	x3, [x29, 120]
.L2457:
	strb	w26, [x19, 1]
	mov	w26, 1
.L2453:
	ldr	x0, [x28, #:lo12:.LANCHOR27]
	ldrb	w1, [x19, 1]
	add	x0, x0, x1
	ldrb	w28, [x0, 40]
	strb	w28, [x19]
	cmp	w28, 255
	beq	.L2459
	ldr	x0, [x29, 104]
	ldrh	w27, [x0]
	mov	w0, 0
	mul	w27, w27, w28
	mov	w1, w27
	bl	flash_erase_block
	ldrb	w4, [x21, #:lo12:.LANCHOR126]
	mov	w1, w27
	add	x3, x20, :lo12:.LANCHOR184
	add	x2, x22, :lo12:ftl_info_data_buffer
	mov	w0, 0
	add	w27, w27, 1
	bl	ftl_prog_page
	mov	w0, 1
	strh	w0, [x19, 2]
.L2460:
	ldrb	w4, [x21, #:lo12:.LANCHOR126]
	mov	w1, w27
	add	x3, x20, :lo12:.LANCHOR184
	add	x2, x22, :lo12:ftl_info_data_buffer
	mov	w0, 0
	bl	ftl_prog_page
	cmn	w0, #1
	ldrh	w1, [x19, 2]
	adrp	x0, .LANCHOR187
	add	w1, w1, 1
	strh	w1, [x19, 2]
	beq	.L2461
	ldrb	w1, [x0, #:lo12:.LANCHOR187]
	cbz	w1, .L2462
.L2461:
	strb	wzr, [x0, #:lo12:.LANCHOR187]
	b	.L2463
.L2454:
	cmp	w2, 255
	bne	.L2457
	add	x0, x0, 1
	cmp	x0, 8
	bne	.L2458
	mov	w26, w0
	b	.L2457
.L2452:
	ldr	w1, [x29, 120]
	madd	w27, w1, w28, w27
	cbnz	w0, .L2460
	mov	w1, w27
	bl	flash_erase_block
	b	.L2460
.L2462:
	cbnz	w26, .L2464
.L2472:
	adrp	x0, .LANCHOR185
	ldrb	w0, [x0, #:lo12:.LANCHOR185]
	cmp	w0, 255
	bne	.L2466
	adrp	x1, .LANCHOR186
	adrp	x0, .LC0
	mov	w2, 797
	add	x1, x1, :lo12:.LANCHOR186
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2466:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L2464:
	ldrb	w19, [x19, 1]
	adrp	x20, .LANCHOR186
	adrp	x21, .LC0
	add	x20, x20, :lo12:.LANCHOR186
	add	w19, w19, 1
	add	x21, x21, :lo12:.LC0
	adrp	x22, .LANCHOR27
.L2467:
	cmp	w19, 7
	bhi	.L2472
	ldr	x1, [x22, #:lo12:.LANCHOR27]
	add	w0, w19, 8
	add	x0, x1, x0, sxtw
	ldrb	w23, [x0, 32]
	add	w0, w23, 127
	and	w0, w0, 255
	cmp	w0, 125
	bhi	.L2468
	mov	w2, 790
	mov	x1, x20
	mov	x0, x21
	bl	printf
.L2469:
	adrp	x0, .LANCHOR105
	ldrh	w1, [x0, #:lo12:.LANCHOR105]
	mov	w0, 0
	mul	w1, w1, w23
	bl	flash_erase_block
	b	.L2470
.L2468:
	cmp	w23, 255
	bne	.L2469
.L2470:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L2467
	.size	ftl_info_flush, .-ftl_info_flush
	.section	.text.ftl_info_blk_init,"ax",@progbits
	.align	2
	.global	ftl_info_blk_init
	.type	ftl_info_blk_init, %function
ftl_info_blk_init:
	stp	x29, x30, [sp, -128]!
	adrp	x0, .LANCHOR188
	adrp	x1, .LANCHOR187
	mov	w2, 16384
	add	x29, sp, 0
	strb	wzr, [x0, #:lo12:.LANCHOR188]
	mov	w0, 1
	strb	w0, [x1, #:lo12:.LANCHOR187]
	adrp	x1, .LANCHOR189
	stp	x21, x22, [sp, 32]
	adrp	x21, ftl_info_data_buffer
	strb	w0, [x1, #:lo12:.LANCHOR189]
	adrp	x1, .LANCHOR7
	add	x0, x21, :lo12:ftl_info_data_buffer
	stp	x19, x20, [sp, 16]
	str	x0, [x1, #:lo12:.LANCHOR7]
	adrp	x1, .LANCHOR6
	adrp	x19, .LANCHOR104
	stp	x23, x24, [sp, 48]
	ldrh	w1, [x1, #:lo12:.LANCHOR6]
	adrp	x23, .LANCHOR27
	stp	x25, x26, [sp, 64]
	adrp	x20, .LANCHOR185
	stp	x27, x28, [sp, 80]
	adrp	x26, .LANCHOR105
	add	x1, x0, x1, lsl 2
	str	x1, [x19, #:lo12:.LANCHOR104]
	mov	w1, 0
	bl	ftl_memset
	mov	w1, 0
	mov	w2, 16384
	adrp	x0, ftl_ext_info_data_buffer
	add	x0, x0, :lo12:ftl_ext_info_data_buffer
	bl	ftl_memset
	adrp	x24, .LANCHOR126
	ldr	x1, [x23, #:lo12:.LANCHOR27]
	add	x0, x20, :lo12:.LANCHOR185
	mov	w27, 21574
	add	x26, x26, :lo12:.LANCHOR105
	add	x24, x24, :lo12:.LANCHOR126
	mov	x22, 7
	strb	wzr, [x0, 1]
	movk	w27, 0x494c, lsl 16
	ldrb	w1, [x1, 40]
	strb	w1, [x20, #:lo12:.LANCHOR185]
	strh	wzr, [x0, 2]
.L2494:
	ldr	x1, [x23, #:lo12:.LANCHOR27]
	add	w0, w22, 8
	sxth	w25, w22
	mov	w28, w22
	add	x0, x1, x0, sxtw
	ldrb	w0, [x0, 32]
	cmp	w0, 255
	bne	.L2493
.L2498:
	sub	x22, x22, #1
	cmn	x22, #1
	bne	.L2494
	mov	w25, 0
.L2495:
	adrp	x24, .LANCHOR14
	ldr	w0, [x24, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2499
	ldr	x0, [x19, #:lo12:.LANCHOR104]
	mov	w2, 4800
	mov	w1, w22
	ldr	w3, [x0]
	adrp	x0, .LC146
	add	x0, x0, :lo12:.LC146
	bl	printf
.L2499:
	cmn	w22, #1
	bne	.L2500
	mov	w1, 0
	mov	w2, 16384
	add	x0, x21, :lo12:ftl_info_data_buffer
	bl	ftl_memset
	ldr	x0, [x19, #:lo12:.LANCHOR104]
	mov	w1, 21574
	movk	w1, 0x494c, lsl 16
	str	w1, [x0]
	mov	w1, 34
	movk	w1, 0x6, lsl 16
	str	w1, [x0, 12]
	mov	w0, w22
.L2492:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L2493:
	ldrh	w6, [x26]
	add	x8, x21, :lo12:ftl_info_data_buffer
	ldrb	w4, [x24]
	adrp	x7, .LANCHOR184
	add	x7, x7, :lo12:.LANCHOR184
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
	bne	.L2496
	ldrb	w4, [x24]
	mov	x3, x7
	mov	x2, x8
	add	w1, w6, 1
	mov	w0, 0
	bl	ftl_read_page
	mov	w5, w0
.L2496:
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2497
	ldr	x0, [x19, #:lo12:.LANCHOR104]
	mov	w2, w5
	str	w5, [x29, 124]
	mov	w3, 672
	mov	w1, w28
	ldr	w4, [x0]
	adrp	x0, .LC145
	add	x0, x0, :lo12:.LC145
	bl	printf
	ldr	w5, [x29, 124]
.L2497:
	cmn	w5, #1
	beq	.L2498
	ldr	x0, [x19, #:lo12:.LANCHOR104]
	ldr	w0, [x0]
	cmp	w0, w27
	bne	.L2498
	mov	w22, w25
	b	.L2495
.L2500:
	ldr	x1, [x23, #:lo12:.LANCHOR27]
	add	w0, w25, 8
	mov	w4, 4
	add	x2, x21, :lo12:ftl_info_data_buffer
	adrp	x26, .LANCHOR126
	mov	w28, 21574
	add	x0, x1, x0, sxtw
	adrp	x27, .LC147
	add	x26, x26, :lo12:.LANCHOR126
	add	x27, x27, :lo12:.LC147
	movk	w28, 0x494c, lsl 16
	ldrb	w1, [x0, 32]
	add	x0, x20, :lo12:.LANCHOR185
	strb	w1, [x20, #:lo12:.LANCHOR185]
	strb	w25, [x0, 1]
	adrp	x25, .LANCHOR184
	mov	w0, 0
	add	x3, x25, :lo12:.LANCHOR184
	bl	flash_get_last_written_page
	sxth	w22, w0
	add	w0, w0, 1
	ldrb	w23, [x20, #:lo12:.LANCHOR185]
	and	w0, w0, 65535
	str	w0, [x29, 124]
	adrp	x0, .LANCHOR105
	ldrh	w0, [x0, #:lo12:.LANCHOR105]
	madd	w23, w23, w0, w22
.L2502:
	tbnz	w22, #31, .L2506
	ldrb	w4, [x26]
	add	x6, x25, :lo12:.LANCHOR184
	add	x5, x21, :lo12:ftl_info_data_buffer
	mov	x3, x6
	mov	x2, x5
	mov	w1, w23
	mov	w0, 0
	stp	x6, x5, [x29, 104]
	bl	ftl_read_page
	cmn	w0, #1
	beq	.L2503
	ldr	x0, [x19, #:lo12:.LANCHOR104]
	ldp	x6, x5, [x29, 104]
	ldr	w0, [x0]
	cmp	w0, w28
	bne	.L2503
	ldr	w6, [x6, 8]
	cbnz	w6, .L2504
.L2506:
	ldrh	w0, [x29, 124]
	add	x20, x20, :lo12:.LANCHOR185
	strh	w0, [x20, 2]
	bl	ftl_tmp_into_update
	ldr	x1, [x19, #:lo12:.LANCHOR104]
	ldr	w0, [x1, 64]
	add	w0, w0, 1
	str	w0, [x1, 64]
	mov	w0, 0
	bl	ftl_info_flush
	mov	w0, 0
	bl	ftl_info_flush
	ldr	w0, [x24, #:lo12:.LANCHOR14]
	tbnz	x0, 14, .L2505
.L2522:
	mov	w0, 0
	b	.L2492
.L2504:
	ldrb	w1, [x26]
	mov	x0, x5
	lsl	w1, w1, 9
	bl	js_hash
	cmp	w6, w0
	beq	.L2506
	mov	w1, w6
	mov	x0, x27
	bl	printf
.L2503:
	sub	w22, w22, #1
	sub	w23, w23, #1
	sxth	w22, w22
	b	.L2502
.L2505:
	ldr	x0, [x19, #:lo12:.LANCHOR104]
	ldr	w1, [x0, 156]
	adrp	x0, .LC148
	add	x0, x0, :lo12:.LC148
	bl	printf
	b	.L2522
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
	cbz	w1, .L2524
	str	wzr, [x0, 520]
.L2524:
	adrp	x20, .LANCHOR87
	adrp	x22, .LANCHOR190
	adrp	x21, .LANCHOR31
	add	x20, x20, :lo12:.LANCHOR87
	add	x22, x22, :lo12:.LANCHOR190
	add	x21, x21, :lo12:.LANCHOR31
	mov	w0, 0
	bl	ftl_total_vpn_update
.L2525:
	adrp	x23, .LANCHOR104
	mov	x24, x23
.L2528:
	ldr	x0, [x23, #:lo12:.LANCHOR104]
	ldr	w1, [x0, 56]
	add	w1, w1, 1
	str	w1, [x0, 56]
	ldrh	w1, [x0, 140]
	ldrh	w0, [x20]
	cmp	w1, w0
	bcc	.L2526
	bl	ftl_ext_alloc_new_blk
.L2526:
	ldr	x0, [x24, #:lo12:.LANCHOR104]
	ldrh	w1, [x0, 130]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L2527
	adrp	x0, .LC0
	mov	w2, 1926
	mov	x1, x22
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2527:
	ldrb	w19, [x21]
	mov	w0, 24
	ldr	x1, [x24, #:lo12:.LANCHOR104]
	adrp	x26, .LANCHOR126
	sub	w19, w0, w19
	adrp	x0, .LANCHOR68
	adrp	x27, .LANCHOR184
	add	x25, x27, :lo12:.LANCHOR184
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
	ldrb	w2, [x26, #:lo12:.LANCHOR126]
	mov	x0, x25
	lsl	w2, w2, 1
	bl	ftl_memset
	ldr	x0, [x24, #:lo12:.LANCHOR104]
	adrp	x6, ftl_ext_info_data_buffer
	ldrb	w7, [x26, #:lo12:.LANCHOR126]
	add	x6, x6, :lo12:ftl_ext_info_data_buffer
	str	wzr, [x27, #:lo12:.LANCHOR184]
	ldr	w0, [x0, 56]
	lsl	w1, w7, 9
	str	w0, [x25, 4]
	mov	x0, x6
	bl	js_hash
	mov	x2, x6
	mov	w1, w19
	str	w0, [x25, 8]
	mov	w4, w7
	mov	x3, x25
	mov	w0, w28
	bl	ftl_prog_page
	ldr	x2, [x24, #:lo12:.LANCHOR104]
	ldrh	w1, [x2, 140]
	add	w1, w1, 1
	and	w1, w1, 65535
	strh	w1, [x2, 140]
	cmp	w1, 1
	beq	.L2528
	cmn	w0, #1
	adrp	x0, .LANCHOR189
	beq	.L2529
	ldrb	w1, [x0, #:lo12:.LANCHOR189]
	cbz	w1, .L2530
.L2529:
	strb	wzr, [x0, #:lo12:.LANCHOR189]
	b	.L2525
.L2530:
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
	stp	x29, x30, [sp, -128]!
	adrp	x0, .LANCHOR115
	adrp	x2, .LANCHOR68
	mov	w4, 4
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR104
	strh	wzr, [x0, #:lo12:.LANCHOR115]
	ldr	x0, [x20, #:lo12:.LANCHOR104]
	stp	x21, x22, [sp, 32]
	stp	x27, x28, [sp, 80]
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR184
	ldrh	w1, [x0, 130]
	adrp	x0, .LANCHOR31
	stp	x25, x26, [sp, 64]
	adrp	x24, ftl_ext_info_data_buffer
	ldrb	w19, [x0, #:lo12:.LANCHOR31]
	mov	w0, 24
	add	x3, x23, :lo12:.LANCHOR184
	sub	w0, w0, w19
	ldrh	w19, [x2, #:lo12:.LANCHOR68]
	add	x2, x24, :lo12:ftl_ext_info_data_buffer
	sub	w0, w0, w19
	mov	w19, 1
	lsl	w19, w19, w0
	sub	w19, w19, #1
	asr	w21, w1, w0
	and	w19, w19, w1
	and	w27, w21, 255
	mov	w1, w19
	mov	w0, w27
	bl	flash_get_last_written_page
	sxth	w22, w0
	adrp	x0, .LANCHOR14
	stp	x0, x23, [x29, 112]
	ldr	w1, [x0, #:lo12:.LANCHOR14]
	tbz	x1, 12, .L2541
	ldr	x0, [x20, #:lo12:.LANCHOR104]
	adrp	x1, .LANCHOR191
	and	w4, w21, 65535
	mov	w3, w22
	mov	w2, 1971
	add	x1, x1, :lo12:.LANCHOR191
	ldrh	w5, [x0, 130]
	adrp	x0, .LC149
	add	x0, x0, :lo12:.LC149
	bl	printf
.L2541:
	adrp	x25, .LANCHOR126
	adrp	x26, .LANCHOR105
	mov	w28, 20038
	add	x25, x25, :lo12:.LANCHOR126
	add	x26, x26, :lo12:.LANCHOR105
	mov	w23, 0
	movk	w28, 0x4549, lsl 16
.L2542:
	and	w21, w22, 65535
	sub	w0, w21, w23
	tbnz	x0, 15, .L2547
	ldr	x0, [x29, 120]
	sub	w1, w22, w23
	ldrb	w4, [x25]
	add	x5, x24, :lo12:ftl_ext_info_data_buffer
	add	x6, x0, :lo12:.LANCHOR184
	ldrh	w0, [x26]
	mov	x2, x5
	mov	x3, x6
	stp	x6, x5, [x29, 96]
	madd	w1, w0, w19, w1
	mov	w0, w27
	bl	flash_read_page_en
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	beq	.L2543
	adrp	x0, .LANCHOR10
	ldp	x6, x5, [x29, 96]
	ldr	x0, [x0, #:lo12:.LANCHOR10]
	ldr	w0, [x0]
	cmp	w0, w28
	bne	.L2543
	ldr	w6, [x6, 8]
	cbnz	w6, .L2544
.L2547:
	bl	zftl_sblk_list_init
	ldr	x0, [x20, #:lo12:.LANCHOR104]
	ldrh	w1, [x0, 140]
	cmp	w1, w22
	bgt	.L2546
	add	w21, w21, 1
	strh	w21, [x0, 140]
	bl	ftl_ext_info_flush
.L2546:
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
	ldr	x1, [x29, 112]
	str	wzr, [x0, 520]
	str	wzr, [x0, 604]
	str	wzr, [x0, 608]
	ldr	w1, [x1, #:lo12:.LANCHOR14]
	tbz	x1, 12, .L2549
	ldr	w3, [x0, 12]
	adrp	x1, .LANCHOR191
	adrp	x0, .LC151
	mov	w4, 0
	mov	w2, 0
	add	x1, x1, :lo12:.LANCHOR191
	add	x0, x0, :lo12:.LC151
	bl	printf
.L2549:
	adrp	x0, .LANCHOR66
	mov	w1, -1
	ldp	x19, x20, [sp, 16]
	strh	w1, [x0, #:lo12:.LANCHOR66]
	ldp	x21, x22, [sp, 32]
	mov	w0, 0
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L2544:
	ldrb	w1, [x25]
	mov	x0, x5
	lsl	w1, w1, 9
	bl	js_hash
	cmp	w6, w0
	beq	.L2547
	adrp	x0, .LC150
	mov	w1, w6
	add	x0, x0, :lo12:.LC150
	bl	printf
.L2543:
	add	w23, w23, 1
	b	.L2542
	.size	ftl_ext_info_init, .-ftl_ext_info_init
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
	bcs	.L2561
	adrp	x1, .LANCHOR192
	adrp	x0, .LC0
	mov	w2, 2172
	add	x1, x1, :lo12:.LANCHOR192
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2561:
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
	adrp	x0, .LANCHOR193
	ldrh	w0, [x0, #:lo12:.LANCHOR193]
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
	adrp	x0, .LC152
	add	x0, x0, :lo12:.LC152
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR194
	stp	x21, x22, [sp, 32]
	add	x20, x20, :lo12:.LANCHOR194
	stp	x25, x26, [sp, 64]
	adrp	x22, .LANCHOR27
	mov	x25, x22
	stp	x23, x24, [sp, 48]
	mov	w19, 8
	adrp	x23, .LC0
	bl	printf
.L2566:
	ldr	x0, [x22, #:lo12:.LANCHOR27]
	add	x0, x0, x19, sxtw
	ldrb	w21, [x0, 32]
	add	w0, w21, 127
	and	w0, w0, 255
	cmp	w0, 125
	bhi	.L2564
	mov	w2, 2226
	mov	x1, x20
	add	x0, x23, :lo12:.LC0
	bl	printf
.L2564:
	cmp	w21, 255
	beq	.L2565
	adrp	x0, .LANCHOR105
	ldrh	w1, [x0, #:lo12:.LANCHOR105]
	mov	w0, 0
	mul	w1, w1, w21
	bl	flash_erase_block
.L2565:
	add	w19, w19, 1
	cmp	w19, 16
	bne	.L2566
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
.L2567:
	cmp	x0, x2
	bne	.L2568
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
.L2569:
	ldrh	w0, [x19, #:lo12:.LANCHOR6]
	adrp	x23, .LANCHOR69
	cmp	w0, w20
	bhi	.L2578
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
.L2581:
	cmp	w2, 4
	add	x1, x1, 4
	csel	w7, w10, w4, eq
	strb	w7, [x1, -1]
	ldrb	w7, [x1, -2]
	orr	w7, w7, -32
	strb	w7, [x1, -2]
	cmp	x1, x0
	bne	.L2581
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
	tbz	x0, 12, .L2582
	adrp	x0, .LC153
	mov	w3, w20
	mov	w2, 128
	mov	w1, 2273
	add	x0, x0, :lo12:.LC153
	bl	printf
.L2582:
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
.L2583:
	cmp	w20, w8
	bcc	.L2589
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
.L2568:
	ldrb	w1, [x0, 2]
	add	x0, x0, 4
	and	w1, w1, 31
	bfi	w1, w3, 3, 2
	strb	w1, [x0, -2]
	b	.L2567
.L2578:
	adrp	x0, .LANCHOR75
	strh	w20, [x24]
	ldrb	w0, [x0, #:lo12:.LANCHOR75]
	cbnz	w0, .L2570
	mov	w0, w20
	bl	ftl_test_block
.L2570:
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
.L2571:
	cmp	w8, w14
	bcs	.L2575
	add	w15, w11, w7
	b	.L2576
.L2574:
	add	w1, w7, w12
	mov	w0, w8
	bl	flash_check_bad_block
	cbz	w0, .L2572
	ldrb	w1, [x6, 3]
	lsl	w0, w26, w7
	orr	w0, w0, w1
	strb	w0, [x6, 3]
	ldrh	w0, [x13, 148]
	add	w0, w0, 1
	strh	w0, [x13, 148]
.L2573:
	add	w7, w7, 1
.L2576:
	cmp	w7, w15
	bne	.L2574
	add	w8, w8, 1
	sub	w12, w12, w11
	and	w8, w8, 65535
	b	.L2571
.L2572:
	add	w10, w10, 1
	and	w10, w10, 65535
	b	.L2573
.L2575:
	cbnz	w10, .L2577
	ldrb	w0, [x6, 2]
	orr	w0, w0, -32
	strb	w0, [x6, 2]
.L2577:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L2569
.L2589:
	add	x13, x15, x20, uxth 2
	mov	w6, 0
	mov	w12, 0
	mov	w5, 0
	ldrb	w0, [x13, 2]
	orr	w0, w0, -32
	strb	w0, [x13, 2]
.L2584:
	cmp	w5, w16
	bcc	.L2591
	add	w20, w20, 1
	add	w1, w1, w11
	and	w20, w20, 65535
	and	w1, w1, 65535
	b	.L2583
.L2587:
	ldrb	w14, [x13, 3]
	add	w17, w12, w7
	asr	w14, w14, w17
	tbnz	x14, 0, .L2585
	cmp	w10, 1
	bls	.L2590
	and	w0, w0, 1
	add	w0, w1, w0
	and	w0, w0, 65535
.L2586:
	add	x14, x2, x3, sxtw 1
	add	w3, w3, 1
	and	w3, w3, 65535
	add	w0, w0, w6
	strh	w0, [x14, 160]
.L2585:
	add	x7, x7, 1
.L2588:
	and	w0, w7, 65535
	cmp	w0, w11
	bcc	.L2587
	add	w5, w5, 1
	add	w6, w4, w6
	and	w5, w5, 65535
	add	w12, w12, w10
	and	w6, w6, 65535
	b	.L2584
.L2590:
	mov	w0, w1
	b	.L2586
.L2591:
	mov	x7, 0
	b	.L2588
	.size	ftl_low_format, .-ftl_low_format
	.section	.text.ftl_re_low_format,"ax",@progbits
	.align	2
	.global	ftl_re_low_format
	.type	ftl_re_low_format, %function
ftl_re_low_format:
	stp	x29, x30, [sp, -16]!
	mov	w1, 1
	adrp	x0, .LC154
	add	x0, x0, :lo12:.LC154
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
.L2602:
	cmp	w1, w7
	bcc	.L2606
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
.L2606:
	ldrb	w6, [x2, 2]
	and	w8, w6, 31
	strb	w8, [x2, 2]
	ands	w6, w6, 24
	bne	.L2603
	add	w5, w5, 1
	and	w5, w5, 65535
.L2604:
	add	w1, w1, 1
	add	x2, x2, 4
	and	w1, w1, 65535
	b	.L2602
.L2603:
	cmp	w6, 16
	bne	.L2605
	add	w4, w4, 1
	and	w4, w4, 65535
	b	.L2604
.L2605:
	add	w3, w3, 1
	and	w3, w3, 65535
	b	.L2604
	.size	ftl_re_low_format, .-ftl_re_low_format
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
	bne	.L2611
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
	beq	.L2612
	ldrh	w0, [x19]
	add	x20, x20, x22, uxth 2
	bl	ftl_vpn_decrement
	adrp	x0, .LANCHOR182
	mov	w1, 15555
	add	x6, x0, :lo12:.LANCHOR182
	movk	w1, 0xf55f, lsl 16
	str	w1, [x0, #:lo12:.LANCHOR182]
	adrp	x0, .LANCHOR87
	ldrh	w1, [x0, #:lo12:.LANCHOR87]
	adrp	x0, .LANCHOR80
	ldrb	w0, [x0, #:lo12:.LANCHOR80]
	mul	w1, w1, w0
	mov	x0, x20
	lsl	w1, w1, 2
	bl	js_hash
	stp	w0, wzr, [x6, 4]
	adrp	x0, .LANCHOR126
	mov	x2, x6
	mov	x1, x20
	ldrb	w3, [x0, #:lo12:.LANCHOR126]
	mov	w0, w21
	str	wzr, [x6, 12]
	bl	ftl_prog_ppa_page
.L2612:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L2611:
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
	tbz	x0, 12, .L2618
	ldrh	w1, [x19, 2]
	adrp	x0, .LC155
	add	x0, x0, :lo12:.LC155
	bl	printf
.L2618:
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2619
	ldrb	w1, [x19, 5]
	adrp	x0, .LC156
	add	x0, x0, :lo12:.LC156
	bl	printf
.L2619:
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2620
	ldrh	w1, [x19]
	adrp	x0, .LC157
	add	x0, x0, :lo12:.LC157
	bl	printf
.L2620:
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2621
	ldrh	w2, [x19, 18]
	adrp	x0, .LC158
	ldrh	w1, [x19, 16]
	add	x0, x0, :lo12:.LC158
	bl	printf
.L2621:
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2622
	ldrb	w1, [x19, 9]
	adrp	x0, .LC159
	add	x0, x0, :lo12:.LC159
	bl	printf
.L2622:
	ldrh	w0, [x19, 10]
	strh	w0, [x19, 14]
	adrp	x0, .LANCHOR6
	ldrh	w1, [x19]
	ldrh	w0, [x0, #:lo12:.LANCHOR6]
	cmp	w1, w0
	bcs	.L2617
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
	adrp	x0, .LANCHOR126
	str	wzr, [x29, 160]
	add	x0, x0, :lo12:.LANCHOR126
	str	x0, [x29, 128]
.L2624:
	ldrh	w0, [x25, #:lo12:.LANCHOR87]
	cmp	w0, w24
	bhi	.L2637
.L2627:
	ldrh	w0, [x19, 10]
	ldrh	w1, [x19, 6]
	ldrh	w2, [x25, #:lo12:.LANCHOR87]
	add	w1, w1, w0
	ldrb	w0, [x19, 9]
	strh	w24, [x19, 2]
	strb	w22, [x19, 5]
	mul	w0, w0, w2
	cmp	w1, w0
	beq	.L2638
	adrp	x1, .LANCHOR195
	adrp	x0, .LC0
	mov	w2, 1579
	add	x1, x1, :lo12:.LANCHOR195
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2638:
	adrp	x2, .LANCHOR111
	ldrh	w3, [x19, 10]
	mov	w0, 0
	mov	w1, 0
	ldr	x4, [x2, #:lo12:.LANCHOR111]
	str	x2, [x29, 136]
.L2639:
	cmp	w1, w3
	bcc	.L2641
	ldrb	w22, [x19, 9]
	adrp	x24, .LANCHOR9
	ldrh	w1, [x25, #:lo12:.LANCHOR87]
	madd	w22, w22, w1, w0
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	sub	w22, w22, w3
	and	w22, w22, 65535
	tbz	x0, 12, .L2642
	ldrh	w1, [x19]
	ldr	x2, [x24, #:lo12:.LANCHOR9]
	ubfiz	x0, x1, 1, 16
	ldrh	w3, [x2, x0]
	adrp	x0, .LC160
	mov	w2, w22
	add	x0, x0, :lo12:.LC160
	bl	printf
.L2642:
	ldr	x0, [x24, #:lo12:.LANCHOR9]
	ldrh	w1, [x19]
	strh	w22, [x0, x1, lsl 1]
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	tbz	x0, 14, .L2643
	ldp	w1, w2, [x29, 176]
	adrp	x0, .LC161
	ldp	w3, w4, [x29, 184]
	add	x0, x0, :lo12:.LC161
	bl	printf
.L2643:
	adrp	x24, .LANCHOR126
	ldr	x0, [x20, 8]
	mov	w1, 0
	mov	x28, 0
	ldrb	w2, [x24, #:lo12:.LANCHOR126]
	lsl	w2, w2, 9
	bl	ftl_memset
	adrp	x0, .LC163
	add	x0, x0, :lo12:.LC163
	str	x0, [x29, 120]
	adrp	x0, .LANCHOR80
	add	x0, x0, :lo12:.LANCHOR80
	str	x0, [x29, 112]
.L2644:
	adrp	x0, .LANCHOR80
	ldr	w2, [x29, 168]
	add	x1, x0, :lo12:.LANCHOR80
	str	w28, [x29, 152]
	ldrb	w0, [x0, #:lo12:.LANCHOR80]
	mul	w0, w0, w2
	cmp	w28, w0
	bcc	.L2656
	adrp	x0, .LC164
	add	x0, x0, :lo12:.LC164
	stp	x0, x1, [x29, 152]
	adrp	x0, .LC163
	add	x28, x0, :lo12:.LC163
	mov	x22, 0
.L2657:
	ldr	x0, [x29, 160]
	ldr	w1, [x29, 168]
	ldrb	w0, [x0]
	mul	w0, w0, w1
	cmp	w0, w22
	bhi	.L2663
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
	beq	.L2664
	adrp	x1, .LANCHOR195
	adrp	x0, .LC0
	mov	w2, 1670
	add	x1, x1, :lo12:.LANCHOR195
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2664:
	ldrh	w0, [x19, 6]
	cmp	w0, 1
	bne	.L2617
	mov	x0, x19
	bl	ftl_write_last_log_page
.L2617:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 368
	ret
.L2637:
	ldrb	w22, [x19, 5]
	adrp	x0, .LANCHOR105
	add	x0, x0, :lo12:.LANCHOR105
	str	x0, [x29, 136]
.L2625:
	ldrb	w0, [x19, 9]
	cmp	w0, w22
	bhi	.L2636
	add	w24, w24, 1
	strb	wzr, [x19, 5]
	and	w24, w24, 65535
	b	.L2624
.L2636:
	add	x0, x19, x22, sxtw 1
	mov	w1, 65535
	ldrh	w0, [x0, 16]
	cmp	w0, w1
	beq	.L2626
	ldr	x1, [x29, 136]
	ldr	x2, [x20, 24]
	ldrh	w1, [x1]
	madd	w0, w1, w0, w24
	ldr	x1, [x20, 8]
	str	w0, [x29, 152]
	adrp	x0, .LANCHOR126
	ldrb	w3, [x0, #:lo12:.LANCHOR126]
	ldr	w0, [x29, 152]
	bl	ftl_read_ppa_page
	mov	w28, w0
	cmp	w0, 512
	beq	.L2627
	cmn	w0, #1
	beq	.L2628
	ldr	x0, [x20, 24]
	ldr	w1, [x0]
	cmn	w1, #1
	bne	.L2628
	ldr	w0, [x0, 4]
	cmn	w0, #1
	bne	.L2628
	ldr	x0, [x20, 8]
	ldr	w0, [x0]
	cmn	w0, #1
	beq	.L2627
.L2628:
	adrp	x0, .LANCHOR188
	mov	w1, 1
	strb	w1, [x0, #:lo12:.LANCHOR188]
	ldrb	w0, [x19, 9]
	ldrh	w1, [x19, 10]
	madd	w0, w0, w24, w22
	cmp	w1, w0
	beq	.L2629
	adrp	x1, .LANCHOR195
	adrp	x0, .LC0
	mov	w2, 1498
	add	x1, x1, :lo12:.LANCHOR195
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2629:
	ldrh	w0, [x19, 10]
	ldrh	w1, [x19, 6]
	ldrb	w2, [x19, 9]
	add	w1, w1, w0
	ldrh	w0, [x25, #:lo12:.LANCHOR87]
	mul	w0, w0, w2
	cmp	w1, w0
	beq	.L2630
	adrp	x1, .LANCHOR195
	adrp	x0, .LC0
	mov	w2, 1499
	add	x1, x1, :lo12:.LANCHOR195
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2630:
	cmn	w28, #1
	beq	.L2632
	ldr	x0, [x20, 24]
	ldr	w0, [x0, 4]
	cmn	w0, #1
	beq	.L2632
	bl	lpa_hash_get_ppa
	ldr	x1, [x29, 144]
	cbz	x1, .L2634
	ldr	x3, [x20, 24]
	ldr	w1, [x3, 8]
	cmp	w0, w1
	beq	.L2634
	cmn	w0, #1
	beq	.L2634
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
	bne	.L2634
	ldr	x1, [x29, 128]
	adrp	x8, .LANCHOR184
	ldr	w10, [x3]
	add	x2, x8, :lo12:.LANCHOR184
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
	ldr	w0, [x8, #:lo12:.LANCHOR184]
	cmp	w10, w0
	bhi	.L2634
	ldr	x0, [x20, 24]
	ldr	w3, [x0, 8]
	cmn	w3, #1
	beq	.L2632
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
.L2632:
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
.L2626:
	add	w22, w22, 1
	and	w22, w22, 65535
	b	.L2625
.L2641:
	ldrh	w2, [x19, 12]
	add	w2, w2, w1
	ldr	w2, [x4, x2, lsl 2]
	cmn	w2, #1
	beq	.L2640
	add	w22, w0, 1
	and	w0, w22, 65535
.L2640:
	add	w1, w1, 1
	b	.L2639
.L2656:
	ldr	w0, [x23, x28, lsl 2]
	cmn	w0, #1
	bne	.L2645
.L2649:
	adrp	x1, .LANCHOR104
	ldr	x0, [x20, 24]
	mov	w22, -1
	ldr	x1, [x1, #:lo12:.LANCHOR104]
	ldr	w1, [x1, 8]
	stp	w1, w22, [x0]
	stp	w22, wzr, [x0, 8]
	ldr	x0, [x20, 8]
	str	wzr, [x0]
.L2646:
	ldr	w0, [x29, 160]
	cbz	w0, .L2651
	ldrh	w0, [x19, 6]
	cmp	w0, 1
	bls	.L2651
	add	x0, x21, :lo12:.LANCHOR14
	str	x0, [x29, 144]
	add	x0, x24, :lo12:.LANCHOR126
	str	x0, [x29, 128]
.L2712:
	mov	x0, x19
	bl	ftl_get_new_free_page
	mov	w5, w0
	ldr	x0, [x29, 144]
	ldr	w0, [x0]
	tbz	x0, 14, .L2653
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
.L2653:
	ldr	x0, [x29, 112]
	ldr	w2, [x29, 168]
	ldrh	w1, [x19, 6]
	ldrb	w0, [x0]
	mul	w0, w0, w2
	ldr	w2, [x29, 152]
	add	w0, w0, 1
	sub	w0, w0, w2
	cmp	w1, w0
	bls	.L2651
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
	beq	.L2654
	ldrh	w0, [x19, 10]
	ldrh	w1, [x19, 12]
	str	w5, [x26, x28, lsl 2]
	add	w0, w0, w1
	sub	w0, w0, #1
	str	w0, [x27, x28, lsl 2]
.L2651:
	add	x28, x28, 1
	b	.L2644
.L2645:
	ldrb	w3, [x24, #:lo12:.LANCHOR126]
	ldr	x1, [x20, 8]
	ldr	x2, [x20, 24]
	bl	ftl_read_ppa_page
	mov	w22, w0
	ldr	x0, [x20, 24]
	ldr	w0, [x0, 4]
	bl	lpa_hash_get_ppa
	mov	w5, w0
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	tbz	x0, 14, .L2647
	ldr	x0, [x20, 24]
	mov	w1, w5
	ldr	w2, [x23, x28, lsl 2]
	str	w5, [x29, 144]
	ldr	w3, [x0, 4]
	adrp	x0, .LC162
	add	x0, x0, :lo12:.LC162
	bl	printf
	ldr	w5, [x29, 144]
.L2647:
	ldr	w0, [x23, x28, lsl 2]
	mov	w1, 1
	cmp	w5, w0
	ldr	x0, [x20, 24]
	csinv	w22, w22, wzr, eq
	cmn	w22, #1
	stp	w5, w1, [x0, 8]
	bne	.L2646
	b	.L2649
.L2654:
	ldrh	w0, [x19, 6]
	cmp	w0, 1
	bls	.L2651
	cmn	w22, #1
	bne	.L2712
	b	.L2651
.L2663:
	ldr	w0, [x26, x22, lsl 2]
	cmn	w0, #1
	beq	.L2659
	ldrb	w3, [x24, #:lo12:.LANCHOR126]
	ldr	w0, [x23, x22, lsl 2]
	ldr	x1, [x20, 8]
	ldr	x2, [x20, 24]
	bl	ftl_read_ppa_page
	cmp	w0, 256
	ccmn	w0, #1, 4, ne
	bne	.L2659
	ldrb	w3, [x24, #:lo12:.LANCHOR126]
	ldr	w0, [x26, x22, lsl 2]
	ldr	x1, [x20, 8]
	ldr	x2, [x20, 24]
	bl	ftl_read_ppa_page
	mov	w5, w0
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	tbz	x0, 14, .L2661
	ldr	x0, [x20, 24]
	mov	w1, w5
	ldr	w3, [x23, x22, lsl 2]
	str	w5, [x29, 144]
	ldr	w2, [x0, 8]
	mov	x0, x28
	bl	printf
	ldr	w5, [x29, 144]
.L2661:
	cmn	w5, #1
	beq	.L2659
	ldr	x0, [x20, 24]
	ldr	w2, [x23, x22, lsl 2]
	ldr	w1, [x0, 8]
	cmp	w2, w1
	bne	.L2659
	ldr	w1, [x21, #:lo12:.LANCHOR14]
	tbz	x1, 14, .L2662
	ldr	w1, [x0, 4]
	ldr	w3, [x27, x22, lsl 2]
	ldr	x0, [x29, 152]
	bl	printf
.L2662:
	ldr	x0, [x20, 24]
	lsl	x1, x22, 2
	ldrh	w2, [x27, x1]
	ldr	w1, [x0, 8]
	ldr	w0, [x0, 4]
	bl	lpa_hash_update_ppa
.L2659:
	add	x22, x22, 1
	b	.L2657
.L2634:
	ldr	x3, [x20, 24]
	adrp	x0, .LANCHOR123
	ldr	w0, [x0, #:lo12:.LANCHOR123]
	ldr	w1, [x3, 4]
	cmp	w1, w0
	bcs	.L2632
	ldrb	w0, [x19, 9]
	ldrh	w1, [x25, #:lo12:.LANCHOR87]
	ldrh	w2, [x19, 10]
	mul	w0, w0, w1
	sub	w0, w0, #1
	cmp	w2, w0
	bge	.L2632
	adrp	x0, .LANCHOR104
	ldr	w1, [x3]
	ldr	x0, [x0, #:lo12:.LANCHOR104]
	ldr	w4, [x0, 8]
	cmp	w1, w4
	bls	.L2635
	str	w1, [x0, 8]
.L2635:
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
	b	.L2632
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
	adrp	x24, .LANCHOR104
	mov	x23, x1
	add	x21, x21, :lo12:.LANCHOR87
	mov	x20, x24
	add	x22, x22, :lo12:.LANCHOR105
	stp	x25, x26, [sp, 64]
	str	x27, [sp, 80]
	mov	w25, 65535
.L2739:
	ldr	x0, [x24, #:lo12:.LANCHOR104]
	ldr	w1, [x0, 48]
	ldrh	w2, [x0, 696]
	add	w1, w1, 1
	str	w1, [x0, 48]
	ldrh	w1, [x21]
	cmp	w2, w1
	bcs	.L2740
	ldrh	w0, [x0, 692]
	cmp	w0, w25
	bne	.L2741
.L2740:
	bl	pm_alloc_new_blk
	mov	w0, 0
	bl	ftl_info_flush
.L2741:
	ldr	x0, [x20, #:lo12:.LANCHOR104]
	ldrh	w0, [x0, 692]
	cmp	w0, w25
	bne	.L2742
	adrp	x1, .LANCHOR196
	adrp	x0, .LC0
	mov	w2, 267
	add	x1, x1, :lo12:.LANCHOR196
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2742:
	ldr	x0, [x20, #:lo12:.LANCHOR104]
	adrp	x27, .LANCHOR197
	ldrh	w1, [x22]
	mov	w2, 64
	ldrh	w26, [x0, 692]
	ldrh	w0, [x0, 696]
	madd	w26, w26, w1, w0
	ldr	x0, [x27, #:lo12:.LANCHOR197]
	mov	w1, 0
	bl	ftl_memset
	ldr	x6, [x27, #:lo12:.LANCHOR197]
	ldr	x7, [x20, #:lo12:.LANCHOR104]
	str	w19, [x6]
	ldr	w0, [x7, 48]
	str	w0, [x6, 4]
	adrp	x0, .LANCHOR126
	ldrb	w8, [x0, #:lo12:.LANCHOR126]
	mov	x0, x23
	lsl	w1, w8, 9
	bl	js_hash
	str	w0, [x6, 8]
	ldrb	w0, [x7, 694]
	mov	x2, x23
	mov	w1, w26
	mov	w4, w8
	mov	x3, x6
	bl	ftl_prog_page
	ldr	x2, [x20, #:lo12:.LANCHOR104]
	ldrh	w1, [x2, 696]
	add	w1, w1, 1
	and	w1, w1, 65535
	strh	w1, [x2, 696]
	cmp	w1, 1
	adrp	x1, .LANCHOR198
	beq	.L2743
	ldrb	w3, [x1, #:lo12:.LANCHOR198]
	cbz	w3, .L2744
.L2743:
	strb	wzr, [x1, #:lo12:.LANCHOR198]
	b	.L2739
.L2744:
	cmn	w0, #1
	bne	.L2746
	mov	w1, w26
	adrp	x0, .LC165
	add	x0, x0, :lo12:.LC165
	bl	printf
	b	.L2739
.L2746:
	ldrh	w0, [x2, 698]
	cmp	w19, w0
	bcs	.L2747
	add	x19, x2, x19, uxtw 2
	str	w26, [x19, 704]
.L2747:
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
	bls	.L2752
	adrp	x25, .LANCHOR77
	str	x25, [x29, 136]
	ldrb	w0, [x25, #:lo12:.LANCHOR77]
	cbnz	w0, .L2754
	adrp	x0, .LANCHOR74
	ldrb	w0, [x0, #:lo12:.LANCHOR74]
	cbz	w0, .L2752
.L2754:
	adrp	x0, .LANCHOR7
	ubfiz	x14, x20, 2, 16
	mov	x15, x0
	ldr	x1, [x0, #:lo12:.LANCHOR7]
	add	x1, x1, x14
	ldrb	w1, [x1, 2]
	and	w1, w1, 224
	cmp	w1, 160
	bne	.L2774
	adrp	x0, .LANCHOR73
	ldrb	w10, [x0, #:lo12:.LANCHOR73]
.L2755:
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
	adrp	x0, .LC166
	ubfx	x5, x5, 11, 8
	add	x0, x0, :lo12:.LC166
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
.L2756:
	ldrh	w0, [x14]
	cmp	w0, w25
	bls	.L2762
	lsl	w11, w25, 1
	adrp	x26, .LC167
	sub	w11, w11, #1
	mov	w27, 0
	add	x26, x26, :lo12:.LC167
	b	.L2766
.L2774:
	mov	w10, 1
	b	.L2755
.L2764:
	ldrh	w13, [x22, x28]
	mov	w0, 65535
	cmp	w13, w0
	bne	.L2757
.L2763:
	add	w24, w24, 1
	and	w24, w24, 65535
.L2758:
	cmp	w10, w24
	bcs	.L2764
	add	w27, w27, 1
	and	w27, w27, 65535
.L2766:
	ldrb	w0, [x29, 153]
	cmp	w0, w27
	bls	.L2765
	sxtw	x28, w27
	mov	w24, 1
	add	x28, x28, 8
	lsl	x28, x28, 1
	b	.L2758
.L2757:
	ldrh	w21, [x12]
	cmp	w10, 3
	mul	w21, w21, w13
	bne	.L2759
	add	w21, w25, w21
	orr	w21, w21, w24, lsl 24
.L2760:
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
	bne	.L2763
.L2762:
	mov	w4, w24
	mov	w3, w27
	mov	w2, w25
	mov	w1, w20
	adrp	x24, .LANCHOR126
	adrp	x0, .LC168
	add	x0, x0, :lo12:.LC168
	bl	printf
	ldr	x0, [x19, 8]
	mov	w1, 0
	ldrb	w2, [x24, #:lo12:.LANCHOR126]
	adrp	x26, .LC169
	adrp	x27, .LANCHOR73
	add	x26, x26, :lo12:.LC169
	add	x27, x27, :lo12:.LANCHOR73
	lsl	w2, w2, 9
	bl	ftl_memset
	ldr	x0, [x19, 24]
	mov	w1, 0
	ldrb	w2, [x24, #:lo12:.LANCHOR126]
	lsl	w2, w2, 1
	bl	ftl_memset
.L2767:
	ldrh	w0, [x23, #:lo12:.LANCHOR87]
	cmp	w0, w25
	bls	.L2772
	ldr	x0, [x29, 136]
	lsl	w28, w25, 1
	mov	w21, 0
	add	x0, x0, :lo12:.LANCHOR77
	str	x0, [x29, 128]
	b	.L2773
.L2759:
	cmp	w10, 2
	bne	.L2761
	adrp	x0, .LANCHOR73
	add	w21, w21, w11
	add	w21, w21, w24
	ldrb	w3, [x0, #:lo12:.LANCHOR73]
	orr	w21, w21, w3, lsl 24
	b	.L2760
.L2761:
	add	w21, w25, w21
	b	.L2760
.L2765:
	add	w8, w25, 1
	and	w25, w8, 65535
	b	.L2756
.L2771:
	mov	w2, w21
	mov	w1, w25
	mov	x0, x26
	bl	printf
	ldr	x0, [x29, 128]
	adrp	x2, .LANCHOR105
	ldrb	w1, [x0]
	sxtw	x0, w21
	cbz	w1, .L2768
	add	x0, x0, 8
	ldrh	w1, [x2, #:lo12:.LANCHOR105]
	ldrh	w0, [x22, x0, lsl 1]
	mul	w0, w0, w1
	orr	w0, w0, w25
	str	w0, [x19, 40]
	mov	x0, x19
	bl	sblk_3d_tlc_dump_prog
.L2769:
	add	w21, w21, 1
	and	w21, w21, 65535
.L2773:
	ldrb	w0, [x29, 153]
	cmp	w0, w21
	bhi	.L2771
	add	w8, w25, 1
	and	w25, w8, 65535
	b	.L2767
.L2768:
	ldrb	w1, [x27]
	add	x0, x0, 8
	cmp	w1, 2
	bne	.L2770
	ldrh	w0, [x22, x0, lsl 1]
	ldrh	w1, [x2, #:lo12:.LANCHOR105]
	mul	w0, w0, w1
	orr	w0, w0, w28
	orr	w0, w0, 33554432
	str	w0, [x19, 40]
	mov	x0, x19
	bl	sblk_mlc_dump_prog
	b	.L2769
.L2770:
	ldrh	w1, [x22, x0, lsl 1]
	mov	w6, 1
	ldrh	w0, [x2, #:lo12:.LANCHOR105]
	mov	w5, 0
	ldrb	w4, [x24, #:lo12:.LANCHOR126]
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
	b	.L2769
.L2772:
	mov	x0, x19
	bl	zbuf_free
	adrp	x0, .LC170
	mov	w1, w20
	add	x0, x0, :lo12:.LC170
	bl	printf
.L2752:
	ldp	x19, x20, [sp, 64]
	ldp	x21, x22, [sp, 80]
	ldp	x23, x24, [sp, 96]
	ldp	x25, x26, [sp, 112]
	ldp	x27, x28, [sp, 128]
	ldp	x29, x30, [sp, 48]
	add	sp, sp, 224
	ret
	.size	ftl_dump_write_open_sblk, .-ftl_dump_write_open_sblk
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
	tbz	x0, 12, .L2783
	adrp	x2, .LANCHOR199
	adrp	x0, .LC91
	add	x2, x2, :lo12:.LANCHOR199
	mov	w1, 325
	add	x0, x0, :lo12:.LC91
	bl	printf
.L2783:
	adrp	x23, .LANCHOR200
	adrp	x20, .LANCHOR27
	mov	w2, 64
	mov	w1, 0
	ldr	x0, [x23, #:lo12:.LANCHOR200]
	adrp	x21, .LANCHOR201
	adrp	x22, .LANCHOR2
	adrp	x24, .LC172
	adrp	x25, .LANCHOR144
	add	x22, x22, :lo12:.LANCHOR2
	add	x24, x24, :lo12:.LC172
	add	x25, x25, :lo12:.LANCHOR144
	bl	ftl_memset
	add	x27, x21, :lo12:.LANCHOR201
	ldr	x1, [x20, #:lo12:.LANCHOR27]
	mov	w3, 16
	mov	w2, 4
	adrp	x0, .LC171
	add	x0, x0, :lo12:.LC171
	mov	w26, 0
	bl	rknand_print_hex
	ldr	x6, [x20, #:lo12:.LANCHOR27]
	add	x0, x6, 16
	ldr	w1, [x6, 8]
	bl	js_hash
	str	w0, [x6, 12]
.L2784:
	add	x28, x21, :lo12:.LANCHOR201
	ldrb	w4, [x21, #:lo12:.LANCHOR201]
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
	blt	.L2785
	ldr	x6, [x20, #:lo12:.LANCHOR27]
	ldrb	w7, [x28, 1]
	strh	wzr, [x28, 2]
	ldr	w0, [x6, 4]
	ldrh	w1, [x6, 16]
	add	w0, w0, 1
	str	w0, [x6, 4]
	ldrb	w0, [x21, #:lo12:.LANCHOR201]
	add	w1, w1, 1
	strb	w0, [x28, 1]
	mov	x0, x6
	strb	w7, [x21, #:lo12:.LANCHOR201]
	strh	w1, [x0, 16]!
	ldr	w1, [x6, 8]
	bl	js_hash
	ldrh	w19, [x22]
	str	w0, [x6, 12]
	mul	w19, w19, w7
.L2794:
	mov	w1, w19
	mov	w0, 0
	bl	flash_erase_block
	b	.L2786
.L2789:
	mov	w26, 1
	b	.L2784
.L2785:
	madd	w19, w19, w4, w3
	cbz	w1, .L2794
.L2786:
	ldr	x2, [x20, #:lo12:.LANCHOR27]
	mov	w1, w19
	ldr	x3, [x23, #:lo12:.LANCHOR200]
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
	bne	.L2787
	mov	w1, w19
	adrp	x0, .LC173
	add	x0, x0, :lo12:.LC173
	bl	printf
	b	.L2784
.L2787:
	cbz	w26, .L2789
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
	tbz	x0, 12, .L2796
	ldr	x4, [x20, #:lo12:.LANCHOR27]
	adrp	x2, .LANCHOR202
	adrp	x0, .LC174
	mov	w3, 2048
	add	x2, x2, :lo12:.LANCHOR202
	mov	w1, 50
	add	x0, x0, :lo12:.LC174
	bl	printf
.L2796:
	adrp	x21, .LANCHOR200
	adrp	x24, .LANCHOR2
	mov	w22, 21321
	add	x26, x24, :lo12:.LANCHOR2
	mov	x23, x21
	mov	w19, 4
	movk	w22, 0x5359, lsl 16
.L2799:
	ldrh	w1, [x26]
	mov	w4, 4
	ldr	x3, [x21, #:lo12:.LANCHOR200]
	mov	w0, 0
	ldr	x2, [x20, #:lo12:.LANCHOR27]
	add	x27, x21, :lo12:.LANCHOR200
	add	x25, x20, :lo12:.LANCHOR27
	mul	w1, w1, w19
	bl	flash_read_page_en
	cmn	w0, #1
	beq	.L2797
	ldr	x2, [x20, #:lo12:.LANCHOR27]
	ldr	w0, [x2]
	cmp	w0, w22
	beq	.L2798
.L2797:
	add	w19, w19, 1
	cmp	w19, 16
	bne	.L2799
.L2824:
	mov	w0, -1
.L2795:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L2807:
	ldr	x0, [x25]
	ldr	w1, [x0]
	cmp	w1, w22
	bne	.L2808
	ldr	w21, [x0, 4]
.L2801:
	add	x22, x19, :lo12:.LANCHOR201
	ldrh	w0, [x24, #:lo12:.LANCHOR2]
	ldr	x3, [x23, #:lo12:.LANCHOR200]
	mov	w4, 4
	ldr	x2, [x20, #:lo12:.LANCHOR27]
	ldrb	w1, [x22, 1]
	mul	w1, w1, w0
	mov	w0, 0
	bl	flash_read_page_en
	cmn	w0, #1
	beq	.L2802
	ldr	x0, [x20, #:lo12:.LANCHOR27]
	mov	w1, 21321
	movk	w1, 0x5359, lsl 16
	ldr	w2, [x0]
	cmp	w2, w1
	bne	.L2802
	ldr	w1, [x0, 4]
	cmp	w21, w1
	bcs	.L2802
	ldrb	w1, [x0, 37]
	ldrb	w0, [x0, 36]
	strb	w1, [x19, #:lo12:.LANCHOR201]
	strb	w0, [x22, 1]
.L2802:
	ldrb	w1, [x19, #:lo12:.LANCHOR201]
	add	x21, x19, :lo12:.LANCHOR201
	ldr	x3, [x23, #:lo12:.LANCHOR200]
	mov	w4, 4
	ldr	x2, [x20, #:lo12:.LANCHOR27]
	mov	w0, 0
	bl	flash_get_last_written_page
	and	w25, w0, 65535
	add	w1, w25, 1
	ldrb	w22, [x19, #:lo12:.LANCHOR201]
	strh	w1, [x21, 2]
	mov	w21, 0
	ldrh	w1, [x24, #:lo12:.LANCHOR2]
	mov	w24, 21321
	movk	w24, 0x5359, lsl 16
	mul	w22, w22, w1
	add	w22, w22, w0, sxth
.L2803:
	sub	w0, w25, w21
	sxth	w19, w0
	tbz	w19, #31, .L2806
	cmn	w19, #1
	bne	.L2805
	ldr	x0, [x20, #:lo12:.LANCHOR27]
	ldr	w1, [x0]
	adrp	x0, .LC175
	add	x0, x0, :lo12:.LC175
	bl	printf
	b	.L2824
.L2806:
	ldr	x3, [x23, #:lo12:.LANCHOR200]
	mov	w4, 4
	ldr	x2, [x20, #:lo12:.LANCHOR27]
	sub	w1, w22, w21
	mov	w0, 0
	bl	flash_read_page_en
	cmn	w0, #1
	beq	.L2804
	ldr	x0, [x20, #:lo12:.LANCHOR27]
	ldr	w0, [x0]
	cmp	w0, w24
	beq	.L2805
.L2804:
	add	w21, w21, 1
	b	.L2803
.L2805:
	cmp	w21, 1
	bls	.L2809
	bl	flash_info_flush
.L2809:
	mov	w0, 0
	b	.L2795
.L2798:
	adrp	x19, .LANCHOR201
	add	x1, x19, :lo12:.LANCHOR201
	ldrb	w3, [x2, 37]
	mov	w4, 4
	ldrb	w0, [x2, 36]
	strb	w3, [x1, 1]
	ldrh	w1, [x26]
	ldr	x3, [x27]
	strb	w0, [x19, #:lo12:.LANCHOR201]
	mul	w1, w1, w0
	mov	w0, 0
	bl	flash_read_page_en
	cmn	w0, #1
	bne	.L2807
.L2808:
	mov	w21, 0
	b	.L2801
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
	tbz	x0, 12, .L2826
	adrp	x2, .LANCHOR203
	adrp	x0, .LC91
	add	x2, x2, :lo12:.LANCHOR203
	mov	w1, 2765
	add	x0, x0, :lo12:.LC91
	bl	printf
.L2826:
	adrp	x0, .LANCHOR165
	adrp	x24, .LANCHOR16
	adrp	x22, .LANCHOR44
	add	x25, x22, :lo12:.LANCHOR44
	str	wzr, [x0, #:lo12:.LANCHOR165]
	mov	x0, x19
	bl	nandc_init
	adrp	x19, .LANCHOR32
	add	x0, x19, :lo12:.LANCHOR32
	str	x0, [x24, #:lo12:.LANCHOR16]
	adrp	x0, .LANCHOR18
	adrp	x23, .LANCHOR31
	mov	x26, x25
	mov	w1, 1
	mov	w21, 0
	strb	w1, [x0, #:lo12:.LANCHOR18]
	mov	w27, 44
	mov	w0, 3
	mov	w2, 8
	strb	w0, [x23, #:lo12:.LANCHOR31]
	mov	w1, 0
	adrp	x0, .LANCHOR30
	add	x0, x0, :lo12:.LANCHOR30
	bl	ftl_memset
	mov	w2, 32
	mov	w1, 0
	adrp	x0, .LANCHOR145
	add	x0, x0, :lo12:.LANCHOR145
	bl	ftl_memset
.L2832:
	mov	x1, x25
	mov	w0, w21
	bl	flash_read_id
	cbnz	w21, .L2827
	ldrb	w0, [x26]
	sub	w0, w0, #1
	and	w0, w0, 255
	cmp	w0, 253
	bls	.L2828
.L2830:
	mov	w19, -2
.L2825:
	mov	w0, w19
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L2828:
	ldrb	w0, [x26, 1]
	cmp	w0, 255
	beq	.L2830
.L2827:
	ldrb	w0, [x25]
	cmp	w0, 181
	bne	.L2831
	strb	w27, [x25]
.L2831:
	add	w21, w21, 1
	add	x25, x25, 8
	and	w21, w21, 255
	cmp	w21, 4
	bne	.L2832
	adrp	x0, .LANCHOR204
	add	x8, x0, :lo12:.LANCHOR204
	add	x8, x8, 1
	mov	x7, x0
	add	x12, x22, :lo12:.LANCHOR44
	mov	x10, 0
.L2835:
	ldrb	w2, [x8, -1]
	mov	w11, w10
	lsl	x25, x10, 5
	mov	x1, x12
	mov	x0, x8
	bl	flash_mem_cmp8
	cbnz	w0, .L2833
	add	x0, x7, :lo12:.LANCHOR204
	ubfiz	x11, x11, 5, 32
	add	x25, x0, x25
	add	x0, x0, x11
	adrp	x1, .LANCHOR205
	add	x4, x1, :lo12:.LANCHOR205
	ldrb	w3, [x0, 22]
	mov	x0, 0
.L2834:
	lsl	x5, x0, 5
	mov	w2, w0
	ldrb	w5, [x5, x4]
	cmp	w5, w3
	beq	.L2836
	add	x0, x0, 1
	cmp	x0, 4
	bne	.L2834
	mov	w2, w0
.L2836:
	ubfiz	x0, x2, 5, 32
	add	x1, x1, :lo12:.LANCHOR205
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
	bhi	.L2837
	ldrb	w0, [x21, 20]
	cmp	w0, 60
	bls	.L2837
	mov	w0, 60
	strb	w0, [x21, 20]
.L2837:
	ldr	w0, [x20, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2865
	adrp	x2, .LANCHOR203
	adrp	x0, .LC91
	add	x2, x2, :lo12:.LANCHOR203
	mov	w1, 2787
	add	x0, x0, :lo12:.LC91
	bl	printf
.L2865:
	ldr	x0, [x24, #:lo12:.LANCHOR16]
	ldrh	w0, [x0, 10]
	cmp	w0, 1023
	bls	.L2838
	mov	w0, 2
	strb	w0, [x23, #:lo12:.LANCHOR31]
.L2838:
	mov	w0, 16384
	bl	ftl_malloc
	adrp	x1, .LANCHOR169
	adrp	x23, .LANCHOR27
	add	x21, x19, :lo12:.LANCHOR32
	str	x0, [x1, #:lo12:.LANCHOR169]
	mov	w0, 16384
	bl	ftl_malloc
	adrp	x1, .LANCHOR161
	str	x0, [x1, #:lo12:.LANCHOR161]
	mov	w0, 2048
	bl	ftl_malloc
	str	x0, [x23, #:lo12:.LANCHOR27]
	mov	w0, 64
	bl	ftl_malloc
	adrp	x1, .LANCHOR168
	str	x0, [x1, #:lo12:.LANCHOR168]
	mov	w0, 64
	bl	ftl_malloc
	adrp	x1, .LANCHOR163
	str	x0, [x1, #:lo12:.LANCHOR163]
	mov	w0, 64
	bl	ftl_malloc
	adrp	x1, .LANCHOR200
	str	x0, [x1, #:lo12:.LANCHOR200]
	adrp	x0, .LANCHOR206
	strb	wzr, [x0, #:lo12:.LANCHOR206]
	bl	flash_die_info_init
	ldrb	w0, [x21, 18]
	bl	flash_lsb_page_tbl_build
	ldrb	w0, [x21, 20]
	adrp	x21, .LANCHOR167
	bl	nandc_bch_sel
	str	xzr, [x21, #:lo12:.LANCHOR167]
	ldr	x2, [x24, #:lo12:.LANCHOR16]
	adrp	x24, .LANCHOR45
	ldrh	w0, [x2, 16]
	ubfx	x1, x0, 8, 3
	strb	w1, [x24, #:lo12:.LANCHOR45]
	adrp	x1, .LANCHOR179
	ubfx	x3, x0, 3, 1
	strb	w3, [x1, #:lo12:.LANCHOR179]
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
	adrp	x3, .LANCHOR118
	ldrb	w1, [x2, 31]
	ldrb	w2, [x2, 28]
	ubfx	x4, x1, 1, 1
	strb	w4, [x3, #:lo12:.LANCHOR118]
	adrp	x3, .LANCHOR207
	ubfx	x1, x1, 2, 1
	strb	w1, [x3, #:lo12:.LANCHOR207]
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
	bne	.L2839
	mov	w3, 70
	strb	w3, [x0, #:lo12:.LANCHOR17]
.L2839:
	adrp	x0, .LANCHOR19
	strb	w2, [x0, #:lo12:.LANCHOR19]
	add	x2, x19, :lo12:.LANCHOR32
	ldrb	w2, [x2, 7]
	cmp	w2, 9
	bne	.L2840
	strb	wzr, [x0, #:lo12:.LANCHOR19]
.L2840:
	add	x2, x19, :lo12:.LANCHOR32
	ldrb	w3, [x2, 31]
	tbz	x3, 0, .L2841
	ldrb	w2, [x2, 29]
	cbz	w2, .L2842
	mov	w2, 2
.L2894:
	strb	w2, [x0, #:lo12:.LANCHOR19]
.L2841:
	cmp	w1, 8
	bne	.L2843
	ldrb	w1, [x22, #:lo12:.LANCHOR44]
	mov	w2, 137
	cmp	w1, 44
	ccmp	w1, w2, 4, ne
	bne	.L2843
	add	x1, x19, :lo12:.LANCHOR32
	ldrb	w1, [x1, 28]
	cmp	w1, 3
	bne	.L2843
	strb	wzr, [x0, #:lo12:.LANCHOR19]
.L2843:
	add	x19, x19, :lo12:.LANCHOR32
	adrp	x25, .LANCHOR24
	ldrh	w1, [x19, 16]
	ldrb	w0, [x19, 19]
	strb	w0, [x25, #:lo12:.LANCHOR24]
	tbz	x1, 6, .L2845
	sub	w1, w0, #17
	and	w1, w1, 255
	cmp	w1, 2
	ccmp	w0, 21, 4, hi
	bne	.L2846
	adrp	x1, micron_read_retrial
	add	x1, x1, :lo12:micron_read_retrial
	str	x1, [x21, #:lo12:.LANCHOR167]
	cmp	w0, 21
	adrp	x0, .LANCHOR164
	beq	.L2847
	mov	w1, 15
.L2896:
	strb	w1, [x0, #:lo12:.LANCHOR164]
	b	.L2845
.L2833:
	add	x10, x10, 1
	add	x8, x8, 32
	cmp	x10, 46
	bne	.L2835
	b	.L2830
.L2842:
	mov	w2, 3
	b	.L2894
.L2847:
	mov	w1, 4
	b	.L2896
.L2846:
	sub	w1, w0, #65
	cmp	w0, 33
	and	w1, w1, 255
	ccmp	w1, 1, 0, ne
	bhi	.L2849
	adrp	x0, toshiba_read_retrial
	add	x0, x0, :lo12:toshiba_read_retrial
	str	x0, [x21, #:lo12:.LANCHOR167]
	adrp	x0, .LANCHOR26
	mov	w1, 4
	strb	w1, [x0, #:lo12:.LANCHOR26]
.L2898:
	mov	w1, 7
	adrp	x0, .LANCHOR164
	b	.L2896
.L2849:
	sub	w2, w0, #34
	sub	w1, w0, #67
	and	w2, w2, 255
	and	w1, w1, 255
	cmp	w2, 1
	ccmp	w1, 1, 0, hi
	bhi	.L2850
	adrp	x2, toshiba_read_retrial
	add	x2, x2, :lo12:toshiba_read_retrial
	str	x2, [x21, #:lo12:.LANCHOR167]
	cmp	w0, 35
	mov	w2, 68
	ccmp	w0, w2, 4, ne
	adrp	x0, .LANCHOR164
	beq	.L2851
	mov	w2, 7
.L2895:
	strb	w2, [x0, #:lo12:.LANCHOR164]
	cmp	w1, 1
	adrp	x0, .LANCHOR26
	bhi	.L2853
	mov	w1, 4
.L2897:
	strb	w1, [x0, #:lo12:.LANCHOR26]
.L2845:
	ldr	w0, [x20, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2854
	adrp	x2, .LANCHOR203
	adrp	x0, .LC91
	add	x2, x2, :lo12:.LANCHOR203
	mov	w1, 2863
	add	x0, x0, :lo12:.LC91
	bl	printf
.L2854:
	adrp	x22, .LANCHOR21
	ldrb	w0, [x24, #:lo12:.LANCHOR45]
	strb	wzr, [x22, #:lo12:.LANCHOR21]
	tbz	x0, 0, .L2855
	mov	w0, 4
	bl	nandc_set_if_mode
	mov	w0, 1
	bl	flash_set_interface_mode
	mov	w0, 1
.L2899:
	bl	nandc_set_if_mode
	bl	flash_info_blk_init
	mov	w19, w0
	cmn	w0, #1
	bne	.L2857
	ldr	w0, [x20, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2858
	adrp	x2, .LANCHOR203
	adrp	x0, .LC91
	add	x2, x2, :lo12:.LANCHOR203
	mov	w1, 2881
	add	x0, x0, :lo12:.LC91
	bl	printf
.L2858:
	ldr	x0, [x23, #:lo12:.LANCHOR27]
	mov	w1, 17
	strb	w1, [x0, 32]
	adrp	x0, .LANCHOR33
	strb	wzr, [x0, #:lo12:.LANCHOR33]
	mov	w0, 0
	bl	zftl_flash_exit_slc_mode
	b	.L2825
.L2851:
	mov	w2, 17
	b	.L2895
.L2853:
	mov	w1, 5
	b	.L2897
.L2850:
	sub	w0, w0, #36
	and	w0, w0, 255
	cmp	w0, 1
	bhi	.L2845
	adrp	x0, toshiba_3d_read_retrial
	add	x0, x0, :lo12:toshiba_3d_read_retrial
	str	x0, [x21, #:lo12:.LANCHOR167]
	b	.L2898
.L2855:
	mov	w0, 4
	b	.L2899
.L2857:
	ldrb	w0, [x25, #:lo12:.LANCHOR24]
	sub	w0, w0, #1
	and	w0, w0, 255
	cmp	w0, 7
	bhi	.L2859
	adrp	x0, hynix_read_retrial
	add	x0, x0, :lo12:hynix_read_retrial
	str	x0, [x21, #:lo12:.LANCHOR167]
.L2859:
	ldrb	w0, [x24, #:lo12:.LANCHOR45]
	tbz	x0, 2, .L2861
	ldr	x0, [x23, #:lo12:.LANCHOR27]
	ldrb	w0, [x0, 19]
	cbz	w0, .L2861
	adrp	x0, .LANCHOR201
	ldrb	w1, [x0, #:lo12:.LANCHOR201]
	adrp	x0, .LANCHOR2
	ldrh	w0, [x0, #:lo12:.LANCHOR2]
	mul	w1, w1, w0
	mov	w0, 0
	bl	flash_ddr_para_scan
	ldrb	w0, [x22, #:lo12:.LANCHOR21]
	cbnz	w0, .L2861
	ldr	x0, [x23, #:lo12:.LANCHOR27]
	strb	wzr, [x0, 19]
	bl	flash_info_flush
.L2861:
	ldr	w0, [x20, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2863
	adrp	x2, .LANCHOR203
	adrp	x0, .LC91
	add	x2, x2, :lo12:.LANCHOR203
	mov	w1, 2935
	add	x0, x0, :lo12:.LC91
	bl	printf
.L2863:
	bl	nand_flash_print_info
	mov	w19, 0
	b	.L2825
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
	adrp	x27, .LANCHOR126
	mov	x24, x0
	add	x25, x25, :lo12:.LANCHOR87
	add	x26, x26, :lo12:.LANCHOR105
	add	x27, x27, :lo12:.LANCHOR126
	mov	w19, 0
.L2901:
	ldrh	w0, [x25]
	cmp	w0, w19
	bhi	.L2903
	add	x1, x28, 704
	mov	w3, 32
	mov	w2, 4
	adrp	x0, .LC176
	add	x0, x0, :lo12:.LC176
	bl	rknand_print_hex
	mov	x0, x24
	bl	zbuf_free
	cbz	w20, .L2904
	adrp	x1, .LANCHOR208
	adrp	x0, .LC0
	mov	w2, 1432
	add	x1, x1, :lo12:.LANCHOR208
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2904:
	mov	w0, w20
	ldp	x19, x20, [sp, 64]
	ldp	x21, x22, [sp, 80]
	ldp	x23, x24, [sp, 96]
	ldp	x25, x26, [sp, 112]
	ldp	x27, x28, [sp, 128]
	ldp	x29, x30, [sp, 48]
	add	sp, sp, 144
	ret
.L2903:
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
	adrp	x0, .LC167
	add	x0, x0, :lo12:.LC167
	bl	printf
	cmp	w22, 512
	ccmn	w22, #1, 4, ne
	csinc	w20, w20, wzr, ne
	b	.L2901
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
	adrp	x0, .LC177
	stp	x19, x20, [sp, 16]
	add	x0, x0, :lo12:.LC177
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR104
	adrp	x19, .LANCHOR10
	adrp	x20, .LANCHOR87
	bl	printf
	adrp	x21, .LANCHOR6
	adrp	x0, .LANCHOR185
	add	x1, x0, :lo12:.LANCHOR185
	ldrh	w3, [x1, 2]
	ldrb	w2, [x1, 1]
	ldrb	w1, [x0, #:lo12:.LANCHOR185]
	adrp	x0, .LC178
	add	x0, x0, :lo12:.LC178
	bl	printf
	ldr	x0, [x22, #:lo12:.LANCHOR104]
	ldrh	w2, [x0, 140]
	ldrh	w1, [x0, 130]
	adrp	x0, .LC179
	add	x0, x0, :lo12:.LC179
	bl	printf
	ldr	x1, [x19, #:lo12:.LANCHOR10]
	adrp	x0, .LC180
	add	x0, x0, :lo12:.LC180
	ldrh	w5, [x1, 26]
	ldrh	w4, [x1, 22]
	ldrb	w3, [x1, 21]
	ldrh	w2, [x1, 18]
	ldrh	w1, [x1, 16]
	bl	printf
	ldr	x1, [x19, #:lo12:.LANCHOR10]
	adrp	x0, .LC181
	add	x0, x0, :lo12:.LC181
	ldrh	w5, [x1, 58]
	ldrh	w4, [x1, 54]
	ldrb	w3, [x1, 53]
	ldrh	w2, [x1, 50]
	ldrh	w1, [x1, 48]
	bl	printf
	ldr	x1, [x19, #:lo12:.LANCHOR10]
	adrp	x19, .LANCHOR80
	adrp	x0, .LC182
	add	x0, x0, :lo12:.LC182
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
	adrp	x0, .LC183
	lsl	w3, w3, 1
	add	x0, x0, :lo12:.LC183
	bl	rknand_print_hex
	adrp	x0, .LANCHOR9
	ldrh	w3, [x21, #:lo12:.LANCHOR6]
	mov	w2, 2
	ldr	x1, [x0, #:lo12:.LANCHOR9]
	adrp	x0, .LC184
	add	x0, x0, :lo12:.LC184
	bl	rknand_print_hex
	ldr	x1, [x22, #:lo12:.LANCHOR104]
	mov	w2, 4
	adrp	x0, .LC176
	add	x0, x0, :lo12:.LC176
	add	x1, x1, 704
	ldrh	w3, [x1, -6]
	bl	rknand_print_hex
	adrp	x0, .LANCHOR7
	ldrh	w3, [x21, #:lo12:.LANCHOR6]
	mov	w2, 4
	ldr	x1, [x0, #:lo12:.LANCHOR7]
	adrp	x0, .LC185
	add	x0, x0, :lo12:.LC185
	bl	rknand_print_hex
	mov	w3, 256
	mov	w2, 2
	adrp	x1, .LANCHOR110
	adrp	x0, .LC186
	add	x1, x1, :lo12:.LANCHOR110
	add	x0, x0, :lo12:.LC186
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
	adrp	x0, .LC187
	add	x0, x0, :lo12:.LC187
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
	bne	.L2915
	mov	w3, w2
	mov	w2, w1
	mov	x1, x0
	stp	x29, x30, [sp, -16]!
	adrp	x0, .LC188
	add	x0, x0, :lo12:.LC188
	add	x29, sp, 0
	bl	printf
	bl	dump_ftl_info
	mov	w0, -1
	ldp	x29, x30, [sp], 16
	ret
.L2915:
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
	bls	.L2921
	adrp	x1, .LANCHOR209
	adrp	x0, .LC0
	mov	w2, 32
	add	x1, x1, :lo12:.LANCHOR209
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2921:
	adrp	x20, .LANCHOR104
	mov	x25, x20
	ldr	x0, [x20, #:lo12:.LANCHOR104]
	ldrh	w2, [x0, 698]
	cmp	w2, w19
	bcs	.L2922
	mov	w1, w19
	adrp	x0, .LC189
	add	x0, x0, :lo12:.LC189
	bl	printf
	adrp	x0, .LANCHOR210
	mov	w1, 255
	ldrh	w2, [x0, #:lo12:.LANCHOR210]
	mov	x0, 0
	ldr	x0, [x0, 8]
	bl	ftl_memset
	ldr	x0, [x20, #:lo12:.LANCHOR104]
	ldrh	w0, [x0, 698]
	cmp	w0, w19
	bcc	.L2923
.L2933:
	mov	w0, 0
.L2920:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L2923:
	mov	w2, 36
.L2934:
	adrp	x1, .LANCHOR209
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR209
	add	x0, x0, :lo12:.LC0
	bl	printf
	b	.L2933
.L2922:
	add	x0, x0, x19, sxtw 2
	adrp	x22, .LANCHOR135
	add	x1, x22, :lo12:.LANCHOR135
	ldr	w23, [x0, 704]
	lsl	x0, x21, 4
	add	x26, x1, x0
	strh	w19, [x1, x0]
	strh	wzr, [x26, 2]
	cbnz	w23, .L2925
	mov	w1, w19
	mov	w2, 0
	adrp	x0, .LC190
	add	x0, x0, :lo12:.LC190
	bl	printf
	adrp	x0, .LANCHOR210
	mov	w1, 255
	ldrh	w2, [x0, #:lo12:.LANCHOR210]
	ldr	x0, [x26, 8]
	bl	ftl_memset
	b	.L2933
.L2925:
	adrp	x20, .LANCHOR197
	adrp	x24, .LANCHOR126
	ldr	x1, [x26, 8]
	mov	w0, w23
	ldr	x2, [x20, #:lo12:.LANCHOR197]
	ldrb	w3, [x24, #:lo12:.LANCHOR126]
	bl	ftl_read_ppa_page
	ldr	x1, [x20, #:lo12:.LANCHOR197]
	ldr	w2, [x1]
	cmp	w2, w19
	bne	.L2926
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	beq	.L2926
.L2930:
	ldr	x0, [x20, #:lo12:.LANCHOR197]
	ldr	w0, [x0]
	cmp	w19, w0
	beq	.L2933
	mov	w2, 67
	b	.L2934
.L2926:
	mov	w4, w23
	mov	w3, w0
	mov	w1, w19
	adrp	x0, .LC191
	add	x0, x0, :lo12:.LC191
	bl	printf
	ldr	x1, [x25, #:lo12:.LANCHOR104]
	add	x22, x22, :lo12:.LANCHOR135
	add	x21, x22, x21, lsl 4
	mov	w2, 4
	add	x1, x1, 704
	adrp	x0, .LC192
	add	x0, x0, :lo12:.LC192
	ldrh	w3, [x1, -6]
	bl	rknand_print_hex
	ldr	x1, [x21, 8]
	mov	w2, 4
	ldrb	w3, [x24, #:lo12:.LANCHOR126]
	adrp	x0, .LC193
	add	x0, x0, :lo12:.LC193
	lsl	w3, w3, 7
	bl	rknand_print_hex
	ldr	x1, [x20, #:lo12:.LANCHOR197]
	mov	w3, 16
	mov	w2, 4
	adrp	x0, .LC194
	add	x0, x0, :lo12:.LC194
	bl	rknand_print_hex
	ldrb	w3, [x24, #:lo12:.LANCHOR126]
	mov	w0, w23
	ldr	x2, [x20, #:lo12:.LANCHOR197]
	ldr	x1, [x21, 8]
	bl	ftl_read_ppa_page
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	bne	.L2929
	adrp	x0, .LANCHOR210
	mov	w1, 255
	ldrh	w2, [x0, #:lo12:.LANCHOR210]
	ldr	x0, [x21, 8]
	bl	ftl_memset
.L2931:
	mov	w0, -1
	b	.L2920
.L2929:
	ldr	x0, [x20, #:lo12:.LANCHOR197]
	ldr	w0, [x0]
	cmp	w19, w0
	beq	.L2930
	b	.L2931
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
	adrp	x21, .LANCHOR148
	ldr	x0, [x19, #:lo12:.LANCHOR104]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	ldrh	w2, [x0, 688]
	adrp	x0, .LANCHOR151
	str	x27, [sp, 80]
	mov	x20, x0
	ldrh	w1, [x0, #:lo12:.LANCHOR151]
	sub	w1, w1, #1
	cmp	w2, w1
	bge	.L2936
	ldr	w0, [x21, #:lo12:.LANCHOR148]
	cbz	w0, .L2937
.L2936:
	bl	pm_free_sblk
	ldr	x2, [x19, #:lo12:.LANCHOR104]
	ldrh	w1, [x20, #:lo12:.LANCHOR151]
	sub	w1, w1, #1
	ldrh	w3, [x2, 688]
	cmp	w3, w1
	bge	.L2938
	ldr	w1, [x21, #:lo12:.LANCHOR148]
	cbz	w1, .L2937
.L2938:
	add	x0, x2, x0, uxth 1
	str	wzr, [x21, #:lo12:.LANCHOR148]
	mov	w20, 65535
	ldrh	w21, [x0, 416]
	cmp	w21, w20
	bne	.L2940
	adrp	x1, .LANCHOR211
	add	x1, x1, :lo12:.LANCHOR211
	mov	w2, 166
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	printf
	bl	pm_free_sblk
	ldr	x1, [x19, #:lo12:.LANCHOR104]
	add	x0, x1, x0, uxth 1
	ldrh	w21, [x0, 416]
	cmp	w21, w20
	beq	.L2937
.L2940:
	bl	pm_select_ram_region
	and	x22, x0, 65535
	lsl	x0, x22, 4
	adrp	x20, .LANCHOR135
	add	x1, x20, :lo12:.LANCHOR135
	mov	x25, x22
	add	x23, x1, x0
	ldrh	w0, [x1, x0]
	mov	w1, 65535
	cmp	w0, w1
	beq	.L2941
	ldr	x1, [x23, 8]
	cbz	x1, .L2941
	ldrsh	w2, [x23, 2]
	tbz	w2, #31, .L2941
	bl	pm_write_page
	ldrh	w0, [x23, 2]
	and	w0, w0, 32767
	strh	w0, [x23, 2]
.L2941:
	adrp	x23, .LANCHOR68
	adrp	x24, .LANCHOR31
	add	x23, x23, :lo12:.LANCHOR68
	add	x24, x24, :lo12:.LANCHOR31
	mov	w27, 0
	mov	w26, 24
.L2942:
	ldr	x2, [x19, #:lo12:.LANCHOR104]
	ldrh	w0, [x2, 698]
	cmp	w0, w27
	bhi	.L2945
	bl	pm_free_sblk
.L2937:
	mov	w0, 0
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L2945:
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
	bne	.L2943
	mov	w1, w25
	mov	w0, w27
	bl	load_l2p_region
	cbnz	w0, .L2944
	add	x0, x20, :lo12:.LANCHOR135
	add	x0, x0, x22, lsl 4
	ldr	x1, [x0, 8]
	mov	w0, w27
	bl	pm_write_page
.L2944:
	add	x1, x20, :lo12:.LANCHOR135
	lsl	x0, x22, 4
	mov	w2, -1
	strh	w2, [x1, x0]
.L2943:
	add	w27, w27, 1
	and	w27, w27, 65535
	b	.L2942
	.size	pm_gc, .-pm_gc
	.section	.text.pm_flush_id,"ax",@progbits
	.align	2
	.global	pm_flush_id
	.type	pm_flush_id, %function
pm_flush_id:
	stp	x29, x30, [sp, -32]!
	ubfiz	x0, x0, 4, 16
	adrp	x2, .LANCHOR135
	add	x2, x2, :lo12:.LANCHOR135
	add	x29, sp, 0
	str	x19, [sp, 16]
	add	x19, x2, x0
	ldrh	w0, [x2, x0]
	ldr	x1, [x19, 8]
	bl	pm_write_page
	ldrh	w0, [x19, 2]
	and	w0, w0, 32767
	strh	w0, [x19, 2]
	adrp	x19, .LANCHOR133
	ldr	w0, [x19, #:lo12:.LANCHOR133]
	cbz	w0, .L2954
	bl	pm_gc
	str	wzr, [x19, #:lo12:.LANCHOR133]
.L2954:
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
	adrp	x19, .LANCHOR135
	add	x19, x19, :lo12:.LANCHOR135
	mov	w20, 0
	add	x19, x19, 2
.L2961:
	ldrsh	w0, [x19]
	tbz	w0, #31, .L2960
	mov	w0, w20
	bl	pm_flush_id
.L2960:
	add	w20, w20, 1
	add	x19, x19, 16
	and	w20, w20, 65535
	cmp	w20, 32
	bne	.L2961
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
	adrp	x0, .LANCHOR148
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	adrp	x19, .LANCHOR135
	str	wzr, [x0, #:lo12:.LANCHOR148]
	adrp	x0, .LANCHOR133
	stp	x25, x26, [sp, 64]
	add	x20, x19, :lo12:.LANCHOR135
	str	wzr, [x0, #:lo12:.LANCHOR133]
	adrp	x0, .LANCHOR198
	stp	x27, x28, [sp, 80]
	adrp	x22, .LANCHOR126
	strb	w1, [x0, #:lo12:.LANCHOR198]
	mov	w0, 64
	bl	ftl_malloc
	add	x23, x20, 512
	adrp	x1, .LANCHOR197
	add	x22, x22, :lo12:.LANCHOR126
	mov	x21, x1
	mov	w25, -1
	str	x0, [x1, #:lo12:.LANCHOR197]
.L2971:
	strh	w25, [x20]
	strh	wzr, [x20, 2]
	cbz	w24, .L2970
	ldrb	w0, [x22]
	lsl	w0, w0, 9
	bl	ftl_malloc
	str	x0, [x20, 8]
.L2970:
	add	x20, x20, 16
	cmp	x20, x23
	bne	.L2971
	add	x0, x19, :lo12:.LANCHOR135
	adrp	x20, .LANCHOR104
	ldr	x22, [x21, #:lo12:.LANCHOR197]
	mov	w4, 4
	ldr	x27, [x0, 8]
	mov	x3, x22
	ldr	x0, [x20, #:lo12:.LANCHOR104]
	mov	x2, x27
	ldrh	w1, [x0, 692]
	ldrb	w0, [x0, 694]
	bl	flash_get_last_written_page
	sxth	w26, w0
	ldr	x0, [x20, #:lo12:.LANCHOR104]
	mov	w24, w26
	ldrh	w2, [x0, 696]
	cmp	w2, w26
	bgt	.L2972
	ldrh	w1, [x0, 692]
	mov	w3, w26
	adrp	x0, .LC195
	add	x0, x0, :lo12:.LC195
	adrp	x25, .LANCHOR126
	add	x25, x25, :lo12:.LANCHOR126
	adrp	x28, .LC196
	bl	printf
	ldr	x0, [x20, #:lo12:.LANCHOR104]
	ldrsh	w21, [x0, 696]
	adrp	x0, .LANCHOR105
	add	x0, x0, :lo12:.LANCHOR105
	str	x0, [x29, 104]
.L2973:
	cmp	w21, w26
	ble	.L2976
	adrp	x0, .LANCHOR188
	mov	w1, 1
	add	w24, w24, 1
	strb	w1, [x0, #:lo12:.LANCHOR188]
	ldr	x0, [x20, #:lo12:.LANCHOR104]
	strh	w24, [x0, 696]
	bl	pm_free_sblk
.L2972:
	add	x19, x19, :lo12:.LANCHOR135
	adrp	x0, .LANCHOR210
	mov	w1, 255
	ldrh	w2, [x0, #:lo12:.LANCHOR210]
	ldr	x0, [x19, 8]
	bl	ftl_memset
	ldr	x1, [x19, 8]
	mov	w0, -1
	bl	pm_write_page
	adrp	x0, .LANCHOR188
	ldrb	w0, [x0, #:lo12:.LANCHOR188]
	cbz	w0, .L2977
	ldr	x1, [x19, 8]
	mov	w0, -1
	bl	pm_write_page
	ldr	x1, [x19, 8]
	mov	w0, -1
	bl	pm_write_page
	ldr	x1, [x19, 8]
	mov	w0, -1
	bl	pm_write_page
.L2977:
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
.L2976:
	ldr	x0, [x20, #:lo12:.LANCHOR104]
	mov	x3, x22
	ldr	x1, [x29, 104]
	mov	x2, x27
	ldrb	w4, [x25]
	ldrh	w23, [x0, 692]
	ldrh	w1, [x1]
	ldrb	w0, [x0, 694]
	madd	w23, w23, w1, w21
	mov	w1, w23
	bl	flash_read_page_en
	mov	w4, w0
	ldr	x0, [x20, #:lo12:.LANCHOR104]
	str	w4, [x29, 100]
	mov	w2, w23
	ldr	w1, [x0, 48]
	ldrh	w3, [x0, 694]
	add	w1, w1, 1
	str	w1, [x0, 48]
	add	x0, x28, :lo12:.LC196
	ldr	w1, [x22]
	bl	printf
	ldr	w4, [x29, 100]
	cmp	w4, 512
	ccmn	w4, #1, 4, ne
	beq	.L2974
	ldr	x8, [x20, #:lo12:.LANCHOR104]
	ldr	w6, [x22]
	ldrh	w0, [x8, 698]
	cmp	w6, w0
	bcs	.L2974
	ldr	w7, [x22, 8]
	cbz	w7, .L2975
	ldrb	w1, [x25]
	mov	x0, x27
	lsl	w1, w1, 9
	bl	js_hash
	cmp	w7, w0
	beq	.L2975
	adrp	x0, .LC197
	mov	w1, w7
	add	x0, x0, :lo12:.LC197
	bl	printf
.L2974:
	add	w21, w21, 1
	sxth	w21, w21
	b	.L2973
.L2975:
	add	x6, x8, x6, uxtw 2
	str	w23, [x6, 704]
	b	.L2974
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
	adrp	x0, .LANCHOR123
	stp	x23, x24, [sp, 48]
	stp	x19, x20, [sp, 16]
	mov	w24, w2
	stp	x21, x22, [sp, 32]
	mov	x23, x1
	ldr	w2, [x0, #:lo12:.LANCHOR123]
	str	x27, [sp, 80]
	cmp	w25, w2
	bcc	.L2993
	mov	w1, w25
	adrp	x0, .LC198
	add	x0, x0, :lo12:.LC198
	bl	printf
	mov	w0, -1
	cbnz	w24, .L2992
	str	w0, [x23]
.L2992:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L2993:
	adrp	x0, .LANCHOR126
	adrp	x21, .LANCHOR135
	mov	x19, 0
	ldrb	w20, [x0, #:lo12:.LANCHOR126]
	add	x0, x21, :lo12:.LANCHOR135
	add	x0, x0, 8
	lsl	w22, w20, 7
	udiv	w22, w25, w22
	and	w26, w22, 65535
.L2999:
	ldr	x1, [x0]
	cbz	x1, .L2995
	ldrh	w1, [x0, -8]
	cmp	w1, w26
	bne	.L2995
.L2996:
	ubfiz	w20, w20, 7, 9
	msub	w25, w26, w20, w25
	and	x25, x25, 65535
	cbnz	w24, .L2997
	add	x0, x21, :lo12:.LANCHOR135
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
	bcc	.L2998
	mov	w0, -1
	str	w0, [x23]
.L2998:
	add	x21, x21, :lo12:.LANCHOR135
	add	x19, x21, x19, lsl 4
	ldrh	w0, [x19, 2]
	mvn	x1, x0
	tst	x1, 32767
	beq	.L3002
	add	w0, w0, 1
	strh	w0, [x19, 2]
.L3002:
	mov	w0, 0
	b	.L2992
.L2997:
	add	x0, x21, :lo12:.LANCHOR135
	ldr	w2, [x23]
	add	x0, x0, x19, lsl 4
	ldr	x1, [x0, 8]
	str	w2, [x1, x25, lsl 2]
	ldrh	w1, [x0, 2]
	orr	w1, w1, -32768
	strh	w1, [x0, 2]
	adrp	x0, .LANCHOR136
	strb	w22, [x0, #:lo12:.LANCHOR136]
	b	.L2998
.L2995:
	add	w19, w19, 1
	add	x0, x0, 16
	and	x19, x19, 65535
	cmp	w19, 32
	bne	.L2999
	bl	pm_select_ram_region
	and	x19, x0, 65535
	sbfiz	x1, x19, 4, 32
	add	x2, x21, :lo12:.LANCHOR135
	add	x3, x2, x1
	mov	w27, w0
	ldrh	w2, [x2, x1]
	mov	w1, 65535
	cmp	w2, w1
	beq	.L3000
	ldrsh	w1, [x3, 2]
	tbz	w1, #31, .L3000
	bl	pm_flush_id
.L3000:
	adrp	x0, .LANCHOR212
	mov	w1, w27
	strb	w19, [x0, #:lo12:.LANCHOR212]
	mov	w0, w26
	bl	load_l2p_region
	b	.L2996
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
	adrp	x1, .LANCHOR155
	stp	x27, x28, [sp, 112]
	mov	x27, x0
	strb	wzr, [x1, #:lo12:.LANCHOR155]
	add	x1, x20, 80
	stp	x21, x22, [sp, 64]
	str	x1, [x29, 168]
	stp	x23, x24, [sp, 80]
	ldrh	w1, [x20, 80]
	stp	x25, x26, [sp, 96]
	cmp	w1, w2
	beq	.L3009
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
	beq	.L3010
	adrp	x0, .LANCHOR35
	ldrb	w0, [x0, #:lo12:.LANCHOR35]
	cbz	w0, .L3011
.L3010:
	adrp	x0, .LANCHOR79
	ldrh	w0, [x0, #:lo12:.LANCHOR79]
	sub	w0, w0, #1
	add	w0, w0, w1
	orr	w2, w0, w2, lsl 24
	str	w2, [x28, 40]
.L3012:
	mov	w1, 1
	mov	x0, x28
	bl	sblk_read_page
	ldr	w0, [x28, 52]
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	beq	.L3013
	ldr	x0, [x28, 24]
	ldr	w1, [x0]
	mov	w0, 15555
	movk	w0, 0xf55f, lsl 16
	cmp	w1, w0
	beq	.L3014
.L3013:
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
.L3015:
	ldrh	w0, [x20, 80]
	adrp	x2, .LANCHOR9
	ldr	x2, [x2, #:lo12:.LANCHOR9]
	ubfiz	x1, x0, 1, 16
	ldrh	w1, [x2, x1]
	cbnz	w1, .L3050
	bl	ftl_dump_write_open_sblk
.L3050:
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
	beq	.L3051
	bl	ftl_free_sblk
.L3051:
	adrp	x0, .LANCHOR104
	ldr	x1, [x0, #:lo12:.LANCHOR104]
	mov	w0, -1
	strh	w0, [x1, 126]
	ldr	x1, [x27, #:lo12:.LANCHOR10]
	strh	w0, [x1, 130]
	mov	w0, 0
	bl	ftl_info_flush
.L3008:
	ldp	x19, x20, [sp, 48]
	ldp	x21, x22, [sp, 64]
	ldp	x23, x24, [sp, 80]
	ldp	x25, x26, [sp, 96]
	ldp	x27, x28, [sp, 112]
	ldp	x29, x30, [sp, 32]
	add	sp, sp, 240
	ret
.L3011:
	cmp	w2, 3
	bne	.L3012
	adrp	x0, .LANCHOR87
	ldrh	w0, [x0, #:lo12:.LANCHOR87]
	sub	w0, w0, #1
	add	w0, w0, w1
	orr	w0, w0, 50331648
	str	w0, [x28, 40]
	b	.L3012
.L3014:
	adrp	x22, .LANCHOR79
	adrp	x19, .LANCHOR80
	adrp	x23, .LANCHOR157
	ldr	x1, [x28, 8]
	ldrb	w0, [x19, #:lo12:.LANCHOR80]
	adrp	x25, .LANCHOR158
	ldrh	w2, [x22, #:lo12:.LANCHOR79]
	mul	w2, w2, w0
	ldr	x0, [x23, #:lo12:.LANCHOR157]
	lsl	w2, w2, 2
	bl	ftl_memcpy
	str	x22, [x29, 152]
	ldrb	w1, [x19, #:lo12:.LANCHOR80]
	ldrh	w0, [x22, #:lo12:.LANCHOR79]
	mul	w0, w0, w1
	adrp	x1, .LANCHOR126
	ldrb	w1, [x1, #:lo12:.LANCHOR126]
	lsl	w2, w0, 2
	cmp	w1, w0, lsr 6
	bge	.L3016
	lsl	w1, w1, 7
	sub	w0, w1, w0
	mov	w1, 0
	lsl	w26, w0, 2
	ldr	x0, [x25, #:lo12:.LANCHOR158]
	bl	ftl_memset
	ldr	x0, [x29, 152]
	mov	w2, w26
	ldrb	w1, [x19, #:lo12:.LANCHOR80]
	ldrh	w0, [x0, #:lo12:.LANCHOR79]
	mul	w0, w0, w1
	ldr	x1, [x28, 8]
	add	x1, x1, x0, sxtw 2
	ldr	x0, [x25, #:lo12:.LANCHOR158]
	bl	ftl_memcpy
	mov	w0, 1
	str	w0, [x29, 180]
.L3017:
	adrp	x0, .LANCHOR87
	ldrh	w0, [x0, #:lo12:.LANCHOR87]
	str	w0, [x29, 184]
	ldr	x0, [x29, 160]
	ldrb	w0, [x0, #:lo12:.LANCHOR73]
	str	w0, [x29, 188]
	cmp	w0, 2
	bne	.L3018
	adrp	x0, .LANCHOR74
	ldrb	w0, [x0, #:lo12:.LANCHOR74]
	cbz	w0, .L3019
.L3018:
	adrp	x0, .LANCHOR35
	ldrb	w0, [x0, #:lo12:.LANCHOR35]
	cbz	w0, .L3020
.L3019:
	ldp	w0, w1, [x29, 184]
	mul	w0, w0, w1
	str	w0, [x29, 184]
	mov	w0, 1
	str	w0, [x29, 188]
.L3020:
	adrp	x24, .LC200
	mov	w22, 0
	add	x0, x24, :lo12:.LC200
	mov	w19, 0
	str	x0, [x29, 104]
.L3021:
	sub	w0, w22, #1
	str	w0, [x29, 136]
	ldr	w0, [x29, 184]
	cmp	w0, w22
	bls	.L3033
	adrp	x0, .LANCHOR35
	mov	x21, 0
	add	x0, x0, :lo12:.LANCHOR35
	str	x0, [x29, 112]
	b	.L3034
.L3016:
	ldr	x1, [x28, 8]
	mov	w26, 0
	add	x1, x1, x0, sxtw 2
	ldr	x0, [x25, #:lo12:.LANCHOR158]
	bl	ftl_memcpy
	str	wzr, [x29, 180]
	b	.L3017
.L3029:
	ldp	x1, x0, [x29, 120]
	ldrh	w0, [x0, 96]
	ldrh	w1, [x1]
	mul	w0, w0, w1
	ldr	x1, [x29, 160]
	str	w0, [x29, 200]
	ldrb	w1, [x1, #:lo12:.LANCHOR73]
	cmp	w1, 2
	beq	.L3022
	ldr	x2, [x29, 112]
	ldrb	w2, [x2]
	cbz	w2, .L3023
.L3022:
	ldr	w2, [x29, 136]
	add	w0, w2, w0
	add	w0, w0, w24
	orr	w0, w0, w1, lsl 24
.L3025:
	str	w0, [x28, 40]
	mov	w1, 1
	str	x8, [x29, 96]
	mov	x0, x28
	bl	sblk_read_page
	ldr	w1, [x29, 180]
	ldr	x0, [x28, 24]
	ldr	x8, [x29, 96]
	cbz	w1, .L3026
	ldr	x1, [x25, #:lo12:.LANCHOR158]
	ldr	w2, [x1, x8]
	cbnz	w2, .L3026
	ldr	w2, [x0, 8]
	str	w2, [x1, x8]
.L3026:
	ldr	x1, [x23, #:lo12:.LANCHOR157]
	ldr	w6, [x0, 4]
	ldr	w3, [x1, x8]
	cmp	w3, w6
	bne	.L3027
	ldr	x1, [x25, #:lo12:.LANCHOR158]
	ldr	w2, [x1, x8]
	ldr	w1, [x0, 8]
	cmp	w2, w1
	beq	.L3028
.L3027:
	ldr	x1, [x25, #:lo12:.LANCHOR158]
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
	ldr	x0, [x23, #:lo12:.LANCHOR157]
	ldr	x8, [x29, 96]
	ldr	w0, [x0, x8]
	cmn	w0, #1
	beq	.L3028
	mov	x0, x28
	bl	zbuf_free
	adrp	x0, .LANCHOR9
	ldrh	w1, [x20, 80]
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	strh	wzr, [x0, x1, lsl 1]
	ldr	x0, [x27, #:lo12:.LANCHOR10]
	ldrh	w1, [x20, 80]
	strh	w1, [x0, 130]
	b	.L3015
.L3023:
	cmp	w1, 3
	add	w0, w22, w0
	bne	.L3025
	orr	w0, w0, w24, lsl 24
	b	.L3025
.L3028:
	add	w19, w19, 1
	add	w24, w24, 1
	add	x8, x8, 4
.L3031:
	ldr	w0, [x29, 188]
	cmp	w0, w24
	bcs	.L3029
	add	x21, x21, 1
.L3034:
	ldr	x0, [x29, 168]
	ldrb	w0, [x0, 9]
	cmp	w0, w21
	ble	.L3030
	add	x0, x20, x21, lsl 1
	str	x0, [x29, 128]
	ldr	x0, [x29, 144]
	sbfiz	x8, x19, 2, 32
	mov	w24, 1
	add	x0, x0, :lo12:.LANCHOR105
	str	x0, [x29, 120]
	b	.L3031
.L3030:
	adrp	x0, .LANCHOR74
	ldrb	w0, [x0, #:lo12:.LANCHOR74]
	cmp	w0, 0
	cinc	w22, w22, ne
	add	w22, w22, 1
	b	.L3021
.L3033:
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
.L3035:
	sub	w0, w28, #1
	str	w0, [x29, 128]
	ldr	w0, [x29, 184]
	cmp	w0, w28
	bls	.L3048
	mov	x22, 0
	b	.L3049
.L3044:
	ldr	w0, [x29, 180]
	ldr	x1, [x23, #:lo12:.LANCHOR157]
	sbfiz	x0, x0, 2, 32
	ldr	w21, [x1, x0]
	cmn	w21, #1
	beq	.L3036
	ldr	x1, [x25, #:lo12:.LANCHOR158]
	ldr	w0, [x1, x0]
	str	w0, [x29, 152]
	mov	w0, w21
	bl	lpa_hash_get_ppa
	str	w0, [x29, 204]
	cmn	w0, #1
	bne	.L3037
	mov	w2, 0
	add	x1, x29, 204
	mov	w0, w21
	bl	pm_log2phys
.L3037:
	ldr	x0, [x29, 120]
	ldr	x1, [x29, 144]
	ldrh	w0, [x0, 96]
	ldrh	w1, [x1, #:lo12:.LANCHOR105]
	mul	w0, w0, w1
	ldr	x1, [x29, 160]
	ldrb	w1, [x1, #:lo12:.LANCHOR73]
	cmp	w1, 2
	beq	.L3038
	adrp	x2, .LANCHOR35
	ldrb	w2, [x2, #:lo12:.LANCHOR35]
	cbz	w2, .L3039
.L3038:
	ldr	w2, [x29, 128]
	add	w0, w0, w2
	add	w0, w0, w24
	orr	w0, w0, w1, lsl 24
.L3041:
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
	bne	.L3042
	add	x1, x29, 200
	mov	w0, w21
	bl	pm_log2phys
	add	w26, w26, 1
	mov	w0, w19
	bl	ftl_vpn_decrement
.L3043:
	ldr	w0, [x29, 180]
	add	w0, w0, 1
	str	w0, [x29, 180]
	adrp	x0, .LANCHOR7
	ldr	x0, [x0, #:lo12:.LANCHOR7]
	add	x0, x0, x19, lsl 2
	ldrb	w0, [x0, 2]
	tst	w0, 224
	bne	.L3036
	ldr	x0, [x29, 136]
	lsl	x19, x19, 1
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrh	w1, [x0, x19]
	cbz	w1, .L3036
	strh	wzr, [x0, x19]
.L3036:
	add	w24, w24, 1
.L3046:
	ldr	w0, [x29, 188]
	cmp	w0, w24
	bcs	.L3044
	add	x22, x22, 1
.L3049:
	ldr	x0, [x29, 168]
	ldrb	w0, [x0, 9]
	cmp	w0, w22
	ble	.L3045
	add	x0, x20, x22, lsl 1
	mov	w24, 1
	str	x0, [x29, 120]
	adrp	x0, .LANCHOR31
	add	x0, x0, :lo12:.LANCHOR31
	str	x0, [x29, 112]
	b	.L3046
.L3039:
	cmp	w1, 3
	add	w0, w28, w0
	bne	.L3041
	orr	w0, w0, w24, lsl 24
	b	.L3041
.L3042:
	ldr	w1, [x29, 200]
	cmp	w0, w1
	cinc	w26, w26, eq
	b	.L3043
.L3045:
	adrp	x0, .LANCHOR74
	ldrb	w0, [x0, #:lo12:.LANCHOR74]
	cmp	w0, 0
	cinc	w28, w28, ne
	add	w28, w28, 1
	b	.L3035
.L3048:
	ldr	x0, [x29, 136]
	ldrh	w1, [x20, 80]
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	strh	w26, [x0, x1, lsl 1]
	ldrh	w0, [x20, 80]
	bl	zftl_insert_data_list
	b	.L3015
.L3009:
	ldrh	w0, [x20, 130]
	cmp	w0, w1
	beq	.L3008
	adrp	x19, .LANCHOR104
	ldr	x1, [x19, #:lo12:.LANCHOR104]
	ldrh	w1, [x1, 126]
	cmp	w1, w0
	bne	.L3053
	bl	pm_flush
	ldr	x0, [x27, #:lo12:.LANCHOR10]
	ldrh	w0, [x0, 130]
	bl	ftl_free_sblk
	ldr	x0, [x19, #:lo12:.LANCHOR104]
	mov	w1, -1
	strh	w1, [x0, 126]
	mov	w0, 0
	bl	ftl_info_flush
.L3053:
	ldr	x0, [x27, #:lo12:.LANCHOR10]
	mov	w1, -1
	strh	w1, [x0, 130]
	b	.L3008
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
	adrp	x1, .LANCHOR129
	stp	x19, x20, [sp, 16]
	adrp	x21, .LANCHOR80
	strb	w0, [x1, #:lo12:.LANCHOR129]
	adrp	x1, .LANCHOR130
	stp	x23, x24, [sp, 48]
	adrp	x20, .LANCHOR210
	strb	wzr, [x1, #:lo12:.LANCHOR130]
	adrp	x1, .LANCHOR178
	stp	x25, x26, [sp, 64]
	adrp	x23, .LANCHOR6
	strb	w0, [x1, #:lo12:.LANCHOR178]
	adrp	x0, .LANCHOR124
	mov	w1, -1
	stp	x27, x28, [sp, 80]
	strb	wzr, [x0, #:lo12:.LANCHOR124]
	adrp	x0, .LANCHOR213
	str	w1, [x0, #:lo12:.LANCHOR213]
	adrp	x1, .LC202
	adrp	x0, .LC98
	add	x1, x1, :lo12:.LC202
	add	x0, x0, :lo12:.LC98
	bl	printf
	adrp	x1, .LANCHOR32
	add	x1, x1, :lo12:.LANCHOR32
	adrp	x0, .LANCHOR73
	adrp	x2, .LANCHOR126
	adrp	x3, .LANCHOR79
	adrp	x4, .LANCHOR69
	ldrb	w5, [x1, 12]
	strb	w5, [x0, #:lo12:.LANCHOR73]
	ldrb	w0, [x1, 9]
	strb	w0, [x2, #:lo12:.LANCHOR126]
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
	strh	w10, [x20, #:lo12:.LANCHOR210]
	mov	w3, 1
	and	w6, w6, 255
	mov	w1, 0
	strb	w6, [x21, #:lo12:.LANCHOR80]
.L3087:
	cmp	w4, w3
	bcs	.L3088
	mul	w2, w0, w2
	adrp	x3, .LANCHOR68
	sub	w1, w1, #1
	mov	w4, 0
	strh	w1, [x3, #:lo12:.LANCHOR68]
	mov	w1, 1
	mul	w3, w2, w7
	lsr	w11, w3, 21
.L3089:
	cmp	w11, w1
	bcs	.L3090
	mov	w1, 57344
	sub	w4, w4, #1
	movk	w1, 0x1c, lsl 16
	mul	w3, w3, w6
	adrp	x28, .LANCHOR123
	sub	w11, w10, #1
	mul	w1, w6, w1
	adrp	x24, .LANCHOR193
	mul	w8, w8, w6
	adrp	x27, .LANCHOR215
	mul	w2, w2, w6
	adrp	x26, .LANCHOR151
	lsl	w1, w1, w4
	adrp	x4, .LANCHOR61
	sub	w2, w2, #1
	adrp	x25, .LANCHOR91
	str	w1, [x4, #:lo12:.LANCHOR61]
	adrp	x4, .LANCHOR214
	str	w3, [x4, #:lo12:.LANCHOR214]
	add	w3, w1, 24576
	str	w3, [x27, #:lo12:.LANCHOR215]
	udiv	w0, w3, w0
	udiv	w3, w3, w2
	adrp	x2, .LANCHOR120
	str	w0, [x28, #:lo12:.LANCHOR123]
	add	w0, w11, w0, lsl 2
	add	w3, w3, 8
	udiv	w0, w0, w10
	strh	w0, [x24, #:lo12:.LANCHOR193]
	ubfiz	w0, w0, 4, 16
	sdiv	w0, w0, w8
	adrp	x8, .LANCHOR95
	str	x8, [x29, 104]
	strh	w3, [x8, #:lo12:.LANCHOR95]
	strh	w0, [x26, #:lo12:.LANCHOR151]
	add	w0, w7, w7, lsl 1
	asr	w0, w0, 2
	strh	w0, [x2, #:lo12:.LANCHOR120]
	lsr	w0, w7, 4
	strh	w0, [x25, #:lo12:.LANCHOR91]
	cmp	w0, 79
	bhi	.L3091
	mov	w0, 80
	strh	w0, [x25, #:lo12:.LANCHOR91]
.L3091:
	adrp	x7, .LANCHOR121
	mov	w0, 2000
	adrp	x6, .LANCHOR119
	adrp	x8, .LANCHOR150
	strh	w0, [x7, #:lo12:.LANCHOR121]
	mov	w0, 50
	adrp	x2, .LANCHOR149
	strh	w0, [x6, #:lo12:.LANCHOR119]
	mov	w0, 256
	strh	w0, [x8, #:lo12:.LANCHOR150]
	mov	w0, 48
	strh	w0, [x2, #:lo12:.LANCHOR149]
	adrp	x0, .LANCHOR8
	mov	w3, 32
	cmp	w5, 2
	mov	x11, x6
	strh	w3, [x0, #:lo12:.LANCHOR8]
	mov	x5, x7
	mov	x10, x2
	beq	.L3092
	adrp	x12, .LANCHOR77
	ldrb	w12, [x12, #:lo12:.LANCHOR77]
	cbz	w12, .L3093
.L3092:
	mov	w2, 150
	strh	w2, [x11, #:lo12:.LANCHOR119]
	mov	w2, 64
	strh	w2, [x10, #:lo12:.LANCHOR149]
	mov	w2, 12
	strh	w2, [x0, #:lo12:.LANCHOR8]
	adrp	x2, .LANCHOR0
	ldrb	w2, [x2, #:lo12:.LANCHOR0]
	cbnz	w2, .L3095
	mov	w2, 4
	strh	w2, [x0, #:lo12:.LANCHOR8]
	mov	w0, 600
	strh	w0, [x5, #:lo12:.LANCHOR121]
	mov	w0, 128
	strh	w0, [x8, #:lo12:.LANCHOR150]
.L3095:
	adrp	x19, .LANCHOR14
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L3097
	str	x4, [x29, 96]
	adrp	x0, .LC203
	add	x0, x0, :lo12:.LC203
	bl	printf
	ldr	x4, [x29, 96]
.L3097:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L3098
	ldr	w1, [x4, #:lo12:.LANCHOR214]
	adrp	x0, .LC204
	add	x0, x0, :lo12:.LC204
	bl	printf
.L3098:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L3099
	ldr	w1, [x28, #:lo12:.LANCHOR123]
	adrp	x0, .LC205
	add	x0, x0, :lo12:.LC205
	bl	printf
.L3099:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L3100
	ldr	w1, [x27, #:lo12:.LANCHOR215]
	adrp	x0, .LC206
	add	x0, x0, :lo12:.LC206
	bl	printf
.L3100:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L3101
	ldrh	w1, [x24, #:lo12:.LANCHOR193]
	adrp	x0, .LC207
	add	x0, x0, :lo12:.LC207
	bl	printf
.L3101:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L3102
	ldrh	w1, [x20, #:lo12:.LANCHOR210]
	adrp	x0, .LC208
	add	x0, x0, :lo12:.LC208
	bl	printf
.L3102:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L3103
	ldrh	w1, [x26, #:lo12:.LANCHOR151]
	adrp	x0, .LC209
	add	x0, x0, :lo12:.LC209
	bl	printf
.L3103:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L3104
	ldrh	w1, [x25, #:lo12:.LANCHOR91]
	adrp	x0, .LC210
	add	x0, x0, :lo12:.LC210
	bl	printf
.L3104:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L3105
	ldr	x0, [x29, 104]
	ldrh	w1, [x0, #:lo12:.LANCHOR95]
	adrp	x0, .LC211
	add	x0, x0, :lo12:.LC211
	bl	printf
.L3105:
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
	tbz	x0, 12, .L3106
	adrp	x0, .LC212
	add	x0, x0, :lo12:.LC212
	bl	printf
.L3106:
	ldrh	w0, [x22, #:lo12:.LANCHOR87]
	ldrb	w21, [x21, #:lo12:.LANCHOR80]
	ldrh	w1, [x23, #:lo12:.LANCHOR6]
	ldrh	w22, [x24, #:lo12:.LANCHOR193]
	mul	w21, w0, w21
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	add	w21, w1, w21, lsl 2
	lsl	w1, w1, 2
	lsl	w21, w21, 1
	add	w22, w1, w22, lsl 2
	add	w21, w21, 632
	add	w22, w22, 704
	tbz	x0, 12, .L3107
	ldrh	w3, [x20, #:lo12:.LANCHOR210]
	adrp	x0, .LC213
	mov	w2, w22
	mov	w1, w21
	add	x0, x0, :lo12:.LC213
	bl	printf
.L3107:
	ldrh	w0, [x20, #:lo12:.LANCHOR210]
	cmp	w21, w0
	bhi	.L3108
	cmp	w22, w0
	bls	.L3109
.L3108:
.L3155:
	b	.L3155
.L3088:
	add	w1, w1, 1
	lsl	w3, w3, 1
	and	w1, w1, 65535
	b	.L3087
.L3090:
	add	w4, w4, 1
	lsl	w1, w1, 1
	and	w4, w4, 65535
	b	.L3089
.L3093:
	adrp	x0, .LANCHOR35
	ldrb	w0, [x0, #:lo12:.LANCHOR35]
	cbz	w0, .L3095
	mov	w0, 1200
	strh	w3, [x6, #:lo12:.LANCHOR119]
	strh	w0, [x7, #:lo12:.LANCHOR121]
	strh	w3, [x2, #:lo12:.LANCHOR149]
	b	.L3095
.L3109:
	bl	sblk_init
	bl	ftl_info_blk_init
	cmn	w0, #1
	beq	.L3086
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
	adrp	x0, .LANCHOR188
	ldrb	w0, [x0, #:lo12:.LANCHOR188]
	cbz	w0, .L3111
	ldr	x1, [x19, #:lo12:.LANCHOR104]
	ldr	w0, [x1, 68]
	add	w0, w0, 1
	str	w0, [x1, 68]
.L3111:
	bl	ftl_ext_info_flush
	mov	w0, 0
	bl	ftl_info_flush
	bl	print_ftl_debug_info
	mov	w0, 0
.L3086:
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
	cbnz	w0, .L3159
	bl	zftl_init
.L3159:
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
	tbz	x1, 8, .L3162
	ldrh	w1, [x21, 80]
	adrp	x0, .LC215
	add	x0, x0, :lo12:.LC215
	bl	printf
.L3162:
	adrp	x23, .LANCHOR9
	ldrh	w1, [x21, 80]
	sub	w2, w26, #1
	mov	x22, 0
	ldr	x0, [x23, #:lo12:.LANCHOR9]
	mov	w25, 0
	strh	w2, [x0, x1, lsl 1]
	adrp	x0, .LANCHOR126
	add	x0, x0, :lo12:.LANCHOR126
	str	x0, [x29, 104]
.L3163:
	mov	w28, w22
	cmp	w26, w22
	bhi	.L3173
	ldr	w0, [x24, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L3174
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
.L3174:
	ldrh	w1, [x21, 80]
	ldr	x0, [x23, #:lo12:.LANCHOR9]
	ldrh	w0, [x0, x1, lsl 1]
	cmp	w25, w0
	beq	.L3175
	adrp	x1, .LANCHOR216
	adrp	x0, .LC0
	mov	w2, 753
	add	x1, x1, :lo12:.LANCHOR216
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3175:
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
.L3173:
	adrp	x27, .LANCHOR157
	lsl	x19, x22, 2
	ldr	x0, [x27, #:lo12:.LANCHOR157]
	ldr	w2, [x0, x19]
	cmn	w2, #1
	beq	.L3164
	adrp	x0, .LANCHOR126
	ldrb	w20, [x0, #:lo12:.LANCHOR126]
	lsl	w20, w20, 7
	udiv	w20, w2, w20
	and	w0, w20, 65535
	str	w0, [x29, 156]
	ldr	w0, [x24, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L3165
	ldr	w1, [x29, 156]
	adrp	x0, .LC216
	mov	w3, w22
	add	x0, x0, :lo12:.LC216
	bl	printf
.L3165:
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
.L3166:
	ldr	x0, [x29, 144]
	cmp	x0, x19
	bne	.L3172
.L3164:
	add	x22, x22, 1
	b	.L3163
.L3172:
	ldr	x0, [x27, #:lo12:.LANCHOR157]
	ldr	w20, [x0, x19]
	cmn	w20, #1
	beq	.L3167
	ldr	x0, [x29, 104]
	ldr	w1, [x29, 156]
	ldrb	w0, [x0]
	lsl	w0, w0, 7
	udiv	w0, w20, w0
	cmp	w1, w0, uxth
	bne	.L3167
	adrp	x0, .LANCHOR158
	ldr	x0, [x0, #:lo12:.LANCHOR158]
	ldr	w28, [x0, x19]
	mov	w0, w20
	bl	lpa_hash_get_ppa
	str	w0, [x29, 172]
	cmn	w0, #1
	bne	.L3168
	mov	w2, 0
	add	x1, x29, 172
	mov	w0, w20
	bl	pm_log2phys
.L3168:
	ldr	w3, [x29, 172]
	cmp	w28, w3
	bne	.L3169
	adrp	x0, .LANCHOR159
	mov	w2, 1
	add	x1, x29, 168
	add	w25, w25, 1
	ldr	x0, [x0, #:lo12:.LANCHOR159]
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
.L3195:
	bl	ftl_vpn_decrement
	ldr	x0, [x27, #:lo12:.LANCHOR157]
	mov	w1, -1
	str	w1, [x0, x19]
.L3167:
	add	x19, x19, 4
	b	.L3166
.L3169:
	ldr	w0, [x24, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L3171
	ldr	x0, [x29, 120]
	mov	w2, w28
	mov	w1, w20
	bl	printf
.L3171:
	ldr	x0, [x29, 136]
	ldrh	w0, [x0]
	b	.L3195
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
.L3197:
	cmp	w23, w5
	beq	.L3199
	cbz	w4, .L3200
	add	x1, x19, :lo12:.LANCHOR64
	strh	w2, [x1, 2]
.L3200:
	cbz	w3, .L3201
	add	x1, x19, :lo12:.LANCHOR64
	strb	w0, [x1, 4]
.L3201:
	mov	w0, 1
	adrp	x24, .LANCHOR105
	bl	buf_alloc
	adrp	x25, .LANCHOR73
	mov	x21, x0
	add	x24, x24, :lo12:.LANCHOR105
	add	x25, x25, :lo12:.LANCHOR73
	mov	w26, 1
.L3202:
	add	x20, x19, :lo12:.LANCHOR64
	ldrb	w1, [x20, 6]
	cmp	w26, w1
	ble	.L3211
	mov	x0, x21
	bl	zbuf_free
	ldrb	w0, [x20, 4]
	ldrb	w1, [x22, #:lo12:.LANCHOR80]
	add	w0, w0, 1
	and	w0, w0, 255
	strb	w0, [x20, 4]
	cmp	w1, w0
	bne	.L3196
	ldrh	w0, [x20, 2]
	strb	wzr, [x20, 4]
	add	w0, w0, 1
	strh	w0, [x20, 2]
.L3196:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L3199:
	add	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, w6
	bne	.L3198
	add	w2, w2, 1
	mov	w0, 0
	and	w2, w2, 65535
	mov	w4, 1
.L3198:
	add	x3, x1, x0, sxtw 1
	ldrh	w23, [x3, 40]
	mov	w3, 1
	b	.L3197
.L3211:
	ldrh	w0, [x24]
	cmp	w1, 2
	mul	w0, w0, w23
	beq	.L3203
	cmp	w1, 3
	bne	.L3204
	adrp	x1, .LANCHOR35
	ldrb	w1, [x1, #:lo12:.LANCHOR35]
	cbz	w1, .L3205
.L3203:
	add	x1, x19, :lo12:.LANCHOR64
	add	w0, w26, w0
	ldrh	w1, [x1, 2]
	lsl	w1, w1, 1
	sub	w1, w1, #1
	add	w0, w1, w0
	ldrb	w1, [x25]
	orr	w0, w0, w1, lsl 24
.L3223:
	str	w0, [x21, 40]
	mov	w1, 1
	mov	x0, x21
	bl	sblk_read_page
	ldr	w0, [x21, 52]
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	beq	.L3208
	ldr	x0, [x21, 24]
	ldr	w20, [x0, 4]
	mov	w0, w20
	bl	lpa_hash_get_ppa
	str	w0, [x29, 92]
	cmn	w0, #1
	bne	.L3209
	adrp	x0, .LANCHOR123
	ldr	w0, [x0, #:lo12:.LANCHOR123]
	cmp	w20, w0
	bcs	.L3209
	mov	w2, 0
	add	x1, x29, 92
	mov	w0, w20
	bl	pm_log2phys
.L3209:
	ldr	w2, [x21, 40]
	ldr	w0, [x29, 92]
	cmp	w2, w0
	bne	.L3208
	add	x1, x19, :lo12:.LANCHOR64
	adrp	x4, .LANCHOR70
	ldr	x4, [x4, #:lo12:.LANCHOR70]
	ldrh	w0, [x1, 24]
	ubfiz	x3, x0, 2, 16
	add	w0, w0, 1
	str	w2, [x4, x3]
	strh	w0, [x1, 24]
.L3208:
	add	x1, x19, :lo12:.LANCHOR64
	add	w26, w26, 1
	ldrh	w0, [x1, 26]
	add	w0, w0, 1
	strh	w0, [x1, 26]
	b	.L3202
.L3205:
	ldrh	w1, [x20, 2]
	add	w0, w1, w0
	orr	w0, w0, w26, lsl 24
	b	.L3223
.L3204:
	ldrh	w1, [x20, 2]
	add	w0, w1, w0
	b	.L3223
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
	bne	.L3225
	adrp	x1, .LANCHOR217
	adrp	x0, .LC0
	mov	w2, 1240
	add	x1, x1, :lo12:.LANCHOR217
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3225:
	ldrh	w1, [x19, #:lo12:.LANCHOR64]
	mov	w0, 65535
	cmp	w1, w0
	beq	.L3245
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L3227
	adrp	x2, .LANCHOR9
	ubfiz	x0, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR9]
	ldrh	w2, [x2, x0]
	adrp	x0, .LC219
	add	x0, x0, :lo12:.LC219
	bl	printf
.L3227:
	ldrh	w0, [x19, #:lo12:.LANCHOR64]
	add	x14, x19, :lo12:.LANCHOR64
	add	x1, x14, 40
	bl	ftl_get_blk_list_in_sblk
	and	w1, w0, 255
	strb	w1, [x14, 5]
	cbnz	w1, .L3228
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR64]
.L3245:
	mov	w0, 0
	b	.L3224
.L3228:
	adrp	x4, .LANCHOR7
	ldrh	w3, [x19, #:lo12:.LANCHOR64]
	mov	x22, x4
	ldr	x1, [x4, #:lo12:.LANCHOR7]
	mov	x2, x3
	add	x1, x1, x3, lsl 2
	ldrb	w1, [x1, 2]
	and	w1, w1, 224
	cmp	w1, 32
	beq	.L3229
	cmp	w1, 224
	beq	.L3229
	cbz	w1, .L3230
	adrp	x1, .LANCHOR10
	ldr	x1, [x1, #:lo12:.LANCHOR10]
	ldrh	w3, [x1, 16]
	cmp	w3, w2
	beq	.L3229
	ldrh	w3, [x1, 48]
	cmp	w3, w2
	beq	.L3229
	ldrh	w1, [x1, 80]
	cmp	w1, w2
	bne	.L3262
.L3229:
	add	x0, x19, :lo12:.LANCHOR64
	mov	w1, -1
	strh	w1, [x19, #:lo12:.LANCHOR64]
	strh	wzr, [x0, 24]
	b	.L3245
.L3230:
	adrp	x0, .LANCHOR9
	mov	x20, x0
	ldr	x1, [x0, #:lo12:.LANCHOR9]
	ldrh	w1, [x1, x3, lsl 1]
	cbz	w1, .L3232
	adrp	x1, .LANCHOR217
	adrp	x0, .LC0
	mov	w2, 1260
	add	x1, x1, :lo12:.LANCHOR217
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3232:
	ldrh	w1, [x19, #:lo12:.LANCHOR64]
	ldr	x0, [x20, #:lo12:.LANCHOR9]
	strh	wzr, [x0, x1, lsl 1]
	b	.L3229
.L3262:
	and	w0, w0, 255
	sub	w0, w0, #1
	add	x0, x14, x0, sxtw 1
	ldrh	w21, [x0, 40]
	mov	w0, 65535
	cmp	w21, w0
	bne	.L3233
	adrp	x1, .LANCHOR217
	adrp	x0, .LC0
	mov	w2, 1268
	add	x1, x1, :lo12:.LANCHOR217
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3233:
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
	bne	.L3246
	adrp	x1, .LANCHOR73
	ldrb	w1, [x1, #:lo12:.LANCHOR73]
	and	w23, w1, 65535
	cmp	w1, 2
	orr	w20, w20, w1, lsl 24
	bne	.L3235
	ldrh	w0, [x21, #:lo12:.LANCHOR79]
	sub	w0, w0, #1
	and	w0, w0, 65535
.L3235:
	adrp	x1, .LANCHOR35
	ldrb	w1, [x1, #:lo12:.LANCHOR35]
	cbz	w1, .L3234
	ldrh	w0, [x21, #:lo12:.LANCHOR79]
	sub	w0, w0, #1
	and	w0, w0, 65535
.L3234:
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
	bne	.L3236
.L3264:
	mov	x0, x25
	bl	zbuf_free
	mov	w0, -1
.L3224:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L3246:
	mov	w23, 1
	b	.L3234
.L3236:
	ldr	x0, [x25, 24]
	ldr	w1, [x0]
	mov	w0, 15555
	movk	w0, 0xf55f, lsl 16
	cmp	w1, w0
	beq	.L3237
	mov	w2, 1303
	adrp	x1, .LANCHOR217
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR217
	add	x0, x0, :lo12:.LC0
	bl	printf
	b	.L3264
.L3237:
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
.L3238:
	cmp	w20, w26
	bgt	.L3243
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
	beq	.L3244
	adrp	x0, .LC220
	add	x0, x0, :lo12:.LC220
	bl	printf
.L3244:
	add	x0, x19, :lo12:.LANCHOR64
	ldrh	w2, [x19, #:lo12:.LANCHOR64]
	ldr	x1, [x20, #:lo12:.LANCHOR9]
	ldrh	w3, [x0, 24]
	strh	w3, [x1, x2, lsl 1]
	strh	wzr, [x0, 28]
	ldrh	w0, [x0, 24]
	b	.L3224
.L3243:
	ldr	w0, [x24, x26, lsl 2]
	cmn	w0, #1
	beq	.L3240
	bl	lpa_hash_get_ppa
	str	w0, [x29, 92]
	cmn	w0, #1
	bne	.L3241
	ldr	w0, [x24, x26, lsl 2]
	mov	w2, 0
	add	x1, x29, 92
	bl	pm_log2phys
.L3241:
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
	bne	.L3240
	ldrh	w0, [x1, 24]
	ldr	x4, [x21, #:lo12:.LANCHOR70]
	ubfiz	x2, x0, 2, 16
	add	w0, w0, 1
	str	w3, [x4, x2]
	strh	w0, [x1, 24]
.L3240:
	add	x26, x26, 1
	b	.L3238
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
	beq	.L3266
	adrp	x21, .LANCHOR218
	adrp	x22, .LC0
	add	x21, x21, :lo12:.LANCHOR218
	add	x22, x22, :lo12:.LC0
	mov	w20, 11
.L3274:
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	mov	w2, 0
	add	x1, x29, 76
	ldr	w0, [x0, 544]
	bl	pm_log2phys
	ldr	w0, [x29, 76]
	cmn	w0, #1
	beq	.L3267
	mov	w0, 1
	bl	buf_alloc
	ldr	w1, [x29, 76]
	mov	x23, x0
	str	w1, [x0, 40]
	mov	w1, 1
	bl	sblk_read_page
	ldr	w0, [x23, 52]
	cmp	w0, 256
	bne	.L3268
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
.L3268:
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	ldr	x1, [x23, 24]
	ldr	w0, [x0, 544]
	ldr	w1, [x1, 4]
	cmp	w1, w0
	beq	.L3269
	mov	w2, 1742
	mov	x1, x21
	mov	x0, x22
	bl	printf
.L3269:
	mov	x0, x23
	bl	zbuf_free
.L3267:
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	adrp	x2, .LANCHOR123
	ldr	w2, [x2, #:lo12:.LANCHOR123]
	ldr	w1, [x0, 544]
	add	w1, w1, 1
	str	w1, [x0, 544]
	cmp	w1, w2
	bcc	.L3270
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
.L3265:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L3270:
	ldr	w0, [x29, 76]
	cmn	w0, #1
	bne	.L3265
	sub	w20, w20, #1
	ands	w20, w20, 65535
	bne	.L3274
	b	.L3265
.L3266:
	ldr	w1, [x0, 536]
	adrp	x3, .LANCHOR104
	ldr	w2, [x0, 12]
	add	w1, w1, 12959744
	add	w1, w1, 256
	cmp	w2, w1
	bhi	.L3276
	ldr	x4, [x3, #:lo12:.LANCHOR104]
	mov	w5, 5000
	ldr	w1, [x0, 540]
	add	w1, w1, w5
	ldr	w4, [x4, 44]
	cmp	w4, w1
	bls	.L3265
.L3276:
	ldr	x1, [x3, #:lo12:.LANCHOR104]
	ldr	w1, [x1, 44]
	str	w1, [x0, 540]
	str	w2, [x0, 536]
	str	wzr, [x0, 544]
	b	.L3265
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
	beq	.L3304
	adrp	x0, .LANCHOR6
	ldrh	w0, [x0, #:lo12:.LANCHOR6]
	cmp	w0, w20
	bls	.L3304
	ldr	x0, [x24, #:lo12:.LANCHOR7]
	add	x0, x0, x23
	ldrb	w0, [x0, 2]
	and	w0, w0, 224
	cmp	w0, 160
	bne	.L3305
	adrp	x0, .LANCHOR73
	ldrb	w25, [x0, #:lo12:.LANCHOR73]
.L3284:
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
.L3285:
	ldr	x0, [x29, 136]
	ldrh	w0, [x0, #:lo12:.LANCHOR87]
	cmp	w0, w19
	bls	.L3301
	lsl	w0, w19, 1
	mov	w22, 0
	sub	w1, w0, #1
	add	w0, w0, w19
	sub	w0, w0, #1
	stp	w0, w1, [x29, 152]
	adrp	x0, .LC167
	add	x0, x0, :lo12:.LC167
	str	x0, [x29, 120]
	b	.L3302
.L3305:
	mov	w25, 1
	b	.L3284
.L3298:
	ldr	x0, [x29, 128]
	ldrh	w11, [x28, x0]
	mov	w0, 65535
	cmp	w11, w0
	beq	.L3286
	ldr	x0, [x29, 112]
	cmp	w25, 3
	ldrh	w8, [x0]
	mul	w8, w8, w11
	add	w0, w21, w8
	bne	.L3287
	adrp	x1, .LANCHOR35
	ldrb	w1, [x1, #:lo12:.LANCHOR35]
	cbz	w1, .L3288
	adrp	x1, .LANCHOR73
	ldrb	w8, [x1, #:lo12:.LANCHOR73]
	ldr	w1, [x29, 152]
.L3314:
	add	w0, w0, w1
	orr	w27, w0, w8, lsl 24
	b	.L3289
.L3288:
	add	w8, w19, w8
	orr	w27, w8, w21, lsl 24
.L3289:
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
	beq	.L3286
	ldr	x0, [x26, 24]
	ldr	w0, [x0, 4]
	bl	lpa_hash_get_ppa
	str	w0, [x29, 204]
	cmn	w0, #1
	bne	.L3292
	ldr	x0, [x26, 24]
	mov	w2, 0
	add	x1, x29, 204
	ldr	w0, [x0, 4]
	bl	pm_log2phys
.L3292:
	ldr	w0, [x29, 204]
	cmp	w27, w0
	bne	.L3293
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
.L3293:
	ldr	x0, [x29, 160]
	cbz	x0, .L3295
	ldr	x0, [x29, 176]
	ubfiz	x3, x0, 2, 32
	ldr	x0, [x29, 160]
	ldr	w2, [x0, x3]
	ldr	x0, [x26, 24]
	ldr	w0, [x0, 4]
	cmp	w0, w2
	beq	.L3296
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L3296
	ldr	w1, [x29, 176]
	adrp	x0, .LC224
	str	x3, [x29, 104]
	add	x0, x0, :lo12:.LC224
	bl	printf
	ldr	x3, [x29, 104]
.L3296:
	ldr	x1, [x26, 24]
	ldr	x0, [x29, 160]
	ldr	w1, [x1, 4]
	ldr	w0, [x0, x3]
	cmp	w1, w0
	beq	.L3295
	cmn	w0, #1
	beq	.L3295
	adrp	x1, .LANCHOR219
	adrp	x0, .LC0
	mov	w2, 1393
	add	x1, x1, :lo12:.LANCHOR219
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3295:
	ldr	w0, [x29, 176]
	add	w0, w0, 1
	str	w0, [x29, 176]
.L3286:
	add	w21, w21, 1
	and	w21, w21, 65535
.L3300:
	cmp	w25, w21
	bcs	.L3298
	add	w22, w22, 1
	and	w22, w22, 65535
.L3302:
	ldrb	w0, [x29, 217]
	cmp	w0, w22
	bls	.L3299
	sxtw	x0, w22
	mov	w21, 1
	add	x0, x0, 8
	lsl	x0, x0, 1
	str	x0, [x29, 128]
	b	.L3300
.L3287:
	cmp	w25, 2
	bne	.L3290
	adrp	x1, .LANCHOR73
	ldrb	w8, [x1, #:lo12:.LANCHOR73]
	ldr	w1, [x29, 156]
	b	.L3314
.L3290:
	add	w27, w19, w8
	b	.L3289
.L3299:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L3285
.L3301:
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
.L3282:
	ldp	x19, x20, [sp, 64]
	ldp	x21, x22, [sp, 80]
	ldp	x23, x24, [sp, 96]
	ldp	x25, x26, [sp, 112]
	ldp	x27, x28, [sp, 128]
	ldp	x29, x30, [sp, 48]
	add	sp, sp, 288
	ret
.L3304:
	mov	w0, 0
	b	.L3282
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
	stp	x23, x24, [sp, 64]
	mov	w20, w1
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	mov	w23, w2
	stp	x25, x26, [sp, 80]
	mov	x22, x3
	stp	x27, x28, [sp, 96]
	tbz	x0, 12, .L3316
	mov	w3, w2
	adrp	x0, .LC226
	mov	w2, w1
	add	x0, x0, :lo12:.LC226
	mov	w1, w19
	bl	printf
.L3316:
	cbnz	w19, .L3317
	adrp	x0, .LANCHOR61
	mov	w19, 24576
	ldr	w0, [x0, #:lo12:.LANCHOR61]
.L3318:
	cmp	w0, w20
	ccmp	w0, w23, 0, hi
	bcc	.L3348
	add	w1, w20, w23
	cmp	w0, w1
	bcc	.L3348
	adrp	x1, .LANCHOR104
	adrp	x26, .LANCHOR126
	add	w19, w19, w20
	str	x1, [x29, 120]
	ldr	x2, [x1, #:lo12:.LANCHOR104]
	str	x26, [x29, 168]
	ldr	w0, [x2, 24]
	add	w0, w0, w23
	str	w0, [x2, 24]
	ldrb	w0, [x26, #:lo12:.LANCHOR126]
	add	w2, w23, w19
	stp	w2, wzr, [x29, 160]
	sub	w2, w2, #1
	udiv	w27, w19, w0
	udiv	w0, w2, w0
	mov	w20, w27
	sub	w25, w0, w27
	str	w0, [x29, 156]
	add	w25, w25, 1
	adrp	x0, .LANCHOR130
	add	x28, x0, :lo12:.LANCHOR130
.L3320:
	cbnz	w25, .L3345
	ldr	w0, [x29, 164]
.L3315:
	ldp	x19, x20, [sp, 32]
	ldp	x21, x22, [sp, 48]
	ldp	x23, x24, [sp, 64]
	ldp	x25, x26, [sp, 80]
	ldp	x27, x28, [sp, 96]
	ldp	x29, x30, [sp, 16]
	add	sp, sp, 208
	ret
.L3317:
	cmp	w19, 3
	bhi	.L3348
	lsl	w19, w19, 13
	mov	w0, 8192
	b	.L3318
.L3345:
	ldr	x0, [x29, 168]
	cmp	w20, w27
	ldrb	w1, [x0, #:lo12:.LANCHOR126]
	ldr	w0, [x29, 156]
	and	w24, w1, 65535
	ccmp	w20, w0, 4, ne
	bne	.L3349
	cmp	w20, w27
	bne	.L3322
	udiv	w3, w19, w1
	and	w0, w23, 65535
	msub	w1, w3, w1, w19
	and	w26, w1, 65535
	sub	w24, w24, w26
	and	w24, w24, 65535
	cmp	w23, w24
	csel	w24, w0, w24, cc
.L3321:
	adrp	x21, .LANCHOR52
	add	x1, x21, :lo12:.LANCHOR52
	add	x1, x1, 2
	mov	w0, 0
.L3325:
	ldr	w2, [x1, 34]
	cmp	w20, w2
	bne	.L3323
	ldrb	w2, [x1]
	tbz	x2, 3, .L3323
	add	x1, x21, :lo12:.LANCHOR52
	ubfiz	x0, x0, 6, 32
	add	x0, x1, x0
	lsl	w2, w24, 9
	ubfiz	x24, x24, 9, 16
	ubfiz	x26, x26, 9, 16
	ldr	x1, [x0, 8]
	mov	x0, x22
	add	x22, x22, x24
	add	x1, x1, x26
	bl	ftl_memcpy
.L3324:
	add	w20, w20, 1
	sub	w25, w25, #1
.L3331:
	adrp	x0, .LANCHOR54
	ldrb	w0, [x0, #:lo12:.LANCHOR54]
	cmp	w0, 2
	bls	.L3332
	cbnz	w25, .L3320
.L3332:
	adrp	x0, .LANCHOR130
	ldrb	w1, [x0, #:lo12:.LANCHOR130]
	cbz	w1, .L3320
	adrp	x24, .LANCHOR129
	add	x0, x21, :lo12:.LANCHOR52
	ldrb	w2, [x24, #:lo12:.LANCHOR129]
	add	x0, x0, x2, lsl 6
	bl	sblk_read_page
	adrp	x0, .LANCHOR220
	add	x0, x0, :lo12:.LANCHOR220
	str	x0, [x29, 136]
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	str	x0, [x29, 128]
.L3334:
	ldrb	w0, [x28]
	cbnz	w0, .L3344
	mov	w0, -1
	strb	wzr, [x28]
	strb	w0, [x24, #:lo12:.LANCHOR129]
	b	.L3320
.L3322:
	ldr	w0, [x29, 160]
	msub	w24, w1, w20, w0
	and	w24, w24, 255
.L3349:
	mov	w26, 0
	b	.L3321
.L3323:
	add	w0, w0, 1
	add	x1, x1, 64
	cmp	w0, 32
	bne	.L3325
	mov	w0, w20
	bl	lpa_hash_get_ppa
	str	w0, [x29, 188]
	cmn	w0, #1
	bne	.L3326
	mov	w2, 0
	add	x1, x29, 188
	mov	w0, w20
	bl	pm_log2phys
.L3326:
	ldr	w0, [x29, 188]
	cmn	w0, #1
	bne	.L3327
	ldr	x0, [x29, 168]
	mov	w24, 0
	add	x26, x0, :lo12:.LANCHOR126
.L3328:
	ldrb	w0, [x26]
	cmp	w24, w0
	bcs	.L3324
	madd	w0, w20, w0, w24
	cmp	w19, w0
	bhi	.L3329
	ldr	w1, [x29, 160]
	cmp	w1, w0
	bls	.L3329
	mov	x0, x22
	add	x22, x22, 512
	mov	w2, 512
	mov	w1, 0
	bl	ftl_memset
.L3329:
	add	w24, w24, 1
	b	.L3328
.L3327:
	mov	w0, 0
	bl	buf_alloc
	cbz	x0, .L3331
	ldr	x2, [x29, 120]
	ldr	x4, [x2, #:lo12:.LANCHOR104]
	ldr	w2, [x4, 40]
	add	w2, w2, 1
	str	w2, [x4, 40]
	ldr	w2, [x29, 188]
	strb	w24, [x0, 56]
	ubfiz	x24, x24, 9, 16
	str	x22, [x0, 16]
	add	x22, x22, x24
	strb	w26, [x0, 57]
	stp	w20, w2, [x0, 36]
	str	w2, [x0, 44]
	bl	zftl_add_read_buf
	b	.L3324
.L3344:
	ldrb	w0, [x24, #:lo12:.LANCHOR129]
	cmp	w0, 255
	bne	.L3335
	ldp	x0, x1, [x29, 128]
	mov	w2, 1090
	bl	printf
.L3335:
	ldrb	w26, [x24, #:lo12:.LANCHOR129]
	add	x0, x21, :lo12:.LANCHOR52
	ubfiz	x1, x26, 6, 8
	lsl	x2, x26, 6
	add	x1, x0, x1
	str	x1, [x29, 144]
	add	x1, x0, x2
	ldrb	w0, [x0, x2]
	strb	w0, [x24, #:lo12:.LANCHOR129]
	ldr	w10, [x1, 52]
	cmn	w10, #1
	bne	.L3336
	adrp	x0, .LANCHOR10
	str	w10, [x29, 164]
	ldr	x1, [x0, #:lo12:.LANCHOR10]
	ldr	w0, [x1, 552]
	add	w0, w0, 1
	str	w0, [x1, 552]
.L3337:
	add	x1, x21, :lo12:.LANCHOR52
	add	x1, x1, x26, lsl 6
	ldr	x0, [x1, 24]
	ldr	w3, [x1, 36]
	ldr	w1, [x0, 4]
	cmp	w1, w3
	bne	.L3338
	cmn	w10, #1
	bne	.L3339
.L3338:
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
.L3339:
	add	x0, x21, :lo12:.LANCHOR52
	add	x0, x0, x26, lsl 6
	ldr	x1, [x0, 24]
	ldr	w0, [x0, 36]
	ldr	w1, [x1, 4]
	cmp	w1, w0
	bne	.L3340
	cmn	w10, #1
	bne	.L3341
.L3340:
	ldp	x0, x1, [x29, 128]
	mov	w2, 1111
	bl	printf
.L3341:
	add	x0, x21, :lo12:.LANCHOR52
	add	x8, x0, x26, lsl 6
	ldr	x0, [x29, 168]
	ldrb	w2, [x8, 56]
	ldrb	w0, [x0, #:lo12:.LANCHOR126]
	cmp	w0, w2
	bls	.L3342
	ldrb	w0, [x8, 57]
	lsl	w2, w2, 9
	ldr	x1, [x8, 8]
	ubfiz	x0, x0, 9, 8
	add	x1, x1, x0
	ldr	x0, [x8, 16]
	bl	ftl_memcpy
.L3343:
	ldr	x1, [x29, 144]
	adrp	x0, .LANCHOR132
	add	x0, x0, :lo12:.LANCHOR132
	bl	buf_remove_buf
	ldr	x0, [x29, 144]
	bl	zbuf_free
	ldrb	w0, [x28]
	sub	w0, w0, #1
	strb	w0, [x28]
	b	.L3334
.L3336:
	cmp	w10, 256
	bne	.L3337
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
	b	.L3337
.L3342:
	ldrb	w0, [x8, 2]
	and	w0, w0, -9
	strb	w0, [x8, 2]
	b	.L3343
.L3348:
	mov	w0, -1
	b	.L3315
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
	adrp	x19, .LANCHOR64
	add	x20, x19, :lo12:.LANCHOR64
	stp	x21, x22, [sp, 48]
	stp	x23, x24, [sp, 64]
	adrp	x22, .LANCHOR10
	stp	x25, x26, [sp, 80]
	ldr	x0, [x20, 8]
	stp	x27, x28, [sp, 96]
	ldr	x23, [x22, #:lo12:.LANCHOR10]
	cbnz	x0, .L3371
	mov	w0, 1
	bl	buf_alloc
	str	x0, [x20, 8]
.L3371:
	add	x0, x19, :lo12:.LANCHOR64
	ldr	x20, [x0, 8]
	cbnz	x20, .L3372
	adrp	x1, .LANCHOR221
	adrp	x0, .LC0
	mov	w2, 614
	add	x1, x1, :lo12:.LANCHOR221
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3372:
	adrp	x4, .LANCHOR105
	add	x28, x23, 96
	add	x24, x23, 80
	add	x4, x4, :lo12:.LANCHOR105
	mov	w27, 0
.L3373:
	ldrb	w0, [x24, 9]
	cmp	w27, w0
	bge	.L3384
	adrp	x26, .LANCHOR73
	mov	w25, 1
	add	x21, x19, :lo12:.LANCHOR64
	add	x26, x26, :lo12:.LANCHOR73
	b	.L3385
.L3383:
	ldrh	w0, [x28]
	ldrh	w1, [x4]
	ldrb	w2, [x26]
	cmp	w2, 2
	mul	w1, w0, w1
	beq	.L3374
	adrp	x0, .LANCHOR35
	ldrb	w0, [x0, #:lo12:.LANCHOR35]
	cbz	w0, .L3375
.L3374:
	ldrh	w0, [x21, 16]
	sub	w3, w0, #1
	add	w0, w25, w1
	add	w0, w3, w0
	orr	w2, w0, w2, lsl 24
	str	w2, [x20, 40]
.L3376:
	str	x4, [x29, 104]
	mov	w1, 1
	mov	x0, x20
	bl	sblk_read_page
	ldr	w2, [x20, 52]
	adrp	x8, .LANCHOR157
	ldr	x4, [x29, 104]
	cmn	w2, #1
	beq	.L3378
	ldrh	w0, [x21, 22]
	ldr	x3, [x8, #:lo12:.LANCHOR157]
	ldr	x1, [x20, 24]
	lsl	x0, x0, 2
	ldr	w5, [x3, x0]
	ldr	w3, [x1, 4]
	cmp	w5, w3
	bne	.L3378
	adrp	x3, .LANCHOR158
	ldr	x3, [x3, #:lo12:.LANCHOR158]
	ldr	w3, [x3, x0]
	ldr	w0, [x1, 8]
	cmp	w3, w0
	beq	.L3379
.L3378:
	ldrh	w0, [x21, 22]
	ldr	x1, [x8, #:lo12:.LANCHOR157]
	lsl	x0, x0, 2
	ldr	w3, [x1, x0]
	cmn	w3, #1
	beq	.L3379
	adrp	x1, .LANCHOR14
	ldr	w1, [x1, #:lo12:.LANCHOR14]
	tbz	x1, 10, .L3380
	ldr	x1, [x20, 24]
	adrp	x4, .LANCHOR158
	str	x8, [x29, 104]
	ldr	x4, [x4, #:lo12:.LANCHOR158]
	ldr	w5, [x1, 12]
	str	w5, [sp]
	ldr	w4, [x4, x0]
	adrp	x0, .LC229
	ldp	w5, w6, [x1]
	add	x0, x0, :lo12:.LC229
	ldr	w7, [x1, 8]
	ldr	w1, [x20, 40]
	bl	printf
	ldr	x8, [x29, 104]
.L3380:
	adrp	x0, .LANCHOR118
	mov	x21, x0
	ldrb	w1, [x0, #:lo12:.LANCHOR118]
	cbnz	w1, .L3381
	adrp	x19, .LANCHOR79
	ldrb	w3, [x24, 9]
	ldr	x1, [x8, #:lo12:.LANCHOR157]
	mov	w2, 4
	ldrh	w0, [x19, #:lo12:.LANCHOR79]
	mul	w3, w3, w0
	adrp	x0, .LC230
	add	x0, x0, :lo12:.LC230
	bl	rknand_print_hex
	ldrh	w0, [x19, #:lo12:.LANCHOR79]
	mov	w2, 4
	ldrb	w3, [x24, 9]
	mul	w3, w3, w0
	adrp	x0, .LANCHOR158
	ldr	x1, [x0, #:lo12:.LANCHOR158]
	adrp	x0, .LC231
	add	x0, x0, :lo12:.LC231
	bl	rknand_print_hex
	ldr	x0, [x22, #:lo12:.LANCHOR10]
	mov	x1, 0
	ldrh	w0, [x0, 80]
	bl	ftl_sblk_dump
.L3381:
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
	bne	.L3387
	ldrb	w0, [x21, #:lo12:.LANCHOR118]
	cbnz	w0, .L3387
	ldr	w0, [x20, 40]
	bl	ftl_mask_bad_block
.L3387:
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
	orr	w0, w0, w25, lsl 24
.L3377:
	str	w0, [x20, 40]
	b	.L3376
.L3379:
	ldrh	w0, [x21, 22]
	add	w25, w25, 1
	add	w0, w0, 1
	strh	w0, [x21, 22]
.L3385:
	ldrh	w0, [x21, 20]
	cmp	w25, w0
	ble	.L3383
	add	w27, w27, 1
	add	x28, x28, 2
	b	.L3373
.L3384:
	add	x19, x19, :lo12:.LANCHOR64
	ldrh	w0, [x19, 16]
	add	w1, w0, 1
	strh	w1, [x19, 16]
	adrp	x1, .LANCHOR74
	ldrb	w1, [x1, #:lo12:.LANCHOR74]
	cbz	w1, .L3388
	add	w0, w0, 2
	strh	w0, [x19, 16]
.L3388:
.L3382:
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
	beq	.L3403
	adrp	x1, .LANCHOR222
	adrp	x0, .LC0
	mov	w2, 1743
	add	x1, x1, :lo12:.LANCHOR222
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3403:
	adrp	x27, .LANCHOR126
	mov	x24, 0
	add	x0, x27, :lo12:.LANCHOR126
	mov	w21, 0
	str	x0, [x29, 96]
.L3404:
	cmp	w24, w23
	blt	.L3410
	adrp	x0, .LANCHOR14
	adrp	x19, .LANCHOR9
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L3411
	ldrh	w1, [x22]
	ldr	x2, [x19, #:lo12:.LANCHOR9]
	ubfiz	x0, x1, 1, 16
	ldrh	w3, [x2, x0]
	adrp	x0, .LC235
	mov	w2, w21
	add	x0, x0, :lo12:.LC235
	bl	printf
.L3411:
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
.L3410:
	ldr	w2, [x19, x24, lsl 2]
	cmn	w2, #1
	beq	.L3405
	ldrb	w20, [x27, #:lo12:.LANCHOR126]
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	lsl	w20, w20, 7
	udiv	w20, w2, w20
	and	w20, w20, 65535
	tbz	x0, 12, .L3406
	adrp	x0, .LC232
	mov	w3, w24
	mov	w1, w20
	add	x0, x0, :lo12:.LC232
	bl	printf
.L3406:
	adrp	x25, .LANCHOR105
	adrp	x26, .LC233
	mov	x28, x24
	add	x25, x25, :lo12:.LANCHOR105
	add	x26, x26, :lo12:.LC233
.L3409:
	ldr	w1, [x19, x28, lsl 2]
	cmn	w1, #1
	beq	.L3407
	ldr	x0, [x29, 96]
	ldrb	w2, [x0]
	lsl	w2, w2, 7
	udiv	w1, w1, w2
	cmp	w20, w1, uxth
	bne	.L3407
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
	cbz	w0, .L3408
	ldr	x0, [x29, 104]
	mov	w3, w23
	mov	w2, 4
	ldr	x1, [x0, #:lo12:.LANCHOR111]
	adrp	x0, .LC234
	add	x0, x0, :lo12:.LC234
	bl	rknand_print_hex
.L3408:
	ldr	w0, [x19, x28, lsl 2]
	add	w21, w21, 1
	mov	w2, 1
	add	x1, x29, 124
	and	w21, w21, 65535
	bl	pm_log2phys
	mov	w0, -1
	str	w0, [x19, x28, lsl 2]
.L3407:
	add	x28, x28, 1
	cmp	w23, w28
	bgt	.L3409
.L3405:
	add	x24, x24, 1
	b	.L3404
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
	beq	.L3433
	bl	zftl_insert_data_list
.L3433:
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
	bne	.L3435
	mov	w20, 65535
	cmp	w21, w20
	beq	.L3435
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
.L3435:
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
.L3439:
	adrp	x2, .LANCHOR60
	ldrb	w1, [x2, #:lo12:.LANCHOR60]
	cbz	w1, .L3441
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
	adrp	x0, .LANCHOR123
	ldr	w2, [x5, 36]
	mov	x19, x0
	ldr	w1, [x0, #:lo12:.LANCHOR123]
	cmp	w2, w1
	bcc	.L3443
	adrp	x1, .LANCHOR223
	adrp	x0, .LC0
	mov	w2, 510
	add	x1, x1, :lo12:.LANCHOR223
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3443:
	ldr	x0, [x29, 112]
	ldr	w1, [x19, #:lo12:.LANCHOR123]
	add	x0, x23, x0, lsl 6
	ldr	w22, [x0, 36]
	cmp	w22, w1
	bcc	.L3444
	ldr	x0, [x29, 120]
	bl	zbuf_free
	mov	w0, -1
.L3438:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	ret
.L3444:
	ldrb	w21, [x0, 57]
	ldrb	w20, [x0, 56]
	ldr	x26, [x0, 8]
	ldr	x28, [x0, 24]
	adrp	x0, .LANCHOR124
	str	x0, [x29, 104]
	ldrb	w1, [x0, #:lo12:.LANCHOR124]
	cbz	w1, .L3446
	adrp	x0, .LANCHOR178
	ldrb	w1, [x0, #:lo12:.LANCHOR178]
	add	x1, x23, x1, lsl 6
.L3447:
	ldrb	w0, [x1]
	cmp	w0, 255
	bne	.L3448
	ldr	w0, [x1, 36]
	cmp	w22, w0
	bne	.L3446
	ldr	x0, [x1, 8]
	ubfiz	x21, x21, 9, 8
	lsl	w2, w20, 9
	add	x1, x26, x21
	add	x0, x0, x21
	bl	ftl_memcpy
	ldr	x0, [x29, 120]
	bl	zbuf_free
	b	.L3439
.L3448:
	ubfiz	x1, x0, 6, 8
	add	x1, x23, x1
	b	.L3447
.L3446:
	mov	w0, w22
	bl	lpa_hash_get_ppa
	str	w0, [x29, 140]
	cmn	w0, #1
	bne	.L3450
	mov	w2, 0
	add	x1, x29, 140
	mov	w0, w22
	bl	pm_log2phys
.L3450:
	adrp	x25, .LANCHOR10
	add	x1, x23, 2
	mov	w0, 0
	ldr	x19, [x25, #:lo12:.LANCHOR10]
	add	x19, x19, 16
.L3453:
	ldr	w2, [x1, 34]
	cmp	w22, w2
	bne	.L3451
	ldrb	w2, [x1]
	tbz	x2, 3, .L3451
	ubfiz	x0, x0, 6, 32
	and	w2, w2, -9
	add	x0, x23, x0
	strb	w2, [x0, 2]
	ldr	x24, [x0, 8]
	ldr	w0, [x0, 40]
	str	w0, [x29, 140]
.L3452:
	adrp	x0, .LANCHOR126
	str	x0, [x29, 96]
	ldrb	w1, [x0, #:lo12:.LANCHOR126]
	cmp	w20, w1
	bcs	.L3477
	add	w20, w21, w20
	cbz	x24, .L3455
	cbz	w21, .L3456
	lsl	w2, w21, 9
	mov	x1, x24
	mov	x0, x26
	bl	ftl_memcpy
	ldr	x19, [x25, #:lo12:.LANCHOR10]
	add	x19, x19, 48
.L3456:
	ldr	x0, [x29, 96]
	ldrb	w2, [x0, #:lo12:.LANCHOR126]
	cmp	w20, w2
	bcc	.L3457
	ldr	x19, [x25, #:lo12:.LANCHOR10]
	add	x19, x19, 16
.L3477:
	mov	w24, 0
	b	.L3454
.L3451:
	add	w0, w0, 1
	add	x1, x1, 64
	cmp	w0, 32
	bne	.L3453
	mov	x24, 0
	b	.L3452
.L3457:
	ubfiz	x0, x20, 9, 9
	sub	w2, w2, w20
	add	x1, x24, x0
	lsl	w2, w2, 9
	add	x0, x26, x0
	bl	ftl_memcpy
	b	.L3477
.L3455:
	ldr	w0, [x29, 140]
	cmn	w0, #1
	beq	.L3458
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
	bne	.L3459
	ldr	w0, [x27, 52]
	cmn	w0, #1
	bne	.L3460
.L3459:
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
	adrp	x0, .LC194
	mov	w2, w3
	add	x0, x0, :lo12:.LC194
	bl	rknand_print_hex
.L3460:
	ldr	x0, [x27, 24]
	ldr	w0, [x0, 4]
	cmp	w22, w0
	bne	.L3461
	ldr	w0, [x27, 52]
	cmn	w0, #1
	bne	.L3462
.L3461:
	adrp	x1, .LANCHOR223
	adrp	x0, .LC0
	mov	w2, 581
	add	x1, x1, :lo12:.LANCHOR223
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3462:
	cbz	w21, .L3463
	ldr	w0, [x29, 140]
	lsl	w2, w21, 9
	cmn	w0, #1
	beq	.L3464
	ldr	x1, [x27, 8]
	mov	x0, x26
	bl	ftl_memcpy
.L3465:
	ldr	x19, [x25, #:lo12:.LANCHOR10]
	add	x19, x19, 48
.L3463:
	ldr	x0, [x29, 96]
	ldrb	w2, [x0, #:lo12:.LANCHOR126]
	cmp	w20, w2
	bcc	.L3466
	bls	.L3467
	ldr	x19, [x25, #:lo12:.LANCHOR10]
	add	x19, x19, 16
.L3467:
	cbz	x27, .L3454
	ldrb	w0, [x27, 2]
	mov	x1, x27
	and	w0, w0, -9
	strb	w0, [x27, 2]
	adrp	x0, .LANCHOR132
	add	x0, x0, :lo12:.LANCHOR132
	bl	buf_remove_buf
	mov	x0, x27
	bl	zbuf_free
.L3454:
	ldrh	w0, [x19, 6]
	cbnz	w0, .L3469
	bl	ftl_flush
	mov	x0, x19
	bl	ftl_alloc_new_data_sblk
.L3469:
	mov	x0, x19
	bl	ftl_get_new_free_page
	ldr	x1, [x29, 112]
	adrp	x20, .LANCHOR178
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
	add	x0, x20, :lo12:.LANCHOR178
	bl	buf_add_tail
	ldr	x0, [x29, 104]
	ldrb	w2, [x0, #:lo12:.LANCHOR124]
	add	w2, w2, 1
	and	w2, w2, 255
	strb	w2, [x0, #:lo12:.LANCHOR124]
	adrp	x0, .LANCHOR224
	cmp	w2, 2
	str	wzr, [x0, #:lo12:.LANCHOR224]
	ldrh	w0, [x19, 6]
	bhi	.L3470
	cmp	w0, 1
	bne	.L3442
.L3470:
	ldrb	w1, [x19, 5]
	cmp	w1, 0
	mov	w1, 0
	cset	w4, ne
	cmp	w0, 1
	ldrb	w0, [x20, #:lo12:.LANCHOR178]
	csinc	w4, w2, w4, eq
	mov	w3, w0
.L3474:
	cmp	w1, w4
	bne	.L3475
	strb	w3, [x20, #:lo12:.LANCHOR178]
	and	w1, w1, 255
	ldr	x3, [x29, 104]
	sub	w2, w2, w1
	ubfiz	x0, x0, 6, 8
	add	x0, x23, x0
	strb	w2, [x3, #:lo12:.LANCHOR124]
	bl	sblk_prog_page
	ldrh	w0, [x19, 6]
	cmp	w0, 1
	bne	.L3442
	bl	sblk_wait_write_queue_completed
	bl	ftl_write_completed
	mov	x0, x19
	bl	ftl_write_last_log_page
	mov	x0, x19
	bl	ftl_alloc_new_data_sblk
.L3442:
	adrp	x0, .LANCHOR60
	ldrb	w0, [x0, #:lo12:.LANCHOR60]
	cbnz	w0, .L3439
.L3441:
	bl	ftl_write_completed
	mov	w0, 0
	b	.L3438
.L3466:
	ldr	w0, [x29, 140]
	sub	w2, w2, w20
	lsl	w2, w2, 9
	cmn	w0, #1
	ubfiz	x0, x20, 7, 9
	beq	.L3468
	ldr	x1, [x27, 8]
	lsl	x0, x0, 2
	add	x1, x1, x0
	add	x0, x26, x0
	bl	ftl_memcpy
	b	.L3467
.L3468:
	mov	w1, 0
	add	x0, x26, x0, lsl 2
	bl	ftl_memset
	b	.L3467
.L3475:
	ubfiz	x3, x3, 6, 8
	add	w1, w1, 1
	ldrb	w3, [x23, x3]
	b	.L3474
.L3476:
	lsl	w2, w21, 9
	mov	x27, 0
	mov	w24, 0
.L3464:
	mov	w1, 0
	mov	x0, x26
	bl	ftl_memset
	b	.L3465
.L3458:
	cbnz	w21, .L3476
	mov	w24, 0
	mov	x27, 0
	b	.L3463
	.size	ftl_write_commit, .-ftl_write_commit
	.section	.text.gc_do_copy_back,"ax",@progbits
	.align	2
	.global	gc_do_copy_back
	.type	gc_do_copy_back, %function
gc_do_copy_back:
	sub	sp, sp, #208
	adrp	x0, .LANCHOR78
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	ldrb	w0, [x0, #:lo12:.LANCHOR78]
	stp	x19, x20, [sp, 32]
	stp	x21, x22, [sp, 48]
	stp	x23, x24, [sp, 64]
	stp	x25, x26, [sp, 80]
	stp	x27, x28, [sp, 96]
	cbnz	w0, .L3500
	bl	buf_alloc
	mov	x19, x0
	cbz	x0, .L3499
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
	bne	.L3502
	adrp	x1, .LANCHOR225
	adrp	x0, .LC0
	mov	w2, 868
	add	x1, x1, :lo12:.LANCHOR225
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3502:
	ldr	x0, [x19, 24]
	ldr	w20, [x0, 4]
	mov	w0, w20
	bl	lpa_hash_get_ppa
	str	w0, [x29, 144]
	cmn	w0, #1
	bne	.L3503
	mov	w2, 0
	add	x1, x29, 144
	mov	w0, w20
	bl	pm_log2phys
.L3503:
	ldr	w23, [x29, 144]
	cmp	w22, w23
	bne	.L3504
	adrp	x0, .LANCHOR52
	add	x0, x0, :lo12:.LANCHOR52
	add	x1, x0, 2
	add	x0, x0, 2050
.L3507:
	ldr	w2, [x1, 34]
	cmp	w20, w2
	bne	.L3505
	ldrb	w2, [x1]
	tbz	x2, 1, .L3505
	mov	x0, x19
	bl	zbuf_free
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L3499
	add	x21, x21, :lo12:.LANCHOR64
	adrp	x0, .LC238
	mov	w2, w22
	mov	w1, w20
	add	x0, x0, :lo12:.LC238
	ldrh	w3, [x21, 26]
	bl	printf
.L3499:
	ldp	x19, x20, [sp, 32]
	ldp	x21, x22, [sp, 48]
	ldp	x23, x24, [sp, 64]
	ldp	x25, x26, [sp, 80]
	ldp	x27, x28, [sp, 96]
	ldp	x29, x30, [sp, 16]
	add	sp, sp, 208
	ret
.L3505:
	add	x1, x1, 64
	cmp	x1, x0
	bne	.L3507
	adrp	x0, .LANCHOR126
	mov	w1, 10
	strb	wzr, [x19, 57]
	ldrb	w0, [x0, #:lo12:.LANCHOR126]
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
	tbz	x0, 8, .L3508
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
.L3508:
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
	b	.L3499
.L3504:
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L3509
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
.L3509:
	mov	x0, x19
	bl	zbuf_free
	b	.L3499
.L3500:
	adrp	x1, .LANCHOR10
	adrp	x0, .LANCHOR73
	stp	x0, x1, [x29, 112]
	adrp	x23, .LANCHOR64
	ldr	x21, [x1, #:lo12:.LANCHOR10]
	ldrb	w19, [x0, #:lo12:.LANCHOR73]
	add	x21, x21, 80
	cmp	w19, 3
	bne	.L3510
	adrp	x0, .LANCHOR35
	ldrb	w0, [x0, #:lo12:.LANCHOR35]
	cbz	w0, .L3511
	add	x0, x23, :lo12:.LANCHOR64
	ldrb	w20, [x21, 9]
	ldrh	w28, [x0, 570]
	adrp	x0, .LANCHOR118
	ldrb	w0, [x0, #:lo12:.LANCHOR118]
	sdiv	w1, w28, w20
	and	w27, w1, 65535
	cbz	w0, .L3512
	adrp	x0, .LANCHOR226
	add	x0, x0, :lo12:.LANCHOR226
	ldrh	w0, [x0, w1, sxtw 1]
	cmp	w0, 0
	cset	w19, ne
.L3631:
	add	w19, w19, 1
.L3513:
	msub	w20, w27, w20, w28
.L3632:
	and	w20, w20, 65535
.L3514:
	adrp	x1, .LANCHOR79
	ldrb	w0, [x21, 9]
	add	x5, x23, :lo12:.LANCHOR64
	adrp	x11, .LANCHOR226
	ldrh	w4, [x1, #:lo12:.LANCHOR79]
	add	x11, x11, :lo12:.LANCHOR226
	sxtw	x14, w27
	mov	w2, 0
	mul	w13, w19, w0
	ldrh	w15, [x5, 24]
	mul	w4, w4, w0
	adrp	x0, .LANCHOR118
	ldrb	w12, [x0, #:lo12:.LANCHOR118]
	adrp	x0, .LANCHOR158
	sub	w4, w4, #1
	ldr	x7, [x0, #:lo12:.LANCHOR158]
.L3518:
	cmp	w2, w13
	blt	.L3522
.L3567:
	mov	w22, 1
	b	.L3516
.L3512:
	adrp	x0, .LANCHOR207
	ldrb	w0, [x0, #:lo12:.LANCHOR207]
	cbz	w0, .L3561
	sub	w0, w27, #62
	and	w0, w0, 65535
	cmp	w0, 2159
	bhi	.L3562
	udiv	w19, w27, w19
	add	w19, w19, w19, lsl 1
	sub	w19, w27, w19
	and	w19, w19, 65535
	cmp	w19, 0
	cset	w19, eq
	b	.L3631
.L3561:
	mov	w19, 1
	b	.L3513
.L3562:
	mov	w19, 2
	b	.L3513
.L3511:
	adrp	x0, .LANCHOR77
	ldrb	w0, [x0, #:lo12:.LANCHOR77]
	cbz	w0, .L3515
	add	x0, x23, :lo12:.LANCHOR64
	ldrb	w20, [x21, 9]
	ldrh	w28, [x0, 570]
	add	w8, w20, w20, lsl 1
	sub	w20, w20, w20, lsl 2
	sdiv	w27, w28, w8
	madd	w20, w27, w20, w28
	b	.L3632
.L3515:
	add	x0, x23, :lo12:.LANCHOR64
	ldrb	w10, [x21, 9]
	ldrh	w1, [x0, 570]
	adrp	x0, .LANCHOR227
	add	x0, x0, :lo12:.LANCHOR227
	sdiv	w20, w1, w10
	ldrh	w22, [x0, w20, sxtw 1]
	msub	w20, w20, w10, w1
	and	w20, w20, 65535
	lsr	w27, w22, 3
	and	w22, w22, 7
	cmp	w22, 1
	madd	w10, w27, w10, w20
	add	w10, w10, w10, lsl 1
	and	w28, w10, 65535
	beq	.L3514
.L3516:
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L3523
	adrp	x0, .LANCHOR158
	ubfiz	x1, x28, 2, 16
	mov	w7, w28
	ldr	x2, [x0, #:lo12:.LANCHOR158]
	add	x0, x23, :lo12:.LANCHOR64
	add	x3, x2, x1
	ldrh	w4, [x0, 570]
	adrp	x0, .LANCHOR226
	add	x0, x0, :lo12:.LANCHOR226
	ldrh	w0, [x0, w27, sxtw 1]
	str	w0, [sp]
	adrp	x0, .LC240
	add	x0, x0, :lo12:.LC240
	ldr	w5, [x2, x1]
	mov	w2, w22
	ldr	w6, [x3, 4]
	mov	w1, w27
	mov	w3, w20
	bl	printf
.L3523:
	adrp	x0, .LANCHOR79
	str	wzr, [x29, 136]
	add	x0, x0, :lo12:.LANCHOR79
	str	x0, [x29, 104]
.L3524:
	ldrb	w2, [x21, 9]
	ldr	w0, [x29, 136]
	ldrh	w24, [x29, 136]
	and	w0, w0, 65535
	str	w0, [x29, 140]
	mul	w1, w19, w2
	cmp	w0, w1
	blt	.L3541
	ldr	x0, [x29, 112]
	ldrb	w0, [x0, #:lo12:.LANCHOR73]
	cmp	w0, 3
	add	x0, x29, 144
	bne	.L3542
	adrp	x3, .LANCHOR35
	ldrb	w3, [x3, #:lo12:.LANCHOR35]
	cbz	w3, .L3543
	sub	w3, w1, #1
	mov	w2, 0
.L3544:
	cmp	w2, w3
	blt	.L3545
.L3636:
	ldr	x0, [x0, w3, sxtw 3]
	mov	w2, -1
	strb	w2, [x0]
	ldr	x0, [x29, 144]
	bl	sblk_prog_page
	b	.L3546
.L3510:
	adrp	x0, .LANCHOR74
	ldrb	w0, [x0, #:lo12:.LANCHOR74]
	cbnz	w0, .L3517
	add	x0, x23, :lo12:.LANCHOR64
	ldrb	w20, [x21, 9]
	mov	w19, 1
	ldrh	w28, [x0, 570]
	sdiv	w27, w28, w20
	msub	w20, w27, w20, w28
	and	w20, w20, 65535
	b	.L3514
.L3517:
	add	x0, x23, :lo12:.LANCHOR64
	ldrb	w20, [x21, 9]
	mov	w19, 2
	ldrh	w28, [x0, 570]
	sdiv	w27, w28, w20
	msub	w20, w27, w20, w28
	and	w20, w20, 65535
	b	.L3514
.L3522:
	add	w3, w28, w2
	cmp	w3, w4
	bne	.L3519
	cbz	w12, .L3567
	ldrh	w0, [x11, x14, lsl 1]
	cmp	w0, w27
	bcs	.L3567
	tbz	x2, 0, .L3567
.L3519:
	sbfiz	x3, x3, 2, 32
	ldr	w0, [x7, x3]
	cmn	w0, #1
	bne	.L3520
	ldrh	w6, [x5, 26]
	cmp	w6, w15
	bcs	.L3499
	cbz	w12, .L3521
	ldrh	w0, [x11, x14, lsl 1]
	cmp	w0, w27
	bcs	.L3521
	tbz	x2, 0, .L3521
	ubfiz	x0, x0, 2, 16
	ldr	w0, [x7, x0]
.L3633:
	str	w0, [x7, x3]
.L3520:
	add	w2, w2, 1
	and	w2, w2, 65535
	b	.L3518
.L3521:
	mov	w0, w6
	bl	gc_get_src_ppa_from_index
	add	w6, w6, 1
	strh	w6, [x5, 26]
	b	.L3633
.L3541:
	ldr	w0, [x29, 140]
	add	w0, w28, w0
	str	w0, [x29, 128]
	sxtw	x26, w0
	adrp	x0, .LANCHOR76
	ldr	x0, [x0, #:lo12:.LANCHOR76]
	ldrb	w0, [x0, x26]
	cmp	w0, 255
	bne	.L3525
	mov	w0, 0
	bl	buf_alloc
	mov	x25, x0
	cbnz	x0, .L3526
	bl	sblk_wait_write_queue_completed
	bl	ftl_write_completed
	bl	gc_write_completed
	bl	gc_free_temp_buf
	mov	w0, 0
	bl	buf_alloc
	mov	x25, x0
	cbz	x0, .L3499
.L3526:
	adrp	x0, .LANCHOR76
	ldrb	w1, [x25, 1]
	adrp	x5, .LANCHOR158
	ldr	x0, [x0, #:lo12:.LANCHOR76]
	strb	w1, [x0, x26]
	add	x1, x23, :lo12:.LANCHOR64
	strb	w22, [x25, 61]
	ldrb	w0, [x1, 7]
	add	w0, w0, 1
	strb	w0, [x1, 7]
	add	w0, w24, w28
	strh	w0, [x25, 48]
	adrp	x0, .LANCHOR79
	ldr	w1, [x29, 128]
	ldrh	w6, [x0, #:lo12:.LANCHOR79]
	ldrb	w0, [x21, 9]
	mul	w0, w0, w6
	sub	w0, w0, #1
	cmp	w1, w0
	bne	.L3527
	adrp	x0, .LANCHOR118
	ldrb	w0, [x0, #:lo12:.LANCHOR118]
	cbz	w0, .L3528
	adrp	x0, .LANCHOR226
	add	x0, x0, :lo12:.LANCHOR226
	ldrh	w0, [x0, w27, sxtw 1]
	cmp	w0, w27
	bcs	.L3528
	tbnz	x24, 0, .L3527
.L3528:
	adrp	x0, .LANCHOR157
	adrp	x4, .LANCHOR80
	str	x5, [x29, 96]
	ldr	x1, [x0, #:lo12:.LANCHOR157]
	mov	w0, -1
	str	x4, [x29, 128]
	str	w0, [x1, x26, lsl 2]
	ldr	x0, [x25, 8]
	ldrb	w2, [x4, #:lo12:.LANCHOR80]
	mul	w2, w2, w6
	lsl	w2, w2, 2
	bl	ftl_memcpy
	ldp	x5, x0, [x29, 96]
	adrp	x6, .LANCHOR126
	ldr	x4, [x29, 128]
	ldrh	w0, [x0]
	ldrb	w1, [x4, #:lo12:.LANCHOR80]
	mul	w0, w0, w1
	adrp	x1, .LANCHOR207
	ldrb	w1, [x1, #:lo12:.LANCHOR207]
	lsl	w2, w0, 2
	cbz	w1, .L3529
	ldrb	w1, [x6, #:lo12:.LANCHOR126]
	lsl	w1, w1, 9
	sub	w2, w1, w2
.L3529:
	ldr	x1, [x5, #:lo12:.LANCHOR158]
	ldr	x7, [x25, 8]
	str	x4, [x29, 96]
	str	x6, [x29, 128]
	add	x0, x7, x0, sxtw 2
	bl	ftl_memcpy
	ldr	x6, [x29, 128]
	mov	w1, 0
	ldr	x0, [x25, 24]
	ldrb	w2, [x6, #:lo12:.LANCHOR126]
	lsl	w2, w2, 1
	bl	ftl_memset
	ldr	x6, [x25, 24]
	mov	w0, 15555
	movk	w0, 0xf55f, lsl 16
	ldr	x4, [x29, 96]
	str	w0, [x6]
	ldr	x0, [x29, 104]
	ldrh	w1, [x0]
	ldrb	w0, [x4, #:lo12:.LANCHOR80]
	mul	w1, w1, w0
	ldr	x0, [x25, 8]
	lsl	w1, w1, 2
	bl	js_hash
	str	w0, [x6, 4]
	ldr	x0, [x29, 120]
	ldr	x0, [x0, #:lo12:.LANCHOR10]
	ldr	w0, [x0, 132]
	str	w0, [x6, 8]
.L3525:
	adrp	x0, .LANCHOR76
	adrp	x11, .LANCHOR52
	add	x7, x11, :lo12:.LANCHOR52
	ldrsw	x2, [x29, 140]
	ldr	x3, [x0, #:lo12:.LANCHOR76]
	mov	w0, 2
	add	x1, x29, 144
	adrp	x6, .LANCHOR159
	ldrb	w5, [x3, x26]
	ubfiz	x4, x5, 6, 8
	add	x4, x7, x4
	add	x7, x7, x5, lsl 6
	str	x4, [x1, x2, lsl 3]
	adrp	x4, .LANCHOR118
	strh	w0, [x7, 50]
	ldr	x0, [x29, 112]
	strb	w22, [x7, 61]
	ldrb	w0, [x0, #:lo12:.LANCHOR73]
	cmp	w0, 3
	bne	.L3533
	adrp	x12, .LANCHOR35
	ldrb	w13, [x12, #:lo12:.LANCHOR35]
	adrp	x12, .LANCHOR105
	cbz	w13, .L3534
	ldrb	w0, [x4, #:lo12:.LANCHOR118]
	and	w14, w24, 1
	add	w13, w14, w27
	cbz	w0, .L3535
	adrp	x7, .LANCHOR226
	add	x7, x7, :lo12:.LANCHOR226
	ldrh	w0, [x7, w27, sxtw 1]
	cmp	w0, w27
	bcs	.L3535
	cmp	w14, 0
	csel	w13, w13, w0, eq
.L3535:
	udiv	w7, w24, w19
	add	x14, x11, :lo12:.LANCHOR52
	add	x14, x14, x5, lsl 6
	add	w7, w7, w20
	add	x7, x21, x7, sxtw 1
	ldrh	w0, [x7, 16]
	ldrh	w7, [x12, #:lo12:.LANCHOR105]
	madd	w0, w0, w7, w13
	orr	w0, w0, 50331648
	str	w0, [x14, 40]
.L3539:
	add	x0, x11, :lo12:.LANCHOR52
	add	x0, x0, x5, lsl 6
	ldrh	w5, [x0, 48]
	ldr	w7, [x0, 40]
	ldr	x0, [x6, #:lo12:.LANCHOR159]
	str	w7, [x0, x5, lsl 2]
	b	.L3537
.L3527:
	lsl	x0, x26, 2
	str	x0, [x29, 128]
	ldr	x0, [x5, #:lo12:.LANCHOR158]
	lsl	x1, x26, 2
	ldr	w0, [x0, x1]
	mov	w1, 1
	str	w0, [x25, 40]
	mov	x0, x25
	bl	sblk_read_page
	ldr	w0, [x25, 52]
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	bne	.L3531
	adrp	x0, .LANCHOR68
	ldrh	w2, [x0, #:lo12:.LANCHOR68]
	adrp	x0, .LANCHOR31
	ldrb	w1, [x0, #:lo12:.LANCHOR31]
	mov	w0, 24
	sub	w0, w0, w1
	sub	w1, w0, w2
	mov	w0, 1
	lsl	w0, w0, w1
	ldr	w1, [x25, 40]
	sub	w0, w0, #1
	lsr	w1, w1, w2
	and	w0, w0, w1
	adrp	x1, .LANCHOR69
	ldrb	w2, [x1, #:lo12:.LANCHOR69]
	mov	x1, 0
	udiv	w0, w0, w2
	bl	ftl_sblk_dump
	ldr	w0, [x25, 52]
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	bne	.L3531
	ldr	x0, [x25, 24]
	mov	w1, -1
	str	w1, [x0, 4]
	ldr	w0, [x25, 52]
	cmp	w0, 512
	ccmp	w0, w1, 4, ne
	bne	.L3531
	adrp	x1, .LANCHOR225
	adrp	x0, .LC0
	mov	w2, 1007
	add	x1, x1, :lo12:.LANCHOR225
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3531:
	ldr	x0, [x25, 24]
	adrp	x1, .LANCHOR123
	ldr	w1, [x1, #:lo12:.LANCHOR123]
	ldr	w2, [x0, 4]
	cmp	w2, w1
	bcc	.L3532
	mov	w1, -1
	str	w1, [x0, 4]
.L3532:
	adrp	x1, .LANCHOR157
	lsl	x3, x26, 2
	ldr	w2, [x0, 4]
	ldr	x1, [x1, #:lo12:.LANCHOR157]
	str	w2, [x1, x3]
	ldr	w1, [x25, 40]
	str	w1, [x0, 8]
	b	.L3525
.L3534:
	udiv	w0, w24, w0
	ldrh	w11, [x12, #:lo12:.LANCHOR105]
	ldr	x6, [x6, #:lo12:.LANCHOR159]
	add	w5, w0, w20
	add	w0, w0, w0, lsl 1
	add	x5, x21, x5, sxtw 1
	sub	w0, w24, w0
	and	w0, w0, 65535
	add	w0, w0, 1
	ldrh	w5, [x5, 16]
	mul	w5, w5, w11
	orr	w5, w5, w27
	str	w5, [x7, 40]
	ldrh	w7, [x7, 48]
	orr	w0, w5, w0, lsl 24
	str	w0, [x6, x7, lsl 2]
.L3537:
	ldrb	w0, [x4, #:lo12:.LANCHOR118]
	cbz	w0, .L3540
	adrp	x0, .LANCHOR226
	add	x0, x0, :lo12:.LANCHOR226
	ldrh	w0, [x0, w27, sxtw 1]
	cmp	w0, w27
	bcs	.L3540
	tbz	x24, 0, .L3540
	mov	w0, -1
	strb	w0, [x3, x26]
	ldrb	w0, [x21, 9]
	ldr	x1, [x1, x2, lsl 3]
	ubfiz	w0, w0, 1, 15
	ldrb	w2, [x1, 1]
	msub	w0, w19, w0, w28
	and	w0, w0, 65535
	strh	w0, [x1, 48]
	adrp	x1, .LANCHOR76
	and	x0, x0, 65535
	ldr	x1, [x1, #:lo12:.LANCHOR76]
	strb	w2, [x1, x0]
	adrp	x0, .LANCHOR158
	mov	w1, -1
	ldr	x0, [x0, #:lo12:.LANCHOR158]
	str	w1, [x0, x26, lsl 2]
.L3540:
	ldr	w0, [x29, 136]
	add	w0, w0, 1
	str	w0, [x29, 136]
	b	.L3524
.L3533:
	cmp	w0, 2
	bne	.L3539
	adrp	x0, .LANCHOR74
	adrp	x12, .LANCHOR105
	ldrb	w0, [x0, #:lo12:.LANCHOR74]
	cbnz	w0, .L3538
	ldr	w0, [x29, 140]
	ldrh	w12, [x12, #:lo12:.LANCHOR105]
	add	w25, w20, w0
	add	x25, x21, x25, sxtw 1
	ldrh	w0, [x25, 16]
	madd	w0, w0, w12, w27
.L3634:
	orr	w0, w0, 33554432
	str	w0, [x7, 40]
	b	.L3539
.L3538:
	add	w0, w20, w24, lsr 1
	ldrh	w12, [x12, #:lo12:.LANCHOR105]
	add	x0, x21, x0, sxtw 1
	ldrh	w0, [x0, 16]
	madd	w0, w0, w12, w27
	and	w12, w24, 1
	add	w0, w0, w12
	b	.L3634
.L3545:
	ldr	x4, [x0, w2, sxtw 3]
	add	w2, w2, 1
	ldr	x5, [x0, w2, sxtw 3]
	and	w2, w2, 65535
	ldrb	w5, [x5, 1]
	strb	w5, [x4]
	b	.L3544
.L3543:
	adrp	x1, .LANCHOR77
	ldrb	w3, [x1, #:lo12:.LANCHOR77]
	ldr	x1, [x29, 144]
	cbz	w3, .L3547
.L3550:
	strb	wzr, [x1, 60]
	b	.L3549
.L3547:
	cmp	w22, 1
	bne	.L3548
	mov	w3, 9
.L3635:
	strb	w3, [x1, 60]
.L3549:
	add	x1, x0, 24
	bl	sblk_xlc_prog_pages
.L3546:
	adrp	x0, .LANCHOR77
	ldrb	w0, [x0, #:lo12:.LANCHOR77]
	cbz	w0, .L3555
	ldrb	w19, [x21, 9]
	add	w19, w19, w19, lsl 1
	and	w19, w19, 1023
.L3556:
	adrp	x0, .LANCHOR104
	add	x23, x23, :lo12:.LANCHOR64
	ldr	x1, [x0, #:lo12:.LANCHOR104]
	ldr	w0, [x1, 52]
	add	w0, w0, w19
	str	w0, [x1, 52]
	ldrh	w0, [x23, 570]
	add	w19, w19, w0
	adrp	x0, .LANCHOR79
	and	w19, w19, 65535
	strh	w19, [x23, 570]
	ldrh	w0, [x0, #:lo12:.LANCHOR79]
	ldrb	w1, [x21, 9]
	mul	w0, w0, w1
	cmp	w19, w0
	blt	.L3559
	ldr	x0, [x29, 120]
	ldr	x0, [x0, #:lo12:.LANCHOR10]
	strh	wzr, [x0, 86]
.L3559:
	bl	gc_write_completed
	b	.L3499
.L3548:
	cmp	w22, 2
	bne	.L3550
	mov	w3, 13
	b	.L3635
.L3542:
	adrp	x3, .LANCHOR74
	ldrb	w3, [x3, #:lo12:.LANCHOR74]
	cbz	w3, .L3568
	adrp	x3, .LANCHOR75
	ldrb	w3, [x3, #:lo12:.LANCHOR75]
	cbnz	w3, .L3552
.L3568:
	sub	w3, w1, #1
	mov	w2, 0
.L3553:
	cmp	w2, w3
	bge	.L3636
	ldr	x4, [x0, w2, sxtw 3]
	add	w2, w2, 1
	ldr	x5, [x0, w2, sxtw 3]
	and	w2, w2, 65535
	ldrb	w5, [x5, 1]
	strb	w5, [x4]
	b	.L3553
.L3552:
	mov	w1, w2
	bl	sblk_3d_mlc_prog_pages
	b	.L3546
.L3555:
	adrp	x0, .LANCHOR74
	ldrb	w0, [x0, #:lo12:.LANCHOR74]
	cbz	w0, .L3557
	ldrb	w19, [x21, 9]
	ubfiz	w19, w19, 1, 8
	b	.L3556
.L3557:
	adrp	x0, .LANCHOR35
	ldrb	w0, [x0, #:lo12:.LANCHOR35]
	cbz	w0, .L3558
	adrp	x0, .LANCHOR118
	ldrb	w1, [x21, 9]
	ldrb	w0, [x0, #:lo12:.LANCHOR118]
	mul	w19, w1, w19
	cbz	w0, .L3556
	adrp	x0, .LANCHOR226
	add	x0, x0, :lo12:.LANCHOR226
	ldrh	w0, [x0, w27, sxtw 1]
	cmp	w0, w27
	csel	w19, w19, w1, cs
	b	.L3556
.L3558:
	ldrb	w19, [x21, 9]
	b	.L3556
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
	adrp	x19, .LANCHOR155
	stp	x21, x22, [sp, 48]
	ldrh	w22, [x1, #:lo12:.LANCHOR101]
	adrp	x1, .LANCHOR97
	stp	x23, x24, [sp, 64]
	adrp	x23, .LANCHOR10
	ldrh	w21, [x1, #:lo12:.LANCHOR97]
	stp	x25, x26, [sp, 80]
	ldrb	w1, [x19, #:lo12:.LANCHOR155]
	add	w21, w22, w21
	stp	x27, x28, [sp, 96]
	ldr	x20, [x23, #:lo12:.LANCHOR10]
	cmp	w1, 6
	bhi	.L3747
	mov	w25, w0
	and	w21, w21, 65535
	adrp	x0, .L3640
	add	x0, x0, :lo12:.L3640
	ldrh	w0, [x0,w1,uxtw #1]
	adr	x1, .Lrtx3640
	add	x0, x1, w0, sxth #2
	br	x0
.Lrtx3640:
	.section	.rodata.zftl_do_gc,"a",@progbits
	.align	0
	.align	2
.L3640:
	.2byte	(.L3639 - .Lrtx3640) / 4
	.2byte	(.L3641 - .Lrtx3640) / 4
	.2byte	(.L3642 - .Lrtx3640) / 4
	.2byte	(.L3643 - .Lrtx3640) / 4
	.2byte	(.L3644 - .Lrtx3640) / 4
	.2byte	(.L3645 - .Lrtx3640) / 4
	.2byte	(.L3646 - .Lrtx3640) / 4
	.section	.text.zftl_do_gc
.L3645:
	adrp	x20, .LANCHOR64
	add	x24, x20, :lo12:.LANCHOR64
	mov	w22, 0
.L3647:
	bl	gc_check_data_one_wl
	cbz	w0, .L3743
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
	strb	wzr, [x19, #:lo12:.LANCHOR155]
	str	xzr, [x20, 8]
	b	.L3817
.L3639:
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
	beq	.L3648
	cbnz	w25, .L3649
	adrp	x0, .LANCHOR81
	ldrh	w0, [x0, #:lo12:.LANCHOR81]
	cmp	w21, w0, lsl 1
	blt	.L3649
.L3747:
	mov	w20, 16
	b	.L3637
.L3649:
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
	beq	.L3650
	adrp	x4, .LANCHOR9
	ubfiz	x3, x3, 1, 16
	adrp	x1, .LANCHOR156
	mov	x26, x1
	ldr	x4, [x4, #:lo12:.LANCHOR9]
	ldr	w2, [x1, #:lo12:.LANCHOR156]
	add	w2, w2, 1
	str	w2, [x1, #:lo12:.LANCHOR156]
	ldrh	w3, [x4, x3]
	adrp	x4, .LANCHOR87
	ldrh	w4, [x4, #:lo12:.LANCHOR87]
	cmp	w4, w3
	bcs	.L3651
	adrp	x1, .LANCHOR6
	ldrh	w1, [x1, #:lo12:.LANCHOR6]
	cmp	w2, w1, lsr 4
	bls	.L3650
	adrp	x1, .LANCHOR93
	ldrh	w1, [x1, #:lo12:.LANCHOR93]
	cmp	w1, w3
	bls	.L3650
.L3651:
	ldrb	w2, [x25, #:lo12:.LANCHOR78]
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L3652
	mov	w0, 1
	str	wzr, [x26, #:lo12:.LANCHOR156]
	strb	w0, [x19, #:lo12:.LANCHOR155]
	b	.L3747
.L3650:
	strh	wzr, [x5, #:lo12:.LANCHOR89]
.L3652:
	cmp	w22, 15
	bls	.L3749
	adrp	x0, .LANCHOR94
	ldrh	w1, [x0, #:lo12:.LANCHOR94]
	adrp	x0, .LANCHOR95
	ldrh	w0, [x0, #:lo12:.LANCHOR95]
	cmp	w1, w0
	bhi	.L3749
	cmp	w24, 0
	cset	w24, eq
	add	w24, w24, 1
.L3653:
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L3654
	ldr	x0, [x23, #:lo12:.LANCHOR10]
	mov	w4, w22
	ldrb	w2, [x25, #:lo12:.LANCHOR78]
	mov	w3, w21
	mov	w1, 2175
	ldrh	w7, [x0, 122]
	ldrh	w6, [x0, 120]
	ldrh	w5, [x0, 124]
	ldrh	w0, [x20, 80]
	str	w0, [sp]
	adrp	x0, .LC241
	add	x0, x0, :lo12:.LC241
	bl	printf
.L3654:
	ldrb	w0, [x25, #:lo12:.LANCHOR78]
	mov	w2, 1
	mov	w1, w24
	bl	gc_search_src_blk
	cmp	w0, 0
	ble	.L3655
.L3656:
	mov	w0, 1
.L3819:
	strb	w0, [x19, #:lo12:.LANCHOR155]
	b	.L3747
.L3749:
	mov	w24, 2
	b	.L3653
.L3655:
	ldrb	w0, [x25, #:lo12:.LANCHOR78]
	mov	w2, 1
	mov	w1, 3
	bl	gc_search_src_blk
	cmp	w0, 0
	bgt	.L3656
	b	.L3747
.L3648:
	adrp	x28, .LANCHOR14
	ldr	w0, [x28, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L3658
	adrp	x0, .LANCHOR78
	ldrh	w7, [x20, 122]
	ldrh	w6, [x20, 120]
	mov	w4, w22
	ldrh	w5, [x20, 124]
	mov	w3, w21
	ldrb	w2, [x0, #:lo12:.LANCHOR78]
	mov	w1, 2187
	str	w25, [sp]
	adrp	x0, .LC241
	add	x0, x0, :lo12:.LC241
	bl	printf
.L3658:
	cmp	w25, 1
	bne	.L3659
	bl	gc_scan_static_data
	adrp	x26, .LANCHOR78
	ldr	x0, [x23, #:lo12:.LANCHOR10]
	ldrh	w0, [x0, 122]
	cbz	w0, .L3660
.L3661:
	mov	w0, 1
	strb	w0, [x26, #:lo12:.LANCHOR78]
	b	.L3819
.L3660:
	bl	gc_static_wearleveling
	mov	w20, w0
	cbnz	w0, .L3661
	cbnz	w22, .L3662
.L3666:
	mov	w20, 16
.L3663:
	ldr	x0, [x23, #:lo12:.LANCHOR10]
	adrp	x3, .LANCHOR78
	mov	w1, 1
	mov	x23, x3
	strb	w1, [x3, #:lo12:.LANCHOR78]
	ldrh	w5, [x0, 124]
	cbz	w5, .L3671
	strb	w1, [x19, #:lo12:.LANCHOR155]
	ldr	w1, [x28, #:lo12:.LANCHOR14]
	strb	wzr, [x3, #:lo12:.LANCHOR78]
	tbz	x1, 8, .L3637
	ldrh	w7, [x0, 122]
	mov	w4, w22
	ldrh	w6, [x0, 120]
	mov	w3, w21
	adrp	x0, .LC242
	mov	w2, 0
	mov	w1, 2277
	add	x0, x0, :lo12:.LC242
	bl	printf
.L3637:
	mov	w0, w20
	ldp	x19, x20, [sp, 32]
	ldp	x21, x22, [sp, 48]
	ldp	x23, x24, [sp, 64]
	ldp	x25, x26, [sp, 80]
	ldp	x27, x28, [sp, 96]
	ldp	x29, x30, [sp, 16]
	add	sp, sp, 128
	ret
.L3662:
	cmp	w21, w24
	adrp	x1, .LANCHOR94
	adrp	x2, .LANCHOR91
	bcs	.L3664
	ldrh	w0, [x2, #:lo12:.LANCHOR91]
	cmp	w0, w21
	bhi	.L3665
.L3664:
	ldrh	w2, [x2, #:lo12:.LANCHOR91]
	add	w0, w21, w24
	cmp	w0, w2
	blt	.L3665
	adrp	x0, .LANCHOR95
	ldrh	w2, [x1, #:lo12:.LANCHOR94]
	ldrh	w0, [x0, #:lo12:.LANCHOR95]
	cmp	w2, w0
	bcc	.L3666
.L3665:
	adrp	x5, .LANCHOR156
	adrp	x2, .LANCHOR6
	mov	w6, 1
	strb	w6, [x26, #:lo12:.LANCHOR78]
	ldr	w0, [x5, #:lo12:.LANCHOR156]
	ldrh	w2, [x2, #:lo12:.LANCHOR6]
	add	w0, w0, 1
	str	w0, [x5, #:lo12:.LANCHOR156]
	cmp	w0, w2, lsr 5
	bls	.L3667
	ldrh	w0, [x1, #:lo12:.LANCHOR94]
	cmp	w0, w22
	bls	.L3667
	mov	w1, 5
	mov	w0, 0
	bl	zftl_get_gc_node
	and	w0, w0, 65535
	mov	w1, 65535
	cmp	w0, w1
	beq	.L3666
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
	bgt	.L3666
	mov	w0, w6
	str	wzr, [x5, #:lo12:.LANCHOR156]
	mov	w2, 4
	mov	w1, 2
.L3807:
	bl	gc_search_src_blk
	and	w0, w0, 65535
	cbz	w0, .L3666
	b	.L3656
.L3667:
	adrp	x0, .LANCHOR95
	ldrh	w1, [x1, #:lo12:.LANCHOR94]
	ldrh	w0, [x0, #:lo12:.LANCHOR95]
	cmp	w1, w0
	bcc	.L3669
	mov	w2, 1
	mov	w1, 2
	mov	w0, w2
	b	.L3807
.L3669:
	ldrh	w0, [x27, #:lo12:.LANCHOR92]
	cbnz	w0, .L3670
	ldr	x0, [x29, 104]
	ldrh	w0, [x0, #:lo12:.LANCHOR90]
	cmp	w0, 8
	bls	.L3663
.L3670:
	mov	w1, 1
	mov	w2, 4
	mov	w0, w1
	b	.L3807
.L3659:
	adrp	x0, .LANCHOR81
	ldrh	w0, [x0, #:lo12:.LANCHOR81]
	cmp	w0, w21
	bcc	.L3747
	b	.L3666
.L3671:
	adrp	x2, .LANCHOR81
	mov	x26, x2
	ldrh	w4, [x2, #:lo12:.LANCHOR81]
	cmp	w21, w4
	bcs	.L3672
	cbz	w22, .L3673
	cmp	w22, 16
	bls	.L3674
	adrp	x0, .LANCHOR94
	ldrh	w2, [x0, #:lo12:.LANCHOR94]
	adrp	x0, .LANCHOR95
	ldrh	w0, [x0, #:lo12:.LANCHOR95]
	cmp	w2, w0
	bhi	.L3674
	str	x3, [x29, 104]
	mov	w2, 4
	mov	w0, w1
	bl	gc_search_src_blk
	ldr	x3, [x29, 104]
	tst	w0, 65535
	bne	.L3675
	ldrb	w0, [x3, #:lo12:.LANCHOR78]
	mov	w2, 4
	mov	w1, 3
.L3809:
	bl	gc_search_src_blk
	and	w0, w0, 65535
.L3676:
	cbnz	w0, .L3678
	b	.L3637
.L3675:
	mov	w1, 5
	mov	w0, 0
	bl	zftl_get_gc_node
	and	w3, w0, 65535
	mov	w1, 65535
	cmp	w3, w1
	beq	.L3678
	adrp	x4, .LANCHOR9
	ubfiz	x3, x3, 1, 16
	adrp	x1, .LANCHOR156
	mov	x21, x1
	ldr	x4, [x4, #:lo12:.LANCHOR9]
	ldr	w2, [x1, #:lo12:.LANCHOR156]
	add	w2, w2, 1
	str	w2, [x1, #:lo12:.LANCHOR156]
	ldrh	w3, [x4, x3]
	adrp	x4, .LANCHOR87
	ldrh	w4, [x4, #:lo12:.LANCHOR87]
	cmp	w4, w3
	bcs	.L3679
	adrp	x1, .LANCHOR6
	ldrh	w1, [x1, #:lo12:.LANCHOR6]
	cmp	w2, w1, lsr 4
	bls	.L3678
	adrp	x1, .LANCHOR93
	ldrh	w1, [x1, #:lo12:.LANCHOR93]
	cmp	w1, w3
	bls	.L3678
.L3679:
	ldrb	w2, [x23, #:lo12:.LANCHOR78]
	mov	w1, 0
	bl	gc_add_sblk
	str	wzr, [x21, #:lo12:.LANCHOR156]
	adrp	x0, .LANCHOR116
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR116]
.L3678:
	mov	w0, 1
	strb	w0, [x19, #:lo12:.LANCHOR155]
	b	.L3637
.L3674:
	mov	w2, 1
	mov	w0, w2
	mov	w1, 2
.L3816:
	bl	gc_search_src_blk
	tst	w0, 65535
	bne	.L3678
	mov	w2, 2
.L3812:
	mov	w1, 3
	ldrb	w0, [x23, #:lo12:.LANCHOR78]
	b	.L3809
.L3673:
	ldr	w1, [x28, #:lo12:.LANCHOR14]
	strb	wzr, [x3, #:lo12:.LANCHOR78]
	tbz	x1, 8, .L3681
	ldrh	w7, [x0, 122]
	mov	w5, 0
	ldrh	w6, [x0, 120]
	mov	w4, 0
	adrp	x0, .LC242
	mov	w3, w21
	mov	w2, 0
	mov	w1, 2307
	add	x0, x0, :lo12:.LC242
	bl	printf
.L3681:
	cmp	w21, 16
	bls	.L3682
	mov	w2, 4
	b	.L3812
.L3682:
	mov	w2, 1
	ldrb	w0, [x23, #:lo12:.LANCHOR78]
	mov	w1, w2
	b	.L3816
.L3672:
	cmp	w25, 1
	bne	.L3637
	cmp	w21, w4, lsl 1
	bge	.L3683
	cmp	w24, w22, lsr 1
	bcs	.L3684
	adrp	x0, .LANCHOR94
	ldrh	w1, [x0, #:lo12:.LANCHOR94]
	adrp	x0, .LANCHOR95
	ldrh	w0, [x0, #:lo12:.LANCHOR95]
	cmp	w1, w0
	bcs	.L3684
	adrp	x0, .LANCHOR91
	ldrh	w0, [x0, #:lo12:.LANCHOR91]
	lsr	w0, w0, 2
	strh	w0, [x2, #:lo12:.LANCHOR81]
	b	.L3637
.L3684:
	mov	w1, 5
	mov	w0, 0
	bl	zftl_get_gc_node
	and	w25, w0, 65535
	mov	w1, 65535
	mov	w28, w25
	cmp	w25, w1
	bne	.L3685
.L3690:
	cmp	w22, 1
	bhi	.L3686
.L3687:
	cmp	w21, w24
	adrp	x21, .LANCHOR91
	bcs	.L3694
	strb	wzr, [x23, #:lo12:.LANCHOR78]
	mov	w0, 4
	bl	zftl_get_gc_node.part.9
	and	w0, w0, 65535
	mov	w1, 65535
	cmp	w0, w1
	beq	.L3694
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
	ble	.L3696
.L3694:
	ldrh	w0, [x21, #:lo12:.LANCHOR91]
	lsr	w0, w0, 2
	strh	w0, [x26, #:lo12:.LANCHOR81]
	b	.L3637
.L3685:
	adrp	x2, .LANCHOR156
	adrp	x3, .LANCHOR6
	uxtw	x25, w25
	ldr	w1, [x2, #:lo12:.LANCHOR156]
	ldrh	w3, [x3, #:lo12:.LANCHOR6]
	add	w1, w1, 1
	str	w1, [x2, #:lo12:.LANCHOR156]
	cmp	w1, w3, lsr 4
	adrp	x3, .LANCHOR9
	bls	.L3688
	ldr	x1, [x3, #:lo12:.LANCHOR9]
	str	wzr, [x2, #:lo12:.LANCHOR156]
	ldrh	w2, [x1, x25, lsl 1]
	adrp	x1, .LANCHOR93
	ldrh	w1, [x1, #:lo12:.LANCHOR93]
	cmp	w2, w1
	bcs	.L3688
	str	x3, [x29, 96]
	mov	w2, 1
	mov	w1, 0
	bl	gc_add_sblk
	ldr	x3, [x29, 96]
	cbnz	w0, .L3678
.L3688:
	ldr	x0, [x3, #:lo12:.LANCHOR9]
	ldrh	w1, [x0, x25, lsl 1]
	adrp	x0, .LANCHOR87
	ldrh	w0, [x0, #:lo12:.LANCHOR87]
	cmp	w1, w0, lsr 1
	bhi	.L3689
	mov	w2, 0
	mov	w1, 1
	mov	w0, w28
	bl	gc_add_sblk
	b	.L3678
.L3689:
	ldr	x2, [x29, 104]
	ldrh	w0, [x27, #:lo12:.LANCHOR92]
	ldrh	w2, [x2, #:lo12:.LANCHOR90]
	add	w0, w0, w2
	adrp	x2, .LANCHOR91
	ldrh	w2, [x2, #:lo12:.LANCHOR91]
	cmp	w0, w2, lsl 1
	ble	.L3690
	adrp	x0, .LANCHOR93
	ldrh	w0, [x0, #:lo12:.LANCHOR93]
	cmp	w0, w1
	bcc	.L3687
	b	.L3690
.L3686:
	mov	w1, 1
	strb	w1, [x23, #:lo12:.LANCHOR78]
	cmp	w22, 16
	bls	.L3691
	adrp	x0, .LANCHOR94
	ldrh	w2, [x0, #:lo12:.LANCHOR94]
	adrp	x0, .LANCHOR95
	ldrh	w0, [x0, #:lo12:.LANCHOR95]
	cmp	w2, w0
	bhi	.L3691
	mov	w2, 4
	mov	w0, w1
	bl	gc_search_src_blk
	ands	w0, w0, 65535
	bne	.L3692
	mov	w2, 4
.L3808:
	ldrb	w0, [x23, #:lo12:.LANCHOR78]
	mov	w1, 3
	bl	gc_search_src_blk
	and	w0, w0, 65535
.L3692:
	adrp	x1, .LANCHOR91
	cmp	w21, w24, lsr 1
	ldrh	w1, [x1, #:lo12:.LANCHOR91]
	bls	.L3810
	lsr	w1, w1, 2
.L3811:
	strh	w1, [x26, #:lo12:.LANCHOR81]
	b	.L3676
.L3691:
	mov	w2, 1
	mov	w1, 2
	mov	w0, w2
	bl	gc_search_src_blk
	ands	w0, w0, 65535
	bne	.L3692
	mov	w2, 2
	b	.L3808
.L3696:
	mov	w1, 3
	mov	w2, 4
	mov	w0, 0
	bl	gc_search_src_blk
	ldrh	w1, [x21, #:lo12:.LANCHOR91]
	and	w0, w0, 65535
.L3810:
	lsr	w1, w1, 1
	b	.L3811
.L3683:
	adrp	x0, .LANCHOR91
	mov	w20, 0
	ldrh	w0, [x0, #:lo12:.LANCHOR91]
	lsr	w0, w0, 2
	strh	w0, [x2, #:lo12:.LANCHOR81]
	b	.L3637
.L3641:
	adrp	x7, .LANCHOR64
	mov	w0, 65535
	ldrh	w1, [x7, #:lo12:.LANCHOR64]
	cmp	w1, w0
	bne	.L3697
	bl	gc_get_src_blk
	strh	w0, [x7, #:lo12:.LANCHOR64]
.L3697:
	ldrh	w0, [x7, #:lo12:.LANCHOR64]
	mov	w1, 65535
	cmp	w0, w1
	beq	.L3698
	adrp	x1, .LANCHOR6
	ldrh	w1, [x1, #:lo12:.LANCHOR6]
	cmp	w1, w0
	bhi	.L3698
	mov	w0, -1
	strh	w0, [x7, #:lo12:.LANCHOR64]
.L3698:
	ldrh	w3, [x7, #:lo12:.LANCHOR64]
	mov	w0, 65535
	add	x1, x7, :lo12:.LANCHOR64
	cmp	w3, w0
	beq	.L3818
	adrp	x0, .LANCHOR7
	ldrh	w5, [x1, 56]
	uxtw	x4, w3
	ldr	x2, [x0, #:lo12:.LANCHOR7]
	add	x2, x2, x4, lsl 2
	cbz	w5, .L3700
	add	x1, x1, 58
	mov	w0, 0
.L3702:
	ldrh	w6, [x1], 2
	cmp	w6, w3
	bne	.L3701
.L3706:
	adrp	x0, .LANCHOR64
	mov	w1, -1
	strh	w1, [x0, #:lo12:.LANCHOR64]
	b	.L3747
.L3701:
	add	w0, w0, 1
	and	w0, w0, 65535
	cmp	w5, w0
	bne	.L3702
.L3700:
	ldrb	w0, [x2, 2]
	and	w1, w0, 224
	cmp	w1, 224
	beq	.L3703
	tst	w0, 192
	bne	.L3704
.L3703:
	adrp	x0, .LANCHOR9
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrh	w0, [x0, x4, lsl 1]
	cbz	w0, .L3706
	mov	w2, 2542
	adrp	x1, .LANCHOR228
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR228
	add	x0, x0, :lo12:.LC0
	bl	printf
	b	.L3706
.L3704:
	mov	w0, 2
	b	.L3819
.L3642:
	bl	gc_scan_src_blk
	cmn	w0, #1
	bne	.L3707
	mov	w0, 3
	b	.L3819
.L3707:
	adrp	x20, .LANCHOR64
	mov	w2, 65535
	add	x0, x20, :lo12:.LANCHOR64
	ldrh	w1, [x20, #:lo12:.LANCHOR64]
	cmp	w1, w2
	beq	.L3656
	ldrh	w2, [x0, 24]
	cbz	w2, .L3708
	mov	w1, 4
	strh	wzr, [x0, 26]
	strb	w1, [x19, #:lo12:.LANCHOR155]
	b	.L3747
.L3708:
	mov	w0, 1
	strb	w0, [x19, #:lo12:.LANCHOR155]
	adrp	x0, .LANCHOR9
	ubfiz	x1, x1, 1, 16
	mov	x19, x0
	ldr	x2, [x0, #:lo12:.LANCHOR9]
	ldrh	w1, [x2, x1]
	cbz	w1, .L3709
	adrp	x1, .LANCHOR228
	adrp	x0, .LC0
	mov	w2, 2570
	add	x1, x1, :lo12:.LANCHOR228
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3709:
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
	bhi	.L3710
	strh	w0, [x21, 30]
	b	.L3706
.L3710:
	strh	wzr, [x21, 30]
	bl	ftl_flush
	bl	pm_flush
	bl	ftl_ext_info_flush
	mov	w0, 0
	bl	ftl_info_flush
	b	.L3706
.L3643:
	adrp	x20, .LANCHOR64
	adrp	x23, .LANCHOR87
	add	x22, x20, :lo12:.LANCHOR64
	add	x23, x23, :lo12:.LANCHOR87
.L3786:
	bl	gc_scan_src_blk_one_page
	ldrh	w1, [x22, 2]
	ldrh	w0, [x23]
	cmp	w1, w0
	bcs	.L3712
	cmp	w21, 7
	bls	.L3786
	b	.L3747
.L3712:
	ldrh	w3, [x22, 24]
	adrp	x0, .LANCHOR14
	cbz	w3, .L3713
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	mov	w1, 4
	strh	wzr, [x22, 26]
	strb	w1, [x19, #:lo12:.LANCHOR155]
	adrp	x19, .LANCHOR9
	tbz	x0, 8, .L3714
	ldrh	w1, [x22]
	ldr	x2, [x19, #:lo12:.LANCHOR9]
	ubfiz	x0, x1, 1, 16
	ldrh	w2, [x2, x0]
	adrp	x0, .LC243
	add	x0, x0, :lo12:.LC243
	bl	printf
.L3714:
	ldrh	w2, [x20, #:lo12:.LANCHOR64]
	add	x0, x20, :lo12:.LANCHOR64
	ldr	x1, [x19, #:lo12:.LANCHOR9]
	ldrh	w0, [x0, 24]
	ldrh	w1, [x1, x2, lsl 1]
	cmp	w1, w0
	beq	.L3715
	adrp	x1, .LANCHOR228
	adrp	x0, .LC0
	mov	w2, 2604
	add	x1, x1, :lo12:.LANCHOR228
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3715:
	add	x0, x20, :lo12:.LANCHOR64
	ldrh	w1, [x20, #:lo12:.LANCHOR64]
	ldrh	w2, [x0, 24]
	ldr	x0, [x19, #:lo12:.LANCHOR9]
	strh	w2, [x0, x1, lsl 1]
	b	.L3747
.L3713:
	adrp	x2, .LANCHOR7
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	ldrh	w1, [x22]
	ldr	x21, [x2, #:lo12:.LANCHOR7]
	mov	w2, 1
	strb	w2, [x19, #:lo12:.LANCHOR155]
	add	x21, x21, x1, uxth 2
	tbz	x0, 8, .L3716
	ldrb	w2, [x21, 2]
	adrp	x0, .LC244
	add	x0, x0, :lo12:.LC244
	ubfx	x2, x2, 5, 3
	bl	printf
.L3716:
	ldrb	w0, [x21, 2]
	and	w1, w0, 224
	cmp	w1, 224
	beq	.L3717
	tst	w0, 192
	bne	.L3718
.L3717:
	adrp	x1, .LANCHOR228
	adrp	x0, .LC0
	mov	w2, 2614
	add	x1, x1, :lo12:.LANCHOR228
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3718:
	ldrh	w0, [x20, #:lo12:.LANCHOR64]
	add	x19, x20, :lo12:.LANCHOR64
	bl	ftl_free_sblk
	mov	w0, -1
	strh	w0, [x20, #:lo12:.LANCHOR64]
	ldrh	w0, [x19, 30]
	add	w0, w0, 1
	and	w0, w0, 65535
	cmp	w0, 8
	bhi	.L3719
	strh	w0, [x19, 30]
	b	.L3747
.L3719:
	strh	wzr, [x19, 30]
.L3817:
	bl	flt_sys_flush
	b	.L3747
.L3644:
	ldrh	w1, [x20, 80]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L3720
	adrp	x0, .LANCHOR78
	ldrb	w22, [x0, #:lo12:.LANCHOR78]
	cmp	w22, 1
	bne	.L3720
	bl	ftl_flush
	adrp	x0, .LANCHOR64
	add	x1, x0, :lo12:.LANCHOR64
	mov	x21, x0
	ldrh	w1, [x1, 574]
	cbz	w1, .L3721
	mov	w0, w22
	mov	w1, 5
.L3814:
	bl	zftl_gc_get_free_sblk
	and	w19, w0, 65535
	mov	w0, 65535
	cmp	w19, w0
	beq	.L3723
	adrp	x0, .LANCHOR7
	ldr	x22, [x0, #:lo12:.LANCHOR7]
	add	x22, x22, x19, uxth 2
	ldrb	w0, [x22, 2]
	tst	w0, 224
	beq	.L3724
	adrp	x1, .LANCHOR228
	adrp	x0, .LC0
	mov	w2, 2643
	add	x1, x1, :lo12:.LANCHOR228
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3724:
	ldrb	w0, [x22, 2]
	mov	w1, 5
	bfi	w0, w1, 5, 3
	orr	w0, w0, 16
	strb	w0, [x22, 2]
.L3746:
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
	adrp	x0, .LANCHOR157
	ldr	x0, [x0, #:lo12:.LANCHOR157]
	lsl	w2, w2, 2
	bl	ftl_memset
	ldrb	w0, [x20, #:lo12:.LANCHOR80]
	mov	w1, 255
	ldrh	w2, [x22, #:lo12:.LANCHOR79]
	mul	w2, w2, w0
	adrp	x0, .LANCHOR158
	ldr	x0, [x0, #:lo12:.LANCHOR158]
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
	b	.L3747
.L3721:
	mov	w1, 5
	mov	w0, 0
	b	.L3814
.L3720:
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
.L3727:
	sub	w22, w22, #1
	and	w22, w22, 255
	cmp	w22, 255
	beq	.L3747
	bl	gc_do_copy_back
	ldrb	w0, [x25]
	cbnz	w0, .L3728
	adrp	x0, .LANCHOR54
	ldrb	w0, [x0, #:lo12:.LANCHOR54]
	cmp	w0, 3
	bhi	.L3729
	bl	ftl_write_commit
.L3729:
	ldrh	w1, [x21, 26]
	ldrh	w0, [x21, 24]
	cmp	w1, w0
	bcc	.L3727
	mov	w0, 1
	strb	w0, [x19, #:lo12:.LANCHOR155]
	bl	ftl_write_commit
	bl	ftl_flush
	adrp	x0, .LANCHOR9
	ldrh	w2, [x21]
	mov	x19, x0
	ldr	x1, [x0, #:lo12:.LANCHOR9]
	ldrh	w1, [x1, x2, lsl 1]
	cbz	w1, .L3731
	adrp	x1, .LANCHOR228
	adrp	x0, .LC0
	mov	w2, 2718
	add	x1, x1, :lo12:.LANCHOR228
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3731:
	ldrh	w0, [x24, #:lo12:.LANCHOR64]
	ldr	x2, [x19, #:lo12:.LANCHOR9]
	ubfiz	x1, x0, 1, 16
	ldrh	w1, [x2, x1]
	cbnz	w1, .L3732
	bl	ftl_free_sblk
	b	.L3706
.L3732:
	mov	w2, 1
	mov	w1, 0
	bl	gc_add_sblk
	b	.L3706
.L3728:
	ldrh	w0, [x21, 576]
	cbz	w0, .L3733
	strh	wzr, [x21, 576]
	bl	sblk_wait_write_queue_completed
	bl	gc_write_completed
	ldr	w0, [x21, 580]
	cmn	w0, #1
	beq	.L3734
	bl	ftl_mask_bad_block
.L3734:
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
	cbz	x0, .L3735
	bl	zbuf_free
.L3735:
	add	x24, x24, :lo12:.LANCHOR64
	str	xzr, [x24, 8]
	bl	flt_sys_flush
	mov	w2, 2756
	strb	wzr, [x19, #:lo12:.LANCHOR155]
	adrp	x1, .LANCHOR228
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR228
	add	x0, x0, :lo12:.LC0
	bl	printf
	b	.L3747
.L3733:
	ldrh	w0, [x26, 6]
	ldrh	w1, [x21, 26]
	cmp	w0, 1
	ldrh	w0, [x21, 24]
	bls	.L3736
	cmp	w1, w0
	bcc	.L3727
	mov	w0, 1
	strb	w0, [x19, #:lo12:.LANCHOR155]
	ldrh	w0, [x21, 56]
	add	w1, w0, 1
	strh	w1, [x21, 56]
	add	x0, x21, x0, sxtw 1
	ldrh	w1, [x21]
	strh	w1, [x0, 58]
	mov	w0, -1
	strh	w0, [x21]
	b	.L3747
.L3736:
	mov	w2, 5
	strb	w2, [x19, #:lo12:.LANCHOR155]
	cmp	w1, w0
	bcc	.L3737
	ldrh	w0, [x21, 56]
	add	w1, w0, 1
	strh	w1, [x21, 56]
	add	x0, x21, x0, sxtw 1
	ldrh	w1, [x21]
	strh	w1, [x0, 58]
	mov	w0, -1
	strh	w0, [x21]
.L3737:
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
	cbz	w2, .L3738
	adrp	x2, .LANCHOR79
	ldrh	w2, [x2, #:lo12:.LANCHOR79]
	strh	w2, [x0, 18]
	mov	w2, 1
	strh	w2, [x0, 20]
.L3738:
	cmp	w1, 2
	bne	.L3740
	add	x0, x24, :lo12:.LANCHOR64
	ldrh	w1, [x0, 18]
	ubfiz	w1, w1, 1, 15
	strh	w1, [x0, 18]
	adrp	x1, .LANCHOR74
	ldrb	w1, [x1, #:lo12:.LANCHOR74]
	cbnz	w1, .L3740
	mov	w1, 1
	strh	w1, [x0, 20]
.L3740:
	add	x24, x24, :lo12:.LANCHOR64
	strh	wzr, [x24, 22]
	b	.L3747
.L3743:
	ldrh	w1, [x24, 16]
	ldrh	w0, [x24, 18]
	cmp	w1, w0
	bcc	.L3744
	mov	w0, 6
	strb	w0, [x19, #:lo12:.LANCHOR155]
	ldr	x0, [x24, 8]
	bl	zbuf_free
	str	xzr, [x24, 8]
	b	.L3747
.L3744:
	cmp	w21, 15
	bls	.L3647
	cmp	w25, 1
	bne	.L3747
	add	w22, w22, 1
	and	w22, w22, 255
	cmp	w22, 4
	bls	.L3647
	b	.L3747
.L3646:
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
.L3818:
	strb	wzr, [x19, #:lo12:.LANCHOR155]
	b	.L3747
.L3723:
	mov	w2, 2649
	adrp	x1, .LANCHOR228
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR228
	add	x0, x0, :lo12:.LC0
	bl	printf
	b	.L3746
	.size	zftl_do_gc, .-zftl_do_gc
	.section	.text.zftl_write,"ax",@progbits
	.align	2
	.global	zftl_write
	.type	zftl_write, %function
zftl_write:
	stp	x29, x30, [sp, -112]!
	add	x29, sp, 0
	stp	x25, x26, [sp, 64]
	mov	w26, w0
	adrp	x0, .LANCHOR14
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	mov	w19, w1
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	mov	w25, w2
	stp	x23, x24, [sp, 48]
	mov	x22, x3
	stp	x27, x28, [sp, 80]
	tbz	x0, 12, .L3821
	ldr	w4, [x22]
	mov	w3, w2
	adrp	x0, .LC245
	mov	w2, w1
	add	x0, x0, :lo12:.LC245
	mov	w1, w26
	bl	printf
.L3821:
	cbnz	w26, .L3822
	adrp	x0, .LANCHOR61
	mov	w26, 24576
	ldr	w0, [x0, #:lo12:.LANCHOR61]
.L3823:
	cmp	w0, w19
	ccmp	w0, w25, 0, hi
	bcc	.L3838
	add	w1, w19, w25
	cmp	w0, w1
	bcc	.L3838
	adrp	x23, .LANCHOR126
	add	w26, w26, w19
	sub	w19, w25, #1
	adrp	x24, .LANCHOR104
	ldrb	w0, [x23, #:lo12:.LANCHOR126]
	add	w19, w19, w26
	add	x23, x23, :lo12:.LANCHOR126
	udiv	w21, w26, w0
	udiv	w19, w19, w0
	add	w0, w26, w25
	str	w0, [x29, 108]
	mov	w28, w21
	sub	w20, w19, w21
	add	w20, w20, 1
.L3825:
	cbnz	w20, .L3833
	adrp	x20, .LANCHOR97
	adrp	x19, .LANCHOR101
	add	x20, x20, :lo12:.LANCHOR97
	add	x19, x19, :lo12:.LANCHOR101
	bl	ftl_write_commit
	bl	ftl_flush
	mov	w1, 1
	mov	w0, 0
	bl	zftl_do_gc
.L3834:
	ldrh	w0, [x20]
	ldrh	w1, [x19]
	add	w0, w0, w1
	cmp	w0, 7
	ble	.L3835
	mov	w0, 0
.L3820:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L3822:
	cmp	w26, 3
	bhi	.L3838
	lsl	w26, w26, 13
	mov	w0, 8192
	b	.L3823
.L3833:
	mov	w0, 0
	bl	buf_alloc
	mov	x27, x0
	cbnz	x0, .L3826
	bl	ftl_write_commit
	b	.L3825
.L3826:
	ldrb	w3, [x23]
	cmp	w28, w21
	strb	wzr, [x0, 57]
	ccmp	w28, w19, 4, ne
	strb	w3, [x0, 56]
	bne	.L3829
	cmp	w28, w21
	bne	.L3830
	udiv	w0, w26, w3
	msub	w0, w0, w3, w26
	and	w0, w0, 255
	strb	w0, [x27, 57]
	sub	w3, w3, w0
	and	w3, w3, 255
	cmp	w25, w3
	csel	w3, w25, w3, cc
.L3843:
	strb	w3, [x27, 56]
.L3829:
	ldr	x3, [x27, 8]
	mov	x1, x22
	ldrb	w0, [x27, 57]
	sub	w20, w20, #1
	ldrb	w2, [x27, 56]
	ubfiz	x0, x0, 9, 8
	lsl	w2, w2, 9
	add	x0, x3, x0
	bl	ftl_memcpy
	ldr	x1, [x24, #:lo12:.LANCHOR104]
	ldr	w0, [x1, 8]
	str	w28, [x27, 36]
	add	w28, w28, 1
	add	w2, w0, 1
	str	w2, [x1, 8]
	str	w0, [x27, 32]
	mov	x0, x27
	bl	ftl_write_buf
	ldrb	w0, [x27, 56]
	ubfiz	x0, x0, 9, 8
	add	x22, x22, x0
	b	.L3825
.L3830:
	ldr	w0, [x29, 108]
	msub	w3, w3, w28, w0
	b	.L3843
.L3835:
	mov	w1, 1
	mov	w0, 0
	bl	zftl_do_gc
	b	.L3834
.L3838:
	mov	w0, -1
	b	.L3820
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
	bne	.L3849
	mov	w3, w2
	mov	w0, 0
	mov	x2, x20
	bl	idb_write_data
.L3849:
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
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w19, w1
	adrp	x1, .LANCHOR61
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	ldr	w1, [x1, #:lo12:.LANCHOR61]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	cmp	w0, w1
	ccmp	w19, w1, 2, cc
	bhi	.L3873
	add	w2, w0, w19
	cmp	w1, w2
	bcc	.L3873
	adrp	x24, .LANCHOR229
	add	w22, w0, 24576
	adrp	x0, .LANCHOR14
	str	x0, [x29, 104]
	ldr	w1, [x24, #:lo12:.LANCHOR229]
	ldr	w2, [x0, #:lo12:.LANCHOR14]
	add	w1, w19, w1
	str	w1, [x24, #:lo12:.LANCHOR229]
	tbz	x2, 12, .L3853
	adrp	x0, .LC246
	mov	w4, 0
	mov	w3, w19
	mov	w2, w22
	add	x0, x0, :lo12:.LC246
	bl	printf
.L3853:
	adrp	x23, .LANCHOR104
	adrp	x26, .LANCHOR126
	ldr	x0, [x23, #:lo12:.LANCHOR104]
	ldr	w27, [x0, 8]
	add	w1, w27, 1
	str	w1, [x0, 8]
	bl	ftl_write_commit
	bl	ftl_flush
	ldrb	w21, [x26, #:lo12:.LANCHOR126]
	udiv	w20, w22, w21
	msub	w25, w20, w21, w22
	cbz	w25, .L3854
	sub	w21, w21, w25
	mov	w0, w20
	cmp	w21, w19
	csel	w21, w21, w19, ls
	bl	lpa_hash_get_ppa
	str	w0, [x29, 120]
	cmn	w0, #1
	bne	.L3855
	mov	w2, 0
	add	x1, x29, 120
	mov	w0, w20
	bl	pm_log2phys
.L3855:
	ldr	w0, [x29, 120]
	and	w28, w21, 65535
	cmn	w0, #1
	beq	.L3857
	mov	w0, 0
	bl	buf_alloc
	mov	x3, x0
	cbz	x0, .L3857
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
.L3857:
	add	w20, w20, 1
	sub	w19, w19, w28
.L3854:
	cbz	w19, .L3859
	bl	ftl_flush
.L3859:
	adrp	x25, .LANCHOR68
	add	x21, x26, :lo12:.LANCHOR126
	add	x25, x25, :lo12:.LANCHOR68
	mov	w0, -1
	str	w0, [x29, 124]
.L3860:
	ldrb	w0, [x21]
	cmp	w19, w0
	bcs	.L3865
	cbz	w19, .L3867
	mov	w0, w20
	bl	lpa_hash_get_ppa
	str	w0, [x29, 120]
	cmn	w0, #1
	bne	.L3868
	mov	w2, 0
	add	x1, x29, 120
	mov	w0, w20
	bl	pm_log2phys
.L3868:
	ldr	w0, [x29, 120]
	cmn	w0, #1
	beq	.L3867
	mov	w0, 0
	bl	buf_alloc
	mov	x21, x0
	cbz	x0, .L3867
	strb	wzr, [x0, 57]
	strb	w19, [x0, 56]
	stp	w27, w20, [x21, 32]
	ldrb	w0, [x26, #:lo12:.LANCHOR126]
	cmp	w19, w0
	bcc	.L3870
	adrp	x1, .LANCHOR230
	adrp	x0, .LC0
	mov	w2, 1261
	add	x1, x1, :lo12:.LANCHOR230
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3870:
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
.L3867:
	ldr	w1, [x24, #:lo12:.LANCHOR229]
	cmp	w1, 8192
	bls	.L3874
	ldr	x0, [x29, 104]
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L3871
	adrp	x0, .LC246
	mov	w4, 0
	mov	w3, w19
	mov	w2, w22
	add	x0, x0, :lo12:.LC246
	bl	printf
.L3871:
	str	wzr, [x24, #:lo12:.LANCHOR229]
	bl	flt_sys_flush
	adrp	x0, .LANCHOR116
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR116]
.L3874:
	mov	w0, 0
	b	.L3851
.L3865:
	mov	w0, w20
	bl	lpa_hash_get_ppa
	str	w0, [x29, 120]
	cmn	w0, #1
	beq	.L3861
	mov	w0, 0
	bl	buf_alloc
	mov	x28, x0
	cbz	x0, .L3863
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
.L3900:
	ldr	x1, [x23, #:lo12:.LANCHOR104]
	ldr	w0, [x1, 76]
	add	w0, w0, 1
	str	w0, [x1, 76]
.L3863:
	ldrb	w0, [x21]
	add	w20, w20, 1
	sub	w19, w19, w0
	b	.L3860
.L3861:
	mov	w2, 0
	add	x1, x29, 120
	mov	w0, w20
	bl	pm_log2phys
	ldr	w0, [x29, 120]
	cmn	w0, #1
	beq	.L3863
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
	b	.L3900
.L3873:
	mov	w0, -1
.L3851:
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
	adrp	x0, .LC247
	add	x0, x0, :lo12:.LC247
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR104
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR151
	ldr	x1, [x20, #:lo12:.LANCHOR104]
	mov	w19, 0
	mov	w22, 65535
	add	x1, x1, 704
	ldrh	w3, [x1, -6]
	bl	rknand_print_hex
	ldrh	w3, [x21, #:lo12:.LANCHOR151]
	add	x21, x21, :lo12:.LANCHOR151
	ldr	x1, [x20, #:lo12:.LANCHOR104]
	mov	w2, 2
	adrp	x0, .LC248
	add	x0, x0, :lo12:.LC248
	add	x1, x1, 416
	bl	rknand_print_hex
.L3903:
	ldrh	w0, [x21]
	cmp	w0, w19
	bhi	.L3905
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L3905:
	ldr	x0, [x20, #:lo12:.LANCHOR104]
	add	x0, x0, x19, sxtw 1
	ldrh	w0, [x0, 416]
	cmp	w0, w22
	beq	.L3904
	mov	x1, 0
	bl	ftl_sblk_dump
.L3904:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L3903
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
	.set	.LANCHOR210,. + 0
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
	.set	.LANCHOR193,. + 0
	.type	_c_ftl_pm_page_num, %object
	.size	_c_ftl_pm_page_num, 2
_c_ftl_pm_page_num:
	.zero	2
	.section	.bss._c_ftl_sec_per_page,"aw",@nobits
	.set	.LANCHOR126,. + 0
	.type	_c_ftl_sec_per_page, %object
	.size	_c_ftl_sec_per_page, 1
_c_ftl_sec_per_page:
	.zero	1
	.section	.bss._c_max_pm_sblk,"aw",@nobits
	.align	1
	.set	.LANCHOR151,. + 0
	.type	_c_max_pm_sblk, %object
	.size	_c_max_pm_sblk, 2
_c_max_pm_sblk:
	.zero	2
	.section	.bss._c_mix_max_slc_ec_count,"aw",@nobits
	.align	1
	.set	.LANCHOR121,. + 0
	.type	_c_mix_max_slc_ec_count, %object
	.size	_c_mix_max_slc_ec_count, 2
_c_mix_max_slc_ec_count:
	.zero	2
	.section	.bss._c_mix_max_xlc_ec_count,"aw",@nobits
	.align	1
	.set	.LANCHOR119,. + 0
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
	.set	.LANCHOR150,. + 0
	.type	_c_swl_slc_gc_th, %object
	.size	_c_swl_slc_gc_th, 2
_c_swl_slc_gc_th:
	.zero	2
	.section	.bss._c_swl_xlc_gc_th,"aw",@nobits
	.align	1
	.set	.LANCHOR149,. + 0
	.type	_c_swl_xlc_gc_th, %object
	.size	_c_swl_xlc_gc_th, 2
_c_swl_xlc_gc_th:
	.zero	2
	.section	.bss._c_totle_data_density,"aw",@nobits
	.align	2
	.set	.LANCHOR215,. + 0
	.type	_c_totle_data_density, %object
	.size	_c_totle_data_density, 4
_c_totle_data_density:
	.zero	4
	.section	.bss._c_totle_log_page,"aw",@nobits
	.align	2
	.set	.LANCHOR123,. + 0
	.type	_c_totle_log_page, %object
	.size	_c_totle_log_page, 4
_c_totle_log_page:
	.zero	4
	.section	.bss._c_totle_phy_density,"aw",@nobits
	.align	2
	.set	.LANCHOR214,. + 0
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
	.set	.LANCHOR120,. + 0
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
	.set	.LANCHOR229,. + 0
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
	.set	.LANCHOR165,. + 0
	.type	flash_ddr_tuning_sdr_read_count, %object
	.size	flash_ddr_tuning_sdr_read_count, 4
flash_ddr_tuning_sdr_read_count:
	.zero	4
	.section	.bss.flash_read_retry,"aw",@nobits
	.align	3
	.set	.LANCHOR167,. + 0
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
	.set	.LANCHOR189,. + 0
	.type	ftl_ext_info_first_write, %object
	.size	ftl_ext_info_first_write, 1
ftl_ext_info_first_write:
	.zero	1
	.section	.bss.ftl_flush_jiffies,"aw",@nobits
	.align	2
	.set	.LANCHOR224,. + 0
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
	.set	.LANCHOR184,. + 0
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
	.set	.LANCHOR188,. + 0
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
	.set	.LANCHOR187,. + 0
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
	.set	.LANCHOR182,. + 0
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
	.set	.LANCHOR145,. + 0
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
	.set	.LANCHOR201,. + 0
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
	.set	.LANCHOR118,. + 0
	.type	g_flash_micron_3d_tlc_b05a, %object
	.size	g_flash_micron_3d_tlc_b05a, 1
g_flash_micron_3d_tlc_b05a:
	.zero	1
	.section	.bss.g_flash_micron_3d_tlc_b16a,"aw",@nobits
	.set	.LANCHOR207,. + 0
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
	.set	.LANCHOR179,. + 0
	.type	g_flash_multi_page_read_en, %object
	.size	g_flash_multi_page_read_en, 1
g_flash_multi_page_read_en:
	.zero	1
	.section	.bss.g_flash_page_buffer,"aw",@nobits
	.align	3
	.set	.LANCHOR169,. + 0
	.type	g_flash_page_buffer, %object
	.size	g_flash_page_buffer, 8
g_flash_page_buffer:
	.zero	8
	.section	.bss.g_flash_reversd_blks,"aw",@nobits
	.set	.LANCHOR206,. + 0
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
	.set	.LANCHOR168,. + 0
	.type	g_flash_spare_buffer, %object
	.size	g_flash_spare_buffer, 8
g_flash_spare_buffer:
	.zero	8
	.section	.bss.g_flash_sys_spare_buffer,"aw",@nobits
	.align	3
	.set	.LANCHOR200,. + 0
	.type	g_flash_sys_spare_buffer, %object
	.size	g_flash_sys_spare_buffer, 8
g_flash_sys_spare_buffer:
	.zero	8
	.section	.bss.g_flash_tmp_page_buffer,"aw",@nobits
	.align	3
	.set	.LANCHOR161,. + 0
	.type	g_flash_tmp_page_buffer, %object
	.size	g_flash_tmp_page_buffer, 8
g_flash_tmp_page_buffer:
	.zero	8
	.section	.bss.g_flash_tmp_spare_buffer,"aw",@nobits
	.align	3
	.set	.LANCHOR163,. + 0
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
	.set	.LANCHOR185,. + 0
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
	.set	.LANCHOR164,. + 0
	.type	g_maxRetryCount, %object
	.size	g_maxRetryCount, 1
g_maxRetryCount:
	.zero	1
	.section	.bss.g_msb_page_tbl,"aw",@nobits
	.align	2
	.set	.LANCHOR142,. + 0
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
	.set	.LANCHOR162,. + 0
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
	.set	.LANCHOR197,. + 0
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
	.set	.LANCHOR144,. + 0
	.type	g_slc_page_num, %object
	.size	g_slc_page_num, 2
g_slc_page_num:
	.zero	2
	.section	.bss.g_totle_phy_block,"aw",@nobits
	.align	1
	.set	.LANCHOR146,. + 0
	.type	g_totle_phy_block, %object
	.size	g_totle_phy_block, 2
g_totle_phy_block:
	.zero	2
	.section	.bss.gc_des_ppa_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR159,. + 0
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
	.set	.LANCHOR157,. + 0
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
	.set	.LANCHOR158,. + 0
	.type	gc_pre_ppa_tbl, %object
	.size	gc_pre_ppa_tbl, 8
gc_pre_ppa_tbl:
	.zero	8
	.section	.bss.gc_search_count,"aw",@nobits
	.align	2
	.set	.LANCHOR156,. + 0
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
	.set	.LANCHOR155,. + 0
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
	.set	.LANCHOR141,. + 0
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
	.set	.LANCHOR138,. + 0
	.type	idb_buf, %object
	.size	idb_buf, 8
idb_buf:
	.zero	8
	.section	.bss.idb_last_lba,"aw",@nobits
	.align	2
	.set	.LANCHOR170,. + 0
	.type	idb_last_lba, %object
	.size	idb_last_lba, 4
idb_last_lba:
	.zero	4
	.section	.bss.idb_need_write_back,"aw",@nobits
	.align	2
	.set	.LANCHOR139,. + 0
	.type	idb_need_write_back, %object
	.size	idb_need_write_back, 4
idb_need_write_back:
	.zero	4
	.section	.bss.idb_write_enable,"aw",@nobits
	.set	.LANCHOR140,. + 0
	.type	idb_write_enable, %object
	.size	idb_write_enable, 1
idb_write_enable:
	.zero	1
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
	.set	.LANCHOR198,. + 0
	.type	pm_first_write, %object
	.size	pm_first_write, 1
pm_first_write:
	.zero	1
	.section	.bss.pm_force_gc,"aw",@nobits
	.align	2
	.set	.LANCHOR148,. + 0
	.type	pm_force_gc, %object
	.size	pm_force_gc, 4
pm_force_gc:
	.zero	4
	.section	.bss.pm_gc_enable,"aw",@nobits
	.align	2
	.set	.LANCHOR133,. + 0
	.type	pm_gc_enable, %object
	.size	pm_gc_enable, 4
pm_gc_enable:
	.zero	4
	.section	.bss.pm_last_load_ram_id,"aw",@nobits
	.set	.LANCHOR212,. + 0
	.type	pm_last_load_ram_id, %object
	.size	pm_last_load_ram_id, 1
pm_last_load_ram_id:
	.zero	1
	.section	.bss.pm_last_update_ram_id,"aw",@nobits
	.set	.LANCHOR136,. + 0
	.type	pm_last_update_ram_id, %object
	.size	pm_last_update_ram_id, 1
pm_last_update_ram_id:
	.zero	1
	.section	.bss.pm_ram_info,"aw",@nobits
	.align	3
	.set	.LANCHOR135,. + 0
	.type	pm_ram_info, %object
	.size	pm_ram_info, 512
pm_ram_info:
	.zero	512
	.section	.bss.read_ahead_lpa,"aw",@nobits
	.align	2
	.set	.LANCHOR213,. + 0
	.type	read_ahead_lpa, %object
	.size	read_ahead_lpa, 4
read_ahead_lpa:
	.zero	4
	.section	.bss.read_buf_count,"aw",@nobits
	.set	.LANCHOR130,. + 0
	.type	read_buf_count, %object
	.size	read_buf_count, 1
read_buf_count:
	.zero	1
	.section	.bss.read_buf_head,"aw",@nobits
	.set	.LANCHOR129,. + 0
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
	.set	.LANCHOR132,. + 0
	.type	sblk_read_completed_queue_head, %object
	.size	sblk_read_completed_queue_head, 1
sblk_read_completed_queue_head:
	.zero	1
	.section	.bss.sblk_write_completed_queue_head,"aw",@nobits
	.set	.LANCHOR127,. + 0
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
	.set	.LANCHOR124,. + 0
	.type	write_commit_count, %object
	.size	write_commit_count, 1
write_commit_count:
	.zero	1
	.section	.bss.write_commit_head,"aw",@nobits
	.set	.LANCHOR178,. + 0
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
	.set	.LANCHOR160,. + 0
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
	.set	.LANCHOR205,. + 0
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
	.set	.LANCHOR226,. + 0
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
	.set	.LANCHOR227,. + 0
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
	.set	.LANCHOR204,. + 0
	.type	zftl_nand_flash_para_tbl, %object
	.size	zftl_nand_flash_para_tbl, 1472
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
	.byte	44
	.byte	-92
	.byte	100
	.byte	50
	.byte	-86
	.byte	4
	.byte	4
	.byte	1
	.byte	32
	.hword	1024
	.byte	2
	.byte	1
	.hword	2192
	.hword	9671
	.byte	10
	.byte	19
	.byte	70
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.hword	1024
	.byte	2
	.byte	-38
	.byte	-33
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
	.byte	3
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
	.byte	3
	.byte	0
	.hword	512
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
	.byte	-120
	.byte	4
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
	.byte	1
	.byte	0
	.byte	24
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
	.section	.rodata.__func__.10018,"a",@progbits
	.align	3
	.set	.LANCHOR209,. + 0
	.type	__func__.10018, %object
	.size	__func__.10018, 16
__func__.10018:
	.string	"load_l2p_region"
	.section	.rodata.__func__.10034,"a",@progbits
	.align	3
	.set	.LANCHOR152,. + 0
	.type	__func__.10034, %object
	.size	__func__.10034, 13
__func__.10034:
	.string	"pm_free_sblk"
	.section	.rodata.__func__.10058,"a",@progbits
	.align	3
	.set	.LANCHOR211,. + 0
	.type	__func__.10058, %object
	.size	__func__.10058, 6
__func__.10058:
	.string	"pm_gc"
	.section	.rodata.__func__.10074,"a",@progbits
	.align	3
	.set	.LANCHOR134,. + 0
	.type	__func__.10074, %object
	.size	__func__.10074, 17
__func__.10074:
	.string	"pm_alloc_new_blk"
	.section	.rodata.__func__.10084,"a",@progbits
	.align	3
	.set	.LANCHOR196,. + 0
	.type	__func__.10084, %object
	.size	__func__.10084, 14
__func__.10084:
	.string	"pm_write_page"
	.section	.rodata.__func__.10102,"a",@progbits
	.align	3
	.set	.LANCHOR137,. + 0
	.type	__func__.10102, %object
	.size	__func__.10102, 21
__func__.10102:
	.string	"pm_select_ram_region"
	.section	.rodata.__func__.7564,"a",@progbits
	.align	3
	.set	.LANCHOR166,. + 0
	.type	__func__.7564, %object
	.size	__func__.7564, 19
__func__.7564:
	.string	"flash_read_page_en"
	.section	.rodata.__func__.7606,"a",@progbits
	.align	3
	.set	.LANCHOR181,. + 0
	.type	__func__.7606, %object
	.size	__func__.7606, 19
__func__.7606:
	.string	"flash_prog_page_en"
	.section	.rodata.__func__.7622,"a",@progbits
	.align	3
	.set	.LANCHOR40,. + 0
	.type	__func__.7622, %object
	.size	__func__.7622, 26
__func__.7622:
	.string	"flash_erase_duplane_block"
	.section	.rodata.__func__.7633,"a",@progbits
	.align	3
	.set	.LANCHOR42,. + 0
	.type	__func__.7633, %object
	.size	__func__.7633, 21
__func__.7633:
	.string	"flash_erase_block_en"
	.section	.rodata.__func__.7647,"a",@progbits
	.align	3
	.set	.LANCHOR29,. + 0
	.type	__func__.7647, %object
	.size	__func__.7647, 28
__func__.7647:
	.string	"flash_wait_device_ready_raw"
	.section	.rodata.__func__.7671,"a",@progbits
	.align	3
	.set	.LANCHOR171,. + 0
	.type	__func__.7671, %object
	.size	__func__.7671, 26
__func__.7671:
	.string	"flash_start_tlc_page_prog"
	.section	.rodata.__func__.7682,"a",@progbits
	.align	3
	.set	.LANCHOR172,. + 0
	.type	__func__.7682, %object
	.size	__func__.7682, 29
__func__.7682:
	.string	"flash_start_3d_mlc_page_prog"
	.section	.rodata.__func__.7700,"a",@progbits
	.align	3
	.set	.LANCHOR173,. + 0
	.type	__func__.7700, %object
	.size	__func__.7700, 22
__func__.7700:
	.string	"flash_start_page_prog"
	.section	.rodata.__func__.7711,"a",@progbits
	.align	3
	.set	.LANCHOR34,. + 0
	.type	__func__.7711, %object
	.size	__func__.7711, 22
__func__.7711:
	.string	"flash_start_page_read"
	.section	.rodata.__func__.7724,"a",@progbits
	.align	3
	.set	.LANCHOR174,. + 0
	.type	__func__.7724, %object
	.size	__func__.7724, 31
__func__.7724:
	.string	"flash_complete_plane_page_read"
	.section	.rodata.__func__.7736,"a",@progbits
	.align	3
	.set	.LANCHOR43,. + 0
	.type	__func__.7736, %object
	.size	__func__.7736, 23
__func__.7736:
	.string	"flash_start_plane_read"
	.section	.rodata.__func__.7749,"a",@progbits
	.align	3
	.set	.LANCHOR175,. + 0
	.type	__func__.7749, %object
	.size	__func__.7749, 25
__func__.7749:
	.string	"flash_complete_page_read"
	.section	.rodata.__func__.8094,"a",@progbits
	.align	3
	.set	.LANCHOR143,. + 0
	.type	__func__.8094, %object
	.size	__func__.8094, 20
__func__.8094:
	.string	"flash_die_info_init"
	.section	.rodata.__func__.8104,"a",@progbits
	.align	3
	.set	.LANCHOR15,. + 0
	.type	__func__.8104, %object
	.size	__func__.8104, 22
__func__.8104:
	.string	"nand_flash_print_info"
	.section	.rodata.__func__.8149,"a",@progbits
	.align	3
	.set	.LANCHOR203,. + 0
	.type	__func__.8149, %object
	.size	__func__.8149, 16
__func__.8149:
	.string	"nand_flash_init"
	.section	.rodata.__func__.8172,"a",@progbits
	.align	3
	.set	.LANCHOR154,. + 0
	.type	__func__.8172, %object
	.size	__func__.8172, 11
__func__.8172:
	.string	"nandc_init"
	.section	.rodata.__func__.8341,"a",@progbits
	.align	3
	.set	.LANCHOR55,. + 0
	.type	__func__.8341, %object
	.size	__func__.8341, 13
__func__.8341:
	.string	"buf_add_tail"
	.section	.rodata.__func__.8354,"a",@progbits
	.align	3
	.set	.LANCHOR57,. + 0
	.type	__func__.8354, %object
	.size	__func__.8354, 10
__func__.8354:
	.string	"buf_alloc"
	.section	.rodata.__func__.8368,"a",@progbits
	.align	3
	.set	.LANCHOR58,. + 0
	.type	__func__.8368, %object
	.size	__func__.8368, 16
__func__.8368:
	.string	"buf_remove_free"
	.section	.rodata.__func__.8381,"a",@progbits
	.align	3
	.set	.LANCHOR202,. + 0
	.type	__func__.8381, %object
	.size	__func__.8381, 20
__func__.8381:
	.string	"flash_info_blk_init"
	.section	.rodata.__func__.8392,"a",@progbits
	.align	3
	.set	.LANCHOR153,. + 0
	.type	__func__.8392, %object
	.size	__func__.8392, 21
__func__.8392:
	.string	"flash_info_data_init"
	.section	.rodata.__func__.8414,"a",@progbits
	.align	3
	.set	.LANCHOR199,. + 0
	.type	__func__.8414, %object
	.size	__func__.8414, 17
__func__.8414:
	.string	"flash_info_flush"
	.section	.rodata.__func__.8490,"a",@progbits
	.align	3
	.set	.LANCHOR147,. + 0
	.type	__func__.8490, %object
	.size	__func__.8490, 17
__func__.8490:
	.string	"lpa_rebuild_hash"
	.section	.rodata.__func__.8537,"a",@progbits
	.align	3
	.set	.LANCHOR223,. + 0
	.type	__func__.8537, %object
	.size	__func__.8537, 17
__func__.8537:
	.string	"ftl_write_commit"
	.section	.rodata.__func__.8555,"a",@progbits
	.align	3
	.set	.LANCHOR125,. + 0
	.type	__func__.8555, %object
	.size	__func__.8555, 14
__func__.8555:
	.string	"ftl_write_buf"
	.section	.rodata.__func__.8600,"a",@progbits
	.align	3
	.set	.LANCHOR128,. + 0
	.type	__func__.8600, %object
	.size	__func__.8600, 18
__func__.8600:
	.string	"zftl_add_read_buf"
	.section	.rodata.__func__.8633,"a",@progbits
	.align	3
	.set	.LANCHOR220,. + 0
	.type	__func__.8633, %object
	.size	__func__.8633, 10
__func__.8633:
	.string	"zftl_read"
	.section	.rodata.__func__.8664,"a",@progbits
	.align	3
	.set	.LANCHOR230,. + 0
	.type	__func__.8664, %object
	.size	__func__.8664, 13
__func__.8664:
	.string	"_ftl_discard"
	.section	.rodata.__func__.8816,"a",@progbits
	.align	3
	.set	.LANCHOR65,. + 0
	.type	__func__.8816, %object
	.size	__func__.8816, 12
__func__.8816:
	.string	"gc_add_sblk"
	.section	.rodata.__func__.8863,"a",@progbits
	.align	3
	.set	.LANCHOR221,. + 0
	.type	__func__.8863, %object
	.size	__func__.8863, 21
__func__.8863:
	.string	"gc_check_data_one_wl"
	.section	.rodata.__func__.8897,"a",@progbits
	.align	3
	.set	.LANCHOR216,. + 0
	.type	__func__.8897, %object
	.size	__func__.8897, 22
__func__.8897:
	.string	"gc_update_l2p_map_new"
	.section	.rodata.__func__.8910,"a",@progbits
	.align	3
	.set	.LANCHOR72,. + 0
	.type	__func__.8910, %object
	.size	__func__.8910, 19
__func__.8910:
	.string	"gc_write_completed"
	.section	.rodata.__func__.8939,"a",@progbits
	.align	3
	.set	.LANCHOR225,. + 0
	.type	__func__.8939, %object
	.size	__func__.8939, 16
__func__.8939:
	.string	"gc_do_copy_back"
	.section	.rodata.__func__.8966,"a",@progbits
	.align	3
	.set	.LANCHOR122,. + 0
	.type	__func__.8966, %object
	.size	__func__.8966, 16
__func__.8966:
	.string	"gc_free_src_blk"
	.section	.rodata.__func__.9010,"a",@progbits
	.align	3
	.set	.LANCHOR217,. + 0
	.type	__func__.9010, %object
	.size	__func__.9010, 16
__func__.9010:
	.string	"gc_scan_src_blk"
	.section	.rodata.__func__.9068,"a",@progbits
	.align	3
	.set	.LANCHOR218,. + 0
	.type	__func__.9068, %object
	.size	__func__.9068, 20
__func__.9068:
	.string	"gc_scan_static_data"
	.section	.rodata.__func__.9135,"a",@progbits
	.align	3
	.set	.LANCHOR228,. + 0
	.type	__func__.9135, %object
	.size	__func__.9135, 11
__func__.9135:
	.string	"zftl_do_gc"
	.section	.rodata.__func__.9228,"a",@progbits
	.align	3
	.set	.LANCHOR5,. + 0
	.type	__func__.9228, %object
	.size	__func__.9228, 18
__func__.9228:
	.string	"_list_remove_node"
	.section	.rodata.__func__.9253,"a",@progbits
	.align	3
	.set	.LANCHOR11,. + 0
	.type	__func__.9253, %object
	.size	__func__.9253, 23
__func__.9253:
	.string	"_list_update_data_list"
	.section	.rodata.__func__.9361,"a",@progbits
	.align	3
	.set	.LANCHOR186,. + 0
	.type	__func__.9361, %object
	.size	__func__.9361, 15
__func__.9361:
	.string	"ftl_info_flush"
	.section	.rodata.__func__.9393,"a",@progbits
	.align	3
	.set	.LANCHOR131,. + 0
	.type	__func__.9393, %object
	.size	__func__.9393, 15
__func__.9393:
	.string	"ftl_alloc_sblk"
	.section	.rodata.__func__.9435,"a",@progbits
	.align	3
	.set	.LANCHOR107,. + 0
	.type	__func__.9435, %object
	.size	__func__.9435, 18
__func__.9435:
	.string	"ftl_alloc_sys_blk"
	.section	.rodata.__func__.9445,"a",@progbits
	.align	3
	.set	.LANCHOR108,. + 0
	.type	__func__.9445, %object
	.size	__func__.9445, 17
__func__.9445:
	.string	"ftl_free_sys_blk"
	.section	.rodata.__func__.9480,"a",@progbits
	.align	3
	.set	.LANCHOR219,. + 0
	.type	__func__.9480, %object
	.size	__func__.9480, 14
__func__.9480:
	.string	"ftl_sblk_dump"
	.section	.rodata.__func__.9504,"a",@progbits
	.align	3
	.set	.LANCHOR208,. + 0
	.type	__func__.9504, %object
	.size	__func__.9504, 16
__func__.9504:
	.string	"ftl_sysblk_dump"
	.section	.rodata.__func__.9528,"a",@progbits
	.align	3
	.set	.LANCHOR195,. + 0
	.type	__func__.9528, %object
	.size	__func__.9528, 23
__func__.9528:
	.string	"ftl_open_sblk_recovery"
	.section	.rodata.__func__.9561,"a",@progbits
	.align	3
	.set	.LANCHOR109,. + 0
	.type	__func__.9561, %object
	.size	__func__.9561, 23
__func__.9561:
	.string	"ftl_get_ppa_from_index"
	.section	.rodata.__func__.9582,"a",@progbits
	.align	3
	.set	.LANCHOR222,. + 0
	.type	__func__.9582, %object
	.size	__func__.9582, 19
__func__.9582:
	.string	"ftl_update_l2p_map"
	.section	.rodata.__func__.9601,"a",@progbits
	.align	3
	.set	.LANCHOR113,. + 0
	.type	__func__.9601, %object
	.size	__func__.9601, 22
__func__.9601:
	.string	"ftl_get_new_free_page"
	.section	.rodata.__func__.9612,"a",@progbits
	.align	3
	.set	.LANCHOR114,. + 0
	.type	__func__.9612, %object
	.size	__func__.9612, 22
__func__.9612:
	.string	"ftl_ext_alloc_new_blk"
	.section	.rodata.__func__.9637,"a",@progbits
	.align	3
	.set	.LANCHOR190,. + 0
	.type	__func__.9637, %object
	.size	__func__.9637, 19
__func__.9637:
	.string	"ftl_ext_info_flush"
	.section	.rodata.__func__.9649,"a",@progbits
	.align	3
	.set	.LANCHOR191,. + 0
	.type	__func__.9649, %object
	.size	__func__.9649, 18
__func__.9649:
	.string	"ftl_ext_info_init"
	.section	.rodata.__func__.9688,"a",@progbits
	.align	3
	.set	.LANCHOR192,. + 0
	.type	__func__.9688, %object
	.size	__func__.9688, 25
__func__.9688:
	.string	"ftl_low_format_data_init"
	.section	.rodata.__func__.9703,"a",@progbits
	.align	3
	.set	.LANCHOR194,. + 0
	.type	__func__.9703, %object
	.size	__func__.9703, 15
__func__.9703:
	.string	"ftl_low_format"
	.section	.rodata.__func__.9751,"a",@progbits
	.align	3
	.set	.LANCHOR183,. + 0
	.type	__func__.9751, %object
	.size	__func__.9751, 14
__func__.9751:
	.string	"ftl_prog_page"
	.section	.rodata.__func__.9873,"a",@progbits
	.align	3
	.set	.LANCHOR176,. + 0
	.type	__func__.9873, %object
	.size	__func__.9873, 31
__func__.9873:
	.string	"queue_wait_first_req_completed"
	.section	.rodata.__func__.9927,"a",@progbits
	.align	3
	.set	.LANCHOR177,. + 0
	.type	__func__.9927, %object
	.size	__func__.9927, 15
__func__.9927:
	.string	"sblk_prog_page"
	.section	.rodata.__func__.9954,"a",@progbits
	.align	3
	.set	.LANCHOR180,. + 0
	.type	__func__.9954, %object
	.size	__func__.9954, 15
__func__.9954:
	.string	"sblk_read_page"
	.section	.rodata._list_remove_node.str1.1,"aMS",@progbits,1
.LC0:
	.string	"\n!!!!! error @ func:%s - line:%d\n"
	.section	.rodata.dump_ftl_info.str1.1,"aMS",@progbits,1
.LC177:
	.string	"free_buf_count: %d\n"
.LC178:
	.string	"g_ftl_info_blk blk:0x%x, index:0x%x, page:0x%x\n"
.LC179:
	.string	"ftl_ext_info_blk blk:0x%x, page:0x%x\n"
.LC180:
	.string	"ac_blk:0x%x, page:0x%x, index:0x%x, free:0x%x, page_index:0x%x\n"
.LC181:
	.string	"tmp_blk:0x%x, page:0x%x, index:0x%x, free:0x%x, page_index:0x%x\n"
.LC182:
	.string	"gc_blk:0x%x, page:0x%x, index:0x%x, free:0x%x, page_index:0x%x\n"
.LC183:
	.string	"lpa:"
.LC184:
	.string	"vpn:"
.LC185:
	.string	"sblk:"
.LC186:
	.string	"lpa_hash:"
.LC187:
	.string	"lpa_hash_index:"
	.section	.rodata.dump_pm_blk.str1.1,"aMS",@progbits,1
.LC247:
	.string	"pm l2p:"
.LC248:
	.string	"pm blk:"
	.section	.rodata.dump_sblk_queue.str1.1,"aMS",@progbits,1
.LC74:
	.string	"dump_sblk_queue: %d\n"
.LC75:
	.string	"buf id= %d state = %d ppa = %x\n"
	.section	.rodata.flash_complete_page_read.str1.1,"aMS",@progbits,1
.LC130:
	.string	"flash_complete_page_read %x %x error_ecc %d %d\n"
	.section	.rodata.flash_ddr_tuning_read.str1.1,"aMS",@progbits,1
.LC116:
	.string	"%d flash_ddr_tuning_read %x ecc=%d\n"
.LC117:
	.string	"sync para %d\n"
.LC118:
	.string	"DDR mode Read error %x %x\n"
.LC119:
	.string	"SDR mode Read %x %x ecc:%x\n"
	.section	.rodata.flash_erase_all.str1.1,"aMS",@progbits,1
.LC35:
	.string	"erase done: %x\n"
	.section	.rodata.flash_erase_block_en.str1.1,"aMS",@progbits,1
.LC33:
	.string	"flash_erase_block %x %x %x\n"
.LC34:
	.string	"flash_erase_block %d block = %x status = %x\n"
	.section	.rodata.flash_erase_duplane_block.str1.1,"aMS",@progbits,1
.LC31:
	.string	"flash_erase_duplane_block %x %x %x\n"
.LC32:
	.string	"flash_erase_duplane_block pageadd = %x status = %x\n"
	.section	.rodata.flash_get_last_written_page.str1.1,"aMS",@progbits,1
.LC122:
	.string	"flash_get_last_written_page: %x %x %x\n"
	.section	.rodata.flash_info_blk_init.str1.1,"aMS",@progbits,1
.LC174:
	.string	"...%d @ %s %d %p\n"
.LC175:
	.string	"no sys info %x\n"
	.section	.rodata.flash_info_data_init.str1.1,"aMS",@progbits,1
.LC91:
	.string	"...%d @ %s\n"
	.section	.rodata.flash_info_flush.str1.1,"aMS",@progbits,1
.LC171:
	.string	"finfo:"
.LC172:
	.string	"flash_info_flush id = %x, page = %x\n"
.LC173:
	.string	"sys_info_flush error:%x\n"
	.section	.rodata.flash_mask_bad_block.str1.1,"aMS",@progbits,1
.LC41:
	.string	"flash_mask_bad_block %d %d\n"
	.section	.rodata.flash_prog_page.str1.1,"aMS",@progbits,1
.LC123:
	.string	"flash_prog_page %x %x %x\n"
.LC124:
	.string	"flash_prog_page page_addr = %x status = %x\n"
	.section	.rodata.flash_prog_page_en.str1.1,"aMS",@progbits,1
.LC137:
	.string	"flash_prog_page_en:%x %x %x\n"
.LC138:
	.string	"w d:"
.LC139:
	.string	"w s:"
.LC140:
	.string	"spare"
.LC141:
	.string	"data"
.LC142:
	.string	"write error: %x\n"
	.section	.rodata.flash_read_id.str1.1,"aMS",@progbits,1
.LC38:
	.string	"No.%d FLASH ID:%x %x %x %x %x %x\n"
	.section	.rodata.flash_read_otp_data.str1.1,"aMS",@progbits,1
.LC39:
	.string	"otp:%x %x %x %x\n"
	.section	.rodata.flash_read_page.str1.1,"aMS",@progbits,1
.LC109:
	.string	"flash_read_page %x %x %x\n"
	.section	.rodata.flash_read_page_en.str1.1,"aMS",@progbits,1
.LC120:
	.string	"flash_read_page_en %x %x %x %x\n"
.LC121:
	.string	"flash_read_page_en %x %x error_ecc %d %d\n"
	.section	.rodata.flash_set_interface_mode.str1.1,"aMS",@progbits,1
.LC36:
	.string	"nand sdr mode %x\n"
.LC37:
	.string	"nand ddr mode %x\n"
	.section	.rodata.ftl_alloc_new_data_sblk.str1.1,"aMS",@progbits,1
.LC236:
	.string	"error gc_add_sblk: %x\n"
	.section	.rodata.ftl_alloc_sblk.str1.1,"aMS",@progbits,1
.LC73:
	.string	"alloc sblk %x %d\n"
	.section	.rodata.ftl_dump_write_open_sblk.str1.1,"aMS",@progbits,1
.LC166:
	.string	"ftl_sblk_dump_write = %x %d %d %d %d\n"
.LC167:
	.string	"blk= %x, page=%x, ppa = %x, status = %x, data:%x %x %x %x, spare: %x %x %x %x\n"
.LC168:
	.string	"ftl_sblk_dump_write2 = %x %d %d %d\n"
.LC169:
	.string	"ftl_sblk_dump_write = %x %x\n"
.LC170:
	.string	"ftl_sblk_dump_write done = %x\n"
	.section	.rodata.ftl_ext_info_init.str1.1,"aMS",@progbits,1
.LC149:
	.string	"%s %d %d %x %x\n"
.LC150:
	.string	"ext info hash %x error\n"
.LC151:
	.string	"%s %x %x %x\n"
	.section	.rodata.ftl_free_sblk.str1.1,"aMS",@progbits,1
.LC62:
	.string	"swl_slc_free_mini_ec_blk sblk %x\n"
	.section	.rodata.ftl_info_blk_init.str1.1,"aMS",@progbits,1
.LC145:
	.string	"%d %x @%d %x\n"
.LC146:
	.string	"ftl_info_blk_init %d %d %x\n"
.LC147:
	.string	"ftl info hash %x error\n"
.LC148:
	.string	"ink flag: %x\n"
	.section	.rodata.ftl_info_flush.str1.1,"aMS",@progbits,1
.LC144:
	.string	"g_ftl_info_blk blk = %x, page = %x version = %d\n"
	.section	.rodata.ftl_low_format.str1.1,"aMS",@progbits,1
.LC152:
	.string	"ftl_low_format %d\n"
.LC153:
	.string	"low format %d %d %d %d\n"
	.section	.rodata.ftl_mask_bad_block.str1.1,"aMS",@progbits,1
.LC60:
	.string	"mask bad block:cs %x %x block: %x %x\n"
	.section	.rodata.ftl_open_sblk_recovery.str1.1,"aMS",@progbits,1
.LC155:
	.string	"saved_active_page  = %x\n"
.LC156:
	.string	"saved_active_plane = %x\n"
.LC157:
	.string	"sblk = %x\n"
.LC158:
	.string	"phy_blk = %x %x\n"
.LC159:
	.string	"num_planes = %x\n"
.LC160:
	.string	"sblk = %x, vpn0 = %d, vpn1 = %d\n"
.LC161:
	.string	"dump_write_lpa = %x %x %x %x\n"
.LC162:
	.string	"dump write new ppa = %x, last ppa = %x lpa = %x\n"
.LC163:
	.string	"dump write = %x %x %x\n"
.LC164:
	.string	"dump write hash update = %x %x %x\n"
	.section	.rodata.ftl_re_low_format.str1.1,"aMS",@progbits,1
.LC154:
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
.LC176:
	.string	"l2p:"
	.section	.rodata.ftl_test_block.str1.1,"aMS",@progbits,1
.LC143:
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
.LC59:
	.string	"ftl_vpn_decrement %x = %d, %d\n"
	.section	.rodata.ftl_write_commit.str1.1,"aMS",@progbits,1
.LC237:
	.string	"%d read error: ppa:%x, lpa:%x, status:%x\n"
	.section	.rodata.ftl_write_completed.str1.1,"aMS",@progbits,1
.LC71:
	.string	"ftl prog error =%x, lpa = %x, ppa= %x\n"
.LC72:
	.string	"ftl re prog: lpa = %x, ppa= %x\n"
	.section	.rodata.gc_add_sblk.str1.1,"aMS",@progbits,1
.LC42:
	.string	"gc_add_sblk = %d, %d, %d, %d, %d, %d, %d\n"
.LC43:
	.string	"gc_add_sblk = %d, %d, %d\n"
.LC44:
	.string	"gc_add_sblk = %d, %d, %d,last update:%d, %d\n"
.LC45:
	.string	"gc_add_sblk = %d, %d, %d, %d, %d, %d\n"
	.section	.rodata.gc_check_data_one_wl.str1.1,"aMS",@progbits,1
.LC229:
	.string	"err: ppa = %x, status = %x, %x %x spare: %x %x %x %x\n"
.LC230:
	.string	"gc_lpa:"
.LC231:
	.string	"gc_ppa:"
	.section	.rodata.gc_do_copy_back.str1.1,"aMS",@progbits,1
.LC238:
	.string	"gc page in buf: lpa %x ppa = %x pageindex= %x\n"
.LC239:
	.string	"gc_do_copy_back: lpa %x des_ppa = %x %x gc_ppa= %x page_index= %d\n"
.LC240:
	.string	"gc_do_copy_back: %x %x %x %x gc_ppa:%x %x %x %d\n"
	.section	.rodata.gc_free_bad_sblk.str1.1,"aMS",@progbits,1
.LC61:
	.string	"gc_free_bad_sblk 0x%x\n"
	.section	.rodata.gc_free_src_blk.str1.1,"aMS",@progbits,1
.LC63:
	.string	"gc_free_src_blk = %x, vpn = %d\n"
.LC64:
	.string	"gc_free_src_blk %x, %d\n"
	.section	.rodata.gc_free_temp_buf.str1.1,"aMS",@progbits,1
.LC49:
	.string	"%d gc_free_temp_buf buf id= %x\n"
	.section	.rodata.gc_mark_bad_ppa.str1.1,"aMS",@progbits,1
.LC46:
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
.LC51:
	.string	"zftl_get_gc_node cache = %x index = %d vpn = %x\n"
.LC52:
	.string	"gc_search_src_blk mode = %x, src mode = %x, count= %d %d\n"
	.section	.rodata.gc_static_wearleveling.str1.1,"aMS",@progbits,1
.LC79:
	.string	"gc_static_wearleveling: min blk: %x,sec=%d,xec = %d ,mode=%d, func=%x, bbt=%x vpn = %d\n"
.LC80:
	.string	"gc_static_wearleveling: min slc blk: %x,sec=%d,xec = %d ,mode=%d, func=%x, bbt=%x vpn = %d\n"
.LC81:
	.string	"gc_static_wearleveling: min tlc blk: %x,sec=%d,xec = %d ,mode=%d, func=%x, bbt=%x vpn = %d\n"
.LC82:
	.string	"gc_static_wearleveling: max slc blk: %x,sec=%d,xec = %d ,mode=%d, func=%x, bbt=%x vpn = %d\n"
.LC83:
	.string	"gc_static_wearleveling: max xlc blk: %x,sec=%d,xec = %d ,mode=%d, func=%x, bbt=%x vpn = %d\n"
.LC84:
	.string	"gc_static_wearleveling: slc blk: %x, tlc blk: %d avg slc ec: %d, avg tlc ec: %d \n"
.LC85:
	.string	"gc_static_wearleveling: min slc ec: %x, min tlc ec: %d max slc ec: %d, max tlc ec: %d; %d %d\n"
.LC86:
	.string	"swl add tlc gc = %x, %d, %d, %d, %d, %d\n"
.LC87:
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
.LC47:
	.string	"status: %x, ppa: %x\n"
.LC48:
	.string	"gc_write_completed: %x  %x  %d %x\n"
	.section	.rodata.hynix_get_read_retry_default.str1.1,"aMS",@progbits,1
.LC99:
	.string	"otp error! %d"
.LC100:
	.string	"rr"
	.section	.rodata.hynix_read_retrial.str1.1,"aMS",@progbits,1
.LC115:
	.string	"hynix RR %d row=%x, count %d, status=%d\n"
	.section	.rodata.idb_write_data.str1.1,"aMS",@progbits,1
.LC125:
	.string	"1 write_idblock fix data %x %x %x\n"
.LC126:
	.string	"write_idblock check fail! %x\n"
.LC127:
	.string	"write_idblock fail! %x\n"
	.section	.rodata.load_l2p_region.str1.1,"aMS",@progbits,1
.LC189:
	.string	"region_id = %d, pm_max_region = %d\n"
.LC190:
	.string	"load_l2p_region no ppa = %x , %x, all setting 0xff....\n"
.LC191:
	.string	"load_l2p_region = %x,%x,%x, %x\n"
.LC192:
	.string	"pm_ppa:"
.LC193:
	.string	"data:"
.LC194:
	.string	"spare:"
	.section	.rodata.lpa_rebuild_hash.str1.1,"aMS",@progbits,1
.LC78:
	.string	"%s %d %d\n"
	.section	.rodata.micron_read_retrial.str1.1,"aMS",@progbits,1
.LC110:
	.string	"MT %d row=%x,last status %d,status = %d\n"
.LC111:
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
	.string	"OptMode: %x\n"
.LC15:
	.string	"g_nand_max_die: %x\n"
.LC16:
	.string	"Cache read enable: %x\n"
.LC17:
	.string	"Cache random read enable: %x\n"
.LC18:
	.string	"Cache prog enable: %x\n"
.LC19:
	.string	"multi read enable: %x\n"
.LC20:
	.string	"multi prog enable: %x\n"
.LC21:
	.string	"interleave enable: %x\n"
.LC22:
	.string	"read retry enable: %x\n"
.LC23:
	.string	"randomizer enable: %x\n"
.LC24:
	.string	"SDR enable: %x\n"
.LC25:
	.string	"ONFI enable: %x\n"
.LC26:
	.string	"TOGGLE enable: %x\n"
.LC27:
	.string	"g_flash_slc_mode: %x %x\n"
.LC28:
	.string	"MultiPlaneProgCmd: %x %x\n"
.LC29:
	.string	"MultiPlaneReadCmd: %x %x\n"
.LC30:
	.string	"g_flash_toggle_mode_en: %x\n"
	.section	.rodata.nandc_init.str1.1,"aMS",@progbits,1
.LC92:
	.string	"...%s enter... %p\n"
.LC93:
	.string	"0:%x %x %x %x %x\n"
.LC94:
	.string	"g_nandc_ver...%d\n"
	.section	.rodata.nandc_xfer.str1.1,"aMS",@progbits,1
.LC106:
	.string	"dqs data abort %x\n"
.LC107:
	.string	"dqs data timeout %x\n"
.LC108:
	.string	"xfer error %x\n"
	.section	.rodata.nandc_xfer_done.str1.1,"aMS",@progbits,1
.LC101:
	.string	"flash_abort_clear = %d\n"
.LC102:
	.string	"%d mtrans_cnt = %d page_num = %d\n"
.LC103:
	.string	"nandc:"
.LC104:
	.string	"%d flReg.d32=%x %x\n"
.LC105:
	.string	"nandc_xfer_done read error %x\n"
	.section	.rodata.pm_alloc_new_blk.str1.1,"aMS",@progbits,1
.LC76:
	.string	"blk %x is bad block\n"
.LC77:
	.string	"pm_alloc_new_blk: %x %x %x %x\n"
	.section	.rodata.pm_free_sblk.str1.1,"aMS",@progbits,1
.LC89:
	.string	"GC PM block %x %x %x %d\n"
.LC90:
	.string	"ftl_free_no_use_map_blk %x %x %x %d\n"
	.section	.rodata.pm_init.str1.1,"aMS",@progbits,1
.LC195:
	.string	"pm_init posr %x %x %x\n"
.LC196:
	.string	"pm_init recovery %x %x %x\n"
.LC197:
	.string	"pm_init hash %x error\n"
	.section	.rodata.pm_log2phys.str1.1,"aMS",@progbits,1
.LC198:
	.string	"pm_log2phys  lpn = %d, max lpn = %d\n"
	.section	.rodata.pm_ppa_update_check.str1.1,"aMS",@progbits,1
.LC188:
	.string	"%s w error lpn = %x, max ppa = %d\n"
	.section	.rodata.pm_write_page.str1.1,"aMS",@progbits,1
.LC165:
	.string	"pm_write_page write error: %x\n"
	.section	.rodata.print_ftl_debug_info.str1.1,"aMS",@progbits,1
.LC65:
	.string	"bad blk = %x, %x free blk: s:%x,t:%x,m:%x, data blk:s:%x,%x,t%x vpn: s:%x t:%x, max_vpn: %x\n"
.LC66:
	.string	"totle w: %d MB,r: %d MB %d dv:0x%X,poc:%d\n"
.LC67:
	.string	"gc xlc page: %d,gc slc page: %d, tmp w: %d MB\n"
.LC68:
	.string	"slc ec: %d,%d,%d,%d,%d,tlc ec: %d,%d,%d,%d,%d\n"
.LC69:
	.string	"gc th: tlc_tlc: %d tlc_slc: %d slc_slc: %d slc_tlc:%d free_th: %d\n"
.LC70:
	.string	"swl : %x %x %x %x %x %x\n"
	.section	.rodata.print_gc_debug_info.str1.1,"aMS",@progbits,1
.LC50:
	.string	"gc: b:%x,p:%x,i:%x; free buf=%d %d free slc th: %d\n"
	.section	.rodata.print_list_info.str1.1,"aMS",@progbits,1
.LC57:
	.string	"list count:%p %d\n"
.LC58:
	.string	"%d: node:%x %x %x %x, %d %d %d %d %d\n"
	.section	.rodata.queue_wait_first_req_completed.str1.1,"aMS",@progbits,1
.LC131:
	.string	"read: %x %x %x %x\n"
.LC132:
	.string	"0set buf %d,status = %x, ppa = %x lun state = %d\n"
.LC133:
	.string	"prog end %x %x error_ecc %d %d\n"
.LC134:
	.string	"1set buf %d,status = %x, ppa = %x lun state = %d\n"
.LC135:
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
.LC95:
	.string	"%s 0x%x:"
.LC96:
	.string	"%x "
.LC97:
	.string	""
.LC98:
	.string	"%s\n"
	.section	.rodata.sandisk_prog_test_bad_block.str1.1,"aMS",@progbits,1
.LC40:
	.string	"bad block test:%x %x\n"
	.section	.rodata.sblk_3d_tlc_dump_prog.str1.1,"aMS",@progbits,1
.LC128:
	.string	"sblk_3d_tlc_dump_prog wl_addr= %x ppa = %x ppa = %x\n"
	.section	.rodata.sblk_mlc_dump_prog.str1.1,"aMS",@progbits,1
.LC129:
	.string	"sblk_mlc_dump_prog wl_addr= %x ppa = %x ppa = %x\n"
	.section	.rodata.sblk_prog_page.str1.1,"aMS",@progbits,1
.LC136:
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
.LC112:
	.string	"toshiba SRR %d row=%x, status=%d\n"
.LC113:
	.string	"toshiba TRR %d row=%x, status=%d\n"
.LC114:
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
.LC246:
	.string	"ftl_discard:(%x, %x, %x, %x)\n"
	.section	.rodata.zftl_do_gc.str1.1,"aMS",@progbits,1
.LC241:
	.string	"gc %d: %d %d %d %d %d %d %d\n"
.LC242:
	.string	"gc %d: %d %d %d %d %d %d\n"
.LC243:
	.string	"GC_STATE_SCAN_ALL_PAGE = %x, vpn0 = %d, vpn1 = %d\n"
.LC244:
	.string	"gc free %x, %d\n"
	.section	.rodata.zftl_gc_get_free_sblk.str1.1,"aMS",@progbits,1
.LC53:
	.string	"swl_tlc_free_mini_ec_blk alloc sblk %x\n"
.LC54:
	.string	"zftl_get_free_sblk %x %d, %p %d %d\n"
.LC55:
	.string	"zftl_gc_get_free_sblk %x %x %x, %d %d %d\n"
	.section	.rodata.zftl_get_free_sblk.str1.1,"aMS",@progbits,1
.LC56:
	.string	"swl_slc_free_mini_ec_blk alloc sblk %x\n"
	.section	.rodata.zftl_init.str1.1,"aMS",@progbits,1
.LC202:
	.string	"FTL version: 6.0.22 20200417"
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
.LC88:
	.string	"free blk vpn error: %x %x\n"
	.section	.rodata.zftl_write.str1.1,"aMS",@progbits,1
.LC245:
	.string	"ftlwrite %x %x %x %x\n"
	.hidden	free
